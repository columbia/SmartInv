1 /*
2 * Synthetix - ExchangeRates.sol
3 *
4 * https://github.com/Synthetixio/synthetix
5 * https://synthetix.io
6 *
7 * MIT License
8 * ===========
9 *
10 * Copyright (c) 2020 Synthetix
11 *
12 * Permission is hereby granted, free of charge, to any person obtaining a copy
13 * of this software and associated documentation files (the "Software"), to deal
14 * in the Software without restriction, including without limitation the rights
15 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 * copies of the Software, and to permit persons to whom the Software is
17 * furnished to do so, subject to the following conditions:
18 *
19 * The above copyright notice and this permission notice shall be included in all
20 * copies or substantial portions of the Software.
21 *
22 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
25 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,	
27 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
28 */
29     
30 /* ===============================================
31 * Flattened with Solidifier by Coinage
32 * 
33 * https://solidifier.coina.ge
34 * ===============================================
35 */
36 
37 
38 pragma solidity ^0.4.24;
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b, "SafeMath.mul Error");
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0, "SafeMath.div Error"); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a, "SafeMath.sub Error");
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a, "SafeMath.add Error");
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0, "SafeMath.mod Error");
100     return a % b;
101   }
102 }
103 
104 
105 /*
106 
107 -----------------------------------------------------------------
108 FILE INFORMATION
109 -----------------------------------------------------------------
110 
111 file:       SafeDecimalMath.sol
112 version:    2.0
113 author:     Kevin Brown
114             Gavin Conway
115 date:       2018-10-18
116 
117 -----------------------------------------------------------------
118 MODULE DESCRIPTION
119 -----------------------------------------------------------------
120 
121 A library providing safe mathematical operations for division and
122 multiplication with the capability to round or truncate the results
123 to the nearest increment. Operations can return a standard precision
124 or high precision decimal. High precision decimals are useful for
125 example when attempting to calculate percentages or fractions
126 accurately.
127 
128 -----------------------------------------------------------------
129 */
130 
131 
132 /**
133  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
134  * @dev Functions accepting uints in this contract and derived contracts
135  * are taken to be such fixed point decimals of a specified precision (either standard
136  * or high).
137  */
138 library SafeDecimalMath {
139     using SafeMath for uint;
140 
141     /* Number of decimal places in the representations. */
142     uint8 public constant decimals = 18;
143     uint8 public constant highPrecisionDecimals = 27;
144 
145     /* The number representing 1.0. */
146     uint public constant UNIT = 10**uint(decimals);
147 
148     /* The number representing 1.0 for higher fidelity numbers. */
149     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
150     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
151 
152     /** 
153      * @return Provides an interface to UNIT.
154      */
155     function unit() external pure returns (uint) {
156         return UNIT;
157     }
158 
159     /** 
160      * @return Provides an interface to PRECISE_UNIT.
161      */
162     function preciseUnit() external pure returns (uint) {
163         return PRECISE_UNIT;
164     }
165 
166     /**
167      * @return The result of multiplying x and y, interpreting the operands as fixed-point
168      * decimals.
169      * 
170      * @dev A unit factor is divided out after the product of x and y is evaluated,
171      * so that product must be less than 2**256. As this is an integer division,
172      * the internal division always rounds down. This helps save on gas. Rounding
173      * is more expensive on gas.
174      */
175     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
176         /* Divide by UNIT to remove the extra factor introduced by the product. */
177         return x.mul(y) / UNIT;
178     }
179 
180     /**
181      * @return The result of safely multiplying x and y, interpreting the operands
182      * as fixed-point decimals of the specified precision unit.
183      *
184      * @dev The operands should be in the form of a the specified unit factor which will be
185      * divided out after the product of x and y is evaluated, so that product must be
186      * less than 2**256.
187      *
188      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
189      * Rounding is useful when you need to retain fidelity for small decimal numbers
190      * (eg. small fractions or percentages).
191      */
192     function _multiplyDecimalRound(uint x, uint y, uint precisionUnit) private pure returns (uint) {
193         /* Divide by UNIT to remove the extra factor introduced by the product. */
194         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
195 
196         if (quotientTimesTen % 10 >= 5) {
197             quotientTimesTen += 10;
198         }
199 
200         return quotientTimesTen / 10;
201     }
202 
203     /**
204      * @return The result of safely multiplying x and y, interpreting the operands
205      * as fixed-point decimals of a precise unit.
206      *
207      * @dev The operands should be in the precise unit factor which will be
208      * divided out after the product of x and y is evaluated, so that product must be
209      * less than 2**256.
210      *
211      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
212      * Rounding is useful when you need to retain fidelity for small decimal numbers
213      * (eg. small fractions or percentages).
214      */
215     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
216         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
217     }
218 
219     /**
220      * @return The result of safely multiplying x and y, interpreting the operands
221      * as fixed-point decimals of a standard unit.
222      *
223      * @dev The operands should be in the standard unit factor which will be
224      * divided out after the product of x and y is evaluated, so that product must be
225      * less than 2**256.
226      *
227      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
228      * Rounding is useful when you need to retain fidelity for small decimal numbers
229      * (eg. small fractions or percentages).
230      */
231     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
232         return _multiplyDecimalRound(x, y, UNIT);
233     }
234 
235     /**
236      * @return The result of safely dividing x and y. The return value is a high
237      * precision decimal.
238      * 
239      * @dev y is divided after the product of x and the standard precision unit
240      * is evaluated, so the product of x and UNIT must be less than 2**256. As
241      * this is an integer division, the result is always rounded down.
242      * This helps save on gas. Rounding is more expensive on gas.
243      */
244     function divideDecimal(uint x, uint y) internal pure returns (uint) {
245         /* Reintroduce the UNIT factor that will be divided out by y. */
246         return x.mul(UNIT).div(y);
247     }
248 
249     /**
250      * @return The result of safely dividing x and y. The return value is as a rounded
251      * decimal in the precision unit specified in the parameter.
252      *
253      * @dev y is divided after the product of x and the specified precision unit
254      * is evaluated, so the product of x and the specified precision unit must
255      * be less than 2**256. The result is rounded to the nearest increment.
256      */
257     function _divideDecimalRound(uint x, uint y, uint precisionUnit) private pure returns (uint) {
258         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
259 
260         if (resultTimesTen % 10 >= 5) {
261             resultTimesTen += 10;
262         }
263 
264         return resultTimesTen / 10;
265     }
266 
267     /**
268      * @return The result of safely dividing x and y. The return value is as a rounded
269      * standard precision decimal.
270      *
271      * @dev y is divided after the product of x and the standard precision unit
272      * is evaluated, so the product of x and the standard precision unit must
273      * be less than 2**256. The result is rounded to the nearest increment.
274      */
275     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
276         return _divideDecimalRound(x, y, UNIT);
277     }
278 
279     /**
280      * @return The result of safely dividing x and y. The return value is as a rounded
281      * high precision decimal.
282      *
283      * @dev y is divided after the product of x and the high precision unit
284      * is evaluated, so the product of x and the high precision unit must
285      * be less than 2**256. The result is rounded to the nearest increment.
286      */
287     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
288         return _divideDecimalRound(x, y, PRECISE_UNIT);
289     }
290 
291     /**
292      * @dev Convert a standard decimal representation to a high precision one.
293      */
294     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
295         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
296     }
297 
298     /**
299      * @dev Convert a high precision decimal to a standard decimal representation.
300      */
301     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
302         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
303 
304         if (quotientTimesTen % 10 >= 5) {
305             quotientTimesTen += 10;
306         }
307 
308         return quotientTimesTen / 10;
309     }
310 }
311 
312 
313 /*
314 -----------------------------------------------------------------
315 FILE INFORMATION
316 -----------------------------------------------------------------
317 
318 file:       Owned.sol
319 version:    1.1
320 author:     Anton Jurisevic
321             Dominic Romanowski
322 
323 date:       2018-2-26
324 
325 -----------------------------------------------------------------
326 MODULE DESCRIPTION
327 -----------------------------------------------------------------
328 
329 An Owned contract, to be inherited by other contracts.
330 Requires its owner to be explicitly set in the constructor.
331 Provides an onlyOwner access modifier.
332 
333 To change owner, the current owner must nominate the next owner,
334 who then has to accept the nomination. The nomination can be
335 cancelled before it is accepted by the new owner by having the
336 previous owner change the nomination (setting it to 0).
337 
338 -----------------------------------------------------------------
339 */
340 
341 
342 /**
343  * @title A contract with an owner.
344  * @notice Contract ownership can be transferred by first nominating the new owner,
345  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
346  */
347 contract Owned {
348     address public owner;
349     address public nominatedOwner;
350 
351     /**
352      * @dev Owned Constructor
353      */
354     constructor(address _owner) public {
355         require(_owner != address(0), "Owner address cannot be 0");
356         owner = _owner;
357         emit OwnerChanged(address(0), _owner);
358     }
359 
360     /**
361      * @notice Nominate a new owner of this contract.
362      * @dev Only the current owner may nominate a new owner.
363      */
364     function nominateNewOwner(address _owner) external onlyOwner {
365         nominatedOwner = _owner;
366         emit OwnerNominated(_owner);
367     }
368 
369     /**
370      * @notice Accept the nomination to be owner.
371      */
372     function acceptOwnership() external {
373         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
374         emit OwnerChanged(owner, nominatedOwner);
375         owner = nominatedOwner;
376         nominatedOwner = address(0);
377     }
378 
379     modifier onlyOwner {
380         require(msg.sender == owner, "Only the contract owner may perform this action");
381         _;
382     }
383 
384     event OwnerNominated(address newOwner);
385     event OwnerChanged(address oldOwner, address newOwner);
386 }
387 
388 
389 /*
390 -----------------------------------------------------------------
391 FILE INFORMATION
392 -----------------------------------------------------------------
393 
394 file:       SelfDestructible.sol
395 version:    1.2
396 author:     Anton Jurisevic
397 
398 date:       2018-05-29
399 
400 -----------------------------------------------------------------
401 MODULE DESCRIPTION
402 -----------------------------------------------------------------
403 
404 This contract allows an inheriting contract to be destroyed after
405 its owner indicates an intention and then waits for a period
406 without changing their mind. All ether contained in the contract
407 is forwarded to a nominated beneficiary upon destruction.
408 
409 -----------------------------------------------------------------
410 */
411 
412 
413 /**
414  * @title A contract that can be destroyed by its owner after a delay elapses.
415  */
416 contract SelfDestructible is Owned {
417     uint public initiationTime;
418     bool public selfDestructInitiated;
419     address public selfDestructBeneficiary;
420     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
421 
422     /**
423      * @dev Constructor
424      * @param _owner The account which controls this contract.
425      */
426     constructor(address _owner) public Owned(_owner) {
427         require(_owner != address(0), "Owner must not be zero");
428         selfDestructBeneficiary = _owner;
429         emit SelfDestructBeneficiaryUpdated(_owner);
430     }
431 
432     /**
433      * @notice Set the beneficiary address of this contract.
434      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
435      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
436      */
437     function setSelfDestructBeneficiary(address _beneficiary) external onlyOwner {
438         require(_beneficiary != address(0), "Beneficiary must not be zero");
439         selfDestructBeneficiary = _beneficiary;
440         emit SelfDestructBeneficiaryUpdated(_beneficiary);
441     }
442 
443     /**
444      * @notice Begin the self-destruction counter of this contract.
445      * Once the delay has elapsed, the contract may be self-destructed.
446      * @dev Only the contract owner may call this.
447      */
448     function initiateSelfDestruct() external onlyOwner {
449         initiationTime = now;
450         selfDestructInitiated = true;
451         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
452     }
453 
454     /**
455      * @notice Terminate and reset the self-destruction timer.
456      * @dev Only the contract owner may call this.
457      */
458     function terminateSelfDestruct() external onlyOwner {
459         initiationTime = 0;
460         selfDestructInitiated = false;
461         emit SelfDestructTerminated();
462     }
463 
464     /**
465      * @notice If the self-destruction delay has elapsed, destroy this contract and
466      * remit any ether it owns to the beneficiary address.
467      * @dev Only the contract owner may call this.
468      */
469     function selfDestruct() external onlyOwner {
470         require(selfDestructInitiated, "Self Destruct not yet initiated");
471         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay not met");
472         address beneficiary = selfDestructBeneficiary;
473         emit SelfDestructed(beneficiary);
474         selfdestruct(beneficiary);
475     }
476 
477     event SelfDestructTerminated();
478     event SelfDestructed(address beneficiary);
479     event SelfDestructInitiated(uint selfDestructDelay);
480     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
481 }
482 
483 
484 interface AggregatorInterface {
485   function latestAnswer() external view returns (int256);
486   function latestTimestamp() external view returns (uint256);
487   function latestRound() external view returns (uint256);
488   function getAnswer(uint256 roundId) external view returns (int256);
489   function getTimestamp(uint256 roundId) external view returns (uint256);
490 
491   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
492   event NewRound(uint256 indexed roundId, address indexed startedBy);
493 }
494 
495 
496 // AggregatorInterface from Chainlink represents a decentralized pricing network for a single currency key
497 
498 
499 /**
500  * @title The repository for exchange rates
501  */
502 
503 contract ExchangeRates is SelfDestructible {
504     using SafeMath for uint;
505     using SafeDecimalMath for uint;
506 
507     struct RateAndUpdatedTime {
508         uint216 rate;
509         uint40 time;
510     }
511 
512     // Exchange rates and update times stored by currency code, e.g. 'SNX', or 'sUSD'
513     mapping(bytes32 => mapping(uint => RateAndUpdatedTime)) private _rates;
514 
515     // The address of the oracle which pushes rate updates to this contract
516     address public oracle;
517 
518     // Decentralized oracle networks that feed into pricing aggregators
519     mapping(bytes32 => AggregatorInterface) public aggregators;
520 
521     // List of aggregator keys for convenient iteration
522     bytes32[] public aggregatorKeys;
523 
524     // Do not allow the oracle to submit times any further forward into the future than this constant.
525     uint private constant ORACLE_FUTURE_LIMIT = 10 minutes;
526 
527     // How long will the contract assume the rate of any asset is correct
528     uint public rateStalePeriod = 3 hours;
529 
530     // For inverted prices, keep a mapping of their entry, limits and frozen status
531     struct InversePricing {
532         uint entryPoint;
533         uint upperLimit;
534         uint lowerLimit;
535         bool frozen;
536     }
537     mapping(bytes32 => InversePricing) public inversePricing;
538     bytes32[] public invertedKeys;
539 
540     mapping(bytes32 => uint) currentRoundForRate;
541 
542     //
543     // ========== CONSTRUCTOR ==========
544 
545     /**
546      * @dev Constructor
547      * @param _owner The owner of this contract.
548      * @param _oracle The address which is able to update rate information.
549      * @param _currencyKeys The initial currency keys to store (in order).
550      * @param _newRates The initial currency amounts for each currency (in order).
551      */
552     constructor(
553         // SelfDestructible (Ownable)
554         address _owner,
555         // Oracle values - Allows for rate updates
556         address _oracle,
557         bytes32[] _currencyKeys,
558         uint[] _newRates
559     )
560         public
561         /* Owned is initialised in SelfDestructible */
562         SelfDestructible(_owner)
563     {
564         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
565 
566         oracle = _oracle;
567 
568         // The sUSD rate is always 1 and is never stale.
569         _setRate("sUSD", SafeDecimalMath.unit(), now);
570 
571         internalUpdateRates(_currencyKeys, _newRates, now);
572     }
573 
574     /* ========== SETTERS ========== */
575 
576     /**
577      * @notice Set the Oracle that pushes the rate information to this contract
578      * @param _oracle The new oracle address
579      */
580     function setOracle(address _oracle) external onlyOwner {
581         oracle = _oracle;
582         emit OracleUpdated(oracle);
583     }
584 
585     /**
586      * @notice Set the stale period on the updated rate variables
587      * @param _time The new rateStalePeriod
588      */
589     function setRateStalePeriod(uint _time) external onlyOwner {
590         rateStalePeriod = _time;
591         emit RateStalePeriodUpdated(rateStalePeriod);
592     }
593 
594     /* ========== MUTATIVE FUNCTIONS ========== */
595 
596     /**
597      * @notice Set the rates stored in this contract
598      * @param currencyKeys The currency keys you wish to update the rates for (in order)
599      * @param newRates The rates for each currency (in order)
600      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).
601      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
602      *                 if it takes a long time for the transaction to confirm.
603      */
604     function updateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent) external onlyOracle returns (bool) {
605         return internalUpdateRates(currencyKeys, newRates, timeSent);
606     }
607 
608     /**
609      * @notice Delete a rate stored in the contract
610      * @param currencyKey The currency key you wish to delete the rate for
611      */
612     function deleteRate(bytes32 currencyKey) external onlyOracle {
613         require(getRate(currencyKey) > 0, "Rate is zero");
614 
615         delete _rates[currencyKey][currentRoundForRate[currencyKey]];
616 
617         currentRoundForRate[currencyKey]--;
618 
619         emit RateDeleted(currencyKey);
620     }
621 
622     /**
623      * @notice Set an inverse price up for the currency key.
624      *
625      * An inverse price is one which has an entryPoint, an uppper and a lower limit. Each update, the
626      * rate is calculated as double the entryPrice minus the current rate. If this calculation is
627      * above or below the upper or lower limits respectively, then the rate is frozen, and no more
628      * rate updates will be accepted.
629      *
630      * @param currencyKey The currency to update
631      * @param entryPoint The entry price point of the inverted price
632      * @param upperLimit The upper limit, at or above which the price will be frozen
633      * @param lowerLimit The lower limit, at or below which the price will be frozen
634      * @param freeze Whether or not to freeze this rate immediately. Note: no frozen event will be configured
635      * @param freezeAtUpperLimit When the freeze flag is true, this flag indicates whether the rate
636      * to freeze at is the upperLimit or lowerLimit..
637      */
638     function setInversePricing(
639         bytes32 currencyKey,
640         uint entryPoint,
641         uint upperLimit,
642         uint lowerLimit,
643         bool freeze,
644         bool freezeAtUpperLimit
645     ) external onlyOwner {
646         require(entryPoint > 0, "entryPoint must be above 0");
647         require(lowerLimit > 0, "lowerLimit must be above 0");
648         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
649         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
650         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
651 
652         if (inversePricing[currencyKey].entryPoint <= 0) {
653             // then we are adding a new inverse pricing, so add this
654             invertedKeys.push(currencyKey);
655         }
656         inversePricing[currencyKey].entryPoint = entryPoint;
657         inversePricing[currencyKey].upperLimit = upperLimit;
658         inversePricing[currencyKey].lowerLimit = lowerLimit;
659         inversePricing[currencyKey].frozen = freeze;
660 
661         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
662 
663         // When indicating to freeze, we need to know the rate to freeze it at - either upper or lower
664         // this is useful in situations where ExchangeRates is updated and there are existing inverted
665         // rates already frozen in the current contract that need persisting across the upgrade
666         if (freeze) {
667             emit InversePriceFrozen(currencyKey);
668 
669             _setRate(currencyKey, freezeAtUpperLimit ? upperLimit : lowerLimit, now);
670         }
671     }
672 
673     /**
674      * @notice Remove an inverse price for the currency key
675      * @param currencyKey The currency to remove inverse pricing for
676      */
677     function removeInversePricing(bytes32 currencyKey) external onlyOwner {
678         require(inversePricing[currencyKey].entryPoint > 0, "No inverted price exists");
679 
680         inversePricing[currencyKey].entryPoint = 0;
681         inversePricing[currencyKey].upperLimit = 0;
682         inversePricing[currencyKey].lowerLimit = 0;
683         inversePricing[currencyKey].frozen = false;
684 
685         // now remove inverted key from array
686         bool wasRemoved = removeFromArray(currencyKey, invertedKeys);
687 
688         if (wasRemoved) {
689             emit InversePriceConfigured(currencyKey, 0, 0, 0);
690         }
691     }
692 
693     /**
694      * @notice Add a pricing aggregator for the given key. Note: existing aggregators may be overridden.
695      * @param currencyKey The currency key to add an aggregator for
696      */
697     function addAggregator(bytes32 currencyKey, address aggregatorAddress) external onlyOwner {
698         AggregatorInterface aggregator = AggregatorInterface(aggregatorAddress);
699         require(aggregator.latestTimestamp() >= 0, "Given Aggregator is invalid");
700         if (aggregators[currencyKey] == address(0)) {
701             aggregatorKeys.push(currencyKey);
702         }
703         aggregators[currencyKey] = aggregator;
704         emit AggregatorAdded(currencyKey, aggregator);
705     }
706 
707     /**
708      * @notice Remove a pricing aggregator for the given key
709      * @param currencyKey The currency key to remove an aggregator for
710      */
711     function removeAggregator(bytes32 currencyKey) external onlyOwner {
712         address aggregator = aggregators[currencyKey];
713         require(aggregator != address(0), "No aggregator exists for key");
714         delete aggregators[currencyKey];
715 
716         bool wasRemoved = removeFromArray(currencyKey, aggregatorKeys);
717 
718         if (wasRemoved) {
719             emit AggregatorRemoved(currencyKey, aggregator);
720         }
721     }
722 
723     function getLastRoundIdBeforeElapsedSecs(
724         bytes32 currencyKey,
725         uint startingRoundId,
726         uint startingTimestamp,
727         uint timediff
728     ) external view returns (uint) {
729         uint roundId = startingRoundId;
730         uint nextTimestamp = 0;
731         while (true) {
732             (, nextTimestamp) = getRateAndTimestampAtRound(currencyKey, roundId + 1);
733             // if there's no new round, then the previous roundId was the latest
734             if (nextTimestamp == 0 || nextTimestamp > startingTimestamp + timediff) {
735                 return roundId;
736             }
737             roundId++;
738         }
739         return roundId;
740     }
741 
742     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint) {
743         if (aggregators[currencyKey] != address(0)) {
744             AggregatorInterface aggregator = aggregators[currencyKey];
745             return aggregator.latestRound();
746         } else {
747             return currentRoundForRate[currencyKey];
748         }
749     }
750 
751     function effectiveValueAtRound(
752         bytes32 sourceCurrencyKey,
753         uint sourceAmount,
754         bytes32 destinationCurrencyKey,
755         uint roundIdForSrc,
756         uint roundIdForDest
757     ) external view rateNotStale(sourceCurrencyKey) rateNotStale(destinationCurrencyKey) returns (uint) {
758         // If there's no change in the currency, then just return the amount they gave us
759         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
760 
761         (uint srcRate, ) = getRateAndTimestampAtRound(sourceCurrencyKey, roundIdForSrc);
762         (uint destRate, ) = getRateAndTimestampAtRound(destinationCurrencyKey, roundIdForDest);
763         // Calculate the effective value by going from source -> USD -> destination
764         return sourceAmount.multiplyDecimalRound(srcRate).divideDecimalRound(destRate);
765     }
766 
767     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time) {
768         return getRateAndTimestampAtRound(currencyKey, roundId);
769     }
770 
771     /* ========== VIEWS ========== */
772 
773     /**
774      * @notice Retrieves the timestamp the given rate was last updated.
775      */
776     function lastRateUpdateTimes(bytes32 currencyKey) public view returns (uint256) {
777         return getRateAndUpdatedTime(currencyKey).time;
778     }
779 
780     /**
781      * @notice Retrieve the last update time for a list of currencies
782      */
783     function lastRateUpdateTimesForCurrencies(bytes32[] currencyKeys) public view returns (uint[]) {
784         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
785 
786         for (uint i = 0; i < currencyKeys.length; i++) {
787             lastUpdateTimes[i] = lastRateUpdateTimes(currencyKeys[i]);
788         }
789 
790         return lastUpdateTimes;
791     }
792 
793     /**
794      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
795      * @param sourceCurrencyKey The currency the amount is specified in
796      * @param sourceAmount The source amount, specified in UNIT base
797      * @param destinationCurrencyKey The destination currency
798      */
799     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
800         public
801         view
802         rateNotStale(sourceCurrencyKey)
803         rateNotStale(destinationCurrencyKey)
804         returns (uint)
805     {
806         // If there's no change in the currency, then just return the amount they gave us
807         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
808 
809         // Calculate the effective value by going from source -> USD -> destination
810         return
811             sourceAmount.multiplyDecimalRound(getRate(sourceCurrencyKey)).divideDecimalRound(
812                 getRate(destinationCurrencyKey)
813             );
814     }
815 
816     /**
817      * @notice Retrieve the rate for a specific currency
818      */
819     function rateForCurrency(bytes32 currencyKey) external view returns (uint) {
820         return getRateAndUpdatedTime(currencyKey).rate;
821     }
822 
823     /**
824      * @notice Retrieve the rates for a list of currencies
825      */
826     function ratesForCurrencies(bytes32[] currencyKeys) external view returns (uint[]) {
827         uint[] memory _localRates = new uint[](currencyKeys.length);
828 
829         for (uint i = 0; i < currencyKeys.length; i++) {
830             _localRates[i] = getRate(currencyKeys[i]);
831         }
832 
833         return _localRates;
834     }
835 
836     /**
837      * @notice Retrieve the rates and isAnyStale for a list of currencies
838      */
839     function ratesAndStaleForCurrencies(bytes32[] currencyKeys) external view returns (uint[], bool) {
840         uint[] memory _localRates = new uint[](currencyKeys.length);
841 
842         bool anyRateStale = false;
843         uint period = rateStalePeriod;
844         for (uint i = 0; i < currencyKeys.length; i++) {
845             RateAndUpdatedTime memory rateAndUpdateTime = getRateAndUpdatedTime(currencyKeys[i]);
846             _localRates[i] = uint256(rateAndUpdateTime.rate);
847             if (!anyRateStale) {
848                 anyRateStale = (currencyKeys[i] != "sUSD" && uint256(rateAndUpdateTime.time).add(period) < now);
849             }
850         }
851 
852         return (_localRates, anyRateStale);
853     }
854 
855     /**
856      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
857      */
858     function rateIsStale(bytes32 currencyKey) public view returns (bool) {
859         // sUSD is a special case and is never stale.
860         if (currencyKey == "sUSD") return false;
861 
862         return lastRateUpdateTimes(currencyKey).add(rateStalePeriod) < now;
863     }
864 
865     /**
866      * @notice Check if any rate is frozen (cannot be exchanged into)
867      */
868     function rateIsFrozen(bytes32 currencyKey) external view returns (bool) {
869         return inversePricing[currencyKey].frozen;
870     }
871 
872     /**
873      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
874      */
875     function anyRateIsStale(bytes32[] currencyKeys) external view returns (bool) {
876         // Loop through each key and check whether the data point is stale.
877         uint256 i = 0;
878 
879         while (i < currencyKeys.length) {
880             // sUSD is a special case and is never false
881             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes(currencyKeys[i]).add(rateStalePeriod) < now) {
882                 return true;
883             }
884             i += 1;
885         }
886 
887         return false;
888     }
889 
890     /* ========== INTERNAL FUNCTIONS ========== */
891 
892     function _setRate(bytes32 currencyKey, uint256 rate, uint256 time) internal {
893         // Note: this will effectively start the rounds at 1, which matches Chainlink's Agggregators
894         currentRoundForRate[currencyKey]++;
895 
896         _rates[currencyKey][currentRoundForRate[currencyKey]] = RateAndUpdatedTime({
897             rate: uint216(rate),
898             time: uint40(time)
899         });
900     }
901 
902     /**
903      * @notice Internal function which sets the rates stored in this contract
904      * @param currencyKeys The currency keys you wish to update the rates for (in order)
905      * @param newRates The rates for each currency (in order)
906      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
907      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
908      *                 if it takes a long time for the transaction to confirm.
909      */
910     function internalUpdateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent) internal returns (bool) {
911         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
912         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
913 
914         // Loop through each key and perform update.
915         for (uint i = 0; i < currencyKeys.length; i++) {
916             bytes32 currencyKey = currencyKeys[i];
917 
918             // Should not set any rate to zero ever, as no asset will ever be
919             // truely worthless and still valid. In this scenario, we should
920             // delete the rate and remove it from the system.
921             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
922             require(currencyKey != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
923 
924             // We should only update the rate if it's at least the same age as the last rate we've got.
925             if (timeSent < lastRateUpdateTimes(currencyKey)) {
926                 continue;
927             }
928 
929             newRates[i] = rateOrInverted(currencyKey, newRates[i]);
930 
931             // Ok, go ahead with the update.
932             _setRate(currencyKey, newRates[i], timeSent);
933         }
934 
935         emit RatesUpdated(currencyKeys, newRates);
936 
937         return true;
938     }
939 
940     /**
941      * @notice Internal function to get the inverted rate, if any, and mark an inverted
942      *  key as frozen if either limits are reached.
943      *
944      * Inverted rates are ones that take a regular rate, perform a simple calculation (double entryPrice and
945      * subtract the rate) on them and if the result of the calculation is over or under predefined limits, it freezes the
946      * rate at that limit, preventing any future rate updates.
947      *
948      * For example, if we have an inverted rate iBTC with the following parameters set:
949      * - entryPrice of 200
950      * - upperLimit of 300
951      * - lower of 100
952      *
953      * if this function is invoked with params iETH and 184 (or rather 184e18),
954      * then the rate would be: 200 * 2 - 184 = 216. 100 < 216 < 200, so the rate would be 216,
955      * and remain unfrozen.
956      *
957      * If this function is then invoked with params iETH and 301 (or rather 301e18),
958      * then the rate would be: 200 * 2 - 301 = 99. 99 < 100, so the rate would be 100 and the
959      * rate would become frozen, no longer accepting future price updates until the synth is unfrozen
960      * by the owner function: setInversePricing().
961      *
962      * @param currencyKey The price key to lookup
963      * @param rate The rate for the given price key
964      */
965     function rateOrInverted(bytes32 currencyKey, uint rate) internal returns (uint) {
966         // if an inverse mapping exists, adjust the price accordingly
967         InversePricing storage inverse = inversePricing[currencyKey];
968         if (inverse.entryPoint <= 0) {
969             return rate;
970         }
971 
972         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
973         uint newInverseRate = getRate(currencyKey);
974 
975         // get the new inverted rate if not frozen
976         if (!inverse.frozen) {
977             uint doubleEntryPoint = inverse.entryPoint.mul(2);
978             if (doubleEntryPoint <= rate) {
979                 // avoid negative numbers for unsigned ints, so set this to 0
980                 // which by the requirement that lowerLimit be > 0 will
981                 // cause this to freeze the price to the lowerLimit
982                 newInverseRate = 0;
983             } else {
984                 newInverseRate = doubleEntryPoint.sub(rate);
985             }
986 
987             // now if new rate hits our limits, set it to the limit and freeze
988             if (newInverseRate >= inverse.upperLimit) {
989                 newInverseRate = inverse.upperLimit;
990             } else if (newInverseRate <= inverse.lowerLimit) {
991                 newInverseRate = inverse.lowerLimit;
992             }
993 
994             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
995                 inverse.frozen = true;
996                 emit InversePriceFrozen(currencyKey);
997             }
998         }
999 
1000         return newInverseRate;
1001     }
1002 
1003     function getRateAndUpdatedTime(bytes32 currencyKey) internal view returns (RateAndUpdatedTime) {
1004         if (aggregators[currencyKey] != address(0)) {
1005             return
1006                 RateAndUpdatedTime({
1007                     rate: uint216(aggregators[currencyKey].latestAnswer() * 1e10),
1008                     time: uint40(aggregators[currencyKey].latestTimestamp())
1009                 });
1010         } else {
1011             return _rates[currencyKey][currentRoundForRate[currencyKey]];
1012         }
1013     }
1014 
1015     /**
1016      * @notice Remove a single value from an array by iterating through until it is found.
1017      * @param entry The entry to find
1018      * @param array The array to mutate
1019      * @return bool Whether or not the entry was found and removed
1020      */
1021     function removeFromArray(bytes32 entry, bytes32[] storage array) internal returns (bool) {
1022         for (uint i = 0; i < array.length; i++) {
1023             if (array[i] == entry) {
1024                 delete array[i];
1025 
1026                 // Copy the last key into the place of the one we just deleted
1027                 // If there's only one key, this is array[0] = array[0].
1028                 // If we're deleting the last one, it's also a NOOP in the same way.
1029                 array[i] = array[array.length - 1];
1030 
1031                 // Decrease the size of the array by one.
1032                 array.length--;
1033 
1034                 return true;
1035             }
1036         }
1037         return false;
1038     }
1039 
1040     function getRateAndTimestampAtRound(bytes32 currencyKey, uint roundId) internal view returns (uint rate, uint time) {
1041         if (aggregators[currencyKey] != address(0)) {
1042             AggregatorInterface aggregator = aggregators[currencyKey];
1043             return (uint(aggregator.getAnswer(roundId) * 1e10), aggregator.getTimestamp(roundId));
1044         } else {
1045             RateAndUpdatedTime storage update = _rates[currencyKey][roundId];
1046             return (update.rate, update.time);
1047         }
1048     }
1049 
1050     function getRate(bytes32 currencyKey) internal view returns (uint256) {
1051         return getRateAndUpdatedTime(currencyKey).rate;
1052     }
1053 
1054     /* ========== MODIFIERS ========== */
1055 
1056     modifier rateNotStale(bytes32 currencyKey) {
1057         require(!rateIsStale(currencyKey), "Rate stale or nonexistant currency");
1058         _;
1059     }
1060 
1061     modifier onlyOracle {
1062         require(msg.sender == oracle, "Only the oracle can perform this action");
1063         _;
1064     }
1065 
1066     /* ========== EVENTS ========== */
1067 
1068     event OracleUpdated(address newOracle);
1069     event RateStalePeriodUpdated(uint rateStalePeriod);
1070     event RatesUpdated(bytes32[] currencyKeys, uint[] newRates);
1071     event RateDeleted(bytes32 currencyKey);
1072     event InversePriceConfigured(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
1073     event InversePriceFrozen(bytes32 currencyKey);
1074     event AggregatorAdded(bytes32 currencyKey, address aggregator);
1075     event AggregatorRemoved(bytes32 currencyKey, address aggregator);
1076 }
1077 
1078 
1079     