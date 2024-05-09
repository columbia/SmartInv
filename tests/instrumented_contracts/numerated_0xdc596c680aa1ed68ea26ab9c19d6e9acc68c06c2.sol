1 pragma solidity 0.4.24;
2 
3 // File: contracts/ExchangeHandler.sol
4 
5 /// @title Interface for all exchange handler contracts
6 interface ExchangeHandler {
7 
8     /// @dev Get the available amount left to fill for an order
9     /// @param orderAddresses Array of address values needed for this DEX order
10     /// @param orderValues Array of uint values needed for this DEX order
11     /// @param exchangeFee Value indicating the fee for this DEX order
12     /// @param v ECDSA signature parameter v
13     /// @param r ECDSA signature parameter r
14     /// @param s ECDSA signature parameter s
15     /// @return Available amount left to fill for this order
16     function getAvailableAmount(
17         address[8] orderAddresses,
18         uint256[6] orderValues,
19         uint256 exchangeFee,
20         uint8 v,
21         bytes32 r,
22         bytes32 s
23     ) external returns (uint256);
24 
25     /// @dev Perform a buy order at the exchange
26     /// @param orderAddresses Array of address values needed for each DEX order
27     /// @param orderValues Array of uint values needed for each DEX order
28     /// @param exchangeFee Value indicating the fee for this DEX order
29     /// @param amountToFill Amount to fill in this order
30     /// @param v ECDSA signature parameter v
31     /// @param r ECDSA signature parameter r
32     /// @param s ECDSA signature parameter s
33     /// @return Amount filled in this order
34     function performBuy(
35         address[8] orderAddresses,
36         uint256[6] orderValues,
37         uint256 exchangeFee,
38         uint256 amountToFill,
39         uint8 v,
40         bytes32 r,
41         bytes32 s
42     ) external payable returns (uint256);
43 
44     /// @dev Perform a sell order at the exchange
45     /// @param orderAddresses Array of address values needed for each DEX order
46     /// @param orderValues Array of uint values needed for each DEX order
47     /// @param exchangeFee Value indicating the fee for this DEX order
48     /// @param amountToFill Amount to fill in this order
49     /// @param v ECDSA signature parameter v
50     /// @param r ECDSA signature parameter r
51     /// @param s ECDSA signature parameter s
52     /// @return Amount filled in this order
53     function performSell(
54         address[8] orderAddresses,
55         uint256[6] orderValues,
56         uint256 exchangeFee,
57         uint256 amountToFill,
58         uint8 v,
59         bytes32 r,
60         bytes32 s
61     ) external returns (uint256);
62 }
63 
64 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() public {
83     owner = msg.sender;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address newOwner) public onlyOwner {
99     require(newOwner != address(0));
100     emit OwnershipTransferred(owner, newOwner);
101     owner = newOwner;
102   }
103 
104 }
105 
106 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
107 
108 /**
109  * @title ERC20Basic
110  * @dev Simpler version of ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/179
112  */
113 contract ERC20Basic {
114   function totalSupply() public view returns (uint256);
115   function balanceOf(address who) public view returns (uint256);
116   function transfer(address to, uint256 value) public returns (bool);
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract Token is ERC20Basic {
127   function allowance(address owner, address spender) public view returns (uint256);
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 // File: contracts/TokenTransferProxy.sol
134 
135 /*
136     Notice - This code is copyright 2017 ZeroEx Intl and licensed
137     under the Apache License, Version 2.0;
138 */
139 
140 contract TokenTransferProxy is Ownable {
141 
142     /// @dev Only authorized addresses can invoke functions with this modifier.
143     modifier onlyAuthorized {
144         require(authorized[msg.sender]);
145         _;
146     }
147 
148     modifier targetAuthorized(address target) {
149         require(authorized[target]);
150         _;
151     }
152 
153     modifier targetNotAuthorized(address target) {
154         require(!authorized[target]);
155         _;
156     }
157 
158     mapping (address => bool) public authorized;
159     address[] public authorities;
160 
161     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
162     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
163 
164     /*
165      * Public functions
166      */
167 
168     /// @dev Authorizes an address.
169     /// @param target Address to authorize.
170     function addAuthorizedAddress(address target)
171         public
172         onlyOwner
173         targetNotAuthorized(target)
174     {
175         authorized[target] = true;
176         authorities.push(target);
177         emit LogAuthorizedAddressAdded(target, msg.sender);
178     }
179 
180     /// @dev Removes authorizion of an address.
181     /// @param target Address to remove authorization from.
182     function removeAuthorizedAddress(address target)
183         public
184         onlyOwner
185         targetAuthorized(target)
186     {
187         delete authorized[target];
188         for (uint i = 0; i < authorities.length; i++) {
189             if (authorities[i] == target) {
190                 authorities[i] = authorities[authorities.length - 1];
191                 authorities.length -= 1;
192                 break;
193             }
194         }
195         emit LogAuthorizedAddressRemoved(target, msg.sender);
196     }
197 
198     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
199     /// @param token Address of token to transfer.
200     /// @param from Address to transfer token from.
201     /// @param to Address to transfer token to.
202     /// @param value Amount of token to transfer.
203     /// @return Success of transfer.
204     function transferFrom(
205         address token,
206         address from,
207         address to,
208         uint value)
209         public
210         onlyAuthorized
211         returns (bool)
212     {
213         return Token(token).transferFrom(from, to, value);
214     }
215 
216     /*
217      * Public constant functions
218      */
219 
220     /// @dev Gets all authorized addresses.
221     /// @return Array of authorized addresses.
222     function getAuthorizedAddresses()
223         public
224         constant
225         returns (address[])
226     {
227         return authorities;
228     }
229 }
230 
231 // File: openzeppelin-solidity/contracts/math/Math.sol
232 
233 /**
234  * @title Math
235  * @dev Assorted math operations
236  */
237 library Math {
238   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
239     return a >= b ? a : b;
240   }
241 
242   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
243     return a < b ? a : b;
244   }
245 
246   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
247     return a >= b ? a : b;
248   }
249 
250   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
251     return a < b ? a : b;
252   }
253 }
254 
255 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
256 
257 /**
258  * @title SafeMath
259  * @dev Math operations with safety checks that throw on error
260  */
261 library SafeMath {
262 
263   /**
264   * @dev Multiplies two numbers, throws on overflow.
265   */
266   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
267     if (a == 0) {
268       return 0;
269     }
270     c = a * b;
271     assert(c / a == b);
272     return c;
273   }
274 
275   /**
276   * @dev Integer division of two numbers, truncating the quotient.
277   */
278   function div(uint256 a, uint256 b) internal pure returns (uint256) {
279     // assert(b > 0); // Solidity automatically throws when dividing by 0
280     // uint256 c = a / b;
281     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
282     return a / b;
283   }
284 
285   /**
286   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
287   */
288   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
289     assert(b <= a);
290     return a - b;
291   }
292 
293   /**
294   * @dev Adds two numbers, throws on overflow.
295   */
296   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
297     c = a + b;
298     assert(c >= a);
299     return c;
300   }
301 }
302 
303 /// @title The primary contract for Totle Inc
304 contract TotlePrimary is Ownable {
305     // Constants
306     uint256 public constant MAX_EXCHANGE_FEE_PERCENTAGE = 0.01 * 10**18; // 1%
307     bool constant BUY = false;
308     bool constant SELL = true;
309 
310     // State variables
311     mapping(address => bool) public handlerWhitelist;
312     address tokenTransferProxy;
313 
314     // Structs
315     struct Tokens {
316         address[] tokenAddresses;
317         bool[]    buyOrSell;
318         uint256[] amountToObtain;
319         uint256[] amountToGive;
320     }
321 
322     struct DEXOrders {
323         address[] tokenForOrder;
324         address[] exchanges;
325         address[8][] orderAddresses;
326         uint256[6][] orderValues;
327         uint256[] exchangeFees;
328         uint8[] v;
329         bytes32[] r;
330         bytes32[] s;
331     }
332 
333     /// @dev Constructor
334     /// @param proxy Address of the TokenTransferProxy
335     constructor(address proxy) public {
336         tokenTransferProxy = proxy;
337     }
338 
339     /*
340     *   Public functions
341     */
342 
343     /// @dev Set an exchange handler address to true/false
344     /// @notice - onlyOwner modifier only allows the contract owner to run the code
345     /// @param handler Address of the exchange handler which permission needs changing
346     /// @param allowed Boolean value to set whether an exchange handler is allowed/denied
347     function setHandler(address handler, bool allowed) public onlyOwner {
348         handlerWhitelist[handler] = allowed;
349     }
350 
351     /// @dev Synchronously executes an array of orders
352     /// @notice The first four parameters relate to Token orders, the last eight relate to DEX orders
353     /// @param tokenAddresses Array of addresses of ERC20 Token contracts for each Token order
354     /// @param buyOrSell Array indicating whether each Token order is a buy or sell
355     /// @param amountToObtain Array indicating the amount (in ether or tokens) to obtain in the order
356     /// @param amountToGive Array indicating the amount (in ether or tokens) to give in the order
357     /// @param tokenForOrder Array of addresses of ERC20 Token contracts for each DEX order
358     /// @param exchanges Array of addresses of exchange handler contracts
359     /// @param orderAddresses Array of address values needed for each DEX order
360     /// @param orderValues Array of uint values needed for each DEX order
361     /// @param exchangeFees Array indicating the fee for each DEX order (percentage of fill amount as decimal * 10**18)
362     /// @param v ECDSA signature parameter v
363     /// @param r ECDSA signature parameter r
364     /// @param s ECDSA signature parameter s
365     function executeOrders(
366         // Tokens
367         address[] tokenAddresses,
368         bool[]    buyOrSell,
369         uint256[] amountToObtain,
370         uint256[] amountToGive,
371         // DEX Orders
372         address[] tokenForOrder,
373         address[] exchanges,
374         address[8][] orderAddresses,
375         uint256[6][] orderValues,
376         uint256[] exchangeFees,
377         uint8[] v,
378         bytes32[] r,
379         bytes32[] s,
380         // Unique ID
381         uint256 uniqueID
382     ) public payable {
383 
384         require(
385             tokenAddresses.length == buyOrSell.length &&
386             buyOrSell.length      == amountToObtain.length &&
387             amountToObtain.length == amountToGive.length,
388             "TotlePrimary - trade length check failed"
389         );
390 
391         require(
392             tokenForOrder.length  == exchanges.length &&
393             exchanges.length      == orderAddresses.length &&
394             orderAddresses.length == orderValues.length &&
395             orderValues.length    == exchangeFees.length &&
396             exchangeFees.length   == v.length &&
397             v.length              == r.length &&
398             r.length              == s.length,
399             "TotlePrimary - order length check failed"
400         );
401 
402         // Wrapping order in structs to reduce local variable count
403         internalOrderExecution(
404             Tokens(
405                 tokenAddresses,
406                 buyOrSell,
407                 amountToObtain,
408                 amountToGive
409             ),
410             DEXOrders(
411                 tokenForOrder,
412                 exchanges,
413                 orderAddresses,
414                 orderValues,
415                 exchangeFees,
416                 v,
417                 r,
418                 s
419             )
420         );
421     }
422 
423     /*
424     *   Internal functions
425     */
426 
427     /// @dev Synchronously executes an array of orders
428     /// @notice The orders in this function have been wrapped in structs to reduce the local variable count
429     /// @param tokens Struct containing the arrays of token orders
430     /// @param orders Struct containing the arrays of DEX orders
431     function internalOrderExecution(Tokens tokens, DEXOrders orders) internal {
432         transferTokens(tokens);
433 
434         uint256 tokensLength = tokens.tokenAddresses.length;
435         uint256 ordersLength = orders.tokenForOrder.length;
436         uint256 etherBalance = msg.value;
437         uint256 orderIndex = 0;
438 
439         for(uint256 tokenIndex = 0; tokenIndex < tokensLength; tokenIndex++) {
440             // NOTE - check for repetitions in the token list?
441 
442             uint256 amountRemaining = tokens.amountToGive[tokenIndex];
443             uint256 amountObtained = 0;
444 
445             while(orderIndex < ordersLength) {
446                 require(
447                     tokens.tokenAddresses[tokenIndex] == orders.tokenForOrder[orderIndex],
448                     "TotlePrimary - tokenAddress != tokenForOrder"
449                 );
450                 require(
451                     handlerWhitelist[orders.exchanges[orderIndex]],
452                     "TotlePrimary - handler not in whitelist"
453                 );
454 
455                 if(amountRemaining > 0) {
456                     if(tokens.buyOrSell[tokenIndex] == BUY) {
457                         require(
458                             etherBalance >= amountRemaining,
459                             "TotlePrimary - not enough ether left to fill next order"
460                         );
461                     }
462                     (amountRemaining, amountObtained) = performTrade(
463                         tokens.buyOrSell[tokenIndex],
464                         amountRemaining,
465                         amountObtained,
466                         orders, // NOTE - unable to send pointer to order values individually, as run out of stack space!
467                         orderIndex
468                         );
469                 }
470 
471                 orderIndex = SafeMath.add(orderIndex, 1);
472                 // If this is the last order for this token
473                 if(orderIndex == ordersLength || orders.tokenForOrder[SafeMath.sub(orderIndex, 1)] != orders.tokenForOrder[orderIndex]) {
474                     break;
475                 }
476             }
477 
478             uint256 amountGiven = SafeMath.sub(tokens.amountToGive[tokenIndex], amountRemaining);
479 
480             require(
481                 orderWasValid(amountObtained, amountGiven, tokens.amountToObtain[tokenIndex], tokens.amountToGive[tokenIndex]),
482                 "TotlePrimary - amount obtained for was not high enough"
483             );
484 
485             if(tokens.buyOrSell[tokenIndex] == BUY) {
486                 // Take away spent ether from refund balance
487                 etherBalance = SafeMath.sub(etherBalance, amountGiven);
488                 // Transfer back tokens acquired
489                 if(amountObtained > 0) {
490                     require(
491                         Token(tokens.tokenAddresses[tokenIndex]).transfer(msg.sender, amountObtained),
492                         "TotlePrimary - failed to transfer tokens bought to msg.sender"
493                     );
494                 }
495             } else {
496                 // Add ether to refund balance
497                 etherBalance = SafeMath.add(etherBalance, amountObtained);
498                 // Transfer back un-sold tokens
499                 if(amountRemaining > 0) {
500                     require(
501                         Token(tokens.tokenAddresses[tokenIndex]).transfer(msg.sender, amountRemaining),
502                         "TotlePrimary - failed to transfer remaining tokens to msg.sender after sell"
503                     );
504                 }
505             }
506         }
507 
508         // Send back acquired/unspent ether - throw on failure
509         if(etherBalance > 0) {
510             msg.sender.transfer(etherBalance);
511         }
512     }
513 
514     /// @dev Iterates through a list of token orders, transfer the SELL orders to this contract & calculates if we have the ether needed
515     /// @param tokens Struct containing the arrays of token orders
516     function transferTokens(Tokens tokens) internal {
517         uint256 expectedEtherAvailable = msg.value;
518         uint256 totalEtherNeeded = 0;
519 
520         for(uint256 i = 0; i < tokens.tokenAddresses.length; i++) {
521             if(tokens.buyOrSell[i] == BUY) {
522                 totalEtherNeeded = SafeMath.add(totalEtherNeeded, tokens.amountToGive[i]);
523             } else {
524                 expectedEtherAvailable = SafeMath.add(expectedEtherAvailable, tokens.amountToObtain[i]);
525                 require(
526                     TokenTransferProxy(tokenTransferProxy).transferFrom(
527                         tokens.tokenAddresses[i],
528                         msg.sender,
529                         this,
530                         tokens.amountToGive[i]
531                     ),
532                     "TotlePrimary - proxy failed to transfer tokens from user"
533                 );
534             }
535         }
536 
537         // Make sure we have will have enough ETH after SELLs to cover our BUYs
538         require(
539             expectedEtherAvailable >= totalEtherNeeded,
540             "TotlePrimary - not enough ether available to fill all orders"
541         );
542     }
543 
544     /// @dev Performs a single trade via the requested exchange handler
545     /// @param buyOrSell Boolean value stating whether this is a buy or sell order
546     /// @param initialRemaining The remaining value we have left to trade
547     /// @param totalObtained The total amount we have obtained so far
548     /// @param orders Struct containing all DEX orders
549     /// @param index Value indicating the index of the specific DEX order we wish to execute
550     /// @return Remaining value left after trade
551     /// @return Total value obtained after trade
552     function performTrade(bool buyOrSell, uint256 initialRemaining, uint256 totalObtained, DEXOrders orders, uint256 index)
553         internal returns (uint256, uint256) {
554         uint256 obtained = 0;
555         uint256 remaining = initialRemaining;
556 
557         require(
558             orders.exchangeFees[index] < MAX_EXCHANGE_FEE_PERCENTAGE,
559             "TotlePrimary - exchange fee was above maximum"
560         );
561 
562         uint256 amountToFill = getAmountToFill(remaining, orders, index);
563 
564         if(amountToFill > 0) {
565             remaining = SafeMath.sub(remaining, amountToFill);
566 
567             if(buyOrSell == BUY) {
568                 obtained = ExchangeHandler(orders.exchanges[index]).performBuy.value(amountToFill)(
569                     orders.orderAddresses[index],
570                     orders.orderValues[index],
571                     orders.exchangeFees[index],
572                     amountToFill,
573                     orders.v[index],
574                     orders.r[index],
575                     orders.s[index]
576                 );
577             } else {
578                 require(
579                     Token(orders.tokenForOrder[index]).transfer(
580                         orders.exchanges[index],
581                         amountToFill
582                     ),
583                     "TotlePrimary - token transfer to handler failed for sell"
584                 );
585                 obtained = ExchangeHandler(orders.exchanges[index]).performSell(
586                     orders.orderAddresses[index],
587                     orders.orderValues[index],
588                     orders.exchangeFees[index],
589                     amountToFill,
590                     orders.v[index],
591                     orders.r[index],
592                     orders.s[index]
593                 );
594             }
595         }
596 
597         return (obtained == 0 ? initialRemaining: remaining, SafeMath.add(totalObtained, obtained));
598     }
599 
600     /// @dev Get the amount of this order we are able to fill
601     /// @param remaining Amount we have left to spend
602     /// @param orders Struct containing all DEX orders
603     /// @param index Value indicating the index of the specific DEX order we wish to execute
604     /// @return Minimum of the amount we have left to spend and the available amount at the exchange
605     function getAmountToFill(uint256 remaining, DEXOrders orders, uint256 index) internal returns (uint256) {
606 
607         uint256 availableAmount = ExchangeHandler(orders.exchanges[index]).getAvailableAmount(
608             orders.orderAddresses[index],
609             orders.orderValues[index],
610             orders.exchangeFees[index],
611             orders.v[index],
612             orders.r[index],
613             orders.s[index]
614         );
615 
616         return Math.min256(remaining, availableAmount);
617     }
618 
619     /// @dev Checks whether a given order was valid
620     /// @param amountObtained Amount of the order which was obtained
621     /// @param amountGiven Amount given in return for amountObtained
622     /// @param amountToObtain Amount we intended to obtain
623     /// @param amountToGive Amount we intended to give in return for amountToObtain
624     /// @return Boolean value indicating whether this order was valid
625     function orderWasValid(uint256 amountObtained, uint256 amountGiven, uint256 amountToObtain, uint256 amountToGive) internal pure returns (bool) {
626 
627         if(amountObtained > 0 && amountGiven > 0) {
628             // NOTE - Check the edge cases here
629             if(amountObtained > amountGiven) {
630                 return SafeMath.div(amountToObtain, amountToGive) <= SafeMath.div(amountObtained, amountGiven);
631             } else {
632                 return SafeMath.div(amountToGive, amountToObtain) >= SafeMath.div(amountGiven, amountObtained);
633             }
634         }
635         return false;
636     }
637 
638     function() public payable {
639         // Check in here that the sender is a contract! (to stop accidents)
640         uint256 size;
641         address sender = msg.sender;
642         assembly {
643             size := extcodesize(sender)
644         }
645         require(size > 0, "TotlePrimary - can only send ether from another contract");
646     }
647 }