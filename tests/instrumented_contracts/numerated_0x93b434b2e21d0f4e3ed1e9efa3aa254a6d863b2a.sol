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
215 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
216 contract AddressResolver is Owned, IAddressResolver {
217     mapping(bytes32 => address) public repository;
218 
219     constructor(address _owner) public Owned(_owner) {}
220 
221     /* ========== MUTATIVE FUNCTIONS ========== */
222 
223     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
224         require(names.length == destinations.length, "Input lengths must match");
225 
226         for (uint i = 0; i < names.length; i++) {
227             repository[names[i]] = destinations[i];
228         }
229     }
230 
231     /* ========== VIEWS ========== */
232 
233     function getAddress(bytes32 name) external view returns (address) {
234         return repository[name];
235     }
236 
237     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
238         address _foundAddress = repository[name];
239         require(_foundAddress != address(0), reason);
240         return _foundAddress;
241     }
242 
243     function getSynth(bytes32 key) external view returns (address) {
244         IIssuer issuer = IIssuer(repository["Issuer"]);
245         require(address(issuer) != address(0), "Cannot find Issuer address");
246         return address(issuer.synths(key));
247     }
248 }
249 
250 
251 // Inheritance
252 
253 
254 // Internal references
255 
256 
257 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
258 contract MixinResolver is Owned {
259     AddressResolver public resolver;
260 
261     mapping(bytes32 => address) private addressCache;
262 
263     bytes32[] public resolverAddressesRequired;
264 
265     uint public constant MAX_ADDRESSES_FROM_RESOLVER = 24;
266 
267     constructor(address _resolver, bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory _addressesToCache) internal {
268         // This contract is abstract, and thus cannot be instantiated directly
269         require(owner != address(0), "Owner must be set");
270 
271         for (uint i = 0; i < _addressesToCache.length; i++) {
272             if (_addressesToCache[i] != bytes32(0)) {
273                 resolverAddressesRequired.push(_addressesToCache[i]);
274             } else {
275                 // End early once an empty item is found - assumes there are no empty slots in
276                 // _addressesToCache
277                 break;
278             }
279         }
280         resolver = AddressResolver(_resolver);
281         // Do not sync the cache as addresses may not be in the resolver yet
282     }
283 
284     /* ========== SETTERS ========== */
285     function setResolverAndSyncCache(AddressResolver _resolver) external onlyOwner {
286         resolver = _resolver;
287 
288         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
289             bytes32 name = resolverAddressesRequired[i];
290             // Note: can only be invoked once the resolver has all the targets needed added
291             addressCache[name] = resolver.requireAndGetAddress(name, "Resolver missing target");
292         }
293     }
294 
295     /* ========== VIEWS ========== */
296 
297     function requireAndGetAddress(bytes32 name, string memory reason) internal view returns (address) {
298         address _foundAddress = addressCache[name];
299         require(_foundAddress != address(0), reason);
300         return _foundAddress;
301     }
302 
303     // Note: this could be made external in a utility contract if addressCache was made public
304     // (used for deployment)
305     function isResolverCached(AddressResolver _resolver) external view returns (bool) {
306         if (resolver != _resolver) {
307             return false;
308         }
309 
310         // otherwise, check everything
311         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
312             bytes32 name = resolverAddressesRequired[i];
313             // false if our cache is invalid or if the resolver doesn't have the required address
314             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
315                 return false;
316             }
317         }
318 
319         return true;
320     }
321 
322     // Note: can be made external into a utility contract (used for deployment)
323     function getResolverAddressesRequired()
324         external
325         view
326         returns (bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory addressesRequired)
327     {
328         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
329             addressesRequired[i] = resolverAddressesRequired[i];
330         }
331     }
332 
333     /* ========== INTERNAL FUNCTIONS ========== */
334     function appendToAddressCache(bytes32 name) internal {
335         resolverAddressesRequired.push(name);
336         require(resolverAddressesRequired.length < MAX_ADDRESSES_FROM_RESOLVER, "Max resolver cache size met");
337         // Because this is designed to be called internally in constructors, we don't
338         // check the address exists already in the resolver
339         addressCache[name] = resolver.getAddress(name);
340     }
341 }
342 
343 
344 // https://docs.synthetix.io/contracts/source/interfaces/iflexiblestorage
345 interface IFlexibleStorage {
346     // Views
347     function getUIntValue(bytes32 contractName, bytes32 record) external view returns (uint);
348 
349     function getUIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (uint[] memory);
350 
351     function getIntValue(bytes32 contractName, bytes32 record) external view returns (int);
352 
353     function getIntValues(bytes32 contractName, bytes32[] calldata records) external view returns (int[] memory);
354 
355     function getAddressValue(bytes32 contractName, bytes32 record) external view returns (address);
356 
357     function getAddressValues(bytes32 contractName, bytes32[] calldata records) external view returns (address[] memory);
358 
359     function getBoolValue(bytes32 contractName, bytes32 record) external view returns (bool);
360 
361     function getBoolValues(bytes32 contractName, bytes32[] calldata records) external view returns (bool[] memory);
362 
363     function getBytes32Value(bytes32 contractName, bytes32 record) external view returns (bytes32);
364 
365     function getBytes32Values(bytes32 contractName, bytes32[] calldata records) external view returns (bytes32[] memory);
366 
367     // Mutative functions
368     function deleteUIntValue(bytes32 contractName, bytes32 record) external;
369 
370     function deleteIntValue(bytes32 contractName, bytes32 record) external;
371 
372     function deleteAddressValue(bytes32 contractName, bytes32 record) external;
373 
374     function deleteBoolValue(bytes32 contractName, bytes32 record) external;
375 
376     function deleteBytes32Value(bytes32 contractName, bytes32 record) external;
377 
378     function setUIntValue(
379         bytes32 contractName,
380         bytes32 record,
381         uint value
382     ) external;
383 
384     function setUIntValues(
385         bytes32 contractName,
386         bytes32[] calldata records,
387         uint[] calldata values
388     ) external;
389 
390     function setIntValue(
391         bytes32 contractName,
392         bytes32 record,
393         int value
394     ) external;
395 
396     function setIntValues(
397         bytes32 contractName,
398         bytes32[] calldata records,
399         int[] calldata values
400     ) external;
401 
402     function setAddressValue(
403         bytes32 contractName,
404         bytes32 record,
405         address value
406     ) external;
407 
408     function setAddressValues(
409         bytes32 contractName,
410         bytes32[] calldata records,
411         address[] calldata values
412     ) external;
413 
414     function setBoolValue(
415         bytes32 contractName,
416         bytes32 record,
417         bool value
418     ) external;
419 
420     function setBoolValues(
421         bytes32 contractName,
422         bytes32[] calldata records,
423         bool[] calldata values
424     ) external;
425 
426     function setBytes32Value(
427         bytes32 contractName,
428         bytes32 record,
429         bytes32 value
430     ) external;
431 
432     function setBytes32Values(
433         bytes32 contractName,
434         bytes32[] calldata records,
435         bytes32[] calldata values
436     ) external;
437 }
438 
439 
440 // Internal references
441 
442 
443 // https://docs.synthetix.io/contracts/source/contracts/mixinsystemsettings
444 contract MixinSystemSettings is MixinResolver {
445     bytes32 internal constant SETTING_CONTRACT_NAME = "SystemSettings";
446 
447     bytes32 internal constant SETTING_WAITING_PERIOD_SECS = "waitingPeriodSecs";
448     bytes32 internal constant SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR = "priceDeviationThresholdFactor";
449     bytes32 internal constant SETTING_ISSUANCE_RATIO = "issuanceRatio";
450     bytes32 internal constant SETTING_FEE_PERIOD_DURATION = "feePeriodDuration";
451     bytes32 internal constant SETTING_TARGET_THRESHOLD = "targetThreshold";
452     bytes32 internal constant SETTING_LIQUIDATION_DELAY = "liquidationDelay";
453     bytes32 internal constant SETTING_LIQUIDATION_RATIO = "liquidationRatio";
454     bytes32 internal constant SETTING_LIQUIDATION_PENALTY = "liquidationPenalty";
455     bytes32 internal constant SETTING_RATE_STALE_PERIOD = "rateStalePeriod";
456     bytes32 internal constant SETTING_EXCHANGE_FEE_RATE = "exchangeFeeRate";
457     bytes32 internal constant SETTING_MINIMUM_STAKE_TIME = "minimumStakeTime";
458     bytes32 internal constant SETTING_AGGREGATOR_WARNING_FLAGS = "aggregatorWarningFlags";
459     bytes32 internal constant SETTING_TRADING_REWARDS_ENABLED = "tradingRewardsEnabled";
460     bytes32 internal constant SETTING_DEBT_SNAPSHOT_STALE_TIME = "debtSnapshotStaleTime";
461 
462     bytes32 private constant CONTRACT_FLEXIBLESTORAGE = "FlexibleStorage";
463 
464     constructor() internal {
465         appendToAddressCache(CONTRACT_FLEXIBLESTORAGE);
466     }
467 
468     function flexibleStorage() internal view returns (IFlexibleStorage) {
469         return IFlexibleStorage(requireAndGetAddress(CONTRACT_FLEXIBLESTORAGE, "Missing FlexibleStorage address"));
470     }
471 
472     function getTradingRewardsEnabled() internal view returns (bool) {
473         return flexibleStorage().getBoolValue(SETTING_CONTRACT_NAME, SETTING_TRADING_REWARDS_ENABLED);
474     }
475 
476     function getWaitingPeriodSecs() internal view returns (uint) {
477         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_WAITING_PERIOD_SECS);
478     }
479 
480     function getPriceDeviationThresholdFactor() internal view returns (uint) {
481         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_PRICE_DEVIATION_THRESHOLD_FACTOR);
482     }
483 
484     function getIssuanceRatio() internal view returns (uint) {
485         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
486         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_ISSUANCE_RATIO);
487     }
488 
489     function getFeePeriodDuration() internal view returns (uint) {
490         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
491         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_FEE_PERIOD_DURATION);
492     }
493 
494     function getTargetThreshold() internal view returns (uint) {
495         // lookup on flexible storage directly for gas savings (rather than via SystemSettings)
496         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_TARGET_THRESHOLD);
497     }
498 
499     function getLiquidationDelay() internal view returns (uint) {
500         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_DELAY);
501     }
502 
503     function getLiquidationRatio() internal view returns (uint) {
504         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_RATIO);
505     }
506 
507     function getLiquidationPenalty() internal view returns (uint) {
508         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_LIQUIDATION_PENALTY);
509     }
510 
511     function getRateStalePeriod() internal view returns (uint) {
512         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_RATE_STALE_PERIOD);
513     }
514 
515     function getExchangeFeeRate(bytes32 currencyKey) internal view returns (uint) {
516         return
517             flexibleStorage().getUIntValue(
518                 SETTING_CONTRACT_NAME,
519                 keccak256(abi.encodePacked(SETTING_EXCHANGE_FEE_RATE, currencyKey))
520             );
521     }
522 
523     function getMinimumStakeTime() internal view returns (uint) {
524         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_MINIMUM_STAKE_TIME);
525     }
526 
527     function getAggregatorWarningFlags() internal view returns (address) {
528         return flexibleStorage().getAddressValue(SETTING_CONTRACT_NAME, SETTING_AGGREGATOR_WARNING_FLAGS);
529     }
530 
531     function getDebtSnapshotStaleTime() internal view returns (uint) {
532         return flexibleStorage().getUIntValue(SETTING_CONTRACT_NAME, SETTING_DEBT_SNAPSHOT_STALE_TIME);
533     }
534 }
535 
536 
537 interface IVirtualSynth {
538     // Views
539     function balanceOfUnderlying(address account) external view returns (uint);
540 
541     function rate() external view returns (uint);
542 
543     function readyToSettle() external view returns (bool);
544 
545     function secsLeftInWaitingPeriod() external view returns (uint);
546 
547     function settled() external view returns (bool);
548 
549     function synth() external view returns (ISynth);
550 
551     // Mutative functions
552     function settle(address account) external;
553 }
554 
555 
556 // https://docs.synthetix.io/contracts/source/interfaces/iexchanger
557 interface IExchanger {
558     // Views
559     function calculateAmountAfterSettlement(
560         address from,
561         bytes32 currencyKey,
562         uint amount,
563         uint refunded
564     ) external view returns (uint amountAfterSettlement);
565 
566     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
567 
568     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
569 
570     function settlementOwing(address account, bytes32 currencyKey)
571         external
572         view
573         returns (
574             uint reclaimAmount,
575             uint rebateAmount,
576             uint numEntries
577         );
578 
579     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
580 
581     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
582         external
583         view
584         returns (uint exchangeFeeRate);
585 
586     function getAmountsForExchange(
587         uint sourceAmount,
588         bytes32 sourceCurrencyKey,
589         bytes32 destinationCurrencyKey
590     )
591         external
592         view
593         returns (
594             uint amountReceived,
595             uint fee,
596             uint exchangeFeeRate
597         );
598 
599     function priceDeviationThresholdFactor() external view returns (uint);
600 
601     function waitingPeriodSecs() external view returns (uint);
602 
603     // Mutative functions
604     function exchange(
605         address from,
606         bytes32 sourceCurrencyKey,
607         uint sourceAmount,
608         bytes32 destinationCurrencyKey,
609         address destinationAddress
610     ) external returns (uint amountReceived);
611 
612     function exchangeOnBehalf(
613         address exchangeForAddress,
614         address from,
615         bytes32 sourceCurrencyKey,
616         uint sourceAmount,
617         bytes32 destinationCurrencyKey
618     ) external returns (uint amountReceived);
619 
620     function exchangeWithTracking(
621         address from,
622         bytes32 sourceCurrencyKey,
623         uint sourceAmount,
624         bytes32 destinationCurrencyKey,
625         address destinationAddress,
626         address originator,
627         bytes32 trackingCode
628     ) external returns (uint amountReceived);
629 
630     function exchangeOnBehalfWithTracking(
631         address exchangeForAddress,
632         address from,
633         bytes32 sourceCurrencyKey,
634         uint sourceAmount,
635         bytes32 destinationCurrencyKey,
636         address originator,
637         bytes32 trackingCode
638     ) external returns (uint amountReceived);
639 
640     function exchangeWithVirtual(
641         address from,
642         bytes32 sourceCurrencyKey,
643         uint sourceAmount,
644         bytes32 destinationCurrencyKey,
645         address destinationAddress,
646         bytes32 trackingCode
647     ) external returns (uint amountReceived, IVirtualSynth vSynth);
648 
649     function settle(address from, bytes32 currencyKey)
650         external
651         returns (
652             uint reclaimed,
653             uint refunded,
654             uint numEntries
655         );
656 
657     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external;
658 
659     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
660 }
661 
662 
663 /**
664  * @dev Wrappers over Solidity's arithmetic operations with added overflow
665  * checks.
666  *
667  * Arithmetic operations in Solidity wrap on overflow. This can easily result
668  * in bugs, because programmers usually assume that an overflow raises an
669  * error, which is the standard behavior in high level programming languages.
670  * `SafeMath` restores this intuition by reverting the transaction when an
671  * operation overflows.
672  *
673  * Using this library instead of the unchecked operations eliminates an entire
674  * class of bugs, so it's recommended to use it always.
675  */
676 library SafeMath {
677     /**
678      * @dev Returns the addition of two unsigned integers, reverting on
679      * overflow.
680      *
681      * Counterpart to Solidity's `+` operator.
682      *
683      * Requirements:
684      * - Addition cannot overflow.
685      */
686     function add(uint256 a, uint256 b) internal pure returns (uint256) {
687         uint256 c = a + b;
688         require(c >= a, "SafeMath: addition overflow");
689 
690         return c;
691     }
692 
693     /**
694      * @dev Returns the subtraction of two unsigned integers, reverting on
695      * overflow (when the result is negative).
696      *
697      * Counterpart to Solidity's `-` operator.
698      *
699      * Requirements:
700      * - Subtraction cannot overflow.
701      */
702     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
703         require(b <= a, "SafeMath: subtraction overflow");
704         uint256 c = a - b;
705 
706         return c;
707     }
708 
709     /**
710      * @dev Returns the multiplication of two unsigned integers, reverting on
711      * overflow.
712      *
713      * Counterpart to Solidity's `*` operator.
714      *
715      * Requirements:
716      * - Multiplication cannot overflow.
717      */
718     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
719         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
720         // benefit is lost if 'b' is also tested.
721         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
722         if (a == 0) {
723             return 0;
724         }
725 
726         uint256 c = a * b;
727         require(c / a == b, "SafeMath: multiplication overflow");
728 
729         return c;
730     }
731 
732     /**
733      * @dev Returns the integer division of two unsigned integers. Reverts on
734      * division by zero. The result is rounded towards zero.
735      *
736      * Counterpart to Solidity's `/` operator. Note: this function uses a
737      * `revert` opcode (which leaves remaining gas untouched) while Solidity
738      * uses an invalid opcode to revert (consuming all remaining gas).
739      *
740      * Requirements:
741      * - The divisor cannot be zero.
742      */
743     function div(uint256 a, uint256 b) internal pure returns (uint256) {
744         // Solidity only automatically asserts when dividing by 0
745         require(b > 0, "SafeMath: division by zero");
746         uint256 c = a / b;
747         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
748 
749         return c;
750     }
751 
752     /**
753      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
754      * Reverts when dividing by zero.
755      *
756      * Counterpart to Solidity's `%` operator. This function uses a `revert`
757      * opcode (which leaves remaining gas untouched) while Solidity uses an
758      * invalid opcode to revert (consuming all remaining gas).
759      *
760      * Requirements:
761      * - The divisor cannot be zero.
762      */
763     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
764         require(b != 0, "SafeMath: modulo by zero");
765         return a % b;
766     }
767 }
768 
769 
770 // Libraries
771 
772 
773 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
774 library SafeDecimalMath {
775     using SafeMath for uint;
776 
777     /* Number of decimal places in the representations. */
778     uint8 public constant decimals = 18;
779     uint8 public constant highPrecisionDecimals = 27;
780 
781     /* The number representing 1.0. */
782     uint public constant UNIT = 10**uint(decimals);
783 
784     /* The number representing 1.0 for higher fidelity numbers. */
785     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
786     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
787 
788     /**
789      * @return Provides an interface to UNIT.
790      */
791     function unit() external pure returns (uint) {
792         return UNIT;
793     }
794 
795     /**
796      * @return Provides an interface to PRECISE_UNIT.
797      */
798     function preciseUnit() external pure returns (uint) {
799         return PRECISE_UNIT;
800     }
801 
802     /**
803      * @return The result of multiplying x and y, interpreting the operands as fixed-point
804      * decimals.
805      *
806      * @dev A unit factor is divided out after the product of x and y is evaluated,
807      * so that product must be less than 2**256. As this is an integer division,
808      * the internal division always rounds down. This helps save on gas. Rounding
809      * is more expensive on gas.
810      */
811     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
812         /* Divide by UNIT to remove the extra factor introduced by the product. */
813         return x.mul(y) / UNIT;
814     }
815 
816     /**
817      * @return The result of safely multiplying x and y, interpreting the operands
818      * as fixed-point decimals of the specified precision unit.
819      *
820      * @dev The operands should be in the form of a the specified unit factor which will be
821      * divided out after the product of x and y is evaluated, so that product must be
822      * less than 2**256.
823      *
824      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
825      * Rounding is useful when you need to retain fidelity for small decimal numbers
826      * (eg. small fractions or percentages).
827      */
828     function _multiplyDecimalRound(
829         uint x,
830         uint y,
831         uint precisionUnit
832     ) private pure returns (uint) {
833         /* Divide by UNIT to remove the extra factor introduced by the product. */
834         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
835 
836         if (quotientTimesTen % 10 >= 5) {
837             quotientTimesTen += 10;
838         }
839 
840         return quotientTimesTen / 10;
841     }
842 
843     /**
844      * @return The result of safely multiplying x and y, interpreting the operands
845      * as fixed-point decimals of a precise unit.
846      *
847      * @dev The operands should be in the precise unit factor which will be
848      * divided out after the product of x and y is evaluated, so that product must be
849      * less than 2**256.
850      *
851      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
852      * Rounding is useful when you need to retain fidelity for small decimal numbers
853      * (eg. small fractions or percentages).
854      */
855     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
856         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
857     }
858 
859     /**
860      * @return The result of safely multiplying x and y, interpreting the operands
861      * as fixed-point decimals of a standard unit.
862      *
863      * @dev The operands should be in the standard unit factor which will be
864      * divided out after the product of x and y is evaluated, so that product must be
865      * less than 2**256.
866      *
867      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
868      * Rounding is useful when you need to retain fidelity for small decimal numbers
869      * (eg. small fractions or percentages).
870      */
871     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
872         return _multiplyDecimalRound(x, y, UNIT);
873     }
874 
875     /**
876      * @return The result of safely dividing x and y. The return value is a high
877      * precision decimal.
878      *
879      * @dev y is divided after the product of x and the standard precision unit
880      * is evaluated, so the product of x and UNIT must be less than 2**256. As
881      * this is an integer division, the result is always rounded down.
882      * This helps save on gas. Rounding is more expensive on gas.
883      */
884     function divideDecimal(uint x, uint y) internal pure returns (uint) {
885         /* Reintroduce the UNIT factor that will be divided out by y. */
886         return x.mul(UNIT).div(y);
887     }
888 
889     /**
890      * @return The result of safely dividing x and y. The return value is as a rounded
891      * decimal in the precision unit specified in the parameter.
892      *
893      * @dev y is divided after the product of x and the specified precision unit
894      * is evaluated, so the product of x and the specified precision unit must
895      * be less than 2**256. The result is rounded to the nearest increment.
896      */
897     function _divideDecimalRound(
898         uint x,
899         uint y,
900         uint precisionUnit
901     ) private pure returns (uint) {
902         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
903 
904         if (resultTimesTen % 10 >= 5) {
905             resultTimesTen += 10;
906         }
907 
908         return resultTimesTen / 10;
909     }
910 
911     /**
912      * @return The result of safely dividing x and y. The return value is as a rounded
913      * standard precision decimal.
914      *
915      * @dev y is divided after the product of x and the standard precision unit
916      * is evaluated, so the product of x and the standard precision unit must
917      * be less than 2**256. The result is rounded to the nearest increment.
918      */
919     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
920         return _divideDecimalRound(x, y, UNIT);
921     }
922 
923     /**
924      * @return The result of safely dividing x and y. The return value is as a rounded
925      * high precision decimal.
926      *
927      * @dev y is divided after the product of x and the high precision unit
928      * is evaluated, so the product of x and the high precision unit must
929      * be less than 2**256. The result is rounded to the nearest increment.
930      */
931     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
932         return _divideDecimalRound(x, y, PRECISE_UNIT);
933     }
934 
935     /**
936      * @dev Convert a standard decimal representation to a high precision one.
937      */
938     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
939         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
940     }
941 
942     /**
943      * @dev Convert a high precision decimal to a standard decimal representation.
944      */
945     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
946         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
947 
948         if (quotientTimesTen % 10 >= 5) {
949             quotientTimesTen += 10;
950         }
951 
952         return quotientTimesTen / 10;
953     }
954 }
955 
956 
957 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
958 interface ISystemStatus {
959     struct Status {
960         bool canSuspend;
961         bool canResume;
962     }
963 
964     struct Suspension {
965         bool suspended;
966         // reason is an integer code,
967         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
968         uint248 reason;
969     }
970 
971     // Views
972     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
973 
974     function requireSystemActive() external view;
975 
976     function requireIssuanceActive() external view;
977 
978     function requireExchangeActive() external view;
979 
980     function requireSynthActive(bytes32 currencyKey) external view;
981 
982     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
983 
984     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
985 
986     // Restricted functions
987     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
988 
989     function updateAccessControl(
990         bytes32 section,
991         address account,
992         bool canSuspend,
993         bool canResume
994     ) external;
995 }
996 
997 
998 // https://docs.synthetix.io/contracts/source/interfaces/iexchangestate
999 interface IExchangeState {
1000     // Views
1001     struct ExchangeEntry {
1002         bytes32 src;
1003         uint amount;
1004         bytes32 dest;
1005         uint amountReceived;
1006         uint exchangeFeeRate;
1007         uint timestamp;
1008         uint roundIdForSrc;
1009         uint roundIdForDest;
1010     }
1011 
1012     function getLengthOfEntries(address account, bytes32 currencyKey) external view returns (uint);
1013 
1014     function getEntryAt(
1015         address account,
1016         bytes32 currencyKey,
1017         uint index
1018     )
1019         external
1020         view
1021         returns (
1022             bytes32 src,
1023             uint amount,
1024             bytes32 dest,
1025             uint amountReceived,
1026             uint exchangeFeeRate,
1027             uint timestamp,
1028             uint roundIdForSrc,
1029             uint roundIdForDest
1030         );
1031 
1032     function getMaxTimestamp(address account, bytes32 currencyKey) external view returns (uint);
1033 
1034     // Mutative functions
1035     function appendExchangeEntry(
1036         address account,
1037         bytes32 src,
1038         uint amount,
1039         bytes32 dest,
1040         uint amountReceived,
1041         uint exchangeFeeRate,
1042         uint timestamp,
1043         uint roundIdForSrc,
1044         uint roundIdForDest
1045     ) external;
1046 
1047     function removeEntries(address account, bytes32 currencyKey) external;
1048 }
1049 
1050 
1051 // https://docs.synthetix.io/contracts/source/interfaces/iexchangerates
1052 interface IExchangeRates {
1053     // Structs
1054     struct RateAndUpdatedTime {
1055         uint216 rate;
1056         uint40 time;
1057     }
1058 
1059     struct InversePricing {
1060         uint entryPoint;
1061         uint upperLimit;
1062         uint lowerLimit;
1063         bool frozenAtUpperLimit;
1064         bool frozenAtLowerLimit;
1065     }
1066 
1067     // Views
1068     function aggregators(bytes32 currencyKey) external view returns (address);
1069 
1070     function aggregatorWarningFlags() external view returns (address);
1071 
1072     function anyRateIsInvalid(bytes32[] calldata currencyKeys) external view returns (bool);
1073 
1074     function canFreezeRate(bytes32 currencyKey) external view returns (bool);
1075 
1076     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
1077 
1078     function currenciesUsingAggregator(address aggregator) external view returns (bytes32[] memory);
1079 
1080     function effectiveValue(
1081         bytes32 sourceCurrencyKey,
1082         uint sourceAmount,
1083         bytes32 destinationCurrencyKey
1084     ) external view returns (uint value);
1085 
1086     function effectiveValueAndRates(
1087         bytes32 sourceCurrencyKey,
1088         uint sourceAmount,
1089         bytes32 destinationCurrencyKey
1090     )
1091         external
1092         view
1093         returns (
1094             uint value,
1095             uint sourceRate,
1096             uint destinationRate
1097         );
1098 
1099     function effectiveValueAtRound(
1100         bytes32 sourceCurrencyKey,
1101         uint sourceAmount,
1102         bytes32 destinationCurrencyKey,
1103         uint roundIdForSrc,
1104         uint roundIdForDest
1105     ) external view returns (uint value);
1106 
1107     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
1108 
1109     function getLastRoundIdBeforeElapsedSecs(
1110         bytes32 currencyKey,
1111         uint startingRoundId,
1112         uint startingTimestamp,
1113         uint timediff
1114     ) external view returns (uint);
1115 
1116     function inversePricing(bytes32 currencyKey)
1117         external
1118         view
1119         returns (
1120             uint entryPoint,
1121             uint upperLimit,
1122             uint lowerLimit,
1123             bool frozenAtUpperLimit,
1124             bool frozenAtLowerLimit
1125         );
1126 
1127     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
1128 
1129     function oracle() external view returns (address);
1130 
1131     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
1132 
1133     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
1134 
1135     function rateAndInvalid(bytes32 currencyKey) external view returns (uint rate, bool isInvalid);
1136 
1137     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1138 
1139     function rateIsFlagged(bytes32 currencyKey) external view returns (bool);
1140 
1141     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
1142 
1143     function rateIsInvalid(bytes32 currencyKey) external view returns (bool);
1144 
1145     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1146 
1147     function rateStalePeriod() external view returns (uint);
1148 
1149     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
1150         external
1151         view
1152         returns (uint[] memory rates, uint[] memory times);
1153 
1154     function ratesAndInvalidForCurrencies(bytes32[] calldata currencyKeys)
1155         external
1156         view
1157         returns (uint[] memory rates, bool anyRateInvalid);
1158 
1159     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
1160 
1161     // Mutative functions
1162     function freezeRate(bytes32 currencyKey) external;
1163 }
1164 
1165 
1166 // https://docs.synthetix.io/contracts/source/interfaces/isynthetix
1167 interface ISynthetix {
1168     // Views
1169     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
1170 
1171     function availableCurrencyKeys() external view returns (bytes32[] memory);
1172 
1173     function availableSynthCount() external view returns (uint);
1174 
1175     function availableSynths(uint index) external view returns (ISynth);
1176 
1177     function collateral(address account) external view returns (uint);
1178 
1179     function collateralisationRatio(address issuer) external view returns (uint);
1180 
1181     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
1182 
1183     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
1184 
1185     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
1186 
1187     function remainingIssuableSynths(address issuer)
1188         external
1189         view
1190         returns (
1191             uint maxIssuable,
1192             uint alreadyIssued,
1193             uint totalSystemDebt
1194         );
1195 
1196     function synths(bytes32 currencyKey) external view returns (ISynth);
1197 
1198     function synthsByAddress(address synthAddress) external view returns (bytes32);
1199 
1200     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
1201 
1202     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);
1203 
1204     function transferableSynthetix(address account) external view returns (uint transferable);
1205 
1206     // Mutative Functions
1207     function burnSynths(uint amount) external;
1208 
1209     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
1210 
1211     function burnSynthsToTarget() external;
1212 
1213     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
1214 
1215     function exchange(
1216         bytes32 sourceCurrencyKey,
1217         uint sourceAmount,
1218         bytes32 destinationCurrencyKey
1219     ) external returns (uint amountReceived);
1220 
1221     function exchangeOnBehalf(
1222         address exchangeForAddress,
1223         bytes32 sourceCurrencyKey,
1224         uint sourceAmount,
1225         bytes32 destinationCurrencyKey
1226     ) external returns (uint amountReceived);
1227 
1228     function exchangeWithTracking(
1229         bytes32 sourceCurrencyKey,
1230         uint sourceAmount,
1231         bytes32 destinationCurrencyKey,
1232         address originator,
1233         bytes32 trackingCode
1234     ) external returns (uint amountReceived);
1235 
1236     function exchangeOnBehalfWithTracking(
1237         address exchangeForAddress,
1238         bytes32 sourceCurrencyKey,
1239         uint sourceAmount,
1240         bytes32 destinationCurrencyKey,
1241         address originator,
1242         bytes32 trackingCode
1243     ) external returns (uint amountReceived);
1244 
1245     function exchangeWithVirtual(
1246         bytes32 sourceCurrencyKey,
1247         uint sourceAmount,
1248         bytes32 destinationCurrencyKey,
1249         bytes32 trackingCode
1250     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1251 
1252     function issueMaxSynths() external;
1253 
1254     function issueMaxSynthsOnBehalf(address issueForAddress) external;
1255 
1256     function issueSynths(uint amount) external;
1257 
1258     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
1259 
1260     function mint() external returns (bool);
1261 
1262     function settle(bytes32 currencyKey)
1263         external
1264         returns (
1265             uint reclaimed,
1266             uint refunded,
1267             uint numEntries
1268         );
1269 
1270     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
1271 
1272     // Restricted Functions
1273 
1274     function mintSecondary(address account, uint amount) external;
1275 
1276     function mintSecondaryRewards(uint amount) external;
1277 
1278     function burnSecondary(address account, uint amount) external;
1279 }
1280 
1281 
1282 // https://docs.synthetix.io/contracts/source/interfaces/ifeepool
1283 interface IFeePool {
1284     // Views
1285 
1286     // solhint-disable-next-line func-name-mixedcase
1287     function FEE_ADDRESS() external view returns (address);
1288 
1289     function feesAvailable(address account) external view returns (uint, uint);
1290 
1291     function feePeriodDuration() external view returns (uint);
1292 
1293     function isFeesClaimable(address account) external view returns (bool);
1294 
1295     function targetThreshold() external view returns (uint);
1296 
1297     function totalFeesAvailable() external view returns (uint);
1298 
1299     function totalRewardsAvailable() external view returns (uint);
1300 
1301     // Mutative Functions
1302     function claimFees() external returns (bool);
1303 
1304     function claimOnBehalf(address claimingForAddress) external returns (bool);
1305 
1306     function closeCurrentFeePeriod() external;
1307 
1308     // Restricted: used internally to Synthetix
1309     function appendAccountIssuanceRecord(
1310         address account,
1311         uint lockedAmount,
1312         uint debtEntryIndex
1313     ) external;
1314 
1315     function recordFeePaid(uint sUSDAmount) external;
1316 
1317     function setRewardsToDistribute(uint amount) external;
1318 }
1319 
1320 
1321 // https://docs.synthetix.io/contracts/source/interfaces/idelegateapprovals
1322 interface IDelegateApprovals {
1323     // Views
1324     function canBurnFor(address authoriser, address delegate) external view returns (bool);
1325 
1326     function canIssueFor(address authoriser, address delegate) external view returns (bool);
1327 
1328     function canClaimFor(address authoriser, address delegate) external view returns (bool);
1329 
1330     function canExchangeFor(address authoriser, address delegate) external view returns (bool);
1331 
1332     // Mutative
1333     function approveAllDelegatePowers(address delegate) external;
1334 
1335     function removeAllDelegatePowers(address delegate) external;
1336 
1337     function approveBurnOnBehalf(address delegate) external;
1338 
1339     function removeBurnOnBehalf(address delegate) external;
1340 
1341     function approveIssueOnBehalf(address delegate) external;
1342 
1343     function removeIssueOnBehalf(address delegate) external;
1344 
1345     function approveClaimOnBehalf(address delegate) external;
1346 
1347     function removeClaimOnBehalf(address delegate) external;
1348 
1349     function approveExchangeOnBehalf(address delegate) external;
1350 
1351     function removeExchangeOnBehalf(address delegate) external;
1352 }
1353 
1354 
1355 // https://docs.synthetix.io/contracts/source/interfaces/itradingrewards
1356 interface ITradingRewards {
1357     /* ========== VIEWS ========== */
1358 
1359     function getAvailableRewards() external view returns (uint);
1360 
1361     function getUnassignedRewards() external view returns (uint);
1362 
1363     function getRewardsToken() external view returns (address);
1364 
1365     function getPeriodController() external view returns (address);
1366 
1367     function getCurrentPeriod() external view returns (uint);
1368 
1369     function getPeriodIsClaimable(uint periodID) external view returns (bool);
1370 
1371     function getPeriodIsFinalized(uint periodID) external view returns (bool);
1372 
1373     function getPeriodRecordedFees(uint periodID) external view returns (uint);
1374 
1375     function getPeriodTotalRewards(uint periodID) external view returns (uint);
1376 
1377     function getPeriodAvailableRewards(uint periodID) external view returns (uint);
1378 
1379     function getUnaccountedFeesForAccountForPeriod(address account, uint periodID) external view returns (uint);
1380 
1381     function getAvailableRewardsForAccountForPeriod(address account, uint periodID) external view returns (uint);
1382 
1383     function getAvailableRewardsForAccountForPeriods(address account, uint[] calldata periodIDs)
1384         external
1385         view
1386         returns (uint totalRewards);
1387 
1388     /* ========== MUTATIVE FUNCTIONS ========== */
1389 
1390     function claimRewardsForPeriod(uint periodID) external;
1391 
1392     function claimRewardsForPeriods(uint[] calldata periodIDs) external;
1393 
1394     /* ========== RESTRICTED FUNCTIONS ========== */
1395 
1396     function recordExchangeFeeForAccount(uint usdFeeAmount, address account) external;
1397 
1398     function closeCurrentPeriodWithRewards(uint rewards) external;
1399 
1400     function recoverEther(address payable recoverAddress) external;
1401 
1402     function recoverTokens(address tokenAddress, address recoverAddress) external;
1403 
1404     function recoverUnassignedRewardTokens(address recoverAddress) external;
1405 
1406     function recoverAssignedRewardTokensAndDestroyPeriod(address recoverAddress, uint periodID) external;
1407 
1408     function setPeriodController(address newPeriodController) external;
1409 }
1410 
1411 
1412 // https://docs.synthetix.io/contracts/source/interfaces/idebtcache
1413 interface IDebtCache {
1414     // Views
1415 
1416     function cachedDebt() external view returns (uint);
1417 
1418     function cachedSynthDebt(bytes32 currencyKey) external view returns (uint);
1419 
1420     function cacheTimestamp() external view returns (uint);
1421 
1422     function cacheInvalid() external view returns (bool);
1423 
1424     function cacheStale() external view returns (bool);
1425 
1426     function currentSynthDebts(bytes32[] calldata currencyKeys)
1427         external
1428         view
1429         returns (uint[] memory debtValues, bool anyRateIsInvalid);
1430 
1431     function cachedSynthDebts(bytes32[] calldata currencyKeys) external view returns (uint[] memory debtValues);
1432 
1433     function currentDebt() external view returns (uint debt, bool anyRateIsInvalid);
1434 
1435     function cacheInfo()
1436         external
1437         view
1438         returns (
1439             uint debt,
1440             uint timestamp,
1441             bool isInvalid,
1442             bool isStale
1443         );
1444 
1445     // Mutative functions
1446 
1447     function takeDebtSnapshot() external;
1448 
1449     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external;
1450 }
1451 
1452 
1453 // Inheritance
1454 
1455 
1456 // Internal references
1457 
1458 
1459 // https://docs.synthetix.io/contracts/source/contracts/proxy
1460 contract Proxy is Owned {
1461     Proxyable public target;
1462 
1463     constructor(address _owner) public Owned(_owner) {}
1464 
1465     function setTarget(Proxyable _target) external onlyOwner {
1466         target = _target;
1467         emit TargetUpdated(_target);
1468     }
1469 
1470     function _emit(
1471         bytes calldata callData,
1472         uint numTopics,
1473         bytes32 topic1,
1474         bytes32 topic2,
1475         bytes32 topic3,
1476         bytes32 topic4
1477     ) external onlyTarget {
1478         uint size = callData.length;
1479         bytes memory _callData = callData;
1480 
1481         assembly {
1482             /* The first 32 bytes of callData contain its length (as specified by the abi).
1483              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
1484              * in length. It is also leftpadded to be a multiple of 32 bytes.
1485              * This means moving call_data across 32 bytes guarantees we correctly access
1486              * the data itself. */
1487             switch numTopics
1488                 case 0 {
1489                     log0(add(_callData, 32), size)
1490                 }
1491                 case 1 {
1492                     log1(add(_callData, 32), size, topic1)
1493                 }
1494                 case 2 {
1495                     log2(add(_callData, 32), size, topic1, topic2)
1496                 }
1497                 case 3 {
1498                     log3(add(_callData, 32), size, topic1, topic2, topic3)
1499                 }
1500                 case 4 {
1501                     log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
1502                 }
1503         }
1504     }
1505 
1506     // solhint-disable no-complex-fallback
1507     function() external payable {
1508         // Mutable call setting Proxyable.messageSender as this is using call not delegatecall
1509         target.setMessageSender(msg.sender);
1510 
1511         assembly {
1512             let free_ptr := mload(0x40)
1513             calldatacopy(free_ptr, 0, calldatasize)
1514 
1515             /* We must explicitly forward ether to the underlying contract as well. */
1516             let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
1517             returndatacopy(free_ptr, 0, returndatasize)
1518 
1519             if iszero(result) {
1520                 revert(free_ptr, returndatasize)
1521             }
1522             return(free_ptr, returndatasize)
1523         }
1524     }
1525 
1526     modifier onlyTarget {
1527         require(Proxyable(msg.sender) == target, "Must be proxy target");
1528         _;
1529     }
1530 
1531     event TargetUpdated(Proxyable newTarget);
1532 }
1533 
1534 
1535 // Inheritance
1536 
1537 
1538 // Internal references
1539 
1540 
1541 // https://docs.synthetix.io/contracts/source/contracts/proxyable
1542 contract Proxyable is Owned {
1543     // This contract should be treated like an abstract contract
1544 
1545     /* The proxy this contract exists behind. */
1546     Proxy public proxy;
1547     Proxy public integrationProxy;
1548 
1549     /* The caller of the proxy, passed through to this contract.
1550      * Note that every function using this member must apply the onlyProxy or
1551      * optionalProxy modifiers, otherwise their invocations can use stale values. */
1552     address public messageSender;
1553 
1554     constructor(address payable _proxy) internal {
1555         // This contract is abstract, and thus cannot be instantiated directly
1556         require(owner != address(0), "Owner must be set");
1557 
1558         proxy = Proxy(_proxy);
1559         emit ProxyUpdated(_proxy);
1560     }
1561 
1562     function setProxy(address payable _proxy) external onlyOwner {
1563         proxy = Proxy(_proxy);
1564         emit ProxyUpdated(_proxy);
1565     }
1566 
1567     function setIntegrationProxy(address payable _integrationProxy) external onlyOwner {
1568         integrationProxy = Proxy(_integrationProxy);
1569     }
1570 
1571     function setMessageSender(address sender) external onlyProxy {
1572         messageSender = sender;
1573     }
1574 
1575     modifier onlyProxy {
1576         _onlyProxy();
1577         _;
1578     }
1579 
1580     function _onlyProxy() private view {
1581         require(Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy, "Only the proxy can call");
1582     }
1583 
1584     modifier optionalProxy {
1585         _optionalProxy();
1586         _;
1587     }
1588 
1589     function _optionalProxy() private {
1590         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
1591             messageSender = msg.sender;
1592         }
1593     }
1594 
1595     modifier optionalProxy_onlyOwner {
1596         _optionalProxy_onlyOwner();
1597         _;
1598     }
1599 
1600     // solhint-disable-next-line func-name-mixedcase
1601     function _optionalProxy_onlyOwner() private {
1602         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
1603             messageSender = msg.sender;
1604         }
1605         require(messageSender == owner, "Owner only function");
1606     }
1607 
1608     event ProxyUpdated(address proxyAddress);
1609 }
1610 
1611 
1612 /**
1613  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1614  * the optional functions; to access them see `ERC20Detailed`.
1615  */
1616 interface IERC20 {
1617     /**
1618      * @dev Returns the amount of tokens in existence.
1619      */
1620     function totalSupply() external view returns (uint256);
1621 
1622     /**
1623      * @dev Returns the amount of tokens owned by `account`.
1624      */
1625     function balanceOf(address account) external view returns (uint256);
1626 
1627     /**
1628      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1629      *
1630      * Returns a boolean value indicating whether the operation succeeded.
1631      *
1632      * Emits a `Transfer` event.
1633      */
1634     function transfer(address recipient, uint256 amount) external returns (bool);
1635 
1636     /**
1637      * @dev Returns the remaining number of tokens that `spender` will be
1638      * allowed to spend on behalf of `owner` through `transferFrom`. This is
1639      * zero by default.
1640      *
1641      * This value changes when `approve` or `transferFrom` are called.
1642      */
1643     function allowance(address owner, address spender) external view returns (uint256);
1644 
1645     /**
1646      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1647      *
1648      * Returns a boolean value indicating whether the operation succeeded.
1649      *
1650      * > Beware that changing an allowance with this method brings the risk
1651      * that someone may use both the old and the new allowance by unfortunate
1652      * transaction ordering. One possible solution to mitigate this race
1653      * condition is to first reduce the spender's allowance to 0 and set the
1654      * desired value afterwards:
1655      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1656      *
1657      * Emits an `Approval` event.
1658      */
1659     function approve(address spender, uint256 amount) external returns (bool);
1660 
1661     /**
1662      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1663      * allowance mechanism. `amount` is then deducted from the caller's
1664      * allowance.
1665      *
1666      * Returns a boolean value indicating whether the operation succeeded.
1667      *
1668      * Emits a `Transfer` event.
1669      */
1670     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1671 
1672     /**
1673      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1674      * another (`to`).
1675      *
1676      * Note that `value` may be zero.
1677      */
1678     event Transfer(address indexed from, address indexed to, uint256 value);
1679 
1680     /**
1681      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1682      * a call to `approve`. `value` is the new allowance.
1683      */
1684     event Approval(address indexed owner, address indexed spender, uint256 value);
1685 }
1686 
1687 
1688 // Inheritance
1689 
1690 
1691 // Libraries
1692 
1693 
1694 // Internal references
1695 
1696 
1697 // Note: use OZ's IERC20 here as using ours will complain about conflicting names
1698 // during the build (VirtualSynth has IERC20 from the OZ ERC20 implementation)
1699 
1700 
1701 // Used to have strongly-typed access to internal mutative functions in Synthetix
1702 interface ISynthetixInternal {
1703     function emitExchangeTracking(
1704         bytes32 trackingCode,
1705         bytes32 toCurrencyKey,
1706         uint256 toAmount
1707     ) external;
1708 
1709     function emitSynthExchange(
1710         address account,
1711         bytes32 fromCurrencyKey,
1712         uint fromAmount,
1713         bytes32 toCurrencyKey,
1714         uint toAmount,
1715         address toAddress
1716     ) external;
1717 
1718     function emitExchangeReclaim(
1719         address account,
1720         bytes32 currencyKey,
1721         uint amount
1722     ) external;
1723 
1724     function emitExchangeRebate(
1725         address account,
1726         bytes32 currencyKey,
1727         uint amount
1728     ) external;
1729 }
1730 
1731 
1732 interface IExchangerInternalDebtCache {
1733     function updateCachedSynthDebtsWithRates(bytes32[] calldata currencyKeys, uint[] calldata currencyRates) external;
1734 
1735     function updateCachedSynthDebts(bytes32[] calldata currencyKeys) external;
1736 }
1737 
1738 
1739 // https://docs.synthetix.io/contracts/source/contracts/exchanger
1740 contract Exchanger is Owned, MixinResolver, MixinSystemSettings, IExchanger {
1741     using SafeMath for uint;
1742     using SafeDecimalMath for uint;
1743 
1744     struct ExchangeEntrySettlement {
1745         bytes32 src;
1746         uint amount;
1747         bytes32 dest;
1748         uint reclaim;
1749         uint rebate;
1750         uint srcRoundIdAtPeriodEnd;
1751         uint destRoundIdAtPeriodEnd;
1752         uint timestamp;
1753     }
1754 
1755     bytes32 private constant sUSD = "sUSD";
1756 
1757     // SIP-65: Decentralized circuit breaker
1758     uint public constant CIRCUIT_BREAKER_SUSPENSION_REASON = 65;
1759 
1760     mapping(bytes32 => uint) public lastExchangeRate;
1761 
1762     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1763 
1764     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1765     bytes32 private constant CONTRACT_EXCHANGESTATE = "ExchangeState";
1766     bytes32 private constant CONTRACT_EXRATES = "ExchangeRates";
1767     bytes32 private constant CONTRACT_SYNTHETIX = "Synthetix";
1768     bytes32 private constant CONTRACT_FEEPOOL = "FeePool";
1769     bytes32 private constant CONTRACT_TRADING_REWARDS = "TradingRewards";
1770     bytes32 private constant CONTRACT_DELEGATEAPPROVALS = "DelegateApprovals";
1771     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1772     bytes32 private constant CONTRACT_DEBTCACHE = "DebtCache";
1773 
1774     bytes32[24] private addressesToCache = [
1775         CONTRACT_SYSTEMSTATUS,
1776         CONTRACT_EXCHANGESTATE,
1777         CONTRACT_EXRATES,
1778         CONTRACT_SYNTHETIX,
1779         CONTRACT_FEEPOOL,
1780         CONTRACT_TRADING_REWARDS,
1781         CONTRACT_DELEGATEAPPROVALS,
1782         CONTRACT_ISSUER,
1783         CONTRACT_DEBTCACHE
1784     ];
1785 
1786     constructor(address _owner, address _resolver)
1787         public
1788         Owned(_owner)
1789         MixinResolver(_resolver, addressesToCache)
1790         MixinSystemSettings()
1791     {}
1792 
1793     /* ========== VIEWS ========== */
1794 
1795     function systemStatus() internal view returns (ISystemStatus) {
1796         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS, "Missing SystemStatus address"));
1797     }
1798 
1799     function exchangeState() internal view returns (IExchangeState) {
1800         return IExchangeState(requireAndGetAddress(CONTRACT_EXCHANGESTATE, "Missing ExchangeState address"));
1801     }
1802 
1803     function exchangeRates() internal view returns (IExchangeRates) {
1804         return IExchangeRates(requireAndGetAddress(CONTRACT_EXRATES, "Missing ExchangeRates address"));
1805     }
1806 
1807     function synthetix() internal view returns (ISynthetix) {
1808         return ISynthetix(requireAndGetAddress(CONTRACT_SYNTHETIX, "Missing Synthetix address"));
1809     }
1810 
1811     function feePool() internal view returns (IFeePool) {
1812         return IFeePool(requireAndGetAddress(CONTRACT_FEEPOOL, "Missing FeePool address"));
1813     }
1814 
1815     function tradingRewards() internal view returns (ITradingRewards) {
1816         return ITradingRewards(requireAndGetAddress(CONTRACT_TRADING_REWARDS, "Missing TradingRewards address"));
1817     }
1818 
1819     function delegateApprovals() internal view returns (IDelegateApprovals) {
1820         return IDelegateApprovals(requireAndGetAddress(CONTRACT_DELEGATEAPPROVALS, "Missing DelegateApprovals address"));
1821     }
1822 
1823     function issuer() internal view returns (IIssuer) {
1824         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER, "Missing Issuer address"));
1825     }
1826 
1827     function debtCache() internal view returns (IExchangerInternalDebtCache) {
1828         return IExchangerInternalDebtCache(requireAndGetAddress(CONTRACT_DEBTCACHE, "Missing DebtCache address"));
1829     }
1830 
1831     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) public view returns (uint) {
1832         return secsLeftInWaitingPeriodForExchange(exchangeState().getMaxTimestamp(account, currencyKey));
1833     }
1834 
1835     function waitingPeriodSecs() external view returns (uint) {
1836         return getWaitingPeriodSecs();
1837     }
1838 
1839     function tradingRewardsEnabled() external view returns (bool) {
1840         return getTradingRewardsEnabled();
1841     }
1842 
1843     function priceDeviationThresholdFactor() external view returns (uint) {
1844         return getPriceDeviationThresholdFactor();
1845     }
1846 
1847     function settlementOwing(address account, bytes32 currencyKey)
1848         public
1849         view
1850         returns (
1851             uint reclaimAmount,
1852             uint rebateAmount,
1853             uint numEntries
1854         )
1855     {
1856         (reclaimAmount, rebateAmount, numEntries, ) = _settlementOwing(account, currencyKey);
1857     }
1858 
1859     // Internal function to emit events for each individual rebate and reclaim entry
1860     function _settlementOwing(address account, bytes32 currencyKey)
1861         internal
1862         view
1863         returns (
1864             uint reclaimAmount,
1865             uint rebateAmount,
1866             uint numEntries,
1867             ExchangeEntrySettlement[] memory
1868         )
1869     {
1870         // Need to sum up all reclaim and rebate amounts for the user and the currency key
1871         numEntries = exchangeState().getLengthOfEntries(account, currencyKey);
1872 
1873         // For each unsettled exchange
1874         ExchangeEntrySettlement[] memory settlements = new ExchangeEntrySettlement[](numEntries);
1875         for (uint i = 0; i < numEntries; i++) {
1876             uint reclaim;
1877             uint rebate;
1878             // fetch the entry from storage
1879             IExchangeState.ExchangeEntry memory exchangeEntry = _getExchangeEntry(account, currencyKey, i);
1880 
1881             // determine the last round ids for src and dest pairs when period ended or latest if not over
1882             (uint srcRoundIdAtPeriodEnd, uint destRoundIdAtPeriodEnd) = getRoundIdsAtPeriodEnd(exchangeEntry);
1883 
1884             // given these round ids, determine what effective value they should have received
1885             uint destinationAmount = exchangeRates().effectiveValueAtRound(
1886                 exchangeEntry.src,
1887                 exchangeEntry.amount,
1888                 exchangeEntry.dest,
1889                 srcRoundIdAtPeriodEnd,
1890                 destRoundIdAtPeriodEnd
1891             );
1892 
1893             // and deduct the fee from this amount using the exchangeFeeRate from storage
1894             uint amountShouldHaveReceived = _getAmountReceivedForExchange(destinationAmount, exchangeEntry.exchangeFeeRate);
1895 
1896             // SIP-65 settlements where the amount at end of waiting period is beyond the threshold, then
1897             // settle with no reclaim or rebate
1898             if (!_isDeviationAboveThreshold(exchangeEntry.amountReceived, amountShouldHaveReceived)) {
1899                 if (exchangeEntry.amountReceived > amountShouldHaveReceived) {
1900                     // if they received more than they should have, add to the reclaim tally
1901                     reclaim = exchangeEntry.amountReceived.sub(amountShouldHaveReceived);
1902                     reclaimAmount = reclaimAmount.add(reclaim);
1903                 } else if (amountShouldHaveReceived > exchangeEntry.amountReceived) {
1904                     // if less, add to the rebate tally
1905                     rebate = amountShouldHaveReceived.sub(exchangeEntry.amountReceived);
1906                     rebateAmount = rebateAmount.add(rebate);
1907                 }
1908             }
1909 
1910             settlements[i] = ExchangeEntrySettlement({
1911                 src: exchangeEntry.src,
1912                 amount: exchangeEntry.amount,
1913                 dest: exchangeEntry.dest,
1914                 reclaim: reclaim,
1915                 rebate: rebate,
1916                 srcRoundIdAtPeriodEnd: srcRoundIdAtPeriodEnd,
1917                 destRoundIdAtPeriodEnd: destRoundIdAtPeriodEnd,
1918                 timestamp: exchangeEntry.timestamp
1919             });
1920         }
1921 
1922         return (reclaimAmount, rebateAmount, numEntries, settlements);
1923     }
1924 
1925     function _getExchangeEntry(
1926         address account,
1927         bytes32 currencyKey,
1928         uint index
1929     ) internal view returns (IExchangeState.ExchangeEntry memory) {
1930         (
1931             bytes32 src,
1932             uint amount,
1933             bytes32 dest,
1934             uint amountReceived,
1935             uint exchangeFeeRate,
1936             uint timestamp,
1937             uint roundIdForSrc,
1938             uint roundIdForDest
1939         ) = exchangeState().getEntryAt(account, currencyKey, index);
1940 
1941         return
1942             IExchangeState.ExchangeEntry({
1943                 src: src,
1944                 amount: amount,
1945                 dest: dest,
1946                 amountReceived: amountReceived,
1947                 exchangeFeeRate: exchangeFeeRate,
1948                 timestamp: timestamp,
1949                 roundIdForSrc: roundIdForSrc,
1950                 roundIdForDest: roundIdForDest
1951             });
1952     }
1953 
1954     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool) {
1955         if (maxSecsLeftInWaitingPeriod(account, currencyKey) != 0) {
1956             return true;
1957         }
1958 
1959         (uint reclaimAmount, , , ) = _settlementOwing(account, currencyKey);
1960 
1961         return reclaimAmount > 0;
1962     }
1963 
1964     /* ========== SETTERS ========== */
1965 
1966     function calculateAmountAfterSettlement(
1967         address from,
1968         bytes32 currencyKey,
1969         uint amount,
1970         uint refunded
1971     ) public view returns (uint amountAfterSettlement) {
1972         amountAfterSettlement = amount;
1973 
1974         // balance of a synth will show an amount after settlement
1975         uint balanceOfSourceAfterSettlement = IERC20(address(issuer().synths(currencyKey))).balanceOf(from);
1976 
1977         // when there isn't enough supply (either due to reclamation settlement or because the number is too high)
1978         if (amountAfterSettlement > balanceOfSourceAfterSettlement) {
1979             // then the amount to exchange is reduced to their remaining supply
1980             amountAfterSettlement = balanceOfSourceAfterSettlement;
1981         }
1982 
1983         if (refunded > 0) {
1984             amountAfterSettlement = amountAfterSettlement.add(refunded);
1985         }
1986     }
1987 
1988     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool) {
1989         return _isSynthRateInvalid(currencyKey, exchangeRates().rateForCurrency(currencyKey));
1990     }
1991 
1992     /* ========== MUTATIVE FUNCTIONS ========== */
1993     function exchange(
1994         address from,
1995         bytes32 sourceCurrencyKey,
1996         uint sourceAmount,
1997         bytes32 destinationCurrencyKey,
1998         address destinationAddress
1999     ) external onlySynthetixorSynth returns (uint amountReceived) {
2000         uint fee;
2001         (amountReceived, fee, ) = _exchange(
2002             from,
2003             sourceCurrencyKey,
2004             sourceAmount,
2005             destinationCurrencyKey,
2006             destinationAddress,
2007             false
2008         );
2009 
2010         _processTradingRewards(fee, destinationAddress);
2011     }
2012 
2013     function exchangeOnBehalf(
2014         address exchangeForAddress,
2015         address from,
2016         bytes32 sourceCurrencyKey,
2017         uint sourceAmount,
2018         bytes32 destinationCurrencyKey
2019     ) external onlySynthetixorSynth returns (uint amountReceived) {
2020         require(delegateApprovals().canExchangeFor(exchangeForAddress, from), "Not approved to act on behalf");
2021 
2022         uint fee;
2023         (amountReceived, fee, ) = _exchange(
2024             exchangeForAddress,
2025             sourceCurrencyKey,
2026             sourceAmount,
2027             destinationCurrencyKey,
2028             exchangeForAddress,
2029             false
2030         );
2031 
2032         _processTradingRewards(fee, exchangeForAddress);
2033     }
2034 
2035     function exchangeWithTracking(
2036         address from,
2037         bytes32 sourceCurrencyKey,
2038         uint sourceAmount,
2039         bytes32 destinationCurrencyKey,
2040         address destinationAddress,
2041         address originator,
2042         bytes32 trackingCode
2043     ) external onlySynthetixorSynth returns (uint amountReceived) {
2044         uint fee;
2045         (amountReceived, fee, ) = _exchange(
2046             from,
2047             sourceCurrencyKey,
2048             sourceAmount,
2049             destinationCurrencyKey,
2050             destinationAddress,
2051             false
2052         );
2053 
2054         _processTradingRewards(fee, originator);
2055 
2056         _emitTrackingEvent(trackingCode, destinationCurrencyKey, amountReceived);
2057     }
2058 
2059     function exchangeOnBehalfWithTracking(
2060         address exchangeForAddress,
2061         address from,
2062         bytes32 sourceCurrencyKey,
2063         uint sourceAmount,
2064         bytes32 destinationCurrencyKey,
2065         address originator,
2066         bytes32 trackingCode
2067     ) external onlySynthetixorSynth returns (uint amountReceived) {
2068         require(delegateApprovals().canExchangeFor(exchangeForAddress, from), "Not approved to act on behalf");
2069 
2070         uint fee;
2071         (amountReceived, fee, ) = _exchange(
2072             exchangeForAddress,
2073             sourceCurrencyKey,
2074             sourceAmount,
2075             destinationCurrencyKey,
2076             exchangeForAddress,
2077             false
2078         );
2079 
2080         _processTradingRewards(fee, originator);
2081 
2082         _emitTrackingEvent(trackingCode, destinationCurrencyKey, amountReceived);
2083     }
2084 
2085     function exchangeWithVirtual(
2086         address from,
2087         bytes32 sourceCurrencyKey,
2088         uint sourceAmount,
2089         bytes32 destinationCurrencyKey,
2090         address destinationAddress,
2091         bytes32 trackingCode
2092     ) external onlySynthetixorSynth returns (uint amountReceived, IVirtualSynth vSynth) {
2093         uint fee;
2094         (amountReceived, fee, vSynth) = _exchange(
2095             from,
2096             sourceCurrencyKey,
2097             sourceAmount,
2098             destinationCurrencyKey,
2099             destinationAddress,
2100             true
2101         );
2102 
2103         _processTradingRewards(fee, destinationAddress);
2104 
2105         if (trackingCode != bytes32(0)) {
2106             _emitTrackingEvent(trackingCode, destinationCurrencyKey, amountReceived);
2107         }
2108     }
2109 
2110     function _emitTrackingEvent(
2111         bytes32 trackingCode,
2112         bytes32 toCurrencyKey,
2113         uint256 toAmount
2114     ) internal {
2115         ISynthetixInternal(address(synthetix())).emitExchangeTracking(trackingCode, toCurrencyKey, toAmount);
2116     }
2117 
2118     function _processTradingRewards(uint fee, address originator) internal {
2119         if (fee > 0 && originator != address(0) && getTradingRewardsEnabled()) {
2120             tradingRewards().recordExchangeFeeForAccount(fee, originator);
2121         }
2122     }
2123 
2124     function _suspendIfRateInvalid(bytes32 currencyKey, uint rate) internal returns (bool circuitBroken) {
2125         if (_isSynthRateInvalid(currencyKey, rate)) {
2126             systemStatus().suspendSynth(currencyKey, CIRCUIT_BREAKER_SUSPENSION_REASON);
2127             circuitBroken = true;
2128         } else {
2129             lastExchangeRate[currencyKey] = rate;
2130         }
2131     }
2132 
2133     function _updateSNXIssuedDebtOnExchange(bytes32[2] memory currencyKeys, uint[2] memory currencyRates) internal {
2134         bool includesSUSD = currencyKeys[0] == sUSD || currencyKeys[1] == sUSD;
2135         uint numKeys = includesSUSD ? 2 : 3;
2136 
2137         bytes32[] memory keys = new bytes32[](numKeys);
2138         keys[0] = currencyKeys[0];
2139         keys[1] = currencyKeys[1];
2140 
2141         uint[] memory rates = new uint[](numKeys);
2142         rates[0] = currencyRates[0];
2143         rates[1] = currencyRates[1];
2144 
2145         if (!includesSUSD) {
2146             keys[2] = sUSD; // And we'll also update sUSD to account for any fees if it wasn't one of the exchanged currencies
2147             rates[2] = SafeDecimalMath.unit();
2148         }
2149 
2150         // Note that exchanges can't invalidate the debt cache, since if a rate is invalid,
2151         // the exchange will have failed already.
2152         debtCache().updateCachedSynthDebtsWithRates(keys, rates);
2153     }
2154 
2155     function _settleAndCalcSourceAmountRemaining(
2156         uint sourceAmount,
2157         address from,
2158         bytes32 sourceCurrencyKey
2159     ) internal returns (uint sourceAmountAfterSettlement) {
2160         (, uint refunded, uint numEntriesSettled) = _internalSettle(from, sourceCurrencyKey, false);
2161 
2162         sourceAmountAfterSettlement = sourceAmount;
2163 
2164         // when settlement was required
2165         if (numEntriesSettled > 0) {
2166             // ensure the sourceAmount takes this into account
2167             sourceAmountAfterSettlement = calculateAmountAfterSettlement(from, sourceCurrencyKey, sourceAmount, refunded);
2168         }
2169     }
2170 
2171     function _exchange(
2172         address from,
2173         bytes32 sourceCurrencyKey,
2174         uint sourceAmount,
2175         bytes32 destinationCurrencyKey,
2176         address destinationAddress,
2177         bool virtualSynth
2178     )
2179         internal
2180         returns (
2181             uint amountReceived,
2182             uint fee,
2183             IVirtualSynth vSynth
2184         )
2185     {
2186         _ensureCanExchange(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
2187 
2188         uint sourceAmountAfterSettlement = _settleAndCalcSourceAmountRemaining(sourceAmount, from, sourceCurrencyKey);
2189 
2190         // If, after settlement the user has no balance left (highly unlikely), then return to prevent
2191         // emitting events of 0 and don't revert so as to ensure the settlement queue is emptied
2192         if (sourceAmountAfterSettlement == 0) {
2193             return (0, 0, IVirtualSynth(0));
2194         }
2195 
2196         uint exchangeFeeRate;
2197         uint sourceRate;
2198         uint destinationRate;
2199 
2200         // Note: `fee` is denominated in the destinationCurrencyKey.
2201         (amountReceived, fee, exchangeFeeRate, sourceRate, destinationRate) = _getAmountsForExchangeMinusFees(
2202             sourceAmountAfterSettlement,
2203             sourceCurrencyKey,
2204             destinationCurrencyKey
2205         );
2206 
2207         // SIP-65: Decentralized Circuit Breaker
2208         if (
2209             _suspendIfRateInvalid(sourceCurrencyKey, sourceRate) ||
2210             _suspendIfRateInvalid(destinationCurrencyKey, destinationRate)
2211         ) {
2212             return (0, 0, IVirtualSynth(0));
2213         }
2214 
2215         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
2216         // the subtraction to not overflow, which would happen if their balance is not sufficient.
2217 
2218         vSynth = _convert(
2219             sourceCurrencyKey,
2220             from,
2221             sourceAmountAfterSettlement,
2222             destinationCurrencyKey,
2223             amountReceived,
2224             destinationAddress,
2225             virtualSynth
2226         );
2227 
2228         // When using a virtual synth, it becomes the destinationAddress for event and settlement tracking
2229         if (vSynth != IVirtualSynth(0)) {
2230             destinationAddress = address(vSynth);
2231         }
2232 
2233         // Remit the fee if required
2234         if (fee > 0) {
2235             // Normalize fee to sUSD
2236             // Note: `fee` is being reused to avoid stack too deep errors.
2237             fee = exchangeRates().effectiveValue(destinationCurrencyKey, fee, sUSD);
2238 
2239             // Remit the fee in sUSDs
2240             issuer().synths(sUSD).issue(feePool().FEE_ADDRESS(), fee);
2241 
2242             // Tell the fee pool about this
2243             feePool().recordFeePaid(fee);
2244         }
2245 
2246         // Note: As of this point, `fee` is denominated in sUSD.
2247 
2248         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
2249         // But we will update the debt snapshot in case exchange rates have fluctuated since the last exchange
2250         // in these currencies
2251         _updateSNXIssuedDebtOnExchange([sourceCurrencyKey, destinationCurrencyKey], [sourceRate, destinationRate]);
2252 
2253         // Let the DApps know there was a Synth exchange
2254         ISynthetixInternal(address(synthetix())).emitSynthExchange(
2255             from,
2256             sourceCurrencyKey,
2257             sourceAmountAfterSettlement,
2258             destinationCurrencyKey,
2259             amountReceived,
2260             destinationAddress
2261         );
2262 
2263         // persist the exchange information for the dest key
2264         appendExchange(
2265             destinationAddress,
2266             sourceCurrencyKey,
2267             sourceAmountAfterSettlement,
2268             destinationCurrencyKey,
2269             amountReceived,
2270             exchangeFeeRate
2271         );
2272     }
2273 
2274     function _convert(
2275         bytes32 sourceCurrencyKey,
2276         address from,
2277         uint sourceAmountAfterSettlement,
2278         bytes32 destinationCurrencyKey,
2279         uint amountReceived,
2280         address recipient,
2281         bool virtualSynth
2282     ) internal returns (IVirtualSynth vSynth) {
2283         // Burn the source amount
2284         issuer().synths(sourceCurrencyKey).burn(from, sourceAmountAfterSettlement);
2285 
2286         // Issue their new synths
2287         ISynth dest = issuer().synths(destinationCurrencyKey);
2288 
2289         if (virtualSynth) {
2290             Proxyable synth = Proxyable(address(dest));
2291             vSynth = _createVirtualSynth(IERC20(address(synth.proxy())), recipient, amountReceived, destinationCurrencyKey);
2292             dest.issue(address(vSynth), amountReceived);
2293         } else {
2294             dest.issue(recipient, amountReceived);
2295         }
2296     }
2297 
2298     function _createVirtualSynth(
2299         IERC20,
2300         address,
2301         uint,
2302         bytes32
2303     ) internal returns (IVirtualSynth) {
2304         revert("Not supported in this layer");
2305     }
2306 
2307     // Note: this function can intentionally be called by anyone on behalf of anyone else (the caller just pays the gas)
2308     function settle(address from, bytes32 currencyKey)
2309         external
2310         returns (
2311             uint reclaimed,
2312             uint refunded,
2313             uint numEntriesSettled
2314         )
2315     {
2316         systemStatus().requireSynthActive(currencyKey);
2317         return _internalSettle(from, currencyKey, true);
2318     }
2319 
2320     function suspendSynthWithInvalidRate(bytes32 currencyKey) external {
2321         systemStatus().requireSystemActive();
2322         require(issuer().synths(currencyKey) != ISynth(0), "No such synth");
2323         require(_isSynthRateInvalid(currencyKey, exchangeRates().rateForCurrency(currencyKey)), "Synth price is valid");
2324         systemStatus().suspendSynth(currencyKey, CIRCUIT_BREAKER_SUSPENSION_REASON);
2325     }
2326 
2327     // SIP-78
2328     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external onlyExchangeRates {
2329         require(rate > 0, "Rate must be above 0");
2330         lastExchangeRate[currencyKey] = rate;
2331     }
2332 
2333     /* ========== INTERNAL FUNCTIONS ========== */
2334 
2335     function _ensureCanExchange(
2336         bytes32 sourceCurrencyKey,
2337         uint sourceAmount,
2338         bytes32 destinationCurrencyKey
2339     ) internal view {
2340         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
2341         require(sourceAmount > 0, "Zero amount");
2342 
2343         bytes32[] memory synthKeys = new bytes32[](2);
2344         synthKeys[0] = sourceCurrencyKey;
2345         synthKeys[1] = destinationCurrencyKey;
2346         require(!exchangeRates().anyRateIsInvalid(synthKeys), "Src/dest rate invalid or not found");
2347     }
2348 
2349     function _isSynthRateInvalid(bytes32 currencyKey, uint currentRate) internal view returns (bool) {
2350         if (currentRate == 0) {
2351             return true;
2352         }
2353 
2354         uint lastRateFromExchange = lastExchangeRate[currencyKey];
2355 
2356         if (lastRateFromExchange > 0) {
2357             return _isDeviationAboveThreshold(lastRateFromExchange, currentRate);
2358         }
2359 
2360         // if no last exchange for this synth, then we need to look up last 3 rates (+1 for current rate)
2361         (uint[] memory rates, ) = exchangeRates().ratesAndUpdatedTimeForCurrencyLastNRounds(currencyKey, 4);
2362 
2363         // start at index 1 to ignore current rate
2364         for (uint i = 1; i < rates.length; i++) {
2365             // ignore any empty rates in the past (otherwise we will never be able to get validity)
2366             if (rates[i] > 0 && _isDeviationAboveThreshold(rates[i], currentRate)) {
2367                 return true;
2368             }
2369         }
2370 
2371         return false;
2372     }
2373 
2374     function _isDeviationAboveThreshold(uint base, uint comparison) internal view returns (bool) {
2375         if (base == 0 || comparison == 0) {
2376             return true;
2377         }
2378 
2379         uint factor;
2380         if (comparison > base) {
2381             factor = comparison.divideDecimal(base);
2382         } else {
2383             factor = base.divideDecimal(comparison);
2384         }
2385 
2386         return factor >= getPriceDeviationThresholdFactor();
2387     }
2388 
2389     function _internalSettle(
2390         address from,
2391         bytes32 currencyKey,
2392         bool updateCache
2393     )
2394         internal
2395         returns (
2396             uint reclaimed,
2397             uint refunded,
2398             uint numEntriesSettled
2399         )
2400     {
2401         require(maxSecsLeftInWaitingPeriod(from, currencyKey) == 0, "Cannot settle during waiting period");
2402 
2403         (
2404             uint reclaimAmount,
2405             uint rebateAmount,
2406             uint entries,
2407             ExchangeEntrySettlement[] memory settlements
2408         ) = _settlementOwing(from, currencyKey);
2409 
2410         if (reclaimAmount > rebateAmount) {
2411             reclaimed = reclaimAmount.sub(rebateAmount);
2412             reclaim(from, currencyKey, reclaimed);
2413         } else if (rebateAmount > reclaimAmount) {
2414             refunded = rebateAmount.sub(reclaimAmount);
2415             refund(from, currencyKey, refunded);
2416         }
2417 
2418         if (updateCache) {
2419             bytes32[] memory key = new bytes32[](1);
2420             key[0] = currencyKey;
2421             debtCache().updateCachedSynthDebts(key);
2422         }
2423 
2424         // emit settlement event for each settled exchange entry
2425         for (uint i = 0; i < settlements.length; i++) {
2426             emit ExchangeEntrySettled(
2427                 from,
2428                 settlements[i].src,
2429                 settlements[i].amount,
2430                 settlements[i].dest,
2431                 settlements[i].reclaim,
2432                 settlements[i].rebate,
2433                 settlements[i].srcRoundIdAtPeriodEnd,
2434                 settlements[i].destRoundIdAtPeriodEnd,
2435                 settlements[i].timestamp
2436             );
2437         }
2438 
2439         numEntriesSettled = entries;
2440 
2441         // Now remove all entries, even if no reclaim and no rebate
2442         exchangeState().removeEntries(from, currencyKey);
2443     }
2444 
2445     function reclaim(
2446         address from,
2447         bytes32 currencyKey,
2448         uint amount
2449     ) internal {
2450         // burn amount from user
2451         issuer().synths(currencyKey).burn(from, amount);
2452         ISynthetixInternal(address(synthetix())).emitExchangeReclaim(from, currencyKey, amount);
2453     }
2454 
2455     function refund(
2456         address from,
2457         bytes32 currencyKey,
2458         uint amount
2459     ) internal {
2460         // issue amount to user
2461         issuer().synths(currencyKey).issue(from, amount);
2462         ISynthetixInternal(address(synthetix())).emitExchangeRebate(from, currencyKey, amount);
2463     }
2464 
2465     function secsLeftInWaitingPeriodForExchange(uint timestamp) internal view returns (uint) {
2466         uint _waitingPeriodSecs = getWaitingPeriodSecs();
2467         if (timestamp == 0 || now >= timestamp.add(_waitingPeriodSecs)) {
2468             return 0;
2469         }
2470 
2471         return timestamp.add(_waitingPeriodSecs).sub(now);
2472     }
2473 
2474     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
2475         external
2476         view
2477         returns (uint exchangeFeeRate)
2478     {
2479         exchangeFeeRate = _feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
2480     }
2481 
2482     function _feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
2483         internal
2484         view
2485         returns (uint exchangeFeeRate)
2486     {
2487         // Get the exchange fee rate as per destination currencyKey
2488         exchangeFeeRate = getExchangeFeeRate(destinationCurrencyKey);
2489 
2490         if (sourceCurrencyKey == sUSD || destinationCurrencyKey == sUSD) {
2491             return exchangeFeeRate;
2492         }
2493 
2494         // Is this a swing trade? long to short or short to long skipping sUSD.
2495         if (
2496             (sourceCurrencyKey[0] == 0x73 && destinationCurrencyKey[0] == 0x69) ||
2497             (sourceCurrencyKey[0] == 0x69 && destinationCurrencyKey[0] == 0x73)
2498         ) {
2499             // Double the exchange fee
2500             exchangeFeeRate = exchangeFeeRate.mul(2);
2501         }
2502 
2503         return exchangeFeeRate;
2504     }
2505 
2506     function getAmountsForExchange(
2507         uint sourceAmount,
2508         bytes32 sourceCurrencyKey,
2509         bytes32 destinationCurrencyKey
2510     )
2511         external
2512         view
2513         returns (
2514             uint amountReceived,
2515             uint fee,
2516             uint exchangeFeeRate
2517         )
2518     {
2519         (amountReceived, fee, exchangeFeeRate, , ) = _getAmountsForExchangeMinusFees(
2520             sourceAmount,
2521             sourceCurrencyKey,
2522             destinationCurrencyKey
2523         );
2524     }
2525 
2526     function _getAmountsForExchangeMinusFees(
2527         uint sourceAmount,
2528         bytes32 sourceCurrencyKey,
2529         bytes32 destinationCurrencyKey
2530     )
2531         internal
2532         view
2533         returns (
2534             uint amountReceived,
2535             uint fee,
2536             uint exchangeFeeRate,
2537             uint sourceRate,
2538             uint destinationRate
2539         )
2540     {
2541         uint destinationAmount;
2542         (destinationAmount, sourceRate, destinationRate) = exchangeRates().effectiveValueAndRates(
2543             sourceCurrencyKey,
2544             sourceAmount,
2545             destinationCurrencyKey
2546         );
2547         exchangeFeeRate = _feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
2548         amountReceived = _getAmountReceivedForExchange(destinationAmount, exchangeFeeRate);
2549         fee = destinationAmount.sub(amountReceived);
2550     }
2551 
2552     function _getAmountReceivedForExchange(uint destinationAmount, uint exchangeFeeRate)
2553         internal
2554         pure
2555         returns (uint amountReceived)
2556     {
2557         amountReceived = destinationAmount.multiplyDecimal(SafeDecimalMath.unit().sub(exchangeFeeRate));
2558     }
2559 
2560     function appendExchange(
2561         address account,
2562         bytes32 src,
2563         uint amount,
2564         bytes32 dest,
2565         uint amountReceived,
2566         uint exchangeFeeRate
2567     ) internal {
2568         IExchangeRates exRates = exchangeRates();
2569         uint roundIdForSrc = exRates.getCurrentRoundId(src);
2570         uint roundIdForDest = exRates.getCurrentRoundId(dest);
2571         exchangeState().appendExchangeEntry(
2572             account,
2573             src,
2574             amount,
2575             dest,
2576             amountReceived,
2577             exchangeFeeRate,
2578             now,
2579             roundIdForSrc,
2580             roundIdForDest
2581         );
2582 
2583         emit ExchangeEntryAppended(
2584             account,
2585             src,
2586             amount,
2587             dest,
2588             amountReceived,
2589             exchangeFeeRate,
2590             roundIdForSrc,
2591             roundIdForDest
2592         );
2593     }
2594 
2595     function getRoundIdsAtPeriodEnd(IExchangeState.ExchangeEntry memory exchangeEntry)
2596         internal
2597         view
2598         returns (uint srcRoundIdAtPeriodEnd, uint destRoundIdAtPeriodEnd)
2599     {
2600         IExchangeRates exRates = exchangeRates();
2601         uint _waitingPeriodSecs = getWaitingPeriodSecs();
2602 
2603         srcRoundIdAtPeriodEnd = exRates.getLastRoundIdBeforeElapsedSecs(
2604             exchangeEntry.src,
2605             exchangeEntry.roundIdForSrc,
2606             exchangeEntry.timestamp,
2607             _waitingPeriodSecs
2608         );
2609         destRoundIdAtPeriodEnd = exRates.getLastRoundIdBeforeElapsedSecs(
2610             exchangeEntry.dest,
2611             exchangeEntry.roundIdForDest,
2612             exchangeEntry.timestamp,
2613             _waitingPeriodSecs
2614         );
2615     }
2616 
2617     // ========== MODIFIERS ==========
2618 
2619     modifier onlySynthetixorSynth() {
2620         ISynthetix _synthetix = synthetix();
2621         require(
2622             msg.sender == address(_synthetix) || _synthetix.synthsByAddress(msg.sender) != bytes32(0),
2623             "Exchanger: Only synthetix or a synth contract can perform this action"
2624         );
2625         _;
2626     }
2627 
2628     modifier onlyExchangeRates() {
2629         IExchangeRates _exchangeRates = exchangeRates();
2630         require(msg.sender == address(_exchangeRates), "Restricted to ExchangeRates");
2631         _;
2632     }
2633 
2634     // ========== EVENTS ==========
2635     event ExchangeEntryAppended(
2636         address indexed account,
2637         bytes32 src,
2638         uint256 amount,
2639         bytes32 dest,
2640         uint256 amountReceived,
2641         uint256 exchangeFeeRate,
2642         uint256 roundIdForSrc,
2643         uint256 roundIdForDest
2644     );
2645 
2646     event ExchangeEntrySettled(
2647         address indexed from,
2648         bytes32 src,
2649         uint256 amount,
2650         bytes32 dest,
2651         uint256 reclaim,
2652         uint256 rebate,
2653         uint256 srcRoundIdAtPeriodEnd,
2654         uint256 destRoundIdAtPeriodEnd,
2655         uint256 exchangeTimestamp
2656     );
2657 }
2658 
2659 
2660 /**
2661  * @dev Implementation of the `IERC20` interface.
2662  *
2663  * This implementation is agnostic to the way tokens are created. This means
2664  * that a supply mechanism has to be added in a derived contract using `_mint`.
2665  * For a generic mechanism see `ERC20Mintable`.
2666  *
2667  * *For a detailed writeup see our guide [How to implement supply
2668  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
2669  *
2670  * We have followed general OpenZeppelin guidelines: functions revert instead
2671  * of returning `false` on failure. This behavior is nonetheless conventional
2672  * and does not conflict with the expectations of ERC20 applications.
2673  *
2674  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
2675  * This allows applications to reconstruct the allowance for all accounts just
2676  * by listening to said events. Other implementations of the EIP may not emit
2677  * these events, as it isn't required by the specification.
2678  *
2679  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
2680  * functions have been added to mitigate the well-known issues around setting
2681  * allowances. See `IERC20.approve`.
2682  */
2683 contract ERC20 is IERC20 {
2684     using SafeMath for uint256;
2685 
2686     mapping (address => uint256) private _balances;
2687 
2688     mapping (address => mapping (address => uint256)) private _allowances;
2689 
2690     uint256 private _totalSupply;
2691 
2692     /**
2693      * @dev See `IERC20.totalSupply`.
2694      */
2695     function totalSupply() public view returns (uint256) {
2696         return _totalSupply;
2697     }
2698 
2699     /**
2700      * @dev See `IERC20.balanceOf`.
2701      */
2702     function balanceOf(address account) public view returns (uint256) {
2703         return _balances[account];
2704     }
2705 
2706     /**
2707      * @dev See `IERC20.transfer`.
2708      *
2709      * Requirements:
2710      *
2711      * - `recipient` cannot be the zero address.
2712      * - the caller must have a balance of at least `amount`.
2713      */
2714     function transfer(address recipient, uint256 amount) public returns (bool) {
2715         _transfer(msg.sender, recipient, amount);
2716         return true;
2717     }
2718 
2719     /**
2720      * @dev See `IERC20.allowance`.
2721      */
2722     function allowance(address owner, address spender) public view returns (uint256) {
2723         return _allowances[owner][spender];
2724     }
2725 
2726     /**
2727      * @dev See `IERC20.approve`.
2728      *
2729      * Requirements:
2730      *
2731      * - `spender` cannot be the zero address.
2732      */
2733     function approve(address spender, uint256 value) public returns (bool) {
2734         _approve(msg.sender, spender, value);
2735         return true;
2736     }
2737 
2738     /**
2739      * @dev See `IERC20.transferFrom`.
2740      *
2741      * Emits an `Approval` event indicating the updated allowance. This is not
2742      * required by the EIP. See the note at the beginning of `ERC20`;
2743      *
2744      * Requirements:
2745      * - `sender` and `recipient` cannot be the zero address.
2746      * - `sender` must have a balance of at least `value`.
2747      * - the caller must have allowance for `sender`'s tokens of at least
2748      * `amount`.
2749      */
2750     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
2751         _transfer(sender, recipient, amount);
2752         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
2753         return true;
2754     }
2755 
2756     /**
2757      * @dev Atomically increases the allowance granted to `spender` by the caller.
2758      *
2759      * This is an alternative to `approve` that can be used as a mitigation for
2760      * problems described in `IERC20.approve`.
2761      *
2762      * Emits an `Approval` event indicating the updated allowance.
2763      *
2764      * Requirements:
2765      *
2766      * - `spender` cannot be the zero address.
2767      */
2768     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
2769         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
2770         return true;
2771     }
2772 
2773     /**
2774      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2775      *
2776      * This is an alternative to `approve` that can be used as a mitigation for
2777      * problems described in `IERC20.approve`.
2778      *
2779      * Emits an `Approval` event indicating the updated allowance.
2780      *
2781      * Requirements:
2782      *
2783      * - `spender` cannot be the zero address.
2784      * - `spender` must have allowance for the caller of at least
2785      * `subtractedValue`.
2786      */
2787     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
2788         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
2789         return true;
2790     }
2791 
2792     /**
2793      * @dev Moves tokens `amount` from `sender` to `recipient`.
2794      *
2795      * This is internal function is equivalent to `transfer`, and can be used to
2796      * e.g. implement automatic token fees, slashing mechanisms, etc.
2797      *
2798      * Emits a `Transfer` event.
2799      *
2800      * Requirements:
2801      *
2802      * - `sender` cannot be the zero address.
2803      * - `recipient` cannot be the zero address.
2804      * - `sender` must have a balance of at least `amount`.
2805      */
2806     function _transfer(address sender, address recipient, uint256 amount) internal {
2807         require(sender != address(0), "ERC20: transfer from the zero address");
2808         require(recipient != address(0), "ERC20: transfer to the zero address");
2809 
2810         _balances[sender] = _balances[sender].sub(amount);
2811         _balances[recipient] = _balances[recipient].add(amount);
2812         emit Transfer(sender, recipient, amount);
2813     }
2814 
2815     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2816      * the total supply.
2817      *
2818      * Emits a `Transfer` event with `from` set to the zero address.
2819      *
2820      * Requirements
2821      *
2822      * - `to` cannot be the zero address.
2823      */
2824     function _mint(address account, uint256 amount) internal {
2825         require(account != address(0), "ERC20: mint to the zero address");
2826 
2827         _totalSupply = _totalSupply.add(amount);
2828         _balances[account] = _balances[account].add(amount);
2829         emit Transfer(address(0), account, amount);
2830     }
2831 
2832      /**
2833      * @dev Destoys `amount` tokens from `account`, reducing the
2834      * total supply.
2835      *
2836      * Emits a `Transfer` event with `to` set to the zero address.
2837      *
2838      * Requirements
2839      *
2840      * - `account` cannot be the zero address.
2841      * - `account` must have at least `amount` tokens.
2842      */
2843     function _burn(address account, uint256 value) internal {
2844         require(account != address(0), "ERC20: burn from the zero address");
2845 
2846         _totalSupply = _totalSupply.sub(value);
2847         _balances[account] = _balances[account].sub(value);
2848         emit Transfer(account, address(0), value);
2849     }
2850 
2851     /**
2852      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
2853      *
2854      * This is internal function is equivalent to `approve`, and can be used to
2855      * e.g. set automatic allowances for certain subsystems, etc.
2856      *
2857      * Emits an `Approval` event.
2858      *
2859      * Requirements:
2860      *
2861      * - `owner` cannot be the zero address.
2862      * - `spender` cannot be the zero address.
2863      */
2864     function _approve(address owner, address spender, uint256 value) internal {
2865         require(owner != address(0), "ERC20: approve from the zero address");
2866         require(spender != address(0), "ERC20: approve to the zero address");
2867 
2868         _allowances[owner][spender] = value;
2869         emit Approval(owner, spender, value);
2870     }
2871 
2872     /**
2873      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
2874      * from the caller's allowance.
2875      *
2876      * See `_burn` and `_approve`.
2877      */
2878     function _burnFrom(address account, uint256 amount) internal {
2879         _burn(account, amount);
2880         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
2881     }
2882 }
2883 
2884 
2885 // Inheritance
2886 
2887 
2888 // Libraries
2889 
2890 
2891 // Internal references
2892 
2893 
2894 // Note: use OZ's IERC20 here as using ours will complain about conflicting names
2895 // during the build
2896 
2897 
2898 // https://docs.synthetix.io/contracts/source/contracts/virtualsynth
2899 contract VirtualSynth is ERC20, IVirtualSynth {
2900     using SafeMath for uint;
2901     using SafeDecimalMath for uint;
2902 
2903     IERC20 public synth;
2904     IAddressResolver public resolver;
2905 
2906     bool public settled = false;
2907 
2908     uint8 public constant decimals = 18;
2909 
2910     // track initial supply so we can calculate the rate even after all supply is burned
2911     uint public initialSupply;
2912 
2913     // track final settled amount of the synth so we can calculate the rate after settlement
2914     uint public settledAmount;
2915 
2916     bytes32 public currencyKey;
2917 
2918     constructor(
2919         IERC20 _synth,
2920         IAddressResolver _resolver,
2921         address _recipient,
2922         uint _amount,
2923         bytes32 _currencyKey
2924     ) public ERC20() {
2925         synth = _synth;
2926         resolver = _resolver;
2927         currencyKey = _currencyKey;
2928 
2929         // Assumption: the synth will be issued to us within the same transaction,
2930         // and this supply matches that
2931         _mint(_recipient, _amount);
2932 
2933         initialSupply = _amount;
2934     }
2935 
2936     // INTERNALS
2937 
2938     function exchanger() internal view returns (IExchanger) {
2939         return IExchanger(resolver.requireAndGetAddress("Exchanger", "Exchanger contract not found"));
2940     }
2941 
2942     function secsLeft() internal view returns (uint) {
2943         return exchanger().maxSecsLeftInWaitingPeriod(address(this), currencyKey);
2944     }
2945 
2946     function calcRate() internal view returns (uint) {
2947         if (initialSupply == 0) {
2948             return 0;
2949         }
2950 
2951         uint synthBalance;
2952 
2953         if (!settled) {
2954             synthBalance = IERC20(address(synth)).balanceOf(address(this));
2955             (uint reclaim, uint rebate, ) = exchanger().settlementOwing(address(this), currencyKey);
2956 
2957             if (reclaim > 0) {
2958                 synthBalance = synthBalance.sub(reclaim);
2959             } else if (rebate > 0) {
2960                 synthBalance = synthBalance.add(rebate);
2961             }
2962         } else {
2963             synthBalance = settledAmount;
2964         }
2965 
2966         return synthBalance.divideDecimalRound(initialSupply);
2967     }
2968 
2969     function balanceUnderlying(address account) internal view returns (uint) {
2970         uint vBalanceOfAccount = balanceOf(account);
2971 
2972         return vBalanceOfAccount.multiplyDecimalRound(calcRate());
2973     }
2974 
2975     function settleSynth() internal {
2976         if (settled) {
2977             return;
2978         }
2979         settled = true;
2980 
2981         exchanger().settle(address(this), currencyKey);
2982 
2983         settledAmount = IERC20(address(synth)).balanceOf(address(this));
2984 
2985         emit Settled(totalSupply(), settledAmount);
2986     }
2987 
2988     // VIEWS
2989 
2990     function name() external view returns (string memory) {
2991         return string(abi.encodePacked("Virtual Synth ", currencyKey));
2992     }
2993 
2994     function symbol() external view returns (string memory) {
2995         return string(abi.encodePacked("v", currencyKey));
2996     }
2997 
2998     // get the rate of the vSynth to the synth.
2999     function rate() external view returns (uint) {
3000         return calcRate();
3001     }
3002 
3003     // show the balance of the underlying synth that the given address has, given
3004     // their proportion of totalSupply
3005     function balanceOfUnderlying(address account) external view returns (uint) {
3006         return balanceUnderlying(account);
3007     }
3008 
3009     function secsLeftInWaitingPeriod() external view returns (uint) {
3010         return secsLeft();
3011     }
3012 
3013     function readyToSettle() external view returns (bool) {
3014         return secsLeft() == 0;
3015     }
3016 
3017     // PUBLIC FUNCTIONS
3018 
3019     // Perform settlement of the underlying exchange if required,
3020     // then burn the accounts vSynths and transfer them their owed balanceOfUnderlying
3021     function settle(address account) external {
3022         settleSynth();
3023 
3024         IERC20(address(synth)).transfer(account, balanceUnderlying(account));
3025 
3026         _burn(account, balanceOf(account));
3027     }
3028 
3029     event Settled(uint totalSupply, uint amountAfterSettled);
3030 }
3031 
3032 
3033 // Inheritance
3034 
3035 
3036 // Internal references
3037 
3038 
3039 // https://docs.synthetix.io/contracts/source/contracts/exchangerwithvirtualsynth
3040 contract ExchangerWithVirtualSynth is Exchanger {
3041     constructor(address _owner, address _resolver) public Exchanger(_owner, _resolver) {}
3042 
3043     function _createVirtualSynth(
3044         IERC20 synth,
3045         address recipient,
3046         uint amount,
3047         bytes32 currencyKey
3048     ) internal returns (IVirtualSynth vSynth) {
3049         // prevent inverse synths from being allowed due to purgeability
3050         require(currencyKey[0] != 0x69, "Cannot virtualize this synth");
3051 
3052         vSynth = new VirtualSynth(synth, resolver, recipient, amount, currencyKey);
3053         emit VirtualSynthCreated(address(synth), recipient, address(vSynth), currencyKey, amount);
3054     }
3055 
3056     event VirtualSynthCreated(
3057         address indexed synth,
3058         address indexed recipient,
3059         address vSynth,
3060         bytes32 currencyKey,
3061         uint amount
3062     );
3063 }
3064 
3065     