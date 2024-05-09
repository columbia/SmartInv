1 pragma solidity 0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 // ERC Token Standard #20 Interface
6 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
7 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
8 // 
9 // ----------------------------------------------------------------------------
10 contract ERC20Interface {
11     function totalSupply() public view returns (uint256);
12     function balanceOf(address who) public view returns (uint256);
13     function allowance(address approver, address spender) public view returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     function approve(address spender, uint256 value) public returns (bool);
16     function transferFrom(address from, address to, uint256 value) public returns (bool);
17 
18     // solhint-disable-next-line no-simple-event-func-name
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed approver, address indexed spender, uint256 value);
21 }
22 
23 
24 
25 //
26 // base contract for all our horizon contracts and tokens
27 //
28 contract HorizonContractBase {
29     // The owner of the contract, set at contract creation to the creator.
30     address public owner;
31 
32     constructor() public {
33         owner = msg.sender;
34     }
35 
36     // Contract authorization - only allow the owner to perform certain actions.
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 }
42 
43 
44 
45 
46  
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  *
52  * Source: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
53  */
54 library SafeMath {
55     /**
56      * @dev Multiplies two numbers, throws on overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62         uint256 c = a * b;
63         assert(c / a == b);
64         return c;
65     }
66 
67     /**
68     * @dev Integer division of two numbers, truncating the quotient.
69     */
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         // assert(b > 0); // Solidity automatically throws when dividing by 0
72         // uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74         return a / b;
75     }
76 
77     /**
78     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
79     */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         assert(b <= a);
82         return a - b;
83     }
84 
85     /**
86     * @dev Adds two numbers, throws on overflow.
87     */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         assert(c >= a);
91         return c;
92     }
93 }
94 
95 
96 /**
97  * VOXToken trader contract for the Talketh.io ICO by Horizon-Globex.com of Switzerland.
98  *
99  * Author: Horizon Globex GmbH Development Team
100  *
101  */
102 
103 
104 contract VOXTrader is HorizonContractBase {
105     using SafeMath for uint256;
106 
107     struct TradeOrder {
108         uint256 quantity;
109         uint256 price;
110         uint256 expiry;
111     }
112 
113     // The owner of this contract.
114     address public owner;
115 
116     // The balances of all accounts.
117     mapping (address => TradeOrder) public orderBook;
118 
119     // The contract containing the tokens that we trade.
120     address public tokenContract;
121 
122     // The price paid for the last sale of tokens on this contract.
123     uint256 public lastSellPrice;
124 
125     // The lowest price an asks can be placed.
126     uint256 public sellCeiling;
127 
128     // The highest price an ask can be placed.
129     uint256 public sellFloor;
130 
131     // The percentage taken off transferred tokens during a buy.
132     uint256 public tokenFeePercent;
133     
134     // The minimum fee when buying tokens (if the calculated percent is less than this value);
135     uint256 public tokenFeeMin;
136     
137     // The percentage taken off the cost of buying tokens in Ether.
138     uint256 public etherFeePercent;
139     
140     // The minimum Ether fee when buying tokens (if the calculated percent is less than this value);
141     uint256 public etherFeeMin;
142 
143     // A sell order was put into the order book.
144     event TokensOffered(address indexed who, uint256 quantity, uint256 price, uint256 expiry);
145 
146     // A user bought tokens from another user.
147     event TokensPurchased(address indexed purchaser, address indexed seller, uint256 quantity, uint256 price);
148 
149     // A user bought phone credit using a top-up voucher, buy VOX Tokens on thier behalf to convert to phone credit.
150     event VoucherRedeemed(uint256 voucherCode, address voucherOwner, address tokenSeller, uint256 quantity);
151 
152 
153     /**
154      * @notice Set owner and the target ERC20 contract containing the tokens it trades.
155      *
156      * @param tokenContract_    The ERC20 contract whose tokens this contract trades.
157      */
158     constructor(address tokenContract_) public {
159         owner = msg.sender;
160         tokenContract = tokenContract_;
161     }
162 
163     /**
164      * @notice Get the trade order for the specified address.
165      *
166      * @param who    The address to get the trade order of.
167      */
168     function getOrder(address who) public view returns (uint256 quantity, uint256 price, uint256 expiry) {
169         TradeOrder memory order = orderBook[who];
170         return (order.quantity, order.price, order.expiry);
171     }
172 
173     /**
174      * @notice Offer tokens for sale, you must call approve on the ERC20 contract first, giving approval to
175      * the address of this contract.
176      *
177      * @param quantity  The number of tokens to offer for sale.
178      * @param price     The unit price of the tokens.
179      * @param expiry    The date and time this order ends.
180      */
181     function sell(uint256 quantity, uint256 price, uint256 expiry) public {
182         require(quantity > 0, "You must supply a quantity.");
183         require(price > 0, "The sale price cannot be zero.");
184         require(expiry > block.timestamp, "Cannot have an expiry date in the past.");
185         require(price >= sellFloor, "The ask is below the minimum allowed.");
186         require(sellCeiling == 0 || price <= sellCeiling, "The ask is above the maximum allowed.");
187 		//require(!willLosePrecision(quantity), "The ask quantity will lose precision when multiplied by price, the bottom 9 digits must be zeroes.");
188 		//require(!willLosePrecision(price), "The ask price will lose precision when multiplied by quantity, the bottom 9 digits must be zeroes.");
189 
190         uint256 allowed = ERC20Interface(tokenContract).allowance(msg.sender, this);
191         require(allowed >= quantity, "You must approve the transfer of tokens before offering them for sale.");
192 
193         uint256 balance = ERC20Interface(tokenContract).balanceOf(msg.sender);
194         require(balance >= quantity, "Not enough tokens owned to complete the order.");
195 
196         orderBook[msg.sender] = TradeOrder(quantity, price, expiry);
197         emit TokensOffered(msg.sender, quantity, price, expiry);
198     }
199 
200     /**
201      * @notice Buy tokens from an existing sell order.
202      *
203      * @param seller    The current owner of the tokens for sale.
204      * @param quantity  The number of tokens to buy.
205      * @param price     The ask price of the tokens.
206     */
207     function buy(address seller, uint256 quantity, uint256 price) public payable {
208         TradeOrder memory order = orderBook[seller];
209         require(order.price == price, "Buy price does not match the listed sell price.");
210         require(block.timestamp < order.expiry, "Sell order has expired.");
211 
212         uint256 tradeQuantity = order.quantity > quantity ? quantity : order.quantity;
213         uint256 cost = multiplyAtPrecision(tradeQuantity, order.price, 9);
214         require(msg.value >= cost, "You did not send enough Ether to purchase the tokens.");
215 
216         uint256 tokenFee;
217         uint256 etherFee;
218         (tokenFee, etherFee) = calculateFee(tradeQuantity, cost);
219 
220         if(!ERC20Interface(tokenContract).transferFrom(seller, msg.sender, tradeQuantity.sub(tokenFee))) {
221             revert("Unable to transfer tokens from seller to buyer.");
222         }
223 
224         // Send any tokens taken as fees to the owner account to be burned.
225         if(tokenFee > 0 && !ERC20Interface(tokenContract).transferFrom(seller, owner, tokenFee)) {
226             revert("Unable to transfer tokens from seller to buyer.");
227         }
228 
229         // Deduct the sold tokens from the sell order.
230         order.quantity = order.quantity.sub(tradeQuantity);
231         orderBook[seller] = order;
232 
233         // Pay the seller.
234         seller.transfer(cost.sub(etherFee));
235         if(etherFee > 0)
236             owner.transfer(etherFee);
237 
238         lastSellPrice = price;
239 
240         emit TokensPurchased(msg.sender, seller, tradeQuantity, price);
241     }
242 
243     /**
244      * @notice Set the percent fee applied to tokens that are transferred.
245      *
246      * @param percent   The new percentage value at 18 decimal places.
247      */
248     function setTokenFeePercent(uint256 percent) public onlyOwner {
249         require(percent <= 100000000000000000000, "Percent must be between 0 and 100.");
250         tokenFeePercent = percent;
251     }
252 
253     /**
254      * @notice Set the minimum number of tokens to be deducted during a buy.
255      *
256      * @param min   The new minimum value.
257      */
258     function setTokenFeeMin(uint256 min) public onlyOwner {
259         tokenFeeMin = min;
260     }
261 
262     /**
263      * @notice Set the percent fee applied to the Ether used to pay for tokens.
264      *
265      * @param percent   The new percentage value at 18 decimal places.
266      */
267     function setEtherFeePercent(uint256 percent) public onlyOwner {
268         require(percent <= 100000000000000000000, "Percent must be between 0 and 100.");
269         etherFeePercent = percent;
270     }
271 
272     /**
273      * @notice Set the minimum amount of Ether to be deducted during a buy.
274      *
275      * @param min   The new minimum value.
276      */
277     function setEtherFeeMin(uint256 min) public onlyOwner {
278         etherFeeMin = min;
279     }
280 
281     /**
282      * @notice Calculate the company's fee for facilitating the transfer of tokens.  The fee can be deducted
283      * from the number of tokens the buyer purchased or the amount of ether being paid to the seller or both.
284      *
285      * @param tokens    The number of tokens being transferred.
286      * @param ethers    The amount of Ether to pay for the tokens.
287      * @return tokenFee The number of tokens taken as a fee during a transfer.
288      * @return etherFee The amount of Ether taken as a fee during a transfer. 
289      */
290     function calculateFee(uint256 tokens, uint256 ethers) public view returns (uint256 tokenFee, uint256 etherFee) {
291         tokenFee = multiplyAtPrecision(tokens, tokenFeePercent / 100, 9);
292         if(tokenFee < tokenFeeMin)
293             tokenFee = tokenFeeMin;
294 
295         etherFee = multiplyAtPrecision(ethers, etherFeePercent / 100, 9);
296         if(etherFee < etherFeeMin)
297             etherFee = etherFeeMin;            
298 
299         return (tokenFee, etherFee);
300     }
301 
302     /**
303      * @notice Buy from multiple sellers at once to fill a single large order.
304      *
305      * @dev This function is to reduce the transaction costs and to make the purchase a single transaction.
306      *
307      * @param sellers       The list of sellers whose tokens make up this buy.
308      * @param lastQuantity  The quantity of tokens to buy from the last seller on the list (the other asks
309      *                      are bought in full).
310      */
311     function multiBuy(address[] sellers, uint256 lastQuantity) public payable {
312 
313         for (uint i = 0; i < sellers.length; i++) {
314             TradeOrder memory to = orderBook[sellers[i]];
315             if(i == sellers.length-1) {
316                 buy(sellers[i], lastQuantity, to.price);
317             }
318             else {
319                 buy(sellers[i], to.quantity, to.price);
320             }
321         }
322     }
323 
324     /**
325      * @notice A user has redeemed a top-up voucher for phone credit.  This is executed by the owner as it is an internal process
326      * to convert a voucher to phone credit via VOX Tokens.
327      *
328      * @param voucherCode   The code on the e.g. scratch card that is to be redeemed for call credit.
329      * @param voucherOwner  The wallet id of the user redeeming the voucher.
330      * @param tokenSeller   The wallet id selling the VOX Tokens that are converted to phone crdit.
331      * @param quantity      The number of vouchers to purchase on behalf of the voucher owner to fulfill the voucher.
332      */
333     function redeemVoucher(uint256 voucherCode, address voucherOwner, address tokenSeller, uint256 quantity) public onlyOwner payable {
334 
335         // Send ether to the token owner and as we buy them as the owner they get burned.
336         buy(tokenSeller, quantity, orderBook[tokenSeller].price);
337 
338         // Log the event so the system can detect the successful top-up and transfer credit to the voucher owner.
339         emit VoucherRedeemed(voucherCode, voucherOwner, tokenSeller, quantity);
340     }
341 
342     /**
343      * @notice Set the highest price an ask can be listed.
344      *
345      * @param ceiling   The new maximum price allowed for a sale.
346      */
347     function setSellCeiling(uint256 ceiling) public onlyOwner {
348         sellCeiling = ceiling;
349     }
350 
351     /**
352      * @notice Set the lowest price an ask can be listed.
353      *
354      * @param floor   The new minimum price allowed for a sale.
355      */
356     function setSellFloor(uint256 floor) public onlyOwner {
357         sellFloor = floor;
358     }
359 
360     /**
361      * @dev Multiply two large numbers using a reduced number of digits e.g. multiply two 10^18 numbers as
362      * 10^9 numbers to give a 10^18 result.
363      *
364      * @param num1      The first number to multiply.
365      * @param num2      The second number to multiply.
366      * @param digits    The number of trailing digits to remove.
367      * @return          The product of the two numbers at the given precision.
368      */
369     function multiplyAtPrecision(uint256 num1, uint256 num2, uint8 digits) public pure returns (uint256) {
370         return removeLowerDigits(num1, digits) * removeLowerDigits(num2, digits);
371     }
372 
373     /**
374      * @dev Strip off the lower n digits of a number, but only if they are zero (to prevent loss of precision).
375      *
376      * @param value     The numeric value to remove the lower digits from.
377      * @param digits    The number of digits to remove.
378      * @return          The original value (e.g. 10^18) as a smaller number (e.g. 10^9).
379      */
380     function removeLowerDigits(uint256 value, uint8 digits) public pure returns (uint256) {
381         uint256 divisor = 10 ** uint256(digits);
382         uint256 div = value / divisor;
383         uint256 mult = div * divisor;
384 
385         require(mult == value, "The lower digits bring stripped off must be non-zero");
386 
387         return div;
388     }
389 }