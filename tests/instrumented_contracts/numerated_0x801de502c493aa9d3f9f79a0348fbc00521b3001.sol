1 // File: contract-72404e8f5d_flat.sol
2 
3 
4 // File: @openzeppelin/contracts@4.7.3/utils/Counters.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @title Counters
13  * @author Matt Condon (@shrugs)
14  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
15  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
16  *
17  * Include with `using Counters for Counters.Counter;`
18  */
19 library Counters {
20     struct Counter {
21         // This variable should never be directly accessed by users of the library: interactions must be restricted to
22         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
23         // this feature: see https://github.com/ethereum/solidity/issues/4637
24         uint256 _value; // default: 0
25     }
26 
27     function current(Counter storage counter) internal view returns (uint256) {
28         return counter._value;
29     }
30 
31     function increment(Counter storage counter) internal {
32         unchecked {
33             counter._value += 1;
34         }
35     }
36 
37     function decrement(Counter storage counter) internal {
38         uint256 value = counter._value;
39         require(value > 0, "Counter: decrement overflow");
40         unchecked {
41             counter._value = value - 1;
42         }
43     }
44 
45     function reset(Counter storage counter) internal {
46         counter._value = 0;
47     }
48 }
49 
50 // File: @openzeppelin/contracts@4.7.3/utils/math/Math.sol
51 
52 
53 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
54 
55 pragma solidity ^0.8.0;
56 
57 /**
58  * @dev Standard math utilities missing in the Solidity language.
59  */
60 library Math {
61     enum Rounding {
62         Down, // Toward negative infinity
63         Up, // Toward infinity
64         Zero // Toward zero
65     }
66 
67     /**
68      * @dev Returns the largest of two numbers.
69      */
70     function max(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a >= b ? a : b;
72     }
73 
74     /**
75      * @dev Returns the smallest of two numbers.
76      */
77     function min(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a < b ? a : b;
79     }
80 
81     /**
82      * @dev Returns the average of two numbers. The result is rounded towards
83      * zero.
84      */
85     function average(uint256 a, uint256 b) internal pure returns (uint256) {
86         // (a + b) / 2 can overflow.
87         return (a & b) + (a ^ b) / 2;
88     }
89 
90     /**
91      * @dev Returns the ceiling of the division of two numbers.
92      *
93      * This differs from standard division with `/` in that it rounds up instead
94      * of rounding down.
95      */
96     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
97         // (a + b - 1) / b can overflow on addition, so we distribute.
98         return a == 0 ? 0 : (a - 1) / b + 1;
99     }
100 
101     /**
102      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
103      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
104      * with further edits by Uniswap Labs also under MIT license.
105      */
106     function mulDiv(
107         uint256 x,
108         uint256 y,
109         uint256 denominator
110     ) internal pure returns (uint256 result) {
111         unchecked {
112             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
113             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
114             // variables such that product = prod1 * 2^256 + prod0.
115             uint256 prod0; // Least significant 256 bits of the product
116             uint256 prod1; // Most significant 256 bits of the product
117             assembly {
118                 let mm := mulmod(x, y, not(0))
119                 prod0 := mul(x, y)
120                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
121             }
122 
123             // Handle non-overflow cases, 256 by 256 division.
124             if (prod1 == 0) {
125                 return prod0 / denominator;
126             }
127 
128             // Make sure the result is less than 2^256. Also prevents denominator == 0.
129             require(denominator > prod1);
130 
131             ///////////////////////////////////////////////
132             // 512 by 256 division.
133             ///////////////////////////////////////////////
134 
135             // Make division exact by subtracting the remainder from [prod1 prod0].
136             uint256 remainder;
137             assembly {
138                 // Compute remainder using mulmod.
139                 remainder := mulmod(x, y, denominator)
140 
141                 // Subtract 256 bit number from 512 bit number.
142                 prod1 := sub(prod1, gt(remainder, prod0))
143                 prod0 := sub(prod0, remainder)
144             }
145 
146             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
147             // See https://cs.stackexchange.com/q/138556/92363.
148 
149             // Does not overflow because the denominator cannot be zero at this stage in the function.
150             uint256 twos = denominator & (~denominator + 1);
151             assembly {
152                 // Divide denominator by twos.
153                 denominator := div(denominator, twos)
154 
155                 // Divide [prod1 prod0] by twos.
156                 prod0 := div(prod0, twos)
157 
158                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
159                 twos := add(div(sub(0, twos), twos), 1)
160             }
161 
162             // Shift in bits from prod1 into prod0.
163             prod0 |= prod1 * twos;
164 
165             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
166             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
167             // four bits. That is, denominator * inv = 1 mod 2^4.
168             uint256 inverse = (3 * denominator) ^ 2;
169 
170             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
171             // in modular arithmetic, doubling the correct bits in each step.
172             inverse *= 2 - denominator * inverse; // inverse mod 2^8
173             inverse *= 2 - denominator * inverse; // inverse mod 2^16
174             inverse *= 2 - denominator * inverse; // inverse mod 2^32
175             inverse *= 2 - denominator * inverse; // inverse mod 2^64
176             inverse *= 2 - denominator * inverse; // inverse mod 2^128
177             inverse *= 2 - denominator * inverse; // inverse mod 2^256
178 
179             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
180             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
181             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
182             // is no longer required.
183             result = prod0 * inverse;
184             return result;
185         }
186     }
187 
188     /**
189      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
190      */
191     function mulDiv(
192         uint256 x,
193         uint256 y,
194         uint256 denominator,
195         Rounding rounding
196     ) internal pure returns (uint256) {
197         uint256 result = mulDiv(x, y, denominator);
198         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
199             result += 1;
200         }
201         return result;
202     }
203 
204     /**
205      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
206      *
207      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
208      */
209     function sqrt(uint256 a) internal pure returns (uint256) {
210         if (a == 0) {
211             return 0;
212         }
213 
214         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
215         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
216         // `msb(a) <= a < 2*msb(a)`.
217         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
218         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
219         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
220         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
221         uint256 result = 1;
222         uint256 x = a;
223         if (x >> 128 > 0) {
224             x >>= 128;
225             result <<= 64;
226         }
227         if (x >> 64 > 0) {
228             x >>= 64;
229             result <<= 32;
230         }
231         if (x >> 32 > 0) {
232             x >>= 32;
233             result <<= 16;
234         }
235         if (x >> 16 > 0) {
236             x >>= 16;
237             result <<= 8;
238         }
239         if (x >> 8 > 0) {
240             x >>= 8;
241             result <<= 4;
242         }
243         if (x >> 4 > 0) {
244             x >>= 4;
245             result <<= 2;
246         }
247         if (x >> 2 > 0) {
248             result <<= 1;
249         }
250 
251         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
252         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
253         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
254         // into the expected uint128 result.
255         unchecked {
256             result = (result + a / result) >> 1;
257             result = (result + a / result) >> 1;
258             result = (result + a / result) >> 1;
259             result = (result + a / result) >> 1;
260             result = (result + a / result) >> 1;
261             result = (result + a / result) >> 1;
262             result = (result + a / result) >> 1;
263             return min(result, a / result);
264         }
265     }
266 
267     /**
268      * @notice Calculates sqrt(a), following the selected rounding direction.
269      */
270     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
271         uint256 result = sqrt(a);
272         if (rounding == Rounding.Up && result * result < a) {
273             result += 1;
274         }
275         return result;
276     }
277 }
278 
279 // File: @openzeppelin/contracts@4.7.3/utils/Arrays.sol
280 
281 
282 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
283 
284 pragma solidity ^0.8.0;
285 
286 
287 /**
288  * @dev Collection of functions related to array types.
289  */
290 library Arrays {
291     /**
292      * @dev Searches a sorted `array` and returns the first index that contains
293      * a value greater or equal to `element`. If no such index exists (i.e. all
294      * values in the array are strictly less than `element`), the array length is
295      * returned. Time complexity O(log n).
296      *
297      * `array` is expected to be sorted in ascending order, and to contain no
298      * repeated elements.
299      */
300     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
301         if (array.length == 0) {
302             return 0;
303         }
304 
305         uint256 low = 0;
306         uint256 high = array.length;
307 
308         while (low < high) {
309             uint256 mid = Math.average(low, high);
310 
311             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
312             // because Math.average rounds down (it does integer division with truncation).
313             if (array[mid] > element) {
314                 high = mid;
315             } else {
316                 low = mid + 1;
317             }
318         }
319 
320         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
321         if (low > 0 && array[low - 1] == element) {
322             return low - 1;
323         } else {
324             return low;
325         }
326     }
327 }
328 
329 // File: @openzeppelin/contracts@4.7.3/utils/Context.sol
330 
331 
332 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Provides information about the current execution context, including the
338  * sender of the transaction and its data. While these are generally available
339  * via msg.sender and msg.data, they should not be accessed in such a direct
340  * manner, since when dealing with meta-transactions the account sending and
341  * paying for execution may not be the actual sender (as far as an application
342  * is concerned).
343  *
344  * This contract is only required for intermediate, library-like contracts.
345  */
346 abstract contract Context {
347     function _msgSender() internal view virtual returns (address) {
348         return msg.sender;
349     }
350 
351     function _msgData() internal view virtual returns (bytes calldata) {
352         return msg.data;
353     }
354 }
355 
356 // File: @openzeppelin/contracts@4.7.3/access/Ownable.sol
357 
358 
359 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 
364 /**
365  * @dev Contract module which provides a basic access control mechanism, where
366  * there is an account (an owner) that can be granted exclusive access to
367  * specific functions.
368  *
369  * By default, the owner account will be the one that deploys the contract. This
370  * can later be changed with {transferOwnership}.
371  *
372  * This module is used through inheritance. It will make available the modifier
373  * `onlyOwner`, which can be applied to your functions to restrict their use to
374  * the owner.
375  */
376 abstract contract Ownable is Context {
377     address private _owner;
378 
379     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
380 
381     /**
382      * @dev Initializes the contract setting the deployer as the initial owner.
383      */
384     constructor() {
385         _transferOwnership(_msgSender());
386     }
387 
388     /**
389      * @dev Throws if called by any account other than the owner.
390      */
391     modifier onlyOwner() {
392         _checkOwner();
393         _;
394     }
395 
396     /**
397      * @dev Returns the address of the current owner.
398      */
399     function owner() public view virtual returns (address) {
400         return _owner;
401     }
402 
403     /**
404      * @dev Throws if the sender is not the owner.
405      */
406     function _checkOwner() internal view virtual {
407         require(owner() == _msgSender(), "Ownable: caller is not the owner");
408     }
409 
410     /**
411      * @dev Leaves the contract without owner. It will not be possible to call
412      * `onlyOwner` functions anymore. Can only be called by the current owner.
413      *
414      * NOTE: Renouncing ownership will leave the contract without an owner,
415      * thereby removing any functionality that is only available to the owner.
416      */
417     function renounceOwnership() public virtual onlyOwner {
418         _transferOwnership(address(0));
419     }
420 
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      * Can only be called by the current owner.
424      */
425     function transferOwnership(address newOwner) public virtual onlyOwner {
426         require(newOwner != address(0), "Ownable: new owner is the zero address");
427         _transferOwnership(newOwner);
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Internal function without access restriction.
433      */
434     function _transferOwnership(address newOwner) internal virtual {
435         address oldOwner = _owner;
436         _owner = newOwner;
437         emit OwnershipTransferred(oldOwner, newOwner);
438     }
439 }
440 
441 // File: @openzeppelin/contracts@4.7.3/token/ERC20/IERC20.sol
442 
443 
444 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev Interface of the ERC20 standard as defined in the EIP.
450  */
451 interface IERC20 {
452     /**
453      * @dev Emitted when `value` tokens are moved from one account (`from`) to
454      * another (`to`).
455      *
456      * Note that `value` may be zero.
457      */
458     event Transfer(address indexed from, address indexed to, uint256 value);
459 
460     /**
461      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
462      * a call to {approve}. `value` is the new allowance.
463      */
464     event Approval(address indexed owner, address indexed spender, uint256 value);
465 
466     /**
467      * @dev Returns the amount of tokens in existence.
468      */
469     function totalSupply() external view returns (uint256);
470 
471     /**
472      * @dev Returns the amount of tokens owned by `account`.
473      */
474     function balanceOf(address account) external view returns (uint256);
475 
476     /**
477      * @dev Moves `amount` tokens from the caller's account to `to`.
478      *
479      * Returns a boolean value indicating whether the operation succeeded.
480      *
481      * Emits a {Transfer} event.
482      */
483     function transfer(address to, uint256 amount) external returns (bool);
484 
485     /**
486      * @dev Returns the remaining number of tokens that `spender` will be
487      * allowed to spend on behalf of `owner` through {transferFrom}. This is
488      * zero by default.
489      *
490      * This value changes when {approve} or {transferFrom} are called.
491      */
492     function allowance(address owner, address spender) external view returns (uint256);
493 
494     /**
495      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
496      *
497      * Returns a boolean value indicating whether the operation succeeded.
498      *
499      * IMPORTANT: Beware that changing an allowance with this method brings the risk
500      * that someone may use both the old and the new allowance by unfortunate
501      * transaction ordering. One possible solution to mitigate this race
502      * condition is to first reduce the spender's allowance to 0 and set the
503      * desired value afterwards:
504      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
505      *
506      * Emits an {Approval} event.
507      */
508     function approve(address spender, uint256 amount) external returns (bool);
509 
510     /**
511      * @dev Moves `amount` tokens from `from` to `to` using the
512      * allowance mechanism. `amount` is then deducted from the caller's
513      * allowance.
514      *
515      * Returns a boolean value indicating whether the operation succeeded.
516      *
517      * Emits a {Transfer} event.
518      */
519     function transferFrom(
520         address from,
521         address to,
522         uint256 amount
523     ) external returns (bool);
524 }
525 
526 // File: @openzeppelin/contracts@4.7.3/token/ERC20/extensions/IERC20Metadata.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev Interface for the optional metadata functions from the ERC20 standard.
536  *
537  * _Available since v4.1._
538  */
539 interface IERC20Metadata is IERC20 {
540     /**
541      * @dev Returns the name of the token.
542      */
543     function name() external view returns (string memory);
544 
545     /**
546      * @dev Returns the symbol of the token.
547      */
548     function symbol() external view returns (string memory);
549 
550     /**
551      * @dev Returns the decimals places of the token.
552      */
553     function decimals() external view returns (uint8);
554 }
555 
556 // File: @openzeppelin/contracts@4.7.3/token/ERC20/ERC20.sol
557 
558 
559 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 
565 
566 /**
567  * @dev Implementation of the {IERC20} interface.
568  *
569  * This implementation is agnostic to the way tokens are created. This means
570  * that a supply mechanism has to be added in a derived contract using {_mint}.
571  * For a generic mechanism see {ERC20PresetMinterPauser}.
572  *
573  * TIP: For a detailed writeup see our guide
574  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
575  * to implement supply mechanisms].
576  *
577  * We have followed general OpenZeppelin Contracts guidelines: functions revert
578  * instead returning `false` on failure. This behavior is nonetheless
579  * conventional and does not conflict with the expectations of ERC20
580  * applications.
581  *
582  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
583  * This allows applications to reconstruct the allowance for all accounts just
584  * by listening to said events. Other implementations of the EIP may not emit
585  * these events, as it isn't required by the specification.
586  *
587  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
588  * functions have been added to mitigate the well-known issues around setting
589  * allowances. See {IERC20-approve}.
590  */
591 contract ERC20 is Context, IERC20, IERC20Metadata {
592     mapping(address => uint256) private _balances;
593 
594     mapping(address => mapping(address => uint256)) private _allowances;
595 
596     uint256 private _totalSupply;
597 
598     string private _name;
599     string private _symbol;
600 
601     /**
602      * @dev Sets the values for {name} and {symbol}.
603      *
604      * The default value of {decimals} is 18. To select a different value for
605      * {decimals} you should overload it.
606      *
607      * All two of these values are immutable: they can only be set once during
608      * construction.
609      */
610     constructor(string memory name_, string memory symbol_) {
611         _name = name_;
612         _symbol = symbol_;
613     }
614 
615     /**
616      * @dev Returns the name of the token.
617      */
618     function name() public view virtual override returns (string memory) {
619         return _name;
620     }
621 
622     /**
623      * @dev Returns the symbol of the token, usually a shorter version of the
624      * name.
625      */
626     function symbol() public view virtual override returns (string memory) {
627         return _symbol;
628     }
629 
630     /**
631      * @dev Returns the number of decimals used to get its user representation.
632      * For example, if `decimals` equals `2`, a balance of `505` tokens should
633      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
634      *
635      * Tokens usually opt for a value of 18, imitating the relationship between
636      * Ether and Wei. This is the value {ERC20} uses, unless this function is
637      * overridden;
638      *
639      * NOTE: This information is only used for _display_ purposes: it in
640      * no way affects any of the arithmetic of the contract, including
641      * {IERC20-balanceOf} and {IERC20-transfer}.
642      */
643     function decimals() public view virtual override returns (uint8) {
644         return 18;
645     }
646 
647     /**
648      * @dev See {IERC20-totalSupply}.
649      */
650     function totalSupply() public view virtual override returns (uint256) {
651         return _totalSupply;
652     }
653 
654     /**
655      * @dev See {IERC20-balanceOf}.
656      */
657     function balanceOf(address account) public view virtual override returns (uint256) {
658         return _balances[account];
659     }
660 
661     /**
662      * @dev See {IERC20-transfer}.
663      *
664      * Requirements:
665      *
666      * - `to` cannot be the zero address.
667      * - the caller must have a balance of at least `amount`.
668      */
669     function transfer(address to, uint256 amount) public virtual override returns (bool) {
670         address owner = _msgSender();
671         _transfer(owner, to, amount);
672         return true;
673     }
674 
675     /**
676      * @dev See {IERC20-allowance}.
677      */
678     function allowance(address owner, address spender) public view virtual override returns (uint256) {
679         return _allowances[owner][spender];
680     }
681 
682     /**
683      * @dev See {IERC20-approve}.
684      *
685      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
686      * `transferFrom`. This is semantically equivalent to an infinite approval.
687      *
688      * Requirements:
689      *
690      * - `spender` cannot be the zero address.
691      */
692     function approve(address spender, uint256 amount) public virtual override returns (bool) {
693         address owner = _msgSender();
694         _approve(owner, spender, amount);
695         return true;
696     }
697 
698     /**
699      * @dev See {IERC20-transferFrom}.
700      *
701      * Emits an {Approval} event indicating the updated allowance. This is not
702      * required by the EIP. See the note at the beginning of {ERC20}.
703      *
704      * NOTE: Does not update the allowance if the current allowance
705      * is the maximum `uint256`.
706      *
707      * Requirements:
708      *
709      * - `from` and `to` cannot be the zero address.
710      * - `from` must have a balance of at least `amount`.
711      * - the caller must have allowance for ``from``'s tokens of at least
712      * `amount`.
713      */
714     function transferFrom(
715         address from,
716         address to,
717         uint256 amount
718     ) public virtual override returns (bool) {
719         address spender = _msgSender();
720         _spendAllowance(from, spender, amount);
721         _transfer(from, to, amount);
722         return true;
723     }
724 
725     /**
726      * @dev Atomically increases the allowance granted to `spender` by the caller.
727      *
728      * This is an alternative to {approve} that can be used as a mitigation for
729      * problems described in {IERC20-approve}.
730      *
731      * Emits an {Approval} event indicating the updated allowance.
732      *
733      * Requirements:
734      *
735      * - `spender` cannot be the zero address.
736      */
737     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
738         address owner = _msgSender();
739         _approve(owner, spender, allowance(owner, spender) + addedValue);
740         return true;
741     }
742 
743     /**
744      * @dev Atomically decreases the allowance granted to `spender` by the caller.
745      *
746      * This is an alternative to {approve} that can be used as a mitigation for
747      * problems described in {IERC20-approve}.
748      *
749      * Emits an {Approval} event indicating the updated allowance.
750      *
751      * Requirements:
752      *
753      * - `spender` cannot be the zero address.
754      * - `spender` must have allowance for the caller of at least
755      * `subtractedValue`.
756      */
757     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
758         address owner = _msgSender();
759         uint256 currentAllowance = allowance(owner, spender);
760         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
761         unchecked {
762             _approve(owner, spender, currentAllowance - subtractedValue);
763         }
764 
765         return true;
766     }
767 
768     /**
769      * @dev Moves `amount` of tokens from `from` to `to`.
770      *
771      * This internal function is equivalent to {transfer}, and can be used to
772      * e.g. implement automatic token fees, slashing mechanisms, etc.
773      *
774      * Emits a {Transfer} event.
775      *
776      * Requirements:
777      *
778      * - `from` cannot be the zero address.
779      * - `to` cannot be the zero address.
780      * - `from` must have a balance of at least `amount`.
781      */
782     function _transfer(
783         address from,
784         address to,
785         uint256 amount
786     ) internal virtual {
787         require(from != address(0), "ERC20: transfer from the zero address");
788         require(to != address(0), "ERC20: transfer to the zero address");
789 
790         _beforeTokenTransfer(from, to, amount);
791 
792         uint256 fromBalance = _balances[from];
793         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
794         unchecked {
795             _balances[from] = fromBalance - amount;
796         }
797         _balances[to] += amount;
798 
799         emit Transfer(from, to, amount);
800 
801         _afterTokenTransfer(from, to, amount);
802     }
803 
804     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
805      * the total supply.
806      *
807      * Emits a {Transfer} event with `from` set to the zero address.
808      *
809      * Requirements:
810      *
811      * - `account` cannot be the zero address.
812      */
813     function _mint(address account, uint256 amount) internal virtual {
814         require(account != address(0), "ERC20: mint to the zero address");
815 
816         _beforeTokenTransfer(address(0), account, amount);
817 
818         _totalSupply += amount;
819         _balances[account] += amount;
820         emit Transfer(address(0), account, amount);
821 
822         _afterTokenTransfer(address(0), account, amount);
823     }
824 
825     /**
826      * @dev Destroys `amount` tokens from `account`, reducing the
827      * total supply.
828      *
829      * Emits a {Transfer} event with `to` set to the zero address.
830      *
831      * Requirements:
832      *
833      * - `account` cannot be the zero address.
834      * - `account` must have at least `amount` tokens.
835      */
836     function _burn(address account, uint256 amount) internal virtual {
837         require(account != address(0), "ERC20: burn from the zero address");
838 
839         _beforeTokenTransfer(account, address(0), amount);
840 
841         uint256 accountBalance = _balances[account];
842         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
843         unchecked {
844             _balances[account] = accountBalance - amount;
845         }
846         _totalSupply -= amount;
847 
848         emit Transfer(account, address(0), amount);
849 
850         _afterTokenTransfer(account, address(0), amount);
851     }
852 
853     /**
854      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
855      *
856      * This internal function is equivalent to `approve`, and can be used to
857      * e.g. set automatic allowances for certain subsystems, etc.
858      *
859      * Emits an {Approval} event.
860      *
861      * Requirements:
862      *
863      * - `owner` cannot be the zero address.
864      * - `spender` cannot be the zero address.
865      */
866     function _approve(
867         address owner,
868         address spender,
869         uint256 amount
870     ) internal virtual {
871         require(owner != address(0), "ERC20: approve from the zero address");
872         require(spender != address(0), "ERC20: approve to the zero address");
873 
874         _allowances[owner][spender] = amount;
875         emit Approval(owner, spender, amount);
876     }
877 
878     /**
879      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
880      *
881      * Does not update the allowance amount in case of infinite allowance.
882      * Revert if not enough allowance is available.
883      *
884      * Might emit an {Approval} event.
885      */
886     function _spendAllowance(
887         address owner,
888         address spender,
889         uint256 amount
890     ) internal virtual {
891         uint256 currentAllowance = allowance(owner, spender);
892         if (currentAllowance != type(uint256).max) {
893             require(currentAllowance >= amount, "ERC20: insufficient allowance");
894             unchecked {
895                 _approve(owner, spender, currentAllowance - amount);
896             }
897         }
898     }
899 
900     /**
901      * @dev Hook that is called before any transfer of tokens. This includes
902      * minting and burning.
903      *
904      * Calling conditions:
905      *
906      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
907      * will be transferred to `to`.
908      * - when `from` is zero, `amount` tokens will be minted for `to`.
909      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
910      * - `from` and `to` are never both zero.
911      *
912      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
913      */
914     function _beforeTokenTransfer(
915         address from,
916         address to,
917         uint256 amount
918     ) internal virtual {}
919 
920     /**
921      * @dev Hook that is called after any transfer of tokens. This includes
922      * minting and burning.
923      *
924      * Calling conditions:
925      *
926      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
927      * has been transferred to `to`.
928      * - when `from` is zero, `amount` tokens have been minted for `to`.
929      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
930      * - `from` and `to` are never both zero.
931      *
932      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
933      */
934     function _afterTokenTransfer(
935         address from,
936         address to,
937         uint256 amount
938     ) internal virtual {}
939 }
940 
941 // File: @openzeppelin/contracts@4.7.3/token/ERC20/extensions/ERC20Snapshot.sol
942 
943 
944 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/extensions/ERC20Snapshot.sol)
945 
946 pragma solidity ^0.8.0;
947 
948 
949 
950 
951 /**
952  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
953  * total supply at the time are recorded for later access.
954  *
955  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
956  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
957  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
958  * used to create an efficient ERC20 forking mechanism.
959  *
960  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
961  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
962  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
963  * and the account address.
964  *
965  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
966  * return `block.number` will trigger the creation of snapshot at the beginning of each new block. When overriding this
967  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
968  *
969  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
970  * alternative consider {ERC20Votes}.
971  *
972  * ==== Gas Costs
973  *
974  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
975  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
976  * smaller since identical balances in subsequent snapshots are stored as a single entry.
977  *
978  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
979  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
980  * transfers will have normal cost until the next snapshot, and so on.
981  */
982 
983 abstract contract ERC20Snapshot is ERC20 {
984     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
985     // https://github.com/Giveth/minime/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
986 
987     using Arrays for uint256[];
988     using Counters for Counters.Counter;
989 
990     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
991     // Snapshot struct, but that would impede usage of functions that work on an array.
992     struct Snapshots {
993         uint256[] ids;
994         uint256[] values;
995     }
996 
997     mapping(address => Snapshots) private _accountBalanceSnapshots;
998     Snapshots private _totalSupplySnapshots;
999 
1000     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1001     Counters.Counter private _currentSnapshotId;
1002 
1003     /**
1004      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1005      */
1006     event Snapshot(uint256 id);
1007 
1008     /**
1009      * @dev Creates a new snapshot and returns its snapshot id.
1010      *
1011      * Emits a {Snapshot} event that contains the same id.
1012      *
1013      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1014      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1015      *
1016      * [WARNING]
1017      * ====
1018      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1019      * you must consider that it can potentially be used by attackers in two ways.
1020      *
1021      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1022      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1023      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1024      * section above.
1025      *
1026      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1027      * ====
1028      */
1029     function _snapshot() internal virtual returns (uint256) {
1030         _currentSnapshotId.increment();
1031 
1032         uint256 currentId = _getCurrentSnapshotId();
1033         emit Snapshot(currentId);
1034         return currentId;
1035     }
1036 
1037     /**
1038      * @dev Get the current snapshotId
1039      */
1040     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
1041         return _currentSnapshotId.current();
1042     }
1043 
1044     /**
1045      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1046      */
1047     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
1048         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1049 
1050         return snapshotted ? value : balanceOf(account);
1051     }
1052 
1053     /**
1054      * @dev Retrieves the total supply at the time `snapshotId` was created.
1055      */
1056     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
1057         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1058 
1059         return snapshotted ? value : totalSupply();
1060     }
1061 
1062     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1063     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1064     function _beforeTokenTransfer(
1065         address from,
1066         address to,
1067         uint256 amount
1068     ) internal virtual override {
1069         super._beforeTokenTransfer(from, to, amount);
1070 
1071         if (from == address(0)) {
1072             // mint
1073             _updateAccountSnapshot(to);
1074             _updateTotalSupplySnapshot();
1075         } else if (to == address(0)) {
1076             // burn
1077             _updateAccountSnapshot(from);
1078             _updateTotalSupplySnapshot();
1079         } else {
1080             // transfer
1081             _updateAccountSnapshot(from);
1082             _updateAccountSnapshot(to);
1083         }
1084     }
1085 
1086     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
1087         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1088         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
1089 
1090         // When a valid snapshot is queried, there are three possibilities:
1091         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1092         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1093         //  to this id is the current one.
1094         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1095         //  requested id, and its value is the one to return.
1096         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1097         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1098         //  larger than the requested one.
1099         //
1100         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1101         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1102         // exactly this.
1103 
1104         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1105 
1106         if (index == snapshots.ids.length) {
1107             return (false, 0);
1108         } else {
1109             return (true, snapshots.values[index]);
1110         }
1111     }
1112 
1113     function _updateAccountSnapshot(address account) private {
1114         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1115     }
1116 
1117     function _updateTotalSupplySnapshot() private {
1118         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1119     }
1120 
1121     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1122         uint256 currentId = _getCurrentSnapshotId();
1123         if (_lastSnapshotId(snapshots.ids) < currentId) {
1124             snapshots.ids.push(currentId);
1125             snapshots.values.push(currentValue);
1126         }
1127     }
1128 
1129     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1130         if (ids.length == 0) {
1131             return 0;
1132         } else {
1133             return ids[ids.length - 1];
1134         }
1135     }
1136 }
1137 
1138 // File: @openzeppelin/contracts@4.7.3/token/ERC20/extensions/ERC20Burnable.sol
1139 
1140 
1141 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1142 
1143 pragma solidity ^0.8.0;
1144 
1145 
1146 
1147 /**
1148  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1149  * tokens and those that they have an allowance for, in a way that can be
1150  * recognized off-chain (via event analysis).
1151  */
1152 abstract contract ERC20Burnable is Context, ERC20 {
1153     /**
1154      * @dev Destroys `amount` tokens from the caller.
1155      *
1156      * See {ERC20-_burn}.
1157      */
1158     function burn(uint256 amount) public virtual {
1159         _burn(_msgSender(), amount);
1160     }
1161 
1162     /**
1163      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1164      * allowance.
1165      *
1166      * See {ERC20-_burn} and {ERC20-allowance}.
1167      *
1168      * Requirements:
1169      *
1170      * - the caller must have allowance for ``accounts``'s tokens of at least
1171      * `amount`.
1172      */
1173     function burnFrom(address account, uint256 amount) public virtual {
1174         _spendAllowance(account, _msgSender(), amount);
1175         _burn(account, amount);
1176     }
1177 }
1178 
1179 // File: contract-72404e8f5d.sol
1180 
1181 
1182 pragma solidity ^0.8.4;
1183 
1184 
1185 
1186 
1187 
1188 /// @custom:security-contact relaxable.com@gmail.com
1189 contract Relaxable is ERC20, ERC20Burnable, ERC20Snapshot, Ownable {
1190     constructor() ERC20("Relaxable", "RELAX") {
1191         _mint(msg.sender, 1000000000 * 10 ** decimals());
1192     }
1193 
1194     function snapshot() public onlyOwner {
1195         _snapshot();
1196     }
1197 
1198     // The following functions are overrides required by Solidity.
1199 
1200     function _beforeTokenTransfer(address from, address to, uint256 amount)
1201         internal
1202         override(ERC20, ERC20Snapshot)
1203     {
1204         super._beforeTokenTransfer(from, to, amount);
1205     }
1206 }