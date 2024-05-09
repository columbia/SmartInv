1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: ExchangerWithVirtualSynth.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/ExchangerWithVirtualSynth.sol
11 * Docs: https://docs.synthetix.io/contracts/ExchangerWithVirtualSynth
12 *
13 * Contract Dependencies: 
14 *	- ERC20
15 *	- Exchanger
16 *	- IAddressResolver
17 *	- IERC20
18 *	- IExchanger
19 *	- IVirtualSynth
20 *	- MixinResolver
21 *	- MixinSystemSettings
22 *	- Owned
23 * Libraries: 
24 *	- SafeDecimalMath
25 *	- SafeMath
26 *
27 * MIT License
28 * ===========
29 *
30 * Copyright (c) 2020 Synthetix
31 *
32 * Permission is hereby granted, free of charge, to any person obtaining a copy
33 * of this software and associated documentation files (the "Software"), to deal
34 * in the Software without restriction, including without limitation the rights
35 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
36 * copies of the Software, and to permit persons to whom the Software is
37 * furnished to do so, subject to the following conditions:
38 *
39 * The above copyright notice and this permission notice shall be included in all
40 * copies or substantial portions of the Software.
41 *
42 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
43 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
44 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
45 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
46 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
47 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
48 */
49 
50 
51 
52 pragma solidity ^0.5.16;
53 
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
357             address destination = resolver.requireAndGetAddress(
358                 name,
359                 string(abi.encodePacked("Resolver missing target: ", name))
360             );
361             addressCache[name] = destination;
362             emit CacheUpdated(name, destination);
363         }
364     }
365 
366     /* ========== VIEWS ========== */
367 
368     function isResolverCached() external view returns (bool) {
369         bytes32[] memory requiredAddresses = resolverAddressesRequired();
370         for (uint i = 0; i < requiredAddresses.length; i++) {
371             bytes32 name = requiredAddresses[i];
372             // false if our cache is invalid or if the resolver doesn't have the required address
373             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
374                 return false;
375             }
376         }
377 
378         return true;
379     }
380 
381     /* ========== INTERNAL FUNCTIONS ========== */
382 
383     function requireAndGetAddress(bytes32 name) internal view returns (address) {
384         address _foundAddress = addressCache[name];
385         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
386         return _foundAddress;
387     }
388 
389     /* ========== EVENTS ========== */
390 
391     event CacheUpdated(bytes32 name, address destination);
392 }
393 
394 
395 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
396 interface IFlexibleStorage {
397     // Views
398     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
399 
400     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
401 
402     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
403 
404     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
405 
406     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
407 
408     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
409 
410     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
411 
412     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
413 
414     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
415 
416     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
417 
418     // Mutative functions
419     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
420 
421     function deleteIntValue(bytes32 contractName, bytes32 record) external;
422 
423     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
424 
425     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
426 
427     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
428 
429     function setUIntValue(
430         bytes32 contractName,
431         bytes32 record,
432         uint value
433     ) external;
434 
435     function setUIntValues(
436         bytes32 contractName,
437         bytes32[] calldata records,
438         uint[] calldata values
439     ) external;
440 
441     function setIntValue(
442         bytes32 contractName,
443         bytes32 record,
444         int value
445     ) external;
446 
447     function setIntValues(
448         bytes32 contractName,
449         bytes32[] calldata records,
450         int[] calldata values
451     ) external;
452 
453     function setAddressValue(
454         bytes32 contractName,
455         bytes32 record,
456         address value
457     ) external;
458 
459     function setAddressValues(
460         bytes32 contractName,
461         bytes32[] calldata records,
462         address[] calldata values
463     ) external;
464 
465     function setBoolValue(
466         bytes32 contractName,
467         bytes32 record,
468         bool value
469     ) external;
470 
471     function setBoolValues(
472         bytes32 contractName,
473         bytes32[] calldata records,
474         bool[] calldata values
475     ) external;
476 
477     function setBytes32Value(
478         bytes32 contractName,
479         bytes32 record,
480         bytes32 value
481     ) external;
482 
483     function setBytes32Values(
484         bytes32 contractName,
485         bytes32[] calldata records,
486         bytes32[] calldata values
487     ) external;
488 }
489 
490 
491 // Internal references
492 
493 
494 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
495 contract MixinSystemSettings is MixinResolver {
496     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
497 
498     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
499     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
500     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
501     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
502     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
503     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
504     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
505     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
506     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
507     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
508     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
509     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
510     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
511     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
512     bytes32 internal constant SETTING_CROSS_DOMAIN_MESSAGE_GAS_LIMIT = "crossDomainMessageGasLimit";
513 
514     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
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
527     function getCrossDomainMessageGasLimit() internal view returns (uint) {
528         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_CROSS_DOMAIN_MESSAGE_GAS_LIMIT);
529     }
530 
531     function getTradingRewardsEnabled() internal view returns (bool) {
532         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
533     }
534 
535     function getWaitingPeriodSecs() internal view returns (uint) {
536         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
537     }
538 
539     function getPriceDeviationThresholdFactor() internal view returns (uint) {
540         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
541     }
542 
543     function getIssuanceRatio() internal view returns (uint) {
544         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
545         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
546     }
547 
548     function getFeePeriodDuration() internal view returns (uint) {
549         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
550         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
551     }
552 
553     function getTargetThreshold() internal view returns (uint) {
554         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
555         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
556     }
557 
558     function getLiquidationDelay() internal view returns (uint) {
559         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
560     }
561 
562     function getLiquidationRatio() internal view returns (uint) {
563         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
564     }
565 
566     function getLiquidationPenalty() internal view returns (uint) {
567         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
568     }
569 
570     function getRateStalePeriod() internal view returns (uint) {
571         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
572     }
573 
574     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
575         return
576             flexibleStorage().getUIntValue(
577                 SETTING_CONTRACT_NAME,
578                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
579             );
580     }
581 
582     function getMinimumStakeTime() internal view returns (uint) {
583         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
584     }
585 
586     function getAggregatorWarningFlags() internal view returns (address) {
587         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
588     }
589 
590     function getDebtSnapshotStaleTime() internal view returns (uint) {
591         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
592     }
593 }
594 
595 
596 interface IVirtualSynth {
597     // Views
598     function balanceOfUnderlying(address account) external view returns (uint);
599 
600     function rate() external view returns (uint);
601 
602     function readyToSettle() external view returns (bool);
603 
604     function secsLeftInWaitingPeriod() external view returns (uint);
605 
606     function settled() external view returns (bool);
607 
608     function synth() external view returns (ISynth);
609 
610     // Mutative functions
611     function settle(address account) external;
612 }
613 
614 
615 // https://docs.synthetix.io/contracts/source/interfaces/iexchanger
616 interface IExchanger {
617     // Views
618     function calculateAmountAfterSettlement(
619         address from,
620         bytes32 currencyKey,
621         uint amount,
622         uint refunded
623     ) external view returns (uint amountAfterSettlement);
624 
625     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
626 
627     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
628 
629     function settlementOwing(address account, bytes32 currencyKey)
630         external
631         view
632         returns (
633             uint reclaimAmount,
634             uint rebateAmount,
635             uint numEntries
636         );
637 
638     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
639 
640     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
641         external
642         view
643         returns (uint exchangeFeeRate);
644 
645     function getAmountsForExchange(
646         uint sourceAmount,
647         bytes32 sourceCurrencyKey,
648         bytes32 destinationCurrencyKey
649     )
650         external
651         view
652         returns (
653             uint amountReceived,
654             uint fee,
655             uint exchangeFeeRate
656         );
657 
658     function priceDeviationThresholdFactor() external view returns (uint);
659 
660     function waitingPeriodSecs() external view returns (uint);
661 
662     // Mutative functions
663     function exchange(
664         address from,
665         bytes32 sourceCurrencyKey,
666         uint sourceAmount,
667         bytes32 destinationCurrencyKey,
668         address destinationAddress
669     ) external returns (uint amountReceived);
670 
671     function exchangeOnBehalf(
672         address exchangeForAddress,
673         address from,
674         bytes32 sourceCurrencyKey,
675         uint sourceAmount,
676         bytes32 destinationCurrencyKey
677     ) external returns (uint amountReceived);
678 
679     function exchangeWithTracking(
680         address from,
681         bytes32 sourceCurrencyKey,
682         uint sourceAmount,
683         bytes32 destinationCurrencyKey,
684         address destinationAddress,
685         address originator,
686         bytes32 trackingCode
687     ) external returns (uint amountReceived);
688 
689     function exchangeOnBehalfWithTracking(
690         address exchangeForAddress,
691         address from,
692         bytes32 sourceCurrencyKey,
693         uint sourceAmount,
694         bytes32 destinationCurrencyKey,
695         address originator,
696         bytes32 trackingCode
697     ) external returns (uint amountReceived);
698 
699     function exchangeWithVirtual(
700         address from,
701         bytes32 sourceCurrencyKey,
702         uint sourceAmount,
703         bytes32 destinationCurrencyKey,
704         address destinationAddress,
705         bytes32 trackingCode
706     ) external returns (uint amountReceived, IVirtualSynth vSynth);
707 
708     function settle(address from, bytes32 currencyKey)
709         external
710         returns (
711             uint reclaimed,
712             uint refunded,
713             uint numEntries
714         );
715 
716     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external;
717 
718     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
719 }
720 
721 
722 /**
723  * @dev Wrappers over Solidity's arithmetic operations with added overflow
724  * checks.
725  *
726  * Arithmetic operations in Solidity wrap on overflow. This can easily result
727  * in bugs, because programmers usually assume that an overflow raises an
728  * error, which is the standard behavior in high level programming languages.
729  * `SafeMath` restores this intuition by reverting the transaction when an
730  * operation overflows.
731  *
732  * Using this library instead of the unchecked operations eliminates an entire
733  * class of bugs, so it's recommended to use it always.
734  */
735 library SafeMath {
736     /**
737      * @dev Returns the addition of two unsigned integers, reverting on
738      * overflow.
739      *
740      * Counterpart to Solidity's `+` operator.
741      *
742      * Requirements:
743      * - Addition cannot overflow.
744      */
745     function add(uint256 a, uint256 b) internal pure returns (uint256) {
746         uint256 c = a + b;
747         require(c >= a, "SafeMath: addition overflow");
748 
749         return c;
750     }
751 
752     /**
753      * @dev Returns the subtraction of two unsigned integers, reverting on
754      * overflow (when the result is negative).
755      *
756      * Counterpart to Solidity's `-` operator.
757      *
758      * Requirements:
759      * - Subtraction cannot overflow.
760      */
761     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
762         require(b <= a, "SafeMath: subtraction overflow");
763         uint256 c = a - b;
764 
765         return c;
766     }
767 
768     /**
769      * @dev Returns the multiplication of two unsigned integers, reverting on
770      * overflow.
771      *
772      * Counterpart to Solidity's `*` operator.
773      *
774      * Requirements:
775      * - Multiplication cannot overflow.
776      */
777     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
778         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
779         // benefit is lost if 'b' is also tested.
780         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
781         if (a == 0) {
782             return 0;
783         }
784 
785         uint256 c = a * b;
786         require(c / a == b, "SafeMath: multiplication overflow");
787 
788         return c;
789     }
790 
791     /**
792      * @dev Returns the integer division of two unsigned integers. Reverts on
793      * division by zero. The result is rounded towards zero.
794      *
795      * Counterpart to Solidity's `/` operator. Note: this function uses a
796      * `revert` opcode (which leaves remaining gas untouched) while Solidity
797      * uses an invalid opcode to revert (consuming all remaining gas).
798      *
799      * Requirements:
800      * - The divisor cannot be zero.
801      */
802     function div(uint256 a, uint256 b) internal pure returns (uint256) {
803         // Solidity only automatically asserts when dividing by 0
804         require(b > 0, "SafeMath: division by zero");
805         uint256 c = a / b;
806         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
807 
808         return c;
809     }
810 
811     /**
812      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
813      * Reverts when dividing by zero.
814      *
815      * Counterpart to Solidity's `%` operator. This function uses a `revert`
816      * opcode (which leaves remaining gas untouched) while Solidity uses an
817      * invalid opcode to revert (consuming all remaining gas).
818      *
819      * Requirements:
820      * - The divisor cannot be zero.
821      */
822     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
823         require(b != 0, "SafeMath: modulo by zero");
824         return a % b;
825     }
826 }
827 
828 
829 // Libraries
830 
831 
832 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
833 library SafeDecimalMath {
834     using SafeMath for uint;
835 
836     /* Number of decimal places in the representations. */
837     uint8 public constant decimals = 18;
838     uint8 public constant highPrecisionDecimals = 27;
839 
840     /* The number representing 1.0. */
841     uint public constant UNIT = 10**uint(decimals);
842 
843     /* The number representing 1.0 for higher fidelity numbers. */
844     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
845     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
846 
847     /**
848      * @return Provides an interface to UNIT.
849      */
850     function unit() external pure returns (uint) {
851         return UNIT;
852     }
853 
854     /**
855      * @return Provides an interface to PRECISE_UNIT.
856      */
857     function preciseUnit() external pure returns (uint) {
858         return PRECISE_UNIT;
859     }
860 
861     /**
862      * @return The result of multiplying x and y, interpreting the operands as fixed-point
863      * decimals.
864      *
865      * @dev A unit factor is divided out after the product of x and y is evaluated,
866      * so that product must be less than 2**256. As this is an integer division,
867      * the internal division always rounds down. This helps save on gas. Rounding
868      * is more expensive on gas.
869      */
870     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
871         /* Divide by UNIT to remove the extra factor introduced by the product. */
872         return x.mul(y) / UNIT;
873     }
874 
875     /**
876      * @return The result of safely multiplying x and y, interpreting the operands
877      * as fixed-point decimals of the specified precision unit.
878      *
879      * @dev The operands should be in the form of a the specified unit factor which will be
880      * divided out after the product of x and y is evaluated, so that product must be
881      * less than 2**256.
882      *
883      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
884      * Rounding is useful when you need to retain fidelity for small decimal numbers
885      * (eg. small fractions or percentages).
886      */
887     function _multiplyDecimalRound(
888         uint x,
889         uint y,
890         uint precisionUnit
891     ) private pure returns (uint) {
892         /* Divide by UNIT to remove the extra factor introduced by the product. */
893         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
894 
895         if (quotientTimesTen % 10 >= 5) {
896             quotientTimesTen += 10;
897         }
898 
899         return quotientTimesTen / 10;
900     }
901 
902     /**
903      * @return The result of safely multiplying x and y, interpreting the operands
904      * as fixed-point decimals of a precise unit.
905      *
906      * @dev The operands should be in the precise unit factor which will be
907      * divided out after the product of x and y is evaluated, so that product must be
908      * less than 2**256.
909      *
910      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
911      * Rounding is useful when you need to retain fidelity for small decimal numbers
912      * (eg. small fractions or percentages).
913      */
914     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
915         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
916     }
917 
918     /**
919      * @return The result of safely multiplying x and y, interpreting the operands
920      * as fixed-point decimals of a standard unit.
921      *
922      * @dev The operands should be in the standard unit factor which will be
923      * divided out after the product of x and y is evaluated, so that product must be
924      * less than 2**256.
925      *
926      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
927      * Rounding is useful when you need to retain fidelity for small decimal numbers
928      * (eg. small fractions or percentages).
929      */
930     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
931         return _multiplyDecimalRound(x, y, UNIT);
932     }
933 
934     /**
935      * @return The result of safely dividing x and y. The return value is a high
936      * precision decimal.
937      *
938      * @dev y is divided after the product of x and the standard precision unit
939      * is evaluated, so the product of x and UNIT must be less than 2**256. As
940      * this is an integer division, the result is always rounded down.
941      * This helps save on gas. Rounding is more expensive on gas.
942      */
943     function divideDecimal(uint x, uint y) internal pure returns (uint) {
944         /* Reintroduce the UNIT factor that will be divided out by y. */
945         return x.mul(UNIT).div(y);
946     }
947 
948     /**
949      * @return The result of safely dividing x and y. The return value is as a rounded
950      * decimal in the precision unit specified in the parameter.
951      *
952      * @dev y is divided after the product of x and the specified precision unit
953      * is evaluated, so the product of x and the specified precision unit must
954      * be less than 2**256. The result is rounded to the nearest increment.
955      */
956     function _divideDecimalRound(
957         uint x,
958         uint y,
959         uint precisionUnit
960     ) private pure returns (uint) {
961         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
962 
963         if (resultTimesTen % 10 >= 5) {
964             resultTimesTen += 10;
965         }
966 
967         return resultTimesTen / 10;
968     }
969 
970     /**
971      * @return The result of safely dividing x and y. The return value is as a rounded
972      * standard precision decimal.
973      *
974      * @dev y is divided after the product of x and the standard precision unit
975      * is evaluated, so the product of x and the standard precision unit must
976      * be less than 2**256. The result is rounded to the nearest increment.
977      */
978     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
979         return _divideDecimalRound(x, y, UNIT);
980     }
981 
982     /**
983      * @return The result of safely dividing x and y. The return value is as a rounded
984      * high precision decimal.
985      *
986      * @dev y is divided after the product of x and the high precision unit
987      * is evaluated, so the product of x and the high precision unit must
988      * be less than 2**256. The result is rounded to the nearest increment.
989      */
990     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
991         return _divideDecimalRound(x, y, PRECISE_UNIT);
992     }
993 
994     /**
995      * @dev Convert a standard decimal representation to a high precision one.
996      */
997     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
998         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
999     }
1000 
1001     /**
1002      * @dev Convert a high precision decimal to a standard decimal representation.
1003      */
1004     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
1005         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
1006 
1007         if (quotientTimesTen % 10 >= 5) {
1008             quotientTimesTen += 10;
1009         }
1010 
1011         return quotientTimesTen / 10;
1012     }
1013 }
1014 
1015 
1016 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1017 interface ISystemStatus {
1018     struct Status {
1019         bool canSuspend;
1020         bool canResume;
1021     }
1022 
1023     struct Suspension {
1024         bool suspended;
1025         // reason is an integer code,
1026         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1027         uint248 reason;
1028     }
1029 
1030     // Views
1031     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1032 
1033     function requireSystemActive() external view;
1034 
1035     function requireIssuanceActive() external view;
1036 
1037     function requireExchangeActive() external view;
1038 
1039     function requireSynthActive(bytes32 currencyKey) external view;
1040 
1041     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1042 
1043     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1044 
1045     // Restricted functions
1046     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1047 
1048     function updateAccessControl(
1049         bytes32 section,
1050         address account,
1051         bool canSuspend,
1052         bool canResume
1053     ) external;
1054 }
1055 
1056 
1057 // https://docs.synthetix.io/contracts/source/interfaces/iexchangestate
1058 interface IExchangeState {
1059     // Views
1060     struct ExchangeEntry {
1061         bytes32 src;
1062         uint amount;
1063         bytes32 dest;
1064         uint amountReceived;
1065         uint exchangeFeeRate;
1066         uint timestamp;
1067         uint roundIdForSrc;
1068         uint roundIdForDest;
1069     }
1070 
1071     function getLengthOfEntries(address account, bytes32 currencyKey) external view returns (uint);
1072 
1073     function getEntryAt(
1074         address account,
1075         bytes32 currencyKey,
1076         uint index
1077     )
1078         external
1079         view
1080         returns (
1081             bytes32 src,
1082             uint amount,
1083             bytes32 dest,
1084             uint amountReceived,
1085             uint exchangeFeeRate,
1086             uint timestamp,
1087             uint roundIdForSrc,
1088             uint roundIdForDest
1089         );
1090 
1091     function getMaxTimestamp(address account, bytes32 currencyKey) external view returns (uint);
1092 
1093     // Mutative functions
1094     function appendExchangeEntry(
1095         address account,
1096         bytes32 src,
1097         uint amount,
1098         bytes32 dest,
1099         uint amountReceived,
1100         uint exchangeFeeRate,
1101         uint timestamp,
1102         uint roundIdForSrc,
1103         uint roundIdForDest
1104     ) external;
1105 
1106     function removeEntries(address account, bytes32 currencyKey) external;
1107 }
1108 
1109 
1110 // https://docs.synthetix.io/contracts/source/interfaces/iexchangerates
1111 interface IExchangeRates {
1112     // Structs
1113     struct RateAndUpdatedTime {
1114         uint216 rate;
1115         uint40 time;
1116     }
1117 
1118     struct InversePricing {
1119         uint entryPoint;
1120         uint upperLimit;
1121         uint lowerLimit;
1122         bool frozenAtUpperLimit;
1123         bool frozenAtLowerLimit;
1124     }
1125 
1126     // Views
1127     function aggregators(bytes32 currencyKey) external view returns (address);
1128 
1129     function aggregatorWarningFlags() external view returns (address);
1130 
1131     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1132 
1133     function canFreezeRate(bytes32 currencyKey) external view returns (bool);
1134 
1135     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
1136 
1137     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1138 
1139     function effectiveValue(
1140         bytes32 sourceCurrencyKey,
1141         uint sourceAmount,
1142         bytes32 destinationCurrencyKey
1143     ) external view returns (uint value);
1144 
1145     function effectiveValueAndRates(
1146         bytes32 sourceCurrencyKey,
1147         uint sourceAmount,
1148         bytes32 destinationCurrencyKey
1149     )
1150         external
1151         view
1152         returns (
1153             uint value,
1154             uint sourceRate,
1155             uint destinationRate
1156         );
1157 
1158     function effectiveValueAtRound(
1159         bytes32 sourceCurrencyKey,
1160         uint sourceAmount,
1161         bytes32 destinationCurrencyKey,
1162         uint roundIdForSrc,
1163         uint roundIdForDest
1164     ) external view returns (uint value);
1165 
1166     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1167 
1168     function getLastRoundIdBeforeElapsedSecs(
1169         bytes32 currencyKey,
1170         uint startingRoundId,
1171         uint startingTimestamp,
1172         uint timediff
1173     ) external view returns (uint);
1174 
1175     function inversePricing(bytes32 currencyKey)
1176         external
1177         view
1178         returns (
1179             uint entryPoint,
1180             uint upperLimit,
1181             uint lowerLimit,
1182             bool frozenAtUpperLimit,
1183             bool frozenAtLowerLimit
1184         );
1185 
1186     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1187 
1188     function oracle() external view returns (address);
1189 
1190     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1191 
1192     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1193 
1194     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1195 
1196     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1197 
1198     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1199 
1200     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
1201 
1202     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1203 
1204     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1205 
1206     function rateStalePeriod() external view returns (uint);
1207 
1208     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
1209         external
1210         view
1211         returns (uint[] memory rates, uint[] memory times);
1212 
1213     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1214         external
1215         view
1216         returns (uint[] memory rates, bool anyRateInvalid);
1217 
1218     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1219 
1220     // Mutative functions
1221     function freezeRate(bytes32 currencyKey) external;
1222 }
1223 
1224 
1225 // https://docs.synthetix.io/contracts/source/interfaces/isynthetix
1226 interface ISynthetix {
1227     // Views
1228     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
1229 
1230     function availableCurrencyKeys() external view returns (bytes32[] memory);
1231 
1232     function availableSynthCount() external view returns (uint);
1233 
1234     function availableSynths(uint index) external view returns (ISynth);
1235 
1236     function collateral(address account) external view returns (uint);
1237 
1238     function collateralisationRatio(address issuer) external view returns (uint);
1239 
1240     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
1241 
1242     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
1243 
1244     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
1245 
1246     function remainingIssuableSynths(address issuer)
1247         external
1248         view
1249         returns (
1250             uint maxIssuable,
1251             uint alreadyIssued,
1252             uint totalSystemDebt
1253         );
1254 
1255     function synths(bytes32 currencyKey) external view returns (ISynth);
1256 
1257     function synthsByAddress(address synthAddress) external view returns (bytes32);
1258 
1259     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
1260 
1261     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);
1262 
1263     function transferableSynthetix(address account) external view returns (uint transferable);
1264 
1265     // Mutative Functions
1266     function burnSynths(uint amount) external;
1267 
1268     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
1269 
1270     function burnSynthsToTarget() external;
1271 
1272     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
1273 
1274     function exchange(
1275         bytes32 sourceCurrencyKey,
1276         uint sourceAmount,
1277         bytes32 destinationCurrencyKey
1278     ) external returns (uint amountReceived);
1279 
1280     function exchangeOnBehalf(
1281         address exchangeForAddress,
1282         bytes32 sourceCurrencyKey,
1283         uint sourceAmount,
1284         bytes32 destinationCurrencyKey
1285     ) external returns (uint amountReceived);
1286 
1287     function exchangeWithTracking(
1288         bytes32 sourceCurrencyKey,
1289         uint sourceAmount,
1290         bytes32 destinationCurrencyKey,
1291         address originator,
1292         bytes32 trackingCode
1293     ) external returns (uint amountReceived);
1294 
1295     function exchangeOnBehalfWithTracking(
1296         address exchangeForAddress,
1297         bytes32 sourceCurrencyKey,
1298         uint sourceAmount,
1299         bytes32 destinationCurrencyKey,
1300         address originator,
1301         bytes32 trackingCode
1302     ) external returns (uint amountReceived);
1303 
1304     function exchangeWithVirtual(
1305         bytes32 sourceCurrencyKey,
1306         uint sourceAmount,
1307         bytes32 destinationCurrencyKey,
1308         bytes32 trackingCode
1309     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1310 
1311     function issueMaxSynths() external;
1312 
1313     function issueMaxSynthsOnBehalf(address issueForAddress) external;
1314 
1315     function issueSynths(uint amount) external;
1316 
1317     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
1318 
1319     function mint() external returns (bool);
1320 
1321     function settle(bytes32 currencyKey)
1322         external
1323         returns (
1324             uint reclaimed,
1325             uint refunded,
1326             uint numEntries
1327         );
1328 
1329     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
1330 
1331     // Restricted Functions
1332 
1333     function mintSecondary(address account, uint amount) external;
1334 
1335     function mintSecondaryRewards(uint amount) external;
1336 
1337     function burnSecondary(address account, uint amount) external;
1338 }
1339 
1340 
1341 // https://docs.synthetix.io/contracts/source/interfaces/ifeepool
1342 interface IFeePool {
1343     // Views
1344 
1345     // solhint-disable-next-line func-name-mixedcase
1346     function FEE_ADDRESS() external view returns (address);
1347 
1348     function feesAvailable(address account) external view returns (uint, uint);
1349 
1350     function feePeriodDuration() external view returns (uint);
1351 
1352     function isFeesClaimable(address account) external view returns (bool);
1353 
1354     function targetThreshold() external view returns (uint);
1355 
1356     function totalFeesAvailable() external view returns (uint);
1357 
1358     function totalRewardsAvailable() external view returns (uint);
1359 
1360     // Mutative Functions
1361     function claimFees() external returns (bool);
1362 
1363     function claimOnBehalf(address claimingForAddress) external returns (bool);
1364 
1365     function closeCurrentFeePeriod() external;
1366 
1367     // Restricted: used internally to Synthetix
1368     function appendAccountIssuanceRecord(
1369         address account,
1370         uint lockedAmount,
1371         uint debtEntryIndex
1372     ) external;
1373 
1374     function recordFeePaid(uint sUSDAmount) external;
1375 
1376     function setRewardsToDistribute(uint amount) external;
1377 }
1378 
1379 
1380 // https://docs.synthetix.io/contracts/source/interfaces/idelegateapprovals
1381 interface IDelegateApprovals {
1382     // Views
1383     function canBurnFor(address authoriser, address delegate) external view returns (bool);
1384 
1385     function canIssueFor(address authoriser, address delegate) external view returns (bool);
1386 
1387     function canClaimFor(address authoriser, address delegate) external view returns (bool);
1388 
1389     function canExchangeFor(address authoriser, address delegate) external view returns (bool);
1390 
1391     // Mutative
1392     function approveAllDelegatePowers(address delegate) external;
1393 
1394     function removeAllDelegatePowers(address delegate) external;
1395 
1396     function approveBurnOnBehalf(address delegate) external;
1397 
1398     function removeBurnOnBehalf(address delegate) external;
1399 
1400     function approveIssueOnBehalf(address delegate) external;
1401 
1402     function removeIssueOnBehalf(address delegate) external;
1403 
1404     function approveClaimOnBehalf(address delegate) external;
1405 
1406     function removeClaimOnBehalf(address delegate) external;
1407 
1408     function approveExchangeOnBehalf(address delegate) external;
1409 
1410     function removeExchangeOnBehalf(address delegate) external;
1411 }
1412 
1413 
1414 // https://docs.synthetix.io/contracts/source/interfaces/itradingrewards
1415 interface ITradingRewards {
1416     /* ========== VIEWS ========== */
1417 
1418     function getAvailableRewards() external view returns (uint);
1419 
1420     function getUnassignedRewards() external view returns (uint);
1421 
1422     function getRewardsToken() external view returns (address);
1423 
1424     function getPeriodController() external view returns (address);
1425 
1426     function getCurrentPeriod() external view returns (uint);
1427 
1428     function getPeriodIsClaimable(uint periodID) external view returns (bool);
1429 
1430     function getPeriodIsFinalized(uint periodID) external view returns (bool);
1431 
1432     function getPeriodRecordedFees(uint periodID) external view returns (uint);
1433 
1434     function getPeriodTotalRewards(uint periodID) external view returns (uint);
1435 
1436     function getPeriodAvailableRewards(uint periodID) external view returns (uint);
1437 
1438     function getUnaccountedFeesForAccountForPeriod(address account, uint periodID) external view returns (uint);
1439 
1440     function getAvailableRewardsForAccountForPeriod(address account, uint periodID) external view returns (uint);
1441 
1442     function getAvailableRewardsForAccountForPeriods(address account, uint[] calldata periodIDs)
1443         external
1444         view
1445         returns (uint totalRewards);
1446 
1447     /* ========== MUTATIVE FUNCTIONS ========== */
1448 
1449     function claimRewardsForPeriod(uint periodID) external;
1450 
1451     function claimRewardsForPeriods(uint[] calldata periodIDs) external;
1452 
1453     /* ========== RESTRICTED FUNCTIONS ========== */
1454 
1455     function recordExchangeFeeForAccount(uint usdFeeAmount, address account) external;
1456 
1457     function closeCurrentPeriodWithRewards(uint rewards) external;
1458 
1459     function recoverTokens(address tokenAddress, address recoverAddress) external;
1460 
1461     function recoverUnassignedRewardTokens(address recoverAddress) external;
1462 
1463     function recoverAssignedRewardTokensAndDestroyPeriod(address recoverAddress, uint periodID) external;
1464 
1465     function setPeriodController(address newPeriodController) external;
1466 }
1467 
1468 
1469 // https://docs.synthetix.io/contracts/source/interfaces/idebtcache
1470 interface IDebtCache {
1471     // Views
1472 
1473     function cachedDebt() external view returns (uint);
1474 
1475     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint);
1476 
1477     function cacheTimestamp() external view returns (uint);
1478 
1479     function cacheInvalid() external view returns (bool);
1480 
1481     function cacheStale() external view returns (bool);
1482 
1483     function currentSynthDebts(bytes32[] calldata currencyKeys)
1484         external
1485         view
1486         returns (uint[] memory debtValues, bool anyRateIsInvalid);
1487 
1488     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory debtValues);
1489 
1490     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid);
1491 
1492     function cacheInfo()
1493         external
1494         view
1495         returns (
1496             uint debt,
1497             uint timestamp,
1498             bool isInvalid,
1499             bool isStale
1500         );
1501 
1502     // Mutative functions
1503 
1504     function takeDebtSnapshot() external;
1505 
1506     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external;
1507 }
1508 
1509 
1510 // Inheritance
1511 
1512 
1513 // Internal references
1514 
1515 
1516 // https://docs.synthetix.io/contracts/source/contracts/proxy
1517 contract Proxy is Owned {
1518     Proxyable public target;
1519 
1520     constructor(address _owner) public Owned(_owner) {}
1521 
1522     function setTarget(Proxyable _target) external onlyOwner {
1523         target = _target;
1524         emit TargetUpdated(_target);
1525     }
1526 
1527     function _emit(
1528         bytes calldata callData,
1529         uint numTopics,
1530         bytes32 topic1,
1531         bytes32 topic2,
1532         bytes32 topic3,
1533         bytes32 topic4
1534     ) external onlyTarget {
1535         uint size = callData.length;
1536         bytes memory _callData = callData;
1537 
1538         assembly {
1539             /* The first 32 bytes of callData contain its length (as specified by the abi).
1540              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
1541              * in length. It is also leftpadded to be a multiple of 32 bytes.
1542              * This means moving call_data across 32 bytes guarantees we correctly access
1543              * the data itself. */
1544             switch numTopics
1545                 case 0 {
1546                     log0(add(_callData, 32), size)
1547                 }
1548                 case 1 {
1549                     log1(add(_callData, 32), size, topic1)
1550                 }
1551                 case 2 {
1552                     log2(add(_callData, 32), size, topic1, topic2)
1553                 }
1554                 case 3 {
1555                     log3(add(_callData, 32), size, topic1, topic2, topic3)
1556                 }
1557                 case 4 {
1558                     log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
1559                 }
1560         }
1561     }
1562 
1563     // solhint-disable no-complex-fallback
1564     function() external payable {
1565         // Mutable call setting Proxyable.messageSender as this is using call not delegatecall
1566         target.setMessageSender(msg.sender);
1567 
1568         assembly {
1569             let free_ptr := mload(0x40)
1570             calldatacopy(free_ptr, 0, calldatasize)
1571 
1572             /* We must explicitly forward ether to the underlying contract as well. */
1573             let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
1574             returndatacopy(free_ptr, 0, returndatasize)
1575 
1576             if iszero(result) {
1577                 revert(free_ptr, returndatasize)
1578             }
1579             return(free_ptr, returndatasize)
1580         }
1581     }
1582 
1583     modifier onlyTarget {
1584         require(Proxyable(msg.sender) == target, "Must be proxy target");
1585         _;
1586     }
1587 
1588     event TargetUpdated(Proxyable newTarget);
1589 }
1590 
1591 
1592 // Inheritance
1593 
1594 
1595 // Internal references
1596 
1597 
1598 // https://docs.synthetix.io/contracts/source/contracts/proxyable
1599 contract Proxyable is Owned {
1600     // This contract should be treated like an abstract contract
1601 
1602     /* The proxy this contract exists behind. */
1603     Proxy public proxy;
1604     Proxy public integrationProxy;
1605 
1606     /* The caller of the proxy, passed through to this contract.
1607      * Note that every function using this member must apply the onlyProxy or
1608      * optionalProxy modifiers, otherwise their invocations can use stale values. */
1609     address public messageSender;
1610 
1611     constructor(address payable _proxy) internal {
1612         // This contract is abstract, and thus cannot be instantiated directly
1613         require(owner != address(0), "Owner must be set");
1614 
1615         proxy = Proxy(_proxy);
1616         emit ProxyUpdated(_proxy);
1617     }
1618 
1619     function setProxy(address payable _proxy) external onlyOwner {
1620         proxy = Proxy(_proxy);
1621         emit ProxyUpdated(_proxy);
1622     }
1623 
1624     function setIntegrationProxy(address payable _integrationProxy) external onlyOwner {
1625         integrationProxy = Proxy(_integrationProxy);
1626     }
1627 
1628     function setMessageSender(address sender) external onlyProxy {
1629         messageSender = sender;
1630     }
1631 
1632     modifier onlyProxy {
1633         _onlyProxy();
1634         _;
1635     }
1636 
1637     function _onlyProxy() private view {
1638         require(Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy, "Only the proxy can call");
1639     }
1640 
1641     modifier optionalProxy {
1642         _optionalProxy();
1643         _;
1644     }
1645 
1646     function _optionalProxy() private {
1647         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
1648             messageSender = msg.sender;
1649         }
1650     }
1651 
1652     modifier optionalProxy_onlyOwner {
1653         _optionalProxy_onlyOwner();
1654         _;
1655     }
1656 
1657     // solhint-disable-next-line func-name-mixedcase
1658     function _optionalProxy_onlyOwner() private {
1659         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
1660             messageSender = msg.sender;
1661         }
1662         require(messageSender == owner, "Owner only function");
1663     }
1664 
1665     event ProxyUpdated(address proxyAddress);
1666 }
1667 
1668 
1669 /**
1670  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1671  * the optional functions; to access them see `ERC20Detailed`.
1672  */
1673 interface IERC20 {
1674     /**
1675      * @dev Returns the amount of tokens in existence.
1676      */
1677     function totalSupply() external view returns (uint256);
1678 
1679     /**
1680      * @dev Returns the amount of tokens owned by `account`.
1681      */
1682     function balanceOf(address account) external view returns (uint256);
1683 
1684     /**
1685      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1686      *
1687      * Returns a boolean value indicating whether the operation succeeded.
1688      *
1689      * Emits a `Transfer` event.
1690      */
1691     function transfer(address recipient, uint256 amount) external returns (bool);
1692 
1693     /**
1694      * @dev Returns the remaining number of tokens that `spender` will be
1695      * allowed to spend on behalf of `owner` through `transferFrom`. This is
1696      * zero by default.
1697      *
1698      * This value changes when `approve` or `transferFrom` are called.
1699      */
1700     function allowance(address owner, address spender) external view returns (uint256);
1701 
1702     /**
1703      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1704      *
1705      * Returns a boolean value indicating whether the operation succeeded.
1706      *
1707      * > Beware that changing an allowance with this method brings the risk
1708      * that someone may use both the old and the new allowance by unfortunate
1709      * transaction ordering. One possible solution to mitigate this race
1710      * condition is to first reduce the spender's allowance to 0 and set the
1711      * desired value afterwards:
1712      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1713      *
1714      * Emits an `Approval` event.
1715      */
1716     function approve(address spender, uint256 amount) external returns (bool);
1717 
1718     /**
1719      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1720      * allowance mechanism. `amount` is then deducted from the caller's
1721      * allowance.
1722      *
1723      * Returns a boolean value indicating whether the operation succeeded.
1724      *
1725      * Emits a `Transfer` event.
1726      */
1727     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1728 
1729     /**
1730      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1731      * another (`to`).
1732      *
1733      * Note that `value` may be zero.
1734      */
1735     event Transfer(address indexed from, address indexed to, uint256 value);
1736 
1737     /**
1738      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1739      * a call to `approve`. `value` is the new allowance.
1740      */
1741     event Approval(address indexed owner, address indexed spender, uint256 value);
1742 }
1743 
1744 
1745 // Inheritance
1746 
1747 
1748 // Libraries
1749 
1750 
1751 // Internal references
1752 
1753 
1754 // Note: use OZ's IERC20 here as using ours will complain about conflicting names
1755 // during the build (VirtualSynth has IERC20 from the OZ ERC20 implementation)
1756 
1757 
1758 // Used to have strongly-typed access to internal mutative functions in Synthetix
1759 interface ISynthetixInternal {
1760     function emitExchangeTracking(
1761         bytes32 trackingCode,
1762         bytes32 toCurrencyKey,
1763         uint256 toAmount
1764     ) external;
1765 
1766     function emitSynthExchange(
1767         address account,
1768         bytes32 fromCurrencyKey,
1769         uint fromAmount,
1770         bytes32 toCurrencyKey,
1771         uint toAmount,
1772         address toAddress
1773     ) external;
1774 
1775     function emitExchangeReclaim(
1776         address account,
1777         bytes32 currencyKey,
1778         uint amount
1779     ) external;
1780 
1781     function emitExchangeRebate(
1782         address account,
1783         bytes32 currencyKey,
1784         uint amount
1785     ) external;
1786 }
1787 
1788 
1789 interface IExchangerInternalDebtCache {
1790     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates) external;
1791 
1792     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external;
1793 }
1794 
1795 
1796 // https://docs.synthetix.io/contracts/source/contracts/exchanger
1797 contract Exchanger is Owned, MixinSystemSettings, IExchanger {
1798     using SafeMath for uint;
1799     using SafeDecimalMath for uint;
1800 
1801     struct ExchangeEntrySettlement {
1802         bytes32 src;
1803         uint amount;
1804         bytes32 dest;
1805         uint reclaim;
1806         uint rebate;
1807         uint srcRoundIdAtPeriodEnd;
1808         uint destRoundIdAtPeriodEnd;
1809         uint timestamp;
1810     }
1811 
1812     bytes32 private constant sUSD = "sUSD";
1813 
1814     // SIP-65: Decentralized circuit breaker
1815     uint public constant CIRCUIT_BREAKER_SUSPENSION_REASON = 65;
1816 
1817     mapping(bytes32 => uint) public lastExchangeRate;
1818 
1819     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1820 
1821     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1822     bytes32 private constant CONTRACT_EXCHANGESTATE = "ExchangeState";
1823     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1824     bytes32 private constant CONTRACT_SYNTHETIX = "Synthetix";
1825     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1826     bytes32 private constant CONTRACT_TRADING_REWARDS = "TradingRewards";
1827     bytes32 private constant CONTRACT_DELEGATEAPPROVALS = "DelegateApprovals";
1828     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1829     bytes32 private constant CONTRACT_DEBTCACHE = "DebtCache";
1830 
1831     constructor(address _owner, address _resolver) public Owned(_owner) MixinSystemSettings(_resolver) {}
1832 
1833     /* ========== VIEWS ========== */
1834 
1835     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1836         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1837         bytes32[] memory newAddresses = new bytes32[](9);
1838         newAddresses[0] = CONTRACT_SYSTEMSTATUS;
1839         newAddresses[1] = CONTRACT_EXCHANGESTATE;
1840         newAddresses[2] = CONTRACT_EXRATES;
1841         newAddresses[3] = CONTRACT_SYNTHETIX;
1842         newAddresses[4] = CONTRACT_FEEPOOL;
1843         newAddresses[5] = CONTRACT_TRADING_REWARDS;
1844         newAddresses[6] = CONTRACT_DELEGATEAPPROVALS;
1845         newAddresses[7] = CONTRACT_ISSUER;
1846         newAddresses[8] = CONTRACT_DEBTCACHE;
1847         addresses = combineArrays(existingAddresses, newAddresses);
1848     }
1849 
1850     function systemStatus() internal view returns (ISystemStatus) {
1851         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1852     }
1853 
1854     function exchangeState() internal view returns (IExchangeState) {
1855         return IExchangeState(requireAndGetAddress(CONTRACT_EXCHANGESTATE));
1856     }
1857 
1858     function exchangeRates() internal view returns (IExchangeRates) {
1859         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES));
1860     }
1861 
1862     function synthetix() internal view returns (ISynthetix) {
1863         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX));
1864     }
1865 
1866     function feePool() internal view returns (IFeePool) {
1867         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL));
1868     }
1869 
1870     function tradingRewards() internal view returns (ITradingRewards) {
1871         return ITradingRewards(requireAndGetAddress(CONTRACT_TRADING_REWARDS));
1872     }
1873 
1874     function delegateApprovals() internal view returns (IDelegateApprovals) {
1875         return IDelegateApprovals(requireAndGetAddress(CONTRACT_DELEGATEAPPROVALS));
1876     }
1877 
1878     function issuer() internal view returns (IIssuer) {
1879         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1880     }
1881 
1882     function debtCache() internal view returns (IExchangerInternalDebtCache) {
1883         return IExchangerInternalDebtCache(requireAndGetAddress(CONTRACT_DEBTCACHE));
1884     }
1885 
1886     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) public view returns (uint) {
1887         return secsLeftInWaitingPeriodForExchange(exchangeState().getMaxTimestamp(account, currencyKey));
1888     }
1889 
1890     function waitingPeriodSecs() external view returns (uint) {
1891         return getWaitingPeriodSecs();
1892     }
1893 
1894     function tradingRewardsEnabled() external view returns (bool) {
1895         return getTradingRewardsEnabled();
1896     }
1897 
1898     function priceDeviationThresholdFactor() external view returns (uint) {
1899         return getPriceDeviationThresholdFactor();
1900     }
1901 
1902     function settlementOwing(address account, bytes32 currencyKey)
1903         public
1904         view
1905         returns (
1906             uint reclaimAmount,
1907             uint rebateAmount,
1908             uint numEntries
1909         )
1910     {
1911         (reclaimAmount, rebateAmount, numEntries, ) = _settlementOwing(account, currencyKey);
1912     }
1913 
1914     // Internal function to emit events for each individual rebate and reclaim entry
1915     function _settlementOwing(address account, bytes32 currencyKey)
1916         internal
1917         view
1918         returns (
1919             uint reclaimAmount,
1920             uint rebateAmount,
1921             uint numEntries,
1922             ExchangeEntrySettlement[] memory
1923         )
1924     {
1925         // Need to sum up all reclaim and rebate amounts for the user and the currency key
1926         numEntries = exchangeState().getLengthOfEntries(account, currencyKey);
1927 
1928         // For each unsettled exchange
1929         ExchangeEntrySettlement[] memory settlements = new ExchangeEntrySettlement[](numEntries);
1930         for (uint i = 0; i < numEntries; i++) {
1931             uint reclaim;
1932             uint rebate;
1933             // fetch the entry from storage
1934             IExchangeState.ExchangeEntry memory exchangeEntry = _getExchangeEntry(account, currencyKey, i);
1935 
1936             // determine the last round ids for src and dest pairs when period ended or latest if not over
1937             (uint srcRoundIdAtPeriodEnd, uint destRoundIdAtPeriodEnd) = getRoundIdsAtPeriodEnd(exchangeEntry);
1938 
1939             // given these round ids, determine what effective value they should have received
1940             uint destinationAmount = exchangeRates().effectiveValueAtRound(
1941                 exchangeEntry.src,
1942                 exchangeEntry.amount,
1943                 exchangeEntry.dest,
1944                 srcRoundIdAtPeriodEnd,
1945                 destRoundIdAtPeriodEnd
1946             );
1947 
1948             // and deduct the fee from this amount using the exchangeFeeRate from storage
1949             uint amountShouldHaveReceived = _getAmountReceivedForExchange(destinationAmount, exchangeEntry.exchangeFeeRate);
1950 
1951             // SIP-65 settlements where the amount at end of waiting period is beyond the threshold, then
1952             // settle with no reclaim or rebate
1953             if (!_isDeviationAboveThreshold(exchangeEntry.amountReceived, amountShouldHaveReceived)) {
1954                 if (exchangeEntry.amountReceived > amountShouldHaveReceived) {
1955                     // if they received more than they should have, add to the reclaim tally
1956                     reclaim = exchangeEntry.amountReceived.sub(amountShouldHaveReceived);
1957                     reclaimAmount = reclaimAmount.add(reclaim);
1958                 } else if (amountShouldHaveReceived > exchangeEntry.amountReceived) {
1959                     // if less, add to the rebate tally
1960                     rebate = amountShouldHaveReceived.sub(exchangeEntry.amountReceived);
1961                     rebateAmount = rebateAmount.add(rebate);
1962                 }
1963             }
1964 
1965             settlements[i] = ExchangeEntrySettlement({
1966                 src: exchangeEntry.src,
1967                 amount: exchangeEntry.amount,
1968                 dest: exchangeEntry.dest,
1969                 reclaim: reclaim,
1970                 rebate: rebate,
1971                 srcRoundIdAtPeriodEnd: srcRoundIdAtPeriodEnd,
1972                 destRoundIdAtPeriodEnd: destRoundIdAtPeriodEnd,
1973                 timestamp: exchangeEntry.timestamp
1974             });
1975         }
1976 
1977         return (reclaimAmount, rebateAmount, numEntries, settlements);
1978     }
1979 
1980     function _getExchangeEntry(
1981         address account,
1982         bytes32 currencyKey,
1983         uint index
1984     ) internal view returns (IExchangeState.ExchangeEntry memory) {
1985         (
1986             bytes32 src,
1987             uint amount,
1988             bytes32 dest,
1989             uint amountReceived,
1990             uint exchangeFeeRate,
1991             uint timestamp,
1992             uint roundIdForSrc,
1993             uint roundIdForDest
1994         ) = exchangeState().getEntryAt(account, currencyKey, index);
1995 
1996         return
1997             IExchangeState.ExchangeEntry({
1998                 src: src,
1999                 amount: amount,
2000                 dest: dest,
2001                 amountReceived: amountReceived,
2002                 exchangeFeeRate: exchangeFeeRate,
2003                 timestamp: timestamp,
2004                 roundIdForSrc: roundIdForSrc,
2005                 roundIdForDest: roundIdForDest
2006             });
2007     }
2008 
2009     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool) {
2010         if (maxSecsLeftInWaitingPeriod(account, currencyKey) != 0) {
2011             return true;
2012         }
2013 
2014         (uint reclaimAmount, , , ) = _settlementOwing(account, currencyKey);
2015 
2016         return reclaimAmount > 0;
2017     }
2018 
2019     /* ========== SETTERS ========== */
2020 
2021     function calculateAmountAfterSettlement(
2022         address from,
2023         bytes32 currencyKey,
2024         uint amount,
2025         uint refunded
2026     ) public view returns (uint amountAfterSettlement) {
2027         amountAfterSettlement = amount;
2028 
2029         // balance of a synth will show an amount after settlement
2030         uint balanceOfSourceAfterSettlement = IERC20(address(issuer().synths(currencyKey))).balanceOf(from);
2031 
2032         // when there isn't enough supply (either due to reclamation settlement or because the number is too high)
2033         if (amountAfterSettlement > balanceOfSourceAfterSettlement) {
2034             // then the amount to exchange is reduced to their remaining supply
2035             amountAfterSettlement = balanceOfSourceAfterSettlement;
2036         }
2037 
2038         if (refunded > 0) {
2039             amountAfterSettlement = amountAfterSettlement.add(refunded);
2040         }
2041     }
2042 
2043     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool) {
2044         return _isSynthRateInvalid(currencyKey, exchangeRates().rateForCurrency(currencyKey));
2045     }
2046 
2047     /* ========== MUTATIVE FUNCTIONS ========== */
2048     function exchange(
2049         address from,
2050         bytes32 sourceCurrencyKey,
2051         uint sourceAmount,
2052         bytes32 destinationCurrencyKey,
2053         address destinationAddress
2054     ) external onlySynthetixorSynth returns (uint amountReceived) {
2055         uint fee;
2056         (amountReceived, fee, ) = _exchange(
2057             from,
2058             sourceCurrencyKey,
2059             sourceAmount,
2060             destinationCurrencyKey,
2061             destinationAddress,
2062             false
2063         );
2064 
2065         _processTradingRewards(fee, destinationAddress);
2066     }
2067 
2068     function exchangeOnBehalf(
2069         address exchangeForAddress,
2070         address from,
2071         bytes32 sourceCurrencyKey,
2072         uint sourceAmount,
2073         bytes32 destinationCurrencyKey
2074     ) external onlySynthetixorSynth returns (uint amountReceived) {
2075         require(delegateApprovals().canExchangeFor(exchangeForAddress, from), "Not approved to act on behalf");
2076 
2077         uint fee;
2078         (amountReceived, fee, ) = _exchange(
2079             exchangeForAddress,
2080             sourceCurrencyKey,
2081             sourceAmount,
2082             destinationCurrencyKey,
2083             exchangeForAddress,
2084             false
2085         );
2086 
2087         _processTradingRewards(fee, exchangeForAddress);
2088     }
2089 
2090     function exchangeWithTracking(
2091         address from,
2092         bytes32 sourceCurrencyKey,
2093         uint sourceAmount,
2094         bytes32 destinationCurrencyKey,
2095         address destinationAddress,
2096         address originator,
2097         bytes32 trackingCode
2098     ) external onlySynthetixorSynth returns (uint amountReceived) {
2099         uint fee;
2100         (amountReceived, fee, ) = _exchange(
2101             from,
2102             sourceCurrencyKey,
2103             sourceAmount,
2104             destinationCurrencyKey,
2105             destinationAddress,
2106             false
2107         );
2108 
2109         _processTradingRewards(fee, originator);
2110 
2111         _emitTrackingEvent(trackingCode, destinationCurrencyKey, amountReceived);
2112     }
2113 
2114     function exchangeOnBehalfWithTracking(
2115         address exchangeForAddress,
2116         address from,
2117         bytes32 sourceCurrencyKey,
2118         uint sourceAmount,
2119         bytes32 destinationCurrencyKey,
2120         address originator,
2121         bytes32 trackingCode
2122     ) external onlySynthetixorSynth returns (uint amountReceived) {
2123         require(delegateApprovals().canExchangeFor(exchangeForAddress, from), "Not approved to act on behalf");
2124 
2125         uint fee;
2126         (amountReceived, fee, ) = _exchange(
2127             exchangeForAddress,
2128             sourceCurrencyKey,
2129             sourceAmount,
2130             destinationCurrencyKey,
2131             exchangeForAddress,
2132             false
2133         );
2134 
2135         _processTradingRewards(fee, originator);
2136 
2137         _emitTrackingEvent(trackingCode, destinationCurrencyKey, amountReceived);
2138     }
2139 
2140     function exchangeWithVirtual(
2141         address from,
2142         bytes32 sourceCurrencyKey,
2143         uint sourceAmount,
2144         bytes32 destinationCurrencyKey,
2145         address destinationAddress,
2146         bytes32 trackingCode
2147     ) external onlySynthetixorSynth returns (uint amountReceived, IVirtualSynth vSynth) {
2148         uint fee;
2149         (amountReceived, fee, vSynth) = _exchange(
2150             from,
2151             sourceCurrencyKey,
2152             sourceAmount,
2153             destinationCurrencyKey,
2154             destinationAddress,
2155             true
2156         );
2157 
2158         _processTradingRewards(fee, destinationAddress);
2159 
2160         if (trackingCode != bytes32(0)) {
2161             _emitTrackingEvent(trackingCode, destinationCurrencyKey, amountReceived);
2162         }
2163     }
2164 
2165     function _emitTrackingEvent(
2166         bytes32 trackingCode,
2167         bytes32 toCurrencyKey,
2168         uint256 toAmount
2169     ) internal {
2170         ISynthetixInternal(address(synthetix())).emitExchangeTracking(trackingCode, toCurrencyKey, toAmount);
2171     }
2172 
2173     function _processTradingRewards(uint fee, address originator) internal {
2174         if (fee > 0 && originator != address(0) && getTradingRewardsEnabled()) {
2175             tradingRewards().recordExchangeFeeForAccount(fee, originator);
2176         }
2177     }
2178 
2179     function _suspendIfRateInvalid(bytes32 currencyKey, uint rate) internal returns (bool circuitBroken) {
2180         if (_isSynthRateInvalid(currencyKey, rate)) {
2181             systemStatus().suspendSynth(currencyKey, CIRCUIT_BREAKER_SUSPENSION_REASON);
2182             circuitBroken = true;
2183         } else {
2184             lastExchangeRate[currencyKey] = rate;
2185         }
2186     }
2187 
2188     function _updateSNXIssuedDebtOnExchange(bytes32[2] memory currencyKeys, uint[2] memory currencyRates) internal {
2189         bool includesSUSD = currencyKeys[0] == sUSD || currencyKeys[1] == sUSD;
2190         uint numKeys = includesSUSD ? 2 : 3;
2191 
2192         bytes32[] memory keys = new bytes32[](numKeys);
2193         keys[0] = currencyKeys[0];
2194         keys[1] = currencyKeys[1];
2195 
2196         uint[] memory rates = new uint[](numKeys);
2197         rates[0] = currencyRates[0];
2198         rates[1] = currencyRates[1];
2199 
2200         if (!includesSUSD) {
2201             keys[2] = sUSD; // And we'll also update sUSD to account for any fees if it wasn't one of the exchanged currencies
2202             rates[2] = SafeDecimalMath.unit();
2203         }
2204 
2205         // Note that exchanges can't invalidate the debt cache, since if a rate is invalid,
2206         // the exchange will have failed already.
2207         debtCache().updateCachedSynthDebtsWithRates(keys, rates);
2208     }
2209 
2210     function _settleAndCalcSourceAmountRemaining(
2211         uint sourceAmount,
2212         address from,
2213         bytes32 sourceCurrencyKey
2214     ) internal returns (uint sourceAmountAfterSettlement) {
2215         (, uint refunded, uint numEntriesSettled) = _internalSettle(from, sourceCurrencyKey, false);
2216 
2217         sourceAmountAfterSettlement = sourceAmount;
2218 
2219         // when settlement was required
2220         if (numEntriesSettled > 0) {
2221             // ensure the sourceAmount takes this into account
2222             sourceAmountAfterSettlement = calculateAmountAfterSettlement(from, sourceCurrencyKey, sourceAmount, refunded);
2223         }
2224     }
2225 
2226     function _exchange(
2227         address from,
2228         bytes32 sourceCurrencyKey,
2229         uint sourceAmount,
2230         bytes32 destinationCurrencyKey,
2231         address destinationAddress,
2232         bool virtualSynth
2233     )
2234         internal
2235         returns (
2236             uint amountReceived,
2237             uint fee,
2238             IVirtualSynth vSynth
2239         )
2240     {
2241         _ensureCanExchange(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
2242 
2243         uint sourceAmountAfterSettlement = _settleAndCalcSourceAmountRemaining(sourceAmount, from, sourceCurrencyKey);
2244 
2245         // If, after settlement the user has no balance left (highly unlikely), then return to prevent
2246         // emitting events of 0 and don't revert so as to ensure the settlement queue is emptied
2247         if (sourceAmountAfterSettlement == 0) {
2248             return (0, 0, IVirtualSynth(0));
2249         }
2250 
2251         uint exchangeFeeRate;
2252         uint sourceRate;
2253         uint destinationRate;
2254 
2255         // Note: `fee` is denominated in the destinationCurrencyKey.
2256         (amountReceived, fee, exchangeFeeRate, sourceRate, destinationRate) = _getAmountsForExchangeMinusFees(
2257             sourceAmountAfterSettlement,
2258             sourceCurrencyKey,
2259             destinationCurrencyKey
2260         );
2261 
2262         // SIP-65: Decentralized Circuit Breaker
2263         if (
2264             _suspendIfRateInvalid(sourceCurrencyKey, sourceRate) ||
2265             _suspendIfRateInvalid(destinationCurrencyKey, destinationRate)
2266         ) {
2267             return (0, 0, IVirtualSynth(0));
2268         }
2269 
2270         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
2271         // the subtraction to not overflow, which would happen if their balance is not sufficient.
2272 
2273         vSynth = _convert(
2274             sourceCurrencyKey,
2275             from,
2276             sourceAmountAfterSettlement,
2277             destinationCurrencyKey,
2278             amountReceived,
2279             destinationAddress,
2280             virtualSynth
2281         );
2282 
2283         // When using a virtual synth, it becomes the destinationAddress for event and settlement tracking
2284         if (vSynth != IVirtualSynth(0)) {
2285             destinationAddress = address(vSynth);
2286         }
2287 
2288         // Remit the fee if required
2289         if (fee > 0) {
2290             // Normalize fee to sUSD
2291             // Note: `fee` is being reused to avoid stack too deep errors.
2292             fee = exchangeRates().effectiveValue(destinationCurrencyKey, fee, sUSD);
2293 
2294             // Remit the fee in sUSDs
2295             issuer().synths(sUSD).issue(feePool().FEE_ADDRESS(), fee);
2296 
2297             // Tell the fee pool about this
2298             feePool().recordFeePaid(fee);
2299         }
2300 
2301         // Note: As of this point, `fee` is denominated in sUSD.
2302 
2303         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
2304         // But we will update the debt snapshot in case exchange rates have fluctuated since the last exchange
2305         // in these currencies
2306         _updateSNXIssuedDebtOnExchange([sourceCurrencyKey, destinationCurrencyKey], [sourceRate, destinationRate]);
2307 
2308         // Let the DApps know there was a Synth exchange
2309         ISynthetixInternal(address(synthetix())).emitSynthExchange(
2310             from,
2311             sourceCurrencyKey,
2312             sourceAmountAfterSettlement,
2313             destinationCurrencyKey,
2314             amountReceived,
2315             destinationAddress
2316         );
2317 
2318         // persist the exchange information for the dest key
2319         appendExchange(
2320             destinationAddress,
2321             sourceCurrencyKey,
2322             sourceAmountAfterSettlement,
2323             destinationCurrencyKey,
2324             amountReceived,
2325             exchangeFeeRate
2326         );
2327     }
2328 
2329     function _convert(
2330         bytes32 sourceCurrencyKey,
2331         address from,
2332         uint sourceAmountAfterSettlement,
2333         bytes32 destinationCurrencyKey,
2334         uint amountReceived,
2335         address recipient,
2336         bool virtualSynth
2337     ) internal returns (IVirtualSynth vSynth) {
2338         // Burn the source amount
2339         issuer().synths(sourceCurrencyKey).burn(from, sourceAmountAfterSettlement);
2340 
2341         // Issue their new synths
2342         ISynth dest = issuer().synths(destinationCurrencyKey);
2343 
2344         if (virtualSynth) {
2345             Proxyable synth = Proxyable(address(dest));
2346             vSynth = _createVirtualSynth(IERC20(address(synth.proxy())), recipient, amountReceived, destinationCurrencyKey);
2347             dest.issue(address(vSynth), amountReceived);
2348         } else {
2349             dest.issue(recipient, amountReceived);
2350         }
2351     }
2352 
2353     function _createVirtualSynth(
2354         IERC20,
2355         address,
2356         uint,
2357         bytes32
2358     ) internal returns (IVirtualSynth) {
2359         revert("Cannot be run on this layer");
2360     }
2361 
2362     // Note: this function can intentionally be called by anyone on behalf of anyone else (the caller just pays the gas)
2363     function settle(address from, bytes32 currencyKey)
2364         external
2365         returns (
2366             uint reclaimed,
2367             uint refunded,
2368             uint numEntriesSettled
2369         )
2370     {
2371         systemStatus().requireSynthActive(currencyKey);
2372         return _internalSettle(from, currencyKey, true);
2373     }
2374 
2375     function suspendSynthWithInvalidRate(bytes32 currencyKey) external {
2376         systemStatus().requireSystemActive();
2377         require(issuer().synths(currencyKey) != ISynth(0), "No such synth");
2378         require(_isSynthRateInvalid(currencyKey, exchangeRates().rateForCurrency(currencyKey)), "Synth price is valid");
2379         systemStatus().suspendSynth(currencyKey, CIRCUIT_BREAKER_SUSPENSION_REASON);
2380     }
2381 
2382     // SIP-78
2383     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external onlyExchangeRates {
2384         require(rate > 0, "Rate must be above 0");
2385         lastExchangeRate[currencyKey] = rate;
2386     }
2387 
2388     /* ========== INTERNAL FUNCTIONS ========== */
2389 
2390     function _ensureCanExchange(
2391         bytes32 sourceCurrencyKey,
2392         uint sourceAmount,
2393         bytes32 destinationCurrencyKey
2394     ) internal view {
2395         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
2396         require(sourceAmount > 0, "Zero amount");
2397 
2398         bytes32[] memory synthKeys = new bytes32[](2);
2399         synthKeys[0] = sourceCurrencyKey;
2400         synthKeys[1] = destinationCurrencyKey;
2401         require(!exchangeRates().anyRateIsInvalid(synthKeys), "Src/dest rate invalid or not found");
2402     }
2403 
2404     function _isSynthRateInvalid(bytes32 currencyKey, uint currentRate) internal view returns (bool) {
2405         if (currentRate == 0) {
2406             return true;
2407         }
2408 
2409         uint lastRateFromExchange = lastExchangeRate[currencyKey];
2410 
2411         if (lastRateFromExchange > 0) {
2412             return _isDeviationAboveThreshold(lastRateFromExchange, currentRate);
2413         }
2414 
2415         // if no last exchange for this synth, then we need to look up last 3 rates (+1 for current rate)
2416         (uint[] memory rates, ) = exchangeRates().ratesAndUpdatedTimeForCurrencyLastNRounds(currencyKey, 4);
2417 
2418         // start at index 1 to ignore current rate
2419         for (uint i = 1; i < rates.length; i++) {
2420             // ignore any empty rates in the past (otherwise we will never be able to get validity)
2421             if (rates[i] > 0 && _isDeviationAboveThreshold(rates[i], currentRate)) {
2422                 return true;
2423             }
2424         }
2425 
2426         return false;
2427     }
2428 
2429     function _isDeviationAboveThreshold(uint base, uint comparison) internal view returns (bool) {
2430         if (base == 0 || comparison == 0) {
2431             return true;
2432         }
2433 
2434         uint factor;
2435         if (comparison > base) {
2436             factor = comparison.divideDecimal(base);
2437         } else {
2438             factor = base.divideDecimal(comparison);
2439         }
2440 
2441         return factor >= getPriceDeviationThresholdFactor();
2442     }
2443 
2444     function _internalSettle(
2445         address from,
2446         bytes32 currencyKey,
2447         bool updateCache
2448     )
2449         internal
2450         returns (
2451             uint reclaimed,
2452             uint refunded,
2453             uint numEntriesSettled
2454         )
2455     {
2456         require(maxSecsLeftInWaitingPeriod(from, currencyKey) == 0, "Cannot settle during waiting period");
2457 
2458         (
2459             uint reclaimAmount,
2460             uint rebateAmount,
2461             uint entries,
2462             ExchangeEntrySettlement[] memory settlements
2463         ) = _settlementOwing(from, currencyKey);
2464 
2465         if (reclaimAmount > rebateAmount) {
2466             reclaimed = reclaimAmount.sub(rebateAmount);
2467             reclaim(from, currencyKey, reclaimed);
2468         } else if (rebateAmount > reclaimAmount) {
2469             refunded = rebateAmount.sub(reclaimAmount);
2470             refund(from, currencyKey, refunded);
2471         }
2472 
2473         if (updateCache) {
2474             bytes32[] memory key = new bytes32[](1);
2475             key[0] = currencyKey;
2476             debtCache().updateCachedSynthDebts(key);
2477         }
2478 
2479         // emit settlement event for each settled exchange entry
2480         for (uint i = 0; i < settlements.length; i++) {
2481             emit ExchangeEntrySettled(
2482                 from,
2483                 settlements[i].src,
2484                 settlements[i].amount,
2485                 settlements[i].dest,
2486                 settlements[i].reclaim,
2487                 settlements[i].rebate,
2488                 settlements[i].srcRoundIdAtPeriodEnd,
2489                 settlements[i].destRoundIdAtPeriodEnd,
2490                 settlements[i].timestamp
2491             );
2492         }
2493 
2494         numEntriesSettled = entries;
2495 
2496         // Now remove all entries, even if no reclaim and no rebate
2497         exchangeState().removeEntries(from, currencyKey);
2498     }
2499 
2500     function reclaim(
2501         address from,
2502         bytes32 currencyKey,
2503         uint amount
2504     ) internal {
2505         // burn amount from user
2506         issuer().synths(currencyKey).burn(from, amount);
2507         ISynthetixInternal(address(synthetix())).emitExchangeReclaim(from, currencyKey, amount);
2508     }
2509 
2510     function refund(
2511         address from,
2512         bytes32 currencyKey,
2513         uint amount
2514     ) internal {
2515         // issue amount to user
2516         issuer().synths(currencyKey).issue(from, amount);
2517         ISynthetixInternal(address(synthetix())).emitExchangeRebate(from, currencyKey, amount);
2518     }
2519 
2520     function secsLeftInWaitingPeriodForExchange(uint timestamp) internal view returns (uint) {
2521         uint _waitingPeriodSecs = getWaitingPeriodSecs();
2522         if (timestamp == 0 || now >= timestamp.add(_waitingPeriodSecs)) {
2523             return 0;
2524         }
2525 
2526         return timestamp.add(_waitingPeriodSecs).sub(now);
2527     }
2528 
2529     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
2530         external
2531         view
2532         returns (uint exchangeFeeRate)
2533     {
2534         exchangeFeeRate = _feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
2535     }
2536 
2537     function _feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
2538         internal
2539         view
2540         returns (uint exchangeFeeRate)
2541     {
2542         // Get the exchange fee rate as per destination currencyKey
2543         exchangeFeeRate = getExchangeFeeRate(destinationCurrencyKey);
2544 
2545         if (sourceCurrencyKey == sUSD || destinationCurrencyKey == sUSD) {
2546             return exchangeFeeRate;
2547         }
2548 
2549         // Is this a swing trade? long to short or short to long skipping sUSD.
2550         if (
2551             (sourceCurrencyKey[0] == 0x73 && destinationCurrencyKey[0] == 0x69) ||
2552             (sourceCurrencyKey[0] == 0x69 && destinationCurrencyKey[0] == 0x73)
2553         ) {
2554             // Double the exchange fee
2555             exchangeFeeRate = exchangeFeeRate.mul(2);
2556         }
2557 
2558         return exchangeFeeRate;
2559     }
2560 
2561     function getAmountsForExchange(
2562         uint sourceAmount,
2563         bytes32 sourceCurrencyKey,
2564         bytes32 destinationCurrencyKey
2565     )
2566         external
2567         view
2568         returns (
2569             uint amountReceived,
2570             uint fee,
2571             uint exchangeFeeRate
2572         )
2573     {
2574         (amountReceived, fee, exchangeFeeRate, , ) = _getAmountsForExchangeMinusFees(
2575             sourceAmount,
2576             sourceCurrencyKey,
2577             destinationCurrencyKey
2578         );
2579     }
2580 
2581     function _getAmountsForExchangeMinusFees(
2582         uint sourceAmount,
2583         bytes32 sourceCurrencyKey,
2584         bytes32 destinationCurrencyKey
2585     )
2586         internal
2587         view
2588         returns (
2589             uint amountReceived,
2590             uint fee,
2591             uint exchangeFeeRate,
2592             uint sourceRate,
2593             uint destinationRate
2594         )
2595     {
2596         uint destinationAmount;
2597         (destinationAmount, sourceRate, destinationRate) = exchangeRates().effectiveValueAndRates(
2598             sourceCurrencyKey,
2599             sourceAmount,
2600             destinationCurrencyKey
2601         );
2602         exchangeFeeRate = _feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
2603         amountReceived = _getAmountReceivedForExchange(destinationAmount, exchangeFeeRate);
2604         fee = destinationAmount.sub(amountReceived);
2605     }
2606 
2607     function _getAmountReceivedForExchange(uint destinationAmount, uint exchangeFeeRate)
2608         internal
2609         pure
2610         returns (uint amountReceived)
2611     {
2612         amountReceived = destinationAmount.multiplyDecimal(SafeDecimalMath.unit().sub(exchangeFeeRate));
2613     }
2614 
2615     function appendExchange(
2616         address account,
2617         bytes32 src,
2618         uint amount,
2619         bytes32 dest,
2620         uint amountReceived,
2621         uint exchangeFeeRate
2622     ) internal {
2623         IExchangeRates exRates = exchangeRates();
2624         uint roundIdForSrc = exRates.getCurrentRoundId(src);
2625         uint roundIdForDest = exRates.getCurrentRoundId(dest);
2626         exchangeState().appendExchangeEntry(
2627             account,
2628             src,
2629             amount,
2630             dest,
2631             amountReceived,
2632             exchangeFeeRate,
2633             now,
2634             roundIdForSrc,
2635             roundIdForDest
2636         );
2637 
2638         emit ExchangeEntryAppended(
2639             account,
2640             src,
2641             amount,
2642             dest,
2643             amountReceived,
2644             exchangeFeeRate,
2645             roundIdForSrc,
2646             roundIdForDest
2647         );
2648     }
2649 
2650     function getRoundIdsAtPeriodEnd(IExchangeState.ExchangeEntry memory exchangeEntry)
2651         internal
2652         view
2653         returns (uint srcRoundIdAtPeriodEnd, uint destRoundIdAtPeriodEnd)
2654     {
2655         IExchangeRates exRates = exchangeRates();
2656         uint _waitingPeriodSecs = getWaitingPeriodSecs();
2657 
2658         srcRoundIdAtPeriodEnd = exRates.getLastRoundIdBeforeElapsedSecs(
2659             exchangeEntry.src,
2660             exchangeEntry.roundIdForSrc,
2661             exchangeEntry.timestamp,
2662             _waitingPeriodSecs
2663         );
2664         destRoundIdAtPeriodEnd = exRates.getLastRoundIdBeforeElapsedSecs(
2665             exchangeEntry.dest,
2666             exchangeEntry.roundIdForDest,
2667             exchangeEntry.timestamp,
2668             _waitingPeriodSecs
2669         );
2670     }
2671 
2672     // ========== MODIFIERS ==========
2673 
2674     modifier onlySynthetixorSynth() {
2675         ISynthetix _synthetix = synthetix();
2676         require(
2677             msg.sender == address(_synthetix) || _synthetix.synthsByAddress(msg.sender) != bytes32(0),
2678             "Exchanger: Only synthetix or a synth contract can perform this action"
2679         );
2680         _;
2681     }
2682 
2683     modifier onlyExchangeRates() {
2684         IExchangeRates _exchangeRates = exchangeRates();
2685         require(msg.sender == address(_exchangeRates), "Restricted to ExchangeRates");
2686         _;
2687     }
2688 
2689     // ========== EVENTS ==========
2690     event ExchangeEntryAppended(
2691         address indexed account,
2692         bytes32 src,
2693         uint256 amount,
2694         bytes32 dest,
2695         uint256 amountReceived,
2696         uint256 exchangeFeeRate,
2697         uint256 roundIdForSrc,
2698         uint256 roundIdForDest
2699     );
2700 
2701     event ExchangeEntrySettled(
2702         address indexed from,
2703         bytes32 src,
2704         uint256 amount,
2705         bytes32 dest,
2706         uint256 reclaim,
2707         uint256 rebate,
2708         uint256 srcRoundIdAtPeriodEnd,
2709         uint256 destRoundIdAtPeriodEnd,
2710         uint256 exchangeTimestamp
2711     );
2712 }
2713 
2714 
2715 /**
2716  * @dev Implementation of the `IERC20` interface.
2717  *
2718  * This implementation is agnostic to the way tokens are created. This means
2719  * that a supply mechanism has to be added in a derived contract using `_mint`.
2720  * For a generic mechanism see `ERC20Mintable`.
2721  *
2722  * *For a detailed writeup see our guide [How to implement supply
2723  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
2724  *
2725  * We have followed general OpenZeppelin guidelines: functions revert instead
2726  * of returning `false` on failure. This behavior is nonetheless conventional
2727  * and does not conflict with the expectations of ERC20 applications.
2728  *
2729  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
2730  * This allows applications to reconstruct the allowance for all accounts just
2731  * by listening to said events. Other implementations of the EIP may not emit
2732  * these events, as it isn't required by the specification.
2733  *
2734  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
2735  * functions have been added to mitigate the well-known issues around setting
2736  * allowances. See `IERC20.approve`.
2737  */
2738 contract ERC20 is IERC20 {
2739     using SafeMath for uint256;
2740 
2741     mapping (address => uint256) private _balances;
2742 
2743     mapping (address => mapping (address => uint256)) private _allowances;
2744 
2745     uint256 private _totalSupply;
2746 
2747     /**
2748      * @dev See `IERC20.totalSupply`.
2749      */
2750     function totalSupply() public view returns (uint256) {
2751         return _totalSupply;
2752     }
2753 
2754     /**
2755      * @dev See `IERC20.balanceOf`.
2756      */
2757     function balanceOf(address account) public view returns (uint256) {
2758         return _balances[account];
2759     }
2760 
2761     /**
2762      * @dev See `IERC20.transfer`.
2763      *
2764      * Requirements:
2765      *
2766      * - `recipient` cannot be the zero address.
2767      * - the caller must have a balance of at least `amount`.
2768      */
2769     function transfer(address recipient, uint256 amount) public returns (bool) {
2770         _transfer(msg.sender, recipient, amount);
2771         return true;
2772     }
2773 
2774     /**
2775      * @dev See `IERC20.allowance`.
2776      */
2777     function allowance(address owner, address spender) public view returns (uint256) {
2778         return _allowances[owner][spender];
2779     }
2780 
2781     /**
2782      * @dev See `IERC20.approve`.
2783      *
2784      * Requirements:
2785      *
2786      * - `spender` cannot be the zero address.
2787      */
2788     function approve(address spender, uint256 value) public returns (bool) {
2789         _approve(msg.sender, spender, value);
2790         return true;
2791     }
2792 
2793     /**
2794      * @dev See `IERC20.transferFrom`.
2795      *
2796      * Emits an `Approval` event indicating the updated allowance. This is not
2797      * required by the EIP. See the note at the beginning of `ERC20`;
2798      *
2799      * Requirements:
2800      * - `sender` and `recipient` cannot be the zero address.
2801      * - `sender` must have a balance of at least `value`.
2802      * - the caller must have allowance for `sender`'s tokens of at least
2803      * `amount`.
2804      */
2805     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
2806         _transfer(sender, recipient, amount);
2807         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
2808         return true;
2809     }
2810 
2811     /**
2812      * @dev Atomically increases the allowance granted to `spender` by the caller.
2813      *
2814      * This is an alternative to `approve` that can be used as a mitigation for
2815      * problems described in `IERC20.approve`.
2816      *
2817      * Emits an `Approval` event indicating the updated allowance.
2818      *
2819      * Requirements:
2820      *
2821      * - `spender` cannot be the zero address.
2822      */
2823     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
2824         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
2825         return true;
2826     }
2827 
2828     /**
2829      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2830      *
2831      * This is an alternative to `approve` that can be used as a mitigation for
2832      * problems described in `IERC20.approve`.
2833      *
2834      * Emits an `Approval` event indicating the updated allowance.
2835      *
2836      * Requirements:
2837      *
2838      * - `spender` cannot be the zero address.
2839      * - `spender` must have allowance for the caller of at least
2840      * `subtractedValue`.
2841      */
2842     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
2843         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
2844         return true;
2845     }
2846 
2847     /**
2848      * @dev Moves tokens `amount` from `sender` to `recipient`.
2849      *
2850      * This is internal function is equivalent to `transfer`, and can be used to
2851      * e.g. implement automatic token fees, slashing mechanisms, etc.
2852      *
2853      * Emits a `Transfer` event.
2854      *
2855      * Requirements:
2856      *
2857      * - `sender` cannot be the zero address.
2858      * - `recipient` cannot be the zero address.
2859      * - `sender` must have a balance of at least `amount`.
2860      */
2861     function _transfer(address sender, address recipient, uint256 amount) internal {
2862         require(sender != address(0), "ERC20: transfer from the zero address");
2863         require(recipient != address(0), "ERC20: transfer to the zero address");
2864 
2865         _balances[sender] = _balances[sender].sub(amount);
2866         _balances[recipient] = _balances[recipient].add(amount);
2867         emit Transfer(sender, recipient, amount);
2868     }
2869 
2870     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2871      * the total supply.
2872      *
2873      * Emits a `Transfer` event with `from` set to the zero address.
2874      *
2875      * Requirements
2876      *
2877      * - `to` cannot be the zero address.
2878      */
2879     function _mint(address account, uint256 amount) internal {
2880         require(account != address(0), "ERC20: mint to the zero address");
2881 
2882         _totalSupply = _totalSupply.add(amount);
2883         _balances[account] = _balances[account].add(amount);
2884         emit Transfer(address(0), account, amount);
2885     }
2886 
2887      /**
2888      * @dev Destoys `amount` tokens from `account`, reducing the
2889      * total supply.
2890      *
2891      * Emits a `Transfer` event with `to` set to the zero address.
2892      *
2893      * Requirements
2894      *
2895      * - `account` cannot be the zero address.
2896      * - `account` must have at least `amount` tokens.
2897      */
2898     function _burn(address account, uint256 value) internal {
2899         require(account != address(0), "ERC20: burn from the zero address");
2900 
2901         _totalSupply = _totalSupply.sub(value);
2902         _balances[account] = _balances[account].sub(value);
2903         emit Transfer(account, address(0), value);
2904     }
2905 
2906     /**
2907      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
2908      *
2909      * This is internal function is equivalent to `approve`, and can be used to
2910      * e.g. set automatic allowances for certain subsystems, etc.
2911      *
2912      * Emits an `Approval` event.
2913      *
2914      * Requirements:
2915      *
2916      * - `owner` cannot be the zero address.
2917      * - `spender` cannot be the zero address.
2918      */
2919     function _approve(address owner, address spender, uint256 value) internal {
2920         require(owner != address(0), "ERC20: approve from the zero address");
2921         require(spender != address(0), "ERC20: approve to the zero address");
2922 
2923         _allowances[owner][spender] = value;
2924         emit Approval(owner, spender, value);
2925     }
2926 
2927     /**
2928      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
2929      * from the caller's allowance.
2930      *
2931      * See `_burn` and `_approve`.
2932      */
2933     function _burnFrom(address account, uint256 amount) internal {
2934         _burn(account, amount);
2935         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
2936     }
2937 }
2938 
2939 
2940 // Inheritance
2941 
2942 
2943 // Libraries
2944 
2945 
2946 // Internal references
2947 
2948 
2949 // Note: use OZ's IERC20 here as using ours will complain about conflicting names
2950 // during the build
2951 
2952 
2953 // https://docs.synthetix.io/contracts/source/contracts/virtualsynth
2954 contract VirtualSynth is ERC20, IVirtualSynth {
2955     using SafeMath for uint;
2956     using SafeDecimalMath for uint;
2957 
2958     IERC20 public synth;
2959     IAddressResolver public resolver;
2960 
2961     bool public settled = false;
2962 
2963     uint8 public constant decimals = 18;
2964 
2965     // track initial supply so we can calculate the rate even after all supply is burned
2966     uint public initialSupply;
2967 
2968     // track final settled amount of the synth so we can calculate the rate after settlement
2969     uint public settledAmount;
2970 
2971     bytes32 public currencyKey;
2972 
2973     constructor(
2974         IERC20 _synth,
2975         IAddressResolver _resolver,
2976         address _recipient,
2977         uint _amount,
2978         bytes32 _currencyKey
2979     ) public ERC20() {
2980         synth = _synth;
2981         resolver = _resolver;
2982         currencyKey = _currencyKey;
2983 
2984         // Assumption: the synth will be issued to us within the same transaction,
2985         // and this supply matches that
2986         _mint(_recipient, _amount);
2987 
2988         initialSupply = _amount;
2989     }
2990 
2991     // INTERNALS
2992 
2993     function exchanger() internal view returns (IExchanger) {
2994         return IExchanger(resolver.requireAndGetAddress("Exchanger", "Exchanger contract not found"));
2995     }
2996 
2997     function secsLeft() internal view returns (uint) {
2998         return exchanger().maxSecsLeftInWaitingPeriod(address(this), currencyKey);
2999     }
3000 
3001     function calcRate() internal view returns (uint) {
3002         if (initialSupply == 0) {
3003             return 0;
3004         }
3005 
3006         uint synthBalance;
3007 
3008         if (!settled) {
3009             synthBalance = IERC20(address(synth)).balanceOf(address(this));
3010             (uint reclaim, uint rebate, ) = exchanger().settlementOwing(address(this), currencyKey);
3011 
3012             if (reclaim > 0) {
3013                 synthBalance = synthBalance.sub(reclaim);
3014             } else if (rebate > 0) {
3015                 synthBalance = synthBalance.add(rebate);
3016             }
3017         } else {
3018             synthBalance = settledAmount;
3019         }
3020 
3021         return synthBalance.divideDecimalRound(initialSupply);
3022     }
3023 
3024     function balanceUnderlying(address account) internal view returns (uint) {
3025         uint vBalanceOfAccount = balanceOf(account);
3026 
3027         return vBalanceOfAccount.multiplyDecimalRound(calcRate());
3028     }
3029 
3030     function settleSynth() internal {
3031         if (settled) {
3032             return;
3033         }
3034         settled = true;
3035 
3036         exchanger().settle(address(this), currencyKey);
3037 
3038         settledAmount = IERC20(address(synth)).balanceOf(address(this));
3039 
3040         emit Settled(totalSupply(), settledAmount);
3041     }
3042 
3043     // VIEWS
3044 
3045     function name() external view returns (string memory) {
3046         return string(abi.encodePacked("Virtual Synth ", currencyKey));
3047     }
3048 
3049     function symbol() external view returns (string memory) {
3050         return string(abi.encodePacked("v", currencyKey));
3051     }
3052 
3053     // get the rate of the vSynth to the synth.
3054     function rate() external view returns (uint) {
3055         return calcRate();
3056     }
3057 
3058     // show the balance of the underlying synth that the given address has, given
3059     // their proportion of totalSupply
3060     function balanceOfUnderlying(address account) external view returns (uint) {
3061         return balanceUnderlying(account);
3062     }
3063 
3064     function secsLeftInWaitingPeriod() external view returns (uint) {
3065         return secsLeft();
3066     }
3067 
3068     function readyToSettle() external view returns (bool) {
3069         return secsLeft() == 0;
3070     }
3071 
3072     // PUBLIC FUNCTIONS
3073 
3074     // Perform settlement of the underlying exchange if required,
3075     // then burn the accounts vSynths and transfer them their owed balanceOfUnderlying
3076     function settle(address account) external {
3077         settleSynth();
3078 
3079         IERC20(address(synth)).transfer(account, balanceUnderlying(account));
3080 
3081         _burn(account, balanceOf(account));
3082     }
3083 
3084     event Settled(uint totalSupply, uint amountAfterSettled);
3085 }
3086 
3087 
3088 // Inheritance
3089 
3090 
3091 // Internal references
3092 
3093 
3094 // https://docs.synthetix.io/contracts/source/contracts/exchangerwithvirtualsynth
3095 contract ExchangerWithVirtualSynth is Exchanger {
3096     constructor(address _owner, address _resolver) public Exchanger(_owner, _resolver) {}
3097 
3098     function _createVirtualSynth(
3099         IERC20 synth,
3100         address recipient,
3101         uint amount,
3102         bytes32 currencyKey
3103     ) internal returns (IVirtualSynth vSynth) {
3104         // prevent inverse synths from being allowed due to purgeability
3105         require(currencyKey[0] != 0x69, "Cannot virtualize this synth");
3106 
3107         vSynth = new VirtualSynth(synth, resolver, recipient, amount, currencyKey);
3108         emit VirtualSynthCreated(address(synth), recipient, address(vSynth), currencyKey, amount);
3109     }
3110 
3111     event VirtualSynthCreated(
3112         address indexed synth,
3113         address indexed recipient,
3114         address vSynth,
3115         bytes32 currencyKey,
3116         uint amount
3117     );
3118 }
3119 
3120     