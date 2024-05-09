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
1205 file:       SupplySchedule.sol
1206 version:    1.0
1207 author:     Jackson Chan
1208             Clinton Ennis
1209 date:       2019-03-01
1210 
1211 -----------------------------------------------------------------
1212 MODULE DESCRIPTION
1213 -----------------------------------------------------------------
1214 
1215 Supply Schedule contract. SNX is a transferable ERC20 token.
1216 
1217 User's get staking rewards as part of the incentives of
1218 +------+-------------+--------------+----------+
1219 | Year |  Increase   | Total Supply | Increase |
1220 +------+-------------+--------------+----------+
1221 |    1 |           0 |  100,000,000 |          |
1222 |    2 |  75,000,000 |  175,000,000 | 75%      |
1223 |    3 |  37,500,000 |  212,500,000 | 21%      |
1224 |    4 |  18,750,000 |  231,250,000 | 9%       |
1225 |    5 |   9,375,000 |  240,625,000 | 4%       |
1226 |    6 |   4,687,500 |  245,312,500 | 2%       |
1227 +------+-------------+--------------+----------+
1228 
1229 
1230 -----------------------------------------------------------------
1231 */
1232 
1233 
1234 /**
1235  * @title SupplySchedule contract
1236  */
1237 contract SupplySchedule is Owned {
1238     using SafeMath for uint;
1239     using SafeDecimalMath for uint;
1240 
1241     /* Storage */
1242     struct ScheduleData {
1243         // Total supply issuable during period
1244         uint totalSupply;
1245 
1246         // UTC Time - Start of the schedule
1247         uint startPeriod;
1248 
1249         // UTC Time - End of the schedule
1250         uint endPeriod;
1251 
1252         // UTC Time - Total of supply minted
1253         uint totalSupplyMinted;
1254     }
1255 
1256     // How long each mint period is
1257     uint public mintPeriodDuration = 1 weeks;
1258 
1259     // time supply last minted
1260     uint public lastMintEvent;
1261 
1262     Synthetix public synthetix;
1263 
1264     uint constant SECONDS_IN_YEAR = 60 * 60 * 24 * 365;
1265 
1266     uint public constant START_DATE = 1520294400; // 2018-03-06T00:00:00+00:00
1267     uint public constant YEAR_ONE = START_DATE + SECONDS_IN_YEAR.mul(1);
1268     uint public constant YEAR_TWO = START_DATE + SECONDS_IN_YEAR.mul(2);
1269     uint public constant YEAR_THREE = START_DATE + SECONDS_IN_YEAR.mul(3);
1270     uint public constant YEAR_FOUR = START_DATE + SECONDS_IN_YEAR.mul(4);
1271     uint public constant YEAR_FIVE = START_DATE + SECONDS_IN_YEAR.mul(5);
1272     uint public constant YEAR_SIX = START_DATE + SECONDS_IN_YEAR.mul(6);
1273     uint public constant YEAR_SEVEN = START_DATE + SECONDS_IN_YEAR.mul(7);
1274 
1275     uint8 constant public INFLATION_SCHEDULES_LENGTH = 7;
1276     ScheduleData[INFLATION_SCHEDULES_LENGTH] public schedules;
1277 
1278     uint public minterReward = 200 * SafeDecimalMath.unit();
1279 
1280     constructor(address _owner)
1281         Owned(_owner)
1282         public
1283     {
1284         // ScheduleData(totalSupply, startPeriod, endPeriod, totalSupplyMinted)
1285         // Year 1 - Total supply 100,000,000
1286         schedules[0] = ScheduleData(1e8 * SafeDecimalMath.unit(), START_DATE, YEAR_ONE - 1, 1e8 * SafeDecimalMath.unit());
1287         schedules[1] = ScheduleData(75e6 * SafeDecimalMath.unit(), YEAR_ONE, YEAR_TWO - 1, 0); // Year 2 - Total supply 175,000,000
1288         schedules[2] = ScheduleData(37.5e6 * SafeDecimalMath.unit(), YEAR_TWO, YEAR_THREE - 1, 0); // Year 3 - Total supply 212,500,000
1289         schedules[3] = ScheduleData(18.75e6 * SafeDecimalMath.unit(), YEAR_THREE, YEAR_FOUR - 1, 0); // Year 4 - Total supply 231,250,000
1290         schedules[4] = ScheduleData(9.375e6 * SafeDecimalMath.unit(), YEAR_FOUR, YEAR_FIVE - 1, 0); // Year 5 - Total supply 240,625,000
1291         schedules[5] = ScheduleData(4.6875e6 * SafeDecimalMath.unit(), YEAR_FIVE, YEAR_SIX - 1, 0); // Year 6 - Total supply 245,312,500
1292         schedules[6] = ScheduleData(0, YEAR_SIX, YEAR_SEVEN - 1, 0); // Year 7 - Total supply 245,312,500
1293     }
1294 
1295     // ========== SETTERS ========== */
1296     function setSynthetix(Synthetix _synthetix)
1297         external
1298         onlyOwner
1299     {
1300         synthetix = _synthetix;
1301         // emit event
1302     }
1303 
1304     // ========== VIEWS ==========
1305     function mintableSupply()
1306         public
1307         view
1308         returns (uint)
1309     {
1310         if (!isMintable()) {
1311             return 0;
1312         }
1313 
1314         uint index = getCurrentSchedule();
1315 
1316         // Calculate previous year's mintable supply
1317         uint amountPreviousPeriod = _remainingSupplyFromPreviousYear(index);
1318 
1319         /* solium-disable */
1320 
1321         // Last mint event within current period will use difference in (now - lastMintEvent)
1322         // Last mint event not set (0) / outside of current Period will use current Period
1323         // start time resolved in (now - schedule.startPeriod)
1324         ScheduleData memory schedule = schedules[index];
1325 
1326         uint weeksInPeriod = (schedule.endPeriod - schedule.startPeriod).div(mintPeriodDuration);
1327 
1328         uint supplyPerWeek = schedule.totalSupply.divideDecimal(weeksInPeriod);
1329 
1330         uint weeksToMint = lastMintEvent >= schedule.startPeriod ? _numWeeksRoundedDown(now.sub(lastMintEvent)) : _numWeeksRoundedDown(now.sub(schedule.startPeriod));
1331         // /* solium-enable */
1332 
1333         uint amountInPeriod = supplyPerWeek.multiplyDecimal(weeksToMint);
1334         return amountInPeriod.add(amountPreviousPeriod);
1335     }
1336 
1337     function _numWeeksRoundedDown(uint _timeDiff)
1338         public
1339         view
1340         returns (uint)
1341     {
1342         // Take timeDiff in seconds (Dividend) and mintPeriodDuration as (Divisor)
1343         // Calculate the numberOfWeeks since last mint rounded down to 1 week
1344         // Fraction of a week will return 0
1345         return _timeDiff.div(mintPeriodDuration);
1346     }
1347 
1348     function isMintable()
1349         public
1350         view
1351         returns (bool)
1352     {
1353         bool mintable = false;
1354         if (now - lastMintEvent > mintPeriodDuration && now <= schedules[6].endPeriod) // Ensure time is not after end of Year 7
1355         {
1356             mintable = true;
1357         }
1358         return mintable;
1359     }
1360 
1361     // Return the current schedule based on the timestamp
1362     // applicable based on startPeriod and endPeriod
1363     function getCurrentSchedule()
1364         public
1365         view
1366         returns (uint)
1367     {
1368         require(now <= schedules[6].endPeriod, "Mintable periods have ended");
1369 
1370         for (uint i = 0; i < INFLATION_SCHEDULES_LENGTH; i++) {
1371             if (schedules[i].startPeriod <= now && schedules[i].endPeriod >= now) {
1372                 return i;
1373             }
1374         }
1375     }
1376 
1377     function _remainingSupplyFromPreviousYear(uint currentSchedule)
1378         internal
1379         view
1380         returns (uint)
1381     {
1382         // All supply has been minted for previous period if last minting event is after
1383         // the endPeriod for last year
1384         if (currentSchedule == 0 || lastMintEvent > schedules[currentSchedule - 1].endPeriod) {
1385             return 0;
1386         }
1387 
1388         // return the remaining supply to be minted for previous period missed
1389         uint amountInPeriod = schedules[currentSchedule - 1].totalSupply.sub(schedules[currentSchedule - 1].totalSupplyMinted);
1390 
1391         // Ensure previous period remaining amount is not less than 0
1392         if (amountInPeriod < 0) {
1393             return 0;
1394         }
1395 
1396         return amountInPeriod;
1397     }
1398 
1399     // ========== MUTATIVE FUNCTIONS ==========
1400     function updateMintValues()
1401         external
1402         onlySynthetix
1403         returns (bool)
1404     {
1405         // Will fail if the time is outside of schedules
1406         uint currentIndex = getCurrentSchedule();
1407         uint lastPeriodAmount = _remainingSupplyFromPreviousYear(currentIndex);
1408         uint currentPeriodAmount = mintableSupply().sub(lastPeriodAmount);
1409 
1410         // Update schedule[n - 1].totalSupplyMinted
1411         if (lastPeriodAmount > 0) {
1412             schedules[currentIndex - 1].totalSupplyMinted = schedules[currentIndex - 1].totalSupplyMinted.add(lastPeriodAmount);
1413         }
1414 
1415         // Update schedule.totalSupplyMinted for currentSchedule
1416         schedules[currentIndex].totalSupplyMinted = schedules[currentIndex].totalSupplyMinted.add(currentPeriodAmount);
1417         // Update mint event to now
1418         lastMintEvent = now;
1419 
1420         emit SupplyMinted(lastPeriodAmount, currentPeriodAmount, currentIndex, now);
1421         return true;
1422     }
1423 
1424     function setMinterReward(uint _amount)
1425         external
1426         onlyOwner
1427     {
1428         minterReward = _amount;
1429         emit MinterRewardUpdated(_amount);
1430     }
1431 
1432     // ========== MODIFIERS ==========
1433 
1434     modifier onlySynthetix() {
1435         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
1436         _;
1437     }
1438 
1439     /* ========== EVENTS ========== */
1440 
1441     event SupplyMinted(uint previousPeriodAmount, uint currentAmount, uint indexed schedule, uint timestamp);
1442     event MinterRewardUpdated(uint newRewardAmount);
1443 }
1444 
1445 
1446 /*
1447 -----------------------------------------------------------------
1448 FILE INFORMATION
1449 -----------------------------------------------------------------
1450 
1451 file:       ExchangeRates.sol
1452 version:    1.0
1453 author:     Kevin Brown
1454 date:       2018-09-12
1455 
1456 -----------------------------------------------------------------
1457 MODULE DESCRIPTION
1458 -----------------------------------------------------------------
1459 
1460 A contract that any other contract in the Synthetix system can query
1461 for the current market value of various assets, including
1462 crypto assets as well as various fiat assets.
1463 
1464 This contract assumes that rate updates will completely update
1465 all rates to their current values. If a rate shock happens
1466 on a single asset, the oracle will still push updated rates
1467 for all other assets.
1468 
1469 -----------------------------------------------------------------
1470 */
1471 
1472 
1473 /**
1474  * @title The repository for exchange rates
1475  */
1476 
1477 contract ExchangeRates is SelfDestructible {
1478 
1479 
1480     using SafeMath for uint;
1481     using SafeDecimalMath for uint;
1482 
1483     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
1484     mapping(bytes4 => uint) public rates;
1485 
1486     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
1487     mapping(bytes4 => uint) public lastRateUpdateTimes;
1488 
1489     // The address of the oracle which pushes rate updates to this contract
1490     address public oracle;
1491 
1492     // Do not allow the oracle to submit times any further forward into the future than this constant.
1493     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
1494 
1495     // How long will the contract assume the rate of any asset is correct
1496     uint public rateStalePeriod = 3 hours;
1497 
1498     // Each participating currency in the XDR basket is represented as a currency key with
1499     // equal weighting.
1500     // There are 5 participating currencies, so we'll declare that clearly.
1501     bytes4[5] public xdrParticipants;
1502 
1503     // For inverted prices, keep a mapping of their entry, limits and frozen status
1504     struct InversePricing {
1505         uint entryPoint;
1506         uint upperLimit;
1507         uint lowerLimit;
1508         bool frozen;
1509     }
1510     mapping(bytes4 => InversePricing) public inversePricing;
1511     bytes4[] public invertedKeys;
1512 
1513     //
1514     // ========== CONSTRUCTOR ==========
1515 
1516     /**
1517      * @dev Constructor
1518      * @param _owner The owner of this contract.
1519      * @param _oracle The address which is able to update rate information.
1520      * @param _currencyKeys The initial currency keys to store (in order).
1521      * @param _newRates The initial currency amounts for each currency (in order).
1522      */
1523     constructor(
1524         // SelfDestructible (Ownable)
1525         address _owner,
1526 
1527         // Oracle values - Allows for rate updates
1528         address _oracle,
1529         bytes4[] _currencyKeys,
1530         uint[] _newRates
1531     )
1532         /* Owned is initialised in SelfDestructible */
1533         SelfDestructible(_owner)
1534         public
1535     {
1536         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
1537 
1538         oracle = _oracle;
1539 
1540         // The sUSD rate is always 1 and is never stale.
1541         rates["sUSD"] = SafeDecimalMath.unit();
1542         lastRateUpdateTimes["sUSD"] = now;
1543 
1544         // These are the currencies that make up the XDR basket.
1545         // These are hard coded because:
1546         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
1547         //  - Adding new currencies would likely introduce some kind of weighting factor, which
1548         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
1549         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
1550         //    then point the system at the new version.
1551         xdrParticipants = [
1552             bytes4("sUSD"),
1553             bytes4("sAUD"),
1554             bytes4("sCHF"),
1555             bytes4("sEUR"),
1556             bytes4("sGBP")
1557         ];
1558 
1559         internalUpdateRates(_currencyKeys, _newRates, now);
1560     }
1561 
1562     /* ========== SETTERS ========== */
1563 
1564     /**
1565      * @notice Set the rates stored in this contract
1566      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1567      * @param newRates The rates for each currency (in order)
1568      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1569      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1570      *                 if it takes a long time for the transaction to confirm.
1571      */
1572     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
1573         external
1574         onlyOracle
1575         returns(bool)
1576     {
1577         return internalUpdateRates(currencyKeys, newRates, timeSent);
1578     }
1579 
1580     /**
1581      * @notice Internal function which sets the rates stored in this contract
1582      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1583      * @param newRates The rates for each currency (in order)
1584      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1585      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1586      *                 if it takes a long time for the transaction to confirm.
1587      */
1588     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
1589         internal
1590         returns(bool)
1591     {
1592         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
1593         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
1594 
1595         // Loop through each key and perform update.
1596         for (uint i = 0; i < currencyKeys.length; i++) {
1597             // Should not set any rate to zero ever, as no asset will ever be
1598             // truely worthless and still valid. In this scenario, we should
1599             // delete the rate and remove it from the system.
1600             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
1601             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
1602 
1603             // We should only update the rate if it's at least the same age as the last rate we've got.
1604             if (timeSent < lastRateUpdateTimes[currencyKeys[i]]) {
1605                 continue;
1606             }
1607 
1608             newRates[i] = rateOrInverted(currencyKeys[i], newRates[i]);
1609 
1610             // Ok, go ahead with the update.
1611             rates[currencyKeys[i]] = newRates[i];
1612             lastRateUpdateTimes[currencyKeys[i]] = timeSent;
1613         }
1614 
1615         emit RatesUpdated(currencyKeys, newRates);
1616 
1617         // Now update our XDR rate.
1618         updateXDRRate(timeSent);
1619 
1620         return true;
1621     }
1622 
1623     /**
1624      * @notice Internal function to get the inverted rate, if any, and mark an inverted
1625      *  key as frozen if either limits are reached.
1626      * @param currencyKey The price key to lookup
1627      * @param rate The rate for the given price key
1628      */
1629     function rateOrInverted(bytes4 currencyKey, uint rate) internal returns (uint) {
1630         // if an inverse mapping exists, adjust the price accordingly
1631         InversePricing storage inverse = inversePricing[currencyKey];
1632         if (inverse.entryPoint <= 0) {
1633             return rate;
1634         }
1635 
1636         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
1637         uint newInverseRate = rates[currencyKey];
1638 
1639         // get the new inverted rate if not frozen
1640         if (!inverse.frozen) {
1641             uint doubleEntryPoint = inverse.entryPoint.mul(2);
1642             if (doubleEntryPoint <= rate) {
1643                 // avoid negative numbers for unsigned ints, so set this to 0
1644                 // which by the requirement that lowerLimit be > 0 will
1645                 // cause this to freeze the price to the lowerLimit
1646                 newInverseRate = 0;
1647             } else {
1648                 newInverseRate = doubleEntryPoint.sub(rate);
1649             }
1650 
1651             // now if new rate hits our limits, set it to the limit and freeze
1652             if (newInverseRate >= inverse.upperLimit) {
1653                 newInverseRate = inverse.upperLimit;
1654             } else if (newInverseRate <= inverse.lowerLimit) {
1655                 newInverseRate = inverse.lowerLimit;
1656             }
1657 
1658             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
1659                 inverse.frozen = true;
1660                 emit InversePriceFrozen(currencyKey);
1661             }
1662         }
1663 
1664         return newInverseRate;
1665     }
1666 
1667     /**
1668      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
1669      */
1670     function updateXDRRate(uint timeSent)
1671         internal
1672     {
1673         uint total = 0;
1674 
1675         for (uint i = 0; i < xdrParticipants.length; i++) {
1676             total = rates[xdrParticipants[i]].add(total);
1677         }
1678 
1679         // Set the rate
1680         rates["XDR"] = total;
1681 
1682         // Record that we updated the XDR rate.
1683         lastRateUpdateTimes["XDR"] = timeSent;
1684 
1685         // Emit our updated event separate to the others to save
1686         // moving data around between arrays.
1687         bytes4[] memory eventCurrencyCode = new bytes4[](1);
1688         eventCurrencyCode[0] = "XDR";
1689 
1690         uint[] memory eventRate = new uint[](1);
1691         eventRate[0] = rates["XDR"];
1692 
1693         emit RatesUpdated(eventCurrencyCode, eventRate);
1694     }
1695 
1696     /**
1697      * @notice Delete a rate stored in the contract
1698      * @param currencyKey The currency key you wish to delete the rate for
1699      */
1700     function deleteRate(bytes4 currencyKey)
1701         external
1702         onlyOracle
1703     {
1704         require(rates[currencyKey] > 0, "Rate is zero");
1705 
1706         delete rates[currencyKey];
1707         delete lastRateUpdateTimes[currencyKey];
1708 
1709         emit RateDeleted(currencyKey);
1710     }
1711 
1712     /**
1713      * @notice Set the Oracle that pushes the rate information to this contract
1714      * @param _oracle The new oracle address
1715      */
1716     function setOracle(address _oracle)
1717         external
1718         onlyOwner
1719     {
1720         oracle = _oracle;
1721         emit OracleUpdated(oracle);
1722     }
1723 
1724     /**
1725      * @notice Set the stale period on the updated rate variables
1726      * @param _time The new rateStalePeriod
1727      */
1728     function setRateStalePeriod(uint _time)
1729         external
1730         onlyOwner
1731     {
1732         rateStalePeriod = _time;
1733         emit RateStalePeriodUpdated(rateStalePeriod);
1734     }
1735 
1736     /**
1737      * @notice Set an inverse price up for the currency key
1738      * @param currencyKey The currency to update
1739      * @param entryPoint The entry price point of the inverted price
1740      * @param upperLimit The upper limit, at or above which the price will be frozen
1741      * @param lowerLimit The lower limit, at or below which the price will be frozen
1742      */
1743     function setInversePricing(bytes4 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit)
1744         external onlyOwner
1745     {
1746         require(entryPoint > 0, "entryPoint must be above 0");
1747         require(lowerLimit > 0, "lowerLimit must be above 0");
1748         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
1749         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
1750         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
1751 
1752         if (inversePricing[currencyKey].entryPoint <= 0) {
1753             // then we are adding a new inverse pricing, so add this
1754             invertedKeys.push(currencyKey);
1755         }
1756         inversePricing[currencyKey].entryPoint = entryPoint;
1757         inversePricing[currencyKey].upperLimit = upperLimit;
1758         inversePricing[currencyKey].lowerLimit = lowerLimit;
1759         inversePricing[currencyKey].frozen = false;
1760 
1761         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
1762     }
1763 
1764     /**
1765      * @notice Remove an inverse price for the currency key
1766      * @param currencyKey The currency to remove inverse pricing for
1767      */
1768     function removeInversePricing(bytes4 currencyKey) external onlyOwner {
1769         inversePricing[currencyKey].entryPoint = 0;
1770         inversePricing[currencyKey].upperLimit = 0;
1771         inversePricing[currencyKey].lowerLimit = 0;
1772         inversePricing[currencyKey].frozen = false;
1773 
1774         // now remove inverted key from array
1775         for (uint8 i = 0; i < invertedKeys.length; i++) {
1776             if (invertedKeys[i] == currencyKey) {
1777                 delete invertedKeys[i];
1778 
1779                 // Copy the last key into the place of the one we just deleted
1780                 // If there's only one key, this is array[0] = array[0].
1781                 // If we're deleting the last one, it's also a NOOP in the same way.
1782                 invertedKeys[i] = invertedKeys[invertedKeys.length - 1];
1783 
1784                 // Decrease the size of the array by one.
1785                 invertedKeys.length--;
1786 
1787                 break;
1788             }
1789         }
1790 
1791         emit InversePriceConfigured(currencyKey, 0, 0, 0);
1792     }
1793     /* ========== VIEWS ========== */
1794 
1795     /**
1796      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
1797      * @param sourceCurrencyKey The currency the amount is specified in
1798      * @param sourceAmount The source amount, specified in UNIT base
1799      * @param destinationCurrencyKey The destination currency
1800      */
1801     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
1802         public
1803         view
1804         rateNotStale(sourceCurrencyKey)
1805         rateNotStale(destinationCurrencyKey)
1806         returns (uint)
1807     {
1808         // If there's no change in the currency, then just return the amount they gave us
1809         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
1810 
1811         // Calculate the effective value by going from source -> USD -> destination
1812         return sourceAmount.multiplyDecimalRound(rateForCurrency(sourceCurrencyKey))
1813             .divideDecimalRound(rateForCurrency(destinationCurrencyKey));
1814     }
1815 
1816     /**
1817      * @notice Retrieve the rate for a specific currency
1818      */
1819     function rateForCurrency(bytes4 currencyKey)
1820         public
1821         view
1822         returns (uint)
1823     {
1824         return rates[currencyKey];
1825     }
1826 
1827     /**
1828      * @notice Retrieve the rates for a list of currencies
1829      */
1830     function ratesForCurrencies(bytes4[] currencyKeys)
1831         public
1832         view
1833         returns (uint[])
1834     {
1835         uint[] memory _rates = new uint[](currencyKeys.length);
1836 
1837         for (uint8 i = 0; i < currencyKeys.length; i++) {
1838             _rates[i] = rates[currencyKeys[i]];
1839         }
1840 
1841         return _rates;
1842     }
1843 
1844     /**
1845      * @notice Retrieve a list of last update times for specific currencies
1846      */
1847     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
1848         public
1849         view
1850         returns (uint)
1851     {
1852         return lastRateUpdateTimes[currencyKey];
1853     }
1854 
1855     /**
1856      * @notice Retrieve the last update time for a specific currency
1857      */
1858     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
1859         public
1860         view
1861         returns (uint[])
1862     {
1863         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
1864 
1865         for (uint8 i = 0; i < currencyKeys.length; i++) {
1866             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
1867         }
1868 
1869         return lastUpdateTimes;
1870     }
1871 
1872     /**
1873      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
1874      */
1875     function rateIsStale(bytes4 currencyKey)
1876         public
1877         view
1878         returns (bool)
1879     {
1880         // sUSD is a special case and is never stale.
1881         if (currencyKey == "sUSD") return false;
1882 
1883         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
1884     }
1885 
1886     /**
1887      * @notice Check if any rate is frozen (cannot be exchanged into)
1888      */
1889     function rateIsFrozen(bytes4 currencyKey)
1890         external
1891         view
1892         returns (bool)
1893     {
1894         return inversePricing[currencyKey].frozen;
1895     }
1896 
1897 
1898     /**
1899      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
1900      */
1901     function anyRateIsStale(bytes4[] currencyKeys)
1902         external
1903         view
1904         returns (bool)
1905     {
1906         // Loop through each key and check whether the data point is stale.
1907         uint256 i = 0;
1908 
1909         while (i < currencyKeys.length) {
1910             // sUSD is a special case and is never false
1911             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
1912                 return true;
1913             }
1914             i += 1;
1915         }
1916 
1917         return false;
1918     }
1919 
1920     /* ========== MODIFIERS ========== */
1921 
1922     modifier rateNotStale(bytes4 currencyKey) {
1923         require(!rateIsStale(currencyKey), "Rate stale or nonexistant currency");
1924         _;
1925     }
1926 
1927     modifier onlyOracle
1928     {
1929         require(msg.sender == oracle, "Only the oracle can perform this action");
1930         _;
1931     }
1932 
1933     /* ========== EVENTS ========== */
1934 
1935     event OracleUpdated(address newOracle);
1936     event RateStalePeriodUpdated(uint rateStalePeriod);
1937     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
1938     event RateDeleted(bytes4 currencyKey);
1939     event InversePriceConfigured(bytes4 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
1940     event InversePriceFrozen(bytes4 currencyKey);
1941 }
1942 
1943 
1944 /*
1945 -----------------------------------------------------------------
1946 FILE INFORMATION
1947 -----------------------------------------------------------------
1948 
1949 file:       LimitedSetup.sol
1950 version:    1.1
1951 author:     Anton Jurisevic
1952 
1953 date:       2018-05-15
1954 
1955 -----------------------------------------------------------------
1956 MODULE DESCRIPTION
1957 -----------------------------------------------------------------
1958 
1959 A contract with a limited setup period. Any function modified
1960 with the setup modifier will cease to work after the
1961 conclusion of the configurable-length post-construction setup period.
1962 
1963 -----------------------------------------------------------------
1964 */
1965 
1966 
1967 /**
1968  * @title Any function decorated with the modifier this contract provides
1969  * deactivates after a specified setup period.
1970  */
1971 contract LimitedSetup {
1972 
1973     uint setupExpiryTime;
1974 
1975     /**
1976      * @dev LimitedSetup Constructor.
1977      * @param setupDuration The time the setup period will last for.
1978      */
1979     constructor(uint setupDuration)
1980         public
1981     {
1982         setupExpiryTime = now + setupDuration;
1983     }
1984 
1985     modifier onlyDuringSetup
1986     {
1987         require(now < setupExpiryTime, "Can only perform this action during setup");
1988         _;
1989     }
1990 }
1991 
1992 
1993 contract ISynthetixState {
1994     // A struct for handing values associated with an individual user's debt position
1995     struct IssuanceData {
1996         // Percentage of the total debt owned at the time
1997         // of issuance. This number is modified by the global debt
1998         // delta array. You can figure out a user's exit price and
1999         // collateralisation ratio using a combination of their initial
2000         // debt and the slice of global debt delta which applies to them.
2001         uint initialDebtOwnership;
2002         // This lets us know when (in relative terms) the user entered
2003         // the debt pool so we can calculate their exit price and
2004         // collateralistion ratio
2005         uint debtEntryIndex;
2006     }
2007 
2008     uint[] public debtLedger;
2009     uint public issuanceRatio;
2010     mapping(address => IssuanceData) public issuanceData;
2011 
2012     function debtLedgerLength() external view returns (uint);
2013     function hasIssued(address account) external view returns (bool);
2014     function incrementTotalIssuerCount() external;
2015     function decrementTotalIssuerCount() external;
2016     function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
2017     function lastDebtLedgerEntry() external view returns (uint);
2018     function appendDebtLedgerValue(uint value) external;
2019     function clearIssuanceData(address account) external;
2020 }
2021 
2022 
2023 /*
2024 -----------------------------------------------------------------
2025 FILE INFORMATION
2026 -----------------------------------------------------------------
2027 
2028 file:       SynthetixState.sol
2029 version:    1.0
2030 author:     Kevin Brown
2031 date:       2018-10-19
2032 
2033 -----------------------------------------------------------------
2034 MODULE DESCRIPTION
2035 -----------------------------------------------------------------
2036 
2037 A contract that holds issuance state and preferred currency of
2038 users in the Synthetix system.
2039 
2040 This contract is used side by side with the Synthetix contract
2041 to make it easier to upgrade the contract logic while maintaining
2042 issuance state.
2043 
2044 The Synthetix contract is also quite large and on the edge of
2045 being beyond the contract size limit without moving this information
2046 out to another contract.
2047 
2048 The first deployed contract would create this state contract,
2049 using it as its store of issuance data.
2050 
2051 When a new contract is deployed, it links to the existing
2052 state contract, whose owner would then change its associated
2053 contract to the new one.
2054 
2055 -----------------------------------------------------------------
2056 */
2057 
2058 
2059 /**\
2060  * @title Synthetix State
2061  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
2062  */
2063 contract SynthetixState is ISynthetixState, State, LimitedSetup {
2064 
2065 
2066     using SafeMath for uint;
2067     using SafeDecimalMath for uint;
2068 
2069     // Issued synth balances for individual fee entitlements and exit price calculations
2070     mapping(address => IssuanceData) public issuanceData;
2071 
2072     // The total count of people that have outstanding issued synths in any flavour
2073     uint public totalIssuerCount;
2074 
2075     // Global debt pool tracking
2076     uint[] public debtLedger;
2077 
2078     // Import state
2079     uint public importedXDRAmount;
2080 
2081     // A quantity of synths greater than this ratio
2082     // may not be issued against a given value of SNX.
2083     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
2084     // No more synths may be issued than the value of SNX backing them.
2085     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
2086 
2087     // Users can specify their preferred currency, in which case all synths they receive
2088     // will automatically exchange to that preferred currency upon receipt in their wallet
2089     mapping(address => bytes4) public preferredCurrency;
2090 
2091     /**
2092      * @dev Constructor
2093      * @param _owner The address which controls this contract.
2094      * @param _associatedContract The ERC20 contract whose state this composes.
2095      */
2096     constructor(address _owner, address _associatedContract)
2097         State(_owner, _associatedContract)
2098         LimitedSetup(1 weeks)
2099         public
2100     {}
2101 
2102     /* ========== SETTERS ========== */
2103 
2104     /**
2105      * @notice Set issuance data for an address
2106      * @dev Only the associated contract may call this.
2107      * @param account The address to set the data for.
2108      * @param initialDebtOwnership The initial debt ownership for this address.
2109      */
2110     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
2111         external
2112         onlyAssociatedContract
2113     {
2114         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
2115         issuanceData[account].debtEntryIndex = debtLedger.length;
2116     }
2117 
2118     /**
2119      * @notice Clear issuance data for an address
2120      * @dev Only the associated contract may call this.
2121      * @param account The address to clear the data for.
2122      */
2123     function clearIssuanceData(address account)
2124         external
2125         onlyAssociatedContract
2126     {
2127         delete issuanceData[account];
2128     }
2129 
2130     /**
2131      * @notice Increment the total issuer count
2132      * @dev Only the associated contract may call this.
2133      */
2134     function incrementTotalIssuerCount()
2135         external
2136         onlyAssociatedContract
2137     {
2138         totalIssuerCount = totalIssuerCount.add(1);
2139     }
2140 
2141     /**
2142      * @notice Decrement the total issuer count
2143      * @dev Only the associated contract may call this.
2144      */
2145     function decrementTotalIssuerCount()
2146         external
2147         onlyAssociatedContract
2148     {
2149         totalIssuerCount = totalIssuerCount.sub(1);
2150     }
2151 
2152     /**
2153      * @notice Append a value to the debt ledger
2154      * @dev Only the associated contract may call this.
2155      * @param value The new value to be added to the debt ledger.
2156      */
2157     function appendDebtLedgerValue(uint value)
2158         external
2159         onlyAssociatedContract
2160     {
2161         debtLedger.push(value);
2162     }
2163 
2164     /**
2165      * @notice Set preferred currency for a user
2166      * @dev Only the associated contract may call this.
2167      * @param account The account to set the preferred currency for
2168      * @param currencyKey The new preferred currency
2169      */
2170     function setPreferredCurrency(address account, bytes4 currencyKey)
2171         external
2172         onlyAssociatedContract
2173     {
2174         preferredCurrency[account] = currencyKey;
2175     }
2176 
2177     /**
2178      * @notice Set the issuanceRatio for issuance calculations.
2179      * @dev Only callable by the contract owner.
2180      */
2181     function setIssuanceRatio(uint _issuanceRatio)
2182         external
2183         onlyOwner
2184     {
2185         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
2186         issuanceRatio = _issuanceRatio;
2187         emit IssuanceRatioUpdated(_issuanceRatio);
2188     }
2189 
2190     /**
2191      * @notice Import issuer data from the old Synthetix contract before multicurrency
2192      * @dev Only callable by the contract owner, and only for 1 week after deployment.
2193      */
2194     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
2195         external
2196         onlyOwner
2197         onlyDuringSetup
2198     {
2199         require(accounts.length == sUSDAmounts.length, "Length mismatch");
2200 
2201         for (uint8 i = 0; i < accounts.length; i++) {
2202             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
2203         }
2204     }
2205 
2206     /**
2207      * @notice Import issuer data from the old Synthetix contract before multicurrency
2208      * @dev Only used from importIssuerData above, meant to be disposable
2209      */
2210     function _addToDebtRegister(address account, uint amount)
2211         internal
2212     {
2213         // This code is duplicated from Synthetix so that we can call it directly here
2214         // during setup only.
2215         Synthetix synthetix = Synthetix(associatedContract);
2216 
2217         // What is the value of the requested debt in XDRs?
2218         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
2219 
2220         // What is the value that we've previously imported?
2221         uint totalDebtIssued = importedXDRAmount;
2222 
2223         // What will the new total be including the new value?
2224         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2225 
2226         // Save that for the next import.
2227         importedXDRAmount = newTotalDebtIssued;
2228 
2229         // What is their percentage (as a high precision int) of the total debt?
2230         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2231 
2232         // And what effect does this percentage have on the global debt holding of other issuers?
2233         // The delta specifically needs to not take into account any existing debt as it's already
2234         // accounted for in the delta from when they issued previously.
2235         // The delta is a high precision integer.
2236         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2237 
2238         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
2239 
2240         // And what does their debt ownership look like including this previous stake?
2241         if (existingDebt > 0) {
2242             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2243         }
2244 
2245         // Are they a new issuer? If so, record them.
2246         if (issuanceData[account].initialDebtOwnership == 0) {
2247             totalIssuerCount = totalIssuerCount.add(1);
2248         }
2249 
2250         // Save the debt entry parameters
2251         issuanceData[account].initialDebtOwnership = debtPercentage;
2252         issuanceData[account].debtEntryIndex = debtLedger.length;
2253 
2254         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2255         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2256         if (debtLedger.length > 0) {
2257             debtLedger.push(
2258                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2259             );
2260         } else {
2261             debtLedger.push(SafeDecimalMath.preciseUnit());
2262         }
2263     }
2264 
2265     /* ========== VIEWS ========== */
2266 
2267     /**
2268      * @notice Retrieve the length of the debt ledger array
2269      */
2270     function debtLedgerLength()
2271         external
2272         view
2273         returns (uint)
2274     {
2275         return debtLedger.length;
2276     }
2277 
2278     /**
2279      * @notice Retrieve the most recent entry from the debt ledger
2280      */
2281     function lastDebtLedgerEntry()
2282         external
2283         view
2284         returns (uint)
2285     {
2286         return debtLedger[debtLedger.length - 1];
2287     }
2288 
2289     /**
2290      * @notice Query whether an account has issued and has an outstanding debt balance
2291      * @param account The address to query for
2292      */
2293     function hasIssued(address account)
2294         external
2295         view
2296         returns (bool)
2297     {
2298         return issuanceData[account].initialDebtOwnership > 0;
2299     }
2300 
2301     event IssuanceRatioUpdated(uint newRatio);
2302 }
2303 
2304 
2305 contract IFeePool {
2306     address public FEE_ADDRESS;
2307     function amountReceivedFromExchange(uint value) external view returns (uint);
2308     function amountReceivedFromTransfer(uint value) external view returns (uint);
2309     function feePaid(bytes4 currencyKey, uint amount) external;
2310     function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
2311     function rewardsMinted(uint amount) external;
2312     function transferFeeIncurred(uint value) public view returns (uint);
2313 }
2314 
2315 
2316 /*
2317 -----------------------------------------------------------------
2318 FILE INFORMATION
2319 -----------------------------------------------------------------
2320 
2321 file:       Synth.sol
2322 version:    2.0
2323 author:     Kevin Brown
2324 date:       2018-09-13
2325 
2326 -----------------------------------------------------------------
2327 MODULE DESCRIPTION
2328 -----------------------------------------------------------------
2329 
2330 Synthetix-backed stablecoin contract.
2331 
2332 This contract issues synths, which are tokens that mirror various
2333 flavours of fiat currency.
2334 
2335 Synths are issuable by Synthetix Network Token (SNX) holders who
2336 have to lock up some value of their SNX to issue S * Cmax synths.
2337 Where Cmax issome value less than 1.
2338 
2339 A configurable fee is charged on synth transfers and deposited
2340 into a common pot, which Synthetix holders may withdraw from once
2341 per fee period.
2342 
2343 -----------------------------------------------------------------
2344 */
2345 
2346 
2347 contract Synth is ExternStateToken {
2348 
2349     /* ========== STATE VARIABLES ========== */
2350 
2351     IFeePool public feePool;
2352     Synthetix public synthetix;
2353 
2354     // Currency key which identifies this Synth to the Synthetix system
2355     bytes4 public currencyKey;
2356 
2357     uint8 constant DECIMALS = 18;
2358 
2359     /* ========== CONSTRUCTOR ========== */
2360 
2361     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, IFeePool _feePool,
2362         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey
2363     )
2364         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, 0, DECIMALS, _owner)
2365         public
2366     {
2367         require(_proxy != 0, "_proxy cannot be 0");
2368         require(address(_synthetix) != 0, "_synthetix cannot be 0");
2369         require(address(_feePool) != 0, "_feePool cannot be 0");
2370         require(_owner != 0, "_owner cannot be 0");
2371         require(_synthetix.synths(_currencyKey) == Synth(0), "Currency key is already in use");
2372 
2373         feePool = _feePool;
2374         synthetix = _synthetix;
2375         currencyKey = _currencyKey;
2376     }
2377 
2378     /* ========== SETTERS ========== */
2379 
2380     function setSynthetix(Synthetix _synthetix)
2381         external
2382         optionalProxy_onlyOwner
2383     {
2384         synthetix = _synthetix;
2385         emitSynthetixUpdated(_synthetix);
2386     }
2387 
2388     function setFeePool(IFeePool _feePool)
2389         external
2390         optionalProxy_onlyOwner
2391     {
2392         feePool = _feePool;
2393         emitFeePoolUpdated(_feePool);
2394     }
2395 
2396     /* ========== MUTATIVE FUNCTIONS ========== */
2397 
2398     /**
2399      * @notice Override ERC20 transfer function in order to
2400      * subtract the transaction fee and send it to the fee pool
2401      * for SNX holders to claim. */
2402     function transfer(address to, uint value)
2403         public
2404         optionalProxy
2405         notFeeAddress(messageSender)
2406         returns (bool)
2407     {
2408         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2409         uint fee = value.sub(amountReceived);
2410 
2411         // Send the fee off to the fee pool.
2412         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
2413 
2414         // And send their result off to the destination address
2415         bytes memory empty;
2416         return _internalTransfer(messageSender, to, amountReceived, empty);
2417     }
2418 
2419     /**
2420      * @notice Override ERC223 transfer function in order to
2421      * subtract the transaction fee and send it to the fee pool
2422      * for SNX holders to claim. */
2423     function transfer(address to, uint value, bytes data)
2424         public
2425         optionalProxy
2426         notFeeAddress(messageSender)
2427         returns (bool)
2428     {
2429         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2430         uint fee = value.sub(amountReceived);
2431 
2432         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2433         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
2434 
2435         // And send their result off to the destination address
2436         return _internalTransfer(messageSender, to, amountReceived, data);
2437     }
2438 
2439     /**
2440      * @notice Override ERC20 transferFrom function in order to
2441      * subtract the transaction fee and send it to the fee pool
2442      * for SNX holders to claim. */
2443     function transferFrom(address from, address to, uint value)
2444         public
2445         optionalProxy
2446         notFeeAddress(from)
2447         returns (bool)
2448     {
2449         // The fee is deducted from the amount sent.
2450         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2451         uint fee = value.sub(amountReceived);
2452 
2453         // Reduce the allowance by the amount we're transferring.
2454         // The safeSub call will handle an insufficient allowance.
2455         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
2456 
2457         // Send the fee off to the fee pool.
2458         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2459 
2460         bytes memory empty;
2461         return _internalTransfer(from, to, amountReceived, empty);
2462     }
2463 
2464     /**
2465      * @notice Override ERC223 transferFrom function in order to
2466      * subtract the transaction fee and send it to the fee pool
2467      * for SNX holders to claim. */
2468     function transferFrom(address from, address to, uint value, bytes data)
2469         public
2470         optionalProxy
2471         notFeeAddress(from)
2472         returns (bool)
2473     {
2474         // The fee is deducted from the amount sent.
2475         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2476         uint fee = value.sub(amountReceived);
2477 
2478         // Reduce the allowance by the amount we're transferring.
2479         // The safeSub call will handle an insufficient allowance.
2480         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
2481 
2482         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2483         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2484 
2485         return _internalTransfer(from, to, amountReceived, data);
2486     }
2487 
2488     /* Subtract the transfer fee from the senders account so the
2489      * receiver gets the exact amount specified to send. */
2490     function transferSenderPaysFee(address to, uint value)
2491         public
2492         optionalProxy
2493         notFeeAddress(messageSender)
2494         returns (bool)
2495     {
2496         uint fee = feePool.transferFeeIncurred(value);
2497 
2498         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2499         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
2500 
2501         // And send their transfer amount off to the destination address
2502         bytes memory empty;
2503         return _internalTransfer(messageSender, to, value, empty);
2504     }
2505 
2506     /* Subtract the transfer fee from the senders account so the
2507      * receiver gets the exact amount specified to send. */
2508     function transferSenderPaysFee(address to, uint value, bytes data)
2509         public
2510         optionalProxy
2511         notFeeAddress(messageSender)
2512         returns (bool)
2513     {
2514         uint fee = feePool.transferFeeIncurred(value);
2515 
2516         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2517         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
2518 
2519         // And send their transfer amount off to the destination address
2520         return _internalTransfer(messageSender, to, value, data);
2521     }
2522 
2523     /* Subtract the transfer fee from the senders account so the
2524      * to address receives the exact amount specified to send. */
2525     function transferFromSenderPaysFee(address from, address to, uint value)
2526         public
2527         optionalProxy
2528         notFeeAddress(from)
2529         returns (bool)
2530     {
2531         uint fee = feePool.transferFeeIncurred(value);
2532 
2533         // Reduce the allowance by the amount we're transferring.
2534         // The safeSub call will handle an insufficient allowance.
2535         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
2536 
2537         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2538         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2539 
2540         bytes memory empty;
2541         return _internalTransfer(from, to, value, empty);
2542     }
2543 
2544     /* Subtract the transfer fee from the senders account so the
2545      * to address receives the exact amount specified to send. */
2546     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
2547         public
2548         optionalProxy
2549         notFeeAddress(from)
2550         returns (bool)
2551     {
2552         uint fee = feePool.transferFeeIncurred(value);
2553 
2554         // Reduce the allowance by the amount we're transferring.
2555         // The safeSub call will handle an insufficient allowance.
2556         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
2557 
2558         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2559         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2560 
2561         return _internalTransfer(from, to, value, data);
2562     }
2563 
2564     // Override our internal transfer to inject preferred currency support
2565     function _internalTransfer(address from, address to, uint value, bytes data)
2566         internal
2567         returns (bool)
2568     {
2569         bytes4 preferredCurrencyKey = synthetix.synthetixState().preferredCurrency(to);
2570 
2571         // Do they have a preferred currency that's not us? If so we need to exchange
2572         if (preferredCurrencyKey != 0 && preferredCurrencyKey != currencyKey) {
2573             return synthetix.synthInitiatedExchange(from, currencyKey, value, preferredCurrencyKey, to);
2574         } else {
2575             // Otherwise we just transfer
2576             return super._internalTransfer(from, to, value, data);
2577         }
2578     }
2579 
2580     // Allow synthetix to issue a certain number of synths from an account.
2581     function issue(address account, uint amount)
2582         external
2583         onlySynthetixOrFeePool
2584     {
2585         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
2586         totalSupply = totalSupply.add(amount);
2587         emitTransfer(address(0), account, amount);
2588         emitIssued(account, amount);
2589     }
2590 
2591     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
2592     function burn(address account, uint amount)
2593         external
2594         onlySynthetixOrFeePool
2595     {
2596         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
2597         totalSupply = totalSupply.sub(amount);
2598         emitTransfer(account, address(0), amount);
2599         emitBurned(account, amount);
2600     }
2601 
2602     // Allow owner to set the total supply on import.
2603     function setTotalSupply(uint amount)
2604         external
2605         optionalProxy_onlyOwner
2606     {
2607         totalSupply = amount;
2608     }
2609 
2610     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
2611     // exchange as well as transfer
2612     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
2613         external
2614         onlySynthetixOrFeePool
2615     {
2616         bytes memory empty;
2617         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
2618     }
2619 
2620     /* ========== MODIFIERS ========== */
2621 
2622     modifier onlySynthetixOrFeePool() {
2623         bool isSynthetix = msg.sender == address(synthetix);
2624         bool isFeePool = msg.sender == address(feePool);
2625 
2626         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
2627         _;
2628     }
2629 
2630     modifier notFeeAddress(address account) {
2631         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
2632         _;
2633     }
2634 
2635     /* ========== EVENTS ========== */
2636 
2637     event SynthetixUpdated(address newSynthetix);
2638     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
2639     function emitSynthetixUpdated(address newSynthetix) internal {
2640         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
2641     }
2642 
2643     event FeePoolUpdated(address newFeePool);
2644     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
2645     function emitFeePoolUpdated(address newFeePool) internal {
2646         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
2647     }
2648 
2649     event Issued(address indexed account, uint value);
2650     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
2651     function emitIssued(address account, uint value) internal {
2652         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
2653     }
2654 
2655     event Burned(address indexed account, uint value);
2656     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
2657     function emitBurned(address account, uint value) internal {
2658         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
2659     }
2660 }
2661 
2662 
2663 /**
2664  * @title SynthetixEscrow interface
2665  */
2666 interface ISynthetixEscrow {
2667     function balanceOf(address account) public view returns (uint);
2668     function appendVestingEntry(address account, uint quantity) public;
2669 }
2670 
2671 
2672 /*
2673 -----------------------------------------------------------------
2674 FILE INFORMATION
2675 -----------------------------------------------------------------
2676 
2677 file:       Synthetix.sol
2678 version:    2.0
2679 author:     Kevin Brown
2680             Gavin Conway
2681 date:       2018-09-14
2682 
2683 -----------------------------------------------------------------
2684 MODULE DESCRIPTION
2685 -----------------------------------------------------------------
2686 
2687 Synthetix token contract. SNX is a transferable ERC20 token,
2688 and also give its holders the following privileges.
2689 An owner of SNX has the right to issue synths in all synth flavours.
2690 
2691 After a fee period terminates, the duration and fees collected for that
2692 period are computed, and the next period begins. Thus an account may only
2693 withdraw the fees owed to them for the previous period, and may only do
2694 so once per period. Any unclaimed fees roll over into the common pot for
2695 the next period.
2696 
2697 == Average Balance Calculations ==
2698 
2699 The fee entitlement of a synthetix holder is proportional to their average
2700 issued synth balance over the last fee period. This is computed by
2701 measuring the area under the graph of a user's issued synth balance over
2702 time, and then when a new fee period begins, dividing through by the
2703 duration of the fee period.
2704 
2705 We need only update values when the balances of an account is modified.
2706 This occurs when issuing or burning for issued synth balances,
2707 and when transferring for synthetix balances. This is for efficiency,
2708 and adds an implicit friction to interacting with SNX.
2709 A synthetix holder pays for his own recomputation whenever he wants to change
2710 his position, which saves the foundation having to maintain a pot dedicated
2711 to resourcing this.
2712 
2713 A hypothetical user's balance history over one fee period, pictorially:
2714 
2715       s ____
2716        |    |
2717        |    |___ p
2718        |____|___|___ __ _  _
2719        f    t   n
2720 
2721 Here, the balance was s between times f and t, at which time a transfer
2722 occurred, updating the balance to p, until n, when the present transfer occurs.
2723 When a new transfer occurs at time n, the balance being p,
2724 we must:
2725 
2726   - Add the area p * (n - t) to the total area recorded so far
2727   - Update the last transfer time to n
2728 
2729 So if this graph represents the entire current fee period,
2730 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
2731 The complementary computations must be performed for both sender and
2732 recipient.
2733 
2734 Note that a transfer keeps global supply of SNX invariant.
2735 The sum of all balances is constant, and unmodified by any transfer.
2736 So the sum of all balances multiplied by the duration of a fee period is also
2737 constant, and this is equivalent to the sum of the area of every user's
2738 time/balance graph. Dividing through by that duration yields back the total
2739 synthetix supply. So, at the end of a fee period, we really do yield a user's
2740 average share in the synthetix supply over that period.
2741 
2742 A slight wrinkle is introduced if we consider the time r when the fee period
2743 rolls over. Then the previous fee period k-1 is before r, and the current fee
2744 period k is afterwards. If the last transfer took place before r,
2745 but the latest transfer occurred afterwards:
2746 
2747 k-1       |        k
2748       s __|_
2749        |  | |
2750        |  | |____ p
2751        |__|_|____|___ __ _  _
2752           |
2753        f  | t    n
2754           r
2755 
2756 In this situation the area (r-f)*s contributes to fee period k-1, while
2757 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2758 zero-value transfer to have occurred at time r. Their fee entitlement for the
2759 previous period will be finalised at the time of their first transfer during the
2760 current fee period, or when they query or withdraw their fee entitlement.
2761 
2762 In the implementation, the duration of different fee periods may be slightly irregular,
2763 as the check that they have rolled over occurs only when state-changing synthetix
2764 operations are performed.
2765 
2766 == Issuance and Burning ==
2767 
2768 In this version of the synthetix contract, synths can only be issued by
2769 those that have been nominated by the synthetix foundation. Synths are assumed
2770 to be valued at $1, as they are a stable unit of account.
2771 
2772 All synths issued require a proportional value of SNX to be locked,
2773 where the proportion is governed by the current issuance ratio. This
2774 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
2775 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
2776 
2777 To determine the value of some amount of SNX(S), an oracle is used to push
2778 the price of SNX (P_S) in dollars to the contract. The value of S
2779 would then be: S * P_S.
2780 
2781 Any SNX that are locked up by this issuance process cannot be transferred.
2782 The amount that is locked floats based on the price of SNX. If the price
2783 of SNX moves up, less SNX are locked, so they can be issued against,
2784 or transferred freely. If the price of SNX moves down, more SNX are locked,
2785 even going above the initial wallet balance.
2786 
2787 -----------------------------------------------------------------
2788 */
2789 
2790 
2791 /**
2792  * @title Synthetix ERC20 contract.
2793  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2794  * but it also computes the quantity of fees each synthetix holder is entitled to.
2795  */
2796 contract Synthetix is ExternStateToken {
2797 
2798     // ========== STATE VARIABLES ==========
2799 
2800     // Available Synths which can be used with the system
2801     Synth[] public availableSynths;
2802     mapping(bytes4 => Synth) public synths;
2803 
2804     IFeePool public feePool;
2805     ISynthetixEscrow public escrow;
2806     ISynthetixEscrow public rewardEscrow;
2807     ExchangeRates public exchangeRates;
2808     SynthetixState public synthetixState;
2809     SupplySchedule public supplySchedule;
2810 
2811     uint constant SYNTHETIX_SUPPLY = 1e8 * SafeDecimalMath.unit();
2812     string constant TOKEN_NAME = "Synthetix Network Token";
2813     string constant TOKEN_SYMBOL = "SNX";
2814     uint8 constant DECIMALS = 18;
2815     // ========== CONSTRUCTOR ==========
2816 
2817     /**
2818      * @dev Constructor
2819      * @param _tokenState A pre-populated contract containing token balances.
2820      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2821      * @param _owner The owner of this contract.
2822      */
2823     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2824         address _owner, ExchangeRates _exchangeRates, IFeePool _feePool, SupplySchedule _supplySchedule,
2825         ISynthetixEscrow _rewardEscrow, ISynthetixEscrow _escrow
2826     )
2827         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, SYNTHETIX_SUPPLY, DECIMALS, _owner)
2828         public
2829     {
2830         synthetixState = _synthetixState;
2831         exchangeRates = _exchangeRates;
2832         feePool = _feePool;
2833         supplySchedule = _supplySchedule;
2834         rewardEscrow = _rewardEscrow;
2835         escrow = _escrow;
2836     }
2837     // ========== SETTERS ========== */
2838 
2839     function setFeePool(IFeePool _feePool)
2840         external
2841         optionalProxy_onlyOwner
2842     {
2843         feePool = _feePool;
2844     }
2845 
2846     function setExchangeRates(ExchangeRates _exchangeRates)
2847         external
2848         optionalProxy_onlyOwner
2849     {
2850         exchangeRates = _exchangeRates;
2851     }
2852 
2853     /**
2854      * @notice Add an associated Synth contract to the Synthetix system
2855      * @dev Only the contract owner may call this.
2856      */
2857     function addSynth(Synth synth)
2858         external
2859         optionalProxy_onlyOwner
2860     {
2861         bytes4 currencyKey = synth.currencyKey();
2862 
2863         require(synths[currencyKey] == Synth(0), "Synth already exists");
2864 
2865         availableSynths.push(synth);
2866         synths[currencyKey] = synth;
2867     }
2868 
2869     /**
2870      * @notice Remove an associated Synth contract from the Synthetix system
2871      * @dev Only the contract owner may call this.
2872      */
2873     function removeSynth(bytes4 currencyKey)
2874         external
2875         optionalProxy_onlyOwner
2876     {
2877         require(synths[currencyKey] != address(0), "Synth does not exist");
2878         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2879         require(currencyKey != "XDR", "Cannot remove XDR synth");
2880 
2881         // Save the address we're removing for emitting the event at the end.
2882         address synthToRemove = synths[currencyKey];
2883 
2884         // Remove the synth from the availableSynths array.
2885         for (uint8 i = 0; i < availableSynths.length; i++) {
2886             if (availableSynths[i] == synthToRemove) {
2887                 delete availableSynths[i];
2888 
2889                 // Copy the last synth into the place of the one we just deleted
2890                 // If there's only one synth, this is synths[0] = synths[0].
2891                 // If we're deleting the last one, it's also a NOOP in the same way.
2892                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2893 
2894                 // Decrease the size of the array by one.
2895                 availableSynths.length--;
2896 
2897                 break;
2898             }
2899         }
2900 
2901         // And remove it from the synths mapping
2902         delete synths[currencyKey];
2903 
2904         // Note: No event here as our contract exceeds max contract size
2905         // with these events, and it's unlikely people will need to
2906         // track these events specifically.
2907     }
2908 
2909     // ========== VIEWS ==========
2910 
2911     /**
2912      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2913      * @param sourceCurrencyKey The currency the amount is specified in
2914      * @param sourceAmount The source amount, specified in UNIT base
2915      * @param destinationCurrencyKey The destination currency
2916      */
2917     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
2918         public
2919         view
2920         rateNotStale(sourceCurrencyKey)
2921         rateNotStale(destinationCurrencyKey)
2922         returns (uint)
2923     {
2924         // If there's no change in the currency, then just return the amount they gave us
2925         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
2926 
2927         // Calculate the effective value by going from source -> USD -> destination
2928         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
2929             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
2930     }
2931 
2932     /**
2933      * @notice Total amount of synths issued by the system, priced in currencyKey
2934      * @param currencyKey The currency to value the synths in
2935      */
2936     function totalIssuedSynths(bytes4 currencyKey)
2937         public
2938         view
2939         rateNotStale(currencyKey)
2940         returns (uint)
2941     {
2942         uint total = 0;
2943         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2944 
2945         require(!exchangeRates.anyRateIsStale(availableCurrencyKeys()), "Rates are stale");
2946 
2947         for (uint8 i = 0; i < availableSynths.length; i++) {
2948             // What's the total issued value of that synth in the destination currency?
2949             // Note: We're not using our effectiveValue function because we don't want to go get the
2950             //       rate for the destination currency and check if it's stale repeatedly on every
2951             //       iteration of the loop
2952             uint synthValue = availableSynths[i].totalSupply()
2953                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
2954                 .divideDecimalRound(currencyRate);
2955             total = total.add(synthValue);
2956         }
2957 
2958         return total;
2959     }
2960 
2961     /**
2962      * @notice Returns the currencyKeys of availableSynths for rate checking
2963      */
2964     function availableCurrencyKeys()
2965         internal
2966         view
2967         returns (bytes4[])
2968     {
2969         bytes4[] memory availableCurrencyKeys = new bytes4[](availableSynths.length);
2970 
2971         for (uint8 i = 0; i < availableSynths.length; i++) {
2972             availableCurrencyKeys[i] = availableSynths[i].currencyKey();
2973         }
2974 
2975         return availableCurrencyKeys;
2976     }
2977 
2978     /**
2979      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
2980      */
2981     function availableSynthCount()
2982         public
2983         view
2984         returns (uint)
2985     {
2986         return availableSynths.length;
2987     }
2988 
2989     // ========== MUTATIVE FUNCTIONS ==========
2990 
2991     /**
2992      * @notice ERC20 transfer function.
2993      */
2994     function transfer(address to, uint value)
2995         public
2996         returns (bool)
2997     {
2998         bytes memory empty;
2999         return transfer(to, value, empty);
3000     }
3001 
3002     /**
3003      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
3004      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3005      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3006      *           tooling such as Etherscan.
3007      */
3008     function transfer(address to, uint value, bytes data)
3009         public
3010         optionalProxy
3011         returns (bool)
3012     {
3013         // Ensure they're not trying to exceed their locked amount
3014         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
3015 
3016         // Perform the transfer: if there is a problem an exception will be thrown in this call.
3017         _transfer_byProxy(messageSender, to, value, data);
3018 
3019         return true;
3020     }
3021 
3022     /**
3023      * @notice ERC20 transferFrom function.
3024      */
3025     function transferFrom(address from, address to, uint value)
3026         public
3027         returns (bool)
3028     {
3029         bytes memory empty;
3030         return transferFrom(from, to, value, empty);
3031     }
3032 
3033     /**
3034      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
3035      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3036      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3037      *           tooling such as Etherscan.
3038      */
3039     function transferFrom(address from, address to, uint value, bytes data)
3040         public
3041         optionalProxy
3042         returns (bool)
3043     {
3044         // Ensure they're not trying to exceed their locked amount
3045         require(value <= transferableSynthetix(from), "Insufficient balance");
3046 
3047         // Perform the transfer: if there is a problem,
3048         // an exception will be thrown in this call.
3049         _transferFrom_byProxy(messageSender, from, to, value, data);
3050 
3051         return true;
3052     }
3053 
3054     /**
3055      * @notice Function that allows you to exchange synths you hold in one flavour for another.
3056      * @param sourceCurrencyKey The source currency you wish to exchange from
3057      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3058      * @param destinationCurrencyKey The destination currency you wish to obtain.
3059      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
3060      * @return Boolean that indicates whether the transfer succeeded or failed.
3061      */
3062     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
3063         external
3064         optionalProxy
3065         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
3066         returns (bool)
3067     {
3068         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
3069         require(sourceAmount > 0, "Zero amount");
3070 
3071         // Pass it along, defaulting to the sender as the recipient.
3072         return _internalExchange(
3073             messageSender,
3074             sourceCurrencyKey,
3075             sourceAmount,
3076             destinationCurrencyKey,
3077             destinationAddress == address(0) ? messageSender : destinationAddress,
3078             true // Charge fee on the exchange
3079         );
3080     }
3081 
3082     /**
3083      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
3084      * @dev Only the synth contract can call this function
3085      * @param from The address to exchange / burn synth from
3086      * @param sourceCurrencyKey The source currency you wish to exchange from
3087      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3088      * @param destinationCurrencyKey The destination currency you wish to obtain.
3089      * @param destinationAddress Where the result should go.
3090      * @return Boolean that indicates whether the transfer succeeded or failed.
3091      */
3092     function synthInitiatedExchange(
3093         address from,
3094         bytes4 sourceCurrencyKey,
3095         uint sourceAmount,
3096         bytes4 destinationCurrencyKey,
3097         address destinationAddress
3098     )
3099         external
3100         onlySynth
3101         returns (bool)
3102     {
3103         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3104         require(sourceAmount > 0, "Zero amount");
3105 
3106         // Pass it along
3107         return _internalExchange(
3108             from,
3109             sourceCurrencyKey,
3110             sourceAmount,
3111             destinationCurrencyKey,
3112             destinationAddress,
3113             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
3114         );
3115     }
3116 
3117     /**
3118      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3119      * @dev Only the synth contract can call this function.
3120      * @param from The address fee is coming from.
3121      * @param sourceCurrencyKey source currency fee from.
3122      * @param sourceAmount The amount, specified in UNIT of source currency.
3123      * @return Boolean that indicates whether the transfer succeeded or failed.
3124      */
3125     function synthInitiatedFeePayment(
3126         address from,
3127         bytes4 sourceCurrencyKey,
3128         uint sourceAmount
3129     )
3130         external
3131         onlySynth
3132         returns (bool)
3133     {
3134         // Allow fee to be 0 and skip minting XDRs to feePool
3135         if (sourceAmount == 0) {
3136             return true;
3137         }
3138 
3139         require(sourceAmount > 0, "Source can't be 0");
3140 
3141         // Pass it along, defaulting to the sender as the recipient.
3142         bool result = _internalExchange(
3143             from,
3144             sourceCurrencyKey,
3145             sourceAmount,
3146             "XDR",
3147             feePool.FEE_ADDRESS(),
3148             false // Don't charge a fee on the exchange because this is already a fee
3149         );
3150 
3151         // Tell the fee pool about this.
3152         feePool.feePaid(sourceCurrencyKey, sourceAmount);
3153 
3154         return result;
3155     }
3156 
3157     /**
3158      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3159      * @dev fee pool contract address is not allowed to call function
3160      * @param from The address to move synth from
3161      * @param sourceCurrencyKey source currency from.
3162      * @param sourceAmount The amount, specified in UNIT of source currency.
3163      * @param destinationCurrencyKey The destination currency to obtain.
3164      * @param destinationAddress Where the result should go.
3165      * @param chargeFee Boolean to charge a fee for transaction.
3166      * @return Boolean that indicates whether the transfer succeeded or failed.
3167      */
3168     function _internalExchange(
3169         address from,
3170         bytes4 sourceCurrencyKey,
3171         uint sourceAmount,
3172         bytes4 destinationCurrencyKey,
3173         address destinationAddress,
3174         bool chargeFee
3175     )
3176         internal
3177         notFeeAddress(from)
3178         returns (bool)
3179     {
3180         require(destinationAddress != address(0), "Zero destination");
3181         require(destinationAddress != address(this), "Synthetix is invalid destination");
3182         require(destinationAddress != address(proxy), "Proxy is invalid destination");
3183 
3184         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3185         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3186 
3187         // Burn the source amount
3188         synths[sourceCurrencyKey].burn(from, sourceAmount);
3189 
3190         // How much should they get in the destination currency?
3191         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3192 
3193         // What's the fee on that currency that we should deduct?
3194         uint amountReceived = destinationAmount;
3195         uint fee = 0;
3196 
3197         if (chargeFee) {
3198             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
3199             fee = destinationAmount.sub(amountReceived);
3200         }
3201 
3202         // Issue their new synths
3203         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3204 
3205         // Remit the fee in XDRs
3206         if (fee > 0) {
3207             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3208             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3209             // Tell the fee pool about this.
3210             feePool.feePaid("XDR", xdrFeeAmount);
3211         }
3212 
3213         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3214 
3215         // Call the ERC223 transfer callback if needed
3216         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
3217 
3218         //Let the DApps know there was a Synth exchange
3219         emitSynthExchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, amountReceived, destinationAddress);
3220 
3221         return true;
3222     }
3223 
3224     /**
3225      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
3226      * @dev Only internal calls from synthetix address.
3227      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3228      * @param amount The amount of synths to register with a base of UNIT
3229      */
3230     function _addToDebtRegister(bytes4 currencyKey, uint amount)
3231         internal
3232         optionalProxy
3233     {
3234         // What is the value of the requested debt in XDRs?
3235         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3236 
3237         // What is the value of all issued synths of the system (priced in XDRs)?
3238         uint totalDebtIssued = totalIssuedSynths("XDR");
3239 
3240         // What will the new total be including the new value?
3241         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3242 
3243         // What is their percentage (as a high precision int) of the total debt?
3244         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3245 
3246         // And what effect does this percentage change have on the global debt holding of other issuers?
3247         // The delta specifically needs to not take into account any existing debt as it's already
3248         // accounted for in the delta from when they issued previously.
3249         // The delta is a high precision integer.
3250         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3251 
3252         // How much existing debt do they have?
3253         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3254 
3255         // And what does their debt ownership look like including this previous stake?
3256         if (existingDebt > 0) {
3257             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3258         }
3259 
3260         // Are they a new issuer? If so, record them.
3261         if (!synthetixState.hasIssued(messageSender)) {
3262             synthetixState.incrementTotalIssuerCount();
3263         }
3264 
3265         // Save the debt entry parameters
3266         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3267 
3268         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3269         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3270         if (synthetixState.debtLedgerLength() > 0) {
3271             synthetixState.appendDebtLedgerValue(
3272                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3273             );
3274         } else {
3275             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3276         }
3277     }
3278 
3279     /**
3280      * @notice Issue synths against the sender's SNX.
3281      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3282      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3283      * @param amount The amount of synths you wish to issue with a base of UNIT
3284      */
3285     function issueSynths(bytes4 currencyKey, uint amount)
3286         public
3287         optionalProxy
3288         // No need to check if price is stale, as it is checked in issuableSynths.
3289     {
3290         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3291 
3292         // Keep track of the debt they're about to create
3293         _addToDebtRegister(currencyKey, amount);
3294 
3295         // Create their synths
3296         synths[currencyKey].issue(messageSender, amount);
3297 
3298         // Store their locked SNX amount to determine their fee % for the period
3299         _appendAccountIssuanceRecord();
3300     }
3301 
3302     /**
3303      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3304      * @dev Issuance is only allowed if the synthetix price isn't stale.
3305      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3306      */
3307     function issueMaxSynths(bytes4 currencyKey)
3308         external
3309         optionalProxy
3310     {
3311         // Figure out the maximum we can issue in that currency
3312         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3313 
3314         // And issue them
3315         issueSynths(currencyKey, maxIssuable);
3316     }
3317 
3318     /**
3319      * @notice Burn synths to clear issued synths/free SNX.
3320      * @param currencyKey The currency you're specifying to burn
3321      * @param amount The amount (in UNIT base) you wish to burn
3322      * @dev The amount to burn is debased to XDR's
3323      */
3324     function burnSynths(bytes4 currencyKey, uint amount)
3325         external
3326         optionalProxy
3327         // No need to check for stale rates as effectiveValue checks rates
3328     {
3329         // How much debt do they have?
3330         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3331         uint debt = debtBalanceOf(messageSender, "XDR");
3332         uint debtInCurrencyKey = debtBalanceOf(messageSender, currencyKey);
3333 
3334         require(debt > 0, "No debt to forgive");
3335 
3336         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3337         // clear their debt and leave them be.
3338         uint amountToRemove = debt < debtToRemove ? debt : debtToRemove;
3339 
3340         // Remove their debt from the ledger
3341         _removeFromDebtRegister(amountToRemove);
3342 
3343         uint amountToBurn = debtInCurrencyKey < amount ? debtInCurrencyKey : amount;
3344 
3345         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3346         synths[currencyKey].burn(messageSender, amountToBurn);
3347 
3348         // Store their debtRatio against a feeperiod to determine their fee/rewards % for the period
3349         _appendAccountIssuanceRecord();
3350     }
3351 
3352     /**
3353      * @notice Store in the FeePool the users current debt value in the system in XDRs.
3354      * @dev debtBalanceOf(messageSender, "XDR") to be used with totalIssuedSynths("XDR") to get
3355      *  users % of the system within a feePeriod.
3356      */
3357     function _appendAccountIssuanceRecord()
3358         internal
3359     {
3360         uint initialDebtOwnership;
3361         uint debtEntryIndex;
3362         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(messageSender);
3363 
3364         feePool.appendAccountIssuanceRecord(
3365             messageSender,
3366             initialDebtOwnership,
3367             debtEntryIndex
3368         );
3369     }
3370 
3371     /**
3372      * @notice Remove a debt position from the register
3373      * @param amount The amount (in UNIT base) being presented in XDRs
3374      */
3375     function _removeFromDebtRegister(uint amount)
3376         internal
3377     {
3378         uint debtToRemove = amount;
3379 
3380         // How much debt do they have?
3381         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3382 
3383         // What is the value of all issued synths of the system (priced in XDRs)?
3384         uint totalDebtIssued = totalIssuedSynths("XDR");
3385 
3386         // What will the new total after taking out the withdrawn amount
3387         uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3388 
3389         uint delta;
3390 
3391         // What will the debt delta be if there is any debt left?
3392         // Set delta to 0 if no more debt left in system after user
3393         if (newTotalDebtIssued > 0) {
3394 
3395             // What is the percentage of the withdrawn debt (as a high precision int) of the total debt after?
3396             uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(newTotalDebtIssued);
3397 
3398             // And what effect does this percentage change have on the global debt holding of other issuers?
3399             // The delta specifically needs to not take into account any existing debt as it's already
3400             // accounted for in the delta from when they issued previously.
3401             delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3402         } else {
3403             delta = 0;
3404         }
3405 
3406         // Are they exiting the system, or are they just decreasing their debt position?
3407         if (debtToRemove == existingDebt) {
3408             synthetixState.setCurrentIssuanceData(messageSender, 0);
3409             synthetixState.decrementTotalIssuerCount();
3410         } else {
3411             // What percentage of the debt will they be left with?
3412             uint newDebt = existingDebt.sub(debtToRemove);
3413             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3414 
3415             // Store the debt percentage and debt ledger as high precision integers
3416             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3417         }
3418 
3419         // Update our cumulative ledger. This is also a high precision integer.
3420         synthetixState.appendDebtLedgerValue(
3421             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3422         );
3423     }
3424 
3425     // ========== Issuance/Burning ==========
3426 
3427     /**
3428      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3429      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3430      */
3431     function maxIssuableSynths(address issuer, bytes4 currencyKey)
3432         public
3433         view
3434         // We don't need to check stale rates here as effectiveValue will do it for us.
3435         returns (uint)
3436     {
3437         // What is the value of their SNX balance in the destination currency?
3438         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3439 
3440         // They're allowed to issue up to issuanceRatio of that value
3441         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3442     }
3443 
3444     /**
3445      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3446      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
3447      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3448      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
3449      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3450      * altering the amount of fees they're able to claim from the system.
3451      */
3452     function collateralisationRatio(address issuer)
3453         public
3454         view
3455         returns (uint)
3456     {
3457         uint totalOwnedSynthetix = collateral(issuer);
3458         if (totalOwnedSynthetix == 0) return 0;
3459 
3460         uint debtBalance = debtBalanceOf(issuer, "SNX");
3461         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3462     }
3463 
3464     /**
3465      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3466      * will tell you how many synths a user has to give back to the system in order to unlock their original
3467      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3468      * the debt in sUSD, XDR, or any other synth you wish.
3469      */
3470     function debtBalanceOf(address issuer, bytes4 currencyKey)
3471         public
3472         view
3473         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3474         returns (uint)
3475     {
3476         // What was their initial debt ownership?
3477         uint initialDebtOwnership;
3478         uint debtEntryIndex;
3479         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3480 
3481         // If it's zero, they haven't issued, and they have no debt.
3482         if (initialDebtOwnership == 0) return 0;
3483 
3484         // Figure out the global debt percentage delta from when they entered the system.
3485         // This is a high precision integer.
3486         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3487             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3488             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3489 
3490         // What's the total value of the system in their requested currency?
3491         uint totalSystemValue = totalIssuedSynths(currencyKey);
3492 
3493         // Their debt balance is their portion of the total system value.
3494         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3495             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3496 
3497         return highPrecisionBalance.preciseDecimalToDecimal();
3498     }
3499 
3500     /**
3501      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3502      * @param issuer The account that intends to issue
3503      * @param currencyKey The currency to price issuable value in
3504      */
3505     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
3506         public
3507         view
3508         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3509         returns (uint)
3510     {
3511         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3512         uint max = maxIssuableSynths(issuer, currencyKey);
3513 
3514         if (alreadyIssued >= max) {
3515             return 0;
3516         } else {
3517             return max.sub(alreadyIssued);
3518         }
3519     }
3520 
3521     /**
3522      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3523      * against which synths can be issued.
3524      * This includes those already being used as collateral (locked), and those
3525      * available for further issuance (unlocked).
3526      */
3527     function collateral(address account)
3528         public
3529         view
3530         returns (uint)
3531     {
3532         uint balance = tokenState.balanceOf(account);
3533 
3534         if (escrow != address(0)) {
3535             balance = balance.add(escrow.balanceOf(account));
3536         }
3537 
3538         if (rewardEscrow != address(0)) {
3539             balance = balance.add(rewardEscrow.balanceOf(account));
3540         }
3541 
3542         return balance;
3543     }
3544 
3545     /**
3546      * @notice The number of SNX that are free to be transferred by an account.
3547      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
3548      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
3549      * in this calculation.
3550      */
3551     function transferableSynthetix(address account)
3552         public
3553         view
3554         rateNotStale("SNX")
3555         returns (uint)
3556     {
3557         // How many SNX do they have, excluding escrow?
3558         // Note: We're excluding escrow here because we're interested in their transferable amount
3559         // and escrowed SNX are not transferable.
3560         uint balance = tokenState.balanceOf(account);
3561 
3562         // How many of those will be locked by the amount they've issued?
3563         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3564         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3565         // The locked synthetix value can exceed their balance.
3566         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3567 
3568         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3569         if (lockedSynthetixValue >= balance) {
3570             return 0;
3571         } else {
3572             return balance.sub(lockedSynthetixValue);
3573         }
3574     }
3575 
3576     function mint()
3577         external
3578         returns (bool)
3579     {
3580         require(rewardEscrow != address(0), "Reward Escrow destination missing");
3581 
3582         uint supplyToMint = supplySchedule.mintableSupply();
3583         require(supplyToMint > 0, "No supply is mintable");
3584 
3585         supplySchedule.updateMintValues();
3586 
3587         // Set minted SNX balance to RewardEscrow's balance
3588         // Minus the minterReward and set balance of minter to add reward
3589         uint minterReward = supplySchedule.minterReward();
3590 
3591         tokenState.setBalanceOf(rewardEscrow, tokenState.balanceOf(rewardEscrow).add(supplyToMint.sub(minterReward)));
3592         emitTransfer(this, rewardEscrow, supplyToMint.sub(minterReward));
3593 
3594         // Tell the FeePool how much it has to distribute
3595         feePool.rewardsMinted(supplyToMint.sub(minterReward));
3596 
3597         // Assign the minters reward.
3598         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
3599         emitTransfer(this, msg.sender, minterReward);
3600 
3601         totalSupply = totalSupply.add(supplyToMint);
3602     }
3603 
3604     // ========== MODIFIERS ==========
3605 
3606     modifier rateNotStale(bytes4 currencyKey) {
3607         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
3608         _;
3609     }
3610 
3611     modifier notFeeAddress(address account) {
3612         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3613         _;
3614     }
3615 
3616     modifier onlySynth() {
3617         bool isSynth = false;
3618 
3619         // No need to repeatedly call this function either
3620         for (uint8 i = 0; i < availableSynths.length; i++) {
3621             if (availableSynths[i] == msg.sender) {
3622                 isSynth = true;
3623                 break;
3624             }
3625         }
3626 
3627         require(isSynth, "Only synth allowed");
3628         _;
3629     }
3630 
3631     modifier nonZeroAmount(uint _amount) {
3632         require(_amount > 0, "Amount needs to be larger than 0");
3633         _;
3634     }
3635 
3636     // ========== EVENTS ==========
3637     /* solium-disable */
3638     event SynthExchange(address indexed account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey,  uint256 toAmount, address toAddress);
3639     bytes32 constant SYNTHEXCHANGE_SIG = keccak256("SynthExchange(address,bytes4,uint256,bytes4,uint256,address)");
3640     function emitSynthExchange(address account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey, uint256 toAmount, address toAddress) internal {
3641         proxy._emit(abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress), 2, SYNTHEXCHANGE_SIG, bytes32(account), 0, 0);
3642     }
3643     /* solium-enable */
3644 }