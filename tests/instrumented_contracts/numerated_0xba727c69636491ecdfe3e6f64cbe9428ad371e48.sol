1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: ExchangeRates.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/ExchangeRates.sol
11 * Docs: https://docs.synthetix.io/contracts/ExchangeRates
12 *
13 * Contract Dependencies: 
14 *	- IExchangeRates
15 *	- Owned
16 *	- SelfDestructible
17 * Libraries: 
18 *	- SafeDecimalMath
19 *	- SafeMath
20 *
21 * MIT License
22 * ===========
23 *
24 * Copyright (c) 2020 Synthetix
25 *
26 * Permission is hereby granted, free of charge, to any person obtaining a copy
27 * of this software and associated documentation files (the "Software"), to deal
28 * in the Software without restriction, including without limitation the rights
29 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
30 * copies of the Software, and to permit persons to whom the Software is
31 * furnished to do so, subject to the following conditions:
32 *
33 * The above copyright notice and this permission notice shall be included in all
34 * copies or substantial portions of the Software.
35 *
36 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
37 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
38 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
39 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
40 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
41 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
42 */
43 
44 /* ===============================================
45 * Flattened with Solidifier by Coinage
46 * 
47 * https://solidifier.coina.ge
48 * ===============================================
49 */
50 
51 
52 pragma solidity ^0.5.16;
53 
54 
55 // https://docs.synthetix.io/contracts/Owned
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
79         require(msg.sender == owner, "Only the contract owner may perform this action");
80         _;
81     }
82 
83     event OwnerNominated(address newOwner);
84     event OwnerChanged(address oldOwner, address newOwner);
85 }
86 
87 
88 // Inheritance
89 
90 
91 // https://docs.synthetix.io/contracts/SelfDestructible
92 contract SelfDestructible is Owned {
93     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
94 
95     uint public initiationTime;
96     bool public selfDestructInitiated;
97 
98     address public selfDestructBeneficiary;
99 
100     constructor() internal {
101         // This contract is abstract, and thus cannot be instantiated directly
102         require(owner != address(0), "Owner must be set");
103         selfDestructBeneficiary = owner;
104         emit SelfDestructBeneficiaryUpdated(owner);
105     }
106 
107     /**
108      * @notice Set the beneficiary address of this contract.
109      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
110      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
111      */
112     function setSelfDestructBeneficiary(address payable _beneficiary) external onlyOwner {
113         require(_beneficiary != address(0), "Beneficiary must not be zero");
114         selfDestructBeneficiary = _beneficiary;
115         emit SelfDestructBeneficiaryUpdated(_beneficiary);
116     }
117 
118     /**
119      * @notice Begin the self-destruction counter of this contract.
120      * Once the delay has elapsed, the contract may be self-destructed.
121      * @dev Only the contract owner may call this.
122      */
123     function initiateSelfDestruct() external onlyOwner {
124         initiationTime = now;
125         selfDestructInitiated = true;
126         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
127     }
128 
129     /**
130      * @notice Terminate and reset the self-destruction timer.
131      * @dev Only the contract owner may call this.
132      */
133     function terminateSelfDestruct() external onlyOwner {
134         initiationTime = 0;
135         selfDestructInitiated = false;
136         emit SelfDestructTerminated();
137     }
138 
139     /**
140      * @notice If the self-destruction delay has elapsed, destroy this contract and
141      * remit any ether it owns to the beneficiary address.
142      * @dev Only the contract owner may call this.
143      */
144     function selfDestruct() external onlyOwner {
145         require(selfDestructInitiated, "Self Destruct not yet initiated");
146         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay not met");
147         emit SelfDestructed(selfDestructBeneficiary);
148         selfdestruct(address(uint160(selfDestructBeneficiary)));
149     }
150 
151     event SelfDestructTerminated();
152     event SelfDestructed(address beneficiary);
153     event SelfDestructInitiated(uint selfDestructDelay);
154     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
155 }
156 
157 
158 // https://docs.synthetix.io/contracts/source/interfaces/IExchangeRates
159 interface IExchangeRates {
160     // Views
161     function aggregators(bytes32 currencyKey) external view returns (address);
162 
163     function anyRateIsStale(bytes32[] calldata currencyKeys) external view returns (bool);
164 
165     function currentRoundForRate(bytes32 currencyKey) external view returns (uint);
166 
167     function effectiveValue(
168         bytes32 sourceCurrencyKey,
169         uint sourceAmount,
170         bytes32 destinationCurrencyKey
171     ) external view returns (uint value);
172 
173     function effectiveValueAndRates(
174         bytes32 sourceCurrencyKey,
175         uint sourceAmount,
176         bytes32 destinationCurrencyKey
177     )
178         external
179         view
180         returns (
181             uint value,
182             uint sourceRate,
183             uint destinationRate
184         );
185 
186     function effectiveValueAtRound(
187         bytes32 sourceCurrencyKey,
188         uint sourceAmount,
189         bytes32 destinationCurrencyKey,
190         uint roundIdForSrc,
191         uint roundIdForDest
192     ) external view returns (uint value);
193 
194     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
195 
196     function getLastRoundIdBeforeElapsedSecs(
197         bytes32 currencyKey,
198         uint startingRoundId,
199         uint startingTimestamp,
200         uint timediff
201     ) external view returns (uint);
202 
203     function inversePricing(bytes32 currencyKey)
204         external
205         view
206         returns (
207             uint entryPoint,
208             uint upperLimit,
209             uint lowerLimit,
210             bool frozen
211         );
212 
213     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256);
214 
215     function oracle() external view returns (address);
216 
217     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
218 
219     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time);
220 
221     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
222 
223     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
224 
225     function rateIsStale(bytes32 currencyKey) external view returns (bool);
226 
227     function rateStalePeriod() external view returns (uint);
228 
229     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
230         external
231         view
232         returns (uint[] memory rates, uint[] memory times);
233 
234     function ratesAndStaleForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory, bool);
235 
236     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory);
237 }
238 
239 
240 /**
241  * @dev Wrappers over Solidity's arithmetic operations with added overflow
242  * checks.
243  *
244  * Arithmetic operations in Solidity wrap on overflow. This can easily result
245  * in bugs, because programmers usually assume that an overflow raises an
246  * error, which is the standard behavior in high level programming languages.
247  * `SafeMath` restores this intuition by reverting the transaction when an
248  * operation overflows.
249  *
250  * Using this library instead of the unchecked operations eliminates an entire
251  * class of bugs, so it's recommended to use it always.
252  */
253 library SafeMath {
254     /**
255      * @dev Returns the addition of two unsigned integers, reverting on
256      * overflow.
257      *
258      * Counterpart to Solidity's `+` operator.
259      *
260      * Requirements:
261      * - Addition cannot overflow.
262      */
263     function add(uint256 a, uint256 b) internal pure returns (uint256) {
264         uint256 c = a + b;
265         require(c >= a, "SafeMath: addition overflow");
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting on
272      * overflow (when the result is negative).
273      *
274      * Counterpart to Solidity's `-` operator.
275      *
276      * Requirements:
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
280         require(b <= a, "SafeMath: subtraction overflow");
281         uint256 c = a - b;
282 
283         return c;
284     }
285 
286     /**
287      * @dev Returns the multiplication of two unsigned integers, reverting on
288      * overflow.
289      *
290      * Counterpart to Solidity's `*` operator.
291      *
292      * Requirements:
293      * - Multiplication cannot overflow.
294      */
295     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
296         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
297         // benefit is lost if 'b' is also tested.
298         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
299         if (a == 0) {
300             return 0;
301         }
302 
303         uint256 c = a * b;
304         require(c / a == b, "SafeMath: multiplication overflow");
305 
306         return c;
307     }
308 
309     /**
310      * @dev Returns the integer division of two unsigned integers. Reverts on
311      * division by zero. The result is rounded towards zero.
312      *
313      * Counterpart to Solidity's `/` operator. Note: this function uses a
314      * `revert` opcode (which leaves remaining gas untouched) while Solidity
315      * uses an invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      * - The divisor cannot be zero.
319      */
320     function div(uint256 a, uint256 b) internal pure returns (uint256) {
321         // Solidity only automatically asserts when dividing by 0
322         require(b > 0, "SafeMath: division by zero");
323         uint256 c = a / b;
324         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
325 
326         return c;
327     }
328 
329     /**
330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
331      * Reverts when dividing by zero.
332      *
333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
334      * opcode (which leaves remaining gas untouched) while Solidity uses an
335      * invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      * - The divisor cannot be zero.
339      */
340     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
341         require(b != 0, "SafeMath: modulo by zero");
342         return a % b;
343     }
344 }
345 
346 
347 // Libraries
348 
349 
350 // https://docs.synthetix.io/contracts/SafeDecimalMath
351 library SafeDecimalMath {
352     using SafeMath for uint;
353 
354     /* Number of decimal places in the representations. */
355     uint8 public constant decimals = 18;
356     uint8 public constant highPrecisionDecimals = 27;
357 
358     /* The number representing 1.0. */
359     uint public constant UNIT = 10**uint(decimals);
360 
361     /* The number representing 1.0 for higher fidelity numbers. */
362     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
363     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
364 
365     /**
366      * @return Provides an interface to UNIT.
367      */
368     function unit() external pure returns (uint) {
369         return UNIT;
370     }
371 
372     /**
373      * @return Provides an interface to PRECISE_UNIT.
374      */
375     function preciseUnit() external pure returns (uint) {
376         return PRECISE_UNIT;
377     }
378 
379     /**
380      * @return The result of multiplying x and y, interpreting the operands as fixed-point
381      * decimals.
382      *
383      * @dev A unit factor is divided out after the product of x and y is evaluated,
384      * so that product must be less than 2**256. As this is an integer division,
385      * the internal division always rounds down. This helps save on gas. Rounding
386      * is more expensive on gas.
387      */
388     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
389         /* Divide by UNIT to remove the extra factor introduced by the product. */
390         return x.mul(y) / UNIT;
391     }
392 
393     /**
394      * @return The result of safely multiplying x and y, interpreting the operands
395      * as fixed-point decimals of the specified precision unit.
396      *
397      * @dev The operands should be in the form of a the specified unit factor which will be
398      * divided out after the product of x and y is evaluated, so that product must be
399      * less than 2**256.
400      *
401      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
402      * Rounding is useful when you need to retain fidelity for small decimal numbers
403      * (eg. small fractions or percentages).
404      */
405     function _multiplyDecimalRound(
406         uint x,
407         uint y,
408         uint precisionUnit
409     ) private pure returns (uint) {
410         /* Divide by UNIT to remove the extra factor introduced by the product. */
411         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
412 
413         if (quotientTimesTen % 10 >= 5) {
414             quotientTimesTen += 10;
415         }
416 
417         return quotientTimesTen / 10;
418     }
419 
420     /**
421      * @return The result of safely multiplying x and y, interpreting the operands
422      * as fixed-point decimals of a precise unit.
423      *
424      * @dev The operands should be in the precise unit factor which will be
425      * divided out after the product of x and y is evaluated, so that product must be
426      * less than 2**256.
427      *
428      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
429      * Rounding is useful when you need to retain fidelity for small decimal numbers
430      * (eg. small fractions or percentages).
431      */
432     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
433         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
434     }
435 
436     /**
437      * @return The result of safely multiplying x and y, interpreting the operands
438      * as fixed-point decimals of a standard unit.
439      *
440      * @dev The operands should be in the standard unit factor which will be
441      * divided out after the product of x and y is evaluated, so that product must be
442      * less than 2**256.
443      *
444      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
445      * Rounding is useful when you need to retain fidelity for small decimal numbers
446      * (eg. small fractions or percentages).
447      */
448     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
449         return _multiplyDecimalRound(x, y, UNIT);
450     }
451 
452     /**
453      * @return The result of safely dividing x and y. The return value is a high
454      * precision decimal.
455      *
456      * @dev y is divided after the product of x and the standard precision unit
457      * is evaluated, so the product of x and UNIT must be less than 2**256. As
458      * this is an integer division, the result is always rounded down.
459      * This helps save on gas. Rounding is more expensive on gas.
460      */
461     function divideDecimal(uint x, uint y) internal pure returns (uint) {
462         /* Reintroduce the UNIT factor that will be divided out by y. */
463         return x.mul(UNIT).div(y);
464     }
465 
466     /**
467      * @return The result of safely dividing x and y. The return value is as a rounded
468      * decimal in the precision unit specified in the parameter.
469      *
470      * @dev y is divided after the product of x and the specified precision unit
471      * is evaluated, so the product of x and the specified precision unit must
472      * be less than 2**256. The result is rounded to the nearest increment.
473      */
474     function _divideDecimalRound(
475         uint x,
476         uint y,
477         uint precisionUnit
478     ) private pure returns (uint) {
479         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
480 
481         if (resultTimesTen % 10 >= 5) {
482             resultTimesTen += 10;
483         }
484 
485         return resultTimesTen / 10;
486     }
487 
488     /**
489      * @return The result of safely dividing x and y. The return value is as a rounded
490      * standard precision decimal.
491      *
492      * @dev y is divided after the product of x and the standard precision unit
493      * is evaluated, so the product of x and the standard precision unit must
494      * be less than 2**256. The result is rounded to the nearest increment.
495      */
496     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
497         return _divideDecimalRound(x, y, UNIT);
498     }
499 
500     /**
501      * @return The result of safely dividing x and y. The return value is as a rounded
502      * high precision decimal.
503      *
504      * @dev y is divided after the product of x and the high precision unit
505      * is evaluated, so the product of x and the high precision unit must
506      * be less than 2**256. The result is rounded to the nearest increment.
507      */
508     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
509         return _divideDecimalRound(x, y, PRECISE_UNIT);
510     }
511 
512     /**
513      * @dev Convert a standard decimal representation to a high precision one.
514      */
515     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
516         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
517     }
518 
519     /**
520      * @dev Convert a high precision decimal to a standard decimal representation.
521      */
522     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
523         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
524 
525         if (quotientTimesTen % 10 >= 5) {
526             quotientTimesTen += 10;
527         }
528 
529         return quotientTimesTen / 10;
530     }
531 }
532 
533 
534 interface AggregatorInterface {
535   function latestAnswer() external view returns (int256);
536   function latestTimestamp() external view returns (uint256);
537   function latestRound() external view returns (uint256);
538   function getAnswer(uint256 roundId) external view returns (int256);
539   function getTimestamp(uint256 roundId) external view returns (uint256);
540 
541   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
542   event NewRound(uint256 indexed roundId, address indexed startedBy);
543 }
544 
545 
546 // Inheritance
547 
548 
549 // Libraries
550 
551 
552 // Internal references
553 // AggregatorInterface from Chainlink represents a decentralized pricing network for a single currency key
554 
555 
556 // https://docs.synthetix.io/contracts/source/contracts/ExchangeRates
557 contract ExchangeRates is Owned, SelfDestructible, IExchangeRates {
558     using SafeMath for uint;
559     using SafeDecimalMath for uint;
560 
561     struct RateAndUpdatedTime {
562         uint216 rate;
563         uint40 time;
564     }
565 
566     // Exchange rates and update times stored by currency code, e.g. 'SNX', or 'sUSD'
567     mapping(bytes32 => mapping(uint => RateAndUpdatedTime)) private _rates;
568 
569     // The address of the oracle which pushes rate updates to this contract
570     address public oracle;
571 
572     // Decentralized oracle networks that feed into pricing aggregators
573     mapping(bytes32 => AggregatorInterface) public aggregators;
574 
575     // List of aggregator keys for convenient iteration
576     bytes32[] public aggregatorKeys;
577 
578     // Do not allow the oracle to submit times any further forward into the future than this constant.
579     uint private constant ORACLE_FUTURE_LIMIT = 10 minutes;
580 
581     // How long will the contract assume the rate of any asset is correct
582     uint public rateStalePeriod = 3 hours;
583 
584     // For inverted prices, keep a mapping of their entry, limits and frozen status
585     struct InversePricing {
586         uint entryPoint;
587         uint upperLimit;
588         uint lowerLimit;
589         bool frozen;
590     }
591     mapping(bytes32 => InversePricing) public inversePricing;
592     bytes32[] public invertedKeys;
593 
594     mapping(bytes32 => uint) public currentRoundForRate;
595 
596     //
597     // ========== CONSTRUCTOR ==========
598 
599     constructor(
600         address _owner,
601         address _oracle,
602         bytes32[] memory _currencyKeys,
603         uint[] memory _newRates
604     ) public Owned(_owner) SelfDestructible() {
605         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
606 
607         oracle = _oracle;
608 
609         // The sUSD rate is always 1 and is never stale.
610         _setRate("sUSD", SafeDecimalMath.unit(), now);
611 
612         internalUpdateRates(_currencyKeys, _newRates, now);
613     }
614 
615     /* ========== SETTERS ========== */
616 
617     function setOracle(address _oracle) external onlyOwner {
618         oracle = _oracle;
619         emit OracleUpdated(oracle);
620     }
621 
622     function setRateStalePeriod(uint _time) external onlyOwner {
623         rateStalePeriod = _time;
624         emit RateStalePeriodUpdated(rateStalePeriod);
625     }
626 
627     /* ========== MUTATIVE FUNCTIONS ========== */
628 
629     function updateRates(
630         bytes32[] calldata currencyKeys,
631         uint[] calldata newRates,
632         uint timeSent
633     ) external onlyOracle returns (bool) {
634         return internalUpdateRates(currencyKeys, newRates, timeSent);
635     }
636 
637     function deleteRate(bytes32 currencyKey) external onlyOracle {
638         require(_getRate(currencyKey) > 0, "Rate is zero");
639 
640         delete _rates[currencyKey][currentRoundForRate[currencyKey]];
641 
642         currentRoundForRate[currencyKey]--;
643 
644         emit RateDeleted(currencyKey);
645     }
646 
647     function setInversePricing(
648         bytes32 currencyKey,
649         uint entryPoint,
650         uint upperLimit,
651         uint lowerLimit,
652         bool freeze,
653         bool freezeAtUpperLimit
654     ) external onlyOwner {
655         // 0 < lowerLimit < entryPoint => 0 < entryPoint
656         require(lowerLimit > 0, "lowerLimit must be above 0");
657         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
658         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
659         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
660 
661         if (inversePricing[currencyKey].entryPoint <= 0) {
662             // then we are adding a new inverse pricing, so add this
663             invertedKeys.push(currencyKey);
664         }
665         inversePricing[currencyKey].entryPoint = entryPoint;
666         inversePricing[currencyKey].upperLimit = upperLimit;
667         inversePricing[currencyKey].lowerLimit = lowerLimit;
668         inversePricing[currencyKey].frozen = freeze;
669 
670         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
671 
672         // When indicating to freeze, we need to know the rate to freeze it at - either upper or lower
673         // this is useful in situations where ExchangeRates is updated and there are existing inverted
674         // rates already frozen in the current contract that need persisting across the upgrade
675         if (freeze) {
676             emit InversePriceFrozen(currencyKey);
677 
678             _setRate(currencyKey, freezeAtUpperLimit ? upperLimit : lowerLimit, now);
679         }
680     }
681 
682     function removeInversePricing(bytes32 currencyKey) external onlyOwner {
683         require(inversePricing[currencyKey].entryPoint > 0, "No inverted price exists");
684 
685         inversePricing[currencyKey].entryPoint = 0;
686         inversePricing[currencyKey].upperLimit = 0;
687         inversePricing[currencyKey].lowerLimit = 0;
688         inversePricing[currencyKey].frozen = false;
689 
690         // now remove inverted key from array
691         bool wasRemoved = removeFromArray(currencyKey, invertedKeys);
692 
693         if (wasRemoved) {
694             emit InversePriceConfigured(currencyKey, 0, 0, 0);
695         }
696     }
697 
698     function addAggregator(bytes32 currencyKey, address aggregatorAddress) external onlyOwner {
699         AggregatorInterface aggregator = AggregatorInterface(aggregatorAddress);
700         // This check tries to make sure that a valid aggregator is being added.
701         // It checks if the aggregator is an existing smart contract that has implemented `latestTimestamp` function.
702         require(aggregator.latestTimestamp() >= 0, "Given Aggregator is invalid");
703         if (address(aggregators[currencyKey]) == address(0)) {
704             aggregatorKeys.push(currencyKey);
705         }
706         aggregators[currencyKey] = aggregator;
707         emit AggregatorAdded(currencyKey, address(aggregator));
708     }
709 
710     function removeAggregator(bytes32 currencyKey) external onlyOwner {
711         address aggregator = address(aggregators[currencyKey]);
712         require(aggregator != address(0), "No aggregator exists for key");
713         delete aggregators[currencyKey];
714 
715         bool wasRemoved = removeFromArray(currencyKey, aggregatorKeys);
716 
717         if (wasRemoved) {
718             emit AggregatorRemoved(currencyKey, aggregator);
719         }
720     }
721 
722     /* ========== VIEWS ========== */
723 
724     function rateAndUpdatedTime(bytes32 currencyKey) external view returns (uint rate, uint time) {
725         RateAndUpdatedTime memory rateAndTime = _getRateAndUpdatedTime(currencyKey);
726         return (rateAndTime.rate, rateAndTime.time);
727     }
728 
729     function getLastRoundIdBeforeElapsedSecs(
730         bytes32 currencyKey,
731         uint startingRoundId,
732         uint startingTimestamp,
733         uint timediff
734     ) external view returns (uint) {
735         uint roundId = startingRoundId;
736         uint nextTimestamp = 0;
737         while (true) {
738             (, nextTimestamp) = _getRateAndTimestampAtRound(currencyKey, roundId + 1);
739             // if there's no new round, then the previous roundId was the latest
740             if (nextTimestamp == 0 || nextTimestamp > startingTimestamp + timediff) {
741                 return roundId;
742             }
743             roundId++;
744         }
745         return roundId;
746     }
747 
748     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint) {
749         return _getCurrentRoundId(currencyKey);
750     }
751 
752     function effectiveValueAtRound(
753         bytes32 sourceCurrencyKey,
754         uint sourceAmount,
755         bytes32 destinationCurrencyKey,
756         uint roundIdForSrc,
757         uint roundIdForDest
758     ) external view returns (uint value) {
759         // If there's no change in the currency, then just return the amount they gave us
760         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
761 
762         (uint srcRate, ) = _getRateAndTimestampAtRound(sourceCurrencyKey, roundIdForSrc);
763         (uint destRate, ) = _getRateAndTimestampAtRound(destinationCurrencyKey, roundIdForDest);
764         // Calculate the effective value by going from source -> USD -> destination
765         value = sourceAmount.multiplyDecimalRound(srcRate).divideDecimalRound(destRate);
766     }
767 
768     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time) {
769         return _getRateAndTimestampAtRound(currencyKey, roundId);
770     }
771 
772     function lastRateUpdateTimes(bytes32 currencyKey) external view returns (uint256) {
773         return _getUpdatedTime(currencyKey);
774     }
775 
776     function lastRateUpdateTimesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory) {
777         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
778 
779         for (uint i = 0; i < currencyKeys.length; i++) {
780             lastUpdateTimes[i] = _getUpdatedTime(currencyKeys[i]);
781         }
782 
783         return lastUpdateTimes;
784     }
785 
786     function effectiveValue(
787         bytes32 sourceCurrencyKey,
788         uint sourceAmount,
789         bytes32 destinationCurrencyKey
790     ) external view returns (uint value) {
791         (value, , ) = _effectiveValueAndRates(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
792     }
793 
794     function effectiveValueAndRates(
795         bytes32 sourceCurrencyKey,
796         uint sourceAmount,
797         bytes32 destinationCurrencyKey
798     )
799         external
800         view
801         returns (
802             uint value,
803             uint sourceRate,
804             uint destinationRate
805         )
806     {
807         return _effectiveValueAndRates(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
808     }
809 
810     function rateForCurrency(bytes32 currencyKey) external view returns (uint) {
811         return _getRateAndUpdatedTime(currencyKey).rate;
812     }
813 
814     function ratesAndUpdatedTimeForCurrencyLastNRounds(bytes32 currencyKey, uint numRounds)
815         external
816         view
817         returns (uint[] memory rates, uint[] memory times)
818     {
819         rates = new uint[](numRounds);
820         times = new uint[](numRounds);
821 
822         uint roundId = _getCurrentRoundId(currencyKey);
823         for (uint i = 0; i < numRounds; i++) {
824             (rates[i], times[i]) = _getRateAndTimestampAtRound(currencyKey, roundId);
825             if (roundId == 0) {
826                 // if we hit the last round, then return what we have
827                 return (rates, times);
828             } else {
829                 roundId--;
830             }
831         }
832     }
833 
834     function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory) {
835         uint[] memory _localRates = new uint[](currencyKeys.length);
836 
837         for (uint i = 0; i < currencyKeys.length; i++) {
838             _localRates[i] = _getRate(currencyKeys[i]);
839         }
840 
841         return _localRates;
842     }
843 
844     function ratesAndStaleForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint[] memory, bool) {
845         uint[] memory _localRates = new uint[](currencyKeys.length);
846 
847         bool anyRateStale = false;
848         uint period = rateStalePeriod;
849         for (uint i = 0; i < currencyKeys.length; i++) {
850             RateAndUpdatedTime memory rateAndUpdateTime = _getRateAndUpdatedTime(currencyKeys[i]);
851             _localRates[i] = uint256(rateAndUpdateTime.rate);
852             if (!anyRateStale) {
853                 anyRateStale = (currencyKeys[i] != "sUSD" && uint256(rateAndUpdateTime.time).add(period) < now);
854             }
855         }
856 
857         return (_localRates, anyRateStale);
858     }
859 
860     function rateIsStale(bytes32 currencyKey) external view returns (bool) {
861         // sUSD is a special case and is never stale.
862         if (currencyKey == "sUSD") return false;
863 
864         return _getUpdatedTime(currencyKey).add(rateStalePeriod) < now;
865     }
866 
867     function rateIsFrozen(bytes32 currencyKey) external view returns (bool) {
868         return inversePricing[currencyKey].frozen;
869     }
870 
871     function anyRateIsStale(bytes32[] calldata currencyKeys) external view returns (bool) {
872         // Loop through each key and check whether the data point is stale.
873         uint256 i = 0;
874 
875         while (i < currencyKeys.length) {
876             // sUSD is a special case and is never false
877             if (currencyKeys[i] != "sUSD" && _getUpdatedTime(currencyKeys[i]).add(rateStalePeriod) < now) {
878                 return true;
879             }
880             i += 1;
881         }
882 
883         return false;
884     }
885 
886     /* ========== INTERNAL FUNCTIONS ========== */
887 
888     function _setRate(
889         bytes32 currencyKey,
890         uint256 rate,
891         uint256 time
892     ) internal {
893         // Note: this will effectively start the rounds at 1, which matches Chainlink's Agggregators
894         currentRoundForRate[currencyKey]++;
895 
896         _rates[currencyKey][currentRoundForRate[currencyKey]] = RateAndUpdatedTime({
897             rate: uint216(rate),
898             time: uint40(time)
899         });
900     }
901 
902     function internalUpdateRates(
903         bytes32[] memory currencyKeys,
904         uint[] memory newRates,
905         uint timeSent
906     ) internal returns (bool) {
907         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
908         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
909 
910         // Loop through each key and perform update.
911         for (uint i = 0; i < currencyKeys.length; i++) {
912             bytes32 currencyKey = currencyKeys[i];
913 
914             // Should not set any rate to zero ever, as no asset will ever be
915             // truely worthless and still valid. In this scenario, we should
916             // delete the rate and remove it from the system.
917             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
918             require(currencyKey != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
919 
920             // We should only update the rate if it's at least the same age as the last rate we've got.
921             if (timeSent < _getUpdatedTime(currencyKey)) {
922                 continue;
923             }
924 
925             newRates[i] = rateOrInverted(currencyKey, newRates[i]);
926 
927             // Ok, go ahead with the update.
928             _setRate(currencyKey, newRates[i], timeSent);
929         }
930 
931         emit RatesUpdated(currencyKeys, newRates);
932 
933         return true;
934     }
935 
936     function rateOrInverted(bytes32 currencyKey, uint rate) internal returns (uint) {
937         // if an inverse mapping exists, adjust the price accordingly
938         InversePricing storage inverse = inversePricing[currencyKey];
939         if (inverse.entryPoint <= 0) {
940             return rate;
941         }
942 
943         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
944         uint newInverseRate = _getRate(currencyKey);
945 
946         // get the new inverted rate if not frozen
947         if (!inverse.frozen) {
948             uint doubleEntryPoint = inverse.entryPoint.mul(2);
949             if (doubleEntryPoint <= rate) {
950                 // avoid negative numbers for unsigned ints, so set this to 0
951                 // which by the requirement that lowerLimit be > 0 will
952                 // cause this to freeze the price to the lowerLimit
953                 newInverseRate = 0;
954             } else {
955                 newInverseRate = doubleEntryPoint.sub(rate);
956             }
957 
958             // now if new rate hits our limits, set it to the limit and freeze
959             if (newInverseRate >= inverse.upperLimit) {
960                 newInverseRate = inverse.upperLimit;
961             } else if (newInverseRate <= inverse.lowerLimit) {
962                 newInverseRate = inverse.lowerLimit;
963             }
964 
965             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
966                 inverse.frozen = true;
967                 emit InversePriceFrozen(currencyKey);
968             }
969         }
970 
971         return newInverseRate;
972     }
973 
974     function removeFromArray(bytes32 entry, bytes32[] storage array) internal returns (bool) {
975         for (uint i = 0; i < array.length; i++) {
976             if (array[i] == entry) {
977                 delete array[i];
978 
979                 // Copy the last key into the place of the one we just deleted
980                 // If there's only one key, this is array[0] = array[0].
981                 // If we're deleting the last one, it's also a NOOP in the same way.
982                 array[i] = array[array.length - 1];
983 
984                 // Decrease the size of the array by one.
985                 array.length--;
986 
987                 return true;
988             }
989         }
990         return false;
991     }
992 
993     function _getRateAndUpdatedTime(bytes32 currencyKey) internal view returns (RateAndUpdatedTime memory) {
994         if (address(aggregators[currencyKey]) != address(0)) {
995             return
996                 RateAndUpdatedTime({
997                     rate: uint216(aggregators[currencyKey].latestAnswer() * 1e10),
998                     time: uint40(aggregators[currencyKey].latestTimestamp())
999                 });
1000         } else {
1001             return _rates[currencyKey][currentRoundForRate[currencyKey]];
1002         }
1003     }
1004 
1005     function _getCurrentRoundId(bytes32 currencyKey) internal view returns (uint) {
1006         if (address(aggregators[currencyKey]) != address(0)) {
1007             AggregatorInterface aggregator = aggregators[currencyKey];
1008             return aggregator.latestRound();
1009         } else {
1010             return currentRoundForRate[currencyKey];
1011         }
1012     }
1013 
1014     function _getRateAndTimestampAtRound(bytes32 currencyKey, uint roundId) internal view returns (uint rate, uint time) {
1015         if (address(aggregators[currencyKey]) != address(0)) {
1016             AggregatorInterface aggregator = aggregators[currencyKey];
1017             return (uint(aggregator.getAnswer(roundId) * 1e10), aggregator.getTimestamp(roundId));
1018         } else {
1019             RateAndUpdatedTime storage update = _rates[currencyKey][roundId];
1020             return (update.rate, update.time);
1021         }
1022     }
1023 
1024     function _getRate(bytes32 currencyKey) internal view returns (uint256) {
1025         return _getRateAndUpdatedTime(currencyKey).rate;
1026     }
1027 
1028     function _getUpdatedTime(bytes32 currencyKey) internal view returns (uint256) {
1029         return _getRateAndUpdatedTime(currencyKey).time;
1030     }
1031 
1032     function _effectiveValueAndRates(
1033         bytes32 sourceCurrencyKey,
1034         uint sourceAmount,
1035         bytes32 destinationCurrencyKey
1036     )
1037         internal
1038         view
1039         returns (
1040             uint value,
1041             uint sourceRate,
1042             uint destinationRate
1043         )
1044     {
1045         sourceRate = _getRate(sourceCurrencyKey);
1046         // If there's no change in the currency, then just return the amount they gave us
1047         if (sourceCurrencyKey == destinationCurrencyKey) {
1048             destinationRate = sourceRate;
1049             value = sourceAmount;
1050         } else {
1051             // Calculate the effective value by going from source -> USD -> destination
1052             destinationRate = _getRate(destinationCurrencyKey);
1053             value = sourceAmount.multiplyDecimalRound(sourceRate).divideDecimalRound(destinationRate);
1054         }
1055     }
1056 
1057     /* ========== MODIFIERS ========== */
1058 
1059     modifier onlyOracle {
1060         require(msg.sender == oracle, "Only the oracle can perform this action");
1061         _;
1062     }
1063 
1064     /* ========== EVENTS ========== */
1065 
1066     event OracleUpdated(address newOracle);
1067     event RateStalePeriodUpdated(uint rateStalePeriod);
1068     event RatesUpdated(bytes32[] currencyKeys, uint[] newRates);
1069     event RateDeleted(bytes32 currencyKey);
1070     event InversePriceConfigured(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
1071     event InversePriceFrozen(bytes32 currencyKey);
1072     event AggregatorAdded(bytes32 currencyKey, address aggregator);
1073     event AggregatorRemoved(bytes32 currencyKey, address aggregator);
1074 }
1075 
1076 
1077     