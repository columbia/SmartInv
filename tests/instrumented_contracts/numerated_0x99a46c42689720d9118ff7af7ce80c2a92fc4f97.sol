1 /* ===============================================
2 * Flattened with Solidifier by Coinage
3 * 
4 * https://solidifier.coina.ge
5 * ===============================================
6 */
7 
8 
9 pragma solidity ^0.4.24;
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that revert on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, reverts on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
22     // benefit is lost if 'b' is also tested.
23     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24     if (a == 0) {
25       return 0;
26     }
27 
28     uint256 c = a * b;
29     require(c / a == b);
30 
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b > 0); // Solidity only automatically asserts when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 
42     return c;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b <= a);
50     uint256 c = a - b;
51 
52     return c;
53   }
54 
55   /**
56   * @dev Adds two numbers, reverts on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     require(c >= a);
61 
62     return c;
63   }
64 
65   /**
66   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
67   * reverts when dividing by zero.
68   */
69   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b != 0);
71     return a % b;
72   }
73 }
74 
75 
76 /*
77 
78 -----------------------------------------------------------------
79 FILE INFORMATION
80 -----------------------------------------------------------------
81 
82 file:       SafeDecimalMath.sol
83 version:    2.0
84 author:     Kevin Brown
85             Gavin Conway
86 date:       2018-10-18
87 
88 -----------------------------------------------------------------
89 MODULE DESCRIPTION
90 -----------------------------------------------------------------
91 
92 A library providing safe mathematical operations for division and
93 multiplication with the capability to round or truncate the results
94 to the nearest increment. Operations can return a standard precision
95 or high precision decimal. High precision decimals are useful for
96 example when attempting to calculate percentages or fractions
97 accurately.
98 
99 -----------------------------------------------------------------
100 */
101 
102 
103 /**
104  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
105  * @dev Functions accepting uints in this contract and derived contracts
106  * are taken to be such fixed point decimals of a specified precision (either standard
107  * or high).
108  */
109 library SafeDecimalMath {
110 
111     using SafeMath for uint;
112 
113     /* Number of decimal places in the representations. */
114     uint8 public constant decimals = 18;
115     uint8 public constant highPrecisionDecimals = 27;
116 
117     /* The number representing 1.0. */
118     uint public constant UNIT = 10 ** uint(decimals);
119 
120     /* The number representing 1.0 for higher fidelity numbers. */
121     uint public constant PRECISE_UNIT = 10 ** uint(highPrecisionDecimals);
122     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10 ** uint(highPrecisionDecimals - decimals);
123 
124     /** 
125      * @return Provides an interface to UNIT.
126      */
127     function unit()
128         external
129         pure
130         returns (uint)
131     {
132         return UNIT;
133     }
134 
135     /** 
136      * @return Provides an interface to PRECISE_UNIT.
137      */
138     function preciseUnit()
139         external
140         pure 
141         returns (uint)
142     {
143         return PRECISE_UNIT;
144     }
145 
146     /**
147      * @return The result of multiplying x and y, interpreting the operands as fixed-point
148      * decimals.
149      * 
150      * @dev A unit factor is divided out after the product of x and y is evaluated,
151      * so that product must be less than 2**256. As this is an integer division,
152      * the internal division always rounds down. This helps save on gas. Rounding
153      * is more expensive on gas.
154      */
155     function multiplyDecimal(uint x, uint y)
156         internal
157         pure
158         returns (uint)
159     {
160         /* Divide by UNIT to remove the extra factor introduced by the product. */
161         return x.mul(y) / UNIT;
162     }
163 
164     /**
165      * @return The result of safely multiplying x and y, interpreting the operands
166      * as fixed-point decimals of the specified precision unit.
167      *
168      * @dev The operands should be in the form of a the specified unit factor which will be
169      * divided out after the product of x and y is evaluated, so that product must be
170      * less than 2**256.
171      *
172      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
173      * Rounding is useful when you need to retain fidelity for small decimal numbers
174      * (eg. small fractions or percentages).
175      */
176     function _multiplyDecimalRound(uint x, uint y, uint precisionUnit)
177         private
178         pure
179         returns (uint)
180     {
181         /* Divide by UNIT to remove the extra factor introduced by the product. */
182         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
183 
184         if (quotientTimesTen % 10 >= 5) {
185             quotientTimesTen += 10;
186         }
187 
188         return quotientTimesTen / 10;
189     }
190 
191     /**
192      * @return The result of safely multiplying x and y, interpreting the operands
193      * as fixed-point decimals of a precise unit.
194      *
195      * @dev The operands should be in the precise unit factor which will be
196      * divided out after the product of x and y is evaluated, so that product must be
197      * less than 2**256.
198      *
199      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
200      * Rounding is useful when you need to retain fidelity for small decimal numbers
201      * (eg. small fractions or percentages).
202      */
203     function multiplyDecimalRoundPrecise(uint x, uint y)
204         internal
205         pure
206         returns (uint)
207     {
208         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
209     }
210 
211     /**
212      * @return The result of safely multiplying x and y, interpreting the operands
213      * as fixed-point decimals of a standard unit.
214      *
215      * @dev The operands should be in the standard unit factor which will be
216      * divided out after the product of x and y is evaluated, so that product must be
217      * less than 2**256.
218      *
219      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
220      * Rounding is useful when you need to retain fidelity for small decimal numbers
221      * (eg. small fractions or percentages).
222      */
223     function multiplyDecimalRound(uint x, uint y)
224         internal
225         pure
226         returns (uint)
227     {
228         return _multiplyDecimalRound(x, y, UNIT);
229     }
230 
231     /**
232      * @return The result of safely dividing x and y. The return value is a high
233      * precision decimal.
234      * 
235      * @dev y is divided after the product of x and the standard precision unit
236      * is evaluated, so the product of x and UNIT must be less than 2**256. As
237      * this is an integer division, the result is always rounded down.
238      * This helps save on gas. Rounding is more expensive on gas.
239      */
240     function divideDecimal(uint x, uint y)
241         internal
242         pure
243         returns (uint)
244     {
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
257     function _divideDecimalRound(uint x, uint y, uint precisionUnit)
258         private
259         pure
260         returns (uint)
261     {
262         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
263 
264         if (resultTimesTen % 10 >= 5) {
265             resultTimesTen += 10;
266         }
267 
268         return resultTimesTen / 10;
269     }
270 
271     /**
272      * @return The result of safely dividing x and y. The return value is as a rounded
273      * standard precision decimal.
274      *
275      * @dev y is divided after the product of x and the standard precision unit
276      * is evaluated, so the product of x and the standard precision unit must
277      * be less than 2**256. The result is rounded to the nearest increment.
278      */
279     function divideDecimalRound(uint x, uint y)
280         internal
281         pure
282         returns (uint)
283     {
284         return _divideDecimalRound(x, y, UNIT);
285     }
286 
287     /**
288      * @return The result of safely dividing x and y. The return value is as a rounded
289      * high precision decimal.
290      *
291      * @dev y is divided after the product of x and the high precision unit
292      * is evaluated, so the product of x and the high precision unit must
293      * be less than 2**256. The result is rounded to the nearest increment.
294      */
295     function divideDecimalRoundPrecise(uint x, uint y)
296         internal
297         pure
298         returns (uint)
299     {
300         return _divideDecimalRound(x, y, PRECISE_UNIT);
301     }
302 
303     /**
304      * @dev Convert a standard decimal representation to a high precision one.
305      */
306     function decimalToPreciseDecimal(uint i)
307         internal
308         pure
309         returns (uint)
310     {
311         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
312     }
313 
314     /**
315      * @dev Convert a high precision decimal to a standard decimal representation.
316      */
317     function preciseDecimalToDecimal(uint i)
318         internal
319         pure
320         returns (uint)
321     {
322         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
323 
324         if (quotientTimesTen % 10 >= 5) {
325             quotientTimesTen += 10;
326         }
327 
328         return quotientTimesTen / 10;
329     }
330 
331 }
332 
333 
334 /*
335 -----------------------------------------------------------------
336 FILE INFORMATION
337 -----------------------------------------------------------------
338 
339 file:       Owned.sol
340 version:    1.1
341 author:     Anton Jurisevic
342             Dominic Romanowski
343 
344 date:       2018-2-26
345 
346 -----------------------------------------------------------------
347 MODULE DESCRIPTION
348 -----------------------------------------------------------------
349 
350 An Owned contract, to be inherited by other contracts.
351 Requires its owner to be explicitly set in the constructor.
352 Provides an onlyOwner access modifier.
353 
354 To change owner, the current owner must nominate the next owner,
355 who then has to accept the nomination. The nomination can be
356 cancelled before it is accepted by the new owner by having the
357 previous owner change the nomination (setting it to 0).
358 
359 -----------------------------------------------------------------
360 */
361 
362 
363 /**
364  * @title A contract with an owner.
365  * @notice Contract ownership can be transferred by first nominating the new owner,
366  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
367  */
368 contract Owned {
369     address public owner;
370     address public nominatedOwner;
371 
372     /**
373      * @dev Owned Constructor
374      */
375     constructor(address _owner)
376         public
377     {
378         require(_owner != address(0), "Owner address cannot be 0");
379         owner = _owner;
380         emit OwnerChanged(address(0), _owner);
381     }
382 
383     /**
384      * @notice Nominate a new owner of this contract.
385      * @dev Only the current owner may nominate a new owner.
386      */
387     function nominateNewOwner(address _owner)
388         external
389         onlyOwner
390     {
391         nominatedOwner = _owner;
392         emit OwnerNominated(_owner);
393     }
394 
395     /**
396      * @notice Accept the nomination to be owner.
397      */
398     function acceptOwnership()
399         external
400     {
401         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
402         emit OwnerChanged(owner, nominatedOwner);
403         owner = nominatedOwner;
404         nominatedOwner = address(0);
405     }
406 
407     modifier onlyOwner
408     {
409         require(msg.sender == owner, "Only the contract owner may perform this action");
410         _;
411     }
412 
413     event OwnerNominated(address newOwner);
414     event OwnerChanged(address oldOwner, address newOwner);
415 }
416 
417 /*
418 -----------------------------------------------------------------
419 FILE INFORMATION
420 -----------------------------------------------------------------
421 
422 file:       SelfDestructible.sol
423 version:    1.2
424 author:     Anton Jurisevic
425 
426 date:       2018-05-29
427 
428 -----------------------------------------------------------------
429 MODULE DESCRIPTION
430 -----------------------------------------------------------------
431 
432 This contract allows an inheriting contract to be destroyed after
433 its owner indicates an intention and then waits for a period
434 without changing their mind. All ether contained in the contract
435 is forwarded to a nominated beneficiary upon destruction.
436 
437 -----------------------------------------------------------------
438 */
439 
440 
441 /**
442  * @title A contract that can be destroyed by its owner after a delay elapses.
443  */
444 contract SelfDestructible is Owned {
445     
446     uint public initiationTime;
447     bool public selfDestructInitiated;
448     address public selfDestructBeneficiary;
449     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
450 
451     /**
452      * @dev Constructor
453      * @param _owner The account which controls this contract.
454      */
455     constructor(address _owner)
456         Owned(_owner)
457         public
458     {
459         require(_owner != address(0), "Owner must not be zero");
460         selfDestructBeneficiary = _owner;
461         emit SelfDestructBeneficiaryUpdated(_owner);
462     }
463 
464     /**
465      * @notice Set the beneficiary address of this contract.
466      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
467      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
468      */
469     function setSelfDestructBeneficiary(address _beneficiary)
470         external
471         onlyOwner
472     {
473         require(_beneficiary != address(0), "Beneficiary must not be zero");
474         selfDestructBeneficiary = _beneficiary;
475         emit SelfDestructBeneficiaryUpdated(_beneficiary);
476     }
477 
478     /**
479      * @notice Begin the self-destruction counter of this contract.
480      * Once the delay has elapsed, the contract may be self-destructed.
481      * @dev Only the contract owner may call this.
482      */
483     function initiateSelfDestruct()
484         external
485         onlyOwner
486     {
487         initiationTime = now;
488         selfDestructInitiated = true;
489         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
490     }
491 
492     /**
493      * @notice Terminate and reset the self-destruction timer.
494      * @dev Only the contract owner may call this.
495      */
496     function terminateSelfDestruct()
497         external
498         onlyOwner
499     {
500         initiationTime = 0;
501         selfDestructInitiated = false;
502         emit SelfDestructTerminated();
503     }
504 
505     /**
506      * @notice If the self-destruction delay has elapsed, destroy this contract and
507      * remit any ether it owns to the beneficiary address.
508      * @dev Only the contract owner may call this.
509      */
510     function selfDestruct()
511         external
512         onlyOwner
513     {
514         require(selfDestructInitiated, "Self Destruct not yet initiated");
515         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay not met");
516         address beneficiary = selfDestructBeneficiary;
517         emit SelfDestructed(beneficiary);
518         selfdestruct(beneficiary);
519     }
520 
521     event SelfDestructTerminated();
522     event SelfDestructed(address beneficiary);
523     event SelfDestructInitiated(uint selfDestructDelay);
524     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
525 }
526 
527 
528 /*
529 -----------------------------------------------------------------
530 FILE INFORMATION
531 -----------------------------------------------------------------
532 
533 file:       ExchangeRates.sol
534 version:    1.0
535 author:     Kevin Brown
536 date:       2018-09-12
537 
538 -----------------------------------------------------------------
539 MODULE DESCRIPTION
540 -----------------------------------------------------------------
541 
542 A contract that any other contract in the Synthetix system can query
543 for the current market value of various assets, including
544 crypto assets as well as various fiat assets.
545 
546 This contract assumes that rate updates will completely update
547 all rates to their current values. If a rate shock happens
548 on a single asset, the oracle will still push updated rates
549 for all other assets.
550 
551 -----------------------------------------------------------------
552 */
553 
554 
555 /**
556  * @title The repository for exchange rates
557  */
558 
559 contract ExchangeRates is SelfDestructible {
560 
561 
562     using SafeMath for uint;
563     using SafeDecimalMath for uint;
564 
565     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
566     mapping(bytes32 => uint) public rates;
567 
568     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
569     mapping(bytes32 => uint) public lastRateUpdateTimes;
570 
571     // The address of the oracle which pushes rate updates to this contract
572     address public oracle;
573 
574     // Do not allow the oracle to submit times any further forward into the future than this constant.
575     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
576 
577     // How long will the contract assume the rate of any asset is correct
578     uint public rateStalePeriod = 3 hours;
579 
580     // Lock exchanges until price update complete
581     bool public priceUpdateLock = false;
582 
583     // Each participating currency in the XDR basket is represented as a currency key with
584     // equal weighting.
585     // There are 5 participating currencies, so we'll declare that clearly.
586     bytes32[5] public xdrParticipants;
587 
588     // For inverted prices, keep a mapping of their entry, limits and frozen status
589     struct InversePricing {
590         uint entryPoint;
591         uint upperLimit;
592         uint lowerLimit;
593         bool frozen;
594     }
595     mapping(bytes32 => InversePricing) public inversePricing;
596     bytes32[] public invertedKeys;
597 
598     //
599     // ========== CONSTRUCTOR ==========
600 
601     /**
602      * @dev Constructor
603      * @param _owner The owner of this contract.
604      * @param _oracle The address which is able to update rate information.
605      * @param _currencyKeys The initial currency keys to store (in order).
606      * @param _newRates The initial currency amounts for each currency (in order).
607      */
608     constructor(
609         // SelfDestructible (Ownable)
610         address _owner,
611 
612         // Oracle values - Allows for rate updates
613         address _oracle,
614         bytes32[] _currencyKeys,
615         uint[] _newRates
616     )
617         /* Owned is initialised in SelfDestructible */
618         SelfDestructible(_owner)
619         public
620     {
621         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
622 
623         oracle = _oracle;
624 
625         // The sUSD rate is always 1 and is never stale.
626         rates["sUSD"] = SafeDecimalMath.unit();
627         lastRateUpdateTimes["sUSD"] = now;
628 
629         // These are the currencies that make up the XDR basket.
630         // These are hard coded because:
631         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
632         //  - Adding new currencies would likely introduce some kind of weighting factor, which
633         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
634         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
635         //    then point the system at the new version.
636         xdrParticipants = [
637             bytes32("sUSD"),
638             bytes32("sAUD"),
639             bytes32("sCHF"),
640             bytes32("sEUR"),
641             bytes32("sGBP")
642         ];
643 
644         internalUpdateRates(_currencyKeys, _newRates, now);
645     }
646 
647     /* ========== SETTERS ========== */
648 
649     /**
650      * @notice Set the rates stored in this contract
651      * @param currencyKeys The currency keys you wish to update the rates for (in order)
652      * @param newRates The rates for each currency (in order)
653      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
654      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
655      *                 if it takes a long time for the transaction to confirm.
656      */
657     function updateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
658         external
659         onlyOracle
660         returns(bool)
661     {
662         return internalUpdateRates(currencyKeys, newRates, timeSent);
663     }
664 
665     /**
666      * @notice Internal function which sets the rates stored in this contract
667      * @param currencyKeys The currency keys you wish to update the rates for (in order)
668      * @param newRates The rates for each currency (in order)
669      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
670      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
671      *                 if it takes a long time for the transaction to confirm.
672      */
673     function internalUpdateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
674         internal
675         returns(bool)
676     {
677         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
678         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
679 
680         // Loop through each key and perform update.
681         for (uint i = 0; i < currencyKeys.length; i++) {
682             // Should not set any rate to zero ever, as no asset will ever be
683             // truely worthless and still valid. In this scenario, we should
684             // delete the rate and remove it from the system.
685             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
686             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
687 
688             // We should only update the rate if it's at least the same age as the last rate we've got.
689             if (timeSent < lastRateUpdateTimes[currencyKeys[i]]) {
690                 continue;
691             }
692 
693             newRates[i] = rateOrInverted(currencyKeys[i], newRates[i]);
694 
695             // Ok, go ahead with the update.
696             rates[currencyKeys[i]] = newRates[i];
697             lastRateUpdateTimes[currencyKeys[i]] = timeSent;
698         }
699 
700         emit RatesUpdated(currencyKeys, newRates);
701 
702         // Now update our XDR rate.
703         updateXDRRate(timeSent);
704 
705         // If locked during a priceupdate then reset it
706         if (priceUpdateLock) {
707             priceUpdateLock = false;
708         }
709 
710         return true;
711     }
712 
713     /**
714      * @notice Internal function to get the inverted rate, if any, and mark an inverted
715      *  key as frozen if either limits are reached.
716      * @param currencyKey The price key to lookup
717      * @param rate The rate for the given price key
718      */
719     function rateOrInverted(bytes32 currencyKey, uint rate) internal returns (uint) {
720         // if an inverse mapping exists, adjust the price accordingly
721         InversePricing storage inverse = inversePricing[currencyKey];
722         if (inverse.entryPoint <= 0) {
723             return rate;
724         }
725 
726         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
727         uint newInverseRate = rates[currencyKey];
728 
729         // get the new inverted rate if not frozen
730         if (!inverse.frozen) {
731             uint doubleEntryPoint = inverse.entryPoint.mul(2);
732             if (doubleEntryPoint <= rate) {
733                 // avoid negative numbers for unsigned ints, so set this to 0
734                 // which by the requirement that lowerLimit be > 0 will
735                 // cause this to freeze the price to the lowerLimit
736                 newInverseRate = 0;
737             } else {
738                 newInverseRate = doubleEntryPoint.sub(rate);
739             }
740 
741             // now if new rate hits our limits, set it to the limit and freeze
742             if (newInverseRate >= inverse.upperLimit) {
743                 newInverseRate = inverse.upperLimit;
744             } else if (newInverseRate <= inverse.lowerLimit) {
745                 newInverseRate = inverse.lowerLimit;
746             }
747 
748             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
749                 inverse.frozen = true;
750                 emit InversePriceFrozen(currencyKey);
751             }
752         }
753 
754         return newInverseRate;
755     }
756 
757     /**
758      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
759      */
760     function updateXDRRate(uint timeSent)
761         internal
762     {
763         uint total = 0;
764 
765         for (uint i = 0; i < xdrParticipants.length; i++) {
766             total = rates[xdrParticipants[i]].add(total);
767         }
768 
769         // Set the rate
770         rates["XDR"] = total;
771 
772         // Record that we updated the XDR rate.
773         lastRateUpdateTimes["XDR"] = timeSent;
774 
775         // Emit our updated event separate to the others to save
776         // moving data around between arrays.
777         bytes32[] memory eventCurrencyCode = new bytes32[](1);
778         eventCurrencyCode[0] = "XDR";
779 
780         uint[] memory eventRate = new uint[](1);
781         eventRate[0] = rates["XDR"];
782 
783         emit RatesUpdated(eventCurrencyCode, eventRate);
784     }
785 
786     /**
787      * @notice Delete a rate stored in the contract
788      * @param currencyKey The currency key you wish to delete the rate for
789      */
790     function deleteRate(bytes32 currencyKey)
791         external
792         onlyOracle
793     {
794         require(rates[currencyKey] > 0, "Rate is zero");
795 
796         delete rates[currencyKey];
797         delete lastRateUpdateTimes[currencyKey];
798 
799         emit RateDeleted(currencyKey);
800     }
801 
802     /**
803      * @notice Set the Oracle that pushes the rate information to this contract
804      * @param _oracle The new oracle address
805      */
806     function setOracle(address _oracle)
807         external
808         onlyOwner
809     {
810         oracle = _oracle;
811         emit OracleUpdated(oracle);
812     }
813 
814     /**
815      * @notice Set the stale period on the updated rate variables
816      * @param _time The new rateStalePeriod
817      */
818     function setRateStalePeriod(uint _time)
819         external
820         onlyOwner
821     {
822         rateStalePeriod = _time;
823         emit RateStalePeriodUpdated(rateStalePeriod);
824     }
825 
826     /**
827      * @notice Set the the locked state for a priceUpdate call
828      * @param _priceUpdateLock lock boolean flag
829      */
830     function setPriceUpdateLock(bool _priceUpdateLock)
831         external
832         onlyOracle
833     {
834         priceUpdateLock = _priceUpdateLock;
835     }
836 
837     /**
838      * @notice Set an inverse price up for the currency key
839      * @param currencyKey The currency to update
840      * @param entryPoint The entry price point of the inverted price
841      * @param upperLimit The upper limit, at or above which the price will be frozen
842      * @param lowerLimit The lower limit, at or below which the price will be frozen
843      */
844     function setInversePricing(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit)
845         external onlyOwner
846     {
847         require(entryPoint > 0, "entryPoint must be above 0");
848         require(lowerLimit > 0, "lowerLimit must be above 0");
849         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
850         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
851         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
852 
853         if (inversePricing[currencyKey].entryPoint <= 0) {
854             // then we are adding a new inverse pricing, so add this
855             invertedKeys.push(currencyKey);
856         }
857         inversePricing[currencyKey].entryPoint = entryPoint;
858         inversePricing[currencyKey].upperLimit = upperLimit;
859         inversePricing[currencyKey].lowerLimit = lowerLimit;
860         inversePricing[currencyKey].frozen = false;
861 
862         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
863     }
864 
865     /**
866      * @notice Remove an inverse price for the currency key
867      * @param currencyKey The currency to remove inverse pricing for
868      */
869     function removeInversePricing(bytes32 currencyKey) external onlyOwner {
870         inversePricing[currencyKey].entryPoint = 0;
871         inversePricing[currencyKey].upperLimit = 0;
872         inversePricing[currencyKey].lowerLimit = 0;
873         inversePricing[currencyKey].frozen = false;
874 
875         // now remove inverted key from array
876         for (uint8 i = 0; i < invertedKeys.length; i++) {
877             if (invertedKeys[i] == currencyKey) {
878                 delete invertedKeys[i];
879 
880                 // Copy the last key into the place of the one we just deleted
881                 // If there's only one key, this is array[0] = array[0].
882                 // If we're deleting the last one, it's also a NOOP in the same way.
883                 invertedKeys[i] = invertedKeys[invertedKeys.length - 1];
884 
885                 // Decrease the size of the array by one.
886                 invertedKeys.length--;
887 
888                 break;
889             }
890         }
891 
892         emit InversePriceConfigured(currencyKey, 0, 0, 0);
893     }
894     /* ========== VIEWS ========== */
895 
896     /**
897      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
898      * @param sourceCurrencyKey The currency the amount is specified in
899      * @param sourceAmount The source amount, specified in UNIT base
900      * @param destinationCurrencyKey The destination currency
901      */
902     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
903         public
904         view
905         rateNotStale(sourceCurrencyKey)
906         rateNotStale(destinationCurrencyKey)
907         returns (uint)
908     {
909         // If there's no change in the currency, then just return the amount they gave us
910         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
911 
912         // Calculate the effective value by going from source -> USD -> destination
913         return sourceAmount.multiplyDecimalRound(rateForCurrency(sourceCurrencyKey))
914             .divideDecimalRound(rateForCurrency(destinationCurrencyKey));
915     }
916 
917     /**
918      * @notice Retrieve the rate for a specific currency
919      */
920     function rateForCurrency(bytes32 currencyKey)
921         public
922         view
923         returns (uint)
924     {
925         return rates[currencyKey];
926     }
927 
928     /**
929      * @notice Retrieve the rates for a list of currencies
930      */
931     function ratesForCurrencies(bytes32[] currencyKeys)
932         public
933         view
934         returns (uint[])
935     {
936         uint[] memory _rates = new uint[](currencyKeys.length);
937 
938         for (uint8 i = 0; i < currencyKeys.length; i++) {
939             _rates[i] = rates[currencyKeys[i]];
940         }
941 
942         return _rates;
943     }
944 
945     /**
946      * @notice Retrieve a list of last update times for specific currencies
947      */
948     function lastRateUpdateTimeForCurrency(bytes32 currencyKey)
949         public
950         view
951         returns (uint)
952     {
953         return lastRateUpdateTimes[currencyKey];
954     }
955 
956     /**
957      * @notice Retrieve the last update time for a specific currency
958      */
959     function lastRateUpdateTimesForCurrencies(bytes32[] currencyKeys)
960         public
961         view
962         returns (uint[])
963     {
964         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
965 
966         for (uint8 i = 0; i < currencyKeys.length; i++) {
967             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
968         }
969 
970         return lastUpdateTimes;
971     }
972 
973     /**
974      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
975      */
976     function rateIsStale(bytes32 currencyKey)
977         public
978         view
979         returns (bool)
980     {
981         // sUSD is a special case and is never stale.
982         if (currencyKey == "sUSD") return false;
983 
984         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
985     }
986 
987     /**
988      * @notice Check if any rate is frozen (cannot be exchanged into)
989      */
990     function rateIsFrozen(bytes32 currencyKey)
991         external
992         view
993         returns (bool)
994     {
995         return inversePricing[currencyKey].frozen;
996     }
997 
998 
999     /**
1000      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
1001      */
1002     function anyRateIsStale(bytes32[] currencyKeys)
1003         external
1004         view
1005         returns (bool)
1006     {
1007         // Loop through each key and check whether the data point is stale.
1008         uint256 i = 0;
1009 
1010         while (i < currencyKeys.length) {
1011             // sUSD is a special case and is never false
1012             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
1013                 return true;
1014             }
1015             i += 1;
1016         }
1017 
1018         return false;
1019     }
1020 
1021     /* ========== MODIFIERS ========== */
1022 
1023     modifier rateNotStale(bytes32 currencyKey) {
1024         require(!rateIsStale(currencyKey), "Rate stale or nonexistant currency");
1025         _;
1026     }
1027 
1028     modifier onlyOracle
1029     {
1030         require(msg.sender == oracle, "Only the oracle can perform this action");
1031         _;
1032     }
1033 
1034     /* ========== EVENTS ========== */
1035 
1036     event OracleUpdated(address newOracle);
1037     event RateStalePeriodUpdated(uint rateStalePeriod);
1038     event RatesUpdated(bytes32[] currencyKeys, uint[] newRates);
1039     event RateDeleted(bytes32 currencyKey);
1040     event InversePriceConfigured(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
1041     event InversePriceFrozen(bytes32 currencyKey);
1042 }
1043 
