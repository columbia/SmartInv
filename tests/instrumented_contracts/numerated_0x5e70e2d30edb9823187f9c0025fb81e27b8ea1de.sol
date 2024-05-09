1 // File: @openzeppelin/contracts/utils/math/Math.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     enum Rounding {
13         Down, // Toward negative infinity
14         Up, // Toward infinity
15         Zero // Toward zero
16     }
17 
18     /**
19      * @dev Returns the largest of two numbers.
20      */
21     function max(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a >= b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the smallest of two numbers.
27      */
28     function min(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a < b ? a : b;
30     }
31 
32     /**
33      * @dev Returns the average of two numbers. The result is rounded towards
34      * zero.
35      */
36     function average(uint256 a, uint256 b) internal pure returns (uint256) {
37         // (a + b) / 2 can overflow.
38         return (a & b) + (a ^ b) / 2;
39     }
40 
41     /**
42      * @dev Returns the ceiling of the division of two numbers.
43      *
44      * This differs from standard division with `/` in that it rounds up instead
45      * of rounding down.
46      */
47     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
48         // (a + b - 1) / b can overflow on addition, so we distribute.
49         return a == 0 ? 0 : (a - 1) / b + 1;
50     }
51 
52     /**
53      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
54      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
55      * with further edits by Uniswap Labs also under MIT license.
56      */
57     function mulDiv(
58         uint256 x,
59         uint256 y,
60         uint256 denominator
61     ) internal pure returns (uint256 result) {
62         unchecked {
63             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
64             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
65             // variables such that product = prod1 * 2^256 + prod0.
66             uint256 prod0; // Least significant 256 bits of the product
67             uint256 prod1; // Most significant 256 bits of the product
68             assembly {
69                 let mm := mulmod(x, y, not(0))
70                 prod0 := mul(x, y)
71                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
72             }
73 
74             // Handle non-overflow cases, 256 by 256 division.
75             if (prod1 == 0) {
76                 return prod0 / denominator;
77             }
78 
79             // Make sure the result is less than 2^256. Also prevents denominator == 0.
80             require(denominator > prod1);
81 
82             ///////////////////////////////////////////////
83             // 512 by 256 division.
84             ///////////////////////////////////////////////
85 
86             // Make division exact by subtracting the remainder from [prod1 prod0].
87             uint256 remainder;
88             assembly {
89                 // Compute remainder using mulmod.
90                 remainder := mulmod(x, y, denominator)
91 
92                 // Subtract 256 bit number from 512 bit number.
93                 prod1 := sub(prod1, gt(remainder, prod0))
94                 prod0 := sub(prod0, remainder)
95             }
96 
97             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
98             // See https://cs.stackexchange.com/q/138556/92363.
99 
100             // Does not overflow because the denominator cannot be zero at this stage in the function.
101             uint256 twos = denominator & (~denominator + 1);
102             assembly {
103                 // Divide denominator by twos.
104                 denominator := div(denominator, twos)
105 
106                 // Divide [prod1 prod0] by twos.
107                 prod0 := div(prod0, twos)
108 
109                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
110                 twos := add(div(sub(0, twos), twos), 1)
111             }
112 
113             // Shift in bits from prod1 into prod0.
114             prod0 |= prod1 * twos;
115 
116             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
117             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
118             // four bits. That is, denominator * inv = 1 mod 2^4.
119             uint256 inverse = (3 * denominator) ^ 2;
120 
121             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
122             // in modular arithmetic, doubling the correct bits in each step.
123             inverse *= 2 - denominator * inverse; // inverse mod 2^8
124             inverse *= 2 - denominator * inverse; // inverse mod 2^16
125             inverse *= 2 - denominator * inverse; // inverse mod 2^32
126             inverse *= 2 - denominator * inverse; // inverse mod 2^64
127             inverse *= 2 - denominator * inverse; // inverse mod 2^128
128             inverse *= 2 - denominator * inverse; // inverse mod 2^256
129 
130             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
131             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
132             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
133             // is no longer required.
134             result = prod0 * inverse;
135             return result;
136         }
137     }
138 
139     /**
140      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
141      */
142     function mulDiv(
143         uint256 x,
144         uint256 y,
145         uint256 denominator,
146         Rounding rounding
147     ) internal pure returns (uint256) {
148         uint256 result = mulDiv(x, y, denominator);
149         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
150             result += 1;
151         }
152         return result;
153     }
154 
155     /**
156      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
157      *
158      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
159      */
160     function sqrt(uint256 a) internal pure returns (uint256) {
161         if (a == 0) {
162             return 0;
163         }
164 
165         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
166         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
167         // `msb(a) <= a < 2*msb(a)`.
168         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
169         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
170         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
171         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
172         uint256 result = 1;
173         uint256 x = a;
174         if (x >> 128 > 0) {
175             x >>= 128;
176             result <<= 64;
177         }
178         if (x >> 64 > 0) {
179             x >>= 64;
180             result <<= 32;
181         }
182         if (x >> 32 > 0) {
183             x >>= 32;
184             result <<= 16;
185         }
186         if (x >> 16 > 0) {
187             x >>= 16;
188             result <<= 8;
189         }
190         if (x >> 8 > 0) {
191             x >>= 8;
192             result <<= 4;
193         }
194         if (x >> 4 > 0) {
195             x >>= 4;
196             result <<= 2;
197         }
198         if (x >> 2 > 0) {
199             result <<= 1;
200         }
201 
202         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
203         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
204         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
205         // into the expected uint128 result.
206         unchecked {
207             result = (result + a / result) >> 1;
208             result = (result + a / result) >> 1;
209             result = (result + a / result) >> 1;
210             result = (result + a / result) >> 1;
211             result = (result + a / result) >> 1;
212             result = (result + a / result) >> 1;
213             result = (result + a / result) >> 1;
214             return min(result, a / result);
215         }
216     }
217 
218     /**
219      * @notice Calculates sqrt(a), following the selected rounding direction.
220      */
221     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
222         uint256 result = sqrt(a);
223         if (rounding == Rounding.Up && result * result < a) {
224             result += 1;
225         }
226         return result;
227     }
228 }
229 
230 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
231 
232 
233 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
239  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
240  *
241  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
242  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
243  * need to send a transaction, and thus is not required to hold Ether at all.
244  */
245 interface IERC20Permit {
246     /**
247      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
248      * given ``owner``'s signed approval.
249      *
250      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
251      * ordering also apply here.
252      *
253      * Emits an {Approval} event.
254      *
255      * Requirements:
256      *
257      * - `spender` cannot be the zero address.
258      * - `deadline` must be a timestamp in the future.
259      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
260      * over the EIP712-formatted function arguments.
261      * - the signature must use ``owner``'s current nonce (see {nonces}).
262      *
263      * For more information on the signature format, see the
264      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
265      * section].
266      */
267     function permit(
268         address owner,
269         address spender,
270         uint256 value,
271         uint256 deadline,
272         uint8 v,
273         bytes32 r,
274         bytes32 s
275     ) external;
276 
277     /**
278      * @dev Returns the current nonce for `owner`. This value must be
279      * included whenever a signature is generated for {permit}.
280      *
281      * Every successful call to {permit} increases ``owner``'s nonce by one. This
282      * prevents a signature from being used multiple times.
283      */
284     function nonces(address owner) external view returns (uint256);
285 
286     /**
287      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
288      */
289     // solhint-disable-next-line func-name-mixedcase
290     function DOMAIN_SEPARATOR() external view returns (bytes32);
291 }
292 
293 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
294 
295 
296 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @dev Interface of the ERC20 standard as defined in the EIP.
302  */
303 interface IERC20 {
304     /**
305      * @dev Emitted when `value` tokens are moved from one account (`from`) to
306      * another (`to`).
307      *
308      * Note that `value` may be zero.
309      */
310     event Transfer(address indexed from, address indexed to, uint256 value);
311 
312     /**
313      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
314      * a call to {approve}. `value` is the new allowance.
315      */
316     event Approval(address indexed owner, address indexed spender, uint256 value);
317 
318     /**
319      * @dev Returns the amount of tokens in existence.
320      */
321     function totalSupply() external view returns (uint256);
322 
323     /**
324      * @dev Returns the amount of tokens owned by `account`.
325      */
326     function balanceOf(address account) external view returns (uint256);
327 
328     /**
329      * @dev Moves `amount` tokens from the caller's account to `to`.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transfer(address to, uint256 amount) external returns (bool);
336 
337     /**
338      * @dev Returns the remaining number of tokens that `spender` will be
339      * allowed to spend on behalf of `owner` through {transferFrom}. This is
340      * zero by default.
341      *
342      * This value changes when {approve} or {transferFrom} are called.
343      */
344     function allowance(address owner, address spender) external view returns (uint256);
345 
346     /**
347      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * IMPORTANT: Beware that changing an allowance with this method brings the risk
352      * that someone may use both the old and the new allowance by unfortunate
353      * transaction ordering. One possible solution to mitigate this race
354      * condition is to first reduce the spender's allowance to 0 and set the
355      * desired value afterwards:
356      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
357      *
358      * Emits an {Approval} event.
359      */
360     function approve(address spender, uint256 amount) external returns (bool);
361 
362     /**
363      * @dev Moves `amount` tokens from `from` to `to` using the
364      * allowance mechanism. `amount` is then deducted from the caller's
365      * allowance.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * Emits a {Transfer} event.
370      */
371     function transferFrom(
372         address from,
373         address to,
374         uint256 amount
375     ) external returns (bool);
376 }
377 
378 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
379 
380 
381 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @dev Contract module that helps prevent reentrant calls to a function.
387  *
388  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
389  * available, which can be applied to functions to make sure there are no nested
390  * (reentrant) calls to them.
391  *
392  * Note that because there is a single `nonReentrant` guard, functions marked as
393  * `nonReentrant` may not call one another. This can be worked around by making
394  * those functions `private`, and then adding `external` `nonReentrant` entry
395  * points to them.
396  *
397  * TIP: If you would like to learn more about reentrancy and alternative ways
398  * to protect against it, check out our blog post
399  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
400  */
401 abstract contract ReentrancyGuard {
402     // Booleans are more expensive than uint256 or any type that takes up a full
403     // word because each write operation emits an extra SLOAD to first read the
404     // slot's contents, replace the bits taken up by the boolean, and then write
405     // back. This is the compiler's defense against contract upgrades and
406     // pointer aliasing, and it cannot be disabled.
407 
408     // The values being non-zero value makes deployment a bit more expensive,
409     // but in exchange the refund on every call to nonReentrant will be lower in
410     // amount. Since refunds are capped to a percentage of the total
411     // transaction's gas, it is best to keep them low in cases like this one, to
412     // increase the likelihood of the full refund coming into effect.
413     uint256 private constant _NOT_ENTERED = 1;
414     uint256 private constant _ENTERED = 2;
415 
416     uint256 private _status;
417 
418     constructor() {
419         _status = _NOT_ENTERED;
420     }
421 
422     /**
423      * @dev Prevents a contract from calling itself, directly or indirectly.
424      * Calling a `nonReentrant` function from another `nonReentrant`
425      * function is not supported. It is possible to prevent this from happening
426      * by making the `nonReentrant` function external, and making it call a
427      * `private` function that does the actual work.
428      */
429     modifier nonReentrant() {
430         // On the first call to nonReentrant, _notEntered will be true
431         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
432 
433         // Any calls to nonReentrant after this point will fail
434         _status = _ENTERED;
435 
436         _;
437 
438         // By storing the original value once again, a refund is triggered (see
439         // https://eips.ethereum.org/EIPS/eip-2200)
440         _status = _NOT_ENTERED;
441     }
442 }
443 
444 // File: @openzeppelin/contracts/utils/Counters.sol
445 
446 
447 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @title Counters
453  * @author Matt Condon (@shrugs)
454  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
455  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
456  *
457  * Include with `using Counters for Counters.Counter;`
458  */
459 library Counters {
460     struct Counter {
461         // This variable should never be directly accessed by users of the library: interactions must be restricted to
462         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
463         // this feature: see https://github.com/ethereum/solidity/issues/4637
464         uint256 _value; // default: 0
465     }
466 
467     function current(Counter storage counter) internal view returns (uint256) {
468         return counter._value;
469     }
470 
471     function increment(Counter storage counter) internal {
472         unchecked {
473             counter._value += 1;
474         }
475     }
476 
477     function decrement(Counter storage counter) internal {
478         uint256 value = counter._value;
479         require(value > 0, "Counter: decrement overflow");
480         unchecked {
481             counter._value = value - 1;
482         }
483     }
484 
485     function reset(Counter storage counter) internal {
486         counter._value = 0;
487     }
488 }
489 
490 // File: @openzeppelin/contracts/utils/Strings.sol
491 
492 
493 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @dev String operations.
499  */
500 library Strings {
501     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
502     uint8 private constant _ADDRESS_LENGTH = 20;
503 
504     /**
505      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
506      */
507     function toString(uint256 value) internal pure returns (string memory) {
508         // Inspired by OraclizeAPI's implementation - MIT licence
509         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
510 
511         if (value == 0) {
512             return "0";
513         }
514         uint256 temp = value;
515         uint256 digits;
516         while (temp != 0) {
517             digits++;
518             temp /= 10;
519         }
520         bytes memory buffer = new bytes(digits);
521         while (value != 0) {
522             digits -= 1;
523             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
524             value /= 10;
525         }
526         return string(buffer);
527     }
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
531      */
532     function toHexString(uint256 value) internal pure returns (string memory) {
533         if (value == 0) {
534             return "0x00";
535         }
536         uint256 temp = value;
537         uint256 length = 0;
538         while (temp != 0) {
539             length++;
540             temp >>= 8;
541         }
542         return toHexString(value, length);
543     }
544 
545     /**
546      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
547      */
548     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
549         bytes memory buffer = new bytes(2 * length + 2);
550         buffer[0] = "0";
551         buffer[1] = "x";
552         for (uint256 i = 2 * length + 1; i > 1; --i) {
553             buffer[i] = _HEX_SYMBOLS[value & 0xf];
554             value >>= 4;
555         }
556         require(value == 0, "Strings: hex length insufficient");
557         return string(buffer);
558     }
559 
560     /**
561      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
562      */
563     function toHexString(address addr) internal pure returns (string memory) {
564         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
565     }
566 }
567 
568 // File: @openzeppelin/contracts/utils/Context.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev Provides information about the current execution context, including the
577  * sender of the transaction and its data. While these are generally available
578  * via msg.sender and msg.data, they should not be accessed in such a direct
579  * manner, since when dealing with meta-transactions the account sending and
580  * paying for execution may not be the actual sender (as far as an application
581  * is concerned).
582  *
583  * This contract is only required for intermediate, library-like contracts.
584  */
585 abstract contract Context {
586     function _msgSender() internal view virtual returns (address) {
587         return msg.sender;
588     }
589 
590     function _msgData() internal view virtual returns (bytes calldata) {
591         return msg.data;
592     }
593 }
594 
595 // File: @openzeppelin/contracts/access/Ownable.sol
596 
597 
598 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
599 
600 pragma solidity ^0.8.0;
601 
602 
603 /**
604  * @dev Contract module which provides a basic access control mechanism, where
605  * there is an account (an owner) that can be granted exclusive access to
606  * specific functions.
607  *
608  * By default, the owner account will be the one that deploys the contract. This
609  * can later be changed with {transferOwnership}.
610  *
611  * This module is used through inheritance. It will make available the modifier
612  * `onlyOwner`, which can be applied to your functions to restrict their use to
613  * the owner.
614  */
615 abstract contract Ownable is Context {
616     address private _owner;
617 
618     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
619 
620     /**
621      * @dev Initializes the contract setting the deployer as the initial owner.
622      */
623     constructor() {
624         _transferOwnership(_msgSender());
625     }
626 
627     /**
628      * @dev Throws if called by any account other than the owner.
629      */
630     modifier onlyOwner() {
631         _checkOwner();
632         _;
633     }
634 
635     /**
636      * @dev Returns the address of the current owner.
637      */
638     function owner() public view virtual returns (address) {
639         return _owner;
640     }
641 
642     /**
643      * @dev Throws if the sender is not the owner.
644      */
645     function _checkOwner() internal view virtual {
646         require(owner() == _msgSender(), "Ownable: caller is not the owner");
647     }
648 
649     /**
650      * @dev Leaves the contract without owner. It will not be possible to call
651      * `onlyOwner` functions anymore. Can only be called by the current owner.
652      *
653      * NOTE: Renouncing ownership will leave the contract without an owner,
654      * thereby removing any functionality that is only available to the owner.
655      */
656     function renounceOwnership() public virtual onlyOwner {
657         _transferOwnership(address(0));
658     }
659 
660     /**
661      * @dev Transfers ownership of the contract to a new account (`newOwner`).
662      * Can only be called by the current owner.
663      */
664     function transferOwnership(address newOwner) public virtual onlyOwner {
665         require(newOwner != address(0), "Ownable: new owner is the zero address");
666         _transferOwnership(newOwner);
667     }
668 
669     /**
670      * @dev Transfers ownership of the contract to a new account (`newOwner`).
671      * Internal function without access restriction.
672      */
673     function _transferOwnership(address newOwner) internal virtual {
674         address oldOwner = _owner;
675         _owner = newOwner;
676         emit OwnershipTransferred(oldOwner, newOwner);
677     }
678 }
679 
680 // File: @openzeppelin/contracts/utils/Address.sol
681 
682 
683 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
684 
685 pragma solidity ^0.8.1;
686 
687 /**
688  * @dev Collection of functions related to the address type
689  */
690 library Address {
691     /**
692      * @dev Returns true if `account` is a contract.
693      *
694      * [IMPORTANT]
695      * ====
696      * It is unsafe to assume that an address for which this function returns
697      * false is an externally-owned account (EOA) and not a contract.
698      *
699      * Among others, `isContract` will return false for the following
700      * types of addresses:
701      *
702      *  - an externally-owned account
703      *  - a contract in construction
704      *  - an address where a contract will be created
705      *  - an address where a contract lived, but was destroyed
706      * ====
707      *
708      * [IMPORTANT]
709      * ====
710      * You shouldn't rely on `isContract` to protect against flash loan attacks!
711      *
712      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
713      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
714      * constructor.
715      * ====
716      */
717     function isContract(address account) internal view returns (bool) {
718         // This method relies on extcodesize/address.code.length, which returns 0
719         // for contracts in construction, since the code is only stored at the end
720         // of the constructor execution.
721 
722         return account.code.length > 0;
723     }
724 
725     /**
726      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
727      * `recipient`, forwarding all available gas and reverting on errors.
728      *
729      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
730      * of certain opcodes, possibly making contracts go over the 2300 gas limit
731      * imposed by `transfer`, making them unable to receive funds via
732      * `transfer`. {sendValue} removes this limitation.
733      *
734      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
735      *
736      * IMPORTANT: because control is transferred to `recipient`, care must be
737      * taken to not create reentrancy vulnerabilities. Consider using
738      * {ReentrancyGuard} or the
739      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
740      */
741     function sendValue(address payable recipient, uint256 amount) internal {
742         require(address(this).balance >= amount, "Address: insufficient balance");
743 
744         (bool success, ) = recipient.call{value: amount}("");
745         require(success, "Address: unable to send value, recipient may have reverted");
746     }
747 
748     /**
749      * @dev Performs a Solidity function call using a low level `call`. A
750      * plain `call` is an unsafe replacement for a function call: use this
751      * function instead.
752      *
753      * If `target` reverts with a revert reason, it is bubbled up by this
754      * function (like regular Solidity function calls).
755      *
756      * Returns the raw returned data. To convert to the expected return value,
757      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
758      *
759      * Requirements:
760      *
761      * - `target` must be a contract.
762      * - calling `target` with `data` must not revert.
763      *
764      * _Available since v3.1._
765      */
766     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
767         return functionCall(target, data, "Address: low-level call failed");
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
772      * `errorMessage` as a fallback revert reason when `target` reverts.
773      *
774      * _Available since v3.1._
775      */
776     function functionCall(
777         address target,
778         bytes memory data,
779         string memory errorMessage
780     ) internal returns (bytes memory) {
781         return functionCallWithValue(target, data, 0, errorMessage);
782     }
783 
784     /**
785      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
786      * but also transferring `value` wei to `target`.
787      *
788      * Requirements:
789      *
790      * - the calling contract must have an ETH balance of at least `value`.
791      * - the called Solidity function must be `payable`.
792      *
793      * _Available since v3.1._
794      */
795     function functionCallWithValue(
796         address target,
797         bytes memory data,
798         uint256 value
799     ) internal returns (bytes memory) {
800         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
801     }
802 
803     /**
804      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
805      * with `errorMessage` as a fallback revert reason when `target` reverts.
806      *
807      * _Available since v3.1._
808      */
809     function functionCallWithValue(
810         address target,
811         bytes memory data,
812         uint256 value,
813         string memory errorMessage
814     ) internal returns (bytes memory) {
815         require(address(this).balance >= value, "Address: insufficient balance for call");
816         require(isContract(target), "Address: call to non-contract");
817 
818         (bool success, bytes memory returndata) = target.call{value: value}(data);
819         return verifyCallResult(success, returndata, errorMessage);
820     }
821 
822     /**
823      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
824      * but performing a static call.
825      *
826      * _Available since v3.3._
827      */
828     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
829         return functionStaticCall(target, data, "Address: low-level static call failed");
830     }
831 
832     /**
833      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
834      * but performing a static call.
835      *
836      * _Available since v3.3._
837      */
838     function functionStaticCall(
839         address target,
840         bytes memory data,
841         string memory errorMessage
842     ) internal view returns (bytes memory) {
843         require(isContract(target), "Address: static call to non-contract");
844 
845         (bool success, bytes memory returndata) = target.staticcall(data);
846         return verifyCallResult(success, returndata, errorMessage);
847     }
848 
849     /**
850      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
851      * but performing a delegate call.
852      *
853      * _Available since v3.4._
854      */
855     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
856         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
857     }
858 
859     /**
860      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
861      * but performing a delegate call.
862      *
863      * _Available since v3.4._
864      */
865     function functionDelegateCall(
866         address target,
867         bytes memory data,
868         string memory errorMessage
869     ) internal returns (bytes memory) {
870         require(isContract(target), "Address: delegate call to non-contract");
871 
872         (bool success, bytes memory returndata) = target.delegatecall(data);
873         return verifyCallResult(success, returndata, errorMessage);
874     }
875 
876     /**
877      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
878      * revert reason using the provided one.
879      *
880      * _Available since v4.3._
881      */
882     function verifyCallResult(
883         bool success,
884         bytes memory returndata,
885         string memory errorMessage
886     ) internal pure returns (bytes memory) {
887         if (success) {
888             return returndata;
889         } else {
890             // Look for revert reason and bubble it up if present
891             if (returndata.length > 0) {
892                 // The easiest way to bubble the revert reason is using memory via assembly
893                 /// @solidity memory-safe-assembly
894                 assembly {
895                     let returndata_size := mload(returndata)
896                     revert(add(32, returndata), returndata_size)
897                 }
898             } else {
899                 revert(errorMessage);
900             }
901         }
902     }
903 }
904 
905 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
906 
907 
908 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
909 
910 pragma solidity ^0.8.0;
911 
912 
913 
914 
915 /**
916  * @title SafeERC20
917  * @dev Wrappers around ERC20 operations that throw on failure (when the token
918  * contract returns false). Tokens that return no value (and instead revert or
919  * throw on failure) are also supported, non-reverting calls are assumed to be
920  * successful.
921  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
922  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
923  */
924 library SafeERC20 {
925     using Address for address;
926 
927     function safeTransfer(
928         IERC20 token,
929         address to,
930         uint256 value
931     ) internal {
932         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
933     }
934 
935     function safeTransferFrom(
936         IERC20 token,
937         address from,
938         address to,
939         uint256 value
940     ) internal {
941         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
942     }
943 
944     /**
945      * @dev Deprecated. This function has issues similar to the ones found in
946      * {IERC20-approve}, and its usage is discouraged.
947      *
948      * Whenever possible, use {safeIncreaseAllowance} and
949      * {safeDecreaseAllowance} instead.
950      */
951     function safeApprove(
952         IERC20 token,
953         address spender,
954         uint256 value
955     ) internal {
956         // safeApprove should only be called when setting an initial allowance,
957         // or when resetting it to zero. To increase and decrease it, use
958         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
959         require(
960             (value == 0) || (token.allowance(address(this), spender) == 0),
961             "SafeERC20: approve from non-zero to non-zero allowance"
962         );
963         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
964     }
965 
966     function safeIncreaseAllowance(
967         IERC20 token,
968         address spender,
969         uint256 value
970     ) internal {
971         uint256 newAllowance = token.allowance(address(this), spender) + value;
972         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
973     }
974 
975     function safeDecreaseAllowance(
976         IERC20 token,
977         address spender,
978         uint256 value
979     ) internal {
980         unchecked {
981             uint256 oldAllowance = token.allowance(address(this), spender);
982             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
983             uint256 newAllowance = oldAllowance - value;
984             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
985         }
986     }
987 
988     function safePermit(
989         IERC20Permit token,
990         address owner,
991         address spender,
992         uint256 value,
993         uint256 deadline,
994         uint8 v,
995         bytes32 r,
996         bytes32 s
997     ) internal {
998         uint256 nonceBefore = token.nonces(owner);
999         token.permit(owner, spender, value, deadline, v, r, s);
1000         uint256 nonceAfter = token.nonces(owner);
1001         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1002     }
1003 
1004     /**
1005      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1006      * on the return value: the return value is optional (but if data is returned, it must not be false).
1007      * @param token The token targeted by the call.
1008      * @param data The call data (encoded using abi.encode or one of its variants).
1009      */
1010     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1011         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1012         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1013         // the target address contains contract code and also asserts for success in the low-level call.
1014 
1015         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1016         if (returndata.length > 0) {
1017             // Return data is optional
1018             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1019         }
1020     }
1021 }
1022 
1023 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
1024 
1025 
1026 // OpenZeppelin Contracts (last updated v4.7.0) (finance/PaymentSplitter.sol)
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 
1031 
1032 
1033 /**
1034  * @title PaymentSplitter
1035  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1036  * that the Ether will be split in this way, since it is handled transparently by the contract.
1037  *
1038  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1039  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1040  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
1041  * time of contract deployment and can't be updated thereafter.
1042  *
1043  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1044  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1045  * function.
1046  *
1047  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1048  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1049  * to run tests before sending real value to this contract.
1050  */
1051 contract PaymentSplitter is Context {
1052     event PayeeAdded(address account, uint256 shares);
1053     event PaymentReleased(address to, uint256 amount);
1054     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1055     event PaymentReceived(address from, uint256 amount);
1056 
1057     uint256 private _totalShares;
1058     uint256 private _totalReleased;
1059 
1060     mapping(address => uint256) private _shares;
1061     mapping(address => uint256) private _released;
1062     address[] private _payees;
1063 
1064     mapping(IERC20 => uint256) private _erc20TotalReleased;
1065     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1066 
1067     /**
1068      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1069      * the matching position in the `shares` array.
1070      *
1071      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1072      * duplicates in `payees`.
1073      */
1074     constructor(address[] memory payees, uint256[] memory shares_) payable {
1075         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1076         require(payees.length > 0, "PaymentSplitter: no payees");
1077 
1078         for (uint256 i = 0; i < payees.length; i++) {
1079             _addPayee(payees[i], shares_[i]);
1080         }
1081     }
1082 
1083     /**
1084      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1085      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1086      * reliability of the events, and not the actual splitting of Ether.
1087      *
1088      * To learn more about this see the Solidity documentation for
1089      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1090      * functions].
1091      */
1092     receive() external payable virtual {
1093         emit PaymentReceived(_msgSender(), msg.value);
1094     }
1095 
1096     /**
1097      * @dev Getter for the total shares held by payees.
1098      */
1099     function totalShares() public view returns (uint256) {
1100         return _totalShares;
1101     }
1102 
1103     /**
1104      * @dev Getter for the total amount of Ether already released.
1105      */
1106     function totalReleased() public view returns (uint256) {
1107         return _totalReleased;
1108     }
1109 
1110     /**
1111      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1112      * contract.
1113      */
1114     function totalReleased(IERC20 token) public view returns (uint256) {
1115         return _erc20TotalReleased[token];
1116     }
1117 
1118     /**
1119      * @dev Getter for the amount of shares held by an account.
1120      */
1121     function shares(address account) public view returns (uint256) {
1122         return _shares[account];
1123     }
1124 
1125     /**
1126      * @dev Getter for the amount of Ether already released to a payee.
1127      */
1128     function released(address account) public view returns (uint256) {
1129         return _released[account];
1130     }
1131 
1132     /**
1133      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1134      * IERC20 contract.
1135      */
1136     function released(IERC20 token, address account) public view returns (uint256) {
1137         return _erc20Released[token][account];
1138     }
1139 
1140     /**
1141      * @dev Getter for the address of the payee number `index`.
1142      */
1143     function payee(uint256 index) public view returns (address) {
1144         return _payees[index];
1145     }
1146 
1147     /**
1148      * @dev Getter for the amount of payee's releasable Ether.
1149      */
1150     function releasable(address account) public view returns (uint256) {
1151         uint256 totalReceived = address(this).balance + totalReleased();
1152         return _pendingPayment(account, totalReceived, released(account));
1153     }
1154 
1155     /**
1156      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1157      * IERC20 contract.
1158      */
1159     function releasable(IERC20 token, address account) public view returns (uint256) {
1160         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1161         return _pendingPayment(account, totalReceived, released(token, account));
1162     }
1163 
1164     /**
1165      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1166      * total shares and their previous withdrawals.
1167      */
1168     function release(address payable account) public virtual {
1169         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1170 
1171         uint256 payment = releasable(account);
1172 
1173         require(payment != 0, "PaymentSplitter: account is not due payment");
1174 
1175         _released[account] += payment;
1176         _totalReleased += payment;
1177 
1178         Address.sendValue(account, payment);
1179         emit PaymentReleased(account, payment);
1180     }
1181 
1182     /**
1183      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1184      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1185      * contract.
1186      */
1187     function release(IERC20 token, address account) public virtual {
1188         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1189 
1190         uint256 payment = releasable(token, account);
1191 
1192         require(payment != 0, "PaymentSplitter: account is not due payment");
1193 
1194         _erc20Released[token][account] += payment;
1195         _erc20TotalReleased[token] += payment;
1196 
1197         SafeERC20.safeTransfer(token, account, payment);
1198         emit ERC20PaymentReleased(token, account, payment);
1199     }
1200 
1201     /**
1202      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1203      * already released amounts.
1204      */
1205     function _pendingPayment(
1206         address account,
1207         uint256 totalReceived,
1208         uint256 alreadyReleased
1209     ) private view returns (uint256) {
1210         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1211     }
1212 
1213     /**
1214      * @dev Add a new payee to the contract.
1215      * @param account The address of the payee to add.
1216      * @param shares_ The number of shares owned by the payee.
1217      */
1218     function _addPayee(address account, uint256 shares_) private {
1219         require(account != address(0), "PaymentSplitter: account is the zero address");
1220         require(shares_ > 0, "PaymentSplitter: shares are 0");
1221         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1222 
1223         _payees.push(account);
1224         _shares[account] = shares_;
1225         _totalShares = _totalShares + shares_;
1226         emit PayeeAdded(account, shares_);
1227     }
1228 }
1229 
1230 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1231 
1232 
1233 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1234 
1235 pragma solidity ^0.8.0;
1236 
1237 /**
1238  * @title ERC721 token receiver interface
1239  * @dev Interface for any contract that wants to support safeTransfers
1240  * from ERC721 asset contracts.
1241  */
1242 interface IERC721Receiver {
1243     /**
1244      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1245      * by `operator` from `from`, this function is called.
1246      *
1247      * It must return its Solidity selector to confirm the token transfer.
1248      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1249      *
1250      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1251      */
1252     function onERC721Received(
1253         address operator,
1254         address from,
1255         uint256 tokenId,
1256         bytes calldata data
1257     ) external returns (bytes4);
1258 }
1259 
1260 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1261 
1262 
1263 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 /**
1268  * @dev Interface of the ERC165 standard, as defined in the
1269  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1270  *
1271  * Implementers can declare support of contract interfaces, which can then be
1272  * queried by others ({ERC165Checker}).
1273  *
1274  * For an implementation, see {ERC165}.
1275  */
1276 interface IERC165 {
1277     /**
1278      * @dev Returns true if this contract implements the interface defined by
1279      * `interfaceId`. See the corresponding
1280      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1281      * to learn more about how these ids are created.
1282      *
1283      * This function call must use less than 30 000 gas.
1284      */
1285     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1286 }
1287 
1288 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1289 
1290 
1291 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1292 
1293 pragma solidity ^0.8.0;
1294 
1295 
1296 /**
1297  * @dev Implementation of the {IERC165} interface.
1298  *
1299  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1300  * for the additional interface id that will be supported. For example:
1301  *
1302  * ```solidity
1303  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1304  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1305  * }
1306  * ```
1307  *
1308  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1309  */
1310 abstract contract ERC165 is IERC165 {
1311     /**
1312      * @dev See {IERC165-supportsInterface}.
1313      */
1314     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1315         return interfaceId == type(IERC165).interfaceId;
1316     }
1317 }
1318 
1319 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1320 
1321 
1322 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1323 
1324 pragma solidity ^0.8.0;
1325 
1326 
1327 /**
1328  * @dev Required interface of an ERC721 compliant contract.
1329  */
1330 interface IERC721 is IERC165 {
1331     /**
1332      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1333      */
1334     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1335 
1336     /**
1337      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1338      */
1339     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1340 
1341     /**
1342      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1343      */
1344     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1345 
1346     /**
1347      * @dev Returns the number of tokens in ``owner``'s account.
1348      */
1349     function balanceOf(address owner) external view returns (uint256 balance);
1350 
1351     /**
1352      * @dev Returns the owner of the `tokenId` token.
1353      *
1354      * Requirements:
1355      *
1356      * - `tokenId` must exist.
1357      */
1358     function ownerOf(uint256 tokenId) external view returns (address owner);
1359 
1360     /**
1361      * @dev Safely transfers `tokenId` token from `from` to `to`.
1362      *
1363      * Requirements:
1364      *
1365      * - `from` cannot be the zero address.
1366      * - `to` cannot be the zero address.
1367      * - `tokenId` token must exist and be owned by `from`.
1368      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1369      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1370      *
1371      * Emits a {Transfer} event.
1372      */
1373     function safeTransferFrom(
1374         address from,
1375         address to,
1376         uint256 tokenId,
1377         bytes calldata data
1378     ) external;
1379 
1380     /**
1381      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1382      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1383      *
1384      * Requirements:
1385      *
1386      * - `from` cannot be the zero address.
1387      * - `to` cannot be the zero address.
1388      * - `tokenId` token must exist and be owned by `from`.
1389      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1390      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function safeTransferFrom(
1395         address from,
1396         address to,
1397         uint256 tokenId
1398     ) external;
1399 
1400     /**
1401      * @dev Transfers `tokenId` token from `from` to `to`.
1402      *
1403      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1404      *
1405      * Requirements:
1406      *
1407      * - `from` cannot be the zero address.
1408      * - `to` cannot be the zero address.
1409      * - `tokenId` token must be owned by `from`.
1410      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1411      *
1412      * Emits a {Transfer} event.
1413      */
1414     function transferFrom(
1415         address from,
1416         address to,
1417         uint256 tokenId
1418     ) external;
1419 
1420     /**
1421      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1422      * The approval is cleared when the token is transferred.
1423      *
1424      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1425      *
1426      * Requirements:
1427      *
1428      * - The caller must own the token or be an approved operator.
1429      * - `tokenId` must exist.
1430      *
1431      * Emits an {Approval} event.
1432      */
1433     function approve(address to, uint256 tokenId) external;
1434 
1435     /**
1436      * @dev Approve or remove `operator` as an operator for the caller.
1437      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1438      *
1439      * Requirements:
1440      *
1441      * - The `operator` cannot be the caller.
1442      *
1443      * Emits an {ApprovalForAll} event.
1444      */
1445     function setApprovalForAll(address operator, bool _approved) external;
1446 
1447     /**
1448      * @dev Returns the account approved for `tokenId` token.
1449      *
1450      * Requirements:
1451      *
1452      * - `tokenId` must exist.
1453      */
1454     function getApproved(uint256 tokenId) external view returns (address operator);
1455 
1456     /**
1457      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1458      *
1459      * See {setApprovalForAll}
1460      */
1461     function isApprovedForAll(address owner, address operator) external view returns (bool);
1462 }
1463 
1464 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1465 
1466 
1467 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1468 
1469 pragma solidity ^0.8.0;
1470 
1471 
1472 /**
1473  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1474  * @dev See https://eips.ethereum.org/EIPS/eip-721
1475  */
1476 interface IERC721Enumerable is IERC721 {
1477     /**
1478      * @dev Returns the total amount of tokens stored by the contract.
1479      */
1480     function totalSupply() external view returns (uint256);
1481 
1482     /**
1483      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1484      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1485      */
1486     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1487 
1488     /**
1489      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1490      * Use along with {totalSupply} to enumerate all tokens.
1491      */
1492     function tokenByIndex(uint256 index) external view returns (uint256);
1493 }
1494 
1495 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1496 
1497 
1498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1499 
1500 pragma solidity ^0.8.0;
1501 
1502 
1503 /**
1504  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1505  * @dev See https://eips.ethereum.org/EIPS/eip-721
1506  */
1507 interface IERC721Metadata is IERC721 {
1508     /**
1509      * @dev Returns the token collection name.
1510      */
1511     function name() external view returns (string memory);
1512 
1513     /**
1514      * @dev Returns the token collection symbol.
1515      */
1516     function symbol() external view returns (string memory);
1517 
1518     /**
1519      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1520      */
1521     function tokenURI(uint256 tokenId) external view returns (string memory);
1522 }
1523 
1524 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1525 
1526 
1527 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1528 
1529 pragma solidity ^0.8.0;
1530 
1531 
1532 
1533 
1534 
1535 
1536 
1537 
1538 /**
1539  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1540  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1541  * {ERC721Enumerable}.
1542  */
1543 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1544     using Address for address;
1545     using Strings for uint256;
1546 
1547     // Token name
1548     string private _name;
1549 
1550     // Token symbol
1551     string private _symbol;
1552 
1553     // Mapping from token ID to owner address
1554     mapping(uint256 => address) private _owners;
1555 
1556     // Mapping owner address to token count
1557     mapping(address => uint256) private _balances;
1558 
1559     // Mapping from token ID to approved address
1560     mapping(uint256 => address) private _tokenApprovals;
1561 
1562     // Mapping from owner to operator approvals
1563     mapping(address => mapping(address => bool)) private _operatorApprovals;
1564 
1565     /**
1566      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1567      */
1568     constructor(string memory name_, string memory symbol_) {
1569         _name = name_;
1570         _symbol = symbol_;
1571     }
1572 
1573     /**
1574      * @dev See {IERC165-supportsInterface}.
1575      */
1576     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1577         return
1578             interfaceId == type(IERC721).interfaceId ||
1579             interfaceId == type(IERC721Metadata).interfaceId ||
1580             super.supportsInterface(interfaceId);
1581     }
1582 
1583     /**
1584      * @dev See {IERC721-balanceOf}.
1585      */
1586     function balanceOf(address owner) public view virtual override returns (uint256) {
1587         require(owner != address(0), "ERC721: address zero is not a valid owner");
1588         return _balances[owner];
1589     }
1590 
1591     /**
1592      * @dev See {IERC721-ownerOf}.
1593      */
1594     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1595         address owner = _owners[tokenId];
1596         require(owner != address(0), "ERC721: invalid token ID");
1597         return owner;
1598     }
1599 
1600     /**
1601      * @dev See {IERC721Metadata-name}.
1602      */
1603     function name() public view virtual override returns (string memory) {
1604         return _name;
1605     }
1606 
1607     /**
1608      * @dev See {IERC721Metadata-symbol}.
1609      */
1610     function symbol() public view virtual override returns (string memory) {
1611         return _symbol;
1612     }
1613 
1614     /**
1615      * @dev See {IERC721Metadata-tokenURI}.
1616      */
1617     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1618         _requireMinted(tokenId);
1619 
1620         string memory baseURI = _baseURI();
1621         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1622     }
1623 
1624     /**
1625      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1626      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1627      * by default, can be overridden in child contracts.
1628      */
1629     function _baseURI() internal view virtual returns (string memory) {
1630         return "";
1631     }
1632 
1633     /**
1634      * @dev See {IERC721-approve}.
1635      */
1636     function approve(address to, uint256 tokenId) public virtual override {
1637         address owner = ERC721.ownerOf(tokenId);
1638         require(to != owner, "ERC721: approval to current owner");
1639 
1640         require(
1641             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1642             "ERC721: approve caller is not token owner nor approved for all"
1643         );
1644 
1645         _approve(to, tokenId);
1646     }
1647 
1648     /**
1649      * @dev See {IERC721-getApproved}.
1650      */
1651     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1652         _requireMinted(tokenId);
1653 
1654         return _tokenApprovals[tokenId];
1655     }
1656 
1657     /**
1658      * @dev See {IERC721-setApprovalForAll}.
1659      */
1660     function setApprovalForAll(address operator, bool approved) public virtual override {
1661         _setApprovalForAll(_msgSender(), operator, approved);
1662     }
1663 
1664     /**
1665      * @dev See {IERC721-isApprovedForAll}.
1666      */
1667     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1668         return _operatorApprovals[owner][operator];
1669     }
1670 
1671     /**
1672      * @dev See {IERC721-transferFrom}.
1673      */
1674     function transferFrom(
1675         address from,
1676         address to,
1677         uint256 tokenId
1678     ) public virtual override {
1679         //solhint-disable-next-line max-line-length
1680         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1681 
1682         _transfer(from, to, tokenId);
1683     }
1684 
1685     /**
1686      * @dev See {IERC721-safeTransferFrom}.
1687      */
1688     function safeTransferFrom(
1689         address from,
1690         address to,
1691         uint256 tokenId
1692     ) public virtual override {
1693         safeTransferFrom(from, to, tokenId, "");
1694     }
1695 
1696     /**
1697      * @dev See {IERC721-safeTransferFrom}.
1698      */
1699     function safeTransferFrom(
1700         address from,
1701         address to,
1702         uint256 tokenId,
1703         bytes memory data
1704     ) public virtual override {
1705         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1706         _safeTransfer(from, to, tokenId, data);
1707     }
1708 
1709     /**
1710      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1711      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1712      *
1713      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1714      *
1715      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1716      * implement alternative mechanisms to perform token transfer, such as signature-based.
1717      *
1718      * Requirements:
1719      *
1720      * - `from` cannot be the zero address.
1721      * - `to` cannot be the zero address.
1722      * - `tokenId` token must exist and be owned by `from`.
1723      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1724      *
1725      * Emits a {Transfer} event.
1726      */
1727     function _safeTransfer(
1728         address from,
1729         address to,
1730         uint256 tokenId,
1731         bytes memory data
1732     ) internal virtual {
1733         _transfer(from, to, tokenId);
1734         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1735     }
1736 
1737     /**
1738      * @dev Returns whether `tokenId` exists.
1739      *
1740      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1741      *
1742      * Tokens start existing when they are minted (`_mint`),
1743      * and stop existing when they are burned (`_burn`).
1744      */
1745     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1746         return _owners[tokenId] != address(0);
1747     }
1748 
1749     /**
1750      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1751      *
1752      * Requirements:
1753      *
1754      * - `tokenId` must exist.
1755      */
1756     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1757         address owner = ERC721.ownerOf(tokenId);
1758         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1759     }
1760 
1761     /**
1762      * @dev Safely mints `tokenId` and transfers it to `to`.
1763      *
1764      * Requirements:
1765      *
1766      * - `tokenId` must not exist.
1767      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1768      *
1769      * Emits a {Transfer} event.
1770      */
1771     function _safeMint(address to, uint256 tokenId) internal virtual {
1772         _safeMint(to, tokenId, "");
1773     }
1774 
1775     /**
1776      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1777      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1778      */
1779     function _safeMint(
1780         address to,
1781         uint256 tokenId,
1782         bytes memory data
1783     ) internal virtual {
1784         _mint(to, tokenId);
1785         require(
1786             _checkOnERC721Received(address(0), to, tokenId, data),
1787             "ERC721: transfer to non ERC721Receiver implementer"
1788         );
1789     }
1790 
1791     /**
1792      * @dev Mints `tokenId` and transfers it to `to`.
1793      *
1794      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1795      *
1796      * Requirements:
1797      *
1798      * - `tokenId` must not exist.
1799      * - `to` cannot be the zero address.
1800      *
1801      * Emits a {Transfer} event.
1802      */
1803     function _mint(address to, uint256 tokenId) internal virtual {
1804         require(to != address(0), "ERC721: mint to the zero address");
1805         require(!_exists(tokenId), "ERC721: token already minted");
1806 
1807         _beforeTokenTransfer(address(0), to, tokenId);
1808 
1809         _balances[to] += 1;
1810         _owners[tokenId] = to;
1811 
1812         emit Transfer(address(0), to, tokenId);
1813 
1814         _afterTokenTransfer(address(0), to, tokenId);
1815     }
1816 
1817     /**
1818      * @dev Destroys `tokenId`.
1819      * The approval is cleared when the token is burned.
1820      *
1821      * Requirements:
1822      *
1823      * - `tokenId` must exist.
1824      *
1825      * Emits a {Transfer} event.
1826      */
1827     function _burn(uint256 tokenId) internal virtual {
1828         address owner = ERC721.ownerOf(tokenId);
1829 
1830         _beforeTokenTransfer(owner, address(0), tokenId);
1831 
1832         // Clear approvals
1833         _approve(address(0), tokenId);
1834 
1835         _balances[owner] -= 1;
1836         delete _owners[tokenId];
1837 
1838         emit Transfer(owner, address(0), tokenId);
1839 
1840         _afterTokenTransfer(owner, address(0), tokenId);
1841     }
1842 
1843     /**
1844      * @dev Transfers `tokenId` from `from` to `to`.
1845      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1846      *
1847      * Requirements:
1848      *
1849      * - `to` cannot be the zero address.
1850      * - `tokenId` token must be owned by `from`.
1851      *
1852      * Emits a {Transfer} event.
1853      */
1854     function _transfer(
1855         address from,
1856         address to,
1857         uint256 tokenId
1858     ) internal virtual {
1859         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1860         require(to != address(0), "ERC721: transfer to the zero address");
1861 
1862         _beforeTokenTransfer(from, to, tokenId);
1863 
1864         // Clear approvals from the previous owner
1865         _approve(address(0), tokenId);
1866 
1867         _balances[from] -= 1;
1868         _balances[to] += 1;
1869         _owners[tokenId] = to;
1870 
1871         emit Transfer(from, to, tokenId);
1872 
1873         _afterTokenTransfer(from, to, tokenId);
1874     }
1875 
1876     /**
1877      * @dev Approve `to` to operate on `tokenId`
1878      *
1879      * Emits an {Approval} event.
1880      */
1881     function _approve(address to, uint256 tokenId) internal virtual {
1882         _tokenApprovals[tokenId] = to;
1883         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1884     }
1885 
1886     /**
1887      * @dev Approve `operator` to operate on all of `owner` tokens
1888      *
1889      * Emits an {ApprovalForAll} event.
1890      */
1891     function _setApprovalForAll(
1892         address owner,
1893         address operator,
1894         bool approved
1895     ) internal virtual {
1896         require(owner != operator, "ERC721: approve to caller");
1897         _operatorApprovals[owner][operator] = approved;
1898         emit ApprovalForAll(owner, operator, approved);
1899     }
1900 
1901     /**
1902      * @dev Reverts if the `tokenId` has not been minted yet.
1903      */
1904     function _requireMinted(uint256 tokenId) internal view virtual {
1905         require(_exists(tokenId), "ERC721: invalid token ID");
1906     }
1907 
1908     /**
1909      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1910      * The call is not executed if the target address is not a contract.
1911      *
1912      * @param from address representing the previous owner of the given token ID
1913      * @param to target address that will receive the tokens
1914      * @param tokenId uint256 ID of the token to be transferred
1915      * @param data bytes optional data to send along with the call
1916      * @return bool whether the call correctly returned the expected magic value
1917      */
1918     function _checkOnERC721Received(
1919         address from,
1920         address to,
1921         uint256 tokenId,
1922         bytes memory data
1923     ) private returns (bool) {
1924         if (to.isContract()) {
1925             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1926                 return retval == IERC721Receiver.onERC721Received.selector;
1927             } catch (bytes memory reason) {
1928                 if (reason.length == 0) {
1929                     revert("ERC721: transfer to non ERC721Receiver implementer");
1930                 } else {
1931                     /// @solidity memory-safe-assembly
1932                     assembly {
1933                         revert(add(32, reason), mload(reason))
1934                     }
1935                 }
1936             }
1937         } else {
1938             return true;
1939         }
1940     }
1941 
1942     /**
1943      * @dev Hook that is called before any token transfer. This includes minting
1944      * and burning.
1945      *
1946      * Calling conditions:
1947      *
1948      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1949      * transferred to `to`.
1950      * - When `from` is zero, `tokenId` will be minted for `to`.
1951      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1952      * - `from` and `to` are never both zero.
1953      *
1954      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1955      */
1956     function _beforeTokenTransfer(
1957         address from,
1958         address to,
1959         uint256 tokenId
1960     ) internal virtual {}
1961 
1962     /**
1963      * @dev Hook that is called after any transfer of tokens. This includes
1964      * minting and burning.
1965      *
1966      * Calling conditions:
1967      *
1968      * - when `from` and `to` are both non-zero.
1969      * - `from` and `to` are never both zero.
1970      *
1971      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1972      */
1973     function _afterTokenTransfer(
1974         address from,
1975         address to,
1976         uint256 tokenId
1977     ) internal virtual {}
1978 }
1979 
1980 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1981 
1982 
1983 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1984 
1985 pragma solidity ^0.8.0;
1986 
1987 
1988 
1989 /**
1990  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1991  * enumerability of all the token ids in the contract as well as all token ids owned by each
1992  * account.
1993  */
1994 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1995     // Mapping from owner to list of owned token IDs
1996     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1997 
1998     // Mapping from token ID to index of the owner tokens list
1999     mapping(uint256 => uint256) private _ownedTokensIndex;
2000 
2001     // Array with all token ids, used for enumeration
2002     uint256[] private _allTokens;
2003 
2004     // Mapping from token id to position in the allTokens array
2005     mapping(uint256 => uint256) private _allTokensIndex;
2006 
2007     /**
2008      * @dev See {IERC165-supportsInterface}.
2009      */
2010     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2011         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2012     }
2013 
2014     /**
2015      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2016      */
2017     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2018         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2019         return _ownedTokens[owner][index];
2020     }
2021 
2022     /**
2023      * @dev See {IERC721Enumerable-totalSupply}.
2024      */
2025     function totalSupply() public view virtual override returns (uint256) {
2026         return _allTokens.length;
2027     }
2028 
2029     /**
2030      * @dev See {IERC721Enumerable-tokenByIndex}.
2031      */
2032     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2033         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2034         return _allTokens[index];
2035     }
2036 
2037     /**
2038      * @dev Hook that is called before any token transfer. This includes minting
2039      * and burning.
2040      *
2041      * Calling conditions:
2042      *
2043      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2044      * transferred to `to`.
2045      * - When `from` is zero, `tokenId` will be minted for `to`.
2046      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2047      * - `from` cannot be the zero address.
2048      * - `to` cannot be the zero address.
2049      *
2050      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2051      */
2052     function _beforeTokenTransfer(
2053         address from,
2054         address to,
2055         uint256 tokenId
2056     ) internal virtual override {
2057         super._beforeTokenTransfer(from, to, tokenId);
2058 
2059         if (from == address(0)) {
2060             _addTokenToAllTokensEnumeration(tokenId);
2061         } else if (from != to) {
2062             _removeTokenFromOwnerEnumeration(from, tokenId);
2063         }
2064         if (to == address(0)) {
2065             _removeTokenFromAllTokensEnumeration(tokenId);
2066         } else if (to != from) {
2067             _addTokenToOwnerEnumeration(to, tokenId);
2068         }
2069     }
2070 
2071     /**
2072      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2073      * @param to address representing the new owner of the given token ID
2074      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2075      */
2076     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2077         uint256 length = ERC721.balanceOf(to);
2078         _ownedTokens[to][length] = tokenId;
2079         _ownedTokensIndex[tokenId] = length;
2080     }
2081 
2082     /**
2083      * @dev Private function to add a token to this extension's token tracking data structures.
2084      * @param tokenId uint256 ID of the token to be added to the tokens list
2085      */
2086     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2087         _allTokensIndex[tokenId] = _allTokens.length;
2088         _allTokens.push(tokenId);
2089     }
2090 
2091     /**
2092      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2093      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2094      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2095      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2096      * @param from address representing the previous owner of the given token ID
2097      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2098      */
2099     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2100         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2101         // then delete the last slot (swap and pop).
2102 
2103         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2104         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2105 
2106         // When the token to delete is the last token, the swap operation is unnecessary
2107         if (tokenIndex != lastTokenIndex) {
2108             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2109 
2110             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2111             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2112         }
2113 
2114         // This also deletes the contents at the last position of the array
2115         delete _ownedTokensIndex[tokenId];
2116         delete _ownedTokens[from][lastTokenIndex];
2117     }
2118 
2119     /**
2120      * @dev Private function to remove a token from this extension's token tracking data structures.
2121      * This has O(1) time complexity, but alters the order of the _allTokens array.
2122      * @param tokenId uint256 ID of the token to be removed from the tokens list
2123      */
2124     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2125         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2126         // then delete the last slot (swap and pop).
2127 
2128         uint256 lastTokenIndex = _allTokens.length - 1;
2129         uint256 tokenIndex = _allTokensIndex[tokenId];
2130 
2131         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2132         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2133         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2134         uint256 lastTokenId = _allTokens[lastTokenIndex];
2135 
2136         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2137         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2138 
2139         // This also deletes the contents at the last position of the array
2140         delete _allTokensIndex[tokenId];
2141         _allTokens.pop();
2142     }
2143 }
2144 
2145 // File: poa/NFT.sol
2146 
2147 
2148 
2149 
2150 
2151 
2152 
2153 
2154 
2155 interface IPRE {
2156     function balanceOf(address user) external view returns (uint256);
2157 }
2158 
2159 contract POANFT is ERC721, ERC721Enumerable, Ownable, ReentrancyGuard {
2160     using Counters for Counters.Counter;
2161     string private _api_entry;
2162     address public token = 0x1d2d542e6D9d85A712deB4D1a7D96a16CE00B8cE;
2163     mapping (address => bool) private checkMint;
2164     Counters.Counter private _tokenIds;
2165     uint16 public constant MAX_SUPPLY = 1000;
2166     error AlreadyMinted();
2167     error ExceedMaxSupply();
2168 
2169     constructor() ERC721("Proof Of Apes", "POANFT") {
2170         _api_entry = "https://api.proofofapes.com/meta/";
2171         _tokenIds.increment();
2172     }
2173 
2174     function contractURI() public pure returns (string memory) {
2175 		return "https://api.proofofapes.com/contract/";
2176 	}
2177 
2178     function _baseURI() internal view override returns (string memory) {
2179         return _api_entry;
2180     }
2181 
2182     modifier canMint() {
2183         uint256 supply = totalSupply();
2184         if (supply + 1 > MAX_SUPPLY) revert ExceedMaxSupply();
2185         if (checkMint[msg.sender]) revert AlreadyMinted();
2186         _;
2187     }
2188 
2189     function mint() public nonReentrant canMint {
2190         uint256 balance = IPRE(token).balanceOf(msg.sender);
2191         if(balance > 50000000 * 10**18) { 
2192             checkMint[msg.sender] = true;
2193             _safeMint(msg.sender, _tokenIds.current());
2194             _tokenIds.increment();
2195         }
2196 	}
2197 
2198     function setToken(address _token) external onlyOwner { 
2199         token = _token;
2200     }
2201     
2202     function withdraw() public payable onlyOwner {
2203         require(payable(msg.sender).send(address(this).balance));
2204     }
2205 
2206     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
2207         uint tokenCount = balanceOf(_owner);
2208 
2209         uint256[] memory tokensId = new uint256[](tokenCount);
2210         for(uint i = 0; i < tokenCount; i++){
2211             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
2212         }
2213 
2214         return tokensId;
2215     }
2216 
2217     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
2218         super._beforeTokenTransfer(from, to, tokenId);
2219     }
2220 
2221     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
2222         return super.supportsInterface(interfaceId);
2223     }
2224 
2225     function recover(address _token) external onlyOwner {
2226         if (_token == 0x0000000000000000000000000000000000000000) {
2227             payable(msg.sender).call{value: address(this).balance}("");
2228         } else {
2229             IERC20 Token = IERC20(_token);
2230             Token.transfer(msg.sender, Token.balanceOf(address(this)));
2231         }
2232     }
2233 
2234 }