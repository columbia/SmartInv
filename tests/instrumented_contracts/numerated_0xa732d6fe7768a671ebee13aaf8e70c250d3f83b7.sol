1 /*
2     ___            _       ___  _                          
3     | .\ ___  _ _ <_> ___ | __><_>._ _  ___ ._ _  ___  ___ 
4     |  _// ._>| '_>| ||___|| _> | || ' |<_> || ' |/ | '/ ._>
5     |_|  \___.|_|  |_|     |_|  |_||_|_|<___||_|_|\_|_.\___.
6     
7 * PeriFinance: ExchangeRates.sol
8 *
9 * Latest source (may be newer): https://github.com/perifinance/peri-finance/blob/master/contracts/ExchangeRates.sol
10 * Docs: Will be added in the future. 
11 * https://docs.peri.finance/contracts/source/contracts/ExchangeRates
12 *
13 * Contract Dependencies: 
14 *	- IAddressResolver
15 *	- IExchangeRates
16 *	- MixinResolver
17 *	- MixinSystemSettings
18 *	- Owned
19 * Libraries: 
20 *	- SafeDecimalMath
21 *	- SafeMath
22 *
23 * MIT License
24 * ===========
25 *
26 * Copyright (c) 2021 PeriFinance
27 *
28 * Permission is hereby granted, free of charge, to any person obtaining a copy
29 * of this software and associated documentation files (the "Software"), to deal
30 * in the Software without restriction, including without limitation the rights
31 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
32 * copies of the Software, and to permit persons to whom the Software is
33 * furnished to do so, subject to the following conditions:
34 *
35 * The above copyright notice and this permission notice shall be included in all
36 * copies or substantial portions of the Software.
37 *
38 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
39 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
40 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
41 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
42 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
43 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
44 */
45 
46 
47 
48 pragma solidity 0.5.16;
49 
50 // https://docs.peri.finance/contracts/source/contracts/owned
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
87 // https://docs.peri.finance/contracts/source/interfaces/iaddressresolver
88 interface IAddressResolver {
89     function getAddress(bytes32 name) external view returns (address);
90 
91     function getPynth(bytes32 key) external view returns (address);
92 
93     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
94 }
95 
96 
97 // https://docs.peri.finance/contracts/source/interfaces/ipynth
98 interface IPynth {
99     // Views
100     function currencyKey() external view returns (bytes32);
101 
102     function transferablePynths(address account) external view returns (uint);
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
113     // Restricted: used internally to PeriFinance
114     function burn(address account, uint amount) external;
115 
116     function issue(address account, uint amount) external;
117 }
118 
119 
120 // https://docs.peri.finance/contracts/source/interfaces/iissuer
121 interface IIssuer {
122     // Views
123     function anyPynthOrPERIRateIsInvalid() external view returns (bool anyRateInvalid);
124 
125     function availableCurrencyKeys() external view returns (bytes32[] memory);
126 
127     function availablePynthCount() external view returns (uint);
128 
129     function availablePynths(uint index) external view returns (IPynth);
130 
131     function canBurnPynths(address account) external view returns (bool);
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
146     function externalTokenLimit() external view returns (uint);
147 
148     function lastIssueEvent(address account) external view returns (uint);
149 
150     function maxIssuablePynths(address issuer) external view returns (uint maxIssuable);
151 
152     function externalTokenQuota(
153         address _account,
154         uint _addtionalpUSD,
155         uint _addtionalExToken,
156         bool _isIssue
157     ) external view returns (uint);
158 
159     function maxExternalTokenStakeAmount(address _account, bytes32 _currencyKey)
160         external
161         view
162         returns (uint issueAmountToQuota, uint stakeAmountToQuota);
163 
164     function minimumStakeTime() external view returns (uint);
165 
166     function remainingIssuablePynths(address issuer)
167         external
168         view
169         returns (
170             uint maxIssuable,
171             uint alreadyIssued,
172             uint totalSystemDebt
173         );
174 
175     function pynths(bytes32 currencyKey) external view returns (IPynth);
176 
177     function getPynths(bytes32[] calldata currencyKeys) external view returns (IPynth[] memory);
178 
179     function pynthsByAddress(address pynthAddress) external view returns (bytes32);
180 
181     function totalIssuedPynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
182 
183     function transferablePeriFinanceAndAnyRateIsInvalid(address account, uint balance)
184         external
185         view
186         returns (uint transferable, bool anyRateIsInvalid);
187 
188     // Restricted: used internally to PeriFinance
189     function issuePynths(
190         address _issuer,
191         bytes32 _currencyKey,
192         uint _issueAmount
193     ) external;
194 
195     function issueMaxPynths(address _issuer) external;
196 
197     function issuePynthsToMaxQuota(address _issuer, bytes32 _currencyKey) external;
198 
199     function burnPynths(
200         address _from,
201         bytes32 _currencyKey,
202         uint _burnAmount
203     ) external;
204 
205     function fitToClaimable(address _from) external;
206 
207     function exit(address _from) external;
208 
209     function liquidateDelinquentAccount(
210         address account,
211         uint pusdAmount,
212         address liquidator
213     ) external returns (uint totalRedeemed, uint amountToLiquidate);
214 }
215 
216 
217 // Inheritance
218 
219 
220 // Internal references
221 
222 
223 // https://docs.peri.finance/contracts/source/contracts/addressresolver
224 contract AddressResolver is Owned, IAddressResolver {
225     mapping(bytes32 => address) public repository;
226 
227     constructor(address _owner) public Owned(_owner) {}
228 
229     /* ========== RESTRICTED FUNCTIONS ========== */
230 
231     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
232         require(names.length == destinations.length, "Input lengths must match");
233 
234         for (uint i = 0; i < names.length; i++) {
235             bytes32 name = names[i];
236             address destination = destinations[i];
237             repository[name] = destination;
238             emit AddressImported(name, destination);
239         }
240     }
241 
242     /* ========= PUBLIC FUNCTIONS ========== */
243 
244     function rebuildCaches(MixinResolver[] calldata destinations) external {
245         for (uint i = 0; i < destinations.length; i++) {
246             destinations[i].rebuildCache();
247         }
248     }
249 
250     /* ========== VIEWS ========== */
251 
252     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
253         for (uint i = 0; i < names.length; i++) {
254             if (repository[names[i]] != destinations[i]) {
255                 return false;
256             }
257         }
258         return true;
259     }
260 
261     function getAddress(bytes32 name) external view returns (address) {
262         return repository[name];
263     }
264 
265     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
266         address _foundAddress = repository[name];
267         require(_foundAddress != address(0), reason);
268         return _foundAddress;
269     }
270 
271     function getPynth(bytes32 key) external view returns (address) {
272         IIssuer issuer = IIssuer(repository["Issuer"]);
273         require(address(issuer) != address(0), "Cannot find Issuer address");
274         return address(issuer.pynths(key));
275     }
276 
277     /* ========== EVENTS ========== */
278 
279     event AddressImported(bytes32 name, address destination);
280 }
281 
282 
283 // solhint-disable payable-fallback
284 
285 // https://docs.peri.finance/contracts/source/contracts/readproxy
286 contract ReadProxy is Owned {
287     address public target;
288 
289     constructor(address _owner) public Owned(_owner) {}
290 
291     function setTarget(address _target) external onlyOwner {
292         target = _target;
293         emit TargetUpdated(target);
294     }
295 
296     function() external {
297         // The basics of a proxy read call
298         // Note that msg.sender in the underlying will always be the address of this contract.
299         assembly {
300             calldatacopy(0, 0, calldatasize)
301 
302             // Use of staticcall - this will revert if the underlying function mutates state
303             let result := staticcall(gas, sload(target_slot), 0, calldatasize, 0, 0)
304             returndatacopy(0, 0, returndatasize)
305 
306             if iszero(result) {
307                 revert(0, returndatasize)
308             }
309             return(0, returndatasize)
310         }
311     }
312 
313     event TargetUpdated(address newTarget);
314 }
315 
316 
317 // Inheritance
318 
319 
320 // Internal references
321 
322 
323 // https://docs.peri.finance/contracts/source/contracts/mixinresolver
324 contract MixinResolver {
325     AddressResolver public resolver;
326 
327     mapping(bytes32 => address) private addressCache;
328 
329     constructor(address _resolver) internal {
330         resolver = AddressResolver(_resolver);
331     }
332 
333     /* ========== INTERNAL FUNCTIONS ========== */
334 
335     function combineArrays(bytes32[] memory first, bytes32[] memory second)
336         internal
337         pure
338         returns (bytes32[] memory combination)
339     {
340         combination = new bytes32[](first.length + second.length);
341 
342         for (uint i = 0; i < first.length; i++) {
343             combination[i] = first[i];
344         }
345 
346         for (uint j = 0; j < second.length; j++) {
347             combination[first.length + j] = second[j];
348         }
349     }
350 
351     /* ========== PUBLIC FUNCTIONS ========== */
352 
353     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
354     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
355 
356     function rebuildCache() public {
357         bytes32[] memory requiredAddresses = resolverAddressesRequired();
358         // The resolver must call this function whenver it updates its state
359         for (uint i = 0; i < requiredAddresses.length; i++) {
360             bytes32 name = requiredAddresses[i];
361             // Note: can only be invoked once the resolver has all the targets needed added
362             address destination =
363                 resolver.requireAndGetAddress(name, string(abi.encodePacked("Resolver missing target: ", name)));
364             addressCache[name] = destination;
365             emit CacheUpdated(name, destination);
366         }
367     }
368 
369     /* ========== VIEWS ========== */
370 
371     function isResolverCached() external view returns (bool) {
372         bytes32[] memory requiredAddresses = resolverAddressesRequired();
373         for (uint i = 0; i < requiredAddresses.length; i++) {
374             bytes32 name = requiredAddresses[i];
375             // false if our cache is invalid or if the resolver doesn't have the required address
376             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
377                 return false;
378             }
379         }
380 
381         return true;
382     }
383 
384     /* ========== INTERNAL FUNCTIONS ========== */
385 
386     function requireAndGetAddress(bytes32 name) internal view returns (address) {
387         address _foundAddress = addressCache[name];
388         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
389         return _foundAddress;
390     }
391 
392     /* ========== EVENTS ========== */
393 
394     event CacheUpdated(bytes32 name, address destination);
395 }
396 
397 
398 // https://docs.peri.finance/contracts/source/interfaces/iflexiblestorage
399 interface IFlexibleStorage {
400     // Views
401     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
402 
403     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
404 
405     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
406 
407     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
408 
409     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
410 
411     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
412 
413     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
414 
415     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
416 
417     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
418 
419     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
420 
421     // Mutative functions
422     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
423 
424     function deleteIntValue(bytes32 contractName, bytes32 record) external;
425 
426     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
427 
428     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
429 
430     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
431 
432     function setUIntValue(
433         bytes32 contractName,
434         bytes32 record,
435         uint value
436     ) external;
437 
438     function setUIntValues(
439         bytes32 contractName,
440         bytes32[] calldata records,
441         uint[] calldata values
442     ) external;
443 
444     function setIntValue(
445         bytes32 contractName,
446         bytes32 record,
447         int value
448     ) external;
449 
450     function setIntValues(
451         bytes32 contractName,
452         bytes32[] calldata records,
453         int[] calldata values
454     ) external;
455 
456     function setAddressValue(
457         bytes32 contractName,
458         bytes32 record,
459         address value
460     ) external;
461 
462     function setAddressValues(
463         bytes32 contractName,
464         bytes32[] calldata records,
465         address[] calldata values
466     ) external;
467 
468     function setBoolValue(
469         bytes32 contractName,
470         bytes32 record,
471         bool value
472     ) external;
473 
474     function setBoolValues(
475         bytes32 contractName,
476         bytes32[] calldata records,
477         bool[] calldata values
478     ) external;
479 
480     function setBytes32Value(
481         bytes32 contractName,
482         bytes32 record,
483         bytes32 value
484     ) external;
485 
486     function setBytes32Values(
487         bytes32 contractName,
488         bytes32[] calldata records,
489         bytes32[] calldata values
490     ) external;
491 }
492 
493 
494 // Internal references
495 
496 
497 // https://docs.peri.finance/contracts/source/contracts/mixinsystemsettings
498 contract MixinSystemSettings is MixinResolver {
499     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
500 
501     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
502     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
503     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
504     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
505     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
506     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
507     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
508     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
509     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
510     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
511     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
512     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
513     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
514     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
515     bytes32 internal constant SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT = "crossDomainDepositGasLimit";
516     bytes32 internal constant SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT = "crossDomainEscrowGasLimit";
517     bytes32 internal constant SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT = "crossDomainRewardGasLimit";
518     bytes32 internal constant SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT = "crossDomainWithdrawalGasLimit";
519     bytes32 internal constant SETTING_EXTERNAL_TOKEN_QUOTA = "externalTokenQuota";
520 
521     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
522 
523     enum CrossDomainMessageGasLimits {Deposit, Escrow, Reward, Withdrawal}
524 
525     constructor(address _resolver) internal MixinResolver(_resolver) {}
526 
527     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
528         addresses = new bytes32[](1);
529         addresses[0] = CONTRACT_FLEXIBLESTORAGE;
530     }
531 
532     function flexibleStorage() internal view returns (IFlexibleStorage) {
533         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
534     }
535 
536     function _getGasLimitSetting(CrossDomainMessageGasLimits gasLimitType) internal pure returns (bytes32) {
537         if (gasLimitType == CrossDomainMessageGasLimits.Deposit) {
538             return SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT;
539         } else if (gasLimitType == CrossDomainMessageGasLimits.Escrow) {
540             return SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT;
541         } else if (gasLimitType == CrossDomainMessageGasLimits.Reward) {
542             return SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT;
543         } else if (gasLimitType == CrossDomainMessageGasLimits.Withdrawal) {
544             return SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT;
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
597     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
598         return
599             flexibleStorage().getUIntValue(
600                 SETTING_CONTRACT_NAME,
601                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
602             );
603     }
604 
605     function getMinimumStakeTime() internal view returns (uint) {
606         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
607     }
608 
609     function getAggregatorWarningFlags() internal view returns (address) {
610         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
611     }
612 
613     function getDebtSnapshotStaleTime() internal view returns (uint) {
614         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
615     }
616 
617     function getExternalTokenQuota() internal view returns (uint) {
618         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_EXTERNAL_TOKEN_QUOTA);
619     }
620 }
621 
622 
623 // https://docs.peri.finance/contracts/source/interfaces/iexchangerates
624 interface IExchangeRates {
625     // Structs
626     struct RateAndUpdatedTime {
627         uint216 rate;
628         uint40 time;
629     }
630 
631     struct InversePricing {
632         uint entryPoint;
633         uint upperLimit;
634         uint lowerLimit;
635         bool frozenAtUpperLimit;
636         bool frozenAtLowerLimit;
637     }
638 
639     // Views
640     function aggregators(bytes32 currencyKey) external view returns (address);
641 
642     function aggregatorWarningFlags() external view returns (address);
643 
644     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
645 
646     function canFreezeRate(bytes32 currencyKey) external view returns (bool);
647 
648     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
649 
650     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
651 
652     function effectiveValue(
653         bytes32 sourceCurrencyKey,
654         uint sourceAmount,
655         bytes32 destinationCurrencyKey
656     ) external view returns (uint value);
657 
658     function effectiveValueAndRates(
659         bytes32 sourceCurrencyKey,
660         uint sourceAmount,
661         bytes32 destinationCurrencyKey
662     )
663         external
664         view
665         returns (
666             uint value,
667             uint sourceRate,
668             uint destinationRate
669         );
670 
671     function effectiveValueAtRound(
672         bytes32 sourceCurrencyKey,
673         uint sourceAmount,
674         bytes32 destinationCurrencyKey,
675         uint roundIdForSrc,
676         uint roundIdForDest
677     ) external view returns (uint value);
678 
679     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
680 
681     function getLastRoundIdBeforeElapsedSecs(
682         bytes32 currencyKey,
683         uint startingRoundId,
684         uint startingTimestamp,
685         uint timediff
686     ) external view returns (uint);
687 
688     function inversePricing(bytes32 currencyKey)
689         external
690         view
691         returns (
692             uint entryPoint,
693             uint upperLimit,
694             uint lowerLimit,
695             bool frozenAtUpperLimit,
696             bool frozenAtLowerLimit
697         );
698 
699     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
700 
701     function oracle() external view returns (address);
702 
703     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
704 
705     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
706 
707     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
708 
709     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
710 
711     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
712 
713     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
714 
715     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
716 
717     function rateIsStale(bytes32 currencyKey) external view returns (bool);
718 
719     function rateStalePeriod() external view returns (uint);
720 
721     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
722         external
723         view
724         returns (uint[] memory rates, uint[] memory times);
725 
726     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
727         external
728         view
729         returns (uint[] memory rates, bool anyRateInvalid);
730 
731     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
732 
733     // Mutative functions
734     function freezeRate(bytes32 currencyKey) external;
735 }
736 
737 
738 /**
739  * @dev Wrappers over Solidity's arithmetic operations with added overflow
740  * checks.
741  *
742  * Arithmetic operations in Solidity wrap on overflow. This can easily result
743  * in bugs, because programmers usually assume that an overflow raises an
744  * error, which is the standard behavior in high level programming languages.
745  * `SafeMath` restores this intuition by reverting the transaction when an
746  * operation overflows.
747  *
748  * Using this library instead of the unchecked operations eliminates an entire
749  * class of bugs, so it's recommended to use it always.
750  */
751 library SafeMath {
752     /**
753      * @dev Returns the addition of two unsigned integers, reverting on
754      * overflow.
755      *
756      * Counterpart to Solidity's `+` operator.
757      *
758      * Requirements:
759      * - Addition cannot overflow.
760      */
761     function add(uint256 a, uint256 b) internal pure returns (uint256) {
762         uint256 c = a + b;
763         require(c >= a, "SafeMath: addition overflow");
764 
765         return c;
766     }
767 
768     /**
769      * @dev Returns the subtraction of two unsigned integers, reverting on
770      * overflow (when the result is negative).
771      *
772      * Counterpart to Solidity's `-` operator.
773      *
774      * Requirements:
775      * - Subtraction cannot overflow.
776      */
777     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
778         require(b <= a, "SafeMath: subtraction overflow");
779         uint256 c = a - b;
780 
781         return c;
782     }
783 
784     /**
785      * @dev Returns the multiplication of two unsigned integers, reverting on
786      * overflow.
787      *
788      * Counterpart to Solidity's `*` operator.
789      *
790      * Requirements:
791      * - Multiplication cannot overflow.
792      */
793     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
794         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
795         // benefit is lost if 'b' is also tested.
796         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
797         if (a == 0) {
798             return 0;
799         }
800 
801         uint256 c = a * b;
802         require(c / a == b, "SafeMath: multiplication overflow");
803 
804         return c;
805     }
806 
807     /**
808      * @dev Returns the integer division of two unsigned integers. Reverts on
809      * division by zero. The result is rounded towards zero.
810      *
811      * Counterpart to Solidity's `/` operator. Note: this function uses a
812      * `revert` opcode (which leaves remaining gas untouched) while Solidity
813      * uses an invalid opcode to revert (consuming all remaining gas).
814      *
815      * Requirements:
816      * - The divisor cannot be zero.
817      */
818     function div(uint256 a, uint256 b) internal pure returns (uint256) {
819         // Solidity only automatically asserts when dividing by 0
820         require(b > 0, "SafeMath: division by zero");
821         uint256 c = a / b;
822         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
823 
824         return c;
825     }
826 
827     /**
828      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
829      * Reverts when dividing by zero.
830      *
831      * Counterpart to Solidity's `%` operator. This function uses a `revert`
832      * opcode (which leaves remaining gas untouched) while Solidity uses an
833      * invalid opcode to revert (consuming all remaining gas).
834      *
835      * Requirements:
836      * - The divisor cannot be zero.
837      */
838     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
839         require(b != 0, "SafeMath: modulo by zero");
840         return a % b;
841     }
842 }
843 
844 
845 // Libraries
846 
847 
848 // https://docs.peri.finance/contracts/source/libraries/safedecimalmath
849 library SafeDecimalMath {
850     using SafeMath for uint;
851 
852     /* Number of decimal places in the representations. */
853     uint8 public constant decimals = 18;
854     uint8 public constant highPrecisionDecimals = 27;
855 
856     /* The number representing 1.0. */
857     uint public constant UNIT = 10**uint(decimals);
858 
859     /* The number representing 1.0 for higher fidelity numbers. */
860     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
861     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
862 
863     /**
864      * @return Provides an interface to UNIT.
865      */
866     function unit() external pure returns (uint) {
867         return UNIT;
868     }
869 
870     /**
871      * @return Provides an interface to PRECISE_UNIT.
872      */
873     function preciseUnit() external pure returns (uint) {
874         return PRECISE_UNIT;
875     }
876 
877     /**
878      * @return The result of multiplying x and y, interpreting the operands as fixed-point
879      * decimals.
880      *
881      * @dev A unit factor is divided out after the product of x and y is evaluated,
882      * so that product must be less than 2**256. As this is an integer division,
883      * the internal division always rounds down. This helps save on gas. Rounding
884      * is more expensive on gas.
885      */
886     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
887         /* Divide by UNIT to remove the extra factor introduced by the product. */
888         return x.mul(y) / UNIT;
889     }
890 
891     /**
892      * @return The result of safely multiplying x and y, interpreting the operands
893      * as fixed-point decimals of the specified precision unit.
894      *
895      * @dev The operands should be in the form of a the specified unit factor which will be
896      * divided out after the product of x and y is evaluated, so that product must be
897      * less than 2**256.
898      *
899      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
900      * Rounding is useful when you need to retain fidelity for small decimal numbers
901      * (eg. small fractions or percentages).
902      */
903     function _multiplyDecimalRound(
904         uint x,
905         uint y,
906         uint precisionUnit
907     ) private pure returns (uint) {
908         /* Divide by UNIT to remove the extra factor introduced by the product. */
909         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
910 
911         if (quotientTimesTen % 10 >= 5) {
912             quotientTimesTen += 10;
913         }
914 
915         return quotientTimesTen / 10;
916     }
917 
918     /**
919      * @return The result of safely multiplying x and y, interpreting the operands
920      * as fixed-point decimals of a precise unit.
921      *
922      * @dev The operands should be in the precise unit factor which will be
923      * divided out after the product of x and y is evaluated, so that product must be
924      * less than 2**256.
925      *
926      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
927      * Rounding is useful when you need to retain fidelity for small decimal numbers
928      * (eg. small fractions or percentages).
929      */
930     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
931         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
932     }
933 
934     /**
935      * @return The result of safely multiplying x and y, interpreting the operands
936      * as fixed-point decimals of a standard unit.
937      *
938      * @dev The operands should be in the standard unit factor which will be
939      * divided out after the product of x and y is evaluated, so that product must be
940      * less than 2**256.
941      *
942      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
943      * Rounding is useful when you need to retain fidelity for small decimal numbers
944      * (eg. small fractions or percentages).
945      */
946     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
947         return _multiplyDecimalRound(x, y, UNIT);
948     }
949 
950     /**
951      * @return The result of safely dividing x and y. The return value is a high
952      * precision decimal.
953      *
954      * @dev y is divided after the product of x and the standard precision unit
955      * is evaluated, so the product of x and UNIT must be less than 2**256. As
956      * this is an integer division, the result is always rounded down.
957      * This helps save on gas. Rounding is more expensive on gas.
958      */
959     function divideDecimal(uint x, uint y) internal pure returns (uint) {
960         /* Reintroduce the UNIT factor that will be divided out by y. */
961         return x.mul(UNIT).div(y);
962     }
963 
964     /**
965      * @return The result of safely dividing x and y. The return value is as a rounded
966      * decimal in the precision unit specified in the parameter.
967      *
968      * @dev y is divided after the product of x and the specified precision unit
969      * is evaluated, so the product of x and the specified precision unit must
970      * be less than 2**256. The result is rounded to the nearest increment.
971      */
972     function _divideDecimalRound(
973         uint x,
974         uint y,
975         uint precisionUnit
976     ) private pure returns (uint) {
977         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
978 
979         if (resultTimesTen % 10 >= 5) {
980             resultTimesTen += 10;
981         }
982 
983         return resultTimesTen / 10;
984     }
985 
986     /**
987      * @return The result of safely dividing x and y. The return value is as a rounded
988      * standard precision decimal.
989      *
990      * @dev y is divided after the product of x and the standard precision unit
991      * is evaluated, so the product of x and the standard precision unit must
992      * be less than 2**256. The result is rounded to the nearest increment.
993      */
994     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
995         return _divideDecimalRound(x, y, UNIT);
996     }
997 
998     /**
999      * @return The result of safely dividing x and y. The return value is as a rounded
1000      * high precision decimal.
1001      *
1002      * @dev y is divided after the product of x and the high precision unit
1003      * is evaluated, so the product of x and the high precision unit must
1004      * be less than 2**256. The result is rounded to the nearest increment.
1005      */
1006     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
1007         return _divideDecimalRound(x, y, PRECISE_UNIT);
1008     }
1009 
1010     /**
1011      * @dev Convert a standard decimal representation to a high precision one.
1012      */
1013     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
1014         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
1015     }
1016 
1017     /**
1018      * @dev Convert a high precision decimal to a standard decimal representation.
1019      */
1020     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
1021         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
1022 
1023         if (quotientTimesTen % 10 >= 5) {
1024             quotientTimesTen += 10;
1025         }
1026 
1027         return quotientTimesTen / 10;
1028     }
1029 
1030     /**
1031      * @dev Round down the value with given number
1032      */
1033     function roundDownDecimal(uint x, uint d) internal pure returns (uint) {
1034         return x.div(10**d).mul(10**d);
1035     }
1036 
1037     /**
1038      * @dev Round up the value with given number
1039      */
1040     function roundUpDecimal(uint x, uint d) internal pure returns (uint) {
1041         uint _decimal = 10**d;
1042 
1043         if (x % _decimal > 0) {
1044             x = x.add(10**d);
1045         }
1046 
1047         return x.div(_decimal).mul(_decimal);
1048     }
1049 }
1050 
1051 
1052 interface AggregatorInterface {
1053   function latestAnswer() external view returns (int256);
1054   function latestTimestamp() external view returns (uint256);
1055   function latestRound() external view returns (uint256);
1056   function getAnswer(uint256 roundId) external view returns (int256);
1057   function getTimestamp(uint256 roundId) external view returns (uint256);
1058 
1059   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
1060   event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
1061 }
1062 
1063 
1064 interface AggregatorV3Interface {
1065 
1066   function decimals() external view returns (uint8);
1067   function description() external view returns (string memory);
1068   function version() external view returns (uint256);
1069 
1070   // getRoundData and latestRoundData should both raise "No data present"
1071   // if they do not have data to report, instead of returning unset values
1072   // which could be misinterpreted as actual reported values.
1073   function getRoundData(uint80 _roundId)
1074     external
1075     view
1076     returns (
1077       uint80 roundId,
1078       int256 answer,
1079       uint256 startedAt,
1080       uint256 updatedAt,
1081       uint80 answeredInRound
1082     );
1083   function latestRoundData()
1084     external
1085     view
1086     returns (
1087       uint80 roundId,
1088       int256 answer,
1089       uint256 startedAt,
1090       uint256 updatedAt,
1091       uint80 answeredInRound
1092     );
1093 
1094 }
1095 
1096 
1097 /**
1098  * @title The V2 & V3 Aggregator Interface
1099  * @notice Solidity V0.5 does not allow interfaces to inherit from other
1100  * interfaces so this contract is a combination of v0.5 AggregatorInterface.sol
1101  * and v0.5 AggregatorV3Interface.sol.
1102  */
1103 interface AggregatorV2V3Interface {
1104   //
1105   // V2 Interface:
1106   //
1107   function latestAnswer() external view returns (int256);
1108   function latestTimestamp() external view returns (uint256);
1109   function latestRound() external view returns (uint256);
1110   function getAnswer(uint256 roundId) external view returns (int256);
1111   function getTimestamp(uint256 roundId) external view returns (uint256);
1112 
1113   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
1114   event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
1115 
1116   //
1117   // V3 Interface:
1118   //
1119   function decimals() external view returns (uint8);
1120   function description() external view returns (string memory);
1121   function version() external view returns (uint256);
1122 
1123   // getRoundData and latestRoundData should both raise "No data present"
1124   // if they do not have data to report, instead of returning unset values
1125   // which could be misinterpreted as actual reported values.
1126   function getRoundData(uint80 _roundId)
1127     external
1128     view
1129     returns (
1130       uint80 roundId,
1131       int256 answer,
1132       uint256 startedAt,
1133       uint256 updatedAt,
1134       uint80 answeredInRound
1135     );
1136   function latestRoundData()
1137     external
1138     view
1139     returns (
1140       uint80 roundId,
1141       int256 answer,
1142       uint256 startedAt,
1143       uint256 updatedAt,
1144       uint80 answeredInRound
1145     );
1146 
1147 }
1148 
1149 
1150 interface FlagsInterface {
1151   function getFlag(address) external view returns (bool);
1152   function getFlags(address[] calldata) external view returns (bool[] memory);
1153   function raiseFlag(address) external;
1154   function raiseFlags(address[] calldata) external;
1155   function lowerFlags(address[] calldata) external;
1156   function setRaisingAccessController(address) external;
1157 }
1158 
1159 
1160 interface IVirtualPynth {
1161     // Views
1162     function balanceOfUnderlying(address account) external view returns (uint);
1163 
1164     function rate() external view returns (uint);
1165 
1166     function readyToSettle() external view returns (bool);
1167 
1168     function secsLeftInWaitingPeriod() external view returns (uint);
1169 
1170     function settled() external view returns (bool);
1171 
1172     function pynth() external view returns (IPynth);
1173 
1174     // Mutative functions
1175     function settle(address account) external;
1176 }
1177 
1178 
1179 // https://docs.peri.finance/contracts/source/interfaces/iexchanger
1180 interface IExchanger {
1181     // Views
1182     function calculateAmountAfterSettlement(
1183         address from,
1184         bytes32 currencyKey,
1185         uint amount,
1186         uint refunded
1187     ) external view returns (uint amountAfterSettlement);
1188 
1189     function isPynthRateInvalid(bytes32 currencyKey) external view returns (bool);
1190 
1191     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
1192 
1193     function settlementOwing(address account, bytes32 currencyKey)
1194         external
1195         view
1196         returns (
1197             uint reclaimAmount,
1198             uint rebateAmount,
1199             uint numEntries
1200         );
1201 
1202     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
1203 
1204     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
1205         external
1206         view
1207         returns (uint exchangeFeeRate);
1208 
1209     function getAmountsForExchange(
1210         uint sourceAmount,
1211         bytes32 sourceCurrencyKey,
1212         bytes32 destinationCurrencyKey
1213     )
1214         external
1215         view
1216         returns (
1217             uint amountReceived,
1218             uint fee,
1219             uint exchangeFeeRate
1220         );
1221 
1222     function priceDeviationThresholdFactor() external view returns (uint);
1223 
1224     function waitingPeriodSecs() external view returns (uint);
1225 
1226     // Mutative functions
1227     function exchange(
1228         address from,
1229         bytes32 sourceCurrencyKey,
1230         uint sourceAmount,
1231         bytes32 destinationCurrencyKey,
1232         address destinationAddress
1233     ) external returns (uint amountReceived);
1234 
1235     function exchangeOnBehalf(
1236         address exchangeForAddress,
1237         address from,
1238         bytes32 sourceCurrencyKey,
1239         uint sourceAmount,
1240         bytes32 destinationCurrencyKey
1241     ) external returns (uint amountReceived);
1242 
1243     function exchangeWithTracking(
1244         address from,
1245         bytes32 sourceCurrencyKey,
1246         uint sourceAmount,
1247         bytes32 destinationCurrencyKey,
1248         address destinationAddress,
1249         address originator,
1250         bytes32 trackingCode
1251     ) external returns (uint amountReceived);
1252 
1253     function exchangeOnBehalfWithTracking(
1254         address exchangeForAddress,
1255         address from,
1256         bytes32 sourceCurrencyKey,
1257         uint sourceAmount,
1258         bytes32 destinationCurrencyKey,
1259         address originator,
1260         bytes32 trackingCode
1261     ) external returns (uint amountReceived);
1262 
1263     function exchangeWithVirtual(
1264         address from,
1265         bytes32 sourceCurrencyKey,
1266         uint sourceAmount,
1267         bytes32 destinationCurrencyKey,
1268         address destinationAddress,
1269         bytes32 trackingCode
1270     ) external returns (uint amountReceived, IVirtualPynth vPynth);
1271 
1272     function settle(address from, bytes32 currencyKey)
1273         external
1274         returns (
1275             uint reclaimed,
1276             uint refunded,
1277             uint numEntries
1278         );
1279 
1280     function setLastExchangeRateForPynth(bytes32 currencyKey, uint rate) external;
1281 
1282     function suspendPynthWithInvalidRate(bytes32 currencyKey) external;
1283 }
1284 
1285 
1286 // Inheritance
1287 
1288 
1289 // Libraries
1290 
1291 
1292 // Internal references
1293 // AggregatorInterface from Chainlink represents a decentralized pricing network for a single currency key
1294 
1295 // FlagsInterface from Chainlink addresses SIP-76
1296 
1297 
1298 interface IExternalRateAggregator {
1299     function getRateAndUpdatedTime(bytes32 _currencyKey) external view returns (uint, uint);
1300 }
1301 
1302 // https://docs.peri.finance/contracts/source/contracts/exchangerates
1303 contract ExchangeRates is Owned, MixinSystemSettings, IExchangeRates {
1304     using SafeMath for uint;
1305     using SafeDecimalMath for uint;
1306 
1307     // Exchange rates and update times stored by currency code, e.g. 'PERI', or 'pUSD'
1308     mapping(bytes32 => mapping(uint => RateAndUpdatedTime)) private _rates;
1309 
1310     // The address of the oracle which pushes rate updates to this contract
1311     address public oracle;
1312 
1313     address public externalRateAggregator;
1314 
1315     mapping(bytes32 => bool) public currencyByExternal;
1316 
1317     // Decentralized oracle networks that feed into pricing aggregators
1318     mapping(bytes32 => AggregatorV2V3Interface) public aggregators;
1319 
1320     mapping(bytes32 => uint8) public currencyKeyDecimals;
1321 
1322     // List of aggregator keys for convenient iteration
1323     bytes32[] public aggregatorKeys;
1324 
1325     // Do not allow the oracle to submit times any further forward into the future than this constant.
1326     uint private constant ORACLE_FUTURE_LIMIT = 10 minutes;
1327 
1328     mapping(bytes32 => InversePricing) public inversePricing;
1329 
1330     bytes32[] public invertedKeys;
1331 
1332     mapping(bytes32 => uint) public currentRoundForRate;
1333 
1334     mapping(bytes32 => uint) public roundFrozen;
1335 
1336     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1337     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1338 
1339     //
1340     // ========== CONSTRUCTOR ==========
1341 
1342     constructor(
1343         address _owner,
1344         address _oracle,
1345         address _resolver,
1346         bytes32[] memory _currencyKeys,
1347         uint[] memory _newRates
1348     ) public Owned(_owner) MixinSystemSettings(_resolver) {
1349         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
1350 
1351         oracle = _oracle;
1352 
1353         // The pUSD rate is always 1 and is never stale.
1354         _setRate("pUSD", SafeDecimalMath.unit(), now);
1355 
1356         internalUpdateRates(_currencyKeys, _newRates, now);
1357     }
1358 
1359     /* ========== SETTERS ========== */
1360 
1361     function setOracle(address _oracle) external onlyOwner {
1362         oracle = _oracle;
1363         emit OracleUpdated(oracle);
1364     }
1365 
1366     function setExternalRateAggregator(address _aggregator) external onlyOwner {
1367         externalRateAggregator = _aggregator;
1368     }
1369 
1370     function setCurrencyToExternalAggregator(bytes32 _currencyKey, bool _set) external onlyOwner {
1371         currencyByExternal[_currencyKey] = _set;
1372     }
1373 
1374     /* ========== MUTATIVE FUNCTIONS ========== */
1375 
1376     function updateRates(
1377         bytes32[] calldata currencyKeys,
1378         uint[] calldata newRates,
1379         uint timeSent
1380     ) external onlyOracle returns (bool) {
1381         return internalUpdateRates(currencyKeys, newRates, timeSent);
1382     }
1383 
1384     function deleteRate(bytes32 currencyKey) external onlyOracle {
1385         require(_getRate(currencyKey) > 0, "Rate is zero");
1386 
1387         delete _rates[currencyKey][currentRoundForRate[currencyKey]];
1388 
1389         currentRoundForRate[currencyKey]--;
1390 
1391         emit RateDeleted(currencyKey);
1392     }
1393 
1394     function setInversePricing(
1395         bytes32 currencyKey,
1396         uint entryPoint,
1397         uint upperLimit,
1398         uint lowerLimit,
1399         bool freezeAtUpperLimit,
1400         bool freezeAtLowerLimit
1401     ) external onlyOwner {
1402         // 0 < lowerLimit < entryPoint => 0 < entryPoint
1403         require(lowerLimit > 0, "lowerLimit must be above 0");
1404         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
1405         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
1406         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
1407 
1408         require(!(freezeAtUpperLimit && freezeAtLowerLimit), "Cannot freeze at both limits");
1409 
1410         InversePricing storage inverse = inversePricing[currencyKey];
1411         if (inverse.entryPoint == 0) {
1412             // then we are adding a new inverse pricing, so add this
1413             invertedKeys.push(currencyKey);
1414         }
1415         inverse.entryPoint = entryPoint;
1416         inverse.upperLimit = upperLimit;
1417         inverse.lowerLimit = lowerLimit;
1418 
1419         if (freezeAtUpperLimit || freezeAtLowerLimit) {
1420             // When indicating to freeze, we need to know the rate to freeze it at - either upper or lower
1421             // this is useful in situations where ExchangeRates is updated and there are existing inverted
1422             // rates already frozen in the current contract that need persisting across the upgrade
1423 
1424             inverse.frozenAtUpperLimit = freezeAtUpperLimit;
1425             inverse.frozenAtLowerLimit = freezeAtLowerLimit;
1426             uint roundId = _getCurrentRoundId(currencyKey);
1427             roundFrozen[currencyKey] = roundId;
1428             emit InversePriceFrozen(currencyKey, freezeAtUpperLimit ? upperLimit : lowerLimit, roundId, msg.sender);
1429         } else {
1430             // unfreeze if need be
1431             inverse.frozenAtUpperLimit = false;
1432             inverse.frozenAtLowerLimit = false;
1433             // remove any tracking
1434             roundFrozen[currencyKey] = 0;
1435         }
1436 
1437         // SIP-78
1438         uint rate = _getRate(currencyKey);
1439         if (rate > 0) {
1440             exchanger().setLastExchangeRateForPynth(currencyKey, rate);
1441         }
1442 
1443         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
1444     }
1445 
1446     function removeInversePricing(bytes32 currencyKey) external onlyOwner {
1447         require(inversePricing[currencyKey].entryPoint > 0, "No inverted price exists");
1448 
1449         delete inversePricing[currencyKey];
1450 
1451         // now remove inverted key from array
1452         bool wasRemoved = removeFromArray(currencyKey, invertedKeys);
1453 
1454         if (wasRemoved) {
1455             emit InversePriceConfigured(currencyKey, 0, 0, 0);
1456         }
1457     }
1458 
1459     function addAggregator(bytes32 currencyKey, address aggregatorAddress) external onlyOwner {
1460         AggregatorV2V3Interface aggregator = AggregatorV2V3Interface(aggregatorAddress);
1461         // This check tries to make sure that a valid aggregator is being added.
1462         // It checks if the aggregator is an existing smart contract that has implemented `latestTimestamp` function.
1463 
1464         require(aggregator.latestRound() >= 0, "Given Aggregator is invalid");
1465         uint8 decimals = aggregator.decimals();
1466         require(decimals <= 18, "Aggregator decimals should be lower or equal to 18");
1467         if (address(aggregators[currencyKey]) == address(0)) {
1468             aggregatorKeys.push(currencyKey);
1469         }
1470         aggregators[currencyKey] = aggregator;
1471         currencyKeyDecimals[currencyKey] = decimals;
1472         emit AggregatorAdded(currencyKey, address(aggregator));
1473     }
1474 
1475     function removeAggregator(bytes32 currencyKey) external onlyOwner {
1476         address aggregator = address(aggregators[currencyKey]);
1477         require(aggregator != address(0), "No aggregator exists for key");
1478         delete aggregators[currencyKey];
1479         delete currencyKeyDecimals[currencyKey];
1480 
1481         bool wasRemoved = removeFromArray(currencyKey, aggregatorKeys);
1482 
1483         if (wasRemoved) {
1484             emit AggregatorRemoved(currencyKey, aggregator);
1485         }
1486     }
1487 
1488     // SIP-75 Public keeper function to freeze a pynth that is out of bounds
1489     function freezeRate(bytes32 currencyKey) external {
1490         InversePricing storage inverse = inversePricing[currencyKey];
1491         require(inverse.entryPoint > 0, "Cannot freeze non-inverse rate");
1492         require(!inverse.frozenAtUpperLimit && !inverse.frozenAtLowerLimit, "The rate is already frozen");
1493 
1494         uint rate = _getRate(currencyKey);
1495 
1496         if (rate > 0 && (rate >= inverse.upperLimit || rate <= inverse.lowerLimit)) {
1497             inverse.frozenAtUpperLimit = (rate == inverse.upperLimit);
1498             inverse.frozenAtLowerLimit = (rate == inverse.lowerLimit);
1499             uint currentRoundId = _getCurrentRoundId(currencyKey);
1500             roundFrozen[currencyKey] = currentRoundId;
1501             emit InversePriceFrozen(currencyKey, rate, currentRoundId, msg.sender);
1502         } else {
1503             revert("Rate within bounds");
1504         }
1505     }
1506 
1507     /* ========== VIEWS ========== */
1508 
1509     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1510         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1511         bytes32[] memory newAddresses = new bytes32[](1);
1512         newAddresses[0] = CONTRACT_EXCHANGER;
1513         addresses = combineArrays(existingAddresses, newAddresses);
1514     }
1515 
1516     // SIP-75 View to determine if freezeRate can be called safely
1517     function canFreezeRate(bytes32 currencyKey) external view returns (bool) {
1518         InversePricing memory inverse = inversePricing[currencyKey];
1519         if (inverse.entryPoint == 0 || inverse.frozenAtUpperLimit || inverse.frozenAtLowerLimit) {
1520             return false;
1521         } else {
1522             uint rate = _getRate(currencyKey);
1523             return (rate > 0 && (rate >= inverse.upperLimit || rate <= inverse.lowerLimit));
1524         }
1525     }
1526 
1527     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory currencies) {
1528         uint count = 0;
1529         currencies = new bytes32[](aggregatorKeys.length);
1530         for (uint i = 0; i < aggregatorKeys.length; i++) {
1531             bytes32 currencyKey = aggregatorKeys[i];
1532             if (address(aggregators[currencyKey]) == aggregator) {
1533                 currencies[count++] = currencyKey;
1534             }
1535         }
1536     }
1537 
1538     function rateStalePeriod() external view returns (uint) {
1539         return getRateStalePeriod();
1540     }
1541 
1542     function aggregatorWarningFlags() external view returns (address) {
1543         return getAggregatorWarningFlags();
1544     }
1545 
1546     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time) {
1547         RateAndUpdatedTime memory rateAndTime = _getRateAndUpdatedTime(currencyKey);
1548         return (rateAndTime.rate, rateAndTime.time);
1549     }
1550 
1551     function getLastRoundIdBeforeElapsedSecs(
1552         bytes32 currencyKey,
1553         uint startingRoundId,
1554         uint startingTimestamp,
1555         uint timediff
1556     ) external view returns (uint) {
1557         uint roundId = startingRoundId;
1558         uint nextTimestamp = 0;
1559         while (true) {
1560             (, nextTimestamp) = _getRateAndTimestampAtRound(currencyKey, roundId + 1);
1561             // if there's no new round, then the previous roundId was the latest
1562             if (nextTimestamp == 0 || nextTimestamp > startingTimestamp + timediff) {
1563                 return roundId;
1564             }
1565             roundId++;
1566         }
1567         return roundId;
1568     }
1569 
1570     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint) {
1571         return _getCurrentRoundId(currencyKey);
1572     }
1573 
1574     function effectiveValueAtRound(
1575         bytes32 sourceCurrencyKey,
1576         uint sourceAmount,
1577         bytes32 destinationCurrencyKey,
1578         uint roundIdForSrc,
1579         uint roundIdForDest
1580     ) external view returns (uint value) {
1581         // If there's no change in the currency, then just return the amount they gave us
1582         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
1583 
1584         (uint srcRate, ) = _getRateAndTimestampAtRound(sourceCurrencyKey, roundIdForSrc);
1585         (uint destRate, ) = _getRateAndTimestampAtRound(destinationCurrencyKey, roundIdForDest);
1586         if (destRate == 0) {
1587             // prevent divide-by 0 error (this can happen when roundIDs jump epochs due
1588             // to aggregator upgrades)
1589             return 0;
1590         }
1591         // Calculate the effective value by going from source -> USD -> destination
1592         value = sourceAmount.multiplyDecimalRound(srcRate).divideDecimalRound(destRate);
1593     }
1594 
1595     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time) {
1596         return _getRateAndTimestampAtRound(currencyKey, roundId);
1597     }
1598 
1599     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256) {
1600         return _getUpdatedTime(currencyKey);
1601     }
1602 
1603     function lastRateUpdateTimesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory) {
1604         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
1605 
1606         for (uint i = 0; i < currencyKeys.length; i++) {
1607             lastUpdateTimes[i] = _getUpdatedTime(currencyKeys[i]);
1608         }
1609 
1610         return lastUpdateTimes;
1611     }
1612 
1613     function effectiveValue(
1614         bytes32 sourceCurrencyKey,
1615         uint sourceAmount,
1616         bytes32 destinationCurrencyKey
1617     ) external view returns (uint value) {
1618         (value, , ) = _effectiveValueAndRates(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
1619     }
1620 
1621     function effectiveValueAndRates(
1622         bytes32 sourceCurrencyKey,
1623         uint sourceAmount,
1624         bytes32 destinationCurrencyKey
1625     )
1626         external
1627         view
1628         returns (
1629             uint value,
1630             uint sourceRate,
1631             uint destinationRate
1632         )
1633     {
1634         return _effectiveValueAndRates(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
1635     }
1636 
1637     function rateForCurrency(bytes32 currencyKey) external view returns (uint) {
1638         return _getRateAndUpdatedTime(currencyKey).rate;
1639     }
1640 
1641     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
1642         external
1643         view
1644         returns (uint[] memory rates, uint[] memory times)
1645     {
1646         rates = new uint[](numRounds);
1647         times = new uint[](numRounds);
1648 
1649         uint roundId = _getCurrentRoundId(currencyKey);
1650         for (uint i = 0; i < numRounds; i++) {
1651             // fetch the rate and treat is as current, so inverse limits if frozen will always be applied
1652             // regardless of current rate
1653             (rates[i], times[i]) = _getRateAndTimestampAtRound(currencyKey, roundId);
1654 
1655             if (roundId == 0) {
1656                 // if we hit the last round, then return what we have
1657                 return (rates, times);
1658             } else {
1659                 roundId--;
1660             }
1661         }
1662     }
1663 
1664     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory) {
1665         uint[] memory _localRates = new uint[](currencyKeys.length);
1666 
1667         for (uint i = 0; i < currencyKeys.length; i++) {
1668             _localRates[i] = _getRate(currencyKeys[i]);
1669         }
1670 
1671         return _localRates;
1672     }
1673 
1674     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid) {
1675         RateAndUpdatedTime memory rateAndTime = _getRateAndUpdatedTime(currencyKey);
1676 
1677         if (currencyKey == "pUSD") {
1678             return (rateAndTime.rate, false);
1679         }
1680         return (
1681             rateAndTime.rate,
1682             _rateIsStaleWithTime(getRateStalePeriod(), rateAndTime.time) ||
1683                 _rateIsFlagged(currencyKey, FlagsInterface(getAggregatorWarningFlags()))
1684         );
1685     }
1686 
1687     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1688         external
1689         view
1690         returns (uint[] memory rates, bool anyRateInvalid)
1691     {
1692         rates = new uint[](currencyKeys.length);
1693 
1694         uint256 _rateStalePeriod = getRateStalePeriod();
1695 
1696         // fetch all flags at once
1697         bool[] memory flagList = getFlagsForRates(currencyKeys);
1698 
1699         for (uint i = 0; i < currencyKeys.length; i++) {
1700             // do one lookup of the rate & time to minimize gas
1701             RateAndUpdatedTime memory rateEntry = _getRateAndUpdatedTime(currencyKeys[i]);
1702             rates[i] = rateEntry.rate;
1703             if (!anyRateInvalid && currencyKeys[i] != "pUSD") {
1704                 anyRateInvalid = flagList[i] || _rateIsStaleWithTime(_rateStalePeriod, rateEntry.time);
1705             }
1706         }
1707     }
1708 
1709     function rateIsStale(bytes32 currencyKey) external view returns (bool) {
1710         return _rateIsStale(currencyKey, getRateStalePeriod());
1711     }
1712 
1713     function rateIsFrozen(bytes32 currencyKey) external view returns (bool) {
1714         return _rateIsFrozen(currencyKey);
1715     }
1716 
1717     function rateIsInvalid(bytes32 currencyKey) external view returns (bool) {
1718         return
1719             _rateIsStale(currencyKey, getRateStalePeriod()) ||
1720             _rateIsFlagged(currencyKey, FlagsInterface(getAggregatorWarningFlags()));
1721     }
1722 
1723     function rateIsFlagged(bytes32 currencyKey) external view returns (bool) {
1724         return _rateIsFlagged(currencyKey, FlagsInterface(getAggregatorWarningFlags()));
1725     }
1726 
1727     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool) {
1728         // Loop through each key and check whether the data point is stale.
1729 
1730         uint256 _rateStalePeriod = getRateStalePeriod();
1731         bool[] memory flagList = getFlagsForRates(currencyKeys);
1732 
1733         for (uint i = 0; i < currencyKeys.length; i++) {
1734             if (flagList[i] || _rateIsStale(currencyKeys[i], _rateStalePeriod)) {
1735                 return true;
1736             }
1737         }
1738 
1739         return false;
1740     }
1741 
1742     /* ========== INTERNAL FUNCTIONS ========== */
1743 
1744     function exchanger() internal view returns (IExchanger) {
1745         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER));
1746     }
1747 
1748     function getFlagsForRates(bytes32[] memory currencyKeys) internal view returns (bool[] memory flagList) {
1749         FlagsInterface _flags = FlagsInterface(getAggregatorWarningFlags());
1750 
1751         // fetch all flags at once
1752         if (_flags != FlagsInterface(0)) {
1753             address[] memory _aggregators = new address[](currencyKeys.length);
1754 
1755             for (uint i = 0; i < currencyKeys.length; i++) {
1756                 _aggregators[i] = address(aggregators[currencyKeys[i]]);
1757             }
1758 
1759             flagList = _flags.getFlags(_aggregators);
1760         } else {
1761             flagList = new bool[](currencyKeys.length);
1762         }
1763     }
1764 
1765     function _setRate(
1766         bytes32 currencyKey,
1767         uint256 rate,
1768         uint256 time
1769     ) internal {
1770         // Note: this will effectively start the rounds at 1, which matches Chainlink's Agggregators
1771         currentRoundForRate[currencyKey]++;
1772 
1773         _rates[currencyKey][currentRoundForRate[currencyKey]] = RateAndUpdatedTime({
1774             rate: uint216(rate),
1775             time: uint40(time)
1776         });
1777     }
1778 
1779     function internalUpdateRates(
1780         bytes32[] memory currencyKeys,
1781         uint[] memory newRates,
1782         uint timeSent
1783     ) internal returns (bool) {
1784         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
1785         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
1786 
1787         // Loop through each key and perform update.
1788         for (uint i = 0; i < currencyKeys.length; i++) {
1789             bytes32 currencyKey = currencyKeys[i];
1790 
1791             // Should not set any rate to zero ever, as no asset will ever be
1792             // truely worthless and still valid. In this scenario, we should
1793             // delete the rate and remove it from the system.
1794             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
1795             require(currencyKey != "pUSD", "Rate of pUSD cannot be updated, it's always UNIT.");
1796 
1797             // We should only update the rate if it's at least the same age as the last rate we've got.
1798             if (timeSent < _getUpdatedTime(currencyKey)) {
1799                 continue;
1800             }
1801 
1802             // Ok, go ahead with the update.
1803             _setRate(currencyKey, newRates[i], timeSent);
1804         }
1805 
1806         emit RatesUpdated(currencyKeys, newRates);
1807 
1808         return true;
1809     }
1810 
1811     function removeFromArray(bytes32 entry, bytes32[] storage array) internal returns (bool) {
1812         for (uint i = 0; i < array.length; i++) {
1813             if (array[i] == entry) {
1814                 delete array[i];
1815 
1816                 // Copy the last key into the place of the one we just deleted
1817                 // If there's only one key, this is array[0] = array[0].
1818                 // If we're deleting the last one, it's also a NOOP in the same way.
1819                 array[i] = array[array.length - 1];
1820 
1821                 // Decrease the size of the array by one.
1822                 array.length--;
1823 
1824                 return true;
1825             }
1826         }
1827         return false;
1828     }
1829 
1830     function _rateOrInverted(
1831         bytes32 currencyKey,
1832         uint rate,
1833         uint roundId
1834     ) internal view returns (uint newRate) {
1835         // if an inverse mapping exists, adjust the price accordingly
1836         InversePricing memory inverse = inversePricing[currencyKey];
1837         if (inverse.entryPoint == 0 || rate == 0) {
1838             // when no inverse is set or when given a 0 rate, return the rate, regardless of the inverse status
1839             // (the latter is so when a new inverse is set but the underlying has no rate, it will return 0 as
1840             // the rate, not the lowerLimit)
1841             return rate;
1842         }
1843 
1844         newRate = rate;
1845 
1846         // Determine when round was frozen (if any)
1847         uint roundWhenRateFrozen = roundFrozen[currencyKey];
1848         // And if we're looking at a rate after frozen, and it's currently frozen, then apply the bounds limit even
1849         // if the current price is back within bounds
1850         if (roundId >= roundWhenRateFrozen && inverse.frozenAtUpperLimit) {
1851             newRate = inverse.upperLimit;
1852         } else if (roundId >= roundWhenRateFrozen && inverse.frozenAtLowerLimit) {
1853             newRate = inverse.lowerLimit;
1854         } else {
1855             // this ensures any rate outside the limit will never be returned
1856             uint doubleEntryPoint = inverse.entryPoint.mul(2);
1857             if (doubleEntryPoint <= rate) {
1858                 // avoid negative numbers for unsigned ints, so set this to 0
1859                 // which by the requirement that lowerLimit be > 0 will
1860                 // cause this to freeze the price to the lowerLimit
1861                 newRate = 0;
1862             } else {
1863                 newRate = doubleEntryPoint.sub(rate);
1864             }
1865 
1866             // now ensure the rate is between the bounds
1867             if (newRate >= inverse.upperLimit) {
1868                 newRate = inverse.upperLimit;
1869             } else if (newRate <= inverse.lowerLimit) {
1870                 newRate = inverse.lowerLimit;
1871             }
1872         }
1873     }
1874 
1875     function _formatAggregatorAnswer(bytes32 currencyKey, int256 rate) internal view returns (uint) {
1876         require(rate >= 0, "Negative rate not supported");
1877         if (currencyKeyDecimals[currencyKey] > 0) {
1878             uint multiplier = 10**uint(SafeMath.sub(18, currencyKeyDecimals[currencyKey]));
1879             return uint(uint(rate).mul(multiplier));
1880         }
1881         return uint(rate);
1882     }
1883 
1884     function _getRateAndUpdatedTime(bytes32 currencyKey) internal view returns (RateAndUpdatedTime memory) {
1885         if (currencyByExternal[currencyKey]) {
1886             require(externalRateAggregator != address(0), "External price aggregator is not set yet");
1887 
1888             IExternalRateAggregator _externalRateAggregator = IExternalRateAggregator(externalRateAggregator);
1889 
1890             (uint rate, uint time) = _externalRateAggregator.getRateAndUpdatedTime(currencyKey);
1891 
1892             return RateAndUpdatedTime({rate: uint216(rate), time: uint40(time)});
1893         }
1894 
1895         AggregatorV2V3Interface aggregator = aggregators[currencyKey];
1896 
1897         if (aggregator != AggregatorV2V3Interface(0)) {
1898             // this view from the aggregator is the most gas efficient but it can throw when there's no data,
1899             // so let's call it low-level to suppress any reverts
1900             bytes memory payload = abi.encodeWithSignature("latestRoundData()");
1901             // solhint-disable avoid-low-level-calls
1902             (bool success, bytes memory returnData) = address(aggregator).staticcall(payload);
1903 
1904             if (success) {
1905                 (uint80 roundId, int256 answer, , uint256 updatedAt, ) =
1906                     abi.decode(returnData, (uint80, int256, uint256, uint256, uint80));
1907                 return
1908                     RateAndUpdatedTime({
1909                         rate: uint216(_rateOrInverted(currencyKey, _formatAggregatorAnswer(currencyKey, answer), roundId)),
1910                         time: uint40(updatedAt)
1911                     });
1912             }
1913         } else {
1914             uint roundId = currentRoundForRate[currencyKey];
1915             RateAndUpdatedTime memory entry = _rates[currencyKey][roundId];
1916 
1917             return RateAndUpdatedTime({rate: uint216(_rateOrInverted(currencyKey, entry.rate, roundId)), time: entry.time});
1918         }
1919     }
1920 
1921     function _getCurrentRoundId(bytes32 currencyKey) internal view returns (uint) {
1922         AggregatorV2V3Interface aggregator = aggregators[currencyKey];
1923 
1924         if (aggregator != AggregatorV2V3Interface(0)) {
1925             return aggregator.latestRound();
1926         } else {
1927             return currentRoundForRate[currencyKey];
1928         }
1929     }
1930 
1931     function _getRateAndTimestampAtRound(bytes32 currencyKey, uint roundId) internal view returns (uint rate, uint time) {
1932         AggregatorV2V3Interface aggregator = aggregators[currencyKey];
1933 
1934         if (aggregator != AggregatorV2V3Interface(0)) {
1935             // this view from the aggregator is the most gas efficient but it can throw when there's no data,
1936             // so let's call it low-level to suppress any reverts
1937             bytes memory payload = abi.encodeWithSignature("getRoundData(uint80)", roundId);
1938             // solhint-disable avoid-low-level-calls
1939             (bool success, bytes memory returnData) = address(aggregator).staticcall(payload);
1940 
1941             if (success) {
1942                 (, int256 answer, , uint256 updatedAt, ) =
1943                     abi.decode(returnData, (uint80, int256, uint256, uint256, uint80));
1944                 return (_rateOrInverted(currencyKey, _formatAggregatorAnswer(currencyKey, answer), roundId), updatedAt);
1945             }
1946         } else {
1947             RateAndUpdatedTime memory update = _rates[currencyKey][roundId];
1948             return (_rateOrInverted(currencyKey, update.rate, roundId), update.time);
1949         }
1950     }
1951 
1952     function _getRate(bytes32 currencyKey) internal view returns (uint256) {
1953         return _getRateAndUpdatedTime(currencyKey).rate;
1954     }
1955 
1956     function _getUpdatedTime(bytes32 currencyKey) internal view returns (uint256) {
1957         return _getRateAndUpdatedTime(currencyKey).time;
1958     }
1959 
1960     function _effectiveValueAndRates(
1961         bytes32 sourceCurrencyKey,
1962         uint sourceAmount,
1963         bytes32 destinationCurrencyKey
1964     )
1965         internal
1966         view
1967         returns (
1968             uint value,
1969             uint sourceRate,
1970             uint destinationRate
1971         )
1972     {
1973         sourceRate = _getRate(sourceCurrencyKey);
1974         // If there's no change in the currency, then just return the amount they gave us
1975         if (sourceCurrencyKey == destinationCurrencyKey) {
1976             destinationRate = sourceRate;
1977             value = sourceAmount;
1978         } else {
1979             // Calculate the effective value by going from source -> USD -> destination
1980             destinationRate = _getRate(destinationCurrencyKey);
1981             // prevent divide-by 0 error (this happens if the dest is not a valid rate)
1982             if (destinationRate > 0) {
1983                 value = sourceAmount.multiplyDecimalRound(sourceRate).divideDecimalRound(destinationRate);
1984             }
1985         }
1986     }
1987 
1988     function _rateIsStale(bytes32 currencyKey, uint _rateStalePeriod) internal view returns (bool) {
1989         // pUSD is a special case and is never stale (check before an SLOAD of getRateAndUpdatedTime)
1990         if (currencyKey == "pUSD") return false;
1991 
1992         return _rateIsStaleWithTime(_rateStalePeriod, _getUpdatedTime(currencyKey));
1993     }
1994 
1995     function _rateIsStaleWithTime(uint _rateStalePeriod, uint _time) internal view returns (bool) {
1996         return _time.add(_rateStalePeriod) < now;
1997     }
1998 
1999     function _rateIsFrozen(bytes32 currencyKey) internal view returns (bool) {
2000         InversePricing memory inverse = inversePricing[currencyKey];
2001         return inverse.frozenAtUpperLimit || inverse.frozenAtLowerLimit;
2002     }
2003 
2004     function _rateIsFlagged(bytes32 currencyKey, FlagsInterface flags) internal view returns (bool) {
2005         // pUSD is a special case and is never invalid
2006         if (currencyKey == "pUSD") return false;
2007         address aggregator = address(aggregators[currencyKey]);
2008         // when no aggregator or when the flags haven't been setup
2009         if (aggregator == address(0) || flags == FlagsInterface(0)) {
2010             return false;
2011         }
2012         return flags.getFlag(aggregator);
2013     }
2014 
2015     /* ========== MODIFIERS ========== */
2016 
2017     modifier onlyOracle {
2018         _onlyOracle();
2019         _;
2020     }
2021 
2022     function _onlyOracle() internal view {
2023         require(msg.sender == oracle, "Only the oracle can perform this action");
2024     }
2025 
2026     /* ========== EVENTS ========== */
2027 
2028     event OracleUpdated(address newOracle);
2029     event RatesUpdated(bytes32[] currencyKeys, uint[] newRates);
2030     event RateDeleted(bytes32 currencyKey);
2031     event InversePriceConfigured(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
2032     event InversePriceFrozen(bytes32 currencyKey, uint rate, uint roundId, address initiator);
2033     event AggregatorAdded(bytes32 currencyKey, address aggregator);
2034     event AggregatorRemoved(bytes32 currencyKey, address aggregator);
2035 }
2036 
2037     