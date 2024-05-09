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
136 // File: contracts/ICrowdsourcerParent.sol
137 
138 /**
139  * Parent of a crowdsourcer that is passed into it on construction. Used
140  * to determine destination for fees.
141  */
142 interface ICrowdsourcerParent {
143   function getContractFeeReceiver() external view returns(address);
144 }
145 
146 // File: contracts/augur/feeWindow.sol
147 
148 interface FeeWindow {
149   function getStartTime() external view returns(uint256);
150   function isOver() external view returns(bool);
151 }
152 
153 // File: contracts/augur/universe.sol
154 
155 interface Universe {
156   function getDisputeRoundDurationInSeconds() external view returns(uint256);
157 
158   function isForking() external view returns(bool);
159 
160   function isContainerForMarket(address _shadyMarket) external view returns(
161     bool
162   );
163 }
164 
165 // File: contracts/augur/reportingParticipant.sol
166 
167 /**
168  * This should've been an interface, but interfaces cannot inherit interfaces
169  */
170 contract ReportingParticipant is IERC20 {
171   function redeem(address _redeemer) external returns(bool);
172   function getStake() external view returns(uint256);
173   function getPayoutDistributionHash() external view returns(bytes32);
174   function getFeeWindow() external view returns(FeeWindow);
175 }
176 
177 // File: contracts/augur/market.sol
178 
179 interface Market {
180   function contribute(
181     uint256[] _payoutNumerators,
182     bool _invalid,
183     uint256 _amount
184   ) external returns(bool);
185 
186   function getReputationToken() external view returns(IERC20);
187 
188   function getUniverse() external view returns(Universe);
189 
190   function derivePayoutDistributionHash(
191     uint256[] _payoutNumerators,
192     bool _invalid
193   ) external view returns(bytes32);
194 
195   function getCrowdsourcer(
196     bytes32 _payoutDistributionHash
197   ) external view returns(ReportingParticipant);
198 
199   function getNumParticipants() external view returns(uint256);
200 
201   function getReportingParticipant(uint256 _index) external view returns(
202     ReportingParticipant
203   );
204 
205   function isFinalized() external view returns(bool);
206 
207   function getFeeWindow() external view returns(FeeWindow);
208 
209   function getWinningReportingParticipant() external view returns(
210     ReportingParticipant
211   );
212 
213   function isContainerForReportingParticipant(
214     ReportingParticipant _shadyReportingParticipant
215   ) external view returns(bool);
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
274   function getDisputerParams() external view returns(
275     Market market,
276     uint256 feeWindowId,
277     uint256[] payoutNumerators,
278     bool invalid
279   );
280 
281   function getDisputer() external view returns(IDisputer);
282 
283   function getAccounting() external view returns(IAccounting);
284 
285   function getREP() external view returns(IERC20);
286 
287   function getDisputeToken() external view returns(IERC20);
288 
289   function isFinalized() external view returns(bool);
290 }
291 
292 // File: contracts/IDisputerFactory.sol
293 
294 interface IDisputerFactory {
295   event DisputerCreated(
296     address _owner,
297     IDisputer _address,
298     Market market,
299     uint256 feeWindowId,
300     uint256[] payoutNumerators,
301     bool invalid
302   );
303 
304   function create(
305     address owner,
306     Market market,
307     uint256 feeWindowId,
308     uint256[] payoutNumerators,
309     bool invalid
310   ) external returns(IDisputer);
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