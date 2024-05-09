1 
2 // File: @openzeppelin/contracts/math/SafeMath.sol
3 
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.6.0;
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on
24      * overflow.
25      *
26      * Counterpart to Solidity's `+` operator.
27      *
28      * Requirements:
29      *
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      *
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      *
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      *
78      * - Multiplication cannot overflow.
79      */
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts with custom message when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
165 
166 
167 
168 pragma solidity ^0.6.0;
169 
170 /**
171  * @dev Interface of the ERC20 standard as defined in the EIP.
172  */
173 interface IERC20 {
174     /**
175      * @dev Returns the amount of tokens in existence.
176      */
177     function totalSupply() external view returns (uint256);
178 
179     /**
180      * @dev Returns the amount of tokens owned by `account`.
181      */
182     function balanceOf(address account) external view returns (uint256);
183 
184     /**
185      * @dev Moves `amount` tokens from the caller's account to `recipient`.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transfer(address recipient, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Returns the remaining number of tokens that `spender` will be
195      * allowed to spend on behalf of `owner` through {transferFrom}. This is
196      * zero by default.
197      *
198      * This value changes when {approve} or {transferFrom} are called.
199      */
200     function allowance(address owner, address spender) external view returns (uint256);
201 
202     /**
203      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * IMPORTANT: Beware that changing an allowance with this method brings the risk
208      * that someone may use both the old and the new allowance by unfortunate
209      * transaction ordering. One possible solution to mitigate this race
210      * condition is to first reduce the spender's allowance to 0 and set the
211      * desired value afterwards:
212      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213      *
214      * Emits an {Approval} event.
215      */
216     function approve(address spender, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Moves `amount` tokens from `sender` to `recipient` using the
220      * allowance mechanism. `amount` is then deducted from the caller's
221      * allowance.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Emitted when `value` tokens are moved from one account (`from`) to
231      * another (`to`).
232      *
233      * Note that `value` may be zero.
234      */
235     event Transfer(address indexed from, address indexed to, uint256 value);
236 
237     /**
238      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
239      * a call to {approve}. `value` is the new allowance.
240      */
241     event Approval(address indexed owner, address indexed spender, uint256 value);
242 }
243 
244 // File: @bancor/token-governance/contracts/IClaimable.sol
245 
246 
247 pragma solidity 0.6.12;
248 
249 /// @title Claimable contract interface
250 interface IClaimable {
251     function owner() external view returns (address);
252 
253     function transferOwnership(address newOwner) external;
254 
255     function acceptOwnership() external;
256 }
257 
258 // File: @bancor/token-governance/contracts/IMintableToken.sol
259 
260 
261 pragma solidity 0.6.12;
262 
263 
264 
265 /// @title Mintable Token interface
266 interface IMintableToken is IERC20, IClaimable {
267     function issue(address to, uint256 amount) external;
268 
269     function destroy(address from, uint256 amount) external;
270 }
271 
272 // File: @bancor/token-governance/contracts/ITokenGovernance.sol
273 
274 
275 pragma solidity 0.6.12;
276 
277 
278 /// @title The interface for mintable/burnable token governance.
279 interface ITokenGovernance {
280     // The address of the mintable ERC20 token.
281     function token() external view returns (IMintableToken);
282 
283     /// @dev Mints new tokens.
284     ///
285     /// @param to Account to receive the new amount.
286     /// @param amount Amount to increase the supply by.
287     ///
288     function mint(address to, uint256 amount) external;
289 
290     /// @dev Burns tokens from the caller.
291     ///
292     /// @param amount Amount to decrease the supply by.
293     ///
294     function burn(uint256 amount) external;
295 }
296 
297 // File: solidity/contracts/utility/interfaces/ICheckpointStore.sol
298 
299 
300 pragma solidity 0.6.12;
301 
302 /**
303  * @dev Checkpoint store contract interface
304  */
305 interface ICheckpointStore {
306     function addCheckpoint(address _address) external;
307 
308     function addPastCheckpoint(address _address, uint256 _time) external;
309 
310     function addPastCheckpoints(address[] calldata _addresses, uint256[] calldata _times) external;
311 
312     function checkpoint(address _address) external view returns (uint256);
313 }
314 
315 // File: solidity/contracts/utility/MathEx.sol
316 
317 
318 pragma solidity 0.6.12;
319 
320 /**
321  * @dev This library provides a set of complex math operations.
322  */
323 library MathEx {
324     /**
325      * @dev returns the largest integer smaller than or equal to the square root of a positive integer
326      *
327      * @param _num a positive integer
328      *
329      * @return the largest integer smaller than or equal to the square root of the positive integer
330      */
331     function floorSqrt(uint256 _num) internal pure returns (uint256) {
332         uint256 x = _num / 2 + 1;
333         uint256 y = (x + _num / x) / 2;
334         while (x > y) {
335             x = y;
336             y = (x + _num / x) / 2;
337         }
338         return x;
339     }
340 
341     /**
342      * @dev returns the smallest integer larger than or equal to the square root of a positive integer
343      *
344      * @param _num a positive integer
345      *
346      * @return the smallest integer larger than or equal to the square root of the positive integer
347      */
348     function ceilSqrt(uint256 _num) internal pure returns (uint256) {
349         uint256 x = floorSqrt(_num);
350         return x * x == _num ? x : x + 1;
351     }
352 
353     /**
354      * @dev computes a reduced-scalar ratio
355      *
356      * @param _n   ratio numerator
357      * @param _d   ratio denominator
358      * @param _max maximum desired scalar
359      *
360      * @return ratio's numerator and denominator
361      */
362     function reducedRatio(
363         uint256 _n,
364         uint256 _d,
365         uint256 _max
366     ) internal pure returns (uint256, uint256) {
367         (uint256 n, uint256 d) = (_n, _d);
368         if (n > _max || d > _max) {
369             (n, d) = normalizedRatio(n, d, _max);
370         }
371         if (n != d) {
372             return (n, d);
373         }
374         return (1, 1);
375     }
376 
377     /**
378      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)".
379      */
380     function normalizedRatio(
381         uint256 _a,
382         uint256 _b,
383         uint256 _scale
384     ) internal pure returns (uint256, uint256) {
385         if (_a <= _b) {
386             return accurateRatio(_a, _b, _scale);
387         }
388         (uint256 y, uint256 x) = accurateRatio(_b, _a, _scale);
389         return (x, y);
390     }
391 
392     /**
393      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)", assuming that "a <= b".
394      */
395     function accurateRatio(
396         uint256 _a,
397         uint256 _b,
398         uint256 _scale
399     ) internal pure returns (uint256, uint256) {
400         uint256 maxVal = uint256(-1) / _scale;
401         if (_a > maxVal) {
402             uint256 c = _a / (maxVal + 1) + 1;
403             _a /= c; // we can now safely compute `_a * _scale`
404             _b /= c;
405         }
406         if (_a != _b) {
407             uint256 n = _a * _scale;
408             uint256 d = _a + _b; // can overflow
409             if (d >= _a) {
410                 // no overflow in `_a + _b`
411                 uint256 x = roundDiv(n, d); // we can now safely compute `_scale - x`
412                 uint256 y = _scale - x;
413                 return (x, y);
414             }
415             if (n < _b - (_b - _a) / 2) {
416                 return (0, _scale); // `_a * _scale < (_a + _b) / 2 < MAX_UINT256 < _a + _b`
417             }
418             return (1, _scale - 1); // `(_a + _b) / 2 < _a * _scale < MAX_UINT256 < _a + _b`
419         }
420         return (_scale / 2, _scale / 2); // allow reduction to `(1, 1)` in the calling function
421     }
422 
423     /**
424      * @dev computes the nearest integer to a given quotient without overflowing or underflowing.
425      */
426     function roundDiv(uint256 _n, uint256 _d) internal pure returns (uint256) {
427         return _n / _d + (_n % _d) / (_d - _d / 2);
428     }
429 
430     /**
431      * @dev returns the average number of decimal digits in a given list of positive integers
432      *
433      * @param _values  list of positive integers
434      *
435      * @return the average number of decimal digits in the given list of positive integers
436      */
437     function geometricMean(uint256[] memory _values) internal pure returns (uint256) {
438         uint256 numOfDigits = 0;
439         uint256 length = _values.length;
440         for (uint256 i = 0; i < length; i++) {
441             numOfDigits += decimalLength(_values[i]);
442         }
443         return uint256(10)**(roundDivUnsafe(numOfDigits, length) - 1);
444     }
445 
446     /**
447      * @dev returns the number of decimal digits in a given positive integer
448      *
449      * @param _x   positive integer
450      *
451      * @return the number of decimal digits in the given positive integer
452      */
453     function decimalLength(uint256 _x) internal pure returns (uint256) {
454         uint256 y = 0;
455         for (uint256 x = _x; x > 0; x /= 10) {
456             y++;
457         }
458         return y;
459     }
460 
461     /**
462      * @dev returns the nearest integer to a given quotient
463      * the computation is overflow-safe assuming that the input is sufficiently small
464      *
465      * @param _n   quotient numerator
466      * @param _d   quotient denominator
467      *
468      * @return the nearest integer to the given quotient
469      */
470     function roundDivUnsafe(uint256 _n, uint256 _d) internal pure returns (uint256) {
471         return (_n + _d / 2) / _d;
472     }
473 
474     /**
475      * @dev returns the larger of two values
476      *
477      * @param _val1 the first value
478      * @param _val2 the second value
479      */
480     function max(uint256 _val1, uint256 _val2) internal pure returns (uint256) {
481         return _val1 > _val2 ? _val1 : _val2;
482     }
483 }
484 
485 // File: solidity/contracts/utility/ReentrancyGuard.sol
486 
487 
488 pragma solidity 0.6.12;
489 
490 /**
491  * @dev This contract provides protection against calling a function
492  * (directly or indirectly) from within itself.
493  */
494 contract ReentrancyGuard {
495     uint256 private constant UNLOCKED = 1;
496     uint256 private constant LOCKED = 2;
497 
498     // LOCKED while protected code is being executed, UNLOCKED otherwise
499     uint256 private state = UNLOCKED;
500 
501     /**
502      * @dev ensures instantiation only by sub-contracts
503      */
504     constructor() internal {}
505 
506     // protects a function against reentrancy attacks
507     modifier protected() {
508         _protected();
509         state = LOCKED;
510         _;
511         state = UNLOCKED;
512     }
513 
514     // error message binary size optimization
515     function _protected() internal view {
516         require(state == UNLOCKED, "ERR_REENTRANCY");
517     }
518 }
519 
520 // File: solidity/contracts/utility/interfaces/IOwned.sol
521 
522 
523 pragma solidity 0.6.12;
524 
525 /*
526     Owned contract interface
527 */
528 interface IOwned {
529     // this function isn't since the compiler emits automatically generated getter functions as external
530     function owner() external view returns (address);
531 
532     function transferOwnership(address _newOwner) external;
533 
534     function acceptOwnership() external;
535 }
536 
537 // File: solidity/contracts/utility/Owned.sol
538 
539 
540 pragma solidity 0.6.12;
541 
542 
543 /**
544  * @dev This contract provides support and utilities for contract ownership.
545  */
546 contract Owned is IOwned {
547     address public override owner;
548     address public newOwner;
549 
550     /**
551      * @dev triggered when the owner is updated
552      *
553      * @param _prevOwner previous owner
554      * @param _newOwner  new owner
555      */
556     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
557 
558     /**
559      * @dev initializes a new Owned instance
560      */
561     constructor() public {
562         owner = msg.sender;
563     }
564 
565     // allows execution by the owner only
566     modifier ownerOnly {
567         _ownerOnly();
568         _;
569     }
570 
571     // error message binary size optimization
572     function _ownerOnly() internal view {
573         require(msg.sender == owner, "ERR_ACCESS_DENIED");
574     }
575 
576     /**
577      * @dev allows transferring the contract ownership
578      * the new owner still needs to accept the transfer
579      * can only be called by the contract owner
580      *
581      * @param _newOwner    new contract owner
582      */
583     function transferOwnership(address _newOwner) public override ownerOnly {
584         require(_newOwner != owner, "ERR_SAME_OWNER");
585         newOwner = _newOwner;
586     }
587 
588     /**
589      * @dev used by a new owner to accept an ownership transfer
590      */
591     function acceptOwnership() public override {
592         require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
593         emit OwnerUpdate(owner, newOwner);
594         owner = newOwner;
595         newOwner = address(0);
596     }
597 }
598 
599 // File: solidity/contracts/token/interfaces/IERC20Token.sol
600 
601 
602 pragma solidity 0.6.12;
603 
604 /*
605     ERC20 Standard Token interface
606 */
607 interface IERC20Token {
608     function name() external view returns (string memory);
609 
610     function symbol() external view returns (string memory);
611 
612     function decimals() external view returns (uint8);
613 
614     function totalSupply() external view returns (uint256);
615 
616     function balanceOf(address _owner) external view returns (uint256);
617 
618     function allowance(address _owner, address _spender) external view returns (uint256);
619 
620     function transfer(address _to, uint256 _value) external returns (bool);
621 
622     function transferFrom(
623         address _from,
624         address _to,
625         uint256 _value
626     ) external returns (bool);
627 
628     function approve(address _spender, uint256 _value) external returns (bool);
629 }
630 
631 // File: solidity/contracts/utility/TokenHandler.sol
632 
633 
634 pragma solidity 0.6.12;
635 
636 
637 contract TokenHandler {
638     bytes4 private constant APPROVE_FUNC_SELECTOR = bytes4(keccak256("approve(address,uint256)"));
639     bytes4 private constant TRANSFER_FUNC_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));
640     bytes4 private constant TRANSFER_FROM_FUNC_SELECTOR = bytes4(keccak256("transferFrom(address,address,uint256)"));
641 
642     /**
643      * @dev executes the ERC20 token's `approve` function and reverts upon failure
644      * the main purpose of this function is to prevent a non standard ERC20 token
645      * from failing silently
646      *
647      * @param _token   ERC20 token address
648      * @param _spender approved address
649      * @param _value   allowance amount
650      */
651     function safeApprove(
652         IERC20Token _token,
653         address _spender,
654         uint256 _value
655     ) internal {
656         (bool success, bytes memory data) = address(_token).call(
657             abi.encodeWithSelector(APPROVE_FUNC_SELECTOR, _spender, _value)
658         );
659         require(success && (data.length == 0 || abi.decode(data, (bool))), "ERR_APPROVE_FAILED");
660     }
661 
662     /**
663      * @dev executes the ERC20 token's `transfer` function and reverts upon failure
664      * the main purpose of this function is to prevent a non standard ERC20 token
665      * from failing silently
666      *
667      * @param _token   ERC20 token address
668      * @param _to      target address
669      * @param _value   transfer amount
670      */
671     function safeTransfer(
672         IERC20Token _token,
673         address _to,
674         uint256 _value
675     ) internal {
676         (bool success, bytes memory data) = address(_token).call(
677             abi.encodeWithSelector(TRANSFER_FUNC_SELECTOR, _to, _value)
678         );
679         require(success && (data.length == 0 || abi.decode(data, (bool))), "ERR_TRANSFER_FAILED");
680     }
681 
682     /**
683      * @dev executes the ERC20 token's `transferFrom` function and reverts upon failure
684      * the main purpose of this function is to prevent a non standard ERC20 token
685      * from failing silently
686      *
687      * @param _token   ERC20 token address
688      * @param _from    source address
689      * @param _to      target address
690      * @param _value   transfer amount
691      */
692     function safeTransferFrom(
693         IERC20Token _token,
694         address _from,
695         address _to,
696         uint256 _value
697     ) internal {
698         (bool success, bytes memory data) = address(_token).call(
699             abi.encodeWithSelector(TRANSFER_FROM_FUNC_SELECTOR, _from, _to, _value)
700         );
701         require(success && (data.length == 0 || abi.decode(data, (bool))), "ERR_TRANSFER_FROM_FAILED");
702     }
703 }
704 
705 // File: solidity/contracts/utility/Types.sol
706 
707 
708 pragma solidity 0.6.12;
709 
710 /**
711  * @dev This contract provides types which can be used by various contracts.
712  */
713 
714 struct Fraction {
715     uint256 n; // numerator
716     uint256 d; // denominator
717 }
718 
719 // File: solidity/contracts/utility/Time.sol
720 
721 
722 pragma solidity 0.6.12;
723 
724 /*
725     Time implementing contract
726 */
727 contract Time {
728     /**
729      * @dev returns the current time
730      */
731     function time() internal view virtual returns (uint256) {
732         return block.timestamp;
733     }
734 }
735 
736 // File: solidity/contracts/utility/Utils.sol
737 
738 
739 pragma solidity 0.6.12;
740 
741 /**
742  * @dev Utilities & Common Modifiers
743  */
744 contract Utils {
745     // verifies that a value is greater than zero
746     modifier greaterThanZero(uint256 _value) {
747         _greaterThanZero(_value);
748         _;
749     }
750 
751     // error message binary size optimization
752     function _greaterThanZero(uint256 _value) internal pure {
753         require(_value > 0, "ERR_ZERO_VALUE");
754     }
755 
756     // validates an address - currently only checks that it isn't null
757     modifier validAddress(address _address) {
758         _validAddress(_address);
759         _;
760     }
761 
762     // error message binary size optimization
763     function _validAddress(address _address) internal pure {
764         require(_address != address(0), "ERR_INVALID_ADDRESS");
765     }
766 
767     // verifies that the address is different than this contract address
768     modifier notThis(address _address) {
769         _notThis(_address);
770         _;
771     }
772 
773     // error message binary size optimization
774     function _notThis(address _address) internal view {
775         require(_address != address(this), "ERR_ADDRESS_IS_SELF");
776     }
777 
778     // validates an external address - currently only checks that it isn't null or this
779     modifier validExternalAddress(address _address) {
780         _validExternalAddress(_address);
781         _;
782     }
783 
784     // error message binary size optimization
785     function _validExternalAddress(address _address) internal view {
786         require(_address != address(0) && _address != address(this), "ERR_INVALID_EXTERNAL_ADDRESS");
787     }
788 }
789 
790 // File: solidity/contracts/converter/interfaces/IConverterAnchor.sol
791 
792 
793 pragma solidity 0.6.12;
794 
795 
796 /*
797     Converter Anchor interface
798 */
799 interface IConverterAnchor is IOwned {
800 
801 }
802 
803 // File: solidity/contracts/token/interfaces/IDSToken.sol
804 
805 
806 pragma solidity 0.6.12;
807 
808 
809 
810 
811 /*
812     DSToken interface
813 */
814 interface IDSToken is IConverterAnchor, IERC20Token {
815     function issue(address _to, uint256 _amount) external;
816 
817     function destroy(address _from, uint256 _amount) external;
818 }
819 
820 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionStore.sol
821 
822 
823 pragma solidity 0.6.12;
824 
825 
826 
827 
828 
829 /*
830     Liquidity Protection Store interface
831 */
832 interface ILiquidityProtectionStore is IOwned {
833     function withdrawTokens(
834         IERC20Token _token,
835         address _to,
836         uint256 _amount
837     ) external;
838 
839     function protectedLiquidity(uint256 _id)
840         external
841         view
842         returns (
843             address,
844             IDSToken,
845             IERC20Token,
846             uint256,
847             uint256,
848             uint256,
849             uint256,
850             uint256
851         );
852 
853     function addProtectedLiquidity(
854         address _provider,
855         IDSToken _poolToken,
856         IERC20Token _reserveToken,
857         uint256 _poolAmount,
858         uint256 _reserveAmount,
859         uint256 _reserveRateN,
860         uint256 _reserveRateD,
861         uint256 _timestamp
862     ) external returns (uint256);
863 
864     function updateProtectedLiquidityAmounts(
865         uint256 _id,
866         uint256 _poolNewAmount,
867         uint256 _reserveNewAmount
868     ) external;
869 
870     function removeProtectedLiquidity(uint256 _id) external;
871 
872     function lockedBalance(address _provider, uint256 _index) external view returns (uint256, uint256);
873 
874     function lockedBalanceRange(
875         address _provider,
876         uint256 _startIndex,
877         uint256 _endIndex
878     ) external view returns (uint256[] memory, uint256[] memory);
879 
880     function addLockedBalance(
881         address _provider,
882         uint256 _reserveAmount,
883         uint256 _expirationTime
884     ) external returns (uint256);
885 
886     function removeLockedBalance(address _provider, uint256 _index) external;
887 
888     function systemBalance(IERC20Token _poolToken) external view returns (uint256);
889 
890     function incSystemBalance(IERC20Token _poolToken, uint256 _poolAmount) external;
891 
892     function decSystemBalance(IERC20Token _poolToken, uint256 _poolAmount) external;
893 }
894 
895 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionStats.sol
896 
897 
898 pragma solidity 0.6.12;
899 
900 
901 
902 
903 /*
904     Liquidity Protection Stats interface
905 */
906 interface ILiquidityProtectionStats {
907     function increaseTotalAmounts(
908         address provider,
909         IDSToken poolToken,
910         IERC20Token reserveToken,
911         uint256 poolAmount,
912         uint256 reserveAmount
913     ) external;
914 
915     function decreaseTotalAmounts(
916         address provider,
917         IDSToken poolToken,
918         IERC20Token reserveToken,
919         uint256 poolAmount,
920         uint256 reserveAmount
921     ) external;
922 
923     function addProviderPool(address provider, IDSToken poolToken) external returns (bool);
924 
925     function removeProviderPool(address provider, IDSToken poolToken) external returns (bool);
926 
927     function totalPoolAmount(IDSToken poolToken) external view returns (uint256);
928 
929     function totalReserveAmount(IDSToken poolToken, IERC20Token reserveToken) external view returns (uint256);
930 
931     function totalProviderAmount(
932         address provider,
933         IDSToken poolToken,
934         IERC20Token reserveToken
935     ) external view returns (uint256);
936 
937     function providerPools(address provider) external view returns (IDSToken[] memory);
938 }
939 
940 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionSettings.sol
941 
942 
943 pragma solidity 0.6.12;
944 
945 
946 /*
947     Liquidity Protection Store Settings interface
948 */
949 interface ILiquidityProtectionSettings {
950     function addPoolToWhitelist(IConverterAnchor _poolAnchor) external;
951 
952     function removePoolFromWhitelist(IConverterAnchor _poolAnchor) external;
953 
954     function isPoolWhitelisted(IConverterAnchor _poolAnchor) external view returns (bool);
955 
956     function isPoolSupported(IConverterAnchor _poolAnchor) external view returns (bool);
957 
958     function minNetworkTokenLiquidityForMinting() external view returns (uint256);
959 
960     function defaultNetworkTokenMintingLimit() external view returns (uint256);
961 
962     function networkTokenMintingLimits(IConverterAnchor _poolAnchor) external view returns (uint256);
963 
964     function networkTokensMinted(IConverterAnchor _poolAnchor) external view returns (uint256);
965 
966     function incNetworkTokensMinted(IConverterAnchor _poolAnchor, uint256 _amount) external;
967 
968     function decNetworkTokensMinted(IConverterAnchor _poolAnchor, uint256 _amount) external;
969 
970     function minProtectionDelay() external view returns (uint256);
971 
972     function maxProtectionDelay() external view returns (uint256);
973 
974     function setProtectionDelays(uint256 _minProtectionDelay, uint256 _maxProtectionDelay) external;
975 
976     function minNetworkCompensation() external view returns (uint256);
977 
978     function setMinNetworkCompensation(uint256 _minCompensation) external;
979 
980     function lockDuration() external view returns (uint256);
981 
982     function setLockDuration(uint256 _lockDuration) external;
983 
984     function averageRateMaxDeviation() external view returns (uint32);
985 
986     function setAverageRateMaxDeviation(uint32 _averageRateMaxDeviation) external;
987 }
988 
989 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtection.sol
990 
991 
992 pragma solidity 0.6.12;
993 
994 
995 
996 
997 
998 
999 /*
1000     Liquidity Protection interface
1001 */
1002 interface ILiquidityProtection {
1003     function store() external view returns (ILiquidityProtectionStore);
1004 
1005     function stats() external view returns (ILiquidityProtectionStats);
1006 
1007     function settings() external view returns (ILiquidityProtectionSettings);
1008 
1009     function addLiquidityFor(
1010         address owner,
1011         IConverterAnchor poolAnchor,
1012         IERC20Token reserveToken,
1013         uint256 amount
1014     ) external payable returns (uint256);
1015 
1016     function addLiquidity(
1017         IConverterAnchor poolAnchor,
1018         IERC20Token reserveToken,
1019         uint256 amount
1020     ) external payable returns (uint256);
1021 
1022     function removeLiquidity(uint256 id, uint32 portion) external;
1023 }
1024 
1025 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionEventsSubscriber.sol
1026 
1027 
1028 pragma solidity 0.6.12;
1029 
1030 
1031 
1032 /**
1033  * @dev Liquidity protection events subscriber interface
1034  */
1035 interface ILiquidityProtectionEventsSubscriber {
1036     function onAddingLiquidity(
1037         address provider,
1038         IConverterAnchor poolAnchor,
1039         IERC20Token reserveToken,
1040         uint256 poolAmount,
1041         uint256 reserveAmount
1042     ) external;
1043 
1044     function onRemovingLiquidity(
1045         uint256 id,
1046         address provider,
1047         IConverterAnchor poolAnchor,
1048         IERC20Token reserveToken,
1049         uint256 poolAmount,
1050         uint256 reserveAmount
1051     ) external;
1052 }
1053 
1054 // File: solidity/contracts/converter/interfaces/IConverter.sol
1055 
1056 
1057 pragma solidity 0.6.12;
1058 
1059 
1060 
1061 
1062 /*
1063     Converter interface
1064 */
1065 interface IConverter is IOwned {
1066     function converterType() external pure returns (uint16);
1067 
1068     function anchor() external view returns (IConverterAnchor);
1069 
1070     function isActive() external view returns (bool);
1071 
1072     function targetAmountAndFee(
1073         IERC20Token _sourceToken,
1074         IERC20Token _targetToken,
1075         uint256 _amount
1076     ) external view returns (uint256, uint256);
1077 
1078     function convert(
1079         IERC20Token _sourceToken,
1080         IERC20Token _targetToken,
1081         uint256 _amount,
1082         address _trader,
1083         address payable _beneficiary
1084     ) external payable returns (uint256);
1085 
1086     function conversionFee() external view returns (uint32);
1087 
1088     function maxConversionFee() external view returns (uint32);
1089 
1090     function reserveBalance(IERC20Token _reserveToken) external view returns (uint256);
1091 
1092     receive() external payable;
1093 
1094     function transferAnchorOwnership(address _newOwner) external;
1095 
1096     function acceptAnchorOwnership() external;
1097 
1098     function setConversionFee(uint32 _conversionFee) external;
1099 
1100     function withdrawTokens(
1101         IERC20Token _token,
1102         address _to,
1103         uint256 _amount
1104     ) external;
1105 
1106     function withdrawETH(address payable _to) external;
1107 
1108     function addReserve(IERC20Token _token, uint32 _ratio) external;
1109 
1110     // deprecated, backward compatibility
1111     function token() external view returns (IConverterAnchor);
1112 
1113     function transferTokenOwnership(address _newOwner) external;
1114 
1115     function acceptTokenOwnership() external;
1116 
1117     function connectors(IERC20Token _address)
1118         external
1119         view
1120         returns (
1121             uint256,
1122             uint32,
1123             bool,
1124             bool,
1125             bool
1126         );
1127 
1128     function getConnectorBalance(IERC20Token _connectorToken) external view returns (uint256);
1129 
1130     function connectorTokens(uint256 _index) external view returns (IERC20Token);
1131 
1132     function connectorTokenCount() external view returns (uint16);
1133 
1134     /**
1135      * @dev triggered when the converter is activated
1136      *
1137      * @param _type        converter type
1138      * @param _anchor      converter anchor
1139      * @param _activated   true if the converter was activated, false if it was deactivated
1140      */
1141     event Activation(uint16 indexed _type, IConverterAnchor indexed _anchor, bool indexed _activated);
1142 
1143     /**
1144      * @dev triggered when a conversion between two tokens occurs
1145      *
1146      * @param _fromToken       source ERC20 token
1147      * @param _toToken         target ERC20 token
1148      * @param _trader          wallet that initiated the trade
1149      * @param _amount          input amount in units of the source token
1150      * @param _return          output amount minus conversion fee in units of the target token
1151      * @param _conversionFee   conversion fee in units of the target token
1152      */
1153     event Conversion(
1154         IERC20Token indexed _fromToken,
1155         IERC20Token indexed _toToken,
1156         address indexed _trader,
1157         uint256 _amount,
1158         uint256 _return,
1159         int256 _conversionFee
1160     );
1161 
1162     /**
1163      * @dev triggered when the rate between two tokens in the converter changes
1164      * note that the event might be dispatched for rate updates between any two tokens in the converter
1165      *
1166      * @param  _token1 address of the first token
1167      * @param  _token2 address of the second token
1168      * @param  _rateN  rate of 1 unit of `_token1` in `_token2` (numerator)
1169      * @param  _rateD  rate of 1 unit of `_token1` in `_token2` (denominator)
1170      */
1171     event TokenRateUpdate(IERC20Token indexed _token1, IERC20Token indexed _token2, uint256 _rateN, uint256 _rateD);
1172 
1173     /**
1174      * @dev triggered when the conversion fee is updated
1175      *
1176      * @param  _prevFee    previous fee percentage, represented in ppm
1177      * @param  _newFee     new fee percentage, represented in ppm
1178      */
1179     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
1180 }
1181 
1182 // File: solidity/contracts/converter/interfaces/IConverterRegistry.sol
1183 
1184 
1185 pragma solidity 0.6.12;
1186 
1187 
1188 
1189 interface IConverterRegistry {
1190     function getAnchorCount() external view returns (uint256);
1191 
1192     function getAnchors() external view returns (address[] memory);
1193 
1194     function getAnchor(uint256 _index) external view returns (IConverterAnchor);
1195 
1196     function isAnchor(address _value) external view returns (bool);
1197 
1198     function getLiquidityPoolCount() external view returns (uint256);
1199 
1200     function getLiquidityPools() external view returns (address[] memory);
1201 
1202     function getLiquidityPool(uint256 _index) external view returns (IConverterAnchor);
1203 
1204     function isLiquidityPool(address _value) external view returns (bool);
1205 
1206     function getConvertibleTokenCount() external view returns (uint256);
1207 
1208     function getConvertibleTokens() external view returns (address[] memory);
1209 
1210     function getConvertibleToken(uint256 _index) external view returns (IERC20Token);
1211 
1212     function isConvertibleToken(address _value) external view returns (bool);
1213 
1214     function getConvertibleTokenAnchorCount(IERC20Token _convertibleToken) external view returns (uint256);
1215 
1216     function getConvertibleTokenAnchors(IERC20Token _convertibleToken) external view returns (address[] memory);
1217 
1218     function getConvertibleTokenAnchor(IERC20Token _convertibleToken, uint256 _index)
1219         external
1220         view
1221         returns (IConverterAnchor);
1222 
1223     function isConvertibleTokenAnchor(IERC20Token _convertibleToken, address _value) external view returns (bool);
1224 }
1225 
1226 // File: solidity/contracts/liquidity-protection/LiquidityProtection.sol
1227 
1228 
1229 pragma solidity 0.6.12;
1230 
1231 
1232 
1233 
1234 
1235 
1236 
1237 
1238 
1239 
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 
1249 interface ILiquidityPoolConverter is IConverter {
1250     function addLiquidity(
1251         IERC20Token[] memory _reserveTokens,
1252         uint256[] memory _reserveAmounts,
1253         uint256 _minReturn
1254     ) external payable;
1255 
1256     function removeLiquidity(
1257         uint256 _amount,
1258         IERC20Token[] memory _reserveTokens,
1259         uint256[] memory _reserveMinReturnAmounts
1260     ) external;
1261 
1262     function recentAverageRate(IERC20Token _reserveToken) external view returns (uint256, uint256);
1263 }
1264 
1265 /**
1266  * @dev This contract implements the liquidity protection mechanism.
1267  */
1268 contract LiquidityProtection is ILiquidityProtection, TokenHandler, Utils, Owned, ReentrancyGuard, Time {
1269     using SafeMath for uint256;
1270     using MathEx for *;
1271 
1272     struct ProtectedLiquidity {
1273         address provider; // liquidity provider
1274         IDSToken poolToken; // pool token address
1275         IERC20Token reserveToken; // reserve token address
1276         uint256 poolAmount; // pool token amount
1277         uint256 reserveAmount; // reserve token amount
1278         uint256 reserveRateN; // rate of 1 protected reserve token in units of the other reserve token (numerator)
1279         uint256 reserveRateD; // rate of 1 protected reserve token in units of the other reserve token (denominator)
1280         uint256 timestamp; // timestamp
1281     }
1282 
1283     // various rates between the two reserve tokens. the rate is of 1 unit of the protected reserve token in units of the other reserve token
1284     struct PackedRates {
1285         uint128 addSpotRateN; // spot rate of 1 A in units of B when liquidity was added (numerator)
1286         uint128 addSpotRateD; // spot rate of 1 A in units of B when liquidity was added (denominator)
1287         uint128 removeSpotRateN; // spot rate of 1 A in units of B when liquidity is removed (numerator)
1288         uint128 removeSpotRateD; // spot rate of 1 A in units of B when liquidity is removed (denominator)
1289         uint128 removeAverageRateN; // average rate of 1 A in units of B when liquidity is removed (numerator)
1290         uint128 removeAverageRateD; // average rate of 1 A in units of B when liquidity is removed (denominator)
1291     }
1292 
1293     IERC20Token internal constant ETH_RESERVE_ADDRESS = IERC20Token(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
1294     uint32 internal constant PPM_RESOLUTION = 1000000;
1295     uint256 internal constant MAX_UINT128 = 2**128 - 1;
1296     uint256 internal constant MAX_UINT256 = uint256(-1);
1297 
1298     ILiquidityProtectionSettings public immutable override settings;
1299     ILiquidityProtectionStore public immutable override store;
1300     ILiquidityProtectionStats public immutable override stats;
1301     IERC20Token public immutable networkToken;
1302     ITokenGovernance public immutable networkTokenGovernance;
1303     IERC20Token public immutable govToken;
1304     ITokenGovernance public immutable govTokenGovernance;
1305     ICheckpointStore public immutable lastRemoveCheckpointStore;
1306     ILiquidityProtectionEventsSubscriber public eventsSubscriber;
1307 
1308     // true if the contract is currently adding/removing liquidity from a converter, used for accepting ETH
1309     bool private updatingLiquidity = false;
1310 
1311     /**
1312      * @dev updates the event subscriber
1313      *
1314      * @param _prevEventsSubscriber the previous events subscriber
1315      * @param _newEventsSubscriber the new events subscriber
1316      */
1317     event EventSubscriberUpdated(
1318         ILiquidityProtectionEventsSubscriber indexed _prevEventsSubscriber,
1319         ILiquidityProtectionEventsSubscriber indexed _newEventsSubscriber
1320     );
1321 
1322     /**
1323      * @dev initializes a new LiquidityProtection contract
1324      *
1325      * @param _settings liquidity protection settings
1326      * @param _store liquidity protection store
1327      * @param _stats liquidity protection stats
1328      * @param _networkTokenGovernance network token governance
1329      * @param _govTokenGovernance governance token governance
1330      * @param _lastRemoveCheckpointStore last liquidity removal/unprotection checkpoints store
1331      */
1332     constructor(
1333         ILiquidityProtectionSettings _settings,
1334         ILiquidityProtectionStore _store,
1335         ILiquidityProtectionStats _stats,
1336         ITokenGovernance _networkTokenGovernance,
1337         ITokenGovernance _govTokenGovernance,
1338         ICheckpointStore _lastRemoveCheckpointStore
1339     )
1340         public
1341         validAddress(address(_settings))
1342         validAddress(address(_store))
1343         validAddress(address(_stats))
1344         validAddress(address(_networkTokenGovernance))
1345         validAddress(address(_govTokenGovernance))
1346         notThis(address(_settings))
1347         notThis(address(_store))
1348         notThis(address(_stats))
1349         notThis(address(_networkTokenGovernance))
1350         notThis(address(_govTokenGovernance))
1351     {
1352         settings = _settings;
1353         store = _store;
1354         stats = _stats;
1355 
1356         networkTokenGovernance = _networkTokenGovernance;
1357         networkToken = IERC20Token(address(_networkTokenGovernance.token()));
1358         govTokenGovernance = _govTokenGovernance;
1359         govToken = IERC20Token(address(_govTokenGovernance.token()));
1360 
1361         lastRemoveCheckpointStore = _lastRemoveCheckpointStore;
1362     }
1363 
1364     // ensures that the contract is currently removing liquidity from a converter
1365     modifier updatingLiquidityOnly() {
1366         _updatingLiquidityOnly();
1367         _;
1368     }
1369 
1370     // error message binary size optimization
1371     function _updatingLiquidityOnly() internal view {
1372         require(updatingLiquidity, "ERR_NOT_UPDATING_LIQUIDITY");
1373     }
1374 
1375     // ensures that the portion is valid
1376     modifier validPortion(uint32 _portion) {
1377         _validPortion(_portion);
1378         _;
1379     }
1380 
1381     // error message binary size optimization
1382     function _validPortion(uint32 _portion) internal pure {
1383         require(_portion > 0 && _portion <= PPM_RESOLUTION, "ERR_INVALID_PORTION");
1384     }
1385 
1386     // ensures that the pool is supported
1387     modifier poolSupported(IConverterAnchor _poolAnchor) {
1388         _poolSupported(_poolAnchor);
1389         _;
1390     }
1391 
1392     // error message binary size optimization
1393     function _poolSupported(IConverterAnchor _poolAnchor) internal view {
1394         require(settings.isPoolSupported(_poolAnchor), "ERR_POOL_NOT_SUPPORTED");
1395     }
1396 
1397     // ensures that the pool is whitelisted
1398     modifier poolWhitelisted(IConverterAnchor _poolAnchor) {
1399         _poolWhitelisted(_poolAnchor);
1400         _;
1401     }
1402 
1403     // error message binary size optimization
1404     function _poolWhitelisted(IConverterAnchor _poolAnchor) internal view {
1405         require(settings.isPoolWhitelisted(_poolAnchor), "ERR_POOL_NOT_WHITELISTED");
1406     }
1407 
1408     /**
1409      * @dev accept ETH
1410      * used when removing liquidity from ETH converters
1411      */
1412     receive() external payable updatingLiquidityOnly() {}
1413 
1414     /**
1415      * @dev transfers the ownership of the store
1416      * can only be called by the contract owner
1417      *
1418      * @param _newOwner    the new owner of the store
1419      */
1420     function transferStoreOwnership(address _newOwner) external ownerOnly {
1421         store.transferOwnership(_newOwner);
1422     }
1423 
1424     /**
1425      * @dev accepts the ownership of the store
1426      * can only be called by the contract owner
1427      */
1428     function acceptStoreOwnership() external ownerOnly {
1429         store.acceptOwnership();
1430     }
1431 
1432     /**
1433      * @dev sets the events subscriber
1434      */
1435     function setEventsSubscriber(ILiquidityProtectionEventsSubscriber _eventsSubscriber)
1436         external
1437         ownerOnly
1438         validAddress(address(_eventsSubscriber))
1439         notThis(address(_eventsSubscriber))
1440     {
1441         emit EventSubscriberUpdated(eventsSubscriber, _eventsSubscriber);
1442 
1443         eventsSubscriber = _eventsSubscriber;
1444     }
1445 
1446     /**
1447      * @dev adds protected liquidity to a pool for a specific recipient
1448      * also mints new governance tokens for the caller if the caller adds network tokens
1449      *
1450      * @param _owner       protected liquidity owner
1451      * @param _poolAnchor      anchor of the pool
1452      * @param _reserveToken    reserve token to add to the pool
1453      * @param _amount          amount of tokens to add to the pool
1454      * @return new protected liquidity id
1455      */
1456     function addLiquidityFor(
1457         address _owner,
1458         IConverterAnchor _poolAnchor,
1459         IERC20Token _reserveToken,
1460         uint256 _amount
1461     )
1462         external
1463         payable
1464         override
1465         protected
1466         validAddress(_owner)
1467         poolSupported(_poolAnchor)
1468         poolWhitelisted(_poolAnchor)
1469         greaterThanZero(_amount)
1470         returns (uint256)
1471     {
1472         return addLiquidity(_owner, _poolAnchor, _reserveToken, _amount);
1473     }
1474 
1475     /**
1476      * @dev adds protected liquidity to a pool
1477      * also mints new governance tokens for the caller if the caller adds network tokens
1478      *
1479      * @param _poolAnchor      anchor of the pool
1480      * @param _reserveToken    reserve token to add to the pool
1481      * @param _amount          amount of tokens to add to the pool
1482      * @return new protected liquidity id
1483      */
1484     function addLiquidity(
1485         IConverterAnchor _poolAnchor,
1486         IERC20Token _reserveToken,
1487         uint256 _amount
1488     )
1489         external
1490         payable
1491         override
1492         protected
1493         poolSupported(_poolAnchor)
1494         poolWhitelisted(_poolAnchor)
1495         greaterThanZero(_amount)
1496         returns (uint256)
1497     {
1498         return addLiquidity(msg.sender, _poolAnchor, _reserveToken, _amount);
1499     }
1500 
1501     /**
1502      * @dev adds protected liquidity to a pool for a specific recipient
1503      * also mints new governance tokens for the caller if the caller adds network tokens
1504      *
1505      * @param _owner       protected liquidity owner
1506      * @param _poolAnchor      anchor of the pool
1507      * @param _reserveToken    reserve token to add to the pool
1508      * @param _amount          amount of tokens to add to the pool
1509      * @return new protected liquidity id
1510      */
1511     function addLiquidity(
1512         address _owner,
1513         IConverterAnchor _poolAnchor,
1514         IERC20Token _reserveToken,
1515         uint256 _amount
1516     ) private returns (uint256) {
1517         // save a local copy of `networkToken`
1518         IERC20Token networkTokenLocal = networkToken;
1519 
1520         if (_reserveToken == networkTokenLocal) {
1521             require(msg.value == 0, "ERR_ETH_AMOUNT_MISMATCH");
1522             return addNetworkTokenLiquidity(_owner, _poolAnchor, networkTokenLocal, _amount);
1523         }
1524 
1525         // verify that ETH was passed with the call if needed
1526         uint256 val = _reserveToken == ETH_RESERVE_ADDRESS ? _amount : 0;
1527         require(msg.value == val, "ERR_ETH_AMOUNT_MISMATCH");
1528         return addBaseTokenLiquidity(_owner, _poolAnchor, _reserveToken, networkTokenLocal, _amount);
1529     }
1530 
1531     /**
1532      * @dev adds protected network token liquidity to a pool
1533      * also mints new governance tokens for the caller
1534      *
1535      * @param _owner    protected liquidity owner
1536      * @param _poolAnchor   anchor of the pool
1537      * @param _networkToken the network reserve token of the pool
1538      * @param _amount       amount of tokens to add to the pool
1539      * @return new protected liquidity id
1540      */
1541     function addNetworkTokenLiquidity(
1542         address _owner,
1543         IConverterAnchor _poolAnchor,
1544         IERC20Token _networkToken,
1545         uint256 _amount
1546     ) internal returns (uint256) {
1547         IDSToken poolToken = IDSToken(address(_poolAnchor));
1548 
1549         // get the rate between the pool token and the reserve
1550         Fraction memory poolRate = poolTokenRate(poolToken, _networkToken);
1551 
1552         // calculate the amount of pool tokens based on the amount of reserve tokens
1553         uint256 poolTokenAmount = _amount.mul(poolRate.d).div(poolRate.n);
1554 
1555         // remove the pool tokens from the system's ownership (will revert if not enough tokens are available)
1556         store.decSystemBalance(poolToken, poolTokenAmount);
1557 
1558         // add protected liquidity for the recipient
1559         uint256 id = addProtectedLiquidity(_owner, poolToken, _networkToken, poolTokenAmount, _amount);
1560 
1561         // burns the network tokens from the caller. we need to transfer the tokens to the contract itself, since only
1562         // token holders can burn their tokens
1563         safeTransferFrom(_networkToken, msg.sender, address(this), _amount);
1564         networkTokenGovernance.burn(_amount);
1565         settings.decNetworkTokensMinted(_poolAnchor, _amount);
1566 
1567         // mint governance tokens to the recipient
1568         govTokenGovernance.mint(_owner, _amount);
1569 
1570         return id;
1571     }
1572 
1573     /**
1574      * @dev adds protected base token liquidity to a pool
1575      *
1576      * @param _owner    protected liquidity owner
1577      * @param _poolAnchor   anchor of the pool
1578      * @param _baseToken    the base reserve token of the pool
1579      * @param _networkToken the network reserve token of the pool
1580      * @param _amount       amount of tokens to add to the pool
1581      * @return new protected liquidity id
1582      */
1583     function addBaseTokenLiquidity(
1584         address _owner,
1585         IConverterAnchor _poolAnchor,
1586         IERC20Token _baseToken,
1587         IERC20Token _networkToken,
1588         uint256 _amount
1589     ) internal returns (uint256) {
1590         IDSToken poolToken = IDSToken(address(_poolAnchor));
1591 
1592         // get the reserve balances
1593         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolAnchor)));
1594         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) =
1595             converterReserveBalances(converter, _baseToken, _networkToken);
1596 
1597         require(reserveBalanceNetwork >= settings.minNetworkTokenLiquidityForMinting(), "ERR_NOT_ENOUGH_LIQUIDITY");
1598 
1599         // calculate and mint the required amount of network tokens for adding liquidity
1600         uint256 newNetworkLiquidityAmount = _amount.mul(reserveBalanceNetwork).div(reserveBalanceBase);
1601 
1602         // verify network token minting limit
1603         uint256 mintingLimit = settings.networkTokenMintingLimits(_poolAnchor);
1604         if (mintingLimit == 0) {
1605             mintingLimit = settings.defaultNetworkTokenMintingLimit();
1606         }
1607 
1608         uint256 newNetworkTokensMinted = settings.networkTokensMinted(_poolAnchor).add(newNetworkLiquidityAmount);
1609         require(newNetworkTokensMinted <= mintingLimit, "ERR_MAX_AMOUNT_REACHED");
1610 
1611         // issue new network tokens to the system
1612         networkTokenGovernance.mint(address(this), newNetworkLiquidityAmount);
1613         settings.incNetworkTokensMinted(_poolAnchor, newNetworkLiquidityAmount);
1614 
1615         // transfer the base tokens from the caller and approve the converter
1616         ensureAllowance(_networkToken, address(converter), newNetworkLiquidityAmount);
1617         if (_baseToken != ETH_RESERVE_ADDRESS) {
1618             safeTransferFrom(_baseToken, msg.sender, address(this), _amount);
1619             ensureAllowance(_baseToken, address(converter), _amount);
1620         }
1621 
1622         // add liquidity
1623         addLiquidity(converter, _baseToken, _networkToken, _amount, newNetworkLiquidityAmount, msg.value);
1624 
1625         // transfer the new pool tokens to the store
1626         uint256 poolTokenAmount = poolToken.balanceOf(address(this));
1627         safeTransfer(poolToken, address(store), poolTokenAmount);
1628 
1629         // the system splits the pool tokens with the caller
1630         // increase the system's pool token balance and add protected liquidity for the caller
1631         store.incSystemBalance(poolToken, poolTokenAmount - poolTokenAmount / 2); // account for rounding errors
1632         return addProtectedLiquidity(_owner, poolToken, _baseToken, poolTokenAmount / 2, _amount);
1633     }
1634 
1635     /**
1636      * @dev returns the single-side staking limits of a given pool
1637      *
1638      * @param _poolAnchor   anchor of the pool
1639      * @return maximum amount of base tokens that can be single-side staked in the pool
1640      * @return maximum amount of network tokens that can be single-side staked in the pool
1641      */
1642     function poolAvailableSpace(IConverterAnchor _poolAnchor)
1643         external
1644         view
1645         poolSupported(_poolAnchor)
1646         poolWhitelisted(_poolAnchor)
1647         returns (uint256, uint256)
1648     {
1649         IERC20Token networkTokenLocal = networkToken;
1650         return (
1651             baseTokenAvailableSpace(_poolAnchor, networkTokenLocal),
1652             networkTokenAvailableSpace(_poolAnchor, networkTokenLocal)
1653         );
1654     }
1655 
1656     /**
1657      * @dev returns the base-token staking limits of a given pool
1658      *
1659      * @param _poolAnchor   anchor of the pool
1660      * @return maximum amount of base tokens that can be single-side staked in the pool
1661      */
1662     function baseTokenAvailableSpace(IConverterAnchor _poolAnchor)
1663         external
1664         view
1665         poolSupported(_poolAnchor)
1666         poolWhitelisted(_poolAnchor)
1667         returns (uint256)
1668     {
1669         return baseTokenAvailableSpace(_poolAnchor, networkToken);
1670     }
1671 
1672     /**
1673      * @dev returns the network-token staking limits of a given pool
1674      *
1675      * @param _poolAnchor   anchor of the pool
1676      * @return maximum amount of network tokens that can be single-side staked in the pool
1677      */
1678     function networkTokenAvailableSpace(IConverterAnchor _poolAnchor)
1679         external
1680         view
1681         poolSupported(_poolAnchor)
1682         poolWhitelisted(_poolAnchor)
1683         returns (uint256)
1684     {
1685         return networkTokenAvailableSpace(_poolAnchor, networkToken);
1686     }
1687 
1688     /**
1689      * @dev returns the base-token staking limits of a given pool
1690      *
1691      * @param _poolAnchor   anchor of the pool
1692      * @param _networkToken the network token
1693      * @return maximum amount of base tokens that can be single-side staked in the pool
1694      */
1695     function baseTokenAvailableSpace(IConverterAnchor _poolAnchor, IERC20Token _networkToken)
1696         internal
1697         view
1698         returns (uint256)
1699     {
1700         // get the pool converter
1701         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolAnchor)));
1702 
1703         // get the base token
1704         IERC20Token baseToken = converterOtherReserve(converter, _networkToken);
1705 
1706         // get the reserve balances
1707         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) =
1708             converterReserveBalances(converter, baseToken, _networkToken);
1709 
1710         // get the network token minting limit
1711         uint256 mintingLimit = settings.networkTokenMintingLimits(_poolAnchor);
1712         if (mintingLimit == 0) {
1713             mintingLimit = settings.defaultNetworkTokenMintingLimit();
1714         }
1715 
1716         // get the amount of network tokens already minted for the pool
1717         uint256 networkTokensMinted = settings.networkTokensMinted(_poolAnchor);
1718 
1719         // get the amount of network tokens which can minted for the pool
1720         uint256 networkTokensCanBeMinted = MathEx.max(mintingLimit, networkTokensMinted) - networkTokensMinted;
1721 
1722         // return the maximum amount of base token liquidity that can be single-sided staked in the pool
1723         return networkTokensCanBeMinted.mul(reserveBalanceBase).div(reserveBalanceNetwork);
1724     }
1725 
1726     /**
1727      * @dev returns the network-token staking limits of a given pool
1728      *
1729      * @param _poolAnchor   anchor of the pool
1730      * @param _networkToken the network token
1731      * @return maximum amount of network tokens that can be single-side staked in the pool
1732      */
1733     function networkTokenAvailableSpace(IConverterAnchor _poolAnchor, IERC20Token _networkToken)
1734         internal
1735         view
1736         returns (uint256)
1737     {
1738         // get the pool token
1739         IDSToken poolToken = IDSToken(address(_poolAnchor));
1740 
1741         // get the pool token rate
1742         Fraction memory poolRate = poolTokenRate(poolToken, _networkToken);
1743 
1744         // return the maximum amount of network token liquidity that can be single-sided staked in the pool
1745         return store.systemBalance(poolToken).mul(poolRate.n).add(poolRate.n).sub(1).div(poolRate.d);
1746     }
1747 
1748     /**
1749      * @dev returns the expected/actual amounts the provider will receive for removing liquidity
1750      * it's also possible to provide the remove liquidity time to get an estimation
1751      * for the return at that given point
1752      *
1753      * @param _id              protected liquidity id
1754      * @param _portion         portion of liquidity to remove, in PPM
1755      * @param _removeTimestamp time at which the liquidity is removed
1756      * @return expected return amount in the reserve token
1757      * @return actual return amount in the reserve token
1758      * @return compensation in the network token
1759      */
1760     function removeLiquidityReturn(
1761         uint256 _id,
1762         uint32 _portion,
1763         uint256 _removeTimestamp
1764     )
1765         external
1766         view
1767         validPortion(_portion)
1768         returns (
1769             uint256,
1770             uint256,
1771             uint256
1772         )
1773     {
1774         ProtectedLiquidity memory liquidity = protectedLiquidity(_id);
1775 
1776         // verify input
1777         require(liquidity.provider != address(0), "ERR_INVALID_ID");
1778         require(_removeTimestamp >= liquidity.timestamp, "ERR_INVALID_TIMESTAMP");
1779 
1780         // calculate the portion of the liquidity to remove
1781         if (_portion != PPM_RESOLUTION) {
1782             liquidity.poolAmount = liquidity.poolAmount.mul(_portion) / PPM_RESOLUTION;
1783             liquidity.reserveAmount = liquidity.reserveAmount.mul(_portion) / PPM_RESOLUTION;
1784         }
1785 
1786         // get the various rates between the reserves upon adding liquidity and now
1787         PackedRates memory packedRates =
1788             packRates(
1789                 liquidity.poolToken,
1790                 liquidity.reserveToken,
1791                 liquidity.reserveRateN,
1792                 liquidity.reserveRateD,
1793                 false
1794             );
1795 
1796         uint256 targetAmount =
1797             removeLiquidityTargetAmount(
1798                 liquidity.poolToken,
1799                 liquidity.reserveToken,
1800                 liquidity.poolAmount,
1801                 liquidity.reserveAmount,
1802                 packedRates,
1803                 liquidity.timestamp,
1804                 _removeTimestamp
1805             );
1806 
1807         // for network token, the return amount is identical to the target amount
1808         if (liquidity.reserveToken == networkToken) {
1809             return (targetAmount, targetAmount, 0);
1810         }
1811 
1812         // handle base token return
1813 
1814         // calculate the amount of pool tokens required for liquidation
1815         // note that the amount is doubled since it's not possible to liquidate one reserve only
1816         Fraction memory poolRate = poolTokenRate(liquidity.poolToken, liquidity.reserveToken);
1817         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
1818 
1819         // limit the amount of pool tokens by the amount the system/caller holds
1820         uint256 availableBalance = store.systemBalance(liquidity.poolToken).add(liquidity.poolAmount);
1821         poolAmount = poolAmount > availableBalance ? availableBalance : poolAmount;
1822 
1823         // calculate the base token amount received by liquidating the pool tokens
1824         // note that the amount is divided by 2 since the pool amount represents both reserves
1825         uint256 baseAmount = poolAmount.mul(poolRate.n / 2).div(poolRate.d);
1826         uint256 networkAmount = getNetworkCompensation(targetAmount, baseAmount, packedRates);
1827 
1828         return (targetAmount, baseAmount, networkAmount);
1829     }
1830 
1831     /**
1832      * @dev removes protected liquidity from a pool
1833      * also burns governance tokens from the caller if the caller removes network tokens
1834      *
1835      * @param _id      id in the caller's list of protected liquidity
1836      * @param _portion portion of liquidity to remove, in PPM
1837      */
1838     function removeLiquidity(uint256 _id, uint32 _portion) external override protected validPortion(_portion) {
1839         removeLiquidity(msg.sender, _id, _portion);
1840     }
1841 
1842     /**
1843      * @dev removes protected liquidity from a pool
1844      * also burns governance tokens from the caller if the caller removes network tokens
1845      *
1846      * @param _provider protected liquidity provider
1847      * @param _id id in the caller's list of protected liquidity
1848      * @param _portion portion of liquidity to remove, in PPM
1849      */
1850     function removeLiquidity(
1851         address payable _provider,
1852         uint256 _id,
1853         uint32 _portion
1854     ) internal {
1855         ProtectedLiquidity memory liquidity = protectedLiquidity(_id, _provider);
1856 
1857         // save a local copy of `networkToken`
1858         IERC20Token networkTokenLocal = networkToken;
1859 
1860         // verify that the pool is whitelisted
1861         _poolWhitelisted(liquidity.poolToken);
1862 
1863         // verify that the protected liquidity is not removed on the same block in which it was added
1864         require(liquidity.timestamp < time(), "ERR_TOO_EARLY");
1865 
1866         if (_portion == PPM_RESOLUTION) {
1867             // notify event subscribers
1868             if (address(eventsSubscriber) != address(0)) {
1869                 eventsSubscriber.onRemovingLiquidity(
1870                     _id,
1871                     _provider,
1872                     liquidity.poolToken,
1873                     liquidity.reserveToken,
1874                     liquidity.poolAmount,
1875                     liquidity.reserveAmount
1876                 );
1877             }
1878 
1879             // remove the protected liquidity from the provider
1880             store.removeProtectedLiquidity(_id);
1881         } else {
1882             // remove a portion of the protected liquidity from the provider
1883             uint256 fullPoolAmount = liquidity.poolAmount;
1884             uint256 fullReserveAmount = liquidity.reserveAmount;
1885             liquidity.poolAmount = liquidity.poolAmount.mul(_portion) / PPM_RESOLUTION;
1886             liquidity.reserveAmount = liquidity.reserveAmount.mul(_portion) / PPM_RESOLUTION;
1887 
1888             // notify event subscribers
1889             if (address(eventsSubscriber) != address(0)) {
1890                 eventsSubscriber.onRemovingLiquidity(
1891                     _id,
1892                     _provider,
1893                     liquidity.poolToken,
1894                     liquidity.reserveToken,
1895                     liquidity.poolAmount,
1896                     liquidity.reserveAmount
1897                 );
1898             }
1899 
1900             store.updateProtectedLiquidityAmounts(
1901                 _id,
1902                 fullPoolAmount - liquidity.poolAmount,
1903                 fullReserveAmount - liquidity.reserveAmount
1904             );
1905         }
1906 
1907         // update the statistics
1908         stats.decreaseTotalAmounts(
1909             liquidity.provider,
1910             liquidity.poolToken,
1911             liquidity.reserveToken,
1912             liquidity.poolAmount,
1913             liquidity.reserveAmount
1914         );
1915 
1916         // update last liquidity removal checkpoint
1917         lastRemoveCheckpointStore.addCheckpoint(_provider);
1918 
1919         // add the pool tokens to the system
1920         store.incSystemBalance(liquidity.poolToken, liquidity.poolAmount);
1921 
1922         // if removing network token liquidity, burn the governance tokens from the caller. we need to transfer the
1923         // tokens to the contract itself, since only token holders can burn their tokens
1924         if (liquidity.reserveToken == networkTokenLocal) {
1925             safeTransferFrom(govToken, _provider, address(this), liquidity.reserveAmount);
1926             govTokenGovernance.burn(liquidity.reserveAmount);
1927         }
1928 
1929         // get the various rates between the reserves upon adding liquidity and now
1930         PackedRates memory packedRates =
1931             packRates(
1932                 liquidity.poolToken,
1933                 liquidity.reserveToken,
1934                 liquidity.reserveRateN,
1935                 liquidity.reserveRateD,
1936                 true
1937             );
1938 
1939         // get the target token amount
1940         uint256 targetAmount =
1941             removeLiquidityTargetAmount(
1942                 liquidity.poolToken,
1943                 liquidity.reserveToken,
1944                 liquidity.poolAmount,
1945                 liquidity.reserveAmount,
1946                 packedRates,
1947                 liquidity.timestamp,
1948                 time()
1949             );
1950 
1951         // remove network token liquidity
1952         if (liquidity.reserveToken == networkTokenLocal) {
1953             // mint network tokens for the caller and lock them
1954             networkTokenGovernance.mint(address(store), targetAmount);
1955             settings.incNetworkTokensMinted(liquidity.poolToken, targetAmount);
1956             lockTokens(_provider, targetAmount);
1957             return;
1958         }
1959 
1960         // remove base token liquidity
1961 
1962         // calculate the amount of pool tokens required for liquidation
1963         // note that the amount is doubled since it's not possible to liquidate one reserve only
1964         Fraction memory poolRate = poolTokenRate(liquidity.poolToken, liquidity.reserveToken);
1965         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
1966 
1967         // limit the amount of pool tokens by the amount the system holds
1968         uint256 systemBalance = store.systemBalance(liquidity.poolToken);
1969         poolAmount = poolAmount > systemBalance ? systemBalance : poolAmount;
1970 
1971         // withdraw the pool tokens from the store
1972         store.decSystemBalance(liquidity.poolToken, poolAmount);
1973         store.withdrawTokens(liquidity.poolToken, address(this), poolAmount);
1974 
1975         // remove liquidity
1976         removeLiquidity(liquidity.poolToken, poolAmount, liquidity.reserveToken, networkTokenLocal);
1977 
1978         // transfer the base tokens to the caller
1979         uint256 baseBalance;
1980         if (liquidity.reserveToken == ETH_RESERVE_ADDRESS) {
1981             baseBalance = address(this).balance;
1982             _provider.transfer(baseBalance);
1983         } else {
1984             baseBalance = liquidity.reserveToken.balanceOf(address(this));
1985             safeTransfer(liquidity.reserveToken, _provider, baseBalance);
1986         }
1987 
1988         // compensate the caller with network tokens if still needed
1989         uint256 delta = getNetworkCompensation(targetAmount, baseBalance, packedRates);
1990         if (delta > 0) {
1991             // check if there's enough network token balance, otherwise mint more
1992             uint256 networkBalance = networkTokenLocal.balanceOf(address(this));
1993             if (networkBalance < delta) {
1994                 networkTokenGovernance.mint(address(this), delta - networkBalance);
1995             }
1996 
1997             // lock network tokens for the caller
1998             safeTransfer(networkTokenLocal, address(store), delta);
1999             lockTokens(_provider, delta);
2000         }
2001 
2002         // if the contract still holds network tokens, burn them
2003         uint256 networkBalance = networkTokenLocal.balanceOf(address(this));
2004         if (networkBalance > 0) {
2005             networkTokenGovernance.burn(networkBalance);
2006             settings.decNetworkTokensMinted(liquidity.poolToken, networkBalance);
2007         }
2008     }
2009 
2010     /**
2011      * @dev returns the amount the provider will receive for removing liquidity
2012      * it's also possible to provide the remove liquidity rate & time to get an estimation
2013      * for the return at that given point
2014      *
2015      * @param _poolToken       pool token
2016      * @param _reserveToken    reserve token
2017      * @param _poolAmount      pool token amount when the liquidity was added
2018      * @param _reserveAmount   reserve token amount that was added
2019      * @param _packedRates     see `struct PackedRates`
2020      * @param _addTimestamp    time at which the liquidity was added
2021      * @param _removeTimestamp time at which the liquidity is removed
2022      * @return amount received for removing liquidity
2023      */
2024     function removeLiquidityTargetAmount(
2025         IDSToken _poolToken,
2026         IERC20Token _reserveToken,
2027         uint256 _poolAmount,
2028         uint256 _reserveAmount,
2029         PackedRates memory _packedRates,
2030         uint256 _addTimestamp,
2031         uint256 _removeTimestamp
2032     ) internal view returns (uint256) {
2033         // get the rate between the pool token and the reserve token
2034         Fraction memory poolRate = poolTokenRate(_poolToken, _reserveToken);
2035 
2036         // get the rate between the reserves upon adding liquidity and now
2037         Fraction memory addSpotRate = Fraction({ n: _packedRates.addSpotRateN, d: _packedRates.addSpotRateD });
2038         Fraction memory removeSpotRate = Fraction({ n: _packedRates.removeSpotRateN, d: _packedRates.removeSpotRateD });
2039         Fraction memory removeAverageRate =
2040             Fraction({ n: _packedRates.removeAverageRateN, d: _packedRates.removeAverageRateD });
2041 
2042         // calculate the protected amount of reserve tokens plus accumulated fee before compensation
2043         uint256 total = protectedAmountPlusFee(_poolAmount, poolRate, addSpotRate, removeSpotRate);
2044 
2045         // calculate the impermanent loss
2046         Fraction memory loss = impLoss(addSpotRate, removeAverageRate);
2047 
2048         // calculate the protection level
2049         Fraction memory level = protectionLevel(_addTimestamp, _removeTimestamp);
2050 
2051         // calculate the compensation amount
2052         return compensationAmount(_reserveAmount, MathEx.max(_reserveAmount, total), loss, level);
2053     }
2054 
2055     /**
2056      * @dev allows the caller to claim network token balance that is no longer locked
2057      * note that the function can revert if the range is too large
2058      *
2059      * @param _startIndex  start index in the caller's list of locked balances
2060      * @param _endIndex    end index in the caller's list of locked balances (exclusive)
2061      */
2062     function claimBalance(uint256 _startIndex, uint256 _endIndex) external protected {
2063         // get the locked balances from the store
2064         (uint256[] memory amounts, uint256[] memory expirationTimes) =
2065             store.lockedBalanceRange(msg.sender, _startIndex, _endIndex);
2066 
2067         uint256 totalAmount = 0;
2068         uint256 length = amounts.length;
2069         assert(length == expirationTimes.length);
2070 
2071         // reverse iteration since we're removing from the list
2072         for (uint256 i = length; i > 0; i--) {
2073             uint256 index = i - 1;
2074             if (expirationTimes[index] > time()) {
2075                 continue;
2076             }
2077 
2078             // remove the locked balance item
2079             store.removeLockedBalance(msg.sender, _startIndex + index);
2080             totalAmount = totalAmount.add(amounts[index]);
2081         }
2082 
2083         if (totalAmount > 0) {
2084             // transfer the tokens to the caller in a single call
2085             store.withdrawTokens(networkToken, msg.sender, totalAmount);
2086         }
2087     }
2088 
2089     /**
2090      * @dev returns the ROI for removing liquidity in the current state after providing liquidity with the given args
2091      * the function assumes full protection is in effect
2092      * return value is in PPM and can be larger than PPM_RESOLUTION for positive ROI, 1M = 0% ROI
2093      *
2094      * @param _poolToken       pool token
2095      * @param _reserveToken    reserve token
2096      * @param _reserveAmount   reserve token amount that was added
2097      * @param _poolRateN       rate of 1 pool token in reserve token units when the liquidity was added (numerator)
2098      * @param _poolRateD       rate of 1 pool token in reserve token units when the liquidity was added (denominator)
2099      * @param _reserveRateN    rate of 1 reserve token in the other reserve token units when the liquidity was added (numerator)
2100      * @param _reserveRateD    rate of 1 reserve token in the other reserve token units when the liquidity was added (denominator)
2101      * @return ROI in PPM
2102      */
2103     function poolROI(
2104         IDSToken _poolToken,
2105         IERC20Token _reserveToken,
2106         uint256 _reserveAmount,
2107         uint256 _poolRateN,
2108         uint256 _poolRateD,
2109         uint256 _reserveRateN,
2110         uint256 _reserveRateD
2111     ) external view returns (uint256) {
2112         // calculate the amount of pool tokens based on the amount of reserve tokens
2113         uint256 poolAmount = _reserveAmount.mul(_poolRateD).div(_poolRateN);
2114 
2115         // get the various rates between the reserves upon adding liquidity and now
2116         PackedRates memory packedRates = packRates(_poolToken, _reserveToken, _reserveRateN, _reserveRateD, false);
2117 
2118         // get the current return
2119         uint256 protectedReturn =
2120             removeLiquidityTargetAmount(
2121                 _poolToken,
2122                 _reserveToken,
2123                 poolAmount,
2124                 _reserveAmount,
2125                 packedRates,
2126                 time().sub(settings.maxProtectionDelay()),
2127                 time()
2128             );
2129 
2130         // calculate the ROI as the ratio between the current fully protected return and the initial amount
2131         return protectedReturn.mul(PPM_RESOLUTION).div(_reserveAmount);
2132     }
2133 
2134     /**
2135      * @dev adds protected liquidity for the caller to the store
2136      *
2137      * @param _provider        protected liquidity provider
2138      * @param _poolToken       pool token
2139      * @param _reserveToken    reserve token
2140      * @param _poolAmount      amount of pool tokens to protect
2141      * @param _reserveAmount   amount of reserve tokens to protect
2142      * @return new protected liquidity id
2143      */
2144     function addProtectedLiquidity(
2145         address _provider,
2146         IDSToken _poolToken,
2147         IERC20Token _reserveToken,
2148         uint256 _poolAmount,
2149         uint256 _reserveAmount
2150     ) internal returns (uint256) {
2151         // notify event subscribers
2152         if (address(eventsSubscriber) != address(0)) {
2153             eventsSubscriber.onAddingLiquidity(_provider, _poolToken, _reserveToken, _poolAmount, _reserveAmount);
2154         }
2155 
2156         Fraction memory rate = reserveTokenAverageRate(_poolToken, _reserveToken, true);
2157         stats.increaseTotalAmounts(_provider, _poolToken, _reserveToken, _poolAmount, _reserveAmount);
2158         stats.addProviderPool(_provider, _poolToken);
2159         return
2160             store.addProtectedLiquidity(
2161                 _provider,
2162                 _poolToken,
2163                 _reserveToken,
2164                 _poolAmount,
2165                 _reserveAmount,
2166                 rate.n,
2167                 rate.d,
2168                 time()
2169             );
2170     }
2171 
2172     /**
2173      * @dev locks network tokens for the provider and emits the tokens locked event
2174      *
2175      * @param _provider    tokens provider
2176      * @param _amount      amount of network tokens
2177      */
2178     function lockTokens(address _provider, uint256 _amount) internal {
2179         uint256 expirationTime = time().add(settings.lockDuration());
2180         store.addLockedBalance(_provider, _amount, expirationTime);
2181     }
2182 
2183     /**
2184      * @dev returns the rate of 1 pool token in reserve token units
2185      *
2186      * @param _poolToken       pool token
2187      * @param _reserveToken    reserve token
2188      */
2189     function poolTokenRate(IDSToken _poolToken, IERC20Token _reserveToken)
2190         internal
2191         view
2192         virtual
2193         returns (Fraction memory)
2194     {
2195         // get the pool token supply
2196         uint256 poolTokenSupply = _poolToken.totalSupply();
2197 
2198         // get the reserve balance
2199         IConverter converter = IConverter(payable(ownedBy(_poolToken)));
2200         uint256 reserveBalance = converter.getConnectorBalance(_reserveToken);
2201 
2202         // for standard pools, 50% of the pool supply value equals the value of each reserve
2203         return Fraction({ n: reserveBalance.mul(2), d: poolTokenSupply });
2204     }
2205 
2206     /**
2207      * @dev returns the average rate of 1 reserve token in the other reserve token units
2208      *
2209      * @param _poolToken            pool token
2210      * @param _reserveToken         reserve token
2211      * @param _validateAverageRate  true to validate the average rate; false otherwise
2212      */
2213     function reserveTokenAverageRate(
2214         IDSToken _poolToken,
2215         IERC20Token _reserveToken,
2216         bool _validateAverageRate
2217     ) internal view returns (Fraction memory) {
2218         (, , uint256 averageRateN, uint256 averageRateD) =
2219             reserveTokenRates(_poolToken, _reserveToken, _validateAverageRate);
2220         return Fraction(averageRateN, averageRateD);
2221     }
2222 
2223     /**
2224      * @dev returns the spot rate and average rate of 1 reserve token in the other reserve token units
2225      *
2226      * @param _poolToken            pool token
2227      * @param _reserveToken         reserve token
2228      * @param _validateAverageRate  true to validate the average rate; false otherwise
2229      */
2230     function reserveTokenRates(
2231         IDSToken _poolToken,
2232         IERC20Token _reserveToken,
2233         bool _validateAverageRate
2234     )
2235         internal
2236         view
2237         returns (
2238             uint256,
2239             uint256,
2240             uint256,
2241             uint256
2242         )
2243     {
2244         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolToken)));
2245         IERC20Token otherReserve = converterOtherReserve(converter, _reserveToken);
2246 
2247         (uint256 spotRateN, uint256 spotRateD) = converterReserveBalances(converter, otherReserve, _reserveToken);
2248         (uint256 averageRateN, uint256 averageRateD) = converter.recentAverageRate(_reserveToken);
2249 
2250         require(
2251             !_validateAverageRate ||
2252                 averageRateInRange(
2253                     spotRateN,
2254                     spotRateD,
2255                     averageRateN,
2256                     averageRateD,
2257                     settings.averageRateMaxDeviation()
2258                 ),
2259             "ERR_INVALID_RATE"
2260         );
2261 
2262         return (spotRateN, spotRateD, averageRateN, averageRateD);
2263     }
2264 
2265     /**
2266      * @dev returns the various rates between the reserves
2267      *
2268      * @param _poolToken            pool token
2269      * @param _reserveToken         reserve token
2270      * @param _addSpotRateN         add spot rate numerator
2271      * @param _addSpotRateD         add spot rate denominator
2272      * @param _validateAverageRate  true to validate the average rate; false otherwise
2273      * @return see `struct PackedRates`
2274      */
2275     function packRates(
2276         IDSToken _poolToken,
2277         IERC20Token _reserveToken,
2278         uint256 _addSpotRateN,
2279         uint256 _addSpotRateD,
2280         bool _validateAverageRate
2281     ) internal view returns (PackedRates memory) {
2282         (uint256 removeSpotRateN, uint256 removeSpotRateD, uint256 removeAverageRateN, uint256 removeAverageRateD) =
2283             reserveTokenRates(_poolToken, _reserveToken, _validateAverageRate);
2284 
2285         require(
2286             (_addSpotRateN <= MAX_UINT128 && _addSpotRateD <= MAX_UINT128) &&
2287                 (removeSpotRateN <= MAX_UINT128 && removeSpotRateD <= MAX_UINT128) &&
2288                 (removeAverageRateN <= MAX_UINT128 && removeAverageRateD <= MAX_UINT128),
2289             "ERR_INVALID_RATE"
2290         );
2291 
2292         return
2293             PackedRates({
2294                 addSpotRateN: uint128(_addSpotRateN),
2295                 addSpotRateD: uint128(_addSpotRateD),
2296                 removeSpotRateN: uint128(removeSpotRateN),
2297                 removeSpotRateD: uint128(removeSpotRateD),
2298                 removeAverageRateN: uint128(removeAverageRateN),
2299                 removeAverageRateD: uint128(removeAverageRateD)
2300             });
2301     }
2302 
2303     /**
2304      * @dev returns whether or not the deviation of the average rate from the spot rate is within range
2305      * for example, if the maximum permitted deviation is 5%, then return `95/100 <= average/spot <= 100/95`
2306      *
2307      * @param _spotRateN       spot rate numerator
2308      * @param _spotRateD       spot rate denominator
2309      * @param _averageRateN    average rate numerator
2310      * @param _averageRateD    average rate denominator
2311      * @param _maxDeviation    the maximum permitted deviation of the average rate from the spot rate
2312      */
2313     function averageRateInRange(
2314         uint256 _spotRateN,
2315         uint256 _spotRateD,
2316         uint256 _averageRateN,
2317         uint256 _averageRateD,
2318         uint32 _maxDeviation
2319     ) internal pure returns (bool) {
2320         uint256 min =
2321             _spotRateN.mul(_averageRateD).mul(PPM_RESOLUTION - _maxDeviation).mul(PPM_RESOLUTION - _maxDeviation);
2322         uint256 mid = _spotRateD.mul(_averageRateN).mul(PPM_RESOLUTION - _maxDeviation).mul(PPM_RESOLUTION);
2323         uint256 max = _spotRateN.mul(_averageRateD).mul(PPM_RESOLUTION).mul(PPM_RESOLUTION);
2324         return min <= mid && mid <= max;
2325     }
2326 
2327     /**
2328      * @dev utility to add liquidity to a converter
2329      *
2330      * @param _converter       converter
2331      * @param _reserveToken1   reserve token 1
2332      * @param _reserveToken2   reserve token 2
2333      * @param _reserveAmount1  reserve amount 1
2334      * @param _reserveAmount2  reserve amount 2
2335      * @param _value           ETH amount to add
2336      */
2337     function addLiquidity(
2338         ILiquidityPoolConverter _converter,
2339         IERC20Token _reserveToken1,
2340         IERC20Token _reserveToken2,
2341         uint256 _reserveAmount1,
2342         uint256 _reserveAmount2,
2343         uint256 _value
2344     ) internal {
2345         // ensure that the contract can receive ETH
2346         updatingLiquidity = true;
2347 
2348         IERC20Token[] memory reserveTokens = new IERC20Token[](2);
2349         uint256[] memory amounts = new uint256[](2);
2350         reserveTokens[0] = _reserveToken1;
2351         reserveTokens[1] = _reserveToken2;
2352         amounts[0] = _reserveAmount1;
2353         amounts[1] = _reserveAmount2;
2354         _converter.addLiquidity{ value: _value }(reserveTokens, amounts, 1);
2355 
2356         // ensure that the contract can receive ETH
2357         updatingLiquidity = false;
2358     }
2359 
2360     /**
2361      * @dev utility to remove liquidity from a converter
2362      *
2363      * @param _poolToken       pool token of the converter
2364      * @param _poolAmount      amount of pool tokens to remove
2365      * @param _reserveToken1   reserve token 1
2366      * @param _reserveToken2   reserve token 2
2367      */
2368     function removeLiquidity(
2369         IDSToken _poolToken,
2370         uint256 _poolAmount,
2371         IERC20Token _reserveToken1,
2372         IERC20Token _reserveToken2
2373     ) internal {
2374         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolToken)));
2375 
2376         // ensure that the contract can receive ETH
2377         updatingLiquidity = true;
2378 
2379         IERC20Token[] memory reserveTokens = new IERC20Token[](2);
2380         uint256[] memory minReturns = new uint256[](2);
2381         reserveTokens[0] = _reserveToken1;
2382         reserveTokens[1] = _reserveToken2;
2383         minReturns[0] = 1;
2384         minReturns[1] = 1;
2385         converter.removeLiquidity(_poolAmount, reserveTokens, minReturns);
2386 
2387         // ensure that the contract can receive ETH
2388         updatingLiquidity = false;
2389     }
2390 
2391     /**
2392      * @dev returns a protected liquidity from the store
2393      *
2394      * @param _id  protected liquidity id
2395      * @return protected liquidity
2396      */
2397     function protectedLiquidity(uint256 _id) internal view returns (ProtectedLiquidity memory) {
2398         ProtectedLiquidity memory liquidity;
2399         (
2400             liquidity.provider,
2401             liquidity.poolToken,
2402             liquidity.reserveToken,
2403             liquidity.poolAmount,
2404             liquidity.reserveAmount,
2405             liquidity.reserveRateN,
2406             liquidity.reserveRateD,
2407             liquidity.timestamp
2408         ) = store.protectedLiquidity(_id);
2409 
2410         return liquidity;
2411     }
2412 
2413     /**
2414      * @dev returns a protected liquidity from the store
2415      *
2416      * @param _id          protected liquidity id
2417      * @param _provider    authorized provider
2418      * @return protected liquidity
2419      */
2420     function protectedLiquidity(uint256 _id, address _provider) internal view returns (ProtectedLiquidity memory) {
2421         ProtectedLiquidity memory liquidity = protectedLiquidity(_id);
2422         require(liquidity.provider == _provider, "ERR_ACCESS_DENIED");
2423         return liquidity;
2424     }
2425 
2426     /**
2427      * @dev returns the protected amount of reserve tokens plus accumulated fee before compensation
2428      *
2429      * @param _poolAmount      pool token amount when the liquidity was added
2430      * @param _poolRate        rate of 1 pool token in the related reserve token units
2431      * @param _addRate         rate of 1 reserve token in the other reserve token units when the liquidity was added
2432      * @param _removeRate      rate of 1 reserve token in the other reserve token units when the liquidity is removed
2433      * @return protected amount of reserve tokens plus accumulated fee = sqrt(_removeRate / _addRate) * _poolRate * _poolAmount
2434      */
2435     function protectedAmountPlusFee(
2436         uint256 _poolAmount,
2437         Fraction memory _poolRate,
2438         Fraction memory _addRate,
2439         Fraction memory _removeRate
2440     ) internal pure returns (uint256) {
2441         uint256 n = MathEx.ceilSqrt(_addRate.d.mul(_removeRate.n)).mul(_poolRate.n);
2442         uint256 d = MathEx.floorSqrt(_addRate.n.mul(_removeRate.d)).mul(_poolRate.d);
2443 
2444         uint256 x = n * _poolAmount;
2445         if (x / n == _poolAmount) {
2446             return x / d;
2447         }
2448 
2449         (uint256 hi, uint256 lo) = n > _poolAmount ? (n, _poolAmount) : (_poolAmount, n);
2450         (uint256 p, uint256 q) = MathEx.reducedRatio(hi, d, MAX_UINT256 / lo);
2451         uint256 min = (hi / d).mul(lo);
2452 
2453         if (q > 0) {
2454             return MathEx.max(min, (p * lo) / q);
2455         }
2456         return min;
2457     }
2458 
2459     /**
2460      * @dev returns the impermanent loss incurred due to the change in rates between the reserve tokens
2461      *
2462      * @param _prevRate    previous rate between the reserves
2463      * @param _newRate     new rate between the reserves
2464      * @return impermanent loss (as a ratio)
2465      */
2466     function impLoss(Fraction memory _prevRate, Fraction memory _newRate) internal pure returns (Fraction memory) {
2467         uint256 ratioN = _newRate.n.mul(_prevRate.d);
2468         uint256 ratioD = _newRate.d.mul(_prevRate.n);
2469 
2470         uint256 prod = ratioN * ratioD;
2471         uint256 root =
2472             prod / ratioN == ratioD ? MathEx.floorSqrt(prod) : MathEx.floorSqrt(ratioN) * MathEx.floorSqrt(ratioD);
2473         uint256 sum = ratioN.add(ratioD);
2474 
2475         // the arithmetic below is safe because `x + y >= sqrt(x * y) * 2`
2476         if (sum % 2 == 0) {
2477             sum /= 2;
2478             return Fraction({ n: sum - root, d: sum });
2479         }
2480         return Fraction({ n: sum - root * 2, d: sum });
2481     }
2482 
2483     /**
2484      * @dev returns the protection level based on the timestamp and protection delays
2485      *
2486      * @param _addTimestamp    time at which the liquidity was added
2487      * @param _removeTimestamp time at which the liquidity is removed
2488      * @return protection level (as a ratio)
2489      */
2490     function protectionLevel(uint256 _addTimestamp, uint256 _removeTimestamp) internal view returns (Fraction memory) {
2491         uint256 timeElapsed = _removeTimestamp.sub(_addTimestamp);
2492         uint256 minProtectionDelay = settings.minProtectionDelay();
2493         uint256 maxProtectionDelay = settings.maxProtectionDelay();
2494         if (timeElapsed < minProtectionDelay) {
2495             return Fraction({ n: 0, d: 1 });
2496         }
2497 
2498         if (timeElapsed >= maxProtectionDelay) {
2499             return Fraction({ n: 1, d: 1 });
2500         }
2501 
2502         return Fraction({ n: timeElapsed, d: maxProtectionDelay });
2503     }
2504 
2505     /**
2506      * @dev returns the compensation amount based on the impermanent loss and the protection level
2507      *
2508      * @param _amount  protected amount in units of the reserve token
2509      * @param _total   amount plus fee in units of the reserve token
2510      * @param _loss    protection level (as a ratio between 0 and 1)
2511      * @param _level   impermanent loss (as a ratio between 0 and 1)
2512      * @return compensation amount
2513      */
2514     function compensationAmount(
2515         uint256 _amount,
2516         uint256 _total,
2517         Fraction memory _loss,
2518         Fraction memory _level
2519     ) internal pure returns (uint256) {
2520         uint256 levelN = _level.n.mul(_amount);
2521         uint256 levelD = _level.d;
2522         uint256 maxVal = MathEx.max(MathEx.max(levelN, levelD), _total);
2523         (uint256 lossN, uint256 lossD) = MathEx.reducedRatio(_loss.n, _loss.d, MAX_UINT256 / maxVal);
2524         return _total.mul(lossD.sub(lossN)).div(lossD).add(lossN.mul(levelN).div(lossD.mul(levelD)));
2525     }
2526 
2527     function getNetworkCompensation(
2528         uint256 _targetAmount,
2529         uint256 _baseAmount,
2530         PackedRates memory _packedRates
2531     ) internal view returns (uint256) {
2532         if (_targetAmount <= _baseAmount) {
2533             return 0;
2534         }
2535 
2536         // calculate the delta in network tokens
2537         uint256 delta =
2538             (_targetAmount - _baseAmount).mul(_packedRates.removeAverageRateN).div(_packedRates.removeAverageRateD);
2539 
2540         // the delta might be very small due to precision loss
2541         // in which case no compensation will take place (gas optimization)
2542         if (delta >= settings.minNetworkCompensation()) {
2543             return delta;
2544         }
2545 
2546         return 0;
2547     }
2548 
2549     /**
2550      * @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't.
2551      * note that we use the non standard erc-20 interface in which `approve` has no return value so that
2552      * this function will work for both standard and non standard tokens
2553      *
2554      * @param _token   token to check the allowance in
2555      * @param _spender approved address
2556      * @param _value   allowance amount
2557      */
2558     function ensureAllowance(
2559         IERC20Token _token,
2560         address _spender,
2561         uint256 _value
2562     ) private {
2563         uint256 allowance = _token.allowance(address(this), _spender);
2564         if (allowance < _value) {
2565             if (allowance > 0) safeApprove(_token, _spender, 0);
2566             safeApprove(_token, _spender, _value);
2567         }
2568     }
2569 
2570     // utility to get the reserve balances
2571     function converterReserveBalances(
2572         IConverter _converter,
2573         IERC20Token _reserveToken1,
2574         IERC20Token _reserveToken2
2575     ) private view returns (uint256, uint256) {
2576         return (_converter.getConnectorBalance(_reserveToken1), _converter.getConnectorBalance(_reserveToken2));
2577     }
2578 
2579     // utility to get the other reserve
2580     function converterOtherReserve(IConverter _converter, IERC20Token _thisReserve) private view returns (IERC20Token) {
2581         IERC20Token otherReserve = _converter.connectorTokens(0);
2582         return otherReserve != _thisReserve ? otherReserve : _converter.connectorTokens(1);
2583     }
2584 
2585     // utility to get the owner
2586     function ownedBy(IOwned _owned) private view returns (address) {
2587         return _owned.owner();
2588     }
2589 }
