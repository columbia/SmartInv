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
1638     // A quantity of synths greater than this ratio
1639     // may not be issued against a given value of SNX.
1640     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
1641     // No more synths may be issued than the value of SNX backing them.
1642     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
1643 
1644     // Users can specify their preferred currency, in which case all synths they receive
1645     // will automatically exchange to that preferred currency upon receipt in their wallet
1646     mapping(address => bytes4) public preferredCurrency;
1647 
1648     /**
1649      * @dev Constructor
1650      * @param _owner The address which controls this contract.
1651      * @param _associatedContract The ERC20 contract whose state this composes.
1652      */
1653     constructor(address _owner, address _associatedContract)
1654         State(_owner, _associatedContract)
1655         LimitedSetup(1 weeks)
1656         public
1657     {}
1658 
1659     /* ========== SETTERS ========== */
1660 
1661     /**
1662      * @notice Set issuance data for an address
1663      * @dev Only the associated contract may call this.
1664      * @param account The address to set the data for.
1665      * @param initialDebtOwnership The initial debt ownership for this address.
1666      */
1667     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
1668         external
1669         onlyAssociatedContract
1670     {
1671         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
1672         issuanceData[account].debtEntryIndex = debtLedger.length;
1673     }
1674 
1675     /**
1676      * @notice Clear issuance data for an address
1677      * @dev Only the associated contract may call this.
1678      * @param account The address to clear the data for.
1679      */
1680     function clearIssuanceData(address account)
1681         external
1682         onlyAssociatedContract
1683     {
1684         delete issuanceData[account];
1685     }
1686 
1687     /**
1688      * @notice Increment the total issuer count
1689      * @dev Only the associated contract may call this.
1690      */
1691     function incrementTotalIssuerCount()
1692         external
1693         onlyAssociatedContract
1694     {
1695         totalIssuerCount = totalIssuerCount.add(1);
1696     }
1697 
1698     /**
1699      * @notice Decrement the total issuer count
1700      * @dev Only the associated contract may call this.
1701      */
1702     function decrementTotalIssuerCount()
1703         external
1704         onlyAssociatedContract
1705     {
1706         totalIssuerCount = totalIssuerCount.sub(1);
1707     }
1708 
1709     /**
1710      * @notice Append a value to the debt ledger
1711      * @dev Only the associated contract may call this.
1712      * @param value The new value to be added to the debt ledger.
1713      */
1714     function appendDebtLedgerValue(uint value)
1715         external
1716         onlyAssociatedContract
1717     {
1718         debtLedger.push(value);
1719     }
1720 
1721     /**
1722      * @notice Set preferred currency for a user
1723      * @dev Only the associated contract may call this.
1724      * @param account The account to set the preferred currency for
1725      * @param currencyKey The new preferred currency
1726      */
1727     function setPreferredCurrency(address account, bytes4 currencyKey)
1728         external
1729         onlyAssociatedContract
1730     {
1731         preferredCurrency[account] = currencyKey;
1732     }
1733 
1734     /**
1735      * @notice Set the issuanceRatio for issuance calculations.
1736      * @dev Only callable by the contract owner.
1737      */
1738     function setIssuanceRatio(uint _issuanceRatio)
1739         external
1740         onlyOwner
1741     {
1742         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
1743         issuanceRatio = _issuanceRatio;
1744         emit IssuanceRatioUpdated(_issuanceRatio);
1745     }
1746 
1747     /**
1748      * @notice Import issuer data from the old Synthetix contract before multicurrency
1749      * @dev Only callable by the contract owner, and only for 1 week after deployment.
1750      */
1751     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
1752         external
1753         onlyOwner
1754         onlyDuringSetup
1755     {
1756         require(accounts.length == sUSDAmounts.length, "Length mismatch");
1757 
1758         for (uint8 i = 0; i < accounts.length; i++) {
1759             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
1760         }
1761     }
1762 
1763     /**
1764      * @notice Import issuer data from the old Synthetix contract before multicurrency
1765      * @dev Only used from importIssuerData above, meant to be disposable
1766      */
1767     function _addToDebtRegister(address account, uint amount)
1768         internal
1769     {
1770         // This code is duplicated from Synthetix so that we can call it directly here
1771         // during setup only.
1772         Synthetix synthetix = Synthetix(associatedContract);
1773 
1774         // What is the value of the requested debt in XDRs?
1775         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
1776 
1777         // What is the value of all issued synths of the system (priced in XDRs)?
1778         uint totalDebtIssued = synthetix.totalIssuedSynths("XDR");
1779 
1780         // What will the new total be including the new value?
1781         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
1782 
1783         // What is their percentage (as a high precision int) of the total debt?
1784         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
1785 
1786         // And what effect does this percentage have on the global debt holding of other issuers?
1787         // The delta specifically needs to not take into account any existing debt as it's already
1788         // accounted for in the delta from when they issued previously.
1789         // The delta is a high precision integer.
1790         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
1791 
1792         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
1793 
1794         // And what does their debt ownership look like including this previous stake?
1795         if (existingDebt > 0) {
1796             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
1797         }
1798 
1799         // Are they a new issuer? If so, record them.
1800         if (issuanceData[account].initialDebtOwnership == 0) {
1801             totalIssuerCount = totalIssuerCount.add(1);
1802         }
1803 
1804         // Save the debt entry parameters
1805         issuanceData[account].initialDebtOwnership = debtPercentage;
1806         issuanceData[account].debtEntryIndex = debtLedger.length;
1807 
1808         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
1809         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
1810         if (debtLedger.length > 0) {
1811             debtLedger.push(
1812                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
1813             );
1814         } else {
1815             debtLedger.push(SafeDecimalMath.preciseUnit());
1816         }
1817     }
1818 
1819     /* ========== VIEWS ========== */
1820 
1821     /**
1822      * @notice Retrieve the length of the debt ledger array
1823      */
1824     function debtLedgerLength()
1825         external
1826         view
1827         returns (uint)
1828     {
1829         return debtLedger.length;
1830     }
1831 
1832     /**
1833      * @notice Retrieve the most recent entry from the debt ledger
1834      */
1835     function lastDebtLedgerEntry()
1836         external
1837         view
1838         returns (uint)
1839     {
1840         return debtLedger[debtLedger.length - 1];
1841     }
1842 
1843     /**
1844      * @notice Query whether an account has issued and has an outstanding debt balance
1845      * @param account The address to query for
1846      */
1847     function hasIssued(address account)
1848         external
1849         view
1850         returns (bool)
1851     {
1852         return issuanceData[account].initialDebtOwnership > 0;
1853     }
1854 
1855     event IssuanceRatioUpdated(uint newRatio);
1856 }
1857 
1858 
1859 /*
1860 -----------------------------------------------------------------
1861 FILE INFORMATION
1862 -----------------------------------------------------------------
1863 
1864 file:       ExchangeRates.sol
1865 version:    1.0
1866 author:     Kevin Brown
1867 date:       2018-09-12
1868 
1869 -----------------------------------------------------------------
1870 MODULE DESCRIPTION
1871 -----------------------------------------------------------------
1872 
1873 A contract that any other contract in the Synthetix system can query
1874 for the current market value of various assets, including
1875 crypto assets as well as various fiat assets.
1876 
1877 This contract assumes that rate updates will completely update
1878 all rates to their current values. If a rate shock happens
1879 on a single asset, the oracle will still push updated rates
1880 for all other assets.
1881 
1882 -----------------------------------------------------------------
1883 */
1884 
1885 
1886 /**
1887  * @title The repository for exchange rates
1888  */
1889 contract ExchangeRates is SelfDestructible {
1890 
1891     using SafeMath for uint;
1892 
1893     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
1894     mapping(bytes4 => uint) public rates;
1895 
1896     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
1897     mapping(bytes4 => uint) public lastRateUpdateTimes;
1898 
1899     // The address of the oracle which pushes rate updates to this contract
1900     address public oracle;
1901 
1902     // Do not allow the oracle to submit times any further forward into the future than this constant.
1903     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
1904 
1905     // How long will the contract assume the rate of any asset is correct
1906     uint public rateStalePeriod = 3 hours;
1907 
1908     // Each participating currency in the XDR basket is represented as a currency key with
1909     // equal weighting.
1910     // There are 5 participating currencies, so we'll declare that clearly.
1911     bytes4[5] public xdrParticipants;
1912 
1913     //
1914     // ========== CONSTRUCTOR ==========
1915 
1916     /**
1917      * @dev Constructor
1918      * @param _owner The owner of this contract.
1919      * @param _oracle The address which is able to update rate information.
1920      * @param _currencyKeys The initial currency keys to store (in order).
1921      * @param _newRates The initial currency amounts for each currency (in order).
1922      */
1923     constructor(
1924         // SelfDestructible (Ownable)
1925         address _owner,
1926 
1927         // Oracle values - Allows for rate updates
1928         address _oracle,
1929         bytes4[] _currencyKeys,
1930         uint[] _newRates
1931     )
1932         /* Owned is initialised in SelfDestructible */
1933         SelfDestructible(_owner)
1934         public
1935     {
1936         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
1937 
1938         oracle = _oracle;
1939 
1940         // The sUSD rate is always 1 and is never stale.
1941         rates["sUSD"] = SafeDecimalMath.unit();
1942         lastRateUpdateTimes["sUSD"] = now;
1943 
1944         // These are the currencies that make up the XDR basket.
1945         // These are hard coded because:
1946         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
1947         //  - Adding new currencies would likely introduce some kind of weighting factor, which
1948         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
1949         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
1950         //    then point the system at the new version.
1951         xdrParticipants = [
1952             bytes4("sUSD"),
1953             bytes4("sAUD"),
1954             bytes4("sCHF"),
1955             bytes4("sEUR"),
1956             bytes4("sGBP")
1957         ];
1958 
1959         internalUpdateRates(_currencyKeys, _newRates, now);
1960     }
1961 
1962     /* ========== SETTERS ========== */
1963 
1964     /**
1965      * @notice Set the rates stored in this contract
1966      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1967      * @param newRates The rates for each currency (in order)
1968      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1969      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1970      *                 if it takes a long time for the transaction to confirm.
1971      */
1972     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
1973         external
1974         onlyOracle
1975         returns(bool)
1976     {
1977         return internalUpdateRates(currencyKeys, newRates, timeSent);
1978     }
1979 
1980     /**
1981      * @notice Internal function which sets the rates stored in this contract
1982      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1983      * @param newRates The rates for each currency (in order)
1984      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1985      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1986      *                 if it takes a long time for the transaction to confirm.
1987      */
1988     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
1989         internal
1990         returns(bool)
1991     {
1992         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
1993         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
1994 
1995         // Loop through each key and perform update.
1996         for (uint i = 0; i < currencyKeys.length; i++) {
1997             // Should not set any rate to zero ever, as no asset will ever be
1998             // truely worthless and still valid. In this scenario, we should
1999             // delete the rate and remove it from the system.
2000             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
2001             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
2002 
2003             // We should only update the rate if it's at least the same age as the last rate we've got.
2004             if (timeSent >= lastRateUpdateTimes[currencyKeys[i]]) {
2005                 // Ok, go ahead with the update.
2006                 rates[currencyKeys[i]] = newRates[i];
2007                 lastRateUpdateTimes[currencyKeys[i]] = timeSent;
2008             }
2009         }
2010 
2011         emit RatesUpdated(currencyKeys, newRates);
2012 
2013         // Now update our XDR rate.
2014         updateXDRRate(timeSent);
2015 
2016         return true;
2017     }
2018 
2019     /**
2020      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
2021      */
2022     function updateXDRRate(uint timeSent)
2023         internal
2024     {
2025         uint total = 0;
2026 
2027         for (uint i = 0; i < xdrParticipants.length; i++) {
2028             total = rates[xdrParticipants[i]].add(total);
2029         }
2030 
2031         // Set the rate
2032         rates["XDR"] = total;
2033 
2034         // Record that we updated the XDR rate.
2035         lastRateUpdateTimes["XDR"] = timeSent;
2036 
2037         // Emit our updated event separate to the others to save
2038         // moving data around between arrays.
2039         bytes4[] memory eventCurrencyCode = new bytes4[](1);
2040         eventCurrencyCode[0] = "XDR";
2041 
2042         uint[] memory eventRate = new uint[](1);
2043         eventRate[0] = rates["XDR"];
2044 
2045         emit RatesUpdated(eventCurrencyCode, eventRate);
2046     }
2047 
2048     /**
2049      * @notice Delete a rate stored in the contract
2050      * @param currencyKey The currency key you wish to delete the rate for
2051      */
2052     function deleteRate(bytes4 currencyKey)
2053         external
2054         onlyOracle
2055     {
2056         require(rates[currencyKey] > 0, "Rate is zero");
2057 
2058         delete rates[currencyKey];
2059         delete lastRateUpdateTimes[currencyKey];
2060 
2061         emit RateDeleted(currencyKey);
2062     }
2063 
2064     /**
2065      * @notice Set the Oracle that pushes the rate information to this contract
2066      * @param _oracle The new oracle address
2067      */
2068     function setOracle(address _oracle)
2069         external
2070         onlyOwner
2071     {
2072         oracle = _oracle;
2073         emit OracleUpdated(oracle);
2074     }
2075 
2076     /**
2077      * @notice Set the stale period on the updated rate variables
2078      * @param _time The new rateStalePeriod
2079      */
2080     function setRateStalePeriod(uint _time)
2081         external
2082         onlyOwner
2083     {
2084         rateStalePeriod = _time;
2085         emit RateStalePeriodUpdated(rateStalePeriod);
2086     }
2087 
2088     /* ========== VIEWS ========== */
2089 
2090     /**
2091      * @notice Retrieve the rate for a specific currency
2092      */
2093     function rateForCurrency(bytes4 currencyKey)
2094         public
2095         view
2096         returns (uint)
2097     {
2098         return rates[currencyKey];
2099     }
2100 
2101     /**
2102      * @notice Retrieve the rates for a list of currencies
2103      */
2104     function ratesForCurrencies(bytes4[] currencyKeys)
2105         public
2106         view
2107         returns (uint[])
2108     {
2109         uint[] memory _rates = new uint[](currencyKeys.length);
2110 
2111         for (uint8 i = 0; i < currencyKeys.length; i++) {
2112             _rates[i] = rates[currencyKeys[i]];
2113         }
2114 
2115         return _rates;
2116     }
2117 
2118     /**
2119      * @notice Retrieve a list of last update times for specific currencies
2120      */
2121     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
2122         public
2123         view
2124         returns (uint)
2125     {
2126         return lastRateUpdateTimes[currencyKey];
2127     }
2128 
2129     /**
2130      * @notice Retrieve the last update time for a specific currency
2131      */
2132     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
2133         public
2134         view
2135         returns (uint[])
2136     {
2137         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
2138 
2139         for (uint8 i = 0; i < currencyKeys.length; i++) {
2140             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
2141         }
2142 
2143         return lastUpdateTimes;
2144     }
2145 
2146     /**
2147      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
2148      */
2149     function rateIsStale(bytes4 currencyKey)
2150         external
2151         view
2152         returns (bool)
2153     {
2154         // sUSD is a special case and is never stale.
2155         if (currencyKey == "sUSD") return false;
2156 
2157         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
2158     }
2159 
2160     /**
2161      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
2162      */
2163     function anyRateIsStale(bytes4[] currencyKeys)
2164         external
2165         view
2166         returns (bool)
2167     {
2168         // Loop through each key and check whether the data point is stale.
2169         uint256 i = 0;
2170 
2171         while (i < currencyKeys.length) {
2172             // sUSD is a special case and is never false
2173             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
2174                 return true;
2175             }
2176             i += 1;
2177         }
2178 
2179         return false;
2180     }
2181 
2182     /* ========== MODIFIERS ========== */
2183 
2184     modifier onlyOracle
2185     {
2186         require(msg.sender == oracle, "Only the oracle can perform this action");
2187         _;
2188     }
2189 
2190     /* ========== EVENTS ========== */
2191 
2192     event OracleUpdated(address newOracle);
2193     event RateStalePeriodUpdated(uint rateStalePeriod);
2194     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
2195     event RateDeleted(bytes4 currencyKey);
2196 }
2197 
2198 
2199 /*
2200 -----------------------------------------------------------------
2201 FILE INFORMATION
2202 -----------------------------------------------------------------
2203 
2204 file:       Synthetix.sol
2205 version:    2.0
2206 author:     Kevin Brown
2207             Gavin Conway
2208 date:       2018-09-14
2209 
2210 -----------------------------------------------------------------
2211 MODULE DESCRIPTION
2212 -----------------------------------------------------------------
2213 
2214 Synthetix token contract. SNX is a transferable ERC20 token,
2215 and also give its holders the following privileges.
2216 An owner of SNX has the right to issue synths in all synth flavours.
2217 
2218 After a fee period terminates, the duration and fees collected for that
2219 period are computed, and the next period begins. Thus an account may only
2220 withdraw the fees owed to them for the previous period, and may only do
2221 so once per period. Any unclaimed fees roll over into the common pot for
2222 the next period.
2223 
2224 == Average Balance Calculations ==
2225 
2226 The fee entitlement of a synthetix holder is proportional to their average
2227 issued synth balance over the last fee period. This is computed by
2228 measuring the area under the graph of a user's issued synth balance over
2229 time, and then when a new fee period begins, dividing through by the
2230 duration of the fee period.
2231 
2232 We need only update values when the balances of an account is modified.
2233 This occurs when issuing or burning for issued synth balances,
2234 and when transferring for synthetix balances. This is for efficiency,
2235 and adds an implicit friction to interacting with SNX.
2236 A synthetix holder pays for his own recomputation whenever he wants to change
2237 his position, which saves the foundation having to maintain a pot dedicated
2238 to resourcing this.
2239 
2240 A hypothetical user's balance history over one fee period, pictorially:
2241 
2242       s ____
2243        |    |
2244        |    |___ p
2245        |____|___|___ __ _  _
2246        f    t   n
2247 
2248 Here, the balance was s between times f and t, at which time a transfer
2249 occurred, updating the balance to p, until n, when the present transfer occurs.
2250 When a new transfer occurs at time n, the balance being p,
2251 we must:
2252 
2253   - Add the area p * (n - t) to the total area recorded so far
2254   - Update the last transfer time to n
2255 
2256 So if this graph represents the entire current fee period,
2257 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
2258 The complementary computations must be performed for both sender and
2259 recipient.
2260 
2261 Note that a transfer keeps global supply of SNX invariant.
2262 The sum of all balances is constant, and unmodified by any transfer.
2263 So the sum of all balances multiplied by the duration of a fee period is also
2264 constant, and this is equivalent to the sum of the area of every user's
2265 time/balance graph. Dividing through by that duration yields back the total
2266 synthetix supply. So, at the end of a fee period, we really do yield a user's
2267 average share in the synthetix supply over that period.
2268 
2269 A slight wrinkle is introduced if we consider the time r when the fee period
2270 rolls over. Then the previous fee period k-1 is before r, and the current fee
2271 period k is afterwards. If the last transfer took place before r,
2272 but the latest transfer occurred afterwards:
2273 
2274 k-1       |        k
2275       s __|_
2276        |  | |
2277        |  | |____ p
2278        |__|_|____|___ __ _  _
2279           |
2280        f  | t    n
2281           r
2282 
2283 In this situation the area (r-f)*s contributes to fee period k-1, while
2284 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2285 zero-value transfer to have occurred at time r. Their fee entitlement for the
2286 previous period will be finalised at the time of their first transfer during the
2287 current fee period, or when they query or withdraw their fee entitlement.
2288 
2289 In the implementation, the duration of different fee periods may be slightly irregular,
2290 as the check that they have rolled over occurs only when state-changing synthetix
2291 operations are performed.
2292 
2293 == Issuance and Burning ==
2294 
2295 In this version of the synthetix contract, synths can only be issued by
2296 those that have been nominated by the synthetix foundation. Synths are assumed
2297 to be valued at $1, as they are a stable unit of account.
2298 
2299 All synths issued require a proportional value of SNX to be locked,
2300 where the proportion is governed by the current issuance ratio. This
2301 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
2302 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
2303 
2304 To determine the value of some amount of SNX(S), an oracle is used to push
2305 the price of SNX (P_S) in dollars to the contract. The value of S
2306 would then be: S * P_S.
2307 
2308 Any SNX that are locked up by this issuance process cannot be transferred.
2309 The amount that is locked floats based on the price of SNX. If the price
2310 of SNX moves up, less SNX are locked, so they can be issued against,
2311 or transferred freely. If the price of SNX moves down, more SNX are locked,
2312 even going above the initial wallet balance.
2313 
2314 -----------------------------------------------------------------
2315 */
2316 
2317 
2318 /**
2319  * @title Synthetix ERC20 contract.
2320  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2321  * but it also computes the quantity of fees each synthetix holder is entitled to.
2322  */
2323 contract Synthetix is ExternStateToken {
2324 
2325     // ========== STATE VARIABLES ==========
2326 
2327     // Available Synths which can be used with the system
2328     Synth[] public availableSynths;
2329     mapping(bytes4 => Synth) public synths;
2330 
2331     FeePool public feePool;
2332     SynthetixEscrow public escrow;
2333     ExchangeRates public exchangeRates;
2334     SynthetixState public synthetixState;
2335 
2336     uint constant SYNTHETIX_SUPPLY = 1e8 * SafeDecimalMath.unit();
2337     string constant TOKEN_NAME = "Synthetix Network Token";
2338     string constant TOKEN_SYMBOL = "SNX";
2339     uint8 constant DECIMALS = 18;
2340 
2341     // ========== CONSTRUCTOR ==========
2342 
2343     /**
2344      * @dev Constructor
2345      * @param _tokenState A pre-populated contract containing token balances.
2346      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2347      * @param _owner The owner of this contract.
2348      */
2349     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2350         address _owner, ExchangeRates _exchangeRates, FeePool _feePool
2351     )
2352         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, SYNTHETIX_SUPPLY, DECIMALS, _owner)
2353         public
2354     {
2355         synthetixState = _synthetixState;
2356         exchangeRates = _exchangeRates;
2357         feePool = _feePool;
2358     }
2359 
2360     // ========== SETTERS ========== */
2361 
2362     /**
2363      * @notice Add an associated Synth contract to the Synthetix system
2364      * @dev Only the contract owner may call this.
2365      */
2366     function addSynth(Synth synth)
2367         external
2368         optionalProxy_onlyOwner
2369     {
2370         bytes4 currencyKey = synth.currencyKey();
2371 
2372         require(synths[currencyKey] == Synth(0), "Synth already exists");
2373 
2374         availableSynths.push(synth);
2375         synths[currencyKey] = synth;
2376 
2377         emitSynthAdded(currencyKey, synth);
2378     }
2379 
2380     /**
2381      * @notice Remove an associated Synth contract from the Synthetix system
2382      * @dev Only the contract owner may call this.
2383      */
2384     function removeSynth(bytes4 currencyKey)
2385         external
2386         optionalProxy_onlyOwner
2387     {
2388         require(synths[currencyKey] != address(0), "Synth does not exist");
2389         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2390         require(currencyKey != "XDR", "Cannot remove XDR synth");
2391 
2392         // Save the address we're removing for emitting the event at the end.
2393         address synthToRemove = synths[currencyKey];
2394 
2395         // Remove the synth from the availableSynths array.
2396         for (uint8 i = 0; i < availableSynths.length; i++) {
2397             if (availableSynths[i] == synthToRemove) {
2398                 delete availableSynths[i];
2399 
2400                 // Copy the last synth into the place of the one we just deleted
2401                 // If there's only one synth, this is synths[0] = synths[0].
2402                 // If we're deleting the last one, it's also a NOOP in the same way.
2403                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2404 
2405                 // Decrease the size of the array by one.
2406                 availableSynths.length--;
2407 
2408                 break;
2409             }
2410         }
2411 
2412         // And remove it from the synths mapping
2413         delete synths[currencyKey];
2414 
2415         emitSynthRemoved(currencyKey, synthToRemove);
2416     }
2417 
2418     /**
2419      * @notice Set the associated synthetix escrow contract.
2420      * @dev Only the contract owner may call this.
2421      */
2422     function setEscrow(SynthetixEscrow _escrow)
2423         external
2424         optionalProxy_onlyOwner
2425     {
2426         escrow = _escrow;
2427         // Note: No event here as our contract exceeds max contract size
2428         // with these events, and it's unlikely people will need to
2429         // track these events specifically.
2430     }
2431 
2432     /**
2433      * @notice Set the ExchangeRates contract address where rates are held.
2434      * @dev Only callable by the contract owner.
2435      */
2436     function setExchangeRates(ExchangeRates _exchangeRates)
2437         external
2438         optionalProxy_onlyOwner
2439     {
2440         exchangeRates = _exchangeRates;
2441         // Note: No event here as our contract exceeds max contract size
2442         // with these events, and it's unlikely people will need to
2443         // track these events specifically.
2444     }
2445 
2446     /**
2447      * @notice Set the synthetixState contract address where issuance data is held.
2448      * @dev Only callable by the contract owner.
2449      */
2450     function setSynthetixState(SynthetixState _synthetixState)
2451         external
2452         optionalProxy_onlyOwner
2453     {
2454         synthetixState = _synthetixState;
2455 
2456         emitStateContractChanged(_synthetixState);
2457     }
2458 
2459     /**
2460      * @notice Set your preferred currency. Note: This does not automatically exchange any balances you've held previously in
2461      * other synth currencies in this address, it will apply for any new payments you receive at this address.
2462      */
2463     function setPreferredCurrency(bytes4 currencyKey)
2464         external
2465         optionalProxy
2466     {
2467         require(currencyKey == 0 || !exchangeRates.rateIsStale(currencyKey), "Currency rate is stale or doesn't exist.");
2468 
2469         synthetixState.setPreferredCurrency(messageSender, currencyKey);
2470 
2471         emitPreferredCurrencyChanged(messageSender, currencyKey);
2472     }
2473 
2474     // ========== VIEWS ==========
2475 
2476     /**
2477      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2478      * @param sourceCurrencyKey The currency the amount is specified in
2479      * @param sourceAmount The source amount, specified in UNIT base
2480      * @param destinationCurrencyKey The destination currency
2481      */
2482     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
2483         public
2484         view
2485         rateNotStale(sourceCurrencyKey)
2486         rateNotStale(destinationCurrencyKey)
2487         returns (uint)
2488     {
2489         // If there's no change in the currency, then just return the amount they gave us
2490         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
2491 
2492         // Calculate the effective value by going from source -> USD -> destination
2493         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
2494             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
2495     }
2496 
2497     /**
2498      * @notice Total amount of synths issued by the system, priced in currencyKey
2499      * @param currencyKey The currency to value the synths in
2500      */
2501     function totalIssuedSynths(bytes4 currencyKey)
2502         public
2503         view
2504         rateNotStale(currencyKey)
2505         returns (uint)
2506     {
2507         uint total = 0;
2508         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2509 
2510         for (uint8 i = 0; i < availableSynths.length; i++) {
2511             // Ensure the rate isn't stale.
2512             // TODO: Investigate gas cost optimisation of doing a single call with all keys in it vs
2513             // individual calls like this.
2514             require(!exchangeRates.rateIsStale(availableSynths[i].currencyKey()), "Rate is stale");
2515 
2516             // What's the total issued value of that synth in the destination currency?
2517             // Note: We're not using our effectiveValue function because we don't want to go get the
2518             //       rate for the destination currency and check if it's stale repeatedly on every
2519             //       iteration of the loop
2520             uint synthValue = availableSynths[i].totalSupply()
2521                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
2522                 .divideDecimalRound(currencyRate);
2523             total = total.add(synthValue);
2524         }
2525 
2526         return total;
2527     }
2528 
2529     /**
2530      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
2531      */
2532     function availableSynthCount()
2533         public
2534         view
2535         returns (uint)
2536     {
2537         return availableSynths.length;
2538     }
2539 
2540     // ========== MUTATIVE FUNCTIONS ==========
2541 
2542     /**
2543      * @notice ERC20 transfer function.
2544      */
2545     function transfer(address to, uint value)
2546         public
2547         returns (bool)
2548     {
2549         bytes memory empty;
2550         return transfer(to, value, empty);
2551     }
2552 
2553     /**
2554      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
2555      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2556      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2557      *           tooling such as Etherscan.
2558      */
2559     function transfer(address to, uint value, bytes data)
2560         public
2561         optionalProxy
2562         returns (bool)
2563     {
2564         // Ensure they're not trying to exceed their locked amount
2565         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
2566 
2567         // Perform the transfer: if there is a problem an exception will be thrown in this call.
2568         _transfer_byProxy(messageSender, to, value, data);
2569 
2570         return true;
2571     }
2572 
2573     /**
2574      * @notice ERC20 transferFrom function.
2575      */
2576     function transferFrom(address from, address to, uint value)
2577         public
2578         returns (bool)
2579     {
2580         bytes memory empty;
2581         return transferFrom(from, to, value, empty);
2582     }
2583 
2584     /**
2585      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
2586      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2587      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2588      *           tooling such as Etherscan.
2589      */
2590     function transferFrom(address from, address to, uint value, bytes data)
2591         public
2592         optionalProxy
2593         returns (bool)
2594     {
2595         // Ensure they're not trying to exceed their locked amount
2596         require(value <= transferableSynthetix(from), "Insufficient balance");
2597 
2598         // Perform the transfer: if there is a problem,
2599         // an exception will be thrown in this call.
2600         _transferFrom_byProxy(messageSender, from, to, value, data);
2601 
2602         return true;
2603     }
2604 
2605     /**
2606      * @notice Function that allows you to exchange synths you hold in one flavour for another.
2607      * @param sourceCurrencyKey The source currency you wish to exchange from
2608      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2609      * @param destinationCurrencyKey The destination currency you wish to obtain.
2610      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
2611      * @return Boolean that indicates whether the transfer succeeded or failed.
2612      */
2613     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
2614         external
2615         optionalProxy
2616         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
2617         returns (bool)
2618     {
2619         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
2620         require(sourceAmount > 0, "Zero amount");
2621 
2622         // Pass it along, defaulting to the sender as the recipient.
2623         return _internalExchange(
2624             messageSender,
2625             sourceCurrencyKey,
2626             sourceAmount,
2627             destinationCurrencyKey,
2628             destinationAddress == address(0) ? messageSender : destinationAddress,
2629             true // Charge fee on the exchange
2630         );
2631     }
2632 
2633     /**
2634      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
2635      * @dev Only the synth contract can call this function
2636      * @param from The address to exchange / burn synth from
2637      * @param sourceCurrencyKey The source currency you wish to exchange from
2638      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2639      * @param destinationCurrencyKey The destination currency you wish to obtain.
2640      * @param destinationAddress Where the result should go.
2641      * @return Boolean that indicates whether the transfer succeeded or failed.
2642      */
2643     function synthInitiatedExchange(
2644         address from,
2645         bytes4 sourceCurrencyKey,
2646         uint sourceAmount,
2647         bytes4 destinationCurrencyKey,
2648         address destinationAddress
2649     )
2650         external
2651         onlySynth
2652         returns (bool)
2653     {
2654         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
2655         require(sourceAmount > 0, "Zero amount");
2656 
2657         // Pass it along
2658         return _internalExchange(
2659             from,
2660             sourceCurrencyKey,
2661             sourceAmount,
2662             destinationCurrencyKey,
2663             destinationAddress,
2664             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
2665         );
2666     }
2667 
2668     /**
2669      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
2670      * @dev Only the synth contract can call this function.
2671      * @param from The address fee is coming from.
2672      * @param sourceCurrencyKey source currency fee from.
2673      * @param sourceAmount The amount, specified in UNIT of source currency.
2674      * @return Boolean that indicates whether the transfer succeeded or failed.
2675      */
2676     function synthInitiatedFeePayment(
2677         address from,
2678         bytes4 sourceCurrencyKey,
2679         uint sourceAmount
2680     )
2681         external
2682         onlySynth
2683         returns (bool)
2684     {
2685         require(sourceAmount > 0, "Source can't be 0");
2686 
2687         // Pass it along, defaulting to the sender as the recipient.
2688         bool result = _internalExchange(
2689             from,
2690             sourceCurrencyKey,
2691             sourceAmount,
2692             "XDR",
2693             feePool.FEE_ADDRESS(),
2694             false // Don't charge a fee on the exchange because this is already a fee
2695         );
2696 
2697         // Tell the fee pool about this.
2698         feePool.feePaid(sourceCurrencyKey, sourceAmount);
2699 
2700         return result;
2701     }
2702 
2703     /**
2704      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
2705      * @dev fee pool contract address is not allowed to call function
2706      * @param from The address to move synth from
2707      * @param sourceCurrencyKey source currency from.
2708      * @param sourceAmount The amount, specified in UNIT of source currency.
2709      * @param destinationCurrencyKey The destination currency to obtain.
2710      * @param destinationAddress Where the result should go.
2711      * @param chargeFee Boolean to charge a fee for transaction.
2712      * @return Boolean that indicates whether the transfer succeeded or failed.
2713      */
2714     function _internalExchange(
2715         address from,
2716         bytes4 sourceCurrencyKey,
2717         uint sourceAmount,
2718         bytes4 destinationCurrencyKey,
2719         address destinationAddress,
2720         bool chargeFee
2721     )
2722         internal
2723         notFeeAddress(from)
2724         returns (bool)
2725     {
2726         require(destinationAddress != address(0), "Zero destination");
2727         require(destinationAddress != address(this), "Synthetix is invalid destination");
2728         require(destinationAddress != address(proxy), "Proxy is invalid destination");
2729 
2730         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
2731         // the subtraction to not overflow, which would happen if their balance is not sufficient.
2732 
2733         // Burn the source amount
2734         synths[sourceCurrencyKey].burn(from, sourceAmount);
2735 
2736         // How much should they get in the destination currency?
2737         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
2738 
2739         // What's the fee on that currency that we should deduct?
2740         uint amountReceived = destinationAmount;
2741         uint fee = 0;
2742 
2743         if (chargeFee) {
2744             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
2745             fee = destinationAmount.sub(amountReceived);
2746         }
2747 
2748         // Issue their new synths
2749         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
2750 
2751         // Remit the fee in XDRs
2752         if (fee > 0) {
2753             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
2754             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
2755         }
2756 
2757         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
2758 
2759         // Call the ERC223 transfer callback if needed
2760         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
2761 
2762         // Gas optimisation:
2763         // No event emitted as it's assumed users will be able to track transfers to the zero address, followed
2764         // by a transfer on another synth from the zero address and ascertain the info required here.
2765 
2766         return true;
2767     }
2768 
2769     /**
2770      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
2771      * @dev Only internal calls from synthetix address.
2772      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
2773      * @param amount The amount of synths to register with a base of UNIT
2774      */
2775     function _addToDebtRegister(bytes4 currencyKey, uint amount)
2776         internal
2777         optionalProxy
2778     {
2779         // What is the value of the requested debt in XDRs?
2780         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
2781 
2782         // What is the value of all issued synths of the system (priced in XDRs)?
2783         uint totalDebtIssued = totalIssuedSynths("XDR");
2784 
2785         // What will the new total be including the new value?
2786         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2787 
2788         // What is their percentage (as a high precision int) of the total debt?
2789         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2790 
2791         // And what effect does this percentage have on the global debt holding of other issuers?
2792         // The delta specifically needs to not take into account any existing debt as it's already
2793         // accounted for in the delta from when they issued previously.
2794         // The delta is a high precision integer.
2795         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2796 
2797         // How much existing debt do they have?
2798         uint existingDebt = debtBalanceOf(messageSender, "XDR");
2799 
2800         // And what does their debt ownership look like including this previous stake?
2801         if (existingDebt > 0) {
2802             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2803         }
2804 
2805         // Are they a new issuer? If so, record them.
2806         if (!synthetixState.hasIssued(messageSender)) {
2807             synthetixState.incrementTotalIssuerCount();
2808         }
2809 
2810         // Save the debt entry parameters
2811         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
2812 
2813         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2814         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2815         if (synthetixState.debtLedgerLength() > 0) {
2816             synthetixState.appendDebtLedgerValue(
2817                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
2818             );
2819         } else {
2820             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
2821         }
2822     }
2823 
2824     /**
2825      * @notice Issue synths against the sender's SNX.
2826      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
2827      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
2828      * @param amount The amount of synths you wish to issue with a base of UNIT
2829      */
2830     function issueSynths(bytes4 currencyKey, uint amount)
2831         public
2832         optionalProxy
2833         nonZeroAmount(amount)
2834         // No need to check if price is stale, as it is checked in issuableSynths.
2835     {
2836         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
2837 
2838         // Keep track of the debt they're about to create
2839         _addToDebtRegister(currencyKey, amount);
2840 
2841         // Create their synths
2842         synths[currencyKey].issue(messageSender, amount);
2843     }
2844 
2845     /**
2846      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
2847      * @dev Issuance is only allowed if the synthetix price isn't stale.
2848      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
2849      */
2850     function issueMaxSynths(bytes4 currencyKey)
2851         external
2852         optionalProxy
2853     {
2854         // Figure out the maximum we can issue in that currency
2855         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
2856 
2857         // And issue them
2858         issueSynths(currencyKey, maxIssuable);
2859     }
2860 
2861     /**
2862      * @notice Burn synths to clear issued synths/free SNX.
2863      * @param currencyKey The currency you're specifying to burn
2864      * @param amount The amount (in UNIT base) you wish to burn
2865      */
2866     function burnSynths(bytes4 currencyKey, uint amount)
2867         external
2868         optionalProxy
2869         // No need to check for stale rates as _removeFromDebtRegister calls effectiveValue
2870         // which does this for us
2871     {
2872         // How much debt do they have?
2873         uint debt = debtBalanceOf(messageSender, currencyKey);
2874 
2875         require(debt > 0, "No debt to forgive");
2876 
2877         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
2878         // clear their debt and leave them be.
2879         uint amountToBurn = debt < amount ? debt : amount;
2880 
2881         // Remove their debt from the ledger
2882         _removeFromDebtRegister(currencyKey, amountToBurn);
2883 
2884         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
2885         synths[currencyKey].burn(messageSender, amountToBurn);
2886     }
2887 
2888     /**
2889      * @notice Remove a debt position from the register
2890      * @param currencyKey The currency the user is presenting to forgive their debt
2891      * @param amount The amount (in UNIT base) being presented
2892      */
2893     function _removeFromDebtRegister(bytes4 currencyKey, uint amount)
2894         internal
2895     {
2896         // How much debt are they trying to remove in XDRs?
2897         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
2898 
2899         // How much debt do they have?
2900         uint existingDebt = debtBalanceOf(messageSender, "XDR");
2901 
2902         // What percentage of the total debt are they trying to remove?
2903         uint totalDebtIssued = totalIssuedSynths("XDR");
2904         uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(totalDebtIssued);
2905 
2906         // And what effect does this percentage have on the global debt holding of other issuers?
2907         // The delta specifically needs to not take into account any existing debt as it's already
2908         // accounted for in the delta from when they issued previously.
2909         uint delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
2910 
2911         // Are they exiting the system, or are they just decreasing their debt position?
2912         if (debtToRemove == existingDebt) {
2913             synthetixState.clearIssuanceData(messageSender);
2914             synthetixState.decrementTotalIssuerCount();
2915         } else {
2916             // What percentage of the debt will they be left with?
2917             uint newDebt = existingDebt.sub(debtToRemove);
2918             uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
2919             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
2920 
2921             // Store the debt percentage and debt ledger as high precision integers
2922             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
2923         }
2924 
2925         // Update our cumulative ledger. This is also a high precision integer.
2926         synthetixState.appendDebtLedgerValue(
2927             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
2928         );
2929     }
2930 
2931     // ========== Issuance/Burning ==========
2932 
2933     /**
2934      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
2935      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
2936      */
2937     function maxIssuableSynths(address issuer, bytes4 currencyKey)
2938         public
2939         view
2940         // We don't need to check stale rates here as effectiveValue will do it for us.
2941         returns (uint)
2942     {
2943         // What is the value of their SNX balance in the destination currency?
2944         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
2945 
2946         // They're allowed to issue up to issuanceRatio of that value
2947         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
2948     }
2949 
2950     /**
2951      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
2952      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
2953      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
2954      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
2955      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
2956      * altering the amount of fees they're able to claim from the system.
2957      */
2958     function collateralisationRatio(address issuer)
2959         public
2960         view
2961         returns (uint)
2962     {
2963         uint totalOwnedSynthetix = collateral(issuer);
2964         if (totalOwnedSynthetix == 0) return 0;
2965 
2966         uint debtBalance = debtBalanceOf(issuer, "SNX");
2967         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
2968     }
2969 
2970 /**
2971      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
2972      * will tell you how many synths a user has to give back to the system in order to unlock their original
2973      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
2974      * the debt in sUSD, XDR, or any other synth you wish.
2975      */
2976     function debtBalanceOf(address issuer, bytes4 currencyKey)
2977         public
2978         view
2979         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
2980         returns (uint)
2981     {
2982         // What was their initial debt ownership?
2983         uint initialDebtOwnership;
2984         uint debtEntryIndex;
2985         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
2986 
2987         // If it's zero, they haven't issued, and they have no debt.
2988         if (initialDebtOwnership == 0) return 0;
2989 
2990         // Figure out the global debt percentage delta from when they entered the system.
2991         // This is a high precision integer.
2992         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
2993             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
2994             .multiplyDecimalRoundPrecise(initialDebtOwnership);
2995 
2996         // What's the total value of the system in their requested currency?
2997         uint totalSystemValue = totalIssuedSynths(currencyKey);
2998 
2999         // Their debt balance is their portion of the total system value.
3000         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3001             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3002 
3003         return highPrecisionBalance.preciseDecimalToDecimal();
3004     }
3005 
3006     /**
3007      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3008      * @param issuer The account that intends to issue
3009      * @param currencyKey The currency to price issuable value in
3010      */
3011     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
3012         public
3013         view
3014         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3015         returns (uint)
3016     {
3017         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3018         uint max = maxIssuableSynths(issuer, currencyKey);
3019 
3020         if (alreadyIssued >= max) {
3021             return 0;
3022         } else {
3023             return max.sub(alreadyIssued);
3024         }
3025     }
3026 
3027     /**
3028      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3029      * against which synths can be issued.
3030      * This includes those already being used as collateral (locked), and those
3031      * available for further issuance (unlocked).
3032      */
3033     function collateral(address account)
3034         public
3035         view
3036         returns (uint)
3037     {
3038         uint balance = tokenState.balanceOf(account);
3039 
3040         if (escrow != address(0)) {
3041             balance = balance.add(escrow.balanceOf(account));
3042         }
3043 
3044         return balance;
3045     }
3046 
3047     /**
3048      * @notice The number of SNX that are free to be transferred by an account.
3049      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
3050      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
3051      * in this calculation.
3052      */
3053     function transferableSynthetix(address account)
3054         public
3055         view
3056         rateNotStale("SNX")
3057         returns (uint)
3058     {
3059         // How many SNX do they have, excluding escrow?
3060         // Note: We're excluding escrow here because we're interested in their transferable amount
3061         // and escrowed SNX are not transferable.
3062         uint balance = tokenState.balanceOf(account);
3063 
3064         // How many of those will be locked by the amount they've issued?
3065         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3066         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3067         // The locked synthetix value can exceed their balance.
3068         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3069 
3070         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3071         if (lockedSynthetixValue >= balance) {
3072             return 0;
3073         } else {
3074             return balance.sub(lockedSynthetixValue);
3075         }
3076     }
3077 
3078     // ========== MODIFIERS ==========
3079 
3080     modifier rateNotStale(bytes4 currencyKey) {
3081         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
3082         _;
3083     }
3084 
3085     modifier notFeeAddress(address account) {
3086         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3087         _;
3088     }
3089 
3090     modifier onlySynth() {
3091         bool isSynth = false;
3092 
3093         // No need to repeatedly call this function either
3094         for (uint8 i = 0; i < availableSynths.length; i++) {
3095             if (availableSynths[i] == msg.sender) {
3096                 isSynth = true;
3097                 break;
3098             }
3099         }
3100 
3101         require(isSynth, "Only synth allowed");
3102         _;
3103     }
3104 
3105     modifier nonZeroAmount(uint _amount) {
3106         require(_amount > 0, "Amount needs to be larger than 0");
3107         _;
3108     }
3109 
3110     // ========== EVENTS ==========
3111 
3112     event PreferredCurrencyChanged(address indexed account, bytes4 newPreferredCurrency);
3113     bytes32 constant PREFERREDCURRENCYCHANGED_SIG = keccak256("PreferredCurrencyChanged(address,bytes4)");
3114     function emitPreferredCurrencyChanged(address account, bytes4 newPreferredCurrency) internal {
3115         proxy._emit(abi.encode(newPreferredCurrency), 2, PREFERREDCURRENCYCHANGED_SIG, bytes32(account), 0, 0);
3116     }
3117 
3118     event StateContractChanged(address stateContract);
3119     bytes32 constant STATECONTRACTCHANGED_SIG = keccak256("StateContractChanged(address)");
3120     function emitStateContractChanged(address stateContract) internal {
3121         proxy._emit(abi.encode(stateContract), 1, STATECONTRACTCHANGED_SIG, 0, 0, 0);
3122     }
3123 
3124     event SynthAdded(bytes4 currencyKey, address newSynth);
3125     bytes32 constant SYNTHADDED_SIG = keccak256("SynthAdded(bytes4,address)");
3126     function emitSynthAdded(bytes4 currencyKey, address newSynth) internal {
3127         proxy._emit(abi.encode(currencyKey, newSynth), 1, SYNTHADDED_SIG, 0, 0, 0);
3128     }
3129 
3130     event SynthRemoved(bytes4 currencyKey, address removedSynth);
3131     bytes32 constant SYNTHREMOVED_SIG = keccak256("SynthRemoved(bytes4,address)");
3132     function emitSynthRemoved(bytes4 currencyKey, address removedSynth) internal {
3133         proxy._emit(abi.encode(currencyKey, removedSynth), 1, SYNTHREMOVED_SIG, 0, 0, 0);
3134     }
3135 }
3136 
3137 
3138 /*
3139 -----------------------------------------------------------------
3140 FILE INFORMATION
3141 -----------------------------------------------------------------
3142 
3143 file:       FeePool.sol
3144 version:    1.0
3145 author:     Kevin Brown
3146 date:       2018-10-15
3147 
3148 -----------------------------------------------------------------
3149 MODULE DESCRIPTION
3150 -----------------------------------------------------------------
3151 
3152 The FeePool is a place for users to interact with the fees that
3153 have been generated from the Synthetix system if they've helped
3154 to create the economy.
3155 
3156 Users stake Synthetix to create Synths. As Synth users transact,
3157 a small fee is deducted from each transaction, which collects
3158 in the fee pool. Fees are immediately converted to XDRs, a type
3159 of reserve currency similar to SDRs used by the IMF:
3160 https://www.imf.org/en/About/Factsheets/Sheets/2016/08/01/14/51/Special-Drawing-Right-SDR
3161 
3162 Users are entitled to withdraw fees from periods that they participated
3163 in fully, e.g. they have to stake before the period starts. They
3164 can withdraw fees for the last 6 periods as a single lump sum.
3165 Currently fee periods are 7 days long, meaning it's assumed
3166 users will withdraw their fees approximately once a month. Fees
3167 which are not withdrawn are redistributed to the whole pool,
3168 enabling these non-claimed fees to go back to the rest of the commmunity.
3169 
3170 Fees can be withdrawn in any synth currency.
3171 
3172 -----------------------------------------------------------------
3173 */
3174 
3175 
3176 contract FeePool is Proxyable, SelfDestructible {
3177 
3178     using SafeMath for uint;
3179     using SafeDecimalMath for uint;
3180 
3181     Synthetix public synthetix;
3182 
3183     // A percentage fee charged on each transfer.
3184     uint public transferFeeRate;
3185 
3186     // Transfer fee may not exceed 10%.
3187     uint constant public MAX_TRANSFER_FEE_RATE = SafeDecimalMath.unit() / 10;
3188 
3189     // A percentage fee charged on each exchange between currencies.
3190     uint public exchangeFeeRate;
3191 
3192     // Exchange fee may not exceed 10%.
3193     uint constant public MAX_EXCHANGE_FEE_RATE = SafeDecimalMath.unit() / 10;
3194 
3195     // The address with the authority to distribute fees.
3196     address public feeAuthority;
3197 
3198     // Where fees are pooled in XDRs.
3199     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
3200 
3201     // This struct represents the issuance activity that's happened in a fee period.
3202     struct FeePeriod {
3203         uint feePeriodId;
3204         uint startingDebtIndex;
3205         uint startTime;
3206         uint feesToDistribute;
3207         uint feesClaimed;
3208     }
3209 
3210     // The last 6 fee periods are all that you can claim from.
3211     // These are stored and managed from [0], such that [0] is always
3212     // the most recent fee period, and [5] is always the oldest fee
3213     // period that users can claim for.
3214     uint8 constant public FEE_PERIOD_LENGTH = 6;
3215     FeePeriod[FEE_PERIOD_LENGTH] public recentFeePeriods;
3216 
3217     // The next fee period will have this ID.
3218     uint public nextFeePeriodId;
3219 
3220     // How long a fee period lasts at a minimum. It is required for the
3221     // fee authority to roll over the periods, so they are not guaranteed
3222     // to roll over at exactly this duration, but the contract enforces
3223     // that they cannot roll over any quicker than this duration.
3224     uint public feePeriodDuration = 1 weeks;
3225 
3226     // The fee period must be between 1 day and 60 days.
3227     uint public constant MIN_FEE_PERIOD_DURATION = 1 days;
3228     uint public constant MAX_FEE_PERIOD_DURATION = 60 days;
3229 
3230     // The last period a user has withdrawn their fees in, identified by the feePeriodId
3231     mapping(address => uint) public lastFeeWithdrawal;
3232 
3233     // Users receive penalties if their collateralisation ratio drifts out of our desired brackets
3234     // We precompute the brackets and penalties to save gas.
3235     uint constant TWENTY_PERCENT = (20 * SafeDecimalMath.unit()) / 100;
3236     uint constant TWENTY_FIVE_PERCENT = (25 * SafeDecimalMath.unit()) / 100;
3237     uint constant THIRTY_PERCENT = (30 * SafeDecimalMath.unit()) / 100;
3238     uint constant FOURTY_PERCENT = (40 * SafeDecimalMath.unit()) / 100;
3239     uint constant FIFTY_PERCENT = (50 * SafeDecimalMath.unit()) / 100;
3240     uint constant SEVENTY_FIVE_PERCENT = (75 * SafeDecimalMath.unit()) / 100;
3241 
3242     constructor(address _proxy, address _owner, Synthetix _synthetix, address _feeAuthority, uint _transferFeeRate, uint _exchangeFeeRate)
3243         SelfDestructible(_owner)
3244         Proxyable(_proxy, _owner)
3245         public
3246     {
3247         // Constructed fee rates should respect the maximum fee rates.
3248         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
3249         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Constructed exchange fee rate should respect the maximum fee rate");
3250 
3251         synthetix = _synthetix;
3252         feeAuthority = _feeAuthority;
3253         transferFeeRate = _transferFeeRate;
3254         exchangeFeeRate = _exchangeFeeRate;
3255 
3256         // Set our initial fee period
3257         recentFeePeriods[0].feePeriodId = 1;
3258         recentFeePeriods[0].startTime = now;
3259         // Gas optimisation: These do not need to be initialised. They start at 0.
3260         // recentFeePeriods[0].startingDebtIndex = 0;
3261         // recentFeePeriods[0].feesToDistribute = 0;
3262 
3263         // And the next one starts at 2.
3264         nextFeePeriodId = 2;
3265     }
3266 
3267     /**
3268      * @notice Set the exchange fee, anywhere within the range 0-10%.
3269      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
3270      */
3271     function setExchangeFeeRate(uint _exchangeFeeRate)
3272         external
3273         optionalProxy_onlyOwner
3274     {
3275         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Exchange fee rate must be below MAX_EXCHANGE_FEE_RATE");
3276 
3277         exchangeFeeRate = _exchangeFeeRate;
3278 
3279         emitExchangeFeeUpdated(_exchangeFeeRate);
3280     }
3281 
3282     /**
3283      * @notice Set the transfer fee, anywhere within the range 0-10%.
3284      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
3285      */
3286     function setTransferFeeRate(uint _transferFeeRate)
3287         external
3288         optionalProxy_onlyOwner
3289     {
3290         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
3291 
3292         transferFeeRate = _transferFeeRate;
3293 
3294         emitTransferFeeUpdated(_transferFeeRate);
3295     }
3296 
3297     /**
3298      * @notice Set the address of the user/contract responsible for collecting or
3299      * distributing fees.
3300      */
3301     function setFeeAuthority(address _feeAuthority)
3302         external
3303         optionalProxy_onlyOwner
3304     {
3305         feeAuthority = _feeAuthority;
3306 
3307         emitFeeAuthorityUpdated(_feeAuthority);
3308     }
3309 
3310     /**
3311      * @notice Set the fee period duration
3312      */
3313     function setFeePeriodDuration(uint _feePeriodDuration)
3314         external
3315         optionalProxy_onlyOwner
3316     {
3317         require(_feePeriodDuration >= MIN_FEE_PERIOD_DURATION, "New fee period cannot be less than minimum fee period duration");
3318         require(_feePeriodDuration <= MAX_FEE_PERIOD_DURATION, "New fee period cannot be greater than maximum fee period duration");
3319 
3320         feePeriodDuration = _feePeriodDuration;
3321 
3322         emitFeePeriodDurationUpdated(_feePeriodDuration);
3323     }
3324 
3325     /**
3326      * @notice Set the synthetix contract
3327      */
3328     function setSynthetix(Synthetix _synthetix)
3329         external
3330         optionalProxy_onlyOwner
3331     {
3332         require(address(_synthetix) != address(0), "New Synthetix must be non-zero");
3333 
3334         synthetix = _synthetix;
3335 
3336         emitSynthetixUpdated(_synthetix);
3337     }
3338 
3339     /**
3340      * @notice The Synthetix contract informs us when fees are paid.
3341      */
3342     function feePaid(bytes4 currencyKey, uint amount)
3343         external
3344         onlySynthetix
3345     {
3346         uint xdrAmount = synthetix.effectiveValue(currencyKey, amount, "XDR");
3347 
3348         // Which we keep track of in XDRs in our fee pool.
3349         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.add(xdrAmount);
3350     }
3351 
3352     /**
3353      * @notice Close the current fee period and start a new one. Only callable by the fee authority.
3354      */
3355     function closeCurrentFeePeriod()
3356         external
3357         onlyFeeAuthority
3358     {
3359         require(recentFeePeriods[0].startTime <= (now - feePeriodDuration), "It is too early to close the current fee period");
3360 
3361         FeePeriod memory secondLastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 2];
3362         FeePeriod memory lastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 1];
3363 
3364         // Any unclaimed fees from the last period in the array roll back one period.
3365         // Because of the subtraction here, they're effectively proportionally redistributed to those who
3366         // have already claimed from the old period, available in the new period.
3367         // The subtraction is important so we don't create a ticking time bomb of an ever growing
3368         // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
3369         recentFeePeriods[FEE_PERIOD_LENGTH - 2].feesToDistribute = lastFeePeriod.feesToDistribute
3370             .sub(lastFeePeriod.feesClaimed)
3371             .add(secondLastFeePeriod.feesToDistribute);
3372 
3373         // Shift the previous fee periods across to make room for the new one.
3374         // Condition checks for overflow when uint subtracts one from zero
3375         // Could be written with int instead of uint, but then we have to convert everywhere
3376         // so it felt better from a gas perspective to just change the condition to check
3377         // for overflow after subtracting one from zero.
3378         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
3379             uint next = i + 1;
3380 
3381             recentFeePeriods[next].feePeriodId = recentFeePeriods[i].feePeriodId;
3382             recentFeePeriods[next].startingDebtIndex = recentFeePeriods[i].startingDebtIndex;
3383             recentFeePeriods[next].startTime = recentFeePeriods[i].startTime;
3384             recentFeePeriods[next].feesToDistribute = recentFeePeriods[i].feesToDistribute;
3385             recentFeePeriods[next].feesClaimed = recentFeePeriods[i].feesClaimed;
3386         }
3387 
3388         // Clear the first element of the array to make sure we don't have any stale values.
3389         delete recentFeePeriods[0];
3390 
3391         // Open up the new fee period
3392         recentFeePeriods[0].feePeriodId = nextFeePeriodId;
3393         recentFeePeriods[0].startingDebtIndex = synthetix.synthetixState().debtLedgerLength();
3394         recentFeePeriods[0].startTime = now;
3395 
3396         nextFeePeriodId = nextFeePeriodId.add(1);
3397 
3398         emitFeePeriodClosed(recentFeePeriods[1].feePeriodId);
3399     }
3400 
3401     /**
3402     * @notice Claim fees for last period when available or not already withdrawn.
3403     * @param currencyKey Synth currency you wish to receive the fees in.
3404     */
3405     function claimFees(bytes4 currencyKey)
3406         external
3407         optionalProxy
3408         returns (bool)
3409     {
3410         uint availableFees = feesAvailable(messageSender, "XDR");
3411 
3412         require(availableFees > 0, "No fees available for period, or fees already claimed");
3413 
3414         lastFeeWithdrawal[messageSender] = recentFeePeriods[1].feePeriodId;
3415 
3416         // Record the fee payment in our recentFeePeriods
3417         _recordFeePayment(availableFees);
3418 
3419         // Send them their fees
3420         _payFees(messageSender, availableFees, currencyKey);
3421 
3422         emitFeesClaimed(messageSender, availableFees);
3423 
3424         return true;
3425     }
3426 
3427     /**
3428      * @notice Record the fee payment in our recentFeePeriods.
3429      * @param xdrAmount The amout of fees priced in XDRs.
3430      */
3431     function _recordFeePayment(uint xdrAmount)
3432         internal
3433     {
3434         // Don't assign to the parameter
3435         uint remainingToAllocate = xdrAmount;
3436 
3437         // Start at the oldest period and record the amount, moving to newer periods
3438         // until we've exhausted the amount.
3439         // The condition checks for overflow because we're going to 0 with an unsigned int.
3440         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
3441             uint delta = recentFeePeriods[i].feesToDistribute.sub(recentFeePeriods[i].feesClaimed);
3442 
3443             if (delta > 0) {
3444                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
3445                 uint amountInPeriod = delta < remainingToAllocate ? delta : remainingToAllocate;
3446 
3447                 recentFeePeriods[i].feesClaimed = recentFeePeriods[i].feesClaimed.add(amountInPeriod);
3448                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
3449 
3450                 // No need to continue iterating if we've recorded the whole amount;
3451                 if (remainingToAllocate == 0) return;
3452             }
3453         }
3454 
3455         // If we hit this line, we've exhausted our fee periods, but still have more to allocate. Wat?
3456         // If this happens it's a definite bug in the code, so assert instead of require.
3457         assert(remainingToAllocate == 0);
3458     }
3459 
3460     /**
3461     * @notice Send the fees to claiming address.
3462     * @param account The address to send the fees to.
3463     * @param xdrAmount The amount of fees priced in XDRs.
3464     * @param destinationCurrencyKey The synth currency the user wishes to receive their fees in (convert to this currency).
3465     */
3466     function _payFees(address account, uint xdrAmount, bytes4 destinationCurrencyKey)
3467         internal
3468         notFeeAddress(account)
3469     {
3470         require(account != address(0), "Account can't be 0");
3471         require(account != address(this), "Can't send fees to fee pool");
3472         require(account != address(proxy), "Can't send fees to proxy");
3473         require(account != address(synthetix), "Can't send fees to synthetix");
3474 
3475         Synth xdrSynth = synthetix.synths("XDR");
3476         Synth destinationSynth = synthetix.synths(destinationCurrencyKey);
3477 
3478         // Note: We don't need to check the fee pool balance as the burn() below will do a safe subtraction which requires
3479         // the subtraction to not overflow, which would happen if the balance is not sufficient.
3480 
3481         // Burn the source amount
3482         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
3483 
3484         // How much should they get in the destination currency?
3485         uint destinationAmount = synthetix.effectiveValue("XDR", xdrAmount, destinationCurrencyKey);
3486 
3487         // There's no fee on withdrawing fees, as that'd be way too meta.
3488 
3489         // Mint their new synths
3490         destinationSynth.issue(account, destinationAmount);
3491 
3492         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3493 
3494         // Call the ERC223 transfer callback if needed
3495         destinationSynth.triggerTokenFallbackIfNeeded(FEE_ADDRESS, account, destinationAmount);
3496     }
3497 
3498     /**
3499      * @notice Calculate the Fee charged on top of a value being sent
3500      * @return Return the fee charged
3501      */
3502     function transferFeeIncurred(uint value)
3503         public
3504         view
3505         returns (uint)
3506     {
3507         return value.multiplyDecimal(transferFeeRate);
3508 
3509         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
3510         // This is on the basis that transfers less than this value will result in a nil fee.
3511         // Probably too insignificant to worry about, but the following code will achieve it.
3512         //      if (fee == 0 && transferFeeRate != 0) {
3513         //          return _value;
3514         //      }
3515         //      return fee;
3516     }
3517 
3518     /**
3519      * @notice The value that you would need to send so that the recipient receives
3520      * a specified value.
3521      * @param value The value you want the recipient to receive
3522      */
3523     function transferredAmountToReceive(uint value)
3524         external
3525         view
3526         returns (uint)
3527     {
3528         return value.add(transferFeeIncurred(value));
3529     }
3530 
3531     /**
3532      * @notice The amount the recipient will receive if you send a certain number of tokens.
3533      * @param value The amount of tokens you intend to send.
3534      */
3535     function amountReceivedFromTransfer(uint value)
3536         external
3537         view
3538         returns (uint)
3539     {
3540         return value.divideDecimal(transferFeeRate.add(SafeDecimalMath.unit()));
3541     }
3542 
3543     /**
3544      * @notice Calculate the fee charged on top of a value being sent via an exchange
3545      * @return Return the fee charged
3546      */
3547     function exchangeFeeIncurred(uint value)
3548         public
3549         view
3550         returns (uint)
3551     {
3552         return value.multiplyDecimal(exchangeFeeRate);
3553 
3554         // Exchanges less than the reciprocal of exchangeFeeRate should be completely eaten up by fees.
3555         // This is on the basis that exchanges less than this value will result in a nil fee.
3556         // Probably too insignificant to worry about, but the following code will achieve it.
3557         //      if (fee == 0 && exchangeFeeRate != 0) {
3558         //          return _value;
3559         //      }
3560         //      return fee;
3561     }
3562 
3563     /**
3564      * @notice The value that you would need to get after currency exchange so that the recipient receives
3565      * a specified value.
3566      * @param value The value you want the recipient to receive
3567      */
3568     function exchangedAmountToReceive(uint value)
3569         external
3570         view
3571         returns (uint)
3572     {
3573         return value.add(exchangeFeeIncurred(value));
3574     }
3575 
3576     /**
3577      * @notice The amount the recipient will receive if you are performing an exchange and the
3578      * destination currency will be worth a certain number of tokens.
3579      * @param value The amount of destination currency tokens they received after the exchange.
3580      */
3581     function amountReceivedFromExchange(uint value)
3582         external
3583         view
3584         returns (uint)
3585     {
3586         return value.divideDecimal(exchangeFeeRate.add(SafeDecimalMath.unit()));
3587     }
3588 
3589     /**
3590      * @notice The total fees available in the system to be withdrawn, priced in currencyKey currency
3591      * @param currencyKey The currency you want to price the fees in
3592      */
3593     function totalFeesAvailable(bytes4 currencyKey)
3594         external
3595         view
3596         returns (uint)
3597     {
3598         uint totalFees = 0;
3599 
3600         // Fees in fee period [0] are not yet available for withdrawal
3601         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
3602             totalFees = totalFees.add(recentFeePeriods[i].feesToDistribute);
3603             totalFees = totalFees.sub(recentFeePeriods[i].feesClaimed);
3604         }
3605 
3606         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
3607     }
3608 
3609     /**
3610      * @notice The fees available to be withdrawn by a specific account, priced in currencyKey currency
3611      * @param currencyKey The currency you want to price the fees in
3612      */
3613     function feesAvailable(address account, bytes4 currencyKey)
3614         public
3615         view
3616         returns (uint)
3617     {
3618         // Add up the fees
3619         uint[FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);
3620 
3621         uint totalFees = 0;
3622 
3623         // Fees in fee period [0] are not yet available for withdrawal
3624         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
3625             totalFees = totalFees.add(userFees[i]);
3626         }
3627 
3628         // And convert them to their desired currency
3629         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
3630     }
3631 
3632     /**
3633      * @notice The penalty a particular address would incur if its fees were withdrawn right now
3634      * @param account The address you want to query the penalty for
3635      */
3636     function currentPenalty(address account)
3637         public
3638         view
3639         returns (uint)
3640     {
3641         uint ratio = synthetix.collateralisationRatio(account);
3642 
3643         // Users receive a different amount of fees depending on how their collateralisation ratio looks right now.
3644         // 0% - 20%: Fee is calculated based on percentage of economy issued.
3645         // 20% - 30%: 25% reduction in fees
3646         // 30% - 40%: 50% reduction in fees
3647         // >40%: 75% reduction in fees
3648         if (ratio <= TWENTY_PERCENT) {
3649             return 0;
3650         } else if (ratio > TWENTY_PERCENT && ratio <= THIRTY_PERCENT) {
3651             return TWENTY_FIVE_PERCENT;
3652         } else if (ratio > THIRTY_PERCENT && ratio <= FOURTY_PERCENT) {
3653             return FIFTY_PERCENT;
3654         }
3655 
3656         return SEVENTY_FIVE_PERCENT;
3657     }
3658 
3659     /**
3660      * @notice Calculates fees by period for an account, priced in XDRs
3661      * @param account The address you want to query the fees by penalty for
3662      */
3663     function feesByPeriod(address account)
3664         public
3665         view
3666         returns (uint[FEE_PERIOD_LENGTH])
3667     {
3668         uint[FEE_PERIOD_LENGTH] memory result;
3669 
3670         // What's the user's debt entry index and the debt they owe to the system
3671         uint initialDebtOwnership;
3672         uint debtEntryIndex;
3673         (initialDebtOwnership, debtEntryIndex) = synthetix.synthetixState().issuanceData(account);
3674 
3675         // If they don't have any debt ownership, they don't have any fees
3676         if (initialDebtOwnership == 0) return result;
3677 
3678         // If there are no XDR synths, then they don't have any fees
3679         uint totalSynths = synthetix.totalIssuedSynths("XDR");
3680         if (totalSynths == 0) return result;
3681 
3682         uint debtBalance = synthetix.debtBalanceOf(account, "XDR");
3683         uint userOwnershipPercentage = debtBalance.divideDecimal(totalSynths);
3684         uint penalty = currentPenalty(account);
3685         
3686         // Go through our fee periods and figure out what we owe them.
3687         // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
3688         // fees owing for, so we need to report on it anyway.
3689         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
3690             // Were they a part of this period in its entirety?
3691             // We don't allow pro-rata participation to reduce the ability to game the system by
3692             // issuing and burning multiple times in a period or close to the ends of periods.
3693             if (recentFeePeriods[i].startingDebtIndex > debtEntryIndex &&
3694                 lastFeeWithdrawal[account] < recentFeePeriods[i].feePeriodId) {
3695 
3696                 // And since they were, they're entitled to their percentage of the fees in this period
3697                 uint feesFromPeriodWithoutPenalty = recentFeePeriods[i].feesToDistribute
3698                     .multiplyDecimal(userOwnershipPercentage);
3699 
3700                 // Less their penalty if they have one.
3701                 uint penaltyFromPeriod = feesFromPeriodWithoutPenalty.multiplyDecimal(penalty);
3702                 uint feesFromPeriod = feesFromPeriodWithoutPenalty.sub(penaltyFromPeriod);
3703 
3704                 result[i] = feesFromPeriod;
3705             }
3706         }
3707 
3708         return result;
3709     }
3710 
3711     modifier onlyFeeAuthority
3712     {
3713         require(msg.sender == feeAuthority, "Only the fee authority can perform this action");
3714         _;
3715     }
3716 
3717     modifier onlySynthetix
3718     {
3719         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
3720         _;
3721     }
3722 
3723     modifier notFeeAddress(address account) {
3724         require(account != FEE_ADDRESS, "Fee address not allowed");
3725         _;
3726     }
3727 
3728     event TransferFeeUpdated(uint newFeeRate);
3729     bytes32 constant TRANSFERFEEUPDATED_SIG = keccak256("TransferFeeUpdated(uint256)");
3730     function emitTransferFeeUpdated(uint newFeeRate) internal {
3731         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEEUPDATED_SIG, 0, 0, 0);
3732     }
3733 
3734     event ExchangeFeeUpdated(uint newFeeRate);
3735     bytes32 constant EXCHANGEFEEUPDATED_SIG = keccak256("ExchangeFeeUpdated(uint256)");
3736     function emitExchangeFeeUpdated(uint newFeeRate) internal {
3737         proxy._emit(abi.encode(newFeeRate), 1, EXCHANGEFEEUPDATED_SIG, 0, 0, 0);
3738     }
3739 
3740     event FeePeriodDurationUpdated(uint newFeePeriodDuration);
3741     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
3742     function emitFeePeriodDurationUpdated(uint newFeePeriodDuration) internal {
3743         proxy._emit(abi.encode(newFeePeriodDuration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
3744     }
3745 
3746     event FeeAuthorityUpdated(address newFeeAuthority);
3747     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
3748     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
3749         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
3750     }
3751 
3752     event FeePeriodClosed(uint feePeriodId);
3753     bytes32 constant FEEPERIODCLOSED_SIG = keccak256("FeePeriodClosed(uint256)");
3754     function emitFeePeriodClosed(uint feePeriodId) internal {
3755         proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
3756     }
3757 
3758     event FeesClaimed(address account, uint xdrAmount);
3759     bytes32 constant FEESCLAIMED_SIG = keccak256("FeesClaimed(address,uint256)");
3760     function emitFeesClaimed(address account, uint xdrAmount) internal {
3761         proxy._emit(abi.encode(account, xdrAmount), 1, FEESCLAIMED_SIG, 0, 0, 0);
3762     }
3763 
3764     event SynthetixUpdated(address newSynthetix);
3765     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
3766     function emitSynthetixUpdated(address newSynthetix) internal {
3767         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
3768     }
3769 }
3770 
3771 
3772 /*
3773 -----------------------------------------------------------------
3774 FILE INFORMATION
3775 -----------------------------------------------------------------
3776 
3777 file:       Synth.sol
3778 version:    2.0
3779 author:     Kevin Brown
3780 date:       2018-09-13
3781 
3782 -----------------------------------------------------------------
3783 MODULE DESCRIPTION
3784 -----------------------------------------------------------------
3785 
3786 Synthetix-backed stablecoin contract.
3787 
3788 This contract issues synths, which are tokens that mirror various
3789 flavours of fiat currency.
3790 
3791 Synths are issuable by Synthetix Network Token (SNX) holders who 
3792 have to lock up some value of their SNX to issue S * Cmax synths. 
3793 Where Cmax issome value less than 1.
3794 
3795 A configurable fee is charged on synth transfers and deposited
3796 into a common pot, which Synthetix holders may withdraw from once
3797 per fee period.
3798 
3799 -----------------------------------------------------------------
3800 */
3801 
3802 
3803 contract Synth is ExternStateToken {
3804 
3805     /* ========== STATE VARIABLES ========== */
3806 
3807     FeePool public feePool;
3808     Synthetix public synthetix;
3809 
3810     // Currency key which identifies this Synth to the Synthetix system
3811     bytes4 public currencyKey;
3812 
3813     uint8 constant DECIMALS = 18;
3814 
3815     /* ========== CONSTRUCTOR ========== */
3816 
3817     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, FeePool _feePool,
3818         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey
3819     )
3820         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, 0, DECIMALS, _owner)
3821         public
3822     {
3823         require(_proxy != 0, "_proxy cannot be 0");
3824         require(address(_synthetix) != 0, "_synthetix cannot be 0");
3825         require(address(_feePool) != 0, "_feePool cannot be 0");
3826         require(_owner != 0, "_owner cannot be 0");
3827         require(_synthetix.synths(_currencyKey) == Synth(0), "Currency key is already in use");
3828 
3829         feePool = _feePool;
3830         synthetix = _synthetix;
3831         currencyKey = _currencyKey;
3832     }
3833 
3834     /* ========== SETTERS ========== */
3835 
3836     function setSynthetix(Synthetix _synthetix)
3837         external
3838         optionalProxy_onlyOwner
3839     {
3840         synthetix = _synthetix;
3841         emitSynthetixUpdated(_synthetix);
3842     }
3843 
3844     function setFeePool(FeePool _feePool)
3845         external
3846         optionalProxy_onlyOwner
3847     {
3848         feePool = _feePool;
3849         emitFeePoolUpdated(_feePool);
3850     }
3851 
3852     /* ========== MUTATIVE FUNCTIONS ========== */
3853 
3854     /**
3855      * @notice Override ERC20 transfer function in order to 
3856      * subtract the transaction fee and send it to the fee pool
3857      * for SNX holders to claim. */
3858     function transfer(address to, uint value)
3859         public
3860         optionalProxy
3861         notFeeAddress(messageSender)
3862         returns (bool)
3863     {
3864         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3865         uint fee = value.sub(amountReceived);
3866 
3867         // Send the fee off to the fee pool.
3868         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3869 
3870         // And send their result off to the destination address
3871         bytes memory empty;
3872         return _internalTransfer(messageSender, to, amountReceived, empty);
3873     }
3874 
3875     /**
3876      * @notice Override ERC223 transfer function in order to 
3877      * subtract the transaction fee and send it to the fee pool
3878      * for SNX holders to claim. */
3879     function transfer(address to, uint value, bytes data)
3880         public
3881         optionalProxy
3882         notFeeAddress(messageSender)
3883         returns (bool)
3884     {
3885         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3886         uint fee = value.sub(amountReceived);
3887 
3888         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3889         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3890 
3891         // And send their result off to the destination address
3892         return _internalTransfer(messageSender, to, amountReceived, data);
3893     }
3894 
3895     /**
3896      * @notice Override ERC20 transferFrom function in order to 
3897      * subtract the transaction fee and send it to the fee pool
3898      * for SNX holders to claim. */
3899     function transferFrom(address from, address to, uint value)
3900         public
3901         optionalProxy
3902         notFeeAddress(from)
3903         returns (bool)
3904     {
3905         // The fee is deducted from the amount sent.
3906         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3907         uint fee = value.sub(amountReceived);
3908 
3909         // Reduce the allowance by the amount we're transferring.
3910         // The safeSub call will handle an insufficient allowance.
3911         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
3912 
3913         // Send the fee off to the fee pool.
3914         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
3915 
3916         bytes memory empty;
3917         return _internalTransfer(from, to, amountReceived, empty);
3918     }
3919 
3920     /**
3921      * @notice Override ERC223 transferFrom function in order to 
3922      * subtract the transaction fee and send it to the fee pool
3923      * for SNX holders to claim. */
3924     function transferFrom(address from, address to, uint value, bytes data)
3925         public
3926         optionalProxy
3927         notFeeAddress(from)
3928         returns (bool)
3929     {
3930         // The fee is deducted from the amount sent.
3931         uint amountReceived = feePool.amountReceivedFromTransfer(value);
3932         uint fee = value.sub(amountReceived);
3933 
3934         // Reduce the allowance by the amount we're transferring.
3935         // The safeSub call will handle an insufficient allowance.
3936         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
3937 
3938         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3939         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
3940 
3941         return _internalTransfer(from, to, amountReceived, data);
3942     }
3943 
3944     /* Subtract the transfer fee from the senders account so the 
3945      * receiver gets the exact amount specified to send. */
3946     function transferSenderPaysFee(address to, uint value)
3947         public
3948         optionalProxy
3949         notFeeAddress(messageSender)
3950         returns (bool)
3951     {
3952         uint fee = feePool.transferFeeIncurred(value);
3953 
3954         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3955         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3956 
3957         // And send their transfer amount off to the destination address
3958         bytes memory empty;
3959         return _internalTransfer(messageSender, to, value, empty);
3960     }
3961 
3962     /* Subtract the transfer fee from the senders account so the 
3963      * receiver gets the exact amount specified to send. */
3964     function transferSenderPaysFee(address to, uint value, bytes data)
3965         public
3966         optionalProxy
3967         notFeeAddress(messageSender)
3968         returns (bool)
3969     {
3970         uint fee = feePool.transferFeeIncurred(value);
3971 
3972         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3973         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
3974 
3975         // And send their transfer amount off to the destination address
3976         return _internalTransfer(messageSender, to, value, data);
3977     }
3978 
3979     /* Subtract the transfer fee from the senders account so the 
3980      * to address receives the exact amount specified to send. */
3981     function transferFromSenderPaysFee(address from, address to, uint value)
3982         public
3983         optionalProxy
3984         notFeeAddress(from)
3985         returns (bool)
3986     {
3987         uint fee = feePool.transferFeeIncurred(value);
3988 
3989         // Reduce the allowance by the amount we're transferring.
3990         // The safeSub call will handle an insufficient allowance.
3991         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
3992 
3993         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
3994         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
3995 
3996         bytes memory empty;
3997         return _internalTransfer(from, to, value, empty);
3998     }
3999 
4000     /* Subtract the transfer fee from the senders account so the 
4001      * to address receives the exact amount specified to send. */
4002     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
4003         public
4004         optionalProxy
4005         notFeeAddress(from)
4006         returns (bool)
4007     {
4008         uint fee = feePool.transferFeeIncurred(value);
4009 
4010         // Reduce the allowance by the amount we're transferring.
4011         // The safeSub call will handle an insufficient allowance.
4012         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
4013 
4014         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
4015         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
4016 
4017         return _internalTransfer(from, to, value, data);
4018     }
4019 
4020     // Override our internal transfer to inject preferred currency support
4021     function _internalTransfer(address from, address to, uint value, bytes data)
4022         internal
4023         returns (bool)
4024     {
4025         bytes4 preferredCurrencyKey = synthetix.synthetixState().preferredCurrency(to);
4026 
4027         // Do they have a preferred currency that's not us? If so we need to exchange
4028         if (preferredCurrencyKey != 0 && preferredCurrencyKey != currencyKey) {
4029             return synthetix.synthInitiatedExchange(from, currencyKey, value, preferredCurrencyKey, to);
4030         } else {
4031             // Otherwise we just transfer
4032             return super._internalTransfer(from, to, value, data);
4033         }
4034     }
4035 
4036     // Allow synthetix to issue a certain number of synths from an account.
4037     function issue(address account, uint amount)
4038         external
4039         onlySynthetixOrFeePool
4040     {
4041         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
4042         totalSupply = totalSupply.add(amount);
4043         emitTransfer(address(0), account, amount);
4044         emitIssued(account, amount);
4045     }
4046 
4047     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
4048     function burn(address account, uint amount)
4049         external
4050         onlySynthetixOrFeePool
4051     {
4052         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
4053         totalSupply = totalSupply.sub(amount);
4054         emitTransfer(account, address(0), amount);
4055         emitBurned(account, amount);
4056     }
4057 
4058     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
4059     // exchange as well as transfer
4060     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
4061         external
4062         onlySynthetixOrFeePool
4063     {
4064         bytes memory empty;
4065         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
4066     }
4067 
4068     /* ========== MODIFIERS ========== */
4069 
4070     modifier onlySynthetixOrFeePool() {
4071         bool isSynthetix = msg.sender == address(synthetix);
4072         bool isFeePool = msg.sender == address(feePool);
4073 
4074         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
4075         _;
4076     }
4077 
4078     modifier notFeeAddress(address account) {
4079         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
4080         _;
4081     }
4082 
4083     /* ========== EVENTS ========== */
4084 
4085     event SynthetixUpdated(address newSynthetix);
4086     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
4087     function emitSynthetixUpdated(address newSynthetix) internal {
4088         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
4089     }
4090 
4091     event FeePoolUpdated(address newFeePool);
4092     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
4093     function emitFeePoolUpdated(address newFeePool) internal {
4094         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
4095     }
4096 
4097     event Issued(address indexed account, uint value);
4098     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
4099     function emitIssued(address account, uint value) internal {
4100         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
4101     }
4102 
4103     event Burned(address indexed account, uint value);
4104     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
4105     function emitBurned(address account, uint value) internal {
4106         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
4107     }
4108 }
4109 
