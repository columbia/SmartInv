1 // SPDX-License-Identifier: MIT
2 // File: contracts/interfaces/IBankingNode.sol
3 
4 pragma solidity ^0.8.0;
5 
6 interface IBankingNode {
7     //ERC20 functions
8 
9     function name() external pure returns (string memory);
10 
11     function symbol() external pure returns (string memory);
12 
13     function decimals() external pure returns (uint8);
14 
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address owner) external view returns (uint256);
18 
19     function allowance(address owner, address spender)
20         external
21         view
22         returns (uint256);
23 
24     function approve(address spender, uint256 value) external returns (bool);
25 
26     function transfer(address to, uint256 value) external returns (bool);
27 
28     function transferFrom(
29         address from,
30         address to,
31         uint256 value
32     ) external returns (bool);
33 
34     //Banking Node Functions
35 
36     function requestLoan(
37         uint256 loanAmount,
38         uint256 paymentInterval,
39         uint256 numberOfPayments,
40         uint256 interestRate,
41         bool interestOnly,
42         address collateral,
43         uint256 collateralAmount,
44         address agent,
45         string memory message
46     ) external returns (uint256 requestId);
47 
48     function withdrawCollateral(uint256 loanId) external;
49 
50     function collectAaveRewards(address[] calldata assets) external;
51 
52     function collectCollateralFees(address collateral) external;
53 
54     function makeLoanPayment(uint256 loanId) external;
55 
56     function repayEarly(uint256 loanId) external;
57 
58     function collectFees() external;
59 
60     function deposit(uint256 _amount) external;
61 
62     function withdraw(uint256 _amount) external;
63 
64     function stake(uint256 _amount) external;
65 
66     function initiateUnstake(uint256 _amount) external;
67 
68     function unstake() external;
69 
70     function slashLoan(uint256 loanId, uint256 minOut) external;
71 
72     function sellSlashed(uint256 minOut) external;
73 
74     function donateBaseToken(uint256 _amount) external;
75 
76     //Operator only functions
77 
78     function approveLoan(uint256 loanId, uint256 requiredCollateralAmount)
79         external;
80 
81     function clearPendingLoans() external;
82 
83     function whitelistAddresses(address whitelistAddition) external;
84 
85     //View functions
86 
87     function getStakedBNPL() external view returns (uint256);
88 
89     function getBaseTokenBalance(address user) external view returns (uint256);
90 
91     function getBNPLBalance(address user) external view returns (uint256 what);
92 
93     function getUnbondingBalance(address user) external view returns (uint256);
94 
95     function getNextPayment(uint256 loanId) external view returns (uint256);
96 
97     function getNextDueDate(uint256 loanId) external view returns (uint256);
98 
99     function getTotalAssetValue() external view returns (uint256);
100 
101     function getPendingRequestCount() external view returns (uint256);
102 
103     function getCurrentLoansCount() external view returns (uint256);
104 
105     function getDefaultedLoansCount() external view returns (uint256);
106 }
107 
108 // File: contracts/libraries/TransferHelper.sol
109 
110 
111 
112 pragma solidity >=0.6.0;
113 
114 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
115 library TransferHelper {
116     function safeApprove(
117         address token,
118         address to,
119         uint256 value
120     ) internal {
121         // bytes4(keccak256(bytes('approve(address,uint256)')));
122         (bool success, bytes memory data) = token.call(
123             abi.encodeWithSelector(0x095ea7b3, to, value)
124         );
125         require(
126             success && (data.length == 0 || abi.decode(data, (bool))),
127             "TransferHelper: APPROVE_FAILED"
128         );
129     }
130 
131     function safeTransfer(
132         address token,
133         address to,
134         uint256 value
135     ) internal {
136         // bytes4(keccak256(bytes('transfer(address,uint256)')));
137         (bool success, bytes memory data) = token.call(
138             abi.encodeWithSelector(0xa9059cbb, to, value)
139         );
140         require(
141             success && (data.length == 0 || abi.decode(data, (bool))),
142             "TransferHelper: TRANSFER_FAILED"
143         );
144     }
145 
146     function safeTransferFrom(
147         address token,
148         address from,
149         address to,
150         uint256 value
151     ) internal {
152         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
153         (bool success, bytes memory data) = token.call(
154             abi.encodeWithSelector(0x23b872dd, from, to, value)
155         );
156         require(
157             success && (data.length == 0 || abi.decode(data, (bool))),
158             "TransferHelper: TRANSFER_FROM_FAILED"
159         );
160     }
161 
162     function safeTransferETH(address to, uint256 value) internal {
163         (bool success, ) = to.call{value: value}(new bytes(0));
164         require(success, "TransferHelper: ETH_TRANSFER_FAILED");
165     }
166 }
167 
168 // File: contracts/libraries/SafeMath.sol
169 
170 pragma solidity >=0.6.6;
171 
172 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
173 
174 library SafeMath {
175     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
176         require((z = x + y) >= x, "ds-math-add-overflow");
177     }
178 
179     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
180         require((z = x - y) <= x, "ds-math-sub-underflow");
181     }
182 
183     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
184         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
185     }
186 }
187 
188 // File: contracts/interfaces/IUniswapV2Pair.sol
189 
190 
191 
192 pragma solidity >=0.5.0;
193 
194 interface IUniswapV2Pair {
195     event Approval(
196         address indexed owner,
197         address indexed spender,
198         uint256 value
199     );
200     event Transfer(address indexed from, address indexed to, uint256 value);
201 
202     function name() external pure returns (string memory);
203 
204     function symbol() external pure returns (string memory);
205 
206     function decimals() external pure returns (uint8);
207 
208     function totalSupply() external view returns (uint256);
209 
210     function balanceOf(address owner) external view returns (uint256);
211 
212     function allowance(address owner, address spender)
213         external
214         view
215         returns (uint256);
216 
217     function approve(address spender, uint256 value) external returns (bool);
218 
219     function transfer(address to, uint256 value) external returns (bool);
220 
221     function transferFrom(
222         address from,
223         address to,
224         uint256 value
225     ) external returns (bool);
226 
227     function DOMAIN_SEPARATOR() external view returns (bytes32);
228 
229     function PERMIT_TYPEHASH() external pure returns (bytes32);
230 
231     function nonces(address owner) external view returns (uint256);
232 
233     function permit(
234         address owner,
235         address spender,
236         uint256 value,
237         uint256 deadline,
238         uint8 v,
239         bytes32 r,
240         bytes32 s
241     ) external;
242 
243     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
244     event Burn(
245         address indexed sender,
246         uint256 amount0,
247         uint256 amount1,
248         address indexed to
249     );
250     event Swap(
251         address indexed sender,
252         uint256 amount0In,
253         uint256 amount1In,
254         uint256 amount0Out,
255         uint256 amount1Out,
256         address indexed to
257     );
258     event Sync(uint112 reserve0, uint112 reserve1);
259 
260     function MINIMUM_LIQUIDITY() external pure returns (uint256);
261 
262     function factory() external view returns (address);
263 
264     function token0() external view returns (address);
265 
266     function token1() external view returns (address);
267 
268     function getReserves()
269         external
270         view
271         returns (
272             uint112 reserve0,
273             uint112 reserve1,
274             uint32 blockTimestampLast
275         );
276 
277     function price0CumulativeLast() external view returns (uint256);
278 
279     function price1CumulativeLast() external view returns (uint256);
280 
281     function kLast() external view returns (uint256);
282 
283     function mint(address to) external returns (uint256 liquidity);
284 
285     function burn(address to)
286         external
287         returns (uint256 amount0, uint256 amount1);
288 
289     function swap(
290         uint256 amount0Out,
291         uint256 amount1Out,
292         address to,
293         bytes calldata data
294     ) external;
295 
296     function skim(address to) external;
297 
298     function sync() external;
299 
300     function initialize(address, address) external;
301 }
302 
303 // File: contracts/libraries/UniswapV2Library.sol
304 
305 pragma solidity >=0.5.0;
306 
307 
308 
309 library UniswapV2Library {
310     using SafeMath for uint256;
311 
312     // returns sorted token addresses, used to handle return values from pairs sorted in this order
313     function sortTokens(address tokenA, address tokenB)
314         internal
315         pure
316         returns (address token0, address token1)
317     {
318         require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
319         (token0, token1) = tokenA < tokenB
320             ? (tokenA, tokenB)
321             : (tokenB, tokenA);
322         require(token0 != address(0), "UniswapV2Library: ZERO_ADDRESS");
323     }
324 
325     // calculates the CREATE2 address for a pair without making any external calls
326     function pairFor(
327         address factory,
328         address tokenA,
329         address tokenB
330     ) internal pure returns (address pair) {
331         (address token0, address token1) = sortTokens(tokenA, tokenB);
332         pair = address(
333             uint160(
334                 uint256(
335                     keccak256(
336                         abi.encodePacked(
337                             hex"ff",
338                             factory,
339                             keccak256(abi.encodePacked(token0, token1)),
340                             // hex"96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f" // init code hash
341                             //mainnet hash for sushiSwap:
342                             hex"e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303"
343                         )
344                     )
345                 )
346             )
347         );
348     }
349 
350     // fetches and sorts the reserves for a pair
351     function getReserves(
352         address factory,
353         address tokenA,
354         address tokenB
355     ) internal view returns (uint256 reserveA, uint256 reserveB) {
356         (address token0, ) = sortTokens(tokenA, tokenB);
357         (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(
358             pairFor(factory, tokenA, tokenB)
359         ).getReserves();
360         (reserveA, reserveB) = tokenA == token0
361             ? (reserve0, reserve1)
362             : (reserve1, reserve0);
363     }
364 
365     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
366     function quote(
367         uint256 amountA,
368         uint256 reserveA,
369         uint256 reserveB
370     ) internal pure returns (uint256 amountB) {
371         require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
372         require(
373             reserveA > 0 && reserveB > 0,
374             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
375         );
376         amountB = amountA.mul(reserveB) / reserveA;
377     }
378 
379     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
380     function getAmountOut(
381         uint256 amountIn,
382         uint256 reserveIn,
383         uint256 reserveOut
384     ) internal pure returns (uint256 amountOut) {
385         require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
386         require(
387             reserveIn > 0 && reserveOut > 0,
388             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
389         );
390         uint256 amountInWithFee = amountIn.mul(997);
391         uint256 numerator = amountInWithFee.mul(reserveOut);
392         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
393         amountOut = numerator / denominator;
394     }
395 
396     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
397     function getAmountIn(
398         uint256 amountOut,
399         uint256 reserveIn,
400         uint256 reserveOut
401     ) internal pure returns (uint256 amountIn) {
402         require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
403         require(
404             reserveIn > 0 && reserveOut > 0,
405             "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
406         );
407         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
408         uint256 denominator = reserveOut.sub(amountOut).mul(997);
409         amountIn = (numerator / denominator).add(1);
410     }
411 
412     // performs chained getAmountOut calculations on any number of pairs
413     function getAmountsOut(
414         address factory,
415         uint256 amountIn,
416         address[] memory path
417     ) internal view returns (uint256[] memory amounts) {
418         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
419         amounts = new uint256[](path.length);
420         amounts[0] = amountIn;
421         for (uint256 i; i < path.length - 1; i++) {
422             (uint256 reserveIn, uint256 reserveOut) = getReserves(
423                 factory,
424                 path[i],
425                 path[i + 1]
426             );
427             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
428         }
429     }
430 
431     // performs chained getAmountIn calculations on any number of pairs
432     function getAmountsIn(
433         address factory,
434         uint256 amountOut,
435         address[] memory path
436     ) internal view returns (uint256[] memory amounts) {
437         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
438         amounts = new uint256[](path.length);
439         amounts[amounts.length - 1] = amountOut;
440         for (uint256 i = path.length - 1; i > 0; i--) {
441             (uint256 reserveIn, uint256 reserveOut) = getReserves(
442                 factory,
443                 path[i - 1],
444                 path[i]
445             );
446             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
447         }
448     }
449 }
450 
451 // File: contracts/libraries/DistributionTypes.sol
452 
453 
454 pragma solidity ^0.8.0;
455 
456 library DistributionTypes {
457     struct AssetConfigInput {
458         uint104 emissionPerSecond;
459         uint256 totalStaked;
460         address underlyingAsset;
461     }
462 
463     struct UserStakeInput {
464         address underlyingAsset;
465         uint256 stakedByUser;
466         uint256 totalStaked;
467     }
468 }
469 
470 // File: contracts/interfaces/IAaveDistributionManager.sol
471 
472 
473 pragma solidity ^0.8.0;
474 
475 interface IAaveDistributionManager {
476     event AssetConfigUpdated(address indexed asset, uint256 emission);
477     event AssetIndexUpdated(address indexed asset, uint256 index);
478     event UserIndexUpdated(
479         address indexed user,
480         address indexed asset,
481         uint256 index
482     );
483     event DistributionEndUpdated(uint256 newDistributionEnd);
484 
485     /**
486      * @dev Sets the end date for the distribution
487      * @param distributionEnd The end date timestamp
488      **/
489     function setDistributionEnd(uint256 distributionEnd) external;
490 
491     /**
492      * @dev Gets the end date for the distribution
493      * @return The end of the distribution
494      **/
495     function getDistributionEnd() external view returns (uint256);
496 
497     /**
498      * @dev for backwards compatibility with the previous DistributionManager used
499      * @return The end of the distribution
500      **/
501     function DISTRIBUTION_END() external view returns (uint256);
502 
503     /**
504      * @dev Returns the data of an user on a distribution
505      * @param user Address of the user
506      * @param asset The address of the reference asset of the distribution
507      * @return The new index
508      **/
509     function getUserAssetData(address user, address asset)
510         external
511         view
512         returns (uint256);
513 
514     /**
515      * @dev Returns the configuration of the distribution for a certain asset
516      * @param asset The address of the reference asset of the distribution
517      * @return The asset index, the emission per second and the last updated timestamp
518      **/
519     function getAssetData(address asset)
520         external
521         view
522         returns (
523             uint256,
524             uint256,
525             uint256
526         );
527 }
528 
529 // File: contracts/interfaces/IAaveIncentivesController.sol
530 
531 
532 pragma solidity ^0.8.0;
533 
534 pragma experimental ABIEncoderV2;
535 
536 
537 interface IAaveIncentivesController is IAaveDistributionManager {
538     event RewardsAccrued(address indexed user, uint256 amount);
539 
540     event RewardsClaimed(
541         address indexed user,
542         address indexed to,
543         address indexed claimer,
544         uint256 amount
545     );
546 
547     event ClaimerSet(address indexed user, address indexed claimer);
548 
549     /**
550      * @dev Whitelists an address to claim the rewards on behalf of another address
551      * @param user The address of the user
552      * @param claimer The address of the claimer
553      */
554     function setClaimer(address user, address claimer) external;
555 
556     /**
557      * @dev Returns the whitelisted claimer for a certain address (0x0 if not set)
558      * @param user The address of the user
559      * @return The claimer address
560      */
561     function getClaimer(address user) external view returns (address);
562 
563     /**
564      * @dev Configure assets for a certain rewards emission
565      * @param assets The assets to incentivize
566      * @param emissionsPerSecond The emission for each asset
567      */
568     function configureAssets(
569         address[] calldata assets,
570         uint256[] calldata emissionsPerSecond
571     ) external;
572 
573     /**
574      * @dev Called by the corresponding asset on any update that affects the rewards distribution
575      * @param asset The address of the user
576      * @param userBalance The balance of the user of the asset in the lending pool
577      * @param totalSupply The total supply of the asset in the lending pool
578      **/
579     function handleAction(
580         address asset,
581         uint256 userBalance,
582         uint256 totalSupply
583     ) external;
584 
585     /**
586      * @dev Returns the total of rewards of an user, already accrued + not yet accrued
587      * @param user The address of the user
588      * @return The rewards
589      **/
590     function getRewardsBalance(address[] calldata assets, address user)
591         external
592         view
593         returns (uint256);
594 
595     /**
596      * @dev Claims reward for an user to the desired address, on all the assets of the lending pool, accumulating the pending rewards
597      * @param amount Amount of rewards to claim
598      * @param to Address that will be receiving the rewards
599      * @return Rewards claimed
600      **/
601     function claimRewards(
602         address[] calldata assets,
603         uint256 amount,
604         address to
605     ) external returns (uint256);
606 
607     /**
608      * @dev Claims reward for an user on behalf, on all the assets of the lending pool, accumulating the pending rewards. The caller must
609      * be whitelisted via "allowClaimOnBehalf" function by the RewardsAdmin role manager
610      * @param amount Amount of rewards to claim
611      * @param user Address to check and claim rewards
612      * @param to Address that will be receiving the rewards
613      * @return Rewards claimed
614      **/
615     function claimRewardsOnBehalf(
616         address[] calldata assets,
617         uint256 amount,
618         address user,
619         address to
620     ) external returns (uint256);
621 
622     /**
623      * @dev Claims reward for msg.sender, on all the assets of the lending pool, accumulating the pending rewards
624      * @param amount Amount of rewards to claim
625      * @return Rewards claimed
626      **/
627     function claimRewardsToSelf(address[] calldata assets, uint256 amount)
628         external
629         returns (uint256);
630 
631     /**
632      * @dev returns the unclaimed rewards of the user
633      * @param user the address of the user
634      * @return the unclaimed user rewards
635      */
636     function getUserUnclaimedRewards(address user)
637         external
638         view
639         returns (uint256);
640 
641     /**
642      * @dev for backward compatibility with previous implementation of the Incentives controller
643      */
644     function REWARD_TOKEN() external view returns (address);
645 }
646 
647 // File: contracts/libraries/DataTypes.sol
648 
649 
650 pragma solidity ^0.8.0;
651 
652 library DataTypes {
653     // refer to the whitepaper, section 1.1 basic concepts for a formal description of these properties.
654     struct ReserveData {
655         //stores the reserve configuration
656         ReserveConfigurationMap configuration;
657         //the liquidity index. Expressed in ray
658         uint128 liquidityIndex;
659         //variable borrow index. Expressed in ray
660         uint128 variableBorrowIndex;
661         //the current supply rate. Expressed in ray
662         uint128 currentLiquidityRate;
663         //the current variable borrow rate. Expressed in ray
664         uint128 currentVariableBorrowRate;
665         //the current stable borrow rate. Expressed in ray
666         uint128 currentStableBorrowRate;
667         uint40 lastUpdateTimestamp;
668         //tokens addresses
669         address aTokenAddress;
670         address stableDebtTokenAddress;
671         address variableDebtTokenAddress;
672         //address of the interest rate strategy
673         address interestRateStrategyAddress;
674         //the id of the reserve. Represents the position in the list of the active reserves
675         uint8 id;
676     }
677 
678     struct ReserveConfigurationMap {
679         //bit 0-15: LTV
680         //bit 16-31: Liq. threshold
681         //bit 32-47: Liq. bonus
682         //bit 48-55: Decimals
683         //bit 56: Reserve is active
684         //bit 57: reserve is frozen
685         //bit 58: borrowing is enabled
686         //bit 59: stable rate borrowing enabled
687         //bit 60-63: reserved
688         //bit 64-79: reserve factor
689         uint256 data;
690     }
691 
692     struct UserConfigurationMap {
693         uint256 data;
694     }
695 
696     enum InterestRateMode {
697         NONE,
698         STABLE,
699         VARIABLE
700     }
701 }
702 
703 // File: contracts/interfaces/ILendingPoolAddressesProvider.sol
704 
705 
706 pragma solidity ^0.8.0;
707 
708 /**
709  * @title LendingPoolAddressesProvider contract
710  * @dev Main registry of addresses part of or connected to the protocol, including permissioned roles
711  * - Acting also as factory of proxies and admin of those, so with right to change its implementations
712  * - Owned by the Aave Governance
713  * @author Aave
714  **/
715 interface ILendingPoolAddressesProvider {
716     event MarketIdSet(string newMarketId);
717     event LendingPoolUpdated(address indexed newAddress);
718     event ConfigurationAdminUpdated(address indexed newAddress);
719     event EmergencyAdminUpdated(address indexed newAddress);
720     event LendingPoolConfiguratorUpdated(address indexed newAddress);
721     event LendingPoolCollateralManagerUpdated(address indexed newAddress);
722     event PriceOracleUpdated(address indexed newAddress);
723     event LendingRateOracleUpdated(address indexed newAddress);
724     event ProxyCreated(bytes32 id, address indexed newAddress);
725     event AddressSet(bytes32 id, address indexed newAddress, bool hasProxy);
726 
727     function getMarketId() external view returns (string memory);
728 
729     function setMarketId(string calldata marketId) external;
730 
731     function setAddress(bytes32 id, address newAddress) external;
732 
733     function setAddressAsProxy(bytes32 id, address impl) external;
734 
735     function getAddress(bytes32 id) external view returns (address);
736 
737     function getLendingPool() external view returns (address);
738 
739     function setLendingPoolImpl(address pool) external;
740 
741     function getLendingPoolConfigurator() external view returns (address);
742 
743     function setLendingPoolConfiguratorImpl(address configurator) external;
744 
745     function getLendingPoolCollateralManager() external view returns (address);
746 
747     function setLendingPoolCollateralManager(address manager) external;
748 
749     function getPoolAdmin() external view returns (address);
750 
751     function setPoolAdmin(address admin) external;
752 
753     function getEmergencyAdmin() external view returns (address);
754 
755     function setEmergencyAdmin(address admin) external;
756 
757     function getPriceOracle() external view returns (address);
758 
759     function setPriceOracle(address priceOracle) external;
760 
761     function getLendingRateOracle() external view returns (address);
762 
763     function setLendingRateOracle(address lendingRateOracle) external;
764 }
765 
766 // File: contracts/interfaces/ILendingPool.sol
767 
768 
769 pragma solidity ^0.8.0;
770 
771 
772 interface ILendingPool {
773     /**
774      * @dev Emitted on deposit()
775      * @param reserve The address of the underlying asset of the reserve
776      * @param user The address initiating the deposit
777      * @param onBehalfOf The beneficiary of the deposit, receiving the aTokens
778      * @param amount The amount deposited
779      * @param referral The referral code used
780      **/
781     event Deposit(
782         address indexed reserve,
783         address user,
784         address indexed onBehalfOf,
785         uint256 amount,
786         uint16 indexed referral
787     );
788 
789     /**
790      * @dev Emitted on withdraw()
791      * @param reserve The address of the underlyng asset being withdrawn
792      * @param user The address initiating the withdrawal, owner of aTokens
793      * @param to Address that will receive the underlying
794      * @param amount The amount to be withdrawn
795      **/
796     event Withdraw(
797         address indexed reserve,
798         address indexed user,
799         address indexed to,
800         uint256 amount
801     );
802 
803     /**
804      * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
805      * @param reserve The address of the underlying asset being borrowed
806      * @param user The address of the user initiating the borrow(), receiving the funds on borrow() or just
807      * initiator of the transaction on flashLoan()
808      * @param onBehalfOf The address that will be getting the debt
809      * @param amount The amount borrowed out
810      * @param borrowRateMode The rate mode: 1 for Stable, 2 for Variable
811      * @param borrowRate The numeric rate at which the user has borrowed
812      * @param referral The referral code used
813      **/
814     event Borrow(
815         address indexed reserve,
816         address user,
817         address indexed onBehalfOf,
818         uint256 amount,
819         uint256 borrowRateMode,
820         uint256 borrowRate,
821         uint16 indexed referral
822     );
823 
824     /**
825      * @dev Emitted on repay()
826      * @param reserve The address of the underlying asset of the reserve
827      * @param user The beneficiary of the repayment, getting his debt reduced
828      * @param repayer The address of the user initiating the repay(), providing the funds
829      * @param amount The amount repaid
830      **/
831     event Repay(
832         address indexed reserve,
833         address indexed user,
834         address indexed repayer,
835         uint256 amount
836     );
837 
838     /**
839      * @dev Emitted on swapBorrowRateMode()
840      * @param reserve The address of the underlying asset of the reserve
841      * @param user The address of the user swapping his rate mode
842      * @param rateMode The rate mode that the user wants to swap to
843      **/
844     event Swap(address indexed reserve, address indexed user, uint256 rateMode);
845 
846     /**
847      * @dev Emitted on setUserUseReserveAsCollateral()
848      * @param reserve The address of the underlying asset of the reserve
849      * @param user The address of the user enabling the usage as collateral
850      **/
851     event ReserveUsedAsCollateralEnabled(
852         address indexed reserve,
853         address indexed user
854     );
855 
856     /**
857      * @dev Emitted on setUserUseReserveAsCollateral()
858      * @param reserve The address of the underlying asset of the reserve
859      * @param user The address of the user enabling the usage as collateral
860      **/
861     event ReserveUsedAsCollateralDisabled(
862         address indexed reserve,
863         address indexed user
864     );
865 
866     /**
867      * @dev Emitted on rebalanceStableBorrowRate()
868      * @param reserve The address of the underlying asset of the reserve
869      * @param user The address of the user for which the rebalance has been executed
870      **/
871     event RebalanceStableBorrowRate(
872         address indexed reserve,
873         address indexed user
874     );
875 
876     /**
877      * @dev Emitted on flashLoan()
878      * @param target The address of the flash loan receiver contract
879      * @param initiator The address initiating the flash loan
880      * @param asset The address of the asset being flash borrowed
881      * @param amount The amount flash borrowed
882      * @param premium The fee flash borrowed
883      * @param referralCode The referral code used
884      **/
885     event FlashLoan(
886         address indexed target,
887         address indexed initiator,
888         address indexed asset,
889         uint256 amount,
890         uint256 premium,
891         uint16 referralCode
892     );
893 
894     /**
895      * @dev Emitted when the pause is triggered.
896      */
897     event Paused();
898 
899     /**
900      * @dev Emitted when the pause is lifted.
901      */
902     event Unpaused();
903 
904     /**
905      * @dev Emitted when a borrower is liquidated. This event is emitted by the LendingPool via
906      * LendingPoolCollateral manager using a DELEGATECALL
907      * This allows to have the events in the generated ABI for LendingPool.
908      * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
909      * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
910      * @param user The address of the borrower getting liquidated
911      * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
912      * @param liquidatedCollateralAmount The amount of collateral received by the liiquidator
913      * @param liquidator The address of the liquidator
914      * @param receiveAToken `true` if the liquidators wants to receive the collateral aTokens, `false` if he wants
915      * to receive the underlying collateral asset directly
916      **/
917     event LiquidationCall(
918         address indexed collateralAsset,
919         address indexed debtAsset,
920         address indexed user,
921         uint256 debtToCover,
922         uint256 liquidatedCollateralAmount,
923         address liquidator,
924         bool receiveAToken
925     );
926 
927     /**
928      * @dev Emitted when the state of a reserve is updated. NOTE: This event is actually declared
929      * in the ReserveLogic library and emitted in the updateInterestRates() function. Since the function is internal,
930      * the event will actually be fired by the LendingPool contract. The event is therefore replicated here so it
931      * gets added to the LendingPool ABI
932      * @param reserve The address of the underlying asset of the reserve
933      * @param liquidityRate The new liquidity rate
934      * @param stableBorrowRate The new stable borrow rate
935      * @param variableBorrowRate The new variable borrow rate
936      * @param liquidityIndex The new liquidity index
937      * @param variableBorrowIndex The new variable borrow index
938      **/
939     event ReserveDataUpdated(
940         address indexed reserve,
941         uint256 liquidityRate,
942         uint256 stableBorrowRate,
943         uint256 variableBorrowRate,
944         uint256 liquidityIndex,
945         uint256 variableBorrowIndex
946     );
947 
948     /**
949      * @dev Deposits an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
950      * - E.g. User deposits 100 USDC and gets in return 100 aUSDC
951      * @param asset The address of the underlying asset to deposit
952      * @param amount The amount to be deposited
953      * @param onBehalfOf The address that will receive the aTokens, same as msg.sender if the user
954      *   wants to receive them on his own wallet, or a different address if the beneficiary of aTokens
955      *   is a different wallet
956      * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
957      *   0 if the action is executed directly by the user, without any middle-man
958      **/
959     function deposit(
960         address asset,
961         uint256 amount,
962         address onBehalfOf,
963         uint16 referralCode
964     ) external;
965 
966     /**
967      * @dev Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
968      * E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
969      * @param asset The address of the underlying asset to withdraw
970      * @param amount The underlying amount to be withdrawn
971      *   - Send the value type(uint256).max in order to withdraw the whole aToken balance
972      * @param to Address that will receive the underlying, same as msg.sender if the user
973      *   wants to receive it on his own wallet, or a different address if the beneficiary is a
974      *   different wallet
975      * @return The final amount withdrawn
976      **/
977     function withdraw(
978         address asset,
979         uint256 amount,
980         address to
981     ) external returns (uint256);
982 
983     /**
984      * @dev Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
985      * already deposited enough collateral, or he was given enough allowance by a credit delegator on the
986      * corresponding debt token (StableDebtToken or VariableDebtToken)
987      * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
988      *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
989      * @param asset The address of the underlying asset to borrow
990      * @param amount The amount to be borrowed
991      * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
992      * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
993      *   0 if the action is executed directly by the user, without any middle-man
994      * @param onBehalfOf Address of the user who will receive the debt. Should be the address of the borrower itself
995      * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
996      * if he has been given credit delegation allowance
997      **/
998     function borrow(
999         address asset,
1000         uint256 amount,
1001         uint256 interestRateMode,
1002         uint16 referralCode,
1003         address onBehalfOf
1004     ) external;
1005 
1006     /**
1007      * @notice Repays a borrowed `amount` on a specific reserve, burning the equivalent debt tokens owned
1008      * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
1009      * @param asset The address of the borrowed underlying asset previously borrowed
1010      * @param amount The amount to repay
1011      * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
1012      * @param rateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
1013      * @param onBehalfOf Address of the user who will get his debt reduced/removed. Should be the address of the
1014      * user calling the function if he wants to reduce/remove his own debt, or the address of any other
1015      * other borrower whose debt should be removed
1016      * @return The final amount repaid
1017      **/
1018     function repay(
1019         address asset,
1020         uint256 amount,
1021         uint256 rateMode,
1022         address onBehalfOf
1023     ) external returns (uint256);
1024 
1025     /**
1026      * @dev Allows a borrower to swap his debt between stable and variable mode, or viceversa
1027      * @param asset The address of the underlying asset borrowed
1028      * @param rateMode The rate mode that the user wants to swap to
1029      **/
1030     function swapBorrowRateMode(address asset, uint256 rateMode) external;
1031 
1032     /**
1033      * @dev Rebalances the stable interest rate of a user to the current stable rate defined on the reserve.
1034      * - Users can be rebalanced if the following conditions are satisfied:
1035      *     1. Usage ratio is above 95%
1036      *     2. the current deposit APY is below REBALANCE_UP_THRESHOLD * maxVariableBorrowRate, which means that too much has been
1037      *        borrowed at a stable rate and depositors are not earning enough
1038      * @param asset The address of the underlying asset borrowed
1039      * @param user The address of the user to be rebalanced
1040      **/
1041     function rebalanceStableBorrowRate(address asset, address user) external;
1042 
1043     /**
1044      * @dev Allows depositors to enable/disable a specific deposited asset as collateral
1045      * @param asset The address of the underlying asset deposited
1046      * @param useAsCollateral `true` if the user wants to use the deposit as collateral, `false` otherwise
1047      **/
1048     function setUserUseReserveAsCollateral(address asset, bool useAsCollateral)
1049         external;
1050 
1051     /**
1052      * @dev Function to liquidate a non-healthy position collateral-wise, with Health Factor below 1
1053      * - The caller (liquidator) covers `debtToCover` amount of debt of the user getting liquidated, and receives
1054      *   a proportionally amount of the `collateralAsset` plus a bonus to cover market risk
1055      * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
1056      * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
1057      * @param user The address of the borrower getting liquidated
1058      * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
1059      * @param receiveAToken `true` if the liquidators wants to receive the collateral aTokens, `false` if he wants
1060      * to receive the underlying collateral asset directly
1061      **/
1062     function liquidationCall(
1063         address collateralAsset,
1064         address debtAsset,
1065         address user,
1066         uint256 debtToCover,
1067         bool receiveAToken
1068     ) external;
1069 
1070     /**
1071      * @dev Allows smartcontracts to access the liquidity of the pool within one transaction,
1072      * as long as the amount taken plus a fee is returned.
1073      * IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept into consideration.
1074      * For further details please visit https://developers.aave.com
1075      * @param receiverAddress The address of the contract receiving the funds, implementing the IFlashLoanReceiver interface
1076      * @param assets The addresses of the assets being flash-borrowed
1077      * @param amounts The amounts amounts being flash-borrowed
1078      * @param modes Types of the debt to open if the flash loan is not returned:
1079      *   0 -> Don't open any debt, just revert if funds can't be transferred from the receiver
1080      *   1 -> Open debt at stable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
1081      *   2 -> Open debt at variable rate for the value of the amount flash-borrowed to the `onBehalfOf` address
1082      * @param onBehalfOf The address  that will receive the debt in the case of using on `modes` 1 or 2
1083      * @param params Variadic packed params to pass to the receiver as extra information
1084      * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
1085      *   0 if the action is executed directly by the user, without any middle-man
1086      **/
1087     function flashLoan(
1088         address receiverAddress,
1089         address[] calldata assets,
1090         uint256[] calldata amounts,
1091         uint256[] calldata modes,
1092         address onBehalfOf,
1093         bytes calldata params,
1094         uint16 referralCode
1095     ) external;
1096 
1097     /**
1098      * @dev Returns the user account data across all the reserves
1099      * @param user The address of the user
1100      * @return totalCollateralETH the total collateral in ETH of the user
1101      * @return totalDebtETH the total debt in ETH of the user
1102      * @return availableBorrowsETH the borrowing power left of the user
1103      * @return currentLiquidationThreshold the liquidation threshold of the user
1104      * @return ltv the loan to value of the user
1105      * @return healthFactor the current health factor of the user
1106      **/
1107     function getUserAccountData(address user)
1108         external
1109         view
1110         returns (
1111             uint256 totalCollateralETH,
1112             uint256 totalDebtETH,
1113             uint256 availableBorrowsETH,
1114             uint256 currentLiquidationThreshold,
1115             uint256 ltv,
1116             uint256 healthFactor
1117         );
1118 
1119     function initReserve(
1120         address reserve,
1121         address aTokenAddress,
1122         address stableDebtAddress,
1123         address variableDebtAddress,
1124         address interestRateStrategyAddress
1125     ) external;
1126 
1127     function setReserveInterestRateStrategyAddress(
1128         address reserve,
1129         address rateStrategyAddress
1130     ) external;
1131 
1132     function setConfiguration(address reserve, uint256 configuration) external;
1133 
1134     /**
1135      * @dev Returns the configuration of the reserve
1136      * @param asset The address of the underlying asset of the reserve
1137      * @return The configuration of the reserve
1138      **/
1139     function getConfiguration(address asset)
1140         external
1141         view
1142         returns (DataTypes.ReserveConfigurationMap memory);
1143 
1144     /**
1145      * @dev Returns the configuration of the user across all the reserves
1146      * @param user The user address
1147      * @return The configuration of the user
1148      **/
1149     function getUserConfiguration(address user)
1150         external
1151         view
1152         returns (DataTypes.UserConfigurationMap memory);
1153 
1154     /**
1155      * @dev Returns the normalized income normalized income of the reserve
1156      * @param asset The address of the underlying asset of the reserve
1157      * @return The reserve's normalized income
1158      */
1159     function getReserveNormalizedIncome(address asset)
1160         external
1161         view
1162         returns (uint256);
1163 
1164     /**
1165      * @dev Returns the normalized variable debt per unit of asset
1166      * @param asset The address of the underlying asset of the reserve
1167      * @return The reserve normalized variable debt
1168      */
1169     function getReserveNormalizedVariableDebt(address asset)
1170         external
1171         view
1172         returns (uint256);
1173 
1174     /**
1175      * @dev Returns the state and configuration of the reserve
1176      * @param asset The address of the underlying asset of the reserve
1177      * @return The state of the reserve
1178      **/
1179     function getReserveData(address asset)
1180         external
1181         view
1182         returns (DataTypes.ReserveData memory);
1183 
1184     function finalizeTransfer(
1185         address asset,
1186         address from,
1187         address to,
1188         uint256 amount,
1189         uint256 balanceFromAfter,
1190         uint256 balanceToBefore
1191     ) external;
1192 
1193     function getReservesList() external view returns (address[] memory);
1194 
1195     function getAddressesProvider()
1196         external
1197         view
1198         returns (ILendingPoolAddressesProvider);
1199 
1200     function setPause(bool val) external;
1201 
1202     function paused() external view returns (bool);
1203 }
1204 
1205 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1206 
1207 
1208 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1209 
1210 pragma solidity ^0.8.0;
1211 
1212 /**
1213  * @dev Contract module that helps prevent reentrant calls to a function.
1214  *
1215  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1216  * available, which can be applied to functions to make sure there are no nested
1217  * (reentrant) calls to them.
1218  *
1219  * Note that because there is a single `nonReentrant` guard, functions marked as
1220  * `nonReentrant` may not call one another. This can be worked around by making
1221  * those functions `private`, and then adding `external` `nonReentrant` entry
1222  * points to them.
1223  *
1224  * TIP: If you would like to learn more about reentrancy and alternative ways
1225  * to protect against it, check out our blog post
1226  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1227  */
1228 abstract contract ReentrancyGuard {
1229     // Booleans are more expensive than uint256 or any type that takes up a full
1230     // word because each write operation emits an extra SLOAD to first read the
1231     // slot's contents, replace the bits taken up by the boolean, and then write
1232     // back. This is the compiler's defense against contract upgrades and
1233     // pointer aliasing, and it cannot be disabled.
1234 
1235     // The values being non-zero value makes deployment a bit more expensive,
1236     // but in exchange the refund on every call to nonReentrant will be lower in
1237     // amount. Since refunds are capped to a percentage of the total
1238     // transaction's gas, it is best to keep them low in cases like this one, to
1239     // increase the likelihood of the full refund coming into effect.
1240     uint256 private constant _NOT_ENTERED = 1;
1241     uint256 private constant _ENTERED = 2;
1242 
1243     uint256 private _status;
1244 
1245     constructor() {
1246         _status = _NOT_ENTERED;
1247     }
1248 
1249     /**
1250      * @dev Prevents a contract from calling itself, directly or indirectly.
1251      * Calling a `nonReentrant` function from another `nonReentrant`
1252      * function is not supported. It is possible to prevent this from happening
1253      * by making the `nonReentrant` function external, and making it call a
1254      * `private` function that does the actual work.
1255      */
1256     modifier nonReentrant() {
1257         // On the first call to nonReentrant, _notEntered will be true
1258         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1259 
1260         // Any calls to nonReentrant after this point will fail
1261         _status = _ENTERED;
1262 
1263         _;
1264 
1265         // By storing the original value once again, a refund is triggered (see
1266         // https://eips.ethereum.org/EIPS/eip-2200)
1267         _status = _NOT_ENTERED;
1268     }
1269 }
1270 
1271 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1272 
1273 
1274 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1275 
1276 pragma solidity ^0.8.0;
1277 
1278 /**
1279  * @dev Interface of the ERC20 standard as defined in the EIP.
1280  */
1281 interface IERC20 {
1282     /**
1283      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1284      * another (`to`).
1285      *
1286      * Note that `value` may be zero.
1287      */
1288     event Transfer(address indexed from, address indexed to, uint256 value);
1289 
1290     /**
1291      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1292      * a call to {approve}. `value` is the new allowance.
1293      */
1294     event Approval(address indexed owner, address indexed spender, uint256 value);
1295 
1296     /**
1297      * @dev Returns the amount of tokens in existence.
1298      */
1299     function totalSupply() external view returns (uint256);
1300 
1301     /**
1302      * @dev Returns the amount of tokens owned by `account`.
1303      */
1304     function balanceOf(address account) external view returns (uint256);
1305 
1306     /**
1307      * @dev Moves `amount` tokens from the caller's account to `to`.
1308      *
1309      * Returns a boolean value indicating whether the operation succeeded.
1310      *
1311      * Emits a {Transfer} event.
1312      */
1313     function transfer(address to, uint256 amount) external returns (bool);
1314 
1315     /**
1316      * @dev Returns the remaining number of tokens that `spender` will be
1317      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1318      * zero by default.
1319      *
1320      * This value changes when {approve} or {transferFrom} are called.
1321      */
1322     function allowance(address owner, address spender) external view returns (uint256);
1323 
1324     /**
1325      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1326      *
1327      * Returns a boolean value indicating whether the operation succeeded.
1328      *
1329      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1330      * that someone may use both the old and the new allowance by unfortunate
1331      * transaction ordering. One possible solution to mitigate this race
1332      * condition is to first reduce the spender's allowance to 0 and set the
1333      * desired value afterwards:
1334      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1335      *
1336      * Emits an {Approval} event.
1337      */
1338     function approve(address spender, uint256 amount) external returns (bool);
1339 
1340     /**
1341      * @dev Moves `amount` tokens from `from` to `to` using the
1342      * allowance mechanism. `amount` is then deducted from the caller's
1343      * allowance.
1344      *
1345      * Returns a boolean value indicating whether the operation succeeded.
1346      *
1347      * Emits a {Transfer} event.
1348      */
1349     function transferFrom(
1350         address from,
1351         address to,
1352         uint256 amount
1353     ) external returns (bool);
1354 }
1355 
1356 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1357 
1358 
1359 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1360 
1361 pragma solidity ^0.8.0;
1362 
1363 
1364 /**
1365  * @dev Interface for the optional metadata functions from the ERC20 standard.
1366  *
1367  * _Available since v4.1._
1368  */
1369 interface IERC20Metadata is IERC20 {
1370     /**
1371      * @dev Returns the name of the token.
1372      */
1373     function name() external view returns (string memory);
1374 
1375     /**
1376      * @dev Returns the symbol of the token.
1377      */
1378     function symbol() external view returns (string memory);
1379 
1380     /**
1381      * @dev Returns the decimals places of the token.
1382      */
1383     function decimals() external view returns (uint8);
1384 }
1385 
1386 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
1387 
1388 
1389 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1390 
1391 pragma solidity ^0.8.1;
1392 
1393 /**
1394  * @dev Collection of functions related to the address type
1395  */
1396 library AddressUpgradeable {
1397     /**
1398      * @dev Returns true if `account` is a contract.
1399      *
1400      * [IMPORTANT]
1401      * ====
1402      * It is unsafe to assume that an address for which this function returns
1403      * false is an externally-owned account (EOA) and not a contract.
1404      *
1405      * Among others, `isContract` will return false for the following
1406      * types of addresses:
1407      *
1408      *  - an externally-owned account
1409      *  - a contract in construction
1410      *  - an address where a contract will be created
1411      *  - an address where a contract lived, but was destroyed
1412      * ====
1413      *
1414      * [IMPORTANT]
1415      * ====
1416      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1417      *
1418      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1419      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1420      * constructor.
1421      * ====
1422      */
1423     function isContract(address account) internal view returns (bool) {
1424         // This method relies on extcodesize/address.code.length, which returns 0
1425         // for contracts in construction, since the code is only stored at the end
1426         // of the constructor execution.
1427 
1428         return account.code.length > 0;
1429     }
1430 
1431     /**
1432      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1433      * `recipient`, forwarding all available gas and reverting on errors.
1434      *
1435      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1436      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1437      * imposed by `transfer`, making them unable to receive funds via
1438      * `transfer`. {sendValue} removes this limitation.
1439      *
1440      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1441      *
1442      * IMPORTANT: because control is transferred to `recipient`, care must be
1443      * taken to not create reentrancy vulnerabilities. Consider using
1444      * {ReentrancyGuard} or the
1445      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1446      */
1447     function sendValue(address payable recipient, uint256 amount) internal {
1448         require(address(this).balance >= amount, "Address: insufficient balance");
1449 
1450         (bool success, ) = recipient.call{value: amount}("");
1451         require(success, "Address: unable to send value, recipient may have reverted");
1452     }
1453 
1454     /**
1455      * @dev Performs a Solidity function call using a low level `call`. A
1456      * plain `call` is an unsafe replacement for a function call: use this
1457      * function instead.
1458      *
1459      * If `target` reverts with a revert reason, it is bubbled up by this
1460      * function (like regular Solidity function calls).
1461      *
1462      * Returns the raw returned data. To convert to the expected return value,
1463      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1464      *
1465      * Requirements:
1466      *
1467      * - `target` must be a contract.
1468      * - calling `target` with `data` must not revert.
1469      *
1470      * _Available since v3.1._
1471      */
1472     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1473         return functionCall(target, data, "Address: low-level call failed");
1474     }
1475 
1476     /**
1477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1478      * `errorMessage` as a fallback revert reason when `target` reverts.
1479      *
1480      * _Available since v3.1._
1481      */
1482     function functionCall(
1483         address target,
1484         bytes memory data,
1485         string memory errorMessage
1486     ) internal returns (bytes memory) {
1487         return functionCallWithValue(target, data, 0, errorMessage);
1488     }
1489 
1490     /**
1491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1492      * but also transferring `value` wei to `target`.
1493      *
1494      * Requirements:
1495      *
1496      * - the calling contract must have an ETH balance of at least `value`.
1497      * - the called Solidity function must be `payable`.
1498      *
1499      * _Available since v3.1._
1500      */
1501     function functionCallWithValue(
1502         address target,
1503         bytes memory data,
1504         uint256 value
1505     ) internal returns (bytes memory) {
1506         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1507     }
1508 
1509     /**
1510      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1511      * with `errorMessage` as a fallback revert reason when `target` reverts.
1512      *
1513      * _Available since v3.1._
1514      */
1515     function functionCallWithValue(
1516         address target,
1517         bytes memory data,
1518         uint256 value,
1519         string memory errorMessage
1520     ) internal returns (bytes memory) {
1521         require(address(this).balance >= value, "Address: insufficient balance for call");
1522         require(isContract(target), "Address: call to non-contract");
1523 
1524         (bool success, bytes memory returndata) = target.call{value: value}(data);
1525         return verifyCallResult(success, returndata, errorMessage);
1526     }
1527 
1528     /**
1529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1530      * but performing a static call.
1531      *
1532      * _Available since v3.3._
1533      */
1534     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1535         return functionStaticCall(target, data, "Address: low-level static call failed");
1536     }
1537 
1538     /**
1539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1540      * but performing a static call.
1541      *
1542      * _Available since v3.3._
1543      */
1544     function functionStaticCall(
1545         address target,
1546         bytes memory data,
1547         string memory errorMessage
1548     ) internal view returns (bytes memory) {
1549         require(isContract(target), "Address: static call to non-contract");
1550 
1551         (bool success, bytes memory returndata) = target.staticcall(data);
1552         return verifyCallResult(success, returndata, errorMessage);
1553     }
1554 
1555     /**
1556      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1557      * revert reason using the provided one.
1558      *
1559      * _Available since v4.3._
1560      */
1561     function verifyCallResult(
1562         bool success,
1563         bytes memory returndata,
1564         string memory errorMessage
1565     ) internal pure returns (bytes memory) {
1566         if (success) {
1567             return returndata;
1568         } else {
1569             // Look for revert reason and bubble it up if present
1570             if (returndata.length > 0) {
1571                 // The easiest way to bubble the revert reason is using memory via assembly
1572 
1573                 assembly {
1574                     let returndata_size := mload(returndata)
1575                     revert(add(32, returndata), returndata_size)
1576                 }
1577             } else {
1578                 revert(errorMessage);
1579             }
1580         }
1581     }
1582 }
1583 
1584 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
1585 
1586 
1587 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/utils/Initializable.sol)
1588 
1589 pragma solidity ^0.8.2;
1590 
1591 
1592 /**
1593  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
1594  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
1595  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
1596  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
1597  *
1598  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
1599  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
1600  * case an upgrade adds a module that needs to be initialized.
1601  *
1602  * For example:
1603  *
1604  * [.hljs-theme-light.nopadding]
1605  * ```
1606  * contract MyToken is ERC20Upgradeable {
1607  *     function initialize() initializer public {
1608  *         __ERC20_init("MyToken", "MTK");
1609  *     }
1610  * }
1611  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
1612  *     function initializeV2() reinitializer(2) public {
1613  *         __ERC20Permit_init("MyToken");
1614  *     }
1615  * }
1616  * ```
1617  *
1618  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
1619  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
1620  *
1621  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
1622  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
1623  *
1624  * [CAUTION]
1625  * ====
1626  * Avoid leaving a contract uninitialized.
1627  *
1628  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
1629  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
1630  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
1631  *
1632  * [.hljs-theme-light.nopadding]
1633  * ```
1634  * /// @custom:oz-upgrades-unsafe-allow constructor
1635  * constructor() {
1636  *     _disableInitializers();
1637  * }
1638  * ```
1639  * ====
1640  */
1641 abstract contract Initializable {
1642     /**
1643      * @dev Indicates that the contract has been initialized.
1644      * @custom:oz-retyped-from bool
1645      */
1646     uint8 private _initialized;
1647 
1648     /**
1649      * @dev Indicates that the contract is in the process of being initialized.
1650      */
1651     bool private _initializing;
1652 
1653     /**
1654      * @dev Triggered when the contract has been initialized or reinitialized.
1655      */
1656     event Initialized(uint8 version);
1657 
1658     /**
1659      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
1660      * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
1661      */
1662     modifier initializer() {
1663         bool isTopLevelCall = _setInitializedVersion(1);
1664         if (isTopLevelCall) {
1665             _initializing = true;
1666         }
1667         _;
1668         if (isTopLevelCall) {
1669             _initializing = false;
1670             emit Initialized(1);
1671         }
1672     }
1673 
1674     /**
1675      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
1676      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
1677      * used to initialize parent contracts.
1678      *
1679      * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
1680      * initialization step. This is essential to configure modules that are added through upgrades and that require
1681      * initialization.
1682      *
1683      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
1684      * a contract, executing them in the right order is up to the developer or operator.
1685      */
1686     modifier reinitializer(uint8 version) {
1687         bool isTopLevelCall = _setInitializedVersion(version);
1688         if (isTopLevelCall) {
1689             _initializing = true;
1690         }
1691         _;
1692         if (isTopLevelCall) {
1693             _initializing = false;
1694             emit Initialized(version);
1695         }
1696     }
1697 
1698     /**
1699      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
1700      * {initializer} and {reinitializer} modifiers, directly or indirectly.
1701      */
1702     modifier onlyInitializing() {
1703         require(_initializing, "Initializable: contract is not initializing");
1704         _;
1705     }
1706 
1707     /**
1708      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
1709      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
1710      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
1711      * through proxies.
1712      */
1713     function _disableInitializers() internal virtual {
1714         _setInitializedVersion(type(uint8).max);
1715     }
1716 
1717     function _setInitializedVersion(uint8 version) private returns (bool) {
1718         // If the contract is initializing we ignore whether _initialized is set in order to support multiple
1719         // inheritance patterns, but we only do this in the context of a constructor, and for the lowest level
1720         // of initializers, because in other contexts the contract may have been reentered.
1721         if (_initializing) {
1722             require(
1723                 version == 1 && !AddressUpgradeable.isContract(address(this)),
1724                 "Initializable: contract is already initialized"
1725             );
1726             return false;
1727         } else {
1728             require(_initialized < version, "Initializable: contract is already initialized");
1729             _initialized = version;
1730             return true;
1731         }
1732     }
1733 }
1734 
1735 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
1736 
1737 
1738 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1739 
1740 pragma solidity ^0.8.0;
1741 
1742 
1743 /**
1744  * @dev Provides information about the current execution context, including the
1745  * sender of the transaction and its data. While these are generally available
1746  * via msg.sender and msg.data, they should not be accessed in such a direct
1747  * manner, since when dealing with meta-transactions the account sending and
1748  * paying for execution may not be the actual sender (as far as an application
1749  * is concerned).
1750  *
1751  * This contract is only required for intermediate, library-like contracts.
1752  */
1753 abstract contract ContextUpgradeable is Initializable {
1754     function __Context_init() internal onlyInitializing {
1755     }
1756 
1757     function __Context_init_unchained() internal onlyInitializing {
1758     }
1759     function _msgSender() internal view virtual returns (address) {
1760         return msg.sender;
1761     }
1762 
1763     function _msgData() internal view virtual returns (bytes calldata) {
1764         return msg.data;
1765     }
1766 
1767     /**
1768      * @dev This empty reserved space is put in place to allow future versions to add new
1769      * variables without shifting down storage in the inheritance chain.
1770      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1771      */
1772     uint256[50] private __gap;
1773 }
1774 
1775 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
1776 
1777 
1778 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1779 
1780 pragma solidity ^0.8.0;
1781 
1782 
1783 
1784 /**
1785  * @dev Contract module which provides a basic access control mechanism, where
1786  * there is an account (an owner) that can be granted exclusive access to
1787  * specific functions.
1788  *
1789  * By default, the owner account will be the one that deploys the contract. This
1790  * can later be changed with {transferOwnership}.
1791  *
1792  * This module is used through inheritance. It will make available the modifier
1793  * `onlyOwner`, which can be applied to your functions to restrict their use to
1794  * the owner.
1795  */
1796 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1797     address private _owner;
1798 
1799     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1800 
1801     /**
1802      * @dev Initializes the contract setting the deployer as the initial owner.
1803      */
1804     function __Ownable_init() internal onlyInitializing {
1805         __Ownable_init_unchained();
1806     }
1807 
1808     function __Ownable_init_unchained() internal onlyInitializing {
1809         _transferOwnership(_msgSender());
1810     }
1811 
1812     /**
1813      * @dev Returns the address of the current owner.
1814      */
1815     function owner() public view virtual returns (address) {
1816         return _owner;
1817     }
1818 
1819     /**
1820      * @dev Throws if called by any account other than the owner.
1821      */
1822     modifier onlyOwner() {
1823         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1824         _;
1825     }
1826 
1827     /**
1828      * @dev Leaves the contract without owner. It will not be possible to call
1829      * `onlyOwner` functions anymore. Can only be called by the current owner.
1830      *
1831      * NOTE: Renouncing ownership will leave the contract without an owner,
1832      * thereby removing any functionality that is only available to the owner.
1833      */
1834     function renounceOwnership() public virtual onlyOwner {
1835         _transferOwnership(address(0));
1836     }
1837 
1838     /**
1839      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1840      * Can only be called by the current owner.
1841      */
1842     function transferOwnership(address newOwner) public virtual onlyOwner {
1843         require(newOwner != address(0), "Ownable: new owner is the zero address");
1844         _transferOwnership(newOwner);
1845     }
1846 
1847     /**
1848      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1849      * Internal function without access restriction.
1850      */
1851     function _transferOwnership(address newOwner) internal virtual {
1852         address oldOwner = _owner;
1853         _owner = newOwner;
1854         emit OwnershipTransferred(oldOwner, newOwner);
1855     }
1856 
1857     /**
1858      * @dev This empty reserved space is put in place to allow future versions to add new
1859      * variables without shifting down storage in the inheritance chain.
1860      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1861      */
1862     uint256[49] private __gap;
1863 }
1864 
1865 // File: @openzeppelin/contracts/utils/Context.sol
1866 
1867 
1868 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1869 
1870 pragma solidity ^0.8.0;
1871 
1872 /**
1873  * @dev Provides information about the current execution context, including the
1874  * sender of the transaction and its data. While these are generally available
1875  * via msg.sender and msg.data, they should not be accessed in such a direct
1876  * manner, since when dealing with meta-transactions the account sending and
1877  * paying for execution may not be the actual sender (as far as an application
1878  * is concerned).
1879  *
1880  * This contract is only required for intermediate, library-like contracts.
1881  */
1882 abstract contract Context {
1883     function _msgSender() internal view virtual returns (address) {
1884         return msg.sender;
1885     }
1886 
1887     function _msgData() internal view virtual returns (bytes calldata) {
1888         return msg.data;
1889     }
1890 }
1891 
1892 // File: @openzeppelin/contracts/security/Pausable.sol
1893 
1894 
1895 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1896 
1897 pragma solidity ^0.8.0;
1898 
1899 
1900 /**
1901  * @dev Contract module which allows children to implement an emergency stop
1902  * mechanism that can be triggered by an authorized account.
1903  *
1904  * This module is used through inheritance. It will make available the
1905  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1906  * the functions of your contract. Note that they will not be pausable by
1907  * simply including this module, only once the modifiers are put in place.
1908  */
1909 abstract contract Pausable is Context {
1910     /**
1911      * @dev Emitted when the pause is triggered by `account`.
1912      */
1913     event Paused(address account);
1914 
1915     /**
1916      * @dev Emitted when the pause is lifted by `account`.
1917      */
1918     event Unpaused(address account);
1919 
1920     bool private _paused;
1921 
1922     /**
1923      * @dev Initializes the contract in unpaused state.
1924      */
1925     constructor() {
1926         _paused = false;
1927     }
1928 
1929     /**
1930      * @dev Returns true if the contract is paused, and false otherwise.
1931      */
1932     function paused() public view virtual returns (bool) {
1933         return _paused;
1934     }
1935 
1936     /**
1937      * @dev Modifier to make a function callable only when the contract is not paused.
1938      *
1939      * Requirements:
1940      *
1941      * - The contract must not be paused.
1942      */
1943     modifier whenNotPaused() {
1944         require(!paused(), "Pausable: paused");
1945         _;
1946     }
1947 
1948     /**
1949      * @dev Modifier to make a function callable only when the contract is paused.
1950      *
1951      * Requirements:
1952      *
1953      * - The contract must be paused.
1954      */
1955     modifier whenPaused() {
1956         require(paused(), "Pausable: not paused");
1957         _;
1958     }
1959 
1960     /**
1961      * @dev Triggers stopped state.
1962      *
1963      * Requirements:
1964      *
1965      * - The contract must not be paused.
1966      */
1967     function _pause() internal virtual whenNotPaused {
1968         _paused = true;
1969         emit Paused(_msgSender());
1970     }
1971 
1972     /**
1973      * @dev Returns to normal state.
1974      *
1975      * Requirements:
1976      *
1977      * - The contract must be paused.
1978      */
1979     function _unpause() internal virtual whenPaused {
1980         _paused = false;
1981         emit Unpaused(_msgSender());
1982     }
1983 }
1984 
1985 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1986 
1987 
1988 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
1989 
1990 pragma solidity ^0.8.0;
1991 
1992 
1993 
1994 
1995 /**
1996  * @dev Implementation of the {IERC20} interface.
1997  *
1998  * This implementation is agnostic to the way tokens are created. This means
1999  * that a supply mechanism has to be added in a derived contract using {_mint}.
2000  * For a generic mechanism see {ERC20PresetMinterPauser}.
2001  *
2002  * TIP: For a detailed writeup see our guide
2003  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2004  * to implement supply mechanisms].
2005  *
2006  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2007  * instead returning `false` on failure. This behavior is nonetheless
2008  * conventional and does not conflict with the expectations of ERC20
2009  * applications.
2010  *
2011  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2012  * This allows applications to reconstruct the allowance for all accounts just
2013  * by listening to said events. Other implementations of the EIP may not emit
2014  * these events, as it isn't required by the specification.
2015  *
2016  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2017  * functions have been added to mitigate the well-known issues around setting
2018  * allowances. See {IERC20-approve}.
2019  */
2020 contract ERC20 is Context, IERC20, IERC20Metadata {
2021     mapping(address => uint256) private _balances;
2022 
2023     mapping(address => mapping(address => uint256)) private _allowances;
2024 
2025     uint256 private _totalSupply;
2026 
2027     string private _name;
2028     string private _symbol;
2029 
2030     /**
2031      * @dev Sets the values for {name} and {symbol}.
2032      *
2033      * The default value of {decimals} is 18. To select a different value for
2034      * {decimals} you should overload it.
2035      *
2036      * All two of these values are immutable: they can only be set once during
2037      * construction.
2038      */
2039     constructor(string memory name_, string memory symbol_) {
2040         _name = name_;
2041         _symbol = symbol_;
2042     }
2043 
2044     /**
2045      * @dev Returns the name of the token.
2046      */
2047     function name() public view virtual override returns (string memory) {
2048         return _name;
2049     }
2050 
2051     /**
2052      * @dev Returns the symbol of the token, usually a shorter version of the
2053      * name.
2054      */
2055     function symbol() public view virtual override returns (string memory) {
2056         return _symbol;
2057     }
2058 
2059     /**
2060      * @dev Returns the number of decimals used to get its user representation.
2061      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2062      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2063      *
2064      * Tokens usually opt for a value of 18, imitating the relationship between
2065      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2066      * overridden;
2067      *
2068      * NOTE: This information is only used for _display_ purposes: it in
2069      * no way affects any of the arithmetic of the contract, including
2070      * {IERC20-balanceOf} and {IERC20-transfer}.
2071      */
2072     function decimals() public view virtual override returns (uint8) {
2073         return 18;
2074     }
2075 
2076     /**
2077      * @dev See {IERC20-totalSupply}.
2078      */
2079     function totalSupply() public view virtual override returns (uint256) {
2080         return _totalSupply;
2081     }
2082 
2083     /**
2084      * @dev See {IERC20-balanceOf}.
2085      */
2086     function balanceOf(address account) public view virtual override returns (uint256) {
2087         return _balances[account];
2088     }
2089 
2090     /**
2091      * @dev See {IERC20-transfer}.
2092      *
2093      * Requirements:
2094      *
2095      * - `to` cannot be the zero address.
2096      * - the caller must have a balance of at least `amount`.
2097      */
2098     function transfer(address to, uint256 amount) public virtual override returns (bool) {
2099         address owner = _msgSender();
2100         _transfer(owner, to, amount);
2101         return true;
2102     }
2103 
2104     /**
2105      * @dev See {IERC20-allowance}.
2106      */
2107     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2108         return _allowances[owner][spender];
2109     }
2110 
2111     /**
2112      * @dev See {IERC20-approve}.
2113      *
2114      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2115      * `transferFrom`. This is semantically equivalent to an infinite approval.
2116      *
2117      * Requirements:
2118      *
2119      * - `spender` cannot be the zero address.
2120      */
2121     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2122         address owner = _msgSender();
2123         _approve(owner, spender, amount);
2124         return true;
2125     }
2126 
2127     /**
2128      * @dev See {IERC20-transferFrom}.
2129      *
2130      * Emits an {Approval} event indicating the updated allowance. This is not
2131      * required by the EIP. See the note at the beginning of {ERC20}.
2132      *
2133      * NOTE: Does not update the allowance if the current allowance
2134      * is the maximum `uint256`.
2135      *
2136      * Requirements:
2137      *
2138      * - `from` and `to` cannot be the zero address.
2139      * - `from` must have a balance of at least `amount`.
2140      * - the caller must have allowance for ``from``'s tokens of at least
2141      * `amount`.
2142      */
2143     function transferFrom(
2144         address from,
2145         address to,
2146         uint256 amount
2147     ) public virtual override returns (bool) {
2148         address spender = _msgSender();
2149         _spendAllowance(from, spender, amount);
2150         _transfer(from, to, amount);
2151         return true;
2152     }
2153 
2154     /**
2155      * @dev Atomically increases the allowance granted to `spender` by the caller.
2156      *
2157      * This is an alternative to {approve} that can be used as a mitigation for
2158      * problems described in {IERC20-approve}.
2159      *
2160      * Emits an {Approval} event indicating the updated allowance.
2161      *
2162      * Requirements:
2163      *
2164      * - `spender` cannot be the zero address.
2165      */
2166     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2167         address owner = _msgSender();
2168         _approve(owner, spender, allowance(owner, spender) + addedValue);
2169         return true;
2170     }
2171 
2172     /**
2173      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2174      *
2175      * This is an alternative to {approve} that can be used as a mitigation for
2176      * problems described in {IERC20-approve}.
2177      *
2178      * Emits an {Approval} event indicating the updated allowance.
2179      *
2180      * Requirements:
2181      *
2182      * - `spender` cannot be the zero address.
2183      * - `spender` must have allowance for the caller of at least
2184      * `subtractedValue`.
2185      */
2186     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2187         address owner = _msgSender();
2188         uint256 currentAllowance = allowance(owner, spender);
2189         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2190         unchecked {
2191             _approve(owner, spender, currentAllowance - subtractedValue);
2192         }
2193 
2194         return true;
2195     }
2196 
2197     /**
2198      * @dev Moves `amount` of tokens from `sender` to `recipient`.
2199      *
2200      * This internal function is equivalent to {transfer}, and can be used to
2201      * e.g. implement automatic token fees, slashing mechanisms, etc.
2202      *
2203      * Emits a {Transfer} event.
2204      *
2205      * Requirements:
2206      *
2207      * - `from` cannot be the zero address.
2208      * - `to` cannot be the zero address.
2209      * - `from` must have a balance of at least `amount`.
2210      */
2211     function _transfer(
2212         address from,
2213         address to,
2214         uint256 amount
2215     ) internal virtual {
2216         require(from != address(0), "ERC20: transfer from the zero address");
2217         require(to != address(0), "ERC20: transfer to the zero address");
2218 
2219         _beforeTokenTransfer(from, to, amount);
2220 
2221         uint256 fromBalance = _balances[from];
2222         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
2223         unchecked {
2224             _balances[from] = fromBalance - amount;
2225         }
2226         _balances[to] += amount;
2227 
2228         emit Transfer(from, to, amount);
2229 
2230         _afterTokenTransfer(from, to, amount);
2231     }
2232 
2233     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2234      * the total supply.
2235      *
2236      * Emits a {Transfer} event with `from` set to the zero address.
2237      *
2238      * Requirements:
2239      *
2240      * - `account` cannot be the zero address.
2241      */
2242     function _mint(address account, uint256 amount) internal virtual {
2243         require(account != address(0), "ERC20: mint to the zero address");
2244 
2245         _beforeTokenTransfer(address(0), account, amount);
2246 
2247         _totalSupply += amount;
2248         _balances[account] += amount;
2249         emit Transfer(address(0), account, amount);
2250 
2251         _afterTokenTransfer(address(0), account, amount);
2252     }
2253 
2254     /**
2255      * @dev Destroys `amount` tokens from `account`, reducing the
2256      * total supply.
2257      *
2258      * Emits a {Transfer} event with `to` set to the zero address.
2259      *
2260      * Requirements:
2261      *
2262      * - `account` cannot be the zero address.
2263      * - `account` must have at least `amount` tokens.
2264      */
2265     function _burn(address account, uint256 amount) internal virtual {
2266         require(account != address(0), "ERC20: burn from the zero address");
2267 
2268         _beforeTokenTransfer(account, address(0), amount);
2269 
2270         uint256 accountBalance = _balances[account];
2271         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2272         unchecked {
2273             _balances[account] = accountBalance - amount;
2274         }
2275         _totalSupply -= amount;
2276 
2277         emit Transfer(account, address(0), amount);
2278 
2279         _afterTokenTransfer(account, address(0), amount);
2280     }
2281 
2282     /**
2283      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2284      *
2285      * This internal function is equivalent to `approve`, and can be used to
2286      * e.g. set automatic allowances for certain subsystems, etc.
2287      *
2288      * Emits an {Approval} event.
2289      *
2290      * Requirements:
2291      *
2292      * - `owner` cannot be the zero address.
2293      * - `spender` cannot be the zero address.
2294      */
2295     function _approve(
2296         address owner,
2297         address spender,
2298         uint256 amount
2299     ) internal virtual {
2300         require(owner != address(0), "ERC20: approve from the zero address");
2301         require(spender != address(0), "ERC20: approve to the zero address");
2302 
2303         _allowances[owner][spender] = amount;
2304         emit Approval(owner, spender, amount);
2305     }
2306 
2307     /**
2308      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
2309      *
2310      * Does not update the allowance amount in case of infinite allowance.
2311      * Revert if not enough allowance is available.
2312      *
2313      * Might emit an {Approval} event.
2314      */
2315     function _spendAllowance(
2316         address owner,
2317         address spender,
2318         uint256 amount
2319     ) internal virtual {
2320         uint256 currentAllowance = allowance(owner, spender);
2321         if (currentAllowance != type(uint256).max) {
2322             require(currentAllowance >= amount, "ERC20: insufficient allowance");
2323             unchecked {
2324                 _approve(owner, spender, currentAllowance - amount);
2325             }
2326         }
2327     }
2328 
2329     /**
2330      * @dev Hook that is called before any transfer of tokens. This includes
2331      * minting and burning.
2332      *
2333      * Calling conditions:
2334      *
2335      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2336      * will be transferred to `to`.
2337      * - when `from` is zero, `amount` tokens will be minted for `to`.
2338      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2339      * - `from` and `to` are never both zero.
2340      *
2341      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2342      */
2343     function _beforeTokenTransfer(
2344         address from,
2345         address to,
2346         uint256 amount
2347     ) internal virtual {}
2348 
2349     /**
2350      * @dev Hook that is called after any transfer of tokens. This includes
2351      * minting and burning.
2352      *
2353      * Calling conditions:
2354      *
2355      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2356      * has been transferred to `to`.
2357      * - when `from` is zero, `amount` tokens have been minted for `to`.
2358      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2359      * - `from` and `to` are never both zero.
2360      *
2361      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2362      */
2363     function _afterTokenTransfer(
2364         address from,
2365         address to,
2366         uint256 amount
2367     ) internal virtual {}
2368 }
2369 
2370 // File: contracts/BankingNode.sol
2371 
2372 
2373 
2374 // NOTE: BankingNode.sol should only be created through the BNPLFactory contract to
2375 // ensure compatibility of baseToken and minimum bond amounts. Before interacting,
2376 // please ensure that the contract deployer was BNPLFactory.sol
2377 
2378 pragma solidity ^0.8.0;
2379 
2380 
2381 
2382 
2383 
2384 
2385 
2386 
2387 
2388 //CUSTOM ERRORS
2389 
2390 //occurs when trying to do privledged functions
2391 error InvalidUser(address requiredUser);
2392 //occurs when users try to add funds if node operator hasn't maintaioned enough pledged BNPL
2393 error NodeInactive();
2394 //occurs when trying to interact without being KYC's (if node requires it)
2395 error KYCNotApproved();
2396 //occurs when trying to pay loans that are completed or not started
2397 error NoPrincipalRemaining();
2398 //occurs when trying to swap/deposit/withdraw a zero
2399 error ZeroInput();
2400 //occurs if interest rate, loanAmount, or paymentInterval or is applied as 0
2401 error InvalidLoanInput();
2402 //occurs if trying to apply for a loan with >5 year loan length
2403 error MaximumLoanDurationExceeded();
2404 //occurs if user tries to withdraw collateral while loan is still ongoing
2405 error LoanStillOngoing();
2406 //edge case occurence if all BNPL is slashed, but there are still BNPL shares
2407 error DonationRequired();
2408 //occurs if operator tries to unstake while there are active loans
2409 error ActiveLoansOngoing();
2410 //occurs when trying to withdraw too much funds
2411 error InsufficientBalance();
2412 //occurs during swaps, if amount received is lower than minOut (slippage tolerance exceeded)
2413 error InsufficentOutput();
2414 //occurs if trying to approve a loan that has already started
2415 error LoanAlreadyStarted();
2416 //occurs if trying to approve a loan without enough collateral posted
2417 error InsufficientCollateral();
2418 //occurs when trying to slash a loan that is not yet considered defaulted
2419 error LoanNotExpired();
2420 //occurs is trying to slash an already slashed loan
2421 error LoanAlreadySlashed();
2422 //occurs if trying to withdraw staked BNPL where 7 day unbonding hasnt passed
2423 error LoanStillUnbonding();
2424 //occurs if trying to post baseToken as collateral
2425 error InvalidCollateral();
2426 //first deposit to prevent edge case must be at least 10M wei
2427 error InvalidInitialDeposit();
2428 
2429 contract BankingNode is ERC20("BNPL USD", "pUSD") {
2430     //Node specific variables
2431     address public operator;
2432     address public baseToken; //base liquidity token, e.g. USDT or USDC
2433     uint256 public gracePeriod;
2434     bool public requireKYC;
2435 
2436     //variables used for swaps, private to reduce contract size
2437     address private uniswapFactory;
2438     address private WETH;
2439     uint256 private incrementor;
2440 
2441     //constants set by factory
2442     address public BNPL;
2443     ILendingPoolAddressesProvider public lendingPoolProvider;
2444     address public immutable bnplFactory;
2445     //used by treasury can be private
2446     IAaveIncentivesController private aaveRewardController;
2447     address private treasury;
2448 
2449     //For loans
2450     mapping(uint256 => Loan) public idToLoan;
2451     uint256[] public pendingRequests;
2452     uint256[] public currentLoans;
2453     mapping(uint256 => uint256) defaultedLoans;
2454     uint256 public defaultedLoanCount;
2455 
2456     //For Staking, Slashing and Balances
2457     uint256 public accountsReceiveable;
2458     mapping(address => bool) public whitelistedAddresses;
2459     mapping(address => uint256) public unbondBlock;
2460     mapping(uint256 => address) public loanToAgent;
2461     uint256 public slashingBalance;
2462     mapping(address => uint256) public stakingShares;
2463     //can be private as there is a getter function for staking balance
2464     uint256 public totalStakingShares;
2465 
2466     uint256 public unbondingAmount;
2467     mapping(address => uint256) public unbondingShares;
2468     //can be private as there is getter function for unbonding balance
2469     uint256 private totalUnbondingShares;
2470     uint256 public timeCreated;
2471 
2472     //For Collateral in loans
2473     mapping(address => uint256) public collateralOwed;
2474 
2475     struct Loan {
2476         address borrower;
2477         bool interestOnly; //interest only or principal + interest
2478         uint256 loanStartTime; //unix timestamp of start
2479         uint256 loanAmount;
2480         uint256 paymentInterval; //unix interval of payment (e.g. monthly = 2,628,000)
2481         uint256 interestRate; //interest rate per peiod * 10000, e.g., 10% on a 12 month loan = : 0.1 * 10000 / 12 = 83
2482         uint256 numberOfPayments;
2483         uint256 principalRemaining;
2484         uint256 paymentsMade;
2485         address collateral;
2486         uint256 collateralAmount;
2487         bool isSlashed;
2488     }
2489 
2490     //EVENTS
2491     event LoanRequest(uint256 loanId, string message);
2492     event collateralWithdrawn(
2493         uint256 loanId,
2494         address collateral,
2495         uint256 collateralAmount
2496     );
2497     event approvedLoan(uint256 loanId);
2498     event loanPaymentMade(uint256 loanId);
2499     event loanRepaidEarly(uint256 loanId);
2500     event baseTokenDeposit(address user, uint256 amount);
2501     event baseTokenWithdrawn(address user, uint256 amount);
2502     event feesCollected(uint256 operatorFees, uint256 stakerFees);
2503     event baseTokensDonated(uint256 amount);
2504     event loanSlashed(uint256 loanId);
2505     event slashingSale(uint256 bnplSold, uint256 baseTokenRecovered);
2506     event bnplStaked(address user, uint256 bnplStaked);
2507     event unbondingInitiated(address user, uint256 unbondAmount);
2508     event bnplWithdrawn(address user, uint256 bnplWithdrawn);
2509     event KYCRequirementChanged(bool newStatus);
2510 
2511     constructor() {
2512         bnplFactory = msg.sender;
2513     }
2514 
2515     // MODIFIERS
2516 
2517     /**
2518      * Ensure a node is active for deposit, stake functions
2519      * Require KYC is also batched in
2520      */
2521     modifier ensureNodeActive() {
2522         address _operator = operator;
2523         if (msg.sender != bnplFactory && msg.sender != _operator) {
2524             if (getBNPLBalance(_operator) < 0x13DA329B6336471800000) {
2525                 revert NodeInactive();
2526             }
2527             if (requireKYC && whitelistedAddresses[msg.sender] == false) {
2528                 revert KYCNotApproved();
2529             }
2530         }
2531         _;
2532     }
2533 
2534     /**
2535      * Ensure that the loan has principal to be paid
2536      */
2537     modifier ensurePrincipalRemaining(uint256 loanId) {
2538         if (idToLoan[loanId].principalRemaining == 0) {
2539             revert NoPrincipalRemaining();
2540         }
2541         _;
2542     }
2543 
2544     /**
2545      * For operator only functions
2546      */
2547     modifier operatorOnly() {
2548         address _operator = operator;
2549         if (msg.sender != _operator) {
2550             revert InvalidUser(_operator);
2551         }
2552         _;
2553     }
2554 
2555     /**
2556      * Requires input value to be non-zero
2557      */
2558     modifier nonZeroInput(uint256 input) {
2559         if (input == 0) {
2560             revert ZeroInput();
2561         }
2562         _;
2563     }
2564 
2565     /**
2566      * Ensures collateral is not the baseToken
2567      */
2568     modifier nonBaseToken(address collateral) {
2569         if (collateral == baseToken) {
2570             revert InvalidCollateral();
2571         }
2572         _;
2573     }
2574 
2575     //STATE CHANGING FUNCTIONS
2576 
2577     /**
2578      * Called once by the factory at time of deployment
2579      */
2580     function initialize(
2581         address _baseToken,
2582         address _BNPL,
2583         bool _requireKYC,
2584         address _operator,
2585         uint256 _gracePeriod,
2586         address _lendingPoolProvider,
2587         address _WETH,
2588         address _aaveDistributionController,
2589         address _uniswapFactory
2590     ) external {
2591         //only to be done by factory, no need for error msgs in here as not used by users
2592         require(msg.sender == bnplFactory);
2593         baseToken = _baseToken;
2594         BNPL = _BNPL;
2595         requireKYC = _requireKYC;
2596         operator = _operator;
2597         gracePeriod = _gracePeriod;
2598         lendingPoolProvider = ILendingPoolAddressesProvider(
2599             _lendingPoolProvider
2600         );
2601         aaveRewardController = IAaveIncentivesController(
2602             _aaveDistributionController
2603         );
2604         WETH = _WETH;
2605         uniswapFactory = _uniswapFactory;
2606         treasury = address(0x27a99802FC48b57670846AbFFf5F2DcDE8a6fC29);
2607         timeCreated = block.timestamp;
2608         //decimal check on baseToken and aToken to make sure math logic on future steps
2609         require(
2610             ERC20(_baseToken).decimals() ==
2611                 ERC20(
2612                     _getLendingPool().getReserveData(_baseToken).aTokenAddress
2613                 ).decimals()
2614         );
2615     }
2616 
2617     /**
2618      * Request a loan from the banking node
2619      * Saves the loan with the operator able to approve or reject
2620      * Can post collateral if chosen, collateral accepted is anything that is accepted by aave
2621      * Collateral can not be the same token as baseToken
2622      */
2623     function requestLoan(
2624         uint256 loanAmount,
2625         uint256 paymentInterval,
2626         uint256 numberOfPayments,
2627         uint256 interestRate,
2628         bool interestOnly,
2629         address collateral,
2630         uint256 collateralAmount,
2631         address agent,
2632         string memory message
2633     )
2634         external
2635         ensureNodeActive
2636         nonBaseToken(collateral)
2637         returns (uint256 requestId)
2638     {
2639         if (
2640             loanAmount < 10000000 ||
2641             paymentInterval == 0 ||
2642             interestRate == 0 ||
2643             numberOfPayments == 0
2644         ) {
2645             revert InvalidLoanInput();
2646         }
2647         //157,680,000 seconds in 5 years
2648         if (paymentInterval * numberOfPayments > 157680000) {
2649             revert MaximumLoanDurationExceeded();
2650         }
2651         requestId = incrementor;
2652         incrementor++;
2653         pendingRequests.push(requestId);
2654         idToLoan[requestId] = Loan(
2655             msg.sender, //set borrower
2656             interestOnly,
2657             0, //start time initiated to 0
2658             loanAmount,
2659             paymentInterval, //interval of payments (e.g. Monthly)
2660             interestRate, //annualized interest rate per period * 10000 (e.g. 12 month loan 10% = 83)
2661             numberOfPayments,
2662             0, //initalize principalRemaining to 0
2663             0, //intialize paymentsMade to 0
2664             collateral,
2665             collateralAmount,
2666             false
2667         );
2668         //post the collateral if any
2669         if (collateralAmount > 0) {
2670             //update the collateral owed (interest accrued on collateral is given to lend)
2671             collateralOwed[collateral] += collateralAmount;
2672             TransferHelper.safeTransferFrom(
2673                 collateral,
2674                 msg.sender,
2675                 address(this),
2676                 collateralAmount
2677             );
2678             //deposit the collateral in AAVE to accrue interest
2679             _depositToLendingPool(collateral, collateralAmount);
2680         }
2681         //save the agent of the loan
2682         loanToAgent[requestId] = agent;
2683 
2684         emit LoanRequest(requestId, message);
2685     }
2686 
2687     /**
2688      * Withdraw the collateral from a loan
2689      * Loan must have no principal remaining (not approved, or payments finsihed)
2690      */
2691     function withdrawCollateral(uint256 loanId) external {
2692         Loan storage loan = idToLoan[loanId];
2693         address collateral = loan.collateral;
2694         uint256 amount = loan.collateralAmount;
2695 
2696         //must be the borrower or operator to withdraw, and loan must be either paid/not initiated
2697         if (msg.sender != loan.borrower) {
2698             revert InvalidUser(loan.borrower);
2699         }
2700         if (loan.principalRemaining > 0) {
2701             revert LoanStillOngoing();
2702         }
2703 
2704         //update the amounts
2705         collateralOwed[collateral] -= amount;
2706         loan.collateralAmount = 0;
2707 
2708         //no need to check if loan is slashed as collateral amont set to 0 on slashing
2709         _withdrawFromLendingPool(collateral, amount, loan.borrower);
2710         emit collateralWithdrawn(loanId, collateral, amount);
2711     }
2712 
2713     /**
2714      * Collect AAVE rewards to be sent to the treasury
2715      */
2716     function collectAaveRewards(address[] calldata assets) external {
2717         uint256 rewardAmount = aaveRewardController.getUserUnclaimedRewards(
2718             address(this)
2719         );
2720         address _treasuy = treasury;
2721         if (rewardAmount == 0) {
2722             revert ZeroInput();
2723         }
2724         //claim rewards to the treasury
2725         aaveRewardController.claimRewards(assets, rewardAmount, _treasuy);
2726         //no need for event as its a function that will only be used by treasury
2727     }
2728 
2729     /**
2730      * Collect the interest earnt on collateral posted to distribute to stakers
2731      * Collateral can not be the same as baseToken
2732      */
2733     function collectCollateralFees(address collateral)
2734         external
2735         nonBaseToken(collateral)
2736     {
2737         //get the aToken address
2738         ILendingPool lendingPool = _getLendingPool();
2739         address _bnpl = BNPL;
2740         uint256 feesAccrued = IERC20(
2741             lendingPool.getReserveData(collateral).aTokenAddress
2742         ).balanceOf(address(this)) - collateralOwed[collateral];
2743         //ensure there is collateral to collect inside of _swap
2744         lendingPool.withdraw(collateral, feesAccrued, address(this));
2745         //no slippage for small swaps
2746         _swapToken(collateral, _bnpl, 0, feesAccrued);
2747     }
2748 
2749     /*
2750      * Make a loan payment
2751      */
2752     function makeLoanPayment(uint256 loanId)
2753         external
2754         ensurePrincipalRemaining(loanId)
2755     {
2756         Loan storage loan = idToLoan[loanId];
2757         uint256 paymentAmount = getNextPayment(loanId);
2758         uint256 interestPortion = (loan.principalRemaining *
2759             loan.interestRate) / 10000;
2760         address _baseToken = baseToken;
2761         loan.paymentsMade++;
2762         //reduce accounts receiveable and loan principal if principal + interest payment
2763         bool finalPayment = loan.paymentsMade == loan.numberOfPayments;
2764 
2765         if (!loan.interestOnly) {
2766             uint256 principalPortion = paymentAmount - interestPortion;
2767             loan.principalRemaining -= principalPortion;
2768             accountsReceiveable -= principalPortion;
2769         } else {
2770             //interest only, principal change only on final payment
2771             if (finalPayment) {
2772                 accountsReceiveable -= loan.principalRemaining;
2773                 loan.principalRemaining = 0;
2774             }
2775         }
2776         //make payment
2777         TransferHelper.safeTransferFrom(
2778             _baseToken,
2779             msg.sender,
2780             address(this),
2781             paymentAmount
2782         );
2783         //deposit the tokens into AAVE on behalf of the pool contract, withholding 30% and the interest as baseToken
2784         _depositToLendingPool(
2785             _baseToken,
2786             paymentAmount - ((interestPortion * 3) / 10)
2787         );
2788         //remove if final payment
2789         if (finalPayment) {
2790             _removeCurrentLoan(loanId);
2791         }
2792         //increment the loan status
2793 
2794         emit loanPaymentMade(loanId);
2795     }
2796 
2797     /**
2798      * Repay remaining balance to save on interest cost
2799      * Payment amount is remaining principal + 1 period of interest
2800      */
2801     function repayEarly(uint256 loanId)
2802         external
2803         ensurePrincipalRemaining(loanId)
2804     {
2805         Loan storage loan = idToLoan[loanId];
2806         uint256 principalLeft = loan.principalRemaining;
2807         //make a payment of remaining principal + 1 period of interest
2808         uint256 interestAmount = (principalLeft * loan.interestRate) / 10000;
2809         uint256 paymentAmount = principalLeft + interestAmount;
2810         address _baseToken = baseToken;
2811 
2812         //update accounts
2813         accountsReceiveable -= principalLeft;
2814         loan.principalRemaining = 0;
2815         //increment the loan status to final and remove from current loans array
2816         loan.paymentsMade = loan.numberOfPayments;
2817         _removeCurrentLoan(loanId);
2818 
2819         //make payment
2820         TransferHelper.safeTransferFrom(
2821             _baseToken,
2822             msg.sender,
2823             address(this),
2824             paymentAmount
2825         );
2826         //deposit withholding 30% of the interest as fees
2827         _depositToLendingPool(
2828             _baseToken,
2829             paymentAmount - ((interestAmount * 3) / 10)
2830         );
2831 
2832         emit loanRepaidEarly(loanId);
2833     }
2834 
2835     /**
2836      * Converts the baseToken (e.g. USDT) 20% BNPL for stakers, and sends 10% to the Banking Node Operator
2837      * Slippage set to 0 here as they would be small purchases of BNPL
2838      */
2839     function collectFees() external {
2840         //requirement check for nonzero inside of _swap
2841         //33% to go to operator as baseToken
2842         address _baseToken = baseToken;
2843         address _bnpl = BNPL;
2844         address _operator = operator;
2845         uint256 _operatorFees = IERC20(_baseToken).balanceOf(address(this)) / 3;
2846         TransferHelper.safeTransfer(_baseToken, _operator, _operatorFees);
2847         //remainder (67%) is traded for staking rewards
2848         //no need for slippage on small trade
2849         uint256 _stakingRewards = _swapToken(
2850             _baseToken,
2851             _bnpl,
2852             0,
2853             IERC20(_baseToken).balanceOf(address(this))
2854         );
2855         emit feesCollected(_operatorFees, _stakingRewards);
2856     }
2857 
2858     /**
2859      * Deposit liquidity to the banking node in the baseToken (e.g. usdt) specified
2860      * Mints tokens, with check on decimals of base tokens
2861      */
2862     function deposit(uint256 _amount)
2863         external
2864         ensureNodeActive
2865         nonZeroInput(_amount)
2866     {
2867         //First deposit must be at least 10M wei to prevent initial attack
2868         if (getTotalAssetValue() == 0 && _amount < 10000000) {
2869             revert InvalidInitialDeposit();
2870         }
2871         //check the decimals of the baseTokens
2872         address _baseToken = baseToken;
2873         uint256 decimalAdjust = 1;
2874         uint256 tokenDecimals = ERC20(_baseToken).decimals();
2875         if (tokenDecimals != 18) {
2876             decimalAdjust = 10**(18 - tokenDecimals);
2877         }
2878         //get the amount of tokens to mint
2879         uint256 what = _amount * decimalAdjust;
2880         if (totalSupply() != 0) {
2881             //no need to decimal adjust here as total asset value adjusts
2882             //unable to deposit if getTotalAssetValue() == 0 and totalSupply() != 0, but this
2883             //should never occur as defaults will get slashed for some base token recovery
2884             what = (_amount * totalSupply()) / getTotalAssetValue();
2885         }
2886         //transfer tokens from the user and mint
2887         TransferHelper.safeTransferFrom(
2888             _baseToken,
2889             msg.sender,
2890             address(this),
2891             _amount
2892         );
2893         _mint(msg.sender, what);
2894 
2895         _depositToLendingPool(_baseToken, _amount);
2896 
2897         emit baseTokenDeposit(msg.sender, _amount);
2898     }
2899 
2900     /**
2901      * Withdraw liquidity from the banking node
2902      * To avoid need to decimal adjust, input _amount is in USDT(or equiv) to withdraw
2903      * , not BNPL USD to burn
2904      */
2905     function withdraw(uint256 _amount) external nonZeroInput(_amount) {
2906         uint256 userBaseBalance = getBaseTokenBalance(msg.sender);
2907         if (userBaseBalance < _amount) {
2908             revert InsufficientBalance();
2909         }
2910         //safe div, if _amount > 0, asset value always >0;
2911         uint256 what = (_amount * totalSupply()) / getTotalAssetValue();
2912         address _baseToken = baseToken;
2913         _burn(msg.sender, what);
2914         //non-zero revert with checked in "_withdrawFromLendingPool"
2915         _withdrawFromLendingPool(_baseToken, _amount, msg.sender);
2916 
2917         emit baseTokenWithdrawn(msg.sender, _amount);
2918     }
2919 
2920     /**
2921      * Stake BNPL into a node
2922      */
2923     function stake(uint256 _amount)
2924         external
2925         ensureNodeActive
2926         nonZeroInput(_amount)
2927     {
2928         address staker = msg.sender;
2929         //factory initial bond counted as operator
2930         if (msg.sender == bnplFactory) {
2931             staker = operator;
2932         }
2933         //calcualte the number of shares to give
2934         uint256 what = _amount;
2935         uint256 _totalStakingShares = totalStakingShares;
2936         if (_totalStakingShares > 0) {
2937             //edge case - if totalStakingShares != 0, but all bnpl has been slashed:
2938             //node will require a donation to work again
2939             uint256 totalStakedBNPL = getStakedBNPL();
2940             if (totalStakedBNPL == 0) {
2941                 revert DonationRequired();
2942             }
2943             what = (_amount * _totalStakingShares) / totalStakedBNPL;
2944         }
2945         //collect the BNPL
2946         address _bnpl = BNPL;
2947         TransferHelper.safeTransferFrom(
2948             _bnpl,
2949             msg.sender,
2950             address(this),
2951             _amount
2952         );
2953         //issue the shares
2954         stakingShares[staker] += what;
2955         totalStakingShares += what;
2956 
2957         emit bnplStaked(msg.sender, _amount);
2958     }
2959 
2960     /**
2961      * Unbond BNPL from a node, input is the number shares (sBNPL)
2962      * Requires a 7 day unbond to prevent frontrun of slashing events or interest repayments
2963      * Operator can not unstake unless there are no loans active
2964      */
2965     function initiateUnstake(uint256 _amount) external nonZeroInput(_amount) {
2966         //operator cannot withdraw unless there are no active loans
2967         address _operator = operator;
2968         if (msg.sender == _operator && currentLoans.length > 0) {
2969             revert ActiveLoansOngoing();
2970         }
2971         uint256 stakingSharesUser = stakingShares[msg.sender];
2972         //require the user has enough
2973         if (stakingShares[msg.sender] < _amount) {
2974             revert InsufficientBalance();
2975         }
2976         //set the time of the unbond
2977         unbondBlock[msg.sender] = block.number;
2978         //get the amount of BNPL to issue back
2979         //safe div: if user staking shares >0, totalStakingShares always > 0
2980         uint256 what = (_amount * getStakedBNPL()) / totalStakingShares;
2981         //subtract the number of shares of BNPL from the user
2982         stakingShares[msg.sender] -= _amount;
2983         totalStakingShares -= _amount;
2984         //initiate as 1:1 for unbonding shares with BNPL sent
2985         uint256 _newUnbondingShares = what;
2986         uint256 _unbondingAmount = unbondingAmount;
2987         //update amount if there is a pool of unbonding
2988         if (_unbondingAmount != 0) {
2989             _newUnbondingShares =
2990                 (what * totalUnbondingShares) /
2991                 _unbondingAmount;
2992         }
2993         //add the balance to their unbonding
2994         unbondingShares[msg.sender] += _newUnbondingShares;
2995         totalUnbondingShares += _newUnbondingShares;
2996         unbondingAmount += what;
2997 
2998         emit unbondingInitiated(msg.sender, _amount);
2999     }
3000 
3001     /**
3002      * Withdraw BNPL from a bond once unbond period ends
3003      * Unbonding period is 46523 blocks (~7 days assuming a 13s avg. block time)
3004      */
3005     function unstake() external {
3006         uint256 _userAmount = unbondingShares[msg.sender];
3007         if (_userAmount == 0) {
3008             revert ZeroInput();
3009         }
3010         //assuming 13s block, 46523 blocks for 1 week
3011         if (block.number < unbondBlock[msg.sender] + 46523) {
3012             revert LoanStillUnbonding();
3013         }
3014         uint256 _unbondingAmount = unbondingAmount;
3015         uint256 _totalUnbondingShares = totalUnbondingShares;
3016         address _bnpl = BNPL;
3017         //safe div: if user amount > 0, then totalUnbondingShares always > 0
3018         uint256 _what = (_userAmount * _unbondingAmount) /
3019             _totalUnbondingShares;
3020         //update the balances
3021         unbondingShares[msg.sender] = 0;
3022         unbondingAmount -= _what;
3023         totalUnbondingShares -= _userAmount;
3024 
3025         //transfer the tokens to user
3026         TransferHelper.safeTransfer(_bnpl, msg.sender, _what);
3027         emit bnplWithdrawn(msg.sender, _what);
3028     }
3029 
3030     /**
3031      * Declare a loan defaulted and slash the loan
3032      * Can be called by anyone
3033      * Move BNPL to a slashing balance, to be sold in seperate function
3034      * minOut used for sale of collateral, if no collateral, put 0
3035      */
3036     function slashLoan(uint256 loanId, uint256 minOut)
3037         external
3038         ensurePrincipalRemaining(loanId)
3039     {
3040         //Step 1. load loan as local variable
3041         Loan storage loan = idToLoan[loanId];
3042 
3043         //Step 2. requirement checks: loan is ongoing and expired past grace period
3044         if (loan.isSlashed) {
3045             revert LoanAlreadySlashed();
3046         }
3047         if (block.timestamp <= getNextDueDate(loanId) + gracePeriod) {
3048             revert LoanNotExpired();
3049         }
3050 
3051         //Step 3, Check if theres any collateral to slash
3052         uint256 _collateralPosted = loan.collateralAmount;
3053         uint256 baseTokenOut = 0;
3054         address _baseToken = baseToken;
3055         if (_collateralPosted > 0) {
3056             //Step 3a. load local variables
3057             address _collateral = loan.collateral;
3058 
3059             //Step 3b. update the colleral owed and loan amounts
3060             collateralOwed[_collateral] -= _collateralPosted;
3061             loan.collateralAmount = 0;
3062 
3063             //Step 3c. withdraw collateral from aave
3064             _withdrawFromLendingPool(
3065                 _collateral,
3066                 _collateralPosted,
3067                 address(this)
3068             );
3069             //Step 3d. sell collateral for baseToken
3070             baseTokenOut = _swapToken(
3071                 _collateral,
3072                 _baseToken,
3073                 minOut,
3074                 _collateralPosted
3075             );
3076             //Step 3e. deposit the recovered baseTokens to aave
3077             _depositToLendingPool(_baseToken, baseTokenOut);
3078         }
3079         //Step 4. calculate the amount to be slashed
3080         uint256 principalLost = loan.principalRemaining;
3081         //Check if there was a full recovery for the loan, if so
3082         if (baseTokenOut >= principalLost) {
3083             //return excess to the lender (if any)
3084             _withdrawFromLendingPool(
3085                 _baseToken,
3086                 baseTokenOut - principalLost,
3087                 loan.borrower
3088             );
3089         }
3090         //slash loan only if losses are greater than recovered
3091         else {
3092             principalLost -= baseTokenOut;
3093             //safe div: principal > 0 => totalassetvalue > 0
3094             uint256 slashPercent = (1e12 * principalLost) /
3095                 getTotalAssetValue();
3096             uint256 unbondingSlash = (unbondingAmount * slashPercent) / 1e12;
3097             uint256 stakingSlash = (getStakedBNPL() * slashPercent) / 1e12;
3098             //Step 5. deduct slashed from respective balances
3099             accountsReceiveable -= principalLost;
3100             slashingBalance += unbondingSlash + stakingSlash;
3101             unbondingAmount -= unbondingSlash;
3102         }
3103 
3104         //Step 6. remove loan from currentLoans and add to defaulted loans
3105         defaultedLoans[defaultedLoanCount] = loanId;
3106         defaultedLoanCount++;
3107 
3108         loan.isSlashed = true;
3109         _removeCurrentLoan(loanId);
3110         emit loanSlashed(loanId);
3111     }
3112 
3113     /**
3114      * Sell the slashing balance of BNPL to give to lenders as <aBaseToken>
3115      * Slashing sale moved to seperate function to simplify logic with minOut
3116      */
3117     function sellSlashed(uint256 minOut) external {
3118         //Step 1. load local variables
3119         address _baseToken = baseToken;
3120         address _bnpl = BNPL;
3121         uint256 _slashingBalance = slashingBalance;
3122         //Step 2. check there is a balance to sell
3123         if (_slashingBalance == 0) {
3124             revert ZeroInput();
3125         }
3126         //Step 3. sell the slashed BNPL for baseToken
3127         uint256 baseTokenOut = _swapToken(
3128             _bnpl,
3129             _baseToken,
3130             minOut,
3131             _slashingBalance
3132         );
3133         //Step 4. deposit baseToken received to aave and update slashing balance
3134         slashingBalance = 0;
3135         _depositToLendingPool(_baseToken, baseTokenOut);
3136 
3137         emit slashingSale(_slashingBalance, baseTokenOut);
3138     }
3139 
3140     /**
3141      * Donate baseToken for when debt is collected post default
3142      * BNPL can be donated by simply sending it to the contract
3143      */
3144     function donateBaseToken(uint256 _amount) external nonZeroInput(_amount) {
3145         //Step 1. load local variables
3146         address _baseToken = baseToken;
3147         //Step 2. collect the baseTokens
3148         TransferHelper.safeTransferFrom(
3149             _baseToken,
3150             msg.sender,
3151             address(this),
3152             _amount
3153         );
3154         //Step 3. deposit baseToken to aave
3155         _depositToLendingPool(_baseToken, _amount);
3156 
3157         emit baseTokensDonated(_amount);
3158     }
3159 
3160     //OPERATOR ONLY FUNCTIONS
3161 
3162     /**
3163      * Approve a pending loan request
3164      * Ensures collateral amount has been posted to prevent front run withdrawal
3165      */
3166     function approveLoan(uint256 loanId, uint256 requiredCollateralAmount)
3167         external
3168         operatorOnly
3169     {
3170         Loan storage loan = idToLoan[loanId];
3171         uint256 length = pendingRequests.length;
3172         uint256 loanSize = loan.loanAmount;
3173         address _baseToken = baseToken;
3174 
3175         if (getBNPLBalance(operator) < 0x13DA329B6336471800000) {
3176             revert NodeInactive();
3177         }
3178         //ensure the loan was never started and collateral enough
3179         if (loan.loanStartTime > 0) {
3180             revert LoanAlreadyStarted();
3181         }
3182         if (loan.collateralAmount < requiredCollateralAmount) {
3183             revert InsufficientCollateral();
3184         }
3185 
3186         //remove from loanRequests and add loan to current loans
3187 
3188         for (uint256 i = 0; i < length; i++) {
3189             if (loanId == pendingRequests[i]) {
3190                 pendingRequests[i] = pendingRequests[length - 1];
3191                 pendingRequests.pop();
3192                 break;
3193             }
3194         }
3195 
3196         currentLoans.push(loanId);
3197 
3198         //add the principal remaining and start the loan
3199 
3200         loan.principalRemaining = loanSize;
3201         loan.loanStartTime = block.timestamp;
3202         accountsReceiveable += loanSize;
3203         //send the funds and update accounts (minus 0.5% origination fee)
3204 
3205         _withdrawFromLendingPool(
3206             _baseToken,
3207             (loanSize * 199) / 200,
3208             loan.borrower
3209         );
3210         //send the 0.25% origination fee to treasury and agent
3211         _withdrawFromLendingPool(_baseToken, loanSize / 400, treasury);
3212         _withdrawFromLendingPool(
3213             _baseToken,
3214             loanSize / 400,
3215             loanToAgent[loanId]
3216         );
3217 
3218         emit approvedLoan(loanId);
3219     }
3220 
3221     /**
3222      * Used to reject all current pending loan requests
3223      */
3224     function clearPendingLoans() external operatorOnly {
3225         pendingRequests = new uint256[](0);
3226     }
3227 
3228     /**
3229      * Whitelist or delist a given list of addresses
3230      * Only relevant on KYC nodes
3231      */
3232     function whitelistAddresses(
3233         address[] memory whitelistAddition,
3234         bool _status
3235     ) external operatorOnly {
3236         uint256 length = whitelistAddition.length;
3237         for (uint256 i; i < length; i++) {
3238             address newWhistelist = whitelistAddition[i];
3239             whitelistedAddresses[newWhistelist] = _status;
3240         }
3241     }
3242 
3243     /**
3244      * Updates the KYC Status of a node
3245      */
3246     function setKYC(bool _newStatus) external operatorOnly {
3247         requireKYC = _newStatus;
3248         emit KYCRequirementChanged(_newStatus);
3249     }
3250 
3251     //PRIVATE FUNCTIONS
3252 
3253     /**
3254      * Deposit token onto AAVE lending pool, receiving aTokens in return
3255      */
3256     function _depositToLendingPool(address tokenIn, uint256 amountIn) private {
3257         address _lendingPool = address(_getLendingPool());
3258         TransferHelper.safeApprove(tokenIn, _lendingPool, 0);
3259         TransferHelper.safeApprove(tokenIn, _lendingPool, amountIn);
3260         _getLendingPool().deposit(tokenIn, amountIn, address(this), 0);
3261     }
3262 
3263     /**
3264      * Withdraw token from AAVE lending pool, converting from aTokens to ERC20 equiv
3265      */
3266     function _withdrawFromLendingPool(
3267         address tokenOut,
3268         uint256 amountOut,
3269         address to
3270     ) private nonZeroInput(amountOut) {
3271         _getLendingPool().withdraw(tokenOut, amountOut, to);
3272     }
3273 
3274     /**
3275      * Get the latest AAVE Lending Pool contract
3276      */
3277     function _getLendingPool() private view returns (ILendingPool) {
3278         return ILendingPool(lendingPoolProvider.getLendingPool());
3279     }
3280 
3281     /**
3282      * Remove given loan from current loan list
3283      */
3284     function _removeCurrentLoan(uint256 loanId) private {
3285         for (uint256 i = 0; i < currentLoans.length; i++) {
3286             if (loanId == currentLoans[i]) {
3287                 currentLoans[i] = currentLoans[currentLoans.length - 1];
3288                 currentLoans.pop();
3289                 return;
3290             }
3291         }
3292     }
3293 
3294     /**
3295      * Swaps given token, with path of length 3, tokenIn => WETH => tokenOut
3296      * Uses Sushiswap pairs only
3297      * Ensures slippage with minOut
3298      */
3299     function _swapToken(
3300         address tokenIn,
3301         address tokenOut,
3302         uint256 minOut,
3303         uint256 amountIn
3304     ) private returns (uint256 tokenOutput) {
3305         if (amountIn == 0) {
3306             revert ZeroInput();
3307         }
3308         //Step 1. load data to local variables
3309         address _uniswapFactory = uniswapFactory;
3310         address _weth = WETH;
3311         address pair1 = UniswapV2Library.pairFor(
3312             _uniswapFactory,
3313             tokenIn,
3314             _weth
3315         );
3316         address pair2 = UniswapV2Library.pairFor(
3317             _uniswapFactory,
3318             _weth,
3319             tokenOut
3320         );
3321         //if tokenIn = weth, only need to swap with pair2 with amountIn as input
3322         if (tokenIn == _weth) {
3323             pair1 = pair2;
3324             tokenOutput = amountIn;
3325         }
3326         //Step 2. transfer the tokens to first pair (pair 2 if tokenIn == weth)
3327         TransferHelper.safeTransfer(tokenIn, pair1, amountIn);
3328         //Step 3. Swap tokenIn to WETH (only if tokenIn != weth)
3329         if (tokenIn != _weth) {
3330             tokenOutput = _swap(tokenIn, _weth, amountIn, pair1, pair2);
3331         }
3332         //Step 4. Swap ETH for tokenOut
3333         tokenOutput = _swap(_weth, tokenOut, tokenOutput, pair2, address(this));
3334         //Step 5. Check slippage parameters
3335         if (minOut > tokenOutput) {
3336             revert InsufficentOutput();
3337         }
3338     }
3339 
3340     /**
3341      * Helper function for _swapToken
3342      * Modified from uniswap router to save gas, makes a single trade
3343      * with uniswap pair without needing address[] path or uit256[] amounts
3344      */
3345     function _swap(
3346         address tokenIn,
3347         address tokenOut,
3348         uint256 amountIn,
3349         address pair,
3350         address to
3351     ) private returns (uint256 tokenOutput) {
3352         address _uniswapFactory = uniswapFactory;
3353         //Step 1. get the reserves of each token
3354         (uint256 reserveIn, uint256 reserveOut) = UniswapV2Library.getReserves(
3355             _uniswapFactory,
3356             tokenIn,
3357             tokenOut
3358         );
3359         //Step 2. get the tokens that will be received
3360         tokenOutput = UniswapV2Library.getAmountOut(
3361             amountIn,
3362             reserveIn,
3363             reserveOut
3364         );
3365         //Step 3. sort the tokens to pass IUniswapV2Pair
3366         (address token0, ) = UniswapV2Library.sortTokens(tokenIn, tokenOut);
3367         (uint256 amount0Out, uint256 amount1Out) = tokenIn == token0
3368             ? (uint256(0), tokenOutput)
3369             : (tokenOutput, uint256(0));
3370         //Step 4. make the trade
3371         IUniswapV2Pair(pair).swap(amount0Out, amount1Out, to, new bytes(0));
3372     }
3373 
3374     //VIEW ONLY FUNCTIONS
3375 
3376     /**
3377      * Get the total BNPL in the staking account
3378      * Given by (total BNPL of node) - (unbonding balance) - (slashing balance)
3379      */
3380     function getStakedBNPL() public view returns (uint256) {
3381         return
3382             IERC20(BNPL).balanceOf(address(this)) -
3383             unbondingAmount -
3384             slashingBalance;
3385     }
3386 
3387     /**
3388      * Gets the given users balance in baseToken
3389      */
3390     function getBaseTokenBalance(address user) public view returns (uint256) {
3391         uint256 _balance = balanceOf(user);
3392         if (totalSupply() == 0) {
3393             return 0;
3394         }
3395         return (_balance * getTotalAssetValue()) / totalSupply();
3396     }
3397 
3398     /**
3399      * Get the value of the BNPL staked by user
3400      * Given by (user's shares) * (total BNPL staked) / (total number of shares)
3401      */
3402     function getBNPLBalance(address user) public view returns (uint256 what) {
3403         uint256 _balance = stakingShares[user];
3404         uint256 _totalStakingShares = totalStakingShares;
3405         if (_totalStakingShares == 0) {
3406             what = 0;
3407         } else {
3408             what = (_balance * getStakedBNPL()) / _totalStakingShares;
3409         }
3410     }
3411 
3412     /**
3413      * Get the amount a user has that is being unbonded
3414      * Given by (user's unbonding shares) * (total unbonding BNPL) / (total unbonding shares)
3415      */
3416     function getUnbondingBalance(address user) external view returns (uint256) {
3417         uint256 _totalUnbondingShares = totalUnbondingShares;
3418         uint256 _userUnbondingShare = unbondingShares[user];
3419         if (_totalUnbondingShares == 0) {
3420             return 0;
3421         }
3422         return (_userUnbondingShare * unbondingAmount) / _totalUnbondingShares;
3423     }
3424 
3425     /**
3426      * Gets the next payment amount due
3427      * If loan is completed or not approved, returns 0
3428      */
3429     function getNextPayment(uint256 loanId) public view returns (uint256) {
3430         //if loan is completed or not approved, return 0
3431         Loan storage loan = idToLoan[loanId];
3432         if (loan.principalRemaining == 0) {
3433             return 0;
3434         }
3435         uint256 _interestRate = loan.interestRate;
3436         uint256 _loanAmount = loan.loanAmount;
3437         uint256 _numberOfPayments = loan.numberOfPayments;
3438         //check if it is an interest only loan
3439         if (loan.interestOnly) {
3440             //check if its the final payment
3441             if (loan.paymentsMade + 1 == _numberOfPayments) {
3442                 //if final payment, then principal + final interest amount
3443                 return _loanAmount + ((_loanAmount * _interestRate) / 10000);
3444             } else {
3445                 //if not final payment, simple interest amount
3446                 return (_loanAmount * _interestRate) / 10000;
3447             }
3448         } else {
3449             //principal + interest payments, payment given by the formula:
3450             //p : principal
3451             //i : interest rate per period
3452             //d : duration
3453             // p * (i * (1+i) ** d) / ((1+i) ** d - 1)
3454             uint256 numerator = _loanAmount *
3455                 _interestRate *
3456                 (10000 + _interestRate)**_numberOfPayments;
3457             uint256 denominator = (10000 + _interestRate)**_numberOfPayments -
3458                 (10**(4 * _numberOfPayments));
3459             return numerator / (denominator * 10000);
3460         }
3461     }
3462 
3463     /**
3464      * Gets the next due date (unix timestamp) of a given loan
3465      * Returns 0 if loan is not a current loan or loan has already been paid
3466      */
3467     function getNextDueDate(uint256 loanId) public view returns (uint256) {
3468         //check that the loan has been approved and loan is not completed;
3469         Loan storage loan = idToLoan[loanId];
3470         if (loan.principalRemaining == 0) {
3471             return 0;
3472         }
3473         return
3474             loan.loanStartTime +
3475             ((loan.paymentsMade + 1) * loan.paymentInterval);
3476     }
3477 
3478     /**
3479      * Get the total assets (accounts receivable + aToken balance)
3480      * Only principal owed is counted as accounts receivable
3481      */
3482     function getTotalAssetValue() public view returns (uint256) {
3483         return
3484             IERC20(_getLendingPool().getReserveData(baseToken).aTokenAddress)
3485                 .balanceOf(address(this)) + accountsReceiveable;
3486     }
3487 
3488     /**
3489      * Get number of pending requests
3490      */
3491     function getPendingRequestCount() external view returns (uint256) {
3492         return pendingRequests.length;
3493     }
3494 
3495     /**
3496      * Get the current number of active loans
3497      */
3498     function getCurrentLoansCount() external view returns (uint256) {
3499         return currentLoans.length;
3500     }
3501 
3502     /**
3503      * Get the total Losses occurred
3504      */
3505     function getTotalDefaultLoss() external view returns (uint256) {
3506         uint256 totalLosses = 0;
3507         for (uint256 i; i < defaultedLoanCount; i++) {
3508             Loan storage loan = idToLoan[defaultedLoans[i]];
3509             totalLosses += loan.principalRemaining;
3510         }
3511         return totalLosses;
3512     }
3513 }
3514 
3515 // File: @openzeppelin/contracts/access/Ownable.sol
3516 
3517 
3518 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
3519 
3520 pragma solidity ^0.8.0;
3521 
3522 
3523 /**
3524  * @dev Contract module which provides a basic access control mechanism, where
3525  * there is an account (an owner) that can be granted exclusive access to
3526  * specific functions.
3527  *
3528  * By default, the owner account will be the one that deploys the contract. This
3529  * can later be changed with {transferOwnership}.
3530  *
3531  * This module is used through inheritance. It will make available the modifier
3532  * `onlyOwner`, which can be applied to your functions to restrict their use to
3533  * the owner.
3534  */
3535 abstract contract Ownable is Context {
3536     address private _owner;
3537 
3538     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3539 
3540     /**
3541      * @dev Initializes the contract setting the deployer as the initial owner.
3542      */
3543     constructor() {
3544         _transferOwnership(_msgSender());
3545     }
3546 
3547     /**
3548      * @dev Returns the address of the current owner.
3549      */
3550     function owner() public view virtual returns (address) {
3551         return _owner;
3552     }
3553 
3554     /**
3555      * @dev Throws if called by any account other than the owner.
3556      */
3557     modifier onlyOwner() {
3558         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3559         _;
3560     }
3561 
3562     /**
3563      * @dev Leaves the contract without owner. It will not be possible to call
3564      * `onlyOwner` functions anymore. Can only be called by the current owner.
3565      *
3566      * NOTE: Renouncing ownership will leave the contract without an owner,
3567      * thereby removing any functionality that is only available to the owner.
3568      */
3569     function renounceOwnership() public virtual onlyOwner {
3570         _transferOwnership(address(0));
3571     }
3572 
3573     /**
3574      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3575      * Can only be called by the current owner.
3576      */
3577     function transferOwnership(address newOwner) public virtual onlyOwner {
3578         require(newOwner != address(0), "Ownable: new owner is the zero address");
3579         _transferOwnership(newOwner);
3580     }
3581 
3582     /**
3583      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3584      * Internal function without access restriction.
3585      */
3586     function _transferOwnership(address newOwner) internal virtual {
3587         address oldOwner = _owner;
3588         _owner = newOwner;
3589         emit OwnershipTransferred(oldOwner, newOwner);
3590     }
3591 }
3592 
3593 // File: contracts/BNPLFactory.sol
3594 
3595 
3596 
3597 pragma solidity ^0.8.0;
3598 
3599 
3600 
3601 
3602 
3603 
3604 //CUSTOM ERRORS
3605 
3606 //occurs when trying to create a node without a whitelisted baseToken
3607 error InvalidBaseToken();
3608 //occurs when a user tries to set up a second node from same account
3609 error OneNodePerAccountOnly();
3610 
3611 contract BNPLFactory is Initializable, OwnableUpgradeable {
3612 
3613     mapping(address => address) public operatorToNode;
3614     address[] public bankingNodesList;
3615     address public BNPL;
3616     address public lendingPoolAddressesProvider;
3617     address public WETH;
3618     address public uniswapFactory;
3619     mapping(address => bool) public approvedBaseTokens;
3620     address public aaveDistributionController;
3621 
3622     event NewNode(address indexed _operator, address indexed _node);
3623 
3624     /**
3625      * Upgradeable contracts uses an initializer function instead of a constructor
3626      * Reference: https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable#initializers
3627     */
3628     function initialize(
3629         address _BNPL,
3630         address _lendingPoolAddressesProvider,
3631         address _WETH,
3632         address _aaveDistributionController,
3633         address _uniswapFactory
3634     ) public initializer {
3635         __Ownable_init();
3636 
3637         BNPL = _BNPL;
3638         lendingPoolAddressesProvider = _lendingPoolAddressesProvider;
3639         WETH = _WETH;
3640         aaveDistributionController = _aaveDistributionController;
3641         uniswapFactory = _uniswapFactory;
3642     }
3643 
3644     //STATE CHANGING FUNCTIONS
3645 
3646     /**
3647      * Creates a new banking node
3648      */
3649     function createNewNode(
3650         address _baseToken,
3651         bool _requireKYC,
3652         uint256 _gracePeriod
3653     ) external returns (address node) {
3654         //collect the 2M BNPL
3655         uint256 bondAmount = 0x1A784379D99DB42000000; //2M BNPL to bond a node
3656         address _bnpl = BNPL;
3657         TransferHelper.safeTransferFrom(
3658             _bnpl,
3659             msg.sender,
3660             address(this),
3661             bondAmount
3662         );
3663         //one node per operator and base token must be approved
3664         if (!approvedBaseTokens[_baseToken]) {
3665             revert InvalidBaseToken();
3666         }
3667         if (operatorToNode[msg.sender] != address(0)) {
3668             revert OneNodePerAccountOnly();
3669         }
3670         //create a new node
3671         bytes memory bytecode = type(BankingNode).creationCode;
3672         bytes32 salt = keccak256(
3673             abi.encodePacked(_baseToken, _requireKYC, _gracePeriod, msg.sender)
3674         );
3675         assembly {
3676             node := create2(0, add(bytecode, 32), mload(bytecode), salt)
3677         }
3678         BankingNode(node).initialize(
3679             _baseToken,
3680             _bnpl,
3681             _requireKYC,
3682             msg.sender,
3683             _gracePeriod,
3684             lendingPoolAddressesProvider,
3685             WETH,
3686             aaveDistributionController,
3687             uniswapFactory
3688         );
3689 
3690         bankingNodesList.push(node);
3691         operatorToNode[msg.sender] = node;
3692         
3693         TransferHelper.safeApprove(_bnpl, node, bondAmount);
3694         BankingNode(node).stake(bondAmount);
3695     }
3696 
3697     //ONLY OWNER FUNCTIONS
3698 
3699     /**
3700      * Whitelist or Delist a base token for banking nodes(e.g. USDC)
3701      */
3702     function whitelistToken(address _baseToken, bool _status)
3703         external
3704         onlyOwner
3705     {
3706         if (_baseToken == BNPL) {
3707             revert InvalidBaseToken();
3708         }
3709         approvedBaseTokens[_baseToken] = _status;
3710     }
3711 
3712     /**
3713      * Get number of current nodes
3714      */
3715     function bankingNodeCount() external view returns (uint256) {
3716         return bankingNodesList.length;
3717     }
3718 }
3719 
3720 // File: contracts/BNPLRewardsController.sol
3721 
3722 
3723 pragma solidity ^0.8.0;
3724 
3725 
3726 
3727 error InvalidToken();
3728 error InsufficientUserBalance(uint256 userBalance);
3729 error PoolExists();
3730 error RewardsCannotIncrease();
3731 
3732 /**
3733  * Modified version of Sushiswap MasterChef.sol contract
3734  * - Migrator functionality removed
3735  * - Uses timestamp instead of block number
3736  * - Adding LP token is public instead of onlyOwner, but requires the LP token to be saved to bnplFactory
3737  * - Alloc points are based on amount of BNPL staked to the node
3738  * - Minting functions for BNPL not possible, they are transfered from treasury instead
3739  * - Removed safeMath as using solidity ^0.8.0
3740  * - Require checks changed to custom errors to save gas
3741  */
3742 
3743 contract BNPLRewardsController is Ownable {
3744     BNPLFactory public immutable bnplFactory;
3745     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
3746     address public immutable bnpl;
3747     address public treasury;
3748     uint256 public bnplPerSecond; //initiated to
3749     uint256 public immutable startTime; //unix time of start
3750     uint256 public endTime; //3 years of emmisions
3751     uint256 public totalAllocPoint = 0; //total allocation points, no need for max alloc points as max is the supply of BNPL
3752     PoolInfo[] public poolInfo;
3753 
3754     struct UserInfo {
3755         uint256 amount;
3756         uint256 rewardDebt;
3757     }
3758 
3759     struct PoolInfo {
3760         IBankingNode lpToken; //changed from IERC20
3761         uint256 allocPoint;
3762         uint256 lastRewardTime;
3763         uint256 accBnplPerShare;
3764     }
3765 
3766     //EVENTS
3767     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
3768     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
3769     event EmergencyWithdraw(
3770         address indexed user,
3771         uint256 indexed pid,
3772         uint256 amount
3773     );
3774 
3775     constructor(
3776         BNPLFactory _bnplFactory,
3777         address _bnpl,
3778         address _treasury,
3779         uint256 _startTime
3780     ) {
3781         bnplFactory = _bnplFactory;
3782         startTime = _startTime;
3783         endTime = _startTime + 94608000; //94,608,000 seconds in 3 years
3784         bnpl = _bnpl;
3785         treasury = _treasury;
3786         bnplPerSecond = 4492220531033316000; //425,000,000 BNPL to be distributed over 3 years = ~4.49 BNPL per second
3787     }
3788 
3789     //STATE CHANGING FUNCTIONS
3790 
3791     /**
3792      * Add a pool to be allocated rewards
3793      * Modified from MasterChef to be public, but requires the pool to be saved in BNPL Factory
3794      * _allocPoints to be based on the number of bnpl staked in the given node
3795      */
3796     function add(IBankingNode _lpToken) public {
3797         checkValidNode(address(_lpToken));
3798 
3799         massUpdatePools();
3800 
3801         uint256 _allocPoint = _lpToken.getStakedBNPL();
3802         checkForDuplicate(_lpToken);
3803 
3804         uint256 lastRewardTime = block.timestamp > startTime
3805             ? block.timestamp
3806             : startTime;
3807         totalAllocPoint += _allocPoint;
3808         poolInfo.push(
3809             PoolInfo({
3810                 lpToken: _lpToken,
3811                 allocPoint: _allocPoint,
3812                 lastRewardTime: lastRewardTime,
3813                 accBnplPerShare: 0
3814             })
3815         );
3816     }
3817 
3818     /**
3819      * Update the given pool's bnpl allocation point, changed from Masterchef to be:
3820      * - Public, but sets _allocPoints to the number of bnpl staked to a node
3821      */
3822     function set(uint256 _pid) external {
3823         //get the new _allocPoints
3824         uint256 _allocPoint = poolInfo[_pid].lpToken.getStakedBNPL();
3825 
3826         massUpdatePools();
3827 
3828         totalAllocPoint =
3829             totalAllocPoint +
3830             _allocPoint -
3831             poolInfo[_pid].allocPoint;
3832         poolInfo[_pid].allocPoint = _allocPoint;
3833     }
3834 
3835     /**
3836      * Update reward variables for all pools
3837      */
3838     function massUpdatePools() public {
3839         uint256 length = poolInfo.length;
3840         for (uint256 pid = 0; pid < length; ++pid) {
3841             updatePool(pid);
3842         }
3843     }
3844 
3845     /**
3846      * Update reward variables for a pool given pool to be up-to-date
3847      */
3848     function updatePool(uint256 _pid) public {
3849         PoolInfo storage pool = poolInfo[_pid];
3850         if (block.timestamp <= pool.lastRewardTime) {
3851             return;
3852         }
3853         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
3854         if (lpSupply == 0) {
3855             pool.lastRewardTime == block.timestamp;
3856             return;
3857         }
3858         uint256 multiplier = getMultiplier(
3859             pool.lastRewardTime,
3860             block.timestamp
3861         );
3862         uint256 bnplReward = (multiplier * bnplPerSecond * pool.allocPoint) /
3863             totalAllocPoint;
3864 
3865         //instead of minting, simply transfers the tokens from the owner
3866         //ensure owner has approved the tokens to the contract
3867 
3868         address _bnpl = bnpl;
3869         address _treasury = treasury;
3870         TransferHelper.safeTransferFrom(
3871             _bnpl,
3872             _treasury,
3873             address(this),
3874             bnplReward
3875         );
3876 
3877         pool.accBnplPerShare += (bnplReward * 1e12) / lpSupply;
3878         pool.lastRewardTime = block.timestamp;
3879     }
3880 
3881     /**
3882      * Deposit LP tokens from the user
3883      */
3884     function deposit(uint256 _pid, uint256 _amount) public {
3885         PoolInfo storage pool = poolInfo[_pid];
3886         UserInfo storage user = userInfo[_pid][msg.sender];
3887 
3888         updatePool(_pid);
3889 
3890         uint256 pending = ((user.amount * pool.accBnplPerShare) / 1e12) -
3891             user.rewardDebt;
3892 
3893         user.amount += _amount;
3894         user.rewardDebt = (user.amount * pool.accBnplPerShare) / 1e12;
3895 
3896         if (pending > 0) {
3897             safeBnplTransfer(msg.sender, pending);
3898         }
3899         TransferHelper.safeTransferFrom(
3900             address(pool.lpToken),
3901             msg.sender,
3902             address(this),
3903             _amount
3904         );
3905 
3906         emit Deposit(msg.sender, _pid, _amount);
3907     }
3908 
3909     /**
3910      * Withdraw LP tokens from the user
3911      */
3912     function withdraw(uint256 _pid, uint256 _amount) public {
3913         PoolInfo storage pool = poolInfo[_pid];
3914         UserInfo storage user = userInfo[_pid][msg.sender];
3915 
3916         if (_amount > user.amount) {
3917             revert InsufficientUserBalance(user.amount);
3918         }
3919 
3920         updatePool(_pid);
3921 
3922         uint256 pending = ((user.amount * pool.accBnplPerShare) / 1e12) -
3923             user.rewardDebt;
3924 
3925         user.amount -= _amount;
3926         user.rewardDebt = (user.amount * pool.accBnplPerShare) / 1e12;
3927 
3928         if (pending > 0) {
3929             safeBnplTransfer(msg.sender, pending);
3930         }
3931         TransferHelper.safeTransfer(address(pool.lpToken), msg.sender, _amount);
3932 
3933         emit Withdraw(msg.sender, _pid, _amount);
3934     }
3935 
3936     /**
3937      * Withdraw without caring about rewards. EMERGENCY ONLY.
3938      */
3939     function emergencyWithdraw(uint256 _pid) public {
3940         PoolInfo storage pool = poolInfo[_pid];
3941         UserInfo storage user = userInfo[_pid][msg.sender];
3942         uint256 oldUserAmount = user.amount;
3943         user.amount = 0;
3944         user.rewardDebt = 0;
3945         TransferHelper.safeTransfer(
3946             address(pool.lpToken),
3947             msg.sender,
3948             oldUserAmount
3949         );
3950         emit EmergencyWithdraw(msg.sender, _pid, oldUserAmount);
3951     }
3952 
3953     /**
3954      * Safe BNPL transfer function, just in case if rounding error causes pool to not have enough BNPL.
3955      */
3956     function safeBnplTransfer(address _to, uint256 _amount) internal {
3957         address _bnpl = bnpl;
3958         uint256 bnplBalance = IERC20(_bnpl).balanceOf(address(this));
3959         if (_amount > bnplBalance) {
3960             TransferHelper.safeTransfer(_bnpl, _to, bnplBalance);
3961         } else {
3962             TransferHelper.safeTransfer(_bnpl, _to, _amount);
3963         }
3964     }
3965 
3966     //OWNER ONLY FUNCTIONS
3967 
3968     /**
3969      * Update the BNPL per second emmisions, emmisions can only be decreased
3970      */
3971     function updateRewards(uint256 _bnplPerSecond) public onlyOwner {
3972         if (_bnplPerSecond > bnplPerSecond) {
3973             revert RewardsCannotIncrease();
3974         }
3975         bnplPerSecond = _bnplPerSecond;
3976 
3977         massUpdatePools();
3978     }
3979 
3980     /**
3981      * Update the treasury address that bnpl is transfered from
3982      */
3983     function updateTreasury(address _treasury) public onlyOwner {
3984         treasury = _treasury;
3985     }
3986 
3987     //VIEW FUNCTIONS
3988 
3989     /**
3990      * Return reward multiplier over the given _from to _to timestamps
3991      */
3992     function getMultiplier(uint256 _from, uint256 _to)
3993         public
3994         view
3995         returns (uint256)
3996     {
3997         //get the start time to be minimum
3998         _from = _from > startTime ? _from : startTime;
3999         if (_to < startTime || _from >= endTime) {
4000             return 0;
4001         } else if (_to <= endTime) {
4002             return _to - _from;
4003         } else {
4004             return endTime - _from;
4005         }
4006     }
4007 
4008     /**
4009      * Get the number of pools
4010      */
4011     function poolLength() external view returns (uint256) {
4012         return poolInfo.length;
4013     }
4014 
4015     /**
4016      * Check if the pool already exists
4017      */
4018     function checkForDuplicate(IBankingNode _lpToken) internal view {
4019         for (uint256 i = 0; i < poolInfo.length; i++) {
4020             if (poolInfo[i].lpToken == _lpToken) {
4021                 revert PoolExists();
4022             }
4023         }
4024     }
4025 
4026     /**
4027      * View function to get the pending bnpl to harvest
4028      * Modifed by removing safe math
4029      */
4030     function pendingBnpl(uint256 _pid, address _user)
4031         external
4032         view
4033         returns (uint256)
4034     {
4035         PoolInfo storage pool = poolInfo[_pid];
4036         UserInfo storage user = userInfo[_pid][_user];
4037         uint256 accBnplPerShare = pool.accBnplPerShare;
4038         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
4039 
4040         if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
4041             uint256 multiplier = getMultiplier(
4042                 pool.lastRewardTime,
4043                 block.timestamp
4044             );
4045             uint256 bnplReward = (multiplier *
4046                 bnplPerSecond *
4047                 pool.allocPoint) / totalAllocPoint;
4048             accBnplPerShare += (bnplReward * 1e12) / lpSupply;
4049         }
4050         return (user.amount * accBnplPerShare) / (1e12) - user.rewardDebt;
4051     }
4052 
4053     /**
4054      * Checks if a given address is a valid banking node registered
4055      * Reverts with InvalidToken() if node not found
4056      */
4057     function checkValidNode(address _bankingNode) private view {
4058         BNPLFactory _bnplFactory = bnplFactory;
4059         uint256 length = _bnplFactory.bankingNodeCount();
4060         for (uint256 i; i < length; i++) {
4061             if (_bnplFactory.bankingNodesList(i) == _bankingNode) {
4062                 return;
4063             }
4064         }
4065         revert InvalidToken();
4066     }
4067 
4068     /**
4069      * Get the Apy for front end for a given pool
4070      * - assumes rewards are active
4071      * - assumes poolTokens have $1 value
4072      * - must multiply by BNPL price / 1e18 to get USD APR
4073      * If return == 0, APR = NaN
4074      */
4075     function getBnplApr(uint256 _pid) external view returns (uint256 bnplApr) {
4076         PoolInfo storage pool = poolInfo[_pid];
4077         uint256 lpBalanceStaked = pool.lpToken.balanceOf(address(this));
4078         if (lpBalanceStaked == 0) {
4079             bnplApr = 0;
4080         } else {
4081             uint256 poolBnplPerYear = (bnplPerSecond *
4082                 pool.allocPoint *
4083                 31536000) / totalAllocPoint; //31536000 seconds in a year
4084             bnplApr = (poolBnplPerYear * 1e18) / lpBalanceStaked;
4085         }
4086     }
4087 
4088     /**
4089      * Helper function for front end
4090      * Get the pid+1 given a node address
4091      * Returns 0xFFFF if node not found
4092      */
4093     function getPid(address node) external view returns (uint256) {
4094         for (uint256 i; i < poolInfo.length; ++i) {
4095             if (address(poolInfo[i].lpToken) == node) {
4096                 return i;
4097             }
4098         }
4099         return 0xFFFF;
4100     }
4101 }