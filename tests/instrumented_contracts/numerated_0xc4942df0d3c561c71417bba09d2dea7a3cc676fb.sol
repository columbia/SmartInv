1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: Exchanger.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/Exchanger.sol
11 * Docs: https://docs.synthetix.io/contracts/Exchanger
12 *
13 * Contract Dependencies: 
14 *	- IAddressResolver
15 *	- IExchanger
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
26 * Copyright (c) 2020 Synthetix
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
48 pragma solidity ^0.5.16;
49 
50 
51 // https://docs.synthetix.io/contracts/Owned
52 contract Owned {
53     address public owner;
54     address public nominatedOwner;
55 
56     constructor(address _owner) public {
57         require(_owner != address(0), "Owner address cannot be 0");
58         owner = _owner;
59         emit OwnerChanged(address(0), _owner);
60     }
61 
62     function nominateNewOwner(address _owner) external onlyOwner {
63         nominatedOwner = _owner;
64         emit OwnerNominated(_owner);
65     }
66 
67     function acceptOwnership() external {
68         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
69         emit OwnerChanged(owner, nominatedOwner);
70         owner = nominatedOwner;
71         nominatedOwner = address(0);
72     }
73 
74     modifier onlyOwner {
75         _onlyOwner();
76         _;
77     }
78 
79     function _onlyOwner() private view {
80         require(msg.sender == owner, "Only the contract owner may perform this action");
81     }
82 
83     event OwnerNominated(address newOwner);
84     event OwnerChanged(address oldOwner, address newOwner);
85 }
86 
87 
88 interface IAddressResolver {
89     function getAddress(bytes32 name) external view returns (address);
90 
91     function getSynth(bytes32 key) external view returns (address);
92 
93     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
94 }
95 
96 
97 interface ISynth {
98     // Views
99     function currencyKey() external view returns (bytes32);
100 
101     function transferableSynths(address account) external view returns (uint);
102 
103     // Mutative functions
104     function transferAndSettle(address to, uint value) external returns (bool);
105 
106     function transferFromAndSettle(
107         address from,
108         address to,
109         uint value
110     ) external returns (bool);
111 
112     // Restricted: used internally to Synthetix
113     function burn(address account, uint amount) external;
114 
115     function issue(address account, uint amount) external;
116 }
117 
118 
119 interface IIssuer {
120     // Views
121     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
122 
123     function availableCurrencyKeys() external view returns (bytes32[] memory);
124 
125     function availableSynthCount() external view returns (uint);
126 
127     function availableSynths(uint index) external view returns (ISynth);
128 
129     function canBurnSynths(address account) external view returns (bool);
130 
131     function collateral(address account) external view returns (uint);
132 
133     function collateralisationRatio(address issuer) external view returns (uint);
134 
135     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
136         external
137         view
138         returns (uint cratio, bool anyRateIsInvalid);
139 
140     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
141 
142     function issuanceRatio() external view returns (uint);
143 
144     function debtSnapshotStaleTime() external view returns (uint);
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
163     function synthsByAddress(address synthAddress) external view returns (bytes32);
164 
165     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
166 
167     function currentSNXIssuedDebtForCurrencies(bytes32[] calldata currencyKeys)
168         external
169         view
170         returns (uint[] memory snxIssuedDebts, bool anyRateIsInvalid);
171 
172     function cachedSNXIssuedDebtForCurrencies(bytes32[] calldata currencyKeys)
173         external
174         view
175         returns (uint[] memory snxIssuedDebts);
176 
177     function currentSNXIssuedDebt() external view returns (uint snxIssuedDebt, bool anyRateIsInvalid);
178 
179     function cachedSNXIssuedDebtInfo()
180         external
181         view
182         returns (
183             uint cachedDebt,
184             uint timestamp,
185             bool isInvalid
186         );
187 
188     function debtCacheIsStale() external view returns (bool);
189 
190     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
191         external
192         view
193         returns (uint transferable, bool anyRateIsInvalid);
194 
195     // Restricted: used internally to Synthetix
196     function issueSynths(address from, uint amount) external;
197 
198     function issueSynthsOnBehalf(
199         address issueFor,
200         address from,
201         uint amount
202     ) external;
203 
204     function issueMaxSynths(address from) external;
205 
206     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
207 
208     function burnSynths(address from, uint amount) external;
209 
210     function burnSynthsOnBehalf(
211         address burnForAddress,
212         address from,
213         uint amount
214     ) external;
215 
216     function burnSynthsToTarget(address from) external;
217 
218     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
219 
220     function liquidateDelinquentAccount(
221         address account,
222         uint susdAmount,
223         address liquidator
224     ) external returns (uint totalRedeemed, uint amountToLiquidate);
225 
226     function cacheSNXIssuedDebt() external;
227 
228     function updateSNXIssuedDebtForCurrencies(bytes32[] calldata currencyKeys) external;
229 }
230 
231 
232 // Inheritance
233 
234 
235 // https://docs.synthetix.io/contracts/AddressResolver
236 contract AddressResolver is Owned, IAddressResolver {
237     mapping(bytes32 => address) public repository;
238 
239     constructor(address _owner) public Owned(_owner) {}
240 
241     /* ========== MUTATIVE FUNCTIONS ========== */
242 
243     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
244         require(names.length == destinations.length, "Input lengths must match");
245 
246         for (uint i = 0; i < names.length; i++) {
247             repository[names[i]] = destinations[i];
248         }
249     }
250 
251     /* ========== VIEWS ========== */
252 
253     function getAddress(bytes32 name) external view returns (address) {
254         return repository[name];
255     }
256 
257     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
258         address _foundAddress = repository[name];
259         require(_foundAddress != address(0), reason);
260         return _foundAddress;
261     }
262 
263     function getSynth(bytes32 key) external view returns (address) {
264         IIssuer issuer = IIssuer(repository["Issuer"]);
265         require(address(issuer) != address(0), "Cannot find Issuer address");
266         return address(issuer.synths(key));
267     }
268 }
269 
270 
271 // Inheritance
272 
273 
274 // Internal references
275 
276 
277 // https://docs.synthetix.io/contracts/MixinResolver
278 contract MixinResolver is Owned {
279     AddressResolver public resolver;
280 
281     mapping(bytes32 => address) private addressCache;
282 
283     bytes32[] public resolverAddressesRequired;
284 
285     uint public constant MAX_ADDRESSES_FROM_RESOLVER = 24;
286 
287     constructor(address _resolver, bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory _addressesToCache) internal {
288         // This contract is abstract, and thus cannot be instantiated directly
289         require(owner != address(0), "Owner must be set");
290 
291         for (uint i = 0; i < _addressesToCache.length; i++) {
292             if (_addressesToCache[i] != bytes32(0)) {
293                 resolverAddressesRequired.push(_addressesToCache[i]);
294             } else {
295                 // End early once an empty item is found - assumes there are no empty slots in
296                 // _addressesToCache
297                 break;
298             }
299         }
300         resolver = AddressResolver(_resolver);
301         // Do not sync the cache as addresses may not be in the resolver yet
302     }
303 
304     /* ========== SETTERS ========== */
305     function setResolverAndSyncCache(AddressResolver _resolver) external onlyOwner {
306         resolver = _resolver;
307 
308         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
309             bytes32 name = resolverAddressesRequired[i];
310             // Note: can only be invoked once the resolver has all the targets needed added
311             addressCache[name] = resolver.requireAndGetAddress(name, "Resolver missing target");
312         }
313     }
314 
315     /* ========== VIEWS ========== */
316 
317     function requireAndGetAddress(bytes32 name, string memory reason) internal view returns (address) {
318         address _foundAddress = addressCache[name];
319         require(_foundAddress != address(0), reason);
320         return _foundAddress;
321     }
322 
323     // Note: this could be made external in a utility contract if addressCache was made public
324     // (used for deployment)
325     function isResolverCached(AddressResolver _resolver) external view returns (bool) {
326         if (resolver != _resolver) {
327             return false;
328         }
329 
330         // otherwise, check everything
331         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
332             bytes32 name = resolverAddressesRequired[i];
333             // false if our cache is invalid or if the resolver doesn't have the required address
334             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
335                 return false;
336             }
337         }
338 
339         return true;
340     }
341 
342     // Note: can be made external into a utility contract (used for deployment)
343     function getResolverAddressesRequired()
344         external
345         view
346         returns (bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory addressesRequired)
347     {
348         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
349             addressesRequired[i] = resolverAddressesRequired[i];
350         }
351     }
352 
353     /* ========== INTERNAL FUNCTIONS ========== */
354     function appendToAddressCache(bytes32 name) internal {
355         resolverAddressesRequired.push(name);
356         require(resolverAddressesRequired.length < MAX_ADDRESSES_FROM_RESOLVER, "Max resolver cache size met");
357         // Because this is designed to be called internally in constructors, we don't
358         // check the address exists already in the resolver
359         addressCache[name] = resolver.getAddress(name);
360     }
361 }
362 
363 
364 interface IFlexibleStorage {
365     // Views
366     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
367 
368     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
369 
370     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
371 
372     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
373 
374     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
375 
376     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
377 
378     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
379 
380     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
381 
382     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
383 
384     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
385 
386     // Mutative functions
387     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
388 
389     function deleteIntValue(bytes32 contractName, bytes32 record) external;
390 
391     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
392 
393     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
394 
395     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
396 
397     function setUIntValue(
398         bytes32 contractName,
399         bytes32 record,
400         uint value
401     ) external;
402 
403     function setUIntValues(
404         bytes32 contractName,
405         bytes32[] calldata records,
406         uint[] calldata values
407     ) external;
408 
409     function setIntValue(
410         bytes32 contractName,
411         bytes32 record,
412         int value
413     ) external;
414 
415     function setIntValues(
416         bytes32 contractName,
417         bytes32[] calldata records,
418         int[] calldata values
419     ) external;
420 
421     function setAddressValue(
422         bytes32 contractName,
423         bytes32 record,
424         address value
425     ) external;
426 
427     function setAddressValues(
428         bytes32 contractName,
429         bytes32[] calldata records,
430         address[] calldata values
431     ) external;
432 
433     function setBoolValue(
434         bytes32 contractName,
435         bytes32 record,
436         bool value
437     ) external;
438 
439     function setBoolValues(
440         bytes32 contractName,
441         bytes32[] calldata records,
442         bool[] calldata values
443     ) external;
444 
445     function setBytes32Value(
446         bytes32 contractName,
447         bytes32 record,
448         bytes32 value
449     ) external;
450 
451     function setBytes32Values(
452         bytes32 contractName,
453         bytes32[] calldata records,
454         bytes32[] calldata values
455     ) external;
456 }
457 
458 
459 // Internal references
460 
461 
462 contract MixinSystemSettings is MixinResolver {
463     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
464 
465     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
466     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
467     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
468     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
469     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
470     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
471     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
472     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
473     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
474     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
475     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
476     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
477     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
478     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
479 
480     bytes32 private constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
481 
482     constructor() internal {
483         appendToAddressCache(CONTRACT_FLEXIBLESTORAGE);
484     }
485 
486     function flexibleStorage() internal view returns (IFlexibleStorage) {
487         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE, "Missing FlexibleStorage address"));
488     }
489 
490     function getTradingRewardsEnabled() internal view returns (bool) {
491         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
492     }
493 
494     function getWaitingPeriodSecs() internal view returns (uint) {
495         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
496     }
497 
498     function getPriceDeviationThresholdFactor() internal view returns (uint) {
499         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
500     }
501 
502     function getIssuanceRatio() internal view returns (uint) {
503         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
504         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
505     }
506 
507     function getFeePeriodDuration() internal view returns (uint) {
508         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
509         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
510     }
511 
512     function getTargetThreshold() internal view returns (uint) {
513         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
514         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
515     }
516 
517     function getLiquidationDelay() internal view returns (uint) {
518         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
519     }
520 
521     function getLiquidationRatio() internal view returns (uint) {
522         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
523     }
524 
525     function getLiquidationPenalty() internal view returns (uint) {
526         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
527     }
528 
529     function getRateStalePeriod() internal view returns (uint) {
530         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
531     }
532 
533     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
534         return
535             flexibleStorage().getUIntValue(
536                 SETTING_CONTRACT_NAME,
537                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
538             );
539     }
540 
541     function getMinimumStakeTime() internal view returns (uint) {
542         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
543     }
544 
545     function getAggregatorWarningFlags() internal view returns (address) {
546         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
547     }
548 
549     function getDebtSnapshotStaleTime() internal view returns (uint) {
550         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
551     }
552 
553 }
554 
555 
556 interface IExchanger {
557     // Views
558     function calculateAmountAfterSettlement(
559         address from,
560         bytes32 currencyKey,
561         uint amount,
562         uint refunded
563     ) external view returns (uint amountAfterSettlement);
564 
565     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
566 
567     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
568 
569     function settlementOwing(address account, bytes32 currencyKey)
570         external
571         view
572         returns (
573             uint reclaimAmount,
574             uint rebateAmount,
575             uint numEntries
576         );
577 
578     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
579 
580     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
581         external
582         view
583         returns (uint exchangeFeeRate);
584 
585     function getAmountsForExchange(
586         uint sourceAmount,
587         bytes32 sourceCurrencyKey,
588         bytes32 destinationCurrencyKey
589     )
590         external
591         view
592         returns (
593             uint amountReceived,
594             uint fee,
595             uint exchangeFeeRate
596         );
597 
598     function priceDeviationThresholdFactor() external view returns (uint);
599 
600     function waitingPeriodSecs() external view returns (uint);
601 
602     // Mutative functions
603     function exchange(
604         address from,
605         bytes32 sourceCurrencyKey,
606         uint sourceAmount,
607         bytes32 destinationCurrencyKey,
608         address destinationAddress
609     ) external returns (uint amountReceived);
610 
611     function exchangeOnBehalf(
612         address exchangeForAddress,
613         address from,
614         bytes32 sourceCurrencyKey,
615         uint sourceAmount,
616         bytes32 destinationCurrencyKey
617     ) external returns (uint amountReceived);
618 
619     function exchangeWithTracking(
620         address from,
621         bytes32 sourceCurrencyKey,
622         uint sourceAmount,
623         bytes32 destinationCurrencyKey,
624         address destinationAddress,
625         address originator,
626         bytes32 trackingCode
627     ) external returns (uint amountReceived);
628 
629     function exchangeOnBehalfWithTracking(
630         address exchangeForAddress,
631         address from,
632         bytes32 sourceCurrencyKey,
633         uint sourceAmount,
634         bytes32 destinationCurrencyKey,
635         address originator,
636         bytes32 trackingCode
637     ) external returns (uint amountReceived);
638 
639     function settle(address from, bytes32 currencyKey)
640         external
641         returns (
642             uint reclaimed,
643             uint refunded,
644             uint numEntries
645         );
646 
647     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external;
648 
649     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
650 }
651 
652 
653 /**
654  * @dev Wrappers over Solidity's arithmetic operations with added overflow
655  * checks.
656  *
657  * Arithmetic operations in Solidity wrap on overflow. This can easily result
658  * in bugs, because programmers usually assume that an overflow raises an
659  * error, which is the standard behavior in high level programming languages.
660  * `SafeMath` restores this intuition by reverting the transaction when an
661  * operation overflows.
662  *
663  * Using this library instead of the unchecked operations eliminates an entire
664  * class of bugs, so it's recommended to use it always.
665  */
666 library SafeMath {
667     /**
668      * @dev Returns the addition of two unsigned integers, reverting on
669      * overflow.
670      *
671      * Counterpart to Solidity's `+` operator.
672      *
673      * Requirements:
674      * - Addition cannot overflow.
675      */
676     function add(uint256 a, uint256 b) internal pure returns (uint256) {
677         uint256 c = a + b;
678         require(c >= a, "SafeMath: addition overflow");
679 
680         return c;
681     }
682 
683     /**
684      * @dev Returns the subtraction of two unsigned integers, reverting on
685      * overflow (when the result is negative).
686      *
687      * Counterpart to Solidity's `-` operator.
688      *
689      * Requirements:
690      * - Subtraction cannot overflow.
691      */
692     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
693         require(b <= a, "SafeMath: subtraction overflow");
694         uint256 c = a - b;
695 
696         return c;
697     }
698 
699     /**
700      * @dev Returns the multiplication of two unsigned integers, reverting on
701      * overflow.
702      *
703      * Counterpart to Solidity's `*` operator.
704      *
705      * Requirements:
706      * - Multiplication cannot overflow.
707      */
708     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
709         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
710         // benefit is lost if 'b' is also tested.
711         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
712         if (a == 0) {
713             return 0;
714         }
715 
716         uint256 c = a * b;
717         require(c / a == b, "SafeMath: multiplication overflow");
718 
719         return c;
720     }
721 
722     /**
723      * @dev Returns the integer division of two unsigned integers. Reverts on
724      * division by zero. The result is rounded towards zero.
725      *
726      * Counterpart to Solidity's `/` operator. Note: this function uses a
727      * `revert` opcode (which leaves remaining gas untouched) while Solidity
728      * uses an invalid opcode to revert (consuming all remaining gas).
729      *
730      * Requirements:
731      * - The divisor cannot be zero.
732      */
733     function div(uint256 a, uint256 b) internal pure returns (uint256) {
734         // Solidity only automatically asserts when dividing by 0
735         require(b > 0, "SafeMath: division by zero");
736         uint256 c = a / b;
737         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
738 
739         return c;
740     }
741 
742     /**
743      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
744      * Reverts when dividing by zero.
745      *
746      * Counterpart to Solidity's `%` operator. This function uses a `revert`
747      * opcode (which leaves remaining gas untouched) while Solidity uses an
748      * invalid opcode to revert (consuming all remaining gas).
749      *
750      * Requirements:
751      * - The divisor cannot be zero.
752      */
753     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
754         require(b != 0, "SafeMath: modulo by zero");
755         return a % b;
756     }
757 }
758 
759 
760 // Libraries
761 
762 
763 // https://docs.synthetix.io/contracts/SafeDecimalMath
764 library SafeDecimalMath {
765     using SafeMath for uint;
766 
767     /* Number of decimal places in the representations. */
768     uint8 public constant decimals = 18;
769     uint8 public constant highPrecisionDecimals = 27;
770 
771     /* The number representing 1.0. */
772     uint public constant UNIT = 10**uint(decimals);
773 
774     /* The number representing 1.0 for higher fidelity numbers. */
775     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
776     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
777 
778     /**
779      * @return Provides an interface to UNIT.
780      */
781     function unit() external pure returns (uint) {
782         return UNIT;
783     }
784 
785     /**
786      * @return Provides an interface to PRECISE_UNIT.
787      */
788     function preciseUnit() external pure returns (uint) {
789         return PRECISE_UNIT;
790     }
791 
792     /**
793      * @return The result of multiplying x and y, interpreting the operands as fixed-point
794      * decimals.
795      *
796      * @dev A unit factor is divided out after the product of x and y is evaluated,
797      * so that product must be less than 2**256. As this is an integer division,
798      * the internal division always rounds down. This helps save on gas. Rounding
799      * is more expensive on gas.
800      */
801     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
802         /* Divide by UNIT to remove the extra factor introduced by the product. */
803         return x.mul(y) / UNIT;
804     }
805 
806     /**
807      * @return The result of safely multiplying x and y, interpreting the operands
808      * as fixed-point decimals of the specified precision unit.
809      *
810      * @dev The operands should be in the form of a the specified unit factor which will be
811      * divided out after the product of x and y is evaluated, so that product must be
812      * less than 2**256.
813      *
814      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
815      * Rounding is useful when you need to retain fidelity for small decimal numbers
816      * (eg. small fractions or percentages).
817      */
818     function _multiplyDecimalRound(
819         uint x,
820         uint y,
821         uint precisionUnit
822     ) private pure returns (uint) {
823         /* Divide by UNIT to remove the extra factor introduced by the product. */
824         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
825 
826         if (quotientTimesTen % 10 >= 5) {
827             quotientTimesTen += 10;
828         }
829 
830         return quotientTimesTen / 10;
831     }
832 
833     /**
834      * @return The result of safely multiplying x and y, interpreting the operands
835      * as fixed-point decimals of a precise unit.
836      *
837      * @dev The operands should be in the precise unit factor which will be
838      * divided out after the product of x and y is evaluated, so that product must be
839      * less than 2**256.
840      *
841      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
842      * Rounding is useful when you need to retain fidelity for small decimal numbers
843      * (eg. small fractions or percentages).
844      */
845     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
846         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
847     }
848 
849     /**
850      * @return The result of safely multiplying x and y, interpreting the operands
851      * as fixed-point decimals of a standard unit.
852      *
853      * @dev The operands should be in the standard unit factor which will be
854      * divided out after the product of x and y is evaluated, so that product must be
855      * less than 2**256.
856      *
857      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
858      * Rounding is useful when you need to retain fidelity for small decimal numbers
859      * (eg. small fractions or percentages).
860      */
861     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
862         return _multiplyDecimalRound(x, y, UNIT);
863     }
864 
865     /**
866      * @return The result of safely dividing x and y. The return value is a high
867      * precision decimal.
868      *
869      * @dev y is divided after the product of x and the standard precision unit
870      * is evaluated, so the product of x and UNIT must be less than 2**256. As
871      * this is an integer division, the result is always rounded down.
872      * This helps save on gas. Rounding is more expensive on gas.
873      */
874     function divideDecimal(uint x, uint y) internal pure returns (uint) {
875         /* Reintroduce the UNIT factor that will be divided out by y. */
876         return x.mul(UNIT).div(y);
877     }
878 
879     /**
880      * @return The result of safely dividing x and y. The return value is as a rounded
881      * decimal in the precision unit specified in the parameter.
882      *
883      * @dev y is divided after the product of x and the specified precision unit
884      * is evaluated, so the product of x and the specified precision unit must
885      * be less than 2**256. The result is rounded to the nearest increment.
886      */
887     function _divideDecimalRound(
888         uint x,
889         uint y,
890         uint precisionUnit
891     ) private pure returns (uint) {
892         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
893 
894         if (resultTimesTen % 10 >= 5) {
895             resultTimesTen += 10;
896         }
897 
898         return resultTimesTen / 10;
899     }
900 
901     /**
902      * @return The result of safely dividing x and y. The return value is as a rounded
903      * standard precision decimal.
904      *
905      * @dev y is divided after the product of x and the standard precision unit
906      * is evaluated, so the product of x and the standard precision unit must
907      * be less than 2**256. The result is rounded to the nearest increment.
908      */
909     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
910         return _divideDecimalRound(x, y, UNIT);
911     }
912 
913     /**
914      * @return The result of safely dividing x and y. The return value is as a rounded
915      * high precision decimal.
916      *
917      * @dev y is divided after the product of x and the high precision unit
918      * is evaluated, so the product of x and the high precision unit must
919      * be less than 2**256. The result is rounded to the nearest increment.
920      */
921     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
922         return _divideDecimalRound(x, y, PRECISE_UNIT);
923     }
924 
925     /**
926      * @dev Convert a standard decimal representation to a high precision one.
927      */
928     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
929         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
930     }
931 
932     /**
933      * @dev Convert a high precision decimal to a standard decimal representation.
934      */
935     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
936         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
937 
938         if (quotientTimesTen % 10 >= 5) {
939             quotientTimesTen += 10;
940         }
941 
942         return quotientTimesTen / 10;
943     }
944 }
945 
946 
947 interface IERC20 {
948     // ERC20 Optional Views
949     function name() external view returns (string memory);
950 
951     function symbol() external view returns (string memory);
952 
953     function decimals() external view returns (uint8);
954 
955     // Views
956     function totalSupply() external view returns (uint);
957 
958     function balanceOf(address owner) external view returns (uint);
959 
960     function allowance(address owner, address spender) external view returns (uint);
961 
962     // Mutative functions
963     function transfer(address to, uint value) external returns (bool);
964 
965     function approve(address spender, uint value) external returns (bool);
966 
967     function transferFrom(
968         address from,
969         address to,
970         uint value
971     ) external returns (bool);
972 
973     // Events
974     event Transfer(address indexed from, address indexed to, uint value);
975 
976     event Approval(address indexed owner, address indexed spender, uint value);
977 }
978 
979 
980 interface ISystemStatus {
981     struct Status {
982         bool canSuspend;
983         bool canResume;
984     }
985 
986     struct Suspension {
987         bool suspended;
988         // reason is an integer code,
989         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
990         uint248 reason;
991     }
992 
993     // Views
994     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
995 
996     function requireSystemActive() external view;
997 
998     function requireIssuanceActive() external view;
999 
1000     function requireExchangeActive() external view;
1001 
1002     function requireSynthActive(bytes32 currencyKey) external view;
1003 
1004     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1005 
1006     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1007 
1008     // Restricted functions
1009     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1010 
1011     function updateAccessControl(
1012         bytes32 section,
1013         address account,
1014         bool canSuspend,
1015         bool canResume
1016     ) external;
1017 }
1018 
1019 
1020 interface IExchangeState {
1021     // Views
1022     struct ExchangeEntry {
1023         bytes32 src;
1024         uint amount;
1025         bytes32 dest;
1026         uint amountReceived;
1027         uint exchangeFeeRate;
1028         uint timestamp;
1029         uint roundIdForSrc;
1030         uint roundIdForDest;
1031     }
1032 
1033     function getLengthOfEntries(address account, bytes32 currencyKey) external view returns (uint);
1034 
1035     function getEntryAt(
1036         address account,
1037         bytes32 currencyKey,
1038         uint index
1039     )
1040         external
1041         view
1042         returns (
1043             bytes32 src,
1044             uint amount,
1045             bytes32 dest,
1046             uint amountReceived,
1047             uint exchangeFeeRate,
1048             uint timestamp,
1049             uint roundIdForSrc,
1050             uint roundIdForDest
1051         );
1052 
1053     function getMaxTimestamp(address account, bytes32 currencyKey) external view returns (uint);
1054 
1055     // Mutative functions
1056     function appendExchangeEntry(
1057         address account,
1058         bytes32 src,
1059         uint amount,
1060         bytes32 dest,
1061         uint amountReceived,
1062         uint exchangeFeeRate,
1063         uint timestamp,
1064         uint roundIdForSrc,
1065         uint roundIdForDest
1066     ) external;
1067 
1068     function removeEntries(address account, bytes32 currencyKey) external;
1069 }
1070 
1071 
1072 // https://docs.synthetix.io/contracts/source/interfaces/IExchangeRates
1073 interface IExchangeRates {
1074     // Structs
1075     struct RateAndUpdatedTime {
1076         uint216 rate;
1077         uint40 time;
1078     }
1079 
1080     struct InversePricing {
1081         uint entryPoint;
1082         uint upperLimit;
1083         uint lowerLimit;
1084         bool frozenAtUpperLimit;
1085         bool frozenAtLowerLimit;
1086     }
1087 
1088     // Views
1089     function aggregators(bytes32 currencyKey) external view returns (address);
1090 
1091     function aggregatorWarningFlags() external view returns (address);
1092 
1093     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1094 
1095     function canFreezeRate(bytes32 currencyKey) external view returns (bool);
1096 
1097     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
1098 
1099     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1100 
1101     function effectiveValue(
1102         bytes32 sourceCurrencyKey,
1103         uint sourceAmount,
1104         bytes32 destinationCurrencyKey
1105     ) external view returns (uint value);
1106 
1107     function effectiveValueAndRates(
1108         bytes32 sourceCurrencyKey,
1109         uint sourceAmount,
1110         bytes32 destinationCurrencyKey
1111     )
1112         external
1113         view
1114         returns (
1115             uint value,
1116             uint sourceRate,
1117             uint destinationRate
1118         );
1119 
1120     function effectiveValueAtRound(
1121         bytes32 sourceCurrencyKey,
1122         uint sourceAmount,
1123         bytes32 destinationCurrencyKey,
1124         uint roundIdForSrc,
1125         uint roundIdForDest
1126     ) external view returns (uint value);
1127 
1128     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1129 
1130     function getLastRoundIdBeforeElapsedSecs(
1131         bytes32 currencyKey,
1132         uint startingRoundId,
1133         uint startingTimestamp,
1134         uint timediff
1135     ) external view returns (uint);
1136 
1137     function inversePricing(bytes32 currencyKey)
1138         external
1139         view
1140         returns (
1141             uint entryPoint,
1142             uint upperLimit,
1143             uint lowerLimit,
1144             bool frozenAtUpperLimit,
1145             bool frozenAtLowerLimit
1146         );
1147 
1148     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1149 
1150     function oracle() external view returns (address);
1151 
1152     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1153 
1154     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1155 
1156     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1157 
1158     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1159 
1160     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1161 
1162     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
1163 
1164     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1165 
1166     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1167 
1168     function rateStalePeriod() external view returns (uint);
1169 
1170     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
1171         external
1172         view
1173         returns (uint[] memory rates, uint[] memory times);
1174 
1175     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1176         external
1177         view
1178         returns (uint[] memory rates, bool anyRateInvalid);
1179 
1180     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1181 
1182     // Mutative functions
1183     function freezeRate(bytes32 currencyKey) external;
1184 }
1185 
1186 
1187 interface ISynthetix {
1188     // Views
1189     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
1190 
1191     function availableCurrencyKeys() external view returns (bytes32[] memory);
1192 
1193     function availableSynthCount() external view returns (uint);
1194 
1195     function availableSynths(uint index) external view returns (ISynth);
1196 
1197     function collateral(address account) external view returns (uint);
1198 
1199     function collateralisationRatio(address issuer) external view returns (uint);
1200 
1201     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
1202 
1203     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
1204 
1205     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
1206 
1207     function remainingIssuableSynths(address issuer)
1208         external
1209         view
1210         returns (
1211             uint maxIssuable,
1212             uint alreadyIssued,
1213             uint totalSystemDebt
1214         );
1215 
1216     function synths(bytes32 currencyKey) external view returns (ISynth);
1217 
1218     function synthsByAddress(address synthAddress) external view returns (bytes32);
1219 
1220     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
1221 
1222     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);
1223 
1224     function transferableSynthetix(address account) external view returns (uint transferable);
1225 
1226     // Mutative Functions
1227     function burnSynths(uint amount) external;
1228 
1229     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
1230 
1231     function burnSynthsToTarget() external;
1232 
1233     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
1234 
1235     function exchange(
1236         bytes32 sourceCurrencyKey,
1237         uint sourceAmount,
1238         bytes32 destinationCurrencyKey
1239     ) external returns (uint amountReceived);
1240 
1241     function exchangeOnBehalf(
1242         address exchangeForAddress,
1243         bytes32 sourceCurrencyKey,
1244         uint sourceAmount,
1245         bytes32 destinationCurrencyKey
1246     ) external returns (uint amountReceived);
1247 
1248     function exchangeWithTracking(
1249         bytes32 sourceCurrencyKey,
1250         uint sourceAmount,
1251         bytes32 destinationCurrencyKey,
1252         address originator,
1253         bytes32 trackingCode
1254     ) external returns (uint amountReceived);
1255 
1256     function exchangeOnBehalfWithTracking(
1257         address exchangeForAddress,
1258         bytes32 sourceCurrencyKey,
1259         uint sourceAmount,
1260         bytes32 destinationCurrencyKey,
1261         address originator,
1262         bytes32 trackingCode
1263     ) external returns (uint amountReceived);
1264 
1265     function issueMaxSynths() external;
1266 
1267     function issueMaxSynthsOnBehalf(address issueForAddress) external;
1268 
1269     function issueSynths(uint amount) external;
1270 
1271     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
1272 
1273     function mint() external returns (bool);
1274 
1275     function settle(bytes32 currencyKey)
1276         external
1277         returns (
1278             uint reclaimed,
1279             uint refunded,
1280             uint numEntries
1281         );
1282 
1283     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
1284 }
1285 
1286 
1287 interface IFeePool {
1288     // Views
1289 
1290     // solhint-disable-next-line func-name-mixedcase
1291     function FEE_ADDRESS() external view returns (address);
1292 
1293     function feesAvailable(address account) external view returns (uint, uint);
1294 
1295     function feePeriodDuration() external view returns (uint);
1296 
1297     function isFeesClaimable(address account) external view returns (bool);
1298 
1299     function targetThreshold() external view returns (uint);
1300 
1301     function totalFeesAvailable() external view returns (uint);
1302 
1303     function totalRewardsAvailable() external view returns (uint);
1304 
1305     // Mutative Functions
1306     function claimFees() external returns (bool);
1307 
1308     function claimOnBehalf(address claimingForAddress) external returns (bool);
1309 
1310     function closeCurrentFeePeriod() external;
1311 
1312     // Restricted: used internally to Synthetix
1313     function appendAccountIssuanceRecord(
1314         address account,
1315         uint lockedAmount,
1316         uint debtEntryIndex
1317     ) external;
1318 
1319     function recordFeePaid(uint sUSDAmount) external;
1320 
1321     function setRewardsToDistribute(uint amount) external;
1322 }
1323 
1324 
1325 interface IDelegateApprovals {
1326     // Views
1327     function canBurnFor(address authoriser, address delegate) external view returns (bool);
1328 
1329     function canIssueFor(address authoriser, address delegate) external view returns (bool);
1330 
1331     function canClaimFor(address authoriser, address delegate) external view returns (bool);
1332 
1333     function canExchangeFor(address authoriser, address delegate) external view returns (bool);
1334 
1335     // Mutative
1336     function approveAllDelegatePowers(address delegate) external;
1337 
1338     function removeAllDelegatePowers(address delegate) external;
1339 
1340     function approveBurnOnBehalf(address delegate) external;
1341 
1342     function removeBurnOnBehalf(address delegate) external;
1343 
1344     function approveIssueOnBehalf(address delegate) external;
1345 
1346     function removeIssueOnBehalf(address delegate) external;
1347 
1348     function approveClaimOnBehalf(address delegate) external;
1349 
1350     function removeClaimOnBehalf(address delegate) external;
1351 
1352     function approveExchangeOnBehalf(address delegate) external;
1353 
1354     function removeExchangeOnBehalf(address delegate) external;
1355 }
1356 
1357 
1358 interface ITradingRewards {
1359     /* ========== VIEWS ========== */
1360 
1361     function getAvailableRewards() external view returns (uint);
1362 
1363     function getUnassignedRewards() external view returns (uint);
1364 
1365     function getRewardsToken() external view returns (address);
1366 
1367     function getPeriodController() external view returns (address);
1368 
1369     function getCurrentPeriod() external view returns (uint);
1370 
1371     function getPeriodIsClaimable(uint periodID) external view returns (bool);
1372 
1373     function getPeriodIsFinalized(uint periodID) external view returns (bool);
1374 
1375     function getPeriodRecordedFees(uint periodID) external view returns (uint);
1376 
1377     function getPeriodTotalRewards(uint periodID) external view returns (uint);
1378 
1379     function getPeriodAvailableRewards(uint periodID) external view returns (uint);
1380 
1381     function getUnaccountedFeesForAccountForPeriod(address account, uint periodID) external view returns (uint);
1382 
1383     function getAvailableRewardsForAccountForPeriod(address account, uint periodID) external view returns (uint);
1384 
1385     function getAvailableRewardsForAccountForPeriods(address account, uint[] calldata periodIDs)
1386         external
1387         view
1388         returns (uint totalRewards);
1389 
1390     /* ========== MUTATIVE FUNCTIONS ========== */
1391 
1392     function claimRewardsForPeriod(uint periodID) external;
1393 
1394     function claimRewardsForPeriods(uint[] calldata periodIDs) external;
1395 
1396     /* ========== RESTRICTED FUNCTIONS ========== */
1397 
1398     function recordExchangeFeeForAccount(uint usdFeeAmount, address account) external;
1399 
1400     function closeCurrentPeriodWithRewards(uint rewards) external;
1401 
1402     function recoverEther(address payable recoverAddress) external;
1403 
1404     function recoverTokens(address tokenAddress, address recoverAddress) external;
1405 
1406     function recoverUnassignedRewardTokens(address recoverAddress) external;
1407 
1408     function recoverAssignedRewardTokensAndDestroyPeriod(address recoverAddress, uint periodID) external;
1409 
1410     function setPeriodController(address newPeriodController) external;
1411 }
1412 
1413 
1414 // Inheritance
1415 
1416 
1417 // Libraries
1418 
1419 
1420 // Internal references
1421 
1422 
1423 // Used to have strongly-typed access to internal mutative functions in Synthetix
1424 interface ISynthetixInternal {
1425     function emitExchangeTracking(
1426         bytes32 trackingCode,
1427         bytes32 toCurrencyKey,
1428         uint256 toAmount
1429     ) external;
1430 
1431     function emitSynthExchange(
1432         address account,
1433         bytes32 fromCurrencyKey,
1434         uint fromAmount,
1435         bytes32 toCurrencyKey,
1436         uint toAmount,
1437         address toAddress
1438     ) external;
1439 
1440     function emitExchangeReclaim(
1441         address account,
1442         bytes32 currencyKey,
1443         uint amount
1444     ) external;
1445 
1446     function emitExchangeRebate(
1447         address account,
1448         bytes32 currencyKey,
1449         uint amount
1450     ) external;
1451 }
1452 
1453 
1454 interface IIssuerInternal {
1455     function updateSNXIssuedDebtOnExchange(bytes32[2] calldata currencyKeys, uint[2] calldata currencyRates) external;
1456 }
1457 
1458 
1459 // https://docs.synthetix.io/contracts/Exchanger
1460 contract Exchanger is Owned, MixinResolver, MixinSystemSettings, IExchanger {
1461     using SafeMath for uint;
1462     using SafeDecimalMath for uint;
1463 
1464     struct ExchangeEntrySettlement {
1465         bytes32 src;
1466         uint amount;
1467         bytes32 dest;
1468         uint reclaim;
1469         uint rebate;
1470         uint srcRoundIdAtPeriodEnd;
1471         uint destRoundIdAtPeriodEnd;
1472         uint timestamp;
1473     }
1474 
1475     bytes32 private constant sUSD = "sUSD";
1476 
1477     // SIP-65: Decentralized circuit breaker
1478     uint public constant CIRCUIT_BREAKER_SUSPENSION_REASON = 65;
1479 
1480     mapping(bytes32 => uint) public lastExchangeRate;
1481 
1482     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1483 
1484     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1485     bytes32 private constant CONTRACT_EXCHANGESTATE = "ExchangeState";
1486     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1487     bytes32 private constant CONTRACT_SYNTHETIX = "Synthetix";
1488     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1489     bytes32 private constant CONTRACT_TRADING_REWARDS = "TradingRewards";
1490     bytes32 private constant CONTRACT_DELEGATEAPPROVALS = "DelegateApprovals";
1491     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1492 
1493     bytes32[24] private addressesToCache = [
1494         CONTRACT_SYSTEMSTATUS,
1495         CONTRACT_EXCHANGESTATE,
1496         CONTRACT_EXRATES,
1497         CONTRACT_SYNTHETIX,
1498         CONTRACT_FEEPOOL,
1499         CONTRACT_TRADING_REWARDS,
1500         CONTRACT_DELEGATEAPPROVALS,
1501         CONTRACT_ISSUER
1502     ];
1503 
1504     constructor(address _owner, address _resolver)
1505         public
1506         Owned(_owner)
1507         MixinResolver(_resolver, addressesToCache)
1508         MixinSystemSettings()
1509     {}
1510 
1511     /* ========== VIEWS ========== */
1512 
1513     function systemStatus() internal view returns (ISystemStatus) {
1514         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS, "Missing SystemStatus address"));
1515     }
1516 
1517     function exchangeState() internal view returns (IExchangeState) {
1518         return IExchangeState(requireAndGetAddress(CONTRACT_EXCHANGESTATE, "Missing ExchangeState address"));
1519     }
1520 
1521     function exchangeRates() internal view returns (IExchangeRates) {
1522         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES, "Missing ExchangeRates address"));
1523     }
1524 
1525     function synthetix() internal view returns (ISynthetix) {
1526         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX, "Missing Synthetix address"));
1527     }
1528 
1529     function feePool() internal view returns (IFeePool) {
1530         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL, "Missing FeePool address"));
1531     }
1532 
1533     function tradingRewards() internal view returns (ITradingRewards) {
1534         return ITradingRewards(requireAndGetAddress(CONTRACT_TRADING_REWARDS, "Missing TradingRewards address"));
1535     }
1536 
1537     function delegateApprovals() internal view returns (IDelegateApprovals) {
1538         return IDelegateApprovals(requireAndGetAddress(CONTRACT_DELEGATEAPPROVALS, "Missing DelegateApprovals address"));
1539     }
1540 
1541     function issuer() internal view returns (IIssuer) {
1542         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER, "Missing Issuer address"));
1543     }
1544 
1545     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) public view returns (uint) {
1546         return secsLeftInWaitingPeriodForExchange(exchangeState().getMaxTimestamp(account, currencyKey));
1547     }
1548 
1549     function waitingPeriodSecs() external view returns (uint) {
1550         return getWaitingPeriodSecs();
1551     }
1552 
1553     function tradingRewardsEnabled() external view returns (bool) {
1554         return getTradingRewardsEnabled();
1555     }
1556 
1557     function priceDeviationThresholdFactor() external view returns (uint) {
1558         return getPriceDeviationThresholdFactor();
1559     }
1560 
1561     function settlementOwing(address account, bytes32 currencyKey)
1562         public
1563         view
1564         returns (
1565             uint reclaimAmount,
1566             uint rebateAmount,
1567             uint numEntries
1568         )
1569     {
1570         (reclaimAmount, rebateAmount, numEntries, ) = _settlementOwing(account, currencyKey);
1571     }
1572 
1573     // Internal function to emit events for each individual rebate and reclaim entry
1574     function _settlementOwing(address account, bytes32 currencyKey)
1575         internal
1576         view
1577         returns (
1578             uint reclaimAmount,
1579             uint rebateAmount,
1580             uint numEntries,
1581             ExchangeEntrySettlement[] memory
1582         )
1583     {
1584         // Need to sum up all reclaim and rebate amounts for the user and the currency key
1585         numEntries = exchangeState().getLengthOfEntries(account, currencyKey);
1586 
1587         // For each unsettled exchange
1588         ExchangeEntrySettlement[] memory settlements = new ExchangeEntrySettlement[](numEntries);
1589         for (uint i = 0; i < numEntries; i++) {
1590             uint reclaim;
1591             uint rebate;
1592             // fetch the entry from storage
1593             IExchangeState.ExchangeEntry memory exchangeEntry = _getExchangeEntry(account, currencyKey, i);
1594 
1595             // determine the last round ids for src and dest pairs when period ended or latest if not over
1596             (uint srcRoundIdAtPeriodEnd, uint destRoundIdAtPeriodEnd) = getRoundIdsAtPeriodEnd(exchangeEntry);
1597 
1598             // given these round ids, determine what effective value they should have received
1599             uint destinationAmount = exchangeRates().effectiveValueAtRound(
1600                 exchangeEntry.src,
1601                 exchangeEntry.amount,
1602                 exchangeEntry.dest,
1603                 srcRoundIdAtPeriodEnd,
1604                 destRoundIdAtPeriodEnd
1605             );
1606 
1607             // and deduct the fee from this amount using the exchangeFeeRate from storage
1608             uint amountShouldHaveReceived = _getAmountReceivedForExchange(destinationAmount, exchangeEntry.exchangeFeeRate);
1609 
1610             // SIP-65 settlements where the amount at end of waiting period is beyond the threshold, then
1611             // settle with no reclaim or rebate
1612             if (!_isDeviationAboveThreshold(exchangeEntry.amountReceived, amountShouldHaveReceived)) {
1613                 if (exchangeEntry.amountReceived > amountShouldHaveReceived) {
1614                     // if they received more than they should have, add to the reclaim tally
1615                     reclaim = exchangeEntry.amountReceived.sub(amountShouldHaveReceived);
1616                     reclaimAmount = reclaimAmount.add(reclaim);
1617                 } else if (amountShouldHaveReceived > exchangeEntry.amountReceived) {
1618                     // if less, add to the rebate tally
1619                     rebate = amountShouldHaveReceived.sub(exchangeEntry.amountReceived);
1620                     rebateAmount = rebateAmount.add(rebate);
1621                 }
1622             }
1623 
1624             settlements[i] = ExchangeEntrySettlement({
1625                 src: exchangeEntry.src,
1626                 amount: exchangeEntry.amount,
1627                 dest: exchangeEntry.dest,
1628                 reclaim: reclaim,
1629                 rebate: rebate,
1630                 srcRoundIdAtPeriodEnd: srcRoundIdAtPeriodEnd,
1631                 destRoundIdAtPeriodEnd: destRoundIdAtPeriodEnd,
1632                 timestamp: exchangeEntry.timestamp
1633             });
1634         }
1635 
1636         return (reclaimAmount, rebateAmount, numEntries, settlements);
1637     }
1638 
1639     function _getExchangeEntry(
1640         address account,
1641         bytes32 currencyKey,
1642         uint index
1643     ) internal view returns (IExchangeState.ExchangeEntry memory) {
1644         (
1645             bytes32 src,
1646             uint amount,
1647             bytes32 dest,
1648             uint amountReceived,
1649             uint exchangeFeeRate,
1650             uint timestamp,
1651             uint roundIdForSrc,
1652             uint roundIdForDest
1653         ) = exchangeState().getEntryAt(account, currencyKey, index);
1654 
1655         return
1656             IExchangeState.ExchangeEntry({
1657                 src: src,
1658                 amount: amount,
1659                 dest: dest,
1660                 amountReceived: amountReceived,
1661                 exchangeFeeRate: exchangeFeeRate,
1662                 timestamp: timestamp,
1663                 roundIdForSrc: roundIdForSrc,
1664                 roundIdForDest: roundIdForDest
1665             });
1666     }
1667 
1668     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool) {
1669         if (maxSecsLeftInWaitingPeriod(account, currencyKey) != 0) {
1670             return true;
1671         }
1672 
1673         (uint reclaimAmount, , , ) = _settlementOwing(account, currencyKey);
1674 
1675         return reclaimAmount > 0;
1676     }
1677 
1678     /* ========== SETTERS ========== */
1679 
1680     function calculateAmountAfterSettlement(
1681         address from,
1682         bytes32 currencyKey,
1683         uint amount,
1684         uint refunded
1685     ) public view returns (uint amountAfterSettlement) {
1686         amountAfterSettlement = amount;
1687 
1688         // balance of a synth will show an amount after settlement
1689         uint balanceOfSourceAfterSettlement = IERC20(address(issuer().synths(currencyKey))).balanceOf(from);
1690 
1691         // when there isn't enough supply (either due to reclamation settlement or because the number is too high)
1692         if (amountAfterSettlement > balanceOfSourceAfterSettlement) {
1693             // then the amount to exchange is reduced to their remaining supply
1694             amountAfterSettlement = balanceOfSourceAfterSettlement;
1695         }
1696 
1697         if (refunded > 0) {
1698             amountAfterSettlement = amountAfterSettlement.add(refunded);
1699         }
1700     }
1701 
1702     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool) {
1703         return _isSynthRateInvalid(currencyKey, exchangeRates().rateForCurrency(currencyKey));
1704     }
1705 
1706     /* ========== MUTATIVE FUNCTIONS ========== */
1707     function exchange(
1708         address from,
1709         bytes32 sourceCurrencyKey,
1710         uint sourceAmount,
1711         bytes32 destinationCurrencyKey,
1712         address destinationAddress
1713     ) external onlySynthetixorSynth returns (uint amountReceived) {
1714         uint fee;
1715         (amountReceived, fee) = _exchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, destinationAddress);
1716 
1717         _processTradingRewards(fee, destinationAddress);
1718     }
1719 
1720     function exchangeOnBehalf(
1721         address exchangeForAddress,
1722         address from,
1723         bytes32 sourceCurrencyKey,
1724         uint sourceAmount,
1725         bytes32 destinationCurrencyKey
1726     ) external onlySynthetixorSynth returns (uint amountReceived) {
1727         require(delegateApprovals().canExchangeFor(exchangeForAddress, from), "Not approved to act on behalf");
1728 
1729         uint fee;
1730         (amountReceived, fee) = _exchange(
1731             exchangeForAddress,
1732             sourceCurrencyKey,
1733             sourceAmount,
1734             destinationCurrencyKey,
1735             exchangeForAddress
1736         );
1737 
1738         _processTradingRewards(fee, exchangeForAddress);
1739     }
1740 
1741     function exchangeWithTracking(
1742         address from,
1743         bytes32 sourceCurrencyKey,
1744         uint sourceAmount,
1745         bytes32 destinationCurrencyKey,
1746         address destinationAddress,
1747         address originator,
1748         bytes32 trackingCode
1749     ) external onlySynthetixorSynth returns (uint amountReceived) {
1750         uint fee;
1751         (amountReceived, fee) = _exchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, destinationAddress);
1752 
1753         _processTradingRewards(fee, originator);
1754 
1755         _emitTrackingEvent(trackingCode, destinationCurrencyKey, amountReceived);
1756     }
1757 
1758     function exchangeOnBehalfWithTracking(
1759         address exchangeForAddress,
1760         address from,
1761         bytes32 sourceCurrencyKey,
1762         uint sourceAmount,
1763         bytes32 destinationCurrencyKey,
1764         address originator,
1765         bytes32 trackingCode
1766     ) external onlySynthetixorSynth returns (uint amountReceived) {
1767         require(delegateApprovals().canExchangeFor(exchangeForAddress, from), "Not approved to act on behalf");
1768 
1769         uint fee;
1770         (amountReceived, fee) = _exchange(
1771             exchangeForAddress,
1772             sourceCurrencyKey,
1773             sourceAmount,
1774             destinationCurrencyKey,
1775             exchangeForAddress
1776         );
1777 
1778         _processTradingRewards(fee, originator);
1779 
1780         _emitTrackingEvent(trackingCode, destinationCurrencyKey, amountReceived);
1781     }
1782 
1783     function _emitTrackingEvent(
1784         bytes32 trackingCode,
1785         bytes32 toCurrencyKey,
1786         uint256 toAmount
1787     ) internal {
1788         ISynthetixInternal(address(synthetix())).emitExchangeTracking(trackingCode, toCurrencyKey, toAmount);
1789     }
1790 
1791     function _processTradingRewards(uint fee, address originator) internal {
1792         if (fee > 0 && originator != address(0) && getTradingRewardsEnabled()) {
1793             tradingRewards().recordExchangeFeeForAccount(fee, originator);
1794         }
1795     }
1796 
1797     function _exchange(
1798         address from,
1799         bytes32 sourceCurrencyKey,
1800         uint sourceAmount,
1801         bytes32 destinationCurrencyKey,
1802         address destinationAddress
1803     ) internal returns (uint amountReceived, uint fee) {
1804         _ensureCanExchange(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
1805 
1806         (, uint refunded, uint numEntriesSettled) = _internalSettle(from, sourceCurrencyKey, false);
1807 
1808         uint sourceAmountAfterSettlement = sourceAmount;
1809 
1810         // when settlement was required
1811         if (numEntriesSettled > 0) {
1812             // ensure the sourceAmount takes this into account
1813             sourceAmountAfterSettlement = calculateAmountAfterSettlement(from, sourceCurrencyKey, sourceAmount, refunded);
1814 
1815             // If, after settlement the user has no balance left (highly unlikely), then return to prevent
1816             // emitting events of 0 and don't revert so as to ensure the settlement queue is emptied
1817             if (sourceAmountAfterSettlement == 0) {
1818                 return (0, 0);
1819             }
1820         }
1821 
1822         uint exchangeFeeRate;
1823         uint sourceRate;
1824         uint destinationRate;
1825 
1826         // Note: `fee` is denominated in the destinationCurrencyKey.
1827         (amountReceived, fee, exchangeFeeRate, sourceRate, destinationRate) = _getAmountsForExchangeMinusFees(
1828             sourceAmountAfterSettlement,
1829             sourceCurrencyKey,
1830             destinationCurrencyKey
1831         );
1832 
1833         // SIP-65: Decentralized Circuit Breaker
1834         if (_isSynthRateInvalid(sourceCurrencyKey, sourceRate)) {
1835             systemStatus().suspendSynth(sourceCurrencyKey, CIRCUIT_BREAKER_SUSPENSION_REASON);
1836             return (0, 0);
1837         } else {
1838             lastExchangeRate[sourceCurrencyKey] = sourceRate;
1839         }
1840 
1841         if (_isSynthRateInvalid(destinationCurrencyKey, destinationRate)) {
1842             systemStatus().suspendSynth(destinationCurrencyKey, CIRCUIT_BREAKER_SUSPENSION_REASON);
1843             return (0, 0);
1844         } else {
1845             lastExchangeRate[destinationCurrencyKey] = destinationRate;
1846         }
1847 
1848         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
1849         // the subtraction to not overflow, which would happen if their balance is not sufficient.
1850 
1851         // Burn the source amount
1852         issuer().synths(sourceCurrencyKey).burn(from, sourceAmountAfterSettlement);
1853 
1854         // Issue their new synths
1855         issuer().synths(destinationCurrencyKey).issue(destinationAddress, amountReceived);
1856 
1857         // Remit the fee if required
1858         if (fee > 0) {
1859             // Normalize fee to sUSD
1860             // Note: `fee` is being reused to avoid stack too deep errors.
1861             fee = exchangeRates().effectiveValue(destinationCurrencyKey, fee, sUSD);
1862 
1863             // Remit the fee in sUSDs
1864             issuer().synths(sUSD).issue(feePool().FEE_ADDRESS(), fee);
1865 
1866             // Tell the fee pool about this
1867             feePool().recordFeePaid(fee);
1868         }
1869 
1870         // Note: As of this point, `fee` is denominated in sUSD.
1871 
1872         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
1873         // But we will update the debt snapshot in case exchange rates have fluctuated since the last exchange
1874         // in these currencies
1875         IIssuerInternal(address(issuer())).updateSNXIssuedDebtOnExchange(
1876             [sourceCurrencyKey, destinationCurrencyKey],
1877             [sourceRate, destinationRate]
1878         );
1879 
1880         // Let the DApps know there was a Synth exchange
1881         ISynthetixInternal(address(synthetix())).emitSynthExchange(
1882             from,
1883             sourceCurrencyKey,
1884             sourceAmountAfterSettlement,
1885             destinationCurrencyKey,
1886             amountReceived,
1887             destinationAddress
1888         );
1889 
1890         // persist the exchange information for the dest key
1891         appendExchange(
1892             destinationAddress,
1893             sourceCurrencyKey,
1894             sourceAmountAfterSettlement,
1895             destinationCurrencyKey,
1896             amountReceived,
1897             exchangeFeeRate
1898         );
1899     }
1900 
1901     // Note: this function can intentionally be called by anyone on behalf of anyone else (the caller just pays the gas)
1902     function settle(address from, bytes32 currencyKey)
1903         external
1904         returns (
1905             uint reclaimed,
1906             uint refunded,
1907             uint numEntriesSettled
1908         )
1909     {
1910         systemStatus().requireSynthActive(currencyKey);
1911         return _internalSettle(from, currencyKey, true);
1912     }
1913 
1914     function suspendSynthWithInvalidRate(bytes32 currencyKey) external {
1915         systemStatus().requireSystemActive();
1916         require(issuer().synths(currencyKey) != ISynth(0), "No such synth");
1917         require(_isSynthRateInvalid(currencyKey, exchangeRates().rateForCurrency(currencyKey)), "Synth price is valid");
1918         systemStatus().suspendSynth(currencyKey, CIRCUIT_BREAKER_SUSPENSION_REASON);
1919     }
1920 
1921     // SIP-78
1922     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external onlyExchangeRates {
1923         require(rate > 0, "Rate must be above 0");
1924         lastExchangeRate[currencyKey] = rate;
1925     }
1926 
1927     /* ========== INTERNAL FUNCTIONS ========== */
1928 
1929     function _ensureCanExchange(
1930         bytes32 sourceCurrencyKey,
1931         uint sourceAmount,
1932         bytes32 destinationCurrencyKey
1933     ) internal view {
1934         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
1935         require(sourceAmount > 0, "Zero amount");
1936 
1937         bytes32[] memory synthKeys = new bytes32[](2);
1938         synthKeys[0] = sourceCurrencyKey;
1939         synthKeys[1] = destinationCurrencyKey;
1940         require(!exchangeRates().anyRateIsInvalid(synthKeys), "Src/dest rate invalid or not found");
1941     }
1942 
1943     function _isSynthRateInvalid(bytes32 currencyKey, uint currentRate) internal view returns (bool) {
1944         if (currentRate == 0) {
1945             return true;
1946         }
1947 
1948         uint lastRateFromExchange = lastExchangeRate[currencyKey];
1949 
1950         if (lastRateFromExchange > 0) {
1951             return _isDeviationAboveThreshold(lastRateFromExchange, currentRate);
1952         }
1953 
1954         // if no last exchange for this synth, then we need to look up last 3 rates (+1 for current rate)
1955         (uint[] memory rates, ) = exchangeRates().ratesAndUpdatedTimeForCurrencyLastNRounds(currencyKey, 4);
1956 
1957         // start at index 1 to ignore current rate
1958         for (uint i = 1; i < rates.length; i++) {
1959             // ignore any empty rates in the past (otherwise we will never be able to get validity)
1960             if (rates[i] > 0 && _isDeviationAboveThreshold(rates[i], currentRate)) {
1961                 return true;
1962             }
1963         }
1964 
1965         return false;
1966     }
1967 
1968     function _isDeviationAboveThreshold(uint base, uint comparison) internal view returns (bool) {
1969         if (base == 0 || comparison == 0) {
1970             return true;
1971         }
1972 
1973         uint factor;
1974         if (comparison > base) {
1975             factor = comparison.divideDecimal(base);
1976         } else {
1977             factor = base.divideDecimal(comparison);
1978         }
1979 
1980         return factor >= getPriceDeviationThresholdFactor();
1981     }
1982 
1983     function _internalSettle(
1984         address from,
1985         bytes32 currencyKey,
1986         bool updateCache
1987     )
1988         internal
1989         returns (
1990             uint reclaimed,
1991             uint refunded,
1992             uint numEntriesSettled
1993         )
1994     {
1995         require(maxSecsLeftInWaitingPeriod(from, currencyKey) == 0, "Cannot settle during waiting period");
1996 
1997         (
1998             uint reclaimAmount,
1999             uint rebateAmount,
2000             uint entries,
2001             ExchangeEntrySettlement[] memory settlements
2002         ) = _settlementOwing(from, currencyKey);
2003 
2004         if (reclaimAmount > rebateAmount) {
2005             reclaimed = reclaimAmount.sub(rebateAmount);
2006             reclaim(from, currencyKey, reclaimed);
2007         } else if (rebateAmount > reclaimAmount) {
2008             refunded = rebateAmount.sub(reclaimAmount);
2009             refund(from, currencyKey, refunded);
2010         }
2011 
2012         if (updateCache) {
2013             bytes32[] memory key = new bytes32[](1);
2014             key[0] = currencyKey;
2015             issuer().updateSNXIssuedDebtForCurrencies(key);
2016         }
2017 
2018         // emit settlement event for each settled exchange entry
2019         for (uint i = 0; i < settlements.length; i++) {
2020             emit ExchangeEntrySettled(
2021                 from,
2022                 settlements[i].src,
2023                 settlements[i].amount,
2024                 settlements[i].dest,
2025                 settlements[i].reclaim,
2026                 settlements[i].rebate,
2027                 settlements[i].srcRoundIdAtPeriodEnd,
2028                 settlements[i].destRoundIdAtPeriodEnd,
2029                 settlements[i].timestamp
2030             );
2031         }
2032 
2033         numEntriesSettled = entries;
2034 
2035         // Now remove all entries, even if no reclaim and no rebate
2036         exchangeState().removeEntries(from, currencyKey);
2037     }
2038 
2039     function reclaim(
2040         address from,
2041         bytes32 currencyKey,
2042         uint amount
2043     ) internal {
2044         // burn amount from user
2045         issuer().synths(currencyKey).burn(from, amount);
2046         ISynthetixInternal(address(synthetix())).emitExchangeReclaim(from, currencyKey, amount);
2047     }
2048 
2049     function refund(
2050         address from,
2051         bytes32 currencyKey,
2052         uint amount
2053     ) internal {
2054         // issue amount to user
2055         issuer().synths(currencyKey).issue(from, amount);
2056         ISynthetixInternal(address(synthetix())).emitExchangeRebate(from, currencyKey, amount);
2057     }
2058 
2059     function secsLeftInWaitingPeriodForExchange(uint timestamp) internal view returns (uint) {
2060         uint _waitingPeriodSecs = getWaitingPeriodSecs();
2061         if (timestamp == 0 || now >= timestamp.add(_waitingPeriodSecs)) {
2062             return 0;
2063         }
2064 
2065         return timestamp.add(_waitingPeriodSecs).sub(now);
2066     }
2067 
2068     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
2069         external
2070         view
2071         returns (uint exchangeFeeRate)
2072     {
2073         exchangeFeeRate = _feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
2074     }
2075 
2076     function _feeRateForExchange(
2077         bytes32, // API for source in case pricing model evolves to include source rate /* sourceCurrencyKey */
2078         bytes32 destinationCurrencyKey
2079     ) internal view returns (uint exchangeFeeRate) {
2080         return getExchangeFeeRate(destinationCurrencyKey);
2081     }
2082 
2083     function getAmountsForExchange(
2084         uint sourceAmount,
2085         bytes32 sourceCurrencyKey,
2086         bytes32 destinationCurrencyKey
2087     )
2088         external
2089         view
2090         returns (
2091             uint amountReceived,
2092             uint fee,
2093             uint exchangeFeeRate
2094         )
2095     {
2096         (amountReceived, fee, exchangeFeeRate, , ) = _getAmountsForExchangeMinusFees(
2097             sourceAmount,
2098             sourceCurrencyKey,
2099             destinationCurrencyKey
2100         );
2101     }
2102 
2103     function _getAmountsForExchangeMinusFees(
2104         uint sourceAmount,
2105         bytes32 sourceCurrencyKey,
2106         bytes32 destinationCurrencyKey
2107     )
2108         internal
2109         view
2110         returns (
2111             uint amountReceived,
2112             uint fee,
2113             uint exchangeFeeRate,
2114             uint sourceRate,
2115             uint destinationRate
2116         )
2117     {
2118         uint destinationAmount;
2119         (destinationAmount, sourceRate, destinationRate) = exchangeRates().effectiveValueAndRates(
2120             sourceCurrencyKey,
2121             sourceAmount,
2122             destinationCurrencyKey
2123         );
2124         exchangeFeeRate = _feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
2125         amountReceived = _getAmountReceivedForExchange(destinationAmount, exchangeFeeRate);
2126         fee = destinationAmount.sub(amountReceived);
2127     }
2128 
2129     function _getAmountReceivedForExchange(uint destinationAmount, uint exchangeFeeRate)
2130         internal
2131         pure
2132         returns (uint amountReceived)
2133     {
2134         amountReceived = destinationAmount.multiplyDecimal(SafeDecimalMath.unit().sub(exchangeFeeRate));
2135     }
2136 
2137     function appendExchange(
2138         address account,
2139         bytes32 src,
2140         uint amount,
2141         bytes32 dest,
2142         uint amountReceived,
2143         uint exchangeFeeRate
2144     ) internal {
2145         IExchangeRates exRates = exchangeRates();
2146         uint roundIdForSrc = exRates.getCurrentRoundId(src);
2147         uint roundIdForDest = exRates.getCurrentRoundId(dest);
2148         exchangeState().appendExchangeEntry(
2149             account,
2150             src,
2151             amount,
2152             dest,
2153             amountReceived,
2154             exchangeFeeRate,
2155             now,
2156             roundIdForSrc,
2157             roundIdForDest
2158         );
2159 
2160         emit ExchangeEntryAppended(
2161             account,
2162             src,
2163             amount,
2164             dest,
2165             amountReceived,
2166             exchangeFeeRate,
2167             roundIdForSrc,
2168             roundIdForDest
2169         );
2170     }
2171 
2172     function getRoundIdsAtPeriodEnd(IExchangeState.ExchangeEntry memory exchangeEntry)
2173         internal
2174         view
2175         returns (uint srcRoundIdAtPeriodEnd, uint destRoundIdAtPeriodEnd)
2176     {
2177         IExchangeRates exRates = exchangeRates();
2178         uint _waitingPeriodSecs = getWaitingPeriodSecs();
2179 
2180         srcRoundIdAtPeriodEnd = exRates.getLastRoundIdBeforeElapsedSecs(
2181             exchangeEntry.src,
2182             exchangeEntry.roundIdForSrc,
2183             exchangeEntry.timestamp,
2184             _waitingPeriodSecs
2185         );
2186         destRoundIdAtPeriodEnd = exRates.getLastRoundIdBeforeElapsedSecs(
2187             exchangeEntry.dest,
2188             exchangeEntry.roundIdForDest,
2189             exchangeEntry.timestamp,
2190             _waitingPeriodSecs
2191         );
2192     }
2193 
2194     // ========== MODIFIERS ==========
2195 
2196     modifier onlySynthetixorSynth() {
2197         ISynthetix _synthetix = synthetix();
2198         require(
2199             msg.sender == address(_synthetix) || _synthetix.synthsByAddress(msg.sender) != bytes32(0),
2200             "Exchanger: Only synthetix or a synth contract can perform this action"
2201         );
2202         _;
2203     }
2204 
2205     modifier onlyExchangeRates() {
2206         IExchangeRates _exchangeRates = exchangeRates();
2207         require(msg.sender == address(_exchangeRates), "Restricted to ExchangeRates");
2208         _;
2209     }
2210 
2211     // ========== EVENTS ==========
2212     event ExchangeEntryAppended(
2213         address indexed account,
2214         bytes32 src,
2215         uint256 amount,
2216         bytes32 dest,
2217         uint256 amountReceived,
2218         uint256 exchangeFeeRate,
2219         uint256 roundIdForSrc,
2220         uint256 roundIdForDest
2221     );
2222 
2223     event ExchangeEntrySettled(
2224         address indexed from,
2225         bytes32 src,
2226         uint256 amount,
2227         bytes32 dest,
2228         uint256 reclaim,
2229         uint256 rebate,
2230         uint256 srcRoundIdAtPeriodEnd,
2231         uint256 destRoundIdAtPeriodEnd,
2232         uint256 exchangeTimestamp
2233     );
2234 }
2235 
2236     