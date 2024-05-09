1 /*
2 -----------------------------------------------------------------
3 FILE INFORMATION
4 -----------------------------------------------------------------
5 
6 file:       NominAirdropper.sol
7 version:    1.0
8 author:     Kevin Brown
9 
10 date:       2018-07-09
11 
12 -----------------------------------------------------------------
13 MODULE DESCRIPTION
14 -----------------------------------------------------------------
15 
16 This contract was adapted for use by the Havven project from the
17 airdropper contract that OmiseGO created here:
18 https://github.com/omisego/airdrop/blob/master/contracts/Airdropper.sol
19 
20 It exists to save gas costs per transaction that'd otherwise be
21 incurred running airdrops individually.
22 
23 Original license below.
24 
25 -----------------------------------------------------------------
26 
27 Copyright 2017 OmiseGO Pte Ltd
28 
29 Licensed under the Apache License, Version 2.0 (the "License");
30 you may not use this file except in compliance with the License.
31 You may obtain a copy of the License at
32 
33     http://www.apache.org/licenses/LICENSE-2.0
34 
35 Unless required by applicable law or agreed to in writing, software
36 distributed under the License is distributed on an "AS IS" BASIS,
37 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
38 See the License for the specific language governing permissions and
39 limitations under the License.
40 */
41 
42 
43 /*
44 -----------------------------------------------------------------
45 FILE INFORMATION
46 -----------------------------------------------------------------
47 
48 file:       Owned.sol
49 version:    1.1
50 author:     Anton Jurisevic
51             Dominic Romanowski
52 
53 date:       2018-2-26
54 
55 -----------------------------------------------------------------
56 MODULE DESCRIPTION
57 -----------------------------------------------------------------
58 
59 An Owned contract, to be inherited by other contracts.
60 Requires its owner to be explicitly set in the constructor.
61 Provides an onlyOwner access modifier.
62 
63 To change owner, the current owner must nominate the next owner,
64 who then has to accept the nomination. The nomination can be
65 cancelled before it is accepted by the new owner by having the
66 previous owner change the nomination (setting it to 0).
67 
68 -----------------------------------------------------------------
69 */
70 
71 pragma solidity 0.4.24;
72 
73 /**
74  * @title A contract with an owner.
75  * @notice Contract ownership can be transferred by first nominating the new owner,
76  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
77  */
78 contract Owned {
79     address public owner;
80     address public nominatedOwner;
81 
82     /**
83      * @dev Owned Constructor
84      */
85     constructor(address _owner)
86         public
87     {
88         require(_owner != address(0));
89         owner = _owner;
90         emit OwnerChanged(address(0), _owner);
91     }
92 
93     /**
94      * @notice Nominate a new owner of this contract.
95      * @dev Only the current owner may nominate a new owner.
96      */
97     function nominateNewOwner(address _owner)
98         external
99         onlyOwner
100     {
101         nominatedOwner = _owner;
102         emit OwnerNominated(_owner);
103     }
104 
105     /**
106      * @notice Accept the nomination to be owner.
107      */
108     function acceptOwnership()
109         external
110     {
111         require(msg.sender == nominatedOwner);
112         emit OwnerChanged(owner, nominatedOwner);
113         owner = nominatedOwner;
114         nominatedOwner = address(0);
115     }
116 
117     modifier onlyOwner
118     {
119         require(msg.sender == owner);
120         _;
121     }
122 
123     event OwnerNominated(address newOwner);
124     event OwnerChanged(address oldOwner, address newOwner);
125 }
126 
127 
128 /*
129 -----------------------------------------------------------------
130 FILE INFORMATION
131 -----------------------------------------------------------------
132 
133 file:       SafeDecimalMath.sol
134 version:    1.0
135 author:     Anton Jurisevic
136 
137 date:       2018-2-5
138 
139 checked:    Mike Spain
140 approved:   Samuel Brooks
141 
142 -----------------------------------------------------------------
143 MODULE DESCRIPTION
144 -----------------------------------------------------------------
145 
146 A fixed point decimal library that provides basic mathematical
147 operations, and checks for unsafe arguments, for example that
148 would lead to overflows.
149 
150 Exceptions are thrown whenever those unsafe operations
151 occur.
152 
153 -----------------------------------------------------------------
154 */
155 
156 
157 /**
158  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
159  * @dev Functions accepting uints in this contract and derived contracts
160  * are taken to be such fixed point decimals (including fiat, ether, and nomin quantities).
161  */
162 contract SafeDecimalMath {
163 
164     /* Number of decimal places in the representation. */
165     uint8 public constant decimals = 18;
166 
167     /* The number representing 1.0. */
168     uint public constant UNIT = 10 ** uint(decimals);
169 
170     /**
171      * @return True iff adding x and y will not overflow.
172      */
173     function addIsSafe(uint x, uint y)
174         pure
175         internal
176         returns (bool)
177     {
178         return x + y >= y;
179     }
180 
181     /**
182      * @return The result of adding x and y, throwing an exception in case of overflow.
183      */
184     function safeAdd(uint x, uint y)
185         pure
186         internal
187         returns (uint)
188     {
189         require(x + y >= y);
190         return x + y;
191     }
192 
193     /**
194      * @return True iff subtracting y from x will not overflow in the negative direction.
195      */
196     function subIsSafe(uint x, uint y)
197         pure
198         internal
199         returns (bool)
200     {
201         return y <= x;
202     }
203 
204     /**
205      * @return The result of subtracting y from x, throwing an exception in case of overflow.
206      */
207     function safeSub(uint x, uint y)
208         pure
209         internal
210         returns (uint)
211     {
212         require(y <= x);
213         return x - y;
214     }
215 
216     /**
217      * @return True iff multiplying x and y would not overflow.
218      */
219     function mulIsSafe(uint x, uint y)
220         pure
221         internal
222         returns (bool)
223     {
224         if (x == 0) {
225             return true;
226         }
227         return (x * y) / x == y;
228     }
229 
230     /**
231      * @return The result of multiplying x and y, throwing an exception in case of overflow.
232      */
233     function safeMul(uint x, uint y)
234         pure
235         internal
236         returns (uint)
237     {
238         if (x == 0) {
239             return 0;
240         }
241         uint p = x * y;
242         require(p / x == y);
243         return p;
244     }
245 
246     /**
247      * @return The result of multiplying x and y, interpreting the operands as fixed-point
248      * decimals. Throws an exception in case of overflow.
249      * 
250      * @dev A unit factor is divided out after the product of x and y is evaluated,
251      * so that product must be less than 2**256.
252      * Incidentally, the internal division always rounds down: one could have rounded to the nearest integer,
253      * but then one would be spending a significant fraction of a cent (of order a microether
254      * at present gas prices) in order to save less than one part in 0.5 * 10^18 per operation, if the operands
255      * contain small enough fractional components. It would also marginally diminish the 
256      * domain this function is defined upon. 
257      */
258     function safeMul_dec(uint x, uint y)
259         pure
260         internal
261         returns (uint)
262     {
263         /* Divide by UNIT to remove the extra factor introduced by the product. */
264         return safeMul(x, y) / UNIT;
265 
266     }
267 
268     /**
269      * @return True iff the denominator of x/y is nonzero.
270      */
271     function divIsSafe(uint x, uint y)
272         pure
273         internal
274         returns (bool)
275     {
276         return y != 0;
277     }
278 
279     /**
280      * @return The result of dividing x by y, throwing an exception if the divisor is zero.
281      */
282     function safeDiv(uint x, uint y)
283         pure
284         internal
285         returns (uint)
286     {
287         /* Although a 0 denominator already throws an exception,
288          * it is equivalent to a THROW operation, which consumes all gas.
289          * A require statement emits REVERT instead, which remits remaining gas. */
290         require(y != 0);
291         return x / y;
292     }
293 
294     /**
295      * @return The result of dividing x by y, interpreting the operands as fixed point decimal numbers.
296      * @dev Throws an exception in case of overflow or zero divisor; x must be less than 2^256 / UNIT.
297      * Internal rounding is downward: a similar caveat holds as with safeDecMul().
298      */
299     function safeDiv_dec(uint x, uint y)
300         pure
301         internal
302         returns (uint)
303     {
304         /* Reintroduce the UNIT factor that will be divided out by y. */
305         return safeDiv(safeMul(x, UNIT), y);
306     }
307 
308     /**
309      * @dev Convert an unsigned integer to a unsigned fixed-point decimal.
310      * Throw an exception if the result would be out of range.
311      */
312     function intToDec(uint i)
313         pure
314         internal
315         returns (uint)
316     {
317         return safeMul(i, UNIT);
318     }
319 }
320 
321 
322 /*
323 -----------------------------------------------------------------
324 FILE INFORMATION
325 -----------------------------------------------------------------
326 
327 file:       SelfDestructible.sol
328 version:    1.2
329 author:     Anton Jurisevic
330 
331 date:       2018-05-29
332 
333 -----------------------------------------------------------------
334 MODULE DESCRIPTION
335 -----------------------------------------------------------------
336 
337 This contract allows an inheriting contract to be destroyed after
338 its owner indicates an intention and then waits for a period
339 without changing their mind. All ether contained in the contract
340 is forwarded to a nominated beneficiary upon destruction.
341 
342 -----------------------------------------------------------------
343 */
344 
345 
346 /**
347  * @title A contract that can be destroyed by its owner after a delay elapses.
348  */
349 contract SelfDestructible is Owned {
350 	
351 	uint public initiationTime;
352 	bool public selfDestructInitiated;
353 	address public selfDestructBeneficiary;
354 	uint public constant SELFDESTRUCT_DELAY = 4 weeks;
355 
356 	/**
357 	 * @dev Constructor
358 	 * @param _owner The account which controls this contract.
359 	 */
360 	constructor(address _owner)
361 	    Owned(_owner)
362 	    public
363 	{
364 		require(_owner != address(0));
365 		selfDestructBeneficiary = _owner;
366 		emit SelfDestructBeneficiaryUpdated(_owner);
367 	}
368 
369 	/**
370 	 * @notice Set the beneficiary address of this contract.
371 	 * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
372 	 * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
373 	 */
374 	function setSelfDestructBeneficiary(address _beneficiary)
375 		external
376 		onlyOwner
377 	{
378 		require(_beneficiary != address(0));
379 		selfDestructBeneficiary = _beneficiary;
380 		emit SelfDestructBeneficiaryUpdated(_beneficiary);
381 	}
382 
383 	/**
384 	 * @notice Begin the self-destruction counter of this contract.
385 	 * Once the delay has elapsed, the contract may be self-destructed.
386 	 * @dev Only the contract owner may call this.
387 	 */
388 	function initiateSelfDestruct()
389 		external
390 		onlyOwner
391 	{
392 		initiationTime = now;
393 		selfDestructInitiated = true;
394 		emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
395 	}
396 
397 	/**
398 	 * @notice Terminate and reset the self-destruction timer.
399 	 * @dev Only the contract owner may call this.
400 	 */
401 	function terminateSelfDestruct()
402 		external
403 		onlyOwner
404 	{
405 		initiationTime = 0;
406 		selfDestructInitiated = false;
407 		emit SelfDestructTerminated();
408 	}
409 
410 	/**
411 	 * @notice If the self-destruction delay has elapsed, destroy this contract and
412 	 * remit any ether it owns to the beneficiary address.
413 	 * @dev Only the contract owner may call this.
414 	 */
415 	function selfDestruct()
416 		external
417 		onlyOwner
418 	{
419 		require(selfDestructInitiated && initiationTime + SELFDESTRUCT_DELAY < now);
420 		address beneficiary = selfDestructBeneficiary;
421 		emit SelfDestructed(beneficiary);
422 		selfdestruct(beneficiary);
423 	}
424 
425 	event SelfDestructTerminated();
426 	event SelfDestructed(address beneficiary);
427 	event SelfDestructInitiated(uint selfDestructDelay);
428 	event SelfDestructBeneficiaryUpdated(address newBeneficiary);
429 }
430 
431 
432 /*
433 -----------------------------------------------------------------
434 FILE INFORMATION
435 -----------------------------------------------------------------
436 
437 file:       State.sol
438 version:    1.1
439 author:     Dominic Romanowski
440             Anton Jurisevic
441 
442 date:       2018-05-15
443 
444 -----------------------------------------------------------------
445 MODULE DESCRIPTION
446 -----------------------------------------------------------------
447 
448 This contract is used side by side with external state token
449 contracts, such as Havven and Nomin.
450 It provides an easy way to upgrade contract logic while
451 maintaining all user balances and allowances. This is designed
452 to make the changeover as easy as possible, since mappings
453 are not so cheap or straightforward to migrate.
454 
455 The first deployed contract would create this state contract,
456 using it as its store of balances.
457 When a new contract is deployed, it links to the existing
458 state contract, whose owner would then change its associated
459 contract to the new one.
460 
461 -----------------------------------------------------------------
462 */
463 
464 
465 contract State is Owned {
466     // the address of the contract that can modify variables
467     // this can only be changed by the owner of this contract
468     address public associatedContract;
469 
470 
471     constructor(address _owner, address _associatedContract)
472         Owned(_owner)
473         public
474     {
475         associatedContract = _associatedContract;
476         emit AssociatedContractUpdated(_associatedContract);
477     }
478 
479     /* ========== SETTERS ========== */
480 
481     // Change the associated contract to a new address
482     function setAssociatedContract(address _associatedContract)
483         external
484         onlyOwner
485     {
486         associatedContract = _associatedContract;
487         emit AssociatedContractUpdated(_associatedContract);
488     }
489 
490     /* ========== MODIFIERS ========== */
491 
492     modifier onlyAssociatedContract
493     {
494         require(msg.sender == associatedContract);
495         _;
496     }
497 
498     /* ========== EVENTS ========== */
499 
500     event AssociatedContractUpdated(address associatedContract);
501 }
502 
503 
504 /*
505 -----------------------------------------------------------------
506 FILE INFORMATION
507 -----------------------------------------------------------------
508 
509 file:       TokenState.sol
510 version:    1.1
511 author:     Dominic Romanowski
512             Anton Jurisevic
513 
514 date:       2018-05-15
515 
516 -----------------------------------------------------------------
517 MODULE DESCRIPTION
518 -----------------------------------------------------------------
519 
520 A contract that holds the state of an ERC20 compliant token.
521 
522 This contract is used side by side with external state token
523 contracts, such as Havven and Nomin.
524 It provides an easy way to upgrade contract logic while
525 maintaining all user balances and allowances. This is designed
526 to make the changeover as easy as possible, since mappings
527 are not so cheap or straightforward to migrate.
528 
529 The first deployed contract would create this state contract,
530 using it as its store of balances.
531 When a new contract is deployed, it links to the existing
532 state contract, whose owner would then change its associated
533 contract to the new one.
534 
535 -----------------------------------------------------------------
536 */
537 
538 
539 /**
540  * @title ERC20 Token State
541  * @notice Stores balance information of an ERC20 token contract.
542  */
543 contract TokenState is State {
544 
545     /* ERC20 fields. */
546     mapping(address => uint) public balanceOf;
547     mapping(address => mapping(address => uint)) public allowance;
548 
549     /**
550      * @dev Constructor
551      * @param _owner The address which controls this contract.
552      * @param _associatedContract The ERC20 contract whose state this composes.
553      */
554     constructor(address _owner, address _associatedContract)
555         State(_owner, _associatedContract)
556         public
557     {}
558 
559     /* ========== SETTERS ========== */
560 
561     /**
562      * @notice Set ERC20 allowance.
563      * @dev Only the associated contract may call this.
564      * @param tokenOwner The authorising party.
565      * @param spender The authorised party.
566      * @param value The total value the authorised party may spend on the
567      * authorising party's behalf.
568      */
569     function setAllowance(address tokenOwner, address spender, uint value)
570         external
571         onlyAssociatedContract
572     {
573         allowance[tokenOwner][spender] = value;
574     }
575 
576     /**
577      * @notice Set the balance in a given account
578      * @dev Only the associated contract may call this.
579      * @param account The account whose value to set.
580      * @param value The new balance of the given account.
581      */
582     function setBalanceOf(address account, uint value)
583         external
584         onlyAssociatedContract
585     {
586         balanceOf[account] = value;
587     }
588 }
589 
590 
591 /*
592 -----------------------------------------------------------------
593 FILE INFORMATION
594 -----------------------------------------------------------------
595 
596 file:       Proxy.sol
597 version:    1.3
598 author:     Anton Jurisevic
599 
600 date:       2018-05-29
601 
602 -----------------------------------------------------------------
603 MODULE DESCRIPTION
604 -----------------------------------------------------------------
605 
606 A proxy contract that, if it does not recognise the function
607 being called on it, passes all value and call data to an
608 underlying target contract.
609 
610 This proxy has the capacity to toggle between DELEGATECALL
611 and CALL style proxy functionality.
612 
613 The former executes in the proxy's context, and so will preserve 
614 msg.sender and store data at the proxy address. The latter will not.
615 Therefore, any contract the proxy wraps in the CALL style must
616 implement the Proxyable interface, in order that it can pass msg.sender
617 into the underlying contract as the state parameter, messageSender.
618 
619 -----------------------------------------------------------------
620 */
621 
622 
623 contract Proxy is Owned {
624 
625     Proxyable public target;
626     bool public useDELEGATECALL;
627 
628     constructor(address _owner)
629         Owned(_owner)
630         public
631     {}
632 
633     function setTarget(Proxyable _target)
634         external
635         onlyOwner
636     {
637         target = _target;
638         emit TargetUpdated(_target);
639     }
640 
641     function setUseDELEGATECALL(bool value) 
642         external
643         onlyOwner
644     {
645         useDELEGATECALL = value;
646     }
647 
648     function _emit(bytes callData, uint numTopics,
649                    bytes32 topic1, bytes32 topic2,
650                    bytes32 topic3, bytes32 topic4)
651         external
652         onlyTarget
653     {
654         uint size = callData.length;
655         bytes memory _callData = callData;
656 
657         assembly {
658             /* The first 32 bytes of callData contain its length (as specified by the abi). 
659              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
660              * in length. It is also leftpadded to be a multiple of 32 bytes.
661              * This means moving call_data across 32 bytes guarantees we correctly access
662              * the data itself. */
663             switch numTopics
664             case 0 {
665                 log0(add(_callData, 32), size)
666             } 
667             case 1 {
668                 log1(add(_callData, 32), size, topic1)
669             }
670             case 2 {
671                 log2(add(_callData, 32), size, topic1, topic2)
672             }
673             case 3 {
674                 log3(add(_callData, 32), size, topic1, topic2, topic3)
675             }
676             case 4 {
677                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
678             }
679         }
680     }
681 
682     function()
683         external
684         payable
685     {
686         if (useDELEGATECALL) {
687             assembly {
688                 /* Copy call data into free memory region. */
689                 let free_ptr := mload(0x40)
690                 calldatacopy(free_ptr, 0, calldatasize)
691 
692                 /* Forward all gas and call data to the target contract. */
693                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
694                 returndatacopy(free_ptr, 0, returndatasize)
695 
696                 /* Revert if the call failed, otherwise return the result. */
697                 if iszero(result) { revert(free_ptr, returndatasize) }
698                 return(free_ptr, returndatasize)
699             }
700         } else {
701             /* Here we are as above, but must send the messageSender explicitly 
702              * since we are using CALL rather than DELEGATECALL. */
703             target.setMessageSender(msg.sender);
704             assembly {
705                 let free_ptr := mload(0x40)
706                 calldatacopy(free_ptr, 0, calldatasize)
707 
708                 /* We must explicitly forward ether to the underlying contract as well. */
709                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
710                 returndatacopy(free_ptr, 0, returndatasize)
711 
712                 if iszero(result) { revert(free_ptr, returndatasize) }
713                 return(free_ptr, returndatasize)
714             }
715         }
716     }
717 
718     modifier onlyTarget {
719         require(Proxyable(msg.sender) == target);
720         _;
721     }
722 
723     event TargetUpdated(Proxyable newTarget);
724 }
725 
726 
727 /*
728 -----------------------------------------------------------------
729 FILE INFORMATION
730 -----------------------------------------------------------------
731 
732 file:       Proxyable.sol
733 version:    1.1
734 author:     Anton Jurisevic
735 
736 date:       2018-05-15
737 
738 checked:    Mike Spain
739 approved:   Samuel Brooks
740 
741 -----------------------------------------------------------------
742 MODULE DESCRIPTION
743 -----------------------------------------------------------------
744 
745 A proxyable contract that works hand in hand with the Proxy contract
746 to allow for anyone to interact with the underlying contract both
747 directly and through the proxy.
748 
749 -----------------------------------------------------------------
750 */
751 
752 
753 // This contract should be treated like an abstract contract
754 contract Proxyable is Owned {
755     /* The proxy this contract exists behind. */
756     Proxy public proxy;
757 
758     /* The caller of the proxy, passed through to this contract.
759      * Note that every function using this member must apply the onlyProxy or
760      * optionalProxy modifiers, otherwise their invocations can use stale values. */ 
761     address messageSender; 
762 
763     constructor(address _proxy, address _owner)
764         Owned(_owner)
765         public
766     {
767         proxy = Proxy(_proxy);
768         emit ProxyUpdated(_proxy);
769     }
770 
771     function setProxy(address _proxy)
772         external
773         onlyOwner
774     {
775         proxy = Proxy(_proxy);
776         emit ProxyUpdated(_proxy);
777     }
778 
779     function setMessageSender(address sender)
780         external
781         onlyProxy
782     {
783         messageSender = sender;
784     }
785 
786     modifier onlyProxy {
787         require(Proxy(msg.sender) == proxy);
788         _;
789     }
790 
791     modifier optionalProxy
792     {
793         if (Proxy(msg.sender) != proxy) {
794             messageSender = msg.sender;
795         }
796         _;
797     }
798 
799     modifier optionalProxy_onlyOwner
800     {
801         if (Proxy(msg.sender) != proxy) {
802             messageSender = msg.sender;
803         }
804         require(messageSender == owner);
805         _;
806     }
807 
808     event ProxyUpdated(address proxyAddress);
809 }
810 
811 
812 /*
813 -----------------------------------------------------------------
814 FILE INFORMATION
815 -----------------------------------------------------------------
816 
817 file:       ExternStateToken.sol
818 version:    1.3
819 author:     Anton Jurisevic
820             Dominic Romanowski
821 
822 date:       2018-05-29
823 
824 -----------------------------------------------------------------
825 MODULE DESCRIPTION
826 -----------------------------------------------------------------
827 
828 A partial ERC20 token contract, designed to operate with a proxy.
829 To produce a complete ERC20 token, transfer and transferFrom
830 tokens must be implemented, using the provided _byProxy internal
831 functions.
832 This contract utilises an external state for upgradeability.
833 
834 -----------------------------------------------------------------
835 */
836 
837 
838 /**
839  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
840  */
841 contract ExternStateToken is SafeDecimalMath, SelfDestructible, Proxyable {
842 
843     /* ========== STATE VARIABLES ========== */
844 
845     /* Stores balances and allowances. */
846     TokenState public tokenState;
847 
848     /* Other ERC20 fields.
849      * Note that the decimals field is defined in SafeDecimalMath.*/
850     string public name;
851     string public symbol;
852     uint public totalSupply;
853 
854     /**
855      * @dev Constructor.
856      * @param _proxy The proxy associated with this contract.
857      * @param _name Token's ERC20 name.
858      * @param _symbol Token's ERC20 symbol.
859      * @param _totalSupply The total supply of the token.
860      * @param _tokenState The TokenState contract address.
861      * @param _owner The owner of this contract.
862      */
863     constructor(address _proxy, TokenState _tokenState,
864                 string _name, string _symbol, uint _totalSupply,
865                 address _owner)
866         SelfDestructible(_owner)
867         Proxyable(_proxy, _owner)
868         public
869     {
870         name = _name;
871         symbol = _symbol;
872         totalSupply = _totalSupply;
873         tokenState = _tokenState;
874    }
875 
876     /* ========== VIEWS ========== */
877 
878     /**
879      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
880      * @param owner The party authorising spending of their funds.
881      * @param spender The party spending tokenOwner's funds.
882      */
883     function allowance(address owner, address spender)
884         public
885         view
886         returns (uint)
887     {
888         return tokenState.allowance(owner, spender);
889     }
890 
891     /**
892      * @notice Returns the ERC20 token balance of a given account.
893      */
894     function balanceOf(address account)
895         public
896         view
897         returns (uint)
898     {
899         return tokenState.balanceOf(account);
900     }
901 
902     /* ========== MUTATIVE FUNCTIONS ========== */
903 
904     /**
905      * @notice Set the address of the TokenState contract.
906      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
907      * as balances would be unreachable.
908      */ 
909     function setTokenState(TokenState _tokenState)
910         external
911         optionalProxy_onlyOwner
912     {
913         tokenState = _tokenState;
914         emitTokenStateUpdated(_tokenState);
915     }
916 
917     function _internalTransfer(address from, address to, uint value) 
918         internal
919         returns (bool)
920     { 
921         /* Disallow transfers to irretrievable-addresses. */
922         require(to != address(0));
923         require(to != address(this));
924         require(to != address(proxy));
925 
926         /* Insufficient balance will be handled by the safe subtraction. */
927         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), value));
928         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), value));
929 
930         emitTransfer(from, to, value);
931 
932         return true;
933     }
934 
935     /**
936      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
937      * the onlyProxy or optionalProxy modifiers.
938      */
939     function _transfer_byProxy(address from, address to, uint value)
940         internal
941         returns (bool)
942     {
943         return _internalTransfer(from, to, value);
944     }
945 
946     /**
947      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
948      * possessing the optionalProxy or optionalProxy modifiers.
949      */
950     function _transferFrom_byProxy(address sender, address from, address to, uint value)
951         internal
952         returns (bool)
953     {
954         /* Insufficient allowance will be handled by the safe subtraction. */
955         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
956         return _internalTransfer(from, to, value);
957     }
958 
959     /**
960      * @notice Approves spender to transfer on the message sender's behalf.
961      */
962     function approve(address spender, uint value)
963         public
964         optionalProxy
965         returns (bool)
966     {
967         address sender = messageSender;
968 
969         tokenState.setAllowance(sender, spender, value);
970         emitApproval(sender, spender, value);
971         return true;
972     }
973 
974     /* ========== EVENTS ========== */
975 
976     event Transfer(address indexed from, address indexed to, uint value);
977     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
978     function emitTransfer(address from, address to, uint value) internal {
979         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
980     }
981 
982     event Approval(address indexed owner, address indexed spender, uint value);
983     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
984     function emitApproval(address owner, address spender, uint value) internal {
985         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
986     }
987 
988     event TokenStateUpdated(address newTokenState);
989     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
990     function emitTokenStateUpdated(address newTokenState) internal {
991         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
992     }
993 }
994 
995 
996 /*
997 -----------------------------------------------------------------
998 FILE INFORMATION
999 -----------------------------------------------------------------
1000 
1001 file:       FeeToken.sol
1002 version:    1.3
1003 author:     Anton Jurisevic
1004             Dominic Romanowski
1005             Kevin Brown
1006 
1007 date:       2018-05-29
1008 
1009 -----------------------------------------------------------------
1010 MODULE DESCRIPTION
1011 -----------------------------------------------------------------
1012 
1013 A token which also has a configurable fee rate
1014 charged on its transfers. This is designed to be overridden in
1015 order to produce an ERC20-compliant token.
1016 
1017 These fees accrue into a pool, from which a nominated authority
1018 may withdraw.
1019 
1020 This contract utilises an external state for upgradeability.
1021 
1022 -----------------------------------------------------------------
1023 */
1024 
1025 
1026 /**
1027  * @title ERC20 Token contract, with detached state.
1028  * Additionally charges fees on each transfer.
1029  */
1030 contract FeeToken is ExternStateToken {
1031 
1032     /* ========== STATE VARIABLES ========== */
1033 
1034     /* ERC20 members are declared in ExternStateToken. */
1035 
1036     /* A percentage fee charged on each transfer. */
1037     uint public transferFeeRate;
1038     /* Fee may not exceed 10%. */
1039     uint constant MAX_TRANSFER_FEE_RATE = UNIT / 10;
1040     /* The address with the authority to distribute fees. */
1041     address public feeAuthority;
1042     /* The address that fees will be pooled in. */
1043     address public constant FEE_ADDRESS = 0xfeefeefeefeefeefeefeefeefeefeefeefeefeef;
1044 
1045 
1046     /* ========== CONSTRUCTOR ========== */
1047 
1048     /**
1049      * @dev Constructor.
1050      * @param _proxy The proxy associated with this contract.
1051      * @param _name Token's ERC20 name.
1052      * @param _symbol Token's ERC20 symbol.
1053      * @param _totalSupply The total supply of the token.
1054      * @param _transferFeeRate The fee rate to charge on transfers.
1055      * @param _feeAuthority The address which has the authority to withdraw fees from the accumulated pool.
1056      * @param _owner The owner of this contract.
1057      */
1058     constructor(address _proxy, TokenState _tokenState, string _name, string _symbol, uint _totalSupply,
1059                 uint _transferFeeRate, address _feeAuthority, address _owner)
1060         ExternStateToken(_proxy, _tokenState,
1061                          _name, _symbol, _totalSupply,
1062                          _owner)
1063         public
1064     {
1065         feeAuthority = _feeAuthority;
1066 
1067         /* Constructed transfer fee rate should respect the maximum fee rate. */
1068         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE);
1069         transferFeeRate = _transferFeeRate;
1070     }
1071 
1072     /* ========== SETTERS ========== */
1073 
1074     /**
1075      * @notice Set the transfer fee, anywhere within the range 0-10%.
1076      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1077      */
1078     function setTransferFeeRate(uint _transferFeeRate)
1079         external
1080         optionalProxy_onlyOwner
1081     {
1082         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE);
1083         transferFeeRate = _transferFeeRate;
1084         emitTransferFeeRateUpdated(_transferFeeRate);
1085     }
1086 
1087     /**
1088      * @notice Set the address of the user/contract responsible for collecting or
1089      * distributing fees.
1090      */
1091     function setFeeAuthority(address _feeAuthority)
1092         public
1093         optionalProxy_onlyOwner
1094     {
1095         feeAuthority = _feeAuthority;
1096         emitFeeAuthorityUpdated(_feeAuthority);
1097     }
1098 
1099     /* ========== VIEWS ========== */
1100 
1101     /**
1102      * @notice Calculate the Fee charged on top of a value being sent
1103      * @return Return the fee charged
1104      */
1105     function transferFeeIncurred(uint value)
1106         public
1107         view
1108         returns (uint)
1109     {
1110         return safeMul_dec(value, transferFeeRate);
1111         /* Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1112          * This is on the basis that transfers less than this value will result in a nil fee.
1113          * Probably too insignificant to worry about, but the following code will achieve it.
1114          *      if (fee == 0 && transferFeeRate != 0) {
1115          *          return _value;
1116          *      }
1117          *      return fee;
1118          */
1119     }
1120 
1121     /**
1122      * @notice The value that you would need to send so that the recipient receives
1123      * a specified value.
1124      */
1125     function transferPlusFee(uint value)
1126         external
1127         view
1128         returns (uint)
1129     {
1130         return safeAdd(value, transferFeeIncurred(value));
1131     }
1132 
1133     /**
1134      * @notice The amount the recipient will receive if you send a certain number of tokens.
1135      */
1136     function amountReceived(uint value)
1137         public
1138         view
1139         returns (uint)
1140     {
1141         return safeDiv_dec(value, safeAdd(UNIT, transferFeeRate));
1142     }
1143 
1144     /**
1145      * @notice Collected fees sit here until they are distributed.
1146      * @dev The balance of the nomin contract itself is the fee pool.
1147      */
1148     function feePool()
1149         external
1150         view
1151         returns (uint)
1152     {
1153         return tokenState.balanceOf(FEE_ADDRESS);
1154     }
1155 
1156     /* ========== MUTATIVE FUNCTIONS ========== */
1157 
1158     /**
1159      * @notice Base of transfer functions
1160      */
1161     function _internalTransfer(address from, address to, uint amount, uint fee)
1162         internal
1163         returns (bool)
1164     {
1165         /* Disallow transfers to irretrievable-addresses. */
1166         require(to != address(0));
1167         require(to != address(this));
1168         require(to != address(proxy));
1169 
1170         /* Insufficient balance will be handled by the safe subtraction. */
1171         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), safeAdd(amount, fee)));
1172         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), amount));
1173         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), fee));
1174 
1175         /* Emit events for both the transfer itself and the fee. */
1176         emitTransfer(from, to, amount);
1177         emitTransfer(from, FEE_ADDRESS, fee);
1178 
1179         return true;
1180     }
1181 
1182     /**
1183      * @notice ERC20 friendly transfer function.
1184      */
1185     function _transfer_byProxy(address sender, address to, uint value)
1186         internal
1187         returns (bool)
1188     {
1189         uint received = amountReceived(value);
1190         uint fee = safeSub(value, received);
1191 
1192         return _internalTransfer(sender, to, received, fee);
1193     }
1194 
1195     /**
1196      * @notice ERC20 friendly transferFrom function.
1197      */
1198     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1199         internal
1200         returns (bool)
1201     {
1202         /* The fee is deducted from the amount sent. */
1203         uint received = amountReceived(value);
1204         uint fee = safeSub(value, received);
1205 
1206         /* Reduce the allowance by the amount we're transferring.
1207          * The safeSub call will handle an insufficient allowance. */
1208         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
1209 
1210         return _internalTransfer(from, to, received, fee);
1211     }
1212 
1213     /**
1214      * @notice Ability to transfer where the sender pays the fees (not ERC20)
1215      */
1216     function _transferSenderPaysFee_byProxy(address sender, address to, uint value)
1217         internal
1218         returns (bool)
1219     {
1220         /* The fee is added to the amount sent. */
1221         uint fee = transferFeeIncurred(value);
1222         return _internalTransfer(sender, to, value, fee);
1223     }
1224 
1225     /**
1226      * @notice Ability to transferFrom where they sender pays the fees (not ERC20).
1227      */
1228     function _transferFromSenderPaysFee_byProxy(address sender, address from, address to, uint value)
1229         internal
1230         returns (bool)
1231     {
1232         /* The fee is added to the amount sent. */
1233         uint fee = transferFeeIncurred(value);
1234         uint total = safeAdd(value, fee);
1235 
1236         /* Reduce the allowance by the amount we're transferring. */
1237         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), total));
1238 
1239         return _internalTransfer(from, to, value, fee);
1240     }
1241 
1242     /**
1243      * @notice Withdraw tokens from the fee pool into a given account.
1244      * @dev Only the fee authority may call this.
1245      */
1246     function withdrawFees(address account, uint value)
1247         external
1248         onlyFeeAuthority
1249         returns (bool)
1250     {
1251         require(account != address(0));
1252 
1253         /* 0-value withdrawals do nothing. */
1254         if (value == 0) {
1255             return false;
1256         }
1257 
1258         /* Safe subtraction ensures an exception is thrown if the balance is insufficient. */
1259         tokenState.setBalanceOf(FEE_ADDRESS, safeSub(tokenState.balanceOf(FEE_ADDRESS), value));
1260         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), value));
1261 
1262         emitFeesWithdrawn(account, value);
1263         emitTransfer(FEE_ADDRESS, account, value);
1264 
1265         return true;
1266     }
1267 
1268     /**
1269      * @notice Donate tokens from the sender's balance into the fee pool.
1270      */
1271     function donateToFeePool(uint n)
1272         external
1273         optionalProxy
1274         returns (bool)
1275     {
1276         address sender = messageSender;
1277         /* Empty donations are disallowed. */
1278         uint balance = tokenState.balanceOf(sender);
1279         require(balance != 0);
1280 
1281         /* safeSub ensures the donor has sufficient balance. */
1282         tokenState.setBalanceOf(sender, safeSub(balance, n));
1283         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), n));
1284 
1285         emitFeesDonated(sender, n);
1286         emitTransfer(sender, FEE_ADDRESS, n);
1287 
1288         return true;
1289     }
1290 
1291 
1292     /* ========== MODIFIERS ========== */
1293 
1294     modifier onlyFeeAuthority
1295     {
1296         require(msg.sender == feeAuthority);
1297         _;
1298     }
1299 
1300 
1301     /* ========== EVENTS ========== */
1302 
1303     event TransferFeeRateUpdated(uint newFeeRate);
1304     bytes32 constant TRANSFERFEERATEUPDATED_SIG = keccak256("TransferFeeRateUpdated(uint256)");
1305     function emitTransferFeeRateUpdated(uint newFeeRate) internal {
1306         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEERATEUPDATED_SIG, 0, 0, 0);
1307     }
1308 
1309     event FeeAuthorityUpdated(address newFeeAuthority);
1310     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
1311     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
1312         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
1313     } 
1314 
1315     event FeesWithdrawn(address indexed account, uint value);
1316     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
1317     function emitFeesWithdrawn(address account, uint value) internal {
1318         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
1319     }
1320 
1321     event FeesDonated(address indexed donor, uint value);
1322     bytes32 constant FEESDONATED_SIG = keccak256("FeesDonated(address,uint256)");
1323     function emitFeesDonated(address donor, uint value) internal {
1324         proxy._emit(abi.encode(value), 2, FEESDONATED_SIG, bytes32(donor), 0, 0);
1325     }
1326 }
1327 
1328 
1329 /*
1330 -----------------------------------------------------------------
1331 FILE INFORMATION
1332 -----------------------------------------------------------------
1333 
1334 file:       LimitedSetup.sol
1335 version:    1.1
1336 author:     Anton Jurisevic
1337 
1338 date:       2018-05-15
1339 
1340 -----------------------------------------------------------------
1341 MODULE DESCRIPTION
1342 -----------------------------------------------------------------
1343 
1344 A contract with a limited setup period. Any function modified
1345 with the setup modifier will cease to work after the
1346 conclusion of the configurable-length post-construction setup period.
1347 
1348 -----------------------------------------------------------------
1349 */
1350 
1351 
1352 /**
1353  * @title Any function decorated with the modifier this contract provides
1354  * deactivates after a specified setup period.
1355  */
1356 contract LimitedSetup {
1357 
1358     uint setupExpiryTime;
1359 
1360     /**
1361      * @dev LimitedSetup Constructor.
1362      * @param setupDuration The time the setup period will last for.
1363      */
1364     constructor(uint setupDuration)
1365         public
1366     {
1367         setupExpiryTime = now + setupDuration;
1368     }
1369 
1370     modifier onlyDuringSetup
1371     {
1372         require(now < setupExpiryTime);
1373         _;
1374     }
1375 }
1376 
1377 
1378 /*
1379 -----------------------------------------------------------------
1380 FILE INFORMATION
1381 -----------------------------------------------------------------
1382 
1383 file:       HavvenEscrow.sol
1384 version:    1.1
1385 author:     Anton Jurisevic
1386             Dominic Romanowski
1387             Mike Spain
1388 
1389 date:       2018-05-29
1390 
1391 -----------------------------------------------------------------
1392 MODULE DESCRIPTION
1393 -----------------------------------------------------------------
1394 
1395 This contract allows the foundation to apply unique vesting
1396 schedules to havven funds sold at various discounts in the token
1397 sale. HavvenEscrow gives users the ability to inspect their
1398 vested funds, their quantities and vesting dates, and to withdraw
1399 the fees that accrue on those funds.
1400 
1401 The fees are handled by withdrawing the entire fee allocation
1402 for all havvens inside the escrow contract, and then allowing
1403 the contract itself to subdivide that pool up proportionally within
1404 itself. Every time the fee period rolls over in the main Havven
1405 contract, the HavvenEscrow fee pool is remitted back into the
1406 main fee pool to be redistributed in the next fee period.
1407 
1408 -----------------------------------------------------------------
1409 */
1410 
1411 
1412 /**
1413  * @title A contract to hold escrowed havvens and free them at given schedules.
1414  */
1415 contract HavvenEscrow is SafeDecimalMath, Owned, LimitedSetup(8 weeks) {
1416     /* The corresponding Havven contract. */
1417     Havven public havven;
1418 
1419     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
1420      * These are the times at which each given quantity of havvens vests. */
1421     mapping(address => uint[2][]) public vestingSchedules;
1422 
1423     /* An account's total vested havven balance to save recomputing this for fee extraction purposes. */
1424     mapping(address => uint) public totalVestedAccountBalance;
1425 
1426     /* The total remaining vested balance, for verifying the actual havven balance of this contract against. */
1427     uint public totalVestedBalance;
1428 
1429     uint constant TIME_INDEX = 0;
1430     uint constant QUANTITY_INDEX = 1;
1431 
1432     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
1433     uint constant MAX_VESTING_ENTRIES = 20;
1434 
1435 
1436     /* ========== CONSTRUCTOR ========== */
1437 
1438     constructor(address _owner, Havven _havven)
1439         Owned(_owner)
1440         public
1441     {
1442         havven = _havven;
1443     }
1444 
1445 
1446     /* ========== SETTERS ========== */
1447 
1448     function setHavven(Havven _havven)
1449         external
1450         onlyOwner
1451     {
1452         havven = _havven;
1453         emit HavvenUpdated(_havven);
1454     }
1455 
1456 
1457     /* ========== VIEW FUNCTIONS ========== */
1458 
1459     /**
1460      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
1461      */
1462     function balanceOf(address account)
1463         public
1464         view
1465         returns (uint)
1466     {
1467         return totalVestedAccountBalance[account];
1468     }
1469 
1470     /**
1471      * @notice The number of vesting dates in an account's schedule.
1472      */
1473     function numVestingEntries(address account)
1474         public
1475         view
1476         returns (uint)
1477     {
1478         return vestingSchedules[account].length;
1479     }
1480 
1481     /**
1482      * @notice Get a particular schedule entry for an account.
1483      * @return A pair of uints: (timestamp, havven quantity).
1484      */
1485     function getVestingScheduleEntry(address account, uint index)
1486         public
1487         view
1488         returns (uint[2])
1489     {
1490         return vestingSchedules[account][index];
1491     }
1492 
1493     /**
1494      * @notice Get the time at which a given schedule entry will vest.
1495      */
1496     function getVestingTime(address account, uint index)
1497         public
1498         view
1499         returns (uint)
1500     {
1501         return getVestingScheduleEntry(account,index)[TIME_INDEX];
1502     }
1503 
1504     /**
1505      * @notice Get the quantity of havvens associated with a given schedule entry.
1506      */
1507     function getVestingQuantity(address account, uint index)
1508         public
1509         view
1510         returns (uint)
1511     {
1512         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
1513     }
1514 
1515     /**
1516      * @notice Obtain the index of the next schedule entry that will vest for a given user.
1517      */
1518     function getNextVestingIndex(address account)
1519         public
1520         view
1521         returns (uint)
1522     {
1523         uint len = numVestingEntries(account);
1524         for (uint i = 0; i < len; i++) {
1525             if (getVestingTime(account, i) != 0) {
1526                 return i;
1527             }
1528         }
1529         return len;
1530     }
1531 
1532     /**
1533      * @notice Obtain the next schedule entry that will vest for a given user.
1534      * @return A pair of uints: (timestamp, havven quantity). */
1535     function getNextVestingEntry(address account)
1536         public
1537         view
1538         returns (uint[2])
1539     {
1540         uint index = getNextVestingIndex(account);
1541         if (index == numVestingEntries(account)) {
1542             return [uint(0), 0];
1543         }
1544         return getVestingScheduleEntry(account, index);
1545     }
1546 
1547     /**
1548      * @notice Obtain the time at which the next schedule entry will vest for a given user.
1549      */
1550     function getNextVestingTime(address account)
1551         external
1552         view
1553         returns (uint)
1554     {
1555         return getNextVestingEntry(account)[TIME_INDEX];
1556     }
1557 
1558     /**
1559      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
1560      */
1561     function getNextVestingQuantity(address account)
1562         external
1563         view
1564         returns (uint)
1565     {
1566         return getNextVestingEntry(account)[QUANTITY_INDEX];
1567     }
1568 
1569 
1570     /* ========== MUTATIVE FUNCTIONS ========== */
1571 
1572     /**
1573      * @notice Withdraws a quantity of havvens back to the havven contract.
1574      * @dev This may only be called by the owner during the contract's setup period.
1575      */
1576     function withdrawHavvens(uint quantity)
1577         external
1578         onlyOwner
1579         onlyDuringSetup
1580     {
1581         havven.transfer(havven, quantity);
1582     }
1583 
1584     /**
1585      * @notice Destroy the vesting information associated with an account.
1586      */
1587     function purgeAccount(address account)
1588         external
1589         onlyOwner
1590         onlyDuringSetup
1591     {
1592         delete vestingSchedules[account];
1593         totalVestedBalance = safeSub(totalVestedBalance, totalVestedAccountBalance[account]);
1594         delete totalVestedAccountBalance[account];
1595     }
1596 
1597     /**
1598      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
1599      * @dev A call to this should be accompanied by either enough balance already available
1600      * in this contract, or a corresponding call to havven.endow(), to ensure that when
1601      * the funds are withdrawn, there is enough balance, as well as correctly calculating
1602      * the fees.
1603      * This may only be called by the owner during the contract's setup period.
1604      * Note; although this function could technically be used to produce unbounded
1605      * arrays, it's only in the foundation's command to add to these lists.
1606      * @param account The account to append a new vesting entry to.
1607      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
1608      * @param quantity The quantity of havvens that will vest.
1609      */
1610     function appendVestingEntry(address account, uint time, uint quantity)
1611         public
1612         onlyOwner
1613         onlyDuringSetup
1614     {
1615         /* No empty or already-passed vesting entries allowed. */
1616         require(now < time);
1617         require(quantity != 0);
1618 
1619         /* There must be enough balance in the contract to provide for the vesting entry. */
1620         totalVestedBalance = safeAdd(totalVestedBalance, quantity);
1621         require(totalVestedBalance <= havven.balanceOf(this));
1622 
1623         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
1624         uint scheduleLength = vestingSchedules[account].length;
1625         require(scheduleLength <= MAX_VESTING_ENTRIES);
1626 
1627         if (scheduleLength == 0) {
1628             totalVestedAccountBalance[account] = quantity;
1629         } else {
1630             /* Disallow adding new vested havvens earlier than the last one.
1631              * Since entries are only appended, this means that no vesting date can be repeated. */
1632             require(getVestingTime(account, numVestingEntries(account) - 1) < time);
1633             totalVestedAccountBalance[account] = safeAdd(totalVestedAccountBalance[account], quantity);
1634         }
1635 
1636         vestingSchedules[account].push([time, quantity]);
1637     }
1638 
1639     /**
1640      * @notice Construct a vesting schedule to release a quantities of havvens
1641      * over a series of intervals.
1642      * @dev Assumes that the quantities are nonzero
1643      * and that the sequence of timestamps is strictly increasing.
1644      * This may only be called by the owner during the contract's setup period.
1645      */
1646     function addVestingSchedule(address account, uint[] times, uint[] quantities)
1647         external
1648         onlyOwner
1649         onlyDuringSetup
1650     {
1651         for (uint i = 0; i < times.length; i++) {
1652             appendVestingEntry(account, times[i], quantities[i]);
1653         }
1654 
1655     }
1656 
1657     /**
1658      * @notice Allow a user to withdraw any havvens in their schedule that have vested.
1659      */
1660     function vest()
1661         external
1662     {
1663         uint numEntries = numVestingEntries(msg.sender);
1664         uint total;
1665         for (uint i = 0; i < numEntries; i++) {
1666             uint time = getVestingTime(msg.sender, i);
1667             /* The list is sorted; when we reach the first future time, bail out. */
1668             if (time > now) {
1669                 break;
1670             }
1671             uint qty = getVestingQuantity(msg.sender, i);
1672             if (qty == 0) {
1673                 continue;
1674             }
1675 
1676             vestingSchedules[msg.sender][i] = [0, 0];
1677             total = safeAdd(total, qty);
1678         }
1679 
1680         if (total != 0) {
1681             totalVestedBalance = safeSub(totalVestedBalance, total);
1682             totalVestedAccountBalance[msg.sender] = safeSub(totalVestedAccountBalance[msg.sender], total);
1683             havven.transfer(msg.sender, total);
1684             emit Vested(msg.sender, now, total);
1685         }
1686     }
1687 
1688 
1689     /* ========== EVENTS ========== */
1690 
1691     event HavvenUpdated(address newHavven);
1692 
1693     event Vested(address indexed beneficiary, uint time, uint value);
1694 }
1695 
1696 
1697 /*
1698 -----------------------------------------------------------------
1699 FILE INFORMATION
1700 -----------------------------------------------------------------
1701 
1702 file:       Havven.sol
1703 version:    1.2
1704 author:     Anton Jurisevic
1705             Dominic Romanowski
1706 
1707 date:       2018-05-15
1708 
1709 -----------------------------------------------------------------
1710 MODULE DESCRIPTION
1711 -----------------------------------------------------------------
1712 
1713 Havven token contract. Havvens are transferable ERC20 tokens,
1714 and also give their holders the following privileges.
1715 An owner of havvens may participate in nomin confiscation votes, they
1716 may also have the right to issue nomins at the discretion of the
1717 foundation for this version of the contract.
1718 
1719 After a fee period terminates, the duration and fees collected for that
1720 period are computed, and the next period begins. Thus an account may only
1721 withdraw the fees owed to them for the previous period, and may only do
1722 so once per period. Any unclaimed fees roll over into the common pot for
1723 the next period.
1724 
1725 == Average Balance Calculations ==
1726 
1727 The fee entitlement of a havven holder is proportional to their average
1728 issued nomin balance over the last fee period. This is computed by
1729 measuring the area under the graph of a user's issued nomin balance over
1730 time, and then when a new fee period begins, dividing through by the
1731 duration of the fee period.
1732 
1733 We need only update values when the balances of an account is modified.
1734 This occurs when issuing or burning for issued nomin balances,
1735 and when transferring for havven balances. This is for efficiency,
1736 and adds an implicit friction to interacting with havvens.
1737 A havven holder pays for his own recomputation whenever he wants to change
1738 his position, which saves the foundation having to maintain a pot dedicated
1739 to resourcing this.
1740 
1741 A hypothetical user's balance history over one fee period, pictorially:
1742 
1743       s ____
1744        |    |
1745        |    |___ p
1746        |____|___|___ __ _  _
1747        f    t   n
1748 
1749 Here, the balance was s between times f and t, at which time a transfer
1750 occurred, updating the balance to p, until n, when the present transfer occurs.
1751 When a new transfer occurs at time n, the balance being p,
1752 we must:
1753 
1754   - Add the area p * (n - t) to the total area recorded so far
1755   - Update the last transfer time to n
1756 
1757 So if this graph represents the entire current fee period,
1758 the average havvens held so far is ((t-f)*s + (n-t)*p) / (n-f).
1759 The complementary computations must be performed for both sender and
1760 recipient.
1761 
1762 Note that a transfer keeps global supply of havvens invariant.
1763 The sum of all balances is constant, and unmodified by any transfer.
1764 So the sum of all balances multiplied by the duration of a fee period is also
1765 constant, and this is equivalent to the sum of the area of every user's
1766 time/balance graph. Dividing through by that duration yields back the total
1767 havven supply. So, at the end of a fee period, we really do yield a user's
1768 average share in the havven supply over that period.
1769 
1770 A slight wrinkle is introduced if we consider the time r when the fee period
1771 rolls over. Then the previous fee period k-1 is before r, and the current fee
1772 period k is afterwards. If the last transfer took place before r,
1773 but the latest transfer occurred afterwards:
1774 
1775 k-1       |        k
1776       s __|_
1777        |  | |
1778        |  | |____ p
1779        |__|_|____|___ __ _  _
1780           |
1781        f  | t    n
1782           r
1783 
1784 In this situation the area (r-f)*s contributes to fee period k-1, while
1785 the area (t-r)*s contributes to fee period k. We will implicitly consider a
1786 zero-value transfer to have occurred at time r. Their fee entitlement for the
1787 previous period will be finalised at the time of their first transfer during the
1788 current fee period, or when they query or withdraw their fee entitlement.
1789 
1790 In the implementation, the duration of different fee periods may be slightly irregular,
1791 as the check that they have rolled over occurs only when state-changing havven
1792 operations are performed.
1793 
1794 == Issuance and Burning ==
1795 
1796 In this version of the havven contract, nomins can only be issued by
1797 those that have been nominated by the havven foundation. Nomins are assumed
1798 to be valued at $1, as they are a stable unit of account.
1799 
1800 All nomins issued require a proportional value of havvens to be locked,
1801 where the proportion is governed by the current issuance ratio. This
1802 means for every $1 of Havvens locked up, $(issuanceRatio) nomins can be issued.
1803 i.e. to issue 100 nomins, 100/issuanceRatio dollars of havvens need to be locked up.
1804 
1805 To determine the value of some amount of havvens(H), an oracle is used to push
1806 the price of havvens (P_H) in dollars to the contract. The value of H
1807 would then be: H * P_H.
1808 
1809 Any havvens that are locked up by this issuance process cannot be transferred.
1810 The amount that is locked floats based on the price of havvens. If the price
1811 of havvens moves up, less havvens are locked, so they can be issued against,
1812 or transferred freely. If the price of havvens moves down, more havvens are locked,
1813 even going above the initial wallet balance.
1814 
1815 -----------------------------------------------------------------
1816 */
1817 
1818 
1819 /**
1820  * @title Havven ERC20 contract.
1821  * @notice The Havven contracts does not only facilitate transfers and track balances,
1822  * but it also computes the quantity of fees each havven holder is entitled to.
1823  */
1824 contract Havven is ExternStateToken {
1825 
1826     /* ========== STATE VARIABLES ========== */
1827 
1828     /* A struct for handing values associated with average balance calculations */
1829     struct IssuanceData {
1830         /* Sums of balances*duration in the current fee period.
1831         /* range: decimals; units: havven-seconds */
1832         uint currentBalanceSum;
1833         /* The last period's average balance */
1834         uint lastAverageBalance;
1835         /* The last time the data was calculated */
1836         uint lastModified;
1837     }
1838 
1839     /* Issued nomin balances for individual fee entitlements */
1840     mapping(address => IssuanceData) public issuanceData;
1841     /* The total number of issued nomins for determining fee entitlements */
1842     IssuanceData public totalIssuanceData;
1843 
1844     /* The time the current fee period began */
1845     uint public feePeriodStartTime;
1846     /* The time the last fee period began */
1847     uint public lastFeePeriodStartTime;
1848 
1849     /* Fee periods will roll over in no shorter a time than this. 
1850      * The fee period cannot actually roll over until a fee-relevant
1851      * operation such as withdrawal or a fee period duration update occurs,
1852      * so this is just a target, and the actual duration may be slightly longer. */
1853     uint public feePeriodDuration = 4 weeks;
1854     /* ...and must target between 1 day and six months. */
1855     uint constant MIN_FEE_PERIOD_DURATION = 1 days;
1856     uint constant MAX_FEE_PERIOD_DURATION = 26 weeks;
1857 
1858     /* The quantity of nomins that were in the fee pot at the time */
1859     /* of the last fee rollover, at feePeriodStartTime. */
1860     uint public lastFeesCollected;
1861 
1862     /* Whether a user has withdrawn their last fees */
1863     mapping(address => bool) public hasWithdrawnFees;
1864 
1865     Nomin public nomin;
1866     HavvenEscrow public escrow;
1867 
1868     /* The address of the oracle which pushes the havven price to this contract */
1869     address public oracle;
1870     /* The price of havvens written in UNIT */
1871     uint public price;
1872     /* The time the havven price was last updated */
1873     uint public lastPriceUpdateTime;
1874     /* How long will the contract assume the price of havvens is correct */
1875     uint public priceStalePeriod = 3 hours;
1876 
1877     /* A quantity of nomins greater than this ratio
1878      * may not be issued against a given value of havvens. */
1879     uint public issuanceRatio = UNIT / 5;
1880     /* No more nomins may be issued than the value of havvens backing them. */
1881     uint constant MAX_ISSUANCE_RATIO = UNIT;
1882 
1883     /* Whether the address can issue nomins or not. */
1884     mapping(address => bool) public isIssuer;
1885     /* The number of currently-outstanding nomins the user has issued. */
1886     mapping(address => uint) public nominsIssued;
1887 
1888     uint constant HAVVEN_SUPPLY = 1e8 * UNIT;
1889     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
1890     string constant TOKEN_NAME = "Havven";
1891     string constant TOKEN_SYMBOL = "HAV";
1892     
1893     /* ========== CONSTRUCTOR ========== */
1894 
1895     /**
1896      * @dev Constructor
1897      * @param _tokenState A pre-populated contract containing token balances.
1898      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
1899      * @param _owner The owner of this contract.
1900      */
1901     constructor(address _proxy, TokenState _tokenState, address _owner, address _oracle,
1902                 uint _price, address[] _issuers, Havven _oldHavven)
1903         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, HAVVEN_SUPPLY, _owner)
1904         public
1905     {
1906         oracle = _oracle;
1907         price = _price;
1908         lastPriceUpdateTime = now;
1909 
1910         uint i;
1911         if (_oldHavven == address(0)) {
1912             feePeriodStartTime = now;
1913             lastFeePeriodStartTime = now - feePeriodDuration;
1914             for (i = 0; i < _issuers.length; i++) {
1915                 isIssuer[_issuers[i]] = true;
1916             }
1917         } else {
1918             feePeriodStartTime = _oldHavven.feePeriodStartTime();
1919             lastFeePeriodStartTime = _oldHavven.lastFeePeriodStartTime();
1920 
1921             uint cbs;
1922             uint lab;
1923             uint lm;
1924             (cbs, lab, lm) = _oldHavven.totalIssuanceData();
1925             totalIssuanceData.currentBalanceSum = cbs;
1926             totalIssuanceData.lastAverageBalance = lab;
1927             totalIssuanceData.lastModified = lm;
1928 
1929             for (i = 0; i < _issuers.length; i++) {
1930                 address issuer = _issuers[i];
1931                 isIssuer[issuer] = true;
1932                 uint nomins = _oldHavven.nominsIssued(issuer);
1933                 if (nomins == 0) {
1934                     // It is not valid in general to skip those with no currently-issued nomins.
1935                     // But for this release, issuers with nonzero issuanceData have current issuance.
1936                     continue;
1937                 }
1938                 (cbs, lab, lm) = _oldHavven.issuanceData(issuer);
1939                 nominsIssued[issuer] = nomins;
1940                 issuanceData[issuer].currentBalanceSum = cbs;
1941                 issuanceData[issuer].lastAverageBalance = lab;
1942                 issuanceData[issuer].lastModified = lm;
1943             }
1944         }
1945 
1946     }
1947 
1948     /* ========== SETTERS ========== */
1949 
1950     /**
1951      * @notice Set the associated Nomin contract to collect fees from.
1952      * @dev Only the contract owner may call this.
1953      */
1954     function setNomin(Nomin _nomin)
1955         external
1956         optionalProxy_onlyOwner
1957     {
1958         nomin = _nomin;
1959         emitNominUpdated(_nomin);
1960     }
1961 
1962     /**
1963      * @notice Set the associated havven escrow contract.
1964      * @dev Only the contract owner may call this.
1965      */
1966     function setEscrow(HavvenEscrow _escrow)
1967         external
1968         optionalProxy_onlyOwner
1969     {
1970         escrow = _escrow;
1971         emitEscrowUpdated(_escrow);
1972     }
1973 
1974     /**
1975      * @notice Set the targeted fee period duration.
1976      * @dev Only callable by the contract owner. The duration must fall within
1977      * acceptable bounds (1 day to 26 weeks). Upon resetting this the fee period
1978      * may roll over if the target duration was shortened sufficiently.
1979      */
1980     function setFeePeriodDuration(uint duration)
1981         external
1982         optionalProxy_onlyOwner
1983     {
1984         require(MIN_FEE_PERIOD_DURATION <= duration &&
1985                                duration <= MAX_FEE_PERIOD_DURATION);
1986         feePeriodDuration = duration;
1987         emitFeePeriodDurationUpdated(duration);
1988         rolloverFeePeriodIfElapsed();
1989     }
1990 
1991     /**
1992      * @notice Set the Oracle that pushes the havven price to this contract
1993      */
1994     function setOracle(address _oracle)
1995         external
1996         optionalProxy_onlyOwner
1997     {
1998         oracle = _oracle;
1999         emitOracleUpdated(_oracle);
2000     }
2001 
2002     /**
2003      * @notice Set the stale period on the updated havven price
2004      * @dev No max/minimum, as changing it wont influence anything but issuance by the foundation
2005      */
2006     function setPriceStalePeriod(uint time)
2007         external
2008         optionalProxy_onlyOwner
2009     {
2010         priceStalePeriod = time;
2011     }
2012 
2013     /**
2014      * @notice Set the issuanceRatio for issuance calculations.
2015      * @dev Only callable by the contract owner.
2016      */
2017     function setIssuanceRatio(uint _issuanceRatio)
2018         external
2019         optionalProxy_onlyOwner
2020     {
2021         require(_issuanceRatio <= MAX_ISSUANCE_RATIO);
2022         issuanceRatio = _issuanceRatio;
2023         emitIssuanceRatioUpdated(_issuanceRatio);
2024     }
2025 
2026     /**
2027      * @notice Set whether the specified can issue nomins or not.
2028      */
2029     function setIssuer(address account, bool value)
2030         external
2031         optionalProxy_onlyOwner
2032     {
2033         isIssuer[account] = value;
2034         emitIssuersUpdated(account, value);
2035     }
2036 
2037     /* ========== VIEWS ========== */
2038 
2039     function issuanceCurrentBalanceSum(address account)
2040         external
2041         view
2042         returns (uint)
2043     {
2044         return issuanceData[account].currentBalanceSum;
2045     }
2046 
2047     function issuanceLastAverageBalance(address account)
2048         external
2049         view
2050         returns (uint)
2051     {
2052         return issuanceData[account].lastAverageBalance;
2053     }
2054 
2055     function issuanceLastModified(address account)
2056         external
2057         view
2058         returns (uint)
2059     {
2060         return issuanceData[account].lastModified;
2061     }
2062 
2063     function totalIssuanceCurrentBalanceSum()
2064         external
2065         view
2066         returns (uint)
2067     {
2068         return totalIssuanceData.currentBalanceSum;
2069     }
2070 
2071     function totalIssuanceLastAverageBalance()
2072         external
2073         view
2074         returns (uint)
2075     {
2076         return totalIssuanceData.lastAverageBalance;
2077     }
2078 
2079     function totalIssuanceLastModified()
2080         external
2081         view
2082         returns (uint)
2083     {
2084         return totalIssuanceData.lastModified;
2085     }
2086 
2087     /* ========== MUTATIVE FUNCTIONS ========== */
2088 
2089     /**
2090      * @notice ERC20 transfer function.
2091      */
2092     function transfer(address to, uint value)
2093         public
2094         optionalProxy
2095         returns (bool)
2096     {
2097         address sender = messageSender;
2098         require(nominsIssued[sender] == 0 || value <= transferableHavvens(sender));
2099         /* Perform the transfer: if there is a problem,
2100          * an exception will be thrown in this call. */
2101         _transfer_byProxy(sender, to, value);
2102 
2103         return true;
2104     }
2105 
2106     /**
2107      * @notice ERC20 transferFrom function.
2108      */
2109     function transferFrom(address from, address to, uint value)
2110         public
2111         optionalProxy
2112         returns (bool)
2113     {
2114         address sender = messageSender;
2115         require(nominsIssued[from] == 0 || value <= transferableHavvens(from));
2116         /* Perform the transfer: if there is a problem,
2117          * an exception will be thrown in this call. */
2118         _transferFrom_byProxy(sender, from, to, value);
2119 
2120         return true;
2121     }
2122 
2123     /**
2124      * @notice Compute the last period's fee entitlement for the message sender
2125      * and then deposit it into their nomin account.
2126      */
2127     function withdrawFees()
2128         external
2129         optionalProxy
2130     {
2131         address sender = messageSender;
2132         rolloverFeePeriodIfElapsed();
2133         /* Do not deposit fees into frozen accounts. */
2134         require(!nomin.frozen(sender));
2135 
2136         /* Check the period has rolled over first. */
2137         updateIssuanceData(sender, nominsIssued[sender], nomin.totalSupply());
2138 
2139         /* Only allow accounts to withdraw fees once per period. */
2140         require(!hasWithdrawnFees[sender]);
2141 
2142         uint feesOwed;
2143         uint lastTotalIssued = totalIssuanceData.lastAverageBalance;
2144 
2145         if (lastTotalIssued > 0) {
2146             /* Sender receives a share of last period's collected fees proportional
2147              * with their average fraction of the last period's issued nomins. */
2148             feesOwed = safeDiv_dec(
2149                 safeMul_dec(issuanceData[sender].lastAverageBalance, lastFeesCollected),
2150                 lastTotalIssued
2151             );
2152         }
2153 
2154         hasWithdrawnFees[sender] = true;
2155 
2156         if (feesOwed != 0) {
2157             nomin.withdrawFees(sender, feesOwed);
2158         }
2159         emitFeesWithdrawn(messageSender, feesOwed);
2160     }
2161 
2162     /**
2163      * @notice Update the havven balance averages since the last transfer
2164      * or entitlement adjustment.
2165      * @dev Since this updates the last transfer timestamp, if invoked
2166      * consecutively, this function will do nothing after the first call.
2167      * Also, this will adjust the total issuance at the same time.
2168      */
2169     function updateIssuanceData(address account, uint preBalance, uint lastTotalSupply)
2170         internal
2171     {
2172         /* update the total balances first */
2173         totalIssuanceData = computeIssuanceData(lastTotalSupply, totalIssuanceData);
2174 
2175         if (issuanceData[account].lastModified < feePeriodStartTime) {
2176             hasWithdrawnFees[account] = false;
2177         }
2178 
2179         issuanceData[account] = computeIssuanceData(preBalance, issuanceData[account]);
2180     }
2181 
2182 
2183     /**
2184      * @notice Compute the new IssuanceData on the old balance
2185      */
2186     function computeIssuanceData(uint preBalance, IssuanceData preIssuance)
2187         internal
2188         view
2189         returns (IssuanceData)
2190     {
2191 
2192         uint currentBalanceSum = preIssuance.currentBalanceSum;
2193         uint lastAverageBalance = preIssuance.lastAverageBalance;
2194         uint lastModified = preIssuance.lastModified;
2195 
2196         if (lastModified < feePeriodStartTime) {
2197             if (lastModified < lastFeePeriodStartTime) {
2198                 /* The balance was last updated before the previous fee period, so the average
2199                  * balance in this period is their pre-transfer balance. */
2200                 lastAverageBalance = preBalance;
2201             } else {
2202                 /* The balance was last updated during the previous fee period. */
2203                 /* No overflow or zero denominator problems, since lastFeePeriodStartTime < feePeriodStartTime < lastModified. 
2204                  * implies these quantities are strictly positive. */
2205                 uint timeUpToRollover = feePeriodStartTime - lastModified;
2206                 uint lastFeePeriodDuration = feePeriodStartTime - lastFeePeriodStartTime;
2207                 uint lastBalanceSum = safeAdd(currentBalanceSum, safeMul(preBalance, timeUpToRollover));
2208                 lastAverageBalance = lastBalanceSum / lastFeePeriodDuration;
2209             }
2210             /* Roll over to the next fee period. */
2211             currentBalanceSum = safeMul(preBalance, now - feePeriodStartTime);
2212         } else {
2213             /* The balance was last updated during the current fee period. */
2214             currentBalanceSum = safeAdd(
2215                 currentBalanceSum,
2216                 safeMul(preBalance, now - lastModified)
2217             );
2218         }
2219 
2220         return IssuanceData(currentBalanceSum, lastAverageBalance, now);
2221     }
2222 
2223     /**
2224      * @notice Recompute and return the given account's last average balance.
2225      */
2226     function recomputeLastAverageBalance(address account)
2227         external
2228         returns (uint)
2229     {
2230         updateIssuanceData(account, nominsIssued[account], nomin.totalSupply());
2231         return issuanceData[account].lastAverageBalance;
2232     }
2233 
2234     /**
2235      * @notice Issue nomins against the sender's havvens.
2236      * @dev Issuance is only allowed if the havven price isn't stale and the sender is an issuer.
2237      */
2238     function issueNomins(uint amount)
2239         public
2240         optionalProxy
2241         requireIssuer(messageSender)
2242         /* No need to check if price is stale, as it is checked in issuableNomins. */
2243     {
2244         address sender = messageSender;
2245         require(amount <= remainingIssuableNomins(sender));
2246         uint lastTot = nomin.totalSupply();
2247         uint preIssued = nominsIssued[sender];
2248         nomin.issue(sender, amount);
2249         nominsIssued[sender] = safeAdd(preIssued, amount);
2250         updateIssuanceData(sender, preIssued, lastTot);
2251     }
2252 
2253     function issueMaxNomins()
2254         external
2255         optionalProxy
2256     {
2257         issueNomins(remainingIssuableNomins(messageSender));
2258     }
2259 
2260     /**
2261      * @notice Burn nomins to clear issued nomins/free havvens.
2262      */
2263     function burnNomins(uint amount)
2264         /* it doesn't matter if the price is stale or if the user is an issuer, as non-issuers have issued no nomins.*/
2265         external
2266         optionalProxy
2267     {
2268         address sender = messageSender;
2269 
2270         uint lastTot = nomin.totalSupply();
2271         uint preIssued = nominsIssued[sender];
2272         /* nomin.burn does a safeSub on balance (so it will revert if there are not enough nomins). */
2273         nomin.burn(sender, amount);
2274         /* This safe sub ensures amount <= number issued */
2275         nominsIssued[sender] = safeSub(preIssued, amount);
2276         updateIssuanceData(sender, preIssued, lastTot);
2277     }
2278 
2279     /**
2280      * @notice Check if the fee period has rolled over. If it has, set the new fee period start
2281      * time, and record the fees collected in the nomin contract.
2282      */
2283     function rolloverFeePeriodIfElapsed()
2284         public
2285     {
2286         /* If the fee period has rolled over... */
2287         if (now >= feePeriodStartTime + feePeriodDuration) {
2288             lastFeesCollected = nomin.feePool();
2289             lastFeePeriodStartTime = feePeriodStartTime;
2290             feePeriodStartTime = now;
2291             emitFeePeriodRollover(now);
2292         }
2293     }
2294 
2295     /* ========== Issuance/Burning ========== */
2296 
2297     /**
2298      * @notice The maximum nomins an issuer can issue against their total havven quantity. This ignores any
2299      * already issued nomins.
2300      */
2301     function maxIssuableNomins(address issuer)
2302         view
2303         public
2304         priceNotStale
2305         returns (uint)
2306     {
2307         if (!isIssuer[issuer]) {
2308             return 0;
2309         }
2310         if (escrow != HavvenEscrow(0)) {
2311             uint totalOwnedHavvens = safeAdd(tokenState.balanceOf(issuer), escrow.balanceOf(issuer));
2312             return safeMul_dec(HAVtoUSD(totalOwnedHavvens), issuanceRatio);
2313         } else {
2314             return safeMul_dec(HAVtoUSD(tokenState.balanceOf(issuer)), issuanceRatio);
2315         }
2316     }
2317 
2318     /**
2319      * @notice The remaining nomins an issuer can issue against their total havven quantity.
2320      */
2321     function remainingIssuableNomins(address issuer)
2322         view
2323         public
2324         returns (uint)
2325     {
2326         uint issued = nominsIssued[issuer];
2327         uint max = maxIssuableNomins(issuer);
2328         if (issued > max) {
2329             return 0;
2330         } else {
2331             return safeSub(max, issued);
2332         }
2333     }
2334 
2335     /**
2336      * @notice The total havvens owned by this account, both escrowed and unescrowed,
2337      * against which nomins can be issued.
2338      * This includes those already being used as collateral (locked), and those
2339      * available for further issuance (unlocked).
2340      */
2341     function collateral(address account)
2342         public
2343         view
2344         returns (uint)
2345     {
2346         uint bal = tokenState.balanceOf(account);
2347         if (escrow != address(0)) {
2348             bal = safeAdd(bal, escrow.balanceOf(account));
2349         }
2350         return bal;
2351     }
2352 
2353     /**
2354      * @notice The collateral that would be locked by issuance, which can exceed the account's actual collateral.
2355      */
2356     function issuanceDraft(address account)
2357         public
2358         view
2359         returns (uint)
2360     {
2361         uint issued = nominsIssued[account];
2362         if (issued == 0) {
2363             return 0;
2364         }
2365         return USDtoHAV(safeDiv_dec(issued, issuanceRatio));
2366     }
2367 
2368     /**
2369      * @notice Collateral that has been locked due to issuance, and cannot be
2370      * transferred to other addresses. This is capped at the account's total collateral.
2371      */
2372     function lockedCollateral(address account)
2373         public
2374         view
2375         returns (uint)
2376     {
2377         uint debt = issuanceDraft(account);
2378         uint collat = collateral(account);
2379         if (debt > collat) {
2380             return collat;
2381         }
2382         return debt;
2383     }
2384 
2385     /**
2386      * @notice Collateral that is not locked and available for issuance.
2387      */
2388     function unlockedCollateral(address account)
2389         public
2390         view
2391         returns (uint)
2392     {
2393         uint locked = lockedCollateral(account);
2394         uint collat = collateral(account);
2395         return safeSub(collat, locked);
2396     }
2397 
2398     /**
2399      * @notice The number of havvens that are free to be transferred by an account.
2400      * @dev If they have enough available Havvens, it could be that
2401      * their havvens are escrowed, however the transfer would then
2402      * fail. This means that escrowed havvens are locked first,
2403      * and then the actual transferable ones.
2404      */
2405     function transferableHavvens(address account)
2406         public
2407         view
2408         returns (uint)
2409     {
2410         uint draft = issuanceDraft(account);
2411         uint collat = collateral(account);
2412         // In the case where the issuanceDraft exceeds the collateral, nothing is free
2413         if (draft > collat) {
2414             return 0;
2415         }
2416 
2417         uint bal = balanceOf(account);
2418         // In the case where the draft exceeds the escrow, but not the whole collateral
2419         //   return the fraction of the balance that remains free
2420         if (draft > safeSub(collat, bal)) {
2421             return safeSub(collat, draft);
2422         }
2423         // In the case where the draft doesn't exceed the escrow, return the entire balance
2424         return bal;
2425     }
2426 
2427     /**
2428      * @notice The value in USD for a given amount of HAV
2429      */
2430     function HAVtoUSD(uint hav_dec)
2431         public
2432         view
2433         priceNotStale
2434         returns (uint)
2435     {
2436         return safeMul_dec(hav_dec, price);
2437     }
2438 
2439     /**
2440      * @notice The value in HAV for a given amount of USD
2441      */
2442     function USDtoHAV(uint usd_dec)
2443         public
2444         view
2445         priceNotStale
2446         returns (uint)
2447     {
2448         return safeDiv_dec(usd_dec, price);
2449     }
2450 
2451     /**
2452      * @notice Access point for the oracle to update the price of havvens.
2453      */
2454     function updatePrice(uint newPrice, uint timeSent)
2455         external
2456         onlyOracle  /* Should be callable only by the oracle. */
2457     {
2458         /* Must be the most recently sent price, but not too far in the future.
2459          * (so we can't lock ourselves out of updating the oracle for longer than this) */
2460         require(lastPriceUpdateTime < timeSent && timeSent < now + ORACLE_FUTURE_LIMIT);
2461 
2462         price = newPrice;
2463         lastPriceUpdateTime = timeSent;
2464         emitPriceUpdated(newPrice, timeSent);
2465 
2466         /* Check the fee period rollover within this as the price should be pushed every 15min. */
2467         rolloverFeePeriodIfElapsed();
2468     }
2469 
2470     /**
2471      * @notice Check if the price of havvens hasn't been updated for longer than the stale period.
2472      */
2473     function priceIsStale()
2474         public
2475         view
2476         returns (bool)
2477     {
2478         return safeAdd(lastPriceUpdateTime, priceStalePeriod) < now;
2479     }
2480 
2481     /* ========== MODIFIERS ========== */
2482 
2483     modifier requireIssuer(address account)
2484     {
2485         require(isIssuer[account]);
2486         _;
2487     }
2488 
2489     modifier onlyOracle
2490     {
2491         require(msg.sender == oracle);
2492         _;
2493     }
2494 
2495     modifier priceNotStale
2496     {
2497         require(!priceIsStale());
2498         _;
2499     }
2500 
2501     /* ========== EVENTS ========== */
2502 
2503     event PriceUpdated(uint newPrice, uint timestamp);
2504     bytes32 constant PRICEUPDATED_SIG = keccak256("PriceUpdated(uint256,uint256)");
2505     function emitPriceUpdated(uint newPrice, uint timestamp) internal {
2506         proxy._emit(abi.encode(newPrice, timestamp), 1, PRICEUPDATED_SIG, 0, 0, 0);
2507     }
2508 
2509     event IssuanceRatioUpdated(uint newRatio);
2510     bytes32 constant ISSUANCERATIOUPDATED_SIG = keccak256("IssuanceRatioUpdated(uint256)");
2511     function emitIssuanceRatioUpdated(uint newRatio) internal {
2512         proxy._emit(abi.encode(newRatio), 1, ISSUANCERATIOUPDATED_SIG, 0, 0, 0);
2513     }
2514 
2515     event FeePeriodRollover(uint timestamp);
2516     bytes32 constant FEEPERIODROLLOVER_SIG = keccak256("FeePeriodRollover(uint256)");
2517     function emitFeePeriodRollover(uint timestamp) internal {
2518         proxy._emit(abi.encode(timestamp), 1, FEEPERIODROLLOVER_SIG, 0, 0, 0);
2519     } 
2520 
2521     event FeePeriodDurationUpdated(uint duration);
2522     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
2523     function emitFeePeriodDurationUpdated(uint duration) internal {
2524         proxy._emit(abi.encode(duration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
2525     } 
2526 
2527     event FeesWithdrawn(address indexed account, uint value);
2528     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
2529     function emitFeesWithdrawn(address account, uint value) internal {
2530         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
2531     }
2532 
2533     event OracleUpdated(address newOracle);
2534     bytes32 constant ORACLEUPDATED_SIG = keccak256("OracleUpdated(address)");
2535     function emitOracleUpdated(address newOracle) internal {
2536         proxy._emit(abi.encode(newOracle), 1, ORACLEUPDATED_SIG, 0, 0, 0);
2537     }
2538 
2539     event NominUpdated(address newNomin);
2540     bytes32 constant NOMINUPDATED_SIG = keccak256("NominUpdated(address)");
2541     function emitNominUpdated(address newNomin) internal {
2542         proxy._emit(abi.encode(newNomin), 1, NOMINUPDATED_SIG, 0, 0, 0);
2543     }
2544 
2545     event EscrowUpdated(address newEscrow);
2546     bytes32 constant ESCROWUPDATED_SIG = keccak256("EscrowUpdated(address)");
2547     function emitEscrowUpdated(address newEscrow) internal {
2548         proxy._emit(abi.encode(newEscrow), 1, ESCROWUPDATED_SIG, 0, 0, 0);
2549     }
2550 
2551     event IssuersUpdated(address indexed account, bool indexed value);
2552     bytes32 constant ISSUERSUPDATED_SIG = keccak256("IssuersUpdated(address,bool)");
2553     function emitIssuersUpdated(address account, bool value) internal {
2554         proxy._emit(abi.encode(), 3, ISSUERSUPDATED_SIG, bytes32(account), bytes32(value ? 1 : 0), 0);
2555     }
2556 
2557 }
2558 
2559 
2560 /*
2561 -----------------------------------------------------------------
2562 FILE INFORMATION
2563 -----------------------------------------------------------------
2564 
2565 file:       Court.sol
2566 version:    1.2
2567 author:     Anton Jurisevic
2568             Mike Spain
2569             Dominic Romanowski
2570 
2571 date:       2018-05-29
2572 
2573 -----------------------------------------------------------------
2574 MODULE DESCRIPTION
2575 -----------------------------------------------------------------
2576 
2577 This provides the nomin contract with a confiscation
2578 facility, if enough havven owners vote to confiscate a target
2579 account's nomins.
2580 
2581 This is designed to provide a mechanism to respond to abusive
2582 contracts such as nomin wrappers, which would allow users to
2583 trade wrapped nomins without accruing fees on those transactions.
2584 
2585 In order to prevent tyranny, an account may only be frozen if
2586 users controlling at least 30% of the value of havvens participate,
2587 and a two thirds majority is attained in that vote.
2588 In order to prevent tyranny of the majority or mob justice,
2589 confiscation motions are only approved if the havven foundation
2590 approves the result.
2591 This latter requirement may be lifted in future versions.
2592 
2593 The foundation, or any user with a sufficient havven balance may
2594 bring a confiscation motion.
2595 A motion lasts for a default period of one week, with a further
2596 confirmation period in which the foundation approves the result.
2597 The latter period may conclude early upon the foundation's decision
2598 to either veto or approve the mooted confiscation motion.
2599 If the confirmation period elapses without the foundation making
2600 a decision, the motion fails.
2601 
2602 The weight of a havven holder's vote is determined by examining
2603 their average balance over the last completed fee period prior to
2604 the beginning of a given motion.
2605 
2606 Thus, since a fee period can roll over in the middle of a motion,
2607 we must also track a user's average balance of the last two periods.
2608 This system is designed such that it cannot be attacked by users
2609 transferring funds between themselves, while also not requiring them
2610 to lock their havvens for the duration of the vote. This is possible
2611 since any transfer that increases the average balance in one account
2612 will be reflected by an equivalent reduction in the voting weight in
2613 the other.
2614 
2615 At present a user may cast a vote only for one motion at a time,
2616 but may cancel their vote at any time except during the confirmation period,
2617 when the vote tallies must remain static until the matter has been settled.
2618 
2619 A motion to confiscate the balance of a given address composes
2620 a state machine built of the following states:
2621 
2622 Waiting:
2623   - A user with standing brings a motion:
2624     If the target address is not frozen;
2625     initialise vote tallies to 0;
2626     transition to the Voting state.
2627 
2628   - An account cancels a previous residual vote:
2629     remain in the Waiting state.
2630 
2631 Voting:
2632   - The foundation vetoes the in-progress motion:
2633     transition to the Waiting state.
2634 
2635   - The voting period elapses:
2636     transition to the Confirmation state.
2637 
2638   - An account votes (for or against the motion):
2639     its weight is added to the appropriate tally;
2640     remain in the Voting state.
2641 
2642   - An account cancels its previous vote:
2643     its weight is deducted from the appropriate tally (if any);
2644     remain in the Voting state.
2645 
2646 Confirmation:
2647   - The foundation vetoes the completed motion:
2648     transition to the Waiting state.
2649 
2650   - The foundation approves confiscation of the target account:
2651     freeze the target account, transfer its nomin balance to the fee pool;
2652     transition to the Waiting state.
2653 
2654   - The confirmation period elapses:
2655     transition to the Waiting state.
2656 
2657 User votes are not automatically cancelled upon the conclusion of a motion.
2658 Therefore, after a motion comes to a conclusion, if a user wishes to vote
2659 in another motion, they must manually cancel their vote in order to do so.
2660 
2661 This procedure is designed to be relatively simple.
2662 There are some things that can be added to enhance the functionality
2663 at the expense of simplicity and efficiency:
2664 
2665   - Democratic unfreezing of nomin accounts (induces multiple categories of vote)
2666   - Configurable per-vote durations;
2667   - Vote standing denominated in a fiat quantity rather than a quantity of havvens;
2668   - Confiscate from multiple addresses in a single vote;
2669 
2670 We might consider updating the contract with any of these features at a later date if necessary.
2671 
2672 -----------------------------------------------------------------
2673 */
2674 
2675 
2676 /**
2677  * @title A court contract allowing a democratic mechanism to dissuade token wrappers.
2678  */
2679 contract Court is SafeDecimalMath, Owned {
2680 
2681     /* ========== STATE VARIABLES ========== */
2682 
2683     /* The addresses of the token contracts this confiscation court interacts with. */
2684     Havven public havven;
2685     Nomin public nomin;
2686 
2687     /* The minimum issued nomin balance required to be considered to have
2688      * standing to begin confiscation proceedings. */
2689     uint public minStandingBalance = 100 * UNIT;
2690 
2691     /* The voting period lasts for this duration,
2692      * and if set, must fall within the given bounds. */
2693     uint public votingPeriod = 1 weeks;
2694     uint constant MIN_VOTING_PERIOD = 3 days;
2695     uint constant MAX_VOTING_PERIOD = 4 weeks;
2696 
2697     /* Duration of the period during which the foundation may confirm
2698      * or veto a motion that has concluded.
2699      * If set, the confirmation duration must fall within the given bounds. */
2700     uint public confirmationPeriod = 1 weeks;
2701     uint constant MIN_CONFIRMATION_PERIOD = 1 days;
2702     uint constant MAX_CONFIRMATION_PERIOD = 2 weeks;
2703 
2704     /* No fewer than this fraction of total available voting power must
2705      * participate in a motion in order for a quorum to be reached.
2706      * The participation fraction required may be set no lower than 10%.
2707      * As a fraction, it is expressed in terms of UNIT, not as an absolute quantity. */
2708     uint public requiredParticipation = 3 * UNIT / 10;
2709     uint constant MIN_REQUIRED_PARTICIPATION = UNIT / 10;
2710 
2711     /* At least this fraction of participating votes must be in favour of
2712      * confiscation for the motion to pass.
2713      * The required majority may be no lower than 50%.
2714      * As a fraction, it is expressed in terms of UNIT, not as an absolute quantity. */
2715     uint public requiredMajority = (2 * UNIT) / 3;
2716     uint constant MIN_REQUIRED_MAJORITY = UNIT / 2;
2717 
2718     /* The next ID to use for opening a motion. 
2719      * The 0 motion ID corresponds to no motion,
2720      * and is used as a null value for later comparison. */
2721     uint nextMotionID = 1;
2722 
2723     /* Mapping from motion IDs to target addresses. */
2724     mapping(uint => address) public motionTarget;
2725 
2726     /* The ID a motion on an address is currently operating at.
2727      * Zero if no such motion is running. */
2728     mapping(address => uint) public targetMotionID;
2729 
2730     /* The timestamp at which a motion began. This is used to determine
2731      * whether a motion is: running, in the confirmation period,
2732      * or has concluded.
2733      * A motion runs from its start time t until (t + votingPeriod),
2734      * and then the confirmation period terminates no later than
2735      * (t + votingPeriod + confirmationPeriod). */
2736     mapping(uint => uint) public motionStartTime;
2737 
2738     /* The tallies for and against confiscation of a given balance.
2739      * These are set to zero at the start of a motion, and also on conclusion,
2740      * just to keep the state clean. */
2741     mapping(uint => uint) public votesFor;
2742     mapping(uint => uint) public votesAgainst;
2743 
2744     /* The last average balance of a user at the time they voted
2745      * in a particular motion.
2746      * If we did not save this information then we would have to
2747      * disallow transfers into an account lest it cancel a vote
2748      * with greater weight than that with which it originally voted,
2749      * and the fee period rolled over in between. */
2750     // TODO: This may be unnecessary now that votes are forced to be
2751     // within a fee period. Likely possible to delete this.
2752     mapping(address => mapping(uint => uint)) voteWeight;
2753 
2754     /* The possible vote types.
2755      * Abstention: not participating in a motion; This is the default value.
2756      * Yea: voting in favour of a motion.
2757      * Nay: voting against a motion. */
2758     enum Vote {Abstention, Yea, Nay}
2759 
2760     /* A given account's vote in some confiscation motion.
2761      * This requires the default value of the Vote enum to correspond to an abstention. */
2762     mapping(address => mapping(uint => Vote)) public vote;
2763 
2764 
2765     /* ========== CONSTRUCTOR ========== */
2766 
2767     /**
2768      * @dev Court Constructor.
2769      */
2770     constructor(Havven _havven, Nomin _nomin, address _owner)
2771         Owned(_owner)
2772         public
2773     {
2774         havven = _havven;
2775         nomin = _nomin;
2776     }
2777 
2778 
2779     /* ========== SETTERS ========== */
2780 
2781     /**
2782      * @notice Set the minimum required havven balance to have standing to bring a motion.
2783      * @dev Only the contract owner may call this.
2784      */
2785     function setMinStandingBalance(uint balance)
2786         external
2787         onlyOwner
2788     {
2789         /* No requirement on the standing threshold here;
2790          * the foundation can set this value such that
2791          * anyone or no one can actually start a motion. */
2792         minStandingBalance = balance;
2793     }
2794 
2795     /**
2796      * @notice Set the length of time a vote runs for.
2797      * @dev Only the contract owner may call this. The proposed duration must fall
2798      * within sensible bounds (3 days to 4 weeks), and must be no longer than a single fee period.
2799      */
2800     function setVotingPeriod(uint duration)
2801         external
2802         onlyOwner
2803     {
2804         require(MIN_VOTING_PERIOD <= duration &&
2805                 duration <= MAX_VOTING_PERIOD);
2806         /* Require that the voting period is no longer than a single fee period,
2807          * So that a single vote can span at most two fee periods. */
2808         require(duration <= havven.feePeriodDuration());
2809         votingPeriod = duration;
2810     }
2811 
2812     /**
2813      * @notice Set the confirmation period after a vote has concluded.
2814      * @dev Only the contract owner may call this. The proposed duration must fall
2815      * within sensible bounds (1 day to 2 weeks).
2816      */
2817     function setConfirmationPeriod(uint duration)
2818         external
2819         onlyOwner
2820     {
2821         require(MIN_CONFIRMATION_PERIOD <= duration &&
2822                 duration <= MAX_CONFIRMATION_PERIOD);
2823         confirmationPeriod = duration;
2824     }
2825 
2826     /**
2827      * @notice Set the required fraction of all Havvens that need to be part of
2828      * a vote for it to pass.
2829      */
2830     function setRequiredParticipation(uint fraction)
2831         external
2832         onlyOwner
2833     {
2834         require(MIN_REQUIRED_PARTICIPATION <= fraction);
2835         requiredParticipation = fraction;
2836     }
2837 
2838     /**
2839      * @notice Set what portion of voting havvens need to be in the affirmative
2840      * to allow it to pass.
2841      */
2842     function setRequiredMajority(uint fraction)
2843         external
2844         onlyOwner
2845     {
2846         require(MIN_REQUIRED_MAJORITY <= fraction);
2847         requiredMajority = fraction;
2848     }
2849 
2850 
2851     /* ========== VIEW FUNCTIONS ========== */
2852 
2853     /**
2854      * @notice There is a motion in progress on the specified
2855      * account, and votes are being accepted in that motion.
2856      */
2857     function motionVoting(uint motionID)
2858         public
2859         view
2860         returns (bool)
2861     {
2862         return motionStartTime[motionID] < now && now < motionStartTime[motionID] + votingPeriod;
2863     }
2864 
2865     /**
2866      * @notice A vote on the target account has concluded, but the motion
2867      * has not yet been approved, vetoed, or closed. */
2868     function motionConfirming(uint motionID)
2869         public
2870         view
2871         returns (bool)
2872     {
2873         /* These values are timestamps, they will not overflow
2874          * as they can only ever be initialised to relatively small values.
2875          */
2876         uint startTime = motionStartTime[motionID];
2877         return startTime + votingPeriod <= now &&
2878                now < startTime + votingPeriod + confirmationPeriod;
2879     }
2880 
2881     /**
2882      * @notice A vote motion either not begun, or it has completely terminated.
2883      */
2884     function motionWaiting(uint motionID)
2885         public
2886         view
2887         returns (bool)
2888     {
2889         /* These values are timestamps, they will not overflow
2890          * as they can only ever be initialised to relatively small values. */
2891         return motionStartTime[motionID] + votingPeriod + confirmationPeriod <= now;
2892     }
2893 
2894     /**
2895      * @notice If the motion was to terminate at this instant, it would pass.
2896      * That is: there was sufficient participation and a sizeable enough majority.
2897      */
2898     function motionPasses(uint motionID)
2899         public
2900         view
2901         returns (bool)
2902     {
2903         uint yeas = votesFor[motionID];
2904         uint nays = votesAgainst[motionID];
2905         uint totalVotes = safeAdd(yeas, nays);
2906 
2907         if (totalVotes == 0) {
2908             return false;
2909         }
2910 
2911         uint participation = safeDiv_dec(totalVotes, havven.totalIssuanceLastAverageBalance());
2912         uint fractionInFavour = safeDiv_dec(yeas, totalVotes);
2913 
2914         /* We require the result to be strictly greater than the requirement
2915          * to enforce a majority being "50% + 1", and so on. */
2916         return participation > requiredParticipation &&
2917                fractionInFavour > requiredMajority;
2918     }
2919 
2920     /**
2921      * @notice Return if the specified account has voted on the specified motion
2922      */
2923     function hasVoted(address account, uint motionID)
2924         public
2925         view
2926         returns (bool)
2927     {
2928         return vote[account][motionID] != Vote.Abstention;
2929     }
2930 
2931 
2932     /* ========== MUTATIVE FUNCTIONS ========== */
2933 
2934     /**
2935      * @notice Begin a motion to confiscate the funds in a given nomin account.
2936      * @dev Only the foundation, or accounts with sufficient havven balances
2937      * may elect to start such a motion.
2938      * @return Returns the ID of the motion that was begun.
2939      */
2940     function beginMotion(address target)
2941         external
2942         returns (uint)
2943     {
2944         /* A confiscation motion must be mooted by someone with standing. */
2945         require((havven.issuanceLastAverageBalance(msg.sender) >= minStandingBalance) ||
2946                 msg.sender == owner);
2947 
2948         /* Require that the voting period is longer than a single fee period,
2949          * So that a single vote can span at most two fee periods. */
2950         require(votingPeriod <= havven.feePeriodDuration());
2951 
2952         /* There must be no confiscation motion already running for this account. */
2953         require(targetMotionID[target] == 0);
2954 
2955         /* Disallow votes on accounts that are currently frozen. */
2956         require(!nomin.frozen(target));
2957 
2958         /* It is necessary to roll over the fee period if it has elapsed, or else
2959          * the vote might be initialised having begun in the past. */
2960         havven.rolloverFeePeriodIfElapsed();
2961 
2962         uint motionID = nextMotionID++;
2963         motionTarget[motionID] = target;
2964         targetMotionID[target] = motionID;
2965 
2966         /* Start the vote at the start of the next fee period */
2967         uint startTime = havven.feePeriodStartTime() + havven.feePeriodDuration();
2968         motionStartTime[motionID] = startTime;
2969         emit MotionBegun(msg.sender, target, motionID, startTime);
2970 
2971         return motionID;
2972     }
2973 
2974     /**
2975      * @notice Shared vote setup function between voteFor and voteAgainst.
2976      * @return Returns the voter's vote weight. */
2977     function setupVote(uint motionID)
2978         internal
2979         returns (uint)
2980     {
2981         /* There must be an active vote for this target running.
2982          * Vote totals must only change during the voting phase. */
2983         require(motionVoting(motionID));
2984 
2985         /* The voter must not have an active vote this motion. */
2986         require(!hasVoted(msg.sender, motionID));
2987 
2988         /* The voter may not cast votes on themselves. */
2989         require(msg.sender != motionTarget[motionID]);
2990 
2991         uint weight = havven.recomputeLastAverageBalance(msg.sender);
2992 
2993         /* Users must have a nonzero voting weight to vote. */
2994         require(weight > 0);
2995 
2996         voteWeight[msg.sender][motionID] = weight;
2997 
2998         return weight;
2999     }
3000 
3001     /**
3002      * @notice The sender casts a vote in favour of confiscation of the
3003      * target account's nomin balance.
3004      */
3005     function voteFor(uint motionID)
3006         external
3007     {
3008         uint weight = setupVote(motionID);
3009         vote[msg.sender][motionID] = Vote.Yea;
3010         votesFor[motionID] = safeAdd(votesFor[motionID], weight);
3011         emit VotedFor(msg.sender, motionID, weight);
3012     }
3013 
3014     /**
3015      * @notice The sender casts a vote against confiscation of the
3016      * target account's nomin balance.
3017      */
3018     function voteAgainst(uint motionID)
3019         external
3020     {
3021         uint weight = setupVote(motionID);
3022         vote[msg.sender][motionID] = Vote.Nay;
3023         votesAgainst[motionID] = safeAdd(votesAgainst[motionID], weight);
3024         emit VotedAgainst(msg.sender, motionID, weight);
3025     }
3026 
3027     /**
3028      * @notice Cancel an existing vote by the sender on a motion
3029      * to confiscate the target balance.
3030      */
3031     function cancelVote(uint motionID)
3032         external
3033     {
3034         /* An account may cancel its vote either before the confirmation phase
3035          * when the motion is still open, or after the confirmation phase,
3036          * when the motion has concluded.
3037          * But the totals must not change during the confirmation phase itself. */
3038         require(!motionConfirming(motionID));
3039 
3040         Vote senderVote = vote[msg.sender][motionID];
3041 
3042         /* If the sender has not voted then there is no need to update anything. */
3043         require(senderVote != Vote.Abstention);
3044 
3045         /* If we are not voting, there is no reason to update the vote totals. */
3046         if (motionVoting(motionID)) {
3047             if (senderVote == Vote.Yea) {
3048                 votesFor[motionID] = safeSub(votesFor[motionID], voteWeight[msg.sender][motionID]);
3049             } else {
3050                 /* Since we already ensured that the vote is not an abstention,
3051                  * the only option remaining is Vote.Nay. */
3052                 votesAgainst[motionID] = safeSub(votesAgainst[motionID], voteWeight[msg.sender][motionID]);
3053             }
3054             /* A cancelled vote is only meaningful if a vote is running. */
3055             emit VoteCancelled(msg.sender, motionID);
3056         }
3057 
3058         delete voteWeight[msg.sender][motionID];
3059         delete vote[msg.sender][motionID];
3060     }
3061 
3062     /**
3063      * @notice clear all data associated with a motionID for hygiene purposes.
3064      */
3065     function _closeMotion(uint motionID)
3066         internal
3067     {
3068         delete targetMotionID[motionTarget[motionID]];
3069         delete motionTarget[motionID];
3070         delete motionStartTime[motionID];
3071         delete votesFor[motionID];
3072         delete votesAgainst[motionID];
3073         emit MotionClosed(motionID);
3074     }
3075 
3076     /**
3077      * @notice If a motion has concluded, or if it lasted its full duration but not passed,
3078      * then anyone may close it.
3079      */
3080     function closeMotion(uint motionID)
3081         external
3082     {
3083         require((motionConfirming(motionID) && !motionPasses(motionID)) || motionWaiting(motionID));
3084         _closeMotion(motionID);
3085     }
3086 
3087     /**
3088      * @notice The foundation may only confiscate a balance during the confirmation
3089      * period after a motion has passed.
3090      */
3091     function approveMotion(uint motionID)
3092         external
3093         onlyOwner
3094     {
3095         require(motionConfirming(motionID) && motionPasses(motionID));
3096         address target = motionTarget[motionID];
3097         nomin.freezeAndConfiscate(target);
3098         _closeMotion(motionID);
3099         emit MotionApproved(motionID);
3100     }
3101 
3102     /* @notice The foundation may veto a motion at any time. */
3103     function vetoMotion(uint motionID)
3104         external
3105         onlyOwner
3106     {
3107         require(!motionWaiting(motionID));
3108         _closeMotion(motionID);
3109         emit MotionVetoed(motionID);
3110     }
3111 
3112 
3113     /* ========== EVENTS ========== */
3114 
3115     event MotionBegun(address indexed initiator, address indexed target, uint indexed motionID, uint startTime);
3116 
3117     event VotedFor(address indexed voter, uint indexed motionID, uint weight);
3118 
3119     event VotedAgainst(address indexed voter, uint indexed motionID, uint weight);
3120 
3121     event VoteCancelled(address indexed voter, uint indexed motionID);
3122 
3123     event MotionClosed(uint indexed motionID);
3124 
3125     event MotionVetoed(uint indexed motionID);
3126 
3127     event MotionApproved(uint indexed motionID);
3128 }
3129 
3130 
3131 /*
3132 -----------------------------------------------------------------
3133 FILE INFORMATION
3134 -----------------------------------------------------------------
3135 
3136 file:       Nomin.sol
3137 version:    1.2
3138 author:     Anton Jurisevic
3139             Mike Spain
3140             Dominic Romanowski
3141             Kevin Brown
3142 
3143 date:       2018-05-29
3144 
3145 -----------------------------------------------------------------
3146 MODULE DESCRIPTION
3147 -----------------------------------------------------------------
3148 
3149 Havven-backed nomin stablecoin contract.
3150 
3151 This contract issues nomins, which are tokens worth 1 USD each.
3152 
3153 Nomins are issuable by Havven holders who have to lock up some
3154 value of their havvens to issue H * Cmax nomins. Where Cmax is
3155 some value less than 1.
3156 
3157 A configurable fee is charged on nomin transfers and deposited
3158 into a common pot, which havven holders may withdraw from once
3159 per fee period.
3160 
3161 -----------------------------------------------------------------
3162 */
3163 
3164 
3165 contract Nomin is FeeToken {
3166 
3167     /* ========== STATE VARIABLES ========== */
3168 
3169     // The address of the contract which manages confiscation votes.
3170     Court public court;
3171     Havven public havven;
3172 
3173     // Accounts which have lost the privilege to transact in nomins.
3174     mapping(address => bool) public frozen;
3175 
3176     // Nomin transfers incur a 15 bp fee by default.
3177     uint constant TRANSFER_FEE_RATE = 15 * UNIT / 10000;
3178     string constant TOKEN_NAME = "Nomin USD";
3179     string constant TOKEN_SYMBOL = "nUSD";
3180 
3181     /* ========== CONSTRUCTOR ========== */
3182 
3183     constructor(address _proxy, TokenState _tokenState, Havven _havven,
3184                 uint _totalSupply,
3185                 address _owner)
3186         FeeToken(_proxy, _tokenState,
3187                  TOKEN_NAME, TOKEN_SYMBOL, _totalSupply,
3188                  TRANSFER_FEE_RATE,
3189                  _havven, // The havven contract is the fee authority.
3190                  _owner)
3191         public
3192     {
3193         require(_proxy != 0 && address(_havven) != 0 && _owner != 0);
3194         // It should not be possible to transfer to the fee pool directly (or confiscate its balance).
3195         frozen[FEE_ADDRESS] = true;
3196         havven = _havven;
3197     }
3198 
3199     /* ========== SETTERS ========== */
3200 
3201     function setCourt(Court _court)
3202         external
3203         optionalProxy_onlyOwner
3204     {
3205         court = _court;
3206         emitCourtUpdated(_court);
3207     }
3208 
3209     function setHavven(Havven _havven)
3210         external
3211         optionalProxy_onlyOwner
3212     {
3213         // havven should be set as the feeAuthority after calling this depending on
3214         // havven's internal logic
3215         havven = _havven;
3216         setFeeAuthority(_havven);
3217         emitHavvenUpdated(_havven);
3218     }
3219 
3220 
3221     /* ========== MUTATIVE FUNCTIONS ========== */
3222 
3223     /* Override ERC20 transfer function in order to check
3224      * whether the recipient account is frozen. Note that there is
3225      * no need to check whether the sender has a frozen account,
3226      * since their funds have already been confiscated,
3227      * and no new funds can be transferred to it.*/
3228     function transfer(address to, uint value)
3229         public
3230         optionalProxy
3231         returns (bool)
3232     {
3233         require(!frozen[to]);
3234         return _transfer_byProxy(messageSender, to, value);
3235     }
3236 
3237     /* Override ERC20 transferFrom function in order to check
3238      * whether the recipient account is frozen. */
3239     function transferFrom(address from, address to, uint value)
3240         public
3241         optionalProxy
3242         returns (bool)
3243     {
3244         require(!frozen[to]);
3245         return _transferFrom_byProxy(messageSender, from, to, value);
3246     }
3247 
3248     function transferSenderPaysFee(address to, uint value)
3249         public
3250         optionalProxy
3251         returns (bool)
3252     {
3253         require(!frozen[to]);
3254         return _transferSenderPaysFee_byProxy(messageSender, to, value);
3255     }
3256 
3257     function transferFromSenderPaysFee(address from, address to, uint value)
3258         public
3259         optionalProxy
3260         returns (bool)
3261     {
3262         require(!frozen[to]);
3263         return _transferFromSenderPaysFee_byProxy(messageSender, from, to, value);
3264     }
3265 
3266     /* If a confiscation court motion has passed and reached the confirmation
3267      * state, the court may transfer the target account's balance to the fee pool
3268      * and freeze its participation in further transactions. */
3269     function freezeAndConfiscate(address target)
3270         external
3271         onlyCourt
3272     {
3273         
3274         // A motion must actually be underway.
3275         uint motionID = court.targetMotionID(target);
3276         require(motionID != 0);
3277 
3278         // These checks are strictly unnecessary,
3279         // since they are already checked in the court contract itself.
3280         require(court.motionConfirming(motionID));
3281         require(court.motionPasses(motionID));
3282         require(!frozen[target]);
3283 
3284         // Confiscate the balance in the account and freeze it.
3285         uint balance = tokenState.balanceOf(target);
3286         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), balance));
3287         tokenState.setBalanceOf(target, 0);
3288         frozen[target] = true;
3289         emitAccountFrozen(target, balance);
3290         emitTransfer(target, FEE_ADDRESS, balance);
3291     }
3292 
3293     /* The owner may allow a previously-frozen contract to once
3294      * again accept and transfer nomins. */
3295     function unfreezeAccount(address target)
3296         external
3297         optionalProxy_onlyOwner
3298     {
3299         require(frozen[target] && target != FEE_ADDRESS);
3300         frozen[target] = false;
3301         emitAccountUnfrozen(target);
3302     }
3303 
3304     /* Allow havven to issue a certain number of
3305      * nomins from an account. */
3306     function issue(address account, uint amount)
3307         external
3308         onlyHavven
3309     {
3310         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), amount));
3311         totalSupply = safeAdd(totalSupply, amount);
3312         emitTransfer(address(0), account, amount);
3313         emitIssued(account, amount);
3314     }
3315 
3316     /* Allow havven to burn a certain number of
3317      * nomins from an account. */
3318     function burn(address account, uint amount)
3319         external
3320         onlyHavven
3321     {
3322         tokenState.setBalanceOf(account, safeSub(tokenState.balanceOf(account), amount));
3323         totalSupply = safeSub(totalSupply, amount);
3324         emitTransfer(account, address(0), amount);
3325         emitBurned(account, amount);
3326     }
3327 
3328     /* ========== MODIFIERS ========== */
3329 
3330     modifier onlyHavven() {
3331         require(Havven(msg.sender) == havven);
3332         _;
3333     }
3334 
3335     modifier onlyCourt() {
3336         require(Court(msg.sender) == court);
3337         _;
3338     }
3339 
3340     /* ========== EVENTS ========== */
3341 
3342     event CourtUpdated(address newCourt);
3343     bytes32 constant COURTUPDATED_SIG = keccak256("CourtUpdated(address)");
3344     function emitCourtUpdated(address newCourt) internal {
3345         proxy._emit(abi.encode(newCourt), 1, COURTUPDATED_SIG, 0, 0, 0);
3346     }
3347 
3348     event HavvenUpdated(address newHavven);
3349     bytes32 constant HAVVENUPDATED_SIG = keccak256("HavvenUpdated(address)");
3350     function emitHavvenUpdated(address newHavven) internal {
3351         proxy._emit(abi.encode(newHavven), 1, HAVVENUPDATED_SIG, 0, 0, 0);
3352     }
3353 
3354     event AccountFrozen(address indexed target, uint balance);
3355     bytes32 constant ACCOUNTFROZEN_SIG = keccak256("AccountFrozen(address,uint256)");
3356     function emitAccountFrozen(address target, uint balance) internal {
3357         proxy._emit(abi.encode(balance), 2, ACCOUNTFROZEN_SIG, bytes32(target), 0, 0);
3358     }
3359 
3360     event AccountUnfrozen(address indexed target);
3361     bytes32 constant ACCOUNTUNFROZEN_SIG = keccak256("AccountUnfrozen(address)");
3362     function emitAccountUnfrozen(address target) internal {
3363         proxy._emit(abi.encode(), 2, ACCOUNTUNFROZEN_SIG, bytes32(target), 0, 0);
3364     }
3365 
3366     event Issued(address indexed account, uint amount);
3367     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
3368     function emitIssued(address account, uint amount) internal {
3369         proxy._emit(abi.encode(amount), 2, ISSUED_SIG, bytes32(account), 0, 0);
3370     }
3371 
3372     event Burned(address indexed account, uint amount);
3373     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
3374     function emitBurned(address account, uint amount) internal {
3375         proxy._emit(abi.encode(amount), 2, BURNED_SIG, bytes32(account), 0, 0);
3376     }
3377 }
3378 
3379 contract NominAirdropper is Owned {
3380     /* ========== CONSTRUCTOR ========== */
3381 
3382     /**
3383      * @dev Constructor
3384      * @param _owner The owner of this contract.
3385      */
3386     constructor (address _owner) 
3387         Owned(_owner)
3388     {}
3389 
3390     /**
3391      * @notice Multisend airdrops tokens to an array of destinations.
3392      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
3393      */
3394     function multisend(address tokenAddress, address[] destinations, uint256[] values)
3395         external
3396         onlyOwner
3397     {
3398         // Protect against obviously incorrect calls.
3399         require(destinations.length == values.length);
3400 
3401         // Loop through each destination and perform the transfer.
3402         uint256 i = 0;
3403         
3404         while (i < destinations.length) {
3405             Nomin(tokenAddress).transferSenderPaysFee(destinations[i], values[i]);
3406             i += 1;
3407         }
3408     }
3409 }