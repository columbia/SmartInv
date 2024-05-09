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
24 *	- SafeERC20
25 *	- SafeMath
26 *	- VestingEntries
27 *
28 * MIT License
29 * ===========
30 *
31 * Copyright (c) 2022 Synthetix
32 *
33 * Permission is hereby granted, free of charge, to any person obtaining a copy
34 * of this software and associated documentation files (the "Software"), to deal
35 * in the Software without restriction, including without limitation the rights
36 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
37 * copies of the Software, and to permit persons to whom the Software is
38 * furnished to do so, subject to the following conditions:
39 *
40 * The above copyright notice and this permission notice shall be included in all
41 * copies or substantial portions of the Software.
42 *
43 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
44 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
45 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
46 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
47 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
48 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
49 */
50 
51 
52 
53 pragma solidity ^0.5.16;
54 
55 // https://docs.synthetix.io/contracts/source/contracts/owned
56 contract Owned {
57     address public owner;
58     address public nominatedOwner;
59 
60     constructor(address _owner) public {
61         require(_owner != address(0), "Owner address cannot be 0");
62         owner = _owner;
63         emit OwnerChanged(address(0), _owner);
64     }
65 
66     function nominateNewOwner(address _owner) external onlyOwner {
67         nominatedOwner = _owner;
68         emit OwnerNominated(_owner);
69     }
70 
71     function acceptOwnership() external {
72         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
73         emit OwnerChanged(owner, nominatedOwner);
74         owner = nominatedOwner;
75         nominatedOwner = address(0);
76     }
77 
78     modifier onlyOwner {
79         _onlyOwner();
80         _;
81     }
82 
83     function _onlyOwner() private view {
84         require(msg.sender == owner, "Only the contract owner may perform this action");
85     }
86 
87     event OwnerNominated(address newOwner);
88     event OwnerChanged(address oldOwner, address newOwner);
89 }
90 
91 
92 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
93 interface IAddressResolver {
94     function getAddress(bytes32 name) external view returns (address);
95 
96     function getSynth(bytes32 key) external view returns (address);
97 
98     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
99 }
100 
101 
102 // https://docs.synthetix.io/contracts/source/interfaces/isynth
103 interface ISynth {
104     // Views
105     function currencyKey() external view returns (bytes32);
106 
107     function transferableSynths(address account) external view returns (uint);
108 
109     // Mutative functions
110     function transferAndSettle(address to, uint value) external returns (bool);
111 
112     function transferFromAndSettle(
113         address from,
114         address to,
115         uint value
116     ) external returns (bool);
117 
118     // Restricted: used internally to Synthetix
119     function burn(address account, uint amount) external;
120 
121     function issue(address account, uint amount) external;
122 }
123 
124 
125 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
126 interface IIssuer {
127     // Views
128     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
129 
130     function availableCurrencyKeys() external view returns (bytes32[] memory);
131 
132     function availableSynthCount() external view returns (uint);
133 
134     function availableSynths(uint index) external view returns (ISynth);
135 
136     function canBurnSynths(address account) external view returns (bool);
137 
138     function collateral(address account) external view returns (uint);
139 
140     function collateralisationRatio(address issuer) external view returns (uint);
141 
142     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
143         external
144         view
145         returns (uint cratio, bool anyRateIsInvalid);
146 
147     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
148 
149     function issuanceRatio() external view returns (uint);
150 
151     function lastIssueEvent(address account) external view returns (uint);
152 
153     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
154 
155     function minimumStakeTime() external view returns (uint);
156 
157     function remainingIssuableSynths(address issuer)
158         external
159         view
160         returns (
161             uint maxIssuable,
162             uint alreadyIssued,
163             uint totalSystemDebt
164         );
165 
166     function synths(bytes32 currencyKey) external view returns (ISynth);
167 
168     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
169 
170     function synthsByAddress(address synthAddress) external view returns (bytes32);
171 
172     function totalIssuedSynths(bytes32 currencyKey, bool excludeOtherCollateral) external view returns (uint);
173 
174     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
175         external
176         view
177         returns (uint transferable, bool anyRateIsInvalid);
178 
179     // Restricted: used internally to Synthetix
180     function issueSynths(address from, uint amount) external;
181 
182     function issueSynthsOnBehalf(
183         address issueFor,
184         address from,
185         uint amount
186     ) external;
187 
188     function issueMaxSynths(address from) external;
189 
190     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
191 
192     function burnSynths(address from, uint amount) external;
193 
194     function burnSynthsOnBehalf(
195         address burnForAddress,
196         address from,
197         uint amount
198     ) external;
199 
200     function burnSynthsToTarget(address from) external;
201 
202     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
203 
204     function burnForRedemption(
205         address deprecatedSynthProxy,
206         address account,
207         uint balance
208     ) external;
209 
210     function liquidateDelinquentAccount(
211         address account,
212         uint susdAmount,
213         address liquidator
214     ) external returns (uint totalRedeemed, uint amountToLiquidate);
215 
216     function setCurrentPeriodId(uint128 periodId) external;
217 }
218 
219 
220 // Inheritance
221 
222 
223 // Internal references
224 
225 
226 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
227 contract AddressResolver is Owned, IAddressResolver {
228     mapping(bytes32 => address) public repository;
229 
230     constructor(address _owner) public Owned(_owner) {}
231 
232     /* ========== RESTRICTED FUNCTIONS ========== */
233 
234     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
235         require(names.length == destinations.length, "Input lengths must match");
236 
237         for (uint i = 0; i < names.length; i++) {
238             bytes32 name = names[i];
239             address destination = destinations[i];
240             repository[name] = destination;
241             emit AddressImported(name, destination);
242         }
243     }
244 
245     /* ========= PUBLIC FUNCTIONS ========== */
246 
247     function rebuildCaches(MixinResolver[] calldata destinations) external {
248         for (uint i = 0; i < destinations.length; i++) {
249             destinations[i].rebuildCache();
250         }
251     }
252 
253     /* ========== VIEWS ========== */
254 
255     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
256         for (uint i = 0; i < names.length; i++) {
257             if (repository[names[i]] != destinations[i]) {
258                 return false;
259             }
260         }
261         return true;
262     }
263 
264     function getAddress(bytes32 name) external view returns (address) {
265         return repository[name];
266     }
267 
268     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
269         address _foundAddress = repository[name];
270         require(_foundAddress != address(0), reason);
271         return _foundAddress;
272     }
273 
274     function getSynth(bytes32 key) external view returns (address) {
275         IIssuer issuer = IIssuer(repository["Issuer"]);
276         require(address(issuer) != address(0), "Cannot find Issuer address");
277         return address(issuer.synths(key));
278     }
279 
280     /* ========== EVENTS ========== */
281 
282     event AddressImported(bytes32 name, address destination);
283 }
284 
285 
286 // Internal references
287 
288 
289 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
290 contract MixinResolver {
291     AddressResolver public resolver;
292 
293     mapping(bytes32 => address) private addressCache;
294 
295     constructor(address _resolver) internal {
296         resolver = AddressResolver(_resolver);
297     }
298 
299     /* ========== INTERNAL FUNCTIONS ========== */
300 
301     function combineArrays(bytes32[] memory first, bytes32[] memory second)
302         internal
303         pure
304         returns (bytes32[] memory combination)
305     {
306         combination = new bytes32[](first.length + second.length);
307 
308         for (uint i = 0; i < first.length; i++) {
309             combination[i] = first[i];
310         }
311 
312         for (uint j = 0; j < second.length; j++) {
313             combination[first.length + j] = second[j];
314         }
315     }
316 
317     /* ========== PUBLIC FUNCTIONS ========== */
318 
319     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
320     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
321 
322     function rebuildCache() public {
323         bytes32[] memory requiredAddresses = resolverAddressesRequired();
324         // The resolver must call this function whenver it updates its state
325         for (uint i = 0; i < requiredAddresses.length; i++) {
326             bytes32 name = requiredAddresses[i];
327             // Note: can only be invoked once the resolver has all the targets needed added
328             address destination =
329                 resolver.requireAndGetAddress(name, string(abi.encodePacked("Resolver missing target: ", name)));
330             addressCache[name] = destination;
331             emit CacheUpdated(name, destination);
332         }
333     }
334 
335     /* ========== VIEWS ========== */
336 
337     function isResolverCached() external view returns (bool) {
338         bytes32[] memory requiredAddresses = resolverAddressesRequired();
339         for (uint i = 0; i < requiredAddresses.length; i++) {
340             bytes32 name = requiredAddresses[i];
341             // false if our cache is invalid or if the resolver doesn't have the required address
342             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
343                 return false;
344             }
345         }
346 
347         return true;
348     }
349 
350     /* ========== INTERNAL FUNCTIONS ========== */
351 
352     function requireAndGetAddress(bytes32 name) internal view returns (address) {
353         address _foundAddress = addressCache[name];
354         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
355         return _foundAddress;
356     }
357 
358     /* ========== EVENTS ========== */
359 
360     event CacheUpdated(bytes32 name, address destination);
361 }
362 
363 
364 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
365 interface IFlexibleStorage {
366     // Views
367     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
368 
369     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
370 
371     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
372 
373     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
374 
375     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
376 
377     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
378 
379     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
380 
381     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
382 
383     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
384 
385     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
386 
387     // Mutative functions
388     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
389 
390     function deleteIntValue(bytes32 contractName, bytes32 record) external;
391 
392     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
393 
394     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
395 
396     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
397 
398     function setUIntValue(
399         bytes32 contractName,
400         bytes32 record,
401         uint value
402     ) external;
403 
404     function setUIntValues(
405         bytes32 contractName,
406         bytes32[] calldata records,
407         uint[] calldata values
408     ) external;
409 
410     function setIntValue(
411         bytes32 contractName,
412         bytes32 record,
413         int value
414     ) external;
415 
416     function setIntValues(
417         bytes32 contractName,
418         bytes32[] calldata records,
419         int[] calldata values
420     ) external;
421 
422     function setAddressValue(
423         bytes32 contractName,
424         bytes32 record,
425         address value
426     ) external;
427 
428     function setAddressValues(
429         bytes32 contractName,
430         bytes32[] calldata records,
431         address[] calldata values
432     ) external;
433 
434     function setBoolValue(
435         bytes32 contractName,
436         bytes32 record,
437         bool value
438     ) external;
439 
440     function setBoolValues(
441         bytes32 contractName,
442         bytes32[] calldata records,
443         bool[] calldata values
444     ) external;
445 
446     function setBytes32Value(
447         bytes32 contractName,
448         bytes32 record,
449         bytes32 value
450     ) external;
451 
452     function setBytes32Values(
453         bytes32 contractName,
454         bytes32[] calldata records,
455         bytes32[] calldata values
456     ) external;
457 }
458 
459 
460 // Internal references
461 
462 
463 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
464 contract MixinSystemSettings is MixinResolver {
465     // must match the one defined SystemSettingsLib, defined in both places due to sol v0.5 limitations
466     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
467 
468     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
469     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
470     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
471     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
472     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
473     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
474     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
475     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
476     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
477     /* ========== Exchange Fees Related ========== */
478     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
479     bytes32 internal constant SETTING_EXCHANGE_DYNAMIC_FEE_THRESHOLD = "exchangeDynamicFeeThreshold";
480     bytes32 internal constant SETTING_EXCHANGE_DYNAMIC_FEE_WEIGHT_DECAY = "exchangeDynamicFeeWeightDecay";
481     bytes32 internal constant SETTING_EXCHANGE_DYNAMIC_FEE_ROUNDS = "exchangeDynamicFeeRounds";
482     bytes32 internal constant SETTING_EXCHANGE_MAX_DYNAMIC_FEE = "exchangeMaxDynamicFee";
483     /* ========== End Exchange Fees Related ========== */
484     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
485     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
486     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
487     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
488     bytes32 internal constant SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT = "crossDomainDepositGasLimit";
489     bytes32 internal constant SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT = "crossDomainEscrowGasLimit";
490     bytes32 internal constant SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT = "crossDomainRewardGasLimit";
491     bytes32 internal constant SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT = "crossDomainWithdrawalGasLimit";
492     bytes32 internal constant SETTING_CROSS_DOMAIN_FEE_PERIOD_CLOSE_GAS_LIMIT = "crossDomainCloseGasLimit";
493     bytes32 internal constant SETTING_CROSS_DOMAIN_RELAY_GAS_LIMIT = "crossDomainRelayGasLimit";
494     bytes32 internal constant SETTING_ETHER_WRAPPER_MAX_ETH = "etherWrapperMaxETH";
495     bytes32 internal constant SETTING_ETHER_WRAPPER_MINT_FEE_RATE = "etherWrapperMintFeeRate";
496     bytes32 internal constant SETTING_ETHER_WRAPPER_BURN_FEE_RATE = "etherWrapperBurnFeeRate";
497     bytes32 internal constant SETTING_WRAPPER_MAX_TOKEN_AMOUNT = "wrapperMaxTokens";
498     bytes32 internal constant SETTING_WRAPPER_MINT_FEE_RATE = "wrapperMintFeeRate";
499     bytes32 internal constant SETTING_WRAPPER_BURN_FEE_RATE = "wrapperBurnFeeRate";
500     bytes32 internal constant SETTING_INTERACTION_DELAY = "interactionDelay";
501     bytes32 internal constant SETTING_COLLAPSE_FEE_RATE = "collapseFeeRate";
502     bytes32 internal constant SETTING_ATOMIC_MAX_VOLUME_PER_BLOCK = "atomicMaxVolumePerBlock";
503     bytes32 internal constant SETTING_ATOMIC_TWAP_WINDOW = "atomicTwapWindow";
504     bytes32 internal constant SETTING_ATOMIC_EQUIVALENT_FOR_DEX_PRICING = "atomicEquivalentForDexPricing";
505     bytes32 internal constant SETTING_ATOMIC_EXCHANGE_FEE_RATE = "atomicExchangeFeeRate";
506     bytes32 internal constant SETTING_ATOMIC_PRICE_BUFFER = "atomicPriceBuffer";
507     bytes32 internal constant SETTING_ATOMIC_VOLATILITY_CONSIDERATION_WINDOW = "atomicVolConsiderationWindow";
508     bytes32 internal constant SETTING_ATOMIC_VOLATILITY_UPDATE_THRESHOLD = "atomicVolUpdateThreshold";
509 
510     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
511 
512     enum CrossDomainMessageGasLimits {Deposit, Escrow, Reward, Withdrawal, CloseFeePeriod, Relay}
513 
514     struct DynamicFeeConfig {
515         uint threshold;
516         uint weightDecay;
517         uint rounds;
518         uint maxFee;
519     }
520 
521     constructor(address _resolver) internal MixinResolver(_resolver) {}
522 
523     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
524         addresses = new bytes32[](1);
525         addresses[0] = CONTRACT_FLEXIBLESTORAGE;
526     }
527 
528     function flexibleStorage() internal view returns (IFlexibleStorage) {
529         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
530     }
531 
532     function _getGasLimitSetting(CrossDomainMessageGasLimits gasLimitType) internal pure returns (bytes32) {
533         if (gasLimitType == CrossDomainMessageGasLimits.Deposit) {
534             return SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT;
535         } else if (gasLimitType == CrossDomainMessageGasLimits.Escrow) {
536             return SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT;
537         } else if (gasLimitType == CrossDomainMessageGasLimits.Reward) {
538             return SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT;
539         } else if (gasLimitType == CrossDomainMessageGasLimits.Withdrawal) {
540             return SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT;
541         } else if (gasLimitType == CrossDomainMessageGasLimits.Relay) {
542             return SETTING_CROSS_DOMAIN_RELAY_GAS_LIMIT;
543         } else if (gasLimitType == CrossDomainMessageGasLimits.CloseFeePeriod) {
544             return SETTING_CROSS_DOMAIN_FEE_PERIOD_CLOSE_GAS_LIMIT;
545         } else {
546             revert("Unknown gas limit type");
547         }
548     }
549 
550     function getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits gasLimitType) internal view returns (uint) {
551         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, _getGasLimitSetting(gasLimitType));
552     }
553 
554     function getTradingRewardsEnabled() internal view returns (bool) {
555         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
556     }
557 
558     function getWaitingPeriodSecs() internal view returns (uint) {
559         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
560     }
561 
562     function getPriceDeviationThresholdFactor() internal view returns (uint) {
563         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
564     }
565 
566     function getIssuanceRatio() internal view returns (uint) {
567         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
568         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
569     }
570 
571     function getFeePeriodDuration() internal view returns (uint) {
572         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
573         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
574     }
575 
576     function getTargetThreshold() internal view returns (uint) {
577         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
578         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
579     }
580 
581     function getLiquidationDelay() internal view returns (uint) {
582         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
583     }
584 
585     function getLiquidationRatio() internal view returns (uint) {
586         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
587     }
588 
589     function getLiquidationPenalty() internal view returns (uint) {
590         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
591     }
592 
593     function getRateStalePeriod() internal view returns (uint) {
594         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
595     }
596 
597     /* ========== Exchange Related Fees ========== */
598     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
599         return
600             flexibleStorage().getUIntValue(
601                 SETTING_CONTRACT_NAME,
602                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
603             );
604     }
605 
606     /// @notice Get exchange dynamic fee related keys
607     /// @return threshold, weight decay, rounds, and max fee
608     function getExchangeDynamicFeeConfig() internal view returns (DynamicFeeConfig memory) {
609         bytes32[] memory keys = new bytes32[](4);
610         keys[0] = SETTING_EXCHANGE_DYNAMIC_FEE_THRESHOLD;
611         keys[1] = SETTING_EXCHANGE_DYNAMIC_FEE_WEIGHT_DECAY;
612         keys[2] = SETTING_EXCHANGE_DYNAMIC_FEE_ROUNDS;
613         keys[3] = SETTING_EXCHANGE_MAX_DYNAMIC_FEE;
614         uint[] memory values = flexibleStorage().getUIntValues(SETTING_CONTRACT_NAME, keys);
615         return DynamicFeeConfig({threshold: values[0], weightDecay: values[1], rounds: values[2], maxFee: values[3]});
616     }
617 
618     /* ========== End Exchange Related Fees ========== */
619 
620     function getMinimumStakeTime() internal view returns (uint) {
621         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
622     }
623 
624     function getAggregatorWarningFlags() internal view returns (address) {
625         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
626     }
627 
628     function getDebtSnapshotStaleTime() internal view returns (uint) {
629         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
630     }
631 
632     function getEtherWrapperMaxETH() internal view returns (uint) {
633         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MAX_ETH);
634     }
635 
636     function getEtherWrapperMintFeeRate() internal view returns (uint) {
637         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_MINT_FEE_RATE);
638     }
639 
640     function getEtherWrapperBurnFeeRate() internal view returns (uint) {
641         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ETHER_WRAPPER_BURN_FEE_RATE);
642     }
643 
644     function getWrapperMaxTokenAmount(address wrapper) internal view returns (uint) {
645         return
646             flexibleStorage().getUIntValue(
647                 SETTING_CONTRACT_NAME,
648                 keccak256(abi.encodePacked(SETTING_WRAPPER_MAX_TOKEN_AMOUNT, wrapper))
649             );
650     }
651 
652     function getWrapperMintFeeRate(address wrapper) internal view returns (int) {
653         return
654             flexibleStorage().getIntValue(
655                 SETTING_CONTRACT_NAME,
656                 keccak256(abi.encodePacked(SETTING_WRAPPER_MINT_FEE_RATE, wrapper))
657             );
658     }
659 
660     function getWrapperBurnFeeRate(address wrapper) internal view returns (int) {
661         return
662             flexibleStorage().getIntValue(
663                 SETTING_CONTRACT_NAME,
664                 keccak256(abi.encodePacked(SETTING_WRAPPER_BURN_FEE_RATE, wrapper))
665             );
666     }
667 
668     function getInteractionDelay(address collateral) internal view returns (uint) {
669         return
670             flexibleStorage().getUIntValue(
671                 SETTING_CONTRACT_NAME,
672                 keccak256(abi.encodePacked(SETTING_INTERACTION_DELAY, collateral))
673             );
674     }
675 
676     function getCollapseFeeRate(address collateral) internal view returns (uint) {
677         return
678             flexibleStorage().getUIntValue(
679                 SETTING_CONTRACT_NAME,
680                 keccak256(abi.encodePacked(SETTING_COLLAPSE_FEE_RATE, collateral))
681             );
682     }
683 
684     function getAtomicMaxVolumePerBlock() internal view returns (uint) {
685         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ATOMIC_MAX_VOLUME_PER_BLOCK);
686     }
687 
688     function getAtomicTwapWindow() internal view returns (uint) {
689         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ATOMIC_TWAP_WINDOW);
690     }
691 
692     function getAtomicEquivalentForDexPricing(bytes32 currencyKey) internal view returns (address) {
693         return
694             flexibleStorage().getAddressValue(
695                 SETTING_CONTRACT_NAME,
696                 keccak256(abi.encodePacked(SETTING_ATOMIC_EQUIVALENT_FOR_DEX_PRICING, currencyKey))
697             );
698     }
699 
700     function getAtomicExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
701         return
702             flexibleStorage().getUIntValue(
703                 SETTING_CONTRACT_NAME,
704                 keccak256(abi.encodePacked(SETTING_ATOMIC_EXCHANGE_FEE_RATE, currencyKey))
705             );
706     }
707 
708     function getAtomicPriceBuffer(bytes32 currencyKey) internal view returns (uint) {
709         return
710             flexibleStorage().getUIntValue(
711                 SETTING_CONTRACT_NAME,
712                 keccak256(abi.encodePacked(SETTING_ATOMIC_PRICE_BUFFER, currencyKey))
713             );
714     }
715 
716     function getAtomicVolatilityConsiderationWindow(bytes32 currencyKey) internal view returns (uint) {
717         return
718             flexibleStorage().getUIntValue(
719                 SETTING_CONTRACT_NAME,
720                 keccak256(abi.encodePacked(SETTING_ATOMIC_VOLATILITY_CONSIDERATION_WINDOW, currencyKey))
721             );
722     }
723 
724     function getAtomicVolatilityUpdateThreshold(bytes32 currencyKey) internal view returns (uint) {
725         return
726             flexibleStorage().getUIntValue(
727                 SETTING_CONTRACT_NAME,
728                 keccak256(abi.encodePacked(SETTING_ATOMIC_VOLATILITY_UPDATE_THRESHOLD, currencyKey))
729             );
730     }
731 }
732 
733 
734 pragma experimental ABIEncoderV2;
735 
736 interface IBaseSynthetixBridge {
737     function suspendInitiation() external;
738 
739     function resumeInitiation() external;
740 }
741 
742 
743 interface IVirtualSynth {
744     // Views
745     function balanceOfUnderlying(address account) external view returns (uint);
746 
747     function rate() external view returns (uint);
748 
749     function readyToSettle() external view returns (bool);
750 
751     function secsLeftInWaitingPeriod() external view returns (uint);
752 
753     function settled() external view returns (bool);
754 
755     function synth() external view returns (ISynth);
756 
757     // Mutative functions
758     function settle(address account) external;
759 }
760 
761 
762 // https://docs.synthetix.io/contracts/source/interfaces/isynthetix
763 interface ISynthetix {
764     // Views
765     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
766 
767     function availableCurrencyKeys() external view returns (bytes32[] memory);
768 
769     function availableSynthCount() external view returns (uint);
770 
771     function availableSynths(uint index) external view returns (ISynth);
772 
773     function collateral(address account) external view returns (uint);
774 
775     function collateralisationRatio(address issuer) external view returns (uint);
776 
777     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
778 
779     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
780 
781     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
782 
783     function remainingIssuableSynths(address issuer)
784         external
785         view
786         returns (
787             uint maxIssuable,
788             uint alreadyIssued,
789             uint totalSystemDebt
790         );
791 
792     function synths(bytes32 currencyKey) external view returns (ISynth);
793 
794     function synthsByAddress(address synthAddress) external view returns (bytes32);
795 
796     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
797 
798     function totalIssuedSynthsExcludeOtherCollateral(bytes32 currencyKey) external view returns (uint);
799 
800     function transferableSynthetix(address account) external view returns (uint transferable);
801 
802     // Mutative Functions
803     function burnSynths(uint amount) external;
804 
805     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
806 
807     function burnSynthsToTarget() external;
808 
809     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
810 
811     function exchange(
812         bytes32 sourceCurrencyKey,
813         uint sourceAmount,
814         bytes32 destinationCurrencyKey
815     ) external returns (uint amountReceived);
816 
817     function exchangeOnBehalf(
818         address exchangeForAddress,
819         bytes32 sourceCurrencyKey,
820         uint sourceAmount,
821         bytes32 destinationCurrencyKey
822     ) external returns (uint amountReceived);
823 
824     function exchangeWithTracking(
825         bytes32 sourceCurrencyKey,
826         uint sourceAmount,
827         bytes32 destinationCurrencyKey,
828         address rewardAddress,
829         bytes32 trackingCode
830     ) external returns (uint amountReceived);
831 
832     function exchangeWithTrackingForInitiator(
833         bytes32 sourceCurrencyKey,
834         uint sourceAmount,
835         bytes32 destinationCurrencyKey,
836         address rewardAddress,
837         bytes32 trackingCode
838     ) external returns (uint amountReceived);
839 
840     function exchangeOnBehalfWithTracking(
841         address exchangeForAddress,
842         bytes32 sourceCurrencyKey,
843         uint sourceAmount,
844         bytes32 destinationCurrencyKey,
845         address rewardAddress,
846         bytes32 trackingCode
847     ) external returns (uint amountReceived);
848 
849     function exchangeWithVirtual(
850         bytes32 sourceCurrencyKey,
851         uint sourceAmount,
852         bytes32 destinationCurrencyKey,
853         bytes32 trackingCode
854     ) external returns (uint amountReceived, IVirtualSynth vSynth);
855 
856     function exchangeAtomically(
857         bytes32 sourceCurrencyKey,
858         uint sourceAmount,
859         bytes32 destinationCurrencyKey,
860         bytes32 trackingCode
861     ) external returns (uint amountReceived);
862 
863     function issueMaxSynths() external;
864 
865     function issueMaxSynthsOnBehalf(address issueForAddress) external;
866 
867     function issueSynths(uint amount) external;
868 
869     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
870 
871     function mint() external returns (bool);
872 
873     function settle(bytes32 currencyKey)
874         external
875         returns (
876             uint reclaimed,
877             uint refunded,
878             uint numEntries
879         );
880 
881     // Liquidations
882     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
883 
884     // Restricted Functions
885 
886     function mintSecondary(address account, uint amount) external;
887 
888     function mintSecondaryRewards(uint amount) external;
889 
890     function burnSecondary(address account, uint amount) external;
891 }
892 
893 
894 library VestingEntries {
895     struct VestingEntry {
896         uint64 endTime;
897         uint256 escrowAmount;
898     }
899     struct VestingEntryWithID {
900         uint64 endTime;
901         uint256 escrowAmount;
902         uint256 entryID;
903     }
904 }
905 
906 interface IRewardEscrowV2 {
907     // Views
908     function balanceOf(address account) external view returns (uint);
909 
910     function numVestingEntries(address account) external view returns (uint);
911 
912     function totalEscrowedAccountBalance(address account) external view returns (uint);
913 
914     function totalVestedAccountBalance(address account) external view returns (uint);
915 
916     function getVestingQuantity(address account, uint256[] calldata entryIDs) external view returns (uint);
917 
918     function getVestingSchedules(
919         address account,
920         uint256 index,
921         uint256 pageSize
922     ) external view returns (VestingEntries.VestingEntryWithID[] memory);
923 
924     function getAccountVestingEntryIDs(
925         address account,
926         uint256 index,
927         uint256 pageSize
928     ) external view returns (uint256[] memory);
929 
930     function getVestingEntryClaimable(address account, uint256 entryID) external view returns (uint);
931 
932     function getVestingEntry(address account, uint256 entryID) external view returns (uint64, uint256);
933 
934     // Mutative functions
935     function vest(uint256[] calldata entryIDs) external;
936 
937     function createEscrowEntry(
938         address beneficiary,
939         uint256 deposit,
940         uint256 duration
941     ) external;
942 
943     function appendVestingEntry(
944         address account,
945         uint256 quantity,
946         uint256 duration
947     ) external;
948 
949     function migrateVestingSchedule(address _addressToMigrate) external;
950 
951     function migrateAccountEscrowBalances(
952         address[] calldata accounts,
953         uint256[] calldata escrowBalances,
954         uint256[] calldata vestedBalances
955     ) external;
956 
957     // Account Merging
958     function startMergingWindow() external;
959 
960     function mergeAccount(address accountToMerge, uint256[] calldata entryIDs) external;
961 
962     function nominateAccountToMerge(address account) external;
963 
964     function accountMergingIsOpen() external view returns (bool);
965 
966     // L2 Migration
967     function importVestingEntries(
968         address account,
969         uint256 escrowedAmount,
970         VestingEntries.VestingEntry[] calldata vestingEntries
971     ) external;
972 
973     // Return amount of SNX transfered to SynthetixBridgeToOptimism deposit contract
974     function burnForMigration(address account, uint256[] calldata entryIDs)
975         external
976         returns (uint256 escrowedAccountBalance, VestingEntries.VestingEntry[] memory vestingEntries);
977 }
978 
979 
980 // https://docs.synthetix.io/contracts/source/interfaces/ifeepool
981 interface IFeePool {
982     // Views
983 
984     // solhint-disable-next-line func-name-mixedcase
985     function FEE_ADDRESS() external view returns (address);
986 
987     function feesAvailable(address account) external view returns (uint, uint);
988 
989     function feePeriodDuration() external view returns (uint);
990 
991     function isFeesClaimable(address account) external view returns (bool);
992 
993     function targetThreshold() external view returns (uint);
994 
995     function totalFeesAvailable() external view returns (uint);
996 
997     function totalRewardsAvailable() external view returns (uint);
998 
999     // Mutative Functions
1000     function claimFees() external returns (bool);
1001 
1002     function claimOnBehalf(address claimingForAddress) external returns (bool);
1003 
1004     function closeCurrentFeePeriod() external;
1005 
1006     function closeSecondary(uint snxBackedDebt, uint debtShareSupply) external;
1007 
1008     function recordFeePaid(uint sUSDAmount) external;
1009 
1010     function setRewardsToDistribute(uint amount) external;
1011 }
1012 
1013 
1014 // SPDX-License-Identifier: MIT
1015 
1016 
1017 /**
1018  * @title iAbs_BaseCrossDomainMessenger
1019  */
1020 interface iAbs_BaseCrossDomainMessenger {
1021 
1022     /**********
1023      * Events *
1024      **********/
1025 
1026     event SentMessage(bytes message);
1027     event RelayedMessage(bytes32 msgHash);
1028     event FailedRelayedMessage(bytes32 msgHash);
1029 
1030 
1031     /*************
1032      * Variables *
1033      *************/
1034 
1035     function xDomainMessageSender() external view returns (address);
1036 
1037 
1038     /********************
1039      * Public Functions *
1040      ********************/
1041 
1042     /**
1043      * Sends a cross domain message to the target messenger.
1044      * @param _target Target contract address.
1045      * @param _message Message to send to the target.
1046      * @param _gasLimit Gas limit for the provided message.
1047      */
1048     function sendMessage(
1049         address _target,
1050         bytes calldata _message,
1051         uint32 _gasLimit
1052     ) external;
1053 }
1054 
1055 
1056 // Inheritance
1057 
1058 
1059 // Internal references
1060 
1061 
1062 contract BaseSynthetixBridge is Owned, MixinSystemSettings, IBaseSynthetixBridge {
1063     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1064     bytes32 private constant CONTRACT_EXT_MESSENGER = "ext:Messenger";
1065     bytes32 internal constant CONTRACT_SYNTHETIX = "Synthetix";
1066     bytes32 private constant CONTRACT_REWARDESCROW = "RewardEscrowV2";
1067     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1068 
1069     bool public initiationActive;
1070 
1071     // ========== CONSTRUCTOR ==========
1072 
1073     constructor(address _owner, address _resolver) public Owned(_owner) MixinSystemSettings(_resolver) {
1074         initiationActive = true;
1075     }
1076 
1077     // ========== INTERNALS ============
1078 
1079     function messenger() internal view returns (iAbs_BaseCrossDomainMessenger) {
1080         return iAbs_BaseCrossDomainMessenger(requireAndGetAddress(CONTRACT_EXT_MESSENGER));
1081     }
1082 
1083     function synthetix() internal view returns (ISynthetix) {
1084         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX));
1085     }
1086 
1087     function rewardEscrowV2() internal view returns (IRewardEscrowV2) {
1088         return IRewardEscrowV2(requireAndGetAddress(CONTRACT_REWARDESCROW));
1089     }
1090 
1091     function feePool() internal view returns (IFeePool) {
1092         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL));
1093     }
1094 
1095     function initiatingActive() internal view {
1096         require(initiationActive, "Initiation deactivated");
1097     }
1098 
1099     /* ========== VIEWS ========== */
1100 
1101     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1102         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1103         bytes32[] memory newAddresses = new bytes32[](4);
1104         newAddresses[0] = CONTRACT_EXT_MESSENGER;
1105         newAddresses[1] = CONTRACT_SYNTHETIX;
1106         newAddresses[2] = CONTRACT_REWARDESCROW;
1107         newAddresses[3] = CONTRACT_FEEPOOL;
1108         addresses = combineArrays(existingAddresses, newAddresses);
1109     }
1110 
1111     // ========== MODIFIERS ============
1112 
1113     modifier requireInitiationActive() {
1114         initiatingActive();
1115         _;
1116     }
1117 
1118     // ========= RESTRICTED FUNCTIONS ==============
1119 
1120     function suspendInitiation() external onlyOwner {
1121         require(initiationActive, "Initiation suspended");
1122         initiationActive = false;
1123         emit InitiationSuspended();
1124     }
1125 
1126     function resumeInitiation() external onlyOwner {
1127         require(!initiationActive, "Initiation not suspended");
1128         initiationActive = true;
1129         emit InitiationResumed();
1130     }
1131 
1132     // ========== EVENTS ==========
1133 
1134     event InitiationSuspended();
1135 
1136     event InitiationResumed();
1137 }
1138 
1139 
1140 interface ISynthetixBridgeToOptimism {
1141     function closeFeePeriod(uint snxBackedDebt, uint debtSharesSupply) external;
1142 
1143     function migrateEscrow(uint256[][] calldata entryIDs) external;
1144 
1145     function depositReward(uint amount) external;
1146 
1147     function depositAndMigrateEscrow(uint256 depositAmount, uint256[][] calldata entryIDs) external;
1148 }
1149 
1150 
1151 // SPDX-License-Identifier: MIT
1152 
1153 
1154 /**
1155  * @title iOVM_L1TokenGateway
1156  */
1157 interface iOVM_L1TokenGateway {
1158 
1159     /**********
1160      * Events *
1161      **********/
1162 
1163     event DepositInitiated(
1164         address indexed _from,
1165         address _to,
1166         uint256 _amount
1167     );
1168 
1169     event WithdrawalFinalized(
1170         address indexed _to,
1171         uint256 _amount
1172     );
1173 
1174 
1175     /********************
1176      * Public Functions *
1177      ********************/
1178 
1179     function deposit(
1180         uint _amount
1181     )
1182         external;
1183 
1184     function depositTo(
1185         address _to,
1186         uint _amount
1187     )
1188         external;
1189 
1190 
1191     /*************************
1192      * Cross-chain Functions *
1193      *************************/
1194 
1195     function finalizeWithdrawal(
1196         address _to,
1197         uint _amount
1198     )
1199         external;
1200 }
1201 
1202 
1203 /**
1204  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1205  * the optional functions; to access them see `ERC20Detailed`.
1206  */
1207 interface IERC20 {
1208     /**
1209      * @dev Returns the amount of tokens in existence.
1210      */
1211     function totalSupply() external view returns (uint256);
1212 
1213     /**
1214      * @dev Returns the amount of tokens owned by `account`.
1215      */
1216     function balanceOf(address account) external view returns (uint256);
1217 
1218     /**
1219      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1220      *
1221      * Returns a boolean value indicating whether the operation succeeded.
1222      *
1223      * Emits a `Transfer` event.
1224      */
1225     function transfer(address recipient, uint256 amount) external returns (bool);
1226 
1227     /**
1228      * @dev Returns the remaining number of tokens that `spender` will be
1229      * allowed to spend on behalf of `owner` through `transferFrom`. This is
1230      * zero by default.
1231      *
1232      * This value changes when `approve` or `transferFrom` are called.
1233      */
1234     function allowance(address owner, address spender) external view returns (uint256);
1235 
1236     /**
1237      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1238      *
1239      * Returns a boolean value indicating whether the operation succeeded.
1240      *
1241      * > Beware that changing an allowance with this method brings the risk
1242      * that someone may use both the old and the new allowance by unfortunate
1243      * transaction ordering. One possible solution to mitigate this race
1244      * condition is to first reduce the spender's allowance to 0 and set the
1245      * desired value afterwards:
1246      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1247      *
1248      * Emits an `Approval` event.
1249      */
1250     function approve(address spender, uint256 amount) external returns (bool);
1251 
1252     /**
1253      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1254      * allowance mechanism. `amount` is then deducted from the caller's
1255      * allowance.
1256      *
1257      * Returns a boolean value indicating whether the operation succeeded.
1258      *
1259      * Emits a `Transfer` event.
1260      */
1261     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1262 
1263     /**
1264      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1265      * another (`to`).
1266      *
1267      * Note that `value` may be zero.
1268      */
1269     event Transfer(address indexed from, address indexed to, uint256 value);
1270 
1271     /**
1272      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1273      * a call to `approve`. `value` is the new allowance.
1274      */
1275     event Approval(address indexed owner, address indexed spender, uint256 value);
1276 }
1277 
1278 
1279 /**
1280  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1281  * checks.
1282  *
1283  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1284  * in bugs, because programmers usually assume that an overflow raises an
1285  * error, which is the standard behavior in high level programming languages.
1286  * `SafeMath` restores this intuition by reverting the transaction when an
1287  * operation overflows.
1288  *
1289  * Using this library instead of the unchecked operations eliminates an entire
1290  * class of bugs, so it's recommended to use it always.
1291  */
1292 library SafeMath {
1293     /**
1294      * @dev Returns the addition of two unsigned integers, reverting on
1295      * overflow.
1296      *
1297      * Counterpart to Solidity's `+` operator.
1298      *
1299      * Requirements:
1300      * - Addition cannot overflow.
1301      */
1302     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1303         uint256 c = a + b;
1304         require(c >= a, "SafeMath: addition overflow");
1305 
1306         return c;
1307     }
1308 
1309     /**
1310      * @dev Returns the subtraction of two unsigned integers, reverting on
1311      * overflow (when the result is negative).
1312      *
1313      * Counterpart to Solidity's `-` operator.
1314      *
1315      * Requirements:
1316      * - Subtraction cannot overflow.
1317      */
1318     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1319         require(b <= a, "SafeMath: subtraction overflow");
1320         uint256 c = a - b;
1321 
1322         return c;
1323     }
1324 
1325     /**
1326      * @dev Returns the multiplication of two unsigned integers, reverting on
1327      * overflow.
1328      *
1329      * Counterpart to Solidity's `*` operator.
1330      *
1331      * Requirements:
1332      * - Multiplication cannot overflow.
1333      */
1334     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1335         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1336         // benefit is lost if 'b' is also tested.
1337         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1338         if (a == 0) {
1339             return 0;
1340         }
1341 
1342         uint256 c = a * b;
1343         require(c / a == b, "SafeMath: multiplication overflow");
1344 
1345         return c;
1346     }
1347 
1348     /**
1349      * @dev Returns the integer division of two unsigned integers. Reverts on
1350      * division by zero. The result is rounded towards zero.
1351      *
1352      * Counterpart to Solidity's `/` operator. Note: this function uses a
1353      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1354      * uses an invalid opcode to revert (consuming all remaining gas).
1355      *
1356      * Requirements:
1357      * - The divisor cannot be zero.
1358      */
1359     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1360         // Solidity only automatically asserts when dividing by 0
1361         require(b > 0, "SafeMath: division by zero");
1362         uint256 c = a / b;
1363         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1364 
1365         return c;
1366     }
1367 
1368     /**
1369      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1370      * Reverts when dividing by zero.
1371      *
1372      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1373      * opcode (which leaves remaining gas untouched) while Solidity uses an
1374      * invalid opcode to revert (consuming all remaining gas).
1375      *
1376      * Requirements:
1377      * - The divisor cannot be zero.
1378      */
1379     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1380         require(b != 0, "SafeMath: modulo by zero");
1381         return a % b;
1382     }
1383 }
1384 
1385 
1386 /**
1387  * @dev Collection of functions related to the address type,
1388  */
1389 library Address {
1390     /**
1391      * @dev Returns true if `account` is a contract.
1392      *
1393      * This test is non-exhaustive, and there may be false-negatives: during the
1394      * execution of a contract's constructor, its address will be reported as
1395      * not containing a contract.
1396      *
1397      * > It is unsafe to assume that an address for which this function returns
1398      * false is an externally-owned account (EOA) and not a contract.
1399      */
1400     function isContract(address account) internal view returns (bool) {
1401         // This method relies in extcodesize, which returns 0 for contracts in
1402         // construction, since the code is only stored at the end of the
1403         // constructor execution.
1404 
1405         uint256 size;
1406         // solhint-disable-next-line no-inline-assembly
1407         assembly { size := extcodesize(account) }
1408         return size > 0;
1409     }
1410 }
1411 
1412 
1413 /**
1414  * @title SafeERC20
1415  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1416  * contract returns false). Tokens that return no value (and instead revert or
1417  * throw on failure) are also supported, non-reverting calls are assumed to be
1418  * successful.
1419  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1420  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1421  */
1422 library SafeERC20 {
1423     using SafeMath for uint256;
1424     using Address for address;
1425 
1426     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1427         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1428     }
1429 
1430     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1431         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1432     }
1433 
1434     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1435         // safeApprove should only be called when setting an initial allowance,
1436         // or when resetting it to zero. To increase and decrease it, use
1437         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1438         // solhint-disable-next-line max-line-length
1439         require((value == 0) || (token.allowance(address(this), spender) == 0),
1440             "SafeERC20: approve from non-zero to non-zero allowance"
1441         );
1442         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1443     }
1444 
1445     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1446         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1447         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1448     }
1449 
1450     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1451         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
1452         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1453     }
1454 
1455     /**
1456      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1457      * on the return value: the return value is optional (but if data is returned, it must not be false).
1458      * @param token The token targeted by the call.
1459      * @param data The call data (encoded using abi.encode or one of its variants).
1460      */
1461     function callOptionalReturn(IERC20 token, bytes memory data) private {
1462         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1463         // we're implementing it ourselves.
1464 
1465         // A Solidity high level call has three parts:
1466         //  1. The target address is checked to verify it contains contract code
1467         //  2. The call itself is made, and success asserted
1468         //  3. The return value is decoded, which in turn checks the size of the returned data.
1469         // solhint-disable-next-line max-line-length
1470         require(address(token).isContract(), "SafeERC20: call to non-contract");
1471 
1472         // solhint-disable-next-line avoid-low-level-calls
1473         (bool success, bytes memory returndata) = address(token).call(data);
1474         require(success, "SafeERC20: low-level call failed");
1475 
1476         if (returndata.length > 0) { // Return data is optional
1477             // solhint-disable-next-line max-line-length
1478             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1479         }
1480     }
1481 }
1482 
1483 
1484 interface ISynthetixBridgeToBase {
1485     // invoked by the xDomain messenger on L2
1486     function finalizeEscrowMigration(
1487         address account,
1488         uint256 escrowedAmount,
1489         VestingEntries.VestingEntry[] calldata vestingEntries
1490     ) external;
1491 
1492     // invoked by the xDomain messenger on L2
1493     function finalizeRewardDeposit(address from, uint amount) external;
1494 
1495     function finalizeFeePeriodClose(uint snxBackedDebt, uint debtSharesSupply) external;
1496 }
1497 
1498 
1499 // SPDX-License-Identifier: MIT
1500 
1501 
1502 /**
1503  * @title iOVM_L2DepositedToken
1504  */
1505 interface iOVM_L2DepositedToken {
1506 
1507     /**********
1508      * Events *
1509      **********/
1510 
1511     event WithdrawalInitiated(
1512         address indexed _from,
1513         address _to,
1514         uint256 _amount
1515     );
1516 
1517     event DepositFinalized(
1518         address indexed _to,
1519         uint256 _amount
1520     );
1521 
1522 
1523     /********************
1524      * Public Functions *
1525      ********************/
1526 
1527     function withdraw(
1528         uint _amount
1529     )
1530         external;
1531 
1532     function withdrawTo(
1533         address _to,
1534         uint _amount
1535     )
1536         external;
1537 
1538 
1539     /*************************
1540      * Cross-chain Functions *
1541      *************************/
1542 
1543     function finalizeDeposit(
1544         address _to,
1545         uint _amount
1546     )
1547         external;
1548 }
1549 
1550 
1551 // Inheritance
1552 
1553 
1554 // Internal references
1555 
1556 
1557 contract SynthetixBridgeToOptimism is BaseSynthetixBridge, ISynthetixBridgeToOptimism, iOVM_L1TokenGateway {
1558     using SafeERC20 for IERC20;
1559 
1560     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1561 
1562     bytes32 public constant CONTRACT_NAME = "SynthetixBridgeToOptimism";
1563 
1564     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1565     bytes32 private constant CONTRACT_REWARDSDISTRIBUTION = "RewardsDistribution";
1566     bytes32 private constant CONTRACT_OVM_SYNTHETIXBRIDGETOBASE = "ovm:SynthetixBridgeToBase";
1567     bytes32 private constant CONTRACT_SYNTHETIXBRIDGEESCROW = "SynthetixBridgeEscrow";
1568 
1569     uint8 private constant MAX_ENTRIES_MIGRATED_PER_MESSAGE = 26;
1570 
1571     // ========== CONSTRUCTOR ==========
1572 
1573     constructor(address _owner, address _resolver) public BaseSynthetixBridge(_owner, _resolver) {}
1574 
1575     // ========== INTERNALS ============
1576 
1577     function synthetixERC20() internal view returns (IERC20) {
1578         return IERC20(requireAndGetAddress(CONTRACT_SYNTHETIX));
1579     }
1580 
1581     function issuer() internal view returns (IIssuer) {
1582         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1583     }
1584 
1585     function rewardsDistribution() internal view returns (address) {
1586         return requireAndGetAddress(CONTRACT_REWARDSDISTRIBUTION);
1587     }
1588 
1589     function synthetixBridgeToBase() internal view returns (address) {
1590         return requireAndGetAddress(CONTRACT_OVM_SYNTHETIXBRIDGETOBASE);
1591     }
1592 
1593     function synthetixBridgeEscrow() internal view returns (address) {
1594         return requireAndGetAddress(CONTRACT_SYNTHETIXBRIDGEESCROW);
1595     }
1596 
1597     function hasZeroDebt() internal view {
1598         require(issuer().debtBalanceOf(msg.sender, "sUSD") == 0, "Cannot deposit or migrate with debt");
1599     }
1600 
1601     /* ========== VIEWS ========== */
1602 
1603     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1604         bytes32[] memory existingAddresses = BaseSynthetixBridge.resolverAddressesRequired();
1605         bytes32[] memory newAddresses = new bytes32[](4);
1606         newAddresses[0] = CONTRACT_ISSUER;
1607         newAddresses[1] = CONTRACT_REWARDSDISTRIBUTION;
1608         newAddresses[2] = CONTRACT_OVM_SYNTHETIXBRIDGETOBASE;
1609         newAddresses[3] = CONTRACT_SYNTHETIXBRIDGEESCROW;
1610         addresses = combineArrays(existingAddresses, newAddresses);
1611     }
1612 
1613     // ========== MODIFIERS ============
1614 
1615     modifier requireZeroDebt() {
1616         hasZeroDebt();
1617         _;
1618     }
1619 
1620     // ========== PUBLIC FUNCTIONS =========
1621 
1622     function deposit(uint256 amount) external requireInitiationActive requireZeroDebt {
1623         _initiateDeposit(msg.sender, amount);
1624     }
1625 
1626     function depositTo(address to, uint amount) external requireInitiationActive requireZeroDebt {
1627         _initiateDeposit(to, amount);
1628     }
1629 
1630     function migrateEscrow(uint256[][] memory entryIDs) public requireInitiationActive requireZeroDebt {
1631         _migrateEscrow(entryIDs);
1632     }
1633 
1634     // invoked by a generous user on L1
1635     function depositReward(uint amount) external requireInitiationActive {
1636         // move the SNX into the deposit escrow
1637         synthetixERC20().transferFrom(msg.sender, synthetixBridgeEscrow(), amount);
1638 
1639         _depositReward(msg.sender, amount);
1640     }
1641 
1642     // forward any accidental tokens sent here to the escrow
1643     function forwardTokensToEscrow(address token) external {
1644         IERC20 erc20 = IERC20(token);
1645         erc20.safeTransfer(synthetixBridgeEscrow(), erc20.balanceOf(address(this)));
1646     }
1647 
1648     // ========= RESTRICTED FUNCTIONS ==============
1649 
1650     function closeFeePeriod(uint snxBackedAmount, uint totalDebtShares) external requireInitiationActive {
1651         require(msg.sender == address(feePool()), "Only the fee pool can call this");
1652 
1653         ISynthetixBridgeToBase bridgeToBase;
1654         bytes memory messageData =
1655             abi.encodeWithSelector(bridgeToBase.finalizeFeePeriodClose.selector, snxBackedAmount, totalDebtShares);
1656 
1657         // relay the message to this contract on L2 via L1 Messenger
1658         messenger().sendMessage(
1659             synthetixBridgeToBase(),
1660             messageData,
1661             uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.CloseFeePeriod))
1662         );
1663 
1664         emit FeePeriodClosed(snxBackedAmount, totalDebtShares);
1665     }
1666 
1667     // invoked by Messenger on L1 after L2 waiting period elapses
1668     function finalizeWithdrawal(address to, uint256 amount) external {
1669         // ensure function only callable from L2 Bridge via messenger (aka relayer)
1670         require(msg.sender == address(messenger()), "Only the relayer can call this");
1671         require(messenger().xDomainMessageSender() == synthetixBridgeToBase(), "Only the L2 bridge can invoke");
1672 
1673         // transfer amount back to user
1674         synthetixERC20().transferFrom(synthetixBridgeEscrow(), to, amount);
1675 
1676         // no escrow actions - escrow remains on L2
1677         emit iOVM_L1TokenGateway.WithdrawalFinalized(to, amount);
1678     }
1679 
1680     // invoked by RewardsDistribution on L1 (takes SNX)
1681     function notifyRewardAmount(uint256 amount) external {
1682         require(msg.sender == address(rewardsDistribution()), "Caller is not RewardsDistribution contract");
1683 
1684         // NOTE: transfer SNX to synthetixBridgeEscrow because RewardsDistribution transfers them initially to this contract.
1685         synthetixERC20().transfer(synthetixBridgeEscrow(), amount);
1686 
1687         // to be here means I've been given an amount of SNX to distribute onto L2
1688         _depositReward(msg.sender, amount);
1689     }
1690 
1691     function depositAndMigrateEscrow(uint256 depositAmount, uint256[][] memory entryIDs)
1692         public
1693         requireInitiationActive
1694         requireZeroDebt
1695     {
1696         if (entryIDs.length > 0) {
1697             _migrateEscrow(entryIDs);
1698         }
1699 
1700         if (depositAmount > 0) {
1701             _initiateDeposit(msg.sender, depositAmount);
1702         }
1703     }
1704 
1705     // ========== PRIVATE/INTERNAL FUNCTIONS =========
1706 
1707     function _depositReward(address _from, uint256 _amount) internal {
1708         // create message payload for L2
1709         ISynthetixBridgeToBase bridgeToBase;
1710         bytes memory messageData = abi.encodeWithSelector(bridgeToBase.finalizeRewardDeposit.selector, _from, _amount);
1711 
1712         // relay the message to this contract on L2 via L1 Messenger
1713         messenger().sendMessage(
1714             synthetixBridgeToBase(),
1715             messageData,
1716             uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Reward))
1717         );
1718 
1719         emit RewardDepositInitiated(_from, _amount);
1720     }
1721 
1722     function _initiateDeposit(address _to, uint256 _depositAmount) private {
1723         // Transfer SNX to L2
1724         // First, move the SNX into the deposit escrow
1725         synthetixERC20().transferFrom(msg.sender, synthetixBridgeEscrow(), _depositAmount);
1726         // create message payload for L2
1727         iOVM_L2DepositedToken bridgeToBase;
1728         bytes memory messageData = abi.encodeWithSelector(bridgeToBase.finalizeDeposit.selector, _to, _depositAmount);
1729 
1730         // relay the message to this contract on L2 via L1 Messenger
1731         messenger().sendMessage(
1732             synthetixBridgeToBase(),
1733             messageData,
1734             uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Deposit))
1735         );
1736 
1737         emit iOVM_L1TokenGateway.DepositInitiated(msg.sender, _to, _depositAmount);
1738     }
1739 
1740     function _migrateEscrow(uint256[][] memory _entryIDs) private {
1741         // loop through the entryID array
1742         for (uint256 i = 0; i < _entryIDs.length; i++) {
1743             // Cannot send more than MAX_ENTRIES_MIGRATED_PER_MESSAGE entries due to ovm gas restrictions
1744             require(_entryIDs[i].length <= MAX_ENTRIES_MIGRATED_PER_MESSAGE, "Exceeds max entries per migration");
1745             // Burn their reward escrow first
1746             // Note: escrowSummary would lose the fidelity of the weekly escrows, so this may not be sufficient
1747             uint256 escrowedAccountBalance;
1748             VestingEntries.VestingEntry[] memory vestingEntries;
1749             (escrowedAccountBalance, vestingEntries) = rewardEscrowV2().burnForMigration(msg.sender, _entryIDs[i]);
1750 
1751             // if there is an escrow amount to be migrated
1752             if (escrowedAccountBalance > 0) {
1753                 // NOTE: transfer SNX to synthetixBridgeEscrow because burnForMigration() transfers them to this contract.
1754                 synthetixERC20().transfer(synthetixBridgeEscrow(), escrowedAccountBalance);
1755                 // create message payload for L2
1756                 ISynthetixBridgeToBase bridgeToBase;
1757                 bytes memory messageData =
1758                     abi.encodeWithSelector(
1759                         bridgeToBase.finalizeEscrowMigration.selector,
1760                         msg.sender,
1761                         escrowedAccountBalance,
1762                         vestingEntries
1763                     );
1764                 // relay the message to this contract on L2 via L1 Messenger
1765                 messenger().sendMessage(
1766                     synthetixBridgeToBase(),
1767                     messageData,
1768                     uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Escrow))
1769                 );
1770 
1771                 emit ExportedVestingEntries(msg.sender, escrowedAccountBalance, vestingEntries);
1772             }
1773         }
1774     }
1775 
1776     // ========== EVENTS ==========
1777 
1778     event ExportedVestingEntries(
1779         address indexed account,
1780         uint256 escrowedAccountBalance,
1781         VestingEntries.VestingEntry[] vestingEntries
1782     );
1783 
1784     event RewardDepositInitiated(address indexed account, uint256 amount);
1785 
1786     event FeePeriodClosed(uint snxBackedDebt, uint totalDebtShares);
1787 }
1788 
1789     