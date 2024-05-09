1 pragma solidity ^0.4.24;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     if (a == 0) {
32       return 0;
33     }
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return a / b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83   function Ownable() public {
84     owner = msg.sender;
85   }
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address newOwner) public onlyOwner {
100     require(newOwner != address(0));
101     emit OwnershipTransferred(owner, newOwner);
102     owner = newOwner;
103   }
104 
105 }
106 
107 contract TokenTransferProxy is Ownable {
108 
109     /// @dev Only authorized addresses can invoke functions with this modifier.
110     modifier onlyAuthorized {
111         require(authorized[msg.sender]);
112         _;
113     }
114 
115     modifier targetAuthorized(address target) {
116         require(authorized[target]);
117         _;
118     }
119 
120     modifier targetNotAuthorized(address target) {
121         require(!authorized[target]);
122         _;
123     }
124 
125     mapping (address => bool) public authorized;
126     address[] public authorities;
127 
128     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
129     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
130 
131     /*
132      * Public functions
133      */
134 
135     /// @dev Authorizes an address.
136     /// @param target Address to authorize.
137     function addAuthorizedAddress(address target)
138         public
139         onlyOwner
140         targetNotAuthorized(target)
141     {
142         authorized[target] = true;
143         authorities.push(target);
144         emit LogAuthorizedAddressAdded(target, msg.sender);
145     }
146 
147     /// @dev Removes authorizion of an address.
148     /// @param target Address to remove authorization from.
149     function removeAuthorizedAddress(address target)
150         public
151         onlyOwner
152         targetAuthorized(target)
153     {
154         delete authorized[target];
155         for (uint i = 0; i < authorities.length; i++) {
156             if (authorities[i] == target) {
157                 authorities[i] = authorities[authorities.length - 1];
158                 authorities.length -= 1;
159                 break;
160             }
161         }
162         emit LogAuthorizedAddressRemoved(target, msg.sender);
163     }
164 
165     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
166     /// @param token Address of token to transfer.
167     /// @param from Address to transfer token from.
168     /// @param to Address to transfer token to.
169     /// @param value Amount of token to transfer.
170     /// @return Success of transfer.
171     function transferFrom(
172         address token,
173         address from,
174         address to,
175         uint value)
176         public
177         onlyAuthorized
178         returns (bool)
179     {
180         return Token(token).transferFrom(from, to, value);
181     }
182 
183     /*
184      * Public constant functions
185      */
186 
187     /// @dev Gets all authorized addresses.
188     /// @return Array of authorized addresses.
189     function getAuthorizedAddresses()
190         public
191         constant
192         returns (address[])
193     {
194         return authorities;
195     }
196 }
197 
198 
199 /// @title Interface for all exchange handler contracts
200 interface ExchangeHandler {
201 
202     /// @dev Get the available amount left to fill for an order
203     /// @param orderAddresses Array of address values needed for this DEX order
204     /// @param orderValues Array of uint values needed for this DEX order
205     /// @param exchangeFee Value indicating the fee for this DEX order
206     /// @param v ECDSA signature parameter v
207     /// @param r ECDSA signature parameter r
208     /// @param s ECDSA signature parameter s
209     /// @return Available amount left to fill for this order
210     function getAvailableAmount(
211         address[8] orderAddresses,
212         uint256[6] orderValues,
213         uint256 exchangeFee,
214         uint8 v,
215         bytes32 r,
216         bytes32 s
217     ) external returns (uint256);
218 
219     /// @dev Perform a buy order at the exchange
220     /// @param orderAddresses Array of address values needed for each DEX order
221     /// @param orderValues Array of uint values needed for each DEX order
222     /// @param exchangeFee Value indicating the fee for this DEX order
223     /// @param amountToFill Amount to fill in this order
224     /// @param v ECDSA signature parameter v
225     /// @param r ECDSA signature parameter r
226     /// @param s ECDSA signature parameter s
227     /// @return Amount filled in this order
228     function performBuy(
229         address[8] orderAddresses,
230         uint256[6] orderValues,
231         uint256 exchangeFee,
232         uint256 amountToFill,
233         uint8 v,
234         bytes32 r,
235         bytes32 s
236     ) external payable returns (uint256);
237 
238     /// @dev Perform a sell order at the exchange
239     /// @param orderAddresses Array of address values needed for each DEX order
240     /// @param orderValues Array of uint values needed for each DEX order
241     /// @param exchangeFee Value indicating the fee for this DEX order
242     /// @param amountToFill Amount to fill in this order
243     /// @param v ECDSA signature parameter v
244     /// @param r ECDSA signature parameter r
245     /// @param s ECDSA signature parameter s
246     /// @return Amount filled in this order
247     function performSell(
248         address[8] orderAddresses,
249         uint256[6] orderValues,
250         uint256 exchangeFee,
251         uint256 amountToFill,
252         uint8 v,
253         bytes32 r,
254         bytes32 s
255     ) external returns (uint256);
256 }
257 
258 contract Token {
259     function totalSupply() public constant returns (uint);
260     function balanceOf(address tokenOwner) public constant returns (uint balance);
261     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
262     function transfer(address to, uint tokens) public returns (bool success);
263     function approve(address spender, uint tokens) public returns (bool success);
264     function transferFrom(address from, address to, uint tokens) public returns (bool success);
265 
266     event Transfer(address indexed from, address indexed to, uint tokens);
267     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
268 }
269 
270 /// @title The primary contract for Totle Inc
271 contract TotlePrimary is Ownable {
272     // Constants
273     string public constant CONTRACT_VERSION = "0";
274     uint256 public constant MAX_EXCHANGE_FEE_PERCENTAGE = 0.01 * 10**18; // 1%
275     bool constant BUY = false;
276     bool constant SELL = true;
277 
278     // State variables
279     mapping(address => bool) public handlerWhitelist;
280     address tokenTransferProxy;
281 
282     // Structs
283     struct Tokens {
284         address[] tokenAddresses;
285         bool[]    buyOrSell;
286         uint256[] amountToObtain;
287         uint256[] amountToGive;
288     }
289 
290     struct DEXOrders {
291         address[] tokenForOrder;
292         address[] exchanges;
293         address[8][] orderAddresses;
294         uint256[6][] orderValues;
295         uint256[] exchangeFees;
296         uint8[] v;
297         bytes32[] r;
298         bytes32[] s;
299     }
300 
301     /// @dev Constructor
302     /// @param proxy Address of the TokenTransferProxy
303     constructor(address proxy) public {
304         tokenTransferProxy = proxy;
305     }
306 
307     /*
308     *   Public functions
309     */
310 
311     /// @dev Set an exchange handler address to true/false
312     /// @notice - onlyOwner modifier only allows the contract owner to run the code
313     /// @param handler Address of the exchange handler which permission needs changing
314     /// @param allowed Boolean value to set whether an exchange handler is allowed/denied
315     function setHandler(address handler, bool allowed) public onlyOwner {
316         handlerWhitelist[handler] = allowed;
317     }
318 
319     /// @dev Synchronously executes an array of orders
320     /// @notice The first four parameters relate to Token orders, the last eight relate to DEX orders
321     /// @param tokenAddresses Array of addresses of ERC20 Token contracts for each Token order
322     /// @param buyOrSell Array indicating whether each Token order is a buy or sell
323     /// @param amountToObtain Array indicating the amount (in ether or tokens) to obtain in the order
324     /// @param amountToGive Array indicating the amount (in ether or tokens) to give in the order
325     /// @param tokenForOrder Array of addresses of ERC20 Token contracts for each DEX order
326     /// @param exchanges Array of addresses of exchange handler contracts
327     /// @param orderAddresses Array of address values needed for each DEX order
328     /// @param orderValues Array of uint values needed for each DEX order
329     /// @param exchangeFees Array indicating the fee for each DEX order (percentage of fill amount as decimal * 10**18)
330     /// @param v ECDSA signature parameter v
331     /// @param r ECDSA signature parameter r
332     /// @param s ECDSA signature parameter s
333     function executeOrders(
334         // Tokens
335         address[] tokenAddresses,
336         bool[]    buyOrSell,
337         uint256[] amountToObtain,
338         uint256[] amountToGive,
339         // DEX Orders
340         address[] tokenForOrder,
341         address[] exchanges,
342         address[8][] orderAddresses,
343         uint256[6][] orderValues,
344         uint256[] exchangeFees,
345         uint8[] v,
346         bytes32[] r,
347         bytes32[] s
348     ) public payable {
349 
350         require(
351             tokenAddresses.length == buyOrSell.length &&
352             buyOrSell.length      == amountToObtain.length &&
353             amountToObtain.length == amountToGive.length
354         );
355 
356         require(
357             tokenForOrder.length  == exchanges.length &&
358             exchanges.length      == orderAddresses.length &&
359             orderAddresses.length == orderValues.length &&
360             orderValues.length    == exchangeFees.length &&
361             exchangeFees.length   == v.length &&
362             v.length              == r.length &&
363             r.length              == s.length
364         );
365 
366         // Wrapping order in structs to reduce local variable count
367         internalOrderExecution(
368             Tokens(
369                 tokenAddresses,
370                 buyOrSell,
371                 amountToObtain,
372                 amountToGive
373             ),
374             DEXOrders(
375                 tokenForOrder,
376                 exchanges,
377                 orderAddresses,
378                 orderValues,
379                 exchangeFees,
380                 v,
381                 r,
382                 s
383             )
384         );
385     }
386 
387     /*
388     *   Internal functions
389     */
390 
391     /// @dev Synchronously executes an array of orders
392     /// @notice The orders in this function have been wrapped in structs to reduce the local variable count
393     /// @param tokens Struct containing the arrays of token orders
394     /// @param orders Struct containing the arrays of DEX orders
395     function internalOrderExecution(Tokens tokens, DEXOrders orders) internal {
396         transferTokens(tokens);
397 
398         uint256 tokensLength = tokens.tokenAddresses.length;
399         uint256 ordersLength = orders.tokenForOrder.length;
400         uint256 etherBalance = msg.value;
401         uint256 orderIndex = 0;
402 
403         for(uint256 tokenIndex = 0; tokenIndex < tokensLength; tokenIndex++) {
404             // NOTE - check for repetitions in the token list?
405 
406             uint256 amountRemaining = tokens.amountToGive[tokenIndex];
407             uint256 amountObtained = 0;
408 
409             while(orderIndex < ordersLength) {
410                 require(tokens.tokenAddresses[tokenIndex] == orders.tokenForOrder[orderIndex]);
411                 require(handlerWhitelist[orders.exchanges[orderIndex]]);
412 
413                 if(amountRemaining > 0) {
414                     if(tokens.buyOrSell[tokenIndex] == BUY) {
415                         require(etherBalance >= amountRemaining);
416                     }
417                     (amountRemaining, amountObtained) = performTrade(
418                         tokens.buyOrSell[tokenIndex],
419                         amountRemaining,
420                         amountObtained,
421                         orders, // NOTE - unable to send pointer to order values individually, as run out of stack space!
422                         orderIndex
423                         );
424                 }
425 
426                 orderIndex = SafeMath.add(orderIndex, 1);
427                 // If this is the last order for this token
428                 if(orderIndex == ordersLength || orders.tokenForOrder[SafeMath.sub(orderIndex, 1)] != orders.tokenForOrder[orderIndex]) {
429                     break;
430                 }
431             }
432 
433             uint256 amountGiven = SafeMath.sub(tokens.amountToGive[tokenIndex], amountRemaining);
434 
435             require(orderWasValid(amountObtained, amountGiven, tokens.amountToObtain[tokenIndex], tokens.amountToGive[tokenIndex]));
436 
437             if(tokens.buyOrSell[tokenIndex] == BUY) {
438                 // Take away spent ether from refund balance
439                 etherBalance = SafeMath.sub(etherBalance, amountGiven);
440                 // Transfer back tokens acquired
441                 if(amountObtained > 0) {
442                     require(Token(tokens.tokenAddresses[tokenIndex]).transfer(msg.sender, amountObtained));
443                 }
444             } else {
445                 // Add ether to refund balance
446                 etherBalance = SafeMath.add(etherBalance, amountObtained);
447                 // Transfer back un-sold tokens
448                 if(amountRemaining > 0) {
449                     require(Token(tokens.tokenAddresses[tokenIndex]).transfer(msg.sender, amountRemaining));
450                 }
451             }
452         }
453 
454         // Send back acquired/unspent ether - throw on failure
455         if(etherBalance > 0) {
456             msg.sender.transfer(etherBalance);
457         }
458     }
459 
460     /// @dev Iterates through a list of token orders, transfer the SELL orders to this contract & calculates if we have the ether needed
461     /// @param tokens Struct containing the arrays of token orders
462     function transferTokens(Tokens tokens) internal {
463         uint256 expectedEtherAvailable = msg.value;
464         uint256 totalEtherNeeded = 0;
465 
466         for(uint256 i = 0; i < tokens.tokenAddresses.length; i++) {
467             if(tokens.buyOrSell[i] == BUY) {
468                 totalEtherNeeded = SafeMath.add(totalEtherNeeded, tokens.amountToGive[i]);
469             } else {
470                 expectedEtherAvailable = SafeMath.add(expectedEtherAvailable, tokens.amountToObtain[i]);
471                 require(TokenTransferProxy(tokenTransferProxy).transferFrom(
472                     tokens.tokenAddresses[i],
473                     msg.sender,
474                     this,
475                     tokens.amountToGive[i]
476                 ));
477             }
478         }
479 
480         // Make sure we have will have enough ETH after SELLs to cover our BUYs
481         require(expectedEtherAvailable >= totalEtherNeeded);
482     }
483 
484     /// @dev Performs a single trade via the requested exchange handler
485     /// @param buyOrSell Boolean value stating whether this is a buy or sell order
486     /// @param initialRemaining The remaining value we have left to trade
487     /// @param totalObtained The total amount we have obtained so far
488     /// @param orders Struct containing all DEX orders
489     /// @param index Value indicating the index of the specific DEX order we wish to execute
490     /// @return Remaining value left after trade
491     /// @return Total value obtained after trade
492     function performTrade(bool buyOrSell, uint256 initialRemaining, uint256 totalObtained, DEXOrders orders, uint256 index)
493         internal returns (uint256, uint256) {
494         uint256 obtained = 0;
495         uint256 remaining = initialRemaining;
496 
497         require(orders.exchangeFees[index] < MAX_EXCHANGE_FEE_PERCENTAGE);
498 
499         uint256 amountToFill = getAmountToFill(remaining, orders, index);
500 
501         if(amountToFill > 0) {
502             remaining = SafeMath.sub(remaining, amountToFill);
503 
504             if(buyOrSell == BUY) {
505                 obtained = ExchangeHandler(orders.exchanges[index]).performBuy.value(amountToFill)(
506                     orders.orderAddresses[index],
507                     orders.orderValues[index],
508                     orders.exchangeFees[index],
509                     amountToFill,
510                     orders.v[index],
511                     orders.r[index],
512                     orders.s[index]
513                 );
514             } else {
515                 require(Token(orders.tokenForOrder[index]).transfer(
516                     orders.exchanges[index],
517                     amountToFill
518                 ));
519                 obtained = ExchangeHandler(orders.exchanges[index]).performSell(
520                     orders.orderAddresses[index],
521                     orders.orderValues[index],
522                     orders.exchangeFees[index],
523                     amountToFill,
524                     orders.v[index],
525                     orders.r[index],
526                     orders.s[index]
527                 );
528             }
529         }
530 
531         return (obtained == 0 ? initialRemaining: remaining, SafeMath.add(totalObtained, obtained));
532     }
533 
534     /// @dev Get the amount of this order we are able to fill
535     /// @param remaining Amount we have left to spend
536     /// @param orders Struct containing all DEX orders
537     /// @param index Value indicating the index of the specific DEX order we wish to execute
538     /// @return Minimum of the amount we have left to spend and the available amount at the exchange
539     function getAmountToFill(uint256 remaining, DEXOrders orders, uint256 index) internal returns (uint256) {
540 
541         uint256 availableAmount = ExchangeHandler(orders.exchanges[index]).getAvailableAmount(
542             orders.orderAddresses[index],
543             orders.orderValues[index],
544             orders.exchangeFees[index],
545             orders.v[index],
546             orders.r[index],
547             orders.s[index]
548         );
549 
550         return Math.min256(remaining, availableAmount);
551     }
552 
553     /// @dev Checks whether a given order was valid
554     /// @param amountObtained Amount of the order which was obtained
555     /// @param amountGiven Amount given in return for amountObtained
556     /// @param amountToObtain Amount we intended to obtain
557     /// @param amountToGive Amount we intended to give in return for amountToObtain
558     /// @return Boolean value indicating whether this order was valid
559     function orderWasValid(uint256 amountObtained, uint256 amountGiven, uint256 amountToObtain, uint256 amountToGive) internal pure returns (bool) {
560 
561         if(amountObtained > 0 && amountGiven > 0) {
562             // NOTE - Check the edge cases here
563             if(amountObtained > amountGiven) {
564                 return SafeMath.div(amountToObtain, amountToGive) <= SafeMath.div(amountObtained, amountGiven);
565             } else {
566                 return SafeMath.div(amountToGive, amountToObtain) >= SafeMath.div(amountGiven, amountObtained);
567             }
568         }
569         return false;
570     }
571 
572     function() public payable {
573         // Check in here that the sender is a contract! (to stop accidents)
574         uint256 size;
575         address sender = msg.sender;
576         assembly {
577             size := extcodesize(sender)
578         }
579         require(size > 0);
580     }
581 }