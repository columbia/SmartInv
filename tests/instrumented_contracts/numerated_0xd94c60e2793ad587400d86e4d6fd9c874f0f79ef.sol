1 pragma solidity 0.4.21;
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
303 // File: contracts/TotlePrimary.sol
304 
305 /// @title The primary contract for Totle Inc
306 contract TotlePrimary is Ownable {
307     // Constants
308     uint256 public constant MAX_EXCHANGE_FEE_PERCENTAGE = 0.01 * 10**18; // 1%
309     bool constant BUY = false;
310     bool constant SELL = true;
311 
312     // State variables
313     mapping(address => bool) public handlerWhitelist;
314     address tokenTransferProxy;
315 
316     // Structs
317     struct Tokens {
318         address[] tokenAddresses;
319         bool[]    buyOrSell;
320         uint256[] amountToObtain;
321         uint256[] amountToGive;
322     }
323 
324     struct DEXOrders {
325         address[] tokenForOrder;
326         address[] exchanges;
327         address[8][] orderAddresses;
328         uint256[6][] orderValues;
329         uint256[] exchangeFees;
330         uint8[] v;
331         bytes32[] r;
332         bytes32[] s;
333     }
334 
335     /// @dev Constructor
336     /// @param proxy Address of the TokenTransferProxy
337     function TotlePrimary(address proxy) public {
338         tokenTransferProxy = proxy;
339     }
340 
341     /*
342     *   Public functions
343     */
344 
345     /// @dev Set an exchange handler address to true/false
346     /// @notice - onlyOwner modifier only allows the contract owner to run the code
347     /// @param handler Address of the exchange handler which permission needs changing
348     /// @param allowed Boolean value to set whether an exchange handler is allowed/denied
349     function setHandler(address handler, bool allowed) public onlyOwner {
350         handlerWhitelist[handler] = allowed;
351     }
352 
353     /// @dev Synchronously executes an array of orders
354     /// @notice The first four parameters relate to Token orders, the last eight relate to DEX orders
355     /// @param tokenAddresses Array of addresses of ERC20 Token contracts for each Token order
356     /// @param buyOrSell Array indicating whether each Token order is a buy or sell
357     /// @param amountToObtain Array indicating the amount (in ether or tokens) to obtain in the order
358     /// @param amountToGive Array indicating the amount (in ether or tokens) to give in the order
359     /// @param tokenForOrder Array of addresses of ERC20 Token contracts for each DEX order
360     /// @param exchanges Array of addresses of exchange handler contracts
361     /// @param orderAddresses Array of address values needed for each DEX order
362     /// @param orderValues Array of uint values needed for each DEX order
363     /// @param exchangeFees Array indicating the fee for each DEX order (percentage of fill amount as decimal * 10**18)
364     /// @param v ECDSA signature parameter v
365     /// @param r ECDSA signature parameter r
366     /// @param s ECDSA signature parameter s
367     function executeOrders(
368         // Tokens
369         address[] tokenAddresses,
370         bool[]    buyOrSell,
371         uint256[] amountToObtain,
372         uint256[] amountToGive,
373         // DEX Orders
374         address[] tokenForOrder,
375         address[] exchanges,
376         address[8][] orderAddresses,
377         uint256[6][] orderValues,
378         uint256[] exchangeFees,
379         uint8[] v,
380         bytes32[] r,
381         bytes32[] s
382     ) public payable {
383 
384         require(
385             tokenAddresses.length == buyOrSell.length &&
386             buyOrSell.length      == amountToObtain.length &&
387             amountToObtain.length == amountToGive.length
388         );
389 
390         require(
391             tokenForOrder.length  == exchanges.length &&
392             exchanges.length      == orderAddresses.length &&
393             orderAddresses.length == orderValues.length &&
394             orderValues.length    == exchangeFees.length &&
395             exchangeFees.length   == v.length &&
396             v.length              == r.length &&
397             r.length              == s.length
398         );
399 
400         // Wrapping order in structs to reduce local variable count
401         internalOrderExecution(
402             Tokens(
403                 tokenAddresses,
404                 buyOrSell,
405                 amountToObtain,
406                 amountToGive
407             ),
408             DEXOrders(
409                 tokenForOrder,
410                 exchanges,
411                 orderAddresses,
412                 orderValues,
413                 exchangeFees,
414                 v,
415                 r,
416                 s
417             )
418         );
419     }
420 
421     /*
422     *   Internal functions
423     */
424 
425     /// @dev Synchronously executes an array of orders
426     /// @notice The orders in this function have been wrapped in structs to reduce the local variable count
427     /// @param tokens Struct containing the arrays of token orders
428     /// @param orders Struct containing the arrays of DEX orders
429     function internalOrderExecution(Tokens tokens, DEXOrders orders) internal {
430         transferTokens(tokens);
431 
432         uint256 tokensLength = tokens.tokenAddresses.length;
433         uint256 ordersLength = orders.tokenForOrder.length;
434         uint256 etherBalance = msg.value;
435         uint256 orderIndex = 0;
436 
437         for(uint256 tokenIndex = 0; tokenIndex < tokensLength; tokenIndex++) {
438             // NOTE - check for repetitions in the token list?
439 
440             uint256 amountRemaining = tokens.amountToGive[tokenIndex];
441             uint256 amountObtained = 0;
442 
443             while(orderIndex < ordersLength) {
444                 require(tokens.tokenAddresses[tokenIndex] == orders.tokenForOrder[orderIndex]);
445                 require(handlerWhitelist[orders.exchanges[orderIndex]]);
446 
447                 if(amountRemaining > 0) {
448                     if(tokens.buyOrSell[tokenIndex] == BUY) {
449                         require(etherBalance >= amountRemaining);
450                     }
451                     (amountRemaining, amountObtained) = performTrade(
452                         tokens.buyOrSell[tokenIndex],
453                         amountRemaining,
454                         amountObtained,
455                         orders, // NOTE - unable to send pointer to order values individually, as run out of stack space!
456                         orderIndex
457                         );
458                 }
459 
460                 orderIndex = SafeMath.add(orderIndex, 1);
461                 // If this is the last order for this token
462                 if(orderIndex == ordersLength || orders.tokenForOrder[SafeMath.sub(orderIndex, 1)] != orders.tokenForOrder[orderIndex]){
463                     break;
464                 }
465             }
466 
467             uint256 amountGiven = SafeMath.sub(tokens.amountToGive[tokenIndex], amountRemaining);
468 
469             require(orderWasValid(amountObtained, amountGiven, tokens.amountToObtain[tokenIndex], tokens.amountToGive[tokenIndex]));
470 
471             if(tokens.buyOrSell[tokenIndex] == BUY) {
472                 // Take away spent ether from refund balance
473                 etherBalance = SafeMath.sub(etherBalance, amountGiven);
474                 // Transfer back tokens acquired
475                 if(amountObtained > 0) {
476                     require(Token(tokens.tokenAddresses[tokenIndex]).transfer(msg.sender, amountObtained));
477                 }
478             } else {
479                 // Add ether to refund balance
480                 etherBalance = SafeMath.add(etherBalance, amountObtained);
481                 // Transfer back un-sold tokens
482                 if(amountRemaining > 0) {
483                     require(Token(tokens.tokenAddresses[tokenIndex]).transfer(msg.sender, amountRemaining));
484                 }
485             }
486         }
487 
488         // Send back acquired/unspent ether - throw on failure
489         if(etherBalance > 0) {
490             msg.sender.transfer(etherBalance);
491         }
492     }
493 
494     /// @dev Iterates through a list of token orders, transfer the SELL orders to this contract & calculates if we have the ether needed
495     /// @param tokens Struct containing the arrays of token orders
496     function transferTokens(Tokens tokens) internal {
497         uint256 expectedEtherAvailable = msg.value;
498         uint256 totalEtherNeeded = 0;
499 
500         for(uint256 i = 0; i < tokens.tokenAddresses.length; i++) {
501             if(tokens.buyOrSell[i] == BUY) {
502                 totalEtherNeeded = SafeMath.add(totalEtherNeeded, tokens.amountToGive[i]);
503             } else {
504                 expectedEtherAvailable = SafeMath.add(expectedEtherAvailable, tokens.amountToObtain[i]);
505                 require(TokenTransferProxy(tokenTransferProxy).transferFrom(
506                     tokens.tokenAddresses[i],
507                     msg.sender,
508                     this,
509                     tokens.amountToGive[i]
510                 ));
511             }
512         }
513 
514         // Make sure we have will have enough ETH after SELLs to cover our BUYs
515         require(expectedEtherAvailable >= totalEtherNeeded);
516     }
517 
518     /// @dev Performs a single trade via the requested exchange handler
519     /// @param buyOrSell Boolean value stating whether this is a buy or sell order
520     /// @param initialRemaining The remaining value we have left to trade
521     /// @param totalObtained The total amount we have obtained so far
522     /// @param orders Struct containing all DEX orders
523     /// @param index Value indicating the index of the specific DEX order we wish to execute
524     /// @return Remaining value left after trade
525     /// @return Total value obtained after trade
526     function performTrade(bool buyOrSell, uint256 initialRemaining, uint256 totalObtained, DEXOrders orders, uint256 index)
527         internal returns (uint256, uint256) {
528         uint256 obtained = 0;
529         uint256 remaining = initialRemaining;
530 
531         require(orders.exchangeFees[index] < MAX_EXCHANGE_FEE_PERCENTAGE);
532 
533         uint256 amountToFill = getAmountToFill(remaining, orders, index);
534 
535         if(amountToFill > 0) {
536             remaining = SafeMath.sub(remaining, amountToFill);
537 
538             if(buyOrSell == BUY) {
539                 obtained = ExchangeHandler(orders.exchanges[index]).performBuy.value(amountToFill)(
540                     orders.orderAddresses[index],
541                     orders.orderValues[index],
542                     orders.exchangeFees[index],
543                     amountToFill,
544                     orders.v[index],
545                     orders.r[index],
546                     orders.s[index]
547                 );
548             } else {
549                 require(Token(orders.tokenForOrder[index]).transfer(
550                     orders.exchanges[index],
551                     amountToFill
552                 ));
553                 obtained = ExchangeHandler(orders.exchanges[index]).performSell(
554                     orders.orderAddresses[index],
555                     orders.orderValues[index],
556                     orders.exchangeFees[index],
557                     amountToFill,
558                     orders.v[index],
559                     orders.r[index],
560                     orders.s[index]
561                 );
562             }
563         }
564 
565         return (obtained == 0 ? initialRemaining: remaining, SafeMath.add(totalObtained, obtained));
566     }
567 
568     /// @dev Get the amount of this order we are able to fill
569     /// @param remaining Amount we have left to spend
570     /// @param orders Struct containing all DEX orders
571     /// @param index Value indicating the index of the specific DEX order we wish to execute
572     /// @return Minimum of the amount we have left to spend and the available amount at the exchange
573     function getAmountToFill(uint256 remaining, DEXOrders orders, uint256 index) internal returns (uint256) {
574 
575         uint256 availableAmount = ExchangeHandler(orders.exchanges[index]).getAvailableAmount(
576             orders.orderAddresses[index],
577             orders.orderValues[index],
578             orders.exchangeFees[index],
579             orders.v[index],
580             orders.r[index],
581             orders.s[index]
582         );
583 
584         return Math.min256(remaining, availableAmount);
585     }
586 
587     /// @dev Checks whether a given order was valid
588     /// @param amountObtained Amount of the order which was obtained
589     /// @param amountGiven Amount given in return for amountObtained
590     /// @param amountToObtain Amount we intended to obtain
591     /// @param amountToGive Amount we intended to give in return for amountToObtain
592     /// @return Boolean value indicating whether this order was valid
593     function orderWasValid(uint256 amountObtained, uint256 amountGiven, uint256 amountToObtain, uint256 amountToGive) internal pure returns (bool) {
594 
595         if(amountObtained > 0 && amountGiven > 0) {
596             // NOTE - Check the edge cases here
597             if(amountObtained > amountGiven) {
598                 return SafeMath.div(amountToObtain, amountToGive) <= SafeMath.div(amountObtained, amountGiven);
599             } else {
600                 return SafeMath.div(amountToGive, amountToObtain) >= SafeMath.div(amountGiven, amountObtained);
601             }
602         }
603         return false;
604     }
605 
606     function() public payable {
607         // Check in here that the sender is a contract! (to stop accidents)
608         uint256 size;
609         address sender = msg.sender;
610         assembly {
611             size := extcodesize(sender)
612         }
613         require(size > 0);
614     }
615 }