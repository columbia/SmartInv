1 /*
2 -----------------------------------------------------------------
3 FILE INFORMATION
4 -----------------------------------------------------------------
5 
6 file:       Owned.sol
7 version:    1.1
8 author:     Anton Jurisevic
9             Dominic Romanowski
10 
11 date:       2018-2-26
12 
13 -----------------------------------------------------------------
14 MODULE DESCRIPTION
15 -----------------------------------------------------------------
16 
17 An Owned contract, to be inherited by other contracts.
18 Requires its owner to be explicitly set in the constructor.
19 Provides an onlyOwner access modifier.
20 
21 To change owner, the current owner must nominate the next owner,
22 who then has to accept the nomination. The nomination can be
23 cancelled before it is accepted by the new owner by having the
24 previous owner change the nomination (setting it to 0).
25 
26 -----------------------------------------------------------------
27 */
28 
29 pragma solidity 0.4.24;
30 
31 /**
32  * @title A contract with an owner.
33  * @notice Contract ownership can be transferred by first nominating the new owner,
34  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
35  */
36 contract Owned {
37     address public owner;
38     address public nominatedOwner;
39 
40     /**
41      * @dev Owned Constructor
42      */
43     constructor(address _owner)
44         public
45     {
46         require(_owner != address(0), "Owner address cannot be 0");
47         owner = _owner;
48         emit OwnerChanged(address(0), _owner);
49     }
50 
51     /**
52      * @notice Nominate a new owner of this contract.
53      * @dev Only the current owner may nominate a new owner.
54      */
55     function nominateNewOwner(address _owner)
56         external
57         onlyOwner
58     {
59         nominatedOwner = _owner;
60         emit OwnerNominated(_owner);
61     }
62 
63     /**
64      * @notice Accept the nomination to be owner.
65      */
66     function acceptOwnership()
67         external
68     {
69         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
70         emit OwnerChanged(owner, nominatedOwner);
71         owner = nominatedOwner;
72         nominatedOwner = address(0);
73     }
74 
75     modifier onlyOwner
76     {
77         require(msg.sender == owner, "Only the contract owner may perform this action");
78         _;
79     }
80 
81     event OwnerNominated(address newOwner);
82     event OwnerChanged(address oldOwner, address newOwner);
83 }
84 
85 /*
86 -----------------------------------------------------------------
87 FILE INFORMATION
88 -----------------------------------------------------------------
89 
90 file:       SelfDestructible.sol
91 version:    1.2
92 author:     Anton Jurisevic
93 
94 date:       2018-05-29
95 
96 -----------------------------------------------------------------
97 MODULE DESCRIPTION
98 -----------------------------------------------------------------
99 
100 This contract allows an inheriting contract to be destroyed after
101 its owner indicates an intention and then waits for a period
102 without changing their mind. All ether contained in the contract
103 is forwarded to a nominated beneficiary upon destruction.
104 
105 -----------------------------------------------------------------
106 */
107 
108 
109 /**
110  * @title A contract that can be destroyed by its owner after a delay elapses.
111  */
112 contract SelfDestructible is Owned {
113 	
114 	uint public initiationTime;
115 	bool public selfDestructInitiated;
116 	address public selfDestructBeneficiary;
117 	uint public constant SELFDESTRUCT_DELAY = 4 weeks;
118 
119 	/**
120 	 * @dev Constructor
121 	 * @param _owner The account which controls this contract.
122 	 */
123 	constructor(address _owner)
124 	    Owned(_owner)
125 	    public
126 	{
127 		require(_owner != address(0), "Owner must not be the zero address");
128 		selfDestructBeneficiary = _owner;
129 		emit SelfDestructBeneficiaryUpdated(_owner);
130 	}
131 
132 	/**
133 	 * @notice Set the beneficiary address of this contract.
134 	 * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
135 	 * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
136 	 */
137 	function setSelfDestructBeneficiary(address _beneficiary)
138 		external
139 		onlyOwner
140 	{
141 		require(_beneficiary != address(0), "Beneficiary must not be the zero address");
142 		selfDestructBeneficiary = _beneficiary;
143 		emit SelfDestructBeneficiaryUpdated(_beneficiary);
144 	}
145 
146 	/**
147 	 * @notice Begin the self-destruction counter of this contract.
148 	 * Once the delay has elapsed, the contract may be self-destructed.
149 	 * @dev Only the contract owner may call this.
150 	 */
151 	function initiateSelfDestruct()
152 		external
153 		onlyOwner
154 	{
155 		initiationTime = now;
156 		selfDestructInitiated = true;
157 		emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
158 	}
159 
160 	/**
161 	 * @notice Terminate and reset the self-destruction timer.
162 	 * @dev Only the contract owner may call this.
163 	 */
164 	function terminateSelfDestruct()
165 		external
166 		onlyOwner
167 	{
168 		initiationTime = 0;
169 		selfDestructInitiated = false;
170 		emit SelfDestructTerminated();
171 	}
172 
173 	/**
174 	 * @notice If the self-destruction delay has elapsed, destroy this contract and
175 	 * remit any ether it owns to the beneficiary address.
176 	 * @dev Only the contract owner may call this.
177 	 */
178 	function selfDestruct()
179 		external
180 		onlyOwner
181 	{
182 		require(selfDestructInitiated, "Self destruct has not yet been initiated");
183 		require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay has not yet elapsed");
184 		address beneficiary = selfDestructBeneficiary;
185 		emit SelfDestructed(beneficiary);
186 		selfdestruct(beneficiary);
187 	}
188 
189 	event SelfDestructTerminated();
190 	event SelfDestructed(address beneficiary);
191 	event SelfDestructInitiated(uint selfDestructDelay);
192 	event SelfDestructBeneficiaryUpdated(address newBeneficiary);
193 }
194 
195 
196 /*
197 -----------------------------------------------------------------
198 FILE INFORMATION
199 -----------------------------------------------------------------
200 
201 file:       Pausable.sol
202 version:    1.0
203 author:     Kevin Brown
204 
205 date:       2018-05-22
206 
207 -----------------------------------------------------------------
208 MODULE DESCRIPTION
209 -----------------------------------------------------------------
210 
211 This contract allows an inheriting contract to be marked as
212 paused. It also defines a modifier which can be used by the
213 inheriting contract to prevent actions while paused.
214 
215 -----------------------------------------------------------------
216 */
217 
218 
219 /**
220  * @title A contract that can be paused by its owner
221  */
222 contract Pausable is Owned {
223     
224     uint public lastPauseTime;
225     bool public paused;
226 
227     /**
228      * @dev Constructor
229      * @param _owner The account which controls this contract.
230      */
231     constructor(address _owner)
232         Owned(_owner)
233         public
234     {
235         // Paused will be false, and lastPauseTime will be 0 upon initialisation
236     }
237 
238     /**
239      * @notice Change the paused state of the contract
240      * @dev Only the contract owner may call this.
241      */
242     function setPaused(bool _paused)
243         external
244         onlyOwner
245     {
246         // Ensure we're actually changing the state before we do anything
247         if (_paused == paused) {
248             return;
249         }
250 
251         // Set our paused state.
252         paused = _paused;
253         
254         // If applicable, set the last pause time.
255         if (paused) {
256             lastPauseTime = now;
257         }
258 
259         // Let everyone know that our pause state has changed.
260         emit PauseChanged(paused);
261     }
262 
263     event PauseChanged(bool isPaused);
264 
265     modifier notPaused {
266         require(!paused, "This action cannot be performed while the contract is paused");
267         _;
268     }
269 }
270 
271 
272 /*
273 -----------------------------------------------------------------
274 FILE INFORMATION
275 -----------------------------------------------------------------
276 
277 file:       SafeDecimalMath.sol
278 version:    1.0
279 author:     Anton Jurisevic
280 
281 date:       2018-2-5
282 
283 checked:    Mike Spain
284 approved:   Samuel Brooks
285 
286 -----------------------------------------------------------------
287 MODULE DESCRIPTION
288 -----------------------------------------------------------------
289 
290 A fixed point decimal library that provides basic mathematical
291 operations, and checks for unsafe arguments, for example that
292 would lead to overflows.
293 
294 Exceptions are thrown whenever those unsafe operations
295 occur.
296 
297 -----------------------------------------------------------------
298 */
299 
300 
301 /**
302  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
303  * @dev Functions accepting uints in this contract and derived contracts
304  * are taken to be such fixed point decimals (including fiat, ether, and nomin quantities).
305  */
306 contract SafeDecimalMath {
307 
308     /* Number of decimal places in the representation. */
309     uint8 public constant decimals = 18;
310 
311     /* The number representing 1.0. */
312     uint public constant UNIT = 10 ** uint(decimals);
313 
314     /**
315      * @return True iff adding x and y will not overflow.
316      */
317     function addIsSafe(uint x, uint y)
318         pure
319         internal
320         returns (bool)
321     {
322         return x + y >= y;
323     }
324 
325     /**
326      * @return The result of adding x and y, throwing an exception in case of overflow.
327      */
328     function safeAdd(uint x, uint y)
329         pure
330         internal
331         returns (uint)
332     {
333         require(x + y >= y, "Safe add failed");
334         return x + y;
335     }
336 
337     /**
338      * @return True iff subtracting y from x will not overflow in the negative direction.
339      */
340     function subIsSafe(uint x, uint y)
341         pure
342         internal
343         returns (bool)
344     {
345         return y <= x;
346     }
347 
348     /**
349      * @return The result of subtracting y from x, throwing an exception in case of overflow.
350      */
351     function safeSub(uint x, uint y)
352         pure
353         internal
354         returns (uint)
355     {
356         require(y <= x, "Safe sub failed");
357         return x - y;
358     }
359 
360     /**
361      * @return True iff multiplying x and y would not overflow.
362      */
363     function mulIsSafe(uint x, uint y)
364         pure
365         internal
366         returns (bool)
367     {
368         if (x == 0) {
369             return true;
370         }
371         return (x * y) / x == y;
372     }
373 
374     /**
375      * @return The result of multiplying x and y, throwing an exception in case of overflow.
376      */
377     function safeMul(uint x, uint y)
378         pure
379         internal
380         returns (uint)
381     {
382         if (x == 0) {
383             return 0;
384         }
385         uint p = x * y;
386         require(p / x == y, "Safe mul failed");
387         return p;
388     }
389 
390     /**
391      * @return The result of multiplying x and y, interpreting the operands as fixed-point
392      * decimals. Throws an exception in case of overflow.
393      * 
394      * @dev A unit factor is divided out after the product of x and y is evaluated,
395      * so that product must be less than 2**256.
396      * Incidentally, the internal division always rounds down: one could have rounded to the nearest integer,
397      * but then one would be spending a significant fraction of a cent (of order a microether
398      * at present gas prices) in order to save less than one part in 0.5 * 10^18 per operation, if the operands
399      * contain small enough fractional components. It would also marginally diminish the 
400      * domain this function is defined upon. 
401      */
402     function safeMul_dec(uint x, uint y)
403         pure
404         internal
405         returns (uint)
406     {
407         /* Divide by UNIT to remove the extra factor introduced by the product. */
408         return safeMul(x, y) / UNIT;
409 
410     }
411 
412     /**
413      * @return True iff the denominator of x/y is nonzero.
414      */
415     function divIsSafe(uint x, uint y)
416         pure
417         internal
418         returns (bool)
419     {
420         return y != 0;
421     }
422 
423     /**
424      * @return The result of dividing x by y, throwing an exception if the divisor is zero.
425      */
426     function safeDiv(uint x, uint y)
427         pure
428         internal
429         returns (uint)
430     {
431         /* Although a 0 denominator already throws an exception,
432          * it is equivalent to a THROW operation, which consumes all gas.
433          * A require statement emits REVERT instead, which remits remaining gas. */
434         require(y != 0, "Denominator cannot be zero");
435         return x / y;
436     }
437 
438     /**
439      * @return The result of dividing x by y, interpreting the operands as fixed point decimal numbers.
440      * @dev Throws an exception in case of overflow or zero divisor; x must be less than 2^256 / UNIT.
441      * Internal rounding is downward: a similar caveat holds as with safeDecMul().
442      */
443     function safeDiv_dec(uint x, uint y)
444         pure
445         internal
446         returns (uint)
447     {
448         /* Reintroduce the UNIT factor that will be divided out by y. */
449         return safeDiv(safeMul(x, UNIT), y);
450     }
451 
452     /**
453      * @dev Convert an unsigned integer to a unsigned fixed-point decimal.
454      * Throw an exception if the result would be out of range.
455      */
456     function intToDec(uint i)
457         pure
458         internal
459         returns (uint)
460     {
461         return safeMul(i, UNIT);
462     }
463 }
464 
465 
466 /*
467 -----------------------------------------------------------------
468 FILE INFORMATION
469 -----------------------------------------------------------------
470 
471 file:       State.sol
472 version:    1.1
473 author:     Dominic Romanowski
474             Anton Jurisevic
475 
476 date:       2018-05-15
477 
478 -----------------------------------------------------------------
479 MODULE DESCRIPTION
480 -----------------------------------------------------------------
481 
482 This contract is used side by side with external state token
483 contracts, such as Havven and Nomin.
484 It provides an easy way to upgrade contract logic while
485 maintaining all user balances and allowances. This is designed
486 to make the changeover as easy as possible, since mappings
487 are not so cheap or straightforward to migrate.
488 
489 The first deployed contract would create this state contract,
490 using it as its store of balances.
491 When a new contract is deployed, it links to the existing
492 state contract, whose owner would then change its associated
493 contract to the new one.
494 
495 -----------------------------------------------------------------
496 */
497 
498 
499 contract State is Owned {
500     // the address of the contract that can modify variables
501     // this can only be changed by the owner of this contract
502     address public associatedContract;
503 
504 
505     constructor(address _owner, address _associatedContract)
506         Owned(_owner)
507         public
508     {
509         associatedContract = _associatedContract;
510         emit AssociatedContractUpdated(_associatedContract);
511     }
512 
513     /* ========== SETTERS ========== */
514 
515     // Change the associated contract to a new address
516     function setAssociatedContract(address _associatedContract)
517         external
518         onlyOwner
519     {
520         associatedContract = _associatedContract;
521         emit AssociatedContractUpdated(_associatedContract);
522     }
523 
524     /* ========== MODIFIERS ========== */
525 
526     modifier onlyAssociatedContract
527     {
528         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
529         _;
530     }
531 
532     /* ========== EVENTS ========== */
533 
534     event AssociatedContractUpdated(address associatedContract);
535 }
536 
537 
538 /*
539 -----------------------------------------------------------------
540 FILE INFORMATION
541 -----------------------------------------------------------------
542 
543 file:       TokenState.sol
544 version:    1.1
545 author:     Dominic Romanowski
546             Anton Jurisevic
547 
548 date:       2018-05-15
549 
550 -----------------------------------------------------------------
551 MODULE DESCRIPTION
552 -----------------------------------------------------------------
553 
554 A contract that holds the state of an ERC20 compliant token.
555 
556 This contract is used side by side with external state token
557 contracts, such as Havven and Nomin.
558 It provides an easy way to upgrade contract logic while
559 maintaining all user balances and allowances. This is designed
560 to make the changeover as easy as possible, since mappings
561 are not so cheap or straightforward to migrate.
562 
563 The first deployed contract would create this state contract,
564 using it as its store of balances.
565 When a new contract is deployed, it links to the existing
566 state contract, whose owner would then change its associated
567 contract to the new one.
568 
569 -----------------------------------------------------------------
570 */
571 
572 
573 /**
574  * @title ERC20 Token State
575  * @notice Stores balance information of an ERC20 token contract.
576  */
577 contract TokenState is State {
578 
579     /* ERC20 fields. */
580     mapping(address => uint) public balanceOf;
581     mapping(address => mapping(address => uint)) public allowance;
582 
583     /**
584      * @dev Constructor
585      * @param _owner The address which controls this contract.
586      * @param _associatedContract The ERC20 contract whose state this composes.
587      */
588     constructor(address _owner, address _associatedContract)
589         State(_owner, _associatedContract)
590         public
591     {}
592 
593     /* ========== SETTERS ========== */
594 
595     /**
596      * @notice Set ERC20 allowance.
597      * @dev Only the associated contract may call this.
598      * @param tokenOwner The authorising party.
599      * @param spender The authorised party.
600      * @param value The total value the authorised party may spend on the
601      * authorising party's behalf.
602      */
603     function setAllowance(address tokenOwner, address spender, uint value)
604         external
605         onlyAssociatedContract
606     {
607         allowance[tokenOwner][spender] = value;
608     }
609 
610     /**
611      * @notice Set the balance in a given account
612      * @dev Only the associated contract may call this.
613      * @param account The account whose value to set.
614      * @param value The new balance of the given account.
615      */
616     function setBalanceOf(address account, uint value)
617         external
618         onlyAssociatedContract
619     {
620         balanceOf[account] = value;
621     }
622 }
623 
624 
625 /*
626 -----------------------------------------------------------------
627 FILE INFORMATION
628 -----------------------------------------------------------------
629 
630 file:       Proxy.sol
631 version:    1.3
632 author:     Anton Jurisevic
633 
634 date:       2018-05-29
635 
636 -----------------------------------------------------------------
637 MODULE DESCRIPTION
638 -----------------------------------------------------------------
639 
640 A proxy contract that, if it does not recognise the function
641 being called on it, passes all value and call data to an
642 underlying target contract.
643 
644 This proxy has the capacity to toggle between DELEGATECALL
645 and CALL style proxy functionality.
646 
647 The former executes in the proxy's context, and so will preserve 
648 msg.sender and store data at the proxy address. The latter will not.
649 Therefore, any contract the proxy wraps in the CALL style must
650 implement the Proxyable interface, in order that it can pass msg.sender
651 into the underlying contract as the state parameter, messageSender.
652 
653 -----------------------------------------------------------------
654 */
655 
656 
657 contract Proxy is Owned {
658 
659     Proxyable public target;
660     bool public useDELEGATECALL;
661 
662     constructor(address _owner)
663         Owned(_owner)
664         public
665     {}
666 
667     function setTarget(Proxyable _target)
668         external
669         onlyOwner
670     {
671         target = _target;
672         emit TargetUpdated(_target);
673     }
674 
675     function setUseDELEGATECALL(bool value) 
676         external
677         onlyOwner
678     {
679         useDELEGATECALL = value;
680     }
681 
682     function _emit(bytes callData, uint numTopics,
683                    bytes32 topic1, bytes32 topic2,
684                    bytes32 topic3, bytes32 topic4)
685         external
686         onlyTarget
687     {
688         uint size = callData.length;
689         bytes memory _callData = callData;
690 
691         assembly {
692             /* The first 32 bytes of callData contain its length (as specified by the abi). 
693              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
694              * in length. It is also leftpadded to be a multiple of 32 bytes.
695              * This means moving call_data across 32 bytes guarantees we correctly access
696              * the data itself. */
697             switch numTopics
698             case 0 {
699                 log0(add(_callData, 32), size)
700             } 
701             case 1 {
702                 log1(add(_callData, 32), size, topic1)
703             }
704             case 2 {
705                 log2(add(_callData, 32), size, topic1, topic2)
706             }
707             case 3 {
708                 log3(add(_callData, 32), size, topic1, topic2, topic3)
709             }
710             case 4 {
711                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
712             }
713         }
714     }
715 
716     function()
717         external
718         payable
719     {
720         if (useDELEGATECALL) {
721             assembly {
722                 /* Copy call data into free memory region. */
723                 let free_ptr := mload(0x40)
724                 calldatacopy(free_ptr, 0, calldatasize)
725 
726                 /* Forward all gas and call data to the target contract. */
727                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
728                 returndatacopy(free_ptr, 0, returndatasize)
729 
730                 /* Revert if the call failed, otherwise return the result. */
731                 if iszero(result) { revert(free_ptr, returndatasize) }
732                 return(free_ptr, returndatasize)
733             }
734         } else {
735             /* Here we are as above, but must send the messageSender explicitly 
736              * since we are using CALL rather than DELEGATECALL. */
737             target.setMessageSender(msg.sender);
738             assembly {
739                 let free_ptr := mload(0x40)
740                 calldatacopy(free_ptr, 0, calldatasize)
741 
742                 /* We must explicitly forward ether to the underlying contract as well. */
743                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
744                 returndatacopy(free_ptr, 0, returndatasize)
745 
746                 if iszero(result) { revert(free_ptr, returndatasize) }
747                 return(free_ptr, returndatasize)
748             }
749         }
750     }
751 
752     modifier onlyTarget {
753         require(Proxyable(msg.sender) == target, "This action can only be performed by the proxy target");
754         _;
755     }
756 
757     event TargetUpdated(Proxyable newTarget);
758 }
759 
760 
761 /*
762 -----------------------------------------------------------------
763 FILE INFORMATION
764 -----------------------------------------------------------------
765 
766 file:       Proxyable.sol
767 version:    1.1
768 author:     Anton Jurisevic
769 
770 date:       2018-05-15
771 
772 checked:    Mike Spain
773 approved:   Samuel Brooks
774 
775 -----------------------------------------------------------------
776 MODULE DESCRIPTION
777 -----------------------------------------------------------------
778 
779 A proxyable contract that works hand in hand with the Proxy contract
780 to allow for anyone to interact with the underlying contract both
781 directly and through the proxy.
782 
783 -----------------------------------------------------------------
784 */
785 
786 
787 // This contract should be treated like an abstract contract
788 contract Proxyable is Owned {
789     /* The proxy this contract exists behind. */
790     Proxy public proxy;
791 
792     /* The caller of the proxy, passed through to this contract.
793      * Note that every function using this member must apply the onlyProxy or
794      * optionalProxy modifiers, otherwise their invocations can use stale values. */ 
795     address messageSender; 
796 
797     constructor(address _proxy, address _owner)
798         Owned(_owner)
799         public
800     {
801         proxy = Proxy(_proxy);
802         emit ProxyUpdated(_proxy);
803     }
804 
805     function setProxy(address _proxy)
806         external
807         onlyOwner
808     {
809         proxy = Proxy(_proxy);
810         emit ProxyUpdated(_proxy);
811     }
812 
813     function setMessageSender(address sender)
814         external
815         onlyProxy
816     {
817         messageSender = sender;
818     }
819 
820     modifier onlyProxy {
821         require(Proxy(msg.sender) == proxy, "Only the proxy can call this function");
822         _;
823     }
824 
825     modifier optionalProxy
826     {
827         if (Proxy(msg.sender) != proxy) {
828             messageSender = msg.sender;
829         }
830         _;
831     }
832 
833     modifier optionalProxy_onlyOwner
834     {
835         if (Proxy(msg.sender) != proxy) {
836             messageSender = msg.sender;
837         }
838         require(messageSender == owner, "This action can only be performed by the owner");
839         _;
840     }
841 
842     event ProxyUpdated(address proxyAddress);
843 }
844 
845 
846 /*
847 -----------------------------------------------------------------
848 FILE INFORMATION
849 -----------------------------------------------------------------
850 
851 file:       ExternStateToken.sol
852 version:    1.0
853 author:     Kevin Brown
854 date:       2018-08-06
855 
856 -----------------------------------------------------------------
857 MODULE DESCRIPTION
858 -----------------------------------------------------------------
859 
860 This contract offers a modifer that can prevent reentrancy on
861 particular actions. It will not work if you put it on multiple
862 functions that can be called from each other. Specifically guard
863 external entry points to the contract with the modifier only.
864 
865 -----------------------------------------------------------------
866 */
867 
868 contract ReentrancyPreventer {
869     /* ========== MODIFIERS ========== */
870     bool isInFunctionBody = false;
871 
872     modifier preventReentrancy {
873         require(!isInFunctionBody, "Reverted to prevent reentrancy");
874         isInFunctionBody = true;
875         _;
876         isInFunctionBody = false;
877     }
878 }
879 
880 /*
881 -----------------------------------------------------------------
882 FILE INFORMATION
883 -----------------------------------------------------------------
884 
885 file:       ExternStateToken.sol
886 version:    1.3
887 author:     Anton Jurisevic
888             Dominic Romanowski
889 
890 date:       2018-05-29
891 
892 -----------------------------------------------------------------
893 MODULE DESCRIPTION
894 -----------------------------------------------------------------
895 
896 A partial ERC20 token contract, designed to operate with a proxy.
897 To produce a complete ERC20 token, transfer and transferFrom
898 tokens must be implemented, using the provided _byProxy internal
899 functions.
900 This contract utilises an external state for upgradeability.
901 
902 -----------------------------------------------------------------
903 */
904 
905 
906 /**
907  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
908  */
909 contract ExternStateToken is SafeDecimalMath, SelfDestructible, Proxyable, ReentrancyPreventer {
910 
911     /* ========== STATE VARIABLES ========== */
912 
913     /* Stores balances and allowances. */
914     TokenState public tokenState;
915 
916     /* Other ERC20 fields.
917      * Note that the decimals field is defined in SafeDecimalMath.*/
918     string public name;
919     string public symbol;
920     uint public totalSupply;
921 
922     /**
923      * @dev Constructor.
924      * @param _proxy The proxy associated with this contract.
925      * @param _name Token's ERC20 name.
926      * @param _symbol Token's ERC20 symbol.
927      * @param _totalSupply The total supply of the token.
928      * @param _tokenState The TokenState contract address.
929      * @param _owner The owner of this contract.
930      */
931     constructor(address _proxy, TokenState _tokenState,
932                 string _name, string _symbol, uint _totalSupply,
933                 address _owner)
934         SelfDestructible(_owner)
935         Proxyable(_proxy, _owner)
936         public
937     {
938         name = _name;
939         symbol = _symbol;
940         totalSupply = _totalSupply;
941         tokenState = _tokenState;
942     }
943 
944     /* ========== VIEWS ========== */
945 
946     /**
947      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
948      * @param owner The party authorising spending of their funds.
949      * @param spender The party spending tokenOwner's funds.
950      */
951     function allowance(address owner, address spender)
952         public
953         view
954         returns (uint)
955     {
956         return tokenState.allowance(owner, spender);
957     }
958 
959     /**
960      * @notice Returns the ERC20 token balance of a given account.
961      */
962     function balanceOf(address account)
963         public
964         view
965         returns (uint)
966     {
967         return tokenState.balanceOf(account);
968     }
969 
970     /* ========== MUTATIVE FUNCTIONS ========== */
971 
972     /**
973      * @notice Set the address of the TokenState contract.
974      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
975      * as balances would be unreachable.
976      */ 
977     function setTokenState(TokenState _tokenState)
978         external
979         optionalProxy_onlyOwner
980     {
981         tokenState = _tokenState;
982         emitTokenStateUpdated(_tokenState);
983     }
984 
985     function _internalTransfer(address from, address to, uint value) 
986         internal
987         preventReentrancy
988         returns (bool)
989     { 
990         /* Disallow transfers to irretrievable-addresses. */
991         require(to != address(0), "Cannot transfer to the 0 address");
992         require(to != address(this), "Cannot transfer to the underlying contract");
993         require(to != address(proxy), "Cannot transfer to the proxy contract");
994 
995         /* Insufficient balance will be handled by the safe subtraction. */
996         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), value));
997         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), value));
998 
999         /*
1000         If we're transferring to a contract and it implements the havvenTokenFallback function, call it.
1001         This isn't ERC223 compliant because:
1002            1. We don't revert if the contract doesn't implement havvenTokenFallback.
1003               This is because many DEXes and other contracts that expect to work with the standard
1004               approve / transferFrom workflow don't implement tokenFallback but can still process our tokens as
1005               usual, so it feels very harsh and likely to cause trouble if we add this restriction after having
1006               previously gone live with a vanilla ERC20.
1007            2. We don't pass the bytes parameter.
1008               This is because of this solidity bug: https://github.com/ethereum/solidity/issues/2884
1009            3. We also don't let the user use a custom tokenFallback. We figure as we're already not standards
1010               compliant, there won't be a use case where users can't just implement our specific function.
1011 
1012         As such we've called the function havvenTokenFallback to be clear that we are not following the standard.
1013         */
1014 
1015         // Is the to address a contract? We can check the code size on that address and know.
1016         uint length;
1017 
1018         // solium-disable-next-line security/no-inline-assembly
1019         assembly {
1020             // Retrieve the size of the code on the recipient address
1021             length := extcodesize(to)
1022         }
1023 
1024         // If there's code there, it's a contract
1025         if (length > 0) {
1026             // Now we need to optionally call havvenTokenFallback(address from, uint value).
1027             // We can't call it the normal way because that reverts when the recipient doesn't implement the function.
1028             // We'll use .call(), which means we need the function selector. We've pre-computed
1029             // abi.encodeWithSignature("havvenTokenFallback(address,uint256)"), to save some gas.
1030 
1031             // solium-disable-next-line security/no-low-level-calls
1032             to.call(0xcbff5d96, messageSender, value);
1033 
1034             // And yes, we specifically don't care if this call fails, so we're not checking the return value.
1035         }
1036 
1037         // Emit a standard ERC20 transfer event
1038         emitTransfer(from, to, value);
1039 
1040         return true;
1041     }
1042 
1043     /**
1044      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
1045      * the onlyProxy or optionalProxy modifiers.
1046      */
1047     function _transfer_byProxy(address from, address to, uint value)
1048         internal
1049         returns (bool)
1050     {
1051         return _internalTransfer(from, to, value);
1052     }
1053 
1054     /**
1055      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
1056      * possessing the optionalProxy or optionalProxy modifiers.
1057      */
1058     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1059         internal
1060         returns (bool)
1061     {
1062         /* Insufficient allowance will be handled by the safe subtraction. */
1063         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
1064         return _internalTransfer(from, to, value);
1065     }
1066 
1067     /**
1068      * @notice Approves spender to transfer on the message sender's behalf.
1069      */
1070     function approve(address spender, uint value)
1071         public
1072         optionalProxy
1073         returns (bool)
1074     {
1075         address sender = messageSender;
1076 
1077         tokenState.setAllowance(sender, spender, value);
1078         emitApproval(sender, spender, value);
1079         return true;
1080     }
1081 
1082     /* ========== EVENTS ========== */
1083 
1084     event Transfer(address indexed from, address indexed to, uint value);
1085     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
1086     function emitTransfer(address from, address to, uint value) internal {
1087         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
1088     }
1089 
1090     event Approval(address indexed owner, address indexed spender, uint value);
1091     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
1092     function emitApproval(address owner, address spender, uint value) internal {
1093         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
1094     }
1095 
1096     event TokenStateUpdated(address newTokenState);
1097     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
1098     function emitTokenStateUpdated(address newTokenState) internal {
1099         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
1100     }
1101 }
1102 
1103 
1104 /*
1105 -----------------------------------------------------------------
1106 FILE INFORMATION
1107 -----------------------------------------------------------------
1108 
1109 file:       FeeToken.sol
1110 version:    1.3
1111 author:     Anton Jurisevic
1112             Dominic Romanowski
1113             Kevin Brown
1114 
1115 date:       2018-05-29
1116 
1117 -----------------------------------------------------------------
1118 MODULE DESCRIPTION
1119 -----------------------------------------------------------------
1120 
1121 A token which also has a configurable fee rate
1122 charged on its transfers. This is designed to be overridden in
1123 order to produce an ERC20-compliant token.
1124 
1125 These fees accrue into a pool, from which a nominated authority
1126 may withdraw.
1127 
1128 This contract utilises an external state for upgradeability.
1129 
1130 -----------------------------------------------------------------
1131 */
1132 
1133 
1134 /**
1135  * @title ERC20 Token contract, with detached state.
1136  * Additionally charges fees on each transfer.
1137  */
1138 contract FeeToken is ExternStateToken {
1139 
1140     /* ========== STATE VARIABLES ========== */
1141 
1142     /* ERC20 members are declared in ExternStateToken. */
1143 
1144     /* A percentage fee charged on each transfer. */
1145     uint public transferFeeRate;
1146     /* Fee may not exceed 10%. */
1147     uint constant MAX_TRANSFER_FEE_RATE = UNIT / 10;
1148     /* The address with the authority to distribute fees. */
1149     address public feeAuthority;
1150     /* The address that fees will be pooled in. */
1151     address public constant FEE_ADDRESS = 0xfeefeefeefeefeefeefeefeefeefeefeefeefeef;
1152 
1153 
1154     /* ========== CONSTRUCTOR ========== */
1155 
1156     /**
1157      * @dev Constructor.
1158      * @param _proxy The proxy associated with this contract.
1159      * @param _name Token's ERC20 name.
1160      * @param _symbol Token's ERC20 symbol.
1161      * @param _totalSupply The total supply of the token.
1162      * @param _transferFeeRate The fee rate to charge on transfers.
1163      * @param _feeAuthority The address which has the authority to withdraw fees from the accumulated pool.
1164      * @param _owner The owner of this contract.
1165      */
1166     constructor(address _proxy, TokenState _tokenState, string _name, string _symbol, uint _totalSupply,
1167                 uint _transferFeeRate, address _feeAuthority, address _owner)
1168         ExternStateToken(_proxy, _tokenState,
1169                          _name, _symbol, _totalSupply,
1170                          _owner)
1171         public
1172     {
1173         feeAuthority = _feeAuthority;
1174 
1175         /* Constructed transfer fee rate should respect the maximum fee rate. */
1176         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
1177         transferFeeRate = _transferFeeRate;
1178     }
1179 
1180     /* ========== SETTERS ========== */
1181 
1182     /**
1183      * @notice Set the transfer fee, anywhere within the range 0-10%.
1184      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1185      */
1186     function setTransferFeeRate(uint _transferFeeRate)
1187         external
1188         optionalProxy_onlyOwner
1189     {
1190         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
1191         transferFeeRate = _transferFeeRate;
1192         emitTransferFeeRateUpdated(_transferFeeRate);
1193     }
1194 
1195     /**
1196      * @notice Set the address of the user/contract responsible for collecting or
1197      * distributing fees.
1198      */
1199     function setFeeAuthority(address _feeAuthority)
1200         public
1201         optionalProxy_onlyOwner
1202     {
1203         feeAuthority = _feeAuthority;
1204         emitFeeAuthorityUpdated(_feeAuthority);
1205     }
1206 
1207     /* ========== VIEWS ========== */
1208 
1209     /**
1210      * @notice Calculate the Fee charged on top of a value being sent
1211      * @return Return the fee charged
1212      */
1213     function transferFeeIncurred(uint value)
1214         public
1215         view
1216         returns (uint)
1217     {
1218         return safeMul_dec(value, transferFeeRate);
1219         /* Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1220          * This is on the basis that transfers less than this value will result in a nil fee.
1221          * Probably too insignificant to worry about, but the following code will achieve it.
1222          *      if (fee == 0 && transferFeeRate != 0) {
1223          *          return _value;
1224          *      }
1225          *      return fee;
1226          */
1227     }
1228 
1229     /**
1230      * @notice The value that you would need to send so that the recipient receives
1231      * a specified value.
1232      */
1233     function transferPlusFee(uint value)
1234         external
1235         view
1236         returns (uint)
1237     {
1238         return safeAdd(value, transferFeeIncurred(value));
1239     }
1240 
1241     /**
1242      * @notice The amount the recipient will receive if you send a certain number of tokens.
1243      */
1244     function amountReceived(uint value)
1245         public
1246         view
1247         returns (uint)
1248     {
1249         return safeDiv_dec(value, safeAdd(UNIT, transferFeeRate));
1250     }
1251 
1252     /**
1253      * @notice Collected fees sit here until they are distributed.
1254      * @dev The balance of the nomin contract itself is the fee pool.
1255      */
1256     function feePool()
1257         external
1258         view
1259         returns (uint)
1260     {
1261         return tokenState.balanceOf(FEE_ADDRESS);
1262     }
1263 
1264     /* ========== MUTATIVE FUNCTIONS ========== */
1265 
1266     /**
1267      * @notice Base of transfer functions
1268      */
1269     function _internalTransfer(address from, address to, uint amount, uint fee)
1270         internal
1271         returns (bool)
1272     {
1273         /* Disallow transfers to irretrievable-addresses. */
1274         require(to != address(0), "Cannot transfer to the 0 address");
1275         require(to != address(this), "Cannot transfer to the underlying contract");
1276         require(to != address(proxy), "Cannot transfer to the proxy contract");
1277 
1278         /* Insufficient balance will be handled by the safe subtraction. */
1279         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), safeAdd(amount, fee)));
1280         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), amount));
1281         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), fee));
1282 
1283         /* Emit events for both the transfer itself and the fee. */
1284         emitTransfer(from, to, amount);
1285         emitTransfer(from, FEE_ADDRESS, fee);
1286 
1287         return true;
1288     }
1289 
1290     /**
1291      * @notice ERC20 friendly transfer function.
1292      */
1293     function _transfer_byProxy(address sender, address to, uint value)
1294         internal
1295         returns (bool)
1296     {
1297         uint received = amountReceived(value);
1298         uint fee = safeSub(value, received);
1299 
1300         return _internalTransfer(sender, to, received, fee);
1301     }
1302 
1303     /**
1304      * @notice ERC20 friendly transferFrom function.
1305      */
1306     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1307         internal
1308         returns (bool)
1309     {
1310         /* The fee is deducted from the amount sent. */
1311         uint received = amountReceived(value);
1312         uint fee = safeSub(value, received);
1313 
1314         /* Reduce the allowance by the amount we're transferring.
1315          * The safeSub call will handle an insufficient allowance. */
1316         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
1317 
1318         return _internalTransfer(from, to, received, fee);
1319     }
1320 
1321     /**
1322      * @notice Ability to transfer where the sender pays the fees (not ERC20)
1323      */
1324     function _transferSenderPaysFee_byProxy(address sender, address to, uint value)
1325         internal
1326         returns (bool)
1327     {
1328         /* The fee is added to the amount sent. */
1329         uint fee = transferFeeIncurred(value);
1330         return _internalTransfer(sender, to, value, fee);
1331     }
1332 
1333     /**
1334      * @notice Ability to transferFrom where they sender pays the fees (not ERC20).
1335      */
1336     function _transferFromSenderPaysFee_byProxy(address sender, address from, address to, uint value)
1337         internal
1338         returns (bool)
1339     {
1340         /* The fee is added to the amount sent. */
1341         uint fee = transferFeeIncurred(value);
1342         uint total = safeAdd(value, fee);
1343 
1344         /* Reduce the allowance by the amount we're transferring. */
1345         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), total));
1346 
1347         return _internalTransfer(from, to, value, fee);
1348     }
1349 
1350     /**
1351      * @notice Withdraw tokens from the fee pool into a given account.
1352      * @dev Only the fee authority may call this.
1353      */
1354     function withdrawFees(address account, uint value)
1355         external
1356         onlyFeeAuthority
1357         returns (bool)
1358     {
1359         require(account != address(0), "Must supply an account address to withdraw fees");
1360 
1361         /* 0-value withdrawals do nothing. */
1362         if (value == 0) {
1363             return false;
1364         }
1365 
1366         /* Safe subtraction ensures an exception is thrown if the balance is insufficient. */
1367         tokenState.setBalanceOf(FEE_ADDRESS, safeSub(tokenState.balanceOf(FEE_ADDRESS), value));
1368         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), value));
1369 
1370         emitFeesWithdrawn(account, value);
1371         emitTransfer(FEE_ADDRESS, account, value);
1372 
1373         return true;
1374     }
1375 
1376     /**
1377      * @notice Donate tokens from the sender's balance into the fee pool.
1378      */
1379     function donateToFeePool(uint n)
1380         external
1381         optionalProxy
1382         returns (bool)
1383     {
1384         address sender = messageSender;
1385         /* Empty donations are disallowed. */
1386         uint balance = tokenState.balanceOf(sender);
1387         require(balance != 0, "Must have a balance in order to donate to the fee pool");
1388 
1389         /* safeSub ensures the donor has sufficient balance. */
1390         tokenState.setBalanceOf(sender, safeSub(balance, n));
1391         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), n));
1392 
1393         emitFeesDonated(sender, n);
1394         emitTransfer(sender, FEE_ADDRESS, n);
1395 
1396         return true;
1397     }
1398 
1399 
1400     /* ========== MODIFIERS ========== */
1401 
1402     modifier onlyFeeAuthority
1403     {
1404         require(msg.sender == feeAuthority, "Only the fee authority can do this action");
1405         _;
1406     }
1407 
1408 
1409     /* ========== EVENTS ========== */
1410 
1411     event TransferFeeRateUpdated(uint newFeeRate);
1412     bytes32 constant TRANSFERFEERATEUPDATED_SIG = keccak256("TransferFeeRateUpdated(uint256)");
1413     function emitTransferFeeRateUpdated(uint newFeeRate) internal {
1414         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEERATEUPDATED_SIG, 0, 0, 0);
1415     }
1416 
1417     event FeeAuthorityUpdated(address newFeeAuthority);
1418     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
1419     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
1420         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
1421     } 
1422 
1423     event FeesWithdrawn(address indexed account, uint value);
1424     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
1425     function emitFeesWithdrawn(address account, uint value) internal {
1426         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
1427     }
1428 
1429     event FeesDonated(address indexed donor, uint value);
1430     bytes32 constant FEESDONATED_SIG = keccak256("FeesDonated(address,uint256)");
1431     function emitFeesDonated(address donor, uint value) internal {
1432         proxy._emit(abi.encode(value), 2, FEESDONATED_SIG, bytes32(donor), 0, 0);
1433     }
1434 }
1435 
1436 
1437 /*
1438 -----------------------------------------------------------------
1439 FILE INFORMATION
1440 -----------------------------------------------------------------
1441 
1442 file:       Nomin.sol
1443 version:    1.2
1444 author:     Anton Jurisevic
1445             Mike Spain
1446             Dominic Romanowski
1447             Kevin Brown
1448 
1449 date:       2018-05-29
1450 
1451 -----------------------------------------------------------------
1452 MODULE DESCRIPTION
1453 -----------------------------------------------------------------
1454 
1455 Havven-backed nomin stablecoin contract.
1456 
1457 This contract issues nomins, which are tokens worth 1 USD each.
1458 
1459 Nomins are issuable by Havven holders who have to lock up some
1460 value of their havvens to issue H * Cmax nomins. Where Cmax is
1461 some value less than 1.
1462 
1463 A configurable fee is charged on nomin transfers and deposited
1464 into a common pot, which havven holders may withdraw from once
1465 per fee period.
1466 
1467 -----------------------------------------------------------------
1468 */
1469 
1470 
1471 contract Nomin is FeeToken {
1472 
1473     /* ========== STATE VARIABLES ========== */
1474 
1475     Havven public havven;
1476 
1477     // Accounts which have lost the privilege to transact in nomins.
1478     mapping(address => bool) public frozen;
1479 
1480     // Nomin transfers incur a 15 bp fee by default.
1481     uint constant TRANSFER_FEE_RATE = 15 * UNIT / 10000;
1482     string constant TOKEN_NAME = "Nomin USD";
1483     string constant TOKEN_SYMBOL = "nUSD";
1484 
1485     /* ========== CONSTRUCTOR ========== */
1486 
1487     constructor(address _proxy, TokenState _tokenState, Havven _havven,
1488                 uint _totalSupply,
1489                 address _owner)
1490         FeeToken(_proxy, _tokenState,
1491                  TOKEN_NAME, TOKEN_SYMBOL, _totalSupply,
1492                  TRANSFER_FEE_RATE,
1493                  _havven, // The havven contract is the fee authority.
1494                  _owner)
1495         public
1496     {
1497         require(_proxy != 0, "_proxy cannot be 0");
1498         require(address(_havven) != 0, "_havven cannot be 0");
1499         require(_owner != 0, "_owner cannot be 0");
1500 
1501         // It should not be possible to transfer to the fee pool directly (or confiscate its balance).
1502         frozen[FEE_ADDRESS] = true;
1503         havven = _havven;
1504     }
1505 
1506     /* ========== SETTERS ========== */
1507 
1508     function setHavven(Havven _havven)
1509         external
1510         optionalProxy_onlyOwner
1511     {
1512         // havven should be set as the feeAuthority after calling this depending on
1513         // havven's internal logic
1514         havven = _havven;
1515         setFeeAuthority(_havven);
1516         emitHavvenUpdated(_havven);
1517     }
1518 
1519 
1520     /* ========== MUTATIVE FUNCTIONS ========== */
1521 
1522     /* Override ERC20 transfer function in order to check
1523      * whether the recipient account is frozen. Note that there is
1524      * no need to check whether the sender has a frozen account,
1525      * since their funds have already been confiscated,
1526      * and no new funds can be transferred to it.*/
1527     function transfer(address to, uint value)
1528         public
1529         optionalProxy
1530         returns (bool)
1531     {
1532         require(!frozen[to], "Cannot transfer to frozen address");
1533         return _transfer_byProxy(messageSender, to, value);
1534     }
1535 
1536     /* Override ERC20 transferFrom function in order to check
1537      * whether the recipient account is frozen. */
1538     function transferFrom(address from, address to, uint value)
1539         public
1540         optionalProxy
1541         returns (bool)
1542     {
1543         require(!frozen[to], "Cannot transfer to frozen address");
1544         return _transferFrom_byProxy(messageSender, from, to, value);
1545     }
1546 
1547     function transferSenderPaysFee(address to, uint value)
1548         public
1549         optionalProxy
1550         returns (bool)
1551     {
1552         require(!frozen[to], "Cannot transfer to frozen address");
1553         return _transferSenderPaysFee_byProxy(messageSender, to, value);
1554     }
1555 
1556     function transferFromSenderPaysFee(address from, address to, uint value)
1557         public
1558         optionalProxy
1559         returns (bool)
1560     {
1561         require(!frozen[to], "Cannot transfer to frozen address");
1562         return _transferFromSenderPaysFee_byProxy(messageSender, from, to, value);
1563     }
1564 
1565     /* The owner may allow a previously-frozen contract to once
1566      * again accept and transfer nomins. */
1567     function unfreezeAccount(address target)
1568         external
1569         optionalProxy_onlyOwner
1570     {
1571         require(frozen[target] && target != FEE_ADDRESS, "Account must be frozen, and cannot be the fee address");
1572         frozen[target] = false;
1573         emitAccountUnfrozen(target);
1574     }
1575 
1576     /* Allow havven to issue a certain number of
1577      * nomins from an account. */
1578     function issue(address account, uint amount)
1579         external
1580         onlyHavven
1581     {
1582         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), amount));
1583         totalSupply = safeAdd(totalSupply, amount);
1584         emitTransfer(address(0), account, amount);
1585         emitIssued(account, amount);
1586     }
1587 
1588     /* Allow havven to burn a certain number of
1589      * nomins from an account. */
1590     function burn(address account, uint amount)
1591         external
1592         onlyHavven
1593     {
1594         tokenState.setBalanceOf(account, safeSub(tokenState.balanceOf(account), amount));
1595         totalSupply = safeSub(totalSupply, amount);
1596         emitTransfer(account, address(0), amount);
1597         emitBurned(account, amount);
1598     }
1599 
1600     /* ========== MODIFIERS ========== */
1601 
1602     modifier onlyHavven() {
1603         require(Havven(msg.sender) == havven, "Only the Havven contract can perform this action");
1604         _;
1605     }
1606 
1607     /* ========== EVENTS ========== */
1608 
1609     event HavvenUpdated(address newHavven);
1610     bytes32 constant HAVVENUPDATED_SIG = keccak256("HavvenUpdated(address)");
1611     function emitHavvenUpdated(address newHavven) internal {
1612         proxy._emit(abi.encode(newHavven), 1, HAVVENUPDATED_SIG, 0, 0, 0);
1613     }
1614 
1615     event AccountFrozen(address indexed target, uint balance);
1616     bytes32 constant ACCOUNTFROZEN_SIG = keccak256("AccountFrozen(address,uint256)");
1617     function emitAccountFrozen(address target, uint balance) internal {
1618         proxy._emit(abi.encode(balance), 2, ACCOUNTFROZEN_SIG, bytes32(target), 0, 0);
1619     }
1620 
1621     event AccountUnfrozen(address indexed target);
1622     bytes32 constant ACCOUNTUNFROZEN_SIG = keccak256("AccountUnfrozen(address)");
1623     function emitAccountUnfrozen(address target) internal {
1624         proxy._emit(abi.encode(), 2, ACCOUNTUNFROZEN_SIG, bytes32(target), 0, 0);
1625     }
1626 
1627     event Issued(address indexed account, uint amount);
1628     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
1629     function emitIssued(address account, uint amount) internal {
1630         proxy._emit(abi.encode(amount), 2, ISSUED_SIG, bytes32(account), 0, 0);
1631     }
1632 
1633     event Burned(address indexed account, uint amount);
1634     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
1635     function emitBurned(address account, uint amount) internal {
1636         proxy._emit(abi.encode(amount), 2, BURNED_SIG, bytes32(account), 0, 0);
1637     }
1638 }
1639 
1640 
1641 /*
1642 -----------------------------------------------------------------
1643 FILE INFORMATION
1644 -----------------------------------------------------------------
1645 
1646 file:       LimitedSetup.sol
1647 version:    1.1
1648 author:     Anton Jurisevic
1649 
1650 date:       2018-05-15
1651 
1652 -----------------------------------------------------------------
1653 MODULE DESCRIPTION
1654 -----------------------------------------------------------------
1655 
1656 A contract with a limited setup period. Any function modified
1657 with the setup modifier will cease to work after the
1658 conclusion of the configurable-length post-construction setup period.
1659 
1660 -----------------------------------------------------------------
1661 */
1662 
1663 
1664 /**
1665  * @title Any function decorated with the modifier this contract provides
1666  * deactivates after a specified setup period.
1667  */
1668 contract LimitedSetup {
1669 
1670     uint setupExpiryTime;
1671 
1672     /**
1673      * @dev LimitedSetup Constructor.
1674      * @param setupDuration The time the setup period will last for.
1675      */
1676     constructor(uint setupDuration)
1677         public
1678     {
1679         setupExpiryTime = now + setupDuration;
1680     }
1681 
1682     modifier onlyDuringSetup
1683     {
1684         require(now < setupExpiryTime, "Can only perform this action during setup");
1685         _;
1686     }
1687 }
1688 
1689 
1690 /*
1691 -----------------------------------------------------------------
1692 FILE INFORMATION
1693 -----------------------------------------------------------------
1694 
1695 file:       HavvenEscrow.sol
1696 version:    1.1
1697 author:     Anton Jurisevic
1698             Dominic Romanowski
1699             Mike Spain
1700 
1701 date:       2018-05-29
1702 
1703 -----------------------------------------------------------------
1704 MODULE DESCRIPTION
1705 -----------------------------------------------------------------
1706 
1707 This contract allows the foundation to apply unique vesting
1708 schedules to havven funds sold at various discounts in the token
1709 sale. HavvenEscrow gives users the ability to inspect their
1710 vested funds, their quantities and vesting dates, and to withdraw
1711 the fees that accrue on those funds.
1712 
1713 The fees are handled by withdrawing the entire fee allocation
1714 for all havvens inside the escrow contract, and then allowing
1715 the contract itself to subdivide that pool up proportionally within
1716 itself. Every time the fee period rolls over in the main Havven
1717 contract, the HavvenEscrow fee pool is remitted back into the
1718 main fee pool to be redistributed in the next fee period.
1719 
1720 -----------------------------------------------------------------
1721 */
1722 
1723 
1724 /**
1725  * @title A contract to hold escrowed havvens and free them at given schedules.
1726  */
1727 contract HavvenEscrow is SafeDecimalMath, Owned, LimitedSetup(8 weeks) {
1728     /* The corresponding Havven contract. */
1729     Havven public havven;
1730 
1731     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
1732      * These are the times at which each given quantity of havvens vests. */
1733     mapping(address => uint[2][]) public vestingSchedules;
1734 
1735     /* An account's total vested havven balance to save recomputing this for fee extraction purposes. */
1736     mapping(address => uint) public totalVestedAccountBalance;
1737 
1738     /* The total remaining vested balance, for verifying the actual havven balance of this contract against. */
1739     uint public totalVestedBalance;
1740 
1741     uint constant TIME_INDEX = 0;
1742     uint constant QUANTITY_INDEX = 1;
1743 
1744     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
1745     uint constant MAX_VESTING_ENTRIES = 20;
1746 
1747 
1748     /* ========== CONSTRUCTOR ========== */
1749 
1750     constructor(address _owner, Havven _havven)
1751         Owned(_owner)
1752         public
1753     {
1754         havven = _havven;
1755     }
1756 
1757 
1758     /* ========== SETTERS ========== */
1759 
1760     function setHavven(Havven _havven)
1761         external
1762         onlyOwner
1763     {
1764         havven = _havven;
1765         emit HavvenUpdated(_havven);
1766     }
1767 
1768 
1769     /* ========== VIEW FUNCTIONS ========== */
1770 
1771     /**
1772      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
1773      */
1774     function balanceOf(address account)
1775         public
1776         view
1777         returns (uint)
1778     {
1779         return totalVestedAccountBalance[account];
1780     }
1781 
1782     /**
1783      * @notice The number of vesting dates in an account's schedule.
1784      */
1785     function numVestingEntries(address account)
1786         public
1787         view
1788         returns (uint)
1789     {
1790         return vestingSchedules[account].length;
1791     }
1792 
1793     /**
1794      * @notice Get a particular schedule entry for an account.
1795      * @return A pair of uints: (timestamp, havven quantity).
1796      */
1797     function getVestingScheduleEntry(address account, uint index)
1798         public
1799         view
1800         returns (uint[2])
1801     {
1802         return vestingSchedules[account][index];
1803     }
1804 
1805     /**
1806      * @notice Get the time at which a given schedule entry will vest.
1807      */
1808     function getVestingTime(address account, uint index)
1809         public
1810         view
1811         returns (uint)
1812     {
1813         return getVestingScheduleEntry(account,index)[TIME_INDEX];
1814     }
1815 
1816     /**
1817      * @notice Get the quantity of havvens associated with a given schedule entry.
1818      */
1819     function getVestingQuantity(address account, uint index)
1820         public
1821         view
1822         returns (uint)
1823     {
1824         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
1825     }
1826 
1827     /**
1828      * @notice Obtain the index of the next schedule entry that will vest for a given user.
1829      */
1830     function getNextVestingIndex(address account)
1831         public
1832         view
1833         returns (uint)
1834     {
1835         uint len = numVestingEntries(account);
1836         for (uint i = 0; i < len; i++) {
1837             if (getVestingTime(account, i) != 0) {
1838                 return i;
1839             }
1840         }
1841         return len;
1842     }
1843 
1844     /**
1845      * @notice Obtain the next schedule entry that will vest for a given user.
1846      * @return A pair of uints: (timestamp, havven quantity). */
1847     function getNextVestingEntry(address account)
1848         public
1849         view
1850         returns (uint[2])
1851     {
1852         uint index = getNextVestingIndex(account);
1853         if (index == numVestingEntries(account)) {
1854             return [uint(0), 0];
1855         }
1856         return getVestingScheduleEntry(account, index);
1857     }
1858 
1859     /**
1860      * @notice Obtain the time at which the next schedule entry will vest for a given user.
1861      */
1862     function getNextVestingTime(address account)
1863         external
1864         view
1865         returns (uint)
1866     {
1867         return getNextVestingEntry(account)[TIME_INDEX];
1868     }
1869 
1870     /**
1871      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
1872      */
1873     function getNextVestingQuantity(address account)
1874         external
1875         view
1876         returns (uint)
1877     {
1878         return getNextVestingEntry(account)[QUANTITY_INDEX];
1879     }
1880 
1881 
1882     /* ========== MUTATIVE FUNCTIONS ========== */
1883 
1884     /**
1885      * @notice Withdraws a quantity of havvens back to the havven contract.
1886      * @dev This may only be called by the owner during the contract's setup period.
1887      */
1888     function withdrawHavvens(uint quantity)
1889         external
1890         onlyOwner
1891         onlyDuringSetup
1892     {
1893         havven.transfer(havven, quantity);
1894     }
1895 
1896     /**
1897      * @notice Destroy the vesting information associated with an account.
1898      */
1899     function purgeAccount(address account)
1900         external
1901         onlyOwner
1902         onlyDuringSetup
1903     {
1904         delete vestingSchedules[account];
1905         totalVestedBalance = safeSub(totalVestedBalance, totalVestedAccountBalance[account]);
1906         delete totalVestedAccountBalance[account];
1907     }
1908 
1909     /**
1910      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
1911      * @dev A call to this should be accompanied by either enough balance already available
1912      * in this contract, or a corresponding call to havven.endow(), to ensure that when
1913      * the funds are withdrawn, there is enough balance, as well as correctly calculating
1914      * the fees.
1915      * This may only be called by the owner during the contract's setup period.
1916      * Note; although this function could technically be used to produce unbounded
1917      * arrays, it's only in the foundation's command to add to these lists.
1918      * @param account The account to append a new vesting entry to.
1919      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
1920      * @param quantity The quantity of havvens that will vest.
1921      */
1922     function appendVestingEntry(address account, uint time, uint quantity)
1923         public
1924         onlyOwner
1925         onlyDuringSetup
1926     {
1927         /* No empty or already-passed vesting entries allowed. */
1928         require(now < time, "Time must be in the future");
1929         require(quantity != 0, "Quantity cannot be zero");
1930 
1931         /* There must be enough balance in the contract to provide for the vesting entry. */
1932         totalVestedBalance = safeAdd(totalVestedBalance, quantity);
1933         require(totalVestedBalance <= havven.balanceOf(this), "Must be enough balance in the contract to provide for the vesting entry");
1934 
1935         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
1936         uint scheduleLength = vestingSchedules[account].length;
1937         require(scheduleLength <= MAX_VESTING_ENTRIES, "Vesting schedule is too long");
1938 
1939         if (scheduleLength == 0) {
1940             totalVestedAccountBalance[account] = quantity;
1941         } else {
1942             /* Disallow adding new vested havvens earlier than the last one.
1943              * Since entries are only appended, this means that no vesting date can be repeated. */
1944             require(getVestingTime(account, numVestingEntries(account) - 1) < time, "Cannot add new vested entries earlier than the last one");
1945             totalVestedAccountBalance[account] = safeAdd(totalVestedAccountBalance[account], quantity);
1946         }
1947 
1948         vestingSchedules[account].push([time, quantity]);
1949     }
1950 
1951     /**
1952      * @notice Construct a vesting schedule to release a quantities of havvens
1953      * over a series of intervals.
1954      * @dev Assumes that the quantities are nonzero
1955      * and that the sequence of timestamps is strictly increasing.
1956      * This may only be called by the owner during the contract's setup period.
1957      */
1958     function addVestingSchedule(address account, uint[] times, uint[] quantities)
1959         external
1960         onlyOwner
1961         onlyDuringSetup
1962     {
1963         for (uint i = 0; i < times.length; i++) {
1964             appendVestingEntry(account, times[i], quantities[i]);
1965         }
1966 
1967     }
1968 
1969     /**
1970      * @notice Allow a user to withdraw any havvens in their schedule that have vested.
1971      */
1972     function vest()
1973         external
1974     {
1975         uint numEntries = numVestingEntries(msg.sender);
1976         uint total;
1977         for (uint i = 0; i < numEntries; i++) {
1978             uint time = getVestingTime(msg.sender, i);
1979             /* The list is sorted; when we reach the first future time, bail out. */
1980             if (time > now) {
1981                 break;
1982             }
1983             uint qty = getVestingQuantity(msg.sender, i);
1984             if (qty == 0) {
1985                 continue;
1986             }
1987 
1988             vestingSchedules[msg.sender][i] = [0, 0];
1989             total = safeAdd(total, qty);
1990         }
1991 
1992         if (total != 0) {
1993             totalVestedBalance = safeSub(totalVestedBalance, total);
1994             totalVestedAccountBalance[msg.sender] = safeSub(totalVestedAccountBalance[msg.sender], total);
1995             havven.transfer(msg.sender, total);
1996             emit Vested(msg.sender, now, total);
1997         }
1998     }
1999 
2000 
2001     /* ========== EVENTS ========== */
2002 
2003     event HavvenUpdated(address newHavven);
2004 
2005     event Vested(address indexed beneficiary, uint time, uint value);
2006 }
2007 
2008 
2009 /*
2010 -----------------------------------------------------------------
2011 FILE INFORMATION
2012 -----------------------------------------------------------------
2013 
2014 file:       Havven.sol
2015 version:    1.2
2016 author:     Anton Jurisevic
2017             Dominic Romanowski
2018 
2019 date:       2018-05-15
2020 
2021 -----------------------------------------------------------------
2022 MODULE DESCRIPTION
2023 -----------------------------------------------------------------
2024 
2025 Havven token contract. Havvens are transferable ERC20 tokens,
2026 and also give their holders the following privileges.
2027 An owner of havvens may participate in nomin confiscation votes, they
2028 may also have the right to issue nomins at the discretion of the
2029 foundation for this version of the contract.
2030 
2031 After a fee period terminates, the duration and fees collected for that
2032 period are computed, and the next period begins. Thus an account may only
2033 withdraw the fees owed to them for the previous period, and may only do
2034 so once per period. Any unclaimed fees roll over into the common pot for
2035 the next period.
2036 
2037 == Average Balance Calculations ==
2038 
2039 The fee entitlement of a havven holder is proportional to their average
2040 issued nomin balance over the last fee period. This is computed by
2041 measuring the area under the graph of a user's issued nomin balance over
2042 time, and then when a new fee period begins, dividing through by the
2043 duration of the fee period.
2044 
2045 We need only update values when the balances of an account is modified.
2046 This occurs when issuing or burning for issued nomin balances,
2047 and when transferring for havven balances. This is for efficiency,
2048 and adds an implicit friction to interacting with havvens.
2049 A havven holder pays for his own recomputation whenever he wants to change
2050 his position, which saves the foundation having to maintain a pot dedicated
2051 to resourcing this.
2052 
2053 A hypothetical user's balance history over one fee period, pictorially:
2054 
2055       s ____
2056        |    |
2057        |    |___ p
2058        |____|___|___ __ _  _
2059        f    t   n
2060 
2061 Here, the balance was s between times f and t, at which time a transfer
2062 occurred, updating the balance to p, until n, when the present transfer occurs.
2063 When a new transfer occurs at time n, the balance being p,
2064 we must:
2065 
2066   - Add the area p * (n - t) to the total area recorded so far
2067   - Update the last transfer time to n
2068 
2069 So if this graph represents the entire current fee period,
2070 the average havvens held so far is ((t-f)*s + (n-t)*p) / (n-f).
2071 The complementary computations must be performed for both sender and
2072 recipient.
2073 
2074 Note that a transfer keeps global supply of havvens invariant.
2075 The sum of all balances is constant, and unmodified by any transfer.
2076 So the sum of all balances multiplied by the duration of a fee period is also
2077 constant, and this is equivalent to the sum of the area of every user's
2078 time/balance graph. Dividing through by that duration yields back the total
2079 havven supply. So, at the end of a fee period, we really do yield a user's
2080 average share in the havven supply over that period.
2081 
2082 A slight wrinkle is introduced if we consider the time r when the fee period
2083 rolls over. Then the previous fee period k-1 is before r, and the current fee
2084 period k is afterwards. If the last transfer took place before r,
2085 but the latest transfer occurred afterwards:
2086 
2087 k-1       |        k
2088       s __|_
2089        |  | |
2090        |  | |____ p
2091        |__|_|____|___ __ _  _
2092           |
2093        f  | t    n
2094           r
2095 
2096 In this situation the area (r-f)*s contributes to fee period k-1, while
2097 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2098 zero-value transfer to have occurred at time r. Their fee entitlement for the
2099 previous period will be finalised at the time of their first transfer during the
2100 current fee period, or when they query or withdraw their fee entitlement.
2101 
2102 In the implementation, the duration of different fee periods may be slightly irregular,
2103 as the check that they have rolled over occurs only when state-changing havven
2104 operations are performed.
2105 
2106 == Issuance and Burning ==
2107 
2108 In this version of the havven contract, nomins can only be issued by
2109 those that have been nominated by the havven foundation. Nomins are assumed
2110 to be valued at $1, as they are a stable unit of account.
2111 
2112 All nomins issued require a proportional value of havvens to be locked,
2113 where the proportion is governed by the current issuance ratio. This
2114 means for every $1 of Havvens locked up, $(issuanceRatio) nomins can be issued.
2115 i.e. to issue 100 nomins, 100/issuanceRatio dollars of havvens need to be locked up.
2116 
2117 To determine the value of some amount of havvens(H), an oracle is used to push
2118 the price of havvens (P_H) in dollars to the contract. The value of H
2119 would then be: H * P_H.
2120 
2121 Any havvens that are locked up by this issuance process cannot be transferred.
2122 The amount that is locked floats based on the price of havvens. If the price
2123 of havvens moves up, less havvens are locked, so they can be issued against,
2124 or transferred freely. If the price of havvens moves down, more havvens are locked,
2125 even going above the initial wallet balance.
2126 
2127 -----------------------------------------------------------------
2128 */
2129 
2130 
2131 /**
2132  * @title Havven ERC20 contract.
2133  * @notice The Havven contracts does not only facilitate transfers and track balances,
2134  * but it also computes the quantity of fees each havven holder is entitled to.
2135  */
2136 contract Havven is ExternStateToken {
2137 
2138     /* ========== STATE VARIABLES ========== */
2139 
2140     /* A struct for handing values associated with average balance calculations */
2141     struct IssuanceData {
2142         /* Sums of balances*duration in the current fee period.
2143         /* range: decimals; units: havven-seconds */
2144         uint currentBalanceSum;
2145         /* The last period's average balance */
2146         uint lastAverageBalance;
2147         /* The last time the data was calculated */
2148         uint lastModified;
2149     }
2150 
2151     /* Issued nomin balances for individual fee entitlements */
2152     mapping(address => IssuanceData) public issuanceData;
2153     /* The total number of issued nomins for determining fee entitlements */
2154     IssuanceData public totalIssuanceData;
2155 
2156     /* The time the current fee period began */
2157     uint public feePeriodStartTime;
2158     /* The time the last fee period began */
2159     uint public lastFeePeriodStartTime;
2160 
2161     /* Fee periods will roll over in no shorter a time than this. 
2162      * The fee period cannot actually roll over until a fee-relevant
2163      * operation such as withdrawal or a fee period duration update occurs,
2164      * so this is just a target, and the actual duration may be slightly longer. */
2165     uint public feePeriodDuration = 4 weeks;
2166     /* ...and must target between 1 day and six months. */
2167     uint constant MIN_FEE_PERIOD_DURATION = 1 days;
2168     uint constant MAX_FEE_PERIOD_DURATION = 26 weeks;
2169 
2170     /* The quantity of nomins that were in the fee pot at the time */
2171     /* of the last fee rollover, at feePeriodStartTime. */
2172     uint public lastFeesCollected;
2173 
2174     /* Whether a user has withdrawn their last fees */
2175     mapping(address => bool) public hasWithdrawnFees;
2176 
2177     Nomin public nomin;
2178     HavvenEscrow public escrow;
2179 
2180     /* The address of the oracle which pushes the havven price to this contract */
2181     address public oracle;
2182     /* The price of havvens written in UNIT */
2183     uint public price;
2184     /* The time the havven price was last updated */
2185     uint public lastPriceUpdateTime;
2186     /* How long will the contract assume the price of havvens is correct */
2187     uint public priceStalePeriod = 3 hours;
2188 
2189     /* A quantity of nomins greater than this ratio
2190      * may not be issued against a given value of havvens. */
2191     uint public issuanceRatio = UNIT / 5;
2192     /* No more nomins may be issued than the value of havvens backing them. */
2193     uint constant MAX_ISSUANCE_RATIO = UNIT;
2194 
2195     /* Whether the address can issue nomins or not. */
2196     mapping(address => bool) public isIssuer;
2197     /* The number of currently-outstanding nomins the user has issued. */
2198     mapping(address => uint) public nominsIssued;
2199 
2200     uint constant HAVVEN_SUPPLY = 1e8 * UNIT;
2201     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
2202     string constant TOKEN_NAME = "Havven";
2203     string constant TOKEN_SYMBOL = "HAV";
2204     
2205     /* ========== CONSTRUCTOR ========== */
2206 
2207     /**
2208      * @dev Constructor
2209      * @param _tokenState A pre-populated contract containing token balances.
2210      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2211      * @param _owner The owner of this contract.
2212      */
2213     constructor(address _proxy, TokenState _tokenState, address _owner, address _oracle,
2214                 uint _price, address[] _issuers, Havven _oldHavven)
2215         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, HAVVEN_SUPPLY, _owner)
2216         public
2217     {
2218         oracle = _oracle;
2219         price = _price;
2220         lastPriceUpdateTime = now;
2221 
2222         uint i;
2223         if (_oldHavven == address(0)) {
2224             feePeriodStartTime = now;
2225             lastFeePeriodStartTime = now - feePeriodDuration;
2226             for (i = 0; i < _issuers.length; i++) {
2227                 isIssuer[_issuers[i]] = true;
2228             }
2229         } else {
2230             feePeriodStartTime = _oldHavven.feePeriodStartTime();
2231             lastFeePeriodStartTime = _oldHavven.lastFeePeriodStartTime();
2232 
2233             uint cbs;
2234             uint lab;
2235             uint lm;
2236             (cbs, lab, lm) = _oldHavven.totalIssuanceData();
2237             totalIssuanceData.currentBalanceSum = cbs;
2238             totalIssuanceData.lastAverageBalance = lab;
2239             totalIssuanceData.lastModified = lm;
2240 
2241             for (i = 0; i < _issuers.length; i++) {
2242                 address issuer = _issuers[i];
2243                 isIssuer[issuer] = true;
2244                 uint nomins = _oldHavven.nominsIssued(issuer);
2245                 if (nomins == 0) {
2246                     // It is not valid in general to skip those with no currently-issued nomins.
2247                     // But for this release, issuers with nonzero issuanceData have current issuance.
2248                     continue;
2249                 }
2250                 (cbs, lab, lm) = _oldHavven.issuanceData(issuer);
2251                 nominsIssued[issuer] = nomins;
2252                 issuanceData[issuer].currentBalanceSum = cbs;
2253                 issuanceData[issuer].lastAverageBalance = lab;
2254                 issuanceData[issuer].lastModified = lm;
2255             }
2256         }
2257 
2258     }
2259 
2260     /* ========== SETTERS ========== */
2261 
2262     /**
2263      * @notice Set the associated Nomin contract to collect fees from.
2264      * @dev Only the contract owner may call this.
2265      */
2266     function setNomin(Nomin _nomin)
2267         external
2268         optionalProxy_onlyOwner
2269     {
2270         nomin = _nomin;
2271         emitNominUpdated(_nomin);
2272     }
2273 
2274     /**
2275      * @notice Set the associated havven escrow contract.
2276      * @dev Only the contract owner may call this.
2277      */
2278     function setEscrow(HavvenEscrow _escrow)
2279         external
2280         optionalProxy_onlyOwner
2281     {
2282         escrow = _escrow;
2283         emitEscrowUpdated(_escrow);
2284     }
2285 
2286     /**
2287      * @notice Set the targeted fee period duration.
2288      * @dev Only callable by the contract owner. The duration must fall within
2289      * acceptable bounds (1 day to 26 weeks). Upon resetting this the fee period
2290      * may roll over if the target duration was shortened sufficiently.
2291      */
2292     function setFeePeriodDuration(uint duration)
2293         external
2294         optionalProxy_onlyOwner
2295     {
2296         require(MIN_FEE_PERIOD_DURATION <= duration && duration <= MAX_FEE_PERIOD_DURATION,
2297             "Duration must be between MIN_FEE_PERIOD_DURATION and MAX_FEE_PERIOD_DURATION");
2298         feePeriodDuration = duration;
2299         emitFeePeriodDurationUpdated(duration);
2300         rolloverFeePeriodIfElapsed();
2301     }
2302 
2303     /**
2304      * @notice Set the Oracle that pushes the havven price to this contract
2305      */
2306     function setOracle(address _oracle)
2307         external
2308         optionalProxy_onlyOwner
2309     {
2310         oracle = _oracle;
2311         emitOracleUpdated(_oracle);
2312     }
2313 
2314     /**
2315      * @notice Set the stale period on the updated havven price
2316      * @dev No max/minimum, as changing it wont influence anything but issuance by the foundation
2317      */
2318     function setPriceStalePeriod(uint time)
2319         external
2320         optionalProxy_onlyOwner
2321     {
2322         priceStalePeriod = time;
2323     }
2324 
2325     /**
2326      * @notice Set the issuanceRatio for issuance calculations.
2327      * @dev Only callable by the contract owner.
2328      */
2329     function setIssuanceRatio(uint _issuanceRatio)
2330         external
2331         optionalProxy_onlyOwner
2332     {
2333         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio must be less than or equal to MAX_ISSUANCE_RATIO");
2334         issuanceRatio = _issuanceRatio;
2335         emitIssuanceRatioUpdated(_issuanceRatio);
2336     }
2337 
2338     /**
2339      * @notice Set whether the specified can issue nomins or not.
2340      */
2341     function setIssuer(address account, bool value)
2342         external
2343         optionalProxy_onlyOwner
2344     {
2345         isIssuer[account] = value;
2346         emitIssuersUpdated(account, value);
2347     }
2348 
2349     /* ========== VIEWS ========== */
2350 
2351     function issuanceCurrentBalanceSum(address account)
2352         external
2353         view
2354         returns (uint)
2355     {
2356         return issuanceData[account].currentBalanceSum;
2357     }
2358 
2359     function issuanceLastAverageBalance(address account)
2360         external
2361         view
2362         returns (uint)
2363     {
2364         return issuanceData[account].lastAverageBalance;
2365     }
2366 
2367     function issuanceLastModified(address account)
2368         external
2369         view
2370         returns (uint)
2371     {
2372         return issuanceData[account].lastModified;
2373     }
2374 
2375     function totalIssuanceCurrentBalanceSum()
2376         external
2377         view
2378         returns (uint)
2379     {
2380         return totalIssuanceData.currentBalanceSum;
2381     }
2382 
2383     function totalIssuanceLastAverageBalance()
2384         external
2385         view
2386         returns (uint)
2387     {
2388         return totalIssuanceData.lastAverageBalance;
2389     }
2390 
2391     function totalIssuanceLastModified()
2392         external
2393         view
2394         returns (uint)
2395     {
2396         return totalIssuanceData.lastModified;
2397     }
2398 
2399     /* ========== MUTATIVE FUNCTIONS ========== */
2400 
2401     /**
2402      * @notice ERC20 transfer function.
2403      */
2404     function transfer(address to, uint value)
2405         public
2406         optionalProxy
2407         returns (bool)
2408     {
2409         address sender = messageSender;
2410         require(nominsIssued[sender] == 0 || value <= transferableHavvens(sender), "Value to transfer exceeds available havvens");
2411         /* Perform the transfer: if there is a problem,
2412          * an exception will be thrown in this call. */
2413         _transfer_byProxy(sender, to, value);
2414 
2415         return true;
2416     }
2417 
2418     /**
2419      * @notice ERC20 transferFrom function.
2420      */
2421     function transferFrom(address from, address to, uint value)
2422         public
2423         optionalProxy
2424         returns (bool)
2425     {
2426         address sender = messageSender;
2427         require(nominsIssued[from] == 0 || value <= transferableHavvens(from), "Value to transfer exceeds available havvens");
2428         /* Perform the transfer: if there is a problem,
2429          * an exception will be thrown in this call. */
2430         _transferFrom_byProxy(sender, from, to, value);
2431 
2432         return true;
2433     }
2434 
2435     /**
2436      * @notice Compute the last period's fee entitlement for the message sender
2437      * and then deposit it into their nomin account.
2438      */
2439     function withdrawFees()
2440         external
2441         optionalProxy
2442     {
2443         address sender = messageSender;
2444         rolloverFeePeriodIfElapsed();
2445         /* Do not deposit fees into frozen accounts. */
2446         require(!nomin.frozen(sender), "Cannot deposit fees into frozen accounts");
2447 
2448         /* Check the period has rolled over first. */
2449         updateIssuanceData(sender, nominsIssued[sender], nomin.totalSupply());
2450 
2451         /* Only allow accounts to withdraw fees once per period. */
2452         require(!hasWithdrawnFees[sender], "Fees have already been withdrawn in this period");
2453 
2454         uint feesOwed;
2455         uint lastTotalIssued = totalIssuanceData.lastAverageBalance;
2456 
2457         if (lastTotalIssued > 0) {
2458             /* Sender receives a share of last period's collected fees proportional
2459              * with their average fraction of the last period's issued nomins. */
2460             feesOwed = safeDiv_dec(
2461                 safeMul_dec(issuanceData[sender].lastAverageBalance, lastFeesCollected),
2462                 lastTotalIssued
2463             );
2464         }
2465 
2466         hasWithdrawnFees[sender] = true;
2467 
2468         if (feesOwed != 0) {
2469             nomin.withdrawFees(sender, feesOwed);
2470         }
2471         emitFeesWithdrawn(messageSender, feesOwed);
2472     }
2473 
2474     /**
2475      * @notice Update the havven balance averages since the last transfer
2476      * or entitlement adjustment.
2477      * @dev Since this updates the last transfer timestamp, if invoked
2478      * consecutively, this function will do nothing after the first call.
2479      * Also, this will adjust the total issuance at the same time.
2480      */
2481     function updateIssuanceData(address account, uint preBalance, uint lastTotalSupply)
2482         internal
2483     {
2484         /* update the total balances first */
2485         totalIssuanceData = computeIssuanceData(lastTotalSupply, totalIssuanceData);
2486 
2487         if (issuanceData[account].lastModified < feePeriodStartTime) {
2488             hasWithdrawnFees[account] = false;
2489         }
2490 
2491         issuanceData[account] = computeIssuanceData(preBalance, issuanceData[account]);
2492     }
2493 
2494 
2495     /**
2496      * @notice Compute the new IssuanceData on the old balance
2497      */
2498     function computeIssuanceData(uint preBalance, IssuanceData preIssuance)
2499         internal
2500         view
2501         returns (IssuanceData)
2502     {
2503 
2504         uint currentBalanceSum = preIssuance.currentBalanceSum;
2505         uint lastAverageBalance = preIssuance.lastAverageBalance;
2506         uint lastModified = preIssuance.lastModified;
2507 
2508         if (lastModified < feePeriodStartTime) {
2509             if (lastModified < lastFeePeriodStartTime) {
2510                 /* The balance was last updated before the previous fee period, so the average
2511                  * balance in this period is their pre-transfer balance. */
2512                 lastAverageBalance = preBalance;
2513             } else {
2514                 /* The balance was last updated during the previous fee period. */
2515                 /* No overflow or zero denominator problems, since lastFeePeriodStartTime < feePeriodStartTime < lastModified. 
2516                  * implies these quantities are strictly positive. */
2517                 uint timeUpToRollover = feePeriodStartTime - lastModified;
2518                 uint lastFeePeriodDuration = feePeriodStartTime - lastFeePeriodStartTime;
2519                 uint lastBalanceSum = safeAdd(currentBalanceSum, safeMul(preBalance, timeUpToRollover));
2520                 lastAverageBalance = lastBalanceSum / lastFeePeriodDuration;
2521             }
2522             /* Roll over to the next fee period. */
2523             currentBalanceSum = safeMul(preBalance, now - feePeriodStartTime);
2524         } else {
2525             /* The balance was last updated during the current fee period. */
2526             currentBalanceSum = safeAdd(
2527                 currentBalanceSum,
2528                 safeMul(preBalance, now - lastModified)
2529             );
2530         }
2531 
2532         return IssuanceData(currentBalanceSum, lastAverageBalance, now);
2533     }
2534 
2535     /**
2536      * @notice Recompute and return the given account's last average balance.
2537      */
2538     function recomputeLastAverageBalance(address account)
2539         external
2540         returns (uint)
2541     {
2542         updateIssuanceData(account, nominsIssued[account], nomin.totalSupply());
2543         return issuanceData[account].lastAverageBalance;
2544     }
2545 
2546     /**
2547      * @notice Issue nomins against the sender's havvens.
2548      * @dev Issuance is only allowed if the havven price isn't stale and the sender is an issuer.
2549      */
2550     function issueNomins(uint amount)
2551         public
2552         optionalProxy
2553         requireIssuer(messageSender)
2554         /* No need to check if price is stale, as it is checked in issuableNomins. */
2555     {
2556         address sender = messageSender;
2557         require(amount <= remainingIssuableNomins(sender), "Amount must be less than or equal to remaining issuable nomins");
2558         uint lastTot = nomin.totalSupply();
2559         uint preIssued = nominsIssued[sender];
2560         nomin.issue(sender, amount);
2561         nominsIssued[sender] = safeAdd(preIssued, amount);
2562         updateIssuanceData(sender, preIssued, lastTot);
2563     }
2564 
2565     function issueMaxNomins()
2566         external
2567         optionalProxy
2568     {
2569         issueNomins(remainingIssuableNomins(messageSender));
2570     }
2571 
2572     /**
2573      * @notice Burn nomins to clear issued nomins/free havvens.
2574      */
2575     function burnNomins(uint amount)
2576         /* it doesn't matter if the price is stale or if the user is an issuer, as non-issuers have issued no nomins.*/
2577         external
2578         optionalProxy
2579     {
2580         address sender = messageSender;
2581 
2582         uint lastTot = nomin.totalSupply();
2583         uint preIssued = nominsIssued[sender];
2584         /* nomin.burn does a safeSub on balance (so it will revert if there are not enough nomins). */
2585         nomin.burn(sender, amount);
2586         /* This safe sub ensures amount <= number issued */
2587         nominsIssued[sender] = safeSub(preIssued, amount);
2588         updateIssuanceData(sender, preIssued, lastTot);
2589     }
2590 
2591     /**
2592      * @notice Check if the fee period has rolled over. If it has, set the new fee period start
2593      * time, and record the fees collected in the nomin contract.
2594      */
2595     function rolloverFeePeriodIfElapsed()
2596         public
2597     {
2598         /* If the fee period has rolled over... */
2599         if (now >= feePeriodStartTime + feePeriodDuration) {
2600             lastFeesCollected = nomin.feePool();
2601             lastFeePeriodStartTime = feePeriodStartTime;
2602             feePeriodStartTime = now;
2603             emitFeePeriodRollover(now);
2604         }
2605     }
2606 
2607     /* ========== Issuance/Burning ========== */
2608 
2609     /**
2610      * @notice The maximum nomins an issuer can issue against their total havven quantity. This ignores any
2611      * already issued nomins.
2612      */
2613     function maxIssuableNomins(address issuer)
2614         view
2615         public
2616         priceNotStale
2617         returns (uint)
2618     {
2619         if (!isIssuer[issuer]) {
2620             return 0;
2621         }
2622         if (escrow != HavvenEscrow(0)) {
2623             uint totalOwnedHavvens = safeAdd(tokenState.balanceOf(issuer), escrow.balanceOf(issuer));
2624             return safeMul_dec(HAVtoUSD(totalOwnedHavvens), issuanceRatio);
2625         } else {
2626             return safeMul_dec(HAVtoUSD(tokenState.balanceOf(issuer)), issuanceRatio);
2627         }
2628     }
2629 
2630     /**
2631      * @notice The remaining nomins an issuer can issue against their total havven quantity.
2632      */
2633     function remainingIssuableNomins(address issuer)
2634         view
2635         public
2636         returns (uint)
2637     {
2638         uint issued = nominsIssued[issuer];
2639         uint max = maxIssuableNomins(issuer);
2640         if (issued > max) {
2641             return 0;
2642         } else {
2643             return safeSub(max, issued);
2644         }
2645     }
2646 
2647     /**
2648      * @notice The total havvens owned by this account, both escrowed and unescrowed,
2649      * against which nomins can be issued.
2650      * This includes those already being used as collateral (locked), and those
2651      * available for further issuance (unlocked).
2652      */
2653     function collateral(address account)
2654         public
2655         view
2656         returns (uint)
2657     {
2658         uint bal = tokenState.balanceOf(account);
2659         if (escrow != address(0)) {
2660             bal = safeAdd(bal, escrow.balanceOf(account));
2661         }
2662         return bal;
2663     }
2664 
2665     /**
2666      * @notice The collateral that would be locked by issuance, which can exceed the account's actual collateral.
2667      */
2668     function issuanceDraft(address account)
2669         public
2670         view
2671         returns (uint)
2672     {
2673         uint issued = nominsIssued[account];
2674         if (issued == 0) {
2675             return 0;
2676         }
2677         return USDtoHAV(safeDiv_dec(issued, issuanceRatio));
2678     }
2679 
2680     /**
2681      * @notice Collateral that has been locked due to issuance, and cannot be
2682      * transferred to other addresses. This is capped at the account's total collateral.
2683      */
2684     function lockedCollateral(address account)
2685         public
2686         view
2687         returns (uint)
2688     {
2689         uint debt = issuanceDraft(account);
2690         uint collat = collateral(account);
2691         if (debt > collat) {
2692             return collat;
2693         }
2694         return debt;
2695     }
2696 
2697     /**
2698      * @notice Collateral that is not locked and available for issuance.
2699      */
2700     function unlockedCollateral(address account)
2701         public
2702         view
2703         returns (uint)
2704     {
2705         uint locked = lockedCollateral(account);
2706         uint collat = collateral(account);
2707         return safeSub(collat, locked);
2708     }
2709 
2710     /**
2711      * @notice The number of havvens that are free to be transferred by an account.
2712      * @dev If they have enough available Havvens, it could be that
2713      * their havvens are escrowed, however the transfer would then
2714      * fail. This means that escrowed havvens are locked first,
2715      * and then the actual transferable ones.
2716      */
2717     function transferableHavvens(address account)
2718         public
2719         view
2720         returns (uint)
2721     {
2722         uint draft = issuanceDraft(account);
2723         uint collat = collateral(account);
2724         // In the case where the issuanceDraft exceeds the collateral, nothing is free
2725         if (draft > collat) {
2726             return 0;
2727         }
2728 
2729         uint bal = balanceOf(account);
2730         // In the case where the draft exceeds the escrow, but not the whole collateral
2731         //   return the fraction of the balance that remains free
2732         if (draft > safeSub(collat, bal)) {
2733             return safeSub(collat, draft);
2734         }
2735         // In the case where the draft doesn't exceed the escrow, return the entire balance
2736         return bal;
2737     }
2738 
2739     /**
2740      * @notice The value in USD for a given amount of HAV
2741      */
2742     function HAVtoUSD(uint hav_dec)
2743         public
2744         view
2745         priceNotStale
2746         returns (uint)
2747     {
2748         return safeMul_dec(hav_dec, price);
2749     }
2750 
2751     /**
2752      * @notice The value in HAV for a given amount of USD
2753      */
2754     function USDtoHAV(uint usd_dec)
2755         public
2756         view
2757         priceNotStale
2758         returns (uint)
2759     {
2760         return safeDiv_dec(usd_dec, price);
2761     }
2762 
2763     /**
2764      * @notice Access point for the oracle to update the price of havvens.
2765      */
2766     function updatePrice(uint newPrice, uint timeSent)
2767         external
2768         onlyOracle  /* Should be callable only by the oracle. */
2769     {
2770         /* Must be the most recently sent price, but not too far in the future.
2771          * (so we can't lock ourselves out of updating the oracle for longer than this) */
2772         require(lastPriceUpdateTime < timeSent && timeSent < now + ORACLE_FUTURE_LIMIT,
2773             "Time sent must be bigger than the last update, and must be less than now + ORACLE_FUTURE_LIMIT");
2774 
2775         price = newPrice;
2776         lastPriceUpdateTime = timeSent;
2777         emitPriceUpdated(newPrice, timeSent);
2778 
2779         /* Check the fee period rollover within this as the price should be pushed every 15min. */
2780         rolloverFeePeriodIfElapsed();
2781     }
2782 
2783     /**
2784      * @notice Check if the price of havvens hasn't been updated for longer than the stale period.
2785      */
2786     function priceIsStale()
2787         public
2788         view
2789         returns (bool)
2790     {
2791         return safeAdd(lastPriceUpdateTime, priceStalePeriod) < now;
2792     }
2793 
2794     /* ========== MODIFIERS ========== */
2795 
2796     modifier requireIssuer(address account)
2797     {
2798         require(isIssuer[account], "Must be issuer to perform this action");
2799         _;
2800     }
2801 
2802     modifier onlyOracle
2803     {
2804         require(msg.sender == oracle, "Must be oracle to perform this action");
2805         _;
2806     }
2807 
2808     modifier priceNotStale
2809     {
2810         require(!priceIsStale(), "Price must not be stale to perform this action");
2811         _;
2812     }
2813 
2814     /* ========== EVENTS ========== */
2815 
2816     event PriceUpdated(uint newPrice, uint timestamp);
2817     bytes32 constant PRICEUPDATED_SIG = keccak256("PriceUpdated(uint256,uint256)");
2818     function emitPriceUpdated(uint newPrice, uint timestamp) internal {
2819         proxy._emit(abi.encode(newPrice, timestamp), 1, PRICEUPDATED_SIG, 0, 0, 0);
2820     }
2821 
2822     event IssuanceRatioUpdated(uint newRatio);
2823     bytes32 constant ISSUANCERATIOUPDATED_SIG = keccak256("IssuanceRatioUpdated(uint256)");
2824     function emitIssuanceRatioUpdated(uint newRatio) internal {
2825         proxy._emit(abi.encode(newRatio), 1, ISSUANCERATIOUPDATED_SIG, 0, 0, 0);
2826     }
2827 
2828     event FeePeriodRollover(uint timestamp);
2829     bytes32 constant FEEPERIODROLLOVER_SIG = keccak256("FeePeriodRollover(uint256)");
2830     function emitFeePeriodRollover(uint timestamp) internal {
2831         proxy._emit(abi.encode(timestamp), 1, FEEPERIODROLLOVER_SIG, 0, 0, 0);
2832     } 
2833 
2834     event FeePeriodDurationUpdated(uint duration);
2835     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
2836     function emitFeePeriodDurationUpdated(uint duration) internal {
2837         proxy._emit(abi.encode(duration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
2838     } 
2839 
2840     event FeesWithdrawn(address indexed account, uint value);
2841     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
2842     function emitFeesWithdrawn(address account, uint value) internal {
2843         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
2844     }
2845 
2846     event OracleUpdated(address newOracle);
2847     bytes32 constant ORACLEUPDATED_SIG = keccak256("OracleUpdated(address)");
2848     function emitOracleUpdated(address newOracle) internal {
2849         proxy._emit(abi.encode(newOracle), 1, ORACLEUPDATED_SIG, 0, 0, 0);
2850     }
2851 
2852     event NominUpdated(address newNomin);
2853     bytes32 constant NOMINUPDATED_SIG = keccak256("NominUpdated(address)");
2854     function emitNominUpdated(address newNomin) internal {
2855         proxy._emit(abi.encode(newNomin), 1, NOMINUPDATED_SIG, 0, 0, 0);
2856     }
2857 
2858     event EscrowUpdated(address newEscrow);
2859     bytes32 constant ESCROWUPDATED_SIG = keccak256("EscrowUpdated(address)");
2860     function emitEscrowUpdated(address newEscrow) internal {
2861         proxy._emit(abi.encode(newEscrow), 1, ESCROWUPDATED_SIG, 0, 0, 0);
2862     }
2863 
2864     event IssuersUpdated(address indexed account, bool indexed value);
2865     bytes32 constant ISSUERSUPDATED_SIG = keccak256("IssuersUpdated(address,bool)");
2866     function emitIssuersUpdated(address account, bool value) internal {
2867         proxy._emit(abi.encode(), 3, ISSUERSUPDATED_SIG, bytes32(account), bytes32(value ? 1 : 0), 0);
2868     }
2869 
2870 }
2871 
2872 
2873 /*
2874 -----------------------------------------------------------------
2875 FILE INFORMATION -----------------------------------------------------------------
2876 
2877 file:       IssuanceController.sol
2878 version:    2.0
2879 author:     Kevin Brown
2880 
2881 date:       2018-07-18
2882 
2883 -----------------------------------------------------------------
2884 MODULE DESCRIPTION
2885 -----------------------------------------------------------------
2886 
2887 Issuance controller contract. The issuance controller provides
2888 a way for users to acquire nomins (Nomin.sol) and havvens
2889 (Havven.sol) by paying ETH and a way for users to acquire havvens
2890 (Havven.sol) by paying nomins. Users can also deposit their nomins
2891 and allow other users to purchase them with ETH. The ETH is sent
2892 to the user who offered their nomins for sale.
2893 
2894 This smart contract contains a balance of each currency, and
2895 allows the owner of the contract (the Havven Foundation) to
2896 manage the available balance of havven at their discretion, while
2897 users are allowed to deposit and withdraw their own nomin deposits
2898 if they have not yet been taken up by another user.
2899 
2900 -----------------------------------------------------------------
2901 */
2902 
2903 
2904 /**
2905  * @title Issuance Controller Contract.
2906  */
2907 contract IssuanceController is SafeDecimalMath, SelfDestructible, Pausable {
2908 
2909     /* ========== STATE VARIABLES ========== */
2910     Havven public havven;
2911     Nomin public nomin;
2912 
2913     // Address where the ether raised is transfered to
2914     address public fundsWallet;
2915 
2916     /* The address of the oracle which pushes the USD price havvens and ether to this contract */
2917     address public oracle;
2918     /* Do not allow the oracle to submit times any further forward into the future than
2919        this constant. */
2920     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
2921 
2922     /* How long will the contract assume the price of any asset is correct */
2923     uint public priceStalePeriod = 3 hours;
2924 
2925     /* The time the prices were last updated */
2926     uint public lastPriceUpdateTime;
2927     /* The USD price of havvens denominated in UNIT */
2928     uint public usdToHavPrice;
2929     /* The USD price of ETH denominated in UNIT */
2930     uint public usdToEthPrice;
2931     
2932     /* ========== CONSTRUCTOR ========== */
2933 
2934     /**
2935      * @dev Constructor
2936      * @param _owner The owner of this contract.
2937      * @param _fundsWallet The recipient of ETH and Nomins that are sent to this contract while exchanging.
2938      * @param _havven The Havven contract we'll interact with for balances and sending.
2939      * @param _nomin The Nomin contract we'll interact with for balances and sending.
2940      * @param _oracle The address which is able to update price information.
2941      * @param _usdToEthPrice The current price of ETH in USD, expressed in UNIT.
2942      * @param _usdToHavPrice The current price of Havven in USD, expressed in UNIT.
2943      */
2944     constructor(
2945         // Ownable
2946         address _owner,
2947 
2948         // Funds Wallet
2949         address _fundsWallet,
2950 
2951         // Other contracts needed
2952         Havven _havven,
2953         Nomin _nomin,
2954 
2955         // Oracle values - Allows for price updates
2956         address _oracle,
2957         uint _usdToEthPrice,
2958         uint _usdToHavPrice
2959     )
2960         /* Owned is initialised in SelfDestructible */
2961         SelfDestructible(_owner)
2962         Pausable(_owner)
2963         public
2964     {
2965         fundsWallet = _fundsWallet;
2966         havven = _havven;
2967         nomin = _nomin;
2968         oracle = _oracle;
2969         usdToEthPrice = _usdToEthPrice;
2970         usdToHavPrice = _usdToHavPrice;
2971         lastPriceUpdateTime = now;
2972     }
2973 
2974     /* ========== SETTERS ========== */
2975 
2976     /**
2977      * @notice Set the funds wallet where ETH raised is held
2978      * @param _fundsWallet The new address to forward ETH and Nomins to
2979      */
2980     function setFundsWallet(address _fundsWallet)
2981         external
2982         onlyOwner
2983     {
2984         fundsWallet = _fundsWallet;
2985         emit FundsWalletUpdated(fundsWallet);
2986     }
2987     
2988     /**
2989      * @notice Set the Oracle that pushes the havven price to this contract
2990      * @param _oracle The new oracle address
2991      */
2992     function setOracle(address _oracle)
2993         external
2994         onlyOwner
2995     {
2996         oracle = _oracle;
2997         emit OracleUpdated(oracle);
2998     }
2999 
3000     /**
3001      * @notice Set the Nomin contract that the issuance controller uses to issue Nomins.
3002      * @param _nomin The new nomin contract target
3003      */
3004     function setNomin(Nomin _nomin)
3005         external
3006         onlyOwner
3007     {
3008         nomin = _nomin;
3009         emit NominUpdated(_nomin);
3010     }
3011 
3012     /**
3013      * @notice Set the Havven contract that the issuance controller uses to issue Havvens.
3014      * @param _havven The new havven contract target
3015      */
3016     function setHavven(Havven _havven)
3017         external
3018         onlyOwner
3019     {
3020         havven = _havven;
3021         emit HavvenUpdated(_havven);
3022     }
3023 
3024     /**
3025      * @notice Set the stale period on the updated price variables
3026      * @param _time The new priceStalePeriod
3027      */
3028     function setPriceStalePeriod(uint _time)
3029         external
3030         onlyOwner 
3031     {
3032         priceStalePeriod = _time;
3033         emit PriceStalePeriodUpdated(priceStalePeriod);
3034     }
3035 
3036     /* ========== MUTATIVE FUNCTIONS ========== */
3037     /**
3038      * @notice Access point for the oracle to update the prices of havvens / eth.
3039      * @param newEthPrice The current price of ether in USD, specified to 18 decimal places.
3040      * @param newHavvenPrice The current price of havvens in USD, specified to 18 decimal places.
3041      * @param timeSent The timestamp from the oracle when the transaction was created. This ensures we don't consider stale prices as current in times of heavy network congestion.
3042      */
3043     function updatePrices(uint newEthPrice, uint newHavvenPrice, uint timeSent)
3044         external
3045         onlyOracle
3046     {
3047         /* Must be the most recently sent price, but not too far in the future.
3048          * (so we can't lock ourselves out of updating the oracle for longer than this) */
3049         require(lastPriceUpdateTime < timeSent && timeSent < now + ORACLE_FUTURE_LIMIT, 
3050             "Time sent must be bigger than the last update, and must be less than now + ORACLE_FUTURE_LIMIT");
3051 
3052         usdToEthPrice = newEthPrice;
3053         usdToHavPrice = newHavvenPrice;
3054         lastPriceUpdateTime = timeSent;
3055 
3056         emit PricesUpdated(usdToEthPrice, usdToHavPrice, lastPriceUpdateTime);
3057     }
3058 
3059     /**
3060      * @notice Fallback function (exchanges ETH to nUSD)
3061      */
3062     function ()
3063         external
3064         payable
3065     {
3066         exchangeEtherForNomins();
3067     } 
3068 
3069     /**
3070      * @notice Exchange ETH to nUSD.
3071      */
3072     function exchangeEtherForNomins()
3073         public 
3074         payable
3075         pricesNotStale
3076         notPaused
3077         returns (uint) // Returns the number of Nomins (nUSD) received
3078     {
3079         // The multiplication works here because usdToEthPrice is specified in
3080         // 18 decimal places, just like our currency base.
3081         uint requestedToPurchase = safeMul_dec(msg.value, usdToEthPrice);
3082 
3083         // Store the ETH in our funds wallet
3084         fundsWallet.transfer(msg.value);
3085 
3086         // Send the nomins.
3087         // Note: Fees are calculated by the Nomin contract, so when 
3088         //       we request a specific transfer here, the fee is
3089         //       automatically deducted and sent to the fee pool.
3090         nomin.transfer(msg.sender, requestedToPurchase);
3091 
3092         emit Exchange("ETH", msg.value, "nUSD", requestedToPurchase);
3093 
3094         return requestedToPurchase;
3095     }
3096 
3097     /**
3098      * @notice Exchange ETH to nUSD while insisting on a particular rate. This allows a user to
3099      *         exchange while protecting against frontrunning by the contract owner on the exchange rate.
3100      * @param guaranteedRate The exchange rate (ether price) which must be honored or the call will revert.
3101      */
3102     function exchangeEtherForNominsAtRate(uint guaranteedRate)
3103         public
3104         payable
3105         pricesNotStale
3106         notPaused
3107         returns (uint) // Returns the number of Nomins (nUSD) received
3108     {
3109         require(guaranteedRate == usdToEthPrice);
3110 
3111         return exchangeEtherForNomins();
3112     }
3113 
3114 
3115     /**
3116      * @notice Exchange ETH to HAV.
3117      */
3118     function exchangeEtherForHavvens()
3119         public 
3120         payable
3121         pricesNotStale
3122         notPaused
3123         returns (uint) // Returns the number of Havvens (HAV) received
3124     {
3125         // How many Havvens are they going to be receiving?
3126         uint havvensToSend = havvensReceivedForEther(msg.value);
3127 
3128         // Store the ETH in our funds wallet
3129         fundsWallet.transfer(msg.value);
3130 
3131         // And send them the Havvens.
3132         havven.transfer(msg.sender, havvensToSend);
3133 
3134         emit Exchange("ETH", msg.value, "HAV", havvensToSend);
3135 
3136         return havvensToSend;
3137     }
3138 
3139     /**
3140      * @notice Exchange ETH to HAV while insisting on a particular set of rates. This allows a user to
3141      *         exchange while protecting against frontrunning by the contract owner on the exchange rates.
3142      * @param guaranteedEtherRate The ether exchange rate which must be honored or the call will revert.
3143      * @param guaranteedHavvenRate The havven exchange rate which must be honored or the call will revert.
3144      */
3145     function exchangeEtherForHavvensAtRate(uint guaranteedEtherRate, uint guaranteedHavvenRate)
3146         public
3147         payable
3148         pricesNotStale
3149         notPaused
3150         returns (uint) // Returns the number of Havvens (HAV) received
3151     {
3152         require(guaranteedEtherRate == usdToEthPrice);
3153         require(guaranteedHavvenRate == usdToHavPrice);
3154 
3155         return exchangeEtherForHavvens();
3156     }
3157 
3158 
3159     /**
3160      * @notice Exchange nUSD for Havvens
3161      * @param nominAmount The amount of nomins the user wishes to exchange.
3162      */
3163     function exchangeNominsForHavvens(uint nominAmount)
3164         public 
3165         pricesNotStale
3166         notPaused
3167         returns (uint) // Returns the number of Havvens (HAV) received
3168     {
3169         // How many Havvens are they going to be receiving?
3170         uint havvensToSend = havvensReceivedForNomins(nominAmount);
3171         
3172         // Ok, transfer the Nomins to our address.
3173         nomin.transferFrom(msg.sender, this, nominAmount);
3174 
3175         // And send them the Havvens.
3176         havven.transfer(msg.sender, havvensToSend);
3177 
3178         emit Exchange("nUSD", nominAmount, "HAV", havvensToSend);
3179 
3180         return havvensToSend; 
3181     }
3182 
3183     /**
3184      * @notice Exchange nUSD for Havvens while insisting on a particular rate. This allows a user to
3185      *         exchange while protecting against frontrunning by the contract owner on the exchange rate.
3186      * @param nominAmount The amount of nomins the user wishes to exchange.
3187      * @param guaranteedRate A rate (havven price) the caller wishes to insist upon.
3188      */
3189     function exchangeNominsForHavvensAtRate(uint nominAmount, uint guaranteedRate)
3190         public 
3191         pricesNotStale
3192         notPaused
3193         returns (uint) // Returns the number of Havvens (HAV) received
3194     {
3195         require(guaranteedRate == usdToHavPrice);
3196 
3197         return exchangeNominsForHavvens(nominAmount);
3198     }
3199     
3200     /**
3201      * @notice Allows the owner to withdraw havvens from this contract if needed.
3202      * @param amount The amount of havvens to attempt to withdraw (in 18 decimal places).
3203      */
3204     function withdrawHavvens(uint amount)
3205         external
3206         onlyOwner
3207     {
3208         havven.transfer(owner, amount);
3209         
3210         // We don't emit our own events here because we assume that anyone
3211         // who wants to watch what the Issuance Controller is doing can
3212         // just watch ERC20 events from the Nomin and/or Havven contracts
3213         // filtered to our address.
3214     }
3215 
3216     /**
3217      * @notice Withdraw nomins: Allows the owner to withdraw nomins from this contract if needed.
3218      * @param amount The amount of nomins to attempt to withdraw (in 18 decimal places).
3219      */
3220     function withdrawNomins(uint amount)
3221         external
3222         onlyOwner
3223     {
3224         nomin.transfer(owner, amount);
3225         
3226         // We don't emit our own events here because we assume that anyone
3227         // who wants to watch what the Issuance Controller is doing can
3228         // just watch ERC20 events from the Nomin and/or Havven contracts
3229         // filtered to our address.
3230     }
3231 
3232     /* ========== VIEWS ========== */
3233     /**
3234      * @notice Check if the prices haven't been updated for longer than the stale period.
3235      */
3236     function pricesAreStale()
3237         public
3238         view
3239         returns (bool)
3240     {
3241         return safeAdd(lastPriceUpdateTime, priceStalePeriod) < now;
3242     }
3243 
3244     /**
3245      * @notice Calculate how many havvens you will receive if you transfer
3246      *         an amount of nomins.
3247      * @param amount The amount of nomins (in 18 decimal places) you want to ask about
3248      */
3249     function havvensReceivedForNomins(uint amount)
3250         public 
3251         view
3252         returns (uint)
3253     {
3254         // How many nomins would we receive after the transfer fee?
3255         uint nominsReceived = nomin.amountReceived(amount);
3256 
3257         // And what would that be worth in havvens based on the current price?
3258         return safeDiv_dec(nominsReceived, usdToHavPrice);
3259     }
3260 
3261     /**
3262      * @notice Calculate how many havvens you will receive if you transfer
3263      *         an amount of ether.
3264      * @param amount The amount of ether (in wei) you want to ask about
3265      */
3266     function havvensReceivedForEther(uint amount)
3267         public 
3268         view
3269         returns (uint)
3270     {
3271         // How much is the ETH they sent us worth in nUSD (ignoring the transfer fee)?
3272         uint valueSentInNomins = safeMul_dec(amount, usdToEthPrice); 
3273 
3274         // Now, how many HAV will that USD amount buy?
3275         return havvensReceivedForNomins(valueSentInNomins);
3276     }
3277 
3278     /**
3279      * @notice Calculate how many nomins you will receive if you transfer
3280      *         an amount of ether.
3281      * @param amount The amount of ether (in wei) you want to ask about
3282      */
3283     function nominsReceivedForEther(uint amount)
3284         public 
3285         view
3286         returns (uint)
3287     {
3288         // How many nomins would that amount of ether be worth?
3289         uint nominsTransferred = safeMul_dec(amount, usdToEthPrice);
3290 
3291         // And how many of those would you receive after a transfer (deducting the transfer fee)
3292         return nomin.amountReceived(nominsTransferred);
3293     }
3294     
3295     /* ========== MODIFIERS ========== */
3296 
3297     modifier onlyOracle
3298     {
3299         require(msg.sender == oracle, "Must be oracle to perform this action");
3300         _;
3301     }
3302 
3303     modifier pricesNotStale
3304     {
3305         require(!pricesAreStale(), "Prices must not be stale to perform this action");
3306         _;
3307     }
3308 
3309     /* ========== EVENTS ========== */
3310 
3311     event FundsWalletUpdated(address newFundsWallet);
3312     event OracleUpdated(address newOracle);
3313     event NominUpdated(Nomin newNominContract);
3314     event HavvenUpdated(Havven newHavvenContract);
3315     event PriceStalePeriodUpdated(uint priceStalePeriod);
3316     event PricesUpdated(uint newEthPrice, uint newHavvenPrice, uint timeSent);
3317     event Exchange(string fromCurrency, uint fromAmount, string toCurrency, uint toAmount);
3318 }