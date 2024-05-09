1 /*
2 -----------------------------------------------------------------
3 Synthetix
4 -----------------------------------------------------------------
5 
6 file:           Depot.sol
7 version:    3.2
8 author:     Kevin Brown
9 date:          2018-10-23
10 
11 -----------------------------------------------------------------
12 MODULE DESCRIPTION
13 -----------------------------------------------------------------
14 
15 Depot contract. The Depot provides
16 a way for users to acquire synths (Synth.sol) and SNX
17 (Synthetix.sol) by paying ETH and a way for users to acquire SNX
18 (Synthetix.sol) by paying synths. Users can also deposit their synths
19 and allow other users to purchase them with ETH. The ETH is sent
20 to the user who offered their synths for sale.
21 
22 This smart contract contains a balance of each token, and
23 allows the owner of the contract (the Synthetix Foundation) to
24 manage the available balance of synthetix at their discretion, while
25 users are allowed to deposit and withdraw their own synth deposits
26 if they have not yet been taken up by another user.
27 
28 -----------------------------------------------------------------
29 
30 
31 /*
32  *
33  * MIT License
34  * ===========
35  *
36  * Copyright (c) 2018 Synthetix
37  *
38  * Permission is hereby granted, free of charge, to any person obtaining a copy
39  * of this software and associated documentation files (the "Software"), to deal
40  * in the Software without restriction, including without limitation the rights
41  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
42  * copies of the Software, and to permit persons to whom the Software is
43  * furnished to do so, subject to the following conditions:
44  *
45  * The above copyright notice and this permission notice shall be included in all
46  * copies or substantial portions of the Software.
47  *
48  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
49  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
50  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
51  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
52  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
53  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
54 */
55 
56 
57 ////////////////// Owned.sol //////////////////
58 
59 /*
60 -----------------------------------------------------------------
61 FILE INFORMATION
62 -----------------------------------------------------------------
63 
64 file:       Owned.sol
65 version:    1.1
66 author:     Anton Jurisevic
67             Dominic Romanowski
68 
69 date:       2018-2-26
70 
71 -----------------------------------------------------------------
72 MODULE DESCRIPTION
73 -----------------------------------------------------------------
74 
75 An Owned contract, to be inherited by other contracts.
76 Requires its owner to be explicitly set in the constructor.
77 Provides an onlyOwner access modifier.
78 
79 To change owner, the current owner must nominate the next owner,
80 who then has to accept the nomination. The nomination can be
81 cancelled before it is accepted by the new owner by having the
82 previous owner change the nomination (setting it to 0).
83 
84 -----------------------------------------------------------------
85 */
86 
87 pragma solidity 0.4.25;
88 
89 /**
90  * @title A contract with an owner.
91  * @notice Contract ownership can be transferred by first nominating the new owner,
92  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
93  */
94 contract Owned {
95     address public owner;
96     address public nominatedOwner;
97 
98     /**
99      * @dev Owned Constructor
100      */
101     constructor(address _owner)
102         public
103     {
104         require(_owner != address(0), "Owner address cannot be 0");
105         owner = _owner;
106         emit OwnerChanged(address(0), _owner);
107     }
108 
109     /**
110      * @notice Nominate a new owner of this contract.
111      * @dev Only the current owner may nominate a new owner.
112      */
113     function nominateNewOwner(address _owner)
114         external
115         onlyOwner
116     {
117         nominatedOwner = _owner;
118         emit OwnerNominated(_owner);
119     }
120 
121     /**
122      * @notice Accept the nomination to be owner.
123      */
124     function acceptOwnership()
125         external
126     {
127         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
128         emit OwnerChanged(owner, nominatedOwner);
129         owner = nominatedOwner;
130         nominatedOwner = address(0);
131     }
132 
133     modifier onlyOwner
134     {
135         require(msg.sender == owner, "Only the contract owner may perform this action");
136         _;
137     }
138 
139     event OwnerNominated(address newOwner);
140     event OwnerChanged(address oldOwner, address newOwner);
141 }
142 
143 ////////////////// SelfDestructible.sol //////////////////
144 
145 /*
146 -----------------------------------------------------------------
147 FILE INFORMATION
148 -----------------------------------------------------------------
149 
150 file:       SelfDestructible.sol
151 version:    1.2
152 author:     Anton Jurisevic
153 
154 date:       2018-05-29
155 
156 -----------------------------------------------------------------
157 MODULE DESCRIPTION
158 -----------------------------------------------------------------
159 
160 This contract allows an inheriting contract to be destroyed after
161 its owner indicates an intention and then waits for a period
162 without changing their mind. All ether contained in the contract
163 is forwarded to a nominated beneficiary upon destruction.
164 
165 -----------------------------------------------------------------
166 */
167 
168 
169 /**
170  * @title A contract that can be destroyed by its owner after a delay elapses.
171  */
172 contract SelfDestructible is Owned {
173     
174     uint public initiationTime;
175     bool public selfDestructInitiated;
176     address public selfDestructBeneficiary;
177     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
178 
179     /**
180      * @dev Constructor
181      * @param _owner The account which controls this contract.
182      */
183     constructor(address _owner)
184         Owned(_owner)
185         public
186     {
187         require(_owner != address(0), "Owner must not be the zero address");
188         selfDestructBeneficiary = _owner;
189         emit SelfDestructBeneficiaryUpdated(_owner);
190     }
191 
192     /**
193      * @notice Set the beneficiary address of this contract.
194      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
195      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
196      */
197     function setSelfDestructBeneficiary(address _beneficiary)
198         external
199         onlyOwner
200     {
201         require(_beneficiary != address(0), "Beneficiary must not be the zero address");
202         selfDestructBeneficiary = _beneficiary;
203         emit SelfDestructBeneficiaryUpdated(_beneficiary);
204     }
205 
206     /**
207      * @notice Begin the self-destruction counter of this contract.
208      * Once the delay has elapsed, the contract may be self-destructed.
209      * @dev Only the contract owner may call this.
210      */
211     function initiateSelfDestruct()
212         external
213         onlyOwner
214     {
215         initiationTime = now;
216         selfDestructInitiated = true;
217         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
218     }
219 
220     /**
221      * @notice Terminate and reset the self-destruction timer.
222      * @dev Only the contract owner may call this.
223      */
224     function terminateSelfDestruct()
225         external
226         onlyOwner
227     {
228         initiationTime = 0;
229         selfDestructInitiated = false;
230         emit SelfDestructTerminated();
231     }
232 
233     /**
234      * @notice If the self-destruction delay has elapsed, destroy this contract and
235      * remit any ether it owns to the beneficiary address.
236      * @dev Only the contract owner may call this.
237      */
238     function selfDestruct()
239         external
240         onlyOwner
241     {
242         require(selfDestructInitiated, "Self destruct has not yet been initiated");
243         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay has not yet elapsed");
244         address beneficiary = selfDestructBeneficiary;
245         emit SelfDestructed(beneficiary);
246         selfdestruct(beneficiary);
247     }
248 
249     event SelfDestructTerminated();
250     event SelfDestructed(address beneficiary);
251     event SelfDestructInitiated(uint selfDestructDelay);
252     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
253 }
254 
255 
256 ////////////////// Pausable.sol //////////////////
257 
258 /*
259 -----------------------------------------------------------------
260 FILE INFORMATION
261 -----------------------------------------------------------------
262 
263 file:       Pausable.sol
264 version:    1.0
265 author:     Kevin Brown
266 
267 date:       2018-05-22
268 
269 -----------------------------------------------------------------
270 MODULE DESCRIPTION
271 -----------------------------------------------------------------
272 
273 This contract allows an inheriting contract to be marked as
274 paused. It also defines a modifier which can be used by the
275 inheriting contract to prevent actions while paused.
276 
277 -----------------------------------------------------------------
278 */
279 
280 
281 /**
282  * @title A contract that can be paused by its owner
283  */
284 contract Pausable is Owned {
285     
286     uint public lastPauseTime;
287     bool public paused;
288 
289     /**
290      * @dev Constructor
291      * @param _owner The account which controls this contract.
292      */
293     constructor(address _owner)
294         Owned(_owner)
295         public
296     {
297         // Paused will be false, and lastPauseTime will be 0 upon initialisation
298     }
299 
300     /**
301      * @notice Change the paused state of the contract
302      * @dev Only the contract owner may call this.
303      */
304     function setPaused(bool _paused)
305         external
306         onlyOwner
307     {
308         // Ensure we're actually changing the state before we do anything
309         if (_paused == paused) {
310             return;
311         }
312 
313         // Set our paused state.
314         paused = _paused;
315         
316         // If applicable, set the last pause time.
317         if (paused) {
318             lastPauseTime = now;
319         }
320 
321         // Let everyone know that our pause state has changed.
322         emit PauseChanged(paused);
323     }
324 
325     event PauseChanged(bool isPaused);
326 
327     modifier notPaused {
328         require(!paused, "This action cannot be performed while the contract is paused");
329         _;
330     }
331 }
332 
333 
334 ////////////////// SafeMath.sol //////////////////
335 
336 
337 /**
338  * @title SafeMath
339  * @dev Math operations with safety checks that revert on error
340  */
341 library SafeMath {
342 
343   /**
344   * @dev Multiplies two numbers, reverts on overflow.
345   */
346   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
347     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
348     // benefit is lost if 'b' is also tested.
349     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
350     if (a == 0) {
351       return 0;
352     }
353 
354     uint256 c = a * b;
355     require(c / a == b);
356 
357     return c;
358   }
359 
360   /**
361   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
362   */
363   function div(uint256 a, uint256 b) internal pure returns (uint256) {
364     require(b > 0); // Solidity only automatically asserts when dividing by 0
365     uint256 c = a / b;
366     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
367 
368     return c;
369   }
370 
371   /**
372   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
373   */
374   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
375     require(b <= a);
376     uint256 c = a - b;
377 
378     return c;
379   }
380 
381   /**
382   * @dev Adds two numbers, reverts on overflow.
383   */
384   function add(uint256 a, uint256 b) internal pure returns (uint256) {
385     uint256 c = a + b;
386     require(c >= a);
387 
388     return c;
389   }
390 
391   /**
392   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
393   * reverts when dividing by zero.
394   */
395   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
396     require(b != 0);
397     return a % b;
398   }
399 }
400 
401 
402 ////////////////// SafeDecimalMath.sol //////////////////
403 
404 /*
405 
406 -----------------------------------------------------------------
407 FILE INFORMATION
408 -----------------------------------------------------------------
409 
410 file:       SafeDecimalMath.sol
411 version:    2.0
412 author:     Kevin Brown
413             Gavin Conway
414 date:       2018-10-18
415 
416 -----------------------------------------------------------------
417 MODULE DESCRIPTION
418 -----------------------------------------------------------------
419 
420 A library providing safe mathematical operations for division and
421 multiplication with the capability to round or truncate the results
422 to the nearest increment. Operations can return a standard precision
423 or high precision decimal. High precision decimals are useful for
424 example when attempting to calculate percentages or fractions
425 accurately.
426 
427 -----------------------------------------------------------------
428 */
429 
430 
431 /**
432  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
433  * @dev Functions accepting uints in this contract and derived contracts
434  * are taken to be such fixed point decimals of a specified precision (either standard
435  * or high).
436  */
437 library SafeDecimalMath {
438 
439     using SafeMath for uint;
440 
441     /* Number of decimal places in the representations. */
442     uint8 public constant decimals = 18;
443     uint8 public constant highPrecisionDecimals = 27;
444 
445     /* The number representing 1.0. */
446     uint public constant UNIT = 10 ** uint(decimals);
447 
448     /* The number representing 1.0 for higher fidelity numbers. */
449     uint public constant PRECISE_UNIT = 10 ** uint(highPrecisionDecimals);
450     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10 ** uint(highPrecisionDecimals - decimals);
451 
452     /** 
453      * @return Provides an interface to UNIT.
454      */
455     function unit()
456         external
457         pure
458         returns (uint)
459     {
460         return UNIT;
461     }
462 
463     /** 
464      * @return Provides an interface to PRECISE_UNIT.
465      */
466     function preciseUnit()
467         external
468         pure 
469         returns (uint)
470     {
471         return PRECISE_UNIT;
472     }
473 
474     /**
475      * @return The result of multiplying x and y, interpreting the operands as fixed-point
476      * decimals.
477      * 
478      * @dev A unit factor is divided out after the product of x and y is evaluated,
479      * so that product must be less than 2**256. As this is an integer division,
480      * the internal division always rounds down. This helps save on gas. Rounding
481      * is more expensive on gas.
482      */
483     function multiplyDecimal(uint x, uint y)
484         internal
485         pure
486         returns (uint)
487     {
488         /* Divide by UNIT to remove the extra factor introduced by the product. */
489         return x.mul(y) / UNIT;
490     }
491 
492     /**
493      * @return The result of safely multiplying x and y, interpreting the operands
494      * as fixed-point decimals of the specified precision unit.
495      *
496      * @dev The operands should be in the form of a the specified unit factor which will be
497      * divided out after the product of x and y is evaluated, so that product must be
498      * less than 2**256.
499      *
500      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
501      * Rounding is useful when you need to retain fidelity for small decimal numbers
502      * (eg. small fractions or percentages).
503      */
504     function _multiplyDecimalRound(uint x, uint y, uint precisionUnit)
505         private
506         pure
507         returns (uint)
508     {
509         /* Divide by UNIT to remove the extra factor introduced by the product. */
510         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
511 
512         if (quotientTimesTen % 10 >= 5) {
513             quotientTimesTen += 10;
514         }
515 
516         return quotientTimesTen / 10;
517     }
518 
519     /**
520      * @return The result of safely multiplying x and y, interpreting the operands
521      * as fixed-point decimals of a precise unit.
522      *
523      * @dev The operands should be in the precise unit factor which will be
524      * divided out after the product of x and y is evaluated, so that product must be
525      * less than 2**256.
526      *
527      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
528      * Rounding is useful when you need to retain fidelity for small decimal numbers
529      * (eg. small fractions or percentages).
530      */
531     function multiplyDecimalRoundPrecise(uint x, uint y)
532         internal
533         pure
534         returns (uint)
535     {
536         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
537     }
538 
539     /**
540      * @return The result of safely multiplying x and y, interpreting the operands
541      * as fixed-point decimals of a standard unit.
542      *
543      * @dev The operands should be in the standard unit factor which will be
544      * divided out after the product of x and y is evaluated, so that product must be
545      * less than 2**256.
546      *
547      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
548      * Rounding is useful when you need to retain fidelity for small decimal numbers
549      * (eg. small fractions or percentages).
550      */
551     function multiplyDecimalRound(uint x, uint y)
552         internal
553         pure
554         returns (uint)
555     {
556         return _multiplyDecimalRound(x, y, UNIT);
557     }
558 
559     /**
560      * @return The result of safely dividing x and y. The return value is a high
561      * precision decimal.
562      * 
563      * @dev y is divided after the product of x and the standard precision unit
564      * is evaluated, so the product of x and UNIT must be less than 2**256. As
565      * this is an integer division, the result is always rounded down.
566      * This helps save on gas. Rounding is more expensive on gas.
567      */
568     function divideDecimal(uint x, uint y)
569         internal
570         pure
571         returns (uint)
572     {
573         /* Reintroduce the UNIT factor that will be divided out by y. */
574         return x.mul(UNIT).div(y);
575     }
576 
577     /**
578      * @return The result of safely dividing x and y. The return value is as a rounded
579      * decimal in the precision unit specified in the parameter.
580      *
581      * @dev y is divided after the product of x and the specified precision unit
582      * is evaluated, so the product of x and the specified precision unit must
583      * be less than 2**256. The result is rounded to the nearest increment.
584      */
585     function _divideDecimalRound(uint x, uint y, uint precisionUnit)
586         private
587         pure
588         returns (uint)
589     {
590         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
591 
592         if (resultTimesTen % 10 >= 5) {
593             resultTimesTen += 10;
594         }
595 
596         return resultTimesTen / 10;
597     }
598 
599     /**
600      * @return The result of safely dividing x and y. The return value is as a rounded
601      * standard precision decimal.
602      *
603      * @dev y is divided after the product of x and the standard precision unit
604      * is evaluated, so the product of x and the standard precision unit must
605      * be less than 2**256. The result is rounded to the nearest increment.
606      */
607     function divideDecimalRound(uint x, uint y)
608         internal
609         pure
610         returns (uint)
611     {
612         return _divideDecimalRound(x, y, UNIT);
613     }
614 
615     /**
616      * @return The result of safely dividing x and y. The return value is as a rounded
617      * high precision decimal.
618      *
619      * @dev y is divided after the product of x and the high precision unit
620      * is evaluated, so the product of x and the high precision unit must
621      * be less than 2**256. The result is rounded to the nearest increment.
622      */
623     function divideDecimalRoundPrecise(uint x, uint y)
624         internal
625         pure
626         returns (uint)
627     {
628         return _divideDecimalRound(x, y, PRECISE_UNIT);
629     }
630 
631     /**
632      * @dev Convert a standard decimal representation to a high precision one.
633      */
634     function decimalToPreciseDecimal(uint i)
635         internal
636         pure
637         returns (uint)
638     {
639         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
640     }
641 
642     /**
643      * @dev Convert a high precision decimal to a standard decimal representation.
644      */
645     function preciseDecimalToDecimal(uint i)
646         internal
647         pure
648         returns (uint)
649     {
650         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
651 
652         if (quotientTimesTen % 10 >= 5) {
653             quotientTimesTen += 10;
654         }
655 
656         return quotientTimesTen / 10;
657     }
658 
659 }
660 
661 
662 ////////////////// Proxy.sol //////////////////
663 
664 /*
665 -----------------------------------------------------------------
666 FILE INFORMATION
667 -----------------------------------------------------------------
668 
669 file:       Proxy.sol
670 version:    1.3
671 author:     Anton Jurisevic
672 
673 date:       2018-05-29
674 
675 -----------------------------------------------------------------
676 MODULE DESCRIPTION
677 -----------------------------------------------------------------
678 
679 A proxy contract that, if it does not recognise the function
680 being called on it, passes all value and call data to an
681 underlying target contract.
682 
683 This proxy has the capacity to toggle between DELEGATECALL
684 and CALL style proxy functionality.
685 
686 The former executes in the proxy's context, and so will preserve 
687 msg.sender and store data at the proxy address. The latter will not.
688 Therefore, any contract the proxy wraps in the CALL style must
689 implement the Proxyable interface, in order that it can pass msg.sender
690 into the underlying contract as the state parameter, messageSender.
691 
692 -----------------------------------------------------------------
693 */
694 
695 
696 contract Proxy is Owned {
697 
698     Proxyable public target;
699     bool public useDELEGATECALL;
700 
701     constructor(address _owner)
702         Owned(_owner)
703         public
704     {}
705 
706     function setTarget(Proxyable _target)
707         external
708         onlyOwner
709     {
710         target = _target;
711         emit TargetUpdated(_target);
712     }
713 
714     function setUseDELEGATECALL(bool value) 
715         external
716         onlyOwner
717     {
718         useDELEGATECALL = value;
719     }
720 
721     function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)
722         external
723         onlyTarget
724     {
725         uint size = callData.length;
726         bytes memory _callData = callData;
727 
728         assembly {
729             /* The first 32 bytes of callData contain its length (as specified by the abi). 
730              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
731              * in length. It is also leftpadded to be a multiple of 32 bytes.
732              * This means moving call_data across 32 bytes guarantees we correctly access
733              * the data itself. */
734             switch numTopics
735             case 0 {
736                 log0(add(_callData, 32), size)
737             } 
738             case 1 {
739                 log1(add(_callData, 32), size, topic1)
740             }
741             case 2 {
742                 log2(add(_callData, 32), size, topic1, topic2)
743             }
744             case 3 {
745                 log3(add(_callData, 32), size, topic1, topic2, topic3)
746             }
747             case 4 {
748                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
749             }
750         }
751     }
752 
753     function()
754         external
755         payable
756     {
757         if (useDELEGATECALL) {
758             assembly {
759                 /* Copy call data into free memory region. */
760                 let free_ptr := mload(0x40)
761                 calldatacopy(free_ptr, 0, calldatasize)
762 
763                 /* Forward all gas and call data to the target contract. */
764                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
765                 returndatacopy(free_ptr, 0, returndatasize)
766 
767                 /* Revert if the call failed, otherwise return the result. */
768                 if iszero(result) { revert(free_ptr, returndatasize) }
769                 return(free_ptr, returndatasize)
770             }
771         } else {
772             /* Here we are as above, but must send the messageSender explicitly 
773              * since we are using CALL rather than DELEGATECALL. */
774             target.setMessageSender(msg.sender);
775             assembly {
776                 let free_ptr := mload(0x40)
777                 calldatacopy(free_ptr, 0, calldatasize)
778 
779                 /* We must explicitly forward ether to the underlying contract as well. */
780                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
781                 returndatacopy(free_ptr, 0, returndatasize)
782 
783                 if iszero(result) { revert(free_ptr, returndatasize) }
784                 return(free_ptr, returndatasize)
785             }
786         }
787     }
788 
789     modifier onlyTarget {
790         require(Proxyable(msg.sender) == target, "Must be proxy target");
791         _;
792     }
793 
794     event TargetUpdated(Proxyable newTarget);
795 }
796 
797 
798 ////////////////// Proxyable.sol //////////////////
799 
800 /*
801 -----------------------------------------------------------------
802 FILE INFORMATION
803 -----------------------------------------------------------------
804 
805 file:       Proxyable.sol
806 version:    1.1
807 author:     Anton Jurisevic
808 
809 date:       2018-05-15
810 
811 checked:    Mike Spain
812 approved:   Samuel Brooks
813 
814 -----------------------------------------------------------------
815 MODULE DESCRIPTION
816 -----------------------------------------------------------------
817 
818 A proxyable contract that works hand in hand with the Proxy contract
819 to allow for anyone to interact with the underlying contract both
820 directly and through the proxy.
821 
822 -----------------------------------------------------------------
823 */
824 
825 
826 // This contract should be treated like an abstract contract
827 contract Proxyable is Owned {
828     /* The proxy this contract exists behind. */
829     Proxy public proxy;
830 
831     /* The caller of the proxy, passed through to this contract.
832      * Note that every function using this member must apply the onlyProxy or
833      * optionalProxy modifiers, otherwise their invocations can use stale values. */ 
834     address messageSender; 
835 
836     constructor(address _proxy, address _owner)
837         Owned(_owner)
838         public
839     {
840         proxy = Proxy(_proxy);
841         emit ProxyUpdated(_proxy);
842     }
843 
844     function setProxy(address _proxy)
845         external
846         onlyOwner
847     {
848         proxy = Proxy(_proxy);
849         emit ProxyUpdated(_proxy);
850     }
851 
852     function setMessageSender(address sender)
853         external
854         onlyProxy
855     {
856         messageSender = sender;
857     }
858 
859     modifier onlyProxy {
860         require(Proxy(msg.sender) == proxy, "Only the proxy can call this function");
861         _;
862     }
863 
864     modifier optionalProxy
865     {
866         if (Proxy(msg.sender) != proxy) {
867             messageSender = msg.sender;
868         }
869         _;
870     }
871 
872     modifier optionalProxy_onlyOwner
873     {
874         if (Proxy(msg.sender) != proxy) {
875             messageSender = msg.sender;
876         }
877         require(messageSender == owner, "This action can only be performed by the owner");
878         _;
879     }
880 
881     event ProxyUpdated(address proxyAddress);
882 }
883 
884 
885 ////////////////// State.sol //////////////////
886 
887 /*
888 -----------------------------------------------------------------
889 FILE INFORMATION
890 -----------------------------------------------------------------
891 
892 file:       State.sol
893 version:    1.1
894 author:     Dominic Romanowski
895             Anton Jurisevic
896 
897 date:       2018-05-15
898 
899 -----------------------------------------------------------------
900 MODULE DESCRIPTION
901 -----------------------------------------------------------------
902 
903 This contract is used side by side with external state token
904 contracts, such as Synthetix and Synth.
905 It provides an easy way to upgrade contract logic while
906 maintaining all user balances and allowances. This is designed
907 to make the changeover as easy as possible, since mappings
908 are not so cheap or straightforward to migrate.
909 
910 The first deployed contract would create this state contract,
911 using it as its store of balances.
912 When a new contract is deployed, it links to the existing
913 state contract, whose owner would then change its associated
914 contract to the new one.
915 
916 -----------------------------------------------------------------
917 */
918 
919 
920 contract State is Owned {
921     // the address of the contract that can modify variables
922     // this can only be changed by the owner of this contract
923     address public associatedContract;
924 
925 
926     constructor(address _owner, address _associatedContract)
927         Owned(_owner)
928         public
929     {
930         associatedContract = _associatedContract;
931         emit AssociatedContractUpdated(_associatedContract);
932     }
933 
934     /* ========== SETTERS ========== */
935 
936     // Change the associated contract to a new address
937     function setAssociatedContract(address _associatedContract)
938         external
939         onlyOwner
940     {
941         associatedContract = _associatedContract;
942         emit AssociatedContractUpdated(_associatedContract);
943     }
944 
945     /* ========== MODIFIERS ========== */
946 
947     modifier onlyAssociatedContract
948     {
949         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
950         _;
951     }
952 
953     /* ========== EVENTS ========== */
954 
955     event AssociatedContractUpdated(address associatedContract);
956 }
957 
958 
959 ////////////////// TokenState.sol //////////////////
960 
961 /*
962 -----------------------------------------------------------------
963 FILE INFORMATION
964 -----------------------------------------------------------------
965 
966 file:       TokenState.sol
967 version:    1.1
968 author:     Dominic Romanowski
969             Anton Jurisevic
970 
971 date:       2018-05-15
972 
973 -----------------------------------------------------------------
974 MODULE DESCRIPTION
975 -----------------------------------------------------------------
976 
977 A contract that holds the state of an ERC20 compliant token.
978 
979 This contract is used side by side with external state token
980 contracts, such as Synthetix and Synth.
981 It provides an easy way to upgrade contract logic while
982 maintaining all user balances and allowances. This is designed
983 to make the changeover as easy as possible, since mappings
984 are not so cheap or straightforward to migrate.
985 
986 The first deployed contract would create this state contract,
987 using it as its store of balances.
988 When a new contract is deployed, it links to the existing
989 state contract, whose owner would then change its associated
990 contract to the new one.
991 
992 -----------------------------------------------------------------
993 */
994 
995 
996 /**
997  * @title ERC20 Token State
998  * @notice Stores balance information of an ERC20 token contract.
999  */
1000 contract TokenState is State {
1001 
1002     /* ERC20 fields. */
1003     mapping(address => uint) public balanceOf;
1004     mapping(address => mapping(address => uint)) public allowance;
1005 
1006     /**
1007      * @dev Constructor
1008      * @param _owner The address which controls this contract.
1009      * @param _associatedContract The ERC20 contract whose state this composes.
1010      */
1011     constructor(address _owner, address _associatedContract)
1012         State(_owner, _associatedContract)
1013         public
1014     {}
1015 
1016     /* ========== SETTERS ========== */
1017 
1018     /**
1019      * @notice Set ERC20 allowance.
1020      * @dev Only the associated contract may call this.
1021      * @param tokenOwner The authorising party.
1022      * @param spender The authorised party.
1023      * @param value The total value the authorised party may spend on the
1024      * authorising party's behalf.
1025      */
1026     function setAllowance(address tokenOwner, address spender, uint value)
1027         external
1028         onlyAssociatedContract
1029     {
1030         allowance[tokenOwner][spender] = value;
1031     }
1032 
1033     /**
1034      * @notice Set the balance in a given account
1035      * @dev Only the associated contract may call this.
1036      * @param account The account whose value to set.
1037      * @param value The new balance of the given account.
1038      */
1039     function setBalanceOf(address account, uint value)
1040         external
1041         onlyAssociatedContract
1042     {
1043         balanceOf[account] = value;
1044     }
1045 }
1046 
1047 
1048 ////////////////// ReentrancyPreventer.sol //////////////////
1049 
1050 /*
1051 -----------------------------------------------------------------
1052 FILE INFORMATION
1053 -----------------------------------------------------------------
1054 
1055 file:       ExternStateToken.sol
1056 version:    1.0
1057 author:     Kevin Brown
1058 date:       2018-08-06
1059 
1060 -----------------------------------------------------------------
1061 MODULE DESCRIPTION
1062 -----------------------------------------------------------------
1063 
1064 This contract offers a modifer that can prevent reentrancy on
1065 particular actions. It will not work if you put it on multiple
1066 functions that can be called from each other. Specifically guard
1067 external entry points to the contract with the modifier only.
1068 
1069 -----------------------------------------------------------------
1070 */
1071 
1072 
1073 contract ReentrancyPreventer {
1074     /* ========== MODIFIERS ========== */
1075     bool isInFunctionBody = false;
1076 
1077     modifier preventReentrancy {
1078         require(!isInFunctionBody, "Reverted to prevent reentrancy");
1079         isInFunctionBody = true;
1080         _;
1081         isInFunctionBody = false;
1082     }
1083 }
1084 
1085 ////////////////// TokenFallbackCaller.sol //////////////////
1086 
1087 /*
1088 -----------------------------------------------------------------
1089 FILE INFORMATION
1090 -----------------------------------------------------------------
1091 
1092 file:       TokenFallback.sol
1093 version:    1.0
1094 author:     Kevin Brown
1095 date:       2018-08-10
1096 
1097 -----------------------------------------------------------------
1098 MODULE DESCRIPTION
1099 -----------------------------------------------------------------
1100 
1101 This contract provides the logic that's used to call tokenFallback()
1102 when transfers happen.
1103 
1104 It's pulled out into its own module because it's needed in two
1105 places, so instead of copy/pasting this logic and maininting it
1106 both in Fee Token and Extern State Token, it's here and depended
1107 on by both contracts.
1108 
1109 -----------------------------------------------------------------
1110 */
1111 
1112 
1113 contract TokenFallbackCaller is ReentrancyPreventer {
1114     function callTokenFallbackIfNeeded(address sender, address recipient, uint amount, bytes data)
1115         internal
1116         preventReentrancy
1117     {
1118         /*
1119             If we're transferring to a contract and it implements the tokenFallback function, call it.
1120             This isn't ERC223 compliant because we don't revert if the contract doesn't implement tokenFallback.
1121             This is because many DEXes and other contracts that expect to work with the standard
1122             approve / transferFrom workflow don't implement tokenFallback but can still process our tokens as
1123             usual, so it feels very harsh and likely to cause trouble if we add this restriction after having
1124             previously gone live with a vanilla ERC20.
1125         */
1126 
1127         // Is the to address a contract? We can check the code size on that address and know.
1128         uint length;
1129 
1130         // solium-disable-next-line security/no-inline-assembly
1131         assembly {
1132             // Retrieve the size of the code on the recipient address
1133             length := extcodesize(recipient)
1134         }
1135 
1136         // If there's code there, it's a contract
1137         if (length > 0) {
1138             // Now we need to optionally call tokenFallback(address from, uint value).
1139             // We can't call it the normal way because that reverts when the recipient doesn't implement the function.
1140 
1141             // solium-disable-next-line security/no-low-level-calls
1142             recipient.call(abi.encodeWithSignature("tokenFallback(address,uint256,bytes)", sender, amount, data));
1143 
1144             // And yes, we specifically don't care if this call fails, so we're not checking the return value.
1145         }
1146     }
1147 }
1148 
1149 
1150 ////////////////// ExternStateToken.sol //////////////////
1151 
1152 /*
1153 -----------------------------------------------------------------
1154 FILE INFORMATION
1155 -----------------------------------------------------------------
1156 
1157 file:       ExternStateToken.sol
1158 version:    1.3
1159 author:     Anton Jurisevic
1160             Dominic Romanowski
1161             Kevin Brown
1162 
1163 date:       2018-05-29
1164 
1165 -----------------------------------------------------------------
1166 MODULE DESCRIPTION
1167 -----------------------------------------------------------------
1168 
1169 A partial ERC20 token contract, designed to operate with a proxy.
1170 To produce a complete ERC20 token, transfer and transferFrom
1171 tokens must be implemented, using the provided _byProxy internal
1172 functions.
1173 This contract utilises an external state for upgradeability.
1174 
1175 -----------------------------------------------------------------
1176 */
1177 
1178 
1179 /**
1180  * @title ERC20 Token contract, with detached state and designed to operate behind a proxy.
1181  */
1182 contract ExternStateToken is SelfDestructible, Proxyable, TokenFallbackCaller {
1183 
1184     using SafeMath for uint;
1185     using SafeDecimalMath for uint;
1186 
1187     /* ========== STATE VARIABLES ========== */
1188 
1189     /* Stores balances and allowances. */
1190     TokenState public tokenState;
1191 
1192     /* Other ERC20 fields. */
1193     string public name;
1194     string public symbol;
1195     uint public totalSupply;
1196     uint8 public decimals;
1197 
1198     /**
1199      * @dev Constructor.
1200      * @param _proxy The proxy associated with this contract.
1201      * @param _name Token's ERC20 name.
1202      * @param _symbol Token's ERC20 symbol.
1203      * @param _totalSupply The total supply of the token.
1204      * @param _tokenState The TokenState contract address.
1205      * @param _owner The owner of this contract.
1206      */
1207     constructor(address _proxy, TokenState _tokenState,
1208                 string _name, string _symbol, uint _totalSupply,
1209                 uint8 _decimals, address _owner)
1210         SelfDestructible(_owner)
1211         Proxyable(_proxy, _owner)
1212         public
1213     {
1214         tokenState = _tokenState;
1215 
1216         name = _name;
1217         symbol = _symbol;
1218         totalSupply = _totalSupply;
1219         decimals = _decimals;
1220     }
1221 
1222     /* ========== VIEWS ========== */
1223 
1224     /**
1225      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
1226      * @param owner The party authorising spending of their funds.
1227      * @param spender The party spending tokenOwner's funds.
1228      */
1229     function allowance(address owner, address spender)
1230         public
1231         view
1232         returns (uint)
1233     {
1234         return tokenState.allowance(owner, spender);
1235     }
1236 
1237     /**
1238      * @notice Returns the ERC20 token balance of a given account.
1239      */
1240     function balanceOf(address account)
1241         public
1242         view
1243         returns (uint)
1244     {
1245         return tokenState.balanceOf(account);
1246     }
1247 
1248     /* ========== MUTATIVE FUNCTIONS ========== */
1249 
1250     /**
1251      * @notice Set the address of the TokenState contract.
1252      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
1253      * as balances would be unreachable.
1254      */ 
1255     function setTokenState(TokenState _tokenState)
1256         external
1257         optionalProxy_onlyOwner
1258     {
1259         tokenState = _tokenState;
1260         emitTokenStateUpdated(_tokenState);
1261     }
1262 
1263     function _internalTransfer(address from, address to, uint value, bytes data) 
1264         internal
1265         returns (bool)
1266     { 
1267         /* Disallow transfers to irretrievable-addresses. */
1268         require(to != address(0), "Cannot transfer to the 0 address");
1269         require(to != address(this), "Cannot transfer to the underlying contract");
1270         require(to != address(proxy), "Cannot transfer to the proxy contract");
1271 
1272         // Insufficient balance will be handled by the safe subtraction.
1273         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
1274         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
1275 
1276         // If the recipient is a contract, we need to call tokenFallback on it so they can do ERC223
1277         // actions when receiving our tokens. Unlike the standard, however, we don't revert if the
1278         // recipient contract doesn't implement tokenFallback.
1279         callTokenFallbackIfNeeded(from, to, value, data);
1280         
1281         // Emit a standard ERC20 transfer event
1282         emitTransfer(from, to, value);
1283 
1284         return true;
1285     }
1286 
1287     /**
1288      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
1289      * the onlyProxy or optionalProxy modifiers.
1290      */
1291     function _transfer_byProxy(address from, address to, uint value, bytes data)
1292         internal
1293         returns (bool)
1294     {
1295         return _internalTransfer(from, to, value, data);
1296     }
1297 
1298     /**
1299      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
1300      * possessing the optionalProxy or optionalProxy modifiers.
1301      */
1302     function _transferFrom_byProxy(address sender, address from, address to, uint value, bytes data)
1303         internal
1304         returns (bool)
1305     {
1306         /* Insufficient allowance will be handled by the safe subtraction. */
1307         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
1308         return _internalTransfer(from, to, value, data);
1309     }
1310 
1311     /**
1312      * @notice Approves spender to transfer on the message sender's behalf.
1313      */
1314     function approve(address spender, uint value)
1315         public
1316         optionalProxy
1317         returns (bool)
1318     {
1319         address sender = messageSender;
1320 
1321         tokenState.setAllowance(sender, spender, value);
1322         emitApproval(sender, spender, value);
1323         return true;
1324     }
1325 
1326     /* ========== EVENTS ========== */
1327 
1328     event Transfer(address indexed from, address indexed to, uint value);
1329     bytes32 constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
1330     function emitTransfer(address from, address to, uint value) internal {
1331         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, bytes32(from), bytes32(to), 0);
1332     }
1333 
1334     event Approval(address indexed owner, address indexed spender, uint value);
1335     bytes32 constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
1336     function emitApproval(address owner, address spender, uint value) internal {
1337         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, bytes32(owner), bytes32(spender), 0);
1338     }
1339 
1340     event TokenStateUpdated(address newTokenState);
1341     bytes32 constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
1342     function emitTokenStateUpdated(address newTokenState) internal {
1343         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
1344     }
1345 }
1346 
1347 
1348 ////////////////// Synth.sol //////////////////
1349 
1350 /*
1351 -----------------------------------------------------------------
1352 FILE INFORMATION
1353 -----------------------------------------------------------------
1354 
1355 file:       Synth.sol
1356 version:    2.0
1357 author:     Kevin Brown
1358 date:       2018-09-13
1359 
1360 -----------------------------------------------------------------
1361 MODULE DESCRIPTION
1362 -----------------------------------------------------------------
1363 
1364 Synthetix-backed stablecoin contract.
1365 
1366 This contract issues synths, which are tokens that mirror various
1367 flavours of fiat currency.
1368 
1369 Synths are issuable by Synthetix Network Token (SNX) holders who 
1370 have to lock up some value of their SNX to issue S * Cmax synths. 
1371 Where Cmax issome value less than 1.
1372 
1373 A configurable fee is charged on synth transfers and deposited
1374 into a common pot, which Synthetix holders may withdraw from once
1375 per fee period.
1376 
1377 -----------------------------------------------------------------
1378 */
1379 
1380 
1381 contract Synth is ExternStateToken {
1382 
1383     /* ========== STATE VARIABLES ========== */
1384 
1385     FeePool public feePool;
1386     Synthetix public synthetix;
1387 
1388     // Currency key which identifies this Synth to the Synthetix system
1389     bytes4 public currencyKey;
1390 
1391     uint8 constant DECIMALS = 18;
1392 
1393     /* ========== CONSTRUCTOR ========== */
1394 
1395     constructor(address _proxy, TokenState _tokenState, Synthetix _synthetix, FeePool _feePool,
1396         string _tokenName, string _tokenSymbol, address _owner, bytes4 _currencyKey
1397     )
1398         ExternStateToken(_proxy, _tokenState, _tokenName, _tokenSymbol, 0, DECIMALS, _owner)
1399         public
1400     {
1401         require(_proxy != 0, "_proxy cannot be 0");
1402         require(address(_synthetix) != 0, "_synthetix cannot be 0");
1403         require(address(_feePool) != 0, "_feePool cannot be 0");
1404         require(_owner != 0, "_owner cannot be 0");
1405         require(_synthetix.synths(_currencyKey) == Synth(0), "Currency key is already in use");
1406 
1407         feePool = _feePool;
1408         synthetix = _synthetix;
1409         currencyKey = _currencyKey;
1410     }
1411 
1412     /* ========== SETTERS ========== */
1413 
1414     function setSynthetix(Synthetix _synthetix)
1415         external
1416         optionalProxy_onlyOwner
1417     {
1418         synthetix = _synthetix;
1419         emitSynthetixUpdated(_synthetix);
1420     }
1421 
1422     function setFeePool(FeePool _feePool)
1423         external
1424         optionalProxy_onlyOwner
1425     {
1426         feePool = _feePool;
1427         emitFeePoolUpdated(_feePool);
1428     }
1429 
1430     /* ========== MUTATIVE FUNCTIONS ========== */
1431 
1432     /**
1433      * @notice Override ERC20 transfer function in order to 
1434      * subtract the transaction fee and send it to the fee pool
1435      * for SNX holders to claim. */
1436     function transfer(address to, uint value)
1437         public
1438         optionalProxy
1439         notFeeAddress(messageSender)
1440         returns (bool)
1441     {
1442         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1443         uint fee = value.sub(amountReceived);
1444 
1445         // Send the fee off to the fee pool.
1446         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1447 
1448         // And send their result off to the destination address
1449         bytes memory empty;
1450         return _internalTransfer(messageSender, to, amountReceived, empty);
1451     }
1452 
1453     /**
1454      * @notice Override ERC223 transfer function in order to 
1455      * subtract the transaction fee and send it to the fee pool
1456      * for SNX holders to claim. */
1457     function transfer(address to, uint value, bytes data)
1458         public
1459         optionalProxy
1460         notFeeAddress(messageSender)
1461         returns (bool)
1462     {
1463         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1464         uint fee = value.sub(amountReceived);
1465 
1466         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1467         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1468 
1469         // And send their result off to the destination address
1470         return _internalTransfer(messageSender, to, amountReceived, data);
1471     }
1472 
1473     /**
1474      * @notice Override ERC20 transferFrom function in order to 
1475      * subtract the transaction fee and send it to the fee pool
1476      * for SNX holders to claim. */
1477     function transferFrom(address from, address to, uint value)
1478         public
1479         optionalProxy
1480         notFeeAddress(from)
1481         returns (bool)
1482     {
1483         // The fee is deducted from the amount sent.
1484         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1485         uint fee = value.sub(amountReceived);
1486 
1487         // Reduce the allowance by the amount we're transferring.
1488         // The safeSub call will handle an insufficient allowance.
1489         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1490 
1491         // Send the fee off to the fee pool.
1492         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1493 
1494         bytes memory empty;
1495         return _internalTransfer(from, to, amountReceived, empty);
1496     }
1497 
1498     /**
1499      * @notice Override ERC223 transferFrom function in order to 
1500      * subtract the transaction fee and send it to the fee pool
1501      * for SNX holders to claim. */
1502     function transferFrom(address from, address to, uint value, bytes data)
1503         public
1504         optionalProxy
1505         notFeeAddress(from)
1506         returns (bool)
1507     {
1508         // The fee is deducted from the amount sent.
1509         uint amountReceived = feePool.amountReceivedFromTransfer(value);
1510         uint fee = value.sub(amountReceived);
1511 
1512         // Reduce the allowance by the amount we're transferring.
1513         // The safeSub call will handle an insufficient allowance.
1514         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value));
1515 
1516         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1517         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1518 
1519         return _internalTransfer(from, to, amountReceived, data);
1520     }
1521 
1522     /* Subtract the transfer fee from the senders account so the 
1523      * receiver gets the exact amount specified to send. */
1524     function transferSenderPaysFee(address to, uint value)
1525         public
1526         optionalProxy
1527         notFeeAddress(messageSender)
1528         returns (bool)
1529     {
1530         uint fee = feePool.transferFeeIncurred(value);
1531 
1532         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1533         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1534 
1535         // And send their transfer amount off to the destination address
1536         bytes memory empty;
1537         return _internalTransfer(messageSender, to, value, empty);
1538     }
1539 
1540     /* Subtract the transfer fee from the senders account so the 
1541      * receiver gets the exact amount specified to send. */
1542     function transferSenderPaysFee(address to, uint value, bytes data)
1543         public
1544         optionalProxy
1545         notFeeAddress(messageSender)
1546         returns (bool)
1547     {
1548         uint fee = feePool.transferFeeIncurred(value);
1549 
1550         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1551         synthetix.synthInitiatedFeePayment(messageSender, currencyKey, fee);
1552 
1553         // And send their transfer amount off to the destination address
1554         return _internalTransfer(messageSender, to, value, data);
1555     }
1556 
1557     /* Subtract the transfer fee from the senders account so the 
1558      * to address receives the exact amount specified to send. */
1559     function transferFromSenderPaysFee(address from, address to, uint value)
1560         public
1561         optionalProxy
1562         notFeeAddress(from)
1563         returns (bool)
1564     {
1565         uint fee = feePool.transferFeeIncurred(value);
1566 
1567         // Reduce the allowance by the amount we're transferring.
1568         // The safeSub call will handle an insufficient allowance.
1569         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
1570 
1571         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1572         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1573 
1574         bytes memory empty;
1575         return _internalTransfer(from, to, value, empty);
1576     }
1577 
1578     /* Subtract the transfer fee from the senders account so the 
1579      * to address receives the exact amount specified to send. */
1580     function transferFromSenderPaysFee(address from, address to, uint value, bytes data)
1581         public
1582         optionalProxy
1583         notFeeAddress(from)
1584         returns (bool)
1585     {
1586         uint fee = feePool.transferFeeIncurred(value);
1587 
1588         // Reduce the allowance by the amount we're transferring.
1589         // The safeSub call will handle an insufficient allowance.
1590         tokenState.setAllowance(from, messageSender, tokenState.allowance(from, messageSender).sub(value.add(fee)));
1591 
1592         // Send the fee off to the fee pool, which we don't want to charge an additional fee on
1593         synthetix.synthInitiatedFeePayment(from, currencyKey, fee);
1594 
1595         return _internalTransfer(from, to, value, data);
1596     }
1597 
1598     // Override our internal transfer to inject preferred currency support
1599     function _internalTransfer(address from, address to, uint value, bytes data)
1600         internal
1601         returns (bool)
1602     {
1603         bytes4 preferredCurrencyKey = synthetix.synthetixState().preferredCurrency(to);
1604 
1605         // Do they have a preferred currency that's not us? If so we need to exchange
1606         if (preferredCurrencyKey != 0 && preferredCurrencyKey != currencyKey) {
1607             return synthetix.synthInitiatedExchange(from, currencyKey, value, preferredCurrencyKey, to);
1608         } else {
1609             // Otherwise we just transfer
1610             return super._internalTransfer(from, to, value, data);
1611         }
1612     }
1613 
1614     // Allow synthetix to issue a certain number of synths from an account.
1615     function issue(address account, uint amount)
1616         external
1617         onlySynthetixOrFeePool
1618     {
1619         tokenState.setBalanceOf(account, tokenState.balanceOf(account).add(amount));
1620         totalSupply = totalSupply.add(amount);
1621         emitTransfer(address(0), account, amount);
1622         emitIssued(account, amount);
1623     }
1624 
1625     // Allow synthetix or another synth contract to burn a certain number of synths from an account.
1626     function burn(address account, uint amount)
1627         external
1628         onlySynthetixOrFeePool
1629     {
1630         tokenState.setBalanceOf(account, tokenState.balanceOf(account).sub(amount));
1631         totalSupply = totalSupply.sub(amount);
1632         emitTransfer(account, address(0), amount);
1633         emitBurned(account, amount);
1634     }
1635 
1636     // Allow owner to set the total supply on import.
1637     function setTotalSupply(uint amount)
1638         external
1639         optionalProxy_onlyOwner
1640     {
1641         totalSupply = amount;
1642     }
1643 
1644     // Allow synthetix to trigger a token fallback call from our synths so users get notified on
1645     // exchange as well as transfer
1646     function triggerTokenFallbackIfNeeded(address sender, address recipient, uint amount)
1647         external
1648         onlySynthetixOrFeePool
1649     {
1650         bytes memory empty;
1651         callTokenFallbackIfNeeded(sender, recipient, amount, empty);
1652     }
1653 
1654     /* ========== MODIFIERS ========== */
1655 
1656     modifier onlySynthetixOrFeePool() {
1657         bool isSynthetix = msg.sender == address(synthetix);
1658         bool isFeePool = msg.sender == address(feePool);
1659 
1660         require(isSynthetix || isFeePool, "Only the Synthetix or FeePool contracts can perform this action");
1661         _;
1662     }
1663 
1664     modifier notFeeAddress(address account) {
1665         require(account != feePool.FEE_ADDRESS(), "Cannot perform this action with the fee address");
1666         _;
1667     }
1668 
1669     /* ========== EVENTS ========== */
1670 
1671     event SynthetixUpdated(address newSynthetix);
1672     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
1673     function emitSynthetixUpdated(address newSynthetix) internal {
1674         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
1675     }
1676 
1677     event FeePoolUpdated(address newFeePool);
1678     bytes32 constant FEEPOOLUPDATED_SIG = keccak256("FeePoolUpdated(address)");
1679     function emitFeePoolUpdated(address newFeePool) internal {
1680         proxy._emit(abi.encode(newFeePool), 1, FEEPOOLUPDATED_SIG, 0, 0, 0);
1681     }
1682 
1683     event Issued(address indexed account, uint value);
1684     bytes32 constant ISSUED_SIG = keccak256("Issued(address,uint256)");
1685     function emitIssued(address account, uint value) internal {
1686         proxy._emit(abi.encode(value), 2, ISSUED_SIG, bytes32(account), 0, 0);
1687     }
1688 
1689     event Burned(address indexed account, uint value);
1690     bytes32 constant BURNED_SIG = keccak256("Burned(address,uint256)");
1691     function emitBurned(address account, uint value) internal {
1692         proxy._emit(abi.encode(value), 2, BURNED_SIG, bytes32(account), 0, 0);
1693     }
1694 }
1695 
1696 
1697 ////////////////// FeePool.sol //////////////////
1698 
1699 /*
1700 -----------------------------------------------------------------
1701 FILE INFORMATION
1702 -----------------------------------------------------------------
1703 
1704 file:       FeePool.sol
1705 version:    1.0
1706 author:     Kevin Brown
1707 date:       2018-10-15
1708 
1709 -----------------------------------------------------------------
1710 MODULE DESCRIPTION
1711 -----------------------------------------------------------------
1712 
1713 The FeePool is a place for users to interact with the fees that
1714 have been generated from the Synthetix system if they've helped
1715 to create the economy.
1716 
1717 Users stake Synthetix to create Synths. As Synth users transact,
1718 a small fee is deducted from each transaction, which collects
1719 in the fee pool. Fees are immediately converted to XDRs, a type
1720 of reserve currency similar to SDRs used by the IMF:
1721 https://www.imf.org/en/About/Factsheets/Sheets/2016/08/01/14/51/Special-Drawing-Right-SDR
1722 
1723 Users are entitled to withdraw fees from periods that they participated
1724 in fully, e.g. they have to stake before the period starts. They
1725 can withdraw fees for the last 6 periods as a single lump sum.
1726 Currently fee periods are 7 days long, meaning it's assumed
1727 users will withdraw their fees approximately once a month. Fees
1728 which are not withdrawn are redistributed to the whole pool,
1729 enabling these non-claimed fees to go back to the rest of the commmunity.
1730 
1731 Fees can be withdrawn in any synth currency.
1732 
1733 -----------------------------------------------------------------
1734 */
1735 
1736 
1737 contract FeePool is Proxyable, SelfDestructible {
1738 
1739     using SafeMath for uint;
1740     using SafeDecimalMath for uint;
1741 
1742     Synthetix public synthetix;
1743 
1744     // A percentage fee charged on each transfer.
1745     uint public transferFeeRate;
1746 
1747     // Transfer fee may not exceed 10%.
1748     uint constant public MAX_TRANSFER_FEE_RATE = SafeDecimalMath.unit() / 10;
1749 
1750     // A percentage fee charged on each exchange between currencies.
1751     uint public exchangeFeeRate;
1752 
1753     // Exchange fee may not exceed 10%.
1754     uint constant public MAX_EXCHANGE_FEE_RATE = SafeDecimalMath.unit() / 10;
1755 
1756     // The address with the authority to distribute fees.
1757     address public feeAuthority;
1758 
1759     // Where fees are pooled in XDRs.
1760     address public constant FEE_ADDRESS = 0xfeEFEEfeefEeFeefEEFEEfEeFeefEEFeeFEEFEeF;
1761 
1762     // This struct represents the issuance activity that's happened in a fee period.
1763     struct FeePeriod {
1764         uint feePeriodId;
1765         uint startingDebtIndex;
1766         uint startTime;
1767         uint feesToDistribute;
1768         uint feesClaimed;
1769     }
1770 
1771     // The last 6 fee periods are all that you can claim from.
1772     // These are stored and managed from [0], such that [0] is always
1773     // the most recent fee period, and [5] is always the oldest fee
1774     // period that users can claim for.
1775     uint8 constant public FEE_PERIOD_LENGTH = 6;
1776     FeePeriod[FEE_PERIOD_LENGTH] public recentFeePeriods;
1777 
1778     // The next fee period will have this ID.
1779     uint public nextFeePeriodId;
1780 
1781     // How long a fee period lasts at a minimum. It is required for the
1782     // fee authority to roll over the periods, so they are not guaranteed
1783     // to roll over at exactly this duration, but the contract enforces
1784     // that they cannot roll over any quicker than this duration.
1785     uint public feePeriodDuration = 1 weeks;
1786 
1787     // The fee period must be between 1 day and 60 days.
1788     uint public constant MIN_FEE_PERIOD_DURATION = 1 days;
1789     uint public constant MAX_FEE_PERIOD_DURATION = 60 days;
1790 
1791     // The last period a user has withdrawn their fees in, identified by the feePeriodId
1792     mapping(address => uint) public lastFeeWithdrawal;
1793 
1794     // Users receive penalties if their collateralisation ratio drifts out of our desired brackets
1795     // We precompute the brackets and penalties to save gas.
1796     uint constant TWENTY_PERCENT = (20 * SafeDecimalMath.unit()) / 100;
1797     uint constant TWENTY_FIVE_PERCENT = (25 * SafeDecimalMath.unit()) / 100;
1798     uint constant THIRTY_PERCENT = (30 * SafeDecimalMath.unit()) / 100;
1799     uint constant FOURTY_PERCENT = (40 * SafeDecimalMath.unit()) / 100;
1800     uint constant FIFTY_PERCENT = (50 * SafeDecimalMath.unit()) / 100;
1801     uint constant SEVENTY_FIVE_PERCENT = (75 * SafeDecimalMath.unit()) / 100;
1802 
1803     constructor(address _proxy, address _owner, Synthetix _synthetix, address _feeAuthority, uint _transferFeeRate, uint _exchangeFeeRate)
1804         SelfDestructible(_owner)
1805         Proxyable(_proxy, _owner)
1806         public
1807     {
1808         // Constructed fee rates should respect the maximum fee rates.
1809         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Constructed transfer fee rate should respect the maximum fee rate");
1810         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Constructed exchange fee rate should respect the maximum fee rate");
1811 
1812         synthetix = _synthetix;
1813         feeAuthority = _feeAuthority;
1814         transferFeeRate = _transferFeeRate;
1815         exchangeFeeRate = _exchangeFeeRate;
1816 
1817         // Set our initial fee period
1818         recentFeePeriods[0].feePeriodId = 1;
1819         recentFeePeriods[0].startTime = now;
1820         // Gas optimisation: These do not need to be initialised. They start at 0.
1821         // recentFeePeriods[0].startingDebtIndex = 0;
1822         // recentFeePeriods[0].feesToDistribute = 0;
1823 
1824         // And the next one starts at 2.
1825         nextFeePeriodId = 2;
1826     }
1827 
1828     /**
1829      * @notice Set the exchange fee, anywhere within the range 0-10%.
1830      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1831      */
1832     function setExchangeFeeRate(uint _exchangeFeeRate)
1833         external
1834         optionalProxy_onlyOwner
1835     {
1836         require(_exchangeFeeRate <= MAX_EXCHANGE_FEE_RATE, "Exchange fee rate must be below MAX_EXCHANGE_FEE_RATE");
1837 
1838         exchangeFeeRate = _exchangeFeeRate;
1839 
1840         emitExchangeFeeUpdated(_exchangeFeeRate);
1841     }
1842 
1843     /**
1844      * @notice Set the transfer fee, anywhere within the range 0-10%.
1845      * @dev The fee rate is in decimal format, with UNIT being the value of 100%.
1846      */
1847     function setTransferFeeRate(uint _transferFeeRate)
1848         external
1849         optionalProxy_onlyOwner
1850     {
1851         require(_transferFeeRate <= MAX_TRANSFER_FEE_RATE, "Transfer fee rate must be below MAX_TRANSFER_FEE_RATE");
1852 
1853         transferFeeRate = _transferFeeRate;
1854 
1855         emitTransferFeeUpdated(_transferFeeRate);
1856     }
1857 
1858     /**
1859      * @notice Set the address of the user/contract responsible for collecting or
1860      * distributing fees.
1861      */
1862     function setFeeAuthority(address _feeAuthority)
1863         external
1864         optionalProxy_onlyOwner
1865     {
1866         feeAuthority = _feeAuthority;
1867 
1868         emitFeeAuthorityUpdated(_feeAuthority);
1869     }
1870 
1871     /**
1872      * @notice Set the fee period duration
1873      */
1874     function setFeePeriodDuration(uint _feePeriodDuration)
1875         external
1876         optionalProxy_onlyOwner
1877     {
1878         require(_feePeriodDuration >= MIN_FEE_PERIOD_DURATION, "New fee period cannot be less than minimum fee period duration");
1879         require(_feePeriodDuration <= MAX_FEE_PERIOD_DURATION, "New fee period cannot be greater than maximum fee period duration");
1880 
1881         feePeriodDuration = _feePeriodDuration;
1882 
1883         emitFeePeriodDurationUpdated(_feePeriodDuration);
1884     }
1885 
1886     /**
1887      * @notice Set the synthetix contract
1888      */
1889     function setSynthetix(Synthetix _synthetix)
1890         external
1891         optionalProxy_onlyOwner
1892     {
1893         require(address(_synthetix) != address(0), "New Synthetix must be non-zero");
1894 
1895         synthetix = _synthetix;
1896 
1897         emitSynthetixUpdated(_synthetix);
1898     }
1899 
1900     /**
1901      * @notice The Synthetix contract informs us when fees are paid.
1902      */
1903     function feePaid(bytes4 currencyKey, uint amount)
1904         external
1905         onlySynthetix
1906     {
1907         uint xdrAmount = synthetix.effectiveValue(currencyKey, amount, "XDR");
1908 
1909         // Which we keep track of in XDRs in our fee pool.
1910         recentFeePeriods[0].feesToDistribute = recentFeePeriods[0].feesToDistribute.add(xdrAmount);
1911     }
1912 
1913     /**
1914      * @notice Close the current fee period and start a new one. Only callable by the fee authority.
1915      */
1916     function closeCurrentFeePeriod()
1917         external
1918         onlyFeeAuthority
1919     {
1920         require(recentFeePeriods[0].startTime <= (now - feePeriodDuration), "It is too early to close the current fee period");
1921 
1922         FeePeriod memory secondLastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 2];
1923         FeePeriod memory lastFeePeriod = recentFeePeriods[FEE_PERIOD_LENGTH - 1];
1924 
1925         // Any unclaimed fees from the last period in the array roll back one period.
1926         // Because of the subtraction here, they're effectively proportionally redistributed to those who
1927         // have already claimed from the old period, available in the new period.
1928         // The subtraction is important so we don't create a ticking time bomb of an ever growing
1929         // number of fees that can never decrease and will eventually overflow at the end of the fee pool.
1930         recentFeePeriods[FEE_PERIOD_LENGTH - 2].feesToDistribute = lastFeePeriod.feesToDistribute
1931             .sub(lastFeePeriod.feesClaimed)
1932             .add(secondLastFeePeriod.feesToDistribute);
1933 
1934         // Shift the previous fee periods across to make room for the new one.
1935         // Condition checks for overflow when uint subtracts one from zero
1936         // Could be written with int instead of uint, but then we have to convert everywhere
1937         // so it felt better from a gas perspective to just change the condition to check
1938         // for overflow after subtracting one from zero.
1939         for (uint i = FEE_PERIOD_LENGTH - 2; i < FEE_PERIOD_LENGTH; i--) {
1940             uint next = i + 1;
1941 
1942             recentFeePeriods[next].feePeriodId = recentFeePeriods[i].feePeriodId;
1943             recentFeePeriods[next].startingDebtIndex = recentFeePeriods[i].startingDebtIndex;
1944             recentFeePeriods[next].startTime = recentFeePeriods[i].startTime;
1945             recentFeePeriods[next].feesToDistribute = recentFeePeriods[i].feesToDistribute;
1946             recentFeePeriods[next].feesClaimed = recentFeePeriods[i].feesClaimed;
1947         }
1948 
1949         // Clear the first element of the array to make sure we don't have any stale values.
1950         delete recentFeePeriods[0];
1951 
1952         // Open up the new fee period
1953         recentFeePeriods[0].feePeriodId = nextFeePeriodId;
1954         recentFeePeriods[0].startingDebtIndex = synthetix.synthetixState().debtLedgerLength();
1955         recentFeePeriods[0].startTime = now;
1956 
1957         nextFeePeriodId = nextFeePeriodId.add(1);
1958 
1959         emitFeePeriodClosed(recentFeePeriods[1].feePeriodId);
1960     }
1961 
1962     /**
1963     * @notice Claim fees for last period when available or not already withdrawn.
1964     * @param currencyKey Synth currency you wish to receive the fees in.
1965     */
1966     function claimFees(bytes4 currencyKey)
1967         external
1968         optionalProxy
1969         returns (bool)
1970     {
1971         uint availableFees = feesAvailable(messageSender, "XDR");
1972 
1973         require(availableFees > 0, "No fees available for period, or fees already claimed");
1974 
1975         lastFeeWithdrawal[messageSender] = recentFeePeriods[1].feePeriodId;
1976 
1977         // Record the fee payment in our recentFeePeriods
1978         _recordFeePayment(availableFees);
1979 
1980         // Send them their fees
1981         _payFees(messageSender, availableFees, currencyKey);
1982 
1983         emitFeesClaimed(messageSender, availableFees);
1984 
1985         return true;
1986     }
1987 
1988     /**
1989      * @notice Record the fee payment in our recentFeePeriods.
1990      * @param xdrAmount The amout of fees priced in XDRs.
1991      */
1992     function _recordFeePayment(uint xdrAmount)
1993         internal
1994     {
1995         // Don't assign to the parameter
1996         uint remainingToAllocate = xdrAmount;
1997 
1998         // Start at the oldest period and record the amount, moving to newer periods
1999         // until we've exhausted the amount.
2000         // The condition checks for overflow because we're going to 0 with an unsigned int.
2001         for (uint i = FEE_PERIOD_LENGTH - 1; i < FEE_PERIOD_LENGTH; i--) {
2002             uint delta = recentFeePeriods[i].feesToDistribute.sub(recentFeePeriods[i].feesClaimed);
2003 
2004             if (delta > 0) {
2005                 // Take the smaller of the amount left to claim in the period and the amount we need to allocate
2006                 uint amountInPeriod = delta < remainingToAllocate ? delta : remainingToAllocate;
2007 
2008                 recentFeePeriods[i].feesClaimed = recentFeePeriods[i].feesClaimed.add(amountInPeriod);
2009                 remainingToAllocate = remainingToAllocate.sub(amountInPeriod);
2010 
2011                 // No need to continue iterating if we've recorded the whole amount;
2012                 if (remainingToAllocate == 0) return;
2013             }
2014         }
2015 
2016         // If we hit this line, we've exhausted our fee periods, but still have more to allocate. Wat?
2017         // If this happens it's a definite bug in the code, so assert instead of require.
2018         assert(remainingToAllocate == 0);
2019     }
2020 
2021     /**
2022     * @notice Send the fees to claiming address.
2023     * @param account The address to send the fees to.
2024     * @param xdrAmount The amount of fees priced in XDRs.
2025     * @param destinationCurrencyKey The synth currency the user wishes to receive their fees in (convert to this currency).
2026     */
2027     function _payFees(address account, uint xdrAmount, bytes4 destinationCurrencyKey)
2028         internal
2029         notFeeAddress(account)
2030     {
2031         require(account != address(0), "Account can't be 0");
2032         require(account != address(this), "Can't send fees to fee pool");
2033         require(account != address(proxy), "Can't send fees to proxy");
2034         require(account != address(synthetix), "Can't send fees to synthetix");
2035 
2036         Synth xdrSynth = synthetix.synths("XDR");
2037         Synth destinationSynth = synthetix.synths(destinationCurrencyKey);
2038 
2039         // Note: We don't need to check the fee pool balance as the burn() below will do a safe subtraction which requires
2040         // the subtraction to not overflow, which would happen if the balance is not sufficient.
2041 
2042         // Burn the source amount
2043         xdrSynth.burn(FEE_ADDRESS, xdrAmount);
2044 
2045         // How much should they get in the destination currency?
2046         uint destinationAmount = synthetix.effectiveValue("XDR", xdrAmount, destinationCurrencyKey);
2047 
2048         // There's no fee on withdrawing fees, as that'd be way too meta.
2049 
2050         // Mint their new synths
2051         destinationSynth.issue(account, destinationAmount);
2052 
2053         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
2054 
2055         // Call the ERC223 transfer callback if needed
2056         destinationSynth.triggerTokenFallbackIfNeeded(FEE_ADDRESS, account, destinationAmount);
2057     }
2058 
2059     /**
2060      * @notice Calculate the Fee charged on top of a value being sent
2061      * @return Return the fee charged
2062      */
2063     function transferFeeIncurred(uint value)
2064         public
2065         view
2066         returns (uint)
2067     {
2068         return value.multiplyDecimal(transferFeeRate);
2069 
2070         // Transfers less than the reciprocal of transferFeeRate should be completely eaten up by fees.
2071         // This is on the basis that transfers less than this value will result in a nil fee.
2072         // Probably too insignificant to worry about, but the following code will achieve it.
2073         //      if (fee == 0 && transferFeeRate != 0) {
2074         //          return _value;
2075         //      }
2076         //      return fee;
2077     }
2078 
2079     /**
2080      * @notice The value that you would need to send so that the recipient receives
2081      * a specified value.
2082      * @param value The value you want the recipient to receive
2083      */
2084     function transferredAmountToReceive(uint value)
2085         external
2086         view
2087         returns (uint)
2088     {
2089         return value.add(transferFeeIncurred(value));
2090     }
2091 
2092     /**
2093      * @notice The amount the recipient will receive if you send a certain number of tokens.
2094      * @param value The amount of tokens you intend to send.
2095      */
2096     function amountReceivedFromTransfer(uint value)
2097         external
2098         view
2099         returns (uint)
2100     {
2101         return value.divideDecimal(transferFeeRate.add(SafeDecimalMath.unit()));
2102     }
2103 
2104     /**
2105      * @notice Calculate the fee charged on top of a value being sent via an exchange
2106      * @return Return the fee charged
2107      */
2108     function exchangeFeeIncurred(uint value)
2109         public
2110         view
2111         returns (uint)
2112     {
2113         return value.multiplyDecimal(exchangeFeeRate);
2114 
2115         // Exchanges less than the reciprocal of exchangeFeeRate should be completely eaten up by fees.
2116         // This is on the basis that exchanges less than this value will result in a nil fee.
2117         // Probably too insignificant to worry about, but the following code will achieve it.
2118         //      if (fee == 0 && exchangeFeeRate != 0) {
2119         //          return _value;
2120         //      }
2121         //      return fee;
2122     }
2123 
2124     /**
2125      * @notice The value that you would need to get after currency exchange so that the recipient receives
2126      * a specified value.
2127      * @param value The value you want the recipient to receive
2128      */
2129     function exchangedAmountToReceive(uint value)
2130         external
2131         view
2132         returns (uint)
2133     {
2134         return value.add(exchangeFeeIncurred(value));
2135     }
2136 
2137     /**
2138      * @notice The amount the recipient will receive if you are performing an exchange and the
2139      * destination currency will be worth a certain number of tokens.
2140      * @param value The amount of destination currency tokens they received after the exchange.
2141      */
2142     function amountReceivedFromExchange(uint value)
2143         external
2144         view
2145         returns (uint)
2146     {
2147         return value.divideDecimal(exchangeFeeRate.add(SafeDecimalMath.unit()));
2148     }
2149 
2150     /**
2151      * @notice The total fees available in the system to be withdrawn, priced in currencyKey currency
2152      * @param currencyKey The currency you want to price the fees in
2153      */
2154     function totalFeesAvailable(bytes4 currencyKey)
2155         external
2156         view
2157         returns (uint)
2158     {
2159         uint totalFees = 0;
2160 
2161         // Fees in fee period [0] are not yet available for withdrawal
2162         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
2163             totalFees = totalFees.add(recentFeePeriods[i].feesToDistribute);
2164             totalFees = totalFees.sub(recentFeePeriods[i].feesClaimed);
2165         }
2166 
2167         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
2168     }
2169 
2170     /**
2171      * @notice The fees available to be withdrawn by a specific account, priced in currencyKey currency
2172      * @param currencyKey The currency you want to price the fees in
2173      */
2174     function feesAvailable(address account, bytes4 currencyKey)
2175         public
2176         view
2177         returns (uint)
2178     {
2179         // Add up the fees
2180         uint[FEE_PERIOD_LENGTH] memory userFees = feesByPeriod(account);
2181 
2182         uint totalFees = 0;
2183 
2184         // Fees in fee period [0] are not yet available for withdrawal
2185         for (uint i = 1; i < FEE_PERIOD_LENGTH; i++) {
2186             totalFees = totalFees.add(userFees[i]);
2187         }
2188 
2189         // And convert them to their desired currency
2190         return synthetix.effectiveValue("XDR", totalFees, currencyKey);
2191     }
2192 
2193     /**
2194      * @notice The penalty a particular address would incur if its fees were withdrawn right now
2195      * @param account The address you want to query the penalty for
2196      */
2197     function currentPenalty(address account)
2198         public
2199         view
2200         returns (uint)
2201     {
2202         uint ratio = synthetix.collateralisationRatio(account);
2203 
2204         // Users receive a different amount of fees depending on how their collateralisation ratio looks right now.
2205         // 0% - 20%: Fee is calculated based on percentage of economy issued.
2206         // 20% - 30%: 25% reduction in fees
2207         // 30% - 40%: 50% reduction in fees
2208         // >40%: 75% reduction in fees
2209         if (ratio <= TWENTY_PERCENT) {
2210             return 0;
2211         } else if (ratio > TWENTY_PERCENT && ratio <= THIRTY_PERCENT) {
2212             return TWENTY_FIVE_PERCENT;
2213         } else if (ratio > THIRTY_PERCENT && ratio <= FOURTY_PERCENT) {
2214             return FIFTY_PERCENT;
2215         }
2216 
2217         return SEVENTY_FIVE_PERCENT;
2218     }
2219 
2220     /**
2221      * @notice Calculates fees by period for an account, priced in XDRs
2222      * @param account The address you want to query the fees by penalty for
2223      */
2224     function feesByPeriod(address account)
2225         public
2226         view
2227         returns (uint[FEE_PERIOD_LENGTH])
2228     {
2229         uint[FEE_PERIOD_LENGTH] memory result;
2230 
2231         // What's the user's debt entry index and the debt they owe to the system
2232         uint initialDebtOwnership;
2233         uint debtEntryIndex;
2234         (initialDebtOwnership, debtEntryIndex) = synthetix.synthetixState().issuanceData(account);
2235 
2236         // If they don't have any debt ownership, they don't have any fees
2237         if (initialDebtOwnership == 0) return result;
2238 
2239         // If there are no XDR synths, then they don't have any fees
2240         uint totalSynths = synthetix.totalIssuedSynths("XDR");
2241         if (totalSynths == 0) return result;
2242 
2243         uint debtBalance = synthetix.debtBalanceOf(account, "XDR");
2244         uint userOwnershipPercentage = debtBalance.divideDecimal(totalSynths);
2245         uint penalty = currentPenalty(account);
2246         
2247         // Go through our fee periods and figure out what we owe them.
2248         // The [0] fee period is not yet ready to claim, but it is a fee period that they can have
2249         // fees owing for, so we need to report on it anyway.
2250         for (uint i = 0; i < FEE_PERIOD_LENGTH; i++) {
2251             // Were they a part of this period in its entirety?
2252             // We don't allow pro-rata participation to reduce the ability to game the system by
2253             // issuing and burning multiple times in a period or close to the ends of periods.
2254             if (recentFeePeriods[i].startingDebtIndex > debtEntryIndex &&
2255                 lastFeeWithdrawal[account] < recentFeePeriods[i].feePeriodId) {
2256 
2257                 // And since they were, they're entitled to their percentage of the fees in this period
2258                 uint feesFromPeriodWithoutPenalty = recentFeePeriods[i].feesToDistribute
2259                     .multiplyDecimal(userOwnershipPercentage);
2260 
2261                 // Less their penalty if they have one.
2262                 uint penaltyFromPeriod = feesFromPeriodWithoutPenalty.multiplyDecimal(penalty);
2263                 uint feesFromPeriod = feesFromPeriodWithoutPenalty.sub(penaltyFromPeriod);
2264 
2265                 result[i] = feesFromPeriod;
2266             }
2267         }
2268 
2269         return result;
2270     }
2271 
2272     modifier onlyFeeAuthority
2273     {
2274         require(msg.sender == feeAuthority, "Only the fee authority can perform this action");
2275         _;
2276     }
2277 
2278     modifier onlySynthetix
2279     {
2280         require(msg.sender == address(synthetix), "Only the synthetix contract can perform this action");
2281         _;
2282     }
2283 
2284     modifier notFeeAddress(address account) {
2285         require(account != FEE_ADDRESS, "Fee address not allowed");
2286         _;
2287     }
2288 
2289     event TransferFeeUpdated(uint newFeeRate);
2290     bytes32 constant TRANSFERFEEUPDATED_SIG = keccak256("TransferFeeUpdated(uint256)");
2291     function emitTransferFeeUpdated(uint newFeeRate) internal {
2292         proxy._emit(abi.encode(newFeeRate), 1, TRANSFERFEEUPDATED_SIG, 0, 0, 0);
2293     }
2294 
2295     event ExchangeFeeUpdated(uint newFeeRate);
2296     bytes32 constant EXCHANGEFEEUPDATED_SIG = keccak256("ExchangeFeeUpdated(uint256)");
2297     function emitExchangeFeeUpdated(uint newFeeRate) internal {
2298         proxy._emit(abi.encode(newFeeRate), 1, EXCHANGEFEEUPDATED_SIG, 0, 0, 0);
2299     }
2300 
2301     event FeePeriodDurationUpdated(uint newFeePeriodDuration);
2302     bytes32 constant FEEPERIODDURATIONUPDATED_SIG = keccak256("FeePeriodDurationUpdated(uint256)");
2303     function emitFeePeriodDurationUpdated(uint newFeePeriodDuration) internal {
2304         proxy._emit(abi.encode(newFeePeriodDuration), 1, FEEPERIODDURATIONUPDATED_SIG, 0, 0, 0);
2305     }
2306 
2307     event FeeAuthorityUpdated(address newFeeAuthority);
2308     bytes32 constant FEEAUTHORITYUPDATED_SIG = keccak256("FeeAuthorityUpdated(address)");
2309     function emitFeeAuthorityUpdated(address newFeeAuthority) internal {
2310         proxy._emit(abi.encode(newFeeAuthority), 1, FEEAUTHORITYUPDATED_SIG, 0, 0, 0);
2311     }
2312 
2313     event FeePeriodClosed(uint feePeriodId);
2314     bytes32 constant FEEPERIODCLOSED_SIG = keccak256("FeePeriodClosed(uint256)");
2315     function emitFeePeriodClosed(uint feePeriodId) internal {
2316         proxy._emit(abi.encode(feePeriodId), 1, FEEPERIODCLOSED_SIG, 0, 0, 0);
2317     }
2318 
2319     event FeesClaimed(address account, uint xdrAmount);
2320     bytes32 constant FEESCLAIMED_SIG = keccak256("FeesClaimed(address,uint256)");
2321     function emitFeesClaimed(address account, uint xdrAmount) internal {
2322         proxy._emit(abi.encode(account, xdrAmount), 1, FEESCLAIMED_SIG, 0, 0, 0);
2323     }
2324 
2325     event SynthetixUpdated(address newSynthetix);
2326     bytes32 constant SYNTHETIXUPDATED_SIG = keccak256("SynthetixUpdated(address)");
2327     function emitSynthetixUpdated(address newSynthetix) internal {
2328         proxy._emit(abi.encode(newSynthetix), 1, SYNTHETIXUPDATED_SIG, 0, 0, 0);
2329     }
2330 }
2331 
2332 
2333 ////////////////// LimitedSetup.sol //////////////////
2334 
2335 /*
2336 -----------------------------------------------------------------
2337 FILE INFORMATION
2338 -----------------------------------------------------------------
2339 
2340 file:       LimitedSetup.sol
2341 version:    1.1
2342 author:     Anton Jurisevic
2343 
2344 date:       2018-05-15
2345 
2346 -----------------------------------------------------------------
2347 MODULE DESCRIPTION
2348 -----------------------------------------------------------------
2349 
2350 A contract with a limited setup period. Any function modified
2351 with the setup modifier will cease to work after the
2352 conclusion of the configurable-length post-construction setup period.
2353 
2354 -----------------------------------------------------------------
2355 */
2356 
2357 
2358 /**
2359  * @title Any function decorated with the modifier this contract provides
2360  * deactivates after a specified setup period.
2361  */
2362 contract LimitedSetup {
2363 
2364     uint setupExpiryTime;
2365 
2366     /**
2367      * @dev LimitedSetup Constructor.
2368      * @param setupDuration The time the setup period will last for.
2369      */
2370     constructor(uint setupDuration)
2371         public
2372     {
2373         setupExpiryTime = now + setupDuration;
2374     }
2375 
2376     modifier onlyDuringSetup
2377     {
2378         require(now < setupExpiryTime, "Can only perform this action during setup");
2379         _;
2380     }
2381 }
2382 
2383 
2384 ////////////////// SynthetixEscrow.sol //////////////////
2385 
2386 /*
2387 -----------------------------------------------------------------
2388 FILE INFORMATION
2389 -----------------------------------------------------------------
2390 
2391 file:       SynthetixEscrow.sol
2392 version:    1.1
2393 author:     Anton Jurisevic
2394             Dominic Romanowski
2395             Mike Spain
2396 
2397 date:       2018-05-29
2398 
2399 -----------------------------------------------------------------
2400 MODULE DESCRIPTION
2401 -----------------------------------------------------------------
2402 
2403 This contract allows the foundation to apply unique vesting
2404 schedules to synthetix funds sold at various discounts in the token
2405 sale. SynthetixEscrow gives users the ability to inspect their
2406 vested funds, their quantities and vesting dates, and to withdraw
2407 the fees that accrue on those funds.
2408 
2409 The fees are handled by withdrawing the entire fee allocation
2410 for all SNX inside the escrow contract, and then allowing
2411 the contract itself to subdivide that pool up proportionally within
2412 itself. Every time the fee period rolls over in the main Synthetix
2413 contract, the SynthetixEscrow fee pool is remitted back into the
2414 main fee pool to be redistributed in the next fee period.
2415 
2416 -----------------------------------------------------------------
2417 */
2418 
2419 
2420 /**
2421  * @title A contract to hold escrowed SNX and free them at given schedules.
2422  */
2423 contract SynthetixEscrow is Owned, LimitedSetup(8 weeks) {
2424 
2425     using SafeMath for uint;
2426 
2427     /* The corresponding Synthetix contract. */
2428     Synthetix public synthetix;
2429 
2430     /* Lists of (timestamp, quantity) pairs per account, sorted in ascending time order.
2431      * These are the times at which each given quantity of SNX vests. */
2432     mapping(address => uint[2][]) public vestingSchedules;
2433 
2434     /* An account's total vested synthetix balance to save recomputing this for fee extraction purposes. */
2435     mapping(address => uint) public totalVestedAccountBalance;
2436 
2437     /* The total remaining vested balance, for verifying the actual synthetix balance of this contract against. */
2438     uint public totalVestedBalance;
2439 
2440     uint constant TIME_INDEX = 0;
2441     uint constant QUANTITY_INDEX = 1;
2442 
2443     /* Limit vesting entries to disallow unbounded iteration over vesting schedules. */
2444     uint constant MAX_VESTING_ENTRIES = 20;
2445 
2446 
2447     /* ========== CONSTRUCTOR ========== */
2448 
2449     constructor(address _owner, Synthetix _synthetix)
2450         Owned(_owner)
2451         public
2452     {
2453         synthetix = _synthetix;
2454     }
2455 
2456 
2457     /* ========== SETTERS ========== */
2458 
2459     function setSynthetix(Synthetix _synthetix)
2460         external
2461         onlyOwner
2462     {
2463         synthetix = _synthetix;
2464         emit SynthetixUpdated(_synthetix);
2465     }
2466 
2467 
2468     /* ========== VIEW FUNCTIONS ========== */
2469 
2470     /**
2471      * @notice A simple alias to totalVestedAccountBalance: provides ERC20 balance integration.
2472      */
2473     function balanceOf(address account)
2474         public
2475         view
2476         returns (uint)
2477     {
2478         return totalVestedAccountBalance[account];
2479     }
2480 
2481     /**
2482      * @notice The number of vesting dates in an account's schedule.
2483      */
2484     function numVestingEntries(address account)
2485         public
2486         view
2487         returns (uint)
2488     {
2489         return vestingSchedules[account].length;
2490     }
2491 
2492     /**
2493      * @notice Get a particular schedule entry for an account.
2494      * @return A pair of uints: (timestamp, synthetix quantity).
2495      */
2496     function getVestingScheduleEntry(address account, uint index)
2497         public
2498         view
2499         returns (uint[2])
2500     {
2501         return vestingSchedules[account][index];
2502     }
2503 
2504     /**
2505      * @notice Get the time at which a given schedule entry will vest.
2506      */
2507     function getVestingTime(address account, uint index)
2508         public
2509         view
2510         returns (uint)
2511     {
2512         return getVestingScheduleEntry(account,index)[TIME_INDEX];
2513     }
2514 
2515     /**
2516      * @notice Get the quantity of SNX associated with a given schedule entry.
2517      */
2518     function getVestingQuantity(address account, uint index)
2519         public
2520         view
2521         returns (uint)
2522     {
2523         return getVestingScheduleEntry(account,index)[QUANTITY_INDEX];
2524     }
2525 
2526     /**
2527      * @notice Obtain the index of the next schedule entry that will vest for a given user.
2528      */
2529     function getNextVestingIndex(address account)
2530         public
2531         view
2532         returns (uint)
2533     {
2534         uint len = numVestingEntries(account);
2535         for (uint i = 0; i < len; i++) {
2536             if (getVestingTime(account, i) != 0) {
2537                 return i;
2538             }
2539         }
2540         return len;
2541     }
2542 
2543     /**
2544      * @notice Obtain the next schedule entry that will vest for a given user.
2545      * @return A pair of uints: (timestamp, synthetix quantity). */
2546     function getNextVestingEntry(address account)
2547         public
2548         view
2549         returns (uint[2])
2550     {
2551         uint index = getNextVestingIndex(account);
2552         if (index == numVestingEntries(account)) {
2553             return [uint(0), 0];
2554         }
2555         return getVestingScheduleEntry(account, index);
2556     }
2557 
2558     /**
2559      * @notice Obtain the time at which the next schedule entry will vest for a given user.
2560      */
2561     function getNextVestingTime(address account)
2562         external
2563         view
2564         returns (uint)
2565     {
2566         return getNextVestingEntry(account)[TIME_INDEX];
2567     }
2568 
2569     /**
2570      * @notice Obtain the quantity which the next schedule entry will vest for a given user.
2571      */
2572     function getNextVestingQuantity(address account)
2573         external
2574         view
2575         returns (uint)
2576     {
2577         return getNextVestingEntry(account)[QUANTITY_INDEX];
2578     }
2579 
2580 
2581     /* ========== MUTATIVE FUNCTIONS ========== */
2582 
2583     /**
2584      * @notice Withdraws a quantity of SNX back to the synthetix contract.
2585      * @dev This may only be called by the owner during the contract's setup period.
2586      */
2587     function withdrawSynthetix(uint quantity)
2588         external
2589         onlyOwner
2590         onlyDuringSetup
2591     {
2592         synthetix.transfer(synthetix, quantity);
2593     }
2594 
2595     /**
2596      * @notice Destroy the vesting information associated with an account.
2597      */
2598     function purgeAccount(address account)
2599         external
2600         onlyOwner
2601         onlyDuringSetup
2602     {
2603         delete vestingSchedules[account];
2604         totalVestedBalance = totalVestedBalance.sub(totalVestedAccountBalance[account]);
2605         delete totalVestedAccountBalance[account];
2606     }
2607 
2608     /**
2609      * @notice Add a new vesting entry at a given time and quantity to an account's schedule.
2610      * @dev A call to this should be accompanied by either enough balance already available
2611      * in this contract, or a corresponding call to synthetix.endow(), to ensure that when
2612      * the funds are withdrawn, there is enough balance, as well as correctly calculating
2613      * the fees.
2614      * This may only be called by the owner during the contract's setup period.
2615      * Note; although this function could technically be used to produce unbounded
2616      * arrays, it's only in the foundation's command to add to these lists.
2617      * @param account The account to append a new vesting entry to.
2618      * @param time The absolute unix timestamp after which the vested quantity may be withdrawn.
2619      * @param quantity The quantity of SNX that will vest.
2620      */
2621     function appendVestingEntry(address account, uint time, uint quantity)
2622         public
2623         onlyOwner
2624         onlyDuringSetup
2625     {
2626         /* No empty or already-passed vesting entries allowed. */
2627         require(now < time, "Time must be in the future");
2628         require(quantity != 0, "Quantity cannot be zero");
2629 
2630         /* There must be enough balance in the contract to provide for the vesting entry. */
2631         totalVestedBalance = totalVestedBalance.add(quantity);
2632         require(totalVestedBalance <= synthetix.balanceOf(this), "Must be enough balance in the contract to provide for the vesting entry");
2633 
2634         /* Disallow arbitrarily long vesting schedules in light of the gas limit. */
2635         uint scheduleLength = vestingSchedules[account].length;
2636         require(scheduleLength <= MAX_VESTING_ENTRIES, "Vesting schedule is too long");
2637 
2638         if (scheduleLength == 0) {
2639             totalVestedAccountBalance[account] = quantity;
2640         } else {
2641             /* Disallow adding new vested SNX earlier than the last one.
2642              * Since entries are only appended, this means that no vesting date can be repeated. */
2643             require(getVestingTime(account, numVestingEntries(account) - 1) < time, "Cannot add new vested entries earlier than the last one");
2644             totalVestedAccountBalance[account] = totalVestedAccountBalance[account].add(quantity);
2645         }
2646 
2647         vestingSchedules[account].push([time, quantity]);
2648     }
2649 
2650     /**
2651      * @notice Construct a vesting schedule to release a quantities of SNX
2652      * over a series of intervals.
2653      * @dev Assumes that the quantities are nonzero
2654      * and that the sequence of timestamps is strictly increasing.
2655      * This may only be called by the owner during the contract's setup period.
2656      */
2657     function addVestingSchedule(address account, uint[] times, uint[] quantities)
2658         external
2659         onlyOwner
2660         onlyDuringSetup
2661     {
2662         for (uint i = 0; i < times.length; i++) {
2663             appendVestingEntry(account, times[i], quantities[i]);
2664         }
2665 
2666     }
2667 
2668     /**
2669      * @notice Allow a user to withdraw any SNX in their schedule that have vested.
2670      */
2671     function vest()
2672         external
2673     {
2674         uint numEntries = numVestingEntries(msg.sender);
2675         uint total;
2676         for (uint i = 0; i < numEntries; i++) {
2677             uint time = getVestingTime(msg.sender, i);
2678             /* The list is sorted; when we reach the first future time, bail out. */
2679             if (time > now) {
2680                 break;
2681             }
2682             uint qty = getVestingQuantity(msg.sender, i);
2683             if (qty == 0) {
2684                 continue;
2685             }
2686 
2687             vestingSchedules[msg.sender][i] = [0, 0];
2688             total = total.add(qty);
2689         }
2690 
2691         if (total != 0) {
2692             totalVestedBalance = totalVestedBalance.sub(total);
2693             totalVestedAccountBalance[msg.sender] = totalVestedAccountBalance[msg.sender].sub(total);
2694             synthetix.transfer(msg.sender, total);
2695             emit Vested(msg.sender, now, total);
2696         }
2697     }
2698 
2699 
2700     /* ========== EVENTS ========== */
2701 
2702     event SynthetixUpdated(address newSynthetix);
2703 
2704     event Vested(address indexed beneficiary, uint time, uint value);
2705 }
2706 
2707 
2708 ////////////////// SynthetixState.sol //////////////////
2709 
2710 /*
2711 -----------------------------------------------------------------
2712 FILE INFORMATION
2713 -----------------------------------------------------------------
2714 
2715 file:       SynthetixState.sol
2716 version:    1.0
2717 author:     Kevin Brown
2718 date:       2018-10-19
2719 
2720 -----------------------------------------------------------------
2721 MODULE DESCRIPTION
2722 -----------------------------------------------------------------
2723 
2724 A contract that holds issuance state and preferred currency of
2725 users in the Synthetix system.
2726 
2727 This contract is used side by side with the Synthetix contract
2728 to make it easier to upgrade the contract logic while maintaining
2729 issuance state.
2730 
2731 The Synthetix contract is also quite large and on the edge of
2732 being beyond the contract size limit without moving this information
2733 out to another contract.
2734 
2735 The first deployed contract would create this state contract,
2736 using it as its store of issuance data.
2737 
2738 When a new contract is deployed, it links to the existing
2739 state contract, whose owner would then change its associated
2740 contract to the new one.
2741 
2742 -----------------------------------------------------------------
2743 */
2744 
2745 
2746 /**
2747  * @title Synthetix State
2748  * @notice Stores issuance information and preferred currency information of the Synthetix contract.
2749  */
2750 contract SynthetixState is State, LimitedSetup {
2751     using SafeMath for uint;
2752     using SafeDecimalMath for uint;
2753 
2754     // A struct for handing values associated with an individual user's debt position
2755     struct IssuanceData {
2756         // Percentage of the total debt owned at the time
2757         // of issuance. This number is modified by the global debt
2758         // delta array. You can figure out a user's exit price and
2759         // collateralisation ratio using a combination of their initial
2760         // debt and the slice of global debt delta which applies to them.
2761         uint initialDebtOwnership;
2762         // This lets us know when (in relative terms) the user entered
2763         // the debt pool so we can calculate their exit price and
2764         // collateralistion ratio
2765         uint debtEntryIndex;
2766     }
2767 
2768     // Issued synth balances for individual fee entitlements and exit price calculations
2769     mapping(address => IssuanceData) public issuanceData;
2770 
2771     // The total count of people that have outstanding issued synths in any flavour
2772     uint public totalIssuerCount;
2773 
2774     // Global debt pool tracking
2775     uint[] public debtLedger;
2776 
2777     // Import state
2778     uint public importedXDRAmount;
2779 
2780     // A quantity of synths greater than this ratio
2781     // may not be issued against a given value of SNX.
2782     uint public issuanceRatio = SafeDecimalMath.unit() / 5;
2783     // No more synths may be issued than the value of SNX backing them.
2784     uint constant MAX_ISSUANCE_RATIO = SafeDecimalMath.unit();
2785 
2786     // Users can specify their preferred currency, in which case all synths they receive
2787     // will automatically exchange to that preferred currency upon receipt in their wallet
2788     mapping(address => bytes4) public preferredCurrency;
2789 
2790     /**
2791      * @dev Constructor
2792      * @param _owner The address which controls this contract.
2793      * @param _associatedContract The ERC20 contract whose state this composes.
2794      */
2795     constructor(address _owner, address _associatedContract)
2796         State(_owner, _associatedContract)
2797         LimitedSetup(1 weeks)
2798         public
2799     {}
2800 
2801     /* ========== SETTERS ========== */
2802 
2803     /**
2804      * @notice Set issuance data for an address
2805      * @dev Only the associated contract may call this.
2806      * @param account The address to set the data for.
2807      * @param initialDebtOwnership The initial debt ownership for this address.
2808      */
2809     function setCurrentIssuanceData(address account, uint initialDebtOwnership)
2810         external
2811         onlyAssociatedContract
2812     {
2813         issuanceData[account].initialDebtOwnership = initialDebtOwnership;
2814         issuanceData[account].debtEntryIndex = debtLedger.length;
2815     }
2816 
2817     /**
2818      * @notice Clear issuance data for an address
2819      * @dev Only the associated contract may call this.
2820      * @param account The address to clear the data for.
2821      */
2822     function clearIssuanceData(address account)
2823         external
2824         onlyAssociatedContract
2825     {
2826         delete issuanceData[account];
2827     }
2828 
2829     /**
2830      * @notice Increment the total issuer count
2831      * @dev Only the associated contract may call this.
2832      */
2833     function incrementTotalIssuerCount()
2834         external
2835         onlyAssociatedContract
2836     {
2837         totalIssuerCount = totalIssuerCount.add(1);
2838     }
2839 
2840     /**
2841      * @notice Decrement the total issuer count
2842      * @dev Only the associated contract may call this.
2843      */
2844     function decrementTotalIssuerCount()
2845         external
2846         onlyAssociatedContract
2847     {
2848         totalIssuerCount = totalIssuerCount.sub(1);
2849     }
2850 
2851     /**
2852      * @notice Append a value to the debt ledger
2853      * @dev Only the associated contract may call this.
2854      * @param value The new value to be added to the debt ledger.
2855      */
2856     function appendDebtLedgerValue(uint value)
2857         external
2858         onlyAssociatedContract
2859     {
2860         debtLedger.push(value);
2861     }
2862 
2863     /**
2864      * @notice Set preferred currency for a user
2865      * @dev Only the associated contract may call this.
2866      * @param account The account to set the preferred currency for
2867      * @param currencyKey The new preferred currency
2868      */
2869     function setPreferredCurrency(address account, bytes4 currencyKey)
2870         external
2871         onlyAssociatedContract
2872     {
2873         preferredCurrency[account] = currencyKey;
2874     }
2875 
2876     /**
2877      * @notice Set the issuanceRatio for issuance calculations.
2878      * @dev Only callable by the contract owner.
2879      */
2880     function setIssuanceRatio(uint _issuanceRatio)
2881         external
2882         onlyOwner
2883     {
2884         require(_issuanceRatio <= MAX_ISSUANCE_RATIO, "New issuance ratio cannot exceed MAX_ISSUANCE_RATIO");
2885         issuanceRatio = _issuanceRatio;
2886         emit IssuanceRatioUpdated(_issuanceRatio);
2887     }
2888 
2889     /**
2890      * @notice Import issuer data from the old Synthetix contract before multicurrency
2891      * @dev Only callable by the contract owner, and only for 1 week after deployment.
2892      */
2893     function importIssuerData(address[] accounts, uint[] sUSDAmounts)
2894         external
2895         onlyOwner
2896         onlyDuringSetup
2897     {
2898         require(accounts.length == sUSDAmounts.length, "Length mismatch");
2899 
2900         for (uint8 i = 0; i < accounts.length; i++) {
2901             _addToDebtRegister(accounts[i], sUSDAmounts[i]);
2902         }
2903     }
2904 
2905     /**
2906      * @notice Import issuer data from the old Synthetix contract before multicurrency
2907      * @dev Only used from importIssuerData above, meant to be disposable
2908      */
2909     function _addToDebtRegister(address account, uint amount)
2910         internal
2911     {
2912         // This code is duplicated from Synthetix so that we can call it directly here
2913         // during setup only.
2914         Synthetix synthetix = Synthetix(associatedContract);
2915 
2916         // What is the value of the requested debt in XDRs?
2917         uint xdrValue = synthetix.effectiveValue("sUSD", amount, "XDR");
2918 
2919         // What is the value that we've previously imported?
2920         uint totalDebtIssued = importedXDRAmount;
2921 
2922         // What will the new total be including the new value?
2923         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
2924 
2925         // Save that for the next import.
2926         importedXDRAmount = newTotalDebtIssued;
2927 
2928         // What is their percentage (as a high precision int) of the total debt?
2929         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
2930 
2931         // And what effect does this percentage have on the global debt holding of other issuers?
2932         // The delta specifically needs to not take into account any existing debt as it's already
2933         // accounted for in the delta from when they issued previously.
2934         // The delta is a high precision integer.
2935         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
2936 
2937         uint existingDebt = synthetix.debtBalanceOf(account, "XDR");
2938 
2939         // And what does their debt ownership look like including this previous stake?
2940         if (existingDebt > 0) {
2941             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
2942         }
2943 
2944         // Are they a new issuer? If so, record them.
2945         if (issuanceData[account].initialDebtOwnership == 0) {
2946             totalIssuerCount = totalIssuerCount.add(1);
2947         }
2948 
2949         // Save the debt entry parameters
2950         issuanceData[account].initialDebtOwnership = debtPercentage;
2951         issuanceData[account].debtEntryIndex = debtLedger.length;
2952 
2953         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
2954         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
2955         if (debtLedger.length > 0) {
2956             debtLedger.push(
2957                 debtLedger[debtLedger.length - 1].multiplyDecimalRoundPrecise(delta)
2958             );
2959         } else {
2960             debtLedger.push(SafeDecimalMath.preciseUnit());
2961         }
2962     }
2963 
2964     /* ========== VIEWS ========== */
2965 
2966     /**
2967      * @notice Retrieve the length of the debt ledger array
2968      */
2969     function debtLedgerLength()
2970         external
2971         view
2972         returns (uint)
2973     {
2974         return debtLedger.length;
2975     }
2976 
2977     /**
2978      * @notice Retrieve the most recent entry from the debt ledger
2979      */
2980     function lastDebtLedgerEntry()
2981         external
2982         view
2983         returns (uint)
2984     {
2985         return debtLedger[debtLedger.length - 1];
2986     }
2987 
2988     /**
2989      * @notice Query whether an account has issued and has an outstanding debt balance
2990      * @param account The address to query for
2991      */
2992     function hasIssued(address account)
2993         external
2994         view
2995         returns (bool)
2996     {
2997         return issuanceData[account].initialDebtOwnership > 0;
2998     }
2999 
3000     event IssuanceRatioUpdated(uint newRatio);
3001 }
3002 
3003 
3004 ////////////////// ExchangeRates.sol //////////////////
3005 
3006 /*
3007 -----------------------------------------------------------------
3008 FILE INFORMATION
3009 -----------------------------------------------------------------
3010 
3011 file:       ExchangeRates.sol
3012 version:    1.0
3013 author:     Kevin Brown
3014 date:       2018-09-12
3015 
3016 -----------------------------------------------------------------
3017 MODULE DESCRIPTION
3018 -----------------------------------------------------------------
3019 
3020 A contract that any other contract in the Synthetix system can query
3021 for the current market value of various assets, including
3022 crypto assets as well as various fiat assets.
3023 
3024 This contract assumes that rate updates will completely update
3025 all rates to their current values. If a rate shock happens
3026 on a single asset, the oracle will still push updated rates
3027 for all other assets.
3028 
3029 -----------------------------------------------------------------
3030 */
3031 
3032 
3033 /**
3034  * @title The repository for exchange rates
3035  */
3036 contract ExchangeRates is SelfDestructible {
3037 
3038     using SafeMath for uint;
3039 
3040     // Exchange rates stored by currency code, e.g. 'SNX', or 'sUSD'
3041     mapping(bytes4 => uint) public rates;
3042 
3043     // Update times stored by currency code, e.g. 'SNX', or 'sUSD'
3044     mapping(bytes4 => uint) public lastRateUpdateTimes;
3045 
3046     // The address of the oracle which pushes rate updates to this contract
3047     address public oracle;
3048 
3049     // Do not allow the oracle to submit times any further forward into the future than this constant.
3050     uint constant ORACLE_FUTURE_LIMIT = 10 minutes;
3051 
3052     // How long will the contract assume the rate of any asset is correct
3053     uint public rateStalePeriod = 3 hours;
3054 
3055     // Each participating currency in the XDR basket is represented as a currency key with
3056     // equal weighting.
3057     // There are 5 participating currencies, so we'll declare that clearly.
3058     bytes4[5] public xdrParticipants;
3059 
3060     //
3061     // ========== CONSTRUCTOR ==========
3062 
3063     /**
3064      * @dev Constructor
3065      * @param _owner The owner of this contract.
3066      * @param _oracle The address which is able to update rate information.
3067      * @param _currencyKeys The initial currency keys to store (in order).
3068      * @param _newRates The initial currency amounts for each currency (in order).
3069      */
3070     constructor(
3071         // SelfDestructible (Ownable)
3072         address _owner,
3073 
3074         // Oracle values - Allows for rate updates
3075         address _oracle,
3076         bytes4[] _currencyKeys,
3077         uint[] _newRates
3078     )
3079         /* Owned is initialised in SelfDestructible */
3080         SelfDestructible(_owner)
3081         public
3082     {
3083         require(_currencyKeys.length == _newRates.length, "Currency key length and rate length must match.");
3084 
3085         oracle = _oracle;
3086 
3087         // The sUSD rate is always 1 and is never stale.
3088         rates["sUSD"] = SafeDecimalMath.unit();
3089         lastRateUpdateTimes["sUSD"] = now;
3090 
3091         // These are the currencies that make up the XDR basket.
3092         // These are hard coded because:
3093         //  - This way users can depend on the calculation and know it won't change for this deployment of the contract.
3094         //  - Adding new currencies would likely introduce some kind of weighting factor, which
3095         //    isn't worth preemptively adding when all of the currencies in the current basket are weighted at 1.
3096         //  - The expectation is if this logic needs to be updated, we'll simply deploy a new version of this contract
3097         //    then point the system at the new version.
3098         xdrParticipants = [
3099             bytes4("sUSD"),
3100             bytes4("sAUD"),
3101             bytes4("sCHF"),
3102             bytes4("sEUR"),
3103             bytes4("sGBP")
3104         ];
3105 
3106         internalUpdateRates(_currencyKeys, _newRates, now);
3107     }
3108 
3109     /* ========== SETTERS ========== */
3110 
3111     /**
3112      * @notice Set the rates stored in this contract
3113      * @param currencyKeys The currency keys you wish to update the rates for (in order)
3114      * @param newRates The rates for each currency (in order)
3115      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
3116      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
3117      *                 if it takes a long time for the transaction to confirm.
3118      */
3119     function updateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
3120         external
3121         onlyOracle
3122         returns(bool)
3123     {
3124         return internalUpdateRates(currencyKeys, newRates, timeSent);
3125     }
3126 
3127     /**
3128      * @notice Internal function which sets the rates stored in this contract
3129      * @param currencyKeys The currency keys you wish to update the rates for (in order)
3130      * @param newRates The rates for each currency (in order)
3131      * @param timeSent The timestamp of when the update was sent, specified in seconds since epoch (e.g. the same as the now keyword in solidity).contract
3132      *                 This is useful because transactions can take a while to confirm, so this way we know how old the oracle's datapoint was exactly even
3133      *                 if it takes a long time for the transaction to confirm.
3134      */
3135     function internalUpdateRates(bytes4[] currencyKeys, uint[] newRates, uint timeSent)
3136         internal
3137         returns(bool)
3138     {
3139         require(currencyKeys.length == newRates.length, "Currency key array length must match rates array length.");
3140         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
3141 
3142         // Loop through each key and perform update.
3143         for (uint i = 0; i < currencyKeys.length; i++) {
3144             // Should not set any rate to zero ever, as no asset will ever be
3145             // truely worthless and still valid. In this scenario, we should
3146             // delete the rate and remove it from the system.
3147             require(newRates[i] != 0, "Zero is not a valid rate, please call deleteRate instead.");
3148             require(currencyKeys[i] != "sUSD", "Rate of sUSD cannot be updated, it's always UNIT.");
3149 
3150             // We should only update the rate if it's at least the same age as the last rate we've got.
3151             if (timeSent >= lastRateUpdateTimes[currencyKeys[i]]) {
3152                 // Ok, go ahead with the update.
3153                 rates[currencyKeys[i]] = newRates[i];
3154                 lastRateUpdateTimes[currencyKeys[i]] = timeSent;
3155             }
3156         }
3157 
3158         emit RatesUpdated(currencyKeys, newRates);
3159 
3160         // Now update our XDR rate.
3161         updateXDRRate(timeSent);
3162 
3163         return true;
3164     }
3165 
3166     /**
3167      * @notice Update the Synthetix Drawing Rights exchange rate based on other rates already updated.
3168      */
3169     function updateXDRRate(uint timeSent)
3170         internal
3171     {
3172         uint total = 0;
3173 
3174         for (uint i = 0; i < xdrParticipants.length; i++) {
3175             total = rates[xdrParticipants[i]].add(total);
3176         }
3177 
3178         // Set the rate
3179         rates["XDR"] = total;
3180 
3181         // Record that we updated the XDR rate.
3182         lastRateUpdateTimes["XDR"] = timeSent;
3183 
3184         // Emit our updated event separate to the others to save
3185         // moving data around between arrays.
3186         bytes4[] memory eventCurrencyCode = new bytes4[](1);
3187         eventCurrencyCode[0] = "XDR";
3188 
3189         uint[] memory eventRate = new uint[](1);
3190         eventRate[0] = rates["XDR"];
3191 
3192         emit RatesUpdated(eventCurrencyCode, eventRate);
3193     }
3194 
3195     /**
3196      * @notice Delete a rate stored in the contract
3197      * @param currencyKey The currency key you wish to delete the rate for
3198      */
3199     function deleteRate(bytes4 currencyKey)
3200         external
3201         onlyOracle
3202     {
3203         require(rates[currencyKey] > 0, "Rate is zero");
3204 
3205         delete rates[currencyKey];
3206         delete lastRateUpdateTimes[currencyKey];
3207 
3208         emit RateDeleted(currencyKey);
3209     }
3210 
3211     /**
3212      * @notice Set the Oracle that pushes the rate information to this contract
3213      * @param _oracle The new oracle address
3214      */
3215     function setOracle(address _oracle)
3216         external
3217         onlyOwner
3218     {
3219         oracle = _oracle;
3220         emit OracleUpdated(oracle);
3221     }
3222 
3223     /**
3224      * @notice Set the stale period on the updated rate variables
3225      * @param _time The new rateStalePeriod
3226      */
3227     function setRateStalePeriod(uint _time)
3228         external
3229         onlyOwner
3230     {
3231         rateStalePeriod = _time;
3232         emit RateStalePeriodUpdated(rateStalePeriod);
3233     }
3234 
3235     /* ========== VIEWS ========== */
3236 
3237     /**
3238      * @notice Retrieve the rate for a specific currency
3239      */
3240     function rateForCurrency(bytes4 currencyKey)
3241         public
3242         view
3243         returns (uint)
3244     {
3245         return rates[currencyKey];
3246     }
3247 
3248     /**
3249      * @notice Retrieve the rates for a list of currencies
3250      */
3251     function ratesForCurrencies(bytes4[] currencyKeys)
3252         public
3253         view
3254         returns (uint[])
3255     {
3256         uint[] memory _rates = new uint[](currencyKeys.length);
3257 
3258         for (uint8 i = 0; i < currencyKeys.length; i++) {
3259             _rates[i] = rates[currencyKeys[i]];
3260         }
3261 
3262         return _rates;
3263     }
3264 
3265     /**
3266      * @notice Retrieve a list of last update times for specific currencies
3267      */
3268     function lastRateUpdateTimeForCurrency(bytes4 currencyKey)
3269         public
3270         view
3271         returns (uint)
3272     {
3273         return lastRateUpdateTimes[currencyKey];
3274     }
3275 
3276     /**
3277      * @notice Retrieve the last update time for a specific currency
3278      */
3279     function lastRateUpdateTimesForCurrencies(bytes4[] currencyKeys)
3280         public
3281         view
3282         returns (uint[])
3283     {
3284         uint[] memory lastUpdateTimes = new uint[](currencyKeys.length);
3285 
3286         for (uint8 i = 0; i < currencyKeys.length; i++) {
3287             lastUpdateTimes[i] = lastRateUpdateTimes[currencyKeys[i]];
3288         }
3289 
3290         return lastUpdateTimes;
3291     }
3292 
3293     /**
3294      * @notice Check if a specific currency's rate hasn't been updated for longer than the stale period.
3295      */
3296     function rateIsStale(bytes4 currencyKey)
3297         external
3298         view
3299         returns (bool)
3300     {
3301         // sUSD is a special case and is never stale.
3302         if (currencyKey == "sUSD") return false;
3303 
3304         return lastRateUpdateTimes[currencyKey].add(rateStalePeriod) < now;
3305     }
3306 
3307     /**
3308      * @notice Check if any of the currency rates passed in haven't been updated for longer than the stale period.
3309      */
3310     function anyRateIsStale(bytes4[] currencyKeys)
3311         external
3312         view
3313         returns (bool)
3314     {
3315         // Loop through each key and check whether the data point is stale.
3316         uint256 i = 0;
3317 
3318         while (i < currencyKeys.length) {
3319             // sUSD is a special case and is never false
3320             if (currencyKeys[i] != "sUSD" && lastRateUpdateTimes[currencyKeys[i]].add(rateStalePeriod) < now) {
3321                 return true;
3322             }
3323             i += 1;
3324         }
3325 
3326         return false;
3327     }
3328 
3329     /* ========== MODIFIERS ========== */
3330 
3331     modifier onlyOracle
3332     {
3333         require(msg.sender == oracle, "Only the oracle can perform this action");
3334         _;
3335     }
3336 
3337     /* ========== EVENTS ========== */
3338 
3339     event OracleUpdated(address newOracle);
3340     event RateStalePeriodUpdated(uint rateStalePeriod);
3341     event RatesUpdated(bytes4[] currencyKeys, uint[] newRates);
3342     event RateDeleted(bytes4 currencyKey);
3343 }
3344 
3345 
3346 ////////////////// Synthetix.sol //////////////////
3347 
3348 /*
3349 -----------------------------------------------------------------
3350 FILE INFORMATION
3351 -----------------------------------------------------------------
3352 
3353 file:       Synthetix.sol
3354 version:    2.0
3355 author:     Kevin Brown
3356             Gavin Conway
3357 date:       2018-09-14
3358 
3359 -----------------------------------------------------------------
3360 MODULE DESCRIPTION
3361 -----------------------------------------------------------------
3362 
3363 Synthetix token contract. SNX is a transferable ERC20 token,
3364 and also give its holders the following privileges.
3365 An owner of SNX has the right to issue synths in all synth flavours.
3366 
3367 After a fee period terminates, the duration and fees collected for that
3368 period are computed, and the next period begins. Thus an account may only
3369 withdraw the fees owed to them for the previous period, and may only do
3370 so once per period. Any unclaimed fees roll over into the common pot for
3371 the next period.
3372 
3373 == Average Balance Calculations ==
3374 
3375 The fee entitlement of a synthetix holder is proportional to their average
3376 issued synth balance over the last fee period. This is computed by
3377 measuring the area under the graph of a user's issued synth balance over
3378 time, and then when a new fee period begins, dividing through by the
3379 duration of the fee period.
3380 
3381 We need only update values when the balances of an account is modified.
3382 This occurs when issuing or burning for issued synth balances,
3383 and when transferring for synthetix balances. This is for efficiency,
3384 and adds an implicit friction to interacting with SNX.
3385 A synthetix holder pays for his own recomputation whenever he wants to change
3386 his position, which saves the foundation having to maintain a pot dedicated
3387 to resourcing this.
3388 
3389 A hypothetical user's balance history over one fee period, pictorially:
3390 
3391       s ____
3392        |    |
3393        |    |___ p
3394        |____|___|___ __ _  _
3395        f    t   n
3396 
3397 Here, the balance was s between times f and t, at which time a transfer
3398 occurred, updating the balance to p, until n, when the present transfer occurs.
3399 When a new transfer occurs at time n, the balance being p,
3400 we must:
3401 
3402   - Add the area p * (n - t) to the total area recorded so far
3403   - Update the last transfer time to n
3404 
3405 So if this graph represents the entire current fee period,
3406 the average SNX held so far is ((t-f)*s + (n-t)*p) / (n-f).
3407 The complementary computations must be performed for both sender and
3408 recipient.
3409 
3410 Note that a transfer keeps global supply of SNX invariant.
3411 The sum of all balances is constant, and unmodified by any transfer.
3412 So the sum of all balances multiplied by the duration of a fee period is also
3413 constant, and this is equivalent to the sum of the area of every user's
3414 time/balance graph. Dividing through by that duration yields back the total
3415 synthetix supply. So, at the end of a fee period, we really do yield a user's
3416 average share in the synthetix supply over that period.
3417 
3418 A slight wrinkle is introduced if we consider the time r when the fee period
3419 rolls over. Then the previous fee period k-1 is before r, and the current fee
3420 period k is afterwards. If the last transfer took place before r,
3421 but the latest transfer occurred afterwards:
3422 
3423 k-1       |        k
3424       s __|_
3425        |  | |
3426        |  | |____ p
3427        |__|_|____|___ __ _  _
3428           |
3429        f  | t    n
3430           r
3431 
3432 In this situation the area (r-f)*s contributes to fee period k-1, while
3433 the area (t-r)*s contributes to fee period k. We will implicitly consider a
3434 zero-value transfer to have occurred at time r. Their fee entitlement for the
3435 previous period will be finalised at the time of their first transfer during the
3436 current fee period, or when they query or withdraw their fee entitlement.
3437 
3438 In the implementation, the duration of different fee periods may be slightly irregular,
3439 as the check that they have rolled over occurs only when state-changing synthetix
3440 operations are performed.
3441 
3442 == Issuance and Burning ==
3443 
3444 In this version of the synthetix contract, synths can only be issued by
3445 those that have been nominated by the synthetix foundation. Synths are assumed
3446 to be valued at $1, as they are a stable unit of account.
3447 
3448 All synths issued require a proportional value of SNX to be locked,
3449 where the proportion is governed by the current issuance ratio. This
3450 means for every $1 of SNX locked up, $(issuanceRatio) synths can be issued.
3451 i.e. to issue 100 synths, 100/issuanceRatio dollars of SNX need to be locked up.
3452 
3453 To determine the value of some amount of SNX(S), an oracle is used to push
3454 the price of SNX (P_S) in dollars to the contract. The value of S
3455 would then be: S * P_S.
3456 
3457 Any SNX that are locked up by this issuance process cannot be transferred.
3458 The amount that is locked floats based on the price of SNX. If the price
3459 of SNX moves up, less SNX are locked, so they can be issued against,
3460 or transferred freely. If the price of SNX moves down, more SNX are locked,
3461 even going above the initial wallet balance.
3462 
3463 -----------------------------------------------------------------
3464 */
3465 
3466 
3467 /**
3468  * @title Synthetix ERC20 contract.
3469  * @notice The Synthetix contracts not only facilitates transfers, exchanges, and tracks balances,
3470  * but it also computes the quantity of fees each synthetix holder is entitled to.
3471  */
3472 contract Synthetix is ExternStateToken {
3473 
3474     // ========== STATE VARIABLES ==========
3475 
3476     // Available Synths which can be used with the system
3477     Synth[] public availableSynths;
3478     mapping(bytes4 => Synth) public synths;
3479 
3480     FeePool public feePool;
3481     SynthetixEscrow public escrow;
3482     ExchangeRates public exchangeRates;
3483     SynthetixState public synthetixState;
3484 
3485     uint constant SYNTHETIX_SUPPLY = 1e8 * SafeDecimalMath.unit();
3486     string constant TOKEN_NAME = "Synthetix Network Token";
3487     string constant TOKEN_SYMBOL = "SNX";
3488     uint8 constant DECIMALS = 18;
3489 
3490     // ========== CONSTRUCTOR ==========
3491 
3492     /**
3493      * @dev Constructor
3494      * @param _tokenState A pre-populated contract containing token balances.
3495      * If the provided address is 0x0, then a fresh one will be constructed with the contract owning all tokens.
3496      * @param _owner The owner of this contract.
3497      */
3498     constructor(address _proxy, TokenState _tokenState, SynthetixState _synthetixState,
3499         address _owner, ExchangeRates _exchangeRates, FeePool _feePool
3500     )
3501         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, SYNTHETIX_SUPPLY, DECIMALS, _owner)
3502         public
3503     {
3504         synthetixState = _synthetixState;
3505         exchangeRates = _exchangeRates;
3506         feePool = _feePool;
3507     }
3508 
3509     // ========== SETTERS ========== */
3510 
3511     /**
3512      * @notice Add an associated Synth contract to the Synthetix system
3513      * @dev Only the contract owner may call this.
3514      */
3515     function addSynth(Synth synth)
3516         external
3517         optionalProxy_onlyOwner
3518     {
3519         bytes4 currencyKey = synth.currencyKey();
3520 
3521         require(synths[currencyKey] == Synth(0), "Synth already exists");
3522 
3523         availableSynths.push(synth);
3524         synths[currencyKey] = synth;
3525 
3526         emitSynthAdded(currencyKey, synth);
3527     }
3528 
3529     /**
3530      * @notice Remove an associated Synth contract from the Synthetix system
3531      * @dev Only the contract owner may call this.
3532      */
3533     function removeSynth(bytes4 currencyKey)
3534         external
3535         optionalProxy_onlyOwner
3536     {
3537         require(synths[currencyKey] != address(0), "Synth does not exist");
3538         require(synths[currencyKey].totalSupply() == 0, "Synth supply exists");
3539         require(currencyKey != "XDR", "Cannot remove XDR synth");
3540 
3541         // Save the address we're removing for emitting the event at the end.
3542         address synthToRemove = synths[currencyKey];
3543 
3544         // Remove the synth from the availableSynths array.
3545         for (uint8 i = 0; i < availableSynths.length; i++) {
3546             if (availableSynths[i] == synthToRemove) {
3547                 delete availableSynths[i];
3548 
3549                 // Copy the last synth into the place of the one we just deleted
3550                 // If there's only one synth, this is synths[0] = synths[0].
3551                 // If we're deleting the last one, it's also a NOOP in the same way.
3552                 availableSynths[i] = availableSynths[availableSynths.length - 1];
3553 
3554                 // Decrease the size of the array by one.
3555                 availableSynths.length--;
3556 
3557                 break;
3558             }
3559         }
3560 
3561         // And remove it from the synths mapping
3562         delete synths[currencyKey];
3563 
3564         emitSynthRemoved(currencyKey, synthToRemove);
3565     }
3566 
3567     /**
3568      * @notice Set the associated synthetix escrow contract.
3569      * @dev Only the contract owner may call this.
3570      */
3571     function setEscrow(SynthetixEscrow _escrow)
3572         external
3573         optionalProxy_onlyOwner
3574     {
3575         escrow = _escrow;
3576         // Note: No event here as our contract exceeds max contract size
3577         // with these events, and it's unlikely people will need to
3578         // track these events specifically.
3579     }
3580 
3581     /**
3582      * @notice Set the ExchangeRates contract address where rates are held.
3583      * @dev Only callable by the contract owner.
3584      */
3585     function setExchangeRates(ExchangeRates _exchangeRates)
3586         external
3587         optionalProxy_onlyOwner
3588     {
3589         exchangeRates = _exchangeRates;
3590         // Note: No event here as our contract exceeds max contract size
3591         // with these events, and it's unlikely people will need to
3592         // track these events specifically.
3593     }
3594 
3595     /**
3596      * @notice Set the synthetixState contract address where issuance data is held.
3597      * @dev Only callable by the contract owner.
3598      */
3599     function setSynthetixState(SynthetixState _synthetixState)
3600         external
3601         optionalProxy_onlyOwner
3602     {
3603         synthetixState = _synthetixState;
3604 
3605         emitStateContractChanged(_synthetixState);
3606     }
3607 
3608     /**
3609      * @notice Set your preferred currency. Note: This does not automatically exchange any balances you've held previously in
3610      * other synth currencies in this address, it will apply for any new payments you receive at this address.
3611      */
3612     function setPreferredCurrency(bytes4 currencyKey)
3613         external
3614         optionalProxy
3615     {
3616         require(currencyKey == 0 || !exchangeRates.rateIsStale(currencyKey), "Currency rate is stale or doesn't exist.");
3617 
3618         synthetixState.setPreferredCurrency(messageSender, currencyKey);
3619 
3620         emitPreferredCurrencyChanged(messageSender, currencyKey);
3621     }
3622 
3623     // ========== VIEWS ==========
3624 
3625     /**
3626      * @notice A function that lets you easily convert an amount in a source currency to an amount in the destination currency
3627      * @param sourceCurrencyKey The currency the amount is specified in
3628      * @param sourceAmount The source amount, specified in UNIT base
3629      * @param destinationCurrencyKey The destination currency
3630      */
3631     function effectiveValue(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey)
3632         public
3633         view
3634         rateNotStale(sourceCurrencyKey)
3635         rateNotStale(destinationCurrencyKey)
3636         returns (uint)
3637     {
3638         // If there's no change in the currency, then just return the amount they gave us
3639         if (sourceCurrencyKey == destinationCurrencyKey) return sourceAmount;
3640 
3641         // Calculate the effective value by going from source -> USD -> destination
3642         return sourceAmount.multiplyDecimalRound(exchangeRates.rateForCurrency(sourceCurrencyKey))
3643             .divideDecimalRound(exchangeRates.rateForCurrency(destinationCurrencyKey));
3644     }
3645 
3646     /**
3647      * @notice Total amount of synths issued by the system, priced in currencyKey
3648      * @param currencyKey The currency to value the synths in
3649      */
3650     function totalIssuedSynths(bytes4 currencyKey)
3651         public
3652         view
3653         rateNotStale(currencyKey)
3654         returns (uint)
3655     {
3656         uint total = 0;
3657         uint currencyRate = exchangeRates.rateForCurrency(currencyKey);
3658 
3659         for (uint8 i = 0; i < availableSynths.length; i++) {
3660             // Ensure the rate isn't stale.
3661             // TODO: Investigate gas cost optimisation of doing a single call with all keys in it vs
3662             // individual calls like this.
3663             require(!exchangeRates.rateIsStale(availableSynths[i].currencyKey()), "Rate is stale");
3664 
3665             // What's the total issued value of that synth in the destination currency?
3666             // Note: We're not using our effectiveValue function because we don't want to go get the
3667             //       rate for the destination currency and check if it's stale repeatedly on every
3668             //       iteration of the loop
3669             uint synthValue = availableSynths[i].totalSupply()
3670                 .multiplyDecimalRound(exchangeRates.rateForCurrency(availableSynths[i].currencyKey()))
3671                 .divideDecimalRound(currencyRate);
3672             total = total.add(synthValue);
3673         }
3674 
3675         return total;
3676     }
3677 
3678     /**
3679      * @notice Returns the count of available synths in the system, which you can use to iterate availableSynths
3680      */
3681     function availableSynthCount()
3682         public
3683         view
3684         returns (uint)
3685     {
3686         return availableSynths.length;
3687     }
3688 
3689     // ========== MUTATIVE FUNCTIONS ==========
3690 
3691     /**
3692      * @notice ERC20 transfer function.
3693      */
3694     function transfer(address to, uint value)
3695         public
3696         returns (bool)
3697     {
3698         bytes memory empty;
3699         return transfer(to, value, empty);
3700     }
3701 
3702     /**
3703      * @notice ERC223 transfer function. Does not conform with the ERC223 spec, as:
3704      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3705      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3706      *           tooling such as Etherscan.
3707      */
3708     function transfer(address to, uint value, bytes data)
3709         public
3710         optionalProxy
3711         returns (bool)
3712     {
3713         // Ensure they're not trying to exceed their locked amount
3714         require(value <= transferableSynthetix(messageSender), "Insufficient balance");
3715 
3716         // Perform the transfer: if there is a problem an exception will be thrown in this call.
3717         _transfer_byProxy(messageSender, to, value, data);
3718 
3719         return true;
3720     }
3721 
3722     /**
3723      * @notice ERC20 transferFrom function.
3724      */
3725     function transferFrom(address from, address to, uint value)
3726         public
3727         returns (bool)
3728     {
3729         bytes memory empty;
3730         return transferFrom(from, to, value, empty);
3731     }
3732 
3733     /**
3734      * @notice ERC223 transferFrom function. Does not conform with the ERC223 spec, as:
3735      *         - Transaction doesn't revert if the recipient doesn't implement tokenFallback()
3736      *         - Emits a standard ERC20 event without the bytes data parameter so as not to confuse
3737      *           tooling such as Etherscan.
3738      */
3739     function transferFrom(address from, address to, uint value, bytes data)
3740         public
3741         optionalProxy
3742         returns (bool)
3743     {
3744         // Ensure they're not trying to exceed their locked amount
3745         require(value <= transferableSynthetix(from), "Insufficient balance");
3746 
3747         // Perform the transfer: if there is a problem,
3748         // an exception will be thrown in this call.
3749         _transferFrom_byProxy(messageSender, from, to, value, data);
3750 
3751         return true;
3752     }
3753 
3754     /**
3755      * @notice Function that allows you to exchange synths you hold in one flavour for another.
3756      * @param sourceCurrencyKey The source currency you wish to exchange from
3757      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3758      * @param destinationCurrencyKey The destination currency you wish to obtain.
3759      * @param destinationAddress Where the result should go. If this is address(0) then it sends back to the message sender.
3760      * @return Boolean that indicates whether the transfer succeeded or failed.
3761      */
3762     function exchange(bytes4 sourceCurrencyKey, uint sourceAmount, bytes4 destinationCurrencyKey, address destinationAddress)
3763         external
3764         optionalProxy
3765         // Note: We don't need to insist on non-stale rates because effectiveValue will do it for us.
3766         returns (bool)
3767     {
3768         require(sourceCurrencyKey != destinationCurrencyKey, "Exchange must use different synths");
3769         require(sourceAmount > 0, "Zero amount");
3770 
3771         // Pass it along, defaulting to the sender as the recipient.
3772         return _internalExchange(
3773             messageSender,
3774             sourceCurrencyKey,
3775             sourceAmount,
3776             destinationCurrencyKey,
3777             destinationAddress == address(0) ? messageSender : destinationAddress,
3778             true // Charge fee on the exchange
3779         );
3780     }
3781 
3782     /**
3783      * @notice Function that allows synth contract to delegate exchanging of a synth that is not the same sourceCurrency
3784      * @dev Only the synth contract can call this function
3785      * @param from The address to exchange / burn synth from
3786      * @param sourceCurrencyKey The source currency you wish to exchange from
3787      * @param sourceAmount The amount, specified in UNIT of source currency you wish to exchange
3788      * @param destinationCurrencyKey The destination currency you wish to obtain.
3789      * @param destinationAddress Where the result should go.
3790      * @return Boolean that indicates whether the transfer succeeded or failed.
3791      */
3792     function synthInitiatedExchange(
3793         address from,
3794         bytes4 sourceCurrencyKey,
3795         uint sourceAmount,
3796         bytes4 destinationCurrencyKey,
3797         address destinationAddress
3798     )
3799         external
3800         onlySynth
3801         returns (bool)
3802     {
3803         require(sourceCurrencyKey != destinationCurrencyKey, "Can't be same synth");
3804         require(sourceAmount > 0, "Zero amount");
3805 
3806         // Pass it along
3807         return _internalExchange(
3808             from,
3809             sourceCurrencyKey,
3810             sourceAmount,
3811             destinationCurrencyKey,
3812             destinationAddress,
3813             false // Don't charge fee on the exchange, as they've already been charged a transfer fee in the synth contract
3814         );
3815     }
3816 
3817     /**
3818      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3819      * @dev Only the synth contract can call this function.
3820      * @param from The address fee is coming from.
3821      * @param sourceCurrencyKey source currency fee from.
3822      * @param sourceAmount The amount, specified in UNIT of source currency.
3823      * @return Boolean that indicates whether the transfer succeeded or failed.
3824      */
3825     function synthInitiatedFeePayment(
3826         address from,
3827         bytes4 sourceCurrencyKey,
3828         uint sourceAmount
3829     )
3830         external
3831         onlySynth
3832         returns (bool)
3833     {
3834         require(sourceAmount > 0, "Source can't be 0");
3835 
3836         // Pass it along, defaulting to the sender as the recipient.
3837         bool result = _internalExchange(
3838             from,
3839             sourceCurrencyKey,
3840             sourceAmount,
3841             "XDR",
3842             feePool.FEE_ADDRESS(),
3843             false // Don't charge a fee on the exchange because this is already a fee
3844         );
3845 
3846         // Tell the fee pool about this.
3847         feePool.feePaid(sourceCurrencyKey, sourceAmount);
3848 
3849         return result;
3850     }
3851 
3852     /**
3853      * @notice Function that allows synth contract to delegate sending fee to the fee Pool.
3854      * @dev fee pool contract address is not allowed to call function
3855      * @param from The address to move synth from
3856      * @param sourceCurrencyKey source currency from.
3857      * @param sourceAmount The amount, specified in UNIT of source currency.
3858      * @param destinationCurrencyKey The destination currency to obtain.
3859      * @param destinationAddress Where the result should go.
3860      * @param chargeFee Boolean to charge a fee for transaction.
3861      * @return Boolean that indicates whether the transfer succeeded or failed.
3862      */
3863     function _internalExchange(
3864         address from,
3865         bytes4 sourceCurrencyKey,
3866         uint sourceAmount,
3867         bytes4 destinationCurrencyKey,
3868         address destinationAddress,
3869         bool chargeFee
3870     )
3871         internal
3872         notFeeAddress(from)
3873         returns (bool)
3874     {
3875         require(destinationAddress != address(0), "Zero destination");
3876         require(destinationAddress != address(this), "Synthetix is invalid destination");
3877         require(destinationAddress != address(proxy), "Proxy is invalid destination");
3878 
3879         // Note: We don't need to check their balance as the burn() below will do a safe subtraction which requires
3880         // the subtraction to not overflow, which would happen if their balance is not sufficient.
3881 
3882         // Burn the source amount
3883         synths[sourceCurrencyKey].burn(from, sourceAmount);
3884 
3885         // How much should they get in the destination currency?
3886         uint destinationAmount = effectiveValue(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
3887 
3888         // What's the fee on that currency that we should deduct?
3889         uint amountReceived = destinationAmount;
3890         uint fee = 0;
3891 
3892         if (chargeFee) {
3893             amountReceived = feePool.amountReceivedFromExchange(destinationAmount);
3894             fee = destinationAmount.sub(amountReceived);
3895         }
3896 
3897         // Issue their new synths
3898         synths[destinationCurrencyKey].issue(destinationAddress, amountReceived);
3899 
3900         // Remit the fee in XDRs
3901         if (fee > 0) {
3902             uint xdrFeeAmount = effectiveValue(destinationCurrencyKey, fee, "XDR");
3903             synths["XDR"].issue(feePool.FEE_ADDRESS(), xdrFeeAmount);
3904         }
3905 
3906         // Nothing changes as far as issuance data goes because the total value in the system hasn't changed.
3907 
3908         // Call the ERC223 transfer callback if needed
3909         synths[destinationCurrencyKey].triggerTokenFallbackIfNeeded(from, destinationAddress, amountReceived);
3910 
3911         // Gas optimisation:
3912         // No event emitted as it's assumed users will be able to track transfers to the zero address, followed
3913         // by a transfer on another synth from the zero address and ascertain the info required here.
3914 
3915         return true;
3916     }
3917 
3918     /**
3919      * @notice Function that registers new synth as they are isseud. Calculate delta to append to synthetixState.
3920      * @dev Only internal calls from synthetix address.
3921      * @param currencyKey The currency to register synths in, for example sUSD or sAUD
3922      * @param amount The amount of synths to register with a base of UNIT
3923      */
3924     function _addToDebtRegister(bytes4 currencyKey, uint amount)
3925         internal
3926         optionalProxy
3927     {
3928         // What is the value of the requested debt in XDRs?
3929         uint xdrValue = effectiveValue(currencyKey, amount, "XDR");
3930 
3931         // What is the value of all issued synths of the system (priced in XDRs)?
3932         uint totalDebtIssued = totalIssuedSynths("XDR");
3933 
3934         // What will the new total be including the new value?
3935         uint newTotalDebtIssued = xdrValue.add(totalDebtIssued);
3936 
3937         // What is their percentage (as a high precision int) of the total debt?
3938         uint debtPercentage = xdrValue.divideDecimalRoundPrecise(newTotalDebtIssued);
3939 
3940         // And what effect does this percentage have on the global debt holding of other issuers?
3941         // The delta specifically needs to not take into account any existing debt as it's already
3942         // accounted for in the delta from when they issued previously.
3943         // The delta is a high precision integer.
3944         uint delta = SafeDecimalMath.preciseUnit().sub(debtPercentage);
3945 
3946         // How much existing debt do they have?
3947         uint existingDebt = debtBalanceOf(messageSender, "XDR");
3948 
3949         // And what does their debt ownership look like including this previous stake?
3950         if (existingDebt > 0) {
3951             debtPercentage = xdrValue.add(existingDebt).divideDecimalRoundPrecise(newTotalDebtIssued);
3952         }
3953 
3954         // Are they a new issuer? If so, record them.
3955         if (!synthetixState.hasIssued(messageSender)) {
3956             synthetixState.incrementTotalIssuerCount();
3957         }
3958 
3959         // Save the debt entry parameters
3960         synthetixState.setCurrentIssuanceData(messageSender, debtPercentage);
3961 
3962         // And if we're the first, push 1 as there was no effect to any other holders, otherwise push
3963         // the change for the rest of the debt holders. The debt ledger holds high precision integers.
3964         if (synthetixState.debtLedgerLength() > 0) {
3965             synthetixState.appendDebtLedgerValue(
3966                 synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
3967             );
3968         } else {
3969             synthetixState.appendDebtLedgerValue(SafeDecimalMath.preciseUnit());
3970         }
3971     }
3972 
3973     /**
3974      * @notice Issue synths against the sender's SNX.
3975      * @dev Issuance is only allowed if the synthetix price isn't stale. Amount should be larger than 0.
3976      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3977      * @param amount The amount of synths you wish to issue with a base of UNIT
3978      */
3979     function issueSynths(bytes4 currencyKey, uint amount)
3980         public
3981         optionalProxy
3982         nonZeroAmount(amount)
3983         // No need to check if price is stale, as it is checked in issuableSynths.
3984     {
3985         require(amount <= remainingIssuableSynths(messageSender, currencyKey), "Amount too large");
3986 
3987         // Keep track of the debt they're about to create
3988         _addToDebtRegister(currencyKey, amount);
3989 
3990         // Create their synths
3991         synths[currencyKey].issue(messageSender, amount);
3992     }
3993 
3994     /**
3995      * @notice Issue the maximum amount of Synths possible against the sender's SNX.
3996      * @dev Issuance is only allowed if the synthetix price isn't stale.
3997      * @param currencyKey The currency you wish to issue synths in, for example sUSD or sAUD
3998      */
3999     function issueMaxSynths(bytes4 currencyKey)
4000         external
4001         optionalProxy
4002     {
4003         // Figure out the maximum we can issue in that currency
4004         uint maxIssuable = remainingIssuableSynths(messageSender, currencyKey);
4005 
4006         // And issue them
4007         issueSynths(currencyKey, maxIssuable);
4008     }
4009 
4010     /**
4011      * @notice Burn synths to clear issued synths/free SNX.
4012      * @param currencyKey The currency you're specifying to burn
4013      * @param amount The amount (in UNIT base) you wish to burn
4014      */
4015     function burnSynths(bytes4 currencyKey, uint amount)
4016         external
4017         optionalProxy
4018         // No need to check for stale rates as _removeFromDebtRegister calls effectiveValue
4019         // which does this for us
4020     {
4021         // How much debt do they have?
4022         uint debt = debtBalanceOf(messageSender, currencyKey);
4023 
4024         require(debt > 0, "No debt to forgive");
4025 
4026         // If they're trying to burn more debt than they actually owe, rather than fail the transaction, let's just
4027         // clear their debt and leave them be.
4028         uint amountToBurn = debt < amount ? debt : amount;
4029 
4030         // Remove their debt from the ledger
4031         _removeFromDebtRegister(currencyKey, amountToBurn);
4032 
4033         // synth.burn does a safe subtraction on balance (so it will revert if there are not enough synths).
4034         synths[currencyKey].burn(messageSender, amountToBurn);
4035     }
4036 
4037     /**
4038      * @notice Remove a debt position from the register
4039      * @param currencyKey The currency the user is presenting to forgive their debt
4040      * @param amount The amount (in UNIT base) being presented
4041      */
4042     function _removeFromDebtRegister(bytes4 currencyKey, uint amount)
4043         internal
4044     {
4045         // How much debt are they trying to remove in XDRs?
4046         uint debtToRemove = effectiveValue(currencyKey, amount, "XDR");
4047 
4048         // How much debt do they have?
4049         uint existingDebt = debtBalanceOf(messageSender, "XDR");
4050 
4051         // What percentage of the total debt are they trying to remove?
4052         uint totalDebtIssued = totalIssuedSynths("XDR");
4053         uint debtPercentage = debtToRemove.divideDecimalRoundPrecise(totalDebtIssued);
4054 
4055         // And what effect does this percentage have on the global debt holding of other issuers?
4056         // The delta specifically needs to not take into account any existing debt as it's already
4057         // accounted for in the delta from when they issued previously.
4058         uint delta = SafeDecimalMath.preciseUnit().add(debtPercentage);
4059 
4060         // Are they exiting the system, or are they just decreasing their debt position?
4061         if (debtToRemove == existingDebt) {
4062             synthetixState.clearIssuanceData(messageSender);
4063             synthetixState.decrementTotalIssuerCount();
4064         } else {
4065             // What percentage of the debt will they be left with?
4066             uint newDebt = existingDebt.sub(debtToRemove);
4067             uint newTotalDebtIssued = totalDebtIssued.sub(debtToRemove);
4068             uint newDebtPercentage = newDebt.divideDecimalRoundPrecise(newTotalDebtIssued);
4069 
4070             // Store the debt percentage and debt ledger as high precision integers
4071             synthetixState.setCurrentIssuanceData(messageSender, newDebtPercentage);
4072         }
4073 
4074         // Update our cumulative ledger. This is also a high precision integer.
4075         synthetixState.appendDebtLedgerValue(
4076             synthetixState.lastDebtLedgerEntry().multiplyDecimalRoundPrecise(delta)
4077         );
4078     }
4079 
4080     // ========== Issuance/Burning ==========
4081 
4082     /**
4083      * @notice The maximum synths an issuer can issue against their total synthetix quantity, priced in XDRs.
4084      * This ignores any already issued synths, and is purely giving you the maximimum amount the user can issue.
4085      */
4086     function maxIssuableSynths(address issuer, bytes4 currencyKey)
4087         public
4088         view
4089         // We don't need to check stale rates here as effectiveValue will do it for us.
4090         returns (uint)
4091     {
4092         // What is the value of their SNX balance in the destination currency?
4093         uint destinationValue = effectiveValue("SNX", collateral(issuer), currencyKey);
4094 
4095         // They're allowed to issue up to issuanceRatio of that value
4096         return destinationValue.multiplyDecimal(synthetixState.issuanceRatio());
4097     }
4098 
4099     /**
4100      * @notice The current collateralisation ratio for a user. Collateralisation ratio varies over time
4101      * as the value of the underlying Synthetix asset changes, e.g. if a user issues their maximum available
4102      * synths when they hold $10 worth of Synthetix, they will have issued $2 worth of synths. If the value
4103      * of Synthetix changes, the ratio returned by this function will adjust accordlingly. Users are
4104      * incentivised to maintain a collateralisation ratio as close to the issuance ratio as possible by
4105      * altering the amount of fees they're able to claim from the system.
4106      */
4107     function collateralisationRatio(address issuer)
4108         public
4109         view
4110         returns (uint)
4111     {
4112         uint totalOwnedSynthetix = collateral(issuer);
4113         if (totalOwnedSynthetix == 0) return 0;
4114 
4115         uint debtBalance = debtBalanceOf(issuer, "SNX");
4116         return debtBalance.divideDecimalRound(totalOwnedSynthetix);
4117     }
4118 
4119 /**
4120      * @notice If a user issues synths backed by SNX in their wallet, the SNX become locked. This function
4121      * will tell you how many synths a user has to give back to the system in order to unlock their original
4122      * debt position. This is priced in whichever synth is passed in as a currency key, e.g. you can price
4123      * the debt in sUSD, XDR, or any other synth you wish.
4124      */
4125     function debtBalanceOf(address issuer, bytes4 currencyKey)
4126         public
4127         view
4128         // Don't need to check for stale rates here because totalIssuedSynths will do it for us
4129         returns (uint)
4130     {
4131         // What was their initial debt ownership?
4132         uint initialDebtOwnership;
4133         uint debtEntryIndex;
4134         (initialDebtOwnership, debtEntryIndex) = synthetixState.issuanceData(issuer);
4135 
4136         // If it's zero, they haven't issued, and they have no debt.
4137         if (initialDebtOwnership == 0) return 0;
4138 
4139         // Figure out the global debt percentage delta from when they entered the system.
4140         // This is a high precision integer.
4141         uint currentDebtOwnership = synthetixState.lastDebtLedgerEntry()
4142             .divideDecimalRoundPrecise(synthetixState.debtLedger(debtEntryIndex))
4143             .multiplyDecimalRoundPrecise(initialDebtOwnership);
4144 
4145         // What's the total value of the system in their requested currency?
4146         uint totalSystemValue = totalIssuedSynths(currencyKey);
4147 
4148         // Their debt balance is their portion of the total system value.
4149         uint highPrecisionBalance = totalSystemValue.decimalToPreciseDecimal()
4150             .multiplyDecimalRoundPrecise(currentDebtOwnership);
4151 
4152         return highPrecisionBalance.preciseDecimalToDecimal();
4153     }
4154 
4155     /**
4156      * @notice The remaining synths an issuer can issue against their total synthetix balance.
4157      * @param issuer The account that intends to issue
4158      * @param currencyKey The currency to price issuable value in
4159      */
4160     function remainingIssuableSynths(address issuer, bytes4 currencyKey)
4161         public
4162         view
4163         // Don't need to check for synth existing or stale rates because maxIssuableSynths will do it for us.
4164         returns (uint)
4165     {
4166         uint alreadyIssued = debtBalanceOf(issuer, currencyKey);
4167         uint max = maxIssuableSynths(issuer, currencyKey);
4168 
4169         if (alreadyIssued >= max) {
4170             return 0;
4171         } else {
4172             return max.sub(alreadyIssued);
4173         }
4174     }
4175 
4176     /**
4177      * @notice The total SNX owned by this account, both escrowed and unescrowed,
4178      * against which synths can be issued.
4179      * This includes those already being used as collateral (locked), and those
4180      * available for further issuance (unlocked).
4181      */
4182     function collateral(address account)
4183         public
4184         view
4185         returns (uint)
4186     {
4187         uint balance = tokenState.balanceOf(account);
4188 
4189         if (escrow != address(0)) {
4190             balance = balance.add(escrow.balanceOf(account));
4191         }
4192 
4193         return balance;
4194     }
4195 
4196     /**
4197      * @notice The number of SNX that are free to be transferred by an account.
4198      * @dev When issuing, escrowed SNX are locked first, then non-escrowed
4199      * SNX are locked last, but escrowed SNX are not transferable, so they are not included
4200      * in this calculation.
4201      */
4202     function transferableSynthetix(address account)
4203         public
4204         view
4205         rateNotStale("SNX")
4206         returns (uint)
4207     {
4208         // How many SNX do they have, excluding escrow?
4209         // Note: We're excluding escrow here because we're interested in their transferable amount
4210         // and escrowed SNX are not transferable.
4211         uint balance = tokenState.balanceOf(account);
4212 
4213         // How many of those will be locked by the amount they've issued?
4214         // Assuming issuance ratio is 20%, then issuing 20 SNX of value would require
4215         // 100 SNX to be locked in their wallet to maintain their collateralisation ratio
4216         // The locked synthetix value can exceed their balance.
4217         uint lockedSynthetixValue = debtBalanceOf(account, "SNX").divideDecimalRound(synthetixState.issuanceRatio());
4218 
4219         // If we exceed the balance, no SNX are transferable, otherwise the difference is.
4220         if (lockedSynthetixValue >= balance) {
4221             return 0;
4222         } else {
4223             return balance.sub(lockedSynthetixValue);
4224         }
4225     }
4226 
4227     // ========== MODIFIERS ==========
4228 
4229     modifier rateNotStale(bytes4 currencyKey) {
4230         require(!exchangeRates.rateIsStale(currencyKey), "Rate stale or nonexistant currency");
4231         _;
4232     }
4233 
4234     modifier notFeeAddress(address account) {
4235         require(account != feePool.FEE_ADDRESS(), "Fee address not allowed");
4236         _;
4237     }
4238 
4239     modifier onlySynth() {
4240         bool isSynth = false;
4241 
4242         // No need to repeatedly call this function either
4243         for (uint8 i = 0; i < availableSynths.length; i++) {
4244             if (availableSynths[i] == msg.sender) {
4245                 isSynth = true;
4246                 break;
4247             }
4248         }
4249 
4250         require(isSynth, "Only synth allowed");
4251         _;
4252     }
4253 
4254     modifier nonZeroAmount(uint _amount) {
4255         require(_amount > 0, "Amount needs to be larger than 0");
4256         _;
4257     }
4258 
4259     // ========== EVENTS ==========
4260 
4261     event PreferredCurrencyChanged(address indexed account, bytes4 newPreferredCurrency);
4262     bytes32 constant PREFERREDCURRENCYCHANGED_SIG = keccak256("PreferredCurrencyChanged(address,bytes4)");
4263     function emitPreferredCurrencyChanged(address account, bytes4 newPreferredCurrency) internal {
4264         proxy._emit(abi.encode(newPreferredCurrency), 2, PREFERREDCURRENCYCHANGED_SIG, bytes32(account), 0, 0);
4265     }
4266 
4267     event StateContractChanged(address stateContract);
4268     bytes32 constant STATECONTRACTCHANGED_SIG = keccak256("StateContractChanged(address)");
4269     function emitStateContractChanged(address stateContract) internal {
4270         proxy._emit(abi.encode(stateContract), 1, STATECONTRACTCHANGED_SIG, 0, 0, 0);
4271     }
4272 
4273     event SynthAdded(bytes4 currencyKey, address newSynth);
4274     bytes32 constant SYNTHADDED_SIG = keccak256("SynthAdded(bytes4,address)");
4275     function emitSynthAdded(bytes4 currencyKey, address newSynth) internal {
4276         proxy._emit(abi.encode(currencyKey, newSynth), 1, SYNTHADDED_SIG, 0, 0, 0);
4277     }
4278 
4279     event SynthRemoved(bytes4 currencyKey, address removedSynth);
4280     bytes32 constant SYNTHREMOVED_SIG = keccak256("SynthRemoved(bytes4,address)");
4281     function emitSynthRemoved(bytes4 currencyKey, address removedSynth) internal {
4282         proxy._emit(abi.encode(currencyKey, removedSynth), 1, SYNTHREMOVED_SIG, 0, 0, 0);
4283     }
4284 }
4285 
4286 
4287 ////////////////// Depot.sol //////////////////
4288 
4289 /*
4290 -----------------------------------------------------------------
4291 FILE INFORMATION
4292 -----------------------------------------------------------------
4293 
4294 file:       Depot.sol
4295 version:    3.0
4296 author:     Kevin Brown
4297 date:       2018-10-23
4298 
4299 -----------------------------------------------------------------
4300 MODULE DESCRIPTION
4301 -----------------------------------------------------------------
4302 
4303 Depot contract. The Depot provides
4304 a way for users to acquire synths (Synth.sol) and SNX
4305 (Synthetix.sol) by paying ETH and a way for users to acquire SNX
4306 (Synthetix.sol) by paying synths. Users can also deposit their synths
4307 and allow other users to purchase them with ETH. The ETH is sent
4308 to the user who offered their synths for sale.
4309 
4310 This smart contract contains a balance of each token, and
4311 allows the owner of the contract (the Synthetix Foundation) to
4312 manage the available balance of synthetix at their discretion, while
4313 users are allowed to deposit and withdraw their own synth deposits
4314 if they have not yet been taken up by another user.
4315 
4316 -----------------------------------------------------------------
4317 */
4318 
4319 
4320 /**
4321  * @title Depot Contract.
4322  */
4323 contract Depot is SelfDestructible, Pausable {
4324     using SafeMath for uint;
4325     using SafeDecimalMath for uint;
4326 
4327     /* ========== STATE VARIABLES ========== */
4328     Synthetix public synthetix;
4329     Synth public synth;
4330     FeePool public feePool;
4331 
4332     // Address where the ether and Synths raised for selling SNX is transfered to
4333     // Any ether raised for selling Synths gets sent back to whoever deposited the Synths,
4334     // and doesn't have anything to do with this address.
4335     address public fundsWallet;
4336 
4337     /* The address of the oracle which pushes the USD price SNX and ether to this contract */
4338     address public oracle;
4339     /* Do not allow the oracle to submit times any further forward into the future than
4340        this constant. */
4341     uint public constant ORACLE_FUTURE_LIMIT = 10 minutes;
4342 
4343     /* How long will the contract assume the price of any asset is correct */
4344     uint public priceStalePeriod = 3 hours;
4345 
4346     /* The time the prices were last updated */
4347     uint public lastPriceUpdateTime;
4348     /* The USD price of SNX denominated in UNIT */
4349     uint public usdToSnxPrice;
4350     /* The USD price of ETH denominated in UNIT */
4351     uint public usdToEthPrice;
4352 
4353     /* Stores deposits from users. */
4354     struct synthDeposit {
4355         // The user that made the deposit
4356         address user;
4357         // The amount (in Synths) that they deposited
4358         uint amount;
4359     }
4360 
4361     /* User deposits are sold on a FIFO (First in First out) basis. When users deposit
4362        synths with us, they get added this queue, which then gets fulfilled in order.
4363        Conceptually this fits well in an array, but then when users fill an order we
4364        end up copying the whole array around, so better to use an index mapping instead
4365        for gas performance reasons.
4366 
4367        The indexes are specified (inclusive, exclusive), so (0, 0) means there's nothing
4368        in the array, and (3, 6) means there are 3 elements at 3, 4, and 5. You can obtain
4369        the length of the "array" by querying depositEndIndex - depositStartIndex. All index
4370        operations use safeAdd, so there is no way to overflow, so that means there is a
4371        very large but finite amount of deposits this contract can handle before it fills up. */
4372     mapping(uint => synthDeposit) public deposits;
4373     // The starting index of our queue inclusive
4374     uint public depositStartIndex;
4375     // The ending index of our queue exclusive
4376     uint public depositEndIndex;
4377 
4378     /* This is a convenience variable so users and dApps can just query how much sUSD
4379        we have available for purchase without having to iterate the mapping with a
4380        O(n) amount of calls for something we'll probably want to display quite regularly. */
4381     uint public totalSellableDeposits;
4382 
4383     // The minimum amount of sUSD required to enter the FiFo queue
4384     uint public minimumDepositAmount = 50 * SafeDecimalMath.unit();
4385 
4386     // If a user deposits a synth amount < the minimumDepositAmount the contract will keep
4387     // the total of small deposits which will not be sold on market and the sender
4388     // must call withdrawMyDepositedSynths() to get them back.
4389     mapping(address => uint) public smallDeposits;
4390 
4391 
4392     /* ========== CONSTRUCTOR ========== */
4393 
4394     /**
4395      * @dev Constructor
4396      * @param _owner The owner of this contract.
4397      * @param _fundsWallet The recipient of ETH and Synths that are sent to this contract while exchanging.
4398      * @param _synthetix The Synthetix contract we'll interact with for balances and sending.
4399      * @param _synth The Synth contract we'll interact with for balances and sending.
4400      * @param _oracle The address which is able to update price information.
4401      * @param _usdToEthPrice The current price of ETH in USD, expressed in UNIT.
4402      * @param _usdToSnxPrice The current price of Synthetix in USD, expressed in UNIT.
4403      */
4404     constructor(
4405         // Ownable
4406         address _owner,
4407 
4408         // Funds Wallet
4409         address _fundsWallet,
4410 
4411         // Other contracts needed
4412         Synthetix _synthetix,
4413         Synth _synth,
4414 		FeePool _feePool,
4415 
4416         // Oracle values - Allows for price updates
4417         address _oracle,
4418         uint _usdToEthPrice,
4419         uint _usdToSnxPrice
4420     )
4421         /* Owned is initialised in SelfDestructible */
4422         SelfDestructible(_owner)
4423         Pausable(_owner)
4424         public
4425     {
4426         fundsWallet = _fundsWallet;
4427         synthetix = _synthetix;
4428         synth = _synth;
4429         feePool = _feePool;
4430         oracle = _oracle;
4431         usdToEthPrice = _usdToEthPrice;
4432         usdToSnxPrice = _usdToSnxPrice;
4433         lastPriceUpdateTime = now;
4434     }
4435 
4436     /* ========== SETTERS ========== */
4437 
4438     /**
4439      * @notice Set the funds wallet where ETH raised is held
4440      * @param _fundsWallet The new address to forward ETH and Synths to
4441      */
4442     function setFundsWallet(address _fundsWallet)
4443         external
4444         onlyOwner
4445     {
4446         fundsWallet = _fundsWallet;
4447         emit FundsWalletUpdated(fundsWallet);
4448     }
4449 
4450     /**
4451      * @notice Set the Oracle that pushes the synthetix price to this contract
4452      * @param _oracle The new oracle address
4453      */
4454     function setOracle(address _oracle)
4455         external
4456         onlyOwner
4457     {
4458         oracle = _oracle;
4459         emit OracleUpdated(oracle);
4460     }
4461 
4462     /**
4463      * @notice Set the Synth contract that the issuance controller uses to issue Synths.
4464      * @param _synth The new synth contract target
4465      */
4466     function setSynth(Synth _synth)
4467         external
4468         onlyOwner
4469     {
4470         synth = _synth;
4471         emit SynthUpdated(_synth);
4472     }
4473 
4474     /**
4475      * @notice Set the Synthetix contract that the issuance controller uses to issue SNX.
4476      * @param _synthetix The new synthetix contract target
4477      */
4478     function setSynthetix(Synthetix _synthetix)
4479         external
4480         onlyOwner
4481     {
4482         synthetix = _synthetix;
4483         emit SynthetixUpdated(_synthetix);
4484     }
4485 
4486     /**
4487      * @notice Set the stale period on the updated price variables
4488      * @param _time The new priceStalePeriod
4489      */
4490     function setPriceStalePeriod(uint _time)
4491         external
4492         onlyOwner
4493     {
4494         priceStalePeriod = _time;
4495         emit PriceStalePeriodUpdated(priceStalePeriod);
4496     }
4497 
4498     /**
4499      * @notice Set the minimum deposit amount required to depoist sUSD into the FIFO queue
4500      * @param _amount The new new minimum number of sUSD required to deposit
4501      */
4502     function setMinimumDepositAmount(uint _amount)
4503         external
4504         onlyOwner
4505     {
4506         // Do not allow us to set it less than 1 dollar opening up to fractional desposits in the queue again
4507         require(_amount > SafeDecimalMath.unit(), "Minimum deposit amount must be greater than UNIT");
4508         minimumDepositAmount = _amount;
4509         emit MinimumDepositAmountUpdated(minimumDepositAmount);
4510     }
4511 
4512     /* ========== MUTATIVE FUNCTIONS ========== */
4513     /**
4514      * @notice Access point for the oracle to update the prices of SNX / eth.
4515      * @param newEthPrice The current price of ether in USD, specified to 18 decimal places.
4516      * @param newSynthetixPrice The current price of SNX in USD, specified to 18 decimal places.
4517      * @param timeSent The timestamp from the oracle when the transaction was created. This ensures we don't consider stale prices as current in times of heavy network congestion.
4518      */
4519     function updatePrices(uint newEthPrice, uint newSynthetixPrice, uint timeSent)
4520         external
4521         onlyOracle
4522     {
4523         /* Must be the most recently sent price, but not too far in the future.
4524          * (so we can't lock ourselves out of updating the oracle for longer than this) */
4525         require(lastPriceUpdateTime < timeSent, "Time must be later than last update");
4526         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time must be less than now + ORACLE_FUTURE_LIMIT");
4527 
4528         usdToEthPrice = newEthPrice;
4529         usdToSnxPrice = newSynthetixPrice;
4530         lastPriceUpdateTime = timeSent;
4531 
4532         emit PricesUpdated(usdToEthPrice, usdToSnxPrice, lastPriceUpdateTime);
4533     }
4534 
4535     /**
4536      * @notice Fallback function (exchanges ETH to sUSD)
4537      */
4538     function ()
4539         external
4540         payable
4541     {
4542         exchangeEtherForSynths();
4543     }
4544 
4545     /**
4546      * @notice Exchange ETH to sUSD.
4547      */
4548     function exchangeEtherForSynths()
4549         public
4550         payable
4551         pricesNotStale
4552         notPaused
4553         returns (uint) // Returns the number of Synths (sUSD) received
4554     {
4555         uint ethToSend;
4556 
4557         // The multiplication works here because usdToEthPrice is specified in
4558         // 18 decimal places, just like our currency base.
4559         uint requestedToPurchase = msg.value.multiplyDecimal(usdToEthPrice);
4560         uint remainingToFulfill = requestedToPurchase;
4561 
4562         // Iterate through our outstanding deposits and sell them one at a time.
4563         for (uint i = depositStartIndex; remainingToFulfill > 0 && i < depositEndIndex; i++) {
4564             synthDeposit memory deposit = deposits[i];
4565 
4566             // If it's an empty spot in the queue from a previous withdrawal, just skip over it and
4567             // update the queue. It's already been deleted.
4568             if (deposit.user == address(0)) {
4569 
4570                 depositStartIndex = depositStartIndex.add(1);
4571             } else {
4572                 // If the deposit can more than fill the order, we can do this
4573                 // without touching the structure of our queue.
4574                 if (deposit.amount > remainingToFulfill) {
4575 
4576                     // Ok, this deposit can fulfill the whole remainder. We don't need
4577                     // to change anything about our queue we can just fulfill it.
4578                     // Subtract the amount from our deposit and total.
4579                     uint newAmount = deposit.amount.sub(remainingToFulfill);
4580                     deposits[i] = synthDeposit({ user: deposit.user, amount: newAmount});
4581                     
4582                     totalSellableDeposits = totalSellableDeposits.sub(remainingToFulfill);
4583 
4584                     // Transfer the ETH to the depositor. Send is used instead of transfer
4585                     // so a non payable contract won't block the FIFO queue on a failed
4586                     // ETH payable for synths transaction. The proceeds to be sent to the
4587                     // synthetix foundation funds wallet. This is to protect all depositors
4588                     // in the queue in this rare case that may occur.
4589                     ethToSend = remainingToFulfill.divideDecimal(usdToEthPrice);
4590 
4591                     // We need to use send here instead of transfer because transfer reverts
4592                     // if the recipient is a non-payable contract. Send will just tell us it
4593                     // failed by returning false at which point we can continue.
4594                     // solium-disable-next-line security/no-send
4595                     if(!deposit.user.send(ethToSend)) {
4596                         fundsWallet.transfer(ethToSend);
4597                         emit NonPayableContract(deposit.user, ethToSend);
4598                     } else {
4599                         emit ClearedDeposit(msg.sender, deposit.user, ethToSend, remainingToFulfill, i);
4600                     }
4601 
4602                     // And the Synths to the recipient.
4603                     // Note: Fees are calculated by the Synth contract, so when
4604                     //       we request a specific transfer here, the fee is
4605                     //       automatically deducted and sent to the fee pool.
4606                     synth.transfer(msg.sender, remainingToFulfill);
4607 
4608                     // And we have nothing left to fulfill on this order.
4609                     remainingToFulfill = 0;
4610                 } else if (deposit.amount <= remainingToFulfill) {
4611                     // We need to fulfill this one in its entirety and kick it out of the queue.
4612                     // Start by kicking it out of the queue.
4613                     // Free the storage because we can.
4614                     delete deposits[i];
4615                     // Bump our start index forward one.
4616                     depositStartIndex = depositStartIndex.add(1);
4617                     // We also need to tell our total it's decreased
4618                     totalSellableDeposits = totalSellableDeposits.sub(deposit.amount);
4619 
4620                     // Now fulfill by transfering the ETH to the depositor. Send is used instead of transfer
4621                     // so a non payable contract won't block the FIFO queue on a failed
4622                     // ETH payable for synths transaction. The proceeds to be sent to the
4623                     // synthetix foundation funds wallet. This is to protect all depositors
4624                     // in the queue in this rare case that may occur.
4625                     ethToSend = deposit.amount.divideDecimal(usdToEthPrice);
4626 
4627                     // We need to use send here instead of transfer because transfer reverts
4628                     // if the recipient is a non-payable contract. Send will just tell us it
4629                     // failed by returning false at which point we can continue.
4630                     // solium-disable-next-line security/no-send
4631                     if(!deposit.user.send(ethToSend)) {
4632                         fundsWallet.transfer(ethToSend);
4633                         emit NonPayableContract(deposit.user, ethToSend);
4634                     } else {
4635                         emit ClearedDeposit(msg.sender, deposit.user, ethToSend, deposit.amount, i);
4636                     }
4637 
4638                     // And the Synths to the recipient.
4639                     // Note: Fees are calculated by the Synth contract, so when
4640                     //       we request a specific transfer here, the fee is
4641                     //       automatically deducted and sent to the fee pool.
4642                     synth.transfer(msg.sender, deposit.amount);
4643 
4644                     // And subtract the order from our outstanding amount remaining
4645                     // for the next iteration of the loop.
4646                     remainingToFulfill = remainingToFulfill.sub(deposit.amount);
4647                 }
4648             }
4649         }
4650 
4651         // Ok, if we're here and 'remainingToFulfill' isn't zero, then
4652         // we need to refund the remainder of their ETH back to them.
4653         if (remainingToFulfill > 0) {
4654             msg.sender.transfer(remainingToFulfill.divideDecimal(usdToEthPrice));
4655         }
4656 
4657         // How many did we actually give them?
4658         uint fulfilled = requestedToPurchase.sub(remainingToFulfill);
4659 
4660         if (fulfilled > 0) {
4661             // Now tell everyone that we gave them that many (only if the amount is greater than 0).
4662             emit Exchange("ETH", msg.value, "sUSD", fulfilled);
4663         }
4664 
4665         return fulfilled;
4666     }
4667 
4668     /**
4669      * @notice Exchange ETH to sUSD while insisting on a particular rate. This allows a user to
4670      *         exchange while protecting against frontrunning by the contract owner on the exchange rate.
4671      * @param guaranteedRate The exchange rate (ether price) which must be honored or the call will revert.
4672      */
4673     function exchangeEtherForSynthsAtRate(uint guaranteedRate)
4674         public
4675         payable
4676         pricesNotStale
4677         notPaused
4678         returns (uint) // Returns the number of Synths (sUSD) received
4679     {
4680         require(guaranteedRate == usdToEthPrice, "Guaranteed rate would not be received");
4681 
4682         return exchangeEtherForSynths();
4683     }
4684 
4685 
4686     /**
4687      * @notice Exchange ETH to SNX.
4688      */
4689     function exchangeEtherForSynthetix()
4690         public
4691         payable
4692         pricesNotStale
4693         notPaused
4694         returns (uint) // Returns the number of SNX received
4695     {
4696         // How many SNX are they going to be receiving?
4697         uint synthetixToSend = synthetixReceivedForEther(msg.value);
4698 
4699         // Store the ETH in our funds wallet
4700         fundsWallet.transfer(msg.value);
4701 
4702         // And send them the SNX.
4703         synthetix.transfer(msg.sender, synthetixToSend);
4704 
4705         emit Exchange("ETH", msg.value, "SNX", synthetixToSend);
4706 
4707         return synthetixToSend;
4708     }
4709 
4710     /**
4711      * @notice Exchange ETH to SNX while insisting on a particular set of rates. This allows a user to
4712      *         exchange while protecting against frontrunning by the contract owner on the exchange rates.
4713      * @param guaranteedEtherRate The ether exchange rate which must be honored or the call will revert.
4714      * @param guaranteedSynthetixRate The synthetix exchange rate which must be honored or the call will revert.
4715      */
4716     function exchangeEtherForSynthetixAtRate(uint guaranteedEtherRate, uint guaranteedSynthetixRate)
4717         public
4718         payable
4719         pricesNotStale
4720         notPaused
4721         returns (uint) // Returns the number of SNX received
4722     {
4723         require(guaranteedEtherRate == usdToEthPrice, "Guaranteed ether rate would not be received");
4724         require(guaranteedSynthetixRate == usdToSnxPrice, "Guaranteed synthetix rate would not be received");
4725 
4726         return exchangeEtherForSynthetix();
4727     }
4728 
4729 
4730     /**
4731      * @notice Exchange sUSD for SNX
4732      * @param synthAmount The amount of synths the user wishes to exchange.
4733      */
4734     function exchangeSynthsForSynthetix(uint synthAmount)
4735         public
4736         pricesNotStale
4737         notPaused
4738         returns (uint) // Returns the number of SNX received
4739     {
4740         // How many SNX are they going to be receiving?
4741         uint synthetixToSend = synthetixReceivedForSynths(synthAmount);
4742 
4743         // Ok, transfer the Synths to our funds wallet.
4744         // These do not go in the deposit queue as they aren't for sale as such unless
4745         // they're sent back in from the funds wallet.
4746         synth.transferFrom(msg.sender, fundsWallet, synthAmount);
4747 
4748         // And send them the SNX.
4749         synthetix.transfer(msg.sender, synthetixToSend);
4750 
4751         emit Exchange("sUSD", synthAmount, "SNX", synthetixToSend);
4752 
4753         return synthetixToSend;
4754     }
4755 
4756     /**
4757      * @notice Exchange sUSD for SNX while insisting on a particular rate. This allows a user to
4758      *         exchange while protecting against frontrunning by the contract owner on the exchange rate.
4759      * @param synthAmount The amount of synths the user wishes to exchange.
4760      * @param guaranteedRate A rate (synthetix price) the caller wishes to insist upon.
4761      */
4762     function exchangeSynthsForSynthetixAtRate(uint synthAmount, uint guaranteedRate)
4763         public
4764         pricesNotStale
4765         notPaused
4766         returns (uint) // Returns the number of SNX received
4767     {
4768         require(guaranteedRate == usdToSnxPrice, "Guaranteed rate would not be received");
4769 
4770         return exchangeSynthsForSynthetix(synthAmount);
4771     }
4772 
4773     /**
4774      * @notice Allows the owner to withdraw SNX from this contract if needed.
4775      * @param amount The amount of SNX to attempt to withdraw (in 18 decimal places).
4776      */
4777     function withdrawSynthetix(uint amount)
4778         external
4779         onlyOwner
4780     {
4781         synthetix.transfer(owner, amount);
4782 
4783         // We don't emit our own events here because we assume that anyone
4784         // who wants to watch what the Issuance Controller is doing can
4785         // just watch ERC20 events from the Synth and/or Synthetix contracts
4786         // filtered to our address.
4787     }
4788 
4789     /**
4790      * @notice Allows a user to withdraw all of their previously deposited synths from this contract if needed.
4791      *         Developer note: We could keep an index of address to deposits to make this operation more efficient
4792      *         but then all the other operations on the queue become less efficient. It's expected that this
4793      *         function will be very rarely used, so placing the inefficiency here is intentional. The usual
4794      *         use case does not involve a withdrawal.
4795      */
4796     function withdrawMyDepositedSynths()
4797         external
4798     {
4799         uint synthsToSend = 0;
4800 
4801         for (uint i = depositStartIndex; i < depositEndIndex; i++) {
4802             synthDeposit memory deposit = deposits[i];
4803 
4804             if (deposit.user == msg.sender) {
4805                 // The user is withdrawing this deposit. Remove it from our queue.
4806                 // We'll just leave a gap, which the purchasing logic can walk past.
4807                 synthsToSend = synthsToSend.add(deposit.amount);
4808                 delete deposits[i];
4809                 //Let the DApps know we've removed this deposit
4810                 emit SynthDepositRemoved(deposit.user, deposit.amount, i);
4811             }
4812         }
4813 
4814         // Update our total
4815         totalSellableDeposits = totalSellableDeposits.sub(synthsToSend);
4816 
4817         // Check if the user has tried to send deposit amounts < the minimumDepositAmount to the FIFO
4818         // queue which would have been added to this mapping for withdrawal only
4819         synthsToSend = synthsToSend.add(smallDeposits[msg.sender]);
4820         smallDeposits[msg.sender] = 0;
4821 
4822         // If there's nothing to do then go ahead and revert the transaction
4823         require(synthsToSend > 0, "You have no deposits to withdraw.");
4824 
4825         // Send their deposits back to them (minus fees)
4826         synth.transfer(msg.sender, synthsToSend);
4827 
4828         emit SynthWithdrawal(msg.sender, synthsToSend);
4829     }
4830 
4831     /**
4832      * @notice depositSynths: Allows users to deposit synths via the approve / transferFrom workflow
4833      *         if they'd like. You can equally just transfer synths to this contract and it will work
4834      *         exactly the same way but with one less call (and therefore cheaper transaction fees)
4835      * @param amount The amount of sUSD you wish to deposit (must have been approved first)
4836      */
4837     function depositSynths(uint amount)
4838         external
4839     {
4840         // Grab the amount of synths
4841         synth.transferFrom(msg.sender, this, amount);
4842 
4843         // Note, we don't need to add them to the deposit list below, as the Synth contract itself will
4844         // call tokenFallback when the transfer happens, adding their deposit to the queue.
4845     }
4846 
4847     /**
4848      * @notice Triggers when users send us SNX or sUSD, but the modifier only allows sUSD calls to proceed.
4849      * @param from The address sending the sUSD
4850      * @param amount The amount of sUSD
4851      */
4852     function tokenFallback(address from, uint amount, bytes data)
4853         external
4854         onlySynth
4855         returns (bool)
4856     {
4857         // A minimum deposit amount is designed to protect purchasers from over paying
4858         // gas for fullfilling multiple small synth deposits
4859         if (amount < minimumDepositAmount) {
4860             // We cant fail/revert the transaction or send the synths back in a reentrant call.
4861             // So we will keep your synths balance seperate from the FIFO queue so you can withdraw them
4862             smallDeposits[from] = smallDeposits[from].add(amount);
4863 
4864             emit SynthDepositNotAccepted(from, amount, minimumDepositAmount);
4865         } else {
4866             // Ok, thanks for the deposit, let's queue it up.
4867             deposits[depositEndIndex] = synthDeposit({ user: from, amount: amount });
4868             emit SynthDeposit(from, amount, depositEndIndex);
4869 
4870             // Walk our index forward as well.
4871             depositEndIndex = depositEndIndex.add(1);
4872 
4873             // And add it to our total.
4874             totalSellableDeposits = totalSellableDeposits.add(amount);
4875         }
4876     }
4877 
4878     /* ========== VIEWS ========== */
4879     /**
4880      * @notice Check if the prices haven't been updated for longer than the stale period.
4881      */
4882     function pricesAreStale()
4883         public
4884         view
4885         returns (bool)
4886     {
4887         return lastPriceUpdateTime.add(priceStalePeriod) < now;
4888     }
4889 
4890     /**
4891      * @notice Calculate how many SNX you will receive if you transfer
4892      *         an amount of synths.
4893      * @param amount The amount of synths (in 18 decimal places) you want to ask about
4894      */
4895     function synthetixReceivedForSynths(uint amount)
4896         public
4897         view
4898         returns (uint)
4899     {
4900         // How many synths would we receive after the transfer fee?
4901         uint synthsReceived = feePool.amountReceivedFromTransfer(amount);
4902 
4903         // And what would that be worth in SNX based on the current price?
4904         return synthsReceived.divideDecimal(usdToSnxPrice);
4905     }
4906 
4907     /**
4908      * @notice Calculate how many SNX you will receive if you transfer
4909      *         an amount of ether.
4910      * @param amount The amount of ether (in wei) you want to ask about
4911      */
4912     function synthetixReceivedForEther(uint amount)
4913         public
4914         view
4915         returns (uint)
4916     {
4917         // How much is the ETH they sent us worth in sUSD (ignoring the transfer fee)?
4918         uint valueSentInSynths = amount.multiplyDecimal(usdToEthPrice);
4919 
4920         // Now, how many SNX will that USD amount buy?
4921         return synthetixReceivedForSynths(valueSentInSynths);
4922     }
4923 
4924     /**
4925      * @notice Calculate how many synths you will receive if you transfer
4926      *         an amount of ether.
4927      * @param amount The amount of ether (in wei) you want to ask about
4928      */
4929     function synthsReceivedForEther(uint amount)
4930         public
4931         view
4932         returns (uint)
4933     {
4934         // How many synths would that amount of ether be worth?
4935         uint synthsTransferred = amount.multiplyDecimal(usdToEthPrice);
4936 
4937         // And how many of those would you receive after a transfer (deducting the transfer fee)
4938         return feePool.amountReceivedFromTransfer(synthsTransferred);
4939     }
4940 
4941     /* ========== MODIFIERS ========== */
4942 
4943     modifier onlyOracle
4944     {
4945         require(msg.sender == oracle, "Only the oracle can perform this action");
4946         _;
4947     }
4948 
4949     modifier onlySynth
4950     {
4951         // We're only interested in doing anything on receiving sUSD.
4952         require(msg.sender == address(synth), "Only the synth contract can perform this action");
4953         _;
4954     }
4955 
4956     modifier pricesNotStale
4957     {
4958         require(!pricesAreStale(), "Prices must not be stale to perform this action");
4959         _;
4960     }
4961 
4962     /* ========== EVENTS ========== */
4963 
4964     event FundsWalletUpdated(address newFundsWallet);
4965     event OracleUpdated(address newOracle);
4966     event SynthUpdated(Synth newSynthContract);
4967     event SynthetixUpdated(Synthetix newSynthetixContract);
4968     event PriceStalePeriodUpdated(uint priceStalePeriod);
4969     event PricesUpdated(uint newEthPrice, uint newSynthetixPrice, uint timeSent);
4970     event Exchange(string fromCurrency, uint fromAmount, string toCurrency, uint toAmount);
4971     event SynthWithdrawal(address user, uint amount);
4972     event SynthDeposit(address indexed user, uint amount, uint indexed depositIndex);
4973     event SynthDepositRemoved(address indexed user, uint amount, uint indexed depositIndex);
4974     event SynthDepositNotAccepted(address user, uint amount, uint minimum);
4975     event MinimumDepositAmountUpdated(uint amount);
4976     event NonPayableContract(address indexed receiver, uint amount);
4977     event ClearedDeposit(address indexed fromAddress, address indexed toAddress, uint fromETHAmount, uint toAmount, uint indexed depositIndex);
4978 }