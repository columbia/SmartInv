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
940 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionEventsSubscriber.sol
941 
942 
943 pragma solidity 0.6.12;
944 
945 
946 
947 /**
948  * @dev Liquidity protection events subscriber interface
949  */
950 interface ILiquidityProtectionEventsSubscriber {
951     function onAddingLiquidity(
952         address provider,
953         IConverterAnchor poolAnchor,
954         IERC20Token reserveToken,
955         uint256 poolAmount,
956         uint256 reserveAmount
957     ) external;
958 
959     function onRemovingLiquidity(
960         uint256 id,
961         address provider,
962         IConverterAnchor poolAnchor,
963         IERC20Token reserveToken,
964         uint256 poolAmount,
965         uint256 reserveAmount
966     ) external;
967 }
968 
969 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionSettings.sol
970 
971 
972 pragma solidity 0.6.12;
973 
974 
975 
976 
977 /*
978     Liquidity Protection Store Settings interface
979 */
980 interface ILiquidityProtectionSettings {
981     function isPoolWhitelisted(IConverterAnchor poolAnchor) external view returns (bool);
982 
983     function poolWhitelist() external view returns (address[] memory);
984 
985     function subscribers() external view returns (address[] memory);
986 
987     function isPoolSupported(IConverterAnchor poolAnchor) external view returns (bool);
988 
989     function minNetworkTokenLiquidityForMinting() external view returns (uint256);
990 
991     function defaultNetworkTokenMintingLimit() external view returns (uint256);
992 
993     function networkTokenMintingLimits(IConverterAnchor poolAnchor) external view returns (uint256);
994 
995     function addLiquidityDisabled(IConverterAnchor poolAnchor, IERC20Token reserveToken) external view returns (bool);
996 
997     function minProtectionDelay() external view returns (uint256);
998 
999     function maxProtectionDelay() external view returns (uint256);
1000 
1001     function minNetworkCompensation() external view returns (uint256);
1002 
1003     function lockDuration() external view returns (uint256);
1004 
1005     function averageRateMaxDeviation() external view returns (uint32);
1006 }
1007 
1008 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtectionSystemStore.sol
1009 
1010 
1011 pragma solidity 0.6.12;
1012 
1013 
1014 
1015 /*
1016     Liquidity Protection System Store interface
1017 */
1018 interface ILiquidityProtectionSystemStore {
1019     function systemBalance(IERC20Token poolToken) external view returns (uint256);
1020 
1021     function incSystemBalance(IERC20Token poolToken, uint256 poolAmount) external;
1022 
1023     function decSystemBalance(IERC20Token poolToken, uint256 poolAmount) external;
1024 
1025     function networkTokensMinted(IConverterAnchor poolAnchor) external view returns (uint256);
1026 
1027     function incNetworkTokensMinted(IConverterAnchor poolAnchor, uint256 amount) external;
1028 
1029     function decNetworkTokensMinted(IConverterAnchor poolAnchor, uint256 amount) external;
1030 }
1031 
1032 // File: solidity/contracts/utility/interfaces/ITokenHolder.sol
1033 
1034 
1035 pragma solidity 0.6.12;
1036 
1037 
1038 
1039 /*
1040     Token Holder interface
1041 */
1042 interface ITokenHolder is IOwned {
1043     function withdrawTokens(
1044         IERC20Token _token,
1045         address _to,
1046         uint256 _amount
1047     ) external;
1048 }
1049 
1050 // File: solidity/contracts/liquidity-protection/interfaces/ILiquidityProtection.sol
1051 
1052 
1053 pragma solidity 0.6.12;
1054 
1055 
1056 
1057 
1058 
1059 
1060 
1061 
1062 /*
1063     Liquidity Protection interface
1064 */
1065 interface ILiquidityProtection {
1066     function store() external view returns (ILiquidityProtectionStore);
1067 
1068     function stats() external view returns (ILiquidityProtectionStats);
1069 
1070     function settings() external view returns (ILiquidityProtectionSettings);
1071 
1072     function systemStore() external view returns (ILiquidityProtectionSystemStore);
1073 
1074     function wallet() external view returns (ITokenHolder);
1075 
1076     function addLiquidityFor(
1077         address owner,
1078         IConverterAnchor poolAnchor,
1079         IERC20Token reserveToken,
1080         uint256 amount
1081     ) external payable returns (uint256);
1082 
1083     function addLiquidity(
1084         IConverterAnchor poolAnchor,
1085         IERC20Token reserveToken,
1086         uint256 amount
1087     ) external payable returns (uint256);
1088 
1089     function removeLiquidity(uint256 id, uint32 portion) external;
1090 }
1091 
1092 // File: solidity/contracts/converter/interfaces/IConverter.sol
1093 
1094 
1095 pragma solidity 0.6.12;
1096 
1097 
1098 
1099 
1100 /*
1101     Converter interface
1102 */
1103 interface IConverter is IOwned {
1104     function converterType() external pure returns (uint16);
1105 
1106     function anchor() external view returns (IConverterAnchor);
1107 
1108     function isActive() external view returns (bool);
1109 
1110     function targetAmountAndFee(
1111         IERC20Token _sourceToken,
1112         IERC20Token _targetToken,
1113         uint256 _amount
1114     ) external view returns (uint256, uint256);
1115 
1116     function convert(
1117         IERC20Token _sourceToken,
1118         IERC20Token _targetToken,
1119         uint256 _amount,
1120         address _trader,
1121         address payable _beneficiary
1122     ) external payable returns (uint256);
1123 
1124     function conversionFee() external view returns (uint32);
1125 
1126     function maxConversionFee() external view returns (uint32);
1127 
1128     function reserveBalance(IERC20Token _reserveToken) external view returns (uint256);
1129 
1130     receive() external payable;
1131 
1132     function transferAnchorOwnership(address _newOwner) external;
1133 
1134     function acceptAnchorOwnership() external;
1135 
1136     function setConversionFee(uint32 _conversionFee) external;
1137 
1138     function withdrawTokens(
1139         IERC20Token _token,
1140         address _to,
1141         uint256 _amount
1142     ) external;
1143 
1144     function withdrawETH(address payable _to) external;
1145 
1146     function addReserve(IERC20Token _token, uint32 _ratio) external;
1147 
1148     // deprecated, backward compatibility
1149     function token() external view returns (IConverterAnchor);
1150 
1151     function transferTokenOwnership(address _newOwner) external;
1152 
1153     function acceptTokenOwnership() external;
1154 
1155     function connectors(IERC20Token _address)
1156         external
1157         view
1158         returns (
1159             uint256,
1160             uint32,
1161             bool,
1162             bool,
1163             bool
1164         );
1165 
1166     function getConnectorBalance(IERC20Token _connectorToken) external view returns (uint256);
1167 
1168     function connectorTokens(uint256 _index) external view returns (IERC20Token);
1169 
1170     function connectorTokenCount() external view returns (uint16);
1171 
1172     /**
1173      * @dev triggered when the converter is activated
1174      *
1175      * @param _type        converter type
1176      * @param _anchor      converter anchor
1177      * @param _activated   true if the converter was activated, false if it was deactivated
1178      */
1179     event Activation(uint16 indexed _type, IConverterAnchor indexed _anchor, bool indexed _activated);
1180 
1181     /**
1182      * @dev triggered when a conversion between two tokens occurs
1183      *
1184      * @param _fromToken       source ERC20 token
1185      * @param _toToken         target ERC20 token
1186      * @param _trader          wallet that initiated the trade
1187      * @param _amount          input amount in units of the source token
1188      * @param _return          output amount minus conversion fee in units of the target token
1189      * @param _conversionFee   conversion fee in units of the target token
1190      */
1191     event Conversion(
1192         IERC20Token indexed _fromToken,
1193         IERC20Token indexed _toToken,
1194         address indexed _trader,
1195         uint256 _amount,
1196         uint256 _return,
1197         int256 _conversionFee
1198     );
1199 
1200     /**
1201      * @dev triggered when the rate between two tokens in the converter changes
1202      * note that the event might be dispatched for rate updates between any two tokens in the converter
1203      *
1204      * @param  _token1 address of the first token
1205      * @param  _token2 address of the second token
1206      * @param  _rateN  rate of 1 unit of `_token1` in `_token2` (numerator)
1207      * @param  _rateD  rate of 1 unit of `_token1` in `_token2` (denominator)
1208      */
1209     event TokenRateUpdate(IERC20Token indexed _token1, IERC20Token indexed _token2, uint256 _rateN, uint256 _rateD);
1210 
1211     /**
1212      * @dev triggered when the conversion fee is updated
1213      *
1214      * @param  _prevFee    previous fee percentage, represented in ppm
1215      * @param  _newFee     new fee percentage, represented in ppm
1216      */
1217     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
1218 }
1219 
1220 // File: solidity/contracts/converter/interfaces/IConverterRegistry.sol
1221 
1222 
1223 pragma solidity 0.6.12;
1224 
1225 
1226 
1227 interface IConverterRegistry {
1228     function getAnchorCount() external view returns (uint256);
1229 
1230     function getAnchors() external view returns (address[] memory);
1231 
1232     function getAnchor(uint256 _index) external view returns (IConverterAnchor);
1233 
1234     function isAnchor(address _value) external view returns (bool);
1235 
1236     function getLiquidityPoolCount() external view returns (uint256);
1237 
1238     function getLiquidityPools() external view returns (address[] memory);
1239 
1240     function getLiquidityPool(uint256 _index) external view returns (IConverterAnchor);
1241 
1242     function isLiquidityPool(address _value) external view returns (bool);
1243 
1244     function getConvertibleTokenCount() external view returns (uint256);
1245 
1246     function getConvertibleTokens() external view returns (address[] memory);
1247 
1248     function getConvertibleToken(uint256 _index) external view returns (IERC20Token);
1249 
1250     function isConvertibleToken(address _value) external view returns (bool);
1251 
1252     function getConvertibleTokenAnchorCount(IERC20Token _convertibleToken) external view returns (uint256);
1253 
1254     function getConvertibleTokenAnchors(IERC20Token _convertibleToken) external view returns (address[] memory);
1255 
1256     function getConvertibleTokenAnchor(IERC20Token _convertibleToken, uint256 _index)
1257         external
1258         view
1259         returns (IConverterAnchor);
1260 
1261     function isConvertibleTokenAnchor(IERC20Token _convertibleToken, address _value) external view returns (bool);
1262 }
1263 
1264 // File: solidity/contracts/liquidity-protection/LiquidityProtection.sol
1265 
1266 
1267 pragma solidity 0.6.12;
1268 
1269 
1270 
1271 
1272 
1273 
1274 
1275 
1276 
1277 
1278 
1279 
1280 
1281 
1282 
1283 
1284 
1285 
1286 interface ILiquidityPoolConverter is IConverter {
1287     function addLiquidity(
1288         IERC20Token[] memory _reserveTokens,
1289         uint256[] memory _reserveAmounts,
1290         uint256 _minReturn
1291     ) external payable;
1292 
1293     function removeLiquidity(
1294         uint256 _amount,
1295         IERC20Token[] memory _reserveTokens,
1296         uint256[] memory _reserveMinReturnAmounts
1297     ) external;
1298 
1299     function recentAverageRate(IERC20Token _reserveToken) external view returns (uint256, uint256);
1300 }
1301 
1302 /**
1303  * @dev This contract implements the liquidity protection mechanism.
1304  */
1305 contract LiquidityProtection is ILiquidityProtection, TokenHandler, Utils, Owned, ReentrancyGuard, Time {
1306     using SafeMath for uint256;
1307     using MathEx for *;
1308 
1309     struct ProtectedLiquidity {
1310         address provider; // liquidity provider
1311         IDSToken poolToken; // pool token address
1312         IERC20Token reserveToken; // reserve token address
1313         uint256 poolAmount; // pool token amount
1314         uint256 reserveAmount; // reserve token amount
1315         uint256 reserveRateN; // rate of 1 protected reserve token in units of the other reserve token (numerator)
1316         uint256 reserveRateD; // rate of 1 protected reserve token in units of the other reserve token (denominator)
1317         uint256 timestamp; // timestamp
1318     }
1319 
1320     // various rates between the two reserve tokens. the rate is of 1 unit of the protected reserve token in units of the other reserve token
1321     struct PackedRates {
1322         uint128 addSpotRateN; // spot rate of 1 A in units of B when liquidity was added (numerator)
1323         uint128 addSpotRateD; // spot rate of 1 A in units of B when liquidity was added (denominator)
1324         uint128 removeSpotRateN; // spot rate of 1 A in units of B when liquidity is removed (numerator)
1325         uint128 removeSpotRateD; // spot rate of 1 A in units of B when liquidity is removed (denominator)
1326         uint128 removeAverageRateN; // average rate of 1 A in units of B when liquidity is removed (numerator)
1327         uint128 removeAverageRateD; // average rate of 1 A in units of B when liquidity is removed (denominator)
1328     }
1329 
1330     IERC20Token internal constant ETH_RESERVE_ADDRESS = IERC20Token(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
1331     uint32 internal constant PPM_RESOLUTION = 1000000;
1332     uint256 internal constant MAX_UINT128 = 2**128 - 1;
1333     uint256 internal constant MAX_UINT256 = uint256(-1);
1334 
1335     ILiquidityProtectionSettings public immutable override settings;
1336     ILiquidityProtectionStore public immutable override store;
1337     ILiquidityProtectionStats public immutable override stats;
1338     ILiquidityProtectionSystemStore public immutable override systemStore;
1339     ITokenHolder public immutable override wallet;
1340     IERC20Token public immutable networkToken;
1341     ITokenGovernance public immutable networkTokenGovernance;
1342     IERC20Token public immutable govToken;
1343     ITokenGovernance public immutable govTokenGovernance;
1344     ICheckpointStore public immutable lastRemoveCheckpointStore;
1345 
1346     // true if the contract is currently adding/removing liquidity from a converter, used for accepting ETH
1347     bool private updatingLiquidity = false;
1348 
1349     /**
1350      * @dev initializes a new LiquidityProtection contract
1351      *
1352      * @param _contractAddresses:
1353      * - [0] liquidity protection settings
1354      * - [1] liquidity protection store
1355      * - [2] liquidity protection stats
1356      * - [3] liquidity protection system store
1357      * - [4] liquidity protection wallet
1358      * - [5] network token governance
1359      * - [6] governance token governance
1360      * - [7] last liquidity removal/unprotection checkpoints store
1361      */
1362     constructor(address[8] memory _contractAddresses) public {
1363         for (uint256 i = 0; i < _contractAddresses.length; i++) {
1364             _validAddress(_contractAddresses[i]);
1365         }
1366 
1367         settings = ILiquidityProtectionSettings(_contractAddresses[0]);
1368         store = ILiquidityProtectionStore(_contractAddresses[1]);
1369         stats = ILiquidityProtectionStats(_contractAddresses[2]);
1370         systemStore = ILiquidityProtectionSystemStore(_contractAddresses[3]);
1371         wallet = ITokenHolder(_contractAddresses[4]);
1372         networkTokenGovernance = ITokenGovernance(_contractAddresses[5]);
1373         govTokenGovernance = ITokenGovernance(_contractAddresses[6]);
1374         lastRemoveCheckpointStore = ICheckpointStore(_contractAddresses[7]);
1375 
1376         networkToken = IERC20Token(address(ITokenGovernance(_contractAddresses[5]).token()));
1377         govToken = IERC20Token(address(ITokenGovernance(_contractAddresses[6]).token()));
1378     }
1379 
1380     // ensures that the contract is currently removing liquidity from a converter
1381     modifier updatingLiquidityOnly() {
1382         require(updatingLiquidity, "ERR_NOT_UPDATING_LIQUIDITY");
1383         _;
1384     }
1385 
1386     // ensures that the portion is valid
1387     modifier validPortion(uint32 _portion) {
1388         _validPortion(_portion);
1389         _;
1390     }
1391 
1392     // error message binary size optimization
1393     function _validPortion(uint32 _portion) internal pure {
1394         require(_portion > 0 && _portion <= PPM_RESOLUTION, "ERR_INVALID_PORTION");
1395     }
1396 
1397     // ensures that the pool is supported and whitelisted
1398     modifier poolSupportedAndWhitelisted(IConverterAnchor _poolAnchor) {
1399         _poolSupported(_poolAnchor);
1400         _poolWhitelisted(_poolAnchor);
1401         _;
1402     }
1403 
1404     // ensures that add liquidity is enabled
1405     modifier addLiquidityEnabled(IConverterAnchor _poolAnchor, IERC20Token _reserveToken) {
1406         _addLiquidityEnabled(_poolAnchor, _reserveToken);
1407         _;
1408     }
1409 
1410     // error message binary size optimization
1411     function _poolSupported(IConverterAnchor _poolAnchor) internal view {
1412         require(settings.isPoolSupported(_poolAnchor), "ERR_POOL_NOT_SUPPORTED");
1413     }
1414 
1415     // error message binary size optimization
1416     function _poolWhitelisted(IConverterAnchor _poolAnchor) internal view {
1417         require(settings.isPoolWhitelisted(_poolAnchor), "ERR_POOL_NOT_WHITELISTED");
1418     }
1419 
1420     // error message binary size optimization
1421     function _addLiquidityEnabled(IConverterAnchor _poolAnchor, IERC20Token _reserveToken) internal view {
1422         require(!settings.addLiquidityDisabled(_poolAnchor, _reserveToken), "ERR_ADD_LIQUIDITY_DISABLED");
1423     }
1424 
1425     // error message binary size optimization
1426     function verifyEthAmount(uint256 _value) internal view {
1427         require(msg.value == _value, "ERR_ETH_AMOUNT_MISMATCH");
1428     }
1429 
1430     /**
1431      * @dev accept ETH
1432      * used when removing liquidity from ETH converters
1433      */
1434     receive() external payable updatingLiquidityOnly() {}
1435 
1436     /**
1437      * @dev transfers the ownership of the store
1438      * can only be called by the contract owner
1439      *
1440      * @param _newOwner    the new owner of the store
1441      */
1442     function transferStoreOwnership(address _newOwner) external ownerOnly {
1443         store.transferOwnership(_newOwner);
1444     }
1445 
1446     /**
1447      * @dev accepts the ownership of the store
1448      * can only be called by the contract owner
1449      */
1450     function acceptStoreOwnership() external ownerOnly {
1451         store.acceptOwnership();
1452     }
1453 
1454     /**
1455      * @dev transfers the ownership of the wallet
1456      * can only be called by the contract owner
1457      *
1458      * @param _newOwner    the new owner of the wallet
1459      */
1460     function transferWalletOwnership(address _newOwner) external ownerOnly {
1461         wallet.transferOwnership(_newOwner);
1462     }
1463 
1464     /**
1465      * @dev accepts the ownership of the wallet
1466      * can only be called by the contract owner
1467      */
1468     function acceptWalletOwnership() external ownerOnly {
1469         wallet.acceptOwnership();
1470     }
1471 
1472     /**
1473      * @dev adds protected liquidity to a pool for a specific recipient
1474      * also mints new governance tokens for the caller if the caller adds network tokens
1475      *
1476      * @param _owner       protected liquidity owner
1477      * @param _poolAnchor      anchor of the pool
1478      * @param _reserveToken    reserve token to add to the pool
1479      * @param _amount          amount of tokens to add to the pool
1480      * @return new protected liquidity id
1481      */
1482     function addLiquidityFor(
1483         address _owner,
1484         IConverterAnchor _poolAnchor,
1485         IERC20Token _reserveToken,
1486         uint256 _amount
1487     )
1488         external
1489         payable
1490         override
1491         protected
1492         validAddress(_owner)
1493         poolSupportedAndWhitelisted(_poolAnchor)
1494         addLiquidityEnabled(_poolAnchor, _reserveToken)
1495         greaterThanZero(_amount)
1496         returns (uint256)
1497     {
1498         return addLiquidity(_owner, _poolAnchor, _reserveToken, _amount);
1499     }
1500 
1501     /**
1502      * @dev adds protected liquidity to a pool
1503      * also mints new governance tokens for the caller if the caller adds network tokens
1504      *
1505      * @param _poolAnchor      anchor of the pool
1506      * @param _reserveToken    reserve token to add to the pool
1507      * @param _amount          amount of tokens to add to the pool
1508      * @return new protected liquidity id
1509      */
1510     function addLiquidity(
1511         IConverterAnchor _poolAnchor,
1512         IERC20Token _reserveToken,
1513         uint256 _amount
1514     )
1515         external
1516         payable
1517         override
1518         protected
1519         poolSupportedAndWhitelisted(_poolAnchor)
1520         addLiquidityEnabled(_poolAnchor, _reserveToken)
1521         greaterThanZero(_amount)
1522         returns (uint256)
1523     {
1524         return addLiquidity(msg.sender, _poolAnchor, _reserveToken, _amount);
1525     }
1526 
1527     /**
1528      * @dev adds protected liquidity to a pool for a specific recipient
1529      * also mints new governance tokens for the caller if the caller adds network tokens
1530      *
1531      * @param _owner       protected liquidity owner
1532      * @param _poolAnchor      anchor of the pool
1533      * @param _reserveToken    reserve token to add to the pool
1534      * @param _amount          amount of tokens to add to the pool
1535      * @return new protected liquidity id
1536      */
1537     function addLiquidity(
1538         address _owner,
1539         IConverterAnchor _poolAnchor,
1540         IERC20Token _reserveToken,
1541         uint256 _amount
1542     ) private returns (uint256) {
1543         // save a local copy of `networkToken`
1544         IERC20Token networkTokenLocal = networkToken;
1545 
1546         if (_reserveToken == networkTokenLocal) {
1547             verifyEthAmount(0);
1548             return addNetworkTokenLiquidity(_owner, _poolAnchor, networkTokenLocal, _amount);
1549         }
1550 
1551         // verify that ETH was passed with the call if needed
1552         verifyEthAmount(_reserveToken == ETH_RESERVE_ADDRESS ? _amount : 0);
1553         return addBaseTokenLiquidity(_owner, _poolAnchor, _reserveToken, networkTokenLocal, _amount);
1554     }
1555 
1556     /**
1557      * @dev adds protected network token liquidity to a pool
1558      * also mints new governance tokens for the caller
1559      *
1560      * @param _owner    protected liquidity owner
1561      * @param _poolAnchor   anchor of the pool
1562      * @param _networkToken the network reserve token of the pool
1563      * @param _amount       amount of tokens to add to the pool
1564      * @return new protected liquidity id
1565      */
1566     function addNetworkTokenLiquidity(
1567         address _owner,
1568         IConverterAnchor _poolAnchor,
1569         IERC20Token _networkToken,
1570         uint256 _amount
1571     ) internal returns (uint256) {
1572         IDSToken poolToken = IDSToken(address(_poolAnchor));
1573 
1574         // get the rate between the pool token and the reserve
1575         Fraction memory poolRate = poolTokenRate(poolToken, _networkToken);
1576 
1577         // calculate the amount of pool tokens based on the amount of reserve tokens
1578         uint256 poolTokenAmount = _amount.mul(poolRate.d).div(poolRate.n);
1579 
1580         // remove the pool tokens from the system's ownership (will revert if not enough tokens are available)
1581         systemStore.decSystemBalance(poolToken, poolTokenAmount);
1582 
1583         // add protected liquidity for the recipient
1584         uint256 id = addProtectedLiquidity(_owner, poolToken, _networkToken, poolTokenAmount, _amount);
1585 
1586         // burns the network tokens from the caller. we need to transfer the tokens to the contract itself, since only
1587         // token holders can burn their tokens
1588         safeTransferFrom(_networkToken, msg.sender, address(this), _amount);
1589         burnNetworkTokens(_poolAnchor, _amount);
1590 
1591         // mint governance tokens to the recipient
1592         govTokenGovernance.mint(_owner, _amount);
1593 
1594         return id;
1595     }
1596 
1597     /**
1598      * @dev adds protected base token liquidity to a pool
1599      *
1600      * @param _owner    protected liquidity owner
1601      * @param _poolAnchor   anchor of the pool
1602      * @param _baseToken    the base reserve token of the pool
1603      * @param _networkToken the network reserve token of the pool
1604      * @param _amount       amount of tokens to add to the pool
1605      * @return new protected liquidity id
1606      */
1607     function addBaseTokenLiquidity(
1608         address _owner,
1609         IConverterAnchor _poolAnchor,
1610         IERC20Token _baseToken,
1611         IERC20Token _networkToken,
1612         uint256 _amount
1613     ) internal returns (uint256) {
1614         IDSToken poolToken = IDSToken(address(_poolAnchor));
1615 
1616         // get the reserve balances
1617         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolAnchor)));
1618         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) =
1619             converterReserveBalances(converter, _baseToken, _networkToken);
1620 
1621         require(reserveBalanceNetwork >= settings.minNetworkTokenLiquidityForMinting(), "ERR_NOT_ENOUGH_LIQUIDITY");
1622 
1623         // calculate and mint the required amount of network tokens for adding liquidity
1624         uint256 newNetworkLiquidityAmount = _amount.mul(reserveBalanceNetwork).div(reserveBalanceBase);
1625 
1626         // verify network token minting limit
1627         uint256 mintingLimit = settings.networkTokenMintingLimits(_poolAnchor);
1628         if (mintingLimit == 0) {
1629             mintingLimit = settings.defaultNetworkTokenMintingLimit();
1630         }
1631 
1632         uint256 newNetworkTokensMinted = systemStore.networkTokensMinted(_poolAnchor).add(newNetworkLiquidityAmount);
1633         require(newNetworkTokensMinted <= mintingLimit, "ERR_MAX_AMOUNT_REACHED");
1634 
1635         // issue new network tokens to the system
1636         mintNetworkTokens(address(this), _poolAnchor, newNetworkLiquidityAmount);
1637 
1638         // transfer the base tokens from the caller and approve the converter
1639         ensureAllowance(_networkToken, address(converter), newNetworkLiquidityAmount);
1640         if (_baseToken != ETH_RESERVE_ADDRESS) {
1641             safeTransferFrom(_baseToken, msg.sender, address(this), _amount);
1642             ensureAllowance(_baseToken, address(converter), _amount);
1643         }
1644 
1645         // add liquidity
1646         addLiquidity(converter, _baseToken, _networkToken, _amount, newNetworkLiquidityAmount, msg.value);
1647 
1648         // transfer the new pool tokens to the wallet
1649         uint256 poolTokenAmount = poolToken.balanceOf(address(this));
1650         safeTransfer(poolToken, address(wallet), poolTokenAmount);
1651 
1652         // the system splits the pool tokens with the caller
1653         // increase the system's pool token balance and add protected liquidity for the caller
1654         systemStore.incSystemBalance(poolToken, poolTokenAmount - poolTokenAmount / 2); // account for rounding errors
1655         return addProtectedLiquidity(_owner, poolToken, _baseToken, poolTokenAmount / 2, _amount);
1656     }
1657 
1658     /**
1659      * @dev returns the single-side staking limits of a given pool
1660      *
1661      * @param _poolAnchor   anchor of the pool
1662      * @return maximum amount of base tokens that can be single-side staked in the pool
1663      * @return maximum amount of network tokens that can be single-side staked in the pool
1664      */
1665     function poolAvailableSpace(IConverterAnchor _poolAnchor)
1666         external
1667         view
1668         poolSupportedAndWhitelisted(_poolAnchor)
1669         returns (uint256, uint256)
1670     {
1671         IERC20Token networkTokenLocal = networkToken;
1672         return (
1673             baseTokenAvailableSpace(_poolAnchor, networkTokenLocal),
1674             networkTokenAvailableSpace(_poolAnchor, networkTokenLocal)
1675         );
1676     }
1677 
1678     /**
1679      * @dev returns the base-token staking limits of a given pool
1680      *
1681      * @param _poolAnchor   anchor of the pool
1682      * @return maximum amount of base tokens that can be single-side staked in the pool
1683      */
1684     function baseTokenAvailableSpace(IConverterAnchor _poolAnchor)
1685         external
1686         view
1687         poolSupportedAndWhitelisted(_poolAnchor)
1688         returns (uint256)
1689     {
1690         return baseTokenAvailableSpace(_poolAnchor, networkToken);
1691     }
1692 
1693     /**
1694      * @dev returns the network-token staking limits of a given pool
1695      *
1696      * @param _poolAnchor   anchor of the pool
1697      * @return maximum amount of network tokens that can be single-side staked in the pool
1698      */
1699     function networkTokenAvailableSpace(IConverterAnchor _poolAnchor)
1700         external
1701         view
1702         poolSupportedAndWhitelisted(_poolAnchor)
1703         returns (uint256)
1704     {
1705         return networkTokenAvailableSpace(_poolAnchor, networkToken);
1706     }
1707 
1708     /**
1709      * @dev returns the base-token staking limits of a given pool
1710      *
1711      * @param _poolAnchor   anchor of the pool
1712      * @param _networkToken the network token
1713      * @return maximum amount of base tokens that can be single-side staked in the pool
1714      */
1715     function baseTokenAvailableSpace(IConverterAnchor _poolAnchor, IERC20Token _networkToken)
1716         internal
1717         view
1718         returns (uint256)
1719     {
1720         // get the pool converter
1721         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolAnchor)));
1722 
1723         // get the base token
1724         IERC20Token baseToken = converterOtherReserve(converter, _networkToken);
1725 
1726         // get the reserve balances
1727         (uint256 reserveBalanceBase, uint256 reserveBalanceNetwork) =
1728             converterReserveBalances(converter, baseToken, _networkToken);
1729 
1730         // get the network token minting limit
1731         uint256 mintingLimit = settings.networkTokenMintingLimits(_poolAnchor);
1732         if (mintingLimit == 0) {
1733             mintingLimit = settings.defaultNetworkTokenMintingLimit();
1734         }
1735 
1736         // get the amount of network tokens already minted for the pool
1737         uint256 networkTokensMinted = systemStore.networkTokensMinted(_poolAnchor);
1738 
1739         // get the amount of network tokens which can minted for the pool
1740         uint256 networkTokensCanBeMinted = MathEx.max(mintingLimit, networkTokensMinted) - networkTokensMinted;
1741 
1742         // return the maximum amount of base token liquidity that can be single-sided staked in the pool
1743         return networkTokensCanBeMinted.mul(reserveBalanceBase).div(reserveBalanceNetwork);
1744     }
1745 
1746     /**
1747      * @dev returns the network-token staking limits of a given pool
1748      *
1749      * @param _poolAnchor   anchor of the pool
1750      * @param _networkToken the network token
1751      * @return maximum amount of network tokens that can be single-side staked in the pool
1752      */
1753     function networkTokenAvailableSpace(IConverterAnchor _poolAnchor, IERC20Token _networkToken)
1754         internal
1755         view
1756         returns (uint256)
1757     {
1758         // get the pool token
1759         IDSToken poolToken = IDSToken(address(_poolAnchor));
1760 
1761         // get the pool token rate
1762         Fraction memory poolRate = poolTokenRate(poolToken, _networkToken);
1763 
1764         // return the maximum amount of network token liquidity that can be single-sided staked in the pool
1765         return systemStore.systemBalance(poolToken).mul(poolRate.n).add(poolRate.n).sub(1).div(poolRate.d);
1766     }
1767 
1768     /**
1769      * @dev returns the expected/actual amounts the provider will receive for removing liquidity
1770      * it's also possible to provide the remove liquidity time to get an estimation
1771      * for the return at that given point
1772      *
1773      * @param _id              protected liquidity id
1774      * @param _portion         portion of liquidity to remove, in PPM
1775      * @param _removeTimestamp time at which the liquidity is removed
1776      * @return expected return amount in the reserve token
1777      * @return actual return amount in the reserve token
1778      * @return compensation in the network token
1779      */
1780     function removeLiquidityReturn(
1781         uint256 _id,
1782         uint32 _portion,
1783         uint256 _removeTimestamp
1784     )
1785         external
1786         view
1787         validPortion(_portion)
1788         returns (
1789             uint256,
1790             uint256,
1791             uint256
1792         )
1793     {
1794         ProtectedLiquidity memory liquidity = protectedLiquidity(_id);
1795 
1796         // verify input
1797         require(liquidity.provider != address(0), "ERR_INVALID_ID");
1798         require(_removeTimestamp >= liquidity.timestamp, "ERR_INVALID_TIMESTAMP");
1799 
1800         // calculate the portion of the liquidity to remove
1801         if (_portion != PPM_RESOLUTION) {
1802             liquidity.poolAmount = liquidity.poolAmount.mul(_portion) / PPM_RESOLUTION;
1803             liquidity.reserveAmount = liquidity.reserveAmount.mul(_portion) / PPM_RESOLUTION;
1804         }
1805 
1806         // get the various rates between the reserves upon adding liquidity and now
1807         PackedRates memory packedRates =
1808             packRates(
1809                 liquidity.poolToken,
1810                 liquidity.reserveToken,
1811                 liquidity.reserveRateN,
1812                 liquidity.reserveRateD,
1813                 false
1814             );
1815 
1816         uint256 targetAmount =
1817             removeLiquidityTargetAmount(
1818                 liquidity.poolToken,
1819                 liquidity.reserveToken,
1820                 liquidity.poolAmount,
1821                 liquidity.reserveAmount,
1822                 packedRates,
1823                 liquidity.timestamp,
1824                 _removeTimestamp
1825             );
1826 
1827         // for network token, the return amount is identical to the target amount
1828         if (liquidity.reserveToken == networkToken) {
1829             return (targetAmount, targetAmount, 0);
1830         }
1831 
1832         // handle base token return
1833 
1834         // calculate the amount of pool tokens required for liquidation
1835         // note that the amount is doubled since it's not possible to liquidate one reserve only
1836         Fraction memory poolRate = poolTokenRate(liquidity.poolToken, liquidity.reserveToken);
1837         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
1838 
1839         // limit the amount of pool tokens by the amount the system/caller holds
1840         uint256 availableBalance = systemStore.systemBalance(liquidity.poolToken).add(liquidity.poolAmount);
1841         poolAmount = poolAmount > availableBalance ? availableBalance : poolAmount;
1842 
1843         // calculate the base token amount received by liquidating the pool tokens
1844         // note that the amount is divided by 2 since the pool amount represents both reserves
1845         uint256 baseAmount = poolAmount.mul(poolRate.n / 2).div(poolRate.d);
1846         uint256 networkAmount = getNetworkCompensation(targetAmount, baseAmount, packedRates);
1847 
1848         return (targetAmount, baseAmount, networkAmount);
1849     }
1850 
1851     /**
1852      * @dev removes protected liquidity from a pool
1853      * also burns governance tokens from the caller if the caller removes network tokens
1854      *
1855      * @param _id      id in the caller's list of protected liquidity
1856      * @param _portion portion of liquidity to remove, in PPM
1857      */
1858     function removeLiquidity(uint256 _id, uint32 _portion) external override protected validPortion(_portion) {
1859         removeLiquidity(msg.sender, _id, _portion);
1860     }
1861 
1862     /**
1863      * @dev removes protected liquidity from a pool
1864      * also burns governance tokens from the caller if the caller removes network tokens
1865      *
1866      * @param _provider protected liquidity provider
1867      * @param _id id in the caller's list of protected liquidity
1868      * @param _portion portion of liquidity to remove, in PPM
1869      */
1870     function removeLiquidity(
1871         address payable _provider,
1872         uint256 _id,
1873         uint32 _portion
1874     ) internal {
1875         ProtectedLiquidity memory liquidity = protectedLiquidity(_id, _provider);
1876 
1877         // save a local copy of `networkToken`
1878         IERC20Token networkTokenLocal = networkToken;
1879 
1880         // verify that the pool is whitelisted
1881         _poolWhitelisted(liquidity.poolToken);
1882 
1883         // verify that the protected liquidity is not removed on the same block in which it was added
1884         require(liquidity.timestamp < time(), "ERR_TOO_EARLY");
1885 
1886         if (_portion == PPM_RESOLUTION) {
1887             // notify event subscribers
1888             notifyEventSubscribersOnRemovingLiquidity(
1889                 _id,
1890                 _provider,
1891                 liquidity.poolToken,
1892                 liquidity.reserveToken,
1893                 liquidity.poolAmount,
1894                 liquidity.reserveAmount
1895             );
1896 
1897             // remove the protected liquidity from the provider
1898             store.removeProtectedLiquidity(_id);
1899         } else {
1900             // remove a portion of the protected liquidity from the provider
1901             uint256 fullPoolAmount = liquidity.poolAmount;
1902             uint256 fullReserveAmount = liquidity.reserveAmount;
1903             liquidity.poolAmount = liquidity.poolAmount.mul(_portion) / PPM_RESOLUTION;
1904             liquidity.reserveAmount = liquidity.reserveAmount.mul(_portion) / PPM_RESOLUTION;
1905 
1906             // notify event subscribers
1907             notifyEventSubscribersOnRemovingLiquidity(
1908                 _id,
1909                 _provider,
1910                 liquidity.poolToken,
1911                 liquidity.reserveToken,
1912                 liquidity.poolAmount,
1913                 liquidity.reserveAmount
1914             );
1915 
1916             store.updateProtectedLiquidityAmounts(
1917                 _id,
1918                 fullPoolAmount - liquidity.poolAmount,
1919                 fullReserveAmount - liquidity.reserveAmount
1920             );
1921         }
1922 
1923         // update the statistics
1924         stats.decreaseTotalAmounts(
1925             liquidity.provider,
1926             liquidity.poolToken,
1927             liquidity.reserveToken,
1928             liquidity.poolAmount,
1929             liquidity.reserveAmount
1930         );
1931 
1932         // update last liquidity removal checkpoint
1933         lastRemoveCheckpointStore.addCheckpoint(_provider);
1934 
1935         // add the pool tokens to the system
1936         systemStore.incSystemBalance(liquidity.poolToken, liquidity.poolAmount);
1937 
1938         // if removing network token liquidity, burn the governance tokens from the caller. we need to transfer the
1939         // tokens to the contract itself, since only token holders can burn their tokens
1940         if (liquidity.reserveToken == networkTokenLocal) {
1941             safeTransferFrom(govToken, _provider, address(this), liquidity.reserveAmount);
1942             govTokenGovernance.burn(liquidity.reserveAmount);
1943         }
1944 
1945         // get the various rates between the reserves upon adding liquidity and now
1946         PackedRates memory packedRates =
1947             packRates(
1948                 liquidity.poolToken,
1949                 liquidity.reserveToken,
1950                 liquidity.reserveRateN,
1951                 liquidity.reserveRateD,
1952                 true
1953             );
1954 
1955         // get the target token amount
1956         uint256 targetAmount =
1957             removeLiquidityTargetAmount(
1958                 liquidity.poolToken,
1959                 liquidity.reserveToken,
1960                 liquidity.poolAmount,
1961                 liquidity.reserveAmount,
1962                 packedRates,
1963                 liquidity.timestamp,
1964                 time()
1965             );
1966 
1967         // remove network token liquidity
1968         if (liquidity.reserveToken == networkTokenLocal) {
1969             // mint network tokens for the caller and lock them
1970             mintNetworkTokens(address(wallet), liquidity.poolToken, targetAmount);
1971             lockTokens(_provider, targetAmount);
1972             return;
1973         }
1974 
1975         // remove base token liquidity
1976 
1977         // calculate the amount of pool tokens required for liquidation
1978         // note that the amount is doubled since it's not possible to liquidate one reserve only
1979         Fraction memory poolRate = poolTokenRate(liquidity.poolToken, liquidity.reserveToken);
1980         uint256 poolAmount = targetAmount.mul(poolRate.d).div(poolRate.n / 2);
1981 
1982         // limit the amount of pool tokens by the amount the system holds
1983         uint256 systemBalance = systemStore.systemBalance(liquidity.poolToken);
1984         poolAmount = poolAmount > systemBalance ? systemBalance : poolAmount;
1985 
1986         // withdraw the pool tokens from the wallet
1987         systemStore.decSystemBalance(liquidity.poolToken, poolAmount);
1988         wallet.withdrawTokens(liquidity.poolToken, address(this), poolAmount);
1989 
1990         // remove liquidity
1991         removeLiquidity(liquidity.poolToken, poolAmount, liquidity.reserveToken, networkTokenLocal);
1992 
1993         // transfer the base tokens to the caller
1994         uint256 baseBalance;
1995         if (liquidity.reserveToken == ETH_RESERVE_ADDRESS) {
1996             baseBalance = address(this).balance;
1997             _provider.transfer(baseBalance);
1998         } else {
1999             baseBalance = liquidity.reserveToken.balanceOf(address(this));
2000             safeTransfer(liquidity.reserveToken, _provider, baseBalance);
2001         }
2002 
2003         // compensate the caller with network tokens if still needed
2004         uint256 delta = getNetworkCompensation(targetAmount, baseBalance, packedRates);
2005         if (delta > 0) {
2006             // check if there's enough network token balance, otherwise mint more
2007             uint256 networkBalance = networkTokenLocal.balanceOf(address(this));
2008             if (networkBalance < delta) {
2009                 networkTokenGovernance.mint(address(this), delta - networkBalance);
2010             }
2011 
2012             // lock network tokens for the caller
2013             safeTransfer(networkTokenLocal, address(wallet), delta);
2014             lockTokens(_provider, delta);
2015         }
2016 
2017         // if the contract still holds network tokens, burn them
2018         uint256 networkBalance = networkTokenLocal.balanceOf(address(this));
2019         if (networkBalance > 0) {
2020             burnNetworkTokens(liquidity.poolToken, networkBalance);
2021         }
2022     }
2023 
2024     /**
2025      * @dev returns the amount the provider will receive for removing liquidity
2026      * it's also possible to provide the remove liquidity rate & time to get an estimation
2027      * for the return at that given point
2028      *
2029      * @param _poolToken       pool token
2030      * @param _reserveToken    reserve token
2031      * @param _poolAmount      pool token amount when the liquidity was added
2032      * @param _reserveAmount   reserve token amount that was added
2033      * @param _packedRates     see `struct PackedRates`
2034      * @param _addTimestamp    time at which the liquidity was added
2035      * @param _removeTimestamp time at which the liquidity is removed
2036      * @return amount received for removing liquidity
2037      */
2038     function removeLiquidityTargetAmount(
2039         IDSToken _poolToken,
2040         IERC20Token _reserveToken,
2041         uint256 _poolAmount,
2042         uint256 _reserveAmount,
2043         PackedRates memory _packedRates,
2044         uint256 _addTimestamp,
2045         uint256 _removeTimestamp
2046     ) internal view returns (uint256) {
2047         // get the rate between the pool token and the reserve token
2048         Fraction memory poolRate = poolTokenRate(_poolToken, _reserveToken);
2049 
2050         // get the rate between the reserves upon adding liquidity and now
2051         Fraction memory addSpotRate = Fraction({ n: _packedRates.addSpotRateN, d: _packedRates.addSpotRateD });
2052         Fraction memory removeSpotRate = Fraction({ n: _packedRates.removeSpotRateN, d: _packedRates.removeSpotRateD });
2053         Fraction memory removeAverageRate =
2054             Fraction({ n: _packedRates.removeAverageRateN, d: _packedRates.removeAverageRateD });
2055 
2056         // calculate the protected amount of reserve tokens plus accumulated fee before compensation
2057         uint256 total = protectedAmountPlusFee(_poolAmount, poolRate, addSpotRate, removeSpotRate);
2058 
2059         // calculate the impermanent loss
2060         Fraction memory loss = impLoss(addSpotRate, removeAverageRate);
2061 
2062         // calculate the protection level
2063         Fraction memory level = protectionLevel(_addTimestamp, _removeTimestamp);
2064 
2065         // calculate the compensation amount
2066         return compensationAmount(_reserveAmount, MathEx.max(_reserveAmount, total), loss, level);
2067     }
2068 
2069     /**
2070      * @dev allows the caller to claim network token balance that is no longer locked
2071      * note that the function can revert if the range is too large
2072      *
2073      * @param _startIndex  start index in the caller's list of locked balances
2074      * @param _endIndex    end index in the caller's list of locked balances (exclusive)
2075      */
2076     function claimBalance(uint256 _startIndex, uint256 _endIndex) external protected {
2077         // get the locked balances from the store
2078         (uint256[] memory amounts, uint256[] memory expirationTimes) =
2079             store.lockedBalanceRange(msg.sender, _startIndex, _endIndex);
2080 
2081         uint256 totalAmount = 0;
2082         uint256 length = amounts.length;
2083         assert(length == expirationTimes.length);
2084 
2085         // reverse iteration since we're removing from the list
2086         for (uint256 i = length; i > 0; i--) {
2087             uint256 index = i - 1;
2088             if (expirationTimes[index] > time()) {
2089                 continue;
2090             }
2091 
2092             // remove the locked balance item
2093             store.removeLockedBalance(msg.sender, _startIndex + index);
2094             totalAmount = totalAmount.add(amounts[index]);
2095         }
2096 
2097         if (totalAmount > 0) {
2098             // transfer the tokens to the caller in a single call
2099             wallet.withdrawTokens(networkToken, msg.sender, totalAmount);
2100         }
2101     }
2102 
2103     /**
2104      * @dev returns the ROI for removing liquidity in the current state after providing liquidity with the given args
2105      * the function assumes full protection is in effect
2106      * return value is in PPM and can be larger than PPM_RESOLUTION for positive ROI, 1M = 0% ROI
2107      *
2108      * @param _poolToken       pool token
2109      * @param _reserveToken    reserve token
2110      * @param _reserveAmount   reserve token amount that was added
2111      * @param _poolRateN       rate of 1 pool token in reserve token units when the liquidity was added (numerator)
2112      * @param _poolRateD       rate of 1 pool token in reserve token units when the liquidity was added (denominator)
2113      * @param _reserveRateN    rate of 1 reserve token in the other reserve token units when the liquidity was added (numerator)
2114      * @param _reserveRateD    rate of 1 reserve token in the other reserve token units when the liquidity was added (denominator)
2115      * @return ROI in PPM
2116      */
2117     function poolROI(
2118         IDSToken _poolToken,
2119         IERC20Token _reserveToken,
2120         uint256 _reserveAmount,
2121         uint256 _poolRateN,
2122         uint256 _poolRateD,
2123         uint256 _reserveRateN,
2124         uint256 _reserveRateD
2125     ) external view returns (uint256) {
2126         // calculate the amount of pool tokens based on the amount of reserve tokens
2127         uint256 poolAmount = _reserveAmount.mul(_poolRateD).div(_poolRateN);
2128 
2129         // get the various rates between the reserves upon adding liquidity and now
2130         PackedRates memory packedRates = packRates(_poolToken, _reserveToken, _reserveRateN, _reserveRateD, false);
2131 
2132         // get the current return
2133         uint256 protectedReturn =
2134             removeLiquidityTargetAmount(
2135                 _poolToken,
2136                 _reserveToken,
2137                 poolAmount,
2138                 _reserveAmount,
2139                 packedRates,
2140                 time().sub(settings.maxProtectionDelay()),
2141                 time()
2142             );
2143 
2144         // calculate the ROI as the ratio between the current fully protected return and the initial amount
2145         return protectedReturn.mul(PPM_RESOLUTION).div(_reserveAmount);
2146     }
2147 
2148     /**
2149      * @dev adds protected liquidity for the caller to the store
2150      *
2151      * @param _provider        protected liquidity provider
2152      * @param _poolToken       pool token
2153      * @param _reserveToken    reserve token
2154      * @param _poolAmount      amount of pool tokens to protect
2155      * @param _reserveAmount   amount of reserve tokens to protect
2156      * @return new protected liquidity id
2157      */
2158     function addProtectedLiquidity(
2159         address _provider,
2160         IDSToken _poolToken,
2161         IERC20Token _reserveToken,
2162         uint256 _poolAmount,
2163         uint256 _reserveAmount
2164     ) internal returns (uint256) {
2165         // notify event subscribers
2166         address[] memory subscribers = settings.subscribers();
2167         uint256 length = subscribers.length;
2168         for (uint256 i = 0; i < length; i++) {
2169             ILiquidityProtectionEventsSubscriber(subscribers[i]).onAddingLiquidity(
2170                 _provider,
2171                 _poolToken,
2172                 _reserveToken,
2173                 _poolAmount,
2174                 _reserveAmount
2175             );
2176         }
2177 
2178         Fraction memory rate = reserveTokenAverageRate(_poolToken, _reserveToken, true);
2179         stats.increaseTotalAmounts(_provider, _poolToken, _reserveToken, _poolAmount, _reserveAmount);
2180         stats.addProviderPool(_provider, _poolToken);
2181         return
2182             store.addProtectedLiquidity(
2183                 _provider,
2184                 _poolToken,
2185                 _reserveToken,
2186                 _poolAmount,
2187                 _reserveAmount,
2188                 rate.n,
2189                 rate.d,
2190                 time()
2191             );
2192     }
2193 
2194     /**
2195      * @dev locks network tokens for the provider and emits the tokens locked event
2196      *
2197      * @param _provider    tokens provider
2198      * @param _amount      amount of network tokens
2199      */
2200     function lockTokens(address _provider, uint256 _amount) internal {
2201         uint256 expirationTime = time().add(settings.lockDuration());
2202         store.addLockedBalance(_provider, _amount, expirationTime);
2203     }
2204 
2205     /**
2206      * @dev returns the rate of 1 pool token in reserve token units
2207      *
2208      * @param _poolToken       pool token
2209      * @param _reserveToken    reserve token
2210      */
2211     function poolTokenRate(IDSToken _poolToken, IERC20Token _reserveToken)
2212         internal
2213         view
2214         virtual
2215         returns (Fraction memory)
2216     {
2217         // get the pool token supply
2218         uint256 poolTokenSupply = _poolToken.totalSupply();
2219 
2220         // get the reserve balance
2221         IConverter converter = IConverter(payable(ownedBy(_poolToken)));
2222         uint256 reserveBalance = converter.getConnectorBalance(_reserveToken);
2223 
2224         // for standard pools, 50% of the pool supply value equals the value of each reserve
2225         return Fraction({ n: reserveBalance.mul(2), d: poolTokenSupply });
2226     }
2227 
2228     /**
2229      * @dev returns the average rate of 1 reserve token in the other reserve token units
2230      *
2231      * @param _poolToken            pool token
2232      * @param _reserveToken         reserve token
2233      * @param _validateAverageRate  true to validate the average rate; false otherwise
2234      */
2235     function reserveTokenAverageRate(
2236         IDSToken _poolToken,
2237         IERC20Token _reserveToken,
2238         bool _validateAverageRate
2239     ) internal view returns (Fraction memory) {
2240         (, , uint256 averageRateN, uint256 averageRateD) =
2241             reserveTokenRates(_poolToken, _reserveToken, _validateAverageRate);
2242         return Fraction(averageRateN, averageRateD);
2243     }
2244 
2245     /**
2246      * @dev returns the spot rate and average rate of 1 reserve token in the other reserve token units
2247      *
2248      * @param _poolToken            pool token
2249      * @param _reserveToken         reserve token
2250      * @param _validateAverageRate  true to validate the average rate; false otherwise
2251      */
2252     function reserveTokenRates(
2253         IDSToken _poolToken,
2254         IERC20Token _reserveToken,
2255         bool _validateAverageRate
2256     )
2257         internal
2258         view
2259         returns (
2260             uint256,
2261             uint256,
2262             uint256,
2263             uint256
2264         )
2265     {
2266         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolToken)));
2267         IERC20Token otherReserve = converterOtherReserve(converter, _reserveToken);
2268 
2269         (uint256 spotRateN, uint256 spotRateD) = converterReserveBalances(converter, otherReserve, _reserveToken);
2270         (uint256 averageRateN, uint256 averageRateD) = converter.recentAverageRate(_reserveToken);
2271 
2272         require(
2273             !_validateAverageRate ||
2274                 averageRateInRange(
2275                     spotRateN,
2276                     spotRateD,
2277                     averageRateN,
2278                     averageRateD,
2279                     settings.averageRateMaxDeviation()
2280                 ),
2281             "ERR_INVALID_RATE"
2282         );
2283 
2284         return (spotRateN, spotRateD, averageRateN, averageRateD);
2285     }
2286 
2287     /**
2288      * @dev returns the various rates between the reserves
2289      *
2290      * @param _poolToken            pool token
2291      * @param _reserveToken         reserve token
2292      * @param _addSpotRateN         add spot rate numerator
2293      * @param _addSpotRateD         add spot rate denominator
2294      * @param _validateAverageRate  true to validate the average rate; false otherwise
2295      * @return see `struct PackedRates`
2296      */
2297     function packRates(
2298         IDSToken _poolToken,
2299         IERC20Token _reserveToken,
2300         uint256 _addSpotRateN,
2301         uint256 _addSpotRateD,
2302         bool _validateAverageRate
2303     ) internal view returns (PackedRates memory) {
2304         (uint256 removeSpotRateN, uint256 removeSpotRateD, uint256 removeAverageRateN, uint256 removeAverageRateD) =
2305             reserveTokenRates(_poolToken, _reserveToken, _validateAverageRate);
2306 
2307         require(
2308             (_addSpotRateN <= MAX_UINT128 && _addSpotRateD <= MAX_UINT128) &&
2309                 (removeSpotRateN <= MAX_UINT128 && removeSpotRateD <= MAX_UINT128) &&
2310                 (removeAverageRateN <= MAX_UINT128 && removeAverageRateD <= MAX_UINT128),
2311             "ERR_INVALID_RATE"
2312         );
2313 
2314         return
2315             PackedRates({
2316                 addSpotRateN: uint128(_addSpotRateN),
2317                 addSpotRateD: uint128(_addSpotRateD),
2318                 removeSpotRateN: uint128(removeSpotRateN),
2319                 removeSpotRateD: uint128(removeSpotRateD),
2320                 removeAverageRateN: uint128(removeAverageRateN),
2321                 removeAverageRateD: uint128(removeAverageRateD)
2322             });
2323     }
2324 
2325     /**
2326      * @dev returns whether or not the deviation of the average rate from the spot rate is within range
2327      * for example, if the maximum permitted deviation is 5%, then return `95/100 <= average/spot <= 100/95`
2328      *
2329      * @param _spotRateN       spot rate numerator
2330      * @param _spotRateD       spot rate denominator
2331      * @param _averageRateN    average rate numerator
2332      * @param _averageRateD    average rate denominator
2333      * @param _maxDeviation    the maximum permitted deviation of the average rate from the spot rate
2334      */
2335     function averageRateInRange(
2336         uint256 _spotRateN,
2337         uint256 _spotRateD,
2338         uint256 _averageRateN,
2339         uint256 _averageRateD,
2340         uint32 _maxDeviation
2341     ) internal pure returns (bool) {
2342         uint256 ppmDelta = PPM_RESOLUTION - _maxDeviation;
2343         uint256 min = _spotRateN.mul(_averageRateD).mul(ppmDelta).mul(ppmDelta);
2344         uint256 mid = _spotRateD.mul(_averageRateN).mul(ppmDelta).mul(PPM_RESOLUTION);
2345         uint256 max = _spotRateN.mul(_averageRateD).mul(PPM_RESOLUTION).mul(PPM_RESOLUTION);
2346         return min <= mid && mid <= max;
2347     }
2348 
2349     /**
2350      * @dev utility to add liquidity to a converter
2351      *
2352      * @param _converter       converter
2353      * @param _reserveToken1   reserve token 1
2354      * @param _reserveToken2   reserve token 2
2355      * @param _reserveAmount1  reserve amount 1
2356      * @param _reserveAmount2  reserve amount 2
2357      * @param _value           ETH amount to add
2358      */
2359     function addLiquidity(
2360         ILiquidityPoolConverter _converter,
2361         IERC20Token _reserveToken1,
2362         IERC20Token _reserveToken2,
2363         uint256 _reserveAmount1,
2364         uint256 _reserveAmount2,
2365         uint256 _value
2366     ) internal {
2367         // ensure that the contract can receive ETH
2368         updatingLiquidity = true;
2369 
2370         IERC20Token[] memory reserveTokens = new IERC20Token[](2);
2371         uint256[] memory amounts = new uint256[](2);
2372         reserveTokens[0] = _reserveToken1;
2373         reserveTokens[1] = _reserveToken2;
2374         amounts[0] = _reserveAmount1;
2375         amounts[1] = _reserveAmount2;
2376         _converter.addLiquidity{ value: _value }(reserveTokens, amounts, 1);
2377 
2378         // ensure that the contract can receive ETH
2379         updatingLiquidity = false;
2380     }
2381 
2382     /**
2383      * @dev utility to remove liquidity from a converter
2384      *
2385      * @param _poolToken       pool token of the converter
2386      * @param _poolAmount      amount of pool tokens to remove
2387      * @param _reserveToken1   reserve token 1
2388      * @param _reserveToken2   reserve token 2
2389      */
2390     function removeLiquidity(
2391         IDSToken _poolToken,
2392         uint256 _poolAmount,
2393         IERC20Token _reserveToken1,
2394         IERC20Token _reserveToken2
2395     ) internal {
2396         ILiquidityPoolConverter converter = ILiquidityPoolConverter(payable(ownedBy(_poolToken)));
2397 
2398         // ensure that the contract can receive ETH
2399         updatingLiquidity = true;
2400 
2401         IERC20Token[] memory reserveTokens = new IERC20Token[](2);
2402         uint256[] memory minReturns = new uint256[](2);
2403         reserveTokens[0] = _reserveToken1;
2404         reserveTokens[1] = _reserveToken2;
2405         minReturns[0] = 1;
2406         minReturns[1] = 1;
2407         converter.removeLiquidity(_poolAmount, reserveTokens, minReturns);
2408 
2409         // ensure that the contract can receive ETH
2410         updatingLiquidity = false;
2411     }
2412 
2413     /**
2414      * @dev returns a protected liquidity from the store
2415      *
2416      * @param _id  protected liquidity id
2417      * @return protected liquidity
2418      */
2419     function protectedLiquidity(uint256 _id) internal view returns (ProtectedLiquidity memory) {
2420         ProtectedLiquidity memory liquidity;
2421         (
2422             liquidity.provider,
2423             liquidity.poolToken,
2424             liquidity.reserveToken,
2425             liquidity.poolAmount,
2426             liquidity.reserveAmount,
2427             liquidity.reserveRateN,
2428             liquidity.reserveRateD,
2429             liquidity.timestamp
2430         ) = store.protectedLiquidity(_id);
2431 
2432         return liquidity;
2433     }
2434 
2435     /**
2436      * @dev returns a protected liquidity from the store
2437      *
2438      * @param _id          protected liquidity id
2439      * @param _provider    authorized provider
2440      * @return protected liquidity
2441      */
2442     function protectedLiquidity(uint256 _id, address _provider) internal view returns (ProtectedLiquidity memory) {
2443         ProtectedLiquidity memory liquidity = protectedLiquidity(_id);
2444         require(liquidity.provider == _provider, "ERR_ACCESS_DENIED");
2445         return liquidity;
2446     }
2447 
2448     /**
2449      * @dev returns the protected amount of reserve tokens plus accumulated fee before compensation
2450      *
2451      * @param _poolAmount      pool token amount when the liquidity was added
2452      * @param _poolRate        rate of 1 pool token in the related reserve token units
2453      * @param _addRate         rate of 1 reserve token in the other reserve token units when the liquidity was added
2454      * @param _removeRate      rate of 1 reserve token in the other reserve token units when the liquidity is removed
2455      * @return protected amount of reserve tokens plus accumulated fee = sqrt(_removeRate / _addRate) * _poolRate * _poolAmount
2456      */
2457     function protectedAmountPlusFee(
2458         uint256 _poolAmount,
2459         Fraction memory _poolRate,
2460         Fraction memory _addRate,
2461         Fraction memory _removeRate
2462     ) internal pure returns (uint256) {
2463         uint256 n = MathEx.ceilSqrt(_addRate.d.mul(_removeRate.n)).mul(_poolRate.n);
2464         uint256 d = MathEx.floorSqrt(_addRate.n.mul(_removeRate.d)).mul(_poolRate.d);
2465 
2466         uint256 x = n * _poolAmount;
2467         if (x / n == _poolAmount) {
2468             return x / d;
2469         }
2470 
2471         (uint256 hi, uint256 lo) = n > _poolAmount ? (n, _poolAmount) : (_poolAmount, n);
2472         (uint256 p, uint256 q) = MathEx.reducedRatio(hi, d, MAX_UINT256 / lo);
2473         uint256 min = (hi / d).mul(lo);
2474 
2475         if (q > 0) {
2476             return MathEx.max(min, (p * lo) / q);
2477         }
2478         return min;
2479     }
2480 
2481     /**
2482      * @dev returns the impermanent loss incurred due to the change in rates between the reserve tokens
2483      *
2484      * @param _prevRate    previous rate between the reserves
2485      * @param _newRate     new rate between the reserves
2486      * @return impermanent loss (as a ratio)
2487      */
2488     function impLoss(Fraction memory _prevRate, Fraction memory _newRate) internal pure returns (Fraction memory) {
2489         uint256 ratioN = _newRate.n.mul(_prevRate.d);
2490         uint256 ratioD = _newRate.d.mul(_prevRate.n);
2491 
2492         uint256 prod = ratioN * ratioD;
2493         uint256 root =
2494             prod / ratioN == ratioD ? MathEx.floorSqrt(prod) : MathEx.floorSqrt(ratioN) * MathEx.floorSqrt(ratioD);
2495         uint256 sum = ratioN.add(ratioD);
2496 
2497         // the arithmetic below is safe because `x + y >= sqrt(x * y) * 2`
2498         if (sum % 2 == 0) {
2499             sum /= 2;
2500             return Fraction({ n: sum - root, d: sum });
2501         }
2502         return Fraction({ n: sum - root * 2, d: sum });
2503     }
2504 
2505     /**
2506      * @dev returns the protection level based on the timestamp and protection delays
2507      *
2508      * @param _addTimestamp    time at which the liquidity was added
2509      * @param _removeTimestamp time at which the liquidity is removed
2510      * @return protection level (as a ratio)
2511      */
2512     function protectionLevel(uint256 _addTimestamp, uint256 _removeTimestamp) internal view returns (Fraction memory) {
2513         uint256 timeElapsed = _removeTimestamp.sub(_addTimestamp);
2514         uint256 minProtectionDelay = settings.minProtectionDelay();
2515         uint256 maxProtectionDelay = settings.maxProtectionDelay();
2516         if (timeElapsed < minProtectionDelay) {
2517             return Fraction({ n: 0, d: 1 });
2518         }
2519 
2520         if (timeElapsed >= maxProtectionDelay) {
2521             return Fraction({ n: 1, d: 1 });
2522         }
2523 
2524         return Fraction({ n: timeElapsed, d: maxProtectionDelay });
2525     }
2526 
2527     /**
2528      * @dev returns the compensation amount based on the impermanent loss and the protection level
2529      *
2530      * @param _amount  protected amount in units of the reserve token
2531      * @param _total   amount plus fee in units of the reserve token
2532      * @param _loss    protection level (as a ratio between 0 and 1)
2533      * @param _level   impermanent loss (as a ratio between 0 and 1)
2534      * @return compensation amount
2535      */
2536     function compensationAmount(
2537         uint256 _amount,
2538         uint256 _total,
2539         Fraction memory _loss,
2540         Fraction memory _level
2541     ) internal pure returns (uint256) {
2542         uint256 levelN = _level.n.mul(_amount);
2543         uint256 levelD = _level.d;
2544         uint256 maxVal = MathEx.max(MathEx.max(levelN, levelD), _total);
2545         (uint256 lossN, uint256 lossD) = MathEx.reducedRatio(_loss.n, _loss.d, MAX_UINT256 / maxVal);
2546         return _total.mul(lossD.sub(lossN)).div(lossD).add(lossN.mul(levelN).div(lossD.mul(levelD)));
2547     }
2548 
2549     function getNetworkCompensation(
2550         uint256 _targetAmount,
2551         uint256 _baseAmount,
2552         PackedRates memory _packedRates
2553     ) internal view returns (uint256) {
2554         if (_targetAmount <= _baseAmount) {
2555             return 0;
2556         }
2557 
2558         // calculate the delta in network tokens
2559         uint256 delta =
2560             (_targetAmount - _baseAmount).mul(_packedRates.removeAverageRateN).div(_packedRates.removeAverageRateD);
2561 
2562         // the delta might be very small due to precision loss
2563         // in which case no compensation will take place (gas optimization)
2564         if (delta >= settings.minNetworkCompensation()) {
2565             return delta;
2566         }
2567 
2568         return 0;
2569     }
2570 
2571     /**
2572      * @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't.
2573      * note that we use the non standard erc-20 interface in which `approve` has no return value so that
2574      * this function will work for both standard and non standard tokens
2575      *
2576      * @param _token   token to check the allowance in
2577      * @param _spender approved address
2578      * @param _value   allowance amount
2579      */
2580     function ensureAllowance(
2581         IERC20Token _token,
2582         address _spender,
2583         uint256 _value
2584     ) private {
2585         uint256 allowance = _token.allowance(address(this), _spender);
2586         if (allowance < _value) {
2587             if (allowance > 0) safeApprove(_token, _spender, 0);
2588             safeApprove(_token, _spender, _value);
2589         }
2590     }
2591 
2592     // utility to mint network tokens
2593     function mintNetworkTokens(
2594         address _owner,
2595         IConverterAnchor _poolAnchor,
2596         uint256 _amount
2597     ) private {
2598         networkTokenGovernance.mint(_owner, _amount);
2599         systemStore.incNetworkTokensMinted(_poolAnchor, _amount);
2600     }
2601 
2602     // utility to burn network tokens
2603     function burnNetworkTokens(IConverterAnchor _poolAnchor, uint256 _amount) private {
2604         networkTokenGovernance.burn(_amount);
2605         systemStore.decNetworkTokensMinted(_poolAnchor, _amount);
2606     }
2607 
2608     // utility to notify event subscribers on removing liquidity
2609     function notifyEventSubscribersOnRemovingLiquidity(
2610         uint256 _id,
2611         address _provider,
2612         IDSToken _poolToken,
2613         IERC20Token _reserveToken,
2614         uint256 _poolAmount,
2615         uint256 _reserveAmount
2616     ) private {
2617         address[] memory subscribers = settings.subscribers();
2618         uint256 length = subscribers.length;
2619         for (uint256 i = 0; i < length; i++) {
2620             ILiquidityProtectionEventsSubscriber(subscribers[i]).onRemovingLiquidity(
2621                 _id,
2622                 _provider,
2623                 _poolToken,
2624                 _reserveToken,
2625                 _poolAmount,
2626                 _reserveAmount
2627             );
2628         }
2629     }
2630 
2631     // utility to get the reserve balances
2632     function converterReserveBalances(
2633         IConverter _converter,
2634         IERC20Token _reserveToken1,
2635         IERC20Token _reserveToken2
2636     ) private view returns (uint256, uint256) {
2637         return (_converter.getConnectorBalance(_reserveToken1), _converter.getConnectorBalance(_reserveToken2));
2638     }
2639 
2640     // utility to get the other reserve
2641     function converterOtherReserve(IConverter _converter, IERC20Token _thisReserve) private view returns (IERC20Token) {
2642         IERC20Token otherReserve = _converter.connectorTokens(0);
2643         return otherReserve != _thisReserve ? otherReserve : _converter.connectorTokens(1);
2644     }
2645 
2646     // utility to get the owner
2647     function ownedBy(IOwned _owned) private view returns (address) {
2648         return _owned.owner();
2649     }
2650 }
