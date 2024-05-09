1 /* ===============================================
2 * Flattened with Solidifier by Coinage
3 * 
4 * https://solidifier.coina.ge
5 * ===============================================
6 */
7 
8 
9 /*
10 -----------------------------------------------------------------
11 FILE INFORMATION
12 -----------------------------------------------------------------
13 
14 file:       Owned.sol
15 version:    1.1
16 author:     Anton Jurisevic
17             Dominic Romanowski
18 
19 date:       2018-2-26
20 
21 -----------------------------------------------------------------
22 MODULE DESCRIPTION
23 -----------------------------------------------------------------
24 
25 An Owned contract, to be inherited by other contracts.
26 Requires its owner to be explicitly set in the constructor.
27 Provides an onlyOwner access modifier.
28 
29 To change owner, the current owner must nominate the next owner,
30 who then has to accept the nomination. The nomination can be
31 cancelled before it is accepted by the new owner by having the
32 previous owner change the nomination (setting it to 0).
33 
34 -----------------------------------------------------------------
35 */
36 
37 pragma solidity 0.4.25;
38 
39 /**
40  * @title A contract with an owner.
41  * @notice Contract ownership can be transferred by first nominating the new owner,
42  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
43  */
44 contract Owned {
45     address public owner;
46     address public nominatedOwner;
47 
48     /**
49      * @dev Owned Constructor
50      */
51     constructor(address _owner)
52         public
53     {
54         require(_owner != address(0), "Owner address cannot be 0");
55         owner = _owner;
56         emit OwnerChanged(address(0), _owner);
57     }
58 
59     /**
60      * @notice Nominate a new owner of this contract.
61      * @dev Only the current owner may nominate a new owner.
62      */
63     function nominateNewOwner(address _owner)
64         external
65         onlyOwner
66     {
67         nominatedOwner = _owner;
68         emit OwnerNominated(_owner);
69     }
70 
71     /**
72      * @notice Accept the nomination to be owner.
73      */
74     function acceptOwnership()
75         external
76     {
77         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
78         emit OwnerChanged(owner, nominatedOwner);
79         owner = nominatedOwner;
80         nominatedOwner = address(0);
81     }
82 
83     modifier onlyOwner
84     {
85         require(msg.sender == owner, "Only the contract owner may perform this action");
86         _;
87     }
88 
89     event OwnerNominated(address newOwner);
90     event OwnerChanged(address oldOwner, address newOwner);
91 }
92 
93 /*
94 -----------------------------------------------------------------
95 FILE INFORMATION
96 -----------------------------------------------------------------
97 
98 file:       SelfDestructible.sol
99 version:    1.2
100 author:     Anton Jurisevic
101 
102 date:       2018-05-29
103 
104 -----------------------------------------------------------------
105 MODULE DESCRIPTION
106 -----------------------------------------------------------------
107 
108 This contract allows an inheriting contract to be destroyed after
109 its owner indicates an intention and then waits for a period
110 without changing their mind. All ether contained in the contract
111 is forwarded to a nominated beneficiary upon destruction.
112 
113 -----------------------------------------------------------------
114 */
115 
116 
117 /**
118  * @title A contract that can be destroyed by its owner after a delay elapses.
119  */
120 contract SelfDestructible is Owned {
121     
122     uint public initiationTime;
123     bool public selfDestructInitiated;
124     address public selfDestructBeneficiary;
125     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
126 
127     /**
128      * @dev Constructor
129      * @param _owner The account which controls this contract.
130      */
131     constructor(address _owner)
132         Owned(_owner)
133         public
134     {
135         require(_owner != address(0), "Owner must not be the zero address");
136         selfDestructBeneficiary = _owner;
137         emit SelfDestructBeneficiaryUpdated(_owner);
138     }
139 
140     /**
141      * @notice Set the beneficiary address of this contract.
142      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
143      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
144      */
145     function setSelfDestructBeneficiary(address _beneficiary)
146         external
147         onlyOwner
148     {
149         require(_beneficiary != address(0), "Beneficiary must not be the zero address");
150         selfDestructBeneficiary = _beneficiary;
151         emit SelfDestructBeneficiaryUpdated(_beneficiary);
152     }
153 
154     /**
155      * @notice Begin the self-destruction counter of this contract.
156      * Once the delay has elapsed, the contract may be self-destructed.
157      * @dev Only the contract owner may call this.
158      */
159     function initiateSelfDestruct()
160         external
161         onlyOwner
162     {
163         initiationTime = now;
164         selfDestructInitiated = true;
165         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
166     }
167 
168     /**
169      * @notice Terminate and reset the self-destruction timer.
170      * @dev Only the contract owner may call this.
171      */
172     function terminateSelfDestruct()
173         external
174         onlyOwner
175     {
176         initiationTime = 0;
177         selfDestructInitiated = false;
178         emit SelfDestructTerminated();
179     }
180 
181     /**
182      * @notice If the self-destruction delay has elapsed, destroy this contract and
183      * remit any ether it owns to the beneficiary address.
184      * @dev Only the contract owner may call this.
185      */
186     function selfDestruct()
187         external
188         onlyOwner
189     {
190         require(selfDestructInitiated, "Self destruct has not yet been initiated");
191         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay has not yet elapsed");
192         address beneficiary = selfDestructBeneficiary;
193         emit SelfDestructed(beneficiary);
194         selfdestruct(beneficiary);
195     }
196 
197     event SelfDestructTerminated();
198     event SelfDestructed(address beneficiary);
199     event SelfDestructInitiated(uint selfDestructDelay);
200     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
201 }
202 
203 
204 /**
205  * @title SafeMath
206  * @dev Math operations with safety checks that revert on error
207  */
208 library SafeMath {
209 
210   /**
211   * @dev Multiplies two numbers, reverts on overflow.
212   */
213   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
214     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
215     // benefit is lost if 'b' is also tested.
216     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
217     if (a == 0) {
218       return 0;
219     }
220 
221     uint256 c = a * b;
222     require(c / a == b);
223 
224     return c;
225   }
226 
227   /**
228   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
229   */
230   function div(uint256 a, uint256 b) internal pure returns (uint256) {
231     require(b > 0); // Solidity only automatically asserts when dividing by 0
232     uint256 c = a / b;
233     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235     return c;
236   }
237 
238   /**
239   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
240   */
241   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242     require(b <= a);
243     uint256 c = a - b;
244 
245     return c;
246   }
247 
248   /**
249   * @dev Adds two numbers, reverts on overflow.
250   */
251   function add(uint256 a, uint256 b) internal pure returns (uint256) {
252     uint256 c = a + b;
253     require(c >= a);
254 
255     return c;
256   }
257 
258   /**
259   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
260   * reverts when dividing by zero.
261   */
262   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263     require(b != 0);
264     return a % b;
265   }
266 }
267 
268 
269 /*
270 
271 -----------------------------------------------------------------
272 FILE INFORMATION
273 -----------------------------------------------------------------
274 
275 file:       SafeDecimalMath.sol
276 version:    2.0
277 author:     Kevin Brown
278             Gavin Conway
279 date:       2018-10-18
280 
281 -----------------------------------------------------------------
282 MODULE DESCRIPTION
283 -----------------------------------------------------------------
284 
285 A library providing safe mathematical operations for division and
286 multiplication with the capability to round or truncate the results
287 to the nearest increment. Operations can return a standard precision
288 or high precision decimal. High precision decimals are useful for
289 example when attempting to calculate percentages or fractions
290 accurately.
291 
292 -----------------------------------------------------------------
293 */
294 
295 
296 /**
297  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
298  * @dev Functions accepting uints in this contract and derived contracts
299  * are taken to be such fixed point decimals of a specified precision (either standard
300  * or high).
301  */
302 library SafeDecimalMath {
303 
304     using SafeMath for uint;
305 
306     /* Number of decimal places in the representations. */
307     uint8 public constant decimals = 18;
308     uint8 public constant highPrecisionDecimals = 27;
309 
310     /* The number representing 1.0. */
311     uint public constant UNIT = 10 ** uint(decimals);
312 
313     /* The number representing 1.0 for higher fidelity numbers. */
314     uint public constant PRECISE_UNIT = 10 ** uint(highPrecisionDecimals);
315     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10 ** uint(highPrecisionDecimals - decimals);
316 
317     /** 
318      * @return Provides an interface to UNIT.
319      */
320     function unit()
321         external
322         pure
323         returns (uint)
324     {
325         return UNIT;
326     }
327 
328     /** 
329      * @return Provides an interface to PRECISE_UNIT.
330      */
331     function preciseUnit()
332         external
333         pure 
334         returns (uint)
335     {
336         return PRECISE_UNIT;
337     }
338 
339     /**
340      * @return The result of multiplying x and y, interpreting the operands as fixed-point
341      * decimals.
342      * 
343      * @dev A unit factor is divided out after the product of x and y is evaluated,
344      * so that product must be less than 2**256. As this is an integer division,
345      * the internal division always rounds down. This helps save on gas. Rounding
346      * is more expensive on gas.
347      */
348     function multiplyDecimal(uint x, uint y)
349         internal
350         pure
351         returns (uint)
352     {
353         /* Divide by UNIT to remove the extra factor introduced by the product. */
354         return x.mul(y) / UNIT;
355     }
356 
357     /**
358      * @return The result of safely multiplying x and y, interpreting the operands
359      * as fixed-point decimals of the specified precision unit.
360      *
361      * @dev The operands should be in the form of a the specified unit factor which will be
362      * divided out after the product of x and y is evaluated, so that product must be
363      * less than 2**256.
364      *
365      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
366      * Rounding is useful when you need to retain fidelity for small decimal numbers
367      * (eg. small fractions or percentages).
368      */
369     function _multiplyDecimalRound(uint x, uint y, uint precisionUnit)
370         private
371         pure
372         returns (uint)
373     {
374         /* Divide by UNIT to remove the extra factor introduced by the product. */
375         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
376 
377         if (quotientTimesTen % 10 >= 5) {
378             quotientTimesTen += 10;
379         }
380 
381         return quotientTimesTen / 10;
382     }
383 
384     /**
385      * @return The result of safely multiplying x and y, interpreting the operands
386      * as fixed-point decimals of a precise unit.
387      *
388      * @dev The operands should be in the precise unit factor which will be
389      * divided out after the product of x and y is evaluated, so that product must be
390      * less than 2**256.
391      *
392      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
393      * Rounding is useful when you need to retain fidelity for small decimal numbers
394      * (eg. small fractions or percentages).
395      */
396     function multiplyDecimalRoundPrecise(uint x, uint y)
397         internal
398         pure
399         returns (uint)
400     {
401         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
402     }
403 
404     /**
405      * @return The result of safely multiplying x and y, interpreting the operands
406      * as fixed-point decimals of a standard unit.
407      *
408      * @dev The operands should be in the standard unit factor which will be
409      * divided out after the product of x and y is evaluated, so that product must be
410      * less than 2**256.
411      *
412      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
413      * Rounding is useful when you need to retain fidelity for small decimal numbers
414      * (eg. small fractions or percentages).
415      */
416     function multiplyDecimalRound(uint x, uint y)
417         internal
418         pure
419         returns (uint)
420     {
421         return _multiplyDecimalRound(x, y, UNIT);
422     }
423 
424     /**
425      * @return The result of safely dividing x and y. The return value is a high
426      * precision decimal.
427      * 
428      * @dev y is divided after the product of x and the standard precision unit
429      * is evaluated, so the product of x and UNIT must be less than 2**256. As
430      * this is an integer division, the result is always rounded down.
431      * This helps save on gas. Rounding is more expensive on gas.
432      */
433     function divideDecimal(uint x, uint y)
434         internal
435         pure
436         returns (uint)
437     {
438         /* Reintroduce the UNIT factor that will be divided out by y. */
439         return x.mul(UNIT).div(y);
440     }
441 
442     /**
443      * @return The result of safely dividing x and y. The return value is as a rounded
444      * decimal in the precision unit specified in the parameter.
445      *
446      * @dev y is divided after the product of x and the specified precision unit
447      * is evaluated, so the product of x and the specified precision unit must
448      * be less than 2**256. The result is rounded to the nearest increment.
449      */
450     function _divideDecimalRound(uint x, uint y, uint precisionUnit)
451         private
452         pure
453         returns (uint)
454     {
455         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
456 
457         if (resultTimesTen % 10 >= 5) {
458             resultTimesTen += 10;
459         }
460 
461         return resultTimesTen / 10;
462     }
463 
464     /**
465      * @return The result of safely dividing x and y. The return value is as a rounded
466      * standard precision decimal.
467      *
468      * @dev y is divided after the product of x and the standard precision unit
469      * is evaluated, so the product of x and the standard precision unit must
470      * be less than 2**256. The result is rounded to the nearest increment.
471      */
472     function divideDecimalRound(uint x, uint y)
473         internal
474         pure
475         returns (uint)
476     {
477         return _divideDecimalRound(x, y, UNIT);
478     }
479 
480     /**
481      * @return The result of safely dividing x and y. The return value is as a rounded
482      * high precision decimal.
483      *
484      * @dev y is divided after the product of x and the high precision unit
485      * is evaluated, so the product of x and the high precision unit must
486      * be less than 2**256. The result is rounded to the nearest increment.
487      */
488     function divideDecimalRoundPrecise(uint x, uint y)
489         internal
490         pure
491         returns (uint)
492     {
493         return _divideDecimalRound(x, y, PRECISE_UNIT);
494     }
495 
496     /**
497      * @dev Convert a standard decimal representation to a high precision one.
498      */
499     function decimalToPreciseDecimal(uint i)
500         internal
501         pure
502         returns (uint)
503     {
504         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
505     }
506 
507     /**
508      * @dev Convert a high precision decimal to a standard decimal representation.
509      */
510     function preciseDecimalToDecimal(uint i)
511         internal
512         pure
513         returns (uint)
514     {
515         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
516 
517         if (quotientTimesTen % 10 >= 5) {
518             quotientTimesTen += 10;
519         }
520 
521         return quotientTimesTen / 10;
522     }
523 
524 }
525 
526 
527 /*
528 -----------------------------------------------------------------
529 FILE INFORMATION
530 -----------------------------------------------------------------
531 
532 file:       LimitedSetup.sol
533 version:    1.1
534 author:     Anton Jurisevic
535 
536 date:       2018-05-15
537 
538 -----------------------------------------------------------------
539 MODULE DESCRIPTION
540 -----------------------------------------------------------------
541 
542 A contract with a limited setup period. Any function modified
543 with the setup modifier will cease to work after the
544 conclusion of the configurable-length post-construction setup period.
545 
546 -----------------------------------------------------------------
547 */
548 
549 
550 /**
551  * @title Any function decorated with the modifier this contract provides
552  * deactivates after a specified setup period.
553  */
554 contract LimitedSetup {
555 
556     uint setupExpiryTime;
557 
558     /**
559      * @dev LimitedSetup Constructor.
560      * @param setupDuration The time the setup period will last for.
561      */
562     constructor(uint setupDuration)
563         public
564     {
565         setupExpiryTime = now + setupDuration;
566     }
567 
568     modifier onlyDuringSetup
569     {
570         require(now < setupExpiryTime, "Can only perform this action during setup");
571         _;
572     }
573 }
574 
575 
576 contract IFeePool {
577     address public FEE_ADDRESS;
578     function amountReceivedFromExchange(uint value) external view returns (uint);
579     function amountReceivedFromTransfer(uint value) external view returns (uint);
580     function feePaid(bytes4 currencyKey, uint amount) external;
581     function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
582     function rewardsMinted(uint amount) external;
583     function transferFeeIncurred(uint value) public view returns (uint);
584 }
585 
586 
587 /*
588 -----------------------------------------------------------------
589 FILE INFORMATION
590 -----------------------------------------------------------------
591 
592 file:       FeePoolState.sol
593 version:    1.0
594 author:     Clinton Ennis
595             Jackson Chan
596 date:       2019-04-05
597 
598 -----------------------------------------------------------------
599 MODULE DESCRIPTION
600 -----------------------------------------------------------------
601 
602 The FeePoolState simply stores the accounts issuance ratio for 
603 each fee period in the FeePool.
604 
605 This is use to caclulate the correct allocation of fees/rewards 
606 owed to minters of the stablecoin total supply
607 
608 -----------------------------------------------------------------
609 */
610 
611 
612 contract FeePoolState is SelfDestructible, LimitedSetup {
613     using SafeMath for uint;
614     using SafeDecimalMath for uint;
615 
616     /* ========== STATE VARIABLES ========== */
617 
618     uint8 constant public FEE_PERIOD_LENGTH = 6;
619 
620     address public feePool;
621 
622     // The IssuanceData activity that's happened in a fee period.
623     struct IssuanceData {
624         uint debtPercentage;
625         uint debtEntryIndex;
626     }
627 
628     // The IssuanceData activity that's happened in a fee period.
629     mapping(address => IssuanceData[FEE_PERIOD_LENGTH]) public accountIssuanceLedger;
630 
631     /**
632      * @dev Constructor.
633      * @param _owner The owner of this contract.
634      */
635     constructor(address _owner, IFeePool _feePool)
636         SelfDestructible(_owner)
637         LimitedSetup(6 weeks)
638         public
639     {
640         feePool = _feePool;
641     }
642 
643     /* ========== SETTERS ========== */
644 
645     /**
646      * @notice set the FeePool contract as it is the only authority to be able to call 
647      * appendAccountIssuanceRecord with the onlyFeePool modifer
648      * @dev Must be set by owner when FeePool logic is upgraded
649      */
650     function setFeePool(IFeePool _feePool)
651         external
652         onlyOwner
653     {
654         feePool = _feePool;
655     }
656 
657     /* ========== VIEWS ========== */
658 
659     /**
660      * @notice Get an accounts issuanceData for 
661      * @param account users account
662      * @param index Index in the array to retrieve. Upto FEE_PERIOD_LENGTH 
663      */
664     function getAccountsDebtEntry(address account, uint index)
665         public
666         view
667         returns (uint debtPercentage, uint debtEntryIndex)
668     {
669         require(index < FEE_PERIOD_LENGTH, "index exceeds the FEE_PERIOD_LENGTH");
670 
671         debtPercentage = accountIssuanceLedger[account][index].debtPercentage;
672         debtEntryIndex = accountIssuanceLedger[account][index].debtEntryIndex;
673     }
674 
675     /**
676      * @notice Find the oldest debtEntryIndex for the corresponding closingDebtIndex
677      * @param account users account
678      * @param closingDebtIndex the last periods debt index on close
679      */
680     function applicableIssuanceData(address account, uint closingDebtIndex)
681         external
682         view
683         returns (uint, uint)
684     {
685         IssuanceData[FEE_PERIOD_LENGTH] memory issuanceData = accountIssuanceLedger[account];
686         
687         // We want to use the user's debtEntryIndex at when the period closed
688         // Find the oldest debtEntryIndex for the corresponding closingDebtIndex
689         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
690             if (closingDebtIndex >= issuanceData[i].debtEntryIndex) {
691                 return (issuanceData[i].debtPercentage, issuanceData[i].debtEntryIndex);
692             }
693         }
694     }
695 
696     /* ========== MUTATIVE FUNCTIONS ========== */
697 
698     /**
699      * @notice Logs an accounts issuance data in the current fee period which is then stored historically
700      * @param account Message.Senders account address
701      * @param debtRatio Debt percentage this account has locked after minting or burning their synth
702      * @param debtEntryIndex The index in the global debt ledger. synthetix.synthetixState().issuanceData(account)
703      * @param currentPeriodStartDebtIndex The startingDebtIndex of the current fee period
704      * @dev onlyFeePool to call me on synthetix.issue() & synthetix.burn() calls to store the locked SNX 
705      * per fee period so we know to allocate the correct proportions of fees and rewards per period
706       accountIssuanceLedger[account][0] has the latest locked amount for the current period. This can be update as many time
707       accountIssuanceLedger[account][1-3] has the last locked amount for a previous period they minted or burned
708      */
709     function appendAccountIssuanceRecord(address account, uint debtRatio, uint debtEntryIndex, uint currentPeriodStartDebtIndex) 
710         external
711         onlyFeePool
712     {
713         // Is the current debtEntryIndex within this fee period 
714         if (accountIssuanceLedger[account][0].debtEntryIndex < currentPeriodStartDebtIndex) {
715              // If its older then shift the previous IssuanceData entries periods down to make room for the new one.
716             issuanceDataIndexOrder(account);            
717         }
718         
719         // Always store the latest IssuanceData entry at [0]
720         accountIssuanceLedger[account][0].debtPercentage = debtRatio;
721         accountIssuanceLedger[account][0].debtEntryIndex = debtEntryIndex;
722     }
723 
724     /**
725      * @notice Pushes down the entire array of debt ratios per fee period
726      */
727     function issuanceDataIndexOrder(address account) 
728         private 
729     {
730         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
731             uint next = i + 1;
732             accountIssuanceLedger[account][next].debtPercentage = accountIssuanceLedger[account][i].debtPercentage;
733             accountIssuanceLedger[account][next].debtEntryIndex = accountIssuanceLedger[account][i].debtEntryIndex;
734         }    
735     }
736 
737     /**
738      * @notice Import issuer data from synthetixState.issuerData on FeePeriodClose() block #
739      * @dev Only callable by the contract owner, and only for 6 weeks after deployment.
740      * @param accounts Array of issuing addresses
741      * @param ratios Array of debt ratios
742      * @param periodToInsert The Fee Period to insert the historical records into
743      * @param feePeriodCloseIndex An accounts debtEntryIndex is valid when within the fee peroid,
744      * since the input ratio will be an average of the pervious periods it just needs to be 
745      * > recentFeePeriods[periodToInsert].startingDebtIndex 
746      * < recentFeePeriods[periodToInsert - 1].startingDebtIndex 
747      */
748     function importIssuerData(address[] accounts, uint[] ratios, uint periodToInsert, uint feePeriodCloseIndex)
749         external
750         onlyOwner
751         onlyDuringSetup
752     {
753         require(accounts.length == ratios.length, "Length mismatch");
754 
755         for (uint8 i = 0; i < accounts.length; i++) {
756             accountIssuanceLedger[accounts[i]][periodToInsert].debtPercentage = ratios[i];
757             accountIssuanceLedger[accounts[i]][periodToInsert].debtEntryIndex = feePeriodCloseIndex;
758             emit IssuanceDebtRatioEntry(accounts[i], ratios[i], feePeriodCloseIndex);
759         }
760     }
761 
762     /* ========== MODIFIERS ========== */
763 
764     modifier onlyFeePool
765     {
766         require(msg.sender == address(feePool), "Only the FeePool contract can perform this action");
767         _;
768     }
769 
770     /* ========== Events ========== */
771     event IssuanceDebtRatioEntry(address indexed account, uint debtRatio, uint feePeriodCloseIndex);
772 }
773 
