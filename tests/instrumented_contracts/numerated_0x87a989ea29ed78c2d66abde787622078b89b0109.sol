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
459         require(_owner != address(0), "Owner must not be the zero address");
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
473         require(_beneficiary != address(0), "Beneficiary must not be the zero address");
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
514         require(selfDestructInitiated, "Self destruct has not yet been initiated");
515         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay has not yet elapsed");
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
566     mapping(bytes4 => uint) public rates;
567 
568     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
569     mapping(bytes4 => uint) public lastRateUpdateTimes;
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
586     bytes4[5] public xdrParticipants;
587 
588     // For inverted prices, keep a mapping of their entry, limits and frozen status
589     struct InversePricing {
590         uint entryPoint;
591         uint upperLimit;
592         uint lowerLimit;
593         bool frozen;
594     }
595     mapping(bytes4 => InversePricing) public inversePricing;
596     bytes4[] public invertedKeys;
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
614         bytes4[] _currencyKeys,
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
637             bytes4("sUSD"),
638             bytes4("sAUD"),
639             bytes4("sCHF"),
640             bytes4("sEUR"),
641             bytes4("sGBP")
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
657     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
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
673     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
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
719     function rateOrInverted(bytes4 currencyKey, uint rate) internal returns (uint) {
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
777         bytes4[] memory eventCurrencyCode = new bytes4[](1);
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
790     function deleteRate(bytes4 currencyKey)
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
844     function setInversePricing(bytes4 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit)
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
869     function removeInversePricing(bytes4 currencyKey) external onlyOwner {
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
902     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
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
920     function rateForCurrency(bytes4 currencyKey)
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
931     function ratesForCurrencies(bytes4[] currencyKeys)
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
948     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
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
959     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
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
976     function rateIsStale(bytes4 currencyKey)
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
990     function rateIsFrozen(bytes4 currencyKey)
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
1002     function anyRateIsStale(bytes4[] currencyKeys)
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
1023     modifier rateNotStale(bytes4 currencyKey) {
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
1038     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
1039     event RateDeleted(bytes4 currencyKey);
1040     event InversePriceConfigured(bytes4 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
1041     event InversePriceFrozen(bytes4 currencyKey);
1042 }
1043 
1044 
1045 /*
1046 -----------------------------------------------------------------
1047 FILE INFORMATION
1048 -----------------------------------------------------------------
1049 
1050 file:       State.sol
1051 version:    1.1
1052 author:     Dominic Romanowski
1053             Anton Jurisevic
1054 
1055 date:       2018-05-15
1056 
1057 -----------------------------------------------------------------
1058 MODULE DESCRIPTION
1059 -----------------------------------------------------------------
1060 
1061 This contract is used side by side with external state token
1062 contracts, such as Synthetix and Synth.
1063 It provides an easy way to upgrade contract logic while
1064 maintaining all user balances and allowances. This is designed
1065 to make the changeover as easy as possible, since mappings
1066 are not so cheap or straightforward to migrate.
1067 
1068 The first deployed contract would create this state contract,
1069 using it as its store of balances.
1070 When a new contract is deployed, it links to the existing
1071 state contract, whose owner would then change its associated
1072 contract to the new one.
1073 
1074 -----------------------------------------------------------------
1075 */
1076 
1077 
1078 contract State is Owned {
1079     // the address of the contract that can modify variables
1080     // this can only be changed by the owner of this contract
1081     address public associatedContract;
1082 
1083 
1084     constructor(address _owner, address _associatedContract)
1085         Owned(_owner)
1086         public
1087     {
1088         associatedContract = _associatedContract;
1089         emit AssociatedContractUpdated(_associatedContract);
1090     }
1091 
1092     /* ========== SETTERS ========== */
1093 
1094     // Change the associated contract to a new address
1095     function setAssociatedContract(address _associatedContract)
1096         external
1097         onlyOwner
1098     {
1099         associatedContract = _associatedContract;
1100         emit AssociatedContractUpdated(_associatedContract);
1101     }
1102 
1103     /* ========== MODIFIERS ========== */
1104 
1105     modifier onlyAssociatedContract
1106     {
1107         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
1108         _;
1109     }
1110 
1111     /* ========== EVENTS ========== */
1112 
1113     event AssociatedContractUpdated(address associatedContract);
1114 }
1115 
1116 
1117 /*
1118 -----------------------------------------------------------------
1119 FILE INFORMATION
1120 -----------------------------------------------------------------
1121 
1122 file:       TokenState.sol
1123 version:    1.1
1124 author:     Dominic Romanowski
1125             Anton Jurisevic
1126 
1127 date:       2018-05-15
1128 
1129 -----------------------------------------------------------------
1130 MODULE DESCRIPTION
1131 -----------------------------------------------------------------
1132 
1133 A contract that holds the state of an ERC20 compliant token.
1134 
1135 This contract is used side by side with external state token
1136 contracts, such as Synthetix and Synth.
1137 It provides an easy way to upgrade contract logic while
1138 maintaining all user balances and allowances. This is designed
1139 to make the changeover as easy as possible, since mappings
1140 are not so cheap or straightforward to migrate.
1141 
1142 The first deployed contract would create this state contract,
1143 using it as its store of balances.
1144 When a new contract is deployed, it links to the existing
1145 state contract, whose owner would then change its associated
1146 contract to the new one.
1147 
1148 -----------------------------------------------------------------
1149 */
1150 
1151 
1152 /**
1153  * @title ERC20 Token State
1154  * @notice Stores balance information of an ERC20 token contract.
1155  */
1156 contract TokenState is State {
1157 
1158     /* ERC20 fields. */
1159     mapping(address => uint) public balanceOf;
1160     mapping(address => mapping(address => uint)) public allowance;
1161 
1162     /**
1163      * @dev Constructor
1164      * @param _owner The address which controls this contract.
1165      * @param _associatedContract The ERC20 contract whose state this composes.
1166      */
1167     constructor(address _owner, address _associatedContract)
1168         State(_owner, _associatedContract)
1169         public
1170     {}
1171 
1172     /* ========== SETTERS ========== */
1173 
1174     /**
1175      * @notice Set ERC20 allowance.
1176      * @dev Only the associated contract may call this.
1177      * @param tokenOwner The authorising party.
1178      * @param spender The authorised party.
1179      * @param value The total value the authorised party may spend on the
1180      * authorising party's behalf.
1181      */
1182     function setAllowance(address tokenOwner, address spender, uint value)
1183         external
1184         onlyAssociatedContract
1185     {
1186         allowance[tokenOwner][spender] = value;
1187     }
1188 
1189     /**
1190      * @notice Set the balance in a given account
1191      * @dev Only the associated contract may call this.
1192      * @param account The account whose value to set.
1193      * @param value The new balance of the given account.
1194      */
1195     function setBalanceOf(address account, uint value)
1196         external
1197         onlyAssociatedContract
1198     {
1199         balanceOf[account] = value;
1200     }
1201 }
1202 
1203 
1204 /*
1205 -----------------------------------------------------------------
1206 FILE INFORMATION
1207 -----------------------------------------------------------------
1208 
1209 file:       Proxy.sol
1210 version:    1.3
1211 author:     Anton Jurisevic
1212 
1213 date:       2018-05-29
1214 
1215 -----------------------------------------------------------------
1216 MODULE DESCRIPTION
1217 -----------------------------------------------------------------
1218 
1219 A proxy contract that, if it does not recognise the function
1220 being called on it, passes all value and call data to an
1221 underlying target contract.
1222 
1223 This proxy has the capacity to toggle between DELEGATECALL
1224 and CALL style proxy functionality.
1225 
1226 The former executes in the proxy's context, and so will preserve 
1227 msg.sender and store data at the proxy address. The latter will not.
1228 Therefore, any contract the proxy wraps in the CALL style must
1229 implement the Proxyable interface, in order that it can pass msg.sender
1230 into the underlying contract as the state parameter, messageSender.
1231 
1232 -----------------------------------------------------------------
1233 */
1234 
1235 
1236 contract Proxy is Owned {
1237 
1238     Proxyable public target;
1239     bool public useDELEGATECALL;
1240 
1241     constructor(address _owner)
1242         Owned(_owner)
1243         public
1244     {}
1245 
1246     function setTarget(Proxyable _target)
1247         external
1248         onlyOwner
1249     {
1250         target = _target;
1251         emit TargetUpdated(_target);
1252     }
1253 
1254     function setUseDELEGATECALL(bool value) 
1255         external
1256         onlyOwner
1257     {
1258         useDELEGATECALL = value;
1259     }
1260 
1261     function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)
1262         external
1263         onlyTarget
1264     {
1265         uint size = callData.length;
1266         bytes memory _callData = callData;
1267 
1268         assembly {
1269             /* The first 32 bytes of callData contain its length (as specified by the abi). 
1270              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
1271              * in length. It is also leftpadded to be a multiple of 32 bytes.
1272              * This means moving call_data across 32 bytes guarantees we correctly access
1273              * the data itself. */
1274             switch numTopics
1275             case 0 {
1276                 log0(add(_callData, 32), size)
1277             } 
1278             case 1 {
1279                 log1(add(_callData, 32), size, topic1)
1280             }
1281             case 2 {
1282                 log2(add(_callData, 32), size, topic1, topic2)
1283             }
1284             case 3 {
1285                 log3(add(_callData, 32), size, topic1, topic2, topic3)
1286             }
1287             case 4 {
1288                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
1289             }
1290         }
1291     }
1292 
1293     function()
1294         external
1295         payable
1296     {
1297         if (useDELEGATECALL) {
1298             assembly {
1299                 /* Copy call data into free memory region. */
1300                 let free_ptr := mload(0x40)
1301                 calldatacopy(free_ptr, 0, calldatasize)
1302 
1303                 /* Forward all gas and call data to the target contract. */
1304                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
1305                 returndatacopy(free_ptr, 0, returndatasize)
1306 
1307                 /* Revert if the call failed, otherwise return the result. */
1308                 if iszero(result) { revert(free_ptr, returndatasize) }
1309                 return(free_ptr, returndatasize)
1310             }
1311         } else {
1312             /* Here we are as above, but must send the messageSender explicitly 
1313              * since we are using CALL rather than DELEGATECALL. */
1314             target.setMessageSender(msg.sender);
1315             assembly {
1316                 let free_ptr := mload(0x40)
1317                 calldatacopy(free_ptr, 0, calldatasize)
1318 
1319                 /* We must explicitly forward ether to the underlying contract as well. */
1320                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
1321                 returndatacopy(free_ptr, 0, returndatasize)
1322 
1323                 if iszero(result) { revert(free_ptr, returndatasize) }
1324                 return(free_ptr, returndatasize)
1325             }
1326         }
1327     }
1328 
1329     modifier onlyTarget {
1330         require(Proxyable(msg.sender) == target, "Must be proxy target");
1331         _;
1332     }
1333 
1334     event TargetUpdated(Proxyable newTarget);
1335 }
1336 
1337 
1338 /*
1339 -----------------------------------------------------------------
1340 FILE INFORMATION
1341 -----------------------------------------------------------------
1342 
1343 file:       Proxyable.sol
1344 version:    1.1
1345 author:     Anton Jurisevic
1346 
1347 date:       2018-05-15
1348 
1349 checked:    Mike Spain
1350 approved:   Samuel Brooks
1351 
1352 -----------------------------------------------------------------
1353 MODULE DESCRIPTION
1354 -----------------------------------------------------------------
1355 
1356 A proxyable contract that works hand in hand with the Proxy contract
1357 to allow for anyone to interact with the underlying contract both
1358 directly and through the proxy.
1359 
1360 -----------------------------------------------------------------
1361 */
1362 
1363 
1364 // This contract should be treated like an abstract contract
1365 contract Proxyable is Owned {
1366     /* The proxy this contract exists behind. */
1367     Proxy public proxy;
1368 
1369     /* The caller of the proxy, passed through to this contract.
1370      * Note that every function using this member must apply the onlyProxy or
1371      * optionalProxy modifiers, otherwise their invocations can use stale values. */ 
1372     address messageSender; 
1373 
1374     constructor(address _proxy, address _owner)
1375         Owned(_owner)
1376         public
1377     {
1378         proxy = Proxy(_proxy);
1379         emit ProxyUpdated(_proxy);
1380     }
1381 
1382     function setProxy(address _proxy)
1383         external
1384         onlyOwner
1385     {
1386         proxy = Proxy(_proxy);
1387         emit ProxyUpdated(_proxy);
1388     }
1389 
1390     function setMessageSender(address sender)
1391         external
1392         onlyProxy
1393     {
1394         messageSender = sender;
1395     }
1396 
1397     modifier onlyProxy {
1398         require(Proxy(msg.sender) == proxy, "Only the proxy can call this function");
1399         _;
1400     }
1401 
1402     modifier optionalProxy
1403     {
1404         if (Proxy(msg.sender) != proxy) {
1405             messageSender = msg.sender;
1406         }
1407         _;
1408     }
1409 
1410     modifier optionalProxy_onlyOwner
1411     {
1412         if (Proxy(msg.sender) != proxy) {
1413             messageSender = msg.sender;
1414         }
1415         require(messageSender == owner, "This action can only be performed by the owner");
1416         _;
1417     }
1418 
1419     event ProxyUpdated(address proxyAddress);
1420 }
1421 
1422 
1423 /*
1424 -----------------------------------------------------------------
1425 FILE INFORMATION
1426 -----------------------------------------------------------------
1427 
1428 file:       ExternStateToken.sol
1429 version:    1.0
1430 author:     Kevin Brown
1431 date:       2018-08-06
1432 
1433 -----------------------------------------------------------------
1434 MODULE DESCRIPTION
1435 -----------------------------------------------------------------
1436 
1437 This contract offers a modifer that can prevent reentrancy on
1438 particular actions. It will not work if you put it on multiple
1439 functions that can be called from each other. Specifically guard
1440 external entry points to the contract with the modifier only.
1441 
1442 -----------------------------------------------------------------
1443 */
1444 
1445 
1446 contract ReentrancyPreventer {
1447     /* ========== MODIFIERS ========== */
1448     bool isInFunctionBody = false;
1449 
1450     modifier preventReentrancy {
1451         require(!isInFunctionBody, "Reverted to prevent reentrancy");
1452         isInFunctionBody = true;
1453         _;
1454         isInFunctionBody = false;
1455     }
1456 }
1457 
1458 /*
1459 -----------------------------------------------------------------
1460 FILE INFORMATION
1461 -----------------------------------------------------------------
1462 
1463 file:       TokenFallback.sol
1464 version:    1.0
1465 author:     Kevin Brown
1466 date:       2018-08-10
1467 
1468 -----------------------------------------------------------------
1469 MODULE DESCRIPTION
1470 -----------------------------------------------------------------
1471 
1472 This contract provides the logic that's used to call tokenFallback()
1473 when transfers happen.
1474 
1475 It's pulled out into its own module because it's needed in two
1476 places, so instead of copy/pasting this logic and maininting it
1477 both in Fee Token and Extern State Token, it's here and depended
1478 on by both contracts.
1479 
1480 -----------------------------------------------------------------
1481 */
1482 
1483 
1484 contract TokenFallbackCaller is ReentrancyPreventer {
1485     function callTokenFallbackIfNeeded(address sender, address recipient, uint amount, bytes data)
1486         internal
1487         preventReentrancy
1488     {
1489         /*
1490             If we're transferring to a contract and it implements the tokenFallback function, call it.
1491             This isn't ERC223 compliant because we don't revert if the contract doesn't implement tokenFallback.
1492             This is because many DEXes and other contracts that expect to work with the standard
1493             approve / transferFrom workflow don't implement tokenFallback but can still process our tokens as
1494             usual, so it feels very harsh and likely to cause trouble if we add this restriction after having
1495             previously gone live with a vanilla ERC20.
1496         */
1497 
1498         // Is the to address a contract? We can check the code size on that address and know.
1499         uint length;
1500 
1501         // solium-disable-next-line security/no-inline-assembly
1502         assembly {
1503             // Retrieve the size of the code on the recipient address
1504             length := extcodesize(recipient)
1505         }
1506 
1507         // If there's code there, it's a contract
1508         if (length > 0) {
1509             // Now we need to optionally call tokenFallback(address from, uint value).
1510             // We can't call it the normal way because that reverts when the recipient doesn't implement the function.
1511 
1512             // solium-disable-next-line security/no-low-level-calls
1513             recipient.call(abi.encodeWithSignature("tokenFallback(address,uint256,bytes)", sender, amount, data));
1514 
1515             // And yes, we specifically don't care if this call fails, so we're not checking the return value.
1516         }
1517     }
1518 }
1519 
1520 
1521 /*
1522 -----------------------------------------------------------------
1523 FILE INFORMATION
1524 -----------------------------------------------------------------
1525 
1526 file:       ExternStateToken.sol
1527 version:    1.3
1528 author:     Anton Jurisevic
1529             Dominic Romanowski
1530             Kevin Brown
1531 
1532 date:       2018-05-29
1533 
1534 -----------------------------------------------------------------
1535 MODULE DESCRIPTION
1536 -----------------------------------------------------------------
1537 
1538 A partial ERC20 token contract, designed to operate with a proxy.
1539 To produce a complete ERC20 token, transfer and transferFrom
1540 tokens must be implemented, using the provided _byProxy internal
1541 functions.
1542 This contract utilises an external state for upgradeability.
1543 
1544 -----------------------------------------------------------------
1545 */
1546 
1547 
1548 /**
1549  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
1550  */
1551 contract ExternStateToken is SelfDestructible, Proxyable, TokenFallbackCaller {
1552 
1553     using SafeMath for uint;
1554     using SafeDecimalMath for uint;
1555 
1556     /* ========== STATE VARIABLES ========== */
1557 
1558     /* Stores balances and allowances. */
1559     TokenState public tokenState;
1560 
1561     /* Other ERC20 fields. */
1562     string public name;
1563     string public symbol;
1564     uint public totalSupply;
1565     uint8 public decimals;
1566 
1567     /**
1568      * @dev Constructor.
1569      * @param _proxy The proxy associated with this contract.
1570      * @param _name Token's ERC20 name.
1571      * @param _symbol Token's ERC20 symbol.
1572      * @param _totalSupply The total supply of the token.
1573      * @param _tokenState The TokenState contract address.
1574      * @param _owner The owner of this contract.
1575      */
1576     constructor(address _proxy, TokenState _tokenState,
1577                 string _name, string _symbol, uint _totalSupply,
1578                 uint8 _decimals, address _owner)
1579         SelfDestructible(_owner)
1580         Proxyable(_proxy, _owner)
1581         public
1582     {
1583         tokenState = _tokenState;
1584 
1585         name = _name;
1586         symbol = _symbol;
1587         totalSupply = _totalSupply;
1588         decimals = _decimals;
1589     }
1590 
1591     /* ========== VIEWS ========== */
1592 
1593     /**
1594      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
1595      * @param owner The party authorising spending of their funds.
1596      * @param spender The party spending tokenOwner's funds.
1597      */
1598     function allowance(address owner, address spender)
1599         public
1600         view
1601         returns (uint)
1602     {
1603         return tokenState.allowance(owner, spender);
1604     }
1605 
1606     /**
1607      * @notice Returns the ERC20 token balance of a given account.
1608      */
1609     function balanceOf(address account)
1610         public
1611         view
1612         returns (uint)
1613     {
1614         return tokenState.balanceOf(account);
1615     }
1616 
1617     /* ========== MUTATIVE FUNCTIONS ========== */
1618 
1619     /**
1620      * @notice Set the address of the TokenState contract.
1621      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
1622      * as balances would be unreachable.
1623      */ 
1624     function setTokenState(TokenState _tokenState)
1625         external
1626         optionalProxy_onlyOwner
1627     {
1628         tokenState = _tokenState;
1629         emitTokenStateUpdated(_tokenState);
1630     }
1631 
1632     function _internalTransfer(address from, address to, uint value, bytes data) 
1633         internal
1634         returns (bool)
1635     { 
1636         /* Disallow transfers to irretrievable-addresses. */
1637         require(to != address(0), "Cannot transfer to the 0 address");
1638         require(to != address(this), "Cannot transfer to the underlying contract");
1639         require(to != address(proxy), "Cannot transfer to the proxy contract");
1640 
1641         // Insufficient balance will be handled by the safe subtraction.
1642         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
1643         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
1644 
1645         // If the recipient is a contract, we need to call tokenFallback on it so they can do ERC223
1646         // actions when receiving our tokens. Unlike the standard, however, we don't revert if the
1647         // recipient contract doesn't implement tokenFallback.
1648         callTokenFallbackIfNeeded(from, to, value, data);
1649         
1650         // Emit a standard ERC20 transfer event
1651         emitTransfer(from, to, value);
1652 
1653         return true;
1654     }
1655 
1656     /**
1657      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
1658      * the onlyProxy or optionalProxy modifiers.
1659      */
1660     function _transfer_byProxy(address from, address to, uint value, bytes data)
1661         internal
1662         returns (bool)
1663     {
1664         return _internalTransfer(from, to, value, data);
1665     }
1666 
1667     /**
1668      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
1669      * possessing the optionalProxy or optionalProxy modifiers.
1670      */
1671     function _transferFrom_byProxy(address sender, address from, address to, uint value, bytes data)
1672         internal
1673         returns (bool)
1674     {
1675         /* Insufficient allowance will be handled by the safe subtraction. */
1676         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
1677         return _internalTransfer(from, to, value, data);
1678     }
1679 
1680     /**
1681      * @notice Approves spender to transfer on the message sender's behalf.
1682      */
1683     function approve(address spender, uint value)
1684         public
1685         optionalProxy
1686         returns (bool)
1687     {
1688         address sender = messageSender;
1689 
1690         tokenState.setAllowance(sender, spender, value);
1691         emitApproval(sender, spender, value);
1692         return true;
1693     }
1694 
1695     /* ========== EVENTS ========== */
1696 
1697     event Transfer(address indexed from, address indexed to, uint value);
1698     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
1699     function emitTransfer(address from, address to, uint value) internal {
1700         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
1701     }
1702 
1703     event Approval(address indexed owner, address indexed spender, uint value);
1704     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
1705     function emitApproval(address owner, address spender, uint value) internal {
1706         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
1707     }
1708 
1709     event TokenStateUpdated(address newTokenState);
1710     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
1711     function emitTokenStateUpdated(address newTokenState) internal {
1712         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
1713     }
1714 }
1715 
1716 
1717 contract IFeePool {
1718     address public FEE_ADDRESS;
1719     function amountReceivedFromExchange(uint value) external view returns (uint);
1720     function amountReceivedFromTransfer(uint value) external view returns (uint);
1721     function feePaid(bytes4 currencyKey, uint amount) external;
1722     function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
1723     function rewardsMinted(uint amount) external;
1724     function transferFeeIncurred(uint value) public view returns (uint);
1725 }
1726 
1727 
1728 /*
1729 -----------------------------------------------------------------
1730 FILE INFORMATION
1731 -----------------------------------------------------------------
1732 
1733 file:       SupplySchedule.sol
1734 version:    1.0
1735 author:     Jackson Chan
1736             Clinton Ennis
1737 date:       2019-03-01
1738 
1739 -----------------------------------------------------------------
1740 MODULE DESCRIPTION
1741 -----------------------------------------------------------------
1742 
1743 Supply Schedule contract. SNX is a transferable ERC20 token.
1744 
1745 User's get staking rewards as part of the incentives of
1746 +------+-------------+--------------+----------+
1747 | Year |  Increase   | Total Supply | Increase |
1748 +------+-------------+--------------+----------+
1749 |    1 |           0 |  100,000,000 |          |
1750 |    2 |  75,000,000 |  175,000,000 | 75%      |
1751 |    3 |  37,500,000 |  212,500,000 | 21%      |
1752 |    4 |  18,750,000 |  231,250,000 | 9%       |
1753 |    5 |   9,375,000 |  240,625,000 | 4%       |
1754 |    6 |   4,687,500 |  245,312,500 | 2%       |
1755 +------+-------------+--------------+----------+
1756 
1757 
1758 -----------------------------------------------------------------
1759 */
1760 
1761 
1762 /**
1763  * @title SupplySchedule contract
1764  */
1765 contract SupplySchedule is Owned {
1766     using SafeMath for uint;
1767     using SafeDecimalMath for uint;
1768 
1769     /* Storage */
1770     struct ScheduleData {
1771         // Total supply issuable during period
1772         uint totalSupply;
1773 
1774         // UTC Time - Start of the schedule
1775         uint startPeriod;
1776 
1777         // UTC Time - End of the schedule
1778         uint endPeriod;
1779 
1780         // UTC Time - Total of supply minted
1781         uint totalSupplyMinted;
1782     }
1783 
1784     // How long each mint period is
1785     uint public mintPeriodDuration = 1 weeks;
1786 
1787     // time supply last minted
1788     uint public lastMintEvent;
1789 
1790     Synthetix public synthetix;
1791 
1792     uint constant SECONDS_IN_YEAR = 60 * 60 * 24 * 365;
1793 
1794     uint public constant START_DATE = 1520294400; // 2018-03-06T00:00:00+00:00
1795     uint public constant YEAR_ONE = START_DATE + SECONDS_IN_YEAR.mul(1);
1796     uint public constant YEAR_TWO = START_DATE + SECONDS_IN_YEAR.mul(2);
1797     uint public constant YEAR_THREE = START_DATE + SECONDS_IN_YEAR.mul(3);
1798     uint public constant YEAR_FOUR = START_DATE + SECONDS_IN_YEAR.mul(4);
1799     uint public constant YEAR_FIVE = START_DATE + SECONDS_IN_YEAR.mul(5);
1800     uint public constant YEAR_SIX = START_DATE + SECONDS_IN_YEAR.mul(6);
1801     uint public constant YEAR_SEVEN = START_DATE + SECONDS_IN_YEAR.mul(7);
1802 
1803     uint8 constant public INFLATION_SCHEDULES_LENGTH = 7;
1804     ScheduleData[INFLATION_SCHEDULES_LENGTH] public schedules;
1805 
1806     uint public minterReward = 200 * SafeDecimalMath.unit();
1807 
1808     constructor(address _owner)
1809         Owned(_owner)
1810         public
1811     {
1812         // ScheduleData(totalSupply, startPeriod, endPeriod, totalSupplyMinted)
1813         // Year 1 - Total supply 100,000,000
1814         schedules[0] = ScheduleData(1e8 * SafeDecimalMath.unit(), START_DATE, YEAR_ONE - 1, 1e8 * SafeDecimalMath.unit());
1815         schedules[1] = ScheduleData(75e6 * SafeDecimalMath.unit(), YEAR_ONE, YEAR_TWO - 1, 0); // Year 2 - Total supply 175,000,000
1816         schedules[2] = ScheduleData(37.5e6 * SafeDecimalMath.unit(), YEAR_TWO, YEAR_THREE - 1, 0); // Year 3 - Total supply 212,500,000
1817         schedules[3] = ScheduleData(18.75e6 * SafeDecimalMath.unit(), YEAR_THREE, YEAR_FOUR - 1, 0); // Year 4 - Total supply 231,250,000
1818         schedules[4] = ScheduleData(9.375e6 * SafeDecimalMath.unit(), YEAR_FOUR, YEAR_FIVE - 1, 0); // Year 5 - Total supply 240,625,000
1819         schedules[5] = ScheduleData(4.6875e6 * SafeDecimalMath.unit(), YEAR_FIVE, YEAR_SIX - 1, 0); // Year 6 - Total supply 245,312,500
1820         schedules[6] = ScheduleData(0, YEAR_SIX, YEAR_SEVEN - 1, 0); // Year 7 - Total supply 245,312,500
1821     }
1822 
1823     // ========== SETTERS ========== */
1824     function setSynthetix(Synthetix _synthetix)
1825         external
1826         onlyOwner
1827     {
1828         synthetix = _synthetix;
1829         // emit event
1830     }
1831 
1832     // ========== VIEWS ==========
1833     function mintableSupply()
1834         public
1835         view
1836         returns (uint)
1837     {
1838         if (!isMintable()) {
1839             return 0;
1840         }
1841 
1842         uint index = getCurrentSchedule();
1843 
1844         // Calculate previous year's mintable supply
1845         uint amountPreviousPeriod = _remainingSupplyFromPreviousYear(index);
1846 
1847         /* solium-disable */
1848 
1849         // Last mint event within current period will use difference in (now - lastMintEvent)
1850         // Last mint event not set (0) / outside of current Period will use current Period
1851         // start time resolved in (now - schedule.startPeriod)
1852         ScheduleData memory schedule = schedules[index];
1853 
1854         uint weeksInPeriod = (schedule.endPeriod - schedule.startPeriod).div(mintPeriodDuration);
1855 
1856         uint supplyPerWeek = schedule.totalSupply.divideDecimal(weeksInPeriod);
1857 
1858         uint weeksToMint = lastMintEvent >= schedule.startPeriod ? _numWeeksRoundedDown(now.sub(lastMintEvent)) : _numWeeksRoundedDown(now.sub(schedule.startPeriod));
1859         // /* solium-enable */
1860 
1861         uint amountInPeriod = supplyPerWeek.multiplyDecimal(weeksToMint);
1862         return amountInPeriod.add(amountPreviousPeriod);
1863     }
1864 
1865     function _numWeeksRoundedDown(uint _timeDiff)
1866         public
1867         view
1868         returns (uint)
1869     {
1870         // Take timeDiff in seconds (Dividend) and mintPeriodDuration as (Divisor)
1871         // Calculate the numberOfWeeks since last mint rounded down to 1 week
1872         // Fraction of a week will return 0
1873         return _timeDiff.div(mintPeriodDuration);
1874     }
1875 
1876     function isMintable()
1877         public
1878         view
1879         returns (bool)
1880     {
1881         bool mintable = false;
1882         if (now - lastMintEvent > mintPeriodDuration && now <= schedules[6].endPeriod) // Ensure time is not after end of Year 7
1883         {
1884             mintable = true;
1885         }
1886         return mintable;
1887     }
1888 
1889     // Return the current schedule based on the timestamp
1890     // applicable based on startPeriod and endPeriod
1891     function getCurrentSchedule()
1892         public
1893         view
1894         returns (uint)
1895     {
1896         require(now <= schedules[6].endPeriod, "Mintable periods have ended");
1897 
1898         for (uint i = 0; i < INFLATION_SCHEDULES_LENGTH; i++) {
1899             if (schedules[i].startPeriod <= now && schedules[i].endPeriod >= now) {
1900                 return i;
1901             }
1902         }
1903     }
1904 
1905     function _remainingSupplyFromPreviousYear(uint currentSchedule)
1906         internal
1907         view
1908         returns (uint)
1909     {
1910         // All supply has been minted for previous period if last minting event is after
1911         // the endPeriod for last year
1912         if (currentSchedule == 0 || lastMintEvent > schedules[currentSchedule - 1].endPeriod) {
1913             return 0;
1914         }
1915 
1916         // return the remaining supply to be minted for previous period missed
1917         uint amountInPeriod = schedules[currentSchedule - 1].totalSupply.sub(schedules[currentSchedule - 1].totalSupplyMinted);
1918 
1919         // Ensure previous period remaining amount is not less than 0
1920         if (amountInPeriod < 0) {
1921             return 0;
1922         }
1923 
1924         return amountInPeriod;
1925     }
1926 
1927     // ========== MUTATIVE FUNCTIONS ==========
1928     function updateMintValues()
1929         external
1930         onlySynthetix
1931         returns (bool)
1932     {
1933         // Will fail if the time is outside of schedules
1934         uint currentIndex = getCurrentSchedule();
1935         uint lastPeriodAmount = _remainingSupplyFromPreviousYear(currentIndex);
1936         uint currentPeriodAmount = mintableSupply().sub(lastPeriodAmount);
1937 
1938         // Update schedule[n - 1].totalSupplyMinted
1939         if (lastPeriodAmount > 0) {
1940             schedules[currentIndex - 1].totalSupplyMinted = schedules[currentIndex - 1].totalSupplyMinted.add(lastPeriodAmount);
1941         }
1942 
1943         // Update schedule.totalSupplyMinted for currentSchedule
1944         schedules[currentIndex].totalSupplyMinted = schedules[currentIndex].totalSupplyMinted.add(currentPeriodAmount);
1945         // Update mint event to now
1946         lastMintEvent = now;
1947 
1948         emit SupplyMinted(lastPeriodAmount, currentPeriodAmount, currentIndex, now);
1949         return true;
1950     }
1951 
1952     function setMinterReward(uint _amount)
1953         external
1954         onlyOwner
1955     {
1956         minterReward = _amount;
1957         emit MinterRewardUpdated(_amount);
1958     }
1959 
1960     // ========== MODIFIERS ==========
1961 
1962     modifier onlySynthetix() {
1963         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
1964         _;
1965     }
1966 
1967     /* ========== EVENTS ========== */
1968 
1969     event SupplyMinted(uint previousPeriodAmount, uint currentAmount, uint indexed schedule, uint timestamp);
1970     event MinterRewardUpdated(uint newRewardAmount);
1971 }
1972 
1973 
1974 /*
1975 -----------------------------------------------------------------
1976 FILE INFORMATION
1977 -----------------------------------------------------------------
1978 
1979 file:       LimitedSetup.sol
1980 version:    1.1
1981 author:     Anton Jurisevic
1982 
1983 date:       2018-05-15
1984 
1985 -----------------------------------------------------------------
1986 MODULE DESCRIPTION
1987 -----------------------------------------------------------------
1988 
1989 A contract with a limited setup period. Any function modified
1990 with the setup modifier will cease to work after the
1991 conclusion of the configurable-length post-construction setup period.
1992 
1993 -----------------------------------------------------------------
1994 */
1995 
1996 
1997 /**
1998  * @title Any function decorated with the modifier this contract provides
1999  * deactivates after a specified setup period.
2000  */
2001 contract LimitedSetup {
2002 
2003     uint setupExpiryTime;
2004 
2005     /**
2006      * @dev LimitedSetup Constructor.
2007      * @param setupDuration The time the setup period will last for.
2008      */
2009     constructor(uint setupDuration)
2010         public
2011     {
2012         setupExpiryTime = now + setupDuration;
2013     }
2014 
2015     modifier onlyDuringSetup
2016     {
2017         require(now < setupExpiryTime, "Can only perform this action during setup");
2018         _;
2019     }
2020 }
2021 
2022 
2023 /*
2024 -----------------------------------------------------------------
2025 FILE INFORMATION
2026 -----------------------------------------------------------------
2027 
2028 file:       SynthetixState.sol
2029 version:    1.0
2030 author:     Kevin Brown
2031 date:       2018-10-19
2032 
2033 -----------------------------------------------------------------
2034 MODULE DESCRIPTION
2035 -----------------------------------------------------------------
2036 
2037 A contract that holds issuance state and preferred currency of
2038 users in the Synthetix system.
2039 
2040 This contract is used side by side with the Synthetix contract
2041 to make it easier to upgrade the contract logic while maintaining
2042 issuance state.
2043 
2044 The Synthetix contract is also quite large and on the edge of
2045 being beyond the contract size limit without moving this information
2046 out to another contract.
2047 
2048 The first deployed contract would create this state contract,
2049 using it as its store of issuance data.
2050 
2051 When a new contract is deployed, it links to the existing
2052 state contract, whose owner would then change its associated
2053 contract to the new one.
2054 
2055 -----------------------------------------------------------------
2056 */
2057 
2058 
2059 /**
2060  * @title Synthetix State
2061  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
2062  */
2063 contract SynthetixState is State, LimitedSetup {
2064     using SafeMath for uint;
2065     using SafeDecimalMath for uint;
2066 
2067     // A struct for handing values associated with an individual user's debt position
2068     struct IssuanceData {
2069         // Percentage of the total debt owned at the time
2070         // of issuance. This number is modified by the global debt
2071         // delta array. You can figure out a user's exit price and
2072         // collateralisation ratio using a combination of their initial
2073         // debt and the slice of global debt delta which applies to them.
2074         uint initialDebtOwnership;
2075         // This lets us know when (in relative terms) the user entered
2076         // the debt pool so we can calculate their exit price and
2077         // collateralistion ratio
2078         uint debtEntryIndex;
2079     }
2080 
2081     // Issued synth balances for individual fee entitlements and exit price calculations
2082     mapping(address => IssuanceData) public issuanceData;
2083 
2084     // The total count of people that have outstanding issued synths in any flavour
2085     uint public totalIssuerCount;
2086 
2087     // Global debt pool tracking
2088     uint[] public debtLedger;
2089 
2090     // Import state
2091     uint public importedXDRAmount;
2092 
2093     // A quantity of synths greater than this ratio
2094     // may not be issued against a given value of SNX.
2095     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
2096     // No more synths may be issued than the value of SNX backing them.
2097     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
2098 
2099     // Users can specify their preferred currency, in which case all synths they receive
2100     // will automatically exchange to that preferred currency upon receipt in their wallet
2101     mapping(address => bytes4) public preferredCurrency;
2102 
2103     /**
2104      * @dev Constructor
2105      * @param _owner The address which controls this contract.
2106      * @param _associatedContract The ERC20 contract whose state this composes.
2107      */
2108     constructor(address _owner, address _associatedContract)
2109         State(_owner, _associatedContract)
2110         LimitedSetup(1 weeks)
2111         public
2112     {}
2113 
2114     /* ========== SETTERS ========== */
2115 
2116     /**
2117      * @notice Set issuance data for an address
2118      * @dev Only the associated contract may call this.
2119      * @param account The address to set the data for.
2120      * @param initialDebtOwnership The initial debt ownership for this address.
2121      */
2122     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
2123         external
2124         onlyAssociatedContract
2125     {
2126         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
2127         issuanceData[account].debtEntryIndex = debtLedger.length;
2128     }
2129 
2130     /**
2131      * @notice Clear issuance data for an address
2132      * @dev Only the associated contract may call this.
2133      * @param account The address to clear the data for.
2134      */
2135     function clearIssuanceData(address account)
2136         external
2137         onlyAssociatedContract
2138     {
2139         delete issuanceData[account];
2140     }
2141 
2142     /**
2143      * @notice Increment the total issuer count
2144      * @dev Only the associated contract may call this.
2145      */
2146     function incrementTotalIssuerCount()
2147         external
2148         onlyAssociatedContract
2149     {
2150         totalIssuerCount = totalIssuerCount.add(1);
2151     }
2152 
2153     /**
2154      * @notice Decrement the total issuer count
2155      * @dev Only the associated contract may call this.
2156      */
2157     function decrementTotalIssuerCount()
2158         external
2159         onlyAssociatedContract
2160     {
2161         totalIssuerCount = totalIssuerCount.sub(1);
2162     }
2163 
2164     /**
2165      * @notice Append a value to the debt ledger
2166      * @dev Only the associated contract may call this.
2167      * @param value The new value to be added to the debt ledger.
2168      */
2169     function appendDebtLedgerValue(uint value)
2170         external
2171         onlyAssociatedContract
2172     {
2173         debtLedger.push(value);
2174     }
2175 
2176     /**
2177      * @notice Set preferred currency for a user
2178      * @dev Only the associated contract may call this.
2179      * @param account The account to set the preferred currency for
2180      * @param currencyKey The new preferred currency
2181      */
2182     function setPreferredCurrency(address account, bytes4 currencyKey)
2183         external
2184         onlyAssociatedContract
2185     {
2186         preferredCurrency[account] = currencyKey;
2187     }
2188 
2189     /**
2190      * @notice Set the issuanceRatio for issuance calculations.
2191      * @dev Only callable by the contract owner.
2192      */
2193     function setIssuanceRatio(uint _issuanceRatio)
2194         external
2195         onlyOwner
2196     {
2197         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
2198         issuanceRatio = _issuanceRatio;
2199         emit IssuanceRatioUpdated(_issuanceRatio);
2200     }
2201 
2202     /**
2203      * @notice Import issuer data from the old Synthetix contract before multicurrency
2204      * @dev Only callable by the contract owner, and only for 1 week after deployment.
2205      */
2206     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
2207         external
2208         onlyOwner
2209         onlyDuringSetup
2210     {
2211         require(accounts.length == sUSDAmounts.length, "Length mismatch");
2212 
2213         for (uint8 i = 0; i < accounts.length; i++) {
2214             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
2215         }
2216     }
2217 
2218     /**
2219      * @notice Import issuer data from the old Synthetix contract before multicurrency
2220      * @dev Only used from importIssuerData above, meant to be disposable
2221      */
2222     function _addToDebtRegister(address account, uint amount)
2223         internal
2224     {
2225         // This code is duplicated from Synthetix so that we can call it directly here
2226         // during setup only.
2227         Synthetix synthetix = Synthetix(associatedContract);
2228 
2229         // What is the value of the requested debt in XDRs?
2230         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
2231 
2232         // What is the value that we've previously imported?
2233         uint totalDebtIssued = importedXDRAmount;
2234 
2235         // What will the new total be including the new value?
2236         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2237 
2238         // Save that for the next import.
2239         importedXDRAmount = newTotalDebtIssued;
2240 
2241         // What is their percentage (as a high precision int) of the total debt?
2242         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2243 
2244         // And what effect does this percentage have on the global debt holding of other issuers?
2245         // The delta specifically needs to not take into account any existing debt as it's already
2246         // accounted for in the delta from when they issued previously.
2247         // The delta is a high precision integer.
2248         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2249 
2250         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
2251 
2252         // And what does their debt ownership look like including this previous stake?
2253         if (existingDebt > 0) {
2254             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2255         }
2256 
2257         // Are they a new issuer? If so, record them.
2258         if (issuanceData[account].initialDebtOwnership == 0) {
2259             totalIssuerCount = totalIssuerCount.add(1);
2260         }
2261 
2262         // Save the debt entry parameters
2263         issuanceData[account].initialDebtOwnership = debtPercentage;
2264         issuanceData[account].debtEntryIndex = debtLedger.length;
2265 
2266         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2267         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2268         if (debtLedger.length > 0) {
2269             debtLedger.push(
2270                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2271             );
2272         } else {
2273             debtLedger.push(SafeDecimalMath.preciseUnit());
2274         }
2275     }
2276 
2277     /* ========== VIEWS ========== */
2278 
2279     /**
2280      * @notice Retrieve the length of the debt ledger array
2281      */
2282     function debtLedgerLength()
2283         external
2284         view
2285         returns (uint)
2286     {
2287         return debtLedger.length;
2288     }
2289 
2290     /**
2291      * @notice Retrieve the most recent entry from the debt ledger
2292      */
2293     function lastDebtLedgerEntry()
2294         external
2295         view
2296         returns (uint)
2297     {
2298         return debtLedger[debtLedger.length - 1];
2299     }
2300 
2301     /**
2302      * @notice Query whether an account has issued and has an outstanding debt balance
2303      * @param account The address to query for
2304      */
2305     function hasIssued(address account)
2306         external
2307         view
2308         returns (bool)
2309     {
2310         return issuanceData[account].initialDebtOwnership > 0;
2311     }
2312 
2313     event IssuanceRatioUpdated(uint newRatio);
2314 }
2315 
2316 
2317 /**
2318  * @title SynthetixEscrow interface
2319  */
2320 interface ISynthetixEscrow {
2321     function balanceOf(address account) public view returns (uint);
2322     function appendVestingEntry(address account, uint quantity) public;
2323 }
2324 
2325 
2326 /*
2327 -----------------------------------------------------------------
2328 FILE INFORMATION
2329 -----------------------------------------------------------------
2330 
2331 file:       Synthetix.sol
2332 version:    2.0
2333 author:     Kevin Brown
2334             Gavin Conway
2335 date:       2018-09-14
2336 
2337 -----------------------------------------------------------------
2338 MODULE DESCRIPTION
2339 -----------------------------------------------------------------
2340 
2341 Synthetix token contract. SNX is a transferable ERC20 token,
2342 and also give its holders the following privileges.
2343 An owner of SNX has the right to issue synths in all synth flavours.
2344 
2345 After a fee period terminates, the duration and fees collected for that
2346 period are computed, and the next period begins. Thus an account may only
2347 withdraw the fees owed to them for the previous period, and may only do
2348 so once per period. Any unclaimed fees roll over into the common pot for
2349 the next period.
2350 
2351 == Average Balance Calculations ==
2352 
2353 The fee entitlement of a synthetix holder is proportional to their average
2354 issued synth balance over the last fee period. This is computed by
2355 measuring the area under the graph of a user's issued synth balance over
2356 time, and then when a new fee period begins, dividing through by the
2357 duration of the fee period.
2358 
2359 We need only update values when the balances of an account is modified.
2360 This occurs when issuing or burning for issued synth balances,
2361 and when transferring for synthetix balances. This is for efficiency,
2362 and adds an implicit friction to interacting with SNX.
2363 A synthetix holder pays for his own recomputation whenever he wants to change
2364 his position, which saves the foundation having to maintain a pot dedicated
2365 to resourcing this.
2366 
2367 A hypothetical user's balance history over one fee period, pictorially:
2368 
2369       s ____
2370        |    |
2371        |    |___ p
2372        |____|___|___ __ _  _
2373        f    t   n
2374 
2375 Here, the balance was s between times f and t, at which time a transfer
2376 occurred, updating the balance to p, until n, when the present transfer occurs.
2377 When a new transfer occurs at time n, the balance being p,
2378 we must:
2379 
2380   - Add the area p * (n - t) to the total area recorded so far
2381   - Update the last transfer time to n
2382 
2383 So if this graph represents the entire current fee period,
2384 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
2385 The complementary computations must be performed for both sender and
2386 recipient.
2387 
2388 Note that a transfer keeps global supply of SNX invariant.
2389 The sum of all balances is constant, and unmodified by any transfer.
2390 So the sum of all balances multiplied by the duration of a fee period is also
2391 constant, and this is equivalent to the sum of the area of every user's
2392 time/balance graph. Dividing through by that duration yields back the total
2393 synthetix supply. So, at the end of a fee period, we really do yield a user's
2394 average share in the synthetix supply over that period.
2395 
2396 A slight wrinkle is introduced if we consider the time r when the fee period
2397 rolls over. Then the previous fee period k-1 is before r, and the current fee
2398 period k is afterwards. If the last transfer took place before r,
2399 but the latest transfer occurred afterwards:
2400 
2401 k-1       |        k
2402       s __|_
2403        |  | |
2404        |  | |____ p
2405        |__|_|____|___ __ _  _
2406           |
2407        f  | t    n
2408           r
2409 
2410 In this situation the area (r-f)*s contributes to fee period k-1, while
2411 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2412 zero-value transfer to have occurred at time r. Their fee entitlement for the
2413 previous period will be finalised at the time of their first transfer during the
2414 current fee period, or when they query or withdraw their fee entitlement.
2415 
2416 In the implementation, the duration of different fee periods may be slightly irregular,
2417 as the check that they have rolled over occurs only when state-changing synthetix
2418 operations are performed.
2419 
2420 == Issuance and Burning ==
2421 
2422 In this version of the synthetix contract, synths can only be issued by
2423 those that have been nominated by the synthetix foundation. Synths are assumed
2424 to be valued at $1, as they are a stable unit of account.
2425 
2426 All synths issued require a proportional value of SNX to be locked,
2427 where the proportion is governed by the current issuance ratio. This
2428 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
2429 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
2430 
2431 To determine the value of some amount of SNX(S), an oracle is used to push
2432 the price of SNX (P_S) in dollars to the contract. The value of S
2433 would then be: S * P_S.
2434 
2435 Any SNX that are locked up by this issuance process cannot be transferred.
2436 The amount that is locked floats based on the price of SNX. If the price
2437 of SNX moves up, less SNX are locked, so they can be issued against,
2438 or transferred freely. If the price of SNX moves down, more SNX are locked,
2439 even going above the initial wallet balance.
2440 
2441 -----------------------------------------------------------------
2442 */
2443 
2444 
2445 /**
2446  * @title Synthetix ERC20 contract.
2447  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2448  * but it also computes the quantity of fees each synthetix holder is entitled to.
2449  */
2450 contract Synthetix is ExternStateToken {
2451 
2452     // ========== STATE VARIABLES ==========
2453 
2454     // Available Synths which can be used with the system
2455     Synth[] public availableSynths;
2456     mapping(bytes4 => Synth) public synths;
2457 
2458     IFeePool public feePool;
2459     ISynthetixEscrow public escrow;
2460     ISynthetixEscrow public rewardEscrow;
2461     ExchangeRates public exchangeRates;
2462     SynthetixState public synthetixState;
2463     SupplySchedule public supplySchedule;
2464 
2465     bool private protectionCircuit = false;
2466 
2467     string constant TOKEN_NAME = "Synthetix Network Token";
2468     string constant TOKEN_SYMBOL = "SNX";
2469     uint8 constant DECIMALS = 18;
2470     bool public exchangeEnabled = true;
2471 
2472     // ========== CONSTRUCTOR ==========
2473 
2474     /**
2475      * @dev Constructor
2476      * @param _tokenState A pre-populated contract containing token balances.
2477      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2478      * @param _owner The owner of this contract.
2479      */
2480     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2481         address _owner, ExchangeRates _exchangeRates, IFeePool _feePool, SupplySchedule _supplySchedule,
2482         ISynthetixEscrow _rewardEscrow, ISynthetixEscrow _escrow, uint _totalSupply
2483     )
2484         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, _totalSupply, DECIMALS, _owner)
2485         public
2486     {
2487         synthetixState = _synthetixState;
2488         exchangeRates = _exchangeRates;
2489         feePool = _feePool;
2490         supplySchedule = _supplySchedule;
2491         rewardEscrow = _rewardEscrow;
2492         escrow = _escrow;
2493     }
2494     // ========== SETTERS ========== */
2495 
2496     function setFeePool(IFeePool _feePool)
2497         external
2498         optionalProxy_onlyOwner
2499     {
2500         feePool = _feePool;
2501     }
2502 
2503     function setExchangeRates(ExchangeRates _exchangeRates)
2504         external
2505         optionalProxy_onlyOwner
2506     {
2507         exchangeRates = _exchangeRates;
2508     }
2509 
2510     function setProtectionCircuit(bool _protectionCircuitIsActivated)
2511         external
2512         onlyOracle
2513     {
2514         protectionCircuit = _protectionCircuitIsActivated;
2515     }
2516 
2517     function setExchangeEnabled(bool _exchangeEnabled)
2518         external
2519         optionalProxy_onlyOwner
2520     {
2521         exchangeEnabled = _exchangeEnabled;
2522     }
2523 
2524     /**
2525      * @notice Add an associated Synth contract to the Synthetix system
2526      * @dev Only the contract owner may call this.
2527      */
2528     function addSynth(Synth synth)
2529         external
2530         optionalProxy_onlyOwner
2531     {
2532         bytes4 currencyKey = synth.currencyKey();
2533 
2534         require(synths[currencyKey] == Synth(0), "Synth already exists");
2535 
2536         availableSynths.push(synth);
2537         synths[currencyKey] = synth;
2538     }
2539 
2540     /**
2541      * @notice Remove an associated Synth contract from the Synthetix system
2542      * @dev Only the contract owner may call this.
2543      */
2544     function removeSynth(bytes4 currencyKey)
2545         external
2546         optionalProxy_onlyOwner
2547     {
2548         require(synths[currencyKey] != address(0), "Synth does not exist");
2549         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2550         require(currencyKey != "XDR", "Cannot remove XDR synth");
2551 
2552         // Save the address we're removing for emitting the event at the end.
2553         address synthToRemove = synths[currencyKey];
2554 
2555         // Remove the synth from the availableSynths array.
2556         for (uint8 i = 0; i < availableSynths.length; i++) {
2557             if (availableSynths[i] == synthToRemove) {
2558                 delete availableSynths[i];
2559 
2560                 // Copy the last synth into the place of the one we just deleted
2561                 // If there's only one synth, this is synths[0] = synths[0].
2562                 // If we're deleting the last one, it's also a NOOP in the same way.
2563                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2564 
2565                 // Decrease the size of the array by one.
2566                 availableSynths.length--;
2567 
2568                 break;
2569             }
2570         }
2571 
2572         // And remove it from the synths mapping
2573         delete synths[currencyKey];
2574 
2575         // Note: No event here as our contract exceeds max contract size
2576         // with these events, and it's unlikely people will need to
2577         // track these events specifically.
2578     }
2579 
2580     // ========== VIEWS ==========
2581 
2582     /**
2583      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2584      * @param sourceCurrencyKey The currency the amount is specified in
2585      * @param sourceAmount The source amount, specified in UNIT base
2586      * @param destinationCurrencyKey The destination currency
2587      */
2588     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
2589         public
2590         view
2591         returns (uint)
2592     {
2593         return exchangeRates.effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
2594     }
2595 
2596     /**
2597      * @notice Total amount of synths issued by the system, priced in currencyKey
2598      * @param currencyKey The currency to value the synths in
2599      */
2600     function totalIssuedSynths(bytes4 currencyKey)
2601         public
2602         view
2603         rateNotStale(currencyKey)
2604         returns (uint)
2605     {
2606         uint total = 0;
2607         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2608 
2609         require(!exchangeRates.anyRateIsStale(availableCurrencyKeys()), "Rates are stale");
2610 
2611         for (uint8 i = 0; i < availableSynths.length; i++) {
2612             // What's the total issued value of that synth in the destination currency?
2613             // Note: We're not using our effectiveValue function because we don't want to go get the
2614             //       rate for the destination currency and check if it's stale repeatedly on every
2615             //       iteration of the loop
2616             uint synthValue = availableSynths[i].totalSupply()
2617                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
2618                 .divideDecimalRound(currencyRate);
2619             total = total.add(synthValue);
2620         }
2621 
2622         return total;
2623     }
2624 
2625     /**
2626      * @notice Returns the currencyKeys of availableSynths for rate checking
2627      */
2628     function availableCurrencyKeys()
2629         public
2630         view
2631         returns (bytes4[])
2632     {
2633         bytes4[] memory availableCurrencyKeys = new bytes4[](availableSynths.length);
2634 
2635         for (uint8 i = 0; i < availableSynths.length; i++) {
2636             availableCurrencyKeys[i] = availableSynths[i].currencyKey();
2637         }
2638 
2639         return availableCurrencyKeys;
2640     }
2641 
2642     /**
2643      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
2644      */
2645     function availableSynthCount()
2646         public
2647         view
2648         returns (uint)
2649     {
2650         return availableSynths.length;
2651     }
2652 
2653     // ========== MUTATIVE FUNCTIONS ==========
2654 
2655     /**
2656      * @notice ERC20 transfer function.
2657      */
2658     function transfer(address to, uint value)
2659         public
2660         returns (bool)
2661     {
2662         bytes memory empty;
2663         return transfer(to, value, empty);
2664     }
2665 
2666     /**
2667      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
2668      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2669      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2670      *           tooling such as Etherscan.
2671      */
2672     function transfer(address to, uint value, bytes data)
2673         public
2674         optionalProxy
2675         returns (bool)
2676     {
2677         // Ensure they're not trying to exceed their locked amount
2678         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
2679 
2680         // Perform the transfer: if there is a problem an exception will be thrown in this call.
2681         _transfer_byProxy(messageSender, to, value, data);
2682 
2683         return true;
2684     }
2685 
2686     /**
2687      * @notice ERC20 transferFrom function.
2688      */
2689     function transferFrom(address from, address to, uint value)
2690         public
2691         returns (bool)
2692     {
2693         bytes memory empty;
2694         return transferFrom(from, to, value, empty);
2695     }
2696 
2697     /**
2698      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
2699      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2700      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2701      *           tooling such as Etherscan.
2702      */
2703     function transferFrom(address from, address to, uint value, bytes data)
2704         public
2705         optionalProxy
2706         returns (bool)
2707     {
2708         // Ensure they're not trying to exceed their locked amount
2709         require(value <= transferableSynthetix(from), "Insufficient balance");
2710 
2711         // Perform the transfer: if there is a problem,
2712         // an exception will be thrown in this call.
2713         _transferFrom_byProxy(messageSender, from, to, value, data);
2714 
2715         return true;
2716     }
2717 
2718     /**
2719      * @notice Function that allows you to exchange synths you hold in one flavour for another.
2720      * @param sourceCurrencyKey The source currency you wish to exchange from
2721      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2722      * @param destinationCurrencyKey The destination currency you wish to obtain.
2723      * @param destinationAddress Deprecated. Will always send to messageSender
2724      * @return Boolean that indicates whether the transfer succeeded or failed.
2725      */
2726     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
2727         external
2728         optionalProxy
2729         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
2730         returns (bool)
2731     {
2732         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
2733         require(sourceAmount > 0, "Zero amount");
2734 
2735         //  If protectionCircuit is true then we burn the synths through _internalLiquidation()
2736         if (protectionCircuit) {
2737             return _internalLiquidation(
2738                 messageSender,
2739                 sourceCurrencyKey,
2740                 sourceAmount
2741             );
2742         } else {
2743             // Pass it along, defaulting to the sender as the recipient.
2744             return _internalExchange(
2745                 messageSender,
2746                 sourceCurrencyKey,
2747                 sourceAmount,
2748                 destinationCurrencyKey,
2749                 messageSender,
2750                 true // Charge fee on the exchange
2751             );
2752         }
2753     }
2754 
2755     /**
2756      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
2757      * @dev Only the synth contract can call this function
2758      * @param from The address to exchange / burn synth from
2759      * @param sourceCurrencyKey The source currency you wish to exchange from
2760      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2761      * @param destinationCurrencyKey The destination currency you wish to obtain.
2762      * @param destinationAddress Where the result should go.
2763      * @return Boolean that indicates whether the transfer succeeded or failed.
2764      */
2765     function synthInitiatedExchange(
2766         address from,
2767         bytes4 sourceCurrencyKey,
2768         uint sourceAmount,
2769         bytes4 destinationCurrencyKey,
2770         address destinationAddress
2771     )
2772         external
2773         onlySynth
2774         returns (bool)
2775     {
2776         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
2777         require(sourceAmount > 0, "Zero amount");
2778 
2779         // Pass it along
2780         return _internalExchange(
2781             from,
2782             sourceCurrencyKey,
2783             sourceAmount,
2784             destinationCurrencyKey,
2785             destinationAddress,
2786             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
2787         );
2788     }
2789 
2790     /**
2791      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
2792      * @dev Only the synth contract can call this function.
2793      * @param from The address fee is coming from.
2794      * @param sourceCurrencyKey source currency fee from.
2795      * @param sourceAmount The amount, specified in UNIT of source currency.
2796      * @return Boolean that indicates whether the transfer succeeded or failed.
2797      */
2798     function synthInitiatedFeePayment(
2799         address from,
2800         bytes4 sourceCurrencyKey,
2801         uint sourceAmount
2802     )
2803         external
2804         onlySynth
2805         returns (bool)
2806     {
2807         // Allow fee to be 0 and skip minting XDRs to feePool
2808         if (sourceAmount == 0) {
2809             return true;
2810         }
2811 
2812         require(sourceAmount > 0, "Source can't be 0");
2813 
2814         // Pass it along, defaulting to the sender as the recipient.
2815         bool result = _internalExchange(
2816             from,
2817             sourceCurrencyKey,
2818             sourceAmount,
2819             "XDR",
2820             feePool.FEE_ADDRESS(),
2821             false // Don't charge a fee on the exchange because this is already a fee
2822         );
2823 
2824         // Tell the fee pool about this.
2825         feePool.feePaid(sourceCurrencyKey, sourceAmount);
2826 
2827         return result;
2828     }
2829 
2830     /**
2831      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
2832      * @dev fee pool contract address is not allowed to call function
2833      * @param from The address to move synth from
2834      * @param sourceCurrencyKey source currency from.
2835      * @param sourceAmount The amount, specified in UNIT of source currency.
2836      * @param destinationCurrencyKey The destination currency to obtain.
2837      * @param destinationAddress Where the result should go.
2838      * @param chargeFee Boolean to charge a fee for transaction.
2839      * @return Boolean that indicates whether the transfer succeeded or failed.
2840      */
2841     function _internalExchange(
2842         address from,
2843         bytes4 sourceCurrencyKey,
2844         uint sourceAmount,
2845         bytes4 destinationCurrencyKey,
2846         address destinationAddress,
2847         bool chargeFee
2848     )
2849         internal
2850         notFeeAddress(from)
2851         returns (bool)
2852     {
2853         require(exchangeEnabled, "Exchanging is disabled");
2854         require(!exchangeRates.priceUpdateLock(), "Price update lock");
2855         require(destinationAddress != address(0), "Zero destination");
2856         require(destinationAddress != address(this), "Synthetix is invalid destination");
2857         require(destinationAddress != address(proxy), "Proxy is invalid destination");
2858 
2859         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
2860         // the subtraction to not overflow, which would happen if their balance is not sufficient.
2861 
2862         // Burn the source amount
2863         synths[sourceCurrencyKey].burn(from, sourceAmount);
2864 
2865         // How much should they get in the destination currency?
2866         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
2867 
2868         // What's the fee on that currency that we should deduct?
2869         uint amountReceived = destinationAmount;
2870         uint fee = 0;
2871 
2872         if (chargeFee) {
2873             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
2874             fee = destinationAmount.sub(amountReceived);
2875         }
2876 
2877         // Issue their new synths
2878         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
2879 
2880         // Remit the fee in XDRs
2881         if (fee > 0) {
2882             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
2883             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
2884             // Tell the fee pool about this.
2885             feePool.feePaid("XDR", xdrFeeAmount);
2886         }
2887 
2888         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
2889 
2890         // Call the ERC223 transfer callback if needed
2891         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
2892 
2893         //Let the DApps know there was a Synth exchange
2894         emitSynthExchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, amountReceived, destinationAddress);
2895 
2896         return true;
2897     }
2898 
2899     /**
2900     * @notice Function that burns the amount sent during an exchange in case the protection circuit is activated
2901     * @param from The address to move synth from
2902     * @param sourceCurrencyKey source currency from.
2903     * @param sourceAmount The amount, specified in UNIT of source currency.
2904     * @return Boolean that indicates whether the transfer succeeded or failed.
2905     */
2906     function _internalLiquidation(
2907         address from,
2908         bytes4 sourceCurrencyKey,
2909         uint sourceAmount
2910     )
2911         internal
2912         returns (bool)
2913     {
2914         // Burn the source amount
2915         synths[sourceCurrencyKey].burn(from, sourceAmount);
2916         return true;
2917     }
2918 
2919     /**
2920      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
2921      * @dev Only internal calls from synthetix address.
2922      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
2923      * @param amount The amount of synths to register with a base of UNIT
2924      */
2925     function _addToDebtRegister(bytes4 currencyKey, uint amount)
2926         internal
2927         optionalProxy
2928     {
2929         // What is the value of the requested debt in XDRs?
2930         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
2931 
2932         // What is the value of all issued synths of the system (priced in XDRs)?
2933         uint totalDebtIssued = totalIssuedSynths("XDR");
2934 
2935         // What will the new total be including the new value?
2936         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2937 
2938         // What is their percentage (as a high precision int) of the total debt?
2939         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2940 
2941         // And what effect does this percentage change have on the global debt holding of other issuers?
2942         // The delta specifically needs to not take into account any existing debt as it's already
2943         // accounted for in the delta from when they issued previously.
2944         // The delta is a high precision integer.
2945         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2946 
2947         // How much existing debt do they have?
2948         uint existingDebt = debtBalanceOf(messageSender, "XDR");
2949 
2950         // And what does their debt ownership look like including this previous stake?
2951         if (existingDebt > 0) {
2952             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2953         }
2954 
2955         // Are they a new issuer? If so, record them.
2956         if (!synthetixState.hasIssued(messageSender)) {
2957             synthetixState.incrementTotalIssuerCount();
2958         }
2959 
2960         // Save the debt entry parameters
2961         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
2962 
2963         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2964         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2965         if (synthetixState.debtLedgerLength() > 0) {
2966             synthetixState.appendDebtLedgerValue(
2967                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
2968             );
2969         } else {
2970             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
2971         }
2972     }
2973 
2974     /**
2975      * @notice Issue synths against the sender's SNX.
2976      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
2977      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
2978      * @param amount The amount of synths you wish to issue with a base of UNIT
2979      */
2980     function issueSynths(bytes4 currencyKey, uint amount)
2981         public
2982         optionalProxy
2983         // No need to check if price is stale, as it is checked in issuableSynths.
2984     {
2985         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
2986 
2987         // Keep track of the debt they're about to create
2988         _addToDebtRegister(currencyKey, amount);
2989 
2990         // Create their synths
2991         synths[currencyKey].issue(messageSender, amount);
2992 
2993         // Store their locked SNX amount to determine their fee % for the period
2994         _appendAccountIssuanceRecord();
2995     }
2996 
2997     /**
2998      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
2999      * @dev Issuance is only allowed if the synthetix price isn't stale.
3000      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3001      */
3002     function issueMaxSynths(bytes4 currencyKey)
3003         external
3004         optionalProxy
3005     {
3006         // Figure out the maximum we can issue in that currency
3007         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3008 
3009         // And issue them
3010         issueSynths(currencyKey, maxIssuable);
3011     }
3012 
3013     /**
3014      * @notice Burn synths to clear issued synths/free SNX.
3015      * @param currencyKey The currency you're specifying to burn
3016      * @param amount The amount (in UNIT base) you wish to burn
3017      * @dev The amount to burn is debased to XDR's
3018      */
3019     function burnSynths(bytes4 currencyKey, uint amount)
3020         external
3021         optionalProxy
3022         // No need to check for stale rates as effectiveValue checks rates
3023     {
3024         // How much debt do they have?
3025         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3026         uint debt = debtBalanceOf(messageSender, "XDR");
3027         uint debtInCurrencyKey = debtBalanceOf(messageSender, currencyKey);
3028 
3029         require(debt > 0, "No debt to forgive");
3030 
3031         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3032         // clear their debt and leave them be.
3033         uint amountToRemove = debt < debtToRemove ? debt : debtToRemove;
3034 
3035         // Remove their debt from the ledger
3036         _removeFromDebtRegister(amountToRemove);
3037 
3038         uint amountToBurn = debtInCurrencyKey < amount ? debtInCurrencyKey : amount;
3039 
3040         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3041         synths[currencyKey].burn(messageSender, amountToBurn);
3042 
3043         // Store their debtRatio against a feeperiod to determine their fee/rewards % for the period
3044         _appendAccountIssuanceRecord();
3045     }
3046 
3047     /**
3048      * @notice Store in the FeePool the users current debt value in the system in XDRs.
3049      * @dev debtBalanceOf(messageSender, "XDR") to be used with totalIssuedSynths("XDR") to get
3050      *  users % of the system within a feePeriod.
3051      */
3052     function _appendAccountIssuanceRecord()
3053         internal
3054     {
3055         uint initialDebtOwnership;
3056         uint debtEntryIndex;
3057         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(messageSender);
3058 
3059         feePool.appendAccountIssuanceRecord(
3060             messageSender,
3061             initialDebtOwnership,
3062             debtEntryIndex
3063         );
3064     }
3065 
3066     /**
3067      * @notice Remove a debt position from the register
3068      * @param amount The amount (in UNIT base) being presented in XDRs
3069      */
3070     function _removeFromDebtRegister(uint amount)
3071         internal
3072     {
3073         uint debtToRemove = amount;
3074 
3075         // How much debt do they have?
3076         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3077 
3078         // What is the value of all issued synths of the system (priced in XDRs)?
3079         uint totalDebtIssued = totalIssuedSynths("XDR");
3080 
3081         // What will the new total after taking out the withdrawn amount
3082         uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3083 
3084         uint delta;
3085 
3086         // What will the debt delta be if there is any debt left?
3087         // Set delta to 0 if no more debt left in system after user
3088         if (newTotalDebtIssued > 0) {
3089 
3090             // What is the percentage of the withdrawn debt (as a high precision int) of the total debt after?
3091             uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(newTotalDebtIssued);
3092 
3093             // And what effect does this percentage change have on the global debt holding of other issuers?
3094             // The delta specifically needs to not take into account any existing debt as it's already
3095             // accounted for in the delta from when they issued previously.
3096             delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3097         } else {
3098             delta = 0;
3099         }
3100 
3101         // Are they exiting the system, or are they just decreasing their debt position?
3102         if (debtToRemove == existingDebt) {
3103             synthetixState.setCurrentIssuanceData(messageSender, 0);
3104             synthetixState.decrementTotalIssuerCount();
3105         } else {
3106             // What percentage of the debt will they be left with?
3107             uint newDebt = existingDebt.sub(debtToRemove);
3108             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3109 
3110             // Store the debt percentage and debt ledger as high precision integers
3111             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3112         }
3113 
3114         // Update our cumulative ledger. This is also a high precision integer.
3115         synthetixState.appendDebtLedgerValue(
3116             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3117         );
3118     }
3119 
3120     // ========== Issuance/Burning ==========
3121 
3122     /**
3123      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3124      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3125      */
3126     function maxIssuableSynths(address issuer, bytes4 currencyKey)
3127         public
3128         view
3129         // We don't need to check stale rates here as effectiveValue will do it for us.
3130         returns (uint)
3131     {
3132         // What is the value of their SNX balance in the destination currency?
3133         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3134 
3135         // They're allowed to issue up to issuanceRatio of that value
3136         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3137     }
3138 
3139     /**
3140      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3141      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
3142      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3143      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
3144      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3145      * altering the amount of fees they're able to claim from the system.
3146      */
3147     function collateralisationRatio(address issuer)
3148         public
3149         view
3150         returns (uint)
3151     {
3152         uint totalOwnedSynthetix = collateral(issuer);
3153         if (totalOwnedSynthetix == 0) return 0;
3154 
3155         uint debtBalance = debtBalanceOf(issuer, "SNX");
3156         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3157     }
3158 
3159     /**
3160      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3161      * will tell you how many synths a user has to give back to the system in order to unlock their original
3162      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3163      * the debt in sUSD, XDR, or any other synth you wish.
3164      */
3165     function debtBalanceOf(address issuer, bytes4 currencyKey)
3166         public
3167         view
3168         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3169         returns (uint)
3170     {
3171         // What was their initial debt ownership?
3172         uint initialDebtOwnership;
3173         uint debtEntryIndex;
3174         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3175 
3176         // If it's zero, they haven't issued, and they have no debt.
3177         if (initialDebtOwnership == 0) return 0;
3178 
3179         // Figure out the global debt percentage delta from when they entered the system.
3180         // This is a high precision integer.
3181         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3182             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3183             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3184 
3185         // What's the total value of the system in their requested currency?
3186         uint totalSystemValue = totalIssuedSynths(currencyKey);
3187 
3188         // Their debt balance is their portion of the total system value.
3189         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3190             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3191 
3192         return highPrecisionBalance.preciseDecimalToDecimal();
3193     }
3194 
3195     /**
3196      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3197      * @param issuer The account that intends to issue
3198      * @param currencyKey The currency to price issuable value in
3199      */
3200     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
3201         public
3202         view
3203         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3204         returns (uint)
3205     {
3206         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3207         uint max = maxIssuableSynths(issuer, currencyKey);
3208 
3209         if (alreadyIssued >= max) {
3210             return 0;
3211         } else {
3212             return max.sub(alreadyIssued);
3213         }
3214     }
3215 
3216     /**
3217      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3218      * against which synths can be issued.
3219      * This includes those already being used as collateral (locked), and those
3220      * available for further issuance (unlocked).
3221      */
3222     function collateral(address account)
3223         public
3224         view
3225         returns (uint)
3226     {
3227         uint balance = tokenState.balanceOf(account);
3228 
3229         if (escrow != address(0)) {
3230             balance = balance.add(escrow.balanceOf(account));
3231         }
3232 
3233         if (rewardEscrow != address(0)) {
3234             balance = balance.add(rewardEscrow.balanceOf(account));
3235         }
3236 
3237         return balance;
3238     }
3239 
3240     /**
3241      * @notice The number of SNX that are free to be transferred by an account.
3242      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
3243      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
3244      * in this calculation.
3245      */
3246     function transferableSynthetix(address account)
3247         public
3248         view
3249         rateNotStale("SNX")
3250         returns (uint)
3251     {
3252         // How many SNX do they have, excluding escrow?
3253         // Note: We're excluding escrow here because we're interested in their transferable amount
3254         // and escrowed SNX are not transferable.
3255         uint balance = tokenState.balanceOf(account);
3256 
3257         // How many of those will be locked by the amount they've issued?
3258         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3259         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3260         // The locked synthetix value can exceed their balance.
3261         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3262 
3263         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3264         if (lockedSynthetixValue >= balance) {
3265             return 0;
3266         } else {
3267             return balance.sub(lockedSynthetixValue);
3268         }
3269     }
3270 
3271     function mint()
3272         external
3273         returns (bool)
3274     {
3275         require(rewardEscrow != address(0), "Reward Escrow destination missing");
3276 
3277         uint supplyToMint = supplySchedule.mintableSupply();
3278         require(supplyToMint > 0, "No supply is mintable");
3279 
3280         supplySchedule.updateMintValues();
3281 
3282         // Set minted SNX balance to RewardEscrow's balance
3283         // Minus the minterReward and set balance of minter to add reward
3284         uint minterReward = supplySchedule.minterReward();
3285 
3286         tokenState.setBalanceOf(rewardEscrow, tokenState.balanceOf(rewardEscrow).add(supplyToMint.sub(minterReward)));
3287         emitTransfer(this, rewardEscrow, supplyToMint.sub(minterReward));
3288 
3289         // Tell the FeePool how much it has to distribute
3290         feePool.rewardsMinted(supplyToMint.sub(minterReward));
3291 
3292         // Assign the minters reward.
3293         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
3294         emitTransfer(this, msg.sender, minterReward);
3295 
3296         totalSupply = totalSupply.add(supplyToMint);
3297     }
3298 
3299     // ========== MODIFIERS ==========
3300 
3301     modifier rateNotStale(bytes4 currencyKey) {
3302         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
3303         _;
3304     }
3305 
3306     modifier notFeeAddress(address account) {
3307         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3308         _;
3309     }
3310 
3311     modifier onlySynth() {
3312         bool isSynth = false;
3313 
3314         // No need to repeatedly call this function either
3315         for (uint8 i = 0; i < availableSynths.length; i++) {
3316             if (availableSynths[i] == msg.sender) {
3317                 isSynth = true;
3318                 break;
3319             }
3320         }
3321 
3322         require(isSynth, "Only synth allowed");
3323         _;
3324     }
3325 
3326     modifier nonZeroAmount(uint _amount) {
3327         require(_amount > 0, "Amount needs to be larger than 0");
3328         _;
3329     }
3330 
3331     modifier onlyOracle
3332     {
3333         require(msg.sender == exchangeRates.oracle(), "Only the oracle can perform this action");
3334         _;
3335     }
3336 
3337     // ========== EVENTS ==========
3338     /* solium-disable */
3339     event SynthExchange(address indexed account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey,  uint256 toAmount, address toAddress);
3340     bytes32 constant SYNTHEXCHANGE_SIG = keccak256("SynthExchange(address,bytes4,uint256,bytes4,uint256,address)");
3341     function emitSynthExchange(address account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey, uint256 toAmount, address toAddress) internal {
3342         proxy._emit(abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress), 2, SYNTHEXCHANGE_SIG, bytes32(account), 0, 0);
3343     }
3344     /* solium-enable */
3345 }
3346 
3347 
3348 /*
3349 -----------------------------------------------------------------
3350 FILE INFORMATION
3351 -----------------------------------------------------------------
3352 
3353 file:       Synth.sol
3354 version:    2.0
3355 author:     Kevin Brown
3356 date:       2018-09-13
3357 
3358 -----------------------------------------------------------------
3359 MODULE DESCRIPTION
3360 -----------------------------------------------------------------
3361 
3362 Synthetix-backed stablecoin contract.
3363 
3364 This contract issues synths, which are tokens that mirror various
3365 flavours of fiat currency.
3366 
3367 Synths are issuable by Synthetix Network Token (SNX) holders who
3368 have to lock up some value of their SNX to issue S * Cmax synths.
3369 Where Cmax issome value less than 1.
3370 
3371 A configurable fee is charged on synth transfers and deposited
3372 into a common pot, which Synthetix holders may withdraw from once
3373 per fee period.
3374 
3375 -----------------------------------------------------------------
3376 */
3377 
3378 
3379 contract Synth is ExternStateToken {
3380 
3381     /* ========== STATE VARIABLES ========== */
3382 
3383     IFeePool public feePool;
3384     Synthetix public synthetix;
3385 
3386     // Currency key which identifies this Synth to the Synthetix system
3387     bytes4 public currencyKey;
3388 
3389     uint8 constant DECIMALS = 18;
3390 
3391     /* ========== CONSTRUCTOR ========== */
3392 
3393     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, IFeePool _feePool,
3394         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey
3395     )
3396         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, 0, DECIMALS, _owner)
3397         public
3398     {
3399         require(_proxy != 0, "_proxy cannot be 0");
3400         require(address(_synthetix) != 0, "_synthetix cannot be 0");
3401         require(address(_feePool) != 0, "_feePool cannot be 0");
3402         require(_owner != 0, "_owner cannot be 0");
3403         require(_synthetix.synths(_currencyKey) == Synth(0), "Currency key is already in use");
3404 
3405         feePool = _feePool;
3406         synthetix = _synthetix;
3407         currencyKey = _currencyKey;
3408     }
3409 
3410     /* ========== SETTERS ========== */
3411 
3412     function setSynthetix(Synthetix _synthetix)
3413         external
3414         optionalProxy_onlyOwner
3415     {
3416         synthetix = _synthetix;
3417         emitSynthetixUpdated(_synthetix);
3418     }
3419 
3420     function setFeePool(IFeePool _feePool)
3421         external
3422         optionalProxy_onlyOwner
3423     {
3424         feePool = _feePool;
3425         emitFeePoolUpdated(_feePool);
3426     }
3427 
3428     /* ========== MUTATIVE FUNCTIONS ========== */
3429 
3430     /**
3431      * @notice Override ERC20 transfer function in order to
3432      * subtract the transaction fee and send it to the fee pool
3433      * for SNX holders to claim. */
3434     function transfer(address to, uint value)
3435         public
3436         optionalProxy
3437         notFeeAddress(messageSender)
3438         returns (bool)
3439     {
3440         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3441         uint fee = value.sub(amountReceived);
3442 
3443         // Send the fee off to the fee pool.
3444         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3445 
3446         // And send their result off to the destination address
3447         bytes memory empty;
3448         return _internalTransfer(messageSender, to, amountReceived, empty);
3449     }
3450 
3451     /**
3452      * @notice Override ERC223 transfer function in order to
3453      * subtract the transaction fee and send it to the fee pool
3454      * for SNX holders to claim. */
3455     function transfer(address to, uint value, bytes data)
3456         public
3457         optionalProxy
3458         notFeeAddress(messageSender)
3459         returns (bool)
3460     {
3461         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3462         uint fee = value.sub(amountReceived);
3463 
3464         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3465         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3466 
3467         // And send their result off to the destination address
3468         return _internalTransfer(messageSender, to, amountReceived, data);
3469     }
3470 
3471     /**
3472      * @notice Override ERC20 transferFrom function in order to
3473      * subtract the transaction fee and send it to the fee pool
3474      * for SNX holders to claim. */
3475     function transferFrom(address from, address to, uint value)
3476         public
3477         optionalProxy
3478         notFeeAddress(from)
3479         returns (bool)
3480     {
3481         // The fee is deducted from the amount sent.
3482         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3483         uint fee = value.sub(amountReceived);
3484 
3485         // Reduce the allowance by the amount we're transferring.
3486         // The safeSub call will handle an insufficient allowance.
3487         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
3488 
3489         // Send the fee off to the fee pool.
3490         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
3491 
3492         bytes memory empty;
3493         return _internalTransfer(from, to, amountReceived, empty);
3494     }
3495 
3496     /**
3497      * @notice Override ERC223 transferFrom function in order to
3498      * subtract the transaction fee and send it to the fee pool
3499      * for SNX holders to claim. */
3500     function transferFrom(address from, address to, uint value, bytes data)
3501         public
3502         optionalProxy
3503         notFeeAddress(from)
3504         returns (bool)
3505     {
3506         // The fee is deducted from the amount sent.
3507         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3508         uint fee = value.sub(amountReceived);
3509 
3510         // Reduce the allowance by the amount we're transferring.
3511         // The safeSub call will handle an insufficient allowance.
3512         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
3513 
3514         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3515         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
3516 
3517         return _internalTransfer(from, to, amountReceived, data);
3518     }
3519 
3520     /* Subtract the transfer fee from the senders account so the
3521      * receiver gets the exact amount specified to send. */
3522     function transferSenderPaysFee(address to, uint value)
3523         public
3524         optionalProxy
3525         notFeeAddress(messageSender)
3526         returns (bool)
3527     {
3528         uint fee = feePool.transferFeeIncurred(value);
3529 
3530         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3531         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3532 
3533         // And send their transfer amount off to the destination address
3534         bytes memory empty;
3535         return _internalTransfer(messageSender, to, value, empty);
3536     }
3537 
3538     /* Subtract the transfer fee from the senders account so the
3539      * receiver gets the exact amount specified to send. */
3540     function transferSenderPaysFee(address to, uint value, bytes data)
3541         public
3542         optionalProxy
3543         notFeeAddress(messageSender)
3544         returns (bool)
3545     {
3546         uint fee = feePool.transferFeeIncurred(value);
3547 
3548         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3549         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3550 
3551         // And send their transfer amount off to the destination address
3552         return _internalTransfer(messageSender, to, value, data);
3553     }
3554 
3555     /* Subtract the transfer fee from the senders account so the
3556      * to address receives the exact amount specified to send. */
3557     function transferFromSenderPaysFee(address from, address to, uint value)
3558         public
3559         optionalProxy
3560         notFeeAddress(from)
3561         returns (bool)
3562     {
3563         uint fee = feePool.transferFeeIncurred(value);
3564 
3565         // Reduce the allowance by the amount we're transferring.
3566         // The safeSub call will handle an insufficient allowance.
3567         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
3568 
3569         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3570         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
3571 
3572         bytes memory empty;
3573         return _internalTransfer(from, to, value, empty);
3574     }
3575 
3576     /* Subtract the transfer fee from the senders account so the
3577      * to address receives the exact amount specified to send. */
3578     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
3579         public
3580         optionalProxy
3581         notFeeAddress(from)
3582         returns (bool)
3583     {
3584         uint fee = feePool.transferFeeIncurred(value);
3585 
3586         // Reduce the allowance by the amount we're transferring.
3587         // The safeSub call will handle an insufficient allowance.
3588         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
3589 
3590         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3591         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
3592 
3593         return _internalTransfer(from, to, value, data);
3594     }
3595 
3596     // Override our internal transfer to inject preferred currency support
3597     function _internalTransfer(address from, address to, uint value, bytes data)
3598         internal
3599         returns (bool)
3600     {
3601         bytes4 preferredCurrencyKey = synthetix.synthetixState().preferredCurrency(to);
3602 
3603         // Do they have a preferred currency that's not us? If so we need to exchange
3604         if (preferredCurrencyKey != 0 && preferredCurrencyKey != currencyKey) {
3605             return synthetix.synthInitiatedExchange(from, currencyKey, value, preferredCurrencyKey, to);
3606         } else {
3607             // Otherwise we just transfer
3608             return super._internalTransfer(from, to, value, data);
3609         }
3610     }
3611 
3612     // Allow synthetix to issue a certain number of synths from an account.
3613     function issue(address account, uint amount)
3614         external
3615         onlySynthetixOrFeePool
3616     {
3617         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
3618         totalSupply = totalSupply.add(amount);
3619         emitTransfer(address(0), account, amount);
3620         emitIssued(account, amount);
3621     }
3622 
3623     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
3624     function burn(address account, uint amount)
3625         external
3626         onlySynthetixOrFeePool
3627     {
3628         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
3629         totalSupply = totalSupply.sub(amount);
3630         emitTransfer(account, address(0), amount);
3631         emitBurned(account, amount);
3632     }
3633 
3634     // Allow owner to set the total supply on import.
3635     function setTotalSupply(uint amount)
3636         external
3637         optionalProxy_onlyOwner
3638     {
3639         totalSupply = amount;
3640     }
3641 
3642     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
3643     // exchange as well as transfer
3644     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
3645         external
3646         onlySynthetixOrFeePool
3647     {
3648         bytes memory empty;
3649         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
3650     }
3651 
3652     /* ========== MODIFIERS ========== */
3653 
3654     modifier onlySynthetixOrFeePool() {
3655         bool isSynthetix = msg.sender == address(synthetix);
3656         bool isFeePool = msg.sender == address(feePool);
3657 
3658         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
3659         _;
3660     }
3661 
3662     modifier notFeeAddress(address account) {
3663         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
3664         _;
3665     }
3666 
3667     /* ========== EVENTS ========== */
3668 
3669     event SynthetixUpdated(address newSynthetix);
3670     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
3671     function emitSynthetixUpdated(address newSynthetix) internal {
3672         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
3673     }
3674 
3675     event FeePoolUpdated(address newFeePool);
3676     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
3677     function emitFeePoolUpdated(address newFeePool) internal {
3678         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
3679     }
3680 
3681     event Issued(address indexed account, uint value);
3682     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
3683     function emitIssued(address account, uint value) internal {
3684         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
3685     }
3686 
3687     event Burned(address indexed account, uint value);
3688     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
3689     function emitBurned(address account, uint value) internal {
3690         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
3691     }
3692 }
3693 
3694 /*
3695 -----------------------------------------------------------------
3696 FILE INFORMATION
3697 -----------------------------------------------------------------
3698 
3699 file:       PurgeableSynth.sol
3700 version:    1.0
3701 author:     Justin J. Moses
3702 date:       2019-05-22
3703 
3704 -----------------------------------------------------------------
3705 MODULE DESCRIPTION
3706 -----------------------------------------------------------------
3707 
3708 Purgeable synths are a subclass of Synth that allows the owner
3709 to exchange all holders of the Synth back into sUSD.
3710 
3711 In order to reduce gas load on the system, and to repurpose older synths
3712 no longer used, purge allows the owner to
3713 
3714 These are used only for frozen or deprecated synths, and the total supply is
3715 hard-coded to
3716 -----------------------------------------------------------------
3717 */
3718 
3719 
3720 contract PurgeableSynth is Synth {
3721 
3722     using SafeDecimalMath for uint;
3723 
3724     // The maximum allowed amount of tokenSupply in equivalent sUSD value for this synth to permit purging
3725     uint public maxSupplyToPurgeInUSD = 10000 * SafeDecimalMath.unit(); // 10,000
3726 
3727     // Track exchange rates so we can determine if supply in USD is below threshpld at purge time
3728     ExchangeRates public exchangeRates;
3729 
3730     /* ========== CONSTRUCTOR ========== */
3731 
3732     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, IFeePool _feePool,
3733         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey, ExchangeRates _exchangeRates
3734     )
3735         Synth(_proxy, _tokenState, _synthetix, _feePool, _tokenName, _tokenSymbol, _owner, _currencyKey)
3736         public
3737     {
3738         exchangeRates = _exchangeRates;
3739     }
3740 
3741     /* ========== MUTATIVE FUNCTIONS ========== */
3742 
3743     /**
3744      * @notice Function that allows owner to exchange any number of holders back to sUSD (for frozen or deprecated synths)
3745      * @param addresses The list of holders to purge
3746      */
3747     function purge(address[] addresses)
3748         external
3749         optionalProxy_onlyOwner
3750     {
3751         uint maxSupplyToPurge = exchangeRates.effectiveValue("sUSD", maxSupplyToPurgeInUSD, currencyKey);
3752 
3753         // Only allow purge when total supply is lte the max or the rate is frozen in ExchangeRates
3754         require(
3755             totalSupply <= maxSupplyToPurge || exchangeRates.rateIsFrozen(currencyKey),
3756             "Cannot purge as total supply is above threshold and rate is not frozen."
3757         );
3758 
3759         for (uint8 i = 0; i < addresses.length; i++) {
3760             address holder = addresses[i];
3761 
3762             uint amountHeld = balanceOf(holder);
3763 
3764             if (amountHeld > 0) {
3765                 synthetix.synthInitiatedExchange(holder, currencyKey, amountHeld, "sUSD", holder);
3766                 emitPurged(holder, amountHeld);
3767             }
3768 
3769         }
3770 
3771     }
3772 
3773     /* ========== SETTERS ========== */
3774 
3775     function setExchangeRates(ExchangeRates _exchangeRates)
3776         external
3777         optionalProxy_onlyOwner
3778     {
3779         exchangeRates = _exchangeRates;
3780     }
3781 
3782     /* ========== EVENTS ========== */
3783 
3784     event Purged(address indexed account, uint value);
3785     bytes32 constant PURGED_SIG = keccak256("Purged(address,uint256)");
3786     function emitPurged(address account, uint value) internal {
3787         proxy._emit(abi.encode(value), 2, PURGED_SIG, bytes32(account), 0, 0);
3788     }
3789 }