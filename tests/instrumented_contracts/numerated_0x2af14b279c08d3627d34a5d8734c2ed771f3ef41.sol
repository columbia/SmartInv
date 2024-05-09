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
158                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
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
375     mapping(address => bool) public authorizedPrimaries;
376 
377     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
378     modifier onlyTotle() {
379         require(authorizedPrimaries[msg.sender]);
380         _;
381     }
382 
383     /// @notice Contract constructor
384     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
385     /// @param _totlePrimary the address of the contract to be set as totlePrimary
386     constructor(address _totlePrimary) public {
387         authorizedPrimaries[_totlePrimary] = true;
388     }
389 
390     /// @notice A function which allows only the owner to change the address of totlePrimary
391     /// @dev onlyOwner modifier only allows the contract owner to run the code
392     /// @param _totlePrimary the address of the contract to be set as totlePrimary
393     function addTotle(
394         address _totlePrimary
395     ) external onlyOwner {
396         authorizedPrimaries[_totlePrimary] = true;
397     }
398 
399     function removeTotle(
400         address _totlePrimary
401     ) external onlyOwner {
402         authorizedPrimaries[_totlePrimary] = false;
403     }
404 }
405 
406 /// @title A contract which allows its owner to withdraw any ether which is contained inside
407 contract Withdrawable is Ownable {
408 
409     /// @notice Withdraw ether contained in this contract and send it back to owner
410     /// @dev onlyOwner modifier only allows the contract owner to run the code
411     /// @param _token The address of the token that the user wants to withdraw
412     /// @param _amount The amount of tokens that the caller wants to withdraw
413     /// @return bool value indicating whether the transfer was successful
414     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
415         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
416     }
417 
418     /// @notice Withdraw ether contained in this contract and send it back to owner
419     /// @dev onlyOwner modifier only allows the contract owner to run the code
420     /// @param _amount The amount of ether that the caller wants to withdraw
421     function withdrawETH(uint256 _amount) external onlyOwner {
422         owner.transfer(_amount);
423     }
424 }
425 
426 /**
427  * @title Pausable
428  * @dev Base contract which allows children to implement an emergency stop mechanism.
429  */
430 contract Pausable is Ownable {
431   event Paused();
432   event Unpaused();
433 
434   bool private _paused = false;
435 
436   /**
437    * @return true if the contract is paused, false otherwise.
438    */
439   function paused() public view returns (bool) {
440     return _paused;
441   }
442 
443   /**
444    * @dev Modifier to make a function callable only when the contract is not paused.
445    */
446   modifier whenNotPaused() {
447     require(!_paused, "Contract is paused.");
448     _;
449   }
450 
451   /**
452    * @dev Modifier to make a function callable only when the contract is paused.
453    */
454   modifier whenPaused() {
455     require(_paused, "Contract not paused.");
456     _;
457   }
458 
459   /**
460    * @dev called by the owner to pause, triggers stopped state
461    */
462   function pause() public onlyOwner whenNotPaused {
463     _paused = true;
464     emit Paused();
465   }
466 
467   /**
468    * @dev called by the owner to unpause, returns to normal state
469    */
470   function unpause() public onlyOwner whenPaused {
471     _paused = false;
472     emit Unpaused();
473   }
474 }
475 
476 contract SelectorProvider {
477     bytes4 constant getAmountToGiveSelector = bytes4(keccak256("getAmountToGive(bytes)"));
478     bytes4 constant staticExchangeChecksSelector = bytes4(keccak256("staticExchangeChecks(bytes)"));
479     bytes4 constant performBuyOrderSelector = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
480     bytes4 constant performSellOrderSelector = bytes4(keccak256("performSellOrder(bytes,uint256)"));
481 
482     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
483 }
484 
485 /// @title Interface for all exchange handler contracts
486 contract ExchangeHandler is SelectorProvider, TotleControl, Withdrawable, Pausable {
487 
488     /*
489     *   State Variables
490     */
491 
492     ErrorReporter public errorReporter;
493     /* Logger public logger; */
494     /*
495     *   Modifiers
496     */
497 
498     /// @notice Constructor
499     /// @dev Calls the constructor of the inherited TotleControl
500     /// @param totlePrimary the address of the totlePrimary contract
501     constructor(
502         address totlePrimary,
503         address _errorReporter
504         /* ,address _logger */
505     )
506         TotleControl(totlePrimary)
507         public
508     {
509         require(_errorReporter != address(0x0));
510         /* require(_logger != address(0x0)); */
511         errorReporter = ErrorReporter(_errorReporter);
512         /* logger = Logger(_logger); */
513     }
514 
515     /// @notice Gets the amount that Totle needs to give for this order
516     /// @param genericPayload the data for this order in a generic format
517     /// @return amountToGive amount taker needs to give in order to fill the order
518     function getAmountToGive(
519         bytes genericPayload
520     )
521         public
522         view
523         returns (uint256 amountToGive)
524     {
525         bool success;
526         bytes4 functionSelector = getSelector(this.getAmountToGive.selector);
527 
528         assembly {
529             let functionSelectorLength := 0x04
530             let functionSelectorOffset := 0x1C
531             let scratchSpace := 0x0
532             let wordLength := 0x20
533             let bytesLength := mload(genericPayload)
534             let totalLength := add(functionSelectorLength, bytesLength)
535             let startOfNewData := add(genericPayload, functionSelectorOffset)
536 
537             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
538             let functionSelectorCorrect := mload(scratchSpace)
539             mstore(genericPayload, functionSelectorCorrect)
540 
541             success := delegatecall(
542                             gas,
543                             address, // This address of the current contract
544                             startOfNewData, // Start data at the beginning of the functionSelector
545                             totalLength, // Total length of all data, including functionSelector
546                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
547                             wordLength // Length of return variable is one word
548                            )
549             amountToGive := mload(scratchSpace)
550             if eq(success, 0) { revert(0, 0) }
551         }
552     }
553 
554     /// @notice Perform exchange-specific checks on the given order
555     /// @dev this should be called to check for payload errors
556     /// @param genericPayload the data for this order in a generic format
557     /// @return checksPassed value representing pass or fail
558     function staticExchangeChecks(
559         bytes genericPayload
560     )
561         public
562         view
563         returns (bool checksPassed)
564     {
565         bool success;
566         bytes4 functionSelector = getSelector(this.staticExchangeChecks.selector);
567         assembly {
568             let functionSelectorLength := 0x04
569             let functionSelectorOffset := 0x1C
570             let scratchSpace := 0x0
571             let wordLength := 0x20
572             let bytesLength := mload(genericPayload)
573             let totalLength := add(functionSelectorLength, bytesLength)
574             let startOfNewData := add(genericPayload, functionSelectorOffset)
575 
576             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
577             let functionSelectorCorrect := mload(scratchSpace)
578             mstore(genericPayload, functionSelectorCorrect)
579 
580             success := delegatecall(
581                             gas,
582                             address, // This address of the current contract
583                             startOfNewData, // Start data at the beginning of the functionSelector
584                             totalLength, // Total length of all data, including functionSelector
585                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
586                             wordLength // Length of return variable is one word
587                            )
588             checksPassed := mload(scratchSpace)
589             if eq(success, 0) { revert(0, 0) }
590         }
591     }
592 
593     /// @notice Perform a buy order at the exchange
594     /// @param genericPayload the data for this order in a generic format
595     /// @param  amountToGiveForOrder amount that should be spent on this order
596     /// @return amountSpentOnOrder the amount that would be spent on the order
597     /// @return amountReceivedFromOrder the amount that was received from this order
598     function performBuyOrder(
599         bytes genericPayload,
600         uint256 amountToGiveForOrder
601     )
602         public
603         payable
604         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
605     {
606         bool success;
607         bytes4 functionSelector = getSelector(this.performBuyOrder.selector);
608         assembly {
609             let callDataOffset := 0x44
610             let functionSelectorOffset := 0x1C
611             let functionSelectorLength := 0x04
612             let scratchSpace := 0x0
613             let wordLength := 0x20
614             let startOfFreeMemory := mload(0x40)
615 
616             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
617 
618             let bytesLength := mload(startOfFreeMemory)
619             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
620 
621             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
622 
623             let functionSelectorCorrect := mload(scratchSpace)
624 
625             mstore(startOfFreeMemory, functionSelectorCorrect)
626 
627             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
628 
629             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
630 
631             success := delegatecall(
632                             gas,
633                             address, // This address of the current contract
634                             startOfNewData, // Start data at the beginning of the functionSelector
635                             totalLength, // Total length of all data, including functionSelector
636                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
637                             mul(wordLength, 0x02) // Length of return variables is two words
638                           )
639             amountSpentOnOrder := mload(scratchSpace)
640             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
641             if eq(success, 0) { revert(0, 0) }
642         }
643     }
644 
645     /// @notice Perform a sell order at the exchange
646     /// @param genericPayload the data for this order in a generic format
647     /// @param  amountToGiveForOrder amount that should be spent on this order
648     /// @return amountSpentOnOrder the amount that would be spent on the order
649     /// @return amountReceivedFromOrder the amount that was received from this order
650     function performSellOrder(
651         bytes genericPayload,
652         uint256 amountToGiveForOrder
653     )
654         public
655         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
656     {
657         bool success;
658         bytes4 functionSelector = getSelector(this.performSellOrder.selector);
659         assembly {
660             let callDataOffset := 0x44
661             let functionSelectorOffset := 0x1C
662             let functionSelectorLength := 0x04
663             let scratchSpace := 0x0
664             let wordLength := 0x20
665             let startOfFreeMemory := mload(0x40)
666 
667             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
668 
669             let bytesLength := mload(startOfFreeMemory)
670             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
671 
672             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
673 
674             let functionSelectorCorrect := mload(scratchSpace)
675 
676             mstore(startOfFreeMemory, functionSelectorCorrect)
677 
678             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
679 
680             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
681 
682             success := delegatecall(
683                             gas,
684                             address, // This address of the current contract
685                             startOfNewData, // Start data at the beginning of the functionSelector
686                             totalLength, // Total length of all data, including functionSelector
687                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
688                             mul(wordLength, 0x02) // Length of return variables is two words
689                           )
690             amountSpentOnOrder := mload(scratchSpace)
691             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
692             if eq(success, 0) { revert(0, 0) }
693         }
694     }
695 }
696 
697 interface UniswapExchange {
698 
699    //Trading
700    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256);
701    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256);
702 
703    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256);
704    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256);
705 
706    // Get Price
707    function getEthToTokenInputPrice(uint256 eth_sold) external constant returns (uint256);
708    function getTokenToEthInputPrice(uint256 tokens_sold) external constant returns (uint256);
709 
710    function tokenAddress() external constant returns (address);
711 }
712 
713 /// @title Handler for Uniswap exchange
714 contract UniswapHandler is ExchangeHandler, AllowanceSetter {
715     /*
716     *   Types
717     */
718 
719     struct OrderData {
720         address exchangeAddress;
721         uint256 amountToGive;
722     }
723 
724     /// @notice Constructor
725     /// @param _totlePrimary the address of the totlePrimary contract
726     /// @param errorReporter the address of of the errorReporter contract
727     constructor(
728         address _totlePrimary,
729         address errorReporter/*,
730         address logger*/
731     ) ExchangeHandler(_totlePrimary, errorReporter/*, logger*/) public {
732 
733     }
734 
735     /*
736     *   Internal functions
737     */
738 
739     /// @notice Gets the amount that TotlePrimary needs to give for this order
740     /// @param data OrderData struct containing order values
741     /// @return amountToGive amount taker needs to give in order to fill the order
742     function getAmountToGive(
743         OrderData data
744     )
745         public
746         view
747         whenNotPaused
748         onlyTotle
749         returns (uint256 amountToGive)
750     {
751         amountToGive = data.amountToGive;
752     }
753 
754     /// @notice Perform exchange-specific checks on the given order
755     /// @dev This should be called to check for payload errors
756     /// @param data OrderData struct containing order values
757     /// @return checksPassed value representing pass or fail
758     function staticExchangeChecks(
759         OrderData data
760     )
761         public
762         view
763         whenNotPaused
764         onlyTotle
765         returns (bool checksPassed)
766     {
767         return true;
768     }
769 
770     /// @dev Perform a buy order at the exchange
771     /// @param data OrderData struct containing order values
772     /// @param  amountToGiveForOrder amount that should be spent on this order
773     /// @return amountSpentOnOrder the amount that would be spent on the order
774     /// @return amountReceivedFromOrder the amount that was received from this order
775     function performBuyOrder(
776         OrderData data,
777         uint256 amountToGiveForOrder
778     )
779         public
780         payable
781         whenNotPaused
782         onlyTotle
783         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
784     {
785         UniswapExchange ex = UniswapExchange(data.exchangeAddress);
786         amountSpentOnOrder = amountToGiveForOrder;
787         amountReceivedFromOrder = ex.ethToTokenTransferInput.value(amountToGiveForOrder)(1, block.timestamp+1, msg.sender);
788         /* logger.log("Performing Uniswap buy order arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder);  */
789 
790     }
791 
792     /// @dev Perform a sell order at the exchange
793     /// @param data OrderData struct containing order values
794     /// @param  amountToGiveForOrder amount that should be spent on this order
795     /// @return amountSpentOnOrder the amount that would be spent on the order
796     /// @return amountReceivedFromOrder the amount that was received from this order
797     function performSellOrder(
798         OrderData data,
799         uint256 amountToGiveForOrder
800     )
801         public
802         whenNotPaused
803         onlyTotle
804         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
805     {
806         UniswapExchange ex = UniswapExchange(data.exchangeAddress);
807         approveAddress(data.exchangeAddress, ex.tokenAddress());
808         amountSpentOnOrder = amountToGiveForOrder;
809         amountReceivedFromOrder = ex.tokenToEthTransferInput(amountToGiveForOrder, 1, block.timestamp+1, msg.sender);
810         /* logger.log("Performing Uniswap sell order arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder",amountSpentOnOrder,amountReceivedFromOrder); */
811     }
812 
813     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
814         if (genericSelector == getAmountToGiveSelector) {
815             return bytes4(keccak256("getAmountToGive((address,uint256))"));
816         } else if (genericSelector == staticExchangeChecksSelector) {
817             return bytes4(keccak256("staticExchangeChecks((address,uint256))"));
818         } else if (genericSelector == performBuyOrderSelector) {
819             return bytes4(keccak256("performBuyOrder((address,uint256),uint256)"));
820         } else if (genericSelector == performSellOrderSelector) {
821             return bytes4(keccak256("performSellOrder((address,uint256),uint256)"));
822         } else {
823             return bytes4(0x0);
824         }
825     }
826 
827     /// @notice payable fallback to block EOA sending eth
828     /// @dev this should fail if an EOA (or contract with 0 bytecode size) tries to send ETH to this contract
829     function() public payable {
830         // Check in here that the sender is a contract! (to stop accidents)
831         uint256 size;
832         address sender = msg.sender;
833         assembly {
834             size := extcodesize(sender)
835         }
836         require(size > 0);
837     }
838 }