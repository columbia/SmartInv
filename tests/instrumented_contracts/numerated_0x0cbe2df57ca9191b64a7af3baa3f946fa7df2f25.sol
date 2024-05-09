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
1205 file:       LimitedSetup.sol
1206 version:    1.1
1207 author:     Anton Jurisevic
1208 
1209 date:       2018-05-15
1210 
1211 -----------------------------------------------------------------
1212 MODULE DESCRIPTION
1213 -----------------------------------------------------------------
1214 
1215 A contract with a limited setup period. Any function modified
1216 with the setup modifier will cease to work after the
1217 conclusion of the configurable-length post-construction setup period.
1218 
1219 -----------------------------------------------------------------
1220 */
1221 
1222 
1223 /**
1224  * @title Any function decorated with the modifier this contract provides
1225  * deactivates after a specified setup period.
1226  */
1227 contract LimitedSetup {
1228 
1229     uint setupExpiryTime;
1230 
1231     /**
1232      * @dev LimitedSetup Constructor.
1233      * @param setupDuration The time the setup period will last for.
1234      */
1235     constructor(uint setupDuration)
1236         public
1237     {
1238         setupExpiryTime = now + setupDuration;
1239     }
1240 
1241     modifier onlyDuringSetup
1242     {
1243         require(now < setupExpiryTime, "Can only perform this action during setup");
1244         _;
1245     }
1246 }
1247 
1248 
1249 /*
1250 -----------------------------------------------------------------
1251 FILE INFORMATION
1252 -----------------------------------------------------------------
1253 
1254 file:       SynthetixEscrow.sol
1255 version:    1.1
1256 author:     Anton Jurisevic
1257             Dominic Romanowski
1258             Mike Spain
1259 
1260 date:       2018-05-29
1261 
1262 -----------------------------------------------------------------
1263 MODULE DESCRIPTION
1264 -----------------------------------------------------------------
1265 
1266 This contract allows the foundation to apply unique vesting
1267 schedules to synthetix funds sold at various discounts in the token
1268 sale. SynthetixEscrow gives users the ability to inspect their
1269 vested funds, their quantities and vesting dates, and to withdraw
1270 the fees that accrue on those funds.
1271 
1272 The fees are handled by withdrawing the entire fee allocation
1273 for all SNX inside the escrow contract, and then allowing
1274 the contract itself to subdivide that pool up proportionally within
1275 itself. Every time the fee period rolls over in the main Synthetix
1276 contract, the SynthetixEscrow fee pool is remitted back into the
1277 main fee pool to be redistributed in the next fee period.
1278 
1279 -----------------------------------------------------------------
1280 */
1281 
1282 
1283 /**
1284  * @title A contract to hold escrowed SNX and free them at given schedules.
1285  */
1286 contract SynthetixEscrow is Owned, LimitedSetup(8 weeks) {
1287 
1288     using SafeMath for uint;
1289 
1290     /* The corresponding Synthetix contract. */
1291     Synthetix public synthetix;
1292 
1293     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
1294      * These are the times at which each given quantity of SNX vests. */
1295     mapping(address => uint[2][]) public vestingSchedules;
1296 
1297     /* An account's total vested synthetix balance to save recomputing this for fee extraction purposes. */
1298     mapping(address => uint) public totalVestedAccountBalance;
1299 
1300     /* The total remaining vested balance, for verifying the actual synthetix balance of this contract against. */
1301     uint public totalVestedBalance;
1302 
1303     uint constant TIME_INDEX = 0;
1304     uint constant QUANTITY_INDEX = 1;
1305 
1306     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
1307     uint constant MAX_VESTING_ENTRIES = 20;
1308 
1309 
1310     /* ========== CONSTRUCTOR ========== */
1311 
1312     constructor(address _owner, Synthetix _synthetix)
1313         Owned(_owner)
1314         public
1315     {
1316         synthetix = _synthetix;
1317     }
1318 
1319 
1320     /* ========== SETTERS ========== */
1321 
1322     function setSynthetix(Synthetix _synthetix)
1323         external
1324         onlyOwner
1325     {
1326         synthetix = _synthetix;
1327         emit SynthetixUpdated(_synthetix);
1328     }
1329 
1330 
1331     /* ========== VIEW FUNCTIONS ========== */
1332 
1333     /**
1334      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
1335      */
1336     function balanceOf(address account)
1337         public
1338         view
1339         returns (uint)
1340     {
1341         return totalVestedAccountBalance[account];
1342     }
1343 
1344     /**
1345      * @notice The number of vesting dates in an account's schedule.
1346      */
1347     function numVestingEntries(address account)
1348         public
1349         view
1350         returns (uint)
1351     {
1352         return vestingSchedules[account].length;
1353     }
1354 
1355     /**
1356      * @notice Get a particular schedule entry for an account.
1357      * @return A pair of uints: (timestamp, synthetix quantity).
1358      */
1359     function getVestingScheduleEntry(address account, uint index)
1360         public
1361         view
1362         returns (uint[2])
1363     {
1364         return vestingSchedules[account][index];
1365     }
1366 
1367     /**
1368      * @notice Get the time at which a given schedule entry will vest.
1369      */
1370     function getVestingTime(address account, uint index)
1371         public
1372         view
1373         returns (uint)
1374     {
1375         return getVestingScheduleEntry(account,index)[TIME_INDEX];
1376     }
1377 
1378     /**
1379      * @notice Get the quantity of SNX associated with a given schedule entry.
1380      */
1381     function getVestingQuantity(address account, uint index)
1382         public
1383         view
1384         returns (uint)
1385     {
1386         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
1387     }
1388 
1389     /**
1390      * @notice Obtain the index of the next schedule entry that will vest for a given user.
1391      */
1392     function getNextVestingIndex(address account)
1393         public
1394         view
1395         returns (uint)
1396     {
1397         uint len = numVestingEntries(account);
1398         for (uint i = 0; i < len; i++) {
1399             if (getVestingTime(account, i) != 0) {
1400                 return i;
1401             }
1402         }
1403         return len;
1404     }
1405 
1406     /**
1407      * @notice Obtain the next schedule entry that will vest for a given user.
1408      * @return A pair of uints: (timestamp, synthetix quantity). */
1409     function getNextVestingEntry(address account)
1410         public
1411         view
1412         returns (uint[2])
1413     {
1414         uint index = getNextVestingIndex(account);
1415         if (index == numVestingEntries(account)) {
1416             return [uint(0), 0];
1417         }
1418         return getVestingScheduleEntry(account, index);
1419     }
1420 
1421     /**
1422      * @notice Obtain the time at which the next schedule entry will vest for a given user.
1423      */
1424     function getNextVestingTime(address account)
1425         external
1426         view
1427         returns (uint)
1428     {
1429         return getNextVestingEntry(account)[TIME_INDEX];
1430     }
1431 
1432     /**
1433      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
1434      */
1435     function getNextVestingQuantity(address account)
1436         external
1437         view
1438         returns (uint)
1439     {
1440         return getNextVestingEntry(account)[QUANTITY_INDEX];
1441     }
1442 
1443 
1444     /* ========== MUTATIVE FUNCTIONS ========== */
1445 
1446     /**
1447      * @notice Withdraws a quantity of SNX back to the synthetix contract.
1448      * @dev This may only be called by the owner during the contract's setup period.
1449      */
1450     function withdrawSynthetix(uint quantity)
1451         external
1452         onlyOwner
1453         onlyDuringSetup
1454     {
1455         synthetix.transfer(synthetix, quantity);
1456     }
1457 
1458     /**
1459      * @notice Destroy the vesting information associated with an account.
1460      */
1461     function purgeAccount(address account)
1462         external
1463         onlyOwner
1464         onlyDuringSetup
1465     {
1466         delete vestingSchedules[account];
1467         totalVestedBalance = totalVestedBalance.sub(totalVestedAccountBalance[account]);
1468         delete totalVestedAccountBalance[account];
1469     }
1470 
1471     /**
1472      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
1473      * @dev A call to this should be accompanied by either enough balance already available
1474      * in this contract, or a corresponding call to synthetix.endow(), to ensure that when
1475      * the funds are withdrawn, there is enough balance, as well as correctly calculating
1476      * the fees.
1477      * This may only be called by the owner during the contract's setup period.
1478      * Note; although this function could technically be used to produce unbounded
1479      * arrays, it's only in the foundation's command to add to these lists.
1480      * @param account The account to append a new vesting entry to.
1481      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
1482      * @param quantity The quantity of SNX that will vest.
1483      */
1484     function appendVestingEntry(address account, uint time, uint quantity)
1485         public
1486         onlyOwner
1487         onlyDuringSetup
1488     {
1489         /* No empty or already-passed vesting entries allowed. */
1490         require(now < time, "Time must be in the future");
1491         require(quantity != 0, "Quantity cannot be zero");
1492 
1493         /* There must be enough balance in the contract to provide for the vesting entry. */
1494         totalVestedBalance = totalVestedBalance.add(quantity);
1495         require(totalVestedBalance <= synthetix.balanceOf(this), "Must be enough balance in the contract to provide for the vesting entry");
1496 
1497         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
1498         uint scheduleLength = vestingSchedules[account].length;
1499         require(scheduleLength <= MAX_VESTING_ENTRIES, "Vesting schedule is too long");
1500 
1501         if (scheduleLength == 0) {
1502             totalVestedAccountBalance[account] = quantity;
1503         } else {
1504             /* Disallow adding new vested SNX earlier than the last one.
1505              * Since entries are only appended, this means that no vesting date can be repeated. */
1506             require(getVestingTime(account, numVestingEntries(account) - 1) < time, "Cannot add new vested entries earlier than the last one");
1507             totalVestedAccountBalance[account] = totalVestedAccountBalance[account].add(quantity);
1508         }
1509 
1510         vestingSchedules[account].push([time, quantity]);
1511     }
1512 
1513     /**
1514      * @notice Construct a vesting schedule to release a quantities of SNX
1515      * over a series of intervals.
1516      * @dev Assumes that the quantities are nonzero
1517      * and that the sequence of timestamps is strictly increasing.
1518      * This may only be called by the owner during the contract's setup period.
1519      */
1520     function addVestingSchedule(address account, uint[] times, uint[] quantities)
1521         external
1522         onlyOwner
1523         onlyDuringSetup
1524     {
1525         for (uint i = 0; i < times.length; i++) {
1526             appendVestingEntry(account, times[i], quantities[i]);
1527         }
1528 
1529     }
1530 
1531     /**
1532      * @notice Allow a user to withdraw any SNX in their schedule that have vested.
1533      */
1534     function vest()
1535         external
1536     {
1537         uint numEntries = numVestingEntries(msg.sender);
1538         uint total;
1539         for (uint i = 0; i < numEntries; i++) {
1540             uint time = getVestingTime(msg.sender, i);
1541             /* The list is sorted; when we reach the first future time, bail out. */
1542             if (time > now) {
1543                 break;
1544             }
1545             uint qty = getVestingQuantity(msg.sender, i);
1546             if (qty == 0) {
1547                 continue;
1548             }
1549 
1550             vestingSchedules[msg.sender][i] = [0, 0];
1551             total = total.add(qty);
1552         }
1553 
1554         if (total != 0) {
1555             totalVestedBalance = totalVestedBalance.sub(total);
1556             totalVestedAccountBalance[msg.sender] = totalVestedAccountBalance[msg.sender].sub(total);
1557             synthetix.transfer(msg.sender, total);
1558             emit Vested(msg.sender, now, total);
1559         }
1560     }
1561 
1562 
1563     /* ========== EVENTS ========== */
1564 
1565     event SynthetixUpdated(address newSynthetix);
1566 
1567     event Vested(address indexed beneficiary, uint time, uint value);
1568 }
1569 
1570 
1571 /*
1572 -----------------------------------------------------------------
1573 FILE INFORMATION
1574 -----------------------------------------------------------------
1575 
1576 file:       SynthetixState.sol
1577 version:    1.0
1578 author:     Kevin Brown
1579 date:       2018-10-19
1580 
1581 -----------------------------------------------------------------
1582 MODULE DESCRIPTION
1583 -----------------------------------------------------------------
1584 
1585 A contract that holds issuance state and preferred currency of
1586 users in the Synthetix system.
1587 
1588 This contract is used side by side with the Synthetix contract
1589 to make it easier to upgrade the contract logic while maintaining
1590 issuance state.
1591 
1592 The Synthetix contract is also quite large and on the edge of
1593 being beyond the contract size limit without moving this information
1594 out to another contract.
1595 
1596 The first deployed contract would create this state contract,
1597 using it as its store of issuance data.
1598 
1599 When a new contract is deployed, it links to the existing
1600 state contract, whose owner would then change its associated
1601 contract to the new one.
1602 
1603 -----------------------------------------------------------------
1604 */
1605 
1606 
1607 /**
1608  * @title Synthetix State
1609  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
1610  */
1611 contract SynthetixState is State, LimitedSetup {
1612     using SafeMath for uint;
1613     using SafeDecimalMath for uint;
1614 
1615     // A struct for handing values associated with an individual user's debt position
1616     struct IssuanceData {
1617         // Percentage of the total debt owned at the time
1618         // of issuance. This number is modified by the global debt
1619         // delta array. You can figure out a user's exit price and
1620         // collateralisation ratio using a combination of their initial
1621         // debt and the slice of global debt delta which applies to them.
1622         uint initialDebtOwnership;
1623         // This lets us know when (in relative terms) the user entered
1624         // the debt pool so we can calculate their exit price and
1625         // collateralistion ratio
1626         uint debtEntryIndex;
1627     }
1628 
1629     // Issued synth balances for individual fee entitlements and exit price calculations
1630     mapping(address => IssuanceData) public issuanceData;
1631 
1632     // The total count of people that have outstanding issued synths in any flavour
1633     uint public totalIssuerCount;
1634 
1635     // Global debt pool tracking
1636     uint[] public debtLedger;
1637 
1638     // Import state
1639     uint public importedXDRAmount;
1640 
1641     // A quantity of synths greater than this ratio
1642     // may not be issued against a given value of SNX.
1643     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
1644     // No more synths may be issued than the value of SNX backing them.
1645     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
1646 
1647     // Users can specify their preferred currency, in which case all synths they receive
1648     // will automatically exchange to that preferred currency upon receipt in their wallet
1649     mapping(address => bytes4) public preferredCurrency;
1650 
1651     /**
1652      * @dev Constructor
1653      * @param _owner The address which controls this contract.
1654      * @param _associatedContract The ERC20 contract whose state this composes.
1655      */
1656     constructor(address _owner, address _associatedContract)
1657         State(_owner, _associatedContract)
1658         LimitedSetup(1 weeks)
1659         public
1660     {}
1661 
1662     /* ========== SETTERS ========== */
1663 
1664     /**
1665      * @notice Set issuance data for an address
1666      * @dev Only the associated contract may call this.
1667      * @param account The address to set the data for.
1668      * @param initialDebtOwnership The initial debt ownership for this address.
1669      */
1670     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
1671         external
1672         onlyAssociatedContract
1673     {
1674         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
1675         issuanceData[account].debtEntryIndex = debtLedger.length;
1676     }
1677 
1678     /**
1679      * @notice Clear issuance data for an address
1680      * @dev Only the associated contract may call this.
1681      * @param account The address to clear the data for.
1682      */
1683     function clearIssuanceData(address account)
1684         external
1685         onlyAssociatedContract
1686     {
1687         delete issuanceData[account];
1688     }
1689 
1690     /**
1691      * @notice Increment the total issuer count
1692      * @dev Only the associated contract may call this.
1693      */
1694     function incrementTotalIssuerCount()
1695         external
1696         onlyAssociatedContract
1697     {
1698         totalIssuerCount = totalIssuerCount.add(1);
1699     }
1700 
1701     /**
1702      * @notice Decrement the total issuer count
1703      * @dev Only the associated contract may call this.
1704      */
1705     function decrementTotalIssuerCount()
1706         external
1707         onlyAssociatedContract
1708     {
1709         totalIssuerCount = totalIssuerCount.sub(1);
1710     }
1711 
1712     /**
1713      * @notice Append a value to the debt ledger
1714      * @dev Only the associated contract may call this.
1715      * @param value The new value to be added to the debt ledger.
1716      */
1717     function appendDebtLedgerValue(uint value)
1718         external
1719         onlyAssociatedContract
1720     {
1721         debtLedger.push(value);
1722     }
1723 
1724     /**
1725      * @notice Set preferred currency for a user
1726      * @dev Only the associated contract may call this.
1727      * @param account The account to set the preferred currency for
1728      * @param currencyKey The new preferred currency
1729      */
1730     function setPreferredCurrency(address account, bytes4 currencyKey)
1731         external
1732         onlyAssociatedContract
1733     {
1734         preferredCurrency[account] = currencyKey;
1735     }
1736 
1737     /**
1738      * @notice Set the issuanceRatio for issuance calculations.
1739      * @dev Only callable by the contract owner.
1740      */
1741     function setIssuanceRatio(uint _issuanceRatio)
1742         external
1743         onlyOwner
1744     {
1745         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
1746         issuanceRatio = _issuanceRatio;
1747         emit IssuanceRatioUpdated(_issuanceRatio);
1748     }
1749 
1750     /**
1751      * @notice Import issuer data from the old Synthetix contract before multicurrency
1752      * @dev Only callable by the contract owner, and only for 1 week after deployment.
1753      */
1754     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
1755         external
1756         onlyOwner
1757         onlyDuringSetup
1758     {
1759         require(accounts.length == sUSDAmounts.length, "Length mismatch");
1760 
1761         for (uint8 i = 0; i < accounts.length; i++) {
1762             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
1763         }
1764     }
1765 
1766     /**
1767      * @notice Import issuer data from the old Synthetix contract before multicurrency
1768      * @dev Only used from importIssuerData above, meant to be disposable
1769      */
1770     function _addToDebtRegister(address account, uint amount)
1771         internal
1772     {
1773         // This code is duplicated from Synthetix so that we can call it directly here
1774         // during setup only.
1775         Synthetix synthetix = Synthetix(associatedContract);
1776 
1777         // What is the value of the requested debt in XDRs?
1778         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
1779 
1780         // What is the value that we've previously imported?
1781         uint totalDebtIssued = importedXDRAmount;
1782 
1783         // What will the new total be including the new value?
1784         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
1785 
1786         // Save that for the next import.
1787         importedXDRAmount = newTotalDebtIssued;
1788 
1789         // What is their percentage (as a high precision int) of the total debt?
1790         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
1791 
1792         // And what effect does this percentage have on the global debt holding of other issuers?
1793         // The delta specifically needs to not take into account any existing debt as it's already
1794         // accounted for in the delta from when they issued previously.
1795         // The delta is a high precision integer.
1796         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
1797 
1798         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
1799 
1800         // And what does their debt ownership look like including this previous stake?
1801         if (existingDebt > 0) {
1802             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
1803         }
1804 
1805         // Are they a new issuer? If so, record them.
1806         if (issuanceData[account].initialDebtOwnership == 0) {
1807             totalIssuerCount = totalIssuerCount.add(1);
1808         }
1809 
1810         // Save the debt entry parameters
1811         issuanceData[account].initialDebtOwnership = debtPercentage;
1812         issuanceData[account].debtEntryIndex = debtLedger.length;
1813 
1814         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
1815         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
1816         if (debtLedger.length > 0) {
1817             debtLedger.push(
1818                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
1819             );
1820         } else {
1821             debtLedger.push(SafeDecimalMath.preciseUnit());
1822         }
1823     }
1824 
1825     /* ========== VIEWS ========== */
1826 
1827     /**
1828      * @notice Retrieve the length of the debt ledger array
1829      */
1830     function debtLedgerLength()
1831         external
1832         view
1833         returns (uint)
1834     {
1835         return debtLedger.length;
1836     }
1837 
1838     /**
1839      * @notice Retrieve the most recent entry from the debt ledger
1840      */
1841     function lastDebtLedgerEntry()
1842         external
1843         view
1844         returns (uint)
1845     {
1846         return debtLedger[debtLedger.length - 1];
1847     }
1848 
1849     /**
1850      * @notice Query whether an account has issued and has an outstanding debt balance
1851      * @param account The address to query for
1852      */
1853     function hasIssued(address account)
1854         external
1855         view
1856         returns (bool)
1857     {
1858         return issuanceData[account].initialDebtOwnership > 0;
1859     }
1860 
1861     event IssuanceRatioUpdated(uint newRatio);
1862 }
1863 
1864 
1865 /*
1866 -----------------------------------------------------------------
1867 FILE INFORMATION
1868 -----------------------------------------------------------------
1869 
1870 file:       ExchangeRates.sol
1871 version:    1.0
1872 author:     Kevin Brown
1873 date:       2018-09-12
1874 
1875 -----------------------------------------------------------------
1876 MODULE DESCRIPTION
1877 -----------------------------------------------------------------
1878 
1879 A contract that any other contract in the Synthetix system can query
1880 for the current market value of various assets, including
1881 crypto assets as well as various fiat assets.
1882 
1883 This contract assumes that rate updates will completely update
1884 all rates to their current values. If a rate shock happens
1885 on a single asset, the oracle will still push updated rates
1886 for all other assets.
1887 
1888 -----------------------------------------------------------------
1889 */
1890 
1891 
1892 /**
1893  * @title The repository for exchange rates
1894  */
1895 contract ExchangeRates is SelfDestructible {
1896 
1897     using SafeMath for uint;
1898 
1899     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
1900     mapping(bytes4 => uint) public rates;
1901 
1902     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
1903     mapping(bytes4 => uint) public lastRateUpdateTimes;
1904 
1905     // The address of the oracle which pushes rate updates to this contract
1906     address public oracle;
1907 
1908     // Do not allow the oracle to submit times any further forward into the future than this constant.
1909     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
1910 
1911     // How long will the contract assume the rate of any asset is correct
1912     uint public rateStalePeriod = 3 hours;
1913 
1914     // Each participating currency in the XDR basket is represented as a currency key with
1915     // equal weighting.
1916     // There are 5 participating currencies, so we'll declare that clearly.
1917     bytes4[5] public xdrParticipants;
1918 
1919     //
1920     // ========== CONSTRUCTOR ==========
1921 
1922     /**
1923      * @dev Constructor
1924      * @param _owner The owner of this contract.
1925      * @param _oracle The address which is able to update rate information.
1926      * @param _currencyKeys The initial currency keys to store (in order).
1927      * @param _newRates The initial currency amounts for each currency (in order).
1928      */
1929     constructor(
1930         // SelfDestructible (Ownable)
1931         address _owner,
1932 
1933         // Oracle values - Allows for rate updates
1934         address _oracle,
1935         bytes4[] _currencyKeys,
1936         uint[] _newRates
1937     )
1938         /* Owned is initialised in SelfDestructible */
1939         SelfDestructible(_owner)
1940         public
1941     {
1942         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
1943 
1944         oracle = _oracle;
1945 
1946         // The sUSD rate is always 1 and is never stale.
1947         rates["sUSD"] = SafeDecimalMath.unit();
1948         lastRateUpdateTimes["sUSD"] = now;
1949 
1950         // These are the currencies that make up the XDR basket.
1951         // These are hard coded because:
1952         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
1953         //  - Adding new currencies would likely introduce some kind of weighting factor, which
1954         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
1955         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
1956         //    then point the system at the new version.
1957         xdrParticipants = [
1958             bytes4("sUSD"),
1959             bytes4("sAUD"),
1960             bytes4("sCHF"),
1961             bytes4("sEUR"),
1962             bytes4("sGBP")
1963         ];
1964 
1965         internalUpdateRates(_currencyKeys, _newRates, now);
1966     }
1967 
1968     /* ========== SETTERS ========== */
1969 
1970     /**
1971      * @notice Set the rates stored in this contract
1972      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1973      * @param newRates The rates for each currency (in order)
1974      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1975      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1976      *                 if it takes a long time for the transaction to confirm.
1977      */
1978     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
1979         external
1980         onlyOracle
1981         returns(bool)
1982     {
1983         return internalUpdateRates(currencyKeys, newRates, timeSent);
1984     }
1985 
1986     /**
1987      * @notice Internal function which sets the rates stored in this contract
1988      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1989      * @param newRates The rates for each currency (in order)
1990      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1991      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1992      *                 if it takes a long time for the transaction to confirm.
1993      */
1994     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
1995         internal
1996         returns(bool)
1997     {
1998         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
1999         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
2000 
2001         // Loop through each key and perform update.
2002         for (uint i = 0; i < currencyKeys.length; i++) {
2003             // Should not set any rate to zero ever, as no asset will ever be
2004             // truely worthless and still valid. In this scenario, we should
2005             // delete the rate and remove it from the system.
2006             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
2007             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
2008 
2009             // We should only update the rate if it's at least the same age as the last rate we've got.
2010             if (timeSent >= lastRateUpdateTimes[currencyKeys[i]]) {
2011                 // Ok, go ahead with the update.
2012                 rates[currencyKeys[i]] = newRates[i];
2013                 lastRateUpdateTimes[currencyKeys[i]] = timeSent;
2014             }
2015         }
2016 
2017         emit RatesUpdated(currencyKeys, newRates);
2018 
2019         // Now update our XDR rate.
2020         updateXDRRate(timeSent);
2021 
2022         return true;
2023     }
2024 
2025     /**
2026      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
2027      */
2028     function updateXDRRate(uint timeSent)
2029         internal
2030     {
2031         uint total = 0;
2032 
2033         for (uint i = 0; i < xdrParticipants.length; i++) {
2034             total = rates[xdrParticipants[i]].add(total);
2035         }
2036 
2037         // Set the rate
2038         rates["XDR"] = total;
2039 
2040         // Record that we updated the XDR rate.
2041         lastRateUpdateTimes["XDR"] = timeSent;
2042 
2043         // Emit our updated event separate to the others to save
2044         // moving data around between arrays.
2045         bytes4[] memory eventCurrencyCode = new bytes4[](1);
2046         eventCurrencyCode[0] = "XDR";
2047 
2048         uint[] memory eventRate = new uint[](1);
2049         eventRate[0] = rates["XDR"];
2050 
2051         emit RatesUpdated(eventCurrencyCode, eventRate);
2052     }
2053 
2054     /**
2055      * @notice Delete a rate stored in the contract
2056      * @param currencyKey The currency key you wish to delete the rate for
2057      */
2058     function deleteRate(bytes4 currencyKey)
2059         external
2060         onlyOracle
2061     {
2062         require(rates[currencyKey] > 0, "Rate is zero");
2063 
2064         delete rates[currencyKey];
2065         delete lastRateUpdateTimes[currencyKey];
2066 
2067         emit RateDeleted(currencyKey);
2068     }
2069 
2070     /**
2071      * @notice Set the Oracle that pushes the rate information to this contract
2072      * @param _oracle The new oracle address
2073      */
2074     function setOracle(address _oracle)
2075         external
2076         onlyOwner
2077     {
2078         oracle = _oracle;
2079         emit OracleUpdated(oracle);
2080     }
2081 
2082     /**
2083      * @notice Set the stale period on the updated rate variables
2084      * @param _time The new rateStalePeriod
2085      */
2086     function setRateStalePeriod(uint _time)
2087         external
2088         onlyOwner
2089     {
2090         rateStalePeriod = _time;
2091         emit RateStalePeriodUpdated(rateStalePeriod);
2092     }
2093 
2094     /* ========== VIEWS ========== */
2095 
2096     /**
2097      * @notice Retrieve the rate for a specific currency
2098      */
2099     function rateForCurrency(bytes4 currencyKey)
2100         public
2101         view
2102         returns (uint)
2103     {
2104         return rates[currencyKey];
2105     }
2106 
2107     /**
2108      * @notice Retrieve the rates for a list of currencies
2109      */
2110     function ratesForCurrencies(bytes4[] currencyKeys)
2111         public
2112         view
2113         returns (uint[])
2114     {
2115         uint[] memory _rates = new uint[](currencyKeys.length);
2116 
2117         for (uint8 i = 0; i < currencyKeys.length; i++) {
2118             _rates[i] = rates[currencyKeys[i]];
2119         }
2120 
2121         return _rates;
2122     }
2123 
2124     /**
2125      * @notice Retrieve a list of last update times for specific currencies
2126      */
2127     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
2128         public
2129         view
2130         returns (uint)
2131     {
2132         return lastRateUpdateTimes[currencyKey];
2133     }
2134 
2135     /**
2136      * @notice Retrieve the last update time for a specific currency
2137      */
2138     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
2139         public
2140         view
2141         returns (uint[])
2142     {
2143         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
2144 
2145         for (uint8 i = 0; i < currencyKeys.length; i++) {
2146             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
2147         }
2148 
2149         return lastUpdateTimes;
2150     }
2151 
2152     /**
2153      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
2154      */
2155     function rateIsStale(bytes4 currencyKey)
2156         external
2157         view
2158         returns (bool)
2159     {
2160         // sUSD is a special case and is never stale.
2161         if (currencyKey == "sUSD") return false;
2162 
2163         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
2164     }
2165 
2166     /**
2167      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
2168      */
2169     function anyRateIsStale(bytes4[] currencyKeys)
2170         external
2171         view
2172         returns (bool)
2173     {
2174         // Loop through each key and check whether the data point is stale.
2175         uint256 i = 0;
2176 
2177         while (i < currencyKeys.length) {
2178             // sUSD is a special case and is never false
2179             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
2180                 return true;
2181             }
2182             i += 1;
2183         }
2184 
2185         return false;
2186     }
2187 
2188     /* ========== MODIFIERS ========== */
2189 
2190     modifier onlyOracle
2191     {
2192         require(msg.sender == oracle, "Only the oracle can perform this action");
2193         _;
2194     }
2195 
2196     /* ========== EVENTS ========== */
2197 
2198     event OracleUpdated(address newOracle);
2199     event RateStalePeriodUpdated(uint rateStalePeriod);
2200     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
2201     event RateDeleted(bytes4 currencyKey);
2202 }
2203 
2204 
2205 /*
2206 -----------------------------------------------------------------
2207 FILE INFORMATION
2208 -----------------------------------------------------------------
2209 
2210 file:       Synthetix.sol
2211 version:    2.0
2212 author:     Kevin Brown
2213             Gavin Conway
2214 date:       2018-09-14
2215 
2216 -----------------------------------------------------------------
2217 MODULE DESCRIPTION
2218 -----------------------------------------------------------------
2219 
2220 Synthetix token contract. SNX is a transferable ERC20 token,
2221 and also give its holders the following privileges.
2222 An owner of SNX has the right to issue synths in all synth flavours.
2223 
2224 After a fee period terminates, the duration and fees collected for that
2225 period are computed, and the next period begins. Thus an account may only
2226 withdraw the fees owed to them for the previous period, and may only do
2227 so once per period. Any unclaimed fees roll over into the common pot for
2228 the next period.
2229 
2230 == Average Balance Calculations ==
2231 
2232 The fee entitlement of a synthetix holder is proportional to their average
2233 issued synth balance over the last fee period. This is computed by
2234 measuring the area under the graph of a user's issued synth balance over
2235 time, and then when a new fee period begins, dividing through by the
2236 duration of the fee period.
2237 
2238 We need only update values when the balances of an account is modified.
2239 This occurs when issuing or burning for issued synth balances,
2240 and when transferring for synthetix balances. This is for efficiency,
2241 and adds an implicit friction to interacting with SNX.
2242 A synthetix holder pays for his own recomputation whenever he wants to change
2243 his position, which saves the foundation having to maintain a pot dedicated
2244 to resourcing this.
2245 
2246 A hypothetical user's balance history over one fee period, pictorially:
2247 
2248       s ____
2249        |    |
2250        |    |___ p
2251        |____|___|___ __ _  _
2252        f    t   n
2253 
2254 Here, the balance was s between times f and t, at which time a transfer
2255 occurred, updating the balance to p, until n, when the present transfer occurs.
2256 When a new transfer occurs at time n, the balance being p,
2257 we must:
2258 
2259   - Add the area p * (n - t) to the total area recorded so far
2260   - Update the last transfer time to n
2261 
2262 So if this graph represents the entire current fee period,
2263 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
2264 The complementary computations must be performed for both sender and
2265 recipient.
2266 
2267 Note that a transfer keeps global supply of SNX invariant.
2268 The sum of all balances is constant, and unmodified by any transfer.
2269 So the sum of all balances multiplied by the duration of a fee period is also
2270 constant, and this is equivalent to the sum of the area of every user's
2271 time/balance graph. Dividing through by that duration yields back the total
2272 synthetix supply. So, at the end of a fee period, we really do yield a user's
2273 average share in the synthetix supply over that period.
2274 
2275 A slight wrinkle is introduced if we consider the time r when the fee period
2276 rolls over. Then the previous fee period k-1 is before r, and the current fee
2277 period k is afterwards. If the last transfer took place before r,
2278 but the latest transfer occurred afterwards:
2279 
2280 k-1       |        k
2281       s __|_
2282        |  | |
2283        |  | |____ p
2284        |__|_|____|___ __ _  _
2285           |
2286        f  | t    n
2287           r
2288 
2289 In this situation the area (r-f)*s contributes to fee period k-1, while
2290 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2291 zero-value transfer to have occurred at time r. Their fee entitlement for the
2292 previous period will be finalised at the time of their first transfer during the
2293 current fee period, or when they query or withdraw their fee entitlement.
2294 
2295 In the implementation, the duration of different fee periods may be slightly irregular,
2296 as the check that they have rolled over occurs only when state-changing synthetix
2297 operations are performed.
2298 
2299 == Issuance and Burning ==
2300 
2301 In this version of the synthetix contract, synths can only be issued by
2302 those that have been nominated by the synthetix foundation. Synths are assumed
2303 to be valued at $1, as they are a stable unit of account.
2304 
2305 All synths issued require a proportional value of SNX to be locked,
2306 where the proportion is governed by the current issuance ratio. This
2307 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
2308 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
2309 
2310 To determine the value of some amount of SNX(S), an oracle is used to push
2311 the price of SNX (P_S) in dollars to the contract. The value of S
2312 would then be: S * P_S.
2313 
2314 Any SNX that are locked up by this issuance process cannot be transferred.
2315 The amount that is locked floats based on the price of SNX. If the price
2316 of SNX moves up, less SNX are locked, so they can be issued against,
2317 or transferred freely. If the price of SNX moves down, more SNX are locked,
2318 even going above the initial wallet balance.
2319 
2320 -----------------------------------------------------------------
2321 */
2322 
2323 
2324 /**
2325  * @title Synthetix ERC20 contract.
2326  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2327  * but it also computes the quantity of fees each synthetix holder is entitled to.
2328  */
2329 contract Synthetix is ExternStateToken {
2330 
2331     // ========== STATE VARIABLES ==========
2332 
2333     // Available Synths which can be used with the system
2334     Synth[] public availableSynths;
2335     mapping(bytes4 => Synth) public synths;
2336 
2337     FeePool public feePool;
2338     SynthetixEscrow public escrow;
2339     ExchangeRates public exchangeRates;
2340     SynthetixState public synthetixState;
2341 
2342     uint constant SYNTHETIX_SUPPLY = 1e8 * SafeDecimalMath.unit();
2343     string constant TOKEN_NAME = "Synthetix";
2344     string constant TOKEN_SYMBOL = "SNX";
2345     uint8 constant DECIMALS = 18;
2346 
2347     // ========== CONSTRUCTOR ==========
2348 
2349     /**
2350      * @dev Constructor
2351      * @param _tokenState A pre-populated contract containing token balances.
2352      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2353      * @param _owner The owner of this contract.
2354      */
2355     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2356         address _owner, ExchangeRates _exchangeRates, FeePool _feePool
2357     )
2358         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, SYNTHETIX_SUPPLY, DECIMALS, _owner)
2359         public
2360     {
2361         synthetixState = _synthetixState;
2362         exchangeRates = _exchangeRates;
2363         feePool = _feePool;
2364     }
2365 
2366     // ========== SETTERS ========== */
2367 
2368     /**
2369      * @notice Add an associated Synth contract to the Synthetix system
2370      * @dev Only the contract owner may call this.
2371      */
2372     function addSynth(Synth synth)
2373         external
2374         optionalProxy_onlyOwner
2375     {
2376         bytes4 currencyKey = synth.currencyKey();
2377 
2378         require(synths[currencyKey] == Synth(0), "Synth already exists");
2379 
2380         availableSynths.push(synth);
2381         synths[currencyKey] = synth;
2382 
2383         emitSynthAdded(currencyKey, synth);
2384     }
2385 
2386     /**
2387      * @notice Remove an associated Synth contract from the Synthetix system
2388      * @dev Only the contract owner may call this.
2389      */
2390     function removeSynth(bytes4 currencyKey)
2391         external
2392         optionalProxy_onlyOwner
2393     {
2394         require(synths[currencyKey] != address(0), "Synth does not exist");
2395         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2396         require(currencyKey != "XDR", "Cannot remove XDR synth");
2397 
2398         // Save the address we're removing for emitting the event at the end.
2399         address synthToRemove = synths[currencyKey];
2400 
2401         // Remove the synth from the availableSynths array.
2402         for (uint8 i = 0; i < availableSynths.length; i++) {
2403             if (availableSynths[i] == synthToRemove) {
2404                 delete availableSynths[i];
2405 
2406                 // Copy the last synth into the place of the one we just deleted
2407                 // If there's only one synth, this is synths[0] = synths[0].
2408                 // If we're deleting the last one, it's also a NOOP in the same way.
2409                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2410 
2411                 // Decrease the size of the array by one.
2412                 availableSynths.length--;
2413 
2414                 break;
2415             }
2416         }
2417 
2418         // And remove it from the synths mapping
2419         delete synths[currencyKey];
2420 
2421         emitSynthRemoved(currencyKey, synthToRemove);
2422     }
2423 
2424     /**
2425      * @notice Set the associated synthetix escrow contract.
2426      * @dev Only the contract owner may call this.
2427      */
2428     function setEscrow(SynthetixEscrow _escrow)
2429         external
2430         optionalProxy_onlyOwner
2431     {
2432         escrow = _escrow;
2433         // Note: No event here as our contract exceeds max contract size
2434         // with these events, and it's unlikely people will need to
2435         // track these events specifically.
2436     }
2437 
2438     /**
2439      * @notice Set the ExchangeRates contract address where rates are held.
2440      * @dev Only callable by the contract owner.
2441      */
2442     function setExchangeRates(ExchangeRates _exchangeRates)
2443         external
2444         optionalProxy_onlyOwner
2445     {
2446         exchangeRates = _exchangeRates;
2447         // Note: No event here as our contract exceeds max contract size
2448         // with these events, and it's unlikely people will need to
2449         // track these events specifically.
2450     }
2451 
2452     /**
2453      * @notice Set the synthetixState contract address where issuance data is held.
2454      * @dev Only callable by the contract owner.
2455      */
2456     function setSynthetixState(SynthetixState _synthetixState)
2457         external
2458         optionalProxy_onlyOwner
2459     {
2460         synthetixState = _synthetixState;
2461 
2462         emitStateContractChanged(_synthetixState);
2463     }
2464 
2465     /**
2466      * @notice Set your preferred currency. Note: This does not automatically exchange any balances you've held previously in
2467      * other synth currencies in this address, it will apply for any new payments you receive at this address.
2468      */
2469     function setPreferredCurrency(bytes4 currencyKey)
2470         external
2471         optionalProxy
2472     {
2473         require(currencyKey == 0 || !exchangeRates.rateIsStale(currencyKey), "Currency rate is stale or doesn't exist.");
2474 
2475         synthetixState.setPreferredCurrency(messageSender, currencyKey);
2476 
2477         emitPreferredCurrencyChanged(messageSender, currencyKey);
2478     }
2479 
2480     // ========== VIEWS ==========
2481 
2482     /**
2483      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2484      * @param sourceCurrencyKey The currency the amount is specified in
2485      * @param sourceAmount The source amount, specified in UNIT base
2486      * @param destinationCurrencyKey The destination currency
2487      */
2488     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
2489         public
2490         view
2491         rateNotStale(sourceCurrencyKey)
2492         rateNotStale(destinationCurrencyKey)
2493         returns (uint)
2494     {
2495         // If there's no change in the currency, then just return the amount they gave us
2496         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
2497 
2498         // Calculate the effective value by going from source -> USD -> destination
2499         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
2500             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
2501     }
2502 
2503     /**
2504      * @notice Total amount of synths issued by the system, priced in currencyKey
2505      * @param currencyKey The currency to value the synths in
2506      */
2507     function totalIssuedSynths(bytes4 currencyKey)
2508         public
2509         view
2510         rateNotStale(currencyKey)
2511         returns (uint)
2512     {
2513         uint total = 0;
2514         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2515 
2516         for (uint8 i = 0; i < availableSynths.length; i++) {
2517             // Ensure the rate isn't stale.
2518             // TODO: Investigate gas cost optimisation of doing a single call with all keys in it vs
2519             // individual calls like this.
2520             require(!exchangeRates.rateIsStale(availableSynths[i].currencyKey()), "Rate is stale");
2521 
2522             // What's the total issued value of that synth in the destination currency?
2523             // Note: We're not using our effectiveValue function because we don't want to go get the
2524             //       rate for the destination currency and check if it's stale repeatedly on every
2525             //       iteration of the loop
2526             uint synthValue = availableSynths[i].totalSupply()
2527                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
2528                 .divideDecimalRound(currencyRate);
2529             total = total.add(synthValue);
2530         }
2531 
2532         return total;
2533     }
2534 
2535     /**
2536      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
2537      */
2538     function availableSynthCount()
2539         public
2540         view
2541         returns (uint)
2542     {
2543         return availableSynths.length;
2544     }
2545 
2546     // ========== MUTATIVE FUNCTIONS ==========
2547 
2548     /**
2549      * @notice ERC20 transfer function.
2550      */
2551     function transfer(address to, uint value)
2552         public
2553         returns (bool)
2554     {
2555         bytes memory empty;
2556         return transfer(to, value, empty);
2557     }
2558 
2559     /**
2560      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
2561      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2562      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2563      *           tooling such as Etherscan.
2564      */
2565     function transfer(address to, uint value, bytes data)
2566         public
2567         optionalProxy
2568         returns (bool)
2569     {
2570         // Ensure they're not trying to exceed their locked amount
2571         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
2572 
2573         // Perform the transfer: if there is a problem an exception will be thrown in this call.
2574         _transfer_byProxy(messageSender, to, value, data);
2575 
2576         return true;
2577     }
2578 
2579     /**
2580      * @notice ERC20 transferFrom function.
2581      */
2582     function transferFrom(address from, address to, uint value)
2583         public
2584         returns (bool)
2585     {
2586         bytes memory empty;
2587         return transferFrom(from, to, value, empty);
2588     }
2589 
2590     /**
2591      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
2592      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2593      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2594      *           tooling such as Etherscan.
2595      */
2596     function transferFrom(address from, address to, uint value, bytes data)
2597         public
2598         optionalProxy
2599         returns (bool)
2600     {
2601         // Ensure they're not trying to exceed their locked amount
2602         require(value <= transferableSynthetix(from), "Insufficient balance");
2603 
2604         // Perform the transfer: if there is a problem,
2605         // an exception will be thrown in this call.
2606         _transferFrom_byProxy(messageSender, from, to, value, data);
2607 
2608         return true;
2609     }
2610 
2611     /**
2612      * @notice Function that allows you to exchange synths you hold in one flavour for another.
2613      * @param sourceCurrencyKey The source currency you wish to exchange from
2614      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2615      * @param destinationCurrencyKey The destination currency you wish to obtain.
2616      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
2617      * @return Boolean that indicates whether the transfer succeeded or failed.
2618      */
2619     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
2620         external
2621         optionalProxy
2622         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
2623         returns (bool)
2624     {
2625         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
2626         require(sourceAmount > 0, "Zero amount");
2627 
2628         // Pass it along, defaulting to the sender as the recipient.
2629         return _internalExchange(
2630             messageSender,
2631             sourceCurrencyKey,
2632             sourceAmount,
2633             destinationCurrencyKey,
2634             destinationAddress == address(0) ? messageSender : destinationAddress,
2635             true // Charge fee on the exchange
2636         );
2637     }
2638 
2639     /**
2640      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
2641      * @dev Only the synth contract can call this function
2642      * @param from The address to exchange / burn synth from
2643      * @param sourceCurrencyKey The source currency you wish to exchange from
2644      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2645      * @param destinationCurrencyKey The destination currency you wish to obtain.
2646      * @param destinationAddress Where the result should go.
2647      * @return Boolean that indicates whether the transfer succeeded or failed.
2648      */
2649     function synthInitiatedExchange(
2650         address from,
2651         bytes4 sourceCurrencyKey,
2652         uint sourceAmount,
2653         bytes4 destinationCurrencyKey,
2654         address destinationAddress
2655     )
2656         external
2657         onlySynth
2658         returns (bool)
2659     {
2660         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
2661         require(sourceAmount > 0, "Zero amount");
2662 
2663         // Pass it along
2664         return _internalExchange(
2665             from,
2666             sourceCurrencyKey,
2667             sourceAmount,
2668             destinationCurrencyKey,
2669             destinationAddress,
2670             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
2671         );
2672     }
2673 
2674     /**
2675      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
2676      * @dev Only the synth contract can call this function.
2677      * @param from The address fee is coming from.
2678      * @param sourceCurrencyKey source currency fee from.
2679      * @param sourceAmount The amount, specified in UNIT of source currency.
2680      * @return Boolean that indicates whether the transfer succeeded or failed.
2681      */
2682     function synthInitiatedFeePayment(
2683         address from,
2684         bytes4 sourceCurrencyKey,
2685         uint sourceAmount
2686     )
2687         external
2688         onlySynth
2689         returns (bool)
2690     {
2691         require(sourceAmount > 0, "Source can't be 0");
2692 
2693         // Pass it along, defaulting to the sender as the recipient.
2694         bool result = _internalExchange(
2695             from,
2696             sourceCurrencyKey,
2697             sourceAmount,
2698             "XDR",
2699             feePool.FEE_ADDRESS(),
2700             false // Don't charge a fee on the exchange because this is already a fee
2701         );
2702 
2703         // Tell the fee pool about this.
2704         feePool.feePaid(sourceCurrencyKey, sourceAmount);
2705 
2706         return result;
2707     }
2708 
2709     /**
2710      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
2711      * @dev fee pool contract address is not allowed to call function
2712      * @param from The address to move synth from
2713      * @param sourceCurrencyKey source currency from.
2714      * @param sourceAmount The amount, specified in UNIT of source currency.
2715      * @param destinationCurrencyKey The destination currency to obtain.
2716      * @param destinationAddress Where the result should go.
2717      * @param chargeFee Boolean to charge a fee for transaction.
2718      * @return Boolean that indicates whether the transfer succeeded or failed.
2719      */
2720     function _internalExchange(
2721         address from,
2722         bytes4 sourceCurrencyKey,
2723         uint sourceAmount,
2724         bytes4 destinationCurrencyKey,
2725         address destinationAddress,
2726         bool chargeFee
2727     )
2728         internal
2729         notFeeAddress(from)
2730         returns (bool)
2731     {
2732         require(destinationAddress != address(0), "Zero destination");
2733         require(destinationAddress != address(this), "Synthetix is invalid destination");
2734         require(destinationAddress != address(proxy), "Proxy is invalid destination");
2735 
2736         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
2737         // the subtraction to not overflow, which would happen if their balance is not sufficient.
2738 
2739         // Burn the source amount
2740         synths[sourceCurrencyKey].burn(from, sourceAmount);
2741 
2742         // How much should they get in the destination currency?
2743         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
2744 
2745         // What's the fee on that currency that we should deduct?
2746         uint amountReceived = destinationAmount;
2747         uint fee = 0;
2748 
2749         if (chargeFee) {
2750             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
2751             fee = destinationAmount.sub(amountReceived);
2752         }
2753 
2754         // Issue their new synths
2755         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
2756 
2757         // Remit the fee in XDRs
2758         if (fee > 0) {
2759             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
2760             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
2761         }
2762 
2763         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
2764 
2765         // Call the ERC223 transfer callback if needed
2766         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
2767 
2768         // Gas optimisation:
2769         // No event emitted as it's assumed users will be able to track transfers to the zero address, followed
2770         // by a transfer on another synth from the zero address and ascertain the info required here.
2771 
2772         return true;
2773     }
2774 
2775     /**
2776      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
2777      * @dev Only internal calls from synthetix address.
2778      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
2779      * @param amount The amount of synths to register with a base of UNIT
2780      */
2781     function _addToDebtRegister(bytes4 currencyKey, uint amount)
2782         internal
2783         optionalProxy
2784     {
2785         // What is the value of the requested debt in XDRs?
2786         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
2787 
2788         // What is the value of all issued synths of the system (priced in XDRs)?
2789         uint totalDebtIssued = totalIssuedSynths("XDR");
2790 
2791         // What will the new total be including the new value?
2792         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2793 
2794         // What is their percentage (as a high precision int) of the total debt?
2795         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2796 
2797         // And what effect does this percentage have on the global debt holding of other issuers?
2798         // The delta specifically needs to not take into account any existing debt as it's already
2799         // accounted for in the delta from when they issued previously.
2800         // The delta is a high precision integer.
2801         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2802 
2803         // How much existing debt do they have?
2804         uint existingDebt = debtBalanceOf(messageSender, "XDR");
2805 
2806         // And what does their debt ownership look like including this previous stake?
2807         if (existingDebt > 0) {
2808             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2809         }
2810 
2811         // Are they a new issuer? If so, record them.
2812         if (!synthetixState.hasIssued(messageSender)) {
2813             synthetixState.incrementTotalIssuerCount();
2814         }
2815 
2816         // Save the debt entry parameters
2817         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
2818 
2819         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2820         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2821         if (synthetixState.debtLedgerLength() > 0) {
2822             synthetixState.appendDebtLedgerValue(
2823                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
2824             );
2825         } else {
2826             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
2827         }
2828     }
2829 
2830     /**
2831      * @notice Issue synths against the sender's SNX.
2832      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
2833      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
2834      * @param amount The amount of synths you wish to issue with a base of UNIT
2835      */
2836     function issueSynths(bytes4 currencyKey, uint amount)
2837         public
2838         optionalProxy
2839         nonZeroAmount(amount)
2840         // No need to check if price is stale, as it is checked in issuableSynths.
2841     {
2842         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
2843 
2844         // Keep track of the debt they're about to create
2845         _addToDebtRegister(currencyKey, amount);
2846 
2847         // Create their synths
2848         synths[currencyKey].issue(messageSender, amount);
2849     }
2850 
2851     /**
2852      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
2853      * @dev Issuance is only allowed if the synthetix price isn't stale.
2854      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
2855      */
2856     function issueMaxSynths(bytes4 currencyKey)
2857         external
2858         optionalProxy
2859     {
2860         // Figure out the maximum we can issue in that currency
2861         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
2862 
2863         // And issue them
2864         issueSynths(currencyKey, maxIssuable);
2865     }
2866 
2867     /**
2868      * @notice Burn synths to clear issued synths/free SNX.
2869      * @param currencyKey The currency you're specifying to burn
2870      * @param amount The amount (in UNIT base) you wish to burn
2871      */
2872     function burnSynths(bytes4 currencyKey, uint amount)
2873         external
2874         optionalProxy
2875         // No need to check for stale rates as _removeFromDebtRegister calls effectiveValue
2876         // which does this for us
2877     {
2878         // How much debt do they have?
2879         uint debt = debtBalanceOf(messageSender, currencyKey);
2880 
2881         require(debt > 0, "No debt to forgive");
2882 
2883         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
2884         // clear their debt and leave them be.
2885         uint amountToBurn = debt < amount ? debt : amount;
2886 
2887         // Remove their debt from the ledger
2888         _removeFromDebtRegister(currencyKey, amountToBurn);
2889 
2890         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
2891         synths[currencyKey].burn(messageSender, amountToBurn);
2892     }
2893 
2894     /**
2895      * @notice Remove a debt position from the register
2896      * @param currencyKey The currency the user is presenting to forgive their debt
2897      * @param amount The amount (in UNIT base) being presented
2898      */
2899     function _removeFromDebtRegister(bytes4 currencyKey, uint amount)
2900         internal
2901     {
2902         // How much debt are they trying to remove in XDRs?
2903         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
2904 
2905         // How much debt do they have?
2906         uint existingDebt = debtBalanceOf(messageSender, "XDR");
2907 
2908         // What percentage of the total debt are they trying to remove?
2909         uint totalDebtIssued = totalIssuedSynths("XDR");
2910         uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(totalDebtIssued);
2911 
2912         // And what effect does this percentage have on the global debt holding of other issuers?
2913         // The delta specifically needs to not take into account any existing debt as it's already
2914         // accounted for in the delta from when they issued previously.
2915         uint delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
2916 
2917         // Are they exiting the system, or are they just decreasing their debt position?
2918         if (debtToRemove == existingDebt) {
2919             synthetixState.clearIssuanceData(messageSender);
2920             synthetixState.decrementTotalIssuerCount();
2921         } else {
2922             // What percentage of the debt will they be left with?
2923             uint newDebt = existingDebt.sub(debtToRemove);
2924             uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
2925             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
2926 
2927             // Store the debt percentage and debt ledger as high precision integers
2928             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
2929         }
2930 
2931         // Update our cumulative ledger. This is also a high precision integer.
2932         synthetixState.appendDebtLedgerValue(
2933             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
2934         );
2935     }
2936 
2937     // ========== Issuance/Burning ==========
2938 
2939     /**
2940      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
2941      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
2942      */
2943     function maxIssuableSynths(address issuer, bytes4 currencyKey)
2944         public
2945         view
2946         // We don't need to check stale rates here as effectiveValue will do it for us.
2947         returns (uint)
2948     {
2949         // What is the value of their SNX balance in the destination currency?
2950         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
2951 
2952         // They're allowed to issue up to issuanceRatio of that value
2953         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
2954     }
2955 
2956     /**
2957      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
2958      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
2959      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
2960      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
2961      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
2962      * altering the amount of fees they're able to claim from the system.
2963      */
2964     function collateralisationRatio(address issuer)
2965         public
2966         view
2967         returns (uint)
2968     {
2969         uint totalOwnedSynthetix = collateral(issuer);
2970         if (totalOwnedSynthetix == 0) return 0;
2971 
2972         uint debtBalance = debtBalanceOf(issuer, "SNX");
2973         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
2974     }
2975 
2976 /**
2977      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
2978      * will tell you how many synths a user has to give back to the system in order to unlock their original
2979      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
2980      * the debt in sUSD, XDR, or any other synth you wish.
2981      */
2982     function debtBalanceOf(address issuer, bytes4 currencyKey)
2983         public
2984         view
2985         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
2986         returns (uint)
2987     {
2988         // What was their initial debt ownership?
2989         uint initialDebtOwnership;
2990         uint debtEntryIndex;
2991         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
2992 
2993         // If it's zero, they haven't issued, and they have no debt.
2994         if (initialDebtOwnership == 0) return 0;
2995 
2996         // Figure out the global debt percentage delta from when they entered the system.
2997         // This is a high precision integer.
2998         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
2999             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3000             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3001 
3002         // What's the total value of the system in their requested currency?
3003         uint totalSystemValue = totalIssuedSynths(currencyKey);
3004 
3005         // Their debt balance is their portion of the total system value.
3006         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3007             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3008 
3009         return highPrecisionBalance.preciseDecimalToDecimal();
3010     }
3011 
3012     /**
3013      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3014      * @param issuer The account that intends to issue
3015      * @param currencyKey The currency to price issuable value in
3016      */
3017     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
3018         public
3019         view
3020         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3021         returns (uint)
3022     {
3023         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3024         uint max = maxIssuableSynths(issuer, currencyKey);
3025 
3026         if (alreadyIssued >= max) {
3027             return 0;
3028         } else {
3029             return max.sub(alreadyIssued);
3030         }
3031     }
3032 
3033     /**
3034      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3035      * against which synths can be issued.
3036      * This includes those already being used as collateral (locked), and those
3037      * available for further issuance (unlocked).
3038      */
3039     function collateral(address account)
3040         public
3041         view
3042         returns (uint)
3043     {
3044         uint balance = tokenState.balanceOf(account);
3045 
3046         if (escrow != address(0)) {
3047             balance = balance.add(escrow.balanceOf(account));
3048         }
3049 
3050         return balance;
3051     }
3052 
3053     /**
3054      * @notice The number of SNX that are free to be transferred by an account.
3055      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
3056      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
3057      * in this calculation.
3058      */
3059     function transferableSynthetix(address account)
3060         public
3061         view
3062         rateNotStale("SNX")
3063         returns (uint)
3064     {
3065         // How many SNX do they have, excluding escrow?
3066         // Note: We're excluding escrow here because we're interested in their transferable amount
3067         // and escrowed SNX are not transferable.
3068         uint balance = tokenState.balanceOf(account);
3069 
3070         // How many of those will be locked by the amount they've issued?
3071         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3072         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3073         // The locked synthetix value can exceed their balance.
3074         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3075 
3076         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3077         if (lockedSynthetixValue >= balance) {
3078             return 0;
3079         } else {
3080             return balance.sub(lockedSynthetixValue);
3081         }
3082     }
3083 
3084     // ========== MODIFIERS ==========
3085 
3086     modifier rateNotStale(bytes4 currencyKey) {
3087         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
3088         _;
3089     }
3090 
3091     modifier notFeeAddress(address account) {
3092         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3093         _;
3094     }
3095 
3096     modifier onlySynth() {
3097         bool isSynth = false;
3098 
3099         // No need to repeatedly call this function either
3100         for (uint8 i = 0; i < availableSynths.length; i++) {
3101             if (availableSynths[i] == msg.sender) {
3102                 isSynth = true;
3103                 break;
3104             }
3105         }
3106 
3107         require(isSynth, "Only synth allowed");
3108         _;
3109     }
3110 
3111     modifier nonZeroAmount(uint _amount) {
3112         require(_amount > 0, "Amount needs to be larger than 0");
3113         _;
3114     }
3115 
3116     // ========== EVENTS ==========
3117 
3118     event PreferredCurrencyChanged(address indexed account, bytes4 newPreferredCurrency);
3119     bytes32 constant PREFERREDCURRENCYCHANGED_SIG = keccak256("PreferredCurrencyChanged(address,bytes4)");
3120     function emitPreferredCurrencyChanged(address account, bytes4 newPreferredCurrency) internal {
3121         proxy._emit(abi.encode(newPreferredCurrency), 2, PREFERREDCURRENCYCHANGED_SIG, bytes32(account), 0, 0);
3122     }
3123 
3124     event StateContractChanged(address stateContract);
3125     bytes32 constant STATECONTRACTCHANGED_SIG = keccak256("StateContractChanged(address)");
3126     function emitStateContractChanged(address stateContract) internal {
3127         proxy._emit(abi.encode(stateContract), 1, STATECONTRACTCHANGED_SIG, 0, 0, 0);
3128     }
3129 
3130     event SynthAdded(bytes4 currencyKey, address newSynth);
3131     bytes32 constant SYNTHADDED_SIG = keccak256("SynthAdded(bytes4,address)");
3132     function emitSynthAdded(bytes4 currencyKey, address newSynth) internal {
3133         proxy._emit(abi.encode(currencyKey, newSynth), 1, SYNTHADDED_SIG, 0, 0, 0);
3134     }
3135 
3136     event SynthRemoved(bytes4 currencyKey, address removedSynth);
3137     bytes32 constant SYNTHREMOVED_SIG = keccak256("SynthRemoved(bytes4,address)");
3138     function emitSynthRemoved(bytes4 currencyKey, address removedSynth) internal {
3139         proxy._emit(abi.encode(currencyKey, removedSynth), 1, SYNTHREMOVED_SIG, 0, 0, 0);
3140     }
3141 }
3142 
3143 
3144 /*
3145 -----------------------------------------------------------------
3146 FILE INFORMATION
3147 -----------------------------------------------------------------
3148 
3149 file:       FeePool.sol
3150 version:    1.0
3151 author:     Kevin Brown
3152 date:       2018-10-15
3153 
3154 -----------------------------------------------------------------
3155 MODULE DESCRIPTION
3156 -----------------------------------------------------------------
3157 
3158 The FeePool is a place for users to interact with the fees that
3159 have been generated from the Synthetix system if they've helped
3160 to create the economy.
3161 
3162 Users stake Synthetix to create Synths. As Synth users transact,
3163 a small fee is deducted from each transaction, which collects
3164 in the fee pool. Fees are immediately converted to XDRs, a type
3165 of reserve currency similar to SDRs used by the IMF:
3166 https://www.imf.org/en/About/Factsheets/Sheets/2016/08/01/14/51/Special-Drawing-Right-SDR
3167 
3168 Users are entitled to withdraw fees from periods that they participated
3169 in fully, e.g. they have to stake before the period starts. They
3170 can withdraw fees for the last 6 periods as a single lump sum.
3171 Currently fee periods are 7 days long, meaning it's assumed
3172 users will withdraw their fees approximately once a month. Fees
3173 which are not withdrawn are redistributed to the whole pool,
3174 enabling these non-claimed fees to go back to the rest of the commmunity.
3175 
3176 Fees can be withdrawn in any synth currency.
3177 
3178 -----------------------------------------------------------------
3179 */
3180 
3181 
3182 contract FeePool is Proxyable, SelfDestructible {
3183 
3184     using SafeMath for uint;
3185     using SafeDecimalMath for uint;
3186 
3187     Synthetix public synthetix;
3188 
3189     // A percentage fee charged on each transfer.
3190     uint public transferFeeRate;
3191 
3192     // Transfer fee may not exceed 10%.
3193     uint constant public MAX_TRANSFER_FEE_RATE = SafeDecimalMath.unit() / 10;
3194 
3195     // A percentage fee charged on each exchange between currencies.
3196     uint public exchangeFeeRate;
3197 
3198     // Exchange fee may not exceed 10%.
3199     uint constant public MAX_EXCHANGE_FEE_RATE = SafeDecimalMath.unit() / 10;
3200 
3201     // The address with the authority to distribute fees.
3202     address public feeAuthority;
3203 
3204     // Where fees are pooled in XDRs.
3205     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
3206 
3207     // This struct represents the issuance activity that's happened in a fee period.
3208     struct FeePeriod {
3209         uint feePeriodId;
3210         uint startingDebtIndex;
3211         uint startTime;
3212         uint feesToDistribute;
3213         uint feesClaimed;
3214     }
3215 
3216     // The last 6 fee periods are all that you can claim from.
3217     // These are stored and managed from [0], such that [0] is always
3218     // the most recent fee period, and [5] is always the oldest fee
3219     // period that users can claim for.
3220     uint8 constant public FEE_PERIOD_LENGTH = 6;
3221     FeePeriod[FEE_PERIOD_LENGTH] public recentFeePeriods;
3222 
3223     // The next fee period will have this ID.
3224     uint public nextFeePeriodId;
3225 
3226     // How long a fee period lasts at a minimum. It is required for the
3227     // fee authority to roll over the periods, so they are not guaranteed
3228     // to roll over at exactly this duration, but the contract enforces
3229     // that they cannot roll over any quicker than this duration.
3230     uint public feePeriodDuration = 1 weeks;
3231 
3232     // The fee period must be between 1 day and 60 days.
3233     uint public constant MIN_FEE_PERIOD_DURATION = 1 days;
3234     uint public constant MAX_FEE_PERIOD_DURATION = 60 days;
3235 
3236     // The last period a user has withdrawn their fees in, identified by the feePeriodId
3237     mapping(address => uint) public lastFeeWithdrawal;
3238 
3239     // Users receive penalties if their collateralisation ratio drifts out of our desired brackets
3240     // We precompute the brackets and penalties to save gas.
3241     uint constant TWENTY_PERCENT = (20 * SafeDecimalMath.unit()) / 100;
3242     uint constant TWENTY_FIVE_PERCENT = (25 * SafeDecimalMath.unit()) / 100;
3243     uint constant THIRTY_PERCENT = (30 * SafeDecimalMath.unit()) / 100;
3244     uint constant FOURTY_PERCENT = (40 * SafeDecimalMath.unit()) / 100;
3245     uint constant FIFTY_PERCENT = (50 * SafeDecimalMath.unit()) / 100;
3246     uint constant SEVENTY_FIVE_PERCENT = (75 * SafeDecimalMath.unit()) / 100;
3247 
3248     constructor(address _proxy, address _owner, Synthetix _synthetix, address _feeAuthority, uint _transferFeeRate, uint _exchangeFeeRate)
3249         SelfDestructible(_owner)
3250         Proxyable(_proxy, _owner)
3251         public
3252     {
3253         // Constructed fee rates should respect the maximum fee rates.
3254         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
3255         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Constructed exchange fee rate should respect the maximum fee rate");
3256 
3257         synthetix = _synthetix;
3258         feeAuthority = _feeAuthority;
3259         transferFeeRate = _transferFeeRate;
3260         exchangeFeeRate = _exchangeFeeRate;
3261 
3262         // Set our initial fee period
3263         recentFeePeriods[0].feePeriodId = 1;
3264         recentFeePeriods[0].startTime = now;
3265         // Gas optimisation: These do not need to be initialised. They start at 0.
3266         // recentFeePeriods[0].startingDebtIndex = 0;
3267         // recentFeePeriods[0].feesToDistribute = 0;
3268 
3269         // And the next one starts at 2.
3270         nextFeePeriodId = 2;
3271     }
3272 
3273     /**
3274      * @notice Set the exchange fee, anywhere within the range 0-10%.
3275      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
3276      */
3277     function setExchangeFeeRate(uint _exchangeFeeRate)
3278         external
3279         optionalProxy_onlyOwner
3280     {
3281         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Exchange fee rate must be below MAX_EXCHANGE_FEE_RATE");
3282 
3283         exchangeFeeRate = _exchangeFeeRate;
3284 
3285         emitExchangeFeeUpdated(_exchangeFeeRate);
3286     }
3287 
3288     /**
3289      * @notice Set the transfer fee, anywhere within the range 0-10%.
3290      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
3291      */
3292     function setTransferFeeRate(uint _transferFeeRate)
3293         external
3294         optionalProxy_onlyOwner
3295     {
3296         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
3297 
3298         transferFeeRate = _transferFeeRate;
3299 
3300         emitTransferFeeUpdated(_transferFeeRate);
3301     }
3302 
3303     /**
3304      * @notice Set the address of the user/contract responsible for collecting or
3305      * distributing fees.
3306      */
3307     function setFeeAuthority(address _feeAuthority)
3308         external
3309         optionalProxy_onlyOwner
3310     {
3311         feeAuthority = _feeAuthority;
3312 
3313         emitFeeAuthorityUpdated(_feeAuthority);
3314     }
3315 
3316     /**
3317      * @notice Set the fee period duration
3318      */
3319     function setFeePeriodDuration(uint _feePeriodDuration)
3320         external
3321         optionalProxy_onlyOwner
3322     {
3323         require(_feePeriodDuration >= MIN_FEE_PERIOD_DURATION, "New fee period cannot be less than minimum fee period duration");
3324         require(_feePeriodDuration <= MAX_FEE_PERIOD_DURATION, "New fee period cannot be greater than maximum fee period duration");
3325 
3326         feePeriodDuration = _feePeriodDuration;
3327 
3328         emitFeePeriodDurationUpdated(_feePeriodDuration);
3329     }
3330 
3331     /**
3332      * @notice Set the synthetix contract
3333      */
3334     function setSynthetix(Synthetix _synthetix)
3335         external
3336         optionalProxy_onlyOwner
3337     {
3338         require(address(_synthetix) != address(0), "New Synthetix must be non-zero");
3339 
3340         synthetix = _synthetix;
3341 
3342         emitSynthetixUpdated(_synthetix);
3343     }
3344 
3345     /**
3346      * @notice The Synthetix contract informs us when fees are paid.
3347      */
3348     function feePaid(bytes4 currencyKey, uint amount)
3349         external
3350         onlySynthetix
3351     {
3352         uint xdrAmount = synthetix.effectiveValue(currencyKey, amount, "XDR");
3353 
3354         // Which we keep track of in XDRs in our fee pool.
3355         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.add(xdrAmount);
3356     }
3357 
3358     /**
3359      * @notice Close the current fee period and start a new one. Only callable by the fee authority.
3360      */
3361     function closeCurrentFeePeriod()
3362         external
3363         onlyFeeAuthority
3364     {
3365         require(recentFeePeriods[0].startTime <= (now - feePeriodDuration), "It is too early to close the current fee period");
3366 
3367         FeePeriod memory secondLastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 2];
3368         FeePeriod memory lastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 1];
3369 
3370         // Any unclaimed fees from the last period in the array roll back one period.
3371         // Because of the subtraction here, they're effectively proportionally redistributed to those who
3372         // have already claimed from the old period, available in the new period.
3373         // The subtraction is important so we don't create a ticking time bomb of an ever growing
3374         // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
3375         recentFeePeriods[FEE_PERIOD_LENGTH - 2].feesToDistribute = lastFeePeriod.feesToDistribute
3376             .sub(lastFeePeriod.feesClaimed)
3377             .add(secondLastFeePeriod.feesToDistribute);
3378 
3379         // Shift the previous fee periods across to make room for the new one.
3380         // Condition checks for overflow when uint subtracts one from zero
3381         // Could be written with int instead of uint, but then we have to convert everywhere
3382         // so it felt better from a gas perspective to just change the condition to check
3383         // for overflow after subtracting one from zero.
3384         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
3385             uint next = i + 1;
3386 
3387             recentFeePeriods[next].feePeriodId = recentFeePeriods[i].feePeriodId;
3388             recentFeePeriods[next].startingDebtIndex = recentFeePeriods[i].startingDebtIndex;
3389             recentFeePeriods[next].startTime = recentFeePeriods[i].startTime;
3390             recentFeePeriods[next].feesToDistribute = recentFeePeriods[i].feesToDistribute;
3391             recentFeePeriods[next].feesClaimed = recentFeePeriods[i].feesClaimed;
3392         }
3393 
3394         // Clear the first element of the array to make sure we don't have any stale values.
3395         delete recentFeePeriods[0];
3396 
3397         // Open up the new fee period
3398         recentFeePeriods[0].feePeriodId = nextFeePeriodId;
3399         recentFeePeriods[0].startingDebtIndex = synthetix.synthetixState().debtLedgerLength();
3400         recentFeePeriods[0].startTime = now;
3401 
3402         nextFeePeriodId = nextFeePeriodId.add(1);
3403 
3404         emitFeePeriodClosed(recentFeePeriods[1].feePeriodId);
3405     }
3406 
3407     /**
3408     * @notice Claim fees for last period when available or not already withdrawn.
3409     * @param currencyKey Synth currency you wish to receive the fees in.
3410     */
3411     function claimFees(bytes4 currencyKey)
3412         external
3413         optionalProxy
3414         returns (bool)
3415     {
3416         uint availableFees = feesAvailable(messageSender, "XDR");
3417 
3418         require(availableFees > 0, "No fees available for period, or fees already claimed");
3419 
3420         lastFeeWithdrawal[messageSender] = recentFeePeriods[1].feePeriodId;
3421 
3422         // Record the fee payment in our recentFeePeriods
3423         _recordFeePayment(availableFees);
3424 
3425         // Send them their fees
3426         _payFees(messageSender, availableFees, currencyKey);
3427 
3428         emitFeesClaimed(messageSender, availableFees);
3429 
3430         return true;
3431     }
3432 
3433     /**
3434      * @notice Record the fee payment in our recentFeePeriods.
3435      * @param xdrAmount The amout of fees priced in XDRs.
3436      */
3437     function _recordFeePayment(uint xdrAmount)
3438         internal
3439     {
3440         // Don't assign to the parameter
3441         uint remainingToAllocate = xdrAmount;
3442 
3443         // Start at the oldest period and record the amount, moving to newer periods
3444         // until we've exhausted the amount.
3445         // The condition checks for overflow because we're going to 0 with an unsigned int.
3446         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
3447             uint delta = recentFeePeriods[i].feesToDistribute.sub(recentFeePeriods[i].feesClaimed);
3448 
3449             if (delta > 0) {
3450                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
3451                 uint amountInPeriod = delta < remainingToAllocate ? delta : remainingToAllocate;
3452 
3453                 recentFeePeriods[i].feesClaimed = recentFeePeriods[i].feesClaimed.add(amountInPeriod);
3454                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
3455 
3456                 // No need to continue iterating if we've recorded the whole amount;
3457                 if (remainingToAllocate == 0) return;
3458             }
3459         }
3460 
3461         // If we hit this line, we've exhausted our fee periods, but still have more to allocate. Wat?
3462         // If this happens it's a definite bug in the code, so assert instead of require.
3463         assert(remainingToAllocate == 0);
3464     }
3465 
3466     /**
3467     * @notice Send the fees to claiming address.
3468     * @param account The address to send the fees to.
3469     * @param xdrAmount The amount of fees priced in XDRs.
3470     * @param destinationCurrencyKey The synth currency the user wishes to receive their fees in (convert to this currency).
3471     */
3472     function _payFees(address account, uint xdrAmount, bytes4 destinationCurrencyKey)
3473         internal
3474         notFeeAddress(account)
3475     {
3476         require(account != address(0), "Account can't be 0");
3477         require(account != address(this), "Can't send fees to fee pool");
3478         require(account != address(proxy), "Can't send fees to proxy");
3479         require(account != address(synthetix), "Can't send fees to synthetix");
3480 
3481         Synth xdrSynth = synthetix.synths("XDR");
3482         Synth destinationSynth = synthetix.synths(destinationCurrencyKey);
3483 
3484         // Note: We don't need to check the fee pool balance as the burn() below will do a safe subtraction which requires
3485         // the subtraction to not overflow, which would happen if the balance is not sufficient.
3486 
3487         // Burn the source amount
3488         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
3489 
3490         // How much should they get in the destination currency?
3491         uint destinationAmount = synthetix.effectiveValue("XDR", xdrAmount, destinationCurrencyKey);
3492 
3493         // There's no fee on withdrawing fees, as that'd be way too meta.
3494 
3495         // Mint their new synths
3496         destinationSynth.issue(account, destinationAmount);
3497 
3498         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3499 
3500         // Call the ERC223 transfer callback if needed
3501         destinationSynth.triggerTokenFallbackIfNeeded(FEE_ADDRESS, account, destinationAmount);
3502     }
3503 
3504     /**
3505      * @notice Calculate the Fee charged on top of a value being sent
3506      * @return Return the fee charged
3507      */
3508     function transferFeeIncurred(uint value)
3509         public
3510         view
3511         returns (uint)
3512     {
3513         return value.multiplyDecimal(transferFeeRate);
3514 
3515         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
3516         // This is on the basis that transfers less than this value will result in a nil fee.
3517         // Probably too insignificant to worry about, but the following code will achieve it.
3518         //      if (fee == 0 && transferFeeRate != 0) {
3519         //          return _value;
3520         //      }
3521         //      return fee;
3522     }
3523 
3524     /**
3525      * @notice The value that you would need to send so that the recipient receives
3526      * a specified value.
3527      * @param value The value you want the recipient to receive
3528      */
3529     function transferredAmountToReceive(uint value)
3530         external
3531         view
3532         returns (uint)
3533     {
3534         return value.add(transferFeeIncurred(value));
3535     }
3536 
3537     /**
3538      * @notice The amount the recipient will receive if you send a certain number of tokens.
3539      * @param value The amount of tokens you intend to send.
3540      */
3541     function amountReceivedFromTransfer(uint value)
3542         external
3543         view
3544         returns (uint)
3545     {
3546         return value.divideDecimal(transferFeeRate.add(SafeDecimalMath.unit()));
3547     }
3548 
3549     /**
3550      * @notice Calculate the fee charged on top of a value being sent via an exchange
3551      * @return Return the fee charged
3552      */
3553     function exchangeFeeIncurred(uint value)
3554         public
3555         view
3556         returns (uint)
3557     {
3558         return value.multiplyDecimal(exchangeFeeRate);
3559 
3560         // Exchanges less than the reciprocal of exchangeFeeRate should be completely eaten up by fees.
3561         // This is on the basis that exchanges less than this value will result in a nil fee.
3562         // Probably too insignificant to worry about, but the following code will achieve it.
3563         //      if (fee == 0 && exchangeFeeRate != 0) {
3564         //          return _value;
3565         //      }
3566         //      return fee;
3567     }
3568 
3569     /**
3570      * @notice The value that you would need to get after currency exchange so that the recipient receives
3571      * a specified value.
3572      * @param value The value you want the recipient to receive
3573      */
3574     function exchangedAmountToReceive(uint value)
3575         external
3576         view
3577         returns (uint)
3578     {
3579         return value.add(exchangeFeeIncurred(value));
3580     }
3581 
3582     /**
3583      * @notice The amount the recipient will receive if you are performing an exchange and the
3584      * destination currency will be worth a certain number of tokens.
3585      * @param value The amount of destination currency tokens they received after the exchange.
3586      */
3587     function amountReceivedFromExchange(uint value)
3588         external
3589         view
3590         returns (uint)
3591     {
3592         return value.divideDecimal(exchangeFeeRate.add(SafeDecimalMath.unit()));
3593     }
3594 
3595     /**
3596      * @notice The total fees available in the system to be withdrawn, priced in currencyKey currency
3597      * @param currencyKey The currency you want to price the fees in
3598      */
3599     function totalFeesAvailable(bytes4 currencyKey)
3600         external
3601         view
3602         returns (uint)
3603     {
3604         uint totalFees = 0;
3605 
3606         // Fees in fee period [0] are not yet available for withdrawal
3607         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
3608             totalFees = totalFees.add(recentFeePeriods[i].feesToDistribute);
3609             totalFees = totalFees.sub(recentFeePeriods[i].feesClaimed);
3610         }
3611 
3612         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
3613     }
3614 
3615     /**
3616      * @notice The fees available to be withdrawn by a specific account, priced in currencyKey currency
3617      * @param currencyKey The currency you want to price the fees in
3618      */
3619     function feesAvailable(address account, bytes4 currencyKey)
3620         public
3621         view
3622         returns (uint)
3623     {
3624         // Add up the fees
3625         uint[FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);
3626 
3627         uint totalFees = 0;
3628 
3629         // Fees in fee period [0] are not yet available for withdrawal
3630         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
3631             totalFees = totalFees.add(userFees[i]);
3632         }
3633 
3634         // And convert them to their desired currency
3635         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
3636     }
3637 
3638     /**
3639      * @notice The penalty a particular address would incur if its fees were withdrawn right now
3640      * @param account The address you want to query the penalty for
3641      */
3642     function currentPenalty(address account)
3643         public
3644         view
3645         returns (uint)
3646     {
3647         uint ratio = synthetix.collateralisationRatio(account);
3648 
3649         // Users receive a different amount of fees depending on how their collateralisation ratio looks right now.
3650         // 0% - 20%: Fee is calculated based on percentage of economy issued.
3651         // 20% - 30%: 25% reduction in fees
3652         // 30% - 40%: 50% reduction in fees
3653         // >40%: 75% reduction in fees
3654         if (ratio <= TWENTY_PERCENT) {
3655             return 0;
3656         } else if (ratio > TWENTY_PERCENT && ratio <= THIRTY_PERCENT) {
3657             return TWENTY_FIVE_PERCENT;
3658         } else if (ratio > THIRTY_PERCENT && ratio <= FOURTY_PERCENT) {
3659             return FIFTY_PERCENT;
3660         }
3661 
3662         return SEVENTY_FIVE_PERCENT;
3663     }
3664 
3665     /**
3666      * @notice Calculates fees by period for an account, priced in XDRs
3667      * @param account The address you want to query the fees by penalty for
3668      */
3669     function feesByPeriod(address account)
3670         public
3671         view
3672         returns (uint[FEE_PERIOD_LENGTH])
3673     {
3674         uint[FEE_PERIOD_LENGTH] memory result;
3675 
3676         // What's the user's debt entry index and the debt they owe to the system
3677         uint initialDebtOwnership;
3678         uint debtEntryIndex;
3679         (initialDebtOwnership, debtEntryIndex) = synthetix.synthetixState().issuanceData(account);
3680 
3681         // If they don't have any debt ownership, they don't have any fees
3682         if (initialDebtOwnership == 0) return result;
3683 
3684         // If there are no XDR synths, then they don't have any fees
3685         uint totalSynths = synthetix.totalIssuedSynths("XDR");
3686         if (totalSynths == 0) return result;
3687 
3688         uint debtBalance = synthetix.debtBalanceOf(account, "XDR");
3689         uint userOwnershipPercentage = debtBalance.divideDecimal(totalSynths);
3690         uint penalty = currentPenalty(account);
3691         
3692         // Go through our fee periods and figure out what we owe them.
3693         // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
3694         // fees owing for, so we need to report on it anyway.
3695         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
3696             // Were they a part of this period in its entirety?
3697             // We don't allow pro-rata participation to reduce the ability to game the system by
3698             // issuing and burning multiple times in a period or close to the ends of periods.
3699             if (recentFeePeriods[i].startingDebtIndex > debtEntryIndex &&
3700                 lastFeeWithdrawal[account] < recentFeePeriods[i].feePeriodId) {
3701 
3702                 // And since they were, they're entitled to their percentage of the fees in this period
3703                 uint feesFromPeriodWithoutPenalty = recentFeePeriods[i].feesToDistribute
3704                     .multiplyDecimal(userOwnershipPercentage);
3705 
3706                 // Less their penalty if they have one.
3707                 uint penaltyFromPeriod = feesFromPeriodWithoutPenalty.multiplyDecimal(penalty);
3708                 uint feesFromPeriod = feesFromPeriodWithoutPenalty.sub(penaltyFromPeriod);
3709 
3710                 result[i] = feesFromPeriod;
3711             }
3712         }
3713 
3714         return result;
3715     }
3716 
3717     modifier onlyFeeAuthority
3718     {
3719         require(msg.sender == feeAuthority, "Only the fee authority can perform this action");
3720         _;
3721     }
3722 
3723     modifier onlySynthetix
3724     {
3725         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
3726         _;
3727     }
3728 
3729     modifier notFeeAddress(address account) {
3730         require(account != FEE_ADDRESS, "Fee address not allowed");
3731         _;
3732     }
3733 
3734     event TransferFeeUpdated(uint newFeeRate);
3735     bytes32 constant TRANSFERFEEUPDATED_SIG = keccak256("TransferFeeUpdated(uint256)");
3736     function emitTransferFeeUpdated(uint newFeeRate) internal {
3737         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEEUPDATED_SIG, 0, 0, 0);
3738     }
3739 
3740     event ExchangeFeeUpdated(uint newFeeRate);
3741     bytes32 constant EXCHANGEFEEUPDATED_SIG = keccak256("ExchangeFeeUpdated(uint256)");
3742     function emitExchangeFeeUpdated(uint newFeeRate) internal {
3743         proxy._emit(abi.encode(newFeeRate), 1, EXCHANGEFEEUPDATED_SIG, 0, 0, 0);
3744     }
3745 
3746     event FeePeriodDurationUpdated(uint newFeePeriodDuration);
3747     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
3748     function emitFeePeriodDurationUpdated(uint newFeePeriodDuration) internal {
3749         proxy._emit(abi.encode(newFeePeriodDuration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
3750     }
3751 
3752     event FeeAuthorityUpdated(address newFeeAuthority);
3753     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
3754     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
3755         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
3756     }
3757 
3758     event FeePeriodClosed(uint feePeriodId);
3759     bytes32 constant FEEPERIODCLOSED_SIG = keccak256("FeePeriodClosed(uint256)");
3760     function emitFeePeriodClosed(uint feePeriodId) internal {
3761         proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
3762     }
3763 
3764     event FeesClaimed(address account, uint xdrAmount);
3765     bytes32 constant FEESCLAIMED_SIG = keccak256("FeesClaimed(address,uint256)");
3766     function emitFeesClaimed(address account, uint xdrAmount) internal {
3767         proxy._emit(abi.encode(account, xdrAmount), 1, FEESCLAIMED_SIG, 0, 0, 0);
3768     }
3769 
3770     event SynthetixUpdated(address newSynthetix);
3771     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
3772     function emitSynthetixUpdated(address newSynthetix) internal {
3773         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
3774     }
3775 }
3776 
3777 
3778 /*
3779 -----------------------------------------------------------------
3780 FILE INFORMATION
3781 -----------------------------------------------------------------
3782 
3783 file:       Synth.sol
3784 version:    2.0
3785 author:     Kevin Brown
3786 date:       2018-09-13
3787 
3788 -----------------------------------------------------------------
3789 MODULE DESCRIPTION
3790 -----------------------------------------------------------------
3791 
3792 Synthetix-backed stablecoin contract.
3793 
3794 This contract issues synths, which are tokens that mirror various
3795 flavours of fiat currency.
3796 
3797 Synths are issuable by Synthetix Network Token (SNX) holders who 
3798 have to lock up some value of their SNX to issue S * Cmax synths. 
3799 Where Cmax issome value less than 1.
3800 
3801 A configurable fee is charged on synth transfers and deposited
3802 into a common pot, which Synthetix holders may withdraw from once
3803 per fee period.
3804 
3805 -----------------------------------------------------------------
3806 */
3807 
3808 
3809 contract Synth is ExternStateToken {
3810 
3811     /* ========== STATE VARIABLES ========== */
3812 
3813     FeePool public feePool;
3814     Synthetix public synthetix;
3815 
3816     // Currency key which identifies this Synth to the Synthetix system
3817     bytes4 public currencyKey;
3818 
3819     uint8 constant DECIMALS = 18;
3820 
3821     /* ========== CONSTRUCTOR ========== */
3822 
3823     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, FeePool _feePool,
3824         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey
3825     )
3826         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, 0, DECIMALS, _owner)
3827         public
3828     {
3829         require(_proxy != 0, "_proxy cannot be 0");
3830         require(address(_synthetix) != 0, "_synthetix cannot be 0");
3831         require(address(_feePool) != 0, "_feePool cannot be 0");
3832         require(_owner != 0, "_owner cannot be 0");
3833         require(_synthetix.synths(_currencyKey) == Synth(0), "Currency key is already in use");
3834 
3835         feePool = _feePool;
3836         synthetix = _synthetix;
3837         currencyKey = _currencyKey;
3838     }
3839 
3840     /* ========== SETTERS ========== */
3841 
3842     function setSynthetix(Synthetix _synthetix)
3843         external
3844         optionalProxy_onlyOwner
3845     {
3846         synthetix = _synthetix;
3847         emitSynthetixUpdated(_synthetix);
3848     }
3849 
3850     function setFeePool(FeePool _feePool)
3851         external
3852         optionalProxy_onlyOwner
3853     {
3854         feePool = _feePool;
3855         emitFeePoolUpdated(_feePool);
3856     }
3857 
3858     /* ========== MUTATIVE FUNCTIONS ========== */
3859 
3860     /**
3861      * @notice Override ERC20 transfer function in order to 
3862      * subtract the transaction fee and send it to the fee pool
3863      * for SNX holders to claim. */
3864     function transfer(address to, uint value)
3865         public
3866         optionalProxy
3867         notFeeAddress(messageSender)
3868         returns (bool)
3869     {
3870         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3871         uint fee = value.sub(amountReceived);
3872 
3873         // Send the fee off to the fee pool.
3874         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3875 
3876         // And send their result off to the destination address
3877         bytes memory empty;
3878         return _internalTransfer(messageSender, to, amountReceived, empty);
3879     }
3880 
3881     /**
3882      * @notice Override ERC223 transfer function in order to 
3883      * subtract the transaction fee and send it to the fee pool
3884      * for SNX holders to claim. */
3885     function transfer(address to, uint value, bytes data)
3886         public
3887         optionalProxy
3888         notFeeAddress(messageSender)
3889         returns (bool)
3890     {
3891         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3892         uint fee = value.sub(amountReceived);
3893 
3894         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3895         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3896 
3897         // And send their result off to the destination address
3898         return _internalTransfer(messageSender, to, amountReceived, data);
3899     }
3900 
3901     /**
3902      * @notice Override ERC20 transferFrom function in order to 
3903      * subtract the transaction fee and send it to the fee pool
3904      * for SNX holders to claim. */
3905     function transferFrom(address from, address to, uint value)
3906         public
3907         optionalProxy
3908         notFeeAddress(from)
3909         returns (bool)
3910     {
3911         // The fee is deducted from the amount sent.
3912         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3913         uint fee = value.sub(amountReceived);
3914 
3915         // Reduce the allowance by the amount we're transferring.
3916         // The safeSub call will handle an insufficient allowance.
3917         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
3918 
3919         // Send the fee off to the fee pool.
3920         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
3921 
3922         bytes memory empty;
3923         return _internalTransfer(from, to, amountReceived, empty);
3924     }
3925 
3926     /**
3927      * @notice Override ERC223 transferFrom function in order to 
3928      * subtract the transaction fee and send it to the fee pool
3929      * for SNX holders to claim. */
3930     function transferFrom(address from, address to, uint value, bytes data)
3931         public
3932         optionalProxy
3933         notFeeAddress(from)
3934         returns (bool)
3935     {
3936         // The fee is deducted from the amount sent.
3937         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3938         uint fee = value.sub(amountReceived);
3939 
3940         // Reduce the allowance by the amount we're transferring.
3941         // The safeSub call will handle an insufficient allowance.
3942         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
3943 
3944         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3945         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
3946 
3947         return _internalTransfer(from, to, amountReceived, data);
3948     }
3949 
3950     /* Subtract the transfer fee from the senders account so the 
3951      * receiver gets the exact amount specified to send. */
3952     function transferSenderPaysFee(address to, uint value)
3953         public
3954         optionalProxy
3955         notFeeAddress(messageSender)
3956         returns (bool)
3957     {
3958         uint fee = feePool.transferFeeIncurred(value);
3959 
3960         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3961         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3962 
3963         // And send their transfer amount off to the destination address
3964         bytes memory empty;
3965         return _internalTransfer(messageSender, to, value, empty);
3966     }
3967 
3968     /* Subtract the transfer fee from the senders account so the 
3969      * receiver gets the exact amount specified to send. */
3970     function transferSenderPaysFee(address to, uint value, bytes data)
3971         public
3972         optionalProxy
3973         notFeeAddress(messageSender)
3974         returns (bool)
3975     {
3976         uint fee = feePool.transferFeeIncurred(value);
3977 
3978         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3979         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3980 
3981         // And send their transfer amount off to the destination address
3982         return _internalTransfer(messageSender, to, value, data);
3983     }
3984 
3985     /* Subtract the transfer fee from the senders account so the 
3986      * to address receives the exact amount specified to send. */
3987     function transferFromSenderPaysFee(address from, address to, uint value)
3988         public
3989         optionalProxy
3990         notFeeAddress(from)
3991         returns (bool)
3992     {
3993         uint fee = feePool.transferFeeIncurred(value);
3994 
3995         // Reduce the allowance by the amount we're transferring.
3996         // The safeSub call will handle an insufficient allowance.
3997         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
3998 
3999         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
4000         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
4001 
4002         bytes memory empty;
4003         return _internalTransfer(from, to, value, empty);
4004     }
4005 
4006     /* Subtract the transfer fee from the senders account so the 
4007      * to address receives the exact amount specified to send. */
4008     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
4009         public
4010         optionalProxy
4011         notFeeAddress(from)
4012         returns (bool)
4013     {
4014         uint fee = feePool.transferFeeIncurred(value);
4015 
4016         // Reduce the allowance by the amount we're transferring.
4017         // The safeSub call will handle an insufficient allowance.
4018         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
4019 
4020         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
4021         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
4022 
4023         return _internalTransfer(from, to, value, data);
4024     }
4025 
4026     // Override our internal transfer to inject preferred currency support
4027     function _internalTransfer(address from, address to, uint value, bytes data)
4028         internal
4029         returns (bool)
4030     {
4031         bytes4 preferredCurrencyKey = synthetix.synthetixState().preferredCurrency(to);
4032 
4033         // Do they have a preferred currency that's not us? If so we need to exchange
4034         if (preferredCurrencyKey != 0 && preferredCurrencyKey != currencyKey) {
4035             return synthetix.synthInitiatedExchange(from, currencyKey, value, preferredCurrencyKey, to);
4036         } else {
4037             // Otherwise we just transfer
4038             return super._internalTransfer(from, to, value, data);
4039         }
4040     }
4041 
4042     // Allow synthetix to issue a certain number of synths from an account.
4043     function issue(address account, uint amount)
4044         external
4045         onlySynthetixOrFeePool
4046     {
4047         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
4048         totalSupply = totalSupply.add(amount);
4049         emitTransfer(address(0), account, amount);
4050         emitIssued(account, amount);
4051     }
4052 
4053     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
4054     function burn(address account, uint amount)
4055         external
4056         onlySynthetixOrFeePool
4057     {
4058         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
4059         totalSupply = totalSupply.sub(amount);
4060         emitTransfer(account, address(0), amount);
4061         emitBurned(account, amount);
4062     }
4063 
4064     // Allow owner to set the total supply on import.
4065     function setTotalSupply(uint amount)
4066         external
4067         optionalProxy_onlyOwner
4068     {
4069         totalSupply = amount;
4070     }
4071 
4072     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
4073     // exchange as well as transfer
4074     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
4075         external
4076         onlySynthetixOrFeePool
4077     {
4078         bytes memory empty;
4079         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
4080     }
4081 
4082     /* ========== MODIFIERS ========== */
4083 
4084     modifier onlySynthetixOrFeePool() {
4085         bool isSynthetix = msg.sender == address(synthetix);
4086         bool isFeePool = msg.sender == address(feePool);
4087 
4088         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
4089         _;
4090     }
4091 
4092     modifier notFeeAddress(address account) {
4093         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
4094         _;
4095     }
4096 
4097     /* ========== EVENTS ========== */
4098 
4099     event SynthetixUpdated(address newSynthetix);
4100     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
4101     function emitSynthetixUpdated(address newSynthetix) internal {
4102         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
4103     }
4104 
4105     event FeePoolUpdated(address newFeePool);
4106     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
4107     function emitFeePoolUpdated(address newFeePool) internal {
4108         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
4109     }
4110 
4111     event Issued(address indexed account, uint value);
4112     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
4113     function emitIssued(address account, uint value) internal {
4114         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
4115     }
4116 
4117     event Burned(address indexed account, uint value);
4118     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
4119     function emitBurned(address account, uint value) internal {
4120         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
4121     }
4122 }
4123 
