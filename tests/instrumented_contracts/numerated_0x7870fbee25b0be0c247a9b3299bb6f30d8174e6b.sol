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
575 /// @title BancorConverter
576 /// @notice Bancor converter contract interface
577 interface BancorConverter {
578     function quickConvert(address[] _path, uint256 _amount, uint256 _minReturn) external payable returns (uint256);
579     function registry() external view returns (IContractRegistry);
580     function BANCOR_GAS_PRICE_LIMIT() external view returns (bytes32);
581     function BANCOR_NETWORK() external view returns (bytes32);
582 }
583 
584 /// @title IContractRegistry
585 /// @notice Bancor contract registry interface
586 interface IContractRegistry {
587     function getAddress(bytes32 _contractName) external view returns (address);
588 }
589 
590 /// @title IBancorGasPriceLimit
591 /// @notice Bancor gas price limit contract interface
592 interface IBancorGasPriceLimit {
593     function gasPrice() external view returns (uint256);
594 }
595 
596 /// @title BancorNetwork
597 /// @notice Bancor Network contract interface
598 interface BancorNetwork {
599     function getReturnByPath(address[] _path, uint256 _amount) external view returns (uint256) ;
600 }
601 
602 /// @title Interface for all exchange handler contracts
603 /// @notice Handles the all Bancor trades for the primary contract
604 contract BancorHandler is ExchangeHandler, AllowanceSetter {
605 
606     /*
607     *   Types
608     */
609 
610     struct OrderData {
611         address converterAddress;
612         address[11] conversionPath;
613         address destinationToken;
614         uint256 minReturn;
615         uint256 amountToGive;
616         uint256 expectedReturn;
617     }
618 
619     /// @notice Constructor
620     /// @param totlePrimary the address of the totlePrimary contract
621     /// @param errorReporter the address of the error reporter contract
622     constructor(
623         address totlePrimary,
624         address errorReporter
625         /* ,address logger */
626     )
627         ExchangeHandler(totlePrimary, errorReporter/*, logger*/)
628         public
629     {}
630 
631     /*
632     *   Public functions
633     */
634 
635     /// @notice Gets the amount that Totle needs to give for this order
636     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
637     /// should only be called from functions which are inherited from the ExchangeHandler
638     /// base contract.
639     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
640     /// @param data OrderData struct containing order values
641     /// @return amountToGive amount taker needs to give in order to fill the order
642     function getAmountToGive(
643         OrderData data
644     )
645         public
646         view
647         whenNotPaused
648         onlyTotle
649         returns (uint256 amountToGive)
650     {
651         amountToGive = data.amountToGive;
652     }
653 
654     /// @notice Perform exchange-specific checks on the given order
655     /// @dev This function should be called to check for payload errors.
656     /// Uses the `onlyTotle` modifier with public visibility as this function
657     /// should only be called from functions which are inherited from the ExchangeHandler
658     /// base contract.
659     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
660     /// @param data OrderData struct containing order values
661     /// @return checksPassed value representing pass or fail
662     function staticExchangeChecks(
663         OrderData data
664     )
665         public
666         view
667         whenNotPaused
668         onlyTotle
669         returns (bool checksPassed)
670     {
671         BancorConverter converter = BancorConverter(data.converterAddress);
672         IBancorGasPriceLimit gasPriceLimitContract = IBancorGasPriceLimit(
673             converter.registry().getAddress(converter.BANCOR_GAS_PRICE_LIMIT())
674         );
675 
676         uint256 gasPriceLimit = gasPriceLimitContract.gasPrice();
677         checksPassed = tx.gasprice <= gasPriceLimit;
678 
679         /* logger.log(
680             "Checking gas price arg2: tx.gasprice, arg3: gasPriceLimit",
681             tx.gasprice,
682             gasPriceLimit
683         ); */
684     }
685 
686     /// @notice Perform a buy order at the exchange
687     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
688     /// should only be called from functions which are inherited from the ExchangeHandler
689     /// base contract.
690     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
691     /// @param data OrderData struct containing order values
692     /// @param amountToGiveForOrder amount that should be spent on this order
693     /// @return amountSpentOnOrder the amount that would be spent on the order
694     /// @return amountReceivedFromOrder the amount that was received from this order
695     function performBuyOrder(
696         OrderData data,
697         uint256 amountToGiveForOrder
698     )
699         public
700         payable
701         whenNotPaused
702         onlyTotle
703         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
704     {
705         amountSpentOnOrder = amountToGiveForOrder;
706         amountReceivedFromOrder = BancorConverter(data.converterAddress).quickConvert.value(msg.value)(
707             trimAddressArray(data.conversionPath),
708             amountToGiveForOrder,
709             data.minReturn
710         );
711 
712         /* logger.log(
713             "Performed Bancor buy arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder",
714             amountSpentOnOrder,
715             amountReceivedFromOrder
716         ); */
717 
718         if (!ERC20SafeTransfer.safeTransfer(data.destinationToken, msg.sender, amountReceivedFromOrder)){
719             errorReporter.revertTx("Failed to transfer tokens to totle primary");
720         }
721     }
722 
723     /// @notice Perform a sell order at the exchange
724     /// @dev Uses the `onlyTotle` modifier with public visibility as this function
725     /// should only be called from functions which are inherited from the ExchangeHandler
726     /// base contract
727     /// Uses `whenNotPaused` modifier to revert transactions when contract is "paused".
728     /// @param data OrderData struct containing order values
729     /// @param amountToGiveForOrder amount that should be spent on this order
730     /// @return amountSpentOnOrder the amount that would be spent on the order
731     /// @return amountReceivedFromOrder the amount that was received from this order
732     function performSellOrder(
733         OrderData data,
734         uint256 amountToGiveForOrder
735     )
736         public
737         whenNotPaused
738         onlyTotle
739         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
740     {
741         approveAddress(data.converterAddress, data.conversionPath[0]);
742 
743         amountSpentOnOrder = amountToGiveForOrder;
744         amountReceivedFromOrder = BancorConverter(data.converterAddress).quickConvert(
745             trimAddressArray(data.conversionPath),
746             amountToGiveForOrder,
747             data.minReturn
748         );
749 
750         /* logger.log(
751             "Performed Bancor sell arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder",
752             amountSpentOnOrder,
753             amountReceivedFromOrder
754         ); */
755 
756         msg.sender.transfer(amountReceivedFromOrder);
757     }
758 
759     /// @notice Calculate the result of ((numerator * target) / denominator)
760     /// @param numerator the numerator in the equation
761     /// @param denominator the denominator in the equation
762     /// @param target the target for the equations
763     /// @return partialAmount the resultant value
764     function getPartialAmount(
765         uint256 numerator,
766         uint256 denominator,
767         uint256 target
768     )
769         internal
770         pure
771         returns (uint256)
772     {
773         return SafeMath.div(SafeMath.mul(numerator, target), denominator);
774     }
775 
776     /// @notice Takes the static array, trims the excess and returns a dynamic array
777     /// @param addresses the static array
778     /// @return address[] the dynamic array
779     function trimAddressArray(address[11] addresses) internal pure returns (address[]) {
780         uint256 length = 0;
781         for (uint256 index = 0; index < 11; index++){
782             if (addresses[index] == 0x0){
783                 continue;
784             }
785             length++;
786         }
787         address[] memory trimmedArray = new address[](length);
788         for (index = 0; index < length; index++){
789             trimmedArray[index] = addresses[index];
790         }
791         return trimmedArray;
792     }
793 
794     function getSelector(bytes4 genericSelector) public pure returns (bytes4) {
795         if (genericSelector == getAmountToGiveSelector) {
796             return bytes4(keccak256("getAmountToGive((address,address[11],address,uint256,uint256,uint256))"));
797         } else if (genericSelector == staticExchangeChecksSelector) {
798             return bytes4(keccak256("staticExchangeChecks((address,address[11],address,uint256,uint256,uint256))"));
799         } else if (genericSelector == performBuyOrderSelector) {
800             return bytes4(keccak256("performBuyOrder((address,address[11],address,uint256,uint256,uint256),uint256)"));
801         } else if (genericSelector == performSellOrderSelector) {
802             return bytes4(keccak256("performSellOrder((address,address[11],address,uint256,uint256,uint256),uint256)"));
803         } else {
804             return bytes4(0x0);
805         }
806     }
807 
808     /*
809     *   Payable fallback function
810     */
811 
812     /// @notice payable fallback to allow handler or exchange contracts to return ether
813     /// @dev only accounts containing code (ie. contracts) can send ether to this contract
814     function() public payable whenNotPaused {
815         // Check in here that the sender is a contract! (to stop accidents)
816         uint256 size;
817         address sender = msg.sender;
818         assembly {
819             size := extcodesize(sender)
820         }
821         if (size == 0) {
822             errorReporter.revertTx("EOA cannot send ether to primary fallback");
823         }
824     }
825 }