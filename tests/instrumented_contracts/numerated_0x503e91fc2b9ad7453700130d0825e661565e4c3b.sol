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
2811     string constant TOKEN_NAME = "Synthetix Network Token";
2812     string constant TOKEN_SYMBOL = "SNX";
2813     uint8 constant DECIMALS = 18;
2814     // ========== CONSTRUCTOR ==========
2815 
2816     /**
2817      * @dev Constructor
2818      * @param _tokenState A pre-populated contract containing token balances.
2819      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2820      * @param _owner The owner of this contract.
2821      */
2822     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2823         address _owner, ExchangeRates _exchangeRates, IFeePool _feePool, SupplySchedule _supplySchedule,
2824         ISynthetixEscrow _rewardEscrow, ISynthetixEscrow _escrow, uint _totalSupply
2825     )
2826         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, _totalSupply, DECIMALS, _owner)
2827         public
2828     {
2829         synthetixState = _synthetixState;
2830         exchangeRates = _exchangeRates;
2831         feePool = _feePool;
2832         supplySchedule = _supplySchedule;
2833         rewardEscrow = _rewardEscrow;
2834         escrow = _escrow;
2835     }
2836     // ========== SETTERS ========== */
2837 
2838     function setFeePool(IFeePool _feePool)
2839         external
2840         optionalProxy_onlyOwner
2841     {
2842         feePool = _feePool;
2843     }
2844 
2845     function setExchangeRates(ExchangeRates _exchangeRates)
2846         external
2847         optionalProxy_onlyOwner
2848     {
2849         exchangeRates = _exchangeRates;
2850     }
2851 
2852     /**
2853      * @notice Add an associated Synth contract to the Synthetix system
2854      * @dev Only the contract owner may call this.
2855      */
2856     function addSynth(Synth synth)
2857         external
2858         optionalProxy_onlyOwner
2859     {
2860         bytes4 currencyKey = synth.currencyKey();
2861 
2862         require(synths[currencyKey] == Synth(0), "Synth already exists");
2863 
2864         availableSynths.push(synth);
2865         synths[currencyKey] = synth;
2866     }
2867 
2868     /**
2869      * @notice Remove an associated Synth contract from the Synthetix system
2870      * @dev Only the contract owner may call this.
2871      */
2872     function removeSynth(bytes4 currencyKey)
2873         external
2874         optionalProxy_onlyOwner
2875     {
2876         require(synths[currencyKey] != address(0), "Synth does not exist");
2877         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2878         require(currencyKey != "XDR", "Cannot remove XDR synth");
2879 
2880         // Save the address we're removing for emitting the event at the end.
2881         address synthToRemove = synths[currencyKey];
2882 
2883         // Remove the synth from the availableSynths array.
2884         for (uint8 i = 0; i < availableSynths.length; i++) {
2885             if (availableSynths[i] == synthToRemove) {
2886                 delete availableSynths[i];
2887 
2888                 // Copy the last synth into the place of the one we just deleted
2889                 // If there's only one synth, this is synths[0] = synths[0].
2890                 // If we're deleting the last one, it's also a NOOP in the same way.
2891                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2892 
2893                 // Decrease the size of the array by one.
2894                 availableSynths.length--;
2895 
2896                 break;
2897             }
2898         }
2899 
2900         // And remove it from the synths mapping
2901         delete synths[currencyKey];
2902 
2903         // Note: No event here as our contract exceeds max contract size
2904         // with these events, and it's unlikely people will need to
2905         // track these events specifically.
2906     }
2907 
2908     // ========== VIEWS ==========
2909 
2910     /**
2911      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2912      * @param sourceCurrencyKey The currency the amount is specified in
2913      * @param sourceAmount The source amount, specified in UNIT base
2914      * @param destinationCurrencyKey The destination currency
2915      */
2916     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
2917         public
2918         view
2919         rateNotStale(sourceCurrencyKey)
2920         rateNotStale(destinationCurrencyKey)
2921         returns (uint)
2922     {
2923         // If there's no change in the currency, then just return the amount they gave us
2924         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
2925 
2926         // Calculate the effective value by going from source -> USD -> destination
2927         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
2928             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
2929     }
2930 
2931     /**
2932      * @notice Total amount of synths issued by the system, priced in currencyKey
2933      * @param currencyKey The currency to value the synths in
2934      */
2935     function totalIssuedSynths(bytes4 currencyKey)
2936         public
2937         view
2938         rateNotStale(currencyKey)
2939         returns (uint)
2940     {
2941         uint total = 0;
2942         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2943 
2944         require(!exchangeRates.anyRateIsStale(availableCurrencyKeys()), "Rates are stale");
2945 
2946         for (uint8 i = 0; i < availableSynths.length; i++) {
2947             // What's the total issued value of that synth in the destination currency?
2948             // Note: We're not using our effectiveValue function because we don't want to go get the
2949             //       rate for the destination currency and check if it's stale repeatedly on every
2950             //       iteration of the loop
2951             uint synthValue = availableSynths[i].totalSupply()
2952                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
2953                 .divideDecimalRound(currencyRate);
2954             total = total.add(synthValue);
2955         }
2956 
2957         return total;
2958     }
2959 
2960     /**
2961      * @notice Returns the currencyKeys of availableSynths for rate checking
2962      */
2963     function availableCurrencyKeys()
2964         internal
2965         view
2966         returns (bytes4[])
2967     {
2968         bytes4[] memory availableCurrencyKeys = new bytes4[](availableSynths.length);
2969 
2970         for (uint8 i = 0; i < availableSynths.length; i++) {
2971             availableCurrencyKeys[i] = availableSynths[i].currencyKey();
2972         }
2973 
2974         return availableCurrencyKeys;
2975     }
2976 
2977     /**
2978      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
2979      */
2980     function availableSynthCount()
2981         public
2982         view
2983         returns (uint)
2984     {
2985         return availableSynths.length;
2986     }
2987 
2988     // ========== MUTATIVE FUNCTIONS ==========
2989 
2990     /**
2991      * @notice ERC20 transfer function.
2992      */
2993     function transfer(address to, uint value)
2994         public
2995         returns (bool)
2996     {
2997         bytes memory empty;
2998         return transfer(to, value, empty);
2999     }
3000 
3001     /**
3002      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
3003      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3004      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3005      *           tooling such as Etherscan.
3006      */
3007     function transfer(address to, uint value, bytes data)
3008         public
3009         optionalProxy
3010         returns (bool)
3011     {
3012         // Ensure they're not trying to exceed their locked amount
3013         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
3014 
3015         // Perform the transfer: if there is a problem an exception will be thrown in this call.
3016         _transfer_byProxy(messageSender, to, value, data);
3017 
3018         return true;
3019     }
3020 
3021     /**
3022      * @notice ERC20 transferFrom function.
3023      */
3024     function transferFrom(address from, address to, uint value)
3025         public
3026         returns (bool)
3027     {
3028         bytes memory empty;
3029         return transferFrom(from, to, value, empty);
3030     }
3031 
3032     /**
3033      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
3034      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3035      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3036      *           tooling such as Etherscan.
3037      */
3038     function transferFrom(address from, address to, uint value, bytes data)
3039         public
3040         optionalProxy
3041         returns (bool)
3042     {
3043         // Ensure they're not trying to exceed their locked amount
3044         require(value <= transferableSynthetix(from), "Insufficient balance");
3045 
3046         // Perform the transfer: if there is a problem,
3047         // an exception will be thrown in this call.
3048         _transferFrom_byProxy(messageSender, from, to, value, data);
3049 
3050         return true;
3051     }
3052 
3053     /**
3054      * @notice Function that allows you to exchange synths you hold in one flavour for another.
3055      * @param sourceCurrencyKey The source currency you wish to exchange from
3056      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3057      * @param destinationCurrencyKey The destination currency you wish to obtain.
3058      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
3059      * @return Boolean that indicates whether the transfer succeeded or failed.
3060      */
3061     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
3062         external
3063         optionalProxy
3064         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
3065         returns (bool)
3066     {
3067         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
3068         require(sourceAmount > 0, "Zero amount");
3069 
3070         // Pass it along, defaulting to the sender as the recipient.
3071         return _internalExchange(
3072             messageSender,
3073             sourceCurrencyKey,
3074             sourceAmount,
3075             destinationCurrencyKey,
3076             destinationAddress == address(0) ? messageSender : destinationAddress,
3077             true // Charge fee on the exchange
3078         );
3079     }
3080 
3081     /**
3082      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
3083      * @dev Only the synth contract can call this function
3084      * @param from The address to exchange / burn synth from
3085      * @param sourceCurrencyKey The source currency you wish to exchange from
3086      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3087      * @param destinationCurrencyKey The destination currency you wish to obtain.
3088      * @param destinationAddress Where the result should go.
3089      * @return Boolean that indicates whether the transfer succeeded or failed.
3090      */
3091     function synthInitiatedExchange(
3092         address from,
3093         bytes4 sourceCurrencyKey,
3094         uint sourceAmount,
3095         bytes4 destinationCurrencyKey,
3096         address destinationAddress
3097     )
3098         external
3099         onlySynth
3100         returns (bool)
3101     {
3102         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3103         require(sourceAmount > 0, "Zero amount");
3104 
3105         // Pass it along
3106         return _internalExchange(
3107             from,
3108             sourceCurrencyKey,
3109             sourceAmount,
3110             destinationCurrencyKey,
3111             destinationAddress,
3112             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
3113         );
3114     }
3115 
3116     /**
3117      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3118      * @dev Only the synth contract can call this function.
3119      * @param from The address fee is coming from.
3120      * @param sourceCurrencyKey source currency fee from.
3121      * @param sourceAmount The amount, specified in UNIT of source currency.
3122      * @return Boolean that indicates whether the transfer succeeded or failed.
3123      */
3124     function synthInitiatedFeePayment(
3125         address from,
3126         bytes4 sourceCurrencyKey,
3127         uint sourceAmount
3128     )
3129         external
3130         onlySynth
3131         returns (bool)
3132     {
3133         // Allow fee to be 0 and skip minting XDRs to feePool
3134         if (sourceAmount == 0) {
3135             return true;
3136         }
3137 
3138         require(sourceAmount > 0, "Source can't be 0");
3139 
3140         // Pass it along, defaulting to the sender as the recipient.
3141         bool result = _internalExchange(
3142             from,
3143             sourceCurrencyKey,
3144             sourceAmount,
3145             "XDR",
3146             feePool.FEE_ADDRESS(),
3147             false // Don't charge a fee on the exchange because this is already a fee
3148         );
3149 
3150         // Tell the fee pool about this.
3151         feePool.feePaid(sourceCurrencyKey, sourceAmount);
3152 
3153         return result;
3154     }
3155 
3156     /**
3157      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3158      * @dev fee pool contract address is not allowed to call function
3159      * @param from The address to move synth from
3160      * @param sourceCurrencyKey source currency from.
3161      * @param sourceAmount The amount, specified in UNIT of source currency.
3162      * @param destinationCurrencyKey The destination currency to obtain.
3163      * @param destinationAddress Where the result should go.
3164      * @param chargeFee Boolean to charge a fee for transaction.
3165      * @return Boolean that indicates whether the transfer succeeded or failed.
3166      */
3167     function _internalExchange(
3168         address from,
3169         bytes4 sourceCurrencyKey,
3170         uint sourceAmount,
3171         bytes4 destinationCurrencyKey,
3172         address destinationAddress,
3173         bool chargeFee
3174     )
3175         internal
3176         notFeeAddress(from)
3177         returns (bool)
3178     {
3179         require(destinationAddress != address(0), "Zero destination");
3180         require(destinationAddress != address(this), "Synthetix is invalid destination");
3181         require(destinationAddress != address(proxy), "Proxy is invalid destination");
3182 
3183         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3184         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3185 
3186         // Burn the source amount
3187         synths[sourceCurrencyKey].burn(from, sourceAmount);
3188 
3189         // How much should they get in the destination currency?
3190         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3191 
3192         // What's the fee on that currency that we should deduct?
3193         uint amountReceived = destinationAmount;
3194         uint fee = 0;
3195 
3196         if (chargeFee) {
3197             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
3198             fee = destinationAmount.sub(amountReceived);
3199         }
3200 
3201         // Issue their new synths
3202         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3203 
3204         // Remit the fee in XDRs
3205         if (fee > 0) {
3206             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3207             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3208             // Tell the fee pool about this.
3209             feePool.feePaid("XDR", xdrFeeAmount);
3210         }
3211 
3212         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3213 
3214         // Call the ERC223 transfer callback if needed
3215         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
3216 
3217         //Let the DApps know there was a Synth exchange
3218         emitSynthExchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, amountReceived, destinationAddress);
3219 
3220         return true;
3221     }
3222 
3223     /**
3224      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
3225      * @dev Only internal calls from synthetix address.
3226      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3227      * @param amount The amount of synths to register with a base of UNIT
3228      */
3229     function _addToDebtRegister(bytes4 currencyKey, uint amount)
3230         internal
3231         optionalProxy
3232     {
3233         // What is the value of the requested debt in XDRs?
3234         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3235 
3236         // What is the value of all issued synths of the system (priced in XDRs)?
3237         uint totalDebtIssued = totalIssuedSynths("XDR");
3238 
3239         // What will the new total be including the new value?
3240         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3241 
3242         // What is their percentage (as a high precision int) of the total debt?
3243         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3244 
3245         // And what effect does this percentage change have on the global debt holding of other issuers?
3246         // The delta specifically needs to not take into account any existing debt as it's already
3247         // accounted for in the delta from when they issued previously.
3248         // The delta is a high precision integer.
3249         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3250 
3251         // How much existing debt do they have?
3252         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3253 
3254         // And what does their debt ownership look like including this previous stake?
3255         if (existingDebt > 0) {
3256             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3257         }
3258 
3259         // Are they a new issuer? If so, record them.
3260         if (!synthetixState.hasIssued(messageSender)) {
3261             synthetixState.incrementTotalIssuerCount();
3262         }
3263 
3264         // Save the debt entry parameters
3265         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3266 
3267         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3268         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3269         if (synthetixState.debtLedgerLength() > 0) {
3270             synthetixState.appendDebtLedgerValue(
3271                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3272             );
3273         } else {
3274             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3275         }
3276     }
3277 
3278     /**
3279      * @notice Issue synths against the sender's SNX.
3280      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3281      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3282      * @param amount The amount of synths you wish to issue with a base of UNIT
3283      */
3284     function issueSynths(bytes4 currencyKey, uint amount)
3285         public
3286         optionalProxy
3287         // No need to check if price is stale, as it is checked in issuableSynths.
3288     {
3289         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3290 
3291         // Keep track of the debt they're about to create
3292         _addToDebtRegister(currencyKey, amount);
3293 
3294         // Create their synths
3295         synths[currencyKey].issue(messageSender, amount);
3296 
3297         // Store their locked SNX amount to determine their fee % for the period
3298         _appendAccountIssuanceRecord();
3299     }
3300 
3301     /**
3302      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3303      * @dev Issuance is only allowed if the synthetix price isn't stale.
3304      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3305      */
3306     function issueMaxSynths(bytes4 currencyKey)
3307         external
3308         optionalProxy
3309     {
3310         // Figure out the maximum we can issue in that currency
3311         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3312 
3313         // And issue them
3314         issueSynths(currencyKey, maxIssuable);
3315     }
3316 
3317     /**
3318      * @notice Burn synths to clear issued synths/free SNX.
3319      * @param currencyKey The currency you're specifying to burn
3320      * @param amount The amount (in UNIT base) you wish to burn
3321      * @dev The amount to burn is debased to XDR's
3322      */
3323     function burnSynths(bytes4 currencyKey, uint amount)
3324         external
3325         optionalProxy
3326         // No need to check for stale rates as effectiveValue checks rates
3327     {
3328         // How much debt do they have?
3329         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3330         uint debt = debtBalanceOf(messageSender, "XDR");
3331         uint debtInCurrencyKey = debtBalanceOf(messageSender, currencyKey);
3332 
3333         require(debt > 0, "No debt to forgive");
3334 
3335         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3336         // clear their debt and leave them be.
3337         uint amountToRemove = debt < debtToRemove ? debt : debtToRemove;
3338 
3339         // Remove their debt from the ledger
3340         _removeFromDebtRegister(amountToRemove);
3341 
3342         uint amountToBurn = debtInCurrencyKey < amount ? debtInCurrencyKey : amount;
3343 
3344         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3345         synths[currencyKey].burn(messageSender, amountToBurn);
3346 
3347         // Store their debtRatio against a feeperiod to determine their fee/rewards % for the period
3348         _appendAccountIssuanceRecord();
3349     }
3350 
3351     /**
3352      * @notice Store in the FeePool the users current debt value in the system in XDRs.
3353      * @dev debtBalanceOf(messageSender, "XDR") to be used with totalIssuedSynths("XDR") to get
3354      *  users % of the system within a feePeriod.
3355      */
3356     function _appendAccountIssuanceRecord()
3357         internal
3358     {
3359         uint initialDebtOwnership;
3360         uint debtEntryIndex;
3361         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(messageSender);
3362 
3363         feePool.appendAccountIssuanceRecord(
3364             messageSender,
3365             initialDebtOwnership,
3366             debtEntryIndex
3367         );
3368     }
3369 
3370     /**
3371      * @notice Remove a debt position from the register
3372      * @param amount The amount (in UNIT base) being presented in XDRs
3373      */
3374     function _removeFromDebtRegister(uint amount)
3375         internal
3376     {
3377         uint debtToRemove = amount;
3378 
3379         // How much debt do they have?
3380         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3381 
3382         // What is the value of all issued synths of the system (priced in XDRs)?
3383         uint totalDebtIssued = totalIssuedSynths("XDR");
3384 
3385         // What will the new total after taking out the withdrawn amount
3386         uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3387 
3388         uint delta;
3389 
3390         // What will the debt delta be if there is any debt left?
3391         // Set delta to 0 if no more debt left in system after user
3392         if (newTotalDebtIssued > 0) {
3393 
3394             // What is the percentage of the withdrawn debt (as a high precision int) of the total debt after?
3395             uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(newTotalDebtIssued);
3396 
3397             // And what effect does this percentage change have on the global debt holding of other issuers?
3398             // The delta specifically needs to not take into account any existing debt as it's already
3399             // accounted for in the delta from when they issued previously.
3400             delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3401         } else {
3402             delta = 0;
3403         }
3404 
3405         // Are they exiting the system, or are they just decreasing their debt position?
3406         if (debtToRemove == existingDebt) {
3407             synthetixState.setCurrentIssuanceData(messageSender, 0);
3408             synthetixState.decrementTotalIssuerCount();
3409         } else {
3410             // What percentage of the debt will they be left with?
3411             uint newDebt = existingDebt.sub(debtToRemove);
3412             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3413 
3414             // Store the debt percentage and debt ledger as high precision integers
3415             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3416         }
3417 
3418         // Update our cumulative ledger. This is also a high precision integer.
3419         synthetixState.appendDebtLedgerValue(
3420             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3421         );
3422     }
3423 
3424     // ========== Issuance/Burning ==========
3425 
3426     /**
3427      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3428      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3429      */
3430     function maxIssuableSynths(address issuer, bytes4 currencyKey)
3431         public
3432         view
3433         // We don't need to check stale rates here as effectiveValue will do it for us.
3434         returns (uint)
3435     {
3436         // What is the value of their SNX balance in the destination currency?
3437         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3438 
3439         // They're allowed to issue up to issuanceRatio of that value
3440         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3441     }
3442 
3443     /**
3444      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3445      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
3446      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3447      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
3448      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3449      * altering the amount of fees they're able to claim from the system.
3450      */
3451     function collateralisationRatio(address issuer)
3452         public
3453         view
3454         returns (uint)
3455     {
3456         uint totalOwnedSynthetix = collateral(issuer);
3457         if (totalOwnedSynthetix == 0) return 0;
3458 
3459         uint debtBalance = debtBalanceOf(issuer, "SNX");
3460         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3461     }
3462 
3463     /**
3464      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3465      * will tell you how many synths a user has to give back to the system in order to unlock their original
3466      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3467      * the debt in sUSD, XDR, or any other synth you wish.
3468      */
3469     function debtBalanceOf(address issuer, bytes4 currencyKey)
3470         public
3471         view
3472         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3473         returns (uint)
3474     {
3475         // What was their initial debt ownership?
3476         uint initialDebtOwnership;
3477         uint debtEntryIndex;
3478         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3479 
3480         // If it's zero, they haven't issued, and they have no debt.
3481         if (initialDebtOwnership == 0) return 0;
3482 
3483         // Figure out the global debt percentage delta from when they entered the system.
3484         // This is a high precision integer.
3485         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3486             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3487             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3488 
3489         // What's the total value of the system in their requested currency?
3490         uint totalSystemValue = totalIssuedSynths(currencyKey);
3491 
3492         // Their debt balance is their portion of the total system value.
3493         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3494             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3495 
3496         return highPrecisionBalance.preciseDecimalToDecimal();
3497     }
3498 
3499     /**
3500      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3501      * @param issuer The account that intends to issue
3502      * @param currencyKey The currency to price issuable value in
3503      */
3504     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
3505         public
3506         view
3507         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3508         returns (uint)
3509     {
3510         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3511         uint max = maxIssuableSynths(issuer, currencyKey);
3512 
3513         if (alreadyIssued >= max) {
3514             return 0;
3515         } else {
3516             return max.sub(alreadyIssued);
3517         }
3518     }
3519 
3520     /**
3521      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3522      * against which synths can be issued.
3523      * This includes those already being used as collateral (locked), and those
3524      * available for further issuance (unlocked).
3525      */
3526     function collateral(address account)
3527         public
3528         view
3529         returns (uint)
3530     {
3531         uint balance = tokenState.balanceOf(account);
3532 
3533         if (escrow != address(0)) {
3534             balance = balance.add(escrow.balanceOf(account));
3535         }
3536 
3537         if (rewardEscrow != address(0)) {
3538             balance = balance.add(rewardEscrow.balanceOf(account));
3539         }
3540 
3541         return balance;
3542     }
3543 
3544     /**
3545      * @notice The number of SNX that are free to be transferred by an account.
3546      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
3547      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
3548      * in this calculation.
3549      */
3550     function transferableSynthetix(address account)
3551         public
3552         view
3553         rateNotStale("SNX")
3554         returns (uint)
3555     {
3556         // How many SNX do they have, excluding escrow?
3557         // Note: We're excluding escrow here because we're interested in their transferable amount
3558         // and escrowed SNX are not transferable.
3559         uint balance = tokenState.balanceOf(account);
3560 
3561         // How many of those will be locked by the amount they've issued?
3562         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3563         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3564         // The locked synthetix value can exceed their balance.
3565         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3566 
3567         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3568         if (lockedSynthetixValue >= balance) {
3569             return 0;
3570         } else {
3571             return balance.sub(lockedSynthetixValue);
3572         }
3573     }
3574 
3575     function mint()
3576         external
3577         returns (bool)
3578     {
3579         require(rewardEscrow != address(0), "Reward Escrow destination missing");
3580 
3581         uint supplyToMint = supplySchedule.mintableSupply();
3582         require(supplyToMint > 0, "No supply is mintable");
3583 
3584         supplySchedule.updateMintValues();
3585 
3586         // Set minted SNX balance to RewardEscrow's balance
3587         // Minus the minterReward and set balance of minter to add reward
3588         uint minterReward = supplySchedule.minterReward();
3589 
3590         tokenState.setBalanceOf(rewardEscrow, tokenState.balanceOf(rewardEscrow).add(supplyToMint.sub(minterReward)));
3591         emitTransfer(this, rewardEscrow, supplyToMint.sub(minterReward));
3592 
3593         // Tell the FeePool how much it has to distribute
3594         feePool.rewardsMinted(supplyToMint.sub(minterReward));
3595 
3596         // Assign the minters reward.
3597         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
3598         emitTransfer(this, msg.sender, minterReward);
3599 
3600         totalSupply = totalSupply.add(supplyToMint);
3601     }
3602 
3603     // ========== MODIFIERS ==========
3604 
3605     modifier rateNotStale(bytes4 currencyKey) {
3606         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
3607         _;
3608     }
3609 
3610     modifier notFeeAddress(address account) {
3611         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3612         _;
3613     }
3614 
3615     modifier onlySynth() {
3616         bool isSynth = false;
3617 
3618         // No need to repeatedly call this function either
3619         for (uint8 i = 0; i < availableSynths.length; i++) {
3620             if (availableSynths[i] == msg.sender) {
3621                 isSynth = true;
3622                 break;
3623             }
3624         }
3625 
3626         require(isSynth, "Only synth allowed");
3627         _;
3628     }
3629 
3630     modifier nonZeroAmount(uint _amount) {
3631         require(_amount > 0, "Amount needs to be larger than 0");
3632         _;
3633     }
3634 
3635     // ========== EVENTS ==========
3636     /* solium-disable */
3637     event SynthExchange(address indexed account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey,  uint256 toAmount, address toAddress);
3638     bytes32 constant SYNTHEXCHANGE_SIG = keccak256("SynthExchange(address,bytes4,uint256,bytes4,uint256,address)");
3639     function emitSynthExchange(address account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey, uint256 toAmount, address toAddress) internal {
3640         proxy._emit(abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress), 2, SYNTHEXCHANGE_SIG, bytes32(account), 0, 0);
3641     }
3642     /* solium-enable */
3643 }
3644 
3645 
3646 /*
3647 -----------------------------------------------------------------
3648 FILE INFORMATION
3649 -----------------------------------------------------------------
3650 
3651 file:       FeePoolState.sol
3652 version:    1.0
3653 author:     Clinton Ennis
3654             Jackson Chan
3655 date:       2019-04-05
3656 
3657 -----------------------------------------------------------------
3658 MODULE DESCRIPTION
3659 -----------------------------------------------------------------
3660 
3661 The FeePoolState simply stores the accounts issuance ratio for
3662 each fee period in the FeePool.
3663 
3664 This is use to caclulate the correct allocation of fees/rewards
3665 owed to minters of the stablecoin total supply
3666 
3667 -----------------------------------------------------------------
3668 */
3669 
3670 
3671 contract FeePoolState is SelfDestructible, LimitedSetup {
3672     using SafeMath for uint;
3673     using SafeDecimalMath for uint;
3674 
3675     /* ========== STATE VARIABLES ========== */
3676 
3677     uint8 constant public FEE_PERIOD_LENGTH = 6;
3678 
3679     address public feePool;
3680 
3681     // The IssuanceData activity that's happened in a fee period.
3682     struct IssuanceData {
3683         uint debtPercentage;
3684         uint debtEntryIndex;
3685     }
3686 
3687     // The IssuanceData activity that's happened in a fee period.
3688     mapping(address => IssuanceData[FEE_PERIOD_LENGTH]) public accountIssuanceLedger;
3689 
3690     /**
3691      * @dev Constructor.
3692      * @param _owner The owner of this contract.
3693      */
3694     constructor(address _owner, IFeePool _feePool)
3695         SelfDestructible(_owner)
3696         LimitedSetup(6 weeks)
3697         public
3698     {
3699         feePool = _feePool;
3700     }
3701 
3702     /* ========== SETTERS ========== */
3703 
3704     /**
3705      * @notice set the FeePool contract as it is the only authority to be able to call
3706      * appendAccountIssuanceRecord with the onlyFeePool modifer
3707      * @dev Must be set by owner when FeePool logic is upgraded
3708      */
3709     function setFeePool(IFeePool _feePool)
3710         external
3711         onlyOwner
3712     {
3713         feePool = _feePool;
3714     }
3715 
3716     /* ========== VIEWS ========== */
3717 
3718     /**
3719      * @notice Get an accounts issuanceData for
3720      * @param account users account
3721      * @param index Index in the array to retrieve. Upto FEE_PERIOD_LENGTH
3722      */
3723     function getAccountsDebtEntry(address account, uint index)
3724         public
3725         view
3726         returns (uint debtPercentage, uint debtEntryIndex)
3727     {
3728         require(index < FEE_PERIOD_LENGTH, "index exceeds the FEE_PERIOD_LENGTH");
3729 
3730         debtPercentage = accountIssuanceLedger[account][index].debtPercentage;
3731         debtEntryIndex = accountIssuanceLedger[account][index].debtEntryIndex;
3732     }
3733 
3734     /**
3735      * @notice Find the oldest debtEntryIndex for the corresponding closingDebtIndex
3736      * @param account users account
3737      * @param closingDebtIndex the last periods debt index on close
3738      */
3739     function applicableIssuanceData(address account, uint closingDebtIndex)
3740         external
3741         view
3742         returns (uint, uint)
3743     {
3744         IssuanceData[FEE_PERIOD_LENGTH] memory issuanceData = accountIssuanceLedger[account];
3745         
3746         // We want to use the user's debtEntryIndex at when the period closed
3747         // Find the oldest debtEntryIndex for the corresponding closingDebtIndex
3748         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
3749             if (closingDebtIndex >= issuanceData[i].debtEntryIndex) {
3750                 return (issuanceData[i].debtPercentage, issuanceData[i].debtEntryIndex);
3751             }
3752         }
3753     }
3754 
3755     /* ========== MUTATIVE FUNCTIONS ========== */
3756 
3757     /**
3758      * @notice Logs an accounts issuance data in the current fee period which is then stored historically
3759      * @param account Message.Senders account address
3760      * @param debtRatio Debt percentage this account has locked after minting or burning their synth
3761      * @param debtEntryIndex The index in the global debt ledger. synthetix.synthetixState().issuanceData(account)
3762      * @param currentPeriodStartDebtIndex The startingDebtIndex of the current fee period
3763      * @dev onlyFeePool to call me on synthetix.issue() & synthetix.burn() calls to store the locked SNX
3764      * per fee period so we know to allocate the correct proportions of fees and rewards per period
3765       accountIssuanceLedger[account][0] has the latest locked amount for the current period. This can be update as many time
3766       accountIssuanceLedger[account][1-3] has the last locked amount for a previous period they minted or burned
3767      */
3768     function appendAccountIssuanceRecord(address account, uint debtRatio, uint debtEntryIndex, uint currentPeriodStartDebtIndex)
3769         external
3770         onlyFeePool
3771     {
3772         // Is the current debtEntryIndex within this fee period
3773         if (accountIssuanceLedger[account][0].debtEntryIndex < currentPeriodStartDebtIndex) {
3774              // If its older then shift the previous IssuanceData entries periods down to make room for the new one.
3775             issuanceDataIndexOrder(account);
3776         }
3777         
3778         // Always store the latest IssuanceData entry at [0]
3779         accountIssuanceLedger[account][0].debtPercentage = debtRatio;
3780         accountIssuanceLedger[account][0].debtEntryIndex = debtEntryIndex;
3781     }
3782 
3783     /**
3784      * @notice Pushes down the entire array of debt ratios per fee period
3785      */
3786     function issuanceDataIndexOrder(address account)
3787         private
3788     {
3789         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
3790             uint next = i + 1;
3791             accountIssuanceLedger[account][next].debtPercentage = accountIssuanceLedger[account][i].debtPercentage;
3792             accountIssuanceLedger[account][next].debtEntryIndex = accountIssuanceLedger[account][i].debtEntryIndex;
3793         }
3794     }
3795 
3796     /**
3797      * @notice Import issuer data from synthetixState.issuerData on FeePeriodClose() block #
3798      * @dev Only callable by the contract owner, and only for 6 weeks after deployment.
3799      * @param accounts Array of issuing addresses
3800      * @param ratios Array of debt ratios
3801      * @param periodToInsert The Fee Period to insert the historical records into
3802      * @param feePeriodCloseIndex An accounts debtEntryIndex is valid when within the fee peroid,
3803      * since the input ratio will be an average of the pervious periods it just needs to be
3804      * > recentFeePeriods[periodToInsert].startingDebtIndex
3805      * < recentFeePeriods[periodToInsert - 1].startingDebtIndex
3806      */
3807     function importIssuerData(address[] accounts, uint[] ratios, uint periodToInsert, uint feePeriodCloseIndex)
3808         external
3809         onlyOwner
3810         onlyDuringSetup
3811     {
3812         require(accounts.length == ratios.length, "Length mismatch");
3813 
3814         for (uint8 i = 0; i < accounts.length; i++) {
3815             accountIssuanceLedger[accounts[i]][periodToInsert].debtPercentage = ratios[i];
3816             accountIssuanceLedger[accounts[i]][periodToInsert].debtEntryIndex = feePeriodCloseIndex;
3817             emit IssuanceDebtRatioEntry(accounts[i], ratios[i], feePeriodCloseIndex);
3818         }
3819     }
3820 
3821     /* ========== MODIFIERS ========== */
3822 
3823     modifier onlyFeePool
3824     {
3825         require(msg.sender == address(feePool), "Only the FeePool contract can perform this action");
3826         _;
3827     }
3828 
3829     /* ========== Events ========== */
3830     event IssuanceDebtRatioEntry(address indexed account, uint debtRatio, uint feePeriodCloseIndex);
3831 }
3832 
3833 
3834 /*
3835 -----------------------------------------------------------------
3836 FILE INFORMATION
3837 -----------------------------------------------------------------
3838 
3839 file:       EternalStorage.sol
3840 version:    1.0
3841 author:     Clinton Ennise
3842             Jackson Chan
3843 
3844 date:       2019-02-01
3845 
3846 -----------------------------------------------------------------
3847 MODULE DESCRIPTION
3848 -----------------------------------------------------------------
3849 
3850 This contract is used with external state storage contracts for
3851 decoupled data storage.
3852 
3853 Implements support for storing a keccak256 key and value pairs. It is
3854 the more flexible and extensible option. This ensures data schema
3855 changes can be implemented without requiring upgrades to the
3856 storage contract
3857 
3858 The first deployed storage contract would create this eternal storage.
3859 Favour use of keccak256 key over sha3 as future version of solidity
3860 > 0.5.0 will be deprecated.
3861 
3862 -----------------------------------------------------------------
3863 */
3864 
3865 
3866 /**
3867  * @notice  This contract is based on the code available from this blog
3868  * https://blog.colony.io/writing-upgradeable-contracts-in-solidity-6743f0eecc88/
3869  * Implements support for storing a keccak256 key and value pairs. It is the more flexible
3870  * and extensible option. This ensures data schema changes can be implemented without
3871  * requiring upgrades to the storage contract.
3872  */
3873 contract EternalStorage is State {
3874 
3875     constructor(address _owner, address _associatedContract)
3876         State(_owner, _associatedContract)
3877         public
3878     {
3879     }
3880 
3881     /* ========== DATA TYPES ========== */
3882     mapping(bytes32 => uint) UIntStorage;
3883     mapping(bytes32 => string) StringStorage;
3884     mapping(bytes32 => address) AddressStorage;
3885     mapping(bytes32 => bytes) BytesStorage;
3886     mapping(bytes32 => bytes32) Bytes32Storage;
3887     mapping(bytes32 => bool) BooleanStorage;
3888     mapping(bytes32 => int) IntStorage;
3889 
3890     // UIntStorage;
3891     function getUIntValue(bytes32 record) external view returns (uint){
3892         return UIntStorage[record];
3893     }
3894 
3895     function setUIntValue(bytes32 record, uint value) external
3896         onlyAssociatedContract
3897     {
3898         UIntStorage[record] = value;
3899     }
3900 
3901     function deleteUIntValue(bytes32 record) external
3902         onlyAssociatedContract
3903     {
3904         delete UIntStorage[record];
3905     }
3906 
3907     // StringStorage
3908     function getStringValue(bytes32 record) external view returns (string memory){
3909         return StringStorage[record];
3910     }
3911 
3912     function setStringValue(bytes32 record, string value) external
3913         onlyAssociatedContract
3914     {
3915         StringStorage[record] = value;
3916     }
3917 
3918     function deleteStringValue(bytes32 record) external
3919         onlyAssociatedContract
3920     {
3921         delete StringStorage[record];
3922     }
3923 
3924     // AddressStorage
3925     function getAddressValue(bytes32 record) external view returns (address){
3926         return AddressStorage[record];
3927     }
3928 
3929     function setAddressValue(bytes32 record, address value) external
3930         onlyAssociatedContract
3931     {
3932         AddressStorage[record] = value;
3933     }
3934 
3935     function deleteAddressValue(bytes32 record) external
3936         onlyAssociatedContract
3937     {
3938         delete AddressStorage[record];
3939     }
3940 
3941 
3942     // BytesStorage
3943     function getBytesValue(bytes32 record) external view returns
3944     (bytes memory){
3945         return BytesStorage[record];
3946     }
3947 
3948     function setBytesValue(bytes32 record, bytes value) external
3949         onlyAssociatedContract
3950     {
3951         BytesStorage[record] = value;
3952     }
3953 
3954     function deleteBytesValue(bytes32 record) external
3955         onlyAssociatedContract
3956     {
3957         delete BytesStorage[record];
3958     }
3959 
3960     // Bytes32Storage
3961     function getBytes32Value(bytes32 record) external view returns (bytes32)
3962     {
3963         return Bytes32Storage[record];
3964     }
3965 
3966     function setBytes32Value(bytes32 record, bytes32 value) external
3967         onlyAssociatedContract
3968     {
3969         Bytes32Storage[record] = value;
3970     }
3971 
3972     function deleteBytes32Value(bytes32 record) external
3973         onlyAssociatedContract
3974     {
3975         delete Bytes32Storage[record];
3976     }
3977 
3978     // BooleanStorage
3979     function getBooleanValue(bytes32 record) external view returns (bool)
3980     {
3981         return BooleanStorage[record];
3982     }
3983 
3984     function setBooleanValue(bytes32 record, bool value) external
3985         onlyAssociatedContract
3986     {
3987         BooleanStorage[record] = value;
3988     }
3989 
3990     function deleteBooleanValue(bytes32 record) external
3991         onlyAssociatedContract
3992     {
3993         delete BooleanStorage[record];
3994     }
3995 
3996     // IntStorage
3997     function getIntValue(bytes32 record) external view returns (int){
3998         return IntStorage[record];
3999     }
4000 
4001     function setIntValue(bytes32 record, int value) external
4002         onlyAssociatedContract
4003     {
4004         IntStorage[record] = value;
4005     }
4006 
4007     function deleteIntValue(bytes32 record) external
4008         onlyAssociatedContract
4009     {
4010         delete IntStorage[record];
4011     }
4012 }
4013 
4014 /*
4015 -----------------------------------------------------------------
4016 FILE INFORMATION
4017 -----------------------------------------------------------------
4018 
4019 file:       FeePoolEternalStorage.sol
4020 version:    1.0
4021 author:     Clinton Ennis
4022             Jackson Chan
4023 date:       2019-04-05
4024 
4025 -----------------------------------------------------------------
4026 MODULE DESCRIPTION
4027 -----------------------------------------------------------------
4028 
4029 The FeePoolEternalStorage is for any state the FeePool contract
4030 needs to persist between upgrades to the FeePool logic.
4031 
4032 Please see EternalStorage.sol
4033 
4034 -----------------------------------------------------------------
4035 */
4036 
4037 
4038 contract FeePoolEternalStorage is EternalStorage, LimitedSetup {
4039 
4040     bytes32 constant LAST_FEE_WITHDRAWAL = "last_fee_withdrawal";
4041 
4042     /**
4043      * @dev Constructor.
4044      * @param _owner The owner of this contract.
4045      */
4046     constructor(address _owner, address _feePool)
4047         EternalStorage(_owner, _feePool)
4048         LimitedSetup(6 weeks)
4049         public
4050     {
4051     }
4052 
4053     /**
4054      * @notice Import data from FeePool.lastFeeWithdrawal
4055      * @dev Only callable by the contract owner, and only for 6 weeks after deployment.
4056      * @param accounts Array of addresses that have claimed
4057      * @param feePeriodIDs Array feePeriodIDs with the accounts last claim
4058      */
4059     function importFeeWithdrawalData(address[] accounts, uint[] feePeriodIDs)
4060         external
4061         onlyOwner
4062         onlyDuringSetup
4063     {
4064         require(accounts.length == feePeriodIDs.length, "Length mismatch");
4065 
4066         for (uint8 i = 0; i < accounts.length; i++) {
4067             this.setUIntValue(keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, accounts[i])), feePeriodIDs[i]);
4068         }
4069     }
4070 }
4071 
4072 
4073 /*
4074 -----------------------------------------------------------------
4075 FILE INFORMATION
4076 -----------------------------------------------------------------
4077 
4078 file:       DelegateApprovals.sol
4079 version:    1.0
4080 author:     Jackson Chan
4081 checked:    Clinton Ennis
4082 date:       2019-05-01
4083 
4084 -----------------------------------------------------------------
4085 MODULE DESCRIPTION
4086 -----------------------------------------------------------------
4087 
4088 The approval state contract is designed to allow a wallet to
4089 authorise another address to perform actions, on a contract,
4090 on their behalf. This could be an automated service
4091 that would help a wallet claim fees / rewards on their behalf.
4092 
4093 The concept is similar to the ERC20 interface where a wallet can
4094 approve an authorised party to spend on the authorising party's
4095 behalf in the allowance interface.
4096 
4097 Withdrawing approval sets the delegate as false instead of
4098 removing from the approvals list for auditability.
4099 
4100 This contract inherits state for upgradeability / associated
4101 contract.
4102 
4103 -----------------------------------------------------------------
4104 */
4105 
4106 
4107 contract DelegateApprovals is State {
4108 
4109     // Approvals - [authoriser][delegate]
4110     // Each authoriser can have multiple delegates
4111     mapping(address => mapping(address => bool)) public approval;
4112 
4113     /**
4114      * @dev Constructor
4115      * @param _owner The address which controls this contract.
4116      * @param _associatedContract The contract whose approval state this composes.
4117      */
4118     constructor(address _owner, address _associatedContract)
4119         State(_owner, _associatedContract)
4120         public
4121     {}
4122 
4123     function setApproval(address authoriser, address delegate)
4124         external
4125         onlyAssociatedContract
4126     {
4127         approval[authoriser][delegate] = true;
4128         emit Approval(authoriser, delegate);
4129     }
4130 
4131     function withdrawApproval(address authoriser, address delegate)
4132         external
4133         onlyAssociatedContract
4134     {
4135         delete approval[authoriser][delegate];
4136         emit WithdrawApproval(authoriser, delegate);
4137     }
4138 
4139      /* ========== EVENTS ========== */
4140 
4141     event Approval(address indexed authoriser, address delegate);
4142     event WithdrawApproval(address indexed authoriser, address delegate);
4143 }
4144 
4145 
4146 /*
4147 -----------------------------------------------------------------
4148 FILE INFORMATION
4149 -----------------------------------------------------------------
4150 
4151 file:       FeePool.sol
4152 version:    1.0
4153 author:     Kevin Brown
4154 date:       2018-10-15
4155 
4156 -----------------------------------------------------------------
4157 MODULE DESCRIPTION
4158 -----------------------------------------------------------------
4159 
4160 The FeePool is a place for users to interact with the fees that
4161 have been generated from the Synthetix system if they've helped
4162 to create the economy.
4163 
4164 Users stake Synthetix to create Synths. As Synth users transact,
4165 a small fee is deducted from exchange transactions, which collects
4166 in the fee pool. Fees are immediately converted to XDRs, a type
4167 of reserve currency similar to SDRs used by the IMF:
4168 https://www.imf.org/en/About/Factsheets/Sheets/2016/08/01/14/51/Special-Drawing-Right-SDR
4169 
4170 Users are entitled to withdraw fees from periods that they participated
4171 in fully, e.g. they have to stake before the period starts. They
4172 can withdraw fees for the last 6 periods as a single lump sum.
4173 Currently fee periods are 7 days long, meaning it's assumed
4174 users will withdraw their fees approximately once a month. Fees
4175 which are not withdrawn are redistributed to the whole pool,
4176 enabling these non-claimed fees to go back to the rest of the commmunity.
4177 
4178 Fees can be withdrawn in any synth currency.
4179 
4180 -----------------------------------------------------------------
4181 */
4182 
4183 
4184 contract FeePool is Proxyable, SelfDestructible, LimitedSetup {
4185 
4186     using SafeMath for uint;
4187     using SafeDecimalMath for uint;
4188 
4189     Synthetix public synthetix;
4190     ISynthetixState public synthetixState;
4191     ISynthetixEscrow public rewardEscrow;
4192     FeePoolEternalStorage public feePoolEternalStorage;
4193 
4194     // A percentage fee charged on each transfer.
4195     uint public transferFeeRate;
4196 
4197     // Transfer fee may not exceed 10%.
4198     uint constant public MAX_TRANSFER_FEE_RATE = SafeDecimalMath.unit() / 10;
4199 
4200     // A percentage fee charged on each exchange between currencies.
4201     uint public exchangeFeeRate;
4202 
4203     // Exchange fee may not exceed 10%.
4204     uint constant public MAX_EXCHANGE_FEE_RATE = SafeDecimalMath.unit() / 10;
4205 
4206     // The address with the authority to distribute fees.
4207     address public feeAuthority;
4208 
4209     // The address to the FeePoolState Contract.
4210     FeePoolState public feePoolState;
4211 
4212     // The address to the DelegateApproval contract.
4213     DelegateApprovals public delegates;
4214 
4215     // Where fees are pooled in XDRs.
4216     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
4217 
4218     // This struct represents the issuance activity that's happened in a fee period.
4219     struct FeePeriod {
4220         uint feePeriodId;
4221         uint startingDebtIndex;
4222         uint startTime;
4223         uint feesToDistribute;
4224         uint feesClaimed;
4225         uint rewardsToDistribute;
4226         uint rewardsClaimed;
4227     }
4228 
4229     // The last 6 fee periods are all that you can claim from.
4230     // These are stored and managed from [0], such that [0] is always
4231     // the most recent fee period, and [5] is always the oldest fee
4232     // period that users can claim for.
4233     uint8 constant public FEE_PERIOD_LENGTH = 6;
4234 
4235     FeePeriod[FEE_PERIOD_LENGTH] public recentFeePeriods;
4236 
4237     // How long a fee period lasts at a minimum. It is required for the
4238     // fee authority to roll over the periods, so they are not guaranteed
4239     // to roll over at exactly this duration, but the contract enforces
4240     // that they cannot roll over any quicker than this duration.
4241     uint public feePeriodDuration = 1 weeks;
4242     // The fee period must be between 1 day and 60 days.
4243     uint public constant MIN_FEE_PERIOD_DURATION = 1 days;
4244     uint public constant MAX_FEE_PERIOD_DURATION = 60 days;
4245 
4246     // Users receive penalties if their collateralisation ratio drifts out of our desired brackets
4247     // We precompute the brackets and penalties to save gas.
4248     uint constant TWENTY_PERCENT = (20 * SafeDecimalMath.unit()) / 100;
4249     uint constant TWENTY_TWO_PERCENT = (22 * SafeDecimalMath.unit()) / 100;
4250     uint constant TWENTY_FIVE_PERCENT = (25 * SafeDecimalMath.unit()) / 100;
4251     uint constant THIRTY_PERCENT = (30 * SafeDecimalMath.unit()) / 100;
4252     uint constant FOURTY_PERCENT = (40 * SafeDecimalMath.unit()) / 100;
4253     uint constant FIFTY_PERCENT = (50 * SafeDecimalMath.unit()) / 100;
4254     uint constant SEVENTY_FIVE_PERCENT = (75 * SafeDecimalMath.unit()) / 100;
4255     uint constant NINETY_PERCENT = (90 * SafeDecimalMath.unit()) / 100;
4256     uint constant ONE_HUNDRED_PERCENT = (100 * SafeDecimalMath.unit()) / 100;
4257 
4258     /* ========== ETERNAL STORAGE CONSTANTS ========== */
4259 
4260     bytes32 constant LAST_FEE_WITHDRAWAL = "last_fee_withdrawal";
4261 
4262     constructor(
4263         address _proxy,
4264         address _owner,
4265         Synthetix _synthetix,
4266         FeePoolState _feePoolState,
4267         FeePoolEternalStorage _feePoolEternalStorage,
4268         ISynthetixState _synthetixState,
4269         ISynthetixEscrow _rewardEscrow,
4270         address _feeAuthority,
4271         uint _transferFeeRate,
4272         uint _exchangeFeeRate)
4273         SelfDestructible(_owner)
4274         Proxyable(_proxy, _owner)
4275         LimitedSetup(3 weeks)
4276         public
4277     {
4278         // Constructed fee rates should respect the maximum fee rates.
4279         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
4280         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Constructed exchange fee rate should respect the maximum fee rate");
4281 
4282         synthetix = _synthetix;
4283         feePoolState = _feePoolState;
4284         feePoolEternalStorage = _feePoolEternalStorage;
4285         rewardEscrow = _rewardEscrow;
4286         synthetixState = _synthetixState;
4287         feeAuthority = _feeAuthority;
4288         transferFeeRate = _transferFeeRate;
4289         exchangeFeeRate = _exchangeFeeRate;
4290 
4291         // Set our initial fee period
4292         recentFeePeriods[0].feePeriodId = 1;
4293         recentFeePeriods[0].startTime = now;
4294     }
4295 
4296     /**
4297      * @notice Logs an accounts issuance data per fee period
4298      * @param account Message.Senders account address
4299      * @param debtRatio Debt percentage this account has locked after minting or burning their synth
4300      * @param debtEntryIndex The index in the global debt ledger. synthetix.synthetixState().issuanceData(account)
4301      * @dev onlySynthetix to call me on synthetix.issue() & synthetix.burn() calls to store the locked SNX
4302      * per fee period so we know to allocate the correct proportions of fees and rewards per period
4303      */
4304     function appendAccountIssuanceRecord(address account, uint debtRatio, uint debtEntryIndex)
4305         external
4306         onlySynthetix
4307     {
4308         feePoolState.appendAccountIssuanceRecord(account, debtRatio, debtEntryIndex, recentFeePeriods[0].startingDebtIndex);
4309 
4310         emitIssuanceDebtRatioEntry(account, debtRatio, debtEntryIndex, recentFeePeriods[0].startingDebtIndex);
4311     }
4312 
4313     /**
4314      * @notice Set the exchange fee, anywhere within the range 0-10%.
4315      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
4316      */
4317     function setExchangeFeeRate(uint _exchangeFeeRate)
4318         external
4319         optionalProxy_onlyOwner
4320     {
4321         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Exchange fee rate must be below MAX_EXCHANGE_FEE_RATE");
4322 
4323         exchangeFeeRate = _exchangeFeeRate;
4324 
4325         emitExchangeFeeUpdated(_exchangeFeeRate);
4326     }
4327 
4328     /**
4329      * @notice Set the transfer fee, anywhere within the range 0-10%.
4330      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
4331      */
4332     function setTransferFeeRate(uint _transferFeeRate)
4333         external
4334         optionalProxy_onlyOwner
4335     {
4336         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
4337 
4338         transferFeeRate = _transferFeeRate;
4339 
4340         emitTransferFeeUpdated(_transferFeeRate);
4341     }
4342 
4343     /**
4344      * @notice Set the address of the user/contract responsible for collecting or
4345      * distributing fees.
4346      */
4347     function setFeeAuthority(address _feeAuthority)
4348         external
4349         optionalProxy_onlyOwner
4350     {
4351         feeAuthority = _feeAuthority;
4352 
4353         emitFeeAuthorityUpdated(_feeAuthority);
4354     }
4355 
4356     /**
4357      * @notice Set the address of the contract for feePool state
4358      */
4359     function setFeePoolState(FeePoolState _feePoolState)
4360         external
4361         optionalProxy_onlyOwner
4362     {
4363         feePoolState = _feePoolState;
4364 
4365         emitFeePoolStateUpdated(_feePoolState);
4366     }
4367 
4368     /**
4369      * @notice Set the address of the contract for delegate approvals
4370      */
4371     function setDelegateApprovals(DelegateApprovals _delegates)
4372         external
4373         optionalProxy_onlyOwner
4374     {
4375         delegates = _delegates;
4376 
4377         emitDelegateApprovalsUpdated(_delegates);
4378     }
4379 
4380     /**
4381      * @notice Set the fee period duration
4382      */
4383     function setFeePeriodDuration(uint _feePeriodDuration)
4384         external
4385         optionalProxy_onlyOwner
4386     {
4387         require(_feePeriodDuration >= MIN_FEE_PERIOD_DURATION, "New fee period cannot be less than minimum fee period duration");
4388         require(_feePeriodDuration <= MAX_FEE_PERIOD_DURATION, "New fee period cannot be greater than maximum fee period duration");
4389 
4390         feePeriodDuration = _feePeriodDuration;
4391 
4392         emitFeePeriodDurationUpdated(_feePeriodDuration);
4393     }
4394 
4395     /**
4396      * @notice Set the synthetix contract
4397      */
4398     function setSynthetix(Synthetix _synthetix)
4399         external
4400         optionalProxy_onlyOwner
4401     {
4402         require(address(_synthetix) != address(0), "New Synthetix must be non-zero");
4403 
4404         synthetix = _synthetix;
4405 
4406         emitSynthetixUpdated(_synthetix);
4407     }
4408 
4409     /**
4410      * @notice The Synthetix contract informs us when fees are paid.
4411      */
4412     function feePaid(bytes4 currencyKey, uint amount)
4413         external
4414         onlySynthetix
4415     {
4416         uint xdrAmount;
4417 
4418         if (currencyKey != "XDR") {
4419             xdrAmount = synthetix.effectiveValue(currencyKey, amount, "XDR");
4420         } else {
4421             xdrAmount = amount;
4422         }
4423 
4424         // Keep track of in XDRs in our fee pool.
4425         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.add(xdrAmount);
4426     }
4427 
4428     /**
4429      * @notice The Synthetix contract informs us when SNX Rewards are minted to RewardEscrow to be claimed.
4430      */
4431     function rewardsMinted(uint amount)
4432         external
4433         onlySynthetix
4434     {
4435         // Add the newly minted SNX rewards on top of the rolling unclaimed amount
4436         recentFeePeriods[0].rewardsToDistribute = recentFeePeriods[0].rewardsToDistribute.add(amount);
4437     }
4438 
4439     /**
4440      * @notice Close the current fee period and start a new one. Only callable by the fee authority.
4441      */
4442     function closeCurrentFeePeriod()
4443         external
4444         optionalProxy_onlyFeeAuthority
4445     {
4446         require(recentFeePeriods[0].startTime <= (now - feePeriodDuration), "It is too early to close the current fee period");
4447 
4448         FeePeriod memory secondLastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 2];
4449         FeePeriod memory lastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 1];
4450 
4451         // Any unclaimed fees from the last period in the array roll back one period.
4452         // Because of the subtraction here, they're effectively proportionally redistributed to those who
4453         // have already claimed from the old period, available in the new period.
4454         // The subtraction is important so we don't create a ticking time bomb of an ever growing
4455         // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
4456         recentFeePeriods[FEE_PERIOD_LENGTH - 2].feesToDistribute = lastFeePeriod.feesToDistribute
4457             .sub(lastFeePeriod.feesClaimed)
4458             .add(secondLastFeePeriod.feesToDistribute);
4459         recentFeePeriods[FEE_PERIOD_LENGTH - 2].rewardsToDistribute = lastFeePeriod.rewardsToDistribute
4460             .sub(lastFeePeriod.rewardsClaimed)
4461             .add(secondLastFeePeriod.rewardsToDistribute);
4462 
4463         // Shift the previous fee periods across to make room for the new one.
4464         // Condition checks for overflow when uint subtracts one from zero
4465         // Could be written with int instead of uint, but then we have to convert everywhere
4466         // so it felt better from a gas perspective to just change the condition to check
4467         // for overflow after subtracting one from zero.
4468         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
4469             uint next = i + 1;
4470             recentFeePeriods[next].feePeriodId = recentFeePeriods[i].feePeriodId;
4471             recentFeePeriods[next].startingDebtIndex = recentFeePeriods[i].startingDebtIndex;
4472             recentFeePeriods[next].startTime = recentFeePeriods[i].startTime;
4473             recentFeePeriods[next].feesToDistribute = recentFeePeriods[i].feesToDistribute;
4474             recentFeePeriods[next].feesClaimed = recentFeePeriods[i].feesClaimed;
4475             recentFeePeriods[next].rewardsToDistribute = recentFeePeriods[i].rewardsToDistribute;
4476             recentFeePeriods[next].rewardsClaimed = recentFeePeriods[i].rewardsClaimed;
4477         }
4478 
4479         // Clear the first element of the array to make sure we don't have any stale values.
4480         delete recentFeePeriods[0];
4481 
4482         // Open up the new fee period. Take a snapshot of the total value of the system.
4483         // Increment periodId from the recent closed period feePeriodId
4484         recentFeePeriods[0].feePeriodId = recentFeePeriods[1].feePeriodId.add(1);
4485         recentFeePeriods[0].startingDebtIndex = synthetixState.debtLedgerLength();
4486         recentFeePeriods[0].startTime = now;
4487 
4488         emitFeePeriodClosed(recentFeePeriods[1].feePeriodId);
4489     }
4490 
4491     /**
4492     * @notice Claim fees for last period when available or not already withdrawn.
4493     * @param currencyKey Synth currency you wish to receive the fees in.
4494     */
4495     function claimFees(bytes4 currencyKey)
4496         external
4497         optionalProxy
4498         returns (bool)
4499     {
4500         return _claimFees(messageSender, currencyKey);
4501     }
4502 
4503     function claimOnBehalf(address claimingForAddress, bytes4 currencyKey)
4504         external
4505         optionalProxy
4506         returns (bool)
4507     {
4508         require(delegates.approval(claimingForAddress, messageSender), "Not approved to claim on behalf this address");
4509 
4510         return _claimFees(claimingForAddress, currencyKey);
4511     }
4512 
4513     function _claimFees(address claimingAddress, bytes4 currencyKey)
4514         internal
4515         returns (bool)
4516     {
4517         uint availableFees;
4518         uint availableRewards;
4519         (availableFees, availableRewards) = feesAvailable(claimingAddress, "XDR");
4520 
4521         require(availableFees > 0 || availableRewards > 0, "No fees or rewards available for period, or fees already claimed");
4522 
4523         _setLastFeeWithdrawal(claimingAddress, recentFeePeriods[1].feePeriodId);
4524 
4525         if (availableFees > 0) {
4526             // Record the fee payment in our recentFeePeriods
4527             uint feesPaid = _recordFeePayment(availableFees);
4528 
4529             // Send them their fees
4530             _payFees(claimingAddress, feesPaid, currencyKey);
4531 
4532             emitFeesClaimed(claimingAddress, feesPaid);
4533         }
4534 
4535         if (availableRewards > 0) {
4536             // Record the reward payment in our recentFeePeriods
4537             uint rewardPaid = _recordRewardPayment(availableRewards);
4538 
4539             // Send them their rewards
4540             _payRewards(claimingAddress, rewardPaid);
4541 
4542             emitRewardsClaimed(claimingAddress, rewardPaid);
4543         }
4544 
4545         return true;
4546     }
4547 
4548     function importFeePeriod(
4549         uint feePeriodIndex, uint feePeriodId, uint startingDebtIndex, uint startTime,
4550         uint feesToDistribute, uint feesClaimed, uint rewardsToDistribute, uint rewardsClaimed)
4551         public
4552         optionalProxy_onlyOwner
4553         onlyDuringSetup
4554     {
4555         recentFeePeriods[feePeriodIndex].feePeriodId = feePeriodId;
4556         recentFeePeriods[feePeriodIndex].startingDebtIndex = startingDebtIndex;
4557         recentFeePeriods[feePeriodIndex].startTime = startTime;
4558         recentFeePeriods[feePeriodIndex].feesToDistribute = feesToDistribute;
4559         recentFeePeriods[feePeriodIndex].feesClaimed = feesClaimed;
4560         recentFeePeriods[feePeriodIndex].rewardsToDistribute = rewardsToDistribute;
4561         recentFeePeriods[feePeriodIndex].rewardsClaimed = rewardsClaimed;
4562     }
4563 
4564     function approveClaimOnBehalf(address account)
4565         public
4566         optionalProxy
4567     {
4568         require(delegates != address(0), "Delegates Approval destination missing");
4569         require(account != address(0), "Can't delegate to address(0)");
4570         delegates.setApproval(messageSender, account);
4571     }
4572 
4573     function removeClaimOnBehalf(address account)
4574         public
4575         optionalProxy
4576     {
4577         require(delegates != address(0), "Delegates Approval destination missing");
4578         delegates.withdrawApproval(messageSender, account);
4579     }
4580 
4581     /**
4582      * @notice Record the fee payment in our recentFeePeriods.
4583      * @param xdrAmount The amount of fees priced in XDRs.
4584      */
4585     function _recordFeePayment(uint xdrAmount)
4586         internal
4587         returns (uint)
4588     {
4589         // Don't assign to the parameter
4590         uint remainingToAllocate = xdrAmount;
4591 
4592         uint feesPaid;
4593         // Start at the oldest period and record the amount, moving to newer periods
4594         // until we've exhausted the amount.
4595         // The condition checks for overflow because we're going to 0 with an unsigned int.
4596         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
4597             uint delta = recentFeePeriods[i].feesToDistribute.sub(recentFeePeriods[i].feesClaimed);
4598 
4599             if (delta > 0) {
4600                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
4601                 uint amountInPeriod = delta < remainingToAllocate ? delta : remainingToAllocate;
4602 
4603                 recentFeePeriods[i].feesClaimed = recentFeePeriods[i].feesClaimed.add(amountInPeriod);
4604                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
4605                 feesPaid = feesPaid.add(amountInPeriod);
4606 
4607                 // No need to continue iterating if we've recorded the whole amount;
4608                 if (remainingToAllocate == 0) return feesPaid;
4609 
4610                 // We've exhausted feePeriods to distribute and no fees remain in last period
4611                 // User last to claim would in this scenario have their remainder slashed
4612                 if (i == 0 && remainingToAllocate > 0) {
4613                     remainingToAllocate = 0;
4614                 }
4615             }
4616         }
4617 
4618         return feesPaid;
4619     }
4620 
4621     /**
4622      * @notice Record the reward payment in our recentFeePeriods.
4623      * @param snxAmount The amount of SNX tokens.
4624      */
4625     function _recordRewardPayment(uint snxAmount)
4626         internal
4627         returns (uint)
4628     {
4629         // Don't assign to the parameter
4630         uint remainingToAllocate = snxAmount;
4631 
4632         uint rewardPaid;
4633 
4634         // Start at the oldest period and record the amount, moving to newer periods
4635         // until we've exhausted the amount.
4636         // The condition checks for overflow because we're going to 0 with an unsigned int.
4637         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
4638             uint toDistribute = recentFeePeriods[i].rewardsToDistribute.sub(recentFeePeriods[i].rewardsClaimed);
4639 
4640             if (toDistribute > 0) {
4641                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
4642                 uint amountInPeriod = toDistribute < remainingToAllocate ? toDistribute : remainingToAllocate;
4643 
4644                 recentFeePeriods[i].rewardsClaimed = recentFeePeriods[i].rewardsClaimed.add(amountInPeriod);
4645                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
4646                 rewardPaid = rewardPaid.add(amountInPeriod);
4647 
4648                 // No need to continue iterating if we've recorded the whole amount;
4649                 if (remainingToAllocate == 0) return rewardPaid;
4650 
4651                 // We've exhausted feePeriods to distribute and no rewards remain in last period
4652                 // User last to claim would in this scenario have their remainder slashed
4653                 // due to rounding up of PreciseDecimal
4654                 if (i == 0 && remainingToAllocate > 0) {
4655                     remainingToAllocate = 0;
4656                 }
4657             }
4658         }
4659         return rewardPaid;
4660     }
4661 
4662     /**
4663     * @notice Send the fees to claiming address.
4664     * @param account The address to send the fees to.
4665     * @param xdrAmount The amount of fees priced in XDRs.
4666     * @param destinationCurrencyKey The synth currency the user wishes to receive their fees in (convert to this currency).
4667     */
4668     function _payFees(address account, uint xdrAmount, bytes4 destinationCurrencyKey)
4669         internal
4670         notFeeAddress(account)
4671     {
4672         require(account != address(0), "Account can't be 0");
4673         require(account != address(this), "Can't send fees to fee pool");
4674         require(account != address(proxy), "Can't send fees to proxy");
4675         require(account != address(synthetix), "Can't send fees to synthetix");
4676 
4677         Synth xdrSynth = synthetix.synths("XDR");
4678         Synth destinationSynth = synthetix.synths(destinationCurrencyKey);
4679 
4680         // Note: We don't need to check the fee pool balance as the burn() below will do a safe subtraction which requires
4681         // the subtraction to not overflow, which would happen if the balance is not sufficient.
4682 
4683         // Burn the source amount
4684         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
4685 
4686         // How much should they get in the destination currency?
4687         uint destinationAmount = synthetix.effectiveValue("XDR", xdrAmount, destinationCurrencyKey);
4688 
4689         // There's no fee on withdrawing fees, as that'd be way too meta.
4690 
4691         // Mint their new synths
4692         destinationSynth.issue(account, destinationAmount);
4693 
4694         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
4695 
4696         // Call the ERC223 transfer callback if needed
4697         destinationSynth.triggerTokenFallbackIfNeeded(FEE_ADDRESS, account, destinationAmount);
4698     }
4699 
4700 
4701     function burnFees(uint xdrAmount)
4702         external
4703         optionalProxy_onlyOwner
4704     {
4705         Synth xdrSynth = synthetix.synths("XDR");
4706         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
4707         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.sub(xdrAmount);
4708     }
4709 
4710     /**
4711     * @notice Send the rewards to claiming address - will be locked in rewardEscrow.
4712     * @param account The address to send the fees to.
4713     * @param snxAmount The amount of SNX.
4714     */
4715     function _payRewards(address account, uint snxAmount)
4716         internal
4717         notFeeAddress(account)
4718     {
4719         require(account != address(0), "Account can't be 0");
4720         require(account != address(this), "Can't send rewards to fee pool");
4721         require(account != address(proxy), "Can't send rewards to proxy");
4722         require(account != address(synthetix), "Can't send rewards to synthetix");
4723 
4724         // Record vesting entry for claiming address and amount
4725         // SNX already minted to rewardEscrow balance
4726         rewardEscrow.appendVestingEntry(account, snxAmount);
4727     }
4728 
4729     /**
4730      * @notice Calculate the Fee charged on top of a value being sent
4731      * @return Return the fee charged
4732      */
4733     function transferFeeIncurred(uint value)
4734         public
4735         view
4736         returns (uint)
4737     {
4738         return value.multiplyDecimal(transferFeeRate);
4739 
4740         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
4741         // This is on the basis that transfers less than this value will result in a nil fee.
4742         // Probably too insignificant to worry about, but the following code will achieve it.
4743         //      if (fee == 0 && transferFeeRate != 0) {
4744         //          return _value;
4745         //      }
4746         //      return fee;
4747     }
4748 
4749     /**
4750      * @notice The value that you would need to send so that the recipient receives
4751      * a specified value.
4752      * @param value The value you want the recipient to receive
4753      */
4754     function transferredAmountToReceive(uint value)
4755         external
4756         view
4757         returns (uint)
4758     {
4759         return value.add(transferFeeIncurred(value));
4760     }
4761 
4762     /**
4763      * @notice The amount the recipient will receive if you send a certain number of tokens.
4764      * @param value The amount of tokens you intend to send.
4765      */
4766     function amountReceivedFromTransfer(uint value)
4767         external
4768         view
4769         returns (uint)
4770     {
4771         return value.divideDecimal(transferFeeRate.add(SafeDecimalMath.unit()));
4772     }
4773 
4774     /**
4775      * @notice Calculate the fee charged on top of a value being sent via an exchange
4776      * @return Return the fee charged
4777      */
4778     function exchangeFeeIncurred(uint value)
4779         public
4780         view
4781         returns (uint)
4782     {
4783         return value.multiplyDecimal(exchangeFeeRate);
4784 
4785         // Exchanges less than the reciprocal of exchangeFeeRate should be completely eaten up by fees.
4786         // This is on the basis that exchanges less than this value will result in a nil fee.
4787         // Probably too insignificant to worry about, but the following code will achieve it.
4788         //      if (fee == 0 && exchangeFeeRate != 0) {
4789         //          return _value;
4790         //      }
4791         //      return fee;
4792     }
4793 
4794     /**
4795      * @notice The value that you would need to get after currency exchange so that the recipient receives
4796      * a specified value.
4797      * @param value The value you want the recipient to receive
4798      */
4799     function exchangedAmountToReceive(uint value)
4800         external
4801         view
4802         returns (uint)
4803     {
4804         return value.add(exchangeFeeIncurred(value));
4805     }
4806 
4807     /**
4808      * @notice The amount the recipient will receive if you are performing an exchange and the
4809      * destination currency will be worth a certain number of tokens.
4810      * @param value The amount of destination currency tokens they received after the exchange.
4811      */
4812     function amountReceivedFromExchange(uint value)
4813         external
4814         view
4815         returns (uint)
4816     {
4817         return value.multiplyDecimal(SafeDecimalMath.unit().sub(exchangeFeeRate));
4818     }
4819 
4820     /**
4821      * @notice The total fees available in the system to be withdrawn, priced in currencyKey currency
4822      * @param currencyKey The currency you want to price the fees in
4823      */
4824     function totalFeesAvailable(bytes4 currencyKey)
4825         external
4826         view
4827         returns (uint)
4828     {
4829         uint totalFees = 0;
4830 
4831         // Fees in fee period [0] are not yet available for withdrawal
4832         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
4833             totalFees = totalFees.add(recentFeePeriods[i].feesToDistribute);
4834             totalFees = totalFees.sub(recentFeePeriods[i].feesClaimed);
4835         }
4836 
4837         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
4838     }
4839 
4840     /**
4841      * @notice The total SNX rewards available in the system to be withdrawn
4842      */
4843     function totalRewardsAvailable()
4844         external
4845         view
4846         returns (uint)
4847     {
4848         uint totalRewards = 0;
4849 
4850         // Rewards in fee period [0] are not yet available for withdrawal
4851         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
4852             totalRewards = totalRewards.add(recentFeePeriods[i].rewardsToDistribute);
4853             totalRewards = totalRewards.sub(recentFeePeriods[i].rewardsClaimed);
4854         }
4855 
4856         return totalRewards;
4857     }
4858 
4859     /**
4860      * @notice The fees available to be withdrawn by a specific account, priced in currencyKey currency
4861      * @dev Returns two amounts, one for fees and one for SNX rewards
4862      * @param currencyKey The currency you want to price the fees in
4863      */
4864     function feesAvailable(address account, bytes4 currencyKey)
4865         public
4866         view
4867         returns (uint, uint)
4868     {
4869         // Add up the fees
4870         uint[2][FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);
4871 
4872         uint totalFees = 0;
4873         uint totalRewards = 0;
4874 
4875         // Fees & Rewards in fee period [0] are not yet available for withdrawal
4876         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
4877             totalFees = totalFees.add(userFees[i][0]);
4878             totalRewards = totalRewards.add(userFees[i][1]);
4879         }
4880 
4881         // And convert totalFees to their desired currency
4882         // Return totalRewards as is in SNX amount
4883         return (
4884             synthetix.effectiveValue("XDR", totalFees, currencyKey),
4885             totalRewards
4886         );
4887     }
4888 
4889     /**
4890      * @notice The penalty a particular address would incur if its fees were withdrawn right now
4891      * @param account The address you want to query the penalty for
4892      */
4893     function currentPenalty(address account)
4894         public
4895         view
4896         returns (uint)
4897     {
4898         uint ratio = synthetix.collateralisationRatio(account);
4899 
4900         // Users receive a different amount of fees depending on how their collateralisation ratio looks right now.
4901         //  0% < 20% (∞ - 500%):    Fee is calculated based on percentage of economy issued.
4902         // 20% - 22% (500% - 454%):  0% reduction in fees
4903         // 22% - 30% (454% - 333%): 25% reduction in fees
4904         // 30% - 40% (333% - 250%): 50% reduction in fees
4905         // 40% - 50% (250% - 200%): 75% reduction in fees
4906         //     > 50% (200% - 100%): 90% reduction in fees
4907         //     > 100%(100% -   0%):100% reduction in fees
4908         if (ratio <= TWENTY_PERCENT) {
4909             return 0;
4910         } else if (ratio > TWENTY_PERCENT && ratio <= TWENTY_TWO_PERCENT) {
4911             return 0;
4912         } else if (ratio > TWENTY_TWO_PERCENT && ratio <= THIRTY_PERCENT) {
4913             return TWENTY_FIVE_PERCENT;
4914         } else if (ratio > THIRTY_PERCENT && ratio <= FOURTY_PERCENT) {
4915             return FIFTY_PERCENT;
4916         } else if (ratio > FOURTY_PERCENT && ratio <= FIFTY_PERCENT) {
4917             return SEVENTY_FIVE_PERCENT;
4918         } else if (ratio > FIFTY_PERCENT && ratio <= ONE_HUNDRED_PERCENT) {
4919             return NINETY_PERCENT;
4920         }
4921         return ONE_HUNDRED_PERCENT;
4922     }
4923 
4924     /**
4925      * @notice Calculates fees by period for an account, priced in XDRs
4926      * @param account The address you want to query the fees by penalty for
4927      */
4928     function feesByPeriod(address account)
4929         public
4930         view
4931         returns (uint[2][FEE_PERIOD_LENGTH] memory results)
4932     {
4933         // What's the user's debt entry index and the debt they owe to the system at current feePeriod
4934         uint userOwnershipPercentage;
4935         uint debtEntryIndex;
4936         (userOwnershipPercentage, debtEntryIndex) = feePoolState.getAccountsDebtEntry(account, 0);
4937 
4938         // If they don't have any debt ownership and they haven't minted, they don't have any fees
4939         if (debtEntryIndex == 0 && userOwnershipPercentage == 0) return;
4940 
4941         // If there are no XDR synths, then they don't have any fees
4942         if (synthetix.totalIssuedSynths("XDR") == 0) return;
4943 
4944         uint penalty = currentPenalty(account);
4945 
4946         // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
4947         // fees owing for, so we need to report on it anyway.
4948         uint feesFromPeriod;
4949         uint rewardsFromPeriod;
4950         (feesFromPeriod, rewardsFromPeriod) = _feesAndRewardsFromPeriod(0, userOwnershipPercentage, debtEntryIndex, penalty);
4951 
4952         results[0][0] = feesFromPeriod;
4953         results[0][1] = rewardsFromPeriod;
4954 
4955         // Go through our fee periods from the oldest feePeriod[FEE_PERIOD_LENGTH - 1] and figure out what we owe them.
4956         // Condition checks for periods > 0
4957         for (uint i = FEE_PERIOD_LENGTH - 1; i > 0; i--) {
4958             uint next = i - 1;
4959             FeePeriod memory nextPeriod = recentFeePeriods[next];
4960 
4961             // We can skip period if no debt minted during period
4962             if (nextPeriod.startingDebtIndex > 0 &&
4963             getLastFeeWithdrawal(account) < recentFeePeriods[i].feePeriodId) {
4964 
4965                 // We calculate a feePeriod's closingDebtIndex by looking at the next feePeriod's startingDebtIndex
4966                 // we can use the most recent issuanceData[0] for the current feePeriod
4967                 // else find the applicableIssuanceData for the feePeriod based on the StartingDebtIndex of the period
4968                 uint closingDebtIndex = nextPeriod.startingDebtIndex.sub(1);
4969 
4970                 // Gas optimisation - to reuse debtEntryIndex if found new applicable one
4971                 // if applicable is 0,0 (none found) we keep most recent one from issuanceData[0]
4972                 // return if userOwnershipPercentage = 0)
4973                 (userOwnershipPercentage, debtEntryIndex) = feePoolState.applicableIssuanceData(account, closingDebtIndex);
4974 
4975                 (feesFromPeriod, rewardsFromPeriod) = _feesAndRewardsFromPeriod(i, userOwnershipPercentage, debtEntryIndex, penalty);
4976 
4977                 results[i][0] = feesFromPeriod;
4978                 results[i][1] = rewardsFromPeriod;
4979             }
4980         }
4981     }
4982 
4983     /**
4984      * @notice ownershipPercentage is a high precision decimals uint based on
4985      * wallet's debtPercentage. Gives a precise amount of the feesToDistribute
4986      * for fees in the period. Precision factor is removed before results are
4987      * returned.
4988      */
4989     function _feesAndRewardsFromPeriod(uint period, uint ownershipPercentage, uint debtEntryIndex, uint penalty)
4990         internal
4991         returns (uint, uint)
4992     {
4993         // If it's zero, they haven't issued, and they have no fees OR rewards.
4994         if (ownershipPercentage == 0) return (0, 0);
4995 
4996         uint debtOwnershipForPeriod = ownershipPercentage;
4997 
4998         // If period has closed we want to calculate debtPercentage for the period
4999         if (period > 0) {
5000             uint closingDebtIndex = recentFeePeriods[period - 1].startingDebtIndex.sub(1);
5001             debtOwnershipForPeriod = _effectiveDebtRatioForPeriod(closingDebtIndex, ownershipPercentage, debtEntryIndex);
5002         }
5003 
5004         // Calculate their percentage of the fees / rewards in this period
5005         // This is a high precision integer.
5006         uint feesFromPeriodWithoutPenalty = recentFeePeriods[period].feesToDistribute
5007             .multiplyDecimal(debtOwnershipForPeriod);
5008 
5009         uint rewardsFromPeriodWithoutPenalty = recentFeePeriods[period].rewardsToDistribute
5010             .multiplyDecimal(debtOwnershipForPeriod);
5011 
5012         // Less their penalty if they have one.
5013         uint feesFromPeriod = feesFromPeriodWithoutPenalty.sub(feesFromPeriodWithoutPenalty.multiplyDecimal(penalty));
5014 
5015         uint rewardsFromPeriod = rewardsFromPeriodWithoutPenalty.sub(rewardsFromPeriodWithoutPenalty.multiplyDecimal(penalty));
5016 
5017         return (
5018             feesFromPeriod.preciseDecimalToDecimal(),
5019             rewardsFromPeriod.preciseDecimalToDecimal()
5020         );
5021     }
5022 
5023     function _effectiveDebtRatioForPeriod(uint closingDebtIndex, uint ownershipPercentage, uint debtEntryIndex)
5024         internal
5025         view
5026         returns (uint)
5027     {
5028         // Condition to check if debtLedger[] has value otherwise return 0
5029         if (closingDebtIndex > synthetixState.debtLedgerLength()) return 0;
5030 
5031         // Figure out their global debt percentage delta at end of fee Period.
5032         // This is a high precision integer.
5033         uint feePeriodDebtOwnership = synthetixState.debtLedger(closingDebtIndex)
5034             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
5035             .multiplyDecimalRoundPrecise(ownershipPercentage);
5036 
5037         return feePeriodDebtOwnership;
5038     }
5039 
5040     function effectiveDebtRatioForPeriod(address account, uint period)
5041         external
5042         view
5043         returns (uint)
5044     {
5045         require(period != 0, "Current period has not closed yet");
5046         require(period < FEE_PERIOD_LENGTH, "Period exceeds the FEE_PERIOD_LENGTH");
5047 
5048         // No debt minted during period as next period starts at 0
5049         if (recentFeePeriods[period - 1].startingDebtIndex == 0) return;
5050 
5051         uint closingDebtIndex = recentFeePeriods[period - 1].startingDebtIndex.sub(1);
5052 
5053         uint ownershipPercentage;
5054         uint debtEntryIndex;
5055         (ownershipPercentage, debtEntryIndex) = feePoolState.applicableIssuanceData(account, closingDebtIndex);
5056 
5057         // internal function will check closingDebtIndex has corresponding debtLedger entry
5058         return _effectiveDebtRatioForPeriod(closingDebtIndex, ownershipPercentage, debtEntryIndex);
5059     }
5060 
5061     /**
5062      * @notice Get the feePeriodID of the last claim this account made
5063      * @param _claimingAddress account to check the last fee period ID claim for
5064      * @return uint of the feePeriodID this account last claimed
5065      */
5066     function getLastFeeWithdrawal(address _claimingAddress)
5067         public
5068         view
5069         returns (uint)
5070     {
5071         return feePoolEternalStorage.getUIntValue(keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, _claimingAddress)));
5072     }
5073 
5074     /**
5075      * @notice Set the feePeriodID of the last claim this account made
5076      * @param _claimingAddress account to set the last feePeriodID claim for
5077      * @param _feePeriodID the feePeriodID this account claimed fees for
5078      */
5079     function _setLastFeeWithdrawal(address _claimingAddress, uint _feePeriodID)
5080         internal
5081     {
5082         feePoolEternalStorage.setUIntValue(keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, _claimingAddress)), _feePeriodID);
5083     }
5084 
5085     /* ========== Modifiers ========== */
5086 
5087     modifier optionalProxy_onlyFeeAuthority
5088     {
5089         if (Proxy(msg.sender) != proxy) {
5090             messageSender = msg.sender;
5091         }
5092         require(msg.sender == feeAuthority, "Only the fee authority can perform this action");
5093         _;
5094     }
5095 
5096     modifier onlySynthetix
5097     {
5098         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
5099         _;
5100     }
5101 
5102     modifier notFeeAddress(address account) {
5103         require(account != FEE_ADDRESS, "Fee address not allowed");
5104         _;
5105     }
5106 
5107     /* ========== Events ========== */
5108 
5109     event IssuanceDebtRatioEntry(address indexed account, uint debtRatio, uint debtEntryIndex, uint feePeriodStartingDebtIndex);
5110     bytes32 constant ISSUANCEDEBTRATIOENTRY_SIG = keccak256("IssuanceDebtRatioEntry(address,uint256,uint256,uint256)");
5111     function emitIssuanceDebtRatioEntry(address account, uint debtRatio, uint debtEntryIndex, uint feePeriodStartingDebtIndex) internal {
5112         proxy._emit(abi.encode(debtRatio, debtEntryIndex, feePeriodStartingDebtIndex), 2, ISSUANCEDEBTRATIOENTRY_SIG, bytes32(account), 0, 0);
5113     }
5114 
5115     event TransferFeeUpdated(uint newFeeRate);
5116     bytes32 constant TRANSFERFEEUPDATED_SIG = keccak256("TransferFeeUpdated(uint256)");
5117     function emitTransferFeeUpdated(uint newFeeRate) internal {
5118         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEEUPDATED_SIG, 0, 0, 0);
5119     }
5120 
5121     event ExchangeFeeUpdated(uint newFeeRate);
5122     bytes32 constant EXCHANGEFEEUPDATED_SIG = keccak256("ExchangeFeeUpdated(uint256)");
5123     function emitExchangeFeeUpdated(uint newFeeRate) internal {
5124         proxy._emit(abi.encode(newFeeRate), 1, EXCHANGEFEEUPDATED_SIG, 0, 0, 0);
5125     }
5126 
5127     event FeePeriodDurationUpdated(uint newFeePeriodDuration);
5128     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
5129     function emitFeePeriodDurationUpdated(uint newFeePeriodDuration) internal {
5130         proxy._emit(abi.encode(newFeePeriodDuration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
5131     }
5132 
5133     event FeeAuthorityUpdated(address newFeeAuthority);
5134     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
5135     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
5136         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
5137     }
5138 
5139     event FeePoolStateUpdated(address newFeePoolState);
5140     bytes32 constant FEEPOOLSTATEUPDATED_SIG = keccak256("FeePoolStateUpdated(address)");
5141     function emitFeePoolStateUpdated(address newFeePoolState) internal {
5142         proxy._emit(abi.encode(newFeePoolState), 1, FEEPOOLSTATEUPDATED_SIG, 0, 0, 0);
5143     }
5144 
5145     event DelegateApprovalsUpdated(address newDelegateApprovals);
5146     bytes32 constant DELEGATEAPPROVALSUPDATED_SIG = keccak256("DelegateApprovalsUpdated(address)");
5147     function emitDelegateApprovalsUpdated(address newDelegateApprovals) internal {
5148         proxy._emit(abi.encode(newDelegateApprovals), 1, DELEGATEAPPROVALSUPDATED_SIG, 0, 0, 0);
5149     }
5150 
5151     event FeePeriodClosed(uint feePeriodId);
5152     bytes32 constant FEEPERIODCLOSED_SIG = keccak256("FeePeriodClosed(uint256)");
5153     function emitFeePeriodClosed(uint feePeriodId) internal {
5154         proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
5155     }
5156 
5157     event FeesClaimed(address account, uint xdrAmount);
5158     bytes32 constant FEESCLAIMED_SIG = keccak256("FeesClaimed(address,uint256)");
5159     function emitFeesClaimed(address account, uint xdrAmount) internal {
5160         proxy._emit(abi.encode(account, xdrAmount), 1, FEESCLAIMED_SIG, 0, 0, 0);
5161     }
5162 
5163     event RewardsClaimed(address account, uint snxAmount);
5164     bytes32 constant REWARDSCLAIMED_SIG = keccak256("RewardsClaimed(address,uint256)");
5165     function emitRewardsClaimed(address account, uint snxAmount) internal {
5166         proxy._emit(abi.encode(account, snxAmount), 1, REWARDSCLAIMED_SIG, 0, 0, 0);
5167     }
5168 
5169     event SynthetixUpdated(address newSynthetix);
5170     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
5171     function emitSynthetixUpdated(address newSynthetix) internal {
5172         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
5173     }
5174 }