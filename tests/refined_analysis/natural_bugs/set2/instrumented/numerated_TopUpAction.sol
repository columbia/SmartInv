1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
8 
9 import "../../../interfaces/IGasBank.sol";
10 import "../../../interfaces/pool/ILiquidityPool.sol";
11 import "../../../interfaces/ISwapperRegistry.sol";
12 import "../../../interfaces/IController.sol";
13 import "../../../interfaces/IStakerVault.sol";
14 import "../../../interfaces/ISwapper.sol";
15 import "../../../interfaces/actions/topup/ITopUpHandler.sol";
16 import "../../../interfaces/actions/topup/ITopUpAction.sol";
17 import "../../../interfaces/actions/IActionFeeHandler.sol";
18 
19 import "../../../libraries/AddressProviderHelpers.sol";
20 import "../../../libraries/Errors.sol";
21 import "../../../libraries/ScaledMath.sol";
22 import "../../../libraries/EnumerableExtensions.sol";
23 
24 import "../../access/Authorization.sol";
25 import "../../utils/Preparable.sol";
26 
27 /**
28  * @notice The logic here should really be part of the top-up action
29  * but is split in a library to circumvent the byte-code size limit
30  */
31 library TopUpActionLibrary {
32     using SafeERC20 for IERC20;
33     using ScaledMath for uint256;
34     using AddressProviderHelpers for IAddressProvider;
35 
36     function lockFunds(
37         address stakerVaultAddress,
38         address payer,
39         address token,
40         uint256 lockAmount,
41         uint256 depositAmount
42     ) external {
43         uint256 amountLeft = lockAmount;
44         IStakerVault stakerVault = IStakerVault(stakerVaultAddress);
45 
46         // stake deposit amount
47         if (depositAmount > 0) {
48             depositAmount = depositAmount > amountLeft ? amountLeft : depositAmount;
49             IERC20(token).safeTransferFrom(payer, address(this), depositAmount);
50             IERC20(token).safeApprove(stakerVaultAddress, depositAmount);
51             stakerVault.stake(depositAmount);
52             stakerVault.increaseActionLockedBalance(payer, depositAmount);
53             amountLeft -= depositAmount;
54         }
55 
56         // use stake vault allowance if available and required
57         if (amountLeft > 0) {
58             uint256 balance = stakerVault.balanceOf(payer);
59             uint256 allowance = stakerVault.allowance(payer, address(this));
60             uint256 availableFunds = balance < allowance ? balance : allowance;
61             if (availableFunds >= amountLeft) {
62                 stakerVault.transferFrom(payer, address(this), amountLeft);
63                 amountLeft = 0;
64             }
65         }
66 
67         require(amountLeft == 0, Error.INSUFFICIENT_UPDATE_BALANCE);
68     }
69 
70     /**
71      * @dev Computes and returns the amount of LP tokens of type `token` that will be received in exchange for an `amount` of the underlying.
72      */
73     function calcExchangeAmount(
74         IAddressProvider addressProvider,
75         address token,
76         address actionToken,
77         uint256 amount
78     ) external view returns (uint256) {
79         ILiquidityPool pool = addressProvider.getPoolForToken(token);
80         uint256 rate = pool.exchangeRate();
81         address underlying = pool.getUnderlying();
82         if (underlying == actionToken) {
83             return amount.scaledDivRoundUp(rate);
84         }
85 
86         ISwapper swapper = getSwapper(addressProvider, underlying, actionToken);
87         uint256 swapperRate = swapper.getRate(underlying, actionToken);
88         return amount.scaledDivRoundUp(rate.scaledMul(swapperRate));
89     }
90 
91     function getSwapper(
92         IAddressProvider addressProvider,
93         address underlying,
94         address actionToken
95     ) public view returns (ISwapper) {
96         address swapperRegistry = addressProvider.getSwapperRegistry();
97         address swapper = ISwapperRegistry(swapperRegistry).getSwapper(underlying, actionToken);
98         require(swapper != address(0), Error.SWAP_PATH_NOT_FOUND);
99         return ISwapper(swapper);
100     }
101 }
102 
103 contract TopUpAction is ITopUpAction, Authorization, Preparable, Initializable {
104     using ScaledMath for uint256;
105     using ScaledMath for uint128;
106     using SafeERC20 for IERC20;
107     using EnumerableSet for EnumerableSet.AddressSet;
108     using EnumerableSet for EnumerableSet.Bytes32Set;
109     using EnumerableExtensions for EnumerableSet.AddressSet;
110     using AddressProviderHelpers for IAddressProvider;
111 
112     /**
113      * @dev Temporary struct to hold local variables in execute
114      * and avoid the stack being "too deep"
115      */
116     struct ExecuteLocalVars {
117         uint256 minActionAmountToTopUp;
118         uint256 actionTokenAmount;
119         uint256 depositTotalFeesAmount;
120         uint256 actionAmountWithFees;
121         uint256 userFactor;
122         uint256 rate;
123         uint256 depositAmountWithFees;
124         uint256 depositAmountWithoutFees;
125         uint256 actionFee;
126         uint256 totalActionTokenAmount;
127         uint128 totalTopUpAmount;
128         bool success;
129         bytes topupResult;
130         uint256 gasBankBalance;
131         uint256 initialGas;
132         uint256 gasConsumed;
133         uint256 userGasPrice;
134         uint256 estimatedRequiredGas;
135         uint256 estimatedRequiredWeiForGas;
136         uint256 requiredWeiForGas;
137         uint256 reimbursedWeiForGas;
138         address underlying;
139         bool removePosition;
140     }
141 
142     EnumerableSet.AddressSet private _usableTokens;
143 
144     uint256 internal constant _INITIAL_ESTIMATED_GAS_USAGE = 500_000;
145 
146     bytes32 internal constant _ACTION_FEE_KEY = "ActionFee";
147     bytes32 internal constant _FEE_HANDLER_KEY = "FeeHandler";
148     bytes32 internal constant _TOP_UP_HANDLER_KEY = "TopUpHandler";
149     bytes32 internal constant _ESTIMATED_GAS_USAGE_KEY = "EstimatedGasUsage";
150     bytes32 internal constant _MAX_SWAPPER_SLIPPAGE_KEY = "MaxSwapperSlippage";
151 
152     uint256 internal constant _MAX_ACTION_FEE = 0.5 * 1e18;
153     uint256 internal constant _MIN_SWAPPER_SLIPPAGE = 0.6 * 1e18;
154     uint256 internal constant _MAX_SWAPPER_SLIPPAGE = 0.95 * 1e18;
155 
156     IController public immutable controller;
157     IAddressProvider public immutable addressProvider;
158 
159     EnumerableSet.Bytes32Set internal _supportedProtocols;
160 
161     /// @notice mapping of (payer -> account -> protocol -> Record)
162     mapping(address => mapping(bytes32 => mapping(bytes32 => Record))) private _positions;
163 
164     mapping(address => RecordMeta[]) internal _userPositions;
165 
166     EnumerableSet.AddressSet internal _usersWithPositions;
167 
168     constructor(IController _controller)
169         Authorization(_controller.addressProvider().getRoleManager())
170     {
171         controller = _controller;
172         addressProvider = controller.addressProvider();
173         _setConfig(_ESTIMATED_GAS_USAGE_KEY, _INITIAL_ESTIMATED_GAS_USAGE);
174     }
175 
176     receive() external payable {
177         // solhint-disable-previous-line no-empty-blocks
178     }
179 
180     function initialize(
181         address feeHandler,
182         bytes32[] calldata protocols,
183         address[] calldata handlers
184     ) external initializer onlyGovernance {
185         require(protocols.length == handlers.length, Error.INVALID_ARGUMENT);
186         _setConfig(_FEE_HANDLER_KEY, feeHandler);
187         _setConfig(_MAX_SWAPPER_SLIPPAGE_KEY, _MAX_SWAPPER_SLIPPAGE);
188         for (uint256 i = 0; i < protocols.length; i++) {
189             bytes32 protocolKey = _getProtocolKey(protocols[i]);
190             _setConfig(protocolKey, handlers[i]);
191             _updateTopUpHandler(protocols[i], address(0), handlers[i]);
192         }
193     }
194 
195     /**
196      * @notice Register a top up action.
197      * @dev The `depositAmount` must be greater or equal to the `totalTopUpAmount` (which is denominated in `actionToken`).
198      * @param account Account to be topped up (first 20 bytes will typically be the address).
199      * @param depositAmount Amount of `depositToken` that will be locked.
200      * @param protocol Protocol which holds position to be topped up.
201      * @param record containing the data for the position to register
202      */
203     function register(
204         bytes32 account,
205         bytes32 protocol,
206         uint128 depositAmount,
207         Record memory record
208     ) external payable returns (bool) {
209         require(_supportedProtocols.contains(protocol), Error.PROTOCOL_NOT_FOUND);
210         require(record.singleTopUpAmount > 0, Error.INVALID_AMOUNT);
211         require(record.threshold > ScaledMath.ONE, Error.INVALID_AMOUNT);
212         require(record.singleTopUpAmount <= record.totalTopUpAmount, Error.INVALID_AMOUNT);
213         require(
214             _positions[msg.sender][account][protocol].threshold == 0,
215             Error.POSITION_ALREADY_EXISTS
216         );
217         require(_isSwappable(record.depositToken, record.actionToken), Error.SWAP_PATH_NOT_FOUND);
218         require(isUsable(record.depositToken), Error.TOKEN_NOT_USABLE);
219 
220         uint256 gasDeposit = (record.totalTopUpAmount.divRoundUp(record.singleTopUpAmount)) *
221             record.maxFee *
222             getEstimatedGasUsage();
223 
224         require(msg.value >= gasDeposit, Error.VALUE_TOO_LOW_FOR_GAS);
225 
226         uint256 totalLockAmount = _calcExchangeAmount(
227             record.depositToken,
228             record.actionToken,
229             record.totalTopUpAmount
230         );
231         _lockFunds(msg.sender, record.depositToken, totalLockAmount, depositAmount);
232 
233         addressProvider.getGasBank().depositFor{value: msg.value}(msg.sender);
234 
235         record.depositTokenBalance = uint128(totalLockAmount);
236         _positions[msg.sender][account][protocol] = record;
237         _userPositions[msg.sender].push(RecordMeta(account, protocol));
238         _usersWithPositions.add(msg.sender);
239 
240         emit Register(
241             account,
242             protocol,
243             record.threshold,
244             msg.sender,
245             record.depositToken,
246             totalLockAmount,
247             record.actionToken,
248             record.singleTopUpAmount,
249             record.totalTopUpAmount,
250             record.maxFee,
251             record.extra
252         );
253         return true;
254     }
255 
256     /**
257      * @notice See overloaded version of `execute` for more details.
258      */
259     function execute(
260         address payer,
261         bytes32 account,
262         address beneficiary,
263         bytes32 protocol
264     ) external override returns (bool) {
265         return execute(payer, account, beneficiary, protocol, 0);
266     }
267 
268     /**
269      * @notice Delete a position to back on the given protocol for `account`.
270      * @param account Account holding the position.
271      * @param protocol Protocol the position is held on.
272      * @param unstake If the tokens should be unstaked from vault.
273      * @return `true` if successful.
274      */
275     function resetPosition(
276         bytes32 account,
277         bytes32 protocol,
278         bool unstake
279     ) external override returns (bool) {
280         address payer = msg.sender;
281         Record memory position = _positions[payer][account][protocol];
282         require(position.threshold != 0, Error.NO_POSITION_EXISTS);
283 
284         address vault = addressProvider.getStakerVault(position.depositToken); // will revert if vault does not exist
285         IStakerVault staker = IStakerVault(vault);
286         staker.decreaseActionLockedBalance(payer, position.depositTokenBalance);
287         if (unstake) {
288             staker.unstake(position.depositTokenBalance);
289             IERC20(position.depositToken).safeTransfer(payer, position.depositTokenBalance);
290         } else {
291             staker.transfer(payer, position.depositTokenBalance);
292         }
293 
294         _removePosition(payer, account, protocol);
295         addressProvider.getGasBank().withdrawUnused(payer);
296         return true;
297     }
298 
299     /**
300      * @notice Execute top up handler update (with time delay enforced).
301      * @dev Needs to be called after the update was prepared. Fails if called before time delay is met.
302      * @param protocol Protocol for which a new handler should be executed.
303      * @return Address of new handler.
304      */
305     function executeTopUpHandler(bytes32 protocol) external override returns (address) {
306         address oldHandler = _getHandler(protocol, false);
307         address newHandler = _executeAddress(_getProtocolKey(protocol));
308 
309         _updateTopUpHandler(protocol, oldHandler, newHandler);
310         return newHandler;
311     }
312 
313     /**
314      * @notice Reset new top up handler deadline for a protocol.
315      * @param protocol Protocol for which top up handler deadline should be reset.
316      * @return `true` if successful.
317      */
318     function resetTopUpHandler(bytes32 protocol) external onlyGovernance returns (bool) {
319         return _resetAddressConfig(_getProtocolKey(protocol));
320     }
321 
322     /**
323      * @notice Prepare action fee update.
324      * @param newActionFee New fee to set.
325      * @return `true` if success.
326      */
327     function prepareActionFee(uint256 newActionFee) external onlyGovernance returns (bool) {
328         require(newActionFee <= _MAX_ACTION_FEE, Error.INVALID_AMOUNT);
329         return _prepare(_ACTION_FEE_KEY, newActionFee);
330     }
331 
332     /**
333      * @notice Execute action fee update (with time delay enforced).
334      * @dev Needs to be called after the update was prepared. Fails if called before time delay is met.
335      * @return `true` if successful.
336      */
337     function executeActionFee() external override returns (uint256) {
338         return _executeUInt256(_ACTION_FEE_KEY);
339     }
340 
341     /**
342      * @notice Reset action fee deadline.
343      * @return `true` if successful.
344      */
345     function resetActionFee() external onlyGovernance returns (bool) {
346         return _resetUInt256Config(_ACTION_FEE_KEY);
347     }
348 
349     /**
350      * @notice Prepare swapper slippage update.
351      * @param newSwapperSlippage New slippage to set.
352      * @return `true` if success.
353      */
354     function prepareSwapperSlippage(uint256 newSwapperSlippage)
355         external
356         onlyGovernance
357         returns (bool)
358     {
359         require(
360             newSwapperSlippage >= _MIN_SWAPPER_SLIPPAGE &&
361                 newSwapperSlippage <= _MAX_SWAPPER_SLIPPAGE,
362             Error.INVALID_AMOUNT
363         );
364         return _prepare(_MAX_SWAPPER_SLIPPAGE_KEY, newSwapperSlippage);
365     }
366 
367     /**
368      * @notice Execute swapper slippage update (with time delay enforced).
369      * @dev Needs to be called after the update was prepared. Fails if called before time delay is met.
370      * @return `true` if successful.
371      */
372     function executeSwapperSlippage() external override returns (uint256) {
373         return _executeUInt256(_MAX_SWAPPER_SLIPPAGE_KEY);
374     }
375 
376     /**
377      * @notice Reset action fee deadline.
378      * @return `true` if successful.
379      */
380     function resetSwapperSlippage() external onlyGovernance returns (bool) {
381         return _resetUInt256Config(_MAX_SWAPPER_SLIPPAGE_KEY);
382     }
383 
384     /** Set fee handler */
385     /**
386      * @notice Prepare update of fee handler.
387      * @param handler New fee handler.
388      * @return `true` if success.
389      */
390     function prepareFeeHandler(address handler) external onlyGovernance returns (bool) {
391         return _prepare(_FEE_HANDLER_KEY, handler);
392     }
393 
394     /**
395      * @notice Execute update of fee handler (with time delay enforced).
396      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
397      * @return `true` if successful.
398      */
399     function executeFeeHandler() external override returns (address) {
400         return _executeAddress(_FEE_HANDLER_KEY);
401     }
402 
403     /**
404      * @notice Reset the handler deadline.
405      * @return `true` if success.
406      */
407     function resetFeeHandler() external onlyGovernance returns (bool) {
408         return _resetAddressConfig(_FEE_HANDLER_KEY);
409     }
410 
411     /**
412      * @notice Prepare update of estimated gas usage.
413      * @param gasUsage New estimated gas usage.
414      * @return `true` if success.
415      */
416     function prepareEstimatedGasUsage(uint256 gasUsage) external onlyGovernance returns (bool) {
417         return _prepare(_ESTIMATED_GAS_USAGE_KEY, gasUsage);
418     }
419 
420     /**
421      * @notice Execute update of gas usage (with time delay enforced).
422      * @return `true` if successful.
423      */
424     function executeEstimatedGasUsage() external returns (uint256) {
425         return _executeUInt256(_ESTIMATED_GAS_USAGE_KEY);
426     }
427 
428     /**
429      * @notice Reset the gas usage deadline.
430      * @return `true` if success.
431      */
432     function resetGasUsage() external onlyGovernance returns (bool) {
433         return _resetUInt256Config(_ESTIMATED_GAS_USAGE_KEY);
434     }
435 
436     /**
437      * @notice Add a new deposit token that is supported by the action.
438      * @dev There is a separate check for whether the usable token (i.e. deposit token)
439      *      is swappable for some action token.
440      * @param token Address of deposit token that can be used by the action.
441      */
442     function addUsableToken(address token) external override onlyGovernance returns (bool) {
443         return _usableTokens.add(token);
444     }
445 
446     /**
447      * @notice Computes the total amount of ETH (as wei) required to pay for all
448      * the top-ups assuming the maximum gas price and the current estimated gas
449      * usage of a top-up
450      */
451     function getEthRequiredForGas(address payer) external view override returns (uint256) {
452         uint256 totalEthRequired = 0;
453         RecordMeta[] memory userRecordsMeta = _userPositions[payer];
454         uint256 gasUsagePerCall = getEstimatedGasUsage();
455         uint256 length = userRecordsMeta.length;
456         for (uint256 i = 0; i < length; i++) {
457             RecordMeta memory meta = userRecordsMeta[i];
458             Record memory record = _positions[payer][meta.account][meta.protocol];
459             uint256 totalCalls = record.totalTopUpAmount.divRoundUp(record.singleTopUpAmount);
460             totalEthRequired += totalCalls * gasUsagePerCall * record.maxFee;
461         }
462         return totalEthRequired;
463     }
464 
465     /**
466      * @notice Returns a list of positions for the given payer
467      */
468     function getUserPositions(address payer) external view override returns (RecordMeta[] memory) {
469         return _userPositions[payer];
470     }
471 
472     /**
473      * @notice Get a list supported protocols.
474      * @return List of supported protocols.
475      */
476     function getSupportedProtocols() external view override returns (bytes32[] memory) {
477         uint256 length = _supportedProtocols.length();
478         bytes32[] memory protocols = new bytes32[](length);
479         for (uint256 i = 0; i < length; i++) {
480             protocols[i] = _supportedProtocols.at(i);
481         }
482         return protocols;
483     }
484 
485     /*
486      * @notice Gets a list of users that have an active position.
487      * @dev Uses cursor pagination.
488      * @param cursor The cursor for pagination (should start at 0 for first call).
489      * @param howMany Maximum number of users to return in this pagination request.
490      * @return users List of users that have an active position.
491      * @return nextCursor The cursor to use for the next pagination request.
492      */
493     function usersWithPositions(uint256 cursor, uint256 howMany)
494         external
495         view
496         override
497         returns (address[] memory users, uint256 nextCursor)
498     {
499         uint256 length = _usersWithPositions.length();
500         if (cursor >= length) return (new address[](0), 0);
501         if (howMany >= length - cursor) {
502             howMany = length - cursor;
503         }
504 
505         address[] memory usersWithPositions_ = new address[](howMany);
506         for (uint256 i = 0; i < howMany; i++) {
507             usersWithPositions_[i] = _usersWithPositions.at(i + cursor);
508         }
509 
510         return (usersWithPositions_, cursor + howMany);
511     }
512 
513     /**
514      * @notice Get a list of all tokens usable for this action.
515      * @dev This refers to all tokens that can be used as deposit tokens.
516      * @return Array of addresses of usable tokens.
517      */
518     function getUsableTokens() external view override returns (address[] memory) {
519         return _usableTokens.toArray();
520     }
521 
522     /**
523      * @notice Retrieves the topup handler for the given `protocol`
524      */
525     function getTopUpHandler(bytes32 protocol) external view returns (address) {
526         return _getHandler(protocol, false);
527     }
528 
529     /**
530      * @notice Successfully tops up a position if it's conditions are met.
531      * @dev pool and vault funds are rebalanced after withdrawal for top up
532      * @param payer Account that pays for the top up.
533      * @param account Account owning the position for top up.
534      * @param beneficiary Address of the keeper's wallet for fee accrual.
535      * @param protocol Protocol of the top up position.
536      * @param maxWeiForGas the maximum extra amount of wei that the keeper is willing to pay for the gas
537      * @return `true` if successful.
538      */
539     function execute(
540         address payer,
541         bytes32 account,
542         address beneficiary,
543         bytes32 protocol,
544         uint256 maxWeiForGas
545     ) public override returns (bool) {
546         require(controller.canKeeperExecuteAction(msg.sender), Error.NOT_ENOUGH_BKD_STAKED);
547 
548         ExecuteLocalVars memory vars;
549 
550         vars.initialGas = gasleft();
551 
552         Record storage position = _positions[payer][account][protocol];
553         require(position.threshold != 0, Error.NO_POSITION_EXISTS);
554         require(position.totalTopUpAmount > 0, Error.INSUFFICIENT_BALANCE);
555 
556         address topUpHandler = _getHandler(protocol, true);
557         vars.userFactor = ITopUpHandler(topUpHandler).getUserFactor(account, position.extra);
558 
559         // ensure that the position is actually below its set user factor threshold
560         require(vars.userFactor < position.threshold, Error.INSUFFICIENT_THRESHOLD);
561 
562         IGasBank gasBank = addressProvider.getGasBank();
563 
564         // fail early if the user does not have enough funds in the gas bank
565         // to cover the cost of the transaction
566         vars.estimatedRequiredGas = getEstimatedGasUsage();
567         vars.estimatedRequiredWeiForGas = vars.estimatedRequiredGas * tx.gasprice;
568 
569         // compute the gas price that the user will be paying
570         vars.userGasPrice = block.basefee + position.priorityFee;
571         if (vars.userGasPrice > tx.gasprice) vars.userGasPrice = tx.gasprice;
572         if (vars.userGasPrice > position.maxFee) vars.userGasPrice = position.maxFee;
573 
574         // ensure the current position allows for the gas to be paid
575         require(
576             vars.estimatedRequiredWeiForGas <=
577                 vars.estimatedRequiredGas * vars.userGasPrice + maxWeiForGas,
578             Error.ESTIMATED_GAS_TOO_HIGH
579         );
580 
581         vars.gasBankBalance = gasBank.balanceOf(payer);
582         // ensure the user has enough funds in the gas bank to cover the gas
583         require(
584             vars.gasBankBalance + maxWeiForGas >= vars.estimatedRequiredWeiForGas,
585             Error.GAS_BANK_BALANCE_TOO_LOW
586         );
587 
588         vars.totalTopUpAmount = position.totalTopUpAmount;
589         vars.actionFee = getActionFee();
590         // add top-up fees to top-up amount
591         vars.minActionAmountToTopUp = position.singleTopUpAmount;
592         vars.actionAmountWithFees = vars.minActionAmountToTopUp.scaledMul(
593             ScaledMath.ONE + vars.actionFee
594         );
595 
596         // if the amount that we want to top-up (including fees) is higher than
597         // the available topup amount, we lower this down to what is left of the position
598         if (vars.actionAmountWithFees > vars.totalTopUpAmount) {
599             vars.actionAmountWithFees = vars.totalTopUpAmount;
600             vars.minActionAmountToTopUp = vars.actionAmountWithFees.scaledDiv(
601                 ScaledMath.ONE + vars.actionFee
602             );
603         }
604         ILiquidityPool pool = addressProvider.getPoolForToken(position.depositToken);
605         vars.underlying = pool.getUnderlying();
606         vars.rate = pool.exchangeRate();
607 
608         ISwapper swapper;
609 
610         if (vars.underlying != position.actionToken) {
611             swapper = _getSwapper(vars.underlying, position.actionToken);
612             vars.rate = vars.rate.scaledMul(swapper.getRate(vars.underlying, position.actionToken));
613         }
614 
615         // compute the deposit tokens amount with and without fees
616         // we will need to unstake the amount with fees and to
617         // swap the amount without fees into action tokens
618         vars.depositAmountWithFees = vars.actionAmountWithFees.scaledDivRoundUp(vars.rate);
619         if (position.depositTokenBalance < vars.depositAmountWithFees) {
620             vars.depositAmountWithFees = position.depositTokenBalance;
621             vars.minActionAmountToTopUp =
622                 (vars.depositAmountWithFees * vars.rate) /
623                 (ScaledMath.ONE + vars.actionFee);
624         }
625 
626         // compute amount of LP tokens needed to pay for action
627         // rate is expressed in actionToken per depositToken
628         vars.depositAmountWithoutFees = vars.minActionAmountToTopUp.scaledDivRoundUp(vars.rate);
629         vars.depositTotalFeesAmount = vars.depositAmountWithFees - vars.depositAmountWithoutFees;
630 
631         // will revert if vault does not exist
632         address vault = addressProvider.getStakerVault(position.depositToken);
633 
634         // unstake deposit tokens including fees
635         IStakerVault(vault).unstake(vars.depositAmountWithFees);
636         IStakerVault(vault).decreaseActionLockedBalance(payer, vars.depositAmountWithFees);
637 
638         // swap the amount without the fees
639         // as the fees are paid in deposit token, not in action token
640         // Redeem first and use swapper only if the underlying tokens are not action tokens
641         vars.actionTokenAmount = pool.redeem(vars.depositAmountWithoutFees);
642 
643         if (address(swapper) != address(0)) {
644             vars.minActionAmountToTopUp = vars.minActionAmountToTopUp.scaledMul(
645                 getSwapperSlippage()
646             );
647             _approve(vars.underlying, address(swapper));
648             vars.actionTokenAmount = swapper.swap(
649                 vars.underlying,
650                 position.actionToken,
651                 vars.actionTokenAmount,
652                 vars.minActionAmountToTopUp
653             );
654         }
655 
656         // compute how much of action token was actually redeemed and add fees to it
657         // this is to ensure that no funds get locked inside the contract
658         vars.totalActionTokenAmount =
659             vars.actionTokenAmount +
660             vars.depositTotalFeesAmount.scaledMul(vars.rate);
661 
662         // at this point, we have exactly `vars.actionTokenAmount`
663         // (at least `position.singleTopUpAmount`) of action token
664         // and exactly `vars.depositTotalFeesAmount` deposit tokens in the contract
665         // solhint-disable-next-line avoid-low-level-calls
666         (vars.success, vars.topupResult) = topUpHandler.delegatecall(
667             abi.encodeWithSignature(
668                 "topUp(bytes32,address,uint256,bytes)",
669                 account,
670                 position.actionToken,
671                 vars.actionTokenAmount,
672                 position.extra
673             )
674         );
675 
676         require(vars.success && abi.decode(vars.topupResult, (bool)), Error.TOP_UP_FAILED);
677 
678         // totalTopUpAmount is updated to reflect the new "balance" of the position
679         if (vars.totalTopUpAmount > vars.totalActionTokenAmount) {
680             position.totalTopUpAmount -= uint128(vars.totalActionTokenAmount);
681         } else {
682             position.totalTopUpAmount = 0;
683         }
684 
685         position.depositTokenBalance -= uint128(vars.depositAmountWithFees);
686 
687         vars.removePosition = position.totalTopUpAmount == 0 || position.depositTokenBalance == 0;
688         _payFees(payer, beneficiary, vars.depositTotalFeesAmount, position.depositToken);
689         if (vars.removePosition) {
690             if (position.depositTokenBalance > 0) {
691                 // transfer any unused locked tokens to the payer
692                 IStakerVault(vault).transfer(payer, position.depositTokenBalance);
693                 IStakerVault(vault).decreaseActionLockedBalance(
694                     payer,
695                     position.depositTokenBalance
696                 );
697             }
698             _removePosition(payer, account, protocol);
699         }
700 
701         emit TopUp(
702             account,
703             protocol,
704             payer,
705             position.depositToken,
706             vars.depositAmountWithFees,
707             position.actionToken,
708             vars.actionTokenAmount
709         );
710 
711         // compute gas used and reimburse the keeper by using the
712         // funds of payer in the gas bank
713         // TODO: add constant gas consumed for transfer and tx prologue
714         vars.gasConsumed = vars.initialGas - gasleft();
715 
716         vars.reimbursedWeiForGas = vars.userGasPrice * vars.gasConsumed;
717         if (vars.reimbursedWeiForGas > vars.gasBankBalance) {
718             vars.reimbursedWeiForGas = vars.gasBankBalance;
719         }
720 
721         // ensure that the keeper is not overpaying
722         vars.requiredWeiForGas = tx.gasprice * vars.gasConsumed;
723         require(
724             vars.reimbursedWeiForGas + maxWeiForGas >= vars.requiredWeiForGas,
725             Error.GAS_TOO_HIGH
726         );
727         gasBank.withdrawFrom(payer, payable(msg.sender), vars.reimbursedWeiForGas);
728         if (vars.removePosition) {
729             gasBank.withdrawUnused(payer);
730         }
731 
732         return true;
733     }
734 
735     /**
736      * @notice Prepare new top up handler fee update.
737      * @dev Setting the addres to 0 means that the protocol will no longer be supported.
738      * @param protocol Protocol for which a new handler should be prepared.
739      * @param newHandler Address of new handler.
740      * @return `true` if success.
741      */
742     function prepareTopUpHandler(bytes32 protocol, address newHandler)
743         public
744         onlyGovernance
745         returns (bool)
746     {
747         return _prepare(_getProtocolKey(protocol), newHandler);
748     }
749 
750     /**
751      * @notice Check if action can be executed.
752      * @param protocol for which to get the health factor
753      * @param account for which to get the health factor
754      * @param extra data to be used by the topup handler
755      * @return healthFactor of the position
756      */
757     function getHealthFactor(
758         bytes32 protocol,
759         bytes32 account,
760         bytes memory extra
761     ) public view override returns (uint256 healthFactor) {
762         ITopUpHandler topUpHandler = ITopUpHandler(_getHandler(protocol, true));
763         return topUpHandler.getUserFactor(account, extra);
764     }
765 
766     function getHandler(bytes32 protocol) public view override returns (address) {
767         return _getHandler(protocol, false);
768     }
769 
770     /**
771      * @notice returns the current estimated gas usage
772      */
773     function getEstimatedGasUsage() public view returns (uint256) {
774         return currentUInts256[_ESTIMATED_GAS_USAGE_KEY];
775     }
776 
777     /**
778      * @notice Returns the current action fee
779      */
780     function getActionFee() public view override returns (uint256) {
781         return currentUInts256[_ACTION_FEE_KEY];
782     }
783 
784     /**
785      * @notice Returns the current max swapper slippage
786      */
787     function getSwapperSlippage() public view override returns (uint256) {
788         return currentUInts256[_MAX_SWAPPER_SLIPPAGE_KEY];
789     }
790 
791     /**
792      * @notice Returns the current fee handler
793      */
794     function getFeeHandler() public view override returns (address) {
795         return currentAddresses[_FEE_HANDLER_KEY];
796     }
797 
798     /**
799      * @notice Get the record for a position.
800      * @param payer Registered payer of the position.
801      * @param account Address holding the position.
802      * @param protocol Protocol where the position is held.
803      */
804     function getPosition(
805         address payer,
806         bytes32 account,
807         bytes32 protocol
808     ) public view override returns (Record memory) {
809         return _positions[payer][account][protocol];
810     }
811 
812     /**
813      * @notice Check whether a token is usable as a deposit token.
814      * @param token Address of token to check.
815      * @return True if token is usable as a deposit token for this action.
816      */
817     function isUsable(address token) public view override returns (bool) {
818         return _usableTokens.contains(token);
819     }
820 
821     function _updateTopUpHandler(
822         bytes32 protocol,
823         address oldHandler,
824         address newHandler
825     ) internal {
826         if (newHandler == address(0)) {
827             _supportedProtocols.remove(protocol);
828         } else if (oldHandler == address(0)) {
829             _supportedProtocols.add(protocol);
830         }
831     }
832 
833     /**
834      * @dev Pays fees to the feeHandler
835      * @param payer The account who's position the fees are charged on
836      * @param beneficiary The beneficiary of the fees paid (usually this will be the keeper)
837      * @param feeAmount The amount in tokens to pay as fees
838      * @param depositToken The LpToken used to pay the fees
839      */
840     function _payFees(
841         address payer,
842         address beneficiary,
843         uint256 feeAmount,
844         address depositToken
845     ) internal {
846         address feeHandler = getFeeHandler();
847         IERC20(depositToken).safeApprove(feeHandler, feeAmount);
848         IActionFeeHandler(feeHandler).payFees(payer, beneficiary, feeAmount, depositToken);
849     }
850 
851     /**
852      * @dev "Locks" an amount of tokens on behalf of the TopUpAction
853      * Funds are taken from staker vault if allowance is sufficient, else direct transfer or a combination of both.
854      * @param payer Owner of the funds to be locked
855      * @param token Token to lock
856      * @param lockAmount Minimum amount of `token` to lock
857      * @param depositAmount Amount of `token` that was deposited.
858      *                      If this is 0 then the staker vault allowance should be used.
859      *                      If this is greater than `requiredAmount` more tokens will be locked.
860      */
861     function _lockFunds(
862         address payer,
863         address token,
864         uint256 lockAmount,
865         uint256 depositAmount
866     ) internal {
867         address stakerVaultAddress = addressProvider.getStakerVault(token);
868         TopUpActionLibrary.lockFunds(stakerVaultAddress, payer, token, lockAmount, depositAmount);
869     }
870 
871     function _removePosition(
872         address payer,
873         bytes32 account,
874         bytes32 protocol
875     ) internal {
876         delete _positions[payer][account][protocol];
877         _removeUserPosition(payer, account, protocol);
878         if (_userPositions[payer].length == 0) {
879             _usersWithPositions.remove(payer);
880         }
881         emit Deregister(payer, account, protocol);
882     }
883 
884     function _removeUserPosition(
885         address payer,
886         bytes32 account,
887         bytes32 protocol
888     ) internal {
889         RecordMeta[] storage positionsMeta = _userPositions[payer];
890         uint256 length = positionsMeta.length;
891         for (uint256 i = 0; i < length; i++) {
892             RecordMeta storage positionMeta = positionsMeta[i];
893             if (positionMeta.account == account && positionMeta.protocol == protocol) {
894                 positionsMeta[i] = positionsMeta[length - 1];
895                 positionsMeta.pop();
896                 return;
897             }
898         }
899     }
900 
901     /**
902      * @dev Approves infinite spending for the given spender.
903      * @param token The token to approve for.
904      * @param spender The spender to approve.
905      */
906     function _approve(address token, address spender) internal {
907         if (IERC20(token).allowance(address(this), spender) > 0) return;
908         IERC20(token).safeApprove(spender, type(uint256).max);
909     }
910 
911     /**
912      * @dev Computes and returns the amount of LP tokens of type `token` that will be received in exchange for an `amount` of the underlying.
913      */
914     function _calcExchangeAmount(
915         address token,
916         address actionToken,
917         uint256 amount
918     ) internal view returns (uint256) {
919         return TopUpActionLibrary.calcExchangeAmount(addressProvider, token, actionToken, amount);
920     }
921 
922     function _getSwapper(address underlying, address actionToken) internal view returns (ISwapper) {
923         return TopUpActionLibrary.getSwapper(addressProvider, underlying, actionToken);
924     }
925 
926     function _getHandler(bytes32 protocol, bool ensureExists) internal view returns (address) {
927         address handler = currentAddresses[_getProtocolKey(protocol)];
928         require(!ensureExists || handler != address(0), Error.PROTOCOL_NOT_FOUND);
929         return handler;
930     }
931 
932     function _isSwappable(address depositToken, address toToken) internal view returns (bool) {
933         ILiquidityPool pool = addressProvider.getPoolForToken(depositToken);
934         address underlying = pool.getUnderlying();
935         if (underlying == toToken) {
936             return true;
937         }
938         address swapperRegistry = addressProvider.getSwapperRegistry();
939         return ISwapperRegistry(swapperRegistry).swapperExists(underlying, toToken);
940     }
941 
942     function _getProtocolKey(bytes32 protocol) internal pure returns (bytes32) {
943         return keccak256(abi.encodePacked(_TOP_UP_HANDLER_KEY, protocol));
944     }
945 }
