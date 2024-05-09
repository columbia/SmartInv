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
851     Proxy public integrationProxy;
852 
853     /* The caller of the proxy, passed through to this contract.
854      * Note that every function using this member must apply the onlyProxy or
855      * optionalProxy modifiers, otherwise their invocations can use stale values. */
856     address messageSender;
857 
858     constructor(address _proxy, address _owner)
859         Owned(_owner)
860         public
861     {
862         proxy = Proxy(_proxy);
863         emit ProxyUpdated(_proxy);
864     }
865 
866     function setProxy(address _proxy)
867         external
868         onlyOwner
869     {
870         proxy = Proxy(_proxy);
871         emit ProxyUpdated(_proxy);
872     }
873 
874     function setIntegrationProxy(address _integrationProxy)
875         external
876         onlyOwner
877     {
878         integrationProxy = Proxy(_integrationProxy);
879     }
880 
881     function setMessageSender(address sender)
882         external
883         onlyProxy
884     {
885         messageSender = sender;
886     }
887 
888     modifier onlyProxy {
889         require(Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy, "Only the proxy can call");
890         _;
891     }
892 
893     modifier optionalProxy
894     {
895         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy) {
896             messageSender = msg.sender;
897         }
898         _;
899     }
900 
901     modifier optionalProxy_onlyOwner
902     {
903         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy) {
904             messageSender = msg.sender;
905         }
906         require(messageSender == owner, "Owner only function");
907         _;
908     }
909 
910     event ProxyUpdated(address proxyAddress);
911 }
912 
913 
914 /*
915 -----------------------------------------------------------------
916 FILE INFORMATION
917 -----------------------------------------------------------------
918 
919 file:       ExternStateToken.sol
920 version:    1.0
921 author:     Kevin Brown
922 date:       2018-08-06
923 
924 -----------------------------------------------------------------
925 MODULE DESCRIPTION
926 -----------------------------------------------------------------
927 
928 This contract offers a modifer that can prevent reentrancy on
929 particular actions. It will not work if you put it on multiple
930 functions that can be called from each other. Specifically guard
931 external entry points to the contract with the modifier only.
932 
933 -----------------------------------------------------------------
934 */
935 
936 
937 contract ReentrancyPreventer {
938     /* ========== MODIFIERS ========== */
939     bool isInFunctionBody = false;
940 
941     modifier preventReentrancy {
942         require(!isInFunctionBody, "Reverted to prevent reentrancy");
943         isInFunctionBody = true;
944         _;
945         isInFunctionBody = false;
946     }
947 }
948 
949 /*
950 -----------------------------------------------------------------
951 FILE INFORMATION
952 -----------------------------------------------------------------
953 
954 file:       TokenFallback.sol
955 version:    1.0
956 author:     Kevin Brown
957 date:       2018-08-10
958 
959 -----------------------------------------------------------------
960 MODULE DESCRIPTION
961 -----------------------------------------------------------------
962 
963 This contract provides the logic that's used to call tokenFallback()
964 when transfers happen.
965 
966 It's pulled out into its own module because it's needed in two
967 places, so instead of copy/pasting this logic and maininting it
968 both in Fee Token and Extern State Token, it's here and depended
969 on by both contracts.
970 
971 -----------------------------------------------------------------
972 */
973 
974 
975 contract TokenFallbackCaller is ReentrancyPreventer {
976     function callTokenFallbackIfNeeded(address sender, address recipient, uint amount, bytes data)
977         internal
978         preventReentrancy
979     {
980         /*
981             If we're transferring to a contract and it implements the tokenFallback function, call it.
982             This isn't ERC223 compliant because we don't revert if the contract doesn't implement tokenFallback.
983             This is because many DEXes and other contracts that expect to work with the standard
984             approve / transferFrom workflow don't implement tokenFallback but can still process our tokens as
985             usual, so it feels very harsh and likely to cause trouble if we add this restriction after having
986             previously gone live with a vanilla ERC20.
987         */
988 
989         // Is the to address a contract? We can check the code size on that address and know.
990         uint length;
991 
992         // solium-disable-next-line security/no-inline-assembly
993         assembly {
994             // Retrieve the size of the code on the recipient address
995             length := extcodesize(recipient)
996         }
997 
998         // If there's code there, it's a contract
999         if (length > 0) {
1000             // Now we need to optionally call tokenFallback(address from, uint value).
1001             // We can't call it the normal way because that reverts when the recipient doesn't implement the function.
1002 
1003             // solium-disable-next-line security/no-low-level-calls
1004             recipient.call(abi.encodeWithSignature("tokenFallback(address,uint256,bytes)", sender, amount, data));
1005 
1006             // And yes, we specifically don't care if this call fails, so we're not checking the return value.
1007         }
1008     }
1009 }
1010 
1011 
1012 /*
1013 -----------------------------------------------------------------
1014 FILE INFORMATION
1015 -----------------------------------------------------------------
1016 
1017 file:       ExternStateToken.sol
1018 version:    1.3
1019 author:     Anton Jurisevic
1020             Dominic Romanowski
1021             Kevin Brown
1022 
1023 date:       2018-05-29
1024 
1025 -----------------------------------------------------------------
1026 MODULE DESCRIPTION
1027 -----------------------------------------------------------------
1028 
1029 A partial ERC20 token contract, designed to operate with a proxy.
1030 To produce a complete ERC20 token, transfer and transferFrom
1031 tokens must be implemented, using the provided _byProxy internal
1032 functions.
1033 This contract utilises an external state for upgradeability.
1034 
1035 -----------------------------------------------------------------
1036 */
1037 
1038 
1039 /**
1040  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
1041  */
1042 contract ExternStateToken is SelfDestructible, Proxyable, TokenFallbackCaller {
1043 
1044     using SafeMath for uint;
1045     using SafeDecimalMath for uint;
1046 
1047     /* ========== STATE VARIABLES ========== */
1048 
1049     /* Stores balances and allowances. */
1050     TokenState public tokenState;
1051 
1052     /* Other ERC20 fields. */
1053     string public name;
1054     string public symbol;
1055     uint public totalSupply;
1056     uint8 public decimals;
1057 
1058     /**
1059      * @dev Constructor.
1060      * @param _proxy The proxy associated with this contract.
1061      * @param _name Token's ERC20 name.
1062      * @param _symbol Token's ERC20 symbol.
1063      * @param _totalSupply The total supply of the token.
1064      * @param _tokenState The TokenState contract address.
1065      * @param _owner The owner of this contract.
1066      */
1067     constructor(address _proxy, TokenState _tokenState,
1068                 string _name, string _symbol, uint _totalSupply,
1069                 uint8 _decimals, address _owner)
1070         SelfDestructible(_owner)
1071         Proxyable(_proxy, _owner)
1072         public
1073     {
1074         tokenState = _tokenState;
1075 
1076         name = _name;
1077         symbol = _symbol;
1078         totalSupply = _totalSupply;
1079         decimals = _decimals;
1080     }
1081 
1082     /* ========== VIEWS ========== */
1083 
1084     /**
1085      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
1086      * @param owner The party authorising spending of their funds.
1087      * @param spender The party spending tokenOwner's funds.
1088      */
1089     function allowance(address owner, address spender)
1090         public
1091         view
1092         returns (uint)
1093     {
1094         return tokenState.allowance(owner, spender);
1095     }
1096 
1097     /**
1098      * @notice Returns the ERC20 token balance of a given account.
1099      */
1100     function balanceOf(address account)
1101         public
1102         view
1103         returns (uint)
1104     {
1105         return tokenState.balanceOf(account);
1106     }
1107 
1108     /* ========== MUTATIVE FUNCTIONS ========== */
1109 
1110     /**
1111      * @notice Set the address of the TokenState contract.
1112      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
1113      * as balances would be unreachable.
1114      */ 
1115     function setTokenState(TokenState _tokenState)
1116         external
1117         optionalProxy_onlyOwner
1118     {
1119         tokenState = _tokenState;
1120         emitTokenStateUpdated(_tokenState);
1121     }
1122 
1123     function _internalTransfer(address from, address to, uint value, bytes data) 
1124         internal
1125         returns (bool)
1126     { 
1127         /* Disallow transfers to irretrievable-addresses. */
1128         require(to != address(0), "Cannot transfer to the 0 address");
1129         require(to != address(this), "Cannot transfer to the contract");
1130         require(to != address(proxy), "Cannot transfer to the proxy");
1131 
1132         // Insufficient balance will be handled by the safe subtraction.
1133         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
1134         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
1135 
1136         // If the recipient is a contract, we need to call tokenFallback on it so they can do ERC223
1137         // actions when receiving our tokens. Unlike the standard, however, we don't revert if the
1138         // recipient contract doesn't implement tokenFallback.
1139         callTokenFallbackIfNeeded(from, to, value, data);
1140         
1141         // Emit a standard ERC20 transfer event
1142         emitTransfer(from, to, value);
1143 
1144         return true;
1145     }
1146 
1147     /**
1148      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
1149      * the onlyProxy or optionalProxy modifiers.
1150      */
1151     function _transfer_byProxy(address from, address to, uint value, bytes data)
1152         internal
1153         returns (bool)
1154     {
1155         return _internalTransfer(from, to, value, data);
1156     }
1157 
1158     /**
1159      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
1160      * possessing the optionalProxy or optionalProxy modifiers.
1161      */
1162     function _transferFrom_byProxy(address sender, address from, address to, uint value, bytes data)
1163         internal
1164         returns (bool)
1165     {
1166         /* Insufficient allowance will be handled by the safe subtraction. */
1167         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
1168         return _internalTransfer(from, to, value, data);
1169     }
1170 
1171     /**
1172      * @notice Approves spender to transfer on the message sender's behalf.
1173      */
1174     function approve(address spender, uint value)
1175         public
1176         optionalProxy
1177         returns (bool)
1178     {
1179         address sender = messageSender;
1180 
1181         tokenState.setAllowance(sender, spender, value);
1182         emitApproval(sender, spender, value);
1183         return true;
1184     }
1185 
1186     /* ========== EVENTS ========== */
1187 
1188     event Transfer(address indexed from, address indexed to, uint value);
1189     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
1190     function emitTransfer(address from, address to, uint value) internal {
1191         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
1192     }
1193 
1194     event Approval(address indexed owner, address indexed spender, uint value);
1195     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
1196     function emitApproval(address owner, address spender, uint value) internal {
1197         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
1198     }
1199 
1200     event TokenStateUpdated(address newTokenState);
1201     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
1202     function emitTokenStateUpdated(address newTokenState) internal {
1203         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
1204     }
1205 }
1206 
1207 
1208 /*
1209 -----------------------------------------------------------------
1210 FILE INFORMATION
1211 -----------------------------------------------------------------
1212 
1213 file:       SupplySchedule.sol
1214 version:    1.0
1215 author:     Jackson Chan
1216             Clinton Ennis
1217 date:       2019-03-01
1218 
1219 -----------------------------------------------------------------
1220 MODULE DESCRIPTION
1221 -----------------------------------------------------------------
1222 
1223 Supply Schedule contract. SNX is a transferable ERC20 token.
1224 
1225 User's get staking rewards as part of the incentives of
1226 +------+-------------+--------------+----------+
1227 | Year |  Increase   | Total Supply | Increase |
1228 +------+-------------+--------------+----------+
1229 |    1 |           0 |  100,000,000 |          |
1230 |    2 |  75,000,000 |  175,000,000 | 75%      |
1231 |    3 |  37,500,000 |  212,500,000 | 21%      |
1232 |    4 |  18,750,000 |  231,250,000 | 9%       |
1233 |    5 |   9,375,000 |  240,625,000 | 4%       |
1234 |    6 |   4,687,500 |  245,312,500 | 2%       |
1235 +------+-------------+--------------+----------+
1236 
1237 
1238 -----------------------------------------------------------------
1239 */
1240 
1241 
1242 /**
1243  * @title SupplySchedule contract
1244  */
1245 contract SupplySchedule is Owned {
1246     using SafeMath for uint;
1247     using SafeDecimalMath for uint;
1248 
1249     /* Storage */
1250     struct ScheduleData {
1251         // Total supply issuable during period
1252         uint totalSupply;
1253 
1254         // UTC Time - Start of the schedule
1255         uint startPeriod;
1256 
1257         // UTC Time - End of the schedule
1258         uint endPeriod;
1259 
1260         // UTC Time - Total of supply minted
1261         uint totalSupplyMinted;
1262     }
1263 
1264     // How long each mint period is
1265     uint public mintPeriodDuration = 1 weeks;
1266 
1267     // time supply last minted
1268     uint public lastMintEvent;
1269 
1270     Synthetix public synthetix;
1271 
1272     uint constant SECONDS_IN_YEAR = 60 * 60 * 24 * 365;
1273 
1274     uint public constant START_DATE = 1520294400; // 2018-03-06T00:00:00+00:00
1275     uint public constant YEAR_ONE = START_DATE + SECONDS_IN_YEAR.mul(1);
1276     uint public constant YEAR_TWO = START_DATE + SECONDS_IN_YEAR.mul(2);
1277     uint public constant YEAR_THREE = START_DATE + SECONDS_IN_YEAR.mul(3);
1278     uint public constant YEAR_FOUR = START_DATE + SECONDS_IN_YEAR.mul(4);
1279     uint public constant YEAR_FIVE = START_DATE + SECONDS_IN_YEAR.mul(5);
1280     uint public constant YEAR_SIX = START_DATE + SECONDS_IN_YEAR.mul(6);
1281     uint public constant YEAR_SEVEN = START_DATE + SECONDS_IN_YEAR.mul(7);
1282 
1283     uint8 constant public INFLATION_SCHEDULES_LENGTH = 7;
1284     ScheduleData[INFLATION_SCHEDULES_LENGTH] public schedules;
1285 
1286     uint public minterReward = 200 * SafeDecimalMath.unit();
1287 
1288     constructor(address _owner)
1289         Owned(_owner)
1290         public
1291     {
1292         // ScheduleData(totalSupply, startPeriod, endPeriod, totalSupplyMinted)
1293         // Year 1 - Total supply 100,000,000
1294         schedules[0] = ScheduleData(1e8 * SafeDecimalMath.unit(), START_DATE, YEAR_ONE - 1, 1e8 * SafeDecimalMath.unit());
1295         schedules[1] = ScheduleData(75e6 * SafeDecimalMath.unit(), YEAR_ONE, YEAR_TWO - 1, 0); // Year 2 - Total supply 175,000,000
1296         schedules[2] = ScheduleData(37.5e6 * SafeDecimalMath.unit(), YEAR_TWO, YEAR_THREE - 1, 0); // Year 3 - Total supply 212,500,000
1297         schedules[3] = ScheduleData(18.75e6 * SafeDecimalMath.unit(), YEAR_THREE, YEAR_FOUR - 1, 0); // Year 4 - Total supply 231,250,000
1298         schedules[4] = ScheduleData(9.375e6 * SafeDecimalMath.unit(), YEAR_FOUR, YEAR_FIVE - 1, 0); // Year 5 - Total supply 240,625,000
1299         schedules[5] = ScheduleData(4.6875e6 * SafeDecimalMath.unit(), YEAR_FIVE, YEAR_SIX - 1, 0); // Year 6 - Total supply 245,312,500
1300         schedules[6] = ScheduleData(0, YEAR_SIX, YEAR_SEVEN - 1, 0); // Year 7 - Total supply 245,312,500
1301     }
1302 
1303     // ========== SETTERS ========== */
1304     function setSynthetix(Synthetix _synthetix)
1305         external
1306         onlyOwner
1307     {
1308         synthetix = _synthetix;
1309         // emit event
1310     }
1311 
1312     // ========== VIEWS ==========
1313     function mintableSupply()
1314         public
1315         view
1316         returns (uint)
1317     {
1318         if (!isMintable()) {
1319             return 0;
1320         }
1321 
1322         uint index = getCurrentSchedule();
1323 
1324         // Calculate previous year's mintable supply
1325         uint amountPreviousPeriod = _remainingSupplyFromPreviousYear(index);
1326 
1327         /* solium-disable */
1328 
1329         // Last mint event within current period will use difference in (now - lastMintEvent)
1330         // Last mint event not set (0) / outside of current Period will use current Period
1331         // start time resolved in (now - schedule.startPeriod)
1332         ScheduleData memory schedule = schedules[index];
1333 
1334         uint weeksInPeriod = (schedule.endPeriod - schedule.startPeriod).div(mintPeriodDuration);
1335 
1336         uint supplyPerWeek = schedule.totalSupply.divideDecimal(weeksInPeriod);
1337 
1338         uint weeksToMint = lastMintEvent >= schedule.startPeriod ? _numWeeksRoundedDown(now.sub(lastMintEvent)) : _numWeeksRoundedDown(now.sub(schedule.startPeriod));
1339         // /* solium-enable */
1340 
1341         uint amountInPeriod = supplyPerWeek.multiplyDecimal(weeksToMint);
1342         return amountInPeriod.add(amountPreviousPeriod);
1343     }
1344 
1345     function _numWeeksRoundedDown(uint _timeDiff)
1346         public
1347         view
1348         returns (uint)
1349     {
1350         // Take timeDiff in seconds (Dividend) and mintPeriodDuration as (Divisor)
1351         // Calculate the numberOfWeeks since last mint rounded down to 1 week
1352         // Fraction of a week will return 0
1353         return _timeDiff.div(mintPeriodDuration);
1354     }
1355 
1356     function isMintable()
1357         public
1358         view
1359         returns (bool)
1360     {
1361         bool mintable = false;
1362         if (now - lastMintEvent > mintPeriodDuration && now <= schedules[6].endPeriod) // Ensure time is not after end of Year 7
1363         {
1364             mintable = true;
1365         }
1366         return mintable;
1367     }
1368 
1369     // Return the current schedule based on the timestamp
1370     // applicable based on startPeriod and endPeriod
1371     function getCurrentSchedule()
1372         public
1373         view
1374         returns (uint)
1375     {
1376         require(now <= schedules[6].endPeriod, "Mintable periods have ended");
1377 
1378         for (uint i = 0; i < INFLATION_SCHEDULES_LENGTH; i++) {
1379             if (schedules[i].startPeriod <= now && schedules[i].endPeriod >= now) {
1380                 return i;
1381             }
1382         }
1383     }
1384 
1385     function _remainingSupplyFromPreviousYear(uint currentSchedule)
1386         internal
1387         view
1388         returns (uint)
1389     {
1390         // All supply has been minted for previous period if last minting event is after
1391         // the endPeriod for last year
1392         if (currentSchedule == 0 || lastMintEvent > schedules[currentSchedule - 1].endPeriod) {
1393             return 0;
1394         }
1395 
1396         // return the remaining supply to be minted for previous period missed
1397         uint amountInPeriod = schedules[currentSchedule - 1].totalSupply.sub(schedules[currentSchedule - 1].totalSupplyMinted);
1398 
1399         // Ensure previous period remaining amount is not less than 0
1400         if (amountInPeriod < 0) {
1401             return 0;
1402         }
1403 
1404         return amountInPeriod;
1405     }
1406 
1407     // ========== MUTATIVE FUNCTIONS ==========
1408     function updateMintValues()
1409         external
1410         onlySynthetix
1411         returns (bool)
1412     {
1413         // Will fail if the time is outside of schedules
1414         uint currentIndex = getCurrentSchedule();
1415         uint lastPeriodAmount = _remainingSupplyFromPreviousYear(currentIndex);
1416         uint currentPeriodAmount = mintableSupply().sub(lastPeriodAmount);
1417 
1418         // Update schedule[n - 1].totalSupplyMinted
1419         if (lastPeriodAmount > 0) {
1420             schedules[currentIndex - 1].totalSupplyMinted = schedules[currentIndex - 1].totalSupplyMinted.add(lastPeriodAmount);
1421         }
1422 
1423         // Update schedule.totalSupplyMinted for currentSchedule
1424         schedules[currentIndex].totalSupplyMinted = schedules[currentIndex].totalSupplyMinted.add(currentPeriodAmount);
1425         // Update mint event to now
1426         lastMintEvent = now;
1427 
1428         emit SupplyMinted(lastPeriodAmount, currentPeriodAmount, currentIndex, now);
1429         return true;
1430     }
1431 
1432     function setMinterReward(uint _amount)
1433         external
1434         onlyOwner
1435     {
1436         minterReward = _amount;
1437         emit MinterRewardUpdated(_amount);
1438     }
1439 
1440     // ========== MODIFIERS ==========
1441 
1442     modifier onlySynthetix() {
1443         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
1444         _;
1445     }
1446 
1447     /* ========== EVENTS ========== */
1448 
1449     event SupplyMinted(uint previousPeriodAmount, uint currentAmount, uint indexed schedule, uint timestamp);
1450     event MinterRewardUpdated(uint newRewardAmount);
1451 }
1452 
1453 
1454 /*
1455 -----------------------------------------------------------------
1456 FILE INFORMATION
1457 -----------------------------------------------------------------
1458 
1459 file:       ExchangeRates.sol
1460 version:    1.0
1461 author:     Kevin Brown
1462 date:       2018-09-12
1463 
1464 -----------------------------------------------------------------
1465 MODULE DESCRIPTION
1466 -----------------------------------------------------------------
1467 
1468 A contract that any other contract in the Synthetix system can query
1469 for the current market value of various assets, including
1470 crypto assets as well as various fiat assets.
1471 
1472 This contract assumes that rate updates will completely update
1473 all rates to their current values. If a rate shock happens
1474 on a single asset, the oracle will still push updated rates
1475 for all other assets.
1476 
1477 -----------------------------------------------------------------
1478 */
1479 
1480 
1481 /**
1482  * @title The repository for exchange rates
1483  */
1484 
1485 contract ExchangeRates is SelfDestructible {
1486 
1487 
1488     using SafeMath for uint;
1489     using SafeDecimalMath for uint;
1490 
1491     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
1492     mapping(bytes32 => uint) public rates;
1493 
1494     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
1495     mapping(bytes32 => uint) public lastRateUpdateTimes;
1496 
1497     // The address of the oracle which pushes rate updates to this contract
1498     address public oracle;
1499 
1500     // Do not allow the oracle to submit times any further forward into the future than this constant.
1501     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
1502 
1503     // How long will the contract assume the rate of any asset is correct
1504     uint public rateStalePeriod = 3 hours;
1505 
1506     // Lock exchanges until price update complete
1507     bool public priceUpdateLock = false;
1508 
1509     // Each participating currency in the XDR basket is represented as a currency key with
1510     // equal weighting.
1511     // There are 5 participating currencies, so we'll declare that clearly.
1512     bytes32[5] public xdrParticipants;
1513 
1514     // For inverted prices, keep a mapping of their entry, limits and frozen status
1515     struct InversePricing {
1516         uint entryPoint;
1517         uint upperLimit;
1518         uint lowerLimit;
1519         bool frozen;
1520     }
1521     mapping(bytes32 => InversePricing) public inversePricing;
1522     bytes32[] public invertedKeys;
1523 
1524     //
1525     // ========== CONSTRUCTOR ==========
1526 
1527     /**
1528      * @dev Constructor
1529      * @param _owner The owner of this contract.
1530      * @param _oracle The address which is able to update rate information.
1531      * @param _currencyKeys The initial currency keys to store (in order).
1532      * @param _newRates The initial currency amounts for each currency (in order).
1533      */
1534     constructor(
1535         // SelfDestructible (Ownable)
1536         address _owner,
1537 
1538         // Oracle values - Allows for rate updates
1539         address _oracle,
1540         bytes32[] _currencyKeys,
1541         uint[] _newRates
1542     )
1543         /* Owned is initialised in SelfDestructible */
1544         SelfDestructible(_owner)
1545         public
1546     {
1547         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
1548 
1549         oracle = _oracle;
1550 
1551         // The sUSD rate is always 1 and is never stale.
1552         rates["sUSD"] = SafeDecimalMath.unit();
1553         lastRateUpdateTimes["sUSD"] = now;
1554 
1555         // These are the currencies that make up the XDR basket.
1556         // These are hard coded because:
1557         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
1558         //  - Adding new currencies would likely introduce some kind of weighting factor, which
1559         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
1560         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
1561         //    then point the system at the new version.
1562         xdrParticipants = [
1563             bytes32("sUSD"),
1564             bytes32("sAUD"),
1565             bytes32("sCHF"),
1566             bytes32("sEUR"),
1567             bytes32("sGBP")
1568         ];
1569 
1570         internalUpdateRates(_currencyKeys, _newRates, now);
1571     }
1572 
1573     /* ========== SETTERS ========== */
1574 
1575     /**
1576      * @notice Set the rates stored in this contract
1577      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1578      * @param newRates The rates for each currency (in order)
1579      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1580      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1581      *                 if it takes a long time for the transaction to confirm.
1582      */
1583     function updateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
1584         external
1585         onlyOracle
1586         returns(bool)
1587     {
1588         return internalUpdateRates(currencyKeys, newRates, timeSent);
1589     }
1590 
1591     /**
1592      * @notice Internal function which sets the rates stored in this contract
1593      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1594      * @param newRates The rates for each currency (in order)
1595      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1596      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1597      *                 if it takes a long time for the transaction to confirm.
1598      */
1599     function internalUpdateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
1600         internal
1601         returns(bool)
1602     {
1603         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
1604         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
1605 
1606         // Loop through each key and perform update.
1607         for (uint i = 0; i < currencyKeys.length; i++) {
1608             // Should not set any rate to zero ever, as no asset will ever be
1609             // truely worthless and still valid. In this scenario, we should
1610             // delete the rate and remove it from the system.
1611             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
1612             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
1613 
1614             // We should only update the rate if it's at least the same age as the last rate we've got.
1615             if (timeSent < lastRateUpdateTimes[currencyKeys[i]]) {
1616                 continue;
1617             }
1618 
1619             newRates[i] = rateOrInverted(currencyKeys[i], newRates[i]);
1620 
1621             // Ok, go ahead with the update.
1622             rates[currencyKeys[i]] = newRates[i];
1623             lastRateUpdateTimes[currencyKeys[i]] = timeSent;
1624         }
1625 
1626         emit RatesUpdated(currencyKeys, newRates);
1627 
1628         // Now update our XDR rate.
1629         updateXDRRate(timeSent);
1630 
1631         // If locked during a priceupdate then reset it
1632         if (priceUpdateLock) {
1633             priceUpdateLock = false;
1634         }
1635 
1636         return true;
1637     }
1638 
1639     /**
1640      * @notice Internal function to get the inverted rate, if any, and mark an inverted
1641      *  key as frozen if either limits are reached.
1642      * @param currencyKey The price key to lookup
1643      * @param rate The rate for the given price key
1644      */
1645     function rateOrInverted(bytes32 currencyKey, uint rate) internal returns (uint) {
1646         // if an inverse mapping exists, adjust the price accordingly
1647         InversePricing storage inverse = inversePricing[currencyKey];
1648         if (inverse.entryPoint <= 0) {
1649             return rate;
1650         }
1651 
1652         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
1653         uint newInverseRate = rates[currencyKey];
1654 
1655         // get the new inverted rate if not frozen
1656         if (!inverse.frozen) {
1657             uint doubleEntryPoint = inverse.entryPoint.mul(2);
1658             if (doubleEntryPoint <= rate) {
1659                 // avoid negative numbers for unsigned ints, so set this to 0
1660                 // which by the requirement that lowerLimit be > 0 will
1661                 // cause this to freeze the price to the lowerLimit
1662                 newInverseRate = 0;
1663             } else {
1664                 newInverseRate = doubleEntryPoint.sub(rate);
1665             }
1666 
1667             // now if new rate hits our limits, set it to the limit and freeze
1668             if (newInverseRate >= inverse.upperLimit) {
1669                 newInverseRate = inverse.upperLimit;
1670             } else if (newInverseRate <= inverse.lowerLimit) {
1671                 newInverseRate = inverse.lowerLimit;
1672             }
1673 
1674             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
1675                 inverse.frozen = true;
1676                 emit InversePriceFrozen(currencyKey);
1677             }
1678         }
1679 
1680         return newInverseRate;
1681     }
1682 
1683     /**
1684      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
1685      */
1686     function updateXDRRate(uint timeSent)
1687         internal
1688     {
1689         uint total = 0;
1690 
1691         for (uint i = 0; i < xdrParticipants.length; i++) {
1692             total = rates[xdrParticipants[i]].add(total);
1693         }
1694 
1695         // Set the rate
1696         rates["XDR"] = total;
1697 
1698         // Record that we updated the XDR rate.
1699         lastRateUpdateTimes["XDR"] = timeSent;
1700 
1701         // Emit our updated event separate to the others to save
1702         // moving data around between arrays.
1703         bytes32[] memory eventCurrencyCode = new bytes32[](1);
1704         eventCurrencyCode[0] = "XDR";
1705 
1706         uint[] memory eventRate = new uint[](1);
1707         eventRate[0] = rates["XDR"];
1708 
1709         emit RatesUpdated(eventCurrencyCode, eventRate);
1710     }
1711 
1712     /**
1713      * @notice Delete a rate stored in the contract
1714      * @param currencyKey The currency key you wish to delete the rate for
1715      */
1716     function deleteRate(bytes32 currencyKey)
1717         external
1718         onlyOracle
1719     {
1720         require(rates[currencyKey] > 0, "Rate is zero");
1721 
1722         delete rates[currencyKey];
1723         delete lastRateUpdateTimes[currencyKey];
1724 
1725         emit RateDeleted(currencyKey);
1726     }
1727 
1728     /**
1729      * @notice Set the Oracle that pushes the rate information to this contract
1730      * @param _oracle The new oracle address
1731      */
1732     function setOracle(address _oracle)
1733         external
1734         onlyOwner
1735     {
1736         oracle = _oracle;
1737         emit OracleUpdated(oracle);
1738     }
1739 
1740     /**
1741      * @notice Set the stale period on the updated rate variables
1742      * @param _time The new rateStalePeriod
1743      */
1744     function setRateStalePeriod(uint _time)
1745         external
1746         onlyOwner
1747     {
1748         rateStalePeriod = _time;
1749         emit RateStalePeriodUpdated(rateStalePeriod);
1750     }
1751 
1752     /**
1753      * @notice Set the the locked state for a priceUpdate call
1754      * @param _priceUpdateLock lock boolean flag
1755      */
1756     function setPriceUpdateLock(bool _priceUpdateLock)
1757         external
1758         onlyOracle
1759     {
1760         priceUpdateLock = _priceUpdateLock;
1761     }
1762 
1763     /**
1764      * @notice Set an inverse price up for the currency key
1765      * @param currencyKey The currency to update
1766      * @param entryPoint The entry price point of the inverted price
1767      * @param upperLimit The upper limit, at or above which the price will be frozen
1768      * @param lowerLimit The lower limit, at or below which the price will be frozen
1769      */
1770     function setInversePricing(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit)
1771         external onlyOwner
1772     {
1773         require(entryPoint > 0, "entryPoint must be above 0");
1774         require(lowerLimit > 0, "lowerLimit must be above 0");
1775         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
1776         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
1777         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
1778 
1779         if (inversePricing[currencyKey].entryPoint <= 0) {
1780             // then we are adding a new inverse pricing, so add this
1781             invertedKeys.push(currencyKey);
1782         }
1783         inversePricing[currencyKey].entryPoint = entryPoint;
1784         inversePricing[currencyKey].upperLimit = upperLimit;
1785         inversePricing[currencyKey].lowerLimit = lowerLimit;
1786         inversePricing[currencyKey].frozen = false;
1787 
1788         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
1789     }
1790 
1791     /**
1792      * @notice Remove an inverse price for the currency key
1793      * @param currencyKey The currency to remove inverse pricing for
1794      */
1795     function removeInversePricing(bytes32 currencyKey) external onlyOwner {
1796         inversePricing[currencyKey].entryPoint = 0;
1797         inversePricing[currencyKey].upperLimit = 0;
1798         inversePricing[currencyKey].lowerLimit = 0;
1799         inversePricing[currencyKey].frozen = false;
1800 
1801         // now remove inverted key from array
1802         for (uint8 i = 0; i < invertedKeys.length; i++) {
1803             if (invertedKeys[i] == currencyKey) {
1804                 delete invertedKeys[i];
1805 
1806                 // Copy the last key into the place of the one we just deleted
1807                 // If there's only one key, this is array[0] = array[0].
1808                 // If we're deleting the last one, it's also a NOOP in the same way.
1809                 invertedKeys[i] = invertedKeys[invertedKeys.length - 1];
1810 
1811                 // Decrease the size of the array by one.
1812                 invertedKeys.length--;
1813 
1814                 break;
1815             }
1816         }
1817 
1818         emit InversePriceConfigured(currencyKey, 0, 0, 0);
1819     }
1820     /* ========== VIEWS ========== */
1821 
1822     /**
1823      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
1824      * @param sourceCurrencyKey The currency the amount is specified in
1825      * @param sourceAmount The source amount, specified in UNIT base
1826      * @param destinationCurrencyKey The destination currency
1827      */
1828     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
1829         public
1830         view
1831         rateNotStale(sourceCurrencyKey)
1832         rateNotStale(destinationCurrencyKey)
1833         returns (uint)
1834     {
1835         // If there's no change in the currency, then just return the amount they gave us
1836         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
1837 
1838         // Calculate the effective value by going from source -> USD -> destination
1839         return sourceAmount.multiplyDecimalRound(rateForCurrency(sourceCurrencyKey))
1840             .divideDecimalRound(rateForCurrency(destinationCurrencyKey));
1841     }
1842 
1843     /**
1844      * @notice Retrieve the rate for a specific currency
1845      */
1846     function rateForCurrency(bytes32 currencyKey)
1847         public
1848         view
1849         returns (uint)
1850     {
1851         return rates[currencyKey];
1852     }
1853 
1854     /**
1855      * @notice Retrieve the rates for a list of currencies
1856      */
1857     function ratesForCurrencies(bytes32[] currencyKeys)
1858         public
1859         view
1860         returns (uint[])
1861     {
1862         uint[] memory _rates = new uint[](currencyKeys.length);
1863 
1864         for (uint8 i = 0; i < currencyKeys.length; i++) {
1865             _rates[i] = rates[currencyKeys[i]];
1866         }
1867 
1868         return _rates;
1869     }
1870 
1871     /**
1872      * @notice Retrieve a list of last update times for specific currencies
1873      */
1874     function lastRateUpdateTimeForCurrency(bytes32 currencyKey)
1875         public
1876         view
1877         returns (uint)
1878     {
1879         return lastRateUpdateTimes[currencyKey];
1880     }
1881 
1882     /**
1883      * @notice Retrieve the last update time for a specific currency
1884      */
1885     function lastRateUpdateTimesForCurrencies(bytes32[] currencyKeys)
1886         public
1887         view
1888         returns (uint[])
1889     {
1890         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
1891 
1892         for (uint8 i = 0; i < currencyKeys.length; i++) {
1893             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
1894         }
1895 
1896         return lastUpdateTimes;
1897     }
1898 
1899     /**
1900      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
1901      */
1902     function rateIsStale(bytes32 currencyKey)
1903         public
1904         view
1905         returns (bool)
1906     {
1907         // sUSD is a special case and is never stale.
1908         if (currencyKey == "sUSD") return false;
1909 
1910         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
1911     }
1912 
1913     /**
1914      * @notice Check if any rate is frozen (cannot be exchanged into)
1915      */
1916     function rateIsFrozen(bytes32 currencyKey)
1917         external
1918         view
1919         returns (bool)
1920     {
1921         return inversePricing[currencyKey].frozen;
1922     }
1923 
1924 
1925     /**
1926      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
1927      */
1928     function anyRateIsStale(bytes32[] currencyKeys)
1929         external
1930         view
1931         returns (bool)
1932     {
1933         // Loop through each key and check whether the data point is stale.
1934         uint256 i = 0;
1935 
1936         while (i < currencyKeys.length) {
1937             // sUSD is a special case and is never false
1938             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
1939                 return true;
1940             }
1941             i += 1;
1942         }
1943 
1944         return false;
1945     }
1946 
1947     /* ========== MODIFIERS ========== */
1948 
1949     modifier rateNotStale(bytes32 currencyKey) {
1950         require(!rateIsStale(currencyKey), "Rate stale or nonexistant currency");
1951         _;
1952     }
1953 
1954     modifier onlyOracle
1955     {
1956         require(msg.sender == oracle, "Only the oracle can perform this action");
1957         _;
1958     }
1959 
1960     /* ========== EVENTS ========== */
1961 
1962     event OracleUpdated(address newOracle);
1963     event RateStalePeriodUpdated(uint rateStalePeriod);
1964     event RatesUpdated(bytes32[] currencyKeys, uint[] newRates);
1965     event RateDeleted(bytes32 currencyKey);
1966     event InversePriceConfigured(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
1967     event InversePriceFrozen(bytes32 currencyKey);
1968 }
1969 
1970 
1971 /*
1972 -----------------------------------------------------------------
1973 FILE INFORMATION
1974 -----------------------------------------------------------------
1975 
1976 file:       LimitedSetup.sol
1977 version:    1.1
1978 author:     Anton Jurisevic
1979 
1980 date:       2018-05-15
1981 
1982 -----------------------------------------------------------------
1983 MODULE DESCRIPTION
1984 -----------------------------------------------------------------
1985 
1986 A contract with a limited setup period. Any function modified
1987 with the setup modifier will cease to work after the
1988 conclusion of the configurable-length post-construction setup period.
1989 
1990 -----------------------------------------------------------------
1991 */
1992 
1993 
1994 /**
1995  * @title Any function decorated with the modifier this contract provides
1996  * deactivates after a specified setup period.
1997  */
1998 contract LimitedSetup {
1999 
2000     uint setupExpiryTime;
2001 
2002     /**
2003      * @dev LimitedSetup Constructor.
2004      * @param setupDuration The time the setup period will last for.
2005      */
2006     constructor(uint setupDuration)
2007         public
2008     {
2009         setupExpiryTime = now + setupDuration;
2010     }
2011 
2012     modifier onlyDuringSetup
2013     {
2014         require(now < setupExpiryTime, "Can only perform this action during setup");
2015         _;
2016     }
2017 }
2018 
2019 
2020 /*
2021 -----------------------------------------------------------------
2022 FILE INFORMATION
2023 -----------------------------------------------------------------
2024 
2025 file:       SynthetixState.sol
2026 version:    1.0
2027 author:     Kevin Brown
2028 date:       2018-10-19
2029 
2030 -----------------------------------------------------------------
2031 MODULE DESCRIPTION
2032 -----------------------------------------------------------------
2033 
2034 A contract that holds issuance state and preferred currency of
2035 users in the Synthetix system.
2036 
2037 This contract is used side by side with the Synthetix contract
2038 to make it easier to upgrade the contract logic while maintaining
2039 issuance state.
2040 
2041 The Synthetix contract is also quite large and on the edge of
2042 being beyond the contract size limit without moving this information
2043 out to another contract.
2044 
2045 The first deployed contract would create this state contract,
2046 using it as its store of issuance data.
2047 
2048 When a new contract is deployed, it links to the existing
2049 state contract, whose owner would then change its associated
2050 contract to the new one.
2051 
2052 -----------------------------------------------------------------
2053 */
2054 
2055 
2056 /**
2057  * @title Synthetix State
2058  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
2059  */
2060 contract SynthetixState is State, LimitedSetup {
2061     using SafeMath for uint;
2062     using SafeDecimalMath for uint;
2063 
2064     // A struct for handing values associated with an individual user's debt position
2065     struct IssuanceData {
2066         // Percentage of the total debt owned at the time
2067         // of issuance. This number is modified by the global debt
2068         // delta array. You can figure out a user's exit price and
2069         // collateralisation ratio using a combination of their initial
2070         // debt and the slice of global debt delta which applies to them.
2071         uint initialDebtOwnership;
2072         // This lets us know when (in relative terms) the user entered
2073         // the debt pool so we can calculate their exit price and
2074         // collateralistion ratio
2075         uint debtEntryIndex;
2076     }
2077 
2078     // Issued synth balances for individual fee entitlements and exit price calculations
2079     mapping(address => IssuanceData) public issuanceData;
2080 
2081     // The total count of people that have outstanding issued synths in any flavour
2082     uint public totalIssuerCount;
2083 
2084     // Global debt pool tracking
2085     uint[] public debtLedger;
2086 
2087     // Import state
2088     uint public importedXDRAmount;
2089 
2090     // A quantity of synths greater than this ratio
2091     // may not be issued against a given value of SNX.
2092     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
2093     // No more synths may be issued than the value of SNX backing them.
2094     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
2095 
2096     // Users can specify their preferred currency, in which case all synths they receive
2097     // will automatically exchange to that preferred currency upon receipt in their wallet
2098     mapping(address => bytes4) public preferredCurrency;
2099 
2100     /**
2101      * @dev Constructor
2102      * @param _owner The address which controls this contract.
2103      * @param _associatedContract The ERC20 contract whose state this composes.
2104      */
2105     constructor(address _owner, address _associatedContract)
2106         State(_owner, _associatedContract)
2107         LimitedSetup(1 weeks)
2108         public
2109     {}
2110 
2111     /* ========== SETTERS ========== */
2112 
2113     /**
2114      * @notice Set issuance data for an address
2115      * @dev Only the associated contract may call this.
2116      * @param account The address to set the data for.
2117      * @param initialDebtOwnership The initial debt ownership for this address.
2118      */
2119     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
2120         external
2121         onlyAssociatedContract
2122     {
2123         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
2124         issuanceData[account].debtEntryIndex = debtLedger.length;
2125     }
2126 
2127     /**
2128      * @notice Clear issuance data for an address
2129      * @dev Only the associated contract may call this.
2130      * @param account The address to clear the data for.
2131      */
2132     function clearIssuanceData(address account)
2133         external
2134         onlyAssociatedContract
2135     {
2136         delete issuanceData[account];
2137     }
2138 
2139     /**
2140      * @notice Increment the total issuer count
2141      * @dev Only the associated contract may call this.
2142      */
2143     function incrementTotalIssuerCount()
2144         external
2145         onlyAssociatedContract
2146     {
2147         totalIssuerCount = totalIssuerCount.add(1);
2148     }
2149 
2150     /**
2151      * @notice Decrement the total issuer count
2152      * @dev Only the associated contract may call this.
2153      */
2154     function decrementTotalIssuerCount()
2155         external
2156         onlyAssociatedContract
2157     {
2158         totalIssuerCount = totalIssuerCount.sub(1);
2159     }
2160 
2161     /**
2162      * @notice Append a value to the debt ledger
2163      * @dev Only the associated contract may call this.
2164      * @param value The new value to be added to the debt ledger.
2165      */
2166     function appendDebtLedgerValue(uint value)
2167         external
2168         onlyAssociatedContract
2169     {
2170         debtLedger.push(value);
2171     }
2172 
2173     /**
2174      * @notice Set preferred currency for a user
2175      * @dev Only the associated contract may call this.
2176      * @param account The account to set the preferred currency for
2177      * @param currencyKey The new preferred currency
2178      */
2179     function setPreferredCurrency(address account, bytes4 currencyKey)
2180         external
2181         onlyAssociatedContract
2182     {
2183         preferredCurrency[account] = currencyKey;
2184     }
2185 
2186     /**
2187      * @notice Set the issuanceRatio for issuance calculations.
2188      * @dev Only callable by the contract owner.
2189      */
2190     function setIssuanceRatio(uint _issuanceRatio)
2191         external
2192         onlyOwner
2193     {
2194         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
2195         issuanceRatio = _issuanceRatio;
2196         emit IssuanceRatioUpdated(_issuanceRatio);
2197     }
2198 
2199     /**
2200      * @notice Import issuer data from the old Synthetix contract before multicurrency
2201      * @dev Only callable by the contract owner, and only for 1 week after deployment.
2202      */
2203     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
2204         external
2205         onlyOwner
2206         onlyDuringSetup
2207     {
2208         require(accounts.length == sUSDAmounts.length, "Length mismatch");
2209 
2210         for (uint8 i = 0; i < accounts.length; i++) {
2211             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
2212         }
2213     }
2214 
2215     /**
2216      * @notice Import issuer data from the old Synthetix contract before multicurrency
2217      * @dev Only used from importIssuerData above, meant to be disposable
2218      */
2219     function _addToDebtRegister(address account, uint amount)
2220         internal
2221     {
2222         // This code is duplicated from Synthetix so that we can call it directly here
2223         // during setup only.
2224         Synthetix synthetix = Synthetix(associatedContract);
2225 
2226         // What is the value of the requested debt in XDRs?
2227         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
2228 
2229         // What is the value that we've previously imported?
2230         uint totalDebtIssued = importedXDRAmount;
2231 
2232         // What will the new total be including the new value?
2233         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2234 
2235         // Save that for the next import.
2236         importedXDRAmount = newTotalDebtIssued;
2237 
2238         // What is their percentage (as a high precision int) of the total debt?
2239         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2240 
2241         // And what effect does this percentage have on the global debt holding of other issuers?
2242         // The delta specifically needs to not take into account any existing debt as it's already
2243         // accounted for in the delta from when they issued previously.
2244         // The delta is a high precision integer.
2245         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2246 
2247         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
2248 
2249         // And what does their debt ownership look like including this previous stake?
2250         if (existingDebt > 0) {
2251             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2252         }
2253 
2254         // Are they a new issuer? If so, record them.
2255         if (issuanceData[account].initialDebtOwnership == 0) {
2256             totalIssuerCount = totalIssuerCount.add(1);
2257         }
2258 
2259         // Save the debt entry parameters
2260         issuanceData[account].initialDebtOwnership = debtPercentage;
2261         issuanceData[account].debtEntryIndex = debtLedger.length;
2262 
2263         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2264         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2265         if (debtLedger.length > 0) {
2266             debtLedger.push(
2267                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2268             );
2269         } else {
2270             debtLedger.push(SafeDecimalMath.preciseUnit());
2271         }
2272     }
2273 
2274     /* ========== VIEWS ========== */
2275 
2276     /**
2277      * @notice Retrieve the length of the debt ledger array
2278      */
2279     function debtLedgerLength()
2280         external
2281         view
2282         returns (uint)
2283     {
2284         return debtLedger.length;
2285     }
2286 
2287     /**
2288      * @notice Retrieve the most recent entry from the debt ledger
2289      */
2290     function lastDebtLedgerEntry()
2291         external
2292         view
2293         returns (uint)
2294     {
2295         return debtLedger[debtLedger.length - 1];
2296     }
2297 
2298     /**
2299      * @notice Query whether an account has issued and has an outstanding debt balance
2300      * @param account The address to query for
2301      */
2302     function hasIssued(address account)
2303         external
2304         view
2305         returns (bool)
2306     {
2307         return issuanceData[account].initialDebtOwnership > 0;
2308     }
2309 
2310     event IssuanceRatioUpdated(uint newRatio);
2311 }
2312 
2313 
2314 /**
2315  * @title FeePool Interface
2316  * @notice Abstract contract to hold public getters
2317  */
2318 contract IFeePool {
2319     address public FEE_ADDRESS;
2320     uint public exchangeFeeRate;
2321     function amountReceivedFromExchange(uint value) external view returns (uint);
2322     function amountReceivedFromTransfer(uint value) external view returns (uint);
2323     function feePaid(bytes32 currencyKey, uint amount) external;
2324     function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
2325     function setRewardsToDistribute(uint amount) external;
2326 }
2327 
2328 
2329 /**
2330  * @title SynthetixState interface contract
2331  * @notice Abstract contract to hold public getters
2332  */
2333 contract ISynthetixState {
2334     // A struct for handing values associated with an individual user's debt position
2335     struct IssuanceData {
2336         // Percentage of the total debt owned at the time
2337         // of issuance. This number is modified by the global debt
2338         // delta array. You can figure out a user's exit price and
2339         // collateralisation ratio using a combination of their initial
2340         // debt and the slice of global debt delta which applies to them.
2341         uint initialDebtOwnership;
2342         // This lets us know when (in relative terms) the user entered
2343         // the debt pool so we can calculate their exit price and
2344         // collateralistion ratio
2345         uint debtEntryIndex;
2346     }
2347 
2348     uint[] public debtLedger;
2349     uint public issuanceRatio;
2350     mapping(address => IssuanceData) public issuanceData;
2351 
2352     function debtLedgerLength() external view returns (uint);
2353     function hasIssued(address account) external view returns (bool);
2354     function incrementTotalIssuerCount() external;
2355     function decrementTotalIssuerCount() external;
2356     function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
2357     function lastDebtLedgerEntry() external view returns (uint);
2358     function appendDebtLedgerValue(uint value) external;
2359     function clearIssuanceData(address account) external;
2360 }
2361 
2362 
2363 interface ISynth {
2364   function burn(address account, uint amount) external;
2365   function issue(address account, uint amount) external;
2366   function transfer(address to, uint value) public returns (bool);
2367   function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount) external;
2368   function transferFrom(address from, address to, uint value) public returns (bool);
2369 }
2370 
2371 
2372 /**
2373  * @title SynthetixEscrow interface
2374  */
2375 interface ISynthetixEscrow {
2376     function balanceOf(address account) public view returns (uint);
2377     function appendVestingEntry(address account, uint quantity) public;
2378 }
2379 
2380 
2381 /**
2382  * @title ExchangeRates interface
2383  */
2384 interface IExchangeRates {
2385     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey) external view returns (uint);
2386 
2387     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
2388     function ratesForCurrencies(bytes32[] currencyKeys) external view returns (uint[] memory);
2389 
2390     function rateIsStale(bytes32 currencyKey) external view returns (bool);
2391     function anyRateIsStale(bytes32[] currencyKeys) external view returns (bool);
2392 }
2393 
2394 
2395 /**
2396  * @title Synthetix interface contract
2397  * @notice Abstract contract to hold public getters
2398  * @dev pseudo interface, actually declared as contract to hold the public getters 
2399  */
2400 
2401 
2402 contract ISynthetix {
2403 
2404     // ========== PUBLIC STATE VARIABLES ==========
2405 
2406     IFeePool public feePool;
2407     ISynthetixEscrow public escrow;
2408     ISynthetixEscrow public rewardEscrow;
2409     ISynthetixState public synthetixState;
2410     IExchangeRates public exchangeRates;
2411 
2412     mapping(bytes32 => Synth) public synths;
2413 
2414     // ========== PUBLIC FUNCTIONS ==========
2415 
2416     function balanceOf(address account) public view returns (uint);
2417     function transfer(address to, uint value) public returns (bool);
2418     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey) public view returns (uint);
2419 
2420     function synthInitiatedExchange(
2421         address from,
2422         bytes32 sourceCurrencyKey,
2423         uint sourceAmount,
2424         bytes32 destinationCurrencyKey,
2425         address destinationAddress) external returns (bool);
2426     function exchange(
2427         bytes32 sourceCurrencyKey,
2428         uint sourceAmount,
2429         bytes32 destinationCurrencyKey,
2430         address destinationAddress) external returns (bool);
2431     function collateralisationRatio(address issuer) public view returns (uint);
2432     function totalIssuedSynths(bytes32 currencyKey)
2433         public
2434         view
2435         returns (uint);
2436     function getSynth(bytes32 currencyKey) public view returns (ISynth);
2437     function debtBalanceOf(address issuer, bytes32 currencyKey) public view returns (uint);
2438 }
2439 
2440 
2441 /*
2442 -----------------------------------------------------------------
2443 FILE INFORMATION
2444 -----------------------------------------------------------------
2445 
2446 file:       Synth.sol
2447 version:    2.0
2448 author:     Kevin Brown
2449 date:       2018-09-13
2450 
2451 -----------------------------------------------------------------
2452 MODULE DESCRIPTION
2453 -----------------------------------------------------------------
2454 
2455 Synthetix-backed stablecoin contract.
2456 
2457 This contract issues synths, which are tokens that mirror various
2458 flavours of fiat currency.
2459 
2460 Synths are issuable by Synthetix Network Token (SNX) holders who
2461 have to lock up some value of their SNX to issue S * Cmax synths.
2462 Where Cmax issome value less than 1.
2463 
2464 A configurable fee is charged on synth transfers and deposited
2465 into a common pot, which Synthetix holders may withdraw from once
2466 per fee period.
2467 
2468 -----------------------------------------------------------------
2469 */
2470 
2471 
2472 contract Synth is ExternStateToken {
2473 
2474     /* ========== STATE VARIABLES ========== */
2475 
2476     // Address of the FeePoolProxy
2477     address public feePoolProxy;
2478     // Address of the SynthetixProxy
2479     address public synthetixProxy;
2480 
2481     // Currency key which identifies this Synth to the Synthetix system
2482     bytes32 public currencyKey;
2483 
2484     uint8 constant DECIMALS = 18;
2485 
2486     /* ========== CONSTRUCTOR ========== */
2487 
2488     constructor(address _proxy, TokenState _tokenState, address _synthetixProxy, address _feePoolProxy,
2489         string _tokenName, string _tokenSymbol, address _owner, bytes32 _currencyKey, uint _totalSupply
2490     )
2491         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, _totalSupply, DECIMALS, _owner)
2492         public
2493     {
2494         require(_proxy != address(0), "_proxy cannot be 0");
2495         require(_synthetixProxy != address(0), "_synthetixProxy cannot be 0");
2496         require(_feePoolProxy != address(0), "_feePoolProxy cannot be 0");
2497         require(_owner != 0, "_owner cannot be 0");
2498         require(ISynthetix(_synthetixProxy).synths(_currencyKey) == Synth(0), "Currency key is already in use");
2499 
2500         feePoolProxy = _feePoolProxy;
2501         synthetixProxy = _synthetixProxy;
2502         currencyKey = _currencyKey;
2503     }
2504 
2505     /* ========== SETTERS ========== */
2506 
2507     /**
2508      * @notice Set the SynthetixProxy should it ever change.
2509      * The Synth requires Synthetix address as it has the authority
2510      * to mint and burn synths
2511      * */
2512     function setSynthetixProxy(ISynthetix _synthetixProxy)
2513         external
2514         optionalProxy_onlyOwner
2515     {
2516         synthetixProxy = _synthetixProxy;
2517         emitSynthetixUpdated(_synthetixProxy);
2518     }
2519 
2520     /**
2521      * @notice Set the FeePoolProxy should it ever change.
2522      * The Synth requires FeePool address as it has the authority
2523      * to mint and burn for FeePool.claimFees()
2524      * */
2525     function setFeePoolProxy(address _feePoolProxy)
2526         external
2527         optionalProxy_onlyOwner
2528     {
2529         feePoolProxy = _feePoolProxy;
2530         emitFeePoolUpdated(_feePoolProxy);
2531     }
2532 
2533     /* ========== MUTATIVE FUNCTIONS ========== */
2534 
2535     /**
2536      * @notice ERC20 transfer function
2537      * forward call on to _internalTransfer */
2538     function transfer(address to, uint value)
2539         public
2540         optionalProxy
2541         returns (bool)
2542     {
2543         _notFeeAddress(messageSender);
2544         bytes memory empty;
2545         return super._internalTransfer(messageSender, to, value, empty);
2546     }
2547 
2548     /**
2549      * @notice ERC223 transfer function
2550      */
2551     function transfer(address to, uint value, bytes data)
2552         public
2553         optionalProxy
2554         returns (bool)
2555     {
2556         _notFeeAddress(messageSender);
2557         // And send their result off to the destination address
2558         return super._internalTransfer(messageSender, to, value, data);
2559     }
2560 
2561     /**
2562      * @notice ERC20 transferFrom function
2563      */
2564     function transferFrom(address from, address to, uint value)
2565         public
2566         optionalProxy
2567         returns (bool)
2568     {
2569         _notFeeAddress(from);
2570         // Reduce the allowance by the amount we're transferring.
2571         // The safeSub call will handle an insufficient allowance.
2572         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
2573 
2574         bytes memory empty;
2575         return super._internalTransfer(from, to, value, empty);
2576     }
2577 
2578     /**
2579      * @notice ERC223 transferFrom function
2580      */
2581     function transferFrom(address from, address to, uint value, bytes data)
2582         public
2583         optionalProxy
2584         returns (bool)
2585     {
2586         _notFeeAddress(from);
2587         // Reduce the allowance by the amount we're transferring.
2588         // The safeSub call will handle an insufficient allowance.
2589         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
2590 
2591         return super._internalTransfer(from, to, value, data);
2592     }
2593 
2594     // Allow synthetix to issue a certain number of synths from an account.
2595     function issue(address account, uint amount)
2596         external
2597         onlySynthetixOrFeePool
2598     {
2599         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
2600         totalSupply = totalSupply.add(amount);
2601         emitTransfer(address(0), account, amount);
2602         emitIssued(account, amount);
2603     }
2604 
2605     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
2606     function burn(address account, uint amount)
2607         external
2608         onlySynthetixOrFeePool
2609     {
2610         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
2611         totalSupply = totalSupply.sub(amount);
2612         emitTransfer(account, address(0), amount);
2613         emitBurned(account, amount);
2614     }
2615 
2616     // Allow owner to set the total supply on import.
2617     function setTotalSupply(uint amount)
2618         external
2619         optionalProxy_onlyOwner
2620     {
2621         totalSupply = amount;
2622     }
2623 
2624     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
2625     // exchange as well as transfer
2626     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
2627         external
2628         onlySynthetixOrFeePool
2629     {
2630         bytes memory empty;
2631         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
2632     }
2633 
2634 
2635     function _notFeeAddress(address account)
2636         internal
2637         view
2638     {
2639         require(account != IFeePool(feePoolProxy).FEE_ADDRESS(), "The fee address is not allowed");
2640     }
2641 
2642     /* ========== MODIFIERS ========== */
2643 
2644     modifier onlySynthetixOrFeePool() {
2645         bool isSynthetix = msg.sender == address(Proxy(synthetixProxy).target());
2646         bool isFeePool = msg.sender == address(Proxy(feePoolProxy).target());
2647 
2648         require(isSynthetix || isFeePool, "Only Synthetix, FeePool allowed");
2649         _;
2650     }
2651 
2652     /* ========== EVENTS ========== */
2653 
2654     event SynthetixUpdated(address newSynthetix);
2655     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
2656     function emitSynthetixUpdated(address newSynthetix) internal {
2657         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
2658     }
2659 
2660     event FeePoolUpdated(address newFeePool);
2661     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
2662     function emitFeePoolUpdated(address newFeePool) internal {
2663         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
2664     }
2665 
2666     event Issued(address indexed account, uint value);
2667     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
2668     function emitIssued(address account, uint value) internal {
2669         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
2670     }
2671 
2672     event Burned(address indexed account, uint value);
2673     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
2674     function emitBurned(address account, uint value) internal {
2675         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
2676     }
2677 }
2678 
2679 
2680 /**
2681  * @title RewardsDistribution interface
2682  */
2683 interface IRewardsDistribution {
2684     function distributeRewards(uint amount) external;
2685 }
2686 
2687 
2688 /*
2689 -----------------------------------------------------------------
2690 FILE INFORMATION
2691 -----------------------------------------------------------------
2692 
2693 file:       Synthetix.sol
2694 version:    2.0
2695 author:     Kevin Brown
2696             Gavin Conway
2697 date:       2018-09-14
2698 
2699 -----------------------------------------------------------------
2700 MODULE DESCRIPTION
2701 -----------------------------------------------------------------
2702 
2703 Synthetix token contract. SNX is a transferable ERC20 token,
2704 and also give its holders the following privileges.
2705 An owner of SNX has the right to issue synths in all synth flavours.
2706 
2707 After a fee period terminates, the duration and fees collected for that
2708 period are computed, and the next period begins. Thus an account may only
2709 withdraw the fees owed to them for the previous period, and may only do
2710 so once per period. Any unclaimed fees roll over into the common pot for
2711 the next period.
2712 
2713 == Average Balance Calculations ==
2714 
2715 The fee entitlement of a synthetix holder is proportional to their average
2716 issued synth balance over the last fee period. This is computed by
2717 measuring the area under the graph of a user's issued synth balance over
2718 time, and then when a new fee period begins, dividing through by the
2719 duration of the fee period.
2720 
2721 We need only update values when the balances of an account is modified.
2722 This occurs when issuing or burning for issued synth balances,
2723 and when transferring for synthetix balances. This is for efficiency,
2724 and adds an implicit friction to interacting with SNX.
2725 A synthetix holder pays for his own recomputation whenever he wants to change
2726 his position, which saves the foundation having to maintain a pot dedicated
2727 to resourcing this.
2728 
2729 A hypothetical user's balance history over one fee period, pictorially:
2730 
2731       s ____
2732        |    |
2733        |    |___ p
2734        |____|___|___ __ _  _
2735        f    t   n
2736 
2737 Here, the balance was s between times f and t, at which time a transfer
2738 occurred, updating the balance to p, until n, when the present transfer occurs.
2739 When a new transfer occurs at time n, the balance being p,
2740 we must:
2741 
2742   - Add the area p * (n - t) to the total area recorded so far
2743   - Update the last transfer time to n
2744 
2745 So if this graph represents the entire current fee period,
2746 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
2747 The complementary computations must be performed for both sender and
2748 recipient.
2749 
2750 Note that a transfer keeps global supply of SNX invariant.
2751 The sum of all balances is constant, and unmodified by any transfer.
2752 So the sum of all balances multiplied by the duration of a fee period is also
2753 constant, and this is equivalent to the sum of the area of every user's
2754 time/balance graph. Dividing through by that duration yields back the total
2755 synthetix supply. So, at the end of a fee period, we really do yield a user's
2756 average share in the synthetix supply over that period.
2757 
2758 A slight wrinkle is introduced if we consider the time r when the fee period
2759 rolls over. Then the previous fee period k-1 is before r, and the current fee
2760 period k is afterwards. If the last transfer took place before r,
2761 but the latest transfer occurred afterwards:
2762 
2763 k-1       |        k
2764       s __|_
2765        |  | |
2766        |  | |____ p
2767        |__|_|____|___ __ _  _
2768           |
2769        f  | t    n
2770           r
2771 
2772 In this situation the area (r-f)*s contributes to fee period k-1, while
2773 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2774 zero-value transfer to have occurred at time r. Their fee entitlement for the
2775 previous period will be finalised at the time of their first transfer during the
2776 current fee period, or when they query or withdraw their fee entitlement.
2777 
2778 In the implementation, the duration of different fee periods may be slightly irregular,
2779 as the check that they have rolled over occurs only when state-changing synthetix
2780 operations are performed.
2781 
2782 == Issuance and Burning ==
2783 
2784 In this version of the synthetix contract, synths can only be issued by
2785 those that have been nominated by the synthetix foundation. Synths are assumed
2786 to be valued at $1, as they are a stable unit of account.
2787 
2788 All synths issued require a proportional value of SNX to be locked,
2789 where the proportion is governed by the current issuance ratio. This
2790 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
2791 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
2792 
2793 To determine the value of some amount of SNX(S), an oracle is used to push
2794 the price of SNX (P_S) in dollars to the contract. The value of S
2795 would then be: S * P_S.
2796 
2797 Any SNX that are locked up by this issuance process cannot be transferred.
2798 The amount that is locked floats based on the price of SNX. If the price
2799 of SNX moves up, less SNX are locked, so they can be issued against,
2800 or transferred freely. If the price of SNX moves down, more SNX are locked,
2801 even going above the initial wallet balance.
2802 
2803 -----------------------------------------------------------------
2804 */
2805 
2806 
2807 /**
2808  * @title Synthetix ERC20 contract.
2809  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2810  * but it also computes the quantity of fees each synthetix holder is entitled to.
2811  */
2812 contract Synthetix is ExternStateToken {
2813 
2814     // ========== STATE VARIABLES ==========
2815 
2816     // Available Synths which can be used with the system
2817     Synth[] public availableSynths;
2818     mapping(bytes32 => Synth) public synths;
2819 
2820     IFeePool public feePool;
2821     ISynthetixEscrow public escrow;
2822     ISynthetixEscrow public rewardEscrow;
2823     ExchangeRates public exchangeRates;
2824     SynthetixState public synthetixState;
2825     SupplySchedule public supplySchedule;
2826     IRewardsDistribution public rewardsDistribution;
2827 
2828     bool private protectionCircuit = false;
2829 
2830     string constant TOKEN_NAME = "Synthetix Network Token";
2831     string constant TOKEN_SYMBOL = "SNX";
2832     uint8 constant DECIMALS = 18;
2833     bool public exchangeEnabled = true;
2834     uint public gasPriceLimit;
2835 
2836     // ========== CONSTRUCTOR ==========
2837 
2838     /**
2839      * @dev Constructor
2840      * @param _tokenState A pre-populated contract containing token balances.
2841      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2842      * @param _owner The owner of this contract.
2843      */
2844     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2845         address _owner, ExchangeRates _exchangeRates, IFeePool _feePool, SupplySchedule _supplySchedule,
2846         ISynthetixEscrow _rewardEscrow, ISynthetixEscrow _escrow, IRewardsDistribution _rewardsDistribution, uint _totalSupply
2847     )
2848         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, _totalSupply, DECIMALS, _owner)
2849         public
2850     {
2851         synthetixState = _synthetixState;
2852         exchangeRates = _exchangeRates;
2853         feePool = _feePool;
2854         supplySchedule = _supplySchedule;
2855         rewardEscrow = _rewardEscrow;
2856         escrow = _escrow;
2857         rewardsDistribution = _rewardsDistribution;
2858     }
2859     // ========== SETTERS ========== */
2860 
2861     function setFeePool(IFeePool _feePool)
2862         external
2863         optionalProxy_onlyOwner
2864     {
2865         feePool = _feePool;
2866     }
2867 
2868     function setExchangeRates(ExchangeRates _exchangeRates)
2869         external
2870         optionalProxy_onlyOwner
2871     {
2872         exchangeRates = _exchangeRates;
2873     }
2874 
2875     function setProtectionCircuit(bool _protectionCircuitIsActivated)
2876         external
2877         onlyOracle
2878     {
2879         protectionCircuit = _protectionCircuitIsActivated;
2880     }
2881 
2882     function setExchangeEnabled(bool _exchangeEnabled)
2883         external
2884         optionalProxy_onlyOwner
2885     {
2886         exchangeEnabled = _exchangeEnabled;
2887     }
2888 
2889     function setGasPriceLimit(uint _gasPriceLimit)
2890         external
2891         onlyOracle
2892     {
2893         require(_gasPriceLimit > 0, "Needs to be greater than 0");
2894         gasPriceLimit = _gasPriceLimit;
2895     }
2896 
2897     /**
2898      * @notice Add an associated Synth contract to the Synthetix system
2899      * @dev Only the contract owner may call this.
2900      */
2901     function addSynth(Synth synth)
2902         external
2903         optionalProxy_onlyOwner
2904     {
2905         bytes32 currencyKey = synth.currencyKey();
2906 
2907         require(synths[currencyKey] == Synth(0), "Synth already exists");
2908 
2909         availableSynths.push(synth);
2910         synths[currencyKey] = synth;
2911     }
2912 
2913     /**
2914      * @notice Remove an associated Synth contract from the Synthetix system
2915      * @dev Only the contract owner may call this.
2916      */
2917     function removeSynth(bytes32 currencyKey)
2918         external
2919         optionalProxy_onlyOwner
2920     {
2921         require(synths[currencyKey] != address(0), "Synth does not exist");
2922         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2923         require(currencyKey != "XDR", "Cannot remove XDR synth");
2924 
2925         // Save the address we're removing for emitting the event at the end.
2926         address synthToRemove = synths[currencyKey];
2927 
2928         // Remove the synth from the availableSynths array.
2929         for (uint8 i = 0; i < availableSynths.length; i++) {
2930             if (availableSynths[i] == synthToRemove) {
2931                 delete availableSynths[i];
2932 
2933                 // Copy the last synth into the place of the one we just deleted
2934                 // If there's only one synth, this is synths[0] = synths[0].
2935                 // If we're deleting the last one, it's also a NOOP in the same way.
2936                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2937 
2938                 // Decrease the size of the array by one.
2939                 availableSynths.length--;
2940 
2941                 break;
2942             }
2943         }
2944 
2945         // And remove it from the synths mapping
2946         delete synths[currencyKey];
2947 
2948         // Note: No event here as our contract exceeds max contract size
2949         // with these events, and it's unlikely people will need to
2950         // track these events specifically.
2951     }
2952 
2953     // ========== VIEWS ==========
2954 
2955     /**
2956      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2957      * @param sourceCurrencyKey The currency the amount is specified in
2958      * @param sourceAmount The source amount, specified in UNIT base
2959      * @param destinationCurrencyKey The destination currency
2960      */
2961     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
2962         public
2963         view
2964         returns (uint)
2965     {
2966         return exchangeRates.effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
2967     }
2968 
2969     /**
2970      * @notice Total amount of synths issued by the system, priced in currencyKey
2971      * @param currencyKey The currency to value the synths in
2972      */
2973     function totalIssuedSynths(bytes32 currencyKey)
2974         public
2975         view
2976         rateNotStale(currencyKey)
2977         returns (uint)
2978     {
2979         uint total = 0;
2980         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2981 
2982         require(!exchangeRates.anyRateIsStale(availableCurrencyKeys()), "Rates are stale");
2983 
2984         for (uint8 i = 0; i < availableSynths.length; i++) {
2985             // What's the total issued value of that synth in the destination currency?
2986             // Note: We're not using our effectiveValue function because we don't want to go get the
2987             //       rate for the destination currency and check if it's stale repeatedly on every
2988             //       iteration of the loop
2989             uint synthValue = availableSynths[i].totalSupply()
2990                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
2991                 .divideDecimalRound(currencyRate);
2992             total = total.add(synthValue);
2993         }
2994 
2995         return total;
2996     }
2997 
2998     /**
2999      * @notice Returns the currencyKeys of availableSynths for rate checking
3000      */
3001     function availableCurrencyKeys()
3002         public
3003         view
3004         returns (bytes32[])
3005     {
3006         bytes32[] memory availableCurrencyKeys = new bytes32[](availableSynths.length);
3007 
3008         for (uint8 i = 0; i < availableSynths.length; i++) {
3009             availableCurrencyKeys[i] = availableSynths[i].currencyKey();
3010         }
3011 
3012         return availableCurrencyKeys;
3013     }
3014 
3015     /**
3016      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
3017      */
3018     function availableSynthCount()
3019         public
3020         view
3021         returns (uint)
3022     {
3023         return availableSynths.length;
3024     }
3025 
3026     // ========== MUTATIVE FUNCTIONS ==========
3027 
3028     /**
3029      * @notice ERC20 transfer function.
3030      */
3031     function transfer(address to, uint value)
3032         public
3033         returns (bool)
3034     {
3035         bytes memory empty;
3036         return transfer(to, value, empty);
3037     }
3038 
3039     /**
3040      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
3041      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3042      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3043      *           tooling such as Etherscan.
3044      */
3045     function transfer(address to, uint value, bytes data)
3046         public
3047         optionalProxy
3048         returns (bool)
3049     {
3050         // Ensure they're not trying to exceed their locked amount
3051         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
3052 
3053         // Perform the transfer: if there is a problem an exception will be thrown in this call.
3054         _transfer_byProxy(messageSender, to, value, data);
3055 
3056         return true;
3057     }
3058 
3059     /**
3060      * @notice ERC20 transferFrom function.
3061      */
3062     function transferFrom(address from, address to, uint value)
3063         public
3064         returns (bool)
3065     {
3066         bytes memory empty;
3067         return transferFrom(from, to, value, empty);
3068     }
3069 
3070     /**
3071      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
3072      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3073      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3074      *           tooling such as Etherscan.
3075      */
3076     function transferFrom(address from, address to, uint value, bytes data)
3077         public
3078         optionalProxy
3079         returns (bool)
3080     {
3081         // Ensure they're not trying to exceed their locked amount
3082         require(value <= transferableSynthetix(from), "Insufficient balance");
3083 
3084         // Perform the transfer: if there is a problem,
3085         // an exception will be thrown in this call.
3086         _transferFrom_byProxy(messageSender, from, to, value, data);
3087 
3088         return true;
3089     }
3090 
3091     /**
3092      * @notice Function that allows you to exchange synths you hold in one flavour for another.
3093      * @param sourceCurrencyKey The source currency you wish to exchange from
3094      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3095      * @param destinationCurrencyKey The destination currency you wish to obtain.
3096      * @param destinationAddress Deprecated. Will always send to messageSender
3097      * @return Boolean that indicates whether the transfer succeeded or failed.
3098      */
3099     function exchange(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey, address destinationAddress)
3100         external
3101         optionalProxy
3102         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
3103         returns (bool)
3104     {
3105         require(sourceCurrencyKey != destinationCurrencyKey, "Must use different synths");
3106         require(sourceAmount > 0, "Zero amount");
3107 
3108         // verify gas price limit
3109         validateGasPrice(tx.gasprice);
3110 
3111         //  If protectionCircuit is true then we burn the synths through _internalLiquidation()
3112         if (protectionCircuit) {
3113             return _internalLiquidation(
3114                 messageSender,
3115                 sourceCurrencyKey,
3116                 sourceAmount
3117             );
3118         } else {
3119             // Pass it along, defaulting to the sender as the recipient.
3120             return _internalExchange(
3121                 messageSender,
3122                 sourceCurrencyKey,
3123                 sourceAmount,
3124                 destinationCurrencyKey,
3125                 messageSender,
3126                 true // Charge fee on the exchange
3127             );
3128         }
3129     }
3130 
3131     /*
3132         @dev validate that the given gas price is less than or equal to the gas price limit
3133         @param _gasPrice tested gas price
3134     */
3135     function validateGasPrice(uint _givenGasPrice)
3136         public
3137         view
3138     {
3139         require(_givenGasPrice <= gasPriceLimit, "Gas price above limit");
3140     }
3141 
3142     /**
3143      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
3144      * @dev Only the synth contract can call this function
3145      * @param from The address to exchange / burn synth from
3146      * @param sourceCurrencyKey The source currency you wish to exchange from
3147      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3148      * @param destinationCurrencyKey The destination currency you wish to obtain.
3149      * @param destinationAddress Where the result should go.
3150      * @return Boolean that indicates whether the transfer succeeded or failed.
3151      */
3152     function synthInitiatedExchange(
3153         address from,
3154         bytes32 sourceCurrencyKey,
3155         uint sourceAmount,
3156         bytes32 destinationCurrencyKey,
3157         address destinationAddress
3158     )
3159         external
3160         returns (bool)
3161     {
3162         _onlySynth();
3163         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3164         require(sourceAmount > 0, "Zero amount");
3165 
3166         // Pass it along
3167         return _internalExchange(
3168             from,
3169             sourceCurrencyKey,
3170             sourceAmount,
3171             destinationCurrencyKey,
3172             destinationAddress,
3173             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
3174         );
3175     }
3176 
3177     /**
3178      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3179      * @dev fee pool contract address is not allowed to call function
3180      * @param from The address to move synth from
3181      * @param sourceCurrencyKey source currency from.
3182      * @param sourceAmount The amount, specified in UNIT of source currency.
3183      * @param destinationCurrencyKey The destination currency to obtain.
3184      * @param destinationAddress Where the result should go.
3185      * @param chargeFee Boolean to charge a fee for transaction.
3186      * @return Boolean that indicates whether the transfer succeeded or failed.
3187      */
3188     function _internalExchange(
3189         address from,
3190         bytes32 sourceCurrencyKey,
3191         uint sourceAmount,
3192         bytes32 destinationCurrencyKey,
3193         address destinationAddress,
3194         bool chargeFee
3195     )
3196         internal
3197         notFeeAddress(from)
3198         returns (bool)
3199     {
3200         require(exchangeEnabled, "Exchanging is disabled");
3201         require(!exchangeRates.priceUpdateLock(), "Price update lock");
3202         require(destinationAddress != address(0), "Zero destination");
3203         require(destinationAddress != address(this), "Synthetix is invalid destination");
3204         require(destinationAddress != address(proxy), "Proxy is invalid destination");
3205 
3206         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3207         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3208 
3209         // Burn the source amount
3210         synths[sourceCurrencyKey].burn(from, sourceAmount);
3211 
3212         // How much should they get in the destination currency?
3213         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3214 
3215         // What's the fee on that currency that we should deduct?
3216         uint amountReceived = destinationAmount;
3217         uint fee = 0;
3218 
3219         if (chargeFee) {
3220             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
3221             fee = destinationAmount.sub(amountReceived);
3222         }
3223 
3224         // Issue their new synths
3225         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3226 
3227         // Remit the fee in XDRs
3228         if (fee > 0) {
3229             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3230             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3231             // Tell the fee pool about this.
3232             feePool.feePaid("XDR", xdrFeeAmount);
3233         }
3234 
3235         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3236 
3237         // Call the ERC223 transfer callback if needed
3238         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
3239 
3240         //Let the DApps know there was a Synth exchange
3241         emitSynthExchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, amountReceived, destinationAddress);
3242 
3243         return true;
3244     }
3245 
3246     /**
3247     * @notice Function that burns the amount sent during an exchange in case the protection circuit is activated
3248     * @param from The address to move synth from
3249     * @param sourceCurrencyKey source currency from.
3250     * @param sourceAmount The amount, specified in UNIT of source currency.
3251     * @return Boolean that indicates whether the transfer succeeded or failed.
3252     */
3253     function _internalLiquidation(
3254         address from,
3255         bytes32 sourceCurrencyKey,
3256         uint sourceAmount
3257     )
3258         internal
3259         returns (bool)
3260     {
3261         // Burn the source amount
3262         synths[sourceCurrencyKey].burn(from, sourceAmount);
3263         return true;
3264     }
3265 
3266     /**
3267      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
3268      * @dev Only internal calls from synthetix address.
3269      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3270      * @param amount The amount of synths to register with a base of UNIT
3271      */
3272     function _addToDebtRegister(bytes32 currencyKey, uint amount)
3273         internal
3274         optionalProxy
3275     {
3276         // What is the value of the requested debt in XDRs?
3277         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3278 
3279         // What is the value of all issued synths of the system (priced in XDRs)?
3280         uint totalDebtIssued = totalIssuedSynths("XDR");
3281 
3282         // What will the new total be including the new value?
3283         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3284 
3285         // What is their percentage (as a high precision int) of the total debt?
3286         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3287 
3288         // And what effect does this percentage change have on the global debt holding of other issuers?
3289         // The delta specifically needs to not take into account any existing debt as it's already
3290         // accounted for in the delta from when they issued previously.
3291         // The delta is a high precision integer.
3292         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3293 
3294         // How much existing debt do they have?
3295         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3296 
3297         // And what does their debt ownership look like including this previous stake?
3298         if (existingDebt > 0) {
3299             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3300         }
3301 
3302         // Are they a new issuer? If so, record them.
3303         if (!synthetixState.hasIssued(messageSender)) {
3304             synthetixState.incrementTotalIssuerCount();
3305         }
3306 
3307         // Save the debt entry parameters
3308         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3309 
3310         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3311         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3312         if (synthetixState.debtLedgerLength() > 0) {
3313             synthetixState.appendDebtLedgerValue(
3314                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3315             );
3316         } else {
3317             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3318         }
3319     }
3320 
3321     /**
3322      * @notice Issue synths against the sender's SNX.
3323      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3324      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3325      * @param amount The amount of synths you wish to issue with a base of UNIT
3326      */
3327     function issueSynths(bytes32 currencyKey, uint amount)
3328         public
3329         optionalProxy
3330         // No need to check if price is stale, as it is checked in issuableSynths.
3331     {
3332         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3333 
3334         // Keep track of the debt they're about to create
3335         _addToDebtRegister(currencyKey, amount);
3336 
3337         // Create their synths
3338         synths[currencyKey].issue(messageSender, amount);
3339 
3340         // Store their locked SNX amount to determine their fee % for the period
3341         _appendAccountIssuanceRecord();
3342     }
3343 
3344     /**
3345      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3346      * @dev Issuance is only allowed if the synthetix price isn't stale.
3347      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3348      */
3349     function issueMaxSynths(bytes32 currencyKey)
3350         external
3351         optionalProxy
3352     {
3353         // Figure out the maximum we can issue in that currency
3354         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3355 
3356         // And issue them
3357         issueSynths(currencyKey, maxIssuable);
3358     }
3359 
3360     /**
3361      * @notice Burn synths to clear issued synths/free SNX.
3362      * @param currencyKey The currency you're specifying to burn
3363      * @param amount The amount (in UNIT base) you wish to burn
3364      * @dev The amount to burn is debased to XDR's
3365      */
3366     function burnSynths(bytes32 currencyKey, uint amount)
3367         external
3368         optionalProxy
3369         // No need to check for stale rates as effectiveValue checks rates
3370     {
3371         // How much debt do they have?
3372         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3373         uint debt = debtBalanceOf(messageSender, "XDR");
3374         uint debtInCurrencyKey = debtBalanceOf(messageSender, currencyKey);
3375 
3376         require(debt > 0, "No debt to forgive");
3377 
3378         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3379         // clear their debt and leave them be.
3380         uint amountToRemove = debt < debtToRemove ? debt : debtToRemove;
3381 
3382         // Remove their debt from the ledger
3383         _removeFromDebtRegister(amountToRemove);
3384 
3385         uint amountToBurn = debtInCurrencyKey < amount ? debtInCurrencyKey : amount;
3386 
3387         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3388         synths[currencyKey].burn(messageSender, amountToBurn);
3389 
3390         // Store their debtRatio against a feeperiod to determine their fee/rewards % for the period
3391         _appendAccountIssuanceRecord();
3392     }
3393 
3394     /**
3395      * @notice Store in the FeePool the users current debt value in the system in XDRs.
3396      * @dev debtBalanceOf(messageSender, "XDR") to be used with totalIssuedSynths("XDR") to get
3397      *  users % of the system within a feePeriod.
3398      */
3399     function _appendAccountIssuanceRecord()
3400         internal
3401     {
3402         uint initialDebtOwnership;
3403         uint debtEntryIndex;
3404         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(messageSender);
3405 
3406         feePool.appendAccountIssuanceRecord(
3407             messageSender,
3408             initialDebtOwnership,
3409             debtEntryIndex
3410         );
3411     }
3412 
3413     /**
3414      * @notice Remove a debt position from the register
3415      * @param amount The amount (in UNIT base) being presented in XDRs
3416      */
3417     function _removeFromDebtRegister(uint amount)
3418         internal
3419     {
3420         uint debtToRemove = amount;
3421 
3422         // How much debt do they have?
3423         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3424 
3425         // What is the value of all issued synths of the system (priced in XDRs)?
3426         uint totalDebtIssued = totalIssuedSynths("XDR");
3427 
3428         // What will the new total after taking out the withdrawn amount
3429         uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3430 
3431         uint delta;
3432 
3433         // What will the debt delta be if there is any debt left?
3434         // Set delta to 0 if no more debt left in system after user
3435         if (newTotalDebtIssued > 0) {
3436 
3437             // What is the percentage of the withdrawn debt (as a high precision int) of the total debt after?
3438             uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(newTotalDebtIssued);
3439 
3440             // And what effect does this percentage change have on the global debt holding of other issuers?
3441             // The delta specifically needs to not take into account any existing debt as it's already
3442             // accounted for in the delta from when they issued previously.
3443             delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3444         } else {
3445             delta = 0;
3446         }
3447 
3448         // Are they exiting the system, or are they just decreasing their debt position?
3449         if (debtToRemove == existingDebt) {
3450             synthetixState.setCurrentIssuanceData(messageSender, 0);
3451             synthetixState.decrementTotalIssuerCount();
3452         } else {
3453             // What percentage of the debt will they be left with?
3454             uint newDebt = existingDebt.sub(debtToRemove);
3455             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3456 
3457             // Store the debt percentage and debt ledger as high precision integers
3458             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3459         }
3460 
3461         // Update our cumulative ledger. This is also a high precision integer.
3462         synthetixState.appendDebtLedgerValue(
3463             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3464         );
3465     }
3466 
3467     // ========== Issuance/Burning ==========
3468 
3469     /**
3470      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3471      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3472      */
3473     function maxIssuableSynths(address issuer, bytes32 currencyKey)
3474         public
3475         view
3476         // We don't need to check stale rates here as effectiveValue will do it for us.
3477         returns (uint)
3478     {
3479         // What is the value of their SNX balance in the destination currency?
3480         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3481 
3482         // They're allowed to issue up to issuanceRatio of that value
3483         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3484     }
3485 
3486     /**
3487      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3488      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
3489      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3490      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
3491      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3492      * altering the amount of fees they're able to claim from the system.
3493      */
3494     function collateralisationRatio(address issuer)
3495         public
3496         view
3497         returns (uint)
3498     {
3499         uint totalOwnedSynthetix = collateral(issuer);
3500         if (totalOwnedSynthetix == 0) return 0;
3501 
3502         uint debtBalance = debtBalanceOf(issuer, "SNX");
3503         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3504     }
3505 
3506     /**
3507      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3508      * will tell you how many synths a user has to give back to the system in order to unlock their original
3509      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3510      * the debt in sUSD, XDR, or any other synth you wish.
3511      */
3512     function debtBalanceOf(address issuer, bytes32 currencyKey)
3513         public
3514         view
3515         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3516         returns (uint)
3517     {
3518         // What was their initial debt ownership?
3519         uint initialDebtOwnership;
3520         uint debtEntryIndex;
3521         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3522 
3523         // If it's zero, they haven't issued, and they have no debt.
3524         if (initialDebtOwnership == 0) return 0;
3525 
3526         // Figure out the global debt percentage delta from when they entered the system.
3527         // This is a high precision integer.
3528         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3529             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3530             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3531 
3532         // What's the total value of the system in their requested currency?
3533         uint totalSystemValue = totalIssuedSynths(currencyKey);
3534 
3535         // Their debt balance is their portion of the total system value.
3536         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3537             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3538 
3539         return highPrecisionBalance.preciseDecimalToDecimal();
3540     }
3541 
3542     /**
3543      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3544      * @param issuer The account that intends to issue
3545      * @param currencyKey The currency to price issuable value in
3546      */
3547     function remainingIssuableSynths(address issuer, bytes32 currencyKey)
3548         public
3549         view
3550         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3551         returns (uint)
3552     {
3553         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3554         uint max = maxIssuableSynths(issuer, currencyKey);
3555 
3556         if (alreadyIssued >= max) {
3557             return 0;
3558         } else {
3559             return max.sub(alreadyIssued);
3560         }
3561     }
3562 
3563     /**
3564      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3565      * against which synths can be issued.
3566      * This includes those already being used as collateral (locked), and those
3567      * available for further issuance (unlocked).
3568      */
3569     function collateral(address account)
3570         public
3571         view
3572         returns (uint)
3573     {
3574         uint balance = tokenState.balanceOf(account);
3575 
3576         if (escrow != address(0)) {
3577             balance = balance.add(escrow.balanceOf(account));
3578         }
3579 
3580         if (rewardEscrow != address(0)) {
3581             balance = balance.add(rewardEscrow.balanceOf(account));
3582         }
3583 
3584         return balance;
3585     }
3586 
3587     /**
3588      * @notice The number of SNX that are free to be transferred by an account.
3589      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
3590      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
3591      * in this calculation.
3592      */
3593     function transferableSynthetix(address account)
3594         public
3595         view
3596         rateNotStale("SNX")
3597         returns (uint)
3598     {
3599         // How many SNX do they have, excluding escrow?
3600         // Note: We're excluding escrow here because we're interested in their transferable amount
3601         // and escrowed SNX are not transferable.
3602         uint balance = tokenState.balanceOf(account);
3603 
3604         // How many of those will be locked by the amount they've issued?
3605         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3606         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3607         // The locked synthetix value can exceed their balance.
3608         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3609 
3610         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3611         if (lockedSynthetixValue >= balance) {
3612             return 0;
3613         } else {
3614             return balance.sub(lockedSynthetixValue);
3615         }
3616     }
3617 
3618     /**
3619      * @notice Mints the inflationary SNX supply. The inflation shedule is
3620      * defined in the SupplySchedule contract.
3621      * The mint() function is publicly callable by anyone. The caller will
3622      receive a minter reward as specified in supplySchedule.minterReward().
3623      */
3624     function mint()
3625         external
3626         returns (bool)
3627     {
3628         require(rewardsDistribution != address(0), "RewardsDistribution not set");
3629 
3630         uint supplyToMint = supplySchedule.mintableSupply();
3631         require(supplyToMint > 0, "No supply is mintable");
3632 
3633         supplySchedule.updateMintValues();
3634 
3635         // Set minted SNX balance to RewardEscrow's balance
3636         // Minus the minterReward and set balance of minter to add reward
3637         uint minterReward = supplySchedule.minterReward();
3638         // Get the remainder
3639         uint amountToDistribute = supplyToMint.sub(minterReward);
3640 
3641         // Set the token balance to the RewardsDistribution contract
3642         tokenState.setBalanceOf(rewardsDistribution, tokenState.balanceOf(rewardsDistribution).add(amountToDistribute));
3643         emitTransfer(this, rewardsDistribution, amountToDistribute);
3644 
3645         // Kick off the distribution of rewards
3646         rewardsDistribution.distributeRewards(amountToDistribute);
3647 
3648         // Assign the minters reward.
3649         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
3650         emitTransfer(this, msg.sender, minterReward);
3651 
3652         totalSupply = totalSupply.add(supplyToMint);
3653 
3654         return true;
3655     }
3656 
3657     // ========== MODIFIERS ==========
3658 
3659     modifier rateNotStale(bytes32 currencyKey) {
3660         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or not a synth");
3661         _;
3662     }
3663 
3664     modifier notFeeAddress(address account) {
3665         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3666         _;
3667     }
3668 
3669     /**
3670      * @notice Only a synth can call this function, optionally via synthetixProxy or directly
3671      * @dev This used to be a modifier but instead of duplicating the bytecode into
3672      * The functions implementing it they now call this internal function to save bytecode space
3673      */
3674     function _onlySynth()
3675         internal
3676         view
3677         optionalProxy
3678     {
3679         bool isSynth = false;
3680 
3681         // No need to repeatedly call this function either
3682         for (uint8 i = 0; i < availableSynths.length; i++) {
3683             if (availableSynths[i] == messageSender) {
3684                 isSynth = true;
3685                 break;
3686             }
3687         }
3688 
3689         require(isSynth, "Only synth allowed");
3690     }
3691 
3692     modifier onlyOracle
3693     {
3694         require(msg.sender == exchangeRates.oracle(), "Only oracle allowed");
3695         _;
3696     }
3697 
3698     // ========== EVENTS ==========
3699     /* solium-disable */
3700     event SynthExchange(address indexed account, bytes32 fromCurrencyKey, uint256 fromAmount, bytes32 toCurrencyKey,  uint256 toAmount, address toAddress);
3701     bytes32 constant SYNTHEXCHANGE_SIG = keccak256("SynthExchange(address,bytes32,uint256,bytes32,uint256,address)");
3702     function emitSynthExchange(address account, bytes32 fromCurrencyKey, uint256 fromAmount, bytes32 toCurrencyKey, uint256 toAmount, address toAddress) internal {
3703         proxy._emit(abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress), 2, SYNTHEXCHANGE_SIG, bytes32(account), 0, 0);
3704     }
3705     /* solium-enable */
3706 }
3707 
