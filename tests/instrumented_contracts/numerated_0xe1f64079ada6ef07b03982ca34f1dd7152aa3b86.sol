1 /*
2 * Synthetix - Depot.sol
3 *
4 * https://github.com/Synthetixio/synthetix
5 * https://synthetix.io
6 *
7 * MIT License
8 * ===========
9 *
10 * Copyright (c) 2020 Synthetix
11 *
12 * Permission is hereby granted, free of charge, to any person obtaining a copy
13 * of this software and associated documentation files (the "Software"), to deal
14 * in the Software without restriction, including without limitation the rights
15 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 * copies of the Software, and to permit persons to whom the Software is
17 * furnished to do so, subject to the following conditions:
18 *
19 * The above copyright notice and this permission notice shall be included in all
20 * copies or substantial portions of the Software.
21 *
22 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
25 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,	
27 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
28 */
29     
30 /* ===============================================
31 * Flattened with Solidifier by Coinage
32 * 
33 * https://solidifier.coina.ge
34 * ===============================================
35 */
36 
37 
38 pragma solidity ^0.4.24;
39 
40 /**
41  * @title Helps contracts guard against reentrancy attacks.
42  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
43  * @dev If you mark a function `nonReentrant`, you should also
44  * mark it `external`.
45  */
46 contract ReentrancyGuard {
47 
48   /// @dev counter to allow mutex lock with only one SSTORE operation
49   uint256 private _guardCounter;
50 
51   constructor() internal {
52     // The counter starts at one to prevent changing it from zero to a non-zero
53     // value, which is a more expensive operation.
54     _guardCounter = 1;
55   }
56 
57   /**
58    * @dev Prevents a contract from calling itself, directly or indirectly.
59    * Calling a `nonReentrant` function from another `nonReentrant`
60    * function is not supported. It is possible to prevent this from happening
61    * by making the `nonReentrant` function external, and make it call a
62    * `private` function that does the actual work.
63    */
64   modifier nonReentrant() {
65     _guardCounter += 1;
66     uint256 localCounter = _guardCounter;
67     _;
68     require(localCounter == _guardCounter);
69   }
70 
71 }
72 
73 
74 /*
75 -----------------------------------------------------------------
76 FILE INFORMATION
77 -----------------------------------------------------------------
78 
79 file:       Owned.sol
80 version:    1.1
81 author:     Anton Jurisevic
82             Dominic Romanowski
83 
84 date:       2018-2-26
85 
86 -----------------------------------------------------------------
87 MODULE DESCRIPTION
88 -----------------------------------------------------------------
89 
90 An Owned contract, to be inherited by other contracts.
91 Requires its owner to be explicitly set in the constructor.
92 Provides an onlyOwner access modifier.
93 
94 To change owner, the current owner must nominate the next owner,
95 who then has to accept the nomination. The nomination can be
96 cancelled before it is accepted by the new owner by having the
97 previous owner change the nomination (setting it to 0).
98 
99 -----------------------------------------------------------------
100 */
101 
102 
103 /**
104  * @title A contract with an owner.
105  * @notice Contract ownership can be transferred by first nominating the new owner,
106  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
107  */
108 contract Owned {
109     address public owner;
110     address public nominatedOwner;
111 
112     /**
113      * @dev Owned Constructor
114      */
115     constructor(address _owner) public {
116         require(_owner != address(0), "Owner address cannot be 0");
117         owner = _owner;
118         emit OwnerChanged(address(0), _owner);
119     }
120 
121     /**
122      * @notice Nominate a new owner of this contract.
123      * @dev Only the current owner may nominate a new owner.
124      */
125     function nominateNewOwner(address _owner) external onlyOwner {
126         nominatedOwner = _owner;
127         emit OwnerNominated(_owner);
128     }
129 
130     /**
131      * @notice Accept the nomination to be owner.
132      */
133     function acceptOwnership() external {
134         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
135         emit OwnerChanged(owner, nominatedOwner);
136         owner = nominatedOwner;
137         nominatedOwner = address(0);
138     }
139 
140     modifier onlyOwner {
141         require(msg.sender == owner, "Only the contract owner may perform this action");
142         _;
143     }
144 
145     event OwnerNominated(address newOwner);
146     event OwnerChanged(address oldOwner, address newOwner);
147 }
148 
149 
150 /*
151 -----------------------------------------------------------------
152 FILE INFORMATION
153 -----------------------------------------------------------------
154 
155 file:       SelfDestructible.sol
156 version:    1.2
157 author:     Anton Jurisevic
158 
159 date:       2018-05-29
160 
161 -----------------------------------------------------------------
162 MODULE DESCRIPTION
163 -----------------------------------------------------------------
164 
165 This contract allows an inheriting contract to be destroyed after
166 its owner indicates an intention and then waits for a period
167 without changing their mind. All ether contained in the contract
168 is forwarded to a nominated beneficiary upon destruction.
169 
170 -----------------------------------------------------------------
171 */
172 
173 
174 /**
175  * @title A contract that can be destroyed by its owner after a delay elapses.
176  */
177 contract SelfDestructible is Owned {
178     uint public initiationTime;
179     bool public selfDestructInitiated;
180     address public selfDestructBeneficiary;
181     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
182 
183     /**
184      * @dev Constructor
185      * @param _owner The account which controls this contract.
186      */
187     constructor(address _owner) public Owned(_owner) {
188         require(_owner != address(0), "Owner must not be zero");
189         selfDestructBeneficiary = _owner;
190         emit SelfDestructBeneficiaryUpdated(_owner);
191     }
192 
193     /**
194      * @notice Set the beneficiary address of this contract.
195      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
196      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
197      */
198     function setSelfDestructBeneficiary(address _beneficiary) external onlyOwner {
199         require(_beneficiary != address(0), "Beneficiary must not be zero");
200         selfDestructBeneficiary = _beneficiary;
201         emit SelfDestructBeneficiaryUpdated(_beneficiary);
202     }
203 
204     /**
205      * @notice Begin the self-destruction counter of this contract.
206      * Once the delay has elapsed, the contract may be self-destructed.
207      * @dev Only the contract owner may call this.
208      */
209     function initiateSelfDestruct() external onlyOwner {
210         initiationTime = now;
211         selfDestructInitiated = true;
212         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
213     }
214 
215     /**
216      * @notice Terminate and reset the self-destruction timer.
217      * @dev Only the contract owner may call this.
218      */
219     function terminateSelfDestruct() external onlyOwner {
220         initiationTime = 0;
221         selfDestructInitiated = false;
222         emit SelfDestructTerminated();
223     }
224 
225     /**
226      * @notice If the self-destruction delay has elapsed, destroy this contract and
227      * remit any ether it owns to the beneficiary address.
228      * @dev Only the contract owner may call this.
229      */
230     function selfDestruct() external onlyOwner {
231         require(selfDestructInitiated, "Self Destruct not yet initiated");
232         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay not met");
233         address beneficiary = selfDestructBeneficiary;
234         emit SelfDestructed(beneficiary);
235         selfdestruct(beneficiary);
236     }
237 
238     event SelfDestructTerminated();
239     event SelfDestructed(address beneficiary);
240     event SelfDestructInitiated(uint selfDestructDelay);
241     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
242 }
243 
244 
245 /*
246 -----------------------------------------------------------------
247 FILE INFORMATION
248 -----------------------------------------------------------------
249 
250 file:       Pausable.sol
251 version:    1.0
252 author:     Kevin Brown
253 
254 date:       2018-05-22
255 
256 -----------------------------------------------------------------
257 MODULE DESCRIPTION
258 -----------------------------------------------------------------
259 
260 This contract allows an inheriting contract to be marked as
261 paused. It also defines a modifier which can be used by the
262 inheriting contract to prevent actions while paused.
263 
264 -----------------------------------------------------------------
265 */
266 
267 
268 /**
269  * @title A contract that can be paused by its owner
270  */
271 contract Pausable is Owned {
272     uint public lastPauseTime;
273     bool public paused;
274 
275     /**
276      * @dev Constructor
277      * @param _owner The account which controls this contract.
278      */
279     constructor(address _owner) public Owned(_owner) {
280         // Paused will be false, and lastPauseTime will be 0 upon initialisation
281     }
282 
283     /**
284      * @notice Change the paused state of the contract
285      * @dev Only the contract owner may call this.
286      */
287     function setPaused(bool _paused) external onlyOwner {
288         // Ensure we're actually changing the state before we do anything
289         if (_paused == paused) {
290             return;
291         }
292 
293         // Set our paused state.
294         paused = _paused;
295 
296         // If applicable, set the last pause time.
297         if (paused) {
298             lastPauseTime = now;
299         }
300 
301         // Let everyone know that our pause state has changed.
302         emit PauseChanged(paused);
303     }
304 
305     event PauseChanged(bool isPaused);
306 
307     modifier notPaused {
308         require(!paused, "This action cannot be performed while the contract is paused");
309         _;
310     }
311 }
312 
313 
314 /**
315  * @title SafeMath
316  * @dev Math operations with safety checks that revert on error
317  */
318 library SafeMath {
319 
320   /**
321   * @dev Multiplies two numbers, reverts on overflow.
322   */
323   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
324     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
325     // benefit is lost if 'b' is also tested.
326     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
327     if (a == 0) {
328       return 0;
329     }
330 
331     uint256 c = a * b;
332     require(c / a == b, "SafeMath.mul Error");
333 
334     return c;
335   }
336 
337   /**
338   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
339   */
340   function div(uint256 a, uint256 b) internal pure returns (uint256) {
341     require(b > 0, "SafeMath.div Error"); // Solidity only automatically asserts when dividing by 0
342     uint256 c = a / b;
343     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
344 
345     return c;
346   }
347 
348   /**
349   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
350   */
351   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
352     require(b <= a, "SafeMath.sub Error");
353     uint256 c = a - b;
354 
355     return c;
356   }
357 
358   /**
359   * @dev Adds two numbers, reverts on overflow.
360   */
361   function add(uint256 a, uint256 b) internal pure returns (uint256) {
362     uint256 c = a + b;
363     require(c >= a, "SafeMath.add Error");
364 
365     return c;
366   }
367 
368   /**
369   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
370   * reverts when dividing by zero.
371   */
372   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
373     require(b != 0, "SafeMath.mod Error");
374     return a % b;
375   }
376 }
377 
378 
379 /*
380 
381 -----------------------------------------------------------------
382 FILE INFORMATION
383 -----------------------------------------------------------------
384 
385 file:       SafeDecimalMath.sol
386 version:    2.0
387 author:     Kevin Brown
388             Gavin Conway
389 date:       2018-10-18
390 
391 -----------------------------------------------------------------
392 MODULE DESCRIPTION
393 -----------------------------------------------------------------
394 
395 A library providing safe mathematical operations for division and
396 multiplication with the capability to round or truncate the results
397 to the nearest increment. Operations can return a standard precision
398 or high precision decimal. High precision decimals are useful for
399 example when attempting to calculate percentages or fractions
400 accurately.
401 
402 -----------------------------------------------------------------
403 */
404 
405 
406 /**
407  * @title Safely manipulate unsigned fixed-point decimals at a given precision level.
408  * @dev Functions accepting uints in this contract and derived contracts
409  * are taken to be such fixed point decimals of a specified precision (either standard
410  * or high).
411  */
412 library SafeDecimalMath {
413     using SafeMath for uint;
414 
415     /* Number of decimal places in the representations. */
416     uint8 public constant decimals = 18;
417     uint8 public constant highPrecisionDecimals = 27;
418 
419     /* The number representing 1.0. */
420     uint public constant UNIT = 10**uint(decimals);
421 
422     /* The number representing 1.0 for higher fidelity numbers. */
423     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
424     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
425 
426     /** 
427      * @return Provides an interface to UNIT.
428      */
429     function unit() external pure returns (uint) {
430         return UNIT;
431     }
432 
433     /** 
434      * @return Provides an interface to PRECISE_UNIT.
435      */
436     function preciseUnit() external pure returns (uint) {
437         return PRECISE_UNIT;
438     }
439 
440     /**
441      * @return The result of multiplying x and y, interpreting the operands as fixed-point
442      * decimals.
443      * 
444      * @dev A unit factor is divided out after the product of x and y is evaluated,
445      * so that product must be less than 2**256. As this is an integer division,
446      * the internal division always rounds down. This helps save on gas. Rounding
447      * is more expensive on gas.
448      */
449     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
450         /* Divide by UNIT to remove the extra factor introduced by the product. */
451         return x.mul(y) / UNIT;
452     }
453 
454     /**
455      * @return The result of safely multiplying x and y, interpreting the operands
456      * as fixed-point decimals of the specified precision unit.
457      *
458      * @dev The operands should be in the form of a the specified unit factor which will be
459      * divided out after the product of x and y is evaluated, so that product must be
460      * less than 2**256.
461      *
462      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
463      * Rounding is useful when you need to retain fidelity for small decimal numbers
464      * (eg. small fractions or percentages).
465      */
466     function _multiplyDecimalRound(uint x, uint y, uint precisionUnit) private pure returns (uint) {
467         /* Divide by UNIT to remove the extra factor introduced by the product. */
468         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
469 
470         if (quotientTimesTen % 10 >= 5) {
471             quotientTimesTen += 10;
472         }
473 
474         return quotientTimesTen / 10;
475     }
476 
477     /**
478      * @return The result of safely multiplying x and y, interpreting the operands
479      * as fixed-point decimals of a precise unit.
480      *
481      * @dev The operands should be in the precise unit factor which will be
482      * divided out after the product of x and y is evaluated, so that product must be
483      * less than 2**256.
484      *
485      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
486      * Rounding is useful when you need to retain fidelity for small decimal numbers
487      * (eg. small fractions or percentages).
488      */
489     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
490         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
491     }
492 
493     /**
494      * @return The result of safely multiplying x and y, interpreting the operands
495      * as fixed-point decimals of a standard unit.
496      *
497      * @dev The operands should be in the standard unit factor which will be
498      * divided out after the product of x and y is evaluated, so that product must be
499      * less than 2**256.
500      *
501      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
502      * Rounding is useful when you need to retain fidelity for small decimal numbers
503      * (eg. small fractions or percentages).
504      */
505     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
506         return _multiplyDecimalRound(x, y, UNIT);
507     }
508 
509     /**
510      * @return The result of safely dividing x and y. The return value is a high
511      * precision decimal.
512      * 
513      * @dev y is divided after the product of x and the standard precision unit
514      * is evaluated, so the product of x and UNIT must be less than 2**256. As
515      * this is an integer division, the result is always rounded down.
516      * This helps save on gas. Rounding is more expensive on gas.
517      */
518     function divideDecimal(uint x, uint y) internal pure returns (uint) {
519         /* Reintroduce the UNIT factor that will be divided out by y. */
520         return x.mul(UNIT).div(y);
521     }
522 
523     /**
524      * @return The result of safely dividing x and y. The return value is as a rounded
525      * decimal in the precision unit specified in the parameter.
526      *
527      * @dev y is divided after the product of x and the specified precision unit
528      * is evaluated, so the product of x and the specified precision unit must
529      * be less than 2**256. The result is rounded to the nearest increment.
530      */
531     function _divideDecimalRound(uint x, uint y, uint precisionUnit) private pure returns (uint) {
532         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
533 
534         if (resultTimesTen % 10 >= 5) {
535             resultTimesTen += 10;
536         }
537 
538         return resultTimesTen / 10;
539     }
540 
541     /**
542      * @return The result of safely dividing x and y. The return value is as a rounded
543      * standard precision decimal.
544      *
545      * @dev y is divided after the product of x and the standard precision unit
546      * is evaluated, so the product of x and the standard precision unit must
547      * be less than 2**256. The result is rounded to the nearest increment.
548      */
549     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
550         return _divideDecimalRound(x, y, UNIT);
551     }
552 
553     /**
554      * @return The result of safely dividing x and y. The return value is as a rounded
555      * high precision decimal.
556      *
557      * @dev y is divided after the product of x and the high precision unit
558      * is evaluated, so the product of x and the high precision unit must
559      * be less than 2**256. The result is rounded to the nearest increment.
560      */
561     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
562         return _divideDecimalRound(x, y, PRECISE_UNIT);
563     }
564 
565     /**
566      * @dev Convert a standard decimal representation to a high precision one.
567      */
568     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
569         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
570     }
571 
572     /**
573      * @dev Convert a high precision decimal to a standard decimal representation.
574      */
575     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
576         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
577 
578         if (quotientTimesTen % 10 >= 5) {
579             quotientTimesTen += 10;
580         }
581 
582         return quotientTimesTen / 10;
583     }
584 }
585 
586 
587 interface ISynth {
588     function burn(address account, uint amount) external;
589 
590     function issue(address account, uint amount) external;
591 
592     function transfer(address to, uint value) external returns (bool);
593 
594     function transferFrom(address from, address to, uint value) external returns (bool);
595 
596     function transferFromAndSettle(address from, address to, uint value) external returns (bool);
597 
598     function balanceOf(address owner) external view returns (uint);
599 }
600 
601 
602 /**
603  * @title ERC20 interface
604  * @dev see https://github.com/ethereum/EIPs/issues/20
605  */
606 contract IERC20 {
607     function totalSupply() public view returns (uint);
608 
609     function balanceOf(address owner) public view returns (uint);
610 
611     function allowance(address owner, address spender) public view returns (uint);
612 
613     function transfer(address to, uint value) public returns (bool);
614 
615     function approve(address spender, uint value) public returns (bool);
616 
617     function transferFrom(address from, address to, uint value) public returns (bool);
618 
619     // ERC20 Optional
620     function name() public view returns (string);
621 
622     function symbol() public view returns (string);
623 
624     function decimals() public view returns (uint8);
625 
626     event Transfer(address indexed from, address indexed to, uint value);
627 
628     event Approval(address indexed owner, address indexed spender, uint value);
629 }
630 
631 
632 /**
633  * @title ExchangeRates interface
634  */
635 interface IExchangeRates {
636     function effectiveValue(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
637         external
638         view
639         returns (uint);
640 
641     function rateForCurrency(bytes32 currencyKey) external view returns (uint);
642 
643     function ratesForCurrencies(bytes32[] currencyKeys) external view returns (uint[] memory);
644 
645     function rateIsStale(bytes32 currencyKey) external view returns (bool);
646 
647     function rateIsFrozen(bytes32 currencyKey) external view returns (bool);
648 
649     function anyRateIsStale(bytes32[] currencyKeys) external view returns (bool);
650 
651     function getCurrentRoundId(bytes32 currencyKey) external view returns (uint);
652 
653     function effectiveValueAtRound(
654         bytes32 sourceCurrencyKey,
655         uint sourceAmount,
656         bytes32 destinationCurrencyKey,
657         uint roundIdForSrc,
658         uint roundIdForDest
659     ) external view returns (uint);
660 
661     function getLastRoundIdBeforeElapsedSecs(
662         bytes32 currencyKey,
663         uint startingRoundId,
664         uint startingTimestamp,
665         uint timediff
666     ) external view returns (uint);
667 
668     function ratesAndStaleForCurrencies(bytes32[] currencyKeys) external view returns (uint[], bool);
669 
670     function rateAndTimestampAtRound(bytes32 currencyKey, uint roundId) external view returns (uint rate, uint time);
671 }
672 
673 
674 contract AddressResolver is Owned {
675     mapping(bytes32 => address) public repository;
676 
677     constructor(address _owner) public Owned(_owner) {}
678 
679     /* ========== MUTATIVE FUNCTIONS ========== */
680 
681     function importAddresses(bytes32[] names, address[] destinations) public onlyOwner {
682         require(names.length == destinations.length, "Input lengths must match");
683 
684         for (uint i = 0; i < names.length; i++) {
685             repository[names[i]] = destinations[i];
686         }
687     }
688 
689     /* ========== VIEWS ========== */
690 
691     function getAddress(bytes32 name) public view returns (address) {
692         return repository[name];
693     }
694 
695     function requireAndGetAddress(bytes32 name, string reason) public view returns (address) {
696         address _foundAddress = repository[name];
697         require(_foundAddress != address(0), reason);
698         return _foundAddress;
699     }
700 }
701 
702 
703 contract MixinResolver is Owned {
704     AddressResolver public resolver;
705 
706     constructor(address _owner, address _resolver) public Owned(_owner) {
707         resolver = AddressResolver(_resolver);
708     }
709 
710     /* ========== SETTERS ========== */
711 
712     function setResolver(AddressResolver _resolver) public onlyOwner {
713         resolver = _resolver;
714     }
715 }
716 
717 
718 contract Depot is SelfDestructible, Pausable, ReentrancyGuard, MixinResolver {
719     using SafeMath for uint;
720     using SafeDecimalMath for uint;
721 
722     bytes32 constant SNX = "SNX";
723     bytes32 constant ETH = "ETH";
724 
725     /* ========== STATE VARIABLES ========== */
726 
727     // Address where the ether and Synths raised for selling SNX is transfered to
728     // Any ether raised for selling Synths gets sent back to whoever deposited the Synths,
729     // and doesn't have anything to do with this address.
730     address public fundsWallet;
731 
732     /* Stores deposits from users. */
733     struct synthDeposit {
734         // The user that made the deposit
735         address user;
736         // The amount (in Synths) that they deposited
737         uint amount;
738     }
739 
740     /* User deposits are sold on a FIFO (First in First out) basis. When users deposit
741        synths with us, they get added this queue, which then gets fulfilled in order.
742        Conceptually this fits well in an array, but then when users fill an order we
743        end up copying the whole array around, so better to use an index mapping instead
744        for gas performance reasons.
745 
746        The indexes are specified (inclusive, exclusive), so (0, 0) means there's nothing
747        in the array, and (3, 6) means there are 3 elements at 3, 4, and 5. You can obtain
748        the length of the "array" by querying depositEndIndex - depositStartIndex. All index
749        operations use safeAdd, so there is no way to overflow, so that means there is a
750        very large but finite amount of deposits this contract can handle before it fills up. */
751     mapping(uint => synthDeposit) public deposits;
752     // The starting index of our queue inclusive
753     uint public depositStartIndex;
754     // The ending index of our queue exclusive
755     uint public depositEndIndex;
756 
757     /* This is a convenience variable so users and dApps can just query how much sUSD
758        we have available for purchase without having to iterate the mapping with a
759        O(n) amount of calls for something we'll probably want to display quite regularly. */
760     uint public totalSellableDeposits;
761 
762     // The minimum amount of sUSD required to enter the FiFo queue
763     uint public minimumDepositAmount = 50 * SafeDecimalMath.unit();
764 
765     // A cap on the amount of sUSD you can buy with ETH in 1 transaction
766     uint public maxEthPurchase = 500 * SafeDecimalMath.unit();
767 
768     // If a user deposits a synth amount < the minimumDepositAmount the contract will keep
769     // the total of small deposits which will not be sold on market and the sender
770     // must call withdrawMyDepositedSynths() to get them back.
771     mapping(address => uint) public smallDeposits;
772 
773     /* ========== CONSTRUCTOR ========== */
774 
775     constructor(
776         // Ownable
777         address _owner,
778         // Funds Wallet
779         address _fundsWallet,
780         // Address Resolver
781         address _resolver
782     )
783         public
784         /* Owned is initialised in SelfDestructible */
785         SelfDestructible(_owner)
786         Pausable(_owner)
787         MixinResolver(_owner, _resolver)
788     {
789         fundsWallet = _fundsWallet;
790     }
791 
792     /* ========== SETTERS ========== */
793 
794     function setMaxEthPurchase(uint _maxEthPurchase) external onlyOwner {
795         maxEthPurchase = _maxEthPurchase;
796         emit MaxEthPurchaseUpdated(maxEthPurchase);
797     }
798 
799     /**
800      * @notice Set the funds wallet where ETH raised is held
801      * @param _fundsWallet The new address to forward ETH and Synths to
802      */
803     function setFundsWallet(address _fundsWallet) external onlyOwner {
804         fundsWallet = _fundsWallet;
805         emit FundsWalletUpdated(fundsWallet);
806     }
807 
808     /**
809      * @notice Set the minimum deposit amount required to depoist sUSD into the FIFO queue
810      * @param _amount The new new minimum number of sUSD required to deposit
811      */
812     function setMinimumDepositAmount(uint _amount) external onlyOwner {
813         // Do not allow us to set it less than 1 dollar opening up to fractional desposits in the queue again
814         require(_amount > SafeDecimalMath.unit(), "Minimum deposit amount must be greater than UNIT");
815         minimumDepositAmount = _amount;
816         emit MinimumDepositAmountUpdated(minimumDepositAmount);
817     }
818 
819     /* ========== MUTATIVE FUNCTIONS ========== */
820 
821     /**
822      * @notice Fallback function (exchanges ETH to sUSD)
823      */
824     function() external payable {
825         exchangeEtherForSynths();
826     }
827 
828     /**
829      * @notice Exchange ETH to sUSD.
830      */
831     function exchangeEtherForSynths()
832         public
833         payable
834         nonReentrant
835         rateNotStale(ETH)
836         notPaused
837         returns (
838             uint // Returns the number of Synths (sUSD) received
839         )
840     {
841         require(msg.value <= maxEthPurchase, "ETH amount above maxEthPurchase limit");
842         uint ethToSend;
843 
844         // The multiplication works here because exchangeRates().rateForCurrency(ETH) is specified in
845         // 18 decimal places, just like our currency base.
846         uint requestedToPurchase = msg.value.multiplyDecimal(exchangeRates().rateForCurrency(ETH));
847         uint remainingToFulfill = requestedToPurchase;
848 
849         // Iterate through our outstanding deposits and sell them one at a time.
850         for (uint i = depositStartIndex; remainingToFulfill > 0 && i < depositEndIndex; i++) {
851             synthDeposit memory deposit = deposits[i];
852 
853             // If it's an empty spot in the queue from a previous withdrawal, just skip over it and
854             // update the queue. It's already been deleted.
855             if (deposit.user == address(0)) {
856                 depositStartIndex = depositStartIndex.add(1);
857             } else {
858                 // If the deposit can more than fill the order, we can do this
859                 // without touching the structure of our queue.
860                 if (deposit.amount > remainingToFulfill) {
861                     // Ok, this deposit can fulfill the whole remainder. We don't need
862                     // to change anything about our queue we can just fulfill it.
863                     // Subtract the amount from our deposit and total.
864                     uint newAmount = deposit.amount.sub(remainingToFulfill);
865                     deposits[i] = synthDeposit({user: deposit.user, amount: newAmount});
866 
867                     totalSellableDeposits = totalSellableDeposits.sub(remainingToFulfill);
868 
869                     // Transfer the ETH to the depositor. Send is used instead of transfer
870                     // so a non payable contract won't block the FIFO queue on a failed
871                     // ETH payable for synths transaction. The proceeds to be sent to the
872                     // synthetix foundation funds wallet. This is to protect all depositors
873                     // in the queue in this rare case that may occur.
874                     ethToSend = remainingToFulfill.divideDecimal(exchangeRates().rateForCurrency(ETH));
875 
876                     // We need to use send here instead of transfer because transfer reverts
877                     // if the recipient is a non-payable contract. Send will just tell us it
878                     // failed by returning false at which point we can continue.
879                     // solium-disable-next-line security/no-send
880                     if (!deposit.user.send(ethToSend)) {
881                         fundsWallet.transfer(ethToSend);
882                         emit NonPayableContract(deposit.user, ethToSend);
883                     } else {
884                         emit ClearedDeposit(msg.sender, deposit.user, ethToSend, remainingToFulfill, i);
885                     }
886 
887                     // And the Synths to the recipient.
888                     // Note: Fees are calculated by the Synth contract, so when
889                     //       we request a specific transfer here, the fee is
890                     //       automatically deducted and sent to the fee pool.
891                     synthsUSD().transfer(msg.sender, remainingToFulfill);
892 
893                     // And we have nothing left to fulfill on this order.
894                     remainingToFulfill = 0;
895                 } else if (deposit.amount <= remainingToFulfill) {
896                     // We need to fulfill this one in its entirety and kick it out of the queue.
897                     // Start by kicking it out of the queue.
898                     // Free the storage because we can.
899                     delete deposits[i];
900                     // Bump our start index forward one.
901                     depositStartIndex = depositStartIndex.add(1);
902                     // We also need to tell our total it's decreased
903                     totalSellableDeposits = totalSellableDeposits.sub(deposit.amount);
904 
905                     // Now fulfill by transfering the ETH to the depositor. Send is used instead of transfer
906                     // so a non payable contract won't block the FIFO queue on a failed
907                     // ETH payable for synths transaction. The proceeds to be sent to the
908                     // synthetix foundation funds wallet. This is to protect all depositors
909                     // in the queue in this rare case that may occur.
910                     ethToSend = deposit.amount.divideDecimal(exchangeRates().rateForCurrency(ETH));
911 
912                     // We need to use send here instead of transfer because transfer reverts
913                     // if the recipient is a non-payable contract. Send will just tell us it
914                     // failed by returning false at which point we can continue.
915                     // solium-disable-next-line security/no-send
916                     if (!deposit.user.send(ethToSend)) {
917                         fundsWallet.transfer(ethToSend);
918                         emit NonPayableContract(deposit.user, ethToSend);
919                     } else {
920                         emit ClearedDeposit(msg.sender, deposit.user, ethToSend, deposit.amount, i);
921                     }
922 
923                     // And the Synths to the recipient.
924                     // Note: Fees are calculated by the Synth contract, so when
925                     //       we request a specific transfer here, the fee is
926                     //       automatically deducted and sent to the fee pool.
927                     synthsUSD().transfer(msg.sender, deposit.amount);
928 
929                     // And subtract the order from our outstanding amount remaining
930                     // for the next iteration of the loop.
931                     remainingToFulfill = remainingToFulfill.sub(deposit.amount);
932                 }
933             }
934         }
935 
936         // Ok, if we're here and 'remainingToFulfill' isn't zero, then
937         // we need to refund the remainder of their ETH back to them.
938         if (remainingToFulfill > 0) {
939             msg.sender.transfer(remainingToFulfill.divideDecimal(exchangeRates().rateForCurrency(ETH)));
940         }
941 
942         // How many did we actually give them?
943         uint fulfilled = requestedToPurchase.sub(remainingToFulfill);
944 
945         if (fulfilled > 0) {
946             // Now tell everyone that we gave them that many (only if the amount is greater than 0).
947             emit Exchange("ETH", msg.value, "sUSD", fulfilled);
948         }
949 
950         return fulfilled;
951     }
952 
953     /**
954      * @notice Exchange ETH to sUSD while insisting on a particular rate. This allows a user to
955      *         exchange while protecting against frontrunning by the contract owner on the exchange rate.
956      * @param guaranteedRate The exchange rate (ether price) which must be honored or the call will revert.
957      */
958     function exchangeEtherForSynthsAtRate(uint guaranteedRate)
959         public
960         payable
961         rateNotStale(ETH)
962         notPaused
963         returns (
964             uint // Returns the number of Synths (sUSD) received
965         )
966     {
967         require(guaranteedRate == exchangeRates().rateForCurrency(ETH), "Guaranteed rate would not be received");
968 
969         return exchangeEtherForSynths();
970     }
971 
972     /**
973      * @notice Exchange ETH to SNX.
974      */
975     function exchangeEtherForSNX()
976         public
977         payable
978         rateNotStale(SNX)
979         rateNotStale(ETH)
980         notPaused
981         returns (
982             uint // Returns the number of SNX received
983         )
984     {
985         // How many SNX are they going to be receiving?
986         uint synthetixToSend = synthetixReceivedForEther(msg.value);
987 
988         // Store the ETH in our funds wallet
989         fundsWallet.transfer(msg.value);
990 
991         // And send them the SNX.
992         synthetix().transfer(msg.sender, synthetixToSend);
993 
994         emit Exchange("ETH", msg.value, "SNX", synthetixToSend);
995 
996         return synthetixToSend;
997     }
998 
999     /**
1000      * @notice Exchange ETH to SNX while insisting on a particular set of rates. This allows a user to
1001      *         exchange while protecting against frontrunning by the contract owner on the exchange rates.
1002      * @param guaranteedEtherRate The ether exchange rate which must be honored or the call will revert.
1003      * @param guaranteedSynthetixRate The synthetix exchange rate which must be honored or the call will revert.
1004      */
1005     function exchangeEtherForSNXAtRate(uint guaranteedEtherRate, uint guaranteedSynthetixRate)
1006         public
1007         payable
1008         rateNotStale(SNX)
1009         rateNotStale(ETH)
1010         notPaused
1011         returns (
1012             uint // Returns the number of SNX received
1013         )
1014     {
1015         require(guaranteedEtherRate == exchangeRates().rateForCurrency(ETH), "Guaranteed ether rate would not be received");
1016         require(
1017             guaranteedSynthetixRate == exchangeRates().rateForCurrency(SNX),
1018             "Guaranteed synthetix rate would not be received"
1019         );
1020 
1021         return exchangeEtherForSNX();
1022     }
1023 
1024     /**
1025      * @notice Exchange sUSD for SNX
1026      * @param synthAmount The amount of synths the user wishes to exchange.
1027      */
1028     function exchangeSynthsForSNX(uint synthAmount)
1029         public
1030         rateNotStale(SNX)
1031         notPaused
1032         returns (
1033             uint // Returns the number of SNX received
1034         )
1035     {
1036         // How many SNX are they going to be receiving?
1037         uint synthetixToSend = synthetixReceivedForSynths(synthAmount);
1038 
1039         // Ok, transfer the Synths to our funds wallet.
1040         // These do not go in the deposit queue as they aren't for sale as such unless
1041         // they're sent back in from the funds wallet.
1042         synthsUSD().transferFrom(msg.sender, fundsWallet, synthAmount);
1043 
1044         // And send them the SNX.
1045         synthetix().transfer(msg.sender, synthetixToSend);
1046 
1047         emit Exchange("sUSD", synthAmount, "SNX", synthetixToSend);
1048 
1049         return synthetixToSend;
1050     }
1051 
1052     /**
1053      * @notice Exchange sUSD for SNX while insisting on a particular rate. This allows a user to
1054      *         exchange while protecting against frontrunning by the contract owner on the exchange rate.
1055      * @param synthAmount The amount of synths the user wishes to exchange.
1056      * @param guaranteedRate A rate (synthetix price) the caller wishes to insist upon.
1057      */
1058     function exchangeSynthsForSNXAtRate(uint synthAmount, uint guaranteedRate)
1059         public
1060         rateNotStale(SNX)
1061         notPaused
1062         returns (
1063             uint // Returns the number of SNX received
1064         )
1065     {
1066         require(guaranteedRate == exchangeRates().rateForCurrency(SNX), "Guaranteed rate would not be received");
1067 
1068         return exchangeSynthsForSNX(synthAmount);
1069     }
1070 
1071     /**
1072      * @notice Allows the owner to withdraw SNX from this contract if needed.
1073      * @param amount The amount of SNX to attempt to withdraw (in 18 decimal places).
1074      */
1075     function withdrawSynthetix(uint amount) external onlyOwner {
1076         synthetix().transfer(owner, amount);
1077 
1078         // We don't emit our own events here because we assume that anyone
1079         // who wants to watch what the Depot is doing can
1080         // just watch ERC20 events from the Synth and/or Synthetix contracts
1081         // filtered to our address.
1082     }
1083 
1084     /**
1085      * @notice Allows a user to withdraw all of their previously deposited synths from this contract if needed.
1086      *         Developer note: We could keep an index of address to deposits to make this operation more efficient
1087      *         but then all the other operations on the queue become less efficient. It's expected that this
1088      *         function will be very rarely used, so placing the inefficiency here is intentional. The usual
1089      *         use case does not involve a withdrawal.
1090      */
1091     function withdrawMyDepositedSynths() external {
1092         uint synthsToSend = 0;
1093 
1094         for (uint i = depositStartIndex; i < depositEndIndex; i++) {
1095             synthDeposit memory deposit = deposits[i];
1096 
1097             if (deposit.user == msg.sender) {
1098                 // The user is withdrawing this deposit. Remove it from our queue.
1099                 // We'll just leave a gap, which the purchasing logic can walk past.
1100                 synthsToSend = synthsToSend.add(deposit.amount);
1101                 delete deposits[i];
1102                 //Let the DApps know we've removed this deposit
1103                 emit SynthDepositRemoved(deposit.user, deposit.amount, i);
1104             }
1105         }
1106 
1107         // Update our total
1108         totalSellableDeposits = totalSellableDeposits.sub(synthsToSend);
1109 
1110         // Check if the user has tried to send deposit amounts < the minimumDepositAmount to the FIFO
1111         // queue which would have been added to this mapping for withdrawal only
1112         synthsToSend = synthsToSend.add(smallDeposits[msg.sender]);
1113         smallDeposits[msg.sender] = 0;
1114 
1115         // If there's nothing to do then go ahead and revert the transaction
1116         require(synthsToSend > 0, "You have no deposits to withdraw.");
1117 
1118         // Send their deposits back to them (minus fees)
1119         synthsUSD().transfer(msg.sender, synthsToSend);
1120 
1121         emit SynthWithdrawal(msg.sender, synthsToSend);
1122     }
1123 
1124     /**
1125      * @notice depositSynths: Allows users to deposit synths via the approve / transferFrom workflow
1126      * @param amount The amount of sUSD you wish to deposit (must have been approved first)
1127      */
1128     function depositSynths(uint amount) external {
1129         // Grab the amount of synths. Will fail if not approved first
1130         synthsUSD().transferFrom(msg.sender, this, amount);
1131 
1132         // A minimum deposit amount is designed to protect purchasers from over paying
1133         // gas for fullfilling multiple small synth deposits
1134         if (amount < minimumDepositAmount) {
1135             // We cant fail/revert the transaction or send the synths back in a reentrant call.
1136             // So we will keep your synths balance seperate from the FIFO queue so you can withdraw them
1137             smallDeposits[msg.sender] = smallDeposits[msg.sender].add(amount);
1138 
1139             emit SynthDepositNotAccepted(msg.sender, amount, minimumDepositAmount);
1140         } else {
1141             // Ok, thanks for the deposit, let's queue it up.
1142             deposits[depositEndIndex] = synthDeposit({user: msg.sender, amount: amount});
1143             emit SynthDeposit(msg.sender, amount, depositEndIndex);
1144 
1145             // Walk our index forward as well.
1146             depositEndIndex = depositEndIndex.add(1);
1147 
1148             // And add it to our total.
1149             totalSellableDeposits = totalSellableDeposits.add(amount);
1150         }
1151     }
1152 
1153     /* ========== VIEWS ========== */
1154 
1155     /**
1156      * @notice Calculate how many SNX you will receive if you transfer
1157      *         an amount of synths.
1158      * @param amount The amount of synths (in 18 decimal places) you want to ask about
1159      */
1160     function synthetixReceivedForSynths(uint amount) public view returns (uint) {
1161         // And what would that be worth in SNX based on the current price?
1162         return amount.divideDecimal(exchangeRates().rateForCurrency(SNX));
1163     }
1164 
1165     /**
1166      * @notice Calculate how many SNX you will receive if you transfer
1167      *         an amount of ether.
1168      * @param amount The amount of ether (in wei) you want to ask about
1169      */
1170     function synthetixReceivedForEther(uint amount) public view returns (uint) {
1171         // How much is the ETH they sent us worth in sUSD (ignoring the transfer fee)?
1172         uint valueSentInSynths = amount.multiplyDecimal(exchangeRates().rateForCurrency(ETH));
1173 
1174         // Now, how many SNX will that USD amount buy?
1175         return synthetixReceivedForSynths(valueSentInSynths);
1176     }
1177 
1178     /**
1179      * @notice Calculate how many synths you will receive if you transfer
1180      *         an amount of ether.
1181      * @param amount The amount of ether (in wei) you want to ask about
1182      */
1183     function synthsReceivedForEther(uint amount) public view returns (uint) {
1184         // How many synths would that amount of ether be worth?
1185         return amount.multiplyDecimal(exchangeRates().rateForCurrency(ETH));
1186     }
1187 
1188     /* ========== INTERNAL VIEWS ========== */
1189 
1190     function synthsUSD() internal view returns (ISynth) {
1191         return ISynth(resolver.requireAndGetAddress("SynthsUSD", "Missing SynthsUSD address"));
1192     }
1193 
1194     function synthetix() internal view returns (IERC20) {
1195         return IERC20(resolver.requireAndGetAddress("Synthetix", "Missing Synthetix address"));
1196     }
1197 
1198     function exchangeRates() internal view returns (IExchangeRates) {
1199         return IExchangeRates(resolver.requireAndGetAddress("ExchangeRates", "Missing ExchangeRates address"));
1200     }
1201 
1202     // ========== MODIFIERS ==========
1203 
1204     modifier rateNotStale(bytes32 currencyKey) {
1205         require(!exchangeRates().rateIsStale(currencyKey), "Rate stale or not a synth");
1206         _;
1207     }
1208 
1209     /* ========== EVENTS ========== */
1210 
1211     event MaxEthPurchaseUpdated(uint amount);
1212     event FundsWalletUpdated(address newFundsWallet);
1213     event Exchange(string fromCurrency, uint fromAmount, string toCurrency, uint toAmount);
1214     event SynthWithdrawal(address user, uint amount);
1215     event SynthDeposit(address indexed user, uint amount, uint indexed depositIndex);
1216     event SynthDepositRemoved(address indexed user, uint amount, uint indexed depositIndex);
1217     event SynthDepositNotAccepted(address user, uint amount, uint minimum);
1218     event MinimumDepositAmountUpdated(uint amount);
1219     event NonPayableContract(address indexed receiver, uint amount);
1220     event ClearedDeposit(
1221         address indexed fromAddress,
1222         address indexed toAddress,
1223         uint fromETHAmount,
1224         uint toAmount,
1225         uint indexed depositIndex
1226     );
1227 }
1228 
1229 
1230     