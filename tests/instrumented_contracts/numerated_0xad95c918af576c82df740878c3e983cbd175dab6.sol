1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: Liquidations.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/Liquidations.sol
11 * Docs: https://docs.synthetix.io/contracts/Liquidations
12 *
13 * Contract Dependencies: 
14 *	- IAddressResolver
15 *	- ILiquidations
16 *	- MixinResolver
17 *	- MixinSystemSettings
18 *	- Owned
19 *	- State
20 * Libraries: 
21 *	- SafeDecimalMath
22 *	- SafeMath
23 *
24 * MIT License
25 * ===========
26 *
27 * Copyright (c) 2020 Synthetix
28 *
29 * Permission is hereby granted, free of charge, to any person obtaining a copy
30 * of this software and associated documentation files (the "Software"), to deal
31 * in the Software without restriction, including without limitation the rights
32 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
33 * copies of the Software, and to permit persons to whom the Software is
34 * furnished to do so, subject to the following conditions:
35 *
36 * The above copyright notice and this permission notice shall be included in all
37 * copies or substantial portions of the Software.
38 *
39 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
40 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
41 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
42 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
43 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
44 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
45 */
46 
47 
48 
49 pragma solidity ^0.5.16;
50 
51 
52 // https://docs.synthetix.io/contracts/source/contracts/owned
53 contract Owned {
54     address public owner;
55     address public nominatedOwner;
56 
57     constructor(address _owner) public {
58         require(_owner != address(0), "Owner address cannot be 0");
59         owner = _owner;
60         emit OwnerChanged(address(0), _owner);
61     }
62 
63     function nominateNewOwner(address _owner) external onlyOwner {
64         nominatedOwner = _owner;
65         emit OwnerNominated(_owner);
66     }
67 
68     function acceptOwnership() external {
69         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
70         emit OwnerChanged(owner, nominatedOwner);
71         owner = nominatedOwner;
72         nominatedOwner = address(0);
73     }
74 
75     modifier onlyOwner {
76         _onlyOwner();
77         _;
78     }
79 
80     function _onlyOwner() private view {
81         require(msg.sender == owner, "Only the contract owner may perform this action");
82     }
83 
84     event OwnerNominated(address newOwner);
85     event OwnerChanged(address oldOwner, address newOwner);
86 }
87 
88 
89 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
90 interface IAddressResolver {
91     function getAddress(bytes32 name) external view returns (address);
92 
93     function getSynth(bytes32 key) external view returns (address);
94 
95     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
96 }
97 
98 
99 // https://docs.synthetix.io/contracts/source/interfaces/isynth
100 interface ISynth {
101     // Views
102     function currencyKey() external view returns (bytes32);
103 
104     function transferableSynths(address account) external view returns (uint);
105 
106     // Mutative functions
107     function transferAndSettle(address to, uint value) external returns (bool);
108 
109     function transferFromAndSettle(
110         address from,
111         address to,
112         uint value
113     ) external returns (bool);
114 
115     // Restricted: used internally to Synthetix
116     function burn(address account, uint amount) external;
117 
118     function issue(address account, uint amount) external;
119 }
120 
121 
122 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
123 interface IIssuer {
124     // Views
125     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
126 
127     function availableCurrencyKeys() external view returns (bytes32[] memory);
128 
129     function availableSynthCount() external view returns (uint);
130 
131     function availableSynths(uint index) external view returns (ISynth);
132 
133     function canBurnSynths(address account) external view returns (bool);
134 
135     function collateral(address account) external view returns (uint);
136 
137     function collateralisationRatio(address issuer) external view returns (uint);
138 
139     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
140         external
141         view
142         returns (uint cratio, bool anyRateIsInvalid);
143 
144     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
145 
146     function issuanceRatio() external view returns (uint);
147 
148     function lastIssueEvent(address account) external view returns (uint);
149 
150     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
151 
152     function minimumStakeTime() external view returns (uint);
153 
154     function remainingIssuableSynths(address issuer)
155         external
156         view
157         returns (
158             uint maxIssuable,
159             uint alreadyIssued,
160             uint totalSystemDebt
161         );
162 
163     function synths(bytes32 currencyKey) external view returns (ISynth);
164 
165     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
166 
167     function synthsByAddress(address synthAddress) external view returns (bytes32);
168 
169     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
170 
171     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
172         external
173         view
174         returns (uint transferable, bool anyRateIsInvalid);
175 
176     // Restricted: used internally to Synthetix
177     function issueSynths(address from, uint amount) external;
178 
179     function issueSynthsOnBehalf(
180         address issueFor,
181         address from,
182         uint amount
183     ) external;
184 
185     function issueMaxSynths(address from) external;
186 
187     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
188 
189     function burnSynths(address from, uint amount) external;
190 
191     function burnSynthsOnBehalf(
192         address burnForAddress,
193         address from,
194         uint amount
195     ) external;
196 
197     function burnSynthsToTarget(address from) external;
198 
199     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
200 
201     function liquidateDelinquentAccount(
202         address account,
203         uint susdAmount,
204         address liquidator
205     ) external returns (uint totalRedeemed, uint amountToLiquidate);
206 }
207 
208 
209 // Inheritance
210 
211 
212 // Internal references
213 
214 
215 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
216 contract AddressResolver is Owned, IAddressResolver {
217     mapping(bytes32 => address) public repository;
218 
219     constructor(address _owner) public Owned(_owner) {}
220 
221     /* ========== RESTRICTED FUNCTIONS ========== */
222 
223     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
224         require(names.length == destinations.length, "Input lengths must match");
225 
226         for (uint i = 0; i < names.length; i++) {
227             bytes32 name = names[i];
228             address destination = destinations[i];
229             repository[name] = destination;
230             emit AddressImported(name, destination);
231         }
232     }
233 
234     /* ========= PUBLIC FUNCTIONS ========== */
235 
236     function rebuildCaches(MixinResolver[] calldata destinations) external {
237         for (uint i = 0; i < destinations.length; i++) {
238             destinations[i].rebuildCache();
239         }
240     }
241 
242     /* ========== VIEWS ========== */
243 
244     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
245         for (uint i = 0; i < names.length; i++) {
246             if (repository[names[i]] != destinations[i]) {
247                 return false;
248             }
249         }
250         return true;
251     }
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
268 
269     /* ========== EVENTS ========== */
270 
271     event AddressImported(bytes32 name, address destination);
272 }
273 
274 
275 // solhint-disable payable-fallback
276 
277 // https://docs.synthetix.io/contracts/source/contracts/readproxy
278 contract ReadProxy is Owned {
279     address public target;
280 
281     constructor(address _owner) public Owned(_owner) {}
282 
283     function setTarget(address _target) external onlyOwner {
284         target = _target;
285         emit TargetUpdated(target);
286     }
287 
288     function() external {
289         // The basics of a proxy read call
290         // Note that msg.sender in the underlying will always be the address of this contract.
291         assembly {
292             calldatacopy(0, 0, calldatasize)
293 
294             // Use of staticcall - this will revert if the underlying function mutates state
295             let result := staticcall(gas, sload(target_slot), 0, calldatasize, 0, 0)
296             returndatacopy(0, 0, returndatasize)
297 
298             if iszero(result) {
299                 revert(0, returndatasize)
300             }
301             return(0, returndatasize)
302         }
303     }
304 
305     event TargetUpdated(address newTarget);
306 }
307 
308 
309 // Inheritance
310 
311 
312 // Internal references
313 
314 
315 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
316 contract MixinResolver {
317     AddressResolver public resolver;
318 
319     mapping(bytes32 => address) private addressCache;
320 
321     constructor(address _resolver) internal {
322         resolver = AddressResolver(_resolver);
323     }
324 
325     /* ========== INTERNAL FUNCTIONS ========== */
326 
327     function combineArrays(bytes32[] memory first, bytes32[] memory second)
328         internal
329         pure
330         returns (bytes32[] memory combination)
331     {
332         combination = new bytes32[](first.length + second.length);
333 
334         for (uint i = 0; i < first.length; i++) {
335             combination[i] = first[i];
336         }
337 
338         for (uint j = 0; j < second.length; j++) {
339             combination[first.length + j] = second[j];
340         }
341     }
342 
343     /* ========== PUBLIC FUNCTIONS ========== */
344 
345     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
346     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
347 
348     function rebuildCache() public {
349         bytes32[] memory requiredAddresses = resolverAddressesRequired();
350         // The resolver must call this function whenver it updates its state
351         for (uint i = 0; i < requiredAddresses.length; i++) {
352             bytes32 name = requiredAddresses[i];
353             // Note: can only be invoked once the resolver has all the targets needed added
354             address destination = resolver.requireAndGetAddress(
355                 name,
356                 string(abi.encodePacked("Resolver missing target: ", name))
357             );
358             addressCache[name] = destination;
359             emit CacheUpdated(name, destination);
360         }
361     }
362 
363     /* ========== VIEWS ========== */
364 
365     function isResolverCached() external view returns (bool) {
366         bytes32[] memory requiredAddresses = resolverAddressesRequired();
367         for (uint i = 0; i < requiredAddresses.length; i++) {
368             bytes32 name = requiredAddresses[i];
369             // false if our cache is invalid or if the resolver doesn't have the required address
370             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
371                 return false;
372             }
373         }
374 
375         return true;
376     }
377 
378     /* ========== INTERNAL FUNCTIONS ========== */
379 
380     function requireAndGetAddress(bytes32 name) internal view returns (address) {
381         address _foundAddress = addressCache[name];
382         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
383         return _foundAddress;
384     }
385 
386     /* ========== EVENTS ========== */
387 
388     event CacheUpdated(bytes32 name, address destination);
389 }
390 
391 
392 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
393 interface IFlexibleStorage {
394     // Views
395     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
396 
397     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
398 
399     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
400 
401     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
402 
403     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
404 
405     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
406 
407     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
408 
409     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
410 
411     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
412 
413     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
414 
415     // Mutative functions
416     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
417 
418     function deleteIntValue(bytes32 contractName, bytes32 record) external;
419 
420     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
421 
422     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
423 
424     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
425 
426     function setUIntValue(
427         bytes32 contractName,
428         bytes32 record,
429         uint value
430     ) external;
431 
432     function setUIntValues(
433         bytes32 contractName,
434         bytes32[] calldata records,
435         uint[] calldata values
436     ) external;
437 
438     function setIntValue(
439         bytes32 contractName,
440         bytes32 record,
441         int value
442     ) external;
443 
444     function setIntValues(
445         bytes32 contractName,
446         bytes32[] calldata records,
447         int[] calldata values
448     ) external;
449 
450     function setAddressValue(
451         bytes32 contractName,
452         bytes32 record,
453         address value
454     ) external;
455 
456     function setAddressValues(
457         bytes32 contractName,
458         bytes32[] calldata records,
459         address[] calldata values
460     ) external;
461 
462     function setBoolValue(
463         bytes32 contractName,
464         bytes32 record,
465         bool value
466     ) external;
467 
468     function setBoolValues(
469         bytes32 contractName,
470         bytes32[] calldata records,
471         bool[] calldata values
472     ) external;
473 
474     function setBytes32Value(
475         bytes32 contractName,
476         bytes32 record,
477         bytes32 value
478     ) external;
479 
480     function setBytes32Values(
481         bytes32 contractName,
482         bytes32[] calldata records,
483         bytes32[] calldata values
484     ) external;
485 }
486 
487 
488 // Internal references
489 
490 
491 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
492 contract MixinSystemSettings is MixinResolver {
493     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
494 
495     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
496     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
497     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
498     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
499     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
500     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
501     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
502     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
503     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
504     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
505     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
506     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
507     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
508     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
509     bytes32 internal constant SETTING_CROSS_DOMAIN_MESSAGE_GAS_LIMIT = "crossDomainMessageGasLimit";
510 
511     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
512 
513     constructor(address _resolver) internal MixinResolver(_resolver) {}
514 
515     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
516         addresses = new bytes32[](1);
517         addresses[0] = CONTRACT_FLEXIBLESTORAGE;
518     }
519 
520     function flexibleStorage() internal view returns (IFlexibleStorage) {
521         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE));
522     }
523 
524     function getCrossDomainMessageGasLimit() internal view returns (uint) {
525         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_CROSS_DOMAIN_MESSAGE_GAS_LIMIT);
526     }
527 
528     function getTradingRewardsEnabled() internal view returns (bool) {
529         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
530     }
531 
532     function getWaitingPeriodSecs() internal view returns (uint) {
533         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
534     }
535 
536     function getPriceDeviationThresholdFactor() internal view returns (uint) {
537         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
538     }
539 
540     function getIssuanceRatio() internal view returns (uint) {
541         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
542         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
543     }
544 
545     function getFeePeriodDuration() internal view returns (uint) {
546         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
547         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
548     }
549 
550     function getTargetThreshold() internal view returns (uint) {
551         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
552         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
553     }
554 
555     function getLiquidationDelay() internal view returns (uint) {
556         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
557     }
558 
559     function getLiquidationRatio() internal view returns (uint) {
560         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
561     }
562 
563     function getLiquidationPenalty() internal view returns (uint) {
564         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
565     }
566 
567     function getRateStalePeriod() internal view returns (uint) {
568         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
569     }
570 
571     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
572         return
573             flexibleStorage().getUIntValue(
574                 SETTING_CONTRACT_NAME,
575                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
576             );
577     }
578 
579     function getMinimumStakeTime() internal view returns (uint) {
580         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
581     }
582 
583     function getAggregatorWarningFlags() internal view returns (address) {
584         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
585     }
586 
587     function getDebtSnapshotStaleTime() internal view returns (uint) {
588         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
589     }
590 }
591 
592 
593 // https://docs.synthetix.io/contracts/source/interfaces/iliquidations
594 interface ILiquidations {
595     // Views
596     function isOpenForLiquidation(address account) external view returns (bool);
597 
598     function getLiquidationDeadlineForAccount(address account) external view returns (uint);
599 
600     function isLiquidationDeadlinePassed(address account) external view returns (bool);
601 
602     function liquidationDelay() external view returns (uint);
603 
604     function liquidationRatio() external view returns (uint);
605 
606     function liquidationPenalty() external view returns (uint);
607 
608     function calculateAmountToFixCollateral(uint debtBalance, uint collateral) external view returns (uint);
609 
610     // Mutative Functions
611     function flagAccountForLiquidation(address account) external;
612 
613     // Restricted: used internally to Synthetix
614     function removeAccountInLiquidation(address account) external;
615 
616     function checkAndRemoveAccountInLiquidation(address account) external;
617 }
618 
619 
620 /**
621  * @dev Wrappers over Solidity's arithmetic operations with added overflow
622  * checks.
623  *
624  * Arithmetic operations in Solidity wrap on overflow. This can easily result
625  * in bugs, because programmers usually assume that an overflow raises an
626  * error, which is the standard behavior in high level programming languages.
627  * `SafeMath` restores this intuition by reverting the transaction when an
628  * operation overflows.
629  *
630  * Using this library instead of the unchecked operations eliminates an entire
631  * class of bugs, so it's recommended to use it always.
632  */
633 library SafeMath {
634     /**
635      * @dev Returns the addition of two unsigned integers, reverting on
636      * overflow.
637      *
638      * Counterpart to Solidity's `+` operator.
639      *
640      * Requirements:
641      * - Addition cannot overflow.
642      */
643     function add(uint256 a, uint256 b) internal pure returns (uint256) {
644         uint256 c = a + b;
645         require(c >= a, "SafeMath: addition overflow");
646 
647         return c;
648     }
649 
650     /**
651      * @dev Returns the subtraction of two unsigned integers, reverting on
652      * overflow (when the result is negative).
653      *
654      * Counterpart to Solidity's `-` operator.
655      *
656      * Requirements:
657      * - Subtraction cannot overflow.
658      */
659     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
660         require(b <= a, "SafeMath: subtraction overflow");
661         uint256 c = a - b;
662 
663         return c;
664     }
665 
666     /**
667      * @dev Returns the multiplication of two unsigned integers, reverting on
668      * overflow.
669      *
670      * Counterpart to Solidity's `*` operator.
671      *
672      * Requirements:
673      * - Multiplication cannot overflow.
674      */
675     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
676         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
677         // benefit is lost if 'b' is also tested.
678         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
679         if (a == 0) {
680             return 0;
681         }
682 
683         uint256 c = a * b;
684         require(c / a == b, "SafeMath: multiplication overflow");
685 
686         return c;
687     }
688 
689     /**
690      * @dev Returns the integer division of two unsigned integers. Reverts on
691      * division by zero. The result is rounded towards zero.
692      *
693      * Counterpart to Solidity's `/` operator. Note: this function uses a
694      * `revert` opcode (which leaves remaining gas untouched) while Solidity
695      * uses an invalid opcode to revert (consuming all remaining gas).
696      *
697      * Requirements:
698      * - The divisor cannot be zero.
699      */
700     function div(uint256 a, uint256 b) internal pure returns (uint256) {
701         // Solidity only automatically asserts when dividing by 0
702         require(b > 0, "SafeMath: division by zero");
703         uint256 c = a / b;
704         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
705 
706         return c;
707     }
708 
709     /**
710      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
711      * Reverts when dividing by zero.
712      *
713      * Counterpart to Solidity's `%` operator. This function uses a `revert`
714      * opcode (which leaves remaining gas untouched) while Solidity uses an
715      * invalid opcode to revert (consuming all remaining gas).
716      *
717      * Requirements:
718      * - The divisor cannot be zero.
719      */
720     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
721         require(b != 0, "SafeMath: modulo by zero");
722         return a % b;
723     }
724 }
725 
726 
727 // Libraries
728 
729 
730 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
731 library SafeDecimalMath {
732     using SafeMath for uint;
733 
734     /* Number of decimal places in the representations. */
735     uint8 public constant decimals = 18;
736     uint8 public constant highPrecisionDecimals = 27;
737 
738     /* The number representing 1.0. */
739     uint public constant UNIT = 10**uint(decimals);
740 
741     /* The number representing 1.0 for higher fidelity numbers. */
742     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
743     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
744 
745     /**
746      * @return Provides an interface to UNIT.
747      */
748     function unit() external pure returns (uint) {
749         return UNIT;
750     }
751 
752     /**
753      * @return Provides an interface to PRECISE_UNIT.
754      */
755     function preciseUnit() external pure returns (uint) {
756         return PRECISE_UNIT;
757     }
758 
759     /**
760      * @return The result of multiplying x and y, interpreting the operands as fixed-point
761      * decimals.
762      *
763      * @dev A unit factor is divided out after the product of x and y is evaluated,
764      * so that product must be less than 2**256. As this is an integer division,
765      * the internal division always rounds down. This helps save on gas. Rounding
766      * is more expensive on gas.
767      */
768     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
769         /* Divide by UNIT to remove the extra factor introduced by the product. */
770         return x.mul(y) / UNIT;
771     }
772 
773     /**
774      * @return The result of safely multiplying x and y, interpreting the operands
775      * as fixed-point decimals of the specified precision unit.
776      *
777      * @dev The operands should be in the form of a the specified unit factor which will be
778      * divided out after the product of x and y is evaluated, so that product must be
779      * less than 2**256.
780      *
781      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
782      * Rounding is useful when you need to retain fidelity for small decimal numbers
783      * (eg. small fractions or percentages).
784      */
785     function _multiplyDecimalRound(
786         uint x,
787         uint y,
788         uint precisionUnit
789     ) private pure returns (uint) {
790         /* Divide by UNIT to remove the extra factor introduced by the product. */
791         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
792 
793         if (quotientTimesTen % 10 >= 5) {
794             quotientTimesTen += 10;
795         }
796 
797         return quotientTimesTen / 10;
798     }
799 
800     /**
801      * @return The result of safely multiplying x and y, interpreting the operands
802      * as fixed-point decimals of a precise unit.
803      *
804      * @dev The operands should be in the precise unit factor which will be
805      * divided out after the product of x and y is evaluated, so that product must be
806      * less than 2**256.
807      *
808      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
809      * Rounding is useful when you need to retain fidelity for small decimal numbers
810      * (eg. small fractions or percentages).
811      */
812     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
813         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
814     }
815 
816     /**
817      * @return The result of safely multiplying x and y, interpreting the operands
818      * as fixed-point decimals of a standard unit.
819      *
820      * @dev The operands should be in the standard unit factor which will be
821      * divided out after the product of x and y is evaluated, so that product must be
822      * less than 2**256.
823      *
824      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
825      * Rounding is useful when you need to retain fidelity for small decimal numbers
826      * (eg. small fractions or percentages).
827      */
828     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
829         return _multiplyDecimalRound(x, y, UNIT);
830     }
831 
832     /**
833      * @return The result of safely dividing x and y. The return value is a high
834      * precision decimal.
835      *
836      * @dev y is divided after the product of x and the standard precision unit
837      * is evaluated, so the product of x and UNIT must be less than 2**256. As
838      * this is an integer division, the result is always rounded down.
839      * This helps save on gas. Rounding is more expensive on gas.
840      */
841     function divideDecimal(uint x, uint y) internal pure returns (uint) {
842         /* Reintroduce the UNIT factor that will be divided out by y. */
843         return x.mul(UNIT).div(y);
844     }
845 
846     /**
847      * @return The result of safely dividing x and y. The return value is as a rounded
848      * decimal in the precision unit specified in the parameter.
849      *
850      * @dev y is divided after the product of x and the specified precision unit
851      * is evaluated, so the product of x and the specified precision unit must
852      * be less than 2**256. The result is rounded to the nearest increment.
853      */
854     function _divideDecimalRound(
855         uint x,
856         uint y,
857         uint precisionUnit
858     ) private pure returns (uint) {
859         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
860 
861         if (resultTimesTen % 10 >= 5) {
862             resultTimesTen += 10;
863         }
864 
865         return resultTimesTen / 10;
866     }
867 
868     /**
869      * @return The result of safely dividing x and y. The return value is as a rounded
870      * standard precision decimal.
871      *
872      * @dev y is divided after the product of x and the standard precision unit
873      * is evaluated, so the product of x and the standard precision unit must
874      * be less than 2**256. The result is rounded to the nearest increment.
875      */
876     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
877         return _divideDecimalRound(x, y, UNIT);
878     }
879 
880     /**
881      * @return The result of safely dividing x and y. The return value is as a rounded
882      * high precision decimal.
883      *
884      * @dev y is divided after the product of x and the high precision unit
885      * is evaluated, so the product of x and the high precision unit must
886      * be less than 2**256. The result is rounded to the nearest increment.
887      */
888     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
889         return _divideDecimalRound(x, y, PRECISE_UNIT);
890     }
891 
892     /**
893      * @dev Convert a standard decimal representation to a high precision one.
894      */
895     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
896         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
897     }
898 
899     /**
900      * @dev Convert a high precision decimal to a standard decimal representation.
901      */
902     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
903         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
904 
905         if (quotientTimesTen % 10 >= 5) {
906             quotientTimesTen += 10;
907         }
908 
909         return quotientTimesTen / 10;
910     }
911 }
912 
913 
914 // Inheritance
915 
916 
917 // https://docs.synthetix.io/contracts/source/contracts/state
918 contract State is Owned {
919     // the address of the contract that can modify variables
920     // this can only be changed by the owner of this contract
921     address public associatedContract;
922 
923     constructor(address _associatedContract) internal {
924         // This contract is abstract, and thus cannot be instantiated directly
925         require(owner != address(0), "Owner must be set");
926 
927         associatedContract = _associatedContract;
928         emit AssociatedContractUpdated(_associatedContract);
929     }
930 
931     /* ========== SETTERS ========== */
932 
933     // Change the associated contract to a new address
934     function setAssociatedContract(address _associatedContract) external onlyOwner {
935         associatedContract = _associatedContract;
936         emit AssociatedContractUpdated(_associatedContract);
937     }
938 
939     /* ========== MODIFIERS ========== */
940 
941     modifier onlyAssociatedContract {
942         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
943         _;
944     }
945 
946     /* ========== EVENTS ========== */
947 
948     event AssociatedContractUpdated(address associatedContract);
949 }
950 
951 
952 // Inheritance
953 
954 
955 // https://docs.synthetix.io/contracts/source/contracts/eternalstorage
956 /**
957  * @notice  This contract is based on the code available from this blog
958  * https://blog.colony.io/writing-upgradeable-contracts-in-solidity-6743f0eecc88/
959  * Implements support for storing a keccak256 key and value pairs. It is the more flexible
960  * and extensible option. This ensures data schema changes can be implemented without
961  * requiring upgrades to the storage contract.
962  */
963 contract EternalStorage is Owned, State {
964     constructor(address _owner, address _associatedContract) public Owned(_owner) State(_associatedContract) {}
965 
966     /* ========== DATA TYPES ========== */
967     mapping(bytes32 => uint) internal UIntStorage;
968     mapping(bytes32 => string) internal StringStorage;
969     mapping(bytes32 => address) internal AddressStorage;
970     mapping(bytes32 => bytes) internal BytesStorage;
971     mapping(bytes32 => bytes32) internal Bytes32Storage;
972     mapping(bytes32 => bool) internal BooleanStorage;
973     mapping(bytes32 => int) internal IntStorage;
974 
975     // UIntStorage;
976     function getUIntValue(bytes32 record) external view returns (uint) {
977         return UIntStorage[record];
978     }
979 
980     function setUIntValue(bytes32 record, uint value) external onlyAssociatedContract {
981         UIntStorage[record] = value;
982     }
983 
984     function deleteUIntValue(bytes32 record) external onlyAssociatedContract {
985         delete UIntStorage[record];
986     }
987 
988     // StringStorage
989     function getStringValue(bytes32 record) external view returns (string memory) {
990         return StringStorage[record];
991     }
992 
993     function setStringValue(bytes32 record, string calldata value) external onlyAssociatedContract {
994         StringStorage[record] = value;
995     }
996 
997     function deleteStringValue(bytes32 record) external onlyAssociatedContract {
998         delete StringStorage[record];
999     }
1000 
1001     // AddressStorage
1002     function getAddressValue(bytes32 record) external view returns (address) {
1003         return AddressStorage[record];
1004     }
1005 
1006     function setAddressValue(bytes32 record, address value) external onlyAssociatedContract {
1007         AddressStorage[record] = value;
1008     }
1009 
1010     function deleteAddressValue(bytes32 record) external onlyAssociatedContract {
1011         delete AddressStorage[record];
1012     }
1013 
1014     // BytesStorage
1015     function getBytesValue(bytes32 record) external view returns (bytes memory) {
1016         return BytesStorage[record];
1017     }
1018 
1019     function setBytesValue(bytes32 record, bytes calldata value) external onlyAssociatedContract {
1020         BytesStorage[record] = value;
1021     }
1022 
1023     function deleteBytesValue(bytes32 record) external onlyAssociatedContract {
1024         delete BytesStorage[record];
1025     }
1026 
1027     // Bytes32Storage
1028     function getBytes32Value(bytes32 record) external view returns (bytes32) {
1029         return Bytes32Storage[record];
1030     }
1031 
1032     function setBytes32Value(bytes32 record, bytes32 value) external onlyAssociatedContract {
1033         Bytes32Storage[record] = value;
1034     }
1035 
1036     function deleteBytes32Value(bytes32 record) external onlyAssociatedContract {
1037         delete Bytes32Storage[record];
1038     }
1039 
1040     // BooleanStorage
1041     function getBooleanValue(bytes32 record) external view returns (bool) {
1042         return BooleanStorage[record];
1043     }
1044 
1045     function setBooleanValue(bytes32 record, bool value) external onlyAssociatedContract {
1046         BooleanStorage[record] = value;
1047     }
1048 
1049     function deleteBooleanValue(bytes32 record) external onlyAssociatedContract {
1050         delete BooleanStorage[record];
1051     }
1052 
1053     // IntStorage
1054     function getIntValue(bytes32 record) external view returns (int) {
1055         return IntStorage[record];
1056     }
1057 
1058     function setIntValue(bytes32 record, int value) external onlyAssociatedContract {
1059         IntStorage[record] = value;
1060     }
1061 
1062     function deleteIntValue(bytes32 record) external onlyAssociatedContract {
1063         delete IntStorage[record];
1064     }
1065 }
1066 
1067 
1068 interface IVirtualSynth {
1069     // Views
1070     function balanceOfUnderlying(address account) external view returns (uint);
1071 
1072     function rate() external view returns (uint);
1073 
1074     function readyToSettle() external view returns (bool);
1075 
1076     function secsLeftInWaitingPeriod() external view returns (uint);
1077 
1078     function settled() external view returns (bool);
1079 
1080     function synth() external view returns (ISynth);
1081 
1082     // Mutative functions
1083     function settle(address account) external;
1084 }
1085 
1086 
1087 // https://docs.synthetix.io/contracts/source/interfaces/isynthetix
1088 interface ISynthetix {
1089     // Views
1090     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
1091 
1092     function availableCurrencyKeys() external view returns (bytes32[] memory);
1093 
1094     function availableSynthCount() external view returns (uint);
1095 
1096     function availableSynths(uint index) external view returns (ISynth);
1097 
1098     function collateral(address account) external view returns (uint);
1099 
1100     function collateralisationRatio(address issuer) external view returns (uint);
1101 
1102     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
1103 
1104     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
1105 
1106     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
1107 
1108     function remainingIssuableSynths(address issuer)
1109         external
1110         view
1111         returns (
1112             uint maxIssuable,
1113             uint alreadyIssued,
1114             uint totalSystemDebt
1115         );
1116 
1117     function synths(bytes32 currencyKey) external view returns (ISynth);
1118 
1119     function synthsByAddress(address synthAddress) external view returns (bytes32);
1120 
1121     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
1122 
1123     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);
1124 
1125     function transferableSynthetix(address account) external view returns (uint transferable);
1126 
1127     // Mutative Functions
1128     function burnSynths(uint amount) external;
1129 
1130     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
1131 
1132     function burnSynthsToTarget() external;
1133 
1134     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
1135 
1136     function exchange(
1137         bytes32 sourceCurrencyKey,
1138         uint sourceAmount,
1139         bytes32 destinationCurrencyKey
1140     ) external returns (uint amountReceived);
1141 
1142     function exchangeOnBehalf(
1143         address exchangeForAddress,
1144         bytes32 sourceCurrencyKey,
1145         uint sourceAmount,
1146         bytes32 destinationCurrencyKey
1147     ) external returns (uint amountReceived);
1148 
1149     function exchangeWithTracking(
1150         bytes32 sourceCurrencyKey,
1151         uint sourceAmount,
1152         bytes32 destinationCurrencyKey,
1153         address originator,
1154         bytes32 trackingCode
1155     ) external returns (uint amountReceived);
1156 
1157     function exchangeOnBehalfWithTracking(
1158         address exchangeForAddress,
1159         bytes32 sourceCurrencyKey,
1160         uint sourceAmount,
1161         bytes32 destinationCurrencyKey,
1162         address originator,
1163         bytes32 trackingCode
1164     ) external returns (uint amountReceived);
1165 
1166     function exchangeWithVirtual(
1167         bytes32 sourceCurrencyKey,
1168         uint sourceAmount,
1169         bytes32 destinationCurrencyKey,
1170         bytes32 trackingCode
1171     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1172 
1173     function issueMaxSynths() external;
1174 
1175     function issueMaxSynthsOnBehalf(address issueForAddress) external;
1176 
1177     function issueSynths(uint amount) external;
1178 
1179     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
1180 
1181     function mint() external returns (bool);
1182 
1183     function settle(bytes32 currencyKey)
1184         external
1185         returns (
1186             uint reclaimed,
1187             uint refunded,
1188             uint numEntries
1189         );
1190 
1191     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
1192 
1193     // Restricted Functions
1194 
1195     function mintSecondary(address account, uint amount) external;
1196 
1197     function mintSecondaryRewards(uint amount) external;
1198 
1199     function burnSecondary(address account, uint amount) external;
1200 }
1201 
1202 
1203 // https://docs.synthetix.io/contracts/source/interfaces/iexchangerates
1204 interface IExchangeRates {
1205     // Structs
1206     struct RateAndUpdatedTime {
1207         uint216 rate;
1208         uint40 time;
1209     }
1210 
1211     struct InversePricing {
1212         uint entryPoint;
1213         uint upperLimit;
1214         uint lowerLimit;
1215         bool frozenAtUpperLimit;
1216         bool frozenAtLowerLimit;
1217     }
1218 
1219     // Views
1220     function aggregators(bytes32 currencyKey) external view returns (address);
1221 
1222     function aggregatorWarningFlags() external view returns (address);
1223 
1224     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1225 
1226     function canFreezeRate(bytes32 currencyKey) external view returns (bool);
1227 
1228     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
1229 
1230     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1231 
1232     function effectiveValue(
1233         bytes32 sourceCurrencyKey,
1234         uint sourceAmount,
1235         bytes32 destinationCurrencyKey
1236     ) external view returns (uint value);
1237 
1238     function effectiveValueAndRates(
1239         bytes32 sourceCurrencyKey,
1240         uint sourceAmount,
1241         bytes32 destinationCurrencyKey
1242     )
1243         external
1244         view
1245         returns (
1246             uint value,
1247             uint sourceRate,
1248             uint destinationRate
1249         );
1250 
1251     function effectiveValueAtRound(
1252         bytes32 sourceCurrencyKey,
1253         uint sourceAmount,
1254         bytes32 destinationCurrencyKey,
1255         uint roundIdForSrc,
1256         uint roundIdForDest
1257     ) external view returns (uint value);
1258 
1259     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1260 
1261     function getLastRoundIdBeforeElapsedSecs(
1262         bytes32 currencyKey,
1263         uint startingRoundId,
1264         uint startingTimestamp,
1265         uint timediff
1266     ) external view returns (uint);
1267 
1268     function inversePricing(bytes32 currencyKey)
1269         external
1270         view
1271         returns (
1272             uint entryPoint,
1273             uint upperLimit,
1274             uint lowerLimit,
1275             bool frozenAtUpperLimit,
1276             bool frozenAtLowerLimit
1277         );
1278 
1279     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1280 
1281     function oracle() external view returns (address);
1282 
1283     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1284 
1285     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1286 
1287     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1288 
1289     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1290 
1291     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1292 
1293     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
1294 
1295     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1296 
1297     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1298 
1299     function rateStalePeriod() external view returns (uint);
1300 
1301     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
1302         external
1303         view
1304         returns (uint[] memory rates, uint[] memory times);
1305 
1306     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1307         external
1308         view
1309         returns (uint[] memory rates, bool anyRateInvalid);
1310 
1311     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1312 
1313     // Mutative functions
1314     function freezeRate(bytes32 currencyKey) external;
1315 }
1316 
1317 
1318 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1319 interface ISystemStatus {
1320     struct Status {
1321         bool canSuspend;
1322         bool canResume;
1323     }
1324 
1325     struct Suspension {
1326         bool suspended;
1327         // reason is an integer code,
1328         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1329         uint248 reason;
1330     }
1331 
1332     // Views
1333     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1334 
1335     function requireSystemActive() external view;
1336 
1337     function requireIssuanceActive() external view;
1338 
1339     function requireExchangeActive() external view;
1340 
1341     function requireSynthActive(bytes32 currencyKey) external view;
1342 
1343     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1344 
1345     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1346 
1347     // Restricted functions
1348     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1349 
1350     function updateAccessControl(
1351         bytes32 section,
1352         address account,
1353         bool canSuspend,
1354         bool canResume
1355     ) external;
1356 }
1357 
1358 
1359 // Inheritance
1360 
1361 
1362 // Libraries
1363 
1364 
1365 // Internal references
1366 
1367 
1368 // https://docs.synthetix.io/contracts/source/contracts/liquidations
1369 contract Liquidations is Owned, MixinSystemSettings, ILiquidations {
1370     using SafeMath for uint;
1371     using SafeDecimalMath for uint;
1372 
1373     struct LiquidationEntry {
1374         uint deadline;
1375         address caller;
1376     }
1377 
1378     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1379 
1380     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1381     bytes32 private constant CONTRACT_SYNTHETIX = "Synthetix";
1382     bytes32 private constant CONTRACT_ETERNALSTORAGE_LIQUIDATIONS = "EternalStorageLiquidations";
1383     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1384     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1385 
1386     /* ========== CONSTANTS ========== */
1387 
1388     // Storage keys
1389     bytes32 public constant LIQUIDATION_DEADLINE = "LiquidationDeadline";
1390     bytes32 public constant LIQUIDATION_CALLER = "LiquidationCaller";
1391 
1392     constructor(address _owner, address _resolver) public Owned(_owner) MixinSystemSettings(_resolver) {}
1393 
1394     /* ========== VIEWS ========== */
1395     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1396         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1397         bytes32[] memory newAddresses = new bytes32[](5);
1398         newAddresses[0] = CONTRACT_SYSTEMSTATUS;
1399         newAddresses[1] = CONTRACT_SYNTHETIX;
1400         newAddresses[2] = CONTRACT_ETERNALSTORAGE_LIQUIDATIONS;
1401         newAddresses[3] = CONTRACT_ISSUER;
1402         newAddresses[4] = CONTRACT_EXRATES;
1403         addresses = combineArrays(existingAddresses, newAddresses);
1404     }
1405 
1406     function synthetix() internal view returns (ISynthetix) {
1407         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX));
1408     }
1409 
1410     function systemStatus() internal view returns (ISystemStatus) {
1411         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1412     }
1413 
1414     function issuer() internal view returns (IIssuer) {
1415         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1416     }
1417 
1418     function exchangeRates() internal view returns (IExchangeRates) {
1419         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES));
1420     }
1421 
1422     // refactor to synthetix storage eternal storage contract once that's ready
1423     function eternalStorageLiquidations() internal view returns (EternalStorage) {
1424         return EternalStorage(requireAndGetAddress(CONTRACT_ETERNALSTORAGE_LIQUIDATIONS));
1425     }
1426 
1427     function issuanceRatio() external view returns (uint) {
1428         return getIssuanceRatio();
1429     }
1430 
1431     function liquidationDelay() external view returns (uint) {
1432         return getLiquidationDelay();
1433     }
1434 
1435     function liquidationRatio() external view returns (uint) {
1436         return getLiquidationRatio();
1437     }
1438 
1439     function liquidationPenalty() external view returns (uint) {
1440         return getLiquidationPenalty();
1441     }
1442 
1443     function liquidationCollateralRatio() external view returns (uint) {
1444         return SafeDecimalMath.unit().divideDecimalRound(getLiquidationRatio());
1445     }
1446 
1447     function getLiquidationDeadlineForAccount(address account) external view returns (uint) {
1448         LiquidationEntry memory liquidation = _getLiquidationEntryForAccount(account);
1449         return liquidation.deadline;
1450     }
1451 
1452     function isOpenForLiquidation(address account) external view returns (bool) {
1453         uint accountCollateralisationRatio = synthetix().collateralisationRatio(account);
1454 
1455         // Liquidation closed if collateral ratio less than or equal target issuance Ratio
1456         // Account with no snx collateral will also not be open for liquidation (ratio is 0)
1457         if (accountCollateralisationRatio <= getIssuanceRatio()) {
1458             return false;
1459         }
1460 
1461         LiquidationEntry memory liquidation = _getLiquidationEntryForAccount(account);
1462 
1463         // liquidation cap at issuanceRatio is checked above
1464         if (_deadlinePassed(liquidation.deadline)) {
1465             return true;
1466         }
1467         return false;
1468     }
1469 
1470     function isLiquidationDeadlinePassed(address account) external view returns (bool) {
1471         LiquidationEntry memory liquidation = _getLiquidationEntryForAccount(account);
1472         return _deadlinePassed(liquidation.deadline);
1473     }
1474 
1475     function _deadlinePassed(uint deadline) internal view returns (bool) {
1476         // check deadline is set > 0
1477         // check now > deadline
1478         return deadline > 0 && now > deadline;
1479     }
1480 
1481     /**
1482      * r = target issuance ratio
1483      * D = debt balance
1484      * V = Collateral
1485      * P = liquidation penalty
1486      * Calculates amount of synths = (D - V * r) / (1 - (1 + P) * r)
1487      */
1488     function calculateAmountToFixCollateral(uint debtBalance, uint collateral) external view returns (uint) {
1489         uint ratio = getIssuanceRatio();
1490         uint unit = SafeDecimalMath.unit();
1491 
1492         uint dividend = debtBalance.sub(collateral.multiplyDecimal(ratio));
1493         uint divisor = unit.sub(unit.add(getLiquidationPenalty()).multiplyDecimal(ratio));
1494 
1495         return dividend.divideDecimal(divisor);
1496     }
1497 
1498     // get liquidationEntry for account
1499     // returns deadline = 0 when not set
1500     function _getLiquidationEntryForAccount(address account) internal view returns (LiquidationEntry memory _liquidation) {
1501         _liquidation.deadline = eternalStorageLiquidations().getUIntValue(_getKey(LIQUIDATION_DEADLINE, account));
1502 
1503         // liquidation caller not used
1504         _liquidation.caller = address(0);
1505     }
1506 
1507     function _getKey(bytes32 _scope, address _account) internal pure returns (bytes32) {
1508         return keccak256(abi.encodePacked(_scope, _account));
1509     }
1510 
1511     /* ========== MUTATIVE FUNCTIONS ========== */
1512 
1513     // totalIssuedSynths checks synths for staleness
1514     // check snx rate is not stale
1515     function flagAccountForLiquidation(address account) external rateNotInvalid("SNX") {
1516         systemStatus().requireSystemActive();
1517 
1518         require(getLiquidationRatio() > 0, "Liquidation ratio not set");
1519         require(getLiquidationDelay() > 0, "Liquidation delay not set");
1520 
1521         LiquidationEntry memory liquidation = _getLiquidationEntryForAccount(account);
1522         require(liquidation.deadline == 0, "Account already flagged for liquidation");
1523 
1524         uint accountsCollateralisationRatio = synthetix().collateralisationRatio(account);
1525 
1526         // if accounts issuance ratio is greater than or equal to liquidation ratio set liquidation entry
1527         require(
1528             accountsCollateralisationRatio >= getLiquidationRatio(),
1529             "Account issuance ratio is less than liquidation ratio"
1530         );
1531 
1532         uint deadline = now.add(getLiquidationDelay());
1533 
1534         _storeLiquidationEntry(account, deadline, msg.sender);
1535 
1536         emit AccountFlaggedForLiquidation(account, deadline);
1537     }
1538 
1539     // Internal function to remove account from liquidations
1540     // Does not check collateral ratio is fixed
1541     function removeAccountInLiquidation(address account) external onlyIssuer {
1542         LiquidationEntry memory liquidation = _getLiquidationEntryForAccount(account);
1543         if (liquidation.deadline > 0) {
1544             _removeLiquidationEntry(account);
1545         }
1546     }
1547 
1548     // Public function to allow an account to remove from liquidations
1549     // Checks collateral ratio is fixed - below target issuance ratio
1550     // Check SNX rate is not stale
1551     function checkAndRemoveAccountInLiquidation(address account) external rateNotInvalid("SNX") {
1552         systemStatus().requireSystemActive();
1553 
1554         LiquidationEntry memory liquidation = _getLiquidationEntryForAccount(account);
1555 
1556         require(liquidation.deadline > 0, "Account has no liquidation set");
1557 
1558         uint accountsCollateralisationRatio = synthetix().collateralisationRatio(account);
1559 
1560         // Remove from liquidations if accountsCollateralisationRatio is fixed (less than equal target issuance ratio)
1561         if (accountsCollateralisationRatio <= getIssuanceRatio()) {
1562             _removeLiquidationEntry(account);
1563         }
1564     }
1565 
1566     function _storeLiquidationEntry(
1567         address _account,
1568         uint _deadline,
1569         address _caller
1570     ) internal {
1571         // record liquidation deadline
1572         eternalStorageLiquidations().setUIntValue(_getKey(LIQUIDATION_DEADLINE, _account), _deadline);
1573         eternalStorageLiquidations().setAddressValue(_getKey(LIQUIDATION_CALLER, _account), _caller);
1574     }
1575 
1576     function _removeLiquidationEntry(address _account) internal {
1577         // delete liquidation deadline
1578         eternalStorageLiquidations().deleteUIntValue(_getKey(LIQUIDATION_DEADLINE, _account));
1579         // delete liquidation caller
1580         eternalStorageLiquidations().deleteAddressValue(_getKey(LIQUIDATION_CALLER, _account));
1581 
1582         emit AccountRemovedFromLiquidation(_account, now);
1583     }
1584 
1585     /* ========== MODIFIERS ========== */
1586     modifier onlyIssuer() {
1587         require(msg.sender == address(issuer()), "Liquidations: Only the Issuer contract can perform this action");
1588         _;
1589     }
1590 
1591     modifier rateNotInvalid(bytes32 currencyKey) {
1592         require(!exchangeRates().rateIsInvalid(currencyKey), "Rate invalid or not a synth");
1593         _;
1594     }
1595 
1596     /* ========== EVENTS ========== */
1597 
1598     event AccountFlaggedForLiquidation(address indexed account, uint deadline);
1599     event AccountRemovedFromLiquidation(address indexed account, uint time);
1600 }
1601 
1602     