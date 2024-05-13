1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "../../interfaces/IStakerVault.sol";
5 import "../../interfaces/tokenomics/IInflationManager.sol";
6 import "../../interfaces/tokenomics/IKeeperGauge.sol";
7 import "../../interfaces/tokenomics/IAmmGauge.sol";
8 
9 import "../../libraries/EnumerableMapping.sol";
10 import "../../libraries/EnumerableExtensions.sol";
11 import "../../libraries/AddressProviderHelpers.sol";
12 
13 import "./Minter.sol";
14 import "../utils/Preparable.sol";
15 import "../access/Authorization.sol";
16 
17 contract InflationManager is Authorization, IInflationManager, Preparable {
18     using EnumerableMapping for EnumerableMapping.AddressToAddressMap;
19     using EnumerableExtensions for EnumerableMapping.AddressToAddressMap;
20     using AddressProviderHelpers for IAddressProvider;
21 
22     IAddressProvider public immutable addressProvider;
23 
24     bytes32 internal constant _KEEPER_WEIGHT_KEY = "keeperWeight";
25     bytes32 internal constant _AMM_WEIGHT_KEY = "ammWeight";
26     bytes32 internal constant _LP_WEIGHT_KEY = "lpWeight";
27 
28     address public minter;
29     bool public weightBasedKeeperDistributionDeactivated;
30     uint256 public totalKeeperPoolWeight;
31     uint256 public totalLpPoolWeight;
32     uint256 public totalAmmTokenWeight;
33 
34     // Pool -> keeperGauge
35     EnumerableMapping.AddressToAddressMap private _keeperGauges;
36     // AMM token -> ammGauge
37     EnumerableMapping.AddressToAddressMap private _ammGauges;
38 
39     mapping(address => bool) public gauges;
40 
41     event NewKeeperWeight(address indexed pool, uint256 newWeight);
42     event NewLpWeight(address indexed pool, uint256 newWeight);
43     event NewAmmTokenWeight(address indexed token, uint256 newWeight);
44 
45     modifier onlyGauge() {
46         require(gauges[msg.sender], Error.UNAUTHORIZED_ACCESS);
47         _;
48     }
49 
50     constructor(IAddressProvider _addressProvider)
51         Authorization(_addressProvider.getRoleManager())
52     {
53         addressProvider = _addressProvider;
54     }
55 
56     function setMinter(address _minter) external onlyGovernance returns (bool) {
57         require(minter == address(0), Error.ADDRESS_ALREADY_SET);
58         require(_minter != address(0), Error.INVALID_MINTER);
59         minter = _minter;
60         return true;
61     }
62 
63     /**
64      * @notice Advance the keeper gauge for a pool by on epoch.
65      * @param pool Pool for which the keeper gauge is advanced.
66      * @return `true` if successful.
67      */
68     function advanceKeeperGaugeEpoch(address pool) external onlyGovernance returns (bool) {
69         IKeeperGauge(_keeperGauges.get(pool)).advanceEpoch();
70         return true;
71     }
72 
73     /**
74      * @notice Mints BKD tokens.
75      * @param beneficiary Address to receive the tokens.
76      * @param amount Amount of tokens to mint.
77      */
78     function mintRewards(address beneficiary, uint256 amount) external override onlyGauge {
79         Minter(minter).mint(beneficiary, amount);
80     }
81 
82     /**
83      * @notice Deactivates the weight-based distribution of keeper inflation.
84      * @dev This can only be done once, when the keeper inflation mechanism is altered.
85      * @return `true` if successful.
86      */
87     function deactivateWeightBasedKeeperDistribution() external onlyGovernance returns (bool) {
88         require(!weightBasedKeeperDistributionDeactivated, "Weight-based dist. deactivated.");
89         address[] memory liquidityPools = addressProvider.allPools();
90         uint256 length = liquidityPools.length;
91         for (uint256 i = 0; i < length; i++) {
92             _removeKeeperGauge(address(liquidityPools[i]));
93         }
94         weightBasedKeeperDistributionDeactivated = true;
95         return true;
96     }
97 
98     /**
99      * @notice Checkpoints all gauges.
100      * @dev This is mostly used upon inflation rate updates.
101      * @return `true` if successful.
102      */
103     function checkpointAllGauges() external override returns (bool) {
104         uint256 length = _keeperGauges.length();
105         for (uint256 i = 0; i < length; i++) {
106             IKeeperGauge(_keeperGauges.valueAt(i)).poolCheckpoint();
107         }
108         address[] memory stakerVaults = addressProvider.allStakerVaults();
109         for (uint256 i = 0; i < stakerVaults.length; i++) {
110             IStakerVault(stakerVaults[i]).poolCheckpoint();
111         }
112 
113         length = _ammGauges.length();
114         for (uint256 i = 0; i < length; i++) {
115             IAmmGauge(_ammGauges.valueAt(i)).poolCheckpoint();
116         }
117         return true;
118     }
119 
120     /**
121      * @notice Prepare update of a keeper pool weight (with time delay enforced).
122      * @param pool Pool to update the keeper weight for.
123      * @param newPoolWeight New weight for the keeper inflation for the pool.
124      * @return `true` if successful.
125      */
126     function prepareKeeperPoolWeight(address pool, uint256 newPoolWeight)
127         external
128         override
129         onlyGovernance
130         returns (bool)
131     {
132         require(_keeperGauges.contains(pool), Error.INVALID_ARGUMENT);
133         bytes32 key = _getKeeperGaugeKey(pool);
134         _prepare(key, newPoolWeight);
135         return true;
136     }
137 
138     /**
139      * @notice Execute update of keeper pool weight (with time delay enforced).
140      * @param pool Pool to execute the keeper weight update for.
141      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
142      * @return New keeper pool weight.
143      */
144     function executeKeeperPoolWeight(address pool) external override returns (uint256) {
145         bytes32 key = _getKeeperGaugeKey(pool);
146         _executeKeeperPoolWeight(key, pool, isInflationWeightManager(msg.sender));
147         return currentUInts256[key];
148     }
149 
150     /**
151      * @notice Prepare update of a batch of keeperGauge weights (with time delay enforced).
152      * @dev Each entry in the pools array corresponds to an entry in the weights array.
153      * @param pools Pools to update the keeper weight for.
154      * @param weights New weights for the keeper inflation for the pools.
155      * @return `true` if successful.
156      */
157     function batchPrepareKeeperPoolWeights(address[] calldata pools, uint256[] calldata weights)
158         external
159         override
160         onlyGovernance
161         returns (bool)
162     {
163         uint256 length = pools.length;
164         require(length == weights.length, Error.INVALID_ARGUMENT);
165         bytes32 key;
166         for (uint256 i = 0; i < length; i++) {
167             require(_keeperGauges.contains(pools[i]), Error.INVALID_ARGUMENT);
168             key = _getKeeperGaugeKey(pools[i]);
169             _prepare(key, weights[i]);
170         }
171         return true;
172     }
173 
174     function whitelistGauge(address gauge) external onlyRole(Roles.CONTROLLER) {
175         gauges[gauge] = true;
176     }
177 
178     /**
179      * @notice Execute weight updates for a batch of _keeperGauges.
180      * @param pools Pools to execute the keeper weight updates for.
181      * @return `true` if successful.
182      */
183     function batchExecuteKeeperPoolWeights(address[] calldata pools)
184         external
185         override
186         onlyRoles2(Roles.GOVERNANCE, Roles.INFLATION_MANAGER)
187         returns (bool)
188     {
189         uint256 length = pools.length;
190         bytes32 key;
191         for (uint256 i = 0; i < length; i++) {
192             key = _getKeeperGaugeKey(pools[i]);
193             _executeKeeperPoolWeight(key, pools[i], isInflationWeightManager(msg.sender));
194         }
195         return true;
196     }
197 
198     function removeStakerVaultFromInflation(address stakerVault, address lpToken)
199         external
200         onlyRole(Roles.CONTROLLER)
201     {
202         bytes32 key = _getLpStakerVaultKey(stakerVault);
203         _prepare(key, 0);
204         _executeLpPoolWeight(key, lpToken, stakerVault, true);
205     }
206 
207     /**
208      * @notice Prepare update of a lp pool weight (with time delay enforced).
209      * @param lpToken LP token to update the weight for.
210      * @param newPoolWeight New LP inflation weight.
211      * @return `true` if successful.
212      */
213     function prepareLpPoolWeight(address lpToken, uint256 newPoolWeight)
214         external
215         override
216         onlyRoles2(Roles.GOVERNANCE, Roles.INFLATION_MANAGER)
217         returns (bool)
218     {
219         address stakerVault = addressProvider.getStakerVault(lpToken);
220         // Require both that gauge is registered and that pool is still in action
221         require(gauges[IStakerVault(stakerVault).getLpGauge()], Error.GAUGE_DOES_NOT_EXIST);
222         _ensurePoolExists(lpToken);
223         bytes32 key = _getLpStakerVaultKey(stakerVault);
224         _prepare(key, newPoolWeight);
225         return true;
226     }
227 
228     /**
229      * @notice Execute update of lp pool weight (with time delay enforced).
230      * @dev Needs to be called after the update was prepared. Fails if called before time delay is met.
231      * @return New lp pool weight.
232      */
233     function executeLpPoolWeight(address lpToken) external override returns (uint256) {
234         address stakerVault = addressProvider.getStakerVault(lpToken);
235         // Require both that gauge is registered and that pool is still in action
236         require(IStakerVault(stakerVault).getLpGauge() != address(0), Error.ADDRESS_NOT_FOUND);
237         _ensurePoolExists(lpToken);
238         bytes32 key = _getLpStakerVaultKey(stakerVault);
239         _executeLpPoolWeight(key, lpToken, stakerVault, isInflationWeightManager(msg.sender));
240         return currentUInts256[key];
241     }
242 
243     /**
244      * @notice Prepare update of a batch of LP token weights (with time delay enforced).
245      * @dev Each entry in the lpTokens array corresponds to an entry in the weights array.
246      * @param lpTokens LpTokens to update the inflation weight for.
247      * @param weights New weights for the inflation for the LpTokens.
248      * @return `true` if successful.
249      */
250     function batchPrepareLpPoolWeights(address[] calldata lpTokens, uint256[] calldata weights)
251         external
252         override
253         onlyRoles2(Roles.GOVERNANCE, Roles.INFLATION_MANAGER)
254         returns (bool)
255     {
256         uint256 length = lpTokens.length;
257         require(length == weights.length, "Invalid length of arguments");
258         bytes32 key;
259         for (uint256 i = 0; i < length; i++) {
260             address stakerVault = addressProvider.getStakerVault(lpTokens[i]);
261             // Require both that gauge is registered and that pool is still in action
262             require(IStakerVault(stakerVault).getLpGauge() != address(0), Error.ADDRESS_NOT_FOUND);
263             _ensurePoolExists(lpTokens[i]);
264             key = _getLpStakerVaultKey(stakerVault);
265             _prepare(key, weights[i]);
266         }
267         return true;
268     }
269 
270     /**
271      * @notice Execute weight updates for a batch of LpTokens.
272      * @dev If this is called by the INFLATION_MANAGER role address, no time delay is enforced.
273      * @param lpTokens LpTokens to execute the weight updates for.
274      * @return `true` if successful.
275      */
276     function batchExecuteLpPoolWeights(address[] calldata lpTokens)
277         external
278         override
279         onlyRoles2(Roles.GOVERNANCE, Roles.INFLATION_MANAGER)
280         returns (bool)
281     {
282         uint256 length = lpTokens.length;
283         for (uint256 i = 0; i < length; i++) {
284             address lpToken = lpTokens[i];
285             address stakerVault = addressProvider.getStakerVault(lpToken);
286             // Require both that gauge is registered and that pool is still in action
287             require(IStakerVault(stakerVault).getLpGauge() != address(0), Error.ADDRESS_NOT_FOUND);
288             _ensurePoolExists(lpToken);
289             bytes32 key = _getLpStakerVaultKey(stakerVault);
290             _executeLpPoolWeight(key, lpToken, stakerVault, isInflationWeightManager(msg.sender));
291         }
292         return true;
293     }
294 
295     /**
296      * @notice Prepare an inflation weight update for an AMM token (with time delay enforced).
297      * @param token AMM token to update the weight for.
298      * @param newTokenWeight New AMM token inflation weight.
299      * @return `true` if successful.
300      */
301     function prepareAmmTokenWeight(address token, uint256 newTokenWeight)
302         external
303         override
304         onlyRoles2(Roles.GOVERNANCE, Roles.INFLATION_MANAGER)
305         returns (bool)
306     {
307         require(_ammGauges.contains(token), "amm gauge not found");
308         bytes32 key = _getAmmGaugeKey(token);
309         _prepare(key, newTokenWeight);
310         return true;
311     }
312 
313     /**
314      * @notice Execute update of lp pool weight (with time delay enforced).
315      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
316      * @return New lp pool weight.
317      */
318     function executeAmmTokenWeight(address token) external override returns (uint256) {
319         bytes32 key = _getAmmGaugeKey(token);
320         _executeAmmTokenWeight(token, key, isInflationWeightManager(msg.sender));
321         return currentUInts256[key];
322     }
323 
324     /**
325      * @notice Registers a pool's strategy with the stakerVault of the pool where the strategy deposits.
326      * @dev This simply avoids the strategy accumulating tokens in the deposit pool.
327      * @param depositStakerVault StakerVault of the pool where the strategy deposits.
328      * @param strategyPool The pool of the strategy to register (avoids blacklisting other addresses).
329      * @return `true` if successful.
330      */
331     function addStrategyToDepositStakerVault(address depositStakerVault, address strategyPool)
332         external
333         onlyGovernance
334         returns (bool)
335     {
336         IVault _vault = ILiquidityPool(strategyPool).getVault();
337         IStakerVault(depositStakerVault).addStrategy(address(_vault.getStrategy()));
338         return true;
339     }
340 
341     /**
342      * @notice Prepare update of a batch of AMM token weights (with time delay enforced).
343      * @dev Each entry in the tokens array corresponds to an entry in the weights array.
344      * @param tokens AMM tokens to update the inflation weight for.
345      * @param weights New weights for the inflation for the AMM tokens.
346      * @return `true` if successful.
347      */
348     function batchPrepareAmmTokenWeights(address[] calldata tokens, uint256[] calldata weights)
349         external
350         override
351         onlyRoles2(Roles.GOVERNANCE, Roles.INFLATION_MANAGER)
352         returns (bool)
353     {
354         uint256 length = tokens.length;
355         bytes32 key;
356         require(length == weights.length, "Invalid length of arguments");
357         for (uint256 i = 0; i < length; i++) {
358             require(_ammGauges.contains(tokens[i]), "amm gauge not found");
359             key = _getAmmGaugeKey(tokens[i]);
360             _prepare(key, weights[i]);
361         }
362         return true;
363     }
364 
365     /**
366      * @notice Execute weight updates for a batch of AMM tokens.
367      * @dev If this is called by the INFLATION_MANAGER role address, no time delay is enforced.
368      * @param tokens AMM tokens to execute the weight updates for.
369      * @return `true` if successful.
370      */
371     function batchExecuteAmmTokenWeights(address[] calldata tokens)
372         external
373         override
374         onlyRoles2(Roles.GOVERNANCE, Roles.INFLATION_MANAGER)
375         returns (bool)
376     {
377         uint256 length = tokens.length;
378         bool isWeightManager = isInflationWeightManager(msg.sender);
379         bytes32 key;
380         address token;
381         for (uint256 i = 0; i < length; i++) {
382             token = tokens[i];
383             key = _getAmmGaugeKey(token);
384             _executeAmmTokenWeight(token, key, isWeightManager);
385         }
386         return true;
387     }
388 
389     /**
390      * @notice Sets the KeeperGauge for a pool.
391      * @dev Multiple pools can have the same KeeperGauge.
392      * @param pool Address of pool to set the KeeperGauge for.
393      * @param _keeperGauge Address of KeeperGauge.
394      * @return `true` if successful.
395      */
396     function setKeeperGauge(address pool, address _keeperGauge)
397         external
398         override
399         onlyGovernance
400         returns (bool)
401     {
402         uint256 length = _keeperGauges.length();
403         bool keeperGaugeExists = false;
404         for (uint256 i = 0; i < length; i++) {
405             if (address(_keeperGauges.valueAt(i)) == _keeperGauge) {
406                 keeperGaugeExists = true;
407                 break;
408             }
409         }
410         // Check to make sure that once weight-based dist is deactivated, only one gauge can exist
411         if (!keeperGaugeExists && weightBasedKeeperDistributionDeactivated && length >= 1) {
412             return false;
413         }
414         (bool exists, address keeperGauge) = _keeperGauges.tryGet(pool);
415         require(!exists || keeperGauge != _keeperGauge, Error.INVALID_ARGUMENT);
416 
417         if (exists && !IKeeperGauge(keeperGauge).killed()) {
418             IKeeperGauge(keeperGauge).poolCheckpoint();
419             IKeeperGauge(keeperGauge).kill();
420         }
421         _keeperGauges.set(pool, _keeperGauge);
422         gauges[_keeperGauge] = true;
423         return true;
424     }
425 
426     function removeKeeperGauge(address pool) external onlyGovernance returns (bool) {
427         _removeKeeperGauge(pool);
428         return true;
429     }
430 
431     /**
432      * @notice Sets the AmmGauge for a particular AMM token.
433      * @param token Address of the amm token.
434      * @param _ammGauge Address of AmmGauge.
435      * @return `true` if successful.
436      */
437     function setAmmGauge(address token, address _ammGauge)
438         external
439         override
440         onlyGovernance
441         returns (bool)
442     {
443         require(IAmmGauge(_ammGauge).isAmmToken(token), Error.ADDRESS_NOT_WHITELISTED);
444         uint256 length = _ammGauges.length();
445         for (uint256 i = 0; i < length; i++) {
446             if (address(_ammGauges.valueAt(i)) == _ammGauge) {
447                 return false;
448             }
449         }
450         if (_ammGauges.contains(token)) {
451             address ammGauge = _ammGauges.get(token);
452             IAmmGauge(ammGauge).poolCheckpoint();
453             IAmmGauge(ammGauge).kill();
454         }
455         _ammGauges.set(token, _ammGauge);
456         gauges[_ammGauge] = true;
457         return true;
458     }
459 
460     function removeAmmGauge(address token) external onlyGovernance returns (bool) {
461         if (!_ammGauges.contains(token)) return false;
462         address ammGauge = _ammGauges.get(token);
463         bytes32 key = _getAmmGaugeKey(token);
464         _prepare(key, 0);
465         _executeAmmTokenWeight(token, key, true);
466         IAmmGauge(ammGauge).kill();
467         _ammGauges.remove(token);
468         // Do not delete from the gauges map to allow claiming of remaining balances
469         emit AmmGaugeDelisted(token, ammGauge);
470         return true;
471     }
472 
473     function addGaugeForVault(address lpToken) external override returns (bool) {
474         IStakerVault _stakerVault = IStakerVault(msg.sender);
475         require(addressProvider.isStakerVault(msg.sender, lpToken), Error.UNAUTHORIZED_ACCESS);
476         address lpGauge = _stakerVault.getLpGauge();
477         require(lpGauge != address(0), Error.GAUGE_DOES_NOT_EXIST);
478         gauges[lpGauge] = true;
479         return true;
480     }
481 
482     function getAllAmmGauges() external view override returns (address[] memory) {
483         return _ammGauges.valuesArray();
484     }
485 
486     function getLpRateForStakerVault(address stakerVault) external view override returns (uint256) {
487         if (minter == address(0) || totalLpPoolWeight == 0) {
488             return 0;
489         }
490 
491         bytes32 key = _getLpStakerVaultKey(stakerVault);
492         uint256 lpInflationRate = Minter(minter).getLpInflationRate();
493         uint256 poolInflationRate = (currentUInts256[key] * lpInflationRate) / totalLpPoolWeight;
494 
495         return poolInflationRate;
496     }
497 
498     function getKeeperRateForPool(address pool) external view override returns (uint256) {
499         if (minter == address(0)) {
500             return 0;
501         }
502         uint256 keeperInflationRate = Minter(minter).getKeeperInflationRate();
503         // After deactivation of weight based dist, KeeperGauge handles the splitting
504         if (weightBasedKeeperDistributionDeactivated) return keeperInflationRate;
505         if (totalKeeperPoolWeight == 0) return 0;
506         bytes32 key = _getKeeperGaugeKey(pool);
507         uint256 poolInflationRate = (currentUInts256[key] * keeperInflationRate) /
508             totalKeeperPoolWeight;
509         return poolInflationRate;
510     }
511 
512     function getAmmRateForToken(address token) external view override returns (uint256) {
513         if (minter == address(0) || totalAmmTokenWeight == 0) {
514             return 0;
515         }
516         bytes32 key = _getAmmGaugeKey(token);
517         uint256 ammInflationRate = Minter(minter).getAmmInflationRate();
518         uint256 ammTokenInflationRate = (currentUInts256[key] * ammInflationRate) /
519             totalAmmTokenWeight;
520         return ammTokenInflationRate;
521     }
522 
523     //TOOD: See if this is still needed somewhere
524     function getKeeperWeightForPool(address pool) external view override returns (uint256) {
525         bytes32 key = _getKeeperGaugeKey(pool);
526         return currentUInts256[key];
527     }
528 
529     function getAmmWeightForToken(address token) external view override returns (uint256) {
530         bytes32 key = _getAmmGaugeKey(token);
531         return currentUInts256[key];
532     }
533 
534     function getLpPoolWeight(address lpToken) external view override returns (uint256) {
535         address stakerVault = addressProvider.getStakerVault(lpToken);
536         bytes32 key = _getLpStakerVaultKey(stakerVault);
537         return currentUInts256[key];
538     }
539 
540     function getKeeperGaugeForPool(address pool) external view override returns (address) {
541         (, address keeperGauge) = _keeperGauges.tryGet(pool);
542         return keeperGauge;
543     }
544 
545     function getAmmGaugeForToken(address token) external view override returns (address) {
546         (, address ammGauge) = _ammGauges.tryGet(token);
547         return ammGauge;
548     }
549 
550     /**
551      * @notice Check if an account is governance proxy.
552      * @param account Address to check.
553      * @return `true` if account is governance proxy.
554      */
555     function isInflationWeightManager(address account) public view override returns (bool) {
556         return _roleManager().hasRole(Roles.INFLATION_MANAGER, account);
557     }
558 
559     function _executeKeeperPoolWeight(
560         bytes32 key,
561         address pool,
562         bool isWeightManager
563     ) internal returns (bool) {
564         IKeeperGauge(_keeperGauges.get(pool)).poolCheckpoint();
565         totalKeeperPoolWeight = totalKeeperPoolWeight - currentUInts256[key] + pendingUInts256[key];
566         totalKeeperPoolWeight = totalKeeperPoolWeight > 0 ? totalKeeperPoolWeight : 0;
567         isWeightManager ? _setConfig(key, pendingUInts256[key]) : _executeUInt256(key);
568         emit NewKeeperWeight(pool, currentUInts256[key]);
569         return true;
570     }
571 
572     function _executeLpPoolWeight(
573         bytes32 key,
574         address lpToken,
575         address stakerVault,
576         bool isWeightManager
577     ) internal returns (bool) {
578         IStakerVault(stakerVault).poolCheckpoint();
579         totalLpPoolWeight = totalLpPoolWeight - currentUInts256[key] + pendingUInts256[key];
580         totalLpPoolWeight = totalLpPoolWeight > 0 ? totalLpPoolWeight : 0;
581         isWeightManager ? _setConfig(key, pendingUInts256[key]) : _executeUInt256(key);
582         emit NewLpWeight(lpToken, currentUInts256[key]);
583         return true;
584     }
585 
586     function _executeAmmTokenWeight(
587         address token,
588         bytes32 key,
589         bool isWeightManager
590     ) internal returns (bool) {
591         IAmmGauge(_ammGauges.get(token)).poolCheckpoint();
592         totalAmmTokenWeight = totalAmmTokenWeight - currentUInts256[key] + pendingUInts256[key];
593         totalAmmTokenWeight = totalAmmTokenWeight > 0 ? totalAmmTokenWeight : 0;
594         isWeightManager ? _setConfig(key, pendingUInts256[key]) : _executeUInt256(key);
595         // Do pool checkpoint to update the pool integrals
596         emit NewAmmTokenWeight(token, currentUInts256[key]);
597         return true;
598     }
599 
600     function _removeKeeperGauge(address pool) internal {
601         address keeperGauge = _keeperGauges.get(pool);
602         bytes32 key = _getKeeperGaugeKey(pool);
603         _prepare(key, 0);
604         _executeKeeperPoolWeight(key, pool, true);
605         _keeperGauges.remove(pool);
606         IKeeperGauge(keeperGauge).kill();
607         // Do not delete from the gauges map to allow claiming of remaining balances
608         emit KeeperGaugeDelisted(pool, keeperGauge);
609     }
610 
611     function _ensurePoolExists(address lpToken) internal view {
612         require(
613             address(addressProvider.safeGetPoolForToken(lpToken)) != address(0),
614             Error.ADDRESS_NOT_FOUND
615         );
616     }
617 
618     function _getKeeperGaugeKey(address pool) internal pure returns (bytes32) {
619         return keccak256(abi.encodePacked(_KEEPER_WEIGHT_KEY, pool));
620     }
621 
622     function _getAmmGaugeKey(address token) internal pure returns (bytes32) {
623         return keccak256(abi.encodePacked(_AMM_WEIGHT_KEY, token));
624     }
625 
626     function _getLpStakerVaultKey(address vault) internal pure returns (bytes32) {
627         return keccak256(abi.encodePacked(_LP_WEIGHT_KEY, vault));
628     }
629 }
