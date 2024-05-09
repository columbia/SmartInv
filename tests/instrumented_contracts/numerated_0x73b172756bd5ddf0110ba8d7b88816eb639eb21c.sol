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
558 contract ExchangeRates is SelfDestructible {
559 
560     using SafeMath for uint;
561 
562     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
563     mapping(bytes4 => uint) public rates;
564 
565     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
566     mapping(bytes4 => uint) public lastRateUpdateTimes;
567 
568     // The address of the oracle which pushes rate updates to this contract
569     address public oracle;
570 
571     // Do not allow the oracle to submit times any further forward into the future than this constant.
572     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
573 
574     // How long will the contract assume the rate of any asset is correct
575     uint public rateStalePeriod = 3 hours;
576 
577     // Each participating currency in the XDR basket is represented as a currency key with
578     // equal weighting.
579     // There are 5 participating currencies, so we'll declare that clearly.
580     bytes4[5] public xdrParticipants;
581 
582     //
583     // ========== CONSTRUCTOR ==========
584 
585     /**
586      * @dev Constructor
587      * @param _owner The owner of this contract.
588      * @param _oracle The address which is able to update rate information.
589      * @param _currencyKeys The initial currency keys to store (in order).
590      * @param _newRates The initial currency amounts for each currency (in order).
591      */
592     constructor(
593         // SelfDestructible (Ownable)
594         address _owner,
595 
596         // Oracle values - Allows for rate updates
597         address _oracle,
598         bytes4[] _currencyKeys,
599         uint[] _newRates
600     )
601         /* Owned is initialised in SelfDestructible */
602         SelfDestructible(_owner)
603         public
604     {
605         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
606 
607         oracle = _oracle;
608 
609         // The sUSD rate is always 1 and is never stale.
610         rates["sUSD"] = SafeDecimalMath.unit();
611         lastRateUpdateTimes["sUSD"] = now;
612 
613         // These are the currencies that make up the XDR basket.
614         // These are hard coded because:
615         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
616         //  - Adding new currencies would likely introduce some kind of weighting factor, which
617         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
618         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
619         //    then point the system at the new version.
620         xdrParticipants = [
621             bytes4("sUSD"),
622             bytes4("sAUD"),
623             bytes4("sCHF"),
624             bytes4("sEUR"),
625             bytes4("sGBP")
626         ];
627 
628         internalUpdateRates(_currencyKeys, _newRates, now);
629     }
630 
631     /* ========== SETTERS ========== */
632 
633     /**
634      * @notice Set the rates stored in this contract
635      * @param currencyKeys The currency keys you wish to update the rates for (in order)
636      * @param newRates The rates for each currency (in order)
637      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
638      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
639      *                 if it takes a long time for the transaction to confirm.
640      */
641     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
642         external
643         onlyOracle
644         returns(bool)
645     {
646         return internalUpdateRates(currencyKeys, newRates, timeSent);
647     }
648 
649     /**
650      * @notice Internal function which sets the rates stored in this contract
651      * @param currencyKeys The currency keys you wish to update the rates for (in order)
652      * @param newRates The rates for each currency (in order)
653      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
654      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
655      *                 if it takes a long time for the transaction to confirm.
656      */
657     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
658         internal
659         returns(bool)
660     {
661         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
662         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
663 
664         // Loop through each key and perform update.
665         for (uint i = 0; i < currencyKeys.length; i++) {
666             // Should not set any rate to zero ever, as no asset will ever be
667             // truely worthless and still valid. In this scenario, we should
668             // delete the rate and remove it from the system.
669             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
670             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
671 
672             // We should only update the rate if it's at least the same age as the last rate we've got.
673             if (timeSent >= lastRateUpdateTimes[currencyKeys[i]]) {
674                 // Ok, go ahead with the update.
675                 rates[currencyKeys[i]] = newRates[i];
676                 lastRateUpdateTimes[currencyKeys[i]] = timeSent;
677             }
678         }
679 
680         emit RatesUpdated(currencyKeys, newRates);
681 
682         // Now update our XDR rate.
683         updateXDRRate(timeSent);
684 
685         return true;
686     }
687 
688     /**
689      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
690      */
691     function updateXDRRate(uint timeSent)
692         internal
693     {
694         uint total = 0;
695 
696         for (uint i = 0; i < xdrParticipants.length; i++) {
697             total = rates[xdrParticipants[i]].add(total);
698         }
699 
700         // Set the rate
701         rates["XDR"] = total;
702 
703         // Record that we updated the XDR rate.
704         lastRateUpdateTimes["XDR"] = timeSent;
705 
706         // Emit our updated event separate to the others to save
707         // moving data around between arrays.
708         bytes4[] memory eventCurrencyCode = new bytes4[](1);
709         eventCurrencyCode[0] = "XDR";
710 
711         uint[] memory eventRate = new uint[](1);
712         eventRate[0] = rates["XDR"];
713 
714         emit RatesUpdated(eventCurrencyCode, eventRate);
715     }
716 
717     /**
718      * @notice Delete a rate stored in the contract
719      * @param currencyKey The currency key you wish to delete the rate for
720      */
721     function deleteRate(bytes4 currencyKey)
722         external
723         onlyOracle
724     {
725         require(rates[currencyKey] > 0, "Rate is zero");
726 
727         delete rates[currencyKey];
728         delete lastRateUpdateTimes[currencyKey];
729 
730         emit RateDeleted(currencyKey);
731     }
732 
733     /**
734      * @notice Set the Oracle that pushes the rate information to this contract
735      * @param _oracle The new oracle address
736      */
737     function setOracle(address _oracle)
738         external
739         onlyOwner
740     {
741         oracle = _oracle;
742         emit OracleUpdated(oracle);
743     }
744 
745     /**
746      * @notice Set the stale period on the updated rate variables
747      * @param _time The new rateStalePeriod
748      */
749     function setRateStalePeriod(uint _time)
750         external
751         onlyOwner
752     {
753         rateStalePeriod = _time;
754         emit RateStalePeriodUpdated(rateStalePeriod);
755     }
756 
757     /* ========== VIEWS ========== */
758 
759     /**
760      * @notice Retrieve the rate for a specific currency
761      */
762     function rateForCurrency(bytes4 currencyKey)
763         public
764         view
765         returns (uint)
766     {
767         return rates[currencyKey];
768     }
769 
770     /**
771      * @notice Retrieve the rates for a list of currencies
772      */
773     function ratesForCurrencies(bytes4[] currencyKeys)
774         public
775         view
776         returns (uint[])
777     {
778         uint[] memory _rates = new uint[](currencyKeys.length);
779 
780         for (uint8 i = 0; i < currencyKeys.length; i++) {
781             _rates[i] = rates[currencyKeys[i]];
782         }
783 
784         return _rates;
785     }
786 
787     /**
788      * @notice Retrieve a list of last update times for specific currencies
789      */
790     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
791         public
792         view
793         returns (uint)
794     {
795         return lastRateUpdateTimes[currencyKey];
796     }
797 
798     /**
799      * @notice Retrieve the last update time for a specific currency
800      */
801     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
802         public
803         view
804         returns (uint[])
805     {
806         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
807 
808         for (uint8 i = 0; i < currencyKeys.length; i++) {
809             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
810         }
811 
812         return lastUpdateTimes;
813     }
814 
815     /**
816      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
817      */
818     function rateIsStale(bytes4 currencyKey)
819         external
820         view
821         returns (bool)
822     {
823         // sUSD is a special case and is never stale.
824         if (currencyKey == "sUSD") return false;
825 
826         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
827     }
828 
829     /**
830      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
831      */
832     function anyRateIsStale(bytes4[] currencyKeys)
833         external
834         view
835         returns (bool)
836     {
837         // Loop through each key and check whether the data point is stale.
838         uint256 i = 0;
839 
840         while (i < currencyKeys.length) {
841             // sUSD is a special case and is never false
842             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
843                 return true;
844             }
845             i += 1;
846         }
847 
848         return false;
849     }
850 
851     /* ========== MODIFIERS ========== */
852 
853     modifier onlyOracle
854     {
855         require(msg.sender == oracle, "Only the oracle can perform this action");
856         _;
857     }
858 
859     /* ========== EVENTS ========== */
860 
861     event OracleUpdated(address newOracle);
862     event RateStalePeriodUpdated(uint rateStalePeriod);
863     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
864     event RateDeleted(bytes4 currencyKey);
865 }