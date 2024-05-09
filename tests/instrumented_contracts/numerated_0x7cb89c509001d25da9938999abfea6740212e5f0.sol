1 /*
2 * Synthetix - Synthetix.sol
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
557 /*
558 -----------------------------------------------------------------
559 FILE INFORMATION
560 -----------------------------------------------------------------
561 
562 file:       State.sol
563 version:    1.1
564 author:     Dominic Romanowski
565             Anton Jurisevic
566 
567 date:       2018-05-15
568 
569 -----------------------------------------------------------------
570 MODULE DESCRIPTION
571 -----------------------------------------------------------------
572 
573 This contract is used side by side with external state token
574 contracts, such as Synthetix and Synth.
575 It provides an easy way to upgrade contract logic while
576 maintaining all user balances and allowances. This is designed
577 to make the changeover as easy as possible, since mappings
578 are not so cheap or straightforward to migrate.
579 
580 The first deployed contract would create this state contract,
581 using it as its store of balances.
582 When a new contract is deployed, it links to the existing
583 state contract, whose owner would then change its associated
584 contract to the new one.
585 
586 -----------------------------------------------------------------
587 */
588 
589 
590 contract State is Owned {
591     // the address of the contract that can modify variables
592     // this can only be changed by the owner of this contract
593     address public associatedContract;
594 
595 
596     constructor(address _owner, address _associatedContract)
597         Owned(_owner)
598         public
599     {
600         associatedContract = _associatedContract;
601         emit AssociatedContractUpdated(_associatedContract);
602     }
603 
604     /* ========== SETTERS ========== */
605 
606     // Change the associated contract to a new address
607     function setAssociatedContract(address _associatedContract)
608         external
609         onlyOwner
610     {
611         associatedContract = _associatedContract;
612         emit AssociatedContractUpdated(_associatedContract);
613     }
614 
615     /* ========== MODIFIERS ========== */
616 
617     modifier onlyAssociatedContract
618     {
619         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
620         _;
621     }
622 
623     /* ========== EVENTS ========== */
624 
625     event AssociatedContractUpdated(address associatedContract);
626 }
627 
628 
629 /*
630 -----------------------------------------------------------------
631 FILE INFORMATION
632 -----------------------------------------------------------------
633 
634 file:       TokenState.sol
635 version:    1.1
636 author:     Dominic Romanowski
637             Anton Jurisevic
638 
639 date:       2018-05-15
640 
641 -----------------------------------------------------------------
642 MODULE DESCRIPTION
643 -----------------------------------------------------------------
644 
645 A contract that holds the state of an ERC20 compliant token.
646 
647 This contract is used side by side with external state token
648 contracts, such as Synthetix and Synth.
649 It provides an easy way to upgrade contract logic while
650 maintaining all user balances and allowances. This is designed
651 to make the changeover as easy as possible, since mappings
652 are not so cheap or straightforward to migrate.
653 
654 The first deployed contract would create this state contract,
655 using it as its store of balances.
656 When a new contract is deployed, it links to the existing
657 state contract, whose owner would then change its associated
658 contract to the new one.
659 
660 -----------------------------------------------------------------
661 */
662 
663 
664 /**
665  * @title ERC20 Token State
666  * @notice Stores balance information of an ERC20 token contract.
667  */
668 contract TokenState is State {
669 
670     /* ERC20 fields. */
671     mapping(address => uint) public balanceOf;
672     mapping(address => mapping(address => uint)) public allowance;
673 
674     /**
675      * @dev Constructor
676      * @param _owner The address which controls this contract.
677      * @param _associatedContract The ERC20 contract whose state this composes.
678      */
679     constructor(address _owner, address _associatedContract)
680         State(_owner, _associatedContract)
681         public
682     {}
683 
684     /* ========== SETTERS ========== */
685 
686     /**
687      * @notice Set ERC20 allowance.
688      * @dev Only the associated contract may call this.
689      * @param tokenOwner The authorising party.
690      * @param spender The authorised party.
691      * @param value The total value the authorised party may spend on the
692      * authorising party's behalf.
693      */
694     function setAllowance(address tokenOwner, address spender, uint value)
695         external
696         onlyAssociatedContract
697     {
698         allowance[tokenOwner][spender] = value;
699     }
700 
701     /**
702      * @notice Set the balance in a given account
703      * @dev Only the associated contract may call this.
704      * @param account The account whose value to set.
705      * @param value The new balance of the given account.
706      */
707     function setBalanceOf(address account, uint value)
708         external
709         onlyAssociatedContract
710     {
711         balanceOf[account] = value;
712     }
713 }
714 
715 
716 /*
717 -----------------------------------------------------------------
718 FILE INFORMATION
719 -----------------------------------------------------------------
720 
721 file:       Proxy.sol
722 version:    1.3
723 author:     Anton Jurisevic
724 
725 date:       2018-05-29
726 
727 -----------------------------------------------------------------
728 MODULE DESCRIPTION
729 -----------------------------------------------------------------
730 
731 A proxy contract that, if it does not recognise the function
732 being called on it, passes all value and call data to an
733 underlying target contract.
734 
735 This proxy has the capacity to toggle between DELEGATECALL
736 and CALL style proxy functionality.
737 
738 The former executes in the proxy's context, and so will preserve 
739 msg.sender and store data at the proxy address. The latter will not.
740 Therefore, any contract the proxy wraps in the CALL style must
741 implement the Proxyable interface, in order that it can pass msg.sender
742 into the underlying contract as the state parameter, messageSender.
743 
744 -----------------------------------------------------------------
745 */
746 
747 
748 contract Proxy is Owned {
749 
750     Proxyable public target;
751     bool public useDELEGATECALL;
752 
753     constructor(address _owner)
754         Owned(_owner)
755         public
756     {}
757 
758     function setTarget(Proxyable _target)
759         external
760         onlyOwner
761     {
762         target = _target;
763         emit TargetUpdated(_target);
764     }
765 
766     function setUseDELEGATECALL(bool value) 
767         external
768         onlyOwner
769     {
770         useDELEGATECALL = value;
771     }
772 
773     function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)
774         external
775         onlyTarget
776     {
777         uint size = callData.length;
778         bytes memory _callData = callData;
779 
780         assembly {
781             /* The first 32 bytes of callData contain its length (as specified by the abi). 
782              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
783              * in length. It is also leftpadded to be a multiple of 32 bytes.
784              * This means moving call_data across 32 bytes guarantees we correctly access
785              * the data itself. */
786             switch numTopics
787             case 0 {
788                 log0(add(_callData, 32), size)
789             } 
790             case 1 {
791                 log1(add(_callData, 32), size, topic1)
792             }
793             case 2 {
794                 log2(add(_callData, 32), size, topic1, topic2)
795             }
796             case 3 {
797                 log3(add(_callData, 32), size, topic1, topic2, topic3)
798             }
799             case 4 {
800                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
801             }
802         }
803     }
804 
805     function()
806         external
807         payable
808     {
809         if (useDELEGATECALL) {
810             assembly {
811                 /* Copy call data into free memory region. */
812                 let free_ptr := mload(0x40)
813                 calldatacopy(free_ptr, 0, calldatasize)
814 
815                 /* Forward all gas and call data to the target contract. */
816                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
817                 returndatacopy(free_ptr, 0, returndatasize)
818 
819                 /* Revert if the call failed, otherwise return the result. */
820                 if iszero(result) { revert(free_ptr, returndatasize) }
821                 return(free_ptr, returndatasize)
822             }
823         } else {
824             /* Here we are as above, but must send the messageSender explicitly 
825              * since we are using CALL rather than DELEGATECALL. */
826             target.setMessageSender(msg.sender);
827             assembly {
828                 let free_ptr := mload(0x40)
829                 calldatacopy(free_ptr, 0, calldatasize)
830 
831                 /* We must explicitly forward ether to the underlying contract as well. */
832                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
833                 returndatacopy(free_ptr, 0, returndatasize)
834 
835                 if iszero(result) { revert(free_ptr, returndatasize) }
836                 return(free_ptr, returndatasize)
837             }
838         }
839     }
840 
841     modifier onlyTarget {
842         require(Proxyable(msg.sender) == target, "Must be proxy target");
843         _;
844     }
845 
846     event TargetUpdated(Proxyable newTarget);
847 }
848 
849 
850 /*
851 -----------------------------------------------------------------
852 FILE INFORMATION
853 -----------------------------------------------------------------
854 
855 file:       Proxyable.sol
856 version:    1.1
857 author:     Anton Jurisevic
858 
859 date:       2018-05-15
860 
861 checked:    Mike Spain
862 approved:   Samuel Brooks
863 
864 -----------------------------------------------------------------
865 MODULE DESCRIPTION
866 -----------------------------------------------------------------
867 
868 A proxyable contract that works hand in hand with the Proxy contract
869 to allow for anyone to interact with the underlying contract both
870 directly and through the proxy.
871 
872 -----------------------------------------------------------------
873 */
874 
875 
876 // This contract should be treated like an abstract contract
877 contract Proxyable is Owned {
878     /* The proxy this contract exists behind. */
879     Proxy public proxy;
880     Proxy public integrationProxy;
881 
882     /* The caller of the proxy, passed through to this contract.
883      * Note that every function using this member must apply the onlyProxy or
884      * optionalProxy modifiers, otherwise their invocations can use stale values. */
885     address public messageSender;
886 
887     constructor(address _proxy, address _owner)
888         Owned(_owner)
889         public
890     {
891         proxy = Proxy(_proxy);
892         emit ProxyUpdated(_proxy);
893     }
894 
895     function setProxy(address _proxy)
896         external
897         onlyOwner
898     {
899         proxy = Proxy(_proxy);
900         emit ProxyUpdated(_proxy);
901     }
902 
903     function setIntegrationProxy(address _integrationProxy)
904         external
905         onlyOwner
906     {
907         integrationProxy = Proxy(_integrationProxy);
908     }
909 
910     function setMessageSender(address sender)
911         external
912         onlyProxy
913     {
914         messageSender = sender;
915     }
916 
917     modifier onlyProxy {
918         require(Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy, "Only the proxy can call");
919         _;
920     }
921 
922     modifier optionalProxy
923     {
924         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
925             messageSender = msg.sender;
926         }
927         _;
928     }
929 
930     modifier optionalProxy_onlyOwner
931     {
932         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
933             messageSender = msg.sender;
934         }
935         require(messageSender == owner, "Owner only function");
936         _;
937     }
938 
939     event ProxyUpdated(address proxyAddress);
940 }
941 
942 
943 /*
944 -----------------------------------------------------------------
945 FILE INFORMATION
946 -----------------------------------------------------------------
947 
948 file:       ExternStateToken.sol
949 version:    1.3
950 author:     Anton Jurisevic
951             Dominic Romanowski
952             Kevin Brown
953 
954 date:       2018-05-29
955 
956 -----------------------------------------------------------------
957 MODULE DESCRIPTION
958 -----------------------------------------------------------------
959 
960 A partial ERC20 token contract, designed to operate with a proxy.
961 To produce a complete ERC20 token, transfer and transferFrom
962 tokens must be implemented, using the provided _byProxy internal
963 functions.
964 This contract utilises an external state for upgradeability.
965 
966 -----------------------------------------------------------------
967 */
968 
969 
970 /**
971  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
972  */
973 contract ExternStateToken is SelfDestructible, Proxyable {
974 
975     using SafeMath for uint;
976     using SafeDecimalMath for uint;
977 
978     /* ========== STATE VARIABLES ========== */
979 
980     /* Stores balances and allowances. */
981     TokenState public tokenState;
982 
983     /* Other ERC20 fields. */
984     string public name;
985     string public symbol;
986     uint public totalSupply;
987     uint8 public decimals;
988 
989     /**
990      * @dev Constructor.
991      * @param _proxy The proxy associated with this contract.
992      * @param _name Token's ERC20 name.
993      * @param _symbol Token's ERC20 symbol.
994      * @param _totalSupply The total supply of the token.
995      * @param _tokenState The TokenState contract address.
996      * @param _owner The owner of this contract.
997      */
998     constructor(address _proxy, TokenState _tokenState,
999                 string _name, string _symbol, uint _totalSupply,
1000                 uint8 _decimals, address _owner)
1001         SelfDestructible(_owner)
1002         Proxyable(_proxy, _owner)
1003         public
1004     {
1005         tokenState = _tokenState;
1006 
1007         name = _name;
1008         symbol = _symbol;
1009         totalSupply = _totalSupply;
1010         decimals = _decimals;
1011     }
1012 
1013     /* ========== VIEWS ========== */
1014 
1015     /**
1016      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
1017      * @param owner The party authorising spending of their funds.
1018      * @param spender The party spending tokenOwner's funds.
1019      */
1020     function allowance(address owner, address spender)
1021         public
1022         view
1023         returns (uint)
1024     {
1025         return tokenState.allowance(owner, spender);
1026     }
1027 
1028     /**
1029      * @notice Returns the ERC20 token balance of a given account.
1030      */
1031     function balanceOf(address account)
1032         public
1033         view
1034         returns (uint)
1035     {
1036         return tokenState.balanceOf(account);
1037     }
1038 
1039     /* ========== MUTATIVE FUNCTIONS ========== */
1040 
1041     /**
1042      * @notice Set the address of the TokenState contract.
1043      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
1044      * as balances would be unreachable.
1045      */
1046     function setTokenState(TokenState _tokenState)
1047         external
1048         optionalProxy_onlyOwner
1049     {
1050         tokenState = _tokenState;
1051         emitTokenStateUpdated(_tokenState);
1052     }
1053 
1054     function _internalTransfer(address from, address to, uint value)
1055         internal
1056         returns (bool)
1057     {
1058         /* Disallow transfers to irretrievable-addresses. */
1059         require(to != address(0) && to != address(this) && to != address(proxy), "Cannot transfer to this address");
1060 
1061         // Insufficient balance will be handled by the safe subtraction.
1062         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
1063         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
1064 
1065         // Emit a standard ERC20 transfer event
1066         emitTransfer(from, to, value);
1067         
1068         return true;
1069     }
1070 
1071     /**
1072      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
1073      * the onlyProxy or optionalProxy modifiers.
1074      */
1075     function _transfer_byProxy(address from, address to, uint value)
1076         internal
1077         returns (bool)
1078     {
1079         return _internalTransfer(from, to, value);
1080     }
1081 
1082     /**
1083      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
1084      * possessing the optionalProxy or optionalProxy modifiers.
1085      */
1086     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1087         internal
1088         returns (bool)
1089     {
1090         /* Insufficient allowance will be handled by the safe subtraction. */
1091         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
1092         return _internalTransfer(from, to, value);
1093     }
1094 
1095     /**
1096      * @notice Approves spender to transfer on the message sender's behalf.
1097      */
1098     function approve(address spender, uint value)
1099         public
1100         optionalProxy
1101         returns (bool)
1102     {
1103         address sender = messageSender;
1104 
1105         tokenState.setAllowance(sender, spender, value);
1106         emitApproval(sender, spender, value);
1107         return true;
1108     }
1109 
1110     /* ========== EVENTS ========== */
1111 
1112     event Transfer(address indexed from, address indexed to, uint value);
1113     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
1114     function emitTransfer(address from, address to, uint value) internal {
1115         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
1116     }
1117 
1118     event Approval(address indexed owner, address indexed spender, uint value);
1119     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
1120     function emitApproval(address owner, address spender, uint value) internal {
1121         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
1122     }
1123 
1124     event TokenStateUpdated(address newTokenState);
1125     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
1126     function emitTokenStateUpdated(address newTokenState) internal {
1127         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
1128     }
1129 }
1130 
1131 
1132 library Math {
1133 
1134     using SafeMath for uint;
1135     using SafeDecimalMath for uint;
1136 
1137     /**
1138     * @dev Uses "exponentiation by squaring" algorithm where cost is 0(logN)
1139     * vs 0(N) for naive repeated multiplication. 
1140     * Calculates x^n with x as fixed-point and n as regular unsigned int.
1141     * Calculates to 18 digits of precision with SafeDecimalMath.unit()
1142     */
1143     function powDecimal(uint x, uint n)
1144         internal
1145         pure
1146         returns (uint)
1147     {
1148         // https://mpark.github.io/programming/2014/08/18/exponentiation-by-squaring/
1149 
1150         uint result = SafeDecimalMath.unit();
1151         while (n > 0) {
1152             if (n % 2 != 0) {
1153                 result = result.multiplyDecimal(x);
1154             }
1155             x = x.multiplyDecimal(x);
1156             n /= 2;
1157         }
1158         return result;
1159     }
1160 }
1161     
1162 
1163 /**
1164  * @title SynthetixState interface contract
1165  * @notice Abstract contract to hold public getters
1166  */
1167 contract ISynthetixState {
1168     // A struct for handing values associated with an individual user's debt position
1169     struct IssuanceData {
1170         // Percentage of the total debt owned at the time
1171         // of issuance. This number is modified by the global debt
1172         // delta array. You can figure out a user's exit price and
1173         // collateralisation ratio using a combination of their initial
1174         // debt and the slice of global debt delta which applies to them.
1175         uint initialDebtOwnership;
1176         // This lets us know when (in relative terms) the user entered
1177         // the debt pool so we can calculate their exit price and
1178         // collateralistion ratio
1179         uint debtEntryIndex;
1180     }
1181 
1182     uint[] public debtLedger;
1183     uint public issuanceRatio;
1184     mapping(address => IssuanceData) public issuanceData;
1185 
1186     function debtLedgerLength() external view returns (uint);
1187     function hasIssued(address account) external view returns (bool);
1188     function incrementTotalIssuerCount() external;
1189     function decrementTotalIssuerCount() external;
1190     function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
1191     function lastDebtLedgerEntry() external view returns (uint);
1192     function appendDebtLedgerValue(uint value) external;
1193     function clearIssuanceData(address account) external;
1194 }
1195 
1196 
1197 interface ISynth {
1198     function burn(address account, uint amount) external;
1199     function issue(address account, uint amount) external;
1200     function transfer(address to, uint value) external returns (bool);
1201     function transferFrom(address from, address to, uint value) external returns (bool);
1202 }
1203 
1204 
1205 /**
1206  * @title SynthetixEscrow interface
1207  */
1208 interface ISynthetixEscrow {
1209     function balanceOf(address account) public view returns (uint);
1210     function appendVestingEntry(address account, uint quantity) public;
1211 }
1212 
1213 
1214 /**
1215  * @title FeePool Interface
1216  * @notice Abstract contract to hold public getters
1217  */
1218 contract IFeePool {
1219     address public FEE_ADDRESS;
1220     uint public exchangeFeeRate;
1221     function amountReceivedFromExchange(uint value) external view returns (uint);
1222     function amountReceivedFromTransfer(uint value) external view returns (uint);
1223     function recordFeePaid(uint xdrAmount) external;
1224     function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
1225     function setRewardsToDistribute(uint amount) external;
1226 }
1227 
1228 
1229 /**
1230  * @title ExchangeRates interface
1231  */
1232 interface IExchangeRates {
1233     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey) external view returns (uint);
1234 
1235     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1236     function ratesForCurrencies(bytes32[] currencyKeys) external view returns (uint[] memory);
1237 
1238     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1239     function anyRateIsStale(bytes32[] currencyKeys) external view returns (bool);
1240 }
1241 
1242 
1243 /*
1244 -----------------------------------------------------------------
1245 MODULE DESCRIPTION
1246 -----------------------------------------------------------------
1247 
1248 Synthetix-backed stablecoin contract.
1249 
1250 This contract issues synths, which are tokens that mirror various
1251 flavours of fiat currency.
1252 
1253 Synths are issuable by Synthetix Network Token (SNX) holders who
1254 have to lock up some value of their SNX to issue S * Cmax synths.
1255 Where Cmax issome value less than 1.
1256 
1257 A configurable fee is charged on synth exchanges and deposited
1258 into the fee pool, which Synthetix holders may withdraw from once
1259 per fee period.
1260 
1261 -----------------------------------------------------------------
1262 */
1263 
1264 
1265 contract Synth is ExternStateToken {
1266 
1267     /* ========== STATE VARIABLES ========== */
1268 
1269     // Address of the FeePoolProxy
1270     address public feePoolProxy;
1271     // Address of the SynthetixProxy
1272     address public synthetixProxy;
1273 
1274     // Currency key which identifies this Synth to the Synthetix system
1275     bytes32 public currencyKey;
1276 
1277     uint8 constant DECIMALS = 18;
1278 
1279     /* ========== CONSTRUCTOR ========== */
1280 
1281     constructor(address _proxy, TokenState _tokenState, address _synthetixProxy, address _feePoolProxy,
1282         string _tokenName, string _tokenSymbol, address _owner, bytes32 _currencyKey, uint _totalSupply
1283     )
1284         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, _totalSupply, DECIMALS, _owner)
1285         public
1286     {
1287         require(_proxy != address(0), "_proxy cannot be 0");
1288         require(_synthetixProxy != address(0), "_synthetixProxy cannot be 0");
1289         require(_feePoolProxy != address(0), "_feePoolProxy cannot be 0");
1290         require(_owner != 0, "_owner cannot be 0");
1291         require(ISynthetix(_synthetixProxy).synths(_currencyKey) == Synth(0), "Currency key is already in use");
1292 
1293         feePoolProxy = _feePoolProxy;
1294         synthetixProxy = _synthetixProxy;
1295         currencyKey = _currencyKey;
1296     }
1297 
1298     /* ========== SETTERS ========== */
1299 
1300     /**
1301      * @notice Set the SynthetixProxy should it ever change.
1302      * The Synth requires Synthetix address as it has the authority
1303      * to mint and burn synths
1304      * */
1305     function setSynthetixProxy(ISynthetix _synthetixProxy)
1306         external
1307         optionalProxy_onlyOwner
1308     {
1309         synthetixProxy = _synthetixProxy;
1310         emitSynthetixUpdated(_synthetixProxy);
1311     }
1312 
1313     /**
1314      * @notice Set the FeePoolProxy should it ever change.
1315      * The Synth requires FeePool address as it has the authority
1316      * to mint and burn for FeePool.claimFees()
1317      * */
1318     function setFeePoolProxy(address _feePoolProxy)
1319         external
1320         optionalProxy_onlyOwner
1321     {
1322         feePoolProxy = _feePoolProxy;
1323         emitFeePoolUpdated(_feePoolProxy);
1324     }
1325 
1326     /* ========== MUTATIVE FUNCTIONS ========== */
1327 
1328     /**
1329      * @notice ERC20 transfer function
1330      * forward call on to _internalTransfer */
1331     function transfer(address to, uint value)
1332         public
1333         optionalProxy
1334         returns (bool)
1335     {        
1336         return super._internalTransfer(messageSender, to, value);
1337     }
1338 
1339     /**
1340      * @notice ERC20 transferFrom function
1341      */
1342     function transferFrom(address from, address to, uint value)
1343         public
1344         optionalProxy
1345         returns (bool)
1346     {        
1347         // Skip allowance update in case of infinite allowance
1348         if (tokenState.allowance(from, messageSender) != uint(-1)) {
1349             // Reduce the allowance by the amount we're transferring.
1350             // The safeSub call will handle an insufficient allowance.
1351             tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1352         }
1353         
1354         return super._internalTransfer(from, to, value);
1355     }
1356 
1357     // Allow synthetix to issue a certain number of synths from an account.
1358     function issue(address account, uint amount)
1359         external
1360         onlySynthetixOrFeePool
1361     {
1362         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
1363         totalSupply = totalSupply.add(amount);
1364         emitTransfer(address(0), account, amount);
1365         emitIssued(account, amount);
1366     }
1367 
1368     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
1369     function burn(address account, uint amount)
1370         external
1371         onlySynthetixOrFeePool
1372     {
1373         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
1374         totalSupply = totalSupply.sub(amount);
1375         emitTransfer(account, address(0), amount);
1376         emitBurned(account, amount);
1377     }
1378 
1379     // Allow owner to set the total supply on import.
1380     function setTotalSupply(uint amount)
1381         external
1382         optionalProxy_onlyOwner
1383     {
1384         totalSupply = amount;
1385     }
1386 
1387     /* ========== MODIFIERS ========== */
1388 
1389     modifier onlySynthetixOrFeePool() {
1390         bool isSynthetix = msg.sender == address(Proxy(synthetixProxy).target());
1391         bool isFeePool = msg.sender == address(Proxy(feePoolProxy).target());
1392 
1393         require(isSynthetix || isFeePool, "Only Synthetix, FeePool allowed");
1394         _;
1395     }
1396 
1397     /* ========== EVENTS ========== */
1398 
1399     event SynthetixUpdated(address newSynthetix);
1400     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
1401     function emitSynthetixUpdated(address newSynthetix) internal {
1402         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
1403     }
1404 
1405     event FeePoolUpdated(address newFeePool);
1406     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
1407     function emitFeePoolUpdated(address newFeePool) internal {
1408         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
1409     }
1410 
1411     event Issued(address indexed account, uint value);
1412     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
1413     function emitIssued(address account, uint value) internal {
1414         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
1415     }
1416 
1417     event Burned(address indexed account, uint value);
1418     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
1419     function emitBurned(address account, uint value) internal {
1420         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
1421     }
1422 }
1423 
1424 
1425 /**
1426  * @title Synthetix interface contract
1427  * @notice Abstract contract to hold public getters
1428  * @dev pseudo interface, actually declared as contract to hold the public getters 
1429  */
1430 
1431 
1432 contract ISynthetix {
1433 
1434     // ========== PUBLIC STATE VARIABLES ==========
1435 
1436     IFeePool public feePool;
1437     ISynthetixEscrow public escrow;
1438     ISynthetixEscrow public rewardEscrow;
1439     ISynthetixState public synthetixState;
1440     IExchangeRates public exchangeRates;
1441 
1442     uint public totalSupply;
1443         
1444     mapping(bytes32 => Synth) public synths;
1445 
1446     // ========== PUBLIC FUNCTIONS ==========
1447 
1448     function balanceOf(address account) public view returns (uint);
1449     function transfer(address to, uint value) public returns (bool);
1450     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey) public view returns (uint);
1451 
1452     function synthInitiatedExchange(
1453         address from,
1454         bytes32 sourceCurrencyKey,
1455         uint sourceAmount,
1456         bytes32 destinationCurrencyKey,
1457         address destinationAddress) external returns (bool);
1458     function exchange(
1459         bytes32 sourceCurrencyKey,
1460         uint sourceAmount,
1461         bytes32 destinationCurrencyKey) external returns (bool);
1462     function collateralisationRatio(address issuer) public view returns (uint);
1463     function totalIssuedSynths(bytes32 currencyKey)
1464         public
1465         view
1466         returns (uint);
1467     function getSynth(bytes32 currencyKey) public view returns (ISynth);
1468     function debtBalanceOf(address issuer, bytes32 currencyKey) public view returns (uint);
1469 }
1470 
1471 
1472 /*
1473 -----------------------------------------------------------------
1474 MODULE DESCRIPTION
1475 -----------------------------------------------------------------
1476 
1477 The SNX supply schedule contract determines the amount of SNX tokens
1478 mintable over the course of 195 weeks.
1479 
1480 Exponential Decay Inflation Schedule
1481 
1482 Synthetix.mint() function is used to mint the inflationary supply.
1483 
1484 The mechanics for Inflation Smoothing and Terminal Inflation 
1485 have been defined in these sips
1486 https://sips.synthetix.io/sips/sip-23
1487 https://sips.synthetix.io/sips/sip-24
1488 
1489 The previous SNX Inflation Supply Schedule is at 
1490 https://etherscan.io/address/0xA3de830b5208851539De8e4FF158D635E8f36FCb#code
1491 
1492 -----------------------------------------------------------------
1493 */
1494 
1495 
1496 /**
1497  * @title SupplySchedule contract
1498  */
1499 contract SupplySchedule is Owned {
1500     using SafeMath for uint;
1501     using SafeDecimalMath for uint;
1502     using Math for uint;
1503 
1504     // Time of the last inflation supply mint event
1505     uint public lastMintEvent;
1506 
1507     // Counter for number of weeks since the start of supply inflation
1508     uint public weekCounter;
1509 
1510     // The number of SNX rewarded to the caller of Synthetix.mint()
1511     uint public minterReward = 200 * SafeDecimalMath.unit();
1512 
1513     // The initial weekly inflationary supply is 75m / 52 until the start of the decay rate. 
1514     // 75e6 * SafeDecimalMath.unit() / 52
1515     uint public constant INITIAL_WEEKLY_SUPPLY = 1442307692307692307692307;    
1516 
1517     // Address of the SynthetixProxy for the onlySynthetix modifier
1518     address public synthetixProxy;
1519 
1520     // Max SNX rewards for minter
1521     uint public constant MAX_MINTER_REWARD = 200 * SafeDecimalMath.unit();
1522 
1523     // How long each inflation period is before mint can be called
1524     uint public constant MINT_PERIOD_DURATION = 1 weeks;
1525 
1526     uint public constant INFLATION_START_DATE = 1551830400; // 2019-03-06T00:00:00+00:00
1527     uint public constant MINT_BUFFER = 1 days;
1528     uint8 public constant SUPPLY_DECAY_START = 40; // Week 40
1529     uint8 public constant SUPPLY_DECAY_END = 234; //  Supply Decay ends on Week 234 (inclusive of Week 234 for a total of 195 weeks of inflation decay)
1530     
1531     // Weekly percentage decay of inflationary supply from the first 40 weeks of the 75% inflation rate
1532     uint public constant DECAY_RATE = 12500000000000000; // 1.25% weekly
1533 
1534     // Percentage growth of terminal supply per annum
1535     uint public constant TERMINAL_SUPPLY_RATE_ANNUAL = 25000000000000000; // 2.5% pa
1536     
1537     constructor(
1538         address _owner,
1539         uint _lastMintEvent,
1540         uint _currentWeek)
1541         Owned(_owner)
1542         public
1543     {
1544         lastMintEvent = _lastMintEvent;
1545         weekCounter = _currentWeek;
1546     }
1547 
1548     // ========== VIEWS ==========     
1549     
1550     /**    
1551     * @return The amount of SNX mintable for the inflationary supply
1552     */
1553     function mintableSupply()
1554         external
1555         view
1556         returns (uint)
1557     {
1558         uint totalAmount;
1559 
1560         if (!isMintable()) {
1561             return totalAmount;
1562         }
1563         
1564         uint remainingWeeksToMint = weeksSinceLastIssuance();
1565           
1566         uint currentWeek = weekCounter;
1567         
1568         // Calculate total mintable supply from exponential decay function
1569         // The decay function stops after week 234
1570         while (remainingWeeksToMint > 0) {
1571             currentWeek++;            
1572             
1573             // If current week is before supply decay we add initial supply to mintableSupply
1574             if (currentWeek < SUPPLY_DECAY_START) {
1575                 totalAmount = totalAmount.add(INITIAL_WEEKLY_SUPPLY);
1576                 remainingWeeksToMint--;
1577             }
1578             // if current week before supply decay ends we add the new supply for the week 
1579             else if (currentWeek <= SUPPLY_DECAY_END) {
1580                 
1581                 // diff between current week and (supply decay start week - 1)  
1582                 uint decayCount = currentWeek.sub(SUPPLY_DECAY_START -1);
1583                 
1584                 totalAmount = totalAmount.add(tokenDecaySupplyForWeek(decayCount));
1585                 remainingWeeksToMint--;
1586             } 
1587             // Terminal supply is calculated on the total supply of Synthetix including any new supply
1588             // We can compound the remaining week's supply at the fixed terminal rate  
1589             else {
1590                 uint totalSupply = ISynthetix(synthetixProxy).totalSupply();
1591                 uint currentTotalSupply = totalSupply.add(totalAmount);
1592 
1593                 totalAmount = totalAmount.add(terminalInflationSupply(currentTotalSupply, remainingWeeksToMint));
1594                 remainingWeeksToMint = 0;
1595             }
1596         }
1597         
1598         return totalAmount;
1599     }
1600 
1601     /**
1602     * @return A unit amount of decaying inflationary supply from the INITIAL_WEEKLY_SUPPLY
1603     * @dev New token supply reduces by the decay rate each week calculated as supply = INITIAL_WEEKLY_SUPPLY * () 
1604     */
1605     function tokenDecaySupplyForWeek(uint counter)
1606         public 
1607         pure
1608         returns (uint)
1609     {   
1610         // Apply exponential decay function to number of weeks since
1611         // start of inflation smoothing to calculate diminishing supply for the week.
1612         uint effectiveDecay = (SafeDecimalMath.unit().sub(DECAY_RATE)).powDecimal(counter);
1613         uint supplyForWeek = INITIAL_WEEKLY_SUPPLY.multiplyDecimal(effectiveDecay);
1614 
1615         return supplyForWeek;
1616     }    
1617     
1618     /**
1619     * @return A unit amount of terminal inflation supply
1620     * @dev Weekly compound rate based on number of weeks     
1621     */
1622     function terminalInflationSupply(uint totalSupply, uint numOfWeeks)
1623         public
1624         pure
1625         returns (uint)
1626     {   
1627         // rate = (1 + weekly rate) ^ num of weeks
1628         uint effectiveCompoundRate = SafeDecimalMath.unit().add(TERMINAL_SUPPLY_RATE_ANNUAL.div(52)).powDecimal(numOfWeeks);
1629 
1630         // return Supply * (effectiveRate - 1) for extra supply to issue based on number of weeks
1631         return totalSupply.multiplyDecimal(effectiveCompoundRate.sub(SafeDecimalMath.unit()));
1632     }
1633 
1634     /**    
1635     * @dev Take timeDiff in seconds (Dividend) and MINT_PERIOD_DURATION as (Divisor)
1636     * @return Calculate the numberOfWeeks since last mint rounded down to 1 week
1637     */
1638     function weeksSinceLastIssuance()
1639         public
1640         view
1641         returns (uint)
1642     {
1643         // Get weeks since lastMintEvent
1644         // If lastMintEvent not set or 0, then start from inflation start date.
1645         uint timeDiff = lastMintEvent > 0 ? now.sub(lastMintEvent) : now.sub(INFLATION_START_DATE);
1646         return timeDiff.div(MINT_PERIOD_DURATION);
1647     }
1648 
1649     /**
1650      * @return boolean whether the MINT_PERIOD_DURATION (7 days)
1651      * has passed since the lastMintEvent.
1652      * */
1653     function isMintable()
1654         public
1655         view
1656         returns (bool)
1657     {
1658         if (now - lastMintEvent > MINT_PERIOD_DURATION)
1659         {
1660             return true;
1661         }
1662         return false;
1663     }
1664 
1665     // ========== MUTATIVE FUNCTIONS ==========
1666 
1667     /**
1668      * @notice Record the mint event from Synthetix by incrementing the inflation 
1669      * week counter for the number of weeks minted (probabaly always 1)
1670      * and store the time of the event.
1671      * @param supplyMinted the amount of SNX the total supply was inflated by.
1672      * */
1673     function recordMintEvent(uint supplyMinted)
1674         external
1675         onlySynthetix
1676         returns (bool)
1677     {
1678         uint numberOfWeeksIssued = weeksSinceLastIssuance();
1679 
1680         // add number of weeks minted to weekCounter
1681         weekCounter = weekCounter.add(numberOfWeeksIssued);
1682 
1683         // Update mint event to latest week issued (start date + number of weeks issued * seconds in week)
1684         // 1 day time buffer is added so inflation is minted after feePeriod closes 
1685         lastMintEvent = INFLATION_START_DATE.add(weekCounter.mul(MINT_PERIOD_DURATION)).add(MINT_BUFFER);
1686 
1687         emit SupplyMinted(supplyMinted, numberOfWeeksIssued, lastMintEvent, now);
1688         return true;
1689     }
1690 
1691     /**
1692      * @notice Sets the reward amount of SNX for the caller of the public 
1693      * function Synthetix.mint(). 
1694      * This incentivises anyone to mint the inflationary supply and the mintr 
1695      * Reward will be deducted from the inflationary supply and sent to the caller.
1696      * @param amount the amount of SNX to reward the minter.
1697      * */
1698     function setMinterReward(uint amount)
1699         external
1700         onlyOwner
1701     {
1702         require(amount <= MAX_MINTER_REWARD, "Reward cannot exceed max minter reward");
1703         minterReward = amount;
1704         emit MinterRewardUpdated(minterReward);
1705     }
1706 
1707     // ========== SETTERS ========== */
1708 
1709     /**
1710      * @notice Set the SynthetixProxy should it ever change.
1711      * SupplySchedule requires Synthetix address as it has the authority
1712      * to record mint event.
1713      * */
1714     function setSynthetixProxy(ISynthetix _synthetixProxy)
1715         external
1716         onlyOwner
1717     {
1718         require(_synthetixProxy != address(0), "Address cannot be 0");
1719         synthetixProxy = _synthetixProxy;
1720         emit SynthetixProxyUpdated(synthetixProxy);
1721     }
1722 
1723     // ========== MODIFIERS ==========
1724 
1725     /**
1726      * @notice Only the Synthetix contract is authorised to call this function
1727      * */
1728     modifier onlySynthetix() {
1729         require(msg.sender == address(Proxy(synthetixProxy).target()), "Only the synthetix contract can perform this action");
1730         _;
1731     }
1732 
1733     /* ========== EVENTS ========== */
1734     /**
1735      * @notice Emitted when the inflationary supply is minted
1736      * */
1737     event SupplyMinted(uint supplyMinted, uint numberOfWeeksIssued, uint lastMintEvent, uint timestamp);
1738 
1739     /**
1740      * @notice Emitted when the SNX minter reward amount is updated
1741      * */
1742     event MinterRewardUpdated(uint newRewardAmount);
1743 
1744     /**
1745      * @notice Emitted when setSynthetixProxy is called changing the Synthetix Proxy address
1746      * */
1747     event SynthetixProxyUpdated(address newAddress);
1748 }
1749 
1750 
1751 interface AggregatorInterface {
1752   function latestAnswer() external view returns (int256);
1753   function latestTimestamp() external view returns (uint256);
1754   function latestRound() external view returns (uint256);
1755   function getAnswer(uint256 roundId) external view returns (int256);
1756   function getTimestamp(uint256 roundId) external view returns (uint256);
1757 
1758   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
1759   event NewRound(uint256 indexed roundId, address indexed startedBy);
1760 }
1761 
1762 
1763 // AggregatorInterface from Chainlink represents a decentralized pricing network for a single currency keys
1764 
1765 
1766 /**
1767  * @title The repository for exchange rates
1768  */
1769 
1770 contract ExchangeRates is SelfDestructible {
1771 
1772 
1773     using SafeMath for uint;
1774     using SafeDecimalMath for uint;
1775 
1776     struct RateAndUpdatedTime {
1777         uint216 rate;
1778         uint40 time;
1779     }
1780 
1781     // Exchange rates and update times stored by currency code, e.g. 'SNX', or 'sUSD'
1782     mapping(bytes32 => RateAndUpdatedTime) private _rates;
1783 
1784     // The address of the oracle which pushes rate updates to this contract
1785     address public oracle;
1786 
1787     // Decentralized oracle networks that feed into pricing aggregators
1788     mapping(bytes32 => AggregatorInterface) public aggregators;
1789 
1790     // List of configure aggregator keys for convenient iteration
1791     bytes32[] public aggregatorKeys;
1792 
1793     // Do not allow the oracle to submit times any further forward into the future than this constant.
1794     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
1795 
1796     // How long will the contract assume the rate of any asset is correct
1797     uint public rateStalePeriod = 3 hours;
1798 
1799 
1800     // Each participating currency in the XDR basket is represented as a currency key with
1801     // equal weighting.
1802     // There are 5 participating currencies, so we'll declare that clearly.
1803     bytes32[5] public xdrParticipants;
1804 
1805     // A conveience mapping for checking if a rate is a XDR participant
1806     mapping(bytes32 => bool) public isXDRParticipant;
1807 
1808     // For inverted prices, keep a mapping of their entry, limits and frozen status
1809     struct InversePricing {
1810         uint entryPoint;
1811         uint upperLimit;
1812         uint lowerLimit;
1813         bool frozen;
1814     }
1815     mapping(bytes32 => InversePricing) public inversePricing;
1816     bytes32[] public invertedKeys;
1817 
1818     //
1819     // ========== CONSTRUCTOR ==========
1820 
1821     /**
1822      * @dev Constructor
1823      * @param _owner The owner of this contract.
1824      * @param _oracle The address which is able to update rate information.
1825      * @param _currencyKeys The initial currency keys to store (in order).
1826      * @param _newRates The initial currency amounts for each currency (in order).
1827      */
1828     constructor(
1829         // SelfDestructible (Ownable)
1830         address _owner,
1831 
1832         // Oracle values - Allows for rate updates
1833         address _oracle,
1834         bytes32[] _currencyKeys,
1835         uint[] _newRates
1836     )
1837         /* Owned is initialised in SelfDestructible */
1838         SelfDestructible(_owner)
1839         public
1840     {
1841         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
1842 
1843         oracle = _oracle;
1844 
1845         // The sUSD rate is always 1 and is never stale.
1846         _setRate("sUSD", SafeDecimalMath.unit(), now);
1847 
1848         // These are the currencies that make up the XDR basket.
1849         // These are hard coded because:
1850         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
1851         //  - Adding new currencies would likely introduce some kind of weighting factor, which
1852         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
1853         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
1854         //    then point the system at the new version.
1855         xdrParticipants = [
1856             bytes32("sUSD"),
1857             bytes32("sAUD"),
1858             bytes32("sCHF"),
1859             bytes32("sEUR"),
1860             bytes32("sGBP")
1861         ];
1862 
1863         // Mapping the XDR participants is cheaper than looping the xdrParticipants array to check if they exist
1864         isXDRParticipant[bytes32("sUSD")] = true;
1865         isXDRParticipant[bytes32("sAUD")] = true;
1866         isXDRParticipant[bytes32("sCHF")] = true;
1867         isXDRParticipant[bytes32("sEUR")] = true;
1868         isXDRParticipant[bytes32("sGBP")] = true;
1869 
1870         internalUpdateRates(_currencyKeys, _newRates, now);
1871     }
1872 
1873     function getRateAndUpdatedTime(bytes32 code) internal view returns (RateAndUpdatedTime) {
1874         if (code == "XDR") {
1875             // The XDR rate is the sum of the underlying XDR participant rates, and the latest
1876             // timestamp from those rates
1877             uint total = 0;
1878             uint lastUpdated = 0;
1879             for (uint i = 0; i < xdrParticipants.length; i++) {
1880                 RateAndUpdatedTime memory xdrEntry = getRateAndUpdatedTime(xdrParticipants[i]);
1881                 total = total.add(xdrEntry.rate);
1882                 if (xdrEntry.time > lastUpdated) {
1883                     lastUpdated = xdrEntry.time;
1884                 }
1885             }
1886             return RateAndUpdatedTime({
1887                 rate: uint216(total),
1888                 time: uint40(lastUpdated)
1889             });
1890         } else if (aggregators[code] != address(0)) {
1891             return RateAndUpdatedTime({
1892                 rate: uint216(aggregators[code].latestAnswer() * 1e10),
1893                 time: uint40(aggregators[code].latestTimestamp())
1894             });
1895         } else {
1896             return _rates[code];
1897         }
1898     }
1899     /**
1900      * @notice Retrieves the exchange rate (sUSD per unit) for a given currency key
1901      */
1902     function rates(bytes32 code) public view returns(uint256) {
1903         return getRateAndUpdatedTime(code).rate;
1904     }
1905 
1906     /**
1907      * @notice Retrieves the timestamp the given rate was last updated.
1908      */
1909     function lastRateUpdateTimes(bytes32 code) public view returns(uint256) {
1910         return getRateAndUpdatedTime(code).time;
1911     }
1912 
1913     /**
1914      * @notice Retrieve the last update time for a list of currencies
1915      */
1916     function lastRateUpdateTimesForCurrencies(bytes32[] currencyKeys)
1917         public
1918         view
1919         returns (uint[])
1920     {
1921         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
1922 
1923         for (uint i = 0; i < currencyKeys.length; i++) {
1924             lastUpdateTimes[i] = lastRateUpdateTimes(currencyKeys[i]);
1925         }
1926 
1927         return lastUpdateTimes;
1928     }
1929 
1930     function _setRate(bytes32 code, uint256 rate, uint256 time) internal {
1931         _rates[code] = RateAndUpdatedTime({
1932             rate: uint216(rate),
1933             time: uint40(time)
1934         });
1935     }
1936 
1937     /* ========== SETTERS ========== */
1938 
1939     /**
1940      * @notice Set the rates stored in this contract
1941      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1942      * @param newRates The rates for each currency (in order)
1943      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1944      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1945      *                 if it takes a long time for the transaction to confirm.
1946      */
1947     function updateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
1948         external
1949         onlyOracle
1950         returns(bool)
1951     {
1952         return internalUpdateRates(currencyKeys, newRates, timeSent);
1953     }
1954 
1955     /**
1956      * @notice Internal function which sets the rates stored in this contract
1957      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1958      * @param newRates The rates for each currency (in order)
1959      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1960      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1961      *                 if it takes a long time for the transaction to confirm.
1962      */
1963     function internalUpdateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
1964         internal
1965         returns(bool)
1966     {
1967         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
1968         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
1969 
1970         // Loop through each key and perform update.
1971         for (uint i = 0; i < currencyKeys.length; i++) {
1972             bytes32 currencyKey = currencyKeys[i];
1973 
1974             // Should not set any rate to zero ever, as no asset will ever be
1975             // truely worthless and still valid. In this scenario, we should
1976             // delete the rate and remove it from the system.
1977             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
1978             require(currencyKey != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
1979 
1980             // We should only update the rate if it's at least the same age as the last rate we've got.
1981             if (timeSent < lastRateUpdateTimes(currencyKey)) {
1982                 continue;
1983             }
1984 
1985             newRates[i] = rateOrInverted(currencyKey, newRates[i]);
1986 
1987             // Ok, go ahead with the update.
1988             _setRate(currencyKey, newRates[i], timeSent);
1989         }
1990 
1991         emit RatesUpdated(currencyKeys, newRates);
1992 
1993         return true;
1994     }
1995 
1996     /**
1997      * @notice Internal function to get the inverted rate, if any, and mark an inverted
1998      *  key as frozen if either limits are reached.
1999      *
2000      * Inverted rates are ones that take a regular rate, perform a simple calculation (double entryPrice and
2001      * subtract the rate) on them and if the result of the calculation is over or under predefined limits, it freezes the
2002      * rate at that limit, preventing any future rate updates.
2003      *
2004      * For example, if we have an inverted rate iBTC with the following parameters set:
2005      * - entryPrice of 200
2006      * - upperLimit of 300
2007      * - lower of 100
2008      *
2009      * if this function is invoked with params iETH and 184 (or rather 184e18),
2010      * then the rate would be: 200 * 2 - 184 = 216. 100 < 216 < 200, so the rate would be 216,
2011      * and remain unfrozen.
2012      *
2013      * If this function is then invoked with params iETH and 301 (or rather 301e18),
2014      * then the rate would be: 200 * 2 - 301 = 99. 99 < 100, so the rate would be 100 and the
2015      * rate would become frozen, no longer accepting future price updates until the synth is unfrozen
2016      * by the owner function: setInversePricing().
2017      *
2018      * @param currencyKey The price key to lookup
2019      * @param rate The rate for the given price key
2020      */
2021     function rateOrInverted(bytes32 currencyKey, uint rate) internal returns (uint) {
2022         // if an inverse mapping exists, adjust the price accordingly
2023         InversePricing storage inverse = inversePricing[currencyKey];
2024         if (inverse.entryPoint <= 0) {
2025             return rate;
2026         }
2027 
2028         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
2029         uint newInverseRate = rates(currencyKey);
2030 
2031         // get the new inverted rate if not frozen
2032         if (!inverse.frozen) {
2033             uint doubleEntryPoint = inverse.entryPoint.mul(2);
2034             if (doubleEntryPoint <= rate) {
2035                 // avoid negative numbers for unsigned ints, so set this to 0
2036                 // which by the requirement that lowerLimit be > 0 will
2037                 // cause this to freeze the price to the lowerLimit
2038                 newInverseRate = 0;
2039             } else {
2040                 newInverseRate = doubleEntryPoint.sub(rate);
2041             }
2042 
2043             // now if new rate hits our limits, set it to the limit and freeze
2044             if (newInverseRate >= inverse.upperLimit) {
2045                 newInverseRate = inverse.upperLimit;
2046             } else if (newInverseRate <= inverse.lowerLimit) {
2047                 newInverseRate = inverse.lowerLimit;
2048             }
2049 
2050             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
2051                 inverse.frozen = true;
2052                 emit InversePriceFrozen(currencyKey);
2053             }
2054         }
2055 
2056         return newInverseRate;
2057     }
2058 
2059     /**
2060      * @notice Delete a rate stored in the contract
2061      * @param currencyKey The currency key you wish to delete the rate for
2062      */
2063     function deleteRate(bytes32 currencyKey)
2064         external
2065         onlyOracle
2066     {
2067         require(rates(currencyKey) > 0, "Rate is zero");
2068 
2069         delete _rates[currencyKey];
2070 
2071         emit RateDeleted(currencyKey);
2072     }
2073 
2074     /**
2075      * @notice Set the Oracle that pushes the rate information to this contract
2076      * @param _oracle The new oracle address
2077      */
2078     function setOracle(address _oracle)
2079         external
2080         onlyOwner
2081     {
2082         oracle = _oracle;
2083         emit OracleUpdated(oracle);
2084     }
2085 
2086     /**
2087      * @notice Set the stale period on the updated rate variables
2088      * @param _time The new rateStalePeriod
2089      */
2090     function setRateStalePeriod(uint _time)
2091         external
2092         onlyOwner
2093     {
2094         rateStalePeriod = _time;
2095         emit RateStalePeriodUpdated(rateStalePeriod);
2096     }
2097 
2098     /**
2099      * @notice Set an inverse price up for the currency key.
2100      *
2101      * An inverse price is one which has an entryPoint, an uppper and a lower limit. Each update, the
2102      * rate is calculated as double the entryPrice minus the current rate. If this calculation is
2103      * above or below the upper or lower limits respectively, then the rate is frozen, and no more
2104      * rate updates will be accepted.
2105      *
2106      * @param currencyKey The currency to update
2107      * @param entryPoint The entry price point of the inverted price
2108      * @param upperLimit The upper limit, at or above which the price will be frozen
2109      * @param lowerLimit The lower limit, at or below which the price will be frozen
2110      * @param freeze Whether or not to freeze this rate immediately. Note: no frozen event will be configured
2111      * @param freezeAtUpperLimit When the freeze flag is true, this flag indicates whether the rate
2112      * to freeze at is the upperLimit or lowerLimit..
2113      */
2114     function setInversePricing(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit, bool freeze, bool freezeAtUpperLimit)
2115         external onlyOwner
2116     {
2117         require(entryPoint > 0, "entryPoint must be above 0");
2118         require(lowerLimit > 0, "lowerLimit must be above 0");
2119         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
2120         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
2121         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
2122 
2123         if (inversePricing[currencyKey].entryPoint <= 0) {
2124             // then we are adding a new inverse pricing, so add this
2125             invertedKeys.push(currencyKey);
2126         }
2127         inversePricing[currencyKey].entryPoint = entryPoint;
2128         inversePricing[currencyKey].upperLimit = upperLimit;
2129         inversePricing[currencyKey].lowerLimit = lowerLimit;
2130         inversePricing[currencyKey].frozen = freeze;
2131 
2132         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
2133 
2134         // When indicating to freeze, we need to know the rate to freeze it at - either upper or lower
2135         // this is useful in situations where ExchangeRates is updated and there are existing inverted
2136         // rates already frozen in the current contract that need persisting across the upgrade
2137         if (freeze) {
2138             emit InversePriceFrozen(currencyKey);
2139 
2140             _setRate(currencyKey, freezeAtUpperLimit ? upperLimit : lowerLimit, now);
2141         }
2142     }
2143 
2144     /**
2145      * @notice Remove an inverse price for the currency key
2146      * @param currencyKey The currency to remove inverse pricing for
2147      */
2148     function removeInversePricing(bytes32 currencyKey) external onlyOwner
2149     {
2150         require(inversePricing[currencyKey].entryPoint > 0, "No inverted price exists");
2151 
2152         inversePricing[currencyKey].entryPoint = 0;
2153         inversePricing[currencyKey].upperLimit = 0;
2154         inversePricing[currencyKey].lowerLimit = 0;
2155         inversePricing[currencyKey].frozen = false;
2156 
2157         // now remove inverted key from array
2158         bool wasRemoved = removeFromArray(currencyKey, invertedKeys);
2159 
2160         if (wasRemoved) {
2161             emit InversePriceConfigured(currencyKey, 0, 0, 0);
2162         }
2163     }
2164 
2165     /**
2166      * @notice Add a pricing aggregator for the given key. Note: existing aggregators may be overridden.
2167      * @param currencyKey The currency key to add an aggregator for
2168      */
2169     function addAggregator(bytes32 currencyKey, address aggregatorAddress) external onlyOwner {
2170         AggregatorInterface aggregator = AggregatorInterface(aggregatorAddress);
2171         require(aggregator.latestTimestamp() >= 0, "Given Aggregator is invalid");
2172         if (aggregators[currencyKey] == address(0)) {
2173             aggregatorKeys.push(currencyKey);
2174         }
2175         aggregators[currencyKey] = aggregator;
2176         emit AggregatorAdded(currencyKey, aggregator);
2177     }
2178 
2179     /**
2180      * @notice Remove a single value from an array by iterating through until it is found.
2181      * @param entry The entry to find
2182      * @param array The array to mutate
2183      * @return bool Whether or not the entry was found and removed
2184      */
2185     function removeFromArray(bytes32 entry, bytes32[] storage array) internal returns (bool) {
2186         for (uint i = 0; i < array.length; i++) {
2187             if (array[i] == entry) {
2188                 delete array[i];
2189 
2190                 // Copy the last key into the place of the one we just deleted
2191                 // If there's only one key, this is array[0] = array[0].
2192                 // If we're deleting the last one, it's also a NOOP in the same way.
2193                 array[i] = array[array.length - 1];
2194 
2195                 // Decrease the size of the array by one.
2196                 array.length--;
2197 
2198                 return true;
2199             }
2200         }
2201         return false;
2202     }
2203     /**
2204      * @notice Remove a pricing aggregator for the given key
2205      * @param currencyKey THe currency key to remove an aggregator for
2206      */
2207     function removeAggregator(bytes32 currencyKey) external onlyOwner {
2208         address aggregator = aggregators[currencyKey];
2209         require(aggregator != address(0), "No aggregator exists for key");
2210         delete aggregators[currencyKey];
2211 
2212         bool wasRemoved = removeFromArray(currencyKey, aggregatorKeys);
2213 
2214         if (wasRemoved) {
2215             emit AggregatorRemoved(currencyKey, aggregator);
2216         }
2217     }
2218 
2219     /* ========== VIEWS ========== */
2220 
2221     /**
2222      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2223      * @param sourceCurrencyKey The currency the amount is specified in
2224      * @param sourceAmount The source amount, specified in UNIT base
2225      * @param destinationCurrencyKey The destination currency
2226      */
2227     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
2228         public
2229         view
2230         rateNotStale(sourceCurrencyKey)
2231         rateNotStale(destinationCurrencyKey)
2232         returns (uint)
2233     {
2234         // If there's no change in the currency, then just return the amount they gave us
2235         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
2236 
2237         // Calculate the effective value by going from source -> USD -> destination
2238         return sourceAmount.multiplyDecimalRound(rateForCurrency(sourceCurrencyKey))
2239             .divideDecimalRound(rateForCurrency(destinationCurrencyKey));
2240     }
2241 
2242     /**
2243      * @notice Retrieve the rate for a specific currency
2244      */
2245     function rateForCurrency(bytes32 currencyKey)
2246         public
2247         view
2248         returns (uint)
2249     {
2250         return rates(currencyKey);
2251     }
2252 
2253     /**
2254      * @notice Retrieve the rates for a list of currencies
2255      */
2256     function ratesForCurrencies(bytes32[] currencyKeys)
2257         public
2258         view
2259         returns (uint[])
2260     {
2261         uint[] memory _localRates = new uint[](currencyKeys.length);
2262 
2263         for (uint i = 0; i < currencyKeys.length; i++) {
2264             _localRates[i] = rates(currencyKeys[i]);
2265         }
2266 
2267         return _localRates;
2268     }
2269 
2270     /**
2271      * @notice Retrieve the rates and isAnyStale for a list of currencies
2272      */
2273     function ratesAndStaleForCurrencies(bytes32[] currencyKeys)
2274         public
2275         view
2276         returns (uint[], bool)
2277     {
2278         uint[] memory _localRates = new uint[](currencyKeys.length);
2279 
2280         bool anyRateStale = false;
2281         uint period = rateStalePeriod;
2282         for (uint i = 0; i < currencyKeys.length; i++) {
2283             RateAndUpdatedTime memory rateAndUpdateTime = getRateAndUpdatedTime(currencyKeys[i]);
2284             _localRates[i] = uint256(rateAndUpdateTime.rate);
2285             if (!anyRateStale) {
2286                 anyRateStale = (currencyKeys[i] != "sUSD" && uint256(rateAndUpdateTime.time).add(period) < now);
2287             }
2288         }
2289 
2290         return (_localRates, anyRateStale);
2291     }
2292 
2293     /**
2294      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
2295      */
2296     function rateIsStale(bytes32 currencyKey)
2297         public
2298         view
2299         returns (bool)
2300     {
2301         // sUSD is a special case and is never stale.
2302         if (currencyKey == "sUSD") return false;
2303 
2304         return lastRateUpdateTimes(currencyKey).add(rateStalePeriod) < now;
2305     }
2306 
2307     /**
2308      * @notice Check if any rate is frozen (cannot be exchanged into)
2309      */
2310     function rateIsFrozen(bytes32 currencyKey)
2311         external
2312         view
2313         returns (bool)
2314     {
2315         return inversePricing[currencyKey].frozen;
2316     }
2317 
2318 
2319     /**
2320      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
2321      */
2322     function anyRateIsStale(bytes32[] currencyKeys)
2323         external
2324         view
2325         returns (bool)
2326     {
2327         // Loop through each key and check whether the data point is stale.
2328         uint256 i = 0;
2329 
2330         while (i < currencyKeys.length) {
2331             // sUSD is a special case and is never false
2332             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes(currencyKeys[i]).add(rateStalePeriod) < now) {
2333                 return true;
2334             }
2335             i += 1;
2336         }
2337 
2338         return false;
2339     }
2340 
2341     /* ========== MODIFIERS ========== */
2342 
2343     modifier rateNotStale(bytes32 currencyKey) {
2344         require(!rateIsStale(currencyKey), "Rate stale or nonexistant currency");
2345         _;
2346     }
2347 
2348     modifier onlyOracle
2349     {
2350         require(msg.sender == oracle, "Only the oracle can perform this action");
2351         _;
2352     }
2353 
2354     /* ========== EVENTS ========== */
2355 
2356     event OracleUpdated(address newOracle);
2357     event RateStalePeriodUpdated(uint rateStalePeriod);
2358     event RatesUpdated(bytes32[] currencyKeys, uint[] newRates);
2359     event RateDeleted(bytes32 currencyKey);
2360     event InversePriceConfigured(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
2361     event InversePriceFrozen(bytes32 currencyKey);
2362     event AggregatorAdded(bytes32 currencyKey, address aggregator);
2363     event AggregatorRemoved(bytes32 currencyKey, address aggregator);
2364 }
2365 
2366 
2367 /*
2368 -----------------------------------------------------------------
2369 FILE INFORMATION
2370 -----------------------------------------------------------------
2371 
2372 file:       LimitedSetup.sol
2373 version:    1.1
2374 author:     Anton Jurisevic
2375 
2376 date:       2018-05-15
2377 
2378 -----------------------------------------------------------------
2379 MODULE DESCRIPTION
2380 -----------------------------------------------------------------
2381 
2382 A contract with a limited setup period. Any function modified
2383 with the setup modifier will cease to work after the
2384 conclusion of the configurable-length post-construction setup period.
2385 
2386 -----------------------------------------------------------------
2387 */
2388 
2389 
2390 /**
2391  * @title Any function decorated with the modifier this contract provides
2392  * deactivates after a specified setup period.
2393  */
2394 contract LimitedSetup {
2395 
2396     uint setupExpiryTime;
2397 
2398     /**
2399      * @dev LimitedSetup Constructor.
2400      * @param setupDuration The time the setup period will last for.
2401      */
2402     constructor(uint setupDuration)
2403         public
2404     {
2405         setupExpiryTime = now + setupDuration;
2406     }
2407 
2408     modifier onlyDuringSetup
2409     {
2410         require(now < setupExpiryTime, "Can only perform this action during setup");
2411         _;
2412     }
2413 }
2414 
2415 
2416 /*
2417 -----------------------------------------------------------------
2418 FILE INFORMATION
2419 -----------------------------------------------------------------
2420 
2421 file:       SynthetixState.sol
2422 version:    1.0
2423 author:     Kevin Brown
2424 date:       2018-10-19
2425 
2426 -----------------------------------------------------------------
2427 MODULE DESCRIPTION
2428 -----------------------------------------------------------------
2429 
2430 A contract that holds issuance state and preferred currency of
2431 users in the Synthetix system.
2432 
2433 This contract is used side by side with the Synthetix contract
2434 to make it easier to upgrade the contract logic while maintaining
2435 issuance state.
2436 
2437 The Synthetix contract is also quite large and on the edge of
2438 being beyond the contract size limit without moving this information
2439 out to another contract.
2440 
2441 The first deployed contract would create this state contract,
2442 using it as its store of issuance data.
2443 
2444 When a new contract is deployed, it links to the existing
2445 state contract, whose owner would then change its associated
2446 contract to the new one.
2447 
2448 -----------------------------------------------------------------
2449 */
2450 
2451 
2452 /**
2453  * @title Synthetix State
2454  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
2455  */
2456 contract SynthetixState is State, LimitedSetup {
2457     using SafeMath for uint;
2458     using SafeDecimalMath for uint;
2459 
2460     // A struct for handing values associated with an individual user's debt position
2461     struct IssuanceData {
2462         // Percentage of the total debt owned at the time
2463         // of issuance. This number is modified by the global debt
2464         // delta array. You can figure out a user's exit price and
2465         // collateralisation ratio using a combination of their initial
2466         // debt and the slice of global debt delta which applies to them.
2467         uint initialDebtOwnership;
2468         // This lets us know when (in relative terms) the user entered
2469         // the debt pool so we can calculate their exit price and
2470         // collateralistion ratio
2471         uint debtEntryIndex;
2472     }
2473 
2474     // Issued synth balances for individual fee entitlements and exit price calculations
2475     mapping(address => IssuanceData) public issuanceData;
2476 
2477     // The total count of people that have outstanding issued synths in any flavour
2478     uint public totalIssuerCount;
2479 
2480     // Global debt pool tracking
2481     uint[] public debtLedger;
2482 
2483     // Import state
2484     uint public importedXDRAmount;
2485 
2486     // A quantity of synths greater than this ratio
2487     // may not be issued against a given value of SNX.
2488     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
2489     // No more synths may be issued than the value of SNX backing them.
2490     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
2491 
2492     // Users can specify their preferred currency, in which case all synths they receive
2493     // will automatically exchange to that preferred currency upon receipt in their wallet
2494     mapping(address => bytes4) public preferredCurrency;
2495 
2496     /**
2497      * @dev Constructor
2498      * @param _owner The address which controls this contract.
2499      * @param _associatedContract The ERC20 contract whose state this composes.
2500      */
2501     constructor(address _owner, address _associatedContract)
2502         State(_owner, _associatedContract)
2503         LimitedSetup(1 weeks)
2504         public
2505     {}
2506 
2507     /* ========== SETTERS ========== */
2508 
2509     /**
2510      * @notice Set issuance data for an address
2511      * @dev Only the associated contract may call this.
2512      * @param account The address to set the data for.
2513      * @param initialDebtOwnership The initial debt ownership for this address.
2514      */
2515     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
2516         external
2517         onlyAssociatedContract
2518     {
2519         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
2520         issuanceData[account].debtEntryIndex = debtLedger.length;
2521     }
2522 
2523     /**
2524      * @notice Clear issuance data for an address
2525      * @dev Only the associated contract may call this.
2526      * @param account The address to clear the data for.
2527      */
2528     function clearIssuanceData(address account)
2529         external
2530         onlyAssociatedContract
2531     {
2532         delete issuanceData[account];
2533     }
2534 
2535     /**
2536      * @notice Increment the total issuer count
2537      * @dev Only the associated contract may call this.
2538      */
2539     function incrementTotalIssuerCount()
2540         external
2541         onlyAssociatedContract
2542     {
2543         totalIssuerCount = totalIssuerCount.add(1);
2544     }
2545 
2546     /**
2547      * @notice Decrement the total issuer count
2548      * @dev Only the associated contract may call this.
2549      */
2550     function decrementTotalIssuerCount()
2551         external
2552         onlyAssociatedContract
2553     {
2554         totalIssuerCount = totalIssuerCount.sub(1);
2555     }
2556 
2557     /**
2558      * @notice Append a value to the debt ledger
2559      * @dev Only the associated contract may call this.
2560      * @param value The new value to be added to the debt ledger.
2561      */
2562     function appendDebtLedgerValue(uint value)
2563         external
2564         onlyAssociatedContract
2565     {
2566         debtLedger.push(value);
2567     }
2568 
2569     /**
2570      * @notice Set preferred currency for a user
2571      * @dev Only the associated contract may call this.
2572      * @param account The account to set the preferred currency for
2573      * @param currencyKey The new preferred currency
2574      */
2575     function setPreferredCurrency(address account, bytes4 currencyKey)
2576         external
2577         onlyAssociatedContract
2578     {
2579         preferredCurrency[account] = currencyKey;
2580     }
2581 
2582     /**
2583      * @notice Set the issuanceRatio for issuance calculations.
2584      * @dev Only callable by the contract owner.
2585      */
2586     function setIssuanceRatio(uint _issuanceRatio)
2587         external
2588         onlyOwner
2589     {
2590         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
2591         issuanceRatio = _issuanceRatio;
2592         emit IssuanceRatioUpdated(_issuanceRatio);
2593     }
2594 
2595     /**
2596      * @notice Import issuer data from the old Synthetix contract before multicurrency
2597      * @dev Only callable by the contract owner, and only for 1 week after deployment.
2598      */
2599     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
2600         external
2601         onlyOwner
2602         onlyDuringSetup
2603     {
2604         require(accounts.length == sUSDAmounts.length, "Length mismatch");
2605 
2606         for (uint8 i = 0; i < accounts.length; i++) {
2607             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
2608         }
2609     }
2610 
2611     /**
2612      * @notice Import issuer data from the old Synthetix contract before multicurrency
2613      * @dev Only used from importIssuerData above, meant to be disposable
2614      */
2615     function _addToDebtRegister(address account, uint amount)
2616         internal
2617     {
2618         // This code is duplicated from Synthetix so that we can call it directly here
2619         // during setup only.
2620         Synthetix synthetix = Synthetix(associatedContract);
2621 
2622         // What is the value of the requested debt in XDRs?
2623         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
2624 
2625         // What is the value that we've previously imported?
2626         uint totalDebtIssued = importedXDRAmount;
2627 
2628         // What will the new total be including the new value?
2629         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2630 
2631         // Save that for the next import.
2632         importedXDRAmount = newTotalDebtIssued;
2633 
2634         // What is their percentage (as a high precision int) of the total debt?
2635         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2636 
2637         // And what effect does this percentage have on the global debt holding of other issuers?
2638         // The delta specifically needs to not take into account any existing debt as it's already
2639         // accounted for in the delta from when they issued previously.
2640         // The delta is a high precision integer.
2641         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2642 
2643         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
2644 
2645         // And what does their debt ownership look like including this previous stake?
2646         if (existingDebt > 0) {
2647             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2648         }
2649 
2650         // Are they a new issuer? If so, record them.
2651         if (issuanceData[account].initialDebtOwnership == 0) {
2652             totalIssuerCount = totalIssuerCount.add(1);
2653         }
2654 
2655         // Save the debt entry parameters
2656         issuanceData[account].initialDebtOwnership = debtPercentage;
2657         issuanceData[account].debtEntryIndex = debtLedger.length;
2658 
2659         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2660         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2661         if (debtLedger.length > 0) {
2662             debtLedger.push(
2663                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2664             );
2665         } else {
2666             debtLedger.push(SafeDecimalMath.preciseUnit());
2667         }
2668     }
2669 
2670     /* ========== VIEWS ========== */
2671 
2672     /**
2673      * @notice Retrieve the length of the debt ledger array
2674      */
2675     function debtLedgerLength()
2676         external
2677         view
2678         returns (uint)
2679     {
2680         return debtLedger.length;
2681     }
2682 
2683     /**
2684      * @notice Retrieve the most recent entry from the debt ledger
2685      */
2686     function lastDebtLedgerEntry()
2687         external
2688         view
2689         returns (uint)
2690     {
2691         return debtLedger[debtLedger.length - 1];
2692     }
2693 
2694     /**
2695      * @notice Query whether an account has issued and has an outstanding debt balance
2696      * @param account The address to query for
2697      */
2698     function hasIssued(address account)
2699         external
2700         view
2701         returns (bool)
2702     {
2703         return issuanceData[account].initialDebtOwnership > 0;
2704     }
2705 
2706     event IssuanceRatioUpdated(uint newRatio);
2707 }
2708 
2709 
2710 /**
2711  * @title RewardsDistribution interface
2712  */
2713 interface IRewardsDistribution {
2714     function distributeRewards(uint amount) external;
2715 }
2716 
2717 
2718 /**
2719  * @title Synthetix ERC20 contract.
2720  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2721  * but it also computes the quantity of fees each synthetix holder is entitled to.
2722  */
2723 contract Synthetix is ExternStateToken {
2724 
2725     // ========== STATE VARIABLES ==========
2726 
2727     // Available Synths which can be used with the system
2728     Synth[] public availableSynths;
2729     mapping(bytes32 => Synth) public synths;
2730     mapping(address => bytes32) public synthsByAddress;
2731 
2732     IFeePool public feePool;
2733     ISynthetixEscrow public escrow;
2734     ISynthetixEscrow public rewardEscrow;
2735     ExchangeRates public exchangeRates;
2736     SynthetixState public synthetixState;
2737     SupplySchedule public supplySchedule;
2738     IRewardsDistribution public rewardsDistribution;
2739 
2740     bool private protectionCircuit = false;
2741 
2742     string constant TOKEN_NAME = "Synthetix Network Token";
2743     string constant TOKEN_SYMBOL = "SNX";
2744     uint8 constant DECIMALS = 18;
2745     bool public exchangeEnabled = true;
2746     uint public gasPriceLimit;
2747 
2748     address public gasLimitOracle;
2749     // ========== CONSTRUCTOR ==========
2750 
2751     /**
2752      * @dev Constructor
2753      * @param _proxy The main token address of the Proxy contract. This will be ProxyERC20.sol
2754      * @param _tokenState Address of the external immutable contract containing token balances.
2755      * @param _synthetixState External immutable contract containing the SNX minters debt ledger.
2756      * @param _owner The owner of this contract.
2757      * @param _exchangeRates External immutable contract where the price oracle pushes prices onchain too.
2758      * @param _feePool External upgradable contract handling SNX Fees and Rewards claiming
2759      * @param _supplySchedule External immutable contract with the SNX inflationary supply schedule
2760      * @param _rewardEscrow External immutable contract for SNX Rewards Escrow
2761      * @param _escrow External immutable contract for SNX Token Sale Escrow
2762      * @param _rewardsDistribution External immutable contract managing the Rewards Distribution of the SNX inflationary supply
2763      * @param _totalSupply On upgrading set to reestablish the current total supply (This should be in SynthetixState if ever updated)
2764      */
2765     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2766         address _owner, ExchangeRates _exchangeRates, IFeePool _feePool, SupplySchedule _supplySchedule,
2767         ISynthetixEscrow _rewardEscrow, ISynthetixEscrow _escrow, IRewardsDistribution _rewardsDistribution, uint _totalSupply
2768     )
2769         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, _totalSupply, DECIMALS, _owner)
2770         public
2771     {
2772         synthetixState = _synthetixState;
2773         exchangeRates = _exchangeRates;
2774         feePool = _feePool;
2775         supplySchedule = _supplySchedule;
2776         rewardEscrow = _rewardEscrow;
2777         escrow = _escrow;
2778         rewardsDistribution = _rewardsDistribution;
2779     }
2780     // ========== SETTERS ========== */
2781 
2782     function setFeePool(IFeePool _feePool)
2783         external
2784         optionalProxy_onlyOwner
2785     {
2786         feePool = _feePool;
2787     }
2788 
2789     function setExchangeRates(ExchangeRates _exchangeRates)
2790         external
2791         optionalProxy_onlyOwner
2792     {
2793         exchangeRates = _exchangeRates;
2794     }
2795 
2796     function setProtectionCircuit(bool _protectionCircuitIsActivated)
2797         external
2798         onlyOracle
2799     {
2800         protectionCircuit = _protectionCircuitIsActivated;
2801     }
2802 
2803     function setExchangeEnabled(bool _exchangeEnabled)
2804         external
2805         optionalProxy_onlyOwner
2806     {
2807         exchangeEnabled = _exchangeEnabled;
2808     }
2809 
2810     function setGasLimitOracle(address _gasLimitOracle)
2811         external
2812         optionalProxy_onlyOwner
2813     {
2814         gasLimitOracle = _gasLimitOracle;
2815     }
2816 
2817     function setGasPriceLimit(uint _gasPriceLimit)
2818         external
2819     {
2820         require(msg.sender == gasLimitOracle, "Only gas limit oracle allowed");
2821         require(_gasPriceLimit > 0, "Needs to be greater than 0");
2822         gasPriceLimit = _gasPriceLimit;
2823     }
2824 
2825     /**
2826      * @notice Add an associated Synth contract to the Synthetix system
2827      * @dev Only the contract owner may call this.
2828      */
2829     function addSynth(Synth synth)
2830         external
2831         optionalProxy_onlyOwner
2832     {
2833         bytes32 currencyKey = synth.currencyKey();
2834 
2835         require(synths[currencyKey] == Synth(0), "Synth already exists");
2836         require(synthsByAddress[synth] == bytes32(0), "Synth address already exists");
2837 
2838         availableSynths.push(synth);
2839         synths[currencyKey] = synth;
2840         synthsByAddress[synth] = currencyKey;
2841     }
2842 
2843     /**
2844      * @notice Remove an associated Synth contract from the Synthetix system
2845      * @dev Only the contract owner may call this.
2846      */
2847     function removeSynth(bytes32 currencyKey)
2848         external
2849         optionalProxy_onlyOwner
2850     {
2851         require(synths[currencyKey] != address(0), "Synth does not exist");
2852         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2853         require(currencyKey != "XDR" && currencyKey != "sUSD", "Cannot remove synth");        
2854 
2855         // Save the address we're removing for emitting the event at the end.
2856         address synthToRemove = synths[currencyKey];
2857 
2858         // Remove the synth from the availableSynths array.
2859         for (uint i = 0; i < availableSynths.length; i++) {
2860             if (availableSynths[i] == synthToRemove) {
2861                 delete availableSynths[i];
2862 
2863                 // Copy the last synth into the place of the one we just deleted
2864                 // If there's only one synth, this is synths[0] = synths[0].
2865                 // If we're deleting the last one, it's also a NOOP in the same way.
2866                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2867 
2868                 // Decrease the size of the array by one.
2869                 availableSynths.length--;
2870 
2871                 break;
2872             }
2873         }
2874 
2875         // And remove it from the synths mapping
2876         delete synthsByAddress[synths[currencyKey]];
2877         delete synths[currencyKey];
2878 
2879         // Note: No event here as Synthetix contract exceeds max contract size
2880         // with these events, and it's unlikely people will need to
2881         // track these events specifically.
2882     }
2883 
2884     // ========== VIEWS ==========
2885 
2886     /**
2887      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2888      * @param sourceCurrencyKey The currency the amount is specified in
2889      * @param sourceAmount The source amount, specified in UNIT base
2890      * @param destinationCurrencyKey The destination currency
2891      */
2892     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
2893         public
2894         view
2895         returns (uint)
2896     {
2897         return exchangeRates.effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
2898     }
2899 
2900     /**
2901      * @notice Total amount of synths issued by the system, priced in currencyKey
2902      * @param currencyKey The currency to value the synths in
2903      */
2904     function totalIssuedSynths(bytes32 currencyKey)
2905         public
2906         view
2907         returns (uint)
2908     {
2909         uint total = 0;
2910         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2911 
2912         (uint[] memory rates, bool anyRateStale) = exchangeRates.ratesAndStaleForCurrencies(availableCurrencyKeys());
2913         require(!anyRateStale, "Rates are stale");
2914 
2915         for (uint i = 0; i < availableSynths.length; i++) {
2916             // What's the total issued value of that synth in the destination currency?
2917             // Note: We're not using our effectiveValue function because we don't want to go get the
2918             //       rate for the destination currency and check if it's stale repeatedly on every
2919             //       iteration of the loop
2920             uint synthValue = availableSynths[i].totalSupply()
2921                 .multiplyDecimalRound(rates[i]);
2922             total = total.add(synthValue);
2923         }
2924 
2925         return total.divideDecimalRound(currencyRate);
2926     }
2927 
2928     /**
2929      * @notice Returns the currencyKeys of availableSynths for rate checking
2930      */
2931     function availableCurrencyKeys()
2932         public
2933         view
2934         returns (bytes32[])
2935     {
2936         bytes32[] memory currencyKeys = new bytes32[](availableSynths.length);
2937 
2938         for (uint i = 0; i < availableSynths.length; i++) {
2939             currencyKeys[i] = synthsByAddress[availableSynths[i]];
2940         }
2941 
2942         return currencyKeys;
2943     }
2944 
2945     /**
2946      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
2947      */
2948     function availableSynthCount()
2949         public
2950         view
2951         returns (uint)
2952     {
2953         return availableSynths.length;
2954     }
2955 
2956     /**
2957      * @notice Determine the effective fee rate for the exchange, taking into considering swing trading
2958      */
2959     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
2960         public
2961         view
2962         returns (uint)
2963     {
2964         // Get the base exchange fee rate
2965         uint exchangeFeeRate = feePool.exchangeFeeRate();
2966 
2967         uint multiplier = 1;
2968 
2969         // Is this a swing trade? I.e. long to short or vice versa, excluding when going into or out of sUSD.
2970         // Note: this assumes shorts begin with 'i' and longs with 's'.
2971         if (
2972             (sourceCurrencyKey[0] == 0x73 && sourceCurrencyKey != "sUSD" && destinationCurrencyKey[0] == 0x69) ||
2973             (sourceCurrencyKey[0] == 0x69 && destinationCurrencyKey != "sUSD" && destinationCurrencyKey[0] == 0x73)
2974         ) {
2975             // If so then double the exchange fee multipler
2976             multiplier = 2;
2977         }
2978 
2979         return exchangeFeeRate.mul(multiplier);
2980     }
2981     // ========== MUTATIVE FUNCTIONS ==========
2982     
2983     /**
2984      * @notice ERC20 transfer function.
2985      */
2986     function transfer(address to, uint value)
2987         public
2988         optionalProxy
2989         returns (bool)
2990     {
2991         // Ensure they're not trying to exceed their staked SNX amount
2992         require(value <= transferableSynthetix(messageSender), "Cannot transfer staked or escrowed SNX");
2993 
2994         // Perform the transfer: if there is a problem an exception will be thrown in this call.
2995         _transfer_byProxy(messageSender, to, value);
2996 
2997         return true;
2998     }
2999 
3000      /**
3001      * @notice ERC20 transferFrom function.
3002      */
3003     function transferFrom(address from, address to, uint value)
3004         public
3005         optionalProxy
3006         returns (bool)
3007     {
3008         // Ensure they're not trying to exceed their locked amount
3009         require(value <= transferableSynthetix(from), "Cannot transfer staked or escrowed SNX");
3010 
3011         // Perform the transfer: if there is a problem,
3012         // an exception will be thrown in this call.
3013         return _transferFrom_byProxy(messageSender, from, to, value);         
3014     }
3015 
3016     /**
3017      * @notice Function that allows you to exchange synths you hold in one flavour for another.
3018      * @param sourceCurrencyKey The source currency you wish to exchange from
3019      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3020      * @param destinationCurrencyKey The destination currency you wish to obtain.
3021      * @return Boolean that indicates whether the transfer succeeded or failed.
3022      */
3023     function exchange(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
3024         external
3025         optionalProxy
3026         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
3027         returns (bool)
3028     {
3029         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3030         require(sourceAmount > 0, "Zero amount");
3031 
3032         // verify gas price limit
3033         validateGasPrice(tx.gasprice);
3034 
3035         //  If the oracle has set protectionCircuit to true then burn the synths
3036         if (protectionCircuit) {
3037             synths[sourceCurrencyKey].burn(messageSender, sourceAmount);
3038             return true;
3039         } else {
3040             // Pass it along, defaulting to the sender as the recipient.
3041             return _internalExchange(
3042                 messageSender,
3043                 sourceCurrencyKey,
3044                 sourceAmount,
3045                 destinationCurrencyKey,
3046                 messageSender,
3047                 true // Charge fee on the exchange
3048             );
3049         }
3050     }
3051 
3052     /*
3053         @dev validate that the given gas price is less than or equal to the gas price limit
3054         @param _gasPrice tested gas price
3055     */
3056     function validateGasPrice(uint _givenGasPrice)
3057         public
3058         view
3059     {
3060         require(_givenGasPrice <= gasPriceLimit, "Gas price above limit");
3061     }
3062 
3063     /**
3064      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
3065      * @dev Only the synth contract can call this function
3066      * @param from The address to exchange / burn synth from
3067      * @param sourceCurrencyKey The source currency you wish to exchange from
3068      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3069      * @param destinationCurrencyKey The destination currency you wish to obtain.
3070      * @param destinationAddress Where the result should go.
3071      * @return Boolean that indicates whether the transfer succeeded or failed.
3072      */
3073     function synthInitiatedExchange(
3074         address from,
3075         bytes32 sourceCurrencyKey,
3076         uint sourceAmount,
3077         bytes32 destinationCurrencyKey,
3078         address destinationAddress
3079     )
3080         external
3081         optionalProxy
3082         returns (bool)
3083     {
3084         require(synthsByAddress[messageSender] != bytes32(0), "Only synth allowed");
3085         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3086         require(sourceAmount > 0, "Zero amount");
3087 
3088         // Pass it along
3089         return _internalExchange(
3090             from,
3091             sourceCurrencyKey,
3092             sourceAmount,
3093             destinationCurrencyKey,
3094             destinationAddress,
3095             false
3096         );
3097     }
3098 
3099     /**
3100      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3101      * @dev fee pool contract address is not allowed to call function
3102      * @param from The address to move synth from
3103      * @param sourceCurrencyKey source currency from.
3104      * @param sourceAmount The amount, specified in UNIT of source currency.
3105      * @param destinationCurrencyKey The destination currency to obtain.
3106      * @param destinationAddress Where the result should go.
3107      * @param chargeFee Boolean to charge a fee for exchange.
3108      * @return Boolean that indicates whether the transfer succeeded or failed.
3109      */
3110     function _internalExchange(
3111         address from,
3112         bytes32 sourceCurrencyKey,
3113         uint sourceAmount,
3114         bytes32 destinationCurrencyKey,
3115         address destinationAddress,
3116         bool chargeFee
3117     )
3118         internal
3119         returns (bool)
3120     {
3121         require(exchangeEnabled, "Exchanging is disabled");
3122 
3123         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3124         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3125 
3126         // Burn the source amount
3127         synths[sourceCurrencyKey].burn(from, sourceAmount);
3128 
3129         // How much should they get in the destination currency?
3130         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3131 
3132         // What's the fee on that currency that we should deduct?
3133         uint amountReceived = destinationAmount;
3134         uint fee = 0;
3135 
3136         if (chargeFee) {
3137             // Get the exchange fee rate
3138             uint exchangeFeeRate = feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
3139 
3140             amountReceived = destinationAmount.multiplyDecimal(SafeDecimalMath.unit().sub(exchangeFeeRate));
3141 
3142             fee = destinationAmount.sub(amountReceived);
3143         }
3144 
3145         // Issue their new synths
3146         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3147 
3148         // Remit the fee in XDRs
3149         if (fee > 0) {
3150             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3151             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3152             // Tell the fee pool about this.
3153             feePool.recordFeePaid(xdrFeeAmount);
3154         }
3155 
3156         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.        
3157 
3158         //Let the DApps know there was a Synth exchange
3159         emitSynthExchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, amountReceived, destinationAddress);
3160 
3161         return true;
3162     }
3163 
3164     /**
3165      * @notice Function that registers new synth as they are issued. Calculate delta to append to synthetixState.
3166      * @dev Only internal calls from synthetix address.
3167      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3168      * @param amount The amount of synths to register with a base of UNIT
3169      */
3170     function _addToDebtRegister(bytes32 currencyKey, uint amount)
3171         internal
3172     {
3173         // What is the value of the requested debt in XDRs?
3174         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3175 
3176         // What is the value of all issued synths of the system (priced in XDRs)?
3177         uint totalDebtIssued = totalIssuedSynths("XDR");
3178 
3179         // What will the new total be including the new value?
3180         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3181 
3182         // What is their percentage (as a high precision int) of the total debt?
3183         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3184 
3185         // And what effect does this percentage change have on the global debt holding of other issuers?
3186         // The delta specifically needs to not take into account any existing debt as it's already
3187         // accounted for in the delta from when they issued previously.
3188         // The delta is a high precision integer.
3189         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3190 
3191         // How much existing debt do they have?
3192         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3193 
3194         // And what does their debt ownership look like including this previous stake?
3195         if (existingDebt > 0) {
3196             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3197         }
3198 
3199         // Are they a new issuer? If so, record them.
3200         if (existingDebt == 0) {
3201             synthetixState.incrementTotalIssuerCount();
3202         }
3203 
3204         // Save the debt entry parameters
3205         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3206 
3207         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3208         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3209         if (synthetixState.debtLedgerLength() > 0) {
3210             synthetixState.appendDebtLedgerValue(
3211                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3212             );
3213         } else {
3214             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3215         }
3216     }
3217 
3218     /**
3219      * @notice Issue synths against the sender's SNX.
3220      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3221      * @param amount The amount of synths you wish to issue with a base of UNIT
3222      */
3223     function issueSynths(uint amount)
3224         public
3225         optionalProxy
3226         // No need to check if price is stale, as it is checked in issuableSynths.
3227     {
3228         bytes32 currencyKey = "sUSD";
3229 
3230         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3231 
3232         // Keep track of the debt they're about to create
3233         _addToDebtRegister(currencyKey, amount);
3234 
3235         // Create their synths
3236         synths[currencyKey].issue(messageSender, amount);
3237 
3238         // Store their locked SNX amount to determine their fee % for the period
3239         _appendAccountIssuanceRecord();
3240     }
3241 
3242     /**
3243      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3244      * @dev Issuance is only allowed if the synthetix price isn't stale.
3245      */
3246     function issueMaxSynths()
3247         external
3248         optionalProxy
3249     {
3250         bytes32 currencyKey = "sUSD";
3251 
3252         // Figure out the maximum we can issue in that currency
3253         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3254 
3255         // Keep track of the debt they're about to create
3256         _addToDebtRegister(currencyKey, maxIssuable);
3257 
3258         // Create their synths
3259         synths[currencyKey].issue(messageSender, maxIssuable);
3260 
3261         // Store their locked SNX amount to determine their fee % for the period
3262         _appendAccountIssuanceRecord();
3263     }
3264 
3265     /**
3266      * @notice Burn synths to clear issued synths/free SNX.
3267      * @param amount The amount (in UNIT base) you wish to burn
3268      * @dev The amount to burn is debased to XDR's
3269      */
3270     function burnSynths(uint amount)
3271         external
3272         optionalProxy
3273         // No need to check for stale rates as effectiveValue checks rates
3274     {
3275         bytes32 currencyKey = "sUSD";
3276 
3277         // How much debt do they have?
3278         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3279         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3280 
3281         uint debtInCurrencyKey = debtBalanceOf(messageSender, currencyKey);
3282 
3283         require(existingDebt > 0, "No debt to forgive");
3284 
3285         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3286         // clear their debt and leave them be.
3287         uint amountToRemove = existingDebt < debtToRemove ? existingDebt : debtToRemove;
3288 
3289         // Remove their debt from the ledger
3290         _removeFromDebtRegister(amountToRemove, existingDebt);
3291 
3292         uint amountToBurn = debtInCurrencyKey < amount ? debtInCurrencyKey : amount;
3293 
3294         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3295         synths[currencyKey].burn(messageSender, amountToBurn);
3296 
3297         // Store their debtRatio against a feeperiod to determine their fee/rewards % for the period
3298         _appendAccountIssuanceRecord();
3299     }
3300 
3301     /**
3302      * @notice Store in the FeePool the users current debt value in the system in XDRs.
3303      * @dev debtBalanceOf(messageSender, "XDR") to be used with totalIssuedSynths("XDR") to get
3304      *  users % of the system within a feePeriod.
3305      */
3306     function _appendAccountIssuanceRecord()
3307         internal
3308     {
3309         uint initialDebtOwnership;
3310         uint debtEntryIndex;
3311         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(messageSender);
3312 
3313         feePool.appendAccountIssuanceRecord(
3314             messageSender,
3315             initialDebtOwnership,
3316             debtEntryIndex
3317         );
3318     }
3319 
3320     /**
3321      * @notice Remove a debt position from the register
3322      * @param amount The amount (in UNIT base) being presented in XDRs
3323      * @param existingDebt The existing debt (in UNIT base) of address presented in XDRs
3324      */
3325     function _removeFromDebtRegister(uint amount, uint existingDebt)
3326         internal
3327     {
3328         uint debtToRemove = amount;
3329 
3330         // What is the value of all issued synths of the system (priced in XDRs)?
3331         uint totalDebtIssued = totalIssuedSynths("XDR");
3332 
3333         // What will the new total after taking out the withdrawn amount
3334         uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3335 
3336         uint delta = 0;
3337 
3338         // What will the debt delta be if there is any debt left?
3339         // Set delta to 0 if no more debt left in system after user
3340         if (newTotalDebtIssued > 0) {
3341 
3342             // What is the percentage of the withdrawn debt (as a high precision int) of the total debt after?
3343             uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(newTotalDebtIssued);
3344 
3345             // And what effect does this percentage change have on the global debt holding of other issuers?
3346             // The delta specifically needs to not take into account any existing debt as it's already
3347             // accounted for in the delta from when they issued previously.
3348             delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3349         }
3350 
3351         // Are they exiting the system, or are they just decreasing their debt position?
3352         if (debtToRemove == existingDebt) {
3353             synthetixState.setCurrentIssuanceData(messageSender, 0);
3354             synthetixState.decrementTotalIssuerCount();
3355         } else {
3356             // What percentage of the debt will they be left with?
3357             uint newDebt = existingDebt.sub(debtToRemove);
3358             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3359 
3360             // Store the debt percentage and debt ledger as high precision integers
3361             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3362         }
3363 
3364         // Update our cumulative ledger. This is also a high precision integer.
3365         synthetixState.appendDebtLedgerValue(
3366             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3367         );
3368     }
3369 
3370     // ========== Issuance/Burning ==========
3371 
3372     /**
3373      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3374      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3375      */
3376     function maxIssuableSynths(address issuer, bytes32 currencyKey)
3377         public
3378         view
3379         // We don't need to check stale rates here as effectiveValue will do it for us.
3380         returns (uint)
3381     {
3382         // What is the value of their SNX balance in the destination currency?
3383         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3384 
3385         // They're allowed to issue up to issuanceRatio of that value
3386         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3387     }
3388 
3389     /**
3390      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3391      * as the value of the underlying Synthetix asset changes,
3392      * e.g. based on an issuance ratio of 20%. if a user issues their maximum available
3393      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3394      * of Synthetix changes, the ratio returned by this function will adjust accordingly. Users are
3395      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3396      * altering the amount of fees they're able to claim from the system.
3397      */
3398     function collateralisationRatio(address issuer)
3399         public
3400         view
3401         returns (uint)
3402     {
3403         uint totalOwnedSynthetix = collateral(issuer);
3404         if (totalOwnedSynthetix == 0) return 0;
3405 
3406         uint debtBalance = debtBalanceOf(issuer, "SNX");
3407         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3408     }
3409 
3410     /**
3411      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3412      * will tell you how many synths a user has to give back to the system in order to unlock their original
3413      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3414      * the debt in sUSD, XDR, or any other synth you wish.
3415      */
3416     function debtBalanceOf(address issuer, bytes32 currencyKey)
3417         public
3418         view
3419         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3420         returns (uint)
3421     {
3422         // What was their initial debt ownership?
3423         uint initialDebtOwnership;
3424         uint debtEntryIndex;
3425         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3426 
3427         // If it's zero, they haven't issued, and they have no debt.
3428         if (initialDebtOwnership == 0) return 0;
3429 
3430         // Figure out the global debt percentage delta from when they entered the system.
3431         // This is a high precision integer of 27 (1e27) decimals.
3432         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3433             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3434             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3435 
3436         // What's the total value of the system in their requested currency?
3437         uint totalSystemValue = totalIssuedSynths(currencyKey);
3438 
3439         // Their debt balance is their portion of the total system value.
3440         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3441             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3442 
3443         // Convert back into 18 decimals (1e18)
3444         return highPrecisionBalance.preciseDecimalToDecimal();
3445     }
3446 
3447     /**
3448      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3449      * @param issuer The account that intends to issue
3450      * @param currencyKey The currency to price issuable value in
3451      */
3452     function remainingIssuableSynths(address issuer, bytes32 currencyKey)
3453         public
3454         view
3455         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3456         returns (uint)
3457     {
3458         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3459         uint max = maxIssuableSynths(issuer, currencyKey);
3460 
3461         if (alreadyIssued >= max) {
3462             return 0;
3463         } else {
3464             return max.sub(alreadyIssued);
3465         }
3466     }
3467 
3468     /**
3469      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3470      * against which synths can be issued.
3471      * This includes those already being used as collateral (locked), and those
3472      * available for further issuance (unlocked).
3473      */
3474     function collateral(address account)
3475         public
3476         view
3477         returns (uint)
3478     {
3479         uint balance = tokenState.balanceOf(account);
3480 
3481         if (escrow != address(0)) {
3482             balance = balance.add(escrow.balanceOf(account));
3483         }
3484 
3485         if (rewardEscrow != address(0)) {
3486             balance = balance.add(rewardEscrow.balanceOf(account));
3487         }
3488 
3489         return balance;
3490     }
3491 
3492     /**
3493      * @notice The number of SNX that are free to be transferred for an account.
3494      * @dev Escrowed SNX are not transferable, so they are not included
3495      * in this calculation.
3496      * @notice SNX rate not stale is checked within debtBalanceOf
3497      */
3498     function transferableSynthetix(address account)
3499         public
3500         view
3501         rateNotStale("SNX") // SNX is not a synth so is not checked in totalIssuedSynths
3502         returns (uint)
3503     {
3504         // How many SNX do they have, excluding escrow?
3505         // Note: We're excluding escrow here because we're interested in their transferable amount
3506         // and escrowed SNX are not transferable.
3507         uint balance = tokenState.balanceOf(account);
3508 
3509         // How many of those will be locked by the amount they've issued?
3510         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3511         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3512         // The locked synthetix value can exceed their balance.
3513         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3514 
3515         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3516         if (lockedSynthetixValue >= balance) {
3517             return 0;
3518         } else {
3519             return balance.sub(lockedSynthetixValue);
3520         }
3521     }
3522 
3523     /**
3524      * @notice Mints the inflationary SNX supply. The inflation shedule is
3525      * defined in the SupplySchedule contract.
3526      * The mint() function is publicly callable by anyone. The caller will
3527      receive a minter reward as specified in supplySchedule.minterReward().
3528      */
3529     function mint()
3530         external
3531         returns (bool)
3532     {
3533         require(rewardsDistribution != address(0), "RewardsDistribution not set");
3534 
3535         uint supplyToMint = supplySchedule.mintableSupply();
3536         require(supplyToMint > 0, "No supply is mintable");
3537 
3538         // record minting event before mutation to token supply
3539         supplySchedule.recordMintEvent(supplyToMint);
3540 
3541         // Set minted SNX balance to RewardEscrow's balance
3542         // Minus the minterReward and set balance of minter to add reward
3543         uint minterReward = supplySchedule.minterReward();
3544         // Get the remainder
3545         uint amountToDistribute = supplyToMint.sub(minterReward);
3546 
3547         // Set the token balance to the RewardsDistribution contract
3548         tokenState.setBalanceOf(rewardsDistribution, tokenState.balanceOf(rewardsDistribution).add(amountToDistribute));
3549         emitTransfer(this, rewardsDistribution, amountToDistribute);
3550 
3551         // Kick off the distribution of rewards
3552         rewardsDistribution.distributeRewards(amountToDistribute);
3553 
3554         // Assign the minters reward.
3555         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
3556         emitTransfer(this, msg.sender, minterReward);
3557 
3558         totalSupply = totalSupply.add(supplyToMint);
3559 
3560         return true;
3561     }
3562 
3563     // ========== MODIFIERS ==========
3564 
3565     modifier rateNotStale(bytes32 currencyKey) {
3566         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or not a synth");
3567         _;
3568     }
3569 
3570     modifier onlyOracle
3571     {
3572         require(msg.sender == exchangeRates.oracle(), "Only oracle allowed");
3573         _;
3574     }
3575 
3576     // ========== EVENTS ==========
3577     /* solium-disable */
3578     event SynthExchange(address indexed account, bytes32 fromCurrencyKey, uint256 fromAmount, bytes32 toCurrencyKey,  uint256 toAmount, address toAddress);
3579     bytes32 constant SYNTHEXCHANGE_SIG = keccak256("SynthExchange(address,bytes32,uint256,bytes32,uint256,address)");
3580     function emitSynthExchange(address account, bytes32 fromCurrencyKey, uint256 fromAmount, bytes32 toCurrencyKey, uint256 toAmount, address toAddress) internal {
3581         proxy._emit(abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress), 2, SYNTHEXCHANGE_SIG, bytes32(account), 0, 0);
3582     }
3583     /* solium-enable */
3584 }
3585 
3586 
3587     