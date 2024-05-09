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
417 
418 contract IFeePool {
419     address public FEE_ADDRESS;
420     function amountReceivedFromExchange(uint value) external view returns (uint);
421     function amountReceivedFromTransfer(uint value) external view returns (uint);
422     function feePaid(bytes4 currencyKey, uint amount) external;
423     function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
424     function rewardsMinted(uint amount) external;
425     function transferFeeIncurred(uint value) public view returns (uint);
426 }
427 
428 
429 contract ISynthetixState {
430     // A struct for handing values associated with an individual user's debt position
431     struct IssuanceData {
432         // Percentage of the total debt owned at the time
433         // of issuance. This number is modified by the global debt
434         // delta array. You can figure out a user's exit price and
435         // collateralisation ratio using a combination of their initial
436         // debt and the slice of global debt delta which applies to them.
437         uint initialDebtOwnership;
438         // This lets us know when (in relative terms) the user entered
439         // the debt pool so we can calculate their exit price and
440         // collateralistion ratio
441         uint debtEntryIndex;
442     }
443 
444     uint[] public debtLedger;
445     uint public issuanceRatio;
446     mapping(address => IssuanceData) public issuanceData;
447 
448     function debtLedgerLength() external view returns (uint);
449     function hasIssued(address account) external view returns (bool);
450     function incrementTotalIssuerCount() external;
451     function decrementTotalIssuerCount() external;
452     function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
453     function lastDebtLedgerEntry() external view returns (uint);
454     function appendDebtLedgerValue(uint value) external;
455     function clearIssuanceData(address account) external;
456 }
457 
458 
459 interface ISynth {
460   function burn(address account, uint amount) external;
461   function issue(address account, uint amount) external;
462   function transfer(address to, uint value) public returns (bool);
463   function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount) external;
464   function transferFrom(address from, address to, uint value) public returns (bool);
465 }
466 
467 
468 /**
469  * @title SynthetixEscrow interface
470  */
471 interface ISynthetixEscrow {
472     function balanceOf(address account) public view returns (uint);
473     function appendVestingEntry(address account, uint quantity) public;
474 }
475 
476 
477 /**
478  * @title ExchangeRates interface
479  */
480 interface IExchangeRates {
481     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey) public view returns (uint);
482 
483     function rateForCurrency(bytes4 currencyKey) public view returns (uint);
484 
485     function anyRateIsStale(bytes4[] currencyKeys) external view returns (bool);
486 
487     function rateIsStale(bytes4 currencyKey) external view returns (bool);
488 }
489 
490 
491 /**
492  * @title Synthetix interface contract
493  * @dev pseudo interface, actually declared as contract to hold the public getters 
494  */
495 
496 
497 contract ISynthetix {
498 
499     // ========== PUBLIC STATE VARIABLES ==========
500 
501     IFeePool public feePool;
502     ISynthetixEscrow public escrow;
503     ISynthetixEscrow public rewardEscrow;
504     ISynthetixState public synthetixState;
505     IExchangeRates public exchangeRates;
506 
507     // ========== PUBLIC FUNCTIONS ==========
508 
509     function balanceOf(address account) public view returns (uint);
510     function transfer(address to, uint value) public returns (bool);
511     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey) public view returns (uint);
512 
513     function synthInitiatedFeePayment(address from, bytes4 sourceCurrencyKey, uint sourceAmount) external returns (bool);
514     function synthInitiatedExchange(
515         address from,
516         bytes4 sourceCurrencyKey,
517         uint sourceAmount,
518         bytes4 destinationCurrencyKey,
519         address destinationAddress) external returns (bool);
520     function collateralisationRatio(address issuer) public view returns (uint);
521     function totalIssuedSynths(bytes4 currencyKey)
522         public
523         view
524         returns (uint);
525     function getSynth(bytes4 currencyKey) public view returns (ISynth);
526     function debtBalanceOf(address issuer, bytes4 currencyKey) public view returns (uint);
527 }
528 
529 
530 /*
531 -----------------------------------------------------------------
532 FILE INFORMATION
533 -----------------------------------------------------------------
534 
535 file:       RewardEscrow.sol
536 version:    1.0
537 author:     Jackson Chan
538             Clinton Ennis
539 
540 date:       2019-03-01
541 
542 -----------------------------------------------------------------
543 MODULE DESCRIPTION
544 -----------------------------------------------------------------
545 Escrows the SNX rewards from the inflationary supply awarded to
546 users for staking their SNX and maintaining the c-rationn target.
547 
548 SNW rewards are escrowed for 1 year from the claim date and users
549 can call vest in 12 months time.
550 -----------------------------------------------------------------
551 */
552 
553 
554 /**
555  * @title A contract to hold escrowed SNX and free them at given schedules.
556  */
557 contract RewardEscrow is Owned {
558 
559     using SafeMath for uint;
560 
561     /* The corresponding Synthetix contract. */
562     ISynthetix public synthetix;
563 
564     IFeePool public feePool;
565 
566     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
567      * These are the times at which each given quantity of SNX vests. */
568     mapping(address => uint[2][]) public vestingSchedules;
569 
570     /* An account's total escrowed synthetix balance to save recomputing this for fee extraction purposes. */
571     mapping(address => uint) public totalEscrowedAccountBalance;
572 
573     /* An account's total vested reward synthetix. */
574     mapping(address => uint) public totalVestedAccountBalance;
575 
576     /* The total remaining escrowed balance, for verifying the actual synthetix balance of this contract against. */
577     uint public totalEscrowedBalance;
578 
579     uint constant TIME_INDEX = 0;
580     uint constant QUANTITY_INDEX = 1;
581 
582     /* Limit vesting entries to disallow unbounded iteration over vesting schedules.
583     * There are 5 years of the supply scedule */
584     uint constant public MAX_VESTING_ENTRIES = 52*5;
585 
586 
587     /* ========== CONSTRUCTOR ========== */
588 
589     constructor(address _owner, ISynthetix _synthetix, IFeePool _feePool)
590     Owned(_owner)
591     public
592     {
593         synthetix = _synthetix;
594         feePool = _feePool;
595     }
596 
597 
598     /* ========== SETTERS ========== */
599 
600     /**
601      * @notice set the synthetix contract address as we need to transfer SNX when the user vests
602      */
603     function setSynthetix(ISynthetix _synthetix)
604     external
605     onlyOwner
606     {
607         synthetix = _synthetix;
608         emit SynthetixUpdated(_synthetix);
609     }
610 
611     /**
612      * @notice set the FeePool contract as it is the only authority to be able to call
613      * appendVestingEntry with the onlyFeePool modifer
614      */
615     function setFeePool(IFeePool _feePool)
616         external
617         onlyOwner
618     {
619         feePool = _feePool;
620         emit FeePoolUpdated(_feePool);
621     }
622 
623 
624     /* ========== VIEW FUNCTIONS ========== */
625 
626     /**
627      * @notice A simple alias to totalEscrowedAccountBalance: provides ERC20 balance integration.
628      */
629     function balanceOf(address account)
630     public
631     view
632     returns (uint)
633     {
634         return totalEscrowedAccountBalance[account];
635     }
636 
637     /**
638      * @notice The number of vesting dates in an account's schedule.
639      */
640     function numVestingEntries(address account)
641     public
642     view
643     returns (uint)
644     {
645         return vestingSchedules[account].length;
646     }
647 
648     /**
649      * @notice Get a particular schedule entry for an account.
650      * @return A pair of uints: (timestamp, synthetix quantity).
651      */
652     function getVestingScheduleEntry(address account, uint index)
653     public
654     view
655     returns (uint[2])
656     {
657         return vestingSchedules[account][index];
658     }
659 
660     /**
661      * @notice Get the time at which a given schedule entry will vest.
662      */
663     function getVestingTime(address account, uint index)
664     public
665     view
666     returns (uint)
667     {
668         return getVestingScheduleEntry(account,index)[TIME_INDEX];
669     }
670 
671     /**
672      * @notice Get the quantity of SNX associated with a given schedule entry.
673      */
674     function getVestingQuantity(address account, uint index)
675     public
676     view
677     returns (uint)
678     {
679         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
680     }
681 
682     /**
683      * @notice Obtain the index of the next schedule entry that will vest for a given user.
684      */
685     function getNextVestingIndex(address account)
686     public
687     view
688     returns (uint)
689     {
690         uint len = numVestingEntries(account);
691         for (uint i = 0; i < len; i++) {
692             if (getVestingTime(account, i) != 0) {
693                 return i;
694             }
695         }
696         return len;
697     }
698 
699     /**
700      * @notice Obtain the next schedule entry that will vest for a given user.
701      * @return A pair of uints: (timestamp, synthetix quantity). */
702     function getNextVestingEntry(address account)
703     public
704     view
705     returns (uint[2])
706     {
707         uint index = getNextVestingIndex(account);
708         if (index == numVestingEntries(account)) {
709             return [uint(0), 0];
710         }
711         return getVestingScheduleEntry(account, index);
712     }
713 
714     /**
715      * @notice Obtain the time at which the next schedule entry will vest for a given user.
716      */
717     function getNextVestingTime(address account)
718     external
719     view
720     returns (uint)
721     {
722         return getNextVestingEntry(account)[TIME_INDEX];
723     }
724 
725     /**
726      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
727      */
728     function getNextVestingQuantity(address account)
729     external
730     view
731     returns (uint)
732     {
733         return getNextVestingEntry(account)[QUANTITY_INDEX];
734     }
735 
736     /**
737      * @notice return the full vesting schedule entries vest for a given user.
738      */
739     function checkAccountSchedule(address account)
740         public
741         view
742         returns (uint[520])
743     {
744         uint[520] memory _result;
745         uint schedules = numVestingEntries(account);
746         for (uint i = 0; i < schedules; i++) {
747             uint[2] memory pair = getVestingScheduleEntry(account, i);
748             _result[i*2] = pair[0];
749             _result[i*2 + 1] = pair[1];
750         }
751         return _result;
752     }
753 
754 
755     /* ========== MUTATIVE FUNCTIONS ========== */
756 
757     /**
758      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
759      * @dev A call to this should accompany a previous successfull call to synthetix.transfer(tewardEscrow, amount),
760      * to ensure that when the funds are withdrawn, there is enough balance.
761      * Note; although this function could technically be used to produce unbounded
762      * arrays, it's only withinn the 4 year period of the weekly inflation schedule.
763      * @param account The account to append a new vesting entry to.
764      * @param quantity The quantity of SNX that will be escrowed.
765      */
766     function appendVestingEntry(address account, uint quantity)
767     public
768     onlyFeePool
769     {
770         /* No empty or already-passed vesting entries allowed. */
771         require(quantity != 0, "Quantity cannot be zero");
772 
773         /* There must be enough balance in the contract to provide for the vesting entry. */
774         totalEscrowedBalance = totalEscrowedBalance.add(quantity);
775         require(totalEscrowedBalance <= synthetix.balanceOf(this), "Must be enough balance in the contract to provide for the vesting entry");
776 
777         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
778         uint scheduleLength = vestingSchedules[account].length;
779         require(scheduleLength <= MAX_VESTING_ENTRIES, "Vesting schedule is too long");
780 
781         /* Escrow the tokens for 1 year. */
782         uint time = now + 52 weeks;
783 
784         if (scheduleLength == 0) {
785             totalEscrowedAccountBalance[account] = quantity;
786         } else {
787             /* Disallow adding new vested SNX earlier than the last one.
788              * Since entries are only appended, this means that no vesting date can be repeated. */
789             require(getVestingTime(account, numVestingEntries(account) - 1) < time, "Cannot add new vested entries earlier than the last one");
790             totalEscrowedAccountBalance[account] = totalEscrowedAccountBalance[account].add(quantity);
791         }
792 
793         vestingSchedules[account].push([time, quantity]);
794 
795         emit VestingEntryCreated(account, now, quantity);
796     }
797 
798     /**
799      * @notice Allow a user to withdraw any SNX in their schedule that have vested.
800      */
801     function vest()
802     external
803     {
804         uint numEntries = numVestingEntries(msg.sender);
805         uint total;
806         for (uint i = 0; i < numEntries; i++) {
807             uint time = getVestingTime(msg.sender, i);
808             /* The list is sorted; when we reach the first future time, bail out. */
809             if (time > now) {
810                 break;
811             }
812             uint qty = getVestingQuantity(msg.sender, i);
813             if (qty == 0) {
814                 continue;
815             }
816 
817             vestingSchedules[msg.sender][i] = [0, 0];
818             total = total.add(qty);
819         }
820 
821         if (total != 0) {
822             totalEscrowedBalance = totalEscrowedBalance.sub(total);
823             totalEscrowedAccountBalance[msg.sender] = totalEscrowedAccountBalance[msg.sender].sub(total);
824             totalVestedAccountBalance[msg.sender] = totalVestedAccountBalance[msg.sender].add(total);
825             synthetix.transfer(msg.sender, total);
826             emit Vested(msg.sender, now, total);
827         }
828     }
829 
830     /* ========== MODIFIERS ========== */
831 
832     modifier onlyFeePool() {
833         bool isFeePool = msg.sender == address(feePool);
834 
835         require(isFeePool, "Only the FeePool contracts can perform this action");
836         _;
837     }
838 
839 
840     /* ========== EVENTS ========== */
841 
842     event SynthetixUpdated(address newSynthetix);
843 
844     event FeePoolUpdated(address newFeePool);
845 
846     event Vested(address indexed beneficiary, uint time, uint value);
847 
848     event VestingEntryCreated(address indexed beneficiary, uint time, uint value);
849 
850 }
851 
