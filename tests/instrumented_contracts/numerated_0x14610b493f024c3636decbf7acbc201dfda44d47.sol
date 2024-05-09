1 pragma solidity 0.4.24;
2 
3 // File: contracts/IAccounting.sol
4 
5 interface IAccounting {
6   function contribute(
7     address contributor,
8     uint128 amount,
9     uint128 feeNumerator
10   ) external returns(uint128 deposited, uint128 depositedFees);
11 
12   function withdrawContribution(address contributor) external returns(
13     uint128 withdrawn,
14     uint128 withdrawnFees
15   );
16 
17   function finalize(uint128 amountDisputed) external;
18 
19   function getOwner() external view returns(address);
20 
21   function isFinalized() external view returns(bool);
22 
23   /**
24    * Return value is how much REP and dispute tokens the contributor is entitled to.
25    *
26    * Does not change the state, as accounting is finalized at that moment.
27    *
28    * In case of partial fill, we round down, leaving some dust in the contract.
29    */
30   function calculateProceeds(address contributor) external view returns(
31     uint128 rep,
32     uint128 disputeTokens
33   );
34 
35   /**
36    * Calculate fee that will be split between contract admin and
37    * account that triggered dispute transaction.
38    *
39    * In case of partial fill, we round down, leaving some dust in the contract.
40    */
41   function calculateFees() external view returns(uint128);
42 
43   function addFeesOnTop(
44     uint128 amount,
45     uint128 feeNumerator
46   ) external pure returns(uint128);
47 }
48 
49 // File: contracts/IAccountingFactory.sol
50 
51 interface IAccountingFactory {
52   function create(address owner) external returns(IAccounting);
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 interface IERC20 {
62   function totalSupply() external view returns (uint256);
63 
64   function balanceOf(address who) external view returns (uint256);
65 
66   function allowance(address owner, address spender)
67     external view returns (uint256);
68 
69   function transfer(address to, uint256 value) external returns (bool);
70 
71   function approve(address spender, uint256 value)
72     external returns (bool);
73 
74   function transferFrom(address from, address to, uint256 value)
75     external returns (bool);
76 
77   event Transfer(
78     address indexed from,
79     address indexed to,
80     uint256 value
81   );
82 
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: contracts/IDisputer.sol
91 
92 /**
93  * Interface of what the disputer contract should do.
94  *
95  * Its main responsibility to interact with Augur. Only minimal glue methods
96  * are added apart from that in order for crowdsourcer to be able to interact
97  * with it.
98  *
99  * This contract holds the actual crowdsourced REP for dispute, so it doesn't
100  * need to transfer it from elsewhere at the moment of dispute. It doesn't care
101  * at all who this REP belongs to, it just spends it for dispute. Accounting
102  * is done in other contracts.
103  */
104 interface IDisputer {
105   /**
106    * This function should use as little gas as possible, as it will be called
107    * during rush time. Unnecessary operations are postponed for later.
108    *
109    * Can by called by anyone, but only once.
110    */
111   function dispute(address feeReceiver) external;
112 
113   // intentionally can be called by anyone, as no user input is used
114   function approveManagerToSpendDisputeTokens() external;
115 
116   function getOwner() external view returns(address);
117 
118   function hasDisputed() external view returns(bool);
119 
120   function feeReceiver() external view returns(address);
121 
122   function getREP() external view returns(IERC20);
123 
124   function getDisputeTokenAddress() external view returns(IERC20);
125 }
126 
127 // File: contracts/augur/feeWindow.sol
128 
129 interface FeeWindow {
130   function getStartTime() external view returns(uint256);
131 }
132 
133 // File: contracts/augur/universe.sol
134 
135 interface Universe {
136   function getDisputeRoundDurationInSeconds() external view returns(uint256);
137   function isForking() external view returns(bool);
138 }
139 
140 // File: contracts/augur/reportingParticipant.sol
141 
142 /**
143  * This should've been an interface, but interfaces cannot inherit interfaces
144  */
145 contract ReportingParticipant is IERC20 {
146   function getStake() external view returns(uint256);
147   function getPayoutDistributionHash() external view returns(bytes32);
148 }
149 
150 // File: contracts/augur/market.sol
151 
152 interface Market {
153   function contribute(
154     uint256[] _payoutNumerators,
155     bool _invalid,
156     uint256 _amount
157   ) external returns(bool);
158 
159   function getReputationToken() external view returns(IERC20);
160 
161   function getUniverse() external view returns(Universe);
162 
163   function derivePayoutDistributionHash(
164     uint256[] _payoutNumerators,
165     bool _invalid
166   ) external view returns(bytes32);
167 
168   function getCrowdsourcer(
169     bytes32 _payoutDistributionHash
170   ) external view returns(ReportingParticipant);
171 
172   function getNumParticipants() external view returns(uint256);
173 
174   function getReportingParticipant(uint256 _index) external view returns(
175     ReportingParticipant
176   );
177 
178   function isFinalized() external view returns(bool);
179 
180   function getFeeWindow() external view returns(FeeWindow);
181 
182   function getWinningReportingParticipant() external view returns(
183     ReportingParticipant
184   );
185 }
186 
187 // File: contracts/IDisputerFactory.sol
188 
189 interface IDisputerFactory {
190   event DisputerCreated(
191     address _owner,
192     IDisputer _address,
193     Market market,
194     uint256 feeWindowId,
195     uint256[] payoutNumerators,
196     bool invalid
197   );
198 
199   function create(
200     address owner,
201     Market market,
202     uint256 feeWindowId,
203     uint256[] payoutNumerators,
204     bool invalid
205   ) external returns(IDisputer);
206 }
207 
208 // File: contracts/ICrowdsourcerParent.sol
209 
210 /**
211  * Parent of a crowdsourcer that is passed into it on construction. Used
212  * to determine destination for fees.
213  */
214 interface ICrowdsourcerParent {
215   function getContractFeeReceiver() external view returns(address);
216 }
217 
218 // File: contracts/ICrowdsourcer.sol
219 
220 /**
221  * Crowdsourcer for specific market/outcome/round.
222  */
223 interface ICrowdsourcer {
224   event ContributionAccepted(
225     address contributor,
226     uint128 amount,
227     uint128 feeNumerator
228   );
229 
230   event ContributionWithdrawn(address contributor, uint128 amount);
231 
232   event CrowdsourcerFinalized(uint128 amountDisputeTokensAcquired);
233 
234   event ProceedsWithdrawn(
235     address contributor,
236     uint128 disputeTokensAmount,
237     uint128 repAmount
238   );
239 
240   event FeesWithdrawn(
241     address contractAuthor,
242     address executor,
243     uint128 contractAuthorAmount,
244     uint128 executorAmount
245   );
246 
247   event Initialized();
248 
249   // initialization stage
250   function initialize() external;
251 
252   // pre-dispute stage
253   function contribute(uint128 amount, uint128 feeNumerator) external;
254 
255   function withdrawContribution() external;
256 
257   // finalization (after dispute happened)
258   function finalize() external;
259 
260   // after finalization
261 
262   // intentionally anyone can call it, since they won't harm contributor
263   // by helping them withdraw their proceeds
264   function withdrawProceeds(address contributor) external;
265 
266   function withdrawFees() external;
267 
268   function hasDisputed() external view returns(bool);
269 
270   function isInitialized() external view returns(bool);
271 
272   function getParent() external view returns(ICrowdsourcerParent);
273 
274   function getDisputer() external view returns(IDisputer);
275 
276   function getAccounting() external view returns(IAccounting);
277 
278   function getREP() external view returns(IERC20);
279 
280   function getDisputeToken() external view returns(IERC20);
281 
282   function isFinalized() external view returns(bool);
283 }
284 
285 // File: contracts/DisputerParams.sol
286 
287 library DisputerParams {
288   struct Params {
289     Market market;
290     uint256 feeWindowId;
291     uint256[] payoutNumerators;
292     bool invalid;
293   }
294 }
295 
296 // File: contracts/Crowdsourcer.sol
297 
298 contract Crowdsourcer is ICrowdsourcer {
299   bool public m_isInitialized = false;
300   DisputerParams.Params public m_disputerParams;
301   IAccountingFactory public m_accountingFactory;
302   IDisputerFactory public m_disputerFactory;
303 
304   IAccounting public m_accounting;
305   ICrowdsourcerParent public m_parent;
306   IDisputer public m_disputer;
307 
308   mapping(address => bool) public m_proceedsCollected;
309   bool public m_feesCollected = false;
310 
311   constructor(
312     ICrowdsourcerParent parent,
313     IAccountingFactory accountingFactory,
314     IDisputerFactory disputerFactory,
315     Market market,
316     uint256 feeWindowId,
317     uint256[] payoutNumerators,
318     bool invalid
319   ) public {
320     m_parent = parent;
321     m_accountingFactory = accountingFactory;
322     m_disputerFactory = disputerFactory;
323     m_disputerParams = DisputerParams.Params(
324       market,
325       feeWindowId,
326       payoutNumerators,
327       invalid
328     );
329   }
330 
331   modifier beforeDisputeOnly() {
332     require(!hasDisputed(), "Method only allowed before dispute");
333     _;
334   }
335 
336   modifier requiresInitialization() {
337     require(isInitialized(), "Must call initialize() first");
338     _;
339   }
340 
341   modifier requiresFinalization() {
342     if (!isFinalized()) {
343       finalize();
344       assert(isFinalized());
345     }
346     _;
347   }
348 
349   function initialize() external {
350     require(!m_isInitialized, "Already initialized");
351     m_isInitialized = true;
352     m_accounting = m_accountingFactory.create(this);
353     m_disputer = m_disputerFactory.create(
354       this,
355       m_disputerParams.market,
356       m_disputerParams.feeWindowId,
357       m_disputerParams.payoutNumerators,
358       m_disputerParams.invalid
359     );
360     emit Initialized();
361   }
362 
363   function contribute(
364     uint128 amount,
365     uint128 feeNumerator
366   ) external requiresInitialization beforeDisputeOnly {
367     uint128 amountWithFees = m_accounting.addFeesOnTop(amount, feeNumerator);
368 
369     IERC20 rep = getREP();
370     require(rep.balanceOf(msg.sender) >= amountWithFees, "Not enough funds");
371     require(
372       rep.allowance(msg.sender, this) >= amountWithFees,
373       "Now enough allowance"
374     );
375 
376     // record contribution in accounting (will perform validations)
377     uint128 deposited;
378     uint128 depositedFees;
379     (deposited, depositedFees) = m_accounting.contribute(
380       msg.sender,
381       amount,
382       feeNumerator
383     );
384 
385     assert(deposited == amount);
386     assert(deposited + depositedFees == amountWithFees);
387 
388     // actually transfer tokens and revert tx if any problem
389     assert(rep.transferFrom(msg.sender, m_disputer, deposited));
390     assert(rep.transferFrom(msg.sender, this, depositedFees));
391 
392     emit ContributionAccepted(msg.sender, amount, feeNumerator);
393   }
394 
395   function withdrawContribution(
396 
397   ) external requiresInitialization beforeDisputeOnly {
398     IERC20 rep = getREP();
399 
400     // record withdrawal in accounting (will perform validations)
401     uint128 withdrawn;
402     uint128 withdrawnFees;
403     (withdrawn, withdrawnFees) = m_accounting.withdrawContribution(msg.sender);
404 
405     // actually transfer tokens and revert tx if any problem
406     assert(rep.transferFrom(m_disputer, msg.sender, withdrawn));
407     assert(rep.transfer(msg.sender, withdrawnFees));
408 
409     emit ContributionWithdrawn(msg.sender, withdrawn);
410   }
411 
412   function withdrawProceeds(address contributor) external requiresFinalization {
413     require(
414       !m_proceedsCollected[contributor],
415       "Can only collect proceeds once"
416     );
417 
418     // record proceeds have been collected
419     m_proceedsCollected[contributor] = true;
420 
421     uint128 refund;
422     uint128 proceeds;
423 
424     // calculate how much this contributor is entitled to
425     (refund, proceeds) = m_accounting.calculateProceeds(contributor);
426 
427     IERC20 rep = getREP();
428     IERC20 disputeTokenAddress = getDisputeToken();
429 
430     // actually deliver the proceeds/refund
431     assert(rep.transfer(contributor, refund));
432     assert(disputeTokenAddress.transfer(contributor, proceeds));
433 
434     emit ProceedsWithdrawn(contributor, proceeds, refund);
435   }
436 
437   function withdrawFees() external requiresFinalization {
438     require(!m_feesCollected, "Can only collect fees once");
439 
440     m_feesCollected = true;
441 
442     uint128 feesTotal = m_accounting.calculateFees();
443     // 10% of fees go to contract author
444     uint128 feesForContractAuthor = feesTotal / 10;
445     uint128 feesForExecutor = feesTotal - feesForContractAuthor;
446 
447     assert(feesForContractAuthor + feesForExecutor == feesTotal);
448 
449     address contractFeesRecipient = m_parent.getContractFeeReceiver();
450     address executorFeesRecipient = m_disputer.feeReceiver();
451 
452     IERC20 rep = getREP();
453 
454     assert(rep.transfer(contractFeesRecipient, feesForContractAuthor));
455     assert(rep.transfer(executorFeesRecipient, feesForExecutor));
456 
457     emit FeesWithdrawn(
458       contractFeesRecipient,
459       executorFeesRecipient,
460       feesForContractAuthor,
461       feesForExecutor
462     );
463   }
464 
465   function getParent() external view returns(ICrowdsourcerParent) {
466     return m_parent;
467   }
468 
469   function getDisputer() external view requiresInitialization returns(
470     IDisputer
471   ) {
472     return m_disputer;
473   }
474 
475   function getAccounting() external view requiresInitialization returns(
476     IAccounting
477   ) {
478     return m_accounting;
479   }
480 
481   function finalize() public requiresInitialization {
482     require(hasDisputed(), "Can only finalize after dispute");
483     require(!isFinalized(), "Can only finalize once");
484 
485     // now that we've disputed we must know dispute token address
486     IERC20 disputeTokenAddress = getDisputeToken();
487     IERC20 rep = getREP();
488 
489     m_disputer.approveManagerToSpendDisputeTokens();
490 
491     // retrieve all tokens from disputer for proceeds distribution
492     // This wouldn't work extremely well if it is called from disputer's
493     // dispute() method, but it should only call Augur which we trust.
494     assert(rep.transferFrom(m_disputer, this, rep.balanceOf(m_disputer)));
495     assert(
496       disputeTokenAddress.transferFrom(
497         m_disputer,
498         this,
499         disputeTokenAddress.balanceOf(m_disputer)
500       )
501     );
502 
503     uint256 amountDisputed = disputeTokenAddress.balanceOf(this);
504     uint128 amountDisputed128 = uint128(amountDisputed);
505 
506     // REP has only so many tokens
507     assert(amountDisputed128 == amountDisputed);
508 
509     m_accounting.finalize(amountDisputed128);
510 
511     assert(isFinalized());
512 
513     emit CrowdsourcerFinalized(amountDisputed128);
514   }
515 
516   function isInitialized() public view returns(bool) {
517     return m_isInitialized;
518   }
519 
520   function getREP() public view requiresInitialization returns(IERC20) {
521     return m_disputer.getREP();
522   }
523 
524   function getDisputeToken() public view requiresInitialization returns(
525     IERC20
526   ) {
527     return m_disputer.getDisputeTokenAddress();
528   }
529 
530   function hasDisputed() public view requiresInitialization returns(bool) {
531     return m_disputer.hasDisputed();
532   }
533 
534   function isFinalized() public view requiresInitialization returns(bool) {
535     return m_accounting.isFinalized();
536   }
537 }
538 
539 // File: contracts/CrowdsourcerFactory.sol
540 
541 /**
542  * NOTE: the created crowdsourcers trust the market that was passed in constructor.
543  * If a malicious market is passed in, all bets are off.
544  *
545  * Individual crowdsourcers have no trust relationships with each other.
546  */
547 contract CrowdsourcerFactory is ICrowdsourcerParent {
548   event CrowdsourcerCreated(
549     ICrowdsourcer crowdsourcer,
550     Market market,
551     uint256 feeWindowId,
552     uint256[] payoutNumerators,
553     bool invalid
554   );
555 
556   IAccountingFactory public m_accountingFactory;
557   IDisputerFactory public m_disputerFactory;
558 
559   address public m_feeCollector;
560   mapping(bytes32 => ICrowdsourcer) public m_crowdsourcers;
561 
562   constructor(
563     IAccountingFactory accountingFactory,
564     IDisputerFactory disputerFactory,
565     address feeCollector
566   ) public {
567     m_accountingFactory = accountingFactory;
568     m_disputerFactory = disputerFactory;
569     m_feeCollector = feeCollector;
570   }
571 
572   function transferFeeCollection(address recipient) external {
573     require(msg.sender == m_feeCollector, "Not authorized");
574     m_feeCollector = recipient;
575   }
576 
577   function getInitializedCrowdsourcer(
578     Market market,
579     uint256 feeWindowId,
580     uint256[] payoutNumerators,
581     bool invalid
582   ) external returns(ICrowdsourcer) {
583     ICrowdsourcer crowdsourcer = getCrowdsourcer(
584       market,
585       feeWindowId,
586       payoutNumerators,
587       invalid
588     );
589     if (!crowdsourcer.isInitialized()) {
590       crowdsourcer.initialize();
591       assert(crowdsourcer.isInitialized());
592     }
593     return crowdsourcer;
594   }
595 
596   function getContractFeeReceiver() external view returns(address) {
597     return m_feeCollector;
598   }
599 
600   function maybeGetCrowdsourcer(
601     Market market,
602     uint256 feeWindowId,
603     uint256[] payoutNumerators,
604     bool invalid
605   ) external view returns(ICrowdsourcer) {
606     bytes32 paramsHash = hashParams(
607       market,
608       feeWindowId,
609       payoutNumerators,
610       invalid
611     );
612     return m_crowdsourcers[paramsHash];
613   }
614 
615   function getCrowdsourcer(
616     Market market,
617     uint256 feeWindowId,
618     uint256[] payoutNumerators,
619     bool invalid
620   ) public returns(ICrowdsourcer) {
621     bytes32 paramsHash = hashParams(
622       market,
623       feeWindowId,
624       payoutNumerators,
625       invalid
626     );
627     ICrowdsourcer existing = m_crowdsourcers[paramsHash];
628     if (address(existing) != 0) {
629       return existing;
630     }
631     ICrowdsourcer created = new Crowdsourcer(
632       this,
633       m_accountingFactory,
634       m_disputerFactory,
635       market,
636       feeWindowId,
637       payoutNumerators,
638       invalid
639     );
640     emit CrowdsourcerCreated(
641       created,
642       market,
643       feeWindowId,
644       payoutNumerators,
645       invalid
646     );
647     m_crowdsourcers[paramsHash] = created;
648     return created;
649   }
650 
651   function hashParams(
652     Market market,
653     uint256 feeWindowId,
654     uint256[] payoutNumerators,
655     bool invalid
656   ) public pure returns(bytes32) {
657     return keccak256(
658       abi.encodePacked(market, feeWindowId, payoutNumerators, invalid)
659     );
660   }
661 }