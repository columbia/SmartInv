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
31 * Copyright (c) 2021 Synthetix
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
172     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
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
204     function liquidateDelinquentAccount(
205         address account,
206         uint susdAmount,
207         address liquidator
208     ) external returns (uint totalRedeemed, uint amountToLiquidate);
209 }
210 
211 
212 // Inheritance
213 
214 
215 // Internal references
216 
217 
218 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
219 contract AddressResolver is Owned, IAddressResolver {
220     mapping(bytes32 => address) public repository;
221 
222     constructor(address _owner) public Owned(_owner) {}
223 
224     /* ========== RESTRICTED FUNCTIONS ========== */
225 
226     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
227         require(names.length == destinations.length, "Input lengths must match");
228 
229         for (uint i = 0; i < names.length; i++) {
230             bytes32 name = names[i];
231             address destination = destinations[i];
232             repository[name] = destination;
233             emit AddressImported(name, destination);
234         }
235     }
236 
237     /* ========= PUBLIC FUNCTIONS ========== */
238 
239     function rebuildCaches(MixinResolver[] calldata destinations) external {
240         for (uint i = 0; i < destinations.length; i++) {
241             destinations[i].rebuildCache();
242         }
243     }
244 
245     /* ========== VIEWS ========== */
246 
247     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
248         for (uint i = 0; i < names.length; i++) {
249             if (repository[names[i]] != destinations[i]) {
250                 return false;
251             }
252         }
253         return true;
254     }
255 
256     function getAddress(bytes32 name) external view returns (address) {
257         return repository[name];
258     }
259 
260     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
261         address _foundAddress = repository[name];
262         require(_foundAddress != address(0), reason);
263         return _foundAddress;
264     }
265 
266     function getSynth(bytes32 key) external view returns (address) {
267         IIssuer issuer = IIssuer(repository["Issuer"]);
268         require(address(issuer) != address(0), "Cannot find Issuer address");
269         return address(issuer.synths(key));
270     }
271 
272     /* ========== EVENTS ========== */
273 
274     event AddressImported(bytes32 name, address destination);
275 }
276 
277 
278 // solhint-disable payable-fallback
279 
280 // https://docs.synthetix.io/contracts/source/contracts/readproxy
281 contract ReadProxy is Owned {
282     address public target;
283 
284     constructor(address _owner) public Owned(_owner) {}
285 
286     function setTarget(address _target) external onlyOwner {
287         target = _target;
288         emit TargetUpdated(target);
289     }
290 
291     function() external {
292         // The basics of a proxy read call
293         // Note that msg.sender in the underlying will always be the address of this contract.
294         assembly {
295             calldatacopy(0, 0, calldatasize)
296 
297             // Use of staticcall - this will revert if the underlying function mutates state
298             let result := staticcall(gas, sload(target_slot), 0, calldatasize, 0, 0)
299             returndatacopy(0, 0, returndatasize)
300 
301             if iszero(result) {
302                 revert(0, returndatasize)
303             }
304             return(0, returndatasize)
305         }
306     }
307 
308     event TargetUpdated(address newTarget);
309 }
310 
311 
312 // Inheritance
313 
314 
315 // Internal references
316 
317 
318 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
319 contract MixinResolver {
320     AddressResolver public resolver;
321 
322     mapping(bytes32 => address) private addressCache;
323 
324     constructor(address _resolver) internal {
325         resolver = AddressResolver(_resolver);
326     }
327 
328     /* ========== INTERNAL FUNCTIONS ========== */
329 
330     function combineArrays(bytes32[] memory first, bytes32[] memory second)
331         internal
332         pure
333         returns (bytes32[] memory combination)
334     {
335         combination = new bytes32[](first.length + second.length);
336 
337         for (uint i = 0; i < first.length; i++) {
338             combination[i] = first[i];
339         }
340 
341         for (uint j = 0; j < second.length; j++) {
342             combination[first.length + j] = second[j];
343         }
344     }
345 
346     /* ========== PUBLIC FUNCTIONS ========== */
347 
348     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
349     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
350 
351     function rebuildCache() public {
352         bytes32[] memory requiredAddresses = resolverAddressesRequired();
353         // The resolver must call this function whenver it updates its state
354         for (uint i = 0; i < requiredAddresses.length; i++) {
355             bytes32 name = requiredAddresses[i];
356             // Note: can only be invoked once the resolver has all the targets needed added
357             address destination =
358                 resolver.requireAndGetAddress(name, string(abi.encodePacked("Resolver missing target: ", name)));
359             addressCache[name] = destination;
360             emit CacheUpdated(name, destination);
361         }
362     }
363 
364     /* ========== VIEWS ========== */
365 
366     function isResolverCached() external view returns (bool) {
367         bytes32[] memory requiredAddresses = resolverAddressesRequired();
368         for (uint i = 0; i < requiredAddresses.length; i++) {
369             bytes32 name = requiredAddresses[i];
370             // false if our cache is invalid or if the resolver doesn't have the required address
371             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
372                 return false;
373             }
374         }
375 
376         return true;
377     }
378 
379     /* ========== INTERNAL FUNCTIONS ========== */
380 
381     function requireAndGetAddress(bytes32 name) internal view returns (address) {
382         address _foundAddress = addressCache[name];
383         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
384         return _foundAddress;
385     }
386 
387     /* ========== EVENTS ========== */
388 
389     event CacheUpdated(bytes32 name, address destination);
390 }
391 
392 
393 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
394 interface IFlexibleStorage {
395     // Views
396     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
397 
398     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
399 
400     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
401 
402     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
403 
404     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
405 
406     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
407 
408     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
409 
410     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
411 
412     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
413 
414     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
415 
416     // Mutative functions
417     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
418 
419     function deleteIntValue(bytes32 contractName, bytes32 record) external;
420 
421     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
422 
423     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
424 
425     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
426 
427     function setUIntValue(
428         bytes32 contractName,
429         bytes32 record,
430         uint value
431     ) external;
432 
433     function setUIntValues(
434         bytes32 contractName,
435         bytes32[] calldata records,
436         uint[] calldata values
437     ) external;
438 
439     function setIntValue(
440         bytes32 contractName,
441         bytes32 record,
442         int value
443     ) external;
444 
445     function setIntValues(
446         bytes32 contractName,
447         bytes32[] calldata records,
448         int[] calldata values
449     ) external;
450 
451     function setAddressValue(
452         bytes32 contractName,
453         bytes32 record,
454         address value
455     ) external;
456 
457     function setAddressValues(
458         bytes32 contractName,
459         bytes32[] calldata records,
460         address[] calldata values
461     ) external;
462 
463     function setBoolValue(
464         bytes32 contractName,
465         bytes32 record,
466         bool value
467     ) external;
468 
469     function setBoolValues(
470         bytes32 contractName,
471         bytes32[] calldata records,
472         bool[] calldata values
473     ) external;
474 
475     function setBytes32Value(
476         bytes32 contractName,
477         bytes32 record,
478         bytes32 value
479     ) external;
480 
481     function setBytes32Values(
482         bytes32 contractName,
483         bytes32[] calldata records,
484         bytes32[] calldata values
485     ) external;
486 }
487 
488 
489 // Internal references
490 
491 
492 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
493 contract MixinSystemSettings is MixinResolver {
494     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
495 
496     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
497     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
498     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
499     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
500     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
501     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
502     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
503     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
504     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
505     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
506     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
507     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
508     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
509     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
510     bytes32 internal constant SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT = "crossDomainDepositGasLimit";
511     bytes32 internal constant SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT = "crossDomainEscrowGasLimit";
512     bytes32 internal constant SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT = "crossDomainRewardGasLimit";
513     bytes32 internal constant SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT = "crossDomainWithdrawalGasLimit";
514 
515     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
516 
517     enum CrossDomainMessageGasLimits {Deposit, Escrow, Reward, Withdrawal}
518 
519     constructor(address _resolver) internal MixinResolver(_resolver) {}
520 
521     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
522         addresses = new bytes32[](1);
523         addresses[0] = CONTRACT_FLEXIBLESTORAGE;
524     }
525 
526     function flexibleStorage() internal view returns (IFlexibleStorage) {
527         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
528     }
529 
530     function _getGasLimitSetting(CrossDomainMessageGasLimits gasLimitType) internal pure returns (bytes32) {
531         if (gasLimitType == CrossDomainMessageGasLimits.Deposit) {
532             return SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT;
533         } else if (gasLimitType == CrossDomainMessageGasLimits.Escrow) {
534             return SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT;
535         } else if (gasLimitType == CrossDomainMessageGasLimits.Reward) {
536             return SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT;
537         } else if (gasLimitType == CrossDomainMessageGasLimits.Withdrawal) {
538             return SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT;
539         } else {
540             revert("Unknown gas limit type");
541         }
542     }
543 
544     function getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits gasLimitType) internal view returns (uint) {
545         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, _getGasLimitSetting(gasLimitType));
546     }
547 
548     function getTradingRewardsEnabled() internal view returns (bool) {
549         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
550     }
551 
552     function getWaitingPeriodSecs() internal view returns (uint) {
553         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
554     }
555 
556     function getPriceDeviationThresholdFactor() internal view returns (uint) {
557         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
558     }
559 
560     function getIssuanceRatio() internal view returns (uint) {
561         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
562         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
563     }
564 
565     function getFeePeriodDuration() internal view returns (uint) {
566         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
567         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
568     }
569 
570     function getTargetThreshold() internal view returns (uint) {
571         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
572         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
573     }
574 
575     function getLiquidationDelay() internal view returns (uint) {
576         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
577     }
578 
579     function getLiquidationRatio() internal view returns (uint) {
580         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
581     }
582 
583     function getLiquidationPenalty() internal view returns (uint) {
584         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
585     }
586 
587     function getRateStalePeriod() internal view returns (uint) {
588         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
589     }
590 
591     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
592         return
593             flexibleStorage().getUIntValue(
594                 SETTING_CONTRACT_NAME,
595                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
596             );
597     }
598 
599     function getMinimumStakeTime() internal view returns (uint) {
600         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
601     }
602 
603     function getAggregatorWarningFlags() internal view returns (address) {
604         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
605     }
606 
607     function getDebtSnapshotStaleTime() internal view returns (uint) {
608         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
609     }
610 }
611 
612 
613 pragma experimental ABIEncoderV2;
614 
615 interface IBaseSynthetixBridge {
616     function suspendInitiation() external;
617 
618     function resumeInitiation() external;
619 }
620 
621 
622 interface IVirtualSynth {
623     // Views
624     function balanceOfUnderlying(address account) external view returns (uint);
625 
626     function rate() external view returns (uint);
627 
628     function readyToSettle() external view returns (bool);
629 
630     function secsLeftInWaitingPeriod() external view returns (uint);
631 
632     function settled() external view returns (bool);
633 
634     function synth() external view returns (ISynth);
635 
636     // Mutative functions
637     function settle(address account) external;
638 }
639 
640 
641 // https://docs.synthetix.io/contracts/source/interfaces/isynthetix
642 interface ISynthetix {
643     // Views
644     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
645 
646     function availableCurrencyKeys() external view returns (bytes32[] memory);
647 
648     function availableSynthCount() external view returns (uint);
649 
650     function availableSynths(uint index) external view returns (ISynth);
651 
652     function collateral(address account) external view returns (uint);
653 
654     function collateralisationRatio(address issuer) external view returns (uint);
655 
656     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
657 
658     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
659 
660     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
661 
662     function remainingIssuableSynths(address issuer)
663         external
664         view
665         returns (
666             uint maxIssuable,
667             uint alreadyIssued,
668             uint totalSystemDebt
669         );
670 
671     function synths(bytes32 currencyKey) external view returns (ISynth);
672 
673     function synthsByAddress(address synthAddress) external view returns (bytes32);
674 
675     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
676 
677     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);
678 
679     function transferableSynthetix(address account) external view returns (uint transferable);
680 
681     // Mutative Functions
682     function burnSynths(uint amount) external;
683 
684     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
685 
686     function burnSynthsToTarget() external;
687 
688     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
689 
690     function exchange(
691         bytes32 sourceCurrencyKey,
692         uint sourceAmount,
693         bytes32 destinationCurrencyKey
694     ) external returns (uint amountReceived);
695 
696     function exchangeOnBehalf(
697         address exchangeForAddress,
698         bytes32 sourceCurrencyKey,
699         uint sourceAmount,
700         bytes32 destinationCurrencyKey
701     ) external returns (uint amountReceived);
702 
703     function exchangeWithTracking(
704         bytes32 sourceCurrencyKey,
705         uint sourceAmount,
706         bytes32 destinationCurrencyKey,
707         address originator,
708         bytes32 trackingCode
709     ) external returns (uint amountReceived);
710 
711     function exchangeOnBehalfWithTracking(
712         address exchangeForAddress,
713         bytes32 sourceCurrencyKey,
714         uint sourceAmount,
715         bytes32 destinationCurrencyKey,
716         address originator,
717         bytes32 trackingCode
718     ) external returns (uint amountReceived);
719 
720     function exchangeWithVirtual(
721         bytes32 sourceCurrencyKey,
722         uint sourceAmount,
723         bytes32 destinationCurrencyKey,
724         bytes32 trackingCode
725     ) external returns (uint amountReceived, IVirtualSynth vSynth);
726 
727     function issueMaxSynths() external;
728 
729     function issueMaxSynthsOnBehalf(address issueForAddress) external;
730 
731     function issueSynths(uint amount) external;
732 
733     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
734 
735     function mint() external returns (bool);
736 
737     function settle(bytes32 currencyKey)
738         external
739         returns (
740             uint reclaimed,
741             uint refunded,
742             uint numEntries
743         );
744 
745     // Liquidations
746     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
747 
748     // Restricted Functions
749 
750     function mintSecondary(address account, uint amount) external;
751 
752     function mintSecondaryRewards(uint amount) external;
753 
754     function burnSecondary(address account, uint amount) external;
755 }
756 
757 
758 library VestingEntries {
759     struct VestingEntry {
760         uint64 endTime;
761         uint256 escrowAmount;
762     }
763     struct VestingEntryWithID {
764         uint64 endTime;
765         uint256 escrowAmount;
766         uint256 entryID;
767     }
768 }
769 
770 interface IRewardEscrowV2 {
771     // Views
772     function balanceOf(address account) external view returns (uint);
773 
774     function numVestingEntries(address account) external view returns (uint);
775 
776     function totalEscrowedAccountBalance(address account) external view returns (uint);
777 
778     function totalVestedAccountBalance(address account) external view returns (uint);
779 
780     function getVestingQuantity(address account, uint256[] calldata entryIDs) external view returns (uint);
781 
782     function getVestingSchedules(
783         address account,
784         uint256 index,
785         uint256 pageSize
786     ) external view returns (VestingEntries.VestingEntryWithID[] memory);
787 
788     function getAccountVestingEntryIDs(
789         address account,
790         uint256 index,
791         uint256 pageSize
792     ) external view returns (uint256[] memory);
793 
794     function getVestingEntryClaimable(address account, uint256 entryID) external view returns (uint);
795 
796     function getVestingEntry(address account, uint256 entryID) external view returns (uint64, uint256);
797 
798     // Mutative functions
799     function vest(uint256[] calldata entryIDs) external;
800 
801     function createEscrowEntry(
802         address beneficiary,
803         uint256 deposit,
804         uint256 duration
805     ) external;
806 
807     function appendVestingEntry(
808         address account,
809         uint256 quantity,
810         uint256 duration
811     ) external;
812 
813     function migrateVestingSchedule(address _addressToMigrate) external;
814 
815     function migrateAccountEscrowBalances(
816         address[] calldata accounts,
817         uint256[] calldata escrowBalances,
818         uint256[] calldata vestedBalances
819     ) external;
820 
821     // Account Merging
822     function startMergingWindow() external;
823 
824     function mergeAccount(address accountToMerge, uint256[] calldata entryIDs) external;
825 
826     function nominateAccountToMerge(address account) external;
827 
828     function accountMergingIsOpen() external view returns (bool);
829 
830     // L2 Migration
831     function importVestingEntries(
832         address account,
833         uint256 escrowedAmount,
834         VestingEntries.VestingEntry[] calldata vestingEntries
835     ) external;
836 
837     // Return amount of SNX transfered to SynthetixBridgeToOptimism deposit contract
838     function burnForMigration(address account, uint256[] calldata entryIDs)
839         external
840         returns (uint256 escrowedAccountBalance, VestingEntries.VestingEntry[] memory vestingEntries);
841 }
842 
843 
844 // SPDX-License-Identifier: MIT
845 
846 
847 /**
848  * @title iAbs_BaseCrossDomainMessenger
849  */
850 interface iAbs_BaseCrossDomainMessenger {
851 
852     /**********
853      * Events *
854      **********/
855 
856     event SentMessage(bytes message);
857     event RelayedMessage(bytes32 msgHash);
858     event FailedRelayedMessage(bytes32 msgHash);
859 
860 
861     /*************
862      * Variables *
863      *************/
864 
865     function xDomainMessageSender() external view returns (address);
866 
867 
868     /********************
869      * Public Functions *
870      ********************/
871 
872     /**
873      * Sends a cross domain message to the target messenger.
874      * @param _target Target contract address.
875      * @param _message Message to send to the target.
876      * @param _gasLimit Gas limit for the provided message.
877      */
878     function sendMessage(
879         address _target,
880         bytes calldata _message,
881         uint32 _gasLimit
882     ) external;
883 }
884 
885 
886 // Inheritance
887 
888 
889 // Internal references
890 
891 
892 contract BaseSynthetixBridge is Owned, MixinSystemSettings, IBaseSynthetixBridge {
893     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
894     bytes32 private constant CONTRACT_EXT_MESSENGER = "ext:Messenger";
895     bytes32 internal constant CONTRACT_SYNTHETIX = "Synthetix";
896     bytes32 private constant CONTRACT_REWARDESCROW = "RewardEscrowV2";
897 
898     bool public initiationActive;
899 
900     // ========== CONSTRUCTOR ==========
901 
902     constructor(address _owner, address _resolver) public Owned(_owner) MixinSystemSettings(_resolver) {
903         initiationActive = true;
904     }
905 
906     // ========== INTERNALS ============
907 
908     function messenger() internal view returns (iAbs_BaseCrossDomainMessenger) {
909         return iAbs_BaseCrossDomainMessenger(requireAndGetAddress(CONTRACT_EXT_MESSENGER));
910     }
911 
912     function synthetix() internal view returns (ISynthetix) {
913         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX));
914     }
915 
916     function rewardEscrowV2() internal view returns (IRewardEscrowV2) {
917         return IRewardEscrowV2(requireAndGetAddress(CONTRACT_REWARDESCROW));
918     }
919 
920     function initiatingActive() internal view {
921         require(initiationActive, "Initiation deactivated");
922     }
923 
924     /* ========== VIEWS ========== */
925 
926     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
927         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
928         bytes32[] memory newAddresses = new bytes32[](3);
929         newAddresses[0] = CONTRACT_EXT_MESSENGER;
930         newAddresses[1] = CONTRACT_SYNTHETIX;
931         newAddresses[2] = CONTRACT_REWARDESCROW;
932         addresses = combineArrays(existingAddresses, newAddresses);
933     }
934 
935     // ========== MODIFIERS ============
936 
937     modifier requireInitiationActive() {
938         initiatingActive();
939         _;
940     }
941 
942     // ========= RESTRICTED FUNCTIONS ==============
943 
944     function suspendInitiation() external onlyOwner {
945         require(initiationActive, "Initiation suspended");
946         initiationActive = false;
947         emit InitiationSuspended();
948     }
949 
950     function resumeInitiation() external onlyOwner {
951         require(!initiationActive, "Initiation not suspended");
952         initiationActive = true;
953         emit InitiationResumed();
954     }
955 
956     // ========== EVENTS ==========
957 
958     event InitiationSuspended();
959 
960     event InitiationResumed();
961 }
962 
963 
964 interface ISynthetixBridgeToOptimism {
965     function migrateEscrow(uint256[][] calldata entryIDs) external;
966 
967     function depositReward(uint amount) external;
968 
969     function depositAndMigrateEscrow(uint256 depositAmount, uint256[][] calldata entryIDs) external;
970 }
971 
972 
973 // SPDX-License-Identifier: MIT
974 
975 
976 /**
977  * @title iOVM_L1TokenGateway
978  */
979 interface iOVM_L1TokenGateway {
980 
981     /**********
982      * Events *
983      **********/
984 
985     event DepositInitiated(
986         address indexed _from,
987         address _to,
988         uint256 _amount
989     );
990 
991     event WithdrawalFinalized(
992         address indexed _to,
993         uint256 _amount
994     );
995 
996 
997     /********************
998      * Public Functions *
999      ********************/
1000 
1001     function deposit(
1002         uint _amount
1003     )
1004         external;
1005 
1006     function depositTo(
1007         address _to,
1008         uint _amount
1009     )
1010         external;
1011 
1012 
1013     /*************************
1014      * Cross-chain Functions *
1015      *************************/
1016 
1017     function finalizeWithdrawal(
1018         address _to,
1019         uint _amount
1020     )
1021         external;
1022 }
1023 
1024 
1025 /**
1026  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1027  * the optional functions; to access them see `ERC20Detailed`.
1028  */
1029 interface IERC20 {
1030     /**
1031      * @dev Returns the amount of tokens in existence.
1032      */
1033     function totalSupply() external view returns (uint256);
1034 
1035     /**
1036      * @dev Returns the amount of tokens owned by `account`.
1037      */
1038     function balanceOf(address account) external view returns (uint256);
1039 
1040     /**
1041      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1042      *
1043      * Returns a boolean value indicating whether the operation succeeded.
1044      *
1045      * Emits a `Transfer` event.
1046      */
1047     function transfer(address recipient, uint256 amount) external returns (bool);
1048 
1049     /**
1050      * @dev Returns the remaining number of tokens that `spender` will be
1051      * allowed to spend on behalf of `owner` through `transferFrom`. This is
1052      * zero by default.
1053      *
1054      * This value changes when `approve` or `transferFrom` are called.
1055      */
1056     function allowance(address owner, address spender) external view returns (uint256);
1057 
1058     /**
1059      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1060      *
1061      * Returns a boolean value indicating whether the operation succeeded.
1062      *
1063      * > Beware that changing an allowance with this method brings the risk
1064      * that someone may use both the old and the new allowance by unfortunate
1065      * transaction ordering. One possible solution to mitigate this race
1066      * condition is to first reduce the spender's allowance to 0 and set the
1067      * desired value afterwards:
1068      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1069      *
1070      * Emits an `Approval` event.
1071      */
1072     function approve(address spender, uint256 amount) external returns (bool);
1073 
1074     /**
1075      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1076      * allowance mechanism. `amount` is then deducted from the caller's
1077      * allowance.
1078      *
1079      * Returns a boolean value indicating whether the operation succeeded.
1080      *
1081      * Emits a `Transfer` event.
1082      */
1083     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1084 
1085     /**
1086      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1087      * another (`to`).
1088      *
1089      * Note that `value` may be zero.
1090      */
1091     event Transfer(address indexed from, address indexed to, uint256 value);
1092 
1093     /**
1094      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1095      * a call to `approve`. `value` is the new allowance.
1096      */
1097     event Approval(address indexed owner, address indexed spender, uint256 value);
1098 }
1099 
1100 
1101 /**
1102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1103  * checks.
1104  *
1105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1106  * in bugs, because programmers usually assume that an overflow raises an
1107  * error, which is the standard behavior in high level programming languages.
1108  * `SafeMath` restores this intuition by reverting the transaction when an
1109  * operation overflows.
1110  *
1111  * Using this library instead of the unchecked operations eliminates an entire
1112  * class of bugs, so it's recommended to use it always.
1113  */
1114 library SafeMath {
1115     /**
1116      * @dev Returns the addition of two unsigned integers, reverting on
1117      * overflow.
1118      *
1119      * Counterpart to Solidity's `+` operator.
1120      *
1121      * Requirements:
1122      * - Addition cannot overflow.
1123      */
1124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1125         uint256 c = a + b;
1126         require(c >= a, "SafeMath: addition overflow");
1127 
1128         return c;
1129     }
1130 
1131     /**
1132      * @dev Returns the subtraction of two unsigned integers, reverting on
1133      * overflow (when the result is negative).
1134      *
1135      * Counterpart to Solidity's `-` operator.
1136      *
1137      * Requirements:
1138      * - Subtraction cannot overflow.
1139      */
1140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1141         require(b <= a, "SafeMath: subtraction overflow");
1142         uint256 c = a - b;
1143 
1144         return c;
1145     }
1146 
1147     /**
1148      * @dev Returns the multiplication of two unsigned integers, reverting on
1149      * overflow.
1150      *
1151      * Counterpart to Solidity's `*` operator.
1152      *
1153      * Requirements:
1154      * - Multiplication cannot overflow.
1155      */
1156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1158         // benefit is lost if 'b' is also tested.
1159         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1160         if (a == 0) {
1161             return 0;
1162         }
1163 
1164         uint256 c = a * b;
1165         require(c / a == b, "SafeMath: multiplication overflow");
1166 
1167         return c;
1168     }
1169 
1170     /**
1171      * @dev Returns the integer division of two unsigned integers. Reverts on
1172      * division by zero. The result is rounded towards zero.
1173      *
1174      * Counterpart to Solidity's `/` operator. Note: this function uses a
1175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1176      * uses an invalid opcode to revert (consuming all remaining gas).
1177      *
1178      * Requirements:
1179      * - The divisor cannot be zero.
1180      */
1181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1182         // Solidity only automatically asserts when dividing by 0
1183         require(b > 0, "SafeMath: division by zero");
1184         uint256 c = a / b;
1185         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1186 
1187         return c;
1188     }
1189 
1190     /**
1191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1192      * Reverts when dividing by zero.
1193      *
1194      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1195      * opcode (which leaves remaining gas untouched) while Solidity uses an
1196      * invalid opcode to revert (consuming all remaining gas).
1197      *
1198      * Requirements:
1199      * - The divisor cannot be zero.
1200      */
1201     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1202         require(b != 0, "SafeMath: modulo by zero");
1203         return a % b;
1204     }
1205 }
1206 
1207 
1208 /**
1209  * @dev Collection of functions related to the address type,
1210  */
1211 library Address {
1212     /**
1213      * @dev Returns true if `account` is a contract.
1214      *
1215      * This test is non-exhaustive, and there may be false-negatives: during the
1216      * execution of a contract's constructor, its address will be reported as
1217      * not containing a contract.
1218      *
1219      * > It is unsafe to assume that an address for which this function returns
1220      * false is an externally-owned account (EOA) and not a contract.
1221      */
1222     function isContract(address account) internal view returns (bool) {
1223         // This method relies in extcodesize, which returns 0 for contracts in
1224         // construction, since the code is only stored at the end of the
1225         // constructor execution.
1226 
1227         uint256 size;
1228         // solhint-disable-next-line no-inline-assembly
1229         assembly { size := extcodesize(account) }
1230         return size > 0;
1231     }
1232 }
1233 
1234 
1235 /**
1236  * @title SafeERC20
1237  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1238  * contract returns false). Tokens that return no value (and instead revert or
1239  * throw on failure) are also supported, non-reverting calls are assumed to be
1240  * successful.
1241  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1242  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1243  */
1244 library SafeERC20 {
1245     using SafeMath for uint256;
1246     using Address for address;
1247 
1248     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1249         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1250     }
1251 
1252     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1253         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1254     }
1255 
1256     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1257         // safeApprove should only be called when setting an initial allowance,
1258         // or when resetting it to zero. To increase and decrease it, use
1259         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1260         // solhint-disable-next-line max-line-length
1261         require((value == 0) || (token.allowance(address(this), spender) == 0),
1262             "SafeERC20: approve from non-zero to non-zero allowance"
1263         );
1264         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1265     }
1266 
1267     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1268         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1269         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1270     }
1271 
1272     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1273         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
1274         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1275     }
1276 
1277     /**
1278      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1279      * on the return value: the return value is optional (but if data is returned, it must not be false).
1280      * @param token The token targeted by the call.
1281      * @param data The call data (encoded using abi.encode or one of its variants).
1282      */
1283     function callOptionalReturn(IERC20 token, bytes memory data) private {
1284         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1285         // we're implementing it ourselves.
1286 
1287         // A Solidity high level call has three parts:
1288         //  1. The target address is checked to verify it contains contract code
1289         //  2. The call itself is made, and success asserted
1290         //  3. The return value is decoded, which in turn checks the size of the returned data.
1291         // solhint-disable-next-line max-line-length
1292         require(address(token).isContract(), "SafeERC20: call to non-contract");
1293 
1294         // solhint-disable-next-line avoid-low-level-calls
1295         (bool success, bytes memory returndata) = address(token).call(data);
1296         require(success, "SafeERC20: low-level call failed");
1297 
1298         if (returndata.length > 0) { // Return data is optional
1299             // solhint-disable-next-line max-line-length
1300             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1301         }
1302     }
1303 }
1304 
1305 
1306 interface ISynthetixBridgeToBase {
1307     // invoked by the xDomain messenger on L2
1308     function finalizeEscrowMigration(
1309         address account,
1310         uint256 escrowedAmount,
1311         VestingEntries.VestingEntry[] calldata vestingEntries
1312     ) external;
1313 
1314     // invoked by the xDomain messenger on L2
1315     function finalizeRewardDeposit(address from, uint amount) external;
1316 }
1317 
1318 
1319 // SPDX-License-Identifier: MIT
1320 
1321 
1322 /**
1323  * @title iOVM_L2DepositedToken
1324  */
1325 interface iOVM_L2DepositedToken {
1326 
1327     /**********
1328      * Events *
1329      **********/
1330 
1331     event WithdrawalInitiated(
1332         address indexed _from,
1333         address _to,
1334         uint256 _amount
1335     );
1336 
1337     event DepositFinalized(
1338         address indexed _to,
1339         uint256 _amount
1340     );
1341 
1342 
1343     /********************
1344      * Public Functions *
1345      ********************/
1346 
1347     function withdraw(
1348         uint _amount
1349     )
1350         external;
1351 
1352     function withdrawTo(
1353         address _to,
1354         uint _amount
1355     )
1356         external;
1357 
1358 
1359     /*************************
1360      * Cross-chain Functions *
1361      *************************/
1362 
1363     function finalizeDeposit(
1364         address _to,
1365         uint _amount
1366     )
1367         external;
1368 }
1369 
1370 
1371 // Inheritance
1372 
1373 
1374 // Internal references
1375 
1376 
1377 contract SynthetixBridgeToOptimism is BaseSynthetixBridge, ISynthetixBridgeToOptimism, iOVM_L1TokenGateway {
1378     using SafeERC20 for IERC20;
1379 
1380     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1381     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1382     bytes32 private constant CONTRACT_REWARDSDISTRIBUTION = "RewardsDistribution";
1383     bytes32 private constant CONTRACT_OVM_SYNTHETIXBRIDGETOBASE = "ovm:SynthetixBridgeToBase";
1384     bytes32 private constant CONTRACT_SYNTHETIXBRIDGEESCROW = "SynthetixBridgeEscrow";
1385 
1386     uint8 private constant MAX_ENTRIES_MIGRATED_PER_MESSAGE = 26;
1387 
1388     // ========== CONSTRUCTOR ==========
1389 
1390     constructor(address _owner, address _resolver) public BaseSynthetixBridge(_owner, _resolver) {}
1391 
1392     // ========== INTERNALS ============
1393 
1394     function synthetixERC20() internal view returns (IERC20) {
1395         return IERC20(requireAndGetAddress(CONTRACT_SYNTHETIX));
1396     }
1397 
1398     function issuer() internal view returns (IIssuer) {
1399         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1400     }
1401 
1402     function rewardsDistribution() internal view returns (address) {
1403         return requireAndGetAddress(CONTRACT_REWARDSDISTRIBUTION);
1404     }
1405 
1406     function synthetixBridgeToBase() internal view returns (address) {
1407         return requireAndGetAddress(CONTRACT_OVM_SYNTHETIXBRIDGETOBASE);
1408     }
1409 
1410     function synthetixBridgeEscrow() internal view returns (address) {
1411         return requireAndGetAddress(CONTRACT_SYNTHETIXBRIDGEESCROW);
1412     }
1413 
1414     function hasZeroDebt() internal view {
1415         require(issuer().debtBalanceOf(msg.sender, "sUSD") == 0, "Cannot deposit or migrate with debt");
1416     }
1417 
1418     /* ========== VIEWS ========== */
1419 
1420     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1421         bytes32[] memory existingAddresses = BaseSynthetixBridge.resolverAddressesRequired();
1422         bytes32[] memory newAddresses = new bytes32[](4);
1423         newAddresses[0] = CONTRACT_ISSUER;
1424         newAddresses[1] = CONTRACT_REWARDSDISTRIBUTION;
1425         newAddresses[2] = CONTRACT_OVM_SYNTHETIXBRIDGETOBASE;
1426         newAddresses[3] = CONTRACT_SYNTHETIXBRIDGEESCROW;
1427         addresses = combineArrays(existingAddresses, newAddresses);
1428     }
1429 
1430     // ========== MODIFIERS ============
1431 
1432     modifier requireZeroDebt() {
1433         hasZeroDebt();
1434         _;
1435     }
1436 
1437     // ========== PUBLIC FUNCTIONS =========
1438 
1439     function deposit(uint256 amount) external requireInitiationActive requireZeroDebt {
1440         _initiateDeposit(msg.sender, amount);
1441     }
1442 
1443     function depositTo(address to, uint amount) external requireInitiationActive requireZeroDebt {
1444         _initiateDeposit(to, amount);
1445     }
1446 
1447     function migrateEscrow(uint256[][] memory entryIDs) public requireInitiationActive requireZeroDebt {
1448         _migrateEscrow(entryIDs);
1449     }
1450 
1451     // invoked by a generous user on L1
1452     function depositReward(uint amount) external requireInitiationActive {
1453         // move the SNX into the deposit escrow
1454         synthetixERC20().transferFrom(msg.sender, synthetixBridgeEscrow(), amount);
1455 
1456         _depositReward(msg.sender, amount);
1457     }
1458 
1459     // forward any accidental tokens sent here to the escrow
1460     function forwardTokensToEscrow(address token) external {
1461         IERC20 erc20 = IERC20(token);
1462         erc20.safeTransfer(synthetixBridgeEscrow(), erc20.balanceOf(address(this)));
1463     }
1464 
1465     // ========= RESTRICTED FUNCTIONS ==============
1466 
1467     // invoked by Messenger on L1 after L2 waiting period elapses
1468     function finalizeWithdrawal(address to, uint256 amount) external {
1469         // ensure function only callable from L2 Bridge via messenger (aka relayer)
1470         require(msg.sender == address(messenger()), "Only the relayer can call this");
1471         require(messenger().xDomainMessageSender() == synthetixBridgeToBase(), "Only the L2 bridge can invoke");
1472 
1473         // transfer amount back to user
1474         synthetixERC20().transferFrom(synthetixBridgeEscrow(), to, amount);
1475 
1476         // no escrow actions - escrow remains on L2
1477         emit iOVM_L1TokenGateway.WithdrawalFinalized(to, amount);
1478     }
1479 
1480     // invoked by RewardsDistribution on L1 (takes SNX)
1481     function notifyRewardAmount(uint256 amount) external {
1482         require(msg.sender == address(rewardsDistribution()), "Caller is not RewardsDistribution contract");
1483 
1484         // NOTE: transfer SNX to synthetixBridgeEscrow because RewardsDistribution transfers them initially to this contract.
1485         synthetixERC20().transfer(synthetixBridgeEscrow(), amount);
1486 
1487         // to be here means I've been given an amount of SNX to distribute onto L2
1488         _depositReward(msg.sender, amount);
1489     }
1490 
1491     function depositAndMigrateEscrow(uint256 depositAmount, uint256[][] memory entryIDs)
1492         public
1493         requireInitiationActive
1494         requireZeroDebt
1495     {
1496         if (entryIDs.length > 0) {
1497             _migrateEscrow(entryIDs);
1498         }
1499 
1500         if (depositAmount > 0) {
1501             _initiateDeposit(msg.sender, depositAmount);
1502         }
1503     }
1504 
1505     // ========== PRIVATE/INTERNAL FUNCTIONS =========
1506 
1507     function _depositReward(address _from, uint256 _amount) internal {
1508         // create message payload for L2
1509         ISynthetixBridgeToBase bridgeToBase;
1510         bytes memory messageData = abi.encodeWithSelector(bridgeToBase.finalizeRewardDeposit.selector, _from, _amount);
1511 
1512         // relay the message to this contract on L2 via L1 Messenger
1513         messenger().sendMessage(
1514             synthetixBridgeToBase(),
1515             messageData,
1516             uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Reward))
1517         );
1518 
1519         emit RewardDepositInitiated(_from, _amount);
1520     }
1521 
1522     function _initiateDeposit(address _to, uint256 _depositAmount) private {
1523         // Transfer SNX to L2
1524         // First, move the SNX into the deposit escrow
1525         synthetixERC20().transferFrom(msg.sender, synthetixBridgeEscrow(), _depositAmount);
1526         // create message payload for L2
1527         iOVM_L2DepositedToken bridgeToBase;
1528         bytes memory messageData = abi.encodeWithSelector(bridgeToBase.finalizeDeposit.selector, _to, _depositAmount);
1529 
1530         // relay the message to this contract on L2 via L1 Messenger
1531         messenger().sendMessage(
1532             synthetixBridgeToBase(),
1533             messageData,
1534             uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Deposit))
1535         );
1536 
1537         emit iOVM_L1TokenGateway.DepositInitiated(msg.sender, _to, _depositAmount);
1538     }
1539 
1540     function _migrateEscrow(uint256[][] memory _entryIDs) private {
1541         // loop through the entryID array
1542         for (uint256 i = 0; i < _entryIDs.length; i++) {
1543             // Cannot send more than MAX_ENTRIES_MIGRATED_PER_MESSAGE entries due to ovm gas restrictions
1544             require(_entryIDs[i].length <= MAX_ENTRIES_MIGRATED_PER_MESSAGE, "Exceeds max entries per migration");
1545             // Burn their reward escrow first
1546             // Note: escrowSummary would lose the fidelity of the weekly escrows, so this may not be sufficient
1547             uint256 escrowedAccountBalance;
1548             VestingEntries.VestingEntry[] memory vestingEntries;
1549             (escrowedAccountBalance, vestingEntries) = rewardEscrowV2().burnForMigration(msg.sender, _entryIDs[i]);
1550 
1551             // if there is an escrow amount to be migrated
1552             if (escrowedAccountBalance > 0) {
1553                 // NOTE: transfer SNX to synthetixBridgeEscrow because burnForMigration() transfers them to this contract.
1554                 synthetixERC20().transfer(synthetixBridgeEscrow(), escrowedAccountBalance);
1555                 // create message payload for L2
1556                 ISynthetixBridgeToBase bridgeToBase;
1557                 bytes memory messageData =
1558                     abi.encodeWithSelector(
1559                         bridgeToBase.finalizeEscrowMigration.selector,
1560                         msg.sender,
1561                         escrowedAccountBalance,
1562                         vestingEntries
1563                     );
1564                 // relay the message to this contract on L2 via L1 Messenger
1565                 messenger().sendMessage(
1566                     synthetixBridgeToBase(),
1567                     messageData,
1568                     uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Escrow))
1569                 );
1570 
1571                 emit ExportedVestingEntries(msg.sender, escrowedAccountBalance, vestingEntries);
1572             }
1573         }
1574     }
1575 
1576     // ========== EVENTS ==========
1577 
1578     event ExportedVestingEntries(
1579         address indexed account,
1580         uint256 escrowedAccountBalance,
1581         VestingEntries.VestingEntry[] vestingEntries
1582     );
1583 
1584     event RewardDepositInitiated(address indexed account, uint256 amount);
1585 }
1586 
1587     