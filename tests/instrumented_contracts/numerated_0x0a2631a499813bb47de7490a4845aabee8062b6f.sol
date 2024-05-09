1 pragma solidity 0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title Math
6  * @dev Assorted math operations
7  */
8 
9 library Math {
10   function max(uint256 a, uint256 b) internal pure returns (uint256) {
11     return a >= b ? a : b;
12   }
13 
14   function min(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a < b ? a : b;
16   }
17 
18   function average(uint256 a, uint256 b) internal pure returns (uint256) {
19     // (a + b) / 2 can overflow, so we distribute
20     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
21   }
22 }
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that revert on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, reverts on overflow.
32   */
33   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
34     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35     // benefit is lost if 'b' is also tested.
36     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37     if (_a == 0) {
38       return 0;
39     }
40 
41     uint256 c = _a * _b;
42     require(c / _a == _b);
43 
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
49   */
50   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     require(_b > 0); // Solidity only automatically asserts when dividing by 0
52     uint256 c = _a / _b;
53     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
54 
55     return c;
56   }
57 
58   /**
59   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
60   */
61   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
62     require(_b <= _a);
63     uint256 c = _a - _b;
64 
65     return c;
66   }
67 
68   /**
69   * @dev Adds two numbers, reverts on overflow.
70   */
71   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
72     uint256 c = _a + _b;
73     require(c >= _a);
74 
75     return c;
76   }
77 
78   /**
79   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
80   * reverts when dividing by zero.
81   */
82   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83     require(b != 0);
84     return a % b;
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
123 library ERC20SafeTransfer {
124     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
125 
126         require(_tokenAddress.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
127 
128         return fetchReturnData();
129     }
130 
131     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
132 
133         require(_tokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
134 
135         return fetchReturnData();
136     }
137 
138     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
139 
140         require(_tokenAddress.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
141 
142         return fetchReturnData();
143     }
144 
145     function fetchReturnData() internal returns (bool success){
146         assembly {
147             switch returndatasize()
148             case 0 {
149                 success := 1
150             }
151             case 32 {
152                 returndatacopy(0, 0, 32)
153                 success := mload(0)
154             }
155             default {
156                 revert(0, 0)
157             }
158         }
159     }
160 
161 }
162 
163 /// @title A contract which is used to check and set allowances of tokens
164 /// @dev In order to use this contract is must be inherited in the contract which is using
165 /// its functionality
166 contract AllowanceSetter {
167     uint256 constant MAX_UINT = 2**256 - 1;
168 
169     /// @notice A function which allows the caller to approve the max amount of any given token
170     /// @dev In order to function correctly, token allowances should not be set anywhere else in
171     /// the inheriting contract
172     /// @param addressToApprove the address which we want to approve to transfer the token
173     /// @param token the token address which we want to call approve on
174     function approveAddress(address addressToApprove, address token) internal {
175         if(ERC20(token).allowance(address(this), addressToApprove) == 0) {
176             require(ERC20SafeTransfer.safeApprove(token, addressToApprove, MAX_UINT));
177         }
178     }
179 
180 }
181 
182 contract ErrorReporter {
183     function revertTx(string reason) public pure {
184         revert(reason);
185     }
186 }
187 
188 /**
189  * @title Ownable
190  * @dev The Ownable contract has an owner address, and provides basic authorization control
191  * functions, this simplifies the implementation of "user permissions".
192  */
193 contract Ownable {
194   address public owner;
195 
196   event OwnershipRenounced(address indexed previousOwner);
197   event OwnershipTransferred(
198     address indexed previousOwner,
199     address indexed newOwner
200   );
201 
202   /**
203    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
204    * account.
205    */
206   constructor() public {
207     owner = msg.sender;
208   }
209 
210   /**
211    * @dev Throws if called by any account other than the owner.
212    */
213   modifier onlyOwner() {
214     require(msg.sender == owner);
215     _;
216   }
217 
218   /**
219    * @dev Allows the current owner to relinquish control of the contract.
220    * @notice Renouncing to ownership will leave the contract without an owner.
221    * It will not be possible to call the functions with the `onlyOwner`
222    * modifier anymore.
223    */
224   function renounceOwnership() public onlyOwner {
225     emit OwnershipRenounced(owner);
226     owner = address(0);
227   }
228 
229   /**
230    * @dev Allows the current owner to transfer control of the contract to a newOwner.
231    * @param _newOwner The address to transfer ownership to.
232    */
233   function transferOwnership(address _newOwner) public onlyOwner {
234     _transferOwnership(_newOwner);
235   }
236 
237   /**
238    * @dev Transfers control of the contract to a newOwner.
239    * @param _newOwner The address to transfer ownership to.
240    */
241   function _transferOwnership(address _newOwner) internal {
242     require(_newOwner != address(0));
243     emit OwnershipTransferred(owner, _newOwner);
244     owner = _newOwner;
245   }
246 }
247 
248 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
249 /// some functions
250 /// @dev Defines a modifier which should be used when only the totle contract should
251 /// able able to call a function
252 contract TotleControl is Ownable {
253     address public totlePrimary;
254 
255     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
256     modifier onlyTotle() {
257         require(msg.sender == totlePrimary);
258         _;
259     }
260 
261     /// @notice Contract constructor
262     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
263     /// @param _totlePrimary the address of the contract to be set as totlePrimary
264     constructor(address _totlePrimary) public {
265         require(_totlePrimary != address(0x0));
266         totlePrimary = _totlePrimary;
267     }
268 
269     /// @notice A function which allows only the owner to change the address of totlePrimary
270     /// @dev onlyOwner modifier only allows the contract owner to run the code
271     /// @param _totlePrimary the address of the contract to be set as totlePrimary
272     function setTotle(
273         address _totlePrimary
274     ) external onlyOwner {
275         require(_totlePrimary != address(0x0));
276         totlePrimary = _totlePrimary;
277     }
278 }
279 
280 /// @title A contract which allows its owner to withdraw any ether which is contained inside
281 contract Withdrawable is Ownable {
282 
283     /// @notice Withdraw ether contained in this contract and send it back to owner
284     /// @dev onlyOwner modifier only allows the contract owner to run the code
285     /// @param _token The address of the token that the user wants to withdraw
286     /// @param _amount The amount of tokens that the caller wants to withdraw
287     /// @return bool value indicating whether the transfer was successful
288     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
289         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
290     }
291 
292     /// @notice Withdraw ether contained in this contract and send it back to owner
293     /// @dev onlyOwner modifier only allows the contract owner to run the code
294     /// @param _amount The amount of ether that the caller wants to withdraw
295     function withdrawETH(uint256 _amount) external onlyOwner {
296         owner.transfer(_amount);
297     }
298 }
299 
300 /**
301  * @title Pausable
302  * @dev Base contract which allows children to implement an emergency stop mechanism.
303  */
304 contract Pausable is Ownable {
305   event Paused();
306   event Unpaused();
307 
308   bool private _paused = false;
309 
310   /**
311    * @return true if the contract is paused, false otherwise.
312    */
313   function paused() public view returns (bool) {
314     return _paused;
315   }
316 
317   /**
318    * @dev Modifier to make a function callable only when the contract is not paused.
319    */
320   modifier whenNotPaused() {
321     require(!_paused, "Contract is paused.");
322     _;
323   }
324 
325   /**
326    * @dev Modifier to make a function callable only when the contract is paused.
327    */
328   modifier whenPaused() {
329     require(_paused, "Contract not paused.");
330     _;
331   }
332 
333   /**
334    * @dev called by the owner to pause, triggers stopped state
335    */
336   function pause() public onlyOwner whenNotPaused {
337     _paused = true;
338     emit Paused();
339   }
340 
341   /**
342    * @dev called by the owner to unpause, returns to normal state
343    */
344   function unpause() public onlyOwner whenPaused {
345     _paused = false;
346     emit Unpaused();
347   }
348 }
349 
350 contract SelectorProvider {
351     bytes4 constant getAmountToGive = bytes4(keccak256("getAmountToGive(bytes)"));
352     bytes4 constant staticExchangeChecks = bytes4(keccak256("staticExchangeChecks(bytes)"));
353     bytes4 constant performBuyOrder = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
354     bytes4 constant performSellOrder = bytes4(keccak256("performSellOrder(bytes,uint256)"));
355 
356     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
357 }
358 
359 /// @title Interface for all exchange handler contracts
360 contract ExchangeHandler is TotleControl, Withdrawable, Pausable {
361 
362     /*
363     *   State Variables
364     */
365 
366     SelectorProvider public selectorProvider;
367     ErrorReporter public errorReporter;
368     /* Logger public logger; */
369     /*
370     *   Modifiers
371     */
372 
373     modifier onlySelf() {
374         require(msg.sender == address(this));
375         _;
376     }
377 
378     /// @notice Constructor
379     /// @dev Calls the constructor of the inherited TotleControl
380     /// @param _selectorProvider the provider for this exchanges function selectors
381     /// @param totlePrimary the address of the totlePrimary contract
382     constructor(
383         address _selectorProvider,
384         address totlePrimary,
385         address _errorReporter
386         /* ,address _logger */
387     )
388         TotleControl(totlePrimary)
389         public
390     {
391         require(_selectorProvider != address(0x0));
392         require(_errorReporter != address(0x0));
393         /* require(_logger != address(0x0)); */
394         selectorProvider = SelectorProvider(_selectorProvider);
395         errorReporter = ErrorReporter(_errorReporter);
396         /* logger = Logger(_logger); */
397     }
398 
399     /// @notice Gets the amount that Totle needs to give for this order
400     /// @param genericPayload the data for this order in a generic format
401     /// @return amountToGive amount taker needs to give in order to fill the order
402     function getAmountToGive(
403         bytes genericPayload
404     )
405         public
406         view
407         onlyTotle
408         whenNotPaused
409         returns (uint256 amountToGive)
410     {
411         bool success;
412         bytes4 functionSelector = selectorProvider.getSelector(this.getAmountToGive.selector);
413 
414         assembly {
415             let functionSelectorLength := 0x04
416             let functionSelectorOffset := 0x1C
417             let scratchSpace := 0x0
418             let wordLength := 0x20
419             let bytesLength := mload(genericPayload)
420             let totalLength := add(functionSelectorLength, bytesLength)
421             let startOfNewData := add(genericPayload, functionSelectorOffset)
422 
423             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
424             let functionSelectorCorrect := mload(scratchSpace)
425             mstore(genericPayload, functionSelectorCorrect)
426 
427             success := call(
428                             gas,
429                             address, // This address of the current contract
430                             callvalue,
431                             startOfNewData, // Start data at the beginning of the functionSelector
432                             totalLength, // Total length of all data, including functionSelector
433                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
434                             wordLength // Length of return variable is one word
435                            )
436             amountToGive := mload(scratchSpace)
437             if eq(success, 0) { revert(0, 0) }
438         }
439     }
440 
441     /// @notice Perform exchange-specific checks on the given order
442     /// @dev this should be called to check for payload errors
443     /// @param genericPayload the data for this order in a generic format
444     /// @return checksPassed value representing pass or fail
445     function staticExchangeChecks(
446         bytes genericPayload
447     )
448         public
449         view
450         onlyTotle
451         whenNotPaused
452         returns (bool checksPassed)
453     {
454         bool success;
455         bytes4 functionSelector = selectorProvider.getSelector(this.staticExchangeChecks.selector);
456         assembly {
457             let functionSelectorLength := 0x04
458             let functionSelectorOffset := 0x1C
459             let scratchSpace := 0x0
460             let wordLength := 0x20
461             let bytesLength := mload(genericPayload)
462             let totalLength := add(functionSelectorLength, bytesLength)
463             let startOfNewData := add(genericPayload, functionSelectorOffset)
464 
465             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
466             let functionSelectorCorrect := mload(scratchSpace)
467             mstore(genericPayload, functionSelectorCorrect)
468 
469             success := call(
470                             gas,
471                             address, // This address of the current contract
472                             callvalue,
473                             startOfNewData, // Start data at the beginning of the functionSelector
474                             totalLength, // Total length of all data, including functionSelector
475                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
476                             wordLength // Length of return variable is one word
477                            )
478             checksPassed := mload(scratchSpace)
479             if eq(success, 0) { revert(0, 0) }
480         }
481     }
482 
483     /// @notice Perform a buy order at the exchange
484     /// @param genericPayload the data for this order in a generic format
485     /// @param  amountToGiveForOrder amount that should be spent on this order
486     /// @return amountSpentOnOrder the amount that would be spent on the order
487     /// @return amountReceivedFromOrder the amount that was received from this order
488     function performBuyOrder(
489         bytes genericPayload,
490         uint256 amountToGiveForOrder
491     )
492         public
493         payable
494         onlyTotle
495         whenNotPaused
496         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
497     {
498         bool success;
499         bytes4 functionSelector = selectorProvider.getSelector(this.performBuyOrder.selector);
500         assembly {
501             let callDataOffset := 0x44
502             let functionSelectorOffset := 0x1C
503             let functionSelectorLength := 0x04
504             let scratchSpace := 0x0
505             let wordLength := 0x20
506             let startOfFreeMemory := mload(0x40)
507 
508             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
509 
510             let bytesLength := mload(startOfFreeMemory)
511             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
512 
513             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
514 
515             let functionSelectorCorrect := mload(scratchSpace)
516 
517             mstore(startOfFreeMemory, functionSelectorCorrect)
518 
519             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
520 
521             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
522 
523             success := call(
524                             gas,
525                             address, // This address of the current contract
526                             callvalue,
527                             startOfNewData, // Start data at the beginning of the functionSelector
528                             totalLength, // Total length of all data, including functionSelector
529                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
530                             mul(wordLength, 0x02) // Length of return variables is two words
531                           )
532             amountSpentOnOrder := mload(scratchSpace)
533             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
534             if eq(success, 0) { revert(0, 0) }
535         }
536     }
537 
538     /// @notice Perform a sell order at the exchange
539     /// @param genericPayload the data for this order in a generic format
540     /// @param  amountToGiveForOrder amount that should be spent on this order
541     /// @return amountSpentOnOrder the amount that would be spent on the order
542     /// @return amountReceivedFromOrder the amount that was received from this order
543     function performSellOrder(
544         bytes genericPayload,
545         uint256 amountToGiveForOrder
546     )
547         public
548         onlyTotle
549         whenNotPaused
550         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
551     {
552         bool success;
553         bytes4 functionSelector = selectorProvider.getSelector(this.performSellOrder.selector);
554         assembly {
555             let callDataOffset := 0x44
556             let functionSelectorOffset := 0x1C
557             let functionSelectorLength := 0x04
558             let scratchSpace := 0x0
559             let wordLength := 0x20
560             let startOfFreeMemory := mload(0x40)
561 
562             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
563 
564             let bytesLength := mload(startOfFreeMemory)
565             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
566 
567             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
568 
569             let functionSelectorCorrect := mload(scratchSpace)
570 
571             mstore(startOfFreeMemory, functionSelectorCorrect)
572 
573             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
574 
575             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
576 
577             success := call(
578                             gas,
579                             address, // This address of the current contract
580                             callvalue,
581                             startOfNewData, // Start data at the beginning of the functionSelector
582                             totalLength, // Total length of all data, including functionSelector
583                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
584                             mul(wordLength, 0x02) // Length of return variables is two words
585                           )
586             amountSpentOnOrder := mload(scratchSpace)
587             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
588             if eq(success, 0) { revert(0, 0) }
589         }
590     }
591 }
592 
593 /// @title BancorConverter
594 /// @notice Bancor converter contract interface
595 interface BancorConverter {
596     function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn) external payable returns (uint256);
597     function registry() external view returns (IContractRegistry);
598     function BANCOR_GAS_PRICE_LIMIT() external view returns (bytes32);
599     function BANCOR_NETWORK() external view returns (bytes32);
600 }
601 
602 /// @title IContractRegistry
603 /// @notice Bancor contract registry interface
604 interface IContractRegistry {
605     function getAddress(bytes32 _contractName) external view returns (address);
606 }
607 
608 /// @title IBancorGasPriceLimit
609 /// @notice Bancor gas price limit contract interface
610 interface IBancorGasPriceLimit {
611     function gasPrice() external view returns (uint256);
612 }
613 
614 /// @title BancorNetwork
615 /// @notice Bancor Network contract interface
616 interface BancorNetwork {
617     function getReturnByPath(address[] _path, uint256 _amount) external view returns (uint256) ;
618 }
619 
620 /// @title BancorSelectorProvider
621 /// @notice Provides this exchange implementation with correctly formatted function selectors
622 contract BancorSelectorProvider is SelectorProvider {
623     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
624         if (genericSelector == getAmountToGive) {
625             return bytes4(keccak256("getAmountToGive((address,address[11],address,uint256,uint256,uint256))"));
626         } else if (genericSelector == staticExchangeChecks) {
627             return bytes4(keccak256("staticExchangeChecks((address,address[11],address,uint256,uint256,uint256))"));
628         } else if (genericSelector == performBuyOrder) {
629             return bytes4(keccak256("performBuyOrder((address,address[11],address,uint256,uint256,uint256),uint256)"));
630         } else if (genericSelector == performSellOrder) {
631             return bytes4(keccak256("performSellOrder((address,address[11],address,uint256,uint256,uint256),uint256)"));
632         } else {
633             return bytes4(0x0);
634         }
635     }
636 }
637 
638 /// @title Interface for all exchange handler contracts
639 /// @notice Handles the all Bancor trades for the primary contract
640 contract BancorHandler is ExchangeHandler, AllowanceSetter {
641 
642     /*
643     *   Types
644     */
645 
646     struct OrderData {
647         address converterAddress;
648         address[11] conversionPath;
649         address destinationToken;
650         uint256 minReturn;
651         uint256 amountToGive;
652         uint256 expectedReturn;
653     }
654 
655     /// @notice Constructor
656     /// @param selectorProvider the provider for this exchanges function selectors
657     /// @param totlePrimary the address of the totlePrimary contract
658     /// @param errorReporter the address of the error reporter contract
659     constructor(
660         address selectorProvider,
661         address totlePrimary,
662         address errorReporter
663         /* ,address logger */
664     )
665         ExchangeHandler(selectorProvider, totlePrimary, errorReporter/*, logger*/)
666         public
667     {}
668 
669     /*
670     *   Public functions
671     */
672 
673     /// @notice Gets the amount that Totle needs to give for this order
674     /// @dev Uses the `onlySelf` modifier with public visibility as this function
675     /// should only be called from functions which are inherited from the ExchangeHandler
676     /// base contract.
677     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
678     /// @param data OrderData struct containing order values
679     /// @return amountToGive amount taker needs to give in order to fill the order
680     function getAmountToGive(
681         OrderData data
682     )
683         public
684         view
685         whenNotPaused
686         onlySelf
687         returns (uint256 amountToGive)
688     {
689         amountToGive = data.amountToGive;
690     }
691 
692     /// @notice Perform exchange-specific checks on the given order
693     /// @dev This function should be called to check for payload errors.
694     /// Uses the `onlySelf` modifier with public visibility as this function
695     /// should only be called from functions which are inherited from the ExchangeHandler
696     /// base contract.
697     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
698     /// @param data OrderData struct containing order values
699     /// @return checksPassed value representing pass or fail
700     function staticExchangeChecks(
701         OrderData data
702     )
703         public
704         view
705         whenNotPaused
706         onlySelf
707         returns (bool checksPassed)
708     {
709         BancorConverter converter = BancorConverter(data.converterAddress);
710         IBancorGasPriceLimit gasPriceLimitContract = IBancorGasPriceLimit(
711             converter.registry().getAddress(converter.BANCOR_GAS_PRICE_LIMIT())
712         );
713 
714         uint256 gasPriceLimit = gasPriceLimitContract.gasPrice();
715         checksPassed = tx.gasprice <= gasPriceLimit;
716 
717         /* logger.log(
718             "Checking gas price arg2: tx.gasprice, arg3: gasPriceLimit",
719             tx.gasprice,
720             gasPriceLimit
721         ); */
722     }
723 
724     /// @notice Perform a buy order at the exchange
725     /// @dev Uses the `onlySelf` modifier with public visibility as this function
726     /// should only be called from functions which are inherited from the ExchangeHandler
727     /// base contract.
728     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
729     /// @param data OrderData struct containing order values
730     /// @param amountToGiveForOrder amount that should be spent on this order
731     /// @return amountSpentOnOrder the amount that would be spent on the order
732     /// @return amountReceivedFromOrder the amount that was received from this order
733     function performBuyOrder(
734         OrderData data,
735         uint256 amountToGiveForOrder
736     )
737         public
738         payable
739         whenNotPaused
740         onlySelf
741         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
742     {
743         amountSpentOnOrder = amountToGiveForOrder;
744         amountReceivedFromOrder = BancorConverter(data.converterAddress).quickConvert.value(msg.value)(
745             trimAddressArray(data.conversionPath),
746             amountToGiveForOrder,
747             data.minReturn
748         );
749 
750         /* logger.log(
751             "Performed Bancor buy arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder",
752             amountSpentOnOrder,
753             amountReceivedFromOrder
754         ); */
755 
756         if (!ERC20SafeTransfer.safeTransfer(data.destinationToken, totlePrimary, amountReceivedFromOrder)){
757             errorReporter.revertTx("Failed to transfer tokens to totle primary");
758         }
759     }
760 
761     /// @notice Perform a sell order at the exchange
762     /// @dev Uses the `onlySelf` modifier with public visibility as this function
763     /// should only be called from functions which are inherited from the ExchangeHandler
764     /// base contract
765     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
766     /// @param data OrderData struct containing order values
767     /// @param amountToGiveForOrder amount that should be spent on this order
768     /// @return amountSpentOnOrder the amount that would be spent on the order
769     /// @return amountReceivedFromOrder the amount that was received from this order
770     function performSellOrder(
771         OrderData data,
772         uint256 amountToGiveForOrder
773     )
774         public
775         whenNotPaused
776         onlySelf
777         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
778     {
779         approveAddress(data.converterAddress, data.conversionPath[0]);
780 
781         amountSpentOnOrder = amountToGiveForOrder;
782         amountReceivedFromOrder = BancorConverter(data.converterAddress).quickConvert(
783             trimAddressArray(data.conversionPath),
784             amountToGiveForOrder,
785             data.minReturn
786         );
787 
788         /* logger.log(
789             "Performed Bancor sell arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder",
790             amountSpentOnOrder,
791             amountReceivedFromOrder
792         ); */
793 
794         totlePrimary.transfer(amountReceivedFromOrder);
795     }
796 
797     /// @notice Calculate the result of ((numerator * target) / denominator)
798     /// @param numerator the numerator in the equation
799     /// @param denominator the denominator in the equation
800     /// @param target the target for the equations
801     /// @return partialAmount the resultant value
802     function getPartialAmount(
803         uint256 numerator,
804         uint256 denominator,
805         uint256 target
806     )
807         internal
808         pure
809         returns (uint256)
810     {
811         return SafeMath.div(SafeMath.mul(numerator, target), denominator);
812     }
813 
814     /// @notice Takes the static array, trims the excess and returns a dynamic array
815     /// @param addresses the static array
816     /// @return address[] the dynamic array
817     function trimAddressArray(address[11] addresses) internal pure returns (address[]) {
818         uint256 length = 0;
819         for (uint256 index = 0; index < 11; index++){
820             if (addresses[index] == 0x0){
821                 continue;
822             }
823             length++;
824         }
825         address[] memory trimmedArray = new address[](length);
826         for (index = 0; index < length; index++){
827             trimmedArray[index] = addresses[index];
828         }
829         return trimmedArray;
830     }
831 
832     /*
833     *   Payable fallback function
834     */
835 
836     /// @notice payable fallback to allow handler or exchange contracts to return ether
837     /// @dev only accounts containing code (ie. contracts) can send ether to this contract
838     function() public payable whenNotPaused {
839         // Check in here that the sender is a contract! (to stop accidents)
840         uint256 size;
841         address sender = msg.sender;
842         assembly {
843             size := extcodesize(sender)
844         }
845         if (size == 0) {
846             errorReporter.revertTx("EOA cannot send ether to primary fallback");
847         }
848     }
849 }