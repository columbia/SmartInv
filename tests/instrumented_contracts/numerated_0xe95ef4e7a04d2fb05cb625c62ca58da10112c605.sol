1 /*
2 * Synthetix - ExchangeRates.sol
3 *
4 * https://github.com/Synthetixio/synthetix
5 * https://synthetix.io
6 *
7 * MIT License
8 * ===========
9 *
10 * Copyright (c) 2019 Synthetix
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
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
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
78     require(b <= a);
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
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
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
139 
140     using SafeMath for uint;
141 
142     /* Number of decimal places in the representations. */
143     uint8 public constant decimals = 18;
144     uint8 public constant highPrecisionDecimals = 27;
145 
146     /* The number representing 1.0. */
147     uint public constant UNIT = 10 ** uint(decimals);
148 
149     /* The number representing 1.0 for higher fidelity numbers. */
150     uint public constant PRECISE_UNIT = 10 ** uint(highPrecisionDecimals);
151     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10 ** uint(highPrecisionDecimals - decimals);
152 
153     /** 
154      * @return Provides an interface to UNIT.
155      */
156     function unit()
157         external
158         pure
159         returns (uint)
160     {
161         return UNIT;
162     }
163 
164     /** 
165      * @return Provides an interface to PRECISE_UNIT.
166      */
167     function preciseUnit()
168         external
169         pure 
170         returns (uint)
171     {
172         return PRECISE_UNIT;
173     }
174 
175     /**
176      * @return The result of multiplying x and y, interpreting the operands as fixed-point
177      * decimals.
178      * 
179      * @dev A unit factor is divided out after the product of x and y is evaluated,
180      * so that product must be less than 2**256. As this is an integer division,
181      * the internal division always rounds down. This helps save on gas. Rounding
182      * is more expensive on gas.
183      */
184     function multiplyDecimal(uint x, uint y)
185         internal
186         pure
187         returns (uint)
188     {
189         /* Divide by UNIT to remove the extra factor introduced by the product. */
190         return x.mul(y) / UNIT;
191     }
192 
193     /**
194      * @return The result of safely multiplying x and y, interpreting the operands
195      * as fixed-point decimals of the specified precision unit.
196      *
197      * @dev The operands should be in the form of a the specified unit factor which will be
198      * divided out after the product of x and y is evaluated, so that product must be
199      * less than 2**256.
200      *
201      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
202      * Rounding is useful when you need to retain fidelity for small decimal numbers
203      * (eg. small fractions or percentages).
204      */
205     function _multiplyDecimalRound(uint x, uint y, uint precisionUnit)
206         private
207         pure
208         returns (uint)
209     {
210         /* Divide by UNIT to remove the extra factor introduced by the product. */
211         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
212 
213         if (quotientTimesTen % 10 >= 5) {
214             quotientTimesTen += 10;
215         }
216 
217         return quotientTimesTen / 10;
218     }
219 
220     /**
221      * @return The result of safely multiplying x and y, interpreting the operands
222      * as fixed-point decimals of a precise unit.
223      *
224      * @dev The operands should be in the precise unit factor which will be
225      * divided out after the product of x and y is evaluated, so that product must be
226      * less than 2**256.
227      *
228      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
229      * Rounding is useful when you need to retain fidelity for small decimal numbers
230      * (eg. small fractions or percentages).
231      */
232     function multiplyDecimalRoundPrecise(uint x, uint y)
233         internal
234         pure
235         returns (uint)
236     {
237         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
238     }
239 
240     /**
241      * @return The result of safely multiplying x and y, interpreting the operands
242      * as fixed-point decimals of a standard unit.
243      *
244      * @dev The operands should be in the standard unit factor which will be
245      * divided out after the product of x and y is evaluated, so that product must be
246      * less than 2**256.
247      *
248      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
249      * Rounding is useful when you need to retain fidelity for small decimal numbers
250      * (eg. small fractions or percentages).
251      */
252     function multiplyDecimalRound(uint x, uint y)
253         internal
254         pure
255         returns (uint)
256     {
257         return _multiplyDecimalRound(x, y, UNIT);
258     }
259 
260     /**
261      * @return The result of safely dividing x and y. The return value is a high
262      * precision decimal.
263      * 
264      * @dev y is divided after the product of x and the standard precision unit
265      * is evaluated, so the product of x and UNIT must be less than 2**256. As
266      * this is an integer division, the result is always rounded down.
267      * This helps save on gas. Rounding is more expensive on gas.
268      */
269     function divideDecimal(uint x, uint y)
270         internal
271         pure
272         returns (uint)
273     {
274         /* Reintroduce the UNIT factor that will be divided out by y. */
275         return x.mul(UNIT).div(y);
276     }
277 
278     /**
279      * @return The result of safely dividing x and y. The return value is as a rounded
280      * decimal in the precision unit specified in the parameter.
281      *
282      * @dev y is divided after the product of x and the specified precision unit
283      * is evaluated, so the product of x and the specified precision unit must
284      * be less than 2**256. The result is rounded to the nearest increment.
285      */
286     function _divideDecimalRound(uint x, uint y, uint precisionUnit)
287         private
288         pure
289         returns (uint)
290     {
291         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
292 
293         if (resultTimesTen % 10 >= 5) {
294             resultTimesTen += 10;
295         }
296 
297         return resultTimesTen / 10;
298     }
299 
300     /**
301      * @return The result of safely dividing x and y. The return value is as a rounded
302      * standard precision decimal.
303      *
304      * @dev y is divided after the product of x and the standard precision unit
305      * is evaluated, so the product of x and the standard precision unit must
306      * be less than 2**256. The result is rounded to the nearest increment.
307      */
308     function divideDecimalRound(uint x, uint y)
309         internal
310         pure
311         returns (uint)
312     {
313         return _divideDecimalRound(x, y, UNIT);
314     }
315 
316     /**
317      * @return The result of safely dividing x and y. The return value is as a rounded
318      * high precision decimal.
319      *
320      * @dev y is divided after the product of x and the high precision unit
321      * is evaluated, so the product of x and the high precision unit must
322      * be less than 2**256. The result is rounded to the nearest increment.
323      */
324     function divideDecimalRoundPrecise(uint x, uint y)
325         internal
326         pure
327         returns (uint)
328     {
329         return _divideDecimalRound(x, y, PRECISE_UNIT);
330     }
331 
332     /**
333      * @dev Convert a standard decimal representation to a high precision one.
334      */
335     function decimalToPreciseDecimal(uint i)
336         internal
337         pure
338         returns (uint)
339     {
340         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
341     }
342 
343     /**
344      * @dev Convert a high precision decimal to a standard decimal representation.
345      */
346     function preciseDecimalToDecimal(uint i)
347         internal
348         pure
349         returns (uint)
350     {
351         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
352 
353         if (quotientTimesTen % 10 >= 5) {
354             quotientTimesTen += 10;
355         }
356 
357         return quotientTimesTen / 10;
358     }
359 
360 }
361 
362 
363 /*
364 -----------------------------------------------------------------
365 FILE INFORMATION
366 -----------------------------------------------------------------
367 
368 file:       Owned.sol
369 version:    1.1
370 author:     Anton Jurisevic
371             Dominic Romanowski
372 
373 date:       2018-2-26
374 
375 -----------------------------------------------------------------
376 MODULE DESCRIPTION
377 -----------------------------------------------------------------
378 
379 An Owned contract, to be inherited by other contracts.
380 Requires its owner to be explicitly set in the constructor.
381 Provides an onlyOwner access modifier.
382 
383 To change owner, the current owner must nominate the next owner,
384 who then has to accept the nomination. The nomination can be
385 cancelled before it is accepted by the new owner by having the
386 previous owner change the nomination (setting it to 0).
387 
388 -----------------------------------------------------------------
389 */
390 
391 
392 /**
393  * @title A contract with an owner.
394  * @notice Contract ownership can be transferred by first nominating the new owner,
395  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
396  */
397 contract Owned {
398     address public owner;
399     address public nominatedOwner;
400 
401     /**
402      * @dev Owned Constructor
403      */
404     constructor(address _owner)
405         public
406     {
407         require(_owner != address(0), "Owner address cannot be 0");
408         owner = _owner;
409         emit OwnerChanged(address(0), _owner);
410     }
411 
412     /**
413      * @notice Nominate a new owner of this contract.
414      * @dev Only the current owner may nominate a new owner.
415      */
416     function nominateNewOwner(address _owner)
417         external
418         onlyOwner
419     {
420         nominatedOwner = _owner;
421         emit OwnerNominated(_owner);
422     }
423 
424     /**
425      * @notice Accept the nomination to be owner.
426      */
427     function acceptOwnership()
428         external
429     {
430         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
431         emit OwnerChanged(owner, nominatedOwner);
432         owner = nominatedOwner;
433         nominatedOwner = address(0);
434     }
435 
436     modifier onlyOwner
437     {
438         require(msg.sender == owner, "Only the contract owner may perform this action");
439         _;
440     }
441 
442     event OwnerNominated(address newOwner);
443     event OwnerChanged(address oldOwner, address newOwner);
444 }
445 
446 /*
447 -----------------------------------------------------------------
448 FILE INFORMATION
449 -----------------------------------------------------------------
450 
451 file:       SelfDestructible.sol
452 version:    1.2
453 author:     Anton Jurisevic
454 
455 date:       2018-05-29
456 
457 -----------------------------------------------------------------
458 MODULE DESCRIPTION
459 -----------------------------------------------------------------
460 
461 This contract allows an inheriting contract to be destroyed after
462 its owner indicates an intention and then waits for a period
463 without changing their mind. All ether contained in the contract
464 is forwarded to a nominated beneficiary upon destruction.
465 
466 -----------------------------------------------------------------
467 */
468 
469 
470 /**
471  * @title A contract that can be destroyed by its owner after a delay elapses.
472  */
473 contract SelfDestructible is Owned {
474     
475     uint public initiationTime;
476     bool public selfDestructInitiated;
477     address public selfDestructBeneficiary;
478     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
479 
480     /**
481      * @dev Constructor
482      * @param _owner The account which controls this contract.
483      */
484     constructor(address _owner)
485         Owned(_owner)
486         public
487     {
488         require(_owner != address(0), "Owner must not be zero");
489         selfDestructBeneficiary = _owner;
490         emit SelfDestructBeneficiaryUpdated(_owner);
491     }
492 
493     /**
494      * @notice Set the beneficiary address of this contract.
495      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
496      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
497      */
498     function setSelfDestructBeneficiary(address _beneficiary)
499         external
500         onlyOwner
501     {
502         require(_beneficiary != address(0), "Beneficiary must not be zero");
503         selfDestructBeneficiary = _beneficiary;
504         emit SelfDestructBeneficiaryUpdated(_beneficiary);
505     }
506 
507     /**
508      * @notice Begin the self-destruction counter of this contract.
509      * Once the delay has elapsed, the contract may be self-destructed.
510      * @dev Only the contract owner may call this.
511      */
512     function initiateSelfDestruct()
513         external
514         onlyOwner
515     {
516         initiationTime = now;
517         selfDestructInitiated = true;
518         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
519     }
520 
521     /**
522      * @notice Terminate and reset the self-destruction timer.
523      * @dev Only the contract owner may call this.
524      */
525     function terminateSelfDestruct()
526         external
527         onlyOwner
528     {
529         initiationTime = 0;
530         selfDestructInitiated = false;
531         emit SelfDestructTerminated();
532     }
533 
534     /**
535      * @notice If the self-destruction delay has elapsed, destroy this contract and
536      * remit any ether it owns to the beneficiary address.
537      * @dev Only the contract owner may call this.
538      */
539     function selfDestruct()
540         external
541         onlyOwner
542     {
543         require(selfDestructInitiated, "Self Destruct not yet initiated");
544         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay not met");
545         address beneficiary = selfDestructBeneficiary;
546         emit SelfDestructed(beneficiary);
547         selfdestruct(beneficiary);
548     }
549 
550     event SelfDestructTerminated();
551     event SelfDestructed(address beneficiary);
552     event SelfDestructInitiated(uint selfDestructDelay);
553     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
554 }
555 
556 
557 interface AggregatorInterface {
558   function latestAnswer() external view returns (int256);
559   function latestTimestamp() external view returns (uint256);
560   function latestRound() external view returns (uint256);
561   function getAnswer(uint256 roundId) external view returns (int256);
562   function getTimestamp(uint256 roundId) external view returns (uint256);
563 
564   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
565   event NewRound(uint256 indexed roundId, address indexed startedBy);
566 }
567 
568 
569 // AggregatorInterface from Chainlink represents a decentralized pricing network for a single currency keys
570 
571 
572 /**
573  * @title The repository for exchange rates
574  */
575 
576 contract ExchangeRates is SelfDestructible {
577 
578 
579     using SafeMath for uint;
580     using SafeDecimalMath for uint;
581 
582     struct RateAndUpdatedTime {
583         uint216 rate;
584         uint40 time;
585     }
586 
587     // Exchange rates and update times stored by currency code, e.g. 'SNX', or 'sUSD'
588     mapping(bytes32 => RateAndUpdatedTime) private _rates;
589 
590     // The address of the oracle which pushes rate updates to this contract
591     address public oracle;
592 
593     // Decentralized oracle networks that feed into pricing aggregators
594     mapping(bytes32 => AggregatorInterface) public aggregators;
595 
596     // List of configure aggregator keys for convenient iteration
597     bytes32[] public aggregatorKeys;
598 
599     // Do not allow the oracle to submit times any further forward into the future than this constant.
600     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
601 
602     // How long will the contract assume the rate of any asset is correct
603     uint public rateStalePeriod = 3 hours;
604 
605 
606     // Each participating currency in the XDR basket is represented as a currency key with
607     // equal weighting.
608     // There are 5 participating currencies, so we'll declare that clearly.
609     bytes32[5] public xdrParticipants;
610 
611     // A conveience mapping for checking if a rate is a XDR participant
612     mapping(bytes32 => bool) public isXDRParticipant;
613 
614     // For inverted prices, keep a mapping of their entry, limits and frozen status
615     struct InversePricing {
616         uint entryPoint;
617         uint upperLimit;
618         uint lowerLimit;
619         bool frozen;
620     }
621     mapping(bytes32 => InversePricing) public inversePricing;
622     bytes32[] public invertedKeys;
623 
624     //
625     // ========== CONSTRUCTOR ==========
626 
627     /**
628      * @dev Constructor
629      * @param _owner The owner of this contract.
630      * @param _oracle The address which is able to update rate information.
631      * @param _currencyKeys The initial currency keys to store (in order).
632      * @param _newRates The initial currency amounts for each currency (in order).
633      */
634     constructor(
635         // SelfDestructible (Ownable)
636         address _owner,
637 
638         // Oracle values - Allows for rate updates
639         address _oracle,
640         bytes32[] _currencyKeys,
641         uint[] _newRates
642     )
643         /* Owned is initialised in SelfDestructible */
644         SelfDestructible(_owner)
645         public
646     {
647         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
648 
649         oracle = _oracle;
650 
651         // The sUSD rate is always 1 and is never stale.
652         _setRate("sUSD", SafeDecimalMath.unit(), now);
653 
654         // These are the currencies that make up the XDR basket.
655         // These are hard coded because:
656         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
657         //  - Adding new currencies would likely introduce some kind of weighting factor, which
658         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
659         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
660         //    then point the system at the new version.
661         xdrParticipants = [
662             bytes32("sUSD"),
663             bytes32("sAUD"),
664             bytes32("sCHF"),
665             bytes32("sEUR"),
666             bytes32("sGBP")
667         ];
668 
669         // Mapping the XDR participants is cheaper than looping the xdrParticipants array to check if they exist
670         isXDRParticipant[bytes32("sUSD")] = true;
671         isXDRParticipant[bytes32("sAUD")] = true;
672         isXDRParticipant[bytes32("sCHF")] = true;
673         isXDRParticipant[bytes32("sEUR")] = true;
674         isXDRParticipant[bytes32("sGBP")] = true;
675 
676         internalUpdateRates(_currencyKeys, _newRates, now);
677     }
678 
679     function getRateAndUpdatedTime(bytes32 code) internal view returns (RateAndUpdatedTime) {
680         if (code == "XDR") {
681             // The XDR rate is the sum of the underlying XDR participant rates, and the latest
682             // timestamp from those rates
683             uint total = 0;
684             uint lastUpdated = 0;
685             for (uint i = 0; i < xdrParticipants.length; i++) {
686                 RateAndUpdatedTime memory xdrEntry = getRateAndUpdatedTime(xdrParticipants[i]);
687                 total = total.add(xdrEntry.rate);
688                 if (xdrEntry.time > lastUpdated) {
689                     lastUpdated = xdrEntry.time;
690                 }
691             }
692             return RateAndUpdatedTime({
693                 rate: uint216(total),
694                 time: uint40(lastUpdated)
695             });
696         } else if (aggregators[code] != address(0)) {
697             return RateAndUpdatedTime({
698                 rate: uint216(aggregators[code].latestAnswer() * 1e10),
699                 time: uint40(aggregators[code].latestTimestamp())
700             });
701         } else {
702             return _rates[code];
703         }
704     }
705     /**
706      * @notice Retrieves the exchange rate (sUSD per unit) for a given currency key
707      */
708     function rates(bytes32 code) public view returns(uint256) {
709         return getRateAndUpdatedTime(code).rate;
710     }
711 
712     /**
713      * @notice Retrieves the timestamp the given rate was last updated.
714      */
715     function lastRateUpdateTimes(bytes32 code) public view returns(uint256) {
716         return getRateAndUpdatedTime(code).time;
717     }
718 
719     /**
720      * @notice Retrieve the last update time for a list of currencies
721      */
722     function lastRateUpdateTimesForCurrencies(bytes32[] currencyKeys)
723         public
724         view
725         returns (uint[])
726     {
727         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
728 
729         for (uint i = 0; i < currencyKeys.length; i++) {
730             lastUpdateTimes[i] = lastRateUpdateTimes(currencyKeys[i]);
731         }
732 
733         return lastUpdateTimes;
734     }
735 
736     function _setRate(bytes32 code, uint256 rate, uint256 time) internal {
737         _rates[code] = RateAndUpdatedTime({
738             rate: uint216(rate),
739             time: uint40(time)
740         });
741     }
742 
743     /* ========== SETTERS ========== */
744 
745     /**
746      * @notice Set the rates stored in this contract
747      * @param currencyKeys The currency keys you wish to update the rates for (in order)
748      * @param newRates The rates for each currency (in order)
749      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
750      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
751      *                 if it takes a long time for the transaction to confirm.
752      */
753     function updateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
754         external
755         onlyOracle
756         returns(bool)
757     {
758         return internalUpdateRates(currencyKeys, newRates, timeSent);
759     }
760 
761     /**
762      * @notice Internal function which sets the rates stored in this contract
763      * @param currencyKeys The currency keys you wish to update the rates for (in order)
764      * @param newRates The rates for each currency (in order)
765      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
766      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
767      *                 if it takes a long time for the transaction to confirm.
768      */
769     function internalUpdateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
770         internal
771         returns(bool)
772     {
773         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
774         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
775 
776         // Loop through each key and perform update.
777         for (uint i = 0; i < currencyKeys.length; i++) {
778             bytes32 currencyKey = currencyKeys[i];
779 
780             // Should not set any rate to zero ever, as no asset will ever be
781             // truely worthless and still valid. In this scenario, we should
782             // delete the rate and remove it from the system.
783             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
784             require(currencyKey != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
785 
786             // We should only update the rate if it's at least the same age as the last rate we've got.
787             if (timeSent < lastRateUpdateTimes(currencyKey)) {
788                 continue;
789             }
790 
791             newRates[i] = rateOrInverted(currencyKey, newRates[i]);
792 
793             // Ok, go ahead with the update.
794             _setRate(currencyKey, newRates[i], timeSent);
795         }
796 
797         emit RatesUpdated(currencyKeys, newRates);
798 
799         return true;
800     }
801 
802     /**
803      * @notice Internal function to get the inverted rate, if any, and mark an inverted
804      *  key as frozen if either limits are reached.
805      *
806      * Inverted rates are ones that take a regular rate, perform a simple calculation (double entryPrice and
807      * subtract the rate) on them and if the result of the calculation is over or under predefined limits, it freezes the
808      * rate at that limit, preventing any future rate updates.
809      *
810      * For example, if we have an inverted rate iBTC with the following parameters set:
811      * - entryPrice of 200
812      * - upperLimit of 300
813      * - lower of 100
814      *
815      * if this function is invoked with params iETH and 184 (or rather 184e18),
816      * then the rate would be: 200 * 2 - 184 = 216. 100 < 216 < 200, so the rate would be 216,
817      * and remain unfrozen.
818      *
819      * If this function is then invoked with params iETH and 301 (or rather 301e18),
820      * then the rate would be: 200 * 2 - 301 = 99. 99 < 100, so the rate would be 100 and the
821      * rate would become frozen, no longer accepting future price updates until the synth is unfrozen
822      * by the owner function: setInversePricing().
823      *
824      * @param currencyKey The price key to lookup
825      * @param rate The rate for the given price key
826      */
827     function rateOrInverted(bytes32 currencyKey, uint rate) internal returns (uint) {
828         // if an inverse mapping exists, adjust the price accordingly
829         InversePricing storage inverse = inversePricing[currencyKey];
830         if (inverse.entryPoint <= 0) {
831             return rate;
832         }
833 
834         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
835         uint newInverseRate = rates(currencyKey);
836 
837         // get the new inverted rate if not frozen
838         if (!inverse.frozen) {
839             uint doubleEntryPoint = inverse.entryPoint.mul(2);
840             if (doubleEntryPoint <= rate) {
841                 // avoid negative numbers for unsigned ints, so set this to 0
842                 // which by the requirement that lowerLimit be > 0 will
843                 // cause this to freeze the price to the lowerLimit
844                 newInverseRate = 0;
845             } else {
846                 newInverseRate = doubleEntryPoint.sub(rate);
847             }
848 
849             // now if new rate hits our limits, set it to the limit and freeze
850             if (newInverseRate >= inverse.upperLimit) {
851                 newInverseRate = inverse.upperLimit;
852             } else if (newInverseRate <= inverse.lowerLimit) {
853                 newInverseRate = inverse.lowerLimit;
854             }
855 
856             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
857                 inverse.frozen = true;
858                 emit InversePriceFrozen(currencyKey);
859             }
860         }
861 
862         return newInverseRate;
863     }
864 
865     /**
866      * @notice Delete a rate stored in the contract
867      * @param currencyKey The currency key you wish to delete the rate for
868      */
869     function deleteRate(bytes32 currencyKey)
870         external
871         onlyOracle
872     {
873         require(rates(currencyKey) > 0, "Rate is zero");
874 
875         delete _rates[currencyKey];
876 
877         emit RateDeleted(currencyKey);
878     }
879 
880     /**
881      * @notice Set the Oracle that pushes the rate information to this contract
882      * @param _oracle The new oracle address
883      */
884     function setOracle(address _oracle)
885         external
886         onlyOwner
887     {
888         oracle = _oracle;
889         emit OracleUpdated(oracle);
890     }
891 
892     /**
893      * @notice Set the stale period on the updated rate variables
894      * @param _time The new rateStalePeriod
895      */
896     function setRateStalePeriod(uint _time)
897         external
898         onlyOwner
899     {
900         rateStalePeriod = _time;
901         emit RateStalePeriodUpdated(rateStalePeriod);
902     }
903 
904     /**
905      * @notice Set an inverse price up for the currency key.
906      *
907      * An inverse price is one which has an entryPoint, an uppper and a lower limit. Each update, the
908      * rate is calculated as double the entryPrice minus the current rate. If this calculation is
909      * above or below the upper or lower limits respectively, then the rate is frozen, and no more
910      * rate updates will be accepted.
911      *
912      * @param currencyKey The currency to update
913      * @param entryPoint The entry price point of the inverted price
914      * @param upperLimit The upper limit, at or above which the price will be frozen
915      * @param lowerLimit The lower limit, at or below which the price will be frozen
916      * @param freeze Whether or not to freeze this rate immediately. Note: no frozen event will be configured
917      * @param freezeAtUpperLimit When the freeze flag is true, this flag indicates whether the rate
918      * to freeze at is the upperLimit or lowerLimit..
919      */
920     function setInversePricing(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit, bool freeze, bool freezeAtUpperLimit)
921         external onlyOwner
922     {
923         require(entryPoint > 0, "entryPoint must be above 0");
924         require(lowerLimit > 0, "lowerLimit must be above 0");
925         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
926         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
927         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
928 
929         if (inversePricing[currencyKey].entryPoint <= 0) {
930             // then we are adding a new inverse pricing, so add this
931             invertedKeys.push(currencyKey);
932         }
933         inversePricing[currencyKey].entryPoint = entryPoint;
934         inversePricing[currencyKey].upperLimit = upperLimit;
935         inversePricing[currencyKey].lowerLimit = lowerLimit;
936         inversePricing[currencyKey].frozen = freeze;
937 
938         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
939 
940         // When indicating to freeze, we need to know the rate to freeze it at - either upper or lower
941         // this is useful in situations where ExchangeRates is updated and there are existing inverted
942         // rates already frozen in the current contract that need persisting across the upgrade
943         if (freeze) {
944             emit InversePriceFrozen(currencyKey);
945 
946             _setRate(currencyKey, freezeAtUpperLimit ? upperLimit : lowerLimit, now);
947         }
948     }
949 
950     /**
951      * @notice Remove an inverse price for the currency key
952      * @param currencyKey The currency to remove inverse pricing for
953      */
954     function removeInversePricing(bytes32 currencyKey) external onlyOwner
955     {
956         require(inversePricing[currencyKey].entryPoint > 0, "No inverted price exists");
957 
958         inversePricing[currencyKey].entryPoint = 0;
959         inversePricing[currencyKey].upperLimit = 0;
960         inversePricing[currencyKey].lowerLimit = 0;
961         inversePricing[currencyKey].frozen = false;
962 
963         // now remove inverted key from array
964         bool wasRemoved = removeFromArray(currencyKey, invertedKeys);
965 
966         if (wasRemoved) {
967             emit InversePriceConfigured(currencyKey, 0, 0, 0);
968         }
969     }
970 
971     /**
972      * @notice Add a pricing aggregator for the given key. Note: existing aggregators may be overridden.
973      * @param currencyKey The currency key to add an aggregator for
974      */
975     function addAggregator(bytes32 currencyKey, address aggregatorAddress) external onlyOwner {
976         AggregatorInterface aggregator = AggregatorInterface(aggregatorAddress);
977         require(aggregator.latestTimestamp() >= 0, "Given Aggregator is invalid");
978         if (aggregators[currencyKey] == address(0)) {
979             aggregatorKeys.push(currencyKey);
980         }
981         aggregators[currencyKey] = aggregator;
982         emit AggregatorAdded(currencyKey, aggregator);
983     }
984 
985     /**
986      * @notice Remove a single value from an array by iterating through until it is found.
987      * @param entry The entry to find
988      * @param array The array to mutate
989      * @return bool Whether or not the entry was found and removed
990      */
991     function removeFromArray(bytes32 entry, bytes32[] storage array) internal returns (bool) {
992         for (uint i = 0; i < array.length; i++) {
993             if (array[i] == entry) {
994                 delete array[i];
995 
996                 // Copy the last key into the place of the one we just deleted
997                 // If there's only one key, this is array[0] = array[0].
998                 // If we're deleting the last one, it's also a NOOP in the same way.
999                 array[i] = array[array.length - 1];
1000 
1001                 // Decrease the size of the array by one.
1002                 array.length--;
1003 
1004                 return true;
1005             }
1006         }
1007         return false;
1008     }
1009     /**
1010      * @notice Remove a pricing aggregator for the given key
1011      * @param currencyKey THe currency key to remove an aggregator for
1012      */
1013     function removeAggregator(bytes32 currencyKey) external onlyOwner {
1014         address aggregator = aggregators[currencyKey];
1015         require(aggregator != address(0), "No aggregator exists for key");
1016         delete aggregators[currencyKey];
1017 
1018         bool wasRemoved = removeFromArray(currencyKey, aggregatorKeys);
1019 
1020         if (wasRemoved) {
1021             emit AggregatorRemoved(currencyKey, aggregator);
1022         }
1023     }
1024 
1025     /* ========== VIEWS ========== */
1026 
1027     /**
1028      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
1029      * @param sourceCurrencyKey The currency the amount is specified in
1030      * @param sourceAmount The source amount, specified in UNIT base
1031      * @param destinationCurrencyKey The destination currency
1032      */
1033     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
1034         public
1035         view
1036         rateNotStale(sourceCurrencyKey)
1037         rateNotStale(destinationCurrencyKey)
1038         returns (uint)
1039     {
1040         // If there's no change in the currency, then just return the amount they gave us
1041         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
1042 
1043         // Calculate the effective value by going from source -> USD -> destination
1044         return sourceAmount.multiplyDecimalRound(rateForCurrency(sourceCurrencyKey))
1045             .divideDecimalRound(rateForCurrency(destinationCurrencyKey));
1046     }
1047 
1048     /**
1049      * @notice Retrieve the rate for a specific currency
1050      */
1051     function rateForCurrency(bytes32 currencyKey)
1052         public
1053         view
1054         returns (uint)
1055     {
1056         return rates(currencyKey);
1057     }
1058 
1059     /**
1060      * @notice Retrieve the rates for a list of currencies
1061      */
1062     function ratesForCurrencies(bytes32[] currencyKeys)
1063         public
1064         view
1065         returns (uint[])
1066     {
1067         uint[] memory _localRates = new uint[](currencyKeys.length);
1068 
1069         for (uint i = 0; i < currencyKeys.length; i++) {
1070             _localRates[i] = rates(currencyKeys[i]);
1071         }
1072 
1073         return _localRates;
1074     }
1075 
1076     /**
1077      * @notice Retrieve the rates and isAnyStale for a list of currencies
1078      */
1079     function ratesAndStaleForCurrencies(bytes32[] currencyKeys)
1080         public
1081         view
1082         returns (uint[], bool)
1083     {
1084         uint[] memory _localRates = new uint[](currencyKeys.length);
1085 
1086         bool anyRateStale = false;
1087         uint period = rateStalePeriod;
1088         for (uint i = 0; i < currencyKeys.length; i++) {
1089             RateAndUpdatedTime memory rateAndUpdateTime = getRateAndUpdatedTime(currencyKeys[i]);
1090             _localRates[i] = uint256(rateAndUpdateTime.rate);
1091             if (!anyRateStale) {
1092                 anyRateStale = (currencyKeys[i] != "sUSD" && uint256(rateAndUpdateTime.time).add(period) < now);
1093             }
1094         }
1095 
1096         return (_localRates, anyRateStale);
1097     }
1098 
1099     /**
1100      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
1101      */
1102     function rateIsStale(bytes32 currencyKey)
1103         public
1104         view
1105         returns (bool)
1106     {
1107         // sUSD is a special case and is never stale.
1108         if (currencyKey == "sUSD") return false;
1109 
1110         return lastRateUpdateTimes(currencyKey).add(rateStalePeriod) < now;
1111     }
1112 
1113     /**
1114      * @notice Check if any rate is frozen (cannot be exchanged into)
1115      */
1116     function rateIsFrozen(bytes32 currencyKey)
1117         external
1118         view
1119         returns (bool)
1120     {
1121         return inversePricing[currencyKey].frozen;
1122     }
1123 
1124 
1125     /**
1126      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
1127      */
1128     function anyRateIsStale(bytes32[] currencyKeys)
1129         external
1130         view
1131         returns (bool)
1132     {
1133         // Loop through each key and check whether the data point is stale.
1134         uint256 i = 0;
1135 
1136         while (i < currencyKeys.length) {
1137             // sUSD is a special case and is never false
1138             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes(currencyKeys[i]).add(rateStalePeriod) < now) {
1139                 return true;
1140             }
1141             i += 1;
1142         }
1143 
1144         return false;
1145     }
1146 
1147     /* ========== MODIFIERS ========== */
1148 
1149     modifier rateNotStale(bytes32 currencyKey) {
1150         require(!rateIsStale(currencyKey), "Rate stale or nonexistant currency");
1151         _;
1152     }
1153 
1154     modifier onlyOracle
1155     {
1156         require(msg.sender == oracle, "Only the oracle can perform this action");
1157         _;
1158     }
1159 
1160     /* ========== EVENTS ========== */
1161 
1162     event OracleUpdated(address newOracle);
1163     event RateStalePeriodUpdated(uint rateStalePeriod);
1164     event RatesUpdated(bytes32[] currencyKeys, uint[] newRates);
1165     event RateDeleted(bytes32 currencyKey);
1166     event InversePriceConfigured(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
1167     event InversePriceFrozen(bytes32 currencyKey);
1168     event AggregatorAdded(bytes32 currencyKey, address aggregator);
1169     event AggregatorRemoved(bytes32 currencyKey, address aggregator);
1170 }
1171 
1172 
1173     