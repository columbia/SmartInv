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
418 /*
419 -----------------------------------------------------------------
420 FILE INFORMATION
421 -----------------------------------------------------------------
422 
423 file:       SelfDestructible.sol
424 version:    1.2
425 author:     Anton Jurisevic
426 
427 date:       2018-05-29
428 
429 -----------------------------------------------------------------
430 MODULE DESCRIPTION
431 -----------------------------------------------------------------
432 
433 This contract allows an inheriting contract to be destroyed after
434 its owner indicates an intention and then waits for a period
435 without changing their mind. All ether contained in the contract
436 is forwarded to a nominated beneficiary upon destruction.
437 
438 -----------------------------------------------------------------
439 */
440 
441 
442 /**
443  * @title A contract that can be destroyed by its owner after a delay elapses.
444  */
445 contract SelfDestructible is Owned {
446     
447     uint public initiationTime;
448     bool public selfDestructInitiated;
449     address public selfDestructBeneficiary;
450     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
451 
452     /**
453      * @dev Constructor
454      * @param _owner The account which controls this contract.
455      */
456     constructor(address _owner)
457         Owned(_owner)
458         public
459     {
460         require(_owner != address(0), "Owner must not be the zero address");
461         selfDestructBeneficiary = _owner;
462         emit SelfDestructBeneficiaryUpdated(_owner);
463     }
464 
465     /**
466      * @notice Set the beneficiary address of this contract.
467      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
468      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
469      */
470     function setSelfDestructBeneficiary(address _beneficiary)
471         external
472         onlyOwner
473     {
474         require(_beneficiary != address(0), "Beneficiary must not be the zero address");
475         selfDestructBeneficiary = _beneficiary;
476         emit SelfDestructBeneficiaryUpdated(_beneficiary);
477     }
478 
479     /**
480      * @notice Begin the self-destruction counter of this contract.
481      * Once the delay has elapsed, the contract may be self-destructed.
482      * @dev Only the contract owner may call this.
483      */
484     function initiateSelfDestruct()
485         external
486         onlyOwner
487     {
488         initiationTime = now;
489         selfDestructInitiated = true;
490         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
491     }
492 
493     /**
494      * @notice Terminate and reset the self-destruction timer.
495      * @dev Only the contract owner may call this.
496      */
497     function terminateSelfDestruct()
498         external
499         onlyOwner
500     {
501         initiationTime = 0;
502         selfDestructInitiated = false;
503         emit SelfDestructTerminated();
504     }
505 
506     /**
507      * @notice If the self-destruction delay has elapsed, destroy this contract and
508      * remit any ether it owns to the beneficiary address.
509      * @dev Only the contract owner may call this.
510      */
511     function selfDestruct()
512         external
513         onlyOwner
514     {
515         require(selfDestructInitiated, "Self destruct has not yet been initiated");
516         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay has not yet elapsed");
517         address beneficiary = selfDestructBeneficiary;
518         emit SelfDestructed(beneficiary);
519         selfdestruct(beneficiary);
520     }
521 
522     event SelfDestructTerminated();
523     event SelfDestructed(address beneficiary);
524     event SelfDestructInitiated(uint selfDestructDelay);
525     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
526 }
527 
528 
529 /*
530 -----------------------------------------------------------------
531 FILE INFORMATION
532 -----------------------------------------------------------------
533 
534 file:       State.sol
535 version:    1.1
536 author:     Dominic Romanowski
537             Anton Jurisevic
538 
539 date:       2018-05-15
540 
541 -----------------------------------------------------------------
542 MODULE DESCRIPTION
543 -----------------------------------------------------------------
544 
545 This contract is used side by side with external state token
546 contracts, such as Synthetix and Synth.
547 It provides an easy way to upgrade contract logic while
548 maintaining all user balances and allowances. This is designed
549 to make the changeover as easy as possible, since mappings
550 are not so cheap or straightforward to migrate.
551 
552 The first deployed contract would create this state contract,
553 using it as its store of balances.
554 When a new contract is deployed, it links to the existing
555 state contract, whose owner would then change its associated
556 contract to the new one.
557 
558 -----------------------------------------------------------------
559 */
560 
561 
562 contract State is Owned {
563     // the address of the contract that can modify variables
564     // this can only be changed by the owner of this contract
565     address public associatedContract;
566 
567 
568     constructor(address _owner, address _associatedContract)
569         Owned(_owner)
570         public
571     {
572         associatedContract = _associatedContract;
573         emit AssociatedContractUpdated(_associatedContract);
574     }
575 
576     /* ========== SETTERS ========== */
577 
578     // Change the associated contract to a new address
579     function setAssociatedContract(address _associatedContract)
580         external
581         onlyOwner
582     {
583         associatedContract = _associatedContract;
584         emit AssociatedContractUpdated(_associatedContract);
585     }
586 
587     /* ========== MODIFIERS ========== */
588 
589     modifier onlyAssociatedContract
590     {
591         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
592         _;
593     }
594 
595     /* ========== EVENTS ========== */
596 
597     event AssociatedContractUpdated(address associatedContract);
598 }
599 
600 
601 /*
602 -----------------------------------------------------------------
603 FILE INFORMATION
604 -----------------------------------------------------------------
605 
606 file:       TokenState.sol
607 version:    1.1
608 author:     Dominic Romanowski
609             Anton Jurisevic
610 
611 date:       2018-05-15
612 
613 -----------------------------------------------------------------
614 MODULE DESCRIPTION
615 -----------------------------------------------------------------
616 
617 A contract that holds the state of an ERC20 compliant token.
618 
619 This contract is used side by side with external state token
620 contracts, such as Synthetix and Synth.
621 It provides an easy way to upgrade contract logic while
622 maintaining all user balances and allowances. This is designed
623 to make the changeover as easy as possible, since mappings
624 are not so cheap or straightforward to migrate.
625 
626 The first deployed contract would create this state contract,
627 using it as its store of balances.
628 When a new contract is deployed, it links to the existing
629 state contract, whose owner would then change its associated
630 contract to the new one.
631 
632 -----------------------------------------------------------------
633 */
634 
635 
636 /**
637  * @title ERC20 Token State
638  * @notice Stores balance information of an ERC20 token contract.
639  */
640 contract TokenState is State {
641 
642     /* ERC20 fields. */
643     mapping(address => uint) public balanceOf;
644     mapping(address => mapping(address => uint)) public allowance;
645 
646     /**
647      * @dev Constructor
648      * @param _owner The address which controls this contract.
649      * @param _associatedContract The ERC20 contract whose state this composes.
650      */
651     constructor(address _owner, address _associatedContract)
652         State(_owner, _associatedContract)
653         public
654     {}
655 
656     /* ========== SETTERS ========== */
657 
658     /**
659      * @notice Set ERC20 allowance.
660      * @dev Only the associated contract may call this.
661      * @param tokenOwner The authorising party.
662      * @param spender The authorised party.
663      * @param value The total value the authorised party may spend on the
664      * authorising party's behalf.
665      */
666     function setAllowance(address tokenOwner, address spender, uint value)
667         external
668         onlyAssociatedContract
669     {
670         allowance[tokenOwner][spender] = value;
671     }
672 
673     /**
674      * @notice Set the balance in a given account
675      * @dev Only the associated contract may call this.
676      * @param account The account whose value to set.
677      * @param value The new balance of the given account.
678      */
679     function setBalanceOf(address account, uint value)
680         external
681         onlyAssociatedContract
682     {
683         balanceOf[account] = value;
684     }
685 }
686 
687 
688 /*
689 -----------------------------------------------------------------
690 FILE INFORMATION
691 -----------------------------------------------------------------
692 
693 file:       Proxy.sol
694 version:    1.3
695 author:     Anton Jurisevic
696 
697 date:       2018-05-29
698 
699 -----------------------------------------------------------------
700 MODULE DESCRIPTION
701 -----------------------------------------------------------------
702 
703 A proxy contract that, if it does not recognise the function
704 being called on it, passes all value and call data to an
705 underlying target contract.
706 
707 This proxy has the capacity to toggle between DELEGATECALL
708 and CALL style proxy functionality.
709 
710 The former executes in the proxy's context, and so will preserve 
711 msg.sender and store data at the proxy address. The latter will not.
712 Therefore, any contract the proxy wraps in the CALL style must
713 implement the Proxyable interface, in order that it can pass msg.sender
714 into the underlying contract as the state parameter, messageSender.
715 
716 -----------------------------------------------------------------
717 */
718 
719 
720 contract Proxy is Owned {
721 
722     Proxyable public target;
723     bool public useDELEGATECALL;
724 
725     constructor(address _owner)
726         Owned(_owner)
727         public
728     {}
729 
730     function setTarget(Proxyable _target)
731         external
732         onlyOwner
733     {
734         target = _target;
735         emit TargetUpdated(_target);
736     }
737 
738     function setUseDELEGATECALL(bool value) 
739         external
740         onlyOwner
741     {
742         useDELEGATECALL = value;
743     }
744 
745     function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)
746         external
747         onlyTarget
748     {
749         uint size = callData.length;
750         bytes memory _callData = callData;
751 
752         assembly {
753             /* The first 32 bytes of callData contain its length (as specified by the abi). 
754              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
755              * in length. It is also leftpadded to be a multiple of 32 bytes.
756              * This means moving call_data across 32 bytes guarantees we correctly access
757              * the data itself. */
758             switch numTopics
759             case 0 {
760                 log0(add(_callData, 32), size)
761             } 
762             case 1 {
763                 log1(add(_callData, 32), size, topic1)
764             }
765             case 2 {
766                 log2(add(_callData, 32), size, topic1, topic2)
767             }
768             case 3 {
769                 log3(add(_callData, 32), size, topic1, topic2, topic3)
770             }
771             case 4 {
772                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
773             }
774         }
775     }
776 
777     function()
778         external
779         payable
780     {
781         if (useDELEGATECALL) {
782             assembly {
783                 /* Copy call data into free memory region. */
784                 let free_ptr := mload(0x40)
785                 calldatacopy(free_ptr, 0, calldatasize)
786 
787                 /* Forward all gas and call data to the target contract. */
788                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
789                 returndatacopy(free_ptr, 0, returndatasize)
790 
791                 /* Revert if the call failed, otherwise return the result. */
792                 if iszero(result) { revert(free_ptr, returndatasize) }
793                 return(free_ptr, returndatasize)
794             }
795         } else {
796             /* Here we are as above, but must send the messageSender explicitly 
797              * since we are using CALL rather than DELEGATECALL. */
798             target.setMessageSender(msg.sender);
799             assembly {
800                 let free_ptr := mload(0x40)
801                 calldatacopy(free_ptr, 0, calldatasize)
802 
803                 /* We must explicitly forward ether to the underlying contract as well. */
804                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
805                 returndatacopy(free_ptr, 0, returndatasize)
806 
807                 if iszero(result) { revert(free_ptr, returndatasize) }
808                 return(free_ptr, returndatasize)
809             }
810         }
811     }
812 
813     modifier onlyTarget {
814         require(Proxyable(msg.sender) == target, "Must be proxy target");
815         _;
816     }
817 
818     event TargetUpdated(Proxyable newTarget);
819 }
820 
821 
822 /*
823 -----------------------------------------------------------------
824 FILE INFORMATION
825 -----------------------------------------------------------------
826 
827 file:       Proxyable.sol
828 version:    1.1
829 author:     Anton Jurisevic
830 
831 date:       2018-05-15
832 
833 checked:    Mike Spain
834 approved:   Samuel Brooks
835 
836 -----------------------------------------------------------------
837 MODULE DESCRIPTION
838 -----------------------------------------------------------------
839 
840 A proxyable contract that works hand in hand with the Proxy contract
841 to allow for anyone to interact with the underlying contract both
842 directly and through the proxy.
843 
844 -----------------------------------------------------------------
845 */
846 
847 
848 // This contract should be treated like an abstract contract
849 contract Proxyable is Owned {
850     /* The proxy this contract exists behind. */
851     Proxy public proxy;
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
874     function setMessageSender(address sender)
875         external
876         onlyProxy
877     {
878         messageSender = sender;
879     }
880 
881     modifier onlyProxy {
882         require(Proxy(msg.sender) == proxy, "Only the proxy can call this function");
883         _;
884     }
885 
886     modifier optionalProxy
887     {
888         if (Proxy(msg.sender) != proxy) {
889             messageSender = msg.sender;
890         }
891         _;
892     }
893 
894     modifier optionalProxy_onlyOwner
895     {
896         if (Proxy(msg.sender) != proxy) {
897             messageSender = msg.sender;
898         }
899         require(messageSender == owner, "This action can only be performed by the owner");
900         _;
901     }
902 
903     event ProxyUpdated(address proxyAddress);
904 }
905 
906 
907 /*
908 -----------------------------------------------------------------
909 FILE INFORMATION
910 -----------------------------------------------------------------
911 
912 file:       ExternStateToken.sol
913 version:    1.0
914 author:     Kevin Brown
915 date:       2018-08-06
916 
917 -----------------------------------------------------------------
918 MODULE DESCRIPTION
919 -----------------------------------------------------------------
920 
921 This contract offers a modifer that can prevent reentrancy on
922 particular actions. It will not work if you put it on multiple
923 functions that can be called from each other. Specifically guard
924 external entry points to the contract with the modifier only.
925 
926 -----------------------------------------------------------------
927 */
928 
929 
930 contract ReentrancyPreventer {
931     /* ========== MODIFIERS ========== */
932     bool isInFunctionBody = false;
933 
934     modifier preventReentrancy {
935         require(!isInFunctionBody, "Reverted to prevent reentrancy");
936         isInFunctionBody = true;
937         _;
938         isInFunctionBody = false;
939     }
940 }
941 
942 /*
943 -----------------------------------------------------------------
944 FILE INFORMATION
945 -----------------------------------------------------------------
946 
947 file:       TokenFallback.sol
948 version:    1.0
949 author:     Kevin Brown
950 date:       2018-08-10
951 
952 -----------------------------------------------------------------
953 MODULE DESCRIPTION
954 -----------------------------------------------------------------
955 
956 This contract provides the logic that's used to call tokenFallback()
957 when transfers happen.
958 
959 It's pulled out into its own module because it's needed in two
960 places, so instead of copy/pasting this logic and maininting it
961 both in Fee Token and Extern State Token, it's here and depended
962 on by both contracts.
963 
964 -----------------------------------------------------------------
965 */
966 
967 
968 contract TokenFallbackCaller is ReentrancyPreventer {
969     function callTokenFallbackIfNeeded(address sender, address recipient, uint amount, bytes data)
970         internal
971         preventReentrancy
972     {
973         /*
974             If we're transferring to a contract and it implements the tokenFallback function, call it.
975             This isn't ERC223 compliant because we don't revert if the contract doesn't implement tokenFallback.
976             This is because many DEXes and other contracts that expect to work with the standard
977             approve / transferFrom workflow don't implement tokenFallback but can still process our tokens as
978             usual, so it feels very harsh and likely to cause trouble if we add this restriction after having
979             previously gone live with a vanilla ERC20.
980         */
981 
982         // Is the to address a contract? We can check the code size on that address and know.
983         uint length;
984 
985         // solium-disable-next-line security/no-inline-assembly
986         assembly {
987             // Retrieve the size of the code on the recipient address
988             length := extcodesize(recipient)
989         }
990 
991         // If there's code there, it's a contract
992         if (length > 0) {
993             // Now we need to optionally call tokenFallback(address from, uint value).
994             // We can't call it the normal way because that reverts when the recipient doesn't implement the function.
995 
996             // solium-disable-next-line security/no-low-level-calls
997             recipient.call(abi.encodeWithSignature("tokenFallback(address,uint256,bytes)", sender, amount, data));
998 
999             // And yes, we specifically don't care if this call fails, so we're not checking the return value.
1000         }
1001     }
1002 }
1003 
1004 
1005 /*
1006 -----------------------------------------------------------------
1007 FILE INFORMATION
1008 -----------------------------------------------------------------
1009 
1010 file:       ExternStateToken.sol
1011 version:    1.3
1012 author:     Anton Jurisevic
1013             Dominic Romanowski
1014             Kevin Brown
1015 
1016 date:       2018-05-29
1017 
1018 -----------------------------------------------------------------
1019 MODULE DESCRIPTION
1020 -----------------------------------------------------------------
1021 
1022 A partial ERC20 token contract, designed to operate with a proxy.
1023 To produce a complete ERC20 token, transfer and transferFrom
1024 tokens must be implemented, using the provided _byProxy internal
1025 functions.
1026 This contract utilises an external state for upgradeability.
1027 
1028 -----------------------------------------------------------------
1029 */
1030 
1031 
1032 /**
1033  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
1034  */
1035 contract ExternStateToken is SelfDestructible, Proxyable, TokenFallbackCaller {
1036 
1037     using SafeMath for uint;
1038     using SafeDecimalMath for uint;
1039 
1040     /* ========== STATE VARIABLES ========== */
1041 
1042     /* Stores balances and allowances. */
1043     TokenState public tokenState;
1044 
1045     /* Other ERC20 fields. */
1046     string public name;
1047     string public symbol;
1048     uint public totalSupply;
1049     uint8 public decimals;
1050 
1051     /**
1052      * @dev Constructor.
1053      * @param _proxy The proxy associated with this contract.
1054      * @param _name Token's ERC20 name.
1055      * @param _symbol Token's ERC20 symbol.
1056      * @param _totalSupply The total supply of the token.
1057      * @param _tokenState The TokenState contract address.
1058      * @param _owner The owner of this contract.
1059      */
1060     constructor(address _proxy, TokenState _tokenState,
1061                 string _name, string _symbol, uint _totalSupply,
1062                 uint8 _decimals, address _owner)
1063         SelfDestructible(_owner)
1064         Proxyable(_proxy, _owner)
1065         public
1066     {
1067         tokenState = _tokenState;
1068 
1069         name = _name;
1070         symbol = _symbol;
1071         totalSupply = _totalSupply;
1072         decimals = _decimals;
1073     }
1074 
1075     /* ========== VIEWS ========== */
1076 
1077     /**
1078      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
1079      * @param owner The party authorising spending of their funds.
1080      * @param spender The party spending tokenOwner's funds.
1081      */
1082     function allowance(address owner, address spender)
1083         public
1084         view
1085         returns (uint)
1086     {
1087         return tokenState.allowance(owner, spender);
1088     }
1089 
1090     /**
1091      * @notice Returns the ERC20 token balance of a given account.
1092      */
1093     function balanceOf(address account)
1094         public
1095         view
1096         returns (uint)
1097     {
1098         return tokenState.balanceOf(account);
1099     }
1100 
1101     /* ========== MUTATIVE FUNCTIONS ========== */
1102 
1103     /**
1104      * @notice Set the address of the TokenState contract.
1105      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
1106      * as balances would be unreachable.
1107      */ 
1108     function setTokenState(TokenState _tokenState)
1109         external
1110         optionalProxy_onlyOwner
1111     {
1112         tokenState = _tokenState;
1113         emitTokenStateUpdated(_tokenState);
1114     }
1115 
1116     function _internalTransfer(address from, address to, uint value, bytes data) 
1117         internal
1118         returns (bool)
1119     { 
1120         /* Disallow transfers to irretrievable-addresses. */
1121         require(to != address(0), "Cannot transfer to the 0 address");
1122         require(to != address(this), "Cannot transfer to the underlying contract");
1123         require(to != address(proxy), "Cannot transfer to the proxy contract");
1124 
1125         // Insufficient balance will be handled by the safe subtraction.
1126         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
1127         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
1128 
1129         // If the recipient is a contract, we need to call tokenFallback on it so they can do ERC223
1130         // actions when receiving our tokens. Unlike the standard, however, we don't revert if the
1131         // recipient contract doesn't implement tokenFallback.
1132         callTokenFallbackIfNeeded(from, to, value, data);
1133         
1134         // Emit a standard ERC20 transfer event
1135         emitTransfer(from, to, value);
1136 
1137         return true;
1138     }
1139 
1140     /**
1141      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
1142      * the onlyProxy or optionalProxy modifiers.
1143      */
1144     function _transfer_byProxy(address from, address to, uint value, bytes data)
1145         internal
1146         returns (bool)
1147     {
1148         return _internalTransfer(from, to, value, data);
1149     }
1150 
1151     /**
1152      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
1153      * possessing the optionalProxy or optionalProxy modifiers.
1154      */
1155     function _transferFrom_byProxy(address sender, address from, address to, uint value, bytes data)
1156         internal
1157         returns (bool)
1158     {
1159         /* Insufficient allowance will be handled by the safe subtraction. */
1160         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
1161         return _internalTransfer(from, to, value, data);
1162     }
1163 
1164     /**
1165      * @notice Approves spender to transfer on the message sender's behalf.
1166      */
1167     function approve(address spender, uint value)
1168         public
1169         optionalProxy
1170         returns (bool)
1171     {
1172         address sender = messageSender;
1173 
1174         tokenState.setAllowance(sender, spender, value);
1175         emitApproval(sender, spender, value);
1176         return true;
1177     }
1178 
1179     /* ========== EVENTS ========== */
1180 
1181     event Transfer(address indexed from, address indexed to, uint value);
1182     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
1183     function emitTransfer(address from, address to, uint value) internal {
1184         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
1185     }
1186 
1187     event Approval(address indexed owner, address indexed spender, uint value);
1188     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
1189     function emitApproval(address owner, address spender, uint value) internal {
1190         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
1191     }
1192 
1193     event TokenStateUpdated(address newTokenState);
1194     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
1195     function emitTokenStateUpdated(address newTokenState) internal {
1196         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
1197     }
1198 }
1199 
1200 
1201 /*
1202 -----------------------------------------------------------------
1203 FILE INFORMATION
1204 -----------------------------------------------------------------
1205 
1206 file:       ExchangeRates.sol
1207 version:    1.0
1208 author:     Kevin Brown
1209 date:       2018-09-12
1210 
1211 -----------------------------------------------------------------
1212 MODULE DESCRIPTION
1213 -----------------------------------------------------------------
1214 
1215 A contract that any other contract in the Synthetix system can query
1216 for the current market value of various assets, including
1217 crypto assets as well as various fiat assets.
1218 
1219 This contract assumes that rate updates will completely update
1220 all rates to their current values. If a rate shock happens
1221 on a single asset, the oracle will still push updated rates
1222 for all other assets.
1223 
1224 -----------------------------------------------------------------
1225 */
1226 
1227 
1228 /**
1229  * @title The repository for exchange rates
1230  */
1231 
1232 contract ExchangeRates is SelfDestructible {
1233 
1234 
1235     using SafeMath for uint;
1236     using SafeDecimalMath for uint;
1237 
1238     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
1239     mapping(bytes4 => uint) public rates;
1240 
1241     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
1242     mapping(bytes4 => uint) public lastRateUpdateTimes;
1243 
1244     // The address of the oracle which pushes rate updates to this contract
1245     address public oracle;
1246 
1247     // Do not allow the oracle to submit times any further forward into the future than this constant.
1248     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
1249 
1250     // How long will the contract assume the rate of any asset is correct
1251     uint public rateStalePeriod = 3 hours;
1252 
1253     // Each participating currency in the XDR basket is represented as a currency key with
1254     // equal weighting.
1255     // There are 5 participating currencies, so we'll declare that clearly.
1256     bytes4[5] public xdrParticipants;
1257 
1258     // For inverted prices, keep a mapping of their entry, limits and frozen status
1259     struct InversePricing {
1260         uint entryPoint;
1261         uint upperLimit;
1262         uint lowerLimit;
1263         bool frozen;
1264     }
1265     mapping(bytes4 => InversePricing) public inversePricing;
1266     bytes4[] public invertedKeys;
1267 
1268     //
1269     // ========== CONSTRUCTOR ==========
1270 
1271     /**
1272      * @dev Constructor
1273      * @param _owner The owner of this contract.
1274      * @param _oracle The address which is able to update rate information.
1275      * @param _currencyKeys The initial currency keys to store (in order).
1276      * @param _newRates The initial currency amounts for each currency (in order).
1277      */
1278     constructor(
1279         // SelfDestructible (Ownable)
1280         address _owner,
1281 
1282         // Oracle values - Allows for rate updates
1283         address _oracle,
1284         bytes4[] _currencyKeys,
1285         uint[] _newRates
1286     )
1287         /* Owned is initialised in SelfDestructible */
1288         SelfDestructible(_owner)
1289         public
1290     {
1291         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
1292 
1293         oracle = _oracle;
1294 
1295         // The sUSD rate is always 1 and is never stale.
1296         rates["sUSD"] = SafeDecimalMath.unit();
1297         lastRateUpdateTimes["sUSD"] = now;
1298 
1299         // These are the currencies that make up the XDR basket.
1300         // These are hard coded because:
1301         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
1302         //  - Adding new currencies would likely introduce some kind of weighting factor, which
1303         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
1304         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
1305         //    then point the system at the new version.
1306         xdrParticipants = [
1307             bytes4("sUSD"),
1308             bytes4("sAUD"),
1309             bytes4("sCHF"),
1310             bytes4("sEUR"),
1311             bytes4("sGBP")
1312         ];
1313 
1314         internalUpdateRates(_currencyKeys, _newRates, now);
1315     }
1316 
1317     /* ========== SETTERS ========== */
1318 
1319     /**
1320      * @notice Set the rates stored in this contract
1321      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1322      * @param newRates The rates for each currency (in order)
1323      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1324      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1325      *                 if it takes a long time for the transaction to confirm.
1326      */
1327     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
1328         external
1329         onlyOracle
1330         returns(bool)
1331     {
1332         return internalUpdateRates(currencyKeys, newRates, timeSent);
1333     }
1334 
1335     /**
1336      * @notice Internal function which sets the rates stored in this contract
1337      * @param currencyKeys The currency keys you wish to update the rates for (in order)
1338      * @param newRates The rates for each currency (in order)
1339      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
1340      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
1341      *                 if it takes a long time for the transaction to confirm.
1342      */
1343     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
1344         internal
1345         returns(bool)
1346     {
1347         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
1348         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
1349 
1350         // Loop through each key and perform update.
1351         for (uint i = 0; i < currencyKeys.length; i++) {
1352             // Should not set any rate to zero ever, as no asset will ever be
1353             // truely worthless and still valid. In this scenario, we should
1354             // delete the rate and remove it from the system.
1355             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
1356             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
1357 
1358             // We should only update the rate if it's at least the same age as the last rate we've got.
1359             if (timeSent < lastRateUpdateTimes[currencyKeys[i]]) {
1360                 continue;
1361             }
1362 
1363             newRates[i] = rateOrInverted(currencyKeys[i], newRates[i]);
1364 
1365             // Ok, go ahead with the update.
1366             rates[currencyKeys[i]] = newRates[i];
1367             lastRateUpdateTimes[currencyKeys[i]] = timeSent;
1368         }
1369 
1370         emit RatesUpdated(currencyKeys, newRates);
1371 
1372         // Now update our XDR rate.
1373         updateXDRRate(timeSent);
1374 
1375         return true;
1376     }
1377 
1378     /**
1379      * @notice Internal function to get the inverted rate, if any, and mark an inverted
1380      *  key as frozen if either limits are reached.
1381      * @param currencyKey The price key to lookup
1382      * @param rate The rate for the given price key
1383      */
1384     function rateOrInverted(bytes4 currencyKey, uint rate) internal returns (uint) {
1385         // if an inverse mapping exists, adjust the price accordingly
1386         InversePricing storage inverse = inversePricing[currencyKey];
1387         if (inverse.entryPoint <= 0) {
1388             return rate;
1389         }
1390 
1391         // set the rate to the current rate initially (if it's frozen, this is what will be returned)
1392         uint newInverseRate = rates[currencyKey];
1393 
1394         // get the new inverted rate if not frozen
1395         if (!inverse.frozen) {
1396             uint doubleEntryPoint = inverse.entryPoint.mul(2);
1397             if (doubleEntryPoint <= rate) {
1398                 // avoid negative numbers for unsigned ints, so set this to 0
1399                 // which by the requirement that lowerLimit be > 0 will
1400                 // cause this to freeze the price to the lowerLimit
1401                 newInverseRate = 0;
1402             } else {
1403                 newInverseRate = doubleEntryPoint.sub(rate);
1404             }
1405 
1406             // now if new rate hits our limits, set it to the limit and freeze
1407             if (newInverseRate >= inverse.upperLimit) {
1408                 newInverseRate = inverse.upperLimit;
1409             } else if (newInverseRate <= inverse.lowerLimit) {
1410                 newInverseRate = inverse.lowerLimit;
1411             }
1412 
1413             if (newInverseRate == inverse.upperLimit || newInverseRate == inverse.lowerLimit) {
1414                 inverse.frozen = true;
1415                 emit InversePriceFrozen(currencyKey);
1416             }
1417         }
1418 
1419         return newInverseRate;
1420     }
1421 
1422     /**
1423      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
1424      */
1425     function updateXDRRate(uint timeSent)
1426         internal
1427     {
1428         uint total = 0;
1429 
1430         for (uint i = 0; i < xdrParticipants.length; i++) {
1431             total = rates[xdrParticipants[i]].add(total);
1432         }
1433 
1434         // Set the rate
1435         rates["XDR"] = total;
1436 
1437         // Record that we updated the XDR rate.
1438         lastRateUpdateTimes["XDR"] = timeSent;
1439 
1440         // Emit our updated event separate to the others to save
1441         // moving data around between arrays.
1442         bytes4[] memory eventCurrencyCode = new bytes4[](1);
1443         eventCurrencyCode[0] = "XDR";
1444 
1445         uint[] memory eventRate = new uint[](1);
1446         eventRate[0] = rates["XDR"];
1447 
1448         emit RatesUpdated(eventCurrencyCode, eventRate);
1449     }
1450 
1451     /**
1452      * @notice Delete a rate stored in the contract
1453      * @param currencyKey The currency key you wish to delete the rate for
1454      */
1455     function deleteRate(bytes4 currencyKey)
1456         external
1457         onlyOracle
1458     {
1459         require(rates[currencyKey] > 0, "Rate is zero");
1460 
1461         delete rates[currencyKey];
1462         delete lastRateUpdateTimes[currencyKey];
1463 
1464         emit RateDeleted(currencyKey);
1465     }
1466 
1467     /**
1468      * @notice Set the Oracle that pushes the rate information to this contract
1469      * @param _oracle The new oracle address
1470      */
1471     function setOracle(address _oracle)
1472         external
1473         onlyOwner
1474     {
1475         oracle = _oracle;
1476         emit OracleUpdated(oracle);
1477     }
1478 
1479     /**
1480      * @notice Set the stale period on the updated rate variables
1481      * @param _time The new rateStalePeriod
1482      */
1483     function setRateStalePeriod(uint _time)
1484         external
1485         onlyOwner
1486     {
1487         rateStalePeriod = _time;
1488         emit RateStalePeriodUpdated(rateStalePeriod);
1489     }
1490 
1491     /**
1492      * @notice Set an inverse price up for the currency key
1493      * @param currencyKey The currency to update
1494      * @param entryPoint The entry price point of the inverted price
1495      * @param upperLimit The upper limit, at or above which the price will be frozen
1496      * @param lowerLimit The lower limit, at or below which the price will be frozen
1497      */
1498     function setInversePricing(bytes4 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit)
1499         external onlyOwner
1500     {
1501         require(entryPoint > 0, "entryPoint must be above 0");
1502         require(lowerLimit > 0, "lowerLimit must be above 0");
1503         require(upperLimit > entryPoint, "upperLimit must be above the entryPoint");
1504         require(upperLimit < entryPoint.mul(2), "upperLimit must be less than double entryPoint");
1505         require(lowerLimit < entryPoint, "lowerLimit must be below the entryPoint");
1506 
1507         if (inversePricing[currencyKey].entryPoint <= 0) {
1508             // then we are adding a new inverse pricing, so add this
1509             invertedKeys.push(currencyKey);
1510         }
1511         inversePricing[currencyKey].entryPoint = entryPoint;
1512         inversePricing[currencyKey].upperLimit = upperLimit;
1513         inversePricing[currencyKey].lowerLimit = lowerLimit;
1514         inversePricing[currencyKey].frozen = false;
1515 
1516         emit InversePriceConfigured(currencyKey, entryPoint, upperLimit, lowerLimit);
1517     }
1518 
1519     /**
1520      * @notice Remove an inverse price for the currency key
1521      * @param currencyKey The currency to remove inverse pricing for
1522      */
1523     function removeInversePricing(bytes4 currencyKey) external onlyOwner {
1524         inversePricing[currencyKey].entryPoint = 0;
1525         inversePricing[currencyKey].upperLimit = 0;
1526         inversePricing[currencyKey].lowerLimit = 0;
1527         inversePricing[currencyKey].frozen = false;
1528 
1529         // now remove inverted key from array
1530         for (uint8 i = 0; i < invertedKeys.length; i++) {
1531             if (invertedKeys[i] == currencyKey) {
1532                 delete invertedKeys[i];
1533 
1534                 // Copy the last key into the place of the one we just deleted
1535                 // If there's only one key, this is array[0] = array[0].
1536                 // If we're deleting the last one, it's also a NOOP in the same way.
1537                 invertedKeys[i] = invertedKeys[invertedKeys.length - 1];
1538 
1539                 // Decrease the size of the array by one.
1540                 invertedKeys.length--;
1541 
1542                 break;
1543             }
1544         }
1545 
1546         emit InversePriceConfigured(currencyKey, 0, 0, 0);
1547     }
1548     /* ========== VIEWS ========== */
1549 
1550     /**
1551      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
1552      * @param sourceCurrencyKey The currency the amount is specified in
1553      * @param sourceAmount The source amount, specified in UNIT base
1554      * @param destinationCurrencyKey The destination currency
1555      */
1556     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
1557         public
1558         view
1559         rateNotStale(sourceCurrencyKey)
1560         rateNotStale(destinationCurrencyKey)
1561         returns (uint)
1562     {
1563         // If there's no change in the currency, then just return the amount they gave us
1564         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
1565 
1566         // Calculate the effective value by going from source -> USD -> destination
1567         return sourceAmount.multiplyDecimalRound(rateForCurrency(sourceCurrencyKey))
1568             .divideDecimalRound(rateForCurrency(destinationCurrencyKey));
1569     }
1570 
1571     /**
1572      * @notice Retrieve the rate for a specific currency
1573      */
1574     function rateForCurrency(bytes4 currencyKey)
1575         public
1576         view
1577         returns (uint)
1578     {
1579         return rates[currencyKey];
1580     }
1581 
1582     /**
1583      * @notice Retrieve the rates for a list of currencies
1584      */
1585     function ratesForCurrencies(bytes4[] currencyKeys)
1586         public
1587         view
1588         returns (uint[])
1589     {
1590         uint[] memory _rates = new uint[](currencyKeys.length);
1591 
1592         for (uint8 i = 0; i < currencyKeys.length; i++) {
1593             _rates[i] = rates[currencyKeys[i]];
1594         }
1595 
1596         return _rates;
1597     }
1598 
1599     /**
1600      * @notice Retrieve a list of last update times for specific currencies
1601      */
1602     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
1603         public
1604         view
1605         returns (uint)
1606     {
1607         return lastRateUpdateTimes[currencyKey];
1608     }
1609 
1610     /**
1611      * @notice Retrieve the last update time for a specific currency
1612      */
1613     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
1614         public
1615         view
1616         returns (uint[])
1617     {
1618         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
1619 
1620         for (uint8 i = 0; i < currencyKeys.length; i++) {
1621             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
1622         }
1623 
1624         return lastUpdateTimes;
1625     }
1626 
1627     /**
1628      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
1629      */
1630     function rateIsStale(bytes4 currencyKey)
1631         public
1632         view
1633         returns (bool)
1634     {
1635         // sUSD is a special case and is never stale.
1636         if (currencyKey == "sUSD") return false;
1637 
1638         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
1639     }
1640 
1641     /**
1642      * @notice Check if any rate is frozen (cannot be exchanged into)
1643      */
1644     function rateIsFrozen(bytes4 currencyKey)
1645         external
1646         view
1647         returns (bool)
1648     {
1649         return inversePricing[currencyKey].frozen;
1650     }
1651 
1652 
1653     /**
1654      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
1655      */
1656     function anyRateIsStale(bytes4[] currencyKeys)
1657         external
1658         view
1659         returns (bool)
1660     {
1661         // Loop through each key and check whether the data point is stale.
1662         uint256 i = 0;
1663 
1664         while (i < currencyKeys.length) {
1665             // sUSD is a special case and is never false
1666             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
1667                 return true;
1668             }
1669             i += 1;
1670         }
1671 
1672         return false;
1673     }
1674 
1675     /* ========== MODIFIERS ========== */
1676 
1677     modifier rateNotStale(bytes4 currencyKey) {
1678         require(!rateIsStale(currencyKey), "Rate stale or nonexistant currency");
1679         _;
1680     }
1681 
1682     modifier onlyOracle
1683     {
1684         require(msg.sender == oracle, "Only the oracle can perform this action");
1685         _;
1686     }
1687 
1688     /* ========== EVENTS ========== */
1689 
1690     event OracleUpdated(address newOracle);
1691     event RateStalePeriodUpdated(uint rateStalePeriod);
1692     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
1693     event RateDeleted(bytes4 currencyKey);
1694     event InversePriceConfigured(bytes4 currencyKey, uint entryPoint, uint upperLimit, uint lowerLimit);
1695     event InversePriceFrozen(bytes4 currencyKey);
1696 }
1697 
1698 
1699 /*
1700 -----------------------------------------------------------------
1701 FILE INFORMATION
1702 -----------------------------------------------------------------
1703 
1704 file:       LimitedSetup.sol
1705 version:    1.1
1706 author:     Anton Jurisevic
1707 
1708 date:       2018-05-15
1709 
1710 -----------------------------------------------------------------
1711 MODULE DESCRIPTION
1712 -----------------------------------------------------------------
1713 
1714 A contract with a limited setup period. Any function modified
1715 with the setup modifier will cease to work after the
1716 conclusion of the configurable-length post-construction setup period.
1717 
1718 -----------------------------------------------------------------
1719 */
1720 
1721 
1722 /**
1723  * @title Any function decorated with the modifier this contract provides
1724  * deactivates after a specified setup period.
1725  */
1726 contract LimitedSetup {
1727 
1728     uint setupExpiryTime;
1729 
1730     /**
1731      * @dev LimitedSetup Constructor.
1732      * @param setupDuration The time the setup period will last for.
1733      */
1734     constructor(uint setupDuration)
1735         public
1736     {
1737         setupExpiryTime = now + setupDuration;
1738     }
1739 
1740     modifier onlyDuringSetup
1741     {
1742         require(now < setupExpiryTime, "Can only perform this action during setup");
1743         _;
1744     }
1745 }
1746 
1747 
1748 contract ISynthetixState {
1749     // A struct for handing values associated with an individual user's debt position
1750     struct IssuanceData {
1751         // Percentage of the total debt owned at the time
1752         // of issuance. This number is modified by the global debt
1753         // delta array. You can figure out a user's exit price and
1754         // collateralisation ratio using a combination of their initial
1755         // debt and the slice of global debt delta which applies to them.
1756         uint initialDebtOwnership;
1757         // This lets us know when (in relative terms) the user entered
1758         // the debt pool so we can calculate their exit price and
1759         // collateralistion ratio
1760         uint debtEntryIndex;
1761     }
1762 
1763     uint[] public debtLedger;
1764     uint public issuanceRatio;
1765     mapping(address => IssuanceData) public issuanceData;
1766 
1767     function debtLedgerLength() external view returns (uint);
1768     function hasIssued(address account) external view returns (bool);
1769     function incrementTotalIssuerCount() external;
1770     function decrementTotalIssuerCount() external;
1771     function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
1772     function lastDebtLedgerEntry() external view returns (uint);
1773     function appendDebtLedgerValue(uint value) external;
1774     function clearIssuanceData(address account) external;
1775 }
1776 
1777 
1778 /*
1779 -----------------------------------------------------------------
1780 FILE INFORMATION
1781 -----------------------------------------------------------------
1782 
1783 file:       SynthetixState.sol
1784 version:    1.0
1785 author:     Kevin Brown
1786 date:       2018-10-19
1787 
1788 -----------------------------------------------------------------
1789 MODULE DESCRIPTION
1790 -----------------------------------------------------------------
1791 
1792 A contract that holds issuance state and preferred currency of
1793 users in the Synthetix system.
1794 
1795 This contract is used side by side with the Synthetix contract
1796 to make it easier to upgrade the contract logic while maintaining
1797 issuance state.
1798 
1799 The Synthetix contract is also quite large and on the edge of
1800 being beyond the contract size limit without moving this information
1801 out to another contract.
1802 
1803 The first deployed contract would create this state contract,
1804 using it as its store of issuance data.
1805 
1806 When a new contract is deployed, it links to the existing
1807 state contract, whose owner would then change its associated
1808 contract to the new one.
1809 
1810 -----------------------------------------------------------------
1811 */
1812 
1813 
1814 /**\
1815  * @title Synthetix State
1816  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
1817  */
1818 contract SynthetixState is ISynthetixState, State, LimitedSetup {
1819 
1820 
1821     using SafeMath for uint;
1822     using SafeDecimalMath for uint;
1823 
1824     // Issued synth balances for individual fee entitlements and exit price calculations
1825     mapping(address => IssuanceData) public issuanceData;
1826 
1827     // The total count of people that have outstanding issued synths in any flavour
1828     uint public totalIssuerCount;
1829 
1830     // Global debt pool tracking
1831     uint[] public debtLedger;
1832 
1833     // Import state
1834     uint public importedXDRAmount;
1835 
1836     // A quantity of synths greater than this ratio
1837     // may not be issued against a given value of SNX.
1838     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
1839     // No more synths may be issued than the value of SNX backing them.
1840     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
1841 
1842     // Users can specify their preferred currency, in which case all synths they receive
1843     // will automatically exchange to that preferred currency upon receipt in their wallet
1844     mapping(address => bytes4) public preferredCurrency;
1845 
1846     /**
1847      * @dev Constructor
1848      * @param _owner The address which controls this contract.
1849      * @param _associatedContract The ERC20 contract whose state this composes.
1850      */
1851     constructor(address _owner, address _associatedContract)
1852         State(_owner, _associatedContract)
1853         LimitedSetup(1 weeks)
1854         public
1855     {}
1856 
1857     /* ========== SETTERS ========== */
1858 
1859     /**
1860      * @notice Set issuance data for an address
1861      * @dev Only the associated contract may call this.
1862      * @param account The address to set the data for.
1863      * @param initialDebtOwnership The initial debt ownership for this address.
1864      */
1865     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
1866         external
1867         onlyAssociatedContract
1868     {
1869         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
1870         issuanceData[account].debtEntryIndex = debtLedger.length;
1871     }
1872 
1873     /**
1874      * @notice Clear issuance data for an address
1875      * @dev Only the associated contract may call this.
1876      * @param account The address to clear the data for.
1877      */
1878     function clearIssuanceData(address account)
1879         external
1880         onlyAssociatedContract
1881     {
1882         delete issuanceData[account];
1883     }
1884 
1885     /**
1886      * @notice Increment the total issuer count
1887      * @dev Only the associated contract may call this.
1888      */
1889     function incrementTotalIssuerCount()
1890         external
1891         onlyAssociatedContract
1892     {
1893         totalIssuerCount = totalIssuerCount.add(1);
1894     }
1895 
1896     /**
1897      * @notice Decrement the total issuer count
1898      * @dev Only the associated contract may call this.
1899      */
1900     function decrementTotalIssuerCount()
1901         external
1902         onlyAssociatedContract
1903     {
1904         totalIssuerCount = totalIssuerCount.sub(1);
1905     }
1906 
1907     /**
1908      * @notice Append a value to the debt ledger
1909      * @dev Only the associated contract may call this.
1910      * @param value The new value to be added to the debt ledger.
1911      */
1912     function appendDebtLedgerValue(uint value)
1913         external
1914         onlyAssociatedContract
1915     {
1916         debtLedger.push(value);
1917     }
1918 
1919     /**
1920      * @notice Set preferred currency for a user
1921      * @dev Only the associated contract may call this.
1922      * @param account The account to set the preferred currency for
1923      * @param currencyKey The new preferred currency
1924      */
1925     function setPreferredCurrency(address account, bytes4 currencyKey)
1926         external
1927         onlyAssociatedContract
1928     {
1929         preferredCurrency[account] = currencyKey;
1930     }
1931 
1932     /**
1933      * @notice Set the issuanceRatio for issuance calculations.
1934      * @dev Only callable by the contract owner.
1935      */
1936     function setIssuanceRatio(uint _issuanceRatio)
1937         external
1938         onlyOwner
1939     {
1940         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
1941         issuanceRatio = _issuanceRatio;
1942         emit IssuanceRatioUpdated(_issuanceRatio);
1943     }
1944 
1945     /**
1946      * @notice Import issuer data from the old Synthetix contract before multicurrency
1947      * @dev Only callable by the contract owner, and only for 1 week after deployment.
1948      */
1949     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
1950         external
1951         onlyOwner
1952         onlyDuringSetup
1953     {
1954         require(accounts.length == sUSDAmounts.length, "Length mismatch");
1955 
1956         for (uint8 i = 0; i < accounts.length; i++) {
1957             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
1958         }
1959     }
1960 
1961     /**
1962      * @notice Import issuer data from the old Synthetix contract before multicurrency
1963      * @dev Only used from importIssuerData above, meant to be disposable
1964      */
1965     function _addToDebtRegister(address account, uint amount)
1966         internal
1967     {
1968         // This code is duplicated from Synthetix so that we can call it directly here
1969         // during setup only.
1970         Synthetix synthetix = Synthetix(associatedContract);
1971 
1972         // What is the value of the requested debt in XDRs?
1973         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
1974 
1975         // What is the value that we've previously imported?
1976         uint totalDebtIssued = importedXDRAmount;
1977 
1978         // What will the new total be including the new value?
1979         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
1980 
1981         // Save that for the next import.
1982         importedXDRAmount = newTotalDebtIssued;
1983 
1984         // What is their percentage (as a high precision int) of the total debt?
1985         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
1986 
1987         // And what effect does this percentage have on the global debt holding of other issuers?
1988         // The delta specifically needs to not take into account any existing debt as it's already
1989         // accounted for in the delta from when they issued previously.
1990         // The delta is a high precision integer.
1991         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
1992 
1993         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
1994 
1995         // And what does their debt ownership look like including this previous stake?
1996         if (existingDebt > 0) {
1997             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
1998         }
1999 
2000         // Are they a new issuer? If so, record them.
2001         if (issuanceData[account].initialDebtOwnership == 0) {
2002             totalIssuerCount = totalIssuerCount.add(1);
2003         }
2004 
2005         // Save the debt entry parameters
2006         issuanceData[account].initialDebtOwnership = debtPercentage;
2007         issuanceData[account].debtEntryIndex = debtLedger.length;
2008 
2009         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2010         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2011         if (debtLedger.length > 0) {
2012             debtLedger.push(
2013                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2014             );
2015         } else {
2016             debtLedger.push(SafeDecimalMath.preciseUnit());
2017         }
2018     }
2019 
2020     /* ========== VIEWS ========== */
2021 
2022     /**
2023      * @notice Retrieve the length of the debt ledger array
2024      */
2025     function debtLedgerLength()
2026         external
2027         view
2028         returns (uint)
2029     {
2030         return debtLedger.length;
2031     }
2032 
2033     /**
2034      * @notice Retrieve the most recent entry from the debt ledger
2035      */
2036     function lastDebtLedgerEntry()
2037         external
2038         view
2039         returns (uint)
2040     {
2041         return debtLedger[debtLedger.length - 1];
2042     }
2043 
2044     /**
2045      * @notice Query whether an account has issued and has an outstanding debt balance
2046      * @param account The address to query for
2047      */
2048     function hasIssued(address account)
2049         external
2050         view
2051         returns (bool)
2052     {
2053         return issuanceData[account].initialDebtOwnership > 0;
2054     }
2055 
2056     event IssuanceRatioUpdated(uint newRatio);
2057 }
2058 
2059 
2060 contract IFeePool {
2061     address public FEE_ADDRESS;
2062     function amountReceivedFromExchange(uint value) external view returns (uint);
2063     function amountReceivedFromTransfer(uint value) external view returns (uint);
2064     function feePaid(bytes4 currencyKey, uint amount) external;
2065     function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
2066     function rewardsMinted(uint amount) external;
2067     function transferFeeIncurred(uint value) public view returns (uint);
2068 }
2069 
2070 
2071 /*
2072 -----------------------------------------------------------------
2073 FILE INFORMATION
2074 -----------------------------------------------------------------
2075 
2076 file:       Synth.sol
2077 version:    2.0
2078 author:     Kevin Brown
2079 date:       2018-09-13
2080 
2081 -----------------------------------------------------------------
2082 MODULE DESCRIPTION
2083 -----------------------------------------------------------------
2084 
2085 Synthetix-backed stablecoin contract.
2086 
2087 This contract issues synths, which are tokens that mirror various
2088 flavours of fiat currency.
2089 
2090 Synths are issuable by Synthetix Network Token (SNX) holders who
2091 have to lock up some value of their SNX to issue S * Cmax synths.
2092 Where Cmax issome value less than 1.
2093 
2094 A configurable fee is charged on synth transfers and deposited
2095 into a common pot, which Synthetix holders may withdraw from once
2096 per fee period.
2097 
2098 -----------------------------------------------------------------
2099 */
2100 
2101 
2102 contract Synth is ExternStateToken {
2103 
2104     /* ========== STATE VARIABLES ========== */
2105 
2106     IFeePool public feePool;
2107     Synthetix public synthetix;
2108 
2109     // Currency key which identifies this Synth to the Synthetix system
2110     bytes4 public currencyKey;
2111 
2112     uint8 constant DECIMALS = 18;
2113 
2114     /* ========== CONSTRUCTOR ========== */
2115 
2116     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, IFeePool _feePool,
2117         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey
2118     )
2119         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, 0, DECIMALS, _owner)
2120         public
2121     {
2122         require(_proxy != 0, "_proxy cannot be 0");
2123         require(address(_synthetix) != 0, "_synthetix cannot be 0");
2124         require(address(_feePool) != 0, "_feePool cannot be 0");
2125         require(_owner != 0, "_owner cannot be 0");
2126         require(_synthetix.synths(_currencyKey) == Synth(0), "Currency key is already in use");
2127 
2128         feePool = _feePool;
2129         synthetix = _synthetix;
2130         currencyKey = _currencyKey;
2131     }
2132 
2133     /* ========== SETTERS ========== */
2134 
2135     function setSynthetix(Synthetix _synthetix)
2136         external
2137         optionalProxy_onlyOwner
2138     {
2139         synthetix = _synthetix;
2140         emitSynthetixUpdated(_synthetix);
2141     }
2142 
2143     function setFeePool(IFeePool _feePool)
2144         external
2145         optionalProxy_onlyOwner
2146     {
2147         feePool = _feePool;
2148         emitFeePoolUpdated(_feePool);
2149     }
2150 
2151     /* ========== MUTATIVE FUNCTIONS ========== */
2152 
2153     /**
2154      * @notice Override ERC20 transfer function in order to
2155      * subtract the transaction fee and send it to the fee pool
2156      * for SNX holders to claim. */
2157     function transfer(address to, uint value)
2158         public
2159         optionalProxy
2160         notFeeAddress(messageSender)
2161         returns (bool)
2162     {
2163         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2164         uint fee = value.sub(amountReceived);
2165 
2166         // Send the fee off to the fee pool.
2167         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
2168 
2169         // And send their result off to the destination address
2170         bytes memory empty;
2171         return _internalTransfer(messageSender, to, amountReceived, empty);
2172     }
2173 
2174     /**
2175      * @notice Override ERC223 transfer function in order to
2176      * subtract the transaction fee and send it to the fee pool
2177      * for SNX holders to claim. */
2178     function transfer(address to, uint value, bytes data)
2179         public
2180         optionalProxy
2181         notFeeAddress(messageSender)
2182         returns (bool)
2183     {
2184         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2185         uint fee = value.sub(amountReceived);
2186 
2187         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2188         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
2189 
2190         // And send their result off to the destination address
2191         return _internalTransfer(messageSender, to, amountReceived, data);
2192     }
2193 
2194     /**
2195      * @notice Override ERC20 transferFrom function in order to
2196      * subtract the transaction fee and send it to the fee pool
2197      * for SNX holders to claim. */
2198     function transferFrom(address from, address to, uint value)
2199         public
2200         optionalProxy
2201         notFeeAddress(from)
2202         returns (bool)
2203     {
2204         // The fee is deducted from the amount sent.
2205         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2206         uint fee = value.sub(amountReceived);
2207 
2208         // Reduce the allowance by the amount we're transferring.
2209         // The safeSub call will handle an insufficient allowance.
2210         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
2211 
2212         // Send the fee off to the fee pool.
2213         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2214 
2215         bytes memory empty;
2216         return _internalTransfer(from, to, amountReceived, empty);
2217     }
2218 
2219     /**
2220      * @notice Override ERC223 transferFrom function in order to
2221      * subtract the transaction fee and send it to the fee pool
2222      * for SNX holders to claim. */
2223     function transferFrom(address from, address to, uint value, bytes data)
2224         public
2225         optionalProxy
2226         notFeeAddress(from)
2227         returns (bool)
2228     {
2229         // The fee is deducted from the amount sent.
2230         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2231         uint fee = value.sub(amountReceived);
2232 
2233         // Reduce the allowance by the amount we're transferring.
2234         // The safeSub call will handle an insufficient allowance.
2235         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
2236 
2237         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2238         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2239 
2240         return _internalTransfer(from, to, amountReceived, data);
2241     }
2242 
2243     /* Subtract the transfer fee from the senders account so the
2244      * receiver gets the exact amount specified to send. */
2245     function transferSenderPaysFee(address to, uint value)
2246         public
2247         optionalProxy
2248         notFeeAddress(messageSender)
2249         returns (bool)
2250     {
2251         uint fee = feePool.transferFeeIncurred(value);
2252 
2253         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2254         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
2255 
2256         // And send their transfer amount off to the destination address
2257         bytes memory empty;
2258         return _internalTransfer(messageSender, to, value, empty);
2259     }
2260 
2261     /* Subtract the transfer fee from the senders account so the
2262      * receiver gets the exact amount specified to send. */
2263     function transferSenderPaysFee(address to, uint value, bytes data)
2264         public
2265         optionalProxy
2266         notFeeAddress(messageSender)
2267         returns (bool)
2268     {
2269         uint fee = feePool.transferFeeIncurred(value);
2270 
2271         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2272         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
2273 
2274         // And send their transfer amount off to the destination address
2275         return _internalTransfer(messageSender, to, value, data);
2276     }
2277 
2278     /* Subtract the transfer fee from the senders account so the
2279      * to address receives the exact amount specified to send. */
2280     function transferFromSenderPaysFee(address from, address to, uint value)
2281         public
2282         optionalProxy
2283         notFeeAddress(from)
2284         returns (bool)
2285     {
2286         uint fee = feePool.transferFeeIncurred(value);
2287 
2288         // Reduce the allowance by the amount we're transferring.
2289         // The safeSub call will handle an insufficient allowance.
2290         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
2291 
2292         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2293         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2294 
2295         bytes memory empty;
2296         return _internalTransfer(from, to, value, empty);
2297     }
2298 
2299     /* Subtract the transfer fee from the senders account so the
2300      * to address receives the exact amount specified to send. */
2301     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
2302         public
2303         optionalProxy
2304         notFeeAddress(from)
2305         returns (bool)
2306     {
2307         uint fee = feePool.transferFeeIncurred(value);
2308 
2309         // Reduce the allowance by the amount we're transferring.
2310         // The safeSub call will handle an insufficient allowance.
2311         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
2312 
2313         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2314         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2315 
2316         return _internalTransfer(from, to, value, data);
2317     }
2318 
2319     // Override our internal transfer to inject preferred currency support
2320     function _internalTransfer(address from, address to, uint value, bytes data)
2321         internal
2322         returns (bool)
2323     {
2324         bytes4 preferredCurrencyKey = synthetix.synthetixState().preferredCurrency(to);
2325 
2326         // Do they have a preferred currency that's not us? If so we need to exchange
2327         if (preferredCurrencyKey != 0 && preferredCurrencyKey != currencyKey) {
2328             return synthetix.synthInitiatedExchange(from, currencyKey, value, preferredCurrencyKey, to);
2329         } else {
2330             // Otherwise we just transfer
2331             return super._internalTransfer(from, to, value, data);
2332         }
2333     }
2334 
2335     // Allow synthetix to issue a certain number of synths from an account.
2336     function issue(address account, uint amount)
2337         external
2338         onlySynthetixOrFeePool
2339     {
2340         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
2341         totalSupply = totalSupply.add(amount);
2342         emitTransfer(address(0), account, amount);
2343         emitIssued(account, amount);
2344     }
2345 
2346     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
2347     function burn(address account, uint amount)
2348         external
2349         onlySynthetixOrFeePool
2350     {
2351         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
2352         totalSupply = totalSupply.sub(amount);
2353         emitTransfer(account, address(0), amount);
2354         emitBurned(account, amount);
2355     }
2356 
2357     // Allow owner to set the total supply on import.
2358     function setTotalSupply(uint amount)
2359         external
2360         optionalProxy_onlyOwner
2361     {
2362         totalSupply = amount;
2363     }
2364 
2365     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
2366     // exchange as well as transfer
2367     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
2368         external
2369         onlySynthetixOrFeePool
2370     {
2371         bytes memory empty;
2372         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
2373     }
2374 
2375     /* ========== MODIFIERS ========== */
2376 
2377     modifier onlySynthetixOrFeePool() {
2378         bool isSynthetix = msg.sender == address(synthetix);
2379         bool isFeePool = msg.sender == address(feePool);
2380 
2381         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
2382         _;
2383     }
2384 
2385     modifier notFeeAddress(address account) {
2386         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
2387         _;
2388     }
2389 
2390     /* ========== EVENTS ========== */
2391 
2392     event SynthetixUpdated(address newSynthetix);
2393     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
2394     function emitSynthetixUpdated(address newSynthetix) internal {
2395         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
2396     }
2397 
2398     event FeePoolUpdated(address newFeePool);
2399     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
2400     function emitFeePoolUpdated(address newFeePool) internal {
2401         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
2402     }
2403 
2404     event Issued(address indexed account, uint value);
2405     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
2406     function emitIssued(address account, uint value) internal {
2407         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
2408     }
2409 
2410     event Burned(address indexed account, uint value);
2411     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
2412     function emitBurned(address account, uint value) internal {
2413         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
2414     }
2415 }
2416 
2417 
2418 /**
2419  * @title SynthetixEscrow interface
2420  */
2421 interface ISynthetixEscrow {
2422     function balanceOf(address account) public view returns (uint);
2423     function appendVestingEntry(address account, uint quantity) public;
2424 }
2425 
2426 
2427 /*
2428 -----------------------------------------------------------------
2429 FILE INFORMATION
2430 -----------------------------------------------------------------
2431 
2432 file:       Synthetix.sol
2433 version:    2.0
2434 author:     Kevin Brown
2435             Gavin Conway
2436 date:       2018-09-14
2437 
2438 -----------------------------------------------------------------
2439 MODULE DESCRIPTION
2440 -----------------------------------------------------------------
2441 
2442 Synthetix token contract. SNX is a transferable ERC20 token,
2443 and also give its holders the following privileges.
2444 An owner of SNX has the right to issue synths in all synth flavours.
2445 
2446 After a fee period terminates, the duration and fees collected for that
2447 period are computed, and the next period begins. Thus an account may only
2448 withdraw the fees owed to them for the previous period, and may only do
2449 so once per period. Any unclaimed fees roll over into the common pot for
2450 the next period.
2451 
2452 == Average Balance Calculations ==
2453 
2454 The fee entitlement of a synthetix holder is proportional to their average
2455 issued synth balance over the last fee period. This is computed by
2456 measuring the area under the graph of a user's issued synth balance over
2457 time, and then when a new fee period begins, dividing through by the
2458 duration of the fee period.
2459 
2460 We need only update values when the balances of an account is modified.
2461 This occurs when issuing or burning for issued synth balances,
2462 and when transferring for synthetix balances. This is for efficiency,
2463 and adds an implicit friction to interacting with SNX.
2464 A synthetix holder pays for his own recomputation whenever he wants to change
2465 his position, which saves the foundation having to maintain a pot dedicated
2466 to resourcing this.
2467 
2468 A hypothetical user's balance history over one fee period, pictorially:
2469 
2470       s ____
2471        |    |
2472        |    |___ p
2473        |____|___|___ __ _  _
2474        f    t   n
2475 
2476 Here, the balance was s between times f and t, at which time a transfer
2477 occurred, updating the balance to p, until n, when the present transfer occurs.
2478 When a new transfer occurs at time n, the balance being p,
2479 we must:
2480 
2481   - Add the area p * (n - t) to the total area recorded so far
2482   - Update the last transfer time to n
2483 
2484 So if this graph represents the entire current fee period,
2485 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
2486 The complementary computations must be performed for both sender and
2487 recipient.
2488 
2489 Note that a transfer keeps global supply of SNX invariant.
2490 The sum of all balances is constant, and unmodified by any transfer.
2491 So the sum of all balances multiplied by the duration of a fee period is also
2492 constant, and this is equivalent to the sum of the area of every user's
2493 time/balance graph. Dividing through by that duration yields back the total
2494 synthetix supply. So, at the end of a fee period, we really do yield a user's
2495 average share in the synthetix supply over that period.
2496 
2497 A slight wrinkle is introduced if we consider the time r when the fee period
2498 rolls over. Then the previous fee period k-1 is before r, and the current fee
2499 period k is afterwards. If the last transfer took place before r,
2500 but the latest transfer occurred afterwards:
2501 
2502 k-1       |        k
2503       s __|_
2504        |  | |
2505        |  | |____ p
2506        |__|_|____|___ __ _  _
2507           |
2508        f  | t    n
2509           r
2510 
2511 In this situation the area (r-f)*s contributes to fee period k-1, while
2512 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2513 zero-value transfer to have occurred at time r. Their fee entitlement for the
2514 previous period will be finalised at the time of their first transfer during the
2515 current fee period, or when they query or withdraw their fee entitlement.
2516 
2517 In the implementation, the duration of different fee periods may be slightly irregular,
2518 as the check that they have rolled over occurs only when state-changing synthetix
2519 operations are performed.
2520 
2521 == Issuance and Burning ==
2522 
2523 In this version of the synthetix contract, synths can only be issued by
2524 those that have been nominated by the synthetix foundation. Synths are assumed
2525 to be valued at $1, as they are a stable unit of account.
2526 
2527 All synths issued require a proportional value of SNX to be locked,
2528 where the proportion is governed by the current issuance ratio. This
2529 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
2530 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
2531 
2532 To determine the value of some amount of SNX(S), an oracle is used to push
2533 the price of SNX (P_S) in dollars to the contract. The value of S
2534 would then be: S * P_S.
2535 
2536 Any SNX that are locked up by this issuance process cannot be transferred.
2537 The amount that is locked floats based on the price of SNX. If the price
2538 of SNX moves up, less SNX are locked, so they can be issued against,
2539 or transferred freely. If the price of SNX moves down, more SNX are locked,
2540 even going above the initial wallet balance.
2541 
2542 -----------------------------------------------------------------
2543 */
2544 
2545 
2546 /**
2547  * @title Synthetix ERC20 contract.
2548  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2549  * but it also computes the quantity of fees each synthetix holder is entitled to.
2550  */
2551 contract Synthetix is ExternStateToken {
2552 
2553     // ========== STATE VARIABLES ==========
2554 
2555     // Available Synths which can be used with the system
2556     Synth[] public availableSynths;
2557     mapping(bytes4 => Synth) public synths;
2558 
2559     IFeePool public feePool;
2560     ISynthetixEscrow public escrow;
2561     ISynthetixEscrow public rewardEscrow;
2562     ExchangeRates public exchangeRates;
2563     SynthetixState public synthetixState;
2564     SupplySchedule public supplySchedule;
2565 
2566     uint constant SYNTHETIX_SUPPLY = 1e8 * SafeDecimalMath.unit();
2567     string constant TOKEN_NAME = "Synthetix Network Token";
2568     string constant TOKEN_SYMBOL = "SNX";
2569     uint8 constant DECIMALS = 18;
2570     // ========== CONSTRUCTOR ==========
2571 
2572     /**
2573      * @dev Constructor
2574      * @param _tokenState A pre-populated contract containing token balances.
2575      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2576      * @param _owner The owner of this contract.
2577      */
2578     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2579         address _owner, ExchangeRates _exchangeRates, IFeePool _feePool, SupplySchedule _supplySchedule,
2580         ISynthetixEscrow _rewardEscrow, ISynthetixEscrow _escrow
2581     )
2582         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, SYNTHETIX_SUPPLY, DECIMALS, _owner)
2583         public
2584     {
2585         synthetixState = _synthetixState;
2586         exchangeRates = _exchangeRates;
2587         feePool = _feePool;
2588         supplySchedule = _supplySchedule;
2589         rewardEscrow = _rewardEscrow;
2590         escrow = _escrow;
2591     }
2592     // ========== SETTERS ========== */
2593 
2594     /**
2595      * @notice Add an associated Synth contract to the Synthetix system
2596      * @dev Only the contract owner may call this.
2597      */
2598     function addSynth(Synth synth)
2599         external
2600         optionalProxy_onlyOwner
2601     {
2602         bytes4 currencyKey = synth.currencyKey();
2603 
2604         require(synths[currencyKey] == Synth(0), "Synth already exists");
2605 
2606         availableSynths.push(synth);
2607         synths[currencyKey] = synth;
2608 
2609         // emitSynthAdded(currencyKey, synth);
2610     }
2611 
2612     /**
2613      * @notice Remove an associated Synth contract from the Synthetix system
2614      * @dev Only the contract owner may call this.
2615      */
2616     function removeSynth(bytes4 currencyKey)
2617         external
2618         optionalProxy_onlyOwner
2619     {
2620         require(synths[currencyKey] != address(0), "Synth does not exist");
2621         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2622         require(currencyKey != "XDR", "Cannot remove XDR synth");
2623 
2624         // Save the address we're removing for emitting the event at the end.
2625         address synthToRemove = synths[currencyKey];
2626 
2627         // Remove the synth from the availableSynths array.
2628         for (uint8 i = 0; i < availableSynths.length; i++) {
2629             if (availableSynths[i] == synthToRemove) {
2630                 delete availableSynths[i];
2631 
2632                 // Copy the last synth into the place of the one we just deleted
2633                 // If there's only one synth, this is synths[0] = synths[0].
2634                 // If we're deleting the last one, it's also a NOOP in the same way.
2635                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2636 
2637                 // Decrease the size of the array by one.
2638                 availableSynths.length--;
2639 
2640                 break;
2641             }
2642         }
2643 
2644         // And remove it from the synths mapping
2645         delete synths[currencyKey];
2646 
2647         // Note: No event here as our contract exceeds max contract size
2648         // with these events, and it's unlikely people will need to
2649         // track these events specifically.
2650     }
2651 
2652     // ========== VIEWS ==========
2653 
2654     /**
2655      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2656      * @param sourceCurrencyKey The currency the amount is specified in
2657      * @param sourceAmount The source amount, specified in UNIT base
2658      * @param destinationCurrencyKey The destination currency
2659      */
2660     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
2661         public
2662         view
2663         rateNotStale(sourceCurrencyKey)
2664         rateNotStale(destinationCurrencyKey)
2665         returns (uint)
2666     {
2667         // If there's no change in the currency, then just return the amount they gave us
2668         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
2669 
2670         // Calculate the effective value by going from source -> USD -> destination
2671         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
2672             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
2673     }
2674 
2675     /**
2676      * @notice Total amount of synths issued by the system, priced in currencyKey
2677      * @param currencyKey The currency to value the synths in
2678      */
2679     function totalIssuedSynths(bytes4 currencyKey)
2680         public
2681         view
2682         rateNotStale(currencyKey)
2683         returns (uint)
2684     {
2685         uint total = 0;
2686         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2687 
2688         require(!exchangeRates.anyRateIsStale(availableCurrencyKeys()), "Rates are stale");
2689 
2690         for (uint8 i = 0; i < availableSynths.length; i++) {
2691             // What's the total issued value of that synth in the destination currency?
2692             // Note: We're not using our effectiveValue function because we don't want to go get the
2693             //       rate for the destination currency and check if it's stale repeatedly on every
2694             //       iteration of the loop
2695             uint synthValue = availableSynths[i].totalSupply()
2696                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
2697                 .divideDecimalRound(currencyRate);
2698             total = total.add(synthValue);
2699         }
2700 
2701         return total;
2702     }
2703 
2704     /**
2705      * @notice Returns the currencyKeys of availableSynths for rate checking
2706      */
2707     function availableCurrencyKeys()
2708         internal
2709         view
2710         returns (bytes4[])
2711     {
2712         bytes4[] memory availableCurrencyKeys = new bytes4[](availableSynths.length);
2713 
2714         for (uint8 i = 0; i < availableSynths.length; i++) {
2715             availableCurrencyKeys[i] = availableSynths[i].currencyKey();
2716         }
2717 
2718         return availableCurrencyKeys;
2719     }
2720 
2721     /**
2722      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
2723      */
2724     function availableSynthCount()
2725         public
2726         view
2727         returns (uint)
2728     {
2729         return availableSynths.length;
2730     }
2731 
2732     // ========== MUTATIVE FUNCTIONS ==========
2733 
2734     /**
2735      * @notice ERC20 transfer function.
2736      */
2737     function transfer(address to, uint value)
2738         public
2739         returns (bool)
2740     {
2741         bytes memory empty;
2742         return transfer(to, value, empty);
2743     }
2744 
2745     /**
2746      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
2747      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2748      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2749      *           tooling such as Etherscan.
2750      */
2751     function transfer(address to, uint value, bytes data)
2752         public
2753         optionalProxy
2754         returns (bool)
2755     {
2756         // Ensure they're not trying to exceed their locked amount
2757         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
2758 
2759         // Perform the transfer: if there is a problem an exception will be thrown in this call.
2760         _transfer_byProxy(messageSender, to, value, data);
2761 
2762         return true;
2763     }
2764 
2765     /**
2766      * @notice ERC20 transferFrom function.
2767      */
2768     function transferFrom(address from, address to, uint value)
2769         public
2770         returns (bool)
2771     {
2772         bytes memory empty;
2773         return transferFrom(from, to, value, empty);
2774     }
2775 
2776     /**
2777      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
2778      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2779      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2780      *           tooling such as Etherscan.
2781      */
2782     function transferFrom(address from, address to, uint value, bytes data)
2783         public
2784         optionalProxy
2785         returns (bool)
2786     {
2787         // Ensure they're not trying to exceed their locked amount
2788         require(value <= transferableSynthetix(from), "Insufficient balance");
2789 
2790         // Perform the transfer: if there is a problem,
2791         // an exception will be thrown in this call.
2792         _transferFrom_byProxy(messageSender, from, to, value, data);
2793 
2794         return true;
2795     }
2796 
2797     /**
2798      * @notice Function that allows you to exchange synths you hold in one flavour for another.
2799      * @param sourceCurrencyKey The source currency you wish to exchange from
2800      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2801      * @param destinationCurrencyKey The destination currency you wish to obtain.
2802      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
2803      * @return Boolean that indicates whether the transfer succeeded or failed.
2804      */
2805     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
2806         external
2807         optionalProxy
2808         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
2809         returns (bool)
2810     {
2811         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
2812         require(sourceAmount > 0, "Zero amount");
2813 
2814         // Pass it along, defaulting to the sender as the recipient.
2815         return _internalExchange(
2816             messageSender,
2817             sourceCurrencyKey,
2818             sourceAmount,
2819             destinationCurrencyKey,
2820             destinationAddress == address(0) ? messageSender : destinationAddress,
2821             true // Charge fee on the exchange
2822         );
2823     }
2824 
2825     /**
2826      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
2827      * @dev Only the synth contract can call this function
2828      * @param from The address to exchange / burn synth from
2829      * @param sourceCurrencyKey The source currency you wish to exchange from
2830      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
2831      * @param destinationCurrencyKey The destination currency you wish to obtain.
2832      * @param destinationAddress Where the result should go.
2833      * @return Boolean that indicates whether the transfer succeeded or failed.
2834      */
2835     function synthInitiatedExchange(
2836         address from,
2837         bytes4 sourceCurrencyKey,
2838         uint sourceAmount,
2839         bytes4 destinationCurrencyKey,
2840         address destinationAddress
2841     )
2842         external
2843         onlySynth
2844         returns (bool)
2845     {
2846         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
2847         require(sourceAmount > 0, "Zero amount");
2848 
2849         // Pass it along
2850         return _internalExchange(
2851             from,
2852             sourceCurrencyKey,
2853             sourceAmount,
2854             destinationCurrencyKey,
2855             destinationAddress,
2856             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
2857         );
2858     }
2859 
2860     /**
2861      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
2862      * @dev Only the synth contract can call this function.
2863      * @param from The address fee is coming from.
2864      * @param sourceCurrencyKey source currency fee from.
2865      * @param sourceAmount The amount, specified in UNIT of source currency.
2866      * @return Boolean that indicates whether the transfer succeeded or failed.
2867      */
2868     function synthInitiatedFeePayment(
2869         address from,
2870         bytes4 sourceCurrencyKey,
2871         uint sourceAmount
2872     )
2873         external
2874         onlySynth
2875         returns (bool)
2876     {
2877         // Allow fee to be 0 and skip minting XDRs to feePool
2878         if (sourceAmount == 0) {
2879             return true;
2880         }
2881 
2882         require(sourceAmount > 0, "Source can't be 0");
2883 
2884         // Pass it along, defaulting to the sender as the recipient.
2885         bool result = _internalExchange(
2886             from,
2887             sourceCurrencyKey,
2888             sourceAmount,
2889             "XDR",
2890             feePool.FEE_ADDRESS(),
2891             false // Don't charge a fee on the exchange because this is already a fee
2892         );
2893 
2894         // Tell the fee pool about this.
2895         feePool.feePaid(sourceCurrencyKey, sourceAmount);
2896 
2897         return result;
2898     }
2899 
2900     /**
2901      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
2902      * @dev fee pool contract address is not allowed to call function
2903      * @param from The address to move synth from
2904      * @param sourceCurrencyKey source currency from.
2905      * @param sourceAmount The amount, specified in UNIT of source currency.
2906      * @param destinationCurrencyKey The destination currency to obtain.
2907      * @param destinationAddress Where the result should go.
2908      * @param chargeFee Boolean to charge a fee for transaction.
2909      * @return Boolean that indicates whether the transfer succeeded or failed.
2910      */
2911     function _internalExchange(
2912         address from,
2913         bytes4 sourceCurrencyKey,
2914         uint sourceAmount,
2915         bytes4 destinationCurrencyKey,
2916         address destinationAddress,
2917         bool chargeFee
2918     )
2919         internal
2920         notFeeAddress(from)
2921         returns (bool)
2922     {
2923         require(destinationAddress != address(0), "Zero destination");
2924         require(destinationAddress != address(this), "Synthetix is invalid destination");
2925         require(destinationAddress != address(proxy), "Proxy is invalid destination");
2926 
2927         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
2928         // the subtraction to not overflow, which would happen if their balance is not sufficient.
2929 
2930         // Burn the source amount
2931         synths[sourceCurrencyKey].burn(from, sourceAmount);
2932 
2933         // How much should they get in the destination currency?
2934         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
2935 
2936         // What's the fee on that currency that we should deduct?
2937         uint amountReceived = destinationAmount;
2938         uint fee = 0;
2939 
2940         if (chargeFee) {
2941             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
2942             fee = destinationAmount.sub(amountReceived);
2943         }
2944 
2945         // Issue their new synths
2946         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
2947 
2948         // Remit the fee in XDRs
2949         if (fee > 0) {
2950             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
2951             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
2952             // Tell the fee pool about this.
2953             feePool.feePaid("XDR", xdrFeeAmount);
2954         }
2955 
2956         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
2957 
2958         // Call the ERC223 transfer callback if needed
2959         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
2960 
2961         //Let the DApps know there was a Synth exchange
2962         emitSynthExchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, amountReceived, destinationAddress);
2963 
2964         return true;
2965     }
2966 
2967     /**
2968      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
2969      * @dev Only internal calls from synthetix address.
2970      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
2971      * @param amount The amount of synths to register with a base of UNIT
2972      */
2973     function _addToDebtRegister(bytes4 currencyKey, uint amount)
2974         internal
2975         optionalProxy
2976     {
2977         // What is the value of the requested debt in XDRs?
2978         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
2979 
2980         // What is the value of all issued synths of the system (priced in XDRs)?
2981         uint totalDebtIssued = totalIssuedSynths("XDR");
2982 
2983         // What will the new total be including the new value?
2984         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2985 
2986         // What is their percentage (as a high precision int) of the total debt?
2987         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2988 
2989         // And what effect does this percentage change have on the global debt holding of other issuers?
2990         // The delta specifically needs to not take into account any existing debt as it's already
2991         // accounted for in the delta from when they issued previously.
2992         // The delta is a high precision integer.
2993         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2994 
2995         // How much existing debt do they have?
2996         uint existingDebt = debtBalanceOf(messageSender, "XDR");
2997 
2998         // And what does their debt ownership look like including this previous stake?
2999         if (existingDebt > 0) {
3000             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3001         }
3002 
3003         // Are they a new issuer? If so, record them.
3004         if (!synthetixState.hasIssued(messageSender)) {
3005             synthetixState.incrementTotalIssuerCount();
3006         }
3007 
3008         // Save the debt entry parameters
3009         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3010 
3011         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3012         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3013         if (synthetixState.debtLedgerLength() > 0) {
3014             synthetixState.appendDebtLedgerValue(
3015                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3016             );
3017         } else {
3018             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3019         }
3020     }
3021 
3022     /**
3023      * @notice Issue synths against the sender's SNX.
3024      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3025      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3026      * @param amount The amount of synths you wish to issue with a base of UNIT
3027      */
3028     function issueSynths(bytes4 currencyKey, uint amount)
3029         public
3030         optionalProxy
3031         // No need to check if price is stale, as it is checked in issuableSynths.
3032     {
3033         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3034 
3035         // Keep track of the debt they're about to create
3036         _addToDebtRegister(currencyKey, amount);
3037 
3038         // Create their synths
3039         synths[currencyKey].issue(messageSender, amount);
3040 
3041         // Store their locked SNX amount to determine their fee % for the period
3042         _appendAccountIssuanceRecord();
3043     }
3044 
3045     /**
3046      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3047      * @dev Issuance is only allowed if the synthetix price isn't stale.
3048      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3049      */
3050     function issueMaxSynths(bytes4 currencyKey)
3051         external
3052         optionalProxy
3053     {
3054         // Figure out the maximum we can issue in that currency
3055         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3056 
3057         // And issue them
3058         issueSynths(currencyKey, maxIssuable);
3059     }
3060 
3061     /**
3062      * @notice Burn synths to clear issued synths/free SNX.
3063      * @param currencyKey The currency you're specifying to burn
3064      * @param amount The amount (in UNIT base) you wish to burn
3065      * @dev The amount to burn is debased to XDR's
3066      */
3067     function burnSynths(bytes4 currencyKey, uint amount)
3068         external
3069         optionalProxy
3070         // No need to check for stale rates as effectiveValue checks rates
3071     {
3072         // How much debt do they have?
3073         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3074         uint debt = debtBalanceOf(messageSender, "XDR");
3075         uint debtInCurrencyKey = debtBalanceOf(messageSender, currencyKey);
3076 
3077         require(debt > 0, "No debt to forgive");
3078 
3079         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3080         // clear their debt and leave them be.
3081         uint amountToRemove = debt < debtToRemove ? debt : debtToRemove;
3082 
3083         // Remove their debt from the ledger
3084         _removeFromDebtRegister(amountToRemove);
3085 
3086         uint amountToBurn = debtInCurrencyKey < amount ? debtInCurrencyKey : amount;
3087 
3088         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3089         synths[currencyKey].burn(messageSender, amountToBurn);
3090 
3091         // Store their debtRatio against a feeperiod to determine their fee/rewards % for the period
3092         _appendAccountIssuanceRecord();
3093     }
3094 
3095     /**
3096      * @notice Store in the FeePool the users current debt value in the system in XDRs.
3097      * @dev debtBalanceOf(messageSender, "XDR") to be used with totalIssuedSynths("XDR") to get
3098      *  users % of the system within a feePeriod.
3099      */
3100     function _appendAccountIssuanceRecord()
3101         internal
3102     {
3103         uint initialDebtOwnership;
3104         uint debtEntryIndex;
3105         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(messageSender);
3106 
3107         feePool.appendAccountIssuanceRecord(
3108             messageSender,
3109             initialDebtOwnership,
3110             debtEntryIndex
3111         );
3112     }
3113 
3114     /**
3115      * @notice Remove a debt position from the register
3116      * @param amount The amount (in UNIT base) being presented in XDRs
3117      */
3118     function _removeFromDebtRegister(uint amount)
3119         internal
3120     {
3121         uint debtToRemove = amount;
3122 
3123         // How much debt do they have?
3124         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3125 
3126         // What is the value of all issued synths of the system (priced in XDRs)?
3127         uint totalDebtIssued = totalIssuedSynths("XDR");
3128 
3129         // What will the new total after taking out the withdrawn amount
3130         uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3131 
3132         uint delta;
3133 
3134         // What will the debt delta be if there is any debt left?
3135         // Set delta to 0 if no more debt left in system after user
3136         if (newTotalDebtIssued > 0) {
3137 
3138             // What is the percentage of the withdrawn debt (as a high precision int) of the total debt after?
3139             uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(newTotalDebtIssued);
3140 
3141             // And what effect does this percentage change have on the global debt holding of other issuers?
3142             // The delta specifically needs to not take into account any existing debt as it's already
3143             // accounted for in the delta from when they issued previously.
3144             delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3145         } else {
3146             delta = 0;
3147         }
3148 
3149         // Are they exiting the system, or are they just decreasing their debt position?
3150         if (debtToRemove == existingDebt) {
3151             synthetixState.clearIssuanceData(messageSender);
3152             synthetixState.decrementTotalIssuerCount();
3153         } else {
3154             // What percentage of the debt will they be left with?
3155             uint newDebt = existingDebt.sub(debtToRemove);
3156             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3157 
3158             // Store the debt percentage and debt ledger as high precision integers
3159             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3160         }
3161 
3162         // Update our cumulative ledger. This is also a high precision integer.
3163         synthetixState.appendDebtLedgerValue(
3164             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3165         );
3166     }
3167 
3168     // ========== Issuance/Burning ==========
3169 
3170     /**
3171      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3172      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3173      */
3174     function maxIssuableSynths(address issuer, bytes4 currencyKey)
3175         public
3176         view
3177         // We don't need to check stale rates here as effectiveValue will do it for us.
3178         returns (uint)
3179     {
3180         // What is the value of their SNX balance in the destination currency?
3181         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3182 
3183         // They're allowed to issue up to issuanceRatio of that value
3184         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3185     }
3186 
3187     /**
3188      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3189      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
3190      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3191      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
3192      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3193      * altering the amount of fees they're able to claim from the system.
3194      */
3195     function collateralisationRatio(address issuer)
3196         public
3197         view
3198         returns (uint)
3199     {
3200         uint totalOwnedSynthetix = collateral(issuer);
3201         if (totalOwnedSynthetix == 0) return 0;
3202 
3203         uint debtBalance = debtBalanceOf(issuer, "SNX");
3204         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3205     }
3206 
3207     /**
3208      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3209      * will tell you how many synths a user has to give back to the system in order to unlock their original
3210      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3211      * the debt in sUSD, XDR, or any other synth you wish.
3212      */
3213     function debtBalanceOf(address issuer, bytes4 currencyKey)
3214         public
3215         view
3216         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3217         returns (uint)
3218     {
3219         // What was their initial debt ownership?
3220         uint initialDebtOwnership;
3221         uint debtEntryIndex;
3222         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3223 
3224         // If it's zero, they haven't issued, and they have no debt.
3225         if (initialDebtOwnership == 0) return 0;
3226 
3227         // Figure out the global debt percentage delta from when they entered the system.
3228         // This is a high precision integer.
3229         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3230             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3231             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3232 
3233         // What's the total value of the system in their requested currency?
3234         uint totalSystemValue = totalIssuedSynths(currencyKey);
3235 
3236         // Their debt balance is their portion of the total system value.
3237         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3238             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3239 
3240         return highPrecisionBalance.preciseDecimalToDecimal();
3241     }
3242 
3243     /**
3244      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3245      * @param issuer The account that intends to issue
3246      * @param currencyKey The currency to price issuable value in
3247      */
3248     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
3249         public
3250         view
3251         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3252         returns (uint)
3253     {
3254         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3255         uint max = maxIssuableSynths(issuer, currencyKey);
3256 
3257         if (alreadyIssued >= max) {
3258             return 0;
3259         } else {
3260             return max.sub(alreadyIssued);
3261         }
3262     }
3263 
3264     /**
3265      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3266      * against which synths can be issued.
3267      * This includes those already being used as collateral (locked), and those
3268      * available for further issuance (unlocked).
3269      */
3270     function collateral(address account)
3271         public
3272         view
3273         returns (uint)
3274     {
3275         uint balance = tokenState.balanceOf(account);
3276 
3277         if (escrow != address(0)) {
3278             balance = balance.add(escrow.balanceOf(account));
3279         }
3280 
3281         if (rewardEscrow != address(0)) {
3282             balance = balance.add(rewardEscrow.balanceOf(account));
3283         }
3284 
3285         return balance;
3286     }
3287 
3288     /**
3289      * @notice The number of SNX that are free to be transferred by an account.
3290      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
3291      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
3292      * in this calculation.
3293      */
3294     function transferableSynthetix(address account)
3295         public
3296         view
3297         rateNotStale("SNX")
3298         returns (uint)
3299     {
3300         // How many SNX do they have, excluding escrow?
3301         // Note: We're excluding escrow here because we're interested in their transferable amount
3302         // and escrowed SNX are not transferable.
3303         uint balance = tokenState.balanceOf(account);
3304 
3305         // How many of those will be locked by the amount they've issued?
3306         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3307         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3308         // The locked synthetix value can exceed their balance.
3309         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3310 
3311         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3312         if (lockedSynthetixValue >= balance) {
3313             return 0;
3314         } else {
3315             return balance.sub(lockedSynthetixValue);
3316         }
3317     }
3318 
3319     function mint()
3320         external
3321         returns (bool)
3322     {
3323         require(rewardEscrow != address(0), "Reward Escrow destination missing");
3324 
3325         uint supplyToMint = supplySchedule.mintableSupply();
3326         require(supplyToMint > 0, "No supply is mintable");
3327 
3328         supplySchedule.updateMintValues();
3329 
3330         // Set minted SNX balance to RewardEscrow's balance
3331         // Minus the minterReward and set balance of minter to add reward
3332         uint minterReward = supplySchedule.minterReward();
3333 
3334         tokenState.setBalanceOf(rewardEscrow, tokenState.balanceOf(rewardEscrow).add(supplyToMint.sub(minterReward)));
3335         emitTransfer(this, rewardEscrow, supplyToMint.sub(minterReward));
3336 
3337         // Tell the FeePool how much it has to distribute
3338         feePool.rewardsMinted(supplyToMint.sub(minterReward));
3339 
3340         // Assign the minters reward.
3341         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
3342         emitTransfer(this, msg.sender, minterReward);
3343 
3344         totalSupply = totalSupply.add(supplyToMint);
3345     }
3346 
3347     // ========== MODIFIERS ==========
3348 
3349     modifier rateNotStale(bytes4 currencyKey) {
3350         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
3351         _;
3352     }
3353 
3354     modifier notFeeAddress(address account) {
3355         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3356         _;
3357     }
3358 
3359     modifier onlySynth() {
3360         bool isSynth = false;
3361 
3362         // No need to repeatedly call this function either
3363         for (uint8 i = 0; i < availableSynths.length; i++) {
3364             if (availableSynths[i] == msg.sender) {
3365                 isSynth = true;
3366                 break;
3367             }
3368         }
3369 
3370         require(isSynth, "Only synth allowed");
3371         _;
3372     }
3373 
3374     modifier nonZeroAmount(uint _amount) {
3375         require(_amount > 0, "Amount needs to be larger than 0");
3376         _;
3377     }
3378 
3379     // ========== EVENTS ==========
3380     /* solium-disable */
3381     event SynthExchange(address indexed account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey,  uint256 toAmount, address toAddress);
3382     bytes32 constant SYNTHEXCHANGE_SIG = keccak256("SynthExchange(address,bytes4,uint256,bytes4,uint256,address)");
3383     function emitSynthExchange(address account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey, uint256 toAmount, address toAddress) internal {
3384         proxy._emit(abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress), 2, SYNTHEXCHANGE_SIG, bytes32(account), 0, 0);
3385     }
3386     /* solium-enable */
3387 }
3388 
3389 
3390 /*
3391 -----------------------------------------------------------------
3392 FILE INFORMATION
3393 -----------------------------------------------------------------
3394 
3395 file:       SupplySchedule.sol
3396 version:    1.0
3397 author:     Jackson Chan
3398             Clinton Ennis
3399 date:       2019-03-01
3400 
3401 -----------------------------------------------------------------
3402 MODULE DESCRIPTION
3403 -----------------------------------------------------------------
3404 
3405 Supply Schedule contract. SNX is a transferable ERC20 token.
3406 
3407 User's get staking rewards as part of the incentives of
3408 +------+-------------+--------------+----------+
3409 | Year |  Increase   | Total Supply | Increase |
3410 +------+-------------+--------------+----------+
3411 |    1 |           0 |  100,000,000 |          |
3412 |    2 |  75,000,000 |  175,000,000 | 75%      |
3413 |    3 |  37,500,000 |  212,500,000 | 21%      |
3414 |    4 |  18,750,000 |  231,250,000 | 9%       |
3415 |    5 |   9,375,000 |  240,625,000 | 4%       |
3416 |    6 |   4,687,500 |  245,312,500 | 2%       |
3417 +------+-------------+--------------+----------+
3418 
3419 
3420 -----------------------------------------------------------------
3421 */
3422 
3423 
3424 /**
3425  * @title SupplySchedule contract
3426  */
3427 contract SupplySchedule is Owned {
3428     using SafeMath for uint;
3429     using SafeDecimalMath for uint;
3430 
3431     /* Storage */
3432     struct ScheduleData {
3433         // Total supply issuable during period
3434         uint totalSupply;
3435 
3436         // UTC Time - Start of the schedule
3437         uint startPeriod;
3438 
3439         // UTC Time - End of the schedule
3440         uint endPeriod;
3441 
3442         // UTC Time - Total of supply minted
3443         uint totalSupplyMinted;
3444     }
3445 
3446     // How long each mint period is
3447     uint public mintPeriodDuration = 1 weeks;
3448 
3449     // time supply last minted
3450     uint public lastMintEvent;
3451 
3452     Synthetix public synthetix;
3453 
3454     uint constant SECONDS_IN_YEAR = 60 * 60 * 24 * 365;
3455 
3456     uint public constant START_DATE = 1520294400; // 2018-03-06T00:00:00+00:00
3457     uint public constant YEAR_ONE = START_DATE + SECONDS_IN_YEAR.mul(1);
3458     uint public constant YEAR_TWO = START_DATE + SECONDS_IN_YEAR.mul(2);
3459     uint public constant YEAR_THREE = START_DATE + SECONDS_IN_YEAR.mul(3);
3460     uint public constant YEAR_FOUR = START_DATE + SECONDS_IN_YEAR.mul(4);
3461     uint public constant YEAR_FIVE = START_DATE + SECONDS_IN_YEAR.mul(5);
3462     uint public constant YEAR_SIX = START_DATE + SECONDS_IN_YEAR.mul(6);
3463     uint public constant YEAR_SEVEN = START_DATE + SECONDS_IN_YEAR.mul(7);
3464 
3465     uint8 constant public INFLATION_SCHEDULES_LENGTH = 7;
3466     ScheduleData[INFLATION_SCHEDULES_LENGTH] public schedules;
3467 
3468     uint public minterReward = 200 * SafeDecimalMath.unit();
3469 
3470     constructor(address _owner)
3471         Owned(_owner)
3472         public
3473     {
3474         // ScheduleData(totalSupply, startPeriod, endPeriod, totalSupplyMinted)
3475         // Year 1 - Total supply 100,000,000
3476         schedules[0] = ScheduleData(1e8 * SafeDecimalMath.unit(), START_DATE, YEAR_ONE - 1, 1e8 * SafeDecimalMath.unit());
3477         schedules[1] = ScheduleData(75e6 * SafeDecimalMath.unit(), YEAR_ONE, YEAR_TWO - 1, 0); // Year 2 - Total supply 175,000,000
3478         schedules[2] = ScheduleData(37.5e6 * SafeDecimalMath.unit(), YEAR_TWO, YEAR_THREE - 1, 0); // Year 3 - Total supply 212,500,000
3479         schedules[3] = ScheduleData(18.75e6 * SafeDecimalMath.unit(), YEAR_THREE, YEAR_FOUR - 1, 0); // Year 4 - Total supply 231,250,000
3480         schedules[4] = ScheduleData(9.375e6 * SafeDecimalMath.unit(), YEAR_FOUR, YEAR_FIVE - 1, 0); // Year 5 - Total supply 240,625,000
3481         schedules[5] = ScheduleData(4.6875e6 * SafeDecimalMath.unit(), YEAR_FIVE, YEAR_SIX - 1, 0); // Year 6 - Total supply 245,312,500
3482         schedules[6] = ScheduleData(0, YEAR_SIX, YEAR_SEVEN - 1, 0); // Year 7 - Total supply 245,312,500
3483     }
3484 
3485     // ========== SETTERS ========== */
3486     function setSynthetix(Synthetix _synthetix)
3487         external
3488         onlyOwner
3489     {
3490         synthetix = _synthetix;
3491         // emit event
3492     }
3493 
3494     // ========== VIEWS ==========
3495     function mintableSupply()
3496         public
3497         view
3498         returns (uint)
3499     {
3500         if (!isMintable()) {
3501             return 0;
3502         }
3503 
3504         uint index = getCurrentSchedule();
3505 
3506         // Calculate previous year's mintable supply
3507         uint amountPreviousPeriod = _remainingSupplyFromPreviousYear(index);
3508 
3509         /* solium-disable */
3510 
3511         // Last mint event within current period will use difference in (now - lastMintEvent)
3512         // Last mint event not set (0) / outside of current Period will use current Period
3513         // start time resolved in (now - schedule.startPeriod)
3514         ScheduleData memory schedule = schedules[index];
3515 
3516         uint weeksInPeriod = (schedule.endPeriod - schedule.startPeriod).div(mintPeriodDuration);
3517 
3518         uint supplyPerWeek = schedule.totalSupply.divideDecimal(weeksInPeriod);
3519 
3520         uint weeksToMint = lastMintEvent >= schedule.startPeriod ? _numWeeksRoundedDown(now.sub(lastMintEvent)) : _numWeeksRoundedDown(now.sub(schedule.startPeriod));
3521         // /* solium-enable */
3522 
3523         uint amountInPeriod = supplyPerWeek.multiplyDecimal(weeksToMint);
3524         return amountInPeriod.add(amountPreviousPeriod);
3525     }
3526 
3527     function _numWeeksRoundedDown(uint _timeDiff)
3528         public
3529         view
3530         returns (uint)
3531     {
3532         // Take timeDiff in seconds (Dividend) and mintPeriodDuration as (Divisor)
3533         // Calculate the numberOfWeeks since last mint rounded down to 1 week
3534         // Fraction of a week will return 0
3535         return _timeDiff.div(mintPeriodDuration);
3536     }
3537 
3538     function isMintable()
3539         public
3540         view
3541         returns (bool)
3542     {
3543         bool mintable = false;
3544         if (now - lastMintEvent > mintPeriodDuration && now <= schedules[6].endPeriod) // Ensure time is not after end of Year 7
3545         {
3546             mintable = true;
3547         }
3548         return mintable;
3549     }
3550 
3551     // Return the current schedule based on the timestamp
3552     // applicable based on startPeriod and endPeriod
3553     function getCurrentSchedule()
3554         public
3555         view
3556         returns (uint)
3557     {
3558         require(now <= schedules[6].endPeriod, "Mintable periods have ended");
3559 
3560         for (uint i = 0; i < INFLATION_SCHEDULES_LENGTH; i++) {
3561             if (schedules[i].startPeriod <= now && schedules[i].endPeriod >= now) {
3562                 return i;
3563             }
3564         }
3565     }
3566 
3567     function _remainingSupplyFromPreviousYear(uint currentSchedule)
3568         internal
3569         view
3570         returns (uint)
3571     {
3572         // All supply has been minted for previous period if last minting event is after
3573         // the endPeriod for last year
3574         if (currentSchedule == 0 || lastMintEvent > schedules[currentSchedule - 1].endPeriod) {
3575             return 0;
3576         }
3577 
3578         // return the remaining supply to be minted for previous period missed
3579         uint amountInPeriod = schedules[currentSchedule - 1].totalSupply.sub(schedules[currentSchedule - 1].totalSupplyMinted);
3580 
3581         // Ensure previous period remaining amount is not less than 0
3582         if (amountInPeriod < 0) {
3583             return 0;
3584         }
3585 
3586         return amountInPeriod;
3587     }
3588 
3589     // ========== MUTATIVE FUNCTIONS ==========
3590     function updateMintValues()
3591         external
3592         onlySynthetix
3593         returns (bool)
3594     {
3595         // Will fail if the time is outside of schedules
3596         uint currentIndex = getCurrentSchedule();
3597         uint lastPeriodAmount = _remainingSupplyFromPreviousYear(currentIndex);
3598         uint currentPeriodAmount = mintableSupply().sub(lastPeriodAmount);
3599 
3600         // Update schedule[n - 1].totalSupplyMinted
3601         if (lastPeriodAmount > 0) {
3602             schedules[currentIndex - 1].totalSupplyMinted = schedules[currentIndex - 1].totalSupplyMinted.add(lastPeriodAmount);
3603         }
3604 
3605         // Update schedule.totalSupplyMinted for currentSchedule
3606         schedules[currentIndex].totalSupplyMinted = schedules[currentIndex].totalSupplyMinted.add(currentPeriodAmount);
3607         // Update mint event to now
3608         lastMintEvent = now;
3609 
3610         emit SupplyMinted(lastPeriodAmount, currentPeriodAmount, currentIndex, now);
3611         return true;
3612     }
3613 
3614     function setMinterReward(uint _amount)
3615         external
3616         onlyOwner
3617     {
3618         minterReward = _amount;
3619         emit MinterRewardUpdated(_amount);
3620     }
3621 
3622     // ========== MODIFIERS ==========
3623 
3624     modifier onlySynthetix() {
3625         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
3626         _;
3627     }
3628 
3629     /* ========== EVENTS ========== */
3630 
3631     event SupplyMinted(uint previousPeriodAmount, uint currentAmount, uint indexed schedule, uint timestamp);
3632     event MinterRewardUpdated(uint newRewardAmount);
3633 }
3634 
