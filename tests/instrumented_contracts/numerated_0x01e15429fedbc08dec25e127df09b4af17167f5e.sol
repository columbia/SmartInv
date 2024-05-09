1 pragma solidity 0.4.24;
2 
3 
4 /**
5 * VOXTrader for the talketh.io ICO by Horizon-Globex.com of Switzerland.
6 *
7 * An ERC20 compliant DEcentralized eXchange [DEX] https://talketh.io/dex
8 *
9 * ICO issuers that utilize the Swiss token issuance standard from Horizon Globex
10 * are supplied with a complete KYC+AML platform, an ERC20 token issuance platform,
11 * a Transfer Agent service, and a post-ICO ERC20 DEX for their investor exit strategy.
12 *
13 * Trade events shall be rebroadcast on issuers Twitter feed https://twitter.com/talkethICO
14 *
15 * -- DEX Platform Notes --
16 * 1. By default, only KYC'ed hodlers of tokens may participate on this DEX.
17 *    - Issuer is free to relax this restriction subject to counsels Legal Opinion.
18 * 2. The issuer has sole discretion to set a minimum bid and a maximum ask. 
19 * 3. Seller shall pay a trade execution fee in ETH which is automatically deducted herein. 
20 *    - Issuer is free to amend the trade execution fee percentage from time to time.
21 *
22 */
23 
24 // ----------------------------------------------------------------------------
25 // ERC Token Standard #20 Interface
26 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
27 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
28 // 
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public view returns (uint256);
32     function balanceOf(address who) public view returns (uint256);
33     function allowance(address approver, address spender) public view returns (uint256);
34     function transfer(address to, uint256 value) public returns (bool);
35     function approve(address spender, uint256 value) public returns (bool);
36     function transferFrom(address from, address to, uint256 value) public returns (bool);
37 
38     // solhint-disable-next-line no-simple-event-func-name
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed approver, address indexed spender, uint256 value);
41 }
42 
43 
44 
45 //
46 // base contract for all our horizon contracts and tokens
47 //
48 contract HorizonContractBase {
49     // The owner of the contract, set at contract creation to the creator.
50     address public owner;
51 
52     constructor() public {
53         owner = msg.sender;
54     }
55 
56     // Contract authorization - only allow the owner to perform certain actions.
57     modifier onlyOwner {
58         require(msg.sender == owner, "Only the owner can call this function.");
59         _;
60     }
61 }
62 
63 
64 
65 
66  
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  *
72  * Source: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
73  */
74 library SafeMath {
75     /**
76      * @dev Multiplies two numbers, throws on overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         if (a == 0) {
80             return 0;
81         }
82         uint256 c = a * b;
83         assert(c / a == b);
84         return c;
85     }
86 
87     /**
88     * @dev Integer division of two numbers, truncating the quotient.
89     */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         // assert(b > 0); // Solidity automatically throws when dividing by 0
92         // uint256 c = a / b;
93         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94         return a / b;
95     }
96 
97     /**
98     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99     */
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         assert(b <= a);
102         return a - b;
103     }
104 
105     /**
106     * @dev Adds two numbers, throws on overflow.
107     */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         assert(c >= a);
111         return c;
112     }
113 }
114 /// math.sol -- mixin for inline numerical wizardry
115 
116 // Taken from: https://dapp.tools/dappsys/ds-math.html
117 
118 // This program is free software: you can redistribute it and/or modify
119 // it under the terms of the GNU General Public License as published by
120 // the Free Software Foundation, either version 3 of the License, or
121 // (at your option) any later version.
122 
123 // This program is distributed in the hope that it will be useful,
124 // but WITHOUT ANY WARRANTY; without even the implied warranty of
125 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
126 // GNU General Public License for more details.
127 
128 // You should have received a copy of the GNU General Public License
129 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
130 
131 
132 
133 library DSMath {
134     
135     function dsAdd(uint x, uint y) internal pure returns (uint z) {
136         require((z = x + y) >= x);
137     }
138 
139     function dsMul(uint x, uint y) internal pure returns (uint z) {
140         require(y == 0 || (z = x * y) / y == x);
141     }
142 
143     uint constant WAD = 10 ** 18;
144 
145     function wmul(uint x, uint y) internal pure returns (uint z) {
146         z = dsAdd(dsMul(x, y), WAD / 2) / WAD;
147     }
148 
149     function wdiv(uint x, uint y) internal pure returns (uint z) {
150         z = dsAdd(dsMul(x, WAD), y / 2) / y;
151     }
152 }
153 
154 
155 /**
156 * VOXTrader for the talketh.io ICO by Horizon-Globex.com of Switzerland.
157 *
158 * An ERC20 compliant DEcentralized eXchange [DEX] https://talketh.io/dex
159 *
160 * ICO issuers that utilize the Swiss token issuance standard from Horizon Globex
161 * are supplied with a complete KYC+AML platform, an ERC20 token issuance platform,
162 * a Transfer Agent service, and a post-ICO ERC20 DEX for their investor exit strategy.
163 *
164 * Trade events shall be rebroadcast on issuers Twitter feed https://twitter.com/talkethICO
165 *
166 * -- DEX Platform Notes --
167 * 1. By default, only KYC'ed hodlers of tokens may participate on this DEX.
168 *    - Issuer is free to relax this restriction subject to counsels Legal Opinion.
169 * 2. The issuer has sole discretion to set a minimum bid and a maximum ask. 
170 * 3. Seller shall pay a trade execution fee in ETH which is automatically deducted herein. 
171 *    - Issuer is free to amend the trade execution fee percentage from time to time.
172 *
173 */
174 contract VOXTrader is HorizonContractBase {
175     using SafeMath for uint256;
176     using DSMath for uint256;
177 
178     struct TradeOrder {
179         uint256 quantity;
180         uint256 price;
181         uint256 expiry;
182     }
183 
184     // The owner of this contract.
185     address public owner;
186 
187     // The balances of all accounts.
188     mapping (address => TradeOrder) public orderBook;
189 
190     // The contract containing the tokens that we trade.
191     address public tokenContract;
192 
193     // The price paid for the last sale of tokens on this contract.
194     uint256 public lastSellPrice;
195 
196     // The highest price an asks can be placed.
197     uint256 public sellCeiling;
198 
199     // The lowest price an ask can be placed.
200     uint256 public sellFloor;
201 
202     // The percentage taken off the cost of buying tokens in Ether.
203     uint256 public etherFeePercent;
204     
205     // The minimum Ether fee when buying tokens (if the calculated percent is less than this value);
206     uint256 public etherFeeMin;
207 
208     // Both buying and selling tokens is restricted to only those who have successfully passed KYC.
209     bool public enforceKyc;
210 
211     // The addresses of those allowed to trade using this contract.
212     mapping (address => bool) public tradingWhitelist;
213 
214     // A sell order was put into the order book.
215     event TokensOffered(address indexed who, uint256 quantity, uint256 price, uint256 expiry);
216 
217     // A user bought tokens from another user.
218     event TokensPurchased(address indexed purchaser, address indexed seller, uint256 quantity, uint256 price);
219 
220     // A user updated their ask.
221     event TokenOfferChanged(address who, uint256 quantity, uint256 price, uint256 expiry);
222 
223     // A user bought phone credit using a top-up voucher, buy VOX Tokens on thier behalf to convert to phone credit.
224     event VoucherRedeemed(uint256 voucherCode, address voucherOwner, address tokenSeller, uint256 quantity);
225 
226     // The contract has been shut down.
227     event ContractRetired(address newAddcontract);
228 
229 
230     /**
231      * @notice Set owner and the target ERC20 contract containing the tokens it trades.
232      *
233      * @param tokenContract_    The ERC20 contract whose tokens this contract trades.
234      */
235     constructor(address tokenContract_) public {
236         owner = msg.sender;
237         tokenContract = tokenContract_;
238 
239         // On publication the only person allowed trade is the issuer/owner.
240         enforceKyc = true;
241         setTradingAllowed(msg.sender, true);
242     }
243 
244     /**
245      * @notice Get the trade order for the specified address.
246      *
247      * @param who    The address to get the trade order of.
248      */
249     function getOrder(address who) public view returns (uint256 quantity, uint256 price, uint256 expiry) {
250         TradeOrder memory order = orderBook[who];
251         return (order.quantity, order.price, order.expiry);
252     }
253 
254     /**
255      * @notice Offer tokens for sale, you must call approve on the ERC20 contract first, giving approval to
256      * the address of this contract.
257      *
258      * @param quantity  The number of tokens to offer for sale.
259      * @param price     The unit price of the tokens.
260      * @param expiry    The date and time this order ends.
261      */
262     function offer(uint256 quantity, uint256 price, uint256 expiry) public {
263         require(enforceKyc == false || isAllowedTrade(msg.sender), "You are unknown and not allowed to trade.");
264         require(quantity > 0, "You must supply a quantity.");
265         require(price > 0, "The sale price cannot be zero.");
266         require(expiry > block.timestamp, "Cannot have an expiry date in the past.");
267         require(price >= sellFloor, "The ask is below the minimum allowed.");
268         require(sellCeiling == 0 || price <= sellCeiling, "The ask is above the maximum allowed.");
269 
270         uint256 allowed = ERC20Interface(tokenContract).allowance(msg.sender, this);
271         require(allowed >= quantity, "You must approve the transfer of tokens before offering them for sale.");
272 
273         uint256 balance = ERC20Interface(tokenContract).balanceOf(msg.sender);
274         require(balance >= quantity, "Not enough tokens owned to complete the order.");
275 
276         orderBook[msg.sender] = TradeOrder(quantity, price, expiry);
277         emit TokensOffered(msg.sender, quantity, price, expiry);
278     }
279 
280     /**
281      * @notice Buy tokens from an existing sell order.
282      *
283      * @param seller    The current owner of the tokens for sale.
284      * @param quantity  The number of tokens to buy.
285      * @param price     The ask price of the tokens.
286     */
287     function execute(address seller, uint256 quantity, uint256 price) public payable {
288         require(enforceKyc == false || (isAllowedTrade(msg.sender) && isAllowedTrade(seller)), "Buyer and Seller must be approved to trade on this exchange.");
289         TradeOrder memory order = orderBook[seller];
290         require(order.price == price, "Buy price does not match the listed sell price.");
291         require(block.timestamp < order.expiry, "Sell order has expired.");
292         require(price >= sellFloor, "The bid is below the minimum allowed.");
293         require(sellCeiling == 0 || price <= sellCeiling, "The bid is above the maximum allowed.");
294 
295         // Deduct the sold tokens from the sell order immediateley to prevent re-entrancy.
296         uint256 tradeQuantity = order.quantity > quantity ? quantity : order.quantity;
297         order.quantity = order.quantity.sub(tradeQuantity);
298         if (order.quantity == 0) {
299             order.price = 0;
300             order.expiry = 0;
301         }
302         orderBook[seller] = order;
303 
304         uint256 cost = tradeQuantity.wmul(order.price);
305         require(msg.value >= cost, "You did not send enough Ether to purchase the tokens.");
306 
307         uint256 etherFee = calculateFee(cost);
308 
309         if(!ERC20Interface(tokenContract).transferFrom(seller, msg.sender, tradeQuantity)) {
310             revert("Unable to transfer tokens from seller to buyer.");
311         }
312 
313         // Pay the seller and if applicable the fee to the issuer.
314         seller.transfer(cost.sub(etherFee));
315         if(etherFee > 0)
316             owner.transfer(etherFee);
317 
318         lastSellPrice = price;
319 
320         emit TokensPurchased(msg.sender, seller, tradeQuantity, price);
321     }
322 
323     /**
324      * @notice Cancel an outstanding order.
325      */
326     function cancel() public {
327         orderBook[msg.sender] = TradeOrder(0, 0, 0);
328 
329         TradeOrder memory order = orderBook[msg.sender];
330         emit TokenOfferChanged(msg.sender, order.quantity, order.price, order.expiry);
331     }
332 
333     /** @notice Allow/disallow users from participating in trading.
334      *
335      * @param who       The user 
336      * @param canTrade  True to allow trading, false to disallow.
337     */
338     function setTradingAllowed(address who, bool canTrade) public onlyOwner {
339         tradingWhitelist[who] = canTrade;
340     }
341 
342     /**
343      * @notice Check if a user is allowed to trade.
344      *
345      * @param who   The user to check.
346      */
347     function isAllowedTrade(address who) public view returns (bool) {
348         return tradingWhitelist[who];
349     }
350 
351     /**
352      * @notice Restrict trading to only those who are whitelisted.  This is true during the ICO.
353      *
354      * @param enforce   True to restrict trading, false to open it up.
355     */
356     function setEnforceKyc(bool enforce) public onlyOwner {
357         enforceKyc = enforce;
358     }
359 
360     /**
361      * @notice Modify the price of an existing ask.
362      *
363      * @param price     The new price.
364      */
365     function setOfferPrice(uint256 price) public {
366         require(enforceKyc == false || isAllowedTrade(msg.sender), "You are unknown and not allowed to trade.");
367         require(price >= sellFloor && (sellCeiling == 0 || price <= sellCeiling), "Updated price is out of range.");
368 
369         TradeOrder memory order = orderBook[msg.sender];
370         require(order.price != 0 || order.expiry != 0, "There is no existing order to modify.");
371         
372         order.price = price;
373         orderBook[msg.sender] = order;
374 
375         emit TokenOfferChanged(msg.sender, order.quantity, order.price, order.expiry);
376     }
377 
378     /**
379      * @notice Change the number of VOX Tokens offered by this user.  NOTE: to set the quantity to zero use cancel().
380      *
381      * @param quantity  The new quantity of the ask.
382      */
383     function setOfferSize(uint256 quantity) public {
384         require(enforceKyc == false || isAllowedTrade(msg.sender), "You are unknown and not allowed to trade.");
385         require(quantity > 0, "Size must be greater than zero, change rejected.");
386         uint256 balance = ERC20Interface(tokenContract).balanceOf(msg.sender);
387         require(balance >= quantity, "Not enough tokens owned to complete the order change.");
388         uint256 allowed = ERC20Interface(tokenContract).allowance(msg.sender, this);
389         require(allowed >= quantity, "You must approve the transfer of tokens before offering them for sale.");
390 
391         TradeOrder memory order = orderBook[msg.sender];
392         order.quantity = quantity;
393         orderBook[msg.sender] = order;
394 
395         emit TokenOfferChanged(msg.sender, quantity, order.price, order.expiry);
396     }
397 
398     /**
399      * @notice Modify the expiry date of an existing ask.
400      *
401      * @param expiry    The new expiry date.
402      */
403     function setOfferExpiry(uint256 expiry) public {
404         require(enforceKyc == false || isAllowedTrade(msg.sender), "You are unknown and not allowed to trade.");
405         require(expiry > block.timestamp, "Cannot have an expiry date in the past.");
406 
407         TradeOrder memory order = orderBook[msg.sender];
408         order.expiry = expiry;
409         orderBook[msg.sender] = order;
410 
411         emit TokenOfferChanged(msg.sender, order.quantity, order.price, order.expiry);        
412     }
413 
414     /**
415      * @notice Set the percent fee applied to the Ether used to pay for tokens.
416      *
417      * @param percent   The new percentage value at 18 decimal places.
418      */
419     function setEtherFeePercent(uint256 percent) public onlyOwner {
420         require(percent <= 100000000000000000000, "Percent must be between 0 and 100.");
421         etherFeePercent = percent;
422     }
423 
424     /**
425      * @notice Set the minimum amount of Ether to be deducted during a buy.
426      *
427      * @param min   The new minimum value.
428      */
429     function setEtherFeeMin(uint256 min) public onlyOwner {
430         etherFeeMin = min;
431     }
432 
433     /**
434      * @notice Calculate the company's fee for facilitating the transfer of tokens.  The fee is in Ether so
435      * is deducted from the seller of the tokens.
436      *
437      * @param ethers    The amount of Ether to pay for the tokens.
438      * @return fee      The amount of Ether taken as a fee during a transfer.
439      */
440     function calculateFee(uint256 ethers) public view returns (uint256 fee) {
441 
442         fee = ethers.wmul(etherFeePercent / 100);
443         if(fee < etherFeeMin)
444             fee = etherFeeMin;            
445 
446         return fee;
447     }
448 
449     /**
450      * @notice Buy from multiple sellers at once to fill a single large order.
451      *
452      * @dev This function is to reduce the transaction costs and to make the purchase a single transaction.
453      *
454      * @param sellers       The list of sellers whose tokens make up this buy.
455      * @param lastQuantity  The quantity of tokens to buy from the last seller on the list (the other asks
456      *                      are bought in full).
457      */
458     function multiExecute(address[] sellers, uint256 lastQuantity) public payable returns (uint256 totalVouchers) {
459         require(enforceKyc == false || isAllowedTrade(msg.sender), "You are unknown and not allowed to trade.");
460 
461         totalVouchers = 0;
462 
463         for (uint i = 0; i < sellers.length; i++) {
464             TradeOrder memory to = orderBook[sellers[i]];
465             if(i == sellers.length-1) {
466                 execute(sellers[i], lastQuantity, to.price);
467                 totalVouchers += lastQuantity;
468             }
469             else {
470                 execute(sellers[i], to.quantity, to.price);
471                 totalVouchers += to.quantity;
472             }
473         }
474 
475         return totalVouchers;
476     }
477 
478     /**
479      * @notice A user has redeemed a top-up voucher for phone credit.  This is executed by the owner as it is an internal process
480      * to convert a voucher to phone credit via VOX Tokens.
481      *
482      * @param voucherCode   The code on the e.g. scratch card that is to be redeemed for call credit.
483      * @param voucherOwner  The wallet id of the user redeeming the voucher.
484      * @param seller        The wallet id selling the VOX Tokens needed to fill the voucher.
485      * @param quantity      The quantity of VOX tokens needed to fill the voucher.
486      */
487     function redeemVoucherSingle(uint256 voucherCode, address voucherOwner, address seller, uint256 quantity) public onlyOwner payable {
488 
489         // Send ether to the token owner and as we buy them as the owner they get burned.
490         TradeOrder memory order = orderBook[seller];
491         execute(seller, quantity, order.price);
492 
493         // Log the event so the system can detect the successful top-up and transfer credit to the voucher owner.
494         emit VoucherRedeemed(voucherCode, voucherOwner, seller, quantity);
495     }
496 
497     /**
498      * @notice A user has redeemed a top-up voucher for phone credit.  This is executed by the owner as it is an internal process
499      * to convert a voucher to phone credit via VOX Tokens.
500      *
501      * @param voucherCode   The code on the e.g. scratch card that is to be redeemed for call credit.
502      * @param voucherOwner  The wallet id of the user redeeming the voucher.
503      * @param sellers       The wallet id(s) selling the VOX Tokens needed to fill the voucher.
504      * @param lastQuantity  The quantity of the last seller's ask to use, the other orders are used in full.
505      */
506     function redeemVoucher(uint256 voucherCode, address voucherOwner, address[] sellers, uint256 lastQuantity) public onlyOwner payable {
507 
508         // Send ether to the token owner and as we buy them as the owner they get burned.
509         uint256 totalVouchers = multiExecute(sellers, lastQuantity);
510 
511         // If we fill the voucher from multiple sellers we set the seller address to zero, the associated
512         // TokensPurchased events will contain the details of the orders filled.
513         address seller = sellers.length == 1 ? sellers[0] : 0;
514         emit VoucherRedeemed(voucherCode, voucherOwner, seller, totalVouchers);
515     }
516 
517     /**
518      * @notice Set the highest price an ask can be listed.
519      *
520      * @param ceiling   The new maximum price allowed for a sale.
521      */
522     function setSellCeiling(uint256 ceiling) public onlyOwner {
523         sellCeiling = ceiling;
524     }
525 
526     /**
527      * @notice Set the lowest price an ask can be listed.
528      *
529      * @param floor   The new minimum price allowed for a sale.
530      */
531     function setSellFloor(uint256 floor) public onlyOwner {
532         sellFloor = floor;
533     }
534 
535     /**
536     * @dev A newer version of this contract is available and this contract is now discontinued.
537     *
538     * @param recipient      Which account would get any ether from this contract (it shouldn't have any).
539     * @param newContract    The address of the newer version of this contract.
540     */
541     function retire(address recipient, address newContract) public onlyOwner {
542         emit ContractRetired(newContract);
543 
544         selfdestruct(recipient);
545     }
546 }