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
530 MODULE DESCRIPTION
531 -----------------------------------------------------------------
532 
533 A contract that any other contract in the Synthetix system can query
534 for the current market value of various assets, including
535 crypto assets as well as various fiat assets.
536 
537 This contract assumes that rate updates will completely update
538 all rates to their current values. If a rate shock happens
539 on a single asset, the oracle will still push updated rates
540 for all other assets.
541 
542 -----------------------------------------------------------------
543 */
544 
545 
546 /**
547  * @title The repository for exchange rates
548  */
549 
550 contract ExchangeRates is SelfDestructible {
551 
552 
553     using SafeMath for uint;
554     using SafeDecimalMath for uint;
555 
556     struct RateAndUpdatedTime {
557         uint216 rate;
558         uint40 time;
559     }
560 
561     // Exchange rates and update times stored by currency code, e.g. 'SNX', or 'sUSD'
562     mapping(bytes32 => RateAndUpdatedTime) private _rates;
563 
564     // The address of the oracle which pushes rate updates to this contract
565     address public oracle;
566 
567     // Do not allow the oracle to submit times any further forward into the future than this constant.
568     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
569 
570     // How long will the contract assume the rate of any asset is correct
571     uint public rateStalePeriod = 3 hours;
572 
573 
574     // Each participating currency in the XDR basket is represented as a currency key with
575     // equal weighting.
576     // There are 5 participating currencies, so we'll declare that clearly.
577     bytes32[5] public xdrParticipants;
578 
579     // A conveience mapping for checking if a rate is a XDR participant
580     mapping(bytes32 => bool) public isXDRParticipant;
581 
582     // For inverted prices, keep a mapping of their entry, limits and frozen status
583     struct InversePricing {
584         uint entryPoint;
585         uint upperLimit;
586         uint lowerLimit;
587         bool frozen;
588     }
589     mapping(bytes32 => InversePricing) public inversePricing;
590     bytes32[] public invertedKeys;
591 
592     //
593     // ========== CONSTRUCTOR ==========
594 
595     /**
596      * @dev Constructor
597      * @param _owner The owner of this contract.
598      * @param _oracle The address which is able to update rate information.
599      * @param _currencyKeys The initial currency keys to store (in order).
600      * @param _newRates The initial currency amounts for each currency (in order).
601      */
602     constructor(
603         // SelfDestructible (Ownable)
604         address _owner,
605 
606         // Oracle values - Allows for rate updates
607         address _oracle,
608         bytes32[] _currencyKeys,
609         uint[] _newRates
610     )
611         /* Owned is initialised in SelfDestructible */
612         SelfDestructible(_owner)
613         public
614     {
615         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
616 
617         oracle = _oracle;
618 
619         // The sUSD rate is always 1 and is never stale.
620         _setRate("sUSD", SafeDecimalMath.unit(), now);
621 
622         // These are the currencies that make up the XDR basket.
623         // These are hard coded because:
624         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
625         //  - Adding new currencies would likely introduce some kind of weighting factor, which
626         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
627         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
628         //    then point the system at the new version.
629         xdrParticipants = [
630             bytes32("sUSD"),
631             bytes32("sAUD"),
632             bytes32("sCHF"),
633             bytes32("sEUR"),
634             bytes32("sGBP")
635         ];
636 
637         // Mapping the XDR participants is cheaper than looping the xdrParticipants array to check if they exist
638         isXDRParticipant[bytes32("sUSD")] = true;
639         isXDRParticipant[bytes32("sAUD")] = true;
640         isXDRParticipant[bytes32("sCHF")] = true;
641         isXDRParticipant[bytes32("sEUR")] = true;
642         isXDRParticipant[bytes32("sGBP")] = true;
643 
644         internalUpdateRates(_currencyKeys, _newRates, now);
645     }
646 
647     function rates(bytes32 code) public view returns(uint256) {
648         return uint256(_rates[code].rate);
649     }
650 
651     function lastRateUpdateTimes(bytes32 code) public view returns(uint256) {
652         return uint256(_rates[code].time);
653     }
654 
655     function _setRate(bytes32 code, uint256 rate, uint256 time) internal {
656         _rates[code] = RateAndUpdatedTime({
657             rate: uint216(rate),
658             time: uint40(time)
659         });
660     }
661 
662     /* ========== SETTERS ========== */
663 
664     /**
665      * @notice Set the rates stored in this contract
666      * @param currencyKeys The currency keys you wish to update the rates for (in order)
667      * @param newRates The rates for each currency (in order)
668      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
669      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
670      *                 if it takes a long time for the transaction to confirm.
671      */
672     function updateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
673         external
674         onlyOracle
675         returns(bool)
676     {
677         return internalUpdateRates(currencyKeys, newRates, timeSent);
678     }
679 
680     /**
681      * @notice Internal function which sets the rates stored in this contract
682      * @param currencyKeys The currency keys you wish to update the rates for (in order)
683      * @param newRates The rates for each currency (in order)
684      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
685      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
686      *                 if it takes a long time for the transaction to confirm.
687      */
688     function internalUpdateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
689         internal
690         returns(bool)
691     {
692         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
693         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
694 
695         bool recomputeXDRRate = false;
696 
697         // Loop through each key and perform update.
698         for (uint i = 0; i < currencyKeys.length; i++) {
699             bytes32 currencyKey = currencyKeys[i];
700 
701             // Should not set any rate to zero ever, as no asset will ever be
702             // truely worthless and still valid. In this scenario, we should
703             // delete the rate and remove it from the system.
704             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
705             require(currencyKey != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
706 
707             // We should only update the rate if it's at least the same age as the last rate we've got.
708             if (timeSent < lastRateUpdateTimes(currencyKey)) {
709                 continue;
710             }
711 
712             newRates[i] = rateOrInverted(currencyKey, newRates[i]);
713 
714             // Ok, go ahead with the update.
715             _setRate(currencyKey, newRates[i], timeSent);
716 
717             // Flag if XDR needs to be recomputed. Note: sUSD is not sent and assumed $1
718             if (!recomputeXDRRate && isXDRParticipant[currencyKey]) {
719                 recomputeXDRRate = true;
720             }
721         }
722 
723         emit RatesUpdated(currencyKeys, newRates);
724 
725         if (recomputeXDRRate) {
726             // Now update our XDR rate.
727             updateXDRRate(timeSent);
728         }
729 
730         return true;
731     }
732 
733     /**
734      * @notice Internal function to get the inverted rate, if any, and mark an inverted
735      *  key as frozen if either limits are reached.
736      *
737      * Inverted rates are ones that take a regular rate, perform a simple calculation (double entryPrice and
738      * subtract the rate) on them and if the result of the calculation is over or under predefined limits, it freezes the
739      * rate at that limit, preventing any future rate updates.
740      *
741      * For example, if we have an inverted rate iBTC with the following parameters set:
742      * - entryPrice of 200
743      * - upperLimit of 300
744      * - lower of 100
745      *
746      * if this function is invoked with params iETH and 184 (or rather 184e18),
747      * then the rate would be: 200 * 2 - 184 = 216. 100 < 216 < 200, so the rate would be 216,
748      * and remain unfrozen.
749      *
750      * If this function is then invoked with params iETH and 301 (or rather 301e18),
751      * then the rate would be: 200 * 2 - 301 = 99. 99 < 100, so the rate would be 100 and the
752      * rate would become frozen, no longer accepting future price updates until the synth is unfrozen
753      * by the owner function: setInversePricing().
754      *
755      * @param currencyKey The price key to lookup
756      * @param rate The rate for the given price key
757      */
758     function rateOrInverted(bytes32 currencyKey, uint rate) internal returns (uint) {
759         // if an inverse mapping exists, adjust the price accordingly
760         InversePricing storage inverse = inversePricing[currencyKey];
761         if (inverse.entryPoint <= 0) {
762             return rate;
763         }
764 
765         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
766         uint newInverseRate = rates(currencyKey);
767 
768         // get the new inverted rate if not frozen
769         if (!inverse.frozen) {
770             uint doubleEntryPoint = inverse.entryPoint.mul(2);
771             if (doubleEntryPoint <= rate) {
772                 // avoid negative numbers for unsigned ints, so set this to 0
773                 // which by the requirement that lowerLimit be > 0 will
774                 // cause this to freeze the price to the lowerLimit
775                 newInverseRate = 0;
776             } else {
777                 newInverseRate = doubleEntryPoint.sub(rate);
778             }
779 
780             // now if new rate hits our limits, set it to the limit and freeze
781             if (newInverseRate >= inverse.upperLimit) {
782                 newInverseRate = inverse.upperLimit;
783             } else if (newInverseRate <= inverse.lowerLimit) {
784                 newInverseRate = inverse.lowerLimit;
785             }
786 
787             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
788                 inverse.frozen = true;
789                 emit InversePriceFrozen(currencyKey);
790             }
791         }
792 
793         return newInverseRate;
794     }
795 
796     /**
797      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
798      */
799     function updateXDRRate(uint timeSent)
800         internal
801     {
802         uint total = 0;
803 
804         for (uint i = 0; i < xdrParticipants.length; i++) {
805             total = rates(xdrParticipants[i]).add(total);
806         }
807 
808         // Set the rate and update time
809         _setRate("XDR", total, timeSent);
810 
811         // Emit our updated event separate to the others to save
812         // moving data around between arrays.
813         bytes32[] memory eventCurrencyCode = new bytes32[](1);
814         eventCurrencyCode[0] = "XDR";
815 
816         uint[] memory eventRate = new uint[](1);
817         eventRate[0] = rates("XDR");
818 
819         emit RatesUpdated(eventCurrencyCode, eventRate);
820     }
821 
822     /**
823      * @notice Delete a rate stored in the contract
824      * @param currencyKey The currency key you wish to delete the rate for
825      */
826     function deleteRate(bytes32 currencyKey)
827         external
828         onlyOracle
829     {
830         require(rates(currencyKey) > 0, "Rate is zero");
831 
832         delete _rates[currencyKey];
833 
834         emit RateDeleted(currencyKey);
835     }
836 
837     /**
838      * @notice Set the Oracle that pushes the rate information to this contract
839      * @param _oracle The new oracle address
840      */
841     function setOracle(address _oracle)
842         external
843         onlyOwner
844     {
845         oracle = _oracle;
846         emit OracleUpdated(oracle);
847     }
848 
849     /**
850      * @notice Set the stale period on the updated rate variables
851      * @param _time The new rateStalePeriod
852      */
853     function setRateStalePeriod(uint _time)
854         external
855         onlyOwner
856     {
857         rateStalePeriod = _time;
858         emit RateStalePeriodUpdated(rateStalePeriod);
859     }
860 
861     /**
862      * @notice Set an inverse price up for the currency key.
863      *
864      * An inverse price is one which has an entryPoint, an uppper and a lower limit. Each update, the
865      * rate is calculated as double the entryPrice minus the current rate. If this calculation is
866      * above or below the upper or lower limits respectively, then the rate is frozen, and no more
867      * rate updates will be accepted.
868      *
869      * @param currencyKey The currency to update
870      * @param entryPoint The entry price point of the inverted price
871      * @param upperLimit The upper limit, at or above which the price will be frozen
872      * @param lowerLimit The lower limit, at or below which the price will be frozen
873      * @param freeze Whether or not to freeze this rate immediately. Note: no frozen event will be configured
874      * @param freezeAtUpperLimit When the freeze flag is true, this flag indicates whether the rate
875      * to freeze at is the upperLimit or lowerLimit..
876      */
877     function setInversePricing(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit, bool freeze, bool freezeAtUpperLimit)
878         external onlyOwner
879     {
880         require(entryPoint > 0, "entryPoint must be above 0");
881         require(lowerLimit > 0, "lowerLimit must be above 0");
882         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
883         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
884         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
885 
886         if (inversePricing[currencyKey].entryPoint <= 0) {
887             // then we are adding a new inverse pricing, so add this
888             invertedKeys.push(currencyKey);
889         }
890         inversePricing[currencyKey].entryPoint = entryPoint;
891         inversePricing[currencyKey].upperLimit = upperLimit;
892         inversePricing[currencyKey].lowerLimit = lowerLimit;
893         inversePricing[currencyKey].frozen = freeze;
894 
895         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
896 
897         // When indicating to freeze, we need to know the rate to freeze it at - either upper or lower
898         // this is useful in situations where ExchangeRates is updated and there are existing inverted
899         // rates already frozen in the current contract that need persisting across the upgrade
900         if (freeze) {
901             emit InversePriceFrozen(currencyKey);
902 
903             _setRate(currencyKey, freezeAtUpperLimit ? upperLimit : lowerLimit, now);
904         }
905     }
906 
907     /**
908      * @notice Remove an inverse price for the currency key
909      * @param currencyKey The currency to remove inverse pricing for
910      */
911     function removeInversePricing(bytes32 currencyKey) external onlyOwner
912     {
913         require(inversePricing[currencyKey].entryPoint > 0, "No inverted price exists");
914 
915         inversePricing[currencyKey].entryPoint = 0;
916         inversePricing[currencyKey].upperLimit = 0;
917         inversePricing[currencyKey].lowerLimit = 0;
918         inversePricing[currencyKey].frozen = false;
919 
920         // now remove inverted key from array
921         for (uint i = 0; i < invertedKeys.length; i++) {
922             if (invertedKeys[i] == currencyKey) {
923                 delete invertedKeys[i];
924 
925                 // Copy the last key into the place of the one we just deleted
926                 // If there's only one key, this is array[0] = array[0].
927                 // If we're deleting the last one, it's also a NOOP in the same way.
928                 invertedKeys[i] = invertedKeys[invertedKeys.length - 1];
929 
930                 // Decrease the size of the array by one.
931                 invertedKeys.length--;
932 
933                 // Track the event
934                 emit InversePriceConfigured(currencyKey, 0, 0, 0);
935 
936                 return;
937             }
938         }
939     }
940     /* ========== VIEWS ========== */
941 
942     /**
943      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
944      * @param sourceCurrencyKey The currency the amount is specified in
945      * @param sourceAmount The source amount, specified in UNIT base
946      * @param destinationCurrencyKey The destination currency
947      */
948     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
949         public
950         view
951         rateNotStale(sourceCurrencyKey)
952         rateNotStale(destinationCurrencyKey)
953         returns (uint)
954     {
955         // If there's no change in the currency, then just return the amount they gave us
956         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
957 
958         // Calculate the effective value by going from source -> USD -> destination
959         return sourceAmount.multiplyDecimalRound(rateForCurrency(sourceCurrencyKey))
960             .divideDecimalRound(rateForCurrency(destinationCurrencyKey));
961     }
962 
963     /**
964      * @notice Retrieve the rate for a specific currency
965      */
966     function rateForCurrency(bytes32 currencyKey)
967         public
968         view
969         returns (uint)
970     {
971         return rates(currencyKey);
972     }
973 
974     /**
975      * @notice Retrieve the rates for a list of currencies
976      */
977     function ratesForCurrencies(bytes32[] currencyKeys)
978         public
979         view
980         returns (uint[])
981     {
982         uint[] memory _localRates = new uint[](currencyKeys.length);
983 
984         for (uint i = 0; i < currencyKeys.length; i++) {
985             _localRates[i] = rates(currencyKeys[i]);
986         }
987 
988         return _localRates;
989     }
990 
991     /**
992      * @notice Retrieve the rates and isAnyStale for a list of currencies
993      */
994     function ratesAndStaleForCurrencies(bytes32[] currencyKeys)
995         public
996         view
997         returns (uint[], bool)
998     {
999         uint[] memory _localRates = new uint[](currencyKeys.length);
1000 
1001         bool anyRateStale = false;
1002         uint period = rateStalePeriod;
1003         for (uint i = 0; i < currencyKeys.length; i++) {
1004             RateAndUpdatedTime memory rateAndUpdateTime = _rates[currencyKeys[i]];
1005             _localRates[i] = uint256(rateAndUpdateTime.rate);
1006             if (!anyRateStale) {
1007                 anyRateStale = (currencyKeys[i] != "sUSD" && uint256(rateAndUpdateTime.time).add(period) < now);
1008             }
1009         }
1010 
1011         return (_localRates, anyRateStale);
1012     }
1013 
1014     /**
1015      * @notice Retrieve a list of last update times for specific currencies
1016      */
1017     function lastRateUpdateTimeForCurrency(bytes32 currencyKey)
1018         public
1019         view
1020         returns (uint)
1021     {
1022         return lastRateUpdateTimes(currencyKey);
1023     }
1024 
1025     /**
1026      * @notice Retrieve the last update time for a specific currency
1027      */
1028     function lastRateUpdateTimesForCurrencies(bytes32[] currencyKeys)
1029         public
1030         view
1031         returns (uint[])
1032     {
1033         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
1034 
1035         for (uint i = 0; i < currencyKeys.length; i++) {
1036             lastUpdateTimes[i] = lastRateUpdateTimes(currencyKeys[i]);
1037         }
1038 
1039         return lastUpdateTimes;
1040     }
1041 
1042     /**
1043      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
1044      */
1045     function rateIsStale(bytes32 currencyKey)
1046         public
1047         view
1048         returns (bool)
1049     {
1050         // sUSD is a special case and is never stale.
1051         if (currencyKey == "sUSD") return false;
1052 
1053         return lastRateUpdateTimes(currencyKey).add(rateStalePeriod) < now;
1054     }
1055 
1056     /**
1057      * @notice Check if any rate is frozen (cannot be exchanged into)
1058      */
1059     function rateIsFrozen(bytes32 currencyKey)
1060         external
1061         view
1062         returns (bool)
1063     {
1064         return inversePricing[currencyKey].frozen;
1065     }
1066 
1067 
1068     /**
1069      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
1070      */
1071     function anyRateIsStale(bytes32[] currencyKeys)
1072         external
1073         view
1074         returns (bool)
1075     {
1076         // Loop through each key and check whether the data point is stale.
1077         uint256 i = 0;
1078 
1079         while (i < currencyKeys.length) {
1080             // sUSD is a special case and is never false
1081             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes(currencyKeys[i]).add(rateStalePeriod) < now) {
1082                 return true;
1083             }
1084             i += 1;
1085         }
1086 
1087         return false;
1088     }
1089 
1090     /* ========== MODIFIERS ========== */
1091 
1092     modifier rateNotStale(bytes32 currencyKey) {
1093         require(!rateIsStale(currencyKey), "Rate stale or nonexistant currency");
1094         _;
1095     }
1096 
1097     modifier onlyOracle
1098     {
1099         require(msg.sender == oracle, "Only the oracle can perform this action");
1100         _;
1101     }
1102 
1103     /* ========== EVENTS ========== */
1104 
1105     event OracleUpdated(address newOracle);
1106     event RateStalePeriodUpdated(uint rateStalePeriod);
1107     event RatesUpdated(bytes32[] currencyKeys, uint[] newRates);
1108     event RateDeleted(bytes32 currencyKey);
1109     event InversePriceConfigured(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
1110     event InversePriceFrozen(bytes32 currencyKey);
1111 }
1112 
