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
395     mapping(address => bool) public authorizedPrimaries;
396 
397     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
398     modifier onlyTotle() {
399         require(authorizedPrimaries[msg.sender]);
400         _;
401     }
402 
403     /// @notice Contract constructor
404     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
405     /// @param _totlePrimary the address of the contract to be set as totlePrimary
406     constructor(address _totlePrimary) public {
407         authorizedPrimaries[_totlePrimary] = true;
408     }
409 
410     /// @notice A function which allows only the owner to change the address of totlePrimary
411     /// @dev onlyOwner modifier only allows the contract owner to run the code
412     /// @param _totlePrimary the address of the contract to be set as totlePrimary
413     function addTotle(
414         address _totlePrimary
415     ) external onlyOwner {
416         authorizedPrimaries[_totlePrimary] = true;
417     }
418 
419     function removeTotle(
420         address _totlePrimary
421     ) external onlyOwner {
422         authorizedPrimaries[_totlePrimary] = false;
423     }
424 }
425 
426 /// @title A contract which allows its owner to withdraw any ether which is contained inside
427 contract Withdrawable is Ownable {
428 
429     /// @notice Withdraw ether contained in this contract and send it back to owner
430     /// @dev onlyOwner modifier only allows the contract owner to run the code
431     /// @param _token The address of the token that the user wants to withdraw
432     /// @param _amount The amount of tokens that the caller wants to withdraw
433     /// @return bool value indicating whether the transfer was successful
434     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
435         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
436     }
437 
438     /// @notice Withdraw ether contained in this contract and send it back to owner
439     /// @dev onlyOwner modifier only allows the contract owner to run the code
440     /// @param _amount The amount of ether that the caller wants to withdraw
441     function withdrawETH(uint256 _amount) external onlyOwner {
442         owner.transfer(_amount);
443     }
444 }
445 
446 /**
447  * @title Pausable
448  * @dev Base contract which allows children to implement an emergency stop mechanism.
449  */
450 contract Pausable is Ownable {
451   event Paused();
452   event Unpaused();
453 
454   bool private _paused = false;
455 
456   /**
457    * @return true if the contract is paused, false otherwise.
458    */
459   function paused() public view returns (bool) {
460     return _paused;
461   }
462 
463   /**
464    * @dev Modifier to make a function callable only when the contract is not paused.
465    */
466   modifier whenNotPaused() {
467     require(!_paused, "Contract is paused.");
468     _;
469   }
470 
471   /**
472    * @dev Modifier to make a function callable only when the contract is paused.
473    */
474   modifier whenPaused() {
475     require(_paused, "Contract not paused.");
476     _;
477   }
478 
479   /**
480    * @dev called by the owner to pause, triggers stopped state
481    */
482   function pause() public onlyOwner whenNotPaused {
483     _paused = true;
484     emit Paused();
485   }
486 
487   /**
488    * @dev called by the owner to unpause, returns to normal state
489    */
490   function unpause() public onlyOwner whenPaused {
491     _paused = false;
492     emit Unpaused();
493   }
494 }
495 
496 contract SelectorProvider {
497     bytes4 constant getAmountToGiveSelector = bytes4(keccak256("getAmountToGive(bytes)"));
498     bytes4 constant staticExchangeChecksSelector = bytes4(keccak256("staticExchangeChecks(bytes)"));
499     bytes4 constant performBuyOrderSelector = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
500     bytes4 constant performSellOrderSelector = bytes4(keccak256("performSellOrder(bytes,uint256)"));
501 
502     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
503 }
504 
505 /// @title Interface for all exchange handler contracts
506 contract ExchangeHandler is SelectorProvider, TotleControl, Withdrawable, Pausable {
507 
508     /*
509     *   State Variables
510     */
511 
512     ErrorReporter public errorReporter;
513     /* Logger public logger; */
514     /*
515     *   Modifiers
516     */
517 
518     /// @notice Constructor
519     /// @dev Calls the constructor of the inherited TotleControl
520     /// @param totlePrimary the address of the totlePrimary contract
521     constructor(
522         address totlePrimary,
523         address _errorReporter
524         /* ,address _logger */
525     )
526         TotleControl(totlePrimary)
527         public
528     {
529         require(_errorReporter != address(0x0));
530         /* require(_logger != address(0x0)); */
531         errorReporter = ErrorReporter(_errorReporter);
532         /* logger = Logger(_logger); */
533     }
534 
535     /// @notice Gets the amount that Totle needs to give for this order
536     /// @param genericPayload the data for this order in a generic format
537     /// @return amountToGive amount taker needs to give in order to fill the order
538     function getAmountToGive(
539         bytes genericPayload
540     )
541         public
542         view
543         returns (uint256 amountToGive)
544     {
545         bool success;
546         bytes4 functionSelector = getSelector(this.getAmountToGive.selector);
547 
548         assembly {
549             let functionSelectorLength := 0x04
550             let functionSelectorOffset := 0x1C
551             let scratchSpace := 0x0
552             let wordLength := 0x20
553             let bytesLength := mload(genericPayload)
554             let totalLength := add(functionSelectorLength, bytesLength)
555             let startOfNewData := add(genericPayload, functionSelectorOffset)
556 
557             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
558             let functionSelectorCorrect := mload(scratchSpace)
559             mstore(genericPayload, functionSelectorCorrect)
560 
561             success := delegatecall(
562                             gas,
563                             address, // This address of the current contract
564                             startOfNewData, // Start data at the beginning of the functionSelector
565                             totalLength, // Total length of all data, including functionSelector
566                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
567                             wordLength // Length of return variable is one word
568                            )
569             amountToGive := mload(scratchSpace)
570             if eq(success, 0) { revert(0, 0) }
571         }
572     }
573 
574     /// @notice Perform exchange-specific checks on the given order
575     /// @dev this should be called to check for payload errors
576     /// @param genericPayload the data for this order in a generic format
577     /// @return checksPassed value representing pass or fail
578     function staticExchangeChecks(
579         bytes genericPayload
580     )
581         public
582         view
583         returns (bool checksPassed)
584     {
585         bool success;
586         bytes4 functionSelector = getSelector(this.staticExchangeChecks.selector);
587         assembly {
588             let functionSelectorLength := 0x04
589             let functionSelectorOffset := 0x1C
590             let scratchSpace := 0x0
591             let wordLength := 0x20
592             let bytesLength := mload(genericPayload)
593             let totalLength := add(functionSelectorLength, bytesLength)
594             let startOfNewData := add(genericPayload, functionSelectorOffset)
595 
596             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
597             let functionSelectorCorrect := mload(scratchSpace)
598             mstore(genericPayload, functionSelectorCorrect)
599 
600             success := delegatecall(
601                             gas,
602                             address, // This address of the current contract
603                             startOfNewData, // Start data at the beginning of the functionSelector
604                             totalLength, // Total length of all data, including functionSelector
605                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
606                             wordLength // Length of return variable is one word
607                            )
608             checksPassed := mload(scratchSpace)
609             if eq(success, 0) { revert(0, 0) }
610         }
611     }
612 
613     /// @notice Perform a buy order at the exchange
614     /// @param genericPayload the data for this order in a generic format
615     /// @param  amountToGiveForOrder amount that should be spent on this order
616     /// @return amountSpentOnOrder the amount that would be spent on the order
617     /// @return amountReceivedFromOrder the amount that was received from this order
618     function performBuyOrder(
619         bytes genericPayload,
620         uint256 amountToGiveForOrder
621     )
622         public
623         payable
624         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
625     {
626         bool success;
627         bytes4 functionSelector = getSelector(this.performBuyOrder.selector);
628         assembly {
629             let callDataOffset := 0x44
630             let functionSelectorOffset := 0x1C
631             let functionSelectorLength := 0x04
632             let scratchSpace := 0x0
633             let wordLength := 0x20
634             let startOfFreeMemory := mload(0x40)
635 
636             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
637 
638             let bytesLength := mload(startOfFreeMemory)
639             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
640 
641             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
642 
643             let functionSelectorCorrect := mload(scratchSpace)
644 
645             mstore(startOfFreeMemory, functionSelectorCorrect)
646 
647             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
648 
649             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
650 
651             success := delegatecall(
652                             gas,
653                             address, // This address of the current contract
654                             startOfNewData, // Start data at the beginning of the functionSelector
655                             totalLength, // Total length of all data, including functionSelector
656                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
657                             mul(wordLength, 0x02) // Length of return variables is two words
658                           )
659             amountSpentOnOrder := mload(scratchSpace)
660             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
661             if eq(success, 0) { revert(0, 0) }
662         }
663     }
664 
665     /// @notice Perform a sell order at the exchange
666     /// @param genericPayload the data for this order in a generic format
667     /// @param  amountToGiveForOrder amount that should be spent on this order
668     /// @return amountSpentOnOrder the amount that would be spent on the order
669     /// @return amountReceivedFromOrder the amount that was received from this order
670     function performSellOrder(
671         bytes genericPayload,
672         uint256 amountToGiveForOrder
673     )
674         public
675         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
676     {
677         bool success;
678         bytes4 functionSelector = getSelector(this.performSellOrder.selector);
679         assembly {
680             let callDataOffset := 0x44
681             let functionSelectorOffset := 0x1C
682             let functionSelectorLength := 0x04
683             let scratchSpace := 0x0
684             let wordLength := 0x20
685             let startOfFreeMemory := mload(0x40)
686 
687             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
688 
689             let bytesLength := mload(startOfFreeMemory)
690             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
691 
692             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
693 
694             let functionSelectorCorrect := mload(scratchSpace)
695 
696             mstore(startOfFreeMemory, functionSelectorCorrect)
697 
698             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
699 
700             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
701 
702             success := delegatecall(
703                             gas,
704                             address, // This address of the current contract
705                             startOfNewData, // Start data at the beginning of the functionSelector
706                             totalLength, // Total length of all data, including functionSelector
707                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
708                             mul(wordLength, 0x02) // Length of return variables is two words
709                           )
710             amountSpentOnOrder := mload(scratchSpace)
711             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
712             if eq(success, 0) { revert(0, 0) }
713         }
714     }
715 }
716 
717 contract Ethex {
718     function takeSellOrder(address token, uint256 tokenAmount, uint256 weiAmount, address seller) external payable;
719     function takeBuyOrder(address token, uint256 tokenAmount, uint256 weiAmount, uint256 totalTokens, address buyer) external;
720     function sellOrderBalances(bytes32 orderHash) external constant returns (uint256); //Returns number of tokens - e.g. available maker tokens
721     function buyOrderBalances(bytes32 orderHash) external constant returns (uint256); //Returns number of eth - e.g. available maker's eth
722     function makeFee() external constant returns (uint256);
723     function takeFee() external constant returns (uint256);
724     function feeFromTotalCostForAccount(uint256 totalCost, uint256 feeAmount, address account) external constant returns (uint256);
725     function calculateFeeForAccount(uint256 cost, uint256 feeAmount, address account) public constant returns (uint256);
726 }
727 
728 /// @title EthexHandler
729 /// @notice Handles the all EtherDelta trades for the primary contract
730 contract EthexHandler is ExchangeHandler, AllowanceSetter {
731 
732     /*
733     *   State Variables
734     */
735 
736     Ethex public exchange;
737 
738     /*
739     *   Types
740     */
741 
742     struct OrderData {
743         address token;       //Token address
744         uint256 tokenAmount; //Order's token amount
745         uint256 weiAmount;   //Order's wei amount
746         address maker;       //Person that created the order
747         bool isSell;         //True if sell order, false if buy order - This is from the Ethex order perspective. E.g. An Ethex sell order is a Totle buy order, so this is True.
748     }
749 
750     /// @notice Constructor
751     /// @param _exchange Address of the EtherDelta exchange
752     /// @param totlePrimary the address of the totlePrimary contract
753     /// @param errorReporter the address of the error reporter contract
754     constructor(
755         address _exchange,
756         address totlePrimary,
757         address errorReporter
758         /* ,address logger */
759     )
760         ExchangeHandler(totlePrimary, errorReporter/*, logger*/)
761         public
762     {
763         require(_exchange != address(0x0));
764         exchange = Ethex(_exchange);
765     }
766 
767     /*
768     *   Public functions
769     */
770 
771     /// @notice Gets the amount that Totle needs to give for this order
772     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
773     /// should only be called from functions which are inherited from the ExchangeHandler
774     /// base contract
775     /// @param order OrderData struct containing order values
776     /// @return amountToGive amount taker needs to give in order to fill the order
777     function getAmountToGive(
778         OrderData order
779     )
780         public
781         view
782         onlyTotle
783         returns (uint256 amountToGive)
784     {
785         bytes32 orderHash = hashOrder(order);
786         uint256 makeFee = exchange.makeFee();
787         uint256 takeFee = exchange.takeFee();
788         uint256 ethVolumeAvailable;
789         if(order.isSell){
790             uint256 tokenVolumeAvailable = Math.min(exchange.sellOrderBalances(orderHash), order.tokenAmount);
791             ethVolumeAvailable = SafeMath.div(SafeMath.mul(tokenVolumeAvailable, order.weiAmount), order.tokenAmount);
792             amountToGive = SafeMath.add(ethVolumeAvailable, feeFromTotalCost(ethVolumeAvailable, takeFee));
793         } else {
794             ethVolumeAvailable = Math.min(removeFee(exchange.buyOrderBalances(orderHash), makeFee), order.weiAmount);
795             amountToGive = SafeMath.div(SafeMath.mul(ethVolumeAvailable, order.tokenAmount), order.weiAmount);
796         }
797         /* logger.log("Remaining volume from Ethex", amountToGive); */
798     }
799 
800     /// @notice Perform exchange-specific checks on the given order
801     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
802     /// should only be called from functions which are inherited from the ExchangeHandler
803     /// base contract.
804     /// This should be called to check for payload errors.
805     /// @param order OrderData struct containing order values
806     /// @return checksPassed value representing pass or fail
807     function staticExchangeChecks(
808         OrderData order
809     )
810         public
811         view
812         onlyTotle
813         returns (bool checksPassed)
814     {
815         //Nothing to check
816         return true;
817     }
818 
819     /// @notice Perform a buy order at the exchange
820     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
821     /// should only be called from functions which are inherited from the ExchangeHandler
822     /// base contract
823     /// @param order OrderData struct containing order values
824     /// @param  amountToGiveForOrder amount that should be spent on this order
825     /// @return amountSpentOnOrder the amount that would be spent on the order
826     /// @return amountReceivedFromOrder the amount that was received from this order
827     function performBuyOrder(
828         OrderData order,
829         uint256 amountToGiveForOrder
830     )
831         public
832         payable
833         onlyTotle
834         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
835     {
836         uint256 takeFee = exchange.takeFee();
837         amountSpentOnOrder = amountToGiveForOrder;
838         uint256 amountSpentMinusFee = SafeMath.sub(amountSpentOnOrder, exchange.feeFromTotalCostForAccount(amountSpentOnOrder, takeFee, address(this)));
839         amountReceivedFromOrder = SafeMath.div(SafeMath.mul(amountSpentMinusFee, order.tokenAmount), order.weiAmount);
840         exchange.takeSellOrder.value(amountToGiveForOrder)(order.token, order.tokenAmount, order.weiAmount, order.maker);
841         if (!ERC20SafeTransfer.safeTransfer(order.token, msg.sender, amountReceivedFromOrder)) {
842             errorReporter.revertTx("Unable to transfer bought tokens to primary");
843         }
844     }
845 
846     /// @notice Perform a sell order at the exchange
847     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
848     /// should only be called from functions which are inherited from the ExchangeHandler
849     /// base contract
850     /// @param order OrderData struct containing order values
851     /// @param  amountToGiveForOrder amount that should be spent on this order
852     /// @return amountSpentOnOrder the amount that would be spent on the order
853     /// @return amountReceivedFromOrder the amount that was received from this order
854     function performSellOrder(
855         OrderData order,
856         uint256 amountToGiveForOrder
857     )
858         public
859         onlyTotle
860         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
861     {
862         approveAddress(address(exchange), order.token);
863         uint256 takeFee = exchange.takeFee();
864         amountSpentOnOrder = amountToGiveForOrder;
865         uint256 ethAmount = SafeMath.div(SafeMath.mul(amountSpentOnOrder, order.weiAmount), order.tokenAmount);
866         amountReceivedFromOrder = SafeMath.sub(ethAmount, exchange.calculateFeeForAccount(ethAmount, takeFee, address(this)));
867         exchange.takeBuyOrder(order.token, order.tokenAmount, order.weiAmount, amountSpentOnOrder, order.maker);
868         msg.sender.transfer(amountReceivedFromOrder);
869     }
870 
871     function hashOrder(OrderData order) internal pure returns (bytes32){
872         return sha256(order.token, order.tokenAmount, order.weiAmount, order.maker);
873     }
874 
875     function removeFee(uint256 cost, uint256 feeAmount) internal pure returns (uint256) {
876         return SafeMath.div(SafeMath.mul(cost, 1e18), SafeMath.add(1e18, feeAmount));
877     }
878 
879     function addFee(uint256 cost, uint256 feeAmount) internal pure returns (uint256) {
880         return SafeMath.div(SafeMath.mul(cost, 1e18), SafeMath.sub(1e18, feeAmount));
881     }
882 
883     function feeFromTotalCost(uint256 totalCost, uint256 feeAmount) public constant returns (uint256) {
884 
885         uint256 cost = SafeMath.mul(totalCost, (1 ether)) / SafeMath.add((1 ether), feeAmount);
886 
887         // Calculate ceil(cost).
888         uint256 remainder = SafeMath.mul(totalCost, (1 ether)) % SafeMath.add((1 ether), feeAmount);
889         if (remainder != 0) {
890             cost = SafeMath.add(cost, 1);
891         }
892 
893         uint256 fee = SafeMath.sub(totalCost, cost);
894         return fee;
895     }
896 
897     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
898         if (genericSelector == getAmountToGiveSelector) {
899             return bytes4(keccak256("getAmountToGive((address,uint256,uint256,address,bool))"));
900         } else if (genericSelector == staticExchangeChecksSelector) {
901             return bytes4(keccak256("staticExchangeChecks((address,uint256,uint256,address,bool))"));
902         } else if (genericSelector == performBuyOrderSelector) {
903             return bytes4(keccak256("performBuyOrder((address,uint256,uint256,address,bool),uint256)"));
904         } else if (genericSelector == performSellOrderSelector) {
905             return bytes4(keccak256("performSellOrder((address,uint256,uint256,address,bool),uint256)"));
906         } else {
907             return bytes4(0x0);
908         }
909     }
910 
911     /*
912     *   Payable fallback function
913     */
914 
915     /// @notice payable fallback to allow the exchange to return ether directly to this contract
916     /// @dev note that only the exchange should be able to send ether to this contract
917     function() public payable {
918         if (msg.sender != address(exchange)) {
919             errorReporter.revertTx("An address other than the exchange cannot send ether to EDHandler fallback");
920         }
921     }
922 }