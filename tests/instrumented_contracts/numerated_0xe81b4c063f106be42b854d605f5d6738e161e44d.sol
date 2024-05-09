1 pragma solidity 0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   function totalSupply() public view returns (uint256);
10 
11   function balanceOf(address _who) public view returns (uint256);
12 
13   function allowance(address _owner, address _spender)
14     public view returns (uint256);
15 
16   function transfer(address _to, uint256 _value) public returns (bool);
17 
18   function approve(address _spender, uint256 _value)
19     public returns (bool);
20 
21   function transferFrom(address _from, address _to, uint256 _value)
22     public returns (bool);
23 
24   function decimals() public view returns (uint256);
25 
26   event Transfer(
27     address indexed from,
28     address indexed to,
29     uint256 value
30   );
31 
32   event Approval(
33     address indexed owner,
34     address indexed spender,
35     uint256 value
36   );
37 }
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that revert on error
42  */
43 library SafeMath {
44 
45   /**
46   * @dev Multiplies two numbers, reverts on overflow.
47   */
48   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
49     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50     // benefit is lost if 'b' is also tested.
51     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52     if (_a == 0) {
53       return 0;
54     }
55 
56     uint256 c = _a * _b;
57     require(c / _a == _b);
58 
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
64   */
65   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     require(_b > 0); // Solidity only automatically asserts when dividing by 0
67     uint256 c = _a / _b;
68     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69 
70     return c;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
77     require(_b <= _a);
78     uint256 c = _a - _b;
79 
80     return c;
81   }
82 
83   /**
84   * @dev Adds two numbers, reverts on overflow.
85   */
86   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
87     uint256 c = _a + _b;
88     require(c >= _a);
89 
90     return c;
91   }
92 
93   /**
94   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
95   * reverts when dividing by zero.
96   */
97   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98     require(b != 0);
99     return a % b;
100   }
101 }
102 
103 /*
104     Modified Util contract as used by Kyber Network
105 */
106 
107 library Utils {
108 
109     uint256 constant internal PRECISION = (10**18);
110     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
111     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
112     uint256 constant internal MAX_DECIMALS = 18;
113     uint256 constant internal ETH_DECIMALS = 18;
114     uint256 constant internal MAX_UINT = 2**256-1;
115 
116     // Currently constants can't be accessed from other contracts, so providing functions to do that here
117     function precision() internal pure returns (uint256) { return PRECISION; }
118     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
119     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
120     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
121     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
122     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
123 
124     /// @notice Retrieve the number of decimals used for a given ERC20 token
125     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
126     /// ensure that an exception doesn't cause transaction failure
127     /// @param token the token for which we should retrieve the decimals
128     /// @return decimals the number of decimals in the given token
129     function getDecimals(address token)
130         internal
131         view
132         returns (uint256 decimals)
133     {
134         bytes4 functionSig = bytes4(keccak256("decimals()"));
135 
136         /// @dev Using assembly due to issues with current solidity `address.call()`
137         /// implementation: https://github.com/ethereum/solidity/issues/2884
138         assembly {
139             // Pointer to next free memory slot
140             let ptr := mload(0x40)
141             // Store functionSig variable at ptr
142             mstore(ptr,functionSig)
143             let functionSigLength := 0x04
144             let wordLength := 0x20
145 
146             let success := call(
147                                 5000, // Amount of gas
148                                 token, // Address to call
149                                 0, // ether to send
150                                 ptr, // ptr to input data
151                                 functionSigLength, // size of data
152                                 ptr, // where to store output data (overwrite input)
153                                 wordLength // size of output data (32 bytes)
154                                )
155 
156             switch success
157             case 0 {
158                 decimals := 18 // If the token doesn't implement `decimals()`, return 18 as default
159             }
160             case 1 {
161                 decimals := mload(ptr) // Set decimals to return data from call
162             }
163             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
164         }
165     }
166 
167     /// @dev Checks that a given address has its token allowance and balance set above the given amount
168     /// @param tokenOwner the address which should have custody of the token
169     /// @param tokenAddress the address of the token to check
170     /// @param tokenAmount the amount of the token which should be set
171     /// @param addressToAllow the address which should be allowed to transfer the token
172     /// @return bool true if the allowance and balance is set, false if not
173     function tokenAllowanceAndBalanceSet(
174         address tokenOwner,
175         address tokenAddress,
176         uint256 tokenAmount,
177         address addressToAllow
178     )
179         internal
180         view
181         returns (bool)
182     {
183         return (
184             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
185             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
186         );
187     }
188 
189     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
190         if (dstDecimals >= srcDecimals) {
191             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
192             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
193         } else {
194             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
195             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
196         }
197     }
198 
199     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
200 
201         //source quantity is rounded up. to avoid dest quantity being too low.
202         uint numerator;
203         uint denominator;
204         if (srcDecimals >= dstDecimals) {
205             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
206             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
207             denominator = rate;
208         } else {
209             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
210             numerator = (PRECISION * dstQty);
211             denominator = (rate * (10**(dstDecimals - srcDecimals)));
212         }
213         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
214     }
215 
216     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns (uint) {
217         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
218     }
219 
220     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns (uint) {
221         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
222     }
223 
224     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
225         internal pure returns (uint)
226     {
227         require(srcAmount <= MAX_QTY);
228         require(destAmount <= MAX_QTY);
229 
230         if (dstDecimals >= srcDecimals) {
231             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
232             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
233         } else {
234             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
235             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
236         }
237     }
238 
239     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
240     function min(uint256 a, uint256 b) internal pure returns (uint256) {
241         return a < b ? a : b;
242     }
243 }
244 
245 library ERC20SafeTransfer {
246     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
247 
248         require(_tokenAddress.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
249 
250         return fetchReturnData();
251     }
252 
253     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
254 
255         require(_tokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
256 
257         return fetchReturnData();
258     }
259 
260     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
261 
262         require(_tokenAddress.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
263 
264         return fetchReturnData();
265     }
266 
267     function fetchReturnData() internal returns (bool success){
268         assembly {
269             switch returndatasize()
270             case 0 {
271                 success := 1
272             }
273             case 32 {
274                 returndatacopy(0, 0, 32)
275                 success := mload(0)
276             }
277             default {
278                 revert(0, 0)
279             }
280         }
281     }
282 
283 }
284 
285 /// @title A contract which is used to check and set allowances of tokens
286 /// @dev In order to use this contract is must be inherited in the contract which is using
287 /// its functionality
288 contract AllowanceSetter {
289     uint256 constant MAX_UINT = 2**256 - 1;
290 
291     /// @notice A function which allows the caller to approve the max amount of any given token
292     /// @dev In order to function correctly, token allowances should not be set anywhere else in
293     /// the inheriting contract
294     /// @param addressToApprove the address which we want to approve to transfer the token
295     /// @param token the token address which we want to call approve on
296     function approveAddress(address addressToApprove, address token) internal {
297         if(ERC20(token).allowance(address(this), addressToApprove) == 0) {
298             require(ERC20SafeTransfer.safeApprove(token, addressToApprove, MAX_UINT));
299         }
300     }
301 
302 }
303 
304 contract ErrorReporter {
305     function revertTx(string reason) public pure {
306         revert(reason);
307     }
308 }
309 
310 /**
311  * @title Ownable
312  * @dev The Ownable contract has an owner address, and provides basic authorization control
313  * functions, this simplifies the implementation of "user permissions".
314  */
315 contract Ownable {
316   address public owner;
317 
318   event OwnershipRenounced(address indexed previousOwner);
319   event OwnershipTransferred(
320     address indexed previousOwner,
321     address indexed newOwner
322   );
323 
324   /**
325    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
326    * account.
327    */
328   constructor() public {
329     owner = msg.sender;
330   }
331 
332   /**
333    * @dev Throws if called by any account other than the owner.
334    */
335   modifier onlyOwner() {
336     require(msg.sender == owner);
337     _;
338   }
339 
340   /**
341    * @dev Allows the current owner to relinquish control of the contract.
342    * @notice Renouncing to ownership will leave the contract without an owner.
343    * It will not be possible to call the functions with the `onlyOwner`
344    * modifier anymore.
345    */
346   function renounceOwnership() public onlyOwner {
347     emit OwnershipRenounced(owner);
348     owner = address(0);
349   }
350 
351   /**
352    * @dev Allows the current owner to transfer control of the contract to a newOwner.
353    * @param _newOwner The address to transfer ownership to.
354    */
355   function transferOwnership(address _newOwner) public onlyOwner {
356     _transferOwnership(_newOwner);
357   }
358 
359   /**
360    * @dev Transfers control of the contract to a newOwner.
361    * @param _newOwner The address to transfer ownership to.
362    */
363   function _transferOwnership(address _newOwner) internal {
364     require(_newOwner != address(0));
365     emit OwnershipTransferred(owner, _newOwner);
366     owner = _newOwner;
367   }
368 }
369 
370 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
371 /// some functions
372 /// @dev Defines a modifier which should be used when only the totle contract should
373 /// able able to call a function
374 contract TotleControl is Ownable {
375     address public totlePrimary;
376 
377     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
378     modifier onlyTotle() {
379         require(msg.sender == totlePrimary);
380         _;
381     }
382 
383     /// @notice Contract constructor
384     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
385     /// @param _totlePrimary the address of the contract to be set as totlePrimary
386     constructor(address _totlePrimary) public {
387         require(_totlePrimary != address(0x0));
388         totlePrimary = _totlePrimary;
389     }
390 
391     /// @notice A function which allows only the owner to change the address of totlePrimary
392     /// @dev onlyOwner modifier only allows the contract owner to run the code
393     /// @param _totlePrimary the address of the contract to be set as totlePrimary
394     function setTotle(
395         address _totlePrimary
396     ) external onlyOwner {
397         require(_totlePrimary != address(0x0));
398         totlePrimary = _totlePrimary;
399     }
400 }
401 
402 /// @title A contract which allows its owner to withdraw any ether which is contained inside
403 contract Withdrawable is Ownable {
404 
405     /// @notice Withdraw ether contained in this contract and send it back to owner
406     /// @dev onlyOwner modifier only allows the contract owner to run the code
407     /// @param _token The address of the token that the user wants to withdraw
408     /// @param _amount The amount of tokens that the caller wants to withdraw
409     /// @return bool value indicating whether the transfer was successful
410     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
411         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
412     }
413 
414     /// @notice Withdraw ether contained in this contract and send it back to owner
415     /// @dev onlyOwner modifier only allows the contract owner to run the code
416     /// @param _amount The amount of ether that the caller wants to withdraw
417     function withdrawETH(uint256 _amount) external onlyOwner {
418         owner.transfer(_amount);
419     }
420 }
421 
422 /**
423  * @title Pausable
424  * @dev Base contract which allows children to implement an emergency stop mechanism.
425  */
426 contract Pausable is Ownable {
427   event Paused();
428   event Unpaused();
429 
430   bool private _paused = false;
431 
432   /**
433    * @return true if the contract is paused, false otherwise.
434    */
435   function paused() public view returns (bool) {
436     return _paused;
437   }
438 
439   /**
440    * @dev Modifier to make a function callable only when the contract is not paused.
441    */
442   modifier whenNotPaused() {
443     require(!_paused, "Contract is paused.");
444     _;
445   }
446 
447   /**
448    * @dev Modifier to make a function callable only when the contract is paused.
449    */
450   modifier whenPaused() {
451     require(_paused, "Contract not paused.");
452     _;
453   }
454 
455   /**
456    * @dev called by the owner to pause, triggers stopped state
457    */
458   function pause() public onlyOwner whenNotPaused {
459     _paused = true;
460     emit Paused();
461   }
462 
463   /**
464    * @dev called by the owner to unpause, returns to normal state
465    */
466   function unpause() public onlyOwner whenPaused {
467     _paused = false;
468     emit Unpaused();
469   }
470 }
471 
472 contract SelectorProvider {
473     bytes4 constant getAmountToGive = bytes4(keccak256("getAmountToGive(bytes)"));
474     bytes4 constant staticExchangeChecks = bytes4(keccak256("staticExchangeChecks(bytes)"));
475     bytes4 constant performBuyOrder = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
476     bytes4 constant performSellOrder = bytes4(keccak256("performSellOrder(bytes,uint256)"));
477 
478     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
479 }
480 
481 /// @title Interface for all exchange handler contracts
482 contract ExchangeHandler is TotleControl, Withdrawable, Pausable {
483 
484     /*
485     *   State Variables
486     */
487 
488     SelectorProvider public selectorProvider;
489     ErrorReporter public errorReporter;
490     /* Logger public logger; */
491     /*
492     *   Modifiers
493     */
494 
495     modifier onlySelf() {
496         require(msg.sender == address(this));
497         _;
498     }
499 
500     /// @notice Constructor
501     /// @dev Calls the constructor of the inherited TotleControl
502     /// @param _selectorProvider the provider for this exchanges function selectors
503     /// @param totlePrimary the address of the totlePrimary contract
504     constructor(
505         address _selectorProvider,
506         address totlePrimary,
507         address _errorReporter
508         /* ,address _logger */
509     )
510         TotleControl(totlePrimary)
511         public
512     {
513         require(_selectorProvider != address(0x0));
514         require(_errorReporter != address(0x0));
515         /* require(_logger != address(0x0)); */
516         selectorProvider = SelectorProvider(_selectorProvider);
517         errorReporter = ErrorReporter(_errorReporter);
518         /* logger = Logger(_logger); */
519     }
520 
521     /// @notice Gets the amount that Totle needs to give for this order
522     /// @param genericPayload the data for this order in a generic format
523     /// @return amountToGive amount taker needs to give in order to fill the order
524     function getAmountToGive(
525         bytes genericPayload
526     )
527         public
528         view
529         onlyTotle
530         whenNotPaused
531         returns (uint256 amountToGive)
532     {
533         bool success;
534         bytes4 functionSelector = selectorProvider.getSelector(this.getAmountToGive.selector);
535 
536         assembly {
537             let functionSelectorLength := 0x04
538             let functionSelectorOffset := 0x1C
539             let scratchSpace := 0x0
540             let wordLength := 0x20
541             let bytesLength := mload(genericPayload)
542             let totalLength := add(functionSelectorLength, bytesLength)
543             let startOfNewData := add(genericPayload, functionSelectorOffset)
544 
545             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
546             let functionSelectorCorrect := mload(scratchSpace)
547             mstore(genericPayload, functionSelectorCorrect)
548 
549             success := call(
550                             gas,
551                             address, // This address of the current contract
552                             callvalue,
553                             startOfNewData, // Start data at the beginning of the functionSelector
554                             totalLength, // Total length of all data, including functionSelector
555                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
556                             wordLength // Length of return variable is one word
557                            )
558             amountToGive := mload(scratchSpace)
559             if eq(success, 0) { revert(0, 0) }
560         }
561     }
562 
563     /// @notice Perform exchange-specific checks on the given order
564     /// @dev this should be called to check for payload errors
565     /// @param genericPayload the data for this order in a generic format
566     /// @return checksPassed value representing pass or fail
567     function staticExchangeChecks(
568         bytes genericPayload
569     )
570         public
571         view
572         onlyTotle
573         whenNotPaused
574         returns (bool checksPassed)
575     {
576         bool success;
577         bytes4 functionSelector = selectorProvider.getSelector(this.staticExchangeChecks.selector);
578         assembly {
579             let functionSelectorLength := 0x04
580             let functionSelectorOffset := 0x1C
581             let scratchSpace := 0x0
582             let wordLength := 0x20
583             let bytesLength := mload(genericPayload)
584             let totalLength := add(functionSelectorLength, bytesLength)
585             let startOfNewData := add(genericPayload, functionSelectorOffset)
586 
587             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
588             let functionSelectorCorrect := mload(scratchSpace)
589             mstore(genericPayload, functionSelectorCorrect)
590 
591             success := call(
592                             gas,
593                             address, // This address of the current contract
594                             callvalue,
595                             startOfNewData, // Start data at the beginning of the functionSelector
596                             totalLength, // Total length of all data, including functionSelector
597                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
598                             wordLength // Length of return variable is one word
599                            )
600             checksPassed := mload(scratchSpace)
601             if eq(success, 0) { revert(0, 0) }
602         }
603     }
604 
605     /// @notice Perform a buy order at the exchange
606     /// @param genericPayload the data for this order in a generic format
607     /// @param  amountToGiveForOrder amount that should be spent on this order
608     /// @return amountSpentOnOrder the amount that would be spent on the order
609     /// @return amountReceivedFromOrder the amount that was received from this order
610     function performBuyOrder(
611         bytes genericPayload,
612         uint256 amountToGiveForOrder
613     )
614         public
615         payable
616         onlyTotle
617         whenNotPaused
618         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
619     {
620         bool success;
621         bytes4 functionSelector = selectorProvider.getSelector(this.performBuyOrder.selector);
622         assembly {
623             let callDataOffset := 0x44
624             let functionSelectorOffset := 0x1C
625             let functionSelectorLength := 0x04
626             let scratchSpace := 0x0
627             let wordLength := 0x20
628             let startOfFreeMemory := mload(0x40)
629 
630             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
631 
632             let bytesLength := mload(startOfFreeMemory)
633             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
634 
635             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
636 
637             let functionSelectorCorrect := mload(scratchSpace)
638 
639             mstore(startOfFreeMemory, functionSelectorCorrect)
640 
641             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
642 
643             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
644 
645             success := call(
646                             gas,
647                             address, // This address of the current contract
648                             callvalue,
649                             startOfNewData, // Start data at the beginning of the functionSelector
650                             totalLength, // Total length of all data, including functionSelector
651                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
652                             mul(wordLength, 0x02) // Length of return variables is two words
653                           )
654             amountSpentOnOrder := mload(scratchSpace)
655             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
656             if eq(success, 0) { revert(0, 0) }
657         }
658     }
659 
660     /// @notice Perform a sell order at the exchange
661     /// @param genericPayload the data for this order in a generic format
662     /// @param  amountToGiveForOrder amount that should be spent on this order
663     /// @return amountSpentOnOrder the amount that would be spent on the order
664     /// @return amountReceivedFromOrder the amount that was received from this order
665     function performSellOrder(
666         bytes genericPayload,
667         uint256 amountToGiveForOrder
668     )
669         public
670         onlyTotle
671         whenNotPaused
672         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
673     {
674         bool success;
675         bytes4 functionSelector = selectorProvider.getSelector(this.performSellOrder.selector);
676         assembly {
677             let callDataOffset := 0x44
678             let functionSelectorOffset := 0x1C
679             let functionSelectorLength := 0x04
680             let scratchSpace := 0x0
681             let wordLength := 0x20
682             let startOfFreeMemory := mload(0x40)
683 
684             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
685 
686             let bytesLength := mload(startOfFreeMemory)
687             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
688 
689             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
690 
691             let functionSelectorCorrect := mload(scratchSpace)
692 
693             mstore(startOfFreeMemory, functionSelectorCorrect)
694 
695             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
696 
697             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
698 
699             success := call(
700                             gas,
701                             address, // This address of the current contract
702                             callvalue,
703                             startOfNewData, // Start data at the beginning of the functionSelector
704                             totalLength, // Total length of all data, including functionSelector
705                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
706                             mul(wordLength, 0x02) // Length of return variables is two words
707                           )
708             amountSpentOnOrder := mload(scratchSpace)
709             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
710             if eq(success, 0) { revert(0, 0) }
711         }
712     }
713 }
714 
715 interface TokenStoreExchange {
716 
717    //Trading
718    function trade(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive,
719        uint _expires, uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s, uint _amount) external;
720 
721    // Get info
722    function fee() external constant returns(uint256);
723    function availableVolume(address _tokenGet, uint _amountGet, address _tokenGive, uint _amountGive, uint _expires,
724        uint _nonce, address _user, uint8 _v, bytes32 _r, bytes32 _s) external constant returns(uint);
725 
726    //Balance deposit/withdraw functions
727    function deposit() external payable; //Deposit ETH
728    function withdraw(uint256 amount) external; //Withdraw ETH
729    function depositToken(address _token, uint _amount) external;
730    function withdrawToken(address _token, uint _amount) external;
731 
732 }
733 
734 /// @title TokenStoreSelectorProvider
735 /// @notice Provides this exchange implementation with correctly formatted function selectors
736 contract TokenStoreSelectorProvider is SelectorProvider {
737     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
738         if (genericSelector == getAmountToGive) {
739             return bytes4(keccak256("getAmountToGive((address,uint256,address,uint256,uint256,uint256,address,uint8,bytes32,bytes32))"));
740         } else if (genericSelector == staticExchangeChecks) {
741             return bytes4(keccak256("staticExchangeChecks((address,uint256,address,uint256,uint256,uint256,address,uint8,bytes32,bytes32))"));
742         } else if (genericSelector == performBuyOrder) {
743             return bytes4(keccak256("performBuyOrder((address,uint256,address,uint256,uint256,uint256,address,uint8,bytes32,bytes32),uint256)"));
744         } else if (genericSelector == performSellOrder) {
745             return bytes4(keccak256("performSellOrder((address,uint256,address,uint256,uint256,uint256,address,uint8,bytes32,bytes32),uint256)"));
746         } else {
747             return bytes4(0x0);
748         }
749     }
750 }
751 
752 /// @title Handler for TokenStore exchange
753 contract TokenStoreHandler is ExchangeHandler, AllowanceSetter {
754 
755     /*
756     *   Types
757     */
758     struct OrderData {
759         address takerToken; //For a Totle sell, takerToken is the token address
760         uint256 takerAmount;
761         address makerToken; //For a Totle sell, makerToken is 0x0 (ETH)
762         uint256 makerAmount;
763         uint256 expires;
764         uint256 nonce;
765         address user; //Maker
766         uint8 v;
767         bytes32 r;
768         bytes32 s;
769     }
770 
771     TokenStoreExchange exchange;
772 
773     /// @notice Constructor
774     /// @param _exchange the address of the token store exchange
775     /// @param _selectorProvider the provider for this exchanges function selectors
776     /// @param _totlePrimary the address of the totlePrimary contract
777     /// @param errorReporter the address of of the errorReporter contract
778     constructor(
779         address _exchange,
780         address _selectorProvider,
781         address _totlePrimary,
782         address errorReporter/*,
783         address logger*/
784     ) ExchangeHandler(_selectorProvider, _totlePrimary, errorReporter/*, logger*/) public {
785         exchange = TokenStoreExchange(_exchange);
786     }
787 
788     /*
789     *   Internal functions
790     */
791 
792     /// @notice Gets the amount that TotlePrimary needs to give for this order
793     /// @param data OrderData struct containing order values
794     /// @return amountToGive amount taker needs to give in order to fill the order
795     function getAmountToGive(
796         OrderData data
797     )
798         public
799         view
800         whenNotPaused
801         onlySelf
802         returns (uint256 amountToGive)
803     {
804         uint256 feePercentage = exchange.fee();
805         uint256 availableVolume = exchange.availableVolume(data.takerToken, data.takerAmount, data.makerToken, data.makerAmount, data.expires,
806             data.nonce, data.user, data.v, data.r, data.s);
807         uint256 fee = SafeMath.div(SafeMath.mul(availableVolume, feePercentage), 1 ether);
808         return SafeMath.add(availableVolume, fee);
809     }
810 
811     /// @notice Perform exchange-specific checks on the given order
812     /// @dev This should be called to check for payload errors
813     /// @param data OrderData struct containing order values
814     /// @return checksPassed value representing pass or fail
815     function staticExchangeChecks(
816         OrderData data
817     )
818         public
819         view
820         whenNotPaused
821         onlySelf
822         returns (bool checksPassed)
823     {
824         bytes32 hash = sha256(abi.encodePacked(address(exchange), data.takerToken, data.takerAmount, data.makerToken, data.makerAmount, data.expires, data.nonce));
825         if (ecrecover(sha3(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), data.v, data.r, data.s) != data.user || block.number > data.expires) {
826             return false;
827         }
828         return true;
829     }
830 
831     /// @dev Perform a buy order at the exchange
832     /// @param data OrderData struct containing order values
833     /// @param  amountToGiveForOrder amount that should be spent on this order
834     /// @return amountSpentOnOrder the amount that would be spent on the order
835     /// @return amountReceivedFromOrder the amount that was received from this order
836     function performBuyOrder(
837         OrderData data,
838         uint256 amountToGiveForOrder
839     )
840         public
841         payable
842         whenNotPaused
843         onlySelf
844         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
845     {
846         amountSpentOnOrder = amountToGiveForOrder;
847         exchange.deposit.value(amountToGiveForOrder)();
848         uint256 amountToSpend = removeFee(amountToGiveForOrder);
849         amountReceivedFromOrder = SafeMath.div(SafeMath.mul(amountToSpend, data.makerAmount), data.takerAmount);
850         exchange.trade(data.takerToken, data.takerAmount, data.makerToken, data.makerAmount, data.expires, data.nonce, data.user, data.v, data.r, data.s, amountToSpend);
851         /* logger.log("Performing TokenStore buy order arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder);  */
852         exchange.withdrawToken(data.makerToken, amountReceivedFromOrder);
853         if (!ERC20SafeTransfer.safeTransfer(data.makerToken, totlePrimary, amountReceivedFromOrder)){
854             errorReporter.revertTx("Failed to transfer tokens to totle primary");
855         }
856 
857     }
858 
859     /// @dev Perform a sell order at the exchange
860     /// @param data OrderData struct containing order values
861     /// @param  amountToGiveForOrder amount that should be spent on this order
862     /// @return amountSpentOnOrder the amount that would be spent on the order
863     /// @return amountReceivedFromOrder the amount that was received from this order
864     function performSellOrder(
865         OrderData data,
866         uint256 amountToGiveForOrder
867     )
868         public
869         whenNotPaused
870         onlySelf
871         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
872     {
873         amountSpentOnOrder = amountToGiveForOrder;
874         approveAddress(address(exchange), data.takerToken);
875         exchange.depositToken(data.takerToken, amountToGiveForOrder);
876         uint256 amountToSpend = removeFee(amountToGiveForOrder);
877         amountReceivedFromOrder = SafeMath.div(SafeMath.mul(amountToSpend, data.makerAmount), data.takerAmount);
878         exchange.trade(data.takerToken, data.takerAmount, data.makerToken, data.makerAmount, data.expires, data.nonce, data.user, data.v, data.r, data.s, amountToSpend);
879         /* logger.log("Performing TokenStore sell order arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder",amountSpentOnOrder,amountReceivedFromOrder); */
880         exchange.withdraw(amountReceivedFromOrder);
881         totlePrimary.transfer(amountReceivedFromOrder);
882     }
883 
884     function removeFee(uint256 totalAmount) internal constant returns (uint256){
885       uint256 feePercentage = exchange.fee();
886       return SafeMath.div(SafeMath.mul(totalAmount, 1 ether), SafeMath.add(feePercentage, 1 ether));
887 
888     }
889 
890     /// @notice payable fallback to block EOA sending eth
891     /// @dev this should fail if an EOA (or contract with 0 bytecode size) tries to send ETH to this contract
892     function() public payable {
893         // Check in here that the sender is a contract! (to stop accidents)
894         uint256 size;
895         address sender = msg.sender;
896         assembly {
897             size := extcodesize(sender)
898         }
899         require(size > 0);
900     }
901 }