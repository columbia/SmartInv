1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: CollateralShort.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/CollateralShort.sol
11 * Docs: https://docs.synthetix.io/contracts/CollateralShort
12 *
13 * Contract Dependencies: 
14 *	- Collateral
15 *	- IAddressResolver
16 *	- ICollateralLoan
17 *	- MixinResolver
18 *	- MixinSystemSettings
19 *	- Owned
20 *	- State
21 * Libraries: 
22 *	- SafeDecimalMath
23 *	- SafeMath
24 *
25 * MIT License
26 * ===========
27 *
28 * Copyright (c) 2021 Synthetix
29 *
30 * Permission is hereby granted, free of charge, to any person obtaining a copy
31 * of this software and associated documentation files (the "Software"), to deal
32 * in the Software without restriction, including without limitation the rights
33 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
34 * copies of the Software, and to permit persons to whom the Software is
35 * furnished to do so, subject to the following conditions:
36 *
37 * The above copyright notice and this permission notice shall be included in all
38 * copies or substantial portions of the Software.
39 *
40 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
41 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
42 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
43 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
44 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
45 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
46 */
47 
48 
49 
50 pragma solidity ^0.5.16;
51 
52 
53 // https://docs.synthetix.io/contracts/source/contracts/owned
54 contract Owned {
55     address public owner;
56     address public nominatedOwner;
57 
58     constructor(address _owner) public {
59         require(_owner != address(0), "Owner address cannot be 0");
60         owner = _owner;
61         emit OwnerChanged(address(0), _owner);
62     }
63 
64     function nominateNewOwner(address _owner) external onlyOwner {
65         nominatedOwner = _owner;
66         emit OwnerNominated(_owner);
67     }
68 
69     function acceptOwnership() external {
70         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
71         emit OwnerChanged(owner, nominatedOwner);
72         owner = nominatedOwner;
73         nominatedOwner = address(0);
74     }
75 
76     modifier onlyOwner {
77         _onlyOwner();
78         _;
79     }
80 
81     function _onlyOwner() private view {
82         require(msg.sender == owner, "Only the contract owner may perform this action");
83     }
84 
85     event OwnerNominated(address newOwner);
86     event OwnerChanged(address oldOwner, address newOwner);
87 }
88 
89 
90 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
91 interface IAddressResolver {
92     function getAddress(bytes32 name) external view returns (address);
93 
94     function getSynth(bytes32 key) external view returns (address);
95 
96     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
97 }
98 
99 
100 // https://docs.synthetix.io/contracts/source/interfaces/isynth
101 interface ISynth {
102     // Views
103     function currencyKey() external view returns (bytes32);
104 
105     function transferableSynths(address account) external view returns (uint);
106 
107     // Mutative functions
108     function transferAndSettle(address to, uint value) external returns (bool);
109 
110     function transferFromAndSettle(
111         address from,
112         address to,
113         uint value
114     ) external returns (bool);
115 
116     // Restricted: used internally to Synthetix
117     function burn(address account, uint amount) external;
118 
119     function issue(address account, uint amount) external;
120 }
121 
122 
123 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
124 interface IIssuer {
125     // Views
126     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
127 
128     function availableCurrencyKeys() external view returns (bytes32[] memory);
129 
130     function availableSynthCount() external view returns (uint);
131 
132     function availableSynths(uint index) external view returns (ISynth);
133 
134     function canBurnSynths(address account) external view returns (bool);
135 
136     function collateral(address account) external view returns (uint);
137 
138     function collateralisationRatio(address issuer) external view returns (uint);
139 
140     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
141         external
142         view
143         returns (uint cratio, bool anyRateIsInvalid);
144 
145     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
146 
147     function issuanceRatio() external view returns (uint);
148 
149     function lastIssueEvent(address account) external view returns (uint);
150 
151     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
152 
153     function minimumStakeTime() external view returns (uint);
154 
155     function remainingIssuableSynths(address issuer)
156         external
157         view
158         returns (
159             uint maxIssuable,
160             uint alreadyIssued,
161             uint totalSystemDebt
162         );
163 
164     function synths(bytes32 currencyKey) external view returns (ISynth);
165 
166     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
167 
168     function synthsByAddress(address synthAddress) external view returns (bytes32);
169 
170     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
171 
172     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
173         external
174         view
175         returns (uint transferable, bool anyRateIsInvalid);
176 
177     // Restricted: used internally to Synthetix
178     function issueSynths(address from, uint amount) external;
179 
180     function issueSynthsOnBehalf(
181         address issueFor,
182         address from,
183         uint amount
184     ) external;
185 
186     function issueMaxSynths(address from) external;
187 
188     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
189 
190     function burnSynths(address from, uint amount) external;
191 
192     function burnSynthsOnBehalf(
193         address burnForAddress,
194         address from,
195         uint amount
196     ) external;
197 
198     function burnSynthsToTarget(address from) external;
199 
200     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
201 
202     function liquidateDelinquentAccount(
203         address account,
204         uint susdAmount,
205         address liquidator
206     ) external returns (uint totalRedeemed, uint amountToLiquidate);
207 }
208 
209 
210 // Inheritance
211 
212 
213 // Internal references
214 
215 
216 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
217 contract AddressResolver is Owned, IAddressResolver {
218     mapping(bytes32 => address) public repository;
219 
220     constructor(address _owner) public Owned(_owner) {}
221 
222     /* ========== RESTRICTED FUNCTIONS ========== */
223 
224     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
225         require(names.length == destinations.length, "Input lengths must match");
226 
227         for (uint i = 0; i < names.length; i++) {
228             bytes32 name = names[i];
229             address destination = destinations[i];
230             repository[name] = destination;
231             emit AddressImported(name, destination);
232         }
233     }
234 
235     /* ========= PUBLIC FUNCTIONS ========== */
236 
237     function rebuildCaches(MixinResolver[] calldata destinations) external {
238         for (uint i = 0; i < destinations.length; i++) {
239             destinations[i].rebuildCache();
240         }
241     }
242 
243     /* ========== VIEWS ========== */
244 
245     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
246         for (uint i = 0; i < names.length; i++) {
247             if (repository[names[i]] != destinations[i]) {
248                 return false;
249             }
250         }
251         return true;
252     }
253 
254     function getAddress(bytes32 name) external view returns (address) {
255         return repository[name];
256     }
257 
258     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
259         address _foundAddress = repository[name];
260         require(_foundAddress != address(0), reason);
261         return _foundAddress;
262     }
263 
264     function getSynth(bytes32 key) external view returns (address) {
265         IIssuer issuer = IIssuer(repository["Issuer"]);
266         require(address(issuer) != address(0), "Cannot find Issuer address");
267         return address(issuer.synths(key));
268     }
269 
270     /* ========== EVENTS ========== */
271 
272     event AddressImported(bytes32 name, address destination);
273 }
274 
275 
276 // solhint-disable payable-fallback
277 
278 // https://docs.synthetix.io/contracts/source/contracts/readproxy
279 contract ReadProxy is Owned {
280     address public target;
281 
282     constructor(address _owner) public Owned(_owner) {}
283 
284     function setTarget(address _target) external onlyOwner {
285         target = _target;
286         emit TargetUpdated(target);
287     }
288 
289     function() external {
290         // The basics of a proxy read call
291         // Note that msg.sender in the underlying will always be the address of this contract.
292         assembly {
293             calldatacopy(0, 0, calldatasize)
294 
295             // Use of staticcall - this will revert if the underlying function mutates state
296             let result := staticcall(gas, sload(target_slot), 0, calldatasize, 0, 0)
297             returndatacopy(0, 0, returndatasize)
298 
299             if iszero(result) {
300                 revert(0, returndatasize)
301             }
302             return(0, returndatasize)
303         }
304     }
305 
306     event TargetUpdated(address newTarget);
307 }
308 
309 
310 // Inheritance
311 
312 
313 // Internal references
314 
315 
316 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
317 contract MixinResolver {
318     AddressResolver public resolver;
319 
320     mapping(bytes32 => address) private addressCache;
321 
322     constructor(address _resolver) internal {
323         resolver = AddressResolver(_resolver);
324     }
325 
326     /* ========== INTERNAL FUNCTIONS ========== */
327 
328     function combineArrays(bytes32[] memory first, bytes32[] memory second)
329         internal
330         pure
331         returns (bytes32[] memory combination)
332     {
333         combination = new bytes32[](first.length + second.length);
334 
335         for (uint i = 0; i < first.length; i++) {
336             combination[i] = first[i];
337         }
338 
339         for (uint j = 0; j < second.length; j++) {
340             combination[first.length + j] = second[j];
341         }
342     }
343 
344     /* ========== PUBLIC FUNCTIONS ========== */
345 
346     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
347     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
348 
349     function rebuildCache() public {
350         bytes32[] memory requiredAddresses = resolverAddressesRequired();
351         // The resolver must call this function whenver it updates its state
352         for (uint i = 0; i < requiredAddresses.length; i++) {
353             bytes32 name = requiredAddresses[i];
354             // Note: can only be invoked once the resolver has all the targets needed added
355             address destination = resolver.requireAndGetAddress(
356                 name,
357                 string(abi.encodePacked("Resolver missing target: ", name))
358             );
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
615 
616 interface ICollateralLoan {
617     struct Loan {
618         // ID for the loan
619         uint id;
620         //  Acccount that created the loan
621         address payable account;
622         //  Amount of collateral deposited
623         uint collateral;
624         // The synth that was borowed
625         bytes32 currency;
626         //  Amount of synths borrowed
627         uint amount;
628         // Indicates if the position was short sold
629         bool short;
630         // interest amounts accrued
631         uint accruedInterest;
632         // last interest index
633         uint interestIndex;
634         // time of last interaction.
635         uint lastInteraction;
636     }
637 }
638 
639 
640 /**
641  * @dev Wrappers over Solidity's arithmetic operations with added overflow
642  * checks.
643  *
644  * Arithmetic operations in Solidity wrap on overflow. This can easily result
645  * in bugs, because programmers usually assume that an overflow raises an
646  * error, which is the standard behavior in high level programming languages.
647  * `SafeMath` restores this intuition by reverting the transaction when an
648  * operation overflows.
649  *
650  * Using this library instead of the unchecked operations eliminates an entire
651  * class of bugs, so it's recommended to use it always.
652  */
653 library SafeMath {
654     /**
655      * @dev Returns the addition of two unsigned integers, reverting on
656      * overflow.
657      *
658      * Counterpart to Solidity's `+` operator.
659      *
660      * Requirements:
661      * - Addition cannot overflow.
662      */
663     function add(uint256 a, uint256 b) internal pure returns (uint256) {
664         uint256 c = a + b;
665         require(c >= a, "SafeMath: addition overflow");
666 
667         return c;
668     }
669 
670     /**
671      * @dev Returns the subtraction of two unsigned integers, reverting on
672      * overflow (when the result is negative).
673      *
674      * Counterpart to Solidity's `-` operator.
675      *
676      * Requirements:
677      * - Subtraction cannot overflow.
678      */
679     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
680         require(b <= a, "SafeMath: subtraction overflow");
681         uint256 c = a - b;
682 
683         return c;
684     }
685 
686     /**
687      * @dev Returns the multiplication of two unsigned integers, reverting on
688      * overflow.
689      *
690      * Counterpart to Solidity's `*` operator.
691      *
692      * Requirements:
693      * - Multiplication cannot overflow.
694      */
695     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
696         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
697         // benefit is lost if 'b' is also tested.
698         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
699         if (a == 0) {
700             return 0;
701         }
702 
703         uint256 c = a * b;
704         require(c / a == b, "SafeMath: multiplication overflow");
705 
706         return c;
707     }
708 
709     /**
710      * @dev Returns the integer division of two unsigned integers. Reverts on
711      * division by zero. The result is rounded towards zero.
712      *
713      * Counterpart to Solidity's `/` operator. Note: this function uses a
714      * `revert` opcode (which leaves remaining gas untouched) while Solidity
715      * uses an invalid opcode to revert (consuming all remaining gas).
716      *
717      * Requirements:
718      * - The divisor cannot be zero.
719      */
720     function div(uint256 a, uint256 b) internal pure returns (uint256) {
721         // Solidity only automatically asserts when dividing by 0
722         require(b > 0, "SafeMath: division by zero");
723         uint256 c = a / b;
724         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
725 
726         return c;
727     }
728 
729     /**
730      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
731      * Reverts when dividing by zero.
732      *
733      * Counterpart to Solidity's `%` operator. This function uses a `revert`
734      * opcode (which leaves remaining gas untouched) while Solidity uses an
735      * invalid opcode to revert (consuming all remaining gas).
736      *
737      * Requirements:
738      * - The divisor cannot be zero.
739      */
740     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
741         require(b != 0, "SafeMath: modulo by zero");
742         return a % b;
743     }
744 }
745 
746 
747 // Libraries
748 
749 
750 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
751 library SafeDecimalMath {
752     using SafeMath for uint;
753 
754     /* Number of decimal places in the representations. */
755     uint8 public constant decimals = 18;
756     uint8 public constant highPrecisionDecimals = 27;
757 
758     /* The number representing 1.0. */
759     uint public constant UNIT = 10**uint(decimals);
760 
761     /* The number representing 1.0 for higher fidelity numbers. */
762     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
763     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
764 
765     /**
766      * @return Provides an interface to UNIT.
767      */
768     function unit() external pure returns (uint) {
769         return UNIT;
770     }
771 
772     /**
773      * @return Provides an interface to PRECISE_UNIT.
774      */
775     function preciseUnit() external pure returns (uint) {
776         return PRECISE_UNIT;
777     }
778 
779     /**
780      * @return The result of multiplying x and y, interpreting the operands as fixed-point
781      * decimals.
782      *
783      * @dev A unit factor is divided out after the product of x and y is evaluated,
784      * so that product must be less than 2**256. As this is an integer division,
785      * the internal division always rounds down. This helps save on gas. Rounding
786      * is more expensive on gas.
787      */
788     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
789         /* Divide by UNIT to remove the extra factor introduced by the product. */
790         return x.mul(y) / UNIT;
791     }
792 
793     /**
794      * @return The result of safely multiplying x and y, interpreting the operands
795      * as fixed-point decimals of the specified precision unit.
796      *
797      * @dev The operands should be in the form of a the specified unit factor which will be
798      * divided out after the product of x and y is evaluated, so that product must be
799      * less than 2**256.
800      *
801      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
802      * Rounding is useful when you need to retain fidelity for small decimal numbers
803      * (eg. small fractions or percentages).
804      */
805     function _multiplyDecimalRound(
806         uint x,
807         uint y,
808         uint precisionUnit
809     ) private pure returns (uint) {
810         /* Divide by UNIT to remove the extra factor introduced by the product. */
811         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
812 
813         if (quotientTimesTen % 10 >= 5) {
814             quotientTimesTen += 10;
815         }
816 
817         return quotientTimesTen / 10;
818     }
819 
820     /**
821      * @return The result of safely multiplying x and y, interpreting the operands
822      * as fixed-point decimals of a precise unit.
823      *
824      * @dev The operands should be in the precise unit factor which will be
825      * divided out after the product of x and y is evaluated, so that product must be
826      * less than 2**256.
827      *
828      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
829      * Rounding is useful when you need to retain fidelity for small decimal numbers
830      * (eg. small fractions or percentages).
831      */
832     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
833         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
834     }
835 
836     /**
837      * @return The result of safely multiplying x and y, interpreting the operands
838      * as fixed-point decimals of a standard unit.
839      *
840      * @dev The operands should be in the standard unit factor which will be
841      * divided out after the product of x and y is evaluated, so that product must be
842      * less than 2**256.
843      *
844      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
845      * Rounding is useful when you need to retain fidelity for small decimal numbers
846      * (eg. small fractions or percentages).
847      */
848     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
849         return _multiplyDecimalRound(x, y, UNIT);
850     }
851 
852     /**
853      * @return The result of safely dividing x and y. The return value is a high
854      * precision decimal.
855      *
856      * @dev y is divided after the product of x and the standard precision unit
857      * is evaluated, so the product of x and UNIT must be less than 2**256. As
858      * this is an integer division, the result is always rounded down.
859      * This helps save on gas. Rounding is more expensive on gas.
860      */
861     function divideDecimal(uint x, uint y) internal pure returns (uint) {
862         /* Reintroduce the UNIT factor that will be divided out by y. */
863         return x.mul(UNIT).div(y);
864     }
865 
866     /**
867      * @return The result of safely dividing x and y. The return value is as a rounded
868      * decimal in the precision unit specified in the parameter.
869      *
870      * @dev y is divided after the product of x and the specified precision unit
871      * is evaluated, so the product of x and the specified precision unit must
872      * be less than 2**256. The result is rounded to the nearest increment.
873      */
874     function _divideDecimalRound(
875         uint x,
876         uint y,
877         uint precisionUnit
878     ) private pure returns (uint) {
879         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
880 
881         if (resultTimesTen % 10 >= 5) {
882             resultTimesTen += 10;
883         }
884 
885         return resultTimesTen / 10;
886     }
887 
888     /**
889      * @return The result of safely dividing x and y. The return value is as a rounded
890      * standard precision decimal.
891      *
892      * @dev y is divided after the product of x and the standard precision unit
893      * is evaluated, so the product of x and the standard precision unit must
894      * be less than 2**256. The result is rounded to the nearest increment.
895      */
896     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
897         return _divideDecimalRound(x, y, UNIT);
898     }
899 
900     /**
901      * @return The result of safely dividing x and y. The return value is as a rounded
902      * high precision decimal.
903      *
904      * @dev y is divided after the product of x and the high precision unit
905      * is evaluated, so the product of x and the high precision unit must
906      * be less than 2**256. The result is rounded to the nearest increment.
907      */
908     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
909         return _divideDecimalRound(x, y, PRECISE_UNIT);
910     }
911 
912     /**
913      * @dev Convert a standard decimal representation to a high precision one.
914      */
915     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
916         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
917     }
918 
919     /**
920      * @dev Convert a high precision decimal to a standard decimal representation.
921      */
922     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
923         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
924 
925         if (quotientTimesTen % 10 >= 5) {
926             quotientTimesTen += 10;
927         }
928 
929         return quotientTimesTen / 10;
930     }
931 }
932 
933 
934 // Inheritance
935 
936 
937 // https://docs.synthetix.io/contracts/source/contracts/state
938 contract State is Owned {
939     // the address of the contract that can modify variables
940     // this can only be changed by the owner of this contract
941     address public associatedContract;
942 
943     constructor(address _associatedContract) internal {
944         // This contract is abstract, and thus cannot be instantiated directly
945         require(owner != address(0), "Owner must be set");
946 
947         associatedContract = _associatedContract;
948         emit AssociatedContractUpdated(_associatedContract);
949     }
950 
951     /* ========== SETTERS ========== */
952 
953     // Change the associated contract to a new address
954     function setAssociatedContract(address _associatedContract) external onlyOwner {
955         associatedContract = _associatedContract;
956         emit AssociatedContractUpdated(_associatedContract);
957     }
958 
959     /* ========== MODIFIERS ========== */
960 
961     modifier onlyAssociatedContract {
962         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
963         _;
964     }
965 
966     /* ========== EVENTS ========== */
967 
968     event AssociatedContractUpdated(address associatedContract);
969 }
970 
971 
972 // Inheritance
973 
974 
975 // Libraries
976 
977 
978 contract CollateralState is Owned, State, ICollateralLoan {
979     using SafeMath for uint;
980     using SafeDecimalMath for uint;
981 
982     mapping(address => Loan[]) public loans;
983 
984     constructor(address _owner, address _associatedContract) public Owned(_owner) State(_associatedContract) {}
985 
986     /* ========== VIEWS ========== */
987     // If we do not find the loan, this returns a struct with 0'd values.
988     function getLoan(address account, uint256 loanID) external view returns (Loan memory) {
989         Loan[] memory accountLoans = loans[account];
990         for (uint i = 0; i < accountLoans.length; i++) {
991             if (accountLoans[i].id == loanID) {
992                 return (accountLoans[i]);
993             }
994         }
995     }
996 
997     function getNumLoans(address account) external view returns (uint numLoans) {
998         return loans[account].length;
999     }
1000 
1001     /* ========== MUTATIVE FUNCTIONS ========== */
1002 
1003     function createLoan(Loan memory loan) public onlyAssociatedContract {
1004         loans[loan.account].push(loan);
1005     }
1006 
1007     function updateLoan(Loan memory loan) public onlyAssociatedContract {
1008         Loan[] storage accountLoans = loans[loan.account];
1009         for (uint i = 0; i < accountLoans.length; i++) {
1010             if (accountLoans[i].id == loan.id) {
1011                 loans[loan.account][i] = loan;
1012             }
1013         }
1014     }
1015 }
1016 
1017 
1018 interface ICollateralManager {
1019     // Manager information
1020     function hasCollateral(address collateral) external view returns (bool);
1021 
1022     function isSynthManaged(bytes32 currencyKey) external view returns (bool);
1023 
1024     // State information
1025     function long(bytes32 synth) external view returns (uint amount);
1026 
1027     function short(bytes32 synth) external view returns (uint amount);
1028 
1029     function totalLong() external view returns (uint susdValue, bool anyRateIsInvalid);
1030 
1031     function totalShort() external view returns (uint susdValue, bool anyRateIsInvalid);
1032 
1033     function getBorrowRate() external view returns (uint borrowRate, bool anyRateIsInvalid);
1034 
1035     function getShortRate(bytes32 synth) external view returns (uint shortRate, bool rateIsInvalid);
1036 
1037     function getRatesAndTime(uint index)
1038         external
1039         view
1040         returns (
1041             uint entryRate,
1042             uint lastRate,
1043             uint lastUpdated,
1044             uint newIndex
1045         );
1046 
1047     function getShortRatesAndTime(bytes32 currency, uint index)
1048         external
1049         view
1050         returns (
1051             uint entryRate,
1052             uint lastRate,
1053             uint lastUpdated,
1054             uint newIndex
1055         );
1056 
1057     function exceedsDebtLimit(uint amount, bytes32 currency) external view returns (bool canIssue, bool anyRateIsInvalid);
1058 
1059     function areSynthsAndCurrenciesSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1060         external
1061         view
1062         returns (bool);
1063 
1064     function areShortableSynthsSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1065         external
1066         view
1067         returns (bool);
1068 
1069     // Loans
1070     function getNewLoanId() external returns (uint id);
1071 
1072     // Manager mutative
1073     function addCollaterals(address[] calldata collaterals) external;
1074 
1075     function removeCollaterals(address[] calldata collaterals) external;
1076 
1077     function addSynths(bytes32[] calldata synthNamesInResolver, bytes32[] calldata synthKeys) external;
1078 
1079     function removeSynths(bytes32[] calldata synths, bytes32[] calldata synthKeys) external;
1080 
1081     function addShortableSynths(bytes32[2][] calldata requiredSynthAndInverseNamesInResolver, bytes32[] calldata synthKeys)
1082         external;
1083 
1084     function removeShortableSynths(bytes32[] calldata synths) external;
1085 
1086     // State mutative
1087     function updateBorrowRates(uint rate) external;
1088 
1089     function updateShortRates(bytes32 currency, uint rate) external;
1090 
1091     function incrementLongs(bytes32 synth, uint amount) external;
1092 
1093     function decrementLongs(bytes32 synth, uint amount) external;
1094 
1095     function incrementShorts(bytes32 synth, uint amount) external;
1096 
1097     function decrementShorts(bytes32 synth, uint amount) external;
1098 }
1099 
1100 
1101 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1102 interface ISystemStatus {
1103     struct Status {
1104         bool canSuspend;
1105         bool canResume;
1106     }
1107 
1108     struct Suspension {
1109         bool suspended;
1110         // reason is an integer code,
1111         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1112         uint248 reason;
1113     }
1114 
1115     // Views
1116     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1117 
1118     function requireSystemActive() external view;
1119 
1120     function requireIssuanceActive() external view;
1121 
1122     function requireExchangeActive() external view;
1123 
1124     function requireSynthActive(bytes32 currencyKey) external view;
1125 
1126     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1127 
1128     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1129 
1130     // Restricted functions
1131     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1132 
1133     function updateAccessControl(
1134         bytes32 section,
1135         address account,
1136         bool canSuspend,
1137         bool canResume
1138     ) external;
1139 }
1140 
1141 
1142 // https://docs.synthetix.io/contracts/source/interfaces/ifeepool
1143 interface IFeePool {
1144     // Views
1145 
1146     // solhint-disable-next-line func-name-mixedcase
1147     function FEE_ADDRESS() external view returns (address);
1148 
1149     function feesAvailable(address account) external view returns (uint, uint);
1150 
1151     function feePeriodDuration() external view returns (uint);
1152 
1153     function isFeesClaimable(address account) external view returns (bool);
1154 
1155     function targetThreshold() external view returns (uint);
1156 
1157     function totalFeesAvailable() external view returns (uint);
1158 
1159     function totalRewardsAvailable() external view returns (uint);
1160 
1161     // Mutative Functions
1162     function claimFees() external returns (bool);
1163 
1164     function claimOnBehalf(address claimingForAddress) external returns (bool);
1165 
1166     function closeCurrentFeePeriod() external;
1167 
1168     // Restricted: used internally to Synthetix
1169     function appendAccountIssuanceRecord(
1170         address account,
1171         uint lockedAmount,
1172         uint debtEntryIndex
1173     ) external;
1174 
1175     function recordFeePaid(uint sUSDAmount) external;
1176 
1177     function setRewardsToDistribute(uint amount) external;
1178 }
1179 
1180 
1181 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
1182 interface IERC20 {
1183     // ERC20 Optional Views
1184     function name() external view returns (string memory);
1185 
1186     function symbol() external view returns (string memory);
1187 
1188     function decimals() external view returns (uint8);
1189 
1190     // Views
1191     function totalSupply() external view returns (uint);
1192 
1193     function balanceOf(address owner) external view returns (uint);
1194 
1195     function allowance(address owner, address spender) external view returns (uint);
1196 
1197     // Mutative functions
1198     function transfer(address to, uint value) external returns (bool);
1199 
1200     function approve(address spender, uint value) external returns (bool);
1201 
1202     function transferFrom(
1203         address from,
1204         address to,
1205         uint value
1206     ) external returns (bool);
1207 
1208     // Events
1209     event Transfer(address indexed from, address indexed to, uint value);
1210 
1211     event Approval(address indexed owner, address indexed spender, uint value);
1212 }
1213 
1214 
1215 // https://docs.synthetix.io/contracts/source/interfaces/iexchangerates
1216 interface IExchangeRates {
1217     // Structs
1218     struct RateAndUpdatedTime {
1219         uint216 rate;
1220         uint40 time;
1221     }
1222 
1223     struct InversePricing {
1224         uint entryPoint;
1225         uint upperLimit;
1226         uint lowerLimit;
1227         bool frozenAtUpperLimit;
1228         bool frozenAtLowerLimit;
1229     }
1230 
1231     // Views
1232     function aggregators(bytes32 currencyKey) external view returns (address);
1233 
1234     function aggregatorWarningFlags() external view returns (address);
1235 
1236     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1237 
1238     function canFreezeRate(bytes32 currencyKey) external view returns (bool);
1239 
1240     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
1241 
1242     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1243 
1244     function effectiveValue(
1245         bytes32 sourceCurrencyKey,
1246         uint sourceAmount,
1247         bytes32 destinationCurrencyKey
1248     ) external view returns (uint value);
1249 
1250     function effectiveValueAndRates(
1251         bytes32 sourceCurrencyKey,
1252         uint sourceAmount,
1253         bytes32 destinationCurrencyKey
1254     )
1255         external
1256         view
1257         returns (
1258             uint value,
1259             uint sourceRate,
1260             uint destinationRate
1261         );
1262 
1263     function effectiveValueAtRound(
1264         bytes32 sourceCurrencyKey,
1265         uint sourceAmount,
1266         bytes32 destinationCurrencyKey,
1267         uint roundIdForSrc,
1268         uint roundIdForDest
1269     ) external view returns (uint value);
1270 
1271     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1272 
1273     function getLastRoundIdBeforeElapsedSecs(
1274         bytes32 currencyKey,
1275         uint startingRoundId,
1276         uint startingTimestamp,
1277         uint timediff
1278     ) external view returns (uint);
1279 
1280     function inversePricing(bytes32 currencyKey)
1281         external
1282         view
1283         returns (
1284             uint entryPoint,
1285             uint upperLimit,
1286             uint lowerLimit,
1287             bool frozenAtUpperLimit,
1288             bool frozenAtLowerLimit
1289         );
1290 
1291     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1292 
1293     function oracle() external view returns (address);
1294 
1295     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1296 
1297     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1298 
1299     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1300 
1301     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1302 
1303     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1304 
1305     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
1306 
1307     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1308 
1309     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1310 
1311     function rateStalePeriod() external view returns (uint);
1312 
1313     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
1314         external
1315         view
1316         returns (uint[] memory rates, uint[] memory times);
1317 
1318     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1319         external
1320         view
1321         returns (uint[] memory rates, bool anyRateInvalid);
1322 
1323     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1324 
1325     // Mutative functions
1326     function freezeRate(bytes32 currencyKey) external;
1327 }
1328 
1329 
1330 interface IVirtualSynth {
1331     // Views
1332     function balanceOfUnderlying(address account) external view returns (uint);
1333 
1334     function rate() external view returns (uint);
1335 
1336     function readyToSettle() external view returns (bool);
1337 
1338     function secsLeftInWaitingPeriod() external view returns (uint);
1339 
1340     function settled() external view returns (bool);
1341 
1342     function synth() external view returns (ISynth);
1343 
1344     // Mutative functions
1345     function settle(address account) external;
1346 }
1347 
1348 
1349 // https://docs.synthetix.io/contracts/source/interfaces/iexchanger
1350 interface IExchanger {
1351     // Views
1352     function calculateAmountAfterSettlement(
1353         address from,
1354         bytes32 currencyKey,
1355         uint amount,
1356         uint refunded
1357     ) external view returns (uint amountAfterSettlement);
1358 
1359     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
1360 
1361     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
1362 
1363     function settlementOwing(address account, bytes32 currencyKey)
1364         external
1365         view
1366         returns (
1367             uint reclaimAmount,
1368             uint rebateAmount,
1369             uint numEntries
1370         );
1371 
1372     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
1373 
1374     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
1375         external
1376         view
1377         returns (uint exchangeFeeRate);
1378 
1379     function getAmountsForExchange(
1380         uint sourceAmount,
1381         bytes32 sourceCurrencyKey,
1382         bytes32 destinationCurrencyKey
1383     )
1384         external
1385         view
1386         returns (
1387             uint amountReceived,
1388             uint fee,
1389             uint exchangeFeeRate
1390         );
1391 
1392     function priceDeviationThresholdFactor() external view returns (uint);
1393 
1394     function waitingPeriodSecs() external view returns (uint);
1395 
1396     // Mutative functions
1397     function exchange(
1398         address from,
1399         bytes32 sourceCurrencyKey,
1400         uint sourceAmount,
1401         bytes32 destinationCurrencyKey,
1402         address destinationAddress
1403     ) external returns (uint amountReceived);
1404 
1405     function exchangeOnBehalf(
1406         address exchangeForAddress,
1407         address from,
1408         bytes32 sourceCurrencyKey,
1409         uint sourceAmount,
1410         bytes32 destinationCurrencyKey
1411     ) external returns (uint amountReceived);
1412 
1413     function exchangeWithTracking(
1414         address from,
1415         bytes32 sourceCurrencyKey,
1416         uint sourceAmount,
1417         bytes32 destinationCurrencyKey,
1418         address destinationAddress,
1419         address originator,
1420         bytes32 trackingCode
1421     ) external returns (uint amountReceived);
1422 
1423     function exchangeOnBehalfWithTracking(
1424         address exchangeForAddress,
1425         address from,
1426         bytes32 sourceCurrencyKey,
1427         uint sourceAmount,
1428         bytes32 destinationCurrencyKey,
1429         address originator,
1430         bytes32 trackingCode
1431     ) external returns (uint amountReceived);
1432 
1433     function exchangeWithVirtual(
1434         address from,
1435         bytes32 sourceCurrencyKey,
1436         uint sourceAmount,
1437         bytes32 destinationCurrencyKey,
1438         address destinationAddress,
1439         bytes32 trackingCode
1440     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1441 
1442     function settle(address from, bytes32 currencyKey)
1443         external
1444         returns (
1445             uint reclaimed,
1446             uint refunded,
1447             uint numEntries
1448         );
1449 
1450     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external;
1451 
1452     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
1453 }
1454 
1455 
1456 // https://docs.synthetix.io/contracts/source/interfaces/istakingrewards
1457 interface IShortingRewards {
1458     // Views
1459     function lastTimeRewardApplicable() external view returns (uint256);
1460 
1461     function rewardPerToken() external view returns (uint256);
1462 
1463     function earned(address account) external view returns (uint256);
1464 
1465     function getRewardForDuration() external view returns (uint256);
1466 
1467     function totalSupply() external view returns (uint256);
1468 
1469     function balanceOf(address account) external view returns (uint256);
1470 
1471     // Mutative
1472 
1473     function enrol(address account, uint256 amount) external;
1474 
1475     function withdraw(address account, uint256 amount) external;
1476 
1477     function getReward(address account) external;
1478 
1479     function exit(address account) external;
1480 }
1481 
1482 
1483 // Inheritance
1484 
1485 
1486 // Libraries
1487 
1488 
1489 // Internal references
1490 
1491 
1492 contract Collateral is ICollateralLoan, Owned, MixinSystemSettings {
1493     /* ========== LIBRARIES ========== */
1494     using SafeMath for uint;
1495     using SafeDecimalMath for uint;
1496 
1497     /* ========== CONSTANTS ========== */
1498 
1499     bytes32 private constant sUSD = "sUSD";
1500 
1501     // ========== STATE VARIABLES ==========
1502 
1503     // The synth corresponding to the collateral.
1504     bytes32 public collateralKey;
1505 
1506     // Stores loans
1507     CollateralState public state;
1508 
1509     address public manager;
1510 
1511     // The synths that this contract can issue.
1512     bytes32[] public synths;
1513 
1514     // Map from currency key to synth contract name.
1515     mapping(bytes32 => bytes32) public synthsByKey;
1516 
1517     // Map from currency key to the shorting rewards contract
1518     mapping(bytes32 => address) public shortingRewards;
1519 
1520     // ========== SETTER STATE VARIABLES ==========
1521 
1522     // The minimum collateral ratio required to avoid liquidation.
1523     uint public minCratio;
1524 
1525     // The minimum amount of collateral to create a loan.
1526     uint public minCollateral;
1527 
1528     // The fee charged for issuing a loan.
1529     uint public issueFeeRate;
1530 
1531     // The maximum number of loans that an account can create with this collateral.
1532     uint public maxLoansPerAccount = 50;
1533 
1534     // Time in seconds that a user must wait between interacting with a loan.
1535     // Provides front running and flash loan protection.
1536     uint public interactionDelay = 300;
1537 
1538     bool public canOpenLoans = true;
1539 
1540     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1541 
1542     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1543     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1544     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1545     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1546     bytes32 private constant CONTRACT_SYNTHSUSD = "SynthsUSD";
1547 
1548     /* ========== CONSTRUCTOR ========== */
1549 
1550     constructor(
1551         CollateralState _state,
1552         address _owner,
1553         address _manager,
1554         address _resolver,
1555         bytes32 _collateralKey,
1556         uint _minCratio,
1557         uint _minCollateral
1558     ) public Owned(_owner) MixinSystemSettings(_resolver) {
1559         manager = _manager;
1560         state = _state;
1561         collateralKey = _collateralKey;
1562         minCratio = _minCratio;
1563         minCollateral = _minCollateral;
1564     }
1565 
1566     /* ========== VIEWS ========== */
1567 
1568     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1569         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1570         bytes32[] memory newAddresses = new bytes32[](5);
1571         newAddresses[0] = CONTRACT_FEEPOOL;
1572         newAddresses[1] = CONTRACT_EXRATES;
1573         newAddresses[2] = CONTRACT_EXCHANGER;
1574         newAddresses[3] = CONTRACT_SYSTEMSTATUS;
1575         newAddresses[4] = CONTRACT_SYNTHSUSD;
1576 
1577         bytes32[] memory combined = combineArrays(existingAddresses, newAddresses);
1578 
1579         addresses = combineArrays(combined, synths);
1580     }
1581 
1582     /* ---------- Related Contracts ---------- */
1583 
1584     function _systemStatus() internal view returns (ISystemStatus) {
1585         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1586     }
1587 
1588     function _synth(bytes32 synthName) internal view returns (ISynth) {
1589         return ISynth(requireAndGetAddress(synthName));
1590     }
1591 
1592     function _synthsUSD() internal view returns (ISynth) {
1593         return ISynth(requireAndGetAddress(CONTRACT_SYNTHSUSD));
1594     }
1595 
1596     function _exchangeRates() internal view returns (IExchangeRates) {
1597         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES));
1598     }
1599 
1600     function _exchanger() internal view returns (IExchanger) {
1601         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER));
1602     }
1603 
1604     function _feePool() internal view returns (IFeePool) {
1605         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL));
1606     }
1607 
1608     function _manager() internal view returns (ICollateralManager) {
1609         return ICollateralManager(manager);
1610     }
1611 
1612     /* ---------- Public Views ---------- */
1613 
1614     function collateralRatio(Loan memory loan) public view returns (uint cratio) {
1615         uint cvalue = _exchangeRates().effectiveValue(collateralKey, loan.collateral, sUSD);
1616         uint dvalue = _exchangeRates().effectiveValue(loan.currency, loan.amount.add(loan.accruedInterest), sUSD);
1617         cratio = cvalue.divideDecimal(dvalue);
1618     }
1619 
1620     // The maximum number of synths issuable for this amount of collateral
1621     function maxLoan(uint amount, bytes32 currency) public view returns (uint max) {
1622         max = issuanceRatio().multiplyDecimal(_exchangeRates().effectiveValue(collateralKey, amount, currency));
1623     }
1624 
1625     /**
1626      * r = target issuance ratio
1627      * D = debt value in sUSD
1628      * V = collateral value in sUSD
1629      * P = liquidation penalty
1630      * Calculates amount of synths = (D - V * r) / (1 - (1 + P) * r)
1631      * Note: if you pass a loan in here that is not eligible for liquidation it will revert.
1632      * We check the ratio first in liquidateInternal and only pass eligible loans in.
1633      */
1634     function liquidationAmount(Loan memory loan) public view returns (uint amount) {
1635         uint liquidationPenalty = getLiquidationPenalty();
1636         uint debtValue = _exchangeRates().effectiveValue(loan.currency, loan.amount.add(loan.accruedInterest), sUSD);
1637         uint collateralValue = _exchangeRates().effectiveValue(collateralKey, loan.collateral, sUSD);
1638         uint unit = SafeDecimalMath.unit();
1639 
1640         uint dividend = debtValue.sub(collateralValue.divideDecimal(minCratio));
1641         uint divisor = unit.sub(unit.add(liquidationPenalty).divideDecimal(minCratio));
1642 
1643         uint sUSDamount = dividend.divideDecimal(divisor);
1644 
1645         return _exchangeRates().effectiveValue(sUSD, sUSDamount, loan.currency);
1646     }
1647 
1648     // amount is the amount of synths we are liquidating
1649     function collateralRedeemed(bytes32 currency, uint amount) public view returns (uint collateral) {
1650         uint liquidationPenalty = getLiquidationPenalty();
1651         collateral = _exchangeRates().effectiveValue(currency, amount, collateralKey);
1652 
1653         collateral = collateral.multiplyDecimal(SafeDecimalMath.unit().add(liquidationPenalty));
1654     }
1655 
1656     function areSynthsAndCurrenciesSet(bytes32[] calldata _synthNamesInResolver, bytes32[] calldata _synthKeys)
1657         external
1658         view
1659         returns (bool)
1660     {
1661         if (synths.length != _synthNamesInResolver.length) {
1662             return false;
1663         }
1664 
1665         for (uint i = 0; i < _synthNamesInResolver.length; i++) {
1666             bytes32 synthName = _synthNamesInResolver[i];
1667             if (synths[i] != synthName) {
1668                 return false;
1669             }
1670             if (synthsByKey[_synthKeys[i]] != synths[i]) {
1671                 return false;
1672             }
1673         }
1674 
1675         return true;
1676     }
1677 
1678     /* ---------- UTILITIES ---------- */
1679 
1680     // Check the account has enough of the synth to make the payment
1681     function _checkSynthBalance(
1682         address payer,
1683         bytes32 key,
1684         uint amount
1685     ) internal view {
1686         require(IERC20(address(_synth(synthsByKey[key]))).balanceOf(payer) >= amount, "Not enough synth balance");
1687     }
1688 
1689     // We set the interest index to 0 to indicate the loan has been closed.
1690     function _checkLoanAvailable(Loan memory _loan) internal view {
1691         require(_loan.interestIndex > 0, "Loan does not exist");
1692         require(_loan.lastInteraction.add(interactionDelay) <= block.timestamp, "Loan recently interacted with");
1693     }
1694 
1695     function issuanceRatio() internal view returns (uint ratio) {
1696         ratio = SafeDecimalMath.unit().divideDecimalRound(minCratio);
1697     }
1698 
1699     /* ========== MUTATIVE FUNCTIONS ========== */
1700 
1701     /* ---------- Synths ---------- */
1702 
1703     function addSynths(bytes32[] calldata _synthNamesInResolver, bytes32[] calldata _synthKeys) external onlyOwner {
1704         require(_synthNamesInResolver.length == _synthKeys.length, "Input array length mismatch");
1705 
1706         for (uint i = 0; i < _synthNamesInResolver.length; i++) {
1707             bytes32 synthName = _synthNamesInResolver[i];
1708             synths.push(synthName);
1709             synthsByKey[_synthKeys[i]] = synthName;
1710         }
1711 
1712         // ensure cache has the latest
1713         rebuildCache();
1714     }
1715 
1716     /* ---------- Rewards Contracts ---------- */
1717 
1718     function addRewardsContracts(address rewardsContract, bytes32 synth) external onlyOwner {
1719         shortingRewards[synth] = rewardsContract;
1720     }
1721 
1722     /* ---------- SETTERS ---------- */
1723 
1724     function setMinCratio(uint _minCratio) external onlyOwner {
1725         require(_minCratio > SafeDecimalMath.unit(), "Must be greater than 1");
1726         minCratio = _minCratio;
1727         emit MinCratioRatioUpdated(minCratio);
1728     }
1729 
1730     function setIssueFeeRate(uint _issueFeeRate) external onlyOwner {
1731         issueFeeRate = _issueFeeRate;
1732         emit IssueFeeRateUpdated(issueFeeRate);
1733     }
1734 
1735     function setInteractionDelay(uint _interactionDelay) external onlyOwner {
1736         require(_interactionDelay <= SafeDecimalMath.unit() * 3600, "Max 1 hour");
1737         interactionDelay = _interactionDelay;
1738         emit InteractionDelayUpdated(interactionDelay);
1739     }
1740 
1741     function setManager(address _newManager) external onlyOwner {
1742         manager = _newManager;
1743         emit ManagerUpdated(manager);
1744     }
1745 
1746     function setCanOpenLoans(bool _canOpenLoans) external onlyOwner {
1747         canOpenLoans = _canOpenLoans;
1748         emit CanOpenLoansUpdated(canOpenLoans);
1749     }
1750 
1751     /* ---------- LOAN INTERACTIONS ---------- */
1752 
1753     function openInternal(
1754         uint collateral,
1755         uint amount,
1756         bytes32 currency,
1757         bool short
1758     ) internal returns (uint id) {
1759         // 0. Check the system is active.
1760         _systemStatus().requireIssuanceActive();
1761 
1762         require(canOpenLoans, "Opening is disabled");
1763 
1764         // 1. Make sure the collateral rate is valid.
1765         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
1766 
1767         // 2. We can only issue certain synths.
1768         require(synthsByKey[currency] > 0, "Not allowed to issue this synth");
1769 
1770         // 3. Make sure the synth rate is not invalid.
1771         require(!_exchangeRates().rateIsInvalid(currency), "Currency rate is invalid");
1772 
1773         // 4. Collateral >= minimum collateral size.
1774         require(collateral >= minCollateral, "Not enough collateral to open");
1775 
1776         // 5. Cap the number of loans so that the array doesn't get too big.
1777         require(state.getNumLoans(msg.sender) < maxLoansPerAccount, "Max loans exceeded");
1778 
1779         // 6. Check we haven't hit the debt cap for non snx collateral.
1780         (bool canIssue, bool anyRateIsInvalid) = _manager().exceedsDebtLimit(amount, currency);
1781 
1782         require(canIssue && !anyRateIsInvalid, "Debt limit or invalid rate");
1783 
1784         // 7. Require requested loan < max loan
1785         require(amount <= maxLoan(collateral, currency), "Exceeds max borrowing power");
1786 
1787         // 8. This fee is denominated in the currency of the loan
1788         uint issueFee = amount.multiplyDecimalRound(issueFeeRate);
1789 
1790         // 9. Calculate the minting fee and subtract it from the loan amount
1791         uint loanAmountMinusFee = amount.sub(issueFee);
1792 
1793         // 10. Get a Loan ID
1794         id = _manager().getNewLoanId();
1795 
1796         // 11. Create the loan struct.
1797         Loan memory loan = Loan({
1798             id: id,
1799             account: msg.sender,
1800             collateral: collateral,
1801             currency: currency,
1802             amount: amount,
1803             short: short,
1804             accruedInterest: 0,
1805             interestIndex: 0,
1806             lastInteraction: block.timestamp
1807         });
1808 
1809         // 12. Accrue interest on the loan.
1810         loan = accrueInterest(loan);
1811 
1812         // 13. Save the loan to storage
1813         state.createLoan(loan);
1814 
1815         // 14. Pay the minting fees to the fee pool
1816         _payFees(issueFee, currency);
1817 
1818         // 15. If its short, convert back to sUSD, otherwise issue the loan.
1819         if (short) {
1820             _synthsUSD().issue(msg.sender, _exchangeRates().effectiveValue(currency, loanAmountMinusFee, sUSD));
1821             _manager().incrementShorts(currency, amount);
1822 
1823             if (shortingRewards[currency] != address(0)) {
1824                 IShortingRewards(shortingRewards[currency]).enrol(msg.sender, amount);
1825             }
1826         } else {
1827             _synth(synthsByKey[currency]).issue(msg.sender, loanAmountMinusFee);
1828             _manager().incrementLongs(currency, amount);
1829         }
1830 
1831         // 16. Emit event
1832         emit LoanCreated(msg.sender, id, amount, collateral, currency, issueFee);
1833     }
1834 
1835     function closeInternal(address borrower, uint id) internal returns (uint collateral) {
1836         // 0. Check the system is active.
1837         _systemStatus().requireIssuanceActive();
1838 
1839         // 1. Make sure the collateral rate is valid
1840         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
1841 
1842         // 2. Get the loan.
1843         Loan memory loan = state.getLoan(borrower, id);
1844 
1845         // 3. Check loan is open and the last interaction time.
1846         _checkLoanAvailable(loan);
1847 
1848         // 4. Accrue interest on the loan.
1849         loan = accrueInterest(loan);
1850 
1851         // 5. Work out the total amount owing on the loan.
1852         uint total = loan.amount.add(loan.accruedInterest);
1853 
1854         // 6. Check they have enough balance to close the loan.
1855         _checkSynthBalance(loan.account, loan.currency, total);
1856 
1857         // 7. Burn the synths
1858         require(
1859             !_exchanger().hasWaitingPeriodOrSettlementOwing(borrower, loan.currency),
1860             "Waiting secs or settlement owing"
1861         );
1862         _synth(synthsByKey[loan.currency]).burn(borrower, total);
1863 
1864         // 8. Tell the manager.
1865         if (loan.short) {
1866             _manager().decrementShorts(loan.currency, loan.amount);
1867 
1868             if (shortingRewards[loan.currency] != address(0)) {
1869                 IShortingRewards(shortingRewards[loan.currency]).withdraw(borrower, loan.amount);
1870             }
1871         } else {
1872             _manager().decrementLongs(loan.currency, loan.amount);
1873         }
1874 
1875         // 9. Assign the collateral to be returned.
1876         collateral = loan.collateral;
1877 
1878         // 10. Pay fees
1879         _payFees(loan.accruedInterest, loan.currency);
1880 
1881         // 11. Record loan as closed
1882         loan.amount = 0;
1883         loan.collateral = 0;
1884         loan.accruedInterest = 0;
1885         loan.interestIndex = 0;
1886         loan.lastInteraction = block.timestamp;
1887         state.updateLoan(loan);
1888 
1889         // 12. Emit the event
1890         emit LoanClosed(borrower, id);
1891     }
1892 
1893     function closeByLiquidationInternal(
1894         address borrower,
1895         address liquidator,
1896         Loan memory loan
1897     ) internal returns (uint collateral) {
1898         // 1. Work out the total amount owing on the loan.
1899         uint total = loan.amount.add(loan.accruedInterest);
1900 
1901         // 2. Store this for the event.
1902         uint amount = loan.amount;
1903 
1904         // 3. Return collateral to the child class so it knows how much to transfer.
1905         collateral = loan.collateral;
1906 
1907         // 4. Burn the synths
1908         require(!_exchanger().hasWaitingPeriodOrSettlementOwing(liquidator, loan.currency), "Waiting or settlement owing");
1909         _synth(synthsByKey[loan.currency]).burn(liquidator, total);
1910 
1911         // 5. Tell the manager.
1912         if (loan.short) {
1913             _manager().decrementShorts(loan.currency, loan.amount);
1914 
1915             if (shortingRewards[loan.currency] != address(0)) {
1916                 IShortingRewards(shortingRewards[loan.currency]).withdraw(borrower, loan.amount);
1917             }
1918         } else {
1919             _manager().decrementLongs(loan.currency, loan.amount);
1920         }
1921 
1922         // 6. Pay fees
1923         _payFees(loan.accruedInterest, loan.currency);
1924 
1925         // 7. Record loan as closed
1926         loan.amount = 0;
1927         loan.collateral = 0;
1928         loan.accruedInterest = 0;
1929         loan.interestIndex = 0;
1930         loan.lastInteraction = block.timestamp;
1931         state.updateLoan(loan);
1932 
1933         // 8. Emit the event.
1934         emit LoanClosedByLiquidation(borrower, loan.id, liquidator, amount, collateral);
1935     }
1936 
1937     function depositInternal(
1938         address account,
1939         uint id,
1940         uint amount
1941     ) internal {
1942         // 0. Check the system is active.
1943         _systemStatus().requireIssuanceActive();
1944 
1945         // 1. Make sure the collateral rate is valid.
1946         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
1947 
1948         // 2. They sent some value > 0
1949         require(amount > 0, "Deposit must be greater than 0");
1950 
1951         // 3. Get the loan
1952         Loan memory loan = state.getLoan(account, id);
1953 
1954         // 4. Check loan is open and last interaction time.
1955         _checkLoanAvailable(loan);
1956 
1957         // 5. Accrue interest
1958         loan = accrueInterest(loan);
1959 
1960         // 6. Add the collateral
1961         loan.collateral = loan.collateral.add(amount);
1962 
1963         // 7. Update the last interaction time.
1964         loan.lastInteraction = block.timestamp;
1965 
1966         // 8. Store the loan
1967         state.updateLoan(loan);
1968 
1969         // 9. Emit the event
1970         emit CollateralDeposited(account, id, amount, loan.collateral);
1971     }
1972 
1973     function withdrawInternal(uint id, uint amount) internal returns (uint withdraw) {
1974         // 0. Check the system is active.
1975         _systemStatus().requireIssuanceActive();
1976 
1977         // 1. Make sure the collateral rate is valid.
1978         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
1979 
1980         // 2. Get the loan.
1981         Loan memory loan = state.getLoan(msg.sender, id);
1982 
1983         // 3. Check loan is open and last interaction time.
1984         _checkLoanAvailable(loan);
1985 
1986         // 4. Accrue interest.
1987         loan = accrueInterest(loan);
1988 
1989         // 5. Subtract the collateral.
1990         loan.collateral = loan.collateral.sub(amount);
1991 
1992         // 6. Update the last interaction time.
1993         loan.lastInteraction = block.timestamp;
1994 
1995         // 7. Check that the new amount does not put them under the minimum c ratio.
1996         require(collateralRatio(loan) > minCratio, "Cratio too low");
1997 
1998         // 8. Store the loan.
1999         state.updateLoan(loan);
2000 
2001         // 9. Assign the return variable.
2002         withdraw = amount;
2003 
2004         // 10. Emit the event.
2005         emit CollateralWithdrawn(msg.sender, id, amount, loan.collateral);
2006     }
2007 
2008     function liquidateInternal(
2009         address borrower,
2010         uint id,
2011         uint payment
2012     ) internal returns (uint collateralLiquidated) {
2013         // 0. Check the system is active.
2014         _systemStatus().requireIssuanceActive();
2015 
2016         // 1. Make sure the collateral rate is valid.
2017         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
2018 
2019         // 2. Check the payment amount.
2020         require(payment > 0, "Payment must be greater than 0");
2021 
2022         // 3. Get the loan.
2023         Loan memory loan = state.getLoan(borrower, id);
2024 
2025         // 4. Check loan is open and last interaction time.
2026         _checkLoanAvailable(loan);
2027 
2028         // 5. Accrue interest.
2029         loan = accrueInterest(loan);
2030 
2031         // 6. Check they have enough balance to make the payment.
2032         _checkSynthBalance(msg.sender, loan.currency, payment);
2033 
2034         // 7. Check they are eligible for liquidation.
2035         require(collateralRatio(loan) < minCratio, "Cratio above liquidation ratio");
2036 
2037         // 8. Determine how much needs to be liquidated to fix their c ratio.
2038         uint liqAmount = liquidationAmount(loan);
2039 
2040         // 9. Only allow them to liquidate enough to fix the c ratio.
2041         uint amountToLiquidate = liqAmount < payment ? liqAmount : payment;
2042 
2043         // 10. Work out the total amount owing on the loan.
2044         uint amountOwing = loan.amount.add(loan.accruedInterest);
2045 
2046         // 11. If its greater than the amount owing, we need to close the loan.
2047         if (amountToLiquidate >= amountOwing) {
2048             return closeByLiquidationInternal(borrower, msg.sender, loan);
2049         }
2050 
2051         // 12. Process the payment to workout interest/principal split.
2052         loan = _processPayment(loan, amountToLiquidate);
2053 
2054         // 13. Work out how much collateral to redeem.
2055         collateralLiquidated = collateralRedeemed(loan.currency, amountToLiquidate);
2056         loan.collateral = loan.collateral.sub(collateralLiquidated);
2057 
2058         // 14. Update the last interaction time.
2059         loan.lastInteraction = block.timestamp;
2060 
2061         // 15. Burn the synths from the liquidator.
2062         require(!_exchanger().hasWaitingPeriodOrSettlementOwing(msg.sender, loan.currency), "Waiting or settlement owing");
2063         _synth(synthsByKey[loan.currency]).burn(msg.sender, amountToLiquidate);
2064 
2065         // 16. Store the loan.
2066         state.updateLoan(loan);
2067 
2068         // 17. Emit the event
2069         emit LoanPartiallyLiquidated(borrower, id, msg.sender, amountToLiquidate, collateralLiquidated);
2070     }
2071 
2072     function repayInternal(
2073         address borrower,
2074         address repayer,
2075         uint id,
2076         uint payment
2077     ) internal {
2078         // 0. Check the system is active.
2079         _systemStatus().requireIssuanceActive();
2080 
2081         // 1. Make sure the collateral rate is valid.
2082         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
2083 
2084         // 2. Check the payment amount.
2085         require(payment > 0, "Payment must be greater than 0");
2086 
2087         // 3. Get loan
2088         Loan memory loan = state.getLoan(borrower, id);
2089 
2090         // 4. Check loan is open and last interaction time.
2091         _checkLoanAvailable(loan);
2092 
2093         // 5. Accrue interest.
2094         loan = accrueInterest(loan);
2095 
2096         // 6. Check the spender has enough synths to make the repayment
2097         _checkSynthBalance(repayer, loan.currency, payment);
2098 
2099         // 7. Process the payment.
2100         loan = _processPayment(loan, payment);
2101 
2102         // 8. Update the last interaction time.
2103         loan.lastInteraction = block.timestamp;
2104 
2105         // 9. Burn synths from the payer
2106         require(!_exchanger().hasWaitingPeriodOrSettlementOwing(repayer, loan.currency), "Waiting or settlement owing");
2107         _synth(synthsByKey[loan.currency]).burn(repayer, payment);
2108 
2109         // 10. Store the loan
2110         state.updateLoan(loan);
2111 
2112         // 11. Emit the event.
2113         emit LoanRepaymentMade(borrower, repayer, id, payment, loan.amount);
2114     }
2115 
2116     function drawInternal(uint id, uint amount) internal {
2117         // 0. Check the system is active.
2118         _systemStatus().requireIssuanceActive();
2119 
2120         // 1. Make sure the collateral rate is valid.
2121         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
2122 
2123         // 2. Get loan.
2124         Loan memory loan = state.getLoan(msg.sender, id);
2125 
2126         // 3. Check loan is open and last interaction time.
2127         _checkLoanAvailable(loan);
2128 
2129         // 4. Accrue interest.
2130         loan = accrueInterest(loan);
2131 
2132         // 5. Add the requested amount.
2133         loan.amount = loan.amount.add(amount);
2134 
2135         // 6. If it is below the minimum, don't allow this draw.
2136         require(collateralRatio(loan) > minCratio, "Cannot draw this much");
2137 
2138         // 7. This fee is denominated in the currency of the loan
2139         uint issueFee = amount.multiplyDecimalRound(issueFeeRate);
2140 
2141         // 8. Calculate the minting fee and subtract it from the draw amount
2142         uint amountMinusFee = amount.sub(issueFee);
2143 
2144         // 9. If its short, let the child handle it, otherwise issue the synths.
2145         if (loan.short) {
2146             _manager().incrementShorts(loan.currency, amount);
2147             _synthsUSD().issue(msg.sender, _exchangeRates().effectiveValue(loan.currency, amountMinusFee, sUSD));
2148 
2149             if (shortingRewards[loan.currency] != address(0)) {
2150                 IShortingRewards(shortingRewards[loan.currency]).enrol(msg.sender, amount);
2151             }
2152         } else {
2153             _manager().incrementLongs(loan.currency, amount);
2154             _synth(synthsByKey[loan.currency]).issue(msg.sender, amountMinusFee);
2155         }
2156 
2157         // 10. Pay the minting fees to the fee pool
2158         _payFees(issueFee, loan.currency);
2159 
2160         // 11. Update the last interaction time.
2161         loan.lastInteraction = block.timestamp;
2162 
2163         // 12. Store the loan
2164         state.updateLoan(loan);
2165 
2166         // 13. Emit the event.
2167         emit LoanDrawnDown(msg.sender, id, amount);
2168     }
2169 
2170     // Update the cumulative interest rate for the currency that was interacted with.
2171     function accrueInterest(Loan memory loan) internal returns (Loan memory loanAfter) {
2172         loanAfter = loan;
2173 
2174         // 1. Get the rates we need.
2175         (uint entryRate, uint lastRate, uint lastUpdated, uint newIndex) = loan.short
2176             ? _manager().getShortRatesAndTime(loan.currency, loan.interestIndex)
2177             : _manager().getRatesAndTime(loan.interestIndex);
2178 
2179         // 2. Get the instantaneous rate.
2180         (uint rate, bool invalid) = loan.short
2181             ? _manager().getShortRate(synthsByKey[loan.currency])
2182             : _manager().getBorrowRate();
2183 
2184         require(!invalid, "Rates are invalid");
2185 
2186         // 3. Get the time since we last updated the rate.
2187         uint timeDelta = block.timestamp.sub(lastUpdated).mul(SafeDecimalMath.unit());
2188 
2189         // 4. Get the latest cumulative rate. F_n+1 = F_n + F_last
2190         uint latestCumulative = lastRate.add(rate.multiplyDecimal(timeDelta));
2191 
2192         // 5. If the loan was just opened, don't record any interest. Otherwise multiple by the amount outstanding.
2193         uint interest = loan.interestIndex == 0 ? 0 : loan.amount.multiplyDecimal(latestCumulative.sub(entryRate));
2194 
2195         // 7. Update rates with the lastest cumulative rate. This also updates the time.
2196         loan.short
2197             ? _manager().updateShortRates(loan.currency, latestCumulative)
2198             : _manager().updateBorrowRates(latestCumulative);
2199 
2200         // 8. Update loan
2201         loanAfter.accruedInterest = loan.accruedInterest.add(interest);
2202         loanAfter.interestIndex = newIndex;
2203         state.updateLoan(loanAfter);
2204     }
2205 
2206     // Works out the amount of interest and principal after a repayment is made.
2207     function _processPayment(Loan memory loanBefore, uint payment) internal returns (Loan memory loanAfter) {
2208         loanAfter = loanBefore;
2209 
2210         if (payment > 0 && loanBefore.accruedInterest > 0) {
2211             uint interestPaid = payment > loanBefore.accruedInterest ? loanBefore.accruedInterest : payment;
2212             loanAfter.accruedInterest = loanBefore.accruedInterest.sub(interestPaid);
2213             payment = payment.sub(interestPaid);
2214 
2215             _payFees(interestPaid, loanBefore.currency);
2216         }
2217 
2218         // If there is more payment left after the interest, pay down the principal.
2219         if (payment > 0) {
2220             loanAfter.amount = loanBefore.amount.sub(payment);
2221 
2222             // And get the manager to reduce the total long/short balance.
2223             if (loanAfter.short) {
2224                 _manager().decrementShorts(loanAfter.currency, payment);
2225 
2226                 if (shortingRewards[loanAfter.currency] != address(0)) {
2227                     IShortingRewards(shortingRewards[loanAfter.currency]).withdraw(loanAfter.account, payment);
2228                 }
2229             } else {
2230                 _manager().decrementLongs(loanAfter.currency, payment);
2231             }
2232         }
2233     }
2234 
2235     // Take an amount of fees in a certain synth and convert it to sUSD before paying the fee pool.
2236     function _payFees(uint amount, bytes32 synth) internal {
2237         if (amount > 0) {
2238             if (synth != sUSD) {
2239                 amount = _exchangeRates().effectiveValue(synth, amount, sUSD);
2240             }
2241             _synthsUSD().issue(_feePool().FEE_ADDRESS(), amount);
2242             _feePool().recordFeePaid(amount);
2243         }
2244     }
2245 
2246     // ========== EVENTS ==========
2247     // Setters
2248     event MinCratioRatioUpdated(uint minCratio);
2249     event MinCollateralUpdated(uint minCollateral);
2250     event IssueFeeRateUpdated(uint issueFeeRate);
2251     event MaxLoansPerAccountUpdated(uint maxLoansPerAccount);
2252     event InteractionDelayUpdated(uint interactionDelay);
2253     event ManagerUpdated(address manager);
2254     event CanOpenLoansUpdated(bool canOpenLoans);
2255 
2256     // Loans
2257     event LoanCreated(address indexed account, uint id, uint amount, uint collateral, bytes32 currency, uint issuanceFee);
2258     event LoanClosed(address indexed account, uint id);
2259     event CollateralDeposited(address indexed account, uint id, uint amountDeposited, uint collateralAfter);
2260     event CollateralWithdrawn(address indexed account, uint id, uint amountWithdrawn, uint collateralAfter);
2261     event LoanRepaymentMade(address indexed account, address indexed repayer, uint id, uint amountRepaid, uint amountAfter);
2262     event LoanDrawnDown(address indexed account, uint id, uint amount);
2263     event LoanPartiallyLiquidated(
2264         address indexed account,
2265         uint id,
2266         address liquidator,
2267         uint amountLiquidated,
2268         uint collateralLiquidated
2269     );
2270     event LoanClosedByLiquidation(
2271         address indexed account,
2272         uint id,
2273         address indexed liquidator,
2274         uint amountLiquidated,
2275         uint collateralLiquidated
2276     );
2277 }
2278 
2279 
2280 // Inheritance
2281 
2282 
2283 // Internal references
2284 
2285 
2286 contract CollateralShort is Collateral {
2287     constructor(
2288         CollateralState _state,
2289         address _owner,
2290         address _manager,
2291         address _resolver,
2292         bytes32 _collateralKey,
2293         uint _minCratio,
2294         uint _minCollateral
2295     ) public Collateral(_state, _owner, _manager, _resolver, _collateralKey, _minCratio, _minCollateral) {}
2296 
2297     function open(
2298         uint collateral,
2299         uint amount,
2300         bytes32 currency
2301     ) external {
2302         require(
2303             collateral <= IERC20(address(_synthsUSD())).allowance(msg.sender, address(this)),
2304             "Allowance not high enough"
2305         );
2306 
2307         openInternal(collateral, amount, currency, true);
2308 
2309         IERC20(address(_synthsUSD())).transferFrom(msg.sender, address(this), collateral);
2310     }
2311 
2312     function close(uint id) external {
2313         uint collateral = closeInternal(msg.sender, id);
2314 
2315         IERC20(address(_synthsUSD())).transfer(msg.sender, collateral);
2316     }
2317 
2318     function deposit(
2319         address borrower,
2320         uint id,
2321         uint amount
2322     ) external {
2323         require(amount <= IERC20(address(_synthsUSD())).allowance(msg.sender, address(this)), "Allowance not high enough");
2324 
2325         IERC20(address(_synthsUSD())).transferFrom(msg.sender, address(this), amount);
2326 
2327         depositInternal(borrower, id, amount);
2328     }
2329 
2330     function withdraw(uint id, uint amount) external {
2331         uint withdrawnAmount = withdrawInternal(id, amount);
2332 
2333         IERC20(address(_synthsUSD())).transfer(msg.sender, withdrawnAmount);
2334     }
2335 
2336     function repay(
2337         address borrower,
2338         uint id,
2339         uint amount
2340     ) external {
2341         repayInternal(borrower, msg.sender, id, amount);
2342     }
2343 
2344     function draw(uint id, uint amount) external {
2345         drawInternal(id, amount);
2346     }
2347 
2348     function liquidate(
2349         address borrower,
2350         uint id,
2351         uint amount
2352     ) external {
2353         uint collateralLiquidated = liquidateInternal(borrower, id, amount);
2354 
2355         IERC20(address(_synthsUSD())).transfer(msg.sender, collateralLiquidated);
2356     }
2357 
2358     function getReward(bytes32 currency, address account) external {
2359         if (shortingRewards[currency] != address(0)) {
2360             IShortingRewards(shortingRewards[currency]).getReward(account);
2361         }
2362     }
2363 }
2364 
2365     