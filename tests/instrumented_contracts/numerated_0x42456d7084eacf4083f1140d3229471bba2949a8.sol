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
1895 
1896 contract ExchangeRates is SelfDestructible {
1897 
1898 
1899     using SafeMath for uint;
1900 
1901     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
1902     mapping(bytes4 => uint) public rates;
1903 
1904     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
1905     mapping(bytes4 => uint) public lastRateUpdateTimes;
1906 
1907     // The address of the oracle which pushes rate updates to this contract
1908     address public oracle;
1909 
1910     // Do not allow the oracle to submit times any further forward into the future than this constant.
1911     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
1912 
1913     // How long will the contract assume the rate of any asset is correct
1914     uint public rateStalePeriod = 3 hours;
1915 
1916     // Each participating currency in the XDR basket is represented as a currency key with
1917     // equal weighting.
1918     // There are 5 participating currencies, so we'll declare that clearly.
1919     bytes4[5] public xdrParticipants;
1920 
1921     // For inverted prices, keep a mapping of their entry, limits and frozen status
1922     struct InversePricing {
1923         uint entryPoint;
1924         uint upperLimit;
1925         uint lowerLimit;
1926         bool frozen;
1927     }
1928     mapping(bytes4 => InversePricing) public inversePricing;
1929     bytes4[] public invertedKeys;
1930 
1931     //
1932     // ========== CONSTRUCTOR ==========
1933 
1934     /**
1935      * @dev Constructor
1936      * @param _owner The owner of this contract.
1937      * @param _oracle The address which is able to update rate information.
1938      * @param _currencyKeys The initial currency keys to store (in order).
1939      * @param _newRates The initial currency amounts for each currency (in order).
1940      */
1941     constructor(
1942         // SelfDestructible (Ownable)
1943         address _owner,
1944 
1945         // Oracle values - Allows for rate updates
1946         address _oracle,
1947         bytes4[] _currencyKeys,
1948         uint[] _newRates
1949     )
1950         /* Owned is initialised in SelfDestructible */
1951         SelfDestructible(_owner)
1952         public
1953     {
1954         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
1955 
1956         oracle = _oracle;
1957 
1958         // The sUSD rate is always 1 and is never stale.
1959         rates["sUSD"] = SafeDecimalMath.unit();
1960         lastRateUpdateTimes["sUSD"] = now;
1961 
1962         // These are the currencies that make up the XDR basket.
1963         // These are hard coded because:
1964         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
1965         //  - Adding new currencies would likely introduce some kind of weighting factor, which
1966         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
1967         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
1968         //    then point the system at the new version.
1969         xdrParticipants = [
1970             bytes4("sUSD"),
1971             bytes4("sAUD"),
1972             bytes4("sCHF"),
1973             bytes4("sEUR"),
1974             bytes4("sGBP")
1975         ];
1976 
1977         internalUpdateRates(_currencyKeys, _newRates, now);
1978     }
1979 
1980     /* ========== SETTERS ========== */
1981 
1982     /**
1983      * @notice Set the rates stored in this contract
1984      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1985      * @param newRates The rates for each currency (in order)
1986      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1987      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1988      *                 if it takes a long time for the transaction to confirm.
1989      */
1990     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
1991         external
1992         onlyOracle
1993         returns(bool)
1994     {
1995         return internalUpdateRates(currencyKeys, newRates, timeSent);
1996     }
1997 
1998     /**
1999      * @notice Internal function which sets the rates stored in this contract
2000      * @param currencyKeys The currency keys you wish to update the rates for (in order)
2001      * @param newRates The rates for each currency (in order)
2002      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
2003      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
2004      *                 if it takes a long time for the transaction to confirm.
2005      */
2006     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
2007         internal
2008         returns(bool)
2009     {
2010         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
2011         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
2012 
2013         // Loop through each key and perform update.
2014         for (uint i = 0; i < currencyKeys.length; i++) {
2015             // Should not set any rate to zero ever, as no asset will ever be
2016             // truely worthless and still valid. In this scenario, we should
2017             // delete the rate and remove it from the system.
2018             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
2019             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
2020 
2021             // We should only update the rate if it's at least the same age as the last rate we've got.
2022             if (timeSent < lastRateUpdateTimes[currencyKeys[i]]) {
2023                 continue;
2024             }
2025 
2026             newRates[i] = rateOrInverted(currencyKeys[i], newRates[i]);
2027 
2028             // Ok, go ahead with the update.
2029             rates[currencyKeys[i]] = newRates[i];
2030             lastRateUpdateTimes[currencyKeys[i]] = timeSent;
2031         }
2032 
2033         emit RatesUpdated(currencyKeys, newRates);
2034 
2035         // Now update our XDR rate.
2036         updateXDRRate(timeSent);
2037 
2038         return true;
2039     }
2040 
2041     /**
2042      * @notice Internal function to get the inverted rate, if any, and mark an inverted
2043      *  key as frozen if either limits are reached.
2044      * @param currencyKey The price key to lookup
2045      * @param rate The rate for the given price key
2046      */
2047     function rateOrInverted(bytes4 currencyKey, uint rate) internal returns (uint) {
2048         // if an inverse mapping exists, adjust the price accordingly
2049         InversePricing storage inverse = inversePricing[currencyKey];
2050         if (inverse.entryPoint <= 0) {
2051             return rate;
2052         }
2053 
2054         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
2055         uint newInverseRate = rates[currencyKey];
2056 
2057         // get the new inverted rate if not frozen
2058         if (!inverse.frozen) {
2059             uint doubleEntryPoint = inverse.entryPoint.mul(2);
2060             if (doubleEntryPoint <= rate) {
2061                 // avoid negative numbers for unsigned ints, so set this to 0
2062                 // which by the requirement that lowerLimit be > 0 will
2063                 // cause this to freeze the price to the lowerLimit
2064                 newInverseRate = 0;
2065             } else {
2066                 newInverseRate = doubleEntryPoint.sub(rate);
2067             }
2068 
2069             // now if new rate hits our limits, set it to the limit and freeze
2070             if (newInverseRate >= inverse.upperLimit) {
2071                 newInverseRate = inverse.upperLimit;
2072             } else if (newInverseRate <= inverse.lowerLimit) {
2073                 newInverseRate = inverse.lowerLimit;
2074             }
2075 
2076             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
2077                 inverse.frozen = true;
2078                 emit InversePriceFrozen(currencyKey);
2079             }
2080         }
2081 
2082         return newInverseRate;
2083     }
2084 
2085     /**
2086      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
2087      */
2088     function updateXDRRate(uint timeSent)
2089         internal
2090     {
2091         uint total = 0;
2092 
2093         for (uint i = 0; i < xdrParticipants.length; i++) {
2094             total = rates[xdrParticipants[i]].add(total);
2095         }
2096 
2097         // Set the rate
2098         rates["XDR"] = total;
2099 
2100         // Record that we updated the XDR rate.
2101         lastRateUpdateTimes["XDR"] = timeSent;
2102 
2103         // Emit our updated event separate to the others to save
2104         // moving data around between arrays.
2105         bytes4[] memory eventCurrencyCode = new bytes4[](1);
2106         eventCurrencyCode[0] = "XDR";
2107 
2108         uint[] memory eventRate = new uint[](1);
2109         eventRate[0] = rates["XDR"];
2110 
2111         emit RatesUpdated(eventCurrencyCode, eventRate);
2112     }
2113 
2114     /**
2115      * @notice Delete a rate stored in the contract
2116      * @param currencyKey The currency key you wish to delete the rate for
2117      */
2118     function deleteRate(bytes4 currencyKey)
2119         external
2120         onlyOracle
2121     {
2122         require(rates[currencyKey] > 0, "Rate is zero");
2123 
2124         delete rates[currencyKey];
2125         delete lastRateUpdateTimes[currencyKey];
2126 
2127         emit RateDeleted(currencyKey);
2128     }
2129 
2130     /**
2131      * @notice Set the Oracle that pushes the rate information to this contract
2132      * @param _oracle The new oracle address
2133      */
2134     function setOracle(address _oracle)
2135         external
2136         onlyOwner
2137     {
2138         oracle = _oracle;
2139         emit OracleUpdated(oracle);
2140     }
2141 
2142     /**
2143      * @notice Set the stale period on the updated rate variables
2144      * @param _time The new rateStalePeriod
2145      */
2146     function setRateStalePeriod(uint _time)
2147         external
2148         onlyOwner
2149     {
2150         rateStalePeriod = _time;
2151         emit RateStalePeriodUpdated(rateStalePeriod);
2152     }
2153 
2154     /**
2155      * @notice Set an inverse price up for the currency key
2156      * @param currencyKey The currency to update
2157      * @param entryPoint The entry price point of the inverted price
2158      * @param upperLimit The upper limit, at or above which the price will be frozen
2159      * @param lowerLimit The lower limit, at or below which the price will be frozen
2160      */
2161     function setInversePricing(bytes4 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit)
2162         external onlyOwner
2163     {
2164         require(entryPoint > 0, "entryPoint must be above 0");
2165         require(lowerLimit > 0, "lowerLimit must be above 0");
2166         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
2167         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
2168         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
2169 
2170         if (inversePricing[currencyKey].entryPoint <= 0) {
2171             // then we are adding a new inverse pricing, so add this
2172             invertedKeys.push(currencyKey);
2173         }
2174         inversePricing[currencyKey].entryPoint = entryPoint;
2175         inversePricing[currencyKey].upperLimit = upperLimit;
2176         inversePricing[currencyKey].lowerLimit = lowerLimit;
2177         inversePricing[currencyKey].frozen = false;
2178 
2179         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
2180     }
2181 
2182     /**
2183      * @notice Remove an inverse price for the currency key
2184      * @param currencyKey The currency to remove inverse pricing for
2185      */
2186     function removeInversePricing(bytes4 currencyKey) external onlyOwner {
2187         inversePricing[currencyKey].entryPoint = 0;
2188         inversePricing[currencyKey].upperLimit = 0;
2189         inversePricing[currencyKey].lowerLimit = 0;
2190         inversePricing[currencyKey].frozen = false;
2191 
2192         // now remove inverted key from array
2193         for (uint8 i = 0; i < invertedKeys.length; i++) {
2194             if (invertedKeys[i] == currencyKey) {
2195                 delete invertedKeys[i];
2196 
2197                 // Copy the last key into the place of the one we just deleted
2198                 // If there's only one key, this is array[0] = array[0].
2199                 // If we're deleting the last one, it's also a NOOP in the same way.
2200                 invertedKeys[i] = invertedKeys[invertedKeys.length - 1];
2201 
2202                 // Decrease the size of the array by one.
2203                 invertedKeys.length--;
2204 
2205                 break;
2206             }
2207         }
2208 
2209         emit InversePriceConfigured(currencyKey, 0, 0, 0);
2210     }
2211     /* ========== VIEWS ========== */
2212 
2213     /**
2214      * @notice Retrieve the rate for a specific currency
2215      */
2216     function rateForCurrency(bytes4 currencyKey)
2217         public
2218         view
2219         returns (uint)
2220     {
2221         return rates[currencyKey];
2222     }
2223 
2224     /**
2225      * @notice Retrieve the rates for a list of currencies
2226      */
2227     function ratesForCurrencies(bytes4[] currencyKeys)
2228         public
2229         view
2230         returns (uint[])
2231     {
2232         uint[] memory _rates = new uint[](currencyKeys.length);
2233 
2234         for (uint8 i = 0; i < currencyKeys.length; i++) {
2235             _rates[i] = rates[currencyKeys[i]];
2236         }
2237 
2238         return _rates;
2239     }
2240 
2241     /**
2242      * @notice Retrieve a list of last update times for specific currencies
2243      */
2244     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
2245         public
2246         view
2247         returns (uint)
2248     {
2249         return lastRateUpdateTimes[currencyKey];
2250     }
2251 
2252     /**
2253      * @notice Retrieve the last update time for a specific currency
2254      */
2255     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
2256         public
2257         view
2258         returns (uint[])
2259     {
2260         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
2261 
2262         for (uint8 i = 0; i < currencyKeys.length; i++) {
2263             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
2264         }
2265 
2266         return lastUpdateTimes;
2267     }
2268 
2269     /**
2270      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
2271      */
2272     function rateIsStale(bytes4 currencyKey)
2273         external
2274         view
2275         returns (bool)
2276     {
2277         // sUSD is a special case and is never stale.
2278         if (currencyKey == "sUSD") return false;
2279 
2280         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
2281     }
2282 
2283     /**
2284      * @notice Check if any rate is frozen (cannot be exchanged into)
2285      */
2286     function rateIsFrozen(bytes4 currencyKey)
2287         external
2288         view
2289         returns (bool)
2290     {
2291         return inversePricing[currencyKey].frozen;
2292     }
2293 
2294 
2295     /**
2296      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
2297      */
2298     function anyRateIsStale(bytes4[] currencyKeys)
2299         external
2300         view
2301         returns (bool)
2302     {
2303         // Loop through each key and check whether the data point is stale.
2304         uint256 i = 0;
2305 
2306         while (i < currencyKeys.length) {
2307             // sUSD is a special case and is never false
2308             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
2309                 return true;
2310             }
2311             i += 1;
2312         }
2313 
2314         return false;
2315     }
2316 
2317     /* ========== MODIFIERS ========== */
2318 
2319     modifier onlyOracle
2320     {
2321         require(msg.sender == oracle, "Only the oracle can perform this action");
2322         _;
2323     }
2324 
2325     /* ========== EVENTS ========== */
2326 
2327     event OracleUpdated(address newOracle);
2328     event RateStalePeriodUpdated(uint rateStalePeriod);
2329     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
2330     event RateDeleted(bytes4 currencyKey);
2331     event InversePriceConfigured(bytes4 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
2332     event InversePriceFrozen(bytes4 currencyKey);
2333 }
2334 
2335 
2336 /*
2337 -----------------------------------------------------------------
2338 FILE INFORMATION
2339 -----------------------------------------------------------------
2340 
2341 file:       Synthetix.sol
2342 version:    2.0
2343 author:     Kevin Brown
2344             Gavin Conway
2345 date:       2018-09-14
2346 
2347 -----------------------------------------------------------------
2348 MODULE DESCRIPTION
2349 -----------------------------------------------------------------
2350 
2351 Synthetix token contract. SNX is a transferable ERC20 token,
2352 and also give its holders the following privileges.
2353 An owner of SNX has the right to issue synths in all synth flavours.
2354 
2355 After a fee period terminates, the duration and fees collected for that
2356 period are computed, and the next period begins. Thus an account may only
2357 withdraw the fees owed to them for the previous period, and may only do
2358 so once per period. Any unclaimed fees roll over into the common pot for
2359 the next period.
2360 
2361 == Average Balance Calculations ==
2362 
2363 The fee entitlement of a synthetix holder is proportional to their average
2364 issued synth balance over the last fee period. This is computed by
2365 measuring the area under the graph of a user's issued synth balance over
2366 time, and then when a new fee period begins, dividing through by the
2367 duration of the fee period.
2368 
2369 We need only update values when the balances of an account is modified.
2370 This occurs when issuing or burning for issued synth balances,
2371 and when transferring for synthetix balances. This is for efficiency,
2372 and adds an implicit friction to interacting with SNX.
2373 A synthetix holder pays for his own recomputation whenever he wants to change
2374 his position, which saves the foundation having to maintain a pot dedicated
2375 to resourcing this.
2376 
2377 A hypothetical user's balance history over one fee period, pictorially:
2378 
2379       s ____
2380        |    |
2381        |    |___ p
2382        |____|___|___ __ _  _
2383        f    t   n
2384 
2385 Here, the balance was s between times f and t, at which time a transfer
2386 occurred, updating the balance to p, until n, when the present transfer occurs.
2387 When a new transfer occurs at time n, the balance being p,
2388 we must:
2389 
2390   - Add the area p * (n - t) to the total area recorded so far
2391   - Update the last transfer time to n
2392 
2393 So if this graph represents the entire current fee period,
2394 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
2395 The complementary computations must be performed for both sender and
2396 recipient.
2397 
2398 Note that a transfer keeps global supply of SNX invariant.
2399 The sum of all balances is constant, and unmodified by any transfer.
2400 So the sum of all balances multiplied by the duration of a fee period is also
2401 constant, and this is equivalent to the sum of the area of every user's
2402 time/balance graph. Dividing through by that duration yields back the total
2403 synthetix supply. So, at the end of a fee period, we really do yield a user's
2404 average share in the synthetix supply over that period.
2405 
2406 A slight wrinkle is introduced if we consider the time r when the fee period
2407 rolls over. Then the previous fee period k-1 is before r, and the current fee
2408 period k is afterwards. If the last transfer took place before r,
2409 but the latest transfer occurred afterwards:
2410 
2411 k-1       |        k
2412       s __|_
2413        |  | |
2414        |  | |____ p
2415        |__|_|____|___ __ _  _
2416           |
2417        f  | t    n
2418           r
2419 
2420 In this situation the area (r-f)*s contributes to fee period k-1, while
2421 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2422 zero-value transfer to have occurred at time r. Their fee entitlement for the
2423 previous period will be finalised at the time of their first transfer during the
2424 current fee period, or when they query or withdraw their fee entitlement.
2425 
2426 In the implementation, the duration of different fee periods may be slightly irregular,
2427 as the check that they have rolled over occurs only when state-changing synthetix
2428 operations are performed.
2429 
2430 == Issuance and Burning ==
2431 
2432 In this version of the synthetix contract, synths can only be issued by
2433 those that have been nominated by the synthetix foundation. Synths are assumed
2434 to be valued at $1, as they are a stable unit of account.
2435 
2436 All synths issued require a proportional value of SNX to be locked,
2437 where the proportion is governed by the current issuance ratio. This
2438 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
2439 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
2440 
2441 To determine the value of some amount of SNX(S), an oracle is used to push
2442 the price of SNX (P_S) in dollars to the contract. The value of S
2443 would then be: S * P_S.
2444 
2445 Any SNX that are locked up by this issuance process cannot be transferred.
2446 The amount that is locked floats based on the price of SNX. If the price
2447 of SNX moves up, less SNX are locked, so they can be issued against,
2448 or transferred freely. If the price of SNX moves down, more SNX are locked,
2449 even going above the initial wallet balance.
2450 
2451 -----------------------------------------------------------------
2452 */
2453 
2454 
2455 /**
2456  * @title Synthetix ERC20 contract.
2457  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2458  * but it also computes the quantity of fees each synthetix holder is entitled to.
2459  */
2460 contract Synthetix is ExternStateToken {
2461 
2462     // ========== STATE VARIABLES ==========
2463 
2464     // Available Synths which can be used with the system
2465     Synth[] public availableSynths;
2466     mapping(bytes4 => Synth) public synths;
2467 
2468     FeePool public feePool;
2469     SynthetixEscrow public escrow;
2470     ExchangeRates public exchangeRates;
2471     SynthetixState public synthetixState;
2472 
2473     uint constant SYNTHETIX_SUPPLY = 1e8 * SafeDecimalMath.unit();
2474     string constant TOKEN_NAME = "Synthetix Network Token";
2475     string constant TOKEN_SYMBOL = "SNX";
2476     uint8 constant DECIMALS = 18;
2477 
2478     // ========== CONSTRUCTOR ==========
2479 
2480     /**
2481      * @dev Constructor
2482      * @param _tokenState A pre-populated contract containing token balances.
2483      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2484      * @param _owner The owner of this contract.
2485      */
2486     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2487         address _owner, ExchangeRates _exchangeRates, FeePool _feePool
2488     )
2489         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, SYNTHETIX_SUPPLY, DECIMALS, _owner)
2490         public
2491     {
2492         synthetixState = _synthetixState;
2493         exchangeRates = _exchangeRates;
2494         feePool = _feePool;
2495     }
2496 
2497     // ========== SETTERS ========== */
2498 
2499     /**
2500      * @notice Add an associated Synth contract to the Synthetix system
2501      * @dev Only the contract owner may call this.
2502      */
2503     function addSynth(Synth synth)
2504         external
2505         optionalProxy_onlyOwner
2506     {
2507         bytes4 currencyKey = synth.currencyKey();
2508 
2509         require(synths[currencyKey] == Synth(0), "Synth already exists");
2510 
2511         availableSynths.push(synth);
2512         synths[currencyKey] = synth;
2513 
2514         emitSynthAdded(currencyKey, synth);
2515     }
2516 
2517     /**
2518      * @notice Remove an associated Synth contract from the Synthetix system
2519      * @dev Only the contract owner may call this.
2520      */
2521     function removeSynth(bytes4 currencyKey)
2522         external
2523         optionalProxy_onlyOwner
2524     {
2525         require(synths[currencyKey] != address(0), "Synth does not exist");
2526         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2527         require(currencyKey != "XDR", "Cannot remove XDR synth");
2528 
2529         // Save the address we're removing for emitting the event at the end.
2530         address synthToRemove = synths[currencyKey];
2531 
2532         // Remove the synth from the availableSynths array.
2533         for (uint8 i = 0; i < availableSynths.length; i++) {
2534             if (availableSynths[i] == synthToRemove) {
2535                 delete availableSynths[i];
2536 
2537                 // Copy the last synth into the place of the one we just deleted
2538                 // If there's only one synth, this is synths[0] = synths[0].
2539                 // If we're deleting the last one, it's also a NOOP in the same way.
2540                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2541 
2542                 // Decrease the size of the array by one.
2543                 availableSynths.length--;
2544 
2545                 break;
2546             }
2547         }
2548 
2549         // And remove it from the synths mapping
2550         delete synths[currencyKey];
2551 
2552         emitSynthRemoved(currencyKey, synthToRemove);
2553     }
2554 
2555     /**
2556      * @notice Set the associated synthetix escrow contract.
2557      * @dev Only the contract owner may call this.
2558      */
2559     function setEscrow(SynthetixEscrow _escrow)
2560         external
2561         optionalProxy_onlyOwner
2562     {
2563         escrow = _escrow;
2564         // Note: No event here as our contract exceeds max contract size
2565         // with these events, and it's unlikely people will need to
2566         // track these events specifically.
2567     }
2568 
2569     /**
2570      * @notice Set the ExchangeRates contract address where rates are held.
2571      * @dev Only callable by the contract owner.
2572      */
2573     function setExchangeRates(ExchangeRates _exchangeRates)
2574         external
2575         optionalProxy_onlyOwner
2576     {
2577         exchangeRates = _exchangeRates;
2578         // Note: No event here as our contract exceeds max contract size
2579         // with these events, and it's unlikely people will need to
2580         // track these events specifically.
2581     }
2582 
2583     /**
2584      * @notice Set the synthetixState contract address where issuance data is held.
2585      * @dev Only callable by the contract owner.
2586      */
2587     function setSynthetixState(SynthetixState _synthetixState)
2588         external
2589         optionalProxy_onlyOwner
2590     {
2591         synthetixState = _synthetixState;
2592 
2593         emitStateContractChanged(_synthetixState);
2594     }
2595 
2596     /**
2597      * @notice Set your preferred currency. Note: This does not automatically exchange any balances you've held previously in
2598      * other synth currencies in this address, it will apply for any new payments you receive at this address.
2599      */
2600     function setPreferredCurrency(bytes4 currencyKey)
2601         external
2602         optionalProxy
2603     {
2604         require(currencyKey == 0 || !exchangeRates.rateIsStale(currencyKey), "Currency rate is stale or doesn't exist.");
2605 
2606         synthetixState.setPreferredCurrency(messageSender, currencyKey);
2607 
2608         emitPreferredCurrencyChanged(messageSender, currencyKey);
2609     }
2610 
2611     // ========== VIEWS ==========
2612 
2613     /**
2614      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2615      * @param sourceCurrencyKey The currency the amount is specified in
2616      * @param sourceAmount The source amount, specified in UNIT base
2617      * @param destinationCurrencyKey The destination currency
2618      */
2619     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
2620         public
2621         view
2622         rateNotStale(sourceCurrencyKey)
2623         rateNotStale(destinationCurrencyKey)
2624         returns (uint)
2625     {
2626         // If there's no change in the currency, then just return the amount they gave us
2627         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
2628 
2629         // Calculate the effective value by going from source -> USD -> destination
2630         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
2631             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
2632     }
2633 
2634     /**
2635      * @notice Total amount of synths issued by the system, priced in currencyKey
2636      * @param currencyKey The currency to value the synths in
2637      */
2638     function totalIssuedSynths(bytes4 currencyKey)
2639         public
2640         view
2641         rateNotStale(currencyKey)
2642         returns (uint)
2643     {
2644         uint total = 0;
2645         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2646         
2647         require(!exchangeRates.anyRateIsStale(availableCurrencyKeys()), "Rates are stale");
2648         
2649         for (uint8 i = 0; i < availableSynths.length; i++) {
2650             // What's the total issued value of that synth in the destination currency?
2651             // Note: We're not using our effectiveValue function because we don't want to go get the
2652             //       rate for the destination currency and check if it's stale repeatedly on every
2653             //       iteration of the loop
2654             uint synthValue = availableSynths[i].totalSupply()
2655                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
2656                 .divideDecimalRound(currencyRate);
2657             total = total.add(synthValue);
2658         }
2659 
2660         return total;
2661     }
2662 
2663     /**
2664      * @notice Returns the currencyKeys of availableSynths for rate checking 
2665      */
2666     function availableCurrencyKeys()
2667         internal
2668         view
2669         returns (bytes4[])
2670     {
2671         bytes4[] memory availableCurrencyKeys = new bytes4[](availableSynths.length);
2672 
2673         for (uint8 i = 0; i < availableSynths.length; i++) {
2674             availableCurrencyKeys[i] = availableSynths[i].currencyKey();
2675         }
2676 
2677         return availableCurrencyKeys;
2678     }
2679 
2680     /**
2681      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
2682      */
2683     function availableSynthCount()
2684         public
2685         view
2686         returns (uint)
2687     {
2688         return availableSynths.length;
2689     }
2690 
2691     // ========== MUTATIVE FUNCTIONS ==========
2692 
2693     /**
2694      * @notice ERC20 transfer function.
2695      */
2696     function transfer(address to, uint value)
2697         public
2698         returns (bool)
2699     {
2700         bytes memory empty;
2701         return transfer(to, value, empty);
2702     }
2703 
2704     /**
2705      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
2706      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2707      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2708      *           tooling such as Etherscan.
2709      */
2710     function transfer(address to, uint value, bytes data)
2711         public
2712         optionalProxy
2713         returns (bool)
2714     {
2715         // Ensure they're not trying to exceed their locked amount
2716         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
2717 
2718         // Perform the transfer: if there is a problem an exception will be thrown in this call.
2719         _transfer_byProxy(messageSender, to, value, data);
2720 
2721         return true;
2722     }
2723 
2724     /**
2725      * @notice ERC20 transferFrom function.
2726      */
2727     function transferFrom(address from, address to, uint value)
2728         public
2729         returns (bool)
2730     {
2731         bytes memory empty;
2732         return transferFrom(from, to, value, empty);
2733     }
2734 
2735     /**
2736      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
2737      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2738      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2739      *           tooling such as Etherscan.
2740      */
2741     function transferFrom(address from, address to, uint value, bytes data)
2742         public
2743         optionalProxy
2744         returns (bool)
2745     {
2746         // Ensure they're not trying to exceed their locked amount
2747         require(value <= transferableSynthetix(from), "Insufficient balance");
2748 
2749         // Perform the transfer: if there is a problem,
2750         // an exception will be thrown in this call.
2751         _transferFrom_byProxy(messageSender, from, to, value, data);
2752 
2753         return true;
2754     }
2755 
2756     /**
2757      * @notice Function that allows you to exchange synths you hold in one flavour for another.
2758      * @param sourceCurrencyKey The source currency you wish to exchange from
2759      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2760      * @param destinationCurrencyKey The destination currency you wish to obtain.
2761      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
2762      * @return Boolean that indicates whether the transfer succeeded or failed.
2763      */
2764     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
2765         external
2766         optionalProxy
2767         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
2768         returns (bool)
2769     {
2770         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
2771         require(sourceAmount > 0, "Zero amount");
2772 
2773         // Pass it along, defaulting to the sender as the recipient.
2774         return _internalExchange(
2775             messageSender,
2776             sourceCurrencyKey,
2777             sourceAmount,
2778             destinationCurrencyKey,
2779             destinationAddress == address(0) ? messageSender : destinationAddress,
2780             true // Charge fee on the exchange
2781         );
2782     }
2783 
2784     /**
2785      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
2786      * @dev Only the synth contract can call this function
2787      * @param from The address to exchange / burn synth from
2788      * @param sourceCurrencyKey The source currency you wish to exchange from
2789      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2790      * @param destinationCurrencyKey The destination currency you wish to obtain.
2791      * @param destinationAddress Where the result should go.
2792      * @return Boolean that indicates whether the transfer succeeded or failed.
2793      */
2794     function synthInitiatedExchange(
2795         address from,
2796         bytes4 sourceCurrencyKey,
2797         uint sourceAmount,
2798         bytes4 destinationCurrencyKey,
2799         address destinationAddress
2800     )
2801         external
2802         onlySynth
2803         returns (bool)
2804     {
2805         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
2806         require(sourceAmount > 0, "Zero amount");
2807 
2808         // Pass it along
2809         return _internalExchange(
2810             from,
2811             sourceCurrencyKey,
2812             sourceAmount,
2813             destinationCurrencyKey,
2814             destinationAddress,
2815             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
2816         );
2817     }
2818 
2819     /**
2820      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
2821      * @dev Only the synth contract can call this function.
2822      * @param from The address fee is coming from.
2823      * @param sourceCurrencyKey source currency fee from.
2824      * @param sourceAmount The amount, specified in UNIT of source currency.
2825      * @return Boolean that indicates whether the transfer succeeded or failed.
2826      */
2827     function synthInitiatedFeePayment(
2828         address from,
2829         bytes4 sourceCurrencyKey,
2830         uint sourceAmount
2831     )
2832         external
2833         onlySynth
2834         returns (bool)
2835     {
2836         // Allow fee to be 0 and skip minting XDRs to feePool 
2837         if (sourceAmount == 0) {
2838             return true;
2839         }
2840 
2841         require(sourceAmount > 0, "Source can't be 0");
2842 
2843         // Pass it along, defaulting to the sender as the recipient.
2844         bool result = _internalExchange(
2845             from,
2846             sourceCurrencyKey,
2847             sourceAmount,
2848             "XDR",
2849             feePool.FEE_ADDRESS(),
2850             false // Don't charge a fee on the exchange because this is already a fee
2851         );
2852 
2853         // Tell the fee pool about this.
2854         feePool.feePaid(sourceCurrencyKey, sourceAmount);
2855 
2856         return result;
2857     }
2858 
2859     /**
2860      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
2861      * @dev fee pool contract address is not allowed to call function
2862      * @param from The address to move synth from
2863      * @param sourceCurrencyKey source currency from.
2864      * @param sourceAmount The amount, specified in UNIT of source currency.
2865      * @param destinationCurrencyKey The destination currency to obtain.
2866      * @param destinationAddress Where the result should go.
2867      * @param chargeFee Boolean to charge a fee for transaction.
2868      * @return Boolean that indicates whether the transfer succeeded or failed.
2869      */
2870     function _internalExchange(
2871         address from,
2872         bytes4 sourceCurrencyKey,
2873         uint sourceAmount,
2874         bytes4 destinationCurrencyKey,
2875         address destinationAddress,
2876         bool chargeFee
2877     )
2878         internal
2879         notFeeAddress(from)
2880         returns (bool)
2881     {
2882         require(destinationAddress != address(0), "Zero destination");
2883         require(destinationAddress != address(this), "Synthetix is invalid destination");
2884         require(destinationAddress != address(proxy), "Proxy is invalid destination");
2885 
2886         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
2887         // the subtraction to not overflow, which would happen if their balance is not sufficient.
2888 
2889         // Burn the source amount
2890         synths[sourceCurrencyKey].burn(from, sourceAmount);
2891 
2892         // How much should they get in the destination currency?
2893         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
2894 
2895         // What's the fee on that currency that we should deduct?
2896         uint amountReceived = destinationAmount;
2897         uint fee = 0;
2898 
2899         if (chargeFee) {
2900             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
2901             fee = destinationAmount.sub(amountReceived);
2902         }
2903 
2904         // Issue their new synths
2905         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
2906 
2907         // Remit the fee in XDRs
2908         if (fee > 0) {
2909             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
2910             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
2911         }
2912 
2913         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
2914 
2915         // Call the ERC223 transfer callback if needed
2916         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
2917 
2918         //Let the DApps know there was a Synth exchange
2919         emitSynthExchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, amountReceived, destinationAddress);
2920 
2921         return true;
2922     }
2923 
2924     /**
2925      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
2926      * @dev Only internal calls from synthetix address.
2927      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
2928      * @param amount The amount of synths to register with a base of UNIT
2929      */
2930     function _addToDebtRegister(bytes4 currencyKey, uint amount)
2931         internal
2932         optionalProxy
2933     {
2934         // What is the value of the requested debt in XDRs?
2935         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
2936 
2937         // What is the value of all issued synths of the system (priced in XDRs)?
2938         uint totalDebtIssued = totalIssuedSynths("XDR");
2939 
2940         // What will the new total be including the new value?
2941         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2942 
2943         // What is their percentage (as a high precision int) of the total debt?
2944         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2945 
2946         // And what effect does this percentage have on the global debt holding of other issuers?
2947         // The delta specifically needs to not take into account any existing debt as it's already
2948         // accounted for in the delta from when they issued previously.
2949         // The delta is a high precision integer.
2950         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2951 
2952         // How much existing debt do they have?
2953         uint existingDebt = debtBalanceOf(messageSender, "XDR");
2954 
2955         // And what does their debt ownership look like including this previous stake?
2956         if (existingDebt > 0) {
2957             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2958         }
2959 
2960         // Are they a new issuer? If so, record them.
2961         if (!synthetixState.hasIssued(messageSender)) {
2962             synthetixState.incrementTotalIssuerCount();
2963         }
2964 
2965         // Save the debt entry parameters
2966         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
2967 
2968         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2969         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2970         if (synthetixState.debtLedgerLength() > 0) {
2971             synthetixState.appendDebtLedgerValue(
2972                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
2973             );
2974         } else {
2975             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
2976         }
2977     }
2978 
2979     /**
2980      * @notice Issue synths against the sender's SNX.
2981      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
2982      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
2983      * @param amount The amount of synths you wish to issue with a base of UNIT
2984      */
2985     function issueSynths(bytes4 currencyKey, uint amount)
2986         public
2987         optionalProxy
2988         nonZeroAmount(amount)
2989         // No need to check if price is stale, as it is checked in issuableSynths.
2990     {
2991         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
2992 
2993         // Keep track of the debt they're about to create
2994         _addToDebtRegister(currencyKey, amount);
2995 
2996         // Create their synths
2997         synths[currencyKey].issue(messageSender, amount);
2998     }
2999 
3000     /**
3001      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3002      * @dev Issuance is only allowed if the synthetix price isn't stale.
3003      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3004      */
3005     function issueMaxSynths(bytes4 currencyKey)
3006         external
3007         optionalProxy
3008     {
3009         // Figure out the maximum we can issue in that currency
3010         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3011 
3012         // And issue them
3013         issueSynths(currencyKey, maxIssuable);
3014     }
3015 
3016     /**
3017      * @notice Burn synths to clear issued synths/free SNX.
3018      * @param currencyKey The currency you're specifying to burn
3019      * @param amount The amount (in UNIT base) you wish to burn
3020      */
3021     function burnSynths(bytes4 currencyKey, uint amount)
3022         external
3023         optionalProxy
3024         // No need to check for stale rates as _removeFromDebtRegister calls effectiveValue
3025         // which does this for us
3026     {
3027         // How much debt do they have?
3028         uint debt = debtBalanceOf(messageSender, currencyKey);
3029 
3030         require(debt > 0, "No debt to forgive");
3031 
3032         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3033         // clear their debt and leave them be.
3034         uint amountToBurn = debt < amount ? debt : amount;
3035 
3036         // Remove their debt from the ledger
3037         _removeFromDebtRegister(currencyKey, amountToBurn);
3038 
3039         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3040         synths[currencyKey].burn(messageSender, amountToBurn);
3041     }
3042 
3043     /**
3044      * @notice Remove a debt position from the register
3045      * @param currencyKey The currency the user is presenting to forgive their debt
3046      * @param amount The amount (in UNIT base) being presented
3047      */
3048     function _removeFromDebtRegister(bytes4 currencyKey, uint amount)
3049         internal
3050     {
3051         // How much debt are they trying to remove in XDRs?
3052         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3053 
3054         // How much debt do they have?
3055         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3056 
3057         // What percentage of the total debt are they trying to remove?
3058         uint totalDebtIssued = totalIssuedSynths("XDR");
3059         uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(totalDebtIssued);
3060 
3061         // And what effect does this percentage have on the global debt holding of other issuers?
3062         // The delta specifically needs to not take into account any existing debt as it's already
3063         // accounted for in the delta from when they issued previously.
3064         uint delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3065 
3066         // Are they exiting the system, or are they just decreasing their debt position?
3067         if (debtToRemove == existingDebt) {
3068             synthetixState.clearIssuanceData(messageSender);
3069             synthetixState.decrementTotalIssuerCount();
3070         } else {
3071             // What percentage of the debt will they be left with?
3072             uint newDebt = existingDebt.sub(debtToRemove);
3073             uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3074             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3075 
3076             // Store the debt percentage and debt ledger as high precision integers
3077             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3078         }
3079 
3080         // Update our cumulative ledger. This is also a high precision integer.
3081         synthetixState.appendDebtLedgerValue(
3082             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3083         );
3084     }
3085 
3086     // ========== Issuance/Burning ==========
3087 
3088     /**
3089      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3090      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3091      */
3092     function maxIssuableSynths(address issuer, bytes4 currencyKey)
3093         public
3094         view
3095         // We don't need to check stale rates here as effectiveValue will do it for us.
3096         returns (uint)
3097     {
3098         // What is the value of their SNX balance in the destination currency?
3099         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3100 
3101         // They're allowed to issue up to issuanceRatio of that value
3102         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3103     }
3104 
3105     /**
3106      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3107      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
3108      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3109      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
3110      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3111      * altering the amount of fees they're able to claim from the system.
3112      */
3113     function collateralisationRatio(address issuer)
3114         public
3115         view
3116         returns (uint)
3117     {
3118         uint totalOwnedSynthetix = collateral(issuer);
3119         if (totalOwnedSynthetix == 0) return 0;
3120 
3121         uint debtBalance = debtBalanceOf(issuer, "SNX");
3122         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3123     }
3124 
3125 /**
3126      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3127      * will tell you how many synths a user has to give back to the system in order to unlock their original
3128      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3129      * the debt in sUSD, XDR, or any other synth you wish.
3130      */
3131     function debtBalanceOf(address issuer, bytes4 currencyKey)
3132         public
3133         view
3134         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3135         returns (uint)
3136     {
3137         // What was their initial debt ownership?
3138         uint initialDebtOwnership;
3139         uint debtEntryIndex;
3140         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3141 
3142         // If it's zero, they haven't issued, and they have no debt.
3143         if (initialDebtOwnership == 0) return 0;
3144 
3145         // Figure out the global debt percentage delta from when they entered the system.
3146         // This is a high precision integer.
3147         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3148             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3149             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3150 
3151         // What's the total value of the system in their requested currency?
3152         uint totalSystemValue = totalIssuedSynths(currencyKey);
3153 
3154         // Their debt balance is their portion of the total system value.
3155         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3156             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3157 
3158         return highPrecisionBalance.preciseDecimalToDecimal();
3159     }
3160 
3161     /**
3162      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3163      * @param issuer The account that intends to issue
3164      * @param currencyKey The currency to price issuable value in
3165      */
3166     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
3167         public
3168         view
3169         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3170         returns (uint)
3171     {
3172         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3173         uint max = maxIssuableSynths(issuer, currencyKey);
3174 
3175         if (alreadyIssued >= max) {
3176             return 0;
3177         } else {
3178             return max.sub(alreadyIssued);
3179         }
3180     }
3181 
3182     /**
3183      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3184      * against which synths can be issued.
3185      * This includes those already being used as collateral (locked), and those
3186      * available for further issuance (unlocked).
3187      */
3188     function collateral(address account)
3189         public
3190         view
3191         returns (uint)
3192     {
3193         uint balance = tokenState.balanceOf(account);
3194 
3195         if (escrow != address(0)) {
3196             balance = balance.add(escrow.balanceOf(account));
3197         }
3198 
3199         return balance;
3200     }
3201 
3202     /**
3203      * @notice The number of SNX that are free to be transferred by an account.
3204      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
3205      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
3206      * in this calculation.
3207      */
3208     function transferableSynthetix(address account)
3209         public
3210         view
3211         rateNotStale("SNX")
3212         returns (uint)
3213     {
3214         // How many SNX do they have, excluding escrow?
3215         // Note: We're excluding escrow here because we're interested in their transferable amount
3216         // and escrowed SNX are not transferable.
3217         uint balance = tokenState.balanceOf(account);
3218 
3219         // How many of those will be locked by the amount they've issued?
3220         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3221         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3222         // The locked synthetix value can exceed their balance.
3223         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3224 
3225         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3226         if (lockedSynthetixValue >= balance) {
3227             return 0;
3228         } else {
3229             return balance.sub(lockedSynthetixValue);
3230         }
3231     }
3232 
3233     // ========== MODIFIERS ==========
3234 
3235     modifier rateNotStale(bytes4 currencyKey) {
3236         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
3237         _;
3238     }
3239 
3240     modifier notFeeAddress(address account) {
3241         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3242         _;
3243     }
3244 
3245     modifier onlySynth() {
3246         bool isSynth = false;
3247 
3248         // No need to repeatedly call this function either
3249         for (uint8 i = 0; i < availableSynths.length; i++) {
3250             if (availableSynths[i] == msg.sender) {
3251                 isSynth = true;
3252                 break;
3253             }
3254         }
3255 
3256         require(isSynth, "Only synth allowed");
3257         _;
3258     }
3259 
3260     modifier nonZeroAmount(uint _amount) {
3261         require(_amount > 0, "Amount needs to be larger than 0");
3262         _;
3263     }
3264 
3265     // ========== EVENTS ==========
3266     /* solium-disable */
3267 
3268     event SynthExchange(address indexed account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey,  uint256 toAmount, address toAddress);
3269     bytes32 constant SYNTHEXCHANGE_SIG = keccak256("SynthExchange(address,bytes4,uint256,bytes4,uint256,address)");
3270     function emitSynthExchange(address account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey, uint256 toAmount, address toAddress) internal {
3271         proxy._emit(abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress), 2, SYNTHEXCHANGE_SIG, bytes32(account), 0, 0);
3272     }
3273     
3274     event PreferredCurrencyChanged(address indexed account, bytes4 newPreferredCurrency);
3275     bytes32 constant PREFERREDCURRENCYCHANGED_SIG = keccak256("PreferredCurrencyChanged(address,bytes4)");
3276     function emitPreferredCurrencyChanged(address account, bytes4 newPreferredCurrency) internal {
3277         proxy._emit(abi.encode(newPreferredCurrency), 2, PREFERREDCURRENCYCHANGED_SIG, bytes32(account), 0, 0);
3278     }
3279 
3280     event StateContractChanged(address stateContract);
3281     bytes32 constant STATECONTRACTCHANGED_SIG = keccak256("StateContractChanged(address)");
3282     function emitStateContractChanged(address stateContract) internal {
3283         proxy._emit(abi.encode(stateContract), 1, STATECONTRACTCHANGED_SIG, 0, 0, 0);
3284     }
3285 
3286     event SynthAdded(bytes4 currencyKey, address newSynth);
3287     bytes32 constant SYNTHADDED_SIG = keccak256("SynthAdded(bytes4,address)");
3288     function emitSynthAdded(bytes4 currencyKey, address newSynth) internal {
3289         proxy._emit(abi.encode(currencyKey, newSynth), 1, SYNTHADDED_SIG, 0, 0, 0);
3290     }
3291 
3292     event SynthRemoved(bytes4 currencyKey, address removedSynth);
3293     bytes32 constant SYNTHREMOVED_SIG = keccak256("SynthRemoved(bytes4,address)");
3294     function emitSynthRemoved(bytes4 currencyKey, address removedSynth) internal {
3295         proxy._emit(abi.encode(currencyKey, removedSynth), 1, SYNTHREMOVED_SIG, 0, 0, 0);
3296     }
3297     /* solium-enable */
3298 }
3299 
3300 
3301 /*
3302 -----------------------------------------------------------------
3303 FILE INFORMATION
3304 -----------------------------------------------------------------
3305 
3306 file:       FeePool.sol
3307 version:    1.0
3308 author:     Kevin Brown
3309 date:       2018-10-15
3310 
3311 -----------------------------------------------------------------
3312 MODULE DESCRIPTION
3313 -----------------------------------------------------------------
3314 
3315 The FeePool is a place for users to interact with the fees that
3316 have been generated from the Synthetix system if they've helped
3317 to create the economy.
3318 
3319 Users stake Synthetix to create Synths. As Synth users transact,
3320 a small fee is deducted from each transaction, which collects
3321 in the fee pool. Fees are immediately converted to XDRs, a type
3322 of reserve currency similar to SDRs used by the IMF:
3323 https://www.imf.org/en/About/Factsheets/Sheets/2016/08/01/14/51/Special-Drawing-Right-SDR
3324 
3325 Users are entitled to withdraw fees from periods that they participated
3326 in fully, e.g. they have to stake before the period starts. They
3327 can withdraw fees for the last 6 periods as a single lump sum.
3328 Currently fee periods are 7 days long, meaning it's assumed
3329 users will withdraw their fees approximately once a month. Fees
3330 which are not withdrawn are redistributed to the whole pool,
3331 enabling these non-claimed fees to go back to the rest of the commmunity.
3332 
3333 Fees can be withdrawn in any synth currency.
3334 
3335 -----------------------------------------------------------------
3336 */
3337 
3338 
3339 contract FeePool is Proxyable, SelfDestructible {
3340 
3341     using SafeMath for uint;
3342     using SafeDecimalMath for uint;
3343 
3344     Synthetix public synthetix;
3345 
3346     // A percentage fee charged on each transfer.
3347     uint public transferFeeRate;
3348 
3349     // Transfer fee may not exceed 10%.
3350     uint constant public MAX_TRANSFER_FEE_RATE = SafeDecimalMath.unit() / 10;
3351 
3352     // A percentage fee charged on each exchange between currencies.
3353     uint public exchangeFeeRate;
3354 
3355     // Exchange fee may not exceed 10%.
3356     uint constant public MAX_EXCHANGE_FEE_RATE = SafeDecimalMath.unit() / 10;
3357 
3358     // The address with the authority to distribute fees.
3359     address public feeAuthority;
3360 
3361     // Where fees are pooled in XDRs.
3362     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
3363 
3364     // This struct represents the issuance activity that's happened in a fee period.
3365     struct FeePeriod {
3366         uint feePeriodId;
3367         uint startingDebtIndex;
3368         uint startTime;
3369         uint feesToDistribute;
3370         uint feesClaimed;
3371     }
3372 
3373     // The last 6 fee periods are all that you can claim from.
3374     // These are stored and managed from [0], such that [0] is always
3375     // the most recent fee period, and [5] is always the oldest fee
3376     // period that users can claim for.
3377     uint8 constant public FEE_PERIOD_LENGTH = 6;
3378     FeePeriod[FEE_PERIOD_LENGTH] public recentFeePeriods;
3379 
3380     // The next fee period will have this ID.
3381     uint public nextFeePeriodId;
3382 
3383     // How long a fee period lasts at a minimum. It is required for the
3384     // fee authority to roll over the periods, so they are not guaranteed
3385     // to roll over at exactly this duration, but the contract enforces
3386     // that they cannot roll over any quicker than this duration.
3387     uint public feePeriodDuration = 1 weeks;
3388 
3389     // The fee period must be between 1 day and 60 days.
3390     uint public constant MIN_FEE_PERIOD_DURATION = 1 days;
3391     uint public constant MAX_FEE_PERIOD_DURATION = 60 days;
3392 
3393     // The last period a user has withdrawn their fees in, identified by the feePeriodId
3394     mapping(address => uint) public lastFeeWithdrawal;
3395 
3396     // Users receive penalties if their collateralisation ratio drifts out of our desired brackets
3397     // We precompute the brackets and penalties to save gas.
3398     uint constant TWENTY_PERCENT = (20 * SafeDecimalMath.unit()) / 100;
3399     uint constant TWENTY_FIVE_PERCENT = (25 * SafeDecimalMath.unit()) / 100;
3400     uint constant THIRTY_PERCENT = (30 * SafeDecimalMath.unit()) / 100;
3401     uint constant FOURTY_PERCENT = (40 * SafeDecimalMath.unit()) / 100;
3402     uint constant FIFTY_PERCENT = (50 * SafeDecimalMath.unit()) / 100;
3403     uint constant SEVENTY_FIVE_PERCENT = (75 * SafeDecimalMath.unit()) / 100;
3404 
3405     constructor(address _proxy, address _owner, Synthetix _synthetix, address _feeAuthority, uint _transferFeeRate, uint _exchangeFeeRate)
3406         SelfDestructible(_owner)
3407         Proxyable(_proxy, _owner)
3408         public
3409     {
3410         // Constructed fee rates should respect the maximum fee rates.
3411         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
3412         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Constructed exchange fee rate should respect the maximum fee rate");
3413 
3414         synthetix = _synthetix;
3415         feeAuthority = _feeAuthority;
3416         transferFeeRate = _transferFeeRate;
3417         exchangeFeeRate = _exchangeFeeRate;
3418 
3419         // Set our initial fee period
3420         recentFeePeriods[0].feePeriodId = 1;
3421         recentFeePeriods[0].startTime = now;
3422         // Gas optimisation: These do not need to be initialised. They start at 0.
3423         // recentFeePeriods[0].startingDebtIndex = 0;
3424         // recentFeePeriods[0].feesToDistribute = 0;
3425 
3426         // And the next one starts at 2.
3427         nextFeePeriodId = 2;
3428     }
3429 
3430     /**
3431      * @notice Set the exchange fee, anywhere within the range 0-10%.
3432      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
3433      */
3434     function setExchangeFeeRate(uint _exchangeFeeRate)
3435         external
3436         optionalProxy_onlyOwner
3437     {
3438         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Exchange fee rate must be below MAX_EXCHANGE_FEE_RATE");
3439 
3440         exchangeFeeRate = _exchangeFeeRate;
3441 
3442         emitExchangeFeeUpdated(_exchangeFeeRate);
3443     }
3444 
3445     /**
3446      * @notice Set the transfer fee, anywhere within the range 0-10%.
3447      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
3448      */
3449     function setTransferFeeRate(uint _transferFeeRate)
3450         external
3451         optionalProxy_onlyOwner
3452     {
3453         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
3454 
3455         transferFeeRate = _transferFeeRate;
3456 
3457         emitTransferFeeUpdated(_transferFeeRate);
3458     }
3459 
3460     /**
3461      * @notice Set the address of the user/contract responsible for collecting or
3462      * distributing fees.
3463      */
3464     function setFeeAuthority(address _feeAuthority)
3465         external
3466         optionalProxy_onlyOwner
3467     {
3468         feeAuthority = _feeAuthority;
3469 
3470         emitFeeAuthorityUpdated(_feeAuthority);
3471     }
3472 
3473     /**
3474      * @notice Set the fee period duration
3475      */
3476     function setFeePeriodDuration(uint _feePeriodDuration)
3477         external
3478         optionalProxy_onlyOwner
3479     {
3480         require(_feePeriodDuration >= MIN_FEE_PERIOD_DURATION, "New fee period cannot be less than minimum fee period duration");
3481         require(_feePeriodDuration <= MAX_FEE_PERIOD_DURATION, "New fee period cannot be greater than maximum fee period duration");
3482 
3483         feePeriodDuration = _feePeriodDuration;
3484 
3485         emitFeePeriodDurationUpdated(_feePeriodDuration);
3486     }
3487 
3488     /**
3489      * @notice Set the synthetix contract
3490      */
3491     function setSynthetix(Synthetix _synthetix)
3492         external
3493         optionalProxy_onlyOwner
3494     {
3495         require(address(_synthetix) != address(0), "New Synthetix must be non-zero");
3496 
3497         synthetix = _synthetix;
3498 
3499         emitSynthetixUpdated(_synthetix);
3500     }
3501 
3502     /**
3503      * @notice The Synthetix contract informs us when fees are paid.
3504      */
3505     function feePaid(bytes4 currencyKey, uint amount)
3506         external
3507         onlySynthetix
3508     {
3509         uint xdrAmount = synthetix.effectiveValue(currencyKey, amount, "XDR");
3510 
3511         // Which we keep track of in XDRs in our fee pool.
3512         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.add(xdrAmount);
3513     }
3514 
3515     /**
3516      * @notice Close the current fee period and start a new one. Only callable by the fee authority.
3517      */
3518     function closeCurrentFeePeriod()
3519         external
3520         onlyFeeAuthority
3521     {
3522         require(recentFeePeriods[0].startTime <= (now - feePeriodDuration), "It is too early to close the current fee period");
3523 
3524         FeePeriod memory secondLastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 2];
3525         FeePeriod memory lastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 1];
3526 
3527         // Any unclaimed fees from the last period in the array roll back one period.
3528         // Because of the subtraction here, they're effectively proportionally redistributed to those who
3529         // have already claimed from the old period, available in the new period.
3530         // The subtraction is important so we don't create a ticking time bomb of an ever growing
3531         // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
3532         recentFeePeriods[FEE_PERIOD_LENGTH - 2].feesToDistribute = lastFeePeriod.feesToDistribute
3533             .sub(lastFeePeriod.feesClaimed)
3534             .add(secondLastFeePeriod.feesToDistribute);
3535 
3536         // Shift the previous fee periods across to make room for the new one.
3537         // Condition checks for overflow when uint subtracts one from zero
3538         // Could be written with int instead of uint, but then we have to convert everywhere
3539         // so it felt better from a gas perspective to just change the condition to check
3540         // for overflow after subtracting one from zero.
3541         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
3542             uint next = i + 1;
3543 
3544             recentFeePeriods[next].feePeriodId = recentFeePeriods[i].feePeriodId;
3545             recentFeePeriods[next].startingDebtIndex = recentFeePeriods[i].startingDebtIndex;
3546             recentFeePeriods[next].startTime = recentFeePeriods[i].startTime;
3547             recentFeePeriods[next].feesToDistribute = recentFeePeriods[i].feesToDistribute;
3548             recentFeePeriods[next].feesClaimed = recentFeePeriods[i].feesClaimed;
3549         }
3550 
3551         // Clear the first element of the array to make sure we don't have any stale values.
3552         delete recentFeePeriods[0];
3553 
3554         // Open up the new fee period
3555         recentFeePeriods[0].feePeriodId = nextFeePeriodId;
3556         recentFeePeriods[0].startingDebtIndex = synthetix.synthetixState().debtLedgerLength();
3557         recentFeePeriods[0].startTime = now;
3558 
3559         nextFeePeriodId = nextFeePeriodId.add(1);
3560 
3561         emitFeePeriodClosed(recentFeePeriods[1].feePeriodId);
3562     }
3563 
3564     /**
3565     * @notice Claim fees for last period when available or not already withdrawn.
3566     * @param currencyKey Synth currency you wish to receive the fees in.
3567     */
3568     function claimFees(bytes4 currencyKey)
3569         external
3570         optionalProxy
3571         returns (bool)
3572     {
3573         uint availableFees = feesAvailable(messageSender, "XDR");
3574 
3575         require(availableFees > 0, "No fees available for period, or fees already claimed");
3576 
3577         lastFeeWithdrawal[messageSender] = recentFeePeriods[1].feePeriodId;
3578 
3579         // Record the fee payment in our recentFeePeriods
3580         _recordFeePayment(availableFees);
3581 
3582         // Send them their fees
3583         _payFees(messageSender, availableFees, currencyKey);
3584 
3585         emitFeesClaimed(messageSender, availableFees);
3586 
3587         return true;
3588     }
3589 
3590     /**
3591      * @notice Record the fee payment in our recentFeePeriods.
3592      * @param xdrAmount The amout of fees priced in XDRs.
3593      */
3594     function _recordFeePayment(uint xdrAmount)
3595         internal
3596     {
3597         // Don't assign to the parameter
3598         uint remainingToAllocate = xdrAmount;
3599 
3600         // Start at the oldest period and record the amount, moving to newer periods
3601         // until we've exhausted the amount.
3602         // The condition checks for overflow because we're going to 0 with an unsigned int.
3603         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
3604             uint delta = recentFeePeriods[i].feesToDistribute.sub(recentFeePeriods[i].feesClaimed);
3605 
3606             if (delta > 0) {
3607                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
3608                 uint amountInPeriod = delta < remainingToAllocate ? delta : remainingToAllocate;
3609 
3610                 recentFeePeriods[i].feesClaimed = recentFeePeriods[i].feesClaimed.add(amountInPeriod);
3611                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
3612 
3613                 // No need to continue iterating if we've recorded the whole amount;
3614                 if (remainingToAllocate == 0) return;
3615             }
3616         }
3617 
3618         // If we hit this line, we've exhausted our fee periods, but still have more to allocate. Wat?
3619         // If this happens it's a definite bug in the code, so assert instead of require.
3620         assert(remainingToAllocate == 0);
3621     }
3622 
3623     /**
3624     * @notice Send the fees to claiming address.
3625     * @param account The address to send the fees to.
3626     * @param xdrAmount The amount of fees priced in XDRs.
3627     * @param destinationCurrencyKey The synth currency the user wishes to receive their fees in (convert to this currency).
3628     */
3629     function _payFees(address account, uint xdrAmount, bytes4 destinationCurrencyKey)
3630         internal
3631         notFeeAddress(account)
3632     {
3633         require(account != address(0), "Account can't be 0");
3634         require(account != address(this), "Can't send fees to fee pool");
3635         require(account != address(proxy), "Can't send fees to proxy");
3636         require(account != address(synthetix), "Can't send fees to synthetix");
3637 
3638         Synth xdrSynth = synthetix.synths("XDR");
3639         Synth destinationSynth = synthetix.synths(destinationCurrencyKey);
3640 
3641         // Note: We don't need to check the fee pool balance as the burn() below will do a safe subtraction which requires
3642         // the subtraction to not overflow, which would happen if the balance is not sufficient.
3643 
3644         // Burn the source amount
3645         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
3646 
3647         // How much should they get in the destination currency?
3648         uint destinationAmount = synthetix.effectiveValue("XDR", xdrAmount, destinationCurrencyKey);
3649 
3650         // There's no fee on withdrawing fees, as that'd be way too meta.
3651 
3652         // Mint their new synths
3653         destinationSynth.issue(account, destinationAmount);
3654 
3655         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3656 
3657         // Call the ERC223 transfer callback if needed
3658         destinationSynth.triggerTokenFallbackIfNeeded(FEE_ADDRESS, account, destinationAmount);
3659     }
3660 
3661     /**
3662      * @notice Calculate the Fee charged on top of a value being sent
3663      * @return Return the fee charged
3664      */
3665     function transferFeeIncurred(uint value)
3666         public
3667         view
3668         returns (uint)
3669     {
3670         return value.multiplyDecimal(transferFeeRate);
3671 
3672         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
3673         // This is on the basis that transfers less than this value will result in a nil fee.
3674         // Probably too insignificant to worry about, but the following code will achieve it.
3675         //      if (fee == 0 && transferFeeRate != 0) {
3676         //          return _value;
3677         //      }
3678         //      return fee;
3679     }
3680 
3681     /**
3682      * @notice The value that you would need to send so that the recipient receives
3683      * a specified value.
3684      * @param value The value you want the recipient to receive
3685      */
3686     function transferredAmountToReceive(uint value)
3687         external
3688         view
3689         returns (uint)
3690     {
3691         return value.add(transferFeeIncurred(value));
3692     }
3693 
3694     /**
3695      * @notice The amount the recipient will receive if you send a certain number of tokens.
3696      * @param value The amount of tokens you intend to send.
3697      */
3698     function amountReceivedFromTransfer(uint value)
3699         external
3700         view
3701         returns (uint)
3702     {
3703         return value.divideDecimal(transferFeeRate.add(SafeDecimalMath.unit()));
3704     }
3705 
3706     /**
3707      * @notice Calculate the fee charged on top of a value being sent via an exchange
3708      * @return Return the fee charged
3709      */
3710     function exchangeFeeIncurred(uint value)
3711         public
3712         view
3713         returns (uint)
3714     {
3715         return value.multiplyDecimal(exchangeFeeRate);
3716 
3717         // Exchanges less than the reciprocal of exchangeFeeRate should be completely eaten up by fees.
3718         // This is on the basis that exchanges less than this value will result in a nil fee.
3719         // Probably too insignificant to worry about, but the following code will achieve it.
3720         //      if (fee == 0 && exchangeFeeRate != 0) {
3721         //          return _value;
3722         //      }
3723         //      return fee;
3724     }
3725 
3726     /**
3727      * @notice The value that you would need to get after currency exchange so that the recipient receives
3728      * a specified value.
3729      * @param value The value you want the recipient to receive
3730      */
3731     function exchangedAmountToReceive(uint value)
3732         external
3733         view
3734         returns (uint)
3735     {
3736         return value.add(exchangeFeeIncurred(value));
3737     }
3738 
3739     /**
3740      * @notice The amount the recipient will receive if you are performing an exchange and the
3741      * destination currency will be worth a certain number of tokens.
3742      * @param value The amount of destination currency tokens they received after the exchange.
3743      */
3744     function amountReceivedFromExchange(uint value)
3745         external
3746         view
3747         returns (uint)
3748     {
3749         return value.divideDecimal(exchangeFeeRate.add(SafeDecimalMath.unit()));
3750     }
3751 
3752     /**
3753      * @notice The total fees available in the system to be withdrawn, priced in currencyKey currency
3754      * @param currencyKey The currency you want to price the fees in
3755      */
3756     function totalFeesAvailable(bytes4 currencyKey)
3757         external
3758         view
3759         returns (uint)
3760     {
3761         uint totalFees = 0;
3762 
3763         // Fees in fee period [0] are not yet available for withdrawal
3764         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
3765             totalFees = totalFees.add(recentFeePeriods[i].feesToDistribute);
3766             totalFees = totalFees.sub(recentFeePeriods[i].feesClaimed);
3767         }
3768 
3769         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
3770     }
3771 
3772     /**
3773      * @notice The fees available to be withdrawn by a specific account, priced in currencyKey currency
3774      * @param currencyKey The currency you want to price the fees in
3775      */
3776     function feesAvailable(address account, bytes4 currencyKey)
3777         public
3778         view
3779         returns (uint)
3780     {
3781         // Add up the fees
3782         uint[FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);
3783 
3784         uint totalFees = 0;
3785 
3786         // Fees in fee period [0] are not yet available for withdrawal
3787         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
3788             totalFees = totalFees.add(userFees[i]);
3789         }
3790 
3791         // And convert them to their desired currency
3792         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
3793     }
3794 
3795     /**
3796      * @notice The penalty a particular address would incur if its fees were withdrawn right now
3797      * @param account The address you want to query the penalty for
3798      */
3799     function currentPenalty(address account)
3800         public
3801         view
3802         returns (uint)
3803     {
3804         uint ratio = synthetix.collateralisationRatio(account);
3805 
3806         // Users receive a different amount of fees depending on how their collateralisation ratio looks right now.
3807         // 0% - 20%: Fee is calculated based on percentage of economy issued.
3808         // 20% - 30%: 25% reduction in fees
3809         // 30% - 40%: 50% reduction in fees
3810         // >40%: 75% reduction in fees
3811         if (ratio <= TWENTY_PERCENT) {
3812             return 0;
3813         } else if (ratio > TWENTY_PERCENT && ratio <= THIRTY_PERCENT) {
3814             return TWENTY_FIVE_PERCENT;
3815         } else if (ratio > THIRTY_PERCENT && ratio <= FOURTY_PERCENT) {
3816             return FIFTY_PERCENT;
3817         }
3818 
3819         return SEVENTY_FIVE_PERCENT;
3820     }
3821 
3822     /**
3823      * @notice Calculates fees by period for an account, priced in XDRs
3824      * @param account The address you want to query the fees by penalty for
3825      */
3826     function feesByPeriod(address account)
3827         public
3828         view
3829         returns (uint[FEE_PERIOD_LENGTH])
3830     {
3831         uint[FEE_PERIOD_LENGTH] memory result;
3832 
3833         // What's the user's debt entry index and the debt they owe to the system
3834         uint initialDebtOwnership;
3835         uint debtEntryIndex;
3836         (initialDebtOwnership, debtEntryIndex) = synthetix.synthetixState().issuanceData(account);
3837 
3838         // If they don't have any debt ownership, they don't have any fees
3839         if (initialDebtOwnership == 0) return result;
3840 
3841         // If there are no XDR synths, then they don't have any fees
3842         uint totalSynths = synthetix.totalIssuedSynths("XDR");
3843         if (totalSynths == 0) return result;
3844 
3845         uint debtBalance = synthetix.debtBalanceOf(account, "XDR");
3846         uint userOwnershipPercentage = debtBalance.divideDecimal(totalSynths);
3847         uint penalty = currentPenalty(account);
3848         
3849         // Go through our fee periods and figure out what we owe them.
3850         // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
3851         // fees owing for, so we need to report on it anyway.
3852         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
3853             // Were they a part of this period in its entirety?
3854             // We don't allow pro-rata participation to reduce the ability to game the system by
3855             // issuing and burning multiple times in a period or close to the ends of periods.
3856             if (recentFeePeriods[i].startingDebtIndex > debtEntryIndex &&
3857                 lastFeeWithdrawal[account] < recentFeePeriods[i].feePeriodId) {
3858 
3859                 // And since they were, they're entitled to their percentage of the fees in this period
3860                 uint feesFromPeriodWithoutPenalty = recentFeePeriods[i].feesToDistribute
3861                     .multiplyDecimal(userOwnershipPercentage);
3862 
3863                 // Less their penalty if they have one.
3864                 uint penaltyFromPeriod = feesFromPeriodWithoutPenalty.multiplyDecimal(penalty);
3865                 uint feesFromPeriod = feesFromPeriodWithoutPenalty.sub(penaltyFromPeriod);
3866 
3867                 result[i] = feesFromPeriod;
3868             }
3869         }
3870 
3871         return result;
3872     }
3873 
3874     modifier onlyFeeAuthority
3875     {
3876         require(msg.sender == feeAuthority, "Only the fee authority can perform this action");
3877         _;
3878     }
3879 
3880     modifier onlySynthetix
3881     {
3882         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
3883         _;
3884     }
3885 
3886     modifier notFeeAddress(address account) {
3887         require(account != FEE_ADDRESS, "Fee address not allowed");
3888         _;
3889     }
3890 
3891     event TransferFeeUpdated(uint newFeeRate);
3892     bytes32 constant TRANSFERFEEUPDATED_SIG = keccak256("TransferFeeUpdated(uint256)");
3893     function emitTransferFeeUpdated(uint newFeeRate) internal {
3894         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEEUPDATED_SIG, 0, 0, 0);
3895     }
3896 
3897     event ExchangeFeeUpdated(uint newFeeRate);
3898     bytes32 constant EXCHANGEFEEUPDATED_SIG = keccak256("ExchangeFeeUpdated(uint256)");
3899     function emitExchangeFeeUpdated(uint newFeeRate) internal {
3900         proxy._emit(abi.encode(newFeeRate), 1, EXCHANGEFEEUPDATED_SIG, 0, 0, 0);
3901     }
3902 
3903     event FeePeriodDurationUpdated(uint newFeePeriodDuration);
3904     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
3905     function emitFeePeriodDurationUpdated(uint newFeePeriodDuration) internal {
3906         proxy._emit(abi.encode(newFeePeriodDuration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
3907     }
3908 
3909     event FeeAuthorityUpdated(address newFeeAuthority);
3910     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
3911     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
3912         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
3913     }
3914 
3915     event FeePeriodClosed(uint feePeriodId);
3916     bytes32 constant FEEPERIODCLOSED_SIG = keccak256("FeePeriodClosed(uint256)");
3917     function emitFeePeriodClosed(uint feePeriodId) internal {
3918         proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
3919     }
3920 
3921     event FeesClaimed(address account, uint xdrAmount);
3922     bytes32 constant FEESCLAIMED_SIG = keccak256("FeesClaimed(address,uint256)");
3923     function emitFeesClaimed(address account, uint xdrAmount) internal {
3924         proxy._emit(abi.encode(account, xdrAmount), 1, FEESCLAIMED_SIG, 0, 0, 0);
3925     }
3926 
3927     event SynthetixUpdated(address newSynthetix);
3928     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
3929     function emitSynthetixUpdated(address newSynthetix) internal {
3930         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
3931     }
3932 }
3933 
3934 
3935 /*
3936 -----------------------------------------------------------------
3937 FILE INFORMATION
3938 -----------------------------------------------------------------
3939 
3940 file:       Synth.sol
3941 version:    2.0
3942 author:     Kevin Brown
3943 date:       2018-09-13
3944 
3945 -----------------------------------------------------------------
3946 MODULE DESCRIPTION
3947 -----------------------------------------------------------------
3948 
3949 Synthetix-backed stablecoin contract.
3950 
3951 This contract issues synths, which are tokens that mirror various
3952 flavours of fiat currency.
3953 
3954 Synths are issuable by Synthetix Network Token (SNX) holders who 
3955 have to lock up some value of their SNX to issue S * Cmax synths. 
3956 Where Cmax issome value less than 1.
3957 
3958 A configurable fee is charged on synth transfers and deposited
3959 into a common pot, which Synthetix holders may withdraw from once
3960 per fee period.
3961 
3962 -----------------------------------------------------------------
3963 */
3964 
3965 
3966 contract Synth is ExternStateToken {
3967 
3968     /* ========== STATE VARIABLES ========== */
3969 
3970     FeePool public feePool;
3971     Synthetix public synthetix;
3972 
3973     // Currency key which identifies this Synth to the Synthetix system
3974     bytes4 public currencyKey;
3975 
3976     uint8 constant DECIMALS = 18;
3977 
3978     /* ========== CONSTRUCTOR ========== */
3979 
3980     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, FeePool _feePool,
3981         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey
3982     )
3983         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, 0, DECIMALS, _owner)
3984         public
3985     {
3986         require(_proxy != 0, "_proxy cannot be 0");
3987         require(address(_synthetix) != 0, "_synthetix cannot be 0");
3988         require(address(_feePool) != 0, "_feePool cannot be 0");
3989         require(_owner != 0, "_owner cannot be 0");
3990         require(_synthetix.synths(_currencyKey) == Synth(0), "Currency key is already in use");
3991 
3992         feePool = _feePool;
3993         synthetix = _synthetix;
3994         currencyKey = _currencyKey;
3995     }
3996 
3997     /* ========== SETTERS ========== */
3998 
3999     function setSynthetix(Synthetix _synthetix)
4000         external
4001         optionalProxy_onlyOwner
4002     {
4003         synthetix = _synthetix;
4004         emitSynthetixUpdated(_synthetix);
4005     }
4006 
4007     function setFeePool(FeePool _feePool)
4008         external
4009         optionalProxy_onlyOwner
4010     {
4011         feePool = _feePool;
4012         emitFeePoolUpdated(_feePool);
4013     }
4014 
4015     /* ========== MUTATIVE FUNCTIONS ========== */
4016 
4017     /**
4018      * @notice Override ERC20 transfer function in order to 
4019      * subtract the transaction fee and send it to the fee pool
4020      * for SNX holders to claim. */
4021     function transfer(address to, uint value)
4022         public
4023         optionalProxy
4024         notFeeAddress(messageSender)
4025         returns (bool)
4026     {
4027         uint amountReceived = feePool.amountReceivedFromTransfer(value);
4028         uint fee = value.sub(amountReceived);
4029 
4030         // Send the fee off to the fee pool.
4031         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
4032 
4033         // And send their result off to the destination address
4034         bytes memory empty;
4035         return _internalTransfer(messageSender, to, amountReceived, empty);
4036     }
4037 
4038     /**
4039      * @notice Override ERC223 transfer function in order to 
4040      * subtract the transaction fee and send it to the fee pool
4041      * for SNX holders to claim. */
4042     function transfer(address to, uint value, bytes data)
4043         public
4044         optionalProxy
4045         notFeeAddress(messageSender)
4046         returns (bool)
4047     {
4048         uint amountReceived = feePool.amountReceivedFromTransfer(value);
4049         uint fee = value.sub(amountReceived);
4050 
4051         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
4052         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
4053 
4054         // And send their result off to the destination address
4055         return _internalTransfer(messageSender, to, amountReceived, data);
4056     }
4057 
4058     /**
4059      * @notice Override ERC20 transferFrom function in order to 
4060      * subtract the transaction fee and send it to the fee pool
4061      * for SNX holders to claim. */
4062     function transferFrom(address from, address to, uint value)
4063         public
4064         optionalProxy
4065         notFeeAddress(from)
4066         returns (bool)
4067     {
4068         // The fee is deducted from the amount sent.
4069         uint amountReceived = feePool.amountReceivedFromTransfer(value);
4070         uint fee = value.sub(amountReceived);
4071 
4072         // Reduce the allowance by the amount we're transferring.
4073         // The safeSub call will handle an insufficient allowance.
4074         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
4075 
4076         // Send the fee off to the fee pool.
4077         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
4078 
4079         bytes memory empty;
4080         return _internalTransfer(from, to, amountReceived, empty);
4081     }
4082 
4083     /**
4084      * @notice Override ERC223 transferFrom function in order to 
4085      * subtract the transaction fee and send it to the fee pool
4086      * for SNX holders to claim. */
4087     function transferFrom(address from, address to, uint value, bytes data)
4088         public
4089         optionalProxy
4090         notFeeAddress(from)
4091         returns (bool)
4092     {
4093         // The fee is deducted from the amount sent.
4094         uint amountReceived = feePool.amountReceivedFromTransfer(value);
4095         uint fee = value.sub(amountReceived);
4096 
4097         // Reduce the allowance by the amount we're transferring.
4098         // The safeSub call will handle an insufficient allowance.
4099         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
4100 
4101         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
4102         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
4103 
4104         return _internalTransfer(from, to, amountReceived, data);
4105     }
4106 
4107     /* Subtract the transfer fee from the senders account so the 
4108      * receiver gets the exact amount specified to send. */
4109     function transferSenderPaysFee(address to, uint value)
4110         public
4111         optionalProxy
4112         notFeeAddress(messageSender)
4113         returns (bool)
4114     {
4115         uint fee = feePool.transferFeeIncurred(value);
4116 
4117         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
4118         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
4119 
4120         // And send their transfer amount off to the destination address
4121         bytes memory empty;
4122         return _internalTransfer(messageSender, to, value, empty);
4123     }
4124 
4125     /* Subtract the transfer fee from the senders account so the 
4126      * receiver gets the exact amount specified to send. */
4127     function transferSenderPaysFee(address to, uint value, bytes data)
4128         public
4129         optionalProxy
4130         notFeeAddress(messageSender)
4131         returns (bool)
4132     {
4133         uint fee = feePool.transferFeeIncurred(value);
4134 
4135         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
4136         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
4137 
4138         // And send their transfer amount off to the destination address
4139         return _internalTransfer(messageSender, to, value, data);
4140     }
4141 
4142     /* Subtract the transfer fee from the senders account so the 
4143      * to address receives the exact amount specified to send. */
4144     function transferFromSenderPaysFee(address from, address to, uint value)
4145         public
4146         optionalProxy
4147         notFeeAddress(from)
4148         returns (bool)
4149     {
4150         uint fee = feePool.transferFeeIncurred(value);
4151 
4152         // Reduce the allowance by the amount we're transferring.
4153         // The safeSub call will handle an insufficient allowance.
4154         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
4155 
4156         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
4157         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
4158 
4159         bytes memory empty;
4160         return _internalTransfer(from, to, value, empty);
4161     }
4162 
4163     /* Subtract the transfer fee from the senders account so the 
4164      * to address receives the exact amount specified to send. */
4165     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
4166         public
4167         optionalProxy
4168         notFeeAddress(from)
4169         returns (bool)
4170     {
4171         uint fee = feePool.transferFeeIncurred(value);
4172 
4173         // Reduce the allowance by the amount we're transferring.
4174         // The safeSub call will handle an insufficient allowance.
4175         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
4176 
4177         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
4178         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
4179 
4180         return _internalTransfer(from, to, value, data);
4181     }
4182 
4183     // Override our internal transfer to inject preferred currency support
4184     function _internalTransfer(address from, address to, uint value, bytes data)
4185         internal
4186         returns (bool)
4187     {
4188         bytes4 preferredCurrencyKey = synthetix.synthetixState().preferredCurrency(to);
4189 
4190         // Do they have a preferred currency that's not us? If so we need to exchange
4191         if (preferredCurrencyKey != 0 && preferredCurrencyKey != currencyKey) {
4192             return synthetix.synthInitiatedExchange(from, currencyKey, value, preferredCurrencyKey, to);
4193         } else {
4194             // Otherwise we just transfer
4195             return super._internalTransfer(from, to, value, data);
4196         }
4197     }
4198 
4199     // Allow synthetix to issue a certain number of synths from an account.
4200     function issue(address account, uint amount)
4201         external
4202         onlySynthetixOrFeePool
4203     {
4204         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
4205         totalSupply = totalSupply.add(amount);
4206         emitTransfer(address(0), account, amount);
4207         emitIssued(account, amount);
4208     }
4209 
4210     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
4211     function burn(address account, uint amount)
4212         external
4213         onlySynthetixOrFeePool
4214     {
4215         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
4216         totalSupply = totalSupply.sub(amount);
4217         emitTransfer(account, address(0), amount);
4218         emitBurned(account, amount);
4219     }
4220 
4221     // Allow owner to set the total supply on import.
4222     function setTotalSupply(uint amount)
4223         external
4224         optionalProxy_onlyOwner
4225     {
4226         totalSupply = amount;
4227     }
4228 
4229     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
4230     // exchange as well as transfer
4231     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
4232         external
4233         onlySynthetixOrFeePool
4234     {
4235         bytes memory empty;
4236         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
4237     }
4238 
4239     /* ========== MODIFIERS ========== */
4240 
4241     modifier onlySynthetixOrFeePool() {
4242         bool isSynthetix = msg.sender == address(synthetix);
4243         bool isFeePool = msg.sender == address(feePool);
4244 
4245         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
4246         _;
4247     }
4248 
4249     modifier notFeeAddress(address account) {
4250         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
4251         _;
4252     }
4253 
4254     /* ========== EVENTS ========== */
4255 
4256     event SynthetixUpdated(address newSynthetix);
4257     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
4258     function emitSynthetixUpdated(address newSynthetix) internal {
4259         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
4260     }
4261 
4262     event FeePoolUpdated(address newFeePool);
4263     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
4264     function emitFeePoolUpdated(address newFeePool) internal {
4265         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
4266     }
4267 
4268     event Issued(address indexed account, uint value);
4269     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
4270     function emitIssued(address account, uint value) internal {
4271         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
4272     }
4273 
4274     event Burned(address indexed account, uint value);
4275     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
4276     function emitBurned(address account, uint value) internal {
4277         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
4278     }
4279 }
4280 
