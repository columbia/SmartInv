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
1993 /*
1994 -----------------------------------------------------------------
1995 FILE INFORMATION
1996 -----------------------------------------------------------------
1997 
1998 file:       SynthetixState.sol
1999 version:    1.0
2000 author:     Kevin Brown
2001 date:       2018-10-19
2002 
2003 -----------------------------------------------------------------
2004 MODULE DESCRIPTION
2005 -----------------------------------------------------------------
2006 
2007 A contract that holds issuance state and preferred currency of
2008 users in the Synthetix system.
2009 
2010 This contract is used side by side with the Synthetix contract
2011 to make it easier to upgrade the contract logic while maintaining
2012 issuance state.
2013 
2014 The Synthetix contract is also quite large and on the edge of
2015 being beyond the contract size limit without moving this information
2016 out to another contract.
2017 
2018 The first deployed contract would create this state contract,
2019 using it as its store of issuance data.
2020 
2021 When a new contract is deployed, it links to the existing
2022 state contract, whose owner would then change its associated
2023 contract to the new one.
2024 
2025 -----------------------------------------------------------------
2026 */
2027 
2028 
2029 /**
2030  * @title Synthetix State
2031  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
2032  */
2033 contract SynthetixState is State, LimitedSetup {
2034     using SafeMath for uint;
2035     using SafeDecimalMath for uint;
2036 
2037     // A struct for handing values associated with an individual user's debt position
2038     struct IssuanceData {
2039         // Percentage of the total debt owned at the time
2040         // of issuance. This number is modified by the global debt
2041         // delta array. You can figure out a user's exit price and
2042         // collateralisation ratio using a combination of their initial
2043         // debt and the slice of global debt delta which applies to them.
2044         uint initialDebtOwnership;
2045         // This lets us know when (in relative terms) the user entered
2046         // the debt pool so we can calculate their exit price and
2047         // collateralistion ratio
2048         uint debtEntryIndex;
2049     }
2050 
2051     // Issued synth balances for individual fee entitlements and exit price calculations
2052     mapping(address => IssuanceData) public issuanceData;
2053 
2054     // The total count of people that have outstanding issued synths in any flavour
2055     uint public totalIssuerCount;
2056 
2057     // Global debt pool tracking
2058     uint[] public debtLedger;
2059 
2060     // Import state
2061     uint public importedXDRAmount;
2062 
2063     // A quantity of synths greater than this ratio
2064     // may not be issued against a given value of SNX.
2065     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
2066     // No more synths may be issued than the value of SNX backing them.
2067     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
2068 
2069     // Users can specify their preferred currency, in which case all synths they receive
2070     // will automatically exchange to that preferred currency upon receipt in their wallet
2071     mapping(address => bytes4) public preferredCurrency;
2072 
2073     /**
2074      * @dev Constructor
2075      * @param _owner The address which controls this contract.
2076      * @param _associatedContract The ERC20 contract whose state this composes.
2077      */
2078     constructor(address _owner, address _associatedContract)
2079         State(_owner, _associatedContract)
2080         LimitedSetup(1 weeks)
2081         public
2082     {}
2083 
2084     /* ========== SETTERS ========== */
2085 
2086     /**
2087      * @notice Set issuance data for an address
2088      * @dev Only the associated contract may call this.
2089      * @param account The address to set the data for.
2090      * @param initialDebtOwnership The initial debt ownership for this address.
2091      */
2092     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
2093         external
2094         onlyAssociatedContract
2095     {
2096         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
2097         issuanceData[account].debtEntryIndex = debtLedger.length;
2098     }
2099 
2100     /**
2101      * @notice Clear issuance data for an address
2102      * @dev Only the associated contract may call this.
2103      * @param account The address to clear the data for.
2104      */
2105     function clearIssuanceData(address account)
2106         external
2107         onlyAssociatedContract
2108     {
2109         delete issuanceData[account];
2110     }
2111 
2112     /**
2113      * @notice Increment the total issuer count
2114      * @dev Only the associated contract may call this.
2115      */
2116     function incrementTotalIssuerCount()
2117         external
2118         onlyAssociatedContract
2119     {
2120         totalIssuerCount = totalIssuerCount.add(1);
2121     }
2122 
2123     /**
2124      * @notice Decrement the total issuer count
2125      * @dev Only the associated contract may call this.
2126      */
2127     function decrementTotalIssuerCount()
2128         external
2129         onlyAssociatedContract
2130     {
2131         totalIssuerCount = totalIssuerCount.sub(1);
2132     }
2133 
2134     /**
2135      * @notice Append a value to the debt ledger
2136      * @dev Only the associated contract may call this.
2137      * @param value The new value to be added to the debt ledger.
2138      */
2139     function appendDebtLedgerValue(uint value)
2140         external
2141         onlyAssociatedContract
2142     {
2143         debtLedger.push(value);
2144     }
2145 
2146     /**
2147      * @notice Set preferred currency for a user
2148      * @dev Only the associated contract may call this.
2149      * @param account The account to set the preferred currency for
2150      * @param currencyKey The new preferred currency
2151      */
2152     function setPreferredCurrency(address account, bytes4 currencyKey)
2153         external
2154         onlyAssociatedContract
2155     {
2156         preferredCurrency[account] = currencyKey;
2157     }
2158 
2159     /**
2160      * @notice Set the issuanceRatio for issuance calculations.
2161      * @dev Only callable by the contract owner.
2162      */
2163     function setIssuanceRatio(uint _issuanceRatio)
2164         external
2165         onlyOwner
2166     {
2167         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
2168         issuanceRatio = _issuanceRatio;
2169         emit IssuanceRatioUpdated(_issuanceRatio);
2170     }
2171 
2172     /**
2173      * @notice Import issuer data from the old Synthetix contract before multicurrency
2174      * @dev Only callable by the contract owner, and only for 1 week after deployment.
2175      */
2176     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
2177         external
2178         onlyOwner
2179         onlyDuringSetup
2180     {
2181         require(accounts.length == sUSDAmounts.length, "Length mismatch");
2182 
2183         for (uint8 i = 0; i < accounts.length; i++) {
2184             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
2185         }
2186     }
2187 
2188     /**
2189      * @notice Import issuer data from the old Synthetix contract before multicurrency
2190      * @dev Only used from importIssuerData above, meant to be disposable
2191      */
2192     function _addToDebtRegister(address account, uint amount)
2193         internal
2194     {
2195         // This code is duplicated from Synthetix so that we can call it directly here
2196         // during setup only.
2197         Synthetix synthetix = Synthetix(associatedContract);
2198 
2199         // What is the value of the requested debt in XDRs?
2200         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
2201 
2202         // What is the value that we've previously imported?
2203         uint totalDebtIssued = importedXDRAmount;
2204 
2205         // What will the new total be including the new value?
2206         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2207 
2208         // Save that for the next import.
2209         importedXDRAmount = newTotalDebtIssued;
2210 
2211         // What is their percentage (as a high precision int) of the total debt?
2212         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2213 
2214         // And what effect does this percentage have on the global debt holding of other issuers?
2215         // The delta specifically needs to not take into account any existing debt as it's already
2216         // accounted for in the delta from when they issued previously.
2217         // The delta is a high precision integer.
2218         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2219 
2220         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
2221 
2222         // And what does their debt ownership look like including this previous stake?
2223         if (existingDebt > 0) {
2224             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2225         }
2226 
2227         // Are they a new issuer? If so, record them.
2228         if (issuanceData[account].initialDebtOwnership == 0) {
2229             totalIssuerCount = totalIssuerCount.add(1);
2230         }
2231 
2232         // Save the debt entry parameters
2233         issuanceData[account].initialDebtOwnership = debtPercentage;
2234         issuanceData[account].debtEntryIndex = debtLedger.length;
2235 
2236         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2237         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2238         if (debtLedger.length > 0) {
2239             debtLedger.push(
2240                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2241             );
2242         } else {
2243             debtLedger.push(SafeDecimalMath.preciseUnit());
2244         }
2245     }
2246 
2247     /* ========== VIEWS ========== */
2248 
2249     /**
2250      * @notice Retrieve the length of the debt ledger array
2251      */
2252     function debtLedgerLength()
2253         external
2254         view
2255         returns (uint)
2256     {
2257         return debtLedger.length;
2258     }
2259 
2260     /**
2261      * @notice Retrieve the most recent entry from the debt ledger
2262      */
2263     function lastDebtLedgerEntry()
2264         external
2265         view
2266         returns (uint)
2267     {
2268         return debtLedger[debtLedger.length - 1];
2269     }
2270 
2271     /**
2272      * @notice Query whether an account has issued and has an outstanding debt balance
2273      * @param account The address to query for
2274      */
2275     function hasIssued(address account)
2276         external
2277         view
2278         returns (bool)
2279     {
2280         return issuanceData[account].initialDebtOwnership > 0;
2281     }
2282 
2283     event IssuanceRatioUpdated(uint newRatio);
2284 }
2285 
2286 
2287 contract IFeePool {
2288     address public FEE_ADDRESS;
2289     function amountReceivedFromExchange(uint value) external view returns (uint);
2290     function amountReceivedFromTransfer(uint value) external view returns (uint);
2291     function feePaid(bytes4 currencyKey, uint amount) external;
2292     function appendAccountIssuanceRecord(address account, uint lockedAmount, uint debtEntryIndex) external;
2293     function rewardsMinted(uint amount) external;
2294     function transferFeeIncurred(uint value) public view returns (uint);
2295 }
2296 
2297 
2298 /*
2299 -----------------------------------------------------------------
2300 FILE INFORMATION
2301 -----------------------------------------------------------------
2302 
2303 file:       Synth.sol
2304 version:    2.0
2305 author:     Kevin Brown
2306 date:       2018-09-13
2307 
2308 -----------------------------------------------------------------
2309 MODULE DESCRIPTION
2310 -----------------------------------------------------------------
2311 
2312 Synthetix-backed stablecoin contract.
2313 
2314 This contract issues synths, which are tokens that mirror various
2315 flavours of fiat currency.
2316 
2317 Synths are issuable by Synthetix Network Token (SNX) holders who
2318 have to lock up some value of their SNX to issue S * Cmax synths.
2319 Where Cmax issome value less than 1.
2320 
2321 A configurable fee is charged on synth transfers and deposited
2322 into a common pot, which Synthetix holders may withdraw from once
2323 per fee period.
2324 
2325 -----------------------------------------------------------------
2326 */
2327 
2328 
2329 contract Synth is ExternStateToken {
2330 
2331     /* ========== STATE VARIABLES ========== */
2332 
2333     IFeePool public feePool;
2334     Synthetix public synthetix;
2335 
2336     // Currency key which identifies this Synth to the Synthetix system
2337     bytes4 public currencyKey;
2338 
2339     uint8 constant DECIMALS = 18;
2340 
2341     /* ========== CONSTRUCTOR ========== */
2342 
2343     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, IFeePool _feePool,
2344         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey
2345     )
2346         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, 0, DECIMALS, _owner)
2347         public
2348     {
2349         require(_proxy != 0, "_proxy cannot be 0");
2350         require(address(_synthetix) != 0, "_synthetix cannot be 0");
2351         require(address(_feePool) != 0, "_feePool cannot be 0");
2352         require(_owner != 0, "_owner cannot be 0");
2353         require(_synthetix.synths(_currencyKey) == Synth(0), "Currency key is already in use");
2354 
2355         feePool = _feePool;
2356         synthetix = _synthetix;
2357         currencyKey = _currencyKey;
2358     }
2359 
2360     /* ========== SETTERS ========== */
2361 
2362     function setSynthetix(Synthetix _synthetix)
2363         external
2364         optionalProxy_onlyOwner
2365     {
2366         synthetix = _synthetix;
2367         emitSynthetixUpdated(_synthetix);
2368     }
2369 
2370     function setFeePool(IFeePool _feePool)
2371         external
2372         optionalProxy_onlyOwner
2373     {
2374         feePool = _feePool;
2375         emitFeePoolUpdated(_feePool);
2376     }
2377 
2378     /* ========== MUTATIVE FUNCTIONS ========== */
2379 
2380     /**
2381      * @notice Override ERC20 transfer function in order to
2382      * subtract the transaction fee and send it to the fee pool
2383      * for SNX holders to claim. */
2384     function transfer(address to, uint value)
2385         public
2386         optionalProxy
2387         notFeeAddress(messageSender)
2388         returns (bool)
2389     {
2390         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2391         uint fee = value.sub(amountReceived);
2392 
2393         // Send the fee off to the fee pool.
2394         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
2395 
2396         // And send their result off to the destination address
2397         bytes memory empty;
2398         return _internalTransfer(messageSender, to, amountReceived, empty);
2399     }
2400 
2401     /**
2402      * @notice Override ERC223 transfer function in order to
2403      * subtract the transaction fee and send it to the fee pool
2404      * for SNX holders to claim. */
2405     function transfer(address to, uint value, bytes data)
2406         public
2407         optionalProxy
2408         notFeeAddress(messageSender)
2409         returns (bool)
2410     {
2411         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2412         uint fee = value.sub(amountReceived);
2413 
2414         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2415         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
2416 
2417         // And send their result off to the destination address
2418         return _internalTransfer(messageSender, to, amountReceived, data);
2419     }
2420 
2421     /**
2422      * @notice Override ERC20 transferFrom function in order to
2423      * subtract the transaction fee and send it to the fee pool
2424      * for SNX holders to claim. */
2425     function transferFrom(address from, address to, uint value)
2426         public
2427         optionalProxy
2428         notFeeAddress(from)
2429         returns (bool)
2430     {
2431         // The fee is deducted from the amount sent.
2432         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2433         uint fee = value.sub(amountReceived);
2434 
2435         // Reduce the allowance by the amount we're transferring.
2436         // The safeSub call will handle an insufficient allowance.
2437         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
2438 
2439         // Send the fee off to the fee pool.
2440         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2441 
2442         bytes memory empty;
2443         return _internalTransfer(from, to, amountReceived, empty);
2444     }
2445 
2446     /**
2447      * @notice Override ERC223 transferFrom function in order to
2448      * subtract the transaction fee and send it to the fee pool
2449      * for SNX holders to claim. */
2450     function transferFrom(address from, address to, uint value, bytes data)
2451         public
2452         optionalProxy
2453         notFeeAddress(from)
2454         returns (bool)
2455     {
2456         // The fee is deducted from the amount sent.
2457         uint amountReceived = feePool.amountReceivedFromTransfer(value);
2458         uint fee = value.sub(amountReceived);
2459 
2460         // Reduce the allowance by the amount we're transferring.
2461         // The safeSub call will handle an insufficient allowance.
2462         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
2463 
2464         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2465         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2466 
2467         return _internalTransfer(from, to, amountReceived, data);
2468     }
2469 
2470     /* Subtract the transfer fee from the senders account so the
2471      * receiver gets the exact amount specified to send. */
2472     function transferSenderPaysFee(address to, uint value)
2473         public
2474         optionalProxy
2475         notFeeAddress(messageSender)
2476         returns (bool)
2477     {
2478         uint fee = feePool.transferFeeIncurred(value);
2479 
2480         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2481         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
2482 
2483         // And send their transfer amount off to the destination address
2484         bytes memory empty;
2485         return _internalTransfer(messageSender, to, value, empty);
2486     }
2487 
2488     /* Subtract the transfer fee from the senders account so the
2489      * receiver gets the exact amount specified to send. */
2490     function transferSenderPaysFee(address to, uint value, bytes data)
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
2502         return _internalTransfer(messageSender, to, value, data);
2503     }
2504 
2505     /* Subtract the transfer fee from the senders account so the
2506      * to address receives the exact amount specified to send. */
2507     function transferFromSenderPaysFee(address from, address to, uint value)
2508         public
2509         optionalProxy
2510         notFeeAddress(from)
2511         returns (bool)
2512     {
2513         uint fee = feePool.transferFeeIncurred(value);
2514 
2515         // Reduce the allowance by the amount we're transferring.
2516         // The safeSub call will handle an insufficient allowance.
2517         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
2518 
2519         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2520         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2521 
2522         bytes memory empty;
2523         return _internalTransfer(from, to, value, empty);
2524     }
2525 
2526     /* Subtract the transfer fee from the senders account so the
2527      * to address receives the exact amount specified to send. */
2528     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
2529         public
2530         optionalProxy
2531         notFeeAddress(from)
2532         returns (bool)
2533     {
2534         uint fee = feePool.transferFeeIncurred(value);
2535 
2536         // Reduce the allowance by the amount we're transferring.
2537         // The safeSub call will handle an insufficient allowance.
2538         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
2539 
2540         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
2541         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
2542 
2543         return _internalTransfer(from, to, value, data);
2544     }
2545 
2546     // Override our internal transfer to inject preferred currency support
2547     function _internalTransfer(address from, address to, uint value, bytes data)
2548         internal
2549         returns (bool)
2550     {
2551         bytes4 preferredCurrencyKey = synthetix.synthetixState().preferredCurrency(to);
2552 
2553         // Do they have a preferred currency that's not us? If so we need to exchange
2554         if (preferredCurrencyKey != 0 && preferredCurrencyKey != currencyKey) {
2555             return synthetix.synthInitiatedExchange(from, currencyKey, value, preferredCurrencyKey, to);
2556         } else {
2557             // Otherwise we just transfer
2558             return super._internalTransfer(from, to, value, data);
2559         }
2560     }
2561 
2562     // Allow synthetix to issue a certain number of synths from an account.
2563     function issue(address account, uint amount)
2564         external
2565         onlySynthetixOrFeePool
2566     {
2567         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
2568         totalSupply = totalSupply.add(amount);
2569         emitTransfer(address(0), account, amount);
2570         emitIssued(account, amount);
2571     }
2572 
2573     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
2574     function burn(address account, uint amount)
2575         external
2576         onlySynthetixOrFeePool
2577     {
2578         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
2579         totalSupply = totalSupply.sub(amount);
2580         emitTransfer(account, address(0), amount);
2581         emitBurned(account, amount);
2582     }
2583 
2584     // Allow owner to set the total supply on import.
2585     function setTotalSupply(uint amount)
2586         external
2587         optionalProxy_onlyOwner
2588     {
2589         totalSupply = amount;
2590     }
2591 
2592     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
2593     // exchange as well as transfer
2594     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
2595         external
2596         onlySynthetixOrFeePool
2597     {
2598         bytes memory empty;
2599         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
2600     }
2601 
2602     /* ========== MODIFIERS ========== */
2603 
2604     modifier onlySynthetixOrFeePool() {
2605         bool isSynthetix = msg.sender == address(synthetix);
2606         bool isFeePool = msg.sender == address(feePool);
2607 
2608         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
2609         _;
2610     }
2611 
2612     modifier notFeeAddress(address account) {
2613         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
2614         _;
2615     }
2616 
2617     /* ========== EVENTS ========== */
2618 
2619     event SynthetixUpdated(address newSynthetix);
2620     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
2621     function emitSynthetixUpdated(address newSynthetix) internal {
2622         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
2623     }
2624 
2625     event FeePoolUpdated(address newFeePool);
2626     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
2627     function emitFeePoolUpdated(address newFeePool) internal {
2628         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
2629     }
2630 
2631     event Issued(address indexed account, uint value);
2632     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
2633     function emitIssued(address account, uint value) internal {
2634         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
2635     }
2636 
2637     event Burned(address indexed account, uint value);
2638     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
2639     function emitBurned(address account, uint value) internal {
2640         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
2641     }
2642 }
2643 
2644 
2645 /**
2646  * @title SynthetixEscrow interface
2647  */
2648 interface ISynthetixEscrow {
2649     function balanceOf(address account) public view returns (uint);
2650     function appendVestingEntry(address account, uint quantity) public;
2651 }
2652 
2653 
2654 /*
2655 -----------------------------------------------------------------
2656 FILE INFORMATION
2657 -----------------------------------------------------------------
2658 
2659 file:       Synthetix.sol
2660 version:    2.0
2661 author:     Kevin Brown
2662             Gavin Conway
2663 date:       2018-09-14
2664 
2665 -----------------------------------------------------------------
2666 MODULE DESCRIPTION
2667 -----------------------------------------------------------------
2668 
2669 Synthetix token contract. SNX is a transferable ERC20 token,
2670 and also give its holders the following privileges.
2671 An owner of SNX has the right to issue synths in all synth flavours.
2672 
2673 After a fee period terminates, the duration and fees collected for that
2674 period are computed, and the next period begins. Thus an account may only
2675 withdraw the fees owed to them for the previous period, and may only do
2676 so once per period. Any unclaimed fees roll over into the common pot for
2677 the next period.
2678 
2679 == Average Balance Calculations ==
2680 
2681 The fee entitlement of a synthetix holder is proportional to their average
2682 issued synth balance over the last fee period. This is computed by
2683 measuring the area under the graph of a user's issued synth balance over
2684 time, and then when a new fee period begins, dividing through by the
2685 duration of the fee period.
2686 
2687 We need only update values when the balances of an account is modified.
2688 This occurs when issuing or burning for issued synth balances,
2689 and when transferring for synthetix balances. This is for efficiency,
2690 and adds an implicit friction to interacting with SNX.
2691 A synthetix holder pays for his own recomputation whenever he wants to change
2692 his position, which saves the foundation having to maintain a pot dedicated
2693 to resourcing this.
2694 
2695 A hypothetical user's balance history over one fee period, pictorially:
2696 
2697       s ____
2698        |    |
2699        |    |___ p
2700        |____|___|___ __ _  _
2701        f    t   n
2702 
2703 Here, the balance was s between times f and t, at which time a transfer
2704 occurred, updating the balance to p, until n, when the present transfer occurs.
2705 When a new transfer occurs at time n, the balance being p,
2706 we must:
2707 
2708   - Add the area p * (n - t) to the total area recorded so far
2709   - Update the last transfer time to n
2710 
2711 So if this graph represents the entire current fee period,
2712 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
2713 The complementary computations must be performed for both sender and
2714 recipient.
2715 
2716 Note that a transfer keeps global supply of SNX invariant.
2717 The sum of all balances is constant, and unmodified by any transfer.
2718 So the sum of all balances multiplied by the duration of a fee period is also
2719 constant, and this is equivalent to the sum of the area of every user's
2720 time/balance graph. Dividing through by that duration yields back the total
2721 synthetix supply. So, at the end of a fee period, we really do yield a user's
2722 average share in the synthetix supply over that period.
2723 
2724 A slight wrinkle is introduced if we consider the time r when the fee period
2725 rolls over. Then the previous fee period k-1 is before r, and the current fee
2726 period k is afterwards. If the last transfer took place before r,
2727 but the latest transfer occurred afterwards:
2728 
2729 k-1       |        k
2730       s __|_
2731        |  | |
2732        |  | |____ p
2733        |__|_|____|___ __ _  _
2734           |
2735        f  | t    n
2736           r
2737 
2738 In this situation the area (r-f)*s contributes to fee period k-1, while
2739 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2740 zero-value transfer to have occurred at time r. Their fee entitlement for the
2741 previous period will be finalised at the time of their first transfer during the
2742 current fee period, or when they query or withdraw their fee entitlement.
2743 
2744 In the implementation, the duration of different fee periods may be slightly irregular,
2745 as the check that they have rolled over occurs only when state-changing synthetix
2746 operations are performed.
2747 
2748 == Issuance and Burning ==
2749 
2750 In this version of the synthetix contract, synths can only be issued by
2751 those that have been nominated by the synthetix foundation. Synths are assumed
2752 to be valued at $1, as they are a stable unit of account.
2753 
2754 All synths issued require a proportional value of SNX to be locked,
2755 where the proportion is governed by the current issuance ratio. This
2756 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
2757 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
2758 
2759 To determine the value of some amount of SNX(S), an oracle is used to push
2760 the price of SNX (P_S) in dollars to the contract. The value of S
2761 would then be: S * P_S.
2762 
2763 Any SNX that are locked up by this issuance process cannot be transferred.
2764 The amount that is locked floats based on the price of SNX. If the price
2765 of SNX moves up, less SNX are locked, so they can be issued against,
2766 or transferred freely. If the price of SNX moves down, more SNX are locked,
2767 even going above the initial wallet balance.
2768 
2769 -----------------------------------------------------------------
2770 */
2771 
2772 
2773 /**
2774  * @title Synthetix ERC20 contract.
2775  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
2776  * but it also computes the quantity of fees each synthetix holder is entitled to.
2777  */
2778 contract Synthetix is ExternStateToken {
2779 
2780     // ========== STATE VARIABLES ==========
2781 
2782     // Available Synths which can be used with the system
2783     Synth[] public availableSynths;
2784     mapping(bytes4 => Synth) public synths;
2785 
2786     IFeePool public feePool;
2787     ISynthetixEscrow public escrow;
2788     ISynthetixEscrow public rewardEscrow;
2789     ExchangeRates public exchangeRates;
2790     SynthetixState public synthetixState;
2791     SupplySchedule public supplySchedule;
2792 
2793     string constant TOKEN_NAME = "Synthetix Network Token";
2794     string constant TOKEN_SYMBOL = "SNX";
2795     uint8 constant DECIMALS = 18;
2796     // ========== CONSTRUCTOR ==========
2797 
2798     /**
2799      * @dev Constructor
2800      * @param _tokenState A pre-populated contract containing token balances.
2801      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2802      * @param _owner The owner of this contract.
2803      */
2804     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
2805         address _owner, ExchangeRates _exchangeRates, IFeePool _feePool, SupplySchedule _supplySchedule,
2806         ISynthetixEscrow _rewardEscrow, ISynthetixEscrow _escrow, uint _totalSupply
2807     )
2808         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, _totalSupply, DECIMALS, _owner)
2809         public
2810     {
2811         synthetixState = _synthetixState;
2812         exchangeRates = _exchangeRates;
2813         feePool = _feePool;
2814         supplySchedule = _supplySchedule;
2815         rewardEscrow = _rewardEscrow;
2816         escrow = _escrow;
2817     }
2818     // ========== SETTERS ========== */
2819 
2820     function setFeePool(IFeePool _feePool)
2821         external
2822         optionalProxy_onlyOwner
2823     {
2824         feePool = _feePool;
2825     }
2826 
2827     function setExchangeRates(ExchangeRates _exchangeRates)
2828         external
2829         optionalProxy_onlyOwner
2830     {
2831         exchangeRates = _exchangeRates;
2832     }
2833 
2834     /**
2835      * @notice Add an associated Synth contract to the Synthetix system
2836      * @dev Only the contract owner may call this.
2837      */
2838     function addSynth(Synth synth)
2839         external
2840         optionalProxy_onlyOwner
2841     {
2842         bytes4 currencyKey = synth.currencyKey();
2843 
2844         require(synths[currencyKey] == Synth(0), "Synth already exists");
2845 
2846         availableSynths.push(synth);
2847         synths[currencyKey] = synth;
2848     }
2849 
2850     /**
2851      * @notice Remove an associated Synth contract from the Synthetix system
2852      * @dev Only the contract owner may call this.
2853      */
2854     function removeSynth(bytes4 currencyKey)
2855         external
2856         optionalProxy_onlyOwner
2857     {
2858         require(synths[currencyKey] != address(0), "Synth does not exist");
2859         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
2860         require(currencyKey != "XDR", "Cannot remove XDR synth");
2861 
2862         // Save the address we're removing for emitting the event at the end.
2863         address synthToRemove = synths[currencyKey];
2864 
2865         // Remove the synth from the availableSynths array.
2866         for (uint8 i = 0; i < availableSynths.length; i++) {
2867             if (availableSynths[i] == synthToRemove) {
2868                 delete availableSynths[i];
2869 
2870                 // Copy the last synth into the place of the one we just deleted
2871                 // If there's only one synth, this is synths[0] = synths[0].
2872                 // If we're deleting the last one, it's also a NOOP in the same way.
2873                 availableSynths[i] = availableSynths[availableSynths.length - 1];
2874 
2875                 // Decrease the size of the array by one.
2876                 availableSynths.length--;
2877 
2878                 break;
2879             }
2880         }
2881 
2882         // And remove it from the synths mapping
2883         delete synths[currencyKey];
2884 
2885         // Note: No event here as our contract exceeds max contract size
2886         // with these events, and it's unlikely people will need to
2887         // track these events specifically.
2888     }
2889 
2890     // ========== VIEWS ==========
2891 
2892     /**
2893      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
2894      * @param sourceCurrencyKey The currency the amount is specified in
2895      * @param sourceAmount The source amount, specified in UNIT base
2896      * @param destinationCurrencyKey The destination currency
2897      */
2898     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
2899         public
2900         view
2901         rateNotStale(sourceCurrencyKey)
2902         rateNotStale(destinationCurrencyKey)
2903         returns (uint)
2904     {
2905         // If there's no change in the currency, then just return the amount they gave us
2906         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
2907 
2908         // Calculate the effective value by going from source -> USD -> destination
2909         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
2910             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
2911     }
2912 
2913     /**
2914      * @notice Total amount of synths issued by the system, priced in currencyKey
2915      * @param currencyKey The currency to value the synths in
2916      */
2917     function totalIssuedSynths(bytes4 currencyKey)
2918         public
2919         view
2920         rateNotStale(currencyKey)
2921         returns (uint)
2922     {
2923         uint total = 0;
2924         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
2925 
2926         require(!exchangeRates.anyRateIsStale(availableCurrencyKeys()), "Rates are stale");
2927 
2928         for (uint8 i = 0; i < availableSynths.length; i++) {
2929             // What's the total issued value of that synth in the destination currency?
2930             // Note: We're not using our effectiveValue function because we don't want to go get the
2931             //       rate for the destination currency and check if it's stale repeatedly on every
2932             //       iteration of the loop
2933             uint synthValue = availableSynths[i].totalSupply()
2934                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
2935                 .divideDecimalRound(currencyRate);
2936             total = total.add(synthValue);
2937         }
2938 
2939         return total;
2940     }
2941 
2942     /**
2943      * @notice Returns the currencyKeys of availableSynths for rate checking
2944      */
2945     function availableCurrencyKeys()
2946         internal
2947         view
2948         returns (bytes4[])
2949     {
2950         bytes4[] memory availableCurrencyKeys = new bytes4[](availableSynths.length);
2951 
2952         for (uint8 i = 0; i < availableSynths.length; i++) {
2953             availableCurrencyKeys[i] = availableSynths[i].currencyKey();
2954         }
2955 
2956         return availableCurrencyKeys;
2957     }
2958 
2959     /**
2960      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
2961      */
2962     function availableSynthCount()
2963         public
2964         view
2965         returns (uint)
2966     {
2967         return availableSynths.length;
2968     }
2969 
2970     // ========== MUTATIVE FUNCTIONS ==========
2971 
2972     /**
2973      * @notice ERC20 transfer function.
2974      */
2975     function transfer(address to, uint value)
2976         public
2977         returns (bool)
2978     {
2979         bytes memory empty;
2980         return transfer(to, value, empty);
2981     }
2982 
2983     /**
2984      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
2985      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2986      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2987      *           tooling such as Etherscan.
2988      */
2989     function transfer(address to, uint value, bytes data)
2990         public
2991         optionalProxy
2992         returns (bool)
2993     {
2994         // Ensure they're not trying to exceed their locked amount
2995         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
2996 
2997         // Perform the transfer: if there is a problem an exception will be thrown in this call.
2998         _transfer_byProxy(messageSender, to, value, data);
2999 
3000         return true;
3001     }
3002 
3003     /**
3004      * @notice ERC20 transferFrom function.
3005      */
3006     function transferFrom(address from, address to, uint value)
3007         public
3008         returns (bool)
3009     {
3010         bytes memory empty;
3011         return transferFrom(from, to, value, empty);
3012     }
3013 
3014     /**
3015      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
3016      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3017      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3018      *           tooling such as Etherscan.
3019      */
3020     function transferFrom(address from, address to, uint value, bytes data)
3021         public
3022         optionalProxy
3023         returns (bool)
3024     {
3025         // Ensure they're not trying to exceed their locked amount
3026         require(value <= transferableSynthetix(from), "Insufficient balance");
3027 
3028         // Perform the transfer: if there is a problem,
3029         // an exception will be thrown in this call.
3030         _transferFrom_byProxy(messageSender, from, to, value, data);
3031 
3032         return true;
3033     }
3034 
3035     /**
3036      * @notice Function that allows you to exchange synths you hold in one flavour for another.
3037      * @param sourceCurrencyKey The source currency you wish to exchange from
3038      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3039      * @param destinationCurrencyKey The destination currency you wish to obtain.
3040      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
3041      * @return Boolean that indicates whether the transfer succeeded or failed.
3042      */
3043     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
3044         external
3045         optionalProxy
3046         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
3047         returns (bool)
3048     {
3049         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
3050         require(sourceAmount > 0, "Zero amount");
3051 
3052         // Pass it along, defaulting to the sender as the recipient.
3053         return _internalExchange(
3054             messageSender,
3055             sourceCurrencyKey,
3056             sourceAmount,
3057             destinationCurrencyKey,
3058             destinationAddress == address(0) ? messageSender : destinationAddress,
3059             true // Charge fee on the exchange
3060         );
3061     }
3062 
3063     /**
3064      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
3065      * @dev Only the synth contract can call this function
3066      * @param from The address to exchange / burn synth from
3067      * @param sourceCurrencyKey The source currency you wish to exchange from
3068      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3069      * @param destinationCurrencyKey The destination currency you wish to obtain.
3070      * @param destinationAddress Where the result should go.
3071      * @return Boolean that indicates whether the transfer succeeded or failed.
3072      */
3073     function synthInitiatedExchange(
3074         address from,
3075         bytes4 sourceCurrencyKey,
3076         uint sourceAmount,
3077         bytes4 destinationCurrencyKey,
3078         address destinationAddress
3079     )
3080         external
3081         onlySynth
3082         returns (bool)
3083     {
3084         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3085         require(sourceAmount > 0, "Zero amount");
3086 
3087         // Pass it along
3088         return _internalExchange(
3089             from,
3090             sourceCurrencyKey,
3091             sourceAmount,
3092             destinationCurrencyKey,
3093             destinationAddress,
3094             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
3095         );
3096     }
3097 
3098     /**
3099      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3100      * @dev Only the synth contract can call this function.
3101      * @param from The address fee is coming from.
3102      * @param sourceCurrencyKey source currency fee from.
3103      * @param sourceAmount The amount, specified in UNIT of source currency.
3104      * @return Boolean that indicates whether the transfer succeeded or failed.
3105      */
3106     function synthInitiatedFeePayment(
3107         address from,
3108         bytes4 sourceCurrencyKey,
3109         uint sourceAmount
3110     )
3111         external
3112         onlySynth
3113         returns (bool)
3114     {
3115         // Allow fee to be 0 and skip minting XDRs to feePool
3116         if (sourceAmount == 0) {
3117             return true;
3118         }
3119 
3120         require(sourceAmount > 0, "Source can't be 0");
3121 
3122         // Pass it along, defaulting to the sender as the recipient.
3123         bool result = _internalExchange(
3124             from,
3125             sourceCurrencyKey,
3126             sourceAmount,
3127             "XDR",
3128             feePool.FEE_ADDRESS(),
3129             false // Don't charge a fee on the exchange because this is already a fee
3130         );
3131 
3132         // Tell the fee pool about this.
3133         feePool.feePaid(sourceCurrencyKey, sourceAmount);
3134 
3135         return result;
3136     }
3137 
3138     /**
3139      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3140      * @dev fee pool contract address is not allowed to call function
3141      * @param from The address to move synth from
3142      * @param sourceCurrencyKey source currency from.
3143      * @param sourceAmount The amount, specified in UNIT of source currency.
3144      * @param destinationCurrencyKey The destination currency to obtain.
3145      * @param destinationAddress Where the result should go.
3146      * @param chargeFee Boolean to charge a fee for transaction.
3147      * @return Boolean that indicates whether the transfer succeeded or failed.
3148      */
3149     function _internalExchange(
3150         address from,
3151         bytes4 sourceCurrencyKey,
3152         uint sourceAmount,
3153         bytes4 destinationCurrencyKey,
3154         address destinationAddress,
3155         bool chargeFee
3156     )
3157         internal
3158         notFeeAddress(from)
3159         returns (bool)
3160     {
3161         require(destinationAddress != address(0), "Zero destination");
3162         require(destinationAddress != address(this), "Synthetix is invalid destination");
3163         require(destinationAddress != address(proxy), "Proxy is invalid destination");
3164 
3165         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3166         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3167 
3168         // Burn the source amount
3169         synths[sourceCurrencyKey].burn(from, sourceAmount);
3170 
3171         // How much should they get in the destination currency?
3172         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3173 
3174         // What's the fee on that currency that we should deduct?
3175         uint amountReceived = destinationAmount;
3176         uint fee = 0;
3177 
3178         if (chargeFee) {
3179             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
3180             fee = destinationAmount.sub(amountReceived);
3181         }
3182 
3183         // Issue their new synths
3184         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3185 
3186         // Remit the fee in XDRs
3187         if (fee > 0) {
3188             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3189             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3190             // Tell the fee pool about this.
3191             feePool.feePaid("XDR", xdrFeeAmount);
3192         }
3193 
3194         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3195 
3196         // Call the ERC223 transfer callback if needed
3197         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
3198 
3199         //Let the DApps know there was a Synth exchange
3200         emitSynthExchange(from, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, amountReceived, destinationAddress);
3201 
3202         return true;
3203     }
3204 
3205     /**
3206      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
3207      * @dev Only internal calls from synthetix address.
3208      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3209      * @param amount The amount of synths to register with a base of UNIT
3210      */
3211     function _addToDebtRegister(bytes4 currencyKey, uint amount)
3212         internal
3213         optionalProxy
3214     {
3215         // What is the value of the requested debt in XDRs?
3216         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3217 
3218         // What is the value of all issued synths of the system (priced in XDRs)?
3219         uint totalDebtIssued = totalIssuedSynths("XDR");
3220 
3221         // What will the new total be including the new value?
3222         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3223 
3224         // What is their percentage (as a high precision int) of the total debt?
3225         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3226 
3227         // And what effect does this percentage change have on the global debt holding of other issuers?
3228         // The delta specifically needs to not take into account any existing debt as it's already
3229         // accounted for in the delta from when they issued previously.
3230         // The delta is a high precision integer.
3231         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3232 
3233         // How much existing debt do they have?
3234         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3235 
3236         // And what does their debt ownership look like including this previous stake?
3237         if (existingDebt > 0) {
3238             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3239         }
3240 
3241         // Are they a new issuer? If so, record them.
3242         if (!synthetixState.hasIssued(messageSender)) {
3243             synthetixState.incrementTotalIssuerCount();
3244         }
3245 
3246         // Save the debt entry parameters
3247         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3248 
3249         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3250         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3251         if (synthetixState.debtLedgerLength() > 0) {
3252             synthetixState.appendDebtLedgerValue(
3253                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3254             );
3255         } else {
3256             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3257         }
3258     }
3259 
3260     /**
3261      * @notice Issue synths against the sender's SNX.
3262      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3263      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3264      * @param amount The amount of synths you wish to issue with a base of UNIT
3265      */
3266     function issueSynths(bytes4 currencyKey, uint amount)
3267         public
3268         optionalProxy
3269         // No need to check if price is stale, as it is checked in issuableSynths.
3270     {
3271         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3272 
3273         // Keep track of the debt they're about to create
3274         _addToDebtRegister(currencyKey, amount);
3275 
3276         // Create their synths
3277         synths[currencyKey].issue(messageSender, amount);
3278 
3279         // Store their locked SNX amount to determine their fee % for the period
3280         _appendAccountIssuanceRecord();
3281     }
3282 
3283     /**
3284      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3285      * @dev Issuance is only allowed if the synthetix price isn't stale.
3286      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3287      */
3288     function issueMaxSynths(bytes4 currencyKey)
3289         external
3290         optionalProxy
3291     {
3292         // Figure out the maximum we can issue in that currency
3293         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3294 
3295         // And issue them
3296         issueSynths(currencyKey, maxIssuable);
3297     }
3298 
3299     /**
3300      * @notice Burn synths to clear issued synths/free SNX.
3301      * @param currencyKey The currency you're specifying to burn
3302      * @param amount The amount (in UNIT base) you wish to burn
3303      * @dev The amount to burn is debased to XDR's
3304      */
3305     function burnSynths(bytes4 currencyKey, uint amount)
3306         external
3307         optionalProxy
3308         // No need to check for stale rates as effectiveValue checks rates
3309     {
3310         // How much debt do they have?
3311         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3312         uint debt = debtBalanceOf(messageSender, "XDR");
3313         uint debtInCurrencyKey = debtBalanceOf(messageSender, currencyKey);
3314 
3315         require(debt > 0, "No debt to forgive");
3316 
3317         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3318         // clear their debt and leave them be.
3319         uint amountToRemove = debt < debtToRemove ? debt : debtToRemove;
3320 
3321         // Remove their debt from the ledger
3322         _removeFromDebtRegister(amountToRemove);
3323 
3324         uint amountToBurn = debtInCurrencyKey < amount ? debtInCurrencyKey : amount;
3325 
3326         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3327         synths[currencyKey].burn(messageSender, amountToBurn);
3328 
3329         // Store their debtRatio against a feeperiod to determine their fee/rewards % for the period
3330         _appendAccountIssuanceRecord();
3331     }
3332 
3333     /**
3334      * @notice Store in the FeePool the users current debt value in the system in XDRs.
3335      * @dev debtBalanceOf(messageSender, "XDR") to be used with totalIssuedSynths("XDR") to get
3336      *  users % of the system within a feePeriod.
3337      */
3338     function _appendAccountIssuanceRecord()
3339         internal
3340     {
3341         uint initialDebtOwnership;
3342         uint debtEntryIndex;
3343         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(messageSender);
3344 
3345         feePool.appendAccountIssuanceRecord(
3346             messageSender,
3347             initialDebtOwnership,
3348             debtEntryIndex
3349         );
3350     }
3351 
3352     /**
3353      * @notice Remove a debt position from the register
3354      * @param amount The amount (in UNIT base) being presented in XDRs
3355      */
3356     function _removeFromDebtRegister(uint amount)
3357         internal
3358     {
3359         uint debtToRemove = amount;
3360 
3361         // How much debt do they have?
3362         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3363 
3364         // What is the value of all issued synths of the system (priced in XDRs)?
3365         uint totalDebtIssued = totalIssuedSynths("XDR");
3366 
3367         // What will the new total after taking out the withdrawn amount
3368         uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3369 
3370         uint delta;
3371 
3372         // What will the debt delta be if there is any debt left?
3373         // Set delta to 0 if no more debt left in system after user
3374         if (newTotalDebtIssued > 0) {
3375 
3376             // What is the percentage of the withdrawn debt (as a high precision int) of the total debt after?
3377             uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(newTotalDebtIssued);
3378 
3379             // And what effect does this percentage change have on the global debt holding of other issuers?
3380             // The delta specifically needs to not take into account any existing debt as it's already
3381             // accounted for in the delta from when they issued previously.
3382             delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3383         } else {
3384             delta = 0;
3385         }
3386 
3387         // Are they exiting the system, or are they just decreasing their debt position?
3388         if (debtToRemove == existingDebt) {
3389             synthetixState.setCurrentIssuanceData(messageSender, 0);
3390             synthetixState.decrementTotalIssuerCount();
3391         } else {
3392             // What percentage of the debt will they be left with?
3393             uint newDebt = existingDebt.sub(debtToRemove);
3394             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3395 
3396             // Store the debt percentage and debt ledger as high precision integers
3397             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3398         }
3399 
3400         // Update our cumulative ledger. This is also a high precision integer.
3401         synthetixState.appendDebtLedgerValue(
3402             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3403         );
3404     }
3405 
3406     // ========== Issuance/Burning ==========
3407 
3408     /**
3409      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3410      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3411      */
3412     function maxIssuableSynths(address issuer, bytes4 currencyKey)
3413         public
3414         view
3415         // We don't need to check stale rates here as effectiveValue will do it for us.
3416         returns (uint)
3417     {
3418         // What is the value of their SNX balance in the destination currency?
3419         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3420 
3421         // They're allowed to issue up to issuanceRatio of that value
3422         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3423     }
3424 
3425     /**
3426      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3427      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
3428      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3429      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
3430      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3431      * altering the amount of fees they're able to claim from the system.
3432      */
3433     function collateralisationRatio(address issuer)
3434         public
3435         view
3436         returns (uint)
3437     {
3438         uint totalOwnedSynthetix = collateral(issuer);
3439         if (totalOwnedSynthetix == 0) return 0;
3440 
3441         uint debtBalance = debtBalanceOf(issuer, "SNX");
3442         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3443     }
3444 
3445     /**
3446      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3447      * will tell you how many synths a user has to give back to the system in order to unlock their original
3448      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3449      * the debt in sUSD, XDR, or any other synth you wish.
3450      */
3451     function debtBalanceOf(address issuer, bytes4 currencyKey)
3452         public
3453         view
3454         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3455         returns (uint)
3456     {
3457         // What was their initial debt ownership?
3458         uint initialDebtOwnership;
3459         uint debtEntryIndex;
3460         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3461 
3462         // If it's zero, they haven't issued, and they have no debt.
3463         if (initialDebtOwnership == 0) return 0;
3464 
3465         // Figure out the global debt percentage delta from when they entered the system.
3466         // This is a high precision integer.
3467         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3468             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3469             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3470 
3471         // What's the total value of the system in their requested currency?
3472         uint totalSystemValue = totalIssuedSynths(currencyKey);
3473 
3474         // Their debt balance is their portion of the total system value.
3475         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3476             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3477 
3478         return highPrecisionBalance.preciseDecimalToDecimal();
3479     }
3480 
3481     /**
3482      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3483      * @param issuer The account that intends to issue
3484      * @param currencyKey The currency to price issuable value in
3485      */
3486     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
3487         public
3488         view
3489         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3490         returns (uint)
3491     {
3492         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3493         uint max = maxIssuableSynths(issuer, currencyKey);
3494 
3495         if (alreadyIssued >= max) {
3496             return 0;
3497         } else {
3498             return max.sub(alreadyIssued);
3499         }
3500     }
3501 
3502     /**
3503      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3504      * against which synths can be issued.
3505      * This includes those already being used as collateral (locked), and those
3506      * available for further issuance (unlocked).
3507      */
3508     function collateral(address account)
3509         public
3510         view
3511         returns (uint)
3512     {
3513         uint balance = tokenState.balanceOf(account);
3514 
3515         if (escrow != address(0)) {
3516             balance = balance.add(escrow.balanceOf(account));
3517         }
3518 
3519         if (rewardEscrow != address(0)) {
3520             balance = balance.add(rewardEscrow.balanceOf(account));
3521         }
3522 
3523         return balance;
3524     }
3525 
3526     /**
3527      * @notice The number of SNX that are free to be transferred by an account.
3528      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
3529      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
3530      * in this calculation.
3531      */
3532     function transferableSynthetix(address account)
3533         public
3534         view
3535         rateNotStale("SNX")
3536         returns (uint)
3537     {
3538         // How many SNX do they have, excluding escrow?
3539         // Note: We're excluding escrow here because we're interested in their transferable amount
3540         // and escrowed SNX are not transferable.
3541         uint balance = tokenState.balanceOf(account);
3542 
3543         // How many of those will be locked by the amount they've issued?
3544         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3545         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3546         // The locked synthetix value can exceed their balance.
3547         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3548 
3549         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3550         if (lockedSynthetixValue >= balance) {
3551             return 0;
3552         } else {
3553             return balance.sub(lockedSynthetixValue);
3554         }
3555     }
3556 
3557     function mint()
3558         external
3559         returns (bool)
3560     {
3561         require(rewardEscrow != address(0), "Reward Escrow destination missing");
3562 
3563         uint supplyToMint = supplySchedule.mintableSupply();
3564         require(supplyToMint > 0, "No supply is mintable");
3565 
3566         supplySchedule.updateMintValues();
3567 
3568         // Set minted SNX balance to RewardEscrow's balance
3569         // Minus the minterReward and set balance of minter to add reward
3570         uint minterReward = supplySchedule.minterReward();
3571 
3572         tokenState.setBalanceOf(rewardEscrow, tokenState.balanceOf(rewardEscrow).add(supplyToMint.sub(minterReward)));
3573         emitTransfer(this, rewardEscrow, supplyToMint.sub(minterReward));
3574 
3575         // Tell the FeePool how much it has to distribute
3576         feePool.rewardsMinted(supplyToMint.sub(minterReward));
3577 
3578         // Assign the minters reward.
3579         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
3580         emitTransfer(this, msg.sender, minterReward);
3581 
3582         totalSupply = totalSupply.add(supplyToMint);
3583     }
3584 
3585     // ========== MODIFIERS ==========
3586 
3587     modifier rateNotStale(bytes4 currencyKey) {
3588         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
3589         _;
3590     }
3591 
3592     modifier notFeeAddress(address account) {
3593         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3594         _;
3595     }
3596 
3597     modifier onlySynth() {
3598         bool isSynth = false;
3599 
3600         // No need to repeatedly call this function either
3601         for (uint8 i = 0; i < availableSynths.length; i++) {
3602             if (availableSynths[i] == msg.sender) {
3603                 isSynth = true;
3604                 break;
3605             }
3606         }
3607 
3608         require(isSynth, "Only synth allowed");
3609         _;
3610     }
3611 
3612     modifier nonZeroAmount(uint _amount) {
3613         require(_amount > 0, "Amount needs to be larger than 0");
3614         _;
3615     }
3616 
3617     // ========== EVENTS ==========
3618     /* solium-disable */
3619     event SynthExchange(address indexed account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey,  uint256 toAmount, address toAddress);
3620     bytes32 constant SYNTHEXCHANGE_SIG = keccak256("SynthExchange(address,bytes4,uint256,bytes4,uint256,address)");
3621     function emitSynthExchange(address account, bytes4 fromCurrencyKey, uint256 fromAmount, bytes4 toCurrencyKey, uint256 toAmount, address toAddress) internal {
3622         proxy._emit(abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress), 2, SYNTHEXCHANGE_SIG, bytes32(account), 0, 0);
3623     }
3624     /* solium-enable */
3625 }
3626 
3627 
3628 contract ISynthetixState {
3629     // A struct for handing values associated with an individual user's debt position
3630     struct IssuanceData {
3631         // Percentage of the total debt owned at the time
3632         // of issuance. This number is modified by the global debt
3633         // delta array. You can figure out a user's exit price and
3634         // collateralisation ratio using a combination of their initial
3635         // debt and the slice of global debt delta which applies to them.
3636         uint initialDebtOwnership;
3637         // This lets us know when (in relative terms) the user entered
3638         // the debt pool so we can calculate their exit price and
3639         // collateralistion ratio
3640         uint debtEntryIndex;
3641     }
3642 
3643     uint[] public debtLedger;
3644     uint public issuanceRatio;
3645     mapping(address => IssuanceData) public issuanceData;
3646 
3647     function debtLedgerLength() external view returns (uint);
3648     function hasIssued(address account) external view returns (bool);
3649     function incrementTotalIssuerCount() external;
3650     function decrementTotalIssuerCount() external;
3651     function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
3652     function lastDebtLedgerEntry() external view returns (uint);
3653     function appendDebtLedgerValue(uint value) external;
3654     function clearIssuanceData(address account) external;
3655 }
3656 
3657 
3658 /*
3659 -----------------------------------------------------------------
3660 FILE INFORMATION
3661 -----------------------------------------------------------------
3662 
3663 file:       FeePoolState.sol
3664 version:    1.0
3665 author:     Clinton Ennis
3666             Jackson Chan
3667 date:       2019-04-05
3668 
3669 -----------------------------------------------------------------
3670 MODULE DESCRIPTION
3671 -----------------------------------------------------------------
3672 
3673 The FeePoolState simply stores the accounts issuance ratio for
3674 each fee period in the FeePool.
3675 
3676 This is use to caclulate the correct allocation of fees/rewards
3677 owed to minters of the stablecoin total supply
3678 
3679 -----------------------------------------------------------------
3680 */
3681 
3682 
3683 contract FeePoolState is SelfDestructible, LimitedSetup {
3684     using SafeMath for uint;
3685     using SafeDecimalMath for uint;
3686 
3687     /* ========== STATE VARIABLES ========== */
3688 
3689     uint8 constant public FEE_PERIOD_LENGTH = 6;
3690 
3691     address public feePool;
3692 
3693     // The IssuanceData activity that's happened in a fee period.
3694     struct IssuanceData {
3695         uint debtPercentage;
3696         uint debtEntryIndex;
3697     }
3698 
3699     // The IssuanceData activity that's happened in a fee period.
3700     mapping(address => IssuanceData[FEE_PERIOD_LENGTH]) public accountIssuanceLedger;
3701 
3702     /**
3703      * @dev Constructor.
3704      * @param _owner The owner of this contract.
3705      */
3706     constructor(address _owner, IFeePool _feePool)
3707         SelfDestructible(_owner)
3708         LimitedSetup(6 weeks)
3709         public
3710     {
3711         feePool = _feePool;
3712     }
3713 
3714     /* ========== SETTERS ========== */
3715 
3716     /**
3717      * @notice set the FeePool contract as it is the only authority to be able to call
3718      * appendAccountIssuanceRecord with the onlyFeePool modifer
3719      * @dev Must be set by owner when FeePool logic is upgraded
3720      */
3721     function setFeePool(IFeePool _feePool)
3722         external
3723         onlyOwner
3724     {
3725         feePool = _feePool;
3726     }
3727 
3728     /* ========== VIEWS ========== */
3729 
3730     /**
3731      * @notice Get an accounts issuanceData for
3732      * @param account users account
3733      * @param index Index in the array to retrieve. Upto FEE_PERIOD_LENGTH
3734      */
3735     function getAccountsDebtEntry(address account, uint index)
3736         public
3737         view
3738         returns (uint debtPercentage, uint debtEntryIndex)
3739     {
3740         require(index < FEE_PERIOD_LENGTH, "index exceeds the FEE_PERIOD_LENGTH");
3741 
3742         debtPercentage = accountIssuanceLedger[account][index].debtPercentage;
3743         debtEntryIndex = accountIssuanceLedger[account][index].debtEntryIndex;
3744     }
3745 
3746     /**
3747      * @notice Find the oldest debtEntryIndex for the corresponding closingDebtIndex
3748      * @param account users account
3749      * @param closingDebtIndex the last periods debt index on close
3750      */
3751     function applicableIssuanceData(address account, uint closingDebtIndex)
3752         external
3753         view
3754         returns (uint, uint)
3755     {
3756         IssuanceData[FEE_PERIOD_LENGTH] memory issuanceData = accountIssuanceLedger[account];
3757         
3758         // We want to use the user's debtEntryIndex at when the period closed
3759         // Find the oldest debtEntryIndex for the corresponding closingDebtIndex
3760         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
3761             if (closingDebtIndex >= issuanceData[i].debtEntryIndex) {
3762                 return (issuanceData[i].debtPercentage, issuanceData[i].debtEntryIndex);
3763             }
3764         }
3765     }
3766 
3767     /* ========== MUTATIVE FUNCTIONS ========== */
3768 
3769     /**
3770      * @notice Logs an accounts issuance data in the current fee period which is then stored historically
3771      * @param account Message.Senders account address
3772      * @param debtRatio Debt percentage this account has locked after minting or burning their synth
3773      * @param debtEntryIndex The index in the global debt ledger. synthetix.synthetixState().issuanceData(account)
3774      * @param currentPeriodStartDebtIndex The startingDebtIndex of the current fee period
3775      * @dev onlyFeePool to call me on synthetix.issue() & synthetix.burn() calls to store the locked SNX
3776      * per fee period so we know to allocate the correct proportions of fees and rewards per period
3777       accountIssuanceLedger[account][0] has the latest locked amount for the current period. This can be update as many time
3778       accountIssuanceLedger[account][1-3] has the last locked amount for a previous period they minted or burned
3779      */
3780     function appendAccountIssuanceRecord(address account, uint debtRatio, uint debtEntryIndex, uint currentPeriodStartDebtIndex)
3781         external
3782         onlyFeePool
3783     {
3784         // Is the current debtEntryIndex within this fee period
3785         if (accountIssuanceLedger[account][0].debtEntryIndex < currentPeriodStartDebtIndex) {
3786              // If its older then shift the previous IssuanceData entries periods down to make room for the new one.
3787             issuanceDataIndexOrder(account);
3788         }
3789         
3790         // Always store the latest IssuanceData entry at [0]
3791         accountIssuanceLedger[account][0].debtPercentage = debtRatio;
3792         accountIssuanceLedger[account][0].debtEntryIndex = debtEntryIndex;
3793     }
3794 
3795     /**
3796      * @notice Pushes down the entire array of debt ratios per fee period
3797      */
3798     function issuanceDataIndexOrder(address account)
3799         private
3800     {
3801         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
3802             uint next = i + 1;
3803             accountIssuanceLedger[account][next].debtPercentage = accountIssuanceLedger[account][i].debtPercentage;
3804             accountIssuanceLedger[account][next].debtEntryIndex = accountIssuanceLedger[account][i].debtEntryIndex;
3805         }
3806     }
3807 
3808     /**
3809      * @notice Import issuer data from synthetixState.issuerData on FeePeriodClose() block #
3810      * @dev Only callable by the contract owner, and only for 6 weeks after deployment.
3811      * @param accounts Array of issuing addresses
3812      * @param ratios Array of debt ratios
3813      * @param periodToInsert The Fee Period to insert the historical records into
3814      * @param feePeriodCloseIndex An accounts debtEntryIndex is valid when within the fee peroid,
3815      * since the input ratio will be an average of the pervious periods it just needs to be
3816      * > recentFeePeriods[periodToInsert].startingDebtIndex
3817      * < recentFeePeriods[periodToInsert - 1].startingDebtIndex
3818      */
3819     function importIssuerData(address[] accounts, uint[] ratios, uint periodToInsert, uint feePeriodCloseIndex)
3820         external
3821         onlyOwner
3822         onlyDuringSetup
3823     {
3824         require(accounts.length == ratios.length, "Length mismatch");
3825 
3826         for (uint8 i = 0; i < accounts.length; i++) {
3827             accountIssuanceLedger[accounts[i]][periodToInsert].debtPercentage = ratios[i];
3828             accountIssuanceLedger[accounts[i]][periodToInsert].debtEntryIndex = feePeriodCloseIndex;
3829             emit IssuanceDebtRatioEntry(accounts[i], ratios[i], feePeriodCloseIndex);
3830         }
3831     }
3832 
3833     /* ========== MODIFIERS ========== */
3834 
3835     modifier onlyFeePool
3836     {
3837         require(msg.sender == address(feePool), "Only the FeePool contract can perform this action");
3838         _;
3839     }
3840 
3841     /* ========== Events ========== */
3842     event IssuanceDebtRatioEntry(address indexed account, uint debtRatio, uint feePeriodCloseIndex);
3843 }
3844 
3845 
3846 /*
3847 -----------------------------------------------------------------
3848 FILE INFORMATION
3849 -----------------------------------------------------------------
3850 
3851 file:       EternalStorage.sol
3852 version:    1.0
3853 author:     Clinton Ennise
3854             Jackson Chan
3855 
3856 date:       2019-02-01
3857 
3858 -----------------------------------------------------------------
3859 MODULE DESCRIPTION
3860 -----------------------------------------------------------------
3861 
3862 This contract is used with external state storage contracts for
3863 decoupled data storage.
3864 
3865 Implements support for storing a keccak256 key and value pairs. It is
3866 the more flexible and extensible option. This ensures data schema
3867 changes can be implemented without requiring upgrades to the
3868 storage contract
3869 
3870 The first deployed storage contract would create this eternal storage.
3871 Favour use of keccak256 key over sha3 as future version of solidity
3872 > 0.5.0 will be deprecated.
3873 
3874 -----------------------------------------------------------------
3875 */
3876 
3877 
3878 /**
3879  * @notice  This contract is based on the code available from this blog
3880  * https://blog.colony.io/writing-upgradeable-contracts-in-solidity-6743f0eecc88/
3881  * Implements support for storing a keccak256 key and value pairs. It is the more flexible
3882  * and extensible option. This ensures data schema changes can be implemented without
3883  * requiring upgrades to the storage contract.
3884  */
3885 contract EternalStorage is State {
3886 
3887     constructor(address _owner, address _associatedContract)
3888         State(_owner, _associatedContract)
3889         public
3890     {
3891     }
3892 
3893     /* ========== DATA TYPES ========== */
3894     mapping(bytes32 => uint) UIntStorage;
3895     mapping(bytes32 => string) StringStorage;
3896     mapping(bytes32 => address) AddressStorage;
3897     mapping(bytes32 => bytes) BytesStorage;
3898     mapping(bytes32 => bytes32) Bytes32Storage;
3899     mapping(bytes32 => bool) BooleanStorage;
3900     mapping(bytes32 => int) IntStorage;
3901 
3902     // UIntStorage;
3903     function getUIntValue(bytes32 record) external view returns (uint){
3904         return UIntStorage[record];
3905     }
3906 
3907     function setUIntValue(bytes32 record, uint value) external
3908         onlyAssociatedContract
3909     {
3910         UIntStorage[record] = value;
3911     }
3912 
3913     function deleteUIntValue(bytes32 record) external
3914         onlyAssociatedContract
3915     {
3916         delete UIntStorage[record];
3917     }
3918 
3919     // StringStorage
3920     function getStringValue(bytes32 record) external view returns (string memory){
3921         return StringStorage[record];
3922     }
3923 
3924     function setStringValue(bytes32 record, string value) external
3925         onlyAssociatedContract
3926     {
3927         StringStorage[record] = value;
3928     }
3929 
3930     function deleteStringValue(bytes32 record) external
3931         onlyAssociatedContract
3932     {
3933         delete StringStorage[record];
3934     }
3935 
3936     // AddressStorage
3937     function getAddressValue(bytes32 record) external view returns (address){
3938         return AddressStorage[record];
3939     }
3940 
3941     function setAddressValue(bytes32 record, address value) external
3942         onlyAssociatedContract
3943     {
3944         AddressStorage[record] = value;
3945     }
3946 
3947     function deleteAddressValue(bytes32 record) external
3948         onlyAssociatedContract
3949     {
3950         delete AddressStorage[record];
3951     }
3952 
3953 
3954     // BytesStorage
3955     function getBytesValue(bytes32 record) external view returns
3956     (bytes memory){
3957         return BytesStorage[record];
3958     }
3959 
3960     function setBytesValue(bytes32 record, bytes value) external
3961         onlyAssociatedContract
3962     {
3963         BytesStorage[record] = value;
3964     }
3965 
3966     function deleteBytesValue(bytes32 record) external
3967         onlyAssociatedContract
3968     {
3969         delete BytesStorage[record];
3970     }
3971 
3972     // Bytes32Storage
3973     function getBytes32Value(bytes32 record) external view returns (bytes32)
3974     {
3975         return Bytes32Storage[record];
3976     }
3977 
3978     function setBytes32Value(bytes32 record, bytes32 value) external
3979         onlyAssociatedContract
3980     {
3981         Bytes32Storage[record] = value;
3982     }
3983 
3984     function deleteBytes32Value(bytes32 record) external
3985         onlyAssociatedContract
3986     {
3987         delete Bytes32Storage[record];
3988     }
3989 
3990     // BooleanStorage
3991     function getBooleanValue(bytes32 record) external view returns (bool)
3992     {
3993         return BooleanStorage[record];
3994     }
3995 
3996     function setBooleanValue(bytes32 record, bool value) external
3997         onlyAssociatedContract
3998     {
3999         BooleanStorage[record] = value;
4000     }
4001 
4002     function deleteBooleanValue(bytes32 record) external
4003         onlyAssociatedContract
4004     {
4005         delete BooleanStorage[record];
4006     }
4007 
4008     // IntStorage
4009     function getIntValue(bytes32 record) external view returns (int){
4010         return IntStorage[record];
4011     }
4012 
4013     function setIntValue(bytes32 record, int value) external
4014         onlyAssociatedContract
4015     {
4016         IntStorage[record] = value;
4017     }
4018 
4019     function deleteIntValue(bytes32 record) external
4020         onlyAssociatedContract
4021     {
4022         delete IntStorage[record];
4023     }
4024 }
4025 
4026 /*
4027 -----------------------------------------------------------------
4028 FILE INFORMATION
4029 -----------------------------------------------------------------
4030 
4031 file:       FeePoolEternalStorage.sol
4032 version:    1.0
4033 author:     Clinton Ennis
4034             Jackson Chan
4035 date:       2019-04-05
4036 
4037 -----------------------------------------------------------------
4038 MODULE DESCRIPTION
4039 -----------------------------------------------------------------
4040 
4041 The FeePoolEternalStorage is for any state the FeePool contract
4042 needs to persist between upgrades to the FeePool logic.
4043 
4044 Please see EternalStorage.sol
4045 
4046 -----------------------------------------------------------------
4047 */
4048 
4049 
4050 contract FeePoolEternalStorage is EternalStorage, LimitedSetup {
4051 
4052     bytes32 constant LAST_FEE_WITHDRAWAL = "last_fee_withdrawal";
4053 
4054     /**
4055      * @dev Constructor.
4056      * @param _owner The owner of this contract.
4057      */
4058     constructor(address _owner, address _feePool)
4059         EternalStorage(_owner, _feePool)
4060         LimitedSetup(6 weeks)
4061         public
4062     {
4063     }
4064 
4065     /**
4066      * @notice Import data from FeePool.lastFeeWithdrawal
4067      * @dev Only callable by the contract owner, and only for 6 weeks after deployment.
4068      * @param accounts Array of addresses that have claimed
4069      * @param feePeriodIDs Array feePeriodIDs with the accounts last claim
4070      */
4071     function importFeeWithdrawalData(address[] accounts, uint[] feePeriodIDs)
4072         external
4073         onlyOwner
4074         onlyDuringSetup
4075     {
4076         require(accounts.length == feePeriodIDs.length, "Length mismatch");
4077 
4078         for (uint8 i = 0; i < accounts.length; i++) {
4079             this.setUIntValue(keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, accounts[i])), feePeriodIDs[i]);
4080         }
4081     }
4082 }
4083 
4084 
4085 /*
4086 -----------------------------------------------------------------
4087 FILE INFORMATION
4088 -----------------------------------------------------------------
4089 
4090 file:       DelegateApprovals.sol
4091 version:    1.0
4092 author:     Jackson Chan
4093 checked:    Clinton Ennis
4094 date:       2019-05-01
4095 
4096 -----------------------------------------------------------------
4097 MODULE DESCRIPTION
4098 -----------------------------------------------------------------
4099 
4100 The approval state contract is designed to allow a wallet to
4101 authorise another address to perform actions, on a contract,
4102 on their behalf. This could be an automated service
4103 that would help a wallet claim fees / rewards on their behalf.
4104 
4105 The concept is similar to the ERC20 interface where a wallet can
4106 approve an authorised party to spend on the authorising party's
4107 behalf in the allowance interface.
4108 
4109 Withdrawing approval sets the delegate as false instead of
4110 removing from the approvals list for auditability.
4111 
4112 This contract inherits state for upgradeability / associated
4113 contract.
4114 
4115 -----------------------------------------------------------------
4116 */
4117 
4118 
4119 contract DelegateApprovals is State {
4120 
4121     // Approvals - [authoriser][delegate]
4122     // Each authoriser can have multiple delegates
4123     mapping(address => mapping(address => bool)) public approval;
4124 
4125     /**
4126      * @dev Constructor
4127      * @param _owner The address which controls this contract.
4128      * @param _associatedContract The contract whose approval state this composes.
4129      */
4130     constructor(address _owner, address _associatedContract)
4131         State(_owner, _associatedContract)
4132         public
4133     {}
4134 
4135     function setApproval(address authoriser, address delegate)
4136         external
4137         onlyAssociatedContract
4138     {
4139         approval[authoriser][delegate] = true;
4140         emit Approval(authoriser, delegate);
4141     }
4142 
4143     function withdrawApproval(address authoriser, address delegate)
4144         external
4145         onlyAssociatedContract
4146     {
4147         delete approval[authoriser][delegate];
4148         emit WithdrawApproval(authoriser, delegate);
4149     }
4150 
4151      /* ========== EVENTS ========== */
4152 
4153     event Approval(address indexed authoriser, address delegate);
4154     event WithdrawApproval(address indexed authoriser, address delegate);
4155 }
4156 
4157 
4158 /*
4159 -----------------------------------------------------------------
4160 FILE INFORMATION
4161 -----------------------------------------------------------------
4162 
4163 file:       FeePool.sol
4164 version:    1.0
4165 author:     Kevin Brown
4166 date:       2018-10-15
4167 
4168 -----------------------------------------------------------------
4169 MODULE DESCRIPTION
4170 -----------------------------------------------------------------
4171 
4172 The FeePool is a place for users to interact with the fees that
4173 have been generated from the Synthetix system if they've helped
4174 to create the economy.
4175 
4176 Users stake Synthetix to create Synths. As Synth users transact,
4177 a small fee is deducted from exchange transactions, which collects
4178 in the fee pool. Fees are immediately converted to XDRs, a type
4179 of reserve currency similar to SDRs used by the IMF:
4180 https://www.imf.org/en/About/Factsheets/Sheets/2016/08/01/14/51/Special-Drawing-Right-SDR
4181 
4182 Users are entitled to withdraw fees from periods that they participated
4183 in fully, e.g. they have to stake before the period starts. They
4184 can withdraw fees for the last 6 periods as a single lump sum.
4185 Currently fee periods are 7 days long, meaning it's assumed
4186 users will withdraw their fees approximately once a month. Fees
4187 which are not withdrawn are redistributed to the whole pool,
4188 enabling these non-claimed fees to go back to the rest of the commmunity.
4189 
4190 Fees can be withdrawn in any synth currency.
4191 
4192 -----------------------------------------------------------------
4193 */
4194 
4195 
4196 contract FeePool is Proxyable, SelfDestructible, LimitedSetup {
4197 
4198     using SafeMath for uint;
4199     using SafeDecimalMath for uint;
4200 
4201     Synthetix public synthetix;
4202     ISynthetixState public synthetixState;
4203     ISynthetixEscrow public rewardEscrow;
4204     FeePoolEternalStorage public feePoolEternalStorage;
4205 
4206     // A percentage fee charged on each transfer.
4207     uint public transferFeeRate;
4208 
4209     // Transfer fee may not exceed 10%.
4210     uint constant public MAX_TRANSFER_FEE_RATE = SafeDecimalMath.unit() / 10;
4211 
4212     // A percentage fee charged on each exchange between currencies.
4213     uint public exchangeFeeRate;
4214 
4215     // Exchange fee may not exceed 10%.
4216     uint constant public MAX_EXCHANGE_FEE_RATE = SafeDecimalMath.unit() / 10;
4217 
4218     // The address with the authority to distribute fees.
4219     address public feeAuthority;
4220 
4221     // The address to the FeePoolState Contract.
4222     FeePoolState public feePoolState;
4223 
4224     // The address to the DelegateApproval contract.
4225     DelegateApprovals public delegates;
4226 
4227     // Where fees are pooled in XDRs.
4228     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
4229 
4230     // This struct represents the issuance activity that's happened in a fee period.
4231     struct FeePeriod {
4232         uint feePeriodId;
4233         uint startingDebtIndex;
4234         uint startTime;
4235         uint feesToDistribute;
4236         uint feesClaimed;
4237         uint rewardsToDistribute;
4238         uint rewardsClaimed;
4239     }
4240 
4241     // The last 6 fee periods are all that you can claim from.
4242     // These are stored and managed from [0], such that [0] is always
4243     // the most recent fee period, and [3] is always the oldest fee
4244     // period that users can claim for.
4245     uint8 constant public FEE_PERIOD_LENGTH = 3;
4246 
4247     FeePeriod[FEE_PERIOD_LENGTH] public recentFeePeriods;
4248 
4249     // How long a fee period lasts at a minimum. It is required for the
4250     // fee authority to roll over the periods, so they are not guaranteed
4251     // to roll over at exactly this duration, but the contract enforces
4252     // that they cannot roll over any quicker than this duration.
4253     uint public feePeriodDuration = 1 weeks;
4254     // The fee period must be between 1 day and 60 days.
4255     uint public constant MIN_FEE_PERIOD_DURATION = 1 days;
4256     uint public constant MAX_FEE_PERIOD_DURATION = 60 days;
4257 
4258     // Users are unable to claim fees if their collateralisation ratio drifts out of target treshold
4259     uint public TARGET_THRESHOLD = (10 * SafeDecimalMath.unit()) / 100;
4260 
4261     /* ========== ETERNAL STORAGE CONSTANTS ========== */
4262 
4263     bytes32 constant LAST_FEE_WITHDRAWAL = "last_fee_withdrawal";
4264 
4265     constructor(
4266         address _proxy,
4267         address _owner,
4268         Synthetix _synthetix,
4269         FeePoolState _feePoolState,
4270         FeePoolEternalStorage _feePoolEternalStorage,
4271         ISynthetixState _synthetixState,
4272         ISynthetixEscrow _rewardEscrow,
4273         address _feeAuthority,
4274         uint _transferFeeRate,
4275         uint _exchangeFeeRate)
4276         SelfDestructible(_owner)
4277         Proxyable(_proxy, _owner)
4278         LimitedSetup(3 weeks)
4279         public
4280     {
4281         // Constructed fee rates should respect the maximum fee rates.
4282         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
4283         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Constructed exchange fee rate should respect the maximum fee rate");
4284 
4285         synthetix = _synthetix;
4286         feePoolState = _feePoolState;
4287         feePoolEternalStorage = _feePoolEternalStorage;
4288         rewardEscrow = _rewardEscrow;
4289         synthetixState = _synthetixState;
4290         feeAuthority = _feeAuthority;
4291         transferFeeRate = _transferFeeRate;
4292         exchangeFeeRate = _exchangeFeeRate;
4293 
4294         // Set our initial fee period
4295         recentFeePeriods[0].feePeriodId = 1;
4296         recentFeePeriods[0].startTime = now;
4297     }
4298 
4299     /**
4300      * @notice Logs an accounts issuance data per fee period
4301      * @param account Message.Senders account address
4302      * @param debtRatio Debt percentage this account has locked after minting or burning their synth
4303      * @param debtEntryIndex The index in the global debt ledger. synthetix.synthetixState().issuanceData(account)
4304      * @dev onlySynthetix to call me on synthetix.issue() & synthetix.burn() calls to store the locked SNX
4305      * per fee period so we know to allocate the correct proportions of fees and rewards per period
4306      */
4307     function appendAccountIssuanceRecord(address account, uint debtRatio, uint debtEntryIndex)
4308         external
4309         onlySynthetix
4310     {
4311         feePoolState.appendAccountIssuanceRecord(account, debtRatio, debtEntryIndex, recentFeePeriods[0].startingDebtIndex);
4312 
4313         emitIssuanceDebtRatioEntry(account, debtRatio, debtEntryIndex, recentFeePeriods[0].startingDebtIndex);
4314     }
4315 
4316     /**
4317      * @notice Set the exchange fee, anywhere within the range 0-10%.
4318      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
4319      */
4320     function setExchangeFeeRate(uint _exchangeFeeRate)
4321         external
4322         optionalProxy_onlyOwner
4323     {
4324         exchangeFeeRate = _exchangeFeeRate;
4325     }
4326 
4327     /**
4328      * @notice Set the transfer fee, anywhere within the range 0-10%.
4329      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
4330      */
4331     function setTransferFeeRate(uint _transferFeeRate)
4332         external
4333         optionalProxy_onlyOwner
4334     {
4335         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
4336 
4337         transferFeeRate = _transferFeeRate;
4338     }
4339 
4340     /**
4341      * @notice Set the address of the user/contract responsible for collecting or
4342      * distributing fees.
4343      */
4344     function setFeeAuthority(address _feeAuthority)
4345         external
4346         optionalProxy_onlyOwner
4347     {
4348         feeAuthority = _feeAuthority;
4349     }
4350 
4351     /**
4352      * @notice Set the address of the contract for feePool state
4353      */
4354     function setFeePoolState(FeePoolState _feePoolState)
4355         external
4356         optionalProxy_onlyOwner
4357     {
4358         feePoolState = _feePoolState;
4359     }
4360 
4361     /**
4362      * @notice Set the address of the contract for delegate approvals
4363      */
4364     function setDelegateApprovals(DelegateApprovals _delegates)
4365         external
4366         optionalProxy_onlyOwner
4367     {
4368         delegates = _delegates;
4369     }
4370 
4371     /**
4372      * @notice Set the fee period duration
4373      */
4374     function setFeePeriodDuration(uint _feePeriodDuration)
4375         external
4376         optionalProxy_onlyOwner
4377     {
4378         require(_feePeriodDuration >= MIN_FEE_PERIOD_DURATION, "New fee period cannot be less than minimum fee period duration");
4379         require(_feePeriodDuration <= MAX_FEE_PERIOD_DURATION, "New fee period cannot be greater than maximum fee period duration");
4380 
4381         feePeriodDuration = _feePeriodDuration;
4382 
4383         emitFeePeriodDurationUpdated(_feePeriodDuration);
4384     }
4385 
4386     /**
4387      * @notice Set the synthetix contract
4388      */
4389     function setSynthetix(Synthetix _synthetix)
4390         external
4391         optionalProxy_onlyOwner
4392     {
4393         require(address(_synthetix) != address(0), "New Synthetix must be non-zero");
4394 
4395         synthetix = _synthetix;
4396     }
4397 
4398     function setTargetThreshold(uint _percent)
4399         external
4400         optionalProxy_onlyOwner
4401     {
4402         require(_percent >= 0, "Threshold should be positive");
4403         TARGET_THRESHOLD = (_percent * SafeDecimalMath.unit()) / 100;
4404     }
4405 
4406     /**
4407      * @notice The Synthetix contract informs us when fees are paid.
4408      */
4409     function feePaid(bytes4 currencyKey, uint amount)
4410         external
4411         onlySynthetix
4412     {
4413         uint xdrAmount;
4414 
4415         if (currencyKey != "XDR") {
4416             xdrAmount = synthetix.effectiveValue(currencyKey, amount, "XDR");
4417         } else {
4418             xdrAmount = amount;
4419         }
4420 
4421         // Keep track of in XDRs in our fee pool.
4422         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.add(xdrAmount);
4423     }
4424 
4425     /**
4426      * @notice The Synthetix contract informs us when SNX Rewards are minted to RewardEscrow to be claimed.
4427      */
4428     function rewardsMinted(uint amount)
4429         external
4430         onlySynthetix
4431     {
4432         // Add the newly minted SNX rewards on top of the rolling unclaimed amount
4433         recentFeePeriods[0].rewardsToDistribute = recentFeePeriods[0].rewardsToDistribute.add(amount);
4434     }
4435 
4436     /**
4437      * @notice Close the current fee period and start a new one. Only callable by the fee authority.
4438      */
4439     function closeCurrentFeePeriod()
4440         external
4441         optionalProxy_onlyFeeAuthority
4442     {
4443         require(recentFeePeriods[0].startTime <= (now - feePeriodDuration), "It is too early to close the current fee period");
4444 
4445         FeePeriod memory secondLastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 2];
4446         FeePeriod memory lastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 1];
4447 
4448         // Any unclaimed fees from the last period in the array roll back one period.
4449         // Because of the subtraction here, they're effectively proportionally redistributed to those who
4450         // have already claimed from the old period, available in the new period.
4451         // The subtraction is important so we don't create a ticking time bomb of an ever growing
4452         // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
4453         recentFeePeriods[FEE_PERIOD_LENGTH - 2].feesToDistribute = lastFeePeriod.feesToDistribute
4454             .sub(lastFeePeriod.feesClaimed)
4455             .add(secondLastFeePeriod.feesToDistribute);
4456         recentFeePeriods[FEE_PERIOD_LENGTH - 2].rewardsToDistribute = lastFeePeriod.rewardsToDistribute
4457             .sub(lastFeePeriod.rewardsClaimed)
4458             .add(secondLastFeePeriod.rewardsToDistribute);
4459 
4460         // Shift the previous fee periods across to make room for the new one.
4461         // Condition checks for overflow when uint subtracts one from zero
4462         // Could be written with int instead of uint, but then we have to convert everywhere
4463         // so it felt better from a gas perspective to just change the condition to check
4464         // for overflow after subtracting one from zero.
4465         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
4466             uint next = i + 1;
4467             recentFeePeriods[next].feePeriodId = recentFeePeriods[i].feePeriodId;
4468             recentFeePeriods[next].startingDebtIndex = recentFeePeriods[i].startingDebtIndex;
4469             recentFeePeriods[next].startTime = recentFeePeriods[i].startTime;
4470             recentFeePeriods[next].feesToDistribute = recentFeePeriods[i].feesToDistribute;
4471             recentFeePeriods[next].feesClaimed = recentFeePeriods[i].feesClaimed;
4472             recentFeePeriods[next].rewardsToDistribute = recentFeePeriods[i].rewardsToDistribute;
4473             recentFeePeriods[next].rewardsClaimed = recentFeePeriods[i].rewardsClaimed;
4474         }
4475 
4476         // Clear the first element of the array to make sure we don't have any stale values.
4477         delete recentFeePeriods[0];
4478 
4479         // Open up the new fee period. Take a snapshot of the total value of the system.
4480         // Increment periodId from the recent closed period feePeriodId
4481         recentFeePeriods[0].feePeriodId = recentFeePeriods[1].feePeriodId.add(1);
4482         recentFeePeriods[0].startingDebtIndex = synthetixState.debtLedgerLength();
4483         recentFeePeriods[0].startTime = now;
4484 
4485         emitFeePeriodClosed(recentFeePeriods[1].feePeriodId);
4486     }
4487 
4488     /**
4489     * @notice Claim fees for last period when available or not already withdrawn.
4490     * @param currencyKey Synth currency you wish to receive the fees in.
4491     */
4492     function claimFees(bytes4 currencyKey)
4493         external
4494         optionalProxy
4495         returns (bool)
4496     {
4497         return _claimFees(messageSender, currencyKey);
4498     }
4499 
4500     function claimOnBehalf(address claimingForAddress, bytes4 currencyKey)
4501         external
4502         optionalProxy
4503         returns (bool)
4504     {
4505         require(delegates.approval(claimingForAddress, messageSender), "Not approved to claim on behalf this address");
4506 
4507         return _claimFees(claimingForAddress, currencyKey);
4508     }
4509 
4510     function _claimFees(address claimingAddress, bytes4 currencyKey)
4511         internal
4512         returns (bool)
4513     {
4514         uint rewardsPaid;
4515         uint feesPaid;
4516         uint availableFees;
4517         uint availableRewards;
4518 
4519         // Address wont be able to claim fees if it is to far below the target c-ratio.
4520         // It will need to burn synths then try claiming again.
4521         require(feesClaimable(claimingAddress), "C-Ratio below penalty threshold");
4522 
4523         // Get the claimingAddress available fees and rewards
4524         (availableFees, availableRewards) = feesAvailable(claimingAddress, "XDR");
4525 
4526         require(availableFees > 0 || availableRewards > 0, "No fees or rewards available for period, or fees already claimed");
4527 
4528         // Record the address has claimed for this period
4529         _setLastFeeWithdrawal(claimingAddress, recentFeePeriods[1].feePeriodId);
4530 
4531         if (availableFees > 0) {
4532             // Record the fee payment in our recentFeePeriods
4533             feesPaid = _recordFeePayment(availableFees);
4534 
4535             // Send them their fees
4536             _payFees(claimingAddress, feesPaid, currencyKey);
4537         }
4538 
4539         if (availableRewards > 0) {
4540             // Record the reward payment in our recentFeePeriods
4541             rewardsPaid = _recordRewardPayment(availableRewards);
4542 
4543             // Send them their rewards
4544             _payRewards(claimingAddress, rewardsPaid);
4545         }
4546 
4547         emitFeesClaimed(claimingAddress, feesPaid, rewardsPaid);
4548 
4549         return true;
4550     }
4551 
4552     function importFeePeriod(
4553         uint feePeriodIndex, uint feePeriodId, uint startingDebtIndex, uint startTime,
4554         uint feesToDistribute, uint feesClaimed, uint rewardsToDistribute, uint rewardsClaimed)
4555         public
4556         optionalProxy_onlyOwner
4557         onlyDuringSetup
4558     {
4559         recentFeePeriods[feePeriodIndex].feePeriodId = feePeriodId;
4560         recentFeePeriods[feePeriodIndex].startingDebtIndex = startingDebtIndex;
4561         recentFeePeriods[feePeriodIndex].startTime = startTime;
4562         recentFeePeriods[feePeriodIndex].feesToDistribute = feesToDistribute;
4563         recentFeePeriods[feePeriodIndex].feesClaimed = feesClaimed;
4564         recentFeePeriods[feePeriodIndex].rewardsToDistribute = rewardsToDistribute;
4565         recentFeePeriods[feePeriodIndex].rewardsClaimed = rewardsClaimed;
4566     }
4567 
4568     function approveClaimOnBehalf(address account)
4569         public
4570         optionalProxy
4571     {
4572         require(delegates != address(0), "Delegates Approval destination missing");
4573         require(account != address(0), "Can't delegate to address(0)");
4574         delegates.setApproval(messageSender, account);
4575     }
4576 
4577     function removeClaimOnBehalf(address account)
4578         public
4579         optionalProxy
4580     {
4581         require(delegates != address(0), "Delegates Approval destination missing");
4582         delegates.withdrawApproval(messageSender, account);
4583     }
4584 
4585     /**
4586      * @notice Record the fee payment in our recentFeePeriods.
4587      * @param xdrAmount The amount of fees priced in XDRs.
4588      */
4589     function _recordFeePayment(uint xdrAmount)
4590         internal
4591         returns (uint)
4592     {
4593         // Don't assign to the parameter
4594         uint remainingToAllocate = xdrAmount;
4595 
4596         uint feesPaid;
4597         // Start at the oldest period and record the amount, moving to newer periods
4598         // until we've exhausted the amount.
4599         // The condition checks for overflow because we're going to 0 with an unsigned int.
4600         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
4601             uint delta = recentFeePeriods[i].feesToDistribute.sub(recentFeePeriods[i].feesClaimed);
4602 
4603             if (delta > 0) {
4604                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
4605                 uint amountInPeriod = delta < remainingToAllocate ? delta : remainingToAllocate;
4606 
4607                 recentFeePeriods[i].feesClaimed = recentFeePeriods[i].feesClaimed.add(amountInPeriod);
4608                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
4609                 feesPaid = feesPaid.add(amountInPeriod);
4610 
4611                 // No need to continue iterating if we've recorded the whole amount;
4612                 if (remainingToAllocate == 0) return feesPaid;
4613 
4614                 // We've exhausted feePeriods to distribute and no fees remain in last period
4615                 // User last to claim would in this scenario have their remainder slashed
4616                 if (i == 0 && remainingToAllocate > 0) {
4617                     remainingToAllocate = 0;
4618                 }
4619             }
4620         }
4621 
4622         return feesPaid;
4623     }
4624 
4625     /**
4626      * @notice Record the reward payment in our recentFeePeriods.
4627      * @param snxAmount The amount of SNX tokens.
4628      */
4629     function _recordRewardPayment(uint snxAmount)
4630         internal
4631         returns (uint)
4632     {
4633         // Don't assign to the parameter
4634         uint remainingToAllocate = snxAmount;
4635 
4636         uint rewardPaid;
4637 
4638         // Start at the oldest period and record the amount, moving to newer periods
4639         // until we've exhausted the amount.
4640         // The condition checks for overflow because we're going to 0 with an unsigned int.
4641         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
4642             uint toDistribute = recentFeePeriods[i].rewardsToDistribute.sub(recentFeePeriods[i].rewardsClaimed);
4643 
4644             if (toDistribute > 0) {
4645                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
4646                 uint amountInPeriod = toDistribute < remainingToAllocate ? toDistribute : remainingToAllocate;
4647 
4648                 recentFeePeriods[i].rewardsClaimed = recentFeePeriods[i].rewardsClaimed.add(amountInPeriod);
4649                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
4650                 rewardPaid = rewardPaid.add(amountInPeriod);
4651 
4652                 // No need to continue iterating if we've recorded the whole amount;
4653                 if (remainingToAllocate == 0) return rewardPaid;
4654 
4655                 // We've exhausted feePeriods to distribute and no rewards remain in last period
4656                 // User last to claim would in this scenario have their remainder slashed
4657                 // due to rounding up of PreciseDecimal
4658                 if (i == 0 && remainingToAllocate > 0) {
4659                     remainingToAllocate = 0;
4660                 }
4661             }
4662         }
4663         return rewardPaid;
4664     }
4665 
4666     /**
4667     * @notice Send the fees to claiming address.
4668     * @param account The address to send the fees to.
4669     * @param xdrAmount The amount of fees priced in XDRs.
4670     * @param destinationCurrencyKey The synth currency the user wishes to receive their fees in (convert to this currency).
4671     */
4672     function _payFees(address account, uint xdrAmount, bytes4 destinationCurrencyKey)
4673         internal
4674         notFeeAddress(account)
4675     {
4676         require(account != address(0), "Account can't be 0");
4677         require(account != address(this), "Can't send fees to fee pool");
4678         require(account != address(proxy), "Can't send fees to proxy");
4679         require(account != address(synthetix), "Can't send fees to synthetix");
4680 
4681         Synth xdrSynth = synthetix.synths("XDR");
4682         Synth destinationSynth = synthetix.synths(destinationCurrencyKey);
4683 
4684         // Note: We don't need to check the fee pool balance as the burn() below will do a safe subtraction which requires
4685         // the subtraction to not overflow, which would happen if the balance is not sufficient.
4686 
4687         // Burn the source amount
4688         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
4689 
4690         // How much should they get in the destination currency?
4691         uint destinationAmount = synthetix.effectiveValue("XDR", xdrAmount, destinationCurrencyKey);
4692 
4693         // There's no fee on withdrawing fees, as that'd be way too meta.
4694 
4695         // Mint their new synths
4696         destinationSynth.issue(account, destinationAmount);
4697 
4698         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
4699 
4700         // Call the ERC223 transfer callback if needed
4701         destinationSynth.triggerTokenFallbackIfNeeded(FEE_ADDRESS, account, destinationAmount);
4702     }
4703 
4704     /**
4705     * @notice Send the rewards to claiming address - will be locked in rewardEscrow.
4706     * @param account The address to send the fees to.
4707     * @param snxAmount The amount of SNX.
4708     */
4709     function _payRewards(address account, uint snxAmount)
4710         internal
4711         notFeeAddress(account)
4712     {
4713         require(account != address(0), "Account can't be 0");
4714         require(account != address(this), "Can't send rewards to fee pool");
4715         require(account != address(proxy), "Can't send rewards to proxy");
4716         require(account != address(synthetix), "Can't send rewards to synthetix");
4717 
4718         // Record vesting entry for claiming address and amount
4719         // SNX already minted to rewardEscrow balance
4720         rewardEscrow.appendVestingEntry(account, snxAmount);
4721     }
4722 
4723     /**
4724      * @notice Calculate the Fee charged on top of a value being sent
4725      * @return Return the fee charged
4726      */
4727     function transferFeeIncurred(uint value)
4728         public
4729         view
4730         returns (uint)
4731     {
4732         return value.multiplyDecimal(transferFeeRate);
4733 
4734         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
4735         // This is on the basis that transfers less than this value will result in a nil fee.
4736         // Probably too insignificant to worry about, but the following code will achieve it.
4737         //      if (fee == 0 && transferFeeRate != 0) {
4738         //          return _value;
4739         //      }
4740         //      return fee;
4741     }
4742 
4743     /**
4744      * @notice The value that you would need to send so that the recipient receives
4745      * a specified value.
4746      * @param value The value you want the recipient to receive
4747      */
4748     function transferredAmountToReceive(uint value)
4749         external
4750         view
4751         returns (uint)
4752     {
4753         return value.add(transferFeeIncurred(value));
4754     }
4755 
4756     /**
4757      * @notice The amount the recipient will receive if you send a certain number of tokens.
4758      * @param value The amount of tokens you intend to send.
4759      */
4760     function amountReceivedFromTransfer(uint value)
4761         external
4762         view
4763         returns (uint)
4764     {
4765         return value.divideDecimal(transferFeeRate.add(SafeDecimalMath.unit()));
4766     }
4767 
4768     /**
4769      * @notice Calculate the fee charged on top of a value being sent via an exchange
4770      * @return Return the fee charged
4771      */
4772     function exchangeFeeIncurred(uint value)
4773         public
4774         view
4775         returns (uint)
4776     {
4777         return value.multiplyDecimal(exchangeFeeRate);
4778 
4779         // Exchanges less than the reciprocal of exchangeFeeRate should be completely eaten up by fees.
4780         // This is on the basis that exchanges less than this value will result in a nil fee.
4781         // Probably too insignificant to worry about, but the following code will achieve it.
4782         //      if (fee == 0 && exchangeFeeRate != 0) {
4783         //          return _value;
4784         //      }
4785         //      return fee;
4786     }
4787 
4788     /**
4789      * @notice The value that you would need to get after currency exchange so that the recipient receives
4790      * a specified value.
4791      * @param value The value you want the recipient to receive
4792      */
4793     function exchangedAmountToReceive(uint value)
4794         external
4795         view
4796         returns (uint)
4797     {
4798         return value.add(exchangeFeeIncurred(value));
4799     }
4800 
4801     /**
4802      * @notice The amount the recipient will receive if you are performing an exchange and the
4803      * destination currency will be worth a certain number of tokens.
4804      * @param value The amount of destination currency tokens they received after the exchange.
4805      */
4806     function amountReceivedFromExchange(uint value)
4807         external
4808         view
4809         returns (uint)
4810     {
4811         return value.multiplyDecimal(SafeDecimalMath.unit().sub(exchangeFeeRate));
4812     }
4813 
4814     /**
4815      * @notice The total fees available in the system to be withdrawn, priced in currencyKey currency
4816      * @param currencyKey The currency you want to price the fees in
4817      */
4818     function totalFeesAvailable(bytes4 currencyKey)
4819         external
4820         view
4821         returns (uint)
4822     {
4823         uint totalFees = 0;
4824 
4825         // Fees in fee period [0] are not yet available for withdrawal
4826         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
4827             totalFees = totalFees.add(recentFeePeriods[i].feesToDistribute);
4828             totalFees = totalFees.sub(recentFeePeriods[i].feesClaimed);
4829         }
4830 
4831         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
4832     }
4833 
4834     /**
4835      * @notice The total SNX rewards available in the system to be withdrawn
4836      */
4837     function totalRewardsAvailable()
4838         external
4839         view
4840         returns (uint)
4841     {
4842         uint totalRewards = 0;
4843 
4844         // Rewards in fee period [0] are not yet available for withdrawal
4845         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
4846             totalRewards = totalRewards.add(recentFeePeriods[i].rewardsToDistribute);
4847             totalRewards = totalRewards.sub(recentFeePeriods[i].rewardsClaimed);
4848         }
4849 
4850         return totalRewards;
4851     }
4852 
4853     /**
4854      * @notice The fees available to be withdrawn by a specific account, priced in currencyKey currency
4855      * @dev Returns two amounts, one for fees and one for SNX rewards
4856      * @param currencyKey The currency you want to price the fees in
4857      */
4858     function feesAvailable(address account, bytes4 currencyKey)
4859         public
4860         view
4861         returns (uint, uint)
4862     {
4863         // Add up the fees
4864         uint[2][FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);
4865 
4866         uint totalFees = 0;
4867         uint totalRewards = 0;
4868 
4869         // Fees & Rewards in fee period [0] are not yet available for withdrawal
4870         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
4871             totalFees = totalFees.add(userFees[i][0]);
4872             totalRewards = totalRewards.add(userFees[i][1]);
4873         }
4874 
4875         // And convert totalFees to their desired currency
4876         // Return totalRewards as is in SNX amount
4877         return (
4878             synthetix.effectiveValue("XDR", totalFees, currencyKey),
4879             totalRewards
4880         );
4881     }
4882 
4883     /**
4884      * @notice Check if a particular address is able to claim fees right now
4885      * @param account The address you want to query for
4886      */
4887     function feesClaimable(address account)
4888         public
4889         view
4890         returns (bool)
4891     {
4892         // Threshold is calculated from ratio % above the target ratio (issuanceRatio).
4893         //  0  <  10%:   Claimable
4894         // 10% > above:  Unable to claim
4895         uint ratio = synthetix.collateralisationRatio(account);
4896         uint targetRatio = synthetix.synthetixState().issuanceRatio();
4897 
4898         // Claimable if collateral ratio below target ratio
4899         if (ratio < targetRatio) {
4900             return true;
4901         }
4902 
4903         // Calculate the threshold for collateral ratio before fees can't be claimed.
4904         uint ratio_threshold = targetRatio.multiplyDecimal(SafeDecimalMath.unit().add(TARGET_THRESHOLD));
4905 
4906         // Not claimable if collateral ratio above threshold
4907         if (ratio > ratio_threshold) {
4908             return false;
4909         }
4910 
4911         return true;
4912     }
4913 
4914     /**
4915      * @notice Calculates fees by period for an account, priced in XDRs
4916      * @param account The address you want to query the fees for
4917      */
4918     function feesByPeriod(address account)
4919         public
4920         view
4921         returns (uint[2][FEE_PERIOD_LENGTH] memory results)
4922     {
4923         // What's the user's debt entry index and the debt they owe to the system at current feePeriod
4924         uint userOwnershipPercentage;
4925         uint debtEntryIndex;
4926         (userOwnershipPercentage, debtEntryIndex) = feePoolState.getAccountsDebtEntry(account, 0);
4927 
4928         // If they don't have any debt ownership and they haven't minted, they don't have any fees
4929         if (debtEntryIndex == 0 && userOwnershipPercentage == 0) return;
4930 
4931         // If there are no XDR synths, then they don't have any fees
4932         if (synthetix.totalIssuedSynths("XDR") == 0) return;
4933 
4934         // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
4935         // fees owing for, so we need to report on it anyway.
4936         uint feesFromPeriod;
4937         uint rewardsFromPeriod;
4938         (feesFromPeriod, rewardsFromPeriod) = _feesAndRewardsFromPeriod(0, userOwnershipPercentage, debtEntryIndex);
4939 
4940         results[0][0] = feesFromPeriod;
4941         results[0][1] = rewardsFromPeriod;
4942 
4943         // Go through our fee periods from the oldest feePeriod[FEE_PERIOD_LENGTH - 1] and figure out what we owe them.
4944         // Condition checks for periods > 0
4945         for (uint i = FEE_PERIOD_LENGTH - 1; i > 0; i--) {
4946             uint next = i - 1;
4947             FeePeriod memory nextPeriod = recentFeePeriods[next];
4948 
4949             // We can skip period if no debt minted during period
4950             if (nextPeriod.startingDebtIndex > 0 &&
4951             getLastFeeWithdrawal(account) < recentFeePeriods[i].feePeriodId) {
4952 
4953                 // We calculate a feePeriod's closingDebtIndex by looking at the next feePeriod's startingDebtIndex
4954                 // we can use the most recent issuanceData[0] for the current feePeriod
4955                 // else find the applicableIssuanceData for the feePeriod based on the StartingDebtIndex of the period
4956                 uint closingDebtIndex = nextPeriod.startingDebtIndex.sub(1);
4957 
4958                 // Gas optimisation - to reuse debtEntryIndex if found new applicable one
4959                 // if applicable is 0,0 (none found) we keep most recent one from issuanceData[0]
4960                 // return if userOwnershipPercentage = 0)
4961                 (userOwnershipPercentage, debtEntryIndex) = feePoolState.applicableIssuanceData(account, closingDebtIndex);
4962 
4963                 (feesFromPeriod, rewardsFromPeriod) = _feesAndRewardsFromPeriod(i, userOwnershipPercentage, debtEntryIndex);
4964 
4965                 results[i][0] = feesFromPeriod;
4966                 results[i][1] = rewardsFromPeriod;
4967             }
4968         }
4969     }
4970 
4971     /**
4972      * @notice ownershipPercentage is a high precision decimals uint based on
4973      * wallet's debtPercentage. Gives a precise amount of the feesToDistribute
4974      * for fees in the period. Precision factor is removed before results are
4975      * returned.
4976      */
4977     function _feesAndRewardsFromPeriod(uint period, uint ownershipPercentage, uint debtEntryIndex)
4978         internal
4979         returns (uint, uint)
4980     {
4981         // If it's zero, they haven't issued, and they have no fees OR rewards.
4982         if (ownershipPercentage == 0) return (0, 0);
4983 
4984         uint debtOwnershipForPeriod = ownershipPercentage;
4985 
4986         // If period has closed we want to calculate debtPercentage for the period
4987         if (period > 0) {
4988             uint closingDebtIndex = recentFeePeriods[period - 1].startingDebtIndex.sub(1);
4989             debtOwnershipForPeriod = _effectiveDebtRatioForPeriod(closingDebtIndex, ownershipPercentage, debtEntryIndex);
4990         }
4991 
4992         // Calculate their percentage of the fees / rewards in this period
4993         // This is a high precision integer.
4994         uint feesFromPeriod = recentFeePeriods[period].feesToDistribute
4995             .multiplyDecimal(debtOwnershipForPeriod);
4996 
4997         uint rewardsFromPeriod = recentFeePeriods[period].rewardsToDistribute
4998             .multiplyDecimal(debtOwnershipForPeriod);
4999 
5000         return (
5001             feesFromPeriod.preciseDecimalToDecimal(),
5002             rewardsFromPeriod.preciseDecimalToDecimal()
5003         );
5004     }
5005 
5006     function _effectiveDebtRatioForPeriod(uint closingDebtIndex, uint ownershipPercentage, uint debtEntryIndex)
5007         internal
5008         view
5009         returns (uint)
5010     {
5011         // Condition to check if debtLedger[] has value otherwise return 0
5012         if (closingDebtIndex > synthetixState.debtLedgerLength()) return 0;
5013 
5014         // Figure out their global debt percentage delta at end of fee Period.
5015         // This is a high precision integer.
5016         uint feePeriodDebtOwnership = synthetixState.debtLedger(closingDebtIndex)
5017             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
5018             .multiplyDecimalRoundPrecise(ownershipPercentage);
5019 
5020         return feePeriodDebtOwnership;
5021     }
5022 
5023     function effectiveDebtRatioForPeriod(address account, uint period)
5024         external
5025         view
5026         returns (uint)
5027     {
5028         require(period != 0, "Current period has not closed yet");
5029         require(period < FEE_PERIOD_LENGTH, "Period exceeds the FEE_PERIOD_LENGTH");
5030 
5031         // No debt minted during period as next period starts at 0
5032         if (recentFeePeriods[period - 1].startingDebtIndex == 0) return;
5033 
5034         uint closingDebtIndex = recentFeePeriods[period - 1].startingDebtIndex.sub(1);
5035 
5036         uint ownershipPercentage;
5037         uint debtEntryIndex;
5038         (ownershipPercentage, debtEntryIndex) = feePoolState.applicableIssuanceData(account, closingDebtIndex);
5039 
5040         // internal function will check closingDebtIndex has corresponding debtLedger entry
5041         return _effectiveDebtRatioForPeriod(closingDebtIndex, ownershipPercentage, debtEntryIndex);
5042     }
5043 
5044     /**
5045      * @notice Get the feePeriodID of the last claim this account made
5046      * @param _claimingAddress account to check the last fee period ID claim for
5047      * @return uint of the feePeriodID this account last claimed
5048      */
5049     function getLastFeeWithdrawal(address _claimingAddress)
5050         public
5051         view
5052         returns (uint)
5053     {
5054         return feePoolEternalStorage.getUIntValue(keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, _claimingAddress)));
5055     }
5056 
5057     /**
5058     * @notice Calculate the collateral ratio before user is blocked from claiming.
5059     */
5060     function getPenaltyThresholdRatio()
5061         public
5062         view
5063         returns (uint)
5064     {
5065         uint targetRatio = synthetix.synthetixState().issuanceRatio();
5066 
5067         return targetRatio.multiplyDecimal(SafeDecimalMath.unit().add(TARGET_THRESHOLD));
5068     }
5069 
5070     /* ========== Modifiers ========== */
5071 
5072     /**
5073      * @notice Set the feePeriodID of the last claim this account made
5074      * @param _claimingAddress account to set the last feePeriodID claim for
5075      * @param _feePeriodID the feePeriodID this account claimed fees for
5076      */
5077     function _setLastFeeWithdrawal(address _claimingAddress, uint _feePeriodID)
5078         internal
5079     {
5080         feePoolEternalStorage.setUIntValue(keccak256(abi.encodePacked(LAST_FEE_WITHDRAWAL, _claimingAddress)), _feePeriodID);
5081     }
5082 
5083     modifier optionalProxy_onlyFeeAuthority
5084     {
5085         if (Proxy(msg.sender) != proxy) {
5086             messageSender = msg.sender;
5087         }
5088         require(msg.sender == feeAuthority, "Only the fee authority can perform this action");
5089         _;
5090     }
5091 
5092     modifier onlySynthetix
5093     {
5094         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
5095         _;
5096     }
5097 
5098     modifier notFeeAddress(address account) {
5099         require(account != FEE_ADDRESS, "Fee address not allowed");
5100         _;
5101     }
5102 
5103     /* ========== Proxy Events ========== */
5104 
5105     event IssuanceDebtRatioEntry(address indexed account, uint debtRatio, uint debtEntryIndex, uint feePeriodStartingDebtIndex);
5106     bytes32 constant ISSUANCEDEBTRATIOENTRY_SIG = keccak256("IssuanceDebtRatioEntry(address,uint256,uint256,uint256)");
5107     function emitIssuanceDebtRatioEntry(address account, uint debtRatio, uint debtEntryIndex, uint feePeriodStartingDebtIndex) internal {
5108         proxy._emit(abi.encode(debtRatio, debtEntryIndex, feePeriodStartingDebtIndex), 2, ISSUANCEDEBTRATIOENTRY_SIG, bytes32(account), 0, 0);
5109     }
5110 
5111     event TransferFeeUpdated(uint newFeeRate);
5112     bytes32 constant TRANSFERFEEUPDATED_SIG = keccak256("TransferFeeUpdated(uint256)");
5113     function emitTransferFeeUpdated(uint newFeeRate) internal {
5114         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEEUPDATED_SIG, 0, 0, 0);
5115     }
5116 
5117     event ExchangeFeeUpdated(uint newFeeRate);
5118     bytes32 constant EXCHANGEFEEUPDATED_SIG = keccak256("ExchangeFeeUpdated(uint256)");
5119     function emitExchangeFeeUpdated(uint newFeeRate) internal {
5120         proxy._emit(abi.encode(newFeeRate), 1, EXCHANGEFEEUPDATED_SIG, 0, 0, 0);
5121     }
5122 
5123     event FeePeriodDurationUpdated(uint newFeePeriodDuration);
5124     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
5125     function emitFeePeriodDurationUpdated(uint newFeePeriodDuration) internal {
5126         proxy._emit(abi.encode(newFeePeriodDuration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
5127     }
5128 
5129     event FeePeriodClosed(uint feePeriodId);
5130     bytes32 constant FEEPERIODCLOSED_SIG = keccak256("FeePeriodClosed(uint256)");
5131     function emitFeePeriodClosed(uint feePeriodId) internal {
5132         proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
5133     }
5134 
5135     event FeesClaimed(address account, uint xdrAmount, uint snxRewards);
5136     bytes32 constant FEESCLAIMED_SIG = keccak256("FeesClaimed(address,uint256,uint256)");
5137     function emitFeesClaimed(address account, uint xdrAmount, uint snxRewards) internal {
5138         proxy._emit(abi.encode(account, xdrAmount, snxRewards), 1, FEESCLAIMED_SIG, 0, 0, 0);
5139     }
5140 }