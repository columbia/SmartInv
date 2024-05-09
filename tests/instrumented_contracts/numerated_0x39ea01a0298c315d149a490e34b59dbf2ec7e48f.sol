1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: SynthetixBridgeToOptimism.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/SynthetixBridgeToOptimism.sol
11 * Docs: https://docs.synthetix.io/contracts/SynthetixBridgeToOptimism
12 *
13 * Contract Dependencies: 
14 *	- BaseSynthetixBridge
15 *	- IAddressResolver
16 *	- IBaseSynthetixBridge
17 *	- ISynthetixBridgeToOptimism
18 *	- MixinResolver
19 *	- MixinSystemSettings
20 *	- Owned
21 *	- iOVM_L1TokenGateway
22 * Libraries: 
23 *	- Address
24 *	- Math
25 *	- SafeDecimalMath
26 *	- SafeERC20
27 *	- SafeMath
28 *	- VestingEntries
29 *
30 * MIT License
31 * ===========
32 *
33 * Copyright (c) 2022 Synthetix
34 *
35 * Permission is hereby granted, free of charge, to any person obtaining a copy
36 * of this software and associated documentation files (the "Software"), to deal
37 * in the Software without restriction, including without limitation the rights
38 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
39 * copies of the Software, and to permit persons to whom the Software is
40 * furnished to do so, subject to the following conditions:
41 *
42 * The above copyright notice and this permission notice shall be included in all
43 * copies or substantial portions of the Software.
44 *
45 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
46 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
47 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
48 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
49 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
50 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
51 */
52 
53 
54 
55 pragma solidity ^0.5.16;
56 
57 // https://docs.synthetix.io/contracts/source/contracts/owned
58 contract Owned {
59     address public owner;
60     address public nominatedOwner;
61 
62     constructor(address _owner) public {
63         require(_owner != address(0), "Owner address cannot be 0");
64         owner = _owner;
65         emit OwnerChanged(address(0), _owner);
66     }
67 
68     function nominateNewOwner(address _owner) external onlyOwner {
69         nominatedOwner = _owner;
70         emit OwnerNominated(_owner);
71     }
72 
73     function acceptOwnership() external {
74         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
75         emit OwnerChanged(owner, nominatedOwner);
76         owner = nominatedOwner;
77         nominatedOwner = address(0);
78     }
79 
80     modifier onlyOwner {
81         _onlyOwner();
82         _;
83     }
84 
85     function _onlyOwner() private view {
86         require(msg.sender == owner, "Only the contract owner may perform this action");
87     }
88 
89     event OwnerNominated(address newOwner);
90     event OwnerChanged(address oldOwner, address newOwner);
91 }
92 
93 
94 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
95 interface IAddressResolver {
96     function getAddress(bytes32 name) external view returns (address);
97 
98     function getSynth(bytes32 key) external view returns (address);
99 
100     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
101 }
102 
103 
104 // https://docs.synthetix.io/contracts/source/interfaces/isynth
105 interface ISynth {
106     // Views
107     function currencyKey() external view returns (bytes32);
108 
109     function transferableSynths(address account) external view returns (uint);
110 
111     // Mutative functions
112     function transferAndSettle(address to, uint value) external returns (bool);
113 
114     function transferFromAndSettle(
115         address from,
116         address to,
117         uint value
118     ) external returns (bool);
119 
120     // Restricted: used internally to Synthetix
121     function burn(address account, uint amount) external;
122 
123     function issue(address account, uint amount) external;
124 }
125 
126 
127 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
128 interface IIssuer {
129     // Views
130     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
131 
132     function availableCurrencyKeys() external view returns (bytes32[] memory);
133 
134     function availableSynthCount() external view returns (uint);
135 
136     function availableSynths(uint index) external view returns (ISynth);
137 
138     function canBurnSynths(address account) external view returns (bool);
139 
140     function collateral(address account) external view returns (uint);
141 
142     function collateralisationRatio(address issuer) external view returns (uint);
143 
144     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
145         external
146         view
147         returns (uint cratio, bool anyRateIsInvalid);
148 
149     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
150 
151     function issuanceRatio() external view returns (uint);
152 
153     function lastIssueEvent(address account) external view returns (uint);
154 
155     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
156 
157     function minimumStakeTime() external view returns (uint);
158 
159     function remainingIssuableSynths(address issuer)
160         external
161         view
162         returns (
163             uint maxIssuable,
164             uint alreadyIssued,
165             uint totalSystemDebt
166         );
167 
168     function synths(bytes32 currencyKey) external view returns (ISynth);
169 
170     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
171 
172     function synthsByAddress(address synthAddress) external view returns (bytes32);
173 
174     function totalIssuedSynths(bytes32 currencyKey, bool excludeOtherCollateral) external view returns (uint);
175 
176     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
177         external
178         view
179         returns (uint transferable, bool anyRateIsInvalid);
180 
181     // Restricted: used internally to Synthetix
182     function issueSynths(address from, uint amount) external;
183 
184     function issueSynthsOnBehalf(
185         address issueFor,
186         address from,
187         uint amount
188     ) external;
189 
190     function issueMaxSynths(address from) external;
191 
192     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
193 
194     function burnSynths(address from, uint amount) external;
195 
196     function burnSynthsOnBehalf(
197         address burnForAddress,
198         address from,
199         uint amount
200     ) external;
201 
202     function burnSynthsToTarget(address from) external;
203 
204     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
205 
206     function burnForRedemption(
207         address deprecatedSynthProxy,
208         address account,
209         uint balance
210     ) external;
211 
212     function liquidateDelinquentAccount(
213         address account,
214         uint susdAmount,
215         address liquidator
216     ) external returns (uint totalRedeemed, uint amountToLiquidate);
217 
218     function setCurrentPeriodId(uint128 periodId) external;
219 
220     function issueSynthsWithoutDebt(
221         bytes32 currencyKey,
222         address to,
223         uint amount
224     ) external returns (bool rateInvalid);
225 
226     function burnSynthsWithoutDebt(
227         bytes32 currencyKey,
228         address to,
229         uint amount
230     ) external returns (bool rateInvalid);
231 }
232 
233 
234 // Inheritance
235 
236 
237 // Internal references
238 
239 
240 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
241 contract AddressResolver is Owned, IAddressResolver {
242     mapping(bytes32 => address) public repository;
243 
244     constructor(address _owner) public Owned(_owner) {}
245 
246     /* ========== RESTRICTED FUNCTIONS ========== */
247 
248     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
249         require(names.length == destinations.length, "Input lengths must match");
250 
251         for (uint i = 0; i < names.length; i++) {
252             bytes32 name = names[i];
253             address destination = destinations[i];
254             repository[name] = destination;
255             emit AddressImported(name, destination);
256         }
257     }
258 
259     /* ========= PUBLIC FUNCTIONS ========== */
260 
261     function rebuildCaches(MixinResolver[] calldata destinations) external {
262         for (uint i = 0; i < destinations.length; i++) {
263             destinations[i].rebuildCache();
264         }
265     }
266 
267     /* ========== VIEWS ========== */
268 
269     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
270         for (uint i = 0; i < names.length; i++) {
271             if (repository[names[i]] != destinations[i]) {
272                 return false;
273             }
274         }
275         return true;
276     }
277 
278     function getAddress(bytes32 name) external view returns (address) {
279         return repository[name];
280     }
281 
282     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
283         address _foundAddress = repository[name];
284         require(_foundAddress != address(0), reason);
285         return _foundAddress;
286     }
287 
288     function getSynth(bytes32 key) external view returns (address) {
289         IIssuer issuer = IIssuer(repository["Issuer"]);
290         require(address(issuer) != address(0), "Cannot find Issuer address");
291         return address(issuer.synths(key));
292     }
293 
294     /* ========== EVENTS ========== */
295 
296     event AddressImported(bytes32 name, address destination);
297 }
298 
299 
300 // Internal references
301 
302 
303 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
304 contract MixinResolver {
305     AddressResolver public resolver;
306 
307     mapping(bytes32 => address) private addressCache;
308 
309     constructor(address _resolver) internal {
310         resolver = AddressResolver(_resolver);
311     }
312 
313     /* ========== INTERNAL FUNCTIONS ========== */
314 
315     function combineArrays(bytes32[] memory first, bytes32[] memory second)
316         internal
317         pure
318         returns (bytes32[] memory combination)
319     {
320         combination = new bytes32[](first.length + second.length);
321 
322         for (uint i = 0; i < first.length; i++) {
323             combination[i] = first[i];
324         }
325 
326         for (uint j = 0; j < second.length; j++) {
327             combination[first.length + j] = second[j];
328         }
329     }
330 
331     /* ========== PUBLIC FUNCTIONS ========== */
332 
333     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
334     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
335 
336     function rebuildCache() public {
337         bytes32[] memory requiredAddresses = resolverAddressesRequired();
338         // The resolver must call this function whenver it updates its state
339         for (uint i = 0; i < requiredAddresses.length; i++) {
340             bytes32 name = requiredAddresses[i];
341             // Note: can only be invoked once the resolver has all the targets needed added
342             address destination =
343                 resolver.requireAndGetAddress(name, string(abi.encodePacked("Resolver missing target: ", name)));
344             addressCache[name] = destination;
345             emit CacheUpdated(name, destination);
346         }
347     }
348 
349     /* ========== VIEWS ========== */
350 
351     function isResolverCached() external view returns (bool) {
352         bytes32[] memory requiredAddresses = resolverAddressesRequired();
353         for (uint i = 0; i < requiredAddresses.length; i++) {
354             bytes32 name = requiredAddresses[i];
355             // false if our cache is invalid or if the resolver doesn't have the required address
356             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
357                 return false;
358             }
359         }
360 
361         return true;
362     }
363 
364     /* ========== INTERNAL FUNCTIONS ========== */
365 
366     function requireAndGetAddress(bytes32 name) internal view returns (address) {
367         address _foundAddress = addressCache[name];
368         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
369         return _foundAddress;
370     }
371 
372     /* ========== EVENTS ========== */
373 
374     event CacheUpdated(bytes32 name, address destination);
375 }
376 
377 
378 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
379 interface IFlexibleStorage {
380     // Views
381     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
382 
383     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
384 
385     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
386 
387     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
388 
389     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
390 
391     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
392 
393     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
394 
395     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
396 
397     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
398 
399     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
400 
401     // Mutative functions
402     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
403 
404     function deleteIntValue(bytes32 contractName, bytes32 record) external;
405 
406     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
407 
408     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
409 
410     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
411 
412     function setUIntValue(
413         bytes32 contractName,
414         bytes32 record,
415         uint value
416     ) external;
417 
418     function setUIntValues(
419         bytes32 contractName,
420         bytes32[] calldata records,
421         uint[] calldata values
422     ) external;
423 
424     function setIntValue(
425         bytes32 contractName,
426         bytes32 record,
427         int value
428     ) external;
429 
430     function setIntValues(
431         bytes32 contractName,
432         bytes32[] calldata records,
433         int[] calldata values
434     ) external;
435 
436     function setAddressValue(
437         bytes32 contractName,
438         bytes32 record,
439         address value
440     ) external;
441 
442     function setAddressValues(
443         bytes32 contractName,
444         bytes32[] calldata records,
445         address[] calldata values
446     ) external;
447 
448     function setBoolValue(
449         bytes32 contractName,
450         bytes32 record,
451         bool value
452     ) external;
453 
454     function setBoolValues(
455         bytes32 contractName,
456         bytes32[] calldata records,
457         bool[] calldata values
458     ) external;
459 
460     function setBytes32Value(
461         bytes32 contractName,
462         bytes32 record,
463         bytes32 value
464     ) external;
465 
466     function setBytes32Values(
467         bytes32 contractName,
468         bytes32[] calldata records,
469         bytes32[] calldata values
470     ) external;
471 }
472 
473 
474 // Internal references
475 
476 
477 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
478 contract MixinSystemSettings is MixinResolver {
479     // must match the one defined SystemSettingsLib, defined in both places due to sol v0.5 limitations
480     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
481 
482     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
483     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
484     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
485     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
486     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
487     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
488     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
489     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
490     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
491     /* ========== Exchange Fees Related ========== */
492     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
493     bytes32 internal constant SETTING_EXCHANGE_DYNAMIC_FEE_THRESHOLD = "exchangeDynamicFeeThreshold";
494     bytes32 internal constant SETTING_EXCHANGE_DYNAMIC_FEE_WEIGHT_DECAY = "exchangeDynamicFeeWeightDecay";
495     bytes32 internal constant SETTING_EXCHANGE_DYNAMIC_FEE_ROUNDS = "exchangeDynamicFeeRounds";
496     bytes32 internal constant SETTING_EXCHANGE_MAX_DYNAMIC_FEE = "exchangeMaxDynamicFee";
497     /* ========== End Exchange Fees Related ========== */
498     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
499     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
500     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
501     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
502     bytes32 internal constant SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT = "crossDomainDepositGasLimit";
503     bytes32 internal constant SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT = "crossDomainEscrowGasLimit";
504     bytes32 internal constant SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT = "crossDomainRewardGasLimit";
505     bytes32 internal constant SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT = "crossDomainWithdrawalGasLimit";
506     bytes32 internal constant SETTING_CROSS_DOMAIN_FEE_PERIOD_CLOSE_GAS_LIMIT = "crossDomainCloseGasLimit";
507     bytes32 internal constant SETTING_CROSS_DOMAIN_RELAY_GAS_LIMIT = "crossDomainRelayGasLimit";
508     bytes32 internal constant SETTING_ETHER_WRAPPER_MAX_ETH = "etherWrapperMaxETH";
509     bytes32 internal constant SETTING_ETHER_WRAPPER_MINT_FEE_RATE = "etherWrapperMintFeeRate";
510     bytes32 internal constant SETTING_ETHER_WRAPPER_BURN_FEE_RATE = "etherWrapperBurnFeeRate";
511     bytes32 internal constant SETTING_WRAPPER_MAX_TOKEN_AMOUNT = "wrapperMaxTokens";
512     bytes32 internal constant SETTING_WRAPPER_MINT_FEE_RATE = "wrapperMintFeeRate";
513     bytes32 internal constant SETTING_WRAPPER_BURN_FEE_RATE = "wrapperBurnFeeRate";
514     bytes32 internal constant SETTING_INTERACTION_DELAY = "interactionDelay";
515     bytes32 internal constant SETTING_COLLAPSE_FEE_RATE = "collapseFeeRate";
516     bytes32 internal constant SETTING_ATOMIC_MAX_VOLUME_PER_BLOCK = "atomicMaxVolumePerBlock";
517     bytes32 internal constant SETTING_ATOMIC_TWAP_WINDOW = "atomicTwapWindow";
518     bytes32 internal constant SETTING_ATOMIC_EQUIVALENT_FOR_DEX_PRICING = "atomicEquivalentForDexPricing";
519     bytes32 internal constant SETTING_ATOMIC_EXCHANGE_FEE_RATE = "atomicExchangeFeeRate";
520     bytes32 internal constant SETTING_ATOMIC_VOLATILITY_CONSIDERATION_WINDOW = "atomicVolConsiderationWindow";
521     bytes32 internal constant SETTING_ATOMIC_VOLATILITY_UPDATE_THRESHOLD = "atomicVolUpdateThreshold";
522     bytes32 internal constant SETTING_PURE_CHAINLINK_PRICE_FOR_ATOMIC_SWAPS_ENABLED = "pureChainlinkForAtomicsEnabled";
523     bytes32 internal constant SETTING_CROSS_SYNTH_TRANSFER_ENABLED = "crossChainSynthTransferEnabled";
524 
525     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
526 
527     enum CrossDomainMessageGasLimits {Deposit, Escrow, Reward, Withdrawal, CloseFeePeriod, Relay}
528 
529     struct DynamicFeeConfig {
530         uint threshold;
531         uint weightDecay;
532         uint rounds;
533         uint maxFee;
534     }
535 
536     constructor(address _resolver) internal MixinResolver(_resolver) {}
537 
538     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
539         addresses = new bytes32[](1);
540         addresses[0] = CONTRACT_FLEXIBLESTORAGE;
541     }
542 
543     function flexibleStorage() internal view returns (IFlexibleStorage) {
544         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
545     }
546 
547     function _getGasLimitSetting(CrossDomainMessageGasLimits gasLimitType) internal pure returns (bytes32) {
548         if (gasLimitType == CrossDomainMessageGasLimits.Deposit) {
549             return SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT;
550         } else if (gasLimitType == CrossDomainMessageGasLimits.Escrow) {
551             return SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT;
552         } else if (gasLimitType == CrossDomainMessageGasLimits.Reward) {
553             return SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT;
554         } else if (gasLimitType == CrossDomainMessageGasLimits.Withdrawal) {
555             return SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT;
556         } else if (gasLimitType == CrossDomainMessageGasLimits.Relay) {
557             return SETTING_CROSS_DOMAIN_RELAY_GAS_LIMIT;
558         } else if (gasLimitType == CrossDomainMessageGasLimits.CloseFeePeriod) {
559             return SETTING_CROSS_DOMAIN_FEE_PERIOD_CLOSE_GAS_LIMIT;
560         } else {
561             revert("Unknown gas limit type");
562         }
563     }
564 
565     function getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits gasLimitType) internal view returns (uint) {
566         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, _getGasLimitSetting(gasLimitType));
567     }
568 
569     function getTradingRewardsEnabled() internal view returns (bool) {
570         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
571     }
572 
573     function getWaitingPeriodSecs() internal view returns (uint) {
574         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
575     }
576 
577     function getPriceDeviationThresholdFactor() internal view returns (uint) {
578         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
579     }
580 
581     function getIssuanceRatio() internal view returns (uint) {
582         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
583         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
584     }
585 
586     function getFeePeriodDuration() internal view returns (uint) {
587         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
588         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
589     }
590 
591     function getTargetThreshold() internal view returns (uint) {
592         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
593         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
594     }
595 
596     function getLiquidationDelay() internal view returns (uint) {
597         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
598     }
599 
600     function getLiquidationRatio() internal view returns (uint) {
601         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
602     }
603 
604     function getLiquidationPenalty() internal view returns (uint) {
605         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
606     }
607 
608     function getRateStalePeriod() internal view returns (uint) {
609         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
610     }
611 
612     /* ========== Exchange Related Fees ========== */
613     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
614         return
615             flexibleStorage().getUIntValue(
616                 SETTING_CONTRACT_NAME,
617                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
618             );
619     }
620 
621     /// @notice Get exchange dynamic fee related keys
622     /// @return threshold, weight decay, rounds, and max fee
623     function getExchangeDynamicFeeConfig() internal view returns (DynamicFeeConfig memory) {
624         bytes32[] memory keys = new bytes32[](4);
625         keys[0] = SETTING_EXCHANGE_DYNAMIC_FEE_THRESHOLD;
626         keys[1] = SETTING_EXCHANGE_DYNAMIC_FEE_WEIGHT_DECAY;
627         keys[2] = SETTING_EXCHANGE_DYNAMIC_FEE_ROUNDS;
628         keys[3] = SETTING_EXCHANGE_MAX_DYNAMIC_FEE;
629         uint[] memory values = flexibleStorage().getUIntValues(SETTING_CONTRACT_NAME, keys);
630         return DynamicFeeConfig({threshold: values[0], weightDecay: values[1], rounds: values[2], maxFee: values[3]});
631     }
632 
633     /* ========== End Exchange Related Fees ========== */
634 
635     function getMinimumStakeTime() internal view returns (uint) {
636         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
637     }
638 
639     function getAggregatorWarningFlags() internal view returns (address) {
640         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
641     }
642 
643     function getDebtSnapshotStaleTime() internal view returns (uint) {
644         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
645     }
646 
647     function getEtherWrapperMaxETH() internal view returns (uint) {
648         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MAX_ETH);
649     }
650 
651     function getEtherWrapperMintFeeRate() internal view returns (uint) {
652         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MINT_FEE_RATE);
653     }
654 
655     function getEtherWrapperBurnFeeRate() internal view returns (uint) {
656         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_BURN_FEE_RATE);
657     }
658 
659     function getWrapperMaxTokenAmount(address wrapper) internal view returns (uint) {
660         return
661             flexibleStorage().getUIntValue(
662                 SETTING_CONTRACT_NAME,
663                 keccak256(abi.encodePacked(SETTING_WRAPPER_MAX_TOKEN_AMOUNT, wrapper))
664             );
665     }
666 
667     function getWrapperMintFeeRate(address wrapper) internal view returns (int) {
668         return
669             flexibleStorage().getIntValue(
670                 SETTING_CONTRACT_NAME,
671                 keccak256(abi.encodePacked(SETTING_WRAPPER_MINT_FEE_RATE, wrapper))
672             );
673     }
674 
675     function getWrapperBurnFeeRate(address wrapper) internal view returns (int) {
676         return
677             flexibleStorage().getIntValue(
678                 SETTING_CONTRACT_NAME,
679                 keccak256(abi.encodePacked(SETTING_WRAPPER_BURN_FEE_RATE, wrapper))
680             );
681     }
682 
683     function getInteractionDelay(address collateral) internal view returns (uint) {
684         return
685             flexibleStorage().getUIntValue(
686                 SETTING_CONTRACT_NAME,
687                 keccak256(abi.encodePacked(SETTING_INTERACTION_DELAY, collateral))
688             );
689     }
690 
691     function getCollapseFeeRate(address collateral) internal view returns (uint) {
692         return
693             flexibleStorage().getUIntValue(
694                 SETTING_CONTRACT_NAME,
695                 keccak256(abi.encodePacked(SETTING_COLLAPSE_FEE_RATE, collateral))
696             );
697     }
698 
699     function getAtomicMaxVolumePerBlock() internal view returns (uint) {
700         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ATOMIC_MAX_VOLUME_PER_BLOCK);
701     }
702 
703     function getAtomicTwapWindow() internal view returns (uint) {
704         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ATOMIC_TWAP_WINDOW);
705     }
706 
707     function getAtomicEquivalentForDexPricing(bytes32 currencyKey) internal view returns (address) {
708         return
709             flexibleStorage().getAddressValue(
710                 SETTING_CONTRACT_NAME,
711                 keccak256(abi.encodePacked(SETTING_ATOMIC_EQUIVALENT_FOR_DEX_PRICING, currencyKey))
712             );
713     }
714 
715     function getAtomicExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
716         return
717             flexibleStorage().getUIntValue(
718                 SETTING_CONTRACT_NAME,
719                 keccak256(abi.encodePacked(SETTING_ATOMIC_EXCHANGE_FEE_RATE, currencyKey))
720             );
721     }
722 
723     function getAtomicVolatilityConsiderationWindow(bytes32 currencyKey) internal view returns (uint) {
724         return
725             flexibleStorage().getUIntValue(
726                 SETTING_CONTRACT_NAME,
727                 keccak256(abi.encodePacked(SETTING_ATOMIC_VOLATILITY_CONSIDERATION_WINDOW, currencyKey))
728             );
729     }
730 
731     function getAtomicVolatilityUpdateThreshold(bytes32 currencyKey) internal view returns (uint) {
732         return
733             flexibleStorage().getUIntValue(
734                 SETTING_CONTRACT_NAME,
735                 keccak256(abi.encodePacked(SETTING_ATOMIC_VOLATILITY_UPDATE_THRESHOLD, currencyKey))
736             );
737     }
738 
739     function getPureChainlinkPriceForAtomicSwapsEnabled(bytes32 currencyKey) internal view returns (bool) {
740         return
741             flexibleStorage().getBoolValue(
742                 SETTING_CONTRACT_NAME,
743                 keccak256(abi.encodePacked(SETTING_PURE_CHAINLINK_PRICE_FOR_ATOMIC_SWAPS_ENABLED, currencyKey))
744             );
745     }
746 
747     function getCrossChainSynthTransferEnabled(bytes32 currencyKey) internal view returns (uint) {
748         return
749             flexibleStorage().getUIntValue(
750                 SETTING_CONTRACT_NAME,
751                 keccak256(abi.encodePacked(SETTING_CROSS_SYNTH_TRANSFER_ENABLED, currencyKey))
752             );
753     }
754 }
755 
756 
757 pragma experimental ABIEncoderV2;
758 
759 interface IBaseSynthetixBridge {
760     function suspendInitiation() external;
761 
762     function resumeInitiation() external;
763 }
764 
765 
766 /**
767  * @dev Wrappers over Solidity's arithmetic operations with added overflow
768  * checks.
769  *
770  * Arithmetic operations in Solidity wrap on overflow. This can easily result
771  * in bugs, because programmers usually assume that an overflow raises an
772  * error, which is the standard behavior in high level programming languages.
773  * `SafeMath` restores this intuition by reverting the transaction when an
774  * operation overflows.
775  *
776  * Using this library instead of the unchecked operations eliminates an entire
777  * class of bugs, so it's recommended to use it always.
778  */
779 library SafeMath {
780     /**
781      * @dev Returns the addition of two unsigned integers, reverting on
782      * overflow.
783      *
784      * Counterpart to Solidity's `+` operator.
785      *
786      * Requirements:
787      * - Addition cannot overflow.
788      */
789     function add(uint256 a, uint256 b) internal pure returns (uint256) {
790         uint256 c = a + b;
791         require(c >= a, "SafeMath: addition overflow");
792 
793         return c;
794     }
795 
796     /**
797      * @dev Returns the subtraction of two unsigned integers, reverting on
798      * overflow (when the result is negative).
799      *
800      * Counterpart to Solidity's `-` operator.
801      *
802      * Requirements:
803      * - Subtraction cannot overflow.
804      */
805     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
806         require(b <= a, "SafeMath: subtraction overflow");
807         uint256 c = a - b;
808 
809         return c;
810     }
811 
812     /**
813      * @dev Returns the multiplication of two unsigned integers, reverting on
814      * overflow.
815      *
816      * Counterpart to Solidity's `*` operator.
817      *
818      * Requirements:
819      * - Multiplication cannot overflow.
820      */
821     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
822         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
823         // benefit is lost if 'b' is also tested.
824         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
825         if (a == 0) {
826             return 0;
827         }
828 
829         uint256 c = a * b;
830         require(c / a == b, "SafeMath: multiplication overflow");
831 
832         return c;
833     }
834 
835     /**
836      * @dev Returns the integer division of two unsigned integers. Reverts on
837      * division by zero. The result is rounded towards zero.
838      *
839      * Counterpart to Solidity's `/` operator. Note: this function uses a
840      * `revert` opcode (which leaves remaining gas untouched) while Solidity
841      * uses an invalid opcode to revert (consuming all remaining gas).
842      *
843      * Requirements:
844      * - The divisor cannot be zero.
845      */
846     function div(uint256 a, uint256 b) internal pure returns (uint256) {
847         // Solidity only automatically asserts when dividing by 0
848         require(b > 0, "SafeMath: division by zero");
849         uint256 c = a / b;
850         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
851 
852         return c;
853     }
854 
855     /**
856      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
857      * Reverts when dividing by zero.
858      *
859      * Counterpart to Solidity's `%` operator. This function uses a `revert`
860      * opcode (which leaves remaining gas untouched) while Solidity uses an
861      * invalid opcode to revert (consuming all remaining gas).
862      *
863      * Requirements:
864      * - The divisor cannot be zero.
865      */
866     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
867         require(b != 0, "SafeMath: modulo by zero");
868         return a % b;
869     }
870 }
871 
872 
873 // Libraries
874 
875 
876 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
877 library SafeDecimalMath {
878     using SafeMath for uint;
879 
880     /* Number of decimal places in the representations. */
881     uint8 public constant decimals = 18;
882     uint8 public constant highPrecisionDecimals = 27;
883 
884     /* The number representing 1.0. */
885     uint public constant UNIT = 10**uint(decimals);
886 
887     /* The number representing 1.0 for higher fidelity numbers. */
888     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
889     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
890 
891     /**
892      * @return Provides an interface to UNIT.
893      */
894     function unit() external pure returns (uint) {
895         return UNIT;
896     }
897 
898     /**
899      * @return Provides an interface to PRECISE_UNIT.
900      */
901     function preciseUnit() external pure returns (uint) {
902         return PRECISE_UNIT;
903     }
904 
905     /**
906      * @return The result of multiplying x and y, interpreting the operands as fixed-point
907      * decimals.
908      *
909      * @dev A unit factor is divided out after the product of x and y is evaluated,
910      * so that product must be less than 2**256. As this is an integer division,
911      * the internal division always rounds down. This helps save on gas. Rounding
912      * is more expensive on gas.
913      */
914     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
915         /* Divide by UNIT to remove the extra factor introduced by the product. */
916         return x.mul(y) / UNIT;
917     }
918 
919     /**
920      * @return The result of safely multiplying x and y, interpreting the operands
921      * as fixed-point decimals of the specified precision unit.
922      *
923      * @dev The operands should be in the form of a the specified unit factor which will be
924      * divided out after the product of x and y is evaluated, so that product must be
925      * less than 2**256.
926      *
927      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
928      * Rounding is useful when you need to retain fidelity for small decimal numbers
929      * (eg. small fractions or percentages).
930      */
931     function _multiplyDecimalRound(
932         uint x,
933         uint y,
934         uint precisionUnit
935     ) private pure returns (uint) {
936         /* Divide by UNIT to remove the extra factor introduced by the product. */
937         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
938 
939         if (quotientTimesTen % 10 >= 5) {
940             quotientTimesTen += 10;
941         }
942 
943         return quotientTimesTen / 10;
944     }
945 
946     /**
947      * @return The result of safely multiplying x and y, interpreting the operands
948      * as fixed-point decimals of a precise unit.
949      *
950      * @dev The operands should be in the precise unit factor which will be
951      * divided out after the product of x and y is evaluated, so that product must be
952      * less than 2**256.
953      *
954      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
955      * Rounding is useful when you need to retain fidelity for small decimal numbers
956      * (eg. small fractions or percentages).
957      */
958     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
959         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
960     }
961 
962     /**
963      * @return The result of safely multiplying x and y, interpreting the operands
964      * as fixed-point decimals of a standard unit.
965      *
966      * @dev The operands should be in the standard unit factor which will be
967      * divided out after the product of x and y is evaluated, so that product must be
968      * less than 2**256.
969      *
970      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
971      * Rounding is useful when you need to retain fidelity for small decimal numbers
972      * (eg. small fractions or percentages).
973      */
974     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
975         return _multiplyDecimalRound(x, y, UNIT);
976     }
977 
978     /**
979      * @return The result of safely dividing x and y. The return value is a high
980      * precision decimal.
981      *
982      * @dev y is divided after the product of x and the standard precision unit
983      * is evaluated, so the product of x and UNIT must be less than 2**256. As
984      * this is an integer division, the result is always rounded down.
985      * This helps save on gas. Rounding is more expensive on gas.
986      */
987     function divideDecimal(uint x, uint y) internal pure returns (uint) {
988         /* Reintroduce the UNIT factor that will be divided out by y. */
989         return x.mul(UNIT).div(y);
990     }
991 
992     /**
993      * @return The result of safely dividing x and y. The return value is as a rounded
994      * decimal in the precision unit specified in the parameter.
995      *
996      * @dev y is divided after the product of x and the specified precision unit
997      * is evaluated, so the product of x and the specified precision unit must
998      * be less than 2**256. The result is rounded to the nearest increment.
999      */
1000     function _divideDecimalRound(
1001         uint x,
1002         uint y,
1003         uint precisionUnit
1004     ) private pure returns (uint) {
1005         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
1006 
1007         if (resultTimesTen % 10 >= 5) {
1008             resultTimesTen += 10;
1009         }
1010 
1011         return resultTimesTen / 10;
1012     }
1013 
1014     /**
1015      * @return The result of safely dividing x and y. The return value is as a rounded
1016      * standard precision decimal.
1017      *
1018      * @dev y is divided after the product of x and the standard precision unit
1019      * is evaluated, so the product of x and the standard precision unit must
1020      * be less than 2**256. The result is rounded to the nearest increment.
1021      */
1022     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
1023         return _divideDecimalRound(x, y, UNIT);
1024     }
1025 
1026     /**
1027      * @return The result of safely dividing x and y. The return value is as a rounded
1028      * high precision decimal.
1029      *
1030      * @dev y is divided after the product of x and the high precision unit
1031      * is evaluated, so the product of x and the high precision unit must
1032      * be less than 2**256. The result is rounded to the nearest increment.
1033      */
1034     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
1035         return _divideDecimalRound(x, y, PRECISE_UNIT);
1036     }
1037 
1038     /**
1039      * @dev Convert a standard decimal representation to a high precision one.
1040      */
1041     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
1042         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
1043     }
1044 
1045     /**
1046      * @dev Convert a high precision decimal to a standard decimal representation.
1047      */
1048     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
1049         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
1050 
1051         if (quotientTimesTen % 10 >= 5) {
1052             quotientTimesTen += 10;
1053         }
1054 
1055         return quotientTimesTen / 10;
1056     }
1057 
1058     // Computes `a - b`, setting the value to 0 if b > a.
1059     function floorsub(uint a, uint b) internal pure returns (uint) {
1060         return b >= a ? 0 : a - b;
1061     }
1062 
1063     /* ---------- Utilities ---------- */
1064     /*
1065      * Absolute value of the input, returned as a signed number.
1066      */
1067     function signedAbs(int x) internal pure returns (int) {
1068         return x < 0 ? -x : x;
1069     }
1070 
1071     /*
1072      * Absolute value of the input, returned as an unsigned number.
1073      */
1074     function abs(int x) internal pure returns (uint) {
1075         return uint(signedAbs(x));
1076     }
1077 }
1078 
1079 
1080 // Libraries
1081 
1082 
1083 // https://docs.synthetix.io/contracts/source/libraries/math
1084 library Math {
1085     using SafeMath for uint;
1086     using SafeDecimalMath for uint;
1087 
1088     /**
1089      * @dev Uses "exponentiation by squaring" algorithm where cost is 0(logN)
1090      * vs 0(N) for naive repeated multiplication.
1091      * Calculates x^n with x as fixed-point and n as regular unsigned int.
1092      * Calculates to 18 digits of precision with SafeDecimalMath.unit()
1093      */
1094     function powDecimal(uint x, uint n) internal pure returns (uint) {
1095         // https://mpark.github.io/programming/2014/08/18/exponentiation-by-squaring/
1096 
1097         uint result = SafeDecimalMath.unit();
1098         while (n > 0) {
1099             if (n % 2 != 0) {
1100                 result = result.multiplyDecimal(x);
1101             }
1102             x = x.multiplyDecimal(x);
1103             n /= 2;
1104         }
1105         return result;
1106     }
1107 }
1108 
1109 
1110 interface IVirtualSynth {
1111     // Views
1112     function balanceOfUnderlying(address account) external view returns (uint);
1113 
1114     function rate() external view returns (uint);
1115 
1116     function readyToSettle() external view returns (bool);
1117 
1118     function secsLeftInWaitingPeriod() external view returns (uint);
1119 
1120     function settled() external view returns (bool);
1121 
1122     function synth() external view returns (ISynth);
1123 
1124     // Mutative functions
1125     function settle(address account) external;
1126 }
1127 
1128 
1129 // https://docs.synthetix.io/contracts/source/interfaces/isynthetix
1130 interface ISynthetix {
1131     // Views
1132     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
1133 
1134     function availableCurrencyKeys() external view returns (bytes32[] memory);
1135 
1136     function availableSynthCount() external view returns (uint);
1137 
1138     function availableSynths(uint index) external view returns (ISynth);
1139 
1140     function collateral(address account) external view returns (uint);
1141 
1142     function collateralisationRatio(address issuer) external view returns (uint);
1143 
1144     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
1145 
1146     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
1147 
1148     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
1149 
1150     function remainingIssuableSynths(address issuer)
1151         external
1152         view
1153         returns (
1154             uint maxIssuable,
1155             uint alreadyIssued,
1156             uint totalSystemDebt
1157         );
1158 
1159     function synths(bytes32 currencyKey) external view returns (ISynth);
1160 
1161     function synthsByAddress(address synthAddress) external view returns (bytes32);
1162 
1163     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
1164 
1165     function totalIssuedSynthsExcludeOtherCollateral(bytes32 currencyKey) external view returns (uint);
1166 
1167     function transferableSynthetix(address account) external view returns (uint transferable);
1168 
1169     // Mutative Functions
1170     function burnSynths(uint amount) external;
1171 
1172     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
1173 
1174     function burnSynthsToTarget() external;
1175 
1176     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
1177 
1178     function exchange(
1179         bytes32 sourceCurrencyKey,
1180         uint sourceAmount,
1181         bytes32 destinationCurrencyKey
1182     ) external returns (uint amountReceived);
1183 
1184     function exchangeOnBehalf(
1185         address exchangeForAddress,
1186         bytes32 sourceCurrencyKey,
1187         uint sourceAmount,
1188         bytes32 destinationCurrencyKey
1189     ) external returns (uint amountReceived);
1190 
1191     function exchangeWithTracking(
1192         bytes32 sourceCurrencyKey,
1193         uint sourceAmount,
1194         bytes32 destinationCurrencyKey,
1195         address rewardAddress,
1196         bytes32 trackingCode
1197     ) external returns (uint amountReceived);
1198 
1199     function exchangeWithTrackingForInitiator(
1200         bytes32 sourceCurrencyKey,
1201         uint sourceAmount,
1202         bytes32 destinationCurrencyKey,
1203         address rewardAddress,
1204         bytes32 trackingCode
1205     ) external returns (uint amountReceived);
1206 
1207     function exchangeOnBehalfWithTracking(
1208         address exchangeForAddress,
1209         bytes32 sourceCurrencyKey,
1210         uint sourceAmount,
1211         bytes32 destinationCurrencyKey,
1212         address rewardAddress,
1213         bytes32 trackingCode
1214     ) external returns (uint amountReceived);
1215 
1216     function exchangeWithVirtual(
1217         bytes32 sourceCurrencyKey,
1218         uint sourceAmount,
1219         bytes32 destinationCurrencyKey,
1220         bytes32 trackingCode
1221     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1222 
1223     function exchangeAtomically(
1224         bytes32 sourceCurrencyKey,
1225         uint sourceAmount,
1226         bytes32 destinationCurrencyKey,
1227         bytes32 trackingCode,
1228         uint minAmount
1229     ) external returns (uint amountReceived);
1230 
1231     function issueMaxSynths() external;
1232 
1233     function issueMaxSynthsOnBehalf(address issueForAddress) external;
1234 
1235     function issueSynths(uint amount) external;
1236 
1237     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
1238 
1239     function mint() external returns (bool);
1240 
1241     function settle(bytes32 currencyKey)
1242         external
1243         returns (
1244             uint reclaimed,
1245             uint refunded,
1246             uint numEntries
1247         );
1248 
1249     // Liquidations
1250     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
1251 
1252     // Restricted Functions
1253 
1254     function mintSecondary(address account, uint amount) external;
1255 
1256     function mintSecondaryRewards(uint amount) external;
1257 
1258     function burnSecondary(address account, uint amount) external;
1259 }
1260 
1261 
1262 library VestingEntries {
1263     struct VestingEntry {
1264         uint64 endTime;
1265         uint256 escrowAmount;
1266     }
1267     struct VestingEntryWithID {
1268         uint64 endTime;
1269         uint256 escrowAmount;
1270         uint256 entryID;
1271     }
1272 }
1273 
1274 interface IRewardEscrowV2 {
1275     // Views
1276     function balanceOf(address account) external view returns (uint);
1277 
1278     function numVestingEntries(address account) external view returns (uint);
1279 
1280     function totalEscrowedAccountBalance(address account) external view returns (uint);
1281 
1282     function totalVestedAccountBalance(address account) external view returns (uint);
1283 
1284     function getVestingQuantity(address account, uint256[] calldata entryIDs) external view returns (uint);
1285 
1286     function getVestingSchedules(
1287         address account,
1288         uint256 index,
1289         uint256 pageSize
1290     ) external view returns (VestingEntries.VestingEntryWithID[] memory);
1291 
1292     function getAccountVestingEntryIDs(
1293         address account,
1294         uint256 index,
1295         uint256 pageSize
1296     ) external view returns (uint256[] memory);
1297 
1298     function getVestingEntryClaimable(address account, uint256 entryID) external view returns (uint);
1299 
1300     function getVestingEntry(address account, uint256 entryID) external view returns (uint64, uint256);
1301 
1302     // Mutative functions
1303     function vest(uint256[] calldata entryIDs) external;
1304 
1305     function createEscrowEntry(
1306         address beneficiary,
1307         uint256 deposit,
1308         uint256 duration
1309     ) external;
1310 
1311     function appendVestingEntry(
1312         address account,
1313         uint256 quantity,
1314         uint256 duration
1315     ) external;
1316 
1317     function migrateVestingSchedule(address _addressToMigrate) external;
1318 
1319     function migrateAccountEscrowBalances(
1320         address[] calldata accounts,
1321         uint256[] calldata escrowBalances,
1322         uint256[] calldata vestedBalances
1323     ) external;
1324 
1325     // Account Merging
1326     function startMergingWindow() external;
1327 
1328     function mergeAccount(address accountToMerge, uint256[] calldata entryIDs) external;
1329 
1330     function nominateAccountToMerge(address account) external;
1331 
1332     function accountMergingIsOpen() external view returns (bool);
1333 
1334     // L2 Migration
1335     function importVestingEntries(
1336         address account,
1337         uint256 escrowedAmount,
1338         VestingEntries.VestingEntry[] calldata vestingEntries
1339     ) external;
1340 
1341     // Return amount of SNX transfered to SynthetixBridgeToOptimism deposit contract
1342     function burnForMigration(address account, uint256[] calldata entryIDs)
1343         external
1344         returns (uint256 escrowedAccountBalance, VestingEntries.VestingEntry[] memory vestingEntries);
1345 }
1346 
1347 
1348 // https://docs.synthetix.io/contracts/source/interfaces/ifeepool
1349 interface IFeePool {
1350     // Views
1351 
1352     // solhint-disable-next-line func-name-mixedcase
1353     function FEE_ADDRESS() external view returns (address);
1354 
1355     function feesAvailable(address account) external view returns (uint, uint);
1356 
1357     function feePeriodDuration() external view returns (uint);
1358 
1359     function isFeesClaimable(address account) external view returns (bool);
1360 
1361     function targetThreshold() external view returns (uint);
1362 
1363     function totalFeesAvailable() external view returns (uint);
1364 
1365     function totalRewardsAvailable() external view returns (uint);
1366 
1367     // Mutative Functions
1368     function claimFees() external returns (bool);
1369 
1370     function claimOnBehalf(address claimingForAddress) external returns (bool);
1371 
1372     function closeCurrentFeePeriod() external;
1373 
1374     function closeSecondary(uint snxBackedDebt, uint debtShareSupply) external;
1375 
1376     function recordFeePaid(uint sUSDAmount) external;
1377 
1378     function setRewardsToDistribute(uint amount) external;
1379 }
1380 
1381 
1382 // https://docs.synthetix.io/contracts/source/interfaces/iexchangerates
1383 interface IExchangeRates {
1384     // Structs
1385     struct RateAndUpdatedTime {
1386         uint216 rate;
1387         uint40 time;
1388     }
1389 
1390     // Views
1391     function aggregators(bytes32 currencyKey) external view returns (address);
1392 
1393     function aggregatorWarningFlags() external view returns (address);
1394 
1395     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1396 
1397     function anyRateIsInvalidAtRound(bytes32[] calldata currencyKeys, uint[] calldata roundIds) external view returns (bool);
1398 
1399     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1400 
1401     function effectiveValue(
1402         bytes32 sourceCurrencyKey,
1403         uint sourceAmount,
1404         bytes32 destinationCurrencyKey
1405     ) external view returns (uint value);
1406 
1407     function effectiveValueAndRates(
1408         bytes32 sourceCurrencyKey,
1409         uint sourceAmount,
1410         bytes32 destinationCurrencyKey
1411     )
1412         external
1413         view
1414         returns (
1415             uint value,
1416             uint sourceRate,
1417             uint destinationRate
1418         );
1419 
1420     function effectiveValueAndRatesAtRound(
1421         bytes32 sourceCurrencyKey,
1422         uint sourceAmount,
1423         bytes32 destinationCurrencyKey,
1424         uint roundIdForSrc,
1425         uint roundIdForDest
1426     )
1427         external
1428         view
1429         returns (
1430             uint value,
1431             uint sourceRate,
1432             uint destinationRate
1433         );
1434 
1435     function effectiveAtomicValueAndRates(
1436         bytes32 sourceCurrencyKey,
1437         uint sourceAmount,
1438         bytes32 destinationCurrencyKey
1439     )
1440         external
1441         view
1442         returns (
1443             uint value,
1444             uint systemValue,
1445             uint systemSourceRate,
1446             uint systemDestinationRate
1447         );
1448 
1449     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1450 
1451     function getLastRoundIdBeforeElapsedSecs(
1452         bytes32 currencyKey,
1453         uint startingRoundId,
1454         uint startingTimestamp,
1455         uint timediff
1456     ) external view returns (uint);
1457 
1458     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1459 
1460     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1461 
1462     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1463 
1464     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1465 
1466     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1467 
1468     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1469 
1470     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1471 
1472     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1473 
1474     function rateStalePeriod() external view returns (uint);
1475 
1476     function ratesAndUpdatedTimeForCurrencyLastNRounds(
1477         bytes32 currencyKey,
1478         uint numRounds,
1479         uint roundId
1480     ) external view returns (uint[] memory rates, uint[] memory times);
1481 
1482     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1483         external
1484         view
1485         returns (uint[] memory rates, bool anyRateInvalid);
1486 
1487     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1488 
1489     function synthTooVolatileForAtomicExchange(bytes32 currencyKey) external view returns (bool);
1490 }
1491 
1492 
1493 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1494 interface ISystemStatus {
1495     struct Status {
1496         bool canSuspend;
1497         bool canResume;
1498     }
1499 
1500     struct Suspension {
1501         bool suspended;
1502         // reason is an integer code,
1503         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1504         uint248 reason;
1505     }
1506 
1507     // Views
1508     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1509 
1510     function requireSystemActive() external view;
1511 
1512     function systemSuspended() external view returns (bool);
1513 
1514     function requireIssuanceActive() external view;
1515 
1516     function requireExchangeActive() external view;
1517 
1518     function requireFuturesActive() external view;
1519 
1520     function requireFuturesMarketActive(bytes32 marketKey) external view;
1521 
1522     function requireExchangeBetweenSynthsAllowed(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1523 
1524     function requireSynthActive(bytes32 currencyKey) external view;
1525 
1526     function synthSuspended(bytes32 currencyKey) external view returns (bool);
1527 
1528     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1529 
1530     function systemSuspension() external view returns (bool suspended, uint248 reason);
1531 
1532     function issuanceSuspension() external view returns (bool suspended, uint248 reason);
1533 
1534     function exchangeSuspension() external view returns (bool suspended, uint248 reason);
1535 
1536     function futuresSuspension() external view returns (bool suspended, uint248 reason);
1537 
1538     function synthExchangeSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1539 
1540     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1541 
1542     function futuresMarketSuspension(bytes32 marketKey) external view returns (bool suspended, uint248 reason);
1543 
1544     function getSynthExchangeSuspensions(bytes32[] calldata synths)
1545         external
1546         view
1547         returns (bool[] memory exchangeSuspensions, uint256[] memory reasons);
1548 
1549     function getSynthSuspensions(bytes32[] calldata synths)
1550         external
1551         view
1552         returns (bool[] memory suspensions, uint256[] memory reasons);
1553 
1554     function getFuturesMarketSuspensions(bytes32[] calldata marketKeys)
1555         external
1556         view
1557         returns (bool[] memory suspensions, uint256[] memory reasons);
1558 
1559     // Restricted functions
1560     function suspendIssuance(uint256 reason) external;
1561 
1562     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1563 
1564     function suspendFuturesMarket(bytes32 marketKey, uint256 reason) external;
1565 
1566     function updateAccessControl(
1567         bytes32 section,
1568         address account,
1569         bool canSuspend,
1570         bool canResume
1571     ) external;
1572 }
1573 
1574 
1575 // SPDX-License-Identifier: MIT
1576 
1577 
1578 /**
1579  * @title iAbs_BaseCrossDomainMessenger
1580  */
1581 interface iAbs_BaseCrossDomainMessenger {
1582 
1583     /**********
1584      * Events *
1585      **********/
1586 
1587     event SentMessage(bytes message);
1588     event RelayedMessage(bytes32 msgHash);
1589     event FailedRelayedMessage(bytes32 msgHash);
1590 
1591 
1592     /*************
1593      * Variables *
1594      *************/
1595 
1596     function xDomainMessageSender() external view returns (address);
1597 
1598 
1599     /********************
1600      * Public Functions *
1601      ********************/
1602 
1603     /**
1604      * Sends a cross domain message to the target messenger.
1605      * @param _target Target contract address.
1606      * @param _message Message to send to the target.
1607      * @param _gasLimit Gas limit for the provided message.
1608      */
1609     function sendMessage(
1610         address _target,
1611         bytes calldata _message,
1612         uint32 _gasLimit
1613     ) external;
1614 }
1615 
1616 
1617 // Inheritance
1618 
1619 
1620 // Libraries
1621 
1622 
1623 // Internal references
1624 
1625 
1626 contract BaseSynthetixBridge is Owned, MixinSystemSettings, IBaseSynthetixBridge {
1627     using SafeMath for uint;
1628     using SafeDecimalMath for uint;
1629 
1630     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1631     bytes32 private constant CONTRACT_EXT_MESSENGER = "ext:Messenger";
1632     bytes32 internal constant CONTRACT_SYNTHETIX = "Synthetix";
1633     bytes32 private constant CONTRACT_REWARDESCROW = "RewardEscrowV2";
1634     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1635     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1636     bytes32 private constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
1637     bytes32 private constant CONTRACT_EXCHANGERATES = "ExchangeRates";
1638     bytes32 private constant CONTRACT_SYSTEM_STATUS = "SystemStatus";
1639 
1640     // have to define this function like this here because contract name is required for FlexibleStorage
1641     function CONTRACT_NAME() public pure returns (bytes32);
1642 
1643     bool public initiationActive;
1644 
1645     bytes32 private constant SYNTH_TRANSFER_NAMESPACE = "SynthTransfer";
1646     bytes32 private constant SYNTH_TRANSFER_SENT = "Sent";
1647     bytes32 private constant SYNTH_TRANSFER_RECV = "Recv";
1648 
1649     // ========== CONSTRUCTOR ==========
1650 
1651     constructor(address _owner, address _resolver) public Owned(_owner) MixinSystemSettings(_resolver) {
1652         initiationActive = true;
1653     }
1654 
1655     // ========== INTERNALS ============
1656 
1657     function messenger() internal view returns (iAbs_BaseCrossDomainMessenger) {
1658         return iAbs_BaseCrossDomainMessenger(requireAndGetAddress(CONTRACT_EXT_MESSENGER));
1659     }
1660 
1661     function synthetix() internal view returns (ISynthetix) {
1662         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX));
1663     }
1664 
1665     function rewardEscrowV2() internal view returns (IRewardEscrowV2) {
1666         return IRewardEscrowV2(requireAndGetAddress(CONTRACT_REWARDESCROW));
1667     }
1668 
1669     function issuer() internal view returns (IIssuer) {
1670         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1671     }
1672 
1673     function feePool() internal view returns (IFeePool) {
1674         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL));
1675     }
1676 
1677     function flexibleStorage() internal view returns (IFlexibleStorage) {
1678         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
1679     }
1680 
1681     function exchangeRates() internal view returns (IExchangeRates) {
1682         return IExchangeRates(requireAndGetAddress(CONTRACT_EXCHANGERATES));
1683     }
1684 
1685     function systemStatus() internal view returns (ISystemStatus) {
1686         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEM_STATUS));
1687     }
1688 
1689     function initiatingActive() internal view {
1690         require(initiationActive, "Initiation deactivated");
1691     }
1692 
1693     function counterpart() internal view returns (address);
1694 
1695     function onlyAllowFromCounterpart() internal view {
1696         // ensure function only callable from the L2 bridge via messenger (aka relayer)
1697         iAbs_BaseCrossDomainMessenger _messenger = messenger();
1698         require(msg.sender == address(_messenger), "Only the relayer can call this");
1699         require(_messenger.xDomainMessageSender() == counterpart(), "Only a counterpart bridge can invoke");
1700     }
1701 
1702     /* ========== VIEWS ========== */
1703 
1704     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1705         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1706         bytes32[] memory newAddresses = new bytes32[](8);
1707         newAddresses[0] = CONTRACT_EXT_MESSENGER;
1708         newAddresses[1] = CONTRACT_SYNTHETIX;
1709         newAddresses[2] = CONTRACT_REWARDESCROW;
1710         newAddresses[3] = CONTRACT_ISSUER;
1711         newAddresses[4] = CONTRACT_FEEPOOL;
1712         newAddresses[5] = CONTRACT_FLEXIBLESTORAGE;
1713         newAddresses[6] = CONTRACT_EXCHANGERATES;
1714         newAddresses[7] = CONTRACT_SYSTEM_STATUS;
1715         addresses = combineArrays(existingAddresses, newAddresses);
1716     }
1717 
1718     function synthTransferSent() external view returns (uint) {
1719         return _sumTransferAmounts(SYNTH_TRANSFER_SENT);
1720     }
1721 
1722     function synthTransferReceived() external view returns (uint) {
1723         return _sumTransferAmounts(SYNTH_TRANSFER_RECV);
1724     }
1725 
1726     // ========== MODIFIERS ============
1727 
1728     modifier requireInitiationActive() {
1729         initiatingActive();
1730         _;
1731     }
1732 
1733     modifier onlyCounterpart() {
1734         onlyAllowFromCounterpart();
1735         _;
1736     }
1737 
1738     // ========= RESTRICTED FUNCTIONS ==============
1739 
1740     function suspendInitiation() external onlyOwner {
1741         require(initiationActive, "Initiation suspended");
1742         initiationActive = false;
1743         emit InitiationSuspended();
1744     }
1745 
1746     function resumeInitiation() external onlyOwner {
1747         require(!initiationActive, "Initiation not suspended");
1748         initiationActive = true;
1749         emit InitiationResumed();
1750     }
1751 
1752     function initiateSynthTransfer(
1753         bytes32 currencyKey,
1754         address destination,
1755         uint amount
1756     ) external requireInitiationActive {
1757         require(destination != address(0), "Cannot send to zero address");
1758         require(getCrossChainSynthTransferEnabled(currencyKey) > 0, "Synth not enabled for cross chain transfer");
1759         systemStatus().requireSynthActive(currencyKey);
1760 
1761         _incrementSynthsTransferCounter(SYNTH_TRANSFER_SENT, currencyKey, amount);
1762 
1763         bool rateInvalid = issuer().burnSynthsWithoutDebt(currencyKey, msg.sender, amount);
1764         require(!rateInvalid, "Cannot initiate if synth rate is invalid");
1765 
1766         // create message payload
1767         bytes memory messageData =
1768             abi.encodeWithSelector(this.finalizeSynthTransfer.selector, currencyKey, destination, amount);
1769 
1770         // relay the message to Bridge on L1 via L2 Messenger
1771         messenger().sendMessage(
1772             counterpart(),
1773             messageData,
1774             uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Withdrawal))
1775         );
1776 
1777         emit InitiateSynthTransfer(currencyKey, destination, amount);
1778     }
1779 
1780     function finalizeSynthTransfer(
1781         bytes32 currencyKey,
1782         address destination,
1783         uint amount
1784     ) external onlyCounterpart {
1785         _incrementSynthsTransferCounter(SYNTH_TRANSFER_RECV, currencyKey, amount);
1786 
1787         issuer().issueSynthsWithoutDebt(currencyKey, destination, amount);
1788 
1789         emit FinalizeSynthTransfer(currencyKey, destination, amount);
1790     }
1791 
1792     // ==== INTERNAL FUNCTIONS ====
1793 
1794     function _incrementSynthsTransferCounter(
1795         bytes32 group,
1796         bytes32 currencyKey,
1797         uint amount
1798     ) internal {
1799         bytes32 key = keccak256(abi.encodePacked(SYNTH_TRANSFER_NAMESPACE, group, currencyKey));
1800 
1801         uint currentSynths = flexibleStorage().getUIntValue(CONTRACT_NAME(), key);
1802 
1803         flexibleStorage().setUIntValue(CONTRACT_NAME(), key, currentSynths.add(amount));
1804     }
1805 
1806     function _sumTransferAmounts(bytes32 group) internal view returns (uint sum) {
1807         // get list of synths from issuer
1808         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
1809 
1810         // get all synth rates
1811         (uint[] memory rates, bool isInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1812 
1813         require(!isInvalid, "Rates are invalid");
1814 
1815         // get all values
1816         bytes32[] memory transferAmountKeys = new bytes32[](currencyKeys.length);
1817         for (uint i = 0; i < currencyKeys.length; i++) {
1818             transferAmountKeys[i] = keccak256(abi.encodePacked(SYNTH_TRANSFER_NAMESPACE, group, currencyKeys[i]));
1819         }
1820 
1821         uint[] memory transferAmounts = flexibleStorage().getUIntValues(CONTRACT_NAME(), transferAmountKeys);
1822 
1823         for (uint i = 0; i < currencyKeys.length; i++) {
1824             sum = sum.add(transferAmounts[i].multiplyDecimalRound(rates[i]));
1825         }
1826     }
1827 
1828     // ========== EVENTS ==========
1829 
1830     event InitiationSuspended();
1831 
1832     event InitiationResumed();
1833 
1834     event InitiateSynthTransfer(bytes32 indexed currencyKey, address indexed destination, uint256 amount);
1835     event FinalizeSynthTransfer(bytes32 indexed currencyKey, address indexed destination, uint256 amount);
1836 }
1837 
1838 
1839 interface ISynthetixBridgeToOptimism {
1840     function closeFeePeriod(uint snxBackedDebt, uint debtSharesSupply) external;
1841 
1842     function migrateEscrow(uint256[][] calldata entryIDs) external;
1843 
1844     function depositReward(uint amount) external;
1845 
1846     function depositAndMigrateEscrow(uint256 depositAmount, uint256[][] calldata entryIDs) external;
1847 }
1848 
1849 
1850 // SPDX-License-Identifier: MIT
1851 
1852 
1853 /**
1854  * @title iOVM_L1TokenGateway
1855  */
1856 interface iOVM_L1TokenGateway {
1857 
1858     /**********
1859      * Events *
1860      **********/
1861 
1862     event DepositInitiated(
1863         address indexed _from,
1864         address _to,
1865         uint256 _amount
1866     );
1867 
1868     event WithdrawalFinalized(
1869         address indexed _to,
1870         uint256 _amount
1871     );
1872 
1873 
1874     /********************
1875      * Public Functions *
1876      ********************/
1877 
1878     function deposit(
1879         uint _amount
1880     )
1881         external;
1882 
1883     function depositTo(
1884         address _to,
1885         uint _amount
1886     )
1887         external;
1888 
1889 
1890     /*************************
1891      * Cross-chain Functions *
1892      *************************/
1893 
1894     function finalizeWithdrawal(
1895         address _to,
1896         uint _amount
1897     )
1898         external;
1899 }
1900 
1901 
1902 /**
1903  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1904  * the optional functions; to access them see `ERC20Detailed`.
1905  */
1906 interface IERC20 {
1907     /**
1908      * @dev Returns the amount of tokens in existence.
1909      */
1910     function totalSupply() external view returns (uint256);
1911 
1912     /**
1913      * @dev Returns the amount of tokens owned by `account`.
1914      */
1915     function balanceOf(address account) external view returns (uint256);
1916 
1917     /**
1918      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1919      *
1920      * Returns a boolean value indicating whether the operation succeeded.
1921      *
1922      * Emits a `Transfer` event.
1923      */
1924     function transfer(address recipient, uint256 amount) external returns (bool);
1925 
1926     /**
1927      * @dev Returns the remaining number of tokens that `spender` will be
1928      * allowed to spend on behalf of `owner` through `transferFrom`. This is
1929      * zero by default.
1930      *
1931      * This value changes when `approve` or `transferFrom` are called.
1932      */
1933     function allowance(address owner, address spender) external view returns (uint256);
1934 
1935     /**
1936      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1937      *
1938      * Returns a boolean value indicating whether the operation succeeded.
1939      *
1940      * > Beware that changing an allowance with this method brings the risk
1941      * that someone may use both the old and the new allowance by unfortunate
1942      * transaction ordering. One possible solution to mitigate this race
1943      * condition is to first reduce the spender's allowance to 0 and set the
1944      * desired value afterwards:
1945      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1946      *
1947      * Emits an `Approval` event.
1948      */
1949     function approve(address spender, uint256 amount) external returns (bool);
1950 
1951     /**
1952      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1953      * allowance mechanism. `amount` is then deducted from the caller's
1954      * allowance.
1955      *
1956      * Returns a boolean value indicating whether the operation succeeded.
1957      *
1958      * Emits a `Transfer` event.
1959      */
1960     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1961 
1962     /**
1963      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1964      * another (`to`).
1965      *
1966      * Note that `value` may be zero.
1967      */
1968     event Transfer(address indexed from, address indexed to, uint256 value);
1969 
1970     /**
1971      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1972      * a call to `approve`. `value` is the new allowance.
1973      */
1974     event Approval(address indexed owner, address indexed spender, uint256 value);
1975 }
1976 
1977 
1978 /**
1979  * @dev Collection of functions related to the address type,
1980  */
1981 library Address {
1982     /**
1983      * @dev Returns true if `account` is a contract.
1984      *
1985      * This test is non-exhaustive, and there may be false-negatives: during the
1986      * execution of a contract's constructor, its address will be reported as
1987      * not containing a contract.
1988      *
1989      * > It is unsafe to assume that an address for which this function returns
1990      * false is an externally-owned account (EOA) and not a contract.
1991      */
1992     function isContract(address account) internal view returns (bool) {
1993         // This method relies in extcodesize, which returns 0 for contracts in
1994         // construction, since the code is only stored at the end of the
1995         // constructor execution.
1996 
1997         uint256 size;
1998         // solhint-disable-next-line no-inline-assembly
1999         assembly { size := extcodesize(account) }
2000         return size > 0;
2001     }
2002 }
2003 
2004 
2005 /**
2006  * @title SafeERC20
2007  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2008  * contract returns false). Tokens that return no value (and instead revert or
2009  * throw on failure) are also supported, non-reverting calls are assumed to be
2010  * successful.
2011  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
2012  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2013  */
2014 library SafeERC20 {
2015     using SafeMath for uint256;
2016     using Address for address;
2017 
2018     function safeTransfer(IERC20 token, address to, uint256 value) internal {
2019         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2020     }
2021 
2022     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
2023         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2024     }
2025 
2026     function safeApprove(IERC20 token, address spender, uint256 value) internal {
2027         // safeApprove should only be called when setting an initial allowance,
2028         // or when resetting it to zero. To increase and decrease it, use
2029         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2030         // solhint-disable-next-line max-line-length
2031         require((value == 0) || (token.allowance(address(this), spender) == 0),
2032             "SafeERC20: approve from non-zero to non-zero allowance"
2033         );
2034         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2035     }
2036 
2037     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2038         uint256 newAllowance = token.allowance(address(this), spender).add(value);
2039         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2040     }
2041 
2042     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2043         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
2044         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2045     }
2046 
2047     /**
2048      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2049      * on the return value: the return value is optional (but if data is returned, it must not be false).
2050      * @param token The token targeted by the call.
2051      * @param data The call data (encoded using abi.encode or one of its variants).
2052      */
2053     function callOptionalReturn(IERC20 token, bytes memory data) private {
2054         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2055         // we're implementing it ourselves.
2056 
2057         // A Solidity high level call has three parts:
2058         //  1. The target address is checked to verify it contains contract code
2059         //  2. The call itself is made, and success asserted
2060         //  3. The return value is decoded, which in turn checks the size of the returned data.
2061         // solhint-disable-next-line max-line-length
2062         require(address(token).isContract(), "SafeERC20: call to non-contract");
2063 
2064         // solhint-disable-next-line avoid-low-level-calls
2065         (bool success, bytes memory returndata) = address(token).call(data);
2066         require(success, "SafeERC20: low-level call failed");
2067 
2068         if (returndata.length > 0) { // Return data is optional
2069             // solhint-disable-next-line max-line-length
2070             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2071         }
2072     }
2073 }
2074 
2075 
2076 interface ISynthetixBridgeToBase {
2077     // invoked by the xDomain messenger on L2
2078     function finalizeEscrowMigration(
2079         address account,
2080         uint256 escrowedAmount,
2081         VestingEntries.VestingEntry[] calldata vestingEntries
2082     ) external;
2083 
2084     // invoked by the xDomain messenger on L2
2085     function finalizeRewardDeposit(address from, uint amount) external;
2086 
2087     function finalizeFeePeriodClose(uint snxBackedDebt, uint debtSharesSupply) external;
2088 }
2089 
2090 
2091 // SPDX-License-Identifier: MIT
2092 
2093 
2094 /**
2095  * @title iOVM_L2DepositedToken
2096  */
2097 interface iOVM_L2DepositedToken {
2098 
2099     /**********
2100      * Events *
2101      **********/
2102 
2103     event WithdrawalInitiated(
2104         address indexed _from,
2105         address _to,
2106         uint256 _amount
2107     );
2108 
2109     event DepositFinalized(
2110         address indexed _to,
2111         uint256 _amount
2112     );
2113 
2114 
2115     /********************
2116      * Public Functions *
2117      ********************/
2118 
2119     function withdraw(
2120         uint _amount
2121     )
2122         external;
2123 
2124     function withdrawTo(
2125         address _to,
2126         uint _amount
2127     )
2128         external;
2129 
2130 
2131     /*************************
2132      * Cross-chain Functions *
2133      *************************/
2134 
2135     function finalizeDeposit(
2136         address _to,
2137         uint _amount
2138     )
2139         external;
2140 }
2141 
2142 
2143 // Inheritance
2144 
2145 
2146 // Internal references
2147 
2148 
2149 contract SynthetixBridgeToOptimism is BaseSynthetixBridge, ISynthetixBridgeToOptimism, iOVM_L1TokenGateway {
2150     using SafeERC20 for IERC20;
2151 
2152     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
2153     bytes32 private constant CONTRACT_ISSUER = "Issuer";
2154     bytes32 private constant CONTRACT_REWARDSDISTRIBUTION = "RewardsDistribution";
2155     bytes32 private constant CONTRACT_OVM_SYNTHETIXBRIDGETOBASE = "ovm:SynthetixBridgeToBase";
2156     bytes32 private constant CONTRACT_SYNTHETIXBRIDGEESCROW = "SynthetixBridgeEscrow";
2157 
2158     uint8 private constant MAX_ENTRIES_MIGRATED_PER_MESSAGE = 26;
2159 
2160     function CONTRACT_NAME() public pure returns (bytes32) {
2161         return "SynthetixBridgeToOptimism";
2162     }
2163 
2164     // ========== CONSTRUCTOR ==========
2165 
2166     constructor(address _owner, address _resolver) public BaseSynthetixBridge(_owner, _resolver) {}
2167 
2168     // ========== INTERNALS ============
2169 
2170     function synthetixERC20() internal view returns (IERC20) {
2171         return IERC20(requireAndGetAddress(CONTRACT_SYNTHETIX));
2172     }
2173 
2174     function issuer() internal view returns (IIssuer) {
2175         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
2176     }
2177 
2178     function rewardsDistribution() internal view returns (address) {
2179         return requireAndGetAddress(CONTRACT_REWARDSDISTRIBUTION);
2180     }
2181 
2182     function synthetixBridgeToBase() internal view returns (address) {
2183         return requireAndGetAddress(CONTRACT_OVM_SYNTHETIXBRIDGETOBASE);
2184     }
2185 
2186     function synthetixBridgeEscrow() internal view returns (address) {
2187         return requireAndGetAddress(CONTRACT_SYNTHETIXBRIDGEESCROW);
2188     }
2189 
2190     function hasZeroDebt() internal view {
2191         require(issuer().debtBalanceOf(msg.sender, "sUSD") == 0, "Cannot deposit or migrate with debt");
2192     }
2193 
2194     function counterpart() internal view returns (address) {
2195         return synthetixBridgeToBase();
2196     }
2197 
2198     /* ========== VIEWS ========== */
2199 
2200     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
2201         bytes32[] memory existingAddresses = BaseSynthetixBridge.resolverAddressesRequired();
2202         bytes32[] memory newAddresses = new bytes32[](4);
2203         newAddresses[0] = CONTRACT_ISSUER;
2204         newAddresses[1] = CONTRACT_REWARDSDISTRIBUTION;
2205         newAddresses[2] = CONTRACT_OVM_SYNTHETIXBRIDGETOBASE;
2206         newAddresses[3] = CONTRACT_SYNTHETIXBRIDGEESCROW;
2207         addresses = combineArrays(existingAddresses, newAddresses);
2208     }
2209 
2210     // ========== MODIFIERS ============
2211 
2212     modifier requireZeroDebt() {
2213         hasZeroDebt();
2214         _;
2215     }
2216 
2217     // ========== PUBLIC FUNCTIONS =========
2218 
2219     function deposit(uint256 amount) external requireInitiationActive requireZeroDebt {
2220         _initiateDeposit(msg.sender, amount);
2221     }
2222 
2223     function depositTo(address to, uint amount) external requireInitiationActive requireZeroDebt {
2224         _initiateDeposit(to, amount);
2225     }
2226 
2227     function migrateEscrow(uint256[][] memory entryIDs) public requireInitiationActive requireZeroDebt {
2228         _migrateEscrow(entryIDs);
2229     }
2230 
2231     // invoked by a generous user on L1
2232     function depositReward(uint amount) external requireInitiationActive {
2233         // move the SNX into the deposit escrow
2234         synthetixERC20().transferFrom(msg.sender, synthetixBridgeEscrow(), amount);
2235 
2236         _depositReward(msg.sender, amount);
2237     }
2238 
2239     // forward any accidental tokens sent here to the escrow
2240     function forwardTokensToEscrow(address token) external {
2241         IERC20 erc20 = IERC20(token);
2242         erc20.safeTransfer(synthetixBridgeEscrow(), erc20.balanceOf(address(this)));
2243     }
2244 
2245     // ========= RESTRICTED FUNCTIONS ==============
2246 
2247     function closeFeePeriod(uint snxBackedAmount, uint totalDebtShares) external requireInitiationActive {
2248         require(msg.sender == address(feePool()), "Only the fee pool can call this");
2249 
2250         ISynthetixBridgeToBase bridgeToBase;
2251         bytes memory messageData =
2252             abi.encodeWithSelector(bridgeToBase.finalizeFeePeriodClose.selector, snxBackedAmount, totalDebtShares);
2253 
2254         // relay the message to this contract on L2 via L1 Messenger
2255         messenger().sendMessage(
2256             synthetixBridgeToBase(),
2257             messageData,
2258             uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.CloseFeePeriod))
2259         );
2260 
2261         emit FeePeriodClosed(snxBackedAmount, totalDebtShares);
2262     }
2263 
2264     // invoked by Messenger on L1 after L2 waiting period elapses
2265     function finalizeWithdrawal(address to, uint256 amount) external onlyCounterpart {
2266         // transfer amount back to user
2267         synthetixERC20().transferFrom(synthetixBridgeEscrow(), to, amount);
2268 
2269         // no escrow actions - escrow remains on L2
2270         emit iOVM_L1TokenGateway.WithdrawalFinalized(to, amount);
2271     }
2272 
2273     // invoked by RewardsDistribution on L1 (takes SNX)
2274     function notifyRewardAmount(uint256 amount) external {
2275         require(msg.sender == address(rewardsDistribution()), "Caller is not RewardsDistribution contract");
2276 
2277         // NOTE: transfer SNX to synthetixBridgeEscrow because RewardsDistribution transfers them initially to this contract.
2278         synthetixERC20().transfer(synthetixBridgeEscrow(), amount);
2279 
2280         // to be here means I've been given an amount of SNX to distribute onto L2
2281         _depositReward(msg.sender, amount);
2282     }
2283 
2284     function depositAndMigrateEscrow(uint256 depositAmount, uint256[][] memory entryIDs)
2285         public
2286         requireInitiationActive
2287         requireZeroDebt
2288     {
2289         if (entryIDs.length > 0) {
2290             _migrateEscrow(entryIDs);
2291         }
2292 
2293         if (depositAmount > 0) {
2294             _initiateDeposit(msg.sender, depositAmount);
2295         }
2296     }
2297 
2298     // ========== PRIVATE/INTERNAL FUNCTIONS =========
2299 
2300     function _depositReward(address _from, uint256 _amount) internal {
2301         // create message payload for L2
2302         ISynthetixBridgeToBase bridgeToBase;
2303         bytes memory messageData = abi.encodeWithSelector(bridgeToBase.finalizeRewardDeposit.selector, _from, _amount);
2304 
2305         // relay the message to this contract on L2 via L1 Messenger
2306         messenger().sendMessage(
2307             synthetixBridgeToBase(),
2308             messageData,
2309             uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Reward))
2310         );
2311 
2312         emit RewardDepositInitiated(_from, _amount);
2313     }
2314 
2315     function _initiateDeposit(address _to, uint256 _depositAmount) private {
2316         // Transfer SNX to L2
2317         // First, move the SNX into the deposit escrow
2318         synthetixERC20().transferFrom(msg.sender, synthetixBridgeEscrow(), _depositAmount);
2319         // create message payload for L2
2320         iOVM_L2DepositedToken bridgeToBase;
2321         bytes memory messageData = abi.encodeWithSelector(bridgeToBase.finalizeDeposit.selector, _to, _depositAmount);
2322 
2323         // relay the message to this contract on L2 via L1 Messenger
2324         messenger().sendMessage(
2325             synthetixBridgeToBase(),
2326             messageData,
2327             uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Deposit))
2328         );
2329 
2330         emit iOVM_L1TokenGateway.DepositInitiated(msg.sender, _to, _depositAmount);
2331     }
2332 
2333     function _migrateEscrow(uint256[][] memory _entryIDs) private {
2334         // loop through the entryID array
2335         for (uint256 i = 0; i < _entryIDs.length; i++) {
2336             // Cannot send more than MAX_ENTRIES_MIGRATED_PER_MESSAGE entries due to ovm gas restrictions
2337             require(_entryIDs[i].length <= MAX_ENTRIES_MIGRATED_PER_MESSAGE, "Exceeds max entries per migration");
2338             // Burn their reward escrow first
2339             // Note: escrowSummary would lose the fidelity of the weekly escrows, so this may not be sufficient
2340             uint256 escrowedAccountBalance;
2341             VestingEntries.VestingEntry[] memory vestingEntries;
2342             (escrowedAccountBalance, vestingEntries) = rewardEscrowV2().burnForMigration(msg.sender, _entryIDs[i]);
2343 
2344             // if there is an escrow amount to be migrated
2345             if (escrowedAccountBalance > 0) {
2346                 // NOTE: transfer SNX to synthetixBridgeEscrow because burnForMigration() transfers them to this contract.
2347                 synthetixERC20().transfer(synthetixBridgeEscrow(), escrowedAccountBalance);
2348                 // create message payload for L2
2349                 ISynthetixBridgeToBase bridgeToBase;
2350                 bytes memory messageData =
2351                     abi.encodeWithSelector(
2352                         bridgeToBase.finalizeEscrowMigration.selector,
2353                         msg.sender,
2354                         escrowedAccountBalance,
2355                         vestingEntries
2356                     );
2357                 // relay the message to this contract on L2 via L1 Messenger
2358                 messenger().sendMessage(
2359                     synthetixBridgeToBase(),
2360                     messageData,
2361                     uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Escrow))
2362                 );
2363 
2364                 emit ExportedVestingEntries(msg.sender, escrowedAccountBalance, vestingEntries);
2365             }
2366         }
2367     }
2368 
2369     // ========== EVENTS ==========
2370 
2371     event ExportedVestingEntries(
2372         address indexed account,
2373         uint256 escrowedAccountBalance,
2374         VestingEntries.VestingEntry[] vestingEntries
2375     );
2376 
2377     event RewardDepositInitiated(address indexed account, uint256 amount);
2378 
2379     event FeePeriodClosed(uint snxBackedDebt, uint totalDebtShares);
2380 }
2381 
2382     