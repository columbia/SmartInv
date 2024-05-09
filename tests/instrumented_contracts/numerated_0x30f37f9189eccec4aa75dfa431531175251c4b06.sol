1 pragma solidity 0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     uint256 c = _a * _b;
22     require(c / _a == _b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     require(_b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     require(_b <= _a);
43     uint256 c = _a - _b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     uint256 c = _a + _b;
53     require(c >= _a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 /**
69  * @title Math
70  * @dev Assorted math operations
71  */
72 
73 library Math {
74   function max(uint256 a, uint256 b) internal pure returns (uint256) {
75     return a >= b ? a : b;
76   }
77 
78   function min(uint256 a, uint256 b) internal pure returns (uint256) {
79     return a < b ? a : b;
80   }
81 
82   function average(uint256 a, uint256 b) internal pure returns (uint256) {
83     // (a + b) / 2 can overflow, so we distribute
84     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
85   }
86 }
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 {
93   function totalSupply() public view returns (uint256);
94 
95   function balanceOf(address _who) public view returns (uint256);
96 
97   function allowance(address _owner, address _spender)
98     public view returns (uint256);
99 
100   function transfer(address _to, uint256 _value) public returns (bool);
101 
102   function approve(address _spender, uint256 _value)
103     public returns (bool);
104 
105   function transferFrom(address _from, address _to, uint256 _value)
106     public returns (bool);
107 
108   function decimals() public view returns (uint256);
109 
110   event Transfer(
111     address indexed from,
112     address indexed to,
113     uint256 value
114   );
115 
116   event Approval(
117     address indexed owner,
118     address indexed spender,
119     uint256 value
120   );
121 }
122 
123 /*
124     Modified Util contract as used by Kyber Network
125 */
126 
127 library Utils {
128 
129     uint256 constant internal PRECISION = (10**18);
130     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
131     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
132     uint256 constant internal MAX_DECIMALS = 18;
133     uint256 constant internal ETH_DECIMALS = 18;
134     uint256 constant internal MAX_UINT = 2**256-1;
135 
136     // Currently constants can't be accessed from other contracts, so providing functions to do that here
137     function precision() internal pure returns (uint256) { return PRECISION; }
138     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
139     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
140     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
141     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
142     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
143 
144     /// @notice Retrieve the number of decimals used for a given ERC20 token
145     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
146     /// ensure that an exception doesn't cause transaction failure
147     /// @param token the token for which we should retrieve the decimals
148     /// @return decimals the number of decimals in the given token
149     function getDecimals(address token)
150         internal
151         view
152         returns (uint256 decimals)
153     {
154         bytes4 functionSig = bytes4(keccak256("decimals()"));
155 
156         /// @dev Using assembly due to issues with current solidity `address.call()`
157         /// implementation: https://github.com/ethereum/solidity/issues/2884
158         assembly {
159             // Pointer to next free memory slot
160             let ptr := mload(0x40)
161             // Store functionSig variable at ptr
162             mstore(ptr,functionSig)
163             let functionSigLength := 0x04
164             let wordLength := 0x20
165 
166             let success := call(
167                                 5000, // Amount of gas
168                                 token, // Address to call
169                                 0, // ether to send
170                                 ptr, // ptr to input data
171                                 functionSigLength, // size of data
172                                 ptr, // where to store output data (overwrite input)
173                                 wordLength // size of output data (32 bytes)
174                                )
175 
176             switch success
177             case 0 {
178                 decimals := 18 // If the token doesn't implement `decimals()`, return 18 as default
179             }
180             case 1 {
181                 decimals := mload(ptr) // Set decimals to return data from call
182             }
183             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
184         }
185     }
186 
187     /// @dev Checks that a given address has its token allowance and balance set above the given amount
188     /// @param tokenOwner the address which should have custody of the token
189     /// @param tokenAddress the address of the token to check
190     /// @param tokenAmount the amount of the token which should be set
191     /// @param addressToAllow the address which should be allowed to transfer the token
192     /// @return bool true if the allowance and balance is set, false if not
193     function tokenAllowanceAndBalanceSet(
194         address tokenOwner,
195         address tokenAddress,
196         uint256 tokenAmount,
197         address addressToAllow
198     )
199         internal
200         view
201         returns (bool)
202     {
203         return (
204             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
205             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
206         );
207     }
208 
209     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
210         if (dstDecimals >= srcDecimals) {
211             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
212             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
213         } else {
214             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
215             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
216         }
217     }
218 
219     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
220 
221         //source quantity is rounded up. to avoid dest quantity being too low.
222         uint numerator;
223         uint denominator;
224         if (srcDecimals >= dstDecimals) {
225             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
226             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
227             denominator = rate;
228         } else {
229             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
230             numerator = (PRECISION * dstQty);
231             denominator = (rate * (10**(dstDecimals - srcDecimals)));
232         }
233         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
234     }
235 
236     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns (uint) {
237         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
238     }
239 
240     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns (uint) {
241         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
242     }
243 
244     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
245         internal pure returns (uint)
246     {
247         require(srcAmount <= MAX_QTY);
248         require(destAmount <= MAX_QTY);
249 
250         if (dstDecimals >= srcDecimals) {
251             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
252             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
253         } else {
254             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
255             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
256         }
257     }
258 
259     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
260     function min(uint256 a, uint256 b) internal pure returns (uint256) {
261         return a < b ? a : b;
262     }
263 }
264 
265 library ERC20SafeTransfer {
266     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
267 
268         require(_tokenAddress.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
269 
270         return fetchReturnData();
271     }
272 
273     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
274 
275         require(_tokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
276 
277         return fetchReturnData();
278     }
279 
280     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
281 
282         require(_tokenAddress.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
283 
284         return fetchReturnData();
285     }
286 
287     function fetchReturnData() internal returns (bool success){
288         assembly {
289             switch returndatasize()
290             case 0 {
291                 success := 1
292             }
293             case 32 {
294                 returndatacopy(0, 0, 32)
295                 success := mload(0)
296             }
297             default {
298                 revert(0, 0)
299             }
300         }
301     }
302 
303 }
304 
305 /// @title A contract which is used to check and set allowances of tokens
306 /// @dev In order to use this contract is must be inherited in the contract which is using
307 /// its functionality
308 contract AllowanceSetter {
309     uint256 constant MAX_UINT = 2**256 - 1;
310 
311     /// @notice A function which allows the caller to approve the max amount of any given token
312     /// @dev In order to function correctly, token allowances should not be set anywhere else in
313     /// the inheriting contract
314     /// @param addressToApprove the address which we want to approve to transfer the token
315     /// @param token the token address which we want to call approve on
316     function approveAddress(address addressToApprove, address token) internal {
317         if(ERC20(token).allowance(address(this), addressToApprove) == 0) {
318             require(ERC20SafeTransfer.safeApprove(token, addressToApprove, MAX_UINT));
319         }
320     }
321 
322 }
323 
324 contract ErrorReporter {
325     function revertTx(string reason) public pure {
326         revert(reason);
327     }
328 }
329 
330 /**
331  * @title Ownable
332  * @dev The Ownable contract has an owner address, and provides basic authorization control
333  * functions, this simplifies the implementation of "user permissions".
334  */
335 contract Ownable {
336   address public owner;
337 
338   event OwnershipRenounced(address indexed previousOwner);
339   event OwnershipTransferred(
340     address indexed previousOwner,
341     address indexed newOwner
342   );
343 
344   /**
345    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
346    * account.
347    */
348   constructor() public {
349     owner = msg.sender;
350   }
351 
352   /**
353    * @dev Throws if called by any account other than the owner.
354    */
355   modifier onlyOwner() {
356     require(msg.sender == owner);
357     _;
358   }
359 
360   /**
361    * @dev Allows the current owner to relinquish control of the contract.
362    * @notice Renouncing to ownership will leave the contract without an owner.
363    * It will not be possible to call the functions with the `onlyOwner`
364    * modifier anymore.
365    */
366   function renounceOwnership() public onlyOwner {
367     emit OwnershipRenounced(owner);
368     owner = address(0);
369   }
370 
371   /**
372    * @dev Allows the current owner to transfer control of the contract to a newOwner.
373    * @param _newOwner The address to transfer ownership to.
374    */
375   function transferOwnership(address _newOwner) public onlyOwner {
376     _transferOwnership(_newOwner);
377   }
378 
379   /**
380    * @dev Transfers control of the contract to a newOwner.
381    * @param _newOwner The address to transfer ownership to.
382    */
383   function _transferOwnership(address _newOwner) internal {
384     require(_newOwner != address(0));
385     emit OwnershipTransferred(owner, _newOwner);
386     owner = _newOwner;
387   }
388 }
389 
390 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
391 /// some functions
392 /// @dev Defines a modifier which should be used when only the totle contract should
393 /// able able to call a function
394 contract TotleControl is Ownable {
395     address public totlePrimary;
396 
397     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
398     modifier onlyTotle() {
399         require(msg.sender == totlePrimary);
400         _;
401     }
402 
403     /// @notice Contract constructor
404     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
405     /// @param _totlePrimary the address of the contract to be set as totlePrimary
406     constructor(address _totlePrimary) public {
407         require(_totlePrimary != address(0x0));
408         totlePrimary = _totlePrimary;
409     }
410 
411     /// @notice A function which allows only the owner to change the address of totlePrimary
412     /// @dev onlyOwner modifier only allows the contract owner to run the code
413     /// @param _totlePrimary the address of the contract to be set as totlePrimary
414     function setTotle(
415         address _totlePrimary
416     ) external onlyOwner {
417         require(_totlePrimary != address(0x0));
418         totlePrimary = _totlePrimary;
419     }
420 }
421 
422 /// @title A contract which allows its owner to withdraw any ether which is contained inside
423 contract Withdrawable is Ownable {
424 
425     /// @notice Withdraw ether contained in this contract and send it back to owner
426     /// @dev onlyOwner modifier only allows the contract owner to run the code
427     /// @param _token The address of the token that the user wants to withdraw
428     /// @param _amount The amount of tokens that the caller wants to withdraw
429     /// @return bool value indicating whether the transfer was successful
430     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
431         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
432     }
433 
434     /// @notice Withdraw ether contained in this contract and send it back to owner
435     /// @dev onlyOwner modifier only allows the contract owner to run the code
436     /// @param _amount The amount of ether that the caller wants to withdraw
437     function withdrawETH(uint256 _amount) external onlyOwner {
438         owner.transfer(_amount);
439     }
440 }
441 
442 /**
443  * @title Pausable
444  * @dev Base contract which allows children to implement an emergency stop mechanism.
445  */
446 contract Pausable is Ownable {
447   event Paused();
448   event Unpaused();
449 
450   bool private _paused = false;
451 
452   /**
453    * @return true if the contract is paused, false otherwise.
454    */
455   function paused() public view returns (bool) {
456     return _paused;
457   }
458 
459   /**
460    * @dev Modifier to make a function callable only when the contract is not paused.
461    */
462   modifier whenNotPaused() {
463     require(!_paused, "Contract is paused.");
464     _;
465   }
466 
467   /**
468    * @dev Modifier to make a function callable only when the contract is paused.
469    */
470   modifier whenPaused() {
471     require(_paused, "Contract not paused.");
472     _;
473   }
474 
475   /**
476    * @dev called by the owner to pause, triggers stopped state
477    */
478   function pause() public onlyOwner whenNotPaused {
479     _paused = true;
480     emit Paused();
481   }
482 
483   /**
484    * @dev called by the owner to unpause, returns to normal state
485    */
486   function unpause() public onlyOwner whenPaused {
487     _paused = false;
488     emit Unpaused();
489   }
490 }
491 
492 contract SelectorProvider {
493     bytes4 constant getAmountToGive = bytes4(keccak256("getAmountToGive(bytes)"));
494     bytes4 constant staticExchangeChecks = bytes4(keccak256("staticExchangeChecks(bytes)"));
495     bytes4 constant performBuyOrder = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
496     bytes4 constant performSellOrder = bytes4(keccak256("performSellOrder(bytes,uint256)"));
497 
498     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
499 }
500 
501 /// @title Interface for all exchange handler contracts
502 contract ExchangeHandler is TotleControl, Withdrawable, Pausable {
503 
504     /*
505     *   State Variables
506     */
507 
508     SelectorProvider public selectorProvider;
509     ErrorReporter public errorReporter;
510     /* Logger public logger; */
511     /*
512     *   Modifiers
513     */
514 
515     modifier onlySelf() {
516         require(msg.sender == address(this));
517         _;
518     }
519 
520     /// @notice Constructor
521     /// @dev Calls the constructor of the inherited TotleControl
522     /// @param _selectorProvider the provider for this exchanges function selectors
523     /// @param totlePrimary the address of the totlePrimary contract
524     constructor(
525         address _selectorProvider,
526         address totlePrimary,
527         address _errorReporter
528         /* ,address _logger */
529     )
530         TotleControl(totlePrimary)
531         public
532     {
533         require(_selectorProvider != address(0x0));
534         require(_errorReporter != address(0x0));
535         /* require(_logger != address(0x0)); */
536         selectorProvider = SelectorProvider(_selectorProvider);
537         errorReporter = ErrorReporter(_errorReporter);
538         /* logger = Logger(_logger); */
539     }
540 
541     /// @notice Gets the amount that Totle needs to give for this order
542     /// @param genericPayload the data for this order in a generic format
543     /// @return amountToGive amount taker needs to give in order to fill the order
544     function getAmountToGive(
545         bytes genericPayload
546     )
547         public
548         view
549         onlyTotle
550         whenNotPaused
551         returns (uint256 amountToGive)
552     {
553         bool success;
554         bytes4 functionSelector = selectorProvider.getSelector(this.getAmountToGive.selector);
555 
556         assembly {
557             let functionSelectorLength := 0x04
558             let functionSelectorOffset := 0x1C
559             let scratchSpace := 0x0
560             let wordLength := 0x20
561             let bytesLength := mload(genericPayload)
562             let totalLength := add(functionSelectorLength, bytesLength)
563             let startOfNewData := add(genericPayload, functionSelectorOffset)
564 
565             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
566             let functionSelectorCorrect := mload(scratchSpace)
567             mstore(genericPayload, functionSelectorCorrect)
568 
569             success := call(
570                             gas,
571                             address, // This address of the current contract
572                             callvalue,
573                             startOfNewData, // Start data at the beginning of the functionSelector
574                             totalLength, // Total length of all data, including functionSelector
575                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
576                             wordLength // Length of return variable is one word
577                            )
578             amountToGive := mload(scratchSpace)
579             if eq(success, 0) { revert(0, 0) }
580         }
581     }
582 
583     /// @notice Perform exchange-specific checks on the given order
584     /// @dev this should be called to check for payload errors
585     /// @param genericPayload the data for this order in a generic format
586     /// @return checksPassed value representing pass or fail
587     function staticExchangeChecks(
588         bytes genericPayload
589     )
590         public
591         view
592         onlyTotle
593         whenNotPaused
594         returns (bool checksPassed)
595     {
596         bool success;
597         bytes4 functionSelector = selectorProvider.getSelector(this.staticExchangeChecks.selector);
598         assembly {
599             let functionSelectorLength := 0x04
600             let functionSelectorOffset := 0x1C
601             let scratchSpace := 0x0
602             let wordLength := 0x20
603             let bytesLength := mload(genericPayload)
604             let totalLength := add(functionSelectorLength, bytesLength)
605             let startOfNewData := add(genericPayload, functionSelectorOffset)
606 
607             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
608             let functionSelectorCorrect := mload(scratchSpace)
609             mstore(genericPayload, functionSelectorCorrect)
610 
611             success := call(
612                             gas,
613                             address, // This address of the current contract
614                             callvalue,
615                             startOfNewData, // Start data at the beginning of the functionSelector
616                             totalLength, // Total length of all data, including functionSelector
617                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
618                             wordLength // Length of return variable is one word
619                            )
620             checksPassed := mload(scratchSpace)
621             if eq(success, 0) { revert(0, 0) }
622         }
623     }
624 
625     /// @notice Perform a buy order at the exchange
626     /// @param genericPayload the data for this order in a generic format
627     /// @param  amountToGiveForOrder amount that should be spent on this order
628     /// @return amountSpentOnOrder the amount that would be spent on the order
629     /// @return amountReceivedFromOrder the amount that was received from this order
630     function performBuyOrder(
631         bytes genericPayload,
632         uint256 amountToGiveForOrder
633     )
634         public
635         payable
636         onlyTotle
637         whenNotPaused
638         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
639     {
640         bool success;
641         bytes4 functionSelector = selectorProvider.getSelector(this.performBuyOrder.selector);
642         assembly {
643             let callDataOffset := 0x44
644             let functionSelectorOffset := 0x1C
645             let functionSelectorLength := 0x04
646             let scratchSpace := 0x0
647             let wordLength := 0x20
648             let startOfFreeMemory := mload(0x40)
649 
650             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
651 
652             let bytesLength := mload(startOfFreeMemory)
653             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
654 
655             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
656 
657             let functionSelectorCorrect := mload(scratchSpace)
658 
659             mstore(startOfFreeMemory, functionSelectorCorrect)
660 
661             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
662 
663             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
664 
665             success := call(
666                             gas,
667                             address, // This address of the current contract
668                             callvalue,
669                             startOfNewData, // Start data at the beginning of the functionSelector
670                             totalLength, // Total length of all data, including functionSelector
671                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
672                             mul(wordLength, 0x02) // Length of return variables is two words
673                           )
674             amountSpentOnOrder := mload(scratchSpace)
675             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
676             if eq(success, 0) { revert(0, 0) }
677         }
678     }
679 
680     /// @notice Perform a sell order at the exchange
681     /// @param genericPayload the data for this order in a generic format
682     /// @param  amountToGiveForOrder amount that should be spent on this order
683     /// @return amountSpentOnOrder the amount that would be spent on the order
684     /// @return amountReceivedFromOrder the amount that was received from this order
685     function performSellOrder(
686         bytes genericPayload,
687         uint256 amountToGiveForOrder
688     )
689         public
690         onlyTotle
691         whenNotPaused
692         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
693     {
694         bool success;
695         bytes4 functionSelector = selectorProvider.getSelector(this.performSellOrder.selector);
696         assembly {
697             let callDataOffset := 0x44
698             let functionSelectorOffset := 0x1C
699             let functionSelectorLength := 0x04
700             let scratchSpace := 0x0
701             let wordLength := 0x20
702             let startOfFreeMemory := mload(0x40)
703 
704             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
705 
706             let bytesLength := mload(startOfFreeMemory)
707             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
708 
709             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
710 
711             let functionSelectorCorrect := mload(scratchSpace)
712 
713             mstore(startOfFreeMemory, functionSelectorCorrect)
714 
715             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
716 
717             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
718 
719             success := call(
720                             gas,
721                             address, // This address of the current contract
722                             callvalue,
723                             startOfNewData, // Start data at the beginning of the functionSelector
724                             totalLength, // Total length of all data, including functionSelector
725                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
726                             mul(wordLength, 0x02) // Length of return variables is two words
727                           )
728             amountSpentOnOrder := mload(scratchSpace)
729             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
730             if eq(success, 0) { revert(0, 0) }
731         }
732     }
733 }
734 
735 contract Ethex {
736     function takeSellOrder(address token, uint256 tokenAmount, uint256 weiAmount, address seller) external payable;
737     function takeBuyOrder(address token, uint256 tokenAmount, uint256 weiAmount, uint256 totalTokens, address buyer) external;
738     function sellOrderBalances(bytes32 orderHash) external returns (uint256); //Returns number of tokens - e.g. available maker tokens
739     function buyOrderBalances(bytes32 orderHash) external returns (uint256); //Returns number of eth - e.g. available maker's eth
740     function makeFee() external constant returns (uint256);
741     function takeFee() external constant returns (uint256);
742     function feeFromTotalCostForAccount(uint256 totalCost, uint256 feeAmount, address account) external constant returns (uint256);
743     function calculateFeeForAccount(uint256 cost, uint256 feeAmount, address account) public constant returns (uint256);
744 }
745 
746 /// @title EtherDeltaSelectorProvider
747 /// @notice Provides this exchange implementation with correctly formatted function selectors
748 contract EthexSelectorProvider is SelectorProvider {
749     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
750         if (genericSelector == getAmountToGive) {
751             return bytes4(keccak256("getAmountToGive((address,uint256,uint256,address,bool))"));
752         } else if (genericSelector == staticExchangeChecks) {
753             return bytes4(keccak256("staticExchangeChecks((address,uint256,uint256,address,bool))"));
754         } else if (genericSelector == performBuyOrder) {
755             return bytes4(keccak256("performBuyOrder((address,uint256,uint256,address,bool),uint256)"));
756         } else if (genericSelector == performSellOrder) {
757             return bytes4(keccak256("performSellOrder((address,uint256,uint256,address,bool),uint256)"));
758         } else {
759             return bytes4(0x0);
760         }
761     }
762 }
763 
764 /// @title EthexHandler
765 /// @notice Handles the all EtherDelta trades for the primary contract
766 contract EthexHandler is ExchangeHandler, AllowanceSetter {
767 
768     /*
769     *   State Variables
770     */
771 
772     Ethex public exchange;
773 
774     /*
775     *   Types
776     */
777 
778     struct OrderData {
779         address token;       //Token address
780         uint256 tokenAmount; //Order's token amount
781         uint256 weiAmount;   //Order's wei amount
782         address maker;       //Person that created the order
783         bool isSell;         //True if sell order, false if buy order - This is from the Ethex order perspective. E.g. An Ethex sell order is a Totle buy order, so this is True.
784     }
785 
786     /// @notice Constructor
787     /// @param _exchange Address of the EtherDelta exchange
788     /// @param selectorProvider the provider for this exchanges function selectors
789     /// @param totlePrimary the address of the totlePrimary contract
790     /// @param errorReporter the address of the error reporter contract
791     constructor(
792         address _exchange,
793         address selectorProvider,
794         address totlePrimary,
795         address errorReporter
796         /* ,address logger */
797     )
798         ExchangeHandler(selectorProvider, totlePrimary, errorReporter/*, logger*/)
799         public
800     {
801         require(_exchange != address(0x0));
802         exchange = Ethex(_exchange);
803     }
804 
805     /*
806     *   Public functions
807     */
808 
809     /// @notice Gets the amount that Totle needs to give for this order
810     /// @dev Uses the `onlySelf` modifier with public visibility as this function
811     /// should only be called from functions which are inherited from the ExchangeHandler
812     /// base contract
813     /// @param order OrderData struct containing order values
814     /// @return amountToGive amount taker needs to give in order to fill the order
815     function getAmountToGive(
816         OrderData order
817     )
818         public
819         view
820         onlySelf
821         returns (uint256 amountToGive)
822     {
823         bytes32 orderHash = hashOrder(order);
824         uint256 makeFee = exchange.makeFee();
825         uint256 takeFee = exchange.takeFee();
826         uint256 ethVolumeAvailable;
827         if(order.isSell){
828             uint256 tokenVolumeAvailable = Math.min(exchange.sellOrderBalances(orderHash), order.tokenAmount);
829             ethVolumeAvailable = SafeMath.div(SafeMath.mul(tokenVolumeAvailable, order.weiAmount), order.tokenAmount);
830             amountToGive = SafeMath.add(ethVolumeAvailable, feeFromTotalCost(ethVolumeAvailable, takeFee));
831         } else {
832             ethVolumeAvailable = Math.min(removeFee(exchange.buyOrderBalances(orderHash), makeFee), order.weiAmount);
833             amountToGive = SafeMath.div(SafeMath.mul(ethVolumeAvailable, order.tokenAmount), order.weiAmount);
834         }
835         /* logger.log("Remaining volume from weiDex", amountToGive); */
836     }
837 
838     /// @notice Perform exchange-specific checks on the given order
839     /// @dev Uses the `onlySelf` modifier with public visibility as this function
840     /// should only be called from functions which are inherited from the ExchangeHandler
841     /// base contract.
842     /// This should be called to check for payload errors.
843     /// @param order OrderData struct containing order values
844     /// @return checksPassed value representing pass or fail
845     function staticExchangeChecks(
846         OrderData order
847     )
848         public
849         view
850         onlySelf
851         returns (bool checksPassed)
852     {
853         //Nothing to check
854         return true;
855     }
856 
857     /// @notice Perform a buy order at the exchange
858     /// @dev Uses the `onlySelf` modifier with public visibility as this function
859     /// should only be called from functions which are inherited from the ExchangeHandler
860     /// base contract
861     /// @param order OrderData struct containing order values
862     /// @param  amountToGiveForOrder amount that should be spent on this order
863     /// @return amountSpentOnOrder the amount that would be spent on the order
864     /// @return amountReceivedFromOrder the amount that was received from this order
865     function performBuyOrder(
866         OrderData order,
867         uint256 amountToGiveForOrder
868     )
869         public
870         payable
871         onlySelf
872         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
873     {
874         uint256 takeFee = exchange.takeFee();
875         amountSpentOnOrder = amountToGiveForOrder;
876         uint256 amountSpentMinusFee = SafeMath.sub(amountSpentOnOrder, exchange.feeFromTotalCostForAccount(amountSpentOnOrder, takeFee, address(this)));
877         amountReceivedFromOrder = SafeMath.div(SafeMath.mul(amountSpentMinusFee, order.tokenAmount), order.weiAmount);
878         exchange.takeSellOrder.value(amountToGiveForOrder)(order.token, order.tokenAmount, order.weiAmount, order.maker);
879         if (!ERC20SafeTransfer.safeTransfer(order.token, totlePrimary, amountReceivedFromOrder)) {
880             errorReporter.revertTx("Unable to transfer bought tokens to primary");
881         }
882     }
883 
884     /// @notice Perform a sell order at the exchange
885     /// @dev Uses the `onlySelf` modifier with public visibility as this function
886     /// should only be called from functions which are inherited from the ExchangeHandler
887     /// base contract
888     /// @param order OrderData struct containing order values
889     /// @param  amountToGiveForOrder amount that should be spent on this order
890     /// @return amountSpentOnOrder the amount that would be spent on the order
891     /// @return amountReceivedFromOrder the amount that was received from this order
892     function performSellOrder(
893         OrderData order,
894         uint256 amountToGiveForOrder
895     )
896         public
897         onlySelf
898         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
899     {
900         approveAddress(address(exchange), order.token);
901         uint256 takeFee = exchange.takeFee();
902         amountSpentOnOrder = amountToGiveForOrder;
903         uint256 ethAmount = SafeMath.div(SafeMath.mul(amountSpentOnOrder, order.weiAmount), order.tokenAmount);
904         amountReceivedFromOrder = SafeMath.sub(ethAmount, exchange.calculateFeeForAccount(ethAmount, takeFee, address(this)));
905         exchange.takeBuyOrder(order.token, order.tokenAmount, order.weiAmount, amountSpentOnOrder, order.maker);
906         totlePrimary.transfer(amountReceivedFromOrder);
907     }
908 
909     function hashOrder(OrderData order) internal pure returns (bytes32){
910         return sha256(order.token, order.tokenAmount, order.weiAmount, order.maker);
911     }
912 
913     function removeFee(uint256 cost, uint256 feeAmount) internal pure returns (uint256) {
914         return SafeMath.div(SafeMath.mul(cost, 1e18), SafeMath.add(1e18, feeAmount));
915     }
916 
917     function addFee(uint256 cost, uint256 feeAmount) internal pure returns (uint256) {
918         return SafeMath.div(SafeMath.mul(cost, 1e18), SafeMath.sub(1e18, feeAmount));
919     }
920 
921     function feeFromTotalCost(uint256 totalCost, uint256 feeAmount) public constant returns (uint256) {
922 
923         uint256 cost = SafeMath.mul(totalCost, (1 ether)) / SafeMath.add((1 ether), feeAmount);
924 
925         // Calculate ceil(cost).
926         uint256 remainder = SafeMath.mul(totalCost, (1 ether)) % SafeMath.add((1 ether), feeAmount);
927         if (remainder != 0) {
928             cost = SafeMath.add(cost, 1);
929         }
930 
931         uint256 fee = SafeMath.sub(totalCost, cost);
932         return fee;
933     }
934 
935     /*
936     *   Payable fallback function
937     */
938 
939     /// @notice payable fallback to allow the exchange to return ether directly to this contract
940     /// @dev note that only the exchange should be able to send ether to this contract
941     function() public payable {
942         if (msg.sender != address(exchange)) {
943             errorReporter.revertTx("An address other than the exchange cannot send ether to EDHandler fallback");
944         }
945     }
946 }