1 // File: localhost/contracts/helpers/SafeMath.sol
2 
3 // SPDX-License-Identifier: bsl-1.1
4 
5 /*
6   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
7 */
8 pragma solidity 0.7.6;
9 
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         if (a == 0) {
22             return 0;
23         }
24         c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     /**
30     * @dev Integer division of two numbers, truncating the quotient.
31     */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0, "SafeMath: division by zero");
34         return a / b;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 // File: localhost/contracts/helpers/ReentrancyGuard.sol
56 
57 pragma solidity 0.7.6;
58 
59 /**
60  * @dev Contract module that helps prevent reentrant calls to a function.
61  *
62  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
63  * available, which can be applied to functions to make sure there are no nested
64  * (reentrant) calls to them.
65  *
66  * Note that because there is a single `nonReentrant` guard, functions marked as
67  * `nonReentrant` may not call one another. This can be worked around by making
68  * those functions `private`, and then adding `external` `nonReentrant` entry
69  * points to them.
70  *
71  * TIP: If you would like to learn more about reentrancy and alternative ways
72  * to protect against it, check out our blog post
73  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
74  */
75 contract ReentrancyGuard {
76     // Booleans are more expensive than uint256 or any type that takes up a full
77     // word because each write operation emits an extra SLOAD to first read the
78     // slot's contents, replace the bits taken up by the boolean, and then write
79     // back. This is the compiler's defense against contract upgrades and
80     // pointer aliasing, and it cannot be disabled.
81 
82     // The values being non-zero value makes deployment a bit more expensive,
83     // but in exchange the refund on every call to nonReentrant will be lower in
84     // amount. Since refunds are capped to a percentage of the total
85     // transaction's gas, it is best to keep them low in cases like this one, to
86     // increase the likelihood of the full refund coming into effect.
87     uint256 private constant _NOT_ENTERED = 1;
88     uint256 private constant _ENTERED = 2;
89 
90     uint256 private _status;
91 
92     constructor () {
93         _status = _NOT_ENTERED;
94     }
95 
96     /**
97      * @dev Prevents a contract from calling itself, directly or indirectly.
98      * Calling a `nonReentrant` function from another `nonReentrant`
99      * function is not supported. It is possible to prevent this from happening
100      * by making the `nonReentrant` function external, and make it call a
101      * `private` function that does the actual work.
102      */
103     modifier nonReentrant() {
104         // On the first call to nonReentrant, _notEntered will be true
105         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
106 
107         // Any calls to nonReentrant after this point will fail
108         _status = _ENTERED;
109 
110         _;
111 
112         // By storing the original value once again, a refund is triggered (see
113         // https://eips.ethereum.org/EIPS/eip-2200)
114         _status = _NOT_ENTERED;
115     }
116 }
117 
118 // File: localhost/contracts/interfaces/IToken.sol
119 
120 interface IToken {
121     function decimals() external view returns (uint8);
122 }
123 // File: localhost/contracts/interfaces/IVaultParameters.sol
124 
125 interface IVaultParameters {
126     function canModifyVault ( address ) external view returns ( bool );
127     function foundation (  ) external view returns ( address );
128     function isManager ( address ) external view returns ( bool );
129     function isOracleTypeEnabled ( uint256, address ) external view returns ( bool );
130     function liquidationFee ( address ) external view returns ( uint256 );
131     function setCollateral ( address asset, uint256 stabilityFeeValue, uint256 liquidationFeeValue, uint256 usdpLimit, uint256[] calldata oracles ) external;
132     function setFoundation ( address newFoundation ) external;
133     function setLiquidationFee ( address asset, uint256 newValue ) external;
134     function setManager ( address who, bool permit ) external;
135     function setOracleType ( uint256 _type, address asset, bool enabled ) external;
136     function setStabilityFee ( address asset, uint256 newValue ) external;
137     function setTokenDebtLimit ( address asset, uint256 limit ) external;
138     function setVaultAccess ( address who, bool permit ) external;
139     function stabilityFee ( address ) external view returns ( uint256 );
140     function tokenDebtLimit ( address ) external view returns ( uint256 );
141     function vault (  ) external view returns ( address );
142     function vaultParameters (  ) external view returns ( address );
143 }
144 
145 // File: localhost/contracts/interfaces/IVaultManagerParameters.sol
146 
147 interface IVaultManagerParameters {
148     function devaluationPeriod ( address ) external view returns ( uint256 );
149     function initialCollateralRatio ( address ) external view returns ( uint256 );
150     function liquidationDiscount ( address ) external view returns ( uint256 );
151     function liquidationRatio ( address ) external view returns ( uint256 );
152     function maxColPercent ( address ) external view returns ( uint256 );
153     function minColPercent ( address ) external view returns ( uint256 );
154     function setColPartRange ( address asset, uint256 min, uint256 max ) external;
155     function setCollateral (
156         address asset,
157         uint256 stabilityFeeValue,
158         uint256 liquidationFeeValue,
159         uint256 initialCollateralRatioValue,
160         uint256 liquidationRatioValue,
161         uint256 liquidationDiscountValue,
162         uint256 devaluationPeriodValue,
163         uint256 usdpLimit,
164         uint256[] calldata oracles,
165         uint256 minColP,
166         uint256 maxColP
167     ) external;
168     function setDevaluationPeriod ( address asset, uint256 newValue ) external;
169     function setInitialCollateralRatio ( address asset, uint256 newValue ) external;
170     function setLiquidationDiscount ( address asset, uint256 newValue ) external;
171     function setLiquidationRatio ( address asset, uint256 newValue ) external;
172     function vaultParameters (  ) external view returns ( address );
173 }
174 
175 // File: localhost/contracts/interfaces/ICDPRegistry.sol
176 
177 pragma experimental ABIEncoderV2;
178 
179 
180 interface ICDPRegistry {
181     
182     struct CDP {
183         address asset;
184         address owner;
185     }
186     
187     function batchCheckpoint ( address[] calldata assets, address[] calldata owners ) external;
188     function batchCheckpointForAsset ( address asset, address[] calldata owners ) external;
189     function checkpoint ( address asset, address owner ) external;
190     function cr (  ) external view returns ( address );
191     function getAllCdps (  ) external view returns ( CDP[] memory r );
192     function getCdpsByCollateral ( address asset ) external view returns ( CDP[] memory cdps );
193     function getCdpsByOwner ( address owner ) external view returns ( CDP[] memory r );
194     function getCdpsCount (  ) external view returns ( uint256 totalCdpCount );
195     function getCdpsCountForCollateral ( address asset ) external view returns ( uint256 );
196     function isAlive ( address asset, address owner ) external view returns ( bool );
197     function isListed ( address asset, address owner ) external view returns ( bool );
198     function vault (  ) external view returns ( address );
199 }
200 
201 // File: localhost/contracts/interfaces/IVault.sol
202 
203 interface IVault {
204     function DENOMINATOR_1E2 (  ) external view returns ( uint256 );
205     function DENOMINATOR_1E5 (  ) external view returns ( uint256 );
206     function borrow ( address asset, address user, uint256 amount ) external returns ( uint256 );
207     function calculateFee ( address asset, address user, uint256 amount ) external view returns ( uint256 );
208     function changeOracleType ( address asset, address user, uint256 newOracleType ) external;
209     function chargeFee ( address asset, address user, uint256 amount ) external;
210     function col (  ) external view returns ( address );
211     function colToken ( address, address ) external view returns ( uint256 );
212     function collaterals ( address, address ) external view returns ( uint256 );
213     function debts ( address, address ) external view returns ( uint256 );
214     function depositCol ( address asset, address user, uint256 amount ) external;
215     function depositEth ( address user ) external payable;
216     function depositMain ( address asset, address user, uint256 amount ) external;
217     function destroy ( address asset, address user ) external;
218     function getTotalDebt ( address asset, address user ) external view returns ( uint256 );
219     function lastUpdate ( address, address ) external view returns ( uint256 );
220     function liquidate ( address asset, address positionOwner, uint256 mainAssetToLiquidator, uint256 colToLiquidator, uint256 mainAssetToPositionOwner, uint256 colToPositionOwner, uint256 repayment, uint256 penalty, address liquidator ) external;
221     function liquidationBlock ( address, address ) external view returns ( uint256 );
222     function liquidationFee ( address, address ) external view returns ( uint256 );
223     function liquidationPrice ( address, address ) external view returns ( uint256 );
224     function oracleType ( address, address ) external view returns ( uint256 );
225     function repay ( address asset, address user, uint256 amount ) external returns ( uint256 );
226     function spawn ( address asset, address user, uint256 _oracleType ) external;
227     function stabilityFee ( address, address ) external view returns ( uint256 );
228     function tokenDebts ( address ) external view returns ( uint256 );
229     function triggerLiquidation ( address asset, address positionOwner, uint256 initialPrice ) external;
230     function update ( address asset, address user ) external;
231     function usdp (  ) external view returns ( address );
232     function vaultParameters (  ) external view returns ( address );
233     function weth (  ) external view returns ( address payable );
234     function withdrawCol ( address asset, address user, uint256 amount ) external;
235     function withdrawEth ( address user, uint256 amount ) external;
236     function withdrawMain ( address asset, address user, uint256 amount ) external;
237 }
238 
239 // File: localhost/contracts/interfaces/IWETH.sol
240 
241 interface IWETH {
242     function deposit() external payable;
243     function transfer(address to, uint value) external returns (bool);
244     function transferFrom(address from, address to, uint value) external returns (bool);
245     function withdraw(uint) external;
246 }
247 // File: localhost/contracts/interfaces/IOracleUsd.sol
248 
249 interface IOracleUsd {
250 
251     // returns Q112-encoded value
252     // returned value 10**18 * 2**112 is $1
253     function assetToUsd(address asset, uint amount) external view returns (uint);
254 }
255 
256 // File: localhost/contracts/interfaces/IOracleRegistry.sol
257 
258 
259 interface IOracleRegistry {
260 
261     struct Oracle {
262         uint oracleType;
263         address oracleAddress;
264     }
265 
266     function WETH (  ) external view returns ( address );
267     function getKeydonixOracleTypes (  ) external view returns ( uint256[] memory );
268     function getOracles (  ) external view returns ( Oracle[] memory foundOracles );
269     function keydonixOracleTypes ( uint256 ) external view returns ( uint256 );
270     function maxOracleType (  ) external view returns ( uint256 );
271     function oracleByAsset ( address asset ) external view returns ( address );
272     function oracleByType ( uint256 ) external view returns ( address );
273     function oracleTypeByAsset ( address ) external view returns ( uint256 );
274     function oracleTypeByOracle ( address ) external view returns ( uint256 );
275     function setKeydonixOracleTypes ( uint256[] memory _keydonixOracleTypes ) external;
276     function setOracle ( uint256 oracleType, address oracle ) external;
277     function setOracleTypeForAsset ( address asset, uint256 oracleType ) external;
278     function setOracleTypeForAssets ( address[] memory assets, uint256 oracleType ) external;
279     function unsetOracle ( uint256 oracleType ) external;
280     function unsetOracleForAsset ( address asset ) external;
281     function unsetOracleForAssets ( address[] memory assets ) external;
282     function vaultParameters (  ) external view returns ( address );
283 }
284 
285 // File: localhost/contracts/vault-managers/CDPManager01.sol
286 
287 /*
288   Copyright 2020 Unit Protocol: Artem Zakharov (az@unit.xyz).
289 */
290 pragma solidity 0.7.6;
291 
292 
293 
294 
295 
296 
297 
298 
299 
300 
301 
302 /**
303  * @title CDPManager01
304  **/
305 contract CDPManager01 is ReentrancyGuard {
306     using SafeMath for uint;
307 
308     IVault public immutable vault;
309     IVaultManagerParameters public immutable vaultManagerParameters;
310     IOracleRegistry public immutable oracleRegistry;
311     ICDPRegistry public immutable cdpRegistry;
312     address payable public immutable WETH;
313 
314     uint public constant Q112 = 2 ** 112;
315     uint public constant DENOMINATOR_1E5 = 1e5;
316 
317     /**
318      * @dev Trigger when joins are happened
319     **/
320     event Join(address indexed asset, address indexed owner, uint main, uint usdp);
321 
322     /**
323      * @dev Trigger when exits are happened
324     **/
325     event Exit(address indexed asset, address indexed owner, uint main, uint usdp);
326 
327     /**
328      * @dev Trigger when liquidations are initiated
329     **/
330     event LiquidationTriggered(address indexed asset, address indexed owner);
331 
332     modifier checkpoint(address asset, address owner) {
333         _;
334         cdpRegistry.checkpoint(asset, owner);
335     }
336 
337     /**
338      * @param _vaultManagerParameters The address of the contract with Vault manager parameters
339      * @param _oracleRegistry The address of the oracle registry
340      * @param _cdpRegistry The address of the CDP registry
341      **/
342     constructor(address _vaultManagerParameters, address _oracleRegistry, address _cdpRegistry) {
343         require(
344             _vaultManagerParameters != address(0) && 
345             _oracleRegistry != address(0) && 
346             _cdpRegistry != address(0),
347                 "Unit Protocol: INVALID_ARGS"
348         );
349         vaultManagerParameters = IVaultManagerParameters(_vaultManagerParameters);
350         vault = IVault(IVaultParameters(IVaultManagerParameters(_vaultManagerParameters).vaultParameters()).vault());
351         oracleRegistry = IOracleRegistry(_oracleRegistry);
352         WETH = IVault(IVaultParameters(IVaultManagerParameters(_vaultManagerParameters).vaultParameters()).vault()).weth();
353         cdpRegistry = ICDPRegistry(_cdpRegistry);
354     }
355 
356     // only accept ETH via fallback from the WETH contract
357     receive() external payable {
358         require(msg.sender == WETH, "Unit Protocol: RESTRICTED");
359     }
360 
361     /**
362       * @notice Depositing tokens must be pre-approved to Vault address
363       * @notice position actually considered as spawned only when debt > 0
364       * @dev Deposits collateral and/or borrows USDP
365       * @param asset The address of the collateral
366       * @param assetAmount The amount of the collateral to deposit
367       * @param usdpAmount The amount of USDP token to borrow
368       **/
369     function join(address asset, uint assetAmount, uint usdpAmount) public nonReentrant checkpoint(asset, msg.sender) {
370         require(usdpAmount != 0 || assetAmount != 0, "Unit Protocol: USELESS_TX");
371 
372         require(IToken(asset).decimals() <= 18, "Unit Protocol: NOT_SUPPORTED_DECIMALS");
373 
374         if (usdpAmount == 0) {
375 
376             vault.depositMain(asset, msg.sender, assetAmount);
377 
378         } else {
379 
380             _ensureOracle(asset);
381 
382             bool spawned = vault.debts(asset, msg.sender) != 0;
383 
384             if (!spawned) {
385                 // spawn a position
386                 vault.spawn(asset, msg.sender, oracleRegistry.oracleTypeByAsset(asset));
387             }
388 
389             if (assetAmount != 0) {
390                 vault.depositMain(asset, msg.sender, assetAmount);
391             }
392 
393             // mint USDP to owner
394             vault.borrow(asset, msg.sender, usdpAmount);
395 
396             // check collateralization
397             _ensurePositionCollateralization(asset, msg.sender);
398 
399         }
400 
401         // fire an event
402         emit Join(asset, msg.sender, assetAmount, usdpAmount);
403     }
404 
405     /**
406       * @dev Deposits ETH and/or borrows USDP
407       * @param usdpAmount The amount of USDP token to borrow
408       **/
409     function join_Eth(uint usdpAmount) external payable {
410 
411         if (msg.value != 0) {
412             IWETH(WETH).deposit{value: msg.value}();
413             require(IWETH(WETH).transfer(msg.sender, msg.value), "Unit Protocol: WETH_TRANSFER_FAILED");
414         }
415 
416         join(WETH, msg.value, usdpAmount);
417     }
418 
419     /**
420       * @notice Tx sender must have a sufficient USDP balance to pay the debt
421       * @dev Withdraws collateral and repays specified amount of debt
422       * @param asset The address of the collateral
423       * @param assetAmount The amount of the collateral to withdraw
424       * @param usdpAmount The amount of USDP to repay
425       **/
426     function exit(address asset, uint assetAmount, uint usdpAmount) public nonReentrant checkpoint(asset, msg.sender) returns (uint) {
427 
428         // check usefulness of tx
429         require(assetAmount != 0 || usdpAmount != 0, "Unit Protocol: USELESS_TX");
430 
431         uint debt = vault.debts(asset, msg.sender);
432 
433         // catch full repayment
434         if (usdpAmount > debt) { usdpAmount = debt; }
435 
436         if (assetAmount == 0) {
437             _repay(asset, msg.sender, usdpAmount);
438         } else {
439             if (debt == usdpAmount) {
440                 vault.withdrawMain(asset, msg.sender, assetAmount);
441                 if (usdpAmount != 0) {
442                     _repay(asset, msg.sender, usdpAmount);
443                 }
444             } else {
445                 _ensureOracle(asset);
446 
447                 // withdraw collateral to the owner address
448                 vault.withdrawMain(asset, msg.sender, assetAmount);
449 
450                 if (usdpAmount != 0) {
451                     _repay(asset, msg.sender, usdpAmount);
452                 }
453 
454                 vault.update(asset, msg.sender);
455 
456                 _ensurePositionCollateralization(asset, msg.sender);
457             }
458         }
459 
460         // fire an event
461         emit Exit(asset, msg.sender, assetAmount, usdpAmount);
462 
463         return usdpAmount;
464     }
465 
466     /**
467       * @notice Repayment is the sum of the principal and interest
468       * @dev Withdraws collateral and repays specified amount of debt
469       * @param asset The address of the collateral
470       * @param assetAmount The amount of the collateral to withdraw
471       * @param repayment The target repayment amount
472       **/
473     function exit_targetRepayment(address asset, uint assetAmount, uint repayment) external returns (uint) {
474 
475         uint usdpAmount = _calcPrincipal(asset, msg.sender, repayment);
476 
477         return exit(asset, assetAmount, usdpAmount);
478     }
479 
480     /**
481       * @notice Withdraws WETH and converts to ETH
482       * @param ethAmount ETH amount to withdraw
483       * @param usdpAmount The amount of USDP token to repay
484       **/
485     function exit_Eth(uint ethAmount, uint usdpAmount) public returns (uint) {
486         usdpAmount = exit(WETH, ethAmount, usdpAmount);
487         require(IWETH(WETH).transferFrom(msg.sender, address(this), ethAmount), "Unit Protocol: WETH_TRANSFER_FROM_FAILED");
488         IWETH(WETH).withdraw(ethAmount);
489         (bool success, ) = msg.sender.call{value:ethAmount}("");
490         require(success, "Unit Protocol: ETH_TRANSFER_FAILED");
491         return usdpAmount;
492     }
493 
494     /**
495       * @notice Repayment is the sum of the principal and interest
496       * @notice Withdraws WETH and converts to ETH
497       * @param ethAmount ETH amount to withdraw
498       * @param repayment The target repayment amount
499       **/
500     function exit_Eth_targetRepayment(uint ethAmount, uint repayment) external returns (uint) {
501         uint usdpAmount = _calcPrincipal(WETH, msg.sender, repayment);
502         return exit_Eth(ethAmount, usdpAmount);
503     }
504 
505     // decreases debt
506     function _repay(address asset, address owner, uint usdpAmount) internal {
507         uint fee = vault.calculateFee(asset, owner, usdpAmount);
508         vault.chargeFee(vault.usdp(), owner, fee);
509 
510         // burn USDP from the owner's balance
511         uint debtAfter = vault.repay(asset, owner, usdpAmount);
512         if (debtAfter == 0) {
513             // clear unused storage
514             vault.destroy(asset, owner);
515         }
516     }
517 
518     function _ensurePositionCollateralization(address asset, address owner) internal view {
519         // collateral value of the position in USD
520         uint usdValue_q112 = getCollateralUsdValue_q112(asset, owner);
521 
522         // USD limit of the position
523         uint usdLimit = usdValue_q112 * vaultManagerParameters.initialCollateralRatio(asset) / Q112 / 100;
524 
525         // revert if collateralization is not enough
526         require(vault.getTotalDebt(asset, owner) <= usdLimit, "Unit Protocol: UNDERCOLLATERALIZED");
527     }
528     
529     // Liquidation Trigger
530 
531     /**
532      * @dev Triggers liquidation of a position
533      * @param asset The address of the collateral token of a position
534      * @param owner The owner of the position
535      **/
536     function triggerLiquidation(address asset, address owner) external nonReentrant {
537 
538         _ensureOracle(asset);
539 
540         // USD value of the collateral
541         uint usdValue_q112 = getCollateralUsdValue_q112(asset, owner);
542         
543         // reverts if a position is not liquidatable
544         require(_isLiquidatablePosition(asset, owner, usdValue_q112), "Unit Protocol: SAFE_POSITION");
545 
546         uint liquidationDiscount_q112 = usdValue_q112.mul(
547             vaultManagerParameters.liquidationDiscount(asset)
548         ).div(DENOMINATOR_1E5);
549 
550         uint initialLiquidationPrice = usdValue_q112.sub(liquidationDiscount_q112).div(Q112);
551 
552         // sends liquidation command to the Vault
553         vault.triggerLiquidation(asset, owner, initialLiquidationPrice);
554 
555         // fire an liquidation event
556         emit LiquidationTriggered(asset, owner);
557     }
558 
559     function getCollateralUsdValue_q112(address asset, address owner) public view returns (uint) {
560         return IOracleUsd(oracleRegistry.oracleByAsset(asset)).assetToUsd(asset, vault.collaterals(asset, owner));
561     }
562 
563     /**
564      * @dev Determines whether a position is liquidatable
565      * @param asset The address of the collateral
566      * @param owner The owner of the position
567      * @param usdValue_q112 Q112-encoded USD value of the collateral
568      * @return boolean value, whether a position is liquidatable
569      **/
570     function _isLiquidatablePosition(
571         address asset,
572         address owner,
573         uint usdValue_q112
574     ) internal view returns (bool) {
575         uint debt = vault.getTotalDebt(asset, owner);
576 
577         // position is collateralized if there is no debt
578         if (debt == 0) return false;
579 
580         return debt.mul(100).mul(Q112).div(usdValue_q112) >= vaultManagerParameters.liquidationRatio(asset);
581     }
582 
583     function _ensureOracle(address asset) internal view {
584         uint oracleType = oracleRegistry.oracleTypeByAsset(asset);
585         require(oracleType != 0, "Unit Protocol: INVALID_ORACLE_TYPE");
586         address oracle = oracleRegistry.oracleByType(oracleType);
587         require(oracle != address(0), "Unit Protocol: DISABLED_ORACLE");
588     }
589 
590     /**
591      * @dev Determines whether a position is liquidatable
592      * @param asset The address of the collateral
593      * @param owner The owner of the position
594      * @return boolean value, whether a position is liquidatable
595      **/
596     function isLiquidatablePosition(
597         address asset,
598         address owner
599     ) public view returns (bool) {
600         uint usdValue_q112 = getCollateralUsdValue_q112(asset, owner);
601 
602         return _isLiquidatablePosition(asset, owner, usdValue_q112);
603     }
604 
605     /**
606      * @dev Calculates current utilization ratio
607      * @param asset The address of the collateral
608      * @param owner The owner of the position
609      * @return utilization ratio
610      **/
611     function utilizationRatio(
612         address asset,
613         address owner
614     ) public view returns (uint) {
615         uint debt = vault.getTotalDebt(asset, owner);
616         if (debt == 0) return 0;
617         
618         uint usdValue_q112 = getCollateralUsdValue_q112(asset, owner);
619 
620         return debt.mul(100).mul(Q112).div(usdValue_q112);
621     }
622     
623 
624     /**
625      * @dev Calculates liquidation price
626      * @param asset The address of the collateral
627      * @param owner The owner of the position
628      * @return Q112-encoded liquidation price
629      **/
630     function liquidationPrice_q112(
631         address asset,
632         address owner
633     ) external view returns (uint) {
634 
635         uint debt = vault.getTotalDebt(asset, owner);
636         if (debt == 0) return uint(-1);
637         
638         uint collateralLiqPrice = debt.mul(100).mul(Q112).div(vaultManagerParameters.liquidationRatio(asset));
639 
640         require(IToken(asset).decimals() <= 18, "Unit Protocol: NOT_SUPPORTED_DECIMALS");
641 
642         return collateralLiqPrice / vault.collaterals(asset, owner) / 10 ** (18 - IToken(asset).decimals());
643     }
644 
645     function _calcPrincipal(address asset, address owner, uint repayment) internal view returns (uint) {
646         uint fee = vault.stabilityFee(asset, owner) * (block.timestamp - vault.lastUpdate(asset, owner)) / 365 days;
647         return repayment * DENOMINATOR_1E5 / (DENOMINATOR_1E5 + fee);
648     }
649 }