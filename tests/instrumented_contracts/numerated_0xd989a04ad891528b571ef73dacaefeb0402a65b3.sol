1 /*
2  * Havven Contract
3  *
4  * The collateral token of the Havven stablecoin system.
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
314  
315 /*
316 -----------------------------------------------------------------
317 FILE INFORMATION
318 -----------------------------------------------------------------
319  
320 file:       SelfDestructible.sol
321 version:    1.2
322 author:     Anton Jurisevic
323  
324 date:       2018-05-29
325  
326 -----------------------------------------------------------------
327 MODULE DESCRIPTION
328 -----------------------------------------------------------------
329  
330 This contract allows an inheriting contract to be destroyed after
331 its owner indicates an intention and then waits for a period
332 without changing their mind. All ether contained in the contract
333 is forwarded to a nominated beneficiary upon destruction.
334  
335 -----------------------------------------------------------------
336 */
337  
338  
339 /**
340  * @title A contract that can be destroyed by its owner after a delay elapses.
341  */
342 contract SelfDestructible is Owned {
343      
344     uint public initiationTime;
345     bool public selfDestructInitiated;
346     address public selfDestructBeneficiary;
347     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
348  
349     /**
350      * @dev Constructor
351      * @param _owner The account which controls this contract.
352      */
353     constructor(address _owner)
354         Owned(_owner)
355         public
356     {
357         require(_owner != address(0));
358         selfDestructBeneficiary = _owner;
359         emit SelfDestructBeneficiaryUpdated(_owner);
360     }
361  
362     /**
363      * @notice Set the beneficiary address of this contract.
364      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
365      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
366      */
367     function setSelfDestructBeneficiary(address _beneficiary)
368         external
369         onlyOwner
370     {
371         require(_beneficiary != address(0));
372         selfDestructBeneficiary = _beneficiary;
373         emit SelfDestructBeneficiaryUpdated(_beneficiary);
374     }
375  
376     /**
377      * @notice Begin the self-destruction counter of this contract.
378      * Once the delay has elapsed, the contract may be self-destructed.
379      * @dev Only the contract owner may call this.
380      */
381     function initiateSelfDestruct()
382         external
383         onlyOwner
384     {
385         initiationTime = now;
386         selfDestructInitiated = true;
387         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
388     }
389  
390     /**
391      * @notice Terminate and reset the self-destruction timer.
392      * @dev Only the contract owner may call this.
393      */
394     function terminateSelfDestruct()
395         external
396         onlyOwner
397     {
398         initiationTime = 0;
399         selfDestructInitiated = false;
400         emit SelfDestructTerminated();
401     }
402  
403     /**
404      * @notice If the self-destruction delay has elapsed, destroy this contract and
405      * remit any ether it owns to the beneficiary address.
406      * @dev Only the contract owner may call this.
407      */
408     function selfDestruct()
409         external
410         onlyOwner
411     {
412         require(selfDestructInitiated && initiationTime + SELFDESTRUCT_DELAY < now);
413         address beneficiary = selfDestructBeneficiary;
414         emit SelfDestructed(beneficiary);
415         selfdestruct(beneficiary);
416     }
417  
418     event SelfDestructTerminated();
419     event SelfDestructed(address beneficiary);
420     event SelfDestructInitiated(uint selfDestructDelay);
421     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
422 }
423  
424  
425 /*
426 -----------------------------------------------------------------
427 FILE INFORMATION
428 -----------------------------------------------------------------
429  
430 file:       State.sol
431 version:    1.1
432 author:     Dominic Romanowski
433             Anton Jurisevic
434  
435 date:       2018-05-15
436  
437 -----------------------------------------------------------------
438 MODULE DESCRIPTION
439 -----------------------------------------------------------------
440  
441 This contract is used side by side with external state token
442 contracts, such as Havven and Nomin.
443 It provides an easy way to upgrade contract logic while
444 maintaining all user balances and allowances. This is designed
445 to make the changeover as easy as possible, since mappings
446 are not so cheap or straightforward to migrate.
447  
448 The first deployed contract would create this state contract,
449 using it as its store of balances.
450 When a new contract is deployed, it links to the existing
451 state contract, whose owner would then change its associated
452 contract to the new one.
453  
454 -----------------------------------------------------------------
455 */
456  
457  
458 contract State is Owned {
459     // the address of the contract that can modify variables
460     // this can only be changed by the owner of this contract
461     address public associatedContract;
462  
463  
464     constructor(address _owner, address _associatedContract)
465         Owned(_owner)
466         public
467     {
468         associatedContract = _associatedContract;
469         emit AssociatedContractUpdated(_associatedContract);
470     }
471  
472     /* ========== SETTERS ========== */
473  
474     // Change the associated contract to a new address
475     function setAssociatedContract(address _associatedContract)
476         external
477         onlyOwner
478     {
479         associatedContract = _associatedContract;
480         emit AssociatedContractUpdated(_associatedContract);
481     }
482  
483     /* ========== MODIFIERS ========== */
484  
485     modifier onlyAssociatedContract
486     {
487         require(msg.sender == associatedContract);
488         _;
489     }
490  
491     /* ========== EVENTS ========== */
492  
493     event AssociatedContractUpdated(address associatedContract);
494 }
495  
496  
497 /*
498 -----------------------------------------------------------------
499 FILE INFORMATION
500 -----------------------------------------------------------------
501  
502 file:       TokenState.sol
503 version:    1.1
504 author:     Dominic Romanowski
505             Anton Jurisevic
506  
507 date:       2018-05-15
508  
509 -----------------------------------------------------------------
510 MODULE DESCRIPTION
511 -----------------------------------------------------------------
512  
513 A contract that holds the state of an ERC20 compliant token.
514  
515 This contract is used side by side with external state token
516 contracts, such as Havven and Nomin.
517 It provides an easy way to upgrade contract logic while
518 maintaining all user balances and allowances. This is designed
519 to make the changeover as easy as possible, since mappings
520 are not so cheap or straightforward to migrate.
521  
522 The first deployed contract would create this state contract,
523 using it as its store of balances.
524 When a new contract is deployed, it links to the existing
525 state contract, whose owner would then change its associated
526 contract to the new one.
527  
528 -----------------------------------------------------------------
529 */
530  
531  
532 /**
533  * @title ERC20 Token State
534  * @notice Stores balance information of an ERC20 token contract.
535  */
536 contract TokenState is State {
537  
538     /* ERC20 fields. */
539     mapping(address => uint) public balanceOf;
540     mapping(address => mapping(address => uint)) public allowance;
541  
542     /**
543      * @dev Constructor
544      * @param _owner The address which controls this contract.
545      * @param _associatedContract The ERC20 contract whose state this composes.
546      */
547     constructor(address _owner, address _associatedContract)
548         State(_owner, _associatedContract)
549         public
550     {}
551  
552     /* ========== SETTERS ========== */
553  
554     /**
555      * @notice Set ERC20 allowance.
556      * @dev Only the associated contract may call this.
557      * @param tokenOwner The authorising party.
558      * @param spender The authorised party.
559      * @param value The total value the authorised party may spend on the
560      * authorising party's behalf.
561      */
562     function setAllowance(address tokenOwner, address spender, uint value)
563         external
564         onlyAssociatedContract
565     {
566         allowance[tokenOwner][spender] = value;
567     }
568  
569     /**
570      * @notice Set the balance in a given account
571      * @dev Only the associated contract may call this.
572      * @param account The account whose value to set.
573      * @param value The new balance of the given account.
574      */
575     function setBalanceOf(address account, uint value)
576         external
577         onlyAssociatedContract
578     {
579         balanceOf[account] = value;
580     }
581 }
582  
583  
584 /*
585 -----------------------------------------------------------------
586 FILE INFORMATION
587 -----------------------------------------------------------------
588  
589 file:       Proxy.sol
590 version:    1.3
591 author:     Anton Jurisevic
592  
593 date:       2018-05-29
594  
595 -----------------------------------------------------------------
596 MODULE DESCRIPTION
597 -----------------------------------------------------------------
598  
599 A proxy contract that, if it does not recognise the function
600 being called on it, passes all value and call data to an
601 underlying target contract.
602  
603 This proxy has the capacity to toggle between DELEGATECALL
604 and CALL style proxy functionality.
605  
606 The former executes in the proxy's context, and so will preserve
607 msg.sender and store data at the proxy address. The latter will not.
608 Therefore, any contract the proxy wraps in the CALL style must
609 implement the Proxyable interface, in order that it can pass msg.sender
610 into the underlying contract as the state parameter, messageSender.
611  
612 -----------------------------------------------------------------
613 */
614  
615  
616 contract Proxy is Owned {
617  
618     Proxyable public target;
619     bool public useDELEGATECALL;
620  
621     constructor(address _owner)
622         Owned(_owner)
623         public
624     {}
625  
626     function setTarget(Proxyable _target)
627         external
628         onlyOwner
629     {
630         target = _target;
631         emit TargetUpdated(_target);
632     }
633  
634     function setUseDELEGATECALL(bool value)
635         external
636         onlyOwner
637     {
638         useDELEGATECALL = value;
639     }
640  
641     function _emit(bytes callData, uint numTopics,
642                    bytes32 topic1, bytes32 topic2,
643                    bytes32 topic3, bytes32 topic4)
644         external
645         onlyTarget
646     {
647         uint size = callData.length;
648         bytes memory _callData = callData;
649  
650         assembly {
651             /* The first 32 bytes of callData contain its length (as specified by the abi).
652              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
653              * in length. It is also leftpadded to be a multiple of 32 bytes.
654              * This means moving call_data across 32 bytes guarantees we correctly access
655              * the data itself. */
656             switch numTopics
657             case 0 {
658                 log0(add(_callData, 32), size)
659             }
660             case 1 {
661                 log1(add(_callData, 32), size, topic1)
662             }
663             case 2 {
664                 log2(add(_callData, 32), size, topic1, topic2)
665             }
666             case 3 {
667                 log3(add(_callData, 32), size, topic1, topic2, topic3)
668             }
669             case 4 {
670                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
671             }
672         }
673     }
674  
675     function()
676         external
677         payable
678     {
679         if (useDELEGATECALL) {
680             assembly {
681                 /* Copy call data into free memory region. */
682                 let free_ptr := mload(0x40)
683                 calldatacopy(free_ptr, 0, calldatasize)
684  
685                 /* Forward all gas and call data to the target contract. */
686                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
687                 returndatacopy(free_ptr, 0, returndatasize)
688  
689                 /* Revert if the call failed, otherwise return the result. */
690                 if iszero(result) { revert(free_ptr, returndatasize) }
691                 return(free_ptr, returndatasize)
692             }
693         } else {
694             /* Here we are as above, but must send the messageSender explicitly
695              * since we are using CALL rather than DELEGATECALL. */
696             target.setMessageSender(msg.sender);
697             assembly {
698                 let free_ptr := mload(0x40)
699                 calldatacopy(free_ptr, 0, calldatasize)
700  
701                 /* We must explicitly forward ether to the underlying contract as well. */
702                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
703                 returndatacopy(free_ptr, 0, returndatasize)
704  
705                 if iszero(result) { revert(free_ptr, returndatasize) }
706                 return(free_ptr, returndatasize)
707             }
708         }
709     }
710  
711     modifier onlyTarget {
712         require(Proxyable(msg.sender) == target);
713         _;
714     }
715  
716     event TargetUpdated(Proxyable newTarget);
717 }
718  
719  
720 /*
721 -----------------------------------------------------------------
722 FILE INFORMATION
723 -----------------------------------------------------------------
724  
725 file:       Proxyable.sol
726 version:    1.1
727 author:     Anton Jurisevic
728  
729 date:       2018-05-15
730  
731 checked:    Mike Spain
732 approved:   Samuel Brooks
733  
734 -----------------------------------------------------------------
735 MODULE DESCRIPTION
736 -----------------------------------------------------------------
737  
738 A proxyable contract that works hand in hand with the Proxy contract
739 to allow for anyone to interact with the underlying contract both
740 directly and through the proxy.
741  
742 -----------------------------------------------------------------
743 */
744  
745  
746 // This contract should be treated like an abstract contract
747 contract Proxyable is Owned {
748     /* The proxy this contract exists behind. */
749     Proxy public proxy;
750  
751     /* The caller of the proxy, passed through to this contract.
752      * Note that every function using this member must apply the onlyProxy or
753      * optionalProxy modifiers, otherwise their invocations can use stale values. */
754     address messageSender;
755  
756     constructor(address _proxy, address _owner)
757         Owned(_owner)
758         public
759     {
760         proxy = Proxy(_proxy);
761         emit ProxyUpdated(_proxy);
762     }
763  
764     function setProxy(address _proxy)
765         external
766         onlyOwner
767     {
768         proxy = Proxy(_proxy);
769         emit ProxyUpdated(_proxy);
770     }
771  
772     function setMessageSender(address sender)
773         external
774         onlyProxy
775     {
776         messageSender = sender;
777     }
778  
779     modifier onlyProxy {
780         require(Proxy(msg.sender) == proxy);
781         _;
782     }
783  
784     modifier optionalProxy
785     {
786         if (Proxy(msg.sender) != proxy) {
787             messageSender = msg.sender;
788         }
789         _;
790     }
791  
792     modifier optionalProxy_onlyOwner
793     {
794         if (Proxy(msg.sender) != proxy) {
795             messageSender = msg.sender;
796         }
797         require(messageSender == owner);
798         _;
799     }
800  
801     event ProxyUpdated(address proxyAddress);
802 }
803  
804  
805 /*
806 -----------------------------------------------------------------
807 FILE INFORMATION
808 -----------------------------------------------------------------
809  
810 file:       ExternStateToken.sol
811 version:    1.3
812 author:     Anton Jurisevic
813             Dominic Romanowski
814  
815 date:       2018-05-29
816  
817 -----------------------------------------------------------------
818 MODULE DESCRIPTION
819 -----------------------------------------------------------------
820  
821 A partial ERC20 token contract, designed to operate with a proxy.
822 To produce a complete ERC20 token, transfer and transferFrom
823 tokens must be implemented, using the provided _byProxy internal
824 functions.
825 This contract utilises an external state for upgradeability.
826  
827 -----------------------------------------------------------------
828 */
829  
830  
831 /**
832  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
833  */
834 contract ExternStateToken is SafeDecimalMath, SelfDestructible, Proxyable {
835  
836     /* ========== STATE VARIABLES ========== */
837  
838     /* Stores balances and allowances. */
839     TokenState public tokenState;
840  
841     /* Other ERC20 fields.
842      * Note that the decimals field is defined in SafeDecimalMath.*/
843     string public name;
844     string public symbol;
845     uint public totalSupply;
846  
847     /**
848      * @dev Constructor.
849      * @param _proxy The proxy associated with this contract.
850      * @param _name Token's ERC20 name.
851      * @param _symbol Token's ERC20 symbol.
852      * @param _totalSupply The total supply of the token.
853      * @param _tokenState The TokenState contract address.
854      * @param _owner The owner of this contract.
855      */
856     constructor(address _proxy, TokenState _tokenState,
857                 string _name, string _symbol, uint _totalSupply,
858                 address _owner)
859         SelfDestructible(_owner)
860         Proxyable(_proxy, _owner)
861         public
862     {
863         name = _name;
864         symbol = _symbol;
865         totalSupply = _totalSupply;
866         tokenState = _tokenState;
867    }
868  
869     /* ========== VIEWS ========== */
870  
871     /**
872      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
873      * @param owner The party authorising spending of their funds.
874      * @param spender The party spending tokenOwner's funds.
875      */
876     function allowance(address owner, address spender)
877         public
878         view
879         returns (uint)
880     {
881         return tokenState.allowance(owner, spender);
882     }
883  
884     /**
885      * @notice Returns the ERC20 token balance of a given account.
886      */
887     function balanceOf(address account)
888         public
889         view
890         returns (uint)
891     {
892         return tokenState.balanceOf(account);
893     }
894  
895     /* ========== MUTATIVE FUNCTIONS ========== */
896  
897     /**
898      * @notice Set the address of the TokenState contract.
899      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
900      * as balances would be unreachable.
901      */
902     function setTokenState(TokenState _tokenState)
903         external
904         optionalProxy_onlyOwner
905     {
906         tokenState = _tokenState;
907         emitTokenStateUpdated(_tokenState);
908     }
909  
910     function _internalTransfer(address from, address to, uint value)
911         internal
912         returns (bool)
913     {
914         /* Disallow transfers to irretrievable-addresses. */
915         require(to != address(0));
916         require(to != address(this));
917         require(to != address(proxy));
918  
919         /* Insufficient balance will be handled by the safe subtraction. */
920         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), value));
921         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), value));
922  
923         emitTransfer(from, to, value);
924  
925         return true;
926     }
927  
928     /**
929      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
930      * the onlyProxy or optionalProxy modifiers.
931      */
932     function _transfer_byProxy(address from, address to, uint value)
933         internal
934         returns (bool)
935     {
936         return _internalTransfer(from, to, value);
937     }
938  
939     /**
940      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
941      * possessing the optionalProxy or optionalProxy modifiers.
942      */
943     function _transferFrom_byProxy(address sender, address from, address to, uint value)
944         internal
945         returns (bool)
946     {
947         /* Insufficient allowance will be handled by the safe subtraction. */
948         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
949         return _internalTransfer(from, to, value);
950     }
951  
952     /**
953      * @notice Approves spender to transfer on the message sender's behalf.
954      */
955     function approve(address spender, uint value)
956         public
957         optionalProxy
958         returns (bool)
959     {
960         address sender = messageSender;
961  
962         tokenState.setAllowance(sender, spender, value);
963         emitApproval(sender, spender, value);
964         return true;
965     }
966  
967     /* ========== EVENTS ========== */
968  
969     event Transfer(address indexed from, address indexed to, uint value);
970     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
971     function emitTransfer(address from, address to, uint value) internal {
972         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
973     }
974  
975     event Approval(address indexed owner, address indexed spender, uint value);
976     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
977     function emitApproval(address owner, address spender, uint value) internal {
978         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
979     }
980  
981     event TokenStateUpdated(address newTokenState);
982     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
983     function emitTokenStateUpdated(address newTokenState) internal {
984         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
985     }
986 }
987  
988  
989 /*
990 -----------------------------------------------------------------
991 FILE INFORMATION
992 -----------------------------------------------------------------
993  
994 file:       FeeToken.sol
995 version:    1.3
996 author:     Anton Jurisevic
997             Dominic Romanowski
998             Kevin Brown
999  
1000 date:       2018-05-29
1001  
1002 -----------------------------------------------------------------
1003 MODULE DESCRIPTION
1004 -----------------------------------------------------------------
1005  
1006 A token which also has a configurable fee rate
1007 charged on its transfers. This is designed to be overridden in
1008 order to produce an ERC20-compliant token.
1009  
1010 These fees accrue into a pool, from which a nominated authority
1011 may withdraw.
1012  
1013 This contract utilises an external state for upgradeability.
1014  
1015 -----------------------------------------------------------------
1016 */
1017  
1018  
1019 /**
1020  * @title ERC20 Token contract, with detached state.
1021  * Additionally charges fees on each transfer.
1022  */
1023 contract FeeToken is ExternStateToken {
1024  
1025     /* ========== STATE VARIABLES ========== */
1026  
1027     /* ERC20 members are declared in ExternStateToken. */
1028  
1029     /* A percentage fee charged on each transfer. */
1030     uint public transferFeeRate;
1031     /* Fee may not exceed 10%. */
1032     uint constant MAX_TRANSFER_FEE_RATE = UNIT / 10;
1033     /* The address with the authority to distribute fees. */
1034     address public feeAuthority;
1035     /* The address that fees will be pooled in. */
1036     address public constant FEE_ADDRESS = 0xfeefeefeefeefeefeefeefeefeefeefeefeefeef;
1037  
1038  
1039     /* ========== CONSTRUCTOR ========== */
1040  
1041     /**
1042      * @dev Constructor.
1043      * @param _proxy The proxy associated with this contract.
1044      * @param _name Token's ERC20 name.
1045      * @param _symbol Token's ERC20 symbol.
1046      * @param _totalSupply The total supply of the token.
1047      * @param _transferFeeRate The fee rate to charge on transfers.
1048      * @param _feeAuthority The address which has the authority to withdraw fees from the accumulated pool.
1049      * @param _owner The owner of this contract.
1050      */
1051     constructor(address _proxy, TokenState _tokenState, string _name, string _symbol, uint _totalSupply,
1052                 uint _transferFeeRate, address _feeAuthority, address _owner)
1053         ExternStateToken(_proxy, _tokenState,
1054                          _name, _symbol, _totalSupply,
1055                          _owner)
1056         public
1057     {
1058         feeAuthority = _feeAuthority;
1059  
1060         /* Constructed transfer fee rate should respect the maximum fee rate. */
1061         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE);
1062         transferFeeRate = _transferFeeRate;
1063     }
1064  
1065     /* ========== SETTERS ========== */
1066  
1067     /**
1068      * @notice Set the transfer fee, anywhere within the range 0-10%.
1069      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1070      */
1071     function setTransferFeeRate(uint _transferFeeRate)
1072         external
1073         optionalProxy_onlyOwner
1074     {
1075         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE);
1076         transferFeeRate = _transferFeeRate;
1077         emitTransferFeeRateUpdated(_transferFeeRate);
1078     }
1079  
1080     /**
1081      * @notice Set the address of the user/contract responsible for collecting or
1082      * distributing fees.
1083      */
1084     function setFeeAuthority(address _feeAuthority)
1085         public
1086         optionalProxy_onlyOwner
1087     {
1088         feeAuthority = _feeAuthority;
1089         emitFeeAuthorityUpdated(_feeAuthority);
1090     }
1091  
1092     /* ========== VIEWS ========== */
1093  
1094     /**
1095      * @notice Calculate the Fee charged on top of a value being sent
1096      * @return Return the fee charged
1097      */
1098     function transferFeeIncurred(uint value)
1099         public
1100         view
1101         returns (uint)
1102     {
1103         return safeMul_dec(value, transferFeeRate);
1104         /* Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
1105          * This is on the basis that transfers less than this value will result in a nil fee.
1106          * Probably too insignificant to worry about, but the following code will achieve it.
1107          *      if (fee == 0 && transferFeeRate != 0) {
1108          *          return _value;
1109          *      }
1110          *      return fee;
1111          */
1112     }
1113  
1114     /**
1115      * @notice The value that you would need to send so that the recipient receives
1116      * a specified value.
1117      */
1118     function transferPlusFee(uint value)
1119         external
1120         view
1121         returns (uint)
1122     {
1123         return safeAdd(value, transferFeeIncurred(value));
1124     }
1125  
1126     /**
1127      * @notice The amount the recipient will receive if you send a certain number of tokens.
1128      */
1129     function amountReceived(uint value)
1130         public
1131         view
1132         returns (uint)
1133     {
1134         return safeDiv_dec(value, safeAdd(UNIT, transferFeeRate));
1135     }
1136  
1137     /**
1138      * @notice Collected fees sit here until they are distributed.
1139      * @dev The balance of the nomin contract itself is the fee pool.
1140      */
1141     function feePool()
1142         external
1143         view
1144         returns (uint)
1145     {
1146         return tokenState.balanceOf(FEE_ADDRESS);
1147     }
1148  
1149     /* ========== MUTATIVE FUNCTIONS ========== */
1150  
1151     /**
1152      * @notice Base of transfer functions
1153      */
1154     function _internalTransfer(address from, address to, uint amount, uint fee)
1155         internal
1156         returns (bool)
1157     {
1158         /* Disallow transfers to irretrievable-addresses. */
1159         require(to != address(0));
1160         require(to != address(this));
1161         require(to != address(proxy));
1162  
1163         /* Insufficient balance will be handled by the safe subtraction. */
1164         tokenState.setBalanceOf(from, safeSub(tokenState.balanceOf(from), safeAdd(amount, fee)));
1165         tokenState.setBalanceOf(to, safeAdd(tokenState.balanceOf(to), amount));
1166         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), fee));
1167  
1168         /* Emit events for both the transfer itself and the fee. */
1169         emitTransfer(from, to, amount);
1170         emitTransfer(from, FEE_ADDRESS, fee);
1171  
1172         return true;
1173     }
1174  
1175     /**
1176      * @notice ERC20 friendly transfer function.
1177      */
1178     function _transfer_byProxy(address sender, address to, uint value)
1179         internal
1180         returns (bool)
1181     {
1182         uint received = amountReceived(value);
1183         uint fee = safeSub(value, received);
1184  
1185         return _internalTransfer(sender, to, received, fee);
1186     }
1187  
1188     /**
1189      * @notice ERC20 friendly transferFrom function.
1190      */
1191     function _transferFrom_byProxy(address sender, address from, address to, uint value)
1192         internal
1193         returns (bool)
1194     {
1195         /* The fee is deducted from the amount sent. */
1196         uint received = amountReceived(value);
1197         uint fee = safeSub(value, received);
1198  
1199         /* Reduce the allowance by the amount we're transferring.
1200          * The safeSub call will handle an insufficient allowance. */
1201         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), value));
1202  
1203         return _internalTransfer(from, to, received, fee);
1204     }
1205  
1206     /**
1207      * @notice Ability to transfer where the sender pays the fees (not ERC20)
1208      */
1209     function _transferSenderPaysFee_byProxy(address sender, address to, uint value)
1210         internal
1211         returns (bool)
1212     {
1213         /* The fee is added to the amount sent. */
1214         uint fee = transferFeeIncurred(value);
1215         return _internalTransfer(sender, to, value, fee);
1216     }
1217  
1218     /**
1219      * @notice Ability to transferFrom where they sender pays the fees (not ERC20).
1220      */
1221     function _transferFromSenderPaysFee_byProxy(address sender, address from, address to, uint value)
1222         internal
1223         returns (bool)
1224     {
1225         /* The fee is added to the amount sent. */
1226         uint fee = transferFeeIncurred(value);
1227         uint total = safeAdd(value, fee);
1228  
1229         /* Reduce the allowance by the amount we're transferring. */
1230         tokenState.setAllowance(from, sender, safeSub(tokenState.allowance(from, sender), total));
1231  
1232         return _internalTransfer(from, to, value, fee);
1233     }
1234  
1235     /**
1236      * @notice Withdraw tokens from the fee pool into a given account.
1237      * @dev Only the fee authority may call this.
1238      */
1239     function withdrawFees(address account, uint value)
1240         external
1241         onlyFeeAuthority
1242         returns (bool)
1243     {
1244         require(account != address(0));
1245  
1246         /* 0-value withdrawals do nothing. */
1247         if (value == 0) {
1248             return false;
1249         }
1250  
1251         /* Safe subtraction ensures an exception is thrown if the balance is insufficient. */
1252         tokenState.setBalanceOf(FEE_ADDRESS, safeSub(tokenState.balanceOf(FEE_ADDRESS), value));
1253         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), value));
1254  
1255         emitFeesWithdrawn(account, value);
1256         emitTransfer(FEE_ADDRESS, account, value);
1257  
1258         return true;
1259     }
1260  
1261     /**
1262      * @notice Donate tokens from the sender's balance into the fee pool.
1263      */
1264     function donateToFeePool(uint n)
1265         external
1266         optionalProxy
1267         returns (bool)
1268     {
1269         address sender = messageSender;
1270         /* Empty donations are disallowed. */
1271         uint balance = tokenState.balanceOf(sender);
1272         require(balance != 0);
1273  
1274         /* safeSub ensures the donor has sufficient balance. */
1275         tokenState.setBalanceOf(sender, safeSub(balance, n));
1276         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), n));
1277  
1278         emitFeesDonated(sender, n);
1279         emitTransfer(sender, FEE_ADDRESS, n);
1280  
1281         return true;
1282     }
1283  
1284  
1285     /* ========== MODIFIERS ========== */
1286  
1287     modifier onlyFeeAuthority
1288     {
1289         require(msg.sender == feeAuthority);
1290         _;
1291     }
1292  
1293  
1294     /* ========== EVENTS ========== */
1295  
1296     event TransferFeeRateUpdated(uint newFeeRate);
1297     bytes32 constant TRANSFERFEERATEUPDATED_SIG = keccak256("TransferFeeRateUpdated(uint256)");
1298     function emitTransferFeeRateUpdated(uint newFeeRate) internal {
1299         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEERATEUPDATED_SIG, 0, 0, 0);
1300     }
1301  
1302     event FeeAuthorityUpdated(address newFeeAuthority);
1303     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
1304     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
1305         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
1306     }
1307  
1308     event FeesWithdrawn(address indexed account, uint value);
1309     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
1310     function emitFeesWithdrawn(address account, uint value) internal {
1311         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
1312     }
1313  
1314     event FeesDonated(address indexed donor, uint value);
1315     bytes32 constant FEESDONATED_SIG = keccak256("FeesDonated(address,uint256)");
1316     function emitFeesDonated(address donor, uint value) internal {
1317         proxy._emit(abi.encode(value), 2, FEESDONATED_SIG, bytes32(donor), 0, 0);
1318     }
1319 }
1320  
1321  
1322 /*
1323 -----------------------------------------------------------------
1324 FILE INFORMATION
1325 -----------------------------------------------------------------
1326  
1327 file:       Court.sol
1328 version:    1.2
1329 author:     Anton Jurisevic
1330             Mike Spain
1331             Dominic Romanowski
1332  
1333 date:       2018-05-29
1334  
1335 -----------------------------------------------------------------
1336 MODULE DESCRIPTION
1337 -----------------------------------------------------------------
1338  
1339 This provides the nomin contract with a confiscation
1340 facility, if enough havven owners vote to confiscate a target
1341 account's nomins.
1342  
1343 This is designed to provide a mechanism to respond to abusive
1344 contracts such as nomin wrappers, which would allow users to
1345 trade wrapped nomins without accruing fees on those transactions.
1346  
1347 In order to prevent tyranny, an account may only be frozen if
1348 users controlling at least 30% of the value of havvens participate,
1349 and a two thirds majority is attained in that vote.
1350 In order to prevent tyranny of the majority or mob justice,
1351 confiscation motions are only approved if the havven foundation
1352 approves the result.
1353 This latter requirement may be lifted in future versions.
1354  
1355 The foundation, or any user with a sufficient havven balance may
1356 bring a confiscation motion.
1357 A motion lasts for a default period of one week, with a further
1358 confirmation period in which the foundation approves the result.
1359 The latter period may conclude early upon the foundation's decision
1360 to either veto or approve the mooted confiscation motion.
1361 If the confirmation period elapses without the foundation making
1362 a decision, the motion fails.
1363  
1364 The weight of a havven holder's vote is determined by examining
1365 their average balance over the last completed fee period prior to
1366 the beginning of a given motion.
1367  
1368 Thus, since a fee period can roll over in the middle of a motion,
1369 we must also track a user's average balance of the last two periods.
1370 This system is designed such that it cannot be attacked by users
1371 transferring funds between themselves, while also not requiring them
1372 to lock their havvens for the duration of the vote. This is possible
1373 since any transfer that increases the average balance in one account
1374 will be reflected by an equivalent reduction in the voting weight in
1375 the other.
1376  
1377 At present a user may cast a vote only for one motion at a time,
1378 but may cancel their vote at any time except during the confirmation period,
1379 when the vote tallies must remain static until the matter has been settled.
1380  
1381 A motion to confiscate the balance of a given address composes
1382 a state machine built of the following states:
1383  
1384 Waiting:
1385   - A user with standing brings a motion:
1386     If the target address is not frozen;
1387     initialise vote tallies to 0;
1388     transition to the Voting state.
1389  
1390   - An account cancels a previous residual vote:
1391     remain in the Waiting state.
1392  
1393 Voting:
1394   - The foundation vetoes the in-progress motion:
1395     transition to the Waiting state.
1396  
1397   - The voting period elapses:
1398     transition to the Confirmation state.
1399  
1400   - An account votes (for or against the motion):
1401     its weight is added to the appropriate tally;
1402     remain in the Voting state.
1403  
1404   - An account cancels its previous vote:
1405     its weight is deducted from the appropriate tally (if any);
1406     remain in the Voting state.
1407  
1408 Confirmation:
1409   - The foundation vetoes the completed motion:
1410     transition to the Waiting state.
1411  
1412   - The foundation approves confiscation of the target account:
1413     freeze the target account, transfer its nomin balance to the fee pool;
1414     transition to the Waiting state.
1415  
1416   - The confirmation period elapses:
1417     transition to the Waiting state.
1418  
1419 User votes are not automatically cancelled upon the conclusion of a motion.
1420 Therefore, after a motion comes to a conclusion, if a user wishes to vote
1421 in another motion, they must manually cancel their vote in order to do so.
1422  
1423 This procedure is designed to be relatively simple.
1424 There are some things that can be added to enhance the functionality
1425 at the expense of simplicity and efficiency:
1426  
1427   - Democratic unfreezing of nomin accounts (induces multiple categories of vote)
1428   - Configurable per-vote durations;
1429   - Vote standing denominated in a fiat quantity rather than a quantity of havvens;
1430   - Confiscate from multiple addresses in a single vote;
1431  
1432 We might consider updating the contract with any of these features at a later date if necessary.
1433  
1434 -----------------------------------------------------------------
1435 */
1436  
1437  
1438 /**
1439  * @title A court contract allowing a democratic mechanism to dissuade token wrappers.
1440  */
1441 contract Court is SafeDecimalMath, Owned {
1442  
1443     /* ========== STATE VARIABLES ========== */
1444  
1445     /* The addresses of the token contracts this confiscation court interacts with. */
1446     Havven public havven;
1447     Nomin public nomin;
1448  
1449     /* The minimum issued nomin balance required to be considered to have
1450      * standing to begin confiscation proceedings. */
1451     uint public minStandingBalance = 100 * UNIT;
1452  
1453     /* The voting period lasts for this duration,
1454      * and if set, must fall within the given bounds. */
1455     uint public votingPeriod = 1 weeks;
1456     uint constant MIN_VOTING_PERIOD = 3 days;
1457     uint constant MAX_VOTING_PERIOD = 4 weeks;
1458  
1459     /* Duration of the period during which the foundation may confirm
1460      * or veto a motion that has concluded.
1461      * If set, the confirmation duration must fall within the given bounds. */
1462     uint public confirmationPeriod = 1 weeks;
1463     uint constant MIN_CONFIRMATION_PERIOD = 1 days;
1464     uint constant MAX_CONFIRMATION_PERIOD = 2 weeks;
1465  
1466     /* No fewer than this fraction of total available voting power must
1467      * participate in a motion in order for a quorum to be reached.
1468      * The participation fraction required may be set no lower than 10%.
1469      * As a fraction, it is expressed in terms of UNIT, not as an absolute quantity. */
1470     uint public requiredParticipation = 3 * UNIT / 10;
1471     uint constant MIN_REQUIRED_PARTICIPATION = UNIT / 10;
1472  
1473     /* At least this fraction of participating votes must be in favour of
1474      * confiscation for the motion to pass.
1475      * The required majority may be no lower than 50%.
1476      * As a fraction, it is expressed in terms of UNIT, not as an absolute quantity. */
1477     uint public requiredMajority = (2 * UNIT) / 3;
1478     uint constant MIN_REQUIRED_MAJORITY = UNIT / 2;
1479  
1480     /* The next ID to use for opening a motion.
1481      * The 0 motion ID corresponds to no motion,
1482      * and is used as a null value for later comparison. */
1483     uint nextMotionID = 1;
1484  
1485     /* Mapping from motion IDs to target addresses. */
1486     mapping(uint => address) public motionTarget;
1487  
1488     /* The ID a motion on an address is currently operating at.
1489      * Zero if no such motion is running. */
1490     mapping(address => uint) public targetMotionID;
1491  
1492     /* The timestamp at which a motion began. This is used to determine
1493      * whether a motion is: running, in the confirmation period,
1494      * or has concluded.
1495      * A motion runs from its start time t until (t + votingPeriod),
1496      * and then the confirmation period terminates no later than
1497      * (t + votingPeriod + confirmationPeriod). */
1498     mapping(uint => uint) public motionStartTime;
1499  
1500     /* The tallies for and against confiscation of a given balance.
1501      * These are set to zero at the start of a motion, and also on conclusion,
1502      * just to keep the state clean. */
1503     mapping(uint => uint) public votesFor;
1504     mapping(uint => uint) public votesAgainst;
1505  
1506     /* The last average balance of a user at the time they voted
1507      * in a particular motion.
1508      * If we did not save this information then we would have to
1509      * disallow transfers into an account lest it cancel a vote
1510      * with greater weight than that with which it originally voted,
1511      * and the fee period rolled over in between. */
1512     // TODO: This may be unnecessary now that votes are forced to be
1513     // within a fee period. Likely possible to delete this.
1514     mapping(address => mapping(uint => uint)) voteWeight;
1515  
1516     /* The possible vote types.
1517      * Abstention: not participating in a motion; This is the default value.
1518      * Yea: voting in favour of a motion.
1519      * Nay: voting against a motion. */
1520     enum Vote {Abstention, Yea, Nay}
1521  
1522     /* A given account's vote in some confiscation motion.
1523      * This requires the default value of the Vote enum to correspond to an abstention. */
1524     mapping(address => mapping(uint => Vote)) public vote;
1525  
1526  
1527     /* ========== CONSTRUCTOR ========== */
1528  
1529     /**
1530      * @dev Court Constructor.
1531      */
1532     constructor(Havven _havven, Nomin _nomin, address _owner)
1533         Owned(_owner)
1534         public
1535     {
1536         havven = _havven;
1537         nomin = _nomin;
1538     }
1539  
1540  
1541     /* ========== SETTERS ========== */
1542  
1543     /**
1544      * @notice Set the minimum required havven balance to have standing to bring a motion.
1545      * @dev Only the contract owner may call this.
1546      */
1547     function setMinStandingBalance(uint balance)
1548         external
1549         onlyOwner
1550     {
1551         /* No requirement on the standing threshold here;
1552          * the foundation can set this value such that
1553          * anyone or no one can actually start a motion. */
1554         minStandingBalance = balance;
1555     }
1556  
1557     /**
1558      * @notice Set the length of time a vote runs for.
1559      * @dev Only the contract owner may call this. The proposed duration must fall
1560      * within sensible bounds (3 days to 4 weeks), and must be no longer than a single fee period.
1561      */
1562     function setVotingPeriod(uint duration)
1563         external
1564         onlyOwner
1565     {
1566         require(MIN_VOTING_PERIOD <= duration &&
1567                 duration <= MAX_VOTING_PERIOD);
1568         /* Require that the voting period is no longer than a single fee period,
1569          * So that a single vote can span at most two fee periods. */
1570         require(duration <= havven.feePeriodDuration());
1571         votingPeriod = duration;
1572     }
1573  
1574     /**
1575      * @notice Set the confirmation period after a vote has concluded.
1576      * @dev Only the contract owner may call this. The proposed duration must fall
1577      * within sensible bounds (1 day to 2 weeks).
1578      */
1579     function setConfirmationPeriod(uint duration)
1580         external
1581         onlyOwner
1582     {
1583         require(MIN_CONFIRMATION_PERIOD <= duration &&
1584                 duration <= MAX_CONFIRMATION_PERIOD);
1585         confirmationPeriod = duration;
1586     }
1587  
1588     /**
1589      * @notice Set the required fraction of all Havvens that need to be part of
1590      * a vote for it to pass.
1591      */
1592     function setRequiredParticipation(uint fraction)
1593         external
1594         onlyOwner
1595     {
1596         require(MIN_REQUIRED_PARTICIPATION <= fraction);
1597         requiredParticipation = fraction;
1598     }
1599  
1600     /**
1601      * @notice Set what portion of voting havvens need to be in the affirmative
1602      * to allow it to pass.
1603      */
1604     function setRequiredMajority(uint fraction)
1605         external
1606         onlyOwner
1607     {
1608         require(MIN_REQUIRED_MAJORITY <= fraction);
1609         requiredMajority = fraction;
1610     }
1611  
1612  
1613     /* ========== VIEW FUNCTIONS ========== */
1614  
1615     /**
1616      * @notice There is a motion in progress on the specified
1617      * account, and votes are being accepted in that motion.
1618      */
1619     function motionVoting(uint motionID)
1620         public
1621         view
1622         returns (bool)
1623     {
1624         return motionStartTime[motionID] < now && now < motionStartTime[motionID] + votingPeriod;
1625     }
1626  
1627     /**
1628      * @notice A vote on the target account has concluded, but the motion
1629      * has not yet been approved, vetoed, or closed. */
1630     function motionConfirming(uint motionID)
1631         public
1632         view
1633         returns (bool)
1634     {
1635         /* These values are timestamps, they will not overflow
1636          * as they can only ever be initialised to relatively small values.
1637          */
1638         uint startTime = motionStartTime[motionID];
1639         return startTime + votingPeriod <= now &&
1640                now < startTime + votingPeriod + confirmationPeriod;
1641     }
1642  
1643     /**
1644      * @notice A vote motion either not begun, or it has completely terminated.
1645      */
1646     function motionWaiting(uint motionID)
1647         public
1648         view
1649         returns (bool)
1650     {
1651         /* These values are timestamps, they will not overflow
1652          * as they can only ever be initialised to relatively small values. */
1653         return motionStartTime[motionID] + votingPeriod + confirmationPeriod <= now;
1654     }
1655  
1656     /**
1657      * @notice If the motion was to terminate at this instant, it would pass.
1658      * That is: there was sufficient participation and a sizeable enough majority.
1659      */
1660     function motionPasses(uint motionID)
1661         public
1662         view
1663         returns (bool)
1664     {
1665         uint yeas = votesFor[motionID];
1666         uint nays = votesAgainst[motionID];
1667         uint totalVotes = safeAdd(yeas, nays);
1668  
1669         if (totalVotes == 0) {
1670             return false;
1671         }
1672  
1673         uint participation = safeDiv_dec(totalVotes, havven.totalIssuanceLastAverageBalance());
1674         uint fractionInFavour = safeDiv_dec(yeas, totalVotes);
1675  
1676         /* We require the result to be strictly greater than the requirement
1677          * to enforce a majority being "50% + 1", and so on. */
1678         return participation > requiredParticipation &&
1679                fractionInFavour > requiredMajority;
1680     }
1681  
1682     /**
1683      * @notice Return if the specified account has voted on the specified motion
1684      */
1685     function hasVoted(address account, uint motionID)
1686         public
1687         view
1688         returns (bool)
1689     {
1690         return vote[account][motionID] != Vote.Abstention;
1691     }
1692  
1693  
1694     /* ========== MUTATIVE FUNCTIONS ========== */
1695  
1696     /**
1697      * @notice Begin a motion to confiscate the funds in a given nomin account.
1698      * @dev Only the foundation, or accounts with sufficient havven balances
1699      * may elect to start such a motion.
1700      * @return Returns the ID of the motion that was begun.
1701      */
1702     function beginMotion(address target)
1703         external
1704         returns (uint)
1705     {
1706         /* A confiscation motion must be mooted by someone with standing. */
1707         require((havven.issuanceLastAverageBalance(msg.sender) >= minStandingBalance) ||
1708                 msg.sender == owner);
1709  
1710         /* Require that the voting period is longer than a single fee period,
1711          * So that a single vote can span at most two fee periods. */
1712         require(votingPeriod <= havven.feePeriodDuration());
1713  
1714         /* There must be no confiscation motion already running for this account. */
1715         require(targetMotionID[target] == 0);
1716  
1717         /* Disallow votes on accounts that are currently frozen. */
1718         require(!nomin.frozen(target));
1719  
1720         /* It is necessary to roll over the fee period if it has elapsed, or else
1721          * the vote might be initialised having begun in the past. */
1722         havven.rolloverFeePeriodIfElapsed();
1723  
1724         uint motionID = nextMotionID++;
1725         motionTarget[motionID] = target;
1726         targetMotionID[target] = motionID;
1727  
1728         /* Start the vote at the start of the next fee period */
1729         uint startTime = havven.feePeriodStartTime() + havven.feePeriodDuration();
1730         motionStartTime[motionID] = startTime;
1731         emit MotionBegun(msg.sender, target, motionID, startTime);
1732  
1733         return motionID;
1734     }
1735  
1736     /**
1737      * @notice Shared vote setup function between voteFor and voteAgainst.
1738      * @return Returns the voter's vote weight. */
1739     function setupVote(uint motionID)
1740         internal
1741         returns (uint)
1742     {
1743         /* There must be an active vote for this target running.
1744          * Vote totals must only change during the voting phase. */
1745         require(motionVoting(motionID));
1746  
1747         /* The voter must not have an active vote this motion. */
1748         require(!hasVoted(msg.sender, motionID));
1749  
1750         /* The voter may not cast votes on themselves. */
1751         require(msg.sender != motionTarget[motionID]);
1752  
1753         uint weight = havven.recomputeLastAverageBalance(msg.sender);
1754  
1755         /* Users must have a nonzero voting weight to vote. */
1756         require(weight > 0);
1757  
1758         voteWeight[msg.sender][motionID] = weight;
1759  
1760         return weight;
1761     }
1762  
1763     /**
1764      * @notice The sender casts a vote in favour of confiscation of the
1765      * target account's nomin balance.
1766      */
1767     function voteFor(uint motionID)
1768         external
1769     {
1770         uint weight = setupVote(motionID);
1771         vote[msg.sender][motionID] = Vote.Yea;
1772         votesFor[motionID] = safeAdd(votesFor[motionID], weight);
1773         emit VotedFor(msg.sender, motionID, weight);
1774     }
1775  
1776     /**
1777      * @notice The sender casts a vote against confiscation of the
1778      * target account's nomin balance.
1779      */
1780     function voteAgainst(uint motionID)
1781         external
1782     {
1783         uint weight = setupVote(motionID);
1784         vote[msg.sender][motionID] = Vote.Nay;
1785         votesAgainst[motionID] = safeAdd(votesAgainst[motionID], weight);
1786         emit VotedAgainst(msg.sender, motionID, weight);
1787     }
1788  
1789     /**
1790      * @notice Cancel an existing vote by the sender on a motion
1791      * to confiscate the target balance.
1792      */
1793     function cancelVote(uint motionID)
1794         external
1795     {
1796         /* An account may cancel its vote either before the confirmation phase
1797          * when the motion is still open, or after the confirmation phase,
1798          * when the motion has concluded.
1799          * But the totals must not change during the confirmation phase itself. */
1800         require(!motionConfirming(motionID));
1801  
1802         Vote senderVote = vote[msg.sender][motionID];
1803  
1804         /* If the sender has not voted then there is no need to update anything. */
1805         require(senderVote != Vote.Abstention);
1806  
1807         /* If we are not voting, there is no reason to update the vote totals. */
1808         if (motionVoting(motionID)) {
1809             if (senderVote == Vote.Yea) {
1810                 votesFor[motionID] = safeSub(votesFor[motionID], voteWeight[msg.sender][motionID]);
1811             } else {
1812                 /* Since we already ensured that the vote is not an abstention,
1813                  * the only option remaining is Vote.Nay. */
1814                 votesAgainst[motionID] = safeSub(votesAgainst[motionID], voteWeight[msg.sender][motionID]);
1815             }
1816             /* A cancelled vote is only meaningful if a vote is running. */
1817             emit VoteCancelled(msg.sender, motionID);
1818         }
1819  
1820         delete voteWeight[msg.sender][motionID];
1821         delete vote[msg.sender][motionID];
1822     }
1823  
1824     /**
1825      * @notice clear all data associated with a motionID for hygiene purposes.
1826      */
1827     function _closeMotion(uint motionID)
1828         internal
1829     {
1830         delete targetMotionID[motionTarget[motionID]];
1831         delete motionTarget[motionID];
1832         delete motionStartTime[motionID];
1833         delete votesFor[motionID];
1834         delete votesAgainst[motionID];
1835         emit MotionClosed(motionID);
1836     }
1837  
1838     /**
1839      * @notice If a motion has concluded, or if it lasted its full duration but not passed,
1840      * then anyone may close it.
1841      */
1842     function closeMotion(uint motionID)
1843         external
1844     {
1845         require((motionConfirming(motionID) && !motionPasses(motionID)) || motionWaiting(motionID));
1846         _closeMotion(motionID);
1847     }
1848  
1849     /**
1850      * @notice The foundation may only confiscate a balance during the confirmation
1851      * period after a motion has passed.
1852      */
1853     function approveMotion(uint motionID)
1854         external
1855         onlyOwner
1856     {
1857         require(motionConfirming(motionID) && motionPasses(motionID));
1858         address target = motionTarget[motionID];
1859         nomin.freezeAndConfiscate(target);
1860         _closeMotion(motionID);
1861         emit MotionApproved(motionID);
1862     }
1863  
1864     /* @notice The foundation may veto a motion at any time. */
1865     function vetoMotion(uint motionID)
1866         external
1867         onlyOwner
1868     {
1869         require(!motionWaiting(motionID));
1870         _closeMotion(motionID);
1871         emit MotionVetoed(motionID);
1872     }
1873  
1874  
1875     /* ========== EVENTS ========== */
1876  
1877     event MotionBegun(address indexed initiator, address indexed target, uint indexed motionID, uint startTime);
1878  
1879     event VotedFor(address indexed voter, uint indexed motionID, uint weight);
1880  
1881     event VotedAgainst(address indexed voter, uint indexed motionID, uint weight);
1882  
1883     event VoteCancelled(address indexed voter, uint indexed motionID);
1884  
1885     event MotionClosed(uint indexed motionID);
1886  
1887     event MotionVetoed(uint indexed motionID);
1888  
1889     event MotionApproved(uint indexed motionID);
1890 }
1891  
1892  
1893 /*
1894 -----------------------------------------------------------------
1895 FILE INFORMATION
1896 -----------------------------------------------------------------
1897  
1898 file:       Nomin.sol
1899 version:    1.2
1900 author:     Anton Jurisevic
1901             Mike Spain
1902             Dominic Romanowski
1903             Kevin Brown
1904  
1905 date:       2018-05-29
1906  
1907 -----------------------------------------------------------------
1908 MODULE DESCRIPTION
1909 -----------------------------------------------------------------
1910  
1911 Havven-backed nomin stablecoin contract.
1912  
1913 This contract issues nomins, which are tokens worth 1 USD each.
1914  
1915 Nomins are issuable by Havven holders who have to lock up some
1916 value of their havvens to issue H * Cmax nomins. Where Cmax is
1917 some value less than 1.
1918  
1919 A configurable fee is charged on nomin transfers and deposited
1920 into a common pot, which havven holders may withdraw from once
1921 per fee period.
1922  
1923 -----------------------------------------------------------------
1924 */
1925  
1926  
1927 contract Nomin is FeeToken {
1928  
1929     /* ========== STATE VARIABLES ========== */
1930  
1931     // The address of the contract which manages confiscation votes.
1932     Court public court;
1933     Havven public havven;
1934  
1935     // Accounts which have lost the privilege to transact in nomins.
1936     mapping(address => bool) public frozen;
1937  
1938     // Nomin transfers incur a 15 bp fee by default.
1939     uint constant TRANSFER_FEE_RATE = 15 * UNIT / 10000;
1940     string constant TOKEN_NAME = "Nomin USD";
1941     string constant TOKEN_SYMBOL = "nUSD";
1942  
1943     /* ========== CONSTRUCTOR ========== */
1944  
1945     constructor(address _proxy, TokenState _tokenState, Havven _havven,
1946                 uint _totalSupply,
1947                 address _owner)
1948         FeeToken(_proxy, _tokenState,
1949                  TOKEN_NAME, TOKEN_SYMBOL, _totalSupply,
1950                  TRANSFER_FEE_RATE,
1951                  _havven, // The havven contract is the fee authority.
1952                  _owner)
1953         public
1954     {
1955         require(_proxy != 0 && address(_havven) != 0 && _owner != 0);
1956         // It should not be possible to transfer to the fee pool directly (or confiscate its balance).
1957         frozen[FEE_ADDRESS] = true;
1958         havven = _havven;
1959     }
1960  
1961     /* ========== SETTERS ========== */
1962  
1963     function setCourt(Court _court)
1964         external
1965         optionalProxy_onlyOwner
1966     {
1967         court = _court;
1968         emitCourtUpdated(_court);
1969     }
1970  
1971     function setHavven(Havven _havven)
1972         external
1973         optionalProxy_onlyOwner
1974     {
1975         // havven should be set as the feeAuthority after calling this depending on
1976         // havven's internal logic
1977         havven = _havven;
1978         setFeeAuthority(_havven);
1979         emitHavvenUpdated(_havven);
1980     }
1981  
1982  
1983     /* ========== MUTATIVE FUNCTIONS ========== */
1984  
1985     /* Override ERC20 transfer function in order to check
1986      * whether the recipient account is frozen. Note that there is
1987      * no need to check whether the sender has a frozen account,
1988      * since their funds have already been confiscated,
1989      * and no new funds can be transferred to it.*/
1990     function transfer(address to, uint value)
1991         public
1992         optionalProxy
1993         returns (bool)
1994     {
1995         require(!frozen[to]);
1996         return _transfer_byProxy(messageSender, to, value);
1997     }
1998  
1999     /* Override ERC20 transferFrom function in order to check
2000      * whether the recipient account is frozen. */
2001     function transferFrom(address from, address to, uint value)
2002         public
2003         optionalProxy
2004         returns (bool)
2005     {
2006         require(!frozen[to]);
2007         return _transferFrom_byProxy(messageSender, from, to, value);
2008     }
2009  
2010     function transferSenderPaysFee(address to, uint value)
2011         public
2012         optionalProxy
2013         returns (bool)
2014     {
2015         require(!frozen[to]);
2016         return _transferSenderPaysFee_byProxy(messageSender, to, value);
2017     }
2018  
2019     function transferFromSenderPaysFee(address from, address to, uint value)
2020         public
2021         optionalProxy
2022         returns (bool)
2023     {
2024         require(!frozen[to]);
2025         return _transferFromSenderPaysFee_byProxy(messageSender, from, to, value);
2026     }
2027  
2028     /* If a confiscation court motion has passed and reached the confirmation
2029      * state, the court may transfer the target account's balance to the fee pool
2030      * and freeze its participation in further transactions. */
2031     function freezeAndConfiscate(address target)
2032         external
2033         onlyCourt
2034     {
2035          
2036         // A motion must actually be underway.
2037         uint motionID = court.targetMotionID(target);
2038         require(motionID != 0);
2039  
2040         // These checks are strictly unnecessary,
2041         // since they are already checked in the court contract itself.
2042         require(court.motionConfirming(motionID));
2043         require(court.motionPasses(motionID));
2044         require(!frozen[target]);
2045  
2046         // Confiscate the balance in the account and freeze it.
2047         uint balance = tokenState.balanceOf(target);
2048         tokenState.setBalanceOf(FEE_ADDRESS, safeAdd(tokenState.balanceOf(FEE_ADDRESS), balance));
2049         tokenState.setBalanceOf(target, 0);
2050         frozen[target] = true;
2051         emitAccountFrozen(target, balance);
2052         emitTransfer(target, FEE_ADDRESS, balance);
2053     }
2054  
2055     /* The owner may allow a previously-frozen contract to once
2056      * again accept and transfer nomins. */
2057     function unfreezeAccount(address target)
2058         external
2059         optionalProxy_onlyOwner
2060     {
2061         require(frozen[target] && target != FEE_ADDRESS);
2062         frozen[target] = false;
2063         emitAccountUnfrozen(target);
2064     }
2065  
2066     /* Allow havven to issue a certain number of
2067      * nomins from an account. */
2068     function issue(address account, uint amount)
2069         external
2070         onlyHavven
2071     {
2072         tokenState.setBalanceOf(account, safeAdd(tokenState.balanceOf(account), amount));
2073         totalSupply = safeAdd(totalSupply, amount);
2074         emitTransfer(address(0), account, amount);
2075         emitIssued(account, amount);
2076     }
2077  
2078     /* Allow havven to burn a certain number of
2079      * nomins from an account. */
2080     function burn(address account, uint amount)
2081         external
2082         onlyHavven
2083     {
2084         tokenState.setBalanceOf(account, safeSub(tokenState.balanceOf(account), amount));
2085         totalSupply = safeSub(totalSupply, amount);
2086         emitTransfer(account, address(0), amount);
2087         emitBurned(account, amount);
2088     }
2089  
2090     /* ========== MODIFIERS ========== */
2091  
2092     modifier onlyHavven() {
2093         require(Havven(msg.sender) == havven);
2094         _;
2095     }
2096  
2097     modifier onlyCourt() {
2098         require(Court(msg.sender) == court);
2099         _;
2100     }
2101  
2102     /* ========== EVENTS ========== */
2103  
2104     event CourtUpdated(address newCourt);
2105     bytes32 constant COURTUPDATED_SIG = keccak256("CourtUpdated(address)");
2106     function emitCourtUpdated(address newCourt) internal {
2107         proxy._emit(abi.encode(newCourt), 1, COURTUPDATED_SIG, 0, 0, 0);
2108     }
2109  
2110     event HavvenUpdated(address newHavven);
2111     bytes32 constant HAVVENUPDATED_SIG = keccak256("HavvenUpdated(address)");
2112     function emitHavvenUpdated(address newHavven) internal {
2113         proxy._emit(abi.encode(newHavven), 1, HAVVENUPDATED_SIG, 0, 0, 0);
2114     }
2115  
2116     event AccountFrozen(address indexed target, uint balance);
2117     bytes32 constant ACCOUNTFROZEN_SIG = keccak256("AccountFrozen(address,uint256)");
2118     function emitAccountFrozen(address target, uint balance) internal {
2119         proxy._emit(abi.encode(balance), 2, ACCOUNTFROZEN_SIG, bytes32(target), 0, 0);
2120     }
2121  
2122     event AccountUnfrozen(address indexed target);
2123     bytes32 constant ACCOUNTUNFROZEN_SIG = keccak256("AccountUnfrozen(address)");
2124     function emitAccountUnfrozen(address target) internal {
2125         proxy._emit(abi.encode(), 2, ACCOUNTUNFROZEN_SIG, bytes32(target), 0, 0);
2126     }
2127  
2128     event Issued(address indexed account, uint amount);
2129     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
2130     function emitIssued(address account, uint amount) internal {
2131         proxy._emit(abi.encode(amount), 2, ISSUED_SIG, bytes32(account), 0, 0);
2132     }
2133  
2134     event Burned(address indexed account, uint amount);
2135     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
2136     function emitBurned(address account, uint amount) internal {
2137         proxy._emit(abi.encode(amount), 2, BURNED_SIG, bytes32(account), 0, 0);
2138     }
2139 }
2140  
2141  
2142 /*
2143 -----------------------------------------------------------------
2144 FILE INFORMATION
2145 -----------------------------------------------------------------
2146  
2147 file:       LimitedSetup.sol
2148 version:    1.1
2149 author:     Anton Jurisevic
2150  
2151 date:       2018-05-15
2152  
2153 -----------------------------------------------------------------
2154 MODULE DESCRIPTION
2155 -----------------------------------------------------------------
2156  
2157 A contract with a limited setup period. Any function modified
2158 with the setup modifier will cease to work after the
2159 conclusion of the configurable-length post-construction setup period.
2160  
2161 -----------------------------------------------------------------
2162 */
2163  
2164  
2165 /**
2166  * @title Any function decorated with the modifier this contract provides
2167  * deactivates after a specified setup period.
2168  */
2169 contract LimitedSetup {
2170  
2171     uint setupExpiryTime;
2172  
2173     /**
2174      * @dev LimitedSetup Constructor.
2175      * @param setupDuration The time the setup period will last for.
2176      */
2177     constructor(uint setupDuration)
2178         public
2179     {
2180         setupExpiryTime = now + setupDuration;
2181     }
2182  
2183     modifier onlyDuringSetup
2184     {
2185         require(now < setupExpiryTime);
2186         _;
2187     }
2188 }
2189  
2190  
2191 /*
2192 -----------------------------------------------------------------
2193 FILE INFORMATION
2194 -----------------------------------------------------------------
2195  
2196 file:       HavvenEscrow.sol
2197 version:    1.1
2198 author:     Anton Jurisevic
2199             Dominic Romanowski
2200             Mike Spain
2201  
2202 date:       2018-05-29
2203  
2204 -----------------------------------------------------------------
2205 MODULE DESCRIPTION
2206 -----------------------------------------------------------------
2207  
2208 This contract allows the foundation to apply unique vesting
2209 schedules to havven funds sold at various discounts in the token
2210 sale. HavvenEscrow gives users the ability to inspect their
2211 vested funds, their quantities and vesting dates, and to withdraw
2212 the fees that accrue on those funds.
2213  
2214 The fees are handled by withdrawing the entire fee allocation
2215 for all havvens inside the escrow contract, and then allowing
2216 the contract itself to subdivide that pool up proportionally within
2217 itself. Every time the fee period rolls over in the main Havven
2218 contract, the HavvenEscrow fee pool is remitted back into the
2219 main fee pool to be redistributed in the next fee period.
2220  
2221 -----------------------------------------------------------------
2222 */
2223  
2224  
2225 /**
2226  * @title A contract to hold escrowed havvens and free them at given schedules.
2227  */
2228 contract HavvenEscrow is SafeDecimalMath, Owned, LimitedSetup(8 weeks) {
2229     /* The corresponding Havven contract. */
2230     Havven public havven;
2231  
2232     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
2233      * These are the times at which each given quantity of havvens vests. */
2234     mapping(address => uint[2][]) public vestingSchedules;
2235  
2236     /* An account's total vested havven balance to save recomputing this for fee extraction purposes. */
2237     mapping(address => uint) public totalVestedAccountBalance;
2238  
2239     /* The total remaining vested balance, for verifying the actual havven balance of this contract against. */
2240     uint public totalVestedBalance;
2241  
2242     uint constant TIME_INDEX = 0;
2243     uint constant QUANTITY_INDEX = 1;
2244  
2245     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
2246     uint constant MAX_VESTING_ENTRIES = 20;
2247  
2248  
2249     /* ========== CONSTRUCTOR ========== */
2250  
2251     constructor(address _owner, Havven _havven)
2252         Owned(_owner)
2253         public
2254     {
2255         havven = _havven;
2256     }
2257  
2258  
2259     /* ========== SETTERS ========== */
2260  
2261     function setHavven(Havven _havven)
2262         external
2263         onlyOwner
2264     {
2265         havven = _havven;
2266         emit HavvenUpdated(_havven);
2267     }
2268  
2269  
2270     /* ========== VIEW FUNCTIONS ========== */
2271  
2272     /**
2273      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
2274      */
2275     function balanceOf(address account)
2276         public
2277         view
2278         returns (uint)
2279     {
2280         return totalVestedAccountBalance[account];
2281     }
2282  
2283     /**
2284      * @notice The number of vesting dates in an account's schedule.
2285      */
2286     function numVestingEntries(address account)
2287         public
2288         view
2289         returns (uint)
2290     {
2291         return vestingSchedules[account].length;
2292     }
2293  
2294     /**
2295      * @notice Get a particular schedule entry for an account.
2296      * @return A pair of uints: (timestamp, havven quantity).
2297      */
2298     function getVestingScheduleEntry(address account, uint index)
2299         public
2300         view
2301         returns (uint[2])
2302     {
2303         return vestingSchedules[account][index];
2304     }
2305  
2306     /**
2307      * @notice Get the time at which a given schedule entry will vest.
2308      */
2309     function getVestingTime(address account, uint index)
2310         public
2311         view
2312         returns (uint)
2313     {
2314         return getVestingScheduleEntry(account,index)[TIME_INDEX];
2315     }
2316  
2317     /**
2318      * @notice Get the quantity of havvens associated with a given schedule entry.
2319      */
2320     function getVestingQuantity(address account, uint index)
2321         public
2322         view
2323         returns (uint)
2324     {
2325         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
2326     }
2327  
2328     /**
2329      * @notice Obtain the index of the next schedule entry that will vest for a given user.
2330      */
2331     function getNextVestingIndex(address account)
2332         public
2333         view
2334         returns (uint)
2335     {
2336         uint len = numVestingEntries(account);
2337         for (uint i = 0; i < len; i++) {
2338             if (getVestingTime(account, i) != 0) {
2339                 return i;
2340             }
2341         }
2342         return len;
2343     }
2344  
2345     /**
2346      * @notice Obtain the next schedule entry that will vest for a given user.
2347      * @return A pair of uints: (timestamp, havven quantity). */
2348     function getNextVestingEntry(address account)
2349         public
2350         view
2351         returns (uint[2])
2352     {
2353         uint index = getNextVestingIndex(account);
2354         if (index == numVestingEntries(account)) {
2355             return [uint(0), 0];
2356         }
2357         return getVestingScheduleEntry(account, index);
2358     }
2359  
2360     /**
2361      * @notice Obtain the time at which the next schedule entry will vest for a given user.
2362      */
2363     function getNextVestingTime(address account)
2364         external
2365         view
2366         returns (uint)
2367     {
2368         return getNextVestingEntry(account)[TIME_INDEX];
2369     }
2370  
2371     /**
2372      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
2373      */
2374     function getNextVestingQuantity(address account)
2375         external
2376         view
2377         returns (uint)
2378     {
2379         return getNextVestingEntry(account)[QUANTITY_INDEX];
2380     }
2381  
2382  
2383     /* ========== MUTATIVE FUNCTIONS ========== */
2384  
2385     /**
2386      * @notice Withdraws a quantity of havvens back to the havven contract.
2387      * @dev This may only be called by the owner during the contract's setup period.
2388      */
2389     function withdrawHavvens(uint quantity)
2390         external
2391         onlyOwner
2392         onlyDuringSetup
2393     {
2394         havven.transfer(havven, quantity);
2395     }
2396  
2397     /**
2398      * @notice Destroy the vesting information associated with an account.
2399      */
2400     function purgeAccount(address account)
2401         external
2402         onlyOwner
2403         onlyDuringSetup
2404     {
2405         delete vestingSchedules[account];
2406         totalVestedBalance = safeSub(totalVestedBalance, totalVestedAccountBalance[account]);
2407         delete totalVestedAccountBalance[account];
2408     }
2409  
2410     /**
2411      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
2412      * @dev A call to this should be accompanied by either enough balance already available
2413      * in this contract, or a corresponding call to havven.endow(), to ensure that when
2414      * the funds are withdrawn, there is enough balance, as well as correctly calculating
2415      * the fees.
2416      * This may only be called by the owner during the contract's setup period.
2417      * Note; although this function could technically be used to produce unbounded
2418      * arrays, it's only in the foundation's command to add to these lists.
2419      * @param account The account to append a new vesting entry to.
2420      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
2421      * @param quantity The quantity of havvens that will vest.
2422      */
2423     function appendVestingEntry(address account, uint time, uint quantity)
2424         public
2425         onlyOwner
2426         onlyDuringSetup
2427     {
2428         /* No empty or already-passed vesting entries allowed. */
2429         require(now < time);
2430         require(quantity != 0);
2431  
2432         /* There must be enough balance in the contract to provide for the vesting entry. */
2433         totalVestedBalance = safeAdd(totalVestedBalance, quantity);
2434         require(totalVestedBalance <= havven.balanceOf(this));
2435  
2436         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
2437         uint scheduleLength = vestingSchedules[account].length;
2438         require(scheduleLength <= MAX_VESTING_ENTRIES);
2439  
2440         if (scheduleLength == 0) {
2441             totalVestedAccountBalance[account] = quantity;
2442         } else {
2443             /* Disallow adding new vested havvens earlier than the last one.
2444              * Since entries are only appended, this means that no vesting date can be repeated. */
2445             require(getVestingTime(account, numVestingEntries(account) - 1) < time);
2446             totalVestedAccountBalance[account] = safeAdd(totalVestedAccountBalance[account], quantity);
2447         }
2448  
2449         vestingSchedules[account].push([time, quantity]);
2450     }
2451  
2452     /**
2453      * @notice Construct a vesting schedule to release a quantities of havvens
2454      * over a series of intervals.
2455      * @dev Assumes that the quantities are nonzero
2456      * and that the sequence of timestamps is strictly increasing.
2457      * This may only be called by the owner during the contract's setup period.
2458      */
2459     function addVestingSchedule(address account, uint[] times, uint[] quantities)
2460         external
2461         onlyOwner
2462         onlyDuringSetup
2463     {
2464         for (uint i = 0; i < times.length; i++) {
2465             appendVestingEntry(account, times[i], quantities[i]);
2466         }
2467  
2468     }
2469  
2470     /**
2471      * @notice Allow a user to withdraw any havvens in their schedule that have vested.
2472      */
2473     function vest()
2474         external
2475     {
2476         uint numEntries = numVestingEntries(msg.sender);
2477         uint total;
2478         for (uint i = 0; i < numEntries; i++) {
2479             uint time = getVestingTime(msg.sender, i);
2480             /* The list is sorted; when we reach the first future time, bail out. */
2481             if (time > now) {
2482                 break;
2483             }
2484             uint qty = getVestingQuantity(msg.sender, i);
2485             if (qty == 0) {
2486                 continue;
2487             }
2488  
2489             vestingSchedules[msg.sender][i] = [0, 0];
2490             total = safeAdd(total, qty);
2491         }
2492  
2493         if (total != 0) {
2494             totalVestedBalance = safeSub(totalVestedBalance, total);
2495             totalVestedAccountBalance[msg.sender] = safeSub(totalVestedAccountBalance[msg.sender], total);
2496             havven.transfer(msg.sender, total);
2497             emit Vested(msg.sender, now, total);
2498         }
2499     }
2500  
2501  
2502     /* ========== EVENTS ========== */
2503  
2504     event HavvenUpdated(address newHavven);
2505  
2506     event Vested(address indexed beneficiary, uint time, uint value);
2507 }
2508  
2509  
2510 /*
2511 -----------------------------------------------------------------
2512 FILE INFORMATION
2513 -----------------------------------------------------------------
2514  
2515 file:       Havven.sol
2516 version:    1.2
2517 author:     Anton Jurisevic
2518             Dominic Romanowski
2519  
2520 date:       2018-05-15
2521  
2522 -----------------------------------------------------------------
2523 MODULE DESCRIPTION
2524 -----------------------------------------------------------------
2525  
2526 Havven token contract. Havvens are transferable ERC20 tokens,
2527 and also give their holders the following privileges.
2528 An owner of havvens may participate in nomin confiscation votes, they
2529 may also have the right to issue nomins at the discretion of the
2530 foundation for this version of the contract.
2531  
2532 After a fee period terminates, the duration and fees collected for that
2533 period are computed, and the next period begins. Thus an account may only
2534 withdraw the fees owed to them for the previous period, and may only do
2535 so once per period. Any unclaimed fees roll over into the common pot for
2536 the next period.
2537  
2538 == Average Balance Calculations ==
2539  
2540 The fee entitlement of a havven holder is proportional to their average
2541 issued nomin balance over the last fee period. This is computed by
2542 measuring the area under the graph of a user's issued nomin balance over
2543 time, and then when a new fee period begins, dividing through by the
2544 duration of the fee period.
2545  
2546 We need only update values when the balances of an account is modified.
2547 This occurs when issuing or burning for issued nomin balances,
2548 and when transferring for havven balances. This is for efficiency,
2549 and adds an implicit friction to interacting with havvens.
2550 A havven holder pays for his own recomputation whenever he wants to change
2551 his position, which saves the foundation having to maintain a pot dedicated
2552 to resourcing this.
2553  
2554 A hypothetical user's balance history over one fee period, pictorially:
2555  
2556       s ____
2557        |    |
2558        |    |___ p
2559        |____|___|___ __ _  _
2560        f    t   n
2561  
2562 Here, the balance was s between times f and t, at which time a transfer
2563 occurred, updating the balance to p, until n, when the present transfer occurs.
2564 When a new transfer occurs at time n, the balance being p,
2565 we must:
2566  
2567   - Add the area p * (n - t) to the total area recorded so far
2568   - Update the last transfer time to n
2569  
2570 So if this graph represents the entire current fee period,
2571 the average havvens held so far is ((t-f)*s + (n-t)*p) / (n-f).
2572 The complementary computations must be performed for both sender and
2573 recipient.
2574  
2575 Note that a transfer keeps global supply of havvens invariant.
2576 The sum of all balances is constant, and unmodified by any transfer.
2577 So the sum of all balances multiplied by the duration of a fee period is also
2578 constant, and this is equivalent to the sum of the area of every user's
2579 time/balance graph. Dividing through by that duration yields back the total
2580 havven supply. So, at the end of a fee period, we really do yield a user's
2581 average share in the havven supply over that period.
2582  
2583 A slight wrinkle is introduced if we consider the time r when the fee period
2584 rolls over. Then the previous fee period k-1 is before r, and the current fee
2585 period k is afterwards. If the last transfer took place before r,
2586 but the latest transfer occurred afterwards:
2587  
2588 k-1       |        k
2589       s __|_
2590        |  | |
2591        |  | |____ p
2592        |__|_|____|___ __ _  _
2593           |
2594        f  | t    n
2595           r
2596  
2597 In this situation the area (r-f)*s contributes to fee period k-1, while
2598 the area (t-r)*s contributes to fee period k. We will implicitly consider a
2599 zero-value transfer to have occurred at time r. Their fee entitlement for the
2600 previous period will be finalised at the time of their first transfer during the
2601 current fee period, or when they query or withdraw their fee entitlement.
2602  
2603 In the implementation, the duration of different fee periods may be slightly irregular,
2604 as the check that they have rolled over occurs only when state-changing havven
2605 operations are performed.
2606  
2607 == Issuance and Burning ==
2608  
2609 In this version of the havven contract, nomins can only be issued by
2610 those that have been nominated by the havven foundation. Nomins are assumed
2611 to be valued at $1, as they are a stable unit of account.
2612  
2613 All nomins issued require a proportional value of havvens to be locked,
2614 where the proportion is governed by the current issuance ratio. This
2615 means for every $1 of Havvens locked up, $(issuanceRatio) nomins can be issued.
2616 i.e. to issue 100 nomins, 100/issuanceRatio dollars of havvens need to be locked up.
2617  
2618 To determine the value of some amount of havvens(H), an oracle is used to push
2619 the price of havvens (P_H) in dollars to the contract. The value of H
2620 would then be: H * P_H.
2621  
2622 Any havvens that are locked up by this issuance process cannot be transferred.
2623 The amount that is locked floats based on the price of havvens. If the price
2624 of havvens moves up, less havvens are locked, so they can be issued against,
2625 or transferred freely. If the price of havvens moves down, more havvens are locked,
2626 even going above the initial wallet balance.
2627  
2628 -----------------------------------------------------------------
2629 */
2630  
2631  
2632 /**
2633  * @title Havven ERC20 contract.
2634  * @notice The Havven contracts does not only facilitate transfers and track balances,
2635  * but it also computes the quantity of fees each havven holder is entitled to.
2636  */
2637 contract Havven is ExternStateToken {
2638  
2639     /* ========== STATE VARIABLES ========== */
2640  
2641     /* A struct for handing values associated with average balance calculations */
2642     struct IssuanceData {
2643         /* Sums of balances*duration in the current fee period.
2644         /* range: decimals; units: havven-seconds */
2645         uint currentBalanceSum;
2646         /* The last period's average balance */
2647         uint lastAverageBalance;
2648         /* The last time the data was calculated */
2649         uint lastModified;
2650     }
2651  
2652     /* Issued nomin balances for individual fee entitlements */
2653     mapping(address => IssuanceData) public issuanceData;
2654     /* The total number of issued nomins for determining fee entitlements */
2655     IssuanceData public totalIssuanceData;
2656  
2657     /* The time the current fee period began */
2658     uint public feePeriodStartTime;
2659     /* The time the last fee period began */
2660     uint public lastFeePeriodStartTime;
2661  
2662     /* Fee periods will roll over in no shorter a time than this.
2663      * The fee period cannot actually roll over until a fee-relevant
2664      * operation such as withdrawal or a fee period duration update occurs,
2665      * so this is just a target, and the actual duration may be slightly longer. */
2666     uint public feePeriodDuration = 4 weeks;
2667     /* ...and must target between 1 day and six months. */
2668     uint constant MIN_FEE_PERIOD_DURATION = 1 days;
2669     uint constant MAX_FEE_PERIOD_DURATION = 26 weeks;
2670  
2671     /* The quantity of nomins that were in the fee pot at the time */
2672     /* of the last fee rollover, at feePeriodStartTime. */
2673     uint public lastFeesCollected;
2674  
2675     /* Whether a user has withdrawn their last fees */
2676     mapping(address => bool) public hasWithdrawnFees;
2677  
2678     Nomin public nomin;
2679     HavvenEscrow public escrow;
2680  
2681     /* The address of the oracle which pushes the havven price to this contract */
2682     address public oracle;
2683     /* The price of havvens written in UNIT */
2684     uint public price;
2685     /* The time the havven price was last updated */
2686     uint public lastPriceUpdateTime;
2687     /* How long will the contract assume the price of havvens is correct */
2688     uint public priceStalePeriod = 3 hours;
2689  
2690     /* A quantity of nomins greater than this ratio
2691      * may not be issued against a given value of havvens. */
2692     uint public issuanceRatio = UNIT / 5;
2693     /* No more nomins may be issued than the value of havvens backing them. */
2694     uint constant MAX_ISSUANCE_RATIO = UNIT;
2695  
2696     /* Whether the address can issue nomins or not. */
2697     mapping(address => bool) public isIssuer;
2698     /* The number of currently-outstanding nomins the user has issued. */
2699     mapping(address => uint) public nominsIssued;
2700  
2701     uint constant HAVVEN_SUPPLY = 1e8 * UNIT;
2702     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
2703     string constant TOKEN_NAME = "Havven";
2704     string constant TOKEN_SYMBOL = "HAV";
2705      
2706     /* ========== CONSTRUCTOR ========== */
2707  
2708     /**
2709      * @dev Constructor
2710      * @param _tokenState A pre-populated contract containing token balances.
2711      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
2712      * @param _owner The owner of this contract.
2713      */
2714     constructor(address _proxy, TokenState _tokenState, address _owner, address _oracle,
2715                 uint _price, address[] _issuers, Havven _oldHavven)
2716         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, HAVVEN_SUPPLY, _owner)
2717         public
2718     {
2719         oracle = _oracle;
2720         price = _price;
2721         lastPriceUpdateTime = now;
2722  
2723         uint i;
2724         if (_oldHavven == address(0)) {
2725             feePeriodStartTime = now;
2726             lastFeePeriodStartTime = now - feePeriodDuration;
2727             for (i = 0; i < _issuers.length; i++) {
2728                 isIssuer[_issuers[i]] = true;
2729             }
2730         } else {
2731             feePeriodStartTime = _oldHavven.feePeriodStartTime();
2732             lastFeePeriodStartTime = _oldHavven.lastFeePeriodStartTime();
2733  
2734             uint cbs;
2735             uint lab;
2736             uint lm;
2737             (cbs, lab, lm) = _oldHavven.totalIssuanceData();
2738             totalIssuanceData.currentBalanceSum = cbs;
2739             totalIssuanceData.lastAverageBalance = lab;
2740             totalIssuanceData.lastModified = lm;
2741  
2742             for (i = 0; i < _issuers.length; i++) {
2743                 address issuer = _issuers[i];
2744                 isIssuer[issuer] = true;
2745                 uint nomins = _oldHavven.nominsIssued(issuer);
2746                 if (nomins == 0) {
2747                     // It is not valid in general to skip those with no currently-issued nomins.
2748                     // But for this release, issuers with nonzero issuanceData have current issuance.
2749                     continue;
2750                 }
2751                 (cbs, lab, lm) = _oldHavven.issuanceData(issuer);
2752                 nominsIssued[issuer] = nomins;
2753                 issuanceData[issuer].currentBalanceSum = cbs;
2754                 issuanceData[issuer].lastAverageBalance = lab;
2755                 issuanceData[issuer].lastModified = lm;
2756             }
2757         }
2758  
2759     }
2760  
2761     /* ========== SETTERS ========== */
2762  
2763     /**
2764      * @notice Set the associated Nomin contract to collect fees from.
2765      * @dev Only the contract owner may call this.
2766      */
2767     function setNomin(Nomin _nomin)
2768         external
2769         optionalProxy_onlyOwner
2770     {
2771         nomin = _nomin;
2772         emitNominUpdated(_nomin);
2773     }
2774  
2775     /**
2776      * @notice Set the associated havven escrow contract.
2777      * @dev Only the contract owner may call this.
2778      */
2779     function setEscrow(HavvenEscrow _escrow)
2780         external
2781         optionalProxy_onlyOwner
2782     {
2783         escrow = _escrow;
2784         emitEscrowUpdated(_escrow);
2785     }
2786  
2787     /**
2788      * @notice Set the targeted fee period duration.
2789      * @dev Only callable by the contract owner. The duration must fall within
2790      * acceptable bounds (1 day to 26 weeks). Upon resetting this the fee period
2791      * may roll over if the target duration was shortened sufficiently.
2792      */
2793     function setFeePeriodDuration(uint duration)
2794         external
2795         optionalProxy_onlyOwner
2796     {
2797         require(MIN_FEE_PERIOD_DURATION <= duration &&
2798                                duration <= MAX_FEE_PERIOD_DURATION);
2799         feePeriodDuration = duration;
2800         emitFeePeriodDurationUpdated(duration);
2801         rolloverFeePeriodIfElapsed();
2802     }
2803  
2804     /**
2805      * @notice Set the Oracle that pushes the havven price to this contract
2806      */
2807     function setOracle(address _oracle)
2808         external
2809         optionalProxy_onlyOwner
2810     {
2811         oracle = _oracle;
2812         emitOracleUpdated(_oracle);
2813     }
2814  
2815     /**
2816      * @notice Set the stale period on the updated havven price
2817      * @dev No max/minimum, as changing it wont influence anything but issuance by the foundation
2818      */
2819     function setPriceStalePeriod(uint time)
2820         external
2821         optionalProxy_onlyOwner
2822     {
2823         priceStalePeriod = time;
2824     }
2825  
2826     /**
2827      * @notice Set the issuanceRatio for issuance calculations.
2828      * @dev Only callable by the contract owner.
2829      */
2830     function setIssuanceRatio(uint _issuanceRatio)
2831         external
2832         optionalProxy_onlyOwner
2833     {
2834         require(_issuanceRatio <= MAX_ISSUANCE_RATIO);
2835         issuanceRatio = _issuanceRatio;
2836         emitIssuanceRatioUpdated(_issuanceRatio);
2837     }
2838  
2839     /**
2840      * @notice Set whether the specified can issue nomins or not.
2841      */
2842     function setIssuer(address account, bool value)
2843         external
2844         optionalProxy_onlyOwner
2845     {
2846         isIssuer[account] = value;
2847         emitIssuersUpdated(account, value);
2848     }
2849  
2850     /* ========== VIEWS ========== */
2851  
2852     function issuanceCurrentBalanceSum(address account)
2853         external
2854         view
2855         returns (uint)
2856     {
2857         return issuanceData[account].currentBalanceSum;
2858     }
2859  
2860     function issuanceLastAverageBalance(address account)
2861         external
2862         view
2863         returns (uint)
2864     {
2865         return issuanceData[account].lastAverageBalance;
2866     }
2867  
2868     function issuanceLastModified(address account)
2869         external
2870         view
2871         returns (uint)
2872     {
2873         return issuanceData[account].lastModified;
2874     }
2875  
2876     function totalIssuanceCurrentBalanceSum()
2877         external
2878         view
2879         returns (uint)
2880     {
2881         return totalIssuanceData.currentBalanceSum;
2882     }
2883  
2884     function totalIssuanceLastAverageBalance()
2885         external
2886         view
2887         returns (uint)
2888     {
2889         return totalIssuanceData.lastAverageBalance;
2890     }
2891  
2892     function totalIssuanceLastModified()
2893         external
2894         view
2895         returns (uint)
2896     {
2897         return totalIssuanceData.lastModified;
2898     }
2899  
2900     /* ========== MUTATIVE FUNCTIONS ========== */
2901  
2902     /**
2903      * @notice ERC20 transfer function.
2904      */
2905     function transfer(address to, uint value)
2906         public
2907         optionalProxy
2908         returns (bool)
2909     {
2910         address sender = messageSender;
2911         require(nominsIssued[sender] == 0 || value <= transferableHavvens(sender));
2912         /* Perform the transfer: if there is a problem,
2913          * an exception will be thrown in this call. */
2914         _transfer_byProxy(sender, to, value);
2915  
2916         return true;
2917     }
2918  
2919     /**
2920      * @notice ERC20 transferFrom function.
2921      */
2922     function transferFrom(address from, address to, uint value)
2923         public
2924         optionalProxy
2925         returns (bool)
2926     {
2927         address sender = messageSender;
2928         require(nominsIssued[from] == 0 || value <= transferableHavvens(from));
2929         /* Perform the transfer: if there is a problem,
2930          * an exception will be thrown in this call. */
2931         _transferFrom_byProxy(sender, from, to, value);
2932  
2933         return true;
2934     }
2935  
2936     /**
2937      * @notice Compute the last period's fee entitlement for the message sender
2938      * and then deposit it into their nomin account.
2939      */
2940     function withdrawFees()
2941         external
2942         optionalProxy
2943     {
2944         address sender = messageSender;
2945         rolloverFeePeriodIfElapsed();
2946         /* Do not deposit fees into frozen accounts. */
2947         require(!nomin.frozen(sender));
2948  
2949         /* Check the period has rolled over first. */
2950         updateIssuanceData(sender, nominsIssued[sender], nomin.totalSupply());
2951  
2952         /* Only allow accounts to withdraw fees once per period. */
2953         require(!hasWithdrawnFees[sender]);
2954  
2955         uint feesOwed;
2956         uint lastTotalIssued = totalIssuanceData.lastAverageBalance;
2957  
2958         if (lastTotalIssued > 0) {
2959             /* Sender receives a share of last period's collected fees proportional
2960              * with their average fraction of the last period's issued nomins. */
2961             feesOwed = safeDiv_dec(
2962                 safeMul_dec(issuanceData[sender].lastAverageBalance, lastFeesCollected),
2963                 lastTotalIssued
2964             );
2965         }
2966  
2967         hasWithdrawnFees[sender] = true;
2968  
2969         if (feesOwed != 0) {
2970             nomin.withdrawFees(sender, feesOwed);
2971         }
2972         emitFeesWithdrawn(messageSender, feesOwed);
2973     }
2974  
2975     /**
2976      * @notice Update the havven balance averages since the last transfer
2977      * or entitlement adjustment.
2978      * @dev Since this updates the last transfer timestamp, if invoked
2979      * consecutively, this function will do nothing after the first call.
2980      * Also, this will adjust the total issuance at the same time.
2981      */
2982     function updateIssuanceData(address account, uint preBalance, uint lastTotalSupply)
2983         internal
2984     {
2985         /* update the total balances first */
2986         totalIssuanceData = computeIssuanceData(lastTotalSupply, totalIssuanceData);
2987  
2988         if (issuanceData[account].lastModified < feePeriodStartTime) {
2989             hasWithdrawnFees[account] = false;
2990         }
2991  
2992         issuanceData[account] = computeIssuanceData(preBalance, issuanceData[account]);
2993     }
2994  
2995  
2996     /**
2997      * @notice Compute the new IssuanceData on the old balance
2998      */
2999     function computeIssuanceData(uint preBalance, IssuanceData preIssuance)
3000         internal
3001         view
3002         returns (IssuanceData)
3003     {
3004  
3005         uint currentBalanceSum = preIssuance.currentBalanceSum;
3006         uint lastAverageBalance = preIssuance.lastAverageBalance;
3007         uint lastModified = preIssuance.lastModified;
3008  
3009         if (lastModified < feePeriodStartTime) {
3010             if (lastModified < lastFeePeriodStartTime) {
3011                 /* The balance was last updated before the previous fee period, so the average
3012                  * balance in this period is their pre-transfer balance. */
3013                 lastAverageBalance = preBalance;
3014             } else {
3015                 /* The balance was last updated during the previous fee period. */
3016                 /* No overflow or zero denominator problems, since lastFeePeriodStartTime < feePeriodStartTime < lastModified.
3017                  * implies these quantities are strictly positive. */
3018                 uint timeUpToRollover = feePeriodStartTime - lastModified;
3019                 uint lastFeePeriodDuration = feePeriodStartTime - lastFeePeriodStartTime;
3020                 uint lastBalanceSum = safeAdd(currentBalanceSum, safeMul(preBalance, timeUpToRollover));
3021                 lastAverageBalance = lastBalanceSum / lastFeePeriodDuration;
3022             }
3023             /* Roll over to the next fee period. */
3024             currentBalanceSum = safeMul(preBalance, now - feePeriodStartTime);
3025         } else {
3026             /* The balance was last updated during the current fee period. */
3027             currentBalanceSum = safeAdd(
3028                 currentBalanceSum,
3029                 safeMul(preBalance, now - lastModified)
3030             );
3031         }
3032  
3033         return IssuanceData(currentBalanceSum, lastAverageBalance, now);
3034     }
3035  
3036     /**
3037      * @notice Recompute and return the given account's last average balance.
3038      */
3039     function recomputeLastAverageBalance(address account)
3040         external
3041         returns (uint)
3042     {
3043         updateIssuanceData(account, nominsIssued[account], nomin.totalSupply());
3044         return issuanceData[account].lastAverageBalance;
3045     }
3046  
3047     /**
3048      * @notice Issue nomins against the sender's havvens.
3049      * @dev Issuance is only allowed if the havven price isn't stale and the sender is an issuer.
3050      */
3051     function issueNomins(uint amount)
3052         public
3053         optionalProxy
3054         requireIssuer(messageSender)
3055         /* No need to check if price is stale, as it is checked in issuableNomins. */
3056     {
3057         address sender = messageSender;
3058         require(amount <= remainingIssuableNomins(sender));
3059         uint lastTot = nomin.totalSupply();
3060         uint preIssued = nominsIssued[sender];
3061         nomin.issue(sender, amount);
3062         nominsIssued[sender] = safeAdd(preIssued, amount);
3063         updateIssuanceData(sender, preIssued, lastTot);
3064     }
3065  
3066     function issueMaxNomins()
3067         external
3068         optionalProxy
3069     {
3070         issueNomins(remainingIssuableNomins(messageSender));
3071     }
3072  
3073     /**
3074      * @notice Burn nomins to clear issued nomins/free havvens.
3075      */
3076     function burnNomins(uint amount)
3077         /* it doesn't matter if the price is stale or if the user is an issuer, as non-issuers have issued no nomins.*/
3078         external
3079         optionalProxy
3080     {
3081         address sender = messageSender;
3082  
3083         uint lastTot = nomin.totalSupply();
3084         uint preIssued = nominsIssued[sender];
3085         /* nomin.burn does a safeSub on balance (so it will revert if there are not enough nomins). */
3086         nomin.burn(sender, amount);
3087         /* This safe sub ensures amount <= number issued */
3088         nominsIssued[sender] = safeSub(preIssued, amount);
3089         updateIssuanceData(sender, preIssued, lastTot);
3090     }
3091  
3092     /**
3093      * @notice Check if the fee period has rolled over. If it has, set the new fee period start
3094      * time, and record the fees collected in the nomin contract.
3095      */
3096     function rolloverFeePeriodIfElapsed()
3097         public
3098     {
3099         /* If the fee period has rolled over... */
3100         if (now >= feePeriodStartTime + feePeriodDuration) {
3101             lastFeesCollected = nomin.feePool();
3102             lastFeePeriodStartTime = feePeriodStartTime;
3103             feePeriodStartTime = now;
3104             emitFeePeriodRollover(now);
3105         }
3106     }
3107  
3108     /* ========== Issuance/Burning ========== */
3109  
3110     /**
3111      * @notice The maximum nomins an issuer can issue against their total havven quantity. This ignores any
3112      * already issued nomins.
3113      */
3114     function maxIssuableNomins(address issuer)
3115         view
3116         public
3117         priceNotStale
3118         returns (uint)
3119     {
3120         if (!isIssuer[issuer]) {
3121             return 0;
3122         }
3123         if (escrow != HavvenEscrow(0)) {
3124             uint totalOwnedHavvens = safeAdd(tokenState.balanceOf(issuer), escrow.balanceOf(issuer));
3125             return safeMul_dec(HAVtoUSD(totalOwnedHavvens), issuanceRatio);
3126         } else {
3127             return safeMul_dec(HAVtoUSD(tokenState.balanceOf(issuer)), issuanceRatio);
3128         }
3129     }
3130  
3131     /**
3132      * @notice The remaining nomins an issuer can issue against their total havven quantity.
3133      */
3134     function remainingIssuableNomins(address issuer)
3135         view
3136         public
3137         returns (uint)
3138     {
3139         uint issued = nominsIssued[issuer];
3140         uint max = maxIssuableNomins(issuer);
3141         if (issued > max) {
3142             return 0;
3143         } else {
3144             return safeSub(max, issued);
3145         }
3146     }
3147  
3148     /**
3149      * @notice The total havvens owned by this account, both escrowed and unescrowed,
3150      * against which nomins can be issued.
3151      * This includes those already being used as collateral (locked), and those
3152      * available for further issuance (unlocked).
3153      */
3154     function collateral(address account)
3155         public
3156         view
3157         returns (uint)
3158     {
3159         uint bal = tokenState.balanceOf(account);
3160         if (escrow != address(0)) {
3161             bal = safeAdd(bal, escrow.balanceOf(account));
3162         }
3163         return bal;
3164     }
3165  
3166     /**
3167      * @notice The collateral that would be locked by issuance, which can exceed the account's actual collateral.
3168      */
3169     function issuanceDraft(address account)
3170         public
3171         view
3172         returns (uint)
3173     {
3174         uint issued = nominsIssued[account];
3175         if (issued == 0) {
3176             return 0;
3177         }
3178         return USDtoHAV(safeDiv_dec(issued, issuanceRatio));
3179     }
3180  
3181     /**
3182      * @notice Collateral that has been locked due to issuance, and cannot be
3183      * transferred to other addresses. This is capped at the account's total collateral.
3184      */
3185     function lockedCollateral(address account)
3186         public
3187         view
3188         returns (uint)
3189     {
3190         uint debt = issuanceDraft(account);
3191         uint collat = collateral(account);
3192         if (debt > collat) {
3193             return collat;
3194         }
3195         return debt;
3196     }
3197  
3198     /**
3199      * @notice Collateral that is not locked and available for issuance.
3200      */
3201     function unlockedCollateral(address account)
3202         public
3203         view
3204         returns (uint)
3205     {
3206         uint locked = lockedCollateral(account);
3207         uint collat = collateral(account);
3208         return safeSub(collat, locked);
3209     }
3210  
3211     /**
3212      * @notice The number of havvens that are free to be transferred by an account.
3213      * @dev If they have enough available Havvens, it could be that
3214      * their havvens are escrowed, however the transfer would then
3215      * fail. This means that escrowed havvens are locked first,
3216      * and then the actual transferable ones.
3217      */
3218     function transferableHavvens(address account)
3219         public
3220         view
3221         returns (uint)
3222     {
3223         uint draft = issuanceDraft(account);
3224         uint collat = collateral(account);
3225         // In the case where the issuanceDraft exceeds the collateral, nothing is free
3226         if (draft > collat) {
3227             return 0;
3228         }
3229  
3230         uint bal = balanceOf(account);
3231         // In the case where the draft exceeds the escrow, but not the whole collateral
3232         //   return the fraction of the balance that remains free
3233         if (draft > safeSub(collat, bal)) {
3234             return safeSub(collat, draft);
3235         }
3236         // In the case where the draft doesn't exceed the escrow, return the entire balance
3237         return bal;
3238     }
3239  
3240     /**
3241      * @notice The value in USD for a given amount of HAV
3242      */
3243     function HAVtoUSD(uint hav_dec)
3244         public
3245         view
3246         priceNotStale
3247         returns (uint)
3248     {
3249         return safeMul_dec(hav_dec, price);
3250     }
3251  
3252     /**
3253      * @notice The value in HAV for a given amount of USD
3254      */
3255     function USDtoHAV(uint usd_dec)
3256         public
3257         view
3258         priceNotStale
3259         returns (uint)
3260     {
3261         return safeDiv_dec(usd_dec, price);
3262     }
3263  
3264     /**
3265      * @notice Access point for the oracle to update the price of havvens.
3266      */
3267     function updatePrice(uint newPrice, uint timeSent)
3268         external
3269         onlyOracle  /* Should be callable only by the oracle. */
3270     {
3271         /* Must be the most recently sent price, but not too far in the future.
3272          * (so we can't lock ourselves out of updating the oracle for longer than this) */
3273         require(lastPriceUpdateTime < timeSent && timeSent < now + ORACLE_FUTURE_LIMIT);
3274  
3275         price = newPrice;
3276         lastPriceUpdateTime = timeSent;
3277         emitPriceUpdated(newPrice, timeSent);
3278  
3279         /* Check the fee period rollover within this as the price should be pushed every 15min. */
3280         rolloverFeePeriodIfElapsed();
3281     }
3282  
3283     /**
3284      * @notice Check if the price of havvens hasn't been updated for longer than the stale period.
3285      */
3286     function priceIsStale()
3287         public
3288         view
3289         returns (bool)
3290     {
3291         return safeAdd(lastPriceUpdateTime, priceStalePeriod) < now;
3292     }
3293  
3294     /* ========== MODIFIERS ========== */
3295  
3296     modifier requireIssuer(address account)
3297     {
3298         require(isIssuer[account]);
3299         _;
3300     }
3301  
3302     modifier onlyOracle
3303     {
3304         require(msg.sender == oracle);
3305         _;
3306     }
3307  
3308     modifier priceNotStale
3309     {
3310         require(!priceIsStale());
3311         _;
3312     }
3313  
3314     /* ========== EVENTS ========== */
3315  
3316     event PriceUpdated(uint newPrice, uint timestamp);
3317     bytes32 constant PRICEUPDATED_SIG = keccak256("PriceUpdated(uint256,uint256)");
3318     function emitPriceUpdated(uint newPrice, uint timestamp) internal {
3319         proxy._emit(abi.encode(newPrice, timestamp), 1, PRICEUPDATED_SIG, 0, 0, 0);
3320     }
3321  
3322     event IssuanceRatioUpdated(uint newRatio);
3323     bytes32 constant ISSUANCERATIOUPDATED_SIG = keccak256("IssuanceRatioUpdated(uint256)");
3324     function emitIssuanceRatioUpdated(uint newRatio) internal {
3325         proxy._emit(abi.encode(newRatio), 1, ISSUANCERATIOUPDATED_SIG, 0, 0, 0);
3326     }
3327  
3328     event FeePeriodRollover(uint timestamp);
3329     bytes32 constant FEEPERIODROLLOVER_SIG = keccak256("FeePeriodRollover(uint256)");
3330     function emitFeePeriodRollover(uint timestamp) internal {
3331         proxy._emit(abi.encode(timestamp), 1, FEEPERIODROLLOVER_SIG, 0, 0, 0);
3332     }
3333  
3334     event FeePeriodDurationUpdated(uint duration);
3335     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
3336     function emitFeePeriodDurationUpdated(uint duration) internal {
3337         proxy._emit(abi.encode(duration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
3338     }
3339  
3340     event FeesWithdrawn(address indexed account, uint value);
3341     bytes32 constant FEESWITHDRAWN_SIG = keccak256("FeesWithdrawn(address,uint256)");
3342     function emitFeesWithdrawn(address account, uint value) internal {
3343         proxy._emit(abi.encode(value), 2, FEESWITHDRAWN_SIG, bytes32(account), 0, 0);
3344     }
3345  
3346     event OracleUpdated(address newOracle);
3347     bytes32 constant ORACLEUPDATED_SIG = keccak256("OracleUpdated(address)");
3348     function emitOracleUpdated(address newOracle) internal {
3349         proxy._emit(abi.encode(newOracle), 1, ORACLEUPDATED_SIG, 0, 0, 0);
3350     }
3351  
3352     event NominUpdated(address newNomin);
3353     bytes32 constant NOMINUPDATED_SIG = keccak256("NominUpdated(address)");
3354     function emitNominUpdated(address newNomin) internal {
3355         proxy._emit(abi.encode(newNomin), 1, NOMINUPDATED_SIG, 0, 0, 0);
3356     }
3357  
3358     event EscrowUpdated(address newEscrow);
3359     bytes32 constant ESCROWUPDATED_SIG = keccak256("EscrowUpdated(address)");
3360     function emitEscrowUpdated(address newEscrow) internal {
3361         proxy._emit(abi.encode(newEscrow), 1, ESCROWUPDATED_SIG, 0, 0, 0);
3362     }
3363  
3364     event IssuersUpdated(address indexed account, bool indexed value);
3365     bytes32 constant ISSUERSUPDATED_SIG = keccak256("IssuersUpdated(address,bool)");
3366     function emitIssuersUpdated(address account, bool value) internal {
3367         proxy._emit(abi.encode(), 3, ISSUERSUPDATED_SIG, bytes32(account), bytes32(value ? 1 : 0), 0);
3368     }
3369  
3370 }