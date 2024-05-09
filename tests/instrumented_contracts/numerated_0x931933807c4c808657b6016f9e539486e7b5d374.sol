1 /*
2 
3 ⚠⚠⚠ WARNING WARNING WARNING ⚠⚠⚠
4 
5 This is a TARGET contract - DO NOT CONNECT TO IT DIRECTLY IN YOUR CONTRACTS or DAPPS!
6 
7 This contract has an associated PROXY that MUST be used for all integrations - this TARGET will be REPLACED in an upcoming Synthetix release!
8 The proxy for this contract can be found here:
9 
10 https://contracts.synthetix.io/ProxySynthetix
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
25 *	- BaseSynthetix
26 *	- ExternStateToken
27 *	- IAddressResolver
28 *	- IERC20
29 *	- ISynthetix
30 *	- MixinResolver
31 *	- Owned
32 *	- Proxyable
33 *	- State
34 * Libraries: 
35 *	- SafeDecimalMath
36 *	- SafeMath
37 *	- VestingEntries
38 *
39 * MIT License
40 * ===========
41 *
42 * Copyright (c) 2022 Synthetix
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
62 
63 
64 pragma solidity >=0.4.24;
65 
66 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
67 interface IERC20 {
68     // ERC20 Optional Views
69     function name() external view returns (string memory);
70 
71     function symbol() external view returns (string memory);
72 
73     function decimals() external view returns (uint8);
74 
75     // Views
76     function totalSupply() external view returns (uint);
77 
78     function balanceOf(address owner) external view returns (uint);
79 
80     function allowance(address owner, address spender) external view returns (uint);
81 
82     // Mutative functions
83     function transfer(address to, uint value) external returns (bool);
84 
85     function approve(address spender, uint value) external returns (bool);
86 
87     function transferFrom(
88         address from,
89         address to,
90         uint value
91     ) external returns (bool);
92 
93     // Events
94     event Transfer(address indexed from, address indexed to, uint value);
95 
96     event Approval(address indexed owner, address indexed spender, uint value);
97 }
98 
99 
100 // https://docs.synthetix.io/contracts/source/contracts/owned
101 contract Owned {
102     address public owner;
103     address public nominatedOwner;
104 
105     constructor(address _owner) public {
106         require(_owner != address(0), "Owner address cannot be 0");
107         owner = _owner;
108         emit OwnerChanged(address(0), _owner);
109     }
110 
111     function nominateNewOwner(address _owner) external onlyOwner {
112         nominatedOwner = _owner;
113         emit OwnerNominated(_owner);
114     }
115 
116     function acceptOwnership() external {
117         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
118         emit OwnerChanged(owner, nominatedOwner);
119         owner = nominatedOwner;
120         nominatedOwner = address(0);
121     }
122 
123     modifier onlyOwner {
124         _onlyOwner();
125         _;
126     }
127 
128     function _onlyOwner() private view {
129         require(msg.sender == owner, "Only the contract owner may perform this action");
130     }
131 
132     event OwnerNominated(address newOwner);
133     event OwnerChanged(address oldOwner, address newOwner);
134 }
135 
136 
137 // Inheritance
138 
139 
140 // Internal references
141 
142 
143 // https://docs.synthetix.io/contracts/source/contracts/proxy
144 contract Proxy is Owned {
145     Proxyable public target;
146 
147     constructor(address _owner) public Owned(_owner) {}
148 
149     function setTarget(Proxyable _target) external onlyOwner {
150         target = _target;
151         emit TargetUpdated(_target);
152     }
153 
154     function _emit(
155         bytes calldata callData,
156         uint numTopics,
157         bytes32 topic1,
158         bytes32 topic2,
159         bytes32 topic3,
160         bytes32 topic4
161     ) external onlyTarget {
162         uint size = callData.length;
163         bytes memory _callData = callData;
164 
165         assembly {
166             /* The first 32 bytes of callData contain its length (as specified by the abi).
167              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
168              * in length. It is also leftpadded to be a multiple of 32 bytes.
169              * This means moving call_data across 32 bytes guarantees we correctly access
170              * the data itself. */
171             switch numTopics
172                 case 0 {
173                     log0(add(_callData, 32), size)
174                 }
175                 case 1 {
176                     log1(add(_callData, 32), size, topic1)
177                 }
178                 case 2 {
179                     log2(add(_callData, 32), size, topic1, topic2)
180                 }
181                 case 3 {
182                     log3(add(_callData, 32), size, topic1, topic2, topic3)
183                 }
184                 case 4 {
185                     log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
186                 }
187         }
188     }
189 
190     // solhint-disable no-complex-fallback
191     function() external payable {
192         // Mutable call setting Proxyable.messageSender as this is using call not delegatecall
193         target.setMessageSender(msg.sender);
194 
195         assembly {
196             let free_ptr := mload(0x40)
197             calldatacopy(free_ptr, 0, calldatasize)
198 
199             /* We must explicitly forward ether to the underlying contract as well. */
200             let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
201             returndatacopy(free_ptr, 0, returndatasize)
202 
203             if iszero(result) {
204                 revert(free_ptr, returndatasize)
205             }
206             return(free_ptr, returndatasize)
207         }
208     }
209 
210     modifier onlyTarget {
211         require(Proxyable(msg.sender) == target, "Must be proxy target");
212         _;
213     }
214 
215     event TargetUpdated(Proxyable newTarget);
216 }
217 
218 
219 // Inheritance
220 
221 
222 // Internal references
223 
224 
225 // https://docs.synthetix.io/contracts/source/contracts/proxyable
226 contract Proxyable is Owned {
227     // This contract should be treated like an abstract contract
228 
229     /* The proxy this contract exists behind. */
230     Proxy public proxy;
231 
232     /* The caller of the proxy, passed through to this contract.
233      * Note that every function using this member must apply the onlyProxy or
234      * optionalProxy modifiers, otherwise their invocations can use stale values. */
235     address public messageSender;
236 
237     constructor(address payable _proxy) internal {
238         // This contract is abstract, and thus cannot be instantiated directly
239         require(owner != address(0), "Owner must be set");
240 
241         proxy = Proxy(_proxy);
242         emit ProxyUpdated(_proxy);
243     }
244 
245     function setProxy(address payable _proxy) external onlyOwner {
246         proxy = Proxy(_proxy);
247         emit ProxyUpdated(_proxy);
248     }
249 
250     function setMessageSender(address sender) external onlyProxy {
251         messageSender = sender;
252     }
253 
254     modifier onlyProxy {
255         _onlyProxy();
256         _;
257     }
258 
259     function _onlyProxy() private view {
260         require(Proxy(msg.sender) == proxy, "Only the proxy can call");
261     }
262 
263     modifier optionalProxy {
264         _optionalProxy();
265         _;
266     }
267 
268     function _optionalProxy() private {
269         if (Proxy(msg.sender) != proxy && messageSender != msg.sender) {
270             messageSender = msg.sender;
271         }
272     }
273 
274     modifier optionalProxy_onlyOwner {
275         _optionalProxy_onlyOwner();
276         _;
277     }
278 
279     // solhint-disable-next-line func-name-mixedcase
280     function _optionalProxy_onlyOwner() private {
281         if (Proxy(msg.sender) != proxy && messageSender != msg.sender) {
282             messageSender = msg.sender;
283         }
284         require(messageSender == owner, "Owner only function");
285     }
286 
287     event ProxyUpdated(address proxyAddress);
288 }
289 
290 
291 /**
292  * @dev Wrappers over Solidity's arithmetic operations with added overflow
293  * checks.
294  *
295  * Arithmetic operations in Solidity wrap on overflow. This can easily result
296  * in bugs, because programmers usually assume that an overflow raises an
297  * error, which is the standard behavior in high level programming languages.
298  * `SafeMath` restores this intuition by reverting the transaction when an
299  * operation overflows.
300  *
301  * Using this library instead of the unchecked operations eliminates an entire
302  * class of bugs, so it's recommended to use it always.
303  */
304 library SafeMath {
305     /**
306      * @dev Returns the addition of two unsigned integers, reverting on
307      * overflow.
308      *
309      * Counterpart to Solidity's `+` operator.
310      *
311      * Requirements:
312      * - Addition cannot overflow.
313      */
314     function add(uint256 a, uint256 b) internal pure returns (uint256) {
315         uint256 c = a + b;
316         require(c >= a, "SafeMath: addition overflow");
317 
318         return c;
319     }
320 
321     /**
322      * @dev Returns the subtraction of two unsigned integers, reverting on
323      * overflow (when the result is negative).
324      *
325      * Counterpart to Solidity's `-` operator.
326      *
327      * Requirements:
328      * - Subtraction cannot overflow.
329      */
330     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
331         require(b <= a, "SafeMath: subtraction overflow");
332         uint256 c = a - b;
333 
334         return c;
335     }
336 
337     /**
338      * @dev Returns the multiplication of two unsigned integers, reverting on
339      * overflow.
340      *
341      * Counterpart to Solidity's `*` operator.
342      *
343      * Requirements:
344      * - Multiplication cannot overflow.
345      */
346     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
347         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
348         // benefit is lost if 'b' is also tested.
349         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
350         if (a == 0) {
351             return 0;
352         }
353 
354         uint256 c = a * b;
355         require(c / a == b, "SafeMath: multiplication overflow");
356 
357         return c;
358     }
359 
360     /**
361      * @dev Returns the integer division of two unsigned integers. Reverts on
362      * division by zero. The result is rounded towards zero.
363      *
364      * Counterpart to Solidity's `/` operator. Note: this function uses a
365      * `revert` opcode (which leaves remaining gas untouched) while Solidity
366      * uses an invalid opcode to revert (consuming all remaining gas).
367      *
368      * Requirements:
369      * - The divisor cannot be zero.
370      */
371     function div(uint256 a, uint256 b) internal pure returns (uint256) {
372         // Solidity only automatically asserts when dividing by 0
373         require(b > 0, "SafeMath: division by zero");
374         uint256 c = a / b;
375         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
376 
377         return c;
378     }
379 
380     /**
381      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
382      * Reverts when dividing by zero.
383      *
384      * Counterpart to Solidity's `%` operator. This function uses a `revert`
385      * opcode (which leaves remaining gas untouched) while Solidity uses an
386      * invalid opcode to revert (consuming all remaining gas).
387      *
388      * Requirements:
389      * - The divisor cannot be zero.
390      */
391     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
392         require(b != 0, "SafeMath: modulo by zero");
393         return a % b;
394     }
395 }
396 
397 
398 // Libraries
399 
400 
401 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
402 library SafeDecimalMath {
403     using SafeMath for uint;
404 
405     /* Number of decimal places in the representations. */
406     uint8 public constant decimals = 18;
407     uint8 public constant highPrecisionDecimals = 27;
408 
409     /* The number representing 1.0. */
410     uint public constant UNIT = 10**uint(decimals);
411 
412     /* The number representing 1.0 for higher fidelity numbers. */
413     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
414     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
415 
416     /**
417      * @return Provides an interface to UNIT.
418      */
419     function unit() external pure returns (uint) {
420         return UNIT;
421     }
422 
423     /**
424      * @return Provides an interface to PRECISE_UNIT.
425      */
426     function preciseUnit() external pure returns (uint) {
427         return PRECISE_UNIT;
428     }
429 
430     /**
431      * @return The result of multiplying x and y, interpreting the operands as fixed-point
432      * decimals.
433      *
434      * @dev A unit factor is divided out after the product of x and y is evaluated,
435      * so that product must be less than 2**256. As this is an integer division,
436      * the internal division always rounds down. This helps save on gas. Rounding
437      * is more expensive on gas.
438      */
439     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
440         /* Divide by UNIT to remove the extra factor introduced by the product. */
441         return x.mul(y) / UNIT;
442     }
443 
444     /**
445      * @return The result of safely multiplying x and y, interpreting the operands
446      * as fixed-point decimals of the specified precision unit.
447      *
448      * @dev The operands should be in the form of a the specified unit factor which will be
449      * divided out after the product of x and y is evaluated, so that product must be
450      * less than 2**256.
451      *
452      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
453      * Rounding is useful when you need to retain fidelity for small decimal numbers
454      * (eg. small fractions or percentages).
455      */
456     function _multiplyDecimalRound(
457         uint x,
458         uint y,
459         uint precisionUnit
460     ) private pure returns (uint) {
461         /* Divide by UNIT to remove the extra factor introduced by the product. */
462         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
463 
464         if (quotientTimesTen % 10 >= 5) {
465             quotientTimesTen += 10;
466         }
467 
468         return quotientTimesTen / 10;
469     }
470 
471     /**
472      * @return The result of safely multiplying x and y, interpreting the operands
473      * as fixed-point decimals of a precise unit.
474      *
475      * @dev The operands should be in the precise unit factor which will be
476      * divided out after the product of x and y is evaluated, so that product must be
477      * less than 2**256.
478      *
479      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
480      * Rounding is useful when you need to retain fidelity for small decimal numbers
481      * (eg. small fractions or percentages).
482      */
483     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
484         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
485     }
486 
487     /**
488      * @return The result of safely multiplying x and y, interpreting the operands
489      * as fixed-point decimals of a standard unit.
490      *
491      * @dev The operands should be in the standard unit factor which will be
492      * divided out after the product of x and y is evaluated, so that product must be
493      * less than 2**256.
494      *
495      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
496      * Rounding is useful when you need to retain fidelity for small decimal numbers
497      * (eg. small fractions or percentages).
498      */
499     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
500         return _multiplyDecimalRound(x, y, UNIT);
501     }
502 
503     /**
504      * @return The result of safely dividing x and y. The return value is a high
505      * precision decimal.
506      *
507      * @dev y is divided after the product of x and the standard precision unit
508      * is evaluated, so the product of x and UNIT must be less than 2**256. As
509      * this is an integer division, the result is always rounded down.
510      * This helps save on gas. Rounding is more expensive on gas.
511      */
512     function divideDecimal(uint x, uint y) internal pure returns (uint) {
513         /* Reintroduce the UNIT factor that will be divided out by y. */
514         return x.mul(UNIT).div(y);
515     }
516 
517     /**
518      * @return The result of safely dividing x and y. The return value is as a rounded
519      * decimal in the precision unit specified in the parameter.
520      *
521      * @dev y is divided after the product of x and the specified precision unit
522      * is evaluated, so the product of x and the specified precision unit must
523      * be less than 2**256. The result is rounded to the nearest increment.
524      */
525     function _divideDecimalRound(
526         uint x,
527         uint y,
528         uint precisionUnit
529     ) private pure returns (uint) {
530         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
531 
532         if (resultTimesTen % 10 >= 5) {
533             resultTimesTen += 10;
534         }
535 
536         return resultTimesTen / 10;
537     }
538 
539     /**
540      * @return The result of safely dividing x and y. The return value is as a rounded
541      * standard precision decimal.
542      *
543      * @dev y is divided after the product of x and the standard precision unit
544      * is evaluated, so the product of x and the standard precision unit must
545      * be less than 2**256. The result is rounded to the nearest increment.
546      */
547     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
548         return _divideDecimalRound(x, y, UNIT);
549     }
550 
551     /**
552      * @return The result of safely dividing x and y. The return value is as a rounded
553      * high precision decimal.
554      *
555      * @dev y is divided after the product of x and the high precision unit
556      * is evaluated, so the product of x and the high precision unit must
557      * be less than 2**256. The result is rounded to the nearest increment.
558      */
559     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
560         return _divideDecimalRound(x, y, PRECISE_UNIT);
561     }
562 
563     /**
564      * @dev Convert a standard decimal representation to a high precision one.
565      */
566     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
567         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
568     }
569 
570     /**
571      * @dev Convert a high precision decimal to a standard decimal representation.
572      */
573     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
574         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
575 
576         if (quotientTimesTen % 10 >= 5) {
577             quotientTimesTen += 10;
578         }
579 
580         return quotientTimesTen / 10;
581     }
582 
583     // Computes `a - b`, setting the value to 0 if b > a.
584     function floorsub(uint a, uint b) internal pure returns (uint) {
585         return b >= a ? 0 : a - b;
586     }
587 
588     /* ---------- Utilities ---------- */
589     /*
590      * Absolute value of the input, returned as a signed number.
591      */
592     function signedAbs(int x) internal pure returns (int) {
593         return x < 0 ? -x : x;
594     }
595 
596     /*
597      * Absolute value of the input, returned as an unsigned number.
598      */
599     function abs(int x) internal pure returns (uint) {
600         return uint(signedAbs(x));
601     }
602 }
603 
604 
605 // Inheritance
606 
607 
608 // https://docs.synthetix.io/contracts/source/contracts/state
609 contract State is Owned {
610     // the address of the contract that can modify variables
611     // this can only be changed by the owner of this contract
612     address public associatedContract;
613 
614     constructor(address _associatedContract) internal {
615         // This contract is abstract, and thus cannot be instantiated directly
616         require(owner != address(0), "Owner must be set");
617 
618         associatedContract = _associatedContract;
619         emit AssociatedContractUpdated(_associatedContract);
620     }
621 
622     /* ========== SETTERS ========== */
623 
624     // Change the associated contract to a new address
625     function setAssociatedContract(address _associatedContract) external onlyOwner {
626         associatedContract = _associatedContract;
627         emit AssociatedContractUpdated(_associatedContract);
628     }
629 
630     /* ========== MODIFIERS ========== */
631 
632     modifier onlyAssociatedContract {
633         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
634         _;
635     }
636 
637     /* ========== EVENTS ========== */
638 
639     event AssociatedContractUpdated(address associatedContract);
640 }
641 
642 
643 // Inheritance
644 
645 
646 // https://docs.synthetix.io/contracts/source/contracts/tokenstate
647 contract TokenState is Owned, State {
648     /* ERC20 fields. */
649     mapping(address => uint) public balanceOf;
650     mapping(address => mapping(address => uint)) public allowance;
651 
652     constructor(address _owner, address _associatedContract) public Owned(_owner) State(_associatedContract) {}
653 
654     /* ========== SETTERS ========== */
655 
656     /**
657      * @notice Set ERC20 allowance.
658      * @dev Only the associated contract may call this.
659      * @param tokenOwner The authorising party.
660      * @param spender The authorised party.
661      * @param value The total value the authorised party may spend on the
662      * authorising party's behalf.
663      */
664     function setAllowance(
665         address tokenOwner,
666         address spender,
667         uint value
668     ) external onlyAssociatedContract {
669         allowance[tokenOwner][spender] = value;
670     }
671 
672     /**
673      * @notice Set the balance in a given account
674      * @dev Only the associated contract may call this.
675      * @param account The account whose value to set.
676      * @param value The new balance of the given account.
677      */
678     function setBalanceOf(address account, uint value) external onlyAssociatedContract {
679         balanceOf[account] = value;
680     }
681 }
682 
683 
684 // Inheritance
685 
686 
687 // Libraries
688 
689 
690 // Internal references
691 
692 
693 // https://docs.synthetix.io/contracts/source/contracts/externstatetoken
694 contract ExternStateToken is Owned, Proxyable {
695     using SafeMath for uint;
696     using SafeDecimalMath for uint;
697 
698     /* ========== STATE VARIABLES ========== */
699 
700     /* Stores balances and allowances. */
701     TokenState public tokenState;
702 
703     /* Other ERC20 fields. */
704     string public name;
705     string public symbol;
706     uint public totalSupply;
707     uint8 public decimals;
708 
709     constructor(
710         address payable _proxy,
711         TokenState _tokenState,
712         string memory _name,
713         string memory _symbol,
714         uint _totalSupply,
715         uint8 _decimals,
716         address _owner
717     ) public Owned(_owner) Proxyable(_proxy) {
718         tokenState = _tokenState;
719 
720         name = _name;
721         symbol = _symbol;
722         totalSupply = _totalSupply;
723         decimals = _decimals;
724     }
725 
726     /* ========== VIEWS ========== */
727 
728     /**
729      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
730      * @param owner The party authorising spending of their funds.
731      * @param spender The party spending tokenOwner's funds.
732      */
733     function allowance(address owner, address spender) public view returns (uint) {
734         return tokenState.allowance(owner, spender);
735     }
736 
737     /**
738      * @notice Returns the ERC20 token balance of a given account.
739      */
740     function balanceOf(address account) external view returns (uint) {
741         return tokenState.balanceOf(account);
742     }
743 
744     /* ========== MUTATIVE FUNCTIONS ========== */
745 
746     /**
747      * @notice Set the address of the TokenState contract.
748      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
749      * as balances would be unreachable.
750      */
751     function setTokenState(TokenState _tokenState) external optionalProxy_onlyOwner {
752         tokenState = _tokenState;
753         emitTokenStateUpdated(address(_tokenState));
754     }
755 
756     function _internalTransfer(
757         address from,
758         address to,
759         uint value
760     ) internal returns (bool) {
761         /* Disallow transfers to irretrievable-addresses. */
762         require(to != address(0) && to != address(this) && to != address(proxy), "Cannot transfer to this address");
763 
764         // Insufficient balance will be handled by the safe subtraction.
765         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
766         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
767 
768         // Emit a standard ERC20 transfer event
769         emitTransfer(from, to, value);
770 
771         return true;
772     }
773 
774     /**
775      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
776      * the onlyProxy or optionalProxy modifiers.
777      */
778     function _transferByProxy(
779         address from,
780         address to,
781         uint value
782     ) internal returns (bool) {
783         return _internalTransfer(from, to, value);
784     }
785 
786     /*
787      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
788      * possessing the optionalProxy or optionalProxy modifiers.
789      */
790     function _transferFromByProxy(
791         address sender,
792         address from,
793         address to,
794         uint value
795     ) internal returns (bool) {
796         /* Insufficient allowance will be handled by the safe subtraction. */
797         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
798         return _internalTransfer(from, to, value);
799     }
800 
801     /**
802      * @notice Approves spender to transfer on the message sender's behalf.
803      */
804     function approve(address spender, uint value) public optionalProxy returns (bool) {
805         address sender = messageSender;
806 
807         tokenState.setAllowance(sender, spender, value);
808         emitApproval(sender, spender, value);
809         return true;
810     }
811 
812     /* ========== EVENTS ========== */
813     function addressToBytes32(address input) internal pure returns (bytes32) {
814         return bytes32(uint256(uint160(input)));
815     }
816 
817     event Transfer(address indexed from, address indexed to, uint value);
818     bytes32 internal constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
819 
820     function emitTransfer(
821         address from,
822         address to,
823         uint value
824     ) internal {
825         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, addressToBytes32(from), addressToBytes32(to), 0);
826     }
827 
828     event Approval(address indexed owner, address indexed spender, uint value);
829     bytes32 internal constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
830 
831     function emitApproval(
832         address owner,
833         address spender,
834         uint value
835     ) internal {
836         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, addressToBytes32(owner), addressToBytes32(spender), 0);
837     }
838 
839     event TokenStateUpdated(address newTokenState);
840     bytes32 internal constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
841 
842     function emitTokenStateUpdated(address newTokenState) internal {
843         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
844     }
845 }
846 
847 
848 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
849 interface IAddressResolver {
850     function getAddress(bytes32 name) external view returns (address);
851 
852     function getSynth(bytes32 key) external view returns (address);
853 
854     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
855 }
856 
857 
858 // https://docs.synthetix.io/contracts/source/interfaces/isynth
859 interface ISynth {
860     // Views
861     function currencyKey() external view returns (bytes32);
862 
863     function transferableSynths(address account) external view returns (uint);
864 
865     // Mutative functions
866     function transferAndSettle(address to, uint value) external returns (bool);
867 
868     function transferFromAndSettle(
869         address from,
870         address to,
871         uint value
872     ) external returns (bool);
873 
874     // Restricted: used internally to Synthetix
875     function burn(address account, uint amount) external;
876 
877     function issue(address account, uint amount) external;
878 }
879 
880 
881 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
882 interface IIssuer {
883     // Views
884 
885     function allNetworksDebtInfo()
886         external
887         view
888         returns (
889             uint256 debt,
890             uint256 sharesSupply,
891             bool isStale
892         );
893 
894     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
895 
896     function availableCurrencyKeys() external view returns (bytes32[] memory);
897 
898     function availableSynthCount() external view returns (uint);
899 
900     function availableSynths(uint index) external view returns (ISynth);
901 
902     function canBurnSynths(address account) external view returns (bool);
903 
904     function collateral(address account) external view returns (uint);
905 
906     function collateralisationRatio(address issuer) external view returns (uint);
907 
908     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
909         external
910         view
911         returns (uint cratio, bool anyRateIsInvalid);
912 
913     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
914 
915     function issuanceRatio() external view returns (uint);
916 
917     function lastIssueEvent(address account) external view returns (uint);
918 
919     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
920 
921     function minimumStakeTime() external view returns (uint);
922 
923     function remainingIssuableSynths(address issuer)
924         external
925         view
926         returns (
927             uint maxIssuable,
928             uint alreadyIssued,
929             uint totalSystemDebt
930         );
931 
932     function synths(bytes32 currencyKey) external view returns (ISynth);
933 
934     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
935 
936     function synthsByAddress(address synthAddress) external view returns (bytes32);
937 
938     function totalIssuedSynths(bytes32 currencyKey, bool excludeOtherCollateral) external view returns (uint);
939 
940     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
941         external
942         view
943         returns (uint transferable, bool anyRateIsInvalid);
944 
945     // Restricted: used internally to Synthetix
946     function issueSynths(address from, uint amount) external;
947 
948     function issueSynthsOnBehalf(
949         address issueFor,
950         address from,
951         uint amount
952     ) external;
953 
954     function issueMaxSynths(address from) external;
955 
956     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
957 
958     function burnSynths(address from, uint amount) external;
959 
960     function burnSynthsOnBehalf(
961         address burnForAddress,
962         address from,
963         uint amount
964     ) external;
965 
966     function burnSynthsToTarget(address from) external;
967 
968     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
969 
970     function burnForRedemption(
971         address deprecatedSynthProxy,
972         address account,
973         uint balance
974     ) external;
975 
976     function setCurrentPeriodId(uint128 periodId) external;
977 
978     function liquidateAccount(address account, bool isSelfLiquidation)
979         external
980         returns (uint totalRedeemed, uint amountToLiquidate);
981 
982     function issueSynthsWithoutDebt(
983         bytes32 currencyKey,
984         address to,
985         uint amount
986     ) external returns (bool rateInvalid);
987 
988     function burnSynthsWithoutDebt(
989         bytes32 currencyKey,
990         address to,
991         uint amount
992     ) external returns (bool rateInvalid);
993 }
994 
995 
996 // Inheritance
997 
998 
999 // Internal references
1000 
1001 
1002 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
1003 contract AddressResolver is Owned, IAddressResolver {
1004     mapping(bytes32 => address) public repository;
1005 
1006     constructor(address _owner) public Owned(_owner) {}
1007 
1008     /* ========== RESTRICTED FUNCTIONS ========== */
1009 
1010     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
1011         require(names.length == destinations.length, "Input lengths must match");
1012 
1013         for (uint i = 0; i < names.length; i++) {
1014             bytes32 name = names[i];
1015             address destination = destinations[i];
1016             repository[name] = destination;
1017             emit AddressImported(name, destination);
1018         }
1019     }
1020 
1021     /* ========= PUBLIC FUNCTIONS ========== */
1022 
1023     function rebuildCaches(MixinResolver[] calldata destinations) external {
1024         for (uint i = 0; i < destinations.length; i++) {
1025             destinations[i].rebuildCache();
1026         }
1027     }
1028 
1029     /* ========== VIEWS ========== */
1030 
1031     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
1032         for (uint i = 0; i < names.length; i++) {
1033             if (repository[names[i]] != destinations[i]) {
1034                 return false;
1035             }
1036         }
1037         return true;
1038     }
1039 
1040     function getAddress(bytes32 name) external view returns (address) {
1041         return repository[name];
1042     }
1043 
1044     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
1045         address _foundAddress = repository[name];
1046         require(_foundAddress != address(0), reason);
1047         return _foundAddress;
1048     }
1049 
1050     function getSynth(bytes32 key) external view returns (address) {
1051         IIssuer issuer = IIssuer(repository["Issuer"]);
1052         require(address(issuer) != address(0), "Cannot find Issuer address");
1053         return address(issuer.synths(key));
1054     }
1055 
1056     /* ========== EVENTS ========== */
1057 
1058     event AddressImported(bytes32 name, address destination);
1059 }
1060 
1061 
1062 // Internal references
1063 
1064 
1065 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
1066 contract MixinResolver {
1067     AddressResolver public resolver;
1068 
1069     mapping(bytes32 => address) private addressCache;
1070 
1071     constructor(address _resolver) internal {
1072         resolver = AddressResolver(_resolver);
1073     }
1074 
1075     /* ========== INTERNAL FUNCTIONS ========== */
1076 
1077     function combineArrays(bytes32[] memory first, bytes32[] memory second)
1078         internal
1079         pure
1080         returns (bytes32[] memory combination)
1081     {
1082         combination = new bytes32[](first.length + second.length);
1083 
1084         for (uint i = 0; i < first.length; i++) {
1085             combination[i] = first[i];
1086         }
1087 
1088         for (uint j = 0; j < second.length; j++) {
1089             combination[first.length + j] = second[j];
1090         }
1091     }
1092 
1093     /* ========== PUBLIC FUNCTIONS ========== */
1094 
1095     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
1096     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
1097 
1098     function rebuildCache() public {
1099         bytes32[] memory requiredAddresses = resolverAddressesRequired();
1100         // The resolver must call this function whenver it updates its state
1101         for (uint i = 0; i < requiredAddresses.length; i++) {
1102             bytes32 name = requiredAddresses[i];
1103             // Note: can only be invoked once the resolver has all the targets needed added
1104             address destination =
1105                 resolver.requireAndGetAddress(name, string(abi.encodePacked("Resolver missing target: ", name)));
1106             addressCache[name] = destination;
1107             emit CacheUpdated(name, destination);
1108         }
1109     }
1110 
1111     /* ========== VIEWS ========== */
1112 
1113     function isResolverCached() external view returns (bool) {
1114         bytes32[] memory requiredAddresses = resolverAddressesRequired();
1115         for (uint i = 0; i < requiredAddresses.length; i++) {
1116             bytes32 name = requiredAddresses[i];
1117             // false if our cache is invalid or if the resolver doesn't have the required address
1118             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
1119                 return false;
1120             }
1121         }
1122 
1123         return true;
1124     }
1125 
1126     /* ========== INTERNAL FUNCTIONS ========== */
1127 
1128     function requireAndGetAddress(bytes32 name) internal view returns (address) {
1129         address _foundAddress = addressCache[name];
1130         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
1131         return _foundAddress;
1132     }
1133 
1134     /* ========== EVENTS ========== */
1135 
1136     event CacheUpdated(bytes32 name, address destination);
1137 }
1138 
1139 
1140 interface IVirtualSynth {
1141     // Views
1142     function balanceOfUnderlying(address account) external view returns (uint);
1143 
1144     function rate() external view returns (uint);
1145 
1146     function readyToSettle() external view returns (bool);
1147 
1148     function secsLeftInWaitingPeriod() external view returns (uint);
1149 
1150     function settled() external view returns (bool);
1151 
1152     function synth() external view returns (ISynth);
1153 
1154     // Mutative functions
1155     function settle(address account) external;
1156 }
1157 
1158 
1159 // https://docs.synthetix.io/contracts/source/interfaces/isynthetix
1160 interface ISynthetix {
1161     // Views
1162     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
1163 
1164     function availableCurrencyKeys() external view returns (bytes32[] memory);
1165 
1166     function availableSynthCount() external view returns (uint);
1167 
1168     function availableSynths(uint index) external view returns (ISynth);
1169 
1170     function collateral(address account) external view returns (uint);
1171 
1172     function collateralisationRatio(address issuer) external view returns (uint);
1173 
1174     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
1175 
1176     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
1177 
1178     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
1179 
1180     function remainingIssuableSynths(address issuer)
1181         external
1182         view
1183         returns (
1184             uint maxIssuable,
1185             uint alreadyIssued,
1186             uint totalSystemDebt
1187         );
1188 
1189     function synths(bytes32 currencyKey) external view returns (ISynth);
1190 
1191     function synthsByAddress(address synthAddress) external view returns (bytes32);
1192 
1193     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
1194 
1195     function totalIssuedSynthsExcludeOtherCollateral(bytes32 currencyKey) external view returns (uint);
1196 
1197     function transferableSynthetix(address account) external view returns (uint transferable);
1198 
1199     // Mutative Functions
1200     function burnSynths(uint amount) external;
1201 
1202     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
1203 
1204     function burnSynthsToTarget() external;
1205 
1206     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
1207 
1208     function exchange(
1209         bytes32 sourceCurrencyKey,
1210         uint sourceAmount,
1211         bytes32 destinationCurrencyKey
1212     ) external returns (uint amountReceived);
1213 
1214     function exchangeOnBehalf(
1215         address exchangeForAddress,
1216         bytes32 sourceCurrencyKey,
1217         uint sourceAmount,
1218         bytes32 destinationCurrencyKey
1219     ) external returns (uint amountReceived);
1220 
1221     function exchangeWithTracking(
1222         bytes32 sourceCurrencyKey,
1223         uint sourceAmount,
1224         bytes32 destinationCurrencyKey,
1225         address rewardAddress,
1226         bytes32 trackingCode
1227     ) external returns (uint amountReceived);
1228 
1229     function exchangeWithTrackingForInitiator(
1230         bytes32 sourceCurrencyKey,
1231         uint sourceAmount,
1232         bytes32 destinationCurrencyKey,
1233         address rewardAddress,
1234         bytes32 trackingCode
1235     ) external returns (uint amountReceived);
1236 
1237     function exchangeOnBehalfWithTracking(
1238         address exchangeForAddress,
1239         bytes32 sourceCurrencyKey,
1240         uint sourceAmount,
1241         bytes32 destinationCurrencyKey,
1242         address rewardAddress,
1243         bytes32 trackingCode
1244     ) external returns (uint amountReceived);
1245 
1246     function exchangeWithVirtual(
1247         bytes32 sourceCurrencyKey,
1248         uint sourceAmount,
1249         bytes32 destinationCurrencyKey,
1250         bytes32 trackingCode
1251     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1252 
1253     function exchangeAtomically(
1254         bytes32 sourceCurrencyKey,
1255         uint sourceAmount,
1256         bytes32 destinationCurrencyKey,
1257         bytes32 trackingCode,
1258         uint minAmount
1259     ) external returns (uint amountReceived);
1260 
1261     function issueMaxSynths() external;
1262 
1263     function issueMaxSynthsOnBehalf(address issueForAddress) external;
1264 
1265     function issueSynths(uint amount) external;
1266 
1267     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
1268 
1269     function mint() external returns (bool);
1270 
1271     function settle(bytes32 currencyKey)
1272         external
1273         returns (
1274             uint reclaimed,
1275             uint refunded,
1276             uint numEntries
1277         );
1278 
1279     // Liquidations
1280     function liquidateDelinquentAccount(address account) external returns (bool);
1281 
1282     function liquidateSelf() external returns (bool);
1283 
1284     // Restricted Functions
1285 
1286     function mintSecondary(address account, uint amount) external;
1287 
1288     function mintSecondaryRewards(uint amount) external;
1289 
1290     function burnSecondary(address account, uint amount) external;
1291 }
1292 
1293 
1294 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1295 interface ISystemStatus {
1296     struct Status {
1297         bool canSuspend;
1298         bool canResume;
1299     }
1300 
1301     struct Suspension {
1302         bool suspended;
1303         // reason is an integer code,
1304         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1305         uint248 reason;
1306     }
1307 
1308     // Views
1309     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1310 
1311     function requireSystemActive() external view;
1312 
1313     function systemSuspended() external view returns (bool);
1314 
1315     function requireIssuanceActive() external view;
1316 
1317     function requireExchangeActive() external view;
1318 
1319     function requireFuturesActive() external view;
1320 
1321     function requireFuturesMarketActive(bytes32 marketKey) external view;
1322 
1323     function requireExchangeBetweenSynthsAllowed(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1324 
1325     function requireSynthActive(bytes32 currencyKey) external view;
1326 
1327     function synthSuspended(bytes32 currencyKey) external view returns (bool);
1328 
1329     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1330 
1331     function systemSuspension() external view returns (bool suspended, uint248 reason);
1332 
1333     function issuanceSuspension() external view returns (bool suspended, uint248 reason);
1334 
1335     function exchangeSuspension() external view returns (bool suspended, uint248 reason);
1336 
1337     function futuresSuspension() external view returns (bool suspended, uint248 reason);
1338 
1339     function synthExchangeSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1340 
1341     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1342 
1343     function futuresMarketSuspension(bytes32 marketKey) external view returns (bool suspended, uint248 reason);
1344 
1345     function getSynthExchangeSuspensions(bytes32[] calldata synths)
1346         external
1347         view
1348         returns (bool[] memory exchangeSuspensions, uint256[] memory reasons);
1349 
1350     function getSynthSuspensions(bytes32[] calldata synths)
1351         external
1352         view
1353         returns (bool[] memory suspensions, uint256[] memory reasons);
1354 
1355     function getFuturesMarketSuspensions(bytes32[] calldata marketKeys)
1356         external
1357         view
1358         returns (bool[] memory suspensions, uint256[] memory reasons);
1359 
1360     // Restricted functions
1361     function suspendIssuance(uint256 reason) external;
1362 
1363     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1364 
1365     function suspendFuturesMarket(bytes32 marketKey, uint256 reason) external;
1366 
1367     function updateAccessControl(
1368         bytes32 section,
1369         address account,
1370         bool canSuspend,
1371         bool canResume
1372     ) external;
1373 }
1374 
1375 
1376 // https://docs.synthetix.io/contracts/source/interfaces/iexchanger
1377 interface IExchanger {
1378     struct ExchangeEntrySettlement {
1379         bytes32 src;
1380         uint amount;
1381         bytes32 dest;
1382         uint reclaim;
1383         uint rebate;
1384         uint srcRoundIdAtPeriodEnd;
1385         uint destRoundIdAtPeriodEnd;
1386         uint timestamp;
1387     }
1388 
1389     struct ExchangeEntry {
1390         uint sourceRate;
1391         uint destinationRate;
1392         uint destinationAmount;
1393         uint exchangeFeeRate;
1394         uint exchangeDynamicFeeRate;
1395         uint roundIdForSrc;
1396         uint roundIdForDest;
1397     }
1398 
1399     // Views
1400     function calculateAmountAfterSettlement(
1401         address from,
1402         bytes32 currencyKey,
1403         uint amount,
1404         uint refunded
1405     ) external view returns (uint amountAfterSettlement);
1406 
1407     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
1408 
1409     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
1410 
1411     function settlementOwing(address account, bytes32 currencyKey)
1412         external
1413         view
1414         returns (
1415             uint reclaimAmount,
1416             uint rebateAmount,
1417             uint numEntries
1418         );
1419 
1420     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
1421 
1422     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view returns (uint);
1423 
1424     function dynamicFeeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
1425         external
1426         view
1427         returns (uint feeRate, bool tooVolatile);
1428 
1429     function getAmountsForExchange(
1430         uint sourceAmount,
1431         bytes32 sourceCurrencyKey,
1432         bytes32 destinationCurrencyKey
1433     )
1434         external
1435         view
1436         returns (
1437             uint amountReceived,
1438             uint fee,
1439             uint exchangeFeeRate
1440         );
1441 
1442     function priceDeviationThresholdFactor() external view returns (uint);
1443 
1444     function waitingPeriodSecs() external view returns (uint);
1445 
1446     function lastExchangeRate(bytes32 currencyKey) external view returns (uint);
1447 
1448     // Mutative functions
1449     function exchange(
1450         address exchangeForAddress,
1451         address from,
1452         bytes32 sourceCurrencyKey,
1453         uint sourceAmount,
1454         bytes32 destinationCurrencyKey,
1455         address destinationAddress,
1456         bool virtualSynth,
1457         address rewardAddress,
1458         bytes32 trackingCode
1459     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1460 
1461     function exchangeAtomically(
1462         address from,
1463         bytes32 sourceCurrencyKey,
1464         uint sourceAmount,
1465         bytes32 destinationCurrencyKey,
1466         address destinationAddress,
1467         bytes32 trackingCode,
1468         uint minAmount
1469     ) external returns (uint amountReceived);
1470 
1471     function settle(address from, bytes32 currencyKey)
1472         external
1473         returns (
1474             uint reclaimed,
1475             uint refunded,
1476             uint numEntries
1477         );
1478 
1479     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
1480 }
1481 
1482 
1483 // https://docs.synthetix.io/contracts/source/interfaces/irewardsdistribution
1484 interface IRewardsDistribution {
1485     // Structs
1486     struct DistributionData {
1487         address destination;
1488         uint amount;
1489     }
1490 
1491     // Views
1492     function authority() external view returns (address);
1493 
1494     function distributions(uint index) external view returns (address destination, uint amount); // DistributionData
1495 
1496     function distributionsLength() external view returns (uint);
1497 
1498     // Mutative Functions
1499     function distributeRewards(uint amount) external returns (bool);
1500 }
1501 
1502 
1503 interface ILiquidator {
1504     // Views
1505     function issuanceRatio() external view returns (uint);
1506 
1507     function liquidationDelay() external view returns (uint);
1508 
1509     function liquidationRatio() external view returns (uint);
1510 
1511     function liquidationEscrowDuration() external view returns (uint);
1512 
1513     function liquidationPenalty() external view returns (uint);
1514 
1515     function selfLiquidationPenalty() external view returns (uint);
1516 
1517     function liquidateReward() external view returns (uint);
1518 
1519     function flagReward() external view returns (uint);
1520 
1521     function liquidationCollateralRatio() external view returns (uint);
1522 
1523     function getLiquidationDeadlineForAccount(address account) external view returns (uint);
1524 
1525     function getLiquidationCallerForAccount(address account) external view returns (address);
1526 
1527     function isLiquidationOpen(address account, bool isSelfLiquidation) external view returns (bool);
1528 
1529     function isLiquidationDeadlinePassed(address account) external view returns (bool);
1530 
1531     function calculateAmountToFixCollateral(
1532         uint debtBalance,
1533         uint collateral,
1534         uint penalty
1535     ) external view returns (uint);
1536 
1537     // Mutative Functions
1538     function flagAccountForLiquidation(address account) external;
1539 
1540     // Restricted: used internally to Synthetix contracts
1541     function removeAccountInLiquidation(address account) external;
1542 
1543     function checkAndRemoveAccountInLiquidation(address account) external;
1544 }
1545 
1546 
1547 interface ILiquidatorRewards {
1548     // Views
1549 
1550     function earned(address account) external view returns (uint256);
1551 
1552     // Mutative
1553 
1554     function getReward(address account) external;
1555 
1556     function notifyRewardAmount(uint256 reward) external;
1557 
1558     function updateEntry(address account) external;
1559 }
1560 
1561 
1562 // Inheritance
1563 
1564 
1565 // Internal references
1566 
1567 
1568 contract BaseSynthetix is IERC20, ExternStateToken, MixinResolver, ISynthetix {
1569     // ========== STATE VARIABLES ==========
1570 
1571     // Available Synths which can be used with the system
1572     string public constant TOKEN_NAME = "Synthetix Network Token";
1573     string public constant TOKEN_SYMBOL = "SNX";
1574     uint8 public constant DECIMALS = 18;
1575     bytes32 public constant sUSD = "sUSD";
1576 
1577     // ========== ADDRESS RESOLVER CONFIGURATION ==========
1578     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1579     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1580     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1581     bytes32 private constant CONTRACT_REWARDSDISTRIBUTION = "RewardsDistribution";
1582     bytes32 private constant CONTRACT_LIQUIDATORREWARDS = "LiquidatorRewards";
1583     bytes32 private constant CONTRACT_LIQUIDATOR = "Liquidator";
1584 
1585     // ========== CONSTRUCTOR ==========
1586 
1587     constructor(
1588         address payable _proxy,
1589         TokenState _tokenState,
1590         address _owner,
1591         uint _totalSupply,
1592         address _resolver
1593     )
1594         public
1595         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, _totalSupply, DECIMALS, _owner)
1596         MixinResolver(_resolver)
1597     {}
1598 
1599     // ========== VIEWS ==========
1600 
1601     // Note: use public visibility so that it can be invoked in a subclass
1602     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1603         addresses = new bytes32[](6);
1604         addresses[0] = CONTRACT_SYSTEMSTATUS;
1605         addresses[1] = CONTRACT_EXCHANGER;
1606         addresses[2] = CONTRACT_ISSUER;
1607         addresses[3] = CONTRACT_REWARDSDISTRIBUTION;
1608         addresses[4] = CONTRACT_LIQUIDATORREWARDS;
1609         addresses[5] = CONTRACT_LIQUIDATOR;
1610     }
1611 
1612     function systemStatus() internal view returns (ISystemStatus) {
1613         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1614     }
1615 
1616     function exchanger() internal view returns (IExchanger) {
1617         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER));
1618     }
1619 
1620     function issuer() internal view returns (IIssuer) {
1621         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1622     }
1623 
1624     function rewardsDistribution() internal view returns (IRewardsDistribution) {
1625         return IRewardsDistribution(requireAndGetAddress(CONTRACT_REWARDSDISTRIBUTION));
1626     }
1627 
1628     function liquidatorRewards() internal view returns (ILiquidatorRewards) {
1629         return ILiquidatorRewards(requireAndGetAddress(CONTRACT_LIQUIDATORREWARDS));
1630     }
1631 
1632     function liquidator() internal view returns (ILiquidator) {
1633         return ILiquidator(requireAndGetAddress(CONTRACT_LIQUIDATOR));
1634     }
1635 
1636     function debtBalanceOf(address account, bytes32 currencyKey) external view returns (uint) {
1637         return issuer().debtBalanceOf(account, currencyKey);
1638     }
1639 
1640     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint) {
1641         return issuer().totalIssuedSynths(currencyKey, false);
1642     }
1643 
1644     function totalIssuedSynthsExcludeOtherCollateral(bytes32 currencyKey) external view returns (uint) {
1645         return issuer().totalIssuedSynths(currencyKey, true);
1646     }
1647 
1648     function availableCurrencyKeys() external view returns (bytes32[] memory) {
1649         return issuer().availableCurrencyKeys();
1650     }
1651 
1652     function availableSynthCount() external view returns (uint) {
1653         return issuer().availableSynthCount();
1654     }
1655 
1656     function availableSynths(uint index) external view returns (ISynth) {
1657         return issuer().availableSynths(index);
1658     }
1659 
1660     function synths(bytes32 currencyKey) external view returns (ISynth) {
1661         return issuer().synths(currencyKey);
1662     }
1663 
1664     function synthsByAddress(address synthAddress) external view returns (bytes32) {
1665         return issuer().synthsByAddress(synthAddress);
1666     }
1667 
1668     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool) {
1669         return exchanger().maxSecsLeftInWaitingPeriod(messageSender, currencyKey) > 0;
1670     }
1671 
1672     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid) {
1673         return issuer().anySynthOrSNXRateIsInvalid();
1674     }
1675 
1676     function maxIssuableSynths(address account) external view returns (uint maxIssuable) {
1677         return issuer().maxIssuableSynths(account);
1678     }
1679 
1680     function remainingIssuableSynths(address account)
1681         external
1682         view
1683         returns (
1684             uint maxIssuable,
1685             uint alreadyIssued,
1686             uint totalSystemDebt
1687         )
1688     {
1689         return issuer().remainingIssuableSynths(account);
1690     }
1691 
1692     function collateralisationRatio(address _issuer) external view returns (uint) {
1693         return issuer().collateralisationRatio(_issuer);
1694     }
1695 
1696     function collateral(address account) external view returns (uint) {
1697         return issuer().collateral(account);
1698     }
1699 
1700     function transferableSynthetix(address account) external view returns (uint transferable) {
1701         (transferable, ) = issuer().transferableSynthetixAndAnyRateIsInvalid(account, tokenState.balanceOf(account));
1702     }
1703 
1704     function _canTransfer(address account, uint value) internal view returns (bool) {
1705         if (issuer().debtBalanceOf(account, sUSD) > 0) {
1706             (uint transferable, bool anyRateIsInvalid) =
1707                 issuer().transferableSynthetixAndAnyRateIsInvalid(account, tokenState.balanceOf(account));
1708             require(value <= transferable, "Cannot transfer staked or escrowed SNX");
1709             require(!anyRateIsInvalid, "A synth or SNX rate is invalid");
1710         }
1711 
1712         return true;
1713     }
1714 
1715     // ========== MUTATIVE FUNCTIONS ==========
1716 
1717     function exchange(
1718         bytes32 sourceCurrencyKey,
1719         uint sourceAmount,
1720         bytes32 destinationCurrencyKey
1721     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
1722         (amountReceived, ) = exchanger().exchange(
1723             messageSender,
1724             messageSender,
1725             sourceCurrencyKey,
1726             sourceAmount,
1727             destinationCurrencyKey,
1728             messageSender,
1729             false,
1730             messageSender,
1731             bytes32(0)
1732         );
1733     }
1734 
1735     function exchangeOnBehalf(
1736         address exchangeForAddress,
1737         bytes32 sourceCurrencyKey,
1738         uint sourceAmount,
1739         bytes32 destinationCurrencyKey
1740     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
1741         (amountReceived, ) = exchanger().exchange(
1742             exchangeForAddress,
1743             messageSender,
1744             sourceCurrencyKey,
1745             sourceAmount,
1746             destinationCurrencyKey,
1747             exchangeForAddress,
1748             false,
1749             exchangeForAddress,
1750             bytes32(0)
1751         );
1752     }
1753 
1754     function settle(bytes32 currencyKey)
1755         external
1756         optionalProxy
1757         returns (
1758             uint reclaimed,
1759             uint refunded,
1760             uint numEntriesSettled
1761         )
1762     {
1763         return exchanger().settle(messageSender, currencyKey);
1764     }
1765 
1766     function exchangeWithTracking(
1767         bytes32 sourceCurrencyKey,
1768         uint sourceAmount,
1769         bytes32 destinationCurrencyKey,
1770         address rewardAddress,
1771         bytes32 trackingCode
1772     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
1773         (amountReceived, ) = exchanger().exchange(
1774             messageSender,
1775             messageSender,
1776             sourceCurrencyKey,
1777             sourceAmount,
1778             destinationCurrencyKey,
1779             messageSender,
1780             false,
1781             rewardAddress,
1782             trackingCode
1783         );
1784     }
1785 
1786     function exchangeOnBehalfWithTracking(
1787         address exchangeForAddress,
1788         bytes32 sourceCurrencyKey,
1789         uint sourceAmount,
1790         bytes32 destinationCurrencyKey,
1791         address rewardAddress,
1792         bytes32 trackingCode
1793     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
1794         (amountReceived, ) = exchanger().exchange(
1795             exchangeForAddress,
1796             messageSender,
1797             sourceCurrencyKey,
1798             sourceAmount,
1799             destinationCurrencyKey,
1800             exchangeForAddress,
1801             false,
1802             rewardAddress,
1803             trackingCode
1804         );
1805     }
1806 
1807     function transfer(address to, uint value) external optionalProxy systemActive returns (bool) {
1808         // Ensure they're not trying to exceed their locked amount -- only if they have debt.
1809         _canTransfer(messageSender, value);
1810 
1811         // Perform the transfer: if there is a problem an exception will be thrown in this call.
1812         _transferByProxy(messageSender, to, value);
1813 
1814         return true;
1815     }
1816 
1817     function transferFrom(
1818         address from,
1819         address to,
1820         uint value
1821     ) external optionalProxy systemActive returns (bool) {
1822         // Ensure they're not trying to exceed their locked amount -- only if they have debt.
1823         _canTransfer(from, value);
1824 
1825         // Perform the transfer: if there is a problem,
1826         // an exception will be thrown in this call.
1827         return _transferFromByProxy(messageSender, from, to, value);
1828     }
1829 
1830     function issueSynths(uint amount) external issuanceActive optionalProxy {
1831         return issuer().issueSynths(messageSender, amount);
1832     }
1833 
1834     function issueSynthsOnBehalf(address issueForAddress, uint amount) external issuanceActive optionalProxy {
1835         return issuer().issueSynthsOnBehalf(issueForAddress, messageSender, amount);
1836     }
1837 
1838     function issueMaxSynths() external issuanceActive optionalProxy {
1839         return issuer().issueMaxSynths(messageSender);
1840     }
1841 
1842     function issueMaxSynthsOnBehalf(address issueForAddress) external issuanceActive optionalProxy {
1843         return issuer().issueMaxSynthsOnBehalf(issueForAddress, messageSender);
1844     }
1845 
1846     function burnSynths(uint amount) external issuanceActive optionalProxy {
1847         return issuer().burnSynths(messageSender, amount);
1848     }
1849 
1850     function burnSynthsOnBehalf(address burnForAddress, uint amount) external issuanceActive optionalProxy {
1851         return issuer().burnSynthsOnBehalf(burnForAddress, messageSender, amount);
1852     }
1853 
1854     function burnSynthsToTarget() external issuanceActive optionalProxy {
1855         return issuer().burnSynthsToTarget(messageSender);
1856     }
1857 
1858     function burnSynthsToTargetOnBehalf(address burnForAddress) external issuanceActive optionalProxy {
1859         return issuer().burnSynthsToTargetOnBehalf(burnForAddress, messageSender);
1860     }
1861 
1862     /// @notice Force liquidate a delinquent account and distribute the redeemed SNX rewards amongst the appropriate recipients.
1863     /// @dev The SNX transfers will revert if the amount to send is more than balanceOf account (i.e. due to escrowed balance).
1864     function liquidateDelinquentAccount(address account) external systemActive optionalProxy returns (bool) {
1865         (uint totalRedeemed, uint amountLiquidated) = issuer().liquidateAccount(account, false);
1866 
1867         emitAccountLiquidated(account, totalRedeemed, amountLiquidated, messageSender);
1868 
1869         if (totalRedeemed > 0) {
1870             uint stakerRewards; // The amount of rewards to be sent to the LiquidatorRewards contract.
1871             uint flagReward = liquidator().flagReward();
1872             uint liquidateReward = liquidator().liquidateReward();
1873             // Check if the total amount of redeemed SNX is enough to payout the liquidation rewards.
1874             if (totalRedeemed > flagReward.add(liquidateReward)) {
1875                 // Transfer the flagReward to the account who flagged this account for liquidation.
1876                 address flagger = liquidator().getLiquidationCallerForAccount(account);
1877                 bool flagRewardTransferSucceeded = _transferByProxy(account, flagger, flagReward);
1878                 require(flagRewardTransferSucceeded, "Flag reward transfer did not succeed");
1879 
1880                 // Transfer the liquidateReward to liquidator (the account who invoked this liquidation).
1881                 bool liquidateRewardTransferSucceeded = _transferByProxy(account, messageSender, liquidateReward);
1882                 require(liquidateRewardTransferSucceeded, "Liquidate reward transfer did not succeed");
1883 
1884                 // The remaining SNX to be sent to the LiquidatorRewards contract.
1885                 stakerRewards = totalRedeemed.sub(flagReward.add(liquidateReward));
1886             } else {
1887                 /* If the total amount of redeemed SNX is greater than zero 
1888                 but is less than the sum of the flag & liquidate rewards,
1889                 then just send all of the SNX to the LiquidatorRewards contract. */
1890                 stakerRewards = totalRedeemed;
1891             }
1892 
1893             bool liquidatorRewardTransferSucceeded = _transferByProxy(account, address(liquidatorRewards()), stakerRewards);
1894             require(liquidatorRewardTransferSucceeded, "Transfer to LiquidatorRewards failed");
1895 
1896             // Inform the LiquidatorRewards contract about the incoming SNX rewards.
1897             liquidatorRewards().notifyRewardAmount(stakerRewards);
1898 
1899             return true;
1900         } else {
1901             // In this unlikely case, the total redeemed SNX is not greater than zero so don't perform any transfers.
1902             return false;
1903         }
1904     }
1905 
1906     /// @notice Allows an account to self-liquidate anytime its c-ratio is below the target issuance ratio.
1907     function liquidateSelf() external systemActive optionalProxy returns (bool) {
1908         // Self liquidate the account (`isSelfLiquidation` flag must be set to `true`).
1909         (uint totalRedeemed, uint amountLiquidated) = issuer().liquidateAccount(messageSender, true);
1910 
1911         emitAccountLiquidated(messageSender, totalRedeemed, amountLiquidated, messageSender);
1912 
1913         // Transfer the redeemed SNX to the LiquidatorRewards contract.
1914         // Reverts if amount to redeem is more than balanceOf account (i.e. due to escrowed balance).
1915         bool success = _transferByProxy(messageSender, address(liquidatorRewards()), totalRedeemed);
1916         require(success, "Transfer to LiquidatorRewards failed");
1917 
1918         // Inform the LiquidatorRewards contract about the incoming SNX rewards.
1919         liquidatorRewards().notifyRewardAmount(totalRedeemed);
1920 
1921         return success;
1922     }
1923 
1924     function exchangeWithTrackingForInitiator(
1925         bytes32,
1926         uint,
1927         bytes32,
1928         address,
1929         bytes32
1930     ) external returns (uint) {
1931         _notImplemented();
1932     }
1933 
1934     function exchangeWithVirtual(
1935         bytes32,
1936         uint,
1937         bytes32,
1938         bytes32
1939     ) external returns (uint, IVirtualSynth) {
1940         _notImplemented();
1941     }
1942 
1943     function exchangeAtomically(
1944         bytes32,
1945         uint,
1946         bytes32,
1947         bytes32,
1948         uint
1949     ) external returns (uint) {
1950         _notImplemented();
1951     }
1952 
1953     function mint() external returns (bool) {
1954         _notImplemented();
1955     }
1956 
1957     function mintSecondary(address, uint) external {
1958         _notImplemented();
1959     }
1960 
1961     function mintSecondaryRewards(uint) external {
1962         _notImplemented();
1963     }
1964 
1965     function burnSecondary(address, uint) external {
1966         _notImplemented();
1967     }
1968 
1969     function _notImplemented() internal pure {
1970         revert("Cannot be run on this layer");
1971     }
1972 
1973     // ========== MODIFIERS ==========
1974 
1975     modifier systemActive() {
1976         _systemActive();
1977         _;
1978     }
1979 
1980     function _systemActive() private view {
1981         systemStatus().requireSystemActive();
1982     }
1983 
1984     modifier issuanceActive() {
1985         _issuanceActive();
1986         _;
1987     }
1988 
1989     function _issuanceActive() private view {
1990         systemStatus().requireIssuanceActive();
1991     }
1992 
1993     modifier exchangeActive(bytes32 src, bytes32 dest) {
1994         _exchangeActive(src, dest);
1995         _;
1996     }
1997 
1998     function _exchangeActive(bytes32 src, bytes32 dest) private view {
1999         systemStatus().requireExchangeBetweenSynthsAllowed(src, dest);
2000     }
2001 
2002     modifier onlyExchanger() {
2003         _onlyExchanger();
2004         _;
2005     }
2006 
2007     function _onlyExchanger() private view {
2008         require(msg.sender == address(exchanger()), "Only Exchanger can invoke this");
2009     }
2010 
2011     // ========== EVENTS ==========
2012     event AccountLiquidated(address indexed account, uint snxRedeemed, uint amountLiquidated, address liquidator);
2013     bytes32 internal constant ACCOUNTLIQUIDATED_SIG = keccak256("AccountLiquidated(address,uint256,uint256,address)");
2014 
2015     function emitAccountLiquidated(
2016         address account,
2017         uint256 snxRedeemed,
2018         uint256 amountLiquidated,
2019         address liquidator
2020     ) internal {
2021         proxy._emit(
2022             abi.encode(snxRedeemed, amountLiquidated, liquidator),
2023             2,
2024             ACCOUNTLIQUIDATED_SIG,
2025             addressToBytes32(account),
2026             0,
2027             0
2028         );
2029     }
2030 
2031     event SynthExchange(
2032         address indexed account,
2033         bytes32 fromCurrencyKey,
2034         uint256 fromAmount,
2035         bytes32 toCurrencyKey,
2036         uint256 toAmount,
2037         address toAddress
2038     );
2039     bytes32 internal constant SYNTH_EXCHANGE_SIG =
2040         keccak256("SynthExchange(address,bytes32,uint256,bytes32,uint256,address)");
2041 
2042     function emitSynthExchange(
2043         address account,
2044         bytes32 fromCurrencyKey,
2045         uint256 fromAmount,
2046         bytes32 toCurrencyKey,
2047         uint256 toAmount,
2048         address toAddress
2049     ) external onlyExchanger {
2050         proxy._emit(
2051             abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress),
2052             2,
2053             SYNTH_EXCHANGE_SIG,
2054             addressToBytes32(account),
2055             0,
2056             0
2057         );
2058     }
2059 
2060     event ExchangeTracking(bytes32 indexed trackingCode, bytes32 toCurrencyKey, uint256 toAmount, uint256 fee);
2061     bytes32 internal constant EXCHANGE_TRACKING_SIG = keccak256("ExchangeTracking(bytes32,bytes32,uint256,uint256)");
2062 
2063     function emitExchangeTracking(
2064         bytes32 trackingCode,
2065         bytes32 toCurrencyKey,
2066         uint256 toAmount,
2067         uint256 fee
2068     ) external onlyExchanger {
2069         proxy._emit(abi.encode(toCurrencyKey, toAmount, fee), 2, EXCHANGE_TRACKING_SIG, trackingCode, 0, 0);
2070     }
2071 
2072     event ExchangeReclaim(address indexed account, bytes32 currencyKey, uint amount);
2073     bytes32 internal constant EXCHANGERECLAIM_SIG = keccak256("ExchangeReclaim(address,bytes32,uint256)");
2074 
2075     function emitExchangeReclaim(
2076         address account,
2077         bytes32 currencyKey,
2078         uint256 amount
2079     ) external onlyExchanger {
2080         proxy._emit(abi.encode(currencyKey, amount), 2, EXCHANGERECLAIM_SIG, addressToBytes32(account), 0, 0);
2081     }
2082 
2083     event ExchangeRebate(address indexed account, bytes32 currencyKey, uint amount);
2084     bytes32 internal constant EXCHANGEREBATE_SIG = keccak256("ExchangeRebate(address,bytes32,uint256)");
2085 
2086     function emitExchangeRebate(
2087         address account,
2088         bytes32 currencyKey,
2089         uint256 amount
2090     ) external onlyExchanger {
2091         proxy._emit(abi.encode(currencyKey, amount), 2, EXCHANGEREBATE_SIG, addressToBytes32(account), 0, 0);
2092     }
2093 }
2094 
2095 
2096 // https://docs.synthetix.io/contracts/source/interfaces/irewardescrow
2097 interface IRewardEscrow {
2098     // Views
2099     function balanceOf(address account) external view returns (uint);
2100 
2101     function numVestingEntries(address account) external view returns (uint);
2102 
2103     function totalEscrowedAccountBalance(address account) external view returns (uint);
2104 
2105     function totalVestedAccountBalance(address account) external view returns (uint);
2106 
2107     function getVestingScheduleEntry(address account, uint index) external view returns (uint[2] memory);
2108 
2109     function getNextVestingIndex(address account) external view returns (uint);
2110 
2111     // Mutative functions
2112     function appendVestingEntry(address account, uint quantity) external;
2113 
2114     function vest() external;
2115 }
2116 
2117 
2118 pragma experimental ABIEncoderV2;
2119 
2120 library VestingEntries {
2121     struct VestingEntry {
2122         uint64 endTime;
2123         uint256 escrowAmount;
2124     }
2125     struct VestingEntryWithID {
2126         uint64 endTime;
2127         uint256 escrowAmount;
2128         uint256 entryID;
2129     }
2130 }
2131 
2132 interface IRewardEscrowV2 {
2133     // Views
2134     function balanceOf(address account) external view returns (uint);
2135 
2136     function numVestingEntries(address account) external view returns (uint);
2137 
2138     function totalEscrowedAccountBalance(address account) external view returns (uint);
2139 
2140     function totalVestedAccountBalance(address account) external view returns (uint);
2141 
2142     function getVestingQuantity(address account, uint256[] calldata entryIDs) external view returns (uint);
2143 
2144     function getVestingSchedules(
2145         address account,
2146         uint256 index,
2147         uint256 pageSize
2148     ) external view returns (VestingEntries.VestingEntryWithID[] memory);
2149 
2150     function getAccountVestingEntryIDs(
2151         address account,
2152         uint256 index,
2153         uint256 pageSize
2154     ) external view returns (uint256[] memory);
2155 
2156     function getVestingEntryClaimable(address account, uint256 entryID) external view returns (uint);
2157 
2158     function getVestingEntry(address account, uint256 entryID) external view returns (uint64, uint256);
2159 
2160     // Mutative functions
2161     function vest(uint256[] calldata entryIDs) external;
2162 
2163     function createEscrowEntry(
2164         address beneficiary,
2165         uint256 deposit,
2166         uint256 duration
2167     ) external;
2168 
2169     function appendVestingEntry(
2170         address account,
2171         uint256 quantity,
2172         uint256 duration
2173     ) external;
2174 
2175     function migrateVestingSchedule(address _addressToMigrate) external;
2176 
2177     function migrateAccountEscrowBalances(
2178         address[] calldata accounts,
2179         uint256[] calldata escrowBalances,
2180         uint256[] calldata vestedBalances
2181     ) external;
2182 
2183     // Account Merging
2184     function startMergingWindow() external;
2185 
2186     function mergeAccount(address accountToMerge, uint256[] calldata entryIDs) external;
2187 
2188     function nominateAccountToMerge(address account) external;
2189 
2190     function accountMergingIsOpen() external view returns (bool);
2191 
2192     // L2 Migration
2193     function importVestingEntries(
2194         address account,
2195         uint256 escrowedAmount,
2196         VestingEntries.VestingEntry[] calldata vestingEntries
2197     ) external;
2198 
2199     // Return amount of SNX transfered to SynthetixBridgeToOptimism deposit contract
2200     function burnForMigration(address account, uint256[] calldata entryIDs)
2201         external
2202         returns (uint256 escrowedAccountBalance, VestingEntries.VestingEntry[] memory vestingEntries);
2203 }
2204 
2205 
2206 // https://docs.synthetix.io/contracts/source/interfaces/isupplyschedule
2207 interface ISupplySchedule {
2208     // Views
2209     function mintableSupply() external view returns (uint);
2210 
2211     function isMintable() external view returns (bool);
2212 
2213     function minterReward() external view returns (uint);
2214 
2215     // Mutative functions
2216     function recordMintEvent(uint supplyMinted) external returns (uint);
2217 }
2218 
2219 
2220 // Inheritance
2221 
2222 
2223 // Internal references
2224 
2225 
2226 // https://docs.synthetix.io/contracts/source/contracts/synthetix
2227 contract Synthetix is BaseSynthetix {
2228     bytes32 public constant CONTRACT_NAME = "Synthetix";
2229 
2230     // ========== ADDRESS RESOLVER CONFIGURATION ==========
2231     bytes32 private constant CONTRACT_REWARD_ESCROW = "RewardEscrow";
2232     bytes32 private constant CONTRACT_REWARDESCROW_V2 = "RewardEscrowV2";
2233     bytes32 private constant CONTRACT_SUPPLYSCHEDULE = "SupplySchedule";
2234 
2235     // ========== CONSTRUCTOR ==========
2236 
2237     constructor(
2238         address payable _proxy,
2239         TokenState _tokenState,
2240         address _owner,
2241         uint _totalSupply,
2242         address _resolver
2243     ) public BaseSynthetix(_proxy, _tokenState, _owner, _totalSupply, _resolver) {}
2244 
2245     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
2246         bytes32[] memory existingAddresses = BaseSynthetix.resolverAddressesRequired();
2247         bytes32[] memory newAddresses = new bytes32[](3);
2248         newAddresses[0] = CONTRACT_REWARD_ESCROW;
2249         newAddresses[1] = CONTRACT_REWARDESCROW_V2;
2250         newAddresses[2] = CONTRACT_SUPPLYSCHEDULE;
2251         return combineArrays(existingAddresses, newAddresses);
2252     }
2253 
2254     // ========== VIEWS ==========
2255 
2256     function rewardEscrow() internal view returns (IRewardEscrow) {
2257         return IRewardEscrow(requireAndGetAddress(CONTRACT_REWARD_ESCROW));
2258     }
2259 
2260     function rewardEscrowV2() internal view returns (IRewardEscrowV2) {
2261         return IRewardEscrowV2(requireAndGetAddress(CONTRACT_REWARDESCROW_V2));
2262     }
2263 
2264     function supplySchedule() internal view returns (ISupplySchedule) {
2265         return ISupplySchedule(requireAndGetAddress(CONTRACT_SUPPLYSCHEDULE));
2266     }
2267 
2268     // ========== OVERRIDDEN FUNCTIONS ==========
2269 
2270     function exchangeWithVirtual(
2271         bytes32 sourceCurrencyKey,
2272         uint sourceAmount,
2273         bytes32 destinationCurrencyKey,
2274         bytes32 trackingCode
2275     )
2276         external
2277         exchangeActive(sourceCurrencyKey, destinationCurrencyKey)
2278         optionalProxy
2279         returns (uint amountReceived, IVirtualSynth vSynth)
2280     {
2281         return
2282             exchanger().exchange(
2283                 messageSender,
2284                 messageSender,
2285                 sourceCurrencyKey,
2286                 sourceAmount,
2287                 destinationCurrencyKey,
2288                 messageSender,
2289                 true,
2290                 messageSender,
2291                 trackingCode
2292             );
2293     }
2294 
2295     // SIP-140 The initiating user of this exchange will receive the proceeds of the exchange
2296     // Note: this function may have unintended consequences if not understood correctly. Please
2297     // read SIP-140 for more information on the use-case
2298     function exchangeWithTrackingForInitiator(
2299         bytes32 sourceCurrencyKey,
2300         uint sourceAmount,
2301         bytes32 destinationCurrencyKey,
2302         address rewardAddress,
2303         bytes32 trackingCode
2304     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
2305         (amountReceived, ) = exchanger().exchange(
2306             messageSender,
2307             messageSender,
2308             sourceCurrencyKey,
2309             sourceAmount,
2310             destinationCurrencyKey,
2311             // solhint-disable avoid-tx-origin
2312             tx.origin,
2313             false,
2314             rewardAddress,
2315             trackingCode
2316         );
2317     }
2318 
2319     function exchangeAtomically(
2320         bytes32 sourceCurrencyKey,
2321         uint sourceAmount,
2322         bytes32 destinationCurrencyKey,
2323         bytes32 trackingCode,
2324         uint minAmount
2325     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
2326         return
2327             exchanger().exchangeAtomically(
2328                 messageSender,
2329                 sourceCurrencyKey,
2330                 sourceAmount,
2331                 destinationCurrencyKey,
2332                 messageSender,
2333                 trackingCode,
2334                 minAmount
2335             );
2336     }
2337 
2338     function settle(bytes32 currencyKey)
2339         external
2340         optionalProxy
2341         returns (
2342             uint reclaimed,
2343             uint refunded,
2344             uint numEntriesSettled
2345         )
2346     {
2347         return exchanger().settle(messageSender, currencyKey);
2348     }
2349 
2350     function mint() external issuanceActive returns (bool) {
2351         require(address(rewardsDistribution()) != address(0), "RewardsDistribution not set");
2352 
2353         ISupplySchedule _supplySchedule = supplySchedule();
2354         IRewardsDistribution _rewardsDistribution = rewardsDistribution();
2355 
2356         uint supplyToMint = _supplySchedule.mintableSupply();
2357         require(supplyToMint > 0, "No supply is mintable");
2358 
2359         emitTransfer(address(0), address(this), supplyToMint);
2360 
2361         // record minting event before mutation to token supply
2362         uint minterReward = _supplySchedule.recordMintEvent(supplyToMint);
2363 
2364         // Set minted SNX balance to RewardEscrow's balance
2365         // Minus the minterReward and set balance of minter to add reward
2366         uint amountToDistribute = supplyToMint.sub(minterReward);
2367 
2368         // Set the token balance to the RewardsDistribution contract
2369         tokenState.setBalanceOf(
2370             address(_rewardsDistribution),
2371             tokenState.balanceOf(address(_rewardsDistribution)).add(amountToDistribute)
2372         );
2373         emitTransfer(address(this), address(_rewardsDistribution), amountToDistribute);
2374 
2375         // Kick off the distribution of rewards
2376         _rewardsDistribution.distributeRewards(amountToDistribute);
2377 
2378         // Assign the minters reward.
2379         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
2380         emitTransfer(address(this), msg.sender, minterReward);
2381 
2382         // Increase total supply by minted amount
2383         totalSupply = totalSupply.add(supplyToMint);
2384 
2385         return true;
2386     }
2387 
2388     /* Once off function for SIP-60 to migrate SNX balances in the RewardEscrow contract
2389      * To the new RewardEscrowV2 contract
2390      */
2391     function migrateEscrowBalanceToRewardEscrowV2() external onlyOwner {
2392         // Record balanceOf(RewardEscrow) contract
2393         uint rewardEscrowBalance = tokenState.balanceOf(address(rewardEscrow()));
2394 
2395         // transfer all of RewardEscrow's balance to RewardEscrowV2
2396         // _internalTransfer emits the transfer event
2397         _internalTransfer(address(rewardEscrow()), address(rewardEscrowV2()), rewardEscrowBalance);
2398     }
2399 
2400     // ========== EVENTS ==========
2401 
2402     event AtomicSynthExchange(
2403         address indexed account,
2404         bytes32 fromCurrencyKey,
2405         uint256 fromAmount,
2406         bytes32 toCurrencyKey,
2407         uint256 toAmount,
2408         address toAddress
2409     );
2410     bytes32 internal constant ATOMIC_SYNTH_EXCHANGE_SIG =
2411         keccak256("AtomicSynthExchange(address,bytes32,uint256,bytes32,uint256,address)");
2412 
2413     function emitAtomicSynthExchange(
2414         address account,
2415         bytes32 fromCurrencyKey,
2416         uint256 fromAmount,
2417         bytes32 toCurrencyKey,
2418         uint256 toAmount,
2419         address toAddress
2420     ) external onlyExchanger {
2421         proxy._emit(
2422             abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress),
2423             2,
2424             ATOMIC_SYNTH_EXCHANGE_SIG,
2425             addressToBytes32(account),
2426             0,
2427             0
2428         );
2429     }
2430 }
2431 
2432     