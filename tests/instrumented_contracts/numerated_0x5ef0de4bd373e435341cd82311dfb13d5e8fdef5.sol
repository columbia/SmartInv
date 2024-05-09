1 /*
2 
3 ⚠⚠⚠ WARNING WARNING WARNING ⚠⚠⚠
4 
5 This is a TARGET contract - DO NOT CONNECT TO IT DIRECTLY IN YOUR CONTRACTS or DAPPS!
6 
7 This contract has an associated PROXY that MUST be used for all integrations - this TARGET will be REPLACED in an upcoming Synthetix release!
8 The proxy for this contract can be found here:
9 
10 https://contracts.synthetix.io/ProxyERC20
11 
12 *//*
13    ____            __   __        __   _
14   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
15  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
16 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
17      /___/
18 
19 * Synthetix: Synthetix.sol
20 *
21 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/Synthetix.sol
22 * Docs: https://docs.synthetix.io/contracts/Synthetix
23 *
24 * Contract Dependencies: 
25 *	- ExternStateToken
26 *	- IAddressResolver
27 *	- IERC20
28 *	- ISynthetix
29 *	- MixinResolver
30 *	- Owned
31 *	- Proxyable
32 *	- SelfDestructible
33 *	- State
34 * Libraries: 
35 *	- Math
36 *	- SafeDecimalMath
37 *	- SafeMath
38 *
39 * MIT License
40 * ===========
41 *
42 * Copyright (c) 2020 Synthetix
43 *
44 * Permission is hereby granted, free of charge, to any person obtaining a copy
45 * of this software and associated documentation files (the "Software"), to deal
46 * in the Software without restriction, including without limitation the rights
47 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
48 * copies of the Software, and to permit persons to whom the Software is
49 * furnished to do so, subject to the following conditions:
50 *
51 * The above copyright notice and this permission notice shall be included in all
52 * copies or substantial portions of the Software.
53 *
54 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
55 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
56 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
57 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
58 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
59 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
60 */
61 
62 /* ===============================================
63 * Flattened with Solidifier by Coinage
64 * 
65 * https://solidifier.coina.ge
66 * ===============================================
67 */
68 
69 
70 pragma solidity >=0.4.24;
71 
72 
73 interface IERC20 {
74     // ERC20 Optional Views
75     function name() external view returns (string memory);
76 
77     function symbol() external view returns (string memory);
78 
79     function decimals() external view returns (uint8);
80 
81     // Views
82     function totalSupply() external view returns (uint);
83 
84     function balanceOf(address owner) external view returns (uint);
85 
86     function allowance(address owner, address spender) external view returns (uint);
87 
88     // Mutative functions
89     function transfer(address to, uint value) external returns (bool);
90 
91     function approve(address spender, uint value) external returns (bool);
92 
93     function transferFrom(
94         address from,
95         address to,
96         uint value
97     ) external returns (bool);
98 
99     // Events
100     event Transfer(address indexed from, address indexed to, uint value);
101 
102     event Approval(address indexed owner, address indexed spender, uint value);
103 }
104 
105 
106 // https://docs.synthetix.io/contracts/Owned
107 contract Owned {
108     address public owner;
109     address public nominatedOwner;
110 
111     constructor(address _owner) public {
112         require(_owner != address(0), "Owner address cannot be 0");
113         owner = _owner;
114         emit OwnerChanged(address(0), _owner);
115     }
116 
117     function nominateNewOwner(address _owner) external onlyOwner {
118         nominatedOwner = _owner;
119         emit OwnerNominated(_owner);
120     }
121 
122     function acceptOwnership() external {
123         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
124         emit OwnerChanged(owner, nominatedOwner);
125         owner = nominatedOwner;
126         nominatedOwner = address(0);
127     }
128 
129     modifier onlyOwner {
130         require(msg.sender == owner, "Only the contract owner may perform this action");
131         _;
132     }
133 
134     event OwnerNominated(address newOwner);
135     event OwnerChanged(address oldOwner, address newOwner);
136 }
137 
138 
139 // Inheritance
140 
141 
142 // https://docs.synthetix.io/contracts/SelfDestructible
143 contract SelfDestructible is Owned {
144     uint public constant SELFDESTRUCT_DELAY = 4 weeks;
145 
146     uint public initiationTime;
147     bool public selfDestructInitiated;
148 
149     address public selfDestructBeneficiary;
150 
151     constructor() internal {
152         // This contract is abstract, and thus cannot be instantiated directly
153         require(owner != address(0), "Owner must be set");
154         selfDestructBeneficiary = owner;
155         emit SelfDestructBeneficiaryUpdated(owner);
156     }
157 
158     /**
159      * @notice Set the beneficiary address of this contract.
160      * @dev Only the contract owner may call this. The provided beneficiary must be non-null.
161      * @param _beneficiary The address to pay any eth contained in this contract to upon self-destruction.
162      */
163     function setSelfDestructBeneficiary(address payable _beneficiary) external onlyOwner {
164         require(_beneficiary != address(0), "Beneficiary must not be zero");
165         selfDestructBeneficiary = _beneficiary;
166         emit SelfDestructBeneficiaryUpdated(_beneficiary);
167     }
168 
169     /**
170      * @notice Begin the self-destruction counter of this contract.
171      * Once the delay has elapsed, the contract may be self-destructed.
172      * @dev Only the contract owner may call this.
173      */
174     function initiateSelfDestruct() external onlyOwner {
175         initiationTime = now;
176         selfDestructInitiated = true;
177         emit SelfDestructInitiated(SELFDESTRUCT_DELAY);
178     }
179 
180     /**
181      * @notice Terminate and reset the self-destruction timer.
182      * @dev Only the contract owner may call this.
183      */
184     function terminateSelfDestruct() external onlyOwner {
185         initiationTime = 0;
186         selfDestructInitiated = false;
187         emit SelfDestructTerminated();
188     }
189 
190     /**
191      * @notice If the self-destruction delay has elapsed, destroy this contract and
192      * remit any ether it owns to the beneficiary address.
193      * @dev Only the contract owner may call this.
194      */
195     function selfDestruct() external onlyOwner {
196         require(selfDestructInitiated, "Self Destruct not yet initiated");
197         require(initiationTime + SELFDESTRUCT_DELAY < now, "Self destruct delay not met");
198         emit SelfDestructed(selfDestructBeneficiary);
199         selfdestruct(address(uint160(selfDestructBeneficiary)));
200     }
201 
202     event SelfDestructTerminated();
203     event SelfDestructed(address beneficiary);
204     event SelfDestructInitiated(uint selfDestructDelay);
205     event SelfDestructBeneficiaryUpdated(address newBeneficiary);
206 }
207 
208 
209 // Inheritance
210 
211 
212 // Internal references
213 
214 
215 // https://docs.synthetix.io/contracts/Proxy
216 contract Proxy is Owned {
217     Proxyable public target;
218 
219     constructor(address _owner) public Owned(_owner) {}
220 
221     function setTarget(Proxyable _target) external onlyOwner {
222         target = _target;
223         emit TargetUpdated(_target);
224     }
225 
226     function _emit(
227         bytes calldata callData,
228         uint numTopics,
229         bytes32 topic1,
230         bytes32 topic2,
231         bytes32 topic3,
232         bytes32 topic4
233     ) external onlyTarget {
234         uint size = callData.length;
235         bytes memory _callData = callData;
236 
237         assembly {
238             /* The first 32 bytes of callData contain its length (as specified by the abi).
239              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
240              * in length. It is also leftpadded to be a multiple of 32 bytes.
241              * This means moving call_data across 32 bytes guarantees we correctly access
242              * the data itself. */
243             switch numTopics
244                 case 0 {
245                     log0(add(_callData, 32), size)
246                 }
247                 case 1 {
248                     log1(add(_callData, 32), size, topic1)
249                 }
250                 case 2 {
251                     log2(add(_callData, 32), size, topic1, topic2)
252                 }
253                 case 3 {
254                     log3(add(_callData, 32), size, topic1, topic2, topic3)
255                 }
256                 case 4 {
257                     log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
258                 }
259         }
260     }
261 
262     // solhint-disable no-complex-fallback
263     function() external payable {
264         // Mutable call setting Proxyable.messageSender as this is using call not delegatecall
265         target.setMessageSender(msg.sender);
266 
267         assembly {
268             let free_ptr := mload(0x40)
269             calldatacopy(free_ptr, 0, calldatasize)
270 
271             /* We must explicitly forward ether to the underlying contract as well. */
272             let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
273             returndatacopy(free_ptr, 0, returndatasize)
274 
275             if iszero(result) {
276                 revert(free_ptr, returndatasize)
277             }
278             return(free_ptr, returndatasize)
279         }
280     }
281 
282     modifier onlyTarget {
283         require(Proxyable(msg.sender) == target, "Must be proxy target");
284         _;
285     }
286 
287     event TargetUpdated(Proxyable newTarget);
288 }
289 
290 
291 // Inheritance
292 
293 
294 // Internal references
295 
296 
297 // https://docs.synthetix.io/contracts/Proxyable
298 contract Proxyable is Owned {
299     // This contract should be treated like an abstract contract
300 
301     /* The proxy this contract exists behind. */
302     Proxy public proxy;
303     Proxy public integrationProxy;
304 
305     /* The caller of the proxy, passed through to this contract.
306      * Note that every function using this member must apply the onlyProxy or
307      * optionalProxy modifiers, otherwise their invocations can use stale values. */
308     address public messageSender;
309 
310     constructor(address payable _proxy) internal {
311         // This contract is abstract, and thus cannot be instantiated directly
312         require(owner != address(0), "Owner must be set");
313 
314         proxy = Proxy(_proxy);
315         emit ProxyUpdated(_proxy);
316     }
317 
318     function setProxy(address payable _proxy) external onlyOwner {
319         proxy = Proxy(_proxy);
320         emit ProxyUpdated(_proxy);
321     }
322 
323     function setIntegrationProxy(address payable _integrationProxy) external onlyOwner {
324         integrationProxy = Proxy(_integrationProxy);
325     }
326 
327     function setMessageSender(address sender) external onlyProxy {
328         messageSender = sender;
329     }
330 
331     modifier onlyProxy {
332         require(Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy, "Only the proxy can call");
333         _;
334     }
335 
336     modifier optionalProxy {
337         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
338             messageSender = msg.sender;
339         }
340         _;
341     }
342 
343     modifier optionalProxy_onlyOwner {
344         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
345             messageSender = msg.sender;
346         }
347         require(messageSender == owner, "Owner only function");
348         _;
349     }
350 
351     event ProxyUpdated(address proxyAddress);
352 }
353 
354 
355 /**
356  * @dev Wrappers over Solidity's arithmetic operations with added overflow
357  * checks.
358  *
359  * Arithmetic operations in Solidity wrap on overflow. This can easily result
360  * in bugs, because programmers usually assume that an overflow raises an
361  * error, which is the standard behavior in high level programming languages.
362  * `SafeMath` restores this intuition by reverting the transaction when an
363  * operation overflows.
364  *
365  * Using this library instead of the unchecked operations eliminates an entire
366  * class of bugs, so it's recommended to use it always.
367  */
368 library SafeMath {
369     /**
370      * @dev Returns the addition of two unsigned integers, reverting on
371      * overflow.
372      *
373      * Counterpart to Solidity's `+` operator.
374      *
375      * Requirements:
376      * - Addition cannot overflow.
377      */
378     function add(uint256 a, uint256 b) internal pure returns (uint256) {
379         uint256 c = a + b;
380         require(c >= a, "SafeMath: addition overflow");
381 
382         return c;
383     }
384 
385     /**
386      * @dev Returns the subtraction of two unsigned integers, reverting on
387      * overflow (when the result is negative).
388      *
389      * Counterpart to Solidity's `-` operator.
390      *
391      * Requirements:
392      * - Subtraction cannot overflow.
393      */
394     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
395         require(b <= a, "SafeMath: subtraction overflow");
396         uint256 c = a - b;
397 
398         return c;
399     }
400 
401     /**
402      * @dev Returns the multiplication of two unsigned integers, reverting on
403      * overflow.
404      *
405      * Counterpart to Solidity's `*` operator.
406      *
407      * Requirements:
408      * - Multiplication cannot overflow.
409      */
410     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
411         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
412         // benefit is lost if 'b' is also tested.
413         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
414         if (a == 0) {
415             return 0;
416         }
417 
418         uint256 c = a * b;
419         require(c / a == b, "SafeMath: multiplication overflow");
420 
421         return c;
422     }
423 
424     /**
425      * @dev Returns the integer division of two unsigned integers. Reverts on
426      * division by zero. The result is rounded towards zero.
427      *
428      * Counterpart to Solidity's `/` operator. Note: this function uses a
429      * `revert` opcode (which leaves remaining gas untouched) while Solidity
430      * uses an invalid opcode to revert (consuming all remaining gas).
431      *
432      * Requirements:
433      * - The divisor cannot be zero.
434      */
435     function div(uint256 a, uint256 b) internal pure returns (uint256) {
436         // Solidity only automatically asserts when dividing by 0
437         require(b > 0, "SafeMath: division by zero");
438         uint256 c = a / b;
439         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
440 
441         return c;
442     }
443 
444     /**
445      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
446      * Reverts when dividing by zero.
447      *
448      * Counterpart to Solidity's `%` operator. This function uses a `revert`
449      * opcode (which leaves remaining gas untouched) while Solidity uses an
450      * invalid opcode to revert (consuming all remaining gas).
451      *
452      * Requirements:
453      * - The divisor cannot be zero.
454      */
455     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
456         require(b != 0, "SafeMath: modulo by zero");
457         return a % b;
458     }
459 }
460 
461 
462 // Libraries
463 
464 
465 // https://docs.synthetix.io/contracts/SafeDecimalMath
466 library SafeDecimalMath {
467     using SafeMath for uint;
468 
469     /* Number of decimal places in the representations. */
470     uint8 public constant decimals = 18;
471     uint8 public constant highPrecisionDecimals = 27;
472 
473     /* The number representing 1.0. */
474     uint public constant UNIT = 10**uint(decimals);
475 
476     /* The number representing 1.0 for higher fidelity numbers. */
477     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
478     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
479 
480     /**
481      * @return Provides an interface to UNIT.
482      */
483     function unit() external pure returns (uint) {
484         return UNIT;
485     }
486 
487     /**
488      * @return Provides an interface to PRECISE_UNIT.
489      */
490     function preciseUnit() external pure returns (uint) {
491         return PRECISE_UNIT;
492     }
493 
494     /**
495      * @return The result of multiplying x and y, interpreting the operands as fixed-point
496      * decimals.
497      *
498      * @dev A unit factor is divided out after the product of x and y is evaluated,
499      * so that product must be less than 2**256. As this is an integer division,
500      * the internal division always rounds down. This helps save on gas. Rounding
501      * is more expensive on gas.
502      */
503     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
504         /* Divide by UNIT to remove the extra factor introduced by the product. */
505         return x.mul(y) / UNIT;
506     }
507 
508     /**
509      * @return The result of safely multiplying x and y, interpreting the operands
510      * as fixed-point decimals of the specified precision unit.
511      *
512      * @dev The operands should be in the form of a the specified unit factor which will be
513      * divided out after the product of x and y is evaluated, so that product must be
514      * less than 2**256.
515      *
516      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
517      * Rounding is useful when you need to retain fidelity for small decimal numbers
518      * (eg. small fractions or percentages).
519      */
520     function _multiplyDecimalRound(
521         uint x,
522         uint y,
523         uint precisionUnit
524     ) private pure returns (uint) {
525         /* Divide by UNIT to remove the extra factor introduced by the product. */
526         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
527 
528         if (quotientTimesTen % 10 >= 5) {
529             quotientTimesTen += 10;
530         }
531 
532         return quotientTimesTen / 10;
533     }
534 
535     /**
536      * @return The result of safely multiplying x and y, interpreting the operands
537      * as fixed-point decimals of a precise unit.
538      *
539      * @dev The operands should be in the precise unit factor which will be
540      * divided out after the product of x and y is evaluated, so that product must be
541      * less than 2**256.
542      *
543      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
544      * Rounding is useful when you need to retain fidelity for small decimal numbers
545      * (eg. small fractions or percentages).
546      */
547     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
548         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
549     }
550 
551     /**
552      * @return The result of safely multiplying x and y, interpreting the operands
553      * as fixed-point decimals of a standard unit.
554      *
555      * @dev The operands should be in the standard unit factor which will be
556      * divided out after the product of x and y is evaluated, so that product must be
557      * less than 2**256.
558      *
559      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
560      * Rounding is useful when you need to retain fidelity for small decimal numbers
561      * (eg. small fractions or percentages).
562      */
563     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
564         return _multiplyDecimalRound(x, y, UNIT);
565     }
566 
567     /**
568      * @return The result of safely dividing x and y. The return value is a high
569      * precision decimal.
570      *
571      * @dev y is divided after the product of x and the standard precision unit
572      * is evaluated, so the product of x and UNIT must be less than 2**256. As
573      * this is an integer division, the result is always rounded down.
574      * This helps save on gas. Rounding is more expensive on gas.
575      */
576     function divideDecimal(uint x, uint y) internal pure returns (uint) {
577         /* Reintroduce the UNIT factor that will be divided out by y. */
578         return x.mul(UNIT).div(y);
579     }
580 
581     /**
582      * @return The result of safely dividing x and y. The return value is as a rounded
583      * decimal in the precision unit specified in the parameter.
584      *
585      * @dev y is divided after the product of x and the specified precision unit
586      * is evaluated, so the product of x and the specified precision unit must
587      * be less than 2**256. The result is rounded to the nearest increment.
588      */
589     function _divideDecimalRound(
590         uint x,
591         uint y,
592         uint precisionUnit
593     ) private pure returns (uint) {
594         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
595 
596         if (resultTimesTen % 10 >= 5) {
597             resultTimesTen += 10;
598         }
599 
600         return resultTimesTen / 10;
601     }
602 
603     /**
604      * @return The result of safely dividing x and y. The return value is as a rounded
605      * standard precision decimal.
606      *
607      * @dev y is divided after the product of x and the standard precision unit
608      * is evaluated, so the product of x and the standard precision unit must
609      * be less than 2**256. The result is rounded to the nearest increment.
610      */
611     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
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
623     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
624         return _divideDecimalRound(x, y, PRECISE_UNIT);
625     }
626 
627     /**
628      * @dev Convert a standard decimal representation to a high precision one.
629      */
630     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
631         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
632     }
633 
634     /**
635      * @dev Convert a high precision decimal to a standard decimal representation.
636      */
637     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
638         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
639 
640         if (quotientTimesTen % 10 >= 5) {
641             quotientTimesTen += 10;
642         }
643 
644         return quotientTimesTen / 10;
645     }
646 }
647 
648 
649 // Inheritance
650 
651 
652 // https://docs.synthetix.io/contracts/State
653 contract State is Owned {
654     // the address of the contract that can modify variables
655     // this can only be changed by the owner of this contract
656     address public associatedContract;
657 
658     constructor(address _associatedContract) internal {
659         // This contract is abstract, and thus cannot be instantiated directly
660         require(owner != address(0), "Owner must be set");
661 
662         associatedContract = _associatedContract;
663         emit AssociatedContractUpdated(_associatedContract);
664     }
665 
666     /* ========== SETTERS ========== */
667 
668     // Change the associated contract to a new address
669     function setAssociatedContract(address _associatedContract) external onlyOwner {
670         associatedContract = _associatedContract;
671         emit AssociatedContractUpdated(_associatedContract);
672     }
673 
674     /* ========== MODIFIERS ========== */
675 
676     modifier onlyAssociatedContract {
677         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
678         _;
679     }
680 
681     /* ========== EVENTS ========== */
682 
683     event AssociatedContractUpdated(address associatedContract);
684 }
685 
686 
687 // Inheritance
688 
689 
690 // https://docs.synthetix.io/contracts/TokenState
691 contract TokenState is Owned, State {
692     /* ERC20 fields. */
693     mapping(address => uint) public balanceOf;
694     mapping(address => mapping(address => uint)) public allowance;
695 
696     constructor(address _owner, address _associatedContract) public Owned(_owner) State(_associatedContract) {}
697 
698     /* ========== SETTERS ========== */
699 
700     /**
701      * @notice Set ERC20 allowance.
702      * @dev Only the associated contract may call this.
703      * @param tokenOwner The authorising party.
704      * @param spender The authorised party.
705      * @param value The total value the authorised party may spend on the
706      * authorising party's behalf.
707      */
708     function setAllowance(
709         address tokenOwner,
710         address spender,
711         uint value
712     ) external onlyAssociatedContract {
713         allowance[tokenOwner][spender] = value;
714     }
715 
716     /**
717      * @notice Set the balance in a given account
718      * @dev Only the associated contract may call this.
719      * @param account The account whose value to set.
720      * @param value The new balance of the given account.
721      */
722     function setBalanceOf(address account, uint value) external onlyAssociatedContract {
723         balanceOf[account] = value;
724     }
725 }
726 
727 
728 // Inheritance
729 
730 
731 // Libraries
732 
733 
734 // Internal references
735 
736 
737 // https://docs.synthetix.io/contracts/ExternStateToken
738 contract ExternStateToken is Owned, SelfDestructible, Proxyable {
739     using SafeMath for uint;
740     using SafeDecimalMath for uint;
741 
742     /* ========== STATE VARIABLES ========== */
743 
744     /* Stores balances and allowances. */
745     TokenState public tokenState;
746 
747     /* Other ERC20 fields. */
748     string public name;
749     string public symbol;
750     uint public totalSupply;
751     uint8 public decimals;
752 
753     constructor(
754         address payable _proxy,
755         TokenState _tokenState,
756         string memory _name,
757         string memory _symbol,
758         uint _totalSupply,
759         uint8 _decimals,
760         address _owner
761     ) public Owned(_owner) SelfDestructible() Proxyable(_proxy) {
762         tokenState = _tokenState;
763 
764         name = _name;
765         symbol = _symbol;
766         totalSupply = _totalSupply;
767         decimals = _decimals;
768     }
769 
770     /* ========== VIEWS ========== */
771 
772     /**
773      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
774      * @param owner The party authorising spending of their funds.
775      * @param spender The party spending tokenOwner's funds.
776      */
777     function allowance(address owner, address spender) public view returns (uint) {
778         return tokenState.allowance(owner, spender);
779     }
780 
781     /**
782      * @notice Returns the ERC20 token balance of a given account.
783      */
784     function balanceOf(address account) external view returns (uint) {
785         return tokenState.balanceOf(account);
786     }
787 
788     /* ========== MUTATIVE FUNCTIONS ========== */
789 
790     /**
791      * @notice Set the address of the TokenState contract.
792      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
793      * as balances would be unreachable.
794      */
795     function setTokenState(TokenState _tokenState) external optionalProxy_onlyOwner {
796         tokenState = _tokenState;
797         emitTokenStateUpdated(address(_tokenState));
798     }
799 
800     function _internalTransfer(
801         address from,
802         address to,
803         uint value
804     ) internal returns (bool) {
805         /* Disallow transfers to irretrievable-addresses. */
806         require(to != address(0) && to != address(this) && to != address(proxy), "Cannot transfer to this address");
807 
808         // Insufficient balance will be handled by the safe subtraction.
809         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
810         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
811 
812         // Emit a standard ERC20 transfer event
813         emitTransfer(from, to, value);
814 
815         return true;
816     }
817 
818     /**
819      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
820      * the onlyProxy or optionalProxy modifiers.
821      */
822     function _transferByProxy(
823         address from,
824         address to,
825         uint value
826     ) internal returns (bool) {
827         return _internalTransfer(from, to, value);
828     }
829 
830     /*
831      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
832      * possessing the optionalProxy or optionalProxy modifiers.
833      */
834     function _transferFromByProxy(
835         address sender,
836         address from,
837         address to,
838         uint value
839     ) internal returns (bool) {
840         /* Insufficient allowance will be handled by the safe subtraction. */
841         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
842         return _internalTransfer(from, to, value);
843     }
844 
845     /**
846      * @notice Approves spender to transfer on the message sender's behalf.
847      */
848     function approve(address spender, uint value) public optionalProxy returns (bool) {
849         address sender = messageSender;
850 
851         tokenState.setAllowance(sender, spender, value);
852         emitApproval(sender, spender, value);
853         return true;
854     }
855 
856     /* ========== EVENTS ========== */
857     function addressToBytes32(address input) internal pure returns (bytes32) {
858         return bytes32(uint256(uint160(input)));
859     }
860 
861     event Transfer(address indexed from, address indexed to, uint value);
862     bytes32 internal constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
863 
864     function emitTransfer(
865         address from,
866         address to,
867         uint value
868     ) internal {
869         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, addressToBytes32(from), addressToBytes32(to), 0);
870     }
871 
872     event Approval(address indexed owner, address indexed spender, uint value);
873     bytes32 internal constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
874 
875     function emitApproval(
876         address owner,
877         address spender,
878         uint value
879     ) internal {
880         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, addressToBytes32(owner), addressToBytes32(spender), 0);
881     }
882 
883     event TokenStateUpdated(address newTokenState);
884     bytes32 internal constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
885 
886     function emitTokenStateUpdated(address newTokenState) internal {
887         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
888     }
889 }
890 
891 
892 interface IAddressResolver {
893     function getAddress(bytes32 name) external view returns (address);
894 
895     function getSynth(bytes32 key) external view returns (address);
896 
897     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
898 }
899 
900 
901 interface ISynth {
902     // Views
903     function currencyKey() external view returns (bytes32);
904 
905     function transferableSynths(address account) external view returns (uint);
906 
907     // Mutative functions
908     function transferAndSettle(address to, uint value) external returns (bool);
909 
910     function transferFromAndSettle(
911         address from,
912         address to,
913         uint value
914     ) external returns (bool);
915 
916     // Restricted: used internally to Synthetix
917     function burn(address account, uint amount) external;
918 
919     function issue(address account, uint amount) external;
920 }
921 
922 
923 interface IIssuer {
924     // Views
925     function anySynthOrSNXRateIsStale() external view returns (bool anyRateStale);
926 
927     function availableCurrencyKeys() external view returns (bytes32[] memory);
928 
929     function availableSynthCount() external view returns (uint);
930 
931     function availableSynths(uint index) external view returns (ISynth);
932 
933     function canBurnSynths(address account) external view returns (bool);
934 
935     function collateral(address account) external view returns (uint);
936 
937     function collateralisationRatio(address issuer) external view returns (uint);
938 
939     function collateralisationRatioAndAnyRatesStale(address _issuer)
940         external
941         view
942         returns (uint cratio, bool anyRateIsStale);
943 
944     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
945 
946     function lastIssueEvent(address account) external view returns (uint);
947 
948     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
949 
950     function remainingIssuableSynths(address issuer)
951         external
952         view
953         returns (
954             uint maxIssuable,
955             uint alreadyIssued,
956             uint totalSystemDebt
957         );
958 
959     function synths(bytes32 currencyKey) external view returns (ISynth);
960 
961     function synthsByAddress(address synthAddress) external view returns (bytes32);
962 
963     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
964 
965     function transferableSynthetixAndAnyRateIsStale(address account, uint balance)
966         external
967         view
968         returns (uint transferable, bool anyRateIsStale);
969 
970     // Restricted: used internally to Synthetix
971     function issueSynths(address from, uint amount) external;
972 
973     function issueSynthsOnBehalf(
974         address issueFor,
975         address from,
976         uint amount
977     ) external;
978 
979     function issueMaxSynths(address from) external;
980 
981     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
982 
983     function burnSynths(address from, uint amount) external;
984 
985     function burnSynthsOnBehalf(
986         address burnForAddress,
987         address from,
988         uint amount
989     ) external;
990 
991     function burnSynthsToTarget(address from) external;
992 
993     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
994 
995     function liquidateDelinquentAccount(address account, uint susdAmount, address liquidator) external returns (uint totalRedeemed, uint amountToLiquidate);
996 }
997 
998 
999 // Inheritance
1000 
1001 
1002 // https://docs.synthetix.io/contracts/AddressResolver
1003 contract AddressResolver is Owned, IAddressResolver {
1004     mapping(bytes32 => address) public repository;
1005 
1006     constructor(address _owner) public Owned(_owner) {}
1007 
1008     /* ========== MUTATIVE FUNCTIONS ========== */
1009 
1010     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
1011         require(names.length == destinations.length, "Input lengths must match");
1012 
1013         for (uint i = 0; i < names.length; i++) {
1014             repository[names[i]] = destinations[i];
1015         }
1016     }
1017 
1018     /* ========== VIEWS ========== */
1019 
1020     function getAddress(bytes32 name) external view returns (address) {
1021         return repository[name];
1022     }
1023 
1024     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
1025         address _foundAddress = repository[name];
1026         require(_foundAddress != address(0), reason);
1027         return _foundAddress;
1028     }
1029 
1030     function getSynth(bytes32 key) external view returns (address) {
1031         IIssuer issuer = IIssuer(repository["Issuer"]);
1032         require(address(issuer) != address(0), "Cannot find Issuer address");
1033         return address(issuer.synths(key));
1034     }
1035 }
1036 
1037 
1038 // Inheritance
1039 
1040 
1041 // Internal references
1042 
1043 
1044 // https://docs.synthetix.io/contracts/MixinResolver
1045 contract MixinResolver is Owned {
1046     AddressResolver public resolver;
1047 
1048     mapping(bytes32 => address) private addressCache;
1049 
1050     bytes32[] public resolverAddressesRequired;
1051 
1052     uint public constant MAX_ADDRESSES_FROM_RESOLVER = 24;
1053 
1054     constructor(address _resolver, bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory _addressesToCache) internal {
1055         // This contract is abstract, and thus cannot be instantiated directly
1056         require(owner != address(0), "Owner must be set");
1057 
1058         for (uint i = 0; i < _addressesToCache.length; i++) {
1059             if (_addressesToCache[i] != bytes32(0)) {
1060                 resolverAddressesRequired.push(_addressesToCache[i]);
1061             } else {
1062                 // End early once an empty item is found - assumes there are no empty slots in
1063                 // _addressesToCache
1064                 break;
1065             }
1066         }
1067         resolver = AddressResolver(_resolver);
1068         // Do not sync the cache as addresses may not be in the resolver yet
1069     }
1070 
1071     /* ========== SETTERS ========== */
1072     function setResolverAndSyncCache(AddressResolver _resolver) external onlyOwner {
1073         resolver = _resolver;
1074 
1075         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
1076             bytes32 name = resolverAddressesRequired[i];
1077             // Note: can only be invoked once the resolver has all the targets needed added
1078             addressCache[name] = resolver.requireAndGetAddress(name, "Resolver missing target");
1079         }
1080     }
1081 
1082     /* ========== VIEWS ========== */
1083 
1084     function requireAndGetAddress(bytes32 name, string memory reason) internal view returns (address) {
1085         address _foundAddress = addressCache[name];
1086         require(_foundAddress != address(0), reason);
1087         return _foundAddress;
1088     }
1089 
1090     // Note: this could be made external in a utility contract if addressCache was made public
1091     // (used for deployment)
1092     function isResolverCached(AddressResolver _resolver) external view returns (bool) {
1093         if (resolver != _resolver) {
1094             return false;
1095         }
1096 
1097         // otherwise, check everything
1098         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
1099             bytes32 name = resolverAddressesRequired[i];
1100             // false if our cache is invalid or if the resolver doesn't have the required address
1101             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
1102                 return false;
1103             }
1104         }
1105 
1106         return true;
1107     }
1108 
1109     // Note: can be made external into a utility contract (used for deployment)
1110     function getResolverAddressesRequired()
1111         external
1112         view
1113         returns (bytes32[MAX_ADDRESSES_FROM_RESOLVER] memory addressesRequired)
1114     {
1115         for (uint i = 0; i < resolverAddressesRequired.length; i++) {
1116             addressesRequired[i] = resolverAddressesRequired[i];
1117         }
1118     }
1119 
1120     /* ========== INTERNAL FUNCTIONS ========== */
1121     function appendToAddressCache(bytes32 name) internal {
1122         resolverAddressesRequired.push(name);
1123         require(resolverAddressesRequired.length < MAX_ADDRESSES_FROM_RESOLVER, "Max resolver cache size met");
1124         // Because this is designed to be called internally in constructors, we don't
1125         // check the address exists already in the resolver
1126         addressCache[name] = resolver.getAddress(name);
1127     }
1128 }
1129 
1130 
1131 interface ISynthetix {
1132     // Views
1133     function anySynthOrSNXRateIsStale() external view returns (bool anyRateStale);
1134 
1135     function availableCurrencyKeys() external view returns (bytes32[] memory);
1136 
1137     function availableSynthCount() external view returns (uint);
1138 
1139     function availableSynths(uint index) external view returns (ISynth);
1140 
1141     function collateral(address account) external view returns (uint);
1142 
1143     function collateralisationRatio(address issuer) external view returns (uint);
1144 
1145     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
1146 
1147     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
1148 
1149     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
1150 
1151     function remainingIssuableSynths(address issuer)
1152         external
1153         view
1154         returns (
1155             uint maxIssuable,
1156             uint alreadyIssued,
1157             uint totalSystemDebt
1158         );
1159 
1160     function synths(bytes32 currencyKey) external view returns (ISynth);
1161 
1162     function synthsByAddress(address synthAddress) external view returns (bytes32);
1163 
1164     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
1165 
1166     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);
1167 
1168     function transferableSynthetix(address account) external view returns (uint transferable);
1169 
1170     // Mutative Functions
1171     function burnSynths(uint amount) external;
1172 
1173     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
1174 
1175     function burnSynthsToTarget() external;
1176 
1177     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
1178 
1179     function exchange(
1180         bytes32 sourceCurrencyKey,
1181         uint sourceAmount,
1182         bytes32 destinationCurrencyKey
1183     ) external returns (uint amountReceived);
1184 
1185     function exchangeOnBehalf(
1186         address exchangeForAddress,
1187         bytes32 sourceCurrencyKey,
1188         uint sourceAmount,
1189         bytes32 destinationCurrencyKey
1190     ) external returns (uint amountReceived);
1191 
1192     function issueMaxSynths() external;
1193 
1194     function issueMaxSynthsOnBehalf(address issueForAddress) external;
1195 
1196     function issueSynths(uint amount) external;
1197 
1198     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
1199 
1200     function mint() external returns (bool);
1201 
1202     function settle(bytes32 currencyKey)
1203         external
1204         returns (
1205             uint reclaimed,
1206             uint refunded,
1207             uint numEntries
1208         );
1209 
1210     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
1211 }
1212 
1213 
1214 interface ISynthetixState {
1215     // Views
1216     function debtLedger(uint index) external view returns (uint);
1217 
1218     function issuanceRatio() external view returns (uint);
1219 
1220     function issuanceData(address account) external view returns (uint initialDebtOwnership, uint debtEntryIndex);
1221 
1222     function debtLedgerLength() external view returns (uint);
1223 
1224     function hasIssued(address account) external view returns (bool);
1225 
1226     function lastDebtLedgerEntry() external view returns (uint);
1227 
1228     // Mutative functions
1229     function incrementTotalIssuerCount() external;
1230 
1231     function decrementTotalIssuerCount() external;
1232 
1233     function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
1234 
1235     function appendDebtLedgerValue(uint value) external;
1236 
1237     function clearIssuanceData(address account) external;
1238 }
1239 
1240 
1241 interface ISystemStatus {
1242     // Views
1243     function requireSystemActive() external view;
1244 
1245     function requireIssuanceActive() external view;
1246 
1247     function requireExchangeActive() external view;
1248 
1249     function requireSynthActive(bytes32 currencyKey) external view;
1250 
1251     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1252 }
1253 
1254 
1255 interface IExchanger {
1256     // Views
1257     function calculateAmountAfterSettlement(
1258         address from,
1259         bytes32 currencyKey,
1260         uint amount,
1261         uint refunded
1262     ) external view returns (uint amountAfterSettlement);
1263 
1264     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
1265 
1266     function settlementOwing(address account, bytes32 currencyKey)
1267         external
1268         view
1269         returns (
1270             uint reclaimAmount,
1271             uint rebateAmount,
1272             uint numEntries
1273         );
1274 
1275     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
1276 
1277     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
1278         external
1279         view
1280         returns (uint exchangeFeeRate);
1281 
1282     function getAmountsForExchange(
1283         uint sourceAmount,
1284         bytes32 sourceCurrencyKey,
1285         bytes32 destinationCurrencyKey
1286     )
1287         external
1288         view
1289         returns (
1290             uint amountReceived,
1291             uint fee,
1292             uint exchangeFeeRate
1293         );
1294 
1295     // Mutative functions
1296     function exchange(
1297         address from,
1298         bytes32 sourceCurrencyKey,
1299         uint sourceAmount,
1300         bytes32 destinationCurrencyKey,
1301         address destinationAddress
1302     ) external returns (uint amountReceived);
1303 
1304     function exchangeOnBehalf(
1305         address exchangeForAddress,
1306         address from,
1307         bytes32 sourceCurrencyKey,
1308         uint sourceAmount,
1309         bytes32 destinationCurrencyKey
1310     ) external returns (uint amountReceived);
1311 
1312     function settle(address from, bytes32 currencyKey)
1313         external
1314         returns (
1315             uint reclaimed,
1316             uint refunded,
1317             uint numEntries
1318         );
1319 }
1320 
1321 
1322 // Libraries
1323 
1324 
1325 // https://docs.synthetix.io/contracts/Math
1326 library Math {
1327     using SafeMath for uint;
1328     using SafeDecimalMath for uint;
1329 
1330     /**
1331      * @dev Uses "exponentiation by squaring" algorithm where cost is 0(logN)
1332      * vs 0(N) for naive repeated multiplication.
1333      * Calculates x^n with x as fixed-point and n as regular unsigned int.
1334      * Calculates to 18 digits of precision with SafeDecimalMath.unit()
1335      */
1336     function powDecimal(uint x, uint n) internal pure returns (uint) {
1337         // https://mpark.github.io/programming/2014/08/18/exponentiation-by-squaring/
1338 
1339         uint result = SafeDecimalMath.unit();
1340         while (n > 0) {
1341             if (n % 2 != 0) {
1342                 result = result.multiplyDecimal(x);
1343             }
1344             x = x.multiplyDecimal(x);
1345             n /= 2;
1346         }
1347         return result;
1348     }
1349 }
1350 
1351 
1352 // Inheritance
1353 
1354 
1355 // Libraries
1356 
1357 
1358 // Internal references
1359 
1360 
1361 // https://docs.synthetix.io/contracts/SupplySchedule
1362 contract SupplySchedule is Owned {
1363     using SafeMath for uint;
1364     using SafeDecimalMath for uint;
1365     using Math for uint;
1366 
1367     // Time of the last inflation supply mint event
1368     uint public lastMintEvent;
1369 
1370     // Counter for number of weeks since the start of supply inflation
1371     uint public weekCounter;
1372 
1373     // The number of SNX rewarded to the caller of Synthetix.mint()
1374     uint public minterReward = 200 * SafeDecimalMath.unit();
1375 
1376     // The initial weekly inflationary supply is 75m / 52 until the start of the decay rate.
1377     // 75e6 * SafeDecimalMath.unit() / 52
1378     uint public constant INITIAL_WEEKLY_SUPPLY = 1442307692307692307692307;
1379 
1380     // Address of the SynthetixProxy for the onlySynthetix modifier
1381     address payable public synthetixProxy;
1382 
1383     // Max SNX rewards for minter
1384     uint public constant MAX_MINTER_REWARD = 200 * 1e18;
1385 
1386     // How long each inflation period is before mint can be called
1387     uint public constant MINT_PERIOD_DURATION = 1 weeks;
1388 
1389     uint public constant INFLATION_START_DATE = 1551830400; // 2019-03-06T00:00:00+00:00
1390     uint public constant MINT_BUFFER = 1 days;
1391     uint8 public constant SUPPLY_DECAY_START = 40; // Week 40
1392     uint8 public constant SUPPLY_DECAY_END = 234; //  Supply Decay ends on Week 234 (inclusive of Week 234 for a total of 195 weeks of inflation decay)
1393 
1394     // Weekly percentage decay of inflationary supply from the first 40 weeks of the 75% inflation rate
1395     uint public constant DECAY_RATE = 12500000000000000; // 1.25% weekly
1396 
1397     // Percentage growth of terminal supply per annum
1398     uint public constant TERMINAL_SUPPLY_RATE_ANNUAL = 25000000000000000; // 2.5% pa
1399 
1400     constructor(
1401         address _owner,
1402         uint _lastMintEvent,
1403         uint _currentWeek
1404     ) public Owned(_owner) {
1405         lastMintEvent = _lastMintEvent;
1406         weekCounter = _currentWeek;
1407     }
1408 
1409     // ========== VIEWS ==========
1410 
1411     /**
1412      * @return The amount of SNX mintable for the inflationary supply
1413      */
1414     function mintableSupply() external view returns (uint) {
1415         uint totalAmount;
1416 
1417         if (!isMintable()) {
1418             return totalAmount;
1419         }
1420 
1421         uint remainingWeeksToMint = weeksSinceLastIssuance();
1422 
1423         uint currentWeek = weekCounter;
1424 
1425         // Calculate total mintable supply from exponential decay function
1426         // The decay function stops after week 234
1427         while (remainingWeeksToMint > 0) {
1428             currentWeek++;
1429 
1430             if (currentWeek < SUPPLY_DECAY_START) {
1431                 // If current week is before supply decay we add initial supply to mintableSupply
1432                 totalAmount = totalAmount.add(INITIAL_WEEKLY_SUPPLY);
1433                 remainingWeeksToMint--;
1434             } else if (currentWeek <= SUPPLY_DECAY_END) {
1435                 // if current week before supply decay ends we add the new supply for the week
1436                 // diff between current week and (supply decay start week - 1)
1437                 uint decayCount = currentWeek.sub(SUPPLY_DECAY_START - 1);
1438 
1439                 totalAmount = totalAmount.add(tokenDecaySupplyForWeek(decayCount));
1440                 remainingWeeksToMint--;
1441             } else {
1442                 // Terminal supply is calculated on the total supply of Synthetix including any new supply
1443                 // We can compound the remaining week's supply at the fixed terminal rate
1444                 uint totalSupply = IERC20(synthetixProxy).totalSupply();
1445                 uint currentTotalSupply = totalSupply.add(totalAmount);
1446 
1447                 totalAmount = totalAmount.add(terminalInflationSupply(currentTotalSupply, remainingWeeksToMint));
1448                 remainingWeeksToMint = 0;
1449             }
1450         }
1451 
1452         return totalAmount;
1453     }
1454 
1455     /**
1456      * @return A unit amount of decaying inflationary supply from the INITIAL_WEEKLY_SUPPLY
1457      * @dev New token supply reduces by the decay rate each week calculated as supply = INITIAL_WEEKLY_SUPPLY * ()
1458      */
1459     function tokenDecaySupplyForWeek(uint counter) public pure returns (uint) {
1460         // Apply exponential decay function to number of weeks since
1461         // start of inflation smoothing to calculate diminishing supply for the week.
1462         uint effectiveDecay = (SafeDecimalMath.unit().sub(DECAY_RATE)).powDecimal(counter);
1463         uint supplyForWeek = INITIAL_WEEKLY_SUPPLY.multiplyDecimal(effectiveDecay);
1464 
1465         return supplyForWeek;
1466     }
1467 
1468     /**
1469      * @return A unit amount of terminal inflation supply
1470      * @dev Weekly compound rate based on number of weeks
1471      */
1472     function terminalInflationSupply(uint totalSupply, uint numOfWeeks) public pure returns (uint) {
1473         // rate = (1 + weekly rate) ^ num of weeks
1474         uint effectiveCompoundRate = SafeDecimalMath.unit().add(TERMINAL_SUPPLY_RATE_ANNUAL.div(52)).powDecimal(numOfWeeks);
1475 
1476         // return Supply * (effectiveRate - 1) for extra supply to issue based on number of weeks
1477         return totalSupply.multiplyDecimal(effectiveCompoundRate.sub(SafeDecimalMath.unit()));
1478     }
1479 
1480     /**
1481      * @dev Take timeDiff in seconds (Dividend) and MINT_PERIOD_DURATION as (Divisor)
1482      * @return Calculate the numberOfWeeks since last mint rounded down to 1 week
1483      */
1484     function weeksSinceLastIssuance() public view returns (uint) {
1485         // Get weeks since lastMintEvent
1486         // If lastMintEvent not set or 0, then start from inflation start date.
1487         uint timeDiff = lastMintEvent > 0 ? now.sub(lastMintEvent) : now.sub(INFLATION_START_DATE);
1488         return timeDiff.div(MINT_PERIOD_DURATION);
1489     }
1490 
1491     /**
1492      * @return boolean whether the MINT_PERIOD_DURATION (7 days)
1493      * has passed since the lastMintEvent.
1494      * */
1495     function isMintable() public view returns (bool) {
1496         if (now - lastMintEvent > MINT_PERIOD_DURATION) {
1497             return true;
1498         }
1499         return false;
1500     }
1501 
1502     // ========== MUTATIVE FUNCTIONS ==========
1503 
1504     /**
1505      * @notice Record the mint event from Synthetix by incrementing the inflation
1506      * week counter for the number of weeks minted (probabaly always 1)
1507      * and store the time of the event.
1508      * @param supplyMinted the amount of SNX the total supply was inflated by.
1509      * */
1510     function recordMintEvent(uint supplyMinted) external onlySynthetix returns (bool) {
1511         uint numberOfWeeksIssued = weeksSinceLastIssuance();
1512 
1513         // add number of weeks minted to weekCounter
1514         weekCounter = weekCounter.add(numberOfWeeksIssued);
1515 
1516         // Update mint event to latest week issued (start date + number of weeks issued * seconds in week)
1517         // 1 day time buffer is added so inflation is minted after feePeriod closes
1518         lastMintEvent = INFLATION_START_DATE.add(weekCounter.mul(MINT_PERIOD_DURATION)).add(MINT_BUFFER);
1519 
1520         emit SupplyMinted(supplyMinted, numberOfWeeksIssued, lastMintEvent, now);
1521         return true;
1522     }
1523 
1524     /**
1525      * @notice Sets the reward amount of SNX for the caller of the public
1526      * function Synthetix.mint().
1527      * This incentivises anyone to mint the inflationary supply and the mintr
1528      * Reward will be deducted from the inflationary supply and sent to the caller.
1529      * @param amount the amount of SNX to reward the minter.
1530      * */
1531     function setMinterReward(uint amount) external onlyOwner {
1532         require(amount <= MAX_MINTER_REWARD, "Reward cannot exceed max minter reward");
1533         minterReward = amount;
1534         emit MinterRewardUpdated(minterReward);
1535     }
1536 
1537     // ========== SETTERS ========== */
1538 
1539     /**
1540      * @notice Set the SynthetixProxy should it ever change.
1541      * SupplySchedule requires Synthetix address as it has the authority
1542      * to record mint event.
1543      * */
1544     function setSynthetixProxy(ISynthetix _synthetixProxy) external onlyOwner {
1545         require(address(_synthetixProxy) != address(0), "Address cannot be 0");
1546         synthetixProxy = address(uint160(address(_synthetixProxy)));
1547         emit SynthetixProxyUpdated(synthetixProxy);
1548     }
1549 
1550     // ========== MODIFIERS ==========
1551 
1552     /**
1553      * @notice Only the Synthetix contract is authorised to call this function
1554      * */
1555     modifier onlySynthetix() {
1556         require(
1557             msg.sender == address(Proxy(address(synthetixProxy)).target()),
1558             "Only the synthetix contract can perform this action"
1559         );
1560         _;
1561     }
1562 
1563     /* ========== EVENTS ========== */
1564     /**
1565      * @notice Emitted when the inflationary supply is minted
1566      * */
1567     event SupplyMinted(uint supplyMinted, uint numberOfWeeksIssued, uint lastMintEvent, uint timestamp);
1568 
1569     /**
1570      * @notice Emitted when the SNX minter reward amount is updated
1571      * */
1572     event MinterRewardUpdated(uint newRewardAmount);
1573 
1574     /**
1575      * @notice Emitted when setSynthetixProxy is called changing the Synthetix Proxy address
1576      * */
1577     event SynthetixProxyUpdated(address newAddress);
1578 }
1579 
1580 
1581 interface IRewardsDistribution {
1582     // Mutative functions
1583     function distributeRewards(uint amount) external returns (bool);
1584 }
1585 
1586 
1587 // Inheritance
1588 
1589 
1590 // Internal references
1591 
1592 
1593 // https://docs.synthetix.io/contracts/Synthetix
1594 contract Synthetix is IERC20, ExternStateToken, MixinResolver, ISynthetix {
1595     // ========== STATE VARIABLES ==========
1596 
1597     // Available Synths which can be used with the system
1598     string public constant TOKEN_NAME = "Synthetix Network Token";
1599     string public constant TOKEN_SYMBOL = "SNX";
1600     uint8 public constant DECIMALS = 18;
1601     bytes32 public constant sUSD = "sUSD";
1602 
1603     /* ========== ADDRESS RESOLVER CONFIGURATION ========== */
1604 
1605     bytes32 private constant CONTRACT_SYNTHETIXSTATE = "SynthetixState";
1606     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1607     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1608     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1609     bytes32 private constant CONTRACT_SUPPLYSCHEDULE = "SupplySchedule";
1610     bytes32 private constant CONTRACT_REWARDSDISTRIBUTION = "RewardsDistribution";
1611 
1612     bytes32[24] private addressesToCache = [
1613         CONTRACT_SYSTEMSTATUS,
1614         CONTRACT_EXCHANGER,
1615         CONTRACT_ISSUER,
1616         CONTRACT_SUPPLYSCHEDULE,
1617         CONTRACT_REWARDSDISTRIBUTION,
1618         CONTRACT_SYNTHETIXSTATE
1619     ];
1620 
1621     // ========== CONSTRUCTOR ==========
1622 
1623     constructor(
1624         address payable _proxy,
1625         TokenState _tokenState,
1626         address _owner,
1627         uint _totalSupply,
1628         address _resolver
1629     )
1630         public
1631         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, _totalSupply, DECIMALS, _owner)
1632         MixinResolver(_resolver, addressesToCache)
1633     {}
1634 
1635     /* ========== VIEWS ========== */
1636 
1637     function synthetixState() internal view returns (ISynthetixState) {
1638         return ISynthetixState(requireAndGetAddress(CONTRACT_SYNTHETIXSTATE, "Missing SynthetixState address"));
1639     }
1640 
1641     function systemStatus() internal view returns (ISystemStatus) {
1642         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS, "Missing SystemStatus address"));
1643     }
1644 
1645     function exchanger() internal view returns (IExchanger) {
1646         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER, "Missing Exchanger address"));
1647     }
1648 
1649     function issuer() internal view returns (IIssuer) {
1650         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER, "Missing Issuer address"));
1651     }
1652 
1653     function supplySchedule() internal view returns (SupplySchedule) {
1654         return SupplySchedule(requireAndGetAddress(CONTRACT_SUPPLYSCHEDULE, "Missing SupplySchedule address"));
1655     }
1656 
1657     function rewardsDistribution() internal view returns (IRewardsDistribution) {
1658         return
1659             IRewardsDistribution(requireAndGetAddress(CONTRACT_REWARDSDISTRIBUTION, "Missing RewardsDistribution address"));
1660     }
1661 
1662     function debtBalanceOf(address account, bytes32 currencyKey) external view returns (uint) {
1663         return issuer().debtBalanceOf(account, currencyKey);
1664     }
1665 
1666     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint) {
1667         return issuer().totalIssuedSynths(currencyKey, false);
1668     }
1669 
1670     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint) {
1671         return issuer().totalIssuedSynths(currencyKey, true);
1672     }
1673 
1674     function availableCurrencyKeys() external view returns (bytes32[] memory) {
1675         return issuer().availableCurrencyKeys();
1676     }
1677 
1678     function availableSynthCount() external view returns (uint) {
1679         return issuer().availableSynthCount();
1680     }
1681 
1682     function availableSynths(uint index) external view returns (ISynth) {
1683         return issuer().availableSynths(index);
1684     }
1685 
1686     function synths(bytes32 currencyKey) external view returns (ISynth) {
1687         return issuer().synths(currencyKey);
1688     }
1689 
1690     function synthsByAddress(address synthAddress) external view returns (bytes32) {
1691         return issuer().synthsByAddress(synthAddress);
1692     }
1693 
1694     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool) {
1695         return exchanger().maxSecsLeftInWaitingPeriod(messageSender, currencyKey) > 0;
1696     }
1697 
1698     function anySynthOrSNXRateIsStale() external view returns (bool anyRateStale) {
1699         return issuer().anySynthOrSNXRateIsStale();
1700     }
1701 
1702     function maxIssuableSynths(address account) external view returns (uint maxIssuable) {
1703         return issuer().maxIssuableSynths(account);
1704     }
1705 
1706     function remainingIssuableSynths(address account)
1707         external
1708         view
1709         returns (
1710             uint maxIssuable,
1711             uint alreadyIssued,
1712             uint totalSystemDebt
1713         )
1714     {
1715         return issuer().remainingIssuableSynths(account);
1716     }
1717 
1718     function _canTransfer(address account, uint value) internal view returns (bool) {
1719         (uint initialDebtOwnership, ) = synthetixState().issuanceData(account);
1720 
1721         if (initialDebtOwnership > 0) {
1722             (uint transferable, bool anyRateIsStale) = issuer().transferableSynthetixAndAnyRateIsStale(
1723                 account,
1724                 tokenState.balanceOf(account)
1725             );
1726             require(value <= transferable, "Cannot transfer staked or escrowed SNX");
1727             require(!anyRateIsStale, "A synth or SNX rate is stale");
1728         }
1729         return true;
1730     }
1731 
1732     // ========== MUTATIVE FUNCTIONS ==========
1733 
1734     function transfer(address to, uint value) external optionalProxy systemActive returns (bool) {
1735         // Ensure they're not trying to exceed their locked amount -- only if they have debt.
1736         _canTransfer(messageSender, value);
1737 
1738         // Perform the transfer: if there is a problem an exception will be thrown in this call.
1739         _transferByProxy(messageSender, to, value);
1740 
1741         return true;
1742     }
1743 
1744     function transferFrom(
1745         address from,
1746         address to,
1747         uint value
1748     ) external optionalProxy systemActive returns (bool) {
1749         // Ensure they're not trying to exceed their locked amount -- only if they have debt.
1750         _canTransfer(from, value);
1751 
1752         // Perform the transfer: if there is a problem,
1753         // an exception will be thrown in this call.
1754         return _transferFromByProxy(messageSender, from, to, value);
1755     }
1756 
1757     function issueSynths(uint amount) external issuanceActive optionalProxy {
1758         return issuer().issueSynths(messageSender, amount);
1759     }
1760 
1761     function issueSynthsOnBehalf(address issueForAddress, uint amount) external issuanceActive optionalProxy {
1762         return issuer().issueSynthsOnBehalf(issueForAddress, messageSender, amount);
1763     }
1764 
1765     function issueMaxSynths() external issuanceActive optionalProxy {
1766         return issuer().issueMaxSynths(messageSender);
1767     }
1768 
1769     function issueMaxSynthsOnBehalf(address issueForAddress) external issuanceActive optionalProxy {
1770         return issuer().issueMaxSynthsOnBehalf(issueForAddress, messageSender);
1771     }
1772 
1773     function burnSynths(uint amount) external issuanceActive optionalProxy {
1774         return issuer().burnSynths(messageSender, amount);
1775     }
1776 
1777     function burnSynthsOnBehalf(address burnForAddress, uint amount) external issuanceActive optionalProxy {
1778         return issuer().burnSynthsOnBehalf(burnForAddress, messageSender, amount);
1779     }
1780 
1781     function burnSynthsToTarget() external issuanceActive optionalProxy {
1782         return issuer().burnSynthsToTarget(messageSender);
1783     }
1784 
1785     function burnSynthsToTargetOnBehalf(address burnForAddress) external issuanceActive optionalProxy {
1786         return issuer().burnSynthsToTargetOnBehalf(burnForAddress, messageSender);
1787     }
1788 
1789     function exchange(
1790         bytes32 sourceCurrencyKey,
1791         uint sourceAmount,
1792         bytes32 destinationCurrencyKey
1793     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
1794         return exchanger().exchange(messageSender, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, messageSender);
1795     }
1796 
1797     function exchangeOnBehalf(
1798         address exchangeForAddress,
1799         bytes32 sourceCurrencyKey,
1800         uint sourceAmount,
1801         bytes32 destinationCurrencyKey
1802     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
1803         return
1804             exchanger().exchangeOnBehalf(
1805                 exchangeForAddress,
1806                 messageSender,
1807                 sourceCurrencyKey,
1808                 sourceAmount,
1809                 destinationCurrencyKey
1810             );
1811     }
1812 
1813     function settle(bytes32 currencyKey)
1814         external
1815         optionalProxy
1816         returns (
1817             uint reclaimed,
1818             uint refunded,
1819             uint numEntriesSettled
1820         )
1821     {
1822         return exchanger().settle(messageSender, currencyKey);
1823     }
1824 
1825     function collateralisationRatio(address _issuer) external view returns (uint) {
1826         return issuer().collateralisationRatio(_issuer);
1827     }
1828 
1829     function collateral(address account) external view returns (uint) {
1830         return issuer().collateral(account);
1831     }
1832 
1833     function transferableSynthetix(address account) external view returns (uint transferable) {
1834         (transferable, ) = issuer().transferableSynthetixAndAnyRateIsStale(account, tokenState.balanceOf(account));
1835     }
1836 
1837     function mint() external issuanceActive returns (bool) {
1838         require(address(rewardsDistribution()) != address(0), "RewardsDistribution not set");
1839 
1840         SupplySchedule _supplySchedule = supplySchedule();
1841         IRewardsDistribution _rewardsDistribution = rewardsDistribution();
1842 
1843         uint supplyToMint = _supplySchedule.mintableSupply();
1844         require(supplyToMint > 0, "No supply is mintable");
1845 
1846         // record minting event before mutation to token supply
1847         _supplySchedule.recordMintEvent(supplyToMint);
1848 
1849         // Set minted SNX balance to RewardEscrow's balance
1850         // Minus the minterReward and set balance of minter to add reward
1851         uint minterReward = _supplySchedule.minterReward();
1852         // Get the remainder
1853         uint amountToDistribute = supplyToMint.sub(minterReward);
1854 
1855         // Set the token balance to the RewardsDistribution contract
1856         tokenState.setBalanceOf(
1857             address(_rewardsDistribution),
1858             tokenState.balanceOf(address(_rewardsDistribution)).add(amountToDistribute)
1859         );
1860         emitTransfer(address(this), address(_rewardsDistribution), amountToDistribute);
1861 
1862         // Kick off the distribution of rewards
1863         _rewardsDistribution.distributeRewards(amountToDistribute);
1864 
1865         // Assign the minters reward.
1866         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
1867         emitTransfer(address(this), msg.sender, minterReward);
1868 
1869         totalSupply = totalSupply.add(supplyToMint);
1870 
1871         return true;
1872     }
1873 
1874     function liquidateDelinquentAccount(address account, uint susdAmount)
1875         external
1876         systemActive
1877         optionalProxy
1878         returns (bool)
1879     {
1880         (uint totalRedeemed, uint amountLiquidated) = issuer().liquidateDelinquentAccount(
1881             account,
1882             susdAmount,
1883             messageSender
1884         );
1885 
1886         emitAccountLiquidated(account, totalRedeemed, amountLiquidated, messageSender);
1887 
1888         // Transfer SNX redeemed to messageSender
1889         // Reverts if amount to redeem is more than balanceOf account, ie due to escrowed balance
1890         return _transferByProxy(account, messageSender, totalRedeemed);
1891     }
1892 
1893     // ========== MODIFIERS ==========
1894 
1895     modifier onlyExchanger() {
1896         require(msg.sender == address(exchanger()), "Only Exchanger can invoke this");
1897         _;
1898     }
1899 
1900     modifier systemActive() {
1901         systemStatus().requireSystemActive();
1902         _;
1903     }
1904 
1905     modifier issuanceActive() {
1906         systemStatus().requireIssuanceActive();
1907         _;
1908     }
1909 
1910     modifier exchangeActive(bytes32 src, bytes32 dest) {
1911         systemStatus().requireExchangeActive();
1912         systemStatus().requireSynthsActive(src, dest);
1913         _;
1914     }
1915 
1916     // ========== EVENTS ==========
1917 
1918     event SynthExchange(
1919         address indexed account,
1920         bytes32 fromCurrencyKey,
1921         uint256 fromAmount,
1922         bytes32 toCurrencyKey,
1923         uint256 toAmount,
1924         address toAddress
1925     );
1926     bytes32 internal constant SYNTHEXCHANGE_SIG = keccak256(
1927         "SynthExchange(address,bytes32,uint256,bytes32,uint256,address)"
1928     );
1929 
1930     function emitSynthExchange(
1931         address account,
1932         bytes32 fromCurrencyKey,
1933         uint256 fromAmount,
1934         bytes32 toCurrencyKey,
1935         uint256 toAmount,
1936         address toAddress
1937     ) external onlyExchanger {
1938         proxy._emit(
1939             abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress),
1940             2,
1941             SYNTHEXCHANGE_SIG,
1942             addressToBytes32(account),
1943             0,
1944             0
1945         );
1946     }
1947 
1948     event ExchangeReclaim(address indexed account, bytes32 currencyKey, uint amount);
1949     bytes32 internal constant EXCHANGERECLAIM_SIG = keccak256("ExchangeReclaim(address,bytes32,uint256)");
1950 
1951     function emitExchangeReclaim(
1952         address account,
1953         bytes32 currencyKey,
1954         uint256 amount
1955     ) external onlyExchanger {
1956         proxy._emit(abi.encode(currencyKey, amount), 2, EXCHANGERECLAIM_SIG, addressToBytes32(account), 0, 0);
1957     }
1958 
1959     event ExchangeRebate(address indexed account, bytes32 currencyKey, uint amount);
1960     bytes32 internal constant EXCHANGEREBATE_SIG = keccak256("ExchangeRebate(address,bytes32,uint256)");
1961 
1962     function emitExchangeRebate(
1963         address account,
1964         bytes32 currencyKey,
1965         uint256 amount
1966     ) external onlyExchanger {
1967         proxy._emit(abi.encode(currencyKey, amount), 2, EXCHANGEREBATE_SIG, addressToBytes32(account), 0, 0);
1968     }
1969 
1970     event AccountLiquidated(address indexed account, uint snxRedeemed, uint amountLiquidated, address liquidator);
1971     bytes32 internal constant ACCOUNTLIQUIDATED_SIG = keccak256("AccountLiquidated(address,uint256,uint256,address)");
1972 
1973     function emitAccountLiquidated(
1974         address account,
1975         uint256 snxRedeemed,
1976         uint256 amountLiquidated,
1977         address liquidator
1978     ) internal {
1979         proxy._emit(
1980             abi.encode(snxRedeemed, amountLiquidated, liquidator),
1981             2,
1982             ACCOUNTLIQUIDATED_SIG,
1983             addressToBytes32(account),
1984             0,
1985             0
1986         );
1987     }
1988 }
1989 
1990 
1991     