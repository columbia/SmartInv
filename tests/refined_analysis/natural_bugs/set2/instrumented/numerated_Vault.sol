1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 
8 import "../../interfaces/IVault.sol";
9 import "../../interfaces/IVaultReserve.sol";
10 import "../../interfaces/IController.sol";
11 import "../../interfaces/IStrategy.sol";
12 
13 import "../../libraries/ScaledMath.sol";
14 import "../../libraries/Errors.sol";
15 import "../../libraries/EnumerableExtensions.sol";
16 import "../../libraries/AddressProviderHelpers.sol";
17 
18 import "./VaultStorage.sol";
19 import "../utils/Preparable.sol";
20 import "../utils/IPausable.sol";
21 import "../access/Authorization.sol";
22 
23 abstract contract Vault is IVault, Authorization, VaultStorageV1, Preparable, Initializable {
24     using ScaledMath for uint256;
25     using SafeERC20 for IERC20;
26     using EnumerableSet for EnumerableSet.AddressSet;
27     using EnumerableExtensions for EnumerableSet.AddressSet;
28     using EnumerableMapping for EnumerableMapping.AddressToUintMap;
29     using EnumerableExtensions for EnumerableMapping.AddressToUintMap;
30     using AddressProviderHelpers for IAddressProvider;
31 
32     bytes32 internal constant _STRATEGY_KEY = "Strategy";
33     bytes32 internal constant _PERFORMANCE_FEE_KEY = "PerformanceFee";
34     bytes32 internal constant _STRATEGIST_FEE_KEY = "StrategistFee";
35     bytes32 internal constant _DEBT_LIMIT_KEY = "DebtLimit";
36     bytes32 internal constant _TARGET_ALLOCATION_KEY = "TargetAllocation";
37     bytes32 internal constant _RESERVE_FEE_KEY = "ReserveFee";
38     bytes32 internal constant _BOUND_KEY = "Bound";
39 
40     uint256 internal constant _INITIAL_RESERVE_FEE = 0.01e18;
41     uint256 internal constant _INITIAL_STRATEGIST_FEE = 0.1e18;
42     uint256 internal constant _INITIAL_PERFORMANCE_FEE = 0;
43 
44     uint256 public constant MAX_PERFORMANCE_FEE = 0.5e18;
45     uint256 public constant MAX_DEVIATION_BOUND = 0.5e18;
46     uint256 public constant STRATEGY_DELAY = 5 days;
47 
48     IController public immutable controller;
49     IAddressProvider public immutable addressProvider;
50     IVaultReserve public immutable reserve;
51 
52     modifier onlyPool() {
53         require(msg.sender == pool, Error.UNAUTHORIZED_ACCESS);
54         _;
55     }
56 
57     modifier onlyPoolOrGovernance() {
58         require(
59             msg.sender == pool || _roleManager().hasRole(Roles.GOVERNANCE, msg.sender),
60             Error.UNAUTHORIZED_ACCESS
61         );
62         _;
63     }
64 
65     modifier onlyPoolOrMaintenance() {
66         require(
67             msg.sender == pool || _roleManager().hasRole(Roles.MAINTENANCE, msg.sender),
68             Error.UNAUTHORIZED_ACCESS
69         );
70         _;
71     }
72 
73     constructor(IController _controller)
74         Authorization(_controller.addressProvider().getRoleManager())
75     {
76         controller = _controller;
77         IAddressProvider addressProvider_ = _controller.addressProvider();
78         addressProvider = addressProvider_;
79         reserve = IVaultReserve(addressProvider_.getVaultReserve());
80     }
81 
82     function _initialize(
83         address _pool,
84         uint256 _debtLimit,
85         uint256 _targetAllocation,
86         uint256 _bound
87     ) internal {
88         require(_debtLimit <= ScaledMath.ONE, Error.INVALID_AMOUNT);
89         require(_targetAllocation <= ScaledMath.ONE, Error.INVALID_AMOUNT);
90         require(_bound <= MAX_DEVIATION_BOUND, Error.INVALID_AMOUNT);
91 
92         pool = _pool;
93 
94         _setConfig(_DEBT_LIMIT_KEY, _debtLimit);
95         _setConfig(_TARGET_ALLOCATION_KEY, _targetAllocation);
96         _setConfig(_BOUND_KEY, _bound);
97         _setConfig(_RESERVE_FEE_KEY, _INITIAL_RESERVE_FEE);
98         _setConfig(_STRATEGIST_FEE_KEY, _INITIAL_STRATEGIST_FEE);
99         _setConfig(_PERFORMANCE_FEE_KEY, _INITIAL_PERFORMANCE_FEE);
100     }
101 
102     /**
103      * @notice Handles deposits from the liquidity pool
104      */
105     function deposit() external payable override onlyPoolOrMaintenance {
106         // solhint-disable-previous-line ordering
107         _deposit();
108     }
109 
110     /**
111      * @notice Withdraws specified amount of underlying from vault.
112      * @dev If the specified amount exceeds idle funds, an amount of funds is withdrawn
113      *      from the strategy such that it will achieve a target allocation for after the
114      *      amount has been withdrawn.
115      * @param amount Amount to withdraw.
116      * @return `true` if successful.
117      */
118     function withdraw(uint256 amount) external override onlyPoolOrGovernance returns (bool) {
119         IStrategy strategy = getStrategy();
120         uint256 availableUnderlying_ = _availableUnderlying();
121 
122         if (availableUnderlying_ < amount) {
123             if (address(strategy) == address(0)) return false;
124             uint256 allocated = strategy.balance();
125             uint256 requiredWithdrawal = amount - availableUnderlying_;
126 
127             if (requiredWithdrawal > allocated) return false;
128 
129             // compute withdrawal amount to sustain target allocation
130             uint256 newTarget = (allocated - requiredWithdrawal).scaledMul(getTargetAllocation());
131             uint256 excessAmount = allocated - newTarget;
132             strategy.withdraw(excessAmount);
133             currentAllocated = _computeNewAllocated(currentAllocated, excessAmount);
134         } else {
135             uint256 allocatedUnderlying = 0;
136             if (address(strategy) != address(0))
137                 allocatedUnderlying = IStrategy(strategy).balance();
138             uint256 totalUnderlying = availableUnderlying_ +
139                 allocatedUnderlying +
140                 waitingForRemovalAllocated;
141             uint256 totalUnderlyingAfterWithdraw = totalUnderlying - amount;
142             _rebalance(totalUnderlyingAfterWithdraw, allocatedUnderlying);
143         }
144 
145         _transfer(pool, amount);
146         return true;
147     }
148 
149     /**
150      * @notice Withdraws all funds from vault and strategy and transfer them to the pool.
151      */
152     function withdrawAll() external override onlyPoolOrGovernance {
153         _withdrawAllFromStrategy();
154         _transfer(pool, _availableUnderlying());
155     }
156 
157     /**
158      * @notice Withdraws specified amount of underlying from reserve to vault.
159      * @dev Withdraws from reserve will cause a spike in pool exchange rate.
160      *  Pool deposits should be paused during this to prevent front running
161      * @param amount Amount to withdraw.
162      */
163     function withdrawFromReserve(uint256 amount) external override onlyGovernance {
164         require(amount > 0, Error.INVALID_AMOUNT);
165         require(IPausable(pool).isPaused(), Error.POOL_NOT_PAUSED);
166         uint256 reserveBalance_ = reserve.getBalance(address(this), getUnderlying());
167         require(amount <= reserveBalance_, Error.INSUFFICIENT_BALANCE);
168         reserve.withdraw(getUnderlying(), amount);
169     }
170 
171     /**
172      * @notice Activate the current strategy set for the vault.
173      * @return `true` if strategy has been activated
174      */
175     function activateStrategy() external onlyGovernance returns (bool) {
176         return _activateStrategy();
177     }
178 
179     /**
180      * @notice Deactivates a strategy.
181      * @return `true` if strategy has been deactivated
182      */
183     function deactivateStrategy() external onlyGovernance returns (bool) {
184         return _deactivateStrategy();
185     }
186 
187     /**
188      * @notice Initializes the vault's strategy.
189      * @dev Bypasses the time delay, but can only be called if strategy is not set already.
190      * @param strategy_ Address of the strategy.
191      * @return `true` if successful.
192      */
193     function initializeStrategy(address strategy_) external override onlyGovernance returns (bool) {
194         require(currentAddresses[_STRATEGY_KEY] == address(0), Error.ADDRESS_ALREADY_SET);
195         require(strategy_ != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
196         _setConfig(_STRATEGY_KEY, strategy_);
197         _activateStrategy();
198         require(IStrategy(strategy_).strategist() != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
199         return true;
200     }
201 
202     /**
203      * @notice Prepare update of the vault's strategy (with time delay enforced).
204      * @param newStrategy Address of the new strategy.
205      * @return `true` if successful.
206      */
207     function prepareNewStrategy(address newStrategy)
208         external
209         override
210         onlyGovernance
211         returns (bool)
212     {
213         return _prepare(_STRATEGY_KEY, newStrategy, STRATEGY_DELAY);
214     }
215 
216     /**
217      * @notice Execute strategy update (with time delay enforced).
218      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
219      * @return New strategy address.
220      */
221     function executeNewStrategy() external override returns (address) {
222         _executeDeadline(_STRATEGY_KEY);
223         IStrategy strategy = getStrategy();
224         if (address(strategy) != address(0)) {
225             _harvest();
226             strategy.shutdown();
227             strategy.withdrawAll();
228 
229             // there might still be some balance left if the strategy did not
230             // manage to withdraw all funds (e.g. due to locking)
231             uint256 remainingStrategyBalance = strategy.balance();
232             if (remainingStrategyBalance > 0) {
233                 _strategiesWaitingForRemoval.set(address(strategy), remainingStrategyBalance);
234                 waitingForRemovalAllocated += remainingStrategyBalance;
235             }
236         }
237         _deactivateStrategy();
238         currentAllocated = 0;
239         totalDebt = 0;
240         address newStrategy = pendingAddresses[_STRATEGY_KEY];
241         _setConfig(_STRATEGY_KEY, newStrategy);
242 
243         if (newStrategy != address(0)) {
244             _activateStrategy();
245         }
246 
247         return newStrategy;
248     }
249 
250     function resetNewStrategy() external onlyGovernance returns (bool) {
251         return _resetAddressConfig(_STRATEGY_KEY);
252     }
253 
254     /**
255      * @notice Prepare update of performance fee (with time delay enforced).
256      * @param newPerformanceFee New performance fee value.
257      * @return `true` if successful.
258      */
259     function preparePerformanceFee(uint256 newPerformanceFee)
260         external
261         onlyGovernance
262         returns (bool)
263     {
264         require(newPerformanceFee <= MAX_PERFORMANCE_FEE, Error.INVALID_AMOUNT);
265         return _prepare(_PERFORMANCE_FEE_KEY, newPerformanceFee);
266     }
267 
268     /**
269      * @notice Execute update of performance fee (with time delay enforced).
270      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
271      * @return New performance fee.
272      */
273     function executePerformanceFee() external returns (uint256) {
274         return _executeUInt256(_PERFORMANCE_FEE_KEY);
275     }
276 
277     function resetPerformanceFee() external onlyGovernance returns (bool) {
278         return _resetUInt256Config(_PERFORMANCE_FEE_KEY);
279     }
280 
281     /**
282      * @notice Prepare update of strategist fee (with time delay enforced).
283      * @param newStrategistFee New strategist fee value.
284      * @return `true` if successful.
285      */
286     function prepareStrategistFee(uint256 newStrategistFee) external onlyGovernance returns (bool) {
287         _checkFeesInvariant(getReserveFee(), newStrategistFee);
288         return _prepare(_STRATEGIST_FEE_KEY, newStrategistFee);
289     }
290 
291     /**
292      * @notice Execute update of strategist fee (with time delay enforced).
293      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
294      * @return New strategist fee.
295      */
296     function executeStrategistFee() external returns (uint256) {
297         uint256 newStrategistFee = _executeUInt256(_STRATEGIST_FEE_KEY);
298         _checkFeesInvariant(getReserveFee(), newStrategistFee);
299         return newStrategistFee;
300     }
301 
302     function resetStrategistFee() external onlyGovernance returns (bool) {
303         return _resetUInt256Config(_STRATEGIST_FEE_KEY);
304     }
305 
306     /**
307      * @notice Prepare update of debt limit (with time delay enforced).
308      * @param newDebtLimit New debt limit.
309      * @return `true` if successful.
310      */
311     function prepareDebtLimit(uint256 newDebtLimit) external onlyGovernance returns (bool) {
312         return _prepare(_DEBT_LIMIT_KEY, newDebtLimit);
313     }
314 
315     /**
316      * @notice Execute update of debt limit (with time delay enforced).
317      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
318      * @return New debt limit.
319      */
320     function executeDebtLimit() external returns (uint256) {
321         uint256 debtLimit = _executeUInt256(_DEBT_LIMIT_KEY);
322         uint256 debtLimitAllocated = currentAllocated.scaledMul(debtLimit);
323         if (totalDebt >= debtLimitAllocated) {
324             _handleExcessDebt();
325         }
326         return debtLimit;
327     }
328 
329     function resetDebtLimit() external onlyGovernance returns (bool) {
330         return _resetUInt256Config(_DEBT_LIMIT_KEY);
331     }
332 
333     /**
334      * @notice Prepare update of target allocation (with time delay enforced).
335      * @param newTargetAllocation New target allocation.
336      * @return `true` if successful.
337      */
338     function prepareTargetAllocation(uint256 newTargetAllocation)
339         external
340         onlyGovernance
341         returns (bool)
342     {
343         return _prepare(_TARGET_ALLOCATION_KEY, newTargetAllocation);
344     }
345 
346     /**
347      * @notice Execute update of target allocation (with time delay enforced).
348      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
349      * @return New target allocation.
350      */
351     function executeTargetAllocation() external returns (uint256) {
352         uint256 targetAllocation = _executeUInt256(_TARGET_ALLOCATION_KEY);
353         _deposit();
354         return targetAllocation;
355     }
356 
357     function resetTargetAllocation() external onlyGovernance returns (bool) {
358         return _resetUInt256Config(_TARGET_ALLOCATION_KEY);
359     }
360 
361     /**
362      * @notice Prepare update of reserve fee (with time delay enforced).
363      * @param newReserveFee New reserve fee.
364      * @return `true` if successful.
365      */
366     function prepareReserveFee(uint256 newReserveFee) external onlyGovernance returns (bool) {
367         _checkFeesInvariant(newReserveFee, getStrategistFee());
368         return _prepare(_RESERVE_FEE_KEY, newReserveFee);
369     }
370 
371     /**
372      * @notice Execute update of reserve fee (with time delay enforced).
373      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
374      * @return New reserve fee.
375      */
376     function executeReserveFee() external returns (uint256) {
377         uint256 newReserveFee = _executeUInt256(_RESERVE_FEE_KEY);
378         _checkFeesInvariant(newReserveFee, getStrategistFee());
379         return newReserveFee;
380     }
381 
382     function resetReserveFee() external onlyGovernance returns (bool) {
383         return _resetUInt256Config(_RESERVE_FEE_KEY);
384     }
385 
386     /**
387      * @notice Prepare update of deviation bound for strategy allocation (with time delay enforced).
388      * @param newBound New deviation bound for target allocation.
389      * @return `true` if successful.
390      */
391     function prepareBound(uint256 newBound) external onlyGovernance returns (bool) {
392         require(newBound <= MAX_DEVIATION_BOUND, Error.INVALID_AMOUNT);
393         return _prepare(_BOUND_KEY, newBound);
394     }
395 
396     /**
397      * @notice Execute update of deviation bound for strategy allocation (with time delay enforced).
398      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
399      * @return New deviation bound.
400      */
401     function executeBound() external returns (uint256) {
402         uint256 bound = _executeUInt256(_BOUND_KEY);
403         _deposit();
404         return bound;
405     }
406 
407     function resetBound() external onlyGovernance returns (bool) {
408         return _resetUInt256Config(_BOUND_KEY);
409     }
410 
411     /**
412      * @notice Withdraws an amount of underlying from the strategy to the vault.
413      * @param amount Amount of underlying to withdraw.
414      * @return True if successful withdrawal.
415      */
416     function withdrawFromStrategy(uint256 amount) external onlyGovernance returns (bool) {
417         IStrategy strategy = getStrategy();
418         if (address(strategy) == address(0)) return false;
419         if (strategy.balance() < amount) return false;
420         uint256 oldBalance = _availableUnderlying();
421         strategy.withdraw(amount);
422         uint256 newBalance = _availableUnderlying();
423         currentAllocated -= newBalance - oldBalance;
424         return true;
425     }
426 
427     function withdrawFromStrategyWaitingForRemoval(address strategy) external returns (uint256) {
428         (bool exists, uint256 allocated) = _strategiesWaitingForRemoval.tryGet(strategy);
429         require(exists, Error.STRATEGY_DOES_NOT_EXIST);
430 
431         IStrategy strategy_ = IStrategy(strategy);
432 
433         strategy_.harvest();
434         uint256 withdrawn = strategy_.withdrawAll();
435 
436         uint256 _waitingForRemovalAllocated = waitingForRemovalAllocated;
437         if (withdrawn >= _waitingForRemovalAllocated) {
438             waitingForRemovalAllocated = 0;
439         } else {
440             waitingForRemovalAllocated = _waitingForRemovalAllocated - withdrawn;
441         }
442 
443         if (withdrawn > allocated) {
444             uint256 profit = withdrawn - allocated;
445             uint256 strategistShare = _shareFees(profit.scaledMul(getPerformanceFee()));
446             if (strategistShare > 0) {
447                 _payStrategist(strategistShare, strategy_.strategist());
448             }
449             allocated = 0;
450             emit Harvest(profit, 0);
451         } else {
452             allocated -= withdrawn;
453         }
454 
455         if (strategy_.balance() == 0) {
456             _strategiesWaitingForRemoval.remove(address(strategy_));
457         } else {
458             _strategiesWaitingForRemoval.set(address(strategy_), allocated);
459         }
460 
461         return withdrawn;
462     }
463 
464     function getStrategiesWaitingForRemoval() external view returns (address[] memory) {
465         return _strategiesWaitingForRemoval.keysArray();
466     }
467 
468     /**
469      * @notice Computes the total underlying of the vault: idle funds + allocated funds - debt
470      * @return Total amount of underlying.
471      */
472     function getTotalUnderlying() external view override returns (uint256) {
473         uint256 availableUnderlying_ = _availableUnderlying();
474 
475         if (address(getStrategy()) == address(0)) {
476             return availableUnderlying_;
477         }
478 
479         uint256 netUnderlying = availableUnderlying_ +
480             currentAllocated +
481             waitingForRemovalAllocated;
482         if (totalDebt <= netUnderlying) return netUnderlying - totalDebt;
483         return 0;
484     }
485 
486     function getAllocatedToStrategyWaitingForRemoval(address strategy)
487         external
488         view
489         returns (uint256)
490     {
491         return _strategiesWaitingForRemoval.get(strategy);
492     }
493 
494     /**
495      * @notice Withdraws all funds from strategy to vault.
496      * @dev Harvests profits before withdrawing. Deactivates strategy after withdrawing.
497      * @return `true` if successful.
498      */
499     function withdrawAllFromStrategy() public onlyPoolOrGovernance returns (bool) {
500         return _withdrawAllFromStrategy();
501     }
502 
503     /**
504      * @notice Harvest profits from the vault's strategy.
505      * @dev Harvesting adds profits to the vault's balance and deducts fees.
506      *  No performance fees are charged on profit used to repay debt.
507      * @return `true` if successful.
508      */
509     function harvest() public onlyPoolOrMaintenance returns (bool) {
510         return _harvest();
511     }
512 
513     /**
514      * @notice Returns the percentage of the performance fee that goes to the strategist.
515      */
516     function getStrategistFee() public view returns (uint256) {
517         return currentUInts256[_STRATEGIST_FEE_KEY];
518     }
519 
520     function getStrategy() public view override returns (IStrategy) {
521         return IStrategy(currentAddresses[_STRATEGY_KEY]);
522     }
523 
524     /**
525      * @notice Returns the percentage of the performance fee which is allocated to the vault reserve
526      */
527     function getReserveFee() public view returns (uint256) {
528         return currentUInts256[_RESERVE_FEE_KEY];
529     }
530 
531     /**
532      * @notice Returns the fee charged on a strategy's generated profits.
533      * @dev The strategist is paid in LP tokens, while the remainder of the profit stays in the vault.
534      *      Default performance fee is set to 5% of harvested profits.
535      */
536     function getPerformanceFee() public view returns (uint256) {
537         return currentUInts256[_PERFORMANCE_FEE_KEY];
538     }
539 
540     /**
541      * @notice Returns the allowed symmetric bound for target allocation (e.g. +- 5%)
542      */
543     function getBound() public view returns (uint256) {
544         return currentUInts256[_BOUND_KEY];
545     }
546 
547     /**
548      * @notice The target percentage of total underlying funds to be allocated towards a strategy.
549      * @dev this is to reduce gas costs. Withdrawals first come from idle funds and can therefore
550      *      avoid unnecessary gas costs.
551      */
552     function getTargetAllocation() public view returns (uint256) {
553         return currentUInts256[_TARGET_ALLOCATION_KEY];
554     }
555 
556     /**
557      * @notice The debt limit that the total debt of a strategy may not exceed.
558      */
559     function getDebtLimit() public view returns (uint256) {
560         return currentUInts256[_DEBT_LIMIT_KEY];
561     }
562 
563     function getUnderlying() public view virtual override returns (address);
564 
565     function _activateStrategy() internal returns (bool) {
566         IStrategy strategy = getStrategy();
567         if (address(strategy) == address(0)) return false;
568 
569         strategyActive = true;
570         emit StrategyActivated(address(strategy));
571         _deposit();
572         return true;
573     }
574 
575     function _harvest() internal returns (bool) {
576         IStrategy strategy = getStrategy();
577         if (address(strategy) == address(0)) {
578             return false;
579         }
580 
581         strategy.harvest();
582 
583         uint256 strategistShare = 0;
584 
585         uint256 allocatedUnderlying = strategy.balance();
586         uint256 amountAllocated = currentAllocated;
587         uint256 currentDebt = totalDebt;
588 
589         if (allocatedUnderlying > amountAllocated) {
590             // we made profits
591             uint256 profit = allocatedUnderlying - amountAllocated;
592 
593             if (profit > currentDebt) {
594                 if (currentDebt > 0) {
595                     profit -= currentDebt;
596                     currentDebt = 0;
597                 }
598                 (profit, strategistShare) = _shareProfit(profit);
599             } else {
600                 currentDebt -= profit;
601             }
602             emit Harvest(profit, 0);
603         } else if (allocatedUnderlying < amountAllocated) {
604             // we made a loss
605             uint256 loss = amountAllocated - allocatedUnderlying;
606             currentDebt += loss;
607 
608             // check debt limit and withdraw funds if exceeded
609             uint256 debtLimit = getDebtLimit();
610             uint256 debtLimitAllocated = amountAllocated.scaledMul(debtLimit);
611             if (currentDebt > debtLimitAllocated) {
612                 currentDebt = _handleExcessDebt(currentDebt);
613             }
614             emit Harvest(0, loss);
615         } else {
616             // nothing to declare
617             return true;
618         }
619 
620         totalDebt = currentDebt;
621         currentAllocated = strategy.balance();
622 
623         if (strategistShare > 0) {
624             _payStrategist(strategistShare);
625         }
626 
627         return true;
628     }
629 
630     function _withdrawAllFromStrategy() internal returns (bool) {
631         IStrategy strategy = getStrategy();
632         if (address(strategy) == address(0)) return false;
633         _harvest();
634         uint256 oldBalance = _availableUnderlying();
635         strategy.withdrawAll();
636         uint256 newBalance = _availableUnderlying();
637         uint256 withdrawnAmount = newBalance - oldBalance;
638 
639         currentAllocated = _computeNewAllocated(currentAllocated, withdrawnAmount);
640         _deactivateStrategy();
641         return true;
642     }
643 
644     function _handleExcessDebt(uint256 currentDebt) internal returns (uint256) {
645         uint256 underlyingReserves = reserve.getBalance(address(this), getUnderlying());
646         if (currentDebt > underlyingReserves) {
647             _emergencyStop(underlyingReserves);
648         } else if (reserve.canWithdraw(address(this))) {
649             reserve.withdraw(getUnderlying(), currentDebt);
650             currentDebt = 0;
651             _deposit();
652         }
653         return currentDebt;
654     }
655 
656     function _handleExcessDebt() internal {
657         uint256 currentDebt = totalDebt;
658         uint256 newDebt = _handleExcessDebt(totalDebt);
659         if (currentDebt != newDebt) {
660             totalDebt = newDebt;
661         }
662     }
663 
664     /**
665      * @notice Invest the underlying money in the vault after a deposit from the pool is made.
666      * @dev After each deposit, the vault checks whether it needs to rebalance underlying funds allocated to strategy.
667      * If no strategy is set then all deposited funds will be idle.
668      */
669     function _deposit() internal {
670         if (!strategyActive) return;
671 
672         uint256 allocatedUnderlying = getStrategy().balance();
673         uint256 totalUnderlying = _availableUnderlying() +
674             allocatedUnderlying +
675             waitingForRemovalAllocated;
676 
677         if (totalUnderlying == 0) return;
678         _rebalance(totalUnderlying, allocatedUnderlying);
679     }
680 
681     function _shareProfit(uint256 profit) internal returns (uint256, uint256) {
682         uint256 totalFeeAmount = profit.scaledMul(getPerformanceFee());
683         if (_availableUnderlying() < totalFeeAmount) {
684             getStrategy().withdraw(totalFeeAmount);
685         }
686         uint256 strategistShare = _shareFees(totalFeeAmount);
687 
688         return ((profit - totalFeeAmount), strategistShare);
689     }
690 
691     function _shareFees(uint256 totalFeeAmount) internal returns (uint256) {
692         uint256 strategistShare = totalFeeAmount.scaledMul(getStrategistFee());
693 
694         uint256 reserveShare = totalFeeAmount.scaledMul(getReserveFee());
695         uint256 treasuryShare = totalFeeAmount - strategistShare - reserveShare;
696 
697         _depositToReserve(reserveShare);
698         if (treasuryShare > 0) {
699             _depositToTreasury(treasuryShare);
700         }
701         return strategistShare;
702     }
703 
704     function _emergencyStop(uint256 underlyingReserves) internal {
705         // debt limit exceeded: withdraw funds from strategy
706         uint256 withdrawn = getStrategy().withdrawAll();
707 
708         uint256 actualDebt = _computeNewAllocated(currentAllocated, withdrawn);
709 
710         if (reserve.canWithdraw(address(this))) {
711             // check if debt can be covered with reserve funds
712             if (underlyingReserves >= actualDebt) {
713                 reserve.withdraw(getUnderlying(), actualDebt);
714             } else if (underlyingReserves > 0) {
715                 // debt can not be covered with reserves
716                 reserve.withdraw(getUnderlying(), underlyingReserves);
717             }
718         }
719 
720         // too much money lost, stop the strategy
721         _deactivateStrategy();
722     }
723 
724     /**
725      * @notice Deactivates a strategy. All positions of the strategy are exited.
726      * @return `true` if strategy has been deactivated
727      */
728     function _deactivateStrategy() internal returns (bool) {
729         if (!strategyActive) return false;
730 
731         strategyActive = false;
732         emit StrategyDeactivated(address(getStrategy()));
733         return true;
734     }
735 
736     function _payStrategist(uint256 amount) internal {
737         _payStrategist(amount, getStrategy().strategist());
738     }
739 
740     function _payStrategist(uint256 amount, address strategist) internal virtual;
741 
742     function _transfer(address to, uint256 amount) internal virtual;
743 
744     function _depositToReserve(uint256 amount) internal virtual;
745 
746     function _depositToTreasury(uint256 amount) internal virtual;
747 
748     function _availableUnderlying() internal view virtual returns (uint256);
749 
750     function _computeNewAllocated(uint256 allocated, uint256 withdrawn)
751         internal
752         pure
753         returns (uint256)
754     {
755         if (allocated > withdrawn) {
756             return allocated - withdrawn;
757         }
758         return 0;
759     }
760 
761     function _checkFeesInvariant(uint256 reserveFee, uint256 strategistFee) internal pure {
762         require(
763             reserveFee + strategistFee <= ScaledMath.ONE,
764             "sum of strategist fee and reserve fee should be below 1"
765         );
766     }
767 
768     function _rebalance(uint256 totalUnderlying, uint256 allocatedUnderlying)
769         private
770         returns (bool)
771     {
772         if (!strategyActive) return false;
773         uint256 targetAllocation = getTargetAllocation();
774 
775         IStrategy strategy = getStrategy();
776         uint256 bound = getBound();
777 
778         uint256 target = totalUnderlying.scaledMul(targetAllocation);
779         uint256 upperBound = targetAllocation == 0 ? 0 : targetAllocation + bound;
780         upperBound = upperBound > ScaledMath.ONE ? ScaledMath.ONE : upperBound;
781         uint256 lowerBound = bound > targetAllocation ? 0 : targetAllocation - bound;
782         if (allocatedUnderlying > totalUnderlying.scaledMul(upperBound)) {
783             // withdraw funds from strategy
784             uint256 withdrawAmount = allocatedUnderlying - target;
785             strategy.withdraw(withdrawAmount);
786 
787             currentAllocated = _computeNewAllocated(currentAllocated, withdrawAmount);
788         } else if (allocatedUnderlying < totalUnderlying.scaledMul(lowerBound)) {
789             // allocate more funds to strategy
790             uint256 depositAmount = target - allocatedUnderlying;
791             _transfer(address(strategy), depositAmount);
792             currentAllocated += depositAmount;
793             strategy.deposit();
794         }
795         return true;
796     }
797 }
