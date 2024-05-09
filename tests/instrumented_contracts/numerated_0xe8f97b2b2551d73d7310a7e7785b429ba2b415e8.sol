1 /*
2  * Nomin Contract
3  *
4  * The stable exchange token of the Havven stablecoin system.
5  *
6  * version: nUSDa.2
7  * date: 27 Nov 2018
8  * source: https://github.com/Havven/havven/blob/11aa8479f71eeaa3d17ffe0a0476043543b68b60/contracts/Nomin.sol
9  *
10  * MIT License
11  * ===========
12  *
13  * Copyright (c) 2018 Havven
14  *
15  * Permission is hereby granted, free of charge, to any person obtaining a copy
16  * of this software and associated documentation files (the "Software"), to deal
17  * in the Software without restriction, including without limitation the rights
18  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
19  * copies of the Software, and to permit persons to whom the Software is
20  * furnished to do so, subject to the following conditions:
21  *
22  * The above copyright notice and this permission notice shall be included in all
23  * copies or substantial portions of the Software.
24  *
25  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
26  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
27  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
28  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
29  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
30  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
31  */
32 
33 
34 ////////////////// SafeDecimalMath.sol //////////////////
35 
36 /*
37 -----------------------------------------------------------------
38 FILE INFORMATION
39 -----------------------------------------------------------------
40 
41 file:       SafeDecimalMath.sol
42 version:    1.0
43 author:     Anton Jurisevic
44 
45 date:       2018-2-5
46 
47 checked:    Mike Spain
48 approved:   Samuel Brooks
49 
50 -----------------------------------------------------------------
51 MODULE DESCRIPTION
52 -----------------------------------------------------------------
53 
54 A fixed point decimal library that provides basic mathematical
55 operations, and checks for unsafe arguments, for example that
56 would lead to overflows.
57 
58 Exceptions are thrown whenever those unsafe operations
59 occur.
60 
61 -----------------------------------------------------------------
62 */
63 
64 pragma solidity 0.4.24;
65 
66 
67 /**
68  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
69  * @dev Functions accepting uints in this contract and derived contracts
70  * are taken to be such fixed point decimals (including fiat, ether, and nomin quantities).
71  */
72 contract SafeDecimalMath {
73 
74     /* Number of decimal places in the representation. */
75     uint8 public constant decimals = 18;
76 
77     /* The number representing 1.0. */
78     uint public constant UNIT = 10 ** uint(decimals);
79 
80     /**
81      * @return True iff adding x and y will not overflow.
82      */
83     function addIsSafe(uint x, uint y)
84         pure
85         internal
86         returns (bool)
87     {
88         return x + y >= y;
89     }
90 
91     /**
92      * @return The result of adding x and y, throwing an exception in case of overflow.
93      */
94     function safeAdd(uint x, uint y)
95         pure
96         internal
97         returns (uint)
98     {
99         require(x + y >= y, "Safe add failed");
100         return x + y;
101     }
102 
103     /**
104      * @return True iff subtracting y from x will not overflow in the negative direction.
105      */
106     function subIsSafe(uint x, uint y)
107         pure
108         internal
109         returns (bool)
110     {
111         return y <= x;
112     }
113 
114     /**
115      * @return The result of subtracting y from x, throwing an exception in case of overflow.
116      */
117     function safeSub(uint x, uint y)
118         pure
119         internal
120         returns (uint)
121     {
122         require(y <= x, "Safe sub failed");
123         return x - y;
124     }
125 
126     /**
127      * @return True iff multiplying x and y would not overflow.
128      */
129     function mulIsSafe(uint x, uint y)
130         pure
131         internal
132         returns (bool)
133     {
134         if (x == 0) {
135             return true;
136         }
137         return (x * y) / x == y;
138     }
139 
140     /**
141      * @return The result of multiplying x and y, throwing an exception in case of overflow.
142      */
143     function safeMul(uint x, uint y)
144         pure
145         internal
146         returns (uint)
147     {
148         if (x == 0) {
149             return 0;
150         }
151         uint p = x * y;
152         require(p / x == y, "Safe mul failed");
153         return p;
154     }
155 
156     /**
157      * @return The result of multiplying x and y, interpreting the operands as fixed-point
158      * decimals. Throws an exception in case of overflow.
159      * 
160      * @dev A unit factor is divided out after the product of x and y is evaluated,
161      * so that product must be less than 2**256.
162      * Incidentally, the internal division always rounds down: one could have rounded to the nearest integer,
163      * but then one would be spending a significant fraction of a cent (of order a microether
164      * at present gas prices) in order to save less than one part in 0.5 * 10^18 per operation, if the operands
165      * contain small enough fractional components. It would also marginally diminish the 
166      * domain this function is defined upon. 
167      */
168     function safeMul_dec(uint x, uint y)
169         pure
170         internal
171         returns (uint)
172     {
173         /* Divide by UNIT to remove the extra factor introduced by the product. */
174         return safeMul(x, y) / UNIT;
175 
176     }
177 
178     /**
179      * @return True iff the denominator of x/y is nonzero.
180      */
181     function divIsSafe(uint x, uint y)
182         pure
183         internal
184         returns (bool)
185     {
186         return y != 0;
187     }
188 
189     /**
190      * @return The result of dividing x by y, throwing an exception if the divisor is zero.
191      */
192     function safeDiv(uint x, uint y)
193         pure
194         internal
195         returns (uint)
196     {
197         /* Although a 0 denominator already throws an exception,
198          * it is equivalent to a THROW operation, which consumes all gas.
199          * A require statement emits REVERT instead, which remits remaining gas. */
200         require(y != 0, "Denominator cannot be zero");
201         return x / y;
202     }
203 
204     /**
205      * @return The result of dividing x by y, interpreting the operands as fixed point decimal numbers.
206      * @dev Throws an exception in case of overflow or zero divisor; x must be less than 2^256 / UNIT.
207      * Internal rounding is downward: a similar caveat holds as with safeDecMul().
208      */
209     function safeDiv_dec(uint x, uint y)
210         pure
211         internal
212         returns (uint)
213     {
214         /* Reintroduce the UNIT factor that will be divided out by y. */
215         return safeDiv(safeMul(x, UNIT), y);
216     }
217 
218     /**
219      * @dev Convert an unsigned integer to a unsigned fixed-point decimal.
220      * Throw an exception if the result would be out of range.
221      */
222     function intToDec(uint i)
223         pure
224         internal
225         returns (uint)
226     {
227         return safeMul(i, UNIT);
228     }
229 }
230 
231 
232 ////////////////// Owned.sol //////////////////
233 
234 /*
235 -----------------------------------------------------------------
236 FILE INFORMATION
237 -----------------------------------------------------------------
238 
239 file:       Owned.sol
240 version:    1.1
241 author:     Anton Jurisevic
242             Dominic Romanowski
243 
244 date:       2018-2-26
245 
246 -----------------------------------------------------------------
247 MODULE DESCRIPTION
248 -----------------------------------------------------------------
249 
250 An Owned contract, to be inherited by other contracts.
251 Requires its owner to be explicitly set in the constructor.
252 Provides an onlyOwner access modifier.
253 
254 To change owner, the current owner must nominate the next owner,
255 who then has to accept the nomination. The nomination can be
256 cancelled before it is accepted by the new owner by having the
257 previous owner change the nomination (setting it to 0).
258 
259 -----------------------------------------------------------------
260 */
261 
262 
263 /**
264  * @title A contract with an owner.
265  * @notice Contract ownership can be transferred by first nominating the new owner,
266  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
267  */
268 contract Owned {
269     address public owner;
270     address public nominatedOwner;
271 
272     /**
273      * @dev Owned Constructor
274      */
275     constructor(address _owner)
276         public
277     {
278         require(_owner != address(0), "Owner address cannot be 0");
279         owner = _owner;
280         emit OwnerChanged(address(0), _owner);
281     }
282 
283     /**
284      * @notice Nominate a new owner of this contract.
285      * @dev Only the current owner may nominate a new owner.
286      */
287     function nominateNewOwner(address _owner)
288         external
289         onlyOwner
290     {
291         nominatedOwner = _owner;
292         emit OwnerNominated(_owner);
293     }
294 
295     /**
296      * @notice Accept the nomination to be owner.
297      */
298     function acceptOwnership()
299         external
300     {
301         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
302         emit OwnerChanged(owner, nominatedOwner);
303         owner = nominatedOwner;
304         nominatedOwner = address(0);
305     }
306 
307     modifier onlyOwner
308     {
309         require(msg.sender == owner, "Only the contract owner may perform this action");
310         _;
311     }
312 
313     event OwnerNominated(address newOwner);
314     event OwnerChanged(address oldOwner, address newOwner);
315 }
316 
317 ////////////////// SelfDestructible.sol //////////////////
318 
319 /*
320 -----------------------------------------------------------------
321 FILE INFORMATION
322 -----------------------------------------------------------------
323 
324 file:       SelfDestructible.sol
325 version:    1.2
326 author:     Anton Jurisevic
327 
328 date:       2018-05-29
329 
330 -----------------------------------------------------------------
331 MODULE DESCRIPTION
332 -----------------------------------------------------------------
333 
334 This contract allows an inheriting contract to be destroyed after
335 its owner indicates an intention and then waits for a period
336 without changing their mind. All ether contained in the contract
337 is forwarded to a nominated beneficiary upon destruction.
338 
339 -----------------------------------------------------------------
340 */
341 
342 
343 /**
344  * @title A contract that can be destroyed by its owner after a delay elapses.
345  */
346 contract SelfDestructible is Owned {
347 	
348 	uint public initiationTime;
349 	bool public selfDestructInitiated;
350 	address public selfDestructBeneficiary;
351 	uint public constant SELFDESTRUCT_DELAY = 4 weeks;
352 
353 	/**
354 	 * @dev Constructor
355 	 * @param _owner The account which controls this contract.
356 	 */
357 	constructor(address _owner)
358 	    Owned(_owner)
359 	    public
360 	{
361 		require(_owner != address(0), "Owner must not be the zero address");
362 		selfDestructBeneficiary = _owner;
363 		emit SelfDestructBeneficiaryUpdated(_owner);
364 	}
365 
366 	/**
367 	 * @notice Set the beneficiary address of this contract.
368 	 * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
369 	 * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
370 	 */
371 	function setSelfDestructBeneficiary(address _beneficiary)
372 		external
373 		onlyOwner
374 	{
375 		require(_beneficiary != address(0), "Beneficiary must not be the zero address");
376 		selfDestructBeneficiary = _beneficiary;
377 		emit SelfDestructBeneficiaryUpdated(_beneficiary);
378 	}
379 
380 	/**
381 	 * @notice Begin the self-destruction counter of this contract.
382 	 * Once the delay has elapsed, the contract may be self-destructed.
383 	 * @dev Only the contract owner may call this.
384 	 */
385 	function initiateSelfDestruct()
386 		external
387 		onlyOwner
388 	{
389 		initiationTime = now;
390 		selfDestructInitiated = true;
391 		emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
392 	}
393 
394 	/**
395 	 * @notice Terminate and reset the self-destruction timer.
396 	 * @dev Only the contract owner may call this.
397 	 */
398 	function terminateSelfDestruct()
399 		external
400 		onlyOwner
401 	{
402 		initiationTime = 0;
403 		selfDestructInitiated = false;
404 		emit SelfDestructTerminated();
405 	}
406 
407 	/**
408 	 * @notice If the self-destruction delay has elapsed, destroy this contract and
409 	 * remit any ether it owns to the beneficiary address.
410 	 * @dev Only the contract owner may call this.
411 	 */
412 	function selfDestruct()
413 		external
414 		onlyOwner
415 	{
416 		require(selfDestructInitiated, "Self destruct has not yet been initiated");
417 		require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay has not yet elapsed");
418 		address beneficiary = selfDestructBeneficiary;
419 		emit SelfDestructed(beneficiary);
420 		selfdestruct(beneficiary);
421 	}
422 
423 	event SelfDestructTerminated();
424 	event SelfDestructed(address beneficiary);
425 	event SelfDestructInitiated(uint selfDestructDelay);
426 	event SelfDestructBeneficiaryUpdated(address newBeneficiary);
427 }
428 
429 
430 ////////////////// State.sol //////////////////
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
494         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
495         _;
496     }
497 
498     /* ========== EVENTS ========== */
499 
500     event AssociatedContractUpdated(address associatedContract);
501 }
502 
503 
504 ////////////////// TokenState.sol //////////////////
505 
506 /*
507 -----------------------------------------------------------------
508 FILE INFORMATION
509 -----------------------------------------------------------------
510 
511 file:       TokenState.sol
512 version:    1.1
513 author:     Dominic Romanowski
514             Anton Jurisevic
515 
516 date:       2018-05-15
517 
518 -----------------------------------------------------------------
519 MODULE DESCRIPTION
520 -----------------------------------------------------------------
521 
522 A contract that holds the state of an ERC20 compliant token.
523 
524 This contract is used side by side with external state token
525 contracts, such as Havven and Nomin.
526 It provides an easy way to upgrade contract logic while
527 maintaining all user balances and allowances. This is designed
528 to make the changeover as easy as possible, since mappings
529 are not so cheap or straightforward to migrate.
530 
531 The first deployed contract would create this state contract,
532 using it as its store of balances.
533 When a new contract is deployed, it links to the existing
534 state contract, whose owner would then change its associated
535 contract to the new one.
536 
537 -----------------------------------------------------------------
538 */
539 
540 
541 /**
542  * @title ERC20 Token State
543  * @notice Stores balance information of an ERC20 token contract.
544  */
545 contract TokenState is State {
546 
547     /* ERC20 fields. */
548     mapping(address => uint) public balanceOf;
549     mapping(address => mapping(address => uint)) public allowance;
550 
551     /**
552      * @dev Constructor
553      * @param _owner The address which controls this contract.
554      * @param _associatedContract The ERC20 contract whose state this composes.
555      */
556     constructor(address _owner, address _associatedContract)
557         State(_owner, _associatedContract)
558         public
559     {}
560 
561     /* ========== SETTERS ========== */
562 
563     /**
564      * @notice Set ERC20 allowance.
565      * @dev Only the associated contract may call this.
566      * @param tokenOwner The authorising party.
567      * @param spender The authorised party.
568      * @param value The total value the authorised party may spend on the
569      * authorising party's behalf.
570      */
571     function setAllowance(address tokenOwner, address spender, uint value)
572         external
573         onlyAssociatedContract
574     {
575         allowance[tokenOwner][spender] = value;
576     }
577 
578     /**
579      * @notice Set the balance in a given account
580      * @dev Only the associated contract may call this.
581      * @param account The account whose value to set.
582      * @param value The new balance of the given account.
583      */
584     function setBalanceOf(address account, uint value)
585         external
586         onlyAssociatedContract
587     {
588         balanceOf[account] = value;
589     }
590 }
591 
592 
593 ////////////////// Proxy.sol //////////////////
594 
595 /*
596 -----------------------------------------------------------------
597 FILE INFORMATION
598 -----------------------------------------------------------------
599 
600 file:       Proxy.sol
601 version:    1.3
602 author:     Anton Jurisevic
603 
604 date:       2018-05-29
605 
606 -----------------------------------------------------------------
607 MODULE DESCRIPTION
608 -----------------------------------------------------------------
609 
610 A proxy contract that, if it does not recognise the function
611 being called on it, passes all value and call data to an
612 underlying target contract.
613 
614 This proxy has the capacity to toggle between DELEGATECALL
615 and CALL style proxy functionality.
616 
617 The former executes in the proxy's context, and so will preserve 
618 msg.sender and store data at the proxy address. The latter will not.
619 Therefore, any contract the proxy wraps in the CALL style must
620 implement the Proxyable interface, in order that it can pass msg.sender
621 into the underlying contract as the state parameter, messageSender.
622 
623 -----------------------------------------------------------------
624 */
625 
626 
627 contract Proxy is Owned {
628 
629     Proxyable public target;
630     bool public useDELEGATECALL;
631 
632     constructor(address _owner)
633         Owned(_owner)
634         public
635     {}
636 
637     function setTarget(Proxyable _target)
638         external
639         onlyOwner
640     {
641         target = _target;
642         emit TargetUpdated(_target);
643     }
644 
645     function setUseDELEGATECALL(bool value) 
646         external
647         onlyOwner
648     {
649         useDELEGATECALL = value;
650     }
651 
652     function _emit(bytes callData, uint numTopics,
653                    bytes32 topic1, bytes32 topic2,
654                    bytes32 topic3, bytes32 topic4)
655         external
656         onlyTarget
657     {
658         uint size = callData.length;
659         bytes memory _callData = callData;
660 
661         assembly {
662             /* The first 32 bytes of callData contain its length (as specified by the abi). 
663              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
664              * in length. It is also leftpadded to be a multiple of 32 bytes.
665              * This means moving call_data across 32 bytes guarantees we correctly access
666              * the data itself. */
667             switch numTopics
668             case 0 {
669                 log0(add(_callData, 32), size)
670             } 
671             case 1 {
672                 log1(add(_callData, 32), size, topic1)
673             }
674             case 2 {
675                 log2(add(_callData, 32), size, topic1, topic2)
676             }
677             case 3 {
678                 log3(add(_callData, 32), size, topic1, topic2, topic3)
679             }
680             case 4 {
681                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
682             }
683         }
684     }
685 
686     function()
687         external
688         payable
689     {
690         if (useDELEGATECALL) {
691             assembly {
692                 /* Copy call data into free memory region. */
693                 let free_ptr := mload(0x40)
694                 calldatacopy(free_ptr, 0, calldatasize)
695 
696                 /* Forward all gas and call data to the target contract. */
697                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
698                 returndatacopy(free_ptr, 0, returndatasize)
699 
700                 /* Revert if the call failed, otherwise return the result. */
701                 if iszero(result) { revert(free_ptr, returndatasize) }
702                 return(free_ptr, returndatasize)
703             }
704         } else {
705             /* Here we are as above, but must send the messageSender explicitly 
706              * since we are using CALL rather than DELEGATECALL. */
707             target.setMessageSender(msg.sender);
708             assembly {
709                 let free_ptr := mload(0x40)
710                 calldatacopy(free_ptr, 0, calldatasize)
711 
712                 /* We must explicitly forward ether to the underlying contract as well. */
713                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
714                 returndatacopy(free_ptr, 0, returndatasize)
715 
716                 if iszero(result) { revert(free_ptr, returndatasize) }
717                 return(free_ptr, returndatasize)
718             }
719         }
720     }
721 
722     modifier onlyTarget {
723         require(Proxyable(msg.sender) == target, "This action can only be performed by the proxy target");
724         _;
725     }
726 
727     event TargetUpdated(Proxyable newTarget);
728 }
729 
730 
731 ////////////////// Proxyable.sol //////////////////
732 
733 /*
734 -----------------------------------------------------------------
735 FILE INFORMATION
736 -----------------------------------------------------------------
737 
738 file:       Proxyable.sol
739 version:    1.1
740 author:     Anton Jurisevic
741 
742 date:       2018-05-15
743 
744 checked:    Mike Spain
745 approved:   Samuel Brooks
746 
747 -----------------------------------------------------------------
748 MODULE DESCRIPTION
749 -----------------------------------------------------------------
750 
751 A proxyable contract that works hand in hand with the Proxy contract
752 to allow for anyone to interact with the underlying contract both
753 directly and through the proxy.
754 
755 -----------------------------------------------------------------
756 */
757 
758 
759 // This contract should be treated like an abstract contract
760 contract Proxyable is Owned {
761     /* The proxy this contract exists behind. */
762     Proxy public proxy;
763 
764     /* The caller of the proxy, passed through to this contract.
765      * Note that every function using this member must apply the onlyProxy or
766      * optionalProxy modifiers, otherwise their invocations can use stale values. */ 
767     address messageSender; 
768 
769     constructor(address _proxy, address _owner)
770         Owned(_owner)
771         public
772     {
773         proxy = Proxy(_proxy);
774         emit ProxyUpdated(_proxy);
775     }
776 
777     function setProxy(address _proxy)
778         external
779         onlyOwner
780     {
781         proxy = Proxy(_proxy);
782         emit ProxyUpdated(_proxy);
783     }
784 
785     function setMessageSender(address sender)
786         external
787         onlyProxy
788     {
789         messageSender = sender;
790     }
791 
792     modifier onlyProxy {
793         require(Proxy(msg.sender) == proxy, "Only the proxy can call this function");
794         _;
795     }
796 
797     modifier optionalProxy
798     {
799         if (Proxy(msg.sender) != proxy) {
800             messageSender = msg.sender;
801         }
802         _;
803     }
804 
805     modifier optionalProxy_onlyOwner
806     {
807         if (Proxy(msg.sender) != proxy) {
808             messageSender = msg.sender;
809         }
810         require(messageSender == owner, "This action can only be performed by the owner");
811         _;
812     }
813 
814     event ProxyUpdated(address proxyAddress);
815 }
816 
817 
818 ////////////////// ReentrancyPreventer.sol //////////////////
819 
820 /*
821 -----------------------------------------------------------------
822 FILE INFORMATION
823 -----------------------------------------------------------------
824 
825 file:       ReentrancyPreventer.sol
826 version:    1.0
827 author:     Kevin Brown
828 date:       2018-08-06
829 
830 -----------------------------------------------------------------
831 MODULE DESCRIPTION
832 -----------------------------------------------------------------
833 
834 This contract offers a modifer that can prevent reentrancy on
835 particular actions. It will not work if you put it on multiple
836 functions that can be called from each other. Specifically guard
837 external entry points to the contract with the modifier only.
838 
839 -----------------------------------------------------------------
840 */
841 
842 
843 contract ReentrancyPreventer {
844     /* ========== MODIFIERS ========== */
845     bool isInFunctionBody = false;
846 
847     modifier preventReentrancy {
848         require(!isInFunctionBody, "Reverted to prevent reentrancy");
849         isInFunctionBody = true;
850         _;
851         isInFunctionBody = false;
852     }
853 }
854 
855 ////////////////// TokenFallbackCaller.sol //////////////////
856 
857 /*
858 -----------------------------------------------------------------
859 FILE INFORMATION
860 -----------------------------------------------------------------
861 
862 file:       TokenFallback.sol
863 version:    1.0
864 author:     Kevin Brown
865 date:       2018-08-10
866 
867 -----------------------------------------------------------------
868 MODULE DESCRIPTION
869 -----------------------------------------------------------------
870 
871 This contract provides the logic that's used to call tokenFallback()
872 when transfers happen.
873 
874 It's pulled out into its own module because it's needed in two
875 places, so instead of copy/pasting this logic and maininting it
876 both in Fee Token and Extern State Token, it's here and depended
877 on by both contracts.
878 
879 -----------------------------------------------------------------
880 */
881 
882 
883 contract TokenFallbackCaller is ReentrancyPreventer {
884     function callTokenFallbackIfNeeded(address sender, address recipient, uint amount, bytes data)
885         internal
886         preventReentrancy
887     {
888         /*
889             If we're transferring to a contract and it implements the tokenFallback function, call it.
890             This isn't ERC223 compliant because we don't revert if the contract doesn't implement tokenFallback.
891             This is because many DEXes and other contracts that expect to work with the standard
892             approve / transferFrom workflow don't implement tokenFallback but can still process our tokens as
893             usual, so it feels very harsh and likely to cause trouble if we add this restriction after having
894             previously gone live with a vanilla ERC20.
895         */
896 
897         // Is the to address a contract? We can check the code size on that address and know.
898         uint length;
899 
900         // solium-disable-next-line security/no-inline-assembly
901         assembly {
902             // Retrieve the size of the code on the recipient address
903             length := extcodesize(recipient)
904         }
905 
906         // If there's code there, it's a contract
907         if (length > 0) {
908             // Now we need to optionally call tokenFallback(address from, uint value).
909             // We can't call it the normal way because that reverts when the recipient doesn't implement the function.
910 
911             // solium-disable-next-line security/no-low-level-calls
912             recipient.call(abi.encodeWithSignature("tokenFallback(address,uint256,bytes)", sender, amount, data));
913 
914             // And yes, we specifically don't care if this call fails, so we're not checking the return value.
915         }
916     }
917 }
918 
919 
920 ////////////////// ExternStateToken.sol //////////////////
921 
922 /*
923 -----------------------------------------------------------------
924 FILE INFORMATION
925 -----------------------------------------------------------------
926 
927 file:       ExternStateToken.sol
928 version:    1.3
929 author:     Anton Jurisevic
930             Dominic Romanowski
931             Kevin Brown
932 
933 date:       2018-05-29
934 
935 -----------------------------------------------------------------
936 MODULE DESCRIPTION
937 -----------------------------------------------------------------
938 
939 A partial ERC20 token contract, designed to operate with a proxy.
940 To produce a complete ERC20 token, transfer and transferFrom
941 tokens must be implemented, using the provided _byProxy internal
942 functions.
943 This contract utilises an external state for upgradeability.
944 
945 -----------------------------------------------------------------
946 */
947 
948 
949 /**
950  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
951  */
952 contract ExternStateToken is SafeDecimalMath, SelfDestructible, Proxyable, TokenFallbackCaller {
953 
954     /* ========== STATE VARIABLES ========== */
955 
956     /* Stores balances and allowances. */
957     TokenState public tokenState;
958 
959     /* Other ERC20 fields.
960      * Note that the decimals field is defined in SafeDecimalMath.*/
961     string public name;
962     string public symbol;
963     uint public totalSupply;
964 
965     /**
966      * @dev Constructor.
967      * @param _proxy The proxy associated with this contract.
968      * @param _name Token's ERC20 name.
969      * @param _symbol Token's ERC20 symbol.
970      * @param _totalSupply The total supply of the token.
971      * @param _tokenState The TokenState contract address.
972      * @param _owner The owner of this contract.
973      */
974     constructor(address _proxy, TokenState _tokenState,
975                 string _name, string _symbol, uint _totalSupply,
976                 address _owner)
977         SelfDestructible(_owner)
978         Proxyable(_proxy, _owner)
979         public
980     {
981         name = _name;
982         symbol = _symbol;
983         totalSupply = _totalSupply;
984         tokenState = _tokenState;
985     }
986 
987     /* ========== VIEWS ========== */
988 
989     /**
990      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
991      * @param owner The party authorising spending of their funds.
992      * @param spender The party spending tokenOwner's funds.
993      */
994     function allowance(address owner, address spender)
995         public
996         view
997         returns (uint)
998     {
999         return tokenState.allowance(owner, spender);
1000     }
1001 
1002     /**
1003      * @notice Returns the ERC20 token balance of a given account.
1004      */
1005     function balanceOf(address account)
1006         public
1007         view
1008         returns (uint)
1009     {
1010         return tokenState.balanceOf(account);
1011     }
1012 
1013     /* ========== MUTATIVE FUNCTIONS ========== */
1014 
1015     /**
1016      * @notice Set the address of the TokenState contract.
1017      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
1018      * as balances would be unreachable.
1019      */ 
1020     function setTokenState(TokenState _tokenState)
1021         external
1022         optionalProxy_onlyOwner
1023     {
1024         tokenState = _tokenState;
1025         emitTokenStateUpdated(_tokenState);
1026     }
1027 
1028     function _internalTransfer(address from, address to, uint value, bytes data) 
1029         internal
1030         returns (bool)
1031     { 
1032         /* Disallow transfers to irretrievable-addresses. */
1033         require(to != address(0), "Cannot transfer to the 0 address");
1034         require(to != address(this), "Cannot transfer to the underlying contract");
1035         require(to != address(proxy), "Cannot transfer to the proxy contract");
1036 
1037         // Insufficient balance will be handled by the safe subtraction.
1038         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), value));
1039         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), value));
1040 
1041         // If the recipient is a contract, we need to call tokenFallback on it so they can do ERC223
1042         // actions when receiving our tokens. Unlike the standard, however, we don't revert if the
1043         // recipient contract doesn't implement tokenFallback.
1044         callTokenFallbackIfNeeded(from, to, value, data);
1045         
1046         // Emit a standard ERC20 transfer event
1047         emitTransfer(from, to, value);
1048 
1049         return true;
1050     }
1051 
1052     /**
1053      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
1054      * the onlyProxy or optionalProxy modifiers.
1055      */
1056     function _transfer_byProxy(address from, address to, uint value, bytes data)
1057         internal
1058         returns (bool)
1059     {
1060         return _internalTransfer(from, to, value, data);
1061     }
1062 
1063     /**
1064      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
1065      * possessing the optionalProxy or optionalProxy modifiers.
1066      */
1067     function _transferFrom_byProxy(address sender, address from, address to, uint value, bytes data)
1068         internal
1069         returns (bool)
1070     {
1071         /* Insufficient allowance will be handled by the safe subtraction. */
1072         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
1073         return _internalTransfer(from, to, value, data);
1074     }
1075 
1076     /**
1077      * @notice Approves spender to transfer on the message sender's behalf.
1078      */
1079     function approve(address spender, uint value)
1080         public
1081         optionalProxy
1082         returns (bool)
1083     {
1084         address sender = messageSender;
1085 
1086         tokenState.setAllowance(sender, spender, value);
1087         emitApproval(sender, spender, value);
1088         return true;
1089     }
1090 
1091     /* ========== EVENTS ========== */
1092 
1093     event Transfer(address indexed from, address indexed to, uint value);
1094     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
1095     function emitTransfer(address from, address to, uint value) internal {
1096         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
1097     }
1098 
1099     event Approval(address indexed owner, address indexed spender, uint value);
1100     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
1101     function emitApproval(address owner, address spender, uint value) internal {
1102         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
1103     }
1104 
1105     event TokenStateUpdated(address newTokenState);
1106     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
1107     function emitTokenStateUpdated(address newTokenState) internal {
1108         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
1109     }
1110 }
1111 
1112 
1113 ////////////////// FeeToken.sol //////////////////
1114 
1115 /*
1116 -----------------------------------------------------------------
1117 FILE INFORMATION
1118 -----------------------------------------------------------------
1119 
1120 file:       FeeToken.sol
1121 version:    1.3
1122 author:     Anton Jurisevic
1123             Dominic Romanowski
1124             Kevin Brown
1125 
1126 date:       2018-05-29
1127 
1128 -----------------------------------------------------------------
1129 MODULE DESCRIPTION
1130 -----------------------------------------------------------------
1131 
1132 A token which also has a configurable fee rate
1133 charged on its transfers. This is designed to be overridden in
1134 order to produce an ERC20-compliant token.
1135 
1136 These fees accrue into a pool, from which a nominated authority
1137 may withdraw.
1138 
1139 This contract utilises an external state for upgradeability.
1140 
1141 -----------------------------------------------------------------
1142 */
1143 
1144 
1145 /**
1146  * @title ERC20 Token contract, with detached state.
1147  * Additionally charges fees on each transfer.
1148  */
1149 contract FeeToken is ExternStateToken {
1150 
1151     /* ========== STATE VARIABLES ========== */
1152 
1153     /* ERC20 members are declared in ExternStateToken. */
1154 
1155     /* A percentage fee charged on each transfer. */
1156     uint public transferFeeRate;
1157     /* Fee may not exceed 10%. */
1158     uint constant MAX_TRANSFER_FEE_RATE = UNIT / 10;
1159     /* The address with the authority to distribute fees. */
1160     address public feeAuthority;
1161     /* The address that fees will be pooled in. */
1162     address public constant FEE_ADDRESS = 0xfeefeefeefeefeefeefeefeefeefeefeefeefeef;
1163 
1164 
1165     /* ========== CONSTRUCTOR ========== */
1166 
1167     /**
1168      * @dev Constructor.
1169      * @param _proxy The proxy associated with this contract.
1170      * @param _name Token's ERC20 name.
1171      * @param _symbol Token's ERC20 symbol.
1172      * @param _totalSupply The total supply of the token.
1173      * @param _transferFeeRate The fee rate to charge on transfers.
1174      * @param _feeAuthority The address which has the authority to withdraw fees from the accumulated pool.
1175      * @param _owner The owner of this contract.
1176      */
1177     constructor(address _proxy, TokenState _tokenState, string _name, string _symbol, uint _totalSupply,
1178                 uint _transferFeeRate, address _feeAuthority, address _owner)
1179         ExternStateToken(_proxy, _tokenState,
1180                          _name, _symbol, _totalSupply,
1181                          _owner)
1182         public
1183     {
1184         feeAuthority = _feeAuthority;
1185 
1186         /* Constructed transfer fee rate should respect the maximum fee rate. */
1187         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
1188         transferFeeRate = _transferFeeRate;
1189     }
1190 
1191     /* ========== SETTERS ========== */
1192 
1193     /**
1194      * @notice Set the transfer fee, anywhere within the range 0-10%.
1195      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1196      */
1197     function setTransferFeeRate(uint _transferFeeRate)
1198         external
1199         optionalProxy_onlyOwner
1200     {
1201         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
1202         transferFeeRate = _transferFeeRate;
1203         emitTransferFeeRateUpdated(_transferFeeRate);
1204     }
1205 
1206     /**
1207      * @notice Set the address of the user/contract responsible for collecting or
1208      * distributing fees.
1209      */
1210     function setFeeAuthority(address _feeAuthority)
1211         public
1212         optionalProxy_onlyOwner
1213     {
1214         feeAuthority = _feeAuthority;
1215         emitFeeAuthorityUpdated(_feeAuthority);
1216     }
1217 
1218     /* ========== VIEWS ========== */
1219 
1220     /**
1221      * @notice Calculate the Fee charged on top of a value being sent
1222      * @return Return the fee charged
1223      */
1224     function transferFeeIncurred(uint value)
1225         public
1226         view
1227         returns (uint)
1228     {
1229         return safeMul_dec(value, transferFeeRate);
1230         /* Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1231          * This is on the basis that transfers less than this value will result in a nil fee.
1232          * Probably too insignificant to worry about, but the following code will achieve it.
1233          *      if (fee == 0 && transferFeeRate != 0) {
1234          *          return _value;
1235          *      }
1236          *      return fee;
1237          */
1238     }
1239 
1240     /**
1241      * @notice The value that you would need to send so that the recipient receives
1242      * a specified value.
1243      */
1244     function transferPlusFee(uint value)
1245         external
1246         view
1247         returns (uint)
1248     {
1249         return safeAdd(value, transferFeeIncurred(value));
1250     }
1251 
1252     /**
1253      * @notice The amount the recipient will receive if you send a certain number of tokens.
1254      */
1255     function amountReceived(uint value)
1256         public
1257         view
1258         returns (uint)
1259     {
1260         return safeDiv_dec(value, safeAdd(UNIT, transferFeeRate));
1261     }
1262 
1263     /**
1264      * @notice Collected fees sit here until they are distributed.
1265      * @dev The balance of the nomin contract itself is the fee pool.
1266      */
1267     function feePool()
1268         external
1269         view
1270         returns (uint)
1271     {
1272         return tokenState.balanceOf(FEE_ADDRESS);
1273     }
1274 
1275     /* ========== MUTATIVE FUNCTIONS ========== */
1276 
1277     /**
1278      * @notice Base of transfer functions
1279      */
1280     function _internalTransfer(address from, address to, uint amount, uint fee, bytes data)
1281         internal
1282         returns (bool)
1283     {
1284         /* Disallow transfers to irretrievable-addresses. */
1285         require(to != address(0), "Cannot transfer to the 0 address");
1286         require(to != address(this), "Cannot transfer to the underlying contract");
1287         require(to != address(proxy), "Cannot transfer to the proxy contract");
1288 
1289         /* Insufficient balance will be handled by the safe subtraction. */
1290         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), safeAdd(amount, fee)));
1291         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), amount));
1292         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), fee));
1293 
1294         callTokenFallbackIfNeeded(from, to, amount, data);
1295 
1296         /* Emit events for both the transfer itself and the fee. */
1297         emitTransfer(from, to, amount);
1298         emitTransfer(from, FEE_ADDRESS, fee);
1299 
1300         return true;
1301     }
1302 
1303     /**
1304      * @notice ERC20 / ERC223 friendly transfer function.
1305      */
1306     function _transfer_byProxy(address sender, address to, uint value, bytes data)
1307         internal
1308         returns (bool)
1309     {
1310         uint received = amountReceived(value);
1311         uint fee = safeSub(value, received);
1312 
1313         return _internalTransfer(sender, to, received, fee, data);
1314     }
1315 
1316     /**
1317      * @notice ERC20 friendly transferFrom function.
1318      */
1319     function _transferFrom_byProxy(address sender, address from, address to, uint value, bytes data)
1320         internal
1321         returns (bool)
1322     {
1323         /* The fee is deducted from the amount sent. */
1324         uint received = amountReceived(value);
1325         uint fee = safeSub(value, received);
1326 
1327         /* Reduce the allowance by the amount we're transferring.
1328          * The safeSub call will handle an insufficient allowance. */
1329         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
1330 
1331         return _internalTransfer(from, to, received, fee, data);
1332     }
1333 
1334     /**
1335      * @notice Ability to transfer where the sender pays the fees (not ERC20)
1336      */
1337     function _transferSenderPaysFee_byProxy(address sender, address to, uint value, bytes data)
1338         internal
1339         returns (bool)
1340     {
1341         /* The fee is added to the amount sent. */
1342         uint fee = transferFeeIncurred(value);
1343         return _internalTransfer(sender, to, value, fee, data);
1344     }
1345 
1346     /**
1347      * @notice Ability to transferFrom where they sender pays the fees (not ERC20).
1348      */
1349     function _transferFromSenderPaysFee_byProxy(address sender, address from, address to, uint value, bytes data)
1350         internal
1351         returns (bool)
1352     {
1353         /* The fee is added to the amount sent. */
1354         uint fee = transferFeeIncurred(value);
1355         uint total = safeAdd(value, fee);
1356 
1357         /* Reduce the allowance by the amount we're transferring. */
1358         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), total));
1359 
1360         return _internalTransfer(from, to, value, fee, data);
1361     }
1362 
1363     /**
1364      * @notice Withdraw tokens from the fee pool into a given account.
1365      * @dev Only the fee authority may call this.
1366      */
1367     function withdrawFees(address account, uint value)
1368         external
1369         onlyFeeAuthority
1370         returns (bool)
1371     {
1372         require(account != address(0), "Must supply an account address to withdraw fees");
1373 
1374         /* 0-value withdrawals do nothing. */
1375         if (value == 0) {
1376             return false;
1377         }
1378 
1379         /* Safe subtraction ensures an exception is thrown if the balance is insufficient. */
1380         tokenState.setBalanceOf(FEE_ADDRESS, safeSub(tokenState.balanceOf(FEE_ADDRESS), value));
1381         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), value));
1382 
1383         emitFeesWithdrawn(account, value);
1384         emitTransfer(FEE_ADDRESS, account, value);
1385 
1386         return true;
1387     }
1388 
1389     /**
1390      * @notice Donate tokens from the sender's balance into the fee pool.
1391      */
1392     function donateToFeePool(uint n)
1393         external
1394         optionalProxy
1395         returns (bool)
1396     {
1397         address sender = messageSender;
1398         /* Empty donations are disallowed. */
1399         uint balance = tokenState.balanceOf(sender);
1400         require(balance != 0, "Must have a balance in order to donate to the fee pool");
1401 
1402         /* safeSub ensures the donor has sufficient balance. */
1403         tokenState.setBalanceOf(sender, safeSub(balance, n));
1404         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), n));
1405 
1406         emitFeesDonated(sender, n);
1407         emitTransfer(sender, FEE_ADDRESS, n);
1408 
1409         return true;
1410     }
1411 
1412 
1413     /* ========== MODIFIERS ========== */
1414 
1415     modifier onlyFeeAuthority
1416     {
1417         require(msg.sender == feeAuthority, "Only the fee authority can do this action");
1418         _;
1419     }
1420 
1421 
1422     /* ========== EVENTS ========== */
1423 
1424     event TransferFeeRateUpdated(uint newFeeRate);
1425     bytes32 constant TRANSFERFEERATEUPDATED_SIG = keccak256("TransferFeeRateUpdated(uint256)");
1426     function emitTransferFeeRateUpdated(uint newFeeRate) internal {
1427         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEERATEUPDATED_SIG, 0, 0, 0);
1428     }
1429 
1430     event FeeAuthorityUpdated(address newFeeAuthority);
1431     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
1432     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
1433         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
1434     } 
1435 
1436     event FeesWithdrawn(address indexed account, uint value);
1437     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
1438     function emitFeesWithdrawn(address account, uint value) internal {
1439         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
1440     }
1441 
1442     event FeesDonated(address indexed donor, uint value);
1443     bytes32 constant FEESDONATED_SIG = keccak256("FeesDonated(address,uint256)");
1444     function emitFeesDonated(address donor, uint value) internal {
1445         proxy._emit(abi.encode(value), 2, FEESDONATED_SIG, bytes32(donor), 0, 0);
1446     }
1447 }
1448 
1449 
1450 ////////////////// LimitedSetup.sol //////////////////
1451 
1452 /*
1453 -----------------------------------------------------------------
1454 FILE INFORMATION
1455 -----------------------------------------------------------------
1456 
1457 file:       LimitedSetup.sol
1458 version:    1.1
1459 author:     Anton Jurisevic
1460 
1461 date:       2018-05-15
1462 
1463 -----------------------------------------------------------------
1464 MODULE DESCRIPTION
1465 -----------------------------------------------------------------
1466 
1467 A contract with a limited setup period. Any function modified
1468 with the setup modifier will cease to work after the
1469 conclusion of the configurable-length post-construction setup period.
1470 
1471 -----------------------------------------------------------------
1472 */
1473 
1474 
1475 /**
1476  * @title Any function decorated with the modifier this contract provides
1477  * deactivates after a specified setup period.
1478  */
1479 contract LimitedSetup {
1480 
1481     uint setupExpiryTime;
1482 
1483     /**
1484      * @dev LimitedSetup Constructor.
1485      * @param setupDuration The time the setup period will last for.
1486      */
1487     constructor(uint setupDuration)
1488         public
1489     {
1490         setupExpiryTime = now + setupDuration;
1491     }
1492 
1493     modifier onlyDuringSetup
1494     {
1495         require(now < setupExpiryTime, "Can only perform this action during setup");
1496         _;
1497     }
1498 }
1499 
1500 
1501 ////////////////// HavvenEscrow.sol //////////////////
1502 
1503 /*
1504 -----------------------------------------------------------------
1505 FILE INFORMATION
1506 -----------------------------------------------------------------
1507 
1508 file:       HavvenEscrow.sol
1509 version:    1.1
1510 author:     Anton Jurisevic
1511             Dominic Romanowski
1512             Mike Spain
1513 
1514 date:       2018-05-29
1515 
1516 -----------------------------------------------------------------
1517 MODULE DESCRIPTION
1518 -----------------------------------------------------------------
1519 
1520 This contract allows the foundation to apply unique vesting
1521 schedules to havven funds sold at various discounts in the token
1522 sale. HavvenEscrow gives users the ability to inspect their
1523 vested funds, their quantities and vesting dates, and to withdraw
1524 the fees that accrue on those funds.
1525 
1526 The fees are handled by withdrawing the entire fee allocation
1527 for all havvens inside the escrow contract, and then allowing
1528 the contract itself to subdivide that pool up proportionally within
1529 itself. Every time the fee period rolls over in the main Havven
1530 contract, the HavvenEscrow fee pool is remitted back into the
1531 main fee pool to be redistributed in the next fee period.
1532 
1533 -----------------------------------------------------------------
1534 */
1535 
1536 
1537 /**
1538  * @title A contract to hold escrowed havvens and free them at given schedules.
1539  */
1540 contract HavvenEscrow is SafeDecimalMath, Owned, LimitedSetup(8 weeks) {
1541     /* The corresponding Havven contract. */
1542     Havven public havven;
1543 
1544     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
1545      * These are the times at which each given quantity of havvens vests. */
1546     mapping(address => uint[2][]) public vestingSchedules;
1547 
1548     /* An account's total vested havven balance to save recomputing this for fee extraction purposes. */
1549     mapping(address => uint) public totalVestedAccountBalance;
1550 
1551     /* The total remaining vested balance, for verifying the actual havven balance of this contract against. */
1552     uint public totalVestedBalance;
1553 
1554     uint constant TIME_INDEX = 0;
1555     uint constant QUANTITY_INDEX = 1;
1556 
1557     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
1558     uint constant MAX_VESTING_ENTRIES = 20;
1559 
1560 
1561     /* ========== CONSTRUCTOR ========== */
1562 
1563     constructor(address _owner, Havven _havven)
1564         Owned(_owner)
1565         public
1566     {
1567         havven = _havven;
1568     }
1569 
1570 
1571     /* ========== SETTERS ========== */
1572 
1573     function setHavven(Havven _havven)
1574         external
1575         onlyOwner
1576     {
1577         havven = _havven;
1578         emit HavvenUpdated(_havven);
1579     }
1580 
1581 
1582     /* ========== VIEW FUNCTIONS ========== */
1583 
1584     /**
1585      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
1586      */
1587     function balanceOf(address account)
1588         public
1589         view
1590         returns (uint)
1591     {
1592         return totalVestedAccountBalance[account];
1593     }
1594 
1595     /**
1596      * @notice The number of vesting dates in an account's schedule.
1597      */
1598     function numVestingEntries(address account)
1599         public
1600         view
1601         returns (uint)
1602     {
1603         return vestingSchedules[account].length;
1604     }
1605 
1606     /**
1607      * @notice Get a particular schedule entry for an account.
1608      * @return A pair of uints: (timestamp, havven quantity).
1609      */
1610     function getVestingScheduleEntry(address account, uint index)
1611         public
1612         view
1613         returns (uint[2])
1614     {
1615         return vestingSchedules[account][index];
1616     }
1617 
1618     /**
1619      * @notice Get the time at which a given schedule entry will vest.
1620      */
1621     function getVestingTime(address account, uint index)
1622         public
1623         view
1624         returns (uint)
1625     {
1626         return getVestingScheduleEntry(account,index)[TIME_INDEX];
1627     }
1628 
1629     /**
1630      * @notice Get the quantity of havvens associated with a given schedule entry.
1631      */
1632     function getVestingQuantity(address account, uint index)
1633         public
1634         view
1635         returns (uint)
1636     {
1637         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
1638     }
1639 
1640     /**
1641      * @notice Obtain the index of the next schedule entry that will vest for a given user.
1642      */
1643     function getNextVestingIndex(address account)
1644         public
1645         view
1646         returns (uint)
1647     {
1648         uint len = numVestingEntries(account);
1649         for (uint i = 0; i < len; i++) {
1650             if (getVestingTime(account, i) != 0) {
1651                 return i;
1652             }
1653         }
1654         return len;
1655     }
1656 
1657     /**
1658      * @notice Obtain the next schedule entry that will vest for a given user.
1659      * @return A pair of uints: (timestamp, havven quantity). */
1660     function getNextVestingEntry(address account)
1661         public
1662         view
1663         returns (uint[2])
1664     {
1665         uint index = getNextVestingIndex(account);
1666         if (index == numVestingEntries(account)) {
1667             return [uint(0), 0];
1668         }
1669         return getVestingScheduleEntry(account, index);
1670     }
1671 
1672     /**
1673      * @notice Obtain the time at which the next schedule entry will vest for a given user.
1674      */
1675     function getNextVestingTime(address account)
1676         external
1677         view
1678         returns (uint)
1679     {
1680         return getNextVestingEntry(account)[TIME_INDEX];
1681     }
1682 
1683     /**
1684      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
1685      */
1686     function getNextVestingQuantity(address account)
1687         external
1688         view
1689         returns (uint)
1690     {
1691         return getNextVestingEntry(account)[QUANTITY_INDEX];
1692     }
1693 
1694 
1695     /* ========== MUTATIVE FUNCTIONS ========== */
1696 
1697     /**
1698      * @notice Withdraws a quantity of havvens back to the havven contract.
1699      * @dev This may only be called by the owner during the contract's setup period.
1700      */
1701     function withdrawHavvens(uint quantity)
1702         external
1703         onlyOwner
1704         onlyDuringSetup
1705     {
1706         havven.transfer(havven, quantity);
1707     }
1708 
1709     /**
1710      * @notice Destroy the vesting information associated with an account.
1711      */
1712     function purgeAccount(address account)
1713         external
1714         onlyOwner
1715         onlyDuringSetup
1716     {
1717         delete vestingSchedules[account];
1718         totalVestedBalance = safeSub(totalVestedBalance, totalVestedAccountBalance[account]);
1719         delete totalVestedAccountBalance[account];
1720     }
1721 
1722     /**
1723      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
1724      * @dev A call to this should be accompanied by either enough balance already available
1725      * in this contract, or a corresponding call to havven.endow(), to ensure that when
1726      * the funds are withdrawn, there is enough balance, as well as correctly calculating
1727      * the fees.
1728      * This may only be called by the owner during the contract's setup period.
1729      * Note; although this function could technically be used to produce unbounded
1730      * arrays, it's only in the foundation's command to add to these lists.
1731      * @param account The account to append a new vesting entry to.
1732      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
1733      * @param quantity The quantity of havvens that will vest.
1734      */
1735     function appendVestingEntry(address account, uint time, uint quantity)
1736         public
1737         onlyOwner
1738         onlyDuringSetup
1739     {
1740         /* No empty or already-passed vesting entries allowed. */
1741         require(now < time, "Time must be in the future");
1742         require(quantity != 0, "Quantity cannot be zero");
1743 
1744         /* There must be enough balance in the contract to provide for the vesting entry. */
1745         totalVestedBalance = safeAdd(totalVestedBalance, quantity);
1746         require(totalVestedBalance <= havven.balanceOf(this), "Must be enough balance in the contract to provide for the vesting entry");
1747 
1748         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
1749         uint scheduleLength = vestingSchedules[account].length;
1750         require(scheduleLength <= MAX_VESTING_ENTRIES, "Vesting schedule is too long");
1751 
1752         if (scheduleLength == 0) {
1753             totalVestedAccountBalance[account] = quantity;
1754         } else {
1755             /* Disallow adding new vested havvens earlier than the last one.
1756              * Since entries are only appended, this means that no vesting date can be repeated. */
1757             require(getVestingTime(account, numVestingEntries(account) - 1) < time, "Cannot add new vested entries earlier than the last one");
1758             totalVestedAccountBalance[account] = safeAdd(totalVestedAccountBalance[account], quantity);
1759         }
1760 
1761         vestingSchedules[account].push([time, quantity]);
1762     }
1763 
1764     /**
1765      * @notice Construct a vesting schedule to release a quantities of havvens
1766      * over a series of intervals.
1767      * @dev Assumes that the quantities are nonzero
1768      * and that the sequence of timestamps is strictly increasing.
1769      * This may only be called by the owner during the contract's setup period.
1770      */
1771     function addVestingSchedule(address account, uint[] times, uint[] quantities)
1772         external
1773         onlyOwner
1774         onlyDuringSetup
1775     {
1776         for (uint i = 0; i < times.length; i++) {
1777             appendVestingEntry(account, times[i], quantities[i]);
1778         }
1779 
1780     }
1781 
1782     /**
1783      * @notice Allow a user to withdraw any havvens in their schedule that have vested.
1784      */
1785     function vest()
1786         external
1787     {
1788         uint numEntries = numVestingEntries(msg.sender);
1789         uint total;
1790         for (uint i = 0; i < numEntries; i++) {
1791             uint time = getVestingTime(msg.sender, i);
1792             /* The list is sorted; when we reach the first future time, bail out. */
1793             if (time > now) {
1794                 break;
1795             }
1796             uint qty = getVestingQuantity(msg.sender, i);
1797             if (qty == 0) {
1798                 continue;
1799             }
1800 
1801             vestingSchedules[msg.sender][i] = [0, 0];
1802             total = safeAdd(total, qty);
1803         }
1804 
1805         if (total != 0) {
1806             totalVestedBalance = safeSub(totalVestedBalance, total);
1807             totalVestedAccountBalance[msg.sender] = safeSub(totalVestedAccountBalance[msg.sender], total);
1808             havven.transfer(msg.sender, total);
1809             emit Vested(msg.sender, now, total);
1810         }
1811     }
1812 
1813 
1814     /* ========== EVENTS ========== */
1815 
1816     event HavvenUpdated(address newHavven);
1817 
1818     event Vested(address indexed beneficiary, uint time, uint value);
1819 }
1820 
1821 
1822 ////////////////// Havven.sol //////////////////
1823 
1824 /*
1825 -----------------------------------------------------------------
1826 FILE INFORMATION
1827 -----------------------------------------------------------------
1828 
1829 file:       Havven.sol
1830 version:    1.2
1831 author:     Anton Jurisevic
1832             Dominic Romanowski
1833 
1834 date:       2018-05-15
1835 
1836 -----------------------------------------------------------------
1837 MODULE DESCRIPTION
1838 -----------------------------------------------------------------
1839 
1840 Havven token contract. Havvens are transferable ERC20 tokens,
1841 and also give their holders the following privileges.
1842 An owner of havvens may participate in nomin confiscation votes, they
1843 may also have the right to issue nomins at the discretion of the
1844 foundation for this version of the contract.
1845 
1846 After a fee period terminates, the duration and fees collected for that
1847 period are computed, and the next period begins. Thus an account may only
1848 withdraw the fees owed to them for the previous period, and may only do
1849 so once per period. Any unclaimed fees roll over into the common pot for
1850 the next period.
1851 
1852 == Average Balance Calculations ==
1853 
1854 The fee entitlement of a havven holder is proportional to their average
1855 issued nomin balance over the last fee period. This is computed by
1856 measuring the area under the graph of a user's issued nomin balance over
1857 time, and then when a new fee period begins, dividing through by the
1858 duration of the fee period.
1859 
1860 We need only update values when the balances of an account is modified.
1861 This occurs when issuing or burning for issued nomin balances,
1862 and when transferring for havven balances. This is for efficiency,
1863 and adds an implicit friction to interacting with havvens.
1864 A havven holder pays for his own recomputation whenever he wants to change
1865 his position, which saves the foundation having to maintain a pot dedicated
1866 to resourcing this.
1867 
1868 A hypothetical user's balance history over one fee period, pictorially:
1869 
1870       s ____
1871        |    |
1872        |    |___ p
1873        |____|___|___ __ _  _
1874        f    t   n
1875 
1876 Here, the balance was s between times f and t, at which time a transfer
1877 occurred, updating the balance to p, until n, when the present transfer occurs.
1878 When a new transfer occurs at time n, the balance being p,
1879 we must:
1880 
1881   - Add the area p * (n - t) to the total area recorded so far
1882   - Update the last transfer time to n
1883 
1884 So if this graph represents the entire current fee period,
1885 the average havvens held so far is ((t-f)*s + (n-t)*p) / (n-f).
1886 The complementary computations must be performed for both sender and
1887 recipient.
1888 
1889 Note that a transfer keeps global supply of havvens invariant.
1890 The sum of all balances is constant, and unmodified by any transfer.
1891 So the sum of all balances multiplied by the duration of a fee period is also
1892 constant, and this is equivalent to the sum of the area of every user's
1893 time/balance graph. Dividing through by that duration yields back the total
1894 havven supply. So, at the end of a fee period, we really do yield a user's
1895 average share in the havven supply over that period.
1896 
1897 A slight wrinkle is introduced if we consider the time r when the fee period
1898 rolls over. Then the previous fee period k-1 is before r, and the current fee
1899 period k is afterwards. If the last transfer took place before r,
1900 but the latest transfer occurred afterwards:
1901 
1902 k-1       |        k
1903       s __|_
1904        |  | |
1905        |  | |____ p
1906        |__|_|____|___ __ _  _
1907           |
1908        f  | t    n
1909           r
1910 
1911 In this situation the area (r-f)*s contributes to fee period k-1, while
1912 the area (t-r)*s contributes to fee period k. We will implicitly consider a
1913 zero-value transfer to have occurred at time r. Their fee entitlement for the
1914 previous period will be finalised at the time of their first transfer during the
1915 current fee period, or when they query or withdraw their fee entitlement.
1916 
1917 In the implementation, the duration of different fee periods may be slightly irregular,
1918 as the check that they have rolled over occurs only when state-changing havven
1919 operations are performed.
1920 
1921 == Issuance and Burning ==
1922 
1923 In this version of the havven contract, nomins can only be issued by
1924 those that have been nominated by the havven foundation. Nomins are assumed
1925 to be valued at $1, as they are a stable unit of account.
1926 
1927 All nomins issued require a proportional value of havvens to be locked,
1928 where the proportion is governed by the current issuance ratio. This
1929 means for every $1 of Havvens locked up, $(issuanceRatio) nomins can be issued.
1930 i.e. to issue 100 nomins, 100/issuanceRatio dollars of havvens need to be locked up.
1931 
1932 To determine the value of some amount of havvens(H), an oracle is used to push
1933 the price of havvens (P_H) in dollars to the contract. The value of H
1934 would then be: H * P_H.
1935 
1936 Any havvens that are locked up by this issuance process cannot be transferred.
1937 The amount that is locked floats based on the price of havvens. If the price
1938 of havvens moves up, less havvens are locked, so they can be issued against,
1939 or transferred freely. If the price of havvens moves down, more havvens are locked,
1940 even going above the initial wallet balance.
1941 
1942 -----------------------------------------------------------------
1943 */
1944 
1945 
1946 /**
1947  * @title Havven ERC20 contract.
1948  * @notice The Havven contracts does not only facilitate transfers and track balances,
1949  * but it also computes the quantity of fees each havven holder is entitled to.
1950  */
1951 contract Havven is ExternStateToken {
1952 
1953     /* ========== STATE VARIABLES ========== */
1954 
1955     /* A struct for handing values associated with average balance calculations */
1956     struct IssuanceData {
1957         /* Sums of balances*duration in the current fee period.
1958         /* range: decimals; units: havven-seconds */
1959         uint currentBalanceSum;
1960         /* The last period's average balance */
1961         uint lastAverageBalance;
1962         /* The last time the data was calculated */
1963         uint lastModified;
1964     }
1965 
1966     /* Issued nomin balances for individual fee entitlements */
1967     mapping(address => IssuanceData) public issuanceData;
1968     /* The total number of issued nomins for determining fee entitlements */
1969     IssuanceData public totalIssuanceData;
1970 
1971     /* The time the current fee period began */
1972     uint public feePeriodStartTime;
1973     /* The time the last fee period began */
1974     uint public lastFeePeriodStartTime;
1975 
1976     /* Fee periods will roll over in no shorter a time than this. 
1977      * The fee period cannot actually roll over until a fee-relevant
1978      * operation such as withdrawal or a fee period duration update occurs,
1979      * so this is just a target, and the actual duration may be slightly longer. */
1980     uint public feePeriodDuration = 4 weeks;
1981     /* ...and must target between 1 day and six months. */
1982     uint constant MIN_FEE_PERIOD_DURATION = 1 days;
1983     uint constant MAX_FEE_PERIOD_DURATION = 26 weeks;
1984 
1985     /* The quantity of nomins that were in the fee pot at the time */
1986     /* of the last fee rollover, at feePeriodStartTime. */
1987     uint public lastFeesCollected;
1988 
1989     /* Whether a user has withdrawn their last fees */
1990     mapping(address => bool) public hasWithdrawnFees;
1991 
1992     Nomin public nomin;
1993     HavvenEscrow public escrow;
1994 
1995     /* The address of the oracle which pushes the havven price to this contract */
1996     address public oracle;
1997     /* The price of havvens written in UNIT */
1998     uint public price;
1999     /* The time the havven price was last updated */
2000     uint public lastPriceUpdateTime;
2001     /* How long will the contract assume the price of havvens is correct */
2002     uint public priceStalePeriod = 3 hours;
2003 
2004     /* A quantity of nomins greater than this ratio
2005      * may not be issued against a given value of havvens. */
2006     uint public issuanceRatio = UNIT / 5;
2007     /* No more nomins may be issued than the value of havvens backing them. */
2008     uint constant MAX_ISSUANCE_RATIO = UNIT;
2009 
2010     /* Whether the address can issue nomins or not. */
2011     mapping(address => bool) public isIssuer;
2012     /* The number of currently-outstanding nomins the user has issued. */
2013     mapping(address => uint) public nominsIssued;
2014 
2015     uint constant HAVVEN_SUPPLY = 1e8 * UNIT;
2016     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
2017     string constant TOKEN_NAME = "Havven";
2018     string constant TOKEN_SYMBOL = "HAV";
2019     
2020     /* ========== CONSTRUCTOR ========== */
2021 
2022     /**
2023      * @dev Constructor
2024      * @param _tokenState A pre-populated contract containing token balances.
2025      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2026      * @param _owner The owner of this contract.
2027      */
2028     constructor(address _proxy, TokenState _tokenState, address _owner, address _oracle,
2029                 uint _price, address[] _issuers, Havven _oldHavven)
2030         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, HAVVEN_SUPPLY, _owner)
2031         public
2032     {
2033         oracle = _oracle;
2034         price = _price;
2035         lastPriceUpdateTime = now;
2036 
2037         uint i;
2038         if (_oldHavven == address(0)) {
2039             feePeriodStartTime = now;
2040             lastFeePeriodStartTime = now - feePeriodDuration;
2041             for (i = 0; i < _issuers.length; i++) {
2042                 isIssuer[_issuers[i]] = true;
2043             }
2044         } else {
2045             feePeriodStartTime = _oldHavven.feePeriodStartTime();
2046             lastFeePeriodStartTime = _oldHavven.lastFeePeriodStartTime();
2047 
2048             uint cbs;
2049             uint lab;
2050             uint lm;
2051             (cbs, lab, lm) = _oldHavven.totalIssuanceData();
2052             totalIssuanceData.currentBalanceSum = cbs;
2053             totalIssuanceData.lastAverageBalance = lab;
2054             totalIssuanceData.lastModified = lm;
2055 
2056             for (i = 0; i < _issuers.length; i++) {
2057                 address issuer = _issuers[i];
2058                 isIssuer[issuer] = true;
2059                 uint nomins = _oldHavven.nominsIssued(issuer);
2060                 if (nomins == 0) {
2061                     // It is not valid in general to skip those with no currently-issued nomins.
2062                     // But for this release, issuers with nonzero issuanceData have current issuance.
2063                     continue;
2064                 }
2065                 (cbs, lab, lm) = _oldHavven.issuanceData(issuer);
2066                 nominsIssued[issuer] = nomins;
2067                 issuanceData[issuer].currentBalanceSum = cbs;
2068                 issuanceData[issuer].lastAverageBalance = lab;
2069                 issuanceData[issuer].lastModified = lm;
2070             }
2071         }
2072 
2073     }
2074 
2075     /* ========== SETTERS ========== */
2076 
2077     /**
2078      * @notice Set the associated Nomin contract to collect fees from.
2079      * @dev Only the contract owner may call this.
2080      */
2081     function setNomin(Nomin _nomin)
2082         external
2083         optionalProxy_onlyOwner
2084     {
2085         nomin = _nomin;
2086         emitNominUpdated(_nomin);
2087     }
2088 
2089     /**
2090      * @notice Set the associated havven escrow contract.
2091      * @dev Only the contract owner may call this.
2092      */
2093     function setEscrow(HavvenEscrow _escrow)
2094         external
2095         optionalProxy_onlyOwner
2096     {
2097         escrow = _escrow;
2098         emitEscrowUpdated(_escrow);
2099     }
2100 
2101     /**
2102      * @notice Set the targeted fee period duration.
2103      * @dev Only callable by the contract owner. The duration must fall within
2104      * acceptable bounds (1 day to 26 weeks). Upon resetting this the fee period
2105      * may roll over if the target duration was shortened sufficiently.
2106      */
2107     function setFeePeriodDuration(uint duration)
2108         external
2109         optionalProxy_onlyOwner
2110     {
2111         require(MIN_FEE_PERIOD_DURATION <= duration && duration <= MAX_FEE_PERIOD_DURATION,
2112             "Duration must be between MIN_FEE_PERIOD_DURATION and MAX_FEE_PERIOD_DURATION");
2113         feePeriodDuration = duration;
2114         emitFeePeriodDurationUpdated(duration);
2115         rolloverFeePeriodIfElapsed();
2116     }
2117 
2118     /**
2119      * @notice Set the Oracle that pushes the havven price to this contract
2120      */
2121     function setOracle(address _oracle)
2122         external
2123         optionalProxy_onlyOwner
2124     {
2125         oracle = _oracle;
2126         emitOracleUpdated(_oracle);
2127     }
2128 
2129     /**
2130      * @notice Set the stale period on the updated havven price
2131      * @dev No max/minimum, as changing it wont influence anything but issuance by the foundation
2132      */
2133     function setPriceStalePeriod(uint time)
2134         external
2135         optionalProxy_onlyOwner
2136     {
2137         priceStalePeriod = time;
2138     }
2139 
2140     /**
2141      * @notice Set the issuanceRatio for issuance calculations.
2142      * @dev Only callable by the contract owner.
2143      */
2144     function setIssuanceRatio(uint _issuanceRatio)
2145         external
2146         optionalProxy_onlyOwner
2147     {
2148         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio must be less than or equal to MAX_ISSUANCE_RATIO");
2149         issuanceRatio = _issuanceRatio;
2150         emitIssuanceRatioUpdated(_issuanceRatio);
2151     }
2152 
2153     /**
2154      * @notice Set whether the specified can issue nomins or not.
2155      */
2156     function setIssuer(address account, bool value)
2157         external
2158         optionalProxy_onlyOwner
2159     {
2160         isIssuer[account] = value;
2161         emitIssuersUpdated(account, value);
2162     }
2163 
2164     /* ========== VIEWS ========== */
2165 
2166     function issuanceCurrentBalanceSum(address account)
2167         external
2168         view
2169         returns (uint)
2170     {
2171         return issuanceData[account].currentBalanceSum;
2172     }
2173 
2174     function issuanceLastAverageBalance(address account)
2175         external
2176         view
2177         returns (uint)
2178     {
2179         return issuanceData[account].lastAverageBalance;
2180     }
2181 
2182     function issuanceLastModified(address account)
2183         external
2184         view
2185         returns (uint)
2186     {
2187         return issuanceData[account].lastModified;
2188     }
2189 
2190     function totalIssuanceCurrentBalanceSum()
2191         external
2192         view
2193         returns (uint)
2194     {
2195         return totalIssuanceData.currentBalanceSum;
2196     }
2197 
2198     function totalIssuanceLastAverageBalance()
2199         external
2200         view
2201         returns (uint)
2202     {
2203         return totalIssuanceData.lastAverageBalance;
2204     }
2205 
2206     function totalIssuanceLastModified()
2207         external
2208         view
2209         returns (uint)
2210     {
2211         return totalIssuanceData.lastModified;
2212     }
2213 
2214     /* ========== MUTATIVE FUNCTIONS ========== */
2215 
2216     /**
2217      * @notice ERC20 transfer function.
2218      */
2219     function transfer(address to, uint value)
2220         public
2221         returns (bool)
2222     {
2223         bytes memory empty;
2224         return transfer(to, value, empty);
2225     }
2226 
2227     /**
2228      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
2229      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2230      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2231      *           tooling such as Etherscan.
2232      */
2233     function transfer(address to, uint value, bytes data)
2234         public
2235         optionalProxy
2236         returns (bool)
2237     {
2238         address sender = messageSender;
2239         require(nominsIssued[sender] == 0 || value <= transferableHavvens(sender), "Value to transfer exceeds available havvens");
2240         /* Perform the transfer: if there is a problem,
2241          * an exception will be thrown in this call. */
2242         _transfer_byProxy(messageSender, to, value, data);
2243 
2244         return true;
2245     }
2246 
2247     /**
2248      * @notice ERC20 transferFrom function.
2249      */
2250     function transferFrom(address from, address to, uint value)
2251         public
2252         returns (bool)
2253     {
2254         bytes memory empty;
2255         return transferFrom(from, to, value, empty);
2256     }
2257 
2258     /**
2259      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
2260      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
2261      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
2262      *           tooling such as Etherscan.
2263      */
2264     function transferFrom(address from, address to, uint value, bytes data)
2265         public
2266         optionalProxy
2267         returns (bool)
2268     {
2269         address sender = messageSender;
2270         require(nominsIssued[from] == 0 || value <= transferableHavvens(from), "Value to transfer exceeds available havvens");
2271         /* Perform the transfer: if there is a problem,
2272          * an exception will be thrown in this call. */
2273         _transferFrom_byProxy(messageSender, from, to, value, data);
2274 
2275         return true;
2276     }
2277 
2278     /**
2279      * @notice Compute the last period's fee entitlement for the message sender
2280      * and then deposit it into their nomin account.
2281      */
2282     function withdrawFees()
2283         external
2284         optionalProxy
2285     {
2286         address sender = messageSender;
2287         rolloverFeePeriodIfElapsed();
2288         /* Do not deposit fees into frozen accounts. */
2289         require(!nomin.frozen(sender), "Cannot deposit fees into frozen accounts");
2290 
2291         /* Check the period has rolled over first. */
2292         updateIssuanceData(sender, nominsIssued[sender], nomin.totalSupply());
2293 
2294         /* Only allow accounts to withdraw fees once per period. */
2295         require(!hasWithdrawnFees[sender], "Fees have already been withdrawn in this period");
2296 
2297         uint feesOwed;
2298         uint lastTotalIssued = totalIssuanceData.lastAverageBalance;
2299 
2300         if (lastTotalIssued > 0) {
2301             /* Sender receives a share of last period's collected fees proportional
2302              * with their average fraction of the last period's issued nomins. */
2303             feesOwed = safeDiv_dec(
2304                 safeMul_dec(issuanceData[sender].lastAverageBalance, lastFeesCollected),
2305                 lastTotalIssued
2306             );
2307         }
2308 
2309         hasWithdrawnFees[sender] = true;
2310 
2311         if (feesOwed != 0) {
2312             nomin.withdrawFees(sender, feesOwed);
2313         }
2314         emitFeesWithdrawn(messageSender, feesOwed);
2315     }
2316 
2317     /**
2318      * @notice Update the havven balance averages since the last transfer
2319      * or entitlement adjustment.
2320      * @dev Since this updates the last transfer timestamp, if invoked
2321      * consecutively, this function will do nothing after the first call.
2322      * Also, this will adjust the total issuance at the same time.
2323      */
2324     function updateIssuanceData(address account, uint preBalance, uint lastTotalSupply)
2325         internal
2326     {
2327         /* update the total balances first */
2328         totalIssuanceData = computeIssuanceData(lastTotalSupply, totalIssuanceData);
2329 
2330         if (issuanceData[account].lastModified < feePeriodStartTime) {
2331             hasWithdrawnFees[account] = false;
2332         }
2333 
2334         issuanceData[account] = computeIssuanceData(preBalance, issuanceData[account]);
2335     }
2336 
2337 
2338     /**
2339      * @notice Compute the new IssuanceData on the old balance
2340      */
2341     function computeIssuanceData(uint preBalance, IssuanceData preIssuance)
2342         internal
2343         view
2344         returns (IssuanceData)
2345     {
2346 
2347         uint currentBalanceSum = preIssuance.currentBalanceSum;
2348         uint lastAverageBalance = preIssuance.lastAverageBalance;
2349         uint lastModified = preIssuance.lastModified;
2350 
2351         if (lastModified < feePeriodStartTime) {
2352             if (lastModified < lastFeePeriodStartTime) {
2353                 /* The balance was last updated before the previous fee period, so the average
2354                  * balance in this period is their pre-transfer balance. */
2355                 lastAverageBalance = preBalance;
2356             } else {
2357                 /* The balance was last updated during the previous fee period. */
2358                 /* No overflow or zero denominator problems, since lastFeePeriodStartTime < feePeriodStartTime < lastModified. 
2359                  * implies these quantities are strictly positive. */
2360                 uint timeUpToRollover = feePeriodStartTime - lastModified;
2361                 uint lastFeePeriodDuration = feePeriodStartTime - lastFeePeriodStartTime;
2362                 uint lastBalanceSum = safeAdd(currentBalanceSum, safeMul(preBalance, timeUpToRollover));
2363                 lastAverageBalance = lastBalanceSum / lastFeePeriodDuration;
2364             }
2365             /* Roll over to the next fee period. */
2366             currentBalanceSum = safeMul(preBalance, now - feePeriodStartTime);
2367         } else {
2368             /* The balance was last updated during the current fee period. */
2369             currentBalanceSum = safeAdd(
2370                 currentBalanceSum,
2371                 safeMul(preBalance, now - lastModified)
2372             );
2373         }
2374 
2375         return IssuanceData(currentBalanceSum, lastAverageBalance, now);
2376     }
2377 
2378     /**
2379      * @notice Recompute and return the given account's last average balance.
2380      */
2381     function recomputeLastAverageBalance(address account)
2382         external
2383         returns (uint)
2384     {
2385         updateIssuanceData(account, nominsIssued[account], nomin.totalSupply());
2386         return issuanceData[account].lastAverageBalance;
2387     }
2388 
2389     /**
2390      * @notice Issue nomins against the sender's havvens.
2391      * @dev Issuance is only allowed if the havven price isn't stale and the sender is an issuer.
2392      */
2393     function issueNomins(uint amount)
2394         public
2395         optionalProxy
2396         requireIssuer(messageSender)
2397         /* No need to check if price is stale, as it is checked in issuableNomins. */
2398     {
2399         address sender = messageSender;
2400         require(amount <= remainingIssuableNomins(sender), "Amount must be less than or equal to remaining issuable nomins");
2401         uint lastTot = nomin.totalSupply();
2402         uint preIssued = nominsIssued[sender];
2403         nomin.issue(sender, amount);
2404         nominsIssued[sender] = safeAdd(preIssued, amount);
2405         updateIssuanceData(sender, preIssued, lastTot);
2406     }
2407 
2408     function issueMaxNomins()
2409         external
2410         optionalProxy
2411     {
2412         issueNomins(remainingIssuableNomins(messageSender));
2413     }
2414 
2415     /**
2416      * @notice Burn nomins to clear issued nomins/free havvens.
2417      */
2418     function burnNomins(uint amount)
2419         /* it doesn't matter if the price is stale or if the user is an issuer, as non-issuers have issued no nomins.*/
2420         external
2421         optionalProxy
2422     {
2423         address sender = messageSender;
2424 
2425         uint lastTot = nomin.totalSupply();
2426         uint preIssued = nominsIssued[sender];
2427         /* nomin.burn does a safeSub on balance (so it will revert if there are not enough nomins). */
2428         nomin.burn(sender, amount);
2429         /* This safe sub ensures amount <= number issued */
2430         nominsIssued[sender] = safeSub(preIssued, amount);
2431         updateIssuanceData(sender, preIssued, lastTot);
2432     }
2433 
2434     /**
2435      * @notice Check if the fee period has rolled over. If it has, set the new fee period start
2436      * time, and record the fees collected in the nomin contract.
2437      */
2438     function rolloverFeePeriodIfElapsed()
2439         public
2440     {
2441         /* If the fee period has rolled over... */
2442         if (now >= feePeriodStartTime + feePeriodDuration) {
2443             lastFeesCollected = nomin.feePool();
2444             lastFeePeriodStartTime = feePeriodStartTime;
2445             feePeriodStartTime = now;
2446             emitFeePeriodRollover(now);
2447         }
2448     }
2449 
2450     /* ========== Issuance/Burning ========== */
2451 
2452     /**
2453      * @notice The maximum nomins an issuer can issue against their total havven quantity. This ignores any
2454      * already issued nomins.
2455      */
2456     function maxIssuableNomins(address issuer)
2457         view
2458         public
2459         priceNotStale
2460         returns (uint)
2461     {
2462         if (!isIssuer[issuer]) {
2463             return 0;
2464         }
2465         if (escrow != HavvenEscrow(0)) {
2466             uint totalOwnedHavvens = safeAdd(tokenState.balanceOf(issuer), escrow.balanceOf(issuer));
2467             return safeMul_dec(HAVtoUSD(totalOwnedHavvens), issuanceRatio);
2468         } else {
2469             return safeMul_dec(HAVtoUSD(tokenState.balanceOf(issuer)), issuanceRatio);
2470         }
2471     }
2472 
2473     /**
2474      * @notice The remaining nomins an issuer can issue against their total havven quantity.
2475      */
2476     function remainingIssuableNomins(address issuer)
2477         view
2478         public
2479         returns (uint)
2480     {
2481         uint issued = nominsIssued[issuer];
2482         uint max = maxIssuableNomins(issuer);
2483         if (issued > max) {
2484             return 0;
2485         } else {
2486             return safeSub(max, issued);
2487         }
2488     }
2489 
2490     /**
2491      * @notice The total havvens owned by this account, both escrowed and unescrowed,
2492      * against which nomins can be issued.
2493      * This includes those already being used as collateral (locked), and those
2494      * available for further issuance (unlocked).
2495      */
2496     function collateral(address account)
2497         public
2498         view
2499         returns (uint)
2500     {
2501         uint bal = tokenState.balanceOf(account);
2502         if (escrow != address(0)) {
2503             bal = safeAdd(bal, escrow.balanceOf(account));
2504         }
2505         return bal;
2506     }
2507 
2508     /**
2509      * @notice The collateral that would be locked by issuance, which can exceed the account's actual collateral.
2510      */
2511     function issuanceDraft(address account)
2512         public
2513         view
2514         returns (uint)
2515     {
2516         uint issued = nominsIssued[account];
2517         if (issued == 0) {
2518             return 0;
2519         }
2520         return USDtoHAV(safeDiv_dec(issued, issuanceRatio));
2521     }
2522 
2523     /**
2524      * @notice Collateral that has been locked due to issuance, and cannot be
2525      * transferred to other addresses. This is capped at the account's total collateral.
2526      */
2527     function lockedCollateral(address account)
2528         public
2529         view
2530         returns (uint)
2531     {
2532         uint debt = issuanceDraft(account);
2533         uint collat = collateral(account);
2534         if (debt > collat) {
2535             return collat;
2536         }
2537         return debt;
2538     }
2539 
2540     /**
2541      * @notice Collateral that is not locked and available for issuance.
2542      */
2543     function unlockedCollateral(address account)
2544         public
2545         view
2546         returns (uint)
2547     {
2548         uint locked = lockedCollateral(account);
2549         uint collat = collateral(account);
2550         return safeSub(collat, locked);
2551     }
2552 
2553     /**
2554      * @notice The number of havvens that are free to be transferred by an account.
2555      * @dev If they have enough available Havvens, it could be that
2556      * their havvens are escrowed, however the transfer would then
2557      * fail. This means that escrowed havvens are locked first,
2558      * and then the actual transferable ones.
2559      */
2560     function transferableHavvens(address account)
2561         public
2562         view
2563         returns (uint)
2564     {
2565         uint draft = issuanceDraft(account);
2566         uint collat = collateral(account);
2567         // In the case where the issuanceDraft exceeds the collateral, nothing is free
2568         if (draft > collat) {
2569             return 0;
2570         }
2571 
2572         uint bal = balanceOf(account);
2573         // In the case where the draft exceeds the escrow, but not the whole collateral
2574         //   return the fraction of the balance that remains free
2575         if (draft > safeSub(collat, bal)) {
2576             return safeSub(collat, draft);
2577         }
2578         // In the case where the draft doesn't exceed the escrow, return the entire balance
2579         return bal;
2580     }
2581 
2582     /**
2583      * @notice The value in USD for a given amount of HAV
2584      */
2585     function HAVtoUSD(uint hav_dec)
2586         public
2587         view
2588         priceNotStale
2589         returns (uint)
2590     {
2591         return safeMul_dec(hav_dec, price);
2592     }
2593 
2594     /**
2595      * @notice The value in HAV for a given amount of USD
2596      */
2597     function USDtoHAV(uint usd_dec)
2598         public
2599         view
2600         priceNotStale
2601         returns (uint)
2602     {
2603         return safeDiv_dec(usd_dec, price);
2604     }
2605 
2606     /**
2607      * @notice Access point for the oracle to update the price of havvens.
2608      */
2609     function updatePrice(uint newPrice, uint timeSent)
2610         external
2611         onlyOracle  /* Should be callable only by the oracle. */
2612     {
2613         /* Must be the most recently sent price, but not too far in the future.
2614          * (so we can't lock ourselves out of updating the oracle for longer than this) */
2615         require(lastPriceUpdateTime < timeSent && timeSent < now + ORACLE_FUTURE_LIMIT,
2616             "Time sent must be bigger than the last update, and must be less than now + ORACLE_FUTURE_LIMIT");
2617 
2618         price = newPrice;
2619         lastPriceUpdateTime = timeSent;
2620         emitPriceUpdated(newPrice, timeSent);
2621 
2622         /* Check the fee period rollover within this as the price should be pushed every 15min. */
2623         rolloverFeePeriodIfElapsed();
2624     }
2625 
2626     /**
2627      * @notice Check if the price of havvens hasn't been updated for longer than the stale period.
2628      */
2629     function priceIsStale()
2630         public
2631         view
2632         returns (bool)
2633     {
2634         return safeAdd(lastPriceUpdateTime, priceStalePeriod) < now;
2635     }
2636 
2637     /* ========== MODIFIERS ========== */
2638 
2639     modifier requireIssuer(address account)
2640     {
2641         require(isIssuer[account], "Must be issuer to perform this action");
2642         _;
2643     }
2644 
2645     modifier onlyOracle
2646     {
2647         require(msg.sender == oracle, "Must be oracle to perform this action");
2648         _;
2649     }
2650 
2651     modifier priceNotStale
2652     {
2653         require(!priceIsStale(), "Price must not be stale to perform this action");
2654         _;
2655     }
2656 
2657     /* ========== EVENTS ========== */
2658 
2659     event PriceUpdated(uint newPrice, uint timestamp);
2660     bytes32 constant PRICEUPDATED_SIG = keccak256("PriceUpdated(uint256,uint256)");
2661     function emitPriceUpdated(uint newPrice, uint timestamp) internal {
2662         proxy._emit(abi.encode(newPrice, timestamp), 1, PRICEUPDATED_SIG, 0, 0, 0);
2663     }
2664 
2665     event IssuanceRatioUpdated(uint newRatio);
2666     bytes32 constant ISSUANCERATIOUPDATED_SIG = keccak256("IssuanceRatioUpdated(uint256)");
2667     function emitIssuanceRatioUpdated(uint newRatio) internal {
2668         proxy._emit(abi.encode(newRatio), 1, ISSUANCERATIOUPDATED_SIG, 0, 0, 0);
2669     }
2670 
2671     event FeePeriodRollover(uint timestamp);
2672     bytes32 constant FEEPERIODROLLOVER_SIG = keccak256("FeePeriodRollover(uint256)");
2673     function emitFeePeriodRollover(uint timestamp) internal {
2674         proxy._emit(abi.encode(timestamp), 1, FEEPERIODROLLOVER_SIG, 0, 0, 0);
2675     } 
2676 
2677     event FeePeriodDurationUpdated(uint duration);
2678     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
2679     function emitFeePeriodDurationUpdated(uint duration) internal {
2680         proxy._emit(abi.encode(duration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
2681     } 
2682 
2683     event FeesWithdrawn(address indexed account, uint value);
2684     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
2685     function emitFeesWithdrawn(address account, uint value) internal {
2686         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
2687     }
2688 
2689     event OracleUpdated(address newOracle);
2690     bytes32 constant ORACLEUPDATED_SIG = keccak256("OracleUpdated(address)");
2691     function emitOracleUpdated(address newOracle) internal {
2692         proxy._emit(abi.encode(newOracle), 1, ORACLEUPDATED_SIG, 0, 0, 0);
2693     }
2694 
2695     event NominUpdated(address newNomin);
2696     bytes32 constant NOMINUPDATED_SIG = keccak256("NominUpdated(address)");
2697     function emitNominUpdated(address newNomin) internal {
2698         proxy._emit(abi.encode(newNomin), 1, NOMINUPDATED_SIG, 0, 0, 0);
2699     }
2700 
2701     event EscrowUpdated(address newEscrow);
2702     bytes32 constant ESCROWUPDATED_SIG = keccak256("EscrowUpdated(address)");
2703     function emitEscrowUpdated(address newEscrow) internal {
2704         proxy._emit(abi.encode(newEscrow), 1, ESCROWUPDATED_SIG, 0, 0, 0);
2705     }
2706 
2707     event IssuersUpdated(address indexed account, bool indexed value);
2708     bytes32 constant ISSUERSUPDATED_SIG = keccak256("IssuersUpdated(address,bool)");
2709     function emitIssuersUpdated(address account, bool value) internal {
2710         proxy._emit(abi.encode(), 3, ISSUERSUPDATED_SIG, bytes32(account), bytes32(value ? 1 : 0), 0);
2711     }
2712 
2713 }
2714 
2715 
2716 ////////////////// Nomin.sol //////////////////
2717 
2718 /*
2719 -----------------------------------------------------------------
2720 FILE INFORMATION
2721 -----------------------------------------------------------------
2722 
2723 file:       Nomin.sol
2724 version:    1.2
2725 author:     Anton Jurisevic
2726             Mike Spain
2727             Dominic Romanowski
2728             Kevin Brown
2729 
2730 date:       2018-05-29
2731 
2732 -----------------------------------------------------------------
2733 MODULE DESCRIPTION
2734 -----------------------------------------------------------------
2735 
2736 Havven-backed nomin stablecoin contract.
2737 
2738 This contract issues nomins, which are tokens worth 1 USD each.
2739 
2740 Nomins are issuable by Havven holders who have to lock up some
2741 value of their havvens to issue H * Cmax nomins. Where Cmax is
2742 some value less than 1.
2743 
2744 A configurable fee is charged on nomin transfers and deposited
2745 into a common pot, which havven holders may withdraw from once
2746 per fee period.
2747 
2748 -----------------------------------------------------------------
2749 */
2750 
2751 
2752 contract Nomin is FeeToken {
2753 
2754     /* ========== STATE VARIABLES ========== */
2755 
2756     Havven public havven;
2757 
2758     // Accounts which have lost the privilege to transact in nomins.
2759     mapping(address => bool) public frozen;
2760 
2761     // Nomin transfers incur a 15 bp fee by default.
2762     uint constant TRANSFER_FEE_RATE = 15 * UNIT / 10000;
2763     string constant TOKEN_NAME = "Nomin USD";
2764     string constant TOKEN_SYMBOL = "nUSD";
2765 
2766     /* ========== CONSTRUCTOR ========== */
2767 
2768     constructor(address _proxy, TokenState _tokenState, Havven _havven,
2769                 uint _totalSupply,
2770                 address _owner)
2771         FeeToken(_proxy, _tokenState,
2772                  TOKEN_NAME, TOKEN_SYMBOL, _totalSupply,
2773                  TRANSFER_FEE_RATE,
2774                  _havven, // The havven contract is the fee authority.
2775                  _owner)
2776         public
2777     {
2778         require(_proxy != 0, "_proxy cannot be 0");
2779         require(address(_havven) != 0, "_havven cannot be 0");
2780         require(_owner != 0, "_owner cannot be 0");
2781 
2782         // It should not be possible to transfer to the fee pool directly (or confiscate its balance).
2783         frozen[FEE_ADDRESS] = true;
2784         havven = _havven;
2785     }
2786 
2787     /* ========== SETTERS ========== */
2788 
2789     function setHavven(Havven _havven)
2790         external
2791         optionalProxy_onlyOwner
2792     {
2793         // havven should be set as the feeAuthority after calling this depending on
2794         // havven's internal logic
2795         havven = _havven;
2796         setFeeAuthority(_havven);
2797         emitHavvenUpdated(_havven);
2798     }
2799 
2800 
2801     /* ========== MUTATIVE FUNCTIONS ========== */
2802 
2803     /* Override ERC20 transfer function in order to check
2804      * whether the recipient account is frozen. Note that there is
2805      * no need to check whether the sender has a frozen account,
2806      * since their funds have already been confiscated,
2807      * and no new funds can be transferred to it.*/
2808     function transfer(address to, uint value)
2809         public
2810         optionalProxy
2811         returns (bool)
2812     {
2813         require(!frozen[to], "Cannot transfer to frozen address");
2814         bytes memory empty;
2815         return _transfer_byProxy(messageSender, to, value, empty);
2816     }
2817 
2818     /* Override ERC223 transfer function in order to check
2819      * whether the recipient account is frozen. Note that there is
2820      * no need to check whether the sender has a frozen account,
2821      * since their funds have already been confiscated,
2822      * and no new funds can be transferred to it.*/
2823     function transfer(address to, uint value, bytes data)
2824         public
2825         optionalProxy
2826         returns (bool)
2827     {
2828         require(!frozen[to], "Cannot transfer to frozen address");
2829         return _transfer_byProxy(messageSender, to, value, data);
2830     }
2831 
2832     /* Override ERC20 transferFrom function in order to check
2833      * whether the recipient account is frozen. */
2834     function transferFrom(address from, address to, uint value)
2835         public
2836         optionalProxy
2837         returns (bool)
2838     {
2839         require(!frozen[to], "Cannot transfer to frozen address");
2840         bytes memory empty;
2841         return _transferFrom_byProxy(messageSender, from, to, value, empty);
2842     }
2843 
2844     /* Override ERC223 transferFrom function in order to check
2845      * whether the recipient account is frozen. */
2846     function transferFrom(address from, address to, uint value, bytes data)
2847         public
2848         optionalProxy
2849         returns (bool)
2850     {
2851         require(!frozen[to], "Cannot transfer to frozen address");
2852         return _transferFrom_byProxy(messageSender, from, to, value, data);
2853     }
2854 
2855     function transferSenderPaysFee(address to, uint value)
2856         public
2857         optionalProxy
2858         returns (bool)
2859     {
2860         require(!frozen[to], "Cannot transfer to frozen address");
2861         bytes memory empty;
2862         return _transferSenderPaysFee_byProxy(messageSender, to, value, empty);
2863     }
2864 
2865     function transferSenderPaysFee(address to, uint value, bytes data)
2866         public
2867         optionalProxy
2868         returns (bool)
2869     {
2870         require(!frozen[to], "Cannot transfer to frozen address");
2871         return _transferSenderPaysFee_byProxy(messageSender, to, value, data);
2872     }
2873 
2874     function transferFromSenderPaysFee(address from, address to, uint value)
2875         public
2876         optionalProxy
2877         returns (bool)
2878     {
2879         require(!frozen[to], "Cannot transfer to frozen address");
2880         bytes memory empty;
2881         return _transferFromSenderPaysFee_byProxy(messageSender, from, to, value, empty);
2882     }
2883 
2884     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
2885         public
2886         optionalProxy
2887         returns (bool)
2888     {
2889         require(!frozen[to], "Cannot transfer to frozen address");
2890         return _transferFromSenderPaysFee_byProxy(messageSender, from, to, value, data);
2891     }
2892 
2893     /* The owner may allow a previously-frozen contract to once
2894      * again accept and transfer nomins. */
2895     function unfreezeAccount(address target)
2896         external
2897         optionalProxy_onlyOwner
2898     {
2899         require(frozen[target] && target != FEE_ADDRESS, "Account must be frozen, and cannot be the fee address");
2900         frozen[target] = false;
2901         emitAccountUnfrozen(target);
2902     }
2903 
2904     /* Allow havven to issue a certain number of
2905      * nomins from an account. */
2906     function issue(address account, uint amount)
2907         external
2908         onlyHavven
2909     {
2910         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), amount));
2911         totalSupply = safeAdd(totalSupply, amount);
2912         emitTransfer(address(0), account, amount);
2913         emitIssued(account, amount);
2914     }
2915 
2916     /* Allow havven to burn a certain number of
2917      * nomins from an account. */
2918     function burn(address account, uint amount)
2919         external
2920         onlyHavven
2921     {
2922         tokenState.setBalanceOf(account, safeSub(tokenState.balanceOf(account), amount));
2923         totalSupply = safeSub(totalSupply, amount);
2924         emitTransfer(account, address(0), amount);
2925         emitBurned(account, amount);
2926     }
2927 
2928     /* ========== MODIFIERS ========== */
2929 
2930     modifier onlyHavven() {
2931         require(Havven(msg.sender) == havven, "Only the Havven contract can perform this action");
2932         _;
2933     }
2934 
2935     /* ========== EVENTS ========== */
2936 
2937     event HavvenUpdated(address newHavven);
2938     bytes32 constant HAVVENUPDATED_SIG = keccak256("HavvenUpdated(address)");
2939     function emitHavvenUpdated(address newHavven) internal {
2940         proxy._emit(abi.encode(newHavven), 1, HAVVENUPDATED_SIG, 0, 0, 0);
2941     }
2942 
2943     event AccountFrozen(address indexed target, uint balance);
2944     bytes32 constant ACCOUNTFROZEN_SIG = keccak256("AccountFrozen(address,uint256)");
2945     function emitAccountFrozen(address target, uint balance) internal {
2946         proxy._emit(abi.encode(balance), 2, ACCOUNTFROZEN_SIG, bytes32(target), 0, 0);
2947     }
2948 
2949     event AccountUnfrozen(address indexed target);
2950     bytes32 constant ACCOUNTUNFROZEN_SIG = keccak256("AccountUnfrozen(address)");
2951     function emitAccountUnfrozen(address target) internal {
2952         proxy._emit(abi.encode(), 2, ACCOUNTUNFROZEN_SIG, bytes32(target), 0, 0);
2953     }
2954 
2955     event Issued(address indexed account, uint amount);
2956     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
2957     function emitIssued(address account, uint amount) internal {
2958         proxy._emit(abi.encode(amount), 2, ISSUED_SIG, bytes32(account), 0, 0);
2959     }
2960 
2961     event Burned(address indexed account, uint amount);
2962     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
2963     function emitBurned(address account, uint amount) internal {
2964         proxy._emit(abi.encode(amount), 2, BURNED_SIG, bytes32(account), 0, 0);
2965     }
2966 }