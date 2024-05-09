1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: DebtCache.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/DebtCache.sol
11 * Docs: https://docs.synthetix.io/contracts/DebtCache
12 *
13 * Contract Dependencies: 
14 *	- IAddressResolver
15 *	- IDebtCache
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
51 // https://docs.synthetix.io/contracts/source/contracts/owned
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
88 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
89 interface IAddressResolver {
90     function getAddress(bytes32 name) external view returns (address);
91 
92     function getSynth(bytes32 key) external view returns (address);
93 
94     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
95 }
96 
97 
98 // https://docs.synthetix.io/contracts/source/interfaces/isynth
99 interface ISynth {
100     // Views
101     function currencyKey() external view returns (bytes32);
102 
103     function transferableSynths(address account) external view returns (uint);
104 
105     // Mutative functions
106     function transferAndSettle(address to, uint value) external returns (bool);
107 
108     function transferFromAndSettle(
109         address from,
110         address to,
111         uint value
112     ) external returns (bool);
113 
114     // Restricted: used internally to Synthetix
115     function burn(address account, uint amount) external;
116 
117     function issue(address account, uint amount) external;
118 }
119 
120 
121 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
122 interface IIssuer {
123     // Views
124     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
125 
126     function availableCurrencyKeys() external view returns (bytes32[] memory);
127 
128     function availableSynthCount() external view returns (uint);
129 
130     function availableSynths(uint index) external view returns (ISynth);
131 
132     function canBurnSynths(address account) external view returns (bool);
133 
134     function collateral(address account) external view returns (uint);
135 
136     function collateralisationRatio(address issuer) external view returns (uint);
137 
138     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
139         external
140         view
141         returns (uint cratio, bool anyRateIsInvalid);
142 
143     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
144 
145     function issuanceRatio() external view returns (uint);
146 
147     function lastIssueEvent(address account) external view returns (uint);
148 
149     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
150 
151     function minimumStakeTime() external view returns (uint);
152 
153     function remainingIssuableSynths(address issuer)
154         external
155         view
156         returns (
157             uint maxIssuable,
158             uint alreadyIssued,
159             uint totalSystemDebt
160         );
161 
162     function synths(bytes32 currencyKey) external view returns (ISynth);
163 
164     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
165 
166     function synthsByAddress(address synthAddress) external view returns (bytes32);
167 
168     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
169 
170     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
171         external
172         view
173         returns (uint transferable, bool anyRateIsInvalid);
174 
175     // Restricted: used internally to Synthetix
176     function issueSynths(address from, uint amount) external;
177 
178     function issueSynthsOnBehalf(
179         address issueFor,
180         address from,
181         uint amount
182     ) external;
183 
184     function issueMaxSynths(address from) external;
185 
186     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
187 
188     function burnSynths(address from, uint amount) external;
189 
190     function burnSynthsOnBehalf(
191         address burnForAddress,
192         address from,
193         uint amount
194     ) external;
195 
196     function burnSynthsToTarget(address from) external;
197 
198     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
199 
200     function liquidateDelinquentAccount(
201         address account,
202         uint susdAmount,
203         address liquidator
204     ) external returns (uint totalRedeemed, uint amountToLiquidate);
205 }
206 
207 
208 // Inheritance
209 
210 
211 // Internal references
212 
213 
214 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
215 contract AddressResolver is Owned, IAddressResolver {
216     mapping(bytes32 => address) public repository;
217 
218     constructor(address _owner) public Owned(_owner) {}
219 
220     /* ========== RESTRICTED FUNCTIONS ========== */
221 
222     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
223         require(names.length == destinations.length, "Input lengths must match");
224 
225         for (uint i = 0; i < names.length; i++) {
226             bytes32 name = names[i];
227             address destination = destinations[i];
228             repository[name] = destination;
229             emit AddressImported(name, destination);
230         }
231     }
232 
233     /* ========= PUBLIC FUNCTIONS ========== */
234 
235     function rebuildCaches(MixinResolver[] calldata destinations) external {
236         for (uint i = 0; i < destinations.length; i++) {
237             destinations[i].rebuildCache();
238         }
239     }
240 
241     /* ========== VIEWS ========== */
242 
243     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
244         for (uint i = 0; i < names.length; i++) {
245             if (repository[names[i]] != destinations[i]) {
246                 return false;
247             }
248         }
249         return true;
250     }
251 
252     function getAddress(bytes32 name) external view returns (address) {
253         return repository[name];
254     }
255 
256     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
257         address _foundAddress = repository[name];
258         require(_foundAddress != address(0), reason);
259         return _foundAddress;
260     }
261 
262     function getSynth(bytes32 key) external view returns (address) {
263         IIssuer issuer = IIssuer(repository["Issuer"]);
264         require(address(issuer) != address(0), "Cannot find Issuer address");
265         return address(issuer.synths(key));
266     }
267 
268     /* ========== EVENTS ========== */
269 
270     event AddressImported(bytes32 name, address destination);
271 }
272 
273 
274 // solhint-disable payable-fallback
275 
276 // https://docs.synthetix.io/contracts/source/contracts/readproxy
277 contract ReadProxy is Owned {
278     address public target;
279 
280     constructor(address _owner) public Owned(_owner) {}
281 
282     function setTarget(address _target) external onlyOwner {
283         target = _target;
284         emit TargetUpdated(target);
285     }
286 
287     function() external {
288         // The basics of a proxy read call
289         // Note that msg.sender in the underlying will always be the address of this contract.
290         assembly {
291             calldatacopy(0, 0, calldatasize)
292 
293             // Use of staticcall - this will revert if the underlying function mutates state
294             let result := staticcall(gas, sload(target_slot), 0, calldatasize, 0, 0)
295             returndatacopy(0, 0, returndatasize)
296 
297             if iszero(result) {
298                 revert(0, returndatasize)
299             }
300             return(0, returndatasize)
301         }
302     }
303 
304     event TargetUpdated(address newTarget);
305 }
306 
307 
308 // Inheritance
309 
310 
311 // Internal references
312 
313 
314 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
315 contract MixinResolver {
316     AddressResolver public resolver;
317 
318     mapping(bytes32 => address) private addressCache;
319 
320     constructor(address _resolver) internal {
321         resolver = AddressResolver(_resolver);
322     }
323 
324     /* ========== INTERNAL FUNCTIONS ========== */
325 
326     function combineArrays(bytes32[] memory first, bytes32[] memory second)
327         internal
328         pure
329         returns (bytes32[] memory combination)
330     {
331         combination = new bytes32[](first.length + second.length);
332 
333         for (uint i = 0; i < first.length; i++) {
334             combination[i] = first[i];
335         }
336 
337         for (uint j = 0; j < second.length; j++) {
338             combination[first.length + j] = second[j];
339         }
340     }
341 
342     /* ========== PUBLIC FUNCTIONS ========== */
343 
344     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
345     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
346 
347     function rebuildCache() public {
348         bytes32[] memory requiredAddresses = resolverAddressesRequired();
349         // The resolver must call this function whenver it updates its state
350         for (uint i = 0; i < requiredAddresses.length; i++) {
351             bytes32 name = requiredAddresses[i];
352             // Note: can only be invoked once the resolver has all the targets needed added
353             address destination = resolver.requireAndGetAddress(
354                 name,
355                 string(abi.encodePacked("Resolver missing target: ", name))
356             );
357             addressCache[name] = destination;
358             emit CacheUpdated(name, destination);
359         }
360     }
361 
362     /* ========== VIEWS ========== */
363 
364     function isResolverCached() external view returns (bool) {
365         bytes32[] memory requiredAddresses = resolverAddressesRequired();
366         for (uint i = 0; i < requiredAddresses.length; i++) {
367             bytes32 name = requiredAddresses[i];
368             // false if our cache is invalid or if the resolver doesn't have the required address
369             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
370                 return false;
371             }
372         }
373 
374         return true;
375     }
376 
377     /* ========== INTERNAL FUNCTIONS ========== */
378 
379     function requireAndGetAddress(bytes32 name) internal view returns (address) {
380         address _foundAddress = addressCache[name];
381         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
382         return _foundAddress;
383     }
384 
385     /* ========== EVENTS ========== */
386 
387     event CacheUpdated(bytes32 name, address destination);
388 }
389 
390 
391 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
392 interface IFlexibleStorage {
393     // Views
394     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
395 
396     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
397 
398     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
399 
400     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
401 
402     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
403 
404     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
405 
406     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
407 
408     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
409 
410     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
411 
412     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
413 
414     // Mutative functions
415     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
416 
417     function deleteIntValue(bytes32 contractName, bytes32 record) external;
418 
419     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
420 
421     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
422 
423     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
424 
425     function setUIntValue(
426         bytes32 contractName,
427         bytes32 record,
428         uint value
429     ) external;
430 
431     function setUIntValues(
432         bytes32 contractName,
433         bytes32[] calldata records,
434         uint[] calldata values
435     ) external;
436 
437     function setIntValue(
438         bytes32 contractName,
439         bytes32 record,
440         int value
441     ) external;
442 
443     function setIntValues(
444         bytes32 contractName,
445         bytes32[] calldata records,
446         int[] calldata values
447     ) external;
448 
449     function setAddressValue(
450         bytes32 contractName,
451         bytes32 record,
452         address value
453     ) external;
454 
455     function setAddressValues(
456         bytes32 contractName,
457         bytes32[] calldata records,
458         address[] calldata values
459     ) external;
460 
461     function setBoolValue(
462         bytes32 contractName,
463         bytes32 record,
464         bool value
465     ) external;
466 
467     function setBoolValues(
468         bytes32 contractName,
469         bytes32[] calldata records,
470         bool[] calldata values
471     ) external;
472 
473     function setBytes32Value(
474         bytes32 contractName,
475         bytes32 record,
476         bytes32 value
477     ) external;
478 
479     function setBytes32Values(
480         bytes32 contractName,
481         bytes32[] calldata records,
482         bytes32[] calldata values
483     ) external;
484 }
485 
486 
487 // Internal references
488 
489 
490 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
491 contract MixinSystemSettings is MixinResolver {
492     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
493 
494     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
495     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
496     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
497     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
498     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
499     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
500     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
501     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
502     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
503     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
504     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
505     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
506     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
507     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
508     bytes32 internal constant SETTING_CROSS_DOMAIN_MESSAGE_GAS_LIMIT = "crossDomainMessageGasLimit";
509 
510     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
511 
512     constructor(address _resolver) internal MixinResolver(_resolver) {}
513 
514     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
515         addresses = new bytes32[](1);
516         addresses[0] = CONTRACT_FLEXIBLESTORAGE;
517     }
518 
519     function flexibleStorage() internal view returns (IFlexibleStorage) {
520         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
521     }
522 
523     function getCrossDomainMessageGasLimit() internal view returns (uint) {
524         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_CROSS_DOMAIN_MESSAGE_GAS_LIMIT);
525     }
526 
527     function getTradingRewardsEnabled() internal view returns (bool) {
528         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
529     }
530 
531     function getWaitingPeriodSecs() internal view returns (uint) {
532         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
533     }
534 
535     function getPriceDeviationThresholdFactor() internal view returns (uint) {
536         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
537     }
538 
539     function getIssuanceRatio() internal view returns (uint) {
540         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
541         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
542     }
543 
544     function getFeePeriodDuration() internal view returns (uint) {
545         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
546         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
547     }
548 
549     function getTargetThreshold() internal view returns (uint) {
550         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
551         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
552     }
553 
554     function getLiquidationDelay() internal view returns (uint) {
555         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
556     }
557 
558     function getLiquidationRatio() internal view returns (uint) {
559         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
560     }
561 
562     function getLiquidationPenalty() internal view returns (uint) {
563         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
564     }
565 
566     function getRateStalePeriod() internal view returns (uint) {
567         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
568     }
569 
570     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
571         return
572             flexibleStorage().getUIntValue(
573                 SETTING_CONTRACT_NAME,
574                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
575             );
576     }
577 
578     function getMinimumStakeTime() internal view returns (uint) {
579         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
580     }
581 
582     function getAggregatorWarningFlags() internal view returns (address) {
583         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
584     }
585 
586     function getDebtSnapshotStaleTime() internal view returns (uint) {
587         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
588     }
589 }
590 
591 
592 // https://docs.synthetix.io/contracts/source/interfaces/idebtcache
593 interface IDebtCache {
594     // Views
595 
596     function cachedDebt() external view returns (uint);
597 
598     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint);
599 
600     function cacheTimestamp() external view returns (uint);
601 
602     function cacheInvalid() external view returns (bool);
603 
604     function cacheStale() external view returns (bool);
605 
606     function currentSynthDebts(bytes32[] calldata currencyKeys)
607         external
608         view
609         returns (uint[] memory debtValues, bool anyRateIsInvalid);
610 
611     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory debtValues);
612 
613     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid);
614 
615     function cacheInfo()
616         external
617         view
618         returns (
619             uint debt,
620             uint timestamp,
621             bool isInvalid,
622             bool isStale
623         );
624 
625     // Mutative functions
626 
627     function takeDebtSnapshot() external;
628 
629     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external;
630 }
631 
632 
633 /**
634  * @dev Wrappers over Solidity's arithmetic operations with added overflow
635  * checks.
636  *
637  * Arithmetic operations in Solidity wrap on overflow. This can easily result
638  * in bugs, because programmers usually assume that an overflow raises an
639  * error, which is the standard behavior in high level programming languages.
640  * `SafeMath` restores this intuition by reverting the transaction when an
641  * operation overflows.
642  *
643  * Using this library instead of the unchecked operations eliminates an entire
644  * class of bugs, so it's recommended to use it always.
645  */
646 library SafeMath {
647     /**
648      * @dev Returns the addition of two unsigned integers, reverting on
649      * overflow.
650      *
651      * Counterpart to Solidity's `+` operator.
652      *
653      * Requirements:
654      * - Addition cannot overflow.
655      */
656     function add(uint256 a, uint256 b) internal pure returns (uint256) {
657         uint256 c = a + b;
658         require(c >= a, "SafeMath: addition overflow");
659 
660         return c;
661     }
662 
663     /**
664      * @dev Returns the subtraction of two unsigned integers, reverting on
665      * overflow (when the result is negative).
666      *
667      * Counterpart to Solidity's `-` operator.
668      *
669      * Requirements:
670      * - Subtraction cannot overflow.
671      */
672     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
673         require(b <= a, "SafeMath: subtraction overflow");
674         uint256 c = a - b;
675 
676         return c;
677     }
678 
679     /**
680      * @dev Returns the multiplication of two unsigned integers, reverting on
681      * overflow.
682      *
683      * Counterpart to Solidity's `*` operator.
684      *
685      * Requirements:
686      * - Multiplication cannot overflow.
687      */
688     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
689         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
690         // benefit is lost if 'b' is also tested.
691         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
692         if (a == 0) {
693             return 0;
694         }
695 
696         uint256 c = a * b;
697         require(c / a == b, "SafeMath: multiplication overflow");
698 
699         return c;
700     }
701 
702     /**
703      * @dev Returns the integer division of two unsigned integers. Reverts on
704      * division by zero. The result is rounded towards zero.
705      *
706      * Counterpart to Solidity's `/` operator. Note: this function uses a
707      * `revert` opcode (which leaves remaining gas untouched) while Solidity
708      * uses an invalid opcode to revert (consuming all remaining gas).
709      *
710      * Requirements:
711      * - The divisor cannot be zero.
712      */
713     function div(uint256 a, uint256 b) internal pure returns (uint256) {
714         // Solidity only automatically asserts when dividing by 0
715         require(b > 0, "SafeMath: division by zero");
716         uint256 c = a / b;
717         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
718 
719         return c;
720     }
721 
722     /**
723      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
724      * Reverts when dividing by zero.
725      *
726      * Counterpart to Solidity's `%` operator. This function uses a `revert`
727      * opcode (which leaves remaining gas untouched) while Solidity uses an
728      * invalid opcode to revert (consuming all remaining gas).
729      *
730      * Requirements:
731      * - The divisor cannot be zero.
732      */
733     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
734         require(b != 0, "SafeMath: modulo by zero");
735         return a % b;
736     }
737 }
738 
739 
740 // Libraries
741 
742 
743 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
744 library SafeDecimalMath {
745     using SafeMath for uint;
746 
747     /* Number of decimal places in the representations. */
748     uint8 public constant decimals = 18;
749     uint8 public constant highPrecisionDecimals = 27;
750 
751     /* The number representing 1.0. */
752     uint public constant UNIT = 10**uint(decimals);
753 
754     /* The number representing 1.0 for higher fidelity numbers. */
755     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
756     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
757 
758     /**
759      * @return Provides an interface to UNIT.
760      */
761     function unit() external pure returns (uint) {
762         return UNIT;
763     }
764 
765     /**
766      * @return Provides an interface to PRECISE_UNIT.
767      */
768     function preciseUnit() external pure returns (uint) {
769         return PRECISE_UNIT;
770     }
771 
772     /**
773      * @return The result of multiplying x and y, interpreting the operands as fixed-point
774      * decimals.
775      *
776      * @dev A unit factor is divided out after the product of x and y is evaluated,
777      * so that product must be less than 2**256. As this is an integer division,
778      * the internal division always rounds down. This helps save on gas. Rounding
779      * is more expensive on gas.
780      */
781     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
782         /* Divide by UNIT to remove the extra factor introduced by the product. */
783         return x.mul(y) / UNIT;
784     }
785 
786     /**
787      * @return The result of safely multiplying x and y, interpreting the operands
788      * as fixed-point decimals of the specified precision unit.
789      *
790      * @dev The operands should be in the form of a the specified unit factor which will be
791      * divided out after the product of x and y is evaluated, so that product must be
792      * less than 2**256.
793      *
794      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
795      * Rounding is useful when you need to retain fidelity for small decimal numbers
796      * (eg. small fractions or percentages).
797      */
798     function _multiplyDecimalRound(
799         uint x,
800         uint y,
801         uint precisionUnit
802     ) private pure returns (uint) {
803         /* Divide by UNIT to remove the extra factor introduced by the product. */
804         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
805 
806         if (quotientTimesTen % 10 >= 5) {
807             quotientTimesTen += 10;
808         }
809 
810         return quotientTimesTen / 10;
811     }
812 
813     /**
814      * @return The result of safely multiplying x and y, interpreting the operands
815      * as fixed-point decimals of a precise unit.
816      *
817      * @dev The operands should be in the precise unit factor which will be
818      * divided out after the product of x and y is evaluated, so that product must be
819      * less than 2**256.
820      *
821      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
822      * Rounding is useful when you need to retain fidelity for small decimal numbers
823      * (eg. small fractions or percentages).
824      */
825     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
826         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
827     }
828 
829     /**
830      * @return The result of safely multiplying x and y, interpreting the operands
831      * as fixed-point decimals of a standard unit.
832      *
833      * @dev The operands should be in the standard unit factor which will be
834      * divided out after the product of x and y is evaluated, so that product must be
835      * less than 2**256.
836      *
837      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
838      * Rounding is useful when you need to retain fidelity for small decimal numbers
839      * (eg. small fractions or percentages).
840      */
841     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
842         return _multiplyDecimalRound(x, y, UNIT);
843     }
844 
845     /**
846      * @return The result of safely dividing x and y. The return value is a high
847      * precision decimal.
848      *
849      * @dev y is divided after the product of x and the standard precision unit
850      * is evaluated, so the product of x and UNIT must be less than 2**256. As
851      * this is an integer division, the result is always rounded down.
852      * This helps save on gas. Rounding is more expensive on gas.
853      */
854     function divideDecimal(uint x, uint y) internal pure returns (uint) {
855         /* Reintroduce the UNIT factor that will be divided out by y. */
856         return x.mul(UNIT).div(y);
857     }
858 
859     /**
860      * @return The result of safely dividing x and y. The return value is as a rounded
861      * decimal in the precision unit specified in the parameter.
862      *
863      * @dev y is divided after the product of x and the specified precision unit
864      * is evaluated, so the product of x and the specified precision unit must
865      * be less than 2**256. The result is rounded to the nearest increment.
866      */
867     function _divideDecimalRound(
868         uint x,
869         uint y,
870         uint precisionUnit
871     ) private pure returns (uint) {
872         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
873 
874         if (resultTimesTen % 10 >= 5) {
875             resultTimesTen += 10;
876         }
877 
878         return resultTimesTen / 10;
879     }
880 
881     /**
882      * @return The result of safely dividing x and y. The return value is as a rounded
883      * standard precision decimal.
884      *
885      * @dev y is divided after the product of x and the standard precision unit
886      * is evaluated, so the product of x and the standard precision unit must
887      * be less than 2**256. The result is rounded to the nearest increment.
888      */
889     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
890         return _divideDecimalRound(x, y, UNIT);
891     }
892 
893     /**
894      * @return The result of safely dividing x and y. The return value is as a rounded
895      * high precision decimal.
896      *
897      * @dev y is divided after the product of x and the high precision unit
898      * is evaluated, so the product of x and the high precision unit must
899      * be less than 2**256. The result is rounded to the nearest increment.
900      */
901     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
902         return _divideDecimalRound(x, y, PRECISE_UNIT);
903     }
904 
905     /**
906      * @dev Convert a standard decimal representation to a high precision one.
907      */
908     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
909         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
910     }
911 
912     /**
913      * @dev Convert a high precision decimal to a standard decimal representation.
914      */
915     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
916         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
917 
918         if (quotientTimesTen % 10 >= 5) {
919             quotientTimesTen += 10;
920         }
921 
922         return quotientTimesTen / 10;
923     }
924 }
925 
926 
927 interface IVirtualSynth {
928     // Views
929     function balanceOfUnderlying(address account) external view returns (uint);
930 
931     function rate() external view returns (uint);
932 
933     function readyToSettle() external view returns (bool);
934 
935     function secsLeftInWaitingPeriod() external view returns (uint);
936 
937     function settled() external view returns (bool);
938 
939     function synth() external view returns (ISynth);
940 
941     // Mutative functions
942     function settle(address account) external;
943 }
944 
945 
946 // https://docs.synthetix.io/contracts/source/interfaces/iexchanger
947 interface IExchanger {
948     // Views
949     function calculateAmountAfterSettlement(
950         address from,
951         bytes32 currencyKey,
952         uint amount,
953         uint refunded
954     ) external view returns (uint amountAfterSettlement);
955 
956     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
957 
958     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
959 
960     function settlementOwing(address account, bytes32 currencyKey)
961         external
962         view
963         returns (
964             uint reclaimAmount,
965             uint rebateAmount,
966             uint numEntries
967         );
968 
969     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
970 
971     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
972         external
973         view
974         returns (uint exchangeFeeRate);
975 
976     function getAmountsForExchange(
977         uint sourceAmount,
978         bytes32 sourceCurrencyKey,
979         bytes32 destinationCurrencyKey
980     )
981         external
982         view
983         returns (
984             uint amountReceived,
985             uint fee,
986             uint exchangeFeeRate
987         );
988 
989     function priceDeviationThresholdFactor() external view returns (uint);
990 
991     function waitingPeriodSecs() external view returns (uint);
992 
993     // Mutative functions
994     function exchange(
995         address from,
996         bytes32 sourceCurrencyKey,
997         uint sourceAmount,
998         bytes32 destinationCurrencyKey,
999         address destinationAddress
1000     ) external returns (uint amountReceived);
1001 
1002     function exchangeOnBehalf(
1003         address exchangeForAddress,
1004         address from,
1005         bytes32 sourceCurrencyKey,
1006         uint sourceAmount,
1007         bytes32 destinationCurrencyKey
1008     ) external returns (uint amountReceived);
1009 
1010     function exchangeWithTracking(
1011         address from,
1012         bytes32 sourceCurrencyKey,
1013         uint sourceAmount,
1014         bytes32 destinationCurrencyKey,
1015         address destinationAddress,
1016         address originator,
1017         bytes32 trackingCode
1018     ) external returns (uint amountReceived);
1019 
1020     function exchangeOnBehalfWithTracking(
1021         address exchangeForAddress,
1022         address from,
1023         bytes32 sourceCurrencyKey,
1024         uint sourceAmount,
1025         bytes32 destinationCurrencyKey,
1026         address originator,
1027         bytes32 trackingCode
1028     ) external returns (uint amountReceived);
1029 
1030     function exchangeWithVirtual(
1031         address from,
1032         bytes32 sourceCurrencyKey,
1033         uint sourceAmount,
1034         bytes32 destinationCurrencyKey,
1035         address destinationAddress,
1036         bytes32 trackingCode
1037     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1038 
1039     function settle(address from, bytes32 currencyKey)
1040         external
1041         returns (
1042             uint reclaimed,
1043             uint refunded,
1044             uint numEntries
1045         );
1046 
1047     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external;
1048 
1049     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
1050 }
1051 
1052 
1053 // https://docs.synthetix.io/contracts/source/interfaces/iexchangerates
1054 interface IExchangeRates {
1055     // Structs
1056     struct RateAndUpdatedTime {
1057         uint216 rate;
1058         uint40 time;
1059     }
1060 
1061     struct InversePricing {
1062         uint entryPoint;
1063         uint upperLimit;
1064         uint lowerLimit;
1065         bool frozenAtUpperLimit;
1066         bool frozenAtLowerLimit;
1067     }
1068 
1069     // Views
1070     function aggregators(bytes32 currencyKey) external view returns (address);
1071 
1072     function aggregatorWarningFlags() external view returns (address);
1073 
1074     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1075 
1076     function canFreezeRate(bytes32 currencyKey) external view returns (bool);
1077 
1078     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
1079 
1080     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1081 
1082     function effectiveValue(
1083         bytes32 sourceCurrencyKey,
1084         uint sourceAmount,
1085         bytes32 destinationCurrencyKey
1086     ) external view returns (uint value);
1087 
1088     function effectiveValueAndRates(
1089         bytes32 sourceCurrencyKey,
1090         uint sourceAmount,
1091         bytes32 destinationCurrencyKey
1092     )
1093         external
1094         view
1095         returns (
1096             uint value,
1097             uint sourceRate,
1098             uint destinationRate
1099         );
1100 
1101     function effectiveValueAtRound(
1102         bytes32 sourceCurrencyKey,
1103         uint sourceAmount,
1104         bytes32 destinationCurrencyKey,
1105         uint roundIdForSrc,
1106         uint roundIdForDest
1107     ) external view returns (uint value);
1108 
1109     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1110 
1111     function getLastRoundIdBeforeElapsedSecs(
1112         bytes32 currencyKey,
1113         uint startingRoundId,
1114         uint startingTimestamp,
1115         uint timediff
1116     ) external view returns (uint);
1117 
1118     function inversePricing(bytes32 currencyKey)
1119         external
1120         view
1121         returns (
1122             uint entryPoint,
1123             uint upperLimit,
1124             uint lowerLimit,
1125             bool frozenAtUpperLimit,
1126             bool frozenAtLowerLimit
1127         );
1128 
1129     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1130 
1131     function oracle() external view returns (address);
1132 
1133     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1134 
1135     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1136 
1137     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1138 
1139     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1140 
1141     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1142 
1143     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
1144 
1145     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1146 
1147     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1148 
1149     function rateStalePeriod() external view returns (uint);
1150 
1151     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
1152         external
1153         view
1154         returns (uint[] memory rates, uint[] memory times);
1155 
1156     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1157         external
1158         view
1159         returns (uint[] memory rates, bool anyRateInvalid);
1160 
1161     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1162 
1163     // Mutative functions
1164     function freezeRate(bytes32 currencyKey) external;
1165 }
1166 
1167 
1168 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1169 interface ISystemStatus {
1170     struct Status {
1171         bool canSuspend;
1172         bool canResume;
1173     }
1174 
1175     struct Suspension {
1176         bool suspended;
1177         // reason is an integer code,
1178         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1179         uint248 reason;
1180     }
1181 
1182     // Views
1183     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1184 
1185     function requireSystemActive() external view;
1186 
1187     function requireIssuanceActive() external view;
1188 
1189     function requireExchangeActive() external view;
1190 
1191     function requireSynthActive(bytes32 currencyKey) external view;
1192 
1193     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1194 
1195     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1196 
1197     // Restricted functions
1198     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1199 
1200     function updateAccessControl(
1201         bytes32 section,
1202         address account,
1203         bool canSuspend,
1204         bool canResume
1205     ) external;
1206 }
1207 
1208 
1209 // https://docs.synthetix.io/contracts/source/interfaces/iethercollateral
1210 interface IEtherCollateral {
1211     // Views
1212     function totalIssuedSynths() external view returns (uint256);
1213 
1214     function totalLoansCreated() external view returns (uint256);
1215 
1216     function totalOpenLoanCount() external view returns (uint256);
1217 
1218     // Mutative functions
1219     function openLoan() external payable returns (uint256 loanID);
1220 
1221     function closeLoan(uint256 loanID) external;
1222 
1223     function liquidateUnclosedLoan(address _loanCreatorsAddress, uint256 _loanID) external;
1224 }
1225 
1226 
1227 // https://docs.synthetix.io/contracts/source/interfaces/iethercollateralsusd
1228 interface IEtherCollateralsUSD {
1229     // Views
1230     function totalIssuedSynths() external view returns (uint256);
1231 
1232     function totalLoansCreated() external view returns (uint256);
1233 
1234     function totalOpenLoanCount() external view returns (uint256);
1235 
1236     // Mutative functions
1237     function openLoan(uint256 _loanAmount) external payable returns (uint256 loanID);
1238 
1239     function closeLoan(uint256 loanID) external;
1240 
1241     function liquidateUnclosedLoan(address _loanCreatorsAddress, uint256 _loanID) external;
1242 
1243     function depositCollateral(address account, uint256 loanID) external payable;
1244 
1245     function withdrawCollateral(uint256 loanID, uint256 withdrawAmount) external;
1246 
1247     function repayLoan(
1248         address _loanCreatorsAddress,
1249         uint256 _loanID,
1250         uint256 _repayAmount
1251     ) external;
1252 }
1253 
1254 
1255 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
1256 interface IERC20 {
1257     // ERC20 Optional Views
1258     function name() external view returns (string memory);
1259 
1260     function symbol() external view returns (string memory);
1261 
1262     function decimals() external view returns (uint8);
1263 
1264     // Views
1265     function totalSupply() external view returns (uint);
1266 
1267     function balanceOf(address owner) external view returns (uint);
1268 
1269     function allowance(address owner, address spender) external view returns (uint);
1270 
1271     // Mutative functions
1272     function transfer(address to, uint value) external returns (bool);
1273 
1274     function approve(address spender, uint value) external returns (bool);
1275 
1276     function transferFrom(
1277         address from,
1278         address to,
1279         uint value
1280     ) external returns (bool);
1281 
1282     // Events
1283     event Transfer(address indexed from, address indexed to, uint value);
1284 
1285     event Approval(address indexed owner, address indexed spender, uint value);
1286 }
1287 
1288 
1289 interface ICollateralManager {
1290     // Manager information
1291     function hasCollateral(address collateral) external view returns (bool);
1292 
1293     function isSynthManaged(bytes32 currencyKey) external view returns (bool);
1294 
1295     // State information
1296     function long(bytes32 synth) external view returns (uint amount);
1297 
1298     function short(bytes32 synth) external view returns (uint amount);
1299 
1300     function totalLong() external view returns (uint susdValue, bool anyRateIsInvalid);
1301 
1302     function totalShort() external view returns (uint susdValue, bool anyRateIsInvalid);
1303 
1304     function getBorrowRate() external view returns (uint borrowRate, bool anyRateIsInvalid);
1305 
1306     function getShortRate(bytes32 synth) external view returns (uint shortRate, bool rateIsInvalid);
1307 
1308     function getRatesAndTime(uint index)
1309         external
1310         view
1311         returns (
1312             uint entryRate,
1313             uint lastRate,
1314             uint lastUpdated,
1315             uint newIndex
1316         );
1317 
1318     function getShortRatesAndTime(bytes32 currency, uint index)
1319         external
1320         view
1321         returns (
1322             uint entryRate,
1323             uint lastRate,
1324             uint lastUpdated,
1325             uint newIndex
1326         );
1327 
1328     function exceedsDebtLimit(uint amount, bytes32 currency) external view returns (bool canIssue, bool anyRateIsInvalid);
1329 
1330     function areSynthsAndCurrenciesSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1331         external
1332         view
1333         returns (bool);
1334 
1335     function areShortableSynthsSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1336         external
1337         view
1338         returns (bool);
1339 
1340     // Loans
1341     function getNewLoanId() external returns (uint id);
1342 
1343     // Manager mutative
1344     function addCollaterals(address[] calldata collaterals) external;
1345 
1346     function removeCollaterals(address[] calldata collaterals) external;
1347 
1348     function addSynths(bytes32[] calldata synthNamesInResolver, bytes32[] calldata synthKeys) external;
1349 
1350     function removeSynths(bytes32[] calldata synths, bytes32[] calldata synthKeys) external;
1351 
1352     function addShortableSynths(bytes32[2][] calldata requiredSynthAndInverseNamesInResolver, bytes32[] calldata synthKeys)
1353         external;
1354 
1355     function removeShortableSynths(bytes32[] calldata synths) external;
1356 
1357     // State mutative
1358     function updateBorrowRates(uint rate) external;
1359 
1360     function updateShortRates(bytes32 currency, uint rate) external;
1361 
1362     function incrementLongs(bytes32 synth, uint amount) external;
1363 
1364     function decrementLongs(bytes32 synth, uint amount) external;
1365 
1366     function incrementShorts(bytes32 synth, uint amount) external;
1367 
1368     function decrementShorts(bytes32 synth, uint amount) external;
1369 }
1370 
1371 
1372 // Inheritance
1373 
1374 
1375 // Libraries
1376 
1377 
1378 // Internal references
1379 
1380 
1381 // https://docs.synthetix.io/contracts/source/contracts/debtcache
1382 contract DebtCache is Owned, MixinSystemSettings, IDebtCache {
1383     using SafeMath for uint;
1384     using SafeDecimalMath for uint;
1385 
1386     uint internal _cachedDebt;
1387     mapping(bytes32 => uint) internal _cachedSynthDebt;
1388     uint internal _cacheTimestamp;
1389     bool internal _cacheInvalid = true;
1390 
1391     /* ========== ENCODED NAMES ========== */
1392 
1393     bytes32 internal constant sUSD = "sUSD";
1394     bytes32 internal constant sETH = "sETH";
1395 
1396     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1397 
1398     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1399     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1400     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1401     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1402     bytes32 private constant CONTRACT_ETHERCOLLATERAL = "EtherCollateral";
1403     bytes32 private constant CONTRACT_ETHERCOLLATERAL_SUSD = "EtherCollateralsUSD";
1404     bytes32 private constant CONTRACT_COLLATERALMANAGER = "CollateralManager";
1405 
1406     constructor(address _owner, address _resolver) public Owned(_owner) MixinSystemSettings(_resolver) {}
1407 
1408     /* ========== VIEWS ========== */
1409 
1410     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1411         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1412         bytes32[] memory newAddresses = new bytes32[](7);
1413         newAddresses[0] = CONTRACT_ISSUER;
1414         newAddresses[1] = CONTRACT_EXCHANGER;
1415         newAddresses[2] = CONTRACT_EXRATES;
1416         newAddresses[3] = CONTRACT_SYSTEMSTATUS;
1417         newAddresses[4] = CONTRACT_ETHERCOLLATERAL;
1418         newAddresses[5] = CONTRACT_ETHERCOLLATERAL_SUSD;
1419         newAddresses[6] = CONTRACT_COLLATERALMANAGER;
1420         addresses = combineArrays(existingAddresses, newAddresses);
1421     }
1422 
1423     function issuer() internal view returns (IIssuer) {
1424         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1425     }
1426 
1427     function exchanger() internal view returns (IExchanger) {
1428         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER));
1429     }
1430 
1431     function exchangeRates() internal view returns (IExchangeRates) {
1432         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES));
1433     }
1434 
1435     function systemStatus() internal view returns (ISystemStatus) {
1436         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1437     }
1438 
1439     function etherCollateral() internal view returns (IEtherCollateral) {
1440         return IEtherCollateral(requireAndGetAddress(CONTRACT_ETHERCOLLATERAL));
1441     }
1442 
1443     function etherCollateralsUSD() internal view returns (IEtherCollateralsUSD) {
1444         return IEtherCollateralsUSD(requireAndGetAddress(CONTRACT_ETHERCOLLATERAL_SUSD));
1445     }
1446 
1447     function collateralManager() internal view returns (ICollateralManager) {
1448         return ICollateralManager(requireAndGetAddress(CONTRACT_COLLATERALMANAGER));
1449     }
1450 
1451     function debtSnapshotStaleTime() external view returns (uint) {
1452         return getDebtSnapshotStaleTime();
1453     }
1454 
1455     function cachedDebt() external view returns (uint) {
1456         return _cachedDebt;
1457     }
1458 
1459     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint) {
1460         return _cachedSynthDebt[currencyKey];
1461     }
1462 
1463     function cacheTimestamp() external view returns (uint) {
1464         return _cacheTimestamp;
1465     }
1466 
1467     function cacheInvalid() external view returns (bool) {
1468         return _cacheInvalid;
1469     }
1470 
1471     function _cacheStale(uint timestamp) internal view returns (bool) {
1472         // Note a 0 timestamp means that the cache is uninitialised.
1473         // We'll keep the check explicitly in case the stale time is
1474         // ever set to something higher than the current unix time (e.g. to turn off staleness).
1475         return getDebtSnapshotStaleTime() < block.timestamp - timestamp || timestamp == 0;
1476     }
1477 
1478     function cacheStale() external view returns (bool) {
1479         return _cacheStale(_cacheTimestamp);
1480     }
1481 
1482     function _issuedSynthValues(bytes32[] memory currencyKeys, uint[] memory rates) internal view returns (uint[] memory) {
1483         uint numValues = currencyKeys.length;
1484         uint[] memory values = new uint[](numValues);
1485         ISynth[] memory synths = issuer().getSynths(currencyKeys);
1486 
1487         for (uint i = 0; i < numValues; i++) {
1488             bytes32 key = currencyKeys[i];
1489             address synthAddress = address(synths[i]);
1490             require(synthAddress != address(0), "Synth does not exist");
1491             uint supply = IERC20(synthAddress).totalSupply();
1492 
1493             if (collateralManager().isSynthManaged(key)) {
1494                 uint collateralIssued = collateralManager().long(key);
1495 
1496                 // this is an edge case --
1497                 // if a synth other than sUSD is only issued by non SNX collateral
1498                 // the long value will exceed the supply if there was a minting fee,
1499                 // so we check explicitly and 0 it out to prevent
1500                 // a safesub overflow.
1501 
1502                 if (collateralIssued > supply) {
1503                     supply = 0;
1504                 } else {
1505                     supply = supply.sub(collateralIssued);
1506                 }
1507             }
1508 
1509             bool isSUSD = key == sUSD;
1510             if (isSUSD || key == sETH) {
1511                 IEtherCollateral etherCollateralContract = isSUSD
1512                     ? IEtherCollateral(address(etherCollateralsUSD()))
1513                     : etherCollateral();
1514                 uint etherCollateralSupply = etherCollateralContract.totalIssuedSynths();
1515                 supply = supply.sub(etherCollateralSupply);
1516             }
1517 
1518             values[i] = supply.multiplyDecimalRound(rates[i]);
1519         }
1520         return values;
1521     }
1522 
1523     function _currentSynthDebts(bytes32[] memory currencyKeys)
1524         internal
1525         view
1526         returns (uint[] memory snxIssuedDebts, bool anyRateIsInvalid)
1527     {
1528         (uint[] memory rates, bool isInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1529         return (_issuedSynthValues(currencyKeys, rates), isInvalid);
1530     }
1531 
1532     function currentSynthDebts(bytes32[] calldata currencyKeys)
1533         external
1534         view
1535         returns (uint[] memory debtValues, bool anyRateIsInvalid)
1536     {
1537         return _currentSynthDebts(currencyKeys);
1538     }
1539 
1540     function _cachedSynthDebts(bytes32[] memory currencyKeys) internal view returns (uint[] memory) {
1541         uint numKeys = currencyKeys.length;
1542         uint[] memory debts = new uint[](numKeys);
1543         for (uint i = 0; i < numKeys; i++) {
1544             debts[i] = _cachedSynthDebt[currencyKeys[i]];
1545         }
1546         return debts;
1547     }
1548 
1549     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory snxIssuedDebts) {
1550         return _cachedSynthDebts(currencyKeys);
1551     }
1552 
1553     function _currentDebt() internal view returns (uint debt, bool anyRateIsInvalid) {
1554         (uint[] memory values, bool isInvalid) = _currentSynthDebts(issuer().availableCurrencyKeys());
1555         uint numValues = values.length;
1556         uint total;
1557         for (uint i; i < numValues; i++) {
1558             total = total.add(values[i]);
1559         }
1560 
1561         // subtract the USD value of all shorts.
1562         (uint susdValue, bool shortInvalid) = collateralManager().totalShort();
1563 
1564         total = total.sub(susdValue);
1565 
1566         isInvalid = isInvalid || shortInvalid;
1567 
1568         return (total, isInvalid);
1569     }
1570 
1571     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid) {
1572         return _currentDebt();
1573     }
1574 
1575     function cacheInfo()
1576         external
1577         view
1578         returns (
1579             uint debt,
1580             uint timestamp,
1581             bool isInvalid,
1582             bool isStale
1583         )
1584     {
1585         uint time = _cacheTimestamp;
1586         return (_cachedDebt, time, _cacheInvalid, _cacheStale(time));
1587     }
1588 
1589     /* ========== MUTATIVE FUNCTIONS ========== */
1590 
1591     // This function exists in case a synth is ever somehow removed without its snapshot being updated.
1592     function purgeCachedSynthDebt(bytes32 currencyKey) external onlyOwner {
1593         require(issuer().synths(currencyKey) == ISynth(0), "Synth exists");
1594         delete _cachedSynthDebt[currencyKey];
1595     }
1596 
1597     function takeDebtSnapshot() external requireSystemActiveIfNotOwner {
1598         bytes32[] memory currencyKeys = issuer().availableCurrencyKeys();
1599         (uint[] memory values, bool isInvalid) = _currentSynthDebts(currencyKeys);
1600 
1601         // Subtract the USD value of all shorts.
1602         (uint shortValue, ) = collateralManager().totalShort();
1603 
1604         uint numValues = values.length;
1605         uint snxCollateralDebt;
1606         for (uint i; i < numValues; i++) {
1607             uint value = values[i];
1608             snxCollateralDebt = snxCollateralDebt.add(value);
1609             _cachedSynthDebt[currencyKeys[i]] = value;
1610         }
1611         _cachedDebt = snxCollateralDebt.sub(shortValue);
1612         _cacheTimestamp = block.timestamp;
1613         emit DebtCacheUpdated(snxCollateralDebt);
1614         emit DebtCacheSnapshotTaken(block.timestamp);
1615 
1616         // (in)validate the cache if necessary
1617         _updateDebtCacheValidity(isInvalid);
1618     }
1619 
1620     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external requireSystemActiveIfNotOwner {
1621         (uint[] memory rates, bool anyRateInvalid) = exchangeRates().ratesAndInvalidForCurrencies(currencyKeys);
1622         _updateCachedSynthDebtsWithRates(currencyKeys, rates, anyRateInvalid);
1623     }
1624 
1625     function updateCachedSynthDebtWithRate(bytes32 currencyKey, uint currencyRate) external onlyIssuer {
1626         bytes32[] memory synthKeyArray = new bytes32[](1);
1627         synthKeyArray[0] = currencyKey;
1628         uint[] memory synthRateArray = new uint[](1);
1629         synthRateArray[0] = currencyRate;
1630         _updateCachedSynthDebtsWithRates(synthKeyArray, synthRateArray, false);
1631     }
1632 
1633     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates)
1634         external
1635         onlyIssuerOrExchanger
1636     {
1637         _updateCachedSynthDebtsWithRates(currencyKeys, currencyRates, false);
1638     }
1639 
1640     function updateDebtCacheValidity(bool currentlyInvalid) external onlyIssuer {
1641         _updateDebtCacheValidity(currentlyInvalid);
1642     }
1643 
1644     /* ========== INTERNAL FUNCTIONS ========== */
1645 
1646     function _updateDebtCacheValidity(bool currentlyInvalid) internal {
1647         if (_cacheInvalid != currentlyInvalid) {
1648             _cacheInvalid = currentlyInvalid;
1649             emit DebtCacheValidityChanged(currentlyInvalid);
1650         }
1651     }
1652 
1653     function _updateCachedSynthDebtsWithRates(
1654         bytes32[] memory currencyKeys,
1655         uint[] memory currentRates,
1656         bool anyRateIsInvalid
1657     ) internal {
1658         uint numKeys = currencyKeys.length;
1659         require(numKeys == currentRates.length, "Input array lengths differ");
1660 
1661         // Update the cached values for each synth, saving the sums as we go.
1662         uint cachedSum;
1663         uint currentSum;
1664         uint[] memory currentValues = _issuedSynthValues(currencyKeys, currentRates);
1665         for (uint i = 0; i < numKeys; i++) {
1666             bytes32 key = currencyKeys[i];
1667             uint currentSynthDebt = currentValues[i];
1668             cachedSum = cachedSum.add(_cachedSynthDebt[key]);
1669             currentSum = currentSum.add(currentSynthDebt);
1670             _cachedSynthDebt[key] = currentSynthDebt;
1671         }
1672 
1673         // Compute the difference and apply it to the snapshot
1674         if (cachedSum != currentSum) {
1675             uint debt = _cachedDebt;
1676             // This requirement should never fail, as the total debt snapshot is the sum of the individual synth
1677             // debt snapshots.
1678             require(cachedSum <= debt, "Cached synth sum exceeds total debt");
1679             debt = debt.sub(cachedSum).add(currentSum);
1680             _cachedDebt = debt;
1681             emit DebtCacheUpdated(debt);
1682         }
1683 
1684         // A partial update can invalidate the debt cache, but a full snapshot must be performed in order
1685         // to re-validate it.
1686         if (anyRateIsInvalid) {
1687             _updateDebtCacheValidity(anyRateIsInvalid);
1688         }
1689     }
1690 
1691     /* ========== MODIFIERS ========== */
1692 
1693     function _requireSystemActiveIfNotOwner() internal view {
1694         if (msg.sender != owner) {
1695             systemStatus().requireSystemActive();
1696         }
1697     }
1698 
1699     modifier requireSystemActiveIfNotOwner() {
1700         _requireSystemActiveIfNotOwner();
1701         _;
1702     }
1703 
1704     function _onlyIssuer() internal view {
1705         require(msg.sender == address(issuer()), "Sender is not Issuer");
1706     }
1707 
1708     modifier onlyIssuer() {
1709         _onlyIssuer();
1710         _;
1711     }
1712 
1713     function _onlyIssuerOrExchanger() internal view {
1714         require(msg.sender == address(issuer()) || msg.sender == address(exchanger()), "Sender is not Issuer or Exchanger");
1715     }
1716 
1717     modifier onlyIssuerOrExchanger() {
1718         _onlyIssuerOrExchanger();
1719         _;
1720     }
1721 
1722     /* ========== EVENTS ========== */
1723 
1724     event DebtCacheUpdated(uint cachedDebt);
1725     event DebtCacheSnapshotTaken(uint timestamp);
1726     event DebtCacheValidityChanged(bool indexed isInvalid);
1727 }
1728 
1729     