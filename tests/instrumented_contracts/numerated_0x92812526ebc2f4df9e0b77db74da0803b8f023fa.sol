1 /*
2  * Nomin Contract
3  *
4  * The stable exchange token of the Havven stablecoin system.
5  *
6  * version: nUSDa.1
7  * date: 29 Jun 2018
8  * url: https://github.com/Havven/havven/releases/tag/nUSDa.1
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
34 pragma solidity 0.4.24;
35  
36  
37 /*
38 -----------------------------------------------------------------
39 FILE INFORMATION
40 -----------------------------------------------------------------
41  
42 file:       SafeDecimalMath.sol
43 version:    1.0
44 author:     Anton Jurisevic
45  
46 date:       2018-2-5
47  
48 checked:    Mike Spain
49 approved:   Samuel Brooks
50  
51 -----------------------------------------------------------------
52 MODULE DESCRIPTION
53 -----------------------------------------------------------------
54  
55 A fixed point decimal library that provides basic mathematical
56 operations, and checks for unsafe arguments, for example that
57 would lead to overflows.
58  
59 Exceptions are thrown whenever those unsafe operations
60 occur.
61  
62 -----------------------------------------------------------------
63 */
64  
65  
66 /**
67  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
68  * @dev Functions accepting uints in this contract and derived contracts
69  * are taken to be such fixed point decimals (including fiat, ether, and nomin quantities).
70  */
71 contract SafeDecimalMath {
72  
73     /* Number of decimal places in the representation. */
74     uint8 public constant decimals = 18;
75  
76     /* The number representing 1.0. */
77     uint public constant UNIT = 10 ** uint(decimals);
78  
79     /**
80      * @return True iff adding x and y will not overflow.
81      */
82     function addIsSafe(uint x, uint y)
83         pure
84         internal
85         returns (bool)
86     {
87         return x + y >= y;
88     }
89  
90     /**
91      * @return The result of adding x and y, throwing an exception in case of overflow.
92      */
93     function safeAdd(uint x, uint y)
94         pure
95         internal
96         returns (uint)
97     {
98         require(x + y >= y);
99         return x + y;
100     }
101  
102     /**
103      * @return True iff subtracting y from x will not overflow in the negative direction.
104      */
105     function subIsSafe(uint x, uint y)
106         pure
107         internal
108         returns (bool)
109     {
110         return y <= x;
111     }
112  
113     /**
114      * @return The result of subtracting y from x, throwing an exception in case of overflow.
115      */
116     function safeSub(uint x, uint y)
117         pure
118         internal
119         returns (uint)
120     {
121         require(y <= x);
122         return x - y;
123     }
124  
125     /**
126      * @return True iff multiplying x and y would not overflow.
127      */
128     function mulIsSafe(uint x, uint y)
129         pure
130         internal
131         returns (bool)
132     {
133         if (x == 0) {
134             return true;
135         }
136         return (x * y) / x == y;
137     }
138  
139     /**
140      * @return The result of multiplying x and y, throwing an exception in case of overflow.
141      */
142     function safeMul(uint x, uint y)
143         pure
144         internal
145         returns (uint)
146     {
147         if (x == 0) {
148             return 0;
149         }
150         uint p = x * y;
151         require(p / x == y);
152         return p;
153     }
154  
155     /**
156      * @return The result of multiplying x and y, interpreting the operands as fixed-point
157      * decimals. Throws an exception in case of overflow.
158      *
159      * @dev A unit factor is divided out after the product of x and y is evaluated,
160      * so that product must be less than 2**256.
161      * Incidentally, the internal division always rounds down: one could have rounded to the nearest integer,
162      * but then one would be spending a significant fraction of a cent (of order a microether
163      * at present gas prices) in order to save less than one part in 0.5 * 10^18 per operation, if the operands
164      * contain small enough fractional components. It would also marginally diminish the
165      * domain this function is defined upon.
166      */
167     function safeMul_dec(uint x, uint y)
168         pure
169         internal
170         returns (uint)
171     {
172         /* Divide by UNIT to remove the extra factor introduced by the product. */
173         return safeMul(x, y) / UNIT;
174  
175     }
176  
177     /**
178      * @return True iff the denominator of x/y is nonzero.
179      */
180     function divIsSafe(uint x, uint y)
181         pure
182         internal
183         returns (bool)
184     {
185         return y != 0;
186     }
187  
188     /**
189      * @return The result of dividing x by y, throwing an exception if the divisor is zero.
190      */
191     function safeDiv(uint x, uint y)
192         pure
193         internal
194         returns (uint)
195     {
196         /* Although a 0 denominator already throws an exception,
197          * it is equivalent to a THROW operation, which consumes all gas.
198          * A require statement emits REVERT instead, which remits remaining gas. */
199         require(y != 0);
200         return x / y;
201     }
202  
203     /**
204      * @return The result of dividing x by y, interpreting the operands as fixed point decimal numbers.
205      * @dev Throws an exception in case of overflow or zero divisor; x must be less than 2^256 / UNIT.
206      * Internal rounding is downward: a similar caveat holds as with safeDecMul().
207      */
208     function safeDiv_dec(uint x, uint y)
209         pure
210         internal
211         returns (uint)
212     {
213         /* Reintroduce the UNIT factor that will be divided out by y. */
214         return safeDiv(safeMul(x, UNIT), y);
215     }
216  
217     /**
218      * @dev Convert an unsigned integer to a unsigned fixed-point decimal.
219      * Throw an exception if the result would be out of range.
220      */
221     function intToDec(uint i)
222         pure
223         internal
224         returns (uint)
225     {
226         return safeMul(i, UNIT);
227     }
228 }
229  
230  
231 /*
232 -----------------------------------------------------------------
233 FILE INFORMATION
234 -----------------------------------------------------------------
235  
236 file:       Owned.sol
237 version:    1.1
238 author:     Anton Jurisevic
239             Dominic Romanowski
240  
241 date:       2018-2-26
242  
243 -----------------------------------------------------------------
244 MODULE DESCRIPTION
245 -----------------------------------------------------------------
246  
247 An Owned contract, to be inherited by other contracts.
248 Requires its owner to be explicitly set in the constructor.
249 Provides an onlyOwner access modifier.
250  
251 To change owner, the current owner must nominate the next owner,
252 who then has to accept the nomination. The nomination can be
253 cancelled before it is accepted by the new owner by having the
254 previous owner change the nomination (setting it to 0).
255  
256 -----------------------------------------------------------------
257 */
258  
259  
260 /**
261  * @title A contract with an owner.
262  * @notice Contract ownership can be transferred by first nominating the new owner,
263  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
264  */
265 contract Owned {
266     address public owner;
267     address public nominatedOwner;
268  
269     /**
270      * @dev Owned Constructor
271      */
272     constructor(address _owner)
273         public
274     {
275         require(_owner != address(0));
276         owner = _owner;
277         emit OwnerChanged(address(0), _owner);
278     }
279  
280     /**
281      * @notice Nominate a new owner of this contract.
282      * @dev Only the current owner may nominate a new owner.
283      */
284     function nominateNewOwner(address _owner)
285         external
286         onlyOwner
287     {
288         nominatedOwner = _owner;
289         emit OwnerNominated(_owner);
290     }
291  
292     /**
293      * @notice Accept the nomination to be owner.
294      */
295     function acceptOwnership()
296         external
297     {
298         require(msg.sender == nominatedOwner);
299         emit OwnerChanged(owner, nominatedOwner);
300         owner = nominatedOwner;
301         nominatedOwner = address(0);
302     }
303  
304     modifier onlyOwner
305     {
306         require(msg.sender == owner);
307         _;
308     }
309  
310     event OwnerNominated(address newOwner);
311     event OwnerChanged(address oldOwner, address newOwner);
312 }
313  
314 /*
315 -----------------------------------------------------------------
316 FILE INFORMATION
317 -----------------------------------------------------------------
318  
319 file:       SelfDestructible.sol
320 version:    1.2
321 author:     Anton Jurisevic
322  
323 date:       2018-05-29
324  
325 -----------------------------------------------------------------
326 MODULE DESCRIPTION
327 -----------------------------------------------------------------
328  
329 This contract allows an inheriting contract to be destroyed after
330 its owner indicates an intention and then waits for a period
331 without changing their mind. All ether contained in the contract
332 is forwarded to a nominated beneficiary upon destruction.
333  
334 -----------------------------------------------------------------
335 */
336  
337  
338 /**
339  * @title A contract that can be destroyed by its owner after a delay elapses.
340  */
341 contract SelfDestructible is Owned {
342      
343     uint public initiationTime;
344     bool public selfDestructInitiated;
345     address public selfDestructBeneficiary;
346     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
347  
348     /**
349      * @dev Constructor
350      * @param _owner The account which controls this contract.
351      */
352     constructor(address _owner)
353         Owned(_owner)
354         public
355     {
356         require(_owner != address(0));
357         selfDestructBeneficiary = _owner;
358         emit SelfDestructBeneficiaryUpdated(_owner);
359     }
360  
361     /**
362      * @notice Set the beneficiary address of this contract.
363      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
364      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
365      */
366     function setSelfDestructBeneficiary(address _beneficiary)
367         external
368         onlyOwner
369     {
370         require(_beneficiary != address(0));
371         selfDestructBeneficiary = _beneficiary;
372         emit SelfDestructBeneficiaryUpdated(_beneficiary);
373     }
374  
375     /**
376      * @notice Begin the self-destruction counter of this contract.
377      * Once the delay has elapsed, the contract may be self-destructed.
378      * @dev Only the contract owner may call this.
379      */
380     function initiateSelfDestruct()
381         external
382         onlyOwner
383     {
384         initiationTime = now;
385         selfDestructInitiated = true;
386         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
387     }
388  
389     /**
390      * @notice Terminate and reset the self-destruction timer.
391      * @dev Only the contract owner may call this.
392      */
393     function terminateSelfDestruct()
394         external
395         onlyOwner
396     {
397         initiationTime = 0;
398         selfDestructInitiated = false;
399         emit SelfDestructTerminated();
400     }
401  
402     /**
403      * @notice If the self-destruction delay has elapsed, destroy this contract and
404      * remit any ether it owns to the beneficiary address.
405      * @dev Only the contract owner may call this.
406      */
407     function selfDestruct()
408         external
409         onlyOwner
410     {
411         require(selfDestructInitiated && initiationTime + SELFDESTRUCT_DELAY < now);
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
424 /*
425 -----------------------------------------------------------------
426 FILE INFORMATION
427 -----------------------------------------------------------------
428  
429 file:       State.sol
430 version:    1.1
431 author:     Dominic Romanowski
432             Anton Jurisevic
433  
434 date:       2018-05-15
435  
436 -----------------------------------------------------------------
437 MODULE DESCRIPTION
438 -----------------------------------------------------------------
439  
440 This contract is used side by side with external state token
441 contracts, such as Havven and Nomin.
442 It provides an easy way to upgrade contract logic while
443 maintaining all user balances and allowances. This is designed
444 to make the changeover as easy as possible, since mappings
445 are not so cheap or straightforward to migrate.
446  
447 The first deployed contract would create this state contract,
448 using it as its store of balances.
449 When a new contract is deployed, it links to the existing
450 state contract, whose owner would then change its associated
451 contract to the new one.
452  
453 -----------------------------------------------------------------
454 */
455  
456  
457 contract State is Owned {
458     // the address of the contract that can modify variables
459     // this can only be changed by the owner of this contract
460     address public associatedContract;
461  
462  
463     constructor(address _owner, address _associatedContract)
464         Owned(_owner)
465         public
466     {
467         associatedContract = _associatedContract;
468         emit AssociatedContractUpdated(_associatedContract);
469     }
470  
471     /* ========== SETTERS ========== */
472  
473     // Change the associated contract to a new address
474     function setAssociatedContract(address _associatedContract)
475         external
476         onlyOwner
477     {
478         associatedContract = _associatedContract;
479         emit AssociatedContractUpdated(_associatedContract);
480     }
481  
482     /* ========== MODIFIERS ========== */
483  
484     modifier onlyAssociatedContract
485     {
486         require(msg.sender == associatedContract);
487         _;
488     }
489  
490     /* ========== EVENTS ========== */
491  
492     event AssociatedContractUpdated(address associatedContract);
493 }
494  
495  
496 /*
497 -----------------------------------------------------------------
498 FILE INFORMATION
499 -----------------------------------------------------------------
500  
501 file:       TokenState.sol
502 version:    1.1
503 author:     Dominic Romanowski
504             Anton Jurisevic
505  
506 date:       2018-05-15
507  
508 -----------------------------------------------------------------
509 MODULE DESCRIPTION
510 -----------------------------------------------------------------
511  
512 A contract that holds the state of an ERC20 compliant token.
513  
514 This contract is used side by side with external state token
515 contracts, such as Havven and Nomin.
516 It provides an easy way to upgrade contract logic while
517 maintaining all user balances and allowances. This is designed
518 to make the changeover as easy as possible, since mappings
519 are not so cheap or straightforward to migrate.
520  
521 The first deployed contract would create this state contract,
522 using it as its store of balances.
523 When a new contract is deployed, it links to the existing
524 state contract, whose owner would then change its associated
525 contract to the new one.
526  
527 -----------------------------------------------------------------
528 */
529  
530  
531 /**
532  * @title ERC20 Token State
533  * @notice Stores balance information of an ERC20 token contract.
534  */
535 contract TokenState is State {
536  
537     /* ERC20 fields. */
538     mapping(address => uint) public balanceOf;
539     mapping(address => mapping(address => uint)) public allowance;
540  
541     /**
542      * @dev Constructor
543      * @param _owner The address which controls this contract.
544      * @param _associatedContract The ERC20 contract whose state this composes.
545      */
546     constructor(address _owner, address _associatedContract)
547         State(_owner, _associatedContract)
548         public
549     {}
550  
551     /* ========== SETTERS ========== */
552  
553     /**
554      * @notice Set ERC20 allowance.
555      * @dev Only the associated contract may call this.
556      * @param tokenOwner The authorising party.
557      * @param spender The authorised party.
558      * @param value The total value the authorised party may spend on the
559      * authorising party's behalf.
560      */
561     function setAllowance(address tokenOwner, address spender, uint value)
562         external
563         onlyAssociatedContract
564     {
565         allowance[tokenOwner][spender] = value;
566     }
567  
568     /**
569      * @notice Set the balance in a given account
570      * @dev Only the associated contract may call this.
571      * @param account The account whose value to set.
572      * @param value The new balance of the given account.
573      */
574     function setBalanceOf(address account, uint value)
575         external
576         onlyAssociatedContract
577     {
578         balanceOf[account] = value;
579     }
580 }
581  
582  
583 /*
584 -----------------------------------------------------------------
585 FILE INFORMATION
586 -----------------------------------------------------------------
587  
588 file:       Proxy.sol
589 version:    1.3
590 author:     Anton Jurisevic
591  
592 date:       2018-05-29
593  
594 -----------------------------------------------------------------
595 MODULE DESCRIPTION
596 -----------------------------------------------------------------
597  
598 A proxy contract that, if it does not recognise the function
599 being called on it, passes all value and call data to an
600 underlying target contract.
601  
602 This proxy has the capacity to toggle between DELEGATECALL
603 and CALL style proxy functionality.
604  
605 The former executes in the proxy's context, and so will preserve
606 msg.sender and store data at the proxy address. The latter will not.
607 Therefore, any contract the proxy wraps in the CALL style must
608 implement the Proxyable interface, in order that it can pass msg.sender
609 into the underlying contract as the state parameter, messageSender.
610  
611 -----------------------------------------------------------------
612 */
613  
614  
615 contract Proxy is Owned {
616  
617     Proxyable public target;
618     bool public useDELEGATECALL;
619  
620     constructor(address _owner)
621         Owned(_owner)
622         public
623     {}
624  
625     function setTarget(Proxyable _target)
626         external
627         onlyOwner
628     {
629         target = _target;
630         emit TargetUpdated(_target);
631     }
632  
633     function setUseDELEGATECALL(bool value)
634         external
635         onlyOwner
636     {
637         useDELEGATECALL = value;
638     }
639  
640     function _emit(bytes callData, uint numTopics,
641                    bytes32 topic1, bytes32 topic2,
642                    bytes32 topic3, bytes32 topic4)
643         external
644         onlyTarget
645     {
646         uint size = callData.length;
647         bytes memory _callData = callData;
648  
649         assembly {
650             /* The first 32 bytes of callData contain its length (as specified by the abi).
651              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
652              * in length. It is also leftpadded to be a multiple of 32 bytes.
653              * This means moving call_data across 32 bytes guarantees we correctly access
654              * the data itself. */
655             switch numTopics
656             case 0 {
657                 log0(add(_callData, 32), size)
658             }
659             case 1 {
660                 log1(add(_callData, 32), size, topic1)
661             }
662             case 2 {
663                 log2(add(_callData, 32), size, topic1, topic2)
664             }
665             case 3 {
666                 log3(add(_callData, 32), size, topic1, topic2, topic3)
667             }
668             case 4 {
669                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
670             }
671         }
672     }
673  
674     function()
675         external
676         payable
677     {
678         if (useDELEGATECALL) {
679             assembly {
680                 /* Copy call data into free memory region. */
681                 let free_ptr := mload(0x40)
682                 calldatacopy(free_ptr, 0, calldatasize)
683  
684                 /* Forward all gas and call data to the target contract. */
685                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
686                 returndatacopy(free_ptr, 0, returndatasize)
687  
688                 /* Revert if the call failed, otherwise return the result. */
689                 if iszero(result) { revert(free_ptr, returndatasize) }
690                 return(free_ptr, returndatasize)
691             }
692         } else {
693             /* Here we are as above, but must send the messageSender explicitly
694              * since we are using CALL rather than DELEGATECALL. */
695             target.setMessageSender(msg.sender);
696             assembly {
697                 let free_ptr := mload(0x40)
698                 calldatacopy(free_ptr, 0, calldatasize)
699  
700                 /* We must explicitly forward ether to the underlying contract as well. */
701                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
702                 returndatacopy(free_ptr, 0, returndatasize)
703  
704                 if iszero(result) { revert(free_ptr, returndatasize) }
705                 return(free_ptr, returndatasize)
706             }
707         }
708     }
709  
710     modifier onlyTarget {
711         require(Proxyable(msg.sender) == target);
712         _;
713     }
714  
715     event TargetUpdated(Proxyable newTarget);
716 }
717  
718  
719 /*
720 -----------------------------------------------------------------
721 FILE INFORMATION
722 -----------------------------------------------------------------
723  
724 file:       Proxyable.sol
725 version:    1.1
726 author:     Anton Jurisevic
727  
728 date:       2018-05-15
729  
730 checked:    Mike Spain
731 approved:   Samuel Brooks
732  
733 -----------------------------------------------------------------
734 MODULE DESCRIPTION
735 -----------------------------------------------------------------
736  
737 A proxyable contract that works hand in hand with the Proxy contract
738 to allow for anyone to interact with the underlying contract both
739 directly and through the proxy.
740  
741 -----------------------------------------------------------------
742 */
743  
744  
745 // This contract should be treated like an abstract contract
746 contract Proxyable is Owned {
747     /* The proxy this contract exists behind. */
748     Proxy public proxy;
749  
750     /* The caller of the proxy, passed through to this contract.
751      * Note that every function using this member must apply the onlyProxy or
752      * optionalProxy modifiers, otherwise their invocations can use stale values. */
753     address messageSender;
754  
755     constructor(address _proxy, address _owner)
756         Owned(_owner)
757         public
758     {
759         proxy = Proxy(_proxy);
760         emit ProxyUpdated(_proxy);
761     }
762  
763     function setProxy(address _proxy)
764         external
765         onlyOwner
766     {
767         proxy = Proxy(_proxy);
768         emit ProxyUpdated(_proxy);
769     }
770  
771     function setMessageSender(address sender)
772         external
773         onlyProxy
774     {
775         messageSender = sender;
776     }
777  
778     modifier onlyProxy {
779         require(Proxy(msg.sender) == proxy);
780         _;
781     }
782  
783     modifier optionalProxy
784     {
785         if (Proxy(msg.sender) != proxy) {
786             messageSender = msg.sender;
787         }
788         _;
789     }
790  
791     modifier optionalProxy_onlyOwner
792     {
793         if (Proxy(msg.sender) != proxy) {
794             messageSender = msg.sender;
795         }
796         require(messageSender == owner);
797         _;
798     }
799  
800     event ProxyUpdated(address proxyAddress);
801 }
802  
803  
804 /*
805 -----------------------------------------------------------------
806 FILE INFORMATION
807 -----------------------------------------------------------------
808  
809 file:       ExternStateToken.sol
810 version:    1.3
811 author:     Anton Jurisevic
812             Dominic Romanowski
813  
814 date:       2018-05-29
815  
816 -----------------------------------------------------------------
817 MODULE DESCRIPTION
818 -----------------------------------------------------------------
819  
820 A partial ERC20 token contract, designed to operate with a proxy.
821 To produce a complete ERC20 token, transfer and transferFrom
822 tokens must be implemented, using the provided _byProxy internal
823 functions.
824 This contract utilises an external state for upgradeability.
825  
826 -----------------------------------------------------------------
827 */
828  
829  
830 /**
831  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
832  */
833 contract ExternStateToken is SafeDecimalMath, SelfDestructible, Proxyable {
834  
835     /* ========== STATE VARIABLES ========== */
836  
837     /* Stores balances and allowances. */
838     TokenState public tokenState;
839  
840     /* Other ERC20 fields.
841      * Note that the decimals field is defined in SafeDecimalMath.*/
842     string public name;
843     string public symbol;
844     uint public totalSupply;
845  
846     /**
847      * @dev Constructor.
848      * @param _proxy The proxy associated with this contract.
849      * @param _name Token's ERC20 name.
850      * @param _symbol Token's ERC20 symbol.
851      * @param _totalSupply The total supply of the token.
852      * @param _tokenState The TokenState contract address.
853      * @param _owner The owner of this contract.
854      */
855     constructor(address _proxy, TokenState _tokenState,
856                 string _name, string _symbol, uint _totalSupply,
857                 address _owner)
858         SelfDestructible(_owner)
859         Proxyable(_proxy, _owner)
860         public
861     {
862         name = _name;
863         symbol = _symbol;
864         totalSupply = _totalSupply;
865         tokenState = _tokenState;
866    }
867  
868     /* ========== VIEWS ========== */
869  
870     /**
871      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
872      * @param owner The party authorising spending of their funds.
873      * @param spender The party spending tokenOwner's funds.
874      */
875     function allowance(address owner, address spender)
876         public
877         view
878         returns (uint)
879     {
880         return tokenState.allowance(owner, spender);
881     }
882  
883     /**
884      * @notice Returns the ERC20 token balance of a given account.
885      */
886     function balanceOf(address account)
887         public
888         view
889         returns (uint)
890     {
891         return tokenState.balanceOf(account);
892     }
893  
894     /* ========== MUTATIVE FUNCTIONS ========== */
895  
896     /**
897      * @notice Set the address of the TokenState contract.
898      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
899      * as balances would be unreachable.
900      */
901     function setTokenState(TokenState _tokenState)
902         external
903         optionalProxy_onlyOwner
904     {
905         tokenState = _tokenState;
906         emitTokenStateUpdated(_tokenState);
907     }
908  
909     function _internalTransfer(address from, address to, uint value)
910         internal
911         returns (bool)
912     {
913         /* Disallow transfers to irretrievable-addresses. */
914         require(to != address(0));
915         require(to != address(this));
916         require(to != address(proxy));
917  
918         /* Insufficient balance will be handled by the safe subtraction. */
919         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), value));
920         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), value));
921  
922         emitTransfer(from, to, value);
923  
924         return true;
925     }
926  
927     /**
928      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
929      * the onlyProxy or optionalProxy modifiers.
930      */
931     function _transfer_byProxy(address from, address to, uint value)
932         internal
933         returns (bool)
934     {
935         return _internalTransfer(from, to, value);
936     }
937  
938     /**
939      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
940      * possessing the optionalProxy or optionalProxy modifiers.
941      */
942     function _transferFrom_byProxy(address sender, address from, address to, uint value)
943         internal
944         returns (bool)
945     {
946         /* Insufficient allowance will be handled by the safe subtraction. */
947         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
948         return _internalTransfer(from, to, value);
949     }
950  
951     /**
952      * @notice Approves spender to transfer on the message sender's behalf.
953      */
954     function approve(address spender, uint value)
955         public
956         optionalProxy
957         returns (bool)
958     {
959         address sender = messageSender;
960  
961         tokenState.setAllowance(sender, spender, value);
962         emitApproval(sender, spender, value);
963         return true;
964     }
965  
966     /* ========== EVENTS ========== */
967  
968     event Transfer(address indexed from, address indexed to, uint value);
969     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
970     function emitTransfer(address from, address to, uint value) internal {
971         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
972     }
973  
974     event Approval(address indexed owner, address indexed spender, uint value);
975     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
976     function emitApproval(address owner, address spender, uint value) internal {
977         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
978     }
979  
980     event TokenStateUpdated(address newTokenState);
981     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
982     function emitTokenStateUpdated(address newTokenState) internal {
983         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
984     }
985 }
986  
987  
988 /*
989 -----------------------------------------------------------------
990 FILE INFORMATION
991 -----------------------------------------------------------------
992  
993 file:       FeeToken.sol
994 version:    1.3
995 author:     Anton Jurisevic
996             Dominic Romanowski
997             Kevin Brown
998  
999 date:       2018-05-29
1000  
1001 -----------------------------------------------------------------
1002 MODULE DESCRIPTION
1003 -----------------------------------------------------------------
1004  
1005 A token which also has a configurable fee rate
1006 charged on its transfers. This is designed to be overridden in
1007 order to produce an ERC20-compliant token.
1008  
1009 These fees accrue into a pool, from which a nominated authority
1010 may withdraw.
1011  
1012 This contract utilises an external state for upgradeability.
1013  
1014 -----------------------------------------------------------------
1015 */
1016  
1017  
1018 /**
1019  * @title ERC20 Token contract, with detached state.
1020  * Additionally charges fees on each transfer.
1021  */
1022 contract FeeToken is ExternStateToken {
1023  
1024     /* ========== STATE VARIABLES ========== */
1025  
1026     /* ERC20 members are declared in ExternStateToken. */
1027  
1028     /* A percentage fee charged on each transfer. */
1029     uint public transferFeeRate;
1030     /* Fee may not exceed 10%. */
1031     uint constant MAX_TRANSFER_FEE_RATE = UNIT / 10;
1032     /* The address with the authority to distribute fees. */
1033     address public feeAuthority;
1034     /* The address that fees will be pooled in. */
1035     address public constant FEE_ADDRESS = 0xfeefeefeefeefeefeefeefeefeefeefeefeefeef;
1036  
1037  
1038     /* ========== CONSTRUCTOR ========== */
1039  
1040     /**
1041      * @dev Constructor.
1042      * @param _proxy The proxy associated with this contract.
1043      * @param _name Token's ERC20 name.
1044      * @param _symbol Token's ERC20 symbol.
1045      * @param _totalSupply The total supply of the token.
1046      * @param _transferFeeRate The fee rate to charge on transfers.
1047      * @param _feeAuthority The address which has the authority to withdraw fees from the accumulated pool.
1048      * @param _owner The owner of this contract.
1049      */
1050     constructor(address _proxy, TokenState _tokenState, string _name, string _symbol, uint _totalSupply,
1051                 uint _transferFeeRate, address _feeAuthority, address _owner)
1052         ExternStateToken(_proxy, _tokenState,
1053                          _name, _symbol, _totalSupply,
1054                          _owner)
1055         public
1056     {
1057         feeAuthority = _feeAuthority;
1058  
1059         /* Constructed transfer fee rate should respect the maximum fee rate. */
1060         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE);
1061         transferFeeRate = _transferFeeRate;
1062     }
1063  
1064     /* ========== SETTERS ========== */
1065  
1066     /**
1067      * @notice Set the transfer fee, anywhere within the range 0-10%.
1068      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1069      */
1070     function setTransferFeeRate(uint _transferFeeRate)
1071         external
1072         optionalProxy_onlyOwner
1073     {
1074         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE);
1075         transferFeeRate = _transferFeeRate;
1076         emitTransferFeeRateUpdated(_transferFeeRate);
1077     }
1078  
1079     /**
1080      * @notice Set the address of the user/contract responsible for collecting or
1081      * distributing fees.
1082      */
1083     function setFeeAuthority(address _feeAuthority)
1084         public
1085         optionalProxy_onlyOwner
1086     {
1087         feeAuthority = _feeAuthority;
1088         emitFeeAuthorityUpdated(_feeAuthority);
1089     }
1090  
1091     /* ========== VIEWS ========== */
1092  
1093     /**
1094      * @notice Calculate the Fee charged on top of a value being sent
1095      * @return Return the fee charged
1096      */
1097     function transferFeeIncurred(uint value)
1098         public
1099         view
1100         returns (uint)
1101     {
1102         return safeMul_dec(value, transferFeeRate);
1103         /* Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1104          * This is on the basis that transfers less than this value will result in a nil fee.
1105          * Probably too insignificant to worry about, but the following code will achieve it.
1106          *      if (fee == 0 && transferFeeRate != 0) {
1107          *          return _value;
1108          *      }
1109          *      return fee;
1110          */
1111     }
1112  
1113     /**
1114      * @notice The value that you would need to send so that the recipient receives
1115      * a specified value.
1116      */
1117     function transferPlusFee(uint value)
1118         external
1119         view
1120         returns (uint)
1121     {
1122         return safeAdd(value, transferFeeIncurred(value));
1123     }
1124  
1125     /**
1126      * @notice The amount the recipient will receive if you send a certain number of tokens.
1127      */
1128     function amountReceived(uint value)
1129         public
1130         view
1131         returns (uint)
1132     {
1133         return safeDiv_dec(value, safeAdd(UNIT, transferFeeRate));
1134     }
1135  
1136     /**
1137      * @notice Collected fees sit here until they are distributed.
1138      * @dev The balance of the nomin contract itself is the fee pool.
1139      */
1140     function feePool()
1141         external
1142         view
1143         returns (uint)
1144     {
1145         return tokenState.balanceOf(FEE_ADDRESS);
1146     }
1147  
1148     /* ========== MUTATIVE FUNCTIONS ========== */
1149  
1150     /**
1151      * @notice Base of transfer functions
1152      */
1153     function _internalTransfer(address from, address to, uint amount, uint fee)
1154         internal
1155         returns (bool)
1156     {
1157         /* Disallow transfers to irretrievable-addresses. */
1158         require(to != address(0));
1159         require(to != address(this));
1160         require(to != address(proxy));
1161  
1162         /* Insufficient balance will be handled by the safe subtraction. */
1163         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), safeAdd(amount, fee)));
1164         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), amount));
1165         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), fee));
1166  
1167         /* Emit events for both the transfer itself and the fee. */
1168         emitTransfer(from, to, amount);
1169         emitTransfer(from, FEE_ADDRESS, fee);
1170  
1171         return true;
1172     }
1173  
1174     /**
1175      * @notice ERC20 friendly transfer function.
1176      */
1177     function _transfer_byProxy(address sender, address to, uint value)
1178         internal
1179         returns (bool)
1180     {
1181         uint received = amountReceived(value);
1182         uint fee = safeSub(value, received);
1183  
1184         return _internalTransfer(sender, to, received, fee);
1185     }
1186  
1187     /**
1188      * @notice ERC20 friendly transferFrom function.
1189      */
1190     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1191         internal
1192         returns (bool)
1193     {
1194         /* The fee is deducted from the amount sent. */
1195         uint received = amountReceived(value);
1196         uint fee = safeSub(value, received);
1197  
1198         /* Reduce the allowance by the amount we're transferring.
1199          * The safeSub call will handle an insufficient allowance. */
1200         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
1201  
1202         return _internalTransfer(from, to, received, fee);
1203     }
1204  
1205     /**
1206      * @notice Ability to transfer where the sender pays the fees (not ERC20)
1207      */
1208     function _transferSenderPaysFee_byProxy(address sender, address to, uint value)
1209         internal
1210         returns (bool)
1211     {
1212         /* The fee is added to the amount sent. */
1213         uint fee = transferFeeIncurred(value);
1214         return _internalTransfer(sender, to, value, fee);
1215     }
1216  
1217     /**
1218      * @notice Ability to transferFrom where they sender pays the fees (not ERC20).
1219      */
1220     function _transferFromSenderPaysFee_byProxy(address sender, address from, address to, uint value)
1221         internal
1222         returns (bool)
1223     {
1224         /* The fee is added to the amount sent. */
1225         uint fee = transferFeeIncurred(value);
1226         uint total = safeAdd(value, fee);
1227  
1228         /* Reduce the allowance by the amount we're transferring. */
1229         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), total));
1230  
1231         return _internalTransfer(from, to, value, fee);
1232     }
1233  
1234     /**
1235      * @notice Withdraw tokens from the fee pool into a given account.
1236      * @dev Only the fee authority may call this.
1237      */
1238     function withdrawFees(address account, uint value)
1239         external
1240         onlyFeeAuthority
1241         returns (bool)
1242     {
1243         require(account != address(0));
1244  
1245         /* 0-value withdrawals do nothing. */
1246         if (value == 0) {
1247             return false;
1248         }
1249  
1250         /* Safe subtraction ensures an exception is thrown if the balance is insufficient. */
1251         tokenState.setBalanceOf(FEE_ADDRESS, safeSub(tokenState.balanceOf(FEE_ADDRESS), value));
1252         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), value));
1253  
1254         emitFeesWithdrawn(account, value);
1255         emitTransfer(FEE_ADDRESS, account, value);
1256  
1257         return true;
1258     }
1259  
1260     /**
1261      * @notice Donate tokens from the sender's balance into the fee pool.
1262      */
1263     function donateToFeePool(uint n)
1264         external
1265         optionalProxy
1266         returns (bool)
1267     {
1268         address sender = messageSender;
1269         /* Empty donations are disallowed. */
1270         uint balance = tokenState.balanceOf(sender);
1271         require(balance != 0);
1272  
1273         /* safeSub ensures the donor has sufficient balance. */
1274         tokenState.setBalanceOf(sender, safeSub(balance, n));
1275         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), n));
1276  
1277         emitFeesDonated(sender, n);
1278         emitTransfer(sender, FEE_ADDRESS, n);
1279  
1280         return true;
1281     }
1282  
1283  
1284     /* ========== MODIFIERS ========== */
1285  
1286     modifier onlyFeeAuthority
1287     {
1288         require(msg.sender == feeAuthority);
1289         _;
1290     }
1291  
1292  
1293     /* ========== EVENTS ========== */
1294  
1295     event TransferFeeRateUpdated(uint newFeeRate);
1296     bytes32 constant TRANSFERFEERATEUPDATED_SIG = keccak256("TransferFeeRateUpdated(uint256)");
1297     function emitTransferFeeRateUpdated(uint newFeeRate) internal {
1298         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEERATEUPDATED_SIG, 0, 0, 0);
1299     }
1300  
1301     event FeeAuthorityUpdated(address newFeeAuthority);
1302     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
1303     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
1304         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
1305     }
1306  
1307     event FeesWithdrawn(address indexed account, uint value);
1308     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
1309     function emitFeesWithdrawn(address account, uint value) internal {
1310         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
1311     }
1312  
1313     event FeesDonated(address indexed donor, uint value);
1314     bytes32 constant FEESDONATED_SIG = keccak256("FeesDonated(address,uint256)");
1315     function emitFeesDonated(address donor, uint value) internal {
1316         proxy._emit(abi.encode(value), 2, FEESDONATED_SIG, bytes32(donor), 0, 0);
1317     }
1318 }
1319  
1320  
1321 /*
1322 -----------------------------------------------------------------
1323 FILE INFORMATION
1324 -----------------------------------------------------------------
1325  
1326 file:       LimitedSetup.sol
1327 version:    1.1
1328 author:     Anton Jurisevic
1329  
1330 date:       2018-05-15
1331  
1332 -----------------------------------------------------------------
1333 MODULE DESCRIPTION
1334 -----------------------------------------------------------------
1335  
1336 A contract with a limited setup period. Any function modified
1337 with the setup modifier will cease to work after the
1338 conclusion of the configurable-length post-construction setup period.
1339  
1340 -----------------------------------------------------------------
1341 */
1342  
1343  
1344 /**
1345  * @title Any function decorated with the modifier this contract provides
1346  * deactivates after a specified setup period.
1347  */
1348 contract LimitedSetup {
1349  
1350     uint setupExpiryTime;
1351  
1352     /**
1353      * @dev LimitedSetup Constructor.
1354      * @param setupDuration The time the setup period will last for.
1355      */
1356     constructor(uint setupDuration)
1357         public
1358     {
1359         setupExpiryTime = now + setupDuration;
1360     }
1361  
1362     modifier onlyDuringSetup
1363     {
1364         require(now < setupExpiryTime);
1365         _;
1366     }
1367 }
1368  
1369  
1370 /*
1371 -----------------------------------------------------------------
1372 FILE INFORMATION
1373 -----------------------------------------------------------------
1374  
1375 file:       HavvenEscrow.sol
1376 version:    1.1
1377 author:     Anton Jurisevic
1378             Dominic Romanowski
1379             Mike Spain
1380  
1381 date:       2018-05-29
1382  
1383 -----------------------------------------------------------------
1384 MODULE DESCRIPTION
1385 -----------------------------------------------------------------
1386  
1387 This contract allows the foundation to apply unique vesting
1388 schedules to havven funds sold at various discounts in the token
1389 sale. HavvenEscrow gives users the ability to inspect their
1390 vested funds, their quantities and vesting dates, and to withdraw
1391 the fees that accrue on those funds.
1392  
1393 The fees are handled by withdrawing the entire fee allocation
1394 for all havvens inside the escrow contract, and then allowing
1395 the contract itself to subdivide that pool up proportionally within
1396 itself. Every time the fee period rolls over in the main Havven
1397 contract, the HavvenEscrow fee pool is remitted back into the
1398 main fee pool to be redistributed in the next fee period.
1399  
1400 -----------------------------------------------------------------
1401 */
1402  
1403  
1404 /**
1405  * @title A contract to hold escrowed havvens and free them at given schedules.
1406  */
1407 contract HavvenEscrow is SafeDecimalMath, Owned, LimitedSetup(8 weeks) {
1408     /* The corresponding Havven contract. */
1409     Havven public havven;
1410  
1411     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
1412      * These are the times at which each given quantity of havvens vests. */
1413     mapping(address => uint[2][]) public vestingSchedules;
1414  
1415     /* An account's total vested havven balance to save recomputing this for fee extraction purposes. */
1416     mapping(address => uint) public totalVestedAccountBalance;
1417  
1418     /* The total remaining vested balance, for verifying the actual havven balance of this contract against. */
1419     uint public totalVestedBalance;
1420  
1421     uint constant TIME_INDEX = 0;
1422     uint constant QUANTITY_INDEX = 1;
1423  
1424     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
1425     uint constant MAX_VESTING_ENTRIES = 20;
1426  
1427  
1428     /* ========== CONSTRUCTOR ========== */
1429  
1430     constructor(address _owner, Havven _havven)
1431         Owned(_owner)
1432         public
1433     {
1434         havven = _havven;
1435     }
1436  
1437  
1438     /* ========== SETTERS ========== */
1439  
1440     function setHavven(Havven _havven)
1441         external
1442         onlyOwner
1443     {
1444         havven = _havven;
1445         emit HavvenUpdated(_havven);
1446     }
1447  
1448  
1449     /* ========== VIEW FUNCTIONS ========== */
1450  
1451     /**
1452      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
1453      */
1454     function balanceOf(address account)
1455         public
1456         view
1457         returns (uint)
1458     {
1459         return totalVestedAccountBalance[account];
1460     }
1461  
1462     /**
1463      * @notice The number of vesting dates in an account's schedule.
1464      */
1465     function numVestingEntries(address account)
1466         public
1467         view
1468         returns (uint)
1469     {
1470         return vestingSchedules[account].length;
1471     }
1472  
1473     /**
1474      * @notice Get a particular schedule entry for an account.
1475      * @return A pair of uints: (timestamp, havven quantity).
1476      */
1477     function getVestingScheduleEntry(address account, uint index)
1478         public
1479         view
1480         returns (uint[2])
1481     {
1482         return vestingSchedules[account][index];
1483     }
1484  
1485     /**
1486      * @notice Get the time at which a given schedule entry will vest.
1487      */
1488     function getVestingTime(address account, uint index)
1489         public
1490         view
1491         returns (uint)
1492     {
1493         return getVestingScheduleEntry(account,index)[TIME_INDEX];
1494     }
1495  
1496     /**
1497      * @notice Get the quantity of havvens associated with a given schedule entry.
1498      */
1499     function getVestingQuantity(address account, uint index)
1500         public
1501         view
1502         returns (uint)
1503     {
1504         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
1505     }
1506  
1507     /**
1508      * @notice Obtain the index of the next schedule entry that will vest for a given user.
1509      */
1510     function getNextVestingIndex(address account)
1511         public
1512         view
1513         returns (uint)
1514     {
1515         uint len = numVestingEntries(account);
1516         for (uint i = 0; i < len; i++) {
1517             if (getVestingTime(account, i) != 0) {
1518                 return i;
1519             }
1520         }
1521         return len;
1522     }
1523  
1524     /**
1525      * @notice Obtain the next schedule entry that will vest for a given user.
1526      * @return A pair of uints: (timestamp, havven quantity). */
1527     function getNextVestingEntry(address account)
1528         public
1529         view
1530         returns (uint[2])
1531     {
1532         uint index = getNextVestingIndex(account);
1533         if (index == numVestingEntries(account)) {
1534             return [uint(0), 0];
1535         }
1536         return getVestingScheduleEntry(account, index);
1537     }
1538  
1539     /**
1540      * @notice Obtain the time at which the next schedule entry will vest for a given user.
1541      */
1542     function getNextVestingTime(address account)
1543         external
1544         view
1545         returns (uint)
1546     {
1547         return getNextVestingEntry(account)[TIME_INDEX];
1548     }
1549  
1550     /**
1551      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
1552      */
1553     function getNextVestingQuantity(address account)
1554         external
1555         view
1556         returns (uint)
1557     {
1558         return getNextVestingEntry(account)[QUANTITY_INDEX];
1559     }
1560  
1561  
1562     /* ========== MUTATIVE FUNCTIONS ========== */
1563  
1564     /**
1565      * @notice Withdraws a quantity of havvens back to the havven contract.
1566      * @dev This may only be called by the owner during the contract's setup period.
1567      */
1568     function withdrawHavvens(uint quantity)
1569         external
1570         onlyOwner
1571         onlyDuringSetup
1572     {
1573         havven.transfer(havven, quantity);
1574     }
1575  
1576     /**
1577      * @notice Destroy the vesting information associated with an account.
1578      */
1579     function purgeAccount(address account)
1580         external
1581         onlyOwner
1582         onlyDuringSetup
1583     {
1584         delete vestingSchedules[account];
1585         totalVestedBalance = safeSub(totalVestedBalance, totalVestedAccountBalance[account]);
1586         delete totalVestedAccountBalance[account];
1587     }
1588  
1589     /**
1590      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
1591      * @dev A call to this should be accompanied by either enough balance already available
1592      * in this contract, or a corresponding call to havven.endow(), to ensure that when
1593      * the funds are withdrawn, there is enough balance, as well as correctly calculating
1594      * the fees.
1595      * This may only be called by the owner during the contract's setup period.
1596      * Note; although this function could technically be used to produce unbounded
1597      * arrays, it's only in the foundation's command to add to these lists.
1598      * @param account The account to append a new vesting entry to.
1599      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
1600      * @param quantity The quantity of havvens that will vest.
1601      */
1602     function appendVestingEntry(address account, uint time, uint quantity)
1603         public
1604         onlyOwner
1605         onlyDuringSetup
1606     {
1607         /* No empty or already-passed vesting entries allowed. */
1608         require(now < time);
1609         require(quantity != 0);
1610  
1611         /* There must be enough balance in the contract to provide for the vesting entry. */
1612         totalVestedBalance = safeAdd(totalVestedBalance, quantity);
1613         require(totalVestedBalance <= havven.balanceOf(this));
1614  
1615         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
1616         uint scheduleLength = vestingSchedules[account].length;
1617         require(scheduleLength <= MAX_VESTING_ENTRIES);
1618  
1619         if (scheduleLength == 0) {
1620             totalVestedAccountBalance[account] = quantity;
1621         } else {
1622             /* Disallow adding new vested havvens earlier than the last one.
1623              * Since entries are only appended, this means that no vesting date can be repeated. */
1624             require(getVestingTime(account, numVestingEntries(account) - 1) < time);
1625             totalVestedAccountBalance[account] = safeAdd(totalVestedAccountBalance[account], quantity);
1626         }
1627  
1628         vestingSchedules[account].push([time, quantity]);
1629     }
1630  
1631     /**
1632      * @notice Construct a vesting schedule to release a quantities of havvens
1633      * over a series of intervals.
1634      * @dev Assumes that the quantities are nonzero
1635      * and that the sequence of timestamps is strictly increasing.
1636      * This may only be called by the owner during the contract's setup period.
1637      */
1638     function addVestingSchedule(address account, uint[] times, uint[] quantities)
1639         external
1640         onlyOwner
1641         onlyDuringSetup
1642     {
1643         for (uint i = 0; i < times.length; i++) {
1644             appendVestingEntry(account, times[i], quantities[i]);
1645         }
1646  
1647     }
1648  
1649     /**
1650      * @notice Allow a user to withdraw any havvens in their schedule that have vested.
1651      */
1652     function vest()
1653         external
1654     {
1655         uint numEntries = numVestingEntries(msg.sender);
1656         uint total;
1657         for (uint i = 0; i < numEntries; i++) {
1658             uint time = getVestingTime(msg.sender, i);
1659             /* The list is sorted; when we reach the first future time, bail out. */
1660             if (time > now) {
1661                 break;
1662             }
1663             uint qty = getVestingQuantity(msg.sender, i);
1664             if (qty == 0) {
1665                 continue;
1666             }
1667  
1668             vestingSchedules[msg.sender][i] = [0, 0];
1669             total = safeAdd(total, qty);
1670         }
1671  
1672         if (total != 0) {
1673             totalVestedBalance = safeSub(totalVestedBalance, total);
1674             totalVestedAccountBalance[msg.sender] = safeSub(totalVestedAccountBalance[msg.sender], total);
1675             havven.transfer(msg.sender, total);
1676             emit Vested(msg.sender, now, total);
1677         }
1678     }
1679  
1680  
1681     /* ========== EVENTS ========== */
1682  
1683     event HavvenUpdated(address newHavven);
1684  
1685     event Vested(address indexed beneficiary, uint time, uint value);
1686 }
1687  
1688  
1689 /*
1690 -----------------------------------------------------------------
1691 FILE INFORMATION
1692 -----------------------------------------------------------------
1693  
1694 file:       Havven.sol
1695 version:    1.2
1696 author:     Anton Jurisevic
1697             Dominic Romanowski
1698  
1699 date:       2018-05-15
1700  
1701 -----------------------------------------------------------------
1702 MODULE DESCRIPTION
1703 -----------------------------------------------------------------
1704  
1705 Havven token contract. Havvens are transferable ERC20 tokens,
1706 and also give their holders the following privileges.
1707 An owner of havvens may participate in nomin confiscation votes, they
1708 may also have the right to issue nomins at the discretion of the
1709 foundation for this version of the contract.
1710  
1711 After a fee period terminates, the duration and fees collected for that
1712 period are computed, and the next period begins. Thus an account may only
1713 withdraw the fees owed to them for the previous period, and may only do
1714 so once per period. Any unclaimed fees roll over into the common pot for
1715 the next period.
1716  
1717 == Average Balance Calculations ==
1718  
1719 The fee entitlement of a havven holder is proportional to their average
1720 issued nomin balance over the last fee period. This is computed by
1721 measuring the area under the graph of a user's issued nomin balance over
1722 time, and then when a new fee period begins, dividing through by the
1723 duration of the fee period.
1724  
1725 We need only update values when the balances of an account is modified.
1726 This occurs when issuing or burning for issued nomin balances,
1727 and when transferring for havven balances. This is for efficiency,
1728 and adds an implicit friction to interacting with havvens.
1729 A havven holder pays for his own recomputation whenever he wants to change
1730 his position, which saves the foundation having to maintain a pot dedicated
1731 to resourcing this.
1732  
1733 A hypothetical user's balance history over one fee period, pictorially:
1734  
1735       s ____
1736        |    |
1737        |    |___ p
1738        |____|___|___ __ _  _
1739        f    t   n
1740  
1741 Here, the balance was s between times f and t, at which time a transfer
1742 occurred, updating the balance to p, until n, when the present transfer occurs.
1743 When a new transfer occurs at time n, the balance being p,
1744 we must:
1745  
1746   - Add the area p * (n - t) to the total area recorded so far
1747   - Update the last transfer time to n
1748  
1749 So if this graph represents the entire current fee period,
1750 the average havvens held so far is ((t-f)*s + (n-t)*p) / (n-f).
1751 The complementary computations must be performed for both sender and
1752 recipient.
1753  
1754 Note that a transfer keeps global supply of havvens invariant.
1755 The sum of all balances is constant, and unmodified by any transfer.
1756 So the sum of all balances multiplied by the duration of a fee period is also
1757 constant, and this is equivalent to the sum of the area of every user's
1758 time/balance graph. Dividing through by that duration yields back the total
1759 havven supply. So, at the end of a fee period, we really do yield a user's
1760 average share in the havven supply over that period.
1761  
1762 A slight wrinkle is introduced if we consider the time r when the fee period
1763 rolls over. Then the previous fee period k-1 is before r, and the current fee
1764 period k is afterwards. If the last transfer took place before r,
1765 but the latest transfer occurred afterwards:
1766  
1767 k-1       |        k
1768       s __|_
1769        |  | |
1770        |  | |____ p
1771        |__|_|____|___ __ _  _
1772           |
1773        f  | t    n
1774           r
1775  
1776 In this situation the area (r-f)*s contributes to fee period k-1, while
1777 the area (t-r)*s contributes to fee period k. We will implicitly consider a
1778 zero-value transfer to have occurred at time r. Their fee entitlement for the
1779 previous period will be finalised at the time of their first transfer during the
1780 current fee period, or when they query or withdraw their fee entitlement.
1781  
1782 In the implementation, the duration of different fee periods may be slightly irregular,
1783 as the check that they have rolled over occurs only when state-changing havven
1784 operations are performed.
1785  
1786 == Issuance and Burning ==
1787  
1788 In this version of the havven contract, nomins can only be issued by
1789 those that have been nominated by the havven foundation. Nomins are assumed
1790 to be valued at $1, as they are a stable unit of account.
1791  
1792 All nomins issued require a proportional value of havvens to be locked,
1793 where the proportion is governed by the current issuance ratio. This
1794 means for every $1 of Havvens locked up, $(issuanceRatio) nomins can be issued.
1795 i.e. to issue 100 nomins, 100/issuanceRatio dollars of havvens need to be locked up.
1796  
1797 To determine the value of some amount of havvens(H), an oracle is used to push
1798 the price of havvens (P_H) in dollars to the contract. The value of H
1799 would then be: H * P_H.
1800  
1801 Any havvens that are locked up by this issuance process cannot be transferred.
1802 The amount that is locked floats based on the price of havvens. If the price
1803 of havvens moves up, less havvens are locked, so they can be issued against,
1804 or transferred freely. If the price of havvens moves down, more havvens are locked,
1805 even going above the initial wallet balance.
1806  
1807 -----------------------------------------------------------------
1808 */
1809  
1810  
1811 /**
1812  * @title Havven ERC20 contract.
1813  * @notice The Havven contracts does not only facilitate transfers and track balances,
1814  * but it also computes the quantity of fees each havven holder is entitled to.
1815  */
1816 contract Havven is ExternStateToken {
1817  
1818     /* ========== STATE VARIABLES ========== */
1819  
1820     /* A struct for handing values associated with average balance calculations */
1821     struct IssuanceData {
1822         /* Sums of balances*duration in the current fee period.
1823         /* range: decimals; units: havven-seconds */
1824         uint currentBalanceSum;
1825         /* The last period's average balance */
1826         uint lastAverageBalance;
1827         /* The last time the data was calculated */
1828         uint lastModified;
1829     }
1830  
1831     /* Issued nomin balances for individual fee entitlements */
1832     mapping(address => IssuanceData) public issuanceData;
1833     /* The total number of issued nomins for determining fee entitlements */
1834     IssuanceData public totalIssuanceData;
1835  
1836     /* The time the current fee period began */
1837     uint public feePeriodStartTime;
1838     /* The time the last fee period began */
1839     uint public lastFeePeriodStartTime;
1840  
1841     /* Fee periods will roll over in no shorter a time than this.
1842      * The fee period cannot actually roll over until a fee-relevant
1843      * operation such as withdrawal or a fee period duration update occurs,
1844      * so this is just a target, and the actual duration may be slightly longer. */
1845     uint public feePeriodDuration = 4 weeks;
1846     /* ...and must target between 1 day and six months. */
1847     uint constant MIN_FEE_PERIOD_DURATION = 1 days;
1848     uint constant MAX_FEE_PERIOD_DURATION = 26 weeks;
1849  
1850     /* The quantity of nomins that were in the fee pot at the time */
1851     /* of the last fee rollover, at feePeriodStartTime. */
1852     uint public lastFeesCollected;
1853  
1854     /* Whether a user has withdrawn their last fees */
1855     mapping(address => bool) public hasWithdrawnFees;
1856  
1857     Nomin public nomin;
1858     HavvenEscrow public escrow;
1859  
1860     /* The address of the oracle which pushes the havven price to this contract */
1861     address public oracle;
1862     /* The price of havvens written in UNIT */
1863     uint public price;
1864     /* The time the havven price was last updated */
1865     uint public lastPriceUpdateTime;
1866     /* How long will the contract assume the price of havvens is correct */
1867     uint public priceStalePeriod = 3 hours;
1868  
1869     /* A quantity of nomins greater than this ratio
1870      * may not be issued against a given value of havvens. */
1871     uint public issuanceRatio = UNIT / 5;
1872     /* No more nomins may be issued than the value of havvens backing them. */
1873     uint constant MAX_ISSUANCE_RATIO = UNIT;
1874  
1875     /* Whether the address can issue nomins or not. */
1876     mapping(address => bool) public isIssuer;
1877     /* The number of currently-outstanding nomins the user has issued. */
1878     mapping(address => uint) public nominsIssued;
1879  
1880     uint constant HAVVEN_SUPPLY = 1e8 * UNIT;
1881     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
1882     string constant TOKEN_NAME = "Havven";
1883     string constant TOKEN_SYMBOL = "HAV";
1884      
1885     /* ========== CONSTRUCTOR ========== */
1886  
1887     /**
1888      * @dev Constructor
1889      * @param _tokenState A pre-populated contract containing token balances.
1890      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
1891      * @param _owner The owner of this contract.
1892      */
1893     constructor(address _proxy, TokenState _tokenState, address _owner, address _oracle,
1894                 uint _price, address[] _issuers, Havven _oldHavven)
1895         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, HAVVEN_SUPPLY, _owner)
1896         public
1897     {
1898         oracle = _oracle;
1899         price = _price;
1900         lastPriceUpdateTime = now;
1901  
1902         uint i;
1903         if (_oldHavven == address(0)) {
1904             feePeriodStartTime = now;
1905             lastFeePeriodStartTime = now - feePeriodDuration;
1906             for (i = 0; i < _issuers.length; i++) {
1907                 isIssuer[_issuers[i]] = true;
1908             }
1909         } else {
1910             feePeriodStartTime = _oldHavven.feePeriodStartTime();
1911             lastFeePeriodStartTime = _oldHavven.lastFeePeriodStartTime();
1912  
1913             uint cbs;
1914             uint lab;
1915             uint lm;
1916             (cbs, lab, lm) = _oldHavven.totalIssuanceData();
1917             totalIssuanceData.currentBalanceSum = cbs;
1918             totalIssuanceData.lastAverageBalance = lab;
1919             totalIssuanceData.lastModified = lm;
1920  
1921             for (i = 0; i < _issuers.length; i++) {
1922                 address issuer = _issuers[i];
1923                 isIssuer[issuer] = true;
1924                 uint nomins = _oldHavven.nominsIssued(issuer);
1925                 if (nomins == 0) {
1926                     // It is not valid in general to skip those with no currently-issued nomins.
1927                     // But for this release, issuers with nonzero issuanceData have current issuance.
1928                     continue;
1929                 }
1930                 (cbs, lab, lm) = _oldHavven.issuanceData(issuer);
1931                 nominsIssued[issuer] = nomins;
1932                 issuanceData[issuer].currentBalanceSum = cbs;
1933                 issuanceData[issuer].lastAverageBalance = lab;
1934                 issuanceData[issuer].lastModified = lm;
1935             }
1936         }
1937  
1938     }
1939  
1940     /* ========== SETTERS ========== */
1941  
1942     /**
1943      * @notice Set the associated Nomin contract to collect fees from.
1944      * @dev Only the contract owner may call this.
1945      */
1946     function setNomin(Nomin _nomin)
1947         external
1948         optionalProxy_onlyOwner
1949     {
1950         nomin = _nomin;
1951         emitNominUpdated(_nomin);
1952     }
1953  
1954     /**
1955      * @notice Set the associated havven escrow contract.
1956      * @dev Only the contract owner may call this.
1957      */
1958     function setEscrow(HavvenEscrow _escrow)
1959         external
1960         optionalProxy_onlyOwner
1961     {
1962         escrow = _escrow;
1963         emitEscrowUpdated(_escrow);
1964     }
1965  
1966     /**
1967      * @notice Set the targeted fee period duration.
1968      * @dev Only callable by the contract owner. The duration must fall within
1969      * acceptable bounds (1 day to 26 weeks). Upon resetting this the fee period
1970      * may roll over if the target duration was shortened sufficiently.
1971      */
1972     function setFeePeriodDuration(uint duration)
1973         external
1974         optionalProxy_onlyOwner
1975     {
1976         require(MIN_FEE_PERIOD_DURATION <= duration &&
1977                                duration <= MAX_FEE_PERIOD_DURATION);
1978         feePeriodDuration = duration;
1979         emitFeePeriodDurationUpdated(duration);
1980         rolloverFeePeriodIfElapsed();
1981     }
1982  
1983     /**
1984      * @notice Set the Oracle that pushes the havven price to this contract
1985      */
1986     function setOracle(address _oracle)
1987         external
1988         optionalProxy_onlyOwner
1989     {
1990         oracle = _oracle;
1991         emitOracleUpdated(_oracle);
1992     }
1993  
1994     /**
1995      * @notice Set the stale period on the updated havven price
1996      * @dev No max/minimum, as changing it wont influence anything but issuance by the foundation
1997      */
1998     function setPriceStalePeriod(uint time)
1999         external
2000         optionalProxy_onlyOwner
2001     {
2002         priceStalePeriod = time;
2003     }
2004  
2005     /**
2006      * @notice Set the issuanceRatio for issuance calculations.
2007      * @dev Only callable by the contract owner.
2008      */
2009     function setIssuanceRatio(uint _issuanceRatio)
2010         external
2011         optionalProxy_onlyOwner
2012     {
2013         require(_issuanceRatio <= MAX_ISSUANCE_RATIO);
2014         issuanceRatio = _issuanceRatio;
2015         emitIssuanceRatioUpdated(_issuanceRatio);
2016     }
2017  
2018     /**
2019      * @notice Set whether the specified can issue nomins or not.
2020      */
2021     function setIssuer(address account, bool value)
2022         external
2023         optionalProxy_onlyOwner
2024     {
2025         isIssuer[account] = value;
2026         emitIssuersUpdated(account, value);
2027     }
2028  
2029     /* ========== VIEWS ========== */
2030  
2031     function issuanceCurrentBalanceSum(address account)
2032         external
2033         view
2034         returns (uint)
2035     {
2036         return issuanceData[account].currentBalanceSum;
2037     }
2038  
2039     function issuanceLastAverageBalance(address account)
2040         external
2041         view
2042         returns (uint)
2043     {
2044         return issuanceData[account].lastAverageBalance;
2045     }
2046  
2047     function issuanceLastModified(address account)
2048         external
2049         view
2050         returns (uint)
2051     {
2052         return issuanceData[account].lastModified;
2053     }
2054  
2055     function totalIssuanceCurrentBalanceSum()
2056         external
2057         view
2058         returns (uint)
2059     {
2060         return totalIssuanceData.currentBalanceSum;
2061     }
2062  
2063     function totalIssuanceLastAverageBalance()
2064         external
2065         view
2066         returns (uint)
2067     {
2068         return totalIssuanceData.lastAverageBalance;
2069     }
2070  
2071     function totalIssuanceLastModified()
2072         external
2073         view
2074         returns (uint)
2075     {
2076         return totalIssuanceData.lastModified;
2077     }
2078  
2079     /* ========== MUTATIVE FUNCTIONS ========== */
2080  
2081     /**
2082      * @notice ERC20 transfer function.
2083      */
2084     function transfer(address to, uint value)
2085         public
2086         optionalProxy
2087         returns (bool)
2088     {
2089         address sender = messageSender;
2090         require(nominsIssued[sender] == 0 || value <= transferableHavvens(sender));
2091         /* Perform the transfer: if there is a problem,
2092          * an exception will be thrown in this call. */
2093         _transfer_byProxy(sender, to, value);
2094  
2095         return true;
2096     }
2097  
2098     /**
2099      * @notice ERC20 transferFrom function.
2100      */
2101     function transferFrom(address from, address to, uint value)
2102         public
2103         optionalProxy
2104         returns (bool)
2105     {
2106         address sender = messageSender;
2107         require(nominsIssued[from] == 0 || value <= transferableHavvens(from));
2108         /* Perform the transfer: if there is a problem,
2109          * an exception will be thrown in this call. */
2110         _transferFrom_byProxy(sender, from, to, value);
2111  
2112         return true;
2113     }
2114  
2115     /**
2116      * @notice Compute the last period's fee entitlement for the message sender
2117      * and then deposit it into their nomin account.
2118      */
2119     function withdrawFees()
2120         external
2121         optionalProxy
2122     {
2123         address sender = messageSender;
2124         rolloverFeePeriodIfElapsed();
2125         /* Do not deposit fees into frozen accounts. */
2126         require(!nomin.frozen(sender));
2127  
2128         /* Check the period has rolled over first. */
2129         updateIssuanceData(sender, nominsIssued[sender], nomin.totalSupply());
2130  
2131         /* Only allow accounts to withdraw fees once per period. */
2132         require(!hasWithdrawnFees[sender]);
2133  
2134         uint feesOwed;
2135         uint lastTotalIssued = totalIssuanceData.lastAverageBalance;
2136  
2137         if (lastTotalIssued > 0) {
2138             /* Sender receives a share of last period's collected fees proportional
2139              * with their average fraction of the last period's issued nomins. */
2140             feesOwed = safeDiv_dec(
2141                 safeMul_dec(issuanceData[sender].lastAverageBalance, lastFeesCollected),
2142                 lastTotalIssued
2143             );
2144         }
2145  
2146         hasWithdrawnFees[sender] = true;
2147  
2148         if (feesOwed != 0) {
2149             nomin.withdrawFees(sender, feesOwed);
2150         }
2151         emitFeesWithdrawn(messageSender, feesOwed);
2152     }
2153  
2154     /**
2155      * @notice Update the havven balance averages since the last transfer
2156      * or entitlement adjustment.
2157      * @dev Since this updates the last transfer timestamp, if invoked
2158      * consecutively, this function will do nothing after the first call.
2159      * Also, this will adjust the total issuance at the same time.
2160      */
2161     function updateIssuanceData(address account, uint preBalance, uint lastTotalSupply)
2162         internal
2163     {
2164         /* update the total balances first */
2165         totalIssuanceData = computeIssuanceData(lastTotalSupply, totalIssuanceData);
2166  
2167         if (issuanceData[account].lastModified < feePeriodStartTime) {
2168             hasWithdrawnFees[account] = false;
2169         }
2170  
2171         issuanceData[account] = computeIssuanceData(preBalance, issuanceData[account]);
2172     }
2173  
2174  
2175     /**
2176      * @notice Compute the new IssuanceData on the old balance
2177      */
2178     function computeIssuanceData(uint preBalance, IssuanceData preIssuance)
2179         internal
2180         view
2181         returns (IssuanceData)
2182     {
2183  
2184         uint currentBalanceSum = preIssuance.currentBalanceSum;
2185         uint lastAverageBalance = preIssuance.lastAverageBalance;
2186         uint lastModified = preIssuance.lastModified;
2187  
2188         if (lastModified < feePeriodStartTime) {
2189             if (lastModified < lastFeePeriodStartTime) {
2190                 /* The balance was last updated before the previous fee period, so the average
2191                  * balance in this period is their pre-transfer balance. */
2192                 lastAverageBalance = preBalance;
2193             } else {
2194                 /* The balance was last updated during the previous fee period. */
2195                 /* No overflow or zero denominator problems, since lastFeePeriodStartTime < feePeriodStartTime < lastModified.
2196                  * implies these quantities are strictly positive. */
2197                 uint timeUpToRollover = feePeriodStartTime - lastModified;
2198                 uint lastFeePeriodDuration = feePeriodStartTime - lastFeePeriodStartTime;
2199                 uint lastBalanceSum = safeAdd(currentBalanceSum, safeMul(preBalance, timeUpToRollover));
2200                 lastAverageBalance = lastBalanceSum / lastFeePeriodDuration;
2201             }
2202             /* Roll over to the next fee period. */
2203             currentBalanceSum = safeMul(preBalance, now - feePeriodStartTime);
2204         } else {
2205             /* The balance was last updated during the current fee period. */
2206             currentBalanceSum = safeAdd(
2207                 currentBalanceSum,
2208                 safeMul(preBalance, now - lastModified)
2209             );
2210         }
2211  
2212         return IssuanceData(currentBalanceSum, lastAverageBalance, now);
2213     }
2214  
2215     /**
2216      * @notice Recompute and return the given account's last average balance.
2217      */
2218     function recomputeLastAverageBalance(address account)
2219         external
2220         returns (uint)
2221     {
2222         updateIssuanceData(account, nominsIssued[account], nomin.totalSupply());
2223         return issuanceData[account].lastAverageBalance;
2224     }
2225  
2226     /**
2227      * @notice Issue nomins against the sender's havvens.
2228      * @dev Issuance is only allowed if the havven price isn't stale and the sender is an issuer.
2229      */
2230     function issueNomins(uint amount)
2231         public
2232         optionalProxy
2233         requireIssuer(messageSender)
2234         /* No need to check if price is stale, as it is checked in issuableNomins. */
2235     {
2236         address sender = messageSender;
2237         require(amount <= remainingIssuableNomins(sender));
2238         uint lastTot = nomin.totalSupply();
2239         uint preIssued = nominsIssued[sender];
2240         nomin.issue(sender, amount);
2241         nominsIssued[sender] = safeAdd(preIssued, amount);
2242         updateIssuanceData(sender, preIssued, lastTot);
2243     }
2244  
2245     function issueMaxNomins()
2246         external
2247         optionalProxy
2248     {
2249         issueNomins(remainingIssuableNomins(messageSender));
2250     }
2251  
2252     /**
2253      * @notice Burn nomins to clear issued nomins/free havvens.
2254      */
2255     function burnNomins(uint amount)
2256         /* it doesn't matter if the price is stale or if the user is an issuer, as non-issuers have issued no nomins.*/
2257         external
2258         optionalProxy
2259     {
2260         address sender = messageSender;
2261  
2262         uint lastTot = nomin.totalSupply();
2263         uint preIssued = nominsIssued[sender];
2264         /* nomin.burn does a safeSub on balance (so it will revert if there are not enough nomins). */
2265         nomin.burn(sender, amount);
2266         /* This safe sub ensures amount <= number issued */
2267         nominsIssued[sender] = safeSub(preIssued, amount);
2268         updateIssuanceData(sender, preIssued, lastTot);
2269     }
2270  
2271     /**
2272      * @notice Check if the fee period has rolled over. If it has, set the new fee period start
2273      * time, and record the fees collected in the nomin contract.
2274      */
2275     function rolloverFeePeriodIfElapsed()
2276         public
2277     {
2278         /* If the fee period has rolled over... */
2279         if (now >= feePeriodStartTime + feePeriodDuration) {
2280             lastFeesCollected = nomin.feePool();
2281             lastFeePeriodStartTime = feePeriodStartTime;
2282             feePeriodStartTime = now;
2283             emitFeePeriodRollover(now);
2284         }
2285     }
2286  
2287     /* ========== Issuance/Burning ========== */
2288  
2289     /**
2290      * @notice The maximum nomins an issuer can issue against their total havven quantity. This ignores any
2291      * already issued nomins.
2292      */
2293     function maxIssuableNomins(address issuer)
2294         view
2295         public
2296         priceNotStale
2297         returns (uint)
2298     {
2299         if (!isIssuer[issuer]) {
2300             return 0;
2301         }
2302         if (escrow != HavvenEscrow(0)) {
2303             uint totalOwnedHavvens = safeAdd(tokenState.balanceOf(issuer), escrow.balanceOf(issuer));
2304             return safeMul_dec(HAVtoUSD(totalOwnedHavvens), issuanceRatio);
2305         } else {
2306             return safeMul_dec(HAVtoUSD(tokenState.balanceOf(issuer)), issuanceRatio);
2307         }
2308     }
2309  
2310     /**
2311      * @notice The remaining nomins an issuer can issue against their total havven quantity.
2312      */
2313     function remainingIssuableNomins(address issuer)
2314         view
2315         public
2316         returns (uint)
2317     {
2318         uint issued = nominsIssued[issuer];
2319         uint max = maxIssuableNomins(issuer);
2320         if (issued > max) {
2321             return 0;
2322         } else {
2323             return safeSub(max, issued);
2324         }
2325     }
2326  
2327     /**
2328      * @notice The total havvens owned by this account, both escrowed and unescrowed,
2329      * against which nomins can be issued.
2330      * This includes those already being used as collateral (locked), and those
2331      * available for further issuance (unlocked).
2332      */
2333     function collateral(address account)
2334         public
2335         view
2336         returns (uint)
2337     {
2338         uint bal = tokenState.balanceOf(account);
2339         if (escrow != address(0)) {
2340             bal = safeAdd(bal, escrow.balanceOf(account));
2341         }
2342         return bal;
2343     }
2344  
2345     /**
2346      * @notice The collateral that would be locked by issuance, which can exceed the account's actual collateral.
2347      */
2348     function issuanceDraft(address account)
2349         public
2350         view
2351         returns (uint)
2352     {
2353         uint issued = nominsIssued[account];
2354         if (issued == 0) {
2355             return 0;
2356         }
2357         return USDtoHAV(safeDiv_dec(issued, issuanceRatio));
2358     }
2359  
2360     /**
2361      * @notice Collateral that has been locked due to issuance, and cannot be
2362      * transferred to other addresses. This is capped at the account's total collateral.
2363      */
2364     function lockedCollateral(address account)
2365         public
2366         view
2367         returns (uint)
2368     {
2369         uint debt = issuanceDraft(account);
2370         uint collat = collateral(account);
2371         if (debt > collat) {
2372             return collat;
2373         }
2374         return debt;
2375     }
2376  
2377     /**
2378      * @notice Collateral that is not locked and available for issuance.
2379      */
2380     function unlockedCollateral(address account)
2381         public
2382         view
2383         returns (uint)
2384     {
2385         uint locked = lockedCollateral(account);
2386         uint collat = collateral(account);
2387         return safeSub(collat, locked);
2388     }
2389  
2390     /**
2391      * @notice The number of havvens that are free to be transferred by an account.
2392      * @dev If they have enough available Havvens, it could be that
2393      * their havvens are escrowed, however the transfer would then
2394      * fail. This means that escrowed havvens are locked first,
2395      * and then the actual transferable ones.
2396      */
2397     function transferableHavvens(address account)
2398         public
2399         view
2400         returns (uint)
2401     {
2402         uint draft = issuanceDraft(account);
2403         uint collat = collateral(account);
2404         // In the case where the issuanceDraft exceeds the collateral, nothing is free
2405         if (draft > collat) {
2406             return 0;
2407         }
2408  
2409         uint bal = balanceOf(account);
2410         // In the case where the draft exceeds the escrow, but not the whole collateral
2411         //   return the fraction of the balance that remains free
2412         if (draft > safeSub(collat, bal)) {
2413             return safeSub(collat, draft);
2414         }
2415         // In the case where the draft doesn't exceed the escrow, return the entire balance
2416         return bal;
2417     }
2418  
2419     /**
2420      * @notice The value in USD for a given amount of HAV
2421      */
2422     function HAVtoUSD(uint hav_dec)
2423         public
2424         view
2425         priceNotStale
2426         returns (uint)
2427     {
2428         return safeMul_dec(hav_dec, price);
2429     }
2430  
2431     /**
2432      * @notice The value in HAV for a given amount of USD
2433      */
2434     function USDtoHAV(uint usd_dec)
2435         public
2436         view
2437         priceNotStale
2438         returns (uint)
2439     {
2440         return safeDiv_dec(usd_dec, price);
2441     }
2442  
2443     /**
2444      * @notice Access point for the oracle to update the price of havvens.
2445      */
2446     function updatePrice(uint newPrice, uint timeSent)
2447         external
2448         onlyOracle  /* Should be callable only by the oracle. */
2449     {
2450         /* Must be the most recently sent price, but not too far in the future.
2451          * (so we can't lock ourselves out of updating the oracle for longer than this) */
2452         require(lastPriceUpdateTime < timeSent && timeSent < now + ORACLE_FUTURE_LIMIT);
2453  
2454         price = newPrice;
2455         lastPriceUpdateTime = timeSent;
2456         emitPriceUpdated(newPrice, timeSent);
2457  
2458         /* Check the fee period rollover within this as the price should be pushed every 15min. */
2459         rolloverFeePeriodIfElapsed();
2460     }
2461  
2462     /**
2463      * @notice Check if the price of havvens hasn't been updated for longer than the stale period.
2464      */
2465     function priceIsStale()
2466         public
2467         view
2468         returns (bool)
2469     {
2470         return safeAdd(lastPriceUpdateTime, priceStalePeriod) < now;
2471     }
2472  
2473     /* ========== MODIFIERS ========== */
2474  
2475     modifier requireIssuer(address account)
2476     {
2477         require(isIssuer[account]);
2478         _;
2479     }
2480  
2481     modifier onlyOracle
2482     {
2483         require(msg.sender == oracle);
2484         _;
2485     }
2486  
2487     modifier priceNotStale
2488     {
2489         require(!priceIsStale());
2490         _;
2491     }
2492  
2493     /* ========== EVENTS ========== */
2494  
2495     event PriceUpdated(uint newPrice, uint timestamp);
2496     bytes32 constant PRICEUPDATED_SIG = keccak256("PriceUpdated(uint256,uint256)");
2497     function emitPriceUpdated(uint newPrice, uint timestamp) internal {
2498         proxy._emit(abi.encode(newPrice, timestamp), 1, PRICEUPDATED_SIG, 0, 0, 0);
2499     }
2500  
2501     event IssuanceRatioUpdated(uint newRatio);
2502     bytes32 constant ISSUANCERATIOUPDATED_SIG = keccak256("IssuanceRatioUpdated(uint256)");
2503     function emitIssuanceRatioUpdated(uint newRatio) internal {
2504         proxy._emit(abi.encode(newRatio), 1, ISSUANCERATIOUPDATED_SIG, 0, 0, 0);
2505     }
2506  
2507     event FeePeriodRollover(uint timestamp);
2508     bytes32 constant FEEPERIODROLLOVER_SIG = keccak256("FeePeriodRollover(uint256)");
2509     function emitFeePeriodRollover(uint timestamp) internal {
2510         proxy._emit(abi.encode(timestamp), 1, FEEPERIODROLLOVER_SIG, 0, 0, 0);
2511     }
2512  
2513     event FeePeriodDurationUpdated(uint duration);
2514     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
2515     function emitFeePeriodDurationUpdated(uint duration) internal {
2516         proxy._emit(abi.encode(duration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
2517     }
2518  
2519     event FeesWithdrawn(address indexed account, uint value);
2520     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
2521     function emitFeesWithdrawn(address account, uint value) internal {
2522         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
2523     }
2524  
2525     event OracleUpdated(address newOracle);
2526     bytes32 constant ORACLEUPDATED_SIG = keccak256("OracleUpdated(address)");
2527     function emitOracleUpdated(address newOracle) internal {
2528         proxy._emit(abi.encode(newOracle), 1, ORACLEUPDATED_SIG, 0, 0, 0);
2529     }
2530  
2531     event NominUpdated(address newNomin);
2532     bytes32 constant NOMINUPDATED_SIG = keccak256("NominUpdated(address)");
2533     function emitNominUpdated(address newNomin) internal {
2534         proxy._emit(abi.encode(newNomin), 1, NOMINUPDATED_SIG, 0, 0, 0);
2535     }
2536  
2537     event EscrowUpdated(address newEscrow);
2538     bytes32 constant ESCROWUPDATED_SIG = keccak256("EscrowUpdated(address)");
2539     function emitEscrowUpdated(address newEscrow) internal {
2540         proxy._emit(abi.encode(newEscrow), 1, ESCROWUPDATED_SIG, 0, 0, 0);
2541     }
2542  
2543     event IssuersUpdated(address indexed account, bool indexed value);
2544     bytes32 constant ISSUERSUPDATED_SIG = keccak256("IssuersUpdated(address,bool)");
2545     function emitIssuersUpdated(address account, bool value) internal {
2546         proxy._emit(abi.encode(), 3, ISSUERSUPDATED_SIG, bytes32(account), bytes32(value ? 1 : 0), 0);
2547     }
2548  
2549 }
2550  
2551  
2552 /*
2553 -----------------------------------------------------------------
2554 FILE INFORMATION
2555 -----------------------------------------------------------------
2556  
2557 file:       Court.sol
2558 version:    1.2
2559 author:     Anton Jurisevic
2560             Mike Spain
2561             Dominic Romanowski
2562  
2563 date:       2018-05-29
2564  
2565 -----------------------------------------------------------------
2566 MODULE DESCRIPTION
2567 -----------------------------------------------------------------
2568  
2569 This provides the nomin contract with a confiscation
2570 facility, if enough havven owners vote to confiscate a target
2571 account's nomins.
2572  
2573 This is designed to provide a mechanism to respond to abusive
2574 contracts such as nomin wrappers, which would allow users to
2575 trade wrapped nomins without accruing fees on those transactions.
2576  
2577 In order to prevent tyranny, an account may only be frozen if
2578 users controlling at least 30% of the value of havvens participate,
2579 and a two thirds majority is attained in that vote.
2580 In order to prevent tyranny of the majority or mob justice,
2581 confiscation motions are only approved if the havven foundation
2582 approves the result.
2583 This latter requirement may be lifted in future versions.
2584  
2585 The foundation, or any user with a sufficient havven balance may
2586 bring a confiscation motion.
2587 A motion lasts for a default period of one week, with a further
2588 confirmation period in which the foundation approves the result.
2589 The latter period may conclude early upon the foundation's decision
2590 to either veto or approve the mooted confiscation motion.
2591 If the confirmation period elapses without the foundation making
2592 a decision, the motion fails.
2593  
2594 The weight of a havven holder's vote is determined by examining
2595 their average balance over the last completed fee period prior to
2596 the beginning of a given motion.
2597  
2598 Thus, since a fee period can roll over in the middle of a motion,
2599 we must also track a user's average balance of the last two periods.
2600 This system is designed such that it cannot be attacked by users
2601 transferring funds between themselves, while also not requiring them
2602 to lock their havvens for the duration of the vote. This is possible
2603 since any transfer that increases the average balance in one account
2604 will be reflected by an equivalent reduction in the voting weight in
2605 the other.
2606  
2607 At present a user may cast a vote only for one motion at a time,
2608 but may cancel their vote at any time except during the confirmation period,
2609 when the vote tallies must remain static until the matter has been settled.
2610  
2611 A motion to confiscate the balance of a given address composes
2612 a state machine built of the following states:
2613  
2614 Waiting:
2615   - A user with standing brings a motion:
2616     If the target address is not frozen;
2617     initialise vote tallies to 0;
2618     transition to the Voting state.
2619  
2620   - An account cancels a previous residual vote:
2621     remain in the Waiting state.
2622  
2623 Voting:
2624   - The foundation vetoes the in-progress motion:
2625     transition to the Waiting state.
2626  
2627   - The voting period elapses:
2628     transition to the Confirmation state.
2629  
2630   - An account votes (for or against the motion):
2631     its weight is added to the appropriate tally;
2632     remain in the Voting state.
2633  
2634   - An account cancels its previous vote:
2635     its weight is deducted from the appropriate tally (if any);
2636     remain in the Voting state.
2637  
2638 Confirmation:
2639   - The foundation vetoes the completed motion:
2640     transition to the Waiting state.
2641  
2642   - The foundation approves confiscation of the target account:
2643     freeze the target account, transfer its nomin balance to the fee pool;
2644     transition to the Waiting state.
2645  
2646   - The confirmation period elapses:
2647     transition to the Waiting state.
2648  
2649 User votes are not automatically cancelled upon the conclusion of a motion.
2650 Therefore, after a motion comes to a conclusion, if a user wishes to vote
2651 in another motion, they must manually cancel their vote in order to do so.
2652  
2653 This procedure is designed to be relatively simple.
2654 There are some things that can be added to enhance the functionality
2655 at the expense of simplicity and efficiency:
2656  
2657   - Democratic unfreezing of nomin accounts (induces multiple categories of vote)
2658   - Configurable per-vote durations;
2659   - Vote standing denominated in a fiat quantity rather than a quantity of havvens;
2660   - Confiscate from multiple addresses in a single vote;
2661  
2662 We might consider updating the contract with any of these features at a later date if necessary.
2663  
2664 -----------------------------------------------------------------
2665 */
2666  
2667  
2668 /**
2669  * @title A court contract allowing a democratic mechanism to dissuade token wrappers.
2670  */
2671 contract Court is SafeDecimalMath, Owned {
2672  
2673     /* ========== STATE VARIABLES ========== */
2674  
2675     /* The addresses of the token contracts this confiscation court interacts with. */
2676     Havven public havven;
2677     Nomin public nomin;
2678  
2679     /* The minimum issued nomin balance required to be considered to have
2680      * standing to begin confiscation proceedings. */
2681     uint public minStandingBalance = 100 * UNIT;
2682  
2683     /* The voting period lasts for this duration,
2684      * and if set, must fall within the given bounds. */
2685     uint public votingPeriod = 1 weeks;
2686     uint constant MIN_VOTING_PERIOD = 3 days;
2687     uint constant MAX_VOTING_PERIOD = 4 weeks;
2688  
2689     /* Duration of the period during which the foundation may confirm
2690      * or veto a motion that has concluded.
2691      * If set, the confirmation duration must fall within the given bounds. */
2692     uint public confirmationPeriod = 1 weeks;
2693     uint constant MIN_CONFIRMATION_PERIOD = 1 days;
2694     uint constant MAX_CONFIRMATION_PERIOD = 2 weeks;
2695  
2696     /* No fewer than this fraction of total available voting power must
2697      * participate in a motion in order for a quorum to be reached.
2698      * The participation fraction required may be set no lower than 10%.
2699      * As a fraction, it is expressed in terms of UNIT, not as an absolute quantity. */
2700     uint public requiredParticipation = 3 * UNIT / 10;
2701     uint constant MIN_REQUIRED_PARTICIPATION = UNIT / 10;
2702  
2703     /* At least this fraction of participating votes must be in favour of
2704      * confiscation for the motion to pass.
2705      * The required majority may be no lower than 50%.
2706      * As a fraction, it is expressed in terms of UNIT, not as an absolute quantity. */
2707     uint public requiredMajority = (2 * UNIT) / 3;
2708     uint constant MIN_REQUIRED_MAJORITY = UNIT / 2;
2709  
2710     /* The next ID to use for opening a motion.
2711      * The 0 motion ID corresponds to no motion,
2712      * and is used as a null value for later comparison. */
2713     uint nextMotionID = 1;
2714  
2715     /* Mapping from motion IDs to target addresses. */
2716     mapping(uint => address) public motionTarget;
2717  
2718     /* The ID a motion on an address is currently operating at.
2719      * Zero if no such motion is running. */
2720     mapping(address => uint) public targetMotionID;
2721  
2722     /* The timestamp at which a motion began. This is used to determine
2723      * whether a motion is: running, in the confirmation period,
2724      * or has concluded.
2725      * A motion runs from its start time t until (t + votingPeriod),
2726      * and then the confirmation period terminates no later than
2727      * (t + votingPeriod + confirmationPeriod). */
2728     mapping(uint => uint) public motionStartTime;
2729  
2730     /* The tallies for and against confiscation of a given balance.
2731      * These are set to zero at the start of a motion, and also on conclusion,
2732      * just to keep the state clean. */
2733     mapping(uint => uint) public votesFor;
2734     mapping(uint => uint) public votesAgainst;
2735  
2736     /* The last average balance of a user at the time they voted
2737      * in a particular motion.
2738      * If we did not save this information then we would have to
2739      * disallow transfers into an account lest it cancel a vote
2740      * with greater weight than that with which it originally voted,
2741      * and the fee period rolled over in between. */
2742     // TODO: This may be unnecessary now that votes are forced to be
2743     // within a fee period. Likely possible to delete this.
2744     mapping(address => mapping(uint => uint)) voteWeight;
2745  
2746     /* The possible vote types.
2747      * Abstention: not participating in a motion; This is the default value.
2748      * Yea: voting in favour of a motion.
2749      * Nay: voting against a motion. */
2750     enum Vote {Abstention, Yea, Nay}
2751  
2752     /* A given account's vote in some confiscation motion.
2753      * This requires the default value of the Vote enum to correspond to an abstention. */
2754     mapping(address => mapping(uint => Vote)) public vote;
2755  
2756  
2757     /* ========== CONSTRUCTOR ========== */
2758  
2759     /**
2760      * @dev Court Constructor.
2761      */
2762     constructor(Havven _havven, Nomin _nomin, address _owner)
2763         Owned(_owner)
2764         public
2765     {
2766         havven = _havven;
2767         nomin = _nomin;
2768     }
2769  
2770  
2771     /* ========== SETTERS ========== */
2772  
2773     /**
2774      * @notice Set the minimum required havven balance to have standing to bring a motion.
2775      * @dev Only the contract owner may call this.
2776      */
2777     function setMinStandingBalance(uint balance)
2778         external
2779         onlyOwner
2780     {
2781         /* No requirement on the standing threshold here;
2782          * the foundation can set this value such that
2783          * anyone or no one can actually start a motion. */
2784         minStandingBalance = balance;
2785     }
2786  
2787     /**
2788      * @notice Set the length of time a vote runs for.
2789      * @dev Only the contract owner may call this. The proposed duration must fall
2790      * within sensible bounds (3 days to 4 weeks), and must be no longer than a single fee period.
2791      */
2792     function setVotingPeriod(uint duration)
2793         external
2794         onlyOwner
2795     {
2796         require(MIN_VOTING_PERIOD <= duration &&
2797                 duration <= MAX_VOTING_PERIOD);
2798         /* Require that the voting period is no longer than a single fee period,
2799          * So that a single vote can span at most two fee periods. */
2800         require(duration <= havven.feePeriodDuration());
2801         votingPeriod = duration;
2802     }
2803  
2804     /**
2805      * @notice Set the confirmation period after a vote has concluded.
2806      * @dev Only the contract owner may call this. The proposed duration must fall
2807      * within sensible bounds (1 day to 2 weeks).
2808      */
2809     function setConfirmationPeriod(uint duration)
2810         external
2811         onlyOwner
2812     {
2813         require(MIN_CONFIRMATION_PERIOD <= duration &&
2814                 duration <= MAX_CONFIRMATION_PERIOD);
2815         confirmationPeriod = duration;
2816     }
2817  
2818     /**
2819      * @notice Set the required fraction of all Havvens that need to be part of
2820      * a vote for it to pass.
2821      */
2822     function setRequiredParticipation(uint fraction)
2823         external
2824         onlyOwner
2825     {
2826         require(MIN_REQUIRED_PARTICIPATION <= fraction);
2827         requiredParticipation = fraction;
2828     }
2829  
2830     /**
2831      * @notice Set what portion of voting havvens need to be in the affirmative
2832      * to allow it to pass.
2833      */
2834     function setRequiredMajority(uint fraction)
2835         external
2836         onlyOwner
2837     {
2838         require(MIN_REQUIRED_MAJORITY <= fraction);
2839         requiredMajority = fraction;
2840     }
2841  
2842  
2843     /* ========== VIEW FUNCTIONS ========== */
2844  
2845     /**
2846      * @notice There is a motion in progress on the specified
2847      * account, and votes are being accepted in that motion.
2848      */
2849     function motionVoting(uint motionID)
2850         public
2851         view
2852         returns (bool)
2853     {
2854         return motionStartTime[motionID] < now && now < motionStartTime[motionID] + votingPeriod;
2855     }
2856  
2857     /**
2858      * @notice A vote on the target account has concluded, but the motion
2859      * has not yet been approved, vetoed, or closed. */
2860     function motionConfirming(uint motionID)
2861         public
2862         view
2863         returns (bool)
2864     {
2865         /* These values are timestamps, they will not overflow
2866          * as they can only ever be initialised to relatively small values.
2867          */
2868         uint startTime = motionStartTime[motionID];
2869         return startTime + votingPeriod <= now &&
2870                now < startTime + votingPeriod + confirmationPeriod;
2871     }
2872  
2873     /**
2874      * @notice A vote motion either not begun, or it has completely terminated.
2875      */
2876     function motionWaiting(uint motionID)
2877         public
2878         view
2879         returns (bool)
2880     {
2881         /* These values are timestamps, they will not overflow
2882          * as they can only ever be initialised to relatively small values. */
2883         return motionStartTime[motionID] + votingPeriod + confirmationPeriod <= now;
2884     }
2885  
2886     /**
2887      * @notice If the motion was to terminate at this instant, it would pass.
2888      * That is: there was sufficient participation and a sizeable enough majority.
2889      */
2890     function motionPasses(uint motionID)
2891         public
2892         view
2893         returns (bool)
2894     {
2895         uint yeas = votesFor[motionID];
2896         uint nays = votesAgainst[motionID];
2897         uint totalVotes = safeAdd(yeas, nays);
2898  
2899         if (totalVotes == 0) {
2900             return false;
2901         }
2902  
2903         uint participation = safeDiv_dec(totalVotes, havven.totalIssuanceLastAverageBalance());
2904         uint fractionInFavour = safeDiv_dec(yeas, totalVotes);
2905  
2906         /* We require the result to be strictly greater than the requirement
2907          * to enforce a majority being "50% + 1", and so on. */
2908         return participation > requiredParticipation &&
2909                fractionInFavour > requiredMajority;
2910     }
2911  
2912     /**
2913      * @notice Return if the specified account has voted on the specified motion
2914      */
2915     function hasVoted(address account, uint motionID)
2916         public
2917         view
2918         returns (bool)
2919     {
2920         return vote[account][motionID] != Vote.Abstention;
2921     }
2922  
2923  
2924     /* ========== MUTATIVE FUNCTIONS ========== */
2925  
2926     /**
2927      * @notice Begin a motion to confiscate the funds in a given nomin account.
2928      * @dev Only the foundation, or accounts with sufficient havven balances
2929      * may elect to start such a motion.
2930      * @return Returns the ID of the motion that was begun.
2931      */
2932     function beginMotion(address target)
2933         external
2934         returns (uint)
2935     {
2936         /* A confiscation motion must be mooted by someone with standing. */
2937         require((havven.issuanceLastAverageBalance(msg.sender) >= minStandingBalance) ||
2938                 msg.sender == owner);
2939  
2940         /* Require that the voting period is longer than a single fee period,
2941          * So that a single vote can span at most two fee periods. */
2942         require(votingPeriod <= havven.feePeriodDuration());
2943  
2944         /* There must be no confiscation motion already running for this account. */
2945         require(targetMotionID[target] == 0);
2946  
2947         /* Disallow votes on accounts that are currently frozen. */
2948         require(!nomin.frozen(target));
2949  
2950         /* It is necessary to roll over the fee period if it has elapsed, or else
2951          * the vote might be initialised having begun in the past. */
2952         havven.rolloverFeePeriodIfElapsed();
2953  
2954         uint motionID = nextMotionID++;
2955         motionTarget[motionID] = target;
2956         targetMotionID[target] = motionID;
2957  
2958         /* Start the vote at the start of the next fee period */
2959         uint startTime = havven.feePeriodStartTime() + havven.feePeriodDuration();
2960         motionStartTime[motionID] = startTime;
2961         emit MotionBegun(msg.sender, target, motionID, startTime);
2962  
2963         return motionID;
2964     }
2965  
2966     /**
2967      * @notice Shared vote setup function between voteFor and voteAgainst.
2968      * @return Returns the voter's vote weight. */
2969     function setupVote(uint motionID)
2970         internal
2971         returns (uint)
2972     {
2973         /* There must be an active vote for this target running.
2974          * Vote totals must only change during the voting phase. */
2975         require(motionVoting(motionID));
2976  
2977         /* The voter must not have an active vote this motion. */
2978         require(!hasVoted(msg.sender, motionID));
2979  
2980         /* The voter may not cast votes on themselves. */
2981         require(msg.sender != motionTarget[motionID]);
2982  
2983         uint weight = havven.recomputeLastAverageBalance(msg.sender);
2984  
2985         /* Users must have a nonzero voting weight to vote. */
2986         require(weight > 0);
2987  
2988         voteWeight[msg.sender][motionID] = weight;
2989  
2990         return weight;
2991     }
2992  
2993     /**
2994      * @notice The sender casts a vote in favour of confiscation of the
2995      * target account's nomin balance.
2996      */
2997     function voteFor(uint motionID)
2998         external
2999     {
3000         uint weight = setupVote(motionID);
3001         vote[msg.sender][motionID] = Vote.Yea;
3002         votesFor[motionID] = safeAdd(votesFor[motionID], weight);
3003         emit VotedFor(msg.sender, motionID, weight);
3004     }
3005  
3006     /**
3007      * @notice The sender casts a vote against confiscation of the
3008      * target account's nomin balance.
3009      */
3010     function voteAgainst(uint motionID)
3011         external
3012     {
3013         uint weight = setupVote(motionID);
3014         vote[msg.sender][motionID] = Vote.Nay;
3015         votesAgainst[motionID] = safeAdd(votesAgainst[motionID], weight);
3016         emit VotedAgainst(msg.sender, motionID, weight);
3017     }
3018  
3019     /**
3020      * @notice Cancel an existing vote by the sender on a motion
3021      * to confiscate the target balance.
3022      */
3023     function cancelVote(uint motionID)
3024         external
3025     {
3026         /* An account may cancel its vote either before the confirmation phase
3027          * when the motion is still open, or after the confirmation phase,
3028          * when the motion has concluded.
3029          * But the totals must not change during the confirmation phase itself. */
3030         require(!motionConfirming(motionID));
3031  
3032         Vote senderVote = vote[msg.sender][motionID];
3033  
3034         /* If the sender has not voted then there is no need to update anything. */
3035         require(senderVote != Vote.Abstention);
3036  
3037         /* If we are not voting, there is no reason to update the vote totals. */
3038         if (motionVoting(motionID)) {
3039             if (senderVote == Vote.Yea) {
3040                 votesFor[motionID] = safeSub(votesFor[motionID], voteWeight[msg.sender][motionID]);
3041             } else {
3042                 /* Since we already ensured that the vote is not an abstention,
3043                  * the only option remaining is Vote.Nay. */
3044                 votesAgainst[motionID] = safeSub(votesAgainst[motionID], voteWeight[msg.sender][motionID]);
3045             }
3046             /* A cancelled vote is only meaningful if a vote is running. */
3047             emit VoteCancelled(msg.sender, motionID);
3048         }
3049  
3050         delete voteWeight[msg.sender][motionID];
3051         delete vote[msg.sender][motionID];
3052     }
3053  
3054     /**
3055      * @notice clear all data associated with a motionID for hygiene purposes.
3056      */
3057     function _closeMotion(uint motionID)
3058         internal
3059     {
3060         delete targetMotionID[motionTarget[motionID]];
3061         delete motionTarget[motionID];
3062         delete motionStartTime[motionID];
3063         delete votesFor[motionID];
3064         delete votesAgainst[motionID];
3065         emit MotionClosed(motionID);
3066     }
3067  
3068     /**
3069      * @notice If a motion has concluded, or if it lasted its full duration but not passed,
3070      * then anyone may close it.
3071      */
3072     function closeMotion(uint motionID)
3073         external
3074     {
3075         require((motionConfirming(motionID) && !motionPasses(motionID)) || motionWaiting(motionID));
3076         _closeMotion(motionID);
3077     }
3078  
3079     /**
3080      * @notice The foundation may only confiscate a balance during the confirmation
3081      * period after a motion has passed.
3082      */
3083     function approveMotion(uint motionID)
3084         external
3085         onlyOwner
3086     {
3087         require(motionConfirming(motionID) && motionPasses(motionID));
3088         address target = motionTarget[motionID];
3089         nomin.freezeAndConfiscate(target);
3090         _closeMotion(motionID);
3091         emit MotionApproved(motionID);
3092     }
3093  
3094     /* @notice The foundation may veto a motion at any time. */
3095     function vetoMotion(uint motionID)
3096         external
3097         onlyOwner
3098     {
3099         require(!motionWaiting(motionID));
3100         _closeMotion(motionID);
3101         emit MotionVetoed(motionID);
3102     }
3103  
3104  
3105     /* ========== EVENTS ========== */
3106  
3107     event MotionBegun(address indexed initiator, address indexed target, uint indexed motionID, uint startTime);
3108  
3109     event VotedFor(address indexed voter, uint indexed motionID, uint weight);
3110  
3111     event VotedAgainst(address indexed voter, uint indexed motionID, uint weight);
3112  
3113     event VoteCancelled(address indexed voter, uint indexed motionID);
3114  
3115     event MotionClosed(uint indexed motionID);
3116  
3117     event MotionVetoed(uint indexed motionID);
3118  
3119     event MotionApproved(uint indexed motionID);
3120 }
3121  
3122  
3123 /*
3124 -----------------------------------------------------------------
3125 FILE INFORMATION
3126 -----------------------------------------------------------------
3127  
3128 file:       Nomin.sol
3129 version:    1.2
3130 author:     Anton Jurisevic
3131             Mike Spain
3132             Dominic Romanowski
3133             Kevin Brown
3134  
3135 date:       2018-05-29
3136  
3137 -----------------------------------------------------------------
3138 MODULE DESCRIPTION
3139 -----------------------------------------------------------------
3140  
3141 Havven-backed nomin stablecoin contract.
3142  
3143 This contract issues nomins, which are tokens worth 1 USD each.
3144  
3145 Nomins are issuable by Havven holders who have to lock up some
3146 value of their havvens to issue H * Cmax nomins. Where Cmax is
3147 some value less than 1.
3148  
3149 A configurable fee is charged on nomin transfers and deposited
3150 into a common pot, which havven holders may withdraw from once
3151 per fee period.
3152  
3153 -----------------------------------------------------------------
3154 */
3155  
3156  
3157 contract Nomin is FeeToken {
3158  
3159     /* ========== STATE VARIABLES ========== */
3160  
3161     // The address of the contract which manages confiscation votes.
3162     Court public court;
3163     Havven public havven;
3164  
3165     // Accounts which have lost the privilege to transact in nomins.
3166     mapping(address => bool) public frozen;
3167  
3168     // Nomin transfers incur a 15 bp fee by default.
3169     uint constant TRANSFER_FEE_RATE = 15 * UNIT / 10000;
3170     string constant TOKEN_NAME = "Nomin USD";
3171     string constant TOKEN_SYMBOL = "nUSD";
3172  
3173     /* ========== CONSTRUCTOR ========== */
3174  
3175     constructor(address _proxy, TokenState _tokenState, Havven _havven,
3176                 uint _totalSupply,
3177                 address _owner)
3178         FeeToken(_proxy, _tokenState,
3179                  TOKEN_NAME, TOKEN_SYMBOL, _totalSupply,
3180                  TRANSFER_FEE_RATE,
3181                  _havven, // The havven contract is the fee authority.
3182                  _owner)
3183         public
3184     {
3185         require(_proxy != 0 && address(_havven) != 0 && _owner != 0);
3186         // It should not be possible to transfer to the fee pool directly (or confiscate its balance).
3187         frozen[FEE_ADDRESS] = true;
3188         havven = _havven;
3189     }
3190  
3191     /* ========== SETTERS ========== */
3192  
3193     function setCourt(Court _court)
3194         external
3195         optionalProxy_onlyOwner
3196     {
3197         court = _court;
3198         emitCourtUpdated(_court);
3199     }
3200  
3201     function setHavven(Havven _havven)
3202         external
3203         optionalProxy_onlyOwner
3204     {
3205         // havven should be set as the feeAuthority after calling this depending on
3206         // havven's internal logic
3207         havven = _havven;
3208         setFeeAuthority(_havven);
3209         emitHavvenUpdated(_havven);
3210     }
3211  
3212  
3213     /* ========== MUTATIVE FUNCTIONS ========== */
3214  
3215     /* Override ERC20 transfer function in order to check
3216      * whether the recipient account is frozen. Note that there is
3217      * no need to check whether the sender has a frozen account,
3218      * since their funds have already been confiscated,
3219      * and no new funds can be transferred to it.*/
3220     function transfer(address to, uint value)
3221         public
3222         optionalProxy
3223         returns (bool)
3224     {
3225         require(!frozen[to]);
3226         return _transfer_byProxy(messageSender, to, value);
3227     }
3228  
3229     /* Override ERC20 transferFrom function in order to check
3230      * whether the recipient account is frozen. */
3231     function transferFrom(address from, address to, uint value)
3232         public
3233         optionalProxy
3234         returns (bool)
3235     {
3236         require(!frozen[to]);
3237         return _transferFrom_byProxy(messageSender, from, to, value);
3238     }
3239  
3240     function transferSenderPaysFee(address to, uint value)
3241         public
3242         optionalProxy
3243         returns (bool)
3244     {
3245         require(!frozen[to]);
3246         return _transferSenderPaysFee_byProxy(messageSender, to, value);
3247     }
3248  
3249     function transferFromSenderPaysFee(address from, address to, uint value)
3250         public
3251         optionalProxy
3252         returns (bool)
3253     {
3254         require(!frozen[to]);
3255         return _transferFromSenderPaysFee_byProxy(messageSender, from, to, value);
3256     }
3257  
3258     /* If a confiscation court motion has passed and reached the confirmation
3259      * state, the court may transfer the target account's balance to the fee pool
3260      * and freeze its participation in further transactions. */
3261     function freezeAndConfiscate(address target)
3262         external
3263         onlyCourt
3264     {
3265          
3266         // A motion must actually be underway.
3267         uint motionID = court.targetMotionID(target);
3268         require(motionID != 0);
3269  
3270         // These checks are strictly unnecessary,
3271         // since they are already checked in the court contract itself.
3272         require(court.motionConfirming(motionID));
3273         require(court.motionPasses(motionID));
3274         require(!frozen[target]);
3275  
3276         // Confiscate the balance in the account and freeze it.
3277         uint balance = tokenState.balanceOf(target);
3278         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), balance));
3279         tokenState.setBalanceOf(target, 0);
3280         frozen[target] = true;
3281         emitAccountFrozen(target, balance);
3282         emitTransfer(target, FEE_ADDRESS, balance);
3283     }
3284  
3285     /* The owner may allow a previously-frozen contract to once
3286      * again accept and transfer nomins. */
3287     function unfreezeAccount(address target)
3288         external
3289         optionalProxy_onlyOwner
3290     {
3291         require(frozen[target] && target != FEE_ADDRESS);
3292         frozen[target] = false;
3293         emitAccountUnfrozen(target);
3294     }
3295  
3296     /* Allow havven to issue a certain number of
3297      * nomins from an account. */
3298     function issue(address account, uint amount)
3299         external
3300         onlyHavven
3301     {
3302         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), amount));
3303         totalSupply = safeAdd(totalSupply, amount);
3304         emitTransfer(address(0), account, amount);
3305         emitIssued(account, amount);
3306     }
3307  
3308     /* Allow havven to burn a certain number of
3309      * nomins from an account. */
3310     function burn(address account, uint amount)
3311         external
3312         onlyHavven
3313     {
3314         tokenState.setBalanceOf(account, safeSub(tokenState.balanceOf(account), amount));
3315         totalSupply = safeSub(totalSupply, amount);
3316         emitTransfer(account, address(0), amount);
3317         emitBurned(account, amount);
3318     }
3319  
3320     /* ========== MODIFIERS ========== */
3321  
3322     modifier onlyHavven() {
3323         require(Havven(msg.sender) == havven);
3324         _;
3325     }
3326  
3327     modifier onlyCourt() {
3328         require(Court(msg.sender) == court);
3329         _;
3330     }
3331  
3332     /* ========== EVENTS ========== */
3333  
3334     event CourtUpdated(address newCourt);
3335     bytes32 constant COURTUPDATED_SIG = keccak256("CourtUpdated(address)");
3336     function emitCourtUpdated(address newCourt) internal {
3337         proxy._emit(abi.encode(newCourt), 1, COURTUPDATED_SIG, 0, 0, 0);
3338     }
3339  
3340     event HavvenUpdated(address newHavven);
3341     bytes32 constant HAVVENUPDATED_SIG = keccak256("HavvenUpdated(address)");
3342     function emitHavvenUpdated(address newHavven) internal {
3343         proxy._emit(abi.encode(newHavven), 1, HAVVENUPDATED_SIG, 0, 0, 0);
3344     }
3345  
3346     event AccountFrozen(address indexed target, uint balance);
3347     bytes32 constant ACCOUNTFROZEN_SIG = keccak256("AccountFrozen(address,uint256)");
3348     function emitAccountFrozen(address target, uint balance) internal {
3349         proxy._emit(abi.encode(balance), 2, ACCOUNTFROZEN_SIG, bytes32(target), 0, 0);
3350     }
3351  
3352     event AccountUnfrozen(address indexed target);
3353     bytes32 constant ACCOUNTUNFROZEN_SIG = keccak256("AccountUnfrozen(address)");
3354     function emitAccountUnfrozen(address target) internal {
3355         proxy._emit(abi.encode(), 2, ACCOUNTUNFROZEN_SIG, bytes32(target), 0, 0);
3356     }
3357  
3358     event Issued(address indexed account, uint amount);
3359     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
3360     function emitIssued(address account, uint amount) internal {
3361         proxy._emit(abi.encode(amount), 2, ISSUED_SIG, bytes32(account), 0, 0);
3362     }
3363  
3364     event Burned(address indexed account, uint amount);
3365     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
3366     function emitBurned(address account, uint amount) internal {
3367         proxy._emit(abi.encode(amount), 2, BURNED_SIG, bytes32(account), 0, 0);
3368     }
3369 }