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
856     address public messageSender;
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
895         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
896             messageSender = msg.sender;
897         }
898         _;
899     }
900 
901     modifier optionalProxy_onlyOwner
902     {
903         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
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
914 /**
915  * @title Helps contracts guard against reentrancy attacks.
916  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
917  * @dev If you mark a function `nonReentrant`, you should also
918  * mark it `external`.
919  */
920 contract ReentrancyGuard {
921 
922   /// @dev counter to allow mutex lock with only one SSTORE operation
923   uint256 private _guardCounter;
924 
925   constructor() internal {
926     // The counter starts at one to prevent changing it from zero to a non-zero
927     // value, which is a more expensive operation.
928     _guardCounter = 1;
929   }
930 
931   /**
932    * @dev Prevents a contract from calling itself, directly or indirectly.
933    * Calling a `nonReentrant` function from another `nonReentrant`
934    * function is not supported. It is possible to prevent this from happening
935    * by making the `nonReentrant` function external, and make it call a
936    * `private` function that does the actual work.
937    */
938   modifier nonReentrant() {
939     _guardCounter += 1;
940     uint256 localCounter = _guardCounter;
941     _;
942     require(localCounter == _guardCounter);
943   }
944 
945 }
946 
947 
948 /*
949 -----------------------------------------------------------------
950 FILE INFORMATION
951 -----------------------------------------------------------------
952 
953 file:       TokenFallback.sol
954 version:    1.0
955 author:     Kevin Brown
956 date:       2018-08-10
957 
958 -----------------------------------------------------------------
959 MODULE DESCRIPTION
960 -----------------------------------------------------------------
961 
962 This contract provides the logic that's used to call ERC223
963 tokenFallback() when SNX or Synth transfers happen.
964 
965 -----------------------------------------------------------------
966 */
967 
968 
969 contract TokenFallbackCaller is ReentrancyGuard {
970     uint constant MAX_GAS_SUB_CALL = 100000;
971     function callTokenFallbackIfNeeded(address sender, address recipient, uint amount, bytes data)
972         internal
973         nonReentrant
974     {
975         /*
976             If we're transferring to a contract and it implements the tokenFallback function, call it.
977             This isn't ERC223 compliant because we don't revert if the contract doesn't implement tokenFallback.
978             This is because many DEXes and other contracts that expect to work with the standard
979             approve / transferFrom workflow don't implement tokenFallback but can still process our tokens as
980             usual, so it feels very harsh and likely to cause trouble if we add this restriction after having
981             previously gone live with a vanilla ERC20.
982         */
983 
984         // Is the to address a contract? We can check the code size on that address and know.
985         uint length;
986 
987         // solium-disable-next-line security/no-inline-assembly
988         assembly {
989             // Retrieve the size of the code on the recipient address
990             length := extcodesize(recipient)
991         }
992 
993         // If there's code there, it's a contract
994         if (length > 0) {
995             // Limit contract sub call to 200000 gas
996             uint gasLimit = gasleft() < MAX_GAS_SUB_CALL ? gasleft() : MAX_GAS_SUB_CALL;
997             // Now we need to optionally call tokenFallback(address from, uint value).
998             // We can't call it the normal way because that reverts when the recipient doesn't implement the function.
999             // solium-disable-next-line security/no-low-level-calls
1000             recipient.call.gas(gasLimit)(abi.encodeWithSignature("tokenFallback(address,uint256,bytes)", sender, amount, data));
1001 
1002             // And yes, we specifically don't care if this call fails, so we're not checking the return value.
1003         }
1004     }
1005 }
1006 
1007 
1008 /*
1009 -----------------------------------------------------------------
1010 FILE INFORMATION
1011 -----------------------------------------------------------------
1012 
1013 file:       ExternStateToken.sol
1014 version:    1.3
1015 author:     Anton Jurisevic
1016             Dominic Romanowski
1017             Kevin Brown
1018 
1019 date:       2018-05-29
1020 
1021 -----------------------------------------------------------------
1022 MODULE DESCRIPTION
1023 -----------------------------------------------------------------
1024 
1025 A partial ERC20 token contract, designed to operate with a proxy.
1026 To produce a complete ERC20 token, transfer and transferFrom
1027 tokens must be implemented, using the provided _byProxy internal
1028 functions.
1029 This contract utilises an external state for upgradeability.
1030 
1031 -----------------------------------------------------------------
1032 */
1033 
1034 
1035 /**
1036  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
1037  */
1038 contract ExternStateToken is SelfDestructible, Proxyable, TokenFallbackCaller {
1039 
1040     using SafeMath for uint;
1041     using SafeDecimalMath for uint;
1042 
1043     /* ========== STATE VARIABLES ========== */
1044 
1045     /* Stores balances and allowances. */
1046     TokenState public tokenState;
1047 
1048     /* Other ERC20 fields. */
1049     string public name;
1050     string public symbol;
1051     uint public totalSupply;
1052     uint8 public decimals;
1053 
1054     /**
1055      * @dev Constructor.
1056      * @param _proxy The proxy associated with this contract.
1057      * @param _name Token's ERC20 name.
1058      * @param _symbol Token's ERC20 symbol.
1059      * @param _totalSupply The total supply of the token.
1060      * @param _tokenState The TokenState contract address.
1061      * @param _owner The owner of this contract.
1062      */
1063     constructor(address _proxy, TokenState _tokenState,
1064                 string _name, string _symbol, uint _totalSupply,
1065                 uint8 _decimals, address _owner)
1066         SelfDestructible(_owner)
1067         Proxyable(_proxy, _owner)
1068         public
1069     {
1070         tokenState = _tokenState;
1071 
1072         name = _name;
1073         symbol = _symbol;
1074         totalSupply = _totalSupply;
1075         decimals = _decimals;
1076     }
1077 
1078     /* ========== VIEWS ========== */
1079 
1080     /**
1081      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
1082      * @param owner The party authorising spending of their funds.
1083      * @param spender The party spending tokenOwner's funds.
1084      */
1085     function allowance(address owner, address spender)
1086         public
1087         view
1088         returns (uint)
1089     {
1090         return tokenState.allowance(owner, spender);
1091     }
1092 
1093     /**
1094      * @notice Returns the ERC20 token balance of a given account.
1095      */
1096     function balanceOf(address account)
1097         public
1098         view
1099         returns (uint)
1100     {
1101         return tokenState.balanceOf(account);
1102     }
1103 
1104     /* ========== MUTATIVE FUNCTIONS ========== */
1105 
1106     /**
1107      * @notice Set the address of the TokenState contract.
1108      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
1109      * as balances would be unreachable.
1110      */
1111     function setTokenState(TokenState _tokenState)
1112         external
1113         optionalProxy_onlyOwner
1114     {
1115         tokenState = _tokenState;
1116         emitTokenStateUpdated(_tokenState);
1117     }
1118 
1119     function _internalTransfer(address from, address to, uint value, bytes data)
1120         internal
1121         returns (bool)
1122     {
1123         /* Disallow transfers to irretrievable-addresses. */
1124         require(to != address(0), "Cannot transfer to the 0 address");
1125         require(to != address(this), "Cannot transfer to the contract");
1126         require(to != address(proxy), "Cannot transfer to the proxy");
1127 
1128         // Insufficient balance will be handled by the safe subtraction.
1129         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
1130         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
1131 
1132         // Emit a standard ERC20 transfer event
1133         emitTransfer(from, to, value);
1134 
1135         // If the recipient is a contract, we need to call tokenFallback on it so they can do ERC223
1136         // actions when receiving our tokens. Unlike the standard, however, we don't revert if the
1137         // recipient contract doesn't implement tokenFallback.
1138         callTokenFallbackIfNeeded(from, to, value, data);
1139         
1140         return true;
1141     }
1142 
1143     /**
1144      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
1145      * the onlyProxy or optionalProxy modifiers.
1146      */
1147     function _transfer_byProxy(address from, address to, uint value, bytes data)
1148         internal
1149         returns (bool)
1150     {
1151         return _internalTransfer(from, to, value, data);
1152     }
1153 
1154     /**
1155      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
1156      * possessing the optionalProxy or optionalProxy modifiers.
1157      */
1158     function _transferFrom_byProxy(address sender, address from, address to, uint value, bytes data)
1159         internal
1160         returns (bool)
1161     {
1162         /* Insufficient allowance will be handled by the safe subtraction. */
1163         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
1164         return _internalTransfer(from, to, value, data);
1165     }
1166 
1167     /**
1168      * @notice Approves spender to transfer on the message sender's behalf.
1169      */
1170     function approve(address spender, uint value)
1171         public
1172         optionalProxy
1173         returns (bool)
1174     {
1175         address sender = messageSender;
1176 
1177         tokenState.setAllowance(sender, spender, value);
1178         emitApproval(sender, spender, value);
1179         return true;
1180     }
1181 
1182     /* ========== EVENTS ========== */
1183 
1184     event Transfer(address indexed from, address indexed to, uint value);
1185     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
1186     function emitTransfer(address from, address to, uint value) internal {
1187         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
1188     }
1189 
1190     event Approval(address indexed owner, address indexed spender, uint value);
1191     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
1192     function emitApproval(address owner, address spender, uint value) internal {
1193         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
1194     }
1195 
1196     event TokenStateUpdated(address newTokenState);
1197     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
1198     function emitTokenStateUpdated(address newTokenState) internal {
1199         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
1200     }
1201 }
1202 
1203 
1204 /*
1205 -----------------------------------------------------------------
1206 FILE INFORMATION
1207 -----------------------------------------------------------------
1208 
1209 file:       SupplySchedule.sol
1210 version:    1.0
1211 author:     Jackson Chan
1212             Clinton Ennis
1213 date:       2019-03-01
1214 
1215 -----------------------------------------------------------------
1216 MODULE DESCRIPTION
1217 -----------------------------------------------------------------
1218 
1219 The SNX supply schedule contract determines the amount of SNX tokens
1220 mintable over 6 years of inflation.
1221 
1222 Inflation Schedule
1223 +------+-------------+--------------+----------+
1224 | Year |  Increase   | Total Supply | Increase |
1225 +------+-------------+--------------+----------+
1226 |    1 |           0 |  100,000,000 |          |
1227 |    2 |  75,000,000 |  175,000,000 | 75%      |
1228 |    3 |  37,500,000 |  212,500,000 | 21%      |
1229 |    4 |  18,750,000 |  231,250,000 | 9%       |
1230 |    5 |   9,375,000 |  240,625,000 | 4%       |
1231 |    6 |   4,687,500 |  245,312,500 | 2%       |
1232 +------+-------------+--------------+----------+
1233 
1234 Synthetix.mint() function is used to mint the inflationary supply.
1235 
1236 -----------------------------------------------------------------
1237 */
1238 
1239 
1240 /**
1241  * @title SupplySchedule contract
1242  */
1243 contract SupplySchedule is Owned {
1244     using SafeMath for uint;
1245     using SafeDecimalMath for uint;
1246 
1247     /* Storage */
1248     struct ScheduleData {
1249         // Total supply issuable during period
1250         uint totalSupply;
1251 
1252         // Start of the schedule
1253         uint startPeriod;
1254 
1255         // End of the schedule
1256         uint endPeriod;
1257 
1258         // Total of supply minted
1259         uint totalSupplyMinted;
1260     }
1261 
1262     // How long each mint period is
1263     uint public mintPeriodDuration = 1 weeks;
1264 
1265     // time supply last minted
1266     uint public lastMintEvent;
1267 
1268     Synthetix public synthetix;
1269 
1270     uint constant SECONDS_IN_YEAR = 60 * 60 * 24 * 365;
1271 
1272     uint public constant START_DATE = 1520294400; // 2018-03-06T00:00:00+00:00
1273     uint public constant YEAR_ONE = START_DATE + SECONDS_IN_YEAR.mul(1);
1274     uint public constant YEAR_TWO = START_DATE + SECONDS_IN_YEAR.mul(2);
1275     uint public constant YEAR_THREE = START_DATE + SECONDS_IN_YEAR.mul(3);
1276     uint public constant YEAR_FOUR = START_DATE + SECONDS_IN_YEAR.mul(4);
1277     uint public constant YEAR_FIVE = START_DATE + SECONDS_IN_YEAR.mul(5);
1278     uint public constant YEAR_SIX = START_DATE + SECONDS_IN_YEAR.mul(6);
1279     uint public constant YEAR_SEVEN = START_DATE + SECONDS_IN_YEAR.mul(7);
1280 
1281     uint8 constant public INFLATION_SCHEDULES_LENGTH = 7;
1282     ScheduleData[INFLATION_SCHEDULES_LENGTH] public schedules;
1283 
1284     uint public minterReward = 200 * SafeDecimalMath.unit();
1285 
1286     constructor(address _owner)
1287         Owned(_owner)
1288         public
1289     {
1290         // ScheduleData(totalSupply, startPeriod, endPeriod, totalSupplyMinted)
1291         // Year 1 - Total supply 100,000,000
1292         schedules[0] = ScheduleData(1e8 * SafeDecimalMath.unit(), START_DATE, YEAR_ONE - 1, 1e8 * SafeDecimalMath.unit());
1293         schedules[1] = ScheduleData(75e6 * SafeDecimalMath.unit(), YEAR_ONE, YEAR_TWO - 1, 0); // Year 2 - Total supply 175,000,000
1294         schedules[2] = ScheduleData(37.5e6 * SafeDecimalMath.unit(), YEAR_TWO, YEAR_THREE - 1, 0); // Year 3 - Total supply 212,500,000
1295         schedules[3] = ScheduleData(18.75e6 * SafeDecimalMath.unit(), YEAR_THREE, YEAR_FOUR - 1, 0); // Year 4 - Total supply 231,250,000
1296         schedules[4] = ScheduleData(9.375e6 * SafeDecimalMath.unit(), YEAR_FOUR, YEAR_FIVE - 1, 0); // Year 5 - Total supply 240,625,000
1297         schedules[5] = ScheduleData(4.6875e6 * SafeDecimalMath.unit(), YEAR_FIVE, YEAR_SIX - 1, 0); // Year 6 - Total supply 245,312,500
1298         schedules[6] = ScheduleData(0, YEAR_SIX, YEAR_SEVEN - 1, 0); // Year 7 - Total supply 245,312,500
1299     }
1300 
1301     // ========== SETTERS ========== */
1302     function setSynthetix(Synthetix _synthetix)
1303         external
1304         onlyOwner
1305     {
1306         synthetix = _synthetix;
1307     }
1308 
1309     // ========== VIEWS ==========
1310     function mintableSupply()
1311         public
1312         view
1313         returns (uint)
1314     {
1315         if (!isMintable()) {
1316             return 0;
1317         }
1318 
1319         uint index = getCurrentSchedule();
1320 
1321         // Calculate previous year's mintable supply
1322         uint amountPreviousPeriod = _remainingSupplyFromPreviousYear(index);
1323 
1324         /* solium-disable */
1325 
1326         // Last mint event within current period will use difference in (now - lastMintEvent)
1327         // Last mint event not set (0) / outside of current Period will use current Period
1328         // start time resolved in (now - schedule.startPeriod)
1329         ScheduleData memory schedule = schedules[index];
1330 
1331         uint weeksInPeriod = (schedule.endPeriod - schedule.startPeriod).div(mintPeriodDuration);
1332 
1333         uint supplyPerWeek = schedule.totalSupply.divideDecimal(weeksInPeriod);
1334 
1335         uint weeksToMint = lastMintEvent >= schedule.startPeriod ? _numWeeksRoundedDown(now.sub(lastMintEvent)) : _numWeeksRoundedDown(now.sub(schedule.startPeriod));
1336         // /* solium-enable */
1337 
1338         uint amountInPeriod = supplyPerWeek.multiplyDecimal(weeksToMint);
1339         return amountInPeriod.add(amountPreviousPeriod);
1340     }
1341 
1342     function _numWeeksRoundedDown(uint _timeDiff)
1343         public
1344         view
1345         returns (uint)
1346     {
1347         // Take timeDiff in seconds (Dividend) and mintPeriodDuration as (Divisor)
1348         // Calculate the numberOfWeeks since last mint rounded down to 1 week
1349         // Fraction of a week will return 0
1350         return _timeDiff.div(mintPeriodDuration);
1351     }
1352 
1353     function isMintable()
1354         public
1355         view
1356         returns (bool)
1357     {
1358         bool mintable = false;
1359         if (now - lastMintEvent > mintPeriodDuration && now <= schedules[6].endPeriod) // Ensure time is not after end of Year 7
1360         {
1361             mintable = true;
1362         }
1363         return mintable;
1364     }
1365 
1366     // Return the current schedule based on the timestamp
1367     // applicable based on startPeriod and endPeriod
1368     function getCurrentSchedule()
1369         public
1370         view
1371         returns (uint)
1372     {
1373         require(now <= schedules[6].endPeriod, "Mintable periods have ended");
1374 
1375         for (uint i = 0; i < INFLATION_SCHEDULES_LENGTH; i++) {
1376             if (schedules[i].startPeriod <= now && schedules[i].endPeriod >= now) {
1377                 return i;
1378             }
1379         }
1380     }
1381 
1382     function _remainingSupplyFromPreviousYear(uint currentSchedule)
1383         internal
1384         view
1385         returns (uint)
1386     {
1387         // All supply has been minted for previous period if last minting event is after
1388         // the endPeriod for last year
1389         if (currentSchedule == 0 || lastMintEvent > schedules[currentSchedule - 1].endPeriod) {
1390             return 0;
1391         }
1392 
1393         // return the remaining supply to be minted for previous period missed
1394         uint amountInPeriod = schedules[currentSchedule - 1].totalSupply.sub(schedules[currentSchedule - 1].totalSupplyMinted);
1395 
1396         // Ensure previous period remaining amount is not less than 0
1397         if (amountInPeriod < 0) {
1398             return 0;
1399         }
1400 
1401         return amountInPeriod;
1402     }
1403 
1404     // ========== MUTATIVE FUNCTIONS ==========
1405     function updateMintValues()
1406         external
1407         onlySynthetix
1408         returns (bool)
1409     {
1410         // Will fail if the time is outside of schedules
1411         uint currentIndex = getCurrentSchedule();
1412         uint lastPeriodAmount = _remainingSupplyFromPreviousYear(currentIndex);
1413         uint currentPeriodAmount = mintableSupply().sub(lastPeriodAmount);
1414 
1415         // Update schedule[n - 1].totalSupplyMinted
1416         if (lastPeriodAmount > 0) {
1417             schedules[currentIndex - 1].totalSupplyMinted = schedules[currentIndex - 1].totalSupplyMinted.add(lastPeriodAmount);
1418         }
1419 
1420         // Update schedule.totalSupplyMinted for currentSchedule
1421         schedules[currentIndex].totalSupplyMinted = schedules[currentIndex].totalSupplyMinted.add(currentPeriodAmount);
1422         // Update mint event to now
1423         lastMintEvent = now;
1424 
1425         emit SupplyMinted(lastPeriodAmount, currentPeriodAmount, currentIndex, now);
1426         return true;
1427     }
1428 
1429     function setMinterReward(uint _amount)
1430         external
1431         onlyOwner
1432     {
1433         minterReward = _amount;
1434         emit MinterRewardUpdated(_amount);
1435     }
1436 
1437     // ========== MODIFIERS ==========
1438 
1439     modifier onlySynthetix() {
1440         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
1441         _;
1442     }
1443 
1444     /* ========== EVENTS ========== */
1445 
1446     event SupplyMinted(uint previousPeriodAmount, uint currentAmount, uint indexed schedule, uint timestamp);
1447     event MinterRewardUpdated(uint newRewardAmount);
1448 }
1449 
1450 
1451 /*
1452 -----------------------------------------------------------------
1453 MODULE DESCRIPTION
1454 -----------------------------------------------------------------
1455 
1456 A contract that any other contract in the Synthetix system can query
1457 for the current market value of various assets, including
1458 crypto assets as well as various fiat assets.
1459 
1460 This contract assumes that rate updates will completely update
1461 all rates to their current values. If a rate shock happens
1462 on a single asset, the oracle will still push updated rates
1463 for all other assets.
1464 
1465 -----------------------------------------------------------------
1466 */
1467 
1468 
1469 /**
1470  * @title The repository for exchange rates
1471  */
1472 
1473 contract ExchangeRates is SelfDestructible {
1474 
1475 
1476     using SafeMath for uint;
1477     using SafeDecimalMath for uint;
1478 
1479     struct RateAndUpdatedTime {
1480         uint216 rate;
1481         uint40 time;
1482     }
1483 
1484     // Exchange rates and update times stored by currency code, e.g. 'SNX', or 'sUSD'
1485     mapping(bytes32 => RateAndUpdatedTime) private _rates;
1486 
1487     // The address of the oracle which pushes rate updates to this contract
1488     address public oracle;
1489 
1490     // Do not allow the oracle to submit times any further forward into the future than this constant.
1491     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
1492 
1493     // How long will the contract assume the rate of any asset is correct
1494     uint public rateStalePeriod = 3 hours;
1495 
1496 
1497     // Each participating currency in the XDR basket is represented as a currency key with
1498     // equal weighting.
1499     // There are 5 participating currencies, so we'll declare that clearly.
1500     bytes32[5] public xdrParticipants;
1501 
1502     // A conveience mapping for checking if a rate is a XDR participant
1503     mapping(bytes32 => bool) public isXDRParticipant;
1504 
1505     // For inverted prices, keep a mapping of their entry, limits and frozen status
1506     struct InversePricing {
1507         uint entryPoint;
1508         uint upperLimit;
1509         uint lowerLimit;
1510         bool frozen;
1511     }
1512     mapping(bytes32 => InversePricing) public inversePricing;
1513     bytes32[] public invertedKeys;
1514 
1515     //
1516     // ========== CONSTRUCTOR ==========
1517 
1518     /**
1519      * @dev Constructor
1520      * @param _owner The owner of this contract.
1521      * @param _oracle The address which is able to update rate information.
1522      * @param _currencyKeys The initial currency keys to store (in order).
1523      * @param _newRates The initial currency amounts for each currency (in order).
1524      */
1525     constructor(
1526         // SelfDestructible (Ownable)
1527         address _owner,
1528 
1529         // Oracle values - Allows for rate updates
1530         address _oracle,
1531         bytes32[] _currencyKeys,
1532         uint[] _newRates
1533     )
1534         /* Owned is initialised in SelfDestructible */
1535         SelfDestructible(_owner)
1536         public
1537     {
1538         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
1539 
1540         oracle = _oracle;
1541 
1542         // The sUSD rate is always 1 and is never stale.
1543         _setRate("sUSD", SafeDecimalMath.unit(), now);
1544 
1545         // These are the currencies that make up the XDR basket.
1546         // These are hard coded because:
1547         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
1548         //  - Adding new currencies would likely introduce some kind of weighting factor, which
1549         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
1550         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
1551         //    then point the system at the new version.
1552         xdrParticipants = [
1553             bytes32("sUSD"),
1554             bytes32("sAUD"),
1555             bytes32("sCHF"),
1556             bytes32("sEUR"),
1557             bytes32("sGBP")
1558         ];
1559 
1560         // Mapping the XDR participants is cheaper than looping the xdrParticipants array to check if they exist
1561         isXDRParticipant[bytes32("sUSD")] = true;
1562         isXDRParticipant[bytes32("sAUD")] = true;
1563         isXDRParticipant[bytes32("sCHF")] = true;
1564         isXDRParticipant[bytes32("sEUR")] = true;
1565         isXDRParticipant[bytes32("sGBP")] = true;
1566 
1567         internalUpdateRates(_currencyKeys, _newRates, now);
1568     }
1569 
1570     function rates(bytes32 code) public view returns(uint256) {
1571         return uint256(_rates[code].rate);
1572     }
1573 
1574     function lastRateUpdateTimes(bytes32 code) public view returns(uint256) {
1575         return uint256(_rates[code].time);
1576     }
1577 
1578     function _setRate(bytes32 code, uint256 rate, uint256 time) internal {
1579         _rates[code] = RateAndUpdatedTime({
1580             rate: uint216(rate),
1581             time: uint40(time)
1582         });
1583     }
1584 
1585     /* ========== SETTERS ========== */
1586 
1587     /**
1588      * @notice Set the rates stored in this contract
1589      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1590      * @param newRates The rates for each currency (in order)
1591      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1592      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1593      *                 if it takes a long time for the transaction to confirm.
1594      */
1595     function updateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
1596         external
1597         onlyOracle
1598         returns(bool)
1599     {
1600         return internalUpdateRates(currencyKeys, newRates, timeSent);
1601     }
1602 
1603     /**
1604      * @notice Internal function which sets the rates stored in this contract
1605      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1606      * @param newRates The rates for each currency (in order)
1607      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1608      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1609      *                 if it takes a long time for the transaction to confirm.
1610      */
1611     function internalUpdateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
1612         internal
1613         returns(bool)
1614     {
1615         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
1616         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
1617 
1618         bool recomputeXDRRate = false;
1619 
1620         // Loop through each key and perform update.
1621         for (uint i = 0; i < currencyKeys.length; i++) {
1622             bytes32 currencyKey = currencyKeys[i];
1623 
1624             // Should not set any rate to zero ever, as no asset will ever be
1625             // truely worthless and still valid. In this scenario, we should
1626             // delete the rate and remove it from the system.
1627             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
1628             require(currencyKey != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
1629 
1630             // We should only update the rate if it's at least the same age as the last rate we've got.
1631             if (timeSent < lastRateUpdateTimes(currencyKey)) {
1632                 continue;
1633             }
1634 
1635             newRates[i] = rateOrInverted(currencyKey, newRates[i]);
1636 
1637             // Ok, go ahead with the update.
1638             _setRate(currencyKey, newRates[i], timeSent);
1639 
1640             // Flag if XDR needs to be recomputed. Note: sUSD is not sent and assumed $1
1641             if (!recomputeXDRRate && isXDRParticipant[currencyKey]) {
1642                 recomputeXDRRate = true;
1643             }
1644         }
1645 
1646         emit RatesUpdated(currencyKeys, newRates);
1647 
1648         if (recomputeXDRRate) {
1649             // Now update our XDR rate.
1650             updateXDRRate(timeSent);
1651         }
1652 
1653         return true;
1654     }
1655 
1656     /**
1657      * @notice Internal function to get the inverted rate, if any, and mark an inverted
1658      *  key as frozen if either limits are reached.
1659      *
1660      * Inverted rates are ones that take a regular rate, perform a simple calculation (double entryPrice and
1661      * subtract the rate) on them and if the result of the calculation is over or under predefined limits, it freezes the
1662      * rate at that limit, preventing any future rate updates.
1663      *
1664      * For example, if we have an inverted rate iBTC with the following parameters set:
1665      * - entryPrice of 200
1666      * - upperLimit of 300
1667      * - lower of 100
1668      *
1669      * if this function is invoked with params iETH and 184 (or rather 184e18),
1670      * then the rate would be: 200 * 2 - 184 = 216. 100 < 216 < 200, so the rate would be 216,
1671      * and remain unfrozen.
1672      *
1673      * If this function is then invoked with params iETH and 301 (or rather 301e18),
1674      * then the rate would be: 200 * 2 - 301 = 99. 99 < 100, so the rate would be 100 and the
1675      * rate would become frozen, no longer accepting future price updates until the synth is unfrozen
1676      * by the owner function: setInversePricing().
1677      *
1678      * @param currencyKey The price key to lookup
1679      * @param rate The rate for the given price key
1680      */
1681     function rateOrInverted(bytes32 currencyKey, uint rate) internal returns (uint) {
1682         // if an inverse mapping exists, adjust the price accordingly
1683         InversePricing storage inverse = inversePricing[currencyKey];
1684         if (inverse.entryPoint <= 0) {
1685             return rate;
1686         }
1687 
1688         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
1689         uint newInverseRate = rates(currencyKey);
1690 
1691         // get the new inverted rate if not frozen
1692         if (!inverse.frozen) {
1693             uint doubleEntryPoint = inverse.entryPoint.mul(2);
1694             if (doubleEntryPoint <= rate) {
1695                 // avoid negative numbers for unsigned ints, so set this to 0
1696                 // which by the requirement that lowerLimit be > 0 will
1697                 // cause this to freeze the price to the lowerLimit
1698                 newInverseRate = 0;
1699             } else {
1700                 newInverseRate = doubleEntryPoint.sub(rate);
1701             }
1702 
1703             // now if new rate hits our limits, set it to the limit and freeze
1704             if (newInverseRate >= inverse.upperLimit) {
1705                 newInverseRate = inverse.upperLimit;
1706             } else if (newInverseRate <= inverse.lowerLimit) {
1707                 newInverseRate = inverse.lowerLimit;
1708             }
1709 
1710             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
1711                 inverse.frozen = true;
1712                 emit InversePriceFrozen(currencyKey);
1713             }
1714         }
1715 
1716         return newInverseRate;
1717     }
1718 
1719     /**
1720      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
1721      */
1722     function updateXDRRate(uint timeSent)
1723         internal
1724     {
1725         uint total = 0;
1726 
1727         for (uint i = 0; i < xdrParticipants.length; i++) {
1728             total = rates(xdrParticipants[i]).add(total);
1729         }
1730 
1731         // Set the rate and update time
1732         _setRate("XDR", total, timeSent);
1733 
1734         // Emit our updated event separate to the others to save
1735         // moving data around between arrays.
1736         bytes32[] memory eventCurrencyCode = new bytes32[](1);
1737         eventCurrencyCode[0] = "XDR";
1738 
1739         uint[] memory eventRate = new uint[](1);
1740         eventRate[0] = rates("XDR");
1741 
1742         emit RatesUpdated(eventCurrencyCode, eventRate);
1743     }
1744 
1745     /**
1746      * @notice Delete a rate stored in the contract
1747      * @param currencyKey The currency key you wish to delete the rate for
1748      */
1749     function deleteRate(bytes32 currencyKey)
1750         external
1751         onlyOracle
1752     {
1753         require(rates(currencyKey) > 0, "Rate is zero");
1754 
1755         delete _rates[currencyKey];
1756 
1757         emit RateDeleted(currencyKey);
1758     }
1759 
1760     /**
1761      * @notice Set the Oracle that pushes the rate information to this contract
1762      * @param _oracle The new oracle address
1763      */
1764     function setOracle(address _oracle)
1765         external
1766         onlyOwner
1767     {
1768         oracle = _oracle;
1769         emit OracleUpdated(oracle);
1770     }
1771 
1772     /**
1773      * @notice Set the stale period on the updated rate variables
1774      * @param _time The new rateStalePeriod
1775      */
1776     function setRateStalePeriod(uint _time)
1777         external
1778         onlyOwner
1779     {
1780         rateStalePeriod = _time;
1781         emit RateStalePeriodUpdated(rateStalePeriod);
1782     }
1783 
1784     /**
1785      * @notice Set an inverse price up for the currency key.
1786      *
1787      * An inverse price is one which has an entryPoint, an uppper and a lower limit. Each update, the
1788      * rate is calculated as double the entryPrice minus the current rate. If this calculation is
1789      * above or below the upper or lower limits respectively, then the rate is frozen, and no more
1790      * rate updates will be accepted.
1791      *
1792      * @param currencyKey The currency to update
1793      * @param entryPoint The entry price point of the inverted price
1794      * @param upperLimit The upper limit, at or above which the price will be frozen
1795      * @param lowerLimit The lower limit, at or below which the price will be frozen
1796      * @param freeze Whether or not to freeze this rate immediately. Note: no frozen event will be configured
1797      * @param freezeAtUpperLimit When the freeze flag is true, this flag indicates whether the rate
1798      * to freeze at is the upperLimit or lowerLimit..
1799      */
1800     function setInversePricing(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit, bool freeze, bool freezeAtUpperLimit)
1801         external onlyOwner
1802     {
1803         require(entryPoint > 0, "entryPoint must be above 0");
1804         require(lowerLimit > 0, "lowerLimit must be above 0");
1805         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
1806         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
1807         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
1808 
1809         if (inversePricing[currencyKey].entryPoint <= 0) {
1810             // then we are adding a new inverse pricing, so add this
1811             invertedKeys.push(currencyKey);
1812         }
1813         inversePricing[currencyKey].entryPoint = entryPoint;
1814         inversePricing[currencyKey].upperLimit = upperLimit;
1815         inversePricing[currencyKey].lowerLimit = lowerLimit;
1816         inversePricing[currencyKey].frozen = freeze;
1817 
1818         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
1819 
1820         // When indicating to freeze, we need to know the rate to freeze it at - either upper or lower
1821         // this is useful in situations where ExchangeRates is updated and there are existing inverted
1822         // rates already frozen in the current contract that need persisting across the upgrade
1823         if (freeze) {
1824             emit InversePriceFrozen(currencyKey);
1825 
1826             _setRate(currencyKey, freezeAtUpperLimit ? upperLimit : lowerLimit, now);
1827         }
1828     }
1829 
1830     /**
1831      * @notice Remove an inverse price for the currency key
1832      * @param currencyKey The currency to remove inverse pricing for
1833      */
1834     function removeInversePricing(bytes32 currencyKey) external onlyOwner
1835     {
1836         require(inversePricing[currencyKey].entryPoint > 0, "No inverted price exists");
1837 
1838         inversePricing[currencyKey].entryPoint = 0;
1839         inversePricing[currencyKey].upperLimit = 0;
1840         inversePricing[currencyKey].lowerLimit = 0;
1841         inversePricing[currencyKey].frozen = false;
1842 
1843         // now remove inverted key from array
1844         for (uint i = 0; i < invertedKeys.length; i++) {
1845             if (invertedKeys[i] == currencyKey) {
1846                 delete invertedKeys[i];
1847 
1848                 // Copy the last key into the place of the one we just deleted
1849                 // If there's only one key, this is array[0] = array[0].
1850                 // If we're deleting the last one, it's also a NOOP in the same way.
1851                 invertedKeys[i] = invertedKeys[invertedKeys.length - 1];
1852 
1853                 // Decrease the size of the array by one.
1854                 invertedKeys.length--;
1855 
1856                 // Track the event
1857                 emit InversePriceConfigured(currencyKey, 0, 0, 0);
1858 
1859                 return;
1860             }
1861         }
1862     }
1863     /* ========== VIEWS ========== */
1864 
1865     /**
1866      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
1867      * @param sourceCurrencyKey The currency the amount is specified in
1868      * @param sourceAmount The source amount, specified in UNIT base
1869      * @param destinationCurrencyKey The destination currency
1870      */
1871     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
1872         public
1873         view
1874         rateNotStale(sourceCurrencyKey)
1875         rateNotStale(destinationCurrencyKey)
1876         returns (uint)
1877     {
1878         // If there's no change in the currency, then just return the amount they gave us
1879         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
1880 
1881         // Calculate the effective value by going from source -> USD -> destination
1882         return sourceAmount.multiplyDecimalRound(rateForCurrency(sourceCurrencyKey))
1883             .divideDecimalRound(rateForCurrency(destinationCurrencyKey));
1884     }
1885 
1886     /**
1887      * @notice Retrieve the rate for a specific currency
1888      */
1889     function rateForCurrency(bytes32 currencyKey)
1890         public
1891         view
1892         returns (uint)
1893     {
1894         return rates(currencyKey);
1895     }
1896 
1897     /**
1898      * @notice Retrieve the rates for a list of currencies
1899      */
1900     function ratesForCurrencies(bytes32[] currencyKeys)
1901         public
1902         view
1903         returns (uint[])
1904     {
1905         uint[] memory _localRates = new uint[](currencyKeys.length);
1906 
1907         for (uint i = 0; i < currencyKeys.length; i++) {
1908             _localRates[i] = rates(currencyKeys[i]);
1909         }
1910 
1911         return _localRates;
1912     }
1913 
1914     /**
1915      * @notice Retrieve the rates and isAnyStale for a list of currencies
1916      */
1917     function ratesAndStaleForCurrencies(bytes32[] currencyKeys)
1918         public
1919         view
1920         returns (uint[], bool)
1921     {
1922         uint[] memory _localRates = new uint[](currencyKeys.length);
1923 
1924         bool anyRateStale = false;
1925         uint period = rateStalePeriod;
1926         for (uint i = 0; i < currencyKeys.length; i++) {
1927             RateAndUpdatedTime memory rateAndUpdateTime = _rates[currencyKeys[i]];
1928             _localRates[i] = uint256(rateAndUpdateTime.rate);
1929             if (!anyRateStale) {
1930                 anyRateStale = (currencyKeys[i] != "sUSD" && uint256(rateAndUpdateTime.time).add(period) < now);
1931             }
1932         }
1933 
1934         return (_localRates, anyRateStale);
1935     }
1936 
1937     /**
1938      * @notice Retrieve a list of last update times for specific currencies
1939      */
1940     function lastRateUpdateTimeForCurrency(bytes32 currencyKey)
1941         public
1942         view
1943         returns (uint)
1944     {
1945         return lastRateUpdateTimes(currencyKey);
1946     }
1947 
1948     /**
1949      * @notice Retrieve the last update time for a specific currency
1950      */
1951     function lastRateUpdateTimesForCurrencies(bytes32[] currencyKeys)
1952         public
1953         view
1954         returns (uint[])
1955     {
1956         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
1957 
1958         for (uint i = 0; i < currencyKeys.length; i++) {
1959             lastUpdateTimes[i] = lastRateUpdateTimes(currencyKeys[i]);
1960         }
1961 
1962         return lastUpdateTimes;
1963     }
1964 
1965     /**
1966      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
1967      */
1968     function rateIsStale(bytes32 currencyKey)
1969         public
1970         view
1971         returns (bool)
1972     {
1973         // sUSD is a special case and is never stale.
1974         if (currencyKey == "sUSD") return false;
1975 
1976         return lastRateUpdateTimes(currencyKey).add(rateStalePeriod) < now;
1977     }
1978 
1979     /**
1980      * @notice Check if any rate is frozen (cannot be exchanged into)
1981      */
1982     function rateIsFrozen(bytes32 currencyKey)
1983         external
1984         view
1985         returns (bool)
1986     {
1987         return inversePricing[currencyKey].frozen;
1988     }
1989 
1990 
1991     /**
1992      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
1993      */
1994     function anyRateIsStale(bytes32[] currencyKeys)
1995         external
1996         view
1997         returns (bool)
1998     {
1999         // Loop through each key and check whether the data point is stale.
2000         uint256 i = 0;
2001 
2002         while (i < currencyKeys.length) {
2003             // sUSD is a special case and is never false
2004             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes(currencyKeys[i]).add(rateStalePeriod) < now) {
2005                 return true;
2006             }
2007             i += 1;
2008         }
2009 
2010         return false;
2011     }
2012 
2013     /* ========== MODIFIERS ========== */
2014 
2015     modifier rateNotStale(bytes32 currencyKey) {
2016         require(!rateIsStale(currencyKey), "Rate stale or nonexistant currency");
2017         _;
2018     }
2019 
2020     modifier onlyOracle
2021     {
2022         require(msg.sender == oracle, "Only the oracle can perform this action");
2023         _;
2024     }
2025 
2026     /* ========== EVENTS ========== */
2027 
2028     event OracleUpdated(address newOracle);
2029     event RateStalePeriodUpdated(uint rateStalePeriod);
2030     event RatesUpdated(bytes32[] currencyKeys, uint[] newRates);
2031     event RateDeleted(bytes32 currencyKey);
2032     event InversePriceConfigured(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
2033     event InversePriceFrozen(bytes32 currencyKey);
2034 }
2035 
2036 
2037 /*
2038 -----------------------------------------------------------------
2039 FILE INFORMATION
2040 -----------------------------------------------------------------
2041 
2042 file:       LimitedSetup.sol
2043 version:    1.1
2044 author:     Anton Jurisevic
2045 
2046 date:       2018-05-15
2047 
2048 -----------------------------------------------------------------
2049 MODULE DESCRIPTION
2050 -----------------------------------------------------------------
2051 
2052 A contract with a limited setup period. Any function modified
2053 with the setup modifier will cease to work after the
2054 conclusion of the configurable-length post-construction setup period.
2055 
2056 -----------------------------------------------------------------
2057 */
2058 
2059 
2060 /**
2061  * @title Any function decorated with the modifier this contract provides
2062  * deactivates after a specified setup period.
2063  */
2064 contract LimitedSetup {
2065 
2066     uint setupExpiryTime;
2067 
2068     /**
2069      * @dev LimitedSetup Constructor.
2070      * @param setupDuration The time the setup period will last for.
2071      */
2072     constructor(uint setupDuration)
2073         public
2074     {
2075         setupExpiryTime = now + setupDuration;
2076     }
2077 
2078     modifier onlyDuringSetup
2079     {
2080         require(now < setupExpiryTime, "Can only perform this action during setup");
2081         _;
2082     }
2083 }
2084 
2085 
2086 /*
2087 -----------------------------------------------------------------
2088 FILE INFORMATION
2089 -----------------------------------------------------------------
2090 
2091 file:       SynthetixState.sol
2092 version:    1.0
2093 author:     Kevin Brown
2094 date:       2018-10-19
2095 
2096 -----------------------------------------------------------------
2097 MODULE DESCRIPTION
2098 -----------------------------------------------------------------
2099 
2100 A contract that holds issuance state and preferred currency of
2101 users in the Synthetix system.
2102 
2103 This contract is used side by side with the Synthetix contract
2104 to make it easier to upgrade the contract logic while maintaining
2105 issuance state.
2106 
2107 The Synthetix contract is also quite large and on the edge of
2108 being beyond the contract size limit without moving this information
2109 out to another contract.
2110 
2111 The first deployed contract would create this state contract,
2112 using it as its store of issuance data.
2113 
2114 When a new contract is deployed, it links to the existing
2115 state contract, whose owner would then change its associated
2116 contract to the new one.
2117 
2118 -----------------------------------------------------------------
2119 */
2120 
2121 
2122 /**
2123  * @title Synthetix State
2124  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
2125  */
2126 contract SynthetixState is State, LimitedSetup {
2127     using SafeMath for uint;
2128     using SafeDecimalMath for uint;
2129 
2130     // A struct for handing values associated with an individual user's debt position
2131     struct IssuanceData {
2132         // Percentage of the total debt owned at the time
2133         // of issuance. This number is modified by the global debt
2134         // delta array. You can figure out a user's exit price and
2135         // collateralisation ratio using a combination of their initial
2136         // debt and the slice of global debt delta which applies to them.
2137         uint initialDebtOwnership;
2138         // This lets us know when (in relative terms) the user entered
2139         // the debt pool so we can calculate their exit price and
2140         // collateralistion ratio
2141         uint debtEntryIndex;
2142     }
2143 
2144     // Issued synth balances for individual fee entitlements and exit price calculations
2145     mapping(address => IssuanceData) public issuanceData;
2146 
2147     // The total count of people that have outstanding issued synths in any flavour
2148     uint public totalIssuerCount;
2149 
2150     // Global debt pool tracking
2151     uint[] public debtLedger;
2152 
2153     // Import state
2154     uint public importedXDRAmount;
2155 
2156     // A quantity of synths greater than this ratio
2157     // may not be issued against a given value of SNX.
2158     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
2159     // No more synths may be issued than the value of SNX backing them.
2160     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
2161 
2162     // Users can specify their preferred currency, in which case all synths they receive
2163     // will automatically exchange to that preferred currency upon receipt in their wallet
2164     mapping(address => bytes4) public preferredCurrency;
2165 
2166     /**
2167      * @dev Constructor
2168      * @param _owner The address which controls this contract.
2169      * @param _associatedContract The ERC20 contract whose state this composes.
2170      */
2171     constructor(address _owner, address _associatedContract)
2172         State(_owner, _associatedContract)
2173         LimitedSetup(1 weeks)
2174         public
2175     {}
2176 
2177     /* ========== SETTERS ========== */
2178 
2179     /**
2180      * @notice Set issuance data for an address
2181      * @dev Only the associated contract may call this.
2182      * @param account The address to set the data for.
2183      * @param initialDebtOwnership The initial debt ownership for this address.
2184      */
2185     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
2186         external
2187         onlyAssociatedContract
2188     {
2189         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
2190         issuanceData[account].debtEntryIndex = debtLedger.length;
2191     }
2192 
2193     /**
2194      * @notice Clear issuance data for an address
2195      * @dev Only the associated contract may call this.
2196      * @param account The address to clear the data for.
2197      */
2198     function clearIssuanceData(address account)
2199         external
2200         onlyAssociatedContract
2201     {
2202         delete issuanceData[account];
2203     }
2204 
2205     /**
2206      * @notice Increment the total issuer count
2207      * @dev Only the associated contract may call this.
2208      */
2209     function incrementTotalIssuerCount()
2210         external
2211         onlyAssociatedContract
2212     {
2213         totalIssuerCount = totalIssuerCount.add(1);
2214     }
2215 
2216     /**
2217      * @notice Decrement the total issuer count
2218      * @dev Only the associated contract may call this.
2219      */
2220     function decrementTotalIssuerCount()
2221         external
2222         onlyAssociatedContract
2223     {
2224         totalIssuerCount = totalIssuerCount.sub(1);
2225     }
2226 
2227     /**
2228      * @notice Append a value to the debt ledger
2229      * @dev Only the associated contract may call this.
2230      * @param value The new value to be added to the debt ledger.
2231      */
2232     function appendDebtLedgerValue(uint value)
2233         external
2234         onlyAssociatedContract
2235     {
2236         debtLedger.push(value);
2237     }
2238 
2239     /**
2240      * @notice Set preferred currency for a user
2241      * @dev Only the associated contract may call this.
2242      * @param account The account to set the preferred currency for
2243      * @param currencyKey The new preferred currency
2244      */
2245     function setPreferredCurrency(address account, bytes4 currencyKey)
2246         external
2247         onlyAssociatedContract
2248     {
2249         preferredCurrency[account] = currencyKey;
2250     }
2251 
2252     /**
2253      * @notice Set the issuanceRatio for issuance calculations.
2254      * @dev Only callable by the contract owner.
2255      */
2256     function setIssuanceRatio(uint _issuanceRatio)
2257         external
2258         onlyOwner
2259     {
2260         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
2261         issuanceRatio = _issuanceRatio;
2262         emit IssuanceRatioUpdated(_issuanceRatio);
2263     }
2264 
2265     /**
2266      * @notice Import issuer data from the old Synthetix contract before multicurrency
2267      * @dev Only callable by the contract owner, and only for 1 week after deployment.
2268      */
2269     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
2270         external
2271         onlyOwner
2272         onlyDuringSetup
2273     {
2274         require(accounts.length == sUSDAmounts.length, "Length mismatch");
2275 
2276         for (uint8 i = 0; i < accounts.length; i++) {
2277             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
2278         }
2279     }
2280 
2281     /**
2282      * @notice Import issuer data from the old Synthetix contract before multicurrency
2283      * @dev Only used from importIssuerData above, meant to be disposable
2284      */
2285     function _addToDebtRegister(address account, uint amount)
2286         internal
2287     {
2288         // This code is duplicated from Synthetix so that we can call it directly here
2289         // during setup only.
2290         Synthetix synthetix = Synthetix(associatedContract);
2291 
2292         // What is the value of the requested debt in XDRs?
2293         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
2294 
2295         // What is the value that we've previously imported?
2296         uint totalDebtIssued = importedXDRAmount;
2297 
2298         // What will the new total be including the new value?
2299         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2300 
2301         // Save that for the next import.
2302         importedXDRAmount = newTotalDebtIssued;
2303 
2304         // What is their percentage (as a high precision int) of the total debt?
2305         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2306 
2307         // And what effect does this percentage have on the global debt holding of other issuers?
2308         // The delta specifically needs to not take into account any existing debt as it's already
2309         // accounted for in the delta from when they issued previously.
2310         // The delta is a high precision integer.
2311         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2312 
2313         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
2314 
2315         // And what does their debt ownership look like including this previous stake?
2316         if (existingDebt > 0) {
2317             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2318         }
2319 
2320         // Are they a new issuer? If so, record them.
2321         if (issuanceData[account].initialDebtOwnership == 0) {
2322             totalIssuerCount = totalIssuerCount.add(1);
2323         }
2324 
2325         // Save the debt entry parameters
2326         issuanceData[account].initialDebtOwnership = debtPercentage;
2327         issuanceData[account].debtEntryIndex = debtLedger.length;
2328 
2329         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2330         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2331         if (debtLedger.length > 0) {
2332             debtLedger.push(
2333                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2334             );
2335         } else {
2336             debtLedger.push(SafeDecimalMath.preciseUnit());
2337         }
2338     }
2339 
2340     /* ========== VIEWS ========== */
2341 
2342     /**
2343      * @notice Retrieve the length of the debt ledger array
2344      */
2345     function debtLedgerLength()
2346         external
2347         view
2348         returns (uint)
2349     {
2350         return debtLedger.length;
2351     }
2352 
2353     /**
2354      * @notice Retrieve the most recent entry from the debt ledger
2355      */
2356     function lastDebtLedgerEntry()
2357         external
2358         view
2359         returns (uint)
2360     {
2361         return debtLedger[debtLedger.length - 1];
2362     }
2363 
2364     /**
2365      * @notice Query whether an account has issued and has an outstanding debt balance
2366      * @param account The address to query for
2367      */
2368     function hasIssued(address account)
2369         external
2370         view
2371         returns (bool)
2372     {
2373         return issuanceData[account].initialDebtOwnership > 0;
2374     }
2375 
2376     event IssuanceRatioUpdated(uint newRatio);
2377 }
2378 
2379 
2380 /**
2381  * @title FeePool Interface
2382  * @notice Abstract contract to hold public getters
2383  */
2384 contract IFeePool {
2385     address public FEE_ADDRESS;
2386     uint public exchangeFeeRate;
2387     function amountReceivedFromExchange(uint value) external view returns (uint);
2388     function amountReceivedFromTransfer(uint value) external view returns (uint);
2389     function recordFeePaid(uint xdrAmount) external;
2390     function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
2391     function setRewardsToDistribute(uint amount) external;
2392 }
2393 
2394 
2395 /**
2396  * @title SynthetixState interface contract
2397  * @notice Abstract contract to hold public getters
2398  */
2399 contract ISynthetixState {
2400     // A struct for handing values associated with an individual user's debt position
2401     struct IssuanceData {
2402         // Percentage of the total debt owned at the time
2403         // of issuance. This number is modified by the global debt
2404         // delta array. You can figure out a user's exit price and
2405         // collateralisation ratio using a combination of their initial
2406         // debt and the slice of global debt delta which applies to them.
2407         uint initialDebtOwnership;
2408         // This lets us know when (in relative terms) the user entered
2409         // the debt pool so we can calculate their exit price and
2410         // collateralistion ratio
2411         uint debtEntryIndex;
2412     }
2413 
2414     uint[] public debtLedger;
2415     uint public issuanceRatio;
2416     mapping(address => IssuanceData) public issuanceData;
2417 
2418     function debtLedgerLength() external view returns (uint);
2419     function hasIssued(address account) external view returns (bool);
2420     function incrementTotalIssuerCount() external;
2421     function decrementTotalIssuerCount() external;
2422     function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
2423     function lastDebtLedgerEntry() external view returns (uint);
2424     function appendDebtLedgerValue(uint value) external;
2425     function clearIssuanceData(address account) external;
2426 }
2427 
2428 
2429 interface ISynth {
2430     function burn(address account, uint amount) external;
2431     function issue(address account, uint amount) external;
2432     function transfer(address to, uint value) public returns (bool);
2433     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount) external;
2434     function transferFrom(address from, address to, uint value) public returns (bool);
2435 }
2436 
2437 
2438 /**
2439  * @title SynthetixEscrow interface
2440  */
2441 interface ISynthetixEscrow {
2442     function balanceOf(address account) public view returns (uint);
2443     function appendVestingEntry(address account, uint quantity) public;
2444 }
2445 
2446 
2447 /**
2448  * @title ExchangeRates interface
2449  */
2450 interface IExchangeRates {
2451     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey) external view returns (uint);
2452 
2453     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
2454     function ratesForCurrencies(bytes32[] currencyKeys) external view returns (uint[] memory);
2455 
2456     function rateIsStale(bytes32 currencyKey) external view returns (bool);
2457     function anyRateIsStale(bytes32[] currencyKeys) external view returns (bool);
2458 }
2459 
2460 
2461 /**
2462  * @title Synthetix interface contract
2463  * @notice Abstract contract to hold public getters
2464  * @dev pseudo interface, actually declared as contract to hold the public getters 
2465  */
2466 
2467 
2468 contract ISynthetix {
2469 
2470     // ========== PUBLIC STATE VARIABLES ==========
2471 
2472     IFeePool public feePool;
2473     ISynthetixEscrow public escrow;
2474     ISynthetixEscrow public rewardEscrow;
2475     ISynthetixState public synthetixState;
2476     IExchangeRates public exchangeRates;
2477 
2478     mapping(bytes32 => Synth) public synths;
2479 
2480     // ========== PUBLIC FUNCTIONS ==========
2481 
2482     function balanceOf(address account) public view returns (uint);
2483     function transfer(address to, uint value) public returns (bool);
2484     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey) public view returns (uint);
2485 
2486     function synthInitiatedExchange(
2487         address from,
2488         bytes32 sourceCurrencyKey,
2489         uint sourceAmount,
2490         bytes32 destinationCurrencyKey,
2491         address destinationAddress) external returns (bool);
2492     function exchange(
2493         bytes32 sourceCurrencyKey,
2494         uint sourceAmount,
2495         bytes32 destinationCurrencyKey) external returns (bool);
2496     function collateralisationRatio(address issuer) public view returns (uint);
2497     function totalIssuedSynths(bytes32 currencyKey)
2498         public
2499         view
2500         returns (uint);
2501     function getSynth(bytes32 currencyKey) public view returns (ISynth);
2502     function debtBalanceOf(address issuer, bytes32 currencyKey) public view returns (uint);
2503 }
2504 
2505 
2506 /*
2507 -----------------------------------------------------------------
2508 FILE INFORMATION
2509 -----------------------------------------------------------------
2510 
2511 file:       Synth.sol
2512 version:    2.0
2513 author:     Kevin Brown
2514 date:       2018-09-13
2515 
2516 -----------------------------------------------------------------
2517 MODULE DESCRIPTION
2518 -----------------------------------------------------------------
2519 
2520 Synthetix-backed stablecoin contract.
2521 
2522 This contract issues synths, which are tokens that mirror various
2523 flavours of fiat currency.
2524 
2525 Synths are issuable by Synthetix Network Token (SNX) holders who
2526 have to lock up some value of their SNX to issue S * Cmax synths.
2527 Where Cmax issome value less than 1.
2528 
2529 A configurable fee is charged on synth transfers and deposited
2530 into a common pot, which Synthetix holders may withdraw from once
2531 per fee period.
2532 
2533 -----------------------------------------------------------------
2534 */
2535 
2536 
2537 contract Synth is ExternStateToken {
2538 
2539     /* ========== STATE VARIABLES ========== */
2540 
2541     // Address of the FeePoolProxy
2542     address public feePoolProxy;
2543     // Address of the SynthetixProxy
2544     address public synthetixProxy;
2545 
2546     // Currency key which identifies this Synth to the Synthetix system
2547     bytes32 public currencyKey;
2548 
2549     uint8 constant DECIMALS = 18;
2550 
2551     /* ========== CONSTRUCTOR ========== */
2552 
2553     constructor(address _proxy, TokenState _tokenState, address _synthetixProxy, address _feePoolProxy,
2554         string _tokenName, string _tokenSymbol, address _owner, bytes32 _currencyKey, uint _totalSupply
2555     )
2556         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, _totalSupply, DECIMALS, _owner)
2557         public
2558     {
2559         require(_proxy != address(0), "_proxy cannot be 0");
2560         require(_synthetixProxy != address(0), "_synthetixProxy cannot be 0");
2561         require(_feePoolProxy != address(0), "_feePoolProxy cannot be 0");
2562         require(_owner != 0, "_owner cannot be 0");
2563         require(ISynthetix(_synthetixProxy).synths(_currencyKey) == Synth(0), "Currency key is already in use");
2564 
2565         feePoolProxy = _feePoolProxy;
2566         synthetixProxy = _synthetixProxy;
2567         currencyKey = _currencyKey;
2568     }
2569 
2570     /* ========== SETTERS ========== */
2571 
2572     /**
2573      * @notice Set the SynthetixProxy should it ever change.
2574      * The Synth requires Synthetix address as it has the authority
2575      * to mint and burn synths
2576      * */
2577     function setSynthetixProxy(ISynthetix _synthetixProxy)
2578         external
2579         optionalProxy_onlyOwner
2580     {
2581         synthetixProxy = _synthetixProxy;
2582         emitSynthetixUpdated(_synthetixProxy);
2583     }
2584 
2585     /**
2586      * @notice Set the FeePoolProxy should it ever change.
2587      * The Synth requires FeePool address as it has the authority
2588      * to mint and burn for FeePool.claimFees()
2589      * */
2590     function setFeePoolProxy(address _feePoolProxy)
2591         external
2592         optionalProxy_onlyOwner
2593     {
2594         feePoolProxy = _feePoolProxy;
2595         emitFeePoolUpdated(_feePoolProxy);
2596     }
2597 
2598     /* ========== MUTATIVE FUNCTIONS ========== */
2599 
2600     /**
2601      * @notice ERC20 transfer function
2602      * forward call on to _internalTransfer */
2603     function transfer(address to, uint value)
2604         public
2605         optionalProxy
2606         returns (bool)
2607     {
2608         bytes memory empty;
2609         return super._internalTransfer(messageSender, to, value, empty);
2610     }
2611 
2612     /**
2613      * @notice ERC223 transfer function
2614      */
2615     function transfer(address to, uint value, bytes data)
2616         public
2617         optionalProxy
2618         returns (bool)
2619     {
2620         // And send their result off to the destination address
2621         return super._internalTransfer(messageSender, to, value, data);
2622     }
2623 
2624     /**
2625      * @notice ERC20 transferFrom function
2626      */
2627     function transferFrom(address from, address to, uint value)
2628         public
2629         optionalProxy
2630         returns (bool)
2631     {
2632         require(from != 0xfeefeefeefeefeefeefeefeefeefeefeefeefeef, "The fee address is not allowed");
2633         // Skip allowance update in case of infinite allowance
2634         if (tokenState.allowance(from, messageSender) != uint(-1)) {
2635             // Reduce the allowance by the amount we're transferring.
2636             // The safeSub call will handle an insufficient allowance.
2637             tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
2638         }
2639 
2640         bytes memory empty;
2641         return super._internalTransfer(from, to, value, empty);
2642     }
2643 
2644     /**
2645      * @notice ERC223 transferFrom function
2646      */
2647     function transferFrom(address from, address to, uint value, bytes data)
2648         public
2649         optionalProxy
2650         returns (bool)
2651     {
2652         require(from != 0xfeefeefeefeefeefeefeefeefeefeefeefeefeef, "The fee address is not allowed");
2653 
2654         // Skip allowance update in case of infinite allowance
2655         if (tokenState.allowance(from, messageSender) != uint(-1)) {
2656             // Reduce the allowance by the amount we're transferring.
2657             // The safeSub call will handle an insufficient allowance.
2658             tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
2659         }
2660 
2661         return super._internalTransfer(from, to, value, data);
2662     }
2663 
2664     // Allow synthetix to issue a certain number of synths from an account.
2665     function issue(address account, uint amount)
2666         external
2667         onlySynthetixOrFeePool
2668     {
2669         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
2670         totalSupply = totalSupply.add(amount);
2671         emitTransfer(address(0), account, amount);
2672         emitIssued(account, amount);
2673     }
2674 
2675     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
2676     function burn(address account, uint amount)
2677         external
2678         onlySynthetixOrFeePool
2679     {
2680         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
2681         totalSupply = totalSupply.sub(amount);
2682         emitTransfer(account, address(0), amount);
2683         emitBurned(account, amount);
2684     }
2685 
2686     // Allow owner to set the total supply on import.
2687     function setTotalSupply(uint amount)
2688         external
2689         optionalProxy_onlyOwner
2690     {
2691         totalSupply = amount;
2692     }
2693 
2694     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
2695     // exchange as well as transfer
2696     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
2697         external
2698         onlySynthetixOrFeePool
2699     {
2700         bytes memory empty;
2701         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
2702     }
2703 
2704     /* ========== MODIFIERS ========== */
2705 
2706     modifier onlySynthetixOrFeePool() {
2707         bool isSynthetix = msg.sender == address(Proxy(synthetixProxy).target());
2708         bool isFeePool = msg.sender == address(Proxy(feePoolProxy).target());
2709 
2710         require(isSynthetix || isFeePool, "Only Synthetix, FeePool allowed");
2711         _;
2712     }
2713 
2714     /* ========== EVENTS ========== */
2715 
2716     event SynthetixUpdated(address newSynthetix);
2717     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
2718     function emitSynthetixUpdated(address newSynthetix) internal {
2719         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
2720     }
2721 
2722     event FeePoolUpdated(address newFeePool);
2723     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
2724     function emitFeePoolUpdated(address newFeePool) internal {
2725         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
2726     }
2727 
2728     event Issued(address indexed account, uint value);
2729     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
2730     function emitIssued(address account, uint value) internal {
2731         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
2732     }
2733 
2734     event Burned(address indexed account, uint value);
2735     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
2736     function emitBurned(address account, uint value) internal {
2737         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
2738     }
2739 }
2740 
2741 
2742 /**
2743  * @title RewardsDistribution interface
2744  */
2745 interface IRewardsDistribution {
2746     function distributeRewards(uint amount) external;
2747 }
2748 
2749 
2750 /*
2751 -----------------------------------------------------------------
2752 FILE INFORMATION
2753 -----------------------------------------------------------------
2754 
2755 file:       Synthetix.sol
2756 version:    2.0
2757 author:     Kevin Brown
2758             Gavin Conway
2759 date:       2018-09-14
2760 
2761 -----------------------------------------------------------------
2762 MODULE DESCRIPTION
2763 -----------------------------------------------------------------
2764 
2765 Synthetix token contract. SNX is a transferable ERC20 token,
2766 and also give its holders the following privileges.
2767 
2768 == Issuance and Burning ==
2769 
2770 All synths issued require a proportional value of SNX to be locked,
2771 where the proportion is governed by the SynthetixState.issuanceRatio. This
2772 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
2773 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
2774 
2775 To determine the value of some amount of SNX(S), an oracle is used to push
2776 the price of SNX (P_S) in dollars to the ExchangeRates contract. The value of S
2777 would then be: S * P_S.
2778 
2779 Any SNX that are locked up by this issuance process cannot be transferred.
2780 The amount that is locked floats based on the price of SNX. If the price
2781 of SNX moves up, less SNX are locked, so they can be issued against,
2782 or transferred freely. If the price of SNX moves down, more SNX are locked,
2783 even going above the initial wallet balance.
2784 
2785 Any synth can be burned to repay the SNX stakers debt. SNX holders can
2786 check their current debt via debtBalanceOf(address) to see the amount
2787 of synths in any value they need to burn to unlock their staked SNX.
2788 
2789 
2790 -----------------------------------------------------------------
2791 */
2792 
2793 
2794 /**
2795  * @title Synthetix ERC20 contract.
2796  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2797  * but it also computes the quantity of fees each synthetix holder is entitled to.
2798  */
2799 contract Synthetix is ExternStateToken {
2800 
2801     // ========== STATE VARIABLES ==========
2802 
2803     // Available Synths which can be used with the system
2804     Synth[] public availableSynths;
2805     mapping(bytes32 => Synth) public synths;
2806     mapping(address => bytes32) public synthsByAddress;
2807 
2808     IFeePool public feePool;
2809     ISynthetixEscrow public escrow;
2810     ISynthetixEscrow public rewardEscrow;
2811     ExchangeRates public exchangeRates;
2812     SynthetixState public synthetixState;
2813     SupplySchedule public supplySchedule;
2814     IRewardsDistribution public rewardsDistribution;
2815 
2816     bool private protectionCircuit = false;
2817 
2818     string constant TOKEN_NAME = "Synthetix Network Token";
2819     string constant TOKEN_SYMBOL = "SNX";
2820     uint8 constant DECIMALS = 18;
2821     bool public exchangeEnabled = true;
2822     uint public gasPriceLimit;
2823 
2824     address public gasLimitOracle;
2825     // ========== CONSTRUCTOR ==========
2826 
2827     /**
2828      * @dev Constructor
2829      * @param _proxy The main token address of the Proxy contract. This will be ProxyERC20.sol
2830      * @param _tokenState Address of the external immutable contract containing token balances.
2831      * @param _synthetixState External immutable contract containing the SNX minters debt ledger.
2832      * @param _owner The owner of this contract.
2833      * @param _exchangeRates External immutable contract where the price oracle pushes prices onchain too.
2834      * @param _feePool External upgradable contract handling SNX Fees and Rewards claiming
2835      * @param _supplySchedule External immutable contract with the SNX inflationary supply schedule
2836      * @param _rewardEscrow External immutable contract for SNX Rewards Escrow
2837      * @param _escrow External immutable contract for SNX Token Sale Escrow
2838      * @param _rewardsDistribution External immutable contract managing the Rewards Distribution of the SNX inflationary supply
2839      * @param _totalSupply On upgrading set to reestablish the current total supply (This should be in SynthetixState if ever updated)
2840      */
2841     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2842         address _owner, ExchangeRates _exchangeRates, IFeePool _feePool, SupplySchedule _supplySchedule,
2843         ISynthetixEscrow _rewardEscrow, ISynthetixEscrow _escrow, IRewardsDistribution _rewardsDistribution, uint _totalSupply
2844     )
2845         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, _totalSupply, DECIMALS, _owner)
2846         public
2847     {
2848         synthetixState = _synthetixState;
2849         exchangeRates = _exchangeRates;
2850         feePool = _feePool;
2851         supplySchedule = _supplySchedule;
2852         rewardEscrow = _rewardEscrow;
2853         escrow = _escrow;
2854         rewardsDistribution = _rewardsDistribution;
2855     }
2856     // ========== SETTERS ========== */
2857 
2858     function setFeePool(IFeePool _feePool)
2859         external
2860         optionalProxy_onlyOwner
2861     {
2862         feePool = _feePool;
2863     }
2864 
2865     function setExchangeRates(ExchangeRates _exchangeRates)
2866         external
2867         optionalProxy_onlyOwner
2868     {
2869         exchangeRates = _exchangeRates;
2870     }
2871 
2872     function setProtectionCircuit(bool _protectionCircuitIsActivated)
2873         external
2874         onlyOracle
2875     {
2876         protectionCircuit = _protectionCircuitIsActivated;
2877     }
2878 
2879     function setExchangeEnabled(bool _exchangeEnabled)
2880         external
2881         optionalProxy_onlyOwner
2882     {
2883         exchangeEnabled = _exchangeEnabled;
2884     }
2885 
2886     function setGasLimitOracle(address _gasLimitOracle)
2887         external
2888         optionalProxy_onlyOwner
2889     {
2890         gasLimitOracle = _gasLimitOracle;
2891     }
2892 
2893     function setGasPriceLimit(uint _gasPriceLimit)
2894         external
2895     {
2896         require(msg.sender == gasLimitOracle, "Only gas limit oracle allowed");
2897         require(_gasPriceLimit > 0, "Needs to be greater than 0");
2898         gasPriceLimit = _gasPriceLimit;
2899     }
2900 
2901     /**
2902      * @notice Add an associated Synth contract to the Synthetix system
2903      * @dev Only the contract owner may call this.
2904      */
2905     function addSynth(Synth synth)
2906         external
2907         optionalProxy_onlyOwner
2908     {
2909         bytes32 currencyKey = synth.currencyKey();
2910 
2911         require(synths[currencyKey] == Synth(0), "Synth already exists");
2912         require(synthsByAddress[synth] == bytes32(0), "Synth address already exists");
2913 
2914         availableSynths.push(synth);
2915         synths[currencyKey] = synth;
2916         synthsByAddress[synth] = currencyKey;
2917     }
2918 
2919     /**
2920      * @notice Remove an associated Synth contract from the Synthetix system
2921      * @dev Only the contract owner may call this.
2922      */
2923     function removeSynth(bytes32 currencyKey)
2924         external
2925         optionalProxy_onlyOwner
2926     {
2927         require(synths[currencyKey] != address(0), "Synth does not exist");
2928         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2929         require(currencyKey != "XDR", "Cannot remove XDR synth");
2930         require(currencyKey != "sUSD", "Cannot remove sUSD synth");
2931 
2932         // Save the address we're removing for emitting the event at the end.
2933         address synthToRemove = synths[currencyKey];
2934 
2935         // Remove the synth from the availableSynths array.
2936         for (uint i = 0; i < availableSynths.length; i++) {
2937             if (availableSynths[i] == synthToRemove) {
2938                 delete availableSynths[i];
2939 
2940                 // Copy the last synth into the place of the one we just deleted
2941                 // If there's only one synth, this is synths[0] = synths[0].
2942                 // If we're deleting the last one, it's also a NOOP in the same way.
2943                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2944 
2945                 // Decrease the size of the array by one.
2946                 availableSynths.length--;
2947 
2948                 break;
2949             }
2950         }
2951 
2952         // And remove it from the synths mapping
2953         delete synthsByAddress[synths[currencyKey]];
2954         delete synths[currencyKey];
2955 
2956         // Note: No event here as Synthetix contract exceeds max contract size
2957         // with these events, and it's unlikely people will need to
2958         // track these events specifically.
2959     }
2960 
2961     // ========== VIEWS ==========
2962 
2963     /**
2964      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2965      * @param sourceCurrencyKey The currency the amount is specified in
2966      * @param sourceAmount The source amount, specified in UNIT base
2967      * @param destinationCurrencyKey The destination currency
2968      */
2969     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
2970         public
2971         view
2972         returns (uint)
2973     {
2974         return exchangeRates.effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
2975     }
2976 
2977     /**
2978      * @notice Total amount of synths issued by the system, priced in currencyKey
2979      * @param currencyKey The currency to value the synths in
2980      */
2981     function totalIssuedSynths(bytes32 currencyKey)
2982         public
2983         view
2984         returns (uint)
2985     {
2986         uint total = 0;
2987         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2988 
2989         (uint[] memory rates, bool anyRateStale) = exchangeRates.ratesAndStaleForCurrencies(availableCurrencyKeys());
2990         require(!anyRateStale, "Rates are stale");
2991 
2992         for (uint i = 0; i < availableSynths.length; i++) {
2993             // What's the total issued value of that synth in the destination currency?
2994             // Note: We're not using our effectiveValue function because we don't want to go get the
2995             //       rate for the destination currency and check if it's stale repeatedly on every
2996             //       iteration of the loop
2997             uint synthValue = availableSynths[i].totalSupply()
2998                 .multiplyDecimalRound(rates[i]);
2999             total = total.add(synthValue);
3000         }
3001 
3002         return total.divideDecimalRound(currencyRate);
3003     }
3004 
3005     /**
3006      * @notice Returns the currencyKeys of availableSynths for rate checking
3007      */
3008     function availableCurrencyKeys()
3009         public
3010         view
3011         returns (bytes32[])
3012     {
3013         bytes32[] memory currencyKeys = new bytes32[](availableSynths.length);
3014 
3015         for (uint i = 0; i < availableSynths.length; i++) {
3016             currencyKeys[i] = synthsByAddress[availableSynths[i]];
3017         }
3018 
3019         return currencyKeys;
3020     }
3021 
3022     /**
3023      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
3024      */
3025     function availableSynthCount()
3026         public
3027         view
3028         returns (uint)
3029     {
3030         return availableSynths.length;
3031     }
3032 
3033     /**
3034      * @notice Determine the effective fee rate for the exchange, taking into considering swing trading
3035      */
3036     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
3037         public
3038         view
3039         returns (uint)
3040     {
3041         // Get the base exchange fee rate
3042         uint exchangeFeeRate = feePool.exchangeFeeRate();
3043 
3044         uint multiplier = 1;
3045 
3046         // Is this a swing trade? I.e. long to short or vice versa, excluding when going into or out of sUSD.
3047         // Note: this assumes shorts begin with 'i' and longs with 's'.
3048         if (
3049             (sourceCurrencyKey[0] == 0x73 && sourceCurrencyKey != "sUSD" && destinationCurrencyKey[0] == 0x69) ||
3050             (sourceCurrencyKey[0] == 0x69 && destinationCurrencyKey != "sUSD" && destinationCurrencyKey[0] == 0x73)
3051         ) {
3052             // If so then double the exchange fee multipler
3053             multiplier = 2;
3054         }
3055 
3056         return exchangeFeeRate.mul(multiplier);
3057     }
3058     // ========== MUTATIVE FUNCTIONS ==========
3059 
3060     /**
3061      * @notice ERC20 transfer function.
3062      */
3063     function transfer(address to, uint value)
3064         public
3065         returns (bool)
3066     {
3067         bytes memory empty;
3068         return transfer(to, value, empty);
3069     }
3070 
3071     /**
3072      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
3073      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3074      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3075      *           tooling such as Etherscan.
3076      */
3077     function transfer(address to, uint value, bytes data)
3078         public
3079         optionalProxy
3080         returns (bool)
3081     {
3082         // Ensure they're not trying to exceed their locked amount
3083         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
3084 
3085         // Perform the transfer: if there is a problem an exception will be thrown in this call.
3086         _transfer_byProxy(messageSender, to, value, data);
3087 
3088         return true;
3089     }
3090 
3091     /**
3092      * @notice ERC20 transferFrom function.
3093      */
3094     function transferFrom(address from, address to, uint value)
3095         public
3096         returns (bool)
3097     {
3098         bytes memory empty;
3099         return transferFrom(from, to, value, empty);
3100     }
3101 
3102     /**
3103      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
3104      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3105      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3106      *           tooling such as Etherscan.
3107      */
3108     function transferFrom(address from, address to, uint value, bytes data)
3109         public
3110         optionalProxy
3111         returns (bool)
3112     {
3113         // Ensure they're not trying to exceed their locked amount
3114         require(value <= transferableSynthetix(from), "Insufficient balance");
3115 
3116         // Perform the transfer: if there is a problem,
3117         // an exception will be thrown in this call.
3118         _transferFrom_byProxy(messageSender, from, to, value, data);
3119 
3120         return true;
3121     }
3122 
3123     /**
3124      * @notice Function that allows you to exchange synths you hold in one flavour for another.
3125      * @param sourceCurrencyKey The source currency you wish to exchange from
3126      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3127      * @param destinationCurrencyKey The destination currency you wish to obtain.
3128      * @return Boolean that indicates whether the transfer succeeded or failed.
3129      */
3130     function exchange(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
3131         external
3132         optionalProxy
3133         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
3134         returns (bool)
3135     {
3136         require(sourceCurrencyKey != destinationCurrencyKey, "Must use different synths");
3137         require(sourceAmount > 0, "Zero amount");
3138 
3139         // verify gas price limit
3140         validateGasPrice(tx.gasprice);
3141 
3142         //  If the oracle has set protectionCircuit to true then burn the synths
3143         if (protectionCircuit) {
3144             synths[sourceCurrencyKey].burn(messageSender, sourceAmount);
3145             return true;
3146         } else {
3147             // Pass it along, defaulting to the sender as the recipient.
3148             return _internalExchange(
3149                 messageSender,
3150                 sourceCurrencyKey,
3151                 sourceAmount,
3152                 destinationCurrencyKey,
3153                 messageSender,
3154                 true // Charge fee on the exchange
3155             );
3156         }
3157     }
3158 
3159     /*
3160         @dev validate that the given gas price is less than or equal to the gas price limit
3161         @param _gasPrice tested gas price
3162     */
3163     function validateGasPrice(uint _givenGasPrice)
3164         public
3165         view
3166     {
3167         require(_givenGasPrice <= gasPriceLimit, "Gas price above limit");
3168     }
3169 
3170     /**
3171      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
3172      * @dev Only the synth contract can call this function
3173      * @param from The address to exchange / burn synth from
3174      * @param sourceCurrencyKey The source currency you wish to exchange from
3175      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3176      * @param destinationCurrencyKey The destination currency you wish to obtain.
3177      * @param destinationAddress Where the result should go.
3178      * @return Boolean that indicates whether the transfer succeeded or failed.
3179      */
3180     function synthInitiatedExchange(
3181         address from,
3182         bytes32 sourceCurrencyKey,
3183         uint sourceAmount,
3184         bytes32 destinationCurrencyKey,
3185         address destinationAddress
3186     )
3187         external
3188         optionalProxy
3189         returns (bool)
3190     {
3191         require(synthsByAddress[messageSender] != bytes32(0), "Only synth allowed");
3192         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3193         require(sourceAmount > 0, "Zero amount");
3194 
3195         // Pass it along
3196         return _internalExchange(
3197             from,
3198             sourceCurrencyKey,
3199             sourceAmount,
3200             destinationCurrencyKey,
3201             destinationAddress,
3202             false
3203         );
3204     }
3205 
3206     /**
3207      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3208      * @dev fee pool contract address is not allowed to call function
3209      * @param from The address to move synth from
3210      * @param sourceCurrencyKey source currency from.
3211      * @param sourceAmount The amount, specified in UNIT of source currency.
3212      * @param destinationCurrencyKey The destination currency to obtain.
3213      * @param destinationAddress Where the result should go.
3214      * @param chargeFee Boolean to charge a fee for exchange.
3215      * @return Boolean that indicates whether the transfer succeeded or failed.
3216      */
3217     function _internalExchange(
3218         address from,
3219         bytes32 sourceCurrencyKey,
3220         uint sourceAmount,
3221         bytes32 destinationCurrencyKey,
3222         address destinationAddress,
3223         bool chargeFee
3224     )
3225         internal
3226         notFeeAddress(from)
3227         returns (bool)
3228     {
3229         require(exchangeEnabled, "Exchanging is disabled");
3230 
3231         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3232         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3233 
3234         // Burn the source amount
3235         synths[sourceCurrencyKey].burn(from, sourceAmount);
3236 
3237         // How much should they get in the destination currency?
3238         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3239 
3240         // What's the fee on that currency that we should deduct?
3241         uint amountReceived = destinationAmount;
3242         uint fee = 0;
3243 
3244         if (chargeFee) {
3245             // Get the exchange fee rate
3246             uint exchangeFeeRate = feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
3247 
3248             amountReceived = destinationAmount.multiplyDecimal(SafeDecimalMath.unit().sub(exchangeFeeRate));
3249 
3250             fee = destinationAmount.sub(amountReceived);
3251         }
3252 
3253         // Issue their new synths
3254         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3255 
3256         // Remit the fee in XDRs
3257         if (fee > 0) {
3258             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3259             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3260             // Tell the fee pool about this.
3261             feePool.recordFeePaid(xdrFeeAmount);
3262         }
3263 
3264         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3265 
3266         // Call the ERC223 transfer callback if needed
3267         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
3268 
3269         //Let the DApps know there was a Synth exchange
3270         emitSynthExchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, amountReceived, destinationAddress);
3271 
3272         return true;
3273     }
3274 
3275     /**
3276      * @notice Function that registers new synth as they are issued. Calculate delta to append to synthetixState.
3277      * @dev Only internal calls from synthetix address.
3278      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3279      * @param amount The amount of synths to register with a base of UNIT
3280      */
3281     function _addToDebtRegister(bytes32 currencyKey, uint amount)
3282         internal
3283     {
3284         // What is the value of the requested debt in XDRs?
3285         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3286 
3287         // What is the value of all issued synths of the system (priced in XDRs)?
3288         uint totalDebtIssued = totalIssuedSynths("XDR");
3289 
3290         // What will the new total be including the new value?
3291         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3292 
3293         // What is their percentage (as a high precision int) of the total debt?
3294         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3295 
3296         // And what effect does this percentage change have on the global debt holding of other issuers?
3297         // The delta specifically needs to not take into account any existing debt as it's already
3298         // accounted for in the delta from when they issued previously.
3299         // The delta is a high precision integer.
3300         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3301 
3302         // How much existing debt do they have?
3303         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3304 
3305         // And what does their debt ownership look like including this previous stake?
3306         if (existingDebt > 0) {
3307             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3308         }
3309 
3310         // Are they a new issuer? If so, record them.
3311         if (existingDebt == 0) {
3312             synthetixState.incrementTotalIssuerCount();
3313         }
3314 
3315         // Save the debt entry parameters
3316         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3317 
3318         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3319         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3320         if (synthetixState.debtLedgerLength() > 0) {
3321             synthetixState.appendDebtLedgerValue(
3322                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3323             );
3324         } else {
3325             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3326         }
3327     }
3328 
3329     /**
3330      * @notice Issue synths against the sender's SNX.
3331      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3332      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3333      * @param amount The amount of synths you wish to issue with a base of UNIT
3334      */
3335     function issueSynths(bytes32 currencyKey, uint amount)
3336         public
3337         optionalProxy
3338         // No need to check if price is stale, as it is checked in issuableSynths.
3339     {
3340         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3341 
3342         // Keep track of the debt they're about to create
3343         _addToDebtRegister(currencyKey, amount);
3344 
3345         // Create their synths
3346         synths[currencyKey].issue(messageSender, amount);
3347 
3348         // Store their locked SNX amount to determine their fee % for the period
3349         _appendAccountIssuanceRecord();
3350     }
3351 
3352     /**
3353      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3354      * @dev Issuance is only allowed if the synthetix price isn't stale.
3355      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3356      */
3357     function issueMaxSynths(bytes32 currencyKey)
3358         external
3359         optionalProxy
3360     {
3361         // Figure out the maximum we can issue in that currency
3362         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3363 
3364         // Keep track of the debt they're about to create
3365         _addToDebtRegister(currencyKey, maxIssuable);
3366 
3367         // Create their synths
3368         synths[currencyKey].issue(messageSender, maxIssuable);
3369 
3370         // Store their locked SNX amount to determine their fee % for the period
3371         _appendAccountIssuanceRecord();
3372     }
3373 
3374     /**
3375      * @notice Burn synths to clear issued synths/free SNX.
3376      * @param currencyKey The currency you're specifying to burn
3377      * @param amount The amount (in UNIT base) you wish to burn
3378      * @dev The amount to burn is debased to XDR's
3379      */
3380     function burnSynths(bytes32 currencyKey, uint amount)
3381         external
3382         optionalProxy
3383         // No need to check for stale rates as effectiveValue checks rates
3384     {
3385         // How much debt do they have?
3386         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3387         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3388         
3389         uint debtInCurrencyKey = debtBalanceOf(messageSender, currencyKey);
3390 
3391         require(existingDebt > 0, "No debt to forgive");
3392 
3393         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3394         // clear their debt and leave them be.
3395         uint amountToRemove = existingDebt < debtToRemove ? existingDebt : debtToRemove;
3396 
3397         // Remove their debt from the ledger
3398         _removeFromDebtRegister(amountToRemove, existingDebt);
3399 
3400         uint amountToBurn = debtInCurrencyKey < amount ? debtInCurrencyKey : amount;
3401 
3402         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3403         synths[currencyKey].burn(messageSender, amountToBurn);
3404 
3405         // Store their debtRatio against a feeperiod to determine their fee/rewards % for the period
3406         _appendAccountIssuanceRecord();
3407     }
3408 
3409     /**
3410      * @notice Store in the FeePool the users current debt value in the system in XDRs.
3411      * @dev debtBalanceOf(messageSender, "XDR") to be used with totalIssuedSynths("XDR") to get
3412      *  users % of the system within a feePeriod.
3413      */
3414     function _appendAccountIssuanceRecord()
3415         internal
3416     {
3417         uint initialDebtOwnership;
3418         uint debtEntryIndex;
3419         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(messageSender);
3420 
3421         feePool.appendAccountIssuanceRecord(
3422             messageSender,
3423             initialDebtOwnership,
3424             debtEntryIndex
3425         );
3426     }
3427 
3428     /**
3429      * @notice Remove a debt position from the register
3430      * @param amount The amount (in UNIT base) being presented in XDRs
3431      * @param existingDebt The existing debt (in UNIT base) of address presented in XDRs
3432      */
3433     function _removeFromDebtRegister(uint amount, uint existingDebt)
3434         internal
3435     {
3436         uint debtToRemove = amount;
3437 
3438         // What is the value of all issued synths of the system (priced in XDRs)?
3439         uint totalDebtIssued = totalIssuedSynths("XDR");
3440 
3441         // What will the new total after taking out the withdrawn amount
3442         uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3443 
3444         uint delta = 0;
3445 
3446         // What will the debt delta be if there is any debt left?
3447         // Set delta to 0 if no more debt left in system after user
3448         if (newTotalDebtIssued > 0) {
3449 
3450             // What is the percentage of the withdrawn debt (as a high precision int) of the total debt after?
3451             uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(newTotalDebtIssued);
3452 
3453             // And what effect does this percentage change have on the global debt holding of other issuers?
3454             // The delta specifically needs to not take into account any existing debt as it's already
3455             // accounted for in the delta from when they issued previously.
3456             delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3457         }
3458 
3459         // Are they exiting the system, or are they just decreasing their debt position?
3460         if (debtToRemove == existingDebt) {
3461             synthetixState.setCurrentIssuanceData(messageSender, 0);
3462             synthetixState.decrementTotalIssuerCount();
3463         } else {
3464             // What percentage of the debt will they be left with?
3465             uint newDebt = existingDebt.sub(debtToRemove);
3466             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3467 
3468             // Store the debt percentage and debt ledger as high precision integers
3469             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3470         }
3471 
3472         // Update our cumulative ledger. This is also a high precision integer.
3473         synthetixState.appendDebtLedgerValue(
3474             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3475         );
3476     }
3477 
3478     // ========== Issuance/Burning ==========
3479 
3480     /**
3481      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3482      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3483      */
3484     function maxIssuableSynths(address issuer, bytes32 currencyKey)
3485         public
3486         view
3487         // We don't need to check stale rates here as effectiveValue will do it for us.
3488         returns (uint)
3489     {
3490         // What is the value of their SNX balance in the destination currency?
3491         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3492 
3493         // They're allowed to issue up to issuanceRatio of that value
3494         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3495     }
3496 
3497     /**
3498      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3499      * as the value of the underlying Synthetix asset changes,
3500      * e.g. based on an issuance ratio of 20%. if a user issues their maximum available
3501      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3502      * of Synthetix changes, the ratio returned by this function will adjust accordingly. Users are
3503      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3504      * altering the amount of fees they're able to claim from the system.
3505      */
3506     function collateralisationRatio(address issuer)
3507         public
3508         view
3509         returns (uint)
3510     {
3511         uint totalOwnedSynthetix = collateral(issuer);
3512         if (totalOwnedSynthetix == 0) return 0;
3513 
3514         uint debtBalance = debtBalanceOf(issuer, "SNX");
3515         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3516     }
3517 
3518     /**
3519      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3520      * will tell you how many synths a user has to give back to the system in order to unlock their original
3521      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3522      * the debt in sUSD, XDR, or any other synth you wish.
3523      */
3524     function debtBalanceOf(address issuer, bytes32 currencyKey)
3525         public
3526         view
3527         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3528         returns (uint)
3529     {
3530         // What was their initial debt ownership?
3531         uint initialDebtOwnership;
3532         uint debtEntryIndex;
3533         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3534 
3535         // If it's zero, they haven't issued, and they have no debt.
3536         if (initialDebtOwnership == 0) return 0;
3537 
3538         // Figure out the global debt percentage delta from when they entered the system.
3539         // This is a high precision integer.
3540         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3541             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3542             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3543 
3544         // What's the total value of the system in their requested currency?
3545         uint totalSystemValue = totalIssuedSynths(currencyKey);
3546 
3547         // Their debt balance is their portion of the total system value.
3548         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3549             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3550 
3551         return highPrecisionBalance.preciseDecimalToDecimal();
3552     }
3553 
3554     /**
3555      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3556      * @param issuer The account that intends to issue
3557      * @param currencyKey The currency to price issuable value in
3558      */
3559     function remainingIssuableSynths(address issuer, bytes32 currencyKey)
3560         public
3561         view
3562         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3563         returns (uint)
3564     {
3565         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3566         uint max = maxIssuableSynths(issuer, currencyKey);
3567 
3568         if (alreadyIssued >= max) {
3569             return 0;
3570         } else {
3571             return max.sub(alreadyIssued);
3572         }
3573     }
3574 
3575     /**
3576      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3577      * against which synths can be issued.
3578      * This includes those already being used as collateral (locked), and those
3579      * available for further issuance (unlocked).
3580      */
3581     function collateral(address account)
3582         public
3583         view
3584         returns (uint)
3585     {
3586         uint balance = tokenState.balanceOf(account);
3587 
3588         if (escrow != address(0)) {
3589             balance = balance.add(escrow.balanceOf(account));
3590         }
3591 
3592         if (rewardEscrow != address(0)) {
3593             balance = balance.add(rewardEscrow.balanceOf(account));
3594         }
3595 
3596         return balance;
3597     }
3598 
3599     /**
3600      * @notice The number of SNX that are free to be transferred for an account.
3601      * @dev Escrowed SNX are not transferable, so they are not included
3602      * in this calculation.
3603      * @notice SNX rate not stale is checked within debtBalanceOf
3604      */
3605     function transferableSynthetix(address account)
3606         public
3607         view
3608         rateNotStale("SNX") // SNX is not a synth so is not checked in totalIssuedSynths
3609         returns (uint)
3610     {
3611         // How many SNX do they have, excluding escrow?
3612         // Note: We're excluding escrow here because we're interested in their transferable amount
3613         // and escrowed SNX are not transferable.
3614         uint balance = tokenState.balanceOf(account);
3615 
3616         // How many of those will be locked by the amount they've issued?
3617         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3618         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3619         // The locked synthetix value can exceed their balance.
3620         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3621 
3622         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3623         if (lockedSynthetixValue >= balance) {
3624             return 0;
3625         } else {
3626             return balance.sub(lockedSynthetixValue);
3627         }
3628     }
3629 
3630     /**
3631      * @notice Mints the inflationary SNX supply. The inflation shedule is
3632      * defined in the SupplySchedule contract.
3633      * The mint() function is publicly callable by anyone. The caller will
3634      receive a minter reward as specified in supplySchedule.minterReward().
3635      */
3636     function mint()
3637         external
3638         returns (bool)
3639     {
3640         require(rewardsDistribution != address(0), "RewardsDistribution not set");
3641 
3642         uint supplyToMint = supplySchedule.mintableSupply();
3643         require(supplyToMint > 0, "No supply is mintable");
3644 
3645         supplySchedule.updateMintValues();
3646 
3647         // Set minted SNX balance to RewardEscrow's balance
3648         // Minus the minterReward and set balance of minter to add reward
3649         uint minterReward = supplySchedule.minterReward();
3650         // Get the remainder
3651         uint amountToDistribute = supplyToMint.sub(minterReward);
3652 
3653         // Set the token balance to the RewardsDistribution contract
3654         tokenState.setBalanceOf(rewardsDistribution, tokenState.balanceOf(rewardsDistribution).add(amountToDistribute));
3655         emitTransfer(this, rewardsDistribution, amountToDistribute);
3656 
3657         // Kick off the distribution of rewards
3658         rewardsDistribution.distributeRewards(amountToDistribute);
3659 
3660         // Assign the minters reward.
3661         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
3662         emitTransfer(this, msg.sender, minterReward);
3663 
3664         totalSupply = totalSupply.add(supplyToMint);
3665 
3666         return true;
3667     }
3668 
3669     // ========== MODIFIERS ==========
3670 
3671     modifier rateNotStale(bytes32 currencyKey) {
3672         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or not a synth");
3673         _;
3674     }
3675 
3676     modifier notFeeAddress(address account) {
3677         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3678         _;
3679     }
3680 
3681     modifier onlyOracle
3682     {
3683         require(msg.sender == exchangeRates.oracle(), "Only oracle allowed");
3684         _;
3685     }
3686 
3687     // ========== EVENTS ==========
3688     /* solium-disable */
3689     event SynthExchange(address indexed account, bytes32 fromCurrencyKey, uint256 fromAmount, bytes32 toCurrencyKey,  uint256 toAmount, address toAddress);
3690     bytes32 constant SYNTHEXCHANGE_SIG = keccak256("SynthExchange(address,bytes32,uint256,bytes32,uint256,address)");
3691     function emitSynthExchange(address account, bytes32 fromCurrencyKey, uint256 fromAmount, bytes32 toCurrencyKey, uint256 toAmount, address toAddress) internal {
3692         proxy._emit(abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress), 2, SYNTHEXCHANGE_SIG, bytes32(account), 0, 0);
3693     }
3694     /* solium-enable */
3695 }
3696 
