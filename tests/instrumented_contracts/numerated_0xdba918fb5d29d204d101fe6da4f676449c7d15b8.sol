1 pragma solidity ^0.4.24;
2 interface IExchangeFormula {
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
25     constructor() public {
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
68 contract ExchangerV4 is Administered, tokenRecipient {
69     bool public enabled = false;    //Owner can turn off and on
70 
71     //The token which is being bought and sold
72     ITradeableAsset public tokenContract;
73     //The contract that does the calculations to determine buy and sell pricing
74     IExchangeFormula public formulaContract;
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
86     //Prevent the eth balance to be lover than a set value
87     //The min Eth reserve amount
88     uint256 public minReserve=0; //
89 
90     /** 
91         @dev Deploys an exchanger contract for a given token / Ether pairing
92         @param _token An ERC20 token
93         @param _weight The reserve fraction of this exchanger, in ppm
94         @param _formulaContract The contract with the algorithms to calculate price
95      */
96 
97     constructor(address _token, 
98                 uint32 _weight,
99                 address _formulaContract) {
100         require (_weight > 0 && weight <= 1000000);
101         
102         weight = _weight;
103         tokenContract = ITradeableAsset(_token);
104         formulaContract = IExchangeFormula(_formulaContract);
105     }
106 
107     //Events raised on completion of buy and sell orders. 
108     //The web client can use this info to provide users with their trading history for a given token
109     //and also to notify when a trade has completed.
110 
111     event Buy(address indexed purchaser, uint256 amountInWei, uint256 amountInToken);
112     event Sell(address indexed seller, uint256 amountInToken, uint256 amountInWei);
113 
114     /**
115      @dev Deposit tokens to the reserve.
116      */
117     function depositTokens(uint amount) onlyOwner public {
118         tokenContract.transferFrom(msg.sender, this, amount);
119     }
120         
121     /**
122     @dev Deposit ether to the reserve
123     */
124     function depositEther() onlyOwner public payable {
125     //return getQuotePrice(); 
126     }
127 
128     /**  
129      @dev Withdraw tokens from the reserve
130      */
131     function withdrawTokens(uint amount) onlyOwner public {
132         tokenContract.transfer(msg.sender, amount);
133     }
134 
135     /**  
136      @dev Withdraw ether from the reserve
137      */
138     function withdrawEther(uint amountInWei) onlyOwner public {
139         msg.sender.transfer(amountInWei); //Transfers in wei
140     }
141 
142     /**
143      @dev Withdraw accumulated fees, without disturbing the core reserve
144      */
145     function extractFees(uint amountInWei) onlyAdmin public {
146         require (amountInWei <= collectedFees);
147         msg.sender.transfer(amountInWei);
148     }
149 
150     /**
151      @dev Enable trading
152      */
153     function enable() onlyAdmin public {
154         enabled = true;
155     }
156 
157      /**
158       @dev Disable trading
159      */
160     function disable() onlyAdmin public {
161         enabled = false;
162     }
163 
164      /**
165       @dev Play central banker and set the fractional reserve ratio, from 1 to 1000000 ppm.
166       It is highly disrecommended to do this while trading is enabled! Obviously this should 
167       only be done in combination with a matching deposit or withdrawal of ether, 
168       and I'll enforce it at a later point.
169      */
170     function setReserveWeight(uint ppm) onlyAdmin public {
171         require (ppm>0 && ppm<=1000000);
172         weight = uint32(ppm);
173     }
174 
175     function setFee(uint ppm) onlyAdmin public {
176         require (ppm >= 0 && ppm <= 1000000);
177         fee = uint32(ppm);
178     }
179 
180     /* The number of tokens that are burned, unissued, or otherwise not in circulation */
181     function setUncirculatedSupplyCount(uint newValue) onlyAdmin public {
182         require (newValue > 0);
183         uncirculatedSupplyCount = uint256(newValue);
184     }
185 
186     /**
187      * The virtual reserve balance set here is added on to the actual ethereum balance of this contract
188      * when calculating price for buy/sell. Note that if you have no real ether in the reserve, you will 
189      * not have liquidity for sells until you have some buys first.
190      */
191     function setVirtualReserveBalance(uint256 amountInWei) onlyAdmin public {
192         virtualReserveBalance = amountInWei;
193     }
194     
195     function setMinReserve(uint256 amountInWei) onlyAdmin public {
196         minReserve = amountInWei;
197     }     
198 
199     //These methods return information about the exchanger, and the buy / sell rates offered on the Token / ETH pairing.
200     //They can be called without gas from any client.
201 
202     /**  
203      @dev Audit the reserve balances, in the base token and in ether
204      returns: [token balance, ether balance - ledger]
205      */
206     function getReserveBalances() public view returns (uint256, uint256) {
207         return (tokenContract.balanceOf(this), address(this).balance+virtualReserveBalance);
208     }
209 
210     /**
211      @dev Get the BUY price based on the order size. Returned as the number of tokens that the amountInWei will buy.
212      */
213     function getPurchasePrice(uint256 amountInWei) public view returns(uint) {
214         uint256 purchaseReturn = formulaContract.calculatePurchaseReturn(
215             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
216             address(this).balance + virtualReserveBalance,
217             weight,
218             amountInWei 
219         ); 
220 
221         purchaseReturn = (purchaseReturn - ((purchaseReturn * fee) / 1000000));
222 
223         if (purchaseReturn > tokenContract.balanceOf(this)){
224             return tokenContract.balanceOf(this);
225         }
226         return purchaseReturn;
227     }
228 
229     /**
230      @dev Get the SELL price based on the order size. Returned as amount (in wei) that you'll get for your tokens.
231      */
232     function getSalePrice(uint256 tokensToSell) public view returns(uint) {
233         uint256 saleReturn = formulaContract.calculateSaleReturn(
234             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
235             address(this).balance + virtualReserveBalance,
236             weight,
237             tokensToSell 
238         ); 
239         saleReturn = (saleReturn - ((saleReturn * fee) / 1000000));
240         if (saleReturn > address(this).balance) {
241             return address(this).balance;
242         }
243         return saleReturn;
244     }
245 
246     //buy and sell execute live trades against the exchanger. For either method, 
247     //you must specify your minimum return (in total tokens or ether that you expect to receive for your trade)
248     //this protects the trader against slippage due to other orders that make it into earlier blocks after they 
249     //place their order. 
250     //
251     //With buy, send the amount of ether you want to spend on the token - you'll get it back immediately if minPurchaseReturn
252     //is not met or if this Exchanger is not in a condition to service your order (usually this happens when there is not a full 
253     //reserve of tokens to satisfy the stated weight)
254     //
255     //With sell, first approve the exchanger to spend the number of tokens you want to sell
256     //Then call sell with that number and your minSaleReturn. The token transfer will not happen 
257     //if the minSaleReturn is not met.
258     //
259     //Sales always go through, as long as there is any ether in the reserve... but those dumping massive quantities of tokens
260     //will naturally be given the shittest rates.
261 
262     /**
263      @dev Buy tokens with ether. 
264      @param minPurchaseReturn The minimum number of tokens you will accept.
265      */
266     function buy(uint minPurchaseReturn) public payable {
267         uint amount = formulaContract.calculatePurchaseReturn(
268             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
269             (address(this).balance + virtualReserveBalance) - msg.value,
270             weight,
271             msg.value);
272         amount = (amount - ((amount * fee) / 1000000));
273         
274         //Now do the trade if conditions are met
275         require (enabled); // ADDED SEMICOLON    
276         require (amount >= minPurchaseReturn);
277         require (tokenContract.balanceOf(this) >= amount);
278         
279         //Accounting - so we can pull the fees out without changing the balance
280         collectedFees += (msg.value * fee) / 1000000;
281         
282         emit Buy(msg.sender, msg.value, amount);
283         tokenContract.transfer(msg.sender, amount);
284     }
285     
286     /**
287      @dev Sell tokens for ether
288      @param quantity Number of tokens to sell
289      @param minSaleReturn Minimum amount of ether (in wei) you will accept for your tokens
290      */
291     function sell(uint quantity, uint minSaleReturn) public {
292         uint amountInWei = formulaContract.calculateSaleReturn(
293             (tokenContract.totalSupply()- uncirculatedSupplyCount) - tokenContract.balanceOf(this),
294              address(this).balance + virtualReserveBalance,
295              weight,
296              quantity
297         );
298         amountInWei = (amountInWei - ((amountInWei * fee) / 1000000));
299 
300         require (enabled); // ADDED SEMICOLON
301         require (amountInWei >= minSaleReturn);
302         require (amountInWei <= address(this).balance);
303         require (address(this).balance - amountInWei > minReserve);
304         require (tokenContract.transferFrom(msg.sender, this, quantity));
305 
306         collectedFees += (amountInWei * fee) / 1000000;
307 
308         emit Sell(msg.sender, quantity, amountInWei);
309         msg.sender.transfer(amountInWei); //Always send ether last
310     }
311 
312     //approveAndCall flow for selling entry point
313     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external {
314         //not needed: if it was the wrong token, the tx fails anyways require(_token == address(tokenContract));
315         sellOneStep(_value, 0, _from);
316     }    
317 
318     //Variant of sell for one step ordering. The seller calls approveAndCall on the token
319     //which calls receiveApproval above, which calls this funciton
320     function sellOneStep(uint quantity, uint minSaleReturn, address seller) public {
321         uint amountInWei = formulaContract.calculateSaleReturn(
322             (tokenContract.totalSupply() - uncirculatedSupplyCount) - tokenContract.balanceOf(this),
323              address(this).balance + virtualReserveBalance,
324              weight,
325              quantity
326         );
327         amountInWei = (amountInWei - ((amountInWei * fee) / 1000000));
328         
329         require (enabled); // ADDED SEMICOLON
330         require (amountInWei >= minSaleReturn);
331         require (amountInWei <= address(this).balance);
332         require (address(this).balance - amountInWei > minReserve);
333         require (tokenContract.transferFrom(seller, this, quantity));
334 
335         collectedFees += (amountInWei * fee) / 1000000;
336 
337 
338         emit Sell(seller, quantity, amountInWei);
339         seller.transfer(amountInWei); //Always send ether last
340     }
341 
342 }