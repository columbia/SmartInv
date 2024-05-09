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
1204 library Math {
1205 
1206     using SafeMath for uint;
1207     using SafeDecimalMath for uint;
1208 
1209     /**
1210     * @dev Uses "exponentiation by squaring" algorithm where cost is 0(logN)
1211     * vs 0(N) for naive repeated multiplication. 
1212     * Calculates x^n with x as fixed-point and n as regular unsigned int.
1213     * Calculates to 18 digits of precision with SafeDecimalMath.unit()
1214     */
1215     function powDecimal(uint x, uint n)
1216         internal
1217         pure
1218         returns (uint)
1219     {
1220         // https://mpark.github.io/programming/2014/08/18/exponentiation-by-squaring/
1221 
1222         uint result = SafeDecimalMath.unit();
1223         while (n > 0) {
1224             if (n % 2 != 0) {
1225                 result = result.multiplyDecimal(x);
1226             }
1227             x = x.multiplyDecimal(x);
1228             n /= 2;
1229         }
1230         return result;
1231     }
1232 }
1233     
1234 
1235 /**
1236  * @title SynthetixState interface contract
1237  * @notice Abstract contract to hold public getters
1238  */
1239 contract ISynthetixState {
1240     // A struct for handing values associated with an individual user's debt position
1241     struct IssuanceData {
1242         // Percentage of the total debt owned at the time
1243         // of issuance. This number is modified by the global debt
1244         // delta array. You can figure out a user's exit price and
1245         // collateralisation ratio using a combination of their initial
1246         // debt and the slice of global debt delta which applies to them.
1247         uint initialDebtOwnership;
1248         // This lets us know when (in relative terms) the user entered
1249         // the debt pool so we can calculate their exit price and
1250         // collateralistion ratio
1251         uint debtEntryIndex;
1252     }
1253 
1254     uint[] public debtLedger;
1255     uint public issuanceRatio;
1256     mapping(address => IssuanceData) public issuanceData;
1257 
1258     function debtLedgerLength() external view returns (uint);
1259     function hasIssued(address account) external view returns (bool);
1260     function incrementTotalIssuerCount() external;
1261     function decrementTotalIssuerCount() external;
1262     function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
1263     function lastDebtLedgerEntry() external view returns (uint);
1264     function appendDebtLedgerValue(uint value) external;
1265     function clearIssuanceData(address account) external;
1266 }
1267 
1268 
1269 interface ISynth {
1270     function burn(address account, uint amount) external;
1271     function issue(address account, uint amount) external;
1272     function transfer(address to, uint value) public returns (bool);
1273     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount) external;
1274     function transferFrom(address from, address to, uint value) public returns (bool);
1275 }
1276 
1277 
1278 /**
1279  * @title SynthetixEscrow interface
1280  */
1281 interface ISynthetixEscrow {
1282     function balanceOf(address account) public view returns (uint);
1283     function appendVestingEntry(address account, uint quantity) public;
1284 }
1285 
1286 
1287 /**
1288  * @title FeePool Interface
1289  * @notice Abstract contract to hold public getters
1290  */
1291 contract IFeePool {
1292     address public FEE_ADDRESS;
1293     uint public exchangeFeeRate;
1294     function amountReceivedFromExchange(uint value) external view returns (uint);
1295     function amountReceivedFromTransfer(uint value) external view returns (uint);
1296     function recordFeePaid(uint xdrAmount) external;
1297     function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
1298     function setRewardsToDistribute(uint amount) external;
1299 }
1300 
1301 
1302 /**
1303  * @title ExchangeRates interface
1304  */
1305 interface IExchangeRates {
1306     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey) external view returns (uint);
1307 
1308     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
1309     function ratesForCurrencies(bytes32[] currencyKeys) external view returns (uint[] memory);
1310 
1311     function rateIsStale(bytes32 currencyKey) external view returns (bool);
1312     function anyRateIsStale(bytes32[] currencyKeys) external view returns (bool);
1313 }
1314 
1315 
1316 /*
1317 -----------------------------------------------------------------
1318 FILE INFORMATION
1319 -----------------------------------------------------------------
1320 
1321 file:       Synth.sol
1322 version:    2.0
1323 author:     Kevin Brown
1324 date:       2018-09-13
1325 
1326 -----------------------------------------------------------------
1327 MODULE DESCRIPTION
1328 -----------------------------------------------------------------
1329 
1330 Synthetix-backed stablecoin contract.
1331 
1332 This contract issues synths, which are tokens that mirror various
1333 flavours of fiat currency.
1334 
1335 Synths are issuable by Synthetix Network Token (SNX) holders who
1336 have to lock up some value of their SNX to issue S * Cmax synths.
1337 Where Cmax issome value less than 1.
1338 
1339 A configurable fee is charged on synth transfers and deposited
1340 into a common pot, which Synthetix holders may withdraw from once
1341 per fee period.
1342 
1343 -----------------------------------------------------------------
1344 */
1345 
1346 
1347 contract Synth is ExternStateToken {
1348 
1349     /* ========== STATE VARIABLES ========== */
1350 
1351     // Address of the FeePoolProxy
1352     address public feePoolProxy;
1353     // Address of the SynthetixProxy
1354     address public synthetixProxy;
1355 
1356     // Currency key which identifies this Synth to the Synthetix system
1357     bytes32 public currencyKey;
1358 
1359     uint8 constant DECIMALS = 18;
1360 
1361     /* ========== CONSTRUCTOR ========== */
1362 
1363     constructor(address _proxy, TokenState _tokenState, address _synthetixProxy, address _feePoolProxy,
1364         string _tokenName, string _tokenSymbol, address _owner, bytes32 _currencyKey, uint _totalSupply
1365     )
1366         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, _totalSupply, DECIMALS, _owner)
1367         public
1368     {
1369         require(_proxy != address(0), "_proxy cannot be 0");
1370         require(_synthetixProxy != address(0), "_synthetixProxy cannot be 0");
1371         require(_feePoolProxy != address(0), "_feePoolProxy cannot be 0");
1372         require(_owner != 0, "_owner cannot be 0");
1373         require(ISynthetix(_synthetixProxy).synths(_currencyKey) == Synth(0), "Currency key is already in use");
1374 
1375         feePoolProxy = _feePoolProxy;
1376         synthetixProxy = _synthetixProxy;
1377         currencyKey = _currencyKey;
1378     }
1379 
1380     /* ========== SETTERS ========== */
1381 
1382     /**
1383      * @notice Set the SynthetixProxy should it ever change.
1384      * The Synth requires Synthetix address as it has the authority
1385      * to mint and burn synths
1386      * */
1387     function setSynthetixProxy(ISynthetix _synthetixProxy)
1388         external
1389         optionalProxy_onlyOwner
1390     {
1391         synthetixProxy = _synthetixProxy;
1392         emitSynthetixUpdated(_synthetixProxy);
1393     }
1394 
1395     /**
1396      * @notice Set the FeePoolProxy should it ever change.
1397      * The Synth requires FeePool address as it has the authority
1398      * to mint and burn for FeePool.claimFees()
1399      * */
1400     function setFeePoolProxy(address _feePoolProxy)
1401         external
1402         optionalProxy_onlyOwner
1403     {
1404         feePoolProxy = _feePoolProxy;
1405         emitFeePoolUpdated(_feePoolProxy);
1406     }
1407 
1408     /* ========== MUTATIVE FUNCTIONS ========== */
1409 
1410     /**
1411      * @notice ERC20 transfer function
1412      * forward call on to _internalTransfer */
1413     function transfer(address to, uint value)
1414         public
1415         optionalProxy
1416         returns (bool)
1417     {
1418         bytes memory empty;
1419         return super._internalTransfer(messageSender, to, value, empty);
1420     }
1421 
1422     /**
1423      * @notice ERC223 transfer function
1424      */
1425     function transfer(address to, uint value, bytes data)
1426         public
1427         optionalProxy
1428         returns (bool)
1429     {
1430         // And send their result off to the destination address
1431         return super._internalTransfer(messageSender, to, value, data);
1432     }
1433 
1434     /**
1435      * @notice ERC20 transferFrom function
1436      */
1437     function transferFrom(address from, address to, uint value)
1438         public
1439         optionalProxy
1440         returns (bool)
1441     {
1442         require(from != 0xfeefeefeefeefeefeefeefeefeefeefeefeefeef, "The fee address is not allowed");
1443         // Skip allowance update in case of infinite allowance
1444         if (tokenState.allowance(from, messageSender) != uint(-1)) {
1445             // Reduce the allowance by the amount we're transferring.
1446             // The safeSub call will handle an insufficient allowance.
1447             tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1448         }
1449 
1450         bytes memory empty;
1451         return super._internalTransfer(from, to, value, empty);
1452     }
1453 
1454     /**
1455      * @notice ERC223 transferFrom function
1456      */
1457     function transferFrom(address from, address to, uint value, bytes data)
1458         public
1459         optionalProxy
1460         returns (bool)
1461     {
1462         require(from != 0xfeefeefeefeefeefeefeefeefeefeefeefeefeef, "The fee address is not allowed");
1463 
1464         // Skip allowance update in case of infinite allowance
1465         if (tokenState.allowance(from, messageSender) != uint(-1)) {
1466             // Reduce the allowance by the amount we're transferring.
1467             // The safeSub call will handle an insufficient allowance.
1468             tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1469         }
1470 
1471         return super._internalTransfer(from, to, value, data);
1472     }
1473 
1474     // Allow synthetix to issue a certain number of synths from an account.
1475     function issue(address account, uint amount)
1476         external
1477         onlySynthetixOrFeePool
1478     {
1479         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
1480         totalSupply = totalSupply.add(amount);
1481         emitTransfer(address(0), account, amount);
1482         emitIssued(account, amount);
1483     }
1484 
1485     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
1486     function burn(address account, uint amount)
1487         external
1488         onlySynthetixOrFeePool
1489     {
1490         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
1491         totalSupply = totalSupply.sub(amount);
1492         emitTransfer(account, address(0), amount);
1493         emitBurned(account, amount);
1494     }
1495 
1496     // Allow owner to set the total supply on import.
1497     function setTotalSupply(uint amount)
1498         external
1499         optionalProxy_onlyOwner
1500     {
1501         totalSupply = amount;
1502     }
1503 
1504     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
1505     // exchange as well as transfer
1506     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
1507         external
1508         onlySynthetixOrFeePool
1509     {
1510         bytes memory empty;
1511         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
1512     }
1513 
1514     /* ========== MODIFIERS ========== */
1515 
1516     modifier onlySynthetixOrFeePool() {
1517         bool isSynthetix = msg.sender == address(Proxy(synthetixProxy).target());
1518         bool isFeePool = msg.sender == address(Proxy(feePoolProxy).target());
1519 
1520         require(isSynthetix || isFeePool, "Only Synthetix, FeePool allowed");
1521         _;
1522     }
1523 
1524     /* ========== EVENTS ========== */
1525 
1526     event SynthetixUpdated(address newSynthetix);
1527     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
1528     function emitSynthetixUpdated(address newSynthetix) internal {
1529         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
1530     }
1531 
1532     event FeePoolUpdated(address newFeePool);
1533     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
1534     function emitFeePoolUpdated(address newFeePool) internal {
1535         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
1536     }
1537 
1538     event Issued(address indexed account, uint value);
1539     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
1540     function emitIssued(address account, uint value) internal {
1541         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
1542     }
1543 
1544     event Burned(address indexed account, uint value);
1545     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
1546     function emitBurned(address account, uint value) internal {
1547         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
1548     }
1549 }
1550 
1551 
1552 /**
1553  * @title Synthetix interface contract
1554  * @notice Abstract contract to hold public getters
1555  * @dev pseudo interface, actually declared as contract to hold the public getters 
1556  */
1557 
1558 
1559 contract ISynthetix {
1560 
1561     // ========== PUBLIC STATE VARIABLES ==========
1562 
1563     IFeePool public feePool;
1564     ISynthetixEscrow public escrow;
1565     ISynthetixEscrow public rewardEscrow;
1566     ISynthetixState public synthetixState;
1567     IExchangeRates public exchangeRates;
1568 
1569     uint public totalSupply;
1570         
1571     mapping(bytes32 => Synth) public synths;
1572 
1573     // ========== PUBLIC FUNCTIONS ==========
1574 
1575     function balanceOf(address account) public view returns (uint);
1576     function transfer(address to, uint value) public returns (bool);
1577     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey) public view returns (uint);
1578 
1579     function synthInitiatedExchange(
1580         address from,
1581         bytes32 sourceCurrencyKey,
1582         uint sourceAmount,
1583         bytes32 destinationCurrencyKey,
1584         address destinationAddress) external returns (bool);
1585     function exchange(
1586         bytes32 sourceCurrencyKey,
1587         uint sourceAmount,
1588         bytes32 destinationCurrencyKey) external returns (bool);
1589     function collateralisationRatio(address issuer) public view returns (uint);
1590     function totalIssuedSynths(bytes32 currencyKey)
1591         public
1592         view
1593         returns (uint);
1594     function getSynth(bytes32 currencyKey) public view returns (ISynth);
1595     function debtBalanceOf(address issuer, bytes32 currencyKey) public view returns (uint);
1596 }
1597 
1598 
1599 /*
1600 -----------------------------------------------------------------
1601 MODULE DESCRIPTION
1602 -----------------------------------------------------------------
1603 
1604 The SNX supply schedule contract determines the amount of SNX tokens
1605 mintable over the course of 195 weeks.
1606 
1607 Exponential Decay Inflation Schedule
1608 
1609 Synthetix.mint() function is used to mint the inflationary supply.
1610 
1611 The mechanics for Inflation Smoothing and Terminal Inflation 
1612 have been defined in these sips
1613 https://sips.synthetix.io/sips/sip-23
1614 https://sips.synthetix.io/sips/sip-24
1615 
1616 The previous SNX Inflation Supply Schedule is at 
1617 https://etherscan.io/address/0xA3de830b5208851539De8e4FF158D635E8f36FCb#code
1618 
1619 -----------------------------------------------------------------
1620 */
1621 
1622 
1623 /**
1624  * @title SupplySchedule contract
1625  */
1626 contract SupplySchedule is Owned {
1627     using SafeMath for uint;
1628     using SafeDecimalMath for uint;
1629     using Math for uint;
1630 
1631     // Time of the last inflation supply mint event
1632     uint public lastMintEvent;
1633 
1634     // Counter for number of weeks since the start of supply inflation
1635     uint public weekCounter;
1636 
1637     // The number of SNX rewarded to the caller of Synthetix.mint()
1638     uint public minterReward = 200 * SafeDecimalMath.unit();
1639 
1640     // The initial weekly inflationary supply is 75m / 52 until the start of the decay rate. 
1641     // 75e6 * SafeDecimalMath.unit() / 52
1642     uint public constant INITIAL_WEEKLY_SUPPLY = 1442307692307692307692307;    
1643 
1644     // Address of the SynthetixProxy for the onlySynthetix modifier
1645     address public synthetixProxy;
1646 
1647     // Max SNX rewards for minter
1648     uint public constant MAX_MINTER_REWARD = 200 * SafeDecimalMath.unit();
1649 
1650     // How long each inflation period is before mint can be called
1651     uint public constant MINT_PERIOD_DURATION = 1 weeks;
1652 
1653     uint public constant INFLATION_START_DATE = 1551830400; // 2019-03-06T00:00:00+00:00
1654     uint public constant MINT_BUFFER = 1 days;
1655     uint8 public constant SUPPLY_DECAY_START = 40; // Week 40
1656     uint8 public constant SUPPLY_DECAY_END = 234; //  Supply Decay ends on Week 234 (inclusive of Week 234 for a total of 195 weeks of inflation decay)
1657     
1658     // Weekly percentage decay of inflationary supply from the first 40 weeks of the 75% inflation rate
1659     uint public constant DECAY_RATE = 12500000000000000; // 1.25% weekly
1660 
1661     // Percentage growth of terminal supply per annum
1662     uint public constant TERMINAL_SUPPLY_RATE_ANNUAL = 25000000000000000; // 2.5% pa
1663     
1664     constructor(
1665         address _owner,
1666         uint _lastMintEvent,
1667         uint _currentWeek)
1668         Owned(_owner)
1669         public
1670     {
1671         lastMintEvent = _lastMintEvent;
1672         weekCounter = _currentWeek;
1673     }
1674 
1675     // ========== VIEWS ==========     
1676     
1677     /**    
1678     * @return The amount of SNX mintable for the inflationary supply
1679     */
1680     function mintableSupply()
1681         external
1682         view
1683         returns (uint)
1684     {
1685         uint totalAmount;
1686 
1687         if (!isMintable()) {
1688             return totalAmount;
1689         }
1690         
1691         uint remainingWeeksToMint = weeksSinceLastIssuance();
1692           
1693         uint currentWeek = weekCounter;
1694         
1695         // Calculate total mintable supply from exponential decay function
1696         // The decay function stops after week 234
1697         while (remainingWeeksToMint > 0) {
1698             currentWeek++;            
1699             
1700             // If current week is before supply decay we add initial supply to mintableSupply
1701             if (currentWeek < SUPPLY_DECAY_START) {
1702                 totalAmount = totalAmount.add(INITIAL_WEEKLY_SUPPLY);
1703                 remainingWeeksToMint--;
1704             }
1705             // if current week before supply decay ends we add the new supply for the week 
1706             else if (currentWeek <= SUPPLY_DECAY_END) {
1707                 
1708                 // diff between current week and (supply decay start week - 1)  
1709                 uint decayCount = currentWeek.sub(SUPPLY_DECAY_START -1);
1710                 
1711                 totalAmount = totalAmount.add(tokenDecaySupplyForWeek(decayCount));
1712                 remainingWeeksToMint--;
1713             } 
1714             // Terminal supply is calculated on the total supply of Synthetix including any new supply
1715             // We can compound the remaining week's supply at the fixed terminal rate  
1716             else {
1717                 uint totalSupply = ISynthetix(synthetixProxy).totalSupply();
1718                 uint currentTotalSupply = totalSupply.add(totalAmount);
1719 
1720                 totalAmount = totalAmount.add(terminalInflationSupply(currentTotalSupply, remainingWeeksToMint));
1721                 remainingWeeksToMint = 0;
1722             }
1723         }
1724         
1725         return totalAmount;
1726     }
1727 
1728     /**
1729     * @return A unit amount of decaying inflationary supply from the INITIAL_WEEKLY_SUPPLY
1730     * @dev New token supply reduces by the decay rate each week calculated as supply = INITIAL_WEEKLY_SUPPLY * () 
1731     */
1732     function tokenDecaySupplyForWeek(uint counter)
1733         public 
1734         pure
1735         returns (uint)
1736     {   
1737         // Apply exponential decay function to number of weeks since
1738         // start of inflation smoothing to calculate diminishing supply for the week.
1739         uint effectiveDecay = (SafeDecimalMath.unit().sub(DECAY_RATE)).powDecimal(counter);
1740         uint supplyForWeek = INITIAL_WEEKLY_SUPPLY.multiplyDecimal(effectiveDecay);
1741 
1742         return supplyForWeek;
1743     }    
1744     
1745     /**
1746     * @return A unit amount of terminal inflation supply
1747     * @dev Weekly compound rate based on number of weeks     
1748     */
1749     function terminalInflationSupply(uint totalSupply, uint numOfWeeks)
1750         public
1751         pure
1752         returns (uint)
1753     {   
1754         // rate = (1 + weekly rate) ^ num of weeks
1755         uint effectiveCompoundRate = SafeDecimalMath.unit().add(TERMINAL_SUPPLY_RATE_ANNUAL.div(52)).powDecimal(numOfWeeks);
1756 
1757         // return Supply * (effectiveRate - 1) for extra supply to issue based on number of weeks
1758         return totalSupply.multiplyDecimal(effectiveCompoundRate.sub(SafeDecimalMath.unit()));
1759     }
1760 
1761     /**    
1762     * @dev Take timeDiff in seconds (Dividend) and MINT_PERIOD_DURATION as (Divisor)
1763     * @return Calculate the numberOfWeeks since last mint rounded down to 1 week
1764     */
1765     function weeksSinceLastIssuance()
1766         public
1767         view
1768         returns (uint)
1769     {
1770         // Get weeks since lastMintEvent
1771         // If lastMintEvent not set or 0, then start from inflation start date.
1772         uint timeDiff = lastMintEvent > 0 ? now.sub(lastMintEvent) : now.sub(INFLATION_START_DATE);
1773         return timeDiff.div(MINT_PERIOD_DURATION);
1774     }
1775 
1776     /**
1777      * @return boolean whether the MINT_PERIOD_DURATION (7 days)
1778      * has passed since the lastMintEvent.
1779      * */
1780     function isMintable()
1781         public
1782         view
1783         returns (bool)
1784     {
1785         if (now - lastMintEvent > MINT_PERIOD_DURATION)
1786         {
1787             return true;
1788         }
1789         return false;
1790     }
1791 
1792     // ========== MUTATIVE FUNCTIONS ==========
1793 
1794     /**
1795      * @notice Record the mint event from Synthetix by incrementing the inflation 
1796      * week counter for the number of weeks minted (probabaly always 1)
1797      * and store the time of the event.
1798      * @param supplyMinted the amount of SNX the total supply was inflated by.
1799      * */
1800     function recordMintEvent(uint supplyMinted)
1801         external
1802         onlySynthetix
1803         returns (bool)
1804     {
1805         uint numberOfWeeksIssued = weeksSinceLastIssuance();
1806 
1807         // add number of weeks minted to weekCounter
1808         weekCounter = weekCounter.add(numberOfWeeksIssued);
1809 
1810         // Update mint event to latest week issued (start date + number of weeks issued * seconds in week)
1811         // 1 day time buffer is added so inflation is minted after feePeriod closes 
1812         lastMintEvent = INFLATION_START_DATE.add(weekCounter.mul(MINT_PERIOD_DURATION)).add(MINT_BUFFER);
1813 
1814         emit SupplyMinted(supplyMinted, numberOfWeeksIssued, lastMintEvent, now);
1815         return true;
1816     }
1817 
1818     /**
1819      * @notice Sets the reward amount of SNX for the caller of the public 
1820      * function Synthetix.mint(). 
1821      * This incentivises anyone to mint the inflationary supply and the mintr 
1822      * Reward will be deducted from the inflationary supply and sent to the caller.
1823      * @param amount the amount of SNX to reward the minter.
1824      * */
1825     function setMinterReward(uint amount)
1826         external
1827         onlyOwner
1828     {
1829         require(amount <= MAX_MINTER_REWARD, "Reward cannot exceed max minter reward");
1830         minterReward = amount;
1831         emit MinterRewardUpdated(minterReward);
1832     }
1833 
1834     // ========== SETTERS ========== */
1835 
1836     /**
1837      * @notice Set the SynthetixProxy should it ever change.
1838      * SupplySchedule requires Synthetix address as it has the authority
1839      * to record mint event.
1840      * */
1841     function setSynthetixProxy(ISynthetix _synthetixProxy)
1842         external
1843         onlyOwner
1844     {
1845         require(_synthetixProxy != address(0), "Address cannot be 0");
1846         synthetixProxy = _synthetixProxy;
1847         emit SynthetixProxyUpdated(synthetixProxy);
1848     }
1849 
1850     // ========== MODIFIERS ==========
1851 
1852     /**
1853      * @notice Only the Synthetix contract is authorised to call this function
1854      * */
1855     modifier onlySynthetix() {
1856         require(msg.sender == address(Proxy(synthetixProxy).target()), "Only the synthetix contract can perform this action");
1857         _;
1858     }
1859 
1860     /* ========== EVENTS ========== */
1861     /**
1862      * @notice Emitted when the inflationary supply is minted
1863      * */
1864     event SupplyMinted(uint supplyMinted, uint numberOfWeeksIssued, uint lastMintEvent, uint timestamp);
1865 
1866     /**
1867      * @notice Emitted when the SNX minter reward amount is updated
1868      * */
1869     event MinterRewardUpdated(uint newRewardAmount);
1870 
1871     /**
1872      * @notice Emitted when setSynthetixProxy is called changing the Synthetix Proxy address
1873      * */
1874     event SynthetixProxyUpdated(address newAddress);
1875 }
1876 
1877 
1878 interface AggregatorInterface {
1879   function latestAnswer() external view returns (int256);
1880   function latestTimestamp() external view returns (uint256);
1881   function latestRound() external view returns (uint256);
1882   function getAnswer(uint256 roundId) external view returns (int256);
1883   function getTimestamp(uint256 roundId) external view returns (uint256);
1884 
1885   event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
1886   event NewRound(uint256 indexed roundId, address indexed startedBy);
1887 }
1888 
1889 
1890 // AggregatorInterface from Chainlink represents a decentralized pricing network for a single currency keys
1891 
1892 
1893 /**
1894  * @title The repository for exchange rates
1895  */
1896 
1897 contract ExchangeRates is SelfDestructible {
1898 
1899 
1900     using SafeMath for uint;
1901     using SafeDecimalMath for uint;
1902 
1903     struct RateAndUpdatedTime {
1904         uint216 rate;
1905         uint40 time;
1906     }
1907 
1908     // Exchange rates and update times stored by currency code, e.g. 'SNX', or 'sUSD'
1909     mapping(bytes32 => RateAndUpdatedTime) private _rates;
1910 
1911     // The address of the oracle which pushes rate updates to this contract
1912     address public oracle;
1913 
1914     // Decentralized oracle networks that feed into pricing aggregators
1915     mapping(bytes32 => AggregatorInterface) public aggregators;
1916 
1917     // List of configure aggregator keys for convenient iteration
1918     bytes32[] public aggregatorKeys;
1919 
1920     // Do not allow the oracle to submit times any further forward into the future than this constant.
1921     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
1922 
1923     // How long will the contract assume the rate of any asset is correct
1924     uint public rateStalePeriod = 3 hours;
1925 
1926 
1927     // Each participating currency in the XDR basket is represented as a currency key with
1928     // equal weighting.
1929     // There are 5 participating currencies, so we'll declare that clearly.
1930     bytes32[5] public xdrParticipants;
1931 
1932     // A conveience mapping for checking if a rate is a XDR participant
1933     mapping(bytes32 => bool) public isXDRParticipant;
1934 
1935     // For inverted prices, keep a mapping of their entry, limits and frozen status
1936     struct InversePricing {
1937         uint entryPoint;
1938         uint upperLimit;
1939         uint lowerLimit;
1940         bool frozen;
1941     }
1942     mapping(bytes32 => InversePricing) public inversePricing;
1943     bytes32[] public invertedKeys;
1944 
1945     //
1946     // ========== CONSTRUCTOR ==========
1947 
1948     /**
1949      * @dev Constructor
1950      * @param _owner The owner of this contract.
1951      * @param _oracle The address which is able to update rate information.
1952      * @param _currencyKeys The initial currency keys to store (in order).
1953      * @param _newRates The initial currency amounts for each currency (in order).
1954      */
1955     constructor(
1956         // SelfDestructible (Ownable)
1957         address _owner,
1958 
1959         // Oracle values - Allows for rate updates
1960         address _oracle,
1961         bytes32[] _currencyKeys,
1962         uint[] _newRates
1963     )
1964         /* Owned is initialised in SelfDestructible */
1965         SelfDestructible(_owner)
1966         public
1967     {
1968         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
1969 
1970         oracle = _oracle;
1971 
1972         // The sUSD rate is always 1 and is never stale.
1973         _setRate("sUSD", SafeDecimalMath.unit(), now);
1974 
1975         // These are the currencies that make up the XDR basket.
1976         // These are hard coded because:
1977         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
1978         //  - Adding new currencies would likely introduce some kind of weighting factor, which
1979         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
1980         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
1981         //    then point the system at the new version.
1982         xdrParticipants = [
1983             bytes32("sUSD"),
1984             bytes32("sAUD"),
1985             bytes32("sCHF"),
1986             bytes32("sEUR"),
1987             bytes32("sGBP")
1988         ];
1989 
1990         // Mapping the XDR participants is cheaper than looping the xdrParticipants array to check if they exist
1991         isXDRParticipant[bytes32("sUSD")] = true;
1992         isXDRParticipant[bytes32("sAUD")] = true;
1993         isXDRParticipant[bytes32("sCHF")] = true;
1994         isXDRParticipant[bytes32("sEUR")] = true;
1995         isXDRParticipant[bytes32("sGBP")] = true;
1996 
1997         internalUpdateRates(_currencyKeys, _newRates, now);
1998     }
1999 
2000     function getRateAndUpdatedTime(bytes32 code) internal view returns (RateAndUpdatedTime) {
2001         if (aggregators[code] != address(0)) {
2002             return RateAndUpdatedTime({
2003                 rate: uint216(aggregators[code].latestAnswer() * 1e10),
2004                 time: uint40(aggregators[code].latestTimestamp())
2005             });
2006         } else {
2007             return _rates[code];
2008         }
2009     }
2010     /**
2011      * @notice Retrieves the exchange rate (sUSD per unit) for a given currency key
2012      */
2013     function rates(bytes32 code) public view returns(uint256) {
2014         return getRateAndUpdatedTime(code).rate;
2015     }
2016 
2017     /**
2018      * @notice Retrieves the timestamp the given rate was last updated.
2019      */
2020     function lastRateUpdateTimes(bytes32 code) public view returns(uint256) {
2021         return getRateAndUpdatedTime(code).time;
2022     }
2023 
2024     /**
2025      * @notice Retrieve the last update time for a list of currencies
2026      */
2027     function lastRateUpdateTimesForCurrencies(bytes32[] currencyKeys)
2028         public
2029         view
2030         returns (uint[])
2031     {
2032         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
2033 
2034         for (uint i = 0; i < currencyKeys.length; i++) {
2035             lastUpdateTimes[i] = lastRateUpdateTimes(currencyKeys[i]);
2036         }
2037 
2038         return lastUpdateTimes;
2039     }
2040 
2041     function _setRate(bytes32 code, uint256 rate, uint256 time) internal {
2042         _rates[code] = RateAndUpdatedTime({
2043             rate: uint216(rate),
2044             time: uint40(time)
2045         });
2046     }
2047 
2048     /* ========== SETTERS ========== */
2049 
2050     /**
2051      * @notice Set the rates stored in this contract
2052      * @param currencyKeys The currency keys you wish to update the rates for (in order)
2053      * @param newRates The rates for each currency (in order)
2054      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
2055      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
2056      *                 if it takes a long time for the transaction to confirm.
2057      */
2058     function updateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
2059         external
2060         onlyOracle
2061         returns(bool)
2062     {
2063         return internalUpdateRates(currencyKeys, newRates, timeSent);
2064     }
2065 
2066     /**
2067      * @notice Internal function which sets the rates stored in this contract
2068      * @param currencyKeys The currency keys you wish to update the rates for (in order)
2069      * @param newRates The rates for each currency (in order)
2070      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
2071      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
2072      *                 if it takes a long time for the transaction to confirm.
2073      */
2074     function internalUpdateRates(bytes32[] currencyKeys, uint[] newRates, uint timeSent)
2075         internal
2076         returns(bool)
2077     {
2078         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
2079         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
2080 
2081         bool recomputeXDRRate = false;
2082 
2083         // Loop through each key and perform update.
2084         for (uint i = 0; i < currencyKeys.length; i++) {
2085             bytes32 currencyKey = currencyKeys[i];
2086 
2087             // Should not set any rate to zero ever, as no asset will ever be
2088             // truely worthless and still valid. In this scenario, we should
2089             // delete the rate and remove it from the system.
2090             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
2091             require(currencyKey != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
2092 
2093             // We should only update the rate if it's at least the same age as the last rate we've got.
2094             if (timeSent < lastRateUpdateTimes(currencyKey)) {
2095                 continue;
2096             }
2097 
2098             newRates[i] = rateOrInverted(currencyKey, newRates[i]);
2099 
2100             // Ok, go ahead with the update.
2101             _setRate(currencyKey, newRates[i], timeSent);
2102 
2103             // Flag if XDR needs to be recomputed. Note: sUSD is not sent and assumed $1
2104             if (!recomputeXDRRate && isXDRParticipant[currencyKey]) {
2105                 recomputeXDRRate = true;
2106             }
2107         }
2108 
2109         emit RatesUpdated(currencyKeys, newRates);
2110 
2111         if (recomputeXDRRate) {
2112             // Now update our XDR rate.
2113             updateXDRRate(timeSent);
2114         }
2115 
2116         return true;
2117     }
2118 
2119     /**
2120      * @notice Internal function to get the inverted rate, if any, and mark an inverted
2121      *  key as frozen if either limits are reached.
2122      *
2123      * Inverted rates are ones that take a regular rate, perform a simple calculation (double entryPrice and
2124      * subtract the rate) on them and if the result of the calculation is over or under predefined limits, it freezes the
2125      * rate at that limit, preventing any future rate updates.
2126      *
2127      * For example, if we have an inverted rate iBTC with the following parameters set:
2128      * - entryPrice of 200
2129      * - upperLimit of 300
2130      * - lower of 100
2131      *
2132      * if this function is invoked with params iETH and 184 (or rather 184e18),
2133      * then the rate would be: 200 * 2 - 184 = 216. 100 < 216 < 200, so the rate would be 216,
2134      * and remain unfrozen.
2135      *
2136      * If this function is then invoked with params iETH and 301 (or rather 301e18),
2137      * then the rate would be: 200 * 2 - 301 = 99. 99 < 100, so the rate would be 100 and the
2138      * rate would become frozen, no longer accepting future price updates until the synth is unfrozen
2139      * by the owner function: setInversePricing().
2140      *
2141      * @param currencyKey The price key to lookup
2142      * @param rate The rate for the given price key
2143      */
2144     function rateOrInverted(bytes32 currencyKey, uint rate) internal returns (uint) {
2145         // if an inverse mapping exists, adjust the price accordingly
2146         InversePricing storage inverse = inversePricing[currencyKey];
2147         if (inverse.entryPoint <= 0) {
2148             return rate;
2149         }
2150 
2151         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
2152         uint newInverseRate = rates(currencyKey);
2153 
2154         // get the new inverted rate if not frozen
2155         if (!inverse.frozen) {
2156             uint doubleEntryPoint = inverse.entryPoint.mul(2);
2157             if (doubleEntryPoint <= rate) {
2158                 // avoid negative numbers for unsigned ints, so set this to 0
2159                 // which by the requirement that lowerLimit be > 0 will
2160                 // cause this to freeze the price to the lowerLimit
2161                 newInverseRate = 0;
2162             } else {
2163                 newInverseRate = doubleEntryPoint.sub(rate);
2164             }
2165 
2166             // now if new rate hits our limits, set it to the limit and freeze
2167             if (newInverseRate >= inverse.upperLimit) {
2168                 newInverseRate = inverse.upperLimit;
2169             } else if (newInverseRate <= inverse.lowerLimit) {
2170                 newInverseRate = inverse.lowerLimit;
2171             }
2172 
2173             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
2174                 inverse.frozen = true;
2175                 emit InversePriceFrozen(currencyKey);
2176             }
2177         }
2178 
2179         return newInverseRate;
2180     }
2181 
2182     /**
2183      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
2184      */
2185     function updateXDRRate(uint timeSent)
2186         internal
2187     {
2188         uint total = 0;
2189 
2190         for (uint i = 0; i < xdrParticipants.length; i++) {
2191             total = rates(xdrParticipants[i]).add(total);
2192         }
2193 
2194         // Set the rate and update time
2195         _setRate("XDR", total, timeSent);
2196 
2197         // Emit our updated event separate to the others to save
2198         // moving data around between arrays.
2199         bytes32[] memory eventCurrencyCode = new bytes32[](1);
2200         eventCurrencyCode[0] = "XDR";
2201 
2202         uint[] memory eventRate = new uint[](1);
2203         eventRate[0] = rates("XDR");
2204 
2205         emit RatesUpdated(eventCurrencyCode, eventRate);
2206     }
2207 
2208     /**
2209      * @notice Delete a rate stored in the contract
2210      * @param currencyKey The currency key you wish to delete the rate for
2211      */
2212     function deleteRate(bytes32 currencyKey)
2213         external
2214         onlyOracle
2215     {
2216         require(rates(currencyKey) > 0, "Rate is zero");
2217 
2218         delete _rates[currencyKey];
2219 
2220         emit RateDeleted(currencyKey);
2221     }
2222 
2223     /**
2224      * @notice Set the Oracle that pushes the rate information to this contract
2225      * @param _oracle The new oracle address
2226      */
2227     function setOracle(address _oracle)
2228         external
2229         onlyOwner
2230     {
2231         oracle = _oracle;
2232         emit OracleUpdated(oracle);
2233     }
2234 
2235     /**
2236      * @notice Set the stale period on the updated rate variables
2237      * @param _time The new rateStalePeriod
2238      */
2239     function setRateStalePeriod(uint _time)
2240         external
2241         onlyOwner
2242     {
2243         rateStalePeriod = _time;
2244         emit RateStalePeriodUpdated(rateStalePeriod);
2245     }
2246 
2247     /**
2248      * @notice Set an inverse price up for the currency key.
2249      *
2250      * An inverse price is one which has an entryPoint, an uppper and a lower limit. Each update, the
2251      * rate is calculated as double the entryPrice minus the current rate. If this calculation is
2252      * above or below the upper or lower limits respectively, then the rate is frozen, and no more
2253      * rate updates will be accepted.
2254      *
2255      * @param currencyKey The currency to update
2256      * @param entryPoint The entry price point of the inverted price
2257      * @param upperLimit The upper limit, at or above which the price will be frozen
2258      * @param lowerLimit The lower limit, at or below which the price will be frozen
2259      * @param freeze Whether or not to freeze this rate immediately. Note: no frozen event will be configured
2260      * @param freezeAtUpperLimit When the freeze flag is true, this flag indicates whether the rate
2261      * to freeze at is the upperLimit or lowerLimit..
2262      */
2263     function setInversePricing(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit, bool freeze, bool freezeAtUpperLimit)
2264         external onlyOwner
2265     {
2266         require(entryPoint > 0, "entryPoint must be above 0");
2267         require(lowerLimit > 0, "lowerLimit must be above 0");
2268         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
2269         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
2270         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
2271 
2272         if (inversePricing[currencyKey].entryPoint <= 0) {
2273             // then we are adding a new inverse pricing, so add this
2274             invertedKeys.push(currencyKey);
2275         }
2276         inversePricing[currencyKey].entryPoint = entryPoint;
2277         inversePricing[currencyKey].upperLimit = upperLimit;
2278         inversePricing[currencyKey].lowerLimit = lowerLimit;
2279         inversePricing[currencyKey].frozen = freeze;
2280 
2281         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
2282 
2283         // When indicating to freeze, we need to know the rate to freeze it at - either upper or lower
2284         // this is useful in situations where ExchangeRates is updated and there are existing inverted
2285         // rates already frozen in the current contract that need persisting across the upgrade
2286         if (freeze) {
2287             emit InversePriceFrozen(currencyKey);
2288 
2289             _setRate(currencyKey, freezeAtUpperLimit ? upperLimit : lowerLimit, now);
2290         }
2291     }
2292 
2293     /**
2294      * @notice Remove an inverse price for the currency key
2295      * @param currencyKey The currency to remove inverse pricing for
2296      */
2297     function removeInversePricing(bytes32 currencyKey) external onlyOwner
2298     {
2299         require(inversePricing[currencyKey].entryPoint > 0, "No inverted price exists");
2300 
2301         inversePricing[currencyKey].entryPoint = 0;
2302         inversePricing[currencyKey].upperLimit = 0;
2303         inversePricing[currencyKey].lowerLimit = 0;
2304         inversePricing[currencyKey].frozen = false;
2305 
2306         // now remove inverted key from array
2307         bool wasRemoved = removeFromArray(currencyKey, invertedKeys);
2308 
2309         if (wasRemoved) {
2310             emit InversePriceConfigured(currencyKey, 0, 0, 0);
2311         }
2312     }
2313 
2314     /**
2315      * @notice Add a pricing aggregator for the given key. Note: existing aggregators may be overridden.
2316      * @param currencyKey The currency key to add an aggregator for
2317      */
2318     function addAggregator(bytes32 currencyKey, address aggregatorAddress) external onlyOwner {
2319         AggregatorInterface aggregator = AggregatorInterface(aggregatorAddress);
2320         require(aggregator.latestTimestamp() >= 0, "Given Aggregator is invalid");
2321         if (aggregators[currencyKey] == address(0)) {
2322             aggregatorKeys.push(currencyKey);
2323         }
2324         aggregators[currencyKey] = aggregator;
2325         emit AggregatorAdded(currencyKey, aggregator);
2326     }
2327 
2328     /**
2329      * @notice Remove a single value from an array by iterating through until it is found.
2330      * @param entry The entry to find
2331      * @param array The array to mutate
2332      * @return bool Whether or not the entry was found and removed
2333      */
2334     function removeFromArray(bytes32 entry, bytes32[] storage array) internal returns (bool) {
2335         for (uint i = 0; i < array.length; i++) {
2336             if (array[i] == entry) {
2337                 delete array[i];
2338 
2339                 // Copy the last key into the place of the one we just deleted
2340                 // If there's only one key, this is array[0] = array[0].
2341                 // If we're deleting the last one, it's also a NOOP in the same way.
2342                 array[i] = array[array.length - 1];
2343 
2344                 // Decrease the size of the array by one.
2345                 array.length--;
2346 
2347                 return true;
2348             }
2349         }
2350         return false;
2351     }
2352     /**
2353      * @notice Remove a pricing aggregator for the given key
2354      * @param currencyKey THe currency key to remove an aggregator for
2355      */
2356     function removeAggregator(bytes32 currencyKey) external onlyOwner {
2357         address aggregator = aggregators[currencyKey];
2358         require(aggregator != address(0), "No aggregator exists for key");
2359         delete aggregators[currencyKey];
2360 
2361         bool wasRemoved = removeFromArray(currencyKey, aggregatorKeys);
2362 
2363         if (wasRemoved) {
2364             emit AggregatorRemoved(currencyKey, aggregator);
2365         }
2366     }
2367 
2368     /* ========== VIEWS ========== */
2369 
2370     /**
2371      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2372      * @param sourceCurrencyKey The currency the amount is specified in
2373      * @param sourceAmount The source amount, specified in UNIT base
2374      * @param destinationCurrencyKey The destination currency
2375      */
2376     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
2377         public
2378         view
2379         rateNotStale(sourceCurrencyKey)
2380         rateNotStale(destinationCurrencyKey)
2381         returns (uint)
2382     {
2383         // If there's no change in the currency, then just return the amount they gave us
2384         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
2385 
2386         // Calculate the effective value by going from source -> USD -> destination
2387         return sourceAmount.multiplyDecimalRound(rateForCurrency(sourceCurrencyKey))
2388             .divideDecimalRound(rateForCurrency(destinationCurrencyKey));
2389     }
2390 
2391     /**
2392      * @notice Retrieve the rate for a specific currency
2393      */
2394     function rateForCurrency(bytes32 currencyKey)
2395         public
2396         view
2397         returns (uint)
2398     {
2399         return rates(currencyKey);
2400     }
2401 
2402     /**
2403      * @notice Retrieve the rates for a list of currencies
2404      */
2405     function ratesForCurrencies(bytes32[] currencyKeys)
2406         public
2407         view
2408         returns (uint[])
2409     {
2410         uint[] memory _localRates = new uint[](currencyKeys.length);
2411 
2412         for (uint i = 0; i < currencyKeys.length; i++) {
2413             _localRates[i] = rates(currencyKeys[i]);
2414         }
2415 
2416         return _localRates;
2417     }
2418 
2419     /**
2420      * @notice Retrieve the rates and isAnyStale for a list of currencies
2421      */
2422     function ratesAndStaleForCurrencies(bytes32[] currencyKeys)
2423         public
2424         view
2425         returns (uint[], bool)
2426     {
2427         uint[] memory _localRates = new uint[](currencyKeys.length);
2428 
2429         bool anyRateStale = false;
2430         uint period = rateStalePeriod;
2431         for (uint i = 0; i < currencyKeys.length; i++) {
2432             RateAndUpdatedTime memory rateAndUpdateTime = getRateAndUpdatedTime(currencyKeys[i]);
2433             _localRates[i] = uint256(rateAndUpdateTime.rate);
2434             if (!anyRateStale) {
2435                 anyRateStale = (currencyKeys[i] != "sUSD" && uint256(rateAndUpdateTime.time).add(period) < now);
2436             }
2437         }
2438 
2439         return (_localRates, anyRateStale);
2440     }
2441 
2442     /**
2443      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
2444      */
2445     function rateIsStale(bytes32 currencyKey)
2446         public
2447         view
2448         returns (bool)
2449     {
2450         // sUSD is a special case and is never stale.
2451         if (currencyKey == "sUSD") return false;
2452 
2453         return lastRateUpdateTimes(currencyKey).add(rateStalePeriod) < now;
2454     }
2455 
2456     /**
2457      * @notice Check if any rate is frozen (cannot be exchanged into)
2458      */
2459     function rateIsFrozen(bytes32 currencyKey)
2460         external
2461         view
2462         returns (bool)
2463     {
2464         return inversePricing[currencyKey].frozen;
2465     }
2466 
2467 
2468     /**
2469      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
2470      */
2471     function anyRateIsStale(bytes32[] currencyKeys)
2472         external
2473         view
2474         returns (bool)
2475     {
2476         // Loop through each key and check whether the data point is stale.
2477         uint256 i = 0;
2478 
2479         while (i < currencyKeys.length) {
2480             // sUSD is a special case and is never false
2481             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes(currencyKeys[i]).add(rateStalePeriod) < now) {
2482                 return true;
2483             }
2484             i += 1;
2485         }
2486 
2487         return false;
2488     }
2489 
2490     /* ========== MODIFIERS ========== */
2491 
2492     modifier rateNotStale(bytes32 currencyKey) {
2493         require(!rateIsStale(currencyKey), "Rate stale or nonexistant currency");
2494         _;
2495     }
2496 
2497     modifier onlyOracle
2498     {
2499         require(msg.sender == oracle, "Only the oracle can perform this action");
2500         _;
2501     }
2502 
2503     /* ========== EVENTS ========== */
2504 
2505     event OracleUpdated(address newOracle);
2506     event RateStalePeriodUpdated(uint rateStalePeriod);
2507     event RatesUpdated(bytes32[] currencyKeys, uint[] newRates);
2508     event RateDeleted(bytes32 currencyKey);
2509     event InversePriceConfigured(bytes32 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
2510     event InversePriceFrozen(bytes32 currencyKey);
2511     event AggregatorAdded(bytes32 currencyKey, address aggregator);
2512     event AggregatorRemoved(bytes32 currencyKey, address aggregator);
2513 }
2514 
2515 
2516 /*
2517 -----------------------------------------------------------------
2518 FILE INFORMATION
2519 -----------------------------------------------------------------
2520 
2521 file:       LimitedSetup.sol
2522 version:    1.1
2523 author:     Anton Jurisevic
2524 
2525 date:       2018-05-15
2526 
2527 -----------------------------------------------------------------
2528 MODULE DESCRIPTION
2529 -----------------------------------------------------------------
2530 
2531 A contract with a limited setup period. Any function modified
2532 with the setup modifier will cease to work after the
2533 conclusion of the configurable-length post-construction setup period.
2534 
2535 -----------------------------------------------------------------
2536 */
2537 
2538 
2539 /**
2540  * @title Any function decorated with the modifier this contract provides
2541  * deactivates after a specified setup period.
2542  */
2543 contract LimitedSetup {
2544 
2545     uint setupExpiryTime;
2546 
2547     /**
2548      * @dev LimitedSetup Constructor.
2549      * @param setupDuration The time the setup period will last for.
2550      */
2551     constructor(uint setupDuration)
2552         public
2553     {
2554         setupExpiryTime = now + setupDuration;
2555     }
2556 
2557     modifier onlyDuringSetup
2558     {
2559         require(now < setupExpiryTime, "Can only perform this action during setup");
2560         _;
2561     }
2562 }
2563 
2564 
2565 /*
2566 -----------------------------------------------------------------
2567 FILE INFORMATION
2568 -----------------------------------------------------------------
2569 
2570 file:       SynthetixState.sol
2571 version:    1.0
2572 author:     Kevin Brown
2573 date:       2018-10-19
2574 
2575 -----------------------------------------------------------------
2576 MODULE DESCRIPTION
2577 -----------------------------------------------------------------
2578 
2579 A contract that holds issuance state and preferred currency of
2580 users in the Synthetix system.
2581 
2582 This contract is used side by side with the Synthetix contract
2583 to make it easier to upgrade the contract logic while maintaining
2584 issuance state.
2585 
2586 The Synthetix contract is also quite large and on the edge of
2587 being beyond the contract size limit without moving this information
2588 out to another contract.
2589 
2590 The first deployed contract would create this state contract,
2591 using it as its store of issuance data.
2592 
2593 When a new contract is deployed, it links to the existing
2594 state contract, whose owner would then change its associated
2595 contract to the new one.
2596 
2597 -----------------------------------------------------------------
2598 */
2599 
2600 
2601 /**
2602  * @title Synthetix State
2603  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
2604  */
2605 contract SynthetixState is State, LimitedSetup {
2606     using SafeMath for uint;
2607     using SafeDecimalMath for uint;
2608 
2609     // A struct for handing values associated with an individual user's debt position
2610     struct IssuanceData {
2611         // Percentage of the total debt owned at the time
2612         // of issuance. This number is modified by the global debt
2613         // delta array. You can figure out a user's exit price and
2614         // collateralisation ratio using a combination of their initial
2615         // debt and the slice of global debt delta which applies to them.
2616         uint initialDebtOwnership;
2617         // This lets us know when (in relative terms) the user entered
2618         // the debt pool so we can calculate their exit price and
2619         // collateralistion ratio
2620         uint debtEntryIndex;
2621     }
2622 
2623     // Issued synth balances for individual fee entitlements and exit price calculations
2624     mapping(address => IssuanceData) public issuanceData;
2625 
2626     // The total count of people that have outstanding issued synths in any flavour
2627     uint public totalIssuerCount;
2628 
2629     // Global debt pool tracking
2630     uint[] public debtLedger;
2631 
2632     // Import state
2633     uint public importedXDRAmount;
2634 
2635     // A quantity of synths greater than this ratio
2636     // may not be issued against a given value of SNX.
2637     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
2638     // No more synths may be issued than the value of SNX backing them.
2639     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
2640 
2641     // Users can specify their preferred currency, in which case all synths they receive
2642     // will automatically exchange to that preferred currency upon receipt in their wallet
2643     mapping(address => bytes4) public preferredCurrency;
2644 
2645     /**
2646      * @dev Constructor
2647      * @param _owner The address which controls this contract.
2648      * @param _associatedContract The ERC20 contract whose state this composes.
2649      */
2650     constructor(address _owner, address _associatedContract)
2651         State(_owner, _associatedContract)
2652         LimitedSetup(1 weeks)
2653         public
2654     {}
2655 
2656     /* ========== SETTERS ========== */
2657 
2658     /**
2659      * @notice Set issuance data for an address
2660      * @dev Only the associated contract may call this.
2661      * @param account The address to set the data for.
2662      * @param initialDebtOwnership The initial debt ownership for this address.
2663      */
2664     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
2665         external
2666         onlyAssociatedContract
2667     {
2668         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
2669         issuanceData[account].debtEntryIndex = debtLedger.length;
2670     }
2671 
2672     /**
2673      * @notice Clear issuance data for an address
2674      * @dev Only the associated contract may call this.
2675      * @param account The address to clear the data for.
2676      */
2677     function clearIssuanceData(address account)
2678         external
2679         onlyAssociatedContract
2680     {
2681         delete issuanceData[account];
2682     }
2683 
2684     /**
2685      * @notice Increment the total issuer count
2686      * @dev Only the associated contract may call this.
2687      */
2688     function incrementTotalIssuerCount()
2689         external
2690         onlyAssociatedContract
2691     {
2692         totalIssuerCount = totalIssuerCount.add(1);
2693     }
2694 
2695     /**
2696      * @notice Decrement the total issuer count
2697      * @dev Only the associated contract may call this.
2698      */
2699     function decrementTotalIssuerCount()
2700         external
2701         onlyAssociatedContract
2702     {
2703         totalIssuerCount = totalIssuerCount.sub(1);
2704     }
2705 
2706     /**
2707      * @notice Append a value to the debt ledger
2708      * @dev Only the associated contract may call this.
2709      * @param value The new value to be added to the debt ledger.
2710      */
2711     function appendDebtLedgerValue(uint value)
2712         external
2713         onlyAssociatedContract
2714     {
2715         debtLedger.push(value);
2716     }
2717 
2718     /**
2719      * @notice Set preferred currency for a user
2720      * @dev Only the associated contract may call this.
2721      * @param account The account to set the preferred currency for
2722      * @param currencyKey The new preferred currency
2723      */
2724     function setPreferredCurrency(address account, bytes4 currencyKey)
2725         external
2726         onlyAssociatedContract
2727     {
2728         preferredCurrency[account] = currencyKey;
2729     }
2730 
2731     /**
2732      * @notice Set the issuanceRatio for issuance calculations.
2733      * @dev Only callable by the contract owner.
2734      */
2735     function setIssuanceRatio(uint _issuanceRatio)
2736         external
2737         onlyOwner
2738     {
2739         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
2740         issuanceRatio = _issuanceRatio;
2741         emit IssuanceRatioUpdated(_issuanceRatio);
2742     }
2743 
2744     /**
2745      * @notice Import issuer data from the old Synthetix contract before multicurrency
2746      * @dev Only callable by the contract owner, and only for 1 week after deployment.
2747      */
2748     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
2749         external
2750         onlyOwner
2751         onlyDuringSetup
2752     {
2753         require(accounts.length == sUSDAmounts.length, "Length mismatch");
2754 
2755         for (uint8 i = 0; i < accounts.length; i++) {
2756             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
2757         }
2758     }
2759 
2760     /**
2761      * @notice Import issuer data from the old Synthetix contract before multicurrency
2762      * @dev Only used from importIssuerData above, meant to be disposable
2763      */
2764     function _addToDebtRegister(address account, uint amount)
2765         internal
2766     {
2767         // This code is duplicated from Synthetix so that we can call it directly here
2768         // during setup only.
2769         Synthetix synthetix = Synthetix(associatedContract);
2770 
2771         // What is the value of the requested debt in XDRs?
2772         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
2773 
2774         // What is the value that we've previously imported?
2775         uint totalDebtIssued = importedXDRAmount;
2776 
2777         // What will the new total be including the new value?
2778         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2779 
2780         // Save that for the next import.
2781         importedXDRAmount = newTotalDebtIssued;
2782 
2783         // What is their percentage (as a high precision int) of the total debt?
2784         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2785 
2786         // And what effect does this percentage have on the global debt holding of other issuers?
2787         // The delta specifically needs to not take into account any existing debt as it's already
2788         // accounted for in the delta from when they issued previously.
2789         // The delta is a high precision integer.
2790         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2791 
2792         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
2793 
2794         // And what does their debt ownership look like including this previous stake?
2795         if (existingDebt > 0) {
2796             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2797         }
2798 
2799         // Are they a new issuer? If so, record them.
2800         if (issuanceData[account].initialDebtOwnership == 0) {
2801             totalIssuerCount = totalIssuerCount.add(1);
2802         }
2803 
2804         // Save the debt entry parameters
2805         issuanceData[account].initialDebtOwnership = debtPercentage;
2806         issuanceData[account].debtEntryIndex = debtLedger.length;
2807 
2808         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2809         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2810         if (debtLedger.length > 0) {
2811             debtLedger.push(
2812                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2813             );
2814         } else {
2815             debtLedger.push(SafeDecimalMath.preciseUnit());
2816         }
2817     }
2818 
2819     /* ========== VIEWS ========== */
2820 
2821     /**
2822      * @notice Retrieve the length of the debt ledger array
2823      */
2824     function debtLedgerLength()
2825         external
2826         view
2827         returns (uint)
2828     {
2829         return debtLedger.length;
2830     }
2831 
2832     /**
2833      * @notice Retrieve the most recent entry from the debt ledger
2834      */
2835     function lastDebtLedgerEntry()
2836         external
2837         view
2838         returns (uint)
2839     {
2840         return debtLedger[debtLedger.length - 1];
2841     }
2842 
2843     /**
2844      * @notice Query whether an account has issued and has an outstanding debt balance
2845      * @param account The address to query for
2846      */
2847     function hasIssued(address account)
2848         external
2849         view
2850         returns (bool)
2851     {
2852         return issuanceData[account].initialDebtOwnership > 0;
2853     }
2854 
2855     event IssuanceRatioUpdated(uint newRatio);
2856 }
2857 
2858 
2859 /**
2860  * @title RewardsDistribution interface
2861  */
2862 interface IRewardsDistribution {
2863     function distributeRewards(uint amount) external;
2864 }
2865 
2866 
2867 /**
2868  * @title Synthetix ERC20 contract.
2869  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2870  * but it also computes the quantity of fees each synthetix holder is entitled to.
2871  */
2872 contract Synthetix is ExternStateToken {
2873 
2874     // ========== STATE VARIABLES ==========
2875 
2876     // Available Synths which can be used with the system
2877     Synth[] public availableSynths;
2878     mapping(bytes32 => Synth) public synths;
2879     mapping(address => bytes32) public synthsByAddress;
2880 
2881     IFeePool public feePool;
2882     ISynthetixEscrow public escrow;
2883     ISynthetixEscrow public rewardEscrow;
2884     ExchangeRates public exchangeRates;
2885     SynthetixState public synthetixState;
2886     SupplySchedule public supplySchedule;
2887     IRewardsDistribution public rewardsDistribution;
2888 
2889     bool private protectionCircuit = false;
2890 
2891     string constant TOKEN_NAME = "Synthetix Network Token";
2892     string constant TOKEN_SYMBOL = "SNX";
2893     uint8 constant DECIMALS = 18;
2894     bool public exchangeEnabled = true;
2895     uint public gasPriceLimit;
2896 
2897     address public gasLimitOracle;
2898     // ========== CONSTRUCTOR ==========
2899 
2900     /**
2901      * @dev Constructor
2902      * @param _proxy The main token address of the Proxy contract. This will be ProxyERC20.sol
2903      * @param _tokenState Address of the external immutable contract containing token balances.
2904      * @param _synthetixState External immutable contract containing the SNX minters debt ledger.
2905      * @param _owner The owner of this contract.
2906      * @param _exchangeRates External immutable contract where the price oracle pushes prices onchain too.
2907      * @param _feePool External upgradable contract handling SNX Fees and Rewards claiming
2908      * @param _supplySchedule External immutable contract with the SNX inflationary supply schedule
2909      * @param _rewardEscrow External immutable contract for SNX Rewards Escrow
2910      * @param _escrow External immutable contract for SNX Token Sale Escrow
2911      * @param _rewardsDistribution External immutable contract managing the Rewards Distribution of the SNX inflationary supply
2912      * @param _totalSupply On upgrading set to reestablish the current total supply (This should be in SynthetixState if ever updated)
2913      */
2914     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2915         address _owner, ExchangeRates _exchangeRates, IFeePool _feePool, SupplySchedule _supplySchedule,
2916         ISynthetixEscrow _rewardEscrow, ISynthetixEscrow _escrow, IRewardsDistribution _rewardsDistribution, uint _totalSupply
2917     )
2918         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, _totalSupply, DECIMALS, _owner)
2919         public
2920     {
2921         synthetixState = _synthetixState;
2922         exchangeRates = _exchangeRates;
2923         feePool = _feePool;
2924         supplySchedule = _supplySchedule;
2925         rewardEscrow = _rewardEscrow;
2926         escrow = _escrow;
2927         rewardsDistribution = _rewardsDistribution;
2928     }
2929     // ========== SETTERS ========== */
2930 
2931     function setFeePool(IFeePool _feePool)
2932         external
2933         optionalProxy_onlyOwner
2934     {
2935         feePool = _feePool;
2936     }
2937 
2938     function setExchangeRates(ExchangeRates _exchangeRates)
2939         external
2940         optionalProxy_onlyOwner
2941     {
2942         exchangeRates = _exchangeRates;
2943     }
2944 
2945     function setProtectionCircuit(bool _protectionCircuitIsActivated)
2946         external
2947         onlyOracle
2948     {
2949         protectionCircuit = _protectionCircuitIsActivated;
2950     }
2951 
2952     function setExchangeEnabled(bool _exchangeEnabled)
2953         external
2954         optionalProxy_onlyOwner
2955     {
2956         exchangeEnabled = _exchangeEnabled;
2957     }
2958 
2959     function setGasLimitOracle(address _gasLimitOracle)
2960         external
2961         optionalProxy_onlyOwner
2962     {
2963         gasLimitOracle = _gasLimitOracle;
2964     }
2965 
2966     function setGasPriceLimit(uint _gasPriceLimit)
2967         external
2968     {
2969         require(msg.sender == gasLimitOracle, "Only gas limit oracle allowed");
2970         require(_gasPriceLimit > 0, "Needs to be greater than 0");
2971         gasPriceLimit = _gasPriceLimit;
2972     }
2973 
2974     /**
2975      * @notice Add an associated Synth contract to the Synthetix system
2976      * @dev Only the contract owner may call this.
2977      */
2978     function addSynth(Synth synth)
2979         external
2980         optionalProxy_onlyOwner
2981     {
2982         bytes32 currencyKey = synth.currencyKey();
2983 
2984         require(synths[currencyKey] == Synth(0), "Synth already exists");
2985         require(synthsByAddress[synth] == bytes32(0), "Synth address already exists");
2986 
2987         availableSynths.push(synth);
2988         synths[currencyKey] = synth;
2989         synthsByAddress[synth] = currencyKey;
2990     }
2991 
2992     /**
2993      * @notice Remove an associated Synth contract from the Synthetix system
2994      * @dev Only the contract owner may call this.
2995      */
2996     function removeSynth(bytes32 currencyKey)
2997         external
2998         optionalProxy_onlyOwner
2999     {
3000         require(synths[currencyKey] != address(0), "Synth does not exist");
3001         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
3002         require(currencyKey != "XDR", "Cannot remove XDR synth");
3003         require(currencyKey != "sUSD", "Cannot remove sUSD synth");
3004 
3005         // Save the address we're removing for emitting the event at the end.
3006         address synthToRemove = synths[currencyKey];
3007 
3008         // Remove the synth from the availableSynths array.
3009         for (uint i = 0; i < availableSynths.length; i++) {
3010             if (availableSynths[i] == synthToRemove) {
3011                 delete availableSynths[i];
3012 
3013                 // Copy the last synth into the place of the one we just deleted
3014                 // If there's only one synth, this is synths[0] = synths[0].
3015                 // If we're deleting the last one, it's also a NOOP in the same way.
3016                 availableSynths[i] = availableSynths[availableSynths.length - 1];
3017 
3018                 // Decrease the size of the array by one.
3019                 availableSynths.length--;
3020 
3021                 break;
3022             }
3023         }
3024 
3025         // And remove it from the synths mapping
3026         delete synthsByAddress[synths[currencyKey]];
3027         delete synths[currencyKey];
3028 
3029         // Note: No event here as Synthetix contract exceeds max contract size
3030         // with these events, and it's unlikely people will need to
3031         // track these events specifically.
3032     }
3033 
3034     // ========== VIEWS ==========
3035 
3036     /**
3037      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
3038      * @param sourceCurrencyKey The currency the amount is specified in
3039      * @param sourceAmount The source amount, specified in UNIT base
3040      * @param destinationCurrencyKey The destination currency
3041      */
3042     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
3043         public
3044         view
3045         returns (uint)
3046     {
3047         return exchangeRates.effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3048     }
3049 
3050     /**
3051      * @notice Total amount of synths issued by the system, priced in currencyKey
3052      * @param currencyKey The currency to value the synths in
3053      */
3054     function totalIssuedSynths(bytes32 currencyKey)
3055         public
3056         view
3057         returns (uint)
3058     {
3059         uint total = 0;
3060         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
3061 
3062         (uint[] memory rates, bool anyRateStale) = exchangeRates.ratesAndStaleForCurrencies(availableCurrencyKeys());
3063         require(!anyRateStale, "Rates are stale");
3064 
3065         for (uint i = 0; i < availableSynths.length; i++) {
3066             // What's the total issued value of that synth in the destination currency?
3067             // Note: We're not using our effectiveValue function because we don't want to go get the
3068             //       rate for the destination currency and check if it's stale repeatedly on every
3069             //       iteration of the loop
3070             uint synthValue = availableSynths[i].totalSupply()
3071                 .multiplyDecimalRound(rates[i]);
3072             total = total.add(synthValue);
3073         }
3074 
3075         return total.divideDecimalRound(currencyRate);
3076     }
3077 
3078     /**
3079      * @notice Returns the currencyKeys of availableSynths for rate checking
3080      */
3081     function availableCurrencyKeys()
3082         public
3083         view
3084         returns (bytes32[])
3085     {
3086         bytes32[] memory currencyKeys = new bytes32[](availableSynths.length);
3087 
3088         for (uint i = 0; i < availableSynths.length; i++) {
3089             currencyKeys[i] = synthsByAddress[availableSynths[i]];
3090         }
3091 
3092         return currencyKeys;
3093     }
3094 
3095     /**
3096      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
3097      */
3098     function availableSynthCount()
3099         public
3100         view
3101         returns (uint)
3102     {
3103         return availableSynths.length;
3104     }
3105 
3106     /**
3107      * @notice Determine the effective fee rate for the exchange, taking into considering swing trading
3108      */
3109     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
3110         public
3111         view
3112         returns (uint)
3113     {
3114         // Get the base exchange fee rate
3115         uint exchangeFeeRate = feePool.exchangeFeeRate();
3116 
3117         uint multiplier = 1;
3118 
3119         // Is this a swing trade? I.e. long to short or vice versa, excluding when going into or out of sUSD.
3120         // Note: this assumes shorts begin with 'i' and longs with 's'.
3121         if (
3122             (sourceCurrencyKey[0] == 0x73 && sourceCurrencyKey != "sUSD" && destinationCurrencyKey[0] == 0x69) ||
3123             (sourceCurrencyKey[0] == 0x69 && destinationCurrencyKey != "sUSD" && destinationCurrencyKey[0] == 0x73)
3124         ) {
3125             // If so then double the exchange fee multipler
3126             multiplier = 2;
3127         }
3128 
3129         return exchangeFeeRate.mul(multiplier);
3130     }
3131     // ========== MUTATIVE FUNCTIONS ==========
3132 
3133     /**
3134      * @notice ERC20 transfer function.
3135      */
3136     function transfer(address to, uint value)
3137         public
3138         returns (bool)
3139     {
3140         bytes memory empty;
3141         return transfer(to, value, empty);
3142     }
3143 
3144     /**
3145      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
3146      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3147      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3148      *           tooling such as Etherscan.
3149      */
3150     function transfer(address to, uint value, bytes data)
3151         public
3152         optionalProxy
3153         returns (bool)
3154     {
3155         // Ensure they're not trying to exceed their locked amount
3156         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
3157 
3158         // Perform the transfer: if there is a problem an exception will be thrown in this call.
3159         _transfer_byProxy(messageSender, to, value, data);
3160 
3161         return true;
3162     }
3163 
3164     /**
3165      * @notice ERC20 transferFrom function.
3166      */
3167     function transferFrom(address from, address to, uint value)
3168         public
3169         returns (bool)
3170     {
3171         bytes memory empty;
3172         return transferFrom(from, to, value, empty);
3173     }
3174 
3175     /**
3176      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
3177      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3178      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3179      *           tooling such as Etherscan.
3180      */
3181     function transferFrom(address from, address to, uint value, bytes data)
3182         public
3183         optionalProxy
3184         returns (bool)
3185     {
3186         // Ensure they're not trying to exceed their locked amount
3187         require(value <= transferableSynthetix(from), "Insufficient balance");
3188 
3189         // Perform the transfer: if there is a problem,
3190         // an exception will be thrown in this call.
3191         _transferFrom_byProxy(messageSender, from, to, value, data);
3192 
3193         return true;
3194     }
3195 
3196     /**
3197      * @notice Function that allows you to exchange synths you hold in one flavour for another.
3198      * @param sourceCurrencyKey The source currency you wish to exchange from
3199      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3200      * @param destinationCurrencyKey The destination currency you wish to obtain.
3201      * @return Boolean that indicates whether the transfer succeeded or failed.
3202      */
3203     function exchange(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
3204         external
3205         optionalProxy
3206         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
3207         returns (bool)
3208     {
3209         require(sourceCurrencyKey != destinationCurrencyKey, "Must use different synths");
3210         require(sourceAmount > 0, "Zero amount");
3211 
3212         // verify gas price limit
3213         validateGasPrice(tx.gasprice);
3214 
3215         //  If the oracle has set protectionCircuit to true then burn the synths
3216         if (protectionCircuit) {
3217             synths[sourceCurrencyKey].burn(messageSender, sourceAmount);
3218             return true;
3219         } else {
3220             // Pass it along, defaulting to the sender as the recipient.
3221             return _internalExchange(
3222                 messageSender,
3223                 sourceCurrencyKey,
3224                 sourceAmount,
3225                 destinationCurrencyKey,
3226                 messageSender,
3227                 true // Charge fee on the exchange
3228             );
3229         }
3230     }
3231 
3232     /*
3233         @dev validate that the given gas price is less than or equal to the gas price limit
3234         @param _gasPrice tested gas price
3235     */
3236     function validateGasPrice(uint _givenGasPrice)
3237         public
3238         view
3239     {
3240         require(_givenGasPrice <= gasPriceLimit, "Gas price above limit");
3241     }
3242 
3243     /**
3244      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
3245      * @dev Only the synth contract can call this function
3246      * @param from The address to exchange / burn synth from
3247      * @param sourceCurrencyKey The source currency you wish to exchange from
3248      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3249      * @param destinationCurrencyKey The destination currency you wish to obtain.
3250      * @param destinationAddress Where the result should go.
3251      * @return Boolean that indicates whether the transfer succeeded or failed.
3252      */
3253     function synthInitiatedExchange(
3254         address from,
3255         bytes32 sourceCurrencyKey,
3256         uint sourceAmount,
3257         bytes32 destinationCurrencyKey,
3258         address destinationAddress
3259     )
3260         external
3261         optionalProxy
3262         returns (bool)
3263     {
3264         require(synthsByAddress[messageSender] != bytes32(0), "Only synth allowed");
3265         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3266         require(sourceAmount > 0, "Zero amount");
3267 
3268         // Pass it along
3269         return _internalExchange(
3270             from,
3271             sourceCurrencyKey,
3272             sourceAmount,
3273             destinationCurrencyKey,
3274             destinationAddress,
3275             false
3276         );
3277     }
3278 
3279     /**
3280      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3281      * @dev fee pool contract address is not allowed to call function
3282      * @param from The address to move synth from
3283      * @param sourceCurrencyKey source currency from.
3284      * @param sourceAmount The amount, specified in UNIT of source currency.
3285      * @param destinationCurrencyKey The destination currency to obtain.
3286      * @param destinationAddress Where the result should go.
3287      * @param chargeFee Boolean to charge a fee for exchange.
3288      * @return Boolean that indicates whether the transfer succeeded or failed.
3289      */
3290     function _internalExchange(
3291         address from,
3292         bytes32 sourceCurrencyKey,
3293         uint sourceAmount,
3294         bytes32 destinationCurrencyKey,
3295         address destinationAddress,
3296         bool chargeFee
3297     )
3298         internal
3299         notFeeAddress(from)
3300         returns (bool)
3301     {
3302         require(exchangeEnabled, "Exchanging is disabled");
3303 
3304         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3305         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3306 
3307         // Burn the source amount
3308         synths[sourceCurrencyKey].burn(from, sourceAmount);
3309 
3310         // How much should they get in the destination currency?
3311         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3312 
3313         // What's the fee on that currency that we should deduct?
3314         uint amountReceived = destinationAmount;
3315         uint fee = 0;
3316 
3317         if (chargeFee) {
3318             // Get the exchange fee rate
3319             uint exchangeFeeRate = feeRateForExchange(sourceCurrencyKey, destinationCurrencyKey);
3320 
3321             amountReceived = destinationAmount.multiplyDecimal(SafeDecimalMath.unit().sub(exchangeFeeRate));
3322 
3323             fee = destinationAmount.sub(amountReceived);
3324         }
3325 
3326         // Issue their new synths
3327         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3328 
3329         // Remit the fee in XDRs
3330         if (fee > 0) {
3331             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3332             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3333             // Tell the fee pool about this.
3334             feePool.recordFeePaid(xdrFeeAmount);
3335         }
3336 
3337         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3338 
3339         // Call the ERC223 transfer callback if needed
3340         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
3341 
3342         //Let the DApps know there was a Synth exchange
3343         emitSynthExchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, amountReceived, destinationAddress);
3344 
3345         return true;
3346     }
3347 
3348     /**
3349      * @notice Function that registers new synth as they are issued. Calculate delta to append to synthetixState.
3350      * @dev Only internal calls from synthetix address.
3351      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3352      * @param amount The amount of synths to register with a base of UNIT
3353      */
3354     function _addToDebtRegister(bytes32 currencyKey, uint amount)
3355         internal
3356     {
3357         // What is the value of the requested debt in XDRs?
3358         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3359 
3360         // What is the value of all issued synths of the system (priced in XDRs)?
3361         uint totalDebtIssued = totalIssuedSynths("XDR");
3362 
3363         // What will the new total be including the new value?
3364         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3365 
3366         // What is their percentage (as a high precision int) of the total debt?
3367         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3368 
3369         // And what effect does this percentage change have on the global debt holding of other issuers?
3370         // The delta specifically needs to not take into account any existing debt as it's already
3371         // accounted for in the delta from when they issued previously.
3372         // The delta is a high precision integer.
3373         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3374 
3375         // How much existing debt do they have?
3376         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3377 
3378         // And what does their debt ownership look like including this previous stake?
3379         if (existingDebt > 0) {
3380             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3381         }
3382 
3383         // Are they a new issuer? If so, record them.
3384         if (existingDebt == 0) {
3385             synthetixState.incrementTotalIssuerCount();
3386         }
3387 
3388         // Save the debt entry parameters
3389         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3390 
3391         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3392         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3393         if (synthetixState.debtLedgerLength() > 0) {
3394             synthetixState.appendDebtLedgerValue(
3395                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3396             );
3397         } else {
3398             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3399         }
3400     }
3401 
3402     /**
3403      * @notice Issue synths against the sender's SNX.
3404      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3405      * @param amount The amount of synths you wish to issue with a base of UNIT
3406      */
3407     function issueSynths(uint amount)
3408         public
3409         optionalProxy
3410         // No need to check if price is stale, as it is checked in issuableSynths.
3411     {
3412         bytes32 currencyKey = "sUSD";
3413 
3414         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3415 
3416         // Keep track of the debt they're about to create
3417         _addToDebtRegister(currencyKey, amount);
3418 
3419         // Create their synths
3420         synths[currencyKey].issue(messageSender, amount);
3421 
3422         // Store their locked SNX amount to determine their fee % for the period
3423         _appendAccountIssuanceRecord();
3424     }
3425 
3426     /**
3427      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3428      * @dev Issuance is only allowed if the synthetix price isn't stale.
3429      */
3430     function issueMaxSynths()
3431         external
3432         optionalProxy
3433     {
3434         bytes32 currencyKey = "sUSD";
3435 
3436         // Figure out the maximum we can issue in that currency
3437         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3438 
3439         // Keep track of the debt they're about to create
3440         _addToDebtRegister(currencyKey, maxIssuable);
3441 
3442         // Create their synths
3443         synths[currencyKey].issue(messageSender, maxIssuable);
3444 
3445         // Store their locked SNX amount to determine their fee % for the period
3446         _appendAccountIssuanceRecord();
3447     }
3448 
3449     /**
3450      * @notice Burn synths to clear issued synths/free SNX.
3451      * @param amount The amount (in UNIT base) you wish to burn
3452      * @dev The amount to burn is debased to XDR's
3453      */
3454     function burnSynths(uint amount)
3455         external
3456         optionalProxy
3457         // No need to check for stale rates as effectiveValue checks rates
3458     {
3459         bytes32 currencyKey = "sUSD";
3460 
3461         // How much debt do they have?
3462         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3463         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3464 
3465         uint debtInCurrencyKey = debtBalanceOf(messageSender, currencyKey);
3466 
3467         require(existingDebt > 0, "No debt to forgive");
3468 
3469         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3470         // clear their debt and leave them be.
3471         uint amountToRemove = existingDebt < debtToRemove ? existingDebt : debtToRemove;
3472 
3473         // Remove their debt from the ledger
3474         _removeFromDebtRegister(amountToRemove, existingDebt);
3475 
3476         uint amountToBurn = debtInCurrencyKey < amount ? debtInCurrencyKey : amount;
3477 
3478         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3479         synths[currencyKey].burn(messageSender, amountToBurn);
3480 
3481         // Store their debtRatio against a feeperiod to determine their fee/rewards % for the period
3482         _appendAccountIssuanceRecord();
3483     }
3484 
3485     /**
3486      * @notice Store in the FeePool the users current debt value in the system in XDRs.
3487      * @dev debtBalanceOf(messageSender, "XDR") to be used with totalIssuedSynths("XDR") to get
3488      *  users % of the system within a feePeriod.
3489      */
3490     function _appendAccountIssuanceRecord()
3491         internal
3492     {
3493         uint initialDebtOwnership;
3494         uint debtEntryIndex;
3495         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(messageSender);
3496 
3497         feePool.appendAccountIssuanceRecord(
3498             messageSender,
3499             initialDebtOwnership,
3500             debtEntryIndex
3501         );
3502     }
3503 
3504     /**
3505      * @notice Remove a debt position from the register
3506      * @param amount The amount (in UNIT base) being presented in XDRs
3507      * @param existingDebt The existing debt (in UNIT base) of address presented in XDRs
3508      */
3509     function _removeFromDebtRegister(uint amount, uint existingDebt)
3510         internal
3511     {
3512         uint debtToRemove = amount;
3513 
3514         // What is the value of all issued synths of the system (priced in XDRs)?
3515         uint totalDebtIssued = totalIssuedSynths("XDR");
3516 
3517         // What will the new total after taking out the withdrawn amount
3518         uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3519 
3520         uint delta = 0;
3521 
3522         // What will the debt delta be if there is any debt left?
3523         // Set delta to 0 if no more debt left in system after user
3524         if (newTotalDebtIssued > 0) {
3525 
3526             // What is the percentage of the withdrawn debt (as a high precision int) of the total debt after?
3527             uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(newTotalDebtIssued);
3528 
3529             // And what effect does this percentage change have on the global debt holding of other issuers?
3530             // The delta specifically needs to not take into account any existing debt as it's already
3531             // accounted for in the delta from when they issued previously.
3532             delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3533         }
3534 
3535         // Are they exiting the system, or are they just decreasing their debt position?
3536         if (debtToRemove == existingDebt) {
3537             synthetixState.setCurrentIssuanceData(messageSender, 0);
3538             synthetixState.decrementTotalIssuerCount();
3539         } else {
3540             // What percentage of the debt will they be left with?
3541             uint newDebt = existingDebt.sub(debtToRemove);
3542             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3543 
3544             // Store the debt percentage and debt ledger as high precision integers
3545             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3546         }
3547 
3548         // Update our cumulative ledger. This is also a high precision integer.
3549         synthetixState.appendDebtLedgerValue(
3550             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3551         );
3552     }
3553 
3554     // ========== Issuance/Burning ==========
3555 
3556     /**
3557      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3558      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3559      */
3560     function maxIssuableSynths(address issuer, bytes32 currencyKey)
3561         public
3562         view
3563         // We don't need to check stale rates here as effectiveValue will do it for us.
3564         returns (uint)
3565     {
3566         // What is the value of their SNX balance in the destination currency?
3567         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3568 
3569         // They're allowed to issue up to issuanceRatio of that value
3570         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3571     }
3572 
3573     /**
3574      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3575      * as the value of the underlying Synthetix asset changes,
3576      * e.g. based on an issuance ratio of 20%. if a user issues their maximum available
3577      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3578      * of Synthetix changes, the ratio returned by this function will adjust accordingly. Users are
3579      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3580      * altering the amount of fees they're able to claim from the system.
3581      */
3582     function collateralisationRatio(address issuer)
3583         public
3584         view
3585         returns (uint)
3586     {
3587         uint totalOwnedSynthetix = collateral(issuer);
3588         if (totalOwnedSynthetix == 0) return 0;
3589 
3590         uint debtBalance = debtBalanceOf(issuer, "SNX");
3591         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3592     }
3593 
3594     /**
3595      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3596      * will tell you how many synths a user has to give back to the system in order to unlock their original
3597      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3598      * the debt in sUSD, XDR, or any other synth you wish.
3599      */
3600     function debtBalanceOf(address issuer, bytes32 currencyKey)
3601         public
3602         view
3603         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3604         returns (uint)
3605     {
3606         // What was their initial debt ownership?
3607         uint initialDebtOwnership;
3608         uint debtEntryIndex;
3609         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3610 
3611         // If it's zero, they haven't issued, and they have no debt.
3612         if (initialDebtOwnership == 0) return 0;
3613 
3614         // Figure out the global debt percentage delta from when they entered the system.
3615         // This is a high precision integer.
3616         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3617             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3618             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3619 
3620         // What's the total value of the system in their requested currency?
3621         uint totalSystemValue = totalIssuedSynths(currencyKey);
3622 
3623         // Their debt balance is their portion of the total system value.
3624         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3625             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3626 
3627         return highPrecisionBalance.preciseDecimalToDecimal();
3628     }
3629 
3630     /**
3631      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3632      * @param issuer The account that intends to issue
3633      * @param currencyKey The currency to price issuable value in
3634      */
3635     function remainingIssuableSynths(address issuer, bytes32 currencyKey)
3636         public
3637         view
3638         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3639         returns (uint)
3640     {
3641         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3642         uint max = maxIssuableSynths(issuer, currencyKey);
3643 
3644         if (alreadyIssued >= max) {
3645             return 0;
3646         } else {
3647             return max.sub(alreadyIssued);
3648         }
3649     }
3650 
3651     /**
3652      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3653      * against which synths can be issued.
3654      * This includes those already being used as collateral (locked), and those
3655      * available for further issuance (unlocked).
3656      */
3657     function collateral(address account)
3658         public
3659         view
3660         returns (uint)
3661     {
3662         uint balance = tokenState.balanceOf(account);
3663 
3664         if (escrow != address(0)) {
3665             balance = balance.add(escrow.balanceOf(account));
3666         }
3667 
3668         if (rewardEscrow != address(0)) {
3669             balance = balance.add(rewardEscrow.balanceOf(account));
3670         }
3671 
3672         return balance;
3673     }
3674 
3675     /**
3676      * @notice The number of SNX that are free to be transferred for an account.
3677      * @dev Escrowed SNX are not transferable, so they are not included
3678      * in this calculation.
3679      * @notice SNX rate not stale is checked within debtBalanceOf
3680      */
3681     function transferableSynthetix(address account)
3682         public
3683         view
3684         rateNotStale("SNX") // SNX is not a synth so is not checked in totalIssuedSynths
3685         returns (uint)
3686     {
3687         // How many SNX do they have, excluding escrow?
3688         // Note: We're excluding escrow here because we're interested in their transferable amount
3689         // and escrowed SNX are not transferable.
3690         uint balance = tokenState.balanceOf(account);
3691 
3692         // How many of those will be locked by the amount they've issued?
3693         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3694         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3695         // The locked synthetix value can exceed their balance.
3696         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3697 
3698         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3699         if (lockedSynthetixValue >= balance) {
3700             return 0;
3701         } else {
3702             return balance.sub(lockedSynthetixValue);
3703         }
3704     }
3705 
3706     /**
3707      * @notice Mints the inflationary SNX supply. The inflation shedule is
3708      * defined in the SupplySchedule contract.
3709      * The mint() function is publicly callable by anyone. The caller will
3710      receive a minter reward as specified in supplySchedule.minterReward().
3711      */
3712     function mint()
3713         external
3714         returns (bool)
3715     {
3716         require(rewardsDistribution != address(0), "RewardsDistribution not set");
3717 
3718         uint supplyToMint = supplySchedule.mintableSupply();
3719         require(supplyToMint > 0, "No supply is mintable");
3720 
3721         // record minting event before mutation to token supply
3722         supplySchedule.recordMintEvent(supplyToMint);
3723 
3724         // Set minted SNX balance to RewardEscrow's balance
3725         // Minus the minterReward and set balance of minter to add reward
3726         uint minterReward = supplySchedule.minterReward();
3727         // Get the remainder
3728         uint amountToDistribute = supplyToMint.sub(minterReward);
3729 
3730         // Set the token balance to the RewardsDistribution contract
3731         tokenState.setBalanceOf(rewardsDistribution, tokenState.balanceOf(rewardsDistribution).add(amountToDistribute));
3732         emitTransfer(this, rewardsDistribution, amountToDistribute);
3733 
3734         // Kick off the distribution of rewards
3735         rewardsDistribution.distributeRewards(amountToDistribute);
3736 
3737         // Assign the minters reward.
3738         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
3739         emitTransfer(this, msg.sender, minterReward);
3740 
3741         totalSupply = totalSupply.add(supplyToMint);
3742 
3743         return true;
3744     }
3745 
3746     // ========== MODIFIERS ==========
3747 
3748     modifier rateNotStale(bytes32 currencyKey) {
3749         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or not a synth");
3750         _;
3751     }
3752 
3753     modifier notFeeAddress(address account) {
3754         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3755         _;
3756     }
3757 
3758     modifier onlyOracle
3759     {
3760         require(msg.sender == exchangeRates.oracle(), "Only oracle allowed");
3761         _;
3762     }
3763 
3764     // ========== EVENTS ==========
3765     /* solium-disable */
3766     event SynthExchange(address indexed account, bytes32 fromCurrencyKey, uint256 fromAmount, bytes32 toCurrencyKey,  uint256 toAmount, address toAddress);
3767     bytes32 constant SYNTHEXCHANGE_SIG = keccak256("SynthExchange(address,bytes32,uint256,bytes32,uint256,address)");
3768     function emitSynthExchange(address account, bytes32 fromCurrencyKey, uint256 fromAmount, bytes32 toCurrencyKey, uint256 toAmount, address toAddress) internal {
3769         proxy._emit(abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress), 2, SYNTHEXCHANGE_SIG, bytes32(account), 0, 0);
3770     }
3771     /* solium-enable */
3772 }