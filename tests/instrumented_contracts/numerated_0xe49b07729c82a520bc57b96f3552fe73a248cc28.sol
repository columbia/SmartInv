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
178                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
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
338 
339   event OwnershipRenounced(address indexed previousOwner);
340   event OwnershipTransferred(
341     address indexed previousOwner,
342     address indexed newOwner
343   );
344 
345 
346   /**
347    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
348    * account.
349    */
350   constructor() public {
351     owner = msg.sender;
352   }
353 
354   /**
355    * @dev Throws if called by any account other than the owner.
356    */
357   modifier onlyOwner() {
358     require(msg.sender == owner);
359     _;
360   }
361 
362   /**
363    * @dev Allows the current owner to relinquish control of the contract.
364    * @notice Renouncing to ownership will leave the contract without an owner.
365    * It will not be possible to call the functions with the `onlyOwner`
366    * modifier anymore.
367    */
368   function renounceOwnership() public onlyOwner {
369     emit OwnershipRenounced(owner);
370     owner = address(0);
371   }
372 
373   /**
374    * @dev Allows the current owner to transfer control of the contract to a newOwner.
375    * @param _newOwner The address to transfer ownership to.
376    */
377   function transferOwnership(address _newOwner) public onlyOwner {
378     _transferOwnership(_newOwner);
379   }
380 
381   /**
382    * @dev Transfers control of the contract to a newOwner.
383    * @param _newOwner The address to transfer ownership to.
384    */
385   function _transferOwnership(address _newOwner) internal {
386     require(_newOwner != address(0));
387     emit OwnershipTransferred(owner, _newOwner);
388     owner = _newOwner;
389   }
390 }
391 
392 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
393 /// some functions
394 /// @dev Defines a modifier which should be used when only the totle contract should
395 /// able able to call a function
396 contract TotleControl is Ownable {
397     mapping(address => bool) public authorizedPrimaries;
398 
399     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
400     modifier onlyTotle() {
401         require(authorizedPrimaries[msg.sender]);
402         _;
403     }
404 
405     /// @notice Contract constructor
406     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
407     /// @param _totlePrimary the address of the contract to be set as totlePrimary
408     constructor(address _totlePrimary) public {
409         authorizedPrimaries[_totlePrimary] = true;
410     }
411 
412     /// @notice A function which allows only the owner to change the address of totlePrimary
413     /// @dev onlyOwner modifier only allows the contract owner to run the code
414     /// @param _totlePrimary the address of the contract to be set as totlePrimary
415     function addTotle(
416         address _totlePrimary
417     ) external onlyOwner {
418         authorizedPrimaries[_totlePrimary] = true;
419     }
420 
421     function removeTotle(
422         address _totlePrimary
423     ) external onlyOwner {
424         authorizedPrimaries[_totlePrimary] = false;
425     }
426 }
427 
428 /// @title A contract which allows its owner to withdraw any ether which is contained inside
429 contract Withdrawable is Ownable {
430 
431     /// @notice Withdraw ether contained in this contract and send it back to owner
432     /// @dev onlyOwner modifier only allows the contract owner to run the code
433     /// @param _token The address of the token that the user wants to withdraw
434     /// @param _amount The amount of tokens that the caller wants to withdraw
435     /// @return bool value indicating whether the transfer was successful
436     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
437         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
438     }
439 
440     /// @notice Withdraw ether contained in this contract and send it back to owner
441     /// @dev onlyOwner modifier only allows the contract owner to run the code
442     /// @param _amount The amount of ether that the caller wants to withdraw
443     function withdrawETH(uint256 _amount) external onlyOwner {
444         owner.transfer(_amount);
445     }
446 }
447 
448 /**
449  * @title Pausable
450  * @dev Base contract which allows children to implement an emergency stop mechanism.
451  */
452 contract Pausable is Ownable {
453   event Paused();
454   event Unpaused();
455 
456   bool private _paused = false;
457 
458   /**
459    * @return true if the contract is paused, false otherwise.
460    */
461   function paused() public view returns (bool) {
462     return _paused;
463   }
464 
465   /**
466    * @dev Modifier to make a function callable only when the contract is not paused.
467    */
468   modifier whenNotPaused() {
469     require(!_paused, "Contract is paused.");
470     _;
471   }
472 
473   /**
474    * @dev Modifier to make a function callable only when the contract is paused.
475    */
476   modifier whenPaused() {
477     require(_paused, "Contract not paused.");
478     _;
479   }
480 
481   /**
482    * @dev called by the owner to pause, triggers stopped state
483    */
484   function pause() public onlyOwner whenNotPaused {
485     _paused = true;
486     emit Paused();
487   }
488 
489   /**
490    * @dev called by the owner to unpause, returns to normal state
491    */
492   function unpause() public onlyOwner whenPaused {
493     _paused = false;
494     emit Unpaused();
495   }
496 }
497 
498 contract SelectorProvider {
499     bytes4 constant getAmountToGiveSelector = bytes4(keccak256("getAmountToGive(bytes)"));
500     bytes4 constant staticExchangeChecksSelector = bytes4(keccak256("staticExchangeChecks(bytes)"));
501     bytes4 constant performBuyOrderSelector = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
502     bytes4 constant performSellOrderSelector = bytes4(keccak256("performSellOrder(bytes,uint256)"));
503 
504     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
505 }
506 
507 /// @title Interface for all exchange handler contracts
508 contract ExchangeHandler is SelectorProvider, TotleControl, Withdrawable, Pausable {
509 
510     /*
511     *   State Variables
512     */
513 
514     ErrorReporter public errorReporter;
515     /* Logger public logger; */
516     /*
517     *   Modifiers
518     */
519 
520     /// @notice Constructor
521     /// @dev Calls the constructor of the inherited TotleControl
522     /// @param totlePrimary the address of the totlePrimary contract
523     constructor(
524         address totlePrimary,
525         address _errorReporter
526         /* ,address _logger */
527     )
528         TotleControl(totlePrimary)
529         public
530     {
531         require(_errorReporter != address(0x0));
532         /* require(_logger != address(0x0)); */
533         errorReporter = ErrorReporter(_errorReporter);
534         /* logger = Logger(_logger); */
535     }
536 
537     /// @notice Gets the amount that Totle needs to give for this order
538     /// @param genericPayload the data for this order in a generic format
539     /// @return amountToGive amount taker needs to give in order to fill the order
540     function getAmountToGive(
541         bytes genericPayload
542     )
543         public
544         view
545         returns (uint256 amountToGive)
546     {
547         bool success;
548         bytes4 functionSelector = getSelector(this.getAmountToGive.selector);
549 
550         assembly {
551             let functionSelectorLength := 0x04
552             let functionSelectorOffset := 0x1C
553             let scratchSpace := 0x0
554             let wordLength := 0x20
555             let bytesLength := mload(genericPayload)
556             let totalLength := add(functionSelectorLength, bytesLength)
557             let startOfNewData := add(genericPayload, functionSelectorOffset)
558 
559             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
560             let functionSelectorCorrect := mload(scratchSpace)
561             mstore(genericPayload, functionSelectorCorrect)
562 
563             success := delegatecall(
564                             gas,
565                             address, // This address of the current contract
566                             startOfNewData, // Start data at the beginning of the functionSelector
567                             totalLength, // Total length of all data, including functionSelector
568                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
569                             wordLength // Length of return variable is one word
570                            )
571             amountToGive := mload(scratchSpace)
572             if eq(success, 0) { revert(0, 0) }
573         }
574     }
575 
576     /// @notice Perform exchange-specific checks on the given order
577     /// @dev this should be called to check for payload errors
578     /// @param genericPayload the data for this order in a generic format
579     /// @return checksPassed value representing pass or fail
580     function staticExchangeChecks(
581         bytes genericPayload
582     )
583         public
584         view
585         returns (bool checksPassed)
586     {
587         bool success;
588         bytes4 functionSelector = getSelector(this.staticExchangeChecks.selector);
589         assembly {
590             let functionSelectorLength := 0x04
591             let functionSelectorOffset := 0x1C
592             let scratchSpace := 0x0
593             let wordLength := 0x20
594             let bytesLength := mload(genericPayload)
595             let totalLength := add(functionSelectorLength, bytesLength)
596             let startOfNewData := add(genericPayload, functionSelectorOffset)
597 
598             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
599             let functionSelectorCorrect := mload(scratchSpace)
600             mstore(genericPayload, functionSelectorCorrect)
601 
602             success := delegatecall(
603                             gas,
604                             address, // This address of the current contract
605                             startOfNewData, // Start data at the beginning of the functionSelector
606                             totalLength, // Total length of all data, including functionSelector
607                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
608                             wordLength // Length of return variable is one word
609                            )
610             checksPassed := mload(scratchSpace)
611             if eq(success, 0) { revert(0, 0) }
612         }
613     }
614 
615     /// @notice Perform a buy order at the exchange
616     /// @param genericPayload the data for this order in a generic format
617     /// @param  amountToGiveForOrder amount that should be spent on this order
618     /// @return amountSpentOnOrder the amount that would be spent on the order
619     /// @return amountReceivedFromOrder the amount that was received from this order
620     function performBuyOrder(
621         bytes genericPayload,
622         uint256 amountToGiveForOrder
623     )
624         public
625         payable
626         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
627     {
628         bool success;
629         bytes4 functionSelector = getSelector(this.performBuyOrder.selector);
630         assembly {
631             let callDataOffset := 0x44
632             let functionSelectorOffset := 0x1C
633             let functionSelectorLength := 0x04
634             let scratchSpace := 0x0
635             let wordLength := 0x20
636             let startOfFreeMemory := mload(0x40)
637 
638             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
639 
640             let bytesLength := mload(startOfFreeMemory)
641             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
642 
643             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
644 
645             let functionSelectorCorrect := mload(scratchSpace)
646 
647             mstore(startOfFreeMemory, functionSelectorCorrect)
648 
649             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
650 
651             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
652 
653             success := delegatecall(
654                             gas,
655                             address, // This address of the current contract
656                             startOfNewData, // Start data at the beginning of the functionSelector
657                             totalLength, // Total length of all data, including functionSelector
658                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
659                             mul(wordLength, 0x02) // Length of return variables is two words
660                           )
661             amountSpentOnOrder := mload(scratchSpace)
662             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
663             if eq(success, 0) { revert(0, 0) }
664         }
665     }
666 
667     /// @notice Perform a sell order at the exchange
668     /// @param genericPayload the data for this order in a generic format
669     /// @param  amountToGiveForOrder amount that should be spent on this order
670     /// @return amountSpentOnOrder the amount that would be spent on the order
671     /// @return amountReceivedFromOrder the amount that was received from this order
672     function performSellOrder(
673         bytes genericPayload,
674         uint256 amountToGiveForOrder
675     )
676         public
677         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
678     {
679         bool success;
680         bytes4 functionSelector = getSelector(this.performSellOrder.selector);
681         assembly {
682             let callDataOffset := 0x44
683             let functionSelectorOffset := 0x1C
684             let functionSelectorLength := 0x04
685             let scratchSpace := 0x0
686             let wordLength := 0x20
687             let startOfFreeMemory := mload(0x40)
688 
689             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
690 
691             let bytesLength := mload(startOfFreeMemory)
692             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
693 
694             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
695 
696             let functionSelectorCorrect := mload(scratchSpace)
697 
698             mstore(startOfFreeMemory, functionSelectorCorrect)
699 
700             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
701 
702             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
703 
704             success := delegatecall(
705                             gas,
706                             address, // This address of the current contract
707                             startOfNewData, // Start data at the beginning of the functionSelector
708                             totalLength, // Total length of all data, including functionSelector
709                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
710                             mul(wordLength, 0x02) // Length of return variables is two words
711                           )
712             amountSpentOnOrder := mload(scratchSpace)
713             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
714             if eq(success, 0) { revert(0, 0) }
715         }
716     }
717 }
718 
719 interface EtherDelta {
720     function deposit() external payable;
721     function withdraw(uint256 amount) external;
722     function depositToken(address token, uint256 amount) external;
723     function withdrawToken(address token, uint256 amount) external;
724     function trade(address tokenGet, uint256 amountGet, address tokenGive, uint256 amountGive, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s, uint256 amount) external;
725     function availableVolume(address tokenGet, uint256 amountGet, address tokenGive, uint256 amountGive, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s) external view returns (uint256);
726 }
727 
728 /// @title EtherDeltaHandler
729 /// @notice Handles the all EtherDelta trades for the primary contract
730 contract EtherDeltaHandler is ExchangeHandler, AllowanceSetter {
731 
732     /*
733     *   State Variables
734     */
735 
736     EtherDelta public exchange;
737 
738     /*
739     *   Types
740     */
741 
742     struct OrderData {
743         address user;
744         address tokenGive;
745         address tokenGet;
746         uint256 amountGive;
747         uint256 amountGet;
748         uint256 expires;
749         uint256 nonce;
750         uint8 v;
751         bytes32 r;
752         bytes32 s;
753         uint256 exchangeFee;
754     }
755 
756     /// @notice Constructor
757     /// @param _exchange Address of the EtherDelta exchange
758     /// @param totlePrimary the address of the totlePrimary contract
759     /// @param errorReporter the address of the error reporter contract
760     constructor(
761         address _exchange,
762         address totlePrimary,
763         address errorReporter
764         /* ,address logger */
765     )
766         ExchangeHandler(totlePrimary, errorReporter/*, logger*/)
767         public
768     {
769         require(_exchange != address(0x0));
770         exchange = EtherDelta(_exchange);
771     }
772 
773     /*
774     *   Public functions
775     */
776 
777     /// @notice Gets the amount that Totle needs to give for this order
778     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
779     /// should only be called from functions which are inherited from the ExchangeHandler
780     /// base contract
781     /// @param data OrderData struct containing order values
782     /// @return amountToGive amount taker needs to give in order to fill the order
783     function getAmountToGive(
784         OrderData data
785     )
786         public
787         view
788         onlyTotle
789         returns (uint256 amountToGive)
790     {
791         uint256 availableVolume = exchange.availableVolume(
792             data.tokenGet,
793             data.amountGet,
794             data.tokenGive,
795             data.amountGive,
796             data.expires,
797             data.nonce,
798             data.user,
799             data.v,
800             data.r,
801             data.s
802         );
803         /* logger.log("Getting available volume from Etherdelta", availableVolume); */
804         // Adds the exchange fee onto the available amount
805         amountToGive = getPartialAmount(availableVolume, SafeMath.sub(1 ether, data.exchangeFee), 1 ether);
806         /* logger.log("Removing fee from amountToGive", amountToGive); */
807     }
808 
809     /// @notice Perform exchange-specific checks on the given order
810     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
811     /// should only be called from functions which are inherited from the ExchangeHandler
812     /// base contract.
813     /// This should be called to check for payload errors.
814     /// @param data OrderData struct containing order values
815     /// @return checksPassed value representing pass or fail
816     function staticExchangeChecks(
817         OrderData data
818     )
819         public
820         view
821         onlyTotle
822         returns (bool checksPassed)
823     {
824         /* logger.log(block.number <= data.expires ? "Order isn't expired" : "Order is expired"); */
825         // Only one thing to check here
826         return block.number <= data.expires; // TODO - check if this is < or <=
827     }
828 
829     /// @notice Perform a buy order at the exchange
830     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
831     /// should only be called from functions which are inherited from the ExchangeHandler
832     /// base contract
833     /// @param data OrderData struct containing order values
834     /// @param  amountToGiveForOrder amount that should be spent on this order
835     /// @return amountSpentOnOrder the amount that would be spent on the order
836     /// @return amountReceivedFromOrder the amount that was received from this order
837     function performBuyOrder(
838         OrderData data,
839         uint256 amountToGiveForOrder
840     )
841         public
842         payable
843         onlyTotle
844         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
845     {
846         if (msg.value != amountToGiveForOrder) {
847             errorReporter.revertTx("msg.value != amountToGiveForOrder");
848         }
849         /* logger.log("Depositing eth to Etherdelta arg2: amountToGive, arg3: ethBalance", amountToGiveForOrder, address(this).balance); */
850         exchange.deposit.value(amountToGiveForOrder)();
851 
852         uint256 amountToTrade;
853         uint256 fee;
854 
855         (amountToTrade, fee) = substractFee(data.exchangeFee, amountToGiveForOrder);
856         /* logger.log("Removing fee from amountToGiveForOrder arg2: amountToGiveForOrder, arg3: amountToTrade, arg4: fee", amountToGiveForOrder, amountToTrade, fee); */
857         trade(data, amountToTrade);
858 
859         amountSpentOnOrder = amountToGiveForOrder;
860         amountReceivedFromOrder = getPartialAmount(data.amountGive, data.amountGet, amountToTrade);
861         /* logger.log("Withdrawing tokens from EtherDelta arg2: amountReceivedFromOrder, arg3: amountSpentOnOrder", amountReceivedFromOrder, amountSpentOnOrder); */
862         exchange.withdrawToken(data.tokenGive, amountReceivedFromOrder);
863 
864         if (!ERC20SafeTransfer.safeTransfer(data.tokenGive, msg.sender, amountReceivedFromOrder)) {
865             errorReporter.revertTx("Unable to transfer bought tokens to primary");
866         }
867     }
868 
869     /// @notice Perform a sell order at the exchange
870     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
871     /// should only be called from functions which are inherited from the ExchangeHandler
872     /// base contract
873     /// @param data OrderData struct containing order values
874     /// @param  amountToGiveForOrder amount that should be spent on this order
875     /// @return amountSpentOnOrder the amount that would be spent on the order
876     /// @return amountReceivedFromOrder the amount that was received from this order
877     function performSellOrder(
878         OrderData data,
879         uint256 amountToGiveForOrder
880     )
881         public
882         onlyTotle
883         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
884     {
885         approveAddress(address(exchange), data.tokenGet);
886         /* logger.log("Depositing tokens to EtherDelta arg2: amountToGiveForOrder", amountToGiveForOrder); */
887         exchange.depositToken(data.tokenGet, amountToGiveForOrder);
888 
889         uint256 amountToTrade;
890         uint256 fee;
891 
892         (amountToTrade, fee) = substractFee(data.exchangeFee, amountToGiveForOrder);
893         /* logger.log("arg2: amountToTrade, arg3: fee", amountToTrade, fee); */
894 
895         trade(data, amountToTrade);
896 
897         amountSpentOnOrder = amountToGiveForOrder;
898         amountReceivedFromOrder = getPartialAmount(data.amountGive, data.amountGet, amountToTrade);
899 
900         exchange.withdraw(amountReceivedFromOrder);
901         /* logger.log("Withdrawing ether arg2: amountReceived", amountReceivedFromOrder); */
902         msg.sender.transfer(amountReceivedFromOrder);
903     }
904 
905     /*
906     *   Internal functions
907     */
908 
909     /// @notice Performs the trade at the exchange
910     /// @dev It was necessary to separate this into a function due to limited stack space
911     /// @param data OrderData struct containing order values
912     /// @param amountToTrade amount that should be spent on this order
913     function trade(
914         OrderData data,
915         uint256 amountToTrade
916     )
917         internal
918     {
919         exchange.trade(
920             data.tokenGet,
921             data.amountGet,
922             data.tokenGive,
923             data.amountGive,
924             data.expires,
925             data.nonce,
926             data.user,
927             data.v,
928             data.r,
929             data.s,
930             amountToTrade
931         );
932     }
933 
934     /// @notice Subtract fee percentage from the amount give
935     /// @param feePercentage the percentage fee to deduct
936     /// @param  amount the amount that we should deduct from
937     /// @return amountMinusFee the amount that would be spent on the order
938     /// @return fee the amount that was received from this order
939     function substractFee(
940         uint256 feePercentage,
941         uint256 amount
942     )
943         public
944         pure
945         returns (uint256 amountMinusFee, uint256 fee)
946     {
947         fee = SafeMath.sub(amount, getPartialAmount(amount, SafeMath.add(feePercentage, 1 ether), 1 ether ));
948         amountMinusFee = SafeMath.sub(amount, fee);
949     }
950 
951     /// @notice Calculate the result of ((numerator * target) / denominator)
952     /// @param numerator the numerator in the equation
953     /// @param denominator the denominator in the equation
954     /// @param target the target for the equations
955     /// @return partialAmount the resultant value
956     function getPartialAmount(
957         uint256 numerator,
958         uint256 denominator,
959         uint256 target
960     )
961         internal
962         pure
963         returns (uint256)
964     {
965         return SafeMath.div(SafeMath.mul(numerator, target), denominator);
966     }
967 
968     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
969         if (genericSelector == getAmountToGiveSelector) {
970             return bytes4(keccak256("getAmountToGive((address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32,uint256))"));
971         } else if (genericSelector == staticExchangeChecksSelector) {
972             return bytes4(keccak256("staticExchangeChecks((address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32,uint256))"));
973         } else if (genericSelector == performBuyOrderSelector) {
974             return bytes4(keccak256("performBuyOrder((address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32,uint256),uint256)"));
975         } else if (genericSelector == performSellOrderSelector) {
976             return bytes4(keccak256("performSellOrder((address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32,uint256),uint256)"));
977         } else {
978             return bytes4(0x0);
979         }
980     }
981 
982     /*
983     *   Payable fallback function
984     */
985 
986     /// @notice payable fallback to allow the exchange to return ether directly to this contract
987     /// @dev note that only the exchange should be able to send ether to this contract
988     function() public payable {
989         if (msg.sender != address(exchange)) {
990             errorReporter.revertTx("An address other than the exchange cannot send ether to EDHandler fallback");
991         }
992     }
993 }