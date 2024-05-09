1 /* ===============================================
2 * 
3 * FeePool
4 * 
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
533 file:       State.sol
534 version:    1.1
535 author:     Dominic Romanowski
536             Anton Jurisevic
537 
538 date:       2018-05-15
539 
540 -----------------------------------------------------------------
541 MODULE DESCRIPTION
542 -----------------------------------------------------------------
543 
544 This contract is used side by side with external state token
545 contracts, such as Synthetix and Synth.
546 It provides an easy way to upgrade contract logic while
547 maintaining all user balances and allowances. This is designed
548 to make the changeover as easy as possible, since mappings
549 are not so cheap or straightforward to migrate.
550 
551 The first deployed contract would create this state contract,
552 using it as its store of balances.
553 When a new contract is deployed, it links to the existing
554 state contract, whose owner would then change its associated
555 contract to the new one.
556 
557 -----------------------------------------------------------------
558 */
559 
560 
561 contract State is Owned {
562     // the address of the contract that can modify variables
563     // this can only be changed by the owner of this contract
564     address public associatedContract;
565 
566 
567     constructor(address _owner, address _associatedContract)
568         Owned(_owner)
569         public
570     {
571         associatedContract = _associatedContract;
572         emit AssociatedContractUpdated(_associatedContract);
573     }
574 
575     /* ========== SETTERS ========== */
576 
577     // Change the associated contract to a new address
578     function setAssociatedContract(address _associatedContract)
579         external
580         onlyOwner
581     {
582         associatedContract = _associatedContract;
583         emit AssociatedContractUpdated(_associatedContract);
584     }
585 
586     /* ========== MODIFIERS ========== */
587 
588     modifier onlyAssociatedContract
589     {
590         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
591         _;
592     }
593 
594     /* ========== EVENTS ========== */
595 
596     event AssociatedContractUpdated(address associatedContract);
597 }
598 
599 
600 /*
601 -----------------------------------------------------------------
602 FILE INFORMATION
603 -----------------------------------------------------------------
604 
605 file:       TokenState.sol
606 version:    1.1
607 author:     Dominic Romanowski
608             Anton Jurisevic
609 
610 date:       2018-05-15
611 
612 -----------------------------------------------------------------
613 MODULE DESCRIPTION
614 -----------------------------------------------------------------
615 
616 A contract that holds the state of an ERC20 compliant token.
617 
618 This contract is used side by side with external state token
619 contracts, such as Synthetix and Synth.
620 It provides an easy way to upgrade contract logic while
621 maintaining all user balances and allowances. This is designed
622 to make the changeover as easy as possible, since mappings
623 are not so cheap or straightforward to migrate.
624 
625 The first deployed contract would create this state contract,
626 using it as its store of balances.
627 When a new contract is deployed, it links to the existing
628 state contract, whose owner would then change its associated
629 contract to the new one.
630 
631 -----------------------------------------------------------------
632 */
633 
634 
635 /**
636  * @title ERC20 Token State
637  * @notice Stores balance information of an ERC20 token contract.
638  */
639 contract TokenState is State {
640 
641     /* ERC20 fields. */
642     mapping(address => uint) public balanceOf;
643     mapping(address => mapping(address => uint)) public allowance;
644 
645     /**
646      * @dev Constructor
647      * @param _owner The address which controls this contract.
648      * @param _associatedContract The ERC20 contract whose state this composes.
649      */
650     constructor(address _owner, address _associatedContract)
651         State(_owner, _associatedContract)
652         public
653     {}
654 
655     /* ========== SETTERS ========== */
656 
657     /**
658      * @notice Set ERC20 allowance.
659      * @dev Only the associated contract may call this.
660      * @param tokenOwner The authorising party.
661      * @param spender The authorised party.
662      * @param value The total value the authorised party may spend on the
663      * authorising party's behalf.
664      */
665     function setAllowance(address tokenOwner, address spender, uint value)
666         external
667         onlyAssociatedContract
668     {
669         allowance[tokenOwner][spender] = value;
670     }
671 
672     /**
673      * @notice Set the balance in a given account
674      * @dev Only the associated contract may call this.
675      * @param account The account whose value to set.
676      * @param value The new balance of the given account.
677      */
678     function setBalanceOf(address account, uint value)
679         external
680         onlyAssociatedContract
681     {
682         balanceOf[account] = value;
683     }
684 }
685 
686 
687 /*
688 -----------------------------------------------------------------
689 FILE INFORMATION
690 -----------------------------------------------------------------
691 
692 file:       Proxy.sol
693 version:    1.3
694 author:     Anton Jurisevic
695 
696 date:       2018-05-29
697 
698 -----------------------------------------------------------------
699 MODULE DESCRIPTION
700 -----------------------------------------------------------------
701 
702 A proxy contract that, if it does not recognise the function
703 being called on it, passes all value and call data to an
704 underlying target contract.
705 
706 This proxy has the capacity to toggle between DELEGATECALL
707 and CALL style proxy functionality.
708 
709 The former executes in the proxy's context, and so will preserve 
710 msg.sender and store data at the proxy address. The latter will not.
711 Therefore, any contract the proxy wraps in the CALL style must
712 implement the Proxyable interface, in order that it can pass msg.sender
713 into the underlying contract as the state parameter, messageSender.
714 
715 -----------------------------------------------------------------
716 */
717 
718 
719 contract Proxy is Owned {
720 
721     Proxyable public target;
722     bool public useDELEGATECALL;
723 
724     constructor(address _owner)
725         Owned(_owner)
726         public
727     {}
728 
729     function setTarget(Proxyable _target)
730         external
731         onlyOwner
732     {
733         target = _target;
734         emit TargetUpdated(_target);
735     }
736 
737     function setUseDELEGATECALL(bool value) 
738         external
739         onlyOwner
740     {
741         useDELEGATECALL = value;
742     }
743 
744     function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)
745         external
746         onlyTarget
747     {
748         uint size = callData.length;
749         bytes memory _callData = callData;
750 
751         assembly {
752             /* The first 32 bytes of callData contain its length (as specified by the abi). 
753              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
754              * in length. It is also leftpadded to be a multiple of 32 bytes.
755              * This means moving call_data across 32 bytes guarantees we correctly access
756              * the data itself. */
757             switch numTopics
758             case 0 {
759                 log0(add(_callData, 32), size)
760             } 
761             case 1 {
762                 log1(add(_callData, 32), size, topic1)
763             }
764             case 2 {
765                 log2(add(_callData, 32), size, topic1, topic2)
766             }
767             case 3 {
768                 log3(add(_callData, 32), size, topic1, topic2, topic3)
769             }
770             case 4 {
771                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
772             }
773         }
774     }
775 
776     function()
777         external
778         payable
779     {
780         if (useDELEGATECALL) {
781             assembly {
782                 /* Copy call data into free memory region. */
783                 let free_ptr := mload(0x40)
784                 calldatacopy(free_ptr, 0, calldatasize)
785 
786                 /* Forward all gas and call data to the target contract. */
787                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
788                 returndatacopy(free_ptr, 0, returndatasize)
789 
790                 /* Revert if the call failed, otherwise return the result. */
791                 if iszero(result) { revert(free_ptr, returndatasize) }
792                 return(free_ptr, returndatasize)
793             }
794         } else {
795             /* Here we are as above, but must send the messageSender explicitly 
796              * since we are using CALL rather than DELEGATECALL. */
797             target.setMessageSender(msg.sender);
798             assembly {
799                 let free_ptr := mload(0x40)
800                 calldatacopy(free_ptr, 0, calldatasize)
801 
802                 /* We must explicitly forward ether to the underlying contract as well. */
803                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
804                 returndatacopy(free_ptr, 0, returndatasize)
805 
806                 if iszero(result) { revert(free_ptr, returndatasize) }
807                 return(free_ptr, returndatasize)
808             }
809         }
810     }
811 
812     modifier onlyTarget {
813         require(Proxyable(msg.sender) == target, "Must be proxy target");
814         _;
815     }
816 
817     event TargetUpdated(Proxyable newTarget);
818 }
819 
820 
821 /*
822 -----------------------------------------------------------------
823 FILE INFORMATION
824 -----------------------------------------------------------------
825 
826 file:       Proxyable.sol
827 version:    1.1
828 author:     Anton Jurisevic
829 
830 date:       2018-05-15
831 
832 checked:    Mike Spain
833 approved:   Samuel Brooks
834 
835 -----------------------------------------------------------------
836 MODULE DESCRIPTION
837 -----------------------------------------------------------------
838 
839 A proxyable contract that works hand in hand with the Proxy contract
840 to allow for anyone to interact with the underlying contract both
841 directly and through the proxy.
842 
843 -----------------------------------------------------------------
844 */
845 
846 
847 // This contract should be treated like an abstract contract
848 contract Proxyable is Owned {
849     /* The proxy this contract exists behind. */
850     Proxy public proxy;
851 
852     /* The caller of the proxy, passed through to this contract.
853      * Note that every function using this member must apply the onlyProxy or
854      * optionalProxy modifiers, otherwise their invocations can use stale values. */ 
855     address messageSender; 
856 
857     constructor(address _proxy, address _owner)
858         Owned(_owner)
859         public
860     {
861         proxy = Proxy(_proxy);
862         emit ProxyUpdated(_proxy);
863     }
864 
865     function setProxy(address _proxy)
866         external
867         onlyOwner
868     {
869         proxy = Proxy(_proxy);
870         emit ProxyUpdated(_proxy);
871     }
872 
873     function setMessageSender(address sender)
874         external
875         onlyProxy
876     {
877         messageSender = sender;
878     }
879 
880     modifier onlyProxy {
881         require(Proxy(msg.sender) == proxy, "Only the proxy can call this function");
882         _;
883     }
884 
885     modifier optionalProxy
886     {
887         if (Proxy(msg.sender) != proxy) {
888             messageSender = msg.sender;
889         }
890         _;
891     }
892 
893     modifier optionalProxy_onlyOwner
894     {
895         if (Proxy(msg.sender) != proxy) {
896             messageSender = msg.sender;
897         }
898         require(messageSender == owner, "This action can only be performed by the owner");
899         _;
900     }
901 
902     event ProxyUpdated(address proxyAddress);
903 }
904 
905 
906 /*
907 -----------------------------------------------------------------
908 FILE INFORMATION
909 -----------------------------------------------------------------
910 
911 file:       ExternStateToken.sol
912 version:    1.0
913 author:     Kevin Brown
914 date:       2018-08-06
915 
916 -----------------------------------------------------------------
917 MODULE DESCRIPTION
918 -----------------------------------------------------------------
919 
920 This contract offers a modifer that can prevent reentrancy on
921 particular actions. It will not work if you put it on multiple
922 functions that can be called from each other. Specifically guard
923 external entry points to the contract with the modifier only.
924 
925 -----------------------------------------------------------------
926 */
927 
928 
929 contract ReentrancyPreventer {
930     /* ========== MODIFIERS ========== */
931     bool isInFunctionBody = false;
932 
933     modifier preventReentrancy {
934         require(!isInFunctionBody, "Reverted to prevent reentrancy");
935         isInFunctionBody = true;
936         _;
937         isInFunctionBody = false;
938     }
939 }
940 
941 /*
942 -----------------------------------------------------------------
943 FILE INFORMATION
944 -----------------------------------------------------------------
945 
946 file:       TokenFallback.sol
947 version:    1.0
948 author:     Kevin Brown
949 date:       2018-08-10
950 
951 -----------------------------------------------------------------
952 MODULE DESCRIPTION
953 -----------------------------------------------------------------
954 
955 This contract provides the logic that's used to call tokenFallback()
956 when transfers happen.
957 
958 It's pulled out into its own module because it's needed in two
959 places, so instead of copy/pasting this logic and maininting it
960 both in Fee Token and Extern State Token, it's here and depended
961 on by both contracts.
962 
963 -----------------------------------------------------------------
964 */
965 
966 
967 contract TokenFallbackCaller is ReentrancyPreventer {
968     function callTokenFallbackIfNeeded(address sender, address recipient, uint amount, bytes data)
969         internal
970         preventReentrancy
971     {
972         /*
973             If we're transferring to a contract and it implements the tokenFallback function, call it.
974             This isn't ERC223 compliant because we don't revert if the contract doesn't implement tokenFallback.
975             This is because many DEXes and other contracts that expect to work with the standard
976             approve / transferFrom workflow don't implement tokenFallback but can still process our tokens as
977             usual, so it feels very harsh and likely to cause trouble if we add this restriction after having
978             previously gone live with a vanilla ERC20.
979         */
980 
981         // Is the to address a contract? We can check the code size on that address and know.
982         uint length;
983 
984         // solium-disable-next-line security/no-inline-assembly
985         assembly {
986             // Retrieve the size of the code on the recipient address
987             length := extcodesize(recipient)
988         }
989 
990         // If there's code there, it's a contract
991         if (length > 0) {
992             // Now we need to optionally call tokenFallback(address from, uint value).
993             // We can't call it the normal way because that reverts when the recipient doesn't implement the function.
994 
995             // solium-disable-next-line security/no-low-level-calls
996             recipient.call(abi.encodeWithSignature("tokenFallback(address,uint256,bytes)", sender, amount, data));
997 
998             // And yes, we specifically don't care if this call fails, so we're not checking the return value.
999         }
1000     }
1001 }
1002 
1003 
1004 /*
1005 -----------------------------------------------------------------
1006 FILE INFORMATION
1007 -----------------------------------------------------------------
1008 
1009 file:       ExternStateToken.sol
1010 version:    1.3
1011 author:     Anton Jurisevic
1012             Dominic Romanowski
1013             Kevin Brown
1014 
1015 date:       2018-05-29
1016 
1017 -----------------------------------------------------------------
1018 MODULE DESCRIPTION
1019 -----------------------------------------------------------------
1020 
1021 A partial ERC20 token contract, designed to operate with a proxy.
1022 To produce a complete ERC20 token, transfer and transferFrom
1023 tokens must be implemented, using the provided _byProxy internal
1024 functions.
1025 This contract utilises an external state for upgradeability.
1026 
1027 -----------------------------------------------------------------
1028 */
1029 
1030 
1031 /**
1032  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
1033  */
1034 contract ExternStateToken is SelfDestructible, Proxyable, TokenFallbackCaller {
1035 
1036     using SafeMath for uint;
1037     using SafeDecimalMath for uint;
1038 
1039     /* ========== STATE VARIABLES ========== */
1040 
1041     /* Stores balances and allowances. */
1042     TokenState public tokenState;
1043 
1044     /* Other ERC20 fields. */
1045     string public name;
1046     string public symbol;
1047     uint public totalSupply;
1048     uint8 public decimals;
1049 
1050     /**
1051      * @dev Constructor.
1052      * @param _proxy The proxy associated with this contract.
1053      * @param _name Token's ERC20 name.
1054      * @param _symbol Token's ERC20 symbol.
1055      * @param _totalSupply The total supply of the token.
1056      * @param _tokenState The TokenState contract address.
1057      * @param _owner The owner of this contract.
1058      */
1059     constructor(address _proxy, TokenState _tokenState,
1060                 string _name, string _symbol, uint _totalSupply,
1061                 uint8 _decimals, address _owner)
1062         SelfDestructible(_owner)
1063         Proxyable(_proxy, _owner)
1064         public
1065     {
1066         tokenState = _tokenState;
1067 
1068         name = _name;
1069         symbol = _symbol;
1070         totalSupply = _totalSupply;
1071         decimals = _decimals;
1072     }
1073 
1074     /* ========== VIEWS ========== */
1075 
1076     /**
1077      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
1078      * @param owner The party authorising spending of their funds.
1079      * @param spender The party spending tokenOwner's funds.
1080      */
1081     function allowance(address owner, address spender)
1082         public
1083         view
1084         returns (uint)
1085     {
1086         return tokenState.allowance(owner, spender);
1087     }
1088 
1089     /**
1090      * @notice Returns the ERC20 token balance of a given account.
1091      */
1092     function balanceOf(address account)
1093         public
1094         view
1095         returns (uint)
1096     {
1097         return tokenState.balanceOf(account);
1098     }
1099 
1100     /* ========== MUTATIVE FUNCTIONS ========== */
1101 
1102     /**
1103      * @notice Set the address of the TokenState contract.
1104      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
1105      * as balances would be unreachable.
1106      */ 
1107     function setTokenState(TokenState _tokenState)
1108         external
1109         optionalProxy_onlyOwner
1110     {
1111         tokenState = _tokenState;
1112         emitTokenStateUpdated(_tokenState);
1113     }
1114 
1115     function _internalTransfer(address from, address to, uint value, bytes data) 
1116         internal
1117         returns (bool)
1118     { 
1119         /* Disallow transfers to irretrievable-addresses. */
1120         require(to != address(0), "Cannot transfer to the 0 address");
1121         require(to != address(this), "Cannot transfer to the underlying contract");
1122         require(to != address(proxy), "Cannot transfer to the proxy contract");
1123 
1124         // Insufficient balance will be handled by the safe subtraction.
1125         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
1126         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
1127 
1128         // If the recipient is a contract, we need to call tokenFallback on it so they can do ERC223
1129         // actions when receiving our tokens. Unlike the standard, however, we don't revert if the
1130         // recipient contract doesn't implement tokenFallback.
1131         callTokenFallbackIfNeeded(from, to, value, data);
1132         
1133         // Emit a standard ERC20 transfer event
1134         emitTransfer(from, to, value);
1135 
1136         return true;
1137     }
1138 
1139     /**
1140      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
1141      * the onlyProxy or optionalProxy modifiers.
1142      */
1143     function _transfer_byProxy(address from, address to, uint value, bytes data)
1144         internal
1145         returns (bool)
1146     {
1147         return _internalTransfer(from, to, value, data);
1148     }
1149 
1150     /**
1151      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
1152      * possessing the optionalProxy or optionalProxy modifiers.
1153      */
1154     function _transferFrom_byProxy(address sender, address from, address to, uint value, bytes data)
1155         internal
1156         returns (bool)
1157     {
1158         /* Insufficient allowance will be handled by the safe subtraction. */
1159         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
1160         return _internalTransfer(from, to, value, data);
1161     }
1162 
1163     /**
1164      * @notice Approves spender to transfer on the message sender's behalf.
1165      */
1166     function approve(address spender, uint value)
1167         public
1168         optionalProxy
1169         returns (bool)
1170     {
1171         address sender = messageSender;
1172 
1173         tokenState.setAllowance(sender, spender, value);
1174         emitApproval(sender, spender, value);
1175         return true;
1176     }
1177 
1178     /* ========== EVENTS ========== */
1179 
1180     event Transfer(address indexed from, address indexed to, uint value);
1181     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
1182     function emitTransfer(address from, address to, uint value) internal {
1183         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
1184     }
1185 
1186     event Approval(address indexed owner, address indexed spender, uint value);
1187     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
1188     function emitApproval(address owner, address spender, uint value) internal {
1189         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
1190     }
1191 
1192     event TokenStateUpdated(address newTokenState);
1193     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
1194     function emitTokenStateUpdated(address newTokenState) internal {
1195         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
1196     }
1197 }
1198 
1199 
1200 /*
1201 -----------------------------------------------------------------
1202 FILE INFORMATION
1203 -----------------------------------------------------------------
1204 
1205 file:       Synth.sol
1206 version:    2.0
1207 author:     Kevin Brown
1208 date:       2018-09-13
1209 
1210 -----------------------------------------------------------------
1211 MODULE DESCRIPTION
1212 -----------------------------------------------------------------
1213 
1214 Synthetix-backed stablecoin contract.
1215 
1216 This contract issues synths, which are tokens that mirror various
1217 flavours of fiat currency.
1218 
1219 Synths are issuable by Synthetix Network Token (SNX) holders who 
1220 have to lock up some value of their SNX to issue S * Cmax synths. 
1221 Where Cmax issome value less than 1.
1222 
1223 A configurable fee is charged on synth transfers and deposited
1224 into a common pot, which Synthetix holders may withdraw from once
1225 per fee period.
1226 
1227 -----------------------------------------------------------------
1228 */
1229 
1230 
1231 contract Synth is ExternStateToken {
1232 
1233     /* ========== STATE VARIABLES ========== */
1234 
1235     FeePool public feePool;
1236     Synthetix public synthetix;
1237 
1238     // Currency key which identifies this Synth to the Synthetix system
1239     bytes4 public currencyKey;
1240 
1241     uint8 constant DECIMALS = 18;
1242 
1243     /* ========== CONSTRUCTOR ========== */
1244 
1245     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, FeePool _feePool,
1246         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey
1247     )
1248         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, 0, DECIMALS, _owner)
1249         public
1250     {
1251         require(_proxy != 0, "_proxy cannot be 0");
1252         require(address(_synthetix) != 0, "_synthetix cannot be 0");
1253         require(address(_feePool) != 0, "_feePool cannot be 0");
1254         require(_owner != 0, "_owner cannot be 0");
1255         require(_synthetix.synths(_currencyKey) == Synth(0), "Currency key is already in use");
1256 
1257         feePool = _feePool;
1258         synthetix = _synthetix;
1259         currencyKey = _currencyKey;
1260     }
1261 
1262     /* ========== SETTERS ========== */
1263 
1264     function setSynthetix(Synthetix _synthetix)
1265         external
1266         optionalProxy_onlyOwner
1267     {
1268         synthetix = _synthetix;
1269         emitSynthetixUpdated(_synthetix);
1270     }
1271 
1272     function setFeePool(FeePool _feePool)
1273         external
1274         optionalProxy_onlyOwner
1275     {
1276         feePool = _feePool;
1277         emitFeePoolUpdated(_feePool);
1278     }
1279 
1280     /* ========== MUTATIVE FUNCTIONS ========== */
1281 
1282     /**
1283      * @notice Override ERC20 transfer function in order to 
1284      * subtract the transaction fee and send it to the fee pool
1285      * for SNX holders to claim. */
1286     function transfer(address to, uint value)
1287         public
1288         optionalProxy
1289         notFeeAddress(messageSender)
1290         returns (bool)
1291     {
1292         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1293         uint fee = value.sub(amountReceived);
1294 
1295         // Send the fee off to the fee pool.
1296         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1297 
1298         // And send their result off to the destination address
1299         bytes memory empty;
1300         return _internalTransfer(messageSender, to, amountReceived, empty);
1301     }
1302 
1303     /**
1304      * @notice Override ERC223 transfer function in order to 
1305      * subtract the transaction fee and send it to the fee pool
1306      * for SNX holders to claim. */
1307     function transfer(address to, uint value, bytes data)
1308         public
1309         optionalProxy
1310         notFeeAddress(messageSender)
1311         returns (bool)
1312     {
1313         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1314         uint fee = value.sub(amountReceived);
1315 
1316         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1317         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1318 
1319         // And send their result off to the destination address
1320         return _internalTransfer(messageSender, to, amountReceived, data);
1321     }
1322 
1323     /**
1324      * @notice Override ERC20 transferFrom function in order to 
1325      * subtract the transaction fee and send it to the fee pool
1326      * for SNX holders to claim. */
1327     function transferFrom(address from, address to, uint value)
1328         public
1329         optionalProxy
1330         notFeeAddress(from)
1331         returns (bool)
1332     {
1333         // The fee is deducted from the amount sent.
1334         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1335         uint fee = value.sub(amountReceived);
1336 
1337         // Reduce the allowance by the amount we're transferring.
1338         // The safeSub call will handle an insufficient allowance.
1339         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1340 
1341         // Send the fee off to the fee pool.
1342         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1343 
1344         bytes memory empty;
1345         return _internalTransfer(from, to, amountReceived, empty);
1346     }
1347 
1348     /**
1349      * @notice Override ERC223 transferFrom function in order to 
1350      * subtract the transaction fee and send it to the fee pool
1351      * for SNX holders to claim. */
1352     function transferFrom(address from, address to, uint value, bytes data)
1353         public
1354         optionalProxy
1355         notFeeAddress(from)
1356         returns (bool)
1357     {
1358         // The fee is deducted from the amount sent.
1359         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1360         uint fee = value.sub(amountReceived);
1361 
1362         // Reduce the allowance by the amount we're transferring.
1363         // The safeSub call will handle an insufficient allowance.
1364         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1365 
1366         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1367         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1368 
1369         return _internalTransfer(from, to, amountReceived, data);
1370     }
1371 
1372     /* Subtract the transfer fee from the senders account so the 
1373      * receiver gets the exact amount specified to send. */
1374     function transferSenderPaysFee(address to, uint value)
1375         public
1376         optionalProxy
1377         notFeeAddress(messageSender)
1378         returns (bool)
1379     {
1380         uint fee = feePool.transferFeeIncurred(value);
1381 
1382         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1383         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1384 
1385         // And send their transfer amount off to the destination address
1386         bytes memory empty;
1387         return _internalTransfer(messageSender, to, value, empty);
1388     }
1389 
1390     /* Subtract the transfer fee from the senders account so the 
1391      * receiver gets the exact amount specified to send. */
1392     function transferSenderPaysFee(address to, uint value, bytes data)
1393         public
1394         optionalProxy
1395         notFeeAddress(messageSender)
1396         returns (bool)
1397     {
1398         uint fee = feePool.transferFeeIncurred(value);
1399 
1400         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1401         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1402 
1403         // And send their transfer amount off to the destination address
1404         return _internalTransfer(messageSender, to, value, data);
1405     }
1406 
1407     /* Subtract the transfer fee from the senders account so the 
1408      * to address receives the exact amount specified to send. */
1409     function transferFromSenderPaysFee(address from, address to, uint value)
1410         public
1411         optionalProxy
1412         notFeeAddress(from)
1413         returns (bool)
1414     {
1415         uint fee = feePool.transferFeeIncurred(value);
1416 
1417         // Reduce the allowance by the amount we're transferring.
1418         // The safeSub call will handle an insufficient allowance.
1419         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
1420 
1421         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1422         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1423 
1424         bytes memory empty;
1425         return _internalTransfer(from, to, value, empty);
1426     }
1427 
1428     /* Subtract the transfer fee from the senders account so the 
1429      * to address receives the exact amount specified to send. */
1430     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
1431         public
1432         optionalProxy
1433         notFeeAddress(from)
1434         returns (bool)
1435     {
1436         uint fee = feePool.transferFeeIncurred(value);
1437 
1438         // Reduce the allowance by the amount we're transferring.
1439         // The safeSub call will handle an insufficient allowance.
1440         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
1441 
1442         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1443         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1444 
1445         return _internalTransfer(from, to, value, data);
1446     }
1447 
1448     // Override our internal transfer to inject preferred currency support
1449     function _internalTransfer(address from, address to, uint value, bytes data)
1450         internal
1451         returns (bool)
1452     {
1453         bytes4 preferredCurrencyKey = synthetix.synthetixState().preferredCurrency(to);
1454 
1455         // Do they have a preferred currency that's not us? If so we need to exchange
1456         if (preferredCurrencyKey != 0 && preferredCurrencyKey != currencyKey) {
1457             return synthetix.synthInitiatedExchange(from, currencyKey, value, preferredCurrencyKey, to);
1458         } else {
1459             // Otherwise we just transfer
1460             return super._internalTransfer(from, to, value, data);
1461         }
1462     }
1463 
1464     // Allow synthetix to issue a certain number of synths from an account.
1465     function issue(address account, uint amount)
1466         external
1467         onlySynthetixOrFeePool
1468     {
1469         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
1470         totalSupply = totalSupply.add(amount);
1471         emitTransfer(address(0), account, amount);
1472         emitIssued(account, amount);
1473     }
1474 
1475     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
1476     function burn(address account, uint amount)
1477         external
1478         onlySynthetixOrFeePool
1479     {
1480         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
1481         totalSupply = totalSupply.sub(amount);
1482         emitTransfer(account, address(0), amount);
1483         emitBurned(account, amount);
1484     }
1485 
1486     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
1487     // exchange as well as transfer
1488     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
1489         external
1490         onlySynthetixOrFeePool
1491     {
1492         bytes memory empty;
1493         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
1494     }
1495 
1496     /* ========== MODIFIERS ========== */
1497 
1498     modifier onlySynthetixOrFeePool() {
1499         bool isSynthetix = msg.sender == address(synthetix);
1500         bool isFeePool = msg.sender == address(feePool);
1501 
1502         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
1503         _;
1504     }
1505 
1506     modifier notFeeAddress(address account) {
1507         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
1508         _;
1509     }
1510 
1511     /* ========== EVENTS ========== */
1512 
1513     event SynthetixUpdated(address newSynthetix);
1514     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
1515     function emitSynthetixUpdated(address newSynthetix) internal {
1516         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
1517     }
1518 
1519     event FeePoolUpdated(address newFeePool);
1520     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
1521     function emitFeePoolUpdated(address newFeePool) internal {
1522         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
1523     }
1524 
1525     event Issued(address indexed account, uint value);
1526     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
1527     function emitIssued(address account, uint value) internal {
1528         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
1529     }
1530 
1531     event Burned(address indexed account, uint value);
1532     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
1533     function emitBurned(address account, uint value) internal {
1534         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
1535     }
1536 }
1537 
1538 
1539 /*
1540 -----------------------------------------------------------------
1541 FILE INFORMATION
1542 -----------------------------------------------------------------
1543 
1544 file:       LimitedSetup.sol
1545 version:    1.1
1546 author:     Anton Jurisevic
1547 
1548 date:       2018-05-15
1549 
1550 -----------------------------------------------------------------
1551 MODULE DESCRIPTION
1552 -----------------------------------------------------------------
1553 
1554 A contract with a limited setup period. Any function modified
1555 with the setup modifier will cease to work after the
1556 conclusion of the configurable-length post-construction setup period.
1557 
1558 -----------------------------------------------------------------
1559 */
1560 
1561 
1562 /**
1563  * @title Any function decorated with the modifier this contract provides
1564  * deactivates after a specified setup period.
1565  */
1566 contract LimitedSetup {
1567 
1568     uint setupExpiryTime;
1569 
1570     /**
1571      * @dev LimitedSetup Constructor.
1572      * @param setupDuration The time the setup period will last for.
1573      */
1574     constructor(uint setupDuration)
1575         public
1576     {
1577         setupExpiryTime = now + setupDuration;
1578     }
1579 
1580     modifier onlyDuringSetup
1581     {
1582         require(now < setupExpiryTime, "Can only perform this action during setup");
1583         _;
1584     }
1585 }
1586 
1587 
1588 /*
1589 -----------------------------------------------------------------
1590 FILE INFORMATION
1591 -----------------------------------------------------------------
1592 
1593 file:       SynthetixEscrow.sol
1594 version:    1.1
1595 author:     Anton Jurisevic
1596             Dominic Romanowski
1597             Mike Spain
1598 
1599 date:       2018-05-29
1600 
1601 -----------------------------------------------------------------
1602 MODULE DESCRIPTION
1603 -----------------------------------------------------------------
1604 
1605 This contract allows the foundation to apply unique vesting
1606 schedules to synthetix funds sold at various discounts in the token
1607 sale. SynthetixEscrow gives users the ability to inspect their
1608 vested funds, their quantities and vesting dates, and to withdraw
1609 the fees that accrue on those funds.
1610 
1611 The fees are handled by withdrawing the entire fee allocation
1612 for all SNX inside the escrow contract, and then allowing
1613 the contract itself to subdivide that pool up proportionally within
1614 itself. Every time the fee period rolls over in the main Synthetix
1615 contract, the SynthetixEscrow fee pool is remitted back into the
1616 main fee pool to be redistributed in the next fee period.
1617 
1618 -----------------------------------------------------------------
1619 */
1620 
1621 
1622 /**
1623  * @title A contract to hold escrowed SNX and free them at given schedules.
1624  */
1625 contract SynthetixEscrow is Owned, LimitedSetup(8 weeks) {
1626 
1627     using SafeMath for uint;
1628 
1629     /* The corresponding Synthetix contract. */
1630     Synthetix public synthetix;
1631 
1632     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
1633      * These are the times at which each given quantity of SNX vests. */
1634     mapping(address => uint[2][]) public vestingSchedules;
1635 
1636     /* An account's total vested synthetix balance to save recomputing this for fee extraction purposes. */
1637     mapping(address => uint) public totalVestedAccountBalance;
1638 
1639     /* The total remaining vested balance, for verifying the actual synthetix balance of this contract against. */
1640     uint public totalVestedBalance;
1641 
1642     uint constant TIME_INDEX = 0;
1643     uint constant QUANTITY_INDEX = 1;
1644 
1645     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
1646     uint constant MAX_VESTING_ENTRIES = 20;
1647 
1648 
1649     /* ========== CONSTRUCTOR ========== */
1650 
1651     constructor(address _owner, Synthetix _synthetix)
1652         Owned(_owner)
1653         public
1654     {
1655         synthetix = _synthetix;
1656     }
1657 
1658 
1659     /* ========== SETTERS ========== */
1660 
1661     function setSynthetix(Synthetix _synthetix)
1662         external
1663         onlyOwner
1664     {
1665         synthetix = _synthetix;
1666         emit SynthetixUpdated(_synthetix);
1667     }
1668 
1669 
1670     /* ========== VIEW FUNCTIONS ========== */
1671 
1672     /**
1673      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
1674      */
1675     function balanceOf(address account)
1676         public
1677         view
1678         returns (uint)
1679     {
1680         return totalVestedAccountBalance[account];
1681     }
1682 
1683     /**
1684      * @notice The number of vesting dates in an account's schedule.
1685      */
1686     function numVestingEntries(address account)
1687         public
1688         view
1689         returns (uint)
1690     {
1691         return vestingSchedules[account].length;
1692     }
1693 
1694     /**
1695      * @notice Get a particular schedule entry for an account.
1696      * @return A pair of uints: (timestamp, synthetix quantity).
1697      */
1698     function getVestingScheduleEntry(address account, uint index)
1699         public
1700         view
1701         returns (uint[2])
1702     {
1703         return vestingSchedules[account][index];
1704     }
1705 
1706     /**
1707      * @notice Get the time at which a given schedule entry will vest.
1708      */
1709     function getVestingTime(address account, uint index)
1710         public
1711         view
1712         returns (uint)
1713     {
1714         return getVestingScheduleEntry(account,index)[TIME_INDEX];
1715     }
1716 
1717     /**
1718      * @notice Get the quantity of SNX associated with a given schedule entry.
1719      */
1720     function getVestingQuantity(address account, uint index)
1721         public
1722         view
1723         returns (uint)
1724     {
1725         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
1726     }
1727 
1728     /**
1729      * @notice Obtain the index of the next schedule entry that will vest for a given user.
1730      */
1731     function getNextVestingIndex(address account)
1732         public
1733         view
1734         returns (uint)
1735     {
1736         uint len = numVestingEntries(account);
1737         for (uint i = 0; i < len; i++) {
1738             if (getVestingTime(account, i) != 0) {
1739                 return i;
1740             }
1741         }
1742         return len;
1743     }
1744 
1745     /**
1746      * @notice Obtain the next schedule entry that will vest for a given user.
1747      * @return A pair of uints: (timestamp, synthetix quantity). */
1748     function getNextVestingEntry(address account)
1749         public
1750         view
1751         returns (uint[2])
1752     {
1753         uint index = getNextVestingIndex(account);
1754         if (index == numVestingEntries(account)) {
1755             return [uint(0), 0];
1756         }
1757         return getVestingScheduleEntry(account, index);
1758     }
1759 
1760     /**
1761      * @notice Obtain the time at which the next schedule entry will vest for a given user.
1762      */
1763     function getNextVestingTime(address account)
1764         external
1765         view
1766         returns (uint)
1767     {
1768         return getNextVestingEntry(account)[TIME_INDEX];
1769     }
1770 
1771     /**
1772      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
1773      */
1774     function getNextVestingQuantity(address account)
1775         external
1776         view
1777         returns (uint)
1778     {
1779         return getNextVestingEntry(account)[QUANTITY_INDEX];
1780     }
1781 
1782 
1783     /* ========== MUTATIVE FUNCTIONS ========== */
1784 
1785     /**
1786      * @notice Withdraws a quantity of SNX back to the synthetix contract.
1787      * @dev This may only be called by the owner during the contract's setup period.
1788      */
1789     function withdrawSynthetix(uint quantity)
1790         external
1791         onlyOwner
1792         onlyDuringSetup
1793     {
1794         synthetix.transfer(synthetix, quantity);
1795     }
1796 
1797     /**
1798      * @notice Destroy the vesting information associated with an account.
1799      */
1800     function purgeAccount(address account)
1801         external
1802         onlyOwner
1803         onlyDuringSetup
1804     {
1805         delete vestingSchedules[account];
1806         totalVestedBalance = totalVestedBalance.sub(totalVestedAccountBalance[account]);
1807         delete totalVestedAccountBalance[account];
1808     }
1809 
1810     /**
1811      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
1812      * @dev A call to this should be accompanied by either enough balance already available
1813      * in this contract, or a corresponding call to synthetix.endow(), to ensure that when
1814      * the funds are withdrawn, there is enough balance, as well as correctly calculating
1815      * the fees.
1816      * This may only be called by the owner during the contract's setup period.
1817      * Note; although this function could technically be used to produce unbounded
1818      * arrays, it's only in the foundation's command to add to these lists.
1819      * @param account The account to append a new vesting entry to.
1820      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
1821      * @param quantity The quantity of SNX that will vest.
1822      */
1823     function appendVestingEntry(address account, uint time, uint quantity)
1824         public
1825         onlyOwner
1826         onlyDuringSetup
1827     {
1828         /* No empty or already-passed vesting entries allowed. */
1829         require(now < time, "Time must be in the future");
1830         require(quantity != 0, "Quantity cannot be zero");
1831 
1832         /* There must be enough balance in the contract to provide for the vesting entry. */
1833         totalVestedBalance = totalVestedBalance.add(quantity);
1834         require(totalVestedBalance <= synthetix.balanceOf(this), "Must be enough balance in the contract to provide for the vesting entry");
1835 
1836         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
1837         uint scheduleLength = vestingSchedules[account].length;
1838         require(scheduleLength <= MAX_VESTING_ENTRIES, "Vesting schedule is too long");
1839 
1840         if (scheduleLength == 0) {
1841             totalVestedAccountBalance[account] = quantity;
1842         } else {
1843             /* Disallow adding new vested SNX earlier than the last one.
1844              * Since entries are only appended, this means that no vesting date can be repeated. */
1845             require(getVestingTime(account, numVestingEntries(account) - 1) < time, "Cannot add new vested entries earlier than the last one");
1846             totalVestedAccountBalance[account] = totalVestedAccountBalance[account].add(quantity);
1847         }
1848 
1849         vestingSchedules[account].push([time, quantity]);
1850     }
1851 
1852     /**
1853      * @notice Construct a vesting schedule to release a quantities of SNX
1854      * over a series of intervals.
1855      * @dev Assumes that the quantities are nonzero
1856      * and that the sequence of timestamps is strictly increasing.
1857      * This may only be called by the owner during the contract's setup period.
1858      */
1859     function addVestingSchedule(address account, uint[] times, uint[] quantities)
1860         external
1861         onlyOwner
1862         onlyDuringSetup
1863     {
1864         for (uint i = 0; i < times.length; i++) {
1865             appendVestingEntry(account, times[i], quantities[i]);
1866         }
1867 
1868     }
1869 
1870     /**
1871      * @notice Allow a user to withdraw any SNX in their schedule that have vested.
1872      */
1873     function vest()
1874         external
1875     {
1876         uint numEntries = numVestingEntries(msg.sender);
1877         uint total;
1878         for (uint i = 0; i < numEntries; i++) {
1879             uint time = getVestingTime(msg.sender, i);
1880             /* The list is sorted; when we reach the first future time, bail out. */
1881             if (time > now) {
1882                 break;
1883             }
1884             uint qty = getVestingQuantity(msg.sender, i);
1885             if (qty == 0) {
1886                 continue;
1887             }
1888 
1889             vestingSchedules[msg.sender][i] = [0, 0];
1890             total = total.add(qty);
1891         }
1892 
1893         if (total != 0) {
1894             totalVestedBalance = totalVestedBalance.sub(total);
1895             totalVestedAccountBalance[msg.sender] = totalVestedAccountBalance[msg.sender].sub(total);
1896             synthetix.transfer(msg.sender, total);
1897             emit Vested(msg.sender, now, total);
1898         }
1899     }
1900 
1901 
1902     /* ========== EVENTS ========== */
1903 
1904     event SynthetixUpdated(address newSynthetix);
1905 
1906     event Vested(address indexed beneficiary, uint time, uint value);
1907 }
1908 
1909 
1910 /*
1911 -----------------------------------------------------------------
1912 FILE INFORMATION
1913 -----------------------------------------------------------------
1914 
1915 file:       SynthetixState.sol
1916 version:    1.0
1917 author:     Kevin Brown
1918 date:       2018-10-19
1919 
1920 -----------------------------------------------------------------
1921 MODULE DESCRIPTION
1922 -----------------------------------------------------------------
1923 
1924 A contract that holds issuance state and preferred currency of
1925 users in the Synthetix system.
1926 
1927 This contract is used side by side with the Synthetix contract
1928 to make it easier to upgrade the contract logic while maintaining
1929 issuance state.
1930 
1931 The Synthetix contract is also quite large and on the edge of
1932 being beyond the contract size limit without moving this information
1933 out to another contract.
1934 
1935 The first deployed contract would create this state contract,
1936 using it as its store of issuance data.
1937 
1938 When a new contract is deployed, it links to the existing
1939 state contract, whose owner would then change its associated
1940 contract to the new one.
1941 
1942 -----------------------------------------------------------------
1943 */
1944 
1945 
1946 /**
1947  * @title Synthetix State
1948  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
1949  */
1950 contract SynthetixState is State, LimitedSetup {
1951     using SafeMath for uint;
1952     using SafeDecimalMath for uint;
1953 
1954     // A struct for handing values associated with an individual user's debt position
1955     struct IssuanceData {
1956         // Percentage of the total debt owned at the time
1957         // of issuance. This number is modified by the global debt
1958         // delta array. You can figure out a user's exit price and
1959         // collateralisation ratio using a combination of their initial
1960         // debt and the slice of global debt delta which applies to them.
1961         uint initialDebtOwnership;
1962         // This lets us know when (in relative terms) the user entered
1963         // the debt pool so we can calculate their exit price and
1964         // collateralistion ratio
1965         uint debtEntryIndex;
1966     }
1967 
1968     // Issued synth balances for individual fee entitlements and exit price calculations
1969     mapping(address => IssuanceData) public issuanceData;
1970 
1971     // The total count of people that have outstanding issued synths in any flavour
1972     uint public totalIssuerCount;
1973 
1974     // Global debt pool tracking
1975     uint[] public debtLedger;
1976 
1977     // A quantity of synths greater than this ratio
1978     // may not be issued against a given value of SNX.
1979     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
1980     // No more synths may be issued than the value of SNX backing them.
1981     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
1982 
1983     // Users can specify their preferred currency, in which case all synths they receive
1984     // will automatically exchange to that preferred currency upon receipt in their wallet
1985     mapping(address => bytes4) public preferredCurrency;
1986 
1987     /**
1988      * @dev Constructor
1989      * @param _owner The address which controls this contract.
1990      * @param _associatedContract The ERC20 contract whose state this composes.
1991      */
1992     constructor(address _owner, address _associatedContract)
1993         State(_owner, _associatedContract)
1994         LimitedSetup(1 weeks)
1995         public
1996     {}
1997 
1998     /* ========== SETTERS ========== */
1999 
2000     /**
2001      * @notice Set issuance data for an address
2002      * @dev Only the associated contract may call this.
2003      * @param account The address to set the data for.
2004      * @param initialDebtOwnership The initial debt ownership for this address.
2005      */
2006     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
2007         external
2008         onlyAssociatedContract
2009     {
2010         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
2011         issuanceData[account].debtEntryIndex = debtLedger.length;
2012     }
2013 
2014     /**
2015      * @notice Clear issuance data for an address
2016      * @dev Only the associated contract may call this.
2017      * @param account The address to clear the data for.
2018      */
2019     function clearIssuanceData(address account)
2020         external
2021         onlyAssociatedContract
2022     {
2023         delete issuanceData[account];
2024     }
2025 
2026     /**
2027      * @notice Increment the total issuer count
2028      * @dev Only the associated contract may call this.
2029      */
2030     function incrementTotalIssuerCount()
2031         external
2032         onlyAssociatedContract
2033     {
2034         totalIssuerCount = totalIssuerCount.add(1);
2035     }
2036 
2037     /**
2038      * @notice Decrement the total issuer count
2039      * @dev Only the associated contract may call this.
2040      */
2041     function decrementTotalIssuerCount()
2042         external
2043         onlyAssociatedContract
2044     {
2045         totalIssuerCount = totalIssuerCount.sub(1);
2046     }
2047 
2048     /**
2049      * @notice Append a value to the debt ledger
2050      * @dev Only the associated contract may call this.
2051      * @param value The new value to be added to the debt ledger.
2052      */
2053     function appendDebtLedgerValue(uint value)
2054         external
2055         onlyAssociatedContract
2056     {
2057         debtLedger.push(value);
2058     }
2059 
2060     /**
2061      * @notice Set preferred currency for a user
2062      * @dev Only the associated contract may call this.
2063      * @param account The account to set the preferred currency for
2064      * @param currencyKey The new preferred currency
2065      */
2066     function setPreferredCurrency(address account, bytes4 currencyKey)
2067         external
2068         onlyAssociatedContract
2069     {
2070         preferredCurrency[account] = currencyKey;
2071     }
2072 
2073     /**
2074      * @notice Set the issuanceRatio for issuance calculations.
2075      * @dev Only callable by the contract owner.
2076      */
2077     function setIssuanceRatio(uint _issuanceRatio)
2078         external
2079         onlyOwner
2080     {
2081         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
2082         issuanceRatio = _issuanceRatio;
2083         emit IssuanceRatioUpdated(_issuanceRatio);
2084     }
2085 
2086     /**
2087      * @notice Import issuer data from the old Synthetix contract before multicurrency
2088      * @dev Only callable by the contract owner, and only for 1 week after deployment.
2089      */
2090     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
2091         external
2092         onlyOwner
2093         onlyDuringSetup
2094     {
2095         require(accounts.length == sUSDAmounts.length, "Length mismatch");
2096 
2097         for (uint8 i = 0; i < accounts.length; i++) {
2098             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
2099         }
2100     }
2101 
2102     /**
2103      * @notice Import issuer data from the old Synthetix contract before multicurrency
2104      * @dev Only used from importIssuerData above, meant to be disposable
2105      */
2106     function _addToDebtRegister(address account, uint amount)
2107         internal
2108     {
2109         // This code is duplicated from Synthetix so that we can call it directly here
2110         // during setup only.
2111         Synthetix synthetix = Synthetix(associatedContract);
2112 
2113         // What is the value of the requested debt in XDRs?
2114         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
2115 
2116         // What is the value of all issued synths of the system (priced in XDRs)?
2117         uint totalDebtIssued = synthetix.totalIssuedSynths("XDR");
2118 
2119         // What will the new total be including the new value?
2120         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2121 
2122         // What is their percentage (as a high precision int) of the total debt?
2123         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2124 
2125         // And what effect does this percentage have on the global debt holding of other issuers?
2126         // The delta specifically needs to not take into account any existing debt as it's already
2127         // accounted for in the delta from when they issued previously.
2128         // The delta is a high precision integer.
2129         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2130 
2131         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
2132 
2133         // And what does their debt ownership look like including this previous stake?
2134         if (existingDebt > 0) {
2135             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2136         }
2137 
2138         // Are they a new issuer? If so, record them.
2139         if (issuanceData[account].initialDebtOwnership == 0) {
2140             totalIssuerCount = totalIssuerCount.add(1);
2141         }
2142 
2143         // Save the debt entry parameters
2144         issuanceData[account].initialDebtOwnership = debtPercentage;
2145         issuanceData[account].debtEntryIndex = debtLedger.length;
2146 
2147         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2148         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2149         if (debtLedger.length > 0) {
2150             debtLedger.push(
2151                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2152             );
2153         } else {
2154             debtLedger.push(SafeDecimalMath.preciseUnit());
2155         }
2156     }
2157 
2158     /* ========== VIEWS ========== */
2159 
2160     /**
2161      * @notice Retrieve the length of the debt ledger array
2162      */
2163     function debtLedgerLength()
2164         external
2165         view
2166         returns (uint)
2167     {
2168         return debtLedger.length;
2169     }
2170 
2171     /**
2172      * @notice Retrieve the most recent entry from the debt ledger
2173      */
2174     function lastDebtLedgerEntry()
2175         external
2176         view
2177         returns (uint)
2178     {
2179         return debtLedger[debtLedger.length - 1];
2180     }
2181 
2182     /**
2183      * @notice Query whether an account has issued and has an outstanding debt balance
2184      * @param account The address to query for
2185      */
2186     function hasIssued(address account)
2187         external
2188         view
2189         returns (bool)
2190     {
2191         return issuanceData[account].initialDebtOwnership > 0;
2192     }
2193 
2194     event IssuanceRatioUpdated(uint newRatio);
2195 }
2196 
2197 
2198 /*
2199 -----------------------------------------------------------------
2200 FILE INFORMATION
2201 -----------------------------------------------------------------
2202 
2203 file:       ExchangeRates.sol
2204 version:    1.0
2205 author:     Kevin Brown
2206 date:       2018-09-12
2207 
2208 -----------------------------------------------------------------
2209 MODULE DESCRIPTION
2210 -----------------------------------------------------------------
2211 
2212 A contract that any other contract in the Synthetix system can query
2213 for the current market value of various assets, including
2214 crypto assets as well as various fiat assets.
2215 
2216 This contract assumes that rate updates will completely update
2217 all rates to their current values. If a rate shock happens
2218 on a single asset, the oracle will still push updated rates
2219 for all other assets.
2220 
2221 -----------------------------------------------------------------
2222 */
2223 
2224 
2225 /**
2226  * @title The repository for exchange rates
2227  */
2228 contract ExchangeRates is SelfDestructible {
2229 
2230     using SafeMath for uint;
2231 
2232     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
2233     mapping(bytes4 => uint) public rates;
2234 
2235     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
2236     mapping(bytes4 => uint) public lastRateUpdateTimes;
2237 
2238     // The address of the oracle which pushes rate updates to this contract
2239     address public oracle;
2240 
2241     // Do not allow the oracle to submit times any further forward into the future than this constant.
2242     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
2243 
2244     // How long will the contract assume the rate of any asset is correct
2245     uint public rateStalePeriod = 3 hours;
2246 
2247     // Each participating currency in the XDR basket is represented as a currency key with
2248     // equal weighting.
2249     // There are 5 participating currencies, so we'll declare that clearly.
2250     bytes4[5] public xdrParticipants;
2251 
2252     //
2253     // ========== CONSTRUCTOR ==========
2254 
2255     /**
2256      * @dev Constructor
2257      * @param _owner The owner of this contract.
2258      * @param _oracle The address which is able to update rate information.
2259      * @param _currencyKeys The initial currency keys to store (in order).
2260      * @param _newRates The initial currency amounts for each currency (in order).
2261      */
2262     constructor(
2263         // SelfDestructible (Ownable)
2264         address _owner,
2265 
2266         // Oracle values - Allows for rate updates
2267         address _oracle,
2268         bytes4[] _currencyKeys,
2269         uint[] _newRates
2270     )
2271         /* Owned is initialised in SelfDestructible */
2272         SelfDestructible(_owner)
2273         public
2274     {
2275         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
2276 
2277         oracle = _oracle;
2278 
2279         // The sUSD rate is always 1 and is never stale.
2280         rates["sUSD"] = SafeDecimalMath.unit();
2281         lastRateUpdateTimes["sUSD"] = now;
2282 
2283         // These are the currencies that make up the XDR basket.
2284         // These are hard coded because:
2285         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
2286         //  - Adding new currencies would likely introduce some kind of weighting factor, which
2287         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
2288         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
2289         //    then point the system at the new version.
2290         xdrParticipants = [
2291             bytes4("sUSD"),
2292             bytes4("sAUD"),
2293             bytes4("sCHF"),
2294             bytes4("sEUR"),
2295             bytes4("sGBP")
2296         ];
2297 
2298         internalUpdateRates(_currencyKeys, _newRates, now);
2299     }
2300 
2301     /* ========== SETTERS ========== */
2302 
2303     /**
2304      * @notice Set the rates stored in this contract
2305      * @param currencyKeys The currency keys you wish to update the rates for (in order)
2306      * @param newRates The rates for each currency (in order)
2307      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
2308      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
2309      *                 if it takes a long time for the transaction to confirm.
2310      */
2311     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
2312         external
2313         onlyOracle
2314         returns(bool)
2315     {
2316         return internalUpdateRates(currencyKeys, newRates, timeSent);
2317     }
2318 
2319     /**
2320      * @notice Internal function which sets the rates stored in this contract
2321      * @param currencyKeys The currency keys you wish to update the rates for (in order)
2322      * @param newRates The rates for each currency (in order)
2323      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
2324      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
2325      *                 if it takes a long time for the transaction to confirm.
2326      */
2327     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
2328         internal
2329         returns(bool)
2330     {
2331         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
2332         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
2333 
2334         // Loop through each key and perform update.
2335         for (uint i = 0; i < currencyKeys.length; i++) {
2336             // Should not set any rate to zero ever, as no asset will ever be
2337             // truely worthless and still valid. In this scenario, we should
2338             // delete the rate and remove it from the system.
2339             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
2340             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
2341 
2342             // We should only update the rate if it's at least the same age as the last rate we've got.
2343             if (timeSent >= lastRateUpdateTimes[currencyKeys[i]]) {
2344                 // Ok, go ahead with the update.
2345                 rates[currencyKeys[i]] = newRates[i];
2346                 lastRateUpdateTimes[currencyKeys[i]] = timeSent;
2347             }
2348         }
2349 
2350         emit RatesUpdated(currencyKeys, newRates);
2351 
2352         // Now update our XDR rate.
2353         updateXDRRate(timeSent);
2354 
2355         return true;
2356     }
2357 
2358     /**
2359      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
2360      */
2361     function updateXDRRate(uint timeSent)
2362         internal
2363     {
2364         uint total = 0;
2365 
2366         for (uint i = 0; i < xdrParticipants.length; i++) {
2367             total = rates[xdrParticipants[i]].add(total);
2368         }
2369 
2370         // Set the rate
2371         rates["XDR"] = total;
2372 
2373         // Record that we updated the XDR rate.
2374         lastRateUpdateTimes["XDR"] = timeSent;
2375 
2376         // Emit our updated event separate to the others to save
2377         // moving data around between arrays.
2378         bytes4[] memory eventCurrencyCode = new bytes4[](1);
2379         eventCurrencyCode[0] = "XDR";
2380 
2381         uint[] memory eventRate = new uint[](1);
2382         eventRate[0] = rates["XDR"];
2383 
2384         emit RatesUpdated(eventCurrencyCode, eventRate);
2385     }
2386 
2387     /**
2388      * @notice Delete a rate stored in the contract
2389      * @param currencyKey The currency key you wish to delete the rate for
2390      */
2391     function deleteRate(bytes4 currencyKey)
2392         external
2393         onlyOracle
2394     {
2395         require(rates[currencyKey] > 0, "Rate is zero");
2396 
2397         delete rates[currencyKey];
2398         delete lastRateUpdateTimes[currencyKey];
2399 
2400         emit RateDeleted(currencyKey);
2401     }
2402 
2403     /**
2404      * @notice Set the Oracle that pushes the rate information to this contract
2405      * @param _oracle The new oracle address
2406      */
2407     function setOracle(address _oracle)
2408         external
2409         onlyOwner
2410     {
2411         oracle = _oracle;
2412         emit OracleUpdated(oracle);
2413     }
2414 
2415     /**
2416      * @notice Set the stale period on the updated rate variables
2417      * @param _time The new rateStalePeriod
2418      */
2419     function setRateStalePeriod(uint _time)
2420         external
2421         onlyOwner
2422     {
2423         rateStalePeriod = _time;
2424         emit RateStalePeriodUpdated(rateStalePeriod);
2425     }
2426 
2427     /* ========== VIEWS ========== */
2428 
2429     /**
2430      * @notice Retrieve the rate for a specific currency
2431      */
2432     function rateForCurrency(bytes4 currencyKey)
2433         public
2434         view
2435         returns (uint)
2436     {
2437         return rates[currencyKey];
2438     }
2439 
2440     /**
2441      * @notice Retrieve the rates for a list of currencies
2442      */
2443     function ratesForCurrencies(bytes4[] currencyKeys)
2444         public
2445         view
2446         returns (uint[])
2447     {
2448         uint[] memory _rates = new uint[](currencyKeys.length);
2449 
2450         for (uint8 i = 0; i < currencyKeys.length; i++) {
2451             _rates[i] = rates[currencyKeys[i]];
2452         }
2453 
2454         return _rates;
2455     }
2456 
2457     /**
2458      * @notice Retrieve a list of last update times for specific currencies
2459      */
2460     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
2461         public
2462         view
2463         returns (uint)
2464     {
2465         return lastRateUpdateTimes[currencyKey];
2466     }
2467 
2468     /**
2469      * @notice Retrieve the last update time for a specific currency
2470      */
2471     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
2472         public
2473         view
2474         returns (uint[])
2475     {
2476         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
2477 
2478         for (uint8 i = 0; i < currencyKeys.length; i++) {
2479             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
2480         }
2481 
2482         return lastUpdateTimes;
2483     }
2484 
2485     /**
2486      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
2487      */
2488     function rateIsStale(bytes4 currencyKey)
2489         external
2490         view
2491         returns (bool)
2492     {
2493         // sUSD is a special case and is never stale.
2494         if (currencyKey == "sUSD") return false;
2495 
2496         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
2497     }
2498 
2499     /**
2500      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
2501      */
2502     function anyRateIsStale(bytes4[] currencyKeys)
2503         external
2504         view
2505         returns (bool)
2506     {
2507         // Loop through each key and check whether the data point is stale.
2508         uint256 i = 0;
2509 
2510         while (i < currencyKeys.length) {
2511             // sUSD is a special case and is never false
2512             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
2513                 return true;
2514             }
2515             i += 1;
2516         }
2517 
2518         return false;
2519     }
2520 
2521     /* ========== MODIFIERS ========== */
2522 
2523     modifier onlyOracle
2524     {
2525         require(msg.sender == oracle, "Only the oracle can perform this action");
2526         _;
2527     }
2528 
2529     /* ========== EVENTS ========== */
2530 
2531     event OracleUpdated(address newOracle);
2532     event RateStalePeriodUpdated(uint rateStalePeriod);
2533     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
2534     event RateDeleted(bytes4 currencyKey);
2535 }
2536 
2537 
2538 /*
2539 -----------------------------------------------------------------
2540 FILE INFORMATION
2541 -----------------------------------------------------------------
2542 
2543 file:       Synthetix.sol
2544 version:    2.0
2545 author:     Kevin Brown
2546             Gavin Conway
2547 date:       2018-09-14
2548 
2549 -----------------------------------------------------------------
2550 MODULE DESCRIPTION
2551 -----------------------------------------------------------------
2552 
2553 Synthetix token contract. SNX is a transferable ERC20 token,
2554 and also give its holders the following privileges.
2555 An owner of SNX has the right to issue synths in all synth flavours.
2556 
2557 After a fee period terminates, the duration and fees collected for that
2558 period are computed, and the next period begins. Thus an account may only
2559 withdraw the fees owed to them for the previous period, and may only do
2560 so once per period. Any unclaimed fees roll over into the common pot for
2561 the next period.
2562 
2563 == Average Balance Calculations ==
2564 
2565 The fee entitlement of a synthetix holder is proportional to their average
2566 issued synth balance over the last fee period. This is computed by
2567 measuring the area under the graph of a user's issued synth balance over
2568 time, and then when a new fee period begins, dividing through by the
2569 duration of the fee period.
2570 
2571 We need only update values when the balances of an account is modified.
2572 This occurs when issuing or burning for issued synth balances,
2573 and when transferring for synthetix balances. This is for efficiency,
2574 and adds an implicit friction to interacting with SNX.
2575 A synthetix holder pays for his own recomputation whenever he wants to change
2576 his position, which saves the foundation having to maintain a pot dedicated
2577 to resourcing this.
2578 
2579 A hypothetical user's balance history over one fee period, pictorially:
2580 
2581       s ____
2582        |    |
2583        |    |___ p
2584        |____|___|___ __ _  _
2585        f    t   n
2586 
2587 Here, the balance was s between times f and t, at which time a transfer
2588 occurred, updating the balance to p, until n, when the present transfer occurs.
2589 When a new transfer occurs at time n, the balance being p,
2590 we must:
2591 
2592   - Add the area p * (n - t) to the total area recorded so far
2593   - Update the last transfer time to n
2594 
2595 So if this graph represents the entire current fee period,
2596 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
2597 The complementary computations must be performed for both sender and
2598 recipient.
2599 
2600 Note that a transfer keeps global supply of SNX invariant.
2601 The sum of all balances is constant, and unmodified by any transfer.
2602 So the sum of all balances multiplied by the duration of a fee period is also
2603 constant, and this is equivalent to the sum of the area of every user's
2604 time/balance graph. Dividing through by that duration yields back the total
2605 synthetix supply. So, at the end of a fee period, we really do yield a user's
2606 average share in the synthetix supply over that period.
2607 
2608 A slight wrinkle is introduced if we consider the time r when the fee period
2609 rolls over. Then the previous fee period k-1 is before r, and the current fee
2610 period k is afterwards. If the last transfer took place before r,
2611 but the latest transfer occurred afterwards:
2612 
2613 k-1       |        k
2614       s __|_
2615        |  | |
2616        |  | |____ p
2617        |__|_|____|___ __ _  _
2618           |
2619        f  | t    n
2620           r
2621 
2622 In this situation the area (r-f)*s contributes to fee period k-1, while
2623 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2624 zero-value transfer to have occurred at time r. Their fee entitlement for the
2625 previous period will be finalised at the time of their first transfer during the
2626 current fee period, or when they query or withdraw their fee entitlement.
2627 
2628 In the implementation, the duration of different fee periods may be slightly irregular,
2629 as the check that they have rolled over occurs only when state-changing synthetix
2630 operations are performed.
2631 
2632 == Issuance and Burning ==
2633 
2634 In this version of the synthetix contract, synths can only be issued by
2635 those that have been nominated by the synthetix foundation. Synths are assumed
2636 to be valued at $1, as they are a stable unit of account.
2637 
2638 All synths issued require a proportional value of SNX to be locked,
2639 where the proportion is governed by the current issuance ratio. This
2640 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
2641 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
2642 
2643 To determine the value of some amount of SNX(S), an oracle is used to push
2644 the price of SNX (P_S) in dollars to the contract. The value of S
2645 would then be: S * P_S.
2646 
2647 Any SNX that are locked up by this issuance process cannot be transferred.
2648 The amount that is locked floats based on the price of SNX. If the price
2649 of SNX moves up, less SNX are locked, so they can be issued against,
2650 or transferred freely. If the price of SNX moves down, more SNX are locked,
2651 even going above the initial wallet balance.
2652 
2653 -----------------------------------------------------------------
2654 */
2655 
2656 
2657 /**
2658  * @title Synthetix ERC20 contract.
2659  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2660  * but it also computes the quantity of fees each synthetix holder is entitled to.
2661  */
2662 contract Synthetix is ExternStateToken {
2663 
2664     // ========== STATE VARIABLES ==========
2665 
2666     // Available Synths which can be used with the system
2667     Synth[] public availableSynths;
2668     mapping(bytes4 => Synth) public synths;
2669 
2670     FeePool public feePool;
2671     SynthetixEscrow public escrow;
2672     ExchangeRates public exchangeRates;
2673     SynthetixState public synthetixState;
2674 
2675     uint constant SYNTHETIX_SUPPLY = 1e8 * SafeDecimalMath.unit();
2676     string constant TOKEN_NAME = "Synthetix Network Token";
2677     string constant TOKEN_SYMBOL = "SNX";
2678     uint8 constant DECIMALS = 18;
2679 
2680     // ========== CONSTRUCTOR ==========
2681 
2682     /**
2683      * @dev Constructor
2684      * @param _tokenState A pre-populated contract containing token balances.
2685      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2686      * @param _owner The owner of this contract.
2687      */
2688     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2689         address _owner, ExchangeRates _exchangeRates, FeePool _feePool
2690     )
2691         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, SYNTHETIX_SUPPLY, DECIMALS, _owner)
2692         public
2693     {
2694         synthetixState = _synthetixState;
2695         exchangeRates = _exchangeRates;
2696         feePool = _feePool;
2697     }
2698 
2699     // ========== SETTERS ========== */
2700 
2701     /**
2702      * @notice Add an associated Synth contract to the Synthetix system
2703      * @dev Only the contract owner may call this.
2704      */
2705     function addSynth(Synth synth)
2706         external
2707         optionalProxy_onlyOwner
2708     {
2709         bytes4 currencyKey = synth.currencyKey();
2710 
2711         require(synths[currencyKey] == Synth(0), "Synth already exists");
2712 
2713         availableSynths.push(synth);
2714         synths[currencyKey] = synth;
2715 
2716         emitSynthAdded(currencyKey, synth);
2717     }
2718 
2719     /**
2720      * @notice Remove an associated Synth contract from the Synthetix system
2721      * @dev Only the contract owner may call this.
2722      */
2723     function removeSynth(bytes4 currencyKey)
2724         external
2725         optionalProxy_onlyOwner
2726     {
2727         require(synths[currencyKey] != address(0), "Synth does not exist");
2728         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2729         require(currencyKey != "XDR", "Cannot remove XDR synth");
2730 
2731         // Save the address we're removing for emitting the event at the end.
2732         address synthToRemove = synths[currencyKey];
2733 
2734         // Remove the synth from the availableSynths array.
2735         for (uint8 i = 0; i < availableSynths.length; i++) {
2736             if (availableSynths[i] == synthToRemove) {
2737                 delete availableSynths[i];
2738 
2739                 // Copy the last synth into the place of the one we just deleted
2740                 // If there's only one synth, this is synths[0] = synths[0].
2741                 // If we're deleting the last one, it's also a NOOP in the same way.
2742                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2743 
2744                 // Decrease the size of the array by one.
2745                 availableSynths.length--;
2746 
2747                 break;
2748             }
2749         }
2750 
2751         // And remove it from the synths mapping
2752         delete synths[currencyKey];
2753 
2754         emitSynthRemoved(currencyKey, synthToRemove);
2755     }
2756 
2757     /**
2758      * @notice Set the associated synthetix escrow contract.
2759      * @dev Only the contract owner may call this.
2760      */
2761     function setEscrow(SynthetixEscrow _escrow)
2762         external
2763         optionalProxy_onlyOwner
2764     {
2765         escrow = _escrow;
2766         // Note: No event here as our contract exceeds max contract size
2767         // with these events, and it's unlikely people will need to
2768         // track these events specifically.
2769     }
2770 
2771     /**
2772      * @notice Set the ExchangeRates contract address where rates are held.
2773      * @dev Only callable by the contract owner.
2774      */
2775     function setExchangeRates(ExchangeRates _exchangeRates)
2776         external
2777         optionalProxy_onlyOwner
2778     {
2779         exchangeRates = _exchangeRates;
2780         // Note: No event here as our contract exceeds max contract size
2781         // with these events, and it's unlikely people will need to
2782         // track these events specifically.
2783     }
2784 
2785     /**
2786      * @notice Set the synthetixState contract address where issuance data is held.
2787      * @dev Only callable by the contract owner.
2788      */
2789     function setSynthetixState(SynthetixState _synthetixState)
2790         external
2791         optionalProxy_onlyOwner
2792     {
2793         synthetixState = _synthetixState;
2794 
2795         emitStateContractChanged(_synthetixState);
2796     }
2797 
2798     /**
2799      * @notice Set your preferred currency. Note: This does not automatically exchange any balances you've held previously in
2800      * other synth currencies in this address, it will apply for any new payments you receive at this address.
2801      */
2802     function setPreferredCurrency(bytes4 currencyKey)
2803         external
2804         optionalProxy
2805     {
2806         require(currencyKey == 0 || !exchangeRates.rateIsStale(currencyKey), "Currency rate is stale or doesn't exist.");
2807 
2808         synthetixState.setPreferredCurrency(messageSender, currencyKey);
2809 
2810         emitPreferredCurrencyChanged(messageSender, currencyKey);
2811     }
2812 
2813     // ========== VIEWS ==========
2814 
2815     /**
2816      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2817      * @param sourceCurrencyKey The currency the amount is specified in
2818      * @param sourceAmount The source amount, specified in UNIT base
2819      * @param destinationCurrencyKey The destination currency
2820      */
2821     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
2822         public
2823         view
2824         rateNotStale(sourceCurrencyKey)
2825         rateNotStale(destinationCurrencyKey)
2826         returns (uint)
2827     {
2828         // If there's no change in the currency, then just return the amount they gave us
2829         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
2830 
2831         // Calculate the effective value by going from source -> USD -> destination
2832         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
2833             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
2834     }
2835 
2836     /**
2837      * @notice Total amount of synths issued by the system, priced in currencyKey
2838      * @param currencyKey The currency to value the synths in
2839      */
2840     function totalIssuedSynths(bytes4 currencyKey)
2841         public
2842         view
2843         rateNotStale(currencyKey)
2844         returns (uint)
2845     {
2846         uint total = 0;
2847         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2848 
2849         for (uint8 i = 0; i < availableSynths.length; i++) {
2850             // Ensure the rate isn't stale.
2851             // TODO: Investigate gas cost optimisation of doing a single call with all keys in it vs
2852             // individual calls like this.
2853             require(!exchangeRates.rateIsStale(availableSynths[i].currencyKey()), "Rate is stale");
2854 
2855             // What's the total issued value of that synth in the destination currency?
2856             // Note: We're not using our effectiveValue function because we don't want to go get the
2857             //       rate for the destination currency and check if it's stale repeatedly on every
2858             //       iteration of the loop
2859             uint synthValue = availableSynths[i].totalSupply()
2860                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
2861                 .divideDecimalRound(currencyRate);
2862             total = total.add(synthValue);
2863         }
2864 
2865         return total;
2866     }
2867 
2868     /**
2869      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
2870      */
2871     function availableSynthCount()
2872         public
2873         view
2874         returns (uint)
2875     {
2876         return availableSynths.length;
2877     }
2878 
2879     // ========== MUTATIVE FUNCTIONS ==========
2880 
2881     /**
2882      * @notice ERC20 transfer function.
2883      */
2884     function transfer(address to, uint value)
2885         public
2886         returns (bool)
2887     {
2888         bytes memory empty;
2889         return transfer(to, value, empty);
2890     }
2891 
2892     /**
2893      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
2894      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2895      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2896      *           tooling such as Etherscan.
2897      */
2898     function transfer(address to, uint value, bytes data)
2899         public
2900         optionalProxy
2901         returns (bool)
2902     {
2903         // Ensure they're not trying to exceed their locked amount
2904         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
2905 
2906         // Perform the transfer: if there is a problem an exception will be thrown in this call.
2907         _transfer_byProxy(messageSender, to, value, data);
2908 
2909         return true;
2910     }
2911 
2912     /**
2913      * @notice ERC20 transferFrom function.
2914      */
2915     function transferFrom(address from, address to, uint value)
2916         public
2917         returns (bool)
2918     {
2919         bytes memory empty;
2920         return transferFrom(from, to, value, empty);
2921     }
2922 
2923     /**
2924      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
2925      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2926      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2927      *           tooling such as Etherscan.
2928      */
2929     function transferFrom(address from, address to, uint value, bytes data)
2930         public
2931         optionalProxy
2932         returns (bool)
2933     {
2934         // Ensure they're not trying to exceed their locked amount
2935         require(value <= transferableSynthetix(from), "Insufficient balance");
2936 
2937         // Perform the transfer: if there is a problem,
2938         // an exception will be thrown in this call.
2939         _transferFrom_byProxy(messageSender, from, to, value, data);
2940 
2941         return true;
2942     }
2943 
2944     /**
2945      * @notice Function that allows you to exchange synths you hold in one flavour for another.
2946      * @param sourceCurrencyKey The source currency you wish to exchange from
2947      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2948      * @param destinationCurrencyKey The destination currency you wish to obtain.
2949      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
2950      * @return Boolean that indicates whether the transfer succeeded or failed.
2951      */
2952     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
2953         external
2954         optionalProxy
2955         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
2956         returns (bool)
2957     {
2958         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
2959         require(sourceAmount > 0, "Zero amount");
2960 
2961         // Pass it along, defaulting to the sender as the recipient.
2962         return _internalExchange(
2963             messageSender,
2964             sourceCurrencyKey,
2965             sourceAmount,
2966             destinationCurrencyKey,
2967             destinationAddress == address(0) ? messageSender : destinationAddress,
2968             true // Charge fee on the exchange
2969         );
2970     }
2971 
2972     /**
2973      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
2974      * @dev Only the synth contract can call this function
2975      * @param from The address to exchange / burn synth from
2976      * @param sourceCurrencyKey The source currency you wish to exchange from
2977      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2978      * @param destinationCurrencyKey The destination currency you wish to obtain.
2979      * @param destinationAddress Where the result should go.
2980      * @return Boolean that indicates whether the transfer succeeded or failed.
2981      */
2982     function synthInitiatedExchange(
2983         address from,
2984         bytes4 sourceCurrencyKey,
2985         uint sourceAmount,
2986         bytes4 destinationCurrencyKey,
2987         address destinationAddress
2988     )
2989         external
2990         onlySynth
2991         returns (bool)
2992     {
2993         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
2994         require(sourceAmount > 0, "Zero amount");
2995 
2996         // Pass it along
2997         return _internalExchange(
2998             from,
2999             sourceCurrencyKey,
3000             sourceAmount,
3001             destinationCurrencyKey,
3002             destinationAddress,
3003             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
3004         );
3005     }
3006 
3007     /**
3008      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3009      * @dev Only the synth contract can call this function.
3010      * @param from The address fee is coming from.
3011      * @param sourceCurrencyKey source currency fee from.
3012      * @param sourceAmount The amount, specified in UNIT of source currency.
3013      * @return Boolean that indicates whether the transfer succeeded or failed.
3014      */
3015     function synthInitiatedFeePayment(
3016         address from,
3017         bytes4 sourceCurrencyKey,
3018         uint sourceAmount
3019     )
3020         external
3021         onlySynth
3022         returns (bool)
3023     {
3024         require(sourceAmount > 0, "Source can't be 0");
3025 
3026         // Pass it along, defaulting to the sender as the recipient.
3027         bool result = _internalExchange(
3028             from,
3029             sourceCurrencyKey,
3030             sourceAmount,
3031             "XDR",
3032             feePool.FEE_ADDRESS(),
3033             false // Don't charge a fee on the exchange because this is already a fee
3034         );
3035 
3036         // Tell the fee pool about this.
3037         feePool.feePaid(sourceCurrencyKey, sourceAmount);
3038 
3039         return result;
3040     }
3041 
3042     /**
3043      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3044      * @dev fee pool contract address is not allowed to call function
3045      * @param from The address to move synth from
3046      * @param sourceCurrencyKey source currency from.
3047      * @param sourceAmount The amount, specified in UNIT of source currency.
3048      * @param destinationCurrencyKey The destination currency to obtain.
3049      * @param destinationAddress Where the result should go.
3050      * @param chargeFee Boolean to charge a fee for transaction.
3051      * @return Boolean that indicates whether the transfer succeeded or failed.
3052      */
3053     function _internalExchange(
3054         address from,
3055         bytes4 sourceCurrencyKey,
3056         uint sourceAmount,
3057         bytes4 destinationCurrencyKey,
3058         address destinationAddress,
3059         bool chargeFee
3060     )
3061         internal
3062         notFeeAddress(from)
3063         returns (bool)
3064     {
3065         require(destinationAddress != address(0), "Zero destination");
3066         require(destinationAddress != address(this), "Synthetix is invalid destination");
3067         require(destinationAddress != address(proxy), "Proxy is invalid destination");
3068 
3069         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3070         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3071 
3072         // Burn the source amount
3073         synths[sourceCurrencyKey].burn(from, sourceAmount);
3074 
3075         // How much should they get in the destination currency?
3076         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3077 
3078         // What's the fee on that currency that we should deduct?
3079         uint amountReceived = destinationAmount;
3080         uint fee = 0;
3081 
3082         if (chargeFee) {
3083             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
3084             fee = destinationAmount.sub(amountReceived);
3085         }
3086 
3087         // Issue their new synths
3088         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3089 
3090         // Remit the fee in XDRs
3091         if (fee > 0) {
3092             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3093             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3094         }
3095 
3096         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3097 
3098         // Call the ERC223 transfer callback if needed
3099         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
3100 
3101         // Gas optimisation:
3102         // No event emitted as it's assumed users will be able to track transfers to the zero address, followed
3103         // by a transfer on another synth from the zero address and ascertain the info required here.
3104 
3105         return true;
3106     }
3107 
3108     /**
3109      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
3110      * @dev Only internal calls from synthetix address.
3111      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3112      * @param amount The amount of synths to register with a base of UNIT
3113      */
3114     function _addToDebtRegister(bytes4 currencyKey, uint amount)
3115         internal
3116         optionalProxy
3117     {
3118         // What is the value of the requested debt in XDRs?
3119         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3120 
3121         // What is the value of all issued synths of the system (priced in XDRs)?
3122         uint totalDebtIssued = totalIssuedSynths("XDR");
3123 
3124         // What will the new total be including the new value?
3125         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3126 
3127         // What is their percentage (as a high precision int) of the total debt?
3128         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3129 
3130         // And what effect does this percentage have on the global debt holding of other issuers?
3131         // The delta specifically needs to not take into account any existing debt as it's already
3132         // accounted for in the delta from when they issued previously.
3133         // The delta is a high precision integer.
3134         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3135 
3136         // How much existing debt do they have?
3137         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3138 
3139         // And what does their debt ownership look like including this previous stake?
3140         if (existingDebt > 0) {
3141             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3142         }
3143 
3144         // Are they a new issuer? If so, record them.
3145         if (!synthetixState.hasIssued(messageSender)) {
3146             synthetixState.incrementTotalIssuerCount();
3147         }
3148 
3149         // Save the debt entry parameters
3150         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3151 
3152         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3153         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3154         if (synthetixState.debtLedgerLength() > 0) {
3155             synthetixState.appendDebtLedgerValue(
3156                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3157             );
3158         } else {
3159             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3160         }
3161     }
3162 
3163     /**
3164      * @notice Issue synths against the sender's SNX.
3165      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3166      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3167      * @param amount The amount of synths you wish to issue with a base of UNIT
3168      */
3169     function issueSynths(bytes4 currencyKey, uint amount)
3170         public
3171         optionalProxy
3172         nonZeroAmount(amount)
3173         // No need to check if price is stale, as it is checked in issuableSynths.
3174     {
3175         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3176 
3177         // Keep track of the debt they're about to create
3178         _addToDebtRegister(currencyKey, amount);
3179 
3180         // Create their synths
3181         synths[currencyKey].issue(messageSender, amount);
3182     }
3183 
3184     /**
3185      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3186      * @dev Issuance is only allowed if the synthetix price isn't stale.
3187      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3188      */
3189     function issueMaxSynths(bytes4 currencyKey)
3190         external
3191         optionalProxy
3192     {
3193         // Figure out the maximum we can issue in that currency
3194         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3195 
3196         // And issue them
3197         issueSynths(currencyKey, maxIssuable);
3198     }
3199 
3200     /**
3201      * @notice Burn synths to clear issued synths/free SNX.
3202      * @param currencyKey The currency you're specifying to burn
3203      * @param amount The amount (in UNIT base) you wish to burn
3204      */
3205     function burnSynths(bytes4 currencyKey, uint amount)
3206         external
3207         optionalProxy
3208         // No need to check for stale rates as _removeFromDebtRegister calls effectiveValue
3209         // which does this for us
3210     {
3211         // How much debt do they have?
3212         uint debt = debtBalanceOf(messageSender, currencyKey);
3213 
3214         require(debt > 0, "No debt to forgive");
3215 
3216         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3217         // clear their debt and leave them be.
3218         uint amountToBurn = debt < amount ? debt : amount;
3219 
3220         // Remove their debt from the ledger
3221         _removeFromDebtRegister(currencyKey, amountToBurn);
3222 
3223         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3224         synths[currencyKey].burn(messageSender, amountToBurn);
3225     }
3226 
3227     /**
3228      * @notice Remove a debt position from the register
3229      * @param currencyKey The currency the user is presenting to forgive their debt
3230      * @param amount The amount (in UNIT base) being presented
3231      */
3232     function _removeFromDebtRegister(bytes4 currencyKey, uint amount)
3233         internal
3234     {
3235         // How much debt are they trying to remove in XDRs?
3236         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3237 
3238         // How much debt do they have?
3239         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3240 
3241         // What percentage of the total debt are they trying to remove?
3242         uint totalDebtIssued = totalIssuedSynths("XDR");
3243         uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(totalDebtIssued);
3244 
3245         // And what effect does this percentage have on the global debt holding of other issuers?
3246         // The delta specifically needs to not take into account any existing debt as it's already
3247         // accounted for in the delta from when they issued previously.
3248         uint delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3249 
3250         // Are they exiting the system, or are they just decreasing their debt position?
3251         if (debtToRemove == existingDebt) {
3252             synthetixState.clearIssuanceData(messageSender);
3253             synthetixState.decrementTotalIssuerCount();
3254         } else {
3255             // What percentage of the debt will they be left with?
3256             uint newDebt = existingDebt.sub(debtToRemove);
3257             uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3258             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3259 
3260             // Store the debt percentage and debt ledger as high precision integers
3261             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3262         }
3263 
3264         // Update our cumulative ledger. This is also a high precision integer.
3265         synthetixState.appendDebtLedgerValue(
3266             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3267         );
3268     }
3269 
3270     // ========== Issuance/Burning ==========
3271 
3272     /**
3273      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3274      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3275      */
3276     function maxIssuableSynths(address issuer, bytes4 currencyKey)
3277         public
3278         view
3279         // We don't need to check stale rates here as effectiveValue will do it for us.
3280         returns (uint)
3281     {
3282         // What is the value of their SNX balance in the destination currency?
3283         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3284 
3285         // They're allowed to issue up to issuanceRatio of that value
3286         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3287     }
3288 
3289     /**
3290      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3291      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
3292      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3293      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
3294      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3295      * altering the amount of fees they're able to claim from the system.
3296      */
3297     function collateralisationRatio(address issuer)
3298         public
3299         view
3300         returns (uint)
3301     {
3302         uint totalOwnedSynthetix = collateral(issuer);
3303         if (totalOwnedSynthetix == 0) return 0;
3304 
3305         uint debtBalance = debtBalanceOf(issuer, "SNX");
3306         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3307     }
3308 
3309 /**
3310      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3311      * will tell you how many synths a user has to give back to the system in order to unlock their original
3312      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3313      * the debt in sUSD, XDR, or any other synth you wish.
3314      */
3315     function debtBalanceOf(address issuer, bytes4 currencyKey)
3316         public
3317         view
3318         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3319         returns (uint)
3320     {
3321         // What was their initial debt ownership?
3322         uint initialDebtOwnership;
3323         uint debtEntryIndex;
3324         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3325 
3326         // If it's zero, they haven't issued, and they have no debt.
3327         if (initialDebtOwnership == 0) return 0;
3328 
3329         // Figure out the global debt percentage delta from when they entered the system.
3330         // This is a high precision integer.
3331         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3332             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3333             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3334 
3335         // What's the total value of the system in their requested currency?
3336         uint totalSystemValue = totalIssuedSynths(currencyKey);
3337 
3338         // Their debt balance is their portion of the total system value.
3339         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3340             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3341 
3342         return highPrecisionBalance.preciseDecimalToDecimal();
3343     }
3344 
3345     /**
3346      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3347      * @param issuer The account that intends to issue
3348      * @param currencyKey The currency to price issuable value in
3349      */
3350     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
3351         public
3352         view
3353         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3354         returns (uint)
3355     {
3356         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3357         uint max = maxIssuableSynths(issuer, currencyKey);
3358 
3359         if (alreadyIssued >= max) {
3360             return 0;
3361         } else {
3362             return max.sub(alreadyIssued);
3363         }
3364     }
3365 
3366     /**
3367      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3368      * against which synths can be issued.
3369      * This includes those already being used as collateral (locked), and those
3370      * available for further issuance (unlocked).
3371      */
3372     function collateral(address account)
3373         public
3374         view
3375         returns (uint)
3376     {
3377         uint balance = tokenState.balanceOf(account);
3378 
3379         if (escrow != address(0)) {
3380             balance = balance.add(escrow.balanceOf(account));
3381         }
3382 
3383         return balance;
3384     }
3385 
3386     /**
3387      * @notice The number of SNX that are free to be transferred by an account.
3388      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
3389      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
3390      * in this calculation.
3391      */
3392     function transferableSynthetix(address account)
3393         public
3394         view
3395         rateNotStale("SNX")
3396         returns (uint)
3397     {
3398         // How many SNX do they have, excluding escrow?
3399         // Note: We're excluding escrow here because we're interested in their transferable amount
3400         // and escrowed SNX are not transferable.
3401         uint balance = tokenState.balanceOf(account);
3402 
3403         // How many of those will be locked by the amount they've issued?
3404         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3405         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3406         // The locked synthetix value can exceed their balance.
3407         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3408 
3409         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3410         if (lockedSynthetixValue >= balance) {
3411             return 0;
3412         } else {
3413             return balance.sub(lockedSynthetixValue);
3414         }
3415     }
3416 
3417     // ========== MODIFIERS ==========
3418 
3419     modifier rateNotStale(bytes4 currencyKey) {
3420         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
3421         _;
3422     }
3423 
3424     modifier notFeeAddress(address account) {
3425         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3426         _;
3427     }
3428 
3429     modifier onlySynth() {
3430         bool isSynth = false;
3431 
3432         // No need to repeatedly call this function either
3433         for (uint8 i = 0; i < availableSynths.length; i++) {
3434             if (availableSynths[i] == msg.sender) {
3435                 isSynth = true;
3436                 break;
3437             }
3438         }
3439 
3440         require(isSynth, "Only synth allowed");
3441         _;
3442     }
3443 
3444     modifier nonZeroAmount(uint _amount) {
3445         require(_amount > 0, "Amount needs to be larger than 0");
3446         _;
3447     }
3448 
3449     // ========== EVENTS ==========
3450 
3451     event PreferredCurrencyChanged(address indexed account, bytes4 newPreferredCurrency);
3452     bytes32 constant PREFERREDCURRENCYCHANGED_SIG = keccak256("PreferredCurrencyChanged(address,bytes4)");
3453     function emitPreferredCurrencyChanged(address account, bytes4 newPreferredCurrency) internal {
3454         proxy._emit(abi.encode(newPreferredCurrency), 2, PREFERREDCURRENCYCHANGED_SIG, bytes32(account), 0, 0);
3455     }
3456 
3457     event StateContractChanged(address stateContract);
3458     bytes32 constant STATECONTRACTCHANGED_SIG = keccak256("StateContractChanged(address)");
3459     function emitStateContractChanged(address stateContract) internal {
3460         proxy._emit(abi.encode(stateContract), 1, STATECONTRACTCHANGED_SIG, 0, 0, 0);
3461     }
3462 
3463     event SynthAdded(bytes4 currencyKey, address newSynth);
3464     bytes32 constant SYNTHADDED_SIG = keccak256("SynthAdded(bytes4,address)");
3465     function emitSynthAdded(bytes4 currencyKey, address newSynth) internal {
3466         proxy._emit(abi.encode(currencyKey, newSynth), 1, SYNTHADDED_SIG, 0, 0, 0);
3467     }
3468 
3469     event SynthRemoved(bytes4 currencyKey, address removedSynth);
3470     bytes32 constant SYNTHREMOVED_SIG = keccak256("SynthRemoved(bytes4,address)");
3471     function emitSynthRemoved(bytes4 currencyKey, address removedSynth) internal {
3472         proxy._emit(abi.encode(currencyKey, removedSynth), 1, SYNTHREMOVED_SIG, 0, 0, 0);
3473     }
3474 }
3475 
3476 
3477 /*
3478 -----------------------------------------------------------------
3479 FILE INFORMATION
3480 -----------------------------------------------------------------
3481 
3482 file:       FeePool.sol
3483 version:    1.0
3484 author:     Kevin Brown
3485 date:       2018-10-15
3486 
3487 -----------------------------------------------------------------
3488 MODULE DESCRIPTION
3489 -----------------------------------------------------------------
3490 
3491 The FeePool is a place for users to interact with the fees that
3492 have been generated from the Synthetix system if they've helped
3493 to create the economy.
3494 
3495 Users stake Synthetix to create Synths. As Synth users transact,
3496 a small fee is deducted from each transaction, which collects
3497 in the fee pool. Fees are immediately converted to XDRs, a type
3498 of reserve currency similar to SDRs used by the IMF:
3499 https://www.imf.org/en/About/Factsheets/Sheets/2016/08/01/14/51/Special-Drawing-Right-SDR
3500 
3501 Users are entitled to withdraw fees from periods that they participated
3502 in fully, e.g. they have to stake before the period starts. They
3503 can withdraw fees for the last 6 periods as a single lump sum.
3504 Currently fee periods are 7 days long, meaning it's assumed
3505 users will withdraw their fees approximately once a month. Fees
3506 which are not withdrawn are redistributed to the whole pool,
3507 enabling these non-claimed fees to go back to the rest of the commmunity.
3508 
3509 Fees can be withdrawn in any synth currency.
3510 
3511 -----------------------------------------------------------------
3512 */
3513 
3514 
3515 contract FeePool is Proxyable, SelfDestructible {
3516 
3517     using SafeMath for uint;
3518     using SafeDecimalMath for uint;
3519 
3520     Synthetix public synthetix;
3521 
3522     // A percentage fee charged on each transfer.
3523     uint public transferFeeRate;
3524 
3525     // Transfer fee may not exceed 10%.
3526     uint constant public MAX_TRANSFER_FEE_RATE = SafeDecimalMath.unit() / 10;
3527 
3528     // A percentage fee charged on each exchange between currencies.
3529     uint public exchangeFeeRate;
3530 
3531     // Exchange fee may not exceed 10%.
3532     uint constant public MAX_EXCHANGE_FEE_RATE = SafeDecimalMath.unit() / 10;
3533 
3534     // The address with the authority to distribute fees.
3535     address public feeAuthority;
3536 
3537     // Where fees are pooled in XDRs.
3538     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
3539 
3540     // This struct represents the issuance activity that's happened in a fee period.
3541     struct FeePeriod {
3542         uint feePeriodId;
3543         uint startingDebtIndex;
3544         uint startTime;
3545         uint feesToDistribute;
3546         uint feesClaimed;
3547     }
3548 
3549     // The last 6 fee periods are all that you can claim from.
3550     // These are stored and managed from [0], such that [0] is always
3551     // the most recent fee period, and [5] is always the oldest fee
3552     // period that users can claim for.
3553     uint8 constant public FEE_PERIOD_LENGTH = 6;
3554     FeePeriod[FEE_PERIOD_LENGTH] public recentFeePeriods;
3555 
3556     // The next fee period will have this ID.
3557     uint public nextFeePeriodId;
3558 
3559     // How long a fee period lasts at a minimum. It is required for the
3560     // fee authority to roll over the periods, so they are not guaranteed
3561     // to roll over at exactly this duration, but the contract enforces
3562     // that they cannot roll over any quicker than this duration.
3563     uint public feePeriodDuration = 1 weeks;
3564 
3565     // The fee period must be between 1 day and 60 days.
3566     uint public constant MIN_FEE_PERIOD_DURATION = 1 days;
3567     uint public constant MAX_FEE_PERIOD_DURATION = 60 days;
3568 
3569     // The last period a user has withdrawn their fees in, identified by the feePeriodId
3570     mapping(address => uint) public lastFeeWithdrawal;
3571 
3572     // Users receive penalties if their collateralisation ratio drifts out of our desired brackets
3573     // We precompute the brackets and penalties to save gas.
3574     uint constant TWENTY_PERCENT = (20 * SafeDecimalMath.unit()) / 100;
3575     uint constant TWENTY_FIVE_PERCENT = (25 * SafeDecimalMath.unit()) / 100;
3576     uint constant THIRTY_PERCENT = (30 * SafeDecimalMath.unit()) / 100;
3577     uint constant FOURTY_PERCENT = (40 * SafeDecimalMath.unit()) / 100;
3578     uint constant FIFTY_PERCENT = (50 * SafeDecimalMath.unit()) / 100;
3579     uint constant SEVENTY_FIVE_PERCENT = (75 * SafeDecimalMath.unit()) / 100;
3580 
3581     constructor(address _proxy, address _owner, Synthetix _synthetix, address _feeAuthority, uint _transferFeeRate, uint _exchangeFeeRate)
3582         SelfDestructible(_owner)
3583         Proxyable(_proxy, _owner)
3584         public
3585     {
3586         // Constructed fee rates should respect the maximum fee rates.
3587         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
3588         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Constructed exchange fee rate should respect the maximum fee rate");
3589 
3590         synthetix = _synthetix;
3591         feeAuthority = _feeAuthority;
3592         transferFeeRate = _transferFeeRate;
3593         exchangeFeeRate = _exchangeFeeRate;
3594 
3595         // Set our initial fee period
3596         recentFeePeriods[0].feePeriodId = 1;
3597         recentFeePeriods[0].startTime = now;
3598         // Gas optimisation: These do not need to be initialised. They start at 0.
3599         // recentFeePeriods[0].startingDebtIndex = 0;
3600         // recentFeePeriods[0].feesToDistribute = 0;
3601 
3602         // And the next one starts at 2.
3603         nextFeePeriodId = 2;
3604     }
3605 
3606     /**
3607      * @notice Set the exchange fee, anywhere within the range 0-10%.
3608      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
3609      */
3610     function setExchangeFeeRate(uint _exchangeFeeRate)
3611         external
3612         optionalProxy_onlyOwner
3613     {
3614         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Exchange fee rate must be below MAX_EXCHANGE_FEE_RATE");
3615 
3616         exchangeFeeRate = _exchangeFeeRate;
3617 
3618         emitExchangeFeeUpdated(_exchangeFeeRate);
3619     }
3620 
3621     /**
3622      * @notice Set the transfer fee, anywhere within the range 0-10%.
3623      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
3624      */
3625     function setTransferFeeRate(uint _transferFeeRate)
3626         external
3627         optionalProxy_onlyOwner
3628     {
3629         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
3630 
3631         transferFeeRate = _transferFeeRate;
3632 
3633         emitTransferFeeUpdated(_transferFeeRate);
3634     }
3635 
3636     /**
3637      * @notice Set the address of the user/contract responsible for collecting or
3638      * distributing fees.
3639      */
3640     function setFeeAuthority(address _feeAuthority)
3641         external
3642         optionalProxy_onlyOwner
3643     {
3644         feeAuthority = _feeAuthority;
3645 
3646         emitFeeAuthorityUpdated(_feeAuthority);
3647     }
3648 
3649     /**
3650      * @notice Set the fee period duration
3651      */
3652     function setFeePeriodDuration(uint _feePeriodDuration)
3653         external
3654         optionalProxy_onlyOwner
3655     {
3656         require(_feePeriodDuration >= MIN_FEE_PERIOD_DURATION, "New fee period cannot be less than minimum fee period duration");
3657         require(_feePeriodDuration <= MAX_FEE_PERIOD_DURATION, "New fee period cannot be greater than maximum fee period duration");
3658 
3659         feePeriodDuration = _feePeriodDuration;
3660 
3661         emitFeePeriodDurationUpdated(_feePeriodDuration);
3662     }
3663 
3664     /**
3665      * @notice Set the synthetix contract
3666      */
3667     function setSynthetix(Synthetix _synthetix)
3668         external
3669         optionalProxy_onlyOwner
3670     {
3671         require(address(_synthetix) != address(0), "New Synthetix must be non-zero");
3672 
3673         synthetix = _synthetix;
3674 
3675         emitSynthetixUpdated(_synthetix);
3676     }
3677 
3678     /**
3679      * @notice The Synthetix contract informs us when fees are paid.
3680      */
3681     function feePaid(bytes4 currencyKey, uint amount)
3682         external
3683         onlySynthetix
3684     {
3685         uint xdrAmount = synthetix.effectiveValue(currencyKey, amount, "XDR");
3686 
3687         // Which we keep track of in XDRs in our fee pool.
3688         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.add(xdrAmount);
3689     }
3690 
3691     /**
3692      * @notice Close the current fee period and start a new one. Only callable by the fee authority.
3693      */
3694     function closeCurrentFeePeriod()
3695         external
3696         onlyFeeAuthority
3697     {
3698         require(recentFeePeriods[0].startTime <= (now - feePeriodDuration), "It is too early to close the current fee period");
3699 
3700         FeePeriod memory secondLastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 2];
3701         FeePeriod memory lastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 1];
3702 
3703         // Any unclaimed fees from the last period in the array roll back one period.
3704         // Because of the subtraction here, they're effectively proportionally redistributed to those who
3705         // have already claimed from the old period, available in the new period.
3706         // The subtraction is important so we don't create a ticking time bomb of an ever growing
3707         // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
3708         recentFeePeriods[FEE_PERIOD_LENGTH - 2].feesToDistribute = lastFeePeriod.feesToDistribute
3709             .sub(lastFeePeriod.feesClaimed)
3710             .add(secondLastFeePeriod.feesToDistribute);
3711 
3712         // Shift the previous fee periods across to make room for the new one.
3713         // Condition checks for overflow when uint subtracts one from zero
3714         // Could be written with int instead of uint, but then we have to convert everywhere
3715         // so it felt better from a gas perspective to just change the condition to check
3716         // for overflow after subtracting one from zero.
3717         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
3718             uint next = i + 1;
3719 
3720             recentFeePeriods[next].feePeriodId = recentFeePeriods[i].feePeriodId;
3721             recentFeePeriods[next].startingDebtIndex = recentFeePeriods[i].startingDebtIndex;
3722             recentFeePeriods[next].startTime = recentFeePeriods[i].startTime;
3723             recentFeePeriods[next].feesToDistribute = recentFeePeriods[i].feesToDistribute;
3724             recentFeePeriods[next].feesClaimed = recentFeePeriods[i].feesClaimed;
3725         }
3726 
3727         // Clear the first element of the array to make sure we don't have any stale values.
3728         delete recentFeePeriods[0];
3729 
3730         // Open up the new fee period
3731         recentFeePeriods[0].feePeriodId = nextFeePeriodId;
3732         recentFeePeriods[0].startingDebtIndex = synthetix.synthetixState().debtLedgerLength();
3733         recentFeePeriods[0].startTime = now;
3734 
3735         nextFeePeriodId = nextFeePeriodId.add(1);
3736 
3737         emitFeePeriodClosed(recentFeePeriods[1].feePeriodId);
3738     }
3739 
3740     /**
3741     * @notice Claim fees for last period when available or not already withdrawn.
3742     * @param currencyKey Synth currency you wish to receive the fees in.
3743     */
3744     function claimFees(bytes4 currencyKey)
3745         external
3746         optionalProxy
3747         returns (bool)
3748     {
3749         uint availableFees = feesAvailable(messageSender, "XDR");
3750 
3751         require(availableFees > 0, "No fees available for period, or fees already claimed");
3752 
3753         lastFeeWithdrawal[messageSender] = recentFeePeriods[1].feePeriodId;
3754 
3755         // Record the fee payment in our recentFeePeriods
3756         _recordFeePayment(availableFees);
3757 
3758         // Send them their fees
3759         _payFees(messageSender, availableFees, currencyKey);
3760 
3761         emitFeesClaimed(messageSender, availableFees);
3762 
3763         return true;
3764     }
3765 
3766     /**
3767      * @notice Record the fee payment in our recentFeePeriods.
3768      * @param xdrAmount The amout of fees priced in XDRs.
3769      */
3770     function _recordFeePayment(uint xdrAmount)
3771         internal
3772     {
3773         // Don't assign to the parameter
3774         uint remainingToAllocate = xdrAmount;
3775 
3776         // Start at the oldest period and record the amount, moving to newer periods
3777         // until we've exhausted the amount.
3778         // The condition checks for overflow because we're going to 0 with an unsigned int.
3779         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
3780             uint delta = recentFeePeriods[i].feesToDistribute.sub(recentFeePeriods[i].feesClaimed);
3781 
3782             if (delta > 0) {
3783                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
3784                 uint amountInPeriod = delta < remainingToAllocate ? delta : remainingToAllocate;
3785 
3786                 recentFeePeriods[i].feesClaimed = recentFeePeriods[i].feesClaimed.add(amountInPeriod);
3787                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
3788 
3789                 // No need to continue iterating if we've recorded the whole amount;
3790                 if (remainingToAllocate == 0) return;
3791             }
3792         }
3793 
3794         // If we hit this line, we've exhausted our fee periods, but still have more to allocate. Wat?
3795         // If this happens it's a definite bug in the code, so assert instead of require.
3796         assert(remainingToAllocate == 0);
3797     }
3798 
3799     /**
3800     * @notice Send the fees to claiming address.
3801     * @param account The address to send the fees to.
3802     * @param xdrAmount The amount of fees priced in XDRs.
3803     * @param destinationCurrencyKey The synth currency the user wishes to receive their fees in (convert to this currency).
3804     */
3805     function _payFees(address account, uint xdrAmount, bytes4 destinationCurrencyKey)
3806         internal
3807         notFeeAddress(account)
3808     {
3809         require(account != address(0), "Account can't be 0");
3810         require(account != address(this), "Can't send fees to fee pool");
3811         require(account != address(proxy), "Can't send fees to proxy");
3812         require(account != address(synthetix), "Can't send fees to synthetix");
3813 
3814         Synth xdrSynth = synthetix.synths("XDR");
3815         Synth destinationSynth = synthetix.synths(destinationCurrencyKey);
3816 
3817         // Note: We don't need to check the fee pool balance as the burn() below will do a safe subtraction which requires
3818         // the subtraction to not overflow, which would happen if the balance is not sufficient.
3819 
3820         // Burn the source amount
3821         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
3822 
3823         // How much should they get in the destination currency?
3824         uint destinationAmount = synthetix.effectiveValue("XDR", xdrAmount, destinationCurrencyKey);
3825 
3826         // There's no fee on withdrawing fees, as that'd be way too meta.
3827 
3828         // Mint their new synths
3829         destinationSynth.issue(account, destinationAmount);
3830 
3831         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3832 
3833         // Call the ERC223 transfer callback if needed
3834         destinationSynth.triggerTokenFallbackIfNeeded(FEE_ADDRESS, account, destinationAmount);
3835     }
3836 
3837     /**
3838      * @notice Calculate the Fee charged on top of a value being sent
3839      * @return Return the fee charged
3840      */
3841     function transferFeeIncurred(uint value)
3842         public
3843         view
3844         returns (uint)
3845     {
3846         return value.multiplyDecimal(transferFeeRate);
3847 
3848         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
3849         // This is on the basis that transfers less than this value will result in a nil fee.
3850         // Probably too insignificant to worry about, but the following code will achieve it.
3851         //      if (fee == 0 && transferFeeRate != 0) {
3852         //          return _value;
3853         //      }
3854         //      return fee;
3855     }
3856 
3857     /**
3858      * @notice The value that you would need to send so that the recipient receives
3859      * a specified value.
3860      * @param value The value you want the recipient to receive
3861      */
3862     function transferredAmountToReceive(uint value)
3863         external
3864         view
3865         returns (uint)
3866     {
3867         return value.add(transferFeeIncurred(value));
3868     }
3869 
3870     /**
3871      * @notice The amount the recipient will receive if you send a certain number of tokens.
3872      * @param value The amount of tokens you intend to send.
3873      */
3874     function amountReceivedFromTransfer(uint value)
3875         external
3876         view
3877         returns (uint)
3878     {
3879         return value.divideDecimal(transferFeeRate.add(SafeDecimalMath.unit()));
3880     }
3881 
3882     /**
3883      * @notice Calculate the fee charged on top of a value being sent via an exchange
3884      * @return Return the fee charged
3885      */
3886     function exchangeFeeIncurred(uint value)
3887         public
3888         view
3889         returns (uint)
3890     {
3891         return value.multiplyDecimal(exchangeFeeRate);
3892 
3893         // Exchanges less than the reciprocal of exchangeFeeRate should be completely eaten up by fees.
3894         // This is on the basis that exchanges less than this value will result in a nil fee.
3895         // Probably too insignificant to worry about, but the following code will achieve it.
3896         //      if (fee == 0 && exchangeFeeRate != 0) {
3897         //          return _value;
3898         //      }
3899         //      return fee;
3900     }
3901 
3902     /**
3903      * @notice The value that you would need to get after currency exchange so that the recipient receives
3904      * a specified value.
3905      * @param value The value you want the recipient to receive
3906      */
3907     function exchangedAmountToReceive(uint value)
3908         external
3909         view
3910         returns (uint)
3911     {
3912         return value.add(exchangeFeeIncurred(value));
3913     }
3914 
3915     /**
3916      * @notice The amount the recipient will receive if you are performing an exchange and the
3917      * destination currency will be worth a certain number of tokens.
3918      * @param value The amount of destination currency tokens they received after the exchange.
3919      */
3920     function amountReceivedFromExchange(uint value)
3921         external
3922         view
3923         returns (uint)
3924     {
3925         return value.divideDecimal(exchangeFeeRate.add(SafeDecimalMath.unit()));
3926     }
3927 
3928     /**
3929      * @notice The total fees available in the system to be withdrawn, priced in currencyKey currency
3930      * @param currencyKey The currency you want to price the fees in
3931      */
3932     function totalFeesAvailable(bytes4 currencyKey)
3933         external
3934         view
3935         returns (uint)
3936     {
3937         uint totalFees = 0;
3938 
3939         // Fees in fee period [0] are not yet available for withdrawal
3940         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
3941             totalFees = totalFees.add(recentFeePeriods[i].feesToDistribute);
3942             totalFees = totalFees.sub(recentFeePeriods[i].feesClaimed);
3943         }
3944 
3945         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
3946     }
3947 
3948     /**
3949      * @notice The fees available to be withdrawn by a specific account, priced in currencyKey currency
3950      * @param currencyKey The currency you want to price the fees in
3951      */
3952     function feesAvailable(address account, bytes4 currencyKey)
3953         public
3954         view
3955         returns (uint)
3956     {
3957         // Add up the fees
3958         uint[FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);
3959 
3960         uint totalFees = 0;
3961 
3962         // Fees in fee period [0] are not yet available for withdrawal
3963         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
3964             totalFees = totalFees.add(userFees[i]);
3965         }
3966 
3967         // And convert them to their desired currency
3968         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
3969     }
3970 
3971     /**
3972      * @notice The penalty a particular address would incur if its fees were withdrawn right now
3973      * @param account The address you want to query the penalty for
3974      */
3975     function currentPenalty(address account)
3976         public
3977         view
3978         returns (uint)
3979     {
3980         uint ratio = synthetix.collateralisationRatio(account);
3981 
3982         // Users receive a different amount of fees depending on how their collateralisation ratio looks right now.
3983         // 0% - 20%: Fee is calculated based on percentage of economy issued.
3984         // 20% - 30%: 25% reduction in fees
3985         // 30% - 40%: 50% reduction in fees
3986         // >40%: 75% reduction in fees
3987         if (ratio <= TWENTY_PERCENT) {
3988             return 0;
3989         } else if (ratio > TWENTY_PERCENT && ratio <= THIRTY_PERCENT) {
3990             return TWENTY_FIVE_PERCENT;
3991         } else if (ratio > THIRTY_PERCENT && ratio <= FOURTY_PERCENT) {
3992             return FIFTY_PERCENT;
3993         }
3994 
3995         return SEVENTY_FIVE_PERCENT;
3996     }
3997 
3998     /**
3999      * @notice Calculates fees by period for an account, priced in XDRs
4000      * @param account The address you want to query the fees by penalty for
4001      */
4002     function feesByPeriod(address account)
4003         public
4004         view
4005         returns (uint[FEE_PERIOD_LENGTH])
4006     {
4007         uint[FEE_PERIOD_LENGTH] memory result;
4008 
4009         // What's the user's debt entry index and the debt they owe to the system
4010         uint initialDebtOwnership;
4011         uint debtEntryIndex;
4012         (initialDebtOwnership, debtEntryIndex) = synthetix.synthetixState().issuanceData(account);
4013 
4014         // If they don't have any debt ownership, they don't have any fees
4015         if (initialDebtOwnership == 0) return result;
4016 
4017         // If there are no XDR synths, then they don't have any fees
4018         uint totalSynths = synthetix.totalIssuedSynths("XDR");
4019         if (totalSynths == 0) return result;
4020 
4021         uint debtBalance = synthetix.debtBalanceOf(account, "XDR");
4022         uint userOwnershipPercentage = debtBalance.divideDecimal(totalSynths);
4023         uint penalty = currentPenalty(account);
4024         
4025         // Go through our fee periods and figure out what we owe them.
4026         // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
4027         // fees owing for, so we need to report on it anyway.
4028         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
4029             // Were they a part of this period in its entirety?
4030             // We don't allow pro-rata participation to reduce the ability to game the system by
4031             // issuing and burning multiple times in a period or close to the ends of periods.
4032             if (recentFeePeriods[i].startingDebtIndex > debtEntryIndex &&
4033                 lastFeeWithdrawal[account] < recentFeePeriods[i].feePeriodId) {
4034 
4035                 // And since they were, they're entitled to their percentage of the fees in this period
4036                 uint feesFromPeriodWithoutPenalty = recentFeePeriods[i].feesToDistribute
4037                     .multiplyDecimal(userOwnershipPercentage);
4038 
4039                 // Less their penalty if they have one.
4040                 uint penaltyFromPeriod = feesFromPeriodWithoutPenalty.multiplyDecimal(penalty);
4041                 uint feesFromPeriod = feesFromPeriodWithoutPenalty.sub(penaltyFromPeriod);
4042 
4043                 result[i] = feesFromPeriod;
4044             }
4045         }
4046 
4047         return result;
4048     }
4049 
4050     modifier onlyFeeAuthority
4051     {
4052         require(msg.sender == feeAuthority, "Only the fee authority can perform this action");
4053         _;
4054     }
4055 
4056     modifier onlySynthetix
4057     {
4058         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
4059         _;
4060     }
4061 
4062     modifier notFeeAddress(address account) {
4063         require(account != FEE_ADDRESS, "Fee address not allowed");
4064         _;
4065     }
4066 
4067     event TransferFeeUpdated(uint newFeeRate);
4068     bytes32 constant TRANSFERFEEUPDATED_SIG = keccak256("TransferFeeUpdated(uint256)");
4069     function emitTransferFeeUpdated(uint newFeeRate) internal {
4070         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEEUPDATED_SIG, 0, 0, 0);
4071     }
4072 
4073     event ExchangeFeeUpdated(uint newFeeRate);
4074     bytes32 constant EXCHANGEFEEUPDATED_SIG = keccak256("ExchangeFeeUpdated(uint256)");
4075     function emitExchangeFeeUpdated(uint newFeeRate) internal {
4076         proxy._emit(abi.encode(newFeeRate), 1, EXCHANGEFEEUPDATED_SIG, 0, 0, 0);
4077     }
4078 
4079     event FeePeriodDurationUpdated(uint newFeePeriodDuration);
4080     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
4081     function emitFeePeriodDurationUpdated(uint newFeePeriodDuration) internal {
4082         proxy._emit(abi.encode(newFeePeriodDuration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
4083     }
4084 
4085     event FeeAuthorityUpdated(address newFeeAuthority);
4086     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
4087     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
4088         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
4089     }
4090 
4091     event FeePeriodClosed(uint feePeriodId);
4092     bytes32 constant FEEPERIODCLOSED_SIG = keccak256("FeePeriodClosed(uint256)");
4093     function emitFeePeriodClosed(uint feePeriodId) internal {
4094         proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
4095     }
4096 
4097     event FeesClaimed(address account, uint xdrAmount);
4098     bytes32 constant FEESCLAIMED_SIG = keccak256("FeesClaimed(address,uint256)");
4099     function emitFeesClaimed(address account, uint xdrAmount) internal {
4100         proxy._emit(abi.encode(account, xdrAmount), 1, FEESCLAIMED_SIG, 0, 0, 0);
4101     }
4102 
4103     event SynthetixUpdated(address newSynthetix);
4104     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
4105     function emitSynthetixUpdated(address newSynthetix) internal {
4106         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
4107     }
4108 }