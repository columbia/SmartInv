1 pragma solidity 0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11 
12   function balanceOf(address _who) public view returns (uint256);
13 
14   function allowance(address _owner, address _spender)
15     public view returns (uint256);
16 
17   function transfer(address _to, uint256 _value) public returns (bool);
18 
19   function approve(address _spender, uint256 _value)
20     public returns (bool);
21 
22   function transferFrom(address _from, address _to, uint256 _value)
23     public returns (bool);
24 
25   function decimals() public view returns (uint256);
26 
27   event Transfer(
28     address indexed from,
29     address indexed to,
30     uint256 value
31   );
32 
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that revert on error
44  */
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, reverts on overflow.
49   */
50   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52     // benefit is lost if 'b' is also tested.
53     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54     if (_a == 0) {
55       return 0;
56     }
57 
58     uint256 c = _a * _b;
59     require(c / _a == _b);
60 
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
66   */
67   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
68     require(_b > 0); // Solidity only automatically asserts when dividing by 0
69     uint256 c = _a / _b;
70     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
71 
72     return c;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
79     require(_b <= _a);
80     uint256 c = _a - _b;
81 
82     return c;
83   }
84 
85   /**
86   * @dev Adds two numbers, reverts on overflow.
87   */
88   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
89     uint256 c = _a + _b;
90     require(c >= _a);
91 
92     return c;
93   }
94 
95   /**
96   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
97   * reverts when dividing by zero.
98   */
99   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100     require(b != 0);
101     return a % b;
102   }
103 }
104 
105 
106 /*
107     Modified Util contract as used by Kyber Network
108 */
109 
110 library Utils {
111 
112     uint256 constant internal PRECISION = (10**18);
113     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
114     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
115     uint256 constant internal MAX_DECIMALS = 18;
116     uint256 constant internal ETH_DECIMALS = 18;
117     uint256 constant internal MAX_UINT = 2**256-1;
118 
119     // Currently constants can't be accessed from other contracts, so providing functions to do that here
120     function precision() internal pure returns (uint256) { return PRECISION; }
121     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
122     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
123     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
124     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
125     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
126 
127     /// @notice Retrieve the number of decimals used for a given ERC20 token
128     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
129     /// ensure that an exception doesn't cause transaction failure
130     /// @param token the token for which we should retrieve the decimals
131     /// @return decimals the number of decimals in the given token
132     function getDecimals(address token)
133         internal
134         view
135         returns (uint256 decimals)
136     {
137         bytes4 functionSig = bytes4(keccak256("decimals()"));
138 
139         /// @dev Using assembly due to issues with current solidity `address.call()`
140         /// implementation: https://github.com/ethereum/solidity/issues/2884
141         assembly {
142             // Pointer to next free memory slot
143             let ptr := mload(0x40)
144             // Store functionSig variable at ptr
145             mstore(ptr,functionSig)
146             let functionSigLength := 0x04
147             let wordLength := 0x20
148 
149             let success := call(
150                                 5000, // Amount of gas
151                                 token, // Address to call
152                                 0, // ether to send
153                                 ptr, // ptr to input data
154                                 functionSigLength, // size of data
155                                 ptr, // where to store output data (overwrite input)
156                                 wordLength // size of output data (32 bytes)
157                                )
158 
159             switch success
160             case 0 {
161                 decimals := 18 // If the token doesn't implement `decimals()`, return 18 as default
162             }
163             case 1 {
164                 decimals := mload(ptr) // Set decimals to return data from call
165             }
166             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
167         }
168     }
169 
170     /// @dev Checks that a given address has its token allowance and balance set above the given amount
171     /// @param tokenOwner the address which should have custody of the token
172     /// @param tokenAddress the address of the token to check
173     /// @param tokenAmount the amount of the token which should be set
174     /// @param addressToAllow the address which should be allowed to transfer the token
175     /// @return bool true if the allowance and balance is set, false if not
176     function tokenAllowanceAndBalanceSet(
177         address tokenOwner,
178         address tokenAddress,
179         uint256 tokenAmount,
180         address addressToAllow
181     )
182         internal
183         view
184         returns (bool)
185     {
186         return (
187             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
188             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
189         );
190     }
191 
192     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
193         if (dstDecimals >= srcDecimals) {
194             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
195             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
196         } else {
197             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
198             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
199         }
200     }
201 
202     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
203 
204         //source quantity is rounded up. to avoid dest quantity being too low.
205         uint numerator;
206         uint denominator;
207         if (srcDecimals >= dstDecimals) {
208             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
209             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
210             denominator = rate;
211         } else {
212             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
213             numerator = (PRECISION * dstQty);
214             denominator = (rate * (10**(dstDecimals - srcDecimals)));
215         }
216         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
217     }
218 
219     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns (uint) {
220         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
221     }
222 
223     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns (uint) {
224         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
225     }
226 
227     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
228         internal pure returns (uint)
229     {
230         require(srcAmount <= MAX_QTY);
231         require(destAmount <= MAX_QTY);
232 
233         if (dstDecimals >= srcDecimals) {
234             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
235             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
236         } else {
237             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
238             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
239         }
240     }
241 
242     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
243     function min(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a < b ? a : b;
245     }
246 }
247 
248 library ERC20SafeTransfer {
249     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
250 
251         require(_tokenAddress.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
252 
253         return fetchReturnData();
254     }
255 
256     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
257 
258         require(_tokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
259 
260         return fetchReturnData();
261     }
262 
263     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
264 
265         require(_tokenAddress.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
266 
267         return fetchReturnData();
268     }
269 
270     function fetchReturnData() internal returns (bool success){
271         assembly {
272             switch returndatasize()
273             case 0 {
274                 success := 1
275             }
276             case 32 {
277                 returndatacopy(0, 0, 32)
278                 success := mload(0)
279             }
280             default {
281                 revert(0, 0)
282             }
283         }
284     }
285 
286 }
287 
288 /// @title A contract which is used to check and set allowances of tokens
289 /// @dev In order to use this contract is must be inherited in the contract which is using
290 /// its functionality
291 contract AllowanceSetter {
292     uint256 constant MAX_UINT = 2**256 - 1;
293 
294     /// @notice A function which allows the caller to approve the max amount of any given token
295     /// @dev In order to function correctly, token allowances should not be set anywhere else in
296     /// the inheriting contract
297     /// @param addressToApprove the address which we want to approve to transfer the token
298     /// @param token the token address which we want to call approve on
299     function approveAddress(address addressToApprove, address token) internal {
300         if(ERC20(token).allowance(address(this), addressToApprove) == 0) {
301             require(ERC20SafeTransfer.safeApprove(token, addressToApprove, MAX_UINT));
302         }
303     }
304 
305 }
306 
307 contract ErrorReporter {
308     function revertTx(string reason) public pure {
309         revert(reason);
310     }
311 }
312 
313 /**
314  * @title Ownable
315  * @dev The Ownable contract has an owner address, and provides basic authorization control
316  * functions, this simplifies the implementation of "user permissions".
317  */
318 contract Ownable {
319   address public owner;
320 
321 
322   event OwnershipRenounced(address indexed previousOwner);
323   event OwnershipTransferred(
324     address indexed previousOwner,
325     address indexed newOwner
326   );
327 
328 
329   /**
330    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
331    * account.
332    */
333   constructor() public {
334     owner = msg.sender;
335   }
336 
337   /**
338    * @dev Throws if called by any account other than the owner.
339    */
340   modifier onlyOwner() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Allows the current owner to relinquish control of the contract.
347    * @notice Renouncing to ownership will leave the contract without an owner.
348    * It will not be possible to call the functions with the `onlyOwner`
349    * modifier anymore.
350    */
351   function renounceOwnership() public onlyOwner {
352     emit OwnershipRenounced(owner);
353     owner = address(0);
354   }
355 
356   /**
357    * @dev Allows the current owner to transfer control of the contract to a newOwner.
358    * @param _newOwner The address to transfer ownership to.
359    */
360   function transferOwnership(address _newOwner) public onlyOwner {
361     _transferOwnership(_newOwner);
362   }
363 
364   /**
365    * @dev Transfers control of the contract to a newOwner.
366    * @param _newOwner The address to transfer ownership to.
367    */
368   function _transferOwnership(address _newOwner) internal {
369     require(_newOwner != address(0));
370     emit OwnershipTransferred(owner, _newOwner);
371     owner = _newOwner;
372   }
373 }
374 
375 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
376 /// some functions
377 /// @dev Defines a modifier which should be used when only the totle contract should
378 /// able able to call a function
379 contract TotleControl is Ownable {
380     address public totlePrimary;
381 
382     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
383     modifier onlyTotle() {
384         require(msg.sender == totlePrimary);
385         _;
386     }
387 
388     /// @notice Contract constructor
389     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
390     /// @param _totlePrimary the address of the contract to be set as totlePrimary
391     constructor(address _totlePrimary) public {
392         require(_totlePrimary != address(0x0));
393         totlePrimary = _totlePrimary;
394     }
395 
396     /// @notice A function which allows only the owner to change the address of totlePrimary
397     /// @dev onlyOwner modifier only allows the contract owner to run the code
398     /// @param _totlePrimary the address of the contract to be set as totlePrimary
399     function setTotle(
400         address _totlePrimary
401     ) external onlyOwner {
402         require(_totlePrimary != address(0x0));
403         totlePrimary = _totlePrimary;
404     }
405 }
406 
407 /// @title A contract which allows its owner to withdraw any ether which is contained inside
408 contract Withdrawable is Ownable {
409 
410     /// @notice Withdraw ether contained in this contract and send it back to owner
411     /// @dev onlyOwner modifier only allows the contract owner to run the code
412     /// @param _token The address of the token that the user wants to withdraw
413     /// @param _amount The amount of tokens that the caller wants to withdraw
414     /// @return bool value indicating whether the transfer was successful
415     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
416         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
417     }
418 
419     /// @notice Withdraw ether contained in this contract and send it back to owner
420     /// @dev onlyOwner modifier only allows the contract owner to run the code
421     /// @param _amount The amount of ether that the caller wants to withdraw
422     function withdrawETH(uint256 _amount) external onlyOwner {
423         owner.transfer(_amount);
424     }
425 }
426 
427 /**
428  * @title Pausable
429  * @dev Base contract which allows children to implement an emergency stop mechanism.
430  */
431 contract Pausable is Ownable {
432   event Paused();
433   event Unpaused();
434 
435   bool private _paused = false;
436 
437   /**
438    * @return true if the contract is paused, false otherwise.
439    */
440   function paused() public view returns (bool) {
441     return _paused;
442   }
443 
444   /**
445    * @dev Modifier to make a function callable only when the contract is not paused.
446    */
447   modifier whenNotPaused() {
448     require(!_paused, "Contract is paused.");
449     _;
450   }
451 
452   /**
453    * @dev Modifier to make a function callable only when the contract is paused.
454    */
455   modifier whenPaused() {
456     require(_paused, "Contract not paused.");
457     _;
458   }
459 
460   /**
461    * @dev called by the owner to pause, triggers stopped state
462    */
463   function pause() public onlyOwner whenNotPaused {
464     _paused = true;
465     emit Paused();
466   }
467 
468   /**
469    * @dev called by the owner to unpause, returns to normal state
470    */
471   function unpause() public onlyOwner whenPaused {
472     _paused = false;
473     emit Unpaused();
474   }
475 }
476 
477 contract SelectorProvider {
478     bytes4 constant getAmountToGive = bytes4(keccak256("getAmountToGive(bytes)"));
479     bytes4 constant staticExchangeChecks = bytes4(keccak256("staticExchangeChecks(bytes)"));
480     bytes4 constant performBuyOrder = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
481     bytes4 constant performSellOrder = bytes4(keccak256("performSellOrder(bytes,uint256)"));
482 
483     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
484 }
485 
486 /// @title Interface for all exchange handler contracts
487 contract ExchangeHandler is TotleControl, Withdrawable, Pausable {
488 
489     /*
490     *   State Variables
491     */
492 
493     SelectorProvider public selectorProvider;
494     ErrorReporter public errorReporter;
495     /* Logger public logger; */
496     /*
497     *   Modifiers
498     */
499 
500     modifier onlySelf() {
501         require(msg.sender == address(this));
502         _;
503     }
504 
505     /// @notice Constructor
506     /// @dev Calls the constructor of the inherited TotleControl
507     /// @param _selectorProvider the provider for this exchanges function selectors
508     /// @param totlePrimary the address of the totlePrimary contract
509     constructor(
510         address _selectorProvider,
511         address totlePrimary,
512         address _errorReporter
513         /* ,address _logger */
514     )
515         TotleControl(totlePrimary)
516         public
517     {
518         require(_selectorProvider != address(0x0));
519         require(_errorReporter != address(0x0));
520         /* require(_logger != address(0x0)); */
521         selectorProvider = SelectorProvider(_selectorProvider);
522         errorReporter = ErrorReporter(_errorReporter);
523         /* logger = Logger(_logger); */
524     }
525 
526     /// @notice Gets the amount that Totle needs to give for this order
527     /// @param genericPayload the data for this order in a generic format
528     /// @return amountToGive amount taker needs to give in order to fill the order
529     function getAmountToGive(
530         bytes genericPayload
531     )
532         public
533         view
534         onlyTotle
535         whenNotPaused
536         returns (uint256 amountToGive)
537     {
538         bool success;
539         bytes4 functionSelector = selectorProvider.getSelector(this.getAmountToGive.selector);
540 
541         assembly {
542             let functionSelectorLength := 0x04
543             let functionSelectorOffset := 0x1C
544             let scratchSpace := 0x0
545             let wordLength := 0x20
546             let bytesLength := mload(genericPayload)
547             let totalLength := add(functionSelectorLength, bytesLength)
548             let startOfNewData := add(genericPayload, functionSelectorOffset)
549 
550             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
551             let functionSelectorCorrect := mload(scratchSpace)
552             mstore(genericPayload, functionSelectorCorrect)
553 
554             success := call(
555                             gas,
556                             address, // This address of the current contract
557                             callvalue,
558                             startOfNewData, // Start data at the beginning of the functionSelector
559                             totalLength, // Total length of all data, including functionSelector
560                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
561                             wordLength // Length of return variable is one word
562                            )
563             amountToGive := mload(scratchSpace)
564             if eq(success, 0) { revert(0, 0) }
565         }
566     }
567 
568     /// @notice Perform exchange-specific checks on the given order
569     /// @dev this should be called to check for payload errors
570     /// @param genericPayload the data for this order in a generic format
571     /// @return checksPassed value representing pass or fail
572     function staticExchangeChecks(
573         bytes genericPayload
574     )
575         public
576         view
577         onlyTotle
578         whenNotPaused
579         returns (bool checksPassed)
580     {
581         bool success;
582         bytes4 functionSelector = selectorProvider.getSelector(this.staticExchangeChecks.selector);
583         assembly {
584             let functionSelectorLength := 0x04
585             let functionSelectorOffset := 0x1C
586             let scratchSpace := 0x0
587             let wordLength := 0x20
588             let bytesLength := mload(genericPayload)
589             let totalLength := add(functionSelectorLength, bytesLength)
590             let startOfNewData := add(genericPayload, functionSelectorOffset)
591 
592             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
593             let functionSelectorCorrect := mload(scratchSpace)
594             mstore(genericPayload, functionSelectorCorrect)
595 
596             success := call(
597                             gas,
598                             address, // This address of the current contract
599                             callvalue,
600                             startOfNewData, // Start data at the beginning of the functionSelector
601                             totalLength, // Total length of all data, including functionSelector
602                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
603                             wordLength // Length of return variable is one word
604                            )
605             checksPassed := mload(scratchSpace)
606             if eq(success, 0) { revert(0, 0) }
607         }
608     }
609 
610     /// @notice Perform a buy order at the exchange
611     /// @param genericPayload the data for this order in a generic format
612     /// @param  amountToGiveForOrder amount that should be spent on this order
613     /// @return amountSpentOnOrder the amount that would be spent on the order
614     /// @return amountReceivedFromOrder the amount that was received from this order
615     function performBuyOrder(
616         bytes genericPayload,
617         uint256 amountToGiveForOrder
618     )
619         public
620         payable
621         onlyTotle
622         whenNotPaused
623         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
624     {
625         bool success;
626         bytes4 functionSelector = selectorProvider.getSelector(this.performBuyOrder.selector);
627         assembly {
628             let callDataOffset := 0x44
629             let functionSelectorOffset := 0x1C
630             let functionSelectorLength := 0x04
631             let scratchSpace := 0x0
632             let wordLength := 0x20
633             let startOfFreeMemory := mload(0x40)
634 
635             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
636 
637             let bytesLength := mload(startOfFreeMemory)
638             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
639 
640             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
641 
642             let functionSelectorCorrect := mload(scratchSpace)
643 
644             mstore(startOfFreeMemory, functionSelectorCorrect)
645 
646             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
647 
648             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
649 
650             success := call(
651                             gas,
652                             address, // This address of the current contract
653                             callvalue,
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
675         onlyTotle
676         whenNotPaused
677         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
678     {
679         bool success;
680         bytes4 functionSelector = selectorProvider.getSelector(this.performSellOrder.selector);
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
704             success := call(
705                             gas,
706                             address, // This address of the current contract
707                             callvalue,
708                             startOfNewData, // Start data at the beginning of the functionSelector
709                             totalLength, // Total length of all data, including functionSelector
710                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
711                             mul(wordLength, 0x02) // Length of return variables is two words
712                           )
713             amountSpentOnOrder := mload(scratchSpace)
714             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
715             if eq(success, 0) { revert(0, 0) }
716         }
717     }
718 }
719 
720 interface ENSResolver {
721     function getKyberNetworkAddress() external view returns (address);
722 }
723 
724 interface Kyber {
725 
726     function trade(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount, uint minConversionRate, address walletId) external payable returns (uint);
727     function maxGasPrice() external view returns(uint);
728     function getExpectedRate(ERC20 source, ERC20 dest, uint srcQty) external view returns (uint expectedPrice, uint slippagePrice);
729 }
730 
731 /// @title KyberSelectorProvider
732 /// @notice Provides this exchange implementation with correctly formatted function selectors
733 contract KyberSelectorProvider is SelectorProvider {
734     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
735         if (genericSelector == getAmountToGive) {
736             return bytes4(keccak256("getAmountToGive((address,address,uint256,uint256,address))"));
737         } else if (genericSelector == staticExchangeChecks) {
738             return bytes4(keccak256("staticExchangeChecks((address,address,uint256,uint256,address))"));
739         } else if (genericSelector == performBuyOrder) {
740             return bytes4(keccak256("performBuyOrder((address,address,uint256,uint256,address),uint256)"));
741         } else if (genericSelector == performSellOrder) {
742             return bytes4(keccak256("performSellOrder((address,address,uint256,uint256,address),uint256)"));
743         } else {
744             return bytes4(0x0);
745         }
746     }
747 }
748 
749 /// @title Interface for all exchange handler contracts
750 contract KyberHandler is ExchangeHandler, AllowanceSetter {
751     /*
752     *   State Variables
753     */
754     ENSResolver public ensResolver;
755     address ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
756     /*
757     *   Types
758     */
759 
760     struct OrderData {
761         address tokenFrom;
762         address tokenTo;
763         uint256 amountToGive;
764         uint256 minConversionRate;
765         address walletId;
766     }
767 
768 
769     /// @notice Constructor
770     /// @param _ensResolver Address of the ENS resolver
771     /// @param _selectorProvider the provider for this exchanges function selectors
772     /// @param _totlePrimary the address of the totlePrimary contract
773     constructor(
774         address _ensResolver,
775         address _selectorProvider,
776         address _totlePrimary,
777         address errorReporter
778         /* ,address logger */
779     )
780         ExchangeHandler(_selectorProvider, _totlePrimary, errorReporter/*,logger*/)
781         public
782     {
783         ensResolver = ENSResolver(_ensResolver);
784     }
785 
786     /*
787     *   Internal functions
788     */
789 
790 
791     /// @notice Gets the amount that Totle needs to give for this order
792     /// @param data OrderData struct containing order values
793     /// @return amountToGive amount taker needs to give in order to fill the order
794     function getAmountToGive(
795         OrderData data
796     )
797         public
798         view
799         whenNotPaused
800         onlySelf
801         returns (uint256 amountToGive)
802     {
803         // Adds the exchange fee onto the available amount
804         amountToGive = data.amountToGive;
805     }
806 
807 
808 
809     /// @notice Perform exchange-specific checks on the given order
810     /// @dev This should be called to check for payload errors
811     /// @param data OrderData struct containing order values
812     /// @return checksPassed value representing pass or fail
813     function staticExchangeChecks(
814         OrderData data
815     )
816         public
817         view
818         whenNotPaused
819         onlySelf
820         returns (bool checksPassed)
821     {
822         uint256 maxGasPrice = resolveExchangeAddress().maxGasPrice();
823         /* logger.log("Checking gas price arg2: tx.gasprice, arg3: maxGasPrice", tx.gasprice, maxGasPrice); */
824         return (maxGasPrice >= tx.gasprice);
825     }
826 
827     /// @dev Perform a buy order at the exchange
828     /// @param data OrderData struct containing order values
829     /// @param  amountToGiveForOrder amount that should be spent on this order
830     /// @return amountSpentOnOrder the amount that would be spent on the order
831     /// @return amountReceivedFromOrder the amount that was received from this order
832     function performBuyOrder(
833         OrderData data,
834         uint256 amountToGiveForOrder
835     )
836         public
837         payable
838         whenNotPaused
839         onlySelf
840         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
841     {
842         amountSpentOnOrder = amountToGiveForOrder;
843         amountReceivedFromOrder = performTrade(data.tokenFrom, amountToGiveForOrder, data.tokenTo, data.minConversionRate);
844         /* logger.log("Performing Kyber buy order arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
845     }
846 
847     /// @dev Perform a sell order at the exchange
848     /// @param data OrderData struct containing order values
849     /// @param  amountToGiveForOrder amount that should be spent on this order
850     /// @return amountSpentOnOrder the amount that would be spent on the order
851     /// @return amountReceivedFromOrder the amount that was received from this order
852     function performSellOrder(
853         OrderData data,
854         uint256 amountToGiveForOrder
855     )
856         public
857         whenNotPaused
858         onlySelf
859         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
860     {
861         approveAddress(address(resolveExchangeAddress()), data.tokenFrom);
862         amountSpentOnOrder = amountToGiveForOrder;
863         amountReceivedFromOrder = performTrade(data.tokenFrom, amountToGiveForOrder, data.tokenTo, data.minConversionRate);
864         /* logger.log("Performing Kyber sell order arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder",amountSpentOnOrder,amountReceivedFromOrder); */
865     }
866 
867     function performTrade(
868         address tokenFrom,
869         uint256 amountToGive,
870         address tokenTo,
871         uint256 minConversionRate
872     )
873          internal
874          returns (uint256 amountReceivedFromOrder)
875     {
876         amountReceivedFromOrder = resolveExchangeAddress().trade.value(msg.value)(
877             ERC20(tokenFrom),
878             amountToGive,
879             ERC20(tokenTo),
880             totlePrimary,
881             Utils.max_uint(),
882             minConversionRate,
883             0x0
884         );
885 
886         // If Kyber has sent us back some excess ether
887         // TODO: If ether gets accidentally trapped in this contract by some other transaction,
888         //       this function will send it back to the primary in the subsequent order.
889         //       Change code to only return back what's left over from *this* transaction.
890         if(address(this).balance > 0) {
891             /* logger.log("Got excess ether back from Kyber arg2: address(this).balance",address(this).balance); */
892             totlePrimary.transfer(address(this).balance);
893         }
894     }
895 
896     function resolveExchangeAddress()
897         internal
898         view
899         returns (Kyber)
900     {
901         return Kyber(ensResolver.getKyberNetworkAddress());
902     }
903 
904     /// @notice payable fallback to block EOA sending eth
905     /// @dev this should fail if an EOA (or contract with 0 bytecode size) tries to send ETH to this contract
906     function() public payable {
907         // Check in here that the sender is a contract! (to stop accidents)
908         uint256 size;
909         address sender = msg.sender;
910         assembly {
911             size := extcodesize(sender)
912         }
913         require(size > 0);
914     }
915 }