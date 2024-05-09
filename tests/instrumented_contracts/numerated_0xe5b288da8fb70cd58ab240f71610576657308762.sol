1 /*
2  * Depot Contract
3  * date: 27/11/18
4  * version: v3.0
5  * source: https://github.com/Havven/havven/blob/11aa8479f71eeaa3d17ffe0a0476043543b68b60/contracts/Depot.sol
6  * 
7  * The Depot contract allows for users to perform the following exchanges:
8  * • Ether to Nomins, via a FIFO exchange queue. 
9  * • Ether to Havvens.
10  * • Nomins to Ether, via a FIFO exchange queue. 
11  * • Nomins to Havvens.
12  *
13  * The Ether/Nomin pair is a peer-to-peer exchange.
14  * Havven (HAV) holders who mint the stablecoin nUSD at mintr.havven.io can 
15  * deposit their minted nUSD into the Depot contracts FIFO (First In First Out) queue 
16  * which will sell their nUSD in return for ETH at the stablecoins price of $1 USD.
17  * Minters of nUSD dont have to exclusivley use this queue, it is just provided for conveinece. 
18  * A stablecoin minter can sell their nUSD at any of the listed exchanges or DEX's
19  * 
20  * The Depot security audit was performed by Sigma Prime. That report is available at:
21  * https://www.havven.io/uploads/Depot-v3.0-Security-Audit-Report.pdf
22  *  
23  * The Depot.sol file is a modification of the IssuanceController.sol which was 
24  * previously reviewed by Sigma Prime. That report is available at:
25  * https://github.com/sigp/public-audits/blob/master/havven-2018-06-18/review.pdf
26  *
27  *
28  * MIT License
29  * ===========
30  *
31  * Copyright (c) 2018 Havven
32  *
33  * Permission is hereby granted, free of charge, to any person obtaining a copy
34  * of this software and associated documentation files (the "Software"), to deal
35  * in the Software without restriction, including without limitation the rights
36  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
37  * copies of the Software, and to permit persons to whom the Software is
38  * furnished to do so, subject to the following conditions:
39  *
40  * The above copyright notice and this permission notice shall be included in all
41  * copies or substantial portions of the Software.
42  *
43  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
44  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
45  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
46  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
47  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
48  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
49  */
50 /*
51 
52 
53 ////////////////// Owned.sol //////////////////
54 
55 /*
56 -----------------------------------------------------------------
57 FILE INFORMATION
58 -----------------------------------------------------------------
59 
60 file:       Owned.sol
61 version:    1.1
62 author:     Anton Jurisevic
63             Dominic Romanowski
64 
65 date:       2018-2-26
66 
67 -----------------------------------------------------------------
68 MODULE DESCRIPTION
69 -----------------------------------------------------------------
70 
71 An Owned contract, to be inherited by other contracts.
72 Requires its owner to be explicitly set in the constructor.
73 Provides an onlyOwner access modifier.
74 
75 To change owner, the current owner must nominate the next owner,
76 who then has to accept the nomination. The nomination can be
77 cancelled before it is accepted by the new owner by having the
78 previous owner change the nomination (setting it to 0).
79 
80 -----------------------------------------------------------------
81 */
82 
83 pragma solidity 0.4.24;
84 
85 /**
86  * @title A contract with an owner.
87  * @notice Contract ownership can be transferred by first nominating the new owner,
88  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
89  */
90 contract Owned {
91     address public owner;
92     address public nominatedOwner;
93 
94     /**
95      * @dev Owned Constructor
96      */
97     constructor(address _owner)
98         public
99     {
100         require(_owner != address(0), "Owner address cannot be 0");
101         owner = _owner;
102         emit OwnerChanged(address(0), _owner);
103     }
104 
105     /**
106      * @notice Nominate a new owner of this contract.
107      * @dev Only the current owner may nominate a new owner.
108      */
109     function nominateNewOwner(address _owner)
110         external
111         onlyOwner
112     {
113         nominatedOwner = _owner;
114         emit OwnerNominated(_owner);
115     }
116 
117     /**
118      * @notice Accept the nomination to be owner.
119      */
120     function acceptOwnership()
121         external
122     {
123         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
124         emit OwnerChanged(owner, nominatedOwner);
125         owner = nominatedOwner;
126         nominatedOwner = address(0);
127     }
128 
129     modifier onlyOwner
130     {
131         require(msg.sender == owner, "Only the contract owner may perform this action");
132         _;
133     }
134 
135     event OwnerNominated(address newOwner);
136     event OwnerChanged(address oldOwner, address newOwner);
137 }
138 
139 ////////////////// SelfDestructible.sol //////////////////
140 
141 /*
142 -----------------------------------------------------------------
143 FILE INFORMATION
144 -----------------------------------------------------------------
145 
146 file:       SelfDestructible.sol
147 version:    1.2
148 author:     Anton Jurisevic
149 
150 date:       2018-05-29
151 
152 -----------------------------------------------------------------
153 MODULE DESCRIPTION
154 -----------------------------------------------------------------
155 
156 This contract allows an inheriting contract to be destroyed after
157 its owner indicates an intention and then waits for a period
158 without changing their mind. All ether contained in the contract
159 is forwarded to a nominated beneficiary upon destruction.
160 
161 -----------------------------------------------------------------
162 */
163 
164 
165 /**
166  * @title A contract that can be destroyed by its owner after a delay elapses.
167  */
168 contract SelfDestructible is Owned {
169 	
170 	uint public initiationTime;
171 	bool public selfDestructInitiated;
172 	address public selfDestructBeneficiary;
173 	uint public constant SELFDESTRUCT_DELAY = 4 weeks;
174 
175 	/**
176 	 * @dev Constructor
177 	 * @param _owner The account which controls this contract.
178 	 */
179 	constructor(address _owner)
180 	    Owned(_owner)
181 	    public
182 	{
183 		require(_owner != address(0), "Owner must not be the zero address");
184 		selfDestructBeneficiary = _owner;
185 		emit SelfDestructBeneficiaryUpdated(_owner);
186 	}
187 
188 	/**
189 	 * @notice Set the beneficiary address of this contract.
190 	 * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
191 	 * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
192 	 */
193 	function setSelfDestructBeneficiary(address _beneficiary)
194 		external
195 		onlyOwner
196 	{
197 		require(_beneficiary != address(0), "Beneficiary must not be the zero address");
198 		selfDestructBeneficiary = _beneficiary;
199 		emit SelfDestructBeneficiaryUpdated(_beneficiary);
200 	}
201 
202 	/**
203 	 * @notice Begin the self-destruction counter of this contract.
204 	 * Once the delay has elapsed, the contract may be self-destructed.
205 	 * @dev Only the contract owner may call this.
206 	 */
207 	function initiateSelfDestruct()
208 		external
209 		onlyOwner
210 	{
211 		initiationTime = now;
212 		selfDestructInitiated = true;
213 		emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
214 	}
215 
216 	/**
217 	 * @notice Terminate and reset the self-destruction timer.
218 	 * @dev Only the contract owner may call this.
219 	 */
220 	function terminateSelfDestruct()
221 		external
222 		onlyOwner
223 	{
224 		initiationTime = 0;
225 		selfDestructInitiated = false;
226 		emit SelfDestructTerminated();
227 	}
228 
229 	/**
230 	 * @notice If the self-destruction delay has elapsed, destroy this contract and
231 	 * remit any ether it owns to the beneficiary address.
232 	 * @dev Only the contract owner may call this.
233 	 */
234 	function selfDestruct()
235 		external
236 		onlyOwner
237 	{
238 		require(selfDestructInitiated, "Self destruct has not yet been initiated");
239 		require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay has not yet elapsed");
240 		address beneficiary = selfDestructBeneficiary;
241 		emit SelfDestructed(beneficiary);
242 		selfdestruct(beneficiary);
243 	}
244 
245 	event SelfDestructTerminated();
246 	event SelfDestructed(address beneficiary);
247 	event SelfDestructInitiated(uint selfDestructDelay);
248 	event SelfDestructBeneficiaryUpdated(address newBeneficiary);
249 }
250 
251 
252 ////////////////// Pausable.sol //////////////////
253 
254 /*
255 -----------------------------------------------------------------
256 FILE INFORMATION
257 -----------------------------------------------------------------
258 
259 file:       Pausable.sol
260 version:    1.0
261 author:     Kevin Brown
262 
263 date:       2018-05-22
264 
265 -----------------------------------------------------------------
266 MODULE DESCRIPTION
267 -----------------------------------------------------------------
268 
269 This contract allows an inheriting contract to be marked as
270 paused. It also defines a modifier which can be used by the
271 inheriting contract to prevent actions while paused.
272 
273 -----------------------------------------------------------------
274 */
275 
276 
277 /**
278  * @title A contract that can be paused by its owner
279  */
280 contract Pausable is Owned {
281     
282     uint public lastPauseTime;
283     bool public paused;
284 
285     /**
286      * @dev Constructor
287      * @param _owner The account which controls this contract.
288      */
289     constructor(address _owner)
290         Owned(_owner)
291         public
292     {
293         // Paused will be false, and lastPauseTime will be 0 upon initialisation
294     }
295 
296     /**
297      * @notice Change the paused state of the contract
298      * @dev Only the contract owner may call this.
299      */
300     function setPaused(bool _paused)
301         external
302         onlyOwner
303     {
304         // Ensure we're actually changing the state before we do anything
305         if (_paused == paused) {
306             return;
307         }
308 
309         // Set our paused state.
310         paused = _paused;
311         
312         // If applicable, set the last pause time.
313         if (paused) {
314             lastPauseTime = now;
315         }
316 
317         // Let everyone know that our pause state has changed.
318         emit PauseChanged(paused);
319     }
320 
321     event PauseChanged(bool isPaused);
322 
323     modifier notPaused {
324         require(!paused, "This action cannot be performed while the contract is paused");
325         _;
326     }
327 }
328 
329 
330 ////////////////// SafeDecimalMath.sol //////////////////
331 
332 /*
333 -----------------------------------------------------------------
334 FILE INFORMATION
335 -----------------------------------------------------------------
336 
337 file:       SafeDecimalMath.sol
338 version:    1.0
339 author:     Anton Jurisevic
340 
341 date:       2018-2-5
342 
343 checked:    Mike Spain
344 approved:   Samuel Brooks
345 
346 -----------------------------------------------------------------
347 MODULE DESCRIPTION
348 -----------------------------------------------------------------
349 
350 A fixed point decimal library that provides basic mathematical
351 operations, and checks for unsafe arguments, for example that
352 would lead to overflows.
353 
354 Exceptions are thrown whenever those unsafe operations
355 occur.
356 
357 -----------------------------------------------------------------
358 */
359 
360 
361 /**
362  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
363  * @dev Functions accepting uints in this contract and derived contracts
364  * are taken to be such fixed point decimals (including fiat, ether, and nomin quantities).
365  */
366 contract SafeDecimalMath {
367 
368     /* Number of decimal places in the representation. */
369     uint8 public constant decimals = 18;
370 
371     /* The number representing 1.0. */
372     uint public constant UNIT = 10 ** uint(decimals);
373 
374     /**
375      * @return True iff adding x and y will not overflow.
376      */
377     function addIsSafe(uint x, uint y)
378         pure
379         internal
380         returns (bool)
381     {
382         return x + y >= y;
383     }
384 
385     /**
386      * @return The result of adding x and y, throwing an exception in case of overflow.
387      */
388     function safeAdd(uint x, uint y)
389         pure
390         internal
391         returns (uint)
392     {
393         require(x + y >= y, "Safe add failed");
394         return x + y;
395     }
396 
397     /**
398      * @return True iff subtracting y from x will not overflow in the negative direction.
399      */
400     function subIsSafe(uint x, uint y)
401         pure
402         internal
403         returns (bool)
404     {
405         return y <= x;
406     }
407 
408     /**
409      * @return The result of subtracting y from x, throwing an exception in case of overflow.
410      */
411     function safeSub(uint x, uint y)
412         pure
413         internal
414         returns (uint)
415     {
416         require(y <= x, "Safe sub failed");
417         return x - y;
418     }
419 
420     /**
421      * @return True iff multiplying x and y would not overflow.
422      */
423     function mulIsSafe(uint x, uint y)
424         pure
425         internal
426         returns (bool)
427     {
428         if (x == 0) {
429             return true;
430         }
431         return (x * y) / x == y;
432     }
433 
434     /**
435      * @return The result of multiplying x and y, throwing an exception in case of overflow.
436      */
437     function safeMul(uint x, uint y)
438         pure
439         internal
440         returns (uint)
441     {
442         if (x == 0) {
443             return 0;
444         }
445         uint p = x * y;
446         require(p / x == y, "Safe mul failed");
447         return p;
448     }
449 
450     /**
451      * @return The result of multiplying x and y, interpreting the operands as fixed-point
452      * decimals. Throws an exception in case of overflow.
453      * 
454      * @dev A unit factor is divided out after the product of x and y is evaluated,
455      * so that product must be less than 2**256.
456      * Incidentally, the internal division always rounds down: one could have rounded to the nearest integer,
457      * but then one would be spending a significant fraction of a cent (of order a microether
458      * at present gas prices) in order to save less than one part in 0.5 * 10^18 per operation, if the operands
459      * contain small enough fractional components. It would also marginally diminish the 
460      * domain this function is defined upon. 
461      */
462     function safeMul_dec(uint x, uint y)
463         pure
464         internal
465         returns (uint)
466     {
467         /* Divide by UNIT to remove the extra factor introduced by the product. */
468         return safeMul(x, y) / UNIT;
469 
470     }
471 
472     /**
473      * @return True iff the denominator of x/y is nonzero.
474      */
475     function divIsSafe(uint x, uint y)
476         pure
477         internal
478         returns (bool)
479     {
480         return y != 0;
481     }
482 
483     /**
484      * @return The result of dividing x by y, throwing an exception if the divisor is zero.
485      */
486     function safeDiv(uint x, uint y)
487         pure
488         internal
489         returns (uint)
490     {
491         /* Although a 0 denominator already throws an exception,
492          * it is equivalent to a THROW operation, which consumes all gas.
493          * A require statement emits REVERT instead, which remits remaining gas. */
494         require(y != 0, "Denominator cannot be zero");
495         return x / y;
496     }
497 
498     /**
499      * @return The result of dividing x by y, interpreting the operands as fixed point decimal numbers.
500      * @dev Throws an exception in case of overflow or zero divisor; x must be less than 2^256 / UNIT.
501      * Internal rounding is downward: a similar caveat holds as with safeDecMul().
502      */
503     function safeDiv_dec(uint x, uint y)
504         pure
505         internal
506         returns (uint)
507     {
508         /* Reintroduce the UNIT factor that will be divided out by y. */
509         return safeDiv(safeMul(x, UNIT), y);
510     }
511 
512     /**
513      * @dev Convert an unsigned integer to a unsigned fixed-point decimal.
514      * Throw an exception if the result would be out of range.
515      */
516     function intToDec(uint i)
517         pure
518         internal
519         returns (uint)
520     {
521         return safeMul(i, UNIT);
522     }
523 }
524 
525 
526 ////////////////// State.sol //////////////////
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
545 contracts, such as Havven and Nomin.
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
600 ////////////////// TokenState.sol //////////////////
601 
602 /*
603 -----------------------------------------------------------------
604 FILE INFORMATION
605 -----------------------------------------------------------------
606 
607 file:       TokenState.sol
608 version:    1.1
609 author:     Dominic Romanowski
610             Anton Jurisevic
611 
612 date:       2018-05-15
613 
614 -----------------------------------------------------------------
615 MODULE DESCRIPTION
616 -----------------------------------------------------------------
617 
618 A contract that holds the state of an ERC20 compliant token.
619 
620 This contract is used side by side with external state token
621 contracts, such as Havven and Nomin.
622 It provides an easy way to upgrade contract logic while
623 maintaining all user balances and allowances. This is designed
624 to make the changeover as easy as possible, since mappings
625 are not so cheap or straightforward to migrate.
626 
627 The first deployed contract would create this state contract,
628 using it as its store of balances.
629 When a new contract is deployed, it links to the existing
630 state contract, whose owner would then change its associated
631 contract to the new one.
632 
633 -----------------------------------------------------------------
634 */
635 
636 
637 /**
638  * @title ERC20 Token State
639  * @notice Stores balance information of an ERC20 token contract.
640  */
641 contract TokenState is State {
642 
643     /* ERC20 fields. */
644     mapping(address => uint) public balanceOf;
645     mapping(address => mapping(address => uint)) public allowance;
646 
647     /**
648      * @dev Constructor
649      * @param _owner The address which controls this contract.
650      * @param _associatedContract The ERC20 contract whose state this composes.
651      */
652     constructor(address _owner, address _associatedContract)
653         State(_owner, _associatedContract)
654         public
655     {}
656 
657     /* ========== SETTERS ========== */
658 
659     /**
660      * @notice Set ERC20 allowance.
661      * @dev Only the associated contract may call this.
662      * @param tokenOwner The authorising party.
663      * @param spender The authorised party.
664      * @param value The total value the authorised party may spend on the
665      * authorising party's behalf.
666      */
667     function setAllowance(address tokenOwner, address spender, uint value)
668         external
669         onlyAssociatedContract
670     {
671         allowance[tokenOwner][spender] = value;
672     }
673 
674     /**
675      * @notice Set the balance in a given account
676      * @dev Only the associated contract may call this.
677      * @param account The account whose value to set.
678      * @param value The new balance of the given account.
679      */
680     function setBalanceOf(address account, uint value)
681         external
682         onlyAssociatedContract
683     {
684         balanceOf[account] = value;
685     }
686 }
687 
688 
689 ////////////////// Proxy.sol //////////////////
690 
691 /*
692 -----------------------------------------------------------------
693 FILE INFORMATION
694 -----------------------------------------------------------------
695 
696 file:       Proxy.sol
697 version:    1.3
698 author:     Anton Jurisevic
699 
700 date:       2018-05-29
701 
702 -----------------------------------------------------------------
703 MODULE DESCRIPTION
704 -----------------------------------------------------------------
705 
706 A proxy contract that, if it does not recognise the function
707 being called on it, passes all value and call data to an
708 underlying target contract.
709 
710 This proxy has the capacity to toggle between DELEGATECALL
711 and CALL style proxy functionality.
712 
713 The former executes in the proxy's context, and so will preserve 
714 msg.sender and store data at the proxy address. The latter will not.
715 Therefore, any contract the proxy wraps in the CALL style must
716 implement the Proxyable interface, in order that it can pass msg.sender
717 into the underlying contract as the state parameter, messageSender.
718 
719 -----------------------------------------------------------------
720 */
721 
722 
723 contract Proxy is Owned {
724 
725     Proxyable public target;
726     bool public useDELEGATECALL;
727 
728     constructor(address _owner)
729         Owned(_owner)
730         public
731     {}
732 
733     function setTarget(Proxyable _target)
734         external
735         onlyOwner
736     {
737         target = _target;
738         emit TargetUpdated(_target);
739     }
740 
741     function setUseDELEGATECALL(bool value) 
742         external
743         onlyOwner
744     {
745         useDELEGATECALL = value;
746     }
747 
748     function _emit(bytes callData, uint numTopics,
749                    bytes32 topic1, bytes32 topic2,
750                    bytes32 topic3, bytes32 topic4)
751         external
752         onlyTarget
753     {
754         uint size = callData.length;
755         bytes memory _callData = callData;
756 
757         assembly {
758             /* The first 32 bytes of callData contain its length (as specified by the abi). 
759              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
760              * in length. It is also leftpadded to be a multiple of 32 bytes.
761              * This means moving call_data across 32 bytes guarantees we correctly access
762              * the data itself. */
763             switch numTopics
764             case 0 {
765                 log0(add(_callData, 32), size)
766             } 
767             case 1 {
768                 log1(add(_callData, 32), size, topic1)
769             }
770             case 2 {
771                 log2(add(_callData, 32), size, topic1, topic2)
772             }
773             case 3 {
774                 log3(add(_callData, 32), size, topic1, topic2, topic3)
775             }
776             case 4 {
777                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
778             }
779         }
780     }
781 
782     function()
783         external
784         payable
785     {
786         if (useDELEGATECALL) {
787             assembly {
788                 /* Copy call data into free memory region. */
789                 let free_ptr := mload(0x40)
790                 calldatacopy(free_ptr, 0, calldatasize)
791 
792                 /* Forward all gas and call data to the target contract. */
793                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
794                 returndatacopy(free_ptr, 0, returndatasize)
795 
796                 /* Revert if the call failed, otherwise return the result. */
797                 if iszero(result) { revert(free_ptr, returndatasize) }
798                 return(free_ptr, returndatasize)
799             }
800         } else {
801             /* Here we are as above, but must send the messageSender explicitly 
802              * since we are using CALL rather than DELEGATECALL. */
803             target.setMessageSender(msg.sender);
804             assembly {
805                 let free_ptr := mload(0x40)
806                 calldatacopy(free_ptr, 0, calldatasize)
807 
808                 /* We must explicitly forward ether to the underlying contract as well. */
809                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
810                 returndatacopy(free_ptr, 0, returndatasize)
811 
812                 if iszero(result) { revert(free_ptr, returndatasize) }
813                 return(free_ptr, returndatasize)
814             }
815         }
816     }
817 
818     modifier onlyTarget {
819         require(Proxyable(msg.sender) == target, "This action can only be performed by the proxy target");
820         _;
821     }
822 
823     event TargetUpdated(Proxyable newTarget);
824 }
825 
826 
827 ////////////////// Proxyable.sol //////////////////
828 
829 /*
830 -----------------------------------------------------------------
831 FILE INFORMATION
832 -----------------------------------------------------------------
833 
834 file:       Proxyable.sol
835 version:    1.1
836 author:     Anton Jurisevic
837 
838 date:       2018-05-15
839 
840 checked:    Mike Spain
841 approved:   Samuel Brooks
842 
843 -----------------------------------------------------------------
844 MODULE DESCRIPTION
845 -----------------------------------------------------------------
846 
847 A proxyable contract that works hand in hand with the Proxy contract
848 to allow for anyone to interact with the underlying contract both
849 directly and through the proxy.
850 
851 -----------------------------------------------------------------
852 */
853 
854 
855 // This contract should be treated like an abstract contract
856 contract Proxyable is Owned {
857     /* The proxy this contract exists behind. */
858     Proxy public proxy;
859 
860     /* The caller of the proxy, passed through to this contract.
861      * Note that every function using this member must apply the onlyProxy or
862      * optionalProxy modifiers, otherwise their invocations can use stale values. */ 
863     address messageSender; 
864 
865     constructor(address _proxy, address _owner)
866         Owned(_owner)
867         public
868     {
869         proxy = Proxy(_proxy);
870         emit ProxyUpdated(_proxy);
871     }
872 
873     function setProxy(address _proxy)
874         external
875         onlyOwner
876     {
877         proxy = Proxy(_proxy);
878         emit ProxyUpdated(_proxy);
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
889         require(Proxy(msg.sender) == proxy, "Only the proxy can call this function");
890         _;
891     }
892 
893     modifier optionalProxy
894     {
895         if (Proxy(msg.sender) != proxy) {
896             messageSender = msg.sender;
897         }
898         _;
899     }
900 
901     modifier optionalProxy_onlyOwner
902     {
903         if (Proxy(msg.sender) != proxy) {
904             messageSender = msg.sender;
905         }
906         require(messageSender == owner, "This action can only be performed by the owner");
907         _;
908     }
909 
910     event ProxyUpdated(address proxyAddress);
911 }
912 
913 
914 ////////////////// ReentrancyPreventer.sol //////////////////
915 
916 /*
917 -----------------------------------------------------------------
918 FILE INFORMATION
919 -----------------------------------------------------------------
920 
921 file:       ReentrancyPreventer.sol
922 version:    1.0
923 author:     Kevin Brown
924 date:       2018-08-06
925 
926 -----------------------------------------------------------------
927 MODULE DESCRIPTION
928 -----------------------------------------------------------------
929 
930 This contract offers a modifer that can prevent reentrancy on
931 particular actions. It will not work if you put it on multiple
932 functions that can be called from each other. Specifically guard
933 external entry points to the contract with the modifier only.
934 
935 -----------------------------------------------------------------
936 */
937 
938 
939 contract ReentrancyPreventer {
940     /* ========== MODIFIERS ========== */
941     bool isInFunctionBody = false;
942 
943     modifier preventReentrancy {
944         require(!isInFunctionBody, "Reverted to prevent reentrancy");
945         isInFunctionBody = true;
946         _;
947         isInFunctionBody = false;
948     }
949 }
950 
951 ////////////////// TokenFallbackCaller.sol //////////////////
952 
953 /*
954 -----------------------------------------------------------------
955 FILE INFORMATION
956 -----------------------------------------------------------------
957 
958 file:       TokenFallback.sol
959 version:    1.0
960 author:     Kevin Brown
961 date:       2018-08-10
962 
963 -----------------------------------------------------------------
964 MODULE DESCRIPTION
965 -----------------------------------------------------------------
966 
967 This contract provides the logic that's used to call tokenFallback()
968 when transfers happen.
969 
970 It's pulled out into its own module because it's needed in two
971 places, so instead of copy/pasting this logic and maininting it
972 both in Fee Token and Extern State Token, it's here and depended
973 on by both contracts.
974 
975 -----------------------------------------------------------------
976 */
977 
978 
979 contract TokenFallbackCaller is ReentrancyPreventer {
980     function callTokenFallbackIfNeeded(address sender, address recipient, uint amount, bytes data)
981         internal
982         preventReentrancy
983     {
984         /*
985             If we're transferring to a contract and it implements the tokenFallback function, call it.
986             This isn't ERC223 compliant because we don't revert if the contract doesn't implement tokenFallback.
987             This is because many DEXes and other contracts that expect to work with the standard
988             approve / transferFrom workflow don't implement tokenFallback but can still process our tokens as
989             usual, so it feels very harsh and likely to cause trouble if we add this restriction after having
990             previously gone live with a vanilla ERC20.
991         */
992 
993         // Is the to address a contract? We can check the code size on that address and know.
994         uint length;
995 
996         // solium-disable-next-line security/no-inline-assembly
997         assembly {
998             // Retrieve the size of the code on the recipient address
999             length := extcodesize(recipient)
1000         }
1001 
1002         // If there's code there, it's a contract
1003         if (length > 0) {
1004             // Now we need to optionally call tokenFallback(address from, uint value).
1005             // We can't call it the normal way because that reverts when the recipient doesn't implement the function.
1006 
1007             // solium-disable-next-line security/no-low-level-calls
1008             recipient.call(abi.encodeWithSignature("tokenFallback(address,uint256,bytes)", sender, amount, data));
1009 
1010             // And yes, we specifically don't care if this call fails, so we're not checking the return value.
1011         }
1012     }
1013 }
1014 
1015 
1016 ////////////////// ExternStateToken.sol //////////////////
1017 
1018 /*
1019 -----------------------------------------------------------------
1020 FILE INFORMATION
1021 -----------------------------------------------------------------
1022 
1023 file:       ExternStateToken.sol
1024 version:    1.3
1025 author:     Anton Jurisevic
1026             Dominic Romanowski
1027             Kevin Brown
1028 
1029 date:       2018-05-29
1030 
1031 -----------------------------------------------------------------
1032 MODULE DESCRIPTION
1033 -----------------------------------------------------------------
1034 
1035 A partial ERC20 token contract, designed to operate with a proxy.
1036 To produce a complete ERC20 token, transfer and transferFrom
1037 tokens must be implemented, using the provided _byProxy internal
1038 functions.
1039 This contract utilises an external state for upgradeability.
1040 
1041 -----------------------------------------------------------------
1042 */
1043 
1044 
1045 /**
1046  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
1047  */
1048 contract ExternStateToken is SafeDecimalMath, SelfDestructible, Proxyable, TokenFallbackCaller {
1049 
1050     /* ========== STATE VARIABLES ========== */
1051 
1052     /* Stores balances and allowances. */
1053     TokenState public tokenState;
1054 
1055     /* Other ERC20 fields.
1056      * Note that the decimals field is defined in SafeDecimalMath.*/
1057     string public name;
1058     string public symbol;
1059     uint public totalSupply;
1060 
1061     /**
1062      * @dev Constructor.
1063      * @param _proxy The proxy associated with this contract.
1064      * @param _name Token's ERC20 name.
1065      * @param _symbol Token's ERC20 symbol.
1066      * @param _totalSupply The total supply of the token.
1067      * @param _tokenState The TokenState contract address.
1068      * @param _owner The owner of this contract.
1069      */
1070     constructor(address _proxy, TokenState _tokenState,
1071                 string _name, string _symbol, uint _totalSupply,
1072                 address _owner)
1073         SelfDestructible(_owner)
1074         Proxyable(_proxy, _owner)
1075         public
1076     {
1077         name = _name;
1078         symbol = _symbol;
1079         totalSupply = _totalSupply;
1080         tokenState = _tokenState;
1081     }
1082 
1083     /* ========== VIEWS ========== */
1084 
1085     /**
1086      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
1087      * @param owner The party authorising spending of their funds.
1088      * @param spender The party spending tokenOwner's funds.
1089      */
1090     function allowance(address owner, address spender)
1091         public
1092         view
1093         returns (uint)
1094     {
1095         return tokenState.allowance(owner, spender);
1096     }
1097 
1098     /**
1099      * @notice Returns the ERC20 token balance of a given account.
1100      */
1101     function balanceOf(address account)
1102         public
1103         view
1104         returns (uint)
1105     {
1106         return tokenState.balanceOf(account);
1107     }
1108 
1109     /* ========== MUTATIVE FUNCTIONS ========== */
1110 
1111     /**
1112      * @notice Set the address of the TokenState contract.
1113      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
1114      * as balances would be unreachable.
1115      */ 
1116     function setTokenState(TokenState _tokenState)
1117         external
1118         optionalProxy_onlyOwner
1119     {
1120         tokenState = _tokenState;
1121         emitTokenStateUpdated(_tokenState);
1122     }
1123 
1124     function _internalTransfer(address from, address to, uint value, bytes data) 
1125         internal
1126         returns (bool)
1127     { 
1128         /* Disallow transfers to irretrievable-addresses. */
1129         require(to != address(0), "Cannot transfer to the 0 address");
1130         require(to != address(this), "Cannot transfer to the underlying contract");
1131         require(to != address(proxy), "Cannot transfer to the proxy contract");
1132 
1133         // Insufficient balance will be handled by the safe subtraction.
1134         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), value));
1135         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), value));
1136 
1137         // If the recipient is a contract, we need to call tokenFallback on it so they can do ERC223
1138         // actions when receiving our tokens. Unlike the standard, however, we don't revert if the
1139         // recipient contract doesn't implement tokenFallback.
1140         callTokenFallbackIfNeeded(from, to, value, data);
1141         
1142         // Emit a standard ERC20 transfer event
1143         emitTransfer(from, to, value);
1144 
1145         return true;
1146     }
1147 
1148     /**
1149      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
1150      * the onlyProxy or optionalProxy modifiers.
1151      */
1152     function _transfer_byProxy(address from, address to, uint value, bytes data)
1153         internal
1154         returns (bool)
1155     {
1156         return _internalTransfer(from, to, value, data);
1157     }
1158 
1159     /**
1160      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
1161      * possessing the optionalProxy or optionalProxy modifiers.
1162      */
1163     function _transferFrom_byProxy(address sender, address from, address to, uint value, bytes data)
1164         internal
1165         returns (bool)
1166     {
1167         /* Insufficient allowance will be handled by the safe subtraction. */
1168         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
1169         return _internalTransfer(from, to, value, data);
1170     }
1171 
1172     /**
1173      * @notice Approves spender to transfer on the message sender's behalf.
1174      */
1175     function approve(address spender, uint value)
1176         public
1177         optionalProxy
1178         returns (bool)
1179     {
1180         address sender = messageSender;
1181 
1182         tokenState.setAllowance(sender, spender, value);
1183         emitApproval(sender, spender, value);
1184         return true;
1185     }
1186 
1187     /* ========== EVENTS ========== */
1188 
1189     event Transfer(address indexed from, address indexed to, uint value);
1190     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
1191     function emitTransfer(address from, address to, uint value) internal {
1192         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
1193     }
1194 
1195     event Approval(address indexed owner, address indexed spender, uint value);
1196     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
1197     function emitApproval(address owner, address spender, uint value) internal {
1198         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
1199     }
1200 
1201     event TokenStateUpdated(address newTokenState);
1202     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
1203     function emitTokenStateUpdated(address newTokenState) internal {
1204         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
1205     }
1206 }
1207 
1208 
1209 ////////////////// FeeToken.sol //////////////////
1210 
1211 /*
1212 -----------------------------------------------------------------
1213 FILE INFORMATION
1214 -----------------------------------------------------------------
1215 
1216 file:       FeeToken.sol
1217 version:    1.3
1218 author:     Anton Jurisevic
1219             Dominic Romanowski
1220             Kevin Brown
1221 
1222 date:       2018-05-29
1223 
1224 -----------------------------------------------------------------
1225 MODULE DESCRIPTION
1226 -----------------------------------------------------------------
1227 
1228 A token which also has a configurable fee rate
1229 charged on its transfers. This is designed to be overridden in
1230 order to produce an ERC20-compliant token.
1231 
1232 These fees accrue into a pool, from which a nominated authority
1233 may withdraw.
1234 
1235 This contract utilises an external state for upgradeability.
1236 
1237 -----------------------------------------------------------------
1238 */
1239 
1240 
1241 /**
1242  * @title ERC20 Token contract, with detached state.
1243  * Additionally charges fees on each transfer.
1244  */
1245 contract FeeToken is ExternStateToken {
1246 
1247     /* ========== STATE VARIABLES ========== */
1248 
1249     /* ERC20 members are declared in ExternStateToken. */
1250 
1251     /* A percentage fee charged on each transfer. */
1252     uint public transferFeeRate;
1253     /* Fee may not exceed 10%. */
1254     uint constant MAX_TRANSFER_FEE_RATE = UNIT / 10;
1255     /* The address with the authority to distribute fees. */
1256     address public feeAuthority;
1257     /* The address that fees will be pooled in. */
1258     address public constant FEE_ADDRESS = 0xfeefeefeefeefeefeefeefeefeefeefeefeefeef;
1259 
1260 
1261     /* ========== CONSTRUCTOR ========== */
1262 
1263     /**
1264      * @dev Constructor.
1265      * @param _proxy The proxy associated with this contract.
1266      * @param _name Token's ERC20 name.
1267      * @param _symbol Token's ERC20 symbol.
1268      * @param _totalSupply The total supply of the token.
1269      * @param _transferFeeRate The fee rate to charge on transfers.
1270      * @param _feeAuthority The address which has the authority to withdraw fees from the accumulated pool.
1271      * @param _owner The owner of this contract.
1272      */
1273     constructor(address _proxy, TokenState _tokenState, string _name, string _symbol, uint _totalSupply,
1274                 uint _transferFeeRate, address _feeAuthority, address _owner)
1275         ExternStateToken(_proxy, _tokenState,
1276                          _name, _symbol, _totalSupply,
1277                          _owner)
1278         public
1279     {
1280         feeAuthority = _feeAuthority;
1281 
1282         /* Constructed transfer fee rate should respect the maximum fee rate. */
1283         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
1284         transferFeeRate = _transferFeeRate;
1285     }
1286 
1287     /* ========== SETTERS ========== */
1288 
1289     /**
1290      * @notice Set the transfer fee, anywhere within the range 0-10%.
1291      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1292      */
1293     function setTransferFeeRate(uint _transferFeeRate)
1294         external
1295         optionalProxy_onlyOwner
1296     {
1297         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
1298         transferFeeRate = _transferFeeRate;
1299         emitTransferFeeRateUpdated(_transferFeeRate);
1300     }
1301 
1302     /**
1303      * @notice Set the address of the user/contract responsible for collecting or
1304      * distributing fees.
1305      */
1306     function setFeeAuthority(address _feeAuthority)
1307         public
1308         optionalProxy_onlyOwner
1309     {
1310         feeAuthority = _feeAuthority;
1311         emitFeeAuthorityUpdated(_feeAuthority);
1312     }
1313 
1314     /* ========== VIEWS ========== */
1315 
1316     /**
1317      * @notice Calculate the Fee charged on top of a value being sent
1318      * @return Return the fee charged
1319      */
1320     function transferFeeIncurred(uint value)
1321         public
1322         view
1323         returns (uint)
1324     {
1325         return safeMul_dec(value, transferFeeRate);
1326         /* Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1327          * This is on the basis that transfers less than this value will result in a nil fee.
1328          * Probably too insignificant to worry about, but the following code will achieve it.
1329          *      if (fee == 0 && transferFeeRate != 0) {
1330          *          return _value;
1331          *      }
1332          *      return fee;
1333          */
1334     }
1335 
1336     /**
1337      * @notice The value that you would need to send so that the recipient receives
1338      * a specified value.
1339      */
1340     function transferPlusFee(uint value)
1341         external
1342         view
1343         returns (uint)
1344     {
1345         return safeAdd(value, transferFeeIncurred(value));
1346     }
1347 
1348     /**
1349      * @notice The amount the recipient will receive if you send a certain number of tokens.
1350      */
1351     function amountReceived(uint value)
1352         public
1353         view
1354         returns (uint)
1355     {
1356         return safeDiv_dec(value, safeAdd(UNIT, transferFeeRate));
1357     }
1358 
1359     /**
1360      * @notice Collected fees sit here until they are distributed.
1361      * @dev The balance of the nomin contract itself is the fee pool.
1362      */
1363     function feePool()
1364         external
1365         view
1366         returns (uint)
1367     {
1368         return tokenState.balanceOf(FEE_ADDRESS);
1369     }
1370 
1371     /* ========== MUTATIVE FUNCTIONS ========== */
1372 
1373     /**
1374      * @notice Base of transfer functions
1375      */
1376     function _internalTransfer(address from, address to, uint amount, uint fee, bytes data)
1377         internal
1378         returns (bool)
1379     {
1380         /* Disallow transfers to irretrievable-addresses. */
1381         require(to != address(0), "Cannot transfer to the 0 address");
1382         require(to != address(this), "Cannot transfer to the underlying contract");
1383         require(to != address(proxy), "Cannot transfer to the proxy contract");
1384 
1385         /* Insufficient balance will be handled by the safe subtraction. */
1386         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), safeAdd(amount, fee)));
1387         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), amount));
1388         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), fee));
1389 
1390         callTokenFallbackIfNeeded(from, to, amount, data);
1391 
1392         /* Emit events for both the transfer itself and the fee. */
1393         emitTransfer(from, to, amount);
1394         emitTransfer(from, FEE_ADDRESS, fee);
1395 
1396         return true;
1397     }
1398 
1399     /**
1400      * @notice ERC20 / ERC223 friendly transfer function.
1401      */
1402     function _transfer_byProxy(address sender, address to, uint value, bytes data)
1403         internal
1404         returns (bool)
1405     {
1406         uint received = amountReceived(value);
1407         uint fee = safeSub(value, received);
1408 
1409         return _internalTransfer(sender, to, received, fee, data);
1410     }
1411 
1412     /**
1413      * @notice ERC20 friendly transferFrom function.
1414      */
1415     function _transferFrom_byProxy(address sender, address from, address to, uint value, bytes data)
1416         internal
1417         returns (bool)
1418     {
1419         /* The fee is deducted from the amount sent. */
1420         uint received = amountReceived(value);
1421         uint fee = safeSub(value, received);
1422 
1423         /* Reduce the allowance by the amount we're transferring.
1424          * The safeSub call will handle an insufficient allowance. */
1425         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
1426 
1427         return _internalTransfer(from, to, received, fee, data);
1428     }
1429 
1430     /**
1431      * @notice Ability to transfer where the sender pays the fees (not ERC20)
1432      */
1433     function _transferSenderPaysFee_byProxy(address sender, address to, uint value, bytes data)
1434         internal
1435         returns (bool)
1436     {
1437         /* The fee is added to the amount sent. */
1438         uint fee = transferFeeIncurred(value);
1439         return _internalTransfer(sender, to, value, fee, data);
1440     }
1441 
1442     /**
1443      * @notice Ability to transferFrom where they sender pays the fees (not ERC20).
1444      */
1445     function _transferFromSenderPaysFee_byProxy(address sender, address from, address to, uint value, bytes data)
1446         internal
1447         returns (bool)
1448     {
1449         /* The fee is added to the amount sent. */
1450         uint fee = transferFeeIncurred(value);
1451         uint total = safeAdd(value, fee);
1452 
1453         /* Reduce the allowance by the amount we're transferring. */
1454         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), total));
1455 
1456         return _internalTransfer(from, to, value, fee, data);
1457     }
1458 
1459     /**
1460      * @notice Withdraw tokens from the fee pool into a given account.
1461      * @dev Only the fee authority may call this.
1462      */
1463     function withdrawFees(address account, uint value)
1464         external
1465         onlyFeeAuthority
1466         returns (bool)
1467     {
1468         require(account != address(0), "Must supply an account address to withdraw fees");
1469 
1470         /* 0-value withdrawals do nothing. */
1471         if (value == 0) {
1472             return false;
1473         }
1474 
1475         /* Safe subtraction ensures an exception is thrown if the balance is insufficient. */
1476         tokenState.setBalanceOf(FEE_ADDRESS, safeSub(tokenState.balanceOf(FEE_ADDRESS), value));
1477         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), value));
1478 
1479         emitFeesWithdrawn(account, value);
1480         emitTransfer(FEE_ADDRESS, account, value);
1481 
1482         return true;
1483     }
1484 
1485     /**
1486      * @notice Donate tokens from the sender's balance into the fee pool.
1487      */
1488     function donateToFeePool(uint n)
1489         external
1490         optionalProxy
1491         returns (bool)
1492     {
1493         address sender = messageSender;
1494         /* Empty donations are disallowed. */
1495         uint balance = tokenState.balanceOf(sender);
1496         require(balance != 0, "Must have a balance in order to donate to the fee pool");
1497 
1498         /* safeSub ensures the donor has sufficient balance. */
1499         tokenState.setBalanceOf(sender, safeSub(balance, n));
1500         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), n));
1501 
1502         emitFeesDonated(sender, n);
1503         emitTransfer(sender, FEE_ADDRESS, n);
1504 
1505         return true;
1506     }
1507 
1508 
1509     /* ========== MODIFIERS ========== */
1510 
1511     modifier onlyFeeAuthority
1512     {
1513         require(msg.sender == feeAuthority, "Only the fee authority can do this action");
1514         _;
1515     }
1516 
1517 
1518     /* ========== EVENTS ========== */
1519 
1520     event TransferFeeRateUpdated(uint newFeeRate);
1521     bytes32 constant TRANSFERFEERATEUPDATED_SIG = keccak256("TransferFeeRateUpdated(uint256)");
1522     function emitTransferFeeRateUpdated(uint newFeeRate) internal {
1523         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEERATEUPDATED_SIG, 0, 0, 0);
1524     }
1525 
1526     event FeeAuthorityUpdated(address newFeeAuthority);
1527     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
1528     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
1529         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
1530     } 
1531 
1532     event FeesWithdrawn(address indexed account, uint value);
1533     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
1534     function emitFeesWithdrawn(address account, uint value) internal {
1535         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
1536     }
1537 
1538     event FeesDonated(address indexed donor, uint value);
1539     bytes32 constant FEESDONATED_SIG = keccak256("FeesDonated(address,uint256)");
1540     function emitFeesDonated(address donor, uint value) internal {
1541         proxy._emit(abi.encode(value), 2, FEESDONATED_SIG, bytes32(donor), 0, 0);
1542     }
1543 }
1544 
1545 
1546 ////////////////// Nomin.sol //////////////////
1547 
1548 /*
1549 -----------------------------------------------------------------
1550 FILE INFORMATION
1551 -----------------------------------------------------------------
1552 
1553 file:       Nomin.sol
1554 version:    1.2
1555 author:     Anton Jurisevic
1556             Mike Spain
1557             Dominic Romanowski
1558             Kevin Brown
1559 
1560 date:       2018-05-29
1561 
1562 -----------------------------------------------------------------
1563 MODULE DESCRIPTION
1564 -----------------------------------------------------------------
1565 
1566 Havven-backed nomin stablecoin contract.
1567 
1568 This contract issues nomins, which are tokens worth 1 USD each.
1569 
1570 Nomins are issuable by Havven holders who have to lock up some
1571 value of their havvens to issue H * Cmax nomins. Where Cmax is
1572 some value less than 1.
1573 
1574 A configurable fee is charged on nomin transfers and deposited
1575 into a common pot, which havven holders may withdraw from once
1576 per fee period.
1577 
1578 -----------------------------------------------------------------
1579 */
1580 
1581 
1582 contract Nomin is FeeToken {
1583 
1584     /* ========== STATE VARIABLES ========== */
1585 
1586     Havven public havven;
1587 
1588     // Accounts which have lost the privilege to transact in nomins.
1589     mapping(address => bool) public frozen;
1590 
1591     // Nomin transfers incur a 15 bp fee by default.
1592     uint constant TRANSFER_FEE_RATE = 15 * UNIT / 10000;
1593     string constant TOKEN_NAME = "Nomin USD";
1594     string constant TOKEN_SYMBOL = "nUSD";
1595 
1596     /* ========== CONSTRUCTOR ========== */
1597 
1598     constructor(address _proxy, TokenState _tokenState, Havven _havven,
1599                 uint _totalSupply,
1600                 address _owner)
1601         FeeToken(_proxy, _tokenState,
1602                  TOKEN_NAME, TOKEN_SYMBOL, _totalSupply,
1603                  TRANSFER_FEE_RATE,
1604                  _havven, // The havven contract is the fee authority.
1605                  _owner)
1606         public
1607     {
1608         require(_proxy != 0, "_proxy cannot be 0");
1609         require(address(_havven) != 0, "_havven cannot be 0");
1610         require(_owner != 0, "_owner cannot be 0");
1611 
1612         // It should not be possible to transfer to the fee pool directly (or confiscate its balance).
1613         frozen[FEE_ADDRESS] = true;
1614         havven = _havven;
1615     }
1616 
1617     /* ========== SETTERS ========== */
1618 
1619     function setHavven(Havven _havven)
1620         external
1621         optionalProxy_onlyOwner
1622     {
1623         // havven should be set as the feeAuthority after calling this depending on
1624         // havven's internal logic
1625         havven = _havven;
1626         setFeeAuthority(_havven);
1627         emitHavvenUpdated(_havven);
1628     }
1629 
1630 
1631     /* ========== MUTATIVE FUNCTIONS ========== */
1632 
1633     /* Override ERC20 transfer function in order to check
1634      * whether the recipient account is frozen. Note that there is
1635      * no need to check whether the sender has a frozen account,
1636      * since their funds have already been confiscated,
1637      * and no new funds can be transferred to it.*/
1638     function transfer(address to, uint value)
1639         public
1640         optionalProxy
1641         returns (bool)
1642     {
1643         require(!frozen[to], "Cannot transfer to frozen address");
1644         bytes memory empty;
1645         return _transfer_byProxy(messageSender, to, value, empty);
1646     }
1647 
1648     /* Override ERC223 transfer function in order to check
1649      * whether the recipient account is frozen. Note that there is
1650      * no need to check whether the sender has a frozen account,
1651      * since their funds have already been confiscated,
1652      * and no new funds can be transferred to it.*/
1653     function transfer(address to, uint value, bytes data)
1654         public
1655         optionalProxy
1656         returns (bool)
1657     {
1658         require(!frozen[to], "Cannot transfer to frozen address");
1659         return _transfer_byProxy(messageSender, to, value, data);
1660     }
1661 
1662     /* Override ERC20 transferFrom function in order to check
1663      * whether the recipient account is frozen. */
1664     function transferFrom(address from, address to, uint value)
1665         public
1666         optionalProxy
1667         returns (bool)
1668     {
1669         require(!frozen[to], "Cannot transfer to frozen address");
1670         bytes memory empty;
1671         return _transferFrom_byProxy(messageSender, from, to, value, empty);
1672     }
1673 
1674     /* Override ERC223 transferFrom function in order to check
1675      * whether the recipient account is frozen. */
1676     function transferFrom(address from, address to, uint value, bytes data)
1677         public
1678         optionalProxy
1679         returns (bool)
1680     {
1681         require(!frozen[to], "Cannot transfer to frozen address");
1682         return _transferFrom_byProxy(messageSender, from, to, value, data);
1683     }
1684 
1685     function transferSenderPaysFee(address to, uint value)
1686         public
1687         optionalProxy
1688         returns (bool)
1689     {
1690         require(!frozen[to], "Cannot transfer to frozen address");
1691         bytes memory empty;
1692         return _transferSenderPaysFee_byProxy(messageSender, to, value, empty);
1693     }
1694 
1695     function transferSenderPaysFee(address to, uint value, bytes data)
1696         public
1697         optionalProxy
1698         returns (bool)
1699     {
1700         require(!frozen[to], "Cannot transfer to frozen address");
1701         return _transferSenderPaysFee_byProxy(messageSender, to, value, data);
1702     }
1703 
1704     function transferFromSenderPaysFee(address from, address to, uint value)
1705         public
1706         optionalProxy
1707         returns (bool)
1708     {
1709         require(!frozen[to], "Cannot transfer to frozen address");
1710         bytes memory empty;
1711         return _transferFromSenderPaysFee_byProxy(messageSender, from, to, value, empty);
1712     }
1713 
1714     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
1715         public
1716         optionalProxy
1717         returns (bool)
1718     {
1719         require(!frozen[to], "Cannot transfer to frozen address");
1720         return _transferFromSenderPaysFee_byProxy(messageSender, from, to, value, data);
1721     }
1722 
1723     /* The owner may allow a previously-frozen contract to once
1724      * again accept and transfer nomins. */
1725     function unfreezeAccount(address target)
1726         external
1727         optionalProxy_onlyOwner
1728     {
1729         require(frozen[target] && target != FEE_ADDRESS, "Account must be frozen, and cannot be the fee address");
1730         frozen[target] = false;
1731         emitAccountUnfrozen(target);
1732     }
1733 
1734     /* Allow havven to issue a certain number of
1735      * nomins from an account. */
1736     function issue(address account, uint amount)
1737         external
1738         onlyHavven
1739     {
1740         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), amount));
1741         totalSupply = safeAdd(totalSupply, amount);
1742         emitTransfer(address(0), account, amount);
1743         emitIssued(account, amount);
1744     }
1745 
1746     /* Allow havven to burn a certain number of
1747      * nomins from an account. */
1748     function burn(address account, uint amount)
1749         external
1750         onlyHavven
1751     {
1752         tokenState.setBalanceOf(account, safeSub(tokenState.balanceOf(account), amount));
1753         totalSupply = safeSub(totalSupply, amount);
1754         emitTransfer(account, address(0), amount);
1755         emitBurned(account, amount);
1756     }
1757 
1758     /* ========== MODIFIERS ========== */
1759 
1760     modifier onlyHavven() {
1761         require(Havven(msg.sender) == havven, "Only the Havven contract can perform this action");
1762         _;
1763     }
1764 
1765     /* ========== EVENTS ========== */
1766 
1767     event HavvenUpdated(address newHavven);
1768     bytes32 constant HAVVENUPDATED_SIG = keccak256("HavvenUpdated(address)");
1769     function emitHavvenUpdated(address newHavven) internal {
1770         proxy._emit(abi.encode(newHavven), 1, HAVVENUPDATED_SIG, 0, 0, 0);
1771     }
1772 
1773     event AccountFrozen(address indexed target, uint balance);
1774     bytes32 constant ACCOUNTFROZEN_SIG = keccak256("AccountFrozen(address,uint256)");
1775     function emitAccountFrozen(address target, uint balance) internal {
1776         proxy._emit(abi.encode(balance), 2, ACCOUNTFROZEN_SIG, bytes32(target), 0, 0);
1777     }
1778 
1779     event AccountUnfrozen(address indexed target);
1780     bytes32 constant ACCOUNTUNFROZEN_SIG = keccak256("AccountUnfrozen(address)");
1781     function emitAccountUnfrozen(address target) internal {
1782         proxy._emit(abi.encode(), 2, ACCOUNTUNFROZEN_SIG, bytes32(target), 0, 0);
1783     }
1784 
1785     event Issued(address indexed account, uint amount);
1786     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
1787     function emitIssued(address account, uint amount) internal {
1788         proxy._emit(abi.encode(amount), 2, ISSUED_SIG, bytes32(account), 0, 0);
1789     }
1790 
1791     event Burned(address indexed account, uint amount);
1792     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
1793     function emitBurned(address account, uint amount) internal {
1794         proxy._emit(abi.encode(amount), 2, BURNED_SIG, bytes32(account), 0, 0);
1795     }
1796 }
1797 
1798 
1799 ////////////////// LimitedSetup.sol //////////////////
1800 
1801 /*
1802 -----------------------------------------------------------------
1803 FILE INFORMATION
1804 -----------------------------------------------------------------
1805 
1806 file:       LimitedSetup.sol
1807 version:    1.1
1808 author:     Anton Jurisevic
1809 
1810 date:       2018-05-15
1811 
1812 -----------------------------------------------------------------
1813 MODULE DESCRIPTION
1814 -----------------------------------------------------------------
1815 
1816 A contract with a limited setup period. Any function modified
1817 with the setup modifier will cease to work after the
1818 conclusion of the configurable-length post-construction setup period.
1819 
1820 -----------------------------------------------------------------
1821 */
1822 
1823 
1824 /**
1825  * @title Any function decorated with the modifier this contract provides
1826  * deactivates after a specified setup period.
1827  */
1828 contract LimitedSetup {
1829 
1830     uint setupExpiryTime;
1831 
1832     /**
1833      * @dev LimitedSetup Constructor.
1834      * @param setupDuration The time the setup period will last for.
1835      */
1836     constructor(uint setupDuration)
1837         public
1838     {
1839         setupExpiryTime = now + setupDuration;
1840     }
1841 
1842     modifier onlyDuringSetup
1843     {
1844         require(now < setupExpiryTime, "Can only perform this action during setup");
1845         _;
1846     }
1847 }
1848 
1849 
1850 ////////////////// HavvenEscrow.sol //////////////////
1851 
1852 /*
1853 -----------------------------------------------------------------
1854 FILE INFORMATION
1855 -----------------------------------------------------------------
1856 
1857 file:       HavvenEscrow.sol
1858 version:    1.1
1859 author:     Anton Jurisevic
1860             Dominic Romanowski
1861             Mike Spain
1862 
1863 date:       2018-05-29
1864 
1865 -----------------------------------------------------------------
1866 MODULE DESCRIPTION
1867 -----------------------------------------------------------------
1868 
1869 This contract allows the foundation to apply unique vesting
1870 schedules to havven funds sold at various discounts in the token
1871 sale. HavvenEscrow gives users the ability to inspect their
1872 vested funds, their quantities and vesting dates, and to withdraw
1873 the fees that accrue on those funds.
1874 
1875 The fees are handled by withdrawing the entire fee allocation
1876 for all havvens inside the escrow contract, and then allowing
1877 the contract itself to subdivide that pool up proportionally within
1878 itself. Every time the fee period rolls over in the main Havven
1879 contract, the HavvenEscrow fee pool is remitted back into the
1880 main fee pool to be redistributed in the next fee period.
1881 
1882 -----------------------------------------------------------------
1883 */
1884 
1885 
1886 /**
1887  * @title A contract to hold escrowed havvens and free them at given schedules.
1888  */
1889 contract HavvenEscrow is SafeDecimalMath, Owned, LimitedSetup(8 weeks) {
1890     /* The corresponding Havven contract. */
1891     Havven public havven;
1892 
1893     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
1894      * These are the times at which each given quantity of havvens vests. */
1895     mapping(address => uint[2][]) public vestingSchedules;
1896 
1897     /* An account's total vested havven balance to save recomputing this for fee extraction purposes. */
1898     mapping(address => uint) public totalVestedAccountBalance;
1899 
1900     /* The total remaining vested balance, for verifying the actual havven balance of this contract against. */
1901     uint public totalVestedBalance;
1902 
1903     uint constant TIME_INDEX = 0;
1904     uint constant QUANTITY_INDEX = 1;
1905 
1906     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
1907     uint constant MAX_VESTING_ENTRIES = 20;
1908 
1909 
1910     /* ========== CONSTRUCTOR ========== */
1911 
1912     constructor(address _owner, Havven _havven)
1913         Owned(_owner)
1914         public
1915     {
1916         havven = _havven;
1917     }
1918 
1919 
1920     /* ========== SETTERS ========== */
1921 
1922     function setHavven(Havven _havven)
1923         external
1924         onlyOwner
1925     {
1926         havven = _havven;
1927         emit HavvenUpdated(_havven);
1928     }
1929 
1930 
1931     /* ========== VIEW FUNCTIONS ========== */
1932 
1933     /**
1934      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
1935      */
1936     function balanceOf(address account)
1937         public
1938         view
1939         returns (uint)
1940     {
1941         return totalVestedAccountBalance[account];
1942     }
1943 
1944     /**
1945      * @notice The number of vesting dates in an account's schedule.
1946      */
1947     function numVestingEntries(address account)
1948         public
1949         view
1950         returns (uint)
1951     {
1952         return vestingSchedules[account].length;
1953     }
1954 
1955     /**
1956      * @notice Get a particular schedule entry for an account.
1957      * @return A pair of uints: (timestamp, havven quantity).
1958      */
1959     function getVestingScheduleEntry(address account, uint index)
1960         public
1961         view
1962         returns (uint[2])
1963     {
1964         return vestingSchedules[account][index];
1965     }
1966 
1967     /**
1968      * @notice Get the time at which a given schedule entry will vest.
1969      */
1970     function getVestingTime(address account, uint index)
1971         public
1972         view
1973         returns (uint)
1974     {
1975         return getVestingScheduleEntry(account,index)[TIME_INDEX];
1976     }
1977 
1978     /**
1979      * @notice Get the quantity of havvens associated with a given schedule entry.
1980      */
1981     function getVestingQuantity(address account, uint index)
1982         public
1983         view
1984         returns (uint)
1985     {
1986         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
1987     }
1988 
1989     /**
1990      * @notice Obtain the index of the next schedule entry that will vest for a given user.
1991      */
1992     function getNextVestingIndex(address account)
1993         public
1994         view
1995         returns (uint)
1996     {
1997         uint len = numVestingEntries(account);
1998         for (uint i = 0; i < len; i++) {
1999             if (getVestingTime(account, i) != 0) {
2000                 return i;
2001             }
2002         }
2003         return len;
2004     }
2005 
2006     /**
2007      * @notice Obtain the next schedule entry that will vest for a given user.
2008      * @return A pair of uints: (timestamp, havven quantity). */
2009     function getNextVestingEntry(address account)
2010         public
2011         view
2012         returns (uint[2])
2013     {
2014         uint index = getNextVestingIndex(account);
2015         if (index == numVestingEntries(account)) {
2016             return [uint(0), 0];
2017         }
2018         return getVestingScheduleEntry(account, index);
2019     }
2020 
2021     /**
2022      * @notice Obtain the time at which the next schedule entry will vest for a given user.
2023      */
2024     function getNextVestingTime(address account)
2025         external
2026         view
2027         returns (uint)
2028     {
2029         return getNextVestingEntry(account)[TIME_INDEX];
2030     }
2031 
2032     /**
2033      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
2034      */
2035     function getNextVestingQuantity(address account)
2036         external
2037         view
2038         returns (uint)
2039     {
2040         return getNextVestingEntry(account)[QUANTITY_INDEX];
2041     }
2042 
2043 
2044     /* ========== MUTATIVE FUNCTIONS ========== */
2045 
2046     /**
2047      * @notice Withdraws a quantity of havvens back to the havven contract.
2048      * @dev This may only be called by the owner during the contract's setup period.
2049      */
2050     function withdrawHavvens(uint quantity)
2051         external
2052         onlyOwner
2053         onlyDuringSetup
2054     {
2055         havven.transfer(havven, quantity);
2056     }
2057 
2058     /**
2059      * @notice Destroy the vesting information associated with an account.
2060      */
2061     function purgeAccount(address account)
2062         external
2063         onlyOwner
2064         onlyDuringSetup
2065     {
2066         delete vestingSchedules[account];
2067         totalVestedBalance = safeSub(totalVestedBalance, totalVestedAccountBalance[account]);
2068         delete totalVestedAccountBalance[account];
2069     }
2070 
2071     /**
2072      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
2073      * @dev A call to this should be accompanied by either enough balance already available
2074      * in this contract, or a corresponding call to havven.endow(), to ensure that when
2075      * the funds are withdrawn, there is enough balance, as well as correctly calculating
2076      * the fees.
2077      * This may only be called by the owner during the contract's setup period.
2078      * Note; although this function could technically be used to produce unbounded
2079      * arrays, it's only in the foundation's command to add to these lists.
2080      * @param account The account to append a new vesting entry to.
2081      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
2082      * @param quantity The quantity of havvens that will vest.
2083      */
2084     function appendVestingEntry(address account, uint time, uint quantity)
2085         public
2086         onlyOwner
2087         onlyDuringSetup
2088     {
2089         /* No empty or already-passed vesting entries allowed. */
2090         require(now < time, "Time must be in the future");
2091         require(quantity != 0, "Quantity cannot be zero");
2092 
2093         /* There must be enough balance in the contract to provide for the vesting entry. */
2094         totalVestedBalance = safeAdd(totalVestedBalance, quantity);
2095         require(totalVestedBalance <= havven.balanceOf(this), "Must be enough balance in the contract to provide for the vesting entry");
2096 
2097         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
2098         uint scheduleLength = vestingSchedules[account].length;
2099         require(scheduleLength <= MAX_VESTING_ENTRIES, "Vesting schedule is too long");
2100 
2101         if (scheduleLength == 0) {
2102             totalVestedAccountBalance[account] = quantity;
2103         } else {
2104             /* Disallow adding new vested havvens earlier than the last one.
2105              * Since entries are only appended, this means that no vesting date can be repeated. */
2106             require(getVestingTime(account, numVestingEntries(account) - 1) < time, "Cannot add new vested entries earlier than the last one");
2107             totalVestedAccountBalance[account] = safeAdd(totalVestedAccountBalance[account], quantity);
2108         }
2109 
2110         vestingSchedules[account].push([time, quantity]);
2111     }
2112 
2113     /**
2114      * @notice Construct a vesting schedule to release a quantities of havvens
2115      * over a series of intervals.
2116      * @dev Assumes that the quantities are nonzero
2117      * and that the sequence of timestamps is strictly increasing.
2118      * This may only be called by the owner during the contract's setup period.
2119      */
2120     function addVestingSchedule(address account, uint[] times, uint[] quantities)
2121         external
2122         onlyOwner
2123         onlyDuringSetup
2124     {
2125         for (uint i = 0; i < times.length; i++) {
2126             appendVestingEntry(account, times[i], quantities[i]);
2127         }
2128 
2129     }
2130 
2131     /**
2132      * @notice Allow a user to withdraw any havvens in their schedule that have vested.
2133      */
2134     function vest()
2135         external
2136     {
2137         uint numEntries = numVestingEntries(msg.sender);
2138         uint total;
2139         for (uint i = 0; i < numEntries; i++) {
2140             uint time = getVestingTime(msg.sender, i);
2141             /* The list is sorted; when we reach the first future time, bail out. */
2142             if (time > now) {
2143                 break;
2144             }
2145             uint qty = getVestingQuantity(msg.sender, i);
2146             if (qty == 0) {
2147                 continue;
2148             }
2149 
2150             vestingSchedules[msg.sender][i] = [0, 0];
2151             total = safeAdd(total, qty);
2152         }
2153 
2154         if (total != 0) {
2155             totalVestedBalance = safeSub(totalVestedBalance, total);
2156             totalVestedAccountBalance[msg.sender] = safeSub(totalVestedAccountBalance[msg.sender], total);
2157             havven.transfer(msg.sender, total);
2158             emit Vested(msg.sender, now, total);
2159         }
2160     }
2161 
2162 
2163     /* ========== EVENTS ========== */
2164 
2165     event HavvenUpdated(address newHavven);
2166 
2167     event Vested(address indexed beneficiary, uint time, uint value);
2168 }
2169 
2170 
2171 ////////////////// Havven.sol //////////////////
2172 
2173 /*
2174 -----------------------------------------------------------------
2175 FILE INFORMATION
2176 -----------------------------------------------------------------
2177 
2178 file:       Havven.sol
2179 version:    1.2
2180 author:     Anton Jurisevic
2181             Dominic Romanowski
2182 
2183 date:       2018-05-15
2184 
2185 -----------------------------------------------------------------
2186 MODULE DESCRIPTION
2187 -----------------------------------------------------------------
2188 
2189 Havven token contract. Havvens are transferable ERC20 tokens,
2190 and also give their holders the following privileges.
2191 An owner of havvens may participate in nomin confiscation votes, they
2192 may also have the right to issue nomins at the discretion of the
2193 foundation for this version of the contract.
2194 
2195 After a fee period terminates, the duration and fees collected for that
2196 period are computed, and the next period begins. Thus an account may only
2197 withdraw the fees owed to them for the previous period, and may only do
2198 so once per period. Any unclaimed fees roll over into the common pot for
2199 the next period.
2200 
2201 == Average Balance Calculations ==
2202 
2203 The fee entitlement of a havven holder is proportional to their average
2204 issued nomin balance over the last fee period. This is computed by
2205 measuring the area under the graph of a user's issued nomin balance over
2206 time, and then when a new fee period begins, dividing through by the
2207 duration of the fee period.
2208 
2209 We need only update values when the balances of an account is modified.
2210 This occurs when issuing or burning for issued nomin balances,
2211 and when transferring for havven balances. This is for efficiency,
2212 and adds an implicit friction to interacting with havvens.
2213 A havven holder pays for his own recomputation whenever he wants to change
2214 his position, which saves the foundation having to maintain a pot dedicated
2215 to resourcing this.
2216 
2217 A hypothetical user's balance history over one fee period, pictorially:
2218 
2219       s ____
2220        |    |
2221        |    |___ p
2222        |____|___|___ __ _  _
2223        f    t   n
2224 
2225 Here, the balance was s between times f and t, at which time a transfer
2226 occurred, updating the balance to p, until n, when the present transfer occurs.
2227 When a new transfer occurs at time n, the balance being p,
2228 we must:
2229 
2230   - Add the area p * (n - t) to the total area recorded so far
2231   - Update the last transfer time to n
2232 
2233 So if this graph represents the entire current fee period,
2234 the average havvens held so far is ((t-f)*s + (n-t)*p) / (n-f).
2235 The complementary computations must be performed for both sender and
2236 recipient.
2237 
2238 Note that a transfer keeps global supply of havvens invariant.
2239 The sum of all balances is constant, and unmodified by any transfer.
2240 So the sum of all balances multiplied by the duration of a fee period is also
2241 constant, and this is equivalent to the sum of the area of every user's
2242 time/balance graph. Dividing through by that duration yields back the total
2243 havven supply. So, at the end of a fee period, we really do yield a user's
2244 average share in the havven supply over that period.
2245 
2246 A slight wrinkle is introduced if we consider the time r when the fee period
2247 rolls over. Then the previous fee period k-1 is before r, and the current fee
2248 period k is afterwards. If the last transfer took place before r,
2249 but the latest transfer occurred afterwards:
2250 
2251 k-1       |        k
2252       s __|_
2253        |  | |
2254        |  | |____ p
2255        |__|_|____|___ __ _  _
2256           |
2257        f  | t    n
2258           r
2259 
2260 In this situation the area (r-f)*s contributes to fee period k-1, while
2261 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2262 zero-value transfer to have occurred at time r. Their fee entitlement for the
2263 previous period will be finalised at the time of their first transfer during the
2264 current fee period, or when they query or withdraw their fee entitlement.
2265 
2266 In the implementation, the duration of different fee periods may be slightly irregular,
2267 as the check that they have rolled over occurs only when state-changing havven
2268 operations are performed.
2269 
2270 == Issuance and Burning ==
2271 
2272 In this version of the havven contract, nomins can only be issued by
2273 those that have been nominated by the havven foundation. Nomins are assumed
2274 to be valued at $1, as they are a stable unit of account.
2275 
2276 All nomins issued require a proportional value of havvens to be locked,
2277 where the proportion is governed by the current issuance ratio. This
2278 means for every $1 of Havvens locked up, $(issuanceRatio) nomins can be issued.
2279 i.e. to issue 100 nomins, 100/issuanceRatio dollars of havvens need to be locked up.
2280 
2281 To determine the value of some amount of havvens(H), an oracle is used to push
2282 the price of havvens (P_H) in dollars to the contract. The value of H
2283 would then be: H * P_H.
2284 
2285 Any havvens that are locked up by this issuance process cannot be transferred.
2286 The amount that is locked floats based on the price of havvens. If the price
2287 of havvens moves up, less havvens are locked, so they can be issued against,
2288 or transferred freely. If the price of havvens moves down, more havvens are locked,
2289 even going above the initial wallet balance.
2290 
2291 -----------------------------------------------------------------
2292 */
2293 
2294 
2295 /**
2296  * @title Havven ERC20 contract.
2297  * @notice The Havven contracts does not only facilitate transfers and track balances,
2298  * but it also computes the quantity of fees each havven holder is entitled to.
2299  */
2300 contract Havven is ExternStateToken {
2301 
2302     /* ========== STATE VARIABLES ========== */
2303 
2304     /* A struct for handing values associated with average balance calculations */
2305     struct IssuanceData {
2306         /* Sums of balances*duration in the current fee period.
2307         /* range: decimals; units: havven-seconds */
2308         uint currentBalanceSum;
2309         /* The last period's average balance */
2310         uint lastAverageBalance;
2311         /* The last time the data was calculated */
2312         uint lastModified;
2313     }
2314 
2315     /* Issued nomin balances for individual fee entitlements */
2316     mapping(address => IssuanceData) public issuanceData;
2317     /* The total number of issued nomins for determining fee entitlements */
2318     IssuanceData public totalIssuanceData;
2319 
2320     /* The time the current fee period began */
2321     uint public feePeriodStartTime;
2322     /* The time the last fee period began */
2323     uint public lastFeePeriodStartTime;
2324 
2325     /* Fee periods will roll over in no shorter a time than this. 
2326      * The fee period cannot actually roll over until a fee-relevant
2327      * operation such as withdrawal or a fee period duration update occurs,
2328      * so this is just a target, and the actual duration may be slightly longer. */
2329     uint public feePeriodDuration = 4 weeks;
2330     /* ...and must target between 1 day and six months. */
2331     uint constant MIN_FEE_PERIOD_DURATION = 1 days;
2332     uint constant MAX_FEE_PERIOD_DURATION = 26 weeks;
2333 
2334     /* The quantity of nomins that were in the fee pot at the time */
2335     /* of the last fee rollover, at feePeriodStartTime. */
2336     uint public lastFeesCollected;
2337 
2338     /* Whether a user has withdrawn their last fees */
2339     mapping(address => bool) public hasWithdrawnFees;
2340 
2341     Nomin public nomin;
2342     HavvenEscrow public escrow;
2343 
2344     /* The address of the oracle which pushes the havven price to this contract */
2345     address public oracle;
2346     /* The price of havvens written in UNIT */
2347     uint public price;
2348     /* The time the havven price was last updated */
2349     uint public lastPriceUpdateTime;
2350     /* How long will the contract assume the price of havvens is correct */
2351     uint public priceStalePeriod = 3 hours;
2352 
2353     /* A quantity of nomins greater than this ratio
2354      * may not be issued against a given value of havvens. */
2355     uint public issuanceRatio = UNIT / 5;
2356     /* No more nomins may be issued than the value of havvens backing them. */
2357     uint constant MAX_ISSUANCE_RATIO = UNIT;
2358 
2359     /* Whether the address can issue nomins or not. */
2360     mapping(address => bool) public isIssuer;
2361     /* The number of currently-outstanding nomins the user has issued. */
2362     mapping(address => uint) public nominsIssued;
2363 
2364     uint constant HAVVEN_SUPPLY = 1e8 * UNIT;
2365     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
2366     string constant TOKEN_NAME = "Havven";
2367     string constant TOKEN_SYMBOL = "HAV";
2368     
2369     /* ========== CONSTRUCTOR ========== */
2370 
2371     /**
2372      * @dev Constructor
2373      * @param _tokenState A pre-populated contract containing token balances.
2374      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2375      * @param _owner The owner of this contract.
2376      */
2377     constructor(address _proxy, TokenState _tokenState, address _owner, address _oracle,
2378                 uint _price, address[] _issuers, Havven _oldHavven)
2379         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, HAVVEN_SUPPLY, _owner)
2380         public
2381     {
2382         oracle = _oracle;
2383         price = _price;
2384         lastPriceUpdateTime = now;
2385 
2386         uint i;
2387         if (_oldHavven == address(0)) {
2388             feePeriodStartTime = now;
2389             lastFeePeriodStartTime = now - feePeriodDuration;
2390             for (i = 0; i < _issuers.length; i++) {
2391                 isIssuer[_issuers[i]] = true;
2392             }
2393         } else {
2394             feePeriodStartTime = _oldHavven.feePeriodStartTime();
2395             lastFeePeriodStartTime = _oldHavven.lastFeePeriodStartTime();
2396 
2397             uint cbs;
2398             uint lab;
2399             uint lm;
2400             (cbs, lab, lm) = _oldHavven.totalIssuanceData();
2401             totalIssuanceData.currentBalanceSum = cbs;
2402             totalIssuanceData.lastAverageBalance = lab;
2403             totalIssuanceData.lastModified = lm;
2404 
2405             for (i = 0; i < _issuers.length; i++) {
2406                 address issuer = _issuers[i];
2407                 isIssuer[issuer] = true;
2408                 uint nomins = _oldHavven.nominsIssued(issuer);
2409                 if (nomins == 0) {
2410                     // It is not valid in general to skip those with no currently-issued nomins.
2411                     // But for this release, issuers with nonzero issuanceData have current issuance.
2412                     continue;
2413                 }
2414                 (cbs, lab, lm) = _oldHavven.issuanceData(issuer);
2415                 nominsIssued[issuer] = nomins;
2416                 issuanceData[issuer].currentBalanceSum = cbs;
2417                 issuanceData[issuer].lastAverageBalance = lab;
2418                 issuanceData[issuer].lastModified = lm;
2419             }
2420         }
2421 
2422     }
2423 
2424     /* ========== SETTERS ========== */
2425 
2426     /**
2427      * @notice Set the associated Nomin contract to collect fees from.
2428      * @dev Only the contract owner may call this.
2429      */
2430     function setNomin(Nomin _nomin)
2431         external
2432         optionalProxy_onlyOwner
2433     {
2434         nomin = _nomin;
2435         emitNominUpdated(_nomin);
2436     }
2437 
2438     /**
2439      * @notice Set the associated havven escrow contract.
2440      * @dev Only the contract owner may call this.
2441      */
2442     function setEscrow(HavvenEscrow _escrow)
2443         external
2444         optionalProxy_onlyOwner
2445     {
2446         escrow = _escrow;
2447         emitEscrowUpdated(_escrow);
2448     }
2449 
2450     /**
2451      * @notice Set the targeted fee period duration.
2452      * @dev Only callable by the contract owner. The duration must fall within
2453      * acceptable bounds (1 day to 26 weeks). Upon resetting this the fee period
2454      * may roll over if the target duration was shortened sufficiently.
2455      */
2456     function setFeePeriodDuration(uint duration)
2457         external
2458         optionalProxy_onlyOwner
2459     {
2460         require(MIN_FEE_PERIOD_DURATION <= duration && duration <= MAX_FEE_PERIOD_DURATION,
2461             "Duration must be between MIN_FEE_PERIOD_DURATION and MAX_FEE_PERIOD_DURATION");
2462         feePeriodDuration = duration;
2463         emitFeePeriodDurationUpdated(duration);
2464         rolloverFeePeriodIfElapsed();
2465     }
2466 
2467     /**
2468      * @notice Set the Oracle that pushes the havven price to this contract
2469      */
2470     function setOracle(address _oracle)
2471         external
2472         optionalProxy_onlyOwner
2473     {
2474         oracle = _oracle;
2475         emitOracleUpdated(_oracle);
2476     }
2477 
2478     /**
2479      * @notice Set the stale period on the updated havven price
2480      * @dev No max/minimum, as changing it wont influence anything but issuance by the foundation
2481      */
2482     function setPriceStalePeriod(uint time)
2483         external
2484         optionalProxy_onlyOwner
2485     {
2486         priceStalePeriod = time;
2487     }
2488 
2489     /**
2490      * @notice Set the issuanceRatio for issuance calculations.
2491      * @dev Only callable by the contract owner.
2492      */
2493     function setIssuanceRatio(uint _issuanceRatio)
2494         external
2495         optionalProxy_onlyOwner
2496     {
2497         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio must be less than or equal to MAX_ISSUANCE_RATIO");
2498         issuanceRatio = _issuanceRatio;
2499         emitIssuanceRatioUpdated(_issuanceRatio);
2500     }
2501 
2502     /**
2503      * @notice Set whether the specified can issue nomins or not.
2504      */
2505     function setIssuer(address account, bool value)
2506         external
2507         optionalProxy_onlyOwner
2508     {
2509         isIssuer[account] = value;
2510         emitIssuersUpdated(account, value);
2511     }
2512 
2513     /* ========== VIEWS ========== */
2514 
2515     function issuanceCurrentBalanceSum(address account)
2516         external
2517         view
2518         returns (uint)
2519     {
2520         return issuanceData[account].currentBalanceSum;
2521     }
2522 
2523     function issuanceLastAverageBalance(address account)
2524         external
2525         view
2526         returns (uint)
2527     {
2528         return issuanceData[account].lastAverageBalance;
2529     }
2530 
2531     function issuanceLastModified(address account)
2532         external
2533         view
2534         returns (uint)
2535     {
2536         return issuanceData[account].lastModified;
2537     }
2538 
2539     function totalIssuanceCurrentBalanceSum()
2540         external
2541         view
2542         returns (uint)
2543     {
2544         return totalIssuanceData.currentBalanceSum;
2545     }
2546 
2547     function totalIssuanceLastAverageBalance()
2548         external
2549         view
2550         returns (uint)
2551     {
2552         return totalIssuanceData.lastAverageBalance;
2553     }
2554 
2555     function totalIssuanceLastModified()
2556         external
2557         view
2558         returns (uint)
2559     {
2560         return totalIssuanceData.lastModified;
2561     }
2562 
2563     /* ========== MUTATIVE FUNCTIONS ========== */
2564 
2565     /**
2566      * @notice ERC20 transfer function.
2567      */
2568     function transfer(address to, uint value)
2569         public
2570         returns (bool)
2571     {
2572         bytes memory empty;
2573         return transfer(to, value, empty);
2574     }
2575 
2576     /**
2577      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
2578      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2579      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2580      *           tooling such as Etherscan.
2581      */
2582     function transfer(address to, uint value, bytes data)
2583         public
2584         optionalProxy
2585         returns (bool)
2586     {
2587         address sender = messageSender;
2588         require(nominsIssued[sender] == 0 || value <= transferableHavvens(sender), "Value to transfer exceeds available havvens");
2589         /* Perform the transfer: if there is a problem,
2590          * an exception will be thrown in this call. */
2591         _transfer_byProxy(messageSender, to, value, data);
2592 
2593         return true;
2594     }
2595 
2596     /**
2597      * @notice ERC20 transferFrom function.
2598      */
2599     function transferFrom(address from, address to, uint value)
2600         public
2601         returns (bool)
2602     {
2603         bytes memory empty;
2604         return transferFrom(from, to, value, empty);
2605     }
2606 
2607     /**
2608      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
2609      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2610      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2611      *           tooling such as Etherscan.
2612      */
2613     function transferFrom(address from, address to, uint value, bytes data)
2614         public
2615         optionalProxy
2616         returns (bool)
2617     {
2618         address sender = messageSender;
2619         require(nominsIssued[from] == 0 || value <= transferableHavvens(from), "Value to transfer exceeds available havvens");
2620         /* Perform the transfer: if there is a problem,
2621          * an exception will be thrown in this call. */
2622         _transferFrom_byProxy(messageSender, from, to, value, data);
2623 
2624         return true;
2625     }
2626 
2627     /**
2628      * @notice Compute the last period's fee entitlement for the message sender
2629      * and then deposit it into their nomin account.
2630      */
2631     function withdrawFees()
2632         external
2633         optionalProxy
2634     {
2635         address sender = messageSender;
2636         rolloverFeePeriodIfElapsed();
2637         /* Do not deposit fees into frozen accounts. */
2638         require(!nomin.frozen(sender), "Cannot deposit fees into frozen accounts");
2639 
2640         /* Check the period has rolled over first. */
2641         updateIssuanceData(sender, nominsIssued[sender], nomin.totalSupply());
2642 
2643         /* Only allow accounts to withdraw fees once per period. */
2644         require(!hasWithdrawnFees[sender], "Fees have already been withdrawn in this period");
2645 
2646         uint feesOwed;
2647         uint lastTotalIssued = totalIssuanceData.lastAverageBalance;
2648 
2649         if (lastTotalIssued > 0) {
2650             /* Sender receives a share of last period's collected fees proportional
2651              * with their average fraction of the last period's issued nomins. */
2652             feesOwed = safeDiv_dec(
2653                 safeMul_dec(issuanceData[sender].lastAverageBalance, lastFeesCollected),
2654                 lastTotalIssued
2655             );
2656         }
2657 
2658         hasWithdrawnFees[sender] = true;
2659 
2660         if (feesOwed != 0) {
2661             nomin.withdrawFees(sender, feesOwed);
2662         }
2663         emitFeesWithdrawn(messageSender, feesOwed);
2664     }
2665 
2666     /**
2667      * @notice Update the havven balance averages since the last transfer
2668      * or entitlement adjustment.
2669      * @dev Since this updates the last transfer timestamp, if invoked
2670      * consecutively, this function will do nothing after the first call.
2671      * Also, this will adjust the total issuance at the same time.
2672      */
2673     function updateIssuanceData(address account, uint preBalance, uint lastTotalSupply)
2674         internal
2675     {
2676         /* update the total balances first */
2677         totalIssuanceData = computeIssuanceData(lastTotalSupply, totalIssuanceData);
2678 
2679         if (issuanceData[account].lastModified < feePeriodStartTime) {
2680             hasWithdrawnFees[account] = false;
2681         }
2682 
2683         issuanceData[account] = computeIssuanceData(preBalance, issuanceData[account]);
2684     }
2685 
2686 
2687     /**
2688      * @notice Compute the new IssuanceData on the old balance
2689      */
2690     function computeIssuanceData(uint preBalance, IssuanceData preIssuance)
2691         internal
2692         view
2693         returns (IssuanceData)
2694     {
2695 
2696         uint currentBalanceSum = preIssuance.currentBalanceSum;
2697         uint lastAverageBalance = preIssuance.lastAverageBalance;
2698         uint lastModified = preIssuance.lastModified;
2699 
2700         if (lastModified < feePeriodStartTime) {
2701             if (lastModified < lastFeePeriodStartTime) {
2702                 /* The balance was last updated before the previous fee period, so the average
2703                  * balance in this period is their pre-transfer balance. */
2704                 lastAverageBalance = preBalance;
2705             } else {
2706                 /* The balance was last updated during the previous fee period. */
2707                 /* No overflow or zero denominator problems, since lastFeePeriodStartTime < feePeriodStartTime < lastModified. 
2708                  * implies these quantities are strictly positive. */
2709                 uint timeUpToRollover = feePeriodStartTime - lastModified;
2710                 uint lastFeePeriodDuration = feePeriodStartTime - lastFeePeriodStartTime;
2711                 uint lastBalanceSum = safeAdd(currentBalanceSum, safeMul(preBalance, timeUpToRollover));
2712                 lastAverageBalance = lastBalanceSum / lastFeePeriodDuration;
2713             }
2714             /* Roll over to the next fee period. */
2715             currentBalanceSum = safeMul(preBalance, now - feePeriodStartTime);
2716         } else {
2717             /* The balance was last updated during the current fee period. */
2718             currentBalanceSum = safeAdd(
2719                 currentBalanceSum,
2720                 safeMul(preBalance, now - lastModified)
2721             );
2722         }
2723 
2724         return IssuanceData(currentBalanceSum, lastAverageBalance, now);
2725     }
2726 
2727     /**
2728      * @notice Recompute and return the given account's last average balance.
2729      */
2730     function recomputeLastAverageBalance(address account)
2731         external
2732         returns (uint)
2733     {
2734         updateIssuanceData(account, nominsIssued[account], nomin.totalSupply());
2735         return issuanceData[account].lastAverageBalance;
2736     }
2737 
2738     /**
2739      * @notice Issue nomins against the sender's havvens.
2740      * @dev Issuance is only allowed if the havven price isn't stale and the sender is an issuer.
2741      */
2742     function issueNomins(uint amount)
2743         public
2744         optionalProxy
2745         requireIssuer(messageSender)
2746         /* No need to check if price is stale, as it is checked in issuableNomins. */
2747     {
2748         address sender = messageSender;
2749         require(amount <= remainingIssuableNomins(sender), "Amount must be less than or equal to remaining issuable nomins");
2750         uint lastTot = nomin.totalSupply();
2751         uint preIssued = nominsIssued[sender];
2752         nomin.issue(sender, amount);
2753         nominsIssued[sender] = safeAdd(preIssued, amount);
2754         updateIssuanceData(sender, preIssued, lastTot);
2755     }
2756 
2757     function issueMaxNomins()
2758         external
2759         optionalProxy
2760     {
2761         issueNomins(remainingIssuableNomins(messageSender));
2762     }
2763 
2764     /**
2765      * @notice Burn nomins to clear issued nomins/free havvens.
2766      */
2767     function burnNomins(uint amount)
2768         /* it doesn't matter if the price is stale or if the user is an issuer, as non-issuers have issued no nomins.*/
2769         external
2770         optionalProxy
2771     {
2772         address sender = messageSender;
2773 
2774         uint lastTot = nomin.totalSupply();
2775         uint preIssued = nominsIssued[sender];
2776         /* nomin.burn does a safeSub on balance (so it will revert if there are not enough nomins). */
2777         nomin.burn(sender, amount);
2778         /* This safe sub ensures amount <= number issued */
2779         nominsIssued[sender] = safeSub(preIssued, amount);
2780         updateIssuanceData(sender, preIssued, lastTot);
2781     }
2782 
2783     /**
2784      * @notice Check if the fee period has rolled over. If it has, set the new fee period start
2785      * time, and record the fees collected in the nomin contract.
2786      */
2787     function rolloverFeePeriodIfElapsed()
2788         public
2789     {
2790         /* If the fee period has rolled over... */
2791         if (now >= feePeriodStartTime + feePeriodDuration) {
2792             lastFeesCollected = nomin.feePool();
2793             lastFeePeriodStartTime = feePeriodStartTime;
2794             feePeriodStartTime = now;
2795             emitFeePeriodRollover(now);
2796         }
2797     }
2798 
2799     /* ========== Issuance/Burning ========== */
2800 
2801     /**
2802      * @notice The maximum nomins an issuer can issue against their total havven quantity. This ignores any
2803      * already issued nomins.
2804      */
2805     function maxIssuableNomins(address issuer)
2806         view
2807         public
2808         priceNotStale
2809         returns (uint)
2810     {
2811         if (!isIssuer[issuer]) {
2812             return 0;
2813         }
2814         if (escrow != HavvenEscrow(0)) {
2815             uint totalOwnedHavvens = safeAdd(tokenState.balanceOf(issuer), escrow.balanceOf(issuer));
2816             return safeMul_dec(HAVtoUSD(totalOwnedHavvens), issuanceRatio);
2817         } else {
2818             return safeMul_dec(HAVtoUSD(tokenState.balanceOf(issuer)), issuanceRatio);
2819         }
2820     }
2821 
2822     /**
2823      * @notice The remaining nomins an issuer can issue against their total havven quantity.
2824      */
2825     function remainingIssuableNomins(address issuer)
2826         view
2827         public
2828         returns (uint)
2829     {
2830         uint issued = nominsIssued[issuer];
2831         uint max = maxIssuableNomins(issuer);
2832         if (issued > max) {
2833             return 0;
2834         } else {
2835             return safeSub(max, issued);
2836         }
2837     }
2838 
2839     /**
2840      * @notice The total havvens owned by this account, both escrowed and unescrowed,
2841      * against which nomins can be issued.
2842      * This includes those already being used as collateral (locked), and those
2843      * available for further issuance (unlocked).
2844      */
2845     function collateral(address account)
2846         public
2847         view
2848         returns (uint)
2849     {
2850         uint bal = tokenState.balanceOf(account);
2851         if (escrow != address(0)) {
2852             bal = safeAdd(bal, escrow.balanceOf(account));
2853         }
2854         return bal;
2855     }
2856 
2857     /**
2858      * @notice The collateral that would be locked by issuance, which can exceed the account's actual collateral.
2859      */
2860     function issuanceDraft(address account)
2861         public
2862         view
2863         returns (uint)
2864     {
2865         uint issued = nominsIssued[account];
2866         if (issued == 0) {
2867             return 0;
2868         }
2869         return USDtoHAV(safeDiv_dec(issued, issuanceRatio));
2870     }
2871 
2872     /**
2873      * @notice Collateral that has been locked due to issuance, and cannot be
2874      * transferred to other addresses. This is capped at the account's total collateral.
2875      */
2876     function lockedCollateral(address account)
2877         public
2878         view
2879         returns (uint)
2880     {
2881         uint debt = issuanceDraft(account);
2882         uint collat = collateral(account);
2883         if (debt > collat) {
2884             return collat;
2885         }
2886         return debt;
2887     }
2888 
2889     /**
2890      * @notice Collateral that is not locked and available for issuance.
2891      */
2892     function unlockedCollateral(address account)
2893         public
2894         view
2895         returns (uint)
2896     {
2897         uint locked = lockedCollateral(account);
2898         uint collat = collateral(account);
2899         return safeSub(collat, locked);
2900     }
2901 
2902     /**
2903      * @notice The number of havvens that are free to be transferred by an account.
2904      * @dev If they have enough available Havvens, it could be that
2905      * their havvens are escrowed, however the transfer would then
2906      * fail. This means that escrowed havvens are locked first,
2907      * and then the actual transferable ones.
2908      */
2909     function transferableHavvens(address account)
2910         public
2911         view
2912         returns (uint)
2913     {
2914         uint draft = issuanceDraft(account);
2915         uint collat = collateral(account);
2916         // In the case where the issuanceDraft exceeds the collateral, nothing is free
2917         if (draft > collat) {
2918             return 0;
2919         }
2920 
2921         uint bal = balanceOf(account);
2922         // In the case where the draft exceeds the escrow, but not the whole collateral
2923         //   return the fraction of the balance that remains free
2924         if (draft > safeSub(collat, bal)) {
2925             return safeSub(collat, draft);
2926         }
2927         // In the case where the draft doesn't exceed the escrow, return the entire balance
2928         return bal;
2929     }
2930 
2931     /**
2932      * @notice The value in USD for a given amount of HAV
2933      */
2934     function HAVtoUSD(uint hav_dec)
2935         public
2936         view
2937         priceNotStale
2938         returns (uint)
2939     {
2940         return safeMul_dec(hav_dec, price);
2941     }
2942 
2943     /**
2944      * @notice The value in HAV for a given amount of USD
2945      */
2946     function USDtoHAV(uint usd_dec)
2947         public
2948         view
2949         priceNotStale
2950         returns (uint)
2951     {
2952         return safeDiv_dec(usd_dec, price);
2953     }
2954 
2955     /**
2956      * @notice Access point for the oracle to update the price of havvens.
2957      */
2958     function updatePrice(uint newPrice, uint timeSent)
2959         external
2960         onlyOracle  /* Should be callable only by the oracle. */
2961     {
2962         /* Must be the most recently sent price, but not too far in the future.
2963          * (so we can't lock ourselves out of updating the oracle for longer than this) */
2964         require(lastPriceUpdateTime < timeSent && timeSent < now + ORACLE_FUTURE_LIMIT,
2965             "Time sent must be bigger than the last update, and must be less than now + ORACLE_FUTURE_LIMIT");
2966 
2967         price = newPrice;
2968         lastPriceUpdateTime = timeSent;
2969         emitPriceUpdated(newPrice, timeSent);
2970 
2971         /* Check the fee period rollover within this as the price should be pushed every 15min. */
2972         rolloverFeePeriodIfElapsed();
2973     }
2974 
2975     /**
2976      * @notice Check if the price of havvens hasn't been updated for longer than the stale period.
2977      */
2978     function priceIsStale()
2979         public
2980         view
2981         returns (bool)
2982     {
2983         return safeAdd(lastPriceUpdateTime, priceStalePeriod) < now;
2984     }
2985 
2986     /* ========== MODIFIERS ========== */
2987 
2988     modifier requireIssuer(address account)
2989     {
2990         require(isIssuer[account], "Must be issuer to perform this action");
2991         _;
2992     }
2993 
2994     modifier onlyOracle
2995     {
2996         require(msg.sender == oracle, "Must be oracle to perform this action");
2997         _;
2998     }
2999 
3000     modifier priceNotStale
3001     {
3002         require(!priceIsStale(), "Price must not be stale to perform this action");
3003         _;
3004     }
3005 
3006     /* ========== EVENTS ========== */
3007 
3008     event PriceUpdated(uint newPrice, uint timestamp);
3009     bytes32 constant PRICEUPDATED_SIG = keccak256("PriceUpdated(uint256,uint256)");
3010     function emitPriceUpdated(uint newPrice, uint timestamp) internal {
3011         proxy._emit(abi.encode(newPrice, timestamp), 1, PRICEUPDATED_SIG, 0, 0, 0);
3012     }
3013 
3014     event IssuanceRatioUpdated(uint newRatio);
3015     bytes32 constant ISSUANCERATIOUPDATED_SIG = keccak256("IssuanceRatioUpdated(uint256)");
3016     function emitIssuanceRatioUpdated(uint newRatio) internal {
3017         proxy._emit(abi.encode(newRatio), 1, ISSUANCERATIOUPDATED_SIG, 0, 0, 0);
3018     }
3019 
3020     event FeePeriodRollover(uint timestamp);
3021     bytes32 constant FEEPERIODROLLOVER_SIG = keccak256("FeePeriodRollover(uint256)");
3022     function emitFeePeriodRollover(uint timestamp) internal {
3023         proxy._emit(abi.encode(timestamp), 1, FEEPERIODROLLOVER_SIG, 0, 0, 0);
3024     } 
3025 
3026     event FeePeriodDurationUpdated(uint duration);
3027     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
3028     function emitFeePeriodDurationUpdated(uint duration) internal {
3029         proxy._emit(abi.encode(duration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
3030     } 
3031 
3032     event FeesWithdrawn(address indexed account, uint value);
3033     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
3034     function emitFeesWithdrawn(address account, uint value) internal {
3035         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
3036     }
3037 
3038     event OracleUpdated(address newOracle);
3039     bytes32 constant ORACLEUPDATED_SIG = keccak256("OracleUpdated(address)");
3040     function emitOracleUpdated(address newOracle) internal {
3041         proxy._emit(abi.encode(newOracle), 1, ORACLEUPDATED_SIG, 0, 0, 0);
3042     }
3043 
3044     event NominUpdated(address newNomin);
3045     bytes32 constant NOMINUPDATED_SIG = keccak256("NominUpdated(address)");
3046     function emitNominUpdated(address newNomin) internal {
3047         proxy._emit(abi.encode(newNomin), 1, NOMINUPDATED_SIG, 0, 0, 0);
3048     }
3049 
3050     event EscrowUpdated(address newEscrow);
3051     bytes32 constant ESCROWUPDATED_SIG = keccak256("EscrowUpdated(address)");
3052     function emitEscrowUpdated(address newEscrow) internal {
3053         proxy._emit(abi.encode(newEscrow), 1, ESCROWUPDATED_SIG, 0, 0, 0);
3054     }
3055 
3056     event IssuersUpdated(address indexed account, bool indexed value);
3057     bytes32 constant ISSUERSUPDATED_SIG = keccak256("IssuersUpdated(address,bool)");
3058     function emitIssuersUpdated(address account, bool value) internal {
3059         proxy._emit(abi.encode(), 3, ISSUERSUPDATED_SIG, bytes32(account), bytes32(value ? 1 : 0), 0);
3060     }
3061 
3062 }
3063 
3064 
3065 ////////////////// Depot.sol //////////////////
3066 
3067 /*
3068 -----------------------------------------------------------------
3069 FILE INFORMATION
3070 -----------------------------------------------------------------
3071 
3072 file:       Depot.sol
3073 version:    3.0
3074 author:     Kevin Brown
3075 date:       2018-10-23
3076 
3077 -----------------------------------------------------------------
3078 MODULE DESCRIPTION
3079 -----------------------------------------------------------------
3080 
3081 Depot contract. The Depot provides
3082 a way for users to acquire nomins (Nomin.sol) and havvens
3083 (Havven.sol) by paying ETH and a way for users to acquire havvens
3084 (Havven.sol) by paying nomins. Users can also deposit their nomins
3085 and allow other users to purchase them with ETH. The ETH is sent
3086 to the user who offered their nomins for sale.
3087 
3088 This smart contract contains a balance of each token, and
3089 allows the owner of the contract (the Havven Foundation) to
3090 manage the available balance of havven at their discretion, while
3091 users are allowed to deposit and withdraw their own nomin deposits
3092 if they have not yet been taken up by another user.
3093 
3094 -----------------------------------------------------------------
3095 */
3096 
3097 
3098 /**
3099  * @title Depot Contract.
3100  */
3101 contract Depot is SafeDecimalMath, SelfDestructible, Pausable {
3102 
3103     /* ========== STATE VARIABLES ========== */
3104     Havven public havven;
3105     Nomin public nomin;
3106 
3107     // Address where the ether and Nomins raised for selling HAV is transfered to
3108     // Any ether raised for selling Nomins gets sent back to whoever deposited the Nomins,
3109     // and doesn't have anything to do with this address.
3110     address public fundsWallet;
3111 
3112     /* The address of the oracle which pushes the USD price havvens and ether to this contract */
3113     address public oracle;
3114     /* Do not allow the oracle to submit times any further forward into the future than
3115        this constant. */
3116     uint public constant ORACLE_FUTURE_LIMIT = 10 minutes;
3117 
3118     /* How long will the contract assume the price of any asset is correct */
3119     uint public priceStalePeriod = 3 hours;
3120 
3121     /* The time the prices were last updated */
3122     uint public lastPriceUpdateTime;
3123     /* The USD price of havvens denominated in UNIT */
3124     uint public usdToHavPrice;
3125     /* The USD price of ETH denominated in UNIT */
3126     uint public usdToEthPrice;
3127 
3128     /* Stores deposits from users. */
3129     struct nominDeposit {
3130         // The user that made the deposit
3131         address user;
3132         // The amount (in Nomins) that they deposited
3133         uint amount;
3134     }
3135 
3136     /* User deposits are sold on a FIFO (First in First out) basis. When users deposit
3137        nomins with us, they get added this queue, which then gets fulfilled in order.
3138        Conceptually this fits well in an array, but then when users fill an order we
3139        end up copying the whole array around, so better to use an index mapping instead
3140        for gas performance reasons.
3141 
3142        The indexes are specified (inclusive, exclusive), so (0, 0) means there's nothing
3143        in the array, and (3, 6) means there are 3 elements at 3, 4, and 5. You can obtain
3144        the length of the "array" by querying depositEndIndex - depositStartIndex. All index
3145        operations use safeAdd, so there is no way to overflow, so that means there is a
3146        very large but finite amount of deposits this contract can handle before it fills up. */
3147     mapping(uint => nominDeposit) public deposits;
3148     // The starting index of our queue inclusive
3149     uint public depositStartIndex;
3150     // The ending index of our queue exclusive
3151     uint public depositEndIndex;
3152 
3153     /* This is a convenience variable so users and dApps can just query how much nUSD
3154        we have available for purchase without having to iterate the mapping with a
3155        O(n) amount of calls for something we'll probably want to display quite regularly. */
3156     uint public totalSellableDeposits;
3157 
3158     // The minimum amount of nUSD required to enter the FiFo queue
3159     uint public minimumDepositAmount = 50 * UNIT;
3160 
3161     // If a user deposits a nomin amount < the minimumDepositAmount the contract will keep
3162     // the total of small deposits which will not be sold on market and the sender
3163     // must call withdrawMyDepositedNomins() to get them back.
3164     mapping(address => uint) public smallDeposits;
3165 
3166 
3167     /* ========== CONSTRUCTOR ========== */
3168 
3169     /**
3170      * @dev Constructor
3171      * @param _owner The owner of this contract.
3172      * @param _fundsWallet The recipient of ETH and Nomins that are sent to this contract while exchanging.
3173      * @param _havven The Havven contract we'll interact with for balances and sending.
3174      * @param _nomin The Nomin contract we'll interact with for balances and sending.
3175      * @param _oracle The address which is able to update price information.
3176      * @param _usdToEthPrice The current price of ETH in USD, expressed in UNIT.
3177      * @param _usdToHavPrice The current price of Havven in USD, expressed in UNIT.
3178      */
3179     constructor(
3180         // Ownable
3181         address _owner,
3182 
3183         // Funds Wallet
3184         address _fundsWallet,
3185 
3186         // Other contracts needed
3187         Havven _havven,
3188         Nomin _nomin,
3189 
3190         // Oracle values - Allows for price updates
3191         address _oracle,
3192         uint _usdToEthPrice,
3193         uint _usdToHavPrice
3194     )
3195         /* Owned is initialised in SelfDestructible */
3196         SelfDestructible(_owner)
3197         Pausable(_owner)
3198         public
3199     {
3200         fundsWallet = _fundsWallet;
3201         havven = _havven;
3202         nomin = _nomin;
3203         oracle = _oracle;
3204         usdToEthPrice = _usdToEthPrice;
3205         usdToHavPrice = _usdToHavPrice;
3206         lastPriceUpdateTime = now;
3207     }
3208 
3209     /* ========== SETTERS ========== */
3210 
3211     /**
3212      * @notice Set the funds wallet where ETH raised is held
3213      * @param _fundsWallet The new address to forward ETH and Nomins to
3214      */
3215     function setFundsWallet(address _fundsWallet)
3216         external
3217         onlyOwner
3218     {
3219         fundsWallet = _fundsWallet;
3220         emit FundsWalletUpdated(fundsWallet);
3221     }
3222 
3223     /**
3224      * @notice Set the Oracle that pushes the havven price to this contract
3225      * @param _oracle The new oracle address
3226      */
3227     function setOracle(address _oracle)
3228         external
3229         onlyOwner
3230     {
3231         oracle = _oracle;
3232         emit OracleUpdated(oracle);
3233     }
3234 
3235     /**
3236      * @notice Set the Nomin contract that the issuance controller uses to issue Nomins.
3237      * @param _nomin The new nomin contract target
3238      */
3239     function setNomin(Nomin _nomin)
3240         external
3241         onlyOwner
3242     {
3243         nomin = _nomin;
3244         emit NominUpdated(_nomin);
3245     }
3246 
3247     /**
3248      * @notice Set the Havven contract that the issuance controller uses to issue Havvens.
3249      * @param _havven The new havven contract target
3250      */
3251     function setHavven(Havven _havven)
3252         external
3253         onlyOwner
3254     {
3255         havven = _havven;
3256         emit HavvenUpdated(_havven);
3257     }
3258 
3259     /**
3260      * @notice Set the stale period on the updated price variables
3261      * @param _time The new priceStalePeriod
3262      */
3263     function setPriceStalePeriod(uint _time)
3264         external
3265         onlyOwner
3266     {
3267         priceStalePeriod = _time;
3268         emit PriceStalePeriodUpdated(priceStalePeriod);
3269     }
3270 
3271     /**
3272      * @notice Set the minimum deposit amount required to depoist nUSD into the FIFO queue
3273      * @param _amount The new new minimum number of nUSD required to deposit
3274      */
3275     function setMinimumDepositAmount(uint _amount)
3276         external
3277         onlyOwner
3278     {
3279         //Do not allow us to set it less than 1 dollar opening up to fractional desposits in the queue again
3280         require(_amount > 1 * UNIT);
3281         minimumDepositAmount = _amount;
3282         emit MinimumDepositAmountUpdated(minimumDepositAmount);
3283     }
3284 
3285     /* ========== MUTATIVE FUNCTIONS ========== */
3286     /**
3287      * @notice Access point for the oracle to update the prices of havvens / eth.
3288      * @param newEthPrice The current price of ether in USD, specified to 18 decimal places.
3289      * @param newHavvenPrice The current price of havvens in USD, specified to 18 decimal places.
3290      * @param timeSent The timestamp from the oracle when the transaction was created. This ensures we don't consider stale prices as current in times of heavy network congestion.
3291      */
3292     function updatePrices(uint newEthPrice, uint newHavvenPrice, uint timeSent)
3293         external
3294         onlyOracle
3295     {
3296         /* Must be the most recently sent price, but not too far in the future.
3297          * (so we can't lock ourselves out of updating the oracle for longer than this) */
3298         require(lastPriceUpdateTime < timeSent, "Time must be later than last update");
3299         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time must be less than now + ORACLE_FUTURE_LIMIT");
3300 
3301         usdToEthPrice = newEthPrice;
3302         usdToHavPrice = newHavvenPrice;
3303         lastPriceUpdateTime = timeSent;
3304 
3305         emit PricesUpdated(usdToEthPrice, usdToHavPrice, lastPriceUpdateTime);
3306     }
3307 
3308     /**
3309      * @notice Fallback function (exchanges ETH to nUSD)
3310      */
3311     function ()
3312         external
3313         payable
3314     {
3315         exchangeEtherForNomins();
3316     }
3317 
3318     /**
3319      * @notice Exchange ETH to nUSD.
3320      */
3321     function exchangeEtherForNomins()
3322         public
3323         payable
3324         pricesNotStale
3325         notPaused
3326         returns (uint) // Returns the number of Nomins (nUSD) received
3327     {
3328         uint ethToSend;
3329 
3330         // The multiplication works here because usdToEthPrice is specified in
3331         // 18 decimal places, just like our currency base.
3332         uint requestedToPurchase = safeMul_dec(msg.value, usdToEthPrice);
3333         uint remainingToFulfill = requestedToPurchase;
3334 
3335         // Iterate through our outstanding deposits and sell them one at a time.
3336         for (uint i = depositStartIndex; remainingToFulfill > 0 && i < depositEndIndex; i++) {
3337             nominDeposit memory deposit = deposits[i];
3338 
3339             // If it's an empty spot in the queue from a previous withdrawal, just skip over it and
3340             // update the queue. It's already been deleted.
3341             if (deposit.user == address(0)) {
3342 
3343                 depositStartIndex = safeAdd(depositStartIndex, 1);
3344             } else {
3345                 // If the deposit can more than fill the order, we can do this
3346                 // without touching the structure of our queue.
3347                 if (deposit.amount > remainingToFulfill) {
3348 
3349                     // Ok, this deposit can fulfill the whole remainder. We don't need
3350                     // to change anything about our queue we can just fulfill it.
3351                     // Subtract the amount from our deposit and total.
3352                     deposit.amount = safeSub(deposit.amount, remainingToFulfill);
3353                     totalSellableDeposits = safeSub(totalSellableDeposits, remainingToFulfill);
3354 
3355                     // Transfer the ETH to the depositor. Send is used instead of transfer
3356                     // so a non payable contract won't block the FIFO queue on a failed
3357                     // ETH payable for nomins transaction. The proceeds to be sent to the
3358                     // havven foundation funds wallet. This is to protect all depositors
3359                     // in the queue in this rare case that may occur.
3360                     ethToSend = safeDiv_dec(remainingToFulfill, usdToEthPrice);
3361                     if(!deposit.user.send(ethToSend)) {
3362                         fundsWallet.transfer(ethToSend);
3363                         emit NonPayableContract(deposit.user, ethToSend);
3364                     }
3365 
3366                     // And the Nomins to the recipient.
3367                     // Note: Fees are calculated by the Nomin contract, so when
3368                     //       we request a specific transfer here, the fee is
3369                     //       automatically deducted and sent to the fee pool.
3370                     nomin.transfer(msg.sender, remainingToFulfill);
3371 
3372                     // And we have nothing left to fulfill on this order.
3373                     remainingToFulfill = 0;
3374                 } else if (deposit.amount <= remainingToFulfill) {
3375                     // We need to fulfill this one in its entirety and kick it out of the queue.
3376                     // Start by kicking it out of the queue.
3377                     // Free the storage because we can.
3378                     delete deposits[i];
3379                     // Bump our start index forward one.
3380                     depositStartIndex = safeAdd(depositStartIndex, 1);
3381                     // We also need to tell our total it's decreased
3382                     totalSellableDeposits = safeSub(totalSellableDeposits, deposit.amount);
3383 
3384                     // Now fulfill by transfering the ETH to the depositor. Send is used instead of transfer
3385                     // so a non payable contract won't block the FIFO queue on a failed
3386                     // ETH payable for nomins transaction. The proceeds to be sent to the
3387                     // havven foundation funds wallet. This is to protect all depositors
3388                     // in the queue in this rare case that may occur.
3389                     ethToSend = safeDiv_dec(deposit.amount, usdToEthPrice);
3390                     if(!deposit.user.send(ethToSend)) {
3391                         fundsWallet.transfer(ethToSend);
3392                         emit NonPayableContract(deposit.user, ethToSend);
3393                     }
3394 
3395                     // And the Nomins to the recipient.
3396                     // Note: Fees are calculated by the Nomin contract, so when
3397                     //       we request a specific transfer here, the fee is
3398                     //       automatically deducted and sent to the fee pool.
3399                     nomin.transfer(msg.sender, deposit.amount);
3400 
3401                     // And subtract the order from our outstanding amount remaining
3402                     // for the next iteration of the loop.
3403                     remainingToFulfill = safeSub(remainingToFulfill, deposit.amount);
3404                 }
3405             }
3406         }
3407 
3408         // Ok, if we're here and 'remainingToFulfill' isn't zero, then
3409         // we need to refund the remainder of their ETH back to them.
3410         if (remainingToFulfill > 0) {
3411             msg.sender.transfer(safeDiv_dec(remainingToFulfill, usdToEthPrice));
3412         }
3413 
3414         // How many did we actually give them?
3415         uint fulfilled = safeSub(requestedToPurchase, remainingToFulfill);
3416 
3417         if (fulfilled > 0) {
3418             // Now tell everyone that we gave them that many (only if the amount is greater than 0).
3419             emit Exchange("ETH", msg.value, "nUSD", fulfilled);
3420         }
3421 
3422         return fulfilled;
3423     }
3424 
3425     /**
3426      * @notice Exchange ETH to nUSD while insisting on a particular rate. This allows a user to
3427      *         exchange while protecting against frontrunning by the contract owner on the exchange rate.
3428      * @param guaranteedRate The exchange rate (ether price) which must be honored or the call will revert.
3429      */
3430     function exchangeEtherForNominsAtRate(uint guaranteedRate)
3431         public
3432         payable
3433         pricesNotStale
3434         notPaused
3435         returns (uint) // Returns the number of Nomins (nUSD) received
3436     {
3437         require(guaranteedRate == usdToEthPrice);
3438 
3439         return exchangeEtherForNomins();
3440     }
3441 
3442 
3443     /**
3444      * @notice Exchange ETH to HAV.
3445      */
3446     function exchangeEtherForHavvens()
3447         public
3448         payable
3449         pricesNotStale
3450         notPaused
3451         returns (uint) // Returns the number of Havvens (HAV) received
3452     {
3453         // How many Havvens are they going to be receiving?
3454         uint havvensToSend = havvensReceivedForEther(msg.value);
3455 
3456         // Store the ETH in our funds wallet
3457         fundsWallet.transfer(msg.value);
3458 
3459         // And send them the Havvens.
3460         havven.transfer(msg.sender, havvensToSend);
3461 
3462         emit Exchange("ETH", msg.value, "HAV", havvensToSend);
3463 
3464         return havvensToSend;
3465     }
3466 
3467     /**
3468      * @notice Exchange ETH to HAV while insisting on a particular set of rates. This allows a user to
3469      *         exchange while protecting against frontrunning by the contract owner on the exchange rates.
3470      * @param guaranteedEtherRate The ether exchange rate which must be honored or the call will revert.
3471      * @param guaranteedHavvenRate The havven exchange rate which must be honored or the call will revert.
3472      */
3473     function exchangeEtherForHavvensAtRate(uint guaranteedEtherRate, uint guaranteedHavvenRate)
3474         public
3475         payable
3476         pricesNotStale
3477         notPaused
3478         returns (uint) // Returns the number of Havvens (HAV) received
3479     {
3480         require(guaranteedEtherRate == usdToEthPrice);
3481         require(guaranteedHavvenRate == usdToHavPrice);
3482 
3483         return exchangeEtherForHavvens();
3484     }
3485 
3486 
3487     /**
3488      * @notice Exchange nUSD for Havvens
3489      * @param nominAmount The amount of nomins the user wishes to exchange.
3490      */
3491     function exchangeNominsForHavvens(uint nominAmount)
3492         public
3493         pricesNotStale
3494         notPaused
3495         returns (uint) // Returns the number of Havvens (HAV) received
3496     {
3497         // How many Havvens are they going to be receiving?
3498         uint havvensToSend = havvensReceivedForNomins(nominAmount);
3499 
3500         // Ok, transfer the Nomins to our funds wallet.
3501         // These do not go in the deposit queue as they aren't for sale as such unless
3502         // they're sent back in from the funds wallet.
3503         nomin.transferFrom(msg.sender, fundsWallet, nominAmount);
3504 
3505         // And send them the Havvens.
3506         havven.transfer(msg.sender, havvensToSend);
3507 
3508         emit Exchange("nUSD", nominAmount, "HAV", havvensToSend);
3509 
3510         return havvensToSend;
3511     }
3512 
3513     /**
3514      * @notice Exchange nUSD for Havvens while insisting on a particular rate. This allows a user to
3515      *         exchange while protecting against frontrunning by the contract owner on the exchange rate.
3516      * @param nominAmount The amount of nomins the user wishes to exchange.
3517      * @param guaranteedRate A rate (havven price) the caller wishes to insist upon.
3518      */
3519     function exchangeNominsForHavvensAtRate(uint nominAmount, uint guaranteedRate)
3520         public
3521         pricesNotStale
3522         notPaused
3523         returns (uint) // Returns the number of Havvens (HAV) received
3524     {
3525         require(guaranteedRate == usdToHavPrice);
3526 
3527         return exchangeNominsForHavvens(nominAmount);
3528     }
3529 
3530     /**
3531      * @notice Allows the owner to withdraw havvens from this contract if needed.
3532      * @param amount The amount of havvens to attempt to withdraw (in 18 decimal places).
3533      */
3534     function withdrawHavvens(uint amount)
3535         external
3536         onlyOwner
3537     {
3538         havven.transfer(owner, amount);
3539 
3540         // We don't emit our own events here because we assume that anyone
3541         // who wants to watch what the Issuance Controller is doing can
3542         // just watch ERC20 events from the Nomin and/or Havven contracts
3543         // filtered to our address.
3544     }
3545 
3546     /**
3547      * @notice Allows a user to withdraw all of their previously deposited nomins from this contract if needed.
3548      *         Developer note: We could keep an index of address to deposits to make this operation more efficient
3549      *         but then all the other operations on the queue become less efficient. It's expected that this
3550      *         function will be very rarely used, so placing the inefficiency here is intentional. The usual
3551      *         use case does not involve a withdrawal.
3552      */
3553     function withdrawMyDepositedNomins()
3554         external
3555     {
3556         uint nominsToSend = 0;
3557 
3558         for (uint i = depositStartIndex; i < depositEndIndex; i++) {
3559             nominDeposit memory deposit = deposits[i];
3560 
3561             if (deposit.user == msg.sender) {
3562                 // The user is withdrawing this deposit. Remove it from our queue.
3563                 // We'll just leave a gap, which the purchasing logic can walk past.
3564                 nominsToSend = safeAdd(nominsToSend, deposit.amount);
3565                 delete deposits[i];
3566             }
3567         }
3568 
3569         // Update our total
3570         totalSellableDeposits = safeSub(totalSellableDeposits, nominsToSend);
3571 
3572         // Check if the user has tried to send deposit amounts < the minimumDepositAmount to the FIFO
3573         // queue which would have been added to this mapping for withdrawal only
3574         nominsToSend = safeAdd(nominsToSend, smallDeposits[msg.sender]);
3575         smallDeposits[msg.sender] = 0;
3576 
3577         // If there's nothing to do then go ahead and revert the transaction
3578         require(nominsToSend > 0, "You have no deposits to withdraw.");
3579 
3580         // Send their deposits back to them (minus fees)
3581         nomin.transfer(msg.sender, nominsToSend);
3582 
3583         emit NominWithdrawal(msg.sender, nominsToSend);
3584     }
3585 
3586     /**
3587      * @notice depositNomins: Allows users to deposit nomins via the approve / transferFrom workflow
3588      *         if they'd like. You can equally just transfer nomins to this contract and it will work
3589      *         exactly the same way but with one less call (and therefore cheaper transaction fees)
3590      * @param amount The amount of nUSD you wish to deposit (must have been approved first)
3591      */
3592     function depositNomins(uint amount)
3593         external
3594     {
3595         // Grab the amount of nomins
3596         nomin.transferFrom(msg.sender, this, amount);
3597 
3598         // Note, we don't need to add them to the deposit list below, as the Nomin contract itself will
3599         // call tokenFallback when the transfer happens, adding their deposit to the queue.
3600     }
3601 
3602     /**
3603      * @notice Triggers when users send us HAV or nUSD, but the modifier only allows nUSD calls to proceed.
3604      * @param from The address sending the nUSD
3605      * @param amount The amount of nUSD
3606      */
3607     function tokenFallback(address from, uint amount, bytes data)
3608         external
3609         onlyNomin
3610         returns (bool)
3611     {
3612         // A minimum deposit amount is designed to protect purchasers from over paying
3613         // gas for fullfilling multiple small nomin deposits
3614         if (amount < minimumDepositAmount) {
3615             // We cant fail/revert the transaction or send the nomins back in a reentrant call.
3616             // So we will keep your nomins balance seperate from the FIFO queue so you can withdraw them
3617             smallDeposits[from] = safeAdd(smallDeposits[from], amount);
3618 
3619             emit NominDepositNotAccepted(from, amount, minimumDepositAmount);
3620         } else {
3621             // Ok, thanks for the deposit, let's queue it up.
3622             deposits[depositEndIndex] = nominDeposit({ user: from, amount: amount });
3623             // Walk our index forward as well.
3624             depositEndIndex = safeAdd(depositEndIndex, 1);
3625 
3626             // And add it to our total.
3627             totalSellableDeposits = safeAdd(totalSellableDeposits, amount);
3628 
3629             emit NominDeposit(from, amount);
3630         }
3631     }
3632 
3633     /* ========== VIEWS ========== */
3634     /**
3635      * @notice Check if the prices haven't been updated for longer than the stale period.
3636      */
3637     function pricesAreStale()
3638         public
3639         view
3640         returns (bool)
3641     {
3642         return safeAdd(lastPriceUpdateTime, priceStalePeriod) < now;
3643     }
3644 
3645     /**
3646      * @notice Calculate how many havvens you will receive if you transfer
3647      *         an amount of nomins.
3648      * @param amount The amount of nomins (in 18 decimal places) you want to ask about
3649      */
3650     function havvensReceivedForNomins(uint amount)
3651         public
3652         view
3653         returns (uint)
3654     {
3655         // How many nomins would we receive after the transfer fee?
3656         uint nominsReceived = nomin.amountReceived(amount);
3657 
3658         // And what would that be worth in havvens based on the current price?
3659         return safeDiv_dec(nominsReceived, usdToHavPrice);
3660     }
3661 
3662     /**
3663      * @notice Calculate how many havvens you will receive if you transfer
3664      *         an amount of ether.
3665      * @param amount The amount of ether (in wei) you want to ask about
3666      */
3667     function havvensReceivedForEther(uint amount)
3668         public
3669         view
3670         returns (uint)
3671     {
3672         // How much is the ETH they sent us worth in nUSD (ignoring the transfer fee)?
3673         uint valueSentInNomins = safeMul_dec(amount, usdToEthPrice);
3674 
3675         // Now, how many HAV will that USD amount buy?
3676         return havvensReceivedForNomins(valueSentInNomins);
3677     }
3678 
3679     /**
3680      * @notice Calculate how many nomins you will receive if you transfer
3681      *         an amount of ether.
3682      * @param amount The amount of ether (in wei) you want to ask about
3683      */
3684     function nominsReceivedForEther(uint amount)
3685         public
3686         view
3687         returns (uint)
3688     {
3689         // How many nomins would that amount of ether be worth?
3690         uint nominsTransferred = safeMul_dec(amount, usdToEthPrice);
3691 
3692         // And how many of those would you receive after a transfer (deducting the transfer fee)
3693         return nomin.amountReceived(nominsTransferred);
3694     }
3695 
3696     /* ========== MODIFIERS ========== */
3697 
3698     modifier onlyOracle
3699     {
3700         require(msg.sender == oracle, "Only the oracle can perform this action");
3701         _;
3702     }
3703 
3704     modifier onlyNomin
3705     {
3706         // We're only interested in doing anything on receiving nUSD.
3707         require(msg.sender == address(nomin), "Only the nomin contract can perform this action");
3708         _;
3709     }
3710 
3711     modifier pricesNotStale
3712     {
3713         require(!pricesAreStale(), "Prices must not be stale to perform this action");
3714         _;
3715     }
3716 
3717     /* ========== EVENTS ========== */
3718 
3719     event FundsWalletUpdated(address newFundsWallet);
3720     event OracleUpdated(address newOracle);
3721     event NominUpdated(Nomin newNominContract);
3722     event HavvenUpdated(Havven newHavvenContract);
3723     event PriceStalePeriodUpdated(uint priceStalePeriod);
3724     event PricesUpdated(uint newEthPrice, uint newHavvenPrice, uint timeSent);
3725     event Exchange(string fromCurrency, uint fromAmount, string toCurrency, uint toAmount);
3726     event NominWithdrawal(address user, uint amount);
3727     event NominDeposit(address user, uint amount);
3728     event NominDepositNotAccepted(address user, uint amount, uint minimum);
3729     event MinimumDepositAmountUpdated(uint amount);
3730     event NonPayableContract(address receiver, uint amount);
3731 }