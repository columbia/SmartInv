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
389     mapping(address => bool) public authorizedPrimaries;
390 
391     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
392     modifier onlyTotle() {
393         require(authorizedPrimaries[msg.sender]);
394         _;
395     }
396 
397     /// @notice Contract constructor
398     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
399     /// @param _totlePrimary the address of the contract to be set as totlePrimary
400     constructor(address _totlePrimary) public {
401         authorizedPrimaries[_totlePrimary] = true;
402     }
403 
404     /// @notice A function which allows only the owner to change the address of totlePrimary
405     /// @dev onlyOwner modifier only allows the contract owner to run the code
406     /// @param _totlePrimary the address of the contract to be set as totlePrimary
407     function addTotle(
408         address _totlePrimary
409     ) external onlyOwner {
410         authorizedPrimaries[_totlePrimary] = true;
411     }
412 
413     function removeTotle(
414         address _totlePrimary
415     ) external onlyOwner {
416         authorizedPrimaries[_totlePrimary] = false;
417     }
418 }
419 
420 /// @title A contract which allows its owner to withdraw any ether which is contained inside
421 contract Withdrawable is Ownable {
422 
423     /// @notice Withdraw ether contained in this contract and send it back to owner
424     /// @dev onlyOwner modifier only allows the contract owner to run the code
425     /// @param _token The address of the token that the user wants to withdraw
426     /// @param _amount The amount of tokens that the caller wants to withdraw
427     /// @return bool value indicating whether the transfer was successful
428     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
429         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
430     }
431 
432     /// @notice Withdraw ether contained in this contract and send it back to owner
433     /// @dev onlyOwner modifier only allows the contract owner to run the code
434     /// @param _amount The amount of ether that the caller wants to withdraw
435     function withdrawETH(uint256 _amount) external onlyOwner {
436         owner.transfer(_amount);
437     }
438 }
439 
440 /**
441  * @title Pausable
442  * @dev Base contract which allows children to implement an emergency stop mechanism.
443  */
444 contract Pausable is Ownable {
445   event Paused();
446   event Unpaused();
447 
448   bool private _paused = false;
449 
450   /**
451    * @return true if the contract is paused, false otherwise.
452    */
453   function paused() public view returns (bool) {
454     return _paused;
455   }
456 
457   /**
458    * @dev Modifier to make a function callable only when the contract is not paused.
459    */
460   modifier whenNotPaused() {
461     require(!_paused, "Contract is paused.");
462     _;
463   }
464 
465   /**
466    * @dev Modifier to make a function callable only when the contract is paused.
467    */
468   modifier whenPaused() {
469     require(_paused, "Contract not paused.");
470     _;
471   }
472 
473   /**
474    * @dev called by the owner to pause, triggers stopped state
475    */
476   function pause() public onlyOwner whenNotPaused {
477     _paused = true;
478     emit Paused();
479   }
480 
481   /**
482    * @dev called by the owner to unpause, returns to normal state
483    */
484   function unpause() public onlyOwner whenPaused {
485     _paused = false;
486     emit Unpaused();
487   }
488 }
489 
490 contract ErrorReporter {
491     function revertTx(string reason) public pure {
492         revert(reason);
493     }
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
717 /*
718 
719   Copyright 2018 ZeroEx Intl.
720 
721   Licensed under the Apache License, Version 2.0 (the "License");
722   you may not use this file except in compliance with the License.
723   You may obtain a copy of the License at
724 
725     http://www.apache.org/licenses/LICENSE-2.0
726 
727   Unless required by applicable law or agreed to in writing, software
728   distributed under the License is distributed on an "AS IS" BASIS,
729   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
730   See the License for the specific language governing permissions and
731   limitations under the License.
732 
733 */
734 
735 contract LibEIP712 {
736 
737     // EIP191 header for EIP712 prefix
738     string constant internal EIP191_HEADER = "\x19\x01";
739 
740     // EIP712 Domain Name value
741     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
742 
743     // EIP712 Domain Version value
744     string constant internal EIP712_DOMAIN_VERSION = "2";
745 
746     // Hash of the EIP712 Domain Separator Schema
747     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
748         "EIP712Domain(",
749         "string name,",
750         "string version,",
751         "address verifyingContract",
752         ")"
753     ));
754 
755     // Hash of the EIP712 Domain Separator data
756     // solhint-disable-next-line var-name-mixedcase
757     bytes32 public EIP712_DOMAIN_HASH;
758 
759     constructor ()
760         public
761     {
762         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
763             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
764             keccak256(bytes(EIP712_DOMAIN_NAME)),
765             keccak256(bytes(EIP712_DOMAIN_VERSION)),
766             bytes32(address(this))
767         ));
768     }
769 
770     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
771     /// @param hashStruct The EIP712 hash struct.
772     /// @return EIP712 hash applied to this EIP712 Domain.
773     function hashEIP712Message(bytes32 hashStruct)
774         internal
775         view
776         returns (bytes32 result)
777     {
778         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
779 
780         // Assembly for more efficient computing:
781         // keccak256(abi.encodePacked(
782         //     EIP191_HEADER,
783         //     EIP712_DOMAIN_HASH,
784         //     hashStruct
785         // ));
786 
787         assembly {
788             // Load free memory pointer
789             let memPtr := mload(64)
790 
791             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
792             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
793             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
794 
795             // Compute hash
796             result := keccak256(memPtr, 66)
797         }
798         return result;
799     }
800 }
801 
802 /*
803 
804   Copyright 2018 ZeroEx Intl.
805 
806   Licensed under the Apache License, Version 2.0 (the "License");
807   you may not use this file except in compliance with the License.
808   You may obtain a copy of the License at
809 
810     http://www.apache.org/licenses/LICENSE-2.0
811 
812   Unless required by applicable law or agreed to in writing, software
813   distributed under the License is distributed on an "AS IS" BASIS,
814   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
815   See the License for the specific language governing permissions and
816   limitations under the License.
817 
818 */
819 
820 contract LibOrder is
821     LibEIP712
822 {
823     // Hash for the EIP712 Order Schema
824     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
825         "Order(",
826         "address makerAddress,",
827         "address takerAddress,",
828         "address feeRecipientAddress,",
829         "address senderAddress,",
830         "uint256 makerAssetAmount,",
831         "uint256 takerAssetAmount,",
832         "uint256 makerFee,",
833         "uint256 takerFee,",
834         "uint256 expirationTimeSeconds,",
835         "uint256 salt,",
836         "bytes makerAssetData,",
837         "bytes takerAssetData",
838         ")"
839     ));
840 
841     // A valid order remains fillable until it is expired, fully filled, or cancelled.
842     // An order's state is unaffected by external factors, like account balances.
843     enum OrderStatus {
844         INVALID,                     // Default value
845         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
846         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
847         FILLABLE,                    // Order is fillable
848         EXPIRED,                     // Order has already expired
849         FULLY_FILLED,                // Order is fully filled
850         CANCELLED                    // Order has been cancelled
851     }
852 
853     // solhint-disable max-line-length
854     struct Order {
855         address makerAddress;           // Address that created the order.
856         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
857         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
858         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
859         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
860         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
861         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
862         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
863         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
864         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
865         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
866         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
867     }
868     // solhint-enable max-line-length
869 
870     struct OrderInfo {
871         uint8 orderStatus;                    // Status that describes order's validity and fillability.
872         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
873         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
874     }
875 
876     /// @dev Calculates Keccak-256 hash of the order.
877     /// @param order The order structure.
878     /// @return Keccak-256 EIP712 hash of the order.
879     function getOrderHash(Order memory order)
880         internal
881         view
882         returns (bytes32 orderHash)
883     {
884         orderHash = hashEIP712Message(hashOrder(order));
885         return orderHash;
886     }
887 
888     /// @dev Calculates EIP712 hash of the order.
889     /// @param order The order structure.
890     /// @return EIP712 hash of the order.
891     function hashOrder(Order memory order)
892         internal
893         pure
894         returns (bytes32 result)
895     {
896         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
897         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
898         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
899 
900         // Assembly for more efficiently computing:
901         // keccak256(abi.encodePacked(
902         //     EIP712_ORDER_SCHEMA_HASH,
903         //     bytes32(order.makerAddress),
904         //     bytes32(order.takerAddress),
905         //     bytes32(order.feeRecipientAddress),
906         //     bytes32(order.senderAddress),
907         //     order.makerAssetAmount,
908         //     order.takerAssetAmount,
909         //     order.makerFee,
910         //     order.takerFee,
911         //     order.expirationTimeSeconds,
912         //     order.salt,
913         //     keccak256(order.makerAssetData),
914         //     keccak256(order.takerAssetData)
915         // ));
916 
917         assembly {
918             // Calculate memory addresses that will be swapped out before hashing
919             let pos1 := sub(order, 32)
920             let pos2 := add(order, 320)
921             let pos3 := add(order, 352)
922 
923             // Backup
924             let temp1 := mload(pos1)
925             let temp2 := mload(pos2)
926             let temp3 := mload(pos3)
927 
928             // Hash in place
929             mstore(pos1, schemaHash)
930             mstore(pos2, makerAssetDataHash)
931             mstore(pos3, takerAssetDataHash)
932             result := keccak256(pos1, 416)
933 
934             // Restore
935             mstore(pos1, temp1)
936             mstore(pos2, temp2)
937             mstore(pos3, temp3)
938         }
939         return result;
940     }
941 }
942 
943 /*
944 
945   Copyright 2018 ZeroEx Intl.
946 
947   Licensed under the Apache License, Version 2.0 (the "License");
948   you may not use this file except in compliance with the License.
949   You may obtain a copy of the License at
950 
951     http://www.apache.org/licenses/LICENSE-2.0
952 
953   Unless required by applicable law or agreed to in writing, software
954   distributed under the License is distributed on an "AS IS" BASIS,
955   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
956   See the License for the specific language governing permissions and
957   limitations under the License.
958 
959 */
960 
961 contract LibFillResults
962 {
963     struct FillResults {
964         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
965         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
966         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
967         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
968     }
969 
970     struct MatchedFillResults {
971         FillResults left;                    // Amounts filled and fees paid of left order.
972         FillResults right;                   // Amounts filled and fees paid of right order.
973         uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
974     }
975 
976     /// @dev Adds properties of both FillResults instances.
977     ///      Modifies the first FillResults instance specified.
978     /// @param totalFillResults Fill results instance that will be added onto.
979     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
980     function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
981         internal
982         pure
983     {
984         totalFillResults.makerAssetFilledAmount = SafeMath.add(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);
985         totalFillResults.takerAssetFilledAmount = SafeMath.add(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);
986         totalFillResults.makerFeePaid = SafeMath.add(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);
987         totalFillResults.takerFeePaid = SafeMath.add(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);
988     }
989 }
990 
991 contract IExchangeCore {
992 
993     bytes public ZRX_ASSET_DATA;
994 
995     /// @dev Fills the input order.
996     /// @param order Order struct containing order specifications.
997     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
998     /// @param signature Proof that order has been created by maker.
999     /// @return Amounts filled and fees paid by maker and taker.
1000     function fillOrder(
1001         LibOrder.Order memory order,
1002         uint256 takerAssetFillAmount,
1003         bytes memory signature
1004     )
1005         public
1006         returns (LibFillResults.FillResults memory fillResults);
1007 
1008     function fillOrderNoThrow(
1009         LibOrder.Order memory order,
1010         uint256 takerAssetFillAmount,
1011         bytes memory signature
1012     )
1013         public
1014         returns (LibFillResults.FillResults memory fillResults);
1015 
1016     /// @dev Gets information about an order: status, hash, and amount filled.
1017     /// @param order Order to gather information on.
1018     /// @return OrderInfo Information about the order and its state.
1019     ///                   See LibOrder.OrderInfo for a complete description.
1020     function getOrderInfo(LibOrder.Order memory order)
1021         public
1022         view
1023         returns (LibOrder.OrderInfo memory orderInfo);
1024 
1025     /// @dev Gets an asset proxy.
1026     /// @param assetProxyId Id of the asset proxy.
1027     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
1028     function getAssetProxy(bytes4 assetProxyId)
1029         external
1030         view
1031         returns (address);
1032 
1033     function isValidSignature(
1034         bytes32 hash,
1035         address signerAddress,
1036         bytes memory signature
1037     )
1038         public
1039         view
1040         returns (bool isValid);
1041 }
1042 
1043 interface WETH {
1044     function deposit() external payable;
1045     function withdraw(uint256 amount) external;
1046 }
1047 
1048 /// @title ZeroExExchangeHandler
1049 /// @notice Handles the all ZeroExExchange trades for the primary contract
1050 contract ZeroExExchangeHandler is ExchangeHandler, AllowanceSetter  {
1051 
1052     /*
1053     *   State Variables
1054     */
1055 
1056     IExchangeCore public exchange;
1057     /// @dev note that this is dependent on the deployment of 0xV2. This is the ERC20 asset proxy + the mainnet address of the ZRX token
1058     bytes constant ZRX_ASSET_DATA = "\xf4\x72\x61\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe4\x1d\x24\x89\x57\x1d\x32\x21\x89\x24\x6d\xaf\xa5\xeb\xde\x1f\x46\x99\xf4\x98";
1059     address ERC20_ASSET_PROXY;
1060     WETH weth;
1061 
1062     /*
1063     *   Types
1064     */
1065 
1066     /// @notice Constructor
1067     /// @param _exchange Address of the IExchangeCore exchange
1068     /// @param totlePrimary the address of the totlePrimary contract
1069     constructor(
1070         address _exchange,
1071         address totlePrimary,
1072         address _weth,
1073         address errorReporter
1074         /* ,address logger */
1075     )
1076         ExchangeHandler(totlePrimary, errorReporter/*, logger*/)
1077         public
1078     {
1079         require(_exchange != address(0x0));
1080         exchange = IExchangeCore(_exchange);
1081         ERC20_ASSET_PROXY = exchange.getAssetProxy(toBytes4(ZRX_ASSET_DATA, 0));
1082         weth = WETH(_weth);
1083     }
1084 
1085     struct OrderData {
1086         address makerAddress;           // Address that created the order.
1087         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
1088         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
1089         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
1090         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
1091         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
1092         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
1093         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
1094         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
1095         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
1096         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
1097         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
1098         bytes signature;
1099     }
1100 
1101     /*
1102     *   Public functions
1103     */
1104 
1105     /*
1106     *   Internal functions
1107     */
1108 
1109     /// @notice Gets the amount that Totle needs to give for this order
1110     /// @param data LibOrder.Order struct containing order values
1111     /// @return amountToGive amount taker needs to give in order to fill the order
1112     function getAmountToGive_(
1113         OrderData data
1114     )
1115       public
1116       view
1117       onlyTotle
1118       returns (uint256 amountToGive)
1119     {
1120         LibOrder.OrderInfo memory orderInfo = exchange.getOrderInfo(
1121             getZeroExOrder(data)
1122         );
1123         uint makerAssetAvailable = getAssetDataAvailable(data.makerAssetData, data.makerAddress);
1124         uint feeAssetAvailable = getAssetDataAvailable(ZRX_ASSET_DATA, data.makerAddress);
1125 
1126         uint maxFromMakerFee = data.makerFee == 0 ? Utils.max_uint() : getPartialAmount(feeAssetAvailable, data.makerFee, data.takerAssetAmount);
1127         amountToGive = Math.min(Math.min(
1128             getPartialAmount(makerAssetAvailable, data.makerAssetAmount, data.takerAssetAmount),
1129             maxFromMakerFee),
1130             SafeMath.sub(data.takerAssetAmount, orderInfo.orderTakerAssetFilledAmount)
1131         );
1132         /* logger.log("Getting amountToGive from ZeroEx arg2: amountToGive", amountToGive); */
1133     }
1134 
1135     function getAssetDataAvailable(bytes assetData, address account) internal view returns (uint){
1136         address tokenAddress = toAddress(assetData, 16);
1137         ERC20 token = ERC20(tokenAddress);
1138         return Math.min(token.balanceOf(account), token.allowance(account, ERC20_ASSET_PROXY));
1139     }
1140 
1141     function getZeroExOrder(OrderData data) internal pure returns (LibOrder.Order) {
1142         return LibOrder.Order({
1143             makerAddress: data.makerAddress,
1144             takerAddress: data.takerAddress,
1145             feeRecipientAddress: data.feeRecipientAddress,
1146             senderAddress: data.senderAddress,
1147             makerAssetAmount: data.makerAssetAmount,
1148             takerAssetAmount: data.takerAssetAmount,
1149             makerFee: data.makerFee,
1150             takerFee: data.takerFee,
1151             expirationTimeSeconds: data.expirationTimeSeconds,
1152             salt: data.salt,
1153             makerAssetData: data.makerAssetData,
1154             takerAssetData: data.takerAssetData
1155         });
1156     }
1157 
1158     /// @notice Perform exchange-specific checks on the given order
1159     /// @dev This should be called to check for payload errors
1160     /// @param data LibOrder.Order struct containing order values
1161     /// @return checksPassed value representing pass or fail
1162     function staticExchangeChecks_(
1163         OrderData data
1164     )
1165         public
1166         view
1167         onlyTotle
1168         returns (bool checksPassed)
1169     {
1170 
1171         // Make sure that:
1172         //  The order is not expired
1173         //  Both the maker and taker assets are ERC20 tokens
1174         //  The taker does not have to pay a fee (we don't support fees yet)
1175         //  We are permitted to take this order
1176         //  We are permitted to send this order
1177         // TODO: Should we check signatures here?
1178         return (block.timestamp <= data.expirationTimeSeconds &&
1179                 toBytes4(data.takerAssetData, 0) == bytes4(0xf47261b0) &&
1180                 toBytes4(data.makerAssetData, 0) == bytes4(0xf47261b0) &&
1181                 data.takerFee == 0 &&
1182                 (data.takerAddress == address(0x0) || data.takerAddress == address(this)) &&
1183                 (data.senderAddress == address(0x0) || data.senderAddress == address(this))
1184         );
1185     }
1186 
1187     /// @notice Perform a buy order at the exchange
1188     /// @param data LibOrder.Order struct containing order values
1189     /// @return amountSpentOnOrder the amount that would be spent on the order
1190     /// @return amountReceivedFromOrder the amount that was received from this order
1191     function performBuyOrder_(
1192         OrderData data
1193     )
1194         public
1195         payable
1196         onlyTotle
1197         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
1198     {
1199         uint256 amountToGiveForOrder = toUint(msg.data, msg.data.length - 32);
1200 
1201         approveAddress(ERC20_ASSET_PROXY, toAddress(data.takerAssetData, 16));
1202 
1203         weth.deposit.value(amountToGiveForOrder)();
1204 
1205         LibFillResults.FillResults memory results = exchange.fillOrder(
1206             getZeroExOrder(data),
1207             amountToGiveForOrder,
1208             data.signature
1209         );
1210         require(ERC20SafeTransfer.safeTransfer(toAddress(data.makerAssetData, 16), msg.sender, results.makerAssetFilledAmount));
1211 
1212         amountSpentOnOrder = results.takerAssetFilledAmount;
1213         amountReceivedFromOrder = results.makerAssetFilledAmount;
1214         /* logger.log("Performed buy order on ZeroEx arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1215     }
1216 
1217     /// @notice Perform a sell order at the exchange
1218     /// @param data LibOrder.Order struct containing order values
1219     /// @return amountSpentOnOrder the amount that would be spent on the order
1220     /// @return amountReceivedFromOrder the amount that was received from this order
1221     function performSellOrder_(
1222         OrderData data
1223     )
1224         public
1225         onlyTotle
1226         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
1227     {
1228         uint256 amountToGiveForOrder = toUint(msg.data, msg.data.length - 32);
1229         approveAddress(ERC20_ASSET_PROXY, toAddress(data.takerAssetData, 16));
1230 
1231         LibFillResults.FillResults memory results = exchange.fillOrder(
1232             getZeroExOrder(data),
1233             amountToGiveForOrder,
1234             data.signature
1235         );
1236 
1237         weth.withdraw(results.makerAssetFilledAmount);
1238         msg.sender.transfer(results.makerAssetFilledAmount);
1239 
1240         amountSpentOnOrder = results.takerAssetFilledAmount;
1241         amountReceivedFromOrder = results.makerAssetFilledAmount;
1242         /* logger.log("Performed sell order on ZeroEx arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1243     }
1244 
1245     /// @notice Calculate the result of ((numerator * target) / denominator)
1246     /// @param numerator the numerator in the equation
1247     /// @param denominator the denominator in the equation
1248     /// @param target the target for the equations
1249     /// @return partialAmount the resultant value
1250     function getPartialAmount(
1251         uint256 numerator,
1252         uint256 denominator,
1253         uint256 target
1254     )
1255         internal
1256         pure
1257         returns (uint256)
1258     {
1259         return SafeMath.div(SafeMath.mul(numerator, target), denominator);
1260     }
1261 
1262     // @notice Extract an address from a string of bytes
1263     // @param _bytes a string of at least 20 bytes
1264     // @param _start the offset of the address within the byte stream
1265     // @return tempAddress the address encoded in the bytestring beginning at _start
1266     function toAddress(bytes _bytes, uint _start) internal  pure returns (address) {
1267         require(_bytes.length >= (_start + 20));
1268         address tempAddress;
1269 
1270         assembly {
1271             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
1272         }
1273 
1274         return tempAddress;
1275     }
1276 
1277     function toBytes4(bytes _bytes, uint _start) internal pure returns (bytes4) {
1278         require(_bytes.length >= (_start + 4));
1279         bytes4 tempBytes4;
1280 
1281         assembly {
1282             tempBytes4 := mload(add(add(_bytes, 0x20), _start))
1283         }
1284         return tempBytes4;
1285     }
1286 
1287     // @notice Extract a uint256 from a string of bytes
1288     // @param _bytes a string of at least 32 bytes
1289     // @param _start the offset of the uint256 within the byte stream
1290     // @return tempUint the uint encoded in the bytestring beginning at _start
1291     function toUint(bytes _bytes, uint _start) internal  pure returns (uint256) {
1292         require(_bytes.length >= (_start + 32));
1293         uint256 tempUint;
1294 
1295         assembly {
1296             tempUint := mload(add(add(_bytes, 0x20), _start))
1297         }
1298 
1299         return tempUint;
1300     }
1301 
1302     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
1303         if (genericSelector == getAmountToGiveSelector) {
1304             return bytes4(keccak256("getAmountToGive_((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes,bytes))"));
1305         } else if (genericSelector == staticExchangeChecksSelector) {
1306             return bytes4(keccak256("staticExchangeChecks_((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes,bytes))"));
1307         } else if (genericSelector == performBuyOrderSelector) {
1308             return bytes4(keccak256("performBuyOrder_((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes,bytes))"));
1309         } else if (genericSelector == performSellOrderSelector) {
1310             return bytes4(keccak256("performSellOrder_((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes,bytes))"));
1311         } else {
1312             return bytes4(0x0);
1313         }
1314     }
1315 
1316     /*
1317     *   Payable fallback function
1318     */
1319 
1320     /// @notice payable fallback to allow the exchange to return ether directly to this contract
1321     /// @dev note that only the exchange should be able to send ether to this contract
1322     function() public payable {
1323         require(msg.sender == address(weth));
1324     }
1325 }