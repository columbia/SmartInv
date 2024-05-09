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
243                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
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
401     mapping(address => bool) public authorizedPrimaries;
402 
403     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
404     modifier onlyTotle() {
405         require(authorizedPrimaries[msg.sender]);
406         _;
407     }
408 
409     /// @notice Contract constructor
410     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
411     /// @param _totlePrimary the address of the contract to be set as totlePrimary
412     constructor(address _totlePrimary) public {
413         authorizedPrimaries[_totlePrimary] = true;
414     }
415 
416     /// @notice A function which allows only the owner to change the address of totlePrimary
417     /// @dev onlyOwner modifier only allows the contract owner to run the code
418     /// @param _totlePrimary the address of the contract to be set as totlePrimary
419     function addTotle(
420         address _totlePrimary
421     ) external onlyOwner {
422         authorizedPrimaries[_totlePrimary] = true;
423     }
424 
425     function removeTotle(
426         address _totlePrimary
427     ) external onlyOwner {
428         authorizedPrimaries[_totlePrimary] = false;
429     }
430 }
431 
432 /// @title A contract which allows its owner to withdraw any ether which is contained inside
433 contract Withdrawable is Ownable {
434 
435     /// @notice Withdraw ether contained in this contract and send it back to owner
436     /// @dev onlyOwner modifier only allows the contract owner to run the code
437     /// @param _token The address of the token that the user wants to withdraw
438     /// @param _amount The amount of tokens that the caller wants to withdraw
439     /// @return bool value indicating whether the transfer was successful
440     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
441         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
442     }
443 
444     /// @notice Withdraw ether contained in this contract and send it back to owner
445     /// @dev onlyOwner modifier only allows the contract owner to run the code
446     /// @param _amount The amount of ether that the caller wants to withdraw
447     function withdrawETH(uint256 _amount) external onlyOwner {
448         owner.transfer(_amount);
449     }
450 }
451 
452 /**
453  * @title Pausable
454  * @dev Base contract which allows children to implement an emergency stop mechanism.
455  */
456 contract Pausable is Ownable {
457   event Paused();
458   event Unpaused();
459 
460   bool private _paused = false;
461 
462   /**
463    * @return true if the contract is paused, false otherwise.
464    */
465   function paused() public view returns (bool) {
466     return _paused;
467   }
468 
469   /**
470    * @dev Modifier to make a function callable only when the contract is not paused.
471    */
472   modifier whenNotPaused() {
473     require(!_paused, "Contract is paused.");
474     _;
475   }
476 
477   /**
478    * @dev Modifier to make a function callable only when the contract is paused.
479    */
480   modifier whenPaused() {
481     require(_paused, "Contract not paused.");
482     _;
483   }
484 
485   /**
486    * @dev called by the owner to pause, triggers stopped state
487    */
488   function pause() public onlyOwner whenNotPaused {
489     _paused = true;
490     emit Paused();
491   }
492 
493   /**
494    * @dev called by the owner to unpause, returns to normal state
495    */
496   function unpause() public onlyOwner whenPaused {
497     _paused = false;
498     emit Unpaused();
499   }
500 }
501 
502 contract SelectorProvider {
503     bytes4 constant getAmountToGiveSelector = bytes4(keccak256("getAmountToGive(bytes)"));
504     bytes4 constant staticExchangeChecksSelector = bytes4(keccak256("staticExchangeChecks(bytes)"));
505     bytes4 constant performBuyOrderSelector = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
506     bytes4 constant performSellOrderSelector = bytes4(keccak256("performSellOrder(bytes,uint256)"));
507 
508     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
509 }
510 
511 /// @title Interface for all exchange handler contracts
512 contract ExchangeHandler is SelectorProvider, TotleControl, Withdrawable, Pausable {
513 
514     /*
515     *   State Variables
516     */
517 
518     ErrorReporter public errorReporter;
519     /* Logger public logger; */
520     /*
521     *   Modifiers
522     */
523 
524     /// @notice Constructor
525     /// @dev Calls the constructor of the inherited TotleControl
526     /// @param totlePrimary the address of the totlePrimary contract
527     constructor(
528         address totlePrimary,
529         address _errorReporter
530         /* ,address _logger */
531     )
532         TotleControl(totlePrimary)
533         public
534     {
535         require(_errorReporter != address(0x0));
536         /* require(_logger != address(0x0)); */
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
549         returns (uint256 amountToGive)
550     {
551         bool success;
552         bytes4 functionSelector = getSelector(this.getAmountToGive.selector);
553 
554         assembly {
555             let functionSelectorLength := 0x04
556             let functionSelectorOffset := 0x1C
557             let scratchSpace := 0x0
558             let wordLength := 0x20
559             let bytesLength := mload(genericPayload)
560             let totalLength := add(functionSelectorLength, bytesLength)
561             let startOfNewData := add(genericPayload, functionSelectorOffset)
562 
563             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
564             let functionSelectorCorrect := mload(scratchSpace)
565             mstore(genericPayload, functionSelectorCorrect)
566 
567             success := delegatecall(
568                             gas,
569                             address, // This address of the current contract
570                             startOfNewData, // Start data at the beginning of the functionSelector
571                             totalLength, // Total length of all data, including functionSelector
572                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
573                             wordLength // Length of return variable is one word
574                            )
575             amountToGive := mload(scratchSpace)
576             if eq(success, 0) { revert(0, 0) }
577         }
578     }
579 
580     /// @notice Perform exchange-specific checks on the given order
581     /// @dev this should be called to check for payload errors
582     /// @param genericPayload the data for this order in a generic format
583     /// @return checksPassed value representing pass or fail
584     function staticExchangeChecks(
585         bytes genericPayload
586     )
587         public
588         view
589         returns (bool checksPassed)
590     {
591         bool success;
592         bytes4 functionSelector = getSelector(this.staticExchangeChecks.selector);
593         assembly {
594             let functionSelectorLength := 0x04
595             let functionSelectorOffset := 0x1C
596             let scratchSpace := 0x0
597             let wordLength := 0x20
598             let bytesLength := mload(genericPayload)
599             let totalLength := add(functionSelectorLength, bytesLength)
600             let startOfNewData := add(genericPayload, functionSelectorOffset)
601 
602             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
603             let functionSelectorCorrect := mload(scratchSpace)
604             mstore(genericPayload, functionSelectorCorrect)
605 
606             success := delegatecall(
607                             gas,
608                             address, // This address of the current contract
609                             startOfNewData, // Start data at the beginning of the functionSelector
610                             totalLength, // Total length of all data, including functionSelector
611                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
612                             wordLength // Length of return variable is one word
613                            )
614             checksPassed := mload(scratchSpace)
615             if eq(success, 0) { revert(0, 0) }
616         }
617     }
618 
619     /// @notice Perform a buy order at the exchange
620     /// @param genericPayload the data for this order in a generic format
621     /// @param  amountToGiveForOrder amount that should be spent on this order
622     /// @return amountSpentOnOrder the amount that would be spent on the order
623     /// @return amountReceivedFromOrder the amount that was received from this order
624     function performBuyOrder(
625         bytes genericPayload,
626         uint256 amountToGiveForOrder
627     )
628         public
629         payable
630         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
631     {
632         bool success;
633         bytes4 functionSelector = getSelector(this.performBuyOrder.selector);
634         assembly {
635             let callDataOffset := 0x44
636             let functionSelectorOffset := 0x1C
637             let functionSelectorLength := 0x04
638             let scratchSpace := 0x0
639             let wordLength := 0x20
640             let startOfFreeMemory := mload(0x40)
641 
642             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
643 
644             let bytesLength := mload(startOfFreeMemory)
645             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
646 
647             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
648 
649             let functionSelectorCorrect := mload(scratchSpace)
650 
651             mstore(startOfFreeMemory, functionSelectorCorrect)
652 
653             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
654 
655             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
656 
657             success := delegatecall(
658                             gas,
659                             address, // This address of the current contract
660                             startOfNewData, // Start data at the beginning of the functionSelector
661                             totalLength, // Total length of all data, including functionSelector
662                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
663                             mul(wordLength, 0x02) // Length of return variables is two words
664                           )
665             amountSpentOnOrder := mload(scratchSpace)
666             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
667             if eq(success, 0) { revert(0, 0) }
668         }
669     }
670 
671     /// @notice Perform a sell order at the exchange
672     /// @param genericPayload the data for this order in a generic format
673     /// @param  amountToGiveForOrder amount that should be spent on this order
674     /// @return amountSpentOnOrder the amount that would be spent on the order
675     /// @return amountReceivedFromOrder the amount that was received from this order
676     function performSellOrder(
677         bytes genericPayload,
678         uint256 amountToGiveForOrder
679     )
680         public
681         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
682     {
683         bool success;
684         bytes4 functionSelector = getSelector(this.performSellOrder.selector);
685         assembly {
686             let callDataOffset := 0x44
687             let functionSelectorOffset := 0x1C
688             let functionSelectorLength := 0x04
689             let scratchSpace := 0x0
690             let wordLength := 0x20
691             let startOfFreeMemory := mload(0x40)
692 
693             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
694 
695             let bytesLength := mload(startOfFreeMemory)
696             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
697 
698             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
699 
700             let functionSelectorCorrect := mload(scratchSpace)
701 
702             mstore(startOfFreeMemory, functionSelectorCorrect)
703 
704             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
705 
706             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
707 
708             success := delegatecall(
709                             gas,
710                             address, // This address of the current contract
711                             startOfNewData, // Start data at the beginning of the functionSelector
712                             totalLength, // Total length of all data, including functionSelector
713                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
714                             mul(wordLength, 0x02) // Length of return variables is two words
715                           )
716             amountSpentOnOrder := mload(scratchSpace)
717             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
718             if eq(success, 0) { revert(0, 0) }
719         }
720     }
721 }
722 
723 /// @title AirSwap
724 /// @notice Exchange contract interface
725 interface AirSwap {
726     /// @dev Mapping of order hash to bool (true = already filled).
727     function fills(bytes32 hash) external view returns (bool);
728 
729     /// @notice Fills an order by transferring tokens between (maker or escrow) and taker
730     function fill(
731         address makerAddress,
732         uint makerAmount,
733         address makerToken,
734         address takerAddress,
735         uint takerAmount,
736         address takerToken,
737         uint256 expiration,
738         uint256 nonce,
739         uint8 v,
740         bytes32 r,
741         bytes32 s
742     ) external payable;
743 }
744 
745 /// @title AirSwapHandler
746 /// @notice Handles the all AirSwap trades for the primary contract
747 contract AirSwapHandler is ExchangeHandler, AllowanceSetter {
748 
749     /*
750     *   State Variables
751     */
752 
753     AirSwap public exchange;
754     WETH public weth;
755 
756     /*
757     *   Types
758     */
759 
760     struct OrderData {
761         address makerAddress;
762         address makerToken;
763         address takerAddress;
764         address takerToken;
765         uint256 makerAmount;
766         uint256 takerAmount;
767         uint256 expiration;
768         uint256 nonce;
769         uint8 v;
770         bytes32 r;
771         bytes32 s;
772     }
773 
774     /// @notice Constructor
775     /// @dev Calls the constructor of the inherited ExchangeHandler
776     /// @param _exchange Address of the AirSwap exchange
777     /// @param _weth Address of the weth contract we are using
778     /// @param totlePrimary the address of the totlePrimary contract
779     /// @param errorReporter the address of the error reporter contract
780     constructor(
781         address _exchange,
782         address _weth,
783         address totlePrimary,
784         address errorReporter
785         /* ,address logger */
786     )
787         ExchangeHandler(totlePrimary, errorReporter/*, logger*/)
788         public
789     {
790         require(_exchange != address(0x0));
791         require(_weth != address(0x0));
792         exchange = AirSwap(_exchange);
793         weth = WETH(_weth);
794     }
795 
796     /*
797     *   Public functions
798     */
799 
800     /// @notice Gets the amount that Totle needs to give for this order
801     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
802     /// should only be called from functions which are inherited from the ExchangeHandler
803     /// base contract.
804     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
805     /// @param data OrderData struct containing order values
806     /// @return amountToGive amount taker needs to give in order to fill the order
807     function getAmountToGive(
808         OrderData data
809     )
810         public
811         view
812         whenNotPaused
813         onlyTotle
814         returns (uint256 amountToGive)
815     {
816         return data.takerAmount;
817     }
818 
819     /// @notice Perform exchange-specific checks on the given order
820     /// @dev This function should be called to check for payload errors.
821     /// Uses the `onlyTotle` modifier with public visibility as this function
822     /// should only be called from functions which are inherited from the ExchangeHandler
823     /// base contract.
824     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
825     /// @param data OrderData struct containing order values
826     /// @return checksPassed value representing pass or fail
827     function staticExchangeChecks(
828         OrderData data
829     )
830         public
831         view
832         whenNotPaused
833         onlyTotle
834         returns (bool checksPassed)
835     {
836         bytes32 orderHash;
837         bytes32 prefixedHash;
838 
839         (orderHash, prefixedHash) = getOrderHash(data);
840 
841         return (
842             data.takerAddress != data.makerAddress &&
843             data.expiration >= block.timestamp &&
844             ecrecover(prefixedHash, data.v, data.r, data.s) == data.makerAddress &&
845             !exchange.fills(orderHash) &&
846             data.takerAddress == address(this) &&
847             Utils.tokenAllowanceAndBalanceSet(data.makerAddress, data.makerToken, data.makerAmount, address(exchange))
848         );
849     }
850 
851     /// @notice Perform a buy order at the exchange
852     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
853     /// should only be called from functions which are inherited from the ExchangeHandler
854     /// base contract.
855     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
856     /// @param data OrderData struct containing order values
857     /// @param amountToGiveForOrder amount that should be spent on this order
858     /// @return amountSpentOnOrder the amount that would be spent on the order
859     /// @return amountReceivedFromOrder the amount that was received from this order
860     function performBuyOrder(
861         OrderData data,
862         uint256 amountToGiveForOrder
863     )
864         public
865         payable
866         whenNotPaused
867         onlyTotle
868         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
869     {
870         /* logger.log("Performing AirSwap buy arg2: amountToGiveForOrder", amountToGiveForOrder); */
871         if (data.takerAmount != amountToGiveForOrder || msg.value != data.takerAmount) {
872             /* logger.log(
873                 "Taker amount is not equal to the amountToGiveForOrder or ether sent is not equal to the taker amount arg2: takerAmount, arg3: amountToGiveForOrder, arg4: msg.value",
874                 data.takerAmount,
875                 amountToGiveForOrder,
876                 msg.value
877             ); */
878             msg.sender.transfer(msg.value);
879             return (0,0);
880         }
881 
882         fillAndValidate(data);
883 
884         /* logger.log("Filled and validated"); */
885 
886         if (!ERC20SafeTransfer.safeTransfer(data.makerToken, msg.sender, data.makerAmount)) {
887             errorReporter.revertTx("AirSwap: Unable to transfer bought tokens to primary");
888         }
889 
890         return (data.takerAmount, data.makerAmount);
891     }
892 
893     /// @notice Perform a sell order at the exchange
894     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
895     /// should only be called from functions which are inherited from the ExchangeHandler
896     /// base contract
897     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
898     /// @param data OrderData struct containing order values
899     /// @param amountToGiveForOrder amount that should be spent on this order
900     /// @return amountSpentOnOrder the amount that would be spent on the order
901     /// @return amountReceivedFromOrder the amount that was received from this order
902     function performSellOrder(
903         OrderData data,
904         uint256 amountToGiveForOrder
905     )
906         public
907         whenNotPaused
908         onlyTotle
909         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
910     {
911         /* logger.log("Performing AirSwap sell arg2: amountToGiveForOrder", amountToGiveForOrder); */
912         /// @dev Primary will have transfered the tokens to us, revert if amount incorrect
913         if (data.takerAmount != amountToGiveForOrder) {
914             errorReporter.revertTx("AirSwap: takerAmount != amountToGiveForOrder");
915         }
916 
917         if (data.makerToken != address(weth)) {
918             /* logger.log("Maker token is not WETH", amountToGiveForOrder); */
919             return (0,0);
920         }
921 
922         approveAddress(address(exchange), data.takerToken);
923 
924         /* logger.log("Address approved arg6: exchange, arg7: takerToken", 0,0,0,0, exchange, data.takerToken); */
925 
926         fillAndValidate(data);
927 
928         /* logger.log("Filled and validated"); */
929 
930         weth.withdraw(data.makerAmount);
931 
932         /* logger.log("WETH withdrawal arg2: makerAmount", data.makerAmount); */
933 
934         msg.sender.transfer(data.makerAmount);
935 
936         /* logger.log("Transfered WETH to Primary"); */
937 
938         return (data.takerAmount, data.makerAmount);
939     }
940 
941     /*
942     *   Internal functions
943     */
944 
945     /// @notice Get both hash(data) and hash(prefix,hash(data))
946     /// @param data OrderData struct containing order values
947     /// @return orderHash the result of hashing the concatenated order data
948     /// @return prefixedHash the result of orderHash prefixed by a message
949     function getOrderHash(
950         OrderData data
951     )
952         internal
953         pure
954         returns (bytes32 orderHash, bytes32 prefixedHash)
955     {
956         orderHash = keccak256(
957             data.makerAddress,
958             data.makerAmount,
959             data.makerToken,
960             data.takerAddress,
961             data.takerAmount,
962             data.takerToken,
963             data.expiration,
964             data.nonce
965         );
966 
967         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
968         prefixedHash = keccak256(prefix, orderHash);
969     }
970 
971     /// @notice Calls the fill function at airSwap, then validates the order was filled
972     /// @dev If the order was not valid, this function will revert the transaction
973     /// @param data OrderData struct containing order values
974     function fillAndValidate(OrderData data) internal {
975 
976         exchange.fill.value(msg.value)(
977             data.makerAddress,
978             data.makerAmount,
979             data.makerToken,
980             data.takerAddress,
981             data.takerAmount,
982             data.takerToken,
983             data.expiration,
984             data.nonce,
985             data.v,
986             data.r,
987             data.s
988         );
989 
990         bytes32 orderHash;
991         (orderHash, ) = getOrderHash(data);
992 
993         if (!exchange.fills(orderHash)) {
994             errorReporter.revertTx("AirSwap: Order failed validation after execution");
995         }
996     }
997 
998     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
999         if (genericSelector == getAmountToGiveSelector) {
1000             return bytes4(keccak256("getAmountToGive((address,address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32))"));
1001         } else if (genericSelector == staticExchangeChecksSelector) {
1002             return bytes4(keccak256("staticExchangeChecks((address,address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32))"));
1003         } else if (genericSelector == performBuyOrderSelector) {
1004             return bytes4(keccak256("performBuyOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32),uint256)"));
1005         } else if (genericSelector == performSellOrderSelector) {
1006             return bytes4(keccak256("performSellOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint8,bytes32,bytes32),uint256)"));
1007         } else {
1008             return bytes4(0x0);
1009         }
1010     }
1011 
1012     /*
1013     *   Payable fallback function
1014     */
1015 
1016     /// @notice payable fallback to allow handler or exchange contracts to return ether
1017     /// @dev only accounts containing code (ie. contracts) can send ether to this contract
1018     function() public payable whenNotPaused {
1019         // Check in here that the sender is a contract! (to stop accidents)
1020         uint256 size;
1021         address sender = msg.sender;
1022         assembly {
1023             size := extcodesize(sender)
1024         }
1025         if (size == 0) {
1026             errorReporter.revertTx("EOA cannot send ether to primary fallback");
1027         }
1028     }
1029 
1030 }