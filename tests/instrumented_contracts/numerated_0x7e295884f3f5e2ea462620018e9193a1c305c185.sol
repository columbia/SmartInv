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
1486     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
1487     // exchange as well as transfer
1488     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
1489         external
1490         onlySynthetixOrFeePool
1491     {
1492         bytes memory empty;
1493         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
1494     }
1495 
1496     /* ========== MODIFIERS ========== */
1497 
1498     modifier onlySynthetixOrFeePool() {
1499         bool isSynthetix = msg.sender == address(synthetix);
1500         bool isFeePool = msg.sender == address(feePool);
1501 
1502         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
1503         _;
1504     }
1505 
1506     modifier notFeeAddress(address account) {
1507         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
1508         _;
1509     }
1510 
1511     /* ========== EVENTS ========== */
1512 
1513     event SynthetixUpdated(address newSynthetix);
1514     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
1515     function emitSynthetixUpdated(address newSynthetix) internal {
1516         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
1517     }
1518 
1519     event FeePoolUpdated(address newFeePool);
1520     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
1521     function emitFeePoolUpdated(address newFeePool) internal {
1522         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
1523     }
1524 
1525     event Issued(address indexed account, uint value);
1526     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
1527     function emitIssued(address account, uint value) internal {
1528         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
1529     }
1530 
1531     event Burned(address indexed account, uint value);
1532     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
1533     function emitBurned(address account, uint value) internal {
1534         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
1535     }
1536 }
1537 
1538 
1539 /*
1540 -----------------------------------------------------------------
1541 FILE INFORMATION
1542 -----------------------------------------------------------------
1543 
1544 file:       FeePool.sol
1545 version:    1.0
1546 author:     Kevin Brown
1547 date:       2018-10-15
1548 
1549 -----------------------------------------------------------------
1550 MODULE DESCRIPTION
1551 -----------------------------------------------------------------
1552 
1553 The FeePool is a place for users to interact with the fees that
1554 have been generated from the Synthetix system if they've helped
1555 to create the economy.
1556 
1557 Users stake Synthetix to create Synths. As Synth users transact,
1558 a small fee is deducted from each transaction, which collects
1559 in the fee pool. Fees are immediately converted to XDRs, a type
1560 of reserve currency similar to SDRs used by the IMF:
1561 https://www.imf.org/en/About/Factsheets/Sheets/2016/08/01/14/51/Special-Drawing-Right-SDR
1562 
1563 Users are entitled to withdraw fees from periods that they participated
1564 in fully, e.g. they have to stake before the period starts. They
1565 can withdraw fees for the last 6 periods as a single lump sum.
1566 Currently fee periods are 7 days long, meaning it's assumed
1567 users will withdraw their fees approximately once a month. Fees
1568 which are not withdrawn are redistributed to the whole pool,
1569 enabling these non-claimed fees to go back to the rest of the commmunity.
1570 
1571 Fees can be withdrawn in any synth currency.
1572 
1573 -----------------------------------------------------------------
1574 */
1575 
1576 
1577 contract FeePool is Proxyable, SelfDestructible {
1578 
1579     using SafeMath for uint;
1580     using SafeDecimalMath for uint;
1581 
1582     Synthetix public synthetix;
1583 
1584     // A percentage fee charged on each transfer.
1585     uint public transferFeeRate;
1586 
1587     // Transfer fee may not exceed 10%.
1588     uint constant public MAX_TRANSFER_FEE_RATE = SafeDecimalMath.unit() / 10;
1589 
1590     // A percentage fee charged on each exchange between currencies.
1591     uint public exchangeFeeRate;
1592 
1593     // Exchange fee may not exceed 10%.
1594     uint constant public MAX_EXCHANGE_FEE_RATE = SafeDecimalMath.unit() / 10;
1595 
1596     // The address with the authority to distribute fees.
1597     address public feeAuthority;
1598 
1599     // Where fees are pooled in XDRs.
1600     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
1601 
1602     // This struct represents the issuance activity that's happened in a fee period.
1603     struct FeePeriod {
1604         uint feePeriodId;
1605         uint startingDebtIndex;
1606         uint startTime;
1607         uint feesToDistribute;
1608         uint feesClaimed;
1609     }
1610 
1611     // The last 6 fee periods are all that you can claim from.
1612     // These are stored and managed from [0], such that [0] is always
1613     // the most recent fee period, and [5] is always the oldest fee
1614     // period that users can claim for.
1615     uint8 constant public FEE_PERIOD_LENGTH = 6;
1616     FeePeriod[FEE_PERIOD_LENGTH] public recentFeePeriods;
1617 
1618     // The next fee period will have this ID.
1619     uint public nextFeePeriodId;
1620 
1621     // How long a fee period lasts at a minimum. It is required for the
1622     // fee authority to roll over the periods, so they are not guaranteed
1623     // to roll over at exactly this duration, but the contract enforces
1624     // that they cannot roll over any quicker than this duration.
1625     uint public feePeriodDuration = 1 weeks;
1626 
1627     // The fee period must be between 1 day and 60 days.
1628     uint public constant MIN_FEE_PERIOD_DURATION = 1 days;
1629     uint public constant MAX_FEE_PERIOD_DURATION = 60 days;
1630 
1631     // The last period a user has withdrawn their fees in, identified by the feePeriodId
1632     mapping(address => uint) public lastFeeWithdrawal;
1633 
1634     // Users receive penalties if their collateralisation ratio drifts out of our desired brackets
1635     // We precompute the brackets and penalties to save gas.
1636     uint constant TWENTY_PERCENT = (20 * SafeDecimalMath.unit()) / 100;
1637     uint constant TWENTY_FIVE_PERCENT = (25 * SafeDecimalMath.unit()) / 100;
1638     uint constant THIRTY_PERCENT = (30 * SafeDecimalMath.unit()) / 100;
1639     uint constant FOURTY_PERCENT = (40 * SafeDecimalMath.unit()) / 100;
1640     uint constant FIFTY_PERCENT = (50 * SafeDecimalMath.unit()) / 100;
1641     uint constant SEVENTY_FIVE_PERCENT = (75 * SafeDecimalMath.unit()) / 100;
1642 
1643     constructor(address _proxy, address _owner, Synthetix _synthetix, address _feeAuthority, uint _transferFeeRate, uint _exchangeFeeRate)
1644         SelfDestructible(_owner)
1645         Proxyable(_proxy, _owner)
1646         public
1647     {
1648         // Constructed fee rates should respect the maximum fee rates.
1649         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
1650         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Constructed exchange fee rate should respect the maximum fee rate");
1651 
1652         synthetix = _synthetix;
1653         feeAuthority = _feeAuthority;
1654         transferFeeRate = _transferFeeRate;
1655         exchangeFeeRate = _exchangeFeeRate;
1656 
1657         // Set our initial fee period
1658         recentFeePeriods[0].feePeriodId = 1;
1659         recentFeePeriods[0].startTime = now;
1660         // Gas optimisation: These do not need to be initialised. They start at 0.
1661         // recentFeePeriods[0].startingDebtIndex = 0;
1662         // recentFeePeriods[0].feesToDistribute = 0;
1663 
1664         // And the next one starts at 2.
1665         nextFeePeriodId = 2;
1666     }
1667 
1668     /**
1669      * @notice Set the exchange fee, anywhere within the range 0-10%.
1670      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1671      */
1672     function setExchangeFeeRate(uint _exchangeFeeRate)
1673         external
1674         optionalProxy_onlyOwner
1675     {
1676         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Exchange fee rate must be below MAX_EXCHANGE_FEE_RATE");
1677 
1678         exchangeFeeRate = _exchangeFeeRate;
1679 
1680         emitExchangeFeeUpdated(_exchangeFeeRate);
1681     }
1682 
1683     /**
1684      * @notice Set the transfer fee, anywhere within the range 0-10%.
1685      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1686      */
1687     function setTransferFeeRate(uint _transferFeeRate)
1688         external
1689         optionalProxy_onlyOwner
1690     {
1691         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
1692 
1693         transferFeeRate = _transferFeeRate;
1694 
1695         emitTransferFeeUpdated(_transferFeeRate);
1696     }
1697 
1698     /**
1699      * @notice Set the address of the user/contract responsible for collecting or
1700      * distributing fees.
1701      */
1702     function setFeeAuthority(address _feeAuthority)
1703         external
1704         optionalProxy_onlyOwner
1705     {
1706         feeAuthority = _feeAuthority;
1707 
1708         emitFeeAuthorityUpdated(_feeAuthority);
1709     }
1710 
1711     /**
1712      * @notice Set the fee period duration
1713      */
1714     function setFeePeriodDuration(uint _feePeriodDuration)
1715         external
1716         optionalProxy_onlyOwner
1717     {
1718         require(_feePeriodDuration >= MIN_FEE_PERIOD_DURATION, "New fee period cannot be less than minimum fee period duration");
1719         require(_feePeriodDuration <= MAX_FEE_PERIOD_DURATION, "New fee period cannot be greater than maximum fee period duration");
1720 
1721         feePeriodDuration = _feePeriodDuration;
1722 
1723         emitFeePeriodDurationUpdated(_feePeriodDuration);
1724     }
1725 
1726     /**
1727      * @notice Set the synthetix contract
1728      */
1729     function setSynthetix(Synthetix _synthetix)
1730         external
1731         optionalProxy_onlyOwner
1732     {
1733         require(address(_synthetix) != address(0), "New Synthetix must be non-zero");
1734 
1735         synthetix = _synthetix;
1736 
1737         emitSynthetixUpdated(_synthetix);
1738     }
1739 
1740     /**
1741      * @notice The Synthetix contract informs us when fees are paid.
1742      */
1743     function feePaid(bytes4 currencyKey, uint amount)
1744         external
1745         onlySynthetix
1746     {
1747         uint xdrAmount = synthetix.effectiveValue(currencyKey, amount, "XDR");
1748 
1749         // Which we keep track of in XDRs in our fee pool.
1750         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.add(xdrAmount);
1751     }
1752 
1753     /**
1754      * @notice Close the current fee period and start a new one. Only callable by the fee authority.
1755      */
1756     function closeCurrentFeePeriod()
1757         external
1758         onlyFeeAuthority
1759     {
1760         require(recentFeePeriods[0].startTime <= (now - feePeriodDuration), "It is too early to close the current fee period");
1761 
1762         FeePeriod memory secondLastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 2];
1763         FeePeriod memory lastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 1];
1764 
1765         // Any unclaimed fees from the last period in the array roll back one period.
1766         // Because of the subtraction here, they're effectively proportionally redistributed to those who
1767         // have already claimed from the old period, available in the new period.
1768         // The subtraction is important so we don't create a ticking time bomb of an ever growing
1769         // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
1770         recentFeePeriods[FEE_PERIOD_LENGTH - 2].feesToDistribute = lastFeePeriod.feesToDistribute
1771             .sub(lastFeePeriod.feesClaimed)
1772             .add(secondLastFeePeriod.feesToDistribute);
1773 
1774         // Shift the previous fee periods across to make room for the new one.
1775         // Condition checks for overflow when uint subtracts one from zero
1776         // Could be written with int instead of uint, but then we have to convert everywhere
1777         // so it felt better from a gas perspective to just change the condition to check
1778         // for overflow after subtracting one from zero.
1779         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
1780             uint next = i + 1;
1781 
1782             recentFeePeriods[next].feePeriodId = recentFeePeriods[i].feePeriodId;
1783             recentFeePeriods[next].startingDebtIndex = recentFeePeriods[i].startingDebtIndex;
1784             recentFeePeriods[next].startTime = recentFeePeriods[i].startTime;
1785             recentFeePeriods[next].feesToDistribute = recentFeePeriods[i].feesToDistribute;
1786             recentFeePeriods[next].feesClaimed = recentFeePeriods[i].feesClaimed;
1787         }
1788 
1789         // Clear the first element of the array to make sure we don't have any stale values.
1790         delete recentFeePeriods[0];
1791 
1792         // Open up the new fee period
1793         recentFeePeriods[0].feePeriodId = nextFeePeriodId;
1794         recentFeePeriods[0].startingDebtIndex = synthetix.synthetixState().debtLedgerLength();
1795         recentFeePeriods[0].startTime = now;
1796 
1797         nextFeePeriodId = nextFeePeriodId.add(1);
1798 
1799         emitFeePeriodClosed(recentFeePeriods[1].feePeriodId);
1800     }
1801 
1802     /**
1803     * @notice Claim fees for last period when available or not already withdrawn.
1804     * @param currencyKey Synth currency you wish to receive the fees in.
1805     */
1806     function claimFees(bytes4 currencyKey)
1807         external
1808         optionalProxy
1809         returns (bool)
1810     {
1811         uint availableFees = feesAvailable(messageSender, "XDR");
1812 
1813         require(availableFees > 0, "No fees available for period, or fees already claimed");
1814 
1815         lastFeeWithdrawal[messageSender] = recentFeePeriods[1].feePeriodId;
1816 
1817         // Record the fee payment in our recentFeePeriods
1818         _recordFeePayment(availableFees);
1819 
1820         // Send them their fees
1821         _payFees(messageSender, availableFees, currencyKey);
1822 
1823         emitFeesClaimed(messageSender, availableFees);
1824 
1825         return true;
1826     }
1827 
1828     /**
1829      * @notice Record the fee payment in our recentFeePeriods.
1830      * @param xdrAmount The amout of fees priced in XDRs.
1831      */
1832     function _recordFeePayment(uint xdrAmount)
1833         internal
1834     {
1835         // Don't assign to the parameter
1836         uint remainingToAllocate = xdrAmount;
1837 
1838         // Start at the oldest period and record the amount, moving to newer periods
1839         // until we've exhausted the amount.
1840         // The condition checks for overflow because we're going to 0 with an unsigned int.
1841         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
1842             uint delta = recentFeePeriods[i].feesToDistribute.sub(recentFeePeriods[i].feesClaimed);
1843 
1844             if (delta > 0) {
1845                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
1846                 uint amountInPeriod = delta < remainingToAllocate ? delta : remainingToAllocate;
1847 
1848                 recentFeePeriods[i].feesClaimed = recentFeePeriods[i].feesClaimed.add(amountInPeriod);
1849                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
1850 
1851                 // No need to continue iterating if we've recorded the whole amount;
1852                 if (remainingToAllocate == 0) return;
1853             }
1854         }
1855 
1856         // If we hit this line, we've exhausted our fee periods, but still have more to allocate. Wat?
1857         // If this happens it's a definite bug in the code, so assert instead of require.
1858         assert(remainingToAllocate == 0);
1859     }
1860 
1861     /**
1862     * @notice Send the fees to claiming address.
1863     * @param account The address to send the fees to.
1864     * @param xdrAmount The amount of fees priced in XDRs.
1865     * @param destinationCurrencyKey The synth currency the user wishes to receive their fees in (convert to this currency).
1866     */
1867     function _payFees(address account, uint xdrAmount, bytes4 destinationCurrencyKey)
1868         internal
1869         notFeeAddress(account)
1870     {
1871         require(account != address(0), "Account can't be 0");
1872         require(account != address(this), "Can't send fees to fee pool");
1873         require(account != address(proxy), "Can't send fees to proxy");
1874         require(account != address(synthetix), "Can't send fees to synthetix");
1875 
1876         Synth xdrSynth = synthetix.synths("XDR");
1877         Synth destinationSynth = synthetix.synths(destinationCurrencyKey);
1878 
1879         // Note: We don't need to check the fee pool balance as the burn() below will do a safe subtraction which requires
1880         // the subtraction to not overflow, which would happen if the balance is not sufficient.
1881 
1882         // Burn the source amount
1883         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
1884 
1885         // How much should they get in the destination currency?
1886         uint destinationAmount = synthetix.effectiveValue("XDR", xdrAmount, destinationCurrencyKey);
1887 
1888         // There's no fee on withdrawing fees, as that'd be way too meta.
1889 
1890         // Mint their new synths
1891         destinationSynth.issue(account, destinationAmount);
1892 
1893         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
1894 
1895         // Call the ERC223 transfer callback if needed
1896         destinationSynth.triggerTokenFallbackIfNeeded(FEE_ADDRESS, account, destinationAmount);
1897     }
1898 
1899     /**
1900      * @notice Calculate the Fee charged on top of a value being sent
1901      * @return Return the fee charged
1902      */
1903     function transferFeeIncurred(uint value)
1904         public
1905         view
1906         returns (uint)
1907     {
1908         return value.multiplyDecimal(transferFeeRate);
1909 
1910         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1911         // This is on the basis that transfers less than this value will result in a nil fee.
1912         // Probably too insignificant to worry about, but the following code will achieve it.
1913         //      if (fee == 0 && transferFeeRate != 0) {
1914         //          return _value;
1915         //      }
1916         //      return fee;
1917     }
1918 
1919     /**
1920      * @notice The value that you would need to send so that the recipient receives
1921      * a specified value.
1922      * @param value The value you want the recipient to receive
1923      */
1924     function transferredAmountToReceive(uint value)
1925         external
1926         view
1927         returns (uint)
1928     {
1929         return value.add(transferFeeIncurred(value));
1930     }
1931 
1932     /**
1933      * @notice The amount the recipient will receive if you send a certain number of tokens.
1934      * @param value The amount of tokens you intend to send.
1935      */
1936     function amountReceivedFromTransfer(uint value)
1937         external
1938         view
1939         returns (uint)
1940     {
1941         return value.divideDecimal(transferFeeRate.add(SafeDecimalMath.unit()));
1942     }
1943 
1944     /**
1945      * @notice Calculate the fee charged on top of a value being sent via an exchange
1946      * @return Return the fee charged
1947      */
1948     function exchangeFeeIncurred(uint value)
1949         public
1950         view
1951         returns (uint)
1952     {
1953         return value.multiplyDecimal(exchangeFeeRate);
1954 
1955         // Exchanges less than the reciprocal of exchangeFeeRate should be completely eaten up by fees.
1956         // This is on the basis that exchanges less than this value will result in a nil fee.
1957         // Probably too insignificant to worry about, but the following code will achieve it.
1958         //      if (fee == 0 && exchangeFeeRate != 0) {
1959         //          return _value;
1960         //      }
1961         //      return fee;
1962     }
1963 
1964     /**
1965      * @notice The value that you would need to get after currency exchange so that the recipient receives
1966      * a specified value.
1967      * @param value The value you want the recipient to receive
1968      */
1969     function exchangedAmountToReceive(uint value)
1970         external
1971         view
1972         returns (uint)
1973     {
1974         return value.add(exchangeFeeIncurred(value));
1975     }
1976 
1977     /**
1978      * @notice The amount the recipient will receive if you are performing an exchange and the
1979      * destination currency will be worth a certain number of tokens.
1980      * @param value The amount of destination currency tokens they received after the exchange.
1981      */
1982     function amountReceivedFromExchange(uint value)
1983         external
1984         view
1985         returns (uint)
1986     {
1987         return value.divideDecimal(exchangeFeeRate.add(SafeDecimalMath.unit()));
1988     }
1989 
1990     /**
1991      * @notice The total fees available in the system to be withdrawn, priced in currencyKey currency
1992      * @param currencyKey The currency you want to price the fees in
1993      */
1994     function totalFeesAvailable(bytes4 currencyKey)
1995         external
1996         view
1997         returns (uint)
1998     {
1999         uint totalFees = 0;
2000 
2001         // Fees in fee period [0] are not yet available for withdrawal
2002         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
2003             totalFees = totalFees.add(recentFeePeriods[i].feesToDistribute);
2004             totalFees = totalFees.sub(recentFeePeriods[i].feesClaimed);
2005         }
2006 
2007         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
2008     }
2009 
2010     /**
2011      * @notice The fees available to be withdrawn by a specific account, priced in currencyKey currency
2012      * @param currencyKey The currency you want to price the fees in
2013      */
2014     function feesAvailable(address account, bytes4 currencyKey)
2015         public
2016         view
2017         returns (uint)
2018     {
2019         // Add up the fees
2020         uint[FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);
2021 
2022         uint totalFees = 0;
2023 
2024         // Fees in fee period [0] are not yet available for withdrawal
2025         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
2026             totalFees = totalFees.add(userFees[i]);
2027         }
2028 
2029         // And convert them to their desired currency
2030         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
2031     }
2032 
2033     /**
2034      * @notice The penalty a particular address would incur if its fees were withdrawn right now
2035      * @param account The address you want to query the penalty for
2036      */
2037     function currentPenalty(address account)
2038         public
2039         view
2040         returns (uint)
2041     {
2042         uint ratio = synthetix.collateralisationRatio(account);
2043 
2044         // Users receive a different amount of fees depending on how their collateralisation ratio looks right now.
2045         // 0% - 20%: Fee is calculated based on percentage of economy issued.
2046         // 20% - 30%: 25% reduction in fees
2047         // 30% - 40%: 50% reduction in fees
2048         // >40%: 75% reduction in fees
2049         if (ratio <= TWENTY_PERCENT) {
2050             return 0;
2051         } else if (ratio > TWENTY_PERCENT && ratio <= THIRTY_PERCENT) {
2052             return TWENTY_FIVE_PERCENT;
2053         } else if (ratio > THIRTY_PERCENT && ratio <= FOURTY_PERCENT) {
2054             return FIFTY_PERCENT;
2055         }
2056 
2057         return SEVENTY_FIVE_PERCENT;
2058     }
2059 
2060     /**
2061      * @notice Calculates fees by period for an account, priced in XDRs
2062      * @param account The address you want to query the fees by penalty for
2063      */
2064     function feesByPeriod(address account)
2065         public
2066         view
2067         returns (uint[FEE_PERIOD_LENGTH])
2068     {
2069         uint[FEE_PERIOD_LENGTH] memory result;
2070 
2071         // What's the user's debt entry index and the debt they owe to the system
2072         uint initialDebtOwnership;
2073         uint debtEntryIndex;
2074         (initialDebtOwnership, debtEntryIndex) = synthetix.synthetixState().issuanceData(account);
2075 
2076         // If they don't have any debt ownership, they don't have any fees
2077         if (initialDebtOwnership == 0) return result;
2078 
2079         // If there are no XDR synths, then they don't have any fees
2080         uint totalSynths = synthetix.totalIssuedSynths("XDR");
2081         if (totalSynths == 0) return result;
2082 
2083         uint debtBalance = synthetix.debtBalanceOf(account, "XDR");
2084         uint userOwnershipPercentage = debtBalance.divideDecimal(totalSynths);
2085         uint penalty = currentPenalty(account);
2086         
2087         // Go through our fee periods and figure out what we owe them.
2088         // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
2089         // fees owing for, so we need to report on it anyway.
2090         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
2091             // Were they a part of this period in its entirety?
2092             // We don't allow pro-rata participation to reduce the ability to game the system by
2093             // issuing and burning multiple times in a period or close to the ends of periods.
2094             if (recentFeePeriods[i].startingDebtIndex > debtEntryIndex &&
2095                 lastFeeWithdrawal[account] < recentFeePeriods[i].feePeriodId) {
2096 
2097                 // And since they were, they're entitled to their percentage of the fees in this period
2098                 uint feesFromPeriodWithoutPenalty = recentFeePeriods[i].feesToDistribute
2099                     .multiplyDecimal(userOwnershipPercentage);
2100 
2101                 // Less their penalty if they have one.
2102                 uint penaltyFromPeriod = feesFromPeriodWithoutPenalty.multiplyDecimal(penalty);
2103                 uint feesFromPeriod = feesFromPeriodWithoutPenalty.sub(penaltyFromPeriod);
2104 
2105                 result[i] = feesFromPeriod;
2106             }
2107         }
2108 
2109         return result;
2110     }
2111 
2112     modifier onlyFeeAuthority
2113     {
2114         require(msg.sender == feeAuthority, "Only the fee authority can perform this action");
2115         _;
2116     }
2117 
2118     modifier onlySynthetix
2119     {
2120         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
2121         _;
2122     }
2123 
2124     modifier notFeeAddress(address account) {
2125         require(account != FEE_ADDRESS, "Fee address not allowed");
2126         _;
2127     }
2128 
2129     event TransferFeeUpdated(uint newFeeRate);
2130     bytes32 constant TRANSFERFEEUPDATED_SIG = keccak256("TransferFeeUpdated(uint256)");
2131     function emitTransferFeeUpdated(uint newFeeRate) internal {
2132         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEEUPDATED_SIG, 0, 0, 0);
2133     }
2134 
2135     event ExchangeFeeUpdated(uint newFeeRate);
2136     bytes32 constant EXCHANGEFEEUPDATED_SIG = keccak256("ExchangeFeeUpdated(uint256)");
2137     function emitExchangeFeeUpdated(uint newFeeRate) internal {
2138         proxy._emit(abi.encode(newFeeRate), 1, EXCHANGEFEEUPDATED_SIG, 0, 0, 0);
2139     }
2140 
2141     event FeePeriodDurationUpdated(uint newFeePeriodDuration);
2142     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
2143     function emitFeePeriodDurationUpdated(uint newFeePeriodDuration) internal {
2144         proxy._emit(abi.encode(newFeePeriodDuration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
2145     }
2146 
2147     event FeeAuthorityUpdated(address newFeeAuthority);
2148     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
2149     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
2150         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
2151     }
2152 
2153     event FeePeriodClosed(uint feePeriodId);
2154     bytes32 constant FEEPERIODCLOSED_SIG = keccak256("FeePeriodClosed(uint256)");
2155     function emitFeePeriodClosed(uint feePeriodId) internal {
2156         proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
2157     }
2158 
2159     event FeesClaimed(address account, uint xdrAmount);
2160     bytes32 constant FEESCLAIMED_SIG = keccak256("FeesClaimed(address,uint256)");
2161     function emitFeesClaimed(address account, uint xdrAmount) internal {
2162         proxy._emit(abi.encode(account, xdrAmount), 1, FEESCLAIMED_SIG, 0, 0, 0);
2163     }
2164 
2165     event SynthetixUpdated(address newSynthetix);
2166     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
2167     function emitSynthetixUpdated(address newSynthetix) internal {
2168         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
2169     }
2170 }
2171 
2172 
2173 /*
2174 -----------------------------------------------------------------
2175 FILE INFORMATION
2176 -----------------------------------------------------------------
2177 
2178 file:       LimitedSetup.sol
2179 version:    1.1
2180 author:     Anton Jurisevic
2181 
2182 date:       2018-05-15
2183 
2184 -----------------------------------------------------------------
2185 MODULE DESCRIPTION
2186 -----------------------------------------------------------------
2187 
2188 A contract with a limited setup period. Any function modified
2189 with the setup modifier will cease to work after the
2190 conclusion of the configurable-length post-construction setup period.
2191 
2192 -----------------------------------------------------------------
2193 */
2194 
2195 
2196 /**
2197  * @title Any function decorated with the modifier this contract provides
2198  * deactivates after a specified setup period.
2199  */
2200 contract LimitedSetup {
2201 
2202     uint setupExpiryTime;
2203 
2204     /**
2205      * @dev LimitedSetup Constructor.
2206      * @param setupDuration The time the setup period will last for.
2207      */
2208     constructor(uint setupDuration)
2209         public
2210     {
2211         setupExpiryTime = now + setupDuration;
2212     }
2213 
2214     modifier onlyDuringSetup
2215     {
2216         require(now < setupExpiryTime, "Can only perform this action during setup");
2217         _;
2218     }
2219 }
2220 
2221 
2222 /*
2223 -----------------------------------------------------------------
2224 FILE INFORMATION
2225 -----------------------------------------------------------------
2226 
2227 file:       SynthetixEscrow.sol
2228 version:    1.1
2229 author:     Anton Jurisevic
2230             Dominic Romanowski
2231             Mike Spain
2232 
2233 date:       2018-05-29
2234 
2235 -----------------------------------------------------------------
2236 MODULE DESCRIPTION
2237 -----------------------------------------------------------------
2238 
2239 This contract allows the foundation to apply unique vesting
2240 schedules to synthetix funds sold at various discounts in the token
2241 sale. SynthetixEscrow gives users the ability to inspect their
2242 vested funds, their quantities and vesting dates, and to withdraw
2243 the fees that accrue on those funds.
2244 
2245 The fees are handled by withdrawing the entire fee allocation
2246 for all SNX inside the escrow contract, and then allowing
2247 the contract itself to subdivide that pool up proportionally within
2248 itself. Every time the fee period rolls over in the main Synthetix
2249 contract, the SynthetixEscrow fee pool is remitted back into the
2250 main fee pool to be redistributed in the next fee period.
2251 
2252 -----------------------------------------------------------------
2253 */
2254 
2255 
2256 /**
2257  * @title A contract to hold escrowed SNX and free them at given schedules.
2258  */
2259 contract SynthetixEscrow is Owned, LimitedSetup(8 weeks) {
2260 
2261     using SafeMath for uint;
2262 
2263     /* The corresponding Synthetix contract. */
2264     Synthetix public synthetix;
2265 
2266     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
2267      * These are the times at which each given quantity of SNX vests. */
2268     mapping(address => uint[2][]) public vestingSchedules;
2269 
2270     /* An account's total vested synthetix balance to save recomputing this for fee extraction purposes. */
2271     mapping(address => uint) public totalVestedAccountBalance;
2272 
2273     /* The total remaining vested balance, for verifying the actual synthetix balance of this contract against. */
2274     uint public totalVestedBalance;
2275 
2276     uint constant TIME_INDEX = 0;
2277     uint constant QUANTITY_INDEX = 1;
2278 
2279     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
2280     uint constant MAX_VESTING_ENTRIES = 20;
2281 
2282 
2283     /* ========== CONSTRUCTOR ========== */
2284 
2285     constructor(address _owner, Synthetix _synthetix)
2286         Owned(_owner)
2287         public
2288     {
2289         synthetix = _synthetix;
2290     }
2291 
2292 
2293     /* ========== SETTERS ========== */
2294 
2295     function setSynthetix(Synthetix _synthetix)
2296         external
2297         onlyOwner
2298     {
2299         synthetix = _synthetix;
2300         emit SynthetixUpdated(_synthetix);
2301     }
2302 
2303 
2304     /* ========== VIEW FUNCTIONS ========== */
2305 
2306     /**
2307      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
2308      */
2309     function balanceOf(address account)
2310         public
2311         view
2312         returns (uint)
2313     {
2314         return totalVestedAccountBalance[account];
2315     }
2316 
2317     /**
2318      * @notice The number of vesting dates in an account's schedule.
2319      */
2320     function numVestingEntries(address account)
2321         public
2322         view
2323         returns (uint)
2324     {
2325         return vestingSchedules[account].length;
2326     }
2327 
2328     /**
2329      * @notice Get a particular schedule entry for an account.
2330      * @return A pair of uints: (timestamp, synthetix quantity).
2331      */
2332     function getVestingScheduleEntry(address account, uint index)
2333         public
2334         view
2335         returns (uint[2])
2336     {
2337         return vestingSchedules[account][index];
2338     }
2339 
2340     /**
2341      * @notice Get the time at which a given schedule entry will vest.
2342      */
2343     function getVestingTime(address account, uint index)
2344         public
2345         view
2346         returns (uint)
2347     {
2348         return getVestingScheduleEntry(account,index)[TIME_INDEX];
2349     }
2350 
2351     /**
2352      * @notice Get the quantity of SNX associated with a given schedule entry.
2353      */
2354     function getVestingQuantity(address account, uint index)
2355         public
2356         view
2357         returns (uint)
2358     {
2359         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
2360     }
2361 
2362     /**
2363      * @notice Obtain the index of the next schedule entry that will vest for a given user.
2364      */
2365     function getNextVestingIndex(address account)
2366         public
2367         view
2368         returns (uint)
2369     {
2370         uint len = numVestingEntries(account);
2371         for (uint i = 0; i < len; i++) {
2372             if (getVestingTime(account, i) != 0) {
2373                 return i;
2374             }
2375         }
2376         return len;
2377     }
2378 
2379     /**
2380      * @notice Obtain the next schedule entry that will vest for a given user.
2381      * @return A pair of uints: (timestamp, synthetix quantity). */
2382     function getNextVestingEntry(address account)
2383         public
2384         view
2385         returns (uint[2])
2386     {
2387         uint index = getNextVestingIndex(account);
2388         if (index == numVestingEntries(account)) {
2389             return [uint(0), 0];
2390         }
2391         return getVestingScheduleEntry(account, index);
2392     }
2393 
2394     /**
2395      * @notice Obtain the time at which the next schedule entry will vest for a given user.
2396      */
2397     function getNextVestingTime(address account)
2398         external
2399         view
2400         returns (uint)
2401     {
2402         return getNextVestingEntry(account)[TIME_INDEX];
2403     }
2404 
2405     /**
2406      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
2407      */
2408     function getNextVestingQuantity(address account)
2409         external
2410         view
2411         returns (uint)
2412     {
2413         return getNextVestingEntry(account)[QUANTITY_INDEX];
2414     }
2415 
2416 
2417     /* ========== MUTATIVE FUNCTIONS ========== */
2418 
2419     /**
2420      * @notice Withdraws a quantity of SNX back to the synthetix contract.
2421      * @dev This may only be called by the owner during the contract's setup period.
2422      */
2423     function withdrawSynthetix(uint quantity)
2424         external
2425         onlyOwner
2426         onlyDuringSetup
2427     {
2428         synthetix.transfer(synthetix, quantity);
2429     }
2430 
2431     /**
2432      * @notice Destroy the vesting information associated with an account.
2433      */
2434     function purgeAccount(address account)
2435         external
2436         onlyOwner
2437         onlyDuringSetup
2438     {
2439         delete vestingSchedules[account];
2440         totalVestedBalance = totalVestedBalance.sub(totalVestedAccountBalance[account]);
2441         delete totalVestedAccountBalance[account];
2442     }
2443 
2444     /**
2445      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
2446      * @dev A call to this should be accompanied by either enough balance already available
2447      * in this contract, or a corresponding call to synthetix.endow(), to ensure that when
2448      * the funds are withdrawn, there is enough balance, as well as correctly calculating
2449      * the fees.
2450      * This may only be called by the owner during the contract's setup period.
2451      * Note; although this function could technically be used to produce unbounded
2452      * arrays, it's only in the foundation's command to add to these lists.
2453      * @param account The account to append a new vesting entry to.
2454      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
2455      * @param quantity The quantity of SNX that will vest.
2456      */
2457     function appendVestingEntry(address account, uint time, uint quantity)
2458         public
2459         onlyOwner
2460         onlyDuringSetup
2461     {
2462         /* No empty or already-passed vesting entries allowed. */
2463         require(now < time, "Time must be in the future");
2464         require(quantity != 0, "Quantity cannot be zero");
2465 
2466         /* There must be enough balance in the contract to provide for the vesting entry. */
2467         totalVestedBalance = totalVestedBalance.add(quantity);
2468         require(totalVestedBalance <= synthetix.balanceOf(this), "Must be enough balance in the contract to provide for the vesting entry");
2469 
2470         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
2471         uint scheduleLength = vestingSchedules[account].length;
2472         require(scheduleLength <= MAX_VESTING_ENTRIES, "Vesting schedule is too long");
2473 
2474         if (scheduleLength == 0) {
2475             totalVestedAccountBalance[account] = quantity;
2476         } else {
2477             /* Disallow adding new vested SNX earlier than the last one.
2478              * Since entries are only appended, this means that no vesting date can be repeated. */
2479             require(getVestingTime(account, numVestingEntries(account) - 1) < time, "Cannot add new vested entries earlier than the last one");
2480             totalVestedAccountBalance[account] = totalVestedAccountBalance[account].add(quantity);
2481         }
2482 
2483         vestingSchedules[account].push([time, quantity]);
2484     }
2485 
2486     /**
2487      * @notice Construct a vesting schedule to release a quantities of SNX
2488      * over a series of intervals.
2489      * @dev Assumes that the quantities are nonzero
2490      * and that the sequence of timestamps is strictly increasing.
2491      * This may only be called by the owner during the contract's setup period.
2492      */
2493     function addVestingSchedule(address account, uint[] times, uint[] quantities)
2494         external
2495         onlyOwner
2496         onlyDuringSetup
2497     {
2498         for (uint i = 0; i < times.length; i++) {
2499             appendVestingEntry(account, times[i], quantities[i]);
2500         }
2501 
2502     }
2503 
2504     /**
2505      * @notice Allow a user to withdraw any SNX in their schedule that have vested.
2506      */
2507     function vest()
2508         external
2509     {
2510         uint numEntries = numVestingEntries(msg.sender);
2511         uint total;
2512         for (uint i = 0; i < numEntries; i++) {
2513             uint time = getVestingTime(msg.sender, i);
2514             /* The list is sorted; when we reach the first future time, bail out. */
2515             if (time > now) {
2516                 break;
2517             }
2518             uint qty = getVestingQuantity(msg.sender, i);
2519             if (qty == 0) {
2520                 continue;
2521             }
2522 
2523             vestingSchedules[msg.sender][i] = [0, 0];
2524             total = total.add(qty);
2525         }
2526 
2527         if (total != 0) {
2528             totalVestedBalance = totalVestedBalance.sub(total);
2529             totalVestedAccountBalance[msg.sender] = totalVestedAccountBalance[msg.sender].sub(total);
2530             synthetix.transfer(msg.sender, total);
2531             emit Vested(msg.sender, now, total);
2532         }
2533     }
2534 
2535 
2536     /* ========== EVENTS ========== */
2537 
2538     event SynthetixUpdated(address newSynthetix);
2539 
2540     event Vested(address indexed beneficiary, uint time, uint value);
2541 }
2542 
2543 
2544 /*
2545 -----------------------------------------------------------------
2546 FILE INFORMATION
2547 -----------------------------------------------------------------
2548 
2549 file:       ExchangeRates.sol
2550 version:    1.0
2551 author:     Kevin Brown
2552 date:       2018-09-12
2553 
2554 -----------------------------------------------------------------
2555 MODULE DESCRIPTION
2556 -----------------------------------------------------------------
2557 
2558 A contract that any other contract in the Synthetix system can query
2559 for the current market value of various assets, including
2560 crypto assets as well as various fiat assets.
2561 
2562 This contract assumes that rate updates will completely update
2563 all rates to their current values. If a rate shock happens
2564 on a single asset, the oracle will still push updated rates
2565 for all other assets.
2566 
2567 -----------------------------------------------------------------
2568 */
2569 
2570 
2571 /**
2572  * @title The repository for exchange rates
2573  */
2574 contract ExchangeRates is SelfDestructible {
2575 
2576     using SafeMath for uint;
2577 
2578     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
2579     mapping(bytes4 => uint) public rates;
2580 
2581     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
2582     mapping(bytes4 => uint) public lastRateUpdateTimes;
2583 
2584     // The address of the oracle which pushes rate updates to this contract
2585     address public oracle;
2586 
2587     // Do not allow the oracle to submit times any further forward into the future than this constant.
2588     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
2589 
2590     // How long will the contract assume the rate of any asset is correct
2591     uint public rateStalePeriod = 3 hours;
2592 
2593     // Each participating currency in the XDR basket is represented as a currency key with
2594     // equal weighting.
2595     // There are 5 participating currencies, so we'll declare that clearly.
2596     bytes4[5] public xdrParticipants;
2597 
2598     //
2599     // ========== CONSTRUCTOR ==========
2600 
2601     /**
2602      * @dev Constructor
2603      * @param _owner The owner of this contract.
2604      * @param _oracle The address which is able to update rate information.
2605      * @param _currencyKeys The initial currency keys to store (in order).
2606      * @param _newRates The initial currency amounts for each currency (in order).
2607      */
2608     constructor(
2609         // SelfDestructible (Ownable)
2610         address _owner,
2611 
2612         // Oracle values - Allows for rate updates
2613         address _oracle,
2614         bytes4[] _currencyKeys,
2615         uint[] _newRates
2616     )
2617         /* Owned is initialised in SelfDestructible */
2618         SelfDestructible(_owner)
2619         public
2620     {
2621         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
2622 
2623         oracle = _oracle;
2624 
2625         // The sUSD rate is always 1 and is never stale.
2626         rates["sUSD"] = SafeDecimalMath.unit();
2627         lastRateUpdateTimes["sUSD"] = now;
2628 
2629         // These are the currencies that make up the XDR basket.
2630         // These are hard coded because:
2631         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
2632         //  - Adding new currencies would likely introduce some kind of weighting factor, which
2633         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
2634         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
2635         //    then point the system at the new version.
2636         xdrParticipants = [
2637             bytes4("sUSD"),
2638             bytes4("sAUD"),
2639             bytes4("sCHF"),
2640             bytes4("sEUR"),
2641             bytes4("sGBP")
2642         ];
2643 
2644         internalUpdateRates(_currencyKeys, _newRates, now);
2645     }
2646 
2647     /* ========== SETTERS ========== */
2648 
2649     /**
2650      * @notice Set the rates stored in this contract
2651      * @param currencyKeys The currency keys you wish to update the rates for (in order)
2652      * @param newRates The rates for each currency (in order)
2653      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
2654      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
2655      *                 if it takes a long time for the transaction to confirm.
2656      */
2657     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
2658         external
2659         onlyOracle
2660         returns(bool)
2661     {
2662         return internalUpdateRates(currencyKeys, newRates, timeSent);
2663     }
2664 
2665     /**
2666      * @notice Internal function which sets the rates stored in this contract
2667      * @param currencyKeys The currency keys you wish to update the rates for (in order)
2668      * @param newRates The rates for each currency (in order)
2669      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
2670      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
2671      *                 if it takes a long time for the transaction to confirm.
2672      */
2673     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
2674         internal
2675         returns(bool)
2676     {
2677         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
2678         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
2679 
2680         // Loop through each key and perform update.
2681         for (uint i = 0; i < currencyKeys.length; i++) {
2682             // Should not set any rate to zero ever, as no asset will ever be
2683             // truely worthless and still valid. In this scenario, we should
2684             // delete the rate and remove it from the system.
2685             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
2686             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
2687 
2688             // We should only update the rate if it's at least the same age as the last rate we've got.
2689             if (timeSent >= lastRateUpdateTimes[currencyKeys[i]]) {
2690                 // Ok, go ahead with the update.
2691                 rates[currencyKeys[i]] = newRates[i];
2692                 lastRateUpdateTimes[currencyKeys[i]] = timeSent;
2693             }
2694         }
2695 
2696         emit RatesUpdated(currencyKeys, newRates);
2697 
2698         // Now update our XDR rate.
2699         updateXDRRate(timeSent);
2700 
2701         return true;
2702     }
2703 
2704     /**
2705      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
2706      */
2707     function updateXDRRate(uint timeSent)
2708         internal
2709     {
2710         uint total = 0;
2711 
2712         for (uint i = 0; i < xdrParticipants.length; i++) {
2713             total = rates[xdrParticipants[i]].add(total);
2714         }
2715 
2716         // Set the rate
2717         rates["XDR"] = total;
2718 
2719         // Record that we updated the XDR rate.
2720         lastRateUpdateTimes["XDR"] = timeSent;
2721 
2722         // Emit our updated event separate to the others to save
2723         // moving data around between arrays.
2724         bytes4[] memory eventCurrencyCode = new bytes4[](1);
2725         eventCurrencyCode[0] = "XDR";
2726 
2727         uint[] memory eventRate = new uint[](1);
2728         eventRate[0] = rates["XDR"];
2729 
2730         emit RatesUpdated(eventCurrencyCode, eventRate);
2731     }
2732 
2733     /**
2734      * @notice Delete a rate stored in the contract
2735      * @param currencyKey The currency key you wish to delete the rate for
2736      */
2737     function deleteRate(bytes4 currencyKey)
2738         external
2739         onlyOracle
2740     {
2741         require(rates[currencyKey] > 0, "Rate is zero");
2742 
2743         delete rates[currencyKey];
2744         delete lastRateUpdateTimes[currencyKey];
2745 
2746         emit RateDeleted(currencyKey);
2747     }
2748 
2749     /**
2750      * @notice Set the Oracle that pushes the rate information to this contract
2751      * @param _oracle The new oracle address
2752      */
2753     function setOracle(address _oracle)
2754         external
2755         onlyOwner
2756     {
2757         oracle = _oracle;
2758         emit OracleUpdated(oracle);
2759     }
2760 
2761     /**
2762      * @notice Set the stale period on the updated rate variables
2763      * @param _time The new rateStalePeriod
2764      */
2765     function setRateStalePeriod(uint _time)
2766         external
2767         onlyOwner
2768     {
2769         rateStalePeriod = _time;
2770         emit RateStalePeriodUpdated(rateStalePeriod);
2771     }
2772 
2773     /* ========== VIEWS ========== */
2774 
2775     /**
2776      * @notice Retrieve the rate for a specific currency
2777      */
2778     function rateForCurrency(bytes4 currencyKey)
2779         public
2780         view
2781         returns (uint)
2782     {
2783         return rates[currencyKey];
2784     }
2785 
2786     /**
2787      * @notice Retrieve the rates for a list of currencies
2788      */
2789     function ratesForCurrencies(bytes4[] currencyKeys)
2790         public
2791         view
2792         returns (uint[])
2793     {
2794         uint[] memory _rates = new uint[](currencyKeys.length);
2795 
2796         for (uint8 i = 0; i < currencyKeys.length; i++) {
2797             _rates[i] = rates[currencyKeys[i]];
2798         }
2799 
2800         return _rates;
2801     }
2802 
2803     /**
2804      * @notice Retrieve a list of last update times for specific currencies
2805      */
2806     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
2807         public
2808         view
2809         returns (uint)
2810     {
2811         return lastRateUpdateTimes[currencyKey];
2812     }
2813 
2814     /**
2815      * @notice Retrieve the last update time for a specific currency
2816      */
2817     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
2818         public
2819         view
2820         returns (uint[])
2821     {
2822         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
2823 
2824         for (uint8 i = 0; i < currencyKeys.length; i++) {
2825             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
2826         }
2827 
2828         return lastUpdateTimes;
2829     }
2830 
2831     /**
2832      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
2833      */
2834     function rateIsStale(bytes4 currencyKey)
2835         external
2836         view
2837         returns (bool)
2838     {
2839         // sUSD is a special case and is never stale.
2840         if (currencyKey == "sUSD") return false;
2841 
2842         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
2843     }
2844 
2845     /**
2846      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
2847      */
2848     function anyRateIsStale(bytes4[] currencyKeys)
2849         external
2850         view
2851         returns (bool)
2852     {
2853         // Loop through each key and check whether the data point is stale.
2854         uint256 i = 0;
2855 
2856         while (i < currencyKeys.length) {
2857             // sUSD is a special case and is never false
2858             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
2859                 return true;
2860             }
2861             i += 1;
2862         }
2863 
2864         return false;
2865     }
2866 
2867     /* ========== MODIFIERS ========== */
2868 
2869     modifier onlyOracle
2870     {
2871         require(msg.sender == oracle, "Only the oracle can perform this action");
2872         _;
2873     }
2874 
2875     /* ========== EVENTS ========== */
2876 
2877     event OracleUpdated(address newOracle);
2878     event RateStalePeriodUpdated(uint rateStalePeriod);
2879     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
2880     event RateDeleted(bytes4 currencyKey);
2881 }
2882 
2883 
2884 /*
2885 -----------------------------------------------------------------
2886 FILE INFORMATION
2887 -----------------------------------------------------------------
2888 
2889 file:       Synthetix.sol
2890 version:    2.0
2891 author:     Kevin Brown
2892             Gavin Conway
2893 date:       2018-09-14
2894 
2895 -----------------------------------------------------------------
2896 MODULE DESCRIPTION
2897 -----------------------------------------------------------------
2898 
2899 Synthetix token contract. SNX is a transferable ERC20 token,
2900 and also give its holders the following privileges.
2901 An owner of SNX has the right to issue synths in all synth flavours.
2902 
2903 After a fee period terminates, the duration and fees collected for that
2904 period are computed, and the next period begins. Thus an account may only
2905 withdraw the fees owed to them for the previous period, and may only do
2906 so once per period. Any unclaimed fees roll over into the common pot for
2907 the next period.
2908 
2909 == Average Balance Calculations ==
2910 
2911 The fee entitlement of a synthetix holder is proportional to their average
2912 issued synth balance over the last fee period. This is computed by
2913 measuring the area under the graph of a user's issued synth balance over
2914 time, and then when a new fee period begins, dividing through by the
2915 duration of the fee period.
2916 
2917 We need only update values when the balances of an account is modified.
2918 This occurs when issuing or burning for issued synth balances,
2919 and when transferring for synthetix balances. This is for efficiency,
2920 and adds an implicit friction to interacting with SNX.
2921 A synthetix holder pays for his own recomputation whenever he wants to change
2922 his position, which saves the foundation having to maintain a pot dedicated
2923 to resourcing this.
2924 
2925 A hypothetical user's balance history over one fee period, pictorially:
2926 
2927       s ____
2928        |    |
2929        |    |___ p
2930        |____|___|___ __ _  _
2931        f    t   n
2932 
2933 Here, the balance was s between times f and t, at which time a transfer
2934 occurred, updating the balance to p, until n, when the present transfer occurs.
2935 When a new transfer occurs at time n, the balance being p,
2936 we must:
2937 
2938   - Add the area p * (n - t) to the total area recorded so far
2939   - Update the last transfer time to n
2940 
2941 So if this graph represents the entire current fee period,
2942 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
2943 The complementary computations must be performed for both sender and
2944 recipient.
2945 
2946 Note that a transfer keeps global supply of SNX invariant.
2947 The sum of all balances is constant, and unmodified by any transfer.
2948 So the sum of all balances multiplied by the duration of a fee period is also
2949 constant, and this is equivalent to the sum of the area of every user's
2950 time/balance graph. Dividing through by that duration yields back the total
2951 synthetix supply. So, at the end of a fee period, we really do yield a user's
2952 average share in the synthetix supply over that period.
2953 
2954 A slight wrinkle is introduced if we consider the time r when the fee period
2955 rolls over. Then the previous fee period k-1 is before r, and the current fee
2956 period k is afterwards. If the last transfer took place before r,
2957 but the latest transfer occurred afterwards:
2958 
2959 k-1       |        k
2960       s __|_
2961        |  | |
2962        |  | |____ p
2963        |__|_|____|___ __ _  _
2964           |
2965        f  | t    n
2966           r
2967 
2968 In this situation the area (r-f)*s contributes to fee period k-1, while
2969 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2970 zero-value transfer to have occurred at time r. Their fee entitlement for the
2971 previous period will be finalised at the time of their first transfer during the
2972 current fee period, or when they query or withdraw their fee entitlement.
2973 
2974 In the implementation, the duration of different fee periods may be slightly irregular,
2975 as the check that they have rolled over occurs only when state-changing synthetix
2976 operations are performed.
2977 
2978 == Issuance and Burning ==
2979 
2980 In this version of the synthetix contract, synths can only be issued by
2981 those that have been nominated by the synthetix foundation. Synths are assumed
2982 to be valued at $1, as they are a stable unit of account.
2983 
2984 All synths issued require a proportional value of SNX to be locked,
2985 where the proportion is governed by the current issuance ratio. This
2986 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
2987 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
2988 
2989 To determine the value of some amount of SNX(S), an oracle is used to push
2990 the price of SNX (P_S) in dollars to the contract. The value of S
2991 would then be: S * P_S.
2992 
2993 Any SNX that are locked up by this issuance process cannot be transferred.
2994 The amount that is locked floats based on the price of SNX. If the price
2995 of SNX moves up, less SNX are locked, so they can be issued against,
2996 or transferred freely. If the price of SNX moves down, more SNX are locked,
2997 even going above the initial wallet balance.
2998 
2999 -----------------------------------------------------------------
3000 */
3001 
3002 
3003 /**
3004  * @title Synthetix ERC20 contract.
3005  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
3006  * but it also computes the quantity of fees each synthetix holder is entitled to.
3007  */
3008 contract Synthetix is ExternStateToken {
3009 
3010     // ========== STATE VARIABLES ==========
3011 
3012     // Available Synths which can be used with the system
3013     Synth[] public availableSynths;
3014     mapping(bytes4 => Synth) public synths;
3015 
3016     FeePool public feePool;
3017     SynthetixEscrow public escrow;
3018     ExchangeRates public exchangeRates;
3019     SynthetixState public synthetixState;
3020 
3021     uint constant SYNTHETIX_SUPPLY = 1e8 * SafeDecimalMath.unit();
3022     string constant TOKEN_NAME = "Synthetix Network Token";
3023     string constant TOKEN_SYMBOL = "SNX";
3024     uint8 constant DECIMALS = 18;
3025 
3026     // ========== CONSTRUCTOR ==========
3027 
3028     /**
3029      * @dev Constructor
3030      * @param _tokenState A pre-populated contract containing token balances.
3031      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
3032      * @param _owner The owner of this contract.
3033      */
3034     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
3035         address _owner, ExchangeRates _exchangeRates, FeePool _feePool
3036     )
3037         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, SYNTHETIX_SUPPLY, DECIMALS, _owner)
3038         public
3039     {
3040         synthetixState = _synthetixState;
3041         exchangeRates = _exchangeRates;
3042         feePool = _feePool;
3043     }
3044 
3045     // ========== SETTERS ========== */
3046 
3047     /**
3048      * @notice Add an associated Synth contract to the Synthetix system
3049      * @dev Only the contract owner may call this.
3050      */
3051     function addSynth(Synth synth)
3052         external
3053         optionalProxy_onlyOwner
3054     {
3055         bytes4 currencyKey = synth.currencyKey();
3056 
3057         require(synths[currencyKey] == Synth(0), "Synth already exists");
3058 
3059         availableSynths.push(synth);
3060         synths[currencyKey] = synth;
3061 
3062         emitSynthAdded(currencyKey, synth);
3063     }
3064 
3065     /**
3066      * @notice Remove an associated Synth contract from the Synthetix system
3067      * @dev Only the contract owner may call this.
3068      */
3069     function removeSynth(bytes4 currencyKey)
3070         external
3071         optionalProxy_onlyOwner
3072     {
3073         require(synths[currencyKey] != address(0), "Synth does not exist");
3074         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
3075         require(currencyKey != "XDR", "Cannot remove XDR synth");
3076 
3077         // Save the address we're removing for emitting the event at the end.
3078         address synthToRemove = synths[currencyKey];
3079 
3080         // Remove the synth from the availableSynths array.
3081         for (uint8 i = 0; i < availableSynths.length; i++) {
3082             if (availableSynths[i] == synthToRemove) {
3083                 delete availableSynths[i];
3084 
3085                 // Copy the last synth into the place of the one we just deleted
3086                 // If there's only one synth, this is synths[0] = synths[0].
3087                 // If we're deleting the last one, it's also a NOOP in the same way.
3088                 availableSynths[i] = availableSynths[availableSynths.length - 1];
3089 
3090                 // Decrease the size of the array by one.
3091                 availableSynths.length--;
3092 
3093                 break;
3094             }
3095         }
3096 
3097         // And remove it from the synths mapping
3098         delete synths[currencyKey];
3099 
3100         emitSynthRemoved(currencyKey, synthToRemove);
3101     }
3102 
3103     /**
3104      * @notice Set the associated synthetix escrow contract.
3105      * @dev Only the contract owner may call this.
3106      */
3107     function setEscrow(SynthetixEscrow _escrow)
3108         external
3109         optionalProxy_onlyOwner
3110     {
3111         escrow = _escrow;
3112         // Note: No event here as our contract exceeds max contract size
3113         // with these events, and it's unlikely people will need to
3114         // track these events specifically.
3115     }
3116 
3117     /**
3118      * @notice Set the ExchangeRates contract address where rates are held.
3119      * @dev Only callable by the contract owner.
3120      */
3121     function setExchangeRates(ExchangeRates _exchangeRates)
3122         external
3123         optionalProxy_onlyOwner
3124     {
3125         exchangeRates = _exchangeRates;
3126         // Note: No event here as our contract exceeds max contract size
3127         // with these events, and it's unlikely people will need to
3128         // track these events specifically.
3129     }
3130 
3131     /**
3132      * @notice Set the synthetixState contract address where issuance data is held.
3133      * @dev Only callable by the contract owner.
3134      */
3135     function setSynthetixState(SynthetixState _synthetixState)
3136         external
3137         optionalProxy_onlyOwner
3138     {
3139         synthetixState = _synthetixState;
3140 
3141         emitStateContractChanged(_synthetixState);
3142     }
3143 
3144     /**
3145      * @notice Set your preferred currency. Note: This does not automatically exchange any balances you've held previously in
3146      * other synth currencies in this address, it will apply for any new payments you receive at this address.
3147      */
3148     function setPreferredCurrency(bytes4 currencyKey)
3149         external
3150         optionalProxy
3151     {
3152         require(currencyKey == 0 || !exchangeRates.rateIsStale(currencyKey), "Currency rate is stale or doesn't exist.");
3153 
3154         synthetixState.setPreferredCurrency(messageSender, currencyKey);
3155 
3156         emitPreferredCurrencyChanged(messageSender, currencyKey);
3157     }
3158 
3159     // ========== VIEWS ==========
3160 
3161     /**
3162      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
3163      * @param sourceCurrencyKey The currency the amount is specified in
3164      * @param sourceAmount The source amount, specified in UNIT base
3165      * @param destinationCurrencyKey The destination currency
3166      */
3167     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
3168         public
3169         view
3170         rateNotStale(sourceCurrencyKey)
3171         rateNotStale(destinationCurrencyKey)
3172         returns (uint)
3173     {
3174         // If there's no change in the currency, then just return the amount they gave us
3175         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
3176 
3177         // Calculate the effective value by going from source -> USD -> destination
3178         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
3179             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
3180     }
3181 
3182     /**
3183      * @notice Total amount of synths issued by the system, priced in currencyKey
3184      * @param currencyKey The currency to value the synths in
3185      */
3186     function totalIssuedSynths(bytes4 currencyKey)
3187         public
3188         view
3189         rateNotStale(currencyKey)
3190         returns (uint)
3191     {
3192         uint total = 0;
3193         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
3194 
3195         for (uint8 i = 0; i < availableSynths.length; i++) {
3196             // Ensure the rate isn't stale.
3197             // TODO: Investigate gas cost optimisation of doing a single call with all keys in it vs
3198             // individual calls like this.
3199             require(!exchangeRates.rateIsStale(availableSynths[i].currencyKey()), "Rate is stale");
3200 
3201             // What's the total issued value of that synth in the destination currency?
3202             // Note: We're not using our effectiveValue function because we don't want to go get the
3203             //       rate for the destination currency and check if it's stale repeatedly on every
3204             //       iteration of the loop
3205             uint synthValue = availableSynths[i].totalSupply()
3206                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
3207                 .divideDecimalRound(currencyRate);
3208             total = total.add(synthValue);
3209         }
3210 
3211         return total;
3212     }
3213 
3214     /**
3215      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
3216      */
3217     function availableSynthCount()
3218         public
3219         view
3220         returns (uint)
3221     {
3222         return availableSynths.length;
3223     }
3224 
3225     // ========== MUTATIVE FUNCTIONS ==========
3226 
3227     /**
3228      * @notice ERC20 transfer function.
3229      */
3230     function transfer(address to, uint value)
3231         public
3232         returns (bool)
3233     {
3234         bytes memory empty;
3235         return transfer(to, value, empty);
3236     }
3237 
3238     /**
3239      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
3240      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3241      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3242      *           tooling such as Etherscan.
3243      */
3244     function transfer(address to, uint value, bytes data)
3245         public
3246         optionalProxy
3247         returns (bool)
3248     {
3249         // Ensure they're not trying to exceed their locked amount
3250         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
3251 
3252         // Perform the transfer: if there is a problem an exception will be thrown in this call.
3253         _transfer_byProxy(messageSender, to, value, data);
3254 
3255         return true;
3256     }
3257 
3258     /**
3259      * @notice ERC20 transferFrom function.
3260      */
3261     function transferFrom(address from, address to, uint value)
3262         public
3263         returns (bool)
3264     {
3265         bytes memory empty;
3266         return transferFrom(from, to, value, empty);
3267     }
3268 
3269     /**
3270      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
3271      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3272      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3273      *           tooling such as Etherscan.
3274      */
3275     function transferFrom(address from, address to, uint value, bytes data)
3276         public
3277         optionalProxy
3278         returns (bool)
3279     {
3280         // Ensure they're not trying to exceed their locked amount
3281         require(value <= transferableSynthetix(from), "Insufficient balance");
3282 
3283         // Perform the transfer: if there is a problem,
3284         // an exception will be thrown in this call.
3285         _transferFrom_byProxy(messageSender, from, to, value, data);
3286 
3287         return true;
3288     }
3289 
3290     /**
3291      * @notice Function that allows you to exchange synths you hold in one flavour for another.
3292      * @param sourceCurrencyKey The source currency you wish to exchange from
3293      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3294      * @param destinationCurrencyKey The destination currency you wish to obtain.
3295      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
3296      * @return Boolean that indicates whether the transfer succeeded or failed.
3297      */
3298     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
3299         external
3300         optionalProxy
3301         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
3302         returns (bool)
3303     {
3304         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
3305         require(sourceAmount > 0, "Zero amount");
3306 
3307         // Pass it along, defaulting to the sender as the recipient.
3308         return _internalExchange(
3309             messageSender,
3310             sourceCurrencyKey,
3311             sourceAmount,
3312             destinationCurrencyKey,
3313             destinationAddress == address(0) ? messageSender : destinationAddress,
3314             true // Charge fee on the exchange
3315         );
3316     }
3317 
3318     /**
3319      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
3320      * @dev Only the synth contract can call this function
3321      * @param from The address to exchange / burn synth from
3322      * @param sourceCurrencyKey The source currency you wish to exchange from
3323      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3324      * @param destinationCurrencyKey The destination currency you wish to obtain.
3325      * @param destinationAddress Where the result should go.
3326      * @return Boolean that indicates whether the transfer succeeded or failed.
3327      */
3328     function synthInitiatedExchange(
3329         address from,
3330         bytes4 sourceCurrencyKey,
3331         uint sourceAmount,
3332         bytes4 destinationCurrencyKey,
3333         address destinationAddress
3334     )
3335         external
3336         onlySynth
3337         returns (bool)
3338     {
3339         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3340         require(sourceAmount > 0, "Zero amount");
3341 
3342         // Pass it along
3343         return _internalExchange(
3344             from,
3345             sourceCurrencyKey,
3346             sourceAmount,
3347             destinationCurrencyKey,
3348             destinationAddress,
3349             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
3350         );
3351     }
3352 
3353     /**
3354      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3355      * @dev Only the synth contract can call this function.
3356      * @param from The address fee is coming from.
3357      * @param sourceCurrencyKey source currency fee from.
3358      * @param sourceAmount The amount, specified in UNIT of source currency.
3359      * @return Boolean that indicates whether the transfer succeeded or failed.
3360      */
3361     function synthInitiatedFeePayment(
3362         address from,
3363         bytes4 sourceCurrencyKey,
3364         uint sourceAmount
3365     )
3366         external
3367         onlySynth
3368         returns (bool)
3369     {
3370         require(sourceAmount > 0, "Source can't be 0");
3371 
3372         // Pass it along, defaulting to the sender as the recipient.
3373         bool result = _internalExchange(
3374             from,
3375             sourceCurrencyKey,
3376             sourceAmount,
3377             "XDR",
3378             feePool.FEE_ADDRESS(),
3379             false // Don't charge a fee on the exchange because this is already a fee
3380         );
3381 
3382         // Tell the fee pool about this.
3383         feePool.feePaid(sourceCurrencyKey, sourceAmount);
3384 
3385         return result;
3386     }
3387 
3388     /**
3389      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3390      * @dev fee pool contract address is not allowed to call function
3391      * @param from The address to move synth from
3392      * @param sourceCurrencyKey source currency from.
3393      * @param sourceAmount The amount, specified in UNIT of source currency.
3394      * @param destinationCurrencyKey The destination currency to obtain.
3395      * @param destinationAddress Where the result should go.
3396      * @param chargeFee Boolean to charge a fee for transaction.
3397      * @return Boolean that indicates whether the transfer succeeded or failed.
3398      */
3399     function _internalExchange(
3400         address from,
3401         bytes4 sourceCurrencyKey,
3402         uint sourceAmount,
3403         bytes4 destinationCurrencyKey,
3404         address destinationAddress,
3405         bool chargeFee
3406     )
3407         internal
3408         notFeeAddress(from)
3409         returns (bool)
3410     {
3411         require(destinationAddress != address(0), "Zero destination");
3412         require(destinationAddress != address(this), "Synthetix is invalid destination");
3413         require(destinationAddress != address(proxy), "Proxy is invalid destination");
3414 
3415         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3416         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3417 
3418         // Burn the source amount
3419         synths[sourceCurrencyKey].burn(from, sourceAmount);
3420 
3421         // How much should they get in the destination currency?
3422         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3423 
3424         // What's the fee on that currency that we should deduct?
3425         uint amountReceived = destinationAmount;
3426         uint fee = 0;
3427 
3428         if (chargeFee) {
3429             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
3430             fee = destinationAmount.sub(amountReceived);
3431         }
3432 
3433         // Issue their new synths
3434         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3435 
3436         // Remit the fee in XDRs
3437         if (fee > 0) {
3438             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3439             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3440         }
3441 
3442         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3443 
3444         // Call the ERC223 transfer callback if needed
3445         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
3446 
3447         // Gas optimisation:
3448         // No event emitted as it's assumed users will be able to track transfers to the zero address, followed
3449         // by a transfer on another synth from the zero address and ascertain the info required here.
3450 
3451         return true;
3452     }
3453 
3454     /**
3455      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
3456      * @dev Only internal calls from synthetix address.
3457      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3458      * @param amount The amount of synths to register with a base of UNIT
3459      */
3460     function _addToDebtRegister(bytes4 currencyKey, uint amount)
3461         internal
3462         optionalProxy
3463     {
3464         // What is the value of the requested debt in XDRs?
3465         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3466 
3467         // What is the value of all issued synths of the system (priced in XDRs)?
3468         uint totalDebtIssued = totalIssuedSynths("XDR");
3469 
3470         // What will the new total be including the new value?
3471         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3472 
3473         // What is their percentage (as a high precision int) of the total debt?
3474         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3475 
3476         // And what effect does this percentage have on the global debt holding of other issuers?
3477         // The delta specifically needs to not take into account any existing debt as it's already
3478         // accounted for in the delta from when they issued previously.
3479         // The delta is a high precision integer.
3480         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3481 
3482         // How much existing debt do they have?
3483         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3484 
3485         // And what does their debt ownership look like including this previous stake?
3486         if (existingDebt > 0) {
3487             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3488         }
3489 
3490         // Are they a new issuer? If so, record them.
3491         if (!synthetixState.hasIssued(messageSender)) {
3492             synthetixState.incrementTotalIssuerCount();
3493         }
3494 
3495         // Save the debt entry parameters
3496         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3497 
3498         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3499         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3500         if (synthetixState.debtLedgerLength() > 0) {
3501             synthetixState.appendDebtLedgerValue(
3502                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3503             );
3504         } else {
3505             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3506         }
3507     }
3508 
3509     /**
3510      * @notice Issue synths against the sender's SNX.
3511      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3512      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3513      * @param amount The amount of synths you wish to issue with a base of UNIT
3514      */
3515     function issueSynths(bytes4 currencyKey, uint amount)
3516         public
3517         optionalProxy
3518         nonZeroAmount(amount)
3519         // No need to check if price is stale, as it is checked in issuableSynths.
3520     {
3521         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3522 
3523         // Keep track of the debt they're about to create
3524         _addToDebtRegister(currencyKey, amount);
3525 
3526         // Create their synths
3527         synths[currencyKey].issue(messageSender, amount);
3528     }
3529 
3530     /**
3531      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3532      * @dev Issuance is only allowed if the synthetix price isn't stale.
3533      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3534      */
3535     function issueMaxSynths(bytes4 currencyKey)
3536         external
3537         optionalProxy
3538     {
3539         // Figure out the maximum we can issue in that currency
3540         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
3541 
3542         // And issue them
3543         issueSynths(currencyKey, maxIssuable);
3544     }
3545 
3546     /**
3547      * @notice Burn synths to clear issued synths/free SNX.
3548      * @param currencyKey The currency you're specifying to burn
3549      * @param amount The amount (in UNIT base) you wish to burn
3550      */
3551     function burnSynths(bytes4 currencyKey, uint amount)
3552         external
3553         optionalProxy
3554         // No need to check for stale rates as _removeFromDebtRegister calls effectiveValue
3555         // which does this for us
3556     {
3557         // How much debt do they have?
3558         uint debt = debtBalanceOf(messageSender, currencyKey);
3559 
3560         require(debt > 0, "No debt to forgive");
3561 
3562         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
3563         // clear their debt and leave them be.
3564         uint amountToBurn = debt < amount ? debt : amount;
3565 
3566         // Remove their debt from the ledger
3567         _removeFromDebtRegister(currencyKey, amountToBurn);
3568 
3569         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
3570         synths[currencyKey].burn(messageSender, amountToBurn);
3571     }
3572 
3573     /**
3574      * @notice Remove a debt position from the register
3575      * @param currencyKey The currency the user is presenting to forgive their debt
3576      * @param amount The amount (in UNIT base) being presented
3577      */
3578     function _removeFromDebtRegister(bytes4 currencyKey, uint amount)
3579         internal
3580     {
3581         // How much debt are they trying to remove in XDRs?
3582         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
3583 
3584         // How much debt do they have?
3585         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3586 
3587         // What percentage of the total debt are they trying to remove?
3588         uint totalDebtIssued = totalIssuedSynths("XDR");
3589         uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(totalDebtIssued);
3590 
3591         // And what effect does this percentage have on the global debt holding of other issuers?
3592         // The delta specifically needs to not take into account any existing debt as it's already
3593         // accounted for in the delta from when they issued previously.
3594         uint delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
3595 
3596         // Are they exiting the system, or are they just decreasing their debt position?
3597         if (debtToRemove == existingDebt) {
3598             synthetixState.clearIssuanceData(messageSender);
3599             synthetixState.decrementTotalIssuerCount();
3600         } else {
3601             // What percentage of the debt will they be left with?
3602             uint newDebt = existingDebt.sub(debtToRemove);
3603             uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
3604             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
3605 
3606             // Store the debt percentage and debt ledger as high precision integers
3607             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
3608         }
3609 
3610         // Update our cumulative ledger. This is also a high precision integer.
3611         synthetixState.appendDebtLedgerValue(
3612             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3613         );
3614     }
3615 
3616     // ========== Issuance/Burning ==========
3617 
3618     /**
3619      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
3620      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
3621      */
3622     function maxIssuableSynths(address issuer, bytes4 currencyKey)
3623         public
3624         view
3625         // We don't need to check stale rates here as effectiveValue will do it for us.
3626         returns (uint)
3627     {
3628         // What is the value of their SNX balance in the destination currency?
3629         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
3630 
3631         // They're allowed to issue up to issuanceRatio of that value
3632         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
3633     }
3634 
3635     /**
3636      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
3637      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
3638      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
3639      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
3640      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
3641      * altering the amount of fees they're able to claim from the system.
3642      */
3643     function collateralisationRatio(address issuer)
3644         public
3645         view
3646         returns (uint)
3647     {
3648         uint totalOwnedSynthetix = collateral(issuer);
3649         if (totalOwnedSynthetix == 0) return 0;
3650 
3651         uint debtBalance = debtBalanceOf(issuer, "SNX");
3652         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
3653     }
3654 
3655 /**
3656      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
3657      * will tell you how many synths a user has to give back to the system in order to unlock their original
3658      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
3659      * the debt in sUSD, XDR, or any other synth you wish.
3660      */
3661     function debtBalanceOf(address issuer, bytes4 currencyKey)
3662         public
3663         view
3664         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
3665         returns (uint)
3666     {
3667         // What was their initial debt ownership?
3668         uint initialDebtOwnership;
3669         uint debtEntryIndex;
3670         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
3671 
3672         // If it's zero, they haven't issued, and they have no debt.
3673         if (initialDebtOwnership == 0) return 0;
3674 
3675         // Figure out the global debt percentage delta from when they entered the system.
3676         // This is a high precision integer.
3677         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
3678             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
3679             .multiplyDecimalRoundPrecise(initialDebtOwnership);
3680 
3681         // What's the total value of the system in their requested currency?
3682         uint totalSystemValue = totalIssuedSynths(currencyKey);
3683 
3684         // Their debt balance is their portion of the total system value.
3685         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
3686             .multiplyDecimalRoundPrecise(currentDebtOwnership);
3687 
3688         return highPrecisionBalance.preciseDecimalToDecimal();
3689     }
3690 
3691     /**
3692      * @notice The remaining synths an issuer can issue against their total synthetix balance.
3693      * @param issuer The account that intends to issue
3694      * @param currencyKey The currency to price issuable value in
3695      */
3696     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
3697         public
3698         view
3699         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
3700         returns (uint)
3701     {
3702         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
3703         uint max = maxIssuableSynths(issuer, currencyKey);
3704 
3705         if (alreadyIssued >= max) {
3706             return 0;
3707         } else {
3708             return max.sub(alreadyIssued);
3709         }
3710     }
3711 
3712     /**
3713      * @notice The total SNX owned by this account, both escrowed and unescrowed,
3714      * against which synths can be issued.
3715      * This includes those already being used as collateral (locked), and those
3716      * available for further issuance (unlocked).
3717      */
3718     function collateral(address account)
3719         public
3720         view
3721         returns (uint)
3722     {
3723         uint balance = tokenState.balanceOf(account);
3724 
3725         if (escrow != address(0)) {
3726             balance = balance.add(escrow.balanceOf(account));
3727         }
3728 
3729         return balance;
3730     }
3731 
3732     /**
3733      * @notice The number of SNX that are free to be transferred by an account.
3734      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
3735      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
3736      * in this calculation.
3737      */
3738     function transferableSynthetix(address account)
3739         public
3740         view
3741         rateNotStale("SNX")
3742         returns (uint)
3743     {
3744         // How many SNX do they have, excluding escrow?
3745         // Note: We're excluding escrow here because we're interested in their transferable amount
3746         // and escrowed SNX are not transferable.
3747         uint balance = tokenState.balanceOf(account);
3748 
3749         // How many of those will be locked by the amount they've issued?
3750         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
3751         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
3752         // The locked synthetix value can exceed their balance.
3753         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
3754 
3755         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
3756         if (lockedSynthetixValue >= balance) {
3757             return 0;
3758         } else {
3759             return balance.sub(lockedSynthetixValue);
3760         }
3761     }
3762 
3763     // ========== MODIFIERS ==========
3764 
3765     modifier rateNotStale(bytes4 currencyKey) {
3766         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
3767         _;
3768     }
3769 
3770     modifier notFeeAddress(address account) {
3771         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
3772         _;
3773     }
3774 
3775     modifier onlySynth() {
3776         bool isSynth = false;
3777 
3778         // No need to repeatedly call this function either
3779         for (uint8 i = 0; i < availableSynths.length; i++) {
3780             if (availableSynths[i] == msg.sender) {
3781                 isSynth = true;
3782                 break;
3783             }
3784         }
3785 
3786         require(isSynth, "Only synth allowed");
3787         _;
3788     }
3789 
3790     modifier nonZeroAmount(uint _amount) {
3791         require(_amount > 0, "Amount needs to be larger than 0");
3792         _;
3793     }
3794 
3795     // ========== EVENTS ==========
3796 
3797     event PreferredCurrencyChanged(address indexed account, bytes4 newPreferredCurrency);
3798     bytes32 constant PREFERREDCURRENCYCHANGED_SIG = keccak256("PreferredCurrencyChanged(address,bytes4)");
3799     function emitPreferredCurrencyChanged(address account, bytes4 newPreferredCurrency) internal {
3800         proxy._emit(abi.encode(newPreferredCurrency), 2, PREFERREDCURRENCYCHANGED_SIG, bytes32(account), 0, 0);
3801     }
3802 
3803     event StateContractChanged(address stateContract);
3804     bytes32 constant STATECONTRACTCHANGED_SIG = keccak256("StateContractChanged(address)");
3805     function emitStateContractChanged(address stateContract) internal {
3806         proxy._emit(abi.encode(stateContract), 1, STATECONTRACTCHANGED_SIG, 0, 0, 0);
3807     }
3808 
3809     event SynthAdded(bytes4 currencyKey, address newSynth);
3810     bytes32 constant SYNTHADDED_SIG = keccak256("SynthAdded(bytes4,address)");
3811     function emitSynthAdded(bytes4 currencyKey, address newSynth) internal {
3812         proxy._emit(abi.encode(currencyKey, newSynth), 1, SYNTHADDED_SIG, 0, 0, 0);
3813     }
3814 
3815     event SynthRemoved(bytes4 currencyKey, address removedSynth);
3816     bytes32 constant SYNTHREMOVED_SIG = keccak256("SynthRemoved(bytes4,address)");
3817     function emitSynthRemoved(bytes4 currencyKey, address removedSynth) internal {
3818         proxy._emit(abi.encode(currencyKey, removedSynth), 1, SYNTHREMOVED_SIG, 0, 0, 0);
3819     }
3820 }
3821 
3822 
3823 /*
3824 -----------------------------------------------------------------
3825 FILE INFORMATION
3826 -----------------------------------------------------------------
3827 
3828 file:       SynthetixState.sol
3829 version:    1.0
3830 author:     Kevin Brown
3831 date:       2018-10-19
3832 
3833 -----------------------------------------------------------------
3834 MODULE DESCRIPTION
3835 -----------------------------------------------------------------
3836 
3837 A contract that holds issuance state and preferred currency of
3838 users in the Synthetix system.
3839 
3840 This contract is used side by side with the Synthetix contract
3841 to make it easier to upgrade the contract logic while maintaining
3842 issuance state.
3843 
3844 The Synthetix contract is also quite large and on the edge of
3845 being beyond the contract size limit without moving this information
3846 out to another contract.
3847 
3848 The first deployed contract would create this state contract,
3849 using it as its store of issuance data.
3850 
3851 When a new contract is deployed, it links to the existing
3852 state contract, whose owner would then change its associated
3853 contract to the new one.
3854 
3855 -----------------------------------------------------------------
3856 */
3857 
3858 
3859 /**
3860  * @title Synthetix State
3861  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
3862  */
3863 contract SynthetixState is State, LimitedSetup {
3864     using SafeMath for uint;
3865     using SafeDecimalMath for uint;
3866 
3867     // A struct for handing values associated with an individual user's debt position
3868     struct IssuanceData {
3869         // Percentage of the total debt owned at the time
3870         // of issuance. This number is modified by the global debt
3871         // delta array. You can figure out a user's exit price and
3872         // collateralisation ratio using a combination of their initial
3873         // debt and the slice of global debt delta which applies to them.
3874         uint initialDebtOwnership;
3875         // This lets us know when (in relative terms) the user entered
3876         // the debt pool so we can calculate their exit price and
3877         // collateralistion ratio
3878         uint debtEntryIndex;
3879     }
3880 
3881     // Issued synth balances for individual fee entitlements and exit price calculations
3882     mapping(address => IssuanceData) public issuanceData;
3883 
3884     // The total count of people that have outstanding issued synths in any flavour
3885     uint public totalIssuerCount;
3886 
3887     // Global debt pool tracking
3888     uint[] public debtLedger;
3889 
3890     // A quantity of synths greater than this ratio
3891     // may not be issued against a given value of SNX.
3892     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
3893     // No more synths may be issued than the value of SNX backing them.
3894     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
3895 
3896     // Users can specify their preferred currency, in which case all synths they receive
3897     // will automatically exchange to that preferred currency upon receipt in their wallet
3898     mapping(address => bytes4) public preferredCurrency;
3899 
3900     /**
3901      * @dev Constructor
3902      * @param _owner The address which controls this contract.
3903      * @param _associatedContract The ERC20 contract whose state this composes.
3904      */
3905     constructor(address _owner, address _associatedContract)
3906         State(_owner, _associatedContract)
3907         LimitedSetup(1 weeks)
3908         public
3909     {}
3910 
3911     /* ========== SETTERS ========== */
3912 
3913     /**
3914      * @notice Set issuance data for an address
3915      * @dev Only the associated contract may call this.
3916      * @param account The address to set the data for.
3917      * @param initialDebtOwnership The initial debt ownership for this address.
3918      */
3919     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
3920         external
3921         onlyAssociatedContract
3922     {
3923         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
3924         issuanceData[account].debtEntryIndex = debtLedger.length;
3925     }
3926 
3927     /**
3928      * @notice Clear issuance data for an address
3929      * @dev Only the associated contract may call this.
3930      * @param account The address to clear the data for.
3931      */
3932     function clearIssuanceData(address account)
3933         external
3934         onlyAssociatedContract
3935     {
3936         delete issuanceData[account];
3937     }
3938 
3939     /**
3940      * @notice Increment the total issuer count
3941      * @dev Only the associated contract may call this.
3942      */
3943     function incrementTotalIssuerCount()
3944         external
3945         onlyAssociatedContract
3946     {
3947         totalIssuerCount = totalIssuerCount.add(1);
3948     }
3949 
3950     /**
3951      * @notice Decrement the total issuer count
3952      * @dev Only the associated contract may call this.
3953      */
3954     function decrementTotalIssuerCount()
3955         external
3956         onlyAssociatedContract
3957     {
3958         totalIssuerCount = totalIssuerCount.sub(1);
3959     }
3960 
3961     /**
3962      * @notice Append a value to the debt ledger
3963      * @dev Only the associated contract may call this.
3964      * @param value The new value to be added to the debt ledger.
3965      */
3966     function appendDebtLedgerValue(uint value)
3967         external
3968         onlyAssociatedContract
3969     {
3970         debtLedger.push(value);
3971     }
3972 
3973     /**
3974      * @notice Set preferred currency for a user
3975      * @dev Only the associated contract may call this.
3976      * @param account The account to set the preferred currency for
3977      * @param currencyKey The new preferred currency
3978      */
3979     function setPreferredCurrency(address account, bytes4 currencyKey)
3980         external
3981         onlyAssociatedContract
3982     {
3983         preferredCurrency[account] = currencyKey;
3984     }
3985 
3986     /**
3987      * @notice Set the issuanceRatio for issuance calculations.
3988      * @dev Only callable by the contract owner.
3989      */
3990     function setIssuanceRatio(uint _issuanceRatio)
3991         external
3992         onlyOwner
3993     {
3994         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
3995         issuanceRatio = _issuanceRatio;
3996         emit IssuanceRatioUpdated(_issuanceRatio);
3997     }
3998 
3999     /**
4000      * @notice Import issuer data from the old Synthetix contract before multicurrency
4001      * @dev Only callable by the contract owner, and only for 1 week after deployment.
4002      */
4003     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
4004         external
4005         onlyOwner
4006         onlyDuringSetup
4007     {
4008         require(accounts.length == sUSDAmounts.length, "Length mismatch");
4009 
4010         for (uint8 i = 0; i < accounts.length; i++) {
4011             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
4012         }
4013     }
4014 
4015     /**
4016      * @notice Import issuer data from the old Synthetix contract before multicurrency
4017      * @dev Only used from importIssuerData above, meant to be disposable
4018      */
4019     function _addToDebtRegister(address account, uint amount)
4020         internal
4021     {
4022         // This code is duplicated from Synthetix so that we can call it directly here
4023         // during setup only.
4024         Synthetix synthetix = Synthetix(associatedContract);
4025 
4026         // What is the value of the requested debt in XDRs?
4027         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
4028 
4029         // What is the value of all issued synths of the system (priced in XDRs)?
4030         uint totalDebtIssued = synthetix.totalIssuedSynths("XDR");
4031 
4032         // What will the new total be including the new value?
4033         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
4034 
4035         // What is their percentage (as a high precision int) of the total debt?
4036         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
4037 
4038         // And what effect does this percentage have on the global debt holding of other issuers?
4039         // The delta specifically needs to not take into account any existing debt as it's already
4040         // accounted for in the delta from when they issued previously.
4041         // The delta is a high precision integer.
4042         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
4043 
4044         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
4045 
4046         // And what does their debt ownership look like including this previous stake?
4047         if (existingDebt > 0) {
4048             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
4049         }
4050 
4051         // Are they a new issuer? If so, record them.
4052         if (issuanceData[account].initialDebtOwnership == 0) {
4053             totalIssuerCount = totalIssuerCount.add(1);
4054         }
4055 
4056         // Save the debt entry parameters
4057         issuanceData[account].initialDebtOwnership = debtPercentage;
4058         issuanceData[account].debtEntryIndex = debtLedger.length;
4059 
4060         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
4061         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
4062         if (debtLedger.length > 0) {
4063             debtLedger.push(
4064                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
4065             );
4066         } else {
4067             debtLedger.push(SafeDecimalMath.preciseUnit());
4068         }
4069     }
4070 
4071     /* ========== VIEWS ========== */
4072 
4073     /**
4074      * @notice Retrieve the length of the debt ledger array
4075      */
4076     function debtLedgerLength()
4077         external
4078         view
4079         returns (uint)
4080     {
4081         return debtLedger.length;
4082     }
4083 
4084     /**
4085      * @notice Retrieve the most recent entry from the debt ledger
4086      */
4087     function lastDebtLedgerEntry()
4088         external
4089         view
4090         returns (uint)
4091     {
4092         return debtLedger[debtLedger.length - 1];
4093     }
4094 
4095     /**
4096      * @notice Query whether an account has issued and has an outstanding debt balance
4097      * @param account The address to query for
4098      */
4099     function hasIssued(address account)
4100         external
4101         view
4102         returns (bool)
4103     {
4104         return issuanceData[account].initialDebtOwnership > 0;
4105     }
4106 
4107     event IssuanceRatioUpdated(uint newRatio);
4108 }
4109 
