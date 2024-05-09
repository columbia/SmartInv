1 pragma solidity 0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     uint256 c = _a * _b;
23     require(c / _a == _b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
32     require(_b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = _a / _b;
34     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
43     require(_b <= _a);
44     uint256 c = _a - _b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
53     uint256 c = _a + _b;
54     require(c >= _a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 /**
70  * @title Math
71  * @dev Assorted math operations
72  */
73 
74 library Math {
75   function max(uint256 a, uint256 b) internal pure returns (uint256) {
76     return a >= b ? a : b;
77   }
78 
79   function min(uint256 a, uint256 b) internal pure returns (uint256) {
80     return a < b ? a : b;
81   }
82 
83   function average(uint256 a, uint256 b) internal pure returns (uint256) {
84     // (a + b) / 2 can overflow, so we distribute
85     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
86   }
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 {
94   function totalSupply() public view returns (uint256);
95 
96   function balanceOf(address _who) public view returns (uint256);
97 
98   function allowance(address _owner, address _spender)
99     public view returns (uint256);
100 
101   function transfer(address _to, uint256 _value) public returns (bool);
102 
103   function approve(address _spender, uint256 _value)
104     public returns (bool);
105 
106   function transferFrom(address _from, address _to, uint256 _value)
107     public returns (bool);
108 
109   function decimals() public view returns (uint256);
110 
111   event Transfer(
112     address indexed from,
113     address indexed to,
114     uint256 value
115   );
116 
117   event Approval(
118     address indexed owner,
119     address indexed spender,
120     uint256 value
121   );
122 }
123 
124 /*
125     Modified Util contract as used by Kyber Network
126 */
127 
128 library Utils {
129 
130     uint256 constant internal PRECISION = (10**18);
131     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
132     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
133     uint256 constant internal MAX_DECIMALS = 18;
134     uint256 constant internal ETH_DECIMALS = 18;
135     uint256 constant internal MAX_UINT = 2**256-1;
136 
137     // Currently constants can't be accessed from other contracts, so providing functions to do that here
138     function precision() internal pure returns (uint256) { return PRECISION; }
139     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
140     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
141     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
142     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
143     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
144 
145     /// @notice Retrieve the number of decimals used for a given ERC20 token
146     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
147     /// ensure that an exception doesn't cause transaction failure
148     /// @param token the token for which we should retrieve the decimals
149     /// @return decimals the number of decimals in the given token
150     function getDecimals(address token)
151         internal
152         view
153         returns (uint256 decimals)
154     {
155         bytes4 functionSig = bytes4(keccak256("decimals()"));
156 
157         /// @dev Using assembly due to issues with current solidity `address.call()`
158         /// implementation: https://github.com/ethereum/solidity/issues/2884
159         assembly {
160             // Pointer to next free memory slot
161             let ptr := mload(0x40)
162             // Store functionSig variable at ptr
163             mstore(ptr,functionSig)
164             let functionSigLength := 0x04
165             let wordLength := 0x20
166 
167             let success := call(
168                                 5000, // Amount of gas
169                                 token, // Address to call
170                                 0, // ether to send
171                                 ptr, // ptr to input data
172                                 functionSigLength, // size of data
173                                 ptr, // where to store output data (overwrite input)
174                                 wordLength // size of output data (32 bytes)
175                                )
176 
177             switch success
178             case 0 {
179                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
180             }
181             case 1 {
182                 decimals := mload(ptr) // Set decimals to return data from call
183             }
184             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
185         }
186     }
187 
188     /// @dev Checks that a given address has its token allowance and balance set above the given amount
189     /// @param tokenOwner the address which should have custody of the token
190     /// @param tokenAddress the address of the token to check
191     /// @param tokenAmount the amount of the token which should be set
192     /// @param addressToAllow the address which should be allowed to transfer the token
193     /// @return bool true if the allowance and balance is set, false if not
194     function tokenAllowanceAndBalanceSet(
195         address tokenOwner,
196         address tokenAddress,
197         uint256 tokenAmount,
198         address addressToAllow
199     )
200         internal
201         view
202         returns (bool)
203     {
204         return (
205             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
206             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
207         );
208     }
209 
210     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
211         if (dstDecimals >= srcDecimals) {
212             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
213             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
214         } else {
215             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
216             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
217         }
218     }
219 
220     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
221 
222         //source quantity is rounded up. to avoid dest quantity being too low.
223         uint numerator;
224         uint denominator;
225         if (srcDecimals >= dstDecimals) {
226             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
227             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
228             denominator = rate;
229         } else {
230             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
231             numerator = (PRECISION * dstQty);
232             denominator = (rate * (10**(dstDecimals - srcDecimals)));
233         }
234         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
235     }
236 
237     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns (uint) {
238         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
239     }
240 
241     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns (uint) {
242         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
243     }
244 
245     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
246         internal pure returns (uint)
247     {
248         require(srcAmount <= MAX_QTY);
249         require(destAmount <= MAX_QTY);
250 
251         if (dstDecimals >= srcDecimals) {
252             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
253             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
254         } else {
255             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
256             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
257         }
258     }
259 
260     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
261     function min(uint256 a, uint256 b) internal pure returns (uint256) {
262         return a < b ? a : b;
263     }
264 }
265 
266 library ERC20SafeTransfer {
267     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
268 
269         require(_tokenAddress.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
270 
271         return fetchReturnData();
272     }
273 
274     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
275 
276         require(_tokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
277 
278         return fetchReturnData();
279     }
280 
281     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
282 
283         require(_tokenAddress.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
284 
285         return fetchReturnData();
286     }
287 
288     function fetchReturnData() internal returns (bool success){
289         assembly {
290             switch returndatasize()
291             case 0 {
292                 success := 1
293             }
294             case 32 {
295                 returndatacopy(0, 0, 32)
296                 success := mload(0)
297             }
298             default {
299                 revert(0, 0)
300             }
301         }
302     }
303 
304 }
305 
306 /// @title A contract which is used to check and set allowances of tokens
307 /// @dev In order to use this contract is must be inherited in the contract which is using
308 /// its functionality
309 contract AllowanceSetter {
310     uint256 constant MAX_UINT = 2**256 - 1;
311 
312     /// @notice A function which allows the caller to approve the max amount of any given token
313     /// @dev In order to function correctly, token allowances should not be set anywhere else in
314     /// the inheriting contract
315     /// @param addressToApprove the address which we want to approve to transfer the token
316     /// @param token the token address which we want to call approve on
317     function approveAddress(address addressToApprove, address token) internal {
318         if(ERC20(token).allowance(address(this), addressToApprove) == 0) {
319             require(ERC20SafeTransfer.safeApprove(token, addressToApprove, MAX_UINT));
320         }
321     }
322 
323 }
324 
325 contract ErrorReporter {
326     function revertTx(string reason) public pure {
327         revert(reason);
328     }
329 }
330 
331 /**
332  * @title Ownable
333  * @dev The Ownable contract has an owner address, and provides basic authorization control
334  * functions, this simplifies the implementation of "user permissions".
335  */
336 contract Ownable {
337   address public owner;
338 
339 
340   event OwnershipRenounced(address indexed previousOwner);
341   event OwnershipTransferred(
342     address indexed previousOwner,
343     address indexed newOwner
344   );
345 
346 
347   /**
348    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
349    * account.
350    */
351   constructor() public {
352     owner = msg.sender;
353   }
354 
355   /**
356    * @dev Throws if called by any account other than the owner.
357    */
358   modifier onlyOwner() {
359     require(msg.sender == owner);
360     _;
361   }
362 
363   /**
364    * @dev Allows the current owner to relinquish control of the contract.
365    * @notice Renouncing to ownership will leave the contract without an owner.
366    * It will not be possible to call the functions with the `onlyOwner`
367    * modifier anymore.
368    */
369   function renounceOwnership() public onlyOwner {
370     emit OwnershipRenounced(owner);
371     owner = address(0);
372   }
373 
374   /**
375    * @dev Allows the current owner to transfer control of the contract to a newOwner.
376    * @param _newOwner The address to transfer ownership to.
377    */
378   function transferOwnership(address _newOwner) public onlyOwner {
379     _transferOwnership(_newOwner);
380   }
381 
382   /**
383    * @dev Transfers control of the contract to a newOwner.
384    * @param _newOwner The address to transfer ownership to.
385    */
386   function _transferOwnership(address _newOwner) internal {
387     require(_newOwner != address(0));
388     emit OwnershipTransferred(owner, _newOwner);
389     owner = _newOwner;
390   }
391 }
392 
393 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
394 /// some functions
395 /// @dev Defines a modifier which should be used when only the totle contract should
396 /// able able to call a function
397 contract TotleControl is Ownable {
398     mapping(address => bool) public authorizedPrimaries;
399 
400     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
401     modifier onlyTotle() {
402         require(authorizedPrimaries[msg.sender]);
403         _;
404     }
405 
406     /// @notice Contract constructor
407     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
408     /// @param _totlePrimary the address of the contract to be set as totlePrimary
409     constructor(address _totlePrimary) public {
410         authorizedPrimaries[_totlePrimary] = true;
411     }
412 
413     /// @notice A function which allows only the owner to change the address of totlePrimary
414     /// @dev onlyOwner modifier only allows the contract owner to run the code
415     /// @param _totlePrimary the address of the contract to be set as totlePrimary
416     function addTotle(
417         address _totlePrimary
418     ) external onlyOwner {
419         authorizedPrimaries[_totlePrimary] = true;
420     }
421 
422     function removeTotle(
423         address _totlePrimary
424     ) external onlyOwner {
425         authorizedPrimaries[_totlePrimary] = false;
426     }
427 }
428 
429 /// @title A contract which allows its owner to withdraw any ether which is contained inside
430 contract Withdrawable is Ownable {
431 
432     /// @notice Withdraw ether contained in this contract and send it back to owner
433     /// @dev onlyOwner modifier only allows the contract owner to run the code
434     /// @param _token The address of the token that the user wants to withdraw
435     /// @param _amount The amount of tokens that the caller wants to withdraw
436     /// @return bool value indicating whether the transfer was successful
437     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
438         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
439     }
440 
441     /// @notice Withdraw ether contained in this contract and send it back to owner
442     /// @dev onlyOwner modifier only allows the contract owner to run the code
443     /// @param _amount The amount of ether that the caller wants to withdraw
444     function withdrawETH(uint256 _amount) external onlyOwner {
445         owner.transfer(_amount);
446     }
447 }
448 
449 /**
450  * @title Pausable
451  * @dev Base contract which allows children to implement an emergency stop mechanism.
452  */
453 contract Pausable is Ownable {
454   event Paused();
455   event Unpaused();
456 
457   bool private _paused = false;
458 
459   /**
460    * @return true if the contract is paused, false otherwise.
461    */
462   function paused() public view returns (bool) {
463     return _paused;
464   }
465 
466   /**
467    * @dev Modifier to make a function callable only when the contract is not paused.
468    */
469   modifier whenNotPaused() {
470     require(!_paused, "Contract is paused.");
471     _;
472   }
473 
474   /**
475    * @dev Modifier to make a function callable only when the contract is paused.
476    */
477   modifier whenPaused() {
478     require(_paused, "Contract not paused.");
479     _;
480   }
481 
482   /**
483    * @dev called by the owner to pause, triggers stopped state
484    */
485   function pause() public onlyOwner whenNotPaused {
486     _paused = true;
487     emit Paused();
488   }
489 
490   /**
491    * @dev called by the owner to unpause, returns to normal state
492    */
493   function unpause() public onlyOwner whenPaused {
494     _paused = false;
495     emit Unpaused();
496   }
497 }
498 
499 contract SelectorProvider {
500     bytes4 constant getAmountToGiveSelector = bytes4(keccak256("getAmountToGive(bytes)"));
501     bytes4 constant staticExchangeChecksSelector = bytes4(keccak256("staticExchangeChecks(bytes)"));
502     bytes4 constant performBuyOrderSelector = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
503     bytes4 constant performSellOrderSelector = bytes4(keccak256("performSellOrder(bytes,uint256)"));
504 
505     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
506 }
507 
508 /// @title Interface for all exchange handler contracts
509 contract ExchangeHandler is SelectorProvider, TotleControl, Withdrawable, Pausable {
510 
511     /*
512     *   State Variables
513     */
514 
515     ErrorReporter public errorReporter;
516     /* Logger public logger; */
517     /*
518     *   Modifiers
519     */
520 
521     /// @notice Constructor
522     /// @dev Calls the constructor of the inherited TotleControl
523     /// @param totlePrimary the address of the totlePrimary contract
524     constructor(
525         address totlePrimary,
526         address _errorReporter
527         /* ,address _logger */
528     )
529         TotleControl(totlePrimary)
530         public
531     {
532         require(_errorReporter != address(0x0));
533         /* require(_logger != address(0x0)); */
534         errorReporter = ErrorReporter(_errorReporter);
535         /* logger = Logger(_logger); */
536     }
537 
538     /// @notice Gets the amount that Totle needs to give for this order
539     /// @param genericPayload the data for this order in a generic format
540     /// @return amountToGive amount taker needs to give in order to fill the order
541     function getAmountToGive(
542         bytes genericPayload
543     )
544         public
545         view
546         returns (uint256 amountToGive)
547     {
548         bool success;
549         bytes4 functionSelector = getSelector(this.getAmountToGive.selector);
550 
551         assembly {
552             let functionSelectorLength := 0x04
553             let functionSelectorOffset := 0x1C
554             let scratchSpace := 0x0
555             let wordLength := 0x20
556             let bytesLength := mload(genericPayload)
557             let totalLength := add(functionSelectorLength, bytesLength)
558             let startOfNewData := add(genericPayload, functionSelectorOffset)
559 
560             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
561             let functionSelectorCorrect := mload(scratchSpace)
562             mstore(genericPayload, functionSelectorCorrect)
563 
564             success := delegatecall(
565                             gas,
566                             address, // This address of the current contract
567                             startOfNewData, // Start data at the beginning of the functionSelector
568                             totalLength, // Total length of all data, including functionSelector
569                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
570                             wordLength // Length of return variable is one word
571                            )
572             amountToGive := mload(scratchSpace)
573             if eq(success, 0) { revert(0, 0) }
574         }
575     }
576 
577     /// @notice Perform exchange-specific checks on the given order
578     /// @dev this should be called to check for payload errors
579     /// @param genericPayload the data for this order in a generic format
580     /// @return checksPassed value representing pass or fail
581     function staticExchangeChecks(
582         bytes genericPayload
583     )
584         public
585         view
586         returns (bool checksPassed)
587     {
588         bool success;
589         bytes4 functionSelector = getSelector(this.staticExchangeChecks.selector);
590         assembly {
591             let functionSelectorLength := 0x04
592             let functionSelectorOffset := 0x1C
593             let scratchSpace := 0x0
594             let wordLength := 0x20
595             let bytesLength := mload(genericPayload)
596             let totalLength := add(functionSelectorLength, bytesLength)
597             let startOfNewData := add(genericPayload, functionSelectorOffset)
598 
599             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
600             let functionSelectorCorrect := mload(scratchSpace)
601             mstore(genericPayload, functionSelectorCorrect)
602 
603             success := delegatecall(
604                             gas,
605                             address, // This address of the current contract
606                             startOfNewData, // Start data at the beginning of the functionSelector
607                             totalLength, // Total length of all data, including functionSelector
608                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
609                             wordLength // Length of return variable is one word
610                            )
611             checksPassed := mload(scratchSpace)
612             if eq(success, 0) { revert(0, 0) }
613         }
614     }
615 
616     /// @notice Perform a buy order at the exchange
617     /// @param genericPayload the data for this order in a generic format
618     /// @param  amountToGiveForOrder amount that should be spent on this order
619     /// @return amountSpentOnOrder the amount that would be spent on the order
620     /// @return amountReceivedFromOrder the amount that was received from this order
621     function performBuyOrder(
622         bytes genericPayload,
623         uint256 amountToGiveForOrder
624     )
625         public
626         payable
627         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
628     {
629         bool success;
630         bytes4 functionSelector = getSelector(this.performBuyOrder.selector);
631         assembly {
632             let callDataOffset := 0x44
633             let functionSelectorOffset := 0x1C
634             let functionSelectorLength := 0x04
635             let scratchSpace := 0x0
636             let wordLength := 0x20
637             let startOfFreeMemory := mload(0x40)
638 
639             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
640 
641             let bytesLength := mload(startOfFreeMemory)
642             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
643 
644             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
645 
646             let functionSelectorCorrect := mload(scratchSpace)
647 
648             mstore(startOfFreeMemory, functionSelectorCorrect)
649 
650             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
651 
652             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
653 
654             success := delegatecall(
655                             gas,
656                             address, // This address of the current contract
657                             startOfNewData, // Start data at the beginning of the functionSelector
658                             totalLength, // Total length of all data, including functionSelector
659                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
660                             mul(wordLength, 0x02) // Length of return variables is two words
661                           )
662             amountSpentOnOrder := mload(scratchSpace)
663             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
664             if eq(success, 0) { revert(0, 0) }
665         }
666     }
667 
668     /// @notice Perform a sell order at the exchange
669     /// @param genericPayload the data for this order in a generic format
670     /// @param  amountToGiveForOrder amount that should be spent on this order
671     /// @return amountSpentOnOrder the amount that would be spent on the order
672     /// @return amountReceivedFromOrder the amount that was received from this order
673     function performSellOrder(
674         bytes genericPayload,
675         uint256 amountToGiveForOrder
676     )
677         public
678         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
679     {
680         bool success;
681         bytes4 functionSelector = getSelector(this.performSellOrder.selector);
682         assembly {
683             let callDataOffset := 0x44
684             let functionSelectorOffset := 0x1C
685             let functionSelectorLength := 0x04
686             let scratchSpace := 0x0
687             let wordLength := 0x20
688             let startOfFreeMemory := mload(0x40)
689 
690             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
691 
692             let bytesLength := mload(startOfFreeMemory)
693             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
694 
695             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
696 
697             let functionSelectorCorrect := mload(scratchSpace)
698 
699             mstore(startOfFreeMemory, functionSelectorCorrect)
700 
701             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
702 
703             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
704 
705             success := delegatecall(
706                             gas,
707                             address, // This address of the current contract
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
720 interface EtherDelta {
721     function deposit() external payable;
722     function withdraw(uint256 amount) external;
723     function depositToken(address token, uint256 amount) external;
724     function withdrawToken(address token, uint256 amount) external;
725     function trade(address tokenGet, uint256 amountGet, address tokenGive, uint256 amountGive, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s, uint256 amount) external;
726     function availableVolume(address tokenGet, uint256 amountGet, address tokenGive, uint256 amountGive, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s) external view returns (uint256);
727 }
728 
729 /// @title EtherDeltaHandler
730 /// @notice Handles the all EtherDelta trades for the primary contract
731 contract EtherDeltaHandler is ExchangeHandler, AllowanceSetter {
732 
733     /*
734     *   State Variables
735     */
736 
737     EtherDelta public exchange;
738 
739     /*
740     *   Types
741     */
742 
743     struct OrderData {
744         address user;
745         address tokenGive;
746         address tokenGet;
747         uint256 amountGive;
748         uint256 amountGet;
749         uint256 expires;
750         uint256 nonce;
751         uint8 v;
752         bytes32 r;
753         bytes32 s;
754         uint256 exchangeFee;
755     }
756 
757     /// @notice Constructor
758     /// @param _exchange Address of the EtherDelta exchange
759     /// @param totlePrimary the address of the totlePrimary contract
760     /// @param errorReporter the address of the error reporter contract
761     constructor(
762         address _exchange,
763         address totlePrimary,
764         address errorReporter
765         /* ,address logger */
766     )
767         ExchangeHandler(totlePrimary, errorReporter/*, logger*/)
768         public
769     {
770         require(_exchange != address(0x0));
771         exchange = EtherDelta(_exchange);
772     }
773 
774     /*
775     *   Public functions
776     */
777 
778     /// @notice Gets the amount that Totle needs to give for this order
779     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
780     /// should only be called from functions which are inherited from the ExchangeHandler
781     /// base contract
782     /// @param data OrderData struct containing order values
783     /// @return amountToGive amount taker needs to give in order to fill the order
784     function getAmountToGive(
785         OrderData data
786     )
787         public
788         view
789         onlyTotle
790         returns (uint256 amountToGive)
791     {
792         uint256 availableVolume = exchange.availableVolume(
793             data.tokenGet,
794             data.amountGet,
795             data.tokenGive,
796             data.amountGive,
797             data.expires,
798             data.nonce,
799             data.user,
800             data.v,
801             data.r,
802             data.s
803         );
804         /* logger.log("Getting available volume from Etherdelta", availableVolume); */
805         // Adds the exchange fee onto the available amount
806         amountToGive = SafeMath.add(SafeMath.mul(availableVolume, data.exchangeFee), availableVolume);
807 
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