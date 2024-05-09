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
447 /**
448  * @title Pausable
449  * @dev Base contract which allows children to implement an emergency stop mechanism.
450  */
451 contract Pausable is Ownable {
452   event Paused();
453   event Unpaused();
454 
455   bool private _paused = false;
456 
457   /**
458    * @return true if the contract is paused, false otherwise.
459    */
460   function paused() public view returns (bool) {
461     return _paused;
462   }
463 
464   /**
465    * @dev Modifier to make a function callable only when the contract is not paused.
466    */
467   modifier whenNotPaused() {
468     require(!_paused, "Contract is paused.");
469     _;
470   }
471 
472   /**
473    * @dev Modifier to make a function callable only when the contract is paused.
474    */
475   modifier whenPaused() {
476     require(_paused, "Contract not paused.");
477     _;
478   }
479 
480   /**
481    * @dev called by the owner to pause, triggers stopped state
482    */
483   function pause() public onlyOwner whenNotPaused {
484     _paused = true;
485     emit Paused();
486   }
487 
488   /**
489    * @dev called by the owner to unpause, returns to normal state
490    */
491   function unpause() public onlyOwner whenPaused {
492     _paused = false;
493     emit Unpaused();
494   }
495 }
496 
497 contract SelectorProvider {
498     bytes4 constant getAmountToGiveSelector = bytes4(keccak256("getAmountToGive(bytes)"));
499     bytes4 constant staticExchangeChecksSelector = bytes4(keccak256("staticExchangeChecks(bytes)"));
500     bytes4 constant performBuyOrderSelector = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
501     bytes4 constant performSellOrderSelector = bytes4(keccak256("performSellOrder(bytes,uint256)"));
502 
503     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
504 }
505 
506 /* import "../lib/Logger.sol"; */
507 
508 
509 /// @title Interface for all exchange handler contracts
510 contract ExchangeHandler is SelectorProvider, TotleControl, Withdrawable, Pausable {
511 
512     /*
513     *   State Variables
514     */
515 
516     ErrorReporter public errorReporter;
517     /* Logger public logger; */
518     /*
519     *   Modifiers
520     */
521 
522     /// @notice Constructor
523     /// @dev Calls the constructor of the inherited TotleControl
524     /// @param totlePrimary the address of the totlePrimary contract
525     constructor(
526         address totlePrimary,
527         address _errorReporter
528         /* ,address _logger */
529     )
530         TotleControl(totlePrimary)
531         public
532     {
533         require(_errorReporter != address(0x0));
534         /* require(_logger != address(0x0)); */
535         errorReporter = ErrorReporter(_errorReporter);
536         /* logger = Logger(_logger); */
537     }
538 
539     /// @notice Gets the amount that Totle needs to give for this order
540     /// @param genericPayload the data for this order in a generic format
541     /// @return amountToGive amount taker needs to give in order to fill the order
542     function getAmountToGive(
543         bytes genericPayload
544     )
545         public
546         view
547         returns (uint256 amountToGive)
548     {
549         bool success;
550         bytes4 functionSelector = getSelector(this.getAmountToGive.selector);
551 
552         assembly {
553             let functionSelectorLength := 0x04
554             let functionSelectorOffset := 0x1C
555             let scratchSpace := 0x0
556             let wordLength := 0x20
557             let bytesLength := mload(genericPayload)
558             let totalLength := add(functionSelectorLength, bytesLength)
559             let startOfNewData := add(genericPayload, functionSelectorOffset)
560 
561             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
562             let functionSelectorCorrect := mload(scratchSpace)
563             mstore(genericPayload, functionSelectorCorrect)
564 
565             success := delegatecall(
566                             gas,
567                             address, // This address of the current contract
568                             startOfNewData, // Start data at the beginning of the functionSelector
569                             totalLength, // Total length of all data, including functionSelector
570                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
571                             wordLength // Length of return variable is one word
572                            )
573             amountToGive := mload(scratchSpace)
574             if eq(success, 0) { revert(0, 0) }
575         }
576     }
577 
578     /// @notice Perform exchange-specific checks on the given order
579     /// @dev this should be called to check for payload errors
580     /// @param genericPayload the data for this order in a generic format
581     /// @return checksPassed value representing pass or fail
582     function staticExchangeChecks(
583         bytes genericPayload
584     )
585         public
586         view
587         returns (bool checksPassed)
588     {
589         bool success;
590         bytes4 functionSelector = getSelector(this.staticExchangeChecks.selector);
591         assembly {
592             let functionSelectorLength := 0x04
593             let functionSelectorOffset := 0x1C
594             let scratchSpace := 0x0
595             let wordLength := 0x20
596             let bytesLength := mload(genericPayload)
597             let totalLength := add(functionSelectorLength, bytesLength)
598             let startOfNewData := add(genericPayload, functionSelectorOffset)
599 
600             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
601             let functionSelectorCorrect := mload(scratchSpace)
602             mstore(genericPayload, functionSelectorCorrect)
603 
604             success := delegatecall(
605                             gas,
606                             address, // This address of the current contract
607                             startOfNewData, // Start data at the beginning of the functionSelector
608                             totalLength, // Total length of all data, including functionSelector
609                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
610                             wordLength // Length of return variable is one word
611                            )
612             checksPassed := mload(scratchSpace)
613             if eq(success, 0) { revert(0, 0) }
614         }
615     }
616 
617     /// @notice Perform a buy order at the exchange
618     /// @param genericPayload the data for this order in a generic format
619     /// @param  amountToGiveForOrder amount that should be spent on this order
620     /// @return amountSpentOnOrder the amount that would be spent on the order
621     /// @return amountReceivedFromOrder the amount that was received from this order
622     function performBuyOrder(
623         bytes genericPayload,
624         uint256 amountToGiveForOrder
625     )
626         public
627         payable
628         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
629     {
630         bool success;
631         bytes4 functionSelector = getSelector(this.performBuyOrder.selector);
632         assembly {
633             let callDataOffset := 0x44
634             let functionSelectorOffset := 0x1C
635             let functionSelectorLength := 0x04
636             let scratchSpace := 0x0
637             let wordLength := 0x20
638             let startOfFreeMemory := mload(0x40)
639 
640             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
641 
642             let bytesLength := mload(startOfFreeMemory)
643             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
644 
645             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
646 
647             let functionSelectorCorrect := mload(scratchSpace)
648 
649             mstore(startOfFreeMemory, functionSelectorCorrect)
650 
651             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
652 
653             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
654 
655             success := delegatecall(
656                             gas,
657                             address, // This address of the current contract
658                             startOfNewData, // Start data at the beginning of the functionSelector
659                             totalLength, // Total length of all data, including functionSelector
660                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
661                             mul(wordLength, 0x02) // Length of return variables is two words
662                           )
663             amountSpentOnOrder := mload(scratchSpace)
664             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
665             if eq(success, 0) { revert(0, 0) }
666         }
667     }
668 
669     /// @notice Perform a sell order at the exchange
670     /// @param genericPayload the data for this order in a generic format
671     /// @param  amountToGiveForOrder amount that should be spent on this order
672     /// @return amountSpentOnOrder the amount that would be spent on the order
673     /// @return amountReceivedFromOrder the amount that was received from this order
674     function performSellOrder(
675         bytes genericPayload,
676         uint256 amountToGiveForOrder
677     )
678         public
679         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
680     {
681         bool success;
682         bytes4 functionSelector = getSelector(this.performSellOrder.selector);
683         assembly {
684             let callDataOffset := 0x44
685             let functionSelectorOffset := 0x1C
686             let functionSelectorLength := 0x04
687             let scratchSpace := 0x0
688             let wordLength := 0x20
689             let startOfFreeMemory := mload(0x40)
690 
691             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
692 
693             let bytesLength := mload(startOfFreeMemory)
694             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
695 
696             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
697 
698             let functionSelectorCorrect := mload(scratchSpace)
699 
700             mstore(startOfFreeMemory, functionSelectorCorrect)
701 
702             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
703 
704             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
705 
706             success := delegatecall(
707                             gas,
708                             address, // This address of the current contract
709                             startOfNewData, // Start data at the beginning of the functionSelector
710                             totalLength, // Total length of all data, including functionSelector
711                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
712                             mul(wordLength, 0x02) // Length of return variables is two words
713                           )
714             amountSpentOnOrder := mload(scratchSpace)
715             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
716             if eq(success, 0) { revert(0, 0) }
717         }
718     }
719 }
720 
721 interface EtherDelta {
722     function deposit() external payable;
723     function withdraw(uint256 amount) external;
724     function depositToken(address token, uint256 amount) external;
725     function withdrawToken(address token, uint256 amount) external;
726     function trade(address tokenGet, uint256 amountGet, address tokenGive, uint256 amountGive, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s, uint256 amount) external;
727     function availableVolume(address tokenGet, uint256 amountGet, address tokenGive, uint256 amountGive, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s) external view returns (uint256);
728 }
729 
730 /// @title EtherDeltaHandler
731 /// @notice Handles the all EtherDelta trades for the primary contract
732 contract EtherDeltaHandler is ExchangeHandler, AllowanceSetter {
733 
734     /*
735     *   State Variables
736     */
737 
738     EtherDelta public exchange;
739 
740     /*
741     *   Types
742     */
743 
744     struct OrderData {
745         address user;
746         address tokenGive;
747         address tokenGet;
748         uint256 amountGive;
749         uint256 amountGet;
750         uint256 expires;
751         uint256 nonce;
752         uint8 v;
753         bytes32 r;
754         bytes32 s;
755         uint256 exchangeFee;
756     }
757 
758     /// @notice Constructor
759     /// @param _exchange Address of the EtherDelta exchange
760     /// @param totlePrimary the address of the totlePrimary contract
761     /// @param errorReporter the address of the error reporter contract
762     constructor(
763         address _exchange,
764         address totlePrimary,
765         address errorReporter
766         /* ,address logger */
767     )
768         ExchangeHandler(totlePrimary, errorReporter/*, logger*/)
769         public
770     {
771         require(_exchange != address(0x0));
772         exchange = EtherDelta(_exchange);
773     }
774 
775     /*
776     *   Public functions
777     */
778 
779     /// @notice Gets the amount that Totle needs to give for this order
780     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
781     /// should only be called from functions which are inherited from the ExchangeHandler
782     /// base contract
783     /// @param data OrderData struct containing order values
784     /// @return amountToGive amount taker needs to give in order to fill the order
785     function getAmountToGive(
786         OrderData data
787     )
788         public
789         view
790         onlyTotle
791         returns (uint256 amountToGive)
792     {
793         uint256 availableVolume = exchange.availableVolume(
794             data.tokenGet,
795             data.amountGet,
796             data.tokenGive,
797             data.amountGive,
798             data.expires,
799             data.nonce,
800             data.user,
801             data.v,
802             data.r,
803             data.s
804         );
805         /* logger.log("Getting available volume from Etherdelta", availableVolume); */
806         // Adds the exchange fee onto the available amount
807         amountToGive = SafeMath.mul(availableVolume, SafeMath.add(1 ether, data.exchangeFee));
808         /* logger.log("Removing fee from amountToGive", amountToGive); */
809     }
810 
811     /// @notice Perform exchange-specific checks on the given order
812     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
813     /// should only be called from functions which are inherited from the ExchangeHandler
814     /// base contract.
815     /// This should be called to check for payload errors.
816     /// @param data OrderData struct containing order values
817     /// @return checksPassed value representing pass or fail
818     function staticExchangeChecks(
819         OrderData data
820     )
821         public
822         view
823         onlyTotle
824         returns (bool checksPassed)
825     {
826         /* logger.log(block.number <= data.expires ? "Order isn't expired" : "Order is expired"); */
827         // Only one thing to check here
828         return block.number <= data.expires; // TODO - check if this is < or <=
829     }
830 
831     /// @notice Perform a buy order at the exchange
832     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
833     /// should only be called from functions which are inherited from the ExchangeHandler
834     /// base contract
835     /// @param data OrderData struct containing order values
836     /// @param  amountToGiveForOrder amount that should be spent on this order
837     /// @return amountSpentOnOrder the amount that would be spent on the order
838     /// @return amountReceivedFromOrder the amount that was received from this order
839     function performBuyOrder(
840         OrderData data,
841         uint256 amountToGiveForOrder
842     )
843         public
844         payable
845         onlyTotle
846         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
847     {
848         if (msg.value != amountToGiveForOrder) {
849             errorReporter.revertTx("msg.value != amountToGiveForOrder");
850         }
851         /* logger.log("Depositing eth to Etherdelta arg2: amountToGive, arg3: ethBalance", amountToGiveForOrder, address(this).balance); */
852         exchange.deposit.value(amountToGiveForOrder)();
853 
854         uint256 amountToTrade;
855         uint256 fee;
856 
857         (amountToTrade, fee) = substractFee(data.exchangeFee, amountToGiveForOrder);
858         /* logger.log("Removing fee from amountToGiveForOrder arg2: amountToGiveForOrder, arg3: amountToTrade, arg4: fee", amountToGiveForOrder, amountToTrade, fee); */
859         trade(data, amountToTrade);
860 
861         amountSpentOnOrder = amountToGiveForOrder;
862         amountReceivedFromOrder = getPartialAmount(data.amountGive, data.amountGet, amountToTrade);
863         /* logger.log("Withdrawing tokens from EtherDelta arg2: amountReceivedFromOrder, arg3: amountSpentOnOrder", amountReceivedFromOrder, amountSpentOnOrder); */
864         exchange.withdrawToken(data.tokenGive, amountReceivedFromOrder);
865 
866         if (!ERC20SafeTransfer.safeTransfer(data.tokenGive, msg.sender, amountReceivedFromOrder)) {
867             errorReporter.revertTx("Unable to transfer bought tokens to primary");
868         }
869     }
870 
871     /// @notice Perform a sell order at the exchange
872     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
873     /// should only be called from functions which are inherited from the ExchangeHandler
874     /// base contract
875     /// @param data OrderData struct containing order values
876     /// @param  amountToGiveForOrder amount that should be spent on this order
877     /// @return amountSpentOnOrder the amount that would be spent on the order
878     /// @return amountReceivedFromOrder the amount that was received from this order
879     function performSellOrder(
880         OrderData data,
881         uint256 amountToGiveForOrder
882     )
883         public
884         onlyTotle
885         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
886     {
887         approveAddress(address(exchange), data.tokenGet);
888         /* logger.log("Depositing tokens to EtherDelta arg2: amountToGiveForOrder", amountToGiveForOrder); */
889         exchange.depositToken(data.tokenGet, amountToGiveForOrder);
890 
891         uint256 amountToTrade;
892         uint256 fee;
893 
894         (amountToTrade, fee) = substractFee(data.exchangeFee, amountToGiveForOrder);
895         /* logger.log("arg2: amountToTrade, arg3: fee", amountToTrade, fee); */
896 
897         trade(data, amountToTrade);
898 
899         amountSpentOnOrder = amountToGiveForOrder;
900         amountReceivedFromOrder = getPartialAmount(data.amountGive, data.amountGet, amountToTrade);
901 
902         exchange.withdraw(amountReceivedFromOrder);
903         /* logger.log("Withdrawing ether arg2: amountReceived", amountReceivedFromOrder); */
904         msg.sender.transfer(amountReceivedFromOrder);
905     }
906 
907     /*
908     *   Internal functions
909     */
910 
911     /// @notice Performs the trade at the exchange
912     /// @dev It was necessary to separate this into a function due to limited stack space
913     /// @param data OrderData struct containing order values
914     /// @param amountToTrade amount that should be spent on this order
915     function trade(
916         OrderData data,
917         uint256 amountToTrade
918     )
919         internal
920     {
921         exchange.trade(
922             data.tokenGet,
923             data.amountGet,
924             data.tokenGive,
925             data.amountGive,
926             data.expires,
927             data.nonce,
928             data.user,
929             data.v,
930             data.r,
931             data.s,
932             amountToTrade
933         );
934     }
935 
936     /// @notice Subtract fee percentage from the amount give
937     /// @param feePercentage the percentage fee to deduct
938     /// @param  amount the amount that we should deduct from
939     /// @return amountMinusFee the amount that would be spent on the order
940     /// @return fee the amount that was received from this order
941     function substractFee(
942         uint256 feePercentage,
943         uint256 amount
944     )
945         public
946         pure
947         returns (uint256 amountMinusFee, uint256 fee)
948     {
949         fee = SafeMath.sub(amount, getPartialAmount(amount, SafeMath.add(feePercentage, 1 ether), 1 ether ));
950         amountMinusFee = SafeMath.sub(amount, fee);
951     }
952 
953     /// @notice Calculate the result of ((numerator * target) / denominator)
954     /// @param numerator the numerator in the equation
955     /// @param denominator the denominator in the equation
956     /// @param target the target for the equations
957     /// @return partialAmount the resultant value
958     function getPartialAmount(
959         uint256 numerator,
960         uint256 denominator,
961         uint256 target
962     )
963         internal
964         pure
965         returns (uint256)
966     {
967         return SafeMath.div(SafeMath.mul(numerator, target), denominator);
968     }
969 
970     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
971         if (genericSelector == getAmountToGiveSelector) {
972             return bytes4(keccak256("getAmountToGive((address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32,uint256))"));
973         } else if (genericSelector == staticExchangeChecksSelector) {
974             return bytes4(keccak256("staticExchangeChecks((address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32,uint256))"));
975         } else if (genericSelector == performBuyOrderSelector) {
976             return bytes4(keccak256("performBuyOrder((address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32,uint256),uint256)"));
977         } else if (genericSelector == performSellOrderSelector) {
978             return bytes4(keccak256("performSellOrder((address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32,uint256),uint256)"));
979         } else {
980             return bytes4(0x0);
981         }
982     }
983 
984     /*
985     *   Payable fallback function
986     */
987 
988     /// @notice payable fallback to allow the exchange to return ether directly to this contract
989     /// @dev note that only the exchange should be able to send ether to this contract
990     function() public payable {
991         if (msg.sender != address(exchange)) {
992             errorReporter.revertTx("An address other than the exchange cannot send ether to EDHandler fallback");
993         }
994     }
995 }