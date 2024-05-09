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
68 contract ExchangerV3 is Administered, tokenRecipient {
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
79     //The portion of the total supply that is not currently (e.g. not yet issued) or not ever (e.g. burned) in circulation
80     //The formula calculates prices based on a circulating supply which is: total supply - uncirculated supply - reserve supply (balance of exchanger)
81     uint256 public uncirculatedSupplyCount=0;
82     //Accounting for the fees
83     uint256 public collectedFees=0;
84     //If part of the ether reserve is stored offsite for security reasons this variable holds that value
85     uint256 public virtualReserveBalance=0;
86 
87     /** 
88         @dev Deploys an exchanger contract for a given token / Ether pairing
89         @param _token An ERC20 token
90         @param _weight The reserve fraction of this exchanger, in ppm
91         @param _formulaContract The contract with the algorithms to calculate price
92      */
93 
94     constructor(address _token, 
95                 uint32 _weight,
96                 address _formulaContract) {
97         require (_weight > 0 && weight <= 1000000);
98         
99         weight = _weight;
100         tokenContract = ITradeableAsset(_token);
101         formulaContract = IYeekFormula(_formulaContract);
102     }
103 
104     //Events raised on completion of buy and sell orders. 
105     //The web client can use this info to provide users with their trading history for a given token
106     //and also to notify when a trade has completed.
107 
108     event Buy(address indexed purchaser, uint256 amountInWei, uint256 amountInToken);
109     event Sell(address indexed seller, uint256 amountInToken, uint256 amountInWei);
110 
111     /**
112      @dev Deposit tokens to the reserve.
113      */
114     function depositTokens(uint amount) onlyOwner public {
115         tokenContract.transferFrom(msg.sender, this, amount);
116     }
117         
118     /**
119     @dev Deposit ether to the reserve
120     */
121     function depositEther() onlyOwner public payable {
122     //return getQuotePrice(); 
123     }
124 
125     /**  
126      @dev Withdraw tokens from the reserve
127      */
128     function withdrawTokens(uint amount) onlyOwner public {
129         tokenContract.transfer(msg.sender, amount);
130     }
131 
132     /**  
133      @dev Withdraw ether from the reserve
134      */
135     function withdrawEther(uint amountInWei) onlyOwner public {
136         msg.sender.transfer(amountInWei); //Transfers in wei
137     }
138 
139     /**
140      @dev Withdraw accumulated fees, without disturbing the core reserve
141      */
142     function extractFees(uint amountInWei) onlyAdmin public {
143         require (amountInWei <= collectedFees);
144         msg.sender.transfer(amountInWei);
145     }
146 
147     /**
148      @dev Enable trading
149      */
150     function enable() onlyAdmin public {
151         enabled = true;
152     }
153 
154      /**
155       @dev Disable trading
156      */
157     function disable() onlyAdmin public {
158         enabled = false;
159     }
160 
161      /**
162       @dev Play central banker and set the fractional reserve ratio, from 1 to 1000000 ppm.
163       It is highly disrecommended to do this while trading is enabled! Obviously this should 
164       only be done in combination with a matching deposit or withdrawal of ether, 
165       and I'll enforce it at a later point.
166      */
167     function setReserveWeight(uint ppm) onlyAdmin public {
168         require (ppm>0 && ppm<=1000000);
169         weight = uint32(ppm);
170     }
171 
172     function setFee(uint ppm) onlyAdmin public {
173         require (ppm >= 0 && ppm <= 1000000);
174         fee = uint32(ppm);
175     }
176 
177     /* The number of tokens that are burned, unissued, or otherwise not in circulation */
178     function setUncirculatedSupplyCount(uint newValue) onlyAdmin public {
179         require (newValue > 0);
180         uncirculatedSupplyCount = uint256(newValue);
181     }
182 
183     /**
184      * The virtual reserve balance set here is added on to the actual ethereum balance of this contract
185      * when calculating price for buy/sell. Note that if you have no real ether in the reserve, you will 
186      * not have liquidity for sells until you have some buys first.
187      */
188     function setVirtualReserveBalance(uint256 amountInWei) onlyAdmin public {
189         virtualReserveBalance = amountInWei;
190     }
191 
192     //These methods return information about the exchanger, and the buy / sell rates offered on the Token / ETH pairing.
193     //They can be called without gas from any client.
194 
195     /**  
196      @dev Audit the reserve balances, in the base token and in ether
197      returns: [token balance, ether balance - ledger]
198      */
199     function getReserveBalances() public view returns (uint256, uint256) {
200         return (tokenContract.balanceOf(this), address(this).balance+virtualReserveBalance);
201     }
202 
203 
204     /**
205      @dev Get the BUY price based on the order size. Returned as the number of tokens that the amountInWei will buy.
206      */
207     function getPurchasePrice(uint256 amountInWei) public view returns(uint) {
208         uint256 purchaseReturn = formulaContract.calculatePurchaseReturn(
209             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
210             address(this).balance + virtualReserveBalance,
211             weight,
212             amountInWei 
213         ); 
214 
215         purchaseReturn = (purchaseReturn - ((purchaseReturn * fee) / 1000000));
216 
217         if (purchaseReturn > tokenContract.balanceOf(this)){
218             return tokenContract.balanceOf(this);
219         }
220         return purchaseReturn;
221     }
222 
223     /**
224      @dev Get the SELL price based on the order size. Returned as amount (in wei) that you'll get for your tokens.
225      */
226     function getSalePrice(uint256 tokensToSell) public view returns(uint) {
227         uint256 saleReturn = formulaContract.calculateSaleReturn(
228             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
229             address(this).balance + virtualReserveBalance,
230             weight,
231             tokensToSell 
232         ); 
233         saleReturn = (saleReturn - ((saleReturn * fee) / 1000000));
234         if (saleReturn > address(this).balance) {
235             return address(this).balance;
236         }
237         return saleReturn;
238     }
239 
240     //buy and sell execute live trades against the exchanger. For either method, 
241     //you must specify your minimum return (in total tokens or ether that you expect to receive for your trade)
242     //this protects the trader against slippage due to other orders that make it into earlier blocks after they 
243     //place their order. 
244     //
245     //With buy, send the amount of ether you want to spend on the token - you'll get it back immediately if minPurchaseReturn
246     //is not met or if this Exchanger is not in a condition to service your order (usually this happens when there is not a full 
247     //reserve of tokens to satisfy the stated weight)
248     //
249     //With sell, first approve the exchanger to spend the number of tokens you want to sell
250     //Then call sell with that number and your minSaleReturn. The token transfer will not happen 
251     //if the minSaleReturn is not met.
252     //
253     //Sales always go through, as long as there is any ether in the reserve... but those dumping massive quantities of tokens
254     //will naturally be given the shittest rates.
255 
256     /**
257      @dev Buy tokens with ether. 
258      @param minPurchaseReturn The minimum number of tokens you will accept.
259      */
260     function buy(uint minPurchaseReturn) public payable {
261         uint amount = formulaContract.calculatePurchaseReturn(
262             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
263             (address(this).balance + virtualReserveBalance) - msg.value,
264             weight,
265             msg.value);
266         amount = (amount - ((amount * fee) / 1000000));
267         
268         //Now do the trade if conditions are met
269         require (enabled); // ADDED SEMICOLON    
270         require (amount >= minPurchaseReturn);
271         require (tokenContract.balanceOf(this) >= amount);
272         
273         //Accounting - so we can pull the fees out without changing the balance
274         collectedFees += (msg.value * fee) / 1000000;
275 
276         emit Buy(msg.sender, msg.value, amount);
277         tokenContract.transfer(msg.sender, amount);
278     }
279     /**
280      @dev Sell tokens for ether
281      @param quantity Number of tokens to sell
282      @param minSaleReturn Minimum amount of ether (in wei) you will accept for your tokens
283      */
284     function sell(uint quantity, uint minSaleReturn) public {
285         uint amountInWei = formulaContract.calculateSaleReturn(
286             (tokenContract.totalSupply()- uncirculatedSupplyCount) - tokenContract.balanceOf(this),
287              address(this).balance + virtualReserveBalance,
288              weight,
289              quantity
290         );
291         amountInWei = (amountInWei - ((amountInWei * fee) / 1000000));
292 
293         require (enabled); // ADDED SEMICOLON
294         require (amountInWei >= minSaleReturn);
295         require (amountInWei <= address(this).balance);
296         require (tokenContract.transferFrom(msg.sender, this, quantity));
297 
298         collectedFees += (amountInWei * fee) / 1000000;
299 
300         emit Sell(msg.sender, quantity, amountInWei);
301         msg.sender.transfer(amountInWei); //Always send ether last
302     }
303 
304 
305     //approveAndCall flow for selling entry point
306     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external {
307         //not needed: if it was the wrong token, the tx fails anyways require(_token == address(tokenContract));
308         sellOneStep(_value, 0, _from);
309     }
310     
311 
312     //Variant of sell for one step ordering. The seller calls approveAndCall on the token
313     //which calls receiveApproval above, which calls this funciton
314     function sellOneStep(uint quantity, uint minSaleReturn, address seller) public {
315         uint amountInWei = formulaContract.calculateSaleReturn(
316             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
317              address(this).balance + virtualReserveBalance,
318              weight,
319              quantity
320         );
321         amountInWei = (amountInWei - ((amountInWei * fee) / 1000000));
322         
323         require (enabled); // ADDED SEMICOLON
324         require (amountInWei >= minSaleReturn);
325         require (amountInWei <= address(this).balance);
326         require (tokenContract.transferFrom(seller, this, quantity));
327 
328         collectedFees += (amountInWei * fee) / 1000000;
329 
330 
331         emit Sell(seller, quantity, amountInWei);
332         seller.transfer(amountInWei); //Always send ether last
333     }
334 
335 }