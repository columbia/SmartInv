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
1205 file:       Synth.sol
1206 version:    2.0
1207 author:     Kevin Brown
1208 date:       2018-09-13
1209 
1210 -----------------------------------------------------------------
1211 MODULE DESCRIPTION
1212 -----------------------------------------------------------------
1213 
1214 Synthetix-backed stablecoin contract.
1215 
1216 This contract issues synths, which are tokens that mirror various
1217 flavours of fiat currency.
1218 
1219 Synths are issuable by Synthetix Network Token (SNX) holders who 
1220 have to lock up some value of their SNX to issue S * Cmax synths. 
1221 Where Cmax issome value less than 1.
1222 
1223 A configurable fee is charged on synth transfers and deposited
1224 into a common pot, which Synthetix holders may withdraw from once
1225 per fee period.
1226 
1227 -----------------------------------------------------------------
1228 */
1229 
1230 
1231 contract Synth is ExternStateToken {
1232 
1233     /* ========== STATE VARIABLES ========== */
1234 
1235     FeePool public feePool;
1236     Synthetix public synthetix;
1237 
1238     // Currency key which identifies this Synth to the Synthetix system
1239     bytes4 public currencyKey;
1240 
1241     uint8 constant DECIMALS = 18;
1242 
1243     /* ========== CONSTRUCTOR ========== */
1244 
1245     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, FeePool _feePool,
1246         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey
1247     )
1248         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, 0, DECIMALS, _owner)
1249         public
1250     {
1251         require(_proxy != 0, "_proxy cannot be 0");
1252         require(address(_synthetix) != 0, "_synthetix cannot be 0");
1253         require(address(_feePool) != 0, "_feePool cannot be 0");
1254         require(_owner != 0, "_owner cannot be 0");
1255         require(_synthetix.synths(_currencyKey) == Synth(0), "Currency key is already in use");
1256 
1257         feePool = _feePool;
1258         synthetix = _synthetix;
1259         currencyKey = _currencyKey;
1260     }
1261 
1262     /* ========== SETTERS ========== */
1263 
1264     function setSynthetix(Synthetix _synthetix)
1265         external
1266         optionalProxy_onlyOwner
1267     {
1268         synthetix = _synthetix;
1269         emitSynthetixUpdated(_synthetix);
1270     }
1271 
1272     function setFeePool(FeePool _feePool)
1273         external
1274         optionalProxy_onlyOwner
1275     {
1276         feePool = _feePool;
1277         emitFeePoolUpdated(_feePool);
1278     }
1279 
1280     /* ========== MUTATIVE FUNCTIONS ========== */
1281 
1282     /**
1283      * @notice Override ERC20 transfer function in order to 
1284      * subtract the transaction fee and send it to the fee pool
1285      * for SNX holders to claim. */
1286     function transfer(address to, uint value)
1287         public
1288         optionalProxy
1289         notFeeAddress(messageSender)
1290         returns (bool)
1291     {
1292         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1293         uint fee = value.sub(amountReceived);
1294 
1295         // Send the fee off to the fee pool.
1296         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1297 
1298         // And send their result off to the destination address
1299         bytes memory empty;
1300         return _internalTransfer(messageSender, to, amountReceived, empty);
1301     }
1302 
1303     /**
1304      * @notice Override ERC223 transfer function in order to 
1305      * subtract the transaction fee and send it to the fee pool
1306      * for SNX holders to claim. */
1307     function transfer(address to, uint value, bytes data)
1308         public
1309         optionalProxy
1310         notFeeAddress(messageSender)
1311         returns (bool)
1312     {
1313         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1314         uint fee = value.sub(amountReceived);
1315 
1316         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1317         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1318 
1319         // And send their result off to the destination address
1320         return _internalTransfer(messageSender, to, amountReceived, data);
1321     }
1322 
1323     /**
1324      * @notice Override ERC20 transferFrom function in order to 
1325      * subtract the transaction fee and send it to the fee pool
1326      * for SNX holders to claim. */
1327     function transferFrom(address from, address to, uint value)
1328         public
1329         optionalProxy
1330         notFeeAddress(from)
1331         returns (bool)
1332     {
1333         // The fee is deducted from the amount sent.
1334         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1335         uint fee = value.sub(amountReceived);
1336 
1337         // Reduce the allowance by the amount we're transferring.
1338         // The safeSub call will handle an insufficient allowance.
1339         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1340 
1341         // Send the fee off to the fee pool.
1342         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1343 
1344         bytes memory empty;
1345         return _internalTransfer(from, to, amountReceived, empty);
1346     }
1347 
1348     /**
1349      * @notice Override ERC223 transferFrom function in order to 
1350      * subtract the transaction fee and send it to the fee pool
1351      * for SNX holders to claim. */
1352     function transferFrom(address from, address to, uint value, bytes data)
1353         public
1354         optionalProxy
1355         notFeeAddress(from)
1356         returns (bool)
1357     {
1358         // The fee is deducted from the amount sent.
1359         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1360         uint fee = value.sub(amountReceived);
1361 
1362         // Reduce the allowance by the amount we're transferring.
1363         // The safeSub call will handle an insufficient allowance.
1364         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1365 
1366         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1367         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1368 
1369         return _internalTransfer(from, to, amountReceived, data);
1370     }
1371 
1372     /* Subtract the transfer fee from the senders account so the 
1373      * receiver gets the exact amount specified to send. */
1374     function transferSenderPaysFee(address to, uint value)
1375         public
1376         optionalProxy
1377         notFeeAddress(messageSender)
1378         returns (bool)
1379     {
1380         uint fee = feePool.transferFeeIncurred(value);
1381 
1382         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1383         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1384 
1385         // And send their transfer amount off to the destination address
1386         bytes memory empty;
1387         return _internalTransfer(messageSender, to, value, empty);
1388     }
1389 
1390     /* Subtract the transfer fee from the senders account so the 
1391      * receiver gets the exact amount specified to send. */
1392     function transferSenderPaysFee(address to, uint value, bytes data)
1393         public
1394         optionalProxy
1395         notFeeAddress(messageSender)
1396         returns (bool)
1397     {
1398         uint fee = feePool.transferFeeIncurred(value);
1399 
1400         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1401         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1402 
1403         // And send their transfer amount off to the destination address
1404         return _internalTransfer(messageSender, to, value, data);
1405     }
1406 
1407     /* Subtract the transfer fee from the senders account so the 
1408      * to address receives the exact amount specified to send. */
1409     function transferFromSenderPaysFee(address from, address to, uint value)
1410         public
1411         optionalProxy
1412         notFeeAddress(from)
1413         returns (bool)
1414     {
1415         uint fee = feePool.transferFeeIncurred(value);
1416 
1417         // Reduce the allowance by the amount we're transferring.
1418         // The safeSub call will handle an insufficient allowance.
1419         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
1420 
1421         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1422         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1423 
1424         bytes memory empty;
1425         return _internalTransfer(from, to, value, empty);
1426     }
1427 
1428     /* Subtract the transfer fee from the senders account so the 
1429      * to address receives the exact amount specified to send. */
1430     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
1431         public
1432         optionalProxy
1433         notFeeAddress(from)
1434         returns (bool)
1435     {
1436         uint fee = feePool.transferFeeIncurred(value);
1437 
1438         // Reduce the allowance by the amount we're transferring.
1439         // The safeSub call will handle an insufficient allowance.
1440         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
1441 
1442         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1443         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1444 
1445         return _internalTransfer(from, to, value, data);
1446     }
1447 
1448     // Override our internal transfer to inject preferred currency support
1449     function _internalTransfer(address from, address to, uint value, bytes data)
1450         internal
1451         returns (bool)
1452     {
1453         bytes4 preferredCurrencyKey = synthetix.synthetixState().preferredCurrency(to);
1454 
1455         // Do they have a preferred currency that's not us? If so we need to exchange
1456         if (preferredCurrencyKey != 0 && preferredCurrencyKey != currencyKey) {
1457             return synthetix.synthInitiatedExchange(from, currencyKey, value, preferredCurrencyKey, to);
1458         } else {
1459             // Otherwise we just transfer
1460             return super._internalTransfer(from, to, value, data);
1461         }
1462     }
1463 
1464     // Allow synthetix to issue a certain number of synths from an account.
1465     function issue(address account, uint amount)
1466         external
1467         onlySynthetixOrFeePool
1468     {
1469         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
1470         totalSupply = totalSupply.add(amount);
1471         emitTransfer(address(0), account, amount);
1472         emitIssued(account, amount);
1473     }
1474 
1475     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
1476     function burn(address account, uint amount)
1477         external
1478         onlySynthetixOrFeePool
1479     {
1480         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
1481         totalSupply = totalSupply.sub(amount);
1482         emitTransfer(account, address(0), amount);
1483         emitBurned(account, amount);
1484     }
1485 
1486     // Allow owner to set the total supply on import.
1487     function setTotalSupply(uint amount)
1488         external
1489         optionalProxy_onlyOwner
1490     {
1491         totalSupply = amount;
1492     }
1493 
1494     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
1495     // exchange as well as transfer
1496     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
1497         external
1498         onlySynthetixOrFeePool
1499     {
1500         bytes memory empty;
1501         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
1502     }
1503 
1504     /* ========== MODIFIERS ========== */
1505 
1506     modifier onlySynthetixOrFeePool() {
1507         bool isSynthetix = msg.sender == address(synthetix);
1508         bool isFeePool = msg.sender == address(feePool);
1509 
1510         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
1511         _;
1512     }
1513 
1514     modifier notFeeAddress(address account) {
1515         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
1516         _;
1517     }
1518 
1519     /* ========== EVENTS ========== */
1520 
1521     event SynthetixUpdated(address newSynthetix);
1522     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
1523     function emitSynthetixUpdated(address newSynthetix) internal {
1524         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
1525     }
1526 
1527     event FeePoolUpdated(address newFeePool);
1528     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
1529     function emitFeePoolUpdated(address newFeePool) internal {
1530         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
1531     }
1532 
1533     event Issued(address indexed account, uint value);
1534     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
1535     function emitIssued(address account, uint value) internal {
1536         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
1537     }
1538 
1539     event Burned(address indexed account, uint value);
1540     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
1541     function emitBurned(address account, uint value) internal {
1542         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
1543     }
1544 }
1545 
1546 
1547 /*
1548 -----------------------------------------------------------------
1549 FILE INFORMATION
1550 -----------------------------------------------------------------
1551 
1552 file:       FeePool.sol
1553 version:    1.0
1554 author:     Kevin Brown
1555 date:       2018-10-15
1556 
1557 -----------------------------------------------------------------
1558 MODULE DESCRIPTION
1559 -----------------------------------------------------------------
1560 
1561 The FeePool is a place for users to interact with the fees that
1562 have been generated from the Synthetix system if they've helped
1563 to create the economy.
1564 
1565 Users stake Synthetix to create Synths. As Synth users transact,
1566 a small fee is deducted from each transaction, which collects
1567 in the fee pool. Fees are immediately converted to XDRs, a type
1568 of reserve currency similar to SDRs used by the IMF:
1569 https://www.imf.org/en/About/Factsheets/Sheets/2016/08/01/14/51/Special-Drawing-Right-SDR
1570 
1571 Users are entitled to withdraw fees from periods that they participated
1572 in fully, e.g. they have to stake before the period starts. They
1573 can withdraw fees for the last 6 periods as a single lump sum.
1574 Currently fee periods are 7 days long, meaning it's assumed
1575 users will withdraw their fees approximately once a month. Fees
1576 which are not withdrawn are redistributed to the whole pool,
1577 enabling these non-claimed fees to go back to the rest of the commmunity.
1578 
1579 Fees can be withdrawn in any synth currency.
1580 
1581 -----------------------------------------------------------------
1582 */
1583 
1584 
1585 contract FeePool is Proxyable, SelfDestructible {
1586 
1587     using SafeMath for uint;
1588     using SafeDecimalMath for uint;
1589 
1590     Synthetix public synthetix;
1591 
1592     // A percentage fee charged on each transfer.
1593     uint public transferFeeRate;
1594 
1595     // Transfer fee may not exceed 10%.
1596     uint constant public MAX_TRANSFER_FEE_RATE = SafeDecimalMath.unit() / 10;
1597 
1598     // A percentage fee charged on each exchange between currencies.
1599     uint public exchangeFeeRate;
1600 
1601     // Exchange fee may not exceed 10%.
1602     uint constant public MAX_EXCHANGE_FEE_RATE = SafeDecimalMath.unit() / 10;
1603 
1604     // The address with the authority to distribute fees.
1605     address public feeAuthority;
1606 
1607     // Where fees are pooled in XDRs.
1608     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
1609 
1610     // This struct represents the issuance activity that's happened in a fee period.
1611     struct FeePeriod {
1612         uint feePeriodId;
1613         uint startingDebtIndex;
1614         uint startTime;
1615         uint feesToDistribute;
1616         uint feesClaimed;
1617     }
1618 
1619     // The last 6 fee periods are all that you can claim from.
1620     // These are stored and managed from [0], such that [0] is always
1621     // the most recent fee period, and [5] is always the oldest fee
1622     // period that users can claim for.
1623     uint8 constant public FEE_PERIOD_LENGTH = 6;
1624     FeePeriod[FEE_PERIOD_LENGTH] public recentFeePeriods;
1625 
1626     // The next fee period will have this ID.
1627     uint public nextFeePeriodId;
1628 
1629     // How long a fee period lasts at a minimum. It is required for the
1630     // fee authority to roll over the periods, so they are not guaranteed
1631     // to roll over at exactly this duration, but the contract enforces
1632     // that they cannot roll over any quicker than this duration.
1633     uint public feePeriodDuration = 1 weeks;
1634 
1635     // The fee period must be between 1 day and 60 days.
1636     uint public constant MIN_FEE_PERIOD_DURATION = 1 days;
1637     uint public constant MAX_FEE_PERIOD_DURATION = 60 days;
1638 
1639     // The last period a user has withdrawn their fees in, identified by the feePeriodId
1640     mapping(address => uint) public lastFeeWithdrawal;
1641 
1642     // Users receive penalties if their collateralisation ratio drifts out of our desired brackets
1643     // We precompute the brackets and penalties to save gas.
1644     uint constant TWENTY_PERCENT = (20 * SafeDecimalMath.unit()) / 100;
1645     uint constant TWENTY_FIVE_PERCENT = (25 * SafeDecimalMath.unit()) / 100;
1646     uint constant THIRTY_PERCENT = (30 * SafeDecimalMath.unit()) / 100;
1647     uint constant FOURTY_PERCENT = (40 * SafeDecimalMath.unit()) / 100;
1648     uint constant FIFTY_PERCENT = (50 * SafeDecimalMath.unit()) / 100;
1649     uint constant SEVENTY_FIVE_PERCENT = (75 * SafeDecimalMath.unit()) / 100;
1650 
1651     constructor(address _proxy, address _owner, Synthetix _synthetix, address _feeAuthority, uint _transferFeeRate, uint _exchangeFeeRate)
1652         SelfDestructible(_owner)
1653         Proxyable(_proxy, _owner)
1654         public
1655     {
1656         // Constructed fee rates should respect the maximum fee rates.
1657         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
1658         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Constructed exchange fee rate should respect the maximum fee rate");
1659 
1660         synthetix = _synthetix;
1661         feeAuthority = _feeAuthority;
1662         transferFeeRate = _transferFeeRate;
1663         exchangeFeeRate = _exchangeFeeRate;
1664 
1665         // Set our initial fee period
1666         recentFeePeriods[0].feePeriodId = 1;
1667         recentFeePeriods[0].startTime = now;
1668         // Gas optimisation: These do not need to be initialised. They start at 0.
1669         // recentFeePeriods[0].startingDebtIndex = 0;
1670         // recentFeePeriods[0].feesToDistribute = 0;
1671 
1672         // And the next one starts at 2.
1673         nextFeePeriodId = 2;
1674     }
1675 
1676     /**
1677      * @notice Set the exchange fee, anywhere within the range 0-10%.
1678      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1679      */
1680     function setExchangeFeeRate(uint _exchangeFeeRate)
1681         external
1682         optionalProxy_onlyOwner
1683     {
1684         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Exchange fee rate must be below MAX_EXCHANGE_FEE_RATE");
1685 
1686         exchangeFeeRate = _exchangeFeeRate;
1687 
1688         emitExchangeFeeUpdated(_exchangeFeeRate);
1689     }
1690 
1691     /**
1692      * @notice Set the transfer fee, anywhere within the range 0-10%.
1693      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1694      */
1695     function setTransferFeeRate(uint _transferFeeRate)
1696         external
1697         optionalProxy_onlyOwner
1698     {
1699         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
1700 
1701         transferFeeRate = _transferFeeRate;
1702 
1703         emitTransferFeeUpdated(_transferFeeRate);
1704     }
1705 
1706     /**
1707      * @notice Set the address of the user/contract responsible for collecting or
1708      * distributing fees.
1709      */
1710     function setFeeAuthority(address _feeAuthority)
1711         external
1712         optionalProxy_onlyOwner
1713     {
1714         feeAuthority = _feeAuthority;
1715 
1716         emitFeeAuthorityUpdated(_feeAuthority);
1717     }
1718 
1719     /**
1720      * @notice Set the fee period duration
1721      */
1722     function setFeePeriodDuration(uint _feePeriodDuration)
1723         external
1724         optionalProxy_onlyOwner
1725     {
1726         require(_feePeriodDuration >= MIN_FEE_PERIOD_DURATION, "New fee period cannot be less than minimum fee period duration");
1727         require(_feePeriodDuration <= MAX_FEE_PERIOD_DURATION, "New fee period cannot be greater than maximum fee period duration");
1728 
1729         feePeriodDuration = _feePeriodDuration;
1730 
1731         emitFeePeriodDurationUpdated(_feePeriodDuration);
1732     }
1733 
1734     /**
1735      * @notice Set the synthetix contract
1736      */
1737     function setSynthetix(Synthetix _synthetix)
1738         external
1739         optionalProxy_onlyOwner
1740     {
1741         require(address(_synthetix) != address(0), "New Synthetix must be non-zero");
1742 
1743         synthetix = _synthetix;
1744 
1745         emitSynthetixUpdated(_synthetix);
1746     }
1747 
1748     /**
1749      * @notice The Synthetix contract informs us when fees are paid.
1750      */
1751     function feePaid(bytes4 currencyKey, uint amount)
1752         external
1753         onlySynthetix
1754     {
1755         uint xdrAmount = synthetix.effectiveValue(currencyKey, amount, "XDR");
1756 
1757         // Which we keep track of in XDRs in our fee pool.
1758         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.add(xdrAmount);
1759     }
1760 
1761     /**
1762      * @notice Close the current fee period and start a new one. Only callable by the fee authority.
1763      */
1764     function closeCurrentFeePeriod()
1765         external
1766         onlyFeeAuthority
1767     {
1768         require(recentFeePeriods[0].startTime <= (now - feePeriodDuration), "It is too early to close the current fee period");
1769 
1770         FeePeriod memory secondLastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 2];
1771         FeePeriod memory lastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 1];
1772 
1773         // Any unclaimed fees from the last period in the array roll back one period.
1774         // Because of the subtraction here, they're effectively proportionally redistributed to those who
1775         // have already claimed from the old period, available in the new period.
1776         // The subtraction is important so we don't create a ticking time bomb of an ever growing
1777         // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
1778         recentFeePeriods[FEE_PERIOD_LENGTH - 2].feesToDistribute = lastFeePeriod.feesToDistribute
1779             .sub(lastFeePeriod.feesClaimed)
1780             .add(secondLastFeePeriod.feesToDistribute);
1781 
1782         // Shift the previous fee periods across to make room for the new one.
1783         // Condition checks for overflow when uint subtracts one from zero
1784         // Could be written with int instead of uint, but then we have to convert everywhere
1785         // so it felt better from a gas perspective to just change the condition to check
1786         // for overflow after subtracting one from zero.
1787         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
1788             uint next = i + 1;
1789 
1790             recentFeePeriods[next].feePeriodId = recentFeePeriods[i].feePeriodId;
1791             recentFeePeriods[next].startingDebtIndex = recentFeePeriods[i].startingDebtIndex;
1792             recentFeePeriods[next].startTime = recentFeePeriods[i].startTime;
1793             recentFeePeriods[next].feesToDistribute = recentFeePeriods[i].feesToDistribute;
1794             recentFeePeriods[next].feesClaimed = recentFeePeriods[i].feesClaimed;
1795         }
1796 
1797         // Clear the first element of the array to make sure we don't have any stale values.
1798         delete recentFeePeriods[0];
1799 
1800         // Open up the new fee period
1801         recentFeePeriods[0].feePeriodId = nextFeePeriodId;
1802         recentFeePeriods[0].startingDebtIndex = synthetix.synthetixState().debtLedgerLength();
1803         recentFeePeriods[0].startTime = now;
1804 
1805         nextFeePeriodId = nextFeePeriodId.add(1);
1806 
1807         emitFeePeriodClosed(recentFeePeriods[1].feePeriodId);
1808     }
1809 
1810     /**
1811     * @notice Claim fees for last period when available or not already withdrawn.
1812     * @param currencyKey Synth currency you wish to receive the fees in.
1813     */
1814     function claimFees(bytes4 currencyKey)
1815         external
1816         optionalProxy
1817         returns (bool)
1818     {
1819         uint availableFees = feesAvailable(messageSender, "XDR");
1820 
1821         require(availableFees > 0, "No fees available for period, or fees already claimed");
1822 
1823         lastFeeWithdrawal[messageSender] = recentFeePeriods[1].feePeriodId;
1824 
1825         // Record the fee payment in our recentFeePeriods
1826         _recordFeePayment(availableFees);
1827 
1828         // Send them their fees
1829         _payFees(messageSender, availableFees, currencyKey);
1830 
1831         emitFeesClaimed(messageSender, availableFees);
1832 
1833         return true;
1834     }
1835 
1836     /**
1837      * @notice Record the fee payment in our recentFeePeriods.
1838      * @param xdrAmount The amout of fees priced in XDRs.
1839      */
1840     function _recordFeePayment(uint xdrAmount)
1841         internal
1842     {
1843         // Don't assign to the parameter
1844         uint remainingToAllocate = xdrAmount;
1845 
1846         // Start at the oldest period and record the amount, moving to newer periods
1847         // until we've exhausted the amount.
1848         // The condition checks for overflow because we're going to 0 with an unsigned int.
1849         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
1850             uint delta = recentFeePeriods[i].feesToDistribute.sub(recentFeePeriods[i].feesClaimed);
1851 
1852             if (delta > 0) {
1853                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
1854                 uint amountInPeriod = delta < remainingToAllocate ? delta : remainingToAllocate;
1855 
1856                 recentFeePeriods[i].feesClaimed = recentFeePeriods[i].feesClaimed.add(amountInPeriod);
1857                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
1858 
1859                 // No need to continue iterating if we've recorded the whole amount;
1860                 if (remainingToAllocate == 0) return;
1861             }
1862         }
1863 
1864         // If we hit this line, we've exhausted our fee periods, but still have more to allocate. Wat?
1865         // If this happens it's a definite bug in the code, so assert instead of require.
1866         assert(remainingToAllocate == 0);
1867     }
1868 
1869     /**
1870     * @notice Send the fees to claiming address.
1871     * @param account The address to send the fees to.
1872     * @param xdrAmount The amount of fees priced in XDRs.
1873     * @param destinationCurrencyKey The synth currency the user wishes to receive their fees in (convert to this currency).
1874     */
1875     function _payFees(address account, uint xdrAmount, bytes4 destinationCurrencyKey)
1876         internal
1877         notFeeAddress(account)
1878     {
1879         require(account != address(0), "Account can't be 0");
1880         require(account != address(this), "Can't send fees to fee pool");
1881         require(account != address(proxy), "Can't send fees to proxy");
1882         require(account != address(synthetix), "Can't send fees to synthetix");
1883 
1884         Synth xdrSynth = synthetix.synths("XDR");
1885         Synth destinationSynth = synthetix.synths(destinationCurrencyKey);
1886 
1887         // Note: We don't need to check the fee pool balance as the burn() below will do a safe subtraction which requires
1888         // the subtraction to not overflow, which would happen if the balance is not sufficient.
1889 
1890         // Burn the source amount
1891         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
1892 
1893         // How much should they get in the destination currency?
1894         uint destinationAmount = synthetix.effectiveValue("XDR", xdrAmount, destinationCurrencyKey);
1895 
1896         // There's no fee on withdrawing fees, as that'd be way too meta.
1897 
1898         // Mint their new synths
1899         destinationSynth.issue(account, destinationAmount);
1900 
1901         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
1902 
1903         // Call the ERC223 transfer callback if needed
1904         destinationSynth.triggerTokenFallbackIfNeeded(FEE_ADDRESS, account, destinationAmount);
1905     }
1906 
1907     /**
1908      * @notice Calculate the Fee charged on top of a value being sent
1909      * @return Return the fee charged
1910      */
1911     function transferFeeIncurred(uint value)
1912         public
1913         view
1914         returns (uint)
1915     {
1916         return value.multiplyDecimal(transferFeeRate);
1917 
1918         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1919         // This is on the basis that transfers less than this value will result in a nil fee.
1920         // Probably too insignificant to worry about, but the following code will achieve it.
1921         //      if (fee == 0 && transferFeeRate != 0) {
1922         //          return _value;
1923         //      }
1924         //      return fee;
1925     }
1926 
1927     /**
1928      * @notice The value that you would need to send so that the recipient receives
1929      * a specified value.
1930      * @param value The value you want the recipient to receive
1931      */
1932     function transferredAmountToReceive(uint value)
1933         external
1934         view
1935         returns (uint)
1936     {
1937         return value.add(transferFeeIncurred(value));
1938     }
1939 
1940     /**
1941      * @notice The amount the recipient will receive if you send a certain number of tokens.
1942      * @param value The amount of tokens you intend to send.
1943      */
1944     function amountReceivedFromTransfer(uint value)
1945         external
1946         view
1947         returns (uint)
1948     {
1949         return value.divideDecimal(transferFeeRate.add(SafeDecimalMath.unit()));
1950     }
1951 
1952     /**
1953      * @notice Calculate the fee charged on top of a value being sent via an exchange
1954      * @return Return the fee charged
1955      */
1956     function exchangeFeeIncurred(uint value)
1957         public
1958         view
1959         returns (uint)
1960     {
1961         return value.multiplyDecimal(exchangeFeeRate);
1962 
1963         // Exchanges less than the reciprocal of exchangeFeeRate should be completely eaten up by fees.
1964         // This is on the basis that exchanges less than this value will result in a nil fee.
1965         // Probably too insignificant to worry about, but the following code will achieve it.
1966         //      if (fee == 0 && exchangeFeeRate != 0) {
1967         //          return _value;
1968         //      }
1969         //      return fee;
1970     }
1971 
1972     /**
1973      * @notice The value that you would need to get after currency exchange so that the recipient receives
1974      * a specified value.
1975      * @param value The value you want the recipient to receive
1976      */
1977     function exchangedAmountToReceive(uint value)
1978         external
1979         view
1980         returns (uint)
1981     {
1982         return value.add(exchangeFeeIncurred(value));
1983     }
1984 
1985     /**
1986      * @notice The amount the recipient will receive if you are performing an exchange and the
1987      * destination currency will be worth a certain number of tokens.
1988      * @param value The amount of destination currency tokens they received after the exchange.
1989      */
1990     function amountReceivedFromExchange(uint value)
1991         external
1992         view
1993         returns (uint)
1994     {
1995         return value.divideDecimal(exchangeFeeRate.add(SafeDecimalMath.unit()));
1996     }
1997 
1998     /**
1999      * @notice The total fees available in the system to be withdrawn, priced in currencyKey currency
2000      * @param currencyKey The currency you want to price the fees in
2001      */
2002     function totalFeesAvailable(bytes4 currencyKey)
2003         external
2004         view
2005         returns (uint)
2006     {
2007         uint totalFees = 0;
2008 
2009         // Fees in fee period [0] are not yet available for withdrawal
2010         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
2011             totalFees = totalFees.add(recentFeePeriods[i].feesToDistribute);
2012             totalFees = totalFees.sub(recentFeePeriods[i].feesClaimed);
2013         }
2014 
2015         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
2016     }
2017 
2018     /**
2019      * @notice The fees available to be withdrawn by a specific account, priced in currencyKey currency
2020      * @param currencyKey The currency you want to price the fees in
2021      */
2022     function feesAvailable(address account, bytes4 currencyKey)
2023         public
2024         view
2025         returns (uint)
2026     {
2027         // Add up the fees
2028         uint[FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);
2029 
2030         uint totalFees = 0;
2031 
2032         // Fees in fee period [0] are not yet available for withdrawal
2033         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
2034             totalFees = totalFees.add(userFees[i]);
2035         }
2036 
2037         // And convert them to their desired currency
2038         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
2039     }
2040 
2041     /**
2042      * @notice The penalty a particular address would incur if its fees were withdrawn right now
2043      * @param account The address you want to query the penalty for
2044      */
2045     function currentPenalty(address account)
2046         public
2047         view
2048         returns (uint)
2049     {
2050         uint ratio = synthetix.collateralisationRatio(account);
2051 
2052         // Users receive a different amount of fees depending on how their collateralisation ratio looks right now.
2053         // 0% - 20%: Fee is calculated based on percentage of economy issued.
2054         // 20% - 30%: 25% reduction in fees
2055         // 30% - 40%: 50% reduction in fees
2056         // >40%: 75% reduction in fees
2057         if (ratio <= TWENTY_PERCENT) {
2058             return 0;
2059         } else if (ratio > TWENTY_PERCENT && ratio <= THIRTY_PERCENT) {
2060             return TWENTY_FIVE_PERCENT;
2061         } else if (ratio > THIRTY_PERCENT && ratio <= FOURTY_PERCENT) {
2062             return FIFTY_PERCENT;
2063         }
2064 
2065         return SEVENTY_FIVE_PERCENT;
2066     }
2067 
2068     /**
2069      * @notice Calculates fees by period for an account, priced in XDRs
2070      * @param account The address you want to query the fees by penalty for
2071      */
2072     function feesByPeriod(address account)
2073         public
2074         view
2075         returns (uint[FEE_PERIOD_LENGTH])
2076     {
2077         uint[FEE_PERIOD_LENGTH] memory result;
2078 
2079         // What's the user's debt entry index and the debt they owe to the system
2080         uint initialDebtOwnership;
2081         uint debtEntryIndex;
2082         (initialDebtOwnership, debtEntryIndex) = synthetix.synthetixState().issuanceData(account);
2083 
2084         // If they don't have any debt ownership, they don't have any fees
2085         if (initialDebtOwnership == 0) return result;
2086 
2087         // If there are no XDR synths, then they don't have any fees
2088         uint totalSynths = synthetix.totalIssuedSynths("XDR");
2089         if (totalSynths == 0) return result;
2090 
2091         uint debtBalance = synthetix.debtBalanceOf(account, "XDR");
2092         uint userOwnershipPercentage = debtBalance.divideDecimal(totalSynths);
2093         uint penalty = currentPenalty(account);
2094         
2095         // Go through our fee periods and figure out what we owe them.
2096         // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
2097         // fees owing for, so we need to report on it anyway.
2098         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
2099             // Were they a part of this period in its entirety?
2100             // We don't allow pro-rata participation to reduce the ability to game the system by
2101             // issuing and burning multiple times in a period or close to the ends of periods.
2102             if (recentFeePeriods[i].startingDebtIndex > debtEntryIndex &&
2103                 lastFeeWithdrawal[account] < recentFeePeriods[i].feePeriodId) {
2104 
2105                 // And since they were, they're entitled to their percentage of the fees in this period
2106                 uint feesFromPeriodWithoutPenalty = recentFeePeriods[i].feesToDistribute
2107                     .multiplyDecimal(userOwnershipPercentage);
2108 
2109                 // Less their penalty if they have one.
2110                 uint penaltyFromPeriod = feesFromPeriodWithoutPenalty.multiplyDecimal(penalty);
2111                 uint feesFromPeriod = feesFromPeriodWithoutPenalty.sub(penaltyFromPeriod);
2112 
2113                 result[i] = feesFromPeriod;
2114             }
2115         }
2116 
2117         return result;
2118     }
2119 
2120     modifier onlyFeeAuthority
2121     {
2122         require(msg.sender == feeAuthority, "Only the fee authority can perform this action");
2123         _;
2124     }
2125 
2126     modifier onlySynthetix
2127     {
2128         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
2129         _;
2130     }
2131 
2132     modifier notFeeAddress(address account) {
2133         require(account != FEE_ADDRESS, "Fee address not allowed");
2134         _;
2135     }
2136 
2137     event TransferFeeUpdated(uint newFeeRate);
2138     bytes32 constant TRANSFERFEEUPDATED_SIG = keccak256("TransferFeeUpdated(uint256)");
2139     function emitTransferFeeUpdated(uint newFeeRate) internal {
2140         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEEUPDATED_SIG, 0, 0, 0);
2141     }
2142 
2143     event ExchangeFeeUpdated(uint newFeeRate);
2144     bytes32 constant EXCHANGEFEEUPDATED_SIG = keccak256("ExchangeFeeUpdated(uint256)");
2145     function emitExchangeFeeUpdated(uint newFeeRate) internal {
2146         proxy._emit(abi.encode(newFeeRate), 1, EXCHANGEFEEUPDATED_SIG, 0, 0, 0);
2147     }
2148 
2149     event FeePeriodDurationUpdated(uint newFeePeriodDuration);
2150     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
2151     function emitFeePeriodDurationUpdated(uint newFeePeriodDuration) internal {
2152         proxy._emit(abi.encode(newFeePeriodDuration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
2153     }
2154 
2155     event FeeAuthorityUpdated(address newFeeAuthority);
2156     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
2157     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
2158         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
2159     }
2160 
2161     event FeePeriodClosed(uint feePeriodId);
2162     bytes32 constant FEEPERIODCLOSED_SIG = keccak256("FeePeriodClosed(uint256)");
2163     function emitFeePeriodClosed(uint feePeriodId) internal {
2164         proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
2165     }
2166 
2167     event FeesClaimed(address account, uint xdrAmount);
2168     bytes32 constant FEESCLAIMED_SIG = keccak256("FeesClaimed(address,uint256)");
2169     function emitFeesClaimed(address account, uint xdrAmount) internal {
2170         proxy._emit(abi.encode(account, xdrAmount), 1, FEESCLAIMED_SIG, 0, 0, 0);
2171     }
2172 
2173     event SynthetixUpdated(address newSynthetix);
2174     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
2175     function emitSynthetixUpdated(address newSynthetix) internal {
2176         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
2177     }
2178 }
2179 
2180 
2181 /*
2182 -----------------------------------------------------------------
2183 FILE INFORMATION
2184 -----------------------------------------------------------------
2185 
2186 file:       LimitedSetup.sol
2187 version:    1.1
2188 author:     Anton Jurisevic
2189 
2190 date:       2018-05-15
2191 
2192 -----------------------------------------------------------------
2193 MODULE DESCRIPTION
2194 -----------------------------------------------------------------
2195 
2196 A contract with a limited setup period. Any function modified
2197 with the setup modifier will cease to work after the
2198 conclusion of the configurable-length post-construction setup period.
2199 
2200 -----------------------------------------------------------------
2201 */
2202 
2203 
2204 /**
2205  * @title Any function decorated with the modifier this contract provides
2206  * deactivates after a specified setup period.
2207  */
2208 contract LimitedSetup {
2209 
2210     uint setupExpiryTime;
2211 
2212     /**
2213      * @dev LimitedSetup Constructor.
2214      * @param setupDuration The time the setup period will last for.
2215      */
2216     constructor(uint setupDuration)
2217         public
2218     {
2219         setupExpiryTime = now + setupDuration;
2220     }
2221 
2222     modifier onlyDuringSetup
2223     {
2224         require(now < setupExpiryTime, "Can only perform this action during setup");
2225         _;
2226     }
2227 }
2228 
2229 
2230 /*
2231 -----------------------------------------------------------------
2232 FILE INFORMATION
2233 -----------------------------------------------------------------
2234 
2235 file:       SynthetixEscrow.sol
2236 version:    1.1
2237 author:     Anton Jurisevic
2238             Dominic Romanowski
2239             Mike Spain
2240 
2241 date:       2018-05-29
2242 
2243 -----------------------------------------------------------------
2244 MODULE DESCRIPTION
2245 -----------------------------------------------------------------
2246 
2247 This contract allows the foundation to apply unique vesting
2248 schedules to synthetix funds sold at various discounts in the token
2249 sale. SynthetixEscrow gives users the ability to inspect their
2250 vested funds, their quantities and vesting dates, and to withdraw
2251 the fees that accrue on those funds.
2252 
2253 The fees are handled by withdrawing the entire fee allocation
2254 for all SNX inside the escrow contract, and then allowing
2255 the contract itself to subdivide that pool up proportionally within
2256 itself. Every time the fee period rolls over in the main Synthetix
2257 contract, the SynthetixEscrow fee pool is remitted back into the
2258 main fee pool to be redistributed in the next fee period.
2259 
2260 -----------------------------------------------------------------
2261 */
2262 
2263 
2264 /**
2265  * @title A contract to hold escrowed SNX and free them at given schedules.
2266  */
2267 contract SynthetixEscrow is Owned, LimitedSetup(8 weeks) {
2268 
2269     using SafeMath for uint;
2270 
2271     /* The corresponding Synthetix contract. */
2272     Synthetix public synthetix;
2273 
2274     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
2275      * These are the times at which each given quantity of SNX vests. */
2276     mapping(address => uint[2][]) public vestingSchedules;
2277 
2278     /* An account's total vested synthetix balance to save recomputing this for fee extraction purposes. */
2279     mapping(address => uint) public totalVestedAccountBalance;
2280 
2281     /* The total remaining vested balance, for verifying the actual synthetix balance of this contract against. */
2282     uint public totalVestedBalance;
2283 
2284     uint constant TIME_INDEX = 0;
2285     uint constant QUANTITY_INDEX = 1;
2286 
2287     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
2288     uint constant MAX_VESTING_ENTRIES = 20;
2289 
2290 
2291     /* ========== CONSTRUCTOR ========== */
2292 
2293     constructor(address _owner, Synthetix _synthetix)
2294         Owned(_owner)
2295         public
2296     {
2297         synthetix = _synthetix;
2298     }
2299 
2300 
2301     /* ========== SETTERS ========== */
2302 
2303     function setSynthetix(Synthetix _synthetix)
2304         external
2305         onlyOwner
2306     {
2307         synthetix = _synthetix;
2308         emit SynthetixUpdated(_synthetix);
2309     }
2310 
2311 
2312     /* ========== VIEW FUNCTIONS ========== */
2313 
2314     /**
2315      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
2316      */
2317     function balanceOf(address account)
2318         public
2319         view
2320         returns (uint)
2321     {
2322         return totalVestedAccountBalance[account];
2323     }
2324 
2325     /**
2326      * @notice The number of vesting dates in an account's schedule.
2327      */
2328     function numVestingEntries(address account)
2329         public
2330         view
2331         returns (uint)
2332     {
2333         return vestingSchedules[account].length;
2334     }
2335 
2336     /**
2337      * @notice Get a particular schedule entry for an account.
2338      * @return A pair of uints: (timestamp, synthetix quantity).
2339      */
2340     function getVestingScheduleEntry(address account, uint index)
2341         public
2342         view
2343         returns (uint[2])
2344     {
2345         return vestingSchedules[account][index];
2346     }
2347 
2348     /**
2349      * @notice Get the time at which a given schedule entry will vest.
2350      */
2351     function getVestingTime(address account, uint index)
2352         public
2353         view
2354         returns (uint)
2355     {
2356         return getVestingScheduleEntry(account,index)[TIME_INDEX];
2357     }
2358 
2359     /**
2360      * @notice Get the quantity of SNX associated with a given schedule entry.
2361      */
2362     function getVestingQuantity(address account, uint index)
2363         public
2364         view
2365         returns (uint)
2366     {
2367         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
2368     }
2369 
2370     /**
2371      * @notice Obtain the index of the next schedule entry that will vest for a given user.
2372      */
2373     function getNextVestingIndex(address account)
2374         public
2375         view
2376         returns (uint)
2377     {
2378         uint len = numVestingEntries(account);
2379         for (uint i = 0; i < len; i++) {
2380             if (getVestingTime(account, i) != 0) {
2381                 return i;
2382             }
2383         }
2384         return len;
2385     }
2386 
2387     /**
2388      * @notice Obtain the next schedule entry that will vest for a given user.
2389      * @return A pair of uints: (timestamp, synthetix quantity). */
2390     function getNextVestingEntry(address account)
2391         public
2392         view
2393         returns (uint[2])
2394     {
2395         uint index = getNextVestingIndex(account);
2396         if (index == numVestingEntries(account)) {
2397             return [uint(0), 0];
2398         }
2399         return getVestingScheduleEntry(account, index);
2400     }
2401 
2402     /**
2403      * @notice Obtain the time at which the next schedule entry will vest for a given user.
2404      */
2405     function getNextVestingTime(address account)
2406         external
2407         view
2408         returns (uint)
2409     {
2410         return getNextVestingEntry(account)[TIME_INDEX];
2411     }
2412 
2413     /**
2414      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
2415      */
2416     function getNextVestingQuantity(address account)
2417         external
2418         view
2419         returns (uint)
2420     {
2421         return getNextVestingEntry(account)[QUANTITY_INDEX];
2422     }
2423 
2424 
2425     /* ========== MUTATIVE FUNCTIONS ========== */
2426 
2427     /**
2428      * @notice Withdraws a quantity of SNX back to the synthetix contract.
2429      * @dev This may only be called by the owner during the contract's setup period.
2430      */
2431     function withdrawSynthetix(uint quantity)
2432         external
2433         onlyOwner
2434         onlyDuringSetup
2435     {
2436         synthetix.transfer(synthetix, quantity);
2437     }
2438 
2439     /**
2440      * @notice Destroy the vesting information associated with an account.
2441      */
2442     function purgeAccount(address account)
2443         external
2444         onlyOwner
2445         onlyDuringSetup
2446     {
2447         delete vestingSchedules[account];
2448         totalVestedBalance = totalVestedBalance.sub(totalVestedAccountBalance[account]);
2449         delete totalVestedAccountBalance[account];
2450     }
2451 
2452     /**
2453      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
2454      * @dev A call to this should be accompanied by either enough balance already available
2455      * in this contract, or a corresponding call to synthetix.endow(), to ensure that when
2456      * the funds are withdrawn, there is enough balance, as well as correctly calculating
2457      * the fees.
2458      * This may only be called by the owner during the contract's setup period.
2459      * Note; although this function could technically be used to produce unbounded
2460      * arrays, it's only in the foundation's command to add to these lists.
2461      * @param account The account to append a new vesting entry to.
2462      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
2463      * @param quantity The quantity of SNX that will vest.
2464      */
2465     function appendVestingEntry(address account, uint time, uint quantity)
2466         public
2467         onlyOwner
2468         onlyDuringSetup
2469     {
2470         /* No empty or already-passed vesting entries allowed. */
2471         require(now < time, "Time must be in the future");
2472         require(quantity != 0, "Quantity cannot be zero");
2473 
2474         /* There must be enough balance in the contract to provide for the vesting entry. */
2475         totalVestedBalance = totalVestedBalance.add(quantity);
2476         require(totalVestedBalance <= synthetix.balanceOf(this), "Must be enough balance in the contract to provide for the vesting entry");
2477 
2478         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
2479         uint scheduleLength = vestingSchedules[account].length;
2480         require(scheduleLength <= MAX_VESTING_ENTRIES, "Vesting schedule is too long");
2481 
2482         if (scheduleLength == 0) {
2483             totalVestedAccountBalance[account] = quantity;
2484         } else {
2485             /* Disallow adding new vested SNX earlier than the last one.
2486              * Since entries are only appended, this means that no vesting date can be repeated. */
2487             require(getVestingTime(account, numVestingEntries(account) - 1) < time, "Cannot add new vested entries earlier than the last one");
2488             totalVestedAccountBalance[account] = totalVestedAccountBalance[account].add(quantity);
2489         }
2490 
2491         vestingSchedules[account].push([time, quantity]);
2492     }
2493 
2494     /**
2495      * @notice Construct a vesting schedule to release a quantities of SNX
2496      * over a series of intervals.
2497      * @dev Assumes that the quantities are nonzero
2498      * and that the sequence of timestamps is strictly increasing.
2499      * This may only be called by the owner during the contract's setup period.
2500      */
2501     function addVestingSchedule(address account, uint[] times, uint[] quantities)
2502         external
2503         onlyOwner
2504         onlyDuringSetup
2505     {
2506         for (uint i = 0; i < times.length; i++) {
2507             appendVestingEntry(account, times[i], quantities[i]);
2508         }
2509 
2510     }
2511 
2512     /**
2513      * @notice Allow a user to withdraw any SNX in their schedule that have vested.
2514      */
2515     function vest()
2516         external
2517     {
2518         uint numEntries = numVestingEntries(msg.sender);
2519         uint total;
2520         for (uint i = 0; i < numEntries; i++) {
2521             uint time = getVestingTime(msg.sender, i);
2522             /* The list is sorted; when we reach the first future time, bail out. */
2523             if (time > now) {
2524                 break;
2525             }
2526             uint qty = getVestingQuantity(msg.sender, i);
2527             if (qty == 0) {
2528                 continue;
2529             }
2530 
2531             vestingSchedules[msg.sender][i] = [0, 0];
2532             total = total.add(qty);
2533         }
2534 
2535         if (total != 0) {
2536             totalVestedBalance = totalVestedBalance.sub(total);
2537             totalVestedAccountBalance[msg.sender] = totalVestedAccountBalance[msg.sender].sub(total);
2538             synthetix.transfer(msg.sender, total);
2539             emit Vested(msg.sender, now, total);
2540         }
2541     }
2542 
2543 
2544     /* ========== EVENTS ========== */
2545 
2546     event SynthetixUpdated(address newSynthetix);
2547 
2548     event Vested(address indexed beneficiary, uint time, uint value);
2549 }
2550 
2551 
2552 /*
2553 -----------------------------------------------------------------
2554 FILE INFORMATION
2555 -----------------------------------------------------------------
2556 
2557 file:       SynthetixState.sol
2558 version:    1.0
2559 author:     Kevin Brown
2560 date:       2018-10-19
2561 
2562 -----------------------------------------------------------------
2563 MODULE DESCRIPTION
2564 -----------------------------------------------------------------
2565 
2566 A contract that holds issuance state and preferred currency of
2567 users in the Synthetix system.
2568 
2569 This contract is used side by side with the Synthetix contract
2570 to make it easier to upgrade the contract logic while maintaining
2571 issuance state.
2572 
2573 The Synthetix contract is also quite large and on the edge of
2574 being beyond the contract size limit without moving this information
2575 out to another contract.
2576 
2577 The first deployed contract would create this state contract,
2578 using it as its store of issuance data.
2579 
2580 When a new contract is deployed, it links to the existing
2581 state contract, whose owner would then change its associated
2582 contract to the new one.
2583 
2584 -----------------------------------------------------------------
2585 */
2586 
2587 
2588 /**
2589  * @title Synthetix State
2590  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
2591  */
2592 contract SynthetixState is State, LimitedSetup {
2593     using SafeMath for uint;
2594     using SafeDecimalMath for uint;
2595 
2596     // A struct for handing values associated with an individual user's debt position
2597     struct IssuanceData {
2598         // Percentage of the total debt owned at the time
2599         // of issuance. This number is modified by the global debt
2600         // delta array. You can figure out a user's exit price and
2601         // collateralisation ratio using a combination of their initial
2602         // debt and the slice of global debt delta which applies to them.
2603         uint initialDebtOwnership;
2604         // This lets us know when (in relative terms) the user entered
2605         // the debt pool so we can calculate their exit price and
2606         // collateralistion ratio
2607         uint debtEntryIndex;
2608     }
2609 
2610     // Issued synth balances for individual fee entitlements and exit price calculations
2611     mapping(address => IssuanceData) public issuanceData;
2612 
2613     // The total count of people that have outstanding issued synths in any flavour
2614     uint public totalIssuerCount;
2615 
2616     // Global debt pool tracking
2617     uint[] public debtLedger;
2618 
2619     // Import state
2620     uint public importedXDRAmount;
2621 
2622     // A quantity of synths greater than this ratio
2623     // may not be issued against a given value of SNX.
2624     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
2625     // No more synths may be issued than the value of SNX backing them.
2626     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
2627 
2628     // Users can specify their preferred currency, in which case all synths they receive
2629     // will automatically exchange to that preferred currency upon receipt in their wallet
2630     mapping(address => bytes4) public preferredCurrency;
2631 
2632     /**
2633      * @dev Constructor
2634      * @param _owner The address which controls this contract.
2635      * @param _associatedContract The ERC20 contract whose state this composes.
2636      */
2637     constructor(address _owner, address _associatedContract)
2638         State(_owner, _associatedContract)
2639         LimitedSetup(1 weeks)
2640         public
2641     {}
2642 
2643     /* ========== SETTERS ========== */
2644 
2645     /**
2646      * @notice Set issuance data for an address
2647      * @dev Only the associated contract may call this.
2648      * @param account The address to set the data for.
2649      * @param initialDebtOwnership The initial debt ownership for this address.
2650      */
2651     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
2652         external
2653         onlyAssociatedContract
2654     {
2655         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
2656         issuanceData[account].debtEntryIndex = debtLedger.length;
2657     }
2658 
2659     /**
2660      * @notice Clear issuance data for an address
2661      * @dev Only the associated contract may call this.
2662      * @param account The address to clear the data for.
2663      */
2664     function clearIssuanceData(address account)
2665         external
2666         onlyAssociatedContract
2667     {
2668         delete issuanceData[account];
2669     }
2670 
2671     /**
2672      * @notice Increment the total issuer count
2673      * @dev Only the associated contract may call this.
2674      */
2675     function incrementTotalIssuerCount()
2676         external
2677         onlyAssociatedContract
2678     {
2679         totalIssuerCount = totalIssuerCount.add(1);
2680     }
2681 
2682     /**
2683      * @notice Decrement the total issuer count
2684      * @dev Only the associated contract may call this.
2685      */
2686     function decrementTotalIssuerCount()
2687         external
2688         onlyAssociatedContract
2689     {
2690         totalIssuerCount = totalIssuerCount.sub(1);
2691     }
2692 
2693     /**
2694      * @notice Append a value to the debt ledger
2695      * @dev Only the associated contract may call this.
2696      * @param value The new value to be added to the debt ledger.
2697      */
2698     function appendDebtLedgerValue(uint value)
2699         external
2700         onlyAssociatedContract
2701     {
2702         debtLedger.push(value);
2703     }
2704 
2705     /**
2706      * @notice Set preferred currency for a user
2707      * @dev Only the associated contract may call this.
2708      * @param account The account to set the preferred currency for
2709      * @param currencyKey The new preferred currency
2710      */
2711     function setPreferredCurrency(address account, bytes4 currencyKey)
2712         external
2713         onlyAssociatedContract
2714     {
2715         preferredCurrency[account] = currencyKey;
2716     }
2717 
2718     /**
2719      * @notice Set the issuanceRatio for issuance calculations.
2720      * @dev Only callable by the contract owner.
2721      */
2722     function setIssuanceRatio(uint _issuanceRatio)
2723         external
2724         onlyOwner
2725     {
2726         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
2727         issuanceRatio = _issuanceRatio;
2728         emit IssuanceRatioUpdated(_issuanceRatio);
2729     }
2730 
2731     /**
2732      * @notice Import issuer data from the old Synthetix contract before multicurrency
2733      * @dev Only callable by the contract owner, and only for 1 week after deployment.
2734      */
2735     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
2736         external
2737         onlyOwner
2738         onlyDuringSetup
2739     {
2740         require(accounts.length == sUSDAmounts.length, "Length mismatch");
2741 
2742         for (uint8 i = 0; i < accounts.length; i++) {
2743             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
2744         }
2745     }
2746 
2747     /**
2748      * @notice Import issuer data from the old Synthetix contract before multicurrency
2749      * @dev Only used from importIssuerData above, meant to be disposable
2750      */
2751     function _addToDebtRegister(address account, uint amount)
2752         internal
2753     {
2754         // This code is duplicated from Synthetix so that we can call it directly here
2755         // during setup only.
2756         Synthetix synthetix = Synthetix(associatedContract);
2757 
2758         // What is the value of the requested debt in XDRs?
2759         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
2760 
2761         // What is the value that we've previously imported?
2762         uint totalDebtIssued = importedXDRAmount;
2763 
2764         // What will the new total be including the new value?
2765         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2766 
2767         // Save that for the next import.
2768         importedXDRAmount = newTotalDebtIssued;
2769 
2770         // What is their percentage (as a high precision int) of the total debt?
2771         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2772 
2773         // And what effect does this percentage have on the global debt holding of other issuers?
2774         // The delta specifically needs to not take into account any existing debt as it's already
2775         // accounted for in the delta from when they issued previously.
2776         // The delta is a high precision integer.
2777         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2778 
2779         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
2780 
2781         // And what does their debt ownership look like including this previous stake?
2782         if (existingDebt > 0) {
2783             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2784         }
2785 
2786         // Are they a new issuer? If so, record them.
2787         if (issuanceData[account].initialDebtOwnership == 0) {
2788             totalIssuerCount = totalIssuerCount.add(1);
2789         }
2790 
2791         // Save the debt entry parameters
2792         issuanceData[account].initialDebtOwnership = debtPercentage;
2793         issuanceData[account].debtEntryIndex = debtLedger.length;
2794 
2795         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2796         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2797         if (debtLedger.length > 0) {
2798             debtLedger.push(
2799                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2800             );
2801         } else {
2802             debtLedger.push(SafeDecimalMath.preciseUnit());
2803         }
2804     }
2805 
2806     /* ========== VIEWS ========== */
2807 
2808     /**
2809      * @notice Retrieve the length of the debt ledger array
2810      */
2811     function debtLedgerLength()
2812         external
2813         view
2814         returns (uint)
2815     {
2816         return debtLedger.length;
2817     }
2818 
2819     /**
2820      * @notice Retrieve the most recent entry from the debt ledger
2821      */
2822     function lastDebtLedgerEntry()
2823         external
2824         view
2825         returns (uint)
2826     {
2827         return debtLedger[debtLedger.length - 1];
2828     }
2829 
2830     /**
2831      * @notice Query whether an account has issued and has an outstanding debt balance
2832      * @param account The address to query for
2833      */
2834     function hasIssued(address account)
2835         external
2836         view
2837         returns (bool)
2838     {
2839         return issuanceData[account].initialDebtOwnership > 0;
2840     }
2841 
2842     event IssuanceRatioUpdated(uint newRatio);
2843 }
2844 
2845 
2846 /*
2847 -----------------------------------------------------------------
2848 FILE INFORMATION
2849 -----------------------------------------------------------------
2850 
2851 file:       ExchangeRates.sol
2852 version:    1.0
2853 author:     Kevin Brown
2854 date:       2018-09-12
2855 
2856 -----------------------------------------------------------------
2857 MODULE DESCRIPTION
2858 -----------------------------------------------------------------
2859 
2860 A contract that any other contract in the Synthetix system can query
2861 for the current market value of various assets, including
2862 crypto assets as well as various fiat assets.
2863 
2864 This contract assumes that rate updates will completely update
2865 all rates to their current values. If a rate shock happens
2866 on a single asset, the oracle will still push updated rates
2867 for all other assets.
2868 
2869 -----------------------------------------------------------------
2870 */
2871 
2872 
2873 /**
2874  * @title The repository for exchange rates
2875  */
2876 contract ExchangeRates is SelfDestructible {
2877 
2878     using SafeMath for uint;
2879 
2880     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
2881     mapping(bytes4 => uint) public rates;
2882 
2883     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
2884     mapping(bytes4 => uint) public lastRateUpdateTimes;
2885 
2886     // The address of the oracle which pushes rate updates to this contract
2887     address public oracle;
2888 
2889     // Do not allow the oracle to submit times any further forward into the future than this constant.
2890     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
2891 
2892     // How long will the contract assume the rate of any asset is correct
2893     uint public rateStalePeriod = 3 hours;
2894 
2895     // Each participating currency in the XDR basket is represented as a currency key with
2896     // equal weighting.
2897     // There are 5 participating currencies, so we'll declare that clearly.
2898     bytes4[5] public xdrParticipants;
2899 
2900     //
2901     // ========== CONSTRUCTOR ==========
2902 
2903     /**
2904      * @dev Constructor
2905      * @param _owner The owner of this contract.
2906      * @param _oracle The address which is able to update rate information.
2907      * @param _currencyKeys The initial currency keys to store (in order).
2908      * @param _newRates The initial currency amounts for each currency (in order).
2909      */
2910     constructor(
2911         // SelfDestructible (Ownable)
2912         address _owner,
2913 
2914         // Oracle values - Allows for rate updates
2915         address _oracle,
2916         bytes4[] _currencyKeys,
2917         uint[] _newRates
2918     )
2919         /* Owned is initialised in SelfDestructible */
2920         SelfDestructible(_owner)
2921         public
2922     {
2923         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
2924 
2925         oracle = _oracle;
2926 
2927         // The sUSD rate is always 1 and is never stale.
2928         rates["sUSD"] = SafeDecimalMath.unit();
2929         lastRateUpdateTimes["sUSD"] = now;
2930 
2931         // These are the currencies that make up the XDR basket.
2932         // These are hard coded because:
2933         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
2934         //  - Adding new currencies would likely introduce some kind of weighting factor, which
2935         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
2936         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
2937         //    then point the system at the new version.
2938         xdrParticipants = [
2939             bytes4("sUSD"),
2940             bytes4("sAUD"),
2941             bytes4("sCHF"),
2942             bytes4("sEUR"),
2943             bytes4("sGBP")
2944         ];
2945 
2946         internalUpdateRates(_currencyKeys, _newRates, now);
2947     }
2948 
2949     /* ========== SETTERS ========== */
2950 
2951     /**
2952      * @notice Set the rates stored in this contract
2953      * @param currencyKeys The currency keys you wish to update the rates for (in order)
2954      * @param newRates The rates for each currency (in order)
2955      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
2956      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
2957      *                 if it takes a long time for the transaction to confirm.
2958      */
2959     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
2960         external
2961         onlyOracle
2962         returns(bool)
2963     {
2964         return internalUpdateRates(currencyKeys, newRates, timeSent);
2965     }
2966 
2967     /**
2968      * @notice Internal function which sets the rates stored in this contract
2969      * @param currencyKeys The currency keys you wish to update the rates for (in order)
2970      * @param newRates The rates for each currency (in order)
2971      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
2972      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
2973      *                 if it takes a long time for the transaction to confirm.
2974      */
2975     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
2976         internal
2977         returns(bool)
2978     {
2979         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
2980         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
2981 
2982         // Loop through each key and perform update.
2983         for (uint i = 0; i < currencyKeys.length; i++) {
2984             // Should not set any rate to zero ever, as no asset will ever be
2985             // truely worthless and still valid. In this scenario, we should
2986             // delete the rate and remove it from the system.
2987             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
2988             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
2989 
2990             // We should only update the rate if it's at least the same age as the last rate we've got.
2991             if (timeSent >= lastRateUpdateTimes[currencyKeys[i]]) {
2992                 // Ok, go ahead with the update.
2993                 rates[currencyKeys[i]] = newRates[i];
2994                 lastRateUpdateTimes[currencyKeys[i]] = timeSent;
2995             }
2996         }
2997 
2998         emit RatesUpdated(currencyKeys, newRates);
2999 
3000         // Now update our XDR rate.
3001         updateXDRRate(timeSent);
3002 
3003         return true;
3004     }
3005 
3006     /**
3007      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
3008      */
3009     function updateXDRRate(uint timeSent)
3010         internal
3011     {
3012         uint total = 0;
3013 
3014         for (uint i = 0; i < xdrParticipants.length; i++) {
3015             total = rates[xdrParticipants[i]].add(total);
3016         }
3017 
3018         // Set the rate
3019         rates["XDR"] = total;
3020 
3021         // Record that we updated the XDR rate.
3022         lastRateUpdateTimes["XDR"] = timeSent;
3023 
3024         // Emit our updated event separate to the others to save
3025         // moving data around between arrays.
3026         bytes4[] memory eventCurrencyCode = new bytes4[](1);
3027         eventCurrencyCode[0] = "XDR";
3028 
3029         uint[] memory eventRate = new uint[](1);
3030         eventRate[0] = rates["XDR"];
3031 
3032         emit RatesUpdated(eventCurrencyCode, eventRate);
3033     }
3034 
3035     /**
3036      * @notice Delete a rate stored in the contract
3037      * @param currencyKey The currency key you wish to delete the rate for
3038      */
3039     function deleteRate(bytes4 currencyKey)
3040         external
3041         onlyOracle
3042     {
3043         require(rates[currencyKey] > 0, "Rate is zero");
3044 
3045         delete rates[currencyKey];
3046         delete lastRateUpdateTimes[currencyKey];
3047 
3048         emit RateDeleted(currencyKey);
3049     }
3050 
3051     /**
3052      * @notice Set the Oracle that pushes the rate information to this contract
3053      * @param _oracle The new oracle address
3054      */
3055     function setOracle(address _oracle)
3056         external
3057         onlyOwner
3058     {
3059         oracle = _oracle;
3060         emit OracleUpdated(oracle);
3061     }
3062 
3063     /**
3064      * @notice Set the stale period on the updated rate variables
3065      * @param _time The new rateStalePeriod
3066      */
3067     function setRateStalePeriod(uint _time)
3068         external
3069         onlyOwner
3070     {
3071         rateStalePeriod = _time;
3072         emit RateStalePeriodUpdated(rateStalePeriod);
3073     }
3074 
3075     /* ========== VIEWS ========== */
3076 
3077     /**
3078      * @notice Retrieve the rate for a specific currency
3079      */
3080     function rateForCurrency(bytes4 currencyKey)
3081         public
3082         view
3083         returns (uint)
3084     {
3085         return rates[currencyKey];
3086     }
3087 
3088     /**
3089      * @notice Retrieve the rates for a list of currencies
3090      */
3091     function ratesForCurrencies(bytes4[] currencyKeys)
3092         public
3093         view
3094         returns (uint[])
3095     {
3096         uint[] memory _rates = new uint[](currencyKeys.length);
3097 
3098         for (uint8 i = 0; i < currencyKeys.length; i++) {
3099             _rates[i] = rates[currencyKeys[i]];
3100         }
3101 
3102         return _rates;
3103     }
3104 
3105     /**
3106      * @notice Retrieve a list of last update times for specific currencies
3107      */
3108     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
3109         public
3110         view
3111         returns (uint)
3112     {
3113         return lastRateUpdateTimes[currencyKey];
3114     }
3115 
3116     /**
3117      * @notice Retrieve the last update time for a specific currency
3118      */
3119     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
3120         public
3121         view
3122         returns (uint[])
3123     {
3124         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
3125 
3126         for (uint8 i = 0; i < currencyKeys.length; i++) {
3127             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
3128         }
3129 
3130         return lastUpdateTimes;
3131     }
3132 
3133     /**
3134      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
3135      */
3136     function rateIsStale(bytes4 currencyKey)
3137         external
3138         view
3139         returns (bool)
3140     {
3141         // sUSD is a special case and is never stale.
3142         if (currencyKey == "sUSD") return false;
3143 
3144         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
3145     }
3146 
3147     /**
3148      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
3149      */
3150     function anyRateIsStale(bytes4[] currencyKeys)
3151         external
3152         view
3153         returns (bool)
3154     {
3155         // Loop through each key and check whether the data point is stale.
3156         uint256 i = 0;
3157 
3158         while (i < currencyKeys.length) {
3159             // sUSD is a special case and is never false
3160             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
3161                 return true;
3162             }
3163             i += 1;
3164         }
3165 
3166         return false;
3167     }
3168 
3169     /* ========== MODIFIERS ========== */
3170 
3171     modifier onlyOracle
3172     {
3173         require(msg.sender == oracle, "Only the oracle can perform this action");
3174         _;
3175     }
3176 
3177     /* ========== EVENTS ========== */
3178 
3179     event OracleUpdated(address newOracle);
3180     event RateStalePeriodUpdated(uint rateStalePeriod);
3181     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
3182     event RateDeleted(bytes4 currencyKey);
3183 }
3184 
3185 
3186 /*
3187 -----------------------------------------------------------------
3188 FILE INFORMATION
3189 -----------------------------------------------------------------
3190 
3191 file:       Synthetix.sol
3192 version:    2.0
3193 author:     Kevin Brown
3194             Gavin Conway
3195 date:       2018-09-14
3196 
3197 -----------------------------------------------------------------
3198 MODULE DESCRIPTION
3199 -----------------------------------------------------------------
3200 
3201 Synthetix token contract. SNX is a transferable ERC20 token,
3202 and also give its holders the following privileges.
3203 An owner of SNX has the right to issue synths in all synth flavours.
3204 
3205 After a fee period terminates, the duration and fees collected for that
3206 period are computed, and the next period begins. Thus an account may only
3207 withdraw the fees owed to them for the previous period, and may only do
3208 so once per period. Any unclaimed fees roll over into the common pot for
3209 the next period.
3210 
3211 == Average Balance Calculations ==
3212 
3213 The fee entitlement of a synthetix holder is proportional to their average
3214 issued synth balance over the last fee period. This is computed by
3215 measuring the area under the graph of a user's issued synth balance over
3216 time, and then when a new fee period begins, dividing through by the
3217 duration of the fee period.
3218 
3219 We need only update values when the balances of an account is modified.
3220 This occurs when issuing or burning for issued synth balances,
3221 and when transferring for synthetix balances. This is for efficiency,
3222 and adds an implicit friction to interacting with SNX.
3223 A synthetix holder pays for his own recomputation whenever he wants to change
3224 his position, which saves the foundation having to maintain a pot dedicated
3225 to resourcing this.
3226 
3227 A hypothetical user's balance history over one fee period, pictorially:
3228 
3229       s ____
3230        |    |
3231        |    |___ p
3232        |____|___|___ __ _  _
3233        f    t   n
3234 
3235 Here, the balance was s between times f and t, at which time a transfer
3236 occurred, updating the balance to p, until n, when the present transfer occurs.
3237 When a new transfer occurs at time n, the balance being p,
3238 we must:
3239 
3240   - Add the area p * (n - t) to the total area recorded so far
3241   - Update the last transfer time to n
3242 
3243 So if this graph represents the entire current fee period,
3244 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
3245 The complementary computations must be performed for both sender and
3246 recipient.
3247 
3248 Note that a transfer keeps global supply of SNX invariant.
3249 The sum of all balances is constant, and unmodified by any transfer.
3250 So the sum of all balances multiplied by the duration of a fee period is also
3251 constant, and this is equivalent to the sum of the area of every user's
3252 time/balance graph. Dividing through by that duration yields back the total
3253 synthetix supply. So, at the end of a fee period, we really do yield a user's
3254 average share in the synthetix supply over that period.
3255 
3256 A slight wrinkle is introduced if we consider the time r when the fee period
3257 rolls over. Then the previous fee period k-1 is before r, and the current fee
3258 period k is afterwards. If the last transfer took place before r,
3259 but the latest transfer occurred afterwards:
3260 
3261 k-1       |        k
3262       s __|_
3263        |  | |
3264        |  | |____ p
3265        |__|_|____|___ __ _  _
3266           |
3267        f  | t    n
3268           r
3269 
3270 In this situation the area (r-f)*s contributes to fee period k-1, while
3271 the area (t-r)*s contributes to fee period k. We will implicitly consider a
3272 zero-value transfer to have occurred at time r. Their fee entitlement for the
3273 previous period will be finalised at the time of their first transfer during the
3274 current fee period, or when they query or withdraw their fee entitlement.
3275 
3276 In the implementation, the duration of different fee periods may be slightly irregular,
3277 as the check that they have rolled over occurs only when state-changing synthetix
3278 operations are performed.
3279 
3280 == Issuance and Burning ==
3281 
3282 In this version of the synthetix contract, synths can only be issued by
3283 those that have been nominated by the synthetix foundation. Synths are assumed
3284 to be valued at $1, as they are a stable unit of account.
3285 
3286 All synths issued require a proportional value of SNX to be locked,
3287 where the proportion is governed by the current issuance ratio. This
3288 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
3289 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
3290 
3291 To determine the value of some amount of SNX(S), an oracle is used to push
3292 the price of SNX (P_S) in dollars to the contract. The value of S
3293 would then be: S * P_S.
3294 
3295 Any SNX that are locked up by this issuance process cannot be transferred.
3296 The amount that is locked floats based on the price of SNX. If the price
3297 of SNX moves up, less SNX are locked, so they can be issued against,
3298 or transferred freely. If the price of SNX moves down, more SNX are locked,
3299 even going above the initial wallet balance.
3300 
3301 -----------------------------------------------------------------
3302 */
3303 
3304 
3305 /**
3306  * @title Synthetix ERC20 contract.
3307  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
3308  * but it also computes the quantity of fees each synthetix holder is entitled to.
3309  */
3310 contract Synthetix is ExternStateToken {
3311 
3312     // ========== STATE VARIABLES ==========
3313 
3314     // Available Synths which can be used with the system
3315     Synth[] public availableSynths;
3316     mapping(bytes4 => Synth) public synths;
3317 
3318     FeePool public feePool;
3319     SynthetixEscrow public escrow;
3320     ExchangeRates public exchangeRates;
3321     SynthetixState public synthetixState;
3322 
3323     uint constant SYNTHETIX_SUPPLY = 1e8 * SafeDecimalMath.unit();
3324     string constant TOKEN_NAME = "Synthetix Network Token";
3325     string constant TOKEN_SYMBOL = "SNX";
3326     uint8 constant DECIMALS = 18;
3327 
3328     // ========== CONSTRUCTOR ==========
3329 
3330     /**
3331      * @dev Constructor
3332      * @param _tokenState A pre-populated contract containing token balances.
3333      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
3334      * @param _owner The owner of this contract.
3335      */
3336     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
3337         address _owner, ExchangeRates _exchangeRates, FeePool _feePool
3338     )
3339         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, SYNTHETIX_SUPPLY, DECIMALS, _owner)
3340         public
3341     {
3342         synthetixState = _synthetixState;
3343         exchangeRates = _exchangeRates;
3344         feePool = _feePool;
3345     }
3346 
3347     // ========== SETTERS ========== */
3348 
3349     /**
3350      * @notice Add an associated Synth contract to the Synthetix system
3351      * @dev Only the contract owner may call this.
3352      */
3353     function addSynth(Synth synth)
3354         external
3355         optionalProxy_onlyOwner
3356     {
3357         bytes4 currencyKey = synth.currencyKey();
3358 
3359         require(synths[currencyKey] == Synth(0), "Synth already exists");
3360 
3361         availableSynths.push(synth);
3362         synths[currencyKey] = synth;
3363 
3364         emitSynthAdded(currencyKey, synth);
3365     }
3366 
3367     /**
3368      * @notice Remove an associated Synth contract from the Synthetix system
3369      * @dev Only the contract owner may call this.
3370      */
3371     function removeSynth(bytes4 currencyKey)
3372         external
3373         optionalProxy_onlyOwner
3374     {
3375         require(synths[currencyKey] != address(0), "Synth does not exist");
3376         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
3377         require(currencyKey != "XDR", "Cannot remove XDR synth");
3378 
3379         // Save the address we're removing for emitting the event at the end.
3380         address synthToRemove = synths[currencyKey];
3381 
3382         // Remove the synth from the availableSynths array.
3383         for (uint8 i = 0; i < availableSynths.length; i++) {
3384             if (availableSynths[i] == synthToRemove) {
3385                 delete availableSynths[i];
3386 
3387                 // Copy the last synth into the place of the one we just deleted
3388                 // If there's only one synth, this is synths[0] = synths[0].
3389                 // If we're deleting the last one, it's also a NOOP in the same way.
3390                 availableSynths[i] = availableSynths[availableSynths.length - 1];
3391 
3392                 // Decrease the size of the array by one.
3393                 availableSynths.length--;
3394 
3395                 break;
3396             }
3397         }
3398 
3399         // And remove it from the synths mapping
3400         delete synths[currencyKey];
3401 
3402         emitSynthRemoved(currencyKey, synthToRemove);
3403     }
3404 
3405     /**
3406      * @notice Set the associated synthetix escrow contract.
3407      * @dev Only the contract owner may call this.
3408      */
3409     function setEscrow(SynthetixEscrow _escrow)
3410         external
3411         optionalProxy_onlyOwner
3412     {
3413         escrow = _escrow;
3414         // Note: No event here as our contract exceeds max contract size
3415         // with these events, and it's unlikely people will need to
3416         // track these events specifically.
3417     }
3418 
3419     /**
3420      * @notice Set the ExchangeRates contract address where rates are held.
3421      * @dev Only callable by the contract owner.
3422      */
3423     function setExchangeRates(ExchangeRates _exchangeRates)
3424         external
3425         optionalProxy_onlyOwner
3426     {
3427         exchangeRates = _exchangeRates;
3428         // Note: No event here as our contract exceeds max contract size
3429         // with these events, and it's unlikely people will need to
3430         // track these events specifically.
3431     }
3432 
3433     /**
3434      * @notice Set the synthetixState contract address where issuance data is held.
3435      * @dev Only callable by the contract owner.
3436      */
3437     function setSynthetixState(SynthetixState _synthetixState)
3438         external
3439         optionalProxy_onlyOwner
3440     {
3441         synthetixState = _synthetixState;
3442 
3443         emitStateContractChanged(_synthetixState);
3444     }
3445 
3446     /**
3447      * @notice Set your preferred currency. Note: This does not automatically exchange any balances you've held previously in
3448      * other synth currencies in this address, it will apply for any new payments you receive at this address.
3449      */
3450     function setPreferredCurrency(bytes4 currencyKey)
3451         external
3452         optionalProxy
3453     {
3454         require(currencyKey == 0 || !exchangeRates.rateIsStale(currencyKey), "Currency rate is stale or doesn't exist.");
3455 
3456         synthetixState.setPreferredCurrency(messageSender, currencyKey);
3457 
3458         emitPreferredCurrencyChanged(messageSender, currencyKey);
3459     }
3460 
3461     // ========== VIEWS ==========
3462 
3463     /**
3464      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
3465      * @param sourceCurrencyKey The currency the amount is specified in
3466      * @param sourceAmount The source amount, specified in UNIT base
3467      * @param destinationCurrencyKey The destination currency
3468      */
3469     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
3470         public
3471         view
3472         rateNotStale(sourceCurrencyKey)
3473         rateNotStale(destinationCurrencyKey)
3474         returns (uint)
3475     {
3476         // If there's no change in the currency, then just return the amount they gave us
3477         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
3478 
3479         // Calculate the effective value by going from source -> USD -> destination
3480         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
3481             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
3482     }
3483 
3484     /**
3485      * @notice Total amount of synths issued by the system, priced in currencyKey
3486      * @param currencyKey The currency to value the synths in
3487      */
3488     function totalIssuedSynths(bytes4 currencyKey)
3489         public
3490         view
3491         rateNotStale(currencyKey)
3492         returns (uint)
3493     {
3494         uint total = 0;
3495         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
3496 
3497         for (uint8 i = 0; i < availableSynths.length; i++) {
3498             // Ensure the rate isn't stale.
3499             // TODO: Investigate gas cost optimisation of doing a single call with all keys in it vs
3500             // individual calls like this.
3501             require(!exchangeRates.rateIsStale(availableSynths[i].currencyKey()), "Rate is stale");
3502 
3503             // What's the total issued value of that synth in the destination currency?
3504             // Note: We're not using our effectiveValue function because we don't want to go get the
3505             //       rate for the destination currency and check if it's stale repeatedly on every
3506             //       iteration of the loop
3507             uint synthValue = availableSynths[i].totalSupply()
3508                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
3509                 .divideDecimalRound(currencyRate);
3510             total = total.add(synthValue);
3511         }
3512 
3513         return total;
3514     }
3515 
3516     /**
3517      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
3518      */
3519     function availableSynthCount()
3520         public
3521         view
3522         returns (uint)
3523     {
3524         return availableSynths.length;
3525     }
3526 
3527     // ========== MUTATIVE FUNCTIONS ==========
3528 
3529     /**
3530      * @notice ERC20 transfer function.
3531      */
3532     function transfer(address to, uint value)
3533         public
3534         returns (bool)
3535     {
3536         bytes memory empty;
3537         return transfer(to, value, empty);
3538     }
3539 
3540     /**
3541      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
3542      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3543      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3544      *           tooling such as Etherscan.
3545      */
3546     function transfer(address to, uint value, bytes data)
3547         public
3548         optionalProxy
3549         returns (bool)
3550     {
3551         // Ensure they're not trying to exceed their locked amount
3552         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
3553 
3554         // Perform the transfer: if there is a problem an exception will be thrown in this call.
3555         _transfer_byProxy(messageSender, to, value, data);
3556 
3557         return true;
3558     }
3559 
3560     /**
3561      * @notice ERC20 transferFrom function.
3562      */
3563     function transferFrom(address from, address to, uint value)
3564         public
3565         returns (bool)
3566     {
3567         bytes memory empty;
3568         return transferFrom(from, to, value, empty);
3569     }
3570 
3571     /**
3572      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
3573      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3574      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3575      *           tooling such as Etherscan.
3576      */
3577     function transferFrom(address from, address to, uint value, bytes data)
3578         public
3579         optionalProxy
3580         returns (bool)
3581     {
3582         // Ensure they're not trying to exceed their locked amount
3583         require(value <= transferableSynthetix(from), "Insufficient balance");
3584 
3585         // Perform the transfer: if there is a problem,
3586         // an exception will be thrown in this call.
3587         _transferFrom_byProxy(messageSender, from, to, value, data);
3588 
3589         return true;
3590     }
3591 
3592     /**
3593      * @notice Function that allows you to exchange synths you hold in one flavour for another.
3594      * @param sourceCurrencyKey The source currency you wish to exchange from
3595      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3596      * @param destinationCurrencyKey The destination currency you wish to obtain.
3597      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
3598      * @return Boolean that indicates whether the transfer succeeded or failed.
3599      */
3600     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
3601         external
3602         optionalProxy
3603         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
3604         returns (bool)
3605     {
3606         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
3607         require(sourceAmount > 0, "Zero amount");
3608 
3609         // Pass it along, defaulting to the sender as the recipient.
3610         return _internalExchange(
3611             messageSender,
3612             sourceCurrencyKey,
3613             sourceAmount,
3614             destinationCurrencyKey,
3615             destinationAddress == address(0) ? messageSender : destinationAddress,
3616             true // Charge fee on the exchange
3617         );
3618     }
3619 
3620     /**
3621      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
3622      * @dev Only the synth contract can call this function
3623      * @param from The address to exchange / burn synth from
3624      * @param sourceCurrencyKey The source currency you wish to exchange from
3625      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3626      * @param destinationCurrencyKey The destination currency you wish to obtain.
3627      * @param destinationAddress Where the result should go.
3628      * @return Boolean that indicates whether the transfer succeeded or failed.
3629      */
3630     function synthInitiatedExchange(
3631         address from,
3632         bytes4 sourceCurrencyKey,
3633         uint sourceAmount,
3634         bytes4 destinationCurrencyKey,
3635         address destinationAddress
3636     )
3637         external
3638         onlySynth
3639         returns (bool)
3640     {
3641         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3642         require(sourceAmount > 0, "Zero amount");
3643 
3644         // Pass it along
3645         return _internalExchange(
3646             from,
3647             sourceCurrencyKey,
3648             sourceAmount,
3649             destinationCurrencyKey,
3650             destinationAddress,
3651             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
3652         );
3653     }
3654 
3655     /**
3656      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3657      * @dev Only the synth contract can call this function.
3658      * @param from The address fee is coming from.
3659      * @param sourceCurrencyKey source currency fee from.
3660      * @param sourceAmount The amount, specified in UNIT of source currency.
3661      * @return Boolean that indicates whether the transfer succeeded or failed.
3662      */
3663     function synthInitiatedFeePayment(
3664         address from,
3665         bytes4 sourceCurrencyKey,
3666         uint sourceAmount
3667     )
3668         external
3669         onlySynth
3670         returns (bool)
3671     {
3672         require(sourceAmount > 0, "Source can't be 0");
3673 
3674         // Pass it along, defaulting to the sender as the recipient.
3675         bool result = _internalExchange(
3676             from,
3677             sourceCurrencyKey,
3678             sourceAmount,
3679             "XDR",
3680             feePool.FEE_ADDRESS(),
3681             false // Don't charge a fee on the exchange because this is already a fee
3682         );
3683 
3684         // Tell the fee pool about this.
3685         feePool.feePaid(sourceCurrencyKey, sourceAmount);
3686 
3687         return result;
3688     }
3689 
3690     /**
3691      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3692      * @dev fee pool contract address is not allowed to call function
3693      * @param from The address to move synth from
3694      * @param sourceCurrencyKey source currency from.
3695      * @param sourceAmount The amount, specified in UNIT of source currency.
3696      * @param destinationCurrencyKey The destination currency to obtain.
3697      * @param destinationAddress Where the result should go.
3698      * @param chargeFee Boolean to charge a fee for transaction.
3699      * @return Boolean that indicates whether the transfer succeeded or failed.
3700      */
3701     function _internalExchange(
3702         address from,
3703         bytes4 sourceCurrencyKey,
3704         uint sourceAmount,
3705         bytes4 destinationCurrencyKey,
3706         address destinationAddress,
3707         bool chargeFee
3708     )
3709         internal
3710         notFeeAddress(from)
3711         returns (bool)
3712     {
3713         require(destinationAddress != address(0), "Zero destination");
3714         require(destinationAddress != address(this), "Synthetix is invalid destination");
3715         require(destinationAddress != address(proxy), "Proxy is invalid destination");
3716 
3717         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3718         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3719 
3720         // Burn the source amount
3721         synths[sourceCurrencyKey].burn(from, sourceAmount);
3722 
3723         // How much should they get in the destination currency?
3724         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3725 
3726         // What's the fee on that currency that we should deduct?
3727         uint amountReceived = destinationAmount;
3728         uint fee = 0;
3729 
3730         if (chargeFee) {
3731             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
3732             fee = destinationAmount.sub(amountReceived);
3733         }
3734 
3735         // Issue their new synths
3736         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3737 
3738         // Remit the fee in XDRs
3739         if (fee > 0) {
3740             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3741             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3742         }
3743 
3744         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3745 
3746         // Call the ERC223 transfer callback if needed
3747         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
3748 
3749         // Gas optimisation:
3750         // No event emitted as it's assumed users will be able to track transfers to the zero address, followed
3751         // by a transfer on another synth from the zero address and ascertain the info required here.
3752 
3753         return true;
3754     }
3755 
3756     /**
3757      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
3758      * @dev Only internal calls from synthetix address.
3759      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3760      * @param amount The amount of synths to register with a base of UNIT
3761      */
3762     function _addToDebtRegister(bytes4 currencyKey, uint amount)
3763         internal
3764         optionalProxy
3765     {
3766         // What is the value of the requested debt in XDRs?
3767         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3768 
3769         // What is the value of all issued synths of the system (priced in XDRs)?
3770         uint totalDebtIssued = totalIssuedSynths("XDR");
3771 
3772         // What will the new total be including the new value?
3773         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3774 
3775         // What is their percentage (as a high precision int) of the total debt?
3776         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3777 
3778         // And what effect does this percentage have on the global debt holding of other issuers?
3779         // The delta specifically needs to not take into account any existing debt as it's already
3780         // accounted for in the delta from when they issued previously.
3781         // The delta is a high precision integer.
3782         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3783 
3784         // How much existing debt do they have?
3785         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3786 
3787         // And what does their debt ownership look like including this previous stake?
3788         if (existingDebt > 0) {
3789             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3790         }
3791 
3792         // Are they a new issuer? If so, record them.
3793         if (!synthetixState.hasIssued(messageSender)) {
3794             synthetixState.incrementTotalIssuerCount();
3795         }
3796 
3797         // Save the debt entry parameters
3798         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3799 
3800         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3801         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3802         if (synthetixState.debtLedgerLength() > 0) {
3803             synthetixState.appendDebtLedgerValue(
3804                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3805             );
3806         } else {
3807             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3808         }
3809     }
3810 
3811     /**
3812      * @notice Issue synths against the sender's SNX.
3813      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3814      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3815      * @param amount The amount of synths you wish to issue with a base of UNIT
3816      */
3817     function issueSynths(bytes4 currencyKey, uint amount)
3818         public
3819         optionalProxy
3820         nonZeroAmount(amount)
3821         // No need to check if price is stale, as it is checked in issuableSynths.
3822     {
3823         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3824 
3825         // Keep track of the debt they're about to create
3826         _addToDebtRegister(currencyKey, amount);
3827 
3828         // Create their synths
3829         synths[currencyKey].issue(messageSender, amount);
3830     }
3831 
3832     /**
3833      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3834      * @dev Issuance is only allowed if the synthetix price isn't stale.
3835      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3836      */
3837     function issueMaxSynths(bytes4 currencyKey)
3838         external
3839         optionalProxy
3840     {
3841         // Figure out the maximum we can issue in that currency
3842         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3843 
3844         // And issue them
3845         issueSynths(currencyKey, maxIssuable);
3846     }
3847 
3848     /**
3849      * @notice Burn synths to clear issued synths/free SNX.
3850      * @param currencyKey The currency you're specifying to burn
3851      * @param amount The amount (in UNIT base) you wish to burn
3852      */
3853     function burnSynths(bytes4 currencyKey, uint amount)
3854         external
3855         optionalProxy
3856         // No need to check for stale rates as _removeFromDebtRegister calls effectiveValue
3857         // which does this for us
3858     {
3859         // How much debt do they have?
3860         uint debt = debtBalanceOf(messageSender, currencyKey);
3861 
3862         require(debt > 0, "No debt to forgive");
3863 
3864         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3865         // clear their debt and leave them be.
3866         uint amountToBurn = debt < amount ? debt : amount;
3867 
3868         // Remove their debt from the ledger
3869         _removeFromDebtRegister(currencyKey, amountToBurn);
3870 
3871         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3872         synths[currencyKey].burn(messageSender, amountToBurn);
3873     }
3874 
3875     /**
3876      * @notice Remove a debt position from the register
3877      * @param currencyKey The currency the user is presenting to forgive their debt
3878      * @param amount The amount (in UNIT base) being presented
3879      */
3880     function _removeFromDebtRegister(bytes4 currencyKey, uint amount)
3881         internal
3882     {
3883         // How much debt are they trying to remove in XDRs?
3884         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3885 
3886         // How much debt do they have?
3887         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3888 
3889         // What percentage of the total debt are they trying to remove?
3890         uint totalDebtIssued = totalIssuedSynths("XDR");
3891         uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(totalDebtIssued);
3892 
3893         // And what effect does this percentage have on the global debt holding of other issuers?
3894         // The delta specifically needs to not take into account any existing debt as it's already
3895         // accounted for in the delta from when they issued previously.
3896         uint delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3897 
3898         // Are they exiting the system, or are they just decreasing their debt position?
3899         if (debtToRemove == existingDebt) {
3900             synthetixState.clearIssuanceData(messageSender);
3901             synthetixState.decrementTotalIssuerCount();
3902         } else {
3903             // What percentage of the debt will they be left with?
3904             uint newDebt = existingDebt.sub(debtToRemove);
3905             uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3906             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3907 
3908             // Store the debt percentage and debt ledger as high precision integers
3909             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3910         }
3911 
3912         // Update our cumulative ledger. This is also a high precision integer.
3913         synthetixState.appendDebtLedgerValue(
3914             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3915         );
3916     }
3917 
3918     // ========== Issuance/Burning ==========
3919 
3920     /**
3921      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3922      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3923      */
3924     function maxIssuableSynths(address issuer, bytes4 currencyKey)
3925         public
3926         view
3927         // We don't need to check stale rates here as effectiveValue will do it for us.
3928         returns (uint)
3929     {
3930         // What is the value of their SNX balance in the destination currency?
3931         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3932 
3933         // They're allowed to issue up to issuanceRatio of that value
3934         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3935     }
3936 
3937     /**
3938      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3939      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
3940      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3941      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
3942      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3943      * altering the amount of fees they're able to claim from the system.
3944      */
3945     function collateralisationRatio(address issuer)
3946         public
3947         view
3948         returns (uint)
3949     {
3950         uint totalOwnedSynthetix = collateral(issuer);
3951         if (totalOwnedSynthetix == 0) return 0;
3952 
3953         uint debtBalance = debtBalanceOf(issuer, "SNX");
3954         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3955     }
3956 
3957 /**
3958      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3959      * will tell you how many synths a user has to give back to the system in order to unlock their original
3960      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3961      * the debt in sUSD, XDR, or any other synth you wish.
3962      */
3963     function debtBalanceOf(address issuer, bytes4 currencyKey)
3964         public
3965         view
3966         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3967         returns (uint)
3968     {
3969         // What was their initial debt ownership?
3970         uint initialDebtOwnership;
3971         uint debtEntryIndex;
3972         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3973 
3974         // If it's zero, they haven't issued, and they have no debt.
3975         if (initialDebtOwnership == 0) return 0;
3976 
3977         // Figure out the global debt percentage delta from when they entered the system.
3978         // This is a high precision integer.
3979         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3980             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3981             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3982 
3983         // What's the total value of the system in their requested currency?
3984         uint totalSystemValue = totalIssuedSynths(currencyKey);
3985 
3986         // Their debt balance is their portion of the total system value.
3987         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3988             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3989 
3990         return highPrecisionBalance.preciseDecimalToDecimal();
3991     }
3992 
3993     /**
3994      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3995      * @param issuer The account that intends to issue
3996      * @param currencyKey The currency to price issuable value in
3997      */
3998     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
3999         public
4000         view
4001         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
4002         returns (uint)
4003     {
4004         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
4005         uint max = maxIssuableSynths(issuer, currencyKey);
4006 
4007         if (alreadyIssued >= max) {
4008             return 0;
4009         } else {
4010             return max.sub(alreadyIssued);
4011         }
4012     }
4013 
4014     /**
4015      * @notice The total SNX owned by this account, both escrowed and unescrowed,
4016      * against which synths can be issued.
4017      * This includes those already being used as collateral (locked), and those
4018      * available for further issuance (unlocked).
4019      */
4020     function collateral(address account)
4021         public
4022         view
4023         returns (uint)
4024     {
4025         uint balance = tokenState.balanceOf(account);
4026 
4027         if (escrow != address(0)) {
4028             balance = balance.add(escrow.balanceOf(account));
4029         }
4030 
4031         return balance;
4032     }
4033 
4034     /**
4035      * @notice The number of SNX that are free to be transferred by an account.
4036      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
4037      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
4038      * in this calculation.
4039      */
4040     function transferableSynthetix(address account)
4041         public
4042         view
4043         rateNotStale("SNX")
4044         returns (uint)
4045     {
4046         // How many SNX do they have, excluding escrow?
4047         // Note: We're excluding escrow here because we're interested in their transferable amount
4048         // and escrowed SNX are not transferable.
4049         uint balance = tokenState.balanceOf(account);
4050 
4051         // How many of those will be locked by the amount they've issued?
4052         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
4053         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
4054         // The locked synthetix value can exceed their balance.
4055         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
4056 
4057         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
4058         if (lockedSynthetixValue >= balance) {
4059             return 0;
4060         } else {
4061             return balance.sub(lockedSynthetixValue);
4062         }
4063     }
4064 
4065     // ========== MODIFIERS ==========
4066 
4067     modifier rateNotStale(bytes4 currencyKey) {
4068         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
4069         _;
4070     }
4071 
4072     modifier notFeeAddress(address account) {
4073         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
4074         _;
4075     }
4076 
4077     modifier onlySynth() {
4078         bool isSynth = false;
4079 
4080         // No need to repeatedly call this function either
4081         for (uint8 i = 0; i < availableSynths.length; i++) {
4082             if (availableSynths[i] == msg.sender) {
4083                 isSynth = true;
4084                 break;
4085             }
4086         }
4087 
4088         require(isSynth, "Only synth allowed");
4089         _;
4090     }
4091 
4092     modifier nonZeroAmount(uint _amount) {
4093         require(_amount > 0, "Amount needs to be larger than 0");
4094         _;
4095     }
4096 
4097     // ========== EVENTS ==========
4098 
4099     event PreferredCurrencyChanged(address indexed account, bytes4 newPreferredCurrency);
4100     bytes32 constant PREFERREDCURRENCYCHANGED_SIG = keccak256("PreferredCurrencyChanged(address,bytes4)");
4101     function emitPreferredCurrencyChanged(address account, bytes4 newPreferredCurrency) internal {
4102         proxy._emit(abi.encode(newPreferredCurrency), 2, PREFERREDCURRENCYCHANGED_SIG, bytes32(account), 0, 0);
4103     }
4104 
4105     event StateContractChanged(address stateContract);
4106     bytes32 constant STATECONTRACTCHANGED_SIG = keccak256("StateContractChanged(address)");
4107     function emitStateContractChanged(address stateContract) internal {
4108         proxy._emit(abi.encode(stateContract), 1, STATECONTRACTCHANGED_SIG, 0, 0, 0);
4109     }
4110 
4111     event SynthAdded(bytes4 currencyKey, address newSynth);
4112     bytes32 constant SYNTHADDED_SIG = keccak256("SynthAdded(bytes4,address)");
4113     function emitSynthAdded(bytes4 currencyKey, address newSynth) internal {
4114         proxy._emit(abi.encode(currencyKey, newSynth), 1, SYNTHADDED_SIG, 0, 0, 0);
4115     }
4116 
4117     event SynthRemoved(bytes4 currencyKey, address removedSynth);
4118     bytes32 constant SYNTHREMOVED_SIG = keccak256("SynthRemoved(bytes4,address)");
4119     function emitSynthRemoved(bytes4 currencyKey, address removedSynth) internal {
4120         proxy._emit(abi.encode(currencyKey, removedSynth), 1, SYNTHREMOVED_SIG, 0, 0, 0);
4121     }
4122 }
4123 
