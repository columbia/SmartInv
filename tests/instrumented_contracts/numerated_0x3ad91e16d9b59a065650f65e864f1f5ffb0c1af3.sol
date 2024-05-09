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
324 /**
325  * @title Ownable
326  * @dev The Ownable contract has an owner address, and provides basic authorization control
327  * functions, this simplifies the implementation of "user permissions".
328  */
329 contract Ownable {
330   address public owner;
331 
332   event OwnershipRenounced(address indexed previousOwner);
333   event OwnershipTransferred(
334     address indexed previousOwner,
335     address indexed newOwner
336   );
337 
338   /**
339    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
340    * account.
341    */
342   constructor() public {
343     owner = msg.sender;
344   }
345 
346   /**
347    * @dev Throws if called by any account other than the owner.
348    */
349   modifier onlyOwner() {
350     require(msg.sender == owner);
351     _;
352   }
353 
354   /**
355    * @dev Allows the current owner to relinquish control of the contract.
356    * @notice Renouncing to ownership will leave the contract without an owner.
357    * It will not be possible to call the functions with the `onlyOwner`
358    * modifier anymore.
359    */
360   function renounceOwnership() public onlyOwner {
361     emit OwnershipRenounced(owner);
362     owner = address(0);
363   }
364 
365   /**
366    * @dev Allows the current owner to transfer control of the contract to a newOwner.
367    * @param _newOwner The address to transfer ownership to.
368    */
369   function transferOwnership(address _newOwner) public onlyOwner {
370     _transferOwnership(_newOwner);
371   }
372 
373   /**
374    * @dev Transfers control of the contract to a newOwner.
375    * @param _newOwner The address to transfer ownership to.
376    */
377   function _transferOwnership(address _newOwner) internal {
378     require(_newOwner != address(0));
379     emit OwnershipTransferred(owner, _newOwner);
380     owner = _newOwner;
381   }
382 }
383 
384 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
385 /// some functions
386 /// @dev Defines a modifier which should be used when only the totle contract should
387 /// able able to call a function
388 contract TotleControl is Ownable {
389     address public totlePrimary;
390 
391     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
392     modifier onlyTotle() {
393         require(msg.sender == totlePrimary);
394         _;
395     }
396 
397     /// @notice Contract constructor
398     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
399     /// @param _totlePrimary the address of the contract to be set as totlePrimary
400     constructor(address _totlePrimary) public {
401         require(_totlePrimary != address(0x0));
402         totlePrimary = _totlePrimary;
403     }
404 
405     /// @notice A function which allows only the owner to change the address of totlePrimary
406     /// @dev onlyOwner modifier only allows the contract owner to run the code
407     /// @param _totlePrimary the address of the contract to be set as totlePrimary
408     function setTotle(
409         address _totlePrimary
410     ) external onlyOwner {
411         require(_totlePrimary != address(0x0));
412         totlePrimary = _totlePrimary;
413     }
414 }
415 
416 /// @title A contract which allows its owner to withdraw any ether which is contained inside
417 contract Withdrawable is Ownable {
418 
419     /// @notice Withdraw ether contained in this contract and send it back to owner
420     /// @dev onlyOwner modifier only allows the contract owner to run the code
421     /// @param _token The address of the token that the user wants to withdraw
422     /// @param _amount The amount of tokens that the caller wants to withdraw
423     /// @return bool value indicating whether the transfer was successful
424     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
425         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
426     }
427 
428     /// @notice Withdraw ether contained in this contract and send it back to owner
429     /// @dev onlyOwner modifier only allows the contract owner to run the code
430     /// @param _amount The amount of ether that the caller wants to withdraw
431     function withdrawETH(uint256 _amount) external onlyOwner {
432         owner.transfer(_amount);
433     }
434 }
435 
436 /**
437  * @title Pausable
438  * @dev Base contract which allows children to implement an emergency stop mechanism.
439  */
440 contract Pausable is Ownable {
441   event Paused();
442   event Unpaused();
443 
444   bool private _paused = false;
445 
446   /**
447    * @return true if the contract is paused, false otherwise.
448    */
449   function paused() public view returns (bool) {
450     return _paused;
451   }
452 
453   /**
454    * @dev Modifier to make a function callable only when the contract is not paused.
455    */
456   modifier whenNotPaused() {
457     require(!_paused, "Contract is paused.");
458     _;
459   }
460 
461   /**
462    * @dev Modifier to make a function callable only when the contract is paused.
463    */
464   modifier whenPaused() {
465     require(_paused, "Contract not paused.");
466     _;
467   }
468 
469   /**
470    * @dev called by the owner to pause, triggers stopped state
471    */
472   function pause() public onlyOwner whenNotPaused {
473     _paused = true;
474     emit Paused();
475   }
476 
477   /**
478    * @dev called by the owner to unpause, returns to normal state
479    */
480   function unpause() public onlyOwner whenPaused {
481     _paused = false;
482     emit Unpaused();
483   }
484 }
485 
486 contract ErrorReporter {
487     function revertTx(string reason) public pure {
488         revert(reason);
489     }
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
735 /*
736 
737   Copyright 2018 ZeroEx Intl.
738 
739   Licensed under the Apache License, Version 2.0 (the "License");
740   you may not use this file except in compliance with the License.
741   You may obtain a copy of the License at
742 
743     http://www.apache.org/licenses/LICENSE-2.0
744 
745   Unless required by applicable law or agreed to in writing, software
746   distributed under the License is distributed on an "AS IS" BASIS,
747   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
748   See the License for the specific language governing permissions and
749   limitations under the License.
750 
751 */
752 
753 pragma solidity ^0.4.24;
754 
755 contract LibEIP712 {
756 
757     // EIP191 header for EIP712 prefix
758     string constant internal EIP191_HEADER = "\x19\x01";
759 
760     // EIP712 Domain Name value
761     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
762 
763     // EIP712 Domain Version value
764     string constant internal EIP712_DOMAIN_VERSION = "2";
765 
766     // Hash of the EIP712 Domain Separator Schema
767     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
768         "EIP712Domain(",
769         "string name,",
770         "string version,",
771         "address verifyingContract",
772         ")"
773     ));
774 
775     // Hash of the EIP712 Domain Separator data
776     // solhint-disable-next-line var-name-mixedcase
777     bytes32 public EIP712_DOMAIN_HASH;
778 
779     constructor ()
780         public
781     {
782         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
783             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
784             keccak256(bytes(EIP712_DOMAIN_NAME)),
785             keccak256(bytes(EIP712_DOMAIN_VERSION)),
786             bytes32(address(this))
787         ));
788     }
789 
790     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
791     /// @param hashStruct The EIP712 hash struct.
792     /// @return EIP712 hash applied to this EIP712 Domain.
793     function hashEIP712Message(bytes32 hashStruct)
794         internal
795         view
796         returns (bytes32 result)
797     {
798         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
799 
800         // Assembly for more efficient computing:
801         // keccak256(abi.encodePacked(
802         //     EIP191_HEADER,
803         //     EIP712_DOMAIN_HASH,
804         //     hashStruct
805         // ));
806 
807         assembly {
808             // Load free memory pointer
809             let memPtr := mload(64)
810 
811             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
812             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
813             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
814 
815             // Compute hash
816             result := keccak256(memPtr, 66)
817         }
818         return result;
819     }
820 }
821 
822 /*
823 
824   Copyright 2018 ZeroEx Intl.
825 
826   Licensed under the Apache License, Version 2.0 (the "License");
827   you may not use this file except in compliance with the License.
828   You may obtain a copy of the License at
829 
830     http://www.apache.org/licenses/LICENSE-2.0
831 
832   Unless required by applicable law or agreed to in writing, software
833   distributed under the License is distributed on an "AS IS" BASIS,
834   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
835   See the License for the specific language governing permissions and
836   limitations under the License.
837 
838 */
839 
840 contract LibOrder is
841     LibEIP712
842 {
843     // Hash for the EIP712 Order Schema
844     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
845         "Order(",
846         "address makerAddress,",
847         "address takerAddress,",
848         "address feeRecipientAddress,",
849         "address senderAddress,",
850         "uint256 makerAssetAmount,",
851         "uint256 takerAssetAmount,",
852         "uint256 makerFee,",
853         "uint256 takerFee,",
854         "uint256 expirationTimeSeconds,",
855         "uint256 salt,",
856         "bytes makerAssetData,",
857         "bytes takerAssetData",
858         ")"
859     ));
860 
861     // A valid order remains fillable until it is expired, fully filled, or cancelled.
862     // An order's state is unaffected by external factors, like account balances.
863     enum OrderStatus {
864         INVALID,                     // Default value
865         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
866         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
867         FILLABLE,                    // Order is fillable
868         EXPIRED,                     // Order has already expired
869         FULLY_FILLED,                // Order is fully filled
870         CANCELLED                    // Order has been cancelled
871     }
872 
873     // solhint-disable max-line-length
874     struct Order {
875         address makerAddress;           // Address that created the order.
876         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
877         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
878         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
879         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
880         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
881         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
882         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
883         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
884         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
885         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
886         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
887     }
888     // solhint-enable max-line-length
889 
890     struct OrderInfo {
891         uint8 orderStatus;                    // Status that describes order's validity and fillability.
892         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
893         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
894     }
895 
896     /// @dev Calculates Keccak-256 hash of the order.
897     /// @param order The order structure.
898     /// @return Keccak-256 EIP712 hash of the order.
899     function getOrderHash(Order memory order)
900         internal
901         view
902         returns (bytes32 orderHash)
903     {
904         orderHash = hashEIP712Message(hashOrder(order));
905         return orderHash;
906     }
907 
908     /// @dev Calculates EIP712 hash of the order.
909     /// @param order The order structure.
910     /// @return EIP712 hash of the order.
911     function hashOrder(Order memory order)
912         internal
913         pure
914         returns (bytes32 result)
915     {
916         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
917         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
918         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
919 
920         // Assembly for more efficiently computing:
921         // keccak256(abi.encodePacked(
922         //     EIP712_ORDER_SCHEMA_HASH,
923         //     bytes32(order.makerAddress),
924         //     bytes32(order.takerAddress),
925         //     bytes32(order.feeRecipientAddress),
926         //     bytes32(order.senderAddress),
927         //     order.makerAssetAmount,
928         //     order.takerAssetAmount,
929         //     order.makerFee,
930         //     order.takerFee,
931         //     order.expirationTimeSeconds,
932         //     order.salt,
933         //     keccak256(order.makerAssetData),
934         //     keccak256(order.takerAssetData)
935         // ));
936 
937         assembly {
938             // Calculate memory addresses that will be swapped out before hashing
939             let pos1 := sub(order, 32)
940             let pos2 := add(order, 320)
941             let pos3 := add(order, 352)
942 
943             // Backup
944             let temp1 := mload(pos1)
945             let temp2 := mload(pos2)
946             let temp3 := mload(pos3)
947 
948             // Hash in place
949             mstore(pos1, schemaHash)
950             mstore(pos2, makerAssetDataHash)
951             mstore(pos3, takerAssetDataHash)
952             result := keccak256(pos1, 416)
953 
954             // Restore
955             mstore(pos1, temp1)
956             mstore(pos2, temp2)
957             mstore(pos3, temp3)
958         }
959         return result;
960     }
961 }
962 
963 /*
964 
965   Copyright 2018 ZeroEx Intl.
966 
967   Licensed under the Apache License, Version 2.0 (the "License");
968   you may not use this file except in compliance with the License.
969   You may obtain a copy of the License at
970 
971     http://www.apache.org/licenses/LICENSE-2.0
972 
973   Unless required by applicable law or agreed to in writing, software
974   distributed under the License is distributed on an "AS IS" BASIS,
975   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
976   See the License for the specific language governing permissions and
977   limitations under the License.
978 
979 */
980 
981 contract LibFillResults
982 {
983     struct FillResults {
984         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
985         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
986         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
987         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
988     }
989 
990     struct MatchedFillResults {
991         FillResults left;                    // Amounts filled and fees paid of left order.
992         FillResults right;                   // Amounts filled and fees paid of right order.
993         uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
994     }
995 
996     /// @dev Adds properties of both FillResults instances.
997     ///      Modifies the first FillResults instance specified.
998     /// @param totalFillResults Fill results instance that will be added onto.
999     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
1000     function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
1001         internal
1002         pure
1003     {
1004         totalFillResults.makerAssetFilledAmount = SafeMath.add(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);
1005         totalFillResults.takerAssetFilledAmount = SafeMath.add(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);
1006         totalFillResults.makerFeePaid = SafeMath.add(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);
1007         totalFillResults.takerFeePaid = SafeMath.add(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);
1008     }
1009 }
1010 
1011 contract IExchangeCore {
1012 
1013     bytes public ZRX_ASSET_DATA;
1014 
1015     /// @dev Fills the input order.
1016     /// @param order Order struct containing order specifications.
1017     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1018     /// @param signature Proof that order has been created by maker.
1019     /// @return Amounts filled and fees paid by maker and taker.
1020     function fillOrder(
1021         LibOrder.Order memory order,
1022         uint256 takerAssetFillAmount,
1023         bytes memory signature
1024     )
1025         public
1026         returns (LibFillResults.FillResults memory fillResults);
1027 
1028     function fillOrderNoThrow(
1029         LibOrder.Order memory order,
1030         uint256 takerAssetFillAmount,
1031         bytes memory signature
1032     )
1033         public
1034         returns (LibFillResults.FillResults memory fillResults);
1035 
1036     /// @dev Gets information about an order: status, hash, and amount filled.
1037     /// @param order Order to gather information on.
1038     /// @return OrderInfo Information about the order and its state.
1039     ///                   See LibOrder.OrderInfo for a complete description.
1040     function getOrderInfo(LibOrder.Order memory order)
1041         public
1042         view
1043         returns (LibOrder.OrderInfo memory orderInfo);
1044 
1045     /// @dev Gets an asset proxy.
1046     /// @param assetProxyId Id of the asset proxy.
1047     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
1048     function getAssetProxy(bytes4 assetProxyId)
1049         external
1050         view
1051         returns (address);
1052 
1053     function isValidSignature(
1054         bytes32 hash,
1055         address signerAddress,
1056         bytes memory signature
1057     )
1058         public
1059         view
1060         returns (bool isValid);
1061 }
1062 
1063 interface WETH {
1064     function deposit() external payable;
1065     function withdraw(uint256 amount) external;
1066 }
1067 
1068 /// @title ZeroExExchangeSelectorProvider
1069 /// @notice Provides this exchange implementation with correctly formatted function selectors
1070 contract ZeroExExchangeSelectorProvider is SelectorProvider {
1071     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
1072         if (genericSelector == getAmountToGive) {
1073             return bytes4(keccak256("getAmountToGive_((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes,bytes))"));
1074         } else if (genericSelector == staticExchangeChecks) {
1075             return bytes4(keccak256("staticExchangeChecks_((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes,bytes))"));
1076         } else if (genericSelector == performBuyOrder) {
1077             return bytes4(keccak256("performBuyOrder_((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes,bytes))"));
1078         } else if (genericSelector == performSellOrder) {
1079             return bytes4(keccak256("performSellOrder_((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes,bytes))"));
1080         } else {
1081             return bytes4(0x0);
1082         }
1083     }
1084 }
1085 
1086 // "((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),bytes)"
1087 
1088 /// @title ZeroExExchangeHandler
1089 /// @notice Handles the all ZeroExExchange trades for the primary contract
1090 contract ZeroExExchangeHandler is ExchangeHandler, AllowanceSetter  {
1091 
1092     /*
1093     *   State Variables
1094     */
1095 
1096     IExchangeCore public exchange;
1097     /// @dev note that this is dependent on the deployment of 0xV2. This is the ERC20 asset proxy + the mainnet address of the ZRX token
1098     bytes constant ZRX_ASSET_DATA = "\xf4\x72\x61\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe4\x1d\x24\x89\x57\x1d\x32\x21\x89\x24\x6d\xaf\xa5\xeb\xde\x1f\x46\x99\xf4\x98";
1099     address ERC20_ASSET_PROXY;
1100     WETH weth;
1101 
1102     /*
1103     *   Types
1104     */
1105 
1106     /// @notice Constructor
1107     /// @param _exchange Address of the IExchangeCore exchange
1108     /// @param selectorProvider the provider for this exchanges function selectors
1109     /// @param totlePrimary the address of the totlePrimary contract
1110     constructor(
1111         address _exchange,
1112         address selectorProvider,
1113         address totlePrimary,
1114         address _weth,
1115         address errorReporter
1116         /* ,address logger */
1117     )
1118         ExchangeHandler(selectorProvider, totlePrimary, errorReporter/*, logger*/)
1119         public
1120     {
1121         require(_exchange != address(0x0));
1122         exchange = IExchangeCore(_exchange);
1123         ERC20_ASSET_PROXY = exchange.getAssetProxy(toBytes4(ZRX_ASSET_DATA, 0));
1124         weth = WETH(_weth);
1125     }
1126 
1127     struct OrderData {
1128         address makerAddress;           // Address that created the order.
1129         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
1130         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
1131         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
1132         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
1133         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
1134         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
1135         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
1136         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
1137         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
1138         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
1139         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
1140         bytes signature;
1141     }
1142 
1143     /*
1144     *   Public functions
1145     */
1146 
1147     /*
1148     *   Internal functions
1149     */
1150 
1151     /// @notice Gets the amount that Totle needs to give for this order
1152     /// @param data LibOrder.Order struct containing order values
1153     /// @return amountToGive amount taker needs to give in order to fill the order
1154     function getAmountToGive_(
1155         OrderData data
1156     )
1157       public
1158       view
1159       onlySelf
1160       returns (uint256 amountToGive)
1161     {
1162         LibOrder.OrderInfo memory orderInfo = exchange.getOrderInfo(
1163             getZeroExOrder(data)
1164         );
1165         uint makerAssetAvailable = getAssetDataAvailable(data.makerAssetData, data.makerAddress);
1166         uint feeAssetAvailable = getAssetDataAvailable(ZRX_ASSET_DATA, data.makerAddress);
1167 
1168         uint maxFromMakerFee = data.makerFee == 0 ? Utils.max_uint() : getPartialAmount(feeAssetAvailable, data.makerFee, data.takerAssetAmount);
1169         amountToGive = Math.min(Math.min(
1170             getPartialAmount(makerAssetAvailable, data.makerAssetAmount, data.takerAssetAmount),
1171             maxFromMakerFee),
1172             SafeMath.sub(data.takerAssetAmount, orderInfo.orderTakerAssetFilledAmount)
1173         );
1174         /* logger.log("Getting amountToGive from ZeroEx arg2: amountToGive", amountToGive); */
1175     }
1176 
1177     function getAssetDataAvailable(bytes assetData, address account) internal view returns (uint){
1178         address tokenAddress = toAddress(assetData, 16);
1179         ERC20 token = ERC20(tokenAddress);
1180         return Math.min(token.balanceOf(account), token.allowance(account, ERC20_ASSET_PROXY));
1181     }
1182 
1183     function getZeroExOrder(OrderData data) internal pure returns (LibOrder.Order) {
1184         return LibOrder.Order({
1185             makerAddress: data.makerAddress,
1186             takerAddress: data.takerAddress,
1187             feeRecipientAddress: data.feeRecipientAddress,
1188             senderAddress: data.senderAddress,
1189             makerAssetAmount: data.makerAssetAmount,
1190             takerAssetAmount: data.takerAssetAmount,
1191             makerFee: data.makerFee,
1192             takerFee: data.takerFee,
1193             expirationTimeSeconds: data.expirationTimeSeconds,
1194             salt: data.salt,
1195             makerAssetData: data.makerAssetData,
1196             takerAssetData: data.takerAssetData
1197         });
1198     }
1199 
1200     /// @notice Perform exchange-specific checks on the given order
1201     /// @dev This should be called to check for payload errors
1202     /// @param data LibOrder.Order struct containing order values
1203     /// @return checksPassed value representing pass or fail
1204     function staticExchangeChecks_(
1205         OrderData data
1206     )
1207         public
1208         view
1209         onlySelf
1210         returns (bool checksPassed)
1211     {
1212 
1213         // Make sure that:
1214         //  The order is not expired
1215         //  Both the maker and taker assets are ERC20 tokens
1216         //  The taker does not have to pay a fee (we don't support fees yet)
1217         //  We are permitted to take this order
1218         //  We are permitted to send this order
1219         // TODO: Should we check signatures here?
1220         return (block.timestamp <= data.expirationTimeSeconds &&
1221                 toBytes4(data.takerAssetData, 0) == bytes4(0xf47261b0) &&
1222                 toBytes4(data.makerAssetData, 0) == bytes4(0xf47261b0) &&
1223                 data.takerFee == 0 &&
1224                 (data.takerAddress == address(0x0) || data.takerAddress == address(this)) &&
1225                 (data.senderAddress == address(0x0) || data.senderAddress == address(this))
1226         );
1227     }
1228 
1229     /// @notice Perform a buy order at the exchange
1230     /// @param data LibOrder.Order struct containing order values
1231     /// @return amountSpentOnOrder the amount that would be spent on the order
1232     /// @return amountReceivedFromOrder the amount that was received from this order
1233     function performBuyOrder_(
1234         OrderData data
1235     )
1236         public
1237         payable
1238         onlySelf
1239         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
1240     {
1241         uint256 amountToGiveForOrder = toUint(msg.data, msg.data.length - 32);
1242 
1243         approveAddress(ERC20_ASSET_PROXY, toAddress(data.takerAssetData, 16));
1244 
1245         weth.deposit.value(amountToGiveForOrder)();
1246 
1247         LibFillResults.FillResults memory results = exchange.fillOrder(
1248             getZeroExOrder(data),
1249             amountToGiveForOrder,
1250             data.signature
1251         );
1252         require(ERC20SafeTransfer.safeTransfer(toAddress(data.makerAssetData, 16), totlePrimary, results.makerAssetFilledAmount));
1253 
1254         amountSpentOnOrder = results.takerAssetFilledAmount;
1255         amountReceivedFromOrder = results.makerAssetFilledAmount;
1256         /* logger.log("Performed buy order on ZeroEx arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1257     }
1258 
1259     /// @notice Perform a sell order at the exchange
1260     /// @param data LibOrder.Order struct containing order values
1261     /// @return amountSpentOnOrder the amount that would be spent on the order
1262     /// @return amountReceivedFromOrder the amount that was received from this order
1263     function performSellOrder_(
1264         OrderData data
1265     )
1266         public
1267         onlySelf
1268         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
1269     {
1270         uint256 amountToGiveForOrder = toUint(msg.data, msg.data.length - 32);
1271         approveAddress(ERC20_ASSET_PROXY, toAddress(data.takerAssetData, 16));
1272 
1273         LibFillResults.FillResults memory results = exchange.fillOrder(
1274             getZeroExOrder(data),
1275             amountToGiveForOrder,
1276             data.signature
1277         );
1278 
1279         weth.withdraw(results.makerAssetFilledAmount);
1280         totlePrimary.transfer(results.makerAssetFilledAmount);
1281 
1282         amountSpentOnOrder = results.takerAssetFilledAmount;
1283         amountReceivedFromOrder = results.makerAssetFilledAmount;
1284         /* logger.log("Performed sell order on ZeroEx arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1285     }
1286 
1287     /// @notice Calculate the result of ((numerator * target) / denominator)
1288     /// @param numerator the numerator in the equation
1289     /// @param denominator the denominator in the equation
1290     /// @param target the target for the equations
1291     /// @return partialAmount the resultant value
1292     function getPartialAmount(
1293         uint256 numerator,
1294         uint256 denominator,
1295         uint256 target
1296     )
1297         internal
1298         pure
1299         returns (uint256)
1300     {
1301         return SafeMath.div(SafeMath.mul(numerator, target), denominator);
1302     }
1303 
1304     // @notice Extract an address from a string of bytes
1305     // @param _bytes a string of at least 20 bytes
1306     // @param _start the offset of the address within the byte stream
1307     // @return tempAddress the address encoded in the bytestring beginning at _start
1308     function toAddress(bytes _bytes, uint _start) internal  pure returns (address) {
1309         require(_bytes.length >= (_start + 20));
1310         address tempAddress;
1311 
1312         assembly {
1313             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
1314         }
1315 
1316         return tempAddress;
1317     }
1318 
1319     function toBytes4(bytes _bytes, uint _start) internal pure returns (bytes4) {
1320         require(_bytes.length >= (_start + 4));
1321         bytes4 tempBytes4;
1322 
1323         assembly {
1324             tempBytes4 := mload(add(add(_bytes, 0x20), _start))
1325         }
1326         return tempBytes4;
1327     }
1328 
1329     // @notice Extract a uint256 from a string of bytes
1330     // @param _bytes a string of at least 32 bytes
1331     // @param _start the offset of the uint256 within the byte stream
1332     // @return tempUint the uint encoded in the bytestring beginning at _start
1333     function toUint(bytes _bytes, uint _start) internal  pure returns (uint256) {
1334         require(_bytes.length >= (_start + 32));
1335         uint256 tempUint;
1336 
1337         assembly {
1338             tempUint := mload(add(add(_bytes, 0x20), _start))
1339         }
1340 
1341         return tempUint;
1342     }
1343 
1344     /*
1345     *   Payable fallback function
1346     */
1347 
1348     /// @notice payable fallback to allow the exchange to return ether directly to this contract
1349     /// @dev note that only the exchange should be able to send ether to this contract
1350     function() public payable {
1351         require(msg.sender == address(weth) || msg.sender == totlePrimary);
1352     }
1353 }