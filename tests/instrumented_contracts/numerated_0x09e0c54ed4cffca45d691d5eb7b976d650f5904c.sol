1 pragma solidity 0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    * @notice Renouncing to ownership will leave the contract without an owner.
33    * It will not be possible to call the functions with the `onlyOwner`
34    * modifier anymore.
35    */
36   function renounceOwnership() public onlyOwner {
37     emit OwnershipRenounced(owner);
38     owner = address(0);
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     _transferOwnership(_newOwner);
47   }
48 
49   /**
50    * @dev Transfers control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function _transferOwnership(address _newOwner) internal {
54     require(_newOwner != address(0));
55     emit OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 }
59 
60 contract Pausable is Ownable {
61   event Pause();
62   event Unpause();
63 
64   bool public paused = false;
65 
66 
67   /**
68    * @dev Modifier to make a function callable only when the contract is not paused.
69    */
70   modifier whenNotPaused() {
71     require(!paused);
72     _;
73   }
74 
75   /**
76    * @dev Modifier to make a function callable only when the contract is paused.
77    */
78   modifier whenPaused() {
79     require(paused);
80     _;
81   }
82 
83   /**
84    * @dev called by the owner to pause, triggers stopped state
85    */
86   function pause() public onlyOwner whenNotPaused {
87     paused = true;
88     emit Pause();
89   }
90 
91   /**
92    * @dev called by the owner to unpause, returns to normal state
93    */
94   function unpause() public onlyOwner whenPaused {
95     paused = false;
96     emit Unpause();
97   }
98 }
99 
100 
101 /**
102  * @title SchedulerInterface
103  * @dev The base contract that the higher contracts: BaseScheduler, BlockScheduler and TimestampScheduler all inherit from.
104  */
105 contract SchedulerInterface {
106     function schedule(address _toAddress, bytes _callData, uint[8] _uintArgs)
107         public payable returns (address);
108     function computeEndowment(uint _bounty, uint _fee, uint _callGas, uint _callValue, uint _gasPrice)
109         public view returns (uint);
110 }
111 
112 contract TransactionRequestInterface {
113     
114     // Primary actions
115     function execute() public returns (bool);
116     function cancel() public returns (bool);
117     function claim() public payable returns (bool);
118 
119     // Proxy function
120     function proxy(address recipient, bytes callData) public payable returns (bool);
121 
122     // Data accessors
123     function requestData() public view returns (address[6], bool[3], uint[15], uint8[1]);
124     function callData() public view returns (bytes);
125 
126     // Pull mechanisms for payments.
127     function refundClaimDeposit() public returns (bool);
128     function sendFee() public returns (bool);
129     function sendBounty() public returns (bool);
130     function sendOwnerEther() public returns (bool);
131     function sendOwnerEther(address recipient) public returns (bool);
132 }
133 
134 contract TransactionRequestCore is TransactionRequestInterface {
135     using RequestLib for RequestLib.Request;
136     using RequestScheduleLib for RequestScheduleLib.ExecutionWindow;
137 
138     RequestLib.Request txnRequest;
139     bool private initialized = false;
140 
141     /*
142      *  addressArgs[0] - meta.createdBy
143      *  addressArgs[1] - meta.owner
144      *  addressArgs[2] - paymentData.feeRecipient
145      *  addressArgs[3] - txnData.toAddress
146      *
147      *  uintArgs[0]  - paymentData.fee
148      *  uintArgs[1]  - paymentData.bounty
149      *  uintArgs[2]  - schedule.claimWindowSize
150      *  uintArgs[3]  - schedule.freezePeriod
151      *  uintArgs[4]  - schedule.reservedWindowSize
152      *  uintArgs[5]  - schedule.temporalUnit
153      *  uintArgs[6]  - schedule.windowSize
154      *  uintArgs[7]  - schedule.windowStart
155      *  uintArgs[8]  - txnData.callGas
156      *  uintArgs[9]  - txnData.callValue
157      *  uintArgs[10] - txnData.gasPrice
158      *  uintArgs[11] - claimData.requiredDeposit
159      */
160     function initialize(
161         address[4]  addressArgs,
162         uint[12]    uintArgs,
163         bytes       callData
164     )
165         public payable
166     {
167         require(!initialized);
168 
169         txnRequest.initialize(addressArgs, uintArgs, callData);
170         initialized = true;
171     }
172 
173     /*
174      *  Allow receiving ether.  This is needed if there is a large increase in
175      *  network gas prices.
176      */
177     function() public payable {}
178 
179     /*
180      *  Actions
181      */
182     function execute() public returns (bool) {
183         return txnRequest.execute();
184     }
185 
186     function cancel() public returns (bool) {
187         return txnRequest.cancel();
188     }
189 
190     function claim() public payable returns (bool) {
191         return txnRequest.claim();
192     }
193 
194     /*
195      *  Data accessor functions.
196      */
197 
198     // Declaring this function `view`, although it creates a compiler warning, is
199     // necessary to return values from it.
200     function requestData()
201         public view returns (address[6], bool[3], uint[15], uint8[1])
202     {
203         return txnRequest.serialize();
204     }
205 
206     function callData()
207         public view returns (bytes data)
208     {
209         data = txnRequest.txnData.callData;
210     }
211 
212     /**
213      * @dev Proxy a call from this contract to another contract.
214      * This function is only callable by the scheduler and can only
215      * be called after the execution window ends. One purpose is to
216      * provide a way to transfer assets held by this contract somewhere else.
217      * For example, if this request was used to buy tokens during an ICO,
218      * it would become the owner of the tokens and this function would need
219      * to be called with the encoded data to the token contract to transfer
220      * the assets somewhere else. */
221     function proxy(address _to, bytes _data)
222         public payable returns (bool success)
223     {
224         require(txnRequest.meta.owner == msg.sender && txnRequest.schedule.isAfterWindow());
225         
226         /* solium-disable-next-line */
227         return _to.call.value(msg.value)(_data);
228     }
229 
230     /*
231      *  Pull based payment functions.
232      */
233     function refundClaimDeposit() public returns (bool) {
234         txnRequest.refundClaimDeposit();
235     }
236 
237     function sendFee() public returns (bool) {
238         return txnRequest.sendFee();
239     }
240 
241     function sendBounty() public returns (bool) {
242         return txnRequest.sendBounty();
243     }
244 
245     function sendOwnerEther() public returns (bool) {
246         return txnRequest.sendOwnerEther();
247     }
248 
249     function sendOwnerEther(address recipient) public returns (bool) {
250         return txnRequest.sendOwnerEther(recipient);
251     }
252 
253     /** Event duplication from RequestLib.sol. This is so
254      *  that these events are available on the contracts ABI.*/
255     event Aborted(uint8 reason);
256     event Cancelled(uint rewardPayment, uint measuredGasConsumption);
257     event Claimed();
258     event Executed(uint bounty, uint fee, uint measuredGasConsumption);
259 }
260 
261 contract RequestFactoryInterface {
262     event RequestCreated(address request, address indexed owner, int indexed bucket, uint[12] params);
263 
264     function createRequest(address[3] addressArgs, uint[12] uintArgs, bytes callData) public payable returns (address);
265     function createValidatedRequest(address[3] addressArgs, uint[12] uintArgs, bytes callData) public payable returns (address);
266     function validateRequestParams(address[3] addressArgs, uint[12] uintArgs, uint endowment) public view returns (bool[6]);
267     function isKnownRequest(address _address) public view returns (bool);
268 }
269 
270 contract TransactionRecorder {
271     address owner;
272 
273     bool public wasCalled;
274     uint public lastCallValue;
275     address public lastCaller;
276     bytes public lastCallData = "";
277     uint public lastCallGas;
278 
279     function TransactionRecorder()  public {
280         owner = msg.sender;
281     }
282 
283     function() payable  public {
284         lastCallGas = gasleft();
285         lastCallData = msg.data;
286         lastCaller = msg.sender;
287         lastCallValue = msg.value;
288         wasCalled = true;
289     }
290 
291     function __reset__() public {
292         lastCallGas = 0;
293         lastCallData = "";
294         lastCaller = 0x0;
295         lastCallValue = 0;
296         wasCalled = false;
297     }
298 
299     function kill() public {
300         require(msg.sender == owner);
301         selfdestruct(owner);
302     }
303 }
304 
305 contract Proxy {
306     SchedulerInterface public scheduler;
307     address public receipient; 
308     address public scheduledTransaction;
309     address public owner;
310 
311     function Proxy(address _scheduler, address _receipient, uint _payout, uint _gasPrice, uint _delay) public payable {
312         scheduler = SchedulerInterface(_scheduler);
313         receipient = _receipient;
314         owner = msg.sender;
315 
316         scheduledTransaction = scheduler.schedule.value(msg.value)(
317             this,              // toAddress
318             "",                     // callData
319             [
320                 2000000,            // The amount of gas to be sent with the transaction.
321                 _payout,                  // The amount of wei to be sent.
322                 255,                // The size of the execution window.
323                 block.number + _delay,        // The start of the execution window.
324                 _gasPrice,    // The gasprice for the transaction
325                 12345 wei,          // The fee included in the transaction.
326                 224455 wei,         // The bounty that awards the executor of the transaction.
327                 20000 wei           // The required amount of wei the claimer must send as deposit.
328             ]
329         );
330     }
331 
332     function () public payable {
333         if (msg.value > 0) {
334             receipient.transfer(msg.value);
335         }
336     }
337 
338     function sendOwnerEther(address _receipient) public {
339         if (msg.sender == owner && _receipient != 0x0) {
340             TransactionRequestInterface(scheduledTransaction).sendOwnerEther(_receipient);
341         }   
342     }
343 }
344 
345 /// Super simple token contract that moves funds into the owner account on creation and
346 /// only exposes an API to be used for `test/proxy.js`
347 contract SimpleToken {
348 
349     address public owner;
350 
351     mapping(address => uint) balances;
352 
353     function SimpleToken (uint _initialSupply) public {
354         owner = msg.sender;
355         balances[owner] = _initialSupply;
356     }
357 
358     function transfer (address _to, uint _amount)
359         public returns (bool success)
360     {
361         require(balances[msg.sender] > _amount);
362         balances[msg.sender] -= _amount;
363         balances[_to] += _amount;
364         success = true;
365     }
366 
367     uint public constant rate = 30;
368 
369     function buyTokens()
370         public payable returns (bool success)
371     {
372         require(msg.value > 0);
373         balances[msg.sender] += msg.value * rate;
374         success = true;
375     }
376 
377     function balanceOf (address _who)
378         public view returns (uint balance)
379     {
380         balance = balances[_who];
381     }
382 }
383 
384 /**
385  * @title SafeMath
386  * @dev Math operations with safety checks that throw on error
387  */
388 library SafeMath {
389     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
390         uint256 c = a * b;
391         require(a == 0 || c / a == b);
392         return c;
393   }
394 
395   function div(uint256 a, uint256 b) internal pure returns (uint256) {
396   // require(b > 0); // Solidity automatically throws when dividing by 0
397   uint256 c = a / b;
398   // require(a == b * c + a % b); // There is no case in which this doesn't hold
399   return c;
400   }
401 
402   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
403   require(b <= a);
404   return a - b;
405   }
406 
407   function add(uint256 a, uint256 b) internal pure returns (uint256) {
408   uint256 c = a + b;
409   require(c >= a);
410   return c;
411   }
412 }
413 
414 /**
415  * @title BaseScheduler
416  * @dev The foundational contract which provides the API for scheduling future transactions on the Alarm Client.
417  */
418 contract BaseScheduler is SchedulerInterface {
419     // The RequestFactory which produces requests for this scheduler.
420     address public factoryAddress;
421 
422     // The TemporalUnit (Block or Timestamp) for this scheduler.
423     RequestScheduleLib.TemporalUnit public temporalUnit;
424 
425     // The address which will be sent the fee payments.
426     address public feeRecipient;
427 
428     /*
429      * @dev Fallback function to be able to receive ether. This can occur
430      *  legitimately when scheduling fails due to a validation error.
431      */
432     function() public payable {}
433 
434     /// Event that bubbles up the address of new requests made with this scheduler.
435     event NewRequest(address request);
436 
437     /**
438      * @dev Schedules a new TransactionRequest using the 'full' parameters.
439      * @param _toAddress The address destination of the transaction.
440      * @param _callData The bytecode that will be included with the transaction.
441      * @param _uintArgs [0] The callGas of the transaction.
442      * @param _uintArgs [1] The value of ether to be sent with the transaction.
443      * @param _uintArgs [2] The size of the execution window of the transaction.
444      * @param _uintArgs [3] The (block or timestamp) of when the execution window starts.
445      * @param _uintArgs [4] The gasPrice which will be used to execute this transaction.
446      * @param _uintArgs [5] The fee attached to this transaction.
447      * @param _uintArgs [6] The bounty attached to this transaction.
448      * @param _uintArgs [7] The deposit required to claim this transaction.
449      * @return The address of the new TransactionRequest.   
450      */ 
451     function schedule (
452         address   _toAddress,
453         bytes     _callData,
454         uint[8]   _uintArgs
455     )
456         public payable returns (address newRequest)
457     {
458         RequestFactoryInterface factory = RequestFactoryInterface(factoryAddress);
459 
460         uint endowment = computeEndowment(
461             _uintArgs[6], //bounty
462             _uintArgs[5], //fee
463             _uintArgs[0], //callGas
464             _uintArgs[1], //callValue
465             _uintArgs[4]  //gasPrice
466         );
467 
468         require(msg.value >= endowment);
469 
470         if (temporalUnit == RequestScheduleLib.TemporalUnit.Blocks) {
471             newRequest = factory.createValidatedRequest.value(msg.value)(
472                 [
473                     msg.sender,                 // meta.owner
474                     feeRecipient,               // paymentData.feeRecipient
475                     _toAddress                  // txnData.toAddress
476                 ],
477                 [
478                     _uintArgs[5],               // paymentData.fee
479                     _uintArgs[6],               // paymentData.bounty
480                     255,                        // scheduler.claimWindowSize
481                     10,                         // scheduler.freezePeriod
482                     16,                         // scheduler.reservedWindowSize
483                     uint(temporalUnit),         // scheduler.temporalUnit (1: block, 2: timestamp)
484                     _uintArgs[2],               // scheduler.windowSize
485                     _uintArgs[3],               // scheduler.windowStart
486                     _uintArgs[0],               // txnData.callGas
487                     _uintArgs[1],               // txnData.callValue
488                     _uintArgs[4],               // txnData.gasPrice
489                     _uintArgs[7]                // claimData.requiredDeposit
490                 ],
491                 _callData
492             );
493         } else if (temporalUnit == RequestScheduleLib.TemporalUnit.Timestamp) {
494             newRequest = factory.createValidatedRequest.value(msg.value)(
495                 [
496                     msg.sender,                 // meta.owner
497                     feeRecipient,               // paymentData.feeRecipient
498                     _toAddress                  // txnData.toAddress
499                 ],
500                 [
501                     _uintArgs[5],               // paymentData.fee
502                     _uintArgs[6],               // paymentData.bounty
503                     60 minutes,                 // scheduler.claimWindowSize
504                     3 minutes,                  // scheduler.freezePeriod
505                     5 minutes,                  // scheduler.reservedWindowSize
506                     uint(temporalUnit),         // scheduler.temporalUnit (1: block, 2: timestamp)
507                     _uintArgs[2],               // scheduler.windowSize
508                     _uintArgs[3],               // scheduler.windowStart
509                     _uintArgs[0],               // txnData.callGas
510                     _uintArgs[1],               // txnData.callValue
511                     _uintArgs[4],               // txnData.gasPrice
512                     _uintArgs[7]                // claimData.requiredDeposit
513                 ],
514                 _callData
515             );
516         } else {
517             // unsupported temporal unit
518             revert();
519         }
520 
521         require(newRequest != 0x0);
522         emit NewRequest(newRequest);
523         return newRequest;
524     }
525 
526     function computeEndowment(
527         uint _bounty,
528         uint _fee,
529         uint _callGas,
530         uint _callValue,
531         uint _gasPrice
532     )
533         public view returns (uint)
534     {
535         return PaymentLib.computeEndowment(
536             _bounty,
537             _fee,
538             _callGas,
539             _callValue,
540             _gasPrice,
541             RequestLib.getEXECUTION_GAS_OVERHEAD()
542         );
543     }
544 }
545 
546 /**
547  * @title BlockScheduler
548  * @dev Top-level contract that exposes the API to the Ethereum Alarm Clock service and passes in blocks as temporal unit.
549  */
550 contract BlockScheduler is BaseScheduler {
551 
552     /**
553      * @dev Constructor
554      * @param _factoryAddress Address of the RequestFactory which creates requests for this scheduler.
555      */
556     constructor(address _factoryAddress, address _feeRecipient) public {
557         require(_factoryAddress != 0x0);
558 
559         // Default temporal unit is block number.
560         temporalUnit = RequestScheduleLib.TemporalUnit.Blocks;
561 
562         // Sets the factoryAddress variable found in BaseScheduler contract.
563         factoryAddress = _factoryAddress;
564 
565         // Sets the fee recipient for these schedulers.
566         feeRecipient = _feeRecipient;
567     }
568 }
569 
570 /**
571  * @title TimestampScheduler
572  * @dev Top-level contract that exposes the API to the Ethereum Alarm Clock service and passes in timestamp as temporal unit.
573  */
574 contract TimestampScheduler is BaseScheduler {
575 
576     /**
577      * @dev Constructor
578      * @param _factoryAddress Address of the RequestFactory which creates requests for this scheduler.
579      */
580     constructor(address _factoryAddress, address _feeRecipient) public {
581         require(_factoryAddress != 0x0);
582 
583         // Default temporal unit is timestamp.
584         temporalUnit = RequestScheduleLib.TemporalUnit.Timestamp;
585 
586         // Sets the factoryAddress variable found in BaseScheduler contract.
587         factoryAddress = _factoryAddress;
588 
589         // Sets the fee recipient for these schedulers.
590         feeRecipient = _feeRecipient;
591     }
592 }
593 
594 /// Truffle-specific contract (Not a part of the EAC)
595 
596 contract Migrations {
597     address public owner;
598 
599     uint public last_completed_migration;
600 
601     modifier restricted() {
602         if (msg.sender == owner) {
603             _;
604         }
605     }
606 
607     function Migrations()  public {
608         owner = msg.sender;
609     }
610 
611     function setCompleted(uint completed) restricted  public {
612         last_completed_migration = completed;
613     }
614 
615     function upgrade(address new_address) restricted  public {
616         Migrations upgraded = Migrations(new_address);
617         upgraded.setCompleted(last_completed_migration);
618     }
619 }
620 
621 /**
622  * @title ExecutionLib
623  * @dev Contains the logic for executing a scheduled transaction.
624  */
625 library ExecutionLib {
626 
627     struct ExecutionData {
628         address toAddress;                  /// The destination of the transaction.
629         bytes callData;                     /// The bytecode that will be sent with the transaction.
630         uint callValue;                     /// The wei value that will be sent with the transaction.
631         uint callGas;                       /// The amount of gas to be sent with the transaction.
632         uint gasPrice;                      /// The gasPrice that should be set for the transaction.
633     }
634 
635     /**
636      * @dev Send the transaction according to the parameters outlined in ExecutionData.
637      * @param self The ExecutionData object.
638      */
639     function sendTransaction(ExecutionData storage self)
640         internal returns (bool)
641     {
642         /// Should never actually reach this require check, but here in case.
643         require(self.gasPrice <= tx.gasprice);
644         /* solium-disable security/no-call-value */
645         return self.toAddress.call.value(self.callValue).gas(self.callGas)(self.callData);
646     }
647 
648 
649     /**
650      * Returns the maximum possible gas consumption that a transaction request
651      * may consume.  The EXTRA_GAS value represents the overhead involved in
652      * request execution.
653      */
654     function CALL_GAS_CEILING(uint EXTRA_GAS) 
655         internal view returns (uint)
656     {
657         return block.gaslimit - EXTRA_GAS;
658     }
659 
660     /*
661      * @dev Validation: ensure that the callGas is not above the total possible gas
662      * for a call.
663      */
664     function validateCallGas(uint callGas, uint EXTRA_GAS)
665         internal view returns (bool)
666     {
667         return callGas < CALL_GAS_CEILING(EXTRA_GAS);
668     }
669 
670     /*
671      * @dev Validation: ensure that the toAddress is not set to the empty address.
672      */
673     function validateToAddress(address toAddress)
674         internal pure returns (bool)
675     {
676         return toAddress != 0x0;
677     }
678 }
679 
680 library MathLib {
681     uint constant INT_MAX = 57896044618658097711785492504343953926634992332820282019728792003956564819967;  // 2**255 - 1
682     /*
683      * Subtracts b from a in a manner such that zero is returned when an
684      * underflow condition is met.
685      */
686     // function flooredSub(uint a, uint b) returns (uint) {
687     //     if (b >= a) {
688     //         return 0;
689     //     } else {
690     //         return a - b;
691     //     }
692     // }
693 
694     // /*
695     //  * Adds b to a in a manner that throws an exception when overflow
696     //  * conditions are met.
697     //  */
698     // function safeAdd(uint a, uint b) returns (uint) {
699     //     if (a + b >= a) {
700     //         return a + b;
701     //     } else {
702     //         throw;
703     //     }
704     // }
705 
706     // /*
707     //  * Multiplies a by b in a manner that throws an exception when overflow
708     //  * conditions are met.
709     //  */
710     // function safeMultiply(uint a, uint b) returns (uint) {
711     //     var result = a * b;
712     //     if (b == 0 || result / b == a) {
713     //         return a * b;
714     //     } else {
715     //         throw;
716     //     }
717     // }
718 
719     /*
720      * Return the larger of a or b.  Returns a if a == b.
721      */
722     function max(uint a, uint b) 
723         public pure returns (uint)
724     {
725         if (a >= b) {
726             return a;
727         } else {
728             return b;
729         }
730     }
731 
732     /*
733      * Return the larger of a or b.  Returns a if a == b.
734      */
735     function min(uint a, uint b) 
736         public pure returns (uint)
737     {
738         if (a <= b) {
739             return a;
740         } else {
741             return b;
742         }
743     }
744 
745     /*
746      * Returns a represented as a signed integer in a manner that throw an
747      * exception if casting to signed integer would result in a negative
748      * number.
749      */
750     function safeCastSigned(uint a) 
751         public pure returns (int)
752     {
753         assert(a <= INT_MAX);
754         return int(a);
755     }
756     
757 }
758 
759 /**
760  * @title RequestMetaLib
761  * @dev Small library holding all the metadata about a TransactionRequest.
762  */
763 library RequestMetaLib {
764 
765     struct RequestMeta {
766         address owner;              /// The address that created this request.
767 
768         address createdBy;          /// The address of the RequestFactory which created this request.
769 
770         bool isCancelled;           /// Was the TransactionRequest cancelled?
771         
772         bool wasCalled;             /// Was the TransactionRequest called?
773 
774         bool wasSuccessful;         /// Was the return value from the TransactionRequest execution successful?
775     }
776 
777 }
778 
779 library RequestLib {
780     using ClaimLib for ClaimLib.ClaimData;
781     using ExecutionLib for ExecutionLib.ExecutionData;
782     using PaymentLib for PaymentLib.PaymentData;
783     using RequestMetaLib for RequestMetaLib.RequestMeta;
784     using RequestScheduleLib for RequestScheduleLib.ExecutionWindow;
785     using SafeMath for uint;
786 
787     struct Request {
788         ExecutionLib.ExecutionData txnData;
789         RequestMetaLib.RequestMeta meta;
790         PaymentLib.PaymentData paymentData;
791         ClaimLib.ClaimData claimData;
792         RequestScheduleLib.ExecutionWindow schedule;
793     }
794 
795     enum AbortReason {
796         WasCancelled,       //0
797         AlreadyCalled,      //1
798         BeforeCallWindow,   //2
799         AfterCallWindow,    //3
800         ReservedForClaimer, //4
801         InsufficientGas,    //5
802         TooLowGasPrice    //6
803     }
804 
805     event Aborted(uint8 reason);
806     event Cancelled(uint rewardPayment, uint measuredGasConsumption);
807     event Claimed();
808     event Executed(uint bounty, uint fee, uint measuredGasConsumption);
809 
810     /**
811      * @dev Validate the initialization parameters of a transaction request.
812      */
813     function validate(
814         address[4]  _addressArgs,
815         uint[12]    _uintArgs,
816         uint        _endowment
817     ) 
818         public view returns (bool[6] isValid)
819     {
820         // The order of these errors matters as it determines which
821         // ValidationError event codes are logged when validation fails.
822         isValid[0] = PaymentLib.validateEndowment(
823             _endowment,
824             _uintArgs[1],               //bounty
825             _uintArgs[0],               //fee
826             _uintArgs[8],               //callGas
827             _uintArgs[9],               //callValue
828             _uintArgs[10],              //gasPrice
829             EXECUTION_GAS_OVERHEAD
830         );
831         isValid[1] = RequestScheduleLib.validateReservedWindowSize(
832             _uintArgs[4],               //reservedWindowSize
833             _uintArgs[6]                //windowSize
834         );
835         isValid[2] = RequestScheduleLib.validateTemporalUnit(_uintArgs[5]);
836         isValid[3] = RequestScheduleLib.validateWindowStart(
837             RequestScheduleLib.TemporalUnit(MathLib.min(_uintArgs[5], 2)),
838             _uintArgs[3],               //freezePeriod
839             _uintArgs[7]                //windowStart
840         );
841         isValid[4] = ExecutionLib.validateCallGas(
842             _uintArgs[8],               //callGas
843             EXECUTION_GAS_OVERHEAD
844         );
845         isValid[5] = ExecutionLib.validateToAddress(_addressArgs[3]);
846 
847         return isValid;
848     }
849 
850     /**
851      * @dev Initialize a new Request.
852      */
853     function initialize(
854         Request storage self,
855         address[4]      _addressArgs,
856         uint[12]        _uintArgs,
857         bytes           _callData
858     ) 
859         public returns (bool)
860     {
861         address[6] memory addressValues = [
862             0x0,                // self.claimData.claimedBy
863             _addressArgs[0],    // self.meta.createdBy
864             _addressArgs[1],    // self.meta.owner
865             _addressArgs[2],    // self.paymentData.feeRecipient
866             0x0,                // self.paymentData.bountyBenefactor
867             _addressArgs[3]     // self.txnData.toAddress
868         ];
869 
870         bool[3] memory boolValues = [false, false, false];
871 
872         uint[15] memory uintValues = [
873             0,                  // self.claimData.claimDeposit
874             _uintArgs[0],       // self.paymentData.fee
875             0,                  // self.paymentData.feeOwed
876             _uintArgs[1],       // self.paymentData.bounty
877             0,                  // self.paymentData.bountyOwed
878             _uintArgs[2],       // self.schedule.claimWindowSize
879             _uintArgs[3],       // self.schedule.freezePeriod
880             _uintArgs[4],       // self.schedule.reservedWindowSize
881             _uintArgs[5],       // self.schedule.temporalUnit
882             _uintArgs[6],       // self.schedule.windowSize
883             _uintArgs[7],       // self.schedule.windowStart
884             _uintArgs[8],       // self.txnData.callGas
885             _uintArgs[9],       // self.txnData.callValue
886             _uintArgs[10],      // self.txnData.gasPrice
887             _uintArgs[11]       // self.claimData.requiredDeposit
888         ];
889 
890         uint8[1] memory uint8Values = [
891             0
892         ];
893 
894         require(deserialize(self, addressValues, boolValues, uintValues, uint8Values, _callData));
895 
896         return true;
897     }
898  
899     function serialize(Request storage self)
900         internal view returns(address[6], bool[3], uint[15], uint8[1])
901     {
902         address[6] memory addressValues = [
903             self.claimData.claimedBy,
904             self.meta.createdBy,
905             self.meta.owner,
906             self.paymentData.feeRecipient,
907             self.paymentData.bountyBenefactor,
908             self.txnData.toAddress
909         ];
910 
911         bool[3] memory boolValues = [
912             self.meta.isCancelled,
913             self.meta.wasCalled,
914             self.meta.wasSuccessful
915         ];
916 
917         uint[15] memory uintValues = [
918             self.claimData.claimDeposit,
919             self.paymentData.fee,
920             self.paymentData.feeOwed,
921             self.paymentData.bounty,
922             self.paymentData.bountyOwed,
923             self.schedule.claimWindowSize,
924             self.schedule.freezePeriod,
925             self.schedule.reservedWindowSize,
926             uint(self.schedule.temporalUnit),
927             self.schedule.windowSize,
928             self.schedule.windowStart,
929             self.txnData.callGas,
930             self.txnData.callValue,
931             self.txnData.gasPrice,
932             self.claimData.requiredDeposit
933         ];
934 
935         uint8[1] memory uint8Values = [
936             self.claimData.paymentModifier
937         ];
938 
939         return (addressValues, boolValues, uintValues, uint8Values);
940     }
941 
942     /**
943      * @dev Populates a Request object from the full output of `serialize`.
944      *
945      *  Parameter order is alphabetical by type, then namespace, then name.
946      */
947     function deserialize(
948         Request storage self,
949         address[6]  _addressValues,
950         bool[3]     _boolValues,
951         uint[15]    _uintValues,
952         uint8[1]    _uint8Values,
953         bytes       _callData
954     )
955         internal returns (bool)
956     {
957         // callData is special.
958         self.txnData.callData = _callData;
959 
960         // Address values
961         self.claimData.claimedBy = _addressValues[0];
962         self.meta.createdBy = _addressValues[1];
963         self.meta.owner = _addressValues[2];
964         self.paymentData.feeRecipient = _addressValues[3];
965         self.paymentData.bountyBenefactor = _addressValues[4];
966         self.txnData.toAddress = _addressValues[5];
967 
968         // Boolean values
969         self.meta.isCancelled = _boolValues[0];
970         self.meta.wasCalled = _boolValues[1];
971         self.meta.wasSuccessful = _boolValues[2];
972 
973         // UInt values
974         self.claimData.claimDeposit = _uintValues[0];
975         self.paymentData.fee = _uintValues[1];
976         self.paymentData.feeOwed = _uintValues[2];
977         self.paymentData.bounty = _uintValues[3];
978         self.paymentData.bountyOwed = _uintValues[4];
979         self.schedule.claimWindowSize = _uintValues[5];
980         self.schedule.freezePeriod = _uintValues[6];
981         self.schedule.reservedWindowSize = _uintValues[7];
982         self.schedule.temporalUnit = RequestScheduleLib.TemporalUnit(_uintValues[8]);
983         self.schedule.windowSize = _uintValues[9];
984         self.schedule.windowStart = _uintValues[10];
985         self.txnData.callGas = _uintValues[11];
986         self.txnData.callValue = _uintValues[12];
987         self.txnData.gasPrice = _uintValues[13];
988         self.claimData.requiredDeposit = _uintValues[14];
989 
990         // Uint8 values
991         self.claimData.paymentModifier = _uint8Values[0];
992 
993         return true;
994     }
995 
996     function execute(Request storage self) 
997         internal returns (bool)
998     {
999         /*
1000          *  Execute the TransactionRequest
1001          *
1002          *  +---------------------+
1003          *  | Phase 1: Validation |
1004          *  +---------------------+
1005          *
1006          *  Must pass all of the following checks:
1007          *
1008          *  1. Not already called.
1009          *  2. Not cancelled.
1010          *  3. Not before the execution window.
1011          *  4. Not after the execution window.
1012          *  5. if (claimedBy == 0x0 or msg.sender == claimedBy):
1013          *         - windowStart <= block.number
1014          *         - block.number <= windowStart + windowSize
1015          *     else if (msg.sender != claimedBy):
1016          *         - windowStart + reservedWindowSize <= block.number
1017          *         - block.number <= windowStart + windowSize
1018          *     else:
1019          *         - throw (should be impossible)
1020          *  
1021          *  6. gasleft() == callGas
1022          *  7. tx.gasprice >= txnData.gasPrice
1023          *
1024          *  +--------------------+
1025          *  | Phase 2: Execution |
1026          *  +--------------------+
1027          *
1028          *  1. Mark as called (must be before actual execution to prevent
1029          *     re-entrance)
1030          *  2. Send Transaction and record success or failure.
1031          *
1032          *  +---------------------+
1033          *  | Phase 3: Accounting |
1034          *  +---------------------+
1035          *
1036          *  1. Calculate and send fee amount.
1037          *  2. Calculate and send bounty amount.
1038          *  3. Send remaining ether back to owner.
1039          *
1040          */
1041 
1042         // Record the gas at the beginning of the transaction so we can
1043         // calculate how much has been used later.
1044         uint startGas = gasleft();
1045 
1046         // +----------------------+
1047         // | Begin: Authorization |
1048         // +----------------------+
1049 
1050         if (gasleft() < requiredExecutionGas(self).sub(PRE_EXECUTION_GAS)) {
1051             emit Aborted(uint8(AbortReason.InsufficientGas));
1052             return false;
1053         } else if (self.meta.wasCalled) {
1054             emit Aborted(uint8(AbortReason.AlreadyCalled));
1055             return false;
1056         } else if (self.meta.isCancelled) {
1057             emit Aborted(uint8(AbortReason.WasCancelled));
1058             return false;
1059         } else if (self.schedule.isBeforeWindow()) {
1060             emit Aborted(uint8(AbortReason.BeforeCallWindow));
1061             return false;
1062         } else if (self.schedule.isAfterWindow()) {
1063             emit Aborted(uint8(AbortReason.AfterCallWindow));
1064             return false;
1065         } else if (self.claimData.isClaimed() && msg.sender != self.claimData.claimedBy && self.schedule.inReservedWindow()) {
1066             emit Aborted(uint8(AbortReason.ReservedForClaimer));
1067             return false;
1068         } else if (self.txnData.gasPrice > tx.gasprice) {
1069             emit Aborted(uint8(AbortReason.TooLowGasPrice));
1070             return false;
1071         }
1072 
1073         // +--------------------+
1074         // | End: Authorization |
1075         // +--------------------+
1076         // +------------------+
1077         // | Begin: Execution |
1078         // +------------------+
1079 
1080         // Mark as being called before sending transaction to prevent re-entrance.
1081         self.meta.wasCalled = true;
1082 
1083         // Send the transaction...
1084         // The transaction is allowed to fail and the executing agent will still get the bounty.
1085         // `.sendTransaction()` will return false on a failed exeuction. 
1086         self.meta.wasSuccessful = self.txnData.sendTransaction();
1087 
1088         // +----------------+
1089         // | End: Execution |
1090         // +----------------+
1091         // +-------------------+
1092         // | Begin: Accounting |
1093         // +-------------------+
1094 
1095         // Compute the fee amount
1096         if (self.paymentData.hasFeeRecipient()) {
1097             self.paymentData.feeOwed = self.paymentData.getFee()
1098                 .add(self.paymentData.feeOwed);
1099         }
1100 
1101         // Record this locally so that we can log it later.
1102         // `.sendFee()` below will change `self.paymentData.feeOwed` to 0 to prevent re-entrance.
1103         uint totalFeePayment = self.paymentData.feeOwed;
1104 
1105         // Send the fee. This transaction may also fail but can be called again after
1106         // execution.
1107         self.paymentData.sendFee();
1108 
1109         // Compute the bounty amount.
1110         self.paymentData.bountyBenefactor = msg.sender;
1111         if (self.claimData.isClaimed()) {
1112             // If the transaction request was claimed, we add the deposit to the bounty whether
1113             // or not the same agent who claimed is executing.
1114             self.paymentData.bountyOwed = self.claimData.claimDeposit
1115                 .add(self.paymentData.bountyOwed);
1116             // To prevent re-entrance we zero out the claim deposit since it is now accounted for
1117             // in the bounty value.
1118             self.claimData.claimDeposit = 0;
1119             // Depending on when the transaction request was claimed, we apply the modifier to the
1120             // bounty payment and add it to the bounty already owed.
1121             self.paymentData.bountyOwed = self.paymentData.getBountyWithModifier(self.claimData.paymentModifier)
1122                 .add(self.paymentData.bountyOwed);
1123         } else {
1124             // Not claimed. Just add the full bounty.
1125             self.paymentData.bountyOwed = self.paymentData.getBounty().add(self.paymentData.bountyOwed);
1126         }
1127 
1128         // Take down the amount of gas used so far in execution to compensate the executing agent.
1129         uint measuredGasConsumption = startGas.sub(gasleft()).add(EXECUTE_EXTRA_GAS);
1130 
1131         // // +----------------------------------------------------------------------+
1132         // // | NOTE: All code after this must be accounted for by EXECUTE_EXTRA_GAS |
1133         // // +----------------------------------------------------------------------+
1134 
1135         // Add the gas reimbursment amount to the bounty.
1136         self.paymentData.bountyOwed = measuredGasConsumption
1137             .mul(self.txnData.gasPrice)
1138             .add(self.paymentData.bountyOwed);
1139 
1140         // Log the bounty and fee. Otherwise it is non-trivial to figure
1141         // out how much was payed.
1142         emit Executed(self.paymentData.bountyOwed, totalFeePayment, measuredGasConsumption);
1143     
1144         // Attempt to send the bounty. as with `.sendFee()` it may fail and need to be caled after execution.
1145         self.paymentData.sendBounty();
1146 
1147         // If any ether is left, send it back to the owner of the transaction request.
1148         _sendOwnerEther(self, self.meta.owner);
1149 
1150         // +-----------------+
1151         // | End: Accounting |
1152         // +-----------------+
1153         // Successful
1154         return true;
1155     }
1156 
1157 
1158     // This is the amount of gas that it takes to enter from the
1159     // `TransactionRequest.execute()` contract into the `RequestLib.execute()`
1160     // method at the point where the gas check happens.
1161     uint public constant PRE_EXECUTION_GAS = 25000;   // TODO is this number still accurate?
1162     
1163     /*
1164      * The amount of gas needed to complete the execute method after
1165      * the transaction has been sent.
1166      */
1167     uint public constant EXECUTION_GAS_OVERHEAD = 180000; // TODO check accuracy of this number
1168     /*
1169      *  The amount of gas used by the portion of the `execute` function
1170      *  that cannot be accounted for via gas tracking.
1171      */
1172     uint public constant  EXECUTE_EXTRA_GAS = 90000; // again, check for accuracy... Doubled this from Piper's original - Logan
1173 
1174     /*
1175      *  Constant value to account for the gas usage that cannot be accounted
1176      *  for using gas-tracking within the `cancel` function.
1177      */
1178     uint public constant CANCEL_EXTRA_GAS = 85000; // Check accuracy
1179 
1180     function getEXECUTION_GAS_OVERHEAD()
1181         public pure returns (uint)
1182     {
1183         return EXECUTION_GAS_OVERHEAD;
1184     }
1185     
1186     function requiredExecutionGas(Request storage self) 
1187         public view returns (uint requiredGas)
1188     {
1189         requiredGas = self.txnData.callGas.add(EXECUTION_GAS_OVERHEAD);
1190     }
1191 
1192     /*
1193      * @dev Performs the checks to see if a request can be cancelled.
1194      *  Must satisfy the following conditions.
1195      *
1196      *  1. Not Cancelled
1197      *  2. either:
1198      *    * not wasCalled && afterExecutionWindow
1199      *    * not claimed && beforeFreezeWindow && msg.sender == owner
1200      */
1201     function isCancellable(Request storage self) 
1202         public view returns (bool)
1203     {
1204         if (self.meta.isCancelled) {
1205             // already cancelled!
1206             return false;
1207         } else if (!self.meta.wasCalled && self.schedule.isAfterWindow()) {
1208             // not called but after the window
1209             return true;
1210         } else if (!self.claimData.isClaimed() && self.schedule.isBeforeFreeze() && msg.sender == self.meta.owner) {
1211             // not claimed and before freezePeriod and owner is cancelling
1212             return true;
1213         } else {
1214             // otherwise cannot cancel
1215             return false;
1216         }
1217     }
1218 
1219     /*
1220      *  Cancel the transaction request, attempting to send all appropriate
1221      *  refunds.  To incentivise cancellation by other parties, a small reward
1222      *  payment is issued to the party that cancels the request if they are not
1223      *  the owner.
1224      */
1225     function cancel(Request storage self) 
1226         public returns (bool)
1227     {
1228         uint startGas = gasleft();
1229         uint rewardPayment;
1230         uint measuredGasConsumption;
1231 
1232         // Checks if this transactionRequest can be cancelled.
1233         require(isCancellable(self));
1234 
1235         // Set here to prevent re-entrance attacks.
1236         self.meta.isCancelled = true;
1237 
1238         // Refund the claim deposit (if there is one)
1239         require(self.claimData.refundDeposit());
1240 
1241         // Send a reward to the cancelling agent if they are not the owner.
1242         // This is to incentivize the cancelling of expired transaction requests.
1243         // This also guarantees that it is being cancelled after the call window
1244         // since the `isCancellable()` function checks this.
1245         if (msg.sender != self.meta.owner) {
1246             // Create the rewardBenefactor
1247             address rewardBenefactor = msg.sender;
1248             // Create the rewardOwed variable, it is one-hundredth
1249             // of the bounty.
1250             uint rewardOwed = self.paymentData.bountyOwed
1251                 .add(self.paymentData.bounty.div(100));
1252 
1253             // Calculate the amount of gas cancelling agent used in this transaction.
1254             measuredGasConsumption = startGas
1255                 .sub(gasleft())
1256                 .add(CANCEL_EXTRA_GAS);
1257             // Add their gas fees to the reward.W
1258             rewardOwed = measuredGasConsumption
1259                 .mul(tx.gasprice)
1260                 .add(rewardOwed);
1261 
1262             // Take note of the rewardPayment to log it.
1263             rewardPayment = rewardOwed;
1264 
1265             // Transfers the rewardPayment.
1266             if (rewardOwed > 0) {
1267                 self.paymentData.bountyOwed = 0;
1268                 rewardBenefactor.transfer(rewardOwed);
1269             }
1270         }
1271 
1272         // Log it!
1273         emit Cancelled(rewardPayment, measuredGasConsumption);
1274 
1275         // Send the remaining ether to the owner.
1276         return sendOwnerEther(self);
1277     }
1278 
1279     /*
1280      * @dev Performs some checks to verify that a transaction request is claimable.
1281      * @param self The Request object.
1282      */
1283     function isClaimable(Request storage self) 
1284         internal view returns (bool)
1285     {
1286         // Require not claimed and not cancelled.
1287         require(!self.claimData.isClaimed());
1288         require(!self.meta.isCancelled);
1289 
1290         // Require that it's in the claim window and the value sent is over the required deposit.
1291         require(self.schedule.inClaimWindow());
1292         require(msg.value >= self.claimData.requiredDeposit);
1293         return true;
1294     }
1295 
1296     /*
1297      * @dev Claims the request.
1298      * @param self The Request object.
1299      * Payable because it requires the sender to send enough ether to cover the claimDeposit.
1300      */
1301     function claim(Request storage self) 
1302         internal returns (bool claimed)
1303     {
1304         require(isClaimable(self));
1305         
1306         emit Claimed();
1307         return self.claimData.claim(self.schedule.computePaymentModifier());
1308     }
1309 
1310     /*
1311      * @dev Refund claimer deposit.
1312      */
1313     function refundClaimDeposit(Request storage self)
1314         public returns (bool)
1315     {
1316         require(self.meta.isCancelled || self.schedule.isAfterWindow());
1317         return self.claimData.refundDeposit();
1318     }
1319 
1320     /*
1321      * Send fee. Wrapper over the real function that perform an extra
1322      * check to see if it's after the execution window (and thus the first transaction failed)
1323      */
1324     function sendFee(Request storage self) 
1325         public returns (bool)
1326     {
1327         if (self.schedule.isAfterWindow()) {
1328             return self.paymentData.sendFee();
1329         }
1330         return false;
1331     }
1332 
1333     /*
1334      * Send bounty. Wrapper over the real function that performs an extra
1335      * check to see if it's after execution window (and thus the first transaction failed)
1336      */
1337     function sendBounty(Request storage self) 
1338         public returns (bool)
1339     {
1340         /// check wasCalled
1341         if (self.schedule.isAfterWindow()) {
1342             return self.paymentData.sendBounty();
1343         }
1344         return false;
1345     }
1346 
1347     function canSendOwnerEther(Request storage self) 
1348         public view returns(bool) 
1349     {
1350         return self.meta.isCancelled || self.schedule.isAfterWindow() || self.meta.wasCalled;
1351     }
1352 
1353     /**
1354      * Send owner ether. Wrapper over the real function that performs an extra 
1355      * check to see if it's after execution window (and thus the first transaction failed)
1356      */
1357     function sendOwnerEther(Request storage self, address recipient)
1358         public returns (bool)
1359     {
1360         require(recipient != 0x0);
1361         if(canSendOwnerEther(self) && msg.sender == self.meta.owner) {
1362             return _sendOwnerEther(self, recipient);
1363         }
1364         return false;
1365     }
1366 
1367     /**
1368      * Send owner ether. Wrapper over the real function that performs an extra 
1369      * check to see if it's after execution window (and thus the first transaction failed)
1370      */
1371     function sendOwnerEther(Request storage self)
1372         public returns (bool)
1373     {
1374         if(canSendOwnerEther(self)) {
1375             return _sendOwnerEther(self, self.meta.owner);
1376         }
1377         return false;
1378     }
1379 
1380     function _sendOwnerEther(Request storage self, address recipient) 
1381         private returns (bool)
1382     {
1383         // Note! This does not do any checks since it is used in the execute function.
1384         // The public version of the function should be used for checks and in the cancel function.
1385         uint ownerRefund = address(this).balance
1386             .sub(self.claimData.claimDeposit)
1387             .sub(self.paymentData.bountyOwed)
1388             .sub(self.paymentData.feeOwed);
1389         /* solium-disable security/no-send */
1390         return recipient.send(ownerRefund);
1391     }
1392 }
1393 
1394 /**
1395  * @title RequestScheduleLib
1396  * @dev Library containing the logic for request scheduling.
1397  */
1398 library RequestScheduleLib {
1399     using SafeMath for uint;
1400 
1401     /**
1402      * The manner in which this schedule specifies time.
1403      *
1404      * Null: present to require this value be explicitely specified
1405      * Blocks: execution schedule determined by block.number
1406      * Timestamp: execution schedule determined by block.timestamp
1407      */
1408     enum TemporalUnit {
1409         Null,           // 0
1410         Blocks,         // 1
1411         Timestamp       // 2
1412     }
1413 
1414     struct ExecutionWindow {
1415 
1416         TemporalUnit temporalUnit;      /// The type of unit used to measure time.
1417 
1418         uint windowStart;               /// The starting point in temporal units from which the transaction can be executed.
1419 
1420         uint windowSize;                /// The length in temporal units of the execution time period.
1421 
1422         uint freezePeriod;              /// The length in temporal units before the windowStart where no activity is allowed.
1423 
1424         uint reservedWindowSize;        /// The length in temporal units at the beginning of the executionWindow in which only the claim address can execute.
1425 
1426         uint claimWindowSize;           /// The length in temporal units before the freezeperiod in which an address can claim the execution.
1427     }
1428 
1429     /**
1430      * @dev Get the `now` represented in the temporal units assigned to this request.
1431      * @param self The ExecutionWindow object.
1432      * @return The unsigned integer representation of `now` in appropiate temporal units.
1433      */
1434     function getNow(ExecutionWindow storage self) 
1435         public view returns (uint)
1436     {
1437         return _getNow(self.temporalUnit);
1438     }
1439 
1440     /**
1441      * @dev Internal function to return the `now` based on the appropiate temporal units.
1442      * @param _temporalUnit The assigned TemporalUnit to this transaction.
1443      */
1444     function _getNow(TemporalUnit _temporalUnit) 
1445         internal view returns (uint)
1446     {
1447         if (_temporalUnit == TemporalUnit.Timestamp) {
1448             return block.timestamp;
1449         } 
1450         if (_temporalUnit == TemporalUnit.Blocks) {
1451             return block.number;
1452         }
1453         /// Only reaches here if the unit is unset, unspecified or unsupported.
1454         revert();
1455     }
1456 
1457     /**
1458      * @dev The modifier that will be applied to the bounty value depending
1459      * on when a call was claimed.
1460      */
1461     function computePaymentModifier(ExecutionWindow storage self) 
1462         internal view returns (uint8)
1463     {        
1464         uint paymentModifier = (getNow(self).sub(firstClaimBlock(self)))
1465             .mul(100)
1466             .div(self.claimWindowSize); 
1467         assert(paymentModifier <= 100); 
1468 
1469         return uint8(paymentModifier);
1470     }
1471 
1472     /*
1473      *  Helper: computes the end of the execution window.
1474      */
1475     function windowEnd(ExecutionWindow storage self)
1476         internal view returns (uint)
1477     {
1478         return self.windowStart.add(self.windowSize);
1479     }
1480 
1481     /*
1482      *  Helper: computes the end of the reserved portion of the execution
1483      *  window.
1484      */
1485     function reservedWindowEnd(ExecutionWindow storage self)
1486         internal view returns (uint)
1487     {
1488         return self.windowStart.add(self.reservedWindowSize);
1489     }
1490 
1491     /*
1492      *  Helper: computes the time when the request will be frozen until execution.
1493      */
1494     function freezeStart(ExecutionWindow storage self) 
1495         internal view returns (uint)
1496     {
1497         return self.windowStart.sub(self.freezePeriod);
1498     }
1499 
1500     /*
1501      *  Helper: computes the time when the request will be frozen until execution.
1502      */
1503     function firstClaimBlock(ExecutionWindow storage self) 
1504         internal view returns (uint)
1505     {
1506         return freezeStart(self).sub(self.claimWindowSize);
1507     }
1508 
1509     /*
1510      *  Helper: Returns boolean if we are before the execution window.
1511      */
1512     function isBeforeWindow(ExecutionWindow storage self)
1513         internal view returns (bool)
1514     {
1515         return getNow(self) < self.windowStart;
1516     }
1517 
1518     /*
1519      *  Helper: Returns boolean if we are after the execution window.
1520      */
1521     function isAfterWindow(ExecutionWindow storage self) 
1522         internal view returns (bool)
1523     {
1524         return getNow(self) > windowEnd(self);
1525     }
1526 
1527     /*
1528      *  Helper: Returns boolean if we are inside the execution window.
1529      */
1530     function inWindow(ExecutionWindow storage self)
1531         internal view returns (bool)
1532     {
1533         return self.windowStart <= getNow(self) && getNow(self) < windowEnd(self);
1534     }
1535 
1536     /*
1537      *  Helper: Returns boolean if we are inside the reserved portion of the
1538      *  execution window.
1539      */
1540     function inReservedWindow(ExecutionWindow storage self)
1541         internal view returns (bool)
1542     {
1543         return self.windowStart <= getNow(self) && getNow(self) < reservedWindowEnd(self);
1544     }
1545 
1546     /*
1547      * @dev Helper: Returns boolean if we are inside the claim window.
1548      */
1549     function inClaimWindow(ExecutionWindow storage self) 
1550         internal view returns (bool)
1551     {
1552         /// Checks that the firstClaimBlock is in the past or now.
1553         /// Checks that now is before the start of the freezePeriod.
1554         return firstClaimBlock(self) <= getNow(self) && getNow(self) < freezeStart(self);
1555     }
1556 
1557     /*
1558      *  Helper: Returns boolean if we are before the freeze period.
1559      */
1560     function isBeforeFreeze(ExecutionWindow storage self) 
1561         internal view returns (bool)
1562     {
1563         return getNow(self) < freezeStart(self);
1564     }
1565 
1566     /*
1567      *  Helper: Returns boolean if we are before the claim window.
1568      */
1569     function isBeforeClaimWindow(ExecutionWindow storage self)
1570         internal view returns (bool)
1571     {
1572         return getNow(self) < firstClaimBlock(self);
1573     }
1574 
1575     ///---------------
1576     /// VALIDATION
1577     ///---------------
1578 
1579     /**
1580      * @dev Validation: Ensure that the reservedWindowSize is less than or equal to the windowSize.
1581      * @param _reservedWindowSize The size of the reserved window.
1582      * @param _windowSize The size of the execution window.
1583      * @return True if the reservedWindowSize is within the windowSize.
1584      */
1585     function validateReservedWindowSize(uint _reservedWindowSize, uint _windowSize)
1586         public pure returns (bool)
1587     {
1588         return _reservedWindowSize <= _windowSize;
1589     }
1590 
1591     /**
1592      * @dev Validation: Ensure that the startWindow is at least freezePeriod amount of time in the future.
1593      * @param _temporalUnit The temporalUnit of this request.
1594      * @param _freezePeriod The freezePeriod in temporal units.
1595      * @param _windowStart The time in the future which represents the start of the execution window.
1596      * @return True if the windowStart is at least freezePeriod amount of time in the future.
1597      */
1598     function validateWindowStart(TemporalUnit _temporalUnit, uint _freezePeriod, uint _windowStart) 
1599         public view returns (bool)
1600     {
1601         return _getNow(_temporalUnit).add(_freezePeriod) <= _windowStart;
1602     }
1603 
1604     /*
1605      *  Validation: ensure that the temporal unit passed in is constrained to 0 or 1
1606      */
1607     function validateTemporalUnit(uint _temporalUnitAsUInt) 
1608         public pure returns (bool)
1609     {
1610         return (_temporalUnitAsUInt != uint(TemporalUnit.Null) &&
1611             (_temporalUnitAsUInt == uint(TemporalUnit.Blocks) ||
1612             _temporalUnitAsUInt == uint(TemporalUnit.Timestamp))
1613         );
1614     }
1615 }
1616 
1617 library ClaimLib {
1618 
1619     struct ClaimData {
1620         address claimedBy;          // The address that has claimed the txRequest.
1621         uint claimDeposit;          // The deposit amount that was put down by the claimer.
1622         uint requiredDeposit;       // The required deposit to claim the txRequest.
1623         uint8 paymentModifier;      // An integer constrained between 0-100 that will be applied to the
1624                                     // request payment as a percentage.
1625     }
1626 
1627     /*
1628      * @dev Mark the request as being claimed.
1629      * @param self The ClaimData that is being accessed.
1630      * @param paymentModifier The payment modifier.
1631      */
1632     function claim(
1633         ClaimData storage self, 
1634         uint8 _paymentModifier
1635     ) 
1636         internal returns (bool)
1637     {
1638         self.claimedBy = msg.sender;
1639         self.claimDeposit = msg.value;
1640         self.paymentModifier = _paymentModifier;
1641         return true;
1642     }
1643 
1644     /*
1645      * Helper: returns whether this request is claimed.
1646      */
1647     function isClaimed(ClaimData storage self) 
1648         internal view returns (bool)
1649     {
1650         return self.claimedBy != 0x0;
1651     }
1652 
1653 
1654     /*
1655      * @dev Refund the claim deposit to claimer.
1656      * @param self The Request.ClaimData
1657      * Called in RequestLib's `cancel()` and `refundClaimDeposit()`
1658      */
1659     function refundDeposit(ClaimData storage self) 
1660         internal returns (bool)
1661     {
1662         // Check that the claim deposit is non-zero.
1663         if (self.claimDeposit > 0) {
1664             uint depositAmount;
1665             depositAmount = self.claimDeposit;
1666             self.claimDeposit = 0;
1667             /* solium-disable security/no-send */
1668             return self.claimedBy.send(depositAmount);
1669         }
1670         return true;
1671     }
1672 }
1673 
1674 
1675 /**
1676  * Library containing the functionality for the bounty and fee payments.
1677  * - Bounty payments are the reward paid to the executing agent of transaction
1678  * requests.
1679  * - Fee payments are the cost of using a Scheduler to make transactions. It is 
1680  * a way for developers to monetize their work on the EAC.
1681  */
1682 library PaymentLib {
1683     using SafeMath for uint;
1684 
1685     struct PaymentData {
1686         uint bounty;                /// The amount in wei to be paid to the executing agent of the TransactionRequest.
1687 
1688         address bountyBenefactor;   /// The address that the bounty will be sent to.
1689 
1690         uint bountyOwed;            /// The amount that is owed to the bountyBenefactor.
1691 
1692         uint fee;                   /// The amount in wei that will be paid to the FEE_RECIPIENT address.
1693 
1694         address feeRecipient;       /// The address that the fee will be sent to.
1695 
1696         uint feeOwed;               /// The amount that is owed to the feeRecipient.
1697     }
1698 
1699     ///---------------
1700     /// GETTERS
1701     ///---------------
1702 
1703     /**
1704      * @dev Getter function that returns true if a request has a benefactor.
1705      */
1706     function hasFeeRecipient(PaymentData storage self)
1707         internal view returns (bool)
1708     {
1709         return self.feeRecipient != 0x0;
1710     }
1711 
1712     /**
1713      * @dev Computes the amount to send to the feeRecipient. 
1714      */
1715     function getFee(PaymentData storage self) 
1716         internal view returns (uint)
1717     {
1718         return self.fee;
1719     }
1720 
1721     /**
1722      * @dev Computes the amount to send to the agent that executed the request.
1723      */
1724     function getBounty(PaymentData storage self)
1725         internal view returns (uint)
1726     {
1727         return self.bounty;
1728     }
1729  
1730     /**
1731      * @dev Computes the amount to send to the address that fulfilled the request
1732      *       with an additional modifier. This is used when the call was claimed.
1733      */
1734     function getBountyWithModifier(PaymentData storage self, uint8 _paymentModifier)
1735         internal view returns (uint)
1736     {
1737         return getBounty(self).mul(_paymentModifier).div(100);
1738     }
1739 
1740     ///---------------
1741     /// SENDERS
1742     ///---------------
1743 
1744     /**
1745      * @dev Send the feeOwed amount to the feeRecipient.
1746      * Note: The send is allowed to fail.
1747      */
1748     function sendFee(PaymentData storage self) 
1749         internal returns (bool)
1750     {
1751         uint feeAmount = self.feeOwed;
1752         if (feeAmount > 0) {
1753             // re-entrance protection.
1754             self.feeOwed = 0;
1755             /* solium-disable security/no-send */
1756             return self.feeRecipient.send(feeAmount);
1757         }
1758         return true;
1759     }
1760 
1761     /**
1762      * @dev Send the bountyOwed amount to the bountyBenefactor.
1763      * Note: The send is allowed to fail.
1764      */
1765     function sendBounty(PaymentData storage self)
1766         internal returns (bool)
1767     {
1768         uint bountyAmount = self.bountyOwed;
1769         if (bountyAmount > 0) {
1770             // re-entrance protection.
1771             self.bountyOwed = 0;
1772             return self.bountyBenefactor.send(bountyAmount);
1773         }
1774         return true;
1775     }
1776 
1777     ///---------------
1778     /// Endowment
1779     ///---------------
1780 
1781     /**
1782      * @dev Compute the endowment value for the given TransactionRequest parameters.
1783      * See request_factory.rst in docs folder under Check #1 for more information about
1784      * this calculation.
1785      */
1786     function computeEndowment(
1787         uint _bounty,
1788         uint _fee,
1789         uint _callGas,
1790         uint _callValue,
1791         uint _gasPrice,
1792         uint _gasOverhead
1793     ) 
1794         public pure returns (uint)
1795     {
1796         return _bounty
1797             .add(_fee)
1798             .add(_callGas.mul(_gasPrice))
1799             .add(_gasOverhead.mul(_gasPrice))
1800             .add(_callValue);
1801     }
1802 
1803     /*
1804      * Validation: ensure that the request endowment is sufficient to cover.
1805      * - bounty
1806      * - fee
1807      * - gasReimbursment
1808      * - callValue
1809      */
1810     function validateEndowment(uint _endowment, uint _bounty, uint _fee, uint _callGas, uint _callValue, uint _gasPrice, uint _gasOverhead)
1811         public pure returns (bool)
1812     {
1813         return _endowment >= computeEndowment(
1814             _bounty,
1815             _fee,
1816             _callGas,
1817             _callValue,
1818             _gasPrice,
1819             _gasOverhead
1820         );
1821     }
1822 }
1823 
1824 /**
1825  * @title IterTools
1826  * @dev Utility library that iterates through a boolean array of length 6.
1827  */
1828 library IterTools {
1829     /*
1830      * @dev Return true if all of the values in the boolean array are true.
1831      * @param _values A boolean array of length 6.
1832      * @return True if all values are true, False if _any_ are false.
1833      */
1834     function all(bool[6] _values) 
1835         public pure returns (bool)
1836     {
1837         for (uint i = 0; i < _values.length; i++) {
1838             if (!_values[i]) {
1839                 return false;
1840             }
1841         }
1842         return true;
1843     }
1844 }
1845 
1846 /*
1847 The MIT License (MIT)
1848 
1849 Copyright (c) 2018 Murray Software, LLC.
1850 
1851 Permission is hereby granted, free of charge, to any person obtaining
1852 a copy of this software and associated documentation files (the
1853 "Software"), to deal in the Software without restriction, including
1854 without limitation the rights to use, copy, modify, merge, publish,
1855 distribute, sublicense, and/or sell copies of the Software, and to
1856 permit persons to whom the Software is furnished to do so, subject to
1857 the following conditions:
1858 
1859 The above copyright notice and this permission notice shall be included
1860 in all copies or substantial portions of the Software.
1861 
1862 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
1863 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
1864 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
1865 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
1866 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
1867 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
1868 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
1869 */
1870 //solhint-disable max-line-length
1871 //solhint-disable no-inline-assembly
1872 
1873 contract CloneFactory {
1874 
1875   event CloneCreated(address indexed target, address clone);
1876 
1877   function createClone(address target) internal returns (address result) {
1878     bytes memory clone = hex"600034603b57603080600f833981f36000368180378080368173bebebebebebebebebebebebebebebebebebebebe5af43d82803e15602c573d90f35b3d90fd";
1879     bytes20 targetBytes = bytes20(target);
1880     for (uint i = 0; i < 20; i++) {
1881       clone[26 + i] = targetBytes[i];
1882     }
1883     assembly {
1884       let len := mload(clone)
1885       let data := add(clone, 0x20)
1886       result := create(0, data, len)
1887     }
1888   }
1889 }
1890 
1891 /// Example of using the Scheduler from a smart contract to delay a payment.
1892 contract DelayedPayment {
1893 
1894     SchedulerInterface public scheduler;
1895     
1896     address recipient;
1897     address owner;
1898     address public payment;
1899 
1900     uint lockedUntil;
1901     uint value;
1902     uint twentyGwei = 20000000000 wei;
1903 
1904     constructor(
1905         address _scheduler,
1906         uint    _numBlocks,
1907         address _recipient,
1908         uint _value
1909     )  public payable {
1910         scheduler = SchedulerInterface(_scheduler);
1911         lockedUntil = block.number + _numBlocks;
1912         recipient = _recipient;
1913         owner = msg.sender;
1914         value = _value;
1915    
1916         uint endowment = scheduler.computeEndowment(
1917             twentyGwei,
1918             twentyGwei,
1919             200000,
1920             0,
1921             twentyGwei
1922         );
1923 
1924         payment = scheduler.schedule.value(endowment)( // 0.1 ether is to pay for gas, bounty and fee
1925             this,                   // send to self
1926             "",                     // and trigger fallback function
1927             [
1928                 200000,             // The amount of gas to be sent with the transaction.
1929                 0,                  // The amount of wei to be sent.
1930                 255,                // The size of the execution window.
1931                 lockedUntil,        // The start of the execution window.
1932                 twentyGwei,    // The gasprice for the transaction (aka 20 gwei)
1933                 twentyGwei,    // The fee included in the transaction.
1934                 twentyGwei,         // The bounty that awards the executor of the transaction.
1935                 twentyGwei * 2     // The required amount of wei the claimer must send as deposit.
1936             ]
1937         );
1938 
1939         assert(address(this).balance >= value);
1940     }
1941 
1942     function () public payable {
1943         if (msg.value > 0) { //this handles recieving remaining funds sent while scheduling (0.1 ether)
1944             return;
1945         } else if (address(this).balance > 0) {
1946             payout();
1947         } else {
1948             revert();
1949         }
1950     }
1951 
1952     function payout()
1953         public returns (bool)
1954     {
1955         require(block.number >= lockedUntil);
1956         
1957         recipient.transfer(value);
1958         return true;
1959     }
1960 
1961     function collectRemaining()
1962         public returns (bool) 
1963     {
1964         owner.transfer(address(this).balance);
1965     }
1966 }
1967 
1968 /// Example of using the Scheduler from a smart contract to delay a payment.
1969 contract RecurringPayment {
1970     SchedulerInterface public scheduler;
1971     
1972     uint paymentInterval;
1973     uint paymentValue;
1974     uint lockedUntil;
1975 
1976     address recipient;
1977     address public currentScheduledTransaction;
1978 
1979     event PaymentScheduled(address indexed scheduledTransaction, address recipient, uint value);
1980     event PaymentExecuted(address indexed scheduledTransaction, address recipient, uint value);
1981 
1982     function RecurringPayment(
1983         address _scheduler,
1984         uint _paymentInterval,
1985         uint _paymentValue,
1986         address _recipient
1987     )  public payable {
1988         scheduler = SchedulerInterface(_scheduler);
1989         paymentInterval = _paymentInterval;
1990         recipient = _recipient;
1991         paymentValue = _paymentValue;
1992 
1993         schedule();
1994     }
1995 
1996     function ()
1997         public payable 
1998     {
1999         if (msg.value > 0) { //this handles recieving remaining funds sent while scheduling (0.1 ether)
2000             return;
2001         } 
2002         
2003         process();
2004     }
2005 
2006     function process() public returns (bool) {
2007         payout();
2008         schedule();
2009     }
2010 
2011     function payout()
2012         private returns (bool)
2013     {
2014         require(block.number >= lockedUntil);
2015         require(address(this).balance >= paymentValue);
2016         
2017         recipient.transfer(paymentValue);
2018 
2019         emit PaymentExecuted(currentScheduledTransaction, recipient, paymentValue);
2020         return true;
2021     }
2022 
2023     function schedule() 
2024         private returns (bool)
2025     {
2026         lockedUntil = block.number + paymentInterval;
2027 
2028         currentScheduledTransaction = scheduler.schedule.value(0.1 ether)( // 0.1 ether is to pay for gas, bounty and fee
2029             this,                   // send to self
2030             "",                     // and trigger fallback function
2031             [
2032                 1000000,            // The amount of gas to be sent with the transaction. Accounts for payout + new contract deployment
2033                 0,                  // The amount of wei to be sent.
2034                 255,                // The size of the execution window.
2035                 lockedUntil,        // The start of the execution window.
2036                 20000000000 wei,    // The gasprice for the transaction (aka 20 gwei)
2037                 20000000000 wei,    // The fee included in the transaction.
2038                 20000000000 wei,         // The bounty that awards the executor of the transaction.
2039                 30000000000 wei     // The required amount of wei the claimer must send as deposit.
2040             ]
2041         );
2042 
2043         emit PaymentScheduled(currentScheduledTransaction, recipient, paymentValue);
2044     }
2045 }
2046 
2047 /**
2048  * @title RequestFactory
2049  * @dev Contract which will produce new TransactionRequests.
2050  */
2051 contract RequestFactory is RequestFactoryInterface, CloneFactory, Pausable {
2052     using IterTools for bool[6];
2053 
2054     TransactionRequestCore public transactionRequestCore;
2055 
2056     uint constant public BLOCKS_BUCKET_SIZE = 240; //~1h
2057     uint constant public TIMESTAMP_BUCKET_SIZE = 3600; //1h
2058 
2059     constructor(
2060         address _transactionRequestCore
2061     ) 
2062         public 
2063     {
2064         require(_transactionRequestCore != 0x0);
2065 
2066         transactionRequestCore = TransactionRequestCore(_transactionRequestCore);
2067     }
2068 
2069     /**
2070      * @dev The lowest level interface for creating a transaction request.
2071      *
2072      * @param _addressArgs [0] -  meta.owner
2073      * @param _addressArgs [1] -  paymentData.feeRecipient
2074      * @param _addressArgs [2] -  txnData.toAddress
2075      * @param _uintArgs [0]    -  paymentData.fee
2076      * @param _uintArgs [1]    -  paymentData.bounty
2077      * @param _uintArgs [2]    -  schedule.claimWindowSize
2078      * @param _uintArgs [3]    -  schedule.freezePeriod
2079      * @param _uintArgs [4]    -  schedule.reservedWindowSize
2080      * @param _uintArgs [5]    -  schedule.temporalUnit
2081      * @param _uintArgs [6]    -  schedule.windowSize
2082      * @param _uintArgs [7]    -  schedule.windowStart
2083      * @param _uintArgs [8]    -  txnData.callGas
2084      * @param _uintArgs [9]    -  txnData.callValue
2085      * @param _uintArgs [10]   -  txnData.gasPrice
2086      * @param _uintArgs [11]   -  claimData.requiredDeposit
2087      * @param _callData        -  The call data
2088      */
2089     function createRequest(
2090         address[3]  _addressArgs,
2091         uint[12]    _uintArgs,
2092         bytes       _callData
2093     )
2094         whenNotPaused
2095         public payable returns (address)
2096     {
2097         // Create a new transaction request clone from transactionRequestCore.
2098         address transactionRequest = createClone(transactionRequestCore);
2099 
2100         // Call initialize on the transaction request clone.
2101         TransactionRequestCore(transactionRequest).initialize.value(msg.value)(
2102             [
2103                 msg.sender,       // Created by
2104                 _addressArgs[0],  // meta.owner
2105                 _addressArgs[1],  // paymentData.feeRecipient
2106                 _addressArgs[2]   // txnData.toAddress
2107             ],
2108             _uintArgs,            //uint[12]
2109             _callData
2110         );
2111 
2112         // Track the address locally
2113         requests[transactionRequest] = true;
2114 
2115         // Log the creation.
2116         emit RequestCreated(
2117             transactionRequest,
2118             _addressArgs[0],
2119             getBucket(_uintArgs[7], RequestScheduleLib.TemporalUnit(_uintArgs[5])),
2120             _uintArgs
2121         );
2122 
2123         return transactionRequest;
2124     }
2125 
2126     /**
2127      *  The same as createRequest except that it requires validation prior to
2128      *  creation.
2129      *
2130      *  Parameters are the same as `createRequest`
2131      */
2132     function createValidatedRequest(
2133         address[3]  _addressArgs,
2134         uint[12]    _uintArgs,
2135         bytes       _callData
2136     )
2137         public payable returns (address)
2138     {
2139         bool[6] memory isValid = validateRequestParams(
2140             _addressArgs,
2141             _uintArgs,
2142             msg.value
2143         );
2144 
2145         if (!isValid.all()) {
2146             if (!isValid[0]) {
2147                 emit ValidationError(uint8(Errors.InsufficientEndowment));
2148             }
2149             if (!isValid[1]) {
2150                 emit ValidationError(uint8(Errors.ReservedWindowBiggerThanExecutionWindow));
2151             }
2152             if (!isValid[2]) {
2153                 emit ValidationError(uint8(Errors.InvalidTemporalUnit));
2154             }
2155             if (!isValid[3]) {
2156                 emit ValidationError(uint8(Errors.ExecutionWindowTooSoon));
2157             }
2158             if (!isValid[4]) {
2159                 emit ValidationError(uint8(Errors.CallGasTooHigh));
2160             }
2161             if (!isValid[5]) {
2162                 emit ValidationError(uint8(Errors.EmptyToAddress));
2163             }
2164 
2165             // Try to return the ether sent with the message
2166             msg.sender.transfer(msg.value);
2167             
2168             return 0x0;
2169         }
2170 
2171         return createRequest(_addressArgs, _uintArgs, _callData);
2172     }
2173 
2174     /// ----------------------------
2175     /// Internal
2176     /// ----------------------------
2177 
2178     /*
2179      *  @dev The enum for launching `ValidationError` events and mapping them to an error.
2180      */
2181     enum Errors {
2182         InsufficientEndowment,
2183         ReservedWindowBiggerThanExecutionWindow,
2184         InvalidTemporalUnit,
2185         ExecutionWindowTooSoon,
2186         CallGasTooHigh,
2187         EmptyToAddress
2188     }
2189 
2190     event ValidationError(uint8 error);
2191 
2192     /*
2193      * @dev Validate the constructor arguments for either `createRequest` or `createValidatedRequest`.
2194      */
2195     function validateRequestParams(
2196         address[3]  _addressArgs,
2197         uint[12]    _uintArgs,
2198         uint        _endowment
2199     )
2200         public view returns (bool[6])
2201     {
2202         return RequestLib.validate(
2203             [
2204                 msg.sender,      // meta.createdBy
2205                 _addressArgs[0],  // meta.owner
2206                 _addressArgs[1],  // paymentData.feeRecipient
2207                 _addressArgs[2]   // txnData.toAddress
2208             ],
2209             _uintArgs,
2210             _endowment
2211         );
2212     }
2213 
2214     /// Mapping to hold known requests.
2215     mapping (address => bool) requests;
2216 
2217     function isKnownRequest(address _address)
2218         public view returns (bool isKnown)
2219     {
2220         return requests[_address];
2221     }
2222 
2223     function getBucket(uint windowStart, RequestScheduleLib.TemporalUnit unit)
2224         public pure returns(int)
2225     {
2226         uint bucketSize;
2227         /* since we want to handle both blocks and timestamps
2228             and do not want to get into case where buckets overlaps
2229             block buckets are going to be negative ints
2230             timestamp buckets are going to be positive ints
2231             we'll overflow after 2**255-1 blocks instead of 2**256-1 since we encoding this on int256
2232         */
2233         int sign;
2234 
2235         if (unit == RequestScheduleLib.TemporalUnit.Blocks) {
2236             bucketSize = BLOCKS_BUCKET_SIZE;
2237             sign = -1;
2238         } else if (unit == RequestScheduleLib.TemporalUnit.Timestamp) {
2239             bucketSize = TIMESTAMP_BUCKET_SIZE;
2240             sign = 1;
2241         } else {
2242             revert();
2243         }
2244         return sign * int(windowStart - (windowStart % bucketSize));
2245     }
2246 }