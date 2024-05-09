1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: CollateralEth.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/CollateralEth.sol
11 * Docs: https://docs.synthetix.io/contracts/CollateralEth
12 *
13 * Contract Dependencies: 
14 *	- Collateral
15 *	- IAddressResolver
16 *	- ICollateralEth
17 *	- ICollateralLoan
18 *	- MixinResolver
19 *	- MixinSystemSettings
20 *	- Owned
21 *	- ReentrancyGuard
22 *	- State
23 * Libraries: 
24 *	- SafeDecimalMath
25 *	- SafeMath
26 *
27 * MIT License
28 * ===========
29 *
30 * Copyright (c) 2021 Synthetix
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
512     bytes32 internal constant SETTING_CROSS_DOMAIN_DEPOSIT_GAS_LIMIT = "crossDomainDepositGasLimit";
513     bytes32 internal constant SETTING_CROSS_DOMAIN_ESCROW_GAS_LIMIT = "crossDomainEscrowGasLimit";
514     bytes32 internal constant SETTING_CROSS_DOMAIN_REWARD_GAS_LIMIT = "crossDomainRewardGasLimit";
515     bytes32 internal constant SETTING_CROSS_DOMAIN_WITHDRAWAL_GAS_LIMIT = "crossDomainWithdrawalGasLimit";
516 
517     bytes32 internal constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
518 
519     enum CrossDomainMessageGasLimits {Deposit, Escrow, Reward, Withdrawal}
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
541         } else {
542             revert("Unknown gas limit type");
543         }
544     }
545 
546     function getCrossDomainMessageGasLimit(CrossDomainMessageGasLimits gasLimitType) internal view returns (uint) {
547         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, _getGasLimitSetting(gasLimitType));
548     }
549 
550     function getTradingRewardsEnabled() internal view returns (bool) {
551         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
552     }
553 
554     function getWaitingPeriodSecs() internal view returns (uint) {
555         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
556     }
557 
558     function getPriceDeviationThresholdFactor() internal view returns (uint) {
559         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
560     }
561 
562     function getIssuanceRatio() internal view returns (uint) {
563         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
564         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
565     }
566 
567     function getFeePeriodDuration() internal view returns (uint) {
568         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
569         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
570     }
571 
572     function getTargetThreshold() internal view returns (uint) {
573         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
574         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
575     }
576 
577     function getLiquidationDelay() internal view returns (uint) {
578         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
579     }
580 
581     function getLiquidationRatio() internal view returns (uint) {
582         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
583     }
584 
585     function getLiquidationPenalty() internal view returns (uint) {
586         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
587     }
588 
589     function getRateStalePeriod() internal view returns (uint) {
590         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
591     }
592 
593     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
594         return
595             flexibleStorage().getUIntValue(
596                 SETTING_CONTRACT_NAME,
597                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
598             );
599     }
600 
601     function getMinimumStakeTime() internal view returns (uint) {
602         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
603     }
604 
605     function getAggregatorWarningFlags() internal view returns (address) {
606         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
607     }
608 
609     function getDebtSnapshotStaleTime() internal view returns (uint) {
610         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
611     }
612 }
613 
614 
615 pragma experimental ABIEncoderV2;
616 
617 
618 interface ICollateralLoan {
619     struct Loan {
620         // ID for the loan
621         uint id;
622         //  Acccount that created the loan
623         address payable account;
624         //  Amount of collateral deposited
625         uint collateral;
626         // The synth that was borowed
627         bytes32 currency;
628         //  Amount of synths borrowed
629         uint amount;
630         // Indicates if the position was short sold
631         bool short;
632         // interest amounts accrued
633         uint accruedInterest;
634         // last interest index
635         uint interestIndex;
636         // time of last interaction.
637         uint lastInteraction;
638     }
639 }
640 
641 
642 /**
643  * @dev Wrappers over Solidity's arithmetic operations with added overflow
644  * checks.
645  *
646  * Arithmetic operations in Solidity wrap on overflow. This can easily result
647  * in bugs, because programmers usually assume that an overflow raises an
648  * error, which is the standard behavior in high level programming languages.
649  * `SafeMath` restores this intuition by reverting the transaction when an
650  * operation overflows.
651  *
652  * Using this library instead of the unchecked operations eliminates an entire
653  * class of bugs, so it's recommended to use it always.
654  */
655 library SafeMath {
656     /**
657      * @dev Returns the addition of two unsigned integers, reverting on
658      * overflow.
659      *
660      * Counterpart to Solidity's `+` operator.
661      *
662      * Requirements:
663      * - Addition cannot overflow.
664      */
665     function add(uint256 a, uint256 b) internal pure returns (uint256) {
666         uint256 c = a + b;
667         require(c >= a, "SafeMath: addition overflow");
668 
669         return c;
670     }
671 
672     /**
673      * @dev Returns the subtraction of two unsigned integers, reverting on
674      * overflow (when the result is negative).
675      *
676      * Counterpart to Solidity's `-` operator.
677      *
678      * Requirements:
679      * - Subtraction cannot overflow.
680      */
681     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
682         require(b <= a, "SafeMath: subtraction overflow");
683         uint256 c = a - b;
684 
685         return c;
686     }
687 
688     /**
689      * @dev Returns the multiplication of two unsigned integers, reverting on
690      * overflow.
691      *
692      * Counterpart to Solidity's `*` operator.
693      *
694      * Requirements:
695      * - Multiplication cannot overflow.
696      */
697     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
698         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
699         // benefit is lost if 'b' is also tested.
700         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
701         if (a == 0) {
702             return 0;
703         }
704 
705         uint256 c = a * b;
706         require(c / a == b, "SafeMath: multiplication overflow");
707 
708         return c;
709     }
710 
711     /**
712      * @dev Returns the integer division of two unsigned integers. Reverts on
713      * division by zero. The result is rounded towards zero.
714      *
715      * Counterpart to Solidity's `/` operator. Note: this function uses a
716      * `revert` opcode (which leaves remaining gas untouched) while Solidity
717      * uses an invalid opcode to revert (consuming all remaining gas).
718      *
719      * Requirements:
720      * - The divisor cannot be zero.
721      */
722     function div(uint256 a, uint256 b) internal pure returns (uint256) {
723         // Solidity only automatically asserts when dividing by 0
724         require(b > 0, "SafeMath: division by zero");
725         uint256 c = a / b;
726         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
727 
728         return c;
729     }
730 
731     /**
732      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
733      * Reverts when dividing by zero.
734      *
735      * Counterpart to Solidity's `%` operator. This function uses a `revert`
736      * opcode (which leaves remaining gas untouched) while Solidity uses an
737      * invalid opcode to revert (consuming all remaining gas).
738      *
739      * Requirements:
740      * - The divisor cannot be zero.
741      */
742     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
743         require(b != 0, "SafeMath: modulo by zero");
744         return a % b;
745     }
746 }
747 
748 
749 // Libraries
750 
751 
752 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
753 library SafeDecimalMath {
754     using SafeMath for uint;
755 
756     /* Number of decimal places in the representations. */
757     uint8 public constant decimals = 18;
758     uint8 public constant highPrecisionDecimals = 27;
759 
760     /* The number representing 1.0. */
761     uint public constant UNIT = 10**uint(decimals);
762 
763     /* The number representing 1.0 for higher fidelity numbers. */
764     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
765     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
766 
767     /**
768      * @return Provides an interface to UNIT.
769      */
770     function unit() external pure returns (uint) {
771         return UNIT;
772     }
773 
774     /**
775      * @return Provides an interface to PRECISE_UNIT.
776      */
777     function preciseUnit() external pure returns (uint) {
778         return PRECISE_UNIT;
779     }
780 
781     /**
782      * @return The result of multiplying x and y, interpreting the operands as fixed-point
783      * decimals.
784      *
785      * @dev A unit factor is divided out after the product of x and y is evaluated,
786      * so that product must be less than 2**256. As this is an integer division,
787      * the internal division always rounds down. This helps save on gas. Rounding
788      * is more expensive on gas.
789      */
790     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
791         /* Divide by UNIT to remove the extra factor introduced by the product. */
792         return x.mul(y) / UNIT;
793     }
794 
795     /**
796      * @return The result of safely multiplying x and y, interpreting the operands
797      * as fixed-point decimals of the specified precision unit.
798      *
799      * @dev The operands should be in the form of a the specified unit factor which will be
800      * divided out after the product of x and y is evaluated, so that product must be
801      * less than 2**256.
802      *
803      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
804      * Rounding is useful when you need to retain fidelity for small decimal numbers
805      * (eg. small fractions or percentages).
806      */
807     function _multiplyDecimalRound(
808         uint x,
809         uint y,
810         uint precisionUnit
811     ) private pure returns (uint) {
812         /* Divide by UNIT to remove the extra factor introduced by the product. */
813         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
814 
815         if (quotientTimesTen % 10 >= 5) {
816             quotientTimesTen += 10;
817         }
818 
819         return quotientTimesTen / 10;
820     }
821 
822     /**
823      * @return The result of safely multiplying x and y, interpreting the operands
824      * as fixed-point decimals of a precise unit.
825      *
826      * @dev The operands should be in the precise unit factor which will be
827      * divided out after the product of x and y is evaluated, so that product must be
828      * less than 2**256.
829      *
830      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
831      * Rounding is useful when you need to retain fidelity for small decimal numbers
832      * (eg. small fractions or percentages).
833      */
834     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
835         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
836     }
837 
838     /**
839      * @return The result of safely multiplying x and y, interpreting the operands
840      * as fixed-point decimals of a standard unit.
841      *
842      * @dev The operands should be in the standard unit factor which will be
843      * divided out after the product of x and y is evaluated, so that product must be
844      * less than 2**256.
845      *
846      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
847      * Rounding is useful when you need to retain fidelity for small decimal numbers
848      * (eg. small fractions or percentages).
849      */
850     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
851         return _multiplyDecimalRound(x, y, UNIT);
852     }
853 
854     /**
855      * @return The result of safely dividing x and y. The return value is a high
856      * precision decimal.
857      *
858      * @dev y is divided after the product of x and the standard precision unit
859      * is evaluated, so the product of x and UNIT must be less than 2**256. As
860      * this is an integer division, the result is always rounded down.
861      * This helps save on gas. Rounding is more expensive on gas.
862      */
863     function divideDecimal(uint x, uint y) internal pure returns (uint) {
864         /* Reintroduce the UNIT factor that will be divided out by y. */
865         return x.mul(UNIT).div(y);
866     }
867 
868     /**
869      * @return The result of safely dividing x and y. The return value is as a rounded
870      * decimal in the precision unit specified in the parameter.
871      *
872      * @dev y is divided after the product of x and the specified precision unit
873      * is evaluated, so the product of x and the specified precision unit must
874      * be less than 2**256. The result is rounded to the nearest increment.
875      */
876     function _divideDecimalRound(
877         uint x,
878         uint y,
879         uint precisionUnit
880     ) private pure returns (uint) {
881         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
882 
883         if (resultTimesTen % 10 >= 5) {
884             resultTimesTen += 10;
885         }
886 
887         return resultTimesTen / 10;
888     }
889 
890     /**
891      * @return The result of safely dividing x and y. The return value is as a rounded
892      * standard precision decimal.
893      *
894      * @dev y is divided after the product of x and the standard precision unit
895      * is evaluated, so the product of x and the standard precision unit must
896      * be less than 2**256. The result is rounded to the nearest increment.
897      */
898     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
899         return _divideDecimalRound(x, y, UNIT);
900     }
901 
902     /**
903      * @return The result of safely dividing x and y. The return value is as a rounded
904      * high precision decimal.
905      *
906      * @dev y is divided after the product of x and the high precision unit
907      * is evaluated, so the product of x and the high precision unit must
908      * be less than 2**256. The result is rounded to the nearest increment.
909      */
910     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
911         return _divideDecimalRound(x, y, PRECISE_UNIT);
912     }
913 
914     /**
915      * @dev Convert a standard decimal representation to a high precision one.
916      */
917     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
918         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
919     }
920 
921     /**
922      * @dev Convert a high precision decimal to a standard decimal representation.
923      */
924     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
925         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
926 
927         if (quotientTimesTen % 10 >= 5) {
928             quotientTimesTen += 10;
929         }
930 
931         return quotientTimesTen / 10;
932     }
933 }
934 
935 
936 // Inheritance
937 
938 
939 // https://docs.synthetix.io/contracts/source/contracts/state
940 contract State is Owned {
941     // the address of the contract that can modify variables
942     // this can only be changed by the owner of this contract
943     address public associatedContract;
944 
945     constructor(address _associatedContract) internal {
946         // This contract is abstract, and thus cannot be instantiated directly
947         require(owner != address(0), "Owner must be set");
948 
949         associatedContract = _associatedContract;
950         emit AssociatedContractUpdated(_associatedContract);
951     }
952 
953     /* ========== SETTERS ========== */
954 
955     // Change the associated contract to a new address
956     function setAssociatedContract(address _associatedContract) external onlyOwner {
957         associatedContract = _associatedContract;
958         emit AssociatedContractUpdated(_associatedContract);
959     }
960 
961     /* ========== MODIFIERS ========== */
962 
963     modifier onlyAssociatedContract {
964         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
965         _;
966     }
967 
968     /* ========== EVENTS ========== */
969 
970     event AssociatedContractUpdated(address associatedContract);
971 }
972 
973 
974 // Inheritance
975 
976 
977 // Libraries
978 
979 
980 contract CollateralState is Owned, State, ICollateralLoan {
981     using SafeMath for uint;
982     using SafeDecimalMath for uint;
983 
984     mapping(address => Loan[]) public loans;
985 
986     constructor(address _owner, address _associatedContract) public Owned(_owner) State(_associatedContract) {}
987 
988     /* ========== VIEWS ========== */
989     // If we do not find the loan, this returns a struct with 0'd values.
990     function getLoan(address account, uint256 loanID) external view returns (Loan memory) {
991         Loan[] memory accountLoans = loans[account];
992         for (uint i = 0; i < accountLoans.length; i++) {
993             if (accountLoans[i].id == loanID) {
994                 return (accountLoans[i]);
995             }
996         }
997     }
998 
999     function getNumLoans(address account) external view returns (uint numLoans) {
1000         return loans[account].length;
1001     }
1002 
1003     /* ========== MUTATIVE FUNCTIONS ========== */
1004 
1005     function createLoan(Loan memory loan) public onlyAssociatedContract {
1006         loans[loan.account].push(loan);
1007     }
1008 
1009     function updateLoan(Loan memory loan) public onlyAssociatedContract {
1010         Loan[] storage accountLoans = loans[loan.account];
1011         for (uint i = 0; i < accountLoans.length; i++) {
1012             if (accountLoans[i].id == loan.id) {
1013                 loans[loan.account][i] = loan;
1014             }
1015         }
1016     }
1017 }
1018 
1019 
1020 interface ICollateralManager {
1021     // Manager information
1022     function hasCollateral(address collateral) external view returns (bool);
1023 
1024     function isSynthManaged(bytes32 currencyKey) external view returns (bool);
1025 
1026     // State information
1027     function long(bytes32 synth) external view returns (uint amount);
1028 
1029     function short(bytes32 synth) external view returns (uint amount);
1030 
1031     function totalLong() external view returns (uint susdValue, bool anyRateIsInvalid);
1032 
1033     function totalShort() external view returns (uint susdValue, bool anyRateIsInvalid);
1034 
1035     function getBorrowRate() external view returns (uint borrowRate, bool anyRateIsInvalid);
1036 
1037     function getShortRate(bytes32 synth) external view returns (uint shortRate, bool rateIsInvalid);
1038 
1039     function getRatesAndTime(uint index)
1040         external
1041         view
1042         returns (
1043             uint entryRate,
1044             uint lastRate,
1045             uint lastUpdated,
1046             uint newIndex
1047         );
1048 
1049     function getShortRatesAndTime(bytes32 currency, uint index)
1050         external
1051         view
1052         returns (
1053             uint entryRate,
1054             uint lastRate,
1055             uint lastUpdated,
1056             uint newIndex
1057         );
1058 
1059     function exceedsDebtLimit(uint amount, bytes32 currency) external view returns (bool canIssue, bool anyRateIsInvalid);
1060 
1061     function areSynthsAndCurrenciesSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1062         external
1063         view
1064         returns (bool);
1065 
1066     function areShortableSynthsSet(bytes32[] calldata requiredSynthNamesInResolver, bytes32[] calldata synthKeys)
1067         external
1068         view
1069         returns (bool);
1070 
1071     // Loans
1072     function getNewLoanId() external returns (uint id);
1073 
1074     // Manager mutative
1075     function addCollaterals(address[] calldata collaterals) external;
1076 
1077     function removeCollaterals(address[] calldata collaterals) external;
1078 
1079     function addSynths(bytes32[] calldata synthNamesInResolver, bytes32[] calldata synthKeys) external;
1080 
1081     function removeSynths(bytes32[] calldata synths, bytes32[] calldata synthKeys) external;
1082 
1083     function addShortableSynths(bytes32[2][] calldata requiredSynthAndInverseNamesInResolver, bytes32[] calldata synthKeys)
1084         external;
1085 
1086     function removeShortableSynths(bytes32[] calldata synths) external;
1087 
1088     // State mutative
1089     function updateBorrowRates(uint rate) external;
1090 
1091     function updateShortRates(bytes32 currency, uint rate) external;
1092 
1093     function incrementLongs(bytes32 synth, uint amount) external;
1094 
1095     function decrementLongs(bytes32 synth, uint amount) external;
1096 
1097     function incrementShorts(bytes32 synth, uint amount) external;
1098 
1099     function decrementShorts(bytes32 synth, uint amount) external;
1100 }
1101 
1102 
1103 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1104 interface ISystemStatus {
1105     struct Status {
1106         bool canSuspend;
1107         bool canResume;
1108     }
1109 
1110     struct Suspension {
1111         bool suspended;
1112         // reason is an integer code,
1113         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1114         uint248 reason;
1115     }
1116 
1117     // Views
1118     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1119 
1120     function requireSystemActive() external view;
1121 
1122     function requireIssuanceActive() external view;
1123 
1124     function requireExchangeActive() external view;
1125 
1126     function requireSynthActive(bytes32 currencyKey) external view;
1127 
1128     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1129 
1130     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1131 
1132     // Restricted functions
1133     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1134 
1135     function updateAccessControl(
1136         bytes32 section,
1137         address account,
1138         bool canSuspend,
1139         bool canResume
1140     ) external;
1141 }
1142 
1143 
1144 // https://docs.synthetix.io/contracts/source/interfaces/ifeepool
1145 interface IFeePool {
1146     // Views
1147 
1148     // solhint-disable-next-line func-name-mixedcase
1149     function FEE_ADDRESS() external view returns (address);
1150 
1151     function feesAvailable(address account) external view returns (uint, uint);
1152 
1153     function feePeriodDuration() external view returns (uint);
1154 
1155     function isFeesClaimable(address account) external view returns (bool);
1156 
1157     function targetThreshold() external view returns (uint);
1158 
1159     function totalFeesAvailable() external view returns (uint);
1160 
1161     function totalRewardsAvailable() external view returns (uint);
1162 
1163     // Mutative Functions
1164     function claimFees() external returns (bool);
1165 
1166     function claimOnBehalf(address claimingForAddress) external returns (bool);
1167 
1168     function closeCurrentFeePeriod() external;
1169 
1170     // Restricted: used internally to Synthetix
1171     function appendAccountIssuanceRecord(
1172         address account,
1173         uint lockedAmount,
1174         uint debtEntryIndex
1175     ) external;
1176 
1177     function recordFeePaid(uint sUSDAmount) external;
1178 
1179     function setRewardsToDistribute(uint amount) external;
1180 }
1181 
1182 
1183 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
1184 interface IERC20 {
1185     // ERC20 Optional Views
1186     function name() external view returns (string memory);
1187 
1188     function symbol() external view returns (string memory);
1189 
1190     function decimals() external view returns (uint8);
1191 
1192     // Views
1193     function totalSupply() external view returns (uint);
1194 
1195     function balanceOf(address owner) external view returns (uint);
1196 
1197     function allowance(address owner, address spender) external view returns (uint);
1198 
1199     // Mutative functions
1200     function transfer(address to, uint value) external returns (bool);
1201 
1202     function approve(address spender, uint value) external returns (bool);
1203 
1204     function transferFrom(
1205         address from,
1206         address to,
1207         uint value
1208     ) external returns (bool);
1209 
1210     // Events
1211     event Transfer(address indexed from, address indexed to, uint value);
1212 
1213     event Approval(address indexed owner, address indexed spender, uint value);
1214 }
1215 
1216 
1217 // https://docs.synthetix.io/contracts/source/interfaces/iexchangerates
1218 interface IExchangeRates {
1219     // Structs
1220     struct RateAndUpdatedTime {
1221         uint216 rate;
1222         uint40 time;
1223     }
1224 
1225     struct InversePricing {
1226         uint entryPoint;
1227         uint upperLimit;
1228         uint lowerLimit;
1229         bool frozenAtUpperLimit;
1230         bool frozenAtLowerLimit;
1231     }
1232 
1233     // Views
1234     function aggregators(bytes32 currencyKey) external view returns (address);
1235 
1236     function aggregatorWarningFlags() external view returns (address);
1237 
1238     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1239 
1240     function canFreezeRate(bytes32 currencyKey) external view returns (bool);
1241 
1242     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
1243 
1244     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1245 
1246     function effectiveValue(
1247         bytes32 sourceCurrencyKey,
1248         uint sourceAmount,
1249         bytes32 destinationCurrencyKey
1250     ) external view returns (uint value);
1251 
1252     function effectiveValueAndRates(
1253         bytes32 sourceCurrencyKey,
1254         uint sourceAmount,
1255         bytes32 destinationCurrencyKey
1256     )
1257         external
1258         view
1259         returns (
1260             uint value,
1261             uint sourceRate,
1262             uint destinationRate
1263         );
1264 
1265     function effectiveValueAtRound(
1266         bytes32 sourceCurrencyKey,
1267         uint sourceAmount,
1268         bytes32 destinationCurrencyKey,
1269         uint roundIdForSrc,
1270         uint roundIdForDest
1271     ) external view returns (uint value);
1272 
1273     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1274 
1275     function getLastRoundIdBeforeElapsedSecs(
1276         bytes32 currencyKey,
1277         uint startingRoundId,
1278         uint startingTimestamp,
1279         uint timediff
1280     ) external view returns (uint);
1281 
1282     function inversePricing(bytes32 currencyKey)
1283         external
1284         view
1285         returns (
1286             uint entryPoint,
1287             uint upperLimit,
1288             uint lowerLimit,
1289             bool frozenAtUpperLimit,
1290             bool frozenAtLowerLimit
1291         );
1292 
1293     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1294 
1295     function oracle() external view returns (address);
1296 
1297     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1298 
1299     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1300 
1301     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1302 
1303     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1304 
1305     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1306 
1307     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
1308 
1309     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1310 
1311     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1312 
1313     function rateStalePeriod() external view returns (uint);
1314 
1315     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
1316         external
1317         view
1318         returns (uint[] memory rates, uint[] memory times);
1319 
1320     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1321         external
1322         view
1323         returns (uint[] memory rates, bool anyRateInvalid);
1324 
1325     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1326 
1327     // Mutative functions
1328     function freezeRate(bytes32 currencyKey) external;
1329 }
1330 
1331 
1332 interface IVirtualSynth {
1333     // Views
1334     function balanceOfUnderlying(address account) external view returns (uint);
1335 
1336     function rate() external view returns (uint);
1337 
1338     function readyToSettle() external view returns (bool);
1339 
1340     function secsLeftInWaitingPeriod() external view returns (uint);
1341 
1342     function settled() external view returns (bool);
1343 
1344     function synth() external view returns (ISynth);
1345 
1346     // Mutative functions
1347     function settle(address account) external;
1348 }
1349 
1350 
1351 // https://docs.synthetix.io/contracts/source/interfaces/iexchanger
1352 interface IExchanger {
1353     // Views
1354     function calculateAmountAfterSettlement(
1355         address from,
1356         bytes32 currencyKey,
1357         uint amount,
1358         uint refunded
1359     ) external view returns (uint amountAfterSettlement);
1360 
1361     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
1362 
1363     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
1364 
1365     function settlementOwing(address account, bytes32 currencyKey)
1366         external
1367         view
1368         returns (
1369             uint reclaimAmount,
1370             uint rebateAmount,
1371             uint numEntries
1372         );
1373 
1374     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
1375 
1376     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
1377         external
1378         view
1379         returns (uint exchangeFeeRate);
1380 
1381     function getAmountsForExchange(
1382         uint sourceAmount,
1383         bytes32 sourceCurrencyKey,
1384         bytes32 destinationCurrencyKey
1385     )
1386         external
1387         view
1388         returns (
1389             uint amountReceived,
1390             uint fee,
1391             uint exchangeFeeRate
1392         );
1393 
1394     function priceDeviationThresholdFactor() external view returns (uint);
1395 
1396     function waitingPeriodSecs() external view returns (uint);
1397 
1398     // Mutative functions
1399     function exchange(
1400         address from,
1401         bytes32 sourceCurrencyKey,
1402         uint sourceAmount,
1403         bytes32 destinationCurrencyKey,
1404         address destinationAddress
1405     ) external returns (uint amountReceived);
1406 
1407     function exchangeOnBehalf(
1408         address exchangeForAddress,
1409         address from,
1410         bytes32 sourceCurrencyKey,
1411         uint sourceAmount,
1412         bytes32 destinationCurrencyKey
1413     ) external returns (uint amountReceived);
1414 
1415     function exchangeWithTracking(
1416         address from,
1417         bytes32 sourceCurrencyKey,
1418         uint sourceAmount,
1419         bytes32 destinationCurrencyKey,
1420         address destinationAddress,
1421         address originator,
1422         bytes32 trackingCode
1423     ) external returns (uint amountReceived);
1424 
1425     function exchangeOnBehalfWithTracking(
1426         address exchangeForAddress,
1427         address from,
1428         bytes32 sourceCurrencyKey,
1429         uint sourceAmount,
1430         bytes32 destinationCurrencyKey,
1431         address originator,
1432         bytes32 trackingCode
1433     ) external returns (uint amountReceived);
1434 
1435     function exchangeWithVirtual(
1436         address from,
1437         bytes32 sourceCurrencyKey,
1438         uint sourceAmount,
1439         bytes32 destinationCurrencyKey,
1440         address destinationAddress,
1441         bytes32 trackingCode
1442     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1443 
1444     function settle(address from, bytes32 currencyKey)
1445         external
1446         returns (
1447             uint reclaimed,
1448             uint refunded,
1449             uint numEntries
1450         );
1451 
1452     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external;
1453 
1454     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
1455 }
1456 
1457 
1458 // https://docs.synthetix.io/contracts/source/interfaces/istakingrewards
1459 interface IShortingRewards {
1460     // Views
1461     function lastTimeRewardApplicable() external view returns (uint256);
1462 
1463     function rewardPerToken() external view returns (uint256);
1464 
1465     function earned(address account) external view returns (uint256);
1466 
1467     function getRewardForDuration() external view returns (uint256);
1468 
1469     function totalSupply() external view returns (uint256);
1470 
1471     function balanceOf(address account) external view returns (uint256);
1472 
1473     // Mutative
1474 
1475     function enrol(address account, uint256 amount) external;
1476 
1477     function withdraw(address account, uint256 amount) external;
1478 
1479     function getReward(address account) external;
1480 
1481     function exit(address account) external;
1482 }
1483 
1484 
1485 // Inheritance
1486 
1487 
1488 // Libraries
1489 
1490 
1491 // Internal references
1492 
1493 
1494 contract Collateral is ICollateralLoan, Owned, MixinSystemSettings {
1495     /* ========== LIBRARIES ========== */
1496     using SafeMath for uint;
1497     using SafeDecimalMath for uint;
1498 
1499     /* ========== CONSTANTS ========== */
1500 
1501     bytes32 private constant sUSD = "sUSD";
1502 
1503     // ========== STATE VARIABLES ==========
1504 
1505     // The synth corresponding to the collateral.
1506     bytes32 public collateralKey;
1507 
1508     // Stores loans
1509     CollateralState public state;
1510 
1511     address public manager;
1512 
1513     // The synths that this contract can issue.
1514     bytes32[] public synths;
1515 
1516     // Map from currency key to synth contract name.
1517     mapping(bytes32 => bytes32) public synthsByKey;
1518 
1519     // Map from currency key to the shorting rewards contract
1520     mapping(bytes32 => address) public shortingRewards;
1521 
1522     // ========== SETTER STATE VARIABLES ==========
1523 
1524     // The minimum collateral ratio required to avoid liquidation.
1525     uint public minCratio;
1526 
1527     // The minimum amount of collateral to create a loan.
1528     uint public minCollateral;
1529 
1530     // The fee charged for issuing a loan.
1531     uint public issueFeeRate;
1532 
1533     // The maximum number of loans that an account can create with this collateral.
1534     uint public maxLoansPerAccount = 50;
1535 
1536     // Time in seconds that a user must wait between interacting with a loan.
1537     // Provides front running and flash loan protection.
1538     uint public interactionDelay = 300;
1539 
1540     bool public canOpenLoans = true;
1541 
1542     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1543 
1544     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1545     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1546     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1547     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1548     bytes32 private constant CONTRACT_SYNTHSUSD = "SynthsUSD";
1549 
1550     /* ========== CONSTRUCTOR ========== */
1551 
1552     constructor(
1553         CollateralState _state,
1554         address _owner,
1555         address _manager,
1556         address _resolver,
1557         bytes32 _collateralKey,
1558         uint _minCratio,
1559         uint _minCollateral
1560     ) public Owned(_owner) MixinSystemSettings(_resolver) {
1561         manager = _manager;
1562         state = _state;
1563         collateralKey = _collateralKey;
1564         minCratio = _minCratio;
1565         minCollateral = _minCollateral;
1566     }
1567 
1568     /* ========== VIEWS ========== */
1569 
1570     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1571         bytes32[] memory existingAddresses = MixinSystemSettings.resolverAddressesRequired();
1572         bytes32[] memory newAddresses = new bytes32[](5);
1573         newAddresses[0] = CONTRACT_FEEPOOL;
1574         newAddresses[1] = CONTRACT_EXRATES;
1575         newAddresses[2] = CONTRACT_EXCHANGER;
1576         newAddresses[3] = CONTRACT_SYSTEMSTATUS;
1577         newAddresses[4] = CONTRACT_SYNTHSUSD;
1578 
1579         bytes32[] memory combined = combineArrays(existingAddresses, newAddresses);
1580 
1581         addresses = combineArrays(combined, synths);
1582     }
1583 
1584     /* ---------- Related Contracts ---------- */
1585 
1586     function _systemStatus() internal view returns (ISystemStatus) {
1587         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1588     }
1589 
1590     function _synth(bytes32 synthName) internal view returns (ISynth) {
1591         return ISynth(requireAndGetAddress(synthName));
1592     }
1593 
1594     function _synthsUSD() internal view returns (ISynth) {
1595         return ISynth(requireAndGetAddress(CONTRACT_SYNTHSUSD));
1596     }
1597 
1598     function _exchangeRates() internal view returns (IExchangeRates) {
1599         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES));
1600     }
1601 
1602     function _exchanger() internal view returns (IExchanger) {
1603         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER));
1604     }
1605 
1606     function _feePool() internal view returns (IFeePool) {
1607         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL));
1608     }
1609 
1610     function _manager() internal view returns (ICollateralManager) {
1611         return ICollateralManager(manager);
1612     }
1613 
1614     /* ---------- Public Views ---------- */
1615 
1616     function collateralRatio(Loan memory loan) public view returns (uint cratio) {
1617         uint cvalue = _exchangeRates().effectiveValue(collateralKey, loan.collateral, sUSD);
1618         uint dvalue = _exchangeRates().effectiveValue(loan.currency, loan.amount.add(loan.accruedInterest), sUSD);
1619         cratio = cvalue.divideDecimal(dvalue);
1620     }
1621 
1622     // The maximum number of synths issuable for this amount of collateral
1623     function maxLoan(uint amount, bytes32 currency) public view returns (uint max) {
1624         max = issuanceRatio().multiplyDecimal(_exchangeRates().effectiveValue(collateralKey, amount, currency));
1625     }
1626 
1627     /**
1628      * r = target issuance ratio
1629      * D = debt value in sUSD
1630      * V = collateral value in sUSD
1631      * P = liquidation penalty
1632      * Calculates amount of synths = (D - V * r) / (1 - (1 + P) * r)
1633      * Note: if you pass a loan in here that is not eligible for liquidation it will revert.
1634      * We check the ratio first in liquidateInternal and only pass eligible loans in.
1635      */
1636     function liquidationAmount(Loan memory loan) public view returns (uint amount) {
1637         uint liquidationPenalty = getLiquidationPenalty();
1638         uint debtValue = _exchangeRates().effectiveValue(loan.currency, loan.amount.add(loan.accruedInterest), sUSD);
1639         uint collateralValue = _exchangeRates().effectiveValue(collateralKey, loan.collateral, sUSD);
1640         uint unit = SafeDecimalMath.unit();
1641 
1642         uint dividend = debtValue.sub(collateralValue.divideDecimal(minCratio));
1643         uint divisor = unit.sub(unit.add(liquidationPenalty).divideDecimal(minCratio));
1644 
1645         uint sUSDamount = dividend.divideDecimal(divisor);
1646 
1647         return _exchangeRates().effectiveValue(sUSD, sUSDamount, loan.currency);
1648     }
1649 
1650     // amount is the amount of synths we are liquidating
1651     function collateralRedeemed(bytes32 currency, uint amount) public view returns (uint collateral) {
1652         uint liquidationPenalty = getLiquidationPenalty();
1653         collateral = _exchangeRates().effectiveValue(currency, amount, collateralKey);
1654 
1655         collateral = collateral.multiplyDecimal(SafeDecimalMath.unit().add(liquidationPenalty));
1656     }
1657 
1658     function areSynthsAndCurrenciesSet(bytes32[] calldata _synthNamesInResolver, bytes32[] calldata _synthKeys)
1659         external
1660         view
1661         returns (bool)
1662     {
1663         if (synths.length != _synthNamesInResolver.length) {
1664             return false;
1665         }
1666 
1667         for (uint i = 0; i < _synthNamesInResolver.length; i++) {
1668             bytes32 synthName = _synthNamesInResolver[i];
1669             if (synths[i] != synthName) {
1670                 return false;
1671             }
1672             if (synthsByKey[_synthKeys[i]] != synths[i]) {
1673                 return false;
1674             }
1675         }
1676 
1677         return true;
1678     }
1679 
1680     /* ---------- UTILITIES ---------- */
1681 
1682     // Check the account has enough of the synth to make the payment
1683     function _checkSynthBalance(
1684         address payer,
1685         bytes32 key,
1686         uint amount
1687     ) internal view {
1688         require(IERC20(address(_synth(synthsByKey[key]))).balanceOf(payer) >= amount, "Not enough synth balance");
1689     }
1690 
1691     // We set the interest index to 0 to indicate the loan has been closed.
1692     function _checkLoanAvailable(Loan memory _loan) internal view {
1693         require(_loan.interestIndex > 0, "Loan does not exist");
1694         require(_loan.lastInteraction.add(interactionDelay) <= block.timestamp, "Loan recently interacted with");
1695     }
1696 
1697     function issuanceRatio() internal view returns (uint ratio) {
1698         ratio = SafeDecimalMath.unit().divideDecimalRound(minCratio);
1699     }
1700 
1701     /* ========== MUTATIVE FUNCTIONS ========== */
1702 
1703     /* ---------- Synths ---------- */
1704 
1705     function addSynths(bytes32[] calldata _synthNamesInResolver, bytes32[] calldata _synthKeys) external onlyOwner {
1706         require(_synthNamesInResolver.length == _synthKeys.length, "Input array length mismatch");
1707 
1708         for (uint i = 0; i < _synthNamesInResolver.length; i++) {
1709             bytes32 synthName = _synthNamesInResolver[i];
1710             synths.push(synthName);
1711             synthsByKey[_synthKeys[i]] = synthName;
1712         }
1713 
1714         // ensure cache has the latest
1715         rebuildCache();
1716     }
1717 
1718     /* ---------- Rewards Contracts ---------- */
1719 
1720     function addRewardsContracts(address rewardsContract, bytes32 synth) external onlyOwner {
1721         shortingRewards[synth] = rewardsContract;
1722     }
1723 
1724     /* ---------- SETTERS ---------- */
1725 
1726     function setMinCratio(uint _minCratio) external onlyOwner {
1727         require(_minCratio > SafeDecimalMath.unit(), "Must be greater than 1");
1728         minCratio = _minCratio;
1729         emit MinCratioRatioUpdated(minCratio);
1730     }
1731 
1732     function setIssueFeeRate(uint _issueFeeRate) external onlyOwner {
1733         issueFeeRate = _issueFeeRate;
1734         emit IssueFeeRateUpdated(issueFeeRate);
1735     }
1736 
1737     function setInteractionDelay(uint _interactionDelay) external onlyOwner {
1738         require(_interactionDelay <= SafeDecimalMath.unit() * 3600, "Max 1 hour");
1739         interactionDelay = _interactionDelay;
1740         emit InteractionDelayUpdated(interactionDelay);
1741     }
1742 
1743     function setManager(address _newManager) external onlyOwner {
1744         manager = _newManager;
1745         emit ManagerUpdated(manager);
1746     }
1747 
1748     function setCanOpenLoans(bool _canOpenLoans) external onlyOwner {
1749         canOpenLoans = _canOpenLoans;
1750         emit CanOpenLoansUpdated(canOpenLoans);
1751     }
1752 
1753     /* ---------- LOAN INTERACTIONS ---------- */
1754 
1755     function openInternal(
1756         uint collateral,
1757         uint amount,
1758         bytes32 currency,
1759         bool short
1760     ) internal returns (uint id) {
1761         // 0. Check the system is active.
1762         _systemStatus().requireIssuanceActive();
1763 
1764         require(canOpenLoans, "Opening is disabled");
1765 
1766         // 1. Make sure the collateral rate is valid.
1767         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
1768 
1769         // 2. We can only issue certain synths.
1770         require(synthsByKey[currency] > 0, "Not allowed to issue this synth");
1771 
1772         // 3. Make sure the synth rate is not invalid.
1773         require(!_exchangeRates().rateIsInvalid(currency), "Currency rate is invalid");
1774 
1775         // 4. Collateral >= minimum collateral size.
1776         require(collateral >= minCollateral, "Not enough collateral to open");
1777 
1778         // 5. Cap the number of loans so that the array doesn't get too big.
1779         require(state.getNumLoans(msg.sender) < maxLoansPerAccount, "Max loans exceeded");
1780 
1781         // 6. Check we haven't hit the debt cap for non snx collateral.
1782         (bool canIssue, bool anyRateIsInvalid) = _manager().exceedsDebtLimit(amount, currency);
1783 
1784         require(canIssue && !anyRateIsInvalid, "Debt limit or invalid rate");
1785 
1786         // 7. Require requested loan < max loan
1787         require(amount <= maxLoan(collateral, currency), "Exceeds max borrowing power");
1788 
1789         // 8. This fee is denominated in the currency of the loan
1790         uint issueFee = amount.multiplyDecimalRound(issueFeeRate);
1791 
1792         // 9. Calculate the minting fee and subtract it from the loan amount
1793         uint loanAmountMinusFee = amount.sub(issueFee);
1794 
1795         // 10. Get a Loan ID
1796         id = _manager().getNewLoanId();
1797 
1798         // 11. Create the loan struct.
1799         Loan memory loan = Loan({
1800             id: id,
1801             account: msg.sender,
1802             collateral: collateral,
1803             currency: currency,
1804             amount: amount,
1805             short: short,
1806             accruedInterest: 0,
1807             interestIndex: 0,
1808             lastInteraction: block.timestamp
1809         });
1810 
1811         // 12. Accrue interest on the loan.
1812         loan = accrueInterest(loan);
1813 
1814         // 13. Save the loan to storage
1815         state.createLoan(loan);
1816 
1817         // 14. Pay the minting fees to the fee pool
1818         _payFees(issueFee, currency);
1819 
1820         // 15. If its short, convert back to sUSD, otherwise issue the loan.
1821         if (short) {
1822             _synthsUSD().issue(msg.sender, _exchangeRates().effectiveValue(currency, loanAmountMinusFee, sUSD));
1823             _manager().incrementShorts(currency, amount);
1824 
1825             if (shortingRewards[currency] != address(0)) {
1826                 IShortingRewards(shortingRewards[currency]).enrol(msg.sender, amount);
1827             }
1828         } else {
1829             _synth(synthsByKey[currency]).issue(msg.sender, loanAmountMinusFee);
1830             _manager().incrementLongs(currency, amount);
1831         }
1832 
1833         // 16. Emit event
1834         emit LoanCreated(msg.sender, id, amount, collateral, currency, issueFee);
1835     }
1836 
1837     function closeInternal(address borrower, uint id) internal returns (uint collateral) {
1838         // 0. Check the system is active.
1839         _systemStatus().requireIssuanceActive();
1840 
1841         // 1. Make sure the collateral rate is valid
1842         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
1843 
1844         // 2. Get the loan.
1845         Loan memory loan = state.getLoan(borrower, id);
1846 
1847         // 3. Check loan is open and the last interaction time.
1848         _checkLoanAvailable(loan);
1849 
1850         // 4. Accrue interest on the loan.
1851         loan = accrueInterest(loan);
1852 
1853         // 5. Work out the total amount owing on the loan.
1854         uint total = loan.amount.add(loan.accruedInterest);
1855 
1856         // 6. Check they have enough balance to close the loan.
1857         _checkSynthBalance(loan.account, loan.currency, total);
1858 
1859         // 7. Burn the synths
1860         require(
1861             !_exchanger().hasWaitingPeriodOrSettlementOwing(borrower, loan.currency),
1862             "Waiting secs or settlement owing"
1863         );
1864         _synth(synthsByKey[loan.currency]).burn(borrower, total);
1865 
1866         // 8. Tell the manager.
1867         if (loan.short) {
1868             _manager().decrementShorts(loan.currency, loan.amount);
1869 
1870             if (shortingRewards[loan.currency] != address(0)) {
1871                 IShortingRewards(shortingRewards[loan.currency]).withdraw(borrower, loan.amount);
1872             }
1873         } else {
1874             _manager().decrementLongs(loan.currency, loan.amount);
1875         }
1876 
1877         // 9. Assign the collateral to be returned.
1878         collateral = loan.collateral;
1879 
1880         // 10. Pay fees
1881         _payFees(loan.accruedInterest, loan.currency);
1882 
1883         // 11. Record loan as closed
1884         loan.amount = 0;
1885         loan.collateral = 0;
1886         loan.accruedInterest = 0;
1887         loan.interestIndex = 0;
1888         loan.lastInteraction = block.timestamp;
1889         state.updateLoan(loan);
1890 
1891         // 12. Emit the event
1892         emit LoanClosed(borrower, id);
1893     }
1894 
1895     function closeByLiquidationInternal(
1896         address borrower,
1897         address liquidator,
1898         Loan memory loan
1899     ) internal returns (uint collateral) {
1900         // 1. Work out the total amount owing on the loan.
1901         uint total = loan.amount.add(loan.accruedInterest);
1902 
1903         // 2. Store this for the event.
1904         uint amount = loan.amount;
1905 
1906         // 3. Return collateral to the child class so it knows how much to transfer.
1907         collateral = loan.collateral;
1908 
1909         // 4. Burn the synths
1910         require(!_exchanger().hasWaitingPeriodOrSettlementOwing(liquidator, loan.currency), "Waiting or settlement owing");
1911         _synth(synthsByKey[loan.currency]).burn(liquidator, total);
1912 
1913         // 5. Tell the manager.
1914         if (loan.short) {
1915             _manager().decrementShorts(loan.currency, loan.amount);
1916 
1917             if (shortingRewards[loan.currency] != address(0)) {
1918                 IShortingRewards(shortingRewards[loan.currency]).withdraw(borrower, loan.amount);
1919             }
1920         } else {
1921             _manager().decrementLongs(loan.currency, loan.amount);
1922         }
1923 
1924         // 6. Pay fees
1925         _payFees(loan.accruedInterest, loan.currency);
1926 
1927         // 7. Record loan as closed
1928         loan.amount = 0;
1929         loan.collateral = 0;
1930         loan.accruedInterest = 0;
1931         loan.interestIndex = 0;
1932         loan.lastInteraction = block.timestamp;
1933         state.updateLoan(loan);
1934 
1935         // 8. Emit the event.
1936         emit LoanClosedByLiquidation(borrower, loan.id, liquidator, amount, collateral);
1937     }
1938 
1939     function depositInternal(
1940         address account,
1941         uint id,
1942         uint amount
1943     ) internal {
1944         // 0. Check the system is active.
1945         _systemStatus().requireIssuanceActive();
1946 
1947         // 1. Make sure the collateral rate is valid.
1948         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
1949 
1950         // 2. They sent some value > 0
1951         require(amount > 0, "Deposit must be greater than 0");
1952 
1953         // 3. Get the loan
1954         Loan memory loan = state.getLoan(account, id);
1955 
1956         // 4. Check loan is open and last interaction time.
1957         _checkLoanAvailable(loan);
1958 
1959         // 5. Accrue interest
1960         loan = accrueInterest(loan);
1961 
1962         // 6. Add the collateral
1963         loan.collateral = loan.collateral.add(amount);
1964 
1965         // 7. Update the last interaction time.
1966         loan.lastInteraction = block.timestamp;
1967 
1968         // 8. Store the loan
1969         state.updateLoan(loan);
1970 
1971         // 9. Emit the event
1972         emit CollateralDeposited(account, id, amount, loan.collateral);
1973     }
1974 
1975     function withdrawInternal(uint id, uint amount) internal returns (uint withdraw) {
1976         // 0. Check the system is active.
1977         _systemStatus().requireIssuanceActive();
1978 
1979         // 1. Make sure the collateral rate is valid.
1980         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
1981 
1982         // 2. Get the loan.
1983         Loan memory loan = state.getLoan(msg.sender, id);
1984 
1985         // 3. Check loan is open and last interaction time.
1986         _checkLoanAvailable(loan);
1987 
1988         // 4. Accrue interest.
1989         loan = accrueInterest(loan);
1990 
1991         // 5. Subtract the collateral.
1992         loan.collateral = loan.collateral.sub(amount);
1993 
1994         // 6. Update the last interaction time.
1995         loan.lastInteraction = block.timestamp;
1996 
1997         // 7. Check that the new amount does not put them under the minimum c ratio.
1998         require(collateralRatio(loan) > minCratio, "Cratio too low");
1999 
2000         // 8. Store the loan.
2001         state.updateLoan(loan);
2002 
2003         // 9. Assign the return variable.
2004         withdraw = amount;
2005 
2006         // 10. Emit the event.
2007         emit CollateralWithdrawn(msg.sender, id, amount, loan.collateral);
2008     }
2009 
2010     function liquidateInternal(
2011         address borrower,
2012         uint id,
2013         uint payment
2014     ) internal returns (uint collateralLiquidated) {
2015         // 0. Check the system is active.
2016         _systemStatus().requireIssuanceActive();
2017 
2018         // 1. Make sure the collateral rate is valid.
2019         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
2020 
2021         // 2. Check the payment amount.
2022         require(payment > 0, "Payment must be greater than 0");
2023 
2024         // 3. Get the loan.
2025         Loan memory loan = state.getLoan(borrower, id);
2026 
2027         // 4. Check loan is open and last interaction time.
2028         _checkLoanAvailable(loan);
2029 
2030         // 5. Accrue interest.
2031         loan = accrueInterest(loan);
2032 
2033         // 6. Check they have enough balance to make the payment.
2034         _checkSynthBalance(msg.sender, loan.currency, payment);
2035 
2036         // 7. Check they are eligible for liquidation.
2037         require(collateralRatio(loan) < minCratio, "Cratio above liquidation ratio");
2038 
2039         // 8. Determine how much needs to be liquidated to fix their c ratio.
2040         uint liqAmount = liquidationAmount(loan);
2041 
2042         // 9. Only allow them to liquidate enough to fix the c ratio.
2043         uint amountToLiquidate = liqAmount < payment ? liqAmount : payment;
2044 
2045         // 10. Work out the total amount owing on the loan.
2046         uint amountOwing = loan.amount.add(loan.accruedInterest);
2047 
2048         // 11. If its greater than the amount owing, we need to close the loan.
2049         if (amountToLiquidate >= amountOwing) {
2050             return closeByLiquidationInternal(borrower, msg.sender, loan);
2051         }
2052 
2053         // 12. Process the payment to workout interest/principal split.
2054         loan = _processPayment(loan, amountToLiquidate);
2055 
2056         // 13. Work out how much collateral to redeem.
2057         collateralLiquidated = collateralRedeemed(loan.currency, amountToLiquidate);
2058         loan.collateral = loan.collateral.sub(collateralLiquidated);
2059 
2060         // 14. Update the last interaction time.
2061         loan.lastInteraction = block.timestamp;
2062 
2063         // 15. Burn the synths from the liquidator.
2064         require(!_exchanger().hasWaitingPeriodOrSettlementOwing(msg.sender, loan.currency), "Waiting or settlement owing");
2065         _synth(synthsByKey[loan.currency]).burn(msg.sender, amountToLiquidate);
2066 
2067         // 16. Store the loan.
2068         state.updateLoan(loan);
2069 
2070         // 17. Emit the event
2071         emit LoanPartiallyLiquidated(borrower, id, msg.sender, amountToLiquidate, collateralLiquidated);
2072     }
2073 
2074     function repayInternal(
2075         address borrower,
2076         address repayer,
2077         uint id,
2078         uint payment
2079     ) internal {
2080         // 0. Check the system is active.
2081         _systemStatus().requireIssuanceActive();
2082 
2083         // 1. Make sure the collateral rate is valid.
2084         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
2085 
2086         // 2. Check the payment amount.
2087         require(payment > 0, "Payment must be greater than 0");
2088 
2089         // 3. Get loan
2090         Loan memory loan = state.getLoan(borrower, id);
2091 
2092         // 4. Check loan is open and last interaction time.
2093         _checkLoanAvailable(loan);
2094 
2095         // 5. Accrue interest.
2096         loan = accrueInterest(loan);
2097 
2098         // 6. Check the spender has enough synths to make the repayment
2099         _checkSynthBalance(repayer, loan.currency, payment);
2100 
2101         // 7. Process the payment.
2102         loan = _processPayment(loan, payment);
2103 
2104         // 8. Update the last interaction time.
2105         loan.lastInteraction = block.timestamp;
2106 
2107         // 9. Burn synths from the payer
2108         require(!_exchanger().hasWaitingPeriodOrSettlementOwing(repayer, loan.currency), "Waiting or settlement owing");
2109         _synth(synthsByKey[loan.currency]).burn(repayer, payment);
2110 
2111         // 10. Store the loan
2112         state.updateLoan(loan);
2113 
2114         // 11. Emit the event.
2115         emit LoanRepaymentMade(borrower, repayer, id, payment, loan.amount);
2116     }
2117 
2118     function drawInternal(uint id, uint amount) internal {
2119         // 0. Check the system is active.
2120         _systemStatus().requireIssuanceActive();
2121 
2122         // 1. Make sure the collateral rate is valid.
2123         require(!_exchangeRates().rateIsInvalid(collateralKey), "Collateral rate is invalid");
2124 
2125         // 2. Get loan.
2126         Loan memory loan = state.getLoan(msg.sender, id);
2127 
2128         // 3. Check loan is open and last interaction time.
2129         _checkLoanAvailable(loan);
2130 
2131         // 4. Accrue interest.
2132         loan = accrueInterest(loan);
2133 
2134         // 5. Add the requested amount.
2135         loan.amount = loan.amount.add(amount);
2136 
2137         // 6. If it is below the minimum, don't allow this draw.
2138         require(collateralRatio(loan) > minCratio, "Cannot draw this much");
2139 
2140         // 7. This fee is denominated in the currency of the loan
2141         uint issueFee = amount.multiplyDecimalRound(issueFeeRate);
2142 
2143         // 8. Calculate the minting fee and subtract it from the draw amount
2144         uint amountMinusFee = amount.sub(issueFee);
2145 
2146         // 9. If its short, let the child handle it, otherwise issue the synths.
2147         if (loan.short) {
2148             _manager().incrementShorts(loan.currency, amount);
2149             _synthsUSD().issue(msg.sender, _exchangeRates().effectiveValue(loan.currency, amountMinusFee, sUSD));
2150 
2151             if (shortingRewards[loan.currency] != address(0)) {
2152                 IShortingRewards(shortingRewards[loan.currency]).enrol(msg.sender, amount);
2153             }
2154         } else {
2155             _manager().incrementLongs(loan.currency, amount);
2156             _synth(synthsByKey[loan.currency]).issue(msg.sender, amountMinusFee);
2157         }
2158 
2159         // 10. Pay the minting fees to the fee pool
2160         _payFees(issueFee, loan.currency);
2161 
2162         // 11. Update the last interaction time.
2163         loan.lastInteraction = block.timestamp;
2164 
2165         // 12. Store the loan
2166         state.updateLoan(loan);
2167 
2168         // 13. Emit the event.
2169         emit LoanDrawnDown(msg.sender, id, amount);
2170     }
2171 
2172     // Update the cumulative interest rate for the currency that was interacted with.
2173     function accrueInterest(Loan memory loan) internal returns (Loan memory loanAfter) {
2174         loanAfter = loan;
2175 
2176         // 1. Get the rates we need.
2177         (uint entryRate, uint lastRate, uint lastUpdated, uint newIndex) = loan.short
2178             ? _manager().getShortRatesAndTime(loan.currency, loan.interestIndex)
2179             : _manager().getRatesAndTime(loan.interestIndex);
2180 
2181         // 2. Get the instantaneous rate.
2182         (uint rate, bool invalid) = loan.short
2183             ? _manager().getShortRate(synthsByKey[loan.currency])
2184             : _manager().getBorrowRate();
2185 
2186         require(!invalid, "Rates are invalid");
2187 
2188         // 3. Get the time since we last updated the rate.
2189         uint timeDelta = block.timestamp.sub(lastUpdated).mul(SafeDecimalMath.unit());
2190 
2191         // 4. Get the latest cumulative rate. F_n+1 = F_n + F_last
2192         uint latestCumulative = lastRate.add(rate.multiplyDecimal(timeDelta));
2193 
2194         // 5. If the loan was just opened, don't record any interest. Otherwise multiple by the amount outstanding.
2195         uint interest = loan.interestIndex == 0 ? 0 : loan.amount.multiplyDecimal(latestCumulative.sub(entryRate));
2196 
2197         // 7. Update rates with the lastest cumulative rate. This also updates the time.
2198         loan.short
2199             ? _manager().updateShortRates(loan.currency, latestCumulative)
2200             : _manager().updateBorrowRates(latestCumulative);
2201 
2202         // 8. Update loan
2203         loanAfter.accruedInterest = loan.accruedInterest.add(interest);
2204         loanAfter.interestIndex = newIndex;
2205         state.updateLoan(loanAfter);
2206     }
2207 
2208     // Works out the amount of interest and principal after a repayment is made.
2209     function _processPayment(Loan memory loanBefore, uint payment) internal returns (Loan memory loanAfter) {
2210         loanAfter = loanBefore;
2211 
2212         if (payment > 0 && loanBefore.accruedInterest > 0) {
2213             uint interestPaid = payment > loanBefore.accruedInterest ? loanBefore.accruedInterest : payment;
2214             loanAfter.accruedInterest = loanBefore.accruedInterest.sub(interestPaid);
2215             payment = payment.sub(interestPaid);
2216 
2217             _payFees(interestPaid, loanBefore.currency);
2218         }
2219 
2220         // If there is more payment left after the interest, pay down the principal.
2221         if (payment > 0) {
2222             loanAfter.amount = loanBefore.amount.sub(payment);
2223 
2224             // And get the manager to reduce the total long/short balance.
2225             if (loanAfter.short) {
2226                 _manager().decrementShorts(loanAfter.currency, payment);
2227 
2228                 if (shortingRewards[loanAfter.currency] != address(0)) {
2229                     IShortingRewards(shortingRewards[loanAfter.currency]).withdraw(loanAfter.account, payment);
2230                 }
2231             } else {
2232                 _manager().decrementLongs(loanAfter.currency, payment);
2233             }
2234         }
2235     }
2236 
2237     // Take an amount of fees in a certain synth and convert it to sUSD before paying the fee pool.
2238     function _payFees(uint amount, bytes32 synth) internal {
2239         if (amount > 0) {
2240             if (synth != sUSD) {
2241                 amount = _exchangeRates().effectiveValue(synth, amount, sUSD);
2242             }
2243             _synthsUSD().issue(_feePool().FEE_ADDRESS(), amount);
2244             _feePool().recordFeePaid(amount);
2245         }
2246     }
2247 
2248     // ========== EVENTS ==========
2249     // Setters
2250     event MinCratioRatioUpdated(uint minCratio);
2251     event MinCollateralUpdated(uint minCollateral);
2252     event IssueFeeRateUpdated(uint issueFeeRate);
2253     event MaxLoansPerAccountUpdated(uint maxLoansPerAccount);
2254     event InteractionDelayUpdated(uint interactionDelay);
2255     event ManagerUpdated(address manager);
2256     event CanOpenLoansUpdated(bool canOpenLoans);
2257 
2258     // Loans
2259     event LoanCreated(address indexed account, uint id, uint amount, uint collateral, bytes32 currency, uint issuanceFee);
2260     event LoanClosed(address indexed account, uint id);
2261     event CollateralDeposited(address indexed account, uint id, uint amountDeposited, uint collateralAfter);
2262     event CollateralWithdrawn(address indexed account, uint id, uint amountWithdrawn, uint collateralAfter);
2263     event LoanRepaymentMade(address indexed account, address indexed repayer, uint id, uint amountRepaid, uint amountAfter);
2264     event LoanDrawnDown(address indexed account, uint id, uint amount);
2265     event LoanPartiallyLiquidated(
2266         address indexed account,
2267         uint id,
2268         address liquidator,
2269         uint amountLiquidated,
2270         uint collateralLiquidated
2271     );
2272     event LoanClosedByLiquidation(
2273         address indexed account,
2274         uint id,
2275         address indexed liquidator,
2276         uint amountLiquidated,
2277         uint collateralLiquidated
2278     );
2279 }
2280 
2281 
2282 /**
2283  * @dev Contract module that helps prevent reentrant calls to a function.
2284  *
2285  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
2286  * available, which can be aplied to functions to make sure there are no nested
2287  * (reentrant) calls to them.
2288  *
2289  * Note that because there is a single `nonReentrant` guard, functions marked as
2290  * `nonReentrant` may not call one another. This can be worked around by making
2291  * those functions `private`, and then adding `external` `nonReentrant` entry
2292  * points to them.
2293  */
2294 contract ReentrancyGuard {
2295     /// @dev counter to allow mutex lock with only one SSTORE operation
2296     uint256 private _guardCounter;
2297 
2298     constructor () internal {
2299         // The counter starts at one to prevent changing it from zero to a non-zero
2300         // value, which is a more expensive operation.
2301         _guardCounter = 1;
2302     }
2303 
2304     /**
2305      * @dev Prevents a contract from calling itself, directly or indirectly.
2306      * Calling a `nonReentrant` function from another `nonReentrant`
2307      * function is not supported. It is possible to prevent this from happening
2308      * by making the `nonReentrant` function external, and make it call a
2309      * `private` function that does the actual work.
2310      */
2311     modifier nonReentrant() {
2312         _guardCounter += 1;
2313         uint256 localCounter = _guardCounter;
2314         _;
2315         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
2316     }
2317 }
2318 
2319 
2320 interface ICollateralEth {
2321     function open(uint amount, bytes32 currency) external payable;
2322 
2323     function close(uint id) external;
2324 
2325     function deposit(address borrower, uint id) external payable;
2326 
2327     function withdraw(uint id, uint amount) external;
2328 
2329     function repay(
2330         address borrower,
2331         uint id,
2332         uint amount
2333     ) external;
2334 
2335     function liquidate(
2336         address borrower,
2337         uint id,
2338         uint amount
2339     ) external;
2340 
2341     function claim(uint amount) external;
2342 }
2343 
2344 
2345 // Inheritance
2346 
2347 
2348 // Internal references
2349 
2350 
2351 // This contract handles the payable aspects of eth loans.
2352 contract CollateralEth is Collateral, ICollateralEth, ReentrancyGuard {
2353     mapping(address => uint) public pendingWithdrawals;
2354 
2355     constructor(
2356         CollateralState _state,
2357         address _owner,
2358         address _manager,
2359         address _resolver,
2360         bytes32 _collateralKey,
2361         uint _minCratio,
2362         uint _minCollateral
2363     ) public Collateral(_state, _owner, _manager, _resolver, _collateralKey, _minCratio, _minCollateral) {}
2364 
2365     function open(uint amount, bytes32 currency) external payable {
2366         openInternal(msg.value, amount, currency, false);
2367     }
2368 
2369     function close(uint id) external {
2370         uint collateral = closeInternal(msg.sender, id);
2371 
2372         pendingWithdrawals[msg.sender] = pendingWithdrawals[msg.sender].add(collateral);
2373     }
2374 
2375     function deposit(address borrower, uint id) external payable {
2376         depositInternal(borrower, id, msg.value);
2377     }
2378 
2379     function withdraw(uint id, uint withdrawAmount) external {
2380         uint amount = withdrawInternal(id, withdrawAmount);
2381 
2382         pendingWithdrawals[msg.sender] = pendingWithdrawals[msg.sender].add(amount);
2383     }
2384 
2385     function repay(
2386         address account,
2387         uint id,
2388         uint amount
2389     ) external {
2390         repayInternal(account, msg.sender, id, amount);
2391     }
2392 
2393     function draw(uint id, uint amount) external {
2394         drawInternal(id, amount);
2395     }
2396 
2397     function liquidate(
2398         address borrower,
2399         uint id,
2400         uint amount
2401     ) external {
2402         uint collateralLiquidated = liquidateInternal(borrower, id, amount);
2403 
2404         pendingWithdrawals[msg.sender] = pendingWithdrawals[msg.sender].add(collateralLiquidated);
2405     }
2406 
2407     function claim(uint amount) external nonReentrant {
2408         // If they try to withdraw more than their total balance, it will fail on the safe sub.
2409         pendingWithdrawals[msg.sender] = pendingWithdrawals[msg.sender].sub(amount);
2410 
2411         (bool success, ) = msg.sender.call.value(amount)("");
2412         require(success, "Transfer failed");
2413     }
2414 }
2415 
2416     