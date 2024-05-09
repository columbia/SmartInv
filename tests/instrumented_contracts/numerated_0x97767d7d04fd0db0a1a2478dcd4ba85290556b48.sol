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
42 * Copyright (c) 2021 Synthetix
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
66 
67 // https://docs.synthetix.io/contracts/source/interfaces/ierc20
68 interface IERC20 {
69     // ERC20 Optional Views
70     function name() external view returns (string memory);
71 
72     function symbol() external view returns (string memory);
73 
74     function decimals() external view returns (uint8);
75 
76     // Views
77     function totalSupply() external view returns (uint);
78 
79     function balanceOf(address owner) external view returns (uint);
80 
81     function allowance(address owner, address spender) external view returns (uint);
82 
83     // Mutative functions
84     function transfer(address to, uint value) external returns (bool);
85 
86     function approve(address spender, uint value) external returns (bool);
87 
88     function transferFrom(
89         address from,
90         address to,
91         uint value
92     ) external returns (bool);
93 
94     // Events
95     event Transfer(address indexed from, address indexed to, uint value);
96 
97     event Approval(address indexed owner, address indexed spender, uint value);
98 }
99 
100 
101 // https://docs.synthetix.io/contracts/source/contracts/owned
102 contract Owned {
103     address public owner;
104     address public nominatedOwner;
105 
106     constructor(address _owner) public {
107         require(_owner != address(0), "Owner address cannot be 0");
108         owner = _owner;
109         emit OwnerChanged(address(0), _owner);
110     }
111 
112     function nominateNewOwner(address _owner) external onlyOwner {
113         nominatedOwner = _owner;
114         emit OwnerNominated(_owner);
115     }
116 
117     function acceptOwnership() external {
118         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
119         emit OwnerChanged(owner, nominatedOwner);
120         owner = nominatedOwner;
121         nominatedOwner = address(0);
122     }
123 
124     modifier onlyOwner {
125         _onlyOwner();
126         _;
127     }
128 
129     function _onlyOwner() private view {
130         require(msg.sender == owner, "Only the contract owner may perform this action");
131     }
132 
133     event OwnerNominated(address newOwner);
134     event OwnerChanged(address oldOwner, address newOwner);
135 }
136 
137 
138 // Inheritance
139 
140 
141 // Internal references
142 
143 
144 // https://docs.synthetix.io/contracts/source/contracts/proxy
145 contract Proxy is Owned {
146     Proxyable public target;
147 
148     constructor(address _owner) public Owned(_owner) {}
149 
150     function setTarget(Proxyable _target) external onlyOwner {
151         target = _target;
152         emit TargetUpdated(_target);
153     }
154 
155     function _emit(
156         bytes calldata callData,
157         uint numTopics,
158         bytes32 topic1,
159         bytes32 topic2,
160         bytes32 topic3,
161         bytes32 topic4
162     ) external onlyTarget {
163         uint size = callData.length;
164         bytes memory _callData = callData;
165 
166         assembly {
167             /* The first 32 bytes of callData contain its length (as specified by the abi).
168              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
169              * in length. It is also leftpadded to be a multiple of 32 bytes.
170              * This means moving call_data across 32 bytes guarantees we correctly access
171              * the data itself. */
172             switch numTopics
173                 case 0 {
174                     log0(add(_callData, 32), size)
175                 }
176                 case 1 {
177                     log1(add(_callData, 32), size, topic1)
178                 }
179                 case 2 {
180                     log2(add(_callData, 32), size, topic1, topic2)
181                 }
182                 case 3 {
183                     log3(add(_callData, 32), size, topic1, topic2, topic3)
184                 }
185                 case 4 {
186                     log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
187                 }
188         }
189     }
190 
191     // solhint-disable no-complex-fallback
192     function() external payable {
193         // Mutable call setting Proxyable.messageSender as this is using call not delegatecall
194         target.setMessageSender(msg.sender);
195 
196         assembly {
197             let free_ptr := mload(0x40)
198             calldatacopy(free_ptr, 0, calldatasize)
199 
200             /* We must explicitly forward ether to the underlying contract as well. */
201             let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
202             returndatacopy(free_ptr, 0, returndatasize)
203 
204             if iszero(result) {
205                 revert(free_ptr, returndatasize)
206             }
207             return(free_ptr, returndatasize)
208         }
209     }
210 
211     modifier onlyTarget {
212         require(Proxyable(msg.sender) == target, "Must be proxy target");
213         _;
214     }
215 
216     event TargetUpdated(Proxyable newTarget);
217 }
218 
219 
220 // Inheritance
221 
222 
223 // Internal references
224 
225 
226 // https://docs.synthetix.io/contracts/source/contracts/proxyable
227 contract Proxyable is Owned {
228     // This contract should be treated like an abstract contract
229 
230     /* The proxy this contract exists behind. */
231     Proxy public proxy;
232     Proxy public integrationProxy;
233 
234     /* The caller of the proxy, passed through to this contract.
235      * Note that every function using this member must apply the onlyProxy or
236      * optionalProxy modifiers, otherwise their invocations can use stale values. */
237     address public messageSender;
238 
239     constructor(address payable _proxy) internal {
240         // This contract is abstract, and thus cannot be instantiated directly
241         require(owner != address(0), "Owner must be set");
242 
243         proxy = Proxy(_proxy);
244         emit ProxyUpdated(_proxy);
245     }
246 
247     function setProxy(address payable _proxy) external onlyOwner {
248         proxy = Proxy(_proxy);
249         emit ProxyUpdated(_proxy);
250     }
251 
252     function setIntegrationProxy(address payable _integrationProxy) external onlyOwner {
253         integrationProxy = Proxy(_integrationProxy);
254     }
255 
256     function setMessageSender(address sender) external onlyProxy {
257         messageSender = sender;
258     }
259 
260     modifier onlyProxy {
261         _onlyProxy();
262         _;
263     }
264 
265     function _onlyProxy() private view {
266         require(Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy, "Only the proxy can call");
267     }
268 
269     modifier optionalProxy {
270         _optionalProxy();
271         _;
272     }
273 
274     function _optionalProxy() private {
275         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
276             messageSender = msg.sender;
277         }
278     }
279 
280     modifier optionalProxy_onlyOwner {
281         _optionalProxy_onlyOwner();
282         _;
283     }
284 
285     // solhint-disable-next-line func-name-mixedcase
286     function _optionalProxy_onlyOwner() private {
287         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy && messageSender != msg.sender) {
288             messageSender = msg.sender;
289         }
290         require(messageSender == owner, "Owner only function");
291     }
292 
293     event ProxyUpdated(address proxyAddress);
294 }
295 
296 
297 /**
298  * @dev Wrappers over Solidity's arithmetic operations with added overflow
299  * checks.
300  *
301  * Arithmetic operations in Solidity wrap on overflow. This can easily result
302  * in bugs, because programmers usually assume that an overflow raises an
303  * error, which is the standard behavior in high level programming languages.
304  * `SafeMath` restores this intuition by reverting the transaction when an
305  * operation overflows.
306  *
307  * Using this library instead of the unchecked operations eliminates an entire
308  * class of bugs, so it's recommended to use it always.
309  */
310 library SafeMath {
311     /**
312      * @dev Returns the addition of two unsigned integers, reverting on
313      * overflow.
314      *
315      * Counterpart to Solidity's `+` operator.
316      *
317      * Requirements:
318      * - Addition cannot overflow.
319      */
320     function add(uint256 a, uint256 b) internal pure returns (uint256) {
321         uint256 c = a + b;
322         require(c >= a, "SafeMath: addition overflow");
323 
324         return c;
325     }
326 
327     /**
328      * @dev Returns the subtraction of two unsigned integers, reverting on
329      * overflow (when the result is negative).
330      *
331      * Counterpart to Solidity's `-` operator.
332      *
333      * Requirements:
334      * - Subtraction cannot overflow.
335      */
336     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
337         require(b <= a, "SafeMath: subtraction overflow");
338         uint256 c = a - b;
339 
340         return c;
341     }
342 
343     /**
344      * @dev Returns the multiplication of two unsigned integers, reverting on
345      * overflow.
346      *
347      * Counterpart to Solidity's `*` operator.
348      *
349      * Requirements:
350      * - Multiplication cannot overflow.
351      */
352     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
353         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
354         // benefit is lost if 'b' is also tested.
355         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
356         if (a == 0) {
357             return 0;
358         }
359 
360         uint256 c = a * b;
361         require(c / a == b, "SafeMath: multiplication overflow");
362 
363         return c;
364     }
365 
366     /**
367      * @dev Returns the integer division of two unsigned integers. Reverts on
368      * division by zero. The result is rounded towards zero.
369      *
370      * Counterpart to Solidity's `/` operator. Note: this function uses a
371      * `revert` opcode (which leaves remaining gas untouched) while Solidity
372      * uses an invalid opcode to revert (consuming all remaining gas).
373      *
374      * Requirements:
375      * - The divisor cannot be zero.
376      */
377     function div(uint256 a, uint256 b) internal pure returns (uint256) {
378         // Solidity only automatically asserts when dividing by 0
379         require(b > 0, "SafeMath: division by zero");
380         uint256 c = a / b;
381         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
382 
383         return c;
384     }
385 
386     /**
387      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
388      * Reverts when dividing by zero.
389      *
390      * Counterpart to Solidity's `%` operator. This function uses a `revert`
391      * opcode (which leaves remaining gas untouched) while Solidity uses an
392      * invalid opcode to revert (consuming all remaining gas).
393      *
394      * Requirements:
395      * - The divisor cannot be zero.
396      */
397     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
398         require(b != 0, "SafeMath: modulo by zero");
399         return a % b;
400     }
401 }
402 
403 
404 // Libraries
405 
406 
407 // https://docs.synthetix.io/contracts/source/libraries/safedecimalmath
408 library SafeDecimalMath {
409     using SafeMath for uint;
410 
411     /* Number of decimal places in the representations. */
412     uint8 public constant decimals = 18;
413     uint8 public constant highPrecisionDecimals = 27;
414 
415     /* The number representing 1.0. */
416     uint public constant UNIT = 10**uint(decimals);
417 
418     /* The number representing 1.0 for higher fidelity numbers. */
419     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
420     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
421 
422     /**
423      * @return Provides an interface to UNIT.
424      */
425     function unit() external pure returns (uint) {
426         return UNIT;
427     }
428 
429     /**
430      * @return Provides an interface to PRECISE_UNIT.
431      */
432     function preciseUnit() external pure returns (uint) {
433         return PRECISE_UNIT;
434     }
435 
436     /**
437      * @return The result of multiplying x and y, interpreting the operands as fixed-point
438      * decimals.
439      *
440      * @dev A unit factor is divided out after the product of x and y is evaluated,
441      * so that product must be less than 2**256. As this is an integer division,
442      * the internal division always rounds down. This helps save on gas. Rounding
443      * is more expensive on gas.
444      */
445     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
446         /* Divide by UNIT to remove the extra factor introduced by the product. */
447         return x.mul(y) / UNIT;
448     }
449 
450     /**
451      * @return The result of safely multiplying x and y, interpreting the operands
452      * as fixed-point decimals of the specified precision unit.
453      *
454      * @dev The operands should be in the form of a the specified unit factor which will be
455      * divided out after the product of x and y is evaluated, so that product must be
456      * less than 2**256.
457      *
458      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
459      * Rounding is useful when you need to retain fidelity for small decimal numbers
460      * (eg. small fractions or percentages).
461      */
462     function _multiplyDecimalRound(
463         uint x,
464         uint y,
465         uint precisionUnit
466     ) private pure returns (uint) {
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
531     function _divideDecimalRound(
532         uint x,
533         uint y,
534         uint precisionUnit
535     ) private pure returns (uint) {
536         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
537 
538         if (resultTimesTen % 10 >= 5) {
539             resultTimesTen += 10;
540         }
541 
542         return resultTimesTen / 10;
543     }
544 
545     /**
546      * @return The result of safely dividing x and y. The return value is as a rounded
547      * standard precision decimal.
548      *
549      * @dev y is divided after the product of x and the standard precision unit
550      * is evaluated, so the product of x and the standard precision unit must
551      * be less than 2**256. The result is rounded to the nearest increment.
552      */
553     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
554         return _divideDecimalRound(x, y, UNIT);
555     }
556 
557     /**
558      * @return The result of safely dividing x and y. The return value is as a rounded
559      * high precision decimal.
560      *
561      * @dev y is divided after the product of x and the high precision unit
562      * is evaluated, so the product of x and the high precision unit must
563      * be less than 2**256. The result is rounded to the nearest increment.
564      */
565     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
566         return _divideDecimalRound(x, y, PRECISE_UNIT);
567     }
568 
569     /**
570      * @dev Convert a standard decimal representation to a high precision one.
571      */
572     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
573         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
574     }
575 
576     /**
577      * @dev Convert a high precision decimal to a standard decimal representation.
578      */
579     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
580         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
581 
582         if (quotientTimesTen % 10 >= 5) {
583             quotientTimesTen += 10;
584         }
585 
586         return quotientTimesTen / 10;
587     }
588 }
589 
590 
591 // Inheritance
592 
593 
594 // https://docs.synthetix.io/contracts/source/contracts/state
595 contract State is Owned {
596     // the address of the contract that can modify variables
597     // this can only be changed by the owner of this contract
598     address public associatedContract;
599 
600     constructor(address _associatedContract) internal {
601         // This contract is abstract, and thus cannot be instantiated directly
602         require(owner != address(0), "Owner must be set");
603 
604         associatedContract = _associatedContract;
605         emit AssociatedContractUpdated(_associatedContract);
606     }
607 
608     /* ========== SETTERS ========== */
609 
610     // Change the associated contract to a new address
611     function setAssociatedContract(address _associatedContract) external onlyOwner {
612         associatedContract = _associatedContract;
613         emit AssociatedContractUpdated(_associatedContract);
614     }
615 
616     /* ========== MODIFIERS ========== */
617 
618     modifier onlyAssociatedContract {
619         require(msg.sender == associatedContract, "Only the associated contract can perform this action");
620         _;
621     }
622 
623     /* ========== EVENTS ========== */
624 
625     event AssociatedContractUpdated(address associatedContract);
626 }
627 
628 
629 // Inheritance
630 
631 
632 // https://docs.synthetix.io/contracts/source/contracts/tokenstate
633 contract TokenState is Owned, State {
634     /* ERC20 fields. */
635     mapping(address => uint) public balanceOf;
636     mapping(address => mapping(address => uint)) public allowance;
637 
638     constructor(address _owner, address _associatedContract) public Owned(_owner) State(_associatedContract) {}
639 
640     /* ========== SETTERS ========== */
641 
642     /**
643      * @notice Set ERC20 allowance.
644      * @dev Only the associated contract may call this.
645      * @param tokenOwner The authorising party.
646      * @param spender The authorised party.
647      * @param value The total value the authorised party may spend on the
648      * authorising party's behalf.
649      */
650     function setAllowance(
651         address tokenOwner,
652         address spender,
653         uint value
654     ) external onlyAssociatedContract {
655         allowance[tokenOwner][spender] = value;
656     }
657 
658     /**
659      * @notice Set the balance in a given account
660      * @dev Only the associated contract may call this.
661      * @param account The account whose value to set.
662      * @param value The new balance of the given account.
663      */
664     function setBalanceOf(address account, uint value) external onlyAssociatedContract {
665         balanceOf[account] = value;
666     }
667 }
668 
669 
670 // Inheritance
671 
672 
673 // Libraries
674 
675 
676 // Internal references
677 
678 
679 // https://docs.synthetix.io/contracts/source/contracts/externstatetoken
680 contract ExternStateToken is Owned, Proxyable {
681     using SafeMath for uint;
682     using SafeDecimalMath for uint;
683 
684     /* ========== STATE VARIABLES ========== */
685 
686     /* Stores balances and allowances. */
687     TokenState public tokenState;
688 
689     /* Other ERC20 fields. */
690     string public name;
691     string public symbol;
692     uint public totalSupply;
693     uint8 public decimals;
694 
695     constructor(
696         address payable _proxy,
697         TokenState _tokenState,
698         string memory _name,
699         string memory _symbol,
700         uint _totalSupply,
701         uint8 _decimals,
702         address _owner
703     ) public Owned(_owner) Proxyable(_proxy) {
704         tokenState = _tokenState;
705 
706         name = _name;
707         symbol = _symbol;
708         totalSupply = _totalSupply;
709         decimals = _decimals;
710     }
711 
712     /* ========== VIEWS ========== */
713 
714     /**
715      * @notice Returns the ERC20 allowance of one party to spend on behalf of another.
716      * @param owner The party authorising spending of their funds.
717      * @param spender The party spending tokenOwner's funds.
718      */
719     function allowance(address owner, address spender) public view returns (uint) {
720         return tokenState.allowance(owner, spender);
721     }
722 
723     /**
724      * @notice Returns the ERC20 token balance of a given account.
725      */
726     function balanceOf(address account) external view returns (uint) {
727         return tokenState.balanceOf(account);
728     }
729 
730     /* ========== MUTATIVE FUNCTIONS ========== */
731 
732     /**
733      * @notice Set the address of the TokenState contract.
734      * @dev This can be used to "pause" transfer functionality, by pointing the tokenState at 0x000..
735      * as balances would be unreachable.
736      */
737     function setTokenState(TokenState _tokenState) external optionalProxy_onlyOwner {
738         tokenState = _tokenState;
739         emitTokenStateUpdated(address(_tokenState));
740     }
741 
742     function _internalTransfer(
743         address from,
744         address to,
745         uint value
746     ) internal returns (bool) {
747         /* Disallow transfers to irretrievable-addresses. */
748         require(to != address(0) && to != address(this) && to != address(proxy), "Cannot transfer to this address");
749 
750         // Insufficient balance will be handled by the safe subtraction.
751         tokenState.setBalanceOf(from, tokenState.balanceOf(from).sub(value));
752         tokenState.setBalanceOf(to, tokenState.balanceOf(to).add(value));
753 
754         // Emit a standard ERC20 transfer event
755         emitTransfer(from, to, value);
756 
757         return true;
758     }
759 
760     /**
761      * @dev Perform an ERC20 token transfer. Designed to be called by transfer functions possessing
762      * the onlyProxy or optionalProxy modifiers.
763      */
764     function _transferByProxy(
765         address from,
766         address to,
767         uint value
768     ) internal returns (bool) {
769         return _internalTransfer(from, to, value);
770     }
771 
772     /*
773      * @dev Perform an ERC20 token transferFrom. Designed to be called by transferFrom functions
774      * possessing the optionalProxy or optionalProxy modifiers.
775      */
776     function _transferFromByProxy(
777         address sender,
778         address from,
779         address to,
780         uint value
781     ) internal returns (bool) {
782         /* Insufficient allowance will be handled by the safe subtraction. */
783         tokenState.setAllowance(from, sender, tokenState.allowance(from, sender).sub(value));
784         return _internalTransfer(from, to, value);
785     }
786 
787     /**
788      * @notice Approves spender to transfer on the message sender's behalf.
789      */
790     function approve(address spender, uint value) public optionalProxy returns (bool) {
791         address sender = messageSender;
792 
793         tokenState.setAllowance(sender, spender, value);
794         emitApproval(sender, spender, value);
795         return true;
796     }
797 
798     /* ========== EVENTS ========== */
799     function addressToBytes32(address input) internal pure returns (bytes32) {
800         return bytes32(uint256(uint160(input)));
801     }
802 
803     event Transfer(address indexed from, address indexed to, uint value);
804     bytes32 internal constant TRANSFER_SIG = keccak256("Transfer(address,address,uint256)");
805 
806     function emitTransfer(
807         address from,
808         address to,
809         uint value
810     ) internal {
811         proxy._emit(abi.encode(value), 3, TRANSFER_SIG, addressToBytes32(from), addressToBytes32(to), 0);
812     }
813 
814     event Approval(address indexed owner, address indexed spender, uint value);
815     bytes32 internal constant APPROVAL_SIG = keccak256("Approval(address,address,uint256)");
816 
817     function emitApproval(
818         address owner,
819         address spender,
820         uint value
821     ) internal {
822         proxy._emit(abi.encode(value), 3, APPROVAL_SIG, addressToBytes32(owner), addressToBytes32(spender), 0);
823     }
824 
825     event TokenStateUpdated(address newTokenState);
826     bytes32 internal constant TOKENSTATEUPDATED_SIG = keccak256("TokenStateUpdated(address)");
827 
828     function emitTokenStateUpdated(address newTokenState) internal {
829         proxy._emit(abi.encode(newTokenState), 1, TOKENSTATEUPDATED_SIG, 0, 0, 0);
830     }
831 }
832 
833 
834 // https://docs.synthetix.io/contracts/source/interfaces/iaddressresolver
835 interface IAddressResolver {
836     function getAddress(bytes32 name) external view returns (address);
837 
838     function getSynth(bytes32 key) external view returns (address);
839 
840     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address);
841 }
842 
843 
844 // https://docs.synthetix.io/contracts/source/interfaces/isynth
845 interface ISynth {
846     // Views
847     function currencyKey() external view returns (bytes32);
848 
849     function transferableSynths(address account) external view returns (uint);
850 
851     // Mutative functions
852     function transferAndSettle(address to, uint value) external returns (bool);
853 
854     function transferFromAndSettle(
855         address from,
856         address to,
857         uint value
858     ) external returns (bool);
859 
860     // Restricted: used internally to Synthetix
861     function burn(address account, uint amount) external;
862 
863     function issue(address account, uint amount) external;
864 }
865 
866 
867 // https://docs.synthetix.io/contracts/source/interfaces/iissuer
868 interface IIssuer {
869     // Views
870     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
871 
872     function availableCurrencyKeys() external view returns (bytes32[] memory);
873 
874     function availableSynthCount() external view returns (uint);
875 
876     function availableSynths(uint index) external view returns (ISynth);
877 
878     function canBurnSynths(address account) external view returns (bool);
879 
880     function collateral(address account) external view returns (uint);
881 
882     function collateralisationRatio(address issuer) external view returns (uint);
883 
884     function collateralisationRatioAndAnyRatesInvalid(address _issuer)
885         external
886         view
887         returns (uint cratio, bool anyRateIsInvalid);
888 
889     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint debtBalance);
890 
891     function issuanceRatio() external view returns (uint);
892 
893     function lastIssueEvent(address account) external view returns (uint);
894 
895     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
896 
897     function minimumStakeTime() external view returns (uint);
898 
899     function remainingIssuableSynths(address issuer)
900         external
901         view
902         returns (
903             uint maxIssuable,
904             uint alreadyIssued,
905             uint totalSystemDebt
906         );
907 
908     function synths(bytes32 currencyKey) external view returns (ISynth);
909 
910     function getSynths(bytes32[] calldata currencyKeys) external view returns (ISynth[] memory);
911 
912     function synthsByAddress(address synthAddress) external view returns (bytes32);
913 
914     function totalIssuedSynths(bytes32 currencyKey, bool excludeEtherCollateral) external view returns (uint);
915 
916     function transferableSynthetixAndAnyRateIsInvalid(address account, uint balance)
917         external
918         view
919         returns (uint transferable, bool anyRateIsInvalid);
920 
921     // Restricted: used internally to Synthetix
922     function issueSynths(address from, uint amount) external;
923 
924     function issueSynthsOnBehalf(
925         address issueFor,
926         address from,
927         uint amount
928     ) external;
929 
930     function issueMaxSynths(address from) external;
931 
932     function issueMaxSynthsOnBehalf(address issueFor, address from) external;
933 
934     function burnSynths(address from, uint amount) external;
935 
936     function burnSynthsOnBehalf(
937         address burnForAddress,
938         address from,
939         uint amount
940     ) external;
941 
942     function burnSynthsToTarget(address from) external;
943 
944     function burnSynthsToTargetOnBehalf(address burnForAddress, address from) external;
945 
946     function liquidateDelinquentAccount(
947         address account,
948         uint susdAmount,
949         address liquidator
950     ) external returns (uint totalRedeemed, uint amountToLiquidate);
951 }
952 
953 
954 // Inheritance
955 
956 
957 // Internal references
958 
959 
960 // https://docs.synthetix.io/contracts/source/contracts/addressresolver
961 contract AddressResolver is Owned, IAddressResolver {
962     mapping(bytes32 => address) public repository;
963 
964     constructor(address _owner) public Owned(_owner) {}
965 
966     /* ========== RESTRICTED FUNCTIONS ========== */
967 
968     function importAddresses(bytes32[] calldata names, address[] calldata destinations) external onlyOwner {
969         require(names.length == destinations.length, "Input lengths must match");
970 
971         for (uint i = 0; i < names.length; i++) {
972             bytes32 name = names[i];
973             address destination = destinations[i];
974             repository[name] = destination;
975             emit AddressImported(name, destination);
976         }
977     }
978 
979     /* ========= PUBLIC FUNCTIONS ========== */
980 
981     function rebuildCaches(MixinResolver[] calldata destinations) external {
982         for (uint i = 0; i < destinations.length; i++) {
983             destinations[i].rebuildCache();
984         }
985     }
986 
987     /* ========== VIEWS ========== */
988 
989     function areAddressesImported(bytes32[] calldata names, address[] calldata destinations) external view returns (bool) {
990         for (uint i = 0; i < names.length; i++) {
991             if (repository[names[i]] != destinations[i]) {
992                 return false;
993             }
994         }
995         return true;
996     }
997 
998     function getAddress(bytes32 name) external view returns (address) {
999         return repository[name];
1000     }
1001 
1002     function requireAndGetAddress(bytes32 name, string calldata reason) external view returns (address) {
1003         address _foundAddress = repository[name];
1004         require(_foundAddress != address(0), reason);
1005         return _foundAddress;
1006     }
1007 
1008     function getSynth(bytes32 key) external view returns (address) {
1009         IIssuer issuer = IIssuer(repository["Issuer"]);
1010         require(address(issuer) != address(0), "Cannot find Issuer address");
1011         return address(issuer.synths(key));
1012     }
1013 
1014     /* ========== EVENTS ========== */
1015 
1016     event AddressImported(bytes32 name, address destination);
1017 }
1018 
1019 
1020 // solhint-disable payable-fallback
1021 
1022 // https://docs.synthetix.io/contracts/source/contracts/readproxy
1023 contract ReadProxy is Owned {
1024     address public target;
1025 
1026     constructor(address _owner) public Owned(_owner) {}
1027 
1028     function setTarget(address _target) external onlyOwner {
1029         target = _target;
1030         emit TargetUpdated(target);
1031     }
1032 
1033     function() external {
1034         // The basics of a proxy read call
1035         // Note that msg.sender in the underlying will always be the address of this contract.
1036         assembly {
1037             calldatacopy(0, 0, calldatasize)
1038 
1039             // Use of staticcall - this will revert if the underlying function mutates state
1040             let result := staticcall(gas, sload(target_slot), 0, calldatasize, 0, 0)
1041             returndatacopy(0, 0, returndatasize)
1042 
1043             if iszero(result) {
1044                 revert(0, returndatasize)
1045             }
1046             return(0, returndatasize)
1047         }
1048     }
1049 
1050     event TargetUpdated(address newTarget);
1051 }
1052 
1053 
1054 // Inheritance
1055 
1056 
1057 // Internal references
1058 
1059 
1060 // https://docs.synthetix.io/contracts/source/contracts/mixinresolver
1061 contract MixinResolver {
1062     AddressResolver public resolver;
1063 
1064     mapping(bytes32 => address) private addressCache;
1065 
1066     constructor(address _resolver) internal {
1067         resolver = AddressResolver(_resolver);
1068     }
1069 
1070     /* ========== INTERNAL FUNCTIONS ========== */
1071 
1072     function combineArrays(bytes32[] memory first, bytes32[] memory second)
1073         internal
1074         pure
1075         returns (bytes32[] memory combination)
1076     {
1077         combination = new bytes32[](first.length + second.length);
1078 
1079         for (uint i = 0; i < first.length; i++) {
1080             combination[i] = first[i];
1081         }
1082 
1083         for (uint j = 0; j < second.length; j++) {
1084             combination[first.length + j] = second[j];
1085         }
1086     }
1087 
1088     /* ========== PUBLIC FUNCTIONS ========== */
1089 
1090     // Note: this function is public not external in order for it to be overridden and invoked via super in subclasses
1091     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {}
1092 
1093     function rebuildCache() public {
1094         bytes32[] memory requiredAddresses = resolverAddressesRequired();
1095         // The resolver must call this function whenver it updates its state
1096         for (uint i = 0; i < requiredAddresses.length; i++) {
1097             bytes32 name = requiredAddresses[i];
1098             // Note: can only be invoked once the resolver has all the targets needed added
1099             address destination = resolver.requireAndGetAddress(
1100                 name,
1101                 string(abi.encodePacked("Resolver missing target: ", name))
1102             );
1103             addressCache[name] = destination;
1104             emit CacheUpdated(name, destination);
1105         }
1106     }
1107 
1108     /* ========== VIEWS ========== */
1109 
1110     function isResolverCached() external view returns (bool) {
1111         bytes32[] memory requiredAddresses = resolverAddressesRequired();
1112         for (uint i = 0; i < requiredAddresses.length; i++) {
1113             bytes32 name = requiredAddresses[i];
1114             // false if our cache is invalid or if the resolver doesn't have the required address
1115             if (resolver.getAddress(name) != addressCache[name] || addressCache[name] == address(0)) {
1116                 return false;
1117             }
1118         }
1119 
1120         return true;
1121     }
1122 
1123     /* ========== INTERNAL FUNCTIONS ========== */
1124 
1125     function requireAndGetAddress(bytes32 name) internal view returns (address) {
1126         address _foundAddress = addressCache[name];
1127         require(_foundAddress != address(0), string(abi.encodePacked("Missing address: ", name)));
1128         return _foundAddress;
1129     }
1130 
1131     /* ========== EVENTS ========== */
1132 
1133     event CacheUpdated(bytes32 name, address destination);
1134 }
1135 
1136 
1137 interface IVirtualSynth {
1138     // Views
1139     function balanceOfUnderlying(address account) external view returns (uint);
1140 
1141     function rate() external view returns (uint);
1142 
1143     function readyToSettle() external view returns (bool);
1144 
1145     function secsLeftInWaitingPeriod() external view returns (uint);
1146 
1147     function settled() external view returns (bool);
1148 
1149     function synth() external view returns (ISynth);
1150 
1151     // Mutative functions
1152     function settle(address account) external;
1153 }
1154 
1155 
1156 // https://docs.synthetix.io/contracts/source/interfaces/isynthetix
1157 interface ISynthetix {
1158     // Views
1159     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid);
1160 
1161     function availableCurrencyKeys() external view returns (bytes32[] memory);
1162 
1163     function availableSynthCount() external view returns (uint);
1164 
1165     function availableSynths(uint index) external view returns (ISynth);
1166 
1167     function collateral(address account) external view returns (uint);
1168 
1169     function collateralisationRatio(address issuer) external view returns (uint);
1170 
1171     function debtBalanceOf(address issuer, bytes32 currencyKey) external view returns (uint);
1172 
1173     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool);
1174 
1175     function maxIssuableSynths(address issuer) external view returns (uint maxIssuable);
1176 
1177     function remainingIssuableSynths(address issuer)
1178         external
1179         view
1180         returns (
1181             uint maxIssuable,
1182             uint alreadyIssued,
1183             uint totalSystemDebt
1184         );
1185 
1186     function synths(bytes32 currencyKey) external view returns (ISynth);
1187 
1188     function synthsByAddress(address synthAddress) external view returns (bytes32);
1189 
1190     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint);
1191 
1192     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint);
1193 
1194     function transferableSynthetix(address account) external view returns (uint transferable);
1195 
1196     // Mutative Functions
1197     function burnSynths(uint amount) external;
1198 
1199     function burnSynthsOnBehalf(address burnForAddress, uint amount) external;
1200 
1201     function burnSynthsToTarget() external;
1202 
1203     function burnSynthsToTargetOnBehalf(address burnForAddress) external;
1204 
1205     function exchange(
1206         bytes32 sourceCurrencyKey,
1207         uint sourceAmount,
1208         bytes32 destinationCurrencyKey
1209     ) external returns (uint amountReceived);
1210 
1211     function exchangeOnBehalf(
1212         address exchangeForAddress,
1213         bytes32 sourceCurrencyKey,
1214         uint sourceAmount,
1215         bytes32 destinationCurrencyKey
1216     ) external returns (uint amountReceived);
1217 
1218     function exchangeWithTracking(
1219         bytes32 sourceCurrencyKey,
1220         uint sourceAmount,
1221         bytes32 destinationCurrencyKey,
1222         address originator,
1223         bytes32 trackingCode
1224     ) external returns (uint amountReceived);
1225 
1226     function exchangeOnBehalfWithTracking(
1227         address exchangeForAddress,
1228         bytes32 sourceCurrencyKey,
1229         uint sourceAmount,
1230         bytes32 destinationCurrencyKey,
1231         address originator,
1232         bytes32 trackingCode
1233     ) external returns (uint amountReceived);
1234 
1235     function exchangeWithVirtual(
1236         bytes32 sourceCurrencyKey,
1237         uint sourceAmount,
1238         bytes32 destinationCurrencyKey,
1239         bytes32 trackingCode
1240     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1241 
1242     function issueMaxSynths() external;
1243 
1244     function issueMaxSynthsOnBehalf(address issueForAddress) external;
1245 
1246     function issueSynths(uint amount) external;
1247 
1248     function issueSynthsOnBehalf(address issueForAddress, uint amount) external;
1249 
1250     function mint() external returns (bool);
1251 
1252     function settle(bytes32 currencyKey)
1253         external
1254         returns (
1255             uint reclaimed,
1256             uint refunded,
1257             uint numEntries
1258         );
1259 
1260     // Liquidations
1261     function liquidateDelinquentAccount(address account, uint susdAmount) external returns (bool);
1262 
1263     // Restricted Functions
1264 
1265     function mintSecondary(address account, uint amount) external;
1266 
1267     function mintSecondaryRewards(uint amount) external;
1268 
1269     function burnSecondary(address account, uint amount) external;
1270 }
1271 
1272 
1273 // https://docs.synthetix.io/contracts/source/interfaces/isynthetixstate
1274 interface ISynthetixState {
1275     // Views
1276     function debtLedger(uint index) external view returns (uint);
1277 
1278     function issuanceData(address account) external view returns (uint initialDebtOwnership, uint debtEntryIndex);
1279 
1280     function debtLedgerLength() external view returns (uint);
1281 
1282     function hasIssued(address account) external view returns (bool);
1283 
1284     function lastDebtLedgerEntry() external view returns (uint);
1285 
1286     // Mutative functions
1287     function incrementTotalIssuerCount() external;
1288 
1289     function decrementTotalIssuerCount() external;
1290 
1291     function setCurrentIssuanceData(address account, uint initialDebtOwnership) external;
1292 
1293     function appendDebtLedgerValue(uint value) external;
1294 
1295     function clearIssuanceData(address account) external;
1296 }
1297 
1298 
1299 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
1300 interface ISystemStatus {
1301     struct Status {
1302         bool canSuspend;
1303         bool canResume;
1304     }
1305 
1306     struct Suspension {
1307         bool suspended;
1308         // reason is an integer code,
1309         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
1310         uint248 reason;
1311     }
1312 
1313     // Views
1314     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
1315 
1316     function requireSystemActive() external view;
1317 
1318     function requireIssuanceActive() external view;
1319 
1320     function requireExchangeActive() external view;
1321 
1322     function requireExchangeBetweenSynthsAllowed(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1323 
1324     function requireSynthActive(bytes32 currencyKey) external view;
1325 
1326     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
1327 
1328     function systemSuspension() external view returns (bool suspended, uint248 reason);
1329 
1330     function issuanceSuspension() external view returns (bool suspended, uint248 reason);
1331 
1332     function exchangeSuspension() external view returns (bool suspended, uint248 reason);
1333 
1334     function synthExchangeSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1335 
1336     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
1337 
1338     function getSynthExchangeSuspensions(bytes32[] calldata synths)
1339         external
1340         view
1341         returns (bool[] memory exchangeSuspensions, uint256[] memory reasons);
1342 
1343     function getSynthSuspensions(bytes32[] calldata synths)
1344         external
1345         view
1346         returns (bool[] memory suspensions, uint256[] memory reasons);
1347 
1348     // Restricted functions
1349     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
1350 
1351     function updateAccessControl(
1352         bytes32 section,
1353         address account,
1354         bool canSuspend,
1355         bool canResume
1356     ) external;
1357 }
1358 
1359 
1360 // https://docs.synthetix.io/contracts/source/interfaces/iexchanger
1361 interface IExchanger {
1362     // Views
1363     function calculateAmountAfterSettlement(
1364         address from,
1365         bytes32 currencyKey,
1366         uint amount,
1367         uint refunded
1368     ) external view returns (uint amountAfterSettlement);
1369 
1370     function isSynthRateInvalid(bytes32 currencyKey) external view returns (bool);
1371 
1372     function maxSecsLeftInWaitingPeriod(address account, bytes32 currencyKey) external view returns (uint);
1373 
1374     function settlementOwing(address account, bytes32 currencyKey)
1375         external
1376         view
1377         returns (
1378             uint reclaimAmount,
1379             uint rebateAmount,
1380             uint numEntries
1381         );
1382 
1383     function hasWaitingPeriodOrSettlementOwing(address account, bytes32 currencyKey) external view returns (bool);
1384 
1385     function feeRateForExchange(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey)
1386         external
1387         view
1388         returns (uint exchangeFeeRate);
1389 
1390     function getAmountsForExchange(
1391         uint sourceAmount,
1392         bytes32 sourceCurrencyKey,
1393         bytes32 destinationCurrencyKey
1394     )
1395         external
1396         view
1397         returns (
1398             uint amountReceived,
1399             uint fee,
1400             uint exchangeFeeRate
1401         );
1402 
1403     function priceDeviationThresholdFactor() external view returns (uint);
1404 
1405     function waitingPeriodSecs() external view returns (uint);
1406 
1407     // Mutative functions
1408     function exchange(
1409         address from,
1410         bytes32 sourceCurrencyKey,
1411         uint sourceAmount,
1412         bytes32 destinationCurrencyKey,
1413         address destinationAddress
1414     ) external returns (uint amountReceived);
1415 
1416     function exchangeOnBehalf(
1417         address exchangeForAddress,
1418         address from,
1419         bytes32 sourceCurrencyKey,
1420         uint sourceAmount,
1421         bytes32 destinationCurrencyKey
1422     ) external returns (uint amountReceived);
1423 
1424     function exchangeWithTracking(
1425         address from,
1426         bytes32 sourceCurrencyKey,
1427         uint sourceAmount,
1428         bytes32 destinationCurrencyKey,
1429         address destinationAddress,
1430         address originator,
1431         bytes32 trackingCode
1432     ) external returns (uint amountReceived);
1433 
1434     function exchangeOnBehalfWithTracking(
1435         address exchangeForAddress,
1436         address from,
1437         bytes32 sourceCurrencyKey,
1438         uint sourceAmount,
1439         bytes32 destinationCurrencyKey,
1440         address originator,
1441         bytes32 trackingCode
1442     ) external returns (uint amountReceived);
1443 
1444     function exchangeWithVirtual(
1445         address from,
1446         bytes32 sourceCurrencyKey,
1447         uint sourceAmount,
1448         bytes32 destinationCurrencyKey,
1449         address destinationAddress,
1450         bytes32 trackingCode
1451     ) external returns (uint amountReceived, IVirtualSynth vSynth);
1452 
1453     function settle(address from, bytes32 currencyKey)
1454         external
1455         returns (
1456             uint reclaimed,
1457             uint refunded,
1458             uint numEntries
1459         );
1460 
1461     function setLastExchangeRateForSynth(bytes32 currencyKey, uint rate) external;
1462 
1463     function suspendSynthWithInvalidRate(bytes32 currencyKey) external;
1464 }
1465 
1466 
1467 // https://docs.synthetix.io/contracts/source/interfaces/irewardsdistribution
1468 interface IRewardsDistribution {
1469     // Structs
1470     struct DistributionData {
1471         address destination;
1472         uint amount;
1473     }
1474 
1475     // Views
1476     function authority() external view returns (address);
1477 
1478     function distributions(uint index) external view returns (address destination, uint amount); // DistributionData
1479 
1480     function distributionsLength() external view returns (uint);
1481 
1482     // Mutative Functions
1483     function distributeRewards(uint amount) external returns (bool);
1484 }
1485 
1486 
1487 // Inheritance
1488 
1489 
1490 // Internal references
1491 
1492 
1493 contract BaseSynthetix is IERC20, ExternStateToken, MixinResolver, ISynthetix {
1494     // ========== STATE VARIABLES ==========
1495 
1496     // Available Synths which can be used with the system
1497     string public constant TOKEN_NAME = "Synthetix Network Token";
1498     string public constant TOKEN_SYMBOL = "SNX";
1499     uint8 public constant DECIMALS = 18;
1500     bytes32 public constant sUSD = "sUSD";
1501 
1502     // ========== ADDRESS RESOLVER CONFIGURATION ==========
1503     bytes32 private constant CONTRACT_SYNTHETIXSTATE = "SynthetixState";
1504     bytes32 private constant CONTRACT_SYSTEMSTATUS = "SystemStatus";
1505     bytes32 private constant CONTRACT_EXCHANGER = "Exchanger";
1506     bytes32 private constant CONTRACT_ISSUER = "Issuer";
1507     bytes32 private constant CONTRACT_REWARDSDISTRIBUTION = "RewardsDistribution";
1508 
1509     // ========== CONSTRUCTOR ==========
1510 
1511     constructor(
1512         address payable _proxy,
1513         TokenState _tokenState,
1514         address _owner,
1515         uint _totalSupply,
1516         address _resolver
1517     )
1518         public
1519         ExternStateToken(_proxy, _tokenState, TOKEN_NAME, TOKEN_SYMBOL, _totalSupply, DECIMALS, _owner)
1520         MixinResolver(_resolver)
1521     {}
1522 
1523     // ========== VIEWS ==========
1524 
1525     // Note: use public visibility so that it can be invoked in a subclass
1526     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1527         addresses = new bytes32[](5);
1528         addresses[0] = CONTRACT_SYNTHETIXSTATE;
1529         addresses[1] = CONTRACT_SYSTEMSTATUS;
1530         addresses[2] = CONTRACT_EXCHANGER;
1531         addresses[3] = CONTRACT_ISSUER;
1532         addresses[4] = CONTRACT_REWARDSDISTRIBUTION;
1533     }
1534 
1535     function synthetixState() internal view returns (ISynthetixState) {
1536         return ISynthetixState(requireAndGetAddress(CONTRACT_SYNTHETIXSTATE));
1537     }
1538 
1539     function systemStatus() internal view returns (ISystemStatus) {
1540         return ISystemStatus(requireAndGetAddress(CONTRACT_SYSTEMSTATUS));
1541     }
1542 
1543     function exchanger() internal view returns (IExchanger) {
1544         return IExchanger(requireAndGetAddress(CONTRACT_EXCHANGER));
1545     }
1546 
1547     function issuer() internal view returns (IIssuer) {
1548         return IIssuer(requireAndGetAddress(CONTRACT_ISSUER));
1549     }
1550 
1551     function rewardsDistribution() internal view returns (IRewardsDistribution) {
1552         return IRewardsDistribution(requireAndGetAddress(CONTRACT_REWARDSDISTRIBUTION));
1553     }
1554 
1555     function debtBalanceOf(address account, bytes32 currencyKey) external view returns (uint) {
1556         return issuer().debtBalanceOf(account, currencyKey);
1557     }
1558 
1559     function totalIssuedSynths(bytes32 currencyKey) external view returns (uint) {
1560         return issuer().totalIssuedSynths(currencyKey, false);
1561     }
1562 
1563     function totalIssuedSynthsExcludeEtherCollateral(bytes32 currencyKey) external view returns (uint) {
1564         return issuer().totalIssuedSynths(currencyKey, true);
1565     }
1566 
1567     function availableCurrencyKeys() external view returns (bytes32[] memory) {
1568         return issuer().availableCurrencyKeys();
1569     }
1570 
1571     function availableSynthCount() external view returns (uint) {
1572         return issuer().availableSynthCount();
1573     }
1574 
1575     function availableSynths(uint index) external view returns (ISynth) {
1576         return issuer().availableSynths(index);
1577     }
1578 
1579     function synths(bytes32 currencyKey) external view returns (ISynth) {
1580         return issuer().synths(currencyKey);
1581     }
1582 
1583     function synthsByAddress(address synthAddress) external view returns (bytes32) {
1584         return issuer().synthsByAddress(synthAddress);
1585     }
1586 
1587     function isWaitingPeriod(bytes32 currencyKey) external view returns (bool) {
1588         return exchanger().maxSecsLeftInWaitingPeriod(messageSender, currencyKey) > 0;
1589     }
1590 
1591     function anySynthOrSNXRateIsInvalid() external view returns (bool anyRateInvalid) {
1592         return issuer().anySynthOrSNXRateIsInvalid();
1593     }
1594 
1595     function maxIssuableSynths(address account) external view returns (uint maxIssuable) {
1596         return issuer().maxIssuableSynths(account);
1597     }
1598 
1599     function remainingIssuableSynths(address account)
1600         external
1601         view
1602         returns (
1603             uint maxIssuable,
1604             uint alreadyIssued,
1605             uint totalSystemDebt
1606         )
1607     {
1608         return issuer().remainingIssuableSynths(account);
1609     }
1610 
1611     function collateralisationRatio(address _issuer) external view returns (uint) {
1612         return issuer().collateralisationRatio(_issuer);
1613     }
1614 
1615     function collateral(address account) external view returns (uint) {
1616         return issuer().collateral(account);
1617     }
1618 
1619     function transferableSynthetix(address account) external view returns (uint transferable) {
1620         (transferable, ) = issuer().transferableSynthetixAndAnyRateIsInvalid(account, tokenState.balanceOf(account));
1621     }
1622 
1623     function _canTransfer(address account, uint value) internal view returns (bool) {
1624         (uint initialDebtOwnership, ) = synthetixState().issuanceData(account);
1625 
1626         if (initialDebtOwnership > 0) {
1627             (uint transferable, bool anyRateIsInvalid) = issuer().transferableSynthetixAndAnyRateIsInvalid(
1628                 account,
1629                 tokenState.balanceOf(account)
1630             );
1631             require(value <= transferable, "Cannot transfer staked or escrowed SNX");
1632             require(!anyRateIsInvalid, "A synth or SNX rate is invalid");
1633         }
1634         return true;
1635     }
1636 
1637     // ========== MUTATIVE FUNCTIONS ==========
1638 
1639     function transfer(address to, uint value) external optionalProxy systemActive returns (bool) {
1640         // Ensure they're not trying to exceed their locked amount -- only if they have debt.
1641         _canTransfer(messageSender, value);
1642 
1643         // Perform the transfer: if there is a problem an exception will be thrown in this call.
1644         _transferByProxy(messageSender, to, value);
1645 
1646         return true;
1647     }
1648 
1649     function transferFrom(
1650         address from,
1651         address to,
1652         uint value
1653     ) external optionalProxy systemActive returns (bool) {
1654         // Ensure they're not trying to exceed their locked amount -- only if they have debt.
1655         _canTransfer(from, value);
1656 
1657         // Perform the transfer: if there is a problem,
1658         // an exception will be thrown in this call.
1659         return _transferFromByProxy(messageSender, from, to, value);
1660     }
1661 
1662     function issueSynths(uint amount) external issuanceActive optionalProxy {
1663         return issuer().issueSynths(messageSender, amount);
1664     }
1665 
1666     function issueSynthsOnBehalf(address issueForAddress, uint amount) external issuanceActive optionalProxy {
1667         return issuer().issueSynthsOnBehalf(issueForAddress, messageSender, amount);
1668     }
1669 
1670     function issueMaxSynths() external issuanceActive optionalProxy {
1671         return issuer().issueMaxSynths(messageSender);
1672     }
1673 
1674     function issueMaxSynthsOnBehalf(address issueForAddress) external issuanceActive optionalProxy {
1675         return issuer().issueMaxSynthsOnBehalf(issueForAddress, messageSender);
1676     }
1677 
1678     function burnSynths(uint amount) external issuanceActive optionalProxy {
1679         return issuer().burnSynths(messageSender, amount);
1680     }
1681 
1682     function burnSynthsOnBehalf(address burnForAddress, uint amount) external issuanceActive optionalProxy {
1683         return issuer().burnSynthsOnBehalf(burnForAddress, messageSender, amount);
1684     }
1685 
1686     function burnSynthsToTarget() external issuanceActive optionalProxy {
1687         return issuer().burnSynthsToTarget(messageSender);
1688     }
1689 
1690     function burnSynthsToTargetOnBehalf(address burnForAddress) external issuanceActive optionalProxy {
1691         return issuer().burnSynthsToTargetOnBehalf(burnForAddress, messageSender);
1692     }
1693 
1694     function exchange(
1695         bytes32,
1696         uint,
1697         bytes32
1698     ) external returns (uint) {
1699         _notImplemented();
1700     }
1701 
1702     function exchangeOnBehalf(
1703         address,
1704         bytes32,
1705         uint,
1706         bytes32
1707     ) external returns (uint) {
1708         _notImplemented();
1709     }
1710 
1711     function exchangeWithTracking(
1712         bytes32,
1713         uint,
1714         bytes32,
1715         address,
1716         bytes32
1717     ) external returns (uint) {
1718         _notImplemented();
1719     }
1720 
1721     function exchangeOnBehalfWithTracking(
1722         address,
1723         bytes32,
1724         uint,
1725         bytes32,
1726         address,
1727         bytes32
1728     ) external returns (uint) {
1729         _notImplemented();
1730     }
1731 
1732     function exchangeWithVirtual(
1733         bytes32,
1734         uint,
1735         bytes32,
1736         bytes32
1737     ) external returns (uint, IVirtualSynth) {
1738         _notImplemented();
1739     }
1740 
1741     function settle(bytes32)
1742         external
1743         returns (
1744             uint,
1745             uint,
1746             uint
1747         )
1748     {
1749         _notImplemented();
1750     }
1751 
1752     function mint() external returns (bool) {
1753         _notImplemented();
1754     }
1755 
1756     function liquidateDelinquentAccount(address, uint) external returns (bool) {
1757         _notImplemented();
1758     }
1759 
1760     function mintSecondary(address, uint) external {
1761         _notImplemented();
1762     }
1763 
1764     function mintSecondaryRewards(uint) external {
1765         _notImplemented();
1766     }
1767 
1768     function burnSecondary(address, uint) external {
1769         _notImplemented();
1770     }
1771 
1772     function _notImplemented() internal pure {
1773         revert("Cannot be run on this layer");
1774     }
1775 
1776     // ========== MODIFIERS ==========
1777 
1778     modifier systemActive() {
1779         _systemActive();
1780         _;
1781     }
1782 
1783     function _systemActive() private {
1784         systemStatus().requireSystemActive();
1785     }
1786 
1787     modifier issuanceActive() {
1788         _issuanceActive();
1789         _;
1790     }
1791 
1792     function _issuanceActive() private {
1793         systemStatus().requireIssuanceActive();
1794     }
1795 }
1796 
1797 
1798 // https://docs.synthetix.io/contracts/source/interfaces/irewardescrow
1799 interface IRewardEscrow {
1800     // Views
1801     function balanceOf(address account) external view returns (uint);
1802 
1803     function numVestingEntries(address account) external view returns (uint);
1804 
1805     function totalEscrowedAccountBalance(address account) external view returns (uint);
1806 
1807     function totalVestedAccountBalance(address account) external view returns (uint);
1808 
1809     function getVestingScheduleEntry(address account, uint index) external view returns (uint[2] memory);
1810 
1811     function getNextVestingIndex(address account) external view returns (uint);
1812 
1813     // Mutative functions
1814     function appendVestingEntry(address account, uint quantity) external;
1815 
1816     function vest() external;
1817 }
1818 
1819 
1820 pragma experimental ABIEncoderV2;
1821 
1822 
1823 library VestingEntries {
1824     struct VestingEntry {
1825         uint64 endTime;
1826         uint256 escrowAmount;
1827     }
1828     struct VestingEntryWithID {
1829         uint64 endTime;
1830         uint256 escrowAmount;
1831         uint256 entryID;
1832     }
1833 }
1834 
1835 
1836 interface IRewardEscrowV2 {
1837     // Views
1838     function balanceOf(address account) external view returns (uint);
1839 
1840     function numVestingEntries(address account) external view returns (uint);
1841 
1842     function totalEscrowedAccountBalance(address account) external view returns (uint);
1843 
1844     function totalVestedAccountBalance(address account) external view returns (uint);
1845 
1846     function getVestingQuantity(address account, uint256[] calldata entryIDs) external view returns (uint);
1847 
1848     function getVestingSchedules(
1849         address account,
1850         uint256 index,
1851         uint256 pageSize
1852     ) external view returns (VestingEntries.VestingEntryWithID[] memory);
1853 
1854     function getAccountVestingEntryIDs(
1855         address account,
1856         uint256 index,
1857         uint256 pageSize
1858     ) external view returns (uint256[] memory);
1859 
1860     function getVestingEntryClaimable(address account, uint256 entryID) external view returns (uint);
1861 
1862     function getVestingEntry(address account, uint256 entryID) external view returns (uint64, uint256);
1863 
1864     // Mutative functions
1865     function vest(uint256[] calldata entryIDs) external;
1866 
1867     function createEscrowEntry(
1868         address beneficiary,
1869         uint256 deposit,
1870         uint256 duration
1871     ) external;
1872 
1873     function appendVestingEntry(
1874         address account,
1875         uint256 quantity,
1876         uint256 duration
1877     ) external;
1878 
1879     function migrateVestingSchedule(address _addressToMigrate) external;
1880 
1881     function migrateAccountEscrowBalances(
1882         address[] calldata accounts,
1883         uint256[] calldata escrowBalances,
1884         uint256[] calldata vestedBalances
1885     ) external;
1886 
1887     // Account Merging
1888     function startMergingWindow() external;
1889 
1890     function mergeAccount(address accountToMerge, uint256[] calldata entryIDs) external;
1891 
1892     function nominateAccountToMerge(address account) external;
1893 
1894     function accountMergingIsOpen() external view returns (bool);
1895 
1896     // L2 Migration
1897     function importVestingEntries(
1898         address account,
1899         uint256 escrowedAmount,
1900         VestingEntries.VestingEntry[] calldata vestingEntries
1901     ) external;
1902 
1903     // Return amount of SNX transfered to SynthetixBridgeToOptimism deposit contract
1904     function burnForMigration(address account, uint256[] calldata entryIDs)
1905         external
1906         returns (uint256 escrowedAccountBalance, VestingEntries.VestingEntry[] memory vestingEntries);
1907 }
1908 
1909 
1910 // https://docs.synthetix.io/contracts/source/interfaces/isupplyschedule
1911 interface ISupplySchedule {
1912     // Views
1913     function mintableSupply() external view returns (uint);
1914 
1915     function isMintable() external view returns (bool);
1916 
1917     function minterReward() external view returns (uint);
1918 
1919     // Mutative functions
1920     function recordMintEvent(uint supplyMinted) external returns (bool);
1921 }
1922 
1923 
1924 // Inheritance
1925 
1926 
1927 // Internal references
1928 
1929 
1930 // https://docs.synthetix.io/contracts/source/contracts/synthetix
1931 contract Synthetix is BaseSynthetix {
1932     // ========== ADDRESS RESOLVER CONFIGURATION ==========
1933     bytes32 private constant CONTRACT_REWARD_ESCROW = "RewardEscrow";
1934     bytes32 private constant CONTRACT_REWARDESCROW_V2 = "RewardEscrowV2";
1935     bytes32 private constant CONTRACT_SUPPLYSCHEDULE = "SupplySchedule";
1936 
1937     // ========== CONSTRUCTOR ==========
1938 
1939     constructor(
1940         address payable _proxy,
1941         TokenState _tokenState,
1942         address _owner,
1943         uint _totalSupply,
1944         address _resolver
1945     ) public BaseSynthetix(_proxy, _tokenState, _owner, _totalSupply, _resolver) {}
1946 
1947     function resolverAddressesRequired() public view returns (bytes32[] memory addresses) {
1948         bytes32[] memory existingAddresses = BaseSynthetix.resolverAddressesRequired();
1949         bytes32[] memory newAddresses = new bytes32[](3);
1950         newAddresses[0] = CONTRACT_REWARD_ESCROW;
1951         newAddresses[1] = CONTRACT_REWARDESCROW_V2;
1952         newAddresses[2] = CONTRACT_SUPPLYSCHEDULE;
1953         return combineArrays(existingAddresses, newAddresses);
1954     }
1955 
1956     // ========== VIEWS ==========
1957 
1958     function rewardEscrow() internal view returns (IRewardEscrow) {
1959         return IRewardEscrow(requireAndGetAddress(CONTRACT_REWARD_ESCROW));
1960     }
1961 
1962     function rewardEscrowV2() internal view returns (IRewardEscrowV2) {
1963         return IRewardEscrowV2(requireAndGetAddress(CONTRACT_REWARDESCROW_V2));
1964     }
1965 
1966     function supplySchedule() internal view returns (ISupplySchedule) {
1967         return ISupplySchedule(requireAndGetAddress(CONTRACT_SUPPLYSCHEDULE));
1968     }
1969 
1970     // ========== OVERRIDDEN FUNCTIONS ==========
1971 
1972     function exchange(
1973         bytes32 sourceCurrencyKey,
1974         uint sourceAmount,
1975         bytes32 destinationCurrencyKey
1976     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
1977         return exchanger().exchange(messageSender, sourceCurrencyKey, sourceAmount, destinationCurrencyKey, messageSender);
1978     }
1979 
1980     function exchangeOnBehalf(
1981         address exchangeForAddress,
1982         bytes32 sourceCurrencyKey,
1983         uint sourceAmount,
1984         bytes32 destinationCurrencyKey
1985     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
1986         return
1987             exchanger().exchangeOnBehalf(
1988                 exchangeForAddress,
1989                 messageSender,
1990                 sourceCurrencyKey,
1991                 sourceAmount,
1992                 destinationCurrencyKey
1993             );
1994     }
1995 
1996     function exchangeWithTracking(
1997         bytes32 sourceCurrencyKey,
1998         uint sourceAmount,
1999         bytes32 destinationCurrencyKey,
2000         address originator,
2001         bytes32 trackingCode
2002     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
2003         return
2004             exchanger().exchangeWithTracking(
2005                 messageSender,
2006                 sourceCurrencyKey,
2007                 sourceAmount,
2008                 destinationCurrencyKey,
2009                 messageSender,
2010                 originator,
2011                 trackingCode
2012             );
2013     }
2014 
2015     function exchangeOnBehalfWithTracking(
2016         address exchangeForAddress,
2017         bytes32 sourceCurrencyKey,
2018         uint sourceAmount,
2019         bytes32 destinationCurrencyKey,
2020         address originator,
2021         bytes32 trackingCode
2022     ) external exchangeActive(sourceCurrencyKey, destinationCurrencyKey) optionalProxy returns (uint amountReceived) {
2023         return
2024             exchanger().exchangeOnBehalfWithTracking(
2025                 exchangeForAddress,
2026                 messageSender,
2027                 sourceCurrencyKey,
2028                 sourceAmount,
2029                 destinationCurrencyKey,
2030                 originator,
2031                 trackingCode
2032             );
2033     }
2034 
2035     function exchangeWithVirtual(
2036         bytes32 sourceCurrencyKey,
2037         uint sourceAmount,
2038         bytes32 destinationCurrencyKey,
2039         bytes32 trackingCode
2040     )
2041         external
2042         exchangeActive(sourceCurrencyKey, destinationCurrencyKey)
2043         optionalProxy
2044         returns (uint amountReceived, IVirtualSynth vSynth)
2045     {
2046         return
2047             exchanger().exchangeWithVirtual(
2048                 messageSender,
2049                 sourceCurrencyKey,
2050                 sourceAmount,
2051                 destinationCurrencyKey,
2052                 messageSender,
2053                 trackingCode
2054             );
2055     }
2056 
2057     function settle(bytes32 currencyKey)
2058         external
2059         optionalProxy
2060         returns (
2061             uint reclaimed,
2062             uint refunded,
2063             uint numEntriesSettled
2064         )
2065     {
2066         return exchanger().settle(messageSender, currencyKey);
2067     }
2068 
2069     function mint() external issuanceActive returns (bool) {
2070         require(address(rewardsDistribution()) != address(0), "RewardsDistribution not set");
2071 
2072         ISupplySchedule _supplySchedule = supplySchedule();
2073         IRewardsDistribution _rewardsDistribution = rewardsDistribution();
2074 
2075         uint supplyToMint = _supplySchedule.mintableSupply();
2076         require(supplyToMint > 0, "No supply is mintable");
2077 
2078         // record minting event before mutation to token supply
2079         _supplySchedule.recordMintEvent(supplyToMint);
2080 
2081         // Set minted SNX balance to RewardEscrow's balance
2082         // Minus the minterReward and set balance of minter to add reward
2083         uint minterReward = _supplySchedule.minterReward();
2084         // Get the remainder
2085         uint amountToDistribute = supplyToMint.sub(minterReward);
2086 
2087         // Set the token balance to the RewardsDistribution contract
2088         tokenState.setBalanceOf(
2089             address(_rewardsDistribution),
2090             tokenState.balanceOf(address(_rewardsDistribution)).add(amountToDistribute)
2091         );
2092         emitTransfer(address(this), address(_rewardsDistribution), amountToDistribute);
2093 
2094         // Kick off the distribution of rewards
2095         _rewardsDistribution.distributeRewards(amountToDistribute);
2096 
2097         // Assign the minters reward.
2098         tokenState.setBalanceOf(msg.sender, tokenState.balanceOf(msg.sender).add(minterReward));
2099         emitTransfer(address(this), msg.sender, minterReward);
2100 
2101         totalSupply = totalSupply.add(supplyToMint);
2102 
2103         return true;
2104     }
2105 
2106     function liquidateDelinquentAccount(address account, uint susdAmount)
2107         external
2108         systemActive
2109         optionalProxy
2110         returns (bool)
2111     {
2112         (uint totalRedeemed, uint amountLiquidated) = issuer().liquidateDelinquentAccount(
2113             account,
2114             susdAmount,
2115             messageSender
2116         );
2117 
2118         emitAccountLiquidated(account, totalRedeemed, amountLiquidated, messageSender);
2119 
2120         // Transfer SNX redeemed to messageSender
2121         // Reverts if amount to redeem is more than balanceOf account, ie due to escrowed balance
2122         return _transferByProxy(account, messageSender, totalRedeemed);
2123     }
2124 
2125     /* Once off function for SIP-60 to migrate SNX balances in the RewardEscrow contract
2126      * To the new RewardEscrowV2 contract
2127      */
2128     function migrateEscrowBalanceToRewardEscrowV2() external onlyOwner {
2129         // Record balanceOf(RewardEscrow) contract
2130         uint rewardEscrowBalance = tokenState.balanceOf(address(rewardEscrow()));
2131 
2132         // transfer all of RewardEscrow's balance to RewardEscrowV2
2133         // _internalTransfer emits the transfer event
2134         _internalTransfer(address(rewardEscrow()), address(rewardEscrowV2()), rewardEscrowBalance);
2135     }
2136 
2137     // ========== EVENTS ==========
2138     event SynthExchange(
2139         address indexed account,
2140         bytes32 fromCurrencyKey,
2141         uint256 fromAmount,
2142         bytes32 toCurrencyKey,
2143         uint256 toAmount,
2144         address toAddress
2145     );
2146     bytes32 internal constant SYNTHEXCHANGE_SIG = keccak256(
2147         "SynthExchange(address,bytes32,uint256,bytes32,uint256,address)"
2148     );
2149 
2150     function emitSynthExchange(
2151         address account,
2152         bytes32 fromCurrencyKey,
2153         uint256 fromAmount,
2154         bytes32 toCurrencyKey,
2155         uint256 toAmount,
2156         address toAddress
2157     ) external onlyExchanger {
2158         proxy._emit(
2159             abi.encode(fromCurrencyKey, fromAmount, toCurrencyKey, toAmount, toAddress),
2160             2,
2161             SYNTHEXCHANGE_SIG,
2162             addressToBytes32(account),
2163             0,
2164             0
2165         );
2166     }
2167 
2168     event ExchangeTracking(bytes32 indexed trackingCode, bytes32 toCurrencyKey, uint256 toAmount);
2169     bytes32 internal constant EXCHANGE_TRACKING_SIG = keccak256("ExchangeTracking(bytes32,bytes32,uint256)");
2170 
2171     function emitExchangeTracking(
2172         bytes32 trackingCode,
2173         bytes32 toCurrencyKey,
2174         uint256 toAmount
2175     ) external onlyExchanger {
2176         proxy._emit(abi.encode(toCurrencyKey, toAmount), 2, EXCHANGE_TRACKING_SIG, trackingCode, 0, 0);
2177     }
2178 
2179     event ExchangeReclaim(address indexed account, bytes32 currencyKey, uint amount);
2180     bytes32 internal constant EXCHANGERECLAIM_SIG = keccak256("ExchangeReclaim(address,bytes32,uint256)");
2181 
2182     function emitExchangeReclaim(
2183         address account,
2184         bytes32 currencyKey,
2185         uint256 amount
2186     ) external onlyExchanger {
2187         proxy._emit(abi.encode(currencyKey, amount), 2, EXCHANGERECLAIM_SIG, addressToBytes32(account), 0, 0);
2188     }
2189 
2190     event ExchangeRebate(address indexed account, bytes32 currencyKey, uint amount);
2191     bytes32 internal constant EXCHANGEREBATE_SIG = keccak256("ExchangeRebate(address,bytes32,uint256)");
2192 
2193     function emitExchangeRebate(
2194         address account,
2195         bytes32 currencyKey,
2196         uint256 amount
2197     ) external onlyExchanger {
2198         proxy._emit(abi.encode(currencyKey, amount), 2, EXCHANGEREBATE_SIG, addressToBytes32(account), 0, 0);
2199     }
2200 
2201     event AccountLiquidated(address indexed account, uint snxRedeemed, uint amountLiquidated, address liquidator);
2202     bytes32 internal constant ACCOUNTLIQUIDATED_SIG = keccak256("AccountLiquidated(address,uint256,uint256,address)");
2203 
2204     function emitAccountLiquidated(
2205         address account,
2206         uint256 snxRedeemed,
2207         uint256 amountLiquidated,
2208         address liquidator
2209     ) internal {
2210         proxy._emit(
2211             abi.encode(snxRedeemed, amountLiquidated, liquidator),
2212             2,
2213             ACCOUNTLIQUIDATED_SIG,
2214             addressToBytes32(account),
2215             0,
2216             0
2217         );
2218     }
2219 
2220     // ========== MODIFIERS ==========
2221 
2222     modifier onlyExchanger() {
2223         _onlyExchanger();
2224         _;
2225     }
2226 
2227     function _onlyExchanger() private {
2228         require(msg.sender == address(exchanger()), "Only Exchanger can invoke this");
2229     }
2230 
2231     modifier exchangeActive(bytes32 src, bytes32 dest) {
2232         _exchangeActive(src, dest);
2233         _;
2234     }
2235 
2236     function _exchangeActive(bytes32 src, bytes32 dest) private {
2237         systemStatus().requireExchangeBetweenSynthsAllowed(src, dest);
2238     }
2239 }
2240 
2241     