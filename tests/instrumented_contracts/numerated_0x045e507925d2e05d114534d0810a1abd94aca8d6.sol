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
14 *	- IAddressResolver
15 *	- ISynthetixBridgeToOptimism
16 *	- MixinResolver
17 *	- MixinSystemSettings
18 *	- Owned
19 * Libraries: 
20 *	- VestingEntries
21 *
22 * MIT License
23 * ===========
24 *
25 * Copyright (c) 2021 Synthetix
26 *
27 * Permission is hereby granted, free of charge, to any person obtaining a copy
28 * of this software and associated documentation files (the "Software"), to deal
29 * in the Software without restriction, including without limitation the rights
30 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
31 * copies of the Software, and to permit persons to whom the Software is
32 * furnished to do so, subject to the following conditions:
33 *
34 * The above copyright notice and this permission notice shall be included in all
35 * copies or substantial portions of the Software.
36 *
37 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
38 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
39 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
40 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
41 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
42 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
43 */
44 
45 
46 
47 pragma solidity ^0.5.16;
48 
49 
50 // https://docs.synthetix.io/contracts/source/contracts/owned
51 contract Owned {
52     address public owner;
53     address public nominatedOwner;
54 
55     constructor(address _owner) public {
56         require(_owner != address(0), "Owner address cannot be 0");
57         owner = _owner;
58         emit OwnerChanged(address(0), _owner);
59     }
60 
61     function nominateNewOwner(address _owner) external onlyOwner {
62         nominatedOwner = _owner;
63         emit OwnerNominated(_owner);
64     }
65 
66     function acceptOwnership() external {
67         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
68         emit OwnerChanged(owner, nominatedOwner);
69         owner = nominatedOwner;
70         nominatedOwner = address(0);
71     }
72 
73     modifier onlyOwner {
74         _onlyOwner();
75         _;
76     }
77 
78     function _onlyOwner() private view {
79         require(msg.sender == owner, "Only the contract owner may perform this action");
80     }
81 
82     event OwnerNominated(address newOwner);
83     event OwnerChanged(address oldOwner, address newOwner);
84 }
85 
86 
87 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
88 interface IAddressResolver {
89     function getAddress(bytes32 name) external view returns (address);
90 
91     function getSynth(bytes32 key) external view returns (address);
92 
93     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
94 }
95 
96 
97 // https://docs.synthetix.io/contracts/source/interfaces/isynth
98 interface ISynth {
99     // Views
100     function currencyKey() external view returns (bytes32);
101 
102     function transferableSynths(address account) external view returns (uint);
103 
104     // Mutative functions
105     function transferAndSettle(address to, uint value) external returns (bool);
106 
107     function transferFromAndSettle(
108         address from,
109         address to,
110         uint value
111     ) external returns (bool);
112 
113     // Restricted: used internally to Synthetix
114     function burn(address account, uint amount) external;
115 
116     function issue(address account, uint amount) external;
117 }
118 
119 
120 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
121 interface IIssuer {
122     // Views
123     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
124 
125     function availableCurrencyKeys() external view returns (bytes32[] memory);
126 
127     function availableSynthCount() external view returns (uint);
128 
129     function availableSynths(uint index) external view returns (ISynth);
130 
131     function canBurnSynths(address account) external view returns (bool);
132 
133     function collateral(address account) external view returns (uint);
134 
135     function collateralisationRatio(address issuer) external view returns (uint);
136 
137     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
138         external
139         view
140         returns (uint cratio, bool anyRateIsInvalid);
141 
142     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
143 
144     function issuanceRatio() external view returns (uint);
145 
146     function lastIssueEvent(address account) external view returns (uint);
147 
148     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
149 
150     function minimumStakeTime() external view returns (uint);
151 
152     function remainingIssuableSynths(address issuer)
153         external
154         view
155         returns (
156             uint maxIssuable,
157             uint alreadyIssued,
158             uint totalSystemDebt
159         );
160 
161     function synths(bytes32 currencyKey) external view returns (ISynth);
162 
163     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
164 
165     function synthsByAddress(address synthAddress) external view returns (bytes32);
166 
167     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
168 
169     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
170         external
171         view
172         returns (uint transferable, bool anyRateIsInvalid);
173 
174     // Restricted: used internally to Synthetix
175     function issueSynths(address from, uint amount) external;
176 
177     function issueSynthsOnBehalf(
178         address issueFor,
179         address from,
180         uint amount
181     ) external;
182 
183     function issueMaxSynths(address from) external;
184 
185     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
186 
187     function burnSynths(address from, uint amount) external;
188 
189     function burnSynthsOnBehalf(
190         address burnForAddress,
191         address from,
192         uint amount
193     ) external;
194 
195     function burnSynthsToTarget(address from) external;
196 
197     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
198 
199     function liquidateDelinquentAccount(
200         address account,
201         uint susdAmount,
202         address liquidator
203     ) external returns (uint totalRedeemed, uint amountToLiquidate);
204 }
205 
206 
207 // Inheritance
208 
209 
210 // Internal references
211 
212 
213 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
214 contract AddressResolver is Owned, IAddressResolver {
215     mapping(bytes32 => address) public repository;
216 
217     constructor(address _owner) public Owned(_owner) {}
218 
219     /* ========== RESTRICTED FUNCTIONS ========== */
220 
221     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
222         require(names.length == destinations.length, "Input lengths must match");
223 
224         for (uint i = 0; i < names.length; i++) {
225             bytes32 name = names[i];
226             address destination = destinations[i];
227             repository[name] = destination;
228             emit AddressImported(name, destination);
229         }
230     }
231 
232     /* ========= PUBLIC FUNCTIONS ========== */
233 
234     function rebuildCaches(MixinResolver[] calldata destinations) external {
235         for (uint i = 0; i < destinations.length; i++) {
236             destinations[i].rebuildCache();
237         }
238     }
239 
240     /* ========== VIEWS ========== */
241 
242     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
243         for (uint i = 0; i < names.length; i++) {
244             if (repository[names[i]] != destinations[i]) {
245                 return false;
246             }
247         }
248         return true;
249     }
250 
251     function getAddress(bytes32 name) external view returns (address) {
252         return repository[name];
253     }
254 
255     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
256         address _foundAddress = repository[name];
257         require(_foundAddress != address(0), reason);
258         return _foundAddress;
259     }
260 
261     function getSynth(bytes32 key) external view returns (address) {
262         IIssuer issuer = IIssuer(repository["Issuer"]);
263         require(address(issuer) != address(0), "Cannot find Issuer address");
264         return address(issuer.synths(key));
265     }
266 
267     /* ========== EVENTS ========== */
268 
269     event AddressImported(bytes32 name, address destination);
270 }
271 
272 
273 // solhint-disable payable-fallback
274 
275 // https://docs.synthetix.io/contracts/source/contracts/readproxy
276 contract ReadProxy is Owned {
277     address public target;
278 
279     constructor(address _owner) public Owned(_owner) {}
280 
281     function setTarget(address _target) external onlyOwner {
282         target = _target;
283         emit TargetUpdated(target);
284     }
285 
286     function() external {
287         // The basics of a proxy read call
288         // Note that msg.sender in the underlying will always be the address of this contract.
289         assembly {
290             calldatacopy(0, 0, calldatasize)
291 
292             // Use of staticcall - this will revert if the underlying function mutates state
293             let result := staticcall(gas, sload(target_slot), 0, calldatasize, 0, 0)
294             returndatacopy(0, 0, returndatasize)
295 
296             if iszero(result) {
297                 revert(0, returndatasize)
298             }
299             return(0, returndatasize)
300         }
301     }
302 
303     event TargetUpdated(address newTarget);
304 }
305 
306 
307 // Inheritance
308 
309 
310 // Internal references
311 
312 
313 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
314 contract MixinResolver {
315     AddressResolver public resolver;
316 
317     mapping(bytes32 => address) private addressCache;
318 
319     constructor(address _resolver) internal {
320         resolver = AddressResolver(_resolver);
321     }
322 
323     /* ========== INTERNAL FUNCTIONS ========== */
324 
325     function combineArrays(bytes32[] memory first, bytes32[] memory second)
326         internal
327         pure
328         returns (bytes32[] memory combination)
329     {
330         combination = new bytes32[](first.length + second.length);
331 
332         for (uint i = 0; i < first.length; i++) {
333             combination[i] = first[i];
334         }
335 
336         for (uint j = 0; j < second.length; j++) {
337             combination[first.length + j] = second[j];
338         }
339     }
340 
341     /* ========== PUBLIC FUNCTIONS ========== */
342 
343     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
344     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
345 
346     function rebuildCache() public {
347         bytes32[] memory requiredAddresses = resolverAddressesRequired();
348         // The resolver must call this function whenver it updates its state
349         for (uint i = 0; i < requiredAddresses.length; i++) {
350             bytes32 name = requiredAddresses[i];
351             // Note: can only be invoked once the resolver has all the targets needed added
352             address destination = resolver.requireAndGetAddress(
353                 name,
354                 string(abi.encodePacked("Resolver missing target: ", name))
355             );
356             addressCache[name] = destination;
357             emit CacheUpdated(name, destination);
358         }
359     }
360 
361     /* ========== VIEWS ========== */
362 
363     function isResolverCached() external view returns (bool) {
364         bytes32[] memory requiredAddresses = resolverAddressesRequired();
365         for (uint i = 0; i < requiredAddresses.length; i++) {
366             bytes32 name = requiredAddresses[i];
367             // false if our cache is invalid or if the resolver doesn't have the required address
368             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
369                 return false;
370             }
371         }
372 
373         return true;
374     }
375 
376     /* ========== INTERNAL FUNCTIONS ========== */
377 
378     function requireAndGetAddress(bytes32 name) internal view returns (address) {
379         address _foundAddress = addressCache[name];
380         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
381         return _foundAddress;
382     }
383 
384     /* ========== EVENTS ========== */
385 
386     event CacheUpdated(bytes32 name, address destination);
387 }
388 
389 
390 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
391 interface IFlexibleStorage {
392     // Views
393     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
394 
395     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
396 
397     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
398 
399     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
400 
401     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
402 
403     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
404 
405     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
406 
407     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
408 
409     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
410 
411     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
412 
413     // Mutative functions
414     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
415 
416     function deleteIntValue(bytes32 contractName, bytes32 record) external;
417 
418     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
419 
420     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
421 
422     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
423 
424     function setUIntValue(
425         bytes32 contractName,
426         bytes32 record,
427         uint value
428     ) external;
429 
430     function setUIntValues(
431         bytes32 contractName,
432         bytes32[] calldata records,
433         uint[] calldata values
434     ) external;
435 
436     function setIntValue(
437         bytes32 contractName,
438         bytes32 record,
439         int value
440     ) external;
441 
442     function setIntValues(
443         bytes32 contractName,
444         bytes32[] calldata records,
445         int[] calldata values
446     ) external;
447 
448     function setAddressValue(
449         bytes32 contractName,
450         bytes32 record,
451         address value
452     ) external;
453 
454     function setAddressValues(
455         bytes32 contractName,
456         bytes32[] calldata records,
457         address[] calldata values
458     ) external;
459 
460     function setBoolValue(
461         bytes32 contractName,
462         bytes32 record,
463         bool value
464     ) external;
465 
466     function setBoolValues(
467         bytes32 contractName,
468         bytes32[] calldata records,
469         bool[] calldata values
470     ) external;
471 
472     function setBytes32Value(
473         bytes32 contractName,
474         bytes32 record,
475         bytes32 value
476     ) external;
477 
478     function setBytes32Values(
479         bytes32 contractName,
480         bytes32[] calldata records,
481         bytes32[] calldata values
482     ) external;
483 }
484 
485 
486 // Internal references
487 
488 
489 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
490 contract MixinSystemSettings is MixinResolver {
491     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
492 
493     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
494     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
495     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
496     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
497     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
498     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
499     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
500     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
501     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
502     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
503     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
504     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
505     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
506     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
507     bytes32 internal constant SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT = "crossDomainDepositGasLimit";
508     bytes32 internal constant SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT = "crossDomainEscrowGasLimit";
509     bytes32 internal constant SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT = "crossDomainRewardGasLimit";
510     bytes32 internal constant SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT = "crossDomainWithdrawalGasLimit";
511 
512     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
513 
514     enum CrossDomainMessageGasLimits {Deposit, Escrow, Reward, Withdrawal}
515 
516     constructor(address _resolver) internal MixinResolver(_resolver) {}
517 
518     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
519         addresses = new bytes32[](1);
520         addresses[0] = CONTRACT_FLEXIBLESTORAGE;
521     }
522 
523     function flexibleStorage() internal view returns (IFlexibleStorage) {
524         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
525     }
526 
527     function _getGasLimitSetting(CrossDomainMessageGasLimits gasLimitType) internal pure returns (bytes32) {
528         if (gasLimitType == CrossDomainMessageGasLimits.Deposit) {
529             return SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT;
530         } else if (gasLimitType == CrossDomainMessageGasLimits.Escrow) {
531             return SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT;
532         } else if (gasLimitType == CrossDomainMessageGasLimits.Reward) {
533             return SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT;
534         } else if (gasLimitType == CrossDomainMessageGasLimits.Withdrawal) {
535             return SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT;
536         } else {
537             revert("Unknown gas limit type");
538         }
539     }
540 
541     function getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits gasLimitType) internal view returns (uint) {
542         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, _getGasLimitSetting(gasLimitType));
543     }
544 
545     function getTradingRewardsEnabled() internal view returns (bool) {
546         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
547     }
548 
549     function getWaitingPeriodSecs() internal view returns (uint) {
550         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
551     }
552 
553     function getPriceDeviationThresholdFactor() internal view returns (uint) {
554         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
555     }
556 
557     function getIssuanceRatio() internal view returns (uint) {
558         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
559         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
560     }
561 
562     function getFeePeriodDuration() internal view returns (uint) {
563         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
564         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
565     }
566 
567     function getTargetThreshold() internal view returns (uint) {
568         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
569         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
570     }
571 
572     function getLiquidationDelay() internal view returns (uint) {
573         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
574     }
575 
576     function getLiquidationRatio() internal view returns (uint) {
577         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
578     }
579 
580     function getLiquidationPenalty() internal view returns (uint) {
581         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
582     }
583 
584     function getRateStalePeriod() internal view returns (uint) {
585         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
586     }
587 
588     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
589         return
590             flexibleStorage().getUIntValue(
591                 SETTING_CONTRACT_NAME,
592                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
593             );
594     }
595 
596     function getMinimumStakeTime() internal view returns (uint) {
597         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
598     }
599 
600     function getAggregatorWarningFlags() internal view returns (address) {
601         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
602     }
603 
604     function getDebtSnapshotStaleTime() internal view returns (uint) {
605         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
606     }
607 }
608 
609 
610 pragma experimental ABIEncoderV2;
611 
612 
613 interface ISynthetixBridgeToOptimism {
614     // Invoked by the relayer on L1
615     function completeWithdrawal(address account, uint amount) external;
616 
617     // The following functions can be invoked by users on L1
618     function initiateDeposit(uint amount) external;
619 
620     function initiateEscrowMigration(uint256[][] calldata entryIDs) external;
621 
622     function initiateRewardDeposit(uint amount) external;
623 
624     function depositAndMigrateEscrow(uint256 depositAmount, uint256[][] calldata entryIDs) external;
625 }
626 
627 
628 interface IVirtualSynth {
629     // Views
630     function balanceOfUnderlying(address account) external view returns (uint);
631 
632     function rate() external view returns (uint);
633 
634     function readyToSettle() external view returns (bool);
635 
636     function secsLeftInWaitingPeriod() external view returns (uint);
637 
638     function settled() external view returns (bool);
639 
640     function synth() external view returns (ISynth);
641 
642     // Mutative functions
643     function settle(address account) external;
644 }
645 
646 
647 // https://docs.synthetix.io/contracts/source/interfaces/isynthetix
648 interface ISynthetix {
649     // Views
650     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
651 
652     function availableCurrencyKeys() external view returns (bytes32[] memory);
653 
654     function availableSynthCount() external view returns (uint);
655 
656     function availableSynths(uint index) external view returns (ISynth);
657 
658     function collateral(address account) external view returns (uint);
659 
660     function collateralisationRatio(address issuer) external view returns (uint);
661 
662     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
663 
664     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
665 
666     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
667 
668     function remainingIssuableSynths(address issuer)
669         external
670         view
671         returns (
672             uint maxIssuable,
673             uint alreadyIssued,
674             uint totalSystemDebt
675         );
676 
677     function synths(bytes32 currencyKey) external view returns (ISynth);
678 
679     function synthsByAddress(address synthAddress) external view returns (bytes32);
680 
681     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
682 
683     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);
684 
685     function transferableSynthetix(address account) external view returns (uint transferable);
686 
687     // Mutative Functions
688     function burnSynths(uint amount) external;
689 
690     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
691 
692     function burnSynthsToTarget() external;
693 
694     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
695 
696     function exchange(
697         bytes32 sourceCurrencyKey,
698         uint sourceAmount,
699         bytes32 destinationCurrencyKey
700     ) external returns (uint amountReceived);
701 
702     function exchangeOnBehalf(
703         address exchangeForAddress,
704         bytes32 sourceCurrencyKey,
705         uint sourceAmount,
706         bytes32 destinationCurrencyKey
707     ) external returns (uint amountReceived);
708 
709     function exchangeWithTracking(
710         bytes32 sourceCurrencyKey,
711         uint sourceAmount,
712         bytes32 destinationCurrencyKey,
713         address originator,
714         bytes32 trackingCode
715     ) external returns (uint amountReceived);
716 
717     function exchangeOnBehalfWithTracking(
718         address exchangeForAddress,
719         bytes32 sourceCurrencyKey,
720         uint sourceAmount,
721         bytes32 destinationCurrencyKey,
722         address originator,
723         bytes32 trackingCode
724     ) external returns (uint amountReceived);
725 
726     function exchangeWithVirtual(
727         bytes32 sourceCurrencyKey,
728         uint sourceAmount,
729         bytes32 destinationCurrencyKey,
730         bytes32 trackingCode
731     ) external returns (uint amountReceived, IVirtualSynth vSynth);
732 
733     function issueMaxSynths() external;
734 
735     function issueMaxSynthsOnBehalf(address issueForAddress) external;
736 
737     function issueSynths(uint amount) external;
738 
739     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
740 
741     function mint() external returns (bool);
742 
743     function settle(bytes32 currencyKey)
744         external
745         returns (
746             uint reclaimed,
747             uint refunded,
748             uint numEntries
749         );
750 
751     // Liquidations
752     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
753 
754     // Restricted Functions
755 
756     function mintSecondary(address account, uint amount) external;
757 
758     function mintSecondaryRewards(uint amount) external;
759 
760     function burnSecondary(address account, uint amount) external;
761 }
762 
763 
764 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
765 interface IERC20 {
766     // ERC20 Optional Views
767     function name() external view returns (string memory);
768 
769     function symbol() external view returns (string memory);
770 
771     function decimals() external view returns (uint8);
772 
773     // Views
774     function totalSupply() external view returns (uint);
775 
776     function balanceOf(address owner) external view returns (uint);
777 
778     function allowance(address owner, address spender) external view returns (uint);
779 
780     // Mutative functions
781     function transfer(address to, uint value) external returns (bool);
782 
783     function approve(address spender, uint value) external returns (bool);
784 
785     function transferFrom(
786         address from,
787         address to,
788         uint value
789     ) external returns (bool);
790 
791     // Events
792     event Transfer(address indexed from, address indexed to, uint value);
793 
794     event Approval(address indexed owner, address indexed spender, uint value);
795 }
796 
797 
798 library VestingEntries {
799     struct VestingEntry {
800         uint64 endTime;
801         uint256 escrowAmount;
802     }
803     struct VestingEntryWithID {
804         uint64 endTime;
805         uint256 escrowAmount;
806         uint256 entryID;
807     }
808 }
809 
810 
811 interface IRewardEscrowV2 {
812     // Views
813     function balanceOf(address account) external view returns (uint);
814 
815     function numVestingEntries(address account) external view returns (uint);
816 
817     function totalEscrowedAccountBalance(address account) external view returns (uint);
818 
819     function totalVestedAccountBalance(address account) external view returns (uint);
820 
821     function getVestingQuantity(address account, uint256[] calldata entryIDs) external view returns (uint);
822 
823     function getVestingSchedules(
824         address account,
825         uint256 index,
826         uint256 pageSize
827     ) external view returns (VestingEntries.VestingEntryWithID[] memory);
828 
829     function getAccountVestingEntryIDs(
830         address account,
831         uint256 index,
832         uint256 pageSize
833     ) external view returns (uint256[] memory);
834 
835     function getVestingEntryClaimable(address account, uint256 entryID) external view returns (uint);
836 
837     function getVestingEntry(address account, uint256 entryID) external view returns (uint64, uint256);
838 
839     // Mutative functions
840     function vest(uint256[] calldata entryIDs) external;
841 
842     function createEscrowEntry(
843         address beneficiary,
844         uint256 deposit,
845         uint256 duration
846     ) external;
847 
848     function appendVestingEntry(
849         address account,
850         uint256 quantity,
851         uint256 duration
852     ) external;
853 
854     function migrateVestingSchedule(address _addressToMigrate) external;
855 
856     function migrateAccountEscrowBalances(
857         address[] calldata accounts,
858         uint256[] calldata escrowBalances,
859         uint256[] calldata vestedBalances
860     ) external;
861 
862     // Account Merging
863     function startMergingWindow() external;
864 
865     function mergeAccount(address accountToMerge, uint256[] calldata entryIDs) external;
866 
867     function nominateAccountToMerge(address account) external;
868 
869     function accountMergingIsOpen() external view returns (bool);
870 
871     // L2 Migration
872     function importVestingEntries(
873         address account,
874         uint256 escrowedAmount,
875         VestingEntries.VestingEntry[] calldata vestingEntries
876     ) external;
877 
878     // Return amount of SNX transfered to SynthetixBridgeToOptimism deposit contract
879     function burnForMigration(address account, uint256[] calldata entryIDs)
880         external
881         returns (uint256 escrowedAccountBalance, VestingEntries.VestingEntry[] memory vestingEntries);
882 }
883 
884 
885 interface ISynthetixBridgeToBase {
886     // invoked by users on L2
887     function initiateWithdrawal(uint amount) external;
888 
889     //  // The following functions can only be invoked by the xDomain messenger on L2
890     function completeDeposit(address account, uint depositAmount) external;
891 
892     // invoked by the xDomain messenger on L2
893     function completeEscrowMigration(
894         address account,
895         uint256 escrowedAmount,
896         VestingEntries.VestingEntry[] calldata vestingEntries
897     ) external;
898 
899     // invoked by the xDomain messenger on L2
900     function completeRewardDeposit(uint amount) external;
901 }
902 
903 
904 // SPDX-License-Identifier: UNLICENSED
905 
906 
907 /**
908  * @title iOVM_BaseCrossDomainMessenger
909  */
910 interface iOVM_BaseCrossDomainMessenger {
911     /**********************
912      * Contract Variables *
913      **********************/
914     function xDomainMessageSender() external view returns (address);
915 
916     /********************
917      * Public Functions *
918      ********************/
919 
920     /**
921      * Sends a cross domain message to the target messenger.
922      * @param _target Target contract address.
923      * @param _message Message to send to the target.
924      * @param _gasLimit Gas limit for the provided message.
925      */
926     function sendMessage(
927         address _target,
928         bytes calldata _message,
929         uint32 _gasLimit
930     ) external;
931 }
932 
933 
934 // Inheritance
935 
936 
937 // Internal references
938 
939 
940 // solhint-disable indent
941 
942 
943 contract SynthetixBridgeToOptimism is Owned, MixinSystemSettings, ISynthetixBridgeToOptimism {
944     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
945     bytes32 private constant CONTRACT_EXT_MESSENGER = "ext:Messenger";
946     bytes32 private constant CONTRACT_SYNTHETIX = "Synthetix";
947     bytes32 private constant CONTRACT_ISSUER = "Issuer";
948     bytes32 private constant CONTRACT_REWARDSDISTRIBUTION = "RewardsDistribution";
949     bytes32 private constant CONTRACT_REWARDESCROW = "RewardEscrowV2";
950     bytes32 private constant CONTRACT_OVM_SYNTHETIXBRIDGETOBASE = "ovm:SynthetixBridgeToBase";
951 
952     uint8 private constant MAX_ENTRIES_MIGRATED_PER_MESSAGE = 26;
953 
954     bool public activated;
955 
956     // ========== CONSTRUCTOR ==========
957 
958     constructor(address _owner, address _resolver) public Owned(_owner) MixinSystemSettings(_resolver) {
959         activated = true;
960     }
961 
962     //
963     // ========== INTERNALS ============
964 
965     function messenger() internal view returns (iOVM_BaseCrossDomainMessenger) {
966         return iOVM_BaseCrossDomainMessenger(requireAndGetAddress(CONTRACT_EXT_MESSENGER));
967     }
968 
969     function synthetix() internal view returns (ISynthetix) {
970         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX));
971     }
972 
973     function synthetixERC20() internal view returns (IERC20) {
974         return IERC20(requireAndGetAddress(CONTRACT_SYNTHETIX));
975     }
976 
977     function issuer() internal view returns (IIssuer) {
978         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
979     }
980 
981     function rewardsDistribution() internal view returns (address) {
982         return requireAndGetAddress(CONTRACT_REWARDSDISTRIBUTION);
983     }
984 
985     function rewardEscrowV2() internal view returns (IRewardEscrowV2) {
986         return IRewardEscrowV2(requireAndGetAddress(CONTRACT_REWARDESCROW));
987     }
988 
989     function synthetixBridgeToBase() internal view returns (address) {
990         return requireAndGetAddress(CONTRACT_OVM_SYNTHETIXBRIDGETOBASE);
991     }
992 
993     function isActive() internal view {
994         require(activated, "Function deactivated");
995     }
996 
997     function hasZeroDebt() internal view {
998         require(issuer().debtBalanceOf(msg.sender, "sUSD") == 0, "Cannot deposit or migrate with debt");
999     }
1000 
1001     /* ========== VIEWS ========== */
1002 
1003     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1004         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1005         bytes32[] memory newAddresses = new bytes32[](6);
1006         newAddresses[0] = CONTRACT_EXT_MESSENGER;
1007         newAddresses[1] = CONTRACT_SYNTHETIX;
1008         newAddresses[2] = CONTRACT_ISSUER;
1009         newAddresses[3] = CONTRACT_REWARDSDISTRIBUTION;
1010         newAddresses[4] = CONTRACT_OVM_SYNTHETIXBRIDGETOBASE;
1011         newAddresses[5] = CONTRACT_REWARDESCROW;
1012         addresses = combineArrays(existingAddresses, newAddresses);
1013     }
1014 
1015     // ========== MODIFIERS ============
1016 
1017     modifier requireActive() {
1018         isActive();
1019         _;
1020     }
1021 
1022     modifier requireZeroDebt() {
1023         hasZeroDebt();
1024         _;
1025     }
1026 
1027     // ========== PUBLIC FUNCTIONS =========
1028 
1029     function initiateDeposit(uint256 depositAmount) external requireActive requireZeroDebt {
1030         _initiateDeposit(depositAmount);
1031     }
1032 
1033     function initiateEscrowMigration(uint256[][] memory entryIDs) public requireActive requireZeroDebt {
1034         _initiateEscrowMigration(entryIDs);
1035     }
1036 
1037     // invoked by a generous user on L1
1038     function initiateRewardDeposit(uint amount) external requireActive {
1039         // move the SNX into this contract
1040         synthetixERC20().transferFrom(msg.sender, address(this), amount);
1041 
1042         _initiateRewardDeposit(amount);
1043     }
1044 
1045     // ========= RESTRICTED FUNCTIONS ==============
1046 
1047     // invoked by Messenger on L1 after L2 waiting period elapses
1048     function completeWithdrawal(address account, uint256 amount) external requireActive {
1049         // ensure function only callable from L2 Bridge via messenger (aka relayer)
1050         require(msg.sender == address(messenger()), "Only the relayer can call this");
1051         require(messenger().xDomainMessageSender() == synthetixBridgeToBase(), "Only the L2 bridge can invoke");
1052 
1053         // transfer amount back to user
1054         synthetixERC20().transfer(account, amount);
1055 
1056         // no escrow actions - escrow remains on L2
1057         emit WithdrawalCompleted(account, amount);
1058     }
1059 
1060     // invoked by the owner for migrating the contract to the new version that will allow for withdrawals
1061     function migrateBridge(address newBridge) external onlyOwner requireActive {
1062         require(newBridge != address(0), "Cannot migrate to address 0");
1063         activated = false;
1064 
1065         IERC20 ERC20Synthetix = synthetixERC20();
1066         // get the current contract balance and transfer it to the new SynthetixL1ToL2Bridge contract
1067         uint256 contractBalance = ERC20Synthetix.balanceOf(address(this));
1068         ERC20Synthetix.transfer(newBridge, contractBalance);
1069 
1070         emit BridgeMigrated(address(this), newBridge, contractBalance);
1071     }
1072 
1073     // invoked by RewardsDistribution on L1 (takes SNX)
1074     function notifyRewardAmount(uint256 amount) external requireActive {
1075         require(msg.sender == address(rewardsDistribution()), "Caller is not RewardsDistribution contract");
1076 
1077         // to be here means I've been given an amount of SNX to distribute onto L2
1078         _initiateRewardDeposit(amount);
1079     }
1080 
1081     function depositAndMigrateEscrow(uint256 depositAmount, uint256[][] memory entryIDs)
1082         public
1083         requireActive
1084         requireZeroDebt
1085     {
1086         if (entryIDs.length > 0) {
1087             _initiateEscrowMigration(entryIDs);
1088         }
1089 
1090         if (depositAmount > 0) {
1091             _initiateDeposit(depositAmount);
1092         }
1093     }
1094 
1095     // ========== PRIVATE/INTERNAL FUNCTIONS =========
1096 
1097     function _initiateRewardDeposit(uint256 _amount) internal {
1098         // create message payload for L2
1099         ISynthetixBridgeToBase bridgeToBase;
1100         bytes memory messageData = abi.encodeWithSelector(bridgeToBase.completeRewardDeposit.selector, _amount);
1101 
1102         // relay the message to this contract on L2 via L1 Messenger
1103         messenger().sendMessage(
1104             synthetixBridgeToBase(),
1105             messageData,
1106             uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Reward))
1107         );
1108 
1109         emit RewardDeposit(msg.sender, _amount);
1110     }
1111 
1112     function _initiateDeposit(uint256 _depositAmount) private {
1113         // Transfer SNX to L2
1114         // First, move the SNX into this contract
1115         synthetixERC20().transferFrom(msg.sender, address(this), _depositAmount);
1116         // create message payload for L2
1117         ISynthetixBridgeToBase bridgeToBase;
1118         bytes memory messageData = abi.encodeWithSelector(bridgeToBase.completeDeposit.selector, msg.sender, _depositAmount);
1119 
1120         // relay the message to this contract on L2 via L1 Messenger
1121         messenger().sendMessage(
1122             synthetixBridgeToBase(),
1123             messageData,
1124             uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Deposit))
1125         );
1126         emit Deposit(msg.sender, _depositAmount);
1127     }
1128 
1129     function _initiateEscrowMigration(uint256[][] memory _entryIDs) private {
1130         // loop through the entryID array
1131         for (uint256 i = 0; i < _entryIDs.length; i++) {
1132             // Cannot send more than MAX_ENTRIES_MIGRATED_PER_MESSAGE entries due to ovm gas restrictions
1133             require(_entryIDs[i].length <= MAX_ENTRIES_MIGRATED_PER_MESSAGE, "Exceeds max entries per migration");
1134             // Burn their reward escrow first
1135             // Note: escrowSummary would lose the fidelity of the weekly escrows, so this may not be sufficient
1136             uint256 escrowedAccountBalance;
1137             VestingEntries.VestingEntry[] memory vestingEntries;
1138             (escrowedAccountBalance, vestingEntries) = rewardEscrowV2().burnForMigration(msg.sender, _entryIDs[i]);
1139             // if there is an escrow amount to be migrated
1140             if (escrowedAccountBalance > 0) {
1141                 // create message payload for L2
1142                 ISynthetixBridgeToBase bridgeToBase;
1143                 bytes memory messageData = abi.encodeWithSelector(
1144                     bridgeToBase.completeEscrowMigration.selector,
1145                     msg.sender,
1146                     escrowedAccountBalance,
1147                     vestingEntries
1148                 );
1149                 // relay the message to this contract on L2 via L1 Messenger
1150                 messenger().sendMessage(
1151                     synthetixBridgeToBase(),
1152                     messageData,
1153                     uint32(getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits.Escrow))
1154                 );
1155                 emit ExportedVestingEntries(msg.sender, escrowedAccountBalance, vestingEntries);
1156             }
1157         }
1158     }
1159 
1160     // ========== EVENTS ==========
1161 
1162     event BridgeMigrated(address oldBridge, address newBridge, uint256 amount);
1163     event Deposit(address indexed account, uint256 amount);
1164     event ExportedVestingEntries(
1165         address indexed account,
1166         uint256 escrowedAccountBalance,
1167         VestingEntries.VestingEntry[] vestingEntries
1168     );
1169     event RewardDeposit(address indexed account, uint256 amount);
1170     event WithdrawalCompleted(address indexed account, uint256 amount);
1171 }
1172 
1173     