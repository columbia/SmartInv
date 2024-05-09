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
593 /// @title OasisInterface
594 /// @notice Exchange contract interface
595 interface OasisInterface {
596     function buy(uint id, uint quantity) external returns (bool);
597     function getOffer(uint id) external constant returns (uint, ERC20, uint, ERC20);
598     function isActive(uint id) external constant returns (bool);
599 }
600 
601 interface WethInterface {
602     function deposit() external payable;
603     function withdraw(uint amount) external payable;
604 }
605 
606 /// @title OasisSelectorProvider
607 /// @notice Provides this exchange implementation with correctly formatted function selectors
608 contract OasisSelectorProvider is SelectorProvider {
609     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
610         if (genericSelector == getAmountToGive) {
611             return bytes4(keccak256("getAmountToGive((uint256,uint256))"));
612         } else if (genericSelector == staticExchangeChecks) {
613             return bytes4(keccak256("staticExchangeChecks((uint256,uint256))"));
614         } else if (genericSelector == performBuyOrder) {
615             return bytes4(keccak256("performBuyOrder((uint256,uint256),uint256)"));
616         } else if (genericSelector == performSellOrder) {
617             return bytes4(keccak256("performSellOrder((uint256,uint256),uint256)"));
618         } else {
619             return bytes4(0x0);
620         }
621     }
622 }
623 
624 /// @title OasisHandler
625 /// @notice Handles the all Oasis trades for the primary contract
626 contract OasisHandler is ExchangeHandler, AllowanceSetter {
627 
628     /*
629     *   State Variables
630     */
631 
632     OasisInterface public oasis;
633     WethInterface public weth;
634 
635     /*
636     *   Types
637     */
638 
639     struct OrderData {
640         uint256 offerId;
641         uint256 maxAmountToSpend;
642     }
643 
644     /// @notice Constructor
645     /// @dev Calls the constructor of the inherited ExchangeHandler
646     /// @param oasisAddress the address of the oasis exchange contract
647     /// @param wethAddress the address of the weth contract
648     /// @param selectorProvider the provider for this exchanges function selectors
649     /// @param totlePrimary the address of the totlePrimary contract
650     constructor(
651         address oasisAddress,
652         address wethAddress,
653         address selectorProvider,
654         address totlePrimary,
655         address errorReporter
656         /* , address logger */
657     )
658         ExchangeHandler(selectorProvider, totlePrimary, errorReporter/*,logger*/)
659         public
660     {
661         require(oasisAddress != address(0x0));
662         require(wethAddress != address(0x0));
663         oasis = OasisInterface(oasisAddress);
664         weth = WethInterface(wethAddress);
665     }
666 
667     /*
668     *   Public functions
669     */
670 
671     /// @notice Gets the amount that Totle needs to give for this order
672     /// @dev Uses the `onlySelf` modifier with public visibility as this function
673     /// should only be called from functions which are inherited from the ExchangeHandler
674     /// base contract.
675     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
676     /// @param data OrderData struct containing order values
677     /// @return amountToGive amount taker needs to give in order to fill the order
678     function getAmountToGive(
679         OrderData data
680     )
681         public
682         view
683         whenNotPaused
684         onlySelf
685         returns (uint256 amountToGive)
686     {
687         uint256 availableGetAmount;
688         (availableGetAmount,,,) = oasis.getOffer(data.offerId);
689         /* logger.log("Oasis order available amount arg2: availableGetAmount", availableGetAmount); */
690         return availableGetAmount > data.maxAmountToSpend ? data.maxAmountToSpend : availableGetAmount;
691     }
692 
693     /// @notice Perform exchange-specific checks on the given order
694     /// @dev This function should be called to check for payload errors.
695     /// Uses the `onlySelf` modifier with public visibility as this function
696     /// should only be called from functions which are inherited from the ExchangeHandler
697     /// base contract.
698     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
699     /// @param data OrderData struct containing order values
700     /// @return checksPassed value representing pass or fail
701     function staticExchangeChecks(
702         OrderData data
703     )
704         public
705         view
706         whenNotPaused
707         onlySelf
708         returns (bool checksPassed)
709     {
710 
711         /* logger.log("Oasis static exchange checks"); */
712         // Check if the offer is active
713         if (!oasis.isActive(data.offerId)){
714             /* logger.log("Oasis offer is not active arg2: offerId", data.offerId); */
715             return false;
716         }
717 
718         // Check if the pay_gem or buy_gem is weth
719         address pay_gem;
720         address buy_gem;
721         (,pay_gem,,buy_gem) = oasis.getOffer(data.offerId);
722 
723         bool isBuyOrPayWeth = pay_gem == address(weth) || buy_gem == address(weth);
724         if (!isBuyOrPayWeth){
725             /* logger.log("Oasis offer's base pair is not WETH arg6: pay_gem, arg7: buy_gem", 0,0,0,0, pay_gem, buy_gem); */
726             return false;
727         }
728 
729         return true;
730     }
731 
732     /// @notice Perform a buy order at the exchange
733     /// @dev Uses the `onlySelf` modifier with public visibility as this function
734     /// should only be called from functions which are inherited from the ExchangeHandler
735     /// base contract.
736     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
737     /// @param data OrderData struct containing order values
738     /// @param amountToSpend amount that should be spent on this order
739     /// @return amountSpentOnOrder the amount that would be spent on the order
740     /// @return amountReceivedFromOrder the amount that was received from this order
741     function performBuyOrder(
742         OrderData data,
743         uint256 amountToSpend
744     )
745         public
746         payable
747         whenNotPaused
748         onlySelf
749         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
750     {
751         /* logger.log("Performing Oasis buy order arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
752         if (msg.value != amountToSpend){
753 
754             /* logger.log("Ether sent is not equal to amount to spend arg2: amountToSpend, arg3: msg.value", amountToSpend, msg.value); */
755             totlePrimary.transfer(msg.value);
756             return (0,0);
757         }
758 
759         //Convert ETH to Weth
760         weth.deposit.value(amountToSpend)();
761 
762         /* logger.log("Converted to WETH"); */
763 
764         //Approve oasis to move weth
765         approveAddress(address(oasis), address(weth));
766 
767         /* logger.log("Address approved"); */
768 
769         //Fetch offer data and validate buy gem is weth
770         uint256 maxPayGem;
771         address payGem;
772         uint256 maxBuyGem;
773         address buyGem;
774         (maxPayGem,payGem,maxBuyGem,buyGem) = oasis.getOffer(data.offerId);
775 
776         if (buyGem != address(weth)){
777             errorReporter.revertTx("buyGem != address(weth)");
778         }
779 
780         //Calculate quantity to buy
781         uint256 amountToBuy = SafeMath.div( SafeMath.mul(amountToSpend, maxPayGem), maxBuyGem);
782 
783         if (!oasis.buy(data.offerId, amountToBuy)){
784             errorReporter.revertTx("Oasis buy failed");
785         }
786 
787         //Calculate actual amounts spent and got
788         uint256 newMaxPayGem;
789         uint256 newMaxBuyGem;
790         (newMaxPayGem,,newMaxBuyGem,) = oasis.getOffer(data.offerId);
791 
792         amountReceivedFromOrder = maxPayGem - newMaxPayGem;
793         amountSpentOnOrder = maxBuyGem - newMaxBuyGem;
794 
795         //If we didn't spend all the eth, withdraw it from weth and send back to totlePrimary
796         if (amountSpentOnOrder < amountToSpend){
797           /* logger.log("Got some ether left, withdrawing arg2: amountSpentOnOrder, arg3: amountToSpend", amountSpentOnOrder, amountToSpend); */
798           weth.withdraw(amountToSpend - amountSpentOnOrder);
799           totlePrimary.transfer(amountToSpend - amountSpentOnOrder);
800         }
801 
802         //Send the purchased tokens back to totlePrimary
803         if (!ERC20(payGem).transfer(totlePrimary, amountReceivedFromOrder)){
804             errorReporter.revertTx("Unable to transfer bought tokens to totlePrimary");
805         }
806     }
807 
808     /// @notice Perform a sell order at the exchange
809     /// @dev Uses the `onlySelf` modifier with public visibility as this function
810     /// should only be called from functions which are inherited from the ExchangeHandler
811     /// base contract
812     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
813     /// @param data OrderData struct containing order values
814     /// @param amountToSpend amount that should be spent on this order
815     /// @return amountSpentOnOrder the amount that would be spent on the order
816     /// @return amountReceivedFromOrder the amount that was received from this order
817     function performSellOrder(
818         OrderData data,
819         uint256 amountToSpend
820     )
821         public
822         whenNotPaused
823         onlySelf
824         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
825     {
826       //Fetch offer data and validate buy gem is weth
827       uint256 maxPayGem;
828       address payGem;
829       uint256 maxBuyGem;
830       address buyGem;
831       (maxPayGem,payGem,maxBuyGem,buyGem) = oasis.getOffer(data.offerId);
832 
833       /* logger.log("Performing Oasis sell order arg2: amountToSpend", amountToSpend); */
834 
835       if (payGem != address(weth)){
836           errorReporter.revertTx("payGem != address(weth)");
837       }
838 
839       //Approve oasis to move buy gem
840       approveAddress(address(oasis), address(buyGem));
841 
842       /* logger.log("Address approved"); */
843 
844       //Calculate quantity to buy
845       uint256 amountToBuy = SafeMath.div( SafeMath.mul(amountToSpend, maxPayGem), maxBuyGem);
846       if(amountToBuy == 0){
847           /* logger.log("Amount to buy is zero, amountToSpend was likely too small to get any. Did the previous order fill all but a small amount? arg2: amountToSpend", amountToSpend); */
848           ERC20(buyGem).transfer(totlePrimary, amountToSpend);
849           return (0, 0);
850       }
851       if (!oasis.buy(data.offerId, amountToBuy)){
852           errorReporter.revertTx("Oasis buy failed");
853       }
854 
855       //Calculate actual amounts spent and got
856       uint256 newMaxPayGem;
857       uint256 newMaxBuyGem;
858       (newMaxPayGem,,newMaxBuyGem,) = oasis.getOffer(data.offerId);
859 
860       amountReceivedFromOrder = maxPayGem - newMaxPayGem;
861       amountSpentOnOrder = maxBuyGem - newMaxBuyGem;
862 
863       //If we didn't spend all the tokens, withdraw it from weth and send back to totlePrimary
864       if (amountSpentOnOrder < amountToSpend){
865         /* logger.log("Got some tokens left, withdrawing arg2: amountSpentOnOrder, arg3: amountToSpend", amountSpentOnOrder, amountToSpend); */
866         ERC20(buyGem).transfer(totlePrimary, amountToSpend - amountSpentOnOrder);
867       }
868 
869       //Send the purchased tokens back to totlePrimary
870       weth.withdraw(amountReceivedFromOrder);
871       totlePrimary.transfer(amountReceivedFromOrder);
872     }
873 
874     /// @notice Changes the current contract address set as WETH
875     /// @param wethAddress the address of the new WETH contract
876     function setWeth(
877         address wethAddress
878     )
879         public
880         onlyOwner
881     {
882         require(wethAddress != address(0x0));
883         weth = WethInterface(wethAddress);
884     }
885 
886     /*
887     *   Payable fallback function
888     */
889 
890     /// @notice payable fallback to allow handler or exchange contracts to return ether
891     /// @dev only accounts containing code (ie. contracts) can send ether to this contract
892     function() public payable whenNotPaused {
893         // Check in here that the sender is a contract! (to stop accidents)
894         uint256 size;
895         address sender = msg.sender;
896         assembly {
897             size := extcodesize(sender)
898         }
899         if (size == 0) {
900             errorReporter.revertTx("EOA cannot send ether to primary fallback");
901         }
902     }
903 }