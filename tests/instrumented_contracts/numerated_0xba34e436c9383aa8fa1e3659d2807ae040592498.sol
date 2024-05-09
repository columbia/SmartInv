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
563 
564     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
565     mapping(bytes4 => uint) public rates;
566 
567     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
568     mapping(bytes4 => uint) public lastRateUpdateTimes;
569 
570     // The address of the oracle which pushes rate updates to this contract
571     address public oracle;
572 
573     // Do not allow the oracle to submit times any further forward into the future than this constant.
574     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
575 
576     // How long will the contract assume the rate of any asset is correct
577     uint public rateStalePeriod = 3 hours;
578 
579     // Each participating currency in the XDR basket is represented as a currency key with
580     // equal weighting.
581     // There are 5 participating currencies, so we'll declare that clearly.
582     bytes4[5] public xdrParticipants;
583 
584     // For inverted prices, keep a mapping of their entry, limits and frozen status
585     struct InversePricing {
586         uint entryPoint;
587         uint upperLimit;
588         uint lowerLimit;
589         bool frozen;
590     }
591     mapping(bytes4 => InversePricing) public inversePricing;
592     bytes4[] public invertedKeys;
593 
594     //
595     // ========== CONSTRUCTOR ==========
596 
597     /**
598      * @dev Constructor
599      * @param _owner The owner of this contract.
600      * @param _oracle The address which is able to update rate information.
601      * @param _currencyKeys The initial currency keys to store (in order).
602      * @param _newRates The initial currency amounts for each currency (in order).
603      */
604     constructor(
605         // SelfDestructible (Ownable)
606         address _owner,
607 
608         // Oracle values - Allows for rate updates
609         address _oracle,
610         bytes4[] _currencyKeys,
611         uint[] _newRates
612     )
613         /* Owned is initialised in SelfDestructible */
614         SelfDestructible(_owner)
615         public
616     {
617         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
618 
619         oracle = _oracle;
620 
621         // The sUSD rate is always 1 and is never stale.
622         rates["sUSD"] = SafeDecimalMath.unit();
623         lastRateUpdateTimes["sUSD"] = now;
624 
625         // These are the currencies that make up the XDR basket.
626         // These are hard coded because:
627         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
628         //  - Adding new currencies would likely introduce some kind of weighting factor, which
629         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
630         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
631         //    then point the system at the new version.
632         xdrParticipants = [
633             bytes4("sUSD"),
634             bytes4("sAUD"),
635             bytes4("sCHF"),
636             bytes4("sEUR"),
637             bytes4("sGBP")
638         ];
639 
640         internalUpdateRates(_currencyKeys, _newRates, now);
641     }
642 
643     /* ========== SETTERS ========== */
644 
645     /**
646      * @notice Set the rates stored in this contract
647      * @param currencyKeys The currency keys you wish to update the rates for (in order)
648      * @param newRates The rates for each currency (in order)
649      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
650      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
651      *                 if it takes a long time for the transaction to confirm.
652      */
653     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
654         external
655         onlyOracle
656         returns(bool)
657     {
658         return internalUpdateRates(currencyKeys, newRates, timeSent);
659     }
660 
661     /**
662      * @notice Internal function which sets the rates stored in this contract
663      * @param currencyKeys The currency keys you wish to update the rates for (in order)
664      * @param newRates The rates for each currency (in order)
665      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
666      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
667      *                 if it takes a long time for the transaction to confirm.
668      */
669     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
670         internal
671         returns(bool)
672     {
673         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
674         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
675 
676         // Loop through each key and perform update.
677         for (uint i = 0; i < currencyKeys.length; i++) {
678             // Should not set any rate to zero ever, as no asset will ever be
679             // truely worthless and still valid. In this scenario, we should
680             // delete the rate and remove it from the system.
681             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
682             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
683 
684             // We should only update the rate if it's at least the same age as the last rate we've got.
685             if (timeSent < lastRateUpdateTimes[currencyKeys[i]]) {
686                 continue;
687             }
688 
689             newRates[i] = rateOrInverted(currencyKeys[i], newRates[i]);
690 
691             // Ok, go ahead with the update.
692             rates[currencyKeys[i]] = newRates[i];
693             lastRateUpdateTimes[currencyKeys[i]] = timeSent;
694         }
695 
696         emit RatesUpdated(currencyKeys, newRates);
697 
698         // Now update our XDR rate.
699         updateXDRRate(timeSent);
700 
701         return true;
702     }
703 
704     /**
705      * @notice Internal function to get the inverted rate, if any, and mark an inverted
706      *  key as frozen if either limits are reached.
707      * @param currencyKey The price key to lookup
708      * @param rate The rate for the given price key
709      */
710     function rateOrInverted(bytes4 currencyKey, uint rate) internal returns (uint) {
711         // if an inverse mapping exists, adjust the price accordingly
712         InversePricing storage inverse = inversePricing[currencyKey];
713         if (inverse.entryPoint <= 0) {
714             return rate;
715         }
716 
717         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
718         uint newInverseRate = rates[currencyKey];
719 
720         // get the new inverted rate if not frozen
721         if (!inverse.frozen) {
722             uint doubleEntryPoint = inverse.entryPoint.mul(2);
723             if (doubleEntryPoint <= rate) {
724                 // avoid negative numbers for unsigned ints, so set this to 0
725                 // which by the requirement that lowerLimit be > 0 will
726                 // cause this to freeze the price to the lowerLimit
727                 newInverseRate = 0;
728             } else {
729                 newInverseRate = doubleEntryPoint.sub(rate);
730             }
731 
732             // now if new rate hits our limits, set it to the limit and freeze
733             if (newInverseRate >= inverse.upperLimit) {
734                 newInverseRate = inverse.upperLimit;
735             } else if (newInverseRate <= inverse.lowerLimit) {
736                 newInverseRate = inverse.lowerLimit;
737             }
738 
739             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
740                 inverse.frozen = true;
741                 emit InversePriceFrozen(currencyKey);
742             }
743         }
744 
745         return newInverseRate;
746     }
747 
748     /**
749      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
750      */
751     function updateXDRRate(uint timeSent)
752         internal
753     {
754         uint total = 0;
755 
756         for (uint i = 0; i < xdrParticipants.length; i++) {
757             total = rates[xdrParticipants[i]].add(total);
758         }
759 
760         // Set the rate
761         rates["XDR"] = total;
762 
763         // Record that we updated the XDR rate.
764         lastRateUpdateTimes["XDR"] = timeSent;
765 
766         // Emit our updated event separate to the others to save
767         // moving data around between arrays.
768         bytes4[] memory eventCurrencyCode = new bytes4[](1);
769         eventCurrencyCode[0] = "XDR";
770 
771         uint[] memory eventRate = new uint[](1);
772         eventRate[0] = rates["XDR"];
773 
774         emit RatesUpdated(eventCurrencyCode, eventRate);
775     }
776 
777     /**
778      * @notice Delete a rate stored in the contract
779      * @param currencyKey The currency key you wish to delete the rate for
780      */
781     function deleteRate(bytes4 currencyKey)
782         external
783         onlyOracle
784     {
785         require(rates[currencyKey] > 0, "Rate is zero");
786 
787         delete rates[currencyKey];
788         delete lastRateUpdateTimes[currencyKey];
789 
790         emit RateDeleted(currencyKey);
791     }
792 
793     /**
794      * @notice Set the Oracle that pushes the rate information to this contract
795      * @param _oracle The new oracle address
796      */
797     function setOracle(address _oracle)
798         external
799         onlyOwner
800     {
801         oracle = _oracle;
802         emit OracleUpdated(oracle);
803     }
804 
805     /**
806      * @notice Set the stale period on the updated rate variables
807      * @param _time The new rateStalePeriod
808      */
809     function setRateStalePeriod(uint _time)
810         external
811         onlyOwner
812     {
813         rateStalePeriod = _time;
814         emit RateStalePeriodUpdated(rateStalePeriod);
815     }
816 
817     /**
818      * @notice Set an inverse price up for the currency key
819      * @param currencyKey The currency to update
820      * @param entryPoint The entry price point of the inverted price
821      * @param upperLimit The upper limit, at or above which the price will be frozen
822      * @param lowerLimit The lower limit, at or below which the price will be frozen
823      */
824     function setInversePricing(bytes4 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit)
825         external onlyOwner
826     {
827         require(entryPoint > 0, "entryPoint must be above 0");
828         require(lowerLimit > 0, "lowerLimit must be above 0");
829         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
830         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
831         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
832 
833         if (inversePricing[currencyKey].entryPoint <= 0) {
834             // then we are adding a new inverse pricing, so add this
835             invertedKeys.push(currencyKey);
836         }
837         inversePricing[currencyKey].entryPoint = entryPoint;
838         inversePricing[currencyKey].upperLimit = upperLimit;
839         inversePricing[currencyKey].lowerLimit = lowerLimit;
840         inversePricing[currencyKey].frozen = false;
841 
842         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
843     }
844 
845     /**
846      * @notice Remove an inverse price for the currency key
847      * @param currencyKey The currency to remove inverse pricing for
848      */
849     function removeInversePricing(bytes4 currencyKey) external onlyOwner {
850         inversePricing[currencyKey].entryPoint = 0;
851         inversePricing[currencyKey].upperLimit = 0;
852         inversePricing[currencyKey].lowerLimit = 0;
853         inversePricing[currencyKey].frozen = false;
854 
855         // now remove inverted key from array
856         for (uint8 i = 0; i < invertedKeys.length; i++) {
857             if (invertedKeys[i] == currencyKey) {
858                 delete invertedKeys[i];
859 
860                 // Copy the last key into the place of the one we just deleted
861                 // If there's only one key, this is array[0] = array[0].
862                 // If we're deleting the last one, it's also a NOOP in the same way.
863                 invertedKeys[i] = invertedKeys[invertedKeys.length - 1];
864 
865                 // Decrease the size of the array by one.
866                 invertedKeys.length--;
867 
868                 break;
869             }
870         }
871 
872         emit InversePriceConfigured(currencyKey, 0, 0, 0);
873     }
874     /* ========== VIEWS ========== */
875 
876     /**
877      * @notice Retrieve the rate for a specific currency
878      */
879     function rateForCurrency(bytes4 currencyKey)
880         public
881         view
882         returns (uint)
883     {
884         return rates[currencyKey];
885     }
886 
887     /**
888      * @notice Retrieve the rates for a list of currencies
889      */
890     function ratesForCurrencies(bytes4[] currencyKeys)
891         public
892         view
893         returns (uint[])
894     {
895         uint[] memory _rates = new uint[](currencyKeys.length);
896 
897         for (uint8 i = 0; i < currencyKeys.length; i++) {
898             _rates[i] = rates[currencyKeys[i]];
899         }
900 
901         return _rates;
902     }
903 
904     /**
905      * @notice Retrieve a list of last update times for specific currencies
906      */
907     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
908         public
909         view
910         returns (uint)
911     {
912         return lastRateUpdateTimes[currencyKey];
913     }
914 
915     /**
916      * @notice Retrieve the last update time for a specific currency
917      */
918     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
919         public
920         view
921         returns (uint[])
922     {
923         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
924 
925         for (uint8 i = 0; i < currencyKeys.length; i++) {
926             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
927         }
928 
929         return lastUpdateTimes;
930     }
931 
932     /**
933      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
934      */
935     function rateIsStale(bytes4 currencyKey)
936         external
937         view
938         returns (bool)
939     {
940         // sUSD is a special case and is never stale.
941         if (currencyKey == "sUSD") return false;
942 
943         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
944     }
945 
946     /**
947      * @notice Check if any rate is frozen (cannot be exchanged into)
948      */
949     function rateIsFrozen(bytes4 currencyKey)
950         external
951         view
952         returns (bool)
953     {
954         return inversePricing[currencyKey].frozen;
955     }
956 
957 
958     /**
959      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
960      */
961     function anyRateIsStale(bytes4[] currencyKeys)
962         external
963         view
964         returns (bool)
965     {
966         // Loop through each key and check whether the data point is stale.
967         uint256 i = 0;
968 
969         while (i < currencyKeys.length) {
970             // sUSD is a special case and is never false
971             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
972                 return true;
973             }
974             i += 1;
975         }
976 
977         return false;
978     }
979 
980     /* ========== MODIFIERS ========== */
981 
982     modifier onlyOracle
983     {
984         require(msg.sender == oracle, "Only the oracle can perform this action");
985         _;
986     }
987 
988     /* ========== EVENTS ========== */
989 
990     event OracleUpdated(address newOracle);
991     event RateStalePeriodUpdated(uint rateStalePeriod);
992     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
993     event RateDeleted(bytes4 currencyKey);
994     event InversePriceConfigured(bytes4 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
995     event InversePriceFrozen(bytes4 currencyKey);
996 }
997 
