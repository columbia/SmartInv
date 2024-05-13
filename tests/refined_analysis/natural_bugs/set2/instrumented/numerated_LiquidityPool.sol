1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
5 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 
8 import "../../interfaces/IController.sol";
9 import "../../interfaces/pool/ILiquidityPool.sol";
10 import "../../interfaces/ILpToken.sol";
11 import "../../interfaces/IStakerVault.sol";
12 import "../../interfaces/IVault.sol";
13 
14 import "../../libraries/AddressProviderHelpers.sol";
15 import "../../libraries/Errors.sol";
16 import "../../libraries/ScaledMath.sol";
17 
18 import "../access/Authorization.sol";
19 import "../utils/Preparable.sol";
20 import "../utils/Pausable.sol";
21 
22 /**
23  * @dev Pausing/unpausing the pool will disable/re-enable deposits.
24  */
25 abstract contract LiquidityPool is
26     ILiquidityPool,
27     Authorization,
28     Preparable,
29     Pausable,
30     Initializable
31 {
32     using AddressProviderHelpers for IAddressProvider;
33     using ScaledMath for uint256;
34     using SafeERC20 for IERC20;
35 
36     struct WithdrawalFeeMeta {
37         uint64 timeToWait;
38         uint64 feeRatio;
39         uint64 lastActionTimestamp;
40     }
41 
42     bytes32 internal constant _VAULT_KEY = "Vault";
43     bytes32 internal constant _RESERVE_DEVIATION_KEY = "ReserveDeviation";
44     bytes32 internal constant _REQUIRED_RESERVES_KEY = "RequiredReserves";
45 
46     bytes32 internal constant _MAX_WITHDRAWAL_FEE_KEY = "MaxWithdrawalFee";
47     bytes32 internal constant _MIN_WITHDRAWAL_FEE_KEY = "MinWithdrawalFee";
48     bytes32 internal constant _WITHDRAWAL_FEE_DECREASE_PERIOD_KEY = "WithdrawalFeeDecreasePeriod";
49 
50     uint256 internal constant _INITIAL_RESERVE_DEVIATION = 0.005e18; // 0.5%
51     uint256 internal constant _INITIAL_FEE_DECREASE_PERIOD = 1 weeks;
52     uint256 internal constant _INITIAL_MAX_WITHDRAWAL_FEE = 0.03e18; // 3%
53 
54     /**
55      * @notice even through admin votes and later governance, the withdrawal
56      * fee will never be able to go above this value
57      */
58     uint256 internal constant _MAX_WITHDRAWAL_FEE = 0.05e18;
59 
60     /**
61      * @notice Keeps track of the withdrawal fees on a per-address basis
62      */
63     mapping(address => WithdrawalFeeMeta) public withdrawalFeeMetas;
64 
65     IController public immutable controller;
66     IAddressProvider public immutable addressProvider;
67 
68     uint256 public depositCap;
69     IStakerVault public staker;
70     ILpToken public lpToken;
71     string public name;
72 
73     constructor(IController _controller)
74         Authorization(_controller.addressProvider().getRoleManager())
75     {
76         require(address(_controller) != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
77         controller = IController(_controller);
78         addressProvider = IController(_controller).addressProvider();
79     }
80 
81     /**
82      * @notice Deposit funds into liquidity pool and mint LP tokens in exchange.
83      * @param depositAmount Amount of the underlying asset to supply.
84      * @return The actual amount minted.
85      */
86     function deposit(uint256 depositAmount) external payable override returns (uint256) {
87         return depositFor(msg.sender, depositAmount, 0);
88     }
89 
90     /**
91      * @notice Deposit funds into liquidity pool and mint LP tokens in exchange.
92      * @param depositAmount Amount of the underlying asset to supply.
93      * @param minTokenAmount Minimum amount of LP tokens that should be minted.
94      * @return The actual amount minted.
95      */
96     function deposit(uint256 depositAmount, uint256 minTokenAmount)
97         external
98         payable
99         override
100         returns (uint256)
101     {
102         return depositFor(msg.sender, depositAmount, minTokenAmount);
103     }
104 
105     /**
106      * @notice Deposit funds into liquidity pool and stake LP Tokens in Staker Vault.
107      * @param depositAmount Amount of the underlying asset to supply.
108      * @param minTokenAmount Minimum amount of LP tokens that should be minted.
109      * @return The actual amount minted and staked.
110      */
111     function depositAndStake(uint256 depositAmount, uint256 minTokenAmount)
112         external
113         payable
114         override
115         returns (uint256)
116     {
117         uint256 amountMinted_ = depositFor(address(this), depositAmount, minTokenAmount);
118         staker.stakeFor(msg.sender, amountMinted_);
119         return amountMinted_;
120     }
121 
122     /**
123      * @notice Withdraws all funds from vault.
124      * @dev Should be called in case of emergencies.
125      */
126     function withdrawAll() external override onlyGovernance {
127         getVault().withdrawAll();
128     }
129 
130     function setLpToken(address _lpToken)
131         external
132         override
133         onlyRoles2(Roles.GOVERNANCE, Roles.POOL_FACTORY)
134         returns (bool)
135     {
136         require(address(lpToken) == address(0), Error.ADDRESS_ALREADY_SET);
137         require(ILpToken(_lpToken).minter() == address(this), Error.INVALID_MINTER);
138         lpToken = ILpToken(_lpToken);
139         _approveStakerVaultSpendingLpTokens();
140         emit LpTokenSet(_lpToken);
141         return true;
142     }
143 
144     /**
145      * @notice Checkpoint function to update a user's withdrawal fees on deposit and redeem
146      * @param from Address sending from
147      * @param to Address sending to
148      * @param amount Amount to redeem or deposit
149      */
150     function handleLpTokenTransfer(
151         address from,
152         address to,
153         uint256 amount
154     ) external override {
155         require(
156             msg.sender == address(lpToken) || msg.sender == address(staker),
157             Error.UNAUTHORIZED_ACCESS
158         );
159         if (
160             addressProvider.isStakerVault(to, address(lpToken)) ||
161             addressProvider.isStakerVault(from, address(lpToken)) ||
162             addressProvider.isAction(to) ||
163             addressProvider.isAction(from)
164         ) {
165             return;
166         }
167 
168         if (to != address(0)) {
169             _updateUserFeesOnDeposit(to, from, amount);
170         }
171     }
172 
173     /**
174      * @notice Prepare update of required reserve ratio (with time delay enforced).
175      * @param _newRatio New required reserve ratio.
176      * @return `true` if success.
177      */
178     function prepareNewRequiredReserves(uint256 _newRatio) external onlyGovernance returns (bool) {
179         require(_newRatio <= ScaledMath.ONE, Error.INVALID_AMOUNT);
180         return _prepare(_REQUIRED_RESERVES_KEY, _newRatio);
181     }
182 
183     /**
184      * @notice Execute required reserve ratio update (with time delay enforced).
185      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
186      * @return New required reserve ratio.
187      */
188     function executeNewRequiredReserves() external override returns (uint256) {
189         uint256 requiredReserveRatio = _executeUInt256(_REQUIRED_RESERVES_KEY);
190         _rebalanceVault();
191         return requiredReserveRatio;
192     }
193 
194     /**
195      * @notice Reset the prepared required reserves.
196      * @return `true` if success.
197      */
198     function resetRequiredReserves() external onlyGovernance returns (bool) {
199         return _resetUInt256Config(_REQUIRED_RESERVES_KEY);
200     }
201 
202     /**
203      * @notice Prepare update of reserve deviation ratio (with time delay enforced).
204      * @param newRatio New reserve deviation ratio.
205      * @return `true` if success.
206      */
207     function prepareNewReserveDeviation(uint256 newRatio) external onlyGovernance returns (bool) {
208         require(newRatio <= (ScaledMath.DECIMAL_SCALE * 50) / 100, Error.INVALID_AMOUNT);
209         return _prepare(_RESERVE_DEVIATION_KEY, newRatio);
210     }
211 
212     /**
213      * @notice Execute reserve deviation ratio update (with time delay enforced).
214      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
215      * @return New reserve deviation ratio.
216      */
217     function executeNewReserveDeviation() external override returns (uint256) {
218         uint256 reserveDeviation = _executeUInt256(_RESERVE_DEVIATION_KEY);
219         _rebalanceVault();
220         return reserveDeviation;
221     }
222 
223     /**
224      * @notice Reset the prepared reserve deviation.
225      * @return `true` if success.
226      */
227     function resetNewReserveDeviation() external onlyGovernance returns (bool) {
228         return _resetUInt256Config(_RESERVE_DEVIATION_KEY);
229     }
230 
231     /**
232      * @notice Prepare update of min withdrawal fee (with time delay enforced).
233      * @param newFee New min withdrawal fee.
234      * @return `true` if success.
235      */
236     function prepareNewMinWithdrawalFee(uint256 newFee) external onlyGovernance returns (bool) {
237         _checkFeeInvariants(newFee, getMaxWithdrawalFee());
238         return _prepare(_MIN_WITHDRAWAL_FEE_KEY, newFee);
239     }
240 
241     /**
242      * @notice Execute min withdrawal fee update (with time delay enforced).
243      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
244      * @return New withdrawal fee.
245      */
246     function executeNewMinWithdrawalFee() external returns (uint256) {
247         uint256 newFee = _executeUInt256(_MIN_WITHDRAWAL_FEE_KEY);
248         _checkFeeInvariants(newFee, getMaxWithdrawalFee());
249         return newFee;
250     }
251 
252     /**
253      * @notice Reset the prepared min withdrawal fee
254      * @return `true` if success.
255      */
256     function resetNewMinWithdrawalFee() external onlyGovernance returns (bool) {
257         return _resetUInt256Config(_MIN_WITHDRAWAL_FEE_KEY);
258     }
259 
260     /**
261      * @notice Prepare update of max withdrawal fee (with time delay enforced).
262      * @param newFee New max withdrawal fee.
263      * @return `true` if success.
264      */
265     function prepareNewMaxWithdrawalFee(uint256 newFee) external onlyGovernance returns (bool) {
266         _checkFeeInvariants(getMinWithdrawalFee(), newFee);
267         return _prepare(_MAX_WITHDRAWAL_FEE_KEY, newFee);
268     }
269 
270     /**
271      * @notice Execute max withdrawal fee update (with time delay enforced).
272      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
273      * @return New max withdrawal fee.
274      */
275     function executeNewMaxWithdrawalFee() external override returns (uint256) {
276         uint256 newFee = _executeUInt256(_MAX_WITHDRAWAL_FEE_KEY);
277         _checkFeeInvariants(getMinWithdrawalFee(), newFee);
278         return newFee;
279     }
280 
281     /**
282      * @notice Reset the prepared max fee.
283      * @return `true` if success.
284      */
285     function resetNewMaxWithdrawalFee() external onlyGovernance returns (bool) {
286         return _resetUInt256Config(_MAX_WITHDRAWAL_FEE_KEY);
287     }
288 
289     /**
290      * @notice Prepare update of withdrawal decrease fee period (with time delay enforced).
291      * @param newPeriod New withdrawal fee decrease period.
292      * @return `true` if success.
293      */
294     function prepareNewWithdrawalFeeDecreasePeriod(uint256 newPeriod)
295         external
296         onlyGovernance
297         returns (bool)
298     {
299         return _prepare(_WITHDRAWAL_FEE_DECREASE_PERIOD_KEY, newPeriod);
300     }
301 
302     /**
303      * @notice Execute withdrawal fee decrease period update (with time delay enforced).
304      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
305      * @return New withdrawal fee decrease period.
306      */
307     function executeNewWithdrawalFeeDecreasePeriod() external returns (uint256) {
308         return _executeUInt256(_WITHDRAWAL_FEE_DECREASE_PERIOD_KEY);
309     }
310 
311     /**
312      * @notice Reset the prepared withdrawal fee decrease period update.
313      * @return `true` if success.
314      */
315     function resetNewWithdrawalFeeDecreasePeriod() external onlyGovernance returns (bool) {
316         return _resetUInt256Config(_WITHDRAWAL_FEE_DECREASE_PERIOD_KEY);
317     }
318 
319     /**
320      * @notice Set the staker vault for this pool's LP token
321      * @dev Staker vault and LP token pairs are immutable and the staker vault can only be set once for a pool.
322      *      Only one vault exists per LP token. This information will be retrieved from the controller of the pool.
323      * @return Address of the new staker vault for the pool.
324      */
325     function setStaker()
326         external
327         override
328         onlyRoles2(Roles.GOVERNANCE, Roles.POOL_FACTORY)
329         returns (bool)
330     {
331         require(address(staker) == address(0), Error.ADDRESS_ALREADY_SET);
332         address stakerVault = addressProvider.getStakerVault(address(lpToken));
333         require(stakerVault != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
334         staker = IStakerVault(stakerVault);
335         _approveStakerVaultSpendingLpTokens();
336         emit StakerVaultSet(stakerVault);
337         return true;
338     }
339 
340     /**
341      * @notice Prepare setting a new Vault (with time delay enforced).
342      * @param _vault Address of new Vault contract.
343      * @return `true` if success.
344      */
345     function prepareNewVault(address _vault) external override onlyGovernance returns (bool) {
346         _prepare(_VAULT_KEY, _vault);
347         return true;
348     }
349 
350     /**
351      * @notice Execute Vault update (with time delay enforced).
352      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
353      * @return Address of new Vault contract.
354      */
355     function executeNewVault() external override returns (address) {
356         IVault vault = getVault();
357         if (address(vault) != address(0)) {
358             vault.withdrawAll();
359         }
360         address newVault = _executeAddress(_VAULT_KEY);
361         addressProvider.updateVault(address(vault), newVault);
362         return newVault;
363     }
364 
365     /**
366      * @notice Reset the vault deadline.
367      * @return `true` if success.
368      */
369     function resetNewVault() external onlyGovernance returns (bool) {
370         return _resetAddressConfig(_VAULT_KEY);
371     }
372 
373     /**
374      * @notice Redeems the underlying asset by burning LP tokens.
375      * @param redeemLpTokens Number of tokens to burn for redeeming the underlying.
376      * @return Actual amount of the underlying redeemed.
377      */
378     function redeem(uint256 redeemLpTokens) external override returns (uint256) {
379         return redeem(redeemLpTokens, 0);
380     }
381 
382     /**
383      * @notice Uncap the pool to remove the deposit limit.
384      * @return `true` if success.
385      */
386     function uncap() external override onlyGovernance returns (bool) {
387         require(isCapped(), Error.NOT_CAPPED);
388 
389         depositCap = 0;
390         return true;
391     }
392 
393     /**
394      * @notice Update the deposit cap value.
395      * @param _depositCap The maximum allowed deposits per address in the pool
396      * @return `true` if success.
397      */
398     function updateDepositCap(uint256 _depositCap) external override onlyGovernance returns (bool) {
399         require(isCapped(), Error.NOT_CAPPED);
400         require(depositCap != _depositCap, Error.SAME_AS_CURRENT);
401         require(_depositCap > 0, Error.INVALID_AMOUNT);
402 
403         depositCap = _depositCap;
404         return true;
405     }
406 
407     /**
408      * @notice Rebalance vault according to required underlying backing reserves.
409      */
410     function rebalanceVault() external onlyGovernance {
411         _rebalanceVault();
412     }
413 
414     /**
415      * @notice Deposit funds for an address into liquidity pool and mint LP tokens in exchange.
416      * @param account Account to deposit for.
417      * @param depositAmount Amount of the underlying asset to supply.
418      * @return Actual amount minted.
419      */
420     function depositFor(address account, uint256 depositAmount)
421         external
422         payable
423         override
424         returns (uint256)
425     {
426         return depositFor(account, depositAmount, 0);
427     }
428 
429     /**
430      * @notice Redeems the underlying asset by burning LP tokens, unstaking any LP tokens needed.
431      * @param redeemLpTokens Number of tokens to unstake and/or burn for redeeming the underlying.
432      * @param minRedeemAmount Minimum amount of underlying that should be received.
433      * @return Actual amount of the underlying redeemed.
434      */
435     function unstakeAndRedeem(uint256 redeemLpTokens, uint256 minRedeemAmount)
436         external
437         override
438         returns (uint256)
439     {
440         uint256 lpBalance_ = lpToken.balanceOf(msg.sender);
441         require(
442             lpBalance_ + staker.balanceOf(msg.sender) >= redeemLpTokens,
443             Error.INSUFFICIENT_BALANCE
444         );
445         if (lpBalance_ < redeemLpTokens) {
446             staker.unstakeFor(msg.sender, msg.sender, redeemLpTokens - lpBalance_);
447         }
448         return redeem(redeemLpTokens, minRedeemAmount);
449     }
450 
451     /**
452      * @notice Returns the address of the LP token of this pool
453      * @return The address of the LP token
454      */
455     function getLpToken() external view override returns (address) {
456         return address(lpToken);
457     }
458 
459     /**
460      * @notice Calculates the amount of LP tokens that need to be redeemed to get a certain amount of underlying (includes fees and exchange rate)
461      * @param account Address of the account redeeming.
462      * @param underlyingAmount The amount of underlying desired.
463      * @return Amount of LP tokens that need to be redeemed.
464      */
465     function calcRedeem(address account, uint256 underlyingAmount)
466         external
467         view
468         override
469         returns (uint256)
470     {
471         require(underlyingAmount > 0, Error.INVALID_AMOUNT);
472         ILpToken lpToken_ = lpToken;
473         require(lpToken_.balanceOf(account) > 0, Error.INSUFFICIENT_BALANCE);
474 
475         uint256 currentExchangeRate = exchangeRate();
476         uint256 withoutFeesLpAmount = underlyingAmount.scaledDiv(currentExchangeRate);
477         if (withoutFeesLpAmount == lpToken_.totalSupply()) {
478             return withoutFeesLpAmount;
479         }
480 
481         WithdrawalFeeMeta memory meta = withdrawalFeeMetas[account];
482 
483         uint256 currentFeeRatio = 0;
484         if (!addressProvider.isAction(account)) {
485             currentFeeRatio = getNewCurrentFees(
486                 meta.timeToWait,
487                 meta.lastActionTimestamp,
488                 meta.feeRatio
489             );
490         }
491         uint256 scalingFactor = currentExchangeRate.scaledMul((ScaledMath.ONE - currentFeeRatio));
492         uint256 neededLpTokens = underlyingAmount.scaledDivRoundUp(scalingFactor);
493 
494         return neededLpTokens;
495     }
496 
497     function getUnderlying() external view virtual override returns (address);
498 
499     /**
500      * @notice Deposit funds for an address into liquidity pool and mint LP tokens in exchange.
501      * @param account Account to deposit for.
502      * @param depositAmount Amount of the underlying asset to supply.
503      * @param minTokenAmount Minimum amount of LP tokens that should be minted.
504      * @return Actual amount minted.
505      */
506     function depositFor(
507         address account,
508         uint256 depositAmount,
509         uint256 minTokenAmount
510     ) public payable override notPaused returns (uint256) {
511         uint256 rate = exchangeRate();
512 
513         if (isCapped()) {
514             uint256 lpBalance = lpToken.balanceOf(account);
515             uint256 stakedAndLockedBalance = staker.stakedAndActionLockedBalanceOf(account);
516             uint256 currentUnderlyingBalance = (lpBalance + stakedAndLockedBalance).scaledMul(rate);
517             require(
518                 currentUnderlyingBalance + depositAmount <= depositCap,
519                 Error.EXCEEDS_DEPOSIT_CAP
520             );
521         }
522 
523         _doTransferIn(msg.sender, depositAmount);
524         uint256 mintedLp = depositAmount.scaledDiv(rate);
525         require(mintedLp >= minTokenAmount, Error.INVALID_AMOUNT);
526 
527         lpToken.mint(account, mintedLp);
528         _rebalanceVault();
529 
530         if (msg.sender == account || address(this) == account) {
531             emit Deposit(msg.sender, depositAmount, mintedLp);
532         } else {
533             emit DepositFor(msg.sender, account, depositAmount, mintedLp);
534         }
535         return mintedLp;
536     }
537 
538     /**
539      * @notice Redeems the underlying asset by burning LP tokens.
540      * @param redeemLpTokens Number of tokens to burn for redeeming the underlying.
541      * @param minRedeemAmount Minimum amount of underlying that should be received.
542      * @return Actual amount of the underlying redeemed.
543      */
544     function redeem(uint256 redeemLpTokens, uint256 minRedeemAmount)
545         public
546         override
547         returns (uint256)
548     {
549         require(redeemLpTokens > 0, Error.INVALID_AMOUNT);
550         ILpToken lpToken_ = lpToken;
551         require(lpToken_.balanceOf(msg.sender) >= redeemLpTokens, Error.INSUFFICIENT_BALANCE);
552 
553         uint256 withdrawalFee = addressProvider.isAction(msg.sender)
554             ? 0
555             : getWithdrawalFee(msg.sender, redeemLpTokens);
556         uint256 redeemMinusFees = redeemLpTokens - withdrawalFee;
557         // Pay no fees on the last withdrawal (avoid locking funds in the pool)
558         if (redeemLpTokens == lpToken_.totalSupply()) {
559             redeemMinusFees = redeemLpTokens;
560         }
561         uint256 redeemUnderlying = redeemMinusFees.scaledMul(exchangeRate());
562         require(redeemUnderlying >= minRedeemAmount, Error.NOT_ENOUGH_FUNDS_WITHDRAWN);
563 
564         _rebalanceVault(redeemUnderlying);
565 
566         lpToken_.burn(msg.sender, redeemLpTokens);
567         _doTransferOut(payable(msg.sender), redeemUnderlying);
568         emit Redeem(msg.sender, redeemUnderlying, redeemLpTokens);
569         return redeemUnderlying;
570     }
571 
572     /**
573      * @return the current required reserves ratio
574      */
575     function getRequiredReserveRatio() public view virtual returns (uint256) {
576         return currentUInts256[_REQUIRED_RESERVES_KEY];
577     }
578 
579     /**
580      * @return the current maximum reserve deviation ratio
581      */
582     function getMaxReserveDeviationRatio() public view virtual returns (uint256) {
583         return currentUInts256[_RESERVE_DEVIATION_KEY];
584     }
585 
586     /**
587      * @notice Returns the current minimum withdrawal fee
588      */
589     function getMinWithdrawalFee() public view returns (uint256) {
590         return currentUInts256[_MIN_WITHDRAWAL_FEE_KEY];
591     }
592 
593     /**
594      * @notice Returns the current maximum withdrawal fee
595      */
596     function getMaxWithdrawalFee() public view returns (uint256) {
597         return currentUInts256[_MAX_WITHDRAWAL_FEE_KEY];
598     }
599 
600     /**
601      * @notice Returns the current withdrawal fee decrease period
602      */
603     function getWithdrawalFeeDecreasePeriod() public view returns (uint256) {
604         return currentUInts256[_WITHDRAWAL_FEE_DECREASE_PERIOD_KEY];
605     }
606 
607     /**
608      * @return the current vault of the liquidity pool
609      */
610     function getVault() public view virtual override returns (IVault) {
611         return IVault(currentAddresses[_VAULT_KEY]);
612     }
613 
614     /**
615      * @notice Compute current exchange rate of LP tokens to underlying scaled to 1e18.
616      * @dev Exchange rate means: underlying = LP token * exchangeRate
617      * @return Current exchange rate.
618      */
619     function exchangeRate() public view override returns (uint256) {
620         uint256 totalUnderlying_ = totalUnderlying();
621         uint256 totalSupply = lpToken.totalSupply();
622         if (totalSupply == 0 || totalUnderlying_ == 0) {
623             return ScaledMath.ONE;
624         }
625 
626         return totalUnderlying_.scaledDiv(totalSupply);
627     }
628 
629     /**
630      * @notice Compute total amount of underlying tokens for this pool.
631      * @return Total amount of underlying in pool.
632      */
633     function totalUnderlying() public view override returns (uint256) {
634         IVault vault = getVault();
635         uint256 balanceUnderlying = _getBalanceUnderlying();
636         if (address(vault) == address(0)) {
637             return balanceUnderlying;
638         }
639         uint256 investedUnderlying = vault.getTotalUnderlying();
640         return investedUnderlying + balanceUnderlying;
641     }
642 
643     /**
644      * @notice Retuns if the pool has an active deposit limit
645      * @return `true` if there is currently a deposit limit
646      */
647     function isCapped() public view override returns (bool) {
648         return depositCap != 0;
649     }
650 
651     /**
652      * @notice Returns the withdrawal fee for `account`
653      * @param account Address to get the withdrawal fee for
654      * @param amount Amount to calculate the withdrawal fee for
655      * @return Withdrawal fee in LP tokens
656      */
657     function getWithdrawalFee(address account, uint256 amount)
658         public
659         view
660         override
661         returns (uint256)
662     {
663         WithdrawalFeeMeta memory meta = withdrawalFeeMetas[account];
664 
665         if (lpToken.balanceOf(account) == 0) {
666             return 0;
667         }
668         uint256 currentFee = getNewCurrentFees(
669             meta.timeToWait,
670             meta.lastActionTimestamp,
671             meta.feeRatio
672         );
673         return amount.scaledMul(currentFee);
674     }
675 
676     /**
677      * @notice Calculates the withdrawal fee a user would currently need to pay on currentBalance.
678      * @param timeToWait The total time to wait until the withdrawal fee reached the min. fee
679      * @param lastActionTimestamp Timestamp of the last fee update
680      * @param feeRatio Fees that would currently be paid on the user's entire balance
681      * @return Updated fee amount on the currentBalance
682      */
683     function getNewCurrentFees(
684         uint256 timeToWait,
685         uint256 lastActionTimestamp,
686         uint256 feeRatio
687     ) public view returns (uint256) {
688         uint256 timeElapsed = _getTime() - lastActionTimestamp;
689         uint256 minFeePercentage = getMinWithdrawalFee();
690         if (timeElapsed >= timeToWait) {
691             return minFeePercentage;
692         }
693         uint256 elapsedShare = timeElapsed.scaledDiv(timeToWait);
694         return feeRatio - (feeRatio - minFeePercentage).scaledMul(elapsedShare);
695     }
696 
697     function _rebalanceVault() internal {
698         _rebalanceVault(0);
699     }
700 
701     function _initialize(
702         string memory name_,
703         uint256 depositCap_,
704         address vault_
705     ) internal initializer returns (bool) {
706         name = name_;
707         depositCap = depositCap_;
708 
709         _setConfig(_WITHDRAWAL_FEE_DECREASE_PERIOD_KEY, _INITIAL_FEE_DECREASE_PERIOD);
710         _setConfig(_MAX_WITHDRAWAL_FEE_KEY, _INITIAL_MAX_WITHDRAWAL_FEE);
711         _setConfig(_REQUIRED_RESERVES_KEY, ScaledMath.ONE);
712         _setConfig(_RESERVE_DEVIATION_KEY, _INITIAL_RESERVE_DEVIATION);
713         _setConfig(_VAULT_KEY, vault_);
714         return true;
715     }
716 
717     function _approveStakerVaultSpendingLpTokens() internal {
718         address staker_ = address(staker);
719         address lpToken_ = address(lpToken);
720         if (staker_ == address(0) || lpToken_ == address(0)) return;
721         IERC20(lpToken_).safeApprove(staker_, type(uint256).max);
722     }
723 
724     function _doTransferIn(address from, uint256 amount) internal virtual;
725 
726     function _doTransferOut(address payable to, uint256 amount) internal virtual;
727 
728     /**
729      * @dev Rebalances the pool's allocations to the vault
730      * @param underlyingToWithdraw Amount of underlying to withdraw such that after the withdrawal the pool and vault allocations are correctly balanced.
731      */
732     function _rebalanceVault(uint256 underlyingToWithdraw) internal {
733         IVault vault = getVault();
734 
735         if (address(vault) == address(0)) return;
736         uint256 lockedLp = staker.getStakedByActions();
737         uint256 totalUnderlyingStaked = lockedLp.scaledMul(exchangeRate());
738 
739         uint256 underlyingBalance = _getBalanceUnderlying(true);
740         uint256 maximumDeviation = totalUnderlyingStaked.scaledMul(getMaxReserveDeviationRatio());
741 
742         uint256 nextTargetBalance = totalUnderlyingStaked.scaledMul(getRequiredReserveRatio());
743 
744         if (
745             underlyingToWithdraw > underlyingBalance ||
746             (underlyingBalance - underlyingToWithdraw) + maximumDeviation < nextTargetBalance
747         ) {
748             uint256 requiredDeposits = nextTargetBalance + underlyingToWithdraw - underlyingBalance;
749             vault.withdraw(requiredDeposits);
750         } else {
751             uint256 nextBalance = underlyingBalance - underlyingToWithdraw;
752             if (nextBalance > nextTargetBalance + maximumDeviation) {
753                 uint256 excessDeposits = nextBalance - nextTargetBalance;
754                 _doTransferOut(payable(address(vault)), excessDeposits);
755                 vault.deposit();
756             }
757         }
758     }
759 
760     function _updateUserFeesOnDeposit(
761         address account,
762         address from,
763         uint256 amountAdded
764     ) internal {
765         WithdrawalFeeMeta storage meta = withdrawalFeeMetas[account];
766         uint256 balance = lpToken.balanceOf(account) +
767             staker.stakedAndActionLockedBalanceOf(account);
768         uint256 newCurrentFeeRatio = getNewCurrentFees(
769             meta.timeToWait,
770             meta.lastActionTimestamp,
771             meta.feeRatio
772         );
773         uint256 shareAdded = amountAdded.scaledDiv(amountAdded + balance);
774         uint256 shareExisting = ScaledMath.ONE - shareAdded;
775         uint256 feeOnDeposit;
776         if (from == address(0)) {
777             feeOnDeposit = getMaxWithdrawalFee();
778         } else {
779             WithdrawalFeeMeta storage fromMeta = withdrawalFeeMetas[from];
780             feeOnDeposit = getNewCurrentFees(
781                 fromMeta.timeToWait,
782                 fromMeta.lastActionTimestamp,
783                 fromMeta.feeRatio
784             );
785         }
786 
787         uint256 newFeeRatio = shareExisting.scaledMul(newCurrentFeeRatio) +
788             shareAdded.scaledMul(feeOnDeposit);
789 
790         meta.feeRatio = uint64(newFeeRatio);
791         meta.timeToWait = uint64(getWithdrawalFeeDecreasePeriod());
792         meta.lastActionTimestamp = uint64(_getTime());
793     }
794 
795     function _getBalanceUnderlying() internal view virtual returns (uint256);
796 
797     function _getBalanceUnderlying(bool transferInDone) internal view virtual returns (uint256);
798 
799     function _isAuthorizedToPause(address account) internal view override returns (bool) {
800         return _roleManager().hasRole(Roles.GOVERNANCE, account);
801     }
802 
803     /**
804      * @dev Overriden for testing
805      */
806     function _getTime() internal view virtual returns (uint256) {
807         return block.timestamp;
808     }
809 
810     function _checkFeeInvariants(uint256 minFee, uint256 maxFee) internal pure {
811         require(maxFee >= minFee, Error.INVALID_AMOUNT);
812         require(maxFee <= _MAX_WITHDRAWAL_FEE, Error.INVALID_AMOUNT);
813     }
814 }
