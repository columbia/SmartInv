1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    */
39   function renounceOwnership() public onlyOwner {
40     emit OwnershipRenounced(owner);
41     owner = address(0);
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param _newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address _newOwner) public onlyOwner {
49     _transferOwnership(_newOwner);
50   }
51 
52   /**
53    * @dev Transfers control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function _transferOwnership(address _newOwner) internal {
57     require(_newOwner != address(0));
58     emit OwnershipTransferred(owner, _newOwner);
59     owner = _newOwner;
60   }
61 }
62 
63 
64 
65 
66 
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73 
74   /**
75   * @dev Multiplies two numbers, throws on overflow.
76   */
77   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
78     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
79     // benefit is lost if 'b' is also tested.
80     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
81     if (a == 0) {
82       return 0;
83     }
84 
85     c = a * b;
86     assert(c / a == b);
87     return c;
88   }
89 
90   /**
91   * @dev Integer division of two numbers, truncating the quotient.
92   */
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     // assert(b > 0); // Solidity automatically throws when dividing by 0
95     // uint256 c = a / b;
96     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97     return a / b;
98   }
99 
100   /**
101   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102   */
103   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104     assert(b <= a);
105     return a - b;
106   }
107 
108   /**
109   * @dev Adds two numbers, throws on overflow.
110   */
111   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
112     c = a + b;
113     assert(c >= a);
114     return c;
115   }
116 }
117 
118 
119 
120 
121 /**
122  * @title Eliptic curve signature operations
123  *
124  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
125  *
126  * TODO Remove this library once solidity supports passing a signature to ecrecover.
127  * See https://github.com/ethereum/solidity/issues/864
128  *
129  */
130 
131 library ECRecovery {
132 
133   /**
134    * @dev Recover signer address from a message by using their signature
135    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
136    * @param sig bytes signature, the signature is generated using web3.eth.sign()
137    */
138   function recover(bytes32 hash, bytes sig)
139     internal
140     pure
141     returns (address)
142   {
143     bytes32 r;
144     bytes32 s;
145     uint8 v;
146 
147     // Check the signature length
148     if (sig.length != 65) {
149       return (address(0));
150     }
151 
152     // Divide the signature in r, s and v variables
153     // ecrecover takes the signature parameters, and the only way to get them
154     // currently is to use assembly.
155     // solium-disable-next-line security/no-inline-assembly
156     assembly {
157       r := mload(add(sig, 32))
158       s := mload(add(sig, 64))
159       v := byte(0, mload(add(sig, 96)))
160     }
161 
162     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
163     if (v < 27) {
164       v += 27;
165     }
166 
167     // If the version is correct return the signer address
168     if (v != 27 && v != 28) {
169       return (address(0));
170     } else {
171       // solium-disable-next-line arg-overflow
172       return ecrecover(hash, v, r, s);
173     }
174   }
175 
176   /**
177    * toEthSignedMessageHash
178    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
179    * @dev and hash the result
180    */
181   function toEthSignedMessageHash(bytes32 hash)
182     internal
183     pure
184     returns (bytes32)
185   {
186     // 32 is the length in bytes of hash,
187     // enforced by the type signature above
188     return keccak256(
189       "\x19Ethereum Signed Message:\n32",
190       hash
191     );
192   }
193 }
194 
195 
196 
197 
198 
199 
200 
201 /**
202  * @title Pausable
203  * @dev Base contract which allows children to implement an emergency stop mechanism.
204  */
205 contract Pausable is Ownable {
206   event Pause();
207   event Unpause();
208 
209   bool public paused = false;
210 
211 
212   /**
213    * @dev Modifier to make a function callable only when the contract is not paused.
214    */
215   modifier whenNotPaused() {
216     require(!paused);
217     _;
218   }
219 
220   /**
221    * @dev Modifier to make a function callable only when the contract is paused.
222    */
223   modifier whenPaused() {
224     require(paused);
225     _;
226   }
227 
228   /**
229    * @dev called by the owner to pause, triggers stopped state
230    */
231   function pause() onlyOwner whenNotPaused public {
232     paused = true;
233     emit Pause();
234   }
235 
236   /**
237    * @dev called by the owner to unpause, returns to normal state
238    */
239   function unpause() onlyOwner whenPaused public {
240     paused = false;
241     emit Unpause();
242   }
243 }
244 
245 
246 
247 
248 
249 
250 contract Arbitrator is Ownable {
251 
252   mapping(address => bool) private aribitratorWhitelist;
253   address private primaryArbitrator;
254 
255   event ArbitratorAdded(address indexed newArbitrator);
256   event ArbitratorRemoved(address indexed newArbitrator);
257   event ChangePrimaryArbitratorWallet(address indexed newPrimaryWallet);
258 
259   constructor() public {
260     primaryArbitrator = msg.sender;
261   }
262 
263   modifier onlyArbitrator() {
264     require(aribitratorWhitelist[msg.sender] == true || msg.sender == primaryArbitrator);
265     _;
266   }
267 
268   function changePrimaryArbitrator(address walletAddress) public onlyOwner {
269     require(walletAddress != address(0));
270     emit ChangePrimaryArbitratorWallet(walletAddress);
271     primaryArbitrator = walletAddress;
272   }
273 
274   function addArbitrator(address newArbitrator) public onlyOwner {
275     require(newArbitrator != address(0));
276     emit ArbitratorAdded(newArbitrator);
277     aribitratorWhitelist[newArbitrator] = true;
278   }
279 
280   function deleteArbitrator(address arbitrator) public onlyOwner {
281     require(arbitrator != address(0));
282     require(arbitrator != msg.sender); //ensure owner isn't removed
283     emit ArbitratorRemoved(arbitrator);
284     delete aribitratorWhitelist[arbitrator];
285   }
286 
287   //Mainly for front-end administration
288   function isArbitrator(address arbitratorCheck) external view returns(bool) {
289     return (aribitratorWhitelist[arbitratorCheck] || arbitratorCheck == primaryArbitrator);
290   }
291 }
292 
293 
294 
295 
296 
297 
298 
299 contract ApprovedWithdrawer is Ownable {
300 
301   mapping(address => bool) private withdrawerWhitelist;
302   address private primaryWallet;
303 
304   event WalletApproved(address indexed newAddress);
305   event WalletRemoved(address indexed removedAddress);
306   event ChangePrimaryApprovedWallet(address indexed newPrimaryWallet);
307 
308   constructor() public {
309     primaryWallet = msg.sender;
310   }
311 
312   modifier onlyApprovedWallet(address _to) {
313     require(withdrawerWhitelist[_to] == true || primaryWallet == _to);
314     _;
315   }
316 
317   function changePrimaryApprovedWallet(address walletAddress) public onlyOwner {
318     require(walletAddress != address(0));
319     emit ChangePrimaryApprovedWallet(walletAddress);
320     primaryWallet = walletAddress;
321   }
322 
323   function addApprovedWalletAddress(address walletAddress) public onlyOwner {
324     require(walletAddress != address(0));
325     emit WalletApproved(walletAddress);
326     withdrawerWhitelist[walletAddress] = true;
327   }
328 
329   function deleteApprovedWalletAddress(address walletAddress) public onlyOwner {
330     require(walletAddress != address(0));
331     require(walletAddress != msg.sender); //ensure owner isn't removed
332     emit WalletRemoved(walletAddress);
333     delete withdrawerWhitelist[walletAddress];
334   }
335 
336   //Mainly for front-end administration
337   function isApprovedWallet(address walletCheck) external view returns(bool) {
338     return (withdrawerWhitelist[walletCheck] || walletCheck == primaryWallet);
339   }
340 }
341 
342 
343 /**
344  * @title CoinSparrow
345  */
346 
347 
348 contract CoinSparrow  is Ownable, Arbitrator, ApprovedWithdrawer, Pausable {
349 
350   //Who wouldn't?
351   using SafeMath for uint256;
352 
353   /**
354    * ------------------------------------
355    * SET UP SOME CONSTANTS FOR JOB STATUS
356    * ------------------------------------
357    */
358 
359   //Some of these are not used in the contract, but are for reference and are used in the front-end's database.
360   uint8 constant private STATUS_JOB_NOT_EXIST = 1; //Not used in contract. Here for reference (used externally)
361   uint8 constant private STATUS_JOB_CREATED = 2; //Job has been created. Set by createJobEscrow()
362   uint8 constant private STATUS_JOB_STARTED = 3; //Contractor flags job as started. Set by jobStarted()
363   uint8 constant private STATUS_HIRER_REQUEST_CANCEL = 4; //Hirer requested cancellation on started job.
364                                                   //Set by requestMutualJobCancelation()
365   uint8 constant private STATUS_JOB_COMPLETED = 5; //Contractor flags job as completed. Set by jobCompleted()
366   uint8 constant private STATUS_JOB_IN_DISPUTE = 6; //Either party raised dispute. Set by requestDispute()
367   uint8 constant private STATUS_HIRER_CANCELLED = 7; //Not used in contract. Here for reference
368   uint8 constant private STATUS_CONTRACTOR_CANCELLED = 8; //Not used in contract. Here for reference
369   uint8 constant private STATUS_FINISHED_FUNDS_RELEASED = 9; //Not used in contract. Here for reference
370   uint8 constant private STATUS_FINISHED_FUNDS_RELEASED_BY_CONTRACTOR = 10; //Not used in contract. Here for reference
371   uint8 constant private STATUS_CONTRACTOR_REQUEST_CANCEL = 11; //Contractor requested cancellation on started job.
372                                                         //Set by requestMutualJobCancelation()
373   uint8 constant private STATUS_MUTUAL_CANCELLATION_PROCESSED = 12; //Not used in contract. Here for reference
374 
375   //Deployment script will check for existing CoinSparrow contracts, and only
376   //deploy if this value is > than existing version.
377   //TODO: to be implemented
378   uint8 constant private COINSPARROW_CONTRACT_VERSION = 1;
379 
380   /**
381    * ------
382    * EVENTS
383    * ------
384    */
385 
386   event JobCreated(bytes32 _jobHash, address _who, uint256 _value);
387   event ContractorStartedJob(bytes32 _jobHash, address _who);
388   event ContractorCompletedJob(bytes32 _jobHash, address _who);
389   event HirerRequestedCancel(bytes32 _jobHash, address _who);
390   event ContractorRequestedCancel(bytes32 _jobHash, address _who);
391   event CancelledByHirer(bytes32 _jobHash, address _who);
392   event CancelledByContractor(bytes32 _jobHash, address _who);
393   event MutuallyAgreedCancellation(
394     bytes32 _jobHash,
395     address _who,
396     uint256 _hirerAmount,
397     uint256 _contractorAmount
398   );
399   event DisputeRequested(bytes32 _jobHash, address _who);
400   event DisputeResolved(
401     bytes32 _jobHash,
402     address _who,
403     uint256 _hirerAmount,
404     uint256 _contractorAmount
405   );
406   event HirerReleased(bytes32 _jobHash, address _hirer, address _contractor, uint256 _value);
407   event AddFeesToCoinSparrowPool(bytes32 _jobHash, uint256 _value);
408   event ContractorReleased(bytes32 _jobHash, address _hirer, address _contractor, uint256 _value);
409   event HirerLastResortRefund(bytes32 _jobHash, address _hirer, address _contractor, uint256 _value);
410   event WithdrawFeesFromCoinSparrowPool(address _whoCalled, address _to, uint256 _amount);
411   event LogFallbackFunctionCalled(address _from, uint256 _amount);
412 
413 
414   /**
415    * ----------
416    * STRUCTURES
417    * ----------
418    */
419 
420   /**
421    * @dev Structure to hold live Escrow data - current status, times etc.
422    */
423   struct JobEscrow {
424     // Set so we know the job has already been created. Set when job created in createJobEscrow()
425     bool exists;
426     // The timestamp after which the hirer can cancel the task if the contractor has not yet flagged as job started.
427     // Set in createJobEscrow(). If the Contractor has not called jobStarted() within this time, then the hirer
428     // can call hirerCancel() to get a full refund (minus gas fees)
429     uint32 hirerCanCancelAfter;
430     //Job's current status (see STATUS_JOB_* constants above). Updated in multiple functions
431     uint8 status;
432     //timestamp for job completion. Set when jobCompleted() is called.
433     uint32 jobCompleteDate;
434     //num agreed seconds it will take to complete the job, once flagged as STATUS_JOB_STARTED. Set in createJobEscrow()
435     uint32 secondsToComplete;
436     //timestamp calculated for agreed completion date. Set when jobStarted() is called.
437     uint32 agreedCompletionDate;
438   }
439 
440   /**
441    * ------------------
442    * CONTRACT VARIABLES
443    * ------------------
444    */
445 
446 
447   //Total Wei currently held in Escrow
448   uint256 private totalInEscrow;
449   //Amount of Wei available to CoinSparrow to withdraw
450   uint256 private feesAvailableForWithdraw;
451 
452   /*
453    * Set max limit for how much (in wei) contract will accept. Can be modified by owner using setMaxSend()
454    * This ensures that arbitrarily large amounts of ETH can't be sent.
455    * Front end will check this value before processing new jobs
456    */
457   uint256 private MAX_SEND;
458 
459   /*
460    * Mapping of active jobs. Key is a hash of the job data:
461    * JobEscrow = keccak256(_jobId,_hirer,_contractor, _value, _fee)
462    * Once job is complete, and refunds released, the
463    * mapping for that job is deleted to conserve space.
464    */
465   mapping(bytes32 => JobEscrow) private jobEscrows;
466 
467   /*
468    * mapping of Hirer's funds in Escrow for each job.
469    * This is referenced when any ETH transactions occur
470    */
471   mapping(address => mapping(bytes32 => uint256)) private hirerEscrowMap;
472 
473   /**
474    * ---------
475    * MODIFIERS
476    * ---------
477    */
478 
479   /**
480    * @dev modifier to ensure only the Hirer can execute
481    * @param _hirer Address of the hirer to check against msg.sender
482    */
483 
484   modifier onlyHirer(address _hirer) {
485     require(msg.sender == _hirer);
486     _;
487   }
488 
489   /**
490    * @dev modifier to ensure only the Contractor can execute
491    * @param _contractor Address of the contractor to check against msg.sender
492    */
493 
494   modifier onlyContractor(address _contractor) {
495     require(msg.sender == _contractor);
496     _;
497   }
498 
499   /**
500    * @dev modifier to ensure only the Contractor can execute
501    * @param _contractor Address of the contractor to check against msg.sender
502    */
503 
504   modifier onlyHirerOrContractor(address _hirer, address _contractor) {
505     require(msg.sender == _hirer || msg.sender == _contractor);
506     _;
507   }
508 
509   /**
510    * ----------------------
511    * CONTRACT FUNCTIONALITY
512    * ----------------------
513    */
514 
515   /**
516    * @dev Constructor function for the contract
517    * @param _maxSend Maximum Wei the contract will accept in a transaction
518    */
519 
520   constructor(uint256 _maxSend) public {
521     require(_maxSend > 0);
522     //a bit of protection. Set a limit, so users can't send stupid amounts of ETH
523     MAX_SEND = _maxSend;
524   }
525 
526   /**
527    * @dev fallback function for the contract. Log event so ETH can be tracked and returned
528    */
529 
530   function() payable {
531     //Log who sent, and how much so it can be returned
532     emit LogFallbackFunctionCalled(msg.sender, msg.value);
533   }
534 
535   /**
536    * @dev Create a new escrow and add it to the `jobEscrows` mapping.
537    * Also updates/creates a reference to the job, and amount in Escrow for the job in hirerEscrowMap
538    * jobHash is created by hashing _jobId, _seller, _buyer, _value and _fee params.
539    * These params must be supplied on future contract calls.
540    * A hash of the job parameters (_jobId, _hirer, _contractor, _value, _fee) is created and used
541    * to access job data held in the contract. All functions that interact with a job in Escrow
542    * require these parameters.
543    * Pausable - only runs whenNotPaused. Can pause to prevent taking any more
544    *            ETH if there is a problem with the Smart Contract.
545    *            Parties can still access/transfer their existing ETH held in Escrow, complete jobs etc.
546    * @param _jobId The unique ID of the job, from the CoinSparrow database
547    * @param _hirer The wallet address of the hiring (buying) party
548    * @param _contractor The wallet address of the contractor (selling) party
549    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
550    * @param _fee CoinSparrow fee for this job. Pre-calculated
551    * @param _jobStartedWindowInSeconds time within which the contractor must flag as job started
552    *                                   if job hasn't started AFTER this time, hirer can cancel contract.
553    *                                   Hirer cannot cancel contract before this time.
554    * @param _secondsToComplete agreed time to complete job once it's flagged as STATUS_JOB_STARTED
555    */
556   function createJobEscrow(
557     bytes16 _jobId,
558     address _hirer,
559     address _contractor,
560     uint256 _value,
561     uint256 _fee,
562     uint32 _jobStartedWindowInSeconds,
563     uint32 _secondsToComplete
564   ) payable external whenNotPaused onlyHirer(_hirer)
565   {
566 
567     // Check sent eth against _value and also make sure is not 0
568     require(msg.value == _value && msg.value > 0);
569 
570     //CoinSparrow's Fee should be less than the Job Value, because anything else would be daft.
571     require(_fee < _value);
572 
573     //Check the amount sent is below the acceptable threshold
574     require(msg.value <= MAX_SEND);
575 
576     //needs to be more than 0 seconds
577     require(_jobStartedWindowInSeconds > 0);
578 
579     //needs to be more than 0 seconds
580     require(_secondsToComplete > 0);
581 
582     //generate the job hash. Used to reference the job in all future function calls/transactions.
583     bytes32 jobHash = getJobHash(
584       _jobId,
585       _hirer,
586       _contractor,
587       _value,
588       _fee);
589 
590     //Check that the job does not already exist.
591     require(!jobEscrows[jobHash].exists);
592 
593     //create the job and store it in the mapping
594     jobEscrows[jobHash] = JobEscrow(
595       true,
596       uint32(block.timestamp) + _jobStartedWindowInSeconds,
597       STATUS_JOB_CREATED,
598       0,
599       _secondsToComplete,
600       0);
601 
602     //update total held in escrow
603     totalInEscrow = totalInEscrow.add(msg.value);
604 
605     //Update hirer's job => value mapping
606     hirerEscrowMap[msg.sender][jobHash] = msg.value;
607 
608     //Let the world know.
609     emit JobCreated(jobHash, msg.sender, msg.value);
610   }
611 
612   /**
613    * -----------------------
614    * RELEASE FUNDS FUNCTIONS
615    * -----------------------
616    */
617 
618   /**
619    * @dev Release funds to contractor. Can only be called by Hirer. Can be called at any time as long as the
620    * job exists in the contract (for example, two parties may have agreed job is complete external to the
621    * CoinSparrow website). Following parameters are used to regenerate the jobHash:
622    * @param _jobId The unique ID of the job, from the CoinSparrow database
623    * @param _hirer The wallet address of the hiring (buying) party
624    * @param _contractor The wallet address of the contractor (selling) party
625    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
626    * @param _fee CoinSparrow fee for this job. Pre-calculated
627    */
628   function hirerReleaseFunds(
629     bytes16 _jobId,
630     address _hirer,
631     address _contractor,
632     uint256 _value,
633     uint256 _fee
634   ) external onlyHirer(_hirer)
635   {
636 
637     bytes32 jobHash = getJobHash(
638       _jobId,
639       _hirer,
640       _contractor,
641       _value,
642       _fee);
643 
644     //check the job exists in the contract
645     require(jobEscrows[jobHash].exists);
646 
647     //check hirer has funds in the Smart Contract assigned to this job
648     require(hirerEscrowMap[msg.sender][jobHash] > 0);
649 
650     //get the value from the stored hirer => job => value mapping
651     uint256 jobValue = hirerEscrowMap[msg.sender][jobHash];
652 
653     //Check values in contract and sent are valid
654     require(jobValue > 0 && jobValue == _value);
655 
656     //check fee amount is valid
657     require(jobValue >= jobValue.sub(_fee));
658 
659     //check there is enough in escrow
660     require(totalInEscrow >= jobValue && totalInEscrow > 0);
661 
662      //Log event
663     emit HirerReleased(
664       jobHash,
665       msg.sender,
666       _contractor,
667       jobValue);
668 
669      //Log event
670     emit AddFeesToCoinSparrowPool(jobHash, _fee);
671 
672     //no longer required. Remove to save storage. Also prevents reentrancy
673     delete jobEscrows[jobHash];
674     //no longer required. Remove to save storage. Also prevents reentrancy
675     delete hirerEscrowMap[msg.sender][jobHash];
676 
677     //add to CoinSparrow's fee pool
678     feesAvailableForWithdraw = feesAvailableForWithdraw.add(_fee);
679 
680     //update total in escrow
681     totalInEscrow = totalInEscrow.sub(jobValue);
682 
683     //Finally, transfer the funds, minus CoinSparrow fees
684     _contractor.transfer(jobValue.sub(_fee));
685 
686   }
687 
688   /**
689    * @dev Release funds to contractor in the event that the Hirer is unresponsive after job has been flagged as complete.
690    * Can only be called by the contractor, and only 4 weeks after the job has been flagged as complete.
691    * Following parameters are used to regenerate the jobHash:
692    * @param _jobId The unique ID of the job, from the CoinSparrow database
693    * @param _hirer The wallet address of the hiring (buying) party
694    * @param _contractor The wallet address of the contractor (selling) party
695    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
696    * @param _fee CoinSparrow fee for this job. Pre-calculated
697    */
698   function contractorReleaseFunds(
699     bytes16 _jobId,
700     address _hirer,
701     address _contractor,
702     uint256 _value,
703     uint256 _fee
704   ) external onlyContractor(_contractor)
705   {
706 
707     bytes32 jobHash = getJobHash(
708       _jobId,
709       _hirer,
710       _contractor,
711       _value,
712       _fee);
713 
714     //check the job exists in the contract
715     require(jobEscrows[jobHash].exists);
716 
717     //check job is actually completed
718     require(jobEscrows[jobHash].status == STATUS_JOB_COMPLETED);
719     //can only self-release 4 weeks after completion
720     require(block.timestamp > jobEscrows[jobHash].jobCompleteDate + 4 weeks);
721 
722     //get value for job
723     uint256 jobValue = hirerEscrowMap[_hirer][jobHash];
724 
725     //Check values in contract and sent are valid
726     require(jobValue > 0 && jobValue == _value);
727 
728     //check fee amount is valid
729     require(jobValue >= jobValue.sub(_fee));
730 
731     //check there is enough in escrow
732     require(totalInEscrow >= jobValue && totalInEscrow > 0);
733 
734     emit ContractorReleased(
735       jobHash,
736       _hirer,
737       _contractor,
738       jobValue); //Log event
739     emit AddFeesToCoinSparrowPool(jobHash, _fee);
740 
741     delete jobEscrows[jobHash]; //no longer required. Remove to save storage.
742     delete  hirerEscrowMap[_hirer][jobHash]; //no longer required. Remove to save storage.
743 
744     //add fees to coinsparrow pool
745     feesAvailableForWithdraw = feesAvailableForWithdraw.add(_fee);
746 
747     //update total in escrow
748     totalInEscrow = totalInEscrow.sub(jobValue);
749 
750     //transfer funds to contractor, minus fees
751     _contractor.transfer(jobValue.sub(_fee));
752 
753   }
754 
755   /**
756    * @dev Can be called by the hirer to claim a full refund, if job has been started but contractor has not
757    * completed within 4 weeks after agreed completion date, and becomes unresponsive.
758    * Following parameters are used to regenerate the jobHash:
759    * @param _jobId The unique ID of the job, from the CoinSparrow database
760    * @param _hirer The wallet address of the hiring (buying) party
761    * @param _contractor The wallet address of the contractor (selling) party
762    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
763    * @param _fee CoinSparrow fee for this job. Pre-calculated
764    */
765   function hirerLastResortRefund(
766     bytes16 _jobId,
767     address _hirer,
768     address _contractor,
769     uint256 _value,
770     uint256 _fee
771   ) external onlyHirer(_hirer)
772   {
773     bytes32 jobHash = getJobHash(
774       _jobId,
775       _hirer,
776       _contractor,
777       _value,
778       _fee);
779 
780     //check the job exists in the contract
781     require(jobEscrows[jobHash].exists);
782     
783     //check job is started
784     require(jobEscrows[jobHash].status == STATUS_JOB_STARTED);
785     //can only self-refund 4 weeks after agreed completion date
786     require(block.timestamp > jobEscrows[jobHash].agreedCompletionDate + 4 weeks);
787 
788     //get value for job
789     uint256 jobValue = hirerEscrowMap[msg.sender][jobHash];
790 
791     //Check values in contract and sent are valid
792     require(jobValue > 0 && jobValue == _value);
793 
794     //check fee amount is valid
795     require(jobValue >= jobValue.sub(_fee));
796 
797     //check there is enough in escrow
798     require(totalInEscrow >= jobValue && totalInEscrow > 0);
799 
800     emit HirerLastResortRefund(
801       jobHash,
802       _hirer,
803       _contractor,
804       jobValue); //Log event
805 
806     delete jobEscrows[jobHash]; //no longer required. Remove to save storage.
807     delete  hirerEscrowMap[_hirer][jobHash]; //no longer required. Remove to save storage.
808 
809     //update total in escrow
810     totalInEscrow = totalInEscrow.sub(jobValue);
811 
812     //transfer funds to hirer
813     _hirer.transfer(jobValue);
814   }
815 
816   /**
817    * ---------------------------
818    * UPDATE JOB STATUS FUNCTIONS
819    * ---------------------------
820    */
821 
822   /**
823    * @dev Flags job started, and Stops the hirer from cancelling the job.
824    * Can only be called the contractor when job starts.
825    * Used to mark the job as started. After this point, hirer must request cancellation
826    * Following parameters are used to regenerate the jobHash:
827    * @param _jobId The unique ID of the job, from the CoinSparrow database
828    * @param _hirer The wallet address of the hiring (buying) party
829    * @param _contractor The wallet address of the contractor (selling) party
830    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
831    * @param _fee CoinSparrow fee for this job. Pre-calculated
832    */
833   function jobStarted(
834     bytes16 _jobId,
835     address _hirer,
836     address _contractor,
837     uint256 _value,
838     uint256 _fee
839   ) external onlyContractor(_contractor)
840   {
841     //get job Hash
842     bytes32 jobHash = getJobHash(
843       _jobId,
844       _hirer,
845       _contractor,
846       _value,
847       _fee);
848 
849     //check the job exists in the contract
850     require(jobEscrows[jobHash].exists);
851     //check job status.
852     require(jobEscrows[jobHash].status == STATUS_JOB_CREATED);
853     jobEscrows[jobHash].status = STATUS_JOB_STARTED; //set status
854     jobEscrows[jobHash].hirerCanCancelAfter = 0;
855     jobEscrows[jobHash].agreedCompletionDate = uint32(block.timestamp) + jobEscrows[jobHash].secondsToComplete;
856     emit ContractorStartedJob(jobHash, msg.sender);
857   }
858 
859   /**
860    * @dev Flags job completed to inform hirer. Also sets flag to allow contractor to get their funds 4 weeks after
861    * completion in the event that the hirer is unresponsive and doesn't release the funds.
862    * Can only be called the contractor when job complete.
863    * Following parameters are used to regenerate the jobHash:
864    * @param _jobId The unique ID of the job, from the CoinSparrow database
865    * @param _hirer The wallet address of the hiring (buying) party
866    * @param _contractor The wallet address of the contractor (selling) party
867    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
868    * @param _fee CoinSparrow fee for this job. Pre-calculated
869    */
870   function jobCompleted(
871     bytes16 _jobId,
872     address _hirer,
873     address _contractor,
874     uint256 _value,
875     uint256 _fee
876   ) external onlyContractor(_contractor)
877   {
878     //get job Hash
879     bytes32 jobHash = getJobHash(
880       _jobId,
881       _hirer,
882       _contractor,
883       _value,
884       _fee);
885 
886     require(jobEscrows[jobHash].exists); //check the job exists in the contract
887     require(jobEscrows[jobHash].status == STATUS_JOB_STARTED); //check job status.
888     jobEscrows[jobHash].status = STATUS_JOB_COMPLETED;
889     jobEscrows[jobHash].jobCompleteDate = uint32(block.timestamp);
890     emit ContractorCompletedJob(jobHash, msg.sender);
891   }
892 
893   /**
894    * --------------------------
895    * JOB CANCELLATION FUNCTIONS
896    * --------------------------
897    */
898 
899   /**
900    * @dev Cancels the job and returns the ether to the hirer.
901    * Can only be called the contractor. Can be called at any time during the process
902    * Following parameters are used to regenerate the jobHash:
903    * @param _jobId The unique ID of the job, from the CoinSparrow database
904    * @param _hirer The wallet address of the hiring (buying) party
905    * @param _contractor The wallet address of the contractor (selling) party
906    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
907    * @param _fee CoinSparrow fee for this job. Pre-calculated
908    */
909   function contractorCancel(
910     bytes16 _jobId,
911     address _hirer,
912     address _contractor,
913     uint256 _value,
914     uint256 _fee
915   ) external onlyContractor(_contractor)
916   {
917     //get job Hash
918     bytes32 jobHash = getJobHash(
919       _jobId,
920       _hirer,
921       _contractor,
922       _value,
923       _fee);
924 
925     uint256 jobValue = hirerEscrowMap[_hirer][jobHash];
926 
927     //check the job exists in the contract
928     require(jobEscrows[jobHash].exists);
929 
930     //Check values in contract and sent are valid
931     require(jobValue > 0 && jobValue == _value);
932 
933     //check fee amount is valid
934     require(jobValue >= jobValue.sub(_fee));
935 
936     //check there is enough in escrow
937     require(totalInEscrow >= jobValue && totalInEscrow > 0);
938 
939     delete jobEscrows[jobHash];
940     delete  hirerEscrowMap[_hirer][jobHash];
941     emit CancelledByContractor(jobHash, msg.sender);
942 
943     totalInEscrow = totalInEscrow.sub(jobValue);
944 
945     _hirer.transfer(jobValue);
946   }
947 
948   /**
949    * @dev Cancels the job and returns the ether to the hirer.
950    * Can only be called the hirer.
951    * Can only be called if the job start window was missed by the contractor
952    * Following parameters are used to regenerate the jobHash:
953    * @param _jobId The unique ID of the job, from the CoinSparrow database
954    * @param _hirer The wallet address of the hiring (buying) party
955    * @param _contractor The wallet address of the contractor (selling) party
956    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
957    * @param _fee CoinSparrow fee for this job. Pre-calculated
958    */
959   function hirerCancel(
960     bytes16 _jobId,
961     address _hirer,
962     address _contractor,
963     uint256 _value,
964     uint256 _fee
965   ) external onlyHirer(_hirer)
966   {
967     //get job Hash
968     bytes32 jobHash = getJobHash(
969       _jobId,
970       _hirer,
971       _contractor,
972       _value,
973       _fee);
974 
975     //check the job exists in the contract
976     require(jobEscrows[jobHash].exists);
977 
978     require(jobEscrows[jobHash].hirerCanCancelAfter > 0);
979     require(jobEscrows[jobHash].status == STATUS_JOB_CREATED);
980     require(jobEscrows[jobHash].hirerCanCancelAfter < block.timestamp);
981 
982     uint256 jobValue = hirerEscrowMap[_hirer][jobHash];
983 
984     //Check values in contract and sent are valid
985     require(jobValue > 0 && jobValue == _value);
986 
987     //check fee amount is valid
988     require(jobValue >= jobValue.sub(_fee));
989 
990     //check there is enough in escrow
991     require(totalInEscrow >= jobValue && totalInEscrow > 0);
992 
993     delete jobEscrows[jobHash];
994     delete  hirerEscrowMap[msg.sender][jobHash];
995     emit CancelledByHirer(jobHash, msg.sender);
996 
997     totalInEscrow = totalInEscrow.sub(jobValue);
998 
999     _hirer.transfer(jobValue);
1000   }
1001 
1002   /**
1003    * @dev Called by the hirer or contractor to request mutual cancellation once job has started
1004    * Can only be called when status = STATUS_JOB_STARTED
1005    * Following parameters are used to regenerate the jobHash:
1006    * @param _jobId The unique ID of the job, from the CoinSparrow database
1007    * @param _hirer The wallet address of the hiring (buying) party
1008    * @param _contractor The wallet address of the contractor (selling) party
1009    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
1010    * @param _fee CoinSparrow fee for this job. Pre-calculated
1011    */
1012   function requestMutualJobCancellation(
1013     bytes16 _jobId,
1014     address _hirer,
1015     address _contractor,
1016     uint256 _value,
1017     uint256 _fee
1018   ) external onlyHirerOrContractor(_hirer, _contractor)
1019   {
1020     //get job Hash
1021     bytes32 jobHash = getJobHash(
1022       _jobId,
1023       _hirer,
1024       _contractor,
1025       _value,
1026       _fee);
1027 
1028     //check the job exists in the contract
1029     require(jobEscrows[jobHash].exists);
1030     require(jobEscrows[jobHash].status == STATUS_JOB_STARTED);
1031 
1032     if (msg.sender == _hirer) {
1033       jobEscrows[jobHash].status = STATUS_HIRER_REQUEST_CANCEL;
1034       emit HirerRequestedCancel(jobHash, msg.sender);
1035     }
1036     if (msg.sender == _contractor) {
1037       jobEscrows[jobHash].status = STATUS_CONTRACTOR_REQUEST_CANCEL;
1038       emit ContractorRequestedCancel(jobHash, msg.sender);
1039     }
1040   }
1041 
1042   /**
1043    * @dev Called when both hirer and contractor have agreed on cancellation conditions, and amount each will receive
1044    * can be called by hirer or contractor once % amount has been signed by both parties.
1045    * Both parties sign a hash of the % agreed upon. The signatures of both parties must be sent and verified
1046    * before the transaction is processed, to ensure that the % processed is valid.
1047    * can be called at any time
1048    * @param _jobId The unique ID of the job, from the CoinSparrow database
1049    * @param _hirer The wallet address of the hiring (buying) party
1050    * @param _contractor The wallet address of the contractor (selling) party
1051    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
1052    * @param _fee CoinSparrow fee for this job. Pre-calculated
1053    * @param _contractorPercent percentage the contractor will be paid
1054    * @param _hirerMsgSig Signed message from hiring party agreeing on _contractorPercent
1055    * @param _contractorMsgSig Signed message from contractor agreeing on _contractorPercent
1056    */
1057   function processMutuallyAgreedJobCancellation(
1058     bytes16 _jobId,
1059     address _hirer,
1060     address _contractor,
1061     uint256 _value,
1062     uint256 _fee,
1063     uint8 _contractorPercent,
1064     bytes _hirerMsgSig,
1065     bytes _contractorMsgSig
1066   ) external
1067   {
1068     //get job Hash
1069     bytes32 jobHash = getJobHash(
1070       _jobId,
1071       _hirer,
1072       _contractor,
1073       _value,
1074       _fee);
1075 
1076     //check the job exists in the contract
1077     require(jobEscrows[jobHash].exists);
1078 
1079     require(msg.sender == _hirer || msg.sender == _contractor);
1080     require(_contractorPercent <= 100 && _contractorPercent >= 0);
1081 
1082     //Checks the signature of both parties to ensure % is correct.
1083     //Attempts to prevent the party calling the function from modifying the pre-agreed %
1084     require(
1085       checkRefundSignature(_contractorPercent,_hirerMsgSig,_hirer)&&
1086       checkRefundSignature(_contractorPercent,_contractorMsgSig,_contractor));
1087 
1088     uint256 jobValue = hirerEscrowMap[_hirer][jobHash];
1089 
1090     //Check values in contract and sent are valid
1091     require(jobValue > 0 && jobValue == _value);
1092 
1093     //check fee amount is valid
1094     require(jobValue >= jobValue.sub(_fee));
1095 
1096     //check there is enough in escrow
1097     require(totalInEscrow >= jobValue && totalInEscrow > 0);
1098 
1099     totalInEscrow = totalInEscrow.sub(jobValue);
1100     feesAvailableForWithdraw = feesAvailableForWithdraw.add(_fee);
1101 
1102     delete jobEscrows[jobHash];
1103     delete  hirerEscrowMap[_hirer][jobHash];
1104 
1105     uint256 contractorAmount = jobValue.sub(_fee).mul(_contractorPercent).div(100);
1106     uint256 hirerAmount = jobValue.sub(_fee).mul(100 - _contractorPercent).div(100);
1107 
1108     emit MutuallyAgreedCancellation(
1109       jobHash,
1110       msg.sender,
1111       hirerAmount,
1112       contractorAmount);
1113 
1114     emit AddFeesToCoinSparrowPool(jobHash, _fee);
1115 
1116     if (contractorAmount > 0) {
1117       _contractor.transfer(contractorAmount);
1118     }
1119     if (hirerAmount > 0) {
1120       _hirer.transfer(hirerAmount);
1121     }
1122   }
1123 
1124   /**
1125    * -------------------------
1126    * DISPUTE RELATED FUNCTIONS
1127    * -------------------------
1128    */
1129 
1130   /**
1131    * @dev Called by hirer or contractor to raise a dispute during started, completed or canellation request statuses
1132    * Once called, funds are locked until arbitrator can resolve the dispute. Assigned arbitrator
1133    * will review all information relating to the job, and decide on a fair course of action.
1134    * Following parameters are used to regenerate the jobHash:
1135    * @param _jobId The unique ID of the job, from the CoinSparrow database
1136    * @param _hirer The wallet address of the hiring (buying) party
1137    * @param _contractor The wallet address of the contractor (selling) party
1138    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
1139    * @param _fee CoinSparrow fee for this job. Pre-calculated
1140    */
1141   function requestDispute(
1142     bytes16 _jobId,
1143     address _hirer,
1144     address _contractor,
1145     uint256 _value,
1146     uint256 _fee
1147   ) external onlyHirerOrContractor(_hirer, _contractor)
1148   {
1149 
1150     //get job Hash
1151     bytes32 jobHash = getJobHash(
1152       _jobId,
1153       _hirer,
1154       _contractor,
1155       _value,
1156       _fee);
1157 
1158     //check the job exists in the contract
1159     require(jobEscrows[jobHash].exists);
1160     require(
1161       jobEscrows[jobHash].status == STATUS_JOB_STARTED||
1162       jobEscrows[jobHash].status == STATUS_JOB_COMPLETED||
1163       jobEscrows[jobHash].status == STATUS_HIRER_REQUEST_CANCEL||
1164       jobEscrows[jobHash].status == STATUS_CONTRACTOR_REQUEST_CANCEL);
1165 
1166     jobEscrows[jobHash].status = STATUS_JOB_IN_DISPUTE;
1167 
1168     emit DisputeRequested(jobHash, msg.sender);
1169   }
1170 
1171   /**
1172    * @dev Called by the arbitrator to resolve a dispute
1173    * @param _jobId The unique ID of the job, from the CoinSparrow database
1174    * @param _hirer The wallet address of the hiring (buying) party
1175    * @param _contractor The wallet address of the contractor (selling) party
1176    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
1177    * @param _fee CoinSparrow fee for this job. Pre-calculated
1178    * @param _contractorPercent percentage the contractor will receive
1179    */
1180 
1181   function resolveDispute(
1182 
1183     bytes16 _jobId,
1184     address _hirer,
1185     address _contractor,
1186     uint256 _value,
1187     uint256 _fee,
1188     uint8 _contractorPercent
1189   ) external onlyArbitrator
1190   {
1191     //get job Hash
1192     bytes32 jobHash = getJobHash(
1193       _jobId,
1194       _hirer,
1195       _contractor,
1196       _value,
1197       _fee);
1198 
1199     //check the job exists in the contract
1200     require(jobEscrows[jobHash].exists);
1201 
1202     require(jobEscrows[jobHash].status == STATUS_JOB_IN_DISPUTE);
1203     require(_contractorPercent <= 100);
1204 
1205     uint256 jobValue = hirerEscrowMap[_hirer][jobHash];
1206 
1207     //Check values in contract and sent are valid
1208     require(jobValue > 0 && jobValue == _value);
1209 
1210     //check fee amount is valid
1211     require(jobValue >= jobValue.sub(_fee));
1212 
1213     //check there is enough in escrow
1214     require(totalInEscrow >= jobValue && totalInEscrow > 0);
1215 
1216     totalInEscrow = totalInEscrow.sub(jobValue);
1217     feesAvailableForWithdraw = feesAvailableForWithdraw.add(_fee);
1218     // Add the the pot for localethereum to withdraw
1219 
1220     delete jobEscrows[jobHash];
1221     delete  hirerEscrowMap[_hirer][jobHash];
1222 
1223     uint256 contractorAmount = jobValue.sub(_fee).mul(_contractorPercent).div(100);
1224     uint256 hirerAmount = jobValue.sub(_fee).mul(100 - _contractorPercent).div(100);
1225     emit DisputeResolved(
1226       jobHash,
1227       msg.sender,
1228       hirerAmount,
1229       contractorAmount);
1230 
1231     emit AddFeesToCoinSparrowPool(jobHash, _fee);
1232 
1233     _contractor.transfer(contractorAmount);
1234     _hirer.transfer(hirerAmount);
1235 
1236   }
1237 
1238   /**
1239    * ------------------------
1240    * ADMINISTRATIVE FUNCTIONS
1241    * ------------------------
1242    */
1243 
1244   /**
1245    * @dev Allows owner to transfer funds from the collected fees pool to an approved wallet address
1246    * @param _to receiver wallet address
1247    * @param _amount amount to withdraw and transfer
1248    */
1249   function withdrawFees(address _to, uint256 _amount) onlyOwner onlyApprovedWallet(_to) external {
1250     /**
1251      * Withdraw fees collected by the contract. Only the owner can call this.
1252      * Can only be sent to an approved wallet address
1253      */
1254     require(_amount > 0);
1255     require(_amount <= feesAvailableForWithdraw && feesAvailableForWithdraw > 0);
1256 
1257     feesAvailableForWithdraw = feesAvailableForWithdraw.sub(_amount);
1258 
1259     emit WithdrawFeesFromCoinSparrowPool(msg.sender,_to, _amount);
1260 
1261     _to.transfer(_amount);
1262   }
1263 
1264   /**
1265    * @dev returns how much has been collected in fees, and how much is available to withdraw
1266    * @return feesAvailableForWithdraw amount available for CoinSparrow to withdraw
1267    */
1268 
1269   function howManyFees() external view returns (uint256) {
1270     return feesAvailableForWithdraw;
1271   }
1272 
1273   /**
1274    * @dev returns how much is currently held in escrow
1275    * @return totalInEscrow amount currently held in escrow
1276    */
1277 
1278   function howMuchInEscrow() external view returns (uint256) {
1279     return totalInEscrow;
1280   }
1281 
1282   /**
1283    * @dev modify the maximum amount of ETH the contract will allow in a transaction (when creating a new job)
1284    * @param _maxSend amount in Wei
1285    */
1286 
1287   function setMaxSend(uint256 _maxSend) onlyOwner external {
1288     require(_maxSend > 0);
1289     MAX_SEND = _maxSend;
1290   }
1291 
1292   /**
1293    * @dev return the current maximum amount the contract will allow in a transaction
1294    * @return MAX_SEND current maximum value
1295    */
1296 
1297   function getMaxSend() external view returns (uint256) {
1298     return MAX_SEND;
1299   }
1300 
1301   /**
1302    * @dev returns THIS contract instance's version
1303    * @return COINSPARROW_CONTRACT_VERSION version number of THIS instance of the contract
1304    */
1305 
1306   function getContractVersion() external pure returns(uint8) {
1307     return COINSPARROW_CONTRACT_VERSION;
1308   }
1309 
1310   /**
1311    * -------------------------
1312    * JOB INFORMATION FUNCTIONS
1313    * -------------------------
1314    */
1315 
1316   /**
1317    * @dev returns the status of the requested job
1318    * Following parameters are used to regenerate the jobHash:
1319    * @param _jobId The unique ID of the job, from the CoinSparrow database
1320    * @param _hirer The wallet address of the hiring (buying) party
1321    * @param _contractor The wallet address of the contractor (selling) party
1322    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
1323    * @param _fee CoinSparrow fee for this job. Pre-calculated
1324    * @return status job's current status
1325    */
1326 
1327   function getJobStatus(
1328     bytes16 _jobId,
1329     address _hirer,
1330     address _contractor,
1331     uint256 _value,
1332     uint256 _fee) external view returns (uint8)
1333   {
1334     //get job Hash
1335     bytes32 jobHash = getJobHash(
1336       _jobId,
1337       _hirer,
1338       _contractor,
1339       _value,
1340       _fee);
1341 
1342     uint8 status = STATUS_JOB_NOT_EXIST;
1343 
1344     if (jobEscrows[jobHash].exists) {
1345       status = jobEscrows[jobHash].status;
1346     }
1347     return status;
1348   }
1349 
1350   /**
1351    * @dev returns the date after which the Hirer can cancel the job
1352    * Following parameters are used to regenerate the jobHash:
1353    * @param _jobId The unique ID of the job, from the CoinSparrow database
1354    * @param _hirer The wallet address of the hiring (buying) party
1355    * @param _contractor The wallet address of the contractor (selling) party
1356    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
1357    * @param _fee CoinSparrow fee for this job. Pre-calculated
1358    * @return hirerCanCancelAfter timestamp for date after which the hirer can cancel
1359    */
1360 
1361   function getJobCanCancelAfter(
1362     bytes16 _jobId,
1363     address _hirer,
1364     address _contractor,
1365     uint256 _value,
1366     uint256 _fee) external view returns (uint32)
1367   {
1368     //get job Hash
1369     bytes32 jobHash = getJobHash(
1370       _jobId,
1371       _hirer,
1372       _contractor,
1373       _value,
1374       _fee);
1375 
1376     uint32 hirerCanCancelAfter = 0;
1377 
1378     if (jobEscrows[jobHash].exists) {
1379       hirerCanCancelAfter = jobEscrows[jobHash].hirerCanCancelAfter;
1380     }
1381     return hirerCanCancelAfter;
1382   }
1383 
1384   /**
1385    * @dev returns the number of seconds for job completion
1386    * Following parameters are used to regenerate the jobHash:
1387    * @param _jobId The unique ID of the job, from the CoinSparrow database
1388    * @param _hirer The wallet address of the hiring (buying) party
1389    * @param _contractor The wallet address of the contractor (selling) party
1390    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
1391    * @param _fee CoinSparrow fee for this job. Pre-calculated
1392    * @return secondsToComplete number of seconds to complete job
1393    */
1394 
1395   function getSecondsToComplete(
1396     bytes16 _jobId,
1397     address _hirer,
1398     address _contractor,
1399     uint256 _value,
1400     uint256 _fee) external view returns (uint32)
1401   {
1402     //get job Hash
1403     bytes32 jobHash = getJobHash(
1404       _jobId,
1405       _hirer,
1406       _contractor,
1407       _value,
1408       _fee);
1409 
1410     uint32 secondsToComplete = 0;
1411 
1412     if (jobEscrows[jobHash].exists) {
1413       secondsToComplete = jobEscrows[jobHash].secondsToComplete;
1414     }
1415     return secondsToComplete;
1416   }
1417 
1418   /**
1419    * @dev returns the agreed completion date of the requested job
1420    * Following parameters are used to regenerate the jobHash:
1421    * @param _jobId The unique ID of the job, from the CoinSparrow database
1422    * @param _hirer The wallet address of the hiring (buying) party
1423    * @param _contractor The wallet address of the contractor (selling) party
1424    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
1425    * @param _fee CoinSparrow fee for this job. Pre-calculated
1426    * @return agreedCompletionDate timestamp for agreed completion date
1427    */
1428 
1429   function getAgreedCompletionDate(
1430     bytes16 _jobId,
1431     address _hirer,
1432     address _contractor,
1433     uint256 _value,
1434     uint256 _fee) external view returns (uint32)
1435   {
1436     //get job Hash
1437     bytes32 jobHash = getJobHash(
1438       _jobId,
1439       _hirer,
1440       _contractor,
1441       _value,
1442       _fee);
1443 
1444     uint32 agreedCompletionDate = 0;
1445 
1446     if (jobEscrows[jobHash].exists) {
1447       agreedCompletionDate = jobEscrows[jobHash].agreedCompletionDate;
1448     }
1449     return agreedCompletionDate;
1450   }
1451 
1452   /**
1453    * @dev returns the actual completion date of the job of the requested job
1454    * Following parameters are used to regenerate the jobHash:
1455    * @param _jobId The unique ID of the job, from the CoinSparrow database
1456    * @param _hirer The wallet address of the hiring (buying) party
1457    * @param _contractor The wallet address of the contractor (selling) party
1458    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
1459    * @param _fee CoinSparrow fee for this job. Pre-calculated
1460    * @return jobCompleteDate timestamp for actual completion date
1461    */
1462 
1463   function getActualCompletionDate(
1464     bytes16 _jobId,
1465     address _hirer,
1466     address _contractor,
1467     uint256 _value,
1468     uint256 _fee) external view returns (uint32)
1469   {
1470     //get job Hash
1471     bytes32 jobHash = getJobHash(
1472       _jobId,
1473       _hirer,
1474       _contractor,
1475       _value,
1476       _fee);
1477 
1478     uint32 jobCompleteDate = 0;
1479 
1480     if (jobEscrows[jobHash].exists) {
1481       jobCompleteDate = jobEscrows[jobHash].jobCompleteDate;
1482     }
1483     return jobCompleteDate;
1484   }
1485 
1486   /**
1487    * @dev returns the value for the requested job
1488    * Following parameters are used to regenerate the jobHash:
1489    * @param _jobId The unique ID of the job, from the CoinSparrow database
1490    * @param _hirer The wallet address of the hiring (buying) party
1491    * @param _contractor The wallet address of the contractor (selling) party
1492    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
1493    * @param _fee CoinSparrow fee for this job. Pre-calculated
1494    * @return amount job's value
1495    */
1496 
1497   function getJobValue(
1498     bytes16 _jobId,
1499     address _hirer,
1500     address _contractor,
1501     uint256 _value,
1502     uint256 _fee) external view returns(uint256)
1503   {
1504     //get job Hash
1505     bytes32 jobHash = getJobHash(
1506       _jobId,
1507       _hirer,
1508       _contractor,
1509       _value,
1510       _fee);
1511 
1512     uint256 amount = 0;
1513     if (jobEscrows[jobHash].exists) {
1514       amount = hirerEscrowMap[_hirer][jobHash];
1515     }
1516     return amount;
1517   }
1518 
1519   /**
1520    * @dev Helper function to pre-validate mutual cancellation signatures. Used by front-end app
1521    * to let each party know that the other has signed off the agreed %
1522    * @param _contractorPercent percentage agreed upon
1523    * @param _sigMsg signed message to be validated
1524    * @param _signer wallet address of the message signer to validate against
1525    * @return bool whether or not the signature is valid
1526    */
1527   function validateRefundSignature(
1528     uint8 _contractorPercent,
1529     bytes _sigMsg,
1530     address _signer) external pure returns(bool)
1531   {
1532 
1533     return checkRefundSignature(_contractorPercent,_sigMsg,_signer);
1534 
1535   }
1536 
1537   /**
1538    * @dev Executes the actual signature verification.
1539    * @param _contractorPercent percentage agreed upon
1540    * @param _sigMsg signed message to be validated
1541    * @param _signer wallet address of the message signer to validate against
1542    * @return bool whether or not the signature is valid
1543    */
1544   function checkRefundSignature(
1545     uint8 _contractorPercent,
1546     bytes _sigMsg,
1547     address _signer) private pure returns(bool)
1548   {
1549     bytes32 percHash = keccak256(abi.encodePacked(_contractorPercent));
1550     bytes32 msgHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",percHash));
1551 
1552     address addr = ECRecovery.recover(msgHash,_sigMsg);
1553     return addr == _signer;
1554   }
1555 
1556   /**
1557    * @dev Generates the sha256 jobHash based on job parameters. Used in several functions
1558    * @param _jobId The unique ID of the job, from the CoinSparrow database
1559    * @param _hirer The wallet address of the hiring (buying) party
1560    * @param _contractor The wallet address of the contractor (selling) party
1561    * @param _value The ether amount being held in escrow. I.e. job cost - amount hirer is paying contractor
1562    * @param _fee CoinSparrow fee for this job. Pre-calculated
1563    * @return bytes32 the calculated jobHash value
1564    */
1565   function getJobHash(
1566     bytes16 _jobId,
1567     address _hirer,
1568     address _contractor,
1569     uint256 _value,
1570     uint256 _fee
1571   )  private pure returns(bytes32)
1572   {
1573     return keccak256(abi.encodePacked(
1574       _jobId,
1575       _hirer,
1576       _contractor,
1577       _value,
1578       _fee));
1579   }
1580 
1581 }