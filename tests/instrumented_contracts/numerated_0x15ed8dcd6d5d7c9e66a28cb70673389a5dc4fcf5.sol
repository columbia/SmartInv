1 /* ===============================================
2 * Flattened with Solidifier by Coinage
3 * 
4 * https://solidifier.coina.ge
5 * ===============================================
6 */
7 
8 
9 /*
10 -----------------------------------------------------------------
11 FILE INFORMATION
12 -----------------------------------------------------------------
13 
14 file:       Owned.sol
15 version:    1.1
16 author:     Anton Jurisevic
17             Dominic Romanowski
18 
19 date:       2018-2-26
20 
21 -----------------------------------------------------------------
22 MODULE DESCRIPTION
23 -----------------------------------------------------------------
24 
25 An Owned contract, to be inherited by other contracts.
26 Requires its owner to be explicitly set in the constructor.
27 Provides an onlyOwner access modifier.
28 
29 To change owner, the current owner must nominate the next owner,
30 who then has to accept the nomination. The nomination can be
31 cancelled before it is accepted by the new owner by having the
32 previous owner change the nomination (setting it to 0).
33 
34 -----------------------------------------------------------------
35 */
36 
37 pragma solidity 0.4.25;
38 
39 /**
40  * @title A contract with an owner.
41  * @notice Contract ownership can be transferred by first nominating the new owner,
42  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
43  */
44 contract Owned {
45     address public owner;
46     address public nominatedOwner;
47 
48     /**
49      * @dev Owned Constructor
50      */
51     constructor(address _owner)
52         public
53     {
54         require(_owner != address(0), "Owner address cannot be 0");
55         owner = _owner;
56         emit OwnerChanged(address(0), _owner);
57     }
58 
59     /**
60      * @notice Nominate a new owner of this contract.
61      * @dev Only the current owner may nominate a new owner.
62      */
63     function nominateNewOwner(address _owner)
64         external
65         onlyOwner
66     {
67         nominatedOwner = _owner;
68         emit OwnerNominated(_owner);
69     }
70 
71     /**
72      * @notice Accept the nomination to be owner.
73      */
74     function acceptOwnership()
75         external
76     {
77         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
78         emit OwnerChanged(owner, nominatedOwner);
79         owner = nominatedOwner;
80         nominatedOwner = address(0);
81     }
82 
83     modifier onlyOwner
84     {
85         require(msg.sender == owner, "Only the contract owner may perform this action");
86         _;
87     }
88 
89     event OwnerNominated(address newOwner);
90     event OwnerChanged(address oldOwner, address newOwner);
91 }
92 
93 /*
94 -----------------------------------------------------------------
95 FILE INFORMATION
96 -----------------------------------------------------------------
97 
98 file:       SelfDestructible.sol
99 version:    1.2
100 author:     Anton Jurisevic
101 
102 date:       2018-05-29
103 
104 -----------------------------------------------------------------
105 MODULE DESCRIPTION
106 -----------------------------------------------------------------
107 
108 This contract allows an inheriting contract to be destroyed after
109 its owner indicates an intention and then waits for a period
110 without changing their mind. All ether contained in the contract
111 is forwarded to a nominated beneficiary upon destruction.
112 
113 -----------------------------------------------------------------
114 */
115 
116 
117 /**
118  * @title A contract that can be destroyed by its owner after a delay elapses.
119  */
120 contract SelfDestructible is Owned {
121     
122     uint public initiationTime;
123     bool public selfDestructInitiated;
124     address public selfDestructBeneficiary;
125     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
126 
127     /**
128      * @dev Constructor
129      * @param _owner The account which controls this contract.
130      */
131     constructor(address _owner)
132         Owned(_owner)
133         public
134     {
135         require(_owner != address(0), "Owner must not be the zero address");
136         selfDestructBeneficiary = _owner;
137         emit SelfDestructBeneficiaryUpdated(_owner);
138     }
139 
140     /**
141      * @notice Set the beneficiary address of this contract.
142      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
143      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
144      */
145     function setSelfDestructBeneficiary(address _beneficiary)
146         external
147         onlyOwner
148     {
149         require(_beneficiary != address(0), "Beneficiary must not be the zero address");
150         selfDestructBeneficiary = _beneficiary;
151         emit SelfDestructBeneficiaryUpdated(_beneficiary);
152     }
153 
154     /**
155      * @notice Begin the self-destruction counter of this contract.
156      * Once the delay has elapsed, the contract may be self-destructed.
157      * @dev Only the contract owner may call this.
158      */
159     function initiateSelfDestruct()
160         external
161         onlyOwner
162     {
163         initiationTime = now;
164         selfDestructInitiated = true;
165         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
166     }
167 
168     /**
169      * @notice Terminate and reset the self-destruction timer.
170      * @dev Only the contract owner may call this.
171      */
172     function terminateSelfDestruct()
173         external
174         onlyOwner
175     {
176         initiationTime = 0;
177         selfDestructInitiated = false;
178         emit SelfDestructTerminated();
179     }
180 
181     /**
182      * @notice If the self-destruction delay has elapsed, destroy this contract and
183      * remit any ether it owns to the beneficiary address.
184      * @dev Only the contract owner may call this.
185      */
186     function selfDestruct()
187         external
188         onlyOwner
189     {
190         require(selfDestructInitiated, "Self destruct has not yet been initiated");
191         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay has not yet elapsed");
192         address beneficiary = selfDestructBeneficiary;
193         emit SelfDestructed(beneficiary);
194         selfdestruct(beneficiary);
195     }
196 
197     event SelfDestructTerminated();
198     event SelfDestructed(address beneficiary);
199     event SelfDestructInitiated(uint selfDestructDelay);
200     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
201 }
202 
203 
204 /*
205 -----------------------------------------------------------------
206 FILE INFORMATION
207 -----------------------------------------------------------------
208 
209 file:       Pausable.sol
210 version:    1.0
211 author:     Kevin Brown
212 
213 date:       2018-05-22
214 
215 -----------------------------------------------------------------
216 MODULE DESCRIPTION
217 -----------------------------------------------------------------
218 
219 This contract allows an inheriting contract to be marked as
220 paused. It also defines a modifier which can be used by the
221 inheriting contract to prevent actions while paused.
222 
223 -----------------------------------------------------------------
224 */
225 
226 
227 /**
228  * @title A contract that can be paused by its owner
229  */
230 contract Pausable is Owned {
231     
232     uint public lastPauseTime;
233     bool public paused;
234 
235     /**
236      * @dev Constructor
237      * @param _owner The account which controls this contract.
238      */
239     constructor(address _owner)
240         Owned(_owner)
241         public
242     {
243         // Paused will be false, and lastPauseTime will be 0 upon initialisation
244     }
245 
246     /**
247      * @notice Change the paused state of the contract
248      * @dev Only the contract owner may call this.
249      */
250     function setPaused(bool _paused)
251         external
252         onlyOwner
253     {
254         // Ensure we're actually changing the state before we do anything
255         if (_paused == paused) {
256             return;
257         }
258 
259         // Set our paused state.
260         paused = _paused;
261         
262         // If applicable, set the last pause time.
263         if (paused) {
264             lastPauseTime = now;
265         }
266 
267         // Let everyone know that our pause state has changed.
268         emit PauseChanged(paused);
269     }
270 
271     event PauseChanged(bool isPaused);
272 
273     modifier notPaused {
274         require(!paused, "This action cannot be performed while the contract is paused");
275         _;
276     }
277 }
278 
279 
280 /**
281  * @title SafeMath
282  * @dev Math operations with safety checks that revert on error
283  */
284 library SafeMath {
285 
286   /**
287   * @dev Multiplies two numbers, reverts on overflow.
288   */
289   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
290     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
291     // benefit is lost if 'b' is also tested.
292     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
293     if (a == 0) {
294       return 0;
295     }
296 
297     uint256 c = a * b;
298     require(c / a == b);
299 
300     return c;
301   }
302 
303   /**
304   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
305   */
306   function div(uint256 a, uint256 b) internal pure returns (uint256) {
307     require(b > 0); // Solidity only automatically asserts when dividing by 0
308     uint256 c = a / b;
309     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
310 
311     return c;
312   }
313 
314   /**
315   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
316   */
317   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
318     require(b <= a);
319     uint256 c = a - b;
320 
321     return c;
322   }
323 
324   /**
325   * @dev Adds two numbers, reverts on overflow.
326   */
327   function add(uint256 a, uint256 b) internal pure returns (uint256) {
328     uint256 c = a + b;
329     require(c >= a);
330 
331     return c;
332   }
333 
334   /**
335   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
336   * reverts when dividing by zero.
337   */
338   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
339     require(b != 0);
340     return a % b;
341   }
342 }
343 
344 
345 /*
346 
347 -----------------------------------------------------------------
348 FILE INFORMATION
349 -----------------------------------------------------------------
350 
351 file:       SafeDecimalMath.sol
352 version:    2.0
353 author:     Kevin Brown
354             Gavin Conway
355 date:       2018-10-18
356 
357 -----------------------------------------------------------------
358 MODULE DESCRIPTION
359 -----------------------------------------------------------------
360 
361 A library providing safe mathematical operations for division and
362 multiplication with the capability to round or truncate the results
363 to the nearest increment. Operations can return a standard precision
364 or high precision decimal. High precision decimals are useful for
365 example when attempting to calculate percentages or fractions
366 accurately.
367 
368 -----------------------------------------------------------------
369 */
370 
371 
372 /**
373  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
374  * @dev Functions accepting uints in this contract and derived contracts
375  * are taken to be such fixed point decimals of a specified precision (either standard
376  * or high).
377  */
378 library SafeDecimalMath {
379 
380     using SafeMath for uint;
381 
382     /* Number of decimal places in the representations. */
383     uint8 public constant decimals = 18;
384     uint8 public constant highPrecisionDecimals = 27;
385 
386     /* The number representing 1.0. */
387     uint public constant UNIT = 10 ** uint(decimals);
388 
389     /* The number representing 1.0 for higher fidelity numbers. */
390     uint public constant PRECISE_UNIT = 10 ** uint(highPrecisionDecimals);
391     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10 ** uint(highPrecisionDecimals - decimals);
392 
393     /** 
394      * @return Provides an interface to UNIT.
395      */
396     function unit()
397         external
398         pure
399         returns (uint)
400     {
401         return UNIT;
402     }
403 
404     /** 
405      * @return Provides an interface to PRECISE_UNIT.
406      */
407     function preciseUnit()
408         external
409         pure 
410         returns (uint)
411     {
412         return PRECISE_UNIT;
413     }
414 
415     /**
416      * @return The result of multiplying x and y, interpreting the operands as fixed-point
417      * decimals.
418      * 
419      * @dev A unit factor is divided out after the product of x and y is evaluated,
420      * so that product must be less than 2**256. As this is an integer division,
421      * the internal division always rounds down. This helps save on gas. Rounding
422      * is more expensive on gas.
423      */
424     function multiplyDecimal(uint x, uint y)
425         internal
426         pure
427         returns (uint)
428     {
429         /* Divide by UNIT to remove the extra factor introduced by the product. */
430         return x.mul(y) / UNIT;
431     }
432 
433     /**
434      * @return The result of safely multiplying x and y, interpreting the operands
435      * as fixed-point decimals of the specified precision unit.
436      *
437      * @dev The operands should be in the form of a the specified unit factor which will be
438      * divided out after the product of x and y is evaluated, so that product must be
439      * less than 2**256.
440      *
441      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
442      * Rounding is useful when you need to retain fidelity for small decimal numbers
443      * (eg. small fractions or percentages).
444      */
445     function _multiplyDecimalRound(uint x, uint y, uint precisionUnit)
446         private
447         pure
448         returns (uint)
449     {
450         /* Divide by UNIT to remove the extra factor introduced by the product. */
451         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
452 
453         if (quotientTimesTen % 10 >= 5) {
454             quotientTimesTen += 10;
455         }
456 
457         return quotientTimesTen / 10;
458     }
459 
460     /**
461      * @return The result of safely multiplying x and y, interpreting the operands
462      * as fixed-point decimals of a precise unit.
463      *
464      * @dev The operands should be in the precise unit factor which will be
465      * divided out after the product of x and y is evaluated, so that product must be
466      * less than 2**256.
467      *
468      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
469      * Rounding is useful when you need to retain fidelity for small decimal numbers
470      * (eg. small fractions or percentages).
471      */
472     function multiplyDecimalRoundPrecise(uint x, uint y)
473         internal
474         pure
475         returns (uint)
476     {
477         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
478     }
479 
480     /**
481      * @return The result of safely multiplying x and y, interpreting the operands
482      * as fixed-point decimals of a standard unit.
483      *
484      * @dev The operands should be in the standard unit factor which will be
485      * divided out after the product of x and y is evaluated, so that product must be
486      * less than 2**256.
487      *
488      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
489      * Rounding is useful when you need to retain fidelity for small decimal numbers
490      * (eg. small fractions or percentages).
491      */
492     function multiplyDecimalRound(uint x, uint y)
493         internal
494         pure
495         returns (uint)
496     {
497         return _multiplyDecimalRound(x, y, UNIT);
498     }
499 
500     /**
501      * @return The result of safely dividing x and y. The return value is a high
502      * precision decimal.
503      * 
504      * @dev y is divided after the product of x and the standard precision unit
505      * is evaluated, so the product of x and UNIT must be less than 2**256. As
506      * this is an integer division, the result is always rounded down.
507      * This helps save on gas. Rounding is more expensive on gas.
508      */
509     function divideDecimal(uint x, uint y)
510         internal
511         pure
512         returns (uint)
513     {
514         /* Reintroduce the UNIT factor that will be divided out by y. */
515         return x.mul(UNIT).div(y);
516     }
517 
518     /**
519      * @return The result of safely dividing x and y. The return value is as a rounded
520      * decimal in the precision unit specified in the parameter.
521      *
522      * @dev y is divided after the product of x and the specified precision unit
523      * is evaluated, so the product of x and the specified precision unit must
524      * be less than 2**256. The result is rounded to the nearest increment.
525      */
526     function _divideDecimalRound(uint x, uint y, uint precisionUnit)
527         private
528         pure
529         returns (uint)
530     {
531         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
532 
533         if (resultTimesTen % 10 >= 5) {
534             resultTimesTen += 10;
535         }
536 
537         return resultTimesTen / 10;
538     }
539 
540     /**
541      * @return The result of safely dividing x and y. The return value is as a rounded
542      * standard precision decimal.
543      *
544      * @dev y is divided after the product of x and the standard precision unit
545      * is evaluated, so the product of x and the standard precision unit must
546      * be less than 2**256. The result is rounded to the nearest increment.
547      */
548     function divideDecimalRound(uint x, uint y)
549         internal
550         pure
551         returns (uint)
552     {
553         return _divideDecimalRound(x, y, UNIT);
554     }
555 
556     /**
557      * @return The result of safely dividing x and y. The return value is as a rounded
558      * high precision decimal.
559      *
560      * @dev y is divided after the product of x and the high precision unit
561      * is evaluated, so the product of x and the high precision unit must
562      * be less than 2**256. The result is rounded to the nearest increment.
563      */
564     function divideDecimalRoundPrecise(uint x, uint y)
565         internal
566         pure
567         returns (uint)
568     {
569         return _divideDecimalRound(x, y, PRECISE_UNIT);
570     }
571 
572     /**
573      * @dev Convert a standard decimal representation to a high precision one.
574      */
575     function decimalToPreciseDecimal(uint i)
576         internal
577         pure
578         returns (uint)
579     {
580         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
581     }
582 
583     /**
584      * @dev Convert a high precision decimal to a standard decimal representation.
585      */
586     function preciseDecimalToDecimal(uint i)
587         internal
588         pure
589         returns (uint)
590     {
591         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
592 
593         if (quotientTimesTen % 10 >= 5) {
594             quotientTimesTen += 10;
595         }
596 
597         return quotientTimesTen / 10;
598     }
599 
600 }
601 
602 
603 /*
604 -----------------------------------------------------------------
605 FILE INFORMATION
606 -----------------------------------------------------------------
607 
608 file:       Proxy.sol
609 version:    1.3
610 author:     Anton Jurisevic
611 
612 date:       2018-05-29
613 
614 -----------------------------------------------------------------
615 MODULE DESCRIPTION
616 -----------------------------------------------------------------
617 
618 A proxy contract that, if it does not recognise the function
619 being called on it, passes all value and call data to an
620 underlying target contract.
621 
622 This proxy has the capacity to toggle between DELEGATECALL
623 and CALL style proxy functionality.
624 
625 The former executes in the proxy's context, and so will preserve 
626 msg.sender and store data at the proxy address. The latter will not.
627 Therefore, any contract the proxy wraps in the CALL style must
628 implement the Proxyable interface, in order that it can pass msg.sender
629 into the underlying contract as the state parameter, messageSender.
630 
631 -----------------------------------------------------------------
632 */
633 
634 
635 contract Proxy is Owned {
636 
637     Proxyable public target;
638     bool public useDELEGATECALL;
639 
640     constructor(address _owner)
641         Owned(_owner)
642         public
643     {}
644 
645     function setTarget(Proxyable _target)
646         external
647         onlyOwner
648     {
649         target = _target;
650         emit TargetUpdated(_target);
651     }
652 
653     function setUseDELEGATECALL(bool value) 
654         external
655         onlyOwner
656     {
657         useDELEGATECALL = value;
658     }
659 
660     function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)
661         external
662         onlyTarget
663     {
664         uint size = callData.length;
665         bytes memory _callData = callData;
666 
667         assembly {
668             /* The first 32 bytes of callData contain its length (as specified by the abi). 
669              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
670              * in length. It is also leftpadded to be a multiple of 32 bytes.
671              * This means moving call_data across 32 bytes guarantees we correctly access
672              * the data itself. */
673             switch numTopics
674             case 0 {
675                 log0(add(_callData, 32), size)
676             } 
677             case 1 {
678                 log1(add(_callData, 32), size, topic1)
679             }
680             case 2 {
681                 log2(add(_callData, 32), size, topic1, topic2)
682             }
683             case 3 {
684                 log3(add(_callData, 32), size, topic1, topic2, topic3)
685             }
686             case 4 {
687                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
688             }
689         }
690     }
691 
692     function()
693         external
694         payable
695     {
696         if (useDELEGATECALL) {
697             assembly {
698                 /* Copy call data into free memory region. */
699                 let free_ptr := mload(0x40)
700                 calldatacopy(free_ptr, 0, calldatasize)
701 
702                 /* Forward all gas and call data to the target contract. */
703                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
704                 returndatacopy(free_ptr, 0, returndatasize)
705 
706                 /* Revert if the call failed, otherwise return the result. */
707                 if iszero(result) { revert(free_ptr, returndatasize) }
708                 return(free_ptr, returndatasize)
709             }
710         } else {
711             /* Here we are as above, but must send the messageSender explicitly 
712              * since we are using CALL rather than DELEGATECALL. */
713             target.setMessageSender(msg.sender);
714             assembly {
715                 let free_ptr := mload(0x40)
716                 calldatacopy(free_ptr, 0, calldatasize)
717 
718                 /* We must explicitly forward ether to the underlying contract as well. */
719                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
720                 returndatacopy(free_ptr, 0, returndatasize)
721 
722                 if iszero(result) { revert(free_ptr, returndatasize) }
723                 return(free_ptr, returndatasize)
724             }
725         }
726     }
727 
728     modifier onlyTarget {
729         require(Proxyable(msg.sender) == target, "Must be proxy target");
730         _;
731     }
732 
733     event TargetUpdated(Proxyable newTarget);
734 }
735 
736 
737 /*
738 -----------------------------------------------------------------
739 FILE INFORMATION
740 -----------------------------------------------------------------
741 
742 file:       Proxyable.sol
743 version:    1.1
744 author:     Anton Jurisevic
745 
746 date:       2018-05-15
747 
748 checked:    Mike Spain
749 approved:   Samuel Brooks
750 
751 -----------------------------------------------------------------
752 MODULE DESCRIPTION
753 -----------------------------------------------------------------
754 
755 A proxyable contract that works hand in hand with the Proxy contract
756 to allow for anyone to interact with the underlying contract both
757 directly and through the proxy.
758 
759 -----------------------------------------------------------------
760 */
761 
762 
763 // This contract should be treated like an abstract contract
764 contract Proxyable is Owned {
765     /* The proxy this contract exists behind. */
766     Proxy public proxy;
767 
768     /* The caller of the proxy, passed through to this contract.
769      * Note that every function using this member must apply the onlyProxy or
770      * optionalProxy modifiers, otherwise their invocations can use stale values. */ 
771     address messageSender; 
772 
773     constructor(address _proxy, address _owner)
774         Owned(_owner)
775         public
776     {
777         proxy = Proxy(_proxy);
778         emit ProxyUpdated(_proxy);
779     }
780 
781     function setProxy(address _proxy)
782         external
783         onlyOwner
784     {
785         proxy = Proxy(_proxy);
786         emit ProxyUpdated(_proxy);
787     }
788 
789     function setMessageSender(address sender)
790         external
791         onlyProxy
792     {
793         messageSender = sender;
794     }
795 
796     modifier onlyProxy {
797         require(Proxy(msg.sender) == proxy, "Only the proxy can call this function");
798         _;
799     }
800 
801     modifier optionalProxy
802     {
803         if (Proxy(msg.sender) != proxy) {
804             messageSender = msg.sender;
805         }
806         _;
807     }
808 
809     modifier optionalProxy_onlyOwner
810     {
811         if (Proxy(msg.sender) != proxy) {
812             messageSender = msg.sender;
813         }
814         require(messageSender == owner, "This action can only be performed by the owner");
815         _;
816     }
817 
818     event ProxyUpdated(address proxyAddress);
819 }
820 
821 
822 /*
823 -----------------------------------------------------------------
824 FILE INFORMATION
825 -----------------------------------------------------------------
826 
827 file:       State.sol
828 version:    1.1
829 author:     Dominic Romanowski
830             Anton Jurisevic
831 
832 date:       2018-05-15
833 
834 -----------------------------------------------------------------
835 MODULE DESCRIPTION
836 -----------------------------------------------------------------
837 
838 This contract is used side by side with external state token
839 contracts, such as Synthetix and Synth.
840 It provides an easy way to upgrade contract logic while
841 maintaining all user balances and allowances. This is designed
842 to make the changeover as easy as possible, since mappings
843 are not so cheap or straightforward to migrate.
844 
845 The first deployed contract would create this state contract,
846 using it as its store of balances.
847 When a new contract is deployed, it links to the existing
848 state contract, whose owner would then change its associated
849 contract to the new one.
850 
851 -----------------------------------------------------------------
852 */
853 
854 
855 contract State is Owned {
856     // the address of the contract that can modify variables
857     // this can only be changed by the owner of this contract
858     address public associatedContract;
859 
860 
861     constructor(address _owner, address _associatedContract)
862         Owned(_owner)
863         public
864     {
865         associatedContract = _associatedContract;
866         emit AssociatedContractUpdated(_associatedContract);
867     }
868 
869     /* ========== SETTERS ========== */
870 
871     // Change the associated contract to a new address
872     function setAssociatedContract(address _associatedContract)
873         external
874         onlyOwner
875     {
876         associatedContract = _associatedContract;
877         emit AssociatedContractUpdated(_associatedContract);
878     }
879 
880     /* ========== MODIFIERS ========== */
881 
882     modifier onlyAssociatedContract
883     {
884         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
885         _;
886     }
887 
888     /* ========== EVENTS ========== */
889 
890     event AssociatedContractUpdated(address associatedContract);
891 }
892 
893 
894 /*
895 -----------------------------------------------------------------
896 FILE INFORMATION
897 -----------------------------------------------------------------
898 
899 file:       TokenState.sol
900 version:    1.1
901 author:     Dominic Romanowski
902             Anton Jurisevic
903 
904 date:       2018-05-15
905 
906 -----------------------------------------------------------------
907 MODULE DESCRIPTION
908 -----------------------------------------------------------------
909 
910 A contract that holds the state of an ERC20 compliant token.
911 
912 This contract is used side by side with external state token
913 contracts, such as Synthetix and Synth.
914 It provides an easy way to upgrade contract logic while
915 maintaining all user balances and allowances. This is designed
916 to make the changeover as easy as possible, since mappings
917 are not so cheap or straightforward to migrate.
918 
919 The first deployed contract would create this state contract,
920 using it as its store of balances.
921 When a new contract is deployed, it links to the existing
922 state contract, whose owner would then change its associated
923 contract to the new one.
924 
925 -----------------------------------------------------------------
926 */
927 
928 
929 /**
930  * @title ERC20 Token State
931  * @notice Stores balance information of an ERC20 token contract.
932  */
933 contract TokenState is State {
934 
935     /* ERC20 fields. */
936     mapping(address => uint) public balanceOf;
937     mapping(address => mapping(address => uint)) public allowance;
938 
939     /**
940      * @dev Constructor
941      * @param _owner The address which controls this contract.
942      * @param _associatedContract The ERC20 contract whose state this composes.
943      */
944     constructor(address _owner, address _associatedContract)
945         State(_owner, _associatedContract)
946         public
947     {}
948 
949     /* ========== SETTERS ========== */
950 
951     /**
952      * @notice Set ERC20 allowance.
953      * @dev Only the associated contract may call this.
954      * @param tokenOwner The authorising party.
955      * @param spender The authorised party.
956      * @param value The total value the authorised party may spend on the
957      * authorising party's behalf.
958      */
959     function setAllowance(address tokenOwner, address spender, uint value)
960         external
961         onlyAssociatedContract
962     {
963         allowance[tokenOwner][spender] = value;
964     }
965 
966     /**
967      * @notice Set the balance in a given account
968      * @dev Only the associated contract may call this.
969      * @param account The account whose value to set.
970      * @param value The new balance of the given account.
971      */
972     function setBalanceOf(address account, uint value)
973         external
974         onlyAssociatedContract
975     {
976         balanceOf[account] = value;
977     }
978 }
979 
980 
981 /*
982 -----------------------------------------------------------------
983 FILE INFORMATION
984 -----------------------------------------------------------------
985 
986 file:       ExternStateToken.sol
987 version:    1.0
988 author:     Kevin Brown
989 date:       2018-08-06
990 
991 -----------------------------------------------------------------
992 MODULE DESCRIPTION
993 -----------------------------------------------------------------
994 
995 This contract offers a modifer that can prevent reentrancy on
996 particular actions. It will not work if you put it on multiple
997 functions that can be called from each other. Specifically guard
998 external entry points to the contract with the modifier only.
999 
1000 -----------------------------------------------------------------
1001 */
1002 
1003 
1004 contract ReentrancyPreventer {
1005     /* ========== MODIFIERS ========== */
1006     bool isInFunctionBody = false;
1007 
1008     modifier preventReentrancy {
1009         require(!isInFunctionBody, "Reverted to prevent reentrancy");
1010         isInFunctionBody = true;
1011         _;
1012         isInFunctionBody = false;
1013     }
1014 }
1015 
1016 /*
1017 -----------------------------------------------------------------
1018 FILE INFORMATION
1019 -----------------------------------------------------------------
1020 
1021 file:       TokenFallback.sol
1022 version:    1.0
1023 author:     Kevin Brown
1024 date:       2018-08-10
1025 
1026 -----------------------------------------------------------------
1027 MODULE DESCRIPTION
1028 -----------------------------------------------------------------
1029 
1030 This contract provides the logic that's used to call tokenFallback()
1031 when transfers happen.
1032 
1033 It's pulled out into its own module because it's needed in two
1034 places, so instead of copy/pasting this logic and maininting it
1035 both in Fee Token and Extern State Token, it's here and depended
1036 on by both contracts.
1037 
1038 -----------------------------------------------------------------
1039 */
1040 
1041 
1042 contract TokenFallbackCaller is ReentrancyPreventer {
1043     function callTokenFallbackIfNeeded(address sender, address recipient, uint amount, bytes data)
1044         internal
1045         preventReentrancy
1046     {
1047         /*
1048             If we're transferring to a contract and it implements the tokenFallback function, call it.
1049             This isn't ERC223 compliant because we don't revert if the contract doesn't implement tokenFallback.
1050             This is because many DEXes and other contracts that expect to work with the standard
1051             approve / transferFrom workflow don't implement tokenFallback but can still process our tokens as
1052             usual, so it feels very harsh and likely to cause trouble if we add this restriction after having
1053             previously gone live with a vanilla ERC20.
1054         */
1055 
1056         // Is the to address a contract? We can check the code size on that address and know.
1057         uint length;
1058 
1059         // solium-disable-next-line security/no-inline-assembly
1060         assembly {
1061             // Retrieve the size of the code on the recipient address
1062             length := extcodesize(recipient)
1063         }
1064 
1065         // If there's code there, it's a contract
1066         if (length > 0) {
1067             // Now we need to optionally call tokenFallback(address from, uint value).
1068             // We can't call it the normal way because that reverts when the recipient doesn't implement the function.
1069 
1070             // solium-disable-next-line security/no-low-level-calls
1071             recipient.call(abi.encodeWithSignature("tokenFallback(address,uint256,bytes)", sender, amount, data));
1072 
1073             // And yes, we specifically don't care if this call fails, so we're not checking the return value.
1074         }
1075     }
1076 }
1077 
1078 
1079 /*
1080 -----------------------------------------------------------------
1081 FILE INFORMATION
1082 -----------------------------------------------------------------
1083 
1084 file:       ExternStateToken.sol
1085 version:    1.3
1086 author:     Anton Jurisevic
1087             Dominic Romanowski
1088             Kevin Brown
1089 
1090 date:       2018-05-29
1091 
1092 -----------------------------------------------------------------
1093 MODULE DESCRIPTION
1094 -----------------------------------------------------------------
1095 
1096 A partial ERC20 token contract, designed to operate with a proxy.
1097 To produce a complete ERC20 token, transfer and transferFrom
1098 tokens must be implemented, using the provided _byProxy internal
1099 functions.
1100 This contract utilises an external state for upgradeability.
1101 
1102 -----------------------------------------------------------------
1103 */
1104 
1105 
1106 /**
1107  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
1108  */
1109 contract ExternStateToken is SelfDestructible, Proxyable, TokenFallbackCaller {
1110 
1111     using SafeMath for uint;
1112     using SafeDecimalMath for uint;
1113 
1114     /* ========== STATE VARIABLES ========== */
1115 
1116     /* Stores balances and allowances. */
1117     TokenState public tokenState;
1118 
1119     /* Other ERC20 fields. */
1120     string public name;
1121     string public symbol;
1122     uint public totalSupply;
1123     uint8 public decimals;
1124 
1125     /**
1126      * @dev Constructor.
1127      * @param _proxy The proxy associated with this contract.
1128      * @param _name Token's ERC20 name.
1129      * @param _symbol Token's ERC20 symbol.
1130      * @param _totalSupply The total supply of the token.
1131      * @param _tokenState The TokenState contract address.
1132      * @param _owner The owner of this contract.
1133      */
1134     constructor(address _proxy, TokenState _tokenState,
1135                 string _name, string _symbol, uint _totalSupply,
1136                 uint8 _decimals, address _owner)
1137         SelfDestructible(_owner)
1138         Proxyable(_proxy, _owner)
1139         public
1140     {
1141         tokenState = _tokenState;
1142 
1143         name = _name;
1144         symbol = _symbol;
1145         totalSupply = _totalSupply;
1146         decimals = _decimals;
1147     }
1148 
1149     /* ========== VIEWS ========== */
1150 
1151     /**
1152      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
1153      * @param owner The party authorising spending of their funds.
1154      * @param spender The party spending tokenOwner's funds.
1155      */
1156     function allowance(address owner, address spender)
1157         public
1158         view
1159         returns (uint)
1160     {
1161         return tokenState.allowance(owner, spender);
1162     }
1163 
1164     /**
1165      * @notice Returns the ERC20 token balance of a given account.
1166      */
1167     function balanceOf(address account)
1168         public
1169         view
1170         returns (uint)
1171     {
1172         return tokenState.balanceOf(account);
1173     }
1174 
1175     /* ========== MUTATIVE FUNCTIONS ========== */
1176 
1177     /**
1178      * @notice Set the address of the TokenState contract.
1179      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
1180      * as balances would be unreachable.
1181      */ 
1182     function setTokenState(TokenState _tokenState)
1183         external
1184         optionalProxy_onlyOwner
1185     {
1186         tokenState = _tokenState;
1187         emitTokenStateUpdated(_tokenState);
1188     }
1189 
1190     function _internalTransfer(address from, address to, uint value, bytes data) 
1191         internal
1192         returns (bool)
1193     { 
1194         /* Disallow transfers to irretrievable-addresses. */
1195         require(to != address(0), "Cannot transfer to the 0 address");
1196         require(to != address(this), "Cannot transfer to the underlying contract");
1197         require(to != address(proxy), "Cannot transfer to the proxy contract");
1198 
1199         // Insufficient balance will be handled by the safe subtraction.
1200         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
1201         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
1202 
1203         // If the recipient is a contract, we need to call tokenFallback on it so they can do ERC223
1204         // actions when receiving our tokens. Unlike the standard, however, we don't revert if the
1205         // recipient contract doesn't implement tokenFallback.
1206         callTokenFallbackIfNeeded(from, to, value, data);
1207         
1208         // Emit a standard ERC20 transfer event
1209         emitTransfer(from, to, value);
1210 
1211         return true;
1212     }
1213 
1214     /**
1215      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
1216      * the onlyProxy or optionalProxy modifiers.
1217      */
1218     function _transfer_byProxy(address from, address to, uint value, bytes data)
1219         internal
1220         returns (bool)
1221     {
1222         return _internalTransfer(from, to, value, data);
1223     }
1224 
1225     /**
1226      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
1227      * possessing the optionalProxy or optionalProxy modifiers.
1228      */
1229     function _transferFrom_byProxy(address sender, address from, address to, uint value, bytes data)
1230         internal
1231         returns (bool)
1232     {
1233         /* Insufficient allowance will be handled by the safe subtraction. */
1234         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
1235         return _internalTransfer(from, to, value, data);
1236     }
1237 
1238     /**
1239      * @notice Approves spender to transfer on the message sender's behalf.
1240      */
1241     function approve(address spender, uint value)
1242         public
1243         optionalProxy
1244         returns (bool)
1245     {
1246         address sender = messageSender;
1247 
1248         tokenState.setAllowance(sender, spender, value);
1249         emitApproval(sender, spender, value);
1250         return true;
1251     }
1252 
1253     /* ========== EVENTS ========== */
1254 
1255     event Transfer(address indexed from, address indexed to, uint value);
1256     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
1257     function emitTransfer(address from, address to, uint value) internal {
1258         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
1259     }
1260 
1261     event Approval(address indexed owner, address indexed spender, uint value);
1262     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
1263     function emitApproval(address owner, address spender, uint value) internal {
1264         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
1265     }
1266 
1267     event TokenStateUpdated(address newTokenState);
1268     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
1269     function emitTokenStateUpdated(address newTokenState) internal {
1270         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
1271     }
1272 }
1273 
1274 
1275 /*
1276 -----------------------------------------------------------------
1277 FILE INFORMATION
1278 -----------------------------------------------------------------
1279 
1280 file:       Synth.sol
1281 version:    2.0
1282 author:     Kevin Brown
1283 date:       2018-09-13
1284 
1285 -----------------------------------------------------------------
1286 MODULE DESCRIPTION
1287 -----------------------------------------------------------------
1288 
1289 Synthetix-backed stablecoin contract.
1290 
1291 This contract issues synths, which are tokens that mirror various
1292 flavours of fiat currency.
1293 
1294 Synths are issuable by Synthetix Network Token (SNX) holders who 
1295 have to lock up some value of their SNX to issue S * Cmax synths. 
1296 Where Cmax issome value less than 1.
1297 
1298 A configurable fee is charged on synth transfers and deposited
1299 into a common pot, which Synthetix holders may withdraw from once
1300 per fee period.
1301 
1302 -----------------------------------------------------------------
1303 */
1304 
1305 
1306 contract Synth is ExternStateToken {
1307 
1308     /* ========== STATE VARIABLES ========== */
1309 
1310     FeePool public feePool;
1311     Synthetix public synthetix;
1312 
1313     // Currency key which identifies this Synth to the Synthetix system
1314     bytes4 public currencyKey;
1315 
1316     uint8 constant DECIMALS = 18;
1317 
1318     /* ========== CONSTRUCTOR ========== */
1319 
1320     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, FeePool _feePool,
1321         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey
1322     )
1323         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, 0, DECIMALS, _owner)
1324         public
1325     {
1326         require(_proxy != 0, "_proxy cannot be 0");
1327         require(address(_synthetix) != 0, "_synthetix cannot be 0");
1328         require(address(_feePool) != 0, "_feePool cannot be 0");
1329         require(_owner != 0, "_owner cannot be 0");
1330         require(_synthetix.synths(_currencyKey) == Synth(0), "Currency key is already in use");
1331 
1332         feePool = _feePool;
1333         synthetix = _synthetix;
1334         currencyKey = _currencyKey;
1335     }
1336 
1337     /* ========== SETTERS ========== */
1338 
1339     function setSynthetix(Synthetix _synthetix)
1340         external
1341         optionalProxy_onlyOwner
1342     {
1343         synthetix = _synthetix;
1344         emitSynthetixUpdated(_synthetix);
1345     }
1346 
1347     function setFeePool(FeePool _feePool)
1348         external
1349         optionalProxy_onlyOwner
1350     {
1351         feePool = _feePool;
1352         emitFeePoolUpdated(_feePool);
1353     }
1354 
1355     /* ========== MUTATIVE FUNCTIONS ========== */
1356 
1357     /**
1358      * @notice Override ERC20 transfer function in order to 
1359      * subtract the transaction fee and send it to the fee pool
1360      * for SNX holders to claim. */
1361     function transfer(address to, uint value)
1362         public
1363         optionalProxy
1364         notFeeAddress(messageSender)
1365         returns (bool)
1366     {
1367         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1368         uint fee = value.sub(amountReceived);
1369 
1370         // Send the fee off to the fee pool.
1371         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1372 
1373         // And send their result off to the destination address
1374         bytes memory empty;
1375         return _internalTransfer(messageSender, to, amountReceived, empty);
1376     }
1377 
1378     /**
1379      * @notice Override ERC223 transfer function in order to 
1380      * subtract the transaction fee and send it to the fee pool
1381      * for SNX holders to claim. */
1382     function transfer(address to, uint value, bytes data)
1383         public
1384         optionalProxy
1385         notFeeAddress(messageSender)
1386         returns (bool)
1387     {
1388         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1389         uint fee = value.sub(amountReceived);
1390 
1391         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1392         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1393 
1394         // And send their result off to the destination address
1395         return _internalTransfer(messageSender, to, amountReceived, data);
1396     }
1397 
1398     /**
1399      * @notice Override ERC20 transferFrom function in order to 
1400      * subtract the transaction fee and send it to the fee pool
1401      * for SNX holders to claim. */
1402     function transferFrom(address from, address to, uint value)
1403         public
1404         optionalProxy
1405         notFeeAddress(from)
1406         returns (bool)
1407     {
1408         // The fee is deducted from the amount sent.
1409         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1410         uint fee = value.sub(amountReceived);
1411 
1412         // Reduce the allowance by the amount we're transferring.
1413         // The safeSub call will handle an insufficient allowance.
1414         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1415 
1416         // Send the fee off to the fee pool.
1417         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1418 
1419         bytes memory empty;
1420         return _internalTransfer(from, to, amountReceived, empty);
1421     }
1422 
1423     /**
1424      * @notice Override ERC223 transferFrom function in order to 
1425      * subtract the transaction fee and send it to the fee pool
1426      * for SNX holders to claim. */
1427     function transferFrom(address from, address to, uint value, bytes data)
1428         public
1429         optionalProxy
1430         notFeeAddress(from)
1431         returns (bool)
1432     {
1433         // The fee is deducted from the amount sent.
1434         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1435         uint fee = value.sub(amountReceived);
1436 
1437         // Reduce the allowance by the amount we're transferring.
1438         // The safeSub call will handle an insufficient allowance.
1439         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1440 
1441         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1442         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1443 
1444         return _internalTransfer(from, to, amountReceived, data);
1445     }
1446 
1447     /* Subtract the transfer fee from the senders account so the 
1448      * receiver gets the exact amount specified to send. */
1449     function transferSenderPaysFee(address to, uint value)
1450         public
1451         optionalProxy
1452         notFeeAddress(messageSender)
1453         returns (bool)
1454     {
1455         uint fee = feePool.transferFeeIncurred(value);
1456 
1457         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1458         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1459 
1460         // And send their transfer amount off to the destination address
1461         bytes memory empty;
1462         return _internalTransfer(messageSender, to, value, empty);
1463     }
1464 
1465     /* Subtract the transfer fee from the senders account so the 
1466      * receiver gets the exact amount specified to send. */
1467     function transferSenderPaysFee(address to, uint value, bytes data)
1468         public
1469         optionalProxy
1470         notFeeAddress(messageSender)
1471         returns (bool)
1472     {
1473         uint fee = feePool.transferFeeIncurred(value);
1474 
1475         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1476         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1477 
1478         // And send their transfer amount off to the destination address
1479         return _internalTransfer(messageSender, to, value, data);
1480     }
1481 
1482     /* Subtract the transfer fee from the senders account so the 
1483      * to address receives the exact amount specified to send. */
1484     function transferFromSenderPaysFee(address from, address to, uint value)
1485         public
1486         optionalProxy
1487         notFeeAddress(from)
1488         returns (bool)
1489     {
1490         uint fee = feePool.transferFeeIncurred(value);
1491 
1492         // Reduce the allowance by the amount we're transferring.
1493         // The safeSub call will handle an insufficient allowance.
1494         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
1495 
1496         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1497         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1498 
1499         bytes memory empty;
1500         return _internalTransfer(from, to, value, empty);
1501     }
1502 
1503     /* Subtract the transfer fee from the senders account so the 
1504      * to address receives the exact amount specified to send. */
1505     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
1506         public
1507         optionalProxy
1508         notFeeAddress(from)
1509         returns (bool)
1510     {
1511         uint fee = feePool.transferFeeIncurred(value);
1512 
1513         // Reduce the allowance by the amount we're transferring.
1514         // The safeSub call will handle an insufficient allowance.
1515         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
1516 
1517         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1518         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1519 
1520         return _internalTransfer(from, to, value, data);
1521     }
1522 
1523     // Override our internal transfer to inject preferred currency support
1524     function _internalTransfer(address from, address to, uint value, bytes data)
1525         internal
1526         returns (bool)
1527     {
1528         bytes4 preferredCurrencyKey = synthetix.synthetixState().preferredCurrency(to);
1529 
1530         // Do they have a preferred currency that's not us? If so we need to exchange
1531         if (preferredCurrencyKey != 0 && preferredCurrencyKey != currencyKey) {
1532             return synthetix.synthInitiatedExchange(from, currencyKey, value, preferredCurrencyKey, to);
1533         } else {
1534             // Otherwise we just transfer
1535             return super._internalTransfer(from, to, value, data);
1536         }
1537     }
1538 
1539     // Allow synthetix to issue a certain number of synths from an account.
1540     function issue(address account, uint amount)
1541         external
1542         onlySynthetixOrFeePool
1543     {
1544         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
1545         totalSupply = totalSupply.add(amount);
1546         emitTransfer(address(0), account, amount);
1547         emitIssued(account, amount);
1548     }
1549 
1550     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
1551     function burn(address account, uint amount)
1552         external
1553         onlySynthetixOrFeePool
1554     {
1555         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
1556         totalSupply = totalSupply.sub(amount);
1557         emitTransfer(account, address(0), amount);
1558         emitBurned(account, amount);
1559     }
1560 
1561     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
1562     // exchange as well as transfer
1563     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
1564         external
1565         onlySynthetixOrFeePool
1566     {
1567         bytes memory empty;
1568         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
1569     }
1570 
1571     /* ========== MODIFIERS ========== */
1572 
1573     modifier onlySynthetixOrFeePool() {
1574         bool isSynthetix = msg.sender == address(synthetix);
1575         bool isFeePool = msg.sender == address(feePool);
1576 
1577         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
1578         _;
1579     }
1580 
1581     modifier notFeeAddress(address account) {
1582         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
1583         _;
1584     }
1585 
1586     /* ========== EVENTS ========== */
1587 
1588     event SynthetixUpdated(address newSynthetix);
1589     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
1590     function emitSynthetixUpdated(address newSynthetix) internal {
1591         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
1592     }
1593 
1594     event FeePoolUpdated(address newFeePool);
1595     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
1596     function emitFeePoolUpdated(address newFeePool) internal {
1597         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
1598     }
1599 
1600     event Issued(address indexed account, uint value);
1601     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
1602     function emitIssued(address account, uint value) internal {
1603         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
1604     }
1605 
1606     event Burned(address indexed account, uint value);
1607     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
1608     function emitBurned(address account, uint value) internal {
1609         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
1610     }
1611 }
1612 
1613 
1614 /*
1615 -----------------------------------------------------------------
1616 FILE INFORMATION
1617 -----------------------------------------------------------------
1618 
1619 file:       FeePool.sol
1620 version:    1.0
1621 author:     Kevin Brown
1622 date:       2018-10-15
1623 
1624 -----------------------------------------------------------------
1625 MODULE DESCRIPTION
1626 -----------------------------------------------------------------
1627 
1628 The FeePool is a place for users to interact with the fees that
1629 have been generated from the Synthetix system if they've helped
1630 to create the economy.
1631 
1632 Users stake Synthetix to create Synths. As Synth users transact,
1633 a small fee is deducted from each transaction, which collects
1634 in the fee pool. Fees are immediately converted to XDRs, a type
1635 of reserve currency similar to SDRs used by the IMF:
1636 https://www.imf.org/en/About/Factsheets/Sheets/2016/08/01/14/51/Special-Drawing-Right-SDR
1637 
1638 Users are entitled to withdraw fees from periods that they participated
1639 in fully, e.g. they have to stake before the period starts. They
1640 can withdraw fees for the last 6 periods as a single lump sum.
1641 Currently fee periods are 7 days long, meaning it's assumed
1642 users will withdraw their fees approximately once a month. Fees
1643 which are not withdrawn are redistributed to the whole pool,
1644 enabling these non-claimed fees to go back to the rest of the commmunity.
1645 
1646 Fees can be withdrawn in any synth currency.
1647 
1648 -----------------------------------------------------------------
1649 */
1650 
1651 
1652 contract FeePool is Proxyable, SelfDestructible {
1653 
1654     using SafeMath for uint;
1655     using SafeDecimalMath for uint;
1656 
1657     Synthetix public synthetix;
1658 
1659     // A percentage fee charged on each transfer.
1660     uint public transferFeeRate;
1661 
1662     // Transfer fee may not exceed 10%.
1663     uint constant public MAX_TRANSFER_FEE_RATE = SafeDecimalMath.unit() / 10;
1664 
1665     // A percentage fee charged on each exchange between currencies.
1666     uint public exchangeFeeRate;
1667 
1668     // Exchange fee may not exceed 10%.
1669     uint constant public MAX_EXCHANGE_FEE_RATE = SafeDecimalMath.unit() / 10;
1670 
1671     // The address with the authority to distribute fees.
1672     address public feeAuthority;
1673 
1674     // Where fees are pooled in XDRs.
1675     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
1676 
1677     // This struct represents the issuance activity that's happened in a fee period.
1678     struct FeePeriod {
1679         uint feePeriodId;
1680         uint startingDebtIndex;
1681         uint startTime;
1682         uint feesToDistribute;
1683         uint feesClaimed;
1684     }
1685 
1686     // The last 6 fee periods are all that you can claim from.
1687     // These are stored and managed from [0], such that [0] is always
1688     // the most recent fee period, and [5] is always the oldest fee
1689     // period that users can claim for.
1690     uint8 constant public FEE_PERIOD_LENGTH = 6;
1691     FeePeriod[FEE_PERIOD_LENGTH] public recentFeePeriods;
1692 
1693     // The next fee period will have this ID.
1694     uint public nextFeePeriodId;
1695 
1696     // How long a fee period lasts at a minimum. It is required for the
1697     // fee authority to roll over the periods, so they are not guaranteed
1698     // to roll over at exactly this duration, but the contract enforces
1699     // that they cannot roll over any quicker than this duration.
1700     uint public feePeriodDuration = 1 weeks;
1701 
1702     // The fee period must be between 1 day and 60 days.
1703     uint public constant MIN_FEE_PERIOD_DURATION = 1 days;
1704     uint public constant MAX_FEE_PERIOD_DURATION = 60 days;
1705 
1706     // The last period a user has withdrawn their fees in, identified by the feePeriodId
1707     mapping(address => uint) public lastFeeWithdrawal;
1708 
1709     // Users receive penalties if their collateralisation ratio drifts out of our desired brackets
1710     // We precompute the brackets and penalties to save gas.
1711     uint constant TWENTY_PERCENT = (20 * SafeDecimalMath.unit()) / 100;
1712     uint constant TWENTY_FIVE_PERCENT = (25 * SafeDecimalMath.unit()) / 100;
1713     uint constant THIRTY_PERCENT = (30 * SafeDecimalMath.unit()) / 100;
1714     uint constant FOURTY_PERCENT = (40 * SafeDecimalMath.unit()) / 100;
1715     uint constant FIFTY_PERCENT = (50 * SafeDecimalMath.unit()) / 100;
1716     uint constant SEVENTY_FIVE_PERCENT = (75 * SafeDecimalMath.unit()) / 100;
1717 
1718     constructor(address _proxy, address _owner, Synthetix _synthetix, address _feeAuthority, uint _transferFeeRate, uint _exchangeFeeRate)
1719         SelfDestructible(_owner)
1720         Proxyable(_proxy, _owner)
1721         public
1722     {
1723         // Constructed fee rates should respect the maximum fee rates.
1724         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
1725         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Constructed exchange fee rate should respect the maximum fee rate");
1726 
1727         synthetix = _synthetix;
1728         feeAuthority = _feeAuthority;
1729         transferFeeRate = _transferFeeRate;
1730         exchangeFeeRate = _exchangeFeeRate;
1731 
1732         // Set our initial fee period
1733         recentFeePeriods[0].feePeriodId = 1;
1734         recentFeePeriods[0].startTime = now;
1735         // Gas optimisation: These do not need to be initialised. They start at 0.
1736         // recentFeePeriods[0].startingDebtIndex = 0;
1737         // recentFeePeriods[0].feesToDistribute = 0;
1738 
1739         // And the next one starts at 2.
1740         nextFeePeriodId = 2;
1741     }
1742 
1743     /**
1744      * @notice Set the exchange fee, anywhere within the range 0-10%.
1745      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1746      */
1747     function setExchangeFeeRate(uint _exchangeFeeRate)
1748         external
1749         optionalProxy_onlyOwner
1750     {
1751         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Exchange fee rate must be below MAX_EXCHANGE_FEE_RATE");
1752 
1753         exchangeFeeRate = _exchangeFeeRate;
1754 
1755         emitExchangeFeeUpdated(_exchangeFeeRate);
1756     }
1757 
1758     /**
1759      * @notice Set the transfer fee, anywhere within the range 0-10%.
1760      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1761      */
1762     function setTransferFeeRate(uint _transferFeeRate)
1763         external
1764         optionalProxy_onlyOwner
1765     {
1766         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
1767 
1768         transferFeeRate = _transferFeeRate;
1769 
1770         emitTransferFeeUpdated(_transferFeeRate);
1771     }
1772 
1773     /**
1774      * @notice Set the address of the user/contract responsible for collecting or
1775      * distributing fees.
1776      */
1777     function setFeeAuthority(address _feeAuthority)
1778         external
1779         optionalProxy_onlyOwner
1780     {
1781         feeAuthority = _feeAuthority;
1782 
1783         emitFeeAuthorityUpdated(_feeAuthority);
1784     }
1785 
1786     /**
1787      * @notice Set the fee period duration
1788      */
1789     function setFeePeriodDuration(uint _feePeriodDuration)
1790         external
1791         optionalProxy_onlyOwner
1792     {
1793         require(_feePeriodDuration >= MIN_FEE_PERIOD_DURATION, "New fee period cannot be less than minimum fee period duration");
1794         require(_feePeriodDuration <= MAX_FEE_PERIOD_DURATION, "New fee period cannot be greater than maximum fee period duration");
1795 
1796         feePeriodDuration = _feePeriodDuration;
1797 
1798         emitFeePeriodDurationUpdated(_feePeriodDuration);
1799     }
1800 
1801     /**
1802      * @notice Set the synthetix contract
1803      */
1804     function setSynthetix(Synthetix _synthetix)
1805         external
1806         optionalProxy_onlyOwner
1807     {
1808         require(address(_synthetix) != address(0), "New Synthetix must be non-zero");
1809 
1810         synthetix = _synthetix;
1811 
1812         emitSynthetixUpdated(_synthetix);
1813     }
1814 
1815     /**
1816      * @notice The Synthetix contract informs us when fees are paid.
1817      */
1818     function feePaid(bytes4 currencyKey, uint amount)
1819         external
1820         onlySynthetix
1821     {
1822         uint xdrAmount = synthetix.effectiveValue(currencyKey, amount, "XDR");
1823 
1824         // Which we keep track of in XDRs in our fee pool.
1825         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.add(xdrAmount);
1826     }
1827 
1828     /**
1829      * @notice Close the current fee period and start a new one. Only callable by the fee authority.
1830      */
1831     function closeCurrentFeePeriod()
1832         external
1833         onlyFeeAuthority
1834     {
1835         require(recentFeePeriods[0].startTime <= (now - feePeriodDuration), "It is too early to close the current fee period");
1836 
1837         FeePeriod memory secondLastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 2];
1838         FeePeriod memory lastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 1];
1839 
1840         // Any unclaimed fees from the last period in the array roll back one period.
1841         // Because of the subtraction here, they're effectively proportionally redistributed to those who
1842         // have already claimed from the old period, available in the new period.
1843         // The subtraction is important so we don't create a ticking time bomb of an ever growing
1844         // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
1845         recentFeePeriods[FEE_PERIOD_LENGTH - 2].feesToDistribute = lastFeePeriod.feesToDistribute
1846             .sub(lastFeePeriod.feesClaimed)
1847             .add(secondLastFeePeriod.feesToDistribute);
1848 
1849         // Shift the previous fee periods across to make room for the new one.
1850         // Condition checks for overflow when uint subtracts one from zero
1851         // Could be written with int instead of uint, but then we have to convert everywhere
1852         // so it felt better from a gas perspective to just change the condition to check
1853         // for overflow after subtracting one from zero.
1854         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
1855             uint next = i + 1;
1856 
1857             recentFeePeriods[next].feePeriodId = recentFeePeriods[i].feePeriodId;
1858             recentFeePeriods[next].startingDebtIndex = recentFeePeriods[i].startingDebtIndex;
1859             recentFeePeriods[next].startTime = recentFeePeriods[i].startTime;
1860             recentFeePeriods[next].feesToDistribute = recentFeePeriods[i].feesToDistribute;
1861             recentFeePeriods[next].feesClaimed = recentFeePeriods[i].feesClaimed;
1862         }
1863 
1864         // Clear the first element of the array to make sure we don't have any stale values.
1865         delete recentFeePeriods[0];
1866 
1867         // Open up the new fee period
1868         recentFeePeriods[0].feePeriodId = nextFeePeriodId;
1869         recentFeePeriods[0].startingDebtIndex = synthetix.synthetixState().debtLedgerLength();
1870         recentFeePeriods[0].startTime = now;
1871 
1872         nextFeePeriodId = nextFeePeriodId.add(1);
1873 
1874         emitFeePeriodClosed(recentFeePeriods[1].feePeriodId);
1875     }
1876 
1877     /**
1878     * @notice Claim fees for last period when available or not already withdrawn.
1879     * @param currencyKey Synth currency you wish to receive the fees in.
1880     */
1881     function claimFees(bytes4 currencyKey)
1882         external
1883         optionalProxy
1884         returns (bool)
1885     {
1886         uint availableFees = feesAvailable(messageSender, "XDR");
1887 
1888         require(availableFees > 0, "No fees available for period, or fees already claimed");
1889 
1890         lastFeeWithdrawal[messageSender] = recentFeePeriods[1].feePeriodId;
1891 
1892         // Record the fee payment in our recentFeePeriods
1893         _recordFeePayment(availableFees);
1894 
1895         // Send them their fees
1896         _payFees(messageSender, availableFees, currencyKey);
1897 
1898         emitFeesClaimed(messageSender, availableFees);
1899 
1900         return true;
1901     }
1902 
1903     /**
1904      * @notice Record the fee payment in our recentFeePeriods.
1905      * @param xdrAmount The amout of fees priced in XDRs.
1906      */
1907     function _recordFeePayment(uint xdrAmount)
1908         internal
1909     {
1910         // Don't assign to the parameter
1911         uint remainingToAllocate = xdrAmount;
1912 
1913         // Start at the oldest period and record the amount, moving to newer periods
1914         // until we've exhausted the amount.
1915         // The condition checks for overflow because we're going to 0 with an unsigned int.
1916         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
1917             uint delta = recentFeePeriods[i].feesToDistribute.sub(recentFeePeriods[i].feesClaimed);
1918 
1919             if (delta > 0) {
1920                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
1921                 uint amountInPeriod = delta < remainingToAllocate ? delta : remainingToAllocate;
1922 
1923                 recentFeePeriods[i].feesClaimed = recentFeePeriods[i].feesClaimed.add(amountInPeriod);
1924                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
1925 
1926                 // No need to continue iterating if we've recorded the whole amount;
1927                 if (remainingToAllocate == 0) return;
1928             }
1929         }
1930 
1931         // If we hit this line, we've exhausted our fee periods, but still have more to allocate. Wat?
1932         // If this happens it's a definite bug in the code, so assert instead of require.
1933         assert(remainingToAllocate == 0);
1934     }
1935 
1936     /**
1937     * @notice Send the fees to claiming address.
1938     * @param account The address to send the fees to.
1939     * @param xdrAmount The amount of fees priced in XDRs.
1940     * @param destinationCurrencyKey The synth currency the user wishes to receive their fees in (convert to this currency).
1941     */
1942     function _payFees(address account, uint xdrAmount, bytes4 destinationCurrencyKey)
1943         internal
1944         notFeeAddress(account)
1945     {
1946         require(account != address(0), "Account can't be 0");
1947         require(account != address(this), "Can't send fees to fee pool");
1948         require(account != address(proxy), "Can't send fees to proxy");
1949         require(account != address(synthetix), "Can't send fees to synthetix");
1950 
1951         Synth xdrSynth = synthetix.synths("XDR");
1952         Synth destinationSynth = synthetix.synths(destinationCurrencyKey);
1953 
1954         // Note: We don't need to check the fee pool balance as the burn() below will do a safe subtraction which requires
1955         // the subtraction to not overflow, which would happen if the balance is not sufficient.
1956 
1957         // Burn the source amount
1958         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
1959 
1960         // How much should they get in the destination currency?
1961         uint destinationAmount = synthetix.effectiveValue("XDR", xdrAmount, destinationCurrencyKey);
1962 
1963         // There's no fee on withdrawing fees, as that'd be way too meta.
1964 
1965         // Mint their new synths
1966         destinationSynth.issue(account, destinationAmount);
1967 
1968         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
1969 
1970         // Call the ERC223 transfer callback if needed
1971         destinationSynth.triggerTokenFallbackIfNeeded(FEE_ADDRESS, account, destinationAmount);
1972     }
1973 
1974     /**
1975      * @notice Calculate the Fee charged on top of a value being sent
1976      * @return Return the fee charged
1977      */
1978     function transferFeeIncurred(uint value)
1979         public
1980         view
1981         returns (uint)
1982     {
1983         return value.multiplyDecimal(transferFeeRate);
1984 
1985         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1986         // This is on the basis that transfers less than this value will result in a nil fee.
1987         // Probably too insignificant to worry about, but the following code will achieve it.
1988         //      if (fee == 0 && transferFeeRate != 0) {
1989         //          return _value;
1990         //      }
1991         //      return fee;
1992     }
1993 
1994     /**
1995      * @notice The value that you would need to send so that the recipient receives
1996      * a specified value.
1997      * @param value The value you want the recipient to receive
1998      */
1999     function transferredAmountToReceive(uint value)
2000         external
2001         view
2002         returns (uint)
2003     {
2004         return value.add(transferFeeIncurred(value));
2005     }
2006 
2007     /**
2008      * @notice The amount the recipient will receive if you send a certain number of tokens.
2009      * @param value The amount of tokens you intend to send.
2010      */
2011     function amountReceivedFromTransfer(uint value)
2012         external
2013         view
2014         returns (uint)
2015     {
2016         return value.divideDecimal(transferFeeRate.add(SafeDecimalMath.unit()));
2017     }
2018 
2019     /**
2020      * @notice Calculate the fee charged on top of a value being sent via an exchange
2021      * @return Return the fee charged
2022      */
2023     function exchangeFeeIncurred(uint value)
2024         public
2025         view
2026         returns (uint)
2027     {
2028         return value.multiplyDecimal(exchangeFeeRate);
2029 
2030         // Exchanges less than the reciprocal of exchangeFeeRate should be completely eaten up by fees.
2031         // This is on the basis that exchanges less than this value will result in a nil fee.
2032         // Probably too insignificant to worry about, but the following code will achieve it.
2033         //      if (fee == 0 && exchangeFeeRate != 0) {
2034         //          return _value;
2035         //      }
2036         //      return fee;
2037     }
2038 
2039     /**
2040      * @notice The value that you would need to get after currency exchange so that the recipient receives
2041      * a specified value.
2042      * @param value The value you want the recipient to receive
2043      */
2044     function exchangedAmountToReceive(uint value)
2045         external
2046         view
2047         returns (uint)
2048     {
2049         return value.add(exchangeFeeIncurred(value));
2050     }
2051 
2052     /**
2053      * @notice The amount the recipient will receive if you are performing an exchange and the
2054      * destination currency will be worth a certain number of tokens.
2055      * @param value The amount of destination currency tokens they received after the exchange.
2056      */
2057     function amountReceivedFromExchange(uint value)
2058         external
2059         view
2060         returns (uint)
2061     {
2062         return value.divideDecimal(exchangeFeeRate.add(SafeDecimalMath.unit()));
2063     }
2064 
2065     /**
2066      * @notice The total fees available in the system to be withdrawn, priced in currencyKey currency
2067      * @param currencyKey The currency you want to price the fees in
2068      */
2069     function totalFeesAvailable(bytes4 currencyKey)
2070         external
2071         view
2072         returns (uint)
2073     {
2074         uint totalFees = 0;
2075 
2076         // Fees in fee period [0] are not yet available for withdrawal
2077         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
2078             totalFees = totalFees.add(recentFeePeriods[i].feesToDistribute);
2079             totalFees = totalFees.sub(recentFeePeriods[i].feesClaimed);
2080         }
2081 
2082         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
2083     }
2084 
2085     /**
2086      * @notice The fees available to be withdrawn by a specific account, priced in currencyKey currency
2087      * @param currencyKey The currency you want to price the fees in
2088      */
2089     function feesAvailable(address account, bytes4 currencyKey)
2090         public
2091         view
2092         returns (uint)
2093     {
2094         // Add up the fees
2095         uint[FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);
2096 
2097         uint totalFees = 0;
2098 
2099         // Fees in fee period [0] are not yet available for withdrawal
2100         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
2101             totalFees = totalFees.add(userFees[i]);
2102         }
2103 
2104         // And convert them to their desired currency
2105         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
2106     }
2107 
2108     /**
2109      * @notice The penalty a particular address would incur if its fees were withdrawn right now
2110      * @param account The address you want to query the penalty for
2111      */
2112     function currentPenalty(address account)
2113         public
2114         view
2115         returns (uint)
2116     {
2117         uint ratio = synthetix.collateralisationRatio(account);
2118 
2119         // Users receive a different amount of fees depending on how their collateralisation ratio looks right now.
2120         // 0% - 20%: Fee is calculated based on percentage of economy issued.
2121         // 20% - 30%: 25% reduction in fees
2122         // 30% - 40%: 50% reduction in fees
2123         // >40%: 75% reduction in fees
2124         if (ratio <= TWENTY_PERCENT) {
2125             return 0;
2126         } else if (ratio > TWENTY_PERCENT && ratio <= THIRTY_PERCENT) {
2127             return TWENTY_FIVE_PERCENT;
2128         } else if (ratio > THIRTY_PERCENT && ratio <= FOURTY_PERCENT) {
2129             return FIFTY_PERCENT;
2130         }
2131 
2132         return SEVENTY_FIVE_PERCENT;
2133     }
2134 
2135     /**
2136      * @notice Calculates fees by period for an account, priced in XDRs
2137      * @param account The address you want to query the fees by penalty for
2138      */
2139     function feesByPeriod(address account)
2140         public
2141         view
2142         returns (uint[FEE_PERIOD_LENGTH])
2143     {
2144         uint[FEE_PERIOD_LENGTH] memory result;
2145 
2146         // What's the user's debt entry index and the debt they owe to the system
2147         uint initialDebtOwnership;
2148         uint debtEntryIndex;
2149         (initialDebtOwnership, debtEntryIndex) = synthetix.synthetixState().issuanceData(account);
2150 
2151         // If they don't have any debt ownership, they don't have any fees
2152         if (initialDebtOwnership == 0) return result;
2153 
2154         // If there are no XDR synths, then they don't have any fees
2155         uint totalSynths = synthetix.totalIssuedSynths("XDR");
2156         if (totalSynths == 0) return result;
2157 
2158         uint debtBalance = synthetix.debtBalanceOf(account, "XDR");
2159         uint userOwnershipPercentage = debtBalance.divideDecimal(totalSynths);
2160         uint penalty = currentPenalty(account);
2161         
2162         // Go through our fee periods and figure out what we owe them.
2163         // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
2164         // fees owing for, so we need to report on it anyway.
2165         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
2166             // Were they a part of this period in its entirety?
2167             // We don't allow pro-rata participation to reduce the ability to game the system by
2168             // issuing and burning multiple times in a period or close to the ends of periods.
2169             if (recentFeePeriods[i].startingDebtIndex > debtEntryIndex &&
2170                 lastFeeWithdrawal[account] < recentFeePeriods[i].feePeriodId) {
2171 
2172                 // And since they were, they're entitled to their percentage of the fees in this period
2173                 uint feesFromPeriodWithoutPenalty = recentFeePeriods[i].feesToDistribute
2174                     .multiplyDecimal(userOwnershipPercentage);
2175 
2176                 // Less their penalty if they have one.
2177                 uint penaltyFromPeriod = feesFromPeriodWithoutPenalty.multiplyDecimal(penalty);
2178                 uint feesFromPeriod = feesFromPeriodWithoutPenalty.sub(penaltyFromPeriod);
2179 
2180                 result[i] = feesFromPeriod;
2181             }
2182         }
2183 
2184         return result;
2185     }
2186 
2187     modifier onlyFeeAuthority
2188     {
2189         require(msg.sender == feeAuthority, "Only the fee authority can perform this action");
2190         _;
2191     }
2192 
2193     modifier onlySynthetix
2194     {
2195         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
2196         _;
2197     }
2198 
2199     modifier notFeeAddress(address account) {
2200         require(account != FEE_ADDRESS, "Fee address not allowed");
2201         _;
2202     }
2203 
2204     event TransferFeeUpdated(uint newFeeRate);
2205     bytes32 constant TRANSFERFEEUPDATED_SIG = keccak256("TransferFeeUpdated(uint256)");
2206     function emitTransferFeeUpdated(uint newFeeRate) internal {
2207         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEEUPDATED_SIG, 0, 0, 0);
2208     }
2209 
2210     event ExchangeFeeUpdated(uint newFeeRate);
2211     bytes32 constant EXCHANGEFEEUPDATED_SIG = keccak256("ExchangeFeeUpdated(uint256)");
2212     function emitExchangeFeeUpdated(uint newFeeRate) internal {
2213         proxy._emit(abi.encode(newFeeRate), 1, EXCHANGEFEEUPDATED_SIG, 0, 0, 0);
2214     }
2215 
2216     event FeePeriodDurationUpdated(uint newFeePeriodDuration);
2217     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
2218     function emitFeePeriodDurationUpdated(uint newFeePeriodDuration) internal {
2219         proxy._emit(abi.encode(newFeePeriodDuration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
2220     }
2221 
2222     event FeeAuthorityUpdated(address newFeeAuthority);
2223     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
2224     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
2225         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
2226     }
2227 
2228     event FeePeriodClosed(uint feePeriodId);
2229     bytes32 constant FEEPERIODCLOSED_SIG = keccak256("FeePeriodClosed(uint256)");
2230     function emitFeePeriodClosed(uint feePeriodId) internal {
2231         proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
2232     }
2233 
2234     event FeesClaimed(address account, uint xdrAmount);
2235     bytes32 constant FEESCLAIMED_SIG = keccak256("FeesClaimed(address,uint256)");
2236     function emitFeesClaimed(address account, uint xdrAmount) internal {
2237         proxy._emit(abi.encode(account, xdrAmount), 1, FEESCLAIMED_SIG, 0, 0, 0);
2238     }
2239 
2240     event SynthetixUpdated(address newSynthetix);
2241     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
2242     function emitSynthetixUpdated(address newSynthetix) internal {
2243         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
2244     }
2245 }
2246 
2247 
2248 /*
2249 -----------------------------------------------------------------
2250 FILE INFORMATION
2251 -----------------------------------------------------------------
2252 
2253 file:       LimitedSetup.sol
2254 version:    1.1
2255 author:     Anton Jurisevic
2256 
2257 date:       2018-05-15
2258 
2259 -----------------------------------------------------------------
2260 MODULE DESCRIPTION
2261 -----------------------------------------------------------------
2262 
2263 A contract with a limited setup period. Any function modified
2264 with the setup modifier will cease to work after the
2265 conclusion of the configurable-length post-construction setup period.
2266 
2267 -----------------------------------------------------------------
2268 */
2269 
2270 
2271 /**
2272  * @title Any function decorated with the modifier this contract provides
2273  * deactivates after a specified setup period.
2274  */
2275 contract LimitedSetup {
2276 
2277     uint setupExpiryTime;
2278 
2279     /**
2280      * @dev LimitedSetup Constructor.
2281      * @param setupDuration The time the setup period will last for.
2282      */
2283     constructor(uint setupDuration)
2284         public
2285     {
2286         setupExpiryTime = now + setupDuration;
2287     }
2288 
2289     modifier onlyDuringSetup
2290     {
2291         require(now < setupExpiryTime, "Can only perform this action during setup");
2292         _;
2293     }
2294 }
2295 
2296 
2297 /*
2298 -----------------------------------------------------------------
2299 FILE INFORMATION
2300 -----------------------------------------------------------------
2301 
2302 file:       SynthetixEscrow.sol
2303 version:    1.1
2304 author:     Anton Jurisevic
2305             Dominic Romanowski
2306             Mike Spain
2307 
2308 date:       2018-05-29
2309 
2310 -----------------------------------------------------------------
2311 MODULE DESCRIPTION
2312 -----------------------------------------------------------------
2313 
2314 This contract allows the foundation to apply unique vesting
2315 schedules to synthetix funds sold at various discounts in the token
2316 sale. SynthetixEscrow gives users the ability to inspect their
2317 vested funds, their quantities and vesting dates, and to withdraw
2318 the fees that accrue on those funds.
2319 
2320 The fees are handled by withdrawing the entire fee allocation
2321 for all SNX inside the escrow contract, and then allowing
2322 the contract itself to subdivide that pool up proportionally within
2323 itself. Every time the fee period rolls over in the main Synthetix
2324 contract, the SynthetixEscrow fee pool is remitted back into the
2325 main fee pool to be redistributed in the next fee period.
2326 
2327 -----------------------------------------------------------------
2328 */
2329 
2330 
2331 /**
2332  * @title A contract to hold escrowed SNX and free them at given schedules.
2333  */
2334 contract SynthetixEscrow is Owned, LimitedSetup(8 weeks) {
2335 
2336     using SafeMath for uint;
2337 
2338     /* The corresponding Synthetix contract. */
2339     Synthetix public synthetix;
2340 
2341     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
2342      * These are the times at which each given quantity of SNX vests. */
2343     mapping(address => uint[2][]) public vestingSchedules;
2344 
2345     /* An account's total vested synthetix balance to save recomputing this for fee extraction purposes. */
2346     mapping(address => uint) public totalVestedAccountBalance;
2347 
2348     /* The total remaining vested balance, for verifying the actual synthetix balance of this contract against. */
2349     uint public totalVestedBalance;
2350 
2351     uint constant TIME_INDEX = 0;
2352     uint constant QUANTITY_INDEX = 1;
2353 
2354     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
2355     uint constant MAX_VESTING_ENTRIES = 20;
2356 
2357 
2358     /* ========== CONSTRUCTOR ========== */
2359 
2360     constructor(address _owner, Synthetix _synthetix)
2361         Owned(_owner)
2362         public
2363     {
2364         synthetix = _synthetix;
2365     }
2366 
2367 
2368     /* ========== SETTERS ========== */
2369 
2370     function setSynthetix(Synthetix _synthetix)
2371         external
2372         onlyOwner
2373     {
2374         synthetix = _synthetix;
2375         emit SynthetixUpdated(_synthetix);
2376     }
2377 
2378 
2379     /* ========== VIEW FUNCTIONS ========== */
2380 
2381     /**
2382      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
2383      */
2384     function balanceOf(address account)
2385         public
2386         view
2387         returns (uint)
2388     {
2389         return totalVestedAccountBalance[account];
2390     }
2391 
2392     /**
2393      * @notice The number of vesting dates in an account's schedule.
2394      */
2395     function numVestingEntries(address account)
2396         public
2397         view
2398         returns (uint)
2399     {
2400         return vestingSchedules[account].length;
2401     }
2402 
2403     /**
2404      * @notice Get a particular schedule entry for an account.
2405      * @return A pair of uints: (timestamp, synthetix quantity).
2406      */
2407     function getVestingScheduleEntry(address account, uint index)
2408         public
2409         view
2410         returns (uint[2])
2411     {
2412         return vestingSchedules[account][index];
2413     }
2414 
2415     /**
2416      * @notice Get the time at which a given schedule entry will vest.
2417      */
2418     function getVestingTime(address account, uint index)
2419         public
2420         view
2421         returns (uint)
2422     {
2423         return getVestingScheduleEntry(account,index)[TIME_INDEX];
2424     }
2425 
2426     /**
2427      * @notice Get the quantity of SNX associated with a given schedule entry.
2428      */
2429     function getVestingQuantity(address account, uint index)
2430         public
2431         view
2432         returns (uint)
2433     {
2434         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
2435     }
2436 
2437     /**
2438      * @notice Obtain the index of the next schedule entry that will vest for a given user.
2439      */
2440     function getNextVestingIndex(address account)
2441         public
2442         view
2443         returns (uint)
2444     {
2445         uint len = numVestingEntries(account);
2446         for (uint i = 0; i < len; i++) {
2447             if (getVestingTime(account, i) != 0) {
2448                 return i;
2449             }
2450         }
2451         return len;
2452     }
2453 
2454     /**
2455      * @notice Obtain the next schedule entry that will vest for a given user.
2456      * @return A pair of uints: (timestamp, synthetix quantity). */
2457     function getNextVestingEntry(address account)
2458         public
2459         view
2460         returns (uint[2])
2461     {
2462         uint index = getNextVestingIndex(account);
2463         if (index == numVestingEntries(account)) {
2464             return [uint(0), 0];
2465         }
2466         return getVestingScheduleEntry(account, index);
2467     }
2468 
2469     /**
2470      * @notice Obtain the time at which the next schedule entry will vest for a given user.
2471      */
2472     function getNextVestingTime(address account)
2473         external
2474         view
2475         returns (uint)
2476     {
2477         return getNextVestingEntry(account)[TIME_INDEX];
2478     }
2479 
2480     /**
2481      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
2482      */
2483     function getNextVestingQuantity(address account)
2484         external
2485         view
2486         returns (uint)
2487     {
2488         return getNextVestingEntry(account)[QUANTITY_INDEX];
2489     }
2490 
2491 
2492     /* ========== MUTATIVE FUNCTIONS ========== */
2493 
2494     /**
2495      * @notice Withdraws a quantity of SNX back to the synthetix contract.
2496      * @dev This may only be called by the owner during the contract's setup period.
2497      */
2498     function withdrawSynthetix(uint quantity)
2499         external
2500         onlyOwner
2501         onlyDuringSetup
2502     {
2503         synthetix.transfer(synthetix, quantity);
2504     }
2505 
2506     /**
2507      * @notice Destroy the vesting information associated with an account.
2508      */
2509     function purgeAccount(address account)
2510         external
2511         onlyOwner
2512         onlyDuringSetup
2513     {
2514         delete vestingSchedules[account];
2515         totalVestedBalance = totalVestedBalance.sub(totalVestedAccountBalance[account]);
2516         delete totalVestedAccountBalance[account];
2517     }
2518 
2519     /**
2520      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
2521      * @dev A call to this should be accompanied by either enough balance already available
2522      * in this contract, or a corresponding call to synthetix.endow(), to ensure that when
2523      * the funds are withdrawn, there is enough balance, as well as correctly calculating
2524      * the fees.
2525      * This may only be called by the owner during the contract's setup period.
2526      * Note; although this function could technically be used to produce unbounded
2527      * arrays, it's only in the foundation's command to add to these lists.
2528      * @param account The account to append a new vesting entry to.
2529      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
2530      * @param quantity The quantity of SNX that will vest.
2531      */
2532     function appendVestingEntry(address account, uint time, uint quantity)
2533         public
2534         onlyOwner
2535         onlyDuringSetup
2536     {
2537         /* No empty or already-passed vesting entries allowed. */
2538         require(now < time, "Time must be in the future");
2539         require(quantity != 0, "Quantity cannot be zero");
2540 
2541         /* There must be enough balance in the contract to provide for the vesting entry. */
2542         totalVestedBalance = totalVestedBalance.add(quantity);
2543         require(totalVestedBalance <= synthetix.balanceOf(this), "Must be enough balance in the contract to provide for the vesting entry");
2544 
2545         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
2546         uint scheduleLength = vestingSchedules[account].length;
2547         require(scheduleLength <= MAX_VESTING_ENTRIES, "Vesting schedule is too long");
2548 
2549         if (scheduleLength == 0) {
2550             totalVestedAccountBalance[account] = quantity;
2551         } else {
2552             /* Disallow adding new vested SNX earlier than the last one.
2553              * Since entries are only appended, this means that no vesting date can be repeated. */
2554             require(getVestingTime(account, numVestingEntries(account) - 1) < time, "Cannot add new vested entries earlier than the last one");
2555             totalVestedAccountBalance[account] = totalVestedAccountBalance[account].add(quantity);
2556         }
2557 
2558         vestingSchedules[account].push([time, quantity]);
2559     }
2560 
2561     /**
2562      * @notice Construct a vesting schedule to release a quantities of SNX
2563      * over a series of intervals.
2564      * @dev Assumes that the quantities are nonzero
2565      * and that the sequence of timestamps is strictly increasing.
2566      * This may only be called by the owner during the contract's setup period.
2567      */
2568     function addVestingSchedule(address account, uint[] times, uint[] quantities)
2569         external
2570         onlyOwner
2571         onlyDuringSetup
2572     {
2573         for (uint i = 0; i < times.length; i++) {
2574             appendVestingEntry(account, times[i], quantities[i]);
2575         }
2576 
2577     }
2578 
2579     /**
2580      * @notice Allow a user to withdraw any SNX in their schedule that have vested.
2581      */
2582     function vest()
2583         external
2584     {
2585         uint numEntries = numVestingEntries(msg.sender);
2586         uint total;
2587         for (uint i = 0; i < numEntries; i++) {
2588             uint time = getVestingTime(msg.sender, i);
2589             /* The list is sorted; when we reach the first future time, bail out. */
2590             if (time > now) {
2591                 break;
2592             }
2593             uint qty = getVestingQuantity(msg.sender, i);
2594             if (qty == 0) {
2595                 continue;
2596             }
2597 
2598             vestingSchedules[msg.sender][i] = [0, 0];
2599             total = total.add(qty);
2600         }
2601 
2602         if (total != 0) {
2603             totalVestedBalance = totalVestedBalance.sub(total);
2604             totalVestedAccountBalance[msg.sender] = totalVestedAccountBalance[msg.sender].sub(total);
2605             synthetix.transfer(msg.sender, total);
2606             emit Vested(msg.sender, now, total);
2607         }
2608     }
2609 
2610 
2611     /* ========== EVENTS ========== */
2612 
2613     event SynthetixUpdated(address newSynthetix);
2614 
2615     event Vested(address indexed beneficiary, uint time, uint value);
2616 }
2617 
2618 
2619 /*
2620 -----------------------------------------------------------------
2621 FILE INFORMATION
2622 -----------------------------------------------------------------
2623 
2624 file:       SynthetixState.sol
2625 version:    1.0
2626 author:     Kevin Brown
2627 date:       2018-10-19
2628 
2629 -----------------------------------------------------------------
2630 MODULE DESCRIPTION
2631 -----------------------------------------------------------------
2632 
2633 A contract that holds issuance state and preferred currency of
2634 users in the Synthetix system.
2635 
2636 This contract is used side by side with the Synthetix contract
2637 to make it easier to upgrade the contract logic while maintaining
2638 issuance state.
2639 
2640 The Synthetix contract is also quite large and on the edge of
2641 being beyond the contract size limit without moving this information
2642 out to another contract.
2643 
2644 The first deployed contract would create this state contract,
2645 using it as its store of issuance data.
2646 
2647 When a new contract is deployed, it links to the existing
2648 state contract, whose owner would then change its associated
2649 contract to the new one.
2650 
2651 -----------------------------------------------------------------
2652 */
2653 
2654 
2655 /**
2656  * @title Synthetix State
2657  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
2658  */
2659 contract SynthetixState is State, LimitedSetup {
2660     using SafeMath for uint;
2661     using SafeDecimalMath for uint;
2662 
2663     // A struct for handing values associated with an individual user's debt position
2664     struct IssuanceData {
2665         // Percentage of the total debt owned at the time
2666         // of issuance. This number is modified by the global debt
2667         // delta array. You can figure out a user's exit price and
2668         // collateralisation ratio using a combination of their initial
2669         // debt and the slice of global debt delta which applies to them.
2670         uint initialDebtOwnership;
2671         // This lets us know when (in relative terms) the user entered
2672         // the debt pool so we can calculate their exit price and
2673         // collateralistion ratio
2674         uint debtEntryIndex;
2675     }
2676 
2677     // Issued synth balances for individual fee entitlements and exit price calculations
2678     mapping(address => IssuanceData) public issuanceData;
2679 
2680     // The total count of people that have outstanding issued synths in any flavour
2681     uint public totalIssuerCount;
2682 
2683     // Global debt pool tracking
2684     uint[] public debtLedger;
2685 
2686     // A quantity of synths greater than this ratio
2687     // may not be issued against a given value of SNX.
2688     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
2689     // No more synths may be issued than the value of SNX backing them.
2690     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
2691 
2692     // Users can specify their preferred currency, in which case all synths they receive
2693     // will automatically exchange to that preferred currency upon receipt in their wallet
2694     mapping(address => bytes4) public preferredCurrency;
2695 
2696     /**
2697      * @dev Constructor
2698      * @param _owner The address which controls this contract.
2699      * @param _associatedContract The ERC20 contract whose state this composes.
2700      */
2701     constructor(address _owner, address _associatedContract)
2702         State(_owner, _associatedContract)
2703         LimitedSetup(1 weeks)
2704         public
2705     {}
2706 
2707     /* ========== SETTERS ========== */
2708 
2709     /**
2710      * @notice Set issuance data for an address
2711      * @dev Only the associated contract may call this.
2712      * @param account The address to set the data for.
2713      * @param initialDebtOwnership The initial debt ownership for this address.
2714      */
2715     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
2716         external
2717         onlyAssociatedContract
2718     {
2719         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
2720         issuanceData[account].debtEntryIndex = debtLedger.length;
2721     }
2722 
2723     /**
2724      * @notice Clear issuance data for an address
2725      * @dev Only the associated contract may call this.
2726      * @param account The address to clear the data for.
2727      */
2728     function clearIssuanceData(address account)
2729         external
2730         onlyAssociatedContract
2731     {
2732         delete issuanceData[account];
2733     }
2734 
2735     /**
2736      * @notice Increment the total issuer count
2737      * @dev Only the associated contract may call this.
2738      */
2739     function incrementTotalIssuerCount()
2740         external
2741         onlyAssociatedContract
2742     {
2743         totalIssuerCount = totalIssuerCount.add(1);
2744     }
2745 
2746     /**
2747      * @notice Decrement the total issuer count
2748      * @dev Only the associated contract may call this.
2749      */
2750     function decrementTotalIssuerCount()
2751         external
2752         onlyAssociatedContract
2753     {
2754         totalIssuerCount = totalIssuerCount.sub(1);
2755     }
2756 
2757     /**
2758      * @notice Append a value to the debt ledger
2759      * @dev Only the associated contract may call this.
2760      * @param value The new value to be added to the debt ledger.
2761      */
2762     function appendDebtLedgerValue(uint value)
2763         external
2764         onlyAssociatedContract
2765     {
2766         debtLedger.push(value);
2767     }
2768 
2769     /**
2770      * @notice Set preferred currency for a user
2771      * @dev Only the associated contract may call this.
2772      * @param account The account to set the preferred currency for
2773      * @param currencyKey The new preferred currency
2774      */
2775     function setPreferredCurrency(address account, bytes4 currencyKey)
2776         external
2777         onlyAssociatedContract
2778     {
2779         preferredCurrency[account] = currencyKey;
2780     }
2781 
2782     /**
2783      * @notice Set the issuanceRatio for issuance calculations.
2784      * @dev Only callable by the contract owner.
2785      */
2786     function setIssuanceRatio(uint _issuanceRatio)
2787         external
2788         onlyOwner
2789     {
2790         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
2791         issuanceRatio = _issuanceRatio;
2792         emit IssuanceRatioUpdated(_issuanceRatio);
2793     }
2794 
2795     /**
2796      * @notice Import issuer data from the old Synthetix contract before multicurrency
2797      * @dev Only callable by the contract owner, and only for 1 week after deployment.
2798      */
2799     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
2800         external
2801         onlyOwner
2802         onlyDuringSetup
2803     {
2804         require(accounts.length == sUSDAmounts.length, "Length mismatch");
2805 
2806         for (uint8 i = 0; i < accounts.length; i++) {
2807             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
2808         }
2809     }
2810 
2811     /**
2812      * @notice Import issuer data from the old Synthetix contract before multicurrency
2813      * @dev Only used from importIssuerData above, meant to be disposable
2814      */
2815     function _addToDebtRegister(address account, uint amount)
2816         internal
2817     {
2818         // This code is duplicated from Synthetix so that we can call it directly here
2819         // during setup only.
2820         Synthetix synthetix = Synthetix(associatedContract);
2821 
2822         // What is the value of the requested debt in XDRs?
2823         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
2824 
2825         // What is the value of all issued synths of the system (priced in XDRs)?
2826         uint totalDebtIssued = synthetix.totalIssuedSynths("XDR");
2827 
2828         // What will the new total be including the new value?
2829         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2830 
2831         // What is their percentage (as a high precision int) of the total debt?
2832         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2833 
2834         // And what effect does this percentage have on the global debt holding of other issuers?
2835         // The delta specifically needs to not take into account any existing debt as it's already
2836         // accounted for in the delta from when they issued previously.
2837         // The delta is a high precision integer.
2838         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2839 
2840         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
2841 
2842         // And what does their debt ownership look like including this previous stake?
2843         if (existingDebt > 0) {
2844             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2845         }
2846 
2847         // Are they a new issuer? If so, record them.
2848         if (issuanceData[account].initialDebtOwnership == 0) {
2849             totalIssuerCount = totalIssuerCount.add(1);
2850         }
2851 
2852         // Save the debt entry parameters
2853         issuanceData[account].initialDebtOwnership = debtPercentage;
2854         issuanceData[account].debtEntryIndex = debtLedger.length;
2855 
2856         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2857         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2858         if (debtLedger.length > 0) {
2859             debtLedger.push(
2860                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2861             );
2862         } else {
2863             debtLedger.push(SafeDecimalMath.preciseUnit());
2864         }
2865     }
2866 
2867     /* ========== VIEWS ========== */
2868 
2869     /**
2870      * @notice Retrieve the length of the debt ledger array
2871      */
2872     function debtLedgerLength()
2873         external
2874         view
2875         returns (uint)
2876     {
2877         return debtLedger.length;
2878     }
2879 
2880     /**
2881      * @notice Retrieve the most recent entry from the debt ledger
2882      */
2883     function lastDebtLedgerEntry()
2884         external
2885         view
2886         returns (uint)
2887     {
2888         return debtLedger[debtLedger.length - 1];
2889     }
2890 
2891     /**
2892      * @notice Query whether an account has issued and has an outstanding debt balance
2893      * @param account The address to query for
2894      */
2895     function hasIssued(address account)
2896         external
2897         view
2898         returns (bool)
2899     {
2900         return issuanceData[account].initialDebtOwnership > 0;
2901     }
2902 
2903     event IssuanceRatioUpdated(uint newRatio);
2904 }
2905 
2906 
2907 /*
2908 -----------------------------------------------------------------
2909 FILE INFORMATION
2910 -----------------------------------------------------------------
2911 
2912 file:       ExchangeRates.sol
2913 version:    1.0
2914 author:     Kevin Brown
2915 date:       2018-09-12
2916 
2917 -----------------------------------------------------------------
2918 MODULE DESCRIPTION
2919 -----------------------------------------------------------------
2920 
2921 A contract that any other contract in the Synthetix system can query
2922 for the current market value of various assets, including
2923 crypto assets as well as various fiat assets.
2924 
2925 This contract assumes that rate updates will completely update
2926 all rates to their current values. If a rate shock happens
2927 on a single asset, the oracle will still push updated rates
2928 for all other assets.
2929 
2930 -----------------------------------------------------------------
2931 */
2932 
2933 
2934 /**
2935  * @title The repository for exchange rates
2936  */
2937 contract ExchangeRates is SelfDestructible {
2938 
2939     using SafeMath for uint;
2940 
2941     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
2942     mapping(bytes4 => uint) public rates;
2943 
2944     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
2945     mapping(bytes4 => uint) public lastRateUpdateTimes;
2946 
2947     // The address of the oracle which pushes rate updates to this contract
2948     address public oracle;
2949 
2950     // Do not allow the oracle to submit times any further forward into the future than this constant.
2951     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
2952 
2953     // How long will the contract assume the rate of any asset is correct
2954     uint public rateStalePeriod = 3 hours;
2955 
2956     // Each participating currency in the XDR basket is represented as a currency key with
2957     // equal weighting.
2958     // There are 5 participating currencies, so we'll declare that clearly.
2959     bytes4[5] public xdrParticipants;
2960 
2961     //
2962     // ========== CONSTRUCTOR ==========
2963 
2964     /**
2965      * @dev Constructor
2966      * @param _owner The owner of this contract.
2967      * @param _oracle The address which is able to update rate information.
2968      * @param _currencyKeys The initial currency keys to store (in order).
2969      * @param _newRates The initial currency amounts for each currency (in order).
2970      */
2971     constructor(
2972         // SelfDestructible (Ownable)
2973         address _owner,
2974 
2975         // Oracle values - Allows for rate updates
2976         address _oracle,
2977         bytes4[] _currencyKeys,
2978         uint[] _newRates
2979     )
2980         /* Owned is initialised in SelfDestructible */
2981         SelfDestructible(_owner)
2982         public
2983     {
2984         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
2985 
2986         oracle = _oracle;
2987 
2988         // The sUSD rate is always 1 and is never stale.
2989         rates["sUSD"] = SafeDecimalMath.unit();
2990         lastRateUpdateTimes["sUSD"] = now;
2991 
2992         // These are the currencies that make up the XDR basket.
2993         // These are hard coded because:
2994         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
2995         //  - Adding new currencies would likely introduce some kind of weighting factor, which
2996         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
2997         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
2998         //    then point the system at the new version.
2999         xdrParticipants = [
3000             bytes4("sUSD"),
3001             bytes4("sAUD"),
3002             bytes4("sCHF"),
3003             bytes4("sEUR"),
3004             bytes4("sGBP")
3005         ];
3006 
3007         internalUpdateRates(_currencyKeys, _newRates, now);
3008     }
3009 
3010     /* ========== SETTERS ========== */
3011 
3012     /**
3013      * @notice Set the rates stored in this contract
3014      * @param currencyKeys The currency keys you wish to update the rates for (in order)
3015      * @param newRates The rates for each currency (in order)
3016      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
3017      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
3018      *                 if it takes a long time for the transaction to confirm.
3019      */
3020     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
3021         external
3022         onlyOracle
3023         returns(bool)
3024     {
3025         return internalUpdateRates(currencyKeys, newRates, timeSent);
3026     }
3027 
3028     /**
3029      * @notice Internal function which sets the rates stored in this contract
3030      * @param currencyKeys The currency keys you wish to update the rates for (in order)
3031      * @param newRates The rates for each currency (in order)
3032      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
3033      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
3034      *                 if it takes a long time for the transaction to confirm.
3035      */
3036     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
3037         internal
3038         returns(bool)
3039     {
3040         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
3041         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
3042 
3043         // Loop through each key and perform update.
3044         for (uint i = 0; i < currencyKeys.length; i++) {
3045             // Should not set any rate to zero ever, as no asset will ever be
3046             // truely worthless and still valid. In this scenario, we should
3047             // delete the rate and remove it from the system.
3048             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
3049             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
3050 
3051             // We should only update the rate if it's at least the same age as the last rate we've got.
3052             if (timeSent >= lastRateUpdateTimes[currencyKeys[i]]) {
3053                 // Ok, go ahead with the update.
3054                 rates[currencyKeys[i]] = newRates[i];
3055                 lastRateUpdateTimes[currencyKeys[i]] = timeSent;
3056             }
3057         }
3058 
3059         emit RatesUpdated(currencyKeys, newRates);
3060 
3061         // Now update our XDR rate.
3062         updateXDRRate(timeSent);
3063 
3064         return true;
3065     }
3066 
3067     /**
3068      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
3069      */
3070     function updateXDRRate(uint timeSent)
3071         internal
3072     {
3073         uint total = 0;
3074 
3075         for (uint i = 0; i < xdrParticipants.length; i++) {
3076             total = rates[xdrParticipants[i]].add(total);
3077         }
3078 
3079         // Set the rate
3080         rates["XDR"] = total;
3081 
3082         // Record that we updated the XDR rate.
3083         lastRateUpdateTimes["XDR"] = timeSent;
3084 
3085         // Emit our updated event separate to the others to save
3086         // moving data around between arrays.
3087         bytes4[] memory eventCurrencyCode = new bytes4[](1);
3088         eventCurrencyCode[0] = "XDR";
3089 
3090         uint[] memory eventRate = new uint[](1);
3091         eventRate[0] = rates["XDR"];
3092 
3093         emit RatesUpdated(eventCurrencyCode, eventRate);
3094     }
3095 
3096     /**
3097      * @notice Delete a rate stored in the contract
3098      * @param currencyKey The currency key you wish to delete the rate for
3099      */
3100     function deleteRate(bytes4 currencyKey)
3101         external
3102         onlyOracle
3103     {
3104         require(rates[currencyKey] > 0, "Rate is zero");
3105 
3106         delete rates[currencyKey];
3107         delete lastRateUpdateTimes[currencyKey];
3108 
3109         emit RateDeleted(currencyKey);
3110     }
3111 
3112     /**
3113      * @notice Set the Oracle that pushes the rate information to this contract
3114      * @param _oracle The new oracle address
3115      */
3116     function setOracle(address _oracle)
3117         external
3118         onlyOwner
3119     {
3120         oracle = _oracle;
3121         emit OracleUpdated(oracle);
3122     }
3123 
3124     /**
3125      * @notice Set the stale period on the updated rate variables
3126      * @param _time The new rateStalePeriod
3127      */
3128     function setRateStalePeriod(uint _time)
3129         external
3130         onlyOwner
3131     {
3132         rateStalePeriod = _time;
3133         emit RateStalePeriodUpdated(rateStalePeriod);
3134     }
3135 
3136     /* ========== VIEWS ========== */
3137 
3138     /**
3139      * @notice Retrieve the rate for a specific currency
3140      */
3141     function rateForCurrency(bytes4 currencyKey)
3142         public
3143         view
3144         returns (uint)
3145     {
3146         return rates[currencyKey];
3147     }
3148 
3149     /**
3150      * @notice Retrieve the rates for a list of currencies
3151      */
3152     function ratesForCurrencies(bytes4[] currencyKeys)
3153         public
3154         view
3155         returns (uint[])
3156     {
3157         uint[] memory _rates = new uint[](currencyKeys.length);
3158 
3159         for (uint8 i = 0; i < currencyKeys.length; i++) {
3160             _rates[i] = rates[currencyKeys[i]];
3161         }
3162 
3163         return _rates;
3164     }
3165 
3166     /**
3167      * @notice Retrieve a list of last update times for specific currencies
3168      */
3169     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
3170         public
3171         view
3172         returns (uint)
3173     {
3174         return lastRateUpdateTimes[currencyKey];
3175     }
3176 
3177     /**
3178      * @notice Retrieve the last update time for a specific currency
3179      */
3180     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
3181         public
3182         view
3183         returns (uint[])
3184     {
3185         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
3186 
3187         for (uint8 i = 0; i < currencyKeys.length; i++) {
3188             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
3189         }
3190 
3191         return lastUpdateTimes;
3192     }
3193 
3194     /**
3195      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
3196      */
3197     function rateIsStale(bytes4 currencyKey)
3198         external
3199         view
3200         returns (bool)
3201     {
3202         // sUSD is a special case and is never stale.
3203         if (currencyKey == "sUSD") return false;
3204 
3205         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
3206     }
3207 
3208     /**
3209      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
3210      */
3211     function anyRateIsStale(bytes4[] currencyKeys)
3212         external
3213         view
3214         returns (bool)
3215     {
3216         // Loop through each key and check whether the data point is stale.
3217         uint256 i = 0;
3218 
3219         while (i < currencyKeys.length) {
3220             // sUSD is a special case and is never false
3221             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
3222                 return true;
3223             }
3224             i += 1;
3225         }
3226 
3227         return false;
3228     }
3229 
3230     /* ========== MODIFIERS ========== */
3231 
3232     modifier onlyOracle
3233     {
3234         require(msg.sender == oracle, "Only the oracle can perform this action");
3235         _;
3236     }
3237 
3238     /* ========== EVENTS ========== */
3239 
3240     event OracleUpdated(address newOracle);
3241     event RateStalePeriodUpdated(uint rateStalePeriod);
3242     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
3243     event RateDeleted(bytes4 currencyKey);
3244 }
3245 
3246 
3247 /*
3248 -----------------------------------------------------------------
3249 FILE INFORMATION
3250 -----------------------------------------------------------------
3251 
3252 file:       Synthetix.sol
3253 version:    2.0
3254 author:     Kevin Brown
3255             Gavin Conway
3256 date:       2018-09-14
3257 
3258 -----------------------------------------------------------------
3259 MODULE DESCRIPTION
3260 -----------------------------------------------------------------
3261 
3262 Synthetix token contract. SNX is a transferable ERC20 token,
3263 and also give its holders the following privileges.
3264 An owner of SNX has the right to issue synths in all synth flavours.
3265 
3266 After a fee period terminates, the duration and fees collected for that
3267 period are computed, and the next period begins. Thus an account may only
3268 withdraw the fees owed to them for the previous period, and may only do
3269 so once per period. Any unclaimed fees roll over into the common pot for
3270 the next period.
3271 
3272 == Average Balance Calculations ==
3273 
3274 The fee entitlement of a synthetix holder is proportional to their average
3275 issued synth balance over the last fee period. This is computed by
3276 measuring the area under the graph of a user's issued synth balance over
3277 time, and then when a new fee period begins, dividing through by the
3278 duration of the fee period.
3279 
3280 We need only update values when the balances of an account is modified.
3281 This occurs when issuing or burning for issued synth balances,
3282 and when transferring for synthetix balances. This is for efficiency,
3283 and adds an implicit friction to interacting with SNX.
3284 A synthetix holder pays for his own recomputation whenever he wants to change
3285 his position, which saves the foundation having to maintain a pot dedicated
3286 to resourcing this.
3287 
3288 A hypothetical user's balance history over one fee period, pictorially:
3289 
3290       s ____
3291        |    |
3292        |    |___ p
3293        |____|___|___ __ _  _
3294        f    t   n
3295 
3296 Here, the balance was s between times f and t, at which time a transfer
3297 occurred, updating the balance to p, until n, when the present transfer occurs.
3298 When a new transfer occurs at time n, the balance being p,
3299 we must:
3300 
3301   - Add the area p * (n - t) to the total area recorded so far
3302   - Update the last transfer time to n
3303 
3304 So if this graph represents the entire current fee period,
3305 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
3306 The complementary computations must be performed for both sender and
3307 recipient.
3308 
3309 Note that a transfer keeps global supply of SNX invariant.
3310 The sum of all balances is constant, and unmodified by any transfer.
3311 So the sum of all balances multiplied by the duration of a fee period is also
3312 constant, and this is equivalent to the sum of the area of every user's
3313 time/balance graph. Dividing through by that duration yields back the total
3314 synthetix supply. So, at the end of a fee period, we really do yield a user's
3315 average share in the synthetix supply over that period.
3316 
3317 A slight wrinkle is introduced if we consider the time r when the fee period
3318 rolls over. Then the previous fee period k-1 is before r, and the current fee
3319 period k is afterwards. If the last transfer took place before r,
3320 but the latest transfer occurred afterwards:
3321 
3322 k-1       |        k
3323       s __|_
3324        |  | |
3325        |  | |____ p
3326        |__|_|____|___ __ _  _
3327           |
3328        f  | t    n
3329           r
3330 
3331 In this situation the area (r-f)*s contributes to fee period k-1, while
3332 the area (t-r)*s contributes to fee period k. We will implicitly consider a
3333 zero-value transfer to have occurred at time r. Their fee entitlement for the
3334 previous period will be finalised at the time of their first transfer during the
3335 current fee period, or when they query or withdraw their fee entitlement.
3336 
3337 In the implementation, the duration of different fee periods may be slightly irregular,
3338 as the check that they have rolled over occurs only when state-changing synthetix
3339 operations are performed.
3340 
3341 == Issuance and Burning ==
3342 
3343 In this version of the synthetix contract, synths can only be issued by
3344 those that have been nominated by the synthetix foundation. Synths are assumed
3345 to be valued at $1, as they are a stable unit of account.
3346 
3347 All synths issued require a proportional value of SNX to be locked,
3348 where the proportion is governed by the current issuance ratio. This
3349 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
3350 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
3351 
3352 To determine the value of some amount of SNX(S), an oracle is used to push
3353 the price of SNX (P_S) in dollars to the contract. The value of S
3354 would then be: S * P_S.
3355 
3356 Any SNX that are locked up by this issuance process cannot be transferred.
3357 The amount that is locked floats based on the price of SNX. If the price
3358 of SNX moves up, less SNX are locked, so they can be issued against,
3359 or transferred freely. If the price of SNX moves down, more SNX are locked,
3360 even going above the initial wallet balance.
3361 
3362 -----------------------------------------------------------------
3363 */
3364 
3365 
3366 /**
3367  * @title Synthetix ERC20 contract.
3368  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
3369  * but it also computes the quantity of fees each synthetix holder is entitled to.
3370  */
3371 contract Synthetix is ExternStateToken {
3372 
3373     // ========== STATE VARIABLES ==========
3374 
3375     // Available Synths which can be used with the system
3376     Synth[] public availableSynths;
3377     mapping(bytes4 => Synth) public synths;
3378 
3379     FeePool public feePool;
3380     SynthetixEscrow public escrow;
3381     ExchangeRates public exchangeRates;
3382     SynthetixState public synthetixState;
3383 
3384     uint constant SYNTHETIX_SUPPLY = 1e8 * SafeDecimalMath.unit();
3385     string constant TOKEN_NAME = "Synthetix Network Token";
3386     string constant TOKEN_SYMBOL = "SNX";
3387     uint8 constant DECIMALS = 18;
3388 
3389     // ========== CONSTRUCTOR ==========
3390 
3391     /**
3392      * @dev Constructor
3393      * @param _tokenState A pre-populated contract containing token balances.
3394      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
3395      * @param _owner The owner of this contract.
3396      */
3397     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
3398         address _owner, ExchangeRates _exchangeRates, FeePool _feePool
3399     )
3400         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, SYNTHETIX_SUPPLY, DECIMALS, _owner)
3401         public
3402     {
3403         synthetixState = _synthetixState;
3404         exchangeRates = _exchangeRates;
3405         feePool = _feePool;
3406     }
3407 
3408     // ========== SETTERS ========== */
3409 
3410     /**
3411      * @notice Add an associated Synth contract to the Synthetix system
3412      * @dev Only the contract owner may call this.
3413      */
3414     function addSynth(Synth synth)
3415         external
3416         optionalProxy_onlyOwner
3417     {
3418         bytes4 currencyKey = synth.currencyKey();
3419 
3420         require(synths[currencyKey] == Synth(0), "Synth already exists");
3421 
3422         availableSynths.push(synth);
3423         synths[currencyKey] = synth;
3424 
3425         emitSynthAdded(currencyKey, synth);
3426     }
3427 
3428     /**
3429      * @notice Remove an associated Synth contract from the Synthetix system
3430      * @dev Only the contract owner may call this.
3431      */
3432     function removeSynth(bytes4 currencyKey)
3433         external
3434         optionalProxy_onlyOwner
3435     {
3436         require(synths[currencyKey] != address(0), "Synth does not exist");
3437         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
3438         require(currencyKey != "XDR", "Cannot remove XDR synth");
3439 
3440         // Save the address we're removing for emitting the event at the end.
3441         address synthToRemove = synths[currencyKey];
3442 
3443         // Remove the synth from the availableSynths array.
3444         for (uint8 i = 0; i < availableSynths.length; i++) {
3445             if (availableSynths[i] == synthToRemove) {
3446                 delete availableSynths[i];
3447 
3448                 // Copy the last synth into the place of the one we just deleted
3449                 // If there's only one synth, this is synths[0] = synths[0].
3450                 // If we're deleting the last one, it's also a NOOP in the same way.
3451                 availableSynths[i] = availableSynths[availableSynths.length - 1];
3452 
3453                 // Decrease the size of the array by one.
3454                 availableSynths.length--;
3455 
3456                 break;
3457             }
3458         }
3459 
3460         // And remove it from the synths mapping
3461         delete synths[currencyKey];
3462 
3463         emitSynthRemoved(currencyKey, synthToRemove);
3464     }
3465 
3466     /**
3467      * @notice Set the associated synthetix escrow contract.
3468      * @dev Only the contract owner may call this.
3469      */
3470     function setEscrow(SynthetixEscrow _escrow)
3471         external
3472         optionalProxy_onlyOwner
3473     {
3474         escrow = _escrow;
3475         // Note: No event here as our contract exceeds max contract size
3476         // with these events, and it's unlikely people will need to
3477         // track these events specifically.
3478     }
3479 
3480     /**
3481      * @notice Set the ExchangeRates contract address where rates are held.
3482      * @dev Only callable by the contract owner.
3483      */
3484     function setExchangeRates(ExchangeRates _exchangeRates)
3485         external
3486         optionalProxy_onlyOwner
3487     {
3488         exchangeRates = _exchangeRates;
3489         // Note: No event here as our contract exceeds max contract size
3490         // with these events, and it's unlikely people will need to
3491         // track these events specifically.
3492     }
3493 
3494     /**
3495      * @notice Set the synthetixState contract address where issuance data is held.
3496      * @dev Only callable by the contract owner.
3497      */
3498     function setSynthetixState(SynthetixState _synthetixState)
3499         external
3500         optionalProxy_onlyOwner
3501     {
3502         synthetixState = _synthetixState;
3503 
3504         emitStateContractChanged(_synthetixState);
3505     }
3506 
3507     /**
3508      * @notice Set your preferred currency. Note: This does not automatically exchange any balances you've held previously in
3509      * other synth currencies in this address, it will apply for any new payments you receive at this address.
3510      */
3511     function setPreferredCurrency(bytes4 currencyKey)
3512         external
3513         optionalProxy
3514     {
3515         require(currencyKey == 0 || !exchangeRates.rateIsStale(currencyKey), "Currency rate is stale or doesn't exist.");
3516 
3517         synthetixState.setPreferredCurrency(messageSender, currencyKey);
3518 
3519         emitPreferredCurrencyChanged(messageSender, currencyKey);
3520     }
3521 
3522     // ========== VIEWS ==========
3523 
3524     /**
3525      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
3526      * @param sourceCurrencyKey The currency the amount is specified in
3527      * @param sourceAmount The source amount, specified in UNIT base
3528      * @param destinationCurrencyKey The destination currency
3529      */
3530     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
3531         public
3532         view
3533         rateNotStale(sourceCurrencyKey)
3534         rateNotStale(destinationCurrencyKey)
3535         returns (uint)
3536     {
3537         // If there's no change in the currency, then just return the amount they gave us
3538         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
3539 
3540         // Calculate the effective value by going from source -> USD -> destination
3541         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
3542             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
3543     }
3544 
3545     /**
3546      * @notice Total amount of synths issued by the system, priced in currencyKey
3547      * @param currencyKey The currency to value the synths in
3548      */
3549     function totalIssuedSynths(bytes4 currencyKey)
3550         public
3551         view
3552         rateNotStale(currencyKey)
3553         returns (uint)
3554     {
3555         uint total = 0;
3556         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
3557 
3558         for (uint8 i = 0; i < availableSynths.length; i++) {
3559             // Ensure the rate isn't stale.
3560             // TODO: Investigate gas cost optimisation of doing a single call with all keys in it vs
3561             // individual calls like this.
3562             require(!exchangeRates.rateIsStale(availableSynths[i].currencyKey()), "Rate is stale");
3563 
3564             // What's the total issued value of that synth in the destination currency?
3565             // Note: We're not using our effectiveValue function because we don't want to go get the
3566             //       rate for the destination currency and check if it's stale repeatedly on every
3567             //       iteration of the loop
3568             uint synthValue = availableSynths[i].totalSupply()
3569                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
3570                 .divideDecimalRound(currencyRate);
3571             total = total.add(synthValue);
3572         }
3573 
3574         return total;
3575     }
3576 
3577     /**
3578      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
3579      */
3580     function availableSynthCount()
3581         public
3582         view
3583         returns (uint)
3584     {
3585         return availableSynths.length;
3586     }
3587 
3588     // ========== MUTATIVE FUNCTIONS ==========
3589 
3590     /**
3591      * @notice ERC20 transfer function.
3592      */
3593     function transfer(address to, uint value)
3594         public
3595         returns (bool)
3596     {
3597         bytes memory empty;
3598         return transfer(to, value, empty);
3599     }
3600 
3601     /**
3602      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
3603      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3604      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3605      *           tooling such as Etherscan.
3606      */
3607     function transfer(address to, uint value, bytes data)
3608         public
3609         optionalProxy
3610         returns (bool)
3611     {
3612         // Ensure they're not trying to exceed their locked amount
3613         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
3614 
3615         // Perform the transfer: if there is a problem an exception will be thrown in this call.
3616         _transfer_byProxy(messageSender, to, value, data);
3617 
3618         return true;
3619     }
3620 
3621     /**
3622      * @notice ERC20 transferFrom function.
3623      */
3624     function transferFrom(address from, address to, uint value)
3625         public
3626         returns (bool)
3627     {
3628         bytes memory empty;
3629         return transferFrom(from, to, value, empty);
3630     }
3631 
3632     /**
3633      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
3634      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3635      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3636      *           tooling such as Etherscan.
3637      */
3638     function transferFrom(address from, address to, uint value, bytes data)
3639         public
3640         optionalProxy
3641         returns (bool)
3642     {
3643         // Ensure they're not trying to exceed their locked amount
3644         require(value <= transferableSynthetix(from), "Insufficient balance");
3645 
3646         // Perform the transfer: if there is a problem,
3647         // an exception will be thrown in this call.
3648         _transferFrom_byProxy(messageSender, from, to, value, data);
3649 
3650         return true;
3651     }
3652 
3653     /**
3654      * @notice Function that allows you to exchange synths you hold in one flavour for another.
3655      * @param sourceCurrencyKey The source currency you wish to exchange from
3656      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3657      * @param destinationCurrencyKey The destination currency you wish to obtain.
3658      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
3659      * @return Boolean that indicates whether the transfer succeeded or failed.
3660      */
3661     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
3662         external
3663         optionalProxy
3664         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
3665         returns (bool)
3666     {
3667         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
3668         require(sourceAmount > 0, "Zero amount");
3669 
3670         // Pass it along, defaulting to the sender as the recipient.
3671         return _internalExchange(
3672             messageSender,
3673             sourceCurrencyKey,
3674             sourceAmount,
3675             destinationCurrencyKey,
3676             destinationAddress == address(0) ? messageSender : destinationAddress,
3677             true // Charge fee on the exchange
3678         );
3679     }
3680 
3681     /**
3682      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
3683      * @dev Only the synth contract can call this function
3684      * @param from The address to exchange / burn synth from
3685      * @param sourceCurrencyKey The source currency you wish to exchange from
3686      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3687      * @param destinationCurrencyKey The destination currency you wish to obtain.
3688      * @param destinationAddress Where the result should go.
3689      * @return Boolean that indicates whether the transfer succeeded or failed.
3690      */
3691     function synthInitiatedExchange(
3692         address from,
3693         bytes4 sourceCurrencyKey,
3694         uint sourceAmount,
3695         bytes4 destinationCurrencyKey,
3696         address destinationAddress
3697     )
3698         external
3699         onlySynth
3700         returns (bool)
3701     {
3702         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3703         require(sourceAmount > 0, "Zero amount");
3704 
3705         // Pass it along
3706         return _internalExchange(
3707             from,
3708             sourceCurrencyKey,
3709             sourceAmount,
3710             destinationCurrencyKey,
3711             destinationAddress,
3712             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
3713         );
3714     }
3715 
3716     /**
3717      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3718      * @dev Only the synth contract can call this function.
3719      * @param from The address fee is coming from.
3720      * @param sourceCurrencyKey source currency fee from.
3721      * @param sourceAmount The amount, specified in UNIT of source currency.
3722      * @return Boolean that indicates whether the transfer succeeded or failed.
3723      */
3724     function synthInitiatedFeePayment(
3725         address from,
3726         bytes4 sourceCurrencyKey,
3727         uint sourceAmount
3728     )
3729         external
3730         onlySynth
3731         returns (bool)
3732     {
3733         require(sourceAmount > 0, "Source can't be 0");
3734 
3735         // Pass it along, defaulting to the sender as the recipient.
3736         bool result = _internalExchange(
3737             from,
3738             sourceCurrencyKey,
3739             sourceAmount,
3740             "XDR",
3741             feePool.FEE_ADDRESS(),
3742             false // Don't charge a fee on the exchange because this is already a fee
3743         );
3744 
3745         // Tell the fee pool about this.
3746         feePool.feePaid(sourceCurrencyKey, sourceAmount);
3747 
3748         return result;
3749     }
3750 
3751     /**
3752      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3753      * @dev fee pool contract address is not allowed to call function
3754      * @param from The address to move synth from
3755      * @param sourceCurrencyKey source currency from.
3756      * @param sourceAmount The amount, specified in UNIT of source currency.
3757      * @param destinationCurrencyKey The destination currency to obtain.
3758      * @param destinationAddress Where the result should go.
3759      * @param chargeFee Boolean to charge a fee for transaction.
3760      * @return Boolean that indicates whether the transfer succeeded or failed.
3761      */
3762     function _internalExchange(
3763         address from,
3764         bytes4 sourceCurrencyKey,
3765         uint sourceAmount,
3766         bytes4 destinationCurrencyKey,
3767         address destinationAddress,
3768         bool chargeFee
3769     )
3770         internal
3771         notFeeAddress(from)
3772         returns (bool)
3773     {
3774         require(destinationAddress != address(0), "Zero destination");
3775         require(destinationAddress != address(this), "Synthetix is invalid destination");
3776         require(destinationAddress != address(proxy), "Proxy is invalid destination");
3777 
3778         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3779         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3780 
3781         // Burn the source amount
3782         synths[sourceCurrencyKey].burn(from, sourceAmount);
3783 
3784         // How much should they get in the destination currency?
3785         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3786 
3787         // What's the fee on that currency that we should deduct?
3788         uint amountReceived = destinationAmount;
3789         uint fee = 0;
3790 
3791         if (chargeFee) {
3792             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
3793             fee = destinationAmount.sub(amountReceived);
3794         }
3795 
3796         // Issue their new synths
3797         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3798 
3799         // Remit the fee in XDRs
3800         if (fee > 0) {
3801             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3802             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3803         }
3804 
3805         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3806 
3807         // Call the ERC223 transfer callback if needed
3808         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
3809 
3810         // Gas optimisation:
3811         // No event emitted as it's assumed users will be able to track transfers to the zero address, followed
3812         // by a transfer on another synth from the zero address and ascertain the info required here.
3813 
3814         return true;
3815     }
3816 
3817     /**
3818      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
3819      * @dev Only internal calls from synthetix address.
3820      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3821      * @param amount The amount of synths to register with a base of UNIT
3822      */
3823     function _addToDebtRegister(bytes4 currencyKey, uint amount)
3824         internal
3825         optionalProxy
3826     {
3827         // What is the value of the requested debt in XDRs?
3828         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3829 
3830         // What is the value of all issued synths of the system (priced in XDRs)?
3831         uint totalDebtIssued = totalIssuedSynths("XDR");
3832 
3833         // What will the new total be including the new value?
3834         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3835 
3836         // What is their percentage (as a high precision int) of the total debt?
3837         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3838 
3839         // And what effect does this percentage have on the global debt holding of other issuers?
3840         // The delta specifically needs to not take into account any existing debt as it's already
3841         // accounted for in the delta from when they issued previously.
3842         // The delta is a high precision integer.
3843         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3844 
3845         // How much existing debt do they have?
3846         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3847 
3848         // And what does their debt ownership look like including this previous stake?
3849         if (existingDebt > 0) {
3850             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3851         }
3852 
3853         // Are they a new issuer? If so, record them.
3854         if (!synthetixState.hasIssued(messageSender)) {
3855             synthetixState.incrementTotalIssuerCount();
3856         }
3857 
3858         // Save the debt entry parameters
3859         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3860 
3861         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3862         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3863         if (synthetixState.debtLedgerLength() > 0) {
3864             synthetixState.appendDebtLedgerValue(
3865                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3866             );
3867         } else {
3868             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3869         }
3870     }
3871 
3872     /**
3873      * @notice Issue synths against the sender's SNX.
3874      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3875      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3876      * @param amount The amount of synths you wish to issue with a base of UNIT
3877      */
3878     function issueSynths(bytes4 currencyKey, uint amount)
3879         public
3880         optionalProxy
3881         nonZeroAmount(amount)
3882         // No need to check if price is stale, as it is checked in issuableSynths.
3883     {
3884         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3885 
3886         // Keep track of the debt they're about to create
3887         _addToDebtRegister(currencyKey, amount);
3888 
3889         // Create their synths
3890         synths[currencyKey].issue(messageSender, amount);
3891     }
3892 
3893     /**
3894      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3895      * @dev Issuance is only allowed if the synthetix price isn't stale.
3896      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3897      */
3898     function issueMaxSynths(bytes4 currencyKey)
3899         external
3900         optionalProxy
3901     {
3902         // Figure out the maximum we can issue in that currency
3903         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3904 
3905         // And issue them
3906         issueSynths(currencyKey, maxIssuable);
3907     }
3908 
3909     /**
3910      * @notice Burn synths to clear issued synths/free SNX.
3911      * @param currencyKey The currency you're specifying to burn
3912      * @param amount The amount (in UNIT base) you wish to burn
3913      */
3914     function burnSynths(bytes4 currencyKey, uint amount)
3915         external
3916         optionalProxy
3917         // No need to check for stale rates as _removeFromDebtRegister calls effectiveValue
3918         // which does this for us
3919     {
3920         // How much debt do they have?
3921         uint debt = debtBalanceOf(messageSender, currencyKey);
3922 
3923         require(debt > 0, "No debt to forgive");
3924 
3925         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3926         // clear their debt and leave them be.
3927         uint amountToBurn = debt < amount ? debt : amount;
3928 
3929         // Remove their debt from the ledger
3930         _removeFromDebtRegister(currencyKey, amountToBurn);
3931 
3932         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3933         synths[currencyKey].burn(messageSender, amountToBurn);
3934     }
3935 
3936     /**
3937      * @notice Remove a debt position from the register
3938      * @param currencyKey The currency the user is presenting to forgive their debt
3939      * @param amount The amount (in UNIT base) being presented
3940      */
3941     function _removeFromDebtRegister(bytes4 currencyKey, uint amount)
3942         internal
3943     {
3944         // How much debt are they trying to remove in XDRs?
3945         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3946 
3947         // How much debt do they have?
3948         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3949 
3950         // What percentage of the total debt are they trying to remove?
3951         uint totalDebtIssued = totalIssuedSynths("XDR");
3952         uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(totalDebtIssued);
3953 
3954         // And what effect does this percentage have on the global debt holding of other issuers?
3955         // The delta specifically needs to not take into account any existing debt as it's already
3956         // accounted for in the delta from when they issued previously.
3957         uint delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3958 
3959         // Are they exiting the system, or are they just decreasing their debt position?
3960         if (debtToRemove == existingDebt) {
3961             synthetixState.clearIssuanceData(messageSender);
3962             synthetixState.decrementTotalIssuerCount();
3963         } else {
3964             // What percentage of the debt will they be left with?
3965             uint newDebt = existingDebt.sub(debtToRemove);
3966             uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3967             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3968 
3969             // Store the debt percentage and debt ledger as high precision integers
3970             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3971         }
3972 
3973         // Update our cumulative ledger. This is also a high precision integer.
3974         synthetixState.appendDebtLedgerValue(
3975             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3976         );
3977     }
3978 
3979     // ========== Issuance/Burning ==========
3980 
3981     /**
3982      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3983      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3984      */
3985     function maxIssuableSynths(address issuer, bytes4 currencyKey)
3986         public
3987         view
3988         // We don't need to check stale rates here as effectiveValue will do it for us.
3989         returns (uint)
3990     {
3991         // What is the value of their SNX balance in the destination currency?
3992         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3993 
3994         // They're allowed to issue up to issuanceRatio of that value
3995         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3996     }
3997 
3998     /**
3999      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
4000      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
4001      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
4002      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
4003      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
4004      * altering the amount of fees they're able to claim from the system.
4005      */
4006     function collateralisationRatio(address issuer)
4007         public
4008         view
4009         returns (uint)
4010     {
4011         uint totalOwnedSynthetix = collateral(issuer);
4012         if (totalOwnedSynthetix == 0) return 0;
4013 
4014         uint debtBalance = debtBalanceOf(issuer, "SNX");
4015         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
4016     }
4017 
4018 /**
4019      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
4020      * will tell you how many synths a user has to give back to the system in order to unlock their original
4021      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
4022      * the debt in sUSD, XDR, or any other synth you wish.
4023      */
4024     function debtBalanceOf(address issuer, bytes4 currencyKey)
4025         public
4026         view
4027         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
4028         returns (uint)
4029     {
4030         // What was their initial debt ownership?
4031         uint initialDebtOwnership;
4032         uint debtEntryIndex;
4033         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
4034 
4035         // If it's zero, they haven't issued, and they have no debt.
4036         if (initialDebtOwnership == 0) return 0;
4037 
4038         // Figure out the global debt percentage delta from when they entered the system.
4039         // This is a high precision integer.
4040         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
4041             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
4042             .multiplyDecimalRoundPrecise(initialDebtOwnership);
4043 
4044         // What's the total value of the system in their requested currency?
4045         uint totalSystemValue = totalIssuedSynths(currencyKey);
4046 
4047         // Their debt balance is their portion of the total system value.
4048         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
4049             .multiplyDecimalRoundPrecise(currentDebtOwnership);
4050 
4051         return highPrecisionBalance.preciseDecimalToDecimal();
4052     }
4053 
4054     /**
4055      * @notice The remaining synths an issuer can issue against their total synthetix balance.
4056      * @param issuer The account that intends to issue
4057      * @param currencyKey The currency to price issuable value in
4058      */
4059     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
4060         public
4061         view
4062         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
4063         returns (uint)
4064     {
4065         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
4066         uint max = maxIssuableSynths(issuer, currencyKey);
4067 
4068         if (alreadyIssued >= max) {
4069             return 0;
4070         } else {
4071             return max.sub(alreadyIssued);
4072         }
4073     }
4074 
4075     /**
4076      * @notice The total SNX owned by this account, both escrowed and unescrowed,
4077      * against which synths can be issued.
4078      * This includes those already being used as collateral (locked), and those
4079      * available for further issuance (unlocked).
4080      */
4081     function collateral(address account)
4082         public
4083         view
4084         returns (uint)
4085     {
4086         uint balance = tokenState.balanceOf(account);
4087 
4088         if (escrow != address(0)) {
4089             balance = balance.add(escrow.balanceOf(account));
4090         }
4091 
4092         return balance;
4093     }
4094 
4095     /**
4096      * @notice The number of SNX that are free to be transferred by an account.
4097      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
4098      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
4099      * in this calculation.
4100      */
4101     function transferableSynthetix(address account)
4102         public
4103         view
4104         rateNotStale("SNX")
4105         returns (uint)
4106     {
4107         // How many SNX do they have, excluding escrow?
4108         // Note: We're excluding escrow here because we're interested in their transferable amount
4109         // and escrowed SNX are not transferable.
4110         uint balance = tokenState.balanceOf(account);
4111 
4112         // How many of those will be locked by the amount they've issued?
4113         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
4114         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
4115         // The locked synthetix value can exceed their balance.
4116         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
4117 
4118         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
4119         if (lockedSynthetixValue >= balance) {
4120             return 0;
4121         } else {
4122             return balance.sub(lockedSynthetixValue);
4123         }
4124     }
4125 
4126     // ========== MODIFIERS ==========
4127 
4128     modifier rateNotStale(bytes4 currencyKey) {
4129         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
4130         _;
4131     }
4132 
4133     modifier notFeeAddress(address account) {
4134         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
4135         _;
4136     }
4137 
4138     modifier onlySynth() {
4139         bool isSynth = false;
4140 
4141         // No need to repeatedly call this function either
4142         for (uint8 i = 0; i < availableSynths.length; i++) {
4143             if (availableSynths[i] == msg.sender) {
4144                 isSynth = true;
4145                 break;
4146             }
4147         }
4148 
4149         require(isSynth, "Only synth allowed");
4150         _;
4151     }
4152 
4153     modifier nonZeroAmount(uint _amount) {
4154         require(_amount > 0, "Amount needs to be larger than 0");
4155         _;
4156     }
4157 
4158     // ========== EVENTS ==========
4159 
4160     event PreferredCurrencyChanged(address indexed account, bytes4 newPreferredCurrency);
4161     bytes32 constant PREFERREDCURRENCYCHANGED_SIG = keccak256("PreferredCurrencyChanged(address,bytes4)");
4162     function emitPreferredCurrencyChanged(address account, bytes4 newPreferredCurrency) internal {
4163         proxy._emit(abi.encode(newPreferredCurrency), 2, PREFERREDCURRENCYCHANGED_SIG, bytes32(account), 0, 0);
4164     }
4165 
4166     event StateContractChanged(address stateContract);
4167     bytes32 constant STATECONTRACTCHANGED_SIG = keccak256("StateContractChanged(address)");
4168     function emitStateContractChanged(address stateContract) internal {
4169         proxy._emit(abi.encode(stateContract), 1, STATECONTRACTCHANGED_SIG, 0, 0, 0);
4170     }
4171 
4172     event SynthAdded(bytes4 currencyKey, address newSynth);
4173     bytes32 constant SYNTHADDED_SIG = keccak256("SynthAdded(bytes4,address)");
4174     function emitSynthAdded(bytes4 currencyKey, address newSynth) internal {
4175         proxy._emit(abi.encode(currencyKey, newSynth), 1, SYNTHADDED_SIG, 0, 0, 0);
4176     }
4177 
4178     event SynthRemoved(bytes4 currencyKey, address removedSynth);
4179     bytes32 constant SYNTHREMOVED_SIG = keccak256("SynthRemoved(bytes4,address)");
4180     function emitSynthRemoved(bytes4 currencyKey, address removedSynth) internal {
4181         proxy._emit(abi.encode(currencyKey, removedSynth), 1, SYNTHREMOVED_SIG, 0, 0, 0);
4182     }
4183 }
4184 
4185 
4186 /*
4187 -----------------------------------------------------------------
4188 FILE INFORMATION
4189 -----------------------------------------------------------------
4190 
4191 file:       Depot.sol
4192 version:    3.0
4193 author:     Kevin Brown
4194 date:       2018-10-23
4195 
4196 -----------------------------------------------------------------
4197 MODULE DESCRIPTION
4198 -----------------------------------------------------------------
4199 
4200 Depot contract. The Depot provides
4201 a way for users to acquire synths (Synth.sol) and SNX
4202 (Synthetix.sol) by paying ETH and a way for users to acquire SNX
4203 (Synthetix.sol) by paying synths. Users can also deposit their synths
4204 and allow other users to purchase them with ETH. The ETH is sent
4205 to the user who offered their synths for sale.
4206 
4207 This smart contract contains a balance of each token, and
4208 allows the owner of the contract (the Synthetix Foundation) to
4209 manage the available balance of synthetix at their discretion, while
4210 users are allowed to deposit and withdraw their own synth deposits
4211 if they have not yet been taken up by another user.
4212 
4213 -----------------------------------------------------------------
4214 */
4215 
4216 
4217 /**
4218  * @title Depot Contract.
4219  */
4220 contract Depot is SelfDestructible, Pausable {
4221     using SafeMath for uint;
4222     using SafeDecimalMath for uint;
4223 
4224     /* ========== STATE VARIABLES ========== */
4225     Synthetix public synthetix;
4226     Synth public synth;
4227     FeePool public feePool;
4228 
4229     // Address where the ether and Synths raised for selling SNX is transfered to
4230     // Any ether raised for selling Synths gets sent back to whoever deposited the Synths,
4231     // and doesn't have anything to do with this address.
4232     address public fundsWallet;
4233 
4234     /* The address of the oracle which pushes the USD price SNX and ether to this contract */
4235     address public oracle;
4236     /* Do not allow the oracle to submit times any further forward into the future than
4237        this constant. */
4238     uint public constant ORACLE_FUTURE_LIMIT = 10 minutes;
4239 
4240     /* How long will the contract assume the price of any asset is correct */
4241     uint public priceStalePeriod = 3 hours;
4242 
4243     /* The time the prices were last updated */
4244     uint public lastPriceUpdateTime;
4245     /* The USD price of SNX denominated in UNIT */
4246     uint public usdToSnxPrice;
4247     /* The USD price of ETH denominated in UNIT */
4248     uint public usdToEthPrice;
4249 
4250     /* Stores deposits from users. */
4251     struct synthDeposit {
4252         // The user that made the deposit
4253         address user;
4254         // The amount (in Synths) that they deposited
4255         uint amount;
4256     }
4257 
4258     /* User deposits are sold on a FIFO (First in First out) basis. When users deposit
4259        synths with us, they get added this queue, which then gets fulfilled in order.
4260        Conceptually this fits well in an array, but then when users fill an order we
4261        end up copying the whole array around, so better to use an index mapping instead
4262        for gas performance reasons.
4263 
4264        The indexes are specified (inclusive, exclusive), so (0, 0) means there's nothing
4265        in the array, and (3, 6) means there are 3 elements at 3, 4, and 5. You can obtain
4266        the length of the "array" by querying depositEndIndex - depositStartIndex. All index
4267        operations use safeAdd, so there is no way to overflow, so that means there is a
4268        very large but finite amount of deposits this contract can handle before it fills up. */
4269     mapping(uint => synthDeposit) public deposits;
4270     // The starting index of our queue inclusive
4271     uint public depositStartIndex;
4272     // The ending index of our queue exclusive
4273     uint public depositEndIndex;
4274 
4275     /* This is a convenience variable so users and dApps can just query how much sUSD
4276        we have available for purchase without having to iterate the mapping with a
4277        O(n) amount of calls for something we'll probably want to display quite regularly. */
4278     uint public totalSellableDeposits;
4279 
4280     // The minimum amount of sUSD required to enter the FiFo queue
4281     uint public minimumDepositAmount = 50 * SafeDecimalMath.unit();
4282 
4283     // If a user deposits a synth amount < the minimumDepositAmount the contract will keep
4284     // the total of small deposits which will not be sold on market and the sender
4285     // must call withdrawMyDepositedSynths() to get them back.
4286     mapping(address => uint) public smallDeposits;
4287 
4288 
4289     /* ========== CONSTRUCTOR ========== */
4290 
4291     /**
4292      * @dev Constructor
4293      * @param _owner The owner of this contract.
4294      * @param _fundsWallet The recipient of ETH and Synths that are sent to this contract while exchanging.
4295      * @param _synthetix The Synthetix contract we'll interact with for balances and sending.
4296      * @param _synth The Synth contract we'll interact with for balances and sending.
4297      * @param _oracle The address which is able to update price information.
4298      * @param _usdToEthPrice The current price of ETH in USD, expressed in UNIT.
4299      * @param _usdToSnxPrice The current price of Synthetix in USD, expressed in UNIT.
4300      */
4301     constructor(
4302         // Ownable
4303         address _owner,
4304 
4305         // Funds Wallet
4306         address _fundsWallet,
4307 
4308         // Other contracts needed
4309         Synthetix _synthetix,
4310         Synth _synth,
4311 		FeePool _feePool,
4312 
4313         // Oracle values - Allows for price updates
4314         address _oracle,
4315         uint _usdToEthPrice,
4316         uint _usdToSnxPrice
4317     )
4318         /* Owned is initialised in SelfDestructible */
4319         SelfDestructible(_owner)
4320         Pausable(_owner)
4321         public
4322     {
4323         fundsWallet = _fundsWallet;
4324         synthetix = _synthetix;
4325         synth = _synth;
4326         feePool = _feePool;
4327         oracle = _oracle;
4328         usdToEthPrice = _usdToEthPrice;
4329         usdToSnxPrice = _usdToSnxPrice;
4330         lastPriceUpdateTime = now;
4331     }
4332 
4333     /* ========== SETTERS ========== */
4334 
4335     /**
4336      * @notice Set the funds wallet where ETH raised is held
4337      * @param _fundsWallet The new address to forward ETH and Synths to
4338      */
4339     function setFundsWallet(address _fundsWallet)
4340         external
4341         onlyOwner
4342     {
4343         fundsWallet = _fundsWallet;
4344         emit FundsWalletUpdated(fundsWallet);
4345     }
4346 
4347     /**
4348      * @notice Set the Oracle that pushes the synthetix price to this contract
4349      * @param _oracle The new oracle address
4350      */
4351     function setOracle(address _oracle)
4352         external
4353         onlyOwner
4354     {
4355         oracle = _oracle;
4356         emit OracleUpdated(oracle);
4357     }
4358 
4359     /**
4360      * @notice Set the Synth contract that the issuance controller uses to issue Synths.
4361      * @param _synth The new synth contract target
4362      */
4363     function setSynth(Synth _synth)
4364         external
4365         onlyOwner
4366     {
4367         synth = _synth;
4368         emit SynthUpdated(_synth);
4369     }
4370 
4371     /**
4372      * @notice Set the Synthetix contract that the issuance controller uses to issue SNX.
4373      * @param _synthetix The new synthetix contract target
4374      */
4375     function setSynthetix(Synthetix _synthetix)
4376         external
4377         onlyOwner
4378     {
4379         synthetix = _synthetix;
4380         emit SynthetixUpdated(_synthetix);
4381     }
4382 
4383     /**
4384      * @notice Set the stale period on the updated price variables
4385      * @param _time The new priceStalePeriod
4386      */
4387     function setPriceStalePeriod(uint _time)
4388         external
4389         onlyOwner
4390     {
4391         priceStalePeriod = _time;
4392         emit PriceStalePeriodUpdated(priceStalePeriod);
4393     }
4394 
4395     /**
4396      * @notice Set the minimum deposit amount required to depoist sUSD into the FIFO queue
4397      * @param _amount The new new minimum number of sUSD required to deposit
4398      */
4399     function setMinimumDepositAmount(uint _amount)
4400         external
4401         onlyOwner
4402     {
4403         // Do not allow us to set it less than 1 dollar opening up to fractional desposits in the queue again
4404         require(_amount > SafeDecimalMath.unit(), "Minimum deposit amount must be greater than UNIT");
4405         minimumDepositAmount = _amount;
4406         emit MinimumDepositAmountUpdated(minimumDepositAmount);
4407     }
4408 
4409     /* ========== MUTATIVE FUNCTIONS ========== */
4410     /**
4411      * @notice Access point for the oracle to update the prices of SNX / eth.
4412      * @param newEthPrice The current price of ether in USD, specified to 18 decimal places.
4413      * @param newSynthetixPrice The current price of SNX in USD, specified to 18 decimal places.
4414      * @param timeSent The timestamp from the oracle when the transaction was created. This ensures we don't consider stale prices as current in times of heavy network congestion.
4415      */
4416     function updatePrices(uint newEthPrice, uint newSynthetixPrice, uint timeSent)
4417         external
4418         onlyOracle
4419     {
4420         /* Must be the most recently sent price, but not too far in the future.
4421          * (so we can't lock ourselves out of updating the oracle for longer than this) */
4422         require(lastPriceUpdateTime < timeSent, "Time must be later than last update");
4423         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time must be less than now + ORACLE_FUTURE_LIMIT");
4424 
4425         usdToEthPrice = newEthPrice;
4426         usdToSnxPrice = newSynthetixPrice;
4427         lastPriceUpdateTime = timeSent;
4428 
4429         emit PricesUpdated(usdToEthPrice, usdToSnxPrice, lastPriceUpdateTime);
4430     }
4431 
4432     /**
4433      * @notice Fallback function (exchanges ETH to sUSD)
4434      */
4435     function ()
4436         external
4437         payable
4438     {
4439         exchangeEtherForSynths();
4440     }
4441 
4442     /**
4443      * @notice Exchange ETH to sUSD.
4444      */
4445     function exchangeEtherForSynths()
4446         public
4447         payable
4448         pricesNotStale
4449         notPaused
4450         returns (uint) // Returns the number of Synths (sUSD) received
4451     {
4452         uint ethToSend;
4453 
4454         // The multiplication works here because usdToEthPrice is specified in
4455         // 18 decimal places, just like our currency base.
4456         uint requestedToPurchase = msg.value.multiplyDecimal(usdToEthPrice);
4457         uint remainingToFulfill = requestedToPurchase;
4458 
4459         // Iterate through our outstanding deposits and sell them one at a time.
4460         for (uint i = depositStartIndex; remainingToFulfill > 0 && i < depositEndIndex; i++) {
4461             synthDeposit memory deposit = deposits[i];
4462 
4463             // If it's an empty spot in the queue from a previous withdrawal, just skip over it and
4464             // update the queue. It's already been deleted.
4465             if (deposit.user == address(0)) {
4466 
4467                 depositStartIndex = depositStartIndex.add(1);
4468             } else {
4469                 // If the deposit can more than fill the order, we can do this
4470                 // without touching the structure of our queue.
4471                 if (deposit.amount > remainingToFulfill) {
4472 
4473                     // Ok, this deposit can fulfill the whole remainder. We don't need
4474                     // to change anything about our queue we can just fulfill it.
4475                     // Subtract the amount from our deposit and total.
4476                     deposit.amount = deposit.amount.sub(remainingToFulfill);
4477                     totalSellableDeposits = totalSellableDeposits.sub(remainingToFulfill);
4478 
4479                     // Transfer the ETH to the depositor. Send is used instead of transfer
4480                     // so a non payable contract won't block the FIFO queue on a failed
4481                     // ETH payable for synths transaction. The proceeds to be sent to the
4482                     // synthetix foundation funds wallet. This is to protect all depositors
4483                     // in the queue in this rare case that may occur.
4484                     ethToSend = remainingToFulfill.divideDecimal(usdToEthPrice);
4485 
4486                     // We need to use send here instead of transfer because transfer reverts
4487                     // if the recipient is a non-payable contract. Send will just tell us it
4488                     // failed by returning false at which point we can continue.
4489                     // solium-disable-next-line security/no-send
4490                     if(!deposit.user.send(ethToSend)) {
4491                         fundsWallet.transfer(ethToSend);
4492                         emit NonPayableContract(deposit.user, ethToSend);
4493                     } else {
4494                         emit ClearedDeposit(msg.sender, deposit.user, ethToSend, remainingToFulfill, i);
4495                     }
4496 
4497                     // And the Synths to the recipient.
4498                     // Note: Fees are calculated by the Synth contract, so when
4499                     //       we request a specific transfer here, the fee is
4500                     //       automatically deducted and sent to the fee pool.
4501                     synth.transfer(msg.sender, remainingToFulfill);
4502 
4503                     // And we have nothing left to fulfill on this order.
4504                     remainingToFulfill = 0;
4505                 } else if (deposit.amount <= remainingToFulfill) {
4506                     // We need to fulfill this one in its entirety and kick it out of the queue.
4507                     // Start by kicking it out of the queue.
4508                     // Free the storage because we can.
4509                     delete deposits[i];
4510                     // Bump our start index forward one.
4511                     depositStartIndex = depositStartIndex.add(1);
4512                     // We also need to tell our total it's decreased
4513                     totalSellableDeposits = totalSellableDeposits.sub(deposit.amount);
4514 
4515                     // Now fulfill by transfering the ETH to the depositor. Send is used instead of transfer
4516                     // so a non payable contract won't block the FIFO queue on a failed
4517                     // ETH payable for synths transaction. The proceeds to be sent to the
4518                     // synthetix foundation funds wallet. This is to protect all depositors
4519                     // in the queue in this rare case that may occur.
4520                     ethToSend = deposit.amount.divideDecimal(usdToEthPrice);
4521 
4522                     // We need to use send here instead of transfer because transfer reverts
4523                     // if the recipient is a non-payable contract. Send will just tell us it
4524                     // failed by returning false at which point we can continue.
4525                     // solium-disable-next-line security/no-send
4526                     if(!deposit.user.send(ethToSend)) {
4527                         fundsWallet.transfer(ethToSend);
4528                         emit NonPayableContract(deposit.user, ethToSend);
4529                     } else {
4530                         emit ClearedDeposit(msg.sender, deposit.user, ethToSend, deposit.amount, i);
4531                     }
4532 
4533                     // And the Synths to the recipient.
4534                     // Note: Fees are calculated by the Synth contract, so when
4535                     //       we request a specific transfer here, the fee is
4536                     //       automatically deducted and sent to the fee pool.
4537                     synth.transfer(msg.sender, deposit.amount);
4538 
4539                     // And subtract the order from our outstanding amount remaining
4540                     // for the next iteration of the loop.
4541                     remainingToFulfill = remainingToFulfill.sub(deposit.amount);
4542                 }
4543             }
4544         }
4545 
4546         // Ok, if we're here and 'remainingToFulfill' isn't zero, then
4547         // we need to refund the remainder of their ETH back to them.
4548         if (remainingToFulfill > 0) {
4549             msg.sender.transfer(remainingToFulfill.divideDecimal(usdToEthPrice));
4550         }
4551 
4552         // How many did we actually give them?
4553         uint fulfilled = requestedToPurchase.sub(remainingToFulfill);
4554 
4555         if (fulfilled > 0) {
4556             // Now tell everyone that we gave them that many (only if the amount is greater than 0).
4557             emit Exchange("ETH", msg.value, "sUSD", fulfilled);
4558         }
4559 
4560         return fulfilled;
4561     }
4562 
4563     /**
4564      * @notice Exchange ETH to sUSD while insisting on a particular rate. This allows a user to
4565      *         exchange while protecting against frontrunning by the contract owner on the exchange rate.
4566      * @param guaranteedRate The exchange rate (ether price) which must be honored or the call will revert.
4567      */
4568     function exchangeEtherForSynthsAtRate(uint guaranteedRate)
4569         public
4570         payable
4571         pricesNotStale
4572         notPaused
4573         returns (uint) // Returns the number of Synths (sUSD) received
4574     {
4575         require(guaranteedRate == usdToEthPrice, "Guaranteed rate would not be received");
4576 
4577         return exchangeEtherForSynths();
4578     }
4579 
4580 
4581     /**
4582      * @notice Exchange ETH to SNX.
4583      */
4584     function exchangeEtherForSynthetix()
4585         public
4586         payable
4587         pricesNotStale
4588         notPaused
4589         returns (uint) // Returns the number of SNX received
4590     {
4591         // How many SNX are they going to be receiving?
4592         uint synthetixToSend = synthetixReceivedForEther(msg.value);
4593 
4594         // Store the ETH in our funds wallet
4595         fundsWallet.transfer(msg.value);
4596 
4597         // And send them the SNX.
4598         synthetix.transfer(msg.sender, synthetixToSend);
4599 
4600         emit Exchange("ETH", msg.value, "SNX", synthetixToSend);
4601 
4602         return synthetixToSend;
4603     }
4604 
4605     /**
4606      * @notice Exchange ETH to SNX while insisting on a particular set of rates. This allows a user to
4607      *         exchange while protecting against frontrunning by the contract owner on the exchange rates.
4608      * @param guaranteedEtherRate The ether exchange rate which must be honored or the call will revert.
4609      * @param guaranteedSynthetixRate The synthetix exchange rate which must be honored or the call will revert.
4610      */
4611     function exchangeEtherForSynthetixAtRate(uint guaranteedEtherRate, uint guaranteedSynthetixRate)
4612         public
4613         payable
4614         pricesNotStale
4615         notPaused
4616         returns (uint) // Returns the number of SNX received
4617     {
4618         require(guaranteedEtherRate == usdToEthPrice, "Guaranteed ether rate would not be received");
4619         require(guaranteedSynthetixRate == usdToSnxPrice, "Guaranteed synthetix rate would not be received");
4620 
4621         return exchangeEtherForSynthetix();
4622     }
4623 
4624 
4625     /**
4626      * @notice Exchange sUSD for SNX
4627      * @param synthAmount The amount of synths the user wishes to exchange.
4628      */
4629     function exchangeSynthsForSynthetix(uint synthAmount)
4630         public
4631         pricesNotStale
4632         notPaused
4633         returns (uint) // Returns the number of SNX received
4634     {
4635         // How many SNX are they going to be receiving?
4636         uint synthetixToSend = synthetixReceivedForSynths(synthAmount);
4637 
4638         // Ok, transfer the Synths to our funds wallet.
4639         // These do not go in the deposit queue as they aren't for sale as such unless
4640         // they're sent back in from the funds wallet.
4641         synth.transferFrom(msg.sender, fundsWallet, synthAmount);
4642 
4643         // And send them the SNX.
4644         synthetix.transfer(msg.sender, synthetixToSend);
4645 
4646         emit Exchange("sUSD", synthAmount, "SNX", synthetixToSend);
4647 
4648         return synthetixToSend;
4649     }
4650 
4651     /**
4652      * @notice Exchange sUSD for SNX while insisting on a particular rate. This allows a user to
4653      *         exchange while protecting against frontrunning by the contract owner on the exchange rate.
4654      * @param synthAmount The amount of synths the user wishes to exchange.
4655      * @param guaranteedRate A rate (synthetix price) the caller wishes to insist upon.
4656      */
4657     function exchangeSynthsForSynthetixAtRate(uint synthAmount, uint guaranteedRate)
4658         public
4659         pricesNotStale
4660         notPaused
4661         returns (uint) // Returns the number of SNX received
4662     {
4663         require(guaranteedRate == usdToSnxPrice, "Guaranteed rate would not be received");
4664 
4665         return exchangeSynthsForSynthetix(synthAmount);
4666     }
4667 
4668     /**
4669      * @notice Allows the owner to withdraw SNX from this contract if needed.
4670      * @param amount The amount of SNX to attempt to withdraw (in 18 decimal places).
4671      */
4672     function withdrawSynthetix(uint amount)
4673         external
4674         onlyOwner
4675     {
4676         synthetix.transfer(owner, amount);
4677 
4678         // We don't emit our own events here because we assume that anyone
4679         // who wants to watch what the Issuance Controller is doing can
4680         // just watch ERC20 events from the Synth and/or Synthetix contracts
4681         // filtered to our address.
4682     }
4683 
4684     /**
4685      * @notice Allows a user to withdraw all of their previously deposited synths from this contract if needed.
4686      *         Developer note: We could keep an index of address to deposits to make this operation more efficient
4687      *         but then all the other operations on the queue become less efficient. It's expected that this
4688      *         function will be very rarely used, so placing the inefficiency here is intentional. The usual
4689      *         use case does not involve a withdrawal.
4690      */
4691     function withdrawMyDepositedSynths()
4692         external
4693     {
4694         uint synthsToSend = 0;
4695 
4696         for (uint i = depositStartIndex; i < depositEndIndex; i++) {
4697             synthDeposit memory deposit = deposits[i];
4698 
4699             if (deposit.user == msg.sender) {
4700                 // The user is withdrawing this deposit. Remove it from our queue.
4701                 // We'll just leave a gap, which the purchasing logic can walk past.
4702                 synthsToSend = synthsToSend.add(deposit.amount);
4703                 delete deposits[i];
4704                 //Let the DApps know we've removed this deposit
4705                 emit SynthDepositRemoved(deposit.user, deposit.amount, i);
4706             }
4707         }
4708 
4709         // Update our total
4710         totalSellableDeposits = totalSellableDeposits.sub(synthsToSend);
4711 
4712         // Check if the user has tried to send deposit amounts < the minimumDepositAmount to the FIFO
4713         // queue which would have been added to this mapping for withdrawal only
4714         synthsToSend = synthsToSend.add(smallDeposits[msg.sender]);
4715         smallDeposits[msg.sender] = 0;
4716 
4717         // If there's nothing to do then go ahead and revert the transaction
4718         require(synthsToSend > 0, "You have no deposits to withdraw.");
4719 
4720         // Send their deposits back to them (minus fees)
4721         synth.transfer(msg.sender, synthsToSend);
4722 
4723         emit SynthWithdrawal(msg.sender, synthsToSend);
4724     }
4725 
4726     /**
4727      * @notice depositSynths: Allows users to deposit synths via the approve / transferFrom workflow
4728      *         if they'd like. You can equally just transfer synths to this contract and it will work
4729      *         exactly the same way but with one less call (and therefore cheaper transaction fees)
4730      * @param amount The amount of sUSD you wish to deposit (must have been approved first)
4731      */
4732     function depositSynths(uint amount)
4733         external
4734     {
4735         // Grab the amount of synths
4736         synth.transferFrom(msg.sender, this, amount);
4737 
4738         // Note, we don't need to add them to the deposit list below, as the Synth contract itself will
4739         // call tokenFallback when the transfer happens, adding their deposit to the queue.
4740     }
4741 
4742     /**
4743      * @notice Triggers when users send us SNX or sUSD, but the modifier only allows sUSD calls to proceed.
4744      * @param from The address sending the sUSD
4745      * @param amount The amount of sUSD
4746      */
4747     function tokenFallback(address from, uint amount, bytes data)
4748         external
4749         onlySynth
4750         returns (bool)
4751     {
4752         // A minimum deposit amount is designed to protect purchasers from over paying
4753         // gas for fullfilling multiple small synth deposits
4754         if (amount < minimumDepositAmount) {
4755             // We cant fail/revert the transaction or send the synths back in a reentrant call.
4756             // So we will keep your synths balance seperate from the FIFO queue so you can withdraw them
4757             smallDeposits[from] = smallDeposits[from].add(amount);
4758 
4759             emit SynthDepositNotAccepted(from, amount, minimumDepositAmount);
4760         } else {
4761             // Ok, thanks for the deposit, let's queue it up.
4762             deposits[depositEndIndex] = synthDeposit({ user: from, amount: amount });
4763             emit SynthDeposit(from, amount, depositEndIndex);
4764 
4765             // Walk our index forward as well.
4766             depositEndIndex = depositEndIndex.add(1);
4767 
4768             // And add it to our total.
4769             totalSellableDeposits = totalSellableDeposits.add(amount);
4770         }
4771     }
4772 
4773     /* ========== VIEWS ========== */
4774     /**
4775      * @notice Check if the prices haven't been updated for longer than the stale period.
4776      */
4777     function pricesAreStale()
4778         public
4779         view
4780         returns (bool)
4781     {
4782         return lastPriceUpdateTime.add(priceStalePeriod) < now;
4783     }
4784 
4785     /**
4786      * @notice Calculate how many SNX you will receive if you transfer
4787      *         an amount of synths.
4788      * @param amount The amount of synths (in 18 decimal places) you want to ask about
4789      */
4790     function synthetixReceivedForSynths(uint amount)
4791         public
4792         view
4793         returns (uint)
4794     {
4795         // How many synths would we receive after the transfer fee?
4796         uint synthsReceived = feePool.amountReceivedFromTransfer(amount);
4797 
4798         // And what would that be worth in SNX based on the current price?
4799         return synthsReceived.divideDecimal(usdToSnxPrice);
4800     }
4801 
4802     /**
4803      * @notice Calculate how many SNX you will receive if you transfer
4804      *         an amount of ether.
4805      * @param amount The amount of ether (in wei) you want to ask about
4806      */
4807     function synthetixReceivedForEther(uint amount)
4808         public
4809         view
4810         returns (uint)
4811     {
4812         // How much is the ETH they sent us worth in sUSD (ignoring the transfer fee)?
4813         uint valueSentInSynths = amount.multiplyDecimal(usdToEthPrice);
4814 
4815         // Now, how many SNX will that USD amount buy?
4816         return synthetixReceivedForSynths(valueSentInSynths);
4817     }
4818 
4819     /**
4820      * @notice Calculate how many synths you will receive if you transfer
4821      *         an amount of ether.
4822      * @param amount The amount of ether (in wei) you want to ask about
4823      */
4824     function synthsReceivedForEther(uint amount)
4825         public
4826         view
4827         returns (uint)
4828     {
4829         // How many synths would that amount of ether be worth?
4830         uint synthsTransferred = amount.multiplyDecimal(usdToEthPrice);
4831 
4832         // And how many of those would you receive after a transfer (deducting the transfer fee)
4833         return feePool.amountReceivedFromTransfer(synthsTransferred);
4834     }
4835 
4836     /* ========== MODIFIERS ========== */
4837 
4838     modifier onlyOracle
4839     {
4840         require(msg.sender == oracle, "Only the oracle can perform this action");
4841         _;
4842     }
4843 
4844     modifier onlySynth
4845     {
4846         // We're only interested in doing anything on receiving sUSD.
4847         require(msg.sender == address(synth), "Only the synth contract can perform this action");
4848         _;
4849     }
4850 
4851     modifier pricesNotStale
4852     {
4853         require(!pricesAreStale(), "Prices must not be stale to perform this action");
4854         _;
4855     }
4856 
4857     /* ========== EVENTS ========== */
4858 
4859     event FundsWalletUpdated(address newFundsWallet);
4860     event OracleUpdated(address newOracle);
4861     event SynthUpdated(Synth newSynthContract);
4862     event SynthetixUpdated(Synthetix newSynthetixContract);
4863     event PriceStalePeriodUpdated(uint priceStalePeriod);
4864     event PricesUpdated(uint newEthPrice, uint newSynthetixPrice, uint timeSent);
4865     event Exchange(string fromCurrency, uint fromAmount, string toCurrency, uint toAmount);
4866     event SynthWithdrawal(address user, uint amount);
4867     event SynthDeposit(address indexed user, uint amount, uint indexed depositIndex);
4868     event SynthDepositRemoved(address indexed user, uint amount, uint indexed depositIndex);
4869     event SynthDepositNotAccepted(address user, uint amount, uint minimum);
4870     event MinimumDepositAmountUpdated(uint amount);
4871     event NonPayableContract(address indexed receiver, uint amount);
4872     event ClearedDeposit(address indexed fromAddress, address indexed toAddress, uint fromETHAmount, uint toAmount, uint indexed depositIndex);
4873 }
4874 
