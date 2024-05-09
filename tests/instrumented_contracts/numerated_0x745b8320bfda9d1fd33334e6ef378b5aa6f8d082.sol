1 pragma solidity ^0.4.18;
2 interface IYeekFormula {
3     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) external view returns (uint256);
4     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) external view returns (uint256);
5 }
6 
7 interface ITradeableAsset {
8     function totalSupply() external view returns (uint256);
9     function approve(address spender, uint tokens) external returns (bool success);
10     function transferFrom(address from, address to, uint tokens) external returns (bool success);
11     function decimals() external view returns (uint256);
12     function transfer(address _to, uint256 _value) external;
13     function balanceOf(address _address) external view returns (uint256);
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
17 
18 /* A basic permissions hierarchy (Owner -> Admin -> Everyone else). One owner may appoint and remove any number of admins
19    and may transfer ownership to another individual address */
20 contract Administered {
21     address public creator;
22 
23     mapping (address => bool) public admins;
24     
25     constructor()  public {
26         creator = msg.sender;
27         admins[creator] = true;
28     }
29 
30     //Restrict to the current owner. There may be only 1 owner at a time, but 
31     //ownership can be transferred.
32     modifier onlyOwner {
33         require(creator == msg.sender);
34         _;
35     }
36     
37     //Restrict to any admin. Not sufficient for highly sensitive methods
38     //since basic admin can be granted programatically regardless of msg.sender
39     modifier onlyAdmin {
40         require(admins[msg.sender] || creator == msg.sender);
41         _;
42     }
43 
44     //Add an admin with basic privileges. Can be done by any superuser (or the owner)
45     function grantAdmin(address newAdmin) onlyOwner  public {
46         _grantAdmin(newAdmin);
47     }
48 
49     function _grantAdmin(address newAdmin) internal
50     {
51         admins[newAdmin] = true;
52     }
53 
54     //Transfer ownership
55     function changeOwner(address newOwner) onlyOwner public {
56         creator = newOwner;
57     }
58 
59     //Remove an admin
60     function revokeAdminStatus(address user) onlyOwner public {
61         admins[user] = false;
62     }
63 }
64 
65 /* A liqudity pool that executes buy and sell orders for an ETH / Token Pair */
66 /* The owner deploys it and then adds tokens / ethereum in the desired ratio */
67 
68 contract ExchangerV2 is Administered, tokenRecipient {
69     bool public enabled = false;    //Owner can turn off and on
70 
71     //The token which is being bought and sold
72     ITradeableAsset public tokenContract;
73     //The contract that does the calculations to determine buy and sell pricing
74     IYeekFormula public formulaContract;
75     //The reserve pct of this exchanger, expressed in ppm
76     uint32 public weight;
77     //The fee, in ppm
78     uint32 public fee=5000; //0.5%
79     //issuedSupplyRatio - for use in early offerings where a majority of the tokens have not yet been issued.
80     //The issued supply is calculated as: token.totalSupply / issuedSupplyRatio
81     //Example: you have minuted 2mil tokens, sold / gave away 40k in an ICO, and 10k are stored here as a liqudity reserve
82     //Since only 50k total coins have been issued, the issuedSupplyRatio should be set to 40 (2mil / 40 = 50k)
83     uint32 public issuedSupplyRatio=1;
84     //Accounting for the fees
85     uint256 public collectedFees=0;
86     //If part of the ether reserve is stored offsite for security reasons this variable holds that value
87     uint256 public virtualReserveBalance=0;
88 
89     /** 
90         @dev Deploys an exchanger contract for a given token / Ether pairing
91         @param _token An ERC20 token
92         @param _weight The reserve fraction of this exchanger, in ppm
93         @param _formulaContract The contract with the algorithms to calculate price
94      */
95 
96     constructor(address _token, 
97                 uint32 _weight,
98                 address _formulaContract) {
99         require (_weight > 0 && weight <= 1000000);
100         
101         weight = _weight;
102         tokenContract = ITradeableAsset(_token);
103         formulaContract = IYeekFormula(_formulaContract);
104     }
105 
106     //Events raised on completion of buy and sell orders. 
107     //The web client can use this info to provide users with their trading history for a given token
108     //and also to notify when a trade has completed.
109 
110     event Buy(address indexed purchaser, uint256 amountInWei, uint256 amountInToken);
111     event Sell(address indexed seller, uint256 amountInToken, uint256 amountInWei);
112 
113     /**
114      @dev Deposit tokens to the reserve.
115      */
116     function depositTokens(uint amount) onlyOwner public {
117         tokenContract.transferFrom(msg.sender, this, amount);
118     }
119         
120     /**
121     @dev Deposit ether to the reserve
122     */
123     function depositEther() onlyOwner public payable {
124     //return getQuotePrice(); 
125     }
126 
127     /**  
128      @dev Withdraw tokens from the reserve
129      */
130     function withdrawTokens(uint amount) onlyOwner public {
131         tokenContract.transfer(msg.sender, amount);
132     }
133 
134     /**  
135      @dev Withdraw ether from the reserve
136      */
137     function withdrawEther(uint amountInWei) onlyOwner public {
138         msg.sender.transfer(amountInWei); //Transfers in wei
139     }
140 
141     /**
142      @dev Withdraw accumulated fees, without disturbing the core reserve
143      */
144     function extractFees(uint amountInWei) onlyAdmin public {
145         require (amountInWei <= collectedFees);
146         msg.sender.transfer(amountInWei);
147     }
148 
149     /**
150      @dev Enable trading
151      */
152     function enable() onlyAdmin public {
153         enabled = true;
154     }
155 
156      /**
157       @dev Disable trading
158      */
159     function disable() onlyAdmin public {
160         enabled = false;
161     }
162 
163      /**
164       @dev Play central banker and set the fractional reserve ratio, from 1 to 1000000 ppm.
165       It is highly disrecommended to do this while trading is enabled! Obviously this should 
166       only be done in combination with a matching deposit or withdrawal of ether, 
167       and I'll enforce it at a later point.
168      */
169     function setReserveWeight(uint ppm) onlyAdmin public {
170         require (ppm>0 && ppm<=1000000);
171         weight = uint32(ppm);
172     }
173 
174     function setFee(uint ppm) onlyAdmin public {
175         require (ppm >= 0 && ppm <= 1000000);
176         fee = uint32(ppm);
177     }
178 
179     function setissuedSupplyRatio(uint newValue) onlyAdmin public {
180         require (newValue > 0);
181         issuedSupplyRatio = uint32(newValue);
182     }
183 
184     /**
185      * The virtual reserve balance set here is added on to the actual ethereum balance of this contract
186      * when calculating price for buy/sell. Note that if you have no real ether in the reserve, you will 
187      * not have liquidity for sells until you have some buys first.
188      */
189     function setVirtualReserveBalance(uint256 amountInWei) onlyAdmin public {
190         virtualReserveBalance = amountInWei;
191     }
192 
193     //These methods return information about the exchanger, and the buy / sell rates offered on the Token / ETH pairing.
194     //They can be called without gas from any client.
195 
196     /**  
197      @dev Audit the reserve balances, in the base token and in ether
198      returns: [token balance, ether balance - ledger]
199      */
200     function getReserveBalances() public view returns (uint256, uint256) {
201         return (tokenContract.balanceOf(this), address(this).balance+virtualReserveBalance);
202     }
203 
204 
205     /**
206      @dev Gets price based on a sample 1 ether BUY order
207      */
208      /*
209     function getQuotePrice() public view returns(uint) {
210         uint tokensPerEther = 
211         formulaContract.calculatePurchaseReturn(
212             (tokenContract.totalSupply() - tokenContract.balanceOf(this)) * issuedSupplyRatio,
213             address(this).balance,
214             weight,
215             1 ether 
216         ); 
217 
218         return tokensPerEther;
219     }*/
220 
221     /**
222      @dev Get the BUY price based on the order size. Returned as the number of tokens that the amountInWei will buy.
223      */
224     function getPurchasePrice(uint256 amountInWei) public view returns(uint) {
225         uint256 purchaseReturn = formulaContract.calculatePurchaseReturn(
226             (tokenContract.totalSupply() / issuedSupplyRatio) - tokenContract.balanceOf(this),
227             address(this).balance + virtualReserveBalance,
228             weight,
229             amountInWei 
230         ); 
231 
232         purchaseReturn = (purchaseReturn - ((purchaseReturn * fee) / 1000000));
233 
234         if (purchaseReturn > tokenContract.balanceOf(this)){
235             return tokenContract.balanceOf(this);
236         }
237         return purchaseReturn;
238     }
239 
240     /**
241      @dev Get the SELL price based on the order size. Returned as amount (in wei) that you'll get for your tokens.
242      */
243     function getSalePrice(uint256 tokensToSell) public view returns(uint) {
244         uint256 saleReturn = formulaContract.calculateSaleReturn(
245             (tokenContract.totalSupply() / issuedSupplyRatio) - tokenContract.balanceOf(this),
246             address(this).balance + virtualReserveBalance,
247             weight,
248             tokensToSell 
249         ); 
250         saleReturn = (saleReturn - ((saleReturn * fee) / 1000000));
251         if (saleReturn > address(this).balance) {
252             return address(this).balance;
253         }
254         return saleReturn;
255     }
256 
257     //buy and sell execute live trades against the exchanger. For either method, 
258     //you must specify your minimum return (in total tokens or ether that you expect to receive for your trade)
259     //this protects the trader against slippage due to other orders that make it into earlier blocks after they 
260     //place their order. 
261     //
262     //With buy, send the amount of ether you want to spend on the token - you'll get it back immediately if minPurchaseReturn
263     //is not met or if this Exchanger is not in a condition to service your order (usually this happens when there is not a full 
264     //reserve of tokens to satisfy the stated weight)
265     //
266     //With sell, first approve the exchanger to spend the number of tokens you want to sell
267     //Then call sell with that number and your minSaleReturn. The token transfer will not happen 
268     //if the minSaleReturn is not met.
269     //
270     //Sales always go through, as long as there is any ether in the reserve... but those dumping massive quantities of tokens
271     //will naturally be given the shittest rates.
272 
273     /**
274      @dev Buy tokens with ether. 
275      @param minPurchaseReturn The minimum number of tokens you will accept.
276      */
277     function buy(uint minPurchaseReturn) public payable {
278         uint amount = formulaContract.calculatePurchaseReturn(
279             (tokenContract.totalSupply() / issuedSupplyRatio) - tokenContract.balanceOf(this),
280             (address(this).balance + virtualReserveBalance) - msg.value,
281             weight,
282             msg.value);
283         amount = (amount - ((amount * fee) / 1000000));
284         
285         //Now do the trade if conditions are met
286         require (enabled); // ADDED SEMICOLON    
287         require (amount >= minPurchaseReturn);
288         require (tokenContract.balanceOf(this) >= amount);
289         
290         //Accounting - so we can pull the fees out without changing the balance
291         collectedFees += (msg.value * fee) / 1000000;
292 
293         emit Buy(msg.sender, msg.value, amount);
294         tokenContract.transfer(msg.sender, amount);
295     }
296     /**
297      @dev Sell tokens for ether
298      @param quantity Number of tokens to sell
299      @param minSaleReturn Minimum amount of ether (in wei) you will accept for your tokens
300      */
301     function sell(uint quantity, uint minSaleReturn) public {
302         uint amountInWei = formulaContract.calculateSaleReturn(
303             (tokenContract.totalSupply() / issuedSupplyRatio) - tokenContract.balanceOf(this),
304              address(this).balance + virtualReserveBalance,
305              weight,
306              quantity
307         );
308         amountInWei = (amountInWei - ((amountInWei * fee) / 1000000));
309 
310         require (enabled); // ADDED SEMICOLON
311         require (amountInWei >= minSaleReturn);
312         require (amountInWei <= address(this).balance);
313         require (tokenContract.transferFrom(msg.sender, this, quantity));
314 
315         collectedFees += (amountInWei * fee) / 1000000;
316 
317         emit Sell(msg.sender, quantity, amountInWei);
318         msg.sender.transfer(amountInWei); //Always send ether last
319     }
320 
321 
322     //approveAndCall flow for selling entry point
323     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external {
324         //not needed: if it was the wrong token, the tx fails anyways require(_token == address(tokenContract));
325         sellOneStep(_value, 0, _from);
326     }
327     
328 
329     //Variant of sell for one step ordering. The seller calls approveAndCall on the token
330     //which calls receiveApproval above, which calls this funciton
331     function sellOneStep(uint quantity, uint minSaleReturn, address seller) public {
332         uint amountInWei = formulaContract.calculateSaleReturn(
333             (tokenContract.totalSupply() / issuedSupplyRatio) - tokenContract.balanceOf(this),
334              address(this).balance + virtualReserveBalance,
335              weight,
336              quantity
337         );
338         amountInWei = (amountInWei - ((amountInWei * fee) / 1000000));
339         
340         require (enabled); // ADDED SEMICOLON
341         require (amountInWei >= minSaleReturn);
342         require (amountInWei <= address(this).balance);
343         require (tokenContract.transferFrom(seller, this, quantity));
344 
345         collectedFees += (amountInWei * fee) / 1000000;
346 
347 
348         emit Sell(seller, quantity, amountInWei);
349         seller.transfer(amountInWei); //Always send ether last
350     }
351 
352 }