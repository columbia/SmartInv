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
93 
94 /*
95 -----------------------------------------------------------------
96 FILE INFORMATION
97 -----------------------------------------------------------------
98 
99 file:       Proxy.sol
100 version:    1.3
101 author:     Anton Jurisevic
102 
103 date:       2018-05-29
104 
105 -----------------------------------------------------------------
106 MODULE DESCRIPTION
107 -----------------------------------------------------------------
108 
109 A proxy contract that, if it does not recognise the function
110 being called on it, passes all value and call data to an
111 underlying target contract.
112 
113 This proxy has the capacity to toggle between DELEGATECALL
114 and CALL style proxy functionality.
115 
116 The former executes in the proxy's context, and so will preserve 
117 msg.sender and store data at the proxy address. The latter will not.
118 Therefore, any contract the proxy wraps in the CALL style must
119 implement the Proxyable interface, in order that it can pass msg.sender
120 into the underlying contract as the state parameter, messageSender.
121 
122 -----------------------------------------------------------------
123 */
124 
125 
126 contract Proxy is Owned {
127 
128     Proxyable public target;
129     bool public useDELEGATECALL;
130 
131     constructor(address _owner)
132         Owned(_owner)
133         public
134     {}
135 
136     function setTarget(Proxyable _target)
137         external
138         onlyOwner
139     {
140         target = _target;
141         emit TargetUpdated(_target);
142     }
143 
144     function setUseDELEGATECALL(bool value) 
145         external
146         onlyOwner
147     {
148         useDELEGATECALL = value;
149     }
150 
151     function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)
152         external
153         onlyTarget
154     {
155         uint size = callData.length;
156         bytes memory _callData = callData;
157 
158         assembly {
159             /* The first 32 bytes of callData contain its length (as specified by the abi). 
160              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
161              * in length. It is also leftpadded to be a multiple of 32 bytes.
162              * This means moving call_data across 32 bytes guarantees we correctly access
163              * the data itself. */
164             switch numTopics
165             case 0 {
166                 log0(add(_callData, 32), size)
167             } 
168             case 1 {
169                 log1(add(_callData, 32), size, topic1)
170             }
171             case 2 {
172                 log2(add(_callData, 32), size, topic1, topic2)
173             }
174             case 3 {
175                 log3(add(_callData, 32), size, topic1, topic2, topic3)
176             }
177             case 4 {
178                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
179             }
180         }
181     }
182 
183     function()
184         external
185         payable
186     {
187         if (useDELEGATECALL) {
188             assembly {
189                 /* Copy call data into free memory region. */
190                 let free_ptr := mload(0x40)
191                 calldatacopy(free_ptr, 0, calldatasize)
192 
193                 /* Forward all gas and call data to the target contract. */
194                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
195                 returndatacopy(free_ptr, 0, returndatasize)
196 
197                 /* Revert if the call failed, otherwise return the result. */
198                 if iszero(result) { revert(free_ptr, returndatasize) }
199                 return(free_ptr, returndatasize)
200             }
201         } else {
202             /* Here we are as above, but must send the messageSender explicitly 
203              * since we are using CALL rather than DELEGATECALL. */
204             target.setMessageSender(msg.sender);
205             assembly {
206                 let free_ptr := mload(0x40)
207                 calldatacopy(free_ptr, 0, calldatasize)
208 
209                 /* We must explicitly forward ether to the underlying contract as well. */
210                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
211                 returndatacopy(free_ptr, 0, returndatasize)
212 
213                 if iszero(result) { revert(free_ptr, returndatasize) }
214                 return(free_ptr, returndatasize)
215             }
216         }
217     }
218 
219     modifier onlyTarget {
220         require(Proxyable(msg.sender) == target, "Must be proxy target");
221         _;
222     }
223 
224     event TargetUpdated(Proxyable newTarget);
225 }
226 
227 
228 /*
229 -----------------------------------------------------------------
230 FILE INFORMATION
231 -----------------------------------------------------------------
232 
233 file:       Proxyable.sol
234 version:    1.1
235 author:     Anton Jurisevic
236 
237 date:       2018-05-15
238 
239 checked:    Mike Spain
240 approved:   Samuel Brooks
241 
242 -----------------------------------------------------------------
243 MODULE DESCRIPTION
244 -----------------------------------------------------------------
245 
246 A proxyable contract that works hand in hand with the Proxy contract
247 to allow for anyone to interact with the underlying contract both
248 directly and through the proxy.
249 
250 -----------------------------------------------------------------
251 */
252 
253 
254 // This contract should be treated like an abstract contract
255 contract Proxyable is Owned {
256     /* The proxy this contract exists behind. */
257     Proxy public proxy;
258 
259     /* The caller of the proxy, passed through to this contract.
260      * Note that every function using this member must apply the onlyProxy or
261      * optionalProxy modifiers, otherwise their invocations can use stale values. */ 
262     address messageSender; 
263 
264     constructor(address _proxy, address _owner)
265         Owned(_owner)
266         public
267     {
268         proxy = Proxy(_proxy);
269         emit ProxyUpdated(_proxy);
270     }
271 
272     function setProxy(address _proxy)
273         external
274         onlyOwner
275     {
276         proxy = Proxy(_proxy);
277         emit ProxyUpdated(_proxy);
278     }
279 
280     function setMessageSender(address sender)
281         external
282         onlyProxy
283     {
284         messageSender = sender;
285     }
286 
287     modifier onlyProxy {
288         require(Proxy(msg.sender) == proxy, "Only the proxy can call this function");
289         _;
290     }
291 
292     modifier optionalProxy
293     {
294         if (Proxy(msg.sender) != proxy) {
295             messageSender = msg.sender;
296         }
297         _;
298     }
299 
300     modifier optionalProxy_onlyOwner
301     {
302         if (Proxy(msg.sender) != proxy) {
303             messageSender = msg.sender;
304         }
305         require(messageSender == owner, "This action can only be performed by the owner");
306         _;
307     }
308 
309     event ProxyUpdated(address proxyAddress);
310 }
311 
312 
313 /*
314 -----------------------------------------------------------------
315 FILE INFORMATION
316 -----------------------------------------------------------------
317 
318 file:       SelfDestructible.sol
319 version:    1.2
320 author:     Anton Jurisevic
321 
322 date:       2018-05-29
323 
324 -----------------------------------------------------------------
325 MODULE DESCRIPTION
326 -----------------------------------------------------------------
327 
328 This contract allows an inheriting contract to be destroyed after
329 its owner indicates an intention and then waits for a period
330 without changing their mind. All ether contained in the contract
331 is forwarded to a nominated beneficiary upon destruction.
332 
333 -----------------------------------------------------------------
334 */
335 
336 
337 /**
338  * @title A contract that can be destroyed by its owner after a delay elapses.
339  */
340 contract SelfDestructible is Owned {
341     
342     uint public initiationTime;
343     bool public selfDestructInitiated;
344     address public selfDestructBeneficiary;
345     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
346 
347     /**
348      * @dev Constructor
349      * @param _owner The account which controls this contract.
350      */
351     constructor(address _owner)
352         Owned(_owner)
353         public
354     {
355         require(_owner != address(0), "Owner must not be the zero address");
356         selfDestructBeneficiary = _owner;
357         emit SelfDestructBeneficiaryUpdated(_owner);
358     }
359 
360     /**
361      * @notice Set the beneficiary address of this contract.
362      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
363      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
364      */
365     function setSelfDestructBeneficiary(address _beneficiary)
366         external
367         onlyOwner
368     {
369         require(_beneficiary != address(0), "Beneficiary must not be the zero address");
370         selfDestructBeneficiary = _beneficiary;
371         emit SelfDestructBeneficiaryUpdated(_beneficiary);
372     }
373 
374     /**
375      * @notice Begin the self-destruction counter of this contract.
376      * Once the delay has elapsed, the contract may be self-destructed.
377      * @dev Only the contract owner may call this.
378      */
379     function initiateSelfDestruct()
380         external
381         onlyOwner
382     {
383         initiationTime = now;
384         selfDestructInitiated = true;
385         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
386     }
387 
388     /**
389      * @notice Terminate and reset the self-destruction timer.
390      * @dev Only the contract owner may call this.
391      */
392     function terminateSelfDestruct()
393         external
394         onlyOwner
395     {
396         initiationTime = 0;
397         selfDestructInitiated = false;
398         emit SelfDestructTerminated();
399     }
400 
401     /**
402      * @notice If the self-destruction delay has elapsed, destroy this contract and
403      * remit any ether it owns to the beneficiary address.
404      * @dev Only the contract owner may call this.
405      */
406     function selfDestruct()
407         external
408         onlyOwner
409     {
410         require(selfDestructInitiated, "Self destruct has not yet been initiated");
411         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay has not yet elapsed");
412         address beneficiary = selfDestructBeneficiary;
413         emit SelfDestructed(beneficiary);
414         selfdestruct(beneficiary);
415     }
416 
417     event SelfDestructTerminated();
418     event SelfDestructed(address beneficiary);
419     event SelfDestructInitiated(uint selfDestructDelay);
420     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
421 }
422 
423 
424 /**
425  * @title SafeMath
426  * @dev Math operations with safety checks that revert on error
427  */
428 library SafeMath {
429 
430   /**
431   * @dev Multiplies two numbers, reverts on overflow.
432   */
433   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
434     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
435     // benefit is lost if 'b' is also tested.
436     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
437     if (a == 0) {
438       return 0;
439     }
440 
441     uint256 c = a * b;
442     require(c / a == b);
443 
444     return c;
445   }
446 
447   /**
448   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
449   */
450   function div(uint256 a, uint256 b) internal pure returns (uint256) {
451     require(b > 0); // Solidity only automatically asserts when dividing by 0
452     uint256 c = a / b;
453     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
454 
455     return c;
456   }
457 
458   /**
459   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
460   */
461   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
462     require(b <= a);
463     uint256 c = a - b;
464 
465     return c;
466   }
467 
468   /**
469   * @dev Adds two numbers, reverts on overflow.
470   */
471   function add(uint256 a, uint256 b) internal pure returns (uint256) {
472     uint256 c = a + b;
473     require(c >= a);
474 
475     return c;
476   }
477 
478   /**
479   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
480   * reverts when dividing by zero.
481   */
482   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
483     require(b != 0);
484     return a % b;
485   }
486 }
487 
488 
489 /*
490 
491 -----------------------------------------------------------------
492 FILE INFORMATION
493 -----------------------------------------------------------------
494 
495 file:       SafeDecimalMath.sol
496 version:    2.0
497 author:     Kevin Brown
498             Gavin Conway
499 date:       2018-10-18
500 
501 -----------------------------------------------------------------
502 MODULE DESCRIPTION
503 -----------------------------------------------------------------
504 
505 A library providing safe mathematical operations for division and
506 multiplication with the capability to round or truncate the results
507 to the nearest increment. Operations can return a standard precision
508 or high precision decimal. High precision decimals are useful for
509 example when attempting to calculate percentages or fractions
510 accurately.
511 
512 -----------------------------------------------------------------
513 */
514 
515 
516 /**
517  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
518  * @dev Functions accepting uints in this contract and derived contracts
519  * are taken to be such fixed point decimals of a specified precision (either standard
520  * or high).
521  */
522 library SafeDecimalMath {
523 
524     using SafeMath for uint;
525 
526     /* Number of decimal places in the representations. */
527     uint8 public constant decimals = 18;
528     uint8 public constant highPrecisionDecimals = 27;
529 
530     /* The number representing 1.0. */
531     uint public constant UNIT = 10 ** uint(decimals);
532 
533     /* The number representing 1.0 for higher fidelity numbers. */
534     uint public constant PRECISE_UNIT = 10 ** uint(highPrecisionDecimals);
535     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10 ** uint(highPrecisionDecimals - decimals);
536 
537     /** 
538      * @return Provides an interface to UNIT.
539      */
540     function unit()
541         external
542         pure
543         returns (uint)
544     {
545         return UNIT;
546     }
547 
548     /** 
549      * @return Provides an interface to PRECISE_UNIT.
550      */
551     function preciseUnit()
552         external
553         pure 
554         returns (uint)
555     {
556         return PRECISE_UNIT;
557     }
558 
559     /**
560      * @return The result of multiplying x and y, interpreting the operands as fixed-point
561      * decimals.
562      * 
563      * @dev A unit factor is divided out after the product of x and y is evaluated,
564      * so that product must be less than 2**256. As this is an integer division,
565      * the internal division always rounds down. This helps save on gas. Rounding
566      * is more expensive on gas.
567      */
568     function multiplyDecimal(uint x, uint y)
569         internal
570         pure
571         returns (uint)
572     {
573         /* Divide by UNIT to remove the extra factor introduced by the product. */
574         return x.mul(y) / UNIT;
575     }
576 
577     /**
578      * @return The result of safely multiplying x and y, interpreting the operands
579      * as fixed-point decimals of the specified precision unit.
580      *
581      * @dev The operands should be in the form of a the specified unit factor which will be
582      * divided out after the product of x and y is evaluated, so that product must be
583      * less than 2**256.
584      *
585      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
586      * Rounding is useful when you need to retain fidelity for small decimal numbers
587      * (eg. small fractions or percentages).
588      */
589     function _multiplyDecimalRound(uint x, uint y, uint precisionUnit)
590         private
591         pure
592         returns (uint)
593     {
594         /* Divide by UNIT to remove the extra factor introduced by the product. */
595         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
596 
597         if (quotientTimesTen % 10 >= 5) {
598             quotientTimesTen += 10;
599         }
600 
601         return quotientTimesTen / 10;
602     }
603 
604     /**
605      * @return The result of safely multiplying x and y, interpreting the operands
606      * as fixed-point decimals of a precise unit.
607      *
608      * @dev The operands should be in the precise unit factor which will be
609      * divided out after the product of x and y is evaluated, so that product must be
610      * less than 2**256.
611      *
612      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
613      * Rounding is useful when you need to retain fidelity for small decimal numbers
614      * (eg. small fractions or percentages).
615      */
616     function multiplyDecimalRoundPrecise(uint x, uint y)
617         internal
618         pure
619         returns (uint)
620     {
621         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
622     }
623 
624     /**
625      * @return The result of safely multiplying x and y, interpreting the operands
626      * as fixed-point decimals of a standard unit.
627      *
628      * @dev The operands should be in the standard unit factor which will be
629      * divided out after the product of x and y is evaluated, so that product must be
630      * less than 2**256.
631      *
632      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
633      * Rounding is useful when you need to retain fidelity for small decimal numbers
634      * (eg. small fractions or percentages).
635      */
636     function multiplyDecimalRound(uint x, uint y)
637         internal
638         pure
639         returns (uint)
640     {
641         return _multiplyDecimalRound(x, y, UNIT);
642     }
643 
644     /**
645      * @return The result of safely dividing x and y. The return value is a high
646      * precision decimal.
647      * 
648      * @dev y is divided after the product of x and the standard precision unit
649      * is evaluated, so the product of x and UNIT must be less than 2**256. As
650      * this is an integer division, the result is always rounded down.
651      * This helps save on gas. Rounding is more expensive on gas.
652      */
653     function divideDecimal(uint x, uint y)
654         internal
655         pure
656         returns (uint)
657     {
658         /* Reintroduce the UNIT factor that will be divided out by y. */
659         return x.mul(UNIT).div(y);
660     }
661 
662     /**
663      * @return The result of safely dividing x and y. The return value is as a rounded
664      * decimal in the precision unit specified in the parameter.
665      *
666      * @dev y is divided after the product of x and the specified precision unit
667      * is evaluated, so the product of x and the specified precision unit must
668      * be less than 2**256. The result is rounded to the nearest increment.
669      */
670     function _divideDecimalRound(uint x, uint y, uint precisionUnit)
671         private
672         pure
673         returns (uint)
674     {
675         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
676 
677         if (resultTimesTen % 10 >= 5) {
678             resultTimesTen += 10;
679         }
680 
681         return resultTimesTen / 10;
682     }
683 
684     /**
685      * @return The result of safely dividing x and y. The return value is as a rounded
686      * standard precision decimal.
687      *
688      * @dev y is divided after the product of x and the standard precision unit
689      * is evaluated, so the product of x and the standard precision unit must
690      * be less than 2**256. The result is rounded to the nearest increment.
691      */
692     function divideDecimalRound(uint x, uint y)
693         internal
694         pure
695         returns (uint)
696     {
697         return _divideDecimalRound(x, y, UNIT);
698     }
699 
700     /**
701      * @return The result of safely dividing x and y. The return value is as a rounded
702      * high precision decimal.
703      *
704      * @dev y is divided after the product of x and the high precision unit
705      * is evaluated, so the product of x and the high precision unit must
706      * be less than 2**256. The result is rounded to the nearest increment.
707      */
708     function divideDecimalRoundPrecise(uint x, uint y)
709         internal
710         pure
711         returns (uint)
712     {
713         return _divideDecimalRound(x, y, PRECISE_UNIT);
714     }
715 
716     /**
717      * @dev Convert a standard decimal representation to a high precision one.
718      */
719     function decimalToPreciseDecimal(uint i)
720         internal
721         pure
722         returns (uint)
723     {
724         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
725     }
726 
727     /**
728      * @dev Convert a high precision decimal to a standard decimal representation.
729      */
730     function preciseDecimalToDecimal(uint i)
731         internal
732         pure
733         returns (uint)
734     {
735         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
736 
737         if (quotientTimesTen % 10 >= 5) {
738             quotientTimesTen += 10;
739         }
740 
741         return quotientTimesTen / 10;
742     }
743 
744 }
745 
746 
747 /*
748 -----------------------------------------------------------------
749 FILE INFORMATION
750 -----------------------------------------------------------------
751 
752 file:       State.sol
753 version:    1.1
754 author:     Dominic Romanowski
755             Anton Jurisevic
756 
757 date:       2018-05-15
758 
759 -----------------------------------------------------------------
760 MODULE DESCRIPTION
761 -----------------------------------------------------------------
762 
763 This contract is used side by side with external state token
764 contracts, such as Synthetix and Synth.
765 It provides an easy way to upgrade contract logic while
766 maintaining all user balances and allowances. This is designed
767 to make the changeover as easy as possible, since mappings
768 are not so cheap or straightforward to migrate.
769 
770 The first deployed contract would create this state contract,
771 using it as its store of balances.
772 When a new contract is deployed, it links to the existing
773 state contract, whose owner would then change its associated
774 contract to the new one.
775 
776 -----------------------------------------------------------------
777 */
778 
779 
780 contract State is Owned {
781     // the address of the contract that can modify variables
782     // this can only be changed by the owner of this contract
783     address public associatedContract;
784 
785 
786     constructor(address _owner, address _associatedContract)
787         Owned(_owner)
788         public
789     {
790         associatedContract = _associatedContract;
791         emit AssociatedContractUpdated(_associatedContract);
792     }
793 
794     /* ========== SETTERS ========== */
795 
796     // Change the associated contract to a new address
797     function setAssociatedContract(address _associatedContract)
798         external
799         onlyOwner
800     {
801         associatedContract = _associatedContract;
802         emit AssociatedContractUpdated(_associatedContract);
803     }
804 
805     /* ========== MODIFIERS ========== */
806 
807     modifier onlyAssociatedContract
808     {
809         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
810         _;
811     }
812 
813     /* ========== EVENTS ========== */
814 
815     event AssociatedContractUpdated(address associatedContract);
816 }
817 
818 
819 /*
820 -----------------------------------------------------------------
821 FILE INFORMATION
822 -----------------------------------------------------------------
823 
824 file:       TokenState.sol
825 version:    1.1
826 author:     Dominic Romanowski
827             Anton Jurisevic
828 
829 date:       2018-05-15
830 
831 -----------------------------------------------------------------
832 MODULE DESCRIPTION
833 -----------------------------------------------------------------
834 
835 A contract that holds the state of an ERC20 compliant token.
836 
837 This contract is used side by side with external state token
838 contracts, such as Synthetix and Synth.
839 It provides an easy way to upgrade contract logic while
840 maintaining all user balances and allowances. This is designed
841 to make the changeover as easy as possible, since mappings
842 are not so cheap or straightforward to migrate.
843 
844 The first deployed contract would create this state contract,
845 using it as its store of balances.
846 When a new contract is deployed, it links to the existing
847 state contract, whose owner would then change its associated
848 contract to the new one.
849 
850 -----------------------------------------------------------------
851 */
852 
853 
854 /**
855  * @title ERC20 Token State
856  * @notice Stores balance information of an ERC20 token contract.
857  */
858 contract TokenState is State {
859 
860     /* ERC20 fields. */
861     mapping(address => uint) public balanceOf;
862     mapping(address => mapping(address => uint)) public allowance;
863 
864     /**
865      * @dev Constructor
866      * @param _owner The address which controls this contract.
867      * @param _associatedContract The ERC20 contract whose state this composes.
868      */
869     constructor(address _owner, address _associatedContract)
870         State(_owner, _associatedContract)
871         public
872     {}
873 
874     /* ========== SETTERS ========== */
875 
876     /**
877      * @notice Set ERC20 allowance.
878      * @dev Only the associated contract may call this.
879      * @param tokenOwner The authorising party.
880      * @param spender The authorised party.
881      * @param value The total value the authorised party may spend on the
882      * authorising party's behalf.
883      */
884     function setAllowance(address tokenOwner, address spender, uint value)
885         external
886         onlyAssociatedContract
887     {
888         allowance[tokenOwner][spender] = value;
889     }
890 
891     /**
892      * @notice Set the balance in a given account
893      * @dev Only the associated contract may call this.
894      * @param account The account whose value to set.
895      * @param value The new balance of the given account.
896      */
897     function setBalanceOf(address account, uint value)
898         external
899         onlyAssociatedContract
900     {
901         balanceOf[account] = value;
902     }
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
3645 
3646 
3647 /*
3648 -----------------------------------------------------------------
3649 FILE INFORMATION
3650 -----------------------------------------------------------------
3651 
3652 file:       FeePoolState.sol
3653 version:    1.0
3654 author:     Clinton Ennis
3655             Jackson Chan
3656 date:       2019-04-05
3657 
3658 -----------------------------------------------------------------
3659 MODULE DESCRIPTION
3660 -----------------------------------------------------------------
3661 
3662 The FeePoolState simply stores the accounts issuance ratio for
3663 each fee period in the FeePool.
3664 
3665 This is use to caclulate the correct allocation of fees/rewards
3666 owed to minters of the stablecoin total supply
3667 
3668 -----------------------------------------------------------------
3669 */
3670 
3671 
3672 contract FeePoolState is SelfDestructible, LimitedSetup {
3673     using SafeMath for uint;
3674     using SafeDecimalMath for uint;
3675 
3676     /* ========== STATE VARIABLES ========== */
3677 
3678     uint8 constant public FEE_PERIOD_LENGTH = 6;
3679 
3680     address public feePool;
3681 
3682     // The IssuanceData activity that's happened in a fee period.
3683     struct IssuanceData {
3684         uint debtPercentage;
3685         uint debtEntryIndex;
3686     }
3687 
3688     // The IssuanceData activity that's happened in a fee period.
3689     mapping(address => IssuanceData[FEE_PERIOD_LENGTH]) public accountIssuanceLedger;
3690 
3691     /**
3692      * @dev Constructor.
3693      * @param _owner The owner of this contract.
3694      */
3695     constructor(address _owner, IFeePool _feePool)
3696         SelfDestructible(_owner)
3697         LimitedSetup(6 weeks)
3698         public
3699     {
3700         feePool = _feePool;
3701     }
3702 
3703     /* ========== SETTERS ========== */
3704 
3705     /**
3706      * @notice set the FeePool contract as it is the only authority to be able to call
3707      * appendAccountIssuanceRecord with the onlyFeePool modifer
3708      * @dev Must be set by owner when FeePool logic is upgraded
3709      */
3710     function setFeePool(IFeePool _feePool)
3711         external
3712         onlyOwner
3713     {
3714         feePool = _feePool;
3715     }
3716 
3717     /* ========== VIEWS ========== */
3718 
3719     /**
3720      * @notice Get an accounts issuanceData for
3721      * @param account users account
3722      * @param index Index in the array to retrieve. Upto FEE_PERIOD_LENGTH
3723      */
3724     function getAccountsDebtEntry(address account, uint index)
3725         public
3726         view
3727         returns (uint debtPercentage, uint debtEntryIndex)
3728     {
3729         require(index < FEE_PERIOD_LENGTH, "index exceeds the FEE_PERIOD_LENGTH");
3730 
3731         debtPercentage = accountIssuanceLedger[account][index].debtPercentage;
3732         debtEntryIndex = accountIssuanceLedger[account][index].debtEntryIndex;
3733     }
3734 
3735     /**
3736      * @notice Find the oldest debtEntryIndex for the corresponding closingDebtIndex
3737      * @param account users account
3738      * @param closingDebtIndex the last periods debt index on close
3739      */
3740     function applicableIssuanceData(address account, uint closingDebtIndex)
3741         external
3742         view
3743         returns (uint, uint)
3744     {
3745         IssuanceData[FEE_PERIOD_LENGTH] memory issuanceData = accountIssuanceLedger[account];
3746         
3747         // We want to use the user's debtEntryIndex at when the period closed
3748         // Find the oldest debtEntryIndex for the corresponding closingDebtIndex
3749         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
3750             if (closingDebtIndex >= issuanceData[i].debtEntryIndex) {
3751                 return (issuanceData[i].debtPercentage, issuanceData[i].debtEntryIndex);
3752             }
3753         }
3754     }
3755 
3756     /* ========== MUTATIVE FUNCTIONS ========== */
3757 
3758     /**
3759      * @notice Logs an accounts issuance data in the current fee period which is then stored historically
3760      * @param account Message.Senders account address
3761      * @param debtRatio Debt percentage this account has locked after minting or burning their synth
3762      * @param debtEntryIndex The index in the global debt ledger. synthetix.synthetixState().issuanceData(account)
3763      * @param currentPeriodStartDebtIndex The startingDebtIndex of the current fee period
3764      * @dev onlyFeePool to call me on synthetix.issue() & synthetix.burn() calls to store the locked SNX
3765      * per fee period so we know to allocate the correct proportions of fees and rewards per period
3766       accountIssuanceLedger[account][0] has the latest locked amount for the current period. This can be update as many time
3767       accountIssuanceLedger[account][1-3] has the last locked amount for a previous period they minted or burned
3768      */
3769     function appendAccountIssuanceRecord(address account, uint debtRatio, uint debtEntryIndex, uint currentPeriodStartDebtIndex)
3770         external
3771         onlyFeePool
3772     {
3773         // Is the current debtEntryIndex within this fee period
3774         if (accountIssuanceLedger[account][0].debtEntryIndex < currentPeriodStartDebtIndex) {
3775              // If its older then shift the previous IssuanceData entries periods down to make room for the new one.
3776             issuanceDataIndexOrder(account);
3777         }
3778         
3779         // Always store the latest IssuanceData entry at [0]
3780         accountIssuanceLedger[account][0].debtPercentage = debtRatio;
3781         accountIssuanceLedger[account][0].debtEntryIndex = debtEntryIndex;
3782     }
3783 
3784     /**
3785      * @notice Pushes down the entire array of debt ratios per fee period
3786      */
3787     function issuanceDataIndexOrder(address account)
3788         private
3789     {
3790         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
3791             uint next = i + 1;
3792             accountIssuanceLedger[account][next].debtPercentage = accountIssuanceLedger[account][i].debtPercentage;
3793             accountIssuanceLedger[account][next].debtEntryIndex = accountIssuanceLedger[account][i].debtEntryIndex;
3794         }
3795     }
3796 
3797     /**
3798      * @notice Import issuer data from synthetixState.issuerData on FeePeriodClose() block #
3799      * @dev Only callable by the contract owner, and only for 6 weeks after deployment.
3800      * @param accounts Array of issuing addresses
3801      * @param ratios Array of debt ratios
3802      * @param periodToInsert The Fee Period to insert the historical records into
3803      * @param feePeriodCloseIndex An accounts debtEntryIndex is valid when within the fee peroid,
3804      * since the input ratio will be an average of the pervious periods it just needs to be
3805      * > recentFeePeriods[periodToInsert].startingDebtIndex
3806      * < recentFeePeriods[periodToInsert - 1].startingDebtIndex
3807      */
3808     function importIssuerData(address[] accounts, uint[] ratios, uint periodToInsert, uint feePeriodCloseIndex)
3809         external
3810         onlyOwner
3811         onlyDuringSetup
3812     {
3813         require(accounts.length == ratios.length, "Length mismatch");
3814 
3815         for (uint8 i = 0; i < accounts.length; i++) {
3816             accountIssuanceLedger[accounts[i]][periodToInsert].debtPercentage = ratios[i];
3817             accountIssuanceLedger[accounts[i]][periodToInsert].debtEntryIndex = feePeriodCloseIndex;
3818             emit IssuanceDebtRatioEntry(accounts[i], ratios[i], feePeriodCloseIndex);
3819         }
3820     }
3821 
3822     /* ========== MODIFIERS ========== */
3823 
3824     modifier onlyFeePool
3825     {
3826         require(msg.sender == address(feePool), "Only the FeePool contract can perform this action");
3827         _;
3828     }
3829 
3830     /* ========== Events ========== */
3831     event IssuanceDebtRatioEntry(address indexed account, uint debtRatio, uint feePeriodCloseIndex);
3832 }
3833 
3834 
3835 /*
3836 -----------------------------------------------------------------
3837 FILE INFORMATION
3838 -----------------------------------------------------------------
3839 
3840 file:       EternalStorage.sol
3841 version:    1.0
3842 author:     Clinton Ennise
3843             Jackson Chan
3844 
3845 date:       2019-02-01
3846 
3847 -----------------------------------------------------------------
3848 MODULE DESCRIPTION
3849 -----------------------------------------------------------------
3850 
3851 This contract is used with external state storage contracts for
3852 decoupled data storage.
3853 
3854 Implements support for storing a keccak256 key and value pairs. It is
3855 the more flexible and extensible option. This ensures data schema
3856 changes can be implemented without requiring upgrades to the
3857 storage contract
3858 
3859 The first deployed storage contract would create this eternal storage.
3860 Favour use of keccak256 key over sha3 as future version of solidity
3861 > 0.5.0 will be deprecated.
3862 
3863 -----------------------------------------------------------------
3864 */
3865 
3866 
3867 /**
3868  * @notice  This contract is based on the code available from this blog
3869  * https://blog.colony.io/writing-upgradeable-contracts-in-solidity-6743f0eecc88/
3870  * Implements support for storing a keccak256 key and value pairs. It is the more flexible
3871  * and extensible option. This ensures data schema changes can be implemented without
3872  * requiring upgrades to the storage contract.
3873  */
3874 contract EternalStorage is State {
3875 
3876     constructor(address _owner, address _associatedContract)
3877         State(_owner, _associatedContract)
3878         public
3879     {
3880     }
3881 
3882     /* ========== DATA TYPES ========== */
3883     mapping(bytes32 => uint) UIntStorage;
3884     mapping(bytes32 => string) StringStorage;
3885     mapping(bytes32 => address) AddressStorage;
3886     mapping(bytes32 => bytes) BytesStorage;
3887     mapping(bytes32 => bytes32) Bytes32Storage;
3888     mapping(bytes32 => bool) BooleanStorage;
3889     mapping(bytes32 => int) IntStorage;
3890 
3891     // UIntStorage;
3892     function getUIntValue(bytes32 record) external view returns (uint){
3893         return UIntStorage[record];
3894     }
3895 
3896     function setUIntValue(bytes32 record, uint value) external
3897         onlyAssociatedContract
3898     {
3899         UIntStorage[record] = value;
3900     }
3901 
3902     function deleteUIntValue(bytes32 record) external
3903         onlyAssociatedContract
3904     {
3905         delete UIntStorage[record];
3906     }
3907 
3908     // StringStorage
3909     function getStringValue(bytes32 record) external view returns (string memory){
3910         return StringStorage[record];
3911     }
3912 
3913     function setStringValue(bytes32 record, string value) external
3914         onlyAssociatedContract
3915     {
3916         StringStorage[record] = value;
3917     }
3918 
3919     function deleteStringValue(bytes32 record) external
3920         onlyAssociatedContract
3921     {
3922         delete StringStorage[record];
3923     }
3924 
3925     // AddressStorage
3926     function getAddressValue(bytes32 record) external view returns (address){
3927         return AddressStorage[record];
3928     }
3929 
3930     function setAddressValue(bytes32 record, address value) external
3931         onlyAssociatedContract
3932     {
3933         AddressStorage[record] = value;
3934     }
3935 
3936     function deleteAddressValue(bytes32 record) external
3937         onlyAssociatedContract
3938     {
3939         delete AddressStorage[record];
3940     }
3941 
3942 
3943     // BytesStorage
3944     function getBytesValue(bytes32 record) external view returns
3945     (bytes memory){
3946         return BytesStorage[record];
3947     }
3948 
3949     function setBytesValue(bytes32 record, bytes value) external
3950         onlyAssociatedContract
3951     {
3952         BytesStorage[record] = value;
3953     }
3954 
3955     function deleteBytesValue(bytes32 record) external
3956         onlyAssociatedContract
3957     {
3958         delete BytesStorage[record];
3959     }
3960 
3961     // Bytes32Storage
3962     function getBytes32Value(bytes32 record) external view returns (bytes32)
3963     {
3964         return Bytes32Storage[record];
3965     }
3966 
3967     function setBytes32Value(bytes32 record, bytes32 value) external
3968         onlyAssociatedContract
3969     {
3970         Bytes32Storage[record] = value;
3971     }
3972 
3973     function deleteBytes32Value(bytes32 record) external
3974         onlyAssociatedContract
3975     {
3976         delete Bytes32Storage[record];
3977     }
3978 
3979     // BooleanStorage
3980     function getBooleanValue(bytes32 record) external view returns (bool)
3981     {
3982         return BooleanStorage[record];
3983     }
3984 
3985     function setBooleanValue(bytes32 record, bool value) external
3986         onlyAssociatedContract
3987     {
3988         BooleanStorage[record] = value;
3989     }
3990 
3991     function deleteBooleanValue(bytes32 record) external
3992         onlyAssociatedContract
3993     {
3994         delete BooleanStorage[record];
3995     }
3996 
3997     // IntStorage
3998     function getIntValue(bytes32 record) external view returns (int){
3999         return IntStorage[record];
4000     }
4001 
4002     function setIntValue(bytes32 record, int value) external
4003         onlyAssociatedContract
4004     {
4005         IntStorage[record] = value;
4006     }
4007 
4008     function deleteIntValue(bytes32 record) external
4009         onlyAssociatedContract
4010     {
4011         delete IntStorage[record];
4012     }
4013 }
4014 
4015 /*
4016 -----------------------------------------------------------------
4017 FILE INFORMATION
4018 -----------------------------------------------------------------
4019 
4020 file:       FeePoolEternalStorage.sol
4021 version:    1.0
4022 author:     Clinton Ennis
4023             Jackson Chan
4024 date:       2019-04-05
4025 
4026 -----------------------------------------------------------------
4027 MODULE DESCRIPTION
4028 -----------------------------------------------------------------
4029 
4030 The FeePoolEternalStorage is for any state the FeePool contract
4031 needs to persist between upgrades to the FeePool logic.
4032 
4033 Please see EternalStorage.sol
4034 
4035 -----------------------------------------------------------------
4036 */
4037 
4038 
4039 contract FeePoolEternalStorage is EternalStorage, LimitedSetup {
4040 
4041     bytes32 constant LAST_FEE_WITHDRAWAL = "last_fee_withdrawal";
4042 
4043     /**
4044      * @dev Constructor.
4045      * @param _owner The owner of this contract.
4046      */
4047     constructor(address _owner, address _feePool)
4048         EternalStorage(_owner, _feePool)
4049         LimitedSetup(6 weeks)
4050         public
4051     {
4052     }
4053 
4054     /**
4055      * @notice Import data from FeePool.lastFeeWithdrawal
4056      * @dev Only callable by the contract owner, and only for 6 weeks after deployment.
4057      * @param accounts Array of addresses that have claimed
4058      * @param feePeriodIDs Array feePeriodIDs with the accounts last claim
4059      */
4060     function importFeeWithdrawalData(address[] accounts, uint[] feePeriodIDs)
4061         external
4062         onlyOwner
4063         onlyDuringSetup
4064     {
4065         require(accounts.length == feePeriodIDs.length, "Length mismatch");
4066 
4067         for (uint8 i = 0; i < accounts.length; i++) {
4068             this.setUIntValue(keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, accounts[i])), feePeriodIDs[i]);
4069         }
4070     }
4071 }
4072 
4073 
4074 /*
4075 -----------------------------------------------------------------
4076 FILE INFORMATION
4077 -----------------------------------------------------------------
4078 
4079 file:       DelegateApprovals.sol
4080 version:    1.0
4081 author:     Jackson Chan
4082 checked:    Clinton Ennis
4083 date:       2019-05-01
4084 
4085 -----------------------------------------------------------------
4086 MODULE DESCRIPTION
4087 -----------------------------------------------------------------
4088 
4089 The approval state contract is designed to allow a wallet to
4090 authorise another address to perform actions, on a contract,
4091 on their behalf. This could be an automated service
4092 that would help a wallet claim fees / rewards on their behalf.
4093 
4094 The concept is similar to the ERC20 interface where a wallet can
4095 approve an authorised party to spend on the authorising party's
4096 behalf in the allowance interface.
4097 
4098 Withdrawing approval sets the delegate as false instead of
4099 removing from the approvals list for auditability.
4100 
4101 This contract inherits state for upgradeability / associated
4102 contract.
4103 
4104 -----------------------------------------------------------------
4105 */
4106 
4107 
4108 contract DelegateApprovals is State {
4109 
4110     // Approvals - [authoriser][delegate]
4111     // Each authoriser can have multiple delegates
4112     mapping(address => mapping(address => bool)) public approval;
4113 
4114     /**
4115      * @dev Constructor
4116      * @param _owner The address which controls this contract.
4117      * @param _associatedContract The contract whose approval state this composes.
4118      */
4119     constructor(address _owner, address _associatedContract)
4120         State(_owner, _associatedContract)
4121         public
4122     {}
4123 
4124     function setApproval(address authoriser, address delegate)
4125         external
4126         onlyAssociatedContract
4127     {
4128         approval[authoriser][delegate] = true;
4129         emit Approval(authoriser, delegate);
4130     }
4131 
4132     function withdrawApproval(address authoriser, address delegate)
4133         external
4134         onlyAssociatedContract
4135     {
4136         delete approval[authoriser][delegate];
4137         emit WithdrawApproval(authoriser, delegate);
4138     }
4139 
4140      /* ========== EVENTS ========== */
4141 
4142     event Approval(address indexed authoriser, address delegate);
4143     event WithdrawApproval(address indexed authoriser, address delegate);
4144 }
4145 
4146 
4147 /*
4148 -----------------------------------------------------------------
4149 FILE INFORMATION
4150 -----------------------------------------------------------------
4151 
4152 file:       FeePool.sol
4153 version:    1.0
4154 author:     Kevin Brown
4155 date:       2018-10-15
4156 
4157 -----------------------------------------------------------------
4158 MODULE DESCRIPTION
4159 -----------------------------------------------------------------
4160 
4161 The FeePool is a place for users to interact with the fees that
4162 have been generated from the Synthetix system if they've helped
4163 to create the economy.
4164 
4165 Users stake Synthetix to create Synths. As Synth users transact,
4166 a small fee is deducted from exchange transactions, which collects
4167 in the fee pool. Fees are immediately converted to XDRs, a type
4168 of reserve currency similar to SDRs used by the IMF:
4169 https://www.imf.org/en/About/Factsheets/Sheets/2016/08/01/14/51/Special-Drawing-Right-SDR
4170 
4171 Users are entitled to withdraw fees from periods that they participated
4172 in fully, e.g. they have to stake before the period starts. They
4173 can withdraw fees for the last 6 periods as a single lump sum.
4174 Currently fee periods are 7 days long, meaning it's assumed
4175 users will withdraw their fees approximately once a month. Fees
4176 which are not withdrawn are redistributed to the whole pool,
4177 enabling these non-claimed fees to go back to the rest of the commmunity.
4178 
4179 Fees can be withdrawn in any synth currency.
4180 
4181 -----------------------------------------------------------------
4182 */
4183 
4184 
4185 contract FeePool is Proxyable, SelfDestructible, LimitedSetup {
4186 
4187     using SafeMath for uint;
4188     using SafeDecimalMath for uint;
4189 
4190     Synthetix public synthetix;
4191     ISynthetixState public synthetixState;
4192     ISynthetixEscrow public rewardEscrow;
4193     FeePoolEternalStorage public feePoolEternalStorage;
4194 
4195     // A percentage fee charged on each transfer.
4196     uint public transferFeeRate;
4197 
4198     // Transfer fee may not exceed 10%.
4199     uint constant public MAX_TRANSFER_FEE_RATE = SafeDecimalMath.unit() / 10;
4200 
4201     // A percentage fee charged on each exchange between currencies.
4202     uint public exchangeFeeRate;
4203 
4204     // Exchange fee may not exceed 10%.
4205     uint constant public MAX_EXCHANGE_FEE_RATE = SafeDecimalMath.unit() / 10;
4206 
4207     // The address with the authority to distribute fees.
4208     address public feeAuthority;
4209 
4210     // The address to the FeePoolState Contract.
4211     FeePoolState public feePoolState;
4212 
4213     // The address to the DelegateApproval contract.
4214     DelegateApprovals public delegates;
4215 
4216     // Where fees are pooled in XDRs.
4217     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
4218 
4219     // This struct represents the issuance activity that's happened in a fee period.
4220     struct FeePeriod {
4221         uint feePeriodId;
4222         uint startingDebtIndex;
4223         uint startTime;
4224         uint feesToDistribute;
4225         uint feesClaimed;
4226         uint rewardsToDistribute;
4227         uint rewardsClaimed;
4228     }
4229 
4230     // The last 6 fee periods are all that you can claim from.
4231     // These are stored and managed from [0], such that [0] is always
4232     // the most recent fee period, and [5] is always the oldest fee
4233     // period that users can claim for.
4234     uint8 constant public FEE_PERIOD_LENGTH = 6;
4235 
4236     FeePeriod[FEE_PERIOD_LENGTH] public recentFeePeriods;
4237 
4238     // How long a fee period lasts at a minimum. It is required for the
4239     // fee authority to roll over the periods, so they are not guaranteed
4240     // to roll over at exactly this duration, but the contract enforces
4241     // that they cannot roll over any quicker than this duration.
4242     uint public feePeriodDuration = 1 weeks;
4243     // The fee period must be between 1 day and 60 days.
4244     uint public constant MIN_FEE_PERIOD_DURATION = 1 days;
4245     uint public constant MAX_FEE_PERIOD_DURATION = 60 days;
4246 
4247     // Users receive penalties if their collateralisation ratio drifts out of our desired brackets
4248     // We precompute the brackets and penalties to save gas.
4249     uint constant TWENTY_PERCENT = (20 * SafeDecimalMath.unit()) / 100;
4250     uint constant TWENTY_TWO_PERCENT = (22 * SafeDecimalMath.unit()) / 100;
4251     uint constant TWENTY_FIVE_PERCENT = (25 * SafeDecimalMath.unit()) / 100;
4252     uint constant THIRTY_PERCENT = (30 * SafeDecimalMath.unit()) / 100;
4253     uint constant FOURTY_PERCENT = (40 * SafeDecimalMath.unit()) / 100;
4254     uint constant FIFTY_PERCENT = (50 * SafeDecimalMath.unit()) / 100;
4255     uint constant SEVENTY_FIVE_PERCENT = (75 * SafeDecimalMath.unit()) / 100;
4256     uint constant NINETY_PERCENT = (90 * SafeDecimalMath.unit()) / 100;
4257     uint constant ONE_HUNDRED_PERCENT = (100 * SafeDecimalMath.unit()) / 100;
4258 
4259     /* ========== ETERNAL STORAGE CONSTANTS ========== */
4260 
4261     bytes32 constant LAST_FEE_WITHDRAWAL = "last_fee_withdrawal";
4262 
4263     constructor(
4264         address _proxy,
4265         address _owner,
4266         Synthetix _synthetix,
4267         FeePoolState _feePoolState,
4268         FeePoolEternalStorage _feePoolEternalStorage,
4269         ISynthetixState _synthetixState,
4270         ISynthetixEscrow _rewardEscrow,
4271         address _feeAuthority,
4272         uint _transferFeeRate,
4273         uint _exchangeFeeRate)
4274         SelfDestructible(_owner)
4275         Proxyable(_proxy, _owner)
4276         LimitedSetup(3 weeks)
4277         public
4278     {
4279         // Constructed fee rates should respect the maximum fee rates.
4280         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
4281         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Constructed exchange fee rate should respect the maximum fee rate");
4282 
4283         synthetix = _synthetix;
4284         feePoolState = _feePoolState;
4285         feePoolEternalStorage = _feePoolEternalStorage;
4286         rewardEscrow = _rewardEscrow;
4287         synthetixState = _synthetixState;
4288         feeAuthority = _feeAuthority;
4289         transferFeeRate = _transferFeeRate;
4290         exchangeFeeRate = _exchangeFeeRate;
4291 
4292         // Set our initial fee period
4293         recentFeePeriods[0].feePeriodId = 1;
4294         recentFeePeriods[0].startTime = now;
4295     }
4296 
4297     /**
4298      * @notice Logs an accounts issuance data per fee period
4299      * @param account Message.Senders account address
4300      * @param debtRatio Debt percentage this account has locked after minting or burning their synth
4301      * @param debtEntryIndex The index in the global debt ledger. synthetix.synthetixState().issuanceData(account)
4302      * @dev onlySynthetix to call me on synthetix.issue() & synthetix.burn() calls to store the locked SNX
4303      * per fee period so we know to allocate the correct proportions of fees and rewards per period
4304      */
4305     function appendAccountIssuanceRecord(address account, uint debtRatio, uint debtEntryIndex)
4306         external
4307         onlySynthetix
4308     {
4309         feePoolState.appendAccountIssuanceRecord(account, debtRatio, debtEntryIndex, recentFeePeriods[0].startingDebtIndex);
4310 
4311         emitIssuanceDebtRatioEntry(account, debtRatio, debtEntryIndex, recentFeePeriods[0].startingDebtIndex);
4312     }
4313 
4314     /**
4315      * @notice Set the exchange fee, anywhere within the range 0-10%.
4316      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
4317      */
4318     function setExchangeFeeRate(uint _exchangeFeeRate)
4319         external
4320         optionalProxy_onlyOwner
4321     {
4322         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Exchange fee rate must be below MAX_EXCHANGE_FEE_RATE");
4323 
4324         exchangeFeeRate = _exchangeFeeRate;
4325 
4326         emitExchangeFeeUpdated(_exchangeFeeRate);
4327     }
4328 
4329     /**
4330      * @notice Set the transfer fee, anywhere within the range 0-10%.
4331      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
4332      */
4333     function setTransferFeeRate(uint _transferFeeRate)
4334         external
4335         optionalProxy_onlyOwner
4336     {
4337         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
4338 
4339         transferFeeRate = _transferFeeRate;
4340 
4341         emitTransferFeeUpdated(_transferFeeRate);
4342     }
4343 
4344     /**
4345      * @notice Set the address of the user/contract responsible for collecting or
4346      * distributing fees.
4347      */
4348     function setFeeAuthority(address _feeAuthority)
4349         external
4350         optionalProxy_onlyOwner
4351     {
4352         feeAuthority = _feeAuthority;
4353 
4354         emitFeeAuthorityUpdated(_feeAuthority);
4355     }
4356 
4357     /**
4358      * @notice Set the address of the contract for feePool state
4359      */
4360     function setFeePoolState(FeePoolState _feePoolState)
4361         external
4362         optionalProxy_onlyOwner
4363     {
4364         feePoolState = _feePoolState;
4365 
4366         emitFeePoolStateUpdated(_feePoolState);
4367     }
4368 
4369     /**
4370      * @notice Set the address of the contract for delegate approvals
4371      */
4372     function setDelegateApprovals(DelegateApprovals _delegates)
4373         external
4374         optionalProxy_onlyOwner
4375     {
4376         delegates = _delegates;
4377 
4378         emitDelegateApprovalsUpdated(_delegates);
4379     }
4380 
4381     /**
4382      * @notice Set the fee period duration
4383      */
4384     function setFeePeriodDuration(uint _feePeriodDuration)
4385         external
4386         optionalProxy_onlyOwner
4387     {
4388         require(_feePeriodDuration >= MIN_FEE_PERIOD_DURATION, "New fee period cannot be less than minimum fee period duration");
4389         require(_feePeriodDuration <= MAX_FEE_PERIOD_DURATION, "New fee period cannot be greater than maximum fee period duration");
4390 
4391         feePeriodDuration = _feePeriodDuration;
4392 
4393         emitFeePeriodDurationUpdated(_feePeriodDuration);
4394     }
4395 
4396     /**
4397      * @notice Set the synthetix contract
4398      */
4399     function setSynthetix(Synthetix _synthetix)
4400         external
4401         optionalProxy_onlyOwner
4402     {
4403         require(address(_synthetix) != address(0), "New Synthetix must be non-zero");
4404 
4405         synthetix = _synthetix;
4406 
4407         emitSynthetixUpdated(_synthetix);
4408     }
4409 
4410     /**
4411      * @notice The Synthetix contract informs us when fees are paid.
4412      */
4413     function feePaid(bytes4 currencyKey, uint amount)
4414         external
4415         onlySynthetix
4416     {
4417         uint xdrAmount;
4418 
4419         if (currencyKey != "XDR") {
4420             xdrAmount = synthetix.effectiveValue(currencyKey, amount, "XDR");
4421         } else {
4422             xdrAmount = amount;
4423         }
4424 
4425         // Keep track of in XDRs in our fee pool.
4426         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.add(xdrAmount);
4427     }
4428 
4429     /**
4430      * @notice The Synthetix contract informs us when SNX Rewards are minted to RewardEscrow to be claimed.
4431      */
4432     function rewardsMinted(uint amount)
4433         external
4434         onlySynthetix
4435     {
4436         // Add the newly minted SNX rewards on top of the rolling unclaimed amount
4437         recentFeePeriods[0].rewardsToDistribute = recentFeePeriods[0].rewardsToDistribute.add(amount);
4438     }
4439 
4440     /**
4441      * @notice Close the current fee period and start a new one. Only callable by the fee authority.
4442      */
4443     function closeCurrentFeePeriod()
4444         external
4445         optionalProxy_onlyFeeAuthority
4446     {
4447         require(recentFeePeriods[0].startTime <= (now - feePeriodDuration), "It is too early to close the current fee period");
4448 
4449         FeePeriod memory secondLastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 2];
4450         FeePeriod memory lastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 1];
4451 
4452         // Any unclaimed fees from the last period in the array roll back one period.
4453         // Because of the subtraction here, they're effectively proportionally redistributed to those who
4454         // have already claimed from the old period, available in the new period.
4455         // The subtraction is important so we don't create a ticking time bomb of an ever growing
4456         // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
4457         recentFeePeriods[FEE_PERIOD_LENGTH - 2].feesToDistribute = lastFeePeriod.feesToDistribute
4458             .sub(lastFeePeriod.feesClaimed)
4459             .add(secondLastFeePeriod.feesToDistribute);
4460         recentFeePeriods[FEE_PERIOD_LENGTH - 2].rewardsToDistribute = lastFeePeriod.rewardsToDistribute
4461             .sub(lastFeePeriod.rewardsClaimed)
4462             .add(secondLastFeePeriod.rewardsToDistribute);
4463 
4464         // Shift the previous fee periods across to make room for the new one.
4465         // Condition checks for overflow when uint subtracts one from zero
4466         // Could be written with int instead of uint, but then we have to convert everywhere
4467         // so it felt better from a gas perspective to just change the condition to check
4468         // for overflow after subtracting one from zero.
4469         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
4470             uint next = i + 1;
4471             recentFeePeriods[next].feePeriodId = recentFeePeriods[i].feePeriodId;
4472             recentFeePeriods[next].startingDebtIndex = recentFeePeriods[i].startingDebtIndex;
4473             recentFeePeriods[next].startTime = recentFeePeriods[i].startTime;
4474             recentFeePeriods[next].feesToDistribute = recentFeePeriods[i].feesToDistribute;
4475             recentFeePeriods[next].feesClaimed = recentFeePeriods[i].feesClaimed;
4476             recentFeePeriods[next].rewardsToDistribute = recentFeePeriods[i].rewardsToDistribute;
4477             recentFeePeriods[next].rewardsClaimed = recentFeePeriods[i].rewardsClaimed;
4478         }
4479 
4480         // Clear the first element of the array to make sure we don't have any stale values.
4481         delete recentFeePeriods[0];
4482 
4483         // Open up the new fee period. Take a snapshot of the total value of the system.
4484         // Increment periodId from the recent closed period feePeriodId
4485         recentFeePeriods[0].feePeriodId = recentFeePeriods[1].feePeriodId.add(1);
4486         recentFeePeriods[0].startingDebtIndex = synthetixState.debtLedgerLength();
4487         recentFeePeriods[0].startTime = now;
4488 
4489         emitFeePeriodClosed(recentFeePeriods[1].feePeriodId);
4490     }
4491 
4492     /**
4493     * @notice Claim fees for last period when available or not already withdrawn.
4494     * @param currencyKey Synth currency you wish to receive the fees in.
4495     */
4496     function claimFees(bytes4 currencyKey)
4497         external
4498         optionalProxy
4499         returns (bool)
4500     {
4501         return _claimFees(messageSender, currencyKey);
4502     }
4503 
4504     function claimOnBehalf(address claimingForAddress, bytes4 currencyKey)
4505         external
4506         optionalProxy
4507         returns (bool)
4508     {
4509         require(delegates.approval(claimingForAddress, messageSender), "Not approved to claim on behalf this address");
4510 
4511         return _claimFees(claimingForAddress, currencyKey);
4512     }
4513 
4514     function _claimFees(address claimingAddress, bytes4 currencyKey)
4515         internal
4516         returns (bool)
4517     {
4518         uint availableFees;
4519         uint availableRewards;
4520         (availableFees, availableRewards) = feesAvailable(claimingAddress, "XDR");
4521 
4522         require(availableFees > 0 || availableRewards > 0, "No fees or rewards available for period, or fees already claimed");
4523 
4524         _setLastFeeWithdrawal(claimingAddress, recentFeePeriods[1].feePeriodId);
4525 
4526         if (availableFees > 0) {
4527             // Record the fee payment in our recentFeePeriods
4528             uint feesPaid = _recordFeePayment(availableFees);
4529 
4530             // Send them their fees
4531             _payFees(claimingAddress, feesPaid, currencyKey);
4532 
4533             emitFeesClaimed(claimingAddress, feesPaid);
4534         }
4535 
4536         if (availableRewards > 0) {
4537             // Record the reward payment in our recentFeePeriods
4538             uint rewardPaid = _recordRewardPayment(availableRewards);
4539 
4540             // Send them their rewards
4541             _payRewards(claimingAddress, rewardPaid);
4542 
4543             emitRewardsClaimed(claimingAddress, rewardPaid);
4544         }
4545 
4546         return true;
4547     }
4548 
4549     function importFeePeriod(
4550         uint feePeriodIndex, uint feePeriodId, uint startingDebtIndex, uint startTime,
4551         uint feesToDistribute, uint feesClaimed, uint rewardsToDistribute, uint rewardsClaimed)
4552         public
4553         optionalProxy_onlyOwner
4554         onlyDuringSetup
4555     {
4556         recentFeePeriods[feePeriodIndex].feePeriodId = feePeriodId;
4557         recentFeePeriods[feePeriodIndex].startingDebtIndex = startingDebtIndex;
4558         recentFeePeriods[feePeriodIndex].startTime = startTime;
4559         recentFeePeriods[feePeriodIndex].feesToDistribute = feesToDistribute;
4560         recentFeePeriods[feePeriodIndex].feesClaimed = feesClaimed;
4561         recentFeePeriods[feePeriodIndex].rewardsToDistribute = rewardsToDistribute;
4562         recentFeePeriods[feePeriodIndex].rewardsClaimed = rewardsClaimed;
4563     }
4564 
4565     function approveClaimOnBehalf(address account)
4566         public
4567         optionalProxy
4568     {
4569         require(delegates != address(0), "Delegates Approval destination missing");
4570         require(account != address(0), "Can't delegate to address(0)");
4571         delegates.setApproval(messageSender, account);
4572     }
4573 
4574     function removeClaimOnBehalf(address account)
4575         public
4576         optionalProxy
4577     {
4578         require(delegates != address(0), "Delegates Approval destination missing");
4579         delegates.withdrawApproval(messageSender, account);
4580     }
4581 
4582     /**
4583      * @notice Record the fee payment in our recentFeePeriods.
4584      * @param xdrAmount The amount of fees priced in XDRs.
4585      */
4586     function _recordFeePayment(uint xdrAmount)
4587         internal
4588         returns (uint)
4589     {
4590         // Don't assign to the parameter
4591         uint remainingToAllocate = xdrAmount;
4592 
4593         uint feesPaid;
4594         // Start at the oldest period and record the amount, moving to newer periods
4595         // until we've exhausted the amount.
4596         // The condition checks for overflow because we're going to 0 with an unsigned int.
4597         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
4598             uint delta = recentFeePeriods[i].feesToDistribute.sub(recentFeePeriods[i].feesClaimed);
4599 
4600             if (delta > 0) {
4601                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
4602                 uint amountInPeriod = delta < remainingToAllocate ? delta : remainingToAllocate;
4603 
4604                 recentFeePeriods[i].feesClaimed = recentFeePeriods[i].feesClaimed.add(amountInPeriod);
4605                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
4606                 feesPaid = feesPaid.add(amountInPeriod);
4607 
4608                 // No need to continue iterating if we've recorded the whole amount;
4609                 if (remainingToAllocate == 0) return feesPaid;
4610 
4611                 // We've exhausted feePeriods to distribute and no fees remain in last period
4612                 // User last to claim would in this scenario have their remainder slashed
4613                 if (i == 0 && remainingToAllocate > 0) {
4614                     remainingToAllocate = 0;
4615                 }
4616             }
4617         }
4618 
4619         return feesPaid;
4620     }
4621 
4622     /**
4623      * @notice Record the reward payment in our recentFeePeriods.
4624      * @param snxAmount The amount of SNX tokens.
4625      */
4626     function _recordRewardPayment(uint snxAmount)
4627         internal
4628         returns (uint)
4629     {
4630         // Don't assign to the parameter
4631         uint remainingToAllocate = snxAmount;
4632 
4633         uint rewardPaid;
4634 
4635         // Start at the oldest period and record the amount, moving to newer periods
4636         // until we've exhausted the amount.
4637         // The condition checks for overflow because we're going to 0 with an unsigned int.
4638         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
4639             uint toDistribute = recentFeePeriods[i].rewardsToDistribute.sub(recentFeePeriods[i].rewardsClaimed);
4640 
4641             if (toDistribute > 0) {
4642                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
4643                 uint amountInPeriod = toDistribute < remainingToAllocate ? toDistribute : remainingToAllocate;
4644 
4645                 recentFeePeriods[i].rewardsClaimed = recentFeePeriods[i].rewardsClaimed.add(amountInPeriod);
4646                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
4647                 rewardPaid = rewardPaid.add(amountInPeriod);
4648 
4649                 // No need to continue iterating if we've recorded the whole amount;
4650                 if (remainingToAllocate == 0) return rewardPaid;
4651 
4652                 // We've exhausted feePeriods to distribute and no rewards remain in last period
4653                 // User last to claim would in this scenario have their remainder slashed
4654                 // due to rounding up of PreciseDecimal
4655                 if (i == 0 && remainingToAllocate > 0) {
4656                     remainingToAllocate = 0;
4657                 }
4658             }
4659         }
4660         return rewardPaid;
4661     }
4662 
4663     /**
4664     * @notice Send the fees to claiming address.
4665     * @param account The address to send the fees to.
4666     * @param xdrAmount The amount of fees priced in XDRs.
4667     * @param destinationCurrencyKey The synth currency the user wishes to receive their fees in (convert to this currency).
4668     */
4669     function _payFees(address account, uint xdrAmount, bytes4 destinationCurrencyKey)
4670         internal
4671         notFeeAddress(account)
4672     {
4673         require(account != address(0), "Account can't be 0");
4674         require(account != address(this), "Can't send fees to fee pool");
4675         require(account != address(proxy), "Can't send fees to proxy");
4676         require(account != address(synthetix), "Can't send fees to synthetix");
4677 
4678         Synth xdrSynth = synthetix.synths("XDR");
4679         Synth destinationSynth = synthetix.synths(destinationCurrencyKey);
4680 
4681         // Note: We don't need to check the fee pool balance as the burn() below will do a safe subtraction which requires
4682         // the subtraction to not overflow, which would happen if the balance is not sufficient.
4683 
4684         // Burn the source amount
4685         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
4686 
4687         // How much should they get in the destination currency?
4688         uint destinationAmount = synthetix.effectiveValue("XDR", xdrAmount, destinationCurrencyKey);
4689 
4690         // There's no fee on withdrawing fees, as that'd be way too meta.
4691 
4692         // Mint their new synths
4693         destinationSynth.issue(account, destinationAmount);
4694 
4695         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
4696 
4697         // Call the ERC223 transfer callback if needed
4698         destinationSynth.triggerTokenFallbackIfNeeded(FEE_ADDRESS, account, destinationAmount);
4699     }
4700 
4701     /**
4702     * @notice Send the rewards to claiming address - will be locked in rewardEscrow.
4703     * @param account The address to send the fees to.
4704     * @param snxAmount The amount of SNX.
4705     */
4706     function _payRewards(address account, uint snxAmount)
4707         internal
4708         notFeeAddress(account)
4709     {
4710         require(account != address(0), "Account can't be 0");
4711         require(account != address(this), "Can't send rewards to fee pool");
4712         require(account != address(proxy), "Can't send rewards to proxy");
4713         require(account != address(synthetix), "Can't send rewards to synthetix");
4714 
4715         // Record vesting entry for claiming address and amount
4716         // SNX already minted to rewardEscrow balance
4717         rewardEscrow.appendVestingEntry(account, snxAmount);
4718     }
4719 
4720     /**
4721      * @notice Calculate the Fee charged on top of a value being sent
4722      * @return Return the fee charged
4723      */
4724     function transferFeeIncurred(uint value)
4725         public
4726         view
4727         returns (uint)
4728     {
4729         return value.multiplyDecimal(transferFeeRate);
4730 
4731         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
4732         // This is on the basis that transfers less than this value will result in a nil fee.
4733         // Probably too insignificant to worry about, but the following code will achieve it.
4734         //      if (fee == 0 && transferFeeRate != 0) {
4735         //          return _value;
4736         //      }
4737         //      return fee;
4738     }
4739 
4740     /**
4741      * @notice The value that you would need to send so that the recipient receives
4742      * a specified value.
4743      * @param value The value you want the recipient to receive
4744      */
4745     function transferredAmountToReceive(uint value)
4746         external
4747         view
4748         returns (uint)
4749     {
4750         return value.add(transferFeeIncurred(value));
4751     }
4752 
4753     /**
4754      * @notice The amount the recipient will receive if you send a certain number of tokens.
4755      * @param value The amount of tokens you intend to send.
4756      */
4757     function amountReceivedFromTransfer(uint value)
4758         external
4759         view
4760         returns (uint)
4761     {
4762         return value.divideDecimal(transferFeeRate.add(SafeDecimalMath.unit()));
4763     }
4764 
4765     /**
4766      * @notice Calculate the fee charged on top of a value being sent via an exchange
4767      * @return Return the fee charged
4768      */
4769     function exchangeFeeIncurred(uint value)
4770         public
4771         view
4772         returns (uint)
4773     {
4774         return value.multiplyDecimal(exchangeFeeRate);
4775 
4776         // Exchanges less than the reciprocal of exchangeFeeRate should be completely eaten up by fees.
4777         // This is on the basis that exchanges less than this value will result in a nil fee.
4778         // Probably too insignificant to worry about, but the following code will achieve it.
4779         //      if (fee == 0 && exchangeFeeRate != 0) {
4780         //          return _value;
4781         //      }
4782         //      return fee;
4783     }
4784 
4785     /**
4786      * @notice The value that you would need to get after currency exchange so that the recipient receives
4787      * a specified value.
4788      * @param value The value you want the recipient to receive
4789      */
4790     function exchangedAmountToReceive(uint value)
4791         external
4792         view
4793         returns (uint)
4794     {
4795         return value.add(exchangeFeeIncurred(value));
4796     }
4797 
4798     /**
4799      * @notice The amount the recipient will receive if you are performing an exchange and the
4800      * destination currency will be worth a certain number of tokens.
4801      * @param value The amount of destination currency tokens they received after the exchange.
4802      */
4803     function amountReceivedFromExchange(uint value)
4804         external
4805         view
4806         returns (uint)
4807     {
4808         return value.multiplyDecimal(SafeDecimalMath.unit().sub(exchangeFeeRate));
4809     }
4810 
4811     /**
4812      * @notice The total fees available in the system to be withdrawn, priced in currencyKey currency
4813      * @param currencyKey The currency you want to price the fees in
4814      */
4815     function totalFeesAvailable(bytes4 currencyKey)
4816         external
4817         view
4818         returns (uint)
4819     {
4820         uint totalFees = 0;
4821 
4822         // Fees in fee period [0] are not yet available for withdrawal
4823         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
4824             totalFees = totalFees.add(recentFeePeriods[i].feesToDistribute);
4825             totalFees = totalFees.sub(recentFeePeriods[i].feesClaimed);
4826         }
4827 
4828         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
4829     }
4830 
4831     /**
4832      * @notice The total SNX rewards available in the system to be withdrawn
4833      */
4834     function totalRewardsAvailable()
4835         external
4836         view
4837         returns (uint)
4838     {
4839         uint totalRewards = 0;
4840 
4841         // Rewards in fee period [0] are not yet available for withdrawal
4842         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
4843             totalRewards = totalRewards.add(recentFeePeriods[i].rewardsToDistribute);
4844             totalRewards = totalRewards.sub(recentFeePeriods[i].rewardsClaimed);
4845         }
4846 
4847         return totalRewards;
4848     }
4849 
4850     /**
4851      * @notice The fees available to be withdrawn by a specific account, priced in currencyKey currency
4852      * @dev Returns two amounts, one for fees and one for SNX rewards
4853      * @param currencyKey The currency you want to price the fees in
4854      */
4855     function feesAvailable(address account, bytes4 currencyKey)
4856         public
4857         view
4858         returns (uint, uint)
4859     {
4860         // Add up the fees
4861         uint[2][FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);
4862 
4863         uint totalFees = 0;
4864         uint totalRewards = 0;
4865 
4866         // Fees & Rewards in fee period [0] are not yet available for withdrawal
4867         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
4868             totalFees = totalFees.add(userFees[i][0]);
4869             totalRewards = totalRewards.add(userFees[i][1]);
4870         }
4871 
4872         // And convert totalFees to their desired currency
4873         // Return totalRewards as is in SNX amount
4874         return (
4875             synthetix.effectiveValue("XDR", totalFees, currencyKey),
4876             totalRewards
4877         );
4878     }
4879 
4880     /**
4881      * @notice The penalty a particular address would incur if its fees were withdrawn right now
4882      * @param account The address you want to query the penalty for
4883      */
4884     function currentPenalty(address account)
4885         public
4886         view
4887         returns (uint)
4888     {
4889         uint ratio = synthetix.collateralisationRatio(account);
4890 
4891         // Users receive a different amount of fees depending on how their collateralisation ratio looks right now.
4892         //  0% < 20% (∞ - 500%):    Fee is calculated based on percentage of economy issued.
4893         // 20% - 22% (500% - 454%):  0% reduction in fees
4894         // 22% - 30% (454% - 333%): 25% reduction in fees
4895         // 30% - 40% (333% - 250%): 50% reduction in fees
4896         // 40% - 50% (250% - 200%): 75% reduction in fees
4897         //     > 50% (200% - 100%): 90% reduction in fees
4898         //     > 100%(100% -   0%):100% reduction in fees
4899         if (ratio <= TWENTY_PERCENT) {
4900             return 0;
4901         } else if (ratio > TWENTY_PERCENT && ratio <= TWENTY_TWO_PERCENT) {
4902             return 0;
4903         } else if (ratio > TWENTY_TWO_PERCENT && ratio <= THIRTY_PERCENT) {
4904             return TWENTY_FIVE_PERCENT;
4905         } else if (ratio > THIRTY_PERCENT && ratio <= FOURTY_PERCENT) {
4906             return FIFTY_PERCENT;
4907         } else if (ratio > FOURTY_PERCENT && ratio <= FIFTY_PERCENT) {
4908             return SEVENTY_FIVE_PERCENT;
4909         } else if (ratio > FIFTY_PERCENT && ratio <= ONE_HUNDRED_PERCENT) {
4910             return NINETY_PERCENT;
4911         }
4912         return ONE_HUNDRED_PERCENT;
4913     }
4914 
4915     /**
4916      * @notice Calculates fees by period for an account, priced in XDRs
4917      * @param account The address you want to query the fees by penalty for
4918      */
4919     function feesByPeriod(address account)
4920         public
4921         view
4922         returns (uint[2][FEE_PERIOD_LENGTH] memory results)
4923     {
4924         // What's the user's debt entry index and the debt they owe to the system at current feePeriod
4925         uint userOwnershipPercentage;
4926         uint debtEntryIndex;
4927         (userOwnershipPercentage, debtEntryIndex) = feePoolState.getAccountsDebtEntry(account, 0);
4928 
4929         // If they don't have any debt ownership and they haven't minted, they don't have any fees
4930         if (debtEntryIndex == 0 && userOwnershipPercentage == 0) return;
4931 
4932         // If there are no XDR synths, then they don't have any fees
4933         if (synthetix.totalIssuedSynths("XDR") == 0) return;
4934 
4935         uint penalty = currentPenalty(account);
4936 
4937         // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
4938         // fees owing for, so we need to report on it anyway.
4939         uint feesFromPeriod;
4940         uint rewardsFromPeriod;
4941         (feesFromPeriod, rewardsFromPeriod) = _feesAndRewardsFromPeriod(0, userOwnershipPercentage, debtEntryIndex, penalty);
4942 
4943         results[0][0] = feesFromPeriod;
4944         results[0][1] = rewardsFromPeriod;
4945 
4946         // Go through our fee periods from the oldest feePeriod[FEE_PERIOD_LENGTH - 1] and figure out what we owe them.
4947         // Condition checks for periods > 0
4948         for (uint i = FEE_PERIOD_LENGTH - 1; i > 0; i--) {
4949             uint next = i - 1;
4950             FeePeriod memory nextPeriod = recentFeePeriods[next];
4951 
4952             // We can skip period if no debt minted during period
4953             if (nextPeriod.startingDebtIndex > 0 &&
4954             getLastFeeWithdrawal(account) < recentFeePeriods[i].feePeriodId) {
4955 
4956                 // We calculate a feePeriod's closingDebtIndex by looking at the next feePeriod's startingDebtIndex
4957                 // we can use the most recent issuanceData[0] for the current feePeriod
4958                 // else find the applicableIssuanceData for the feePeriod based on the StartingDebtIndex of the period
4959                 uint closingDebtIndex = nextPeriod.startingDebtIndex.sub(1);
4960 
4961                 // Gas optimisation - to reuse debtEntryIndex if found new applicable one
4962                 // if applicable is 0,0 (none found) we keep most recent one from issuanceData[0]
4963                 // return if userOwnershipPercentage = 0)
4964                 (userOwnershipPercentage, debtEntryIndex) = feePoolState.applicableIssuanceData(account, closingDebtIndex);
4965 
4966                 (feesFromPeriod, rewardsFromPeriod) = _feesAndRewardsFromPeriod(i, userOwnershipPercentage, debtEntryIndex, penalty);
4967 
4968                 results[i][0] = feesFromPeriod;
4969                 results[i][1] = rewardsFromPeriod;
4970             }
4971         }
4972     }
4973 
4974     /**
4975      * @notice ownershipPercentage is a high precision decimals uint based on
4976      * wallet's debtPercentage. Gives a precise amount of the feesToDistribute
4977      * for fees in the period. Precision factor is removed before results are
4978      * returned.
4979      */
4980     function _feesAndRewardsFromPeriod(uint period, uint ownershipPercentage, uint debtEntryIndex, uint penalty)
4981         internal
4982         returns (uint, uint)
4983     {
4984         // If it's zero, they haven't issued, and they have no fees OR rewards.
4985         if (ownershipPercentage == 0) return (0, 0);
4986 
4987         uint debtOwnershipForPeriod = ownershipPercentage;
4988 
4989         // If period has closed we want to calculate debtPercentage for the period
4990         if (period > 0) {
4991             uint closingDebtIndex = recentFeePeriods[period - 1].startingDebtIndex.sub(1);
4992             debtOwnershipForPeriod = _effectiveDebtRatioForPeriod(closingDebtIndex, ownershipPercentage, debtEntryIndex);
4993         }
4994 
4995         // Calculate their percentage of the fees / rewards in this period
4996         // This is a high precision integer.
4997         uint feesFromPeriodWithoutPenalty = recentFeePeriods[period].feesToDistribute
4998             .multiplyDecimal(debtOwnershipForPeriod);
4999 
5000         uint rewardsFromPeriodWithoutPenalty = recentFeePeriods[period].rewardsToDistribute
5001             .multiplyDecimal(debtOwnershipForPeriod);
5002 
5003         // Less their penalty if they have one.
5004         uint feesFromPeriod = feesFromPeriodWithoutPenalty.sub(feesFromPeriodWithoutPenalty.multiplyDecimal(penalty));
5005 
5006         uint rewardsFromPeriod = rewardsFromPeriodWithoutPenalty.sub(rewardsFromPeriodWithoutPenalty.multiplyDecimal(penalty));
5007 
5008         return (
5009             feesFromPeriod.preciseDecimalToDecimal(),
5010             rewardsFromPeriod.preciseDecimalToDecimal()
5011         );
5012     }
5013 
5014     function _effectiveDebtRatioForPeriod(uint closingDebtIndex, uint ownershipPercentage, uint debtEntryIndex)
5015         internal
5016         view
5017         returns (uint)
5018     {
5019         // Condition to check if debtLedger[] has value otherwise return 0
5020         if (closingDebtIndex > synthetixState.debtLedgerLength()) return 0;
5021 
5022         // Figure out their global debt percentage delta at end of fee Period.
5023         // This is a high precision integer.
5024         uint feePeriodDebtOwnership = synthetixState.debtLedger(closingDebtIndex)
5025             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
5026             .multiplyDecimalRoundPrecise(ownershipPercentage);
5027 
5028         return feePeriodDebtOwnership;
5029     }
5030 
5031     function effectiveDebtRatioForPeriod(address account, uint period)
5032         external
5033         view
5034         returns (uint)
5035     {
5036         require(period != 0, "Current period has not closed yet");
5037         require(period < FEE_PERIOD_LENGTH, "Period exceeds the FEE_PERIOD_LENGTH");
5038 
5039         // No debt minted during period as next period starts at 0
5040         if (recentFeePeriods[period - 1].startingDebtIndex == 0) return;
5041 
5042         uint closingDebtIndex = recentFeePeriods[period - 1].startingDebtIndex.sub(1);
5043 
5044         uint ownershipPercentage;
5045         uint debtEntryIndex;
5046         (ownershipPercentage, debtEntryIndex) = feePoolState.applicableIssuanceData(account, closingDebtIndex);
5047 
5048         // internal function will check closingDebtIndex has corresponding debtLedger entry
5049         return _effectiveDebtRatioForPeriod(closingDebtIndex, ownershipPercentage, debtEntryIndex);
5050     }
5051 
5052     /**
5053      * @notice Get the feePeriodID of the last claim this account made
5054      * @param _claimingAddress account to check the last fee period ID claim for
5055      * @return uint of the feePeriodID this account last claimed
5056      */
5057     function getLastFeeWithdrawal(address _claimingAddress)
5058         public
5059         view
5060         returns (uint)
5061     {
5062         return feePoolEternalStorage.getUIntValue(keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, _claimingAddress)));
5063     }
5064 
5065     /**
5066      * @notice Set the feePeriodID of the last claim this account made
5067      * @param _claimingAddress account to set the last feePeriodID claim for
5068      * @param _feePeriodID the feePeriodID this account claimed fees for
5069      */
5070     function _setLastFeeWithdrawal(address _claimingAddress, uint _feePeriodID)
5071         internal
5072     {
5073         feePoolEternalStorage.setUIntValue(keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, _claimingAddress)), _feePeriodID);
5074     }
5075 
5076     /* ========== Modifiers ========== */
5077 
5078     modifier optionalProxy_onlyFeeAuthority
5079     {
5080         if (Proxy(msg.sender) != proxy) {
5081             messageSender = msg.sender;
5082         }
5083         require(msg.sender == feeAuthority, "Only the fee authority can perform this action");
5084         _;
5085     }
5086 
5087     modifier onlySynthetix
5088     {
5089         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
5090         _;
5091     }
5092 
5093     modifier notFeeAddress(address account) {
5094         require(account != FEE_ADDRESS, "Fee address not allowed");
5095         _;
5096     }
5097 
5098     /* ========== Events ========== */
5099 
5100     event IssuanceDebtRatioEntry(address indexed account, uint debtRatio, uint debtEntryIndex, uint feePeriodStartingDebtIndex);
5101     bytes32 constant ISSUANCEDEBTRATIOENTRY_SIG = keccak256("IssuanceDebtRatioEntry(address,uint256,uint256,uint256)");
5102     function emitIssuanceDebtRatioEntry(address account, uint debtRatio, uint debtEntryIndex, uint feePeriodStartingDebtIndex) internal {
5103         proxy._emit(abi.encode(debtRatio, debtEntryIndex, feePeriodStartingDebtIndex), 2, ISSUANCEDEBTRATIOENTRY_SIG, bytes32(account), 0, 0);
5104     }
5105 
5106     event TransferFeeUpdated(uint newFeeRate);
5107     bytes32 constant TRANSFERFEEUPDATED_SIG = keccak256("TransferFeeUpdated(uint256)");
5108     function emitTransferFeeUpdated(uint newFeeRate) internal {
5109         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEEUPDATED_SIG, 0, 0, 0);
5110     }
5111 
5112     event ExchangeFeeUpdated(uint newFeeRate);
5113     bytes32 constant EXCHANGEFEEUPDATED_SIG = keccak256("ExchangeFeeUpdated(uint256)");
5114     function emitExchangeFeeUpdated(uint newFeeRate) internal {
5115         proxy._emit(abi.encode(newFeeRate), 1, EXCHANGEFEEUPDATED_SIG, 0, 0, 0);
5116     }
5117 
5118     event FeePeriodDurationUpdated(uint newFeePeriodDuration);
5119     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
5120     function emitFeePeriodDurationUpdated(uint newFeePeriodDuration) internal {
5121         proxy._emit(abi.encode(newFeePeriodDuration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
5122     }
5123 
5124     event FeeAuthorityUpdated(address newFeeAuthority);
5125     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
5126     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
5127         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
5128     }
5129 
5130     event FeePoolStateUpdated(address newFeePoolState);
5131     bytes32 constant FEEPOOLSTATEUPDATED_SIG = keccak256("FeePoolStateUpdated(address)");
5132     function emitFeePoolStateUpdated(address newFeePoolState) internal {
5133         proxy._emit(abi.encode(newFeePoolState), 1, FEEPOOLSTATEUPDATED_SIG, 0, 0, 0);
5134     }
5135 
5136     event DelegateApprovalsUpdated(address newDelegateApprovals);
5137     bytes32 constant DELEGATEAPPROVALSUPDATED_SIG = keccak256("DelegateApprovalsUpdated(address)");
5138     function emitDelegateApprovalsUpdated(address newDelegateApprovals) internal {
5139         proxy._emit(abi.encode(newDelegateApprovals), 1, DELEGATEAPPROVALSUPDATED_SIG, 0, 0, 0);
5140     }
5141 
5142     event FeePeriodClosed(uint feePeriodId);
5143     bytes32 constant FEEPERIODCLOSED_SIG = keccak256("FeePeriodClosed(uint256)");
5144     function emitFeePeriodClosed(uint feePeriodId) internal {
5145         proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
5146     }
5147 
5148     event FeesClaimed(address account, uint xdrAmount);
5149     bytes32 constant FEESCLAIMED_SIG = keccak256("FeesClaimed(address,uint256)");
5150     function emitFeesClaimed(address account, uint xdrAmount) internal {
5151         proxy._emit(abi.encode(account, xdrAmount), 1, FEESCLAIMED_SIG, 0, 0, 0);
5152     }
5153 
5154     event RewardsClaimed(address account, uint snxAmount);
5155     bytes32 constant REWARDSCLAIMED_SIG = keccak256("RewardsClaimed(address,uint256)");
5156     function emitRewardsClaimed(address account, uint snxAmount) internal {
5157         proxy._emit(abi.encode(account, snxAmount), 1, REWARDSCLAIMED_SIG, 0, 0, 0);
5158     }
5159 
5160     event SynthetixUpdated(address newSynthetix);
5161     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
5162     function emitSynthetixUpdated(address newSynthetix) internal {
5163         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
5164     }
5165 }