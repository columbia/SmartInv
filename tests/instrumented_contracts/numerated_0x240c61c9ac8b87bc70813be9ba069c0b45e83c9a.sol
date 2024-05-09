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
19   function getTotalContribution() external view returns(uint256);
20 
21   function getTotalFeesOffered() external view returns(uint256);
22 
23   function getProjectedFee(uint128 amountDisputed) external view returns(
24     uint128 feeNumerator,
25     uint128 fundsUsedFromBoundaryBucket
26   );
27 
28   function getOwner() external view returns(address);
29 
30   function isFinalized() external view returns(bool);
31 
32   /**
33    * Return value is how much REP and dispute tokens the contributor is entitled to.
34    *
35    * Does not change the state, as accounting is finalized at that moment.
36    *
37    * In case of partial fill, we round down, leaving some dust in the contract.
38    */
39   function calculateProceeds(address contributor) external view returns(
40     uint128 rep,
41     uint128 disputeTokens
42   );
43 
44   /**
45    * Calculate fee that will be split between contract admin and
46    * account that triggered dispute transaction.
47    *
48    * In case of partial fill, we round down, leaving some dust in the contract.
49    */
50   function calculateFees() external view returns(uint128);
51 
52   function addFeesOnTop(
53     uint128 amount,
54     uint128 feeNumerator
55   ) external pure returns(uint128);
56 }
57 
58 // File: contracts/IAccountingFactory.sol
59 
60 interface IAccountingFactory {
61   function create(address owner) external returns(IAccounting);
62 }
63 
64 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 interface IERC20 {
71   function totalSupply() external view returns (uint256);
72 
73   function balanceOf(address who) external view returns (uint256);
74 
75   function allowance(address owner, address spender)
76     external view returns (uint256);
77 
78   function transfer(address to, uint256 value) external returns (bool);
79 
80   function approve(address spender, uint256 value)
81     external returns (bool);
82 
83   function transferFrom(address from, address to, uint256 value)
84     external returns (bool);
85 
86   event Transfer(
87     address indexed from,
88     address indexed to,
89     uint256 value
90   );
91 
92   event Approval(
93     address indexed owner,
94     address indexed spender,
95     uint256 value
96   );
97 }
98 
99 // File: contracts/IDisputer.sol
100 
101 /**
102  * Interface of what the disputer contract should do.
103  *
104  * Its main responsibility to interact with Augur. Only minimal glue methods
105  * are added apart from that in order for crowdsourcer to be able to interact
106  * with it.
107  *
108  * This contract holds the actual crowdsourced REP for dispute, so it doesn't
109  * need to transfer it from elsewhere at the moment of dispute. It doesn't care
110  * at all who this REP belongs to, it just spends it for dispute. Accounting
111  * is done in other contracts.
112  */
113 interface IDisputer {
114   /**
115    * This function should use as little gas as possible, as it will be called
116    * during rush time. Unnecessary operations are postponed for later.
117    *
118    * Can by called by anyone, but only once.
119    */
120   function dispute(address feeReceiver) external;
121 
122   // intentionally can be called by anyone, as no user input is used
123   function approveManagerToSpendDisputeTokens() external;
124 
125   function getOwner() external view returns(address);
126 
127   function hasDisputed() external view returns(bool);
128 
129   function feeReceiver() external view returns(address);
130 
131   function getREP() external view returns(IERC20);
132 
133   function getDisputeTokenAddress() external view returns(IERC20);
134 }
135 
136 // File: contracts/augur/feeWindow.sol
137 
138 interface FeeWindow {
139   function getStartTime() external view returns(uint256);
140   function isOver() external view returns(bool);
141 }
142 
143 // File: contracts/augur/universe.sol
144 
145 interface Universe {
146   function getDisputeRoundDurationInSeconds() external view returns(uint256);
147 
148   function isForking() external view returns(bool);
149 
150   function isContainerForMarket(address _shadyMarket) external view returns(
151     bool
152   );
153 }
154 
155 // File: contracts/augur/reportingParticipant.sol
156 
157 /**
158  * This should've been an interface, but interfaces cannot inherit interfaces
159  */
160 contract ReportingParticipant is IERC20 {
161   function redeem(address _redeemer) external returns(bool);
162   function getStake() external view returns(uint256);
163   function getPayoutDistributionHash() external view returns(bytes32);
164   function getFeeWindow() external view returns(FeeWindow);
165 }
166 
167 // File: contracts/augur/market.sol
168 
169 interface Market {
170   function contribute(
171     uint256[] _payoutNumerators,
172     bool _invalid,
173     uint256 _amount
174   ) external returns(bool);
175 
176   function getReputationToken() external view returns(IERC20);
177 
178   function getUniverse() external view returns(Universe);
179 
180   function derivePayoutDistributionHash(
181     uint256[] _payoutNumerators,
182     bool _invalid
183   ) external view returns(bytes32);
184 
185   function getCrowdsourcer(
186     bytes32 _payoutDistributionHash
187   ) external view returns(ReportingParticipant);
188 
189   function getNumParticipants() external view returns(uint256);
190 
191   function getReportingParticipant(uint256 _index) external view returns(
192     ReportingParticipant
193   );
194 
195   function isFinalized() external view returns(bool);
196 
197   function getFeeWindow() external view returns(FeeWindow);
198 
199   function getWinningReportingParticipant() external view returns(
200     ReportingParticipant
201   );
202 
203   function isContainerForReportingParticipant(
204     ReportingParticipant _shadyReportingParticipant
205   ) external view returns(bool);
206 }
207 
208 // File: contracts/IDisputerFactory.sol
209 
210 interface IDisputerFactory {
211   event DisputerCreated(
212     address _owner,
213     IDisputer _address,
214     Market market,
215     uint256 feeWindowId,
216     uint256[] payoutNumerators,
217     bool invalid
218   );
219 
220   function create(
221     address owner,
222     Market market,
223     uint256 feeWindowId,
224     uint256[] payoutNumerators,
225     bool invalid
226   ) external returns(IDisputer);
227 }
228 
229 // File: contracts/ICrowdsourcerParent.sol
230 
231 /**
232  * Parent of a crowdsourcer that is passed into it on construction. Used
233  * to determine destination for fees.
234  */
235 interface ICrowdsourcerParent {
236   function getContractFeeReceiver() external view returns(address);
237 }
238 
239 // File: contracts/ICrowdsourcer.sol
240 
241 /**
242  * Crowdsourcer for specific market/outcome/round.
243  */
244 interface ICrowdsourcer {
245   event ContributionAccepted(
246     address contributor,
247     uint128 amount,
248     uint128 feeNumerator
249   );
250 
251   event ContributionWithdrawn(address contributor, uint128 amount);
252 
253   event CrowdsourcerFinalized(uint128 amountDisputeTokensAcquired);
254 
255   event ProceedsWithdrawn(
256     address contributor,
257     uint128 disputeTokensAmount,
258     uint128 repAmount
259   );
260 
261   event FeesWithdrawn(
262     address contractAuthor,
263     address executor,
264     uint128 contractAuthorAmount,
265     uint128 executorAmount
266   );
267 
268   event Initialized();
269 
270   // initialization stage
271   function initialize() external;
272 
273   // pre-dispute stage
274   function contribute(uint128 amount, uint128 feeNumerator) external;
275 
276   function withdrawContribution() external;
277 
278   // finalization (after dispute happened)
279   function finalize() external;
280 
281   // after finalization
282 
283   // intentionally anyone can call it, since they won't harm contributor
284   // by helping them withdraw their proceeds
285   function withdrawProceeds(address contributor) external;
286 
287   function withdrawFees() external;
288 
289   function hasDisputed() external view returns(bool);
290 
291   function isInitialized() external view returns(bool);
292 
293   function getParent() external view returns(ICrowdsourcerParent);
294 
295   function getDisputerParams() external view returns(
296     Market market,
297     uint256 feeWindowId,
298     uint256[] payoutNumerators,
299     bool invalid
300   );
301 
302   function getDisputer() external view returns(IDisputer);
303 
304   function getAccounting() external view returns(IAccounting);
305 
306   function getREP() external view returns(IERC20);
307 
308   function getDisputeToken() external view returns(IERC20);
309 
310   function isFinalized() external view returns(bool);
311 }
312 
313 // File: contracts/DisputerParams.sol
314 
315 library DisputerParams {
316   struct Params {
317     Market market;
318     uint256 feeWindowId;
319     uint256[] payoutNumerators;
320     bool invalid;
321   }
322 }
323 
324 // File: contracts/Crowdsourcer.sol
325 
326 contract Crowdsourcer is ICrowdsourcer {
327   bool public m_isInitialized = false;
328   DisputerParams.Params public m_disputerParams;
329   IAccountingFactory public m_accountingFactory;
330   IDisputerFactory public m_disputerFactory;
331 
332   IAccounting public m_accounting;
333   ICrowdsourcerParent public m_parent;
334   IDisputer public m_disputer;
335 
336   mapping(address => bool) public m_proceedsCollected;
337   bool public m_feesCollected = false;
338 
339   constructor(
340     ICrowdsourcerParent parent,
341     IAccountingFactory accountingFactory,
342     IDisputerFactory disputerFactory,
343     Market market,
344     uint256 feeWindowId,
345     uint256[] payoutNumerators,
346     bool invalid
347   ) public {
348     m_parent = parent;
349     m_accountingFactory = accountingFactory;
350     m_disputerFactory = disputerFactory;
351     m_disputerParams = DisputerParams.Params(
352       market,
353       feeWindowId,
354       payoutNumerators,
355       invalid
356     );
357   }
358 
359   modifier beforeDisputeOnly() {
360     require(!hasDisputed(), "Method only allowed before dispute");
361     _;
362   }
363 
364   modifier requiresInitialization() {
365     require(isInitialized(), "Must call initialize() first");
366     _;
367   }
368 
369   modifier requiresFinalization() {
370     if (!isFinalized()) {
371       finalize();
372       assert(isFinalized());
373     }
374     _;
375   }
376 
377   function initialize() external {
378     require(!m_isInitialized, "Already initialized");
379     m_isInitialized = true;
380     m_accounting = m_accountingFactory.create(this);
381     m_disputer = m_disputerFactory.create(
382       this,
383       m_disputerParams.market,
384       m_disputerParams.feeWindowId,
385       m_disputerParams.payoutNumerators,
386       m_disputerParams.invalid
387     );
388     emit Initialized();
389   }
390 
391   function contribute(
392     uint128 amount,
393     uint128 feeNumerator
394   ) external requiresInitialization beforeDisputeOnly {
395     uint128 amountWithFees = m_accounting.addFeesOnTop(amount, feeNumerator);
396 
397     IERC20 rep = getREP();
398     require(rep.balanceOf(msg.sender) >= amountWithFees, "Not enough funds");
399     require(
400       rep.allowance(msg.sender, this) >= amountWithFees,
401       "Now enough allowance"
402     );
403 
404     // record contribution in accounting (will perform validations)
405     uint128 deposited;
406     uint128 depositedFees;
407     (deposited, depositedFees) = m_accounting.contribute(
408       msg.sender,
409       amount,
410       feeNumerator
411     );
412 
413     assert(deposited == amount);
414     assert(deposited + depositedFees == amountWithFees);
415 
416     // actually transfer tokens and revert tx if any problem
417     assert(rep.transferFrom(msg.sender, m_disputer, deposited));
418     assert(rep.transferFrom(msg.sender, this, depositedFees));
419 
420     assertBalancesBeforeDispute();
421 
422     emit ContributionAccepted(msg.sender, amount, feeNumerator);
423   }
424 
425   function withdrawContribution(
426 
427   ) external requiresInitialization beforeDisputeOnly {
428     IERC20 rep = getREP();
429 
430     // record withdrawal in accounting (will perform validations)
431     uint128 withdrawn;
432     uint128 withdrawnFees;
433     (withdrawn, withdrawnFees) = m_accounting.withdrawContribution(msg.sender);
434 
435     // actually transfer tokens and revert tx if any problem
436     assert(rep.transferFrom(m_disputer, msg.sender, withdrawn));
437     assert(rep.transfer(msg.sender, withdrawnFees));
438 
439     assertBalancesBeforeDispute();
440 
441     emit ContributionWithdrawn(msg.sender, withdrawn);
442   }
443 
444   function withdrawProceeds(address contributor) external requiresFinalization {
445     require(
446       !m_proceedsCollected[contributor],
447       "Can only collect proceeds once"
448     );
449 
450     // record proceeds have been collected
451     m_proceedsCollected[contributor] = true;
452 
453     uint128 refund;
454     uint128 proceeds;
455 
456     // calculate how much this contributor is entitled to
457     (refund, proceeds) = m_accounting.calculateProceeds(contributor);
458 
459     IERC20 rep = getREP();
460     IERC20 disputeTokenAddress = getDisputeToken();
461 
462     // actually deliver the proceeds/refund
463     assert(rep.transfer(contributor, refund));
464     assert(disputeTokenAddress.transfer(contributor, proceeds));
465 
466     emit ProceedsWithdrawn(contributor, proceeds, refund);
467   }
468 
469   function withdrawFees() external requiresFinalization {
470     require(!m_feesCollected, "Can only collect fees once");
471 
472     m_feesCollected = true;
473 
474     uint128 feesTotal = m_accounting.calculateFees();
475     // 10% of fees go to contract author
476     uint128 feesForContractAuthor = feesTotal / 10;
477     uint128 feesForExecutor = feesTotal - feesForContractAuthor;
478 
479     assert(feesForContractAuthor + feesForExecutor == feesTotal);
480 
481     address contractFeesRecipient = m_parent.getContractFeeReceiver();
482     address executorFeesRecipient = m_disputer.feeReceiver();
483 
484     IERC20 rep = getREP();
485 
486     assert(rep.transfer(contractFeesRecipient, feesForContractAuthor));
487     assert(rep.transfer(executorFeesRecipient, feesForExecutor));
488 
489     emit FeesWithdrawn(
490       contractFeesRecipient,
491       executorFeesRecipient,
492       feesForContractAuthor,
493       feesForExecutor
494     );
495   }
496 
497   function getParent() external view returns(ICrowdsourcerParent) {
498     return m_parent;
499   }
500 
501   function getDisputerParams() external view returns(
502     Market market,
503     uint256 feeWindowId,
504     uint256[] payoutNumerators,
505     bool invalid
506   ) {
507     return (m_disputerParams.market, m_disputerParams.feeWindowId, m_disputerParams.payoutNumerators, m_disputerParams.invalid);
508   }
509 
510   function getDisputer() external view requiresInitialization returns(
511     IDisputer
512   ) {
513     return m_disputer;
514   }
515 
516   function getAccounting() external view requiresInitialization returns(
517     IAccounting
518   ) {
519     return m_accounting;
520   }
521 
522   function finalize() public requiresInitialization {
523     require(hasDisputed(), "Can only finalize after dispute");
524     require(!isFinalized(), "Can only finalize once");
525 
526     // now that we've disputed we must know dispute token address
527     IERC20 disputeTokenAddress = getDisputeToken();
528     IERC20 rep = getREP();
529 
530     m_disputer.approveManagerToSpendDisputeTokens();
531 
532     // retrieve all tokens from disputer for proceeds distribution
533     // This wouldn't work extremely well if it is called from disputer's
534     // dispute() method, but it should only call Augur which we trust.
535     assert(rep.transferFrom(m_disputer, this, rep.balanceOf(m_disputer)));
536     assert(
537       disputeTokenAddress.transferFrom(
538         m_disputer,
539         this,
540         disputeTokenAddress.balanceOf(m_disputer)
541       )
542     );
543 
544     uint256 amountDisputed = disputeTokenAddress.balanceOf(this);
545     uint128 amountDisputed128 = uint128(amountDisputed);
546 
547     // REP has only so many tokens
548     assert(amountDisputed128 == amountDisputed);
549 
550     m_accounting.finalize(amountDisputed128);
551 
552     assert(isFinalized());
553 
554     emit CrowdsourcerFinalized(amountDisputed128);
555   }
556 
557   function isInitialized() public view returns(bool) {
558     return m_isInitialized;
559   }
560 
561   function getREP() public view requiresInitialization returns(IERC20) {
562     return m_disputer.getREP();
563   }
564 
565   function getDisputeToken() public view requiresInitialization returns(
566     IERC20
567   ) {
568     return m_disputer.getDisputeTokenAddress();
569   }
570 
571   function hasDisputed() public view requiresInitialization returns(bool) {
572     return m_disputer.hasDisputed();
573   }
574 
575   function isFinalized() public view requiresInitialization returns(bool) {
576     return m_accounting.isFinalized();
577   }
578 
579   function assertBalancesBeforeDispute() internal view {
580     IERC20 rep = getREP();
581     assert(rep.balanceOf(m_disputer) >= m_accounting.getTotalContribution());
582     assert(rep.balanceOf(this) >= m_accounting.getTotalFeesOffered());
583   }
584 }
585 
586 // File: contracts/CrowdsourcerFactory.sol
587 
588 /**
589  * NOTE: the created crowdsourcers trust the market that was passed in constructor.
590  * If a malicious market is passed in, all bets are off.
591  *
592  * Individual crowdsourcers have no trust relationships with each other.
593  */
594 contract CrowdsourcerFactory is ICrowdsourcerParent {
595   event CrowdsourcerCreated(
596     ICrowdsourcer crowdsourcer,
597     Market market,
598     uint256 feeWindowId,
599     uint256[] payoutNumerators,
600     bool invalid
601   );
602 
603   IAccountingFactory public m_accountingFactory;
604   IDisputerFactory public m_disputerFactory;
605 
606   address public m_feeCollector;
607   mapping(bytes32 => ICrowdsourcer) public m_crowdsourcers;
608   mapping(uint256 => ICrowdsourcer[]) private m_crowdsourcersPerFeeWindow;
609 
610   constructor(
611     IAccountingFactory accountingFactory,
612     IDisputerFactory disputerFactory,
613     address feeCollector
614   ) public {
615     m_accountingFactory = accountingFactory;
616     m_disputerFactory = disputerFactory;
617     m_feeCollector = feeCollector;
618   }
619 
620   function transferFeeCollection(address recipient) external {
621     require(msg.sender == m_feeCollector, "Not authorized");
622     m_feeCollector = recipient;
623   }
624 
625   function getInitializedCrowdsourcer(
626     Market market,
627     uint256 feeWindowId,
628     uint256[] payoutNumerators,
629     bool invalid
630   ) external returns(ICrowdsourcer) {
631     ICrowdsourcer crowdsourcer = getCrowdsourcer(
632       market,
633       feeWindowId,
634       payoutNumerators,
635       invalid
636     );
637     if (!crowdsourcer.isInitialized()) {
638       crowdsourcer.initialize();
639       assert(crowdsourcer.isInitialized());
640     }
641     return crowdsourcer;
642   }
643 
644   function getContractFeeReceiver() external view returns(address) {
645     return m_feeCollector;
646   }
647 
648   function maybeGetCrowdsourcer(
649     Market market,
650     uint256 feeWindowId,
651     uint256[] payoutNumerators,
652     bool invalid
653   ) external view returns(ICrowdsourcer) {
654     bytes32 paramsHash = hashParams(
655       market,
656       feeWindowId,
657       payoutNumerators,
658       invalid
659     );
660     return m_crowdsourcers[paramsHash];
661   }
662 
663   function getCrowdsourcer(
664     Market market,
665     uint256 feeWindowId,
666     uint256[] payoutNumerators,
667     bool invalid
668   ) public returns(ICrowdsourcer) {
669     bytes32 paramsHash = hashParams(
670       market,
671       feeWindowId,
672       payoutNumerators,
673       invalid
674     );
675     ICrowdsourcer existing = m_crowdsourcers[paramsHash];
676     if (address(existing) != 0) {
677       return existing;
678     }
679     ICrowdsourcer created = new Crowdsourcer(
680       this,
681       m_accountingFactory,
682       m_disputerFactory,
683       market,
684       feeWindowId,
685       payoutNumerators,
686       invalid
687     );
688     emit CrowdsourcerCreated(
689       created,
690       market,
691       feeWindowId,
692       payoutNumerators,
693       invalid
694     );
695     m_crowdsourcersPerFeeWindow[feeWindowId].push(created);
696     m_crowdsourcers[paramsHash] = created;
697     return created;
698   }
699 
700   function findCrowdsourcer(
701     uint256 feeWindowId,
702     uint256 startFrom,
703     uint256 minFeesOffered,
704     ICrowdsourcer[] exclude
705   ) public view returns(uint256, ICrowdsourcer) {
706     ICrowdsourcer[] storage crowdsourcers = m_crowdsourcersPerFeeWindow[feeWindowId];
707     uint256 n = crowdsourcers.length;
708     uint256 i;
709 
710     for (i = startFrom; i < n; ++i) {
711       ICrowdsourcer candidate = crowdsourcers[i];
712 
713       if (!candidate.isInitialized() || candidate.getAccounting(
714 
715       ).getTotalFeesOffered() < minFeesOffered) {
716         continue;
717       }
718 
719       bool isGood = true;
720       for (uint256 j = 0; j < exclude.length; ++j) {
721         if (candidate == exclude[j]) {
722           isGood = false;
723           break;
724         }
725       }
726 
727       if (isGood) {
728         return (i, candidate);
729       }
730     }
731 
732     return (i, ICrowdsourcer(0));
733   }
734 
735   function getNumCrowdsourcers(uint256 feeWindowId) public view returns(
736     uint256
737   ) {
738     return m_crowdsourcersPerFeeWindow[feeWindowId].length;
739   }
740 
741   function hashParams(
742     Market market,
743     uint256 feeWindowId,
744     uint256[] payoutNumerators,
745     bool invalid
746   ) public pure returns(bytes32) {
747     return keccak256(
748       abi.encodePacked(market, feeWindowId, payoutNumerators, invalid)
749     );
750   }
751 }