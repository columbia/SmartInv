1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/math/Math.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Standard math utilities missing in the Solidity language.
56  */
57 library Math {
58     enum Rounding {
59         Down, // Toward negative infinity
60         Up, // Toward infinity
61         Zero // Toward zero
62     }
63 
64     /**
65      * @dev Returns the largest of two numbers.
66      */
67     function max(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a >= b ? a : b;
69     }
70 
71     /**
72      * @dev Returns the smallest of two numbers.
73      */
74     function min(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a < b ? a : b;
76     }
77 
78     /**
79      * @dev Returns the average of two numbers. The result is rounded towards
80      * zero.
81      */
82     function average(uint256 a, uint256 b) internal pure returns (uint256) {
83         // (a + b) / 2 can overflow.
84         return (a & b) + (a ^ b) / 2;
85     }
86 
87     /**
88      * @dev Returns the ceiling of the division of two numbers.
89      *
90      * This differs from standard division with `/` in that it rounds up instead
91      * of rounding down.
92      */
93     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
94         // (a + b - 1) / b can overflow on addition, so we distribute.
95         return a == 0 ? 0 : (a - 1) / b + 1;
96     }
97 
98     /**
99      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
100      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
101      * with further edits by Uniswap Labs also under MIT license.
102      */
103     function mulDiv(
104         uint256 x,
105         uint256 y,
106         uint256 denominator
107     ) internal pure returns (uint256 result) {
108         unchecked {
109             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
110             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
111             // variables such that product = prod1 * 2^256 + prod0.
112             uint256 prod0; // Least significant 256 bits of the product
113             uint256 prod1; // Most significant 256 bits of the product
114             assembly {
115                 let mm := mulmod(x, y, not(0))
116                 prod0 := mul(x, y)
117                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
118             }
119 
120             // Handle non-overflow cases, 256 by 256 division.
121             if (prod1 == 0) {
122                 return prod0 / denominator;
123             }
124 
125             // Make sure the result is less than 2^256. Also prevents denominator == 0.
126             require(denominator > prod1);
127 
128             ///////////////////////////////////////////////
129             // 512 by 256 division.
130             ///////////////////////////////////////////////
131 
132             // Make division exact by subtracting the remainder from [prod1 prod0].
133             uint256 remainder;
134             assembly {
135                 // Compute remainder using mulmod.
136                 remainder := mulmod(x, y, denominator)
137 
138                 // Subtract 256 bit number from 512 bit number.
139                 prod1 := sub(prod1, gt(remainder, prod0))
140                 prod0 := sub(prod0, remainder)
141             }
142 
143             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
144             // See https://cs.stackexchange.com/q/138556/92363.
145 
146             // Does not overflow because the denominator cannot be zero at this stage in the function.
147             uint256 twos = denominator & (~denominator + 1);
148             assembly {
149                 // Divide denominator by twos.
150                 denominator := div(denominator, twos)
151 
152                 // Divide [prod1 prod0] by twos.
153                 prod0 := div(prod0, twos)
154 
155                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
156                 twos := add(div(sub(0, twos), twos), 1)
157             }
158 
159             // Shift in bits from prod1 into prod0.
160             prod0 |= prod1 * twos;
161 
162             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
163             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
164             // four bits. That is, denominator * inv = 1 mod 2^4.
165             uint256 inverse = (3 * denominator) ^ 2;
166 
167             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
168             // in modular arithmetic, doubling the correct bits in each step.
169             inverse *= 2 - denominator * inverse; // inverse mod 2^8
170             inverse *= 2 - denominator * inverse; // inverse mod 2^16
171             inverse *= 2 - denominator * inverse; // inverse mod 2^32
172             inverse *= 2 - denominator * inverse; // inverse mod 2^64
173             inverse *= 2 - denominator * inverse; // inverse mod 2^128
174             inverse *= 2 - denominator * inverse; // inverse mod 2^256
175 
176             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
177             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
178             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
179             // is no longer required.
180             result = prod0 * inverse;
181             return result;
182         }
183     }
184 
185     /**
186      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
187      */
188     function mulDiv(
189         uint256 x,
190         uint256 y,
191         uint256 denominator,
192         Rounding rounding
193     ) internal pure returns (uint256) {
194         uint256 result = mulDiv(x, y, denominator);
195         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
196             result += 1;
197         }
198         return result;
199     }
200 
201     /**
202      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
203      *
204      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
205      */
206     function sqrt(uint256 a) internal pure returns (uint256) {
207         if (a == 0) {
208             return 0;
209         }
210 
211         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
212         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
213         // `msb(a) <= a < 2*msb(a)`.
214         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
215         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
216         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
217         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
218         uint256 result = 1;
219         uint256 x = a;
220         if (x >> 128 > 0) {
221             x >>= 128;
222             result <<= 64;
223         }
224         if (x >> 64 > 0) {
225             x >>= 64;
226             result <<= 32;
227         }
228         if (x >> 32 > 0) {
229             x >>= 32;
230             result <<= 16;
231         }
232         if (x >> 16 > 0) {
233             x >>= 16;
234             result <<= 8;
235         }
236         if (x >> 8 > 0) {
237             x >>= 8;
238             result <<= 4;
239         }
240         if (x >> 4 > 0) {
241             x >>= 4;
242             result <<= 2;
243         }
244         if (x >> 2 > 0) {
245             result <<= 1;
246         }
247 
248         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
249         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
250         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
251         // into the expected uint128 result.
252         unchecked {
253             result = (result + a / result) >> 1;
254             result = (result + a / result) >> 1;
255             result = (result + a / result) >> 1;
256             result = (result + a / result) >> 1;
257             result = (result + a / result) >> 1;
258             result = (result + a / result) >> 1;
259             result = (result + a / result) >> 1;
260             return min(result, a / result);
261         }
262     }
263 
264     /**
265      * @notice Calculates sqrt(a), following the selected rounding direction.
266      */
267     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
268         uint256 result = sqrt(a);
269         if (rounding == Rounding.Up && result * result < a) {
270             result += 1;
271         }
272         return result;
273     }
274 }
275 
276 // File: @openzeppelin/contracts/utils/Arrays.sol
277 
278 
279 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 
284 /**
285  * @dev Collection of functions related to array types.
286  */
287 library Arrays {
288     /**
289      * @dev Searches a sorted `array` and returns the first index that contains
290      * a value greater or equal to `element`. If no such index exists (i.e. all
291      * values in the array are strictly less than `element`), the array length is
292      * returned. Time complexity O(log n).
293      *
294      * `array` is expected to be sorted in ascending order, and to contain no
295      * repeated elements.
296      */
297     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
298         if (array.length == 0) {
299             return 0;
300         }
301 
302         uint256 low = 0;
303         uint256 high = array.length;
304 
305         while (low < high) {
306             uint256 mid = Math.average(low, high);
307 
308             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
309             // because Math.average rounds down (it does integer division with truncation).
310             if (array[mid] > element) {
311                 high = mid;
312             } else {
313                 low = mid + 1;
314             }
315         }
316 
317         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
318         if (low > 0 && array[low - 1] == element) {
319             return low - 1;
320         } else {
321             return low;
322         }
323     }
324 }
325 
326 // File: @openzeppelin/contracts/utils/Context.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Provides information about the current execution context, including the
335  * sender of the transaction and its data. While these are generally available
336  * via msg.sender and msg.data, they should not be accessed in such a direct
337  * manner, since when dealing with meta-transactions the account sending and
338  * paying for execution may not be the actual sender (as far as an application
339  * is concerned).
340  *
341  * This contract is only required for intermediate, library-like contracts.
342  */
343 abstract contract Context {
344     function _msgSender() internal view virtual returns (address) {
345         return msg.sender;
346     }
347 
348     function _msgData() internal view virtual returns (bytes calldata) {
349         return msg.data;
350     }
351 }
352 
353 // File: @openzeppelin/contracts/security/Pausable.sol
354 
355 
356 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 
361 /**
362  * @dev Contract module which allows children to implement an emergency stop
363  * mechanism that can be triggered by an authorized account.
364  *
365  * This module is used through inheritance. It will make available the
366  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
367  * the functions of your contract. Note that they will not be pausable by
368  * simply including this module, only once the modifiers are put in place.
369  */
370 abstract contract Pausable is Context {
371     /**
372      * @dev Emitted when the pause is triggered by `account`.
373      */
374     event Paused(address account);
375 
376     /**
377      * @dev Emitted when the pause is lifted by `account`.
378      */
379     event Unpaused(address account);
380 
381     bool private _paused;
382 
383     /**
384      * @dev Initializes the contract in unpaused state.
385      */
386     constructor() {
387         _paused = false;
388     }
389 
390     /**
391      * @dev Modifier to make a function callable only when the contract is not paused.
392      *
393      * Requirements:
394      *
395      * - The contract must not be paused.
396      */
397     modifier whenNotPaused() {
398         _requireNotPaused();
399         _;
400     }
401 
402     /**
403      * @dev Modifier to make a function callable only when the contract is paused.
404      *
405      * Requirements:
406      *
407      * - The contract must be paused.
408      */
409     modifier whenPaused() {
410         _requirePaused();
411         _;
412     }
413 
414     /**
415      * @dev Returns true if the contract is paused, and false otherwise.
416      */
417     function paused() public view virtual returns (bool) {
418         return _paused;
419     }
420 
421     /**
422      * @dev Throws if the contract is paused.
423      */
424     function _requireNotPaused() internal view virtual {
425         require(!paused(), "Pausable: paused");
426     }
427 
428     /**
429      * @dev Throws if the contract is not paused.
430      */
431     function _requirePaused() internal view virtual {
432         require(paused(), "Pausable: not paused");
433     }
434 
435     /**
436      * @dev Triggers stopped state.
437      *
438      * Requirements:
439      *
440      * - The contract must not be paused.
441      */
442     function _pause() internal virtual whenNotPaused {
443         _paused = true;
444         emit Paused(_msgSender());
445     }
446 
447     /**
448      * @dev Returns to normal state.
449      *
450      * Requirements:
451      *
452      * - The contract must be paused.
453      */
454     function _unpause() internal virtual whenPaused {
455         _paused = false;
456         emit Unpaused(_msgSender());
457     }
458 }
459 
460 // File: @openzeppelin/contracts/access/Ownable.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @dev Contract module which provides a basic access control mechanism, where
470  * there is an account (an owner) that can be granted exclusive access to
471  * specific functions.
472  *
473  * By default, the owner account will be the one that deploys the contract. This
474  * can later be changed with {transferOwnership}.
475  *
476  * This module is used through inheritance. It will make available the modifier
477  * `onlyOwner`, which can be applied to your functions to restrict their use to
478  * the owner.
479  */
480 abstract contract Ownable is Context {
481     address private _owner;
482 
483     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
484 
485     /**
486      * @dev Initializes the contract setting the deployer as the initial owner.
487      */
488     constructor() {
489         _transferOwnership(_msgSender());
490     }
491 
492     /**
493      * @dev Throws if called by any account other than the owner.
494      */
495     modifier onlyOwner() {
496         _checkOwner();
497         _;
498     }
499 
500     /**
501      * @dev Returns the address of the current owner.
502      */
503     function owner() public view virtual returns (address) {
504         return _owner;
505     }
506 
507     /**
508      * @dev Throws if the sender is not the owner.
509      */
510     function _checkOwner() internal view virtual {
511         require(owner() == _msgSender(), "Ownable: caller is not the owner");
512     }
513 
514     /**
515      * @dev Leaves the contract without owner. It will not be possible to call
516      * `onlyOwner` functions anymore. Can only be called by the current owner.
517      *
518      * NOTE: Renouncing ownership will leave the contract without an owner,
519      * thereby removing any functionality that is only available to the owner.
520      */
521     function renounceOwnership() public virtual onlyOwner {
522         _transferOwnership(address(0));
523     }
524 
525     /**
526      * @dev Transfers ownership of the contract to a new account (`newOwner`).
527      * Can only be called by the current owner.
528      */
529     function transferOwnership(address newOwner) public virtual onlyOwner {
530         require(newOwner != address(0), "Ownable: new owner is the zero address");
531         _transferOwnership(newOwner);
532     }
533 
534     /**
535      * @dev Transfers ownership of the contract to a new account (`newOwner`).
536      * Internal function without access restriction.
537      */
538     function _transferOwnership(address newOwner) internal virtual {
539         address oldOwner = _owner;
540         _owner = newOwner;
541         emit OwnershipTransferred(oldOwner, newOwner);
542     }
543 }
544 
545 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
546 
547 
548 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @dev Interface of the ERC20 standard as defined in the EIP.
554  */
555 interface IERC20 {
556     /**
557      * @dev Emitted when `value` tokens are moved from one account (`from`) to
558      * another (`to`).
559      *
560      * Note that `value` may be zero.
561      */
562     event Transfer(address indexed from, address indexed to, uint256 value);
563 
564     /**
565      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
566      * a call to {approve}. `value` is the new allowance.
567      */
568     event Approval(address indexed owner, address indexed spender, uint256 value);
569 
570     /**
571      * @dev Returns the amount of tokens in existence.
572      */
573     function totalSupply() external view returns (uint256);
574 
575     /**
576      * @dev Returns the amount of tokens owned by `account`.
577      */
578     function balanceOf(address account) external view returns (uint256);
579 
580     /**
581      * @dev Moves `amount` tokens from the caller's account to `to`.
582      *
583      * Returns a boolean value indicating whether the operation succeeded.
584      *
585      * Emits a {Transfer} event.
586      */
587     function transfer(address to, uint256 amount) external returns (bool);
588 
589     /**
590      * @dev Returns the remaining number of tokens that `spender` will be
591      * allowed to spend on behalf of `owner` through {transferFrom}. This is
592      * zero by default.
593      *
594      * This value changes when {approve} or {transferFrom} are called.
595      */
596     function allowance(address owner, address spender) external view returns (uint256);
597 
598     /**
599      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
600      *
601      * Returns a boolean value indicating whether the operation succeeded.
602      *
603      * IMPORTANT: Beware that changing an allowance with this method brings the risk
604      * that someone may use both the old and the new allowance by unfortunate
605      * transaction ordering. One possible solution to mitigate this race
606      * condition is to first reduce the spender's allowance to 0 and set the
607      * desired value afterwards:
608      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
609      *
610      * Emits an {Approval} event.
611      */
612     function approve(address spender, uint256 amount) external returns (bool);
613 
614     /**
615      * @dev Moves `amount` tokens from `from` to `to` using the
616      * allowance mechanism. `amount` is then deducted from the caller's
617      * allowance.
618      *
619      * Returns a boolean value indicating whether the operation succeeded.
620      *
621      * Emits a {Transfer} event.
622      */
623     function transferFrom(
624         address from,
625         address to,
626         uint256 amount
627     ) external returns (bool);
628 }
629 
630 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
631 
632 
633 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @dev Interface for the optional metadata functions from the ERC20 standard.
640  *
641  * _Available since v4.1._
642  */
643 interface IERC20Metadata is IERC20 {
644     /**
645      * @dev Returns the name of the token.
646      */
647     function name() external view returns (string memory);
648 
649     /**
650      * @dev Returns the symbol of the token.
651      */
652     function symbol() external view returns (string memory);
653 
654     /**
655      * @dev Returns the decimals places of the token.
656      */
657     function decimals() external view returns (uint8);
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
661 
662 
663 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 
669 
670 /**
671  * @dev Implementation of the {IERC20} interface.
672  *
673  * This implementation is agnostic to the way tokens are created. This means
674  * that a supply mechanism has to be added in a derived contract using {_mint}.
675  * For a generic mechanism see {ERC20PresetMinterPauser}.
676  *
677  * TIP: For a detailed writeup see our guide
678  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
679  * to implement supply mechanisms].
680  *
681  * We have followed general OpenZeppelin Contracts guidelines: functions revert
682  * instead returning `false` on failure. This behavior is nonetheless
683  * conventional and does not conflict with the expectations of ERC20
684  * applications.
685  *
686  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
687  * This allows applications to reconstruct the allowance for all accounts just
688  * by listening to said events. Other implementations of the EIP may not emit
689  * these events, as it isn't required by the specification.
690  *
691  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
692  * functions have been added to mitigate the well-known issues around setting
693  * allowances. See {IERC20-approve}.
694  */
695 contract ERC20 is Context, IERC20, IERC20Metadata {
696     mapping(address => uint256) private _balances;
697 
698     mapping(address => mapping(address => uint256)) private _allowances;
699 
700     uint256 private _totalSupply;
701 
702     string private _name;
703     string private _symbol;
704 
705     /**
706      * @dev Sets the values for {name} and {symbol}.
707      *
708      * The default value of {decimals} is 18. To select a different value for
709      * {decimals} you should overload it.
710      *
711      * All two of these values are immutable: they can only be set once during
712      * construction.
713      */
714     constructor(string memory name_, string memory symbol_) {
715         _name = name_;
716         _symbol = symbol_;
717     }
718 
719     /**
720      * @dev Returns the name of the token.
721      */
722     function name() public view virtual override returns (string memory) {
723         return _name;
724     }
725 
726     /**
727      * @dev Returns the symbol of the token, usually a shorter version of the
728      * name.
729      */
730     function symbol() public view virtual override returns (string memory) {
731         return _symbol;
732     }
733 
734     /**
735      * @dev Returns the number of decimals used to get its user representation.
736      * For example, if `decimals` equals `2`, a balance of `505` tokens should
737      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
738      *
739      * Tokens usually opt for a value of 18, imitating the relationship between
740      * Ether and Wei. This is the value {ERC20} uses, unless this function is
741      * overridden;
742      *
743      * NOTE: This information is only used for _display_ purposes: it in
744      * no way affects any of the arithmetic of the contract, including
745      * {IERC20-balanceOf} and {IERC20-transfer}.
746      */
747     function decimals() public view virtual override returns (uint8) {
748         return 18;
749     }
750 
751     /**
752      * @dev See {IERC20-totalSupply}.
753      */
754     function totalSupply() public view virtual override returns (uint256) {
755         return _totalSupply;
756     }
757 
758     /**
759      * @dev See {IERC20-balanceOf}.
760      */
761     function balanceOf(address account) public view virtual override returns (uint256) {
762         return _balances[account];
763     }
764 
765     /**
766      * @dev See {IERC20-transfer}.
767      *
768      * Requirements:
769      *
770      * - `to` cannot be the zero address.
771      * - the caller must have a balance of at least `amount`.
772      */
773     function transfer(address to, uint256 amount) public virtual override returns (bool) {
774         address owner = _msgSender();
775         _transfer(owner, to, amount);
776         return true;
777     }
778 
779     /**
780      * @dev See {IERC20-allowance}.
781      */
782     function allowance(address owner, address spender) public view virtual override returns (uint256) {
783         return _allowances[owner][spender];
784     }
785 
786     /**
787      * @dev See {IERC20-approve}.
788      *
789      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
790      * `transferFrom`. This is semantically equivalent to an infinite approval.
791      *
792      * Requirements:
793      *
794      * - `spender` cannot be the zero address.
795      */
796     function approve(address spender, uint256 amount) public virtual override returns (bool) {
797         address owner = _msgSender();
798         _approve(owner, spender, amount);
799         return true;
800     }
801 
802     /**
803      * @dev See {IERC20-transferFrom}.
804      *
805      * Emits an {Approval} event indicating the updated allowance. This is not
806      * required by the EIP. See the note at the beginning of {ERC20}.
807      *
808      * NOTE: Does not update the allowance if the current allowance
809      * is the maximum `uint256`.
810      *
811      * Requirements:
812      *
813      * - `from` and `to` cannot be the zero address.
814      * - `from` must have a balance of at least `amount`.
815      * - the caller must have allowance for ``from``'s tokens of at least
816      * `amount`.
817      */
818     function transferFrom(
819         address from,
820         address to,
821         uint256 amount
822     ) public virtual override returns (bool) {
823         address spender = _msgSender();
824         _spendAllowance(from, spender, amount);
825         _transfer(from, to, amount);
826         return true;
827     }
828 
829     /**
830      * @dev Atomically increases the allowance granted to `spender` by the caller.
831      *
832      * This is an alternative to {approve} that can be used as a mitigation for
833      * problems described in {IERC20-approve}.
834      *
835      * Emits an {Approval} event indicating the updated allowance.
836      *
837      * Requirements:
838      *
839      * - `spender` cannot be the zero address.
840      */
841     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
842         address owner = _msgSender();
843         _approve(owner, spender, allowance(owner, spender) + addedValue);
844         return true;
845     }
846 
847     /**
848      * @dev Atomically decreases the allowance granted to `spender` by the caller.
849      *
850      * This is an alternative to {approve} that can be used as a mitigation for
851      * problems described in {IERC20-approve}.
852      *
853      * Emits an {Approval} event indicating the updated allowance.
854      *
855      * Requirements:
856      *
857      * - `spender` cannot be the zero address.
858      * - `spender` must have allowance for the caller of at least
859      * `subtractedValue`.
860      */
861     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
862         address owner = _msgSender();
863         uint256 currentAllowance = allowance(owner, spender);
864         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
865         unchecked {
866             _approve(owner, spender, currentAllowance - subtractedValue);
867         }
868 
869         return true;
870     }
871 
872     /**
873      * @dev Moves `amount` of tokens from `from` to `to`.
874      *
875      * This internal function is equivalent to {transfer}, and can be used to
876      * e.g. implement automatic token fees, slashing mechanisms, etc.
877      *
878      * Emits a {Transfer} event.
879      *
880      * Requirements:
881      *
882      * - `from` cannot be the zero address.
883      * - `to` cannot be the zero address.
884      * - `from` must have a balance of at least `amount`.
885      */
886     function _transfer(
887         address from,
888         address to,
889         uint256 amount
890     ) internal virtual {
891         require(from != address(0), "ERC20: transfer from the zero address");
892         require(to != address(0), "ERC20: transfer to the zero address");
893 
894         _beforeTokenTransfer(from, to, amount);
895 
896         uint256 fromBalance = _balances[from];
897         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
898         unchecked {
899             _balances[from] = fromBalance - amount;
900         }
901         _balances[to] += amount;
902 
903         emit Transfer(from, to, amount);
904 
905         _afterTokenTransfer(from, to, amount);
906     }
907 
908     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
909      * the total supply.
910      *
911      * Emits a {Transfer} event with `from` set to the zero address.
912      *
913      * Requirements:
914      *
915      * - `account` cannot be the zero address.
916      */
917     function _mint(address account, uint256 amount) internal virtual {
918         require(account != address(0), "ERC20: mint to the zero address");
919 
920         _beforeTokenTransfer(address(0), account, amount);
921 
922         _totalSupply += amount;
923         _balances[account] += amount;
924         emit Transfer(address(0), account, amount);
925 
926         _afterTokenTransfer(address(0), account, amount);
927     }
928 
929     /**
930      * @dev Destroys `amount` tokens from `account`, reducing the
931      * total supply.
932      *
933      * Emits a {Transfer} event with `to` set to the zero address.
934      *
935      * Requirements:
936      *
937      * - `account` cannot be the zero address.
938      * - `account` must have at least `amount` tokens.
939      */
940     function _burn(address account, uint256 amount) internal virtual {
941         require(account != address(0), "ERC20: burn from the zero address");
942 
943         _beforeTokenTransfer(account, address(0), amount);
944 
945         uint256 accountBalance = _balances[account];
946         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
947         unchecked {
948             _balances[account] = accountBalance - amount;
949         }
950         _totalSupply -= amount;
951 
952         emit Transfer(account, address(0), amount);
953 
954         _afterTokenTransfer(account, address(0), amount);
955     }
956 
957     /**
958      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
959      *
960      * This internal function is equivalent to `approve`, and can be used to
961      * e.g. set automatic allowances for certain subsystems, etc.
962      *
963      * Emits an {Approval} event.
964      *
965      * Requirements:
966      *
967      * - `owner` cannot be the zero address.
968      * - `spender` cannot be the zero address.
969      */
970     function _approve(
971         address owner,
972         address spender,
973         uint256 amount
974     ) internal virtual {
975         require(owner != address(0), "ERC20: approve from the zero address");
976         require(spender != address(0), "ERC20: approve to the zero address");
977 
978         _allowances[owner][spender] = amount;
979         emit Approval(owner, spender, amount);
980     }
981 
982     /**
983      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
984      *
985      * Does not update the allowance amount in case of infinite allowance.
986      * Revert if not enough allowance is available.
987      *
988      * Might emit an {Approval} event.
989      */
990     function _spendAllowance(
991         address owner,
992         address spender,
993         uint256 amount
994     ) internal virtual {
995         uint256 currentAllowance = allowance(owner, spender);
996         if (currentAllowance != type(uint256).max) {
997             require(currentAllowance >= amount, "ERC20: insufficient allowance");
998             unchecked {
999                 _approve(owner, spender, currentAllowance - amount);
1000             }
1001         }
1002     }
1003 
1004     /**
1005      * @dev Hook that is called before any transfer of tokens. This includes
1006      * minting and burning.
1007      *
1008      * Calling conditions:
1009      *
1010      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1011      * will be transferred to `to`.
1012      * - when `from` is zero, `amount` tokens will be minted for `to`.
1013      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1014      * - `from` and `to` are never both zero.
1015      *
1016      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1017      */
1018     function _beforeTokenTransfer(
1019         address from,
1020         address to,
1021         uint256 amount
1022     ) internal virtual {}
1023 
1024     /**
1025      * @dev Hook that is called after any transfer of tokens. This includes
1026      * minting and burning.
1027      *
1028      * Calling conditions:
1029      *
1030      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1031      * has been transferred to `to`.
1032      * - when `from` is zero, `amount` tokens have been minted for `to`.
1033      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1034      * - `from` and `to` are never both zero.
1035      *
1036      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1037      */
1038     function _afterTokenTransfer(
1039         address from,
1040         address to,
1041         uint256 amount
1042     ) internal virtual {}
1043 }
1044 
1045 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol
1046 
1047 
1048 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/extensions/ERC20Snapshot.sol)
1049 
1050 pragma solidity ^0.8.0;
1051 
1052 
1053 
1054 
1055 /**
1056  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1057  * total supply at the time are recorded for later access.
1058  *
1059  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1060  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1061  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1062  * used to create an efficient ERC20 forking mechanism.
1063  *
1064  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1065  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1066  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1067  * and the account address.
1068  *
1069  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
1070  * return `block.number` will trigger the creation of snapshot at the beginning of each new block. When overriding this
1071  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
1072  *
1073  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
1074  * alternative consider {ERC20Votes}.
1075  *
1076  * ==== Gas Costs
1077  *
1078  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1079  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1080  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1081  *
1082  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1083  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1084  * transfers will have normal cost until the next snapshot, and so on.
1085  */
1086 
1087 abstract contract ERC20Snapshot is ERC20 {
1088     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1089     // https://github.com/Giveth/minime/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1090 
1091     using Arrays for uint256[];
1092     using Counters for Counters.Counter;
1093 
1094     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1095     // Snapshot struct, but that would impede usage of functions that work on an array.
1096     struct Snapshots {
1097         uint256[] ids;
1098         uint256[] values;
1099     }
1100 
1101     mapping(address => Snapshots) private _accountBalanceSnapshots;
1102     Snapshots private _totalSupplySnapshots;
1103 
1104     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1105     Counters.Counter private _currentSnapshotId;
1106 
1107     /**
1108      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1109      */
1110     event Snapshot(uint256 id);
1111 
1112     /**
1113      * @dev Creates a new snapshot and returns its snapshot id.
1114      *
1115      * Emits a {Snapshot} event that contains the same id.
1116      *
1117      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1118      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1119      *
1120      * [WARNING]
1121      * ====
1122      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1123      * you must consider that it can potentially be used by attackers in two ways.
1124      *
1125      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1126      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1127      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1128      * section above.
1129      *
1130      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1131      * ====
1132      */
1133     function _snapshot() internal virtual returns (uint256) {
1134         _currentSnapshotId.increment();
1135 
1136         uint256 currentId = _getCurrentSnapshotId();
1137         emit Snapshot(currentId);
1138         return currentId;
1139     }
1140 
1141     /**
1142      * @dev Get the current snapshotId
1143      */
1144     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
1145         return _currentSnapshotId.current();
1146     }
1147 
1148     /**
1149      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1150      */
1151     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
1152         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1153 
1154         return snapshotted ? value : balanceOf(account);
1155     }
1156 
1157     /**
1158      * @dev Retrieves the total supply at the time `snapshotId` was created.
1159      */
1160     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
1161         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1162 
1163         return snapshotted ? value : totalSupply();
1164     }
1165 
1166     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1167     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1168     function _beforeTokenTransfer(
1169         address from,
1170         address to,
1171         uint256 amount
1172     ) internal virtual override {
1173         super._beforeTokenTransfer(from, to, amount);
1174 
1175         if (from == address(0)) {
1176             // mint
1177             _updateAccountSnapshot(to);
1178             _updateTotalSupplySnapshot();
1179         } else if (to == address(0)) {
1180             // burn
1181             _updateAccountSnapshot(from);
1182             _updateTotalSupplySnapshot();
1183         } else {
1184             // transfer
1185             _updateAccountSnapshot(from);
1186             _updateAccountSnapshot(to);
1187         }
1188     }
1189 
1190     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
1191         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1192         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
1193 
1194         // When a valid snapshot is queried, there are three possibilities:
1195         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1196         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1197         //  to this id is the current one.
1198         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1199         //  requested id, and its value is the one to return.
1200         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1201         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1202         //  larger than the requested one.
1203         //
1204         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1205         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1206         // exactly this.
1207 
1208         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1209 
1210         if (index == snapshots.ids.length) {
1211             return (false, 0);
1212         } else {
1213             return (true, snapshots.values[index]);
1214         }
1215     }
1216 
1217     function _updateAccountSnapshot(address account) private {
1218         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1219     }
1220 
1221     function _updateTotalSupplySnapshot() private {
1222         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1223     }
1224 
1225     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1226         uint256 currentId = _getCurrentSnapshotId();
1227         if (_lastSnapshotId(snapshots.ids) < currentId) {
1228             snapshots.ids.push(currentId);
1229             snapshots.values.push(currentValue);
1230         }
1231     }
1232 
1233     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1234         if (ids.length == 0) {
1235             return 0;
1236         } else {
1237             return ids[ids.length - 1];
1238         }
1239     }
1240 }
1241 
1242 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1243 
1244 
1245 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 
1250 
1251 /**
1252  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1253  * tokens and those that they have an allowance for, in a way that can be
1254  * recognized off-chain (via event analysis).
1255  */
1256 abstract contract ERC20Burnable is Context, ERC20 {
1257     /**
1258      * @dev Destroys `amount` tokens from the caller.
1259      *
1260      * See {ERC20-_burn}.
1261      */
1262     function burn(uint256 amount) public virtual {
1263         _burn(_msgSender(), amount);
1264     }
1265 
1266     /**
1267      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1268      * allowance.
1269      *
1270      * See {ERC20-_burn} and {ERC20-allowance}.
1271      *
1272      * Requirements:
1273      *
1274      * - the caller must have allowance for ``accounts``'s tokens of at least
1275      * `amount`.
1276      */
1277     function burnFrom(address account, uint256 amount) public virtual {
1278         _spendAllowance(account, _msgSender(), amount);
1279         _burn(account, amount);
1280     }
1281 }
1282 
1283 // File: Elan.sol
1284                                                                                                    
1285 pragma solidity ^0.8.4;
1286 
1287 
1288 
1289 
1290 
1291 
1292 interface IERC165 {
1293     /**
1294      * @dev Returns true if this contract implements the interface defined by
1295      * `interfaceId`. See the corresponding
1296      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1297      * to learn more about how these ids are created.
1298      *
1299      * This function call must use less than 30 000 gas.
1300      */
1301     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1302 }
1303 interface IERC721 is IERC165 {
1304     /**
1305      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1306      */
1307     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1308 
1309     /**
1310      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1311      */
1312     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1313 
1314     /**
1315      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1316      */
1317     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1318 
1319     /**
1320      * @dev Returns the number of tokens in ``owner``'s account.
1321      */
1322     function balanceOf(address owner) external view returns (uint256 balance);
1323 
1324     /**
1325      * @dev Returns the owner of the `tokenId` token.
1326      *
1327      * Requirements:
1328      *
1329      * - `tokenId` must exist.
1330      */
1331     function ownerOf(uint256 tokenId) external view returns (address owner);
1332 
1333     /**
1334      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1335      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1336      *
1337      * Requirements:
1338      *
1339      * - `from` cannot be the zero address.
1340      * - `to` cannot be the zero address.
1341      * - `tokenId` token must exist and be owned by `from`.
1342      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1343      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1348 
1349     /**
1350      * @dev Transfers `tokenId` token from `from` to `to`.
1351      *
1352      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1353      *
1354      * Requirements:
1355      *
1356      * - `from` cannot be the zero address.
1357      * - `to` cannot be the zero address.
1358      * - `tokenId` token must be owned by `from`.
1359      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1360      *
1361      * Emits a {Transfer} event.
1362      */
1363     function transferFrom(address from, address to, uint256 tokenId) external;
1364 
1365     /**
1366      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1367      * The approval is cleared when the token is transferred.
1368      *
1369      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1370      *
1371      * Requirements:
1372      *
1373      * - The caller must own the token or be an approved operator.
1374      * - `tokenId` must exist.
1375      *
1376      * Emits an {Approval} event.
1377      */
1378     function approve(address to, uint256 tokenId) external;
1379 
1380     /**
1381      * @dev Returns the account approved for `tokenId` token.
1382      *
1383      * Requirements:
1384      *
1385      * - `tokenId` must exist.
1386      */
1387     function getApproved(uint256 tokenId) external view returns (address operator);
1388 
1389     /**
1390      * @dev Approve or remove `operator` as an operator for the caller.
1391      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1392      *
1393      * Requirements:
1394      *
1395      * - The `operator` cannot be the caller.
1396      *
1397      * Emits an {ApprovalForAll} event.
1398      */
1399     function setApprovalForAll(address operator, bool _approved) external;
1400 
1401     /**
1402      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1403      *
1404      * See {setApprovalForAll}
1405      */
1406     function isApprovedForAll(address owner, address operator) external view returns (bool);
1407 
1408     /**
1409       * @dev Safely transfers `tokenId` token from `from` to `to`.
1410       *
1411       * Requirements:
1412       *
1413       * - `from` cannot be the zero address.
1414       * - `to` cannot be the zero address.
1415       * - `tokenId` token must exist and be owned by `from`.
1416       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1417       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1418       *
1419       * Emits a {Transfer} event.
1420       */
1421     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1422 }
1423 interface IERC721Enumerable is IERC721 {
1424 
1425     /**
1426      * @dev Returns the total amount of tokens stored by the contract.
1427      */
1428     function totalSupply() external view returns (uint256);
1429 
1430     /**
1431      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1432      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1433      */
1434     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1435 
1436     /**
1437      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1438      * Use along with {totalSupply} to enumerate all tokens.
1439      */
1440     function tokenByIndex(uint256 index) external view returns (uint256);
1441 }
1442 
1443 /// @custom:security-contact security@elanfuture.com
1444 contract Elan is ERC20, ERC20Burnable, ERC20Snapshot, Ownable, Pausable {
1445     uint constant public TOTAL_SUPPLY = 1000000000 * 10 ** 18; // 1B
1446     
1447     //BAYC
1448     address constant public BAYC_address = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
1449     uint constant public BAYC_claim_tokens = 2500;
1450     mapping(uint => bool) public BAYC_CLAIMED;
1451 
1452     //MAYC
1453     address constant public MAYC_address = 0x60E4d786628Fea6478F785A6d7e704777c86a7c6;
1454     uint constant public MAYC_claim_tokens = 1287133800000000000000; // 1287.1338 set in WEI unit to avoid fixed point conversion
1455     mapping(uint => bool) public MAYC_CLAIMED;
1456 
1457     uint public start_timestamp_60days;
1458     uint constant public timestamp_60days = 5184000;
1459 
1460     constructor() ERC20("Elan", "ELAN") {
1461 	    _mint(0xa0d59DF2F3095678A5e271e7211F48355eF1ffAe, 5000000 * 10 ** decimals()); //5M minted to Elan Operational Fund 0xa0d59DF2F3095678A5e271e7211F48355eF1ffAe
1462         _mint(0xf9DfD78c53557D42eb8e7C5F5633A3Dde8D503B4, 5000000 * 10 ** decimals()); //5M minted to Elan Promotional Fund 0xf9DfD78c53557D42eb8e7C5F5633A3Dde8D503B4
1463         _mint(0xAFbF80d4CE9E048D4aec5639e10E5eC5356bA6c4, 25000000 * 10 ** decimals()); //25M minted to Elan Early Investor Fund 0xAFbF80d4CE9E048D4aec5639e10E5eC5356bA6c4
1464         start_timestamp_60days = block.timestamp;
1465     }
1466 
1467     function BAYC_Holders_Claim() public whenNotPaused {
1468         require(block.timestamp <= start_timestamp_60days + timestamp_60days, "60 days claim period is over!!");
1469 
1470         IERC721Enumerable BAYC = IERC721Enumerable(BAYC_address);
1471         uint b = BAYC.balanceOf(msg.sender);
1472         uint count = 0;
1473         for(uint i = 0; i < b; i++){
1474             if(!BAYC_CLAIMED[BAYC.tokenOfOwnerByIndex(msg.sender, i)]){
1475                 BAYC_CLAIMED[BAYC.tokenOfOwnerByIndex(msg.sender, i)] = true;
1476                 count += BAYC_claim_tokens;
1477             }
1478         }
1479         _mint(msg.sender, count * 10 ** decimals());
1480     }
1481 
1482     function MAYC_Holders_Claim() public whenNotPaused {
1483         require(block.timestamp <= start_timestamp_60days + timestamp_60days, "60 days claim period is over!!");
1484 
1485         IERC721Enumerable MAYC = IERC721Enumerable(MAYC_address);
1486         uint b = MAYC.balanceOf(msg.sender);
1487         uint count = 0;
1488         for(uint i = 0; i < b; i++){
1489             if(!MAYC_CLAIMED[MAYC.tokenOfOwnerByIndex(msg.sender, i)]){
1490                 MAYC_CLAIMED[MAYC.tokenOfOwnerByIndex(msg.sender, i)] = true;
1491                 count += MAYC_claim_tokens;
1492             }
1493         }
1494         _mint(msg.sender, count);
1495     }
1496 
1497     function mint(address to, uint256 amount_in_eth_1) public onlyOwner {
1498         require(totalSupply() + amount_in_eth_1 * 10 ** 18 <= TOTAL_SUPPLY, "Request exceeds 1B Cap!!");
1499         _mint(to, amount_in_eth_1 * 10 ** 18);
1500     }
1501 
1502     function snapshot() public onlyOwner {
1503         _snapshot();
1504     }
1505 
1506     function pause() public onlyOwner {
1507         _pause();
1508     }
1509 
1510     function unpause() public onlyOwner {
1511         _unpause();
1512     }
1513 
1514     function _beforeTokenTransfer(address from, address to, uint256 amount)
1515         internal
1516         whenNotPaused
1517         override(ERC20, ERC20Snapshot)
1518     {
1519         super._beforeTokenTransfer(from, to, amount);
1520     }
1521 }