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
39 library ERC20SafeTransfer {
40     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
41 
42         require(_tokenAddress.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
43 
44         return fetchReturnData();
45     }
46 
47     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
48 
49         require(_tokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
50 
51         return fetchReturnData();
52     }
53 
54     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
55 
56         require(_tokenAddress.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
57 
58         return fetchReturnData();
59     }
60 
61     function fetchReturnData() internal returns (bool success){
62         assembly {
63             switch returndatasize()
64             case 0 {
65                 success := 1
66             }
67             case 32 {
68                 returndatacopy(0, 0, 32)
69                 success := mload(0)
70             }
71             default {
72                 revert(0, 0)
73             }
74         }
75     }
76 
77 }
78 
79 /// @title A contract which is used to check and set allowances of tokens
80 /// @dev In order to use this contract is must be inherited in the contract which is using
81 /// its functionality
82 contract AllowanceSetter {
83     uint256 constant MAX_UINT = 2**256 - 1;
84 
85     /// @notice A function which allows the caller to approve the max amount of any given token
86     /// @dev In order to function correctly, token allowances should not be set anywhere else in
87     /// the inheriting contract
88     /// @param addressToApprove the address which we want to approve to transfer the token
89     /// @param token the token address which we want to call approve on
90     function approveAddress(address addressToApprove, address token) internal {
91         if(ERC20(token).allowance(address(this), addressToApprove) == 0) {
92             require(ERC20SafeTransfer.safeApprove(token, addressToApprove, MAX_UINT));
93         }
94     }
95 
96 }
97 
98 contract ErrorReporter {
99     function revertTx(string reason) public pure {
100         revert(reason);
101     }
102 }
103 
104 /**
105  * @title Math
106  * @dev Assorted math operations
107  */
108 
109 library Math {
110   function max(uint256 a, uint256 b) internal pure returns (uint256) {
111     return a >= b ? a : b;
112   }
113 
114   function min(uint256 a, uint256 b) internal pure returns (uint256) {
115     return a < b ? a : b;
116   }
117 
118   function average(uint256 a, uint256 b) internal pure returns (uint256) {
119     // (a + b) / 2 can overflow, so we distribute
120     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
121   }
122 }
123 
124 /**
125  * @title SafeMath
126  * @dev Math operations with safety checks that revert on error
127  */
128 library SafeMath {
129 
130   /**
131   * @dev Multiplies two numbers, reverts on overflow.
132   */
133   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
134     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135     // benefit is lost if 'b' is also tested.
136     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
137     if (_a == 0) {
138       return 0;
139     }
140 
141     uint256 c = _a * _b;
142     require(c / _a == _b);
143 
144     return c;
145   }
146 
147   /**
148   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
149   */
150   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
151     require(_b > 0); // Solidity only automatically asserts when dividing by 0
152     uint256 c = _a / _b;
153     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
154 
155     return c;
156   }
157 
158   /**
159   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
160   */
161   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
162     require(_b <= _a);
163     uint256 c = _a - _b;
164 
165     return c;
166   }
167 
168   /**
169   * @dev Adds two numbers, reverts on overflow.
170   */
171   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
172     uint256 c = _a + _b;
173     require(c >= _a);
174 
175     return c;
176   }
177 
178   /**
179   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
180   * reverts when dividing by zero.
181   */
182   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
183     require(b != 0);
184     return a % b;
185   }
186 }
187 
188 /*
189     Modified Util contract as used by Kyber Network
190 */
191 
192 library Utils {
193 
194     uint256 constant internal PRECISION = (10**18);
195     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
196     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
197     uint256 constant internal MAX_DECIMALS = 18;
198     uint256 constant internal ETH_DECIMALS = 18;
199     uint256 constant internal MAX_UINT = 2**256-1;
200 
201     // Currently constants can't be accessed from other contracts, so providing functions to do that here
202     function precision() internal pure returns (uint256) { return PRECISION; }
203     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
204     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
205     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
206     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
207     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
208 
209     /// @notice Retrieve the number of decimals used for a given ERC20 token
210     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
211     /// ensure that an exception doesn't cause transaction failure
212     /// @param token the token for which we should retrieve the decimals
213     /// @return decimals the number of decimals in the given token
214     function getDecimals(address token)
215         internal
216         view
217         returns (uint256 decimals)
218     {
219         bytes4 functionSig = bytes4(keccak256("decimals()"));
220 
221         /// @dev Using assembly due to issues with current solidity `address.call()`
222         /// implementation: https://github.com/ethereum/solidity/issues/2884
223         assembly {
224             // Pointer to next free memory slot
225             let ptr := mload(0x40)
226             // Store functionSig variable at ptr
227             mstore(ptr,functionSig)
228             let functionSigLength := 0x04
229             let wordLength := 0x20
230 
231             let success := call(
232                                 5000, // Amount of gas
233                                 token, // Address to call
234                                 0, // ether to send
235                                 ptr, // ptr to input data
236                                 functionSigLength, // size of data
237                                 ptr, // where to store output data (overwrite input)
238                                 wordLength // size of output data (32 bytes)
239                                )
240 
241             switch success
242             case 0 {
243                 decimals := 18 // If the token doesn't implement `decimals()`, return 18 as default
244             }
245             case 1 {
246                 decimals := mload(ptr) // Set decimals to return data from call
247             }
248             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
249         }
250     }
251 
252     /// @dev Checks that a given address has its token allowance and balance set above the given amount
253     /// @param tokenOwner the address which should have custody of the token
254     /// @param tokenAddress the address of the token to check
255     /// @param tokenAmount the amount of the token which should be set
256     /// @param addressToAllow the address which should be allowed to transfer the token
257     /// @return bool true if the allowance and balance is set, false if not
258     function tokenAllowanceAndBalanceSet(
259         address tokenOwner,
260         address tokenAddress,
261         uint256 tokenAmount,
262         address addressToAllow
263     )
264         internal
265         view
266         returns (bool)
267     {
268         return (
269             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
270             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
271         );
272     }
273 
274     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
275         if (dstDecimals >= srcDecimals) {
276             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
277             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
278         } else {
279             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
280             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
281         }
282     }
283 
284     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
285 
286         //source quantity is rounded up. to avoid dest quantity being too low.
287         uint numerator;
288         uint denominator;
289         if (srcDecimals >= dstDecimals) {
290             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
291             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
292             denominator = rate;
293         } else {
294             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
295             numerator = (PRECISION * dstQty);
296             denominator = (rate * (10**(dstDecimals - srcDecimals)));
297         }
298         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
299     }
300 
301     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns (uint) {
302         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
303     }
304 
305     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns (uint) {
306         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
307     }
308 
309     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
310         internal pure returns (uint)
311     {
312         require(srcAmount <= MAX_QTY);
313         require(destAmount <= MAX_QTY);
314 
315         if (dstDecimals >= srcDecimals) {
316             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
317             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
318         } else {
319             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
320             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
321         }
322     }
323 
324     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
325     function min(uint256 a, uint256 b) internal pure returns (uint256) {
326         return a < b ? a : b;
327     }
328 }
329 
330 interface WETH {
331     function deposit() external payable;
332     function withdraw(uint256 amount) external;
333     function balanceOf(address account) external returns (uint256);
334 }
335 
336 /**
337  * @title Ownable
338  * @dev The Ownable contract has an owner address, and provides basic authorization control
339  * functions, this simplifies the implementation of "user permissions".
340  */
341 contract Ownable {
342   address public owner;
343 
344   event OwnershipRenounced(address indexed previousOwner);
345   event OwnershipTransferred(
346     address indexed previousOwner,
347     address indexed newOwner
348   );
349 
350   /**
351    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
352    * account.
353    */
354   constructor() public {
355     owner = msg.sender;
356   }
357 
358   /**
359    * @dev Throws if called by any account other than the owner.
360    */
361   modifier onlyOwner() {
362     require(msg.sender == owner);
363     _;
364   }
365 
366   /**
367    * @dev Allows the current owner to relinquish control of the contract.
368    * @notice Renouncing to ownership will leave the contract without an owner.
369    * It will not be possible to call the functions with the `onlyOwner`
370    * modifier anymore.
371    */
372   function renounceOwnership() public onlyOwner {
373     emit OwnershipRenounced(owner);
374     owner = address(0);
375   }
376 
377   /**
378    * @dev Allows the current owner to transfer control of the contract to a newOwner.
379    * @param _newOwner The address to transfer ownership to.
380    */
381   function transferOwnership(address _newOwner) public onlyOwner {
382     _transferOwnership(_newOwner);
383   }
384 
385   /**
386    * @dev Transfers control of the contract to a newOwner.
387    * @param _newOwner The address to transfer ownership to.
388    */
389   function _transferOwnership(address _newOwner) internal {
390     require(_newOwner != address(0));
391     emit OwnershipTransferred(owner, _newOwner);
392     owner = _newOwner;
393   }
394 }
395 
396 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
397 /// some functions
398 /// @dev Defines a modifier which should be used when only the totle contract should
399 /// able able to call a function
400 contract TotleControl is Ownable {
401     address public totlePrimary;
402 
403     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
404     modifier onlyTotle() {
405         require(msg.sender == totlePrimary);
406         _;
407     }
408 
409     /// @notice Contract constructor
410     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
411     /// @param _totlePrimary the address of the contract to be set as totlePrimary
412     constructor(address _totlePrimary) public {
413         require(_totlePrimary != address(0x0));
414         totlePrimary = _totlePrimary;
415     }
416 
417     /// @notice A function which allows only the owner to change the address of totlePrimary
418     /// @dev onlyOwner modifier only allows the contract owner to run the code
419     /// @param _totlePrimary the address of the contract to be set as totlePrimary
420     function setTotle(
421         address _totlePrimary
422     ) external onlyOwner {
423         require(_totlePrimary != address(0x0));
424         totlePrimary = _totlePrimary;
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
499     bytes4 constant getAmountToGive = bytes4(keccak256("getAmountToGive(bytes)"));
500     bytes4 constant staticExchangeChecks = bytes4(keccak256("staticExchangeChecks(bytes)"));
501     bytes4 constant performBuyOrder = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
502     bytes4 constant performSellOrder = bytes4(keccak256("performSellOrder(bytes,uint256)"));
503 
504     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
505 }
506 
507 /// @title Interface for all exchange handler contracts
508 contract ExchangeHandler is TotleControl, Withdrawable, Pausable {
509 
510     /*
511     *   State Variables
512     */
513 
514     SelectorProvider public selectorProvider;
515     ErrorReporter public errorReporter;
516     /* Logger public logger; */
517     /*
518     *   Modifiers
519     */
520 
521     modifier onlySelf() {
522         require(msg.sender == address(this));
523         _;
524     }
525 
526     /// @notice Constructor
527     /// @dev Calls the constructor of the inherited TotleControl
528     /// @param _selectorProvider the provider for this exchanges function selectors
529     /// @param totlePrimary the address of the totlePrimary contract
530     constructor(
531         address _selectorProvider,
532         address totlePrimary,
533         address _errorReporter
534         /* ,address _logger */
535     )
536         TotleControl(totlePrimary)
537         public
538     {
539         require(_selectorProvider != address(0x0));
540         require(_errorReporter != address(0x0));
541         /* require(_logger != address(0x0)); */
542         selectorProvider = SelectorProvider(_selectorProvider);
543         errorReporter = ErrorReporter(_errorReporter);
544         /* logger = Logger(_logger); */
545     }
546 
547     /// @notice Gets the amount that Totle needs to give for this order
548     /// @param genericPayload the data for this order in a generic format
549     /// @return amountToGive amount taker needs to give in order to fill the order
550     function getAmountToGive(
551         bytes genericPayload
552     )
553         public
554         view
555         onlyTotle
556         whenNotPaused
557         returns (uint256 amountToGive)
558     {
559         bool success;
560         bytes4 functionSelector = selectorProvider.getSelector(this.getAmountToGive.selector);
561 
562         assembly {
563             let functionSelectorLength := 0x04
564             let functionSelectorOffset := 0x1C
565             let scratchSpace := 0x0
566             let wordLength := 0x20
567             let bytesLength := mload(genericPayload)
568             let totalLength := add(functionSelectorLength, bytesLength)
569             let startOfNewData := add(genericPayload, functionSelectorOffset)
570 
571             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
572             let functionSelectorCorrect := mload(scratchSpace)
573             mstore(genericPayload, functionSelectorCorrect)
574 
575             success := call(
576                             gas,
577                             address, // This address of the current contract
578                             callvalue,
579                             startOfNewData, // Start data at the beginning of the functionSelector
580                             totalLength, // Total length of all data, including functionSelector
581                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
582                             wordLength // Length of return variable is one word
583                            )
584             amountToGive := mload(scratchSpace)
585             if eq(success, 0) { revert(0, 0) }
586         }
587     }
588 
589     /// @notice Perform exchange-specific checks on the given order
590     /// @dev this should be called to check for payload errors
591     /// @param genericPayload the data for this order in a generic format
592     /// @return checksPassed value representing pass or fail
593     function staticExchangeChecks(
594         bytes genericPayload
595     )
596         public
597         view
598         onlyTotle
599         whenNotPaused
600         returns (bool checksPassed)
601     {
602         bool success;
603         bytes4 functionSelector = selectorProvider.getSelector(this.staticExchangeChecks.selector);
604         assembly {
605             let functionSelectorLength := 0x04
606             let functionSelectorOffset := 0x1C
607             let scratchSpace := 0x0
608             let wordLength := 0x20
609             let bytesLength := mload(genericPayload)
610             let totalLength := add(functionSelectorLength, bytesLength)
611             let startOfNewData := add(genericPayload, functionSelectorOffset)
612 
613             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
614             let functionSelectorCorrect := mload(scratchSpace)
615             mstore(genericPayload, functionSelectorCorrect)
616 
617             success := call(
618                             gas,
619                             address, // This address of the current contract
620                             callvalue,
621                             startOfNewData, // Start data at the beginning of the functionSelector
622                             totalLength, // Total length of all data, including functionSelector
623                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
624                             wordLength // Length of return variable is one word
625                            )
626             checksPassed := mload(scratchSpace)
627             if eq(success, 0) { revert(0, 0) }
628         }
629     }
630 
631     /// @notice Perform a buy order at the exchange
632     /// @param genericPayload the data for this order in a generic format
633     /// @param  amountToGiveForOrder amount that should be spent on this order
634     /// @return amountSpentOnOrder the amount that would be spent on the order
635     /// @return amountReceivedFromOrder the amount that was received from this order
636     function performBuyOrder(
637         bytes genericPayload,
638         uint256 amountToGiveForOrder
639     )
640         public
641         payable
642         onlyTotle
643         whenNotPaused
644         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
645     {
646         bool success;
647         bytes4 functionSelector = selectorProvider.getSelector(this.performBuyOrder.selector);
648         assembly {
649             let callDataOffset := 0x44
650             let functionSelectorOffset := 0x1C
651             let functionSelectorLength := 0x04
652             let scratchSpace := 0x0
653             let wordLength := 0x20
654             let startOfFreeMemory := mload(0x40)
655 
656             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
657 
658             let bytesLength := mload(startOfFreeMemory)
659             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
660 
661             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
662 
663             let functionSelectorCorrect := mload(scratchSpace)
664 
665             mstore(startOfFreeMemory, functionSelectorCorrect)
666 
667             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
668 
669             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
670 
671             success := call(
672                             gas,
673                             address, // This address of the current contract
674                             callvalue,
675                             startOfNewData, // Start data at the beginning of the functionSelector
676                             totalLength, // Total length of all data, including functionSelector
677                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
678                             mul(wordLength, 0x02) // Length of return variables is two words
679                           )
680             amountSpentOnOrder := mload(scratchSpace)
681             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
682             if eq(success, 0) { revert(0, 0) }
683         }
684     }
685 
686     /// @notice Perform a sell order at the exchange
687     /// @param genericPayload the data for this order in a generic format
688     /// @param  amountToGiveForOrder amount that should be spent on this order
689     /// @return amountSpentOnOrder the amount that would be spent on the order
690     /// @return amountReceivedFromOrder the amount that was received from this order
691     function performSellOrder(
692         bytes genericPayload,
693         uint256 amountToGiveForOrder
694     )
695         public
696         onlyTotle
697         whenNotPaused
698         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
699     {
700         bool success;
701         bytes4 functionSelector = selectorProvider.getSelector(this.performSellOrder.selector);
702         assembly {
703             let callDataOffset := 0x44
704             let functionSelectorOffset := 0x1C
705             let functionSelectorLength := 0x04
706             let scratchSpace := 0x0
707             let wordLength := 0x20
708             let startOfFreeMemory := mload(0x40)
709 
710             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
711 
712             let bytesLength := mload(startOfFreeMemory)
713             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
714 
715             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
716 
717             let functionSelectorCorrect := mload(scratchSpace)
718 
719             mstore(startOfFreeMemory, functionSelectorCorrect)
720 
721             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
722 
723             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
724 
725             success := call(
726                             gas,
727                             address, // This address of the current contract
728                             callvalue,
729                             startOfNewData, // Start data at the beginning of the functionSelector
730                             totalLength, // Total length of all data, including functionSelector
731                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
732                             mul(wordLength, 0x02) // Length of return variables is two words
733                           )
734             amountSpentOnOrder := mload(scratchSpace)
735             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
736             if eq(success, 0) { revert(0, 0) }
737         }
738     }
739 }
740 
741 /// @title AirSwap
742 /// @notice Exchange contract interface
743 interface AirSwap {
744     /// @dev Mapping of order hash to bool (true = already filled).
745     function fills(bytes32 hash) external view returns (bool);
746 
747     /// @notice Fills an order by transferring tokens between (maker or escrow) and taker
748     function fill(
749         address makerAddress,
750         uint makerAmount,
751         address makerToken,
752         address takerAddress,
753         uint takerAmount,
754         address takerToken,
755         uint256 expiration,
756         uint256 nonce,
757         uint8 v,
758         bytes32 r,
759         bytes32 s
760     ) external payable;
761 }
762 
763 /// @title AirSwapSelectorProvider
764 /// @notice Provides this exchange implementation with correctly formatted function selectors
765 contract AirSwapSelectorProvider is SelectorProvider {
766     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
767         if (genericSelector == getAmountToGive) {
768             return bytes4(keccak256("getAmountToGive((address,address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32))"));
769         } else if (genericSelector == staticExchangeChecks) {
770             return bytes4(keccak256("staticExchangeChecks((address,address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32))"));
771         } else if (genericSelector == performBuyOrder) {
772             return bytes4(keccak256("performBuyOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32),uint256)"));
773         } else if (genericSelector == performSellOrder) {
774             return bytes4(keccak256("performSellOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32),uint256)"));
775         } else {
776             return bytes4(0x0);
777         }
778     }
779 }
780 
781 /// @title AirSwapHandler
782 /// @notice Handles the all AirSwap trades for the primary contract
783 contract AirSwapHandler is ExchangeHandler, AllowanceSetter {
784 
785     /*
786     *   State Variables
787     */
788 
789     AirSwap public exchange;
790     WETH public weth;
791 
792     /*
793     *   Types
794     */
795 
796     struct OrderData {
797         address makerAddress;
798         address makerToken;
799         address takerAddress;
800         address takerToken;
801         uint256 makerAmount;
802         uint256 takerAmount;
803         uint256 expiration;
804         uint256 nonce;
805         uint8 v;
806         bytes32 r;
807         bytes32 s;
808     }
809 
810     /// @notice Constructor
811     /// @dev Calls the constructor of the inherited ExchangeHandler
812     /// @param _exchange Address of the AirSwap exchange
813     /// @param _weth Address of the weth contract we are using
814     /// @param selectorProvider the provider for this exchanges function selectors
815     /// @param totlePrimary the address of the totlePrimary contract
816     /// @param errorReporter the address of the error reporter contract
817     constructor(
818         address _exchange,
819         address _weth,
820         address selectorProvider,
821         address totlePrimary,
822         address errorReporter
823         /* ,address logger */
824     )
825         ExchangeHandler(selectorProvider, totlePrimary, errorReporter/*, logger*/)
826         public
827     {
828         require(_exchange != address(0x0));
829         require(_weth != address(0x0));
830         exchange = AirSwap(_exchange);
831         weth = WETH(_weth);
832     }
833 
834     /*
835     *   Public functions
836     */
837 
838     /// @notice Gets the amount that Totle needs to give for this order
839     /// @dev Uses the `onlySelf` modifier with public visibility as this function
840     /// should only be called from functions which are inherited from the ExchangeHandler
841     /// base contract.
842     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
843     /// @param data OrderData struct containing order values
844     /// @return amountToGive amount taker needs to give in order to fill the order
845     function getAmountToGive(
846         OrderData data
847     )
848         public
849         view
850         whenNotPaused
851         onlySelf
852         returns (uint256 amountToGive)
853     {
854         return data.takerAmount;
855     }
856 
857     /// @notice Perform exchange-specific checks on the given order
858     /// @dev This function should be called to check for payload errors.
859     /// Uses the `onlySelf` modifier with public visibility as this function
860     /// should only be called from functions which are inherited from the ExchangeHandler
861     /// base contract.
862     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
863     /// @param data OrderData struct containing order values
864     /// @return checksPassed value representing pass or fail
865     function staticExchangeChecks(
866         OrderData data
867     )
868         public
869         view
870         whenNotPaused
871         onlySelf
872         returns (bool checksPassed)
873     {
874         bytes32 orderHash;
875         bytes32 prefixedHash;
876 
877         (orderHash, prefixedHash) = getOrderHash(data);
878 
879         return (
880             data.takerAddress != data.makerAddress &&
881             data.expiration >= block.timestamp &&
882             ecrecover(prefixedHash, data.v, data.r, data.s) == data.makerAddress &&
883             !exchange.fills(orderHash) &&
884             data.takerAddress == address(this) &&
885             Utils.tokenAllowanceAndBalanceSet(data.makerAddress, data.makerToken, data.makerAmount, address(exchange))
886         );
887     }
888 
889     /// @notice Perform a buy order at the exchange
890     /// @dev Uses the `onlySelf` modifier with public visibility as this function
891     /// should only be called from functions which are inherited from the ExchangeHandler
892     /// base contract.
893     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
894     /// @param data OrderData struct containing order values
895     /// @param amountToGiveForOrder amount that should be spent on this order
896     /// @return amountSpentOnOrder the amount that would be spent on the order
897     /// @return amountReceivedFromOrder the amount that was received from this order
898     function performBuyOrder(
899         OrderData data,
900         uint256 amountToGiveForOrder
901     )
902         public
903         payable
904         whenNotPaused
905         onlySelf
906         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
907     {
908         /* logger.log("Performing AirSwap buy arg2: amountToGiveForOrder", amountToGiveForOrder); */
909         if (data.takerAmount != amountToGiveForOrder || msg.value != data.takerAmount) {
910             /* logger.log(
911                 "Taker amount is not equal to the amountToGiveForOrder or ether sent is not equal to the taker amount arg2: takerAmount, arg3: amountToGiveForOrder, arg4: msg.value",
912                 data.takerAmount,
913                 amountToGiveForOrder,
914                 msg.value
915             ); */
916             totlePrimary.transfer(msg.value);
917             return (0,0);
918         }
919 
920         fillAndValidate(data);
921 
922         /* logger.log("Filled and validated"); */
923 
924         if (!ERC20SafeTransfer.safeTransfer(data.makerToken, totlePrimary, data.makerAmount)) {
925             errorReporter.revertTx("AirSwap: Unable to transfer bought tokens to primary");
926         }
927 
928         return (data.takerAmount, data.makerAmount);
929     }
930 
931     /// @notice Perform a sell order at the exchange
932     /// @dev Uses the `onlySelf` modifier with public visibility as this function
933     /// should only be called from functions which are inherited from the ExchangeHandler
934     /// base contract
935     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
936     /// @param data OrderData struct containing order values
937     /// @param amountToGiveForOrder amount that should be spent on this order
938     /// @return amountSpentOnOrder the amount that would be spent on the order
939     /// @return amountReceivedFromOrder the amount that was received from this order
940     function performSellOrder(
941         OrderData data,
942         uint256 amountToGiveForOrder
943     )
944         public
945         whenNotPaused
946         onlySelf
947         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
948     {
949         /* logger.log("Performing AirSwap sell arg2: amountToGiveForOrder", amountToGiveForOrder); */
950         /// @dev Primary will have transfered the tokens to us, revert if amount incorrect
951         if (data.takerAmount != amountToGiveForOrder) {
952             errorReporter.revertTx("AirSwap: takerAmount != amountToGiveForOrder");
953         }
954 
955         if (data.makerToken != address(weth)) {
956             /* logger.log("Maker token is not WETH", amountToGiveForOrder); */
957             return (0,0);
958         }
959 
960         approveAddress(address(exchange), data.takerToken);
961 
962         /* logger.log("Address approved arg6: exchange, arg7: takerToken", 0,0,0,0, exchange, data.takerToken); */
963 
964         fillAndValidate(data);
965 
966         /* logger.log("Filled and validated"); */
967 
968         weth.withdraw(data.makerAmount);
969 
970         /* logger.log("WETH withdrawal arg2: makerAmount", data.makerAmount); */
971 
972         totlePrimary.transfer(data.makerAmount);
973 
974         /* logger.log("Transfered WETH to Primary"); */
975 
976         return (data.takerAmount, data.makerAmount);
977     }
978 
979     /*
980     *   Internal functions
981     */
982 
983     /// @notice Get both hash(data) and hash(prefix,hash(data))
984     /// @param data OrderData struct containing order values
985     /// @return orderHash the result of hashing the concatenated order data
986     /// @return prefixedHash the result of orderHash prefixed by a message
987     function getOrderHash(
988         OrderData data
989     )
990         internal
991         pure
992         returns (bytes32 orderHash, bytes32 prefixedHash)
993     {
994         orderHash = keccak256(
995             data.makerAddress,
996             data.makerAmount,
997             data.makerToken,
998             data.takerAddress,
999             data.takerAmount,
1000             data.takerToken,
1001             data.expiration,
1002             data.nonce
1003         );
1004 
1005         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1006         prefixedHash = keccak256(prefix, orderHash);
1007     }
1008 
1009     /// @notice Calls the fill function at airSwap, then validates the order was filled
1010     /// @dev If the order was not valid, this function will revert the transaction
1011     /// @param data OrderData struct containing order values
1012     function fillAndValidate(OrderData data) internal {
1013 
1014         exchange.fill.value(msg.value)(
1015             data.makerAddress,
1016             data.makerAmount,
1017             data.makerToken,
1018             data.takerAddress,
1019             data.takerAmount,
1020             data.takerToken,
1021             data.expiration,
1022             data.nonce,
1023             data.v,
1024             data.r,
1025             data.s
1026         );
1027 
1028         bytes32 orderHash;
1029         (orderHash, ) = getOrderHash(data);
1030 
1031         if (!exchange.fills(orderHash)) {
1032             errorReporter.revertTx("AirSwap: Order failed validation after execution");
1033         }
1034     }
1035 
1036     /*
1037     *   Payable fallback function
1038     */
1039 
1040     /// @notice payable fallback to allow handler or exchange contracts to return ether
1041     /// @dev only accounts containing code (ie. contracts) can send ether to this contract
1042     function() public payable whenNotPaused {
1043         // Check in here that the sender is a contract! (to stop accidents)
1044         uint256 size;
1045         address sender = msg.sender;
1046         assembly {
1047             size := extcodesize(sender)
1048         }
1049         if (size == 0) {
1050             errorReporter.revertTx("EOA cannot send ether to primary fallback");
1051         }
1052     }
1053 
1054 }