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
253     mapping(address => bool) public authorizedPrimaries;
254 
255     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
256     modifier onlyTotle() {
257         require(authorizedPrimaries[msg.sender]);
258         _;
259     }
260 
261     /// @notice Contract constructor
262     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
263     /// @param _totlePrimary the address of the contract to be set as totlePrimary
264     constructor(address _totlePrimary) public {
265         authorizedPrimaries[_totlePrimary] = true;
266     }
267 
268     /// @notice A function which allows only the owner to change the address of totlePrimary
269     /// @dev onlyOwner modifier only allows the contract owner to run the code
270     /// @param _totlePrimary the address of the contract to be set as totlePrimary
271     function addTotle(
272         address _totlePrimary
273     ) external onlyOwner {
274         authorizedPrimaries[_totlePrimary] = true;
275     }
276 
277     function removeTotle(
278         address _totlePrimary
279     ) external onlyOwner {
280         authorizedPrimaries[_totlePrimary] = false;
281     }
282 }
283 
284 /// @title A contract which allows its owner to withdraw any ether which is contained inside
285 contract Withdrawable is Ownable {
286 
287     /// @notice Withdraw ether contained in this contract and send it back to owner
288     /// @dev onlyOwner modifier only allows the contract owner to run the code
289     /// @param _token The address of the token that the user wants to withdraw
290     /// @param _amount The amount of tokens that the caller wants to withdraw
291     /// @return bool value indicating whether the transfer was successful
292     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
293         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
294     }
295 
296     /// @notice Withdraw ether contained in this contract and send it back to owner
297     /// @dev onlyOwner modifier only allows the contract owner to run the code
298     /// @param _amount The amount of ether that the caller wants to withdraw
299     function withdrawETH(uint256 _amount) external onlyOwner {
300         owner.transfer(_amount);
301     }
302 }
303 
304 /**
305  * @title Pausable
306  * @dev Base contract which allows children to implement an emergency stop mechanism.
307  */
308 contract Pausable is Ownable {
309   event Paused();
310   event Unpaused();
311 
312   bool private _paused = false;
313 
314   /**
315    * @return true if the contract is paused, false otherwise.
316    */
317   function paused() public view returns (bool) {
318     return _paused;
319   }
320 
321   /**
322    * @dev Modifier to make a function callable only when the contract is not paused.
323    */
324   modifier whenNotPaused() {
325     require(!_paused, "Contract is paused.");
326     _;
327   }
328 
329   /**
330    * @dev Modifier to make a function callable only when the contract is paused.
331    */
332   modifier whenPaused() {
333     require(_paused, "Contract not paused.");
334     _;
335   }
336 
337   /**
338    * @dev called by the owner to pause, triggers stopped state
339    */
340   function pause() public onlyOwner whenNotPaused {
341     _paused = true;
342     emit Paused();
343   }
344 
345   /**
346    * @dev called by the owner to unpause, returns to normal state
347    */
348   function unpause() public onlyOwner whenPaused {
349     _paused = false;
350     emit Unpaused();
351   }
352 }
353 
354 contract SelectorProvider {
355     bytes4 constant getAmountToGiveSelector = bytes4(keccak256("getAmountToGive(bytes)"));
356     bytes4 constant staticExchangeChecksSelector = bytes4(keccak256("staticExchangeChecks(bytes)"));
357     bytes4 constant performBuyOrderSelector = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
358     bytes4 constant performSellOrderSelector = bytes4(keccak256("performSellOrder(bytes,uint256)"));
359 
360     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
361 }
362 
363 /// @title Interface for all exchange handler contracts
364 contract ExchangeHandler is SelectorProvider, TotleControl, Withdrawable, Pausable {
365 
366     /*
367     *   State Variables
368     */
369 
370     ErrorReporter public errorReporter;
371     /* Logger public logger; */
372     /*
373     *   Modifiers
374     */
375 
376     /// @notice Constructor
377     /// @dev Calls the constructor of the inherited TotleControl
378     /// @param totlePrimary the address of the totlePrimary contract
379     constructor(
380         address totlePrimary,
381         address _errorReporter
382         /* ,address _logger */
383     )
384         TotleControl(totlePrimary)
385         public
386     {
387         require(_errorReporter != address(0x0));
388         /* require(_logger != address(0x0)); */
389         errorReporter = ErrorReporter(_errorReporter);
390         /* logger = Logger(_logger); */
391     }
392 
393     /// @notice Gets the amount that Totle needs to give for this order
394     /// @param genericPayload the data for this order in a generic format
395     /// @return amountToGive amount taker needs to give in order to fill the order
396     function getAmountToGive(
397         bytes genericPayload
398     )
399         public
400         view
401         returns (uint256 amountToGive)
402     {
403         bool success;
404         bytes4 functionSelector = getSelector(this.getAmountToGive.selector);
405 
406         assembly {
407             let functionSelectorLength := 0x04
408             let functionSelectorOffset := 0x1C
409             let scratchSpace := 0x0
410             let wordLength := 0x20
411             let bytesLength := mload(genericPayload)
412             let totalLength := add(functionSelectorLength, bytesLength)
413             let startOfNewData := add(genericPayload, functionSelectorOffset)
414 
415             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
416             let functionSelectorCorrect := mload(scratchSpace)
417             mstore(genericPayload, functionSelectorCorrect)
418 
419             success := delegatecall(
420                             gas,
421                             address, // This address of the current contract
422                             startOfNewData, // Start data at the beginning of the functionSelector
423                             totalLength, // Total length of all data, including functionSelector
424                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
425                             wordLength // Length of return variable is one word
426                            )
427             amountToGive := mload(scratchSpace)
428             if eq(success, 0) { revert(0, 0) }
429         }
430     }
431 
432     /// @notice Perform exchange-specific checks on the given order
433     /// @dev this should be called to check for payload errors
434     /// @param genericPayload the data for this order in a generic format
435     /// @return checksPassed value representing pass or fail
436     function staticExchangeChecks(
437         bytes genericPayload
438     )
439         public
440         view
441         returns (bool checksPassed)
442     {
443         bool success;
444         bytes4 functionSelector = getSelector(this.staticExchangeChecks.selector);
445         assembly {
446             let functionSelectorLength := 0x04
447             let functionSelectorOffset := 0x1C
448             let scratchSpace := 0x0
449             let wordLength := 0x20
450             let bytesLength := mload(genericPayload)
451             let totalLength := add(functionSelectorLength, bytesLength)
452             let startOfNewData := add(genericPayload, functionSelectorOffset)
453 
454             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
455             let functionSelectorCorrect := mload(scratchSpace)
456             mstore(genericPayload, functionSelectorCorrect)
457 
458             success := delegatecall(
459                             gas,
460                             address, // This address of the current contract
461                             startOfNewData, // Start data at the beginning of the functionSelector
462                             totalLength, // Total length of all data, including functionSelector
463                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
464                             wordLength // Length of return variable is one word
465                            )
466             checksPassed := mload(scratchSpace)
467             if eq(success, 0) { revert(0, 0) }
468         }
469     }
470 
471     /// @notice Perform a buy order at the exchange
472     /// @param genericPayload the data for this order in a generic format
473     /// @param  amountToGiveForOrder amount that should be spent on this order
474     /// @return amountSpentOnOrder the amount that would be spent on the order
475     /// @return amountReceivedFromOrder the amount that was received from this order
476     function performBuyOrder(
477         bytes genericPayload,
478         uint256 amountToGiveForOrder
479     )
480         public
481         payable
482         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
483     {
484         bool success;
485         bytes4 functionSelector = getSelector(this.performBuyOrder.selector);
486         assembly {
487             let callDataOffset := 0x44
488             let functionSelectorOffset := 0x1C
489             let functionSelectorLength := 0x04
490             let scratchSpace := 0x0
491             let wordLength := 0x20
492             let startOfFreeMemory := mload(0x40)
493 
494             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
495 
496             let bytesLength := mload(startOfFreeMemory)
497             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
498 
499             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
500 
501             let functionSelectorCorrect := mload(scratchSpace)
502 
503             mstore(startOfFreeMemory, functionSelectorCorrect)
504 
505             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
506 
507             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
508 
509             success := delegatecall(
510                             gas,
511                             address, // This address of the current contract
512                             startOfNewData, // Start data at the beginning of the functionSelector
513                             totalLength, // Total length of all data, including functionSelector
514                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
515                             mul(wordLength, 0x02) // Length of return variables is two words
516                           )
517             amountSpentOnOrder := mload(scratchSpace)
518             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
519             if eq(success, 0) { revert(0, 0) }
520         }
521     }
522 
523     /// @notice Perform a sell order at the exchange
524     /// @param genericPayload the data for this order in a generic format
525     /// @param  amountToGiveForOrder amount that should be spent on this order
526     /// @return amountSpentOnOrder the amount that would be spent on the order
527     /// @return amountReceivedFromOrder the amount that was received from this order
528     function performSellOrder(
529         bytes genericPayload,
530         uint256 amountToGiveForOrder
531     )
532         public
533         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
534     {
535         bool success;
536         bytes4 functionSelector = getSelector(this.performSellOrder.selector);
537         assembly {
538             let callDataOffset := 0x44
539             let functionSelectorOffset := 0x1C
540             let functionSelectorLength := 0x04
541             let scratchSpace := 0x0
542             let wordLength := 0x20
543             let startOfFreeMemory := mload(0x40)
544 
545             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
546 
547             let bytesLength := mload(startOfFreeMemory)
548             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
549 
550             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
551 
552             let functionSelectorCorrect := mload(scratchSpace)
553 
554             mstore(startOfFreeMemory, functionSelectorCorrect)
555 
556             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
557 
558             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
559 
560             success := delegatecall(
561                             gas,
562                             address, // This address of the current contract
563                             startOfNewData, // Start data at the beginning of the functionSelector
564                             totalLength, // Total length of all data, including functionSelector
565                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
566                             mul(wordLength, 0x02) // Length of return variables is two words
567                           )
568             amountSpentOnOrder := mload(scratchSpace)
569             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
570             if eq(success, 0) { revert(0, 0) }
571         }
572     }
573 }
574 
575 /// @title OasisInterface
576 /// @notice Exchange contract interface
577 interface OasisInterface {
578     function buy(uint id, uint quantity) external returns (bool);
579     function getOffer(uint id) external constant returns (uint, ERC20, uint, ERC20);
580     function isActive(uint id) external constant returns (bool);
581 }
582 
583 interface WethInterface {
584     function deposit() external payable;
585     function withdraw(uint amount) external payable;
586 }
587 
588 /// @title OasisHandler
589 /// @notice Handles the all Oasis trades for the primary contract
590 contract OasisHandler is ExchangeHandler, AllowanceSetter {
591 
592     /*
593     *   State Variables
594     */
595 
596     OasisInterface public oasis;
597     WethInterface public weth;
598 
599     /*
600     *   Types
601     */
602 
603     struct OrderData {
604         uint256 offerId;
605         uint256 maxAmountToSpend;
606     }
607 
608     /// @notice Constructor
609     /// @dev Calls the constructor of the inherited ExchangeHandler
610     /// @param oasisAddress the address of the oasis exchange contract
611     /// @param wethAddress the address of the weth contract
612     /// @param totlePrimary the address of the totlePrimary contract
613     constructor(
614         address oasisAddress,
615         address wethAddress,
616         address totlePrimary,
617         address errorReporter
618         /* , address logger */
619     )
620         ExchangeHandler(totlePrimary, errorReporter/*,logger*/)
621         public
622     {
623         require(oasisAddress != address(0x0));
624         require(wethAddress != address(0x0));
625         oasis = OasisInterface(oasisAddress);
626         weth = WethInterface(wethAddress);
627     }
628 
629     /*
630     *   Public functions
631     */
632 
633     /// @notice Gets the amount that Totle needs to give for this order
634     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
635     /// should only be called from functions which are inherited from the ExchangeHandler
636     /// base contract.
637     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
638     /// @param data OrderData struct containing order values
639     /// @return amountToGive amount taker needs to give in order to fill the order
640     function getAmountToGive(
641         OrderData data
642     )
643         public
644         view
645         whenNotPaused
646         onlyTotle
647         returns (uint256 amountToGive)
648     {
649         uint256 availableGetAmount;
650         (availableGetAmount,,,) = oasis.getOffer(data.offerId);
651         /* logger.log("Oasis order available amount arg2: availableGetAmount", availableGetAmount); */
652         return availableGetAmount > data.maxAmountToSpend ? data.maxAmountToSpend : availableGetAmount;
653     }
654 
655     /// @notice Perform exchange-specific checks on the given order
656     /// @dev This function should be called to check for payload errors.
657     /// Uses the `onlyTotle` modifier with public visibility as this function
658     /// should only be called from functions which are inherited from the ExchangeHandler
659     /// base contract.
660     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
661     /// @param data OrderData struct containing order values
662     /// @return checksPassed value representing pass or fail
663     function staticExchangeChecks(
664         OrderData data
665     )
666         public
667         view
668         whenNotPaused
669         onlyTotle
670         returns (bool checksPassed)
671     {
672 
673         /* logger.log("Oasis static exchange checks"); */
674         // Check if the offer is active
675         if (!oasis.isActive(data.offerId)){
676             /* logger.log("Oasis offer is not active arg2: offerId", data.offerId); */
677             return false;
678         }
679 
680         // Check if the pay_gem or buy_gem is weth
681         address pay_gem;
682         address buy_gem;
683         (,pay_gem,,buy_gem) = oasis.getOffer(data.offerId);
684 
685         bool isBuyOrPayWeth = pay_gem == address(weth) || buy_gem == address(weth);
686         if (!isBuyOrPayWeth){
687             /* logger.log("Oasis offer's base pair is not WETH arg6: pay_gem, arg7: buy_gem", 0,0,0,0, pay_gem, buy_gem); */
688             return false;
689         }
690 
691         return true;
692     }
693 
694     /// @notice Perform a buy order at the exchange
695     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
696     /// should only be called from functions which are inherited from the ExchangeHandler
697     /// base contract.
698     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
699     /// @param data OrderData struct containing order values
700     /// @param amountToSpend amount that should be spent on this order
701     /// @return amountSpentOnOrder the amount that would be spent on the order
702     /// @return amountReceivedFromOrder the amount that was received from this order
703     function performBuyOrder(
704         OrderData data,
705         uint256 amountToSpend
706     )
707         public
708         payable
709         whenNotPaused
710         onlyTotle
711         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
712     {
713         /* logger.log("Performing Oasis buy order arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
714         if (msg.value != amountToSpend){
715 
716             /* logger.log("Ether sent is not equal to amount to spend arg2: amountToSpend, arg3: msg.value", amountToSpend, msg.value); */
717             msg.sender.transfer(msg.value);
718             return (0,0);
719         }
720 
721         //Convert ETH to Weth
722         weth.deposit.value(amountToSpend)();
723 
724         /* logger.log("Converted to WETH"); */
725 
726         //Approve oasis to move weth
727         approveAddress(address(oasis), address(weth));
728 
729         /* logger.log("Address approved"); */
730 
731         //Fetch offer data and validate buy gem is weth
732         uint256 maxPayGem;
733         address payGem;
734         uint256 maxBuyGem;
735         address buyGem;
736         (maxPayGem,payGem,maxBuyGem,buyGem) = oasis.getOffer(data.offerId);
737 
738         if (buyGem != address(weth)){
739             errorReporter.revertTx("buyGem != address(weth)");
740         }
741 
742         //Calculate quantity to buy
743         uint256 amountToBuy = SafeMath.div( SafeMath.mul(amountToSpend, maxPayGem), maxBuyGem);
744 
745         if (!oasis.buy(data.offerId, amountToBuy)){
746             errorReporter.revertTx("Oasis buy failed");
747         }
748 
749         //Calculate actual amounts spent and got
750         uint256 newMaxPayGem;
751         uint256 newMaxBuyGem;
752         (newMaxPayGem,,newMaxBuyGem,) = oasis.getOffer(data.offerId);
753 
754         amountReceivedFromOrder = maxPayGem - newMaxPayGem;
755         amountSpentOnOrder = maxBuyGem - newMaxBuyGem;
756 
757         //If we didn't spend all the eth, withdraw it from weth and send back to totlePrimary
758         if (amountSpentOnOrder < amountToSpend){
759           /* logger.log("Got some ether left, withdrawing arg2: amountSpentOnOrder, arg3: amountToSpend", amountSpentOnOrder, amountToSpend); */
760           weth.withdraw(amountToSpend - amountSpentOnOrder);
761           msg.sender.transfer(amountToSpend - amountSpentOnOrder);
762         }
763 
764         //Send the purchased tokens back to totlePrimary
765         if (!ERC20(payGem).transfer(msg.sender, amountReceivedFromOrder)){
766             errorReporter.revertTx("Unable to transfer bought tokens to totlePrimary");
767         }
768     }
769 
770     /// @notice Perform a sell order at the exchange
771     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
772     /// should only be called from functions which are inherited from the ExchangeHandler
773     /// base contract
774     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
775     /// @param data OrderData struct containing order values
776     /// @param amountToSpend amount that should be spent on this order
777     /// @return amountSpentOnOrder the amount that would be spent on the order
778     /// @return amountReceivedFromOrder the amount that was received from this order
779     function performSellOrder(
780         OrderData data,
781         uint256 amountToSpend
782     )
783         public
784         whenNotPaused
785         onlyTotle
786         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
787     {
788       //Fetch offer data and validate buy gem is weth
789       uint256 maxPayGem;
790       address payGem;
791       uint256 maxBuyGem;
792       address buyGem;
793       (maxPayGem,payGem,maxBuyGem,buyGem) = oasis.getOffer(data.offerId);
794 
795       /* logger.log("Performing Oasis sell order arg2: amountToSpend", amountToSpend); */
796 
797       if (payGem != address(weth)){
798           errorReporter.revertTx("payGem != address(weth)");
799       }
800 
801       //Approve oasis to move buy gem
802       approveAddress(address(oasis), address(buyGem));
803 
804       /* logger.log("Address approved"); */
805 
806       //Calculate quantity to buy
807       uint256 amountToBuy = SafeMath.div( SafeMath.mul(amountToSpend, maxPayGem), maxBuyGem);
808       if(amountToBuy == 0){
809           /* logger.log("Amount to buy is zero, amountToSpend was likely too small to get any. Did the previous order fill all but a small amount? arg2: amountToSpend", amountToSpend); */
810           ERC20(buyGem).transfer(msg.sender, amountToSpend);
811           return (0, 0);
812       }
813       if (!oasis.buy(data.offerId, amountToBuy)){
814           errorReporter.revertTx("Oasis buy failed");
815       }
816 
817       //Calculate actual amounts spent and got
818       uint256 newMaxPayGem;
819       uint256 newMaxBuyGem;
820       (newMaxPayGem,,newMaxBuyGem,) = oasis.getOffer(data.offerId);
821 
822       amountReceivedFromOrder = maxPayGem - newMaxPayGem;
823       amountSpentOnOrder = maxBuyGem - newMaxBuyGem;
824 
825       //If we didn't spend all the tokens, withdraw it from weth and send back to totlePrimary
826       if (amountSpentOnOrder < amountToSpend){
827         /* logger.log("Got some tokens left, withdrawing arg2: amountSpentOnOrder, arg3: amountToSpend", amountSpentOnOrder, amountToSpend); */
828         ERC20(buyGem).transfer(msg.sender, amountToSpend - amountSpentOnOrder);
829       }
830 
831       //Send the purchased tokens back to totlePrimary
832       weth.withdraw(amountReceivedFromOrder);
833       msg.sender.transfer(amountReceivedFromOrder);
834     }
835 
836     /// @notice Changes the current contract address set as WETH
837     /// @param wethAddress the address of the new WETH contract
838     function setWeth(
839         address wethAddress
840     )
841         public
842         onlyOwner
843     {
844         require(wethAddress != address(0x0));
845         weth = WethInterface(wethAddress);
846     }
847 
848     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
849         if (genericSelector == getAmountToGiveSelector) {
850             return bytes4(keccak256("getAmountToGive((uint256,uint256))"));
851         } else if (genericSelector == staticExchangeChecksSelector) {
852             return bytes4(keccak256("staticExchangeChecks((uint256,uint256))"));
853         } else if (genericSelector == performBuyOrderSelector) {
854             return bytes4(keccak256("performBuyOrder((uint256,uint256),uint256)"));
855         } else if (genericSelector == performSellOrderSelector) {
856             return bytes4(keccak256("performSellOrder((uint256,uint256),uint256)"));
857         } else {
858             return bytes4(0x0);
859         }
860     }
861 
862     /*
863     *   Payable fallback function
864     */
865 
866     /// @notice payable fallback to allow handler or exchange contracts to return ether
867     /// @dev only accounts containing code (ie. contracts) can send ether to this contract
868     function() public payable whenNotPaused {
869         // Check in here that the sender is a contract! (to stop accidents)
870         uint256 size;
871         address sender = msg.sender;
872         assembly {
873             size := extcodesize(sender)
874         }
875         if (size == 0) {
876             errorReporter.revertTx("EOA cannot send ether to primary fallback");
877         }
878     }
879 }