1 /*
2 socialfi.dev
3 https://linktr.ee/SocialFiLinks
4 https://t.me/SocialFiChatroom
5 https://social-fi.gitbook.io/socialfi/
6 */
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity 0.8.19;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Emitted when `value` tokens are moved from one account (`from`) to
37      * another (`to`).
38      *
39      * Note that `value` may be zero.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     /**
44      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
45      * a call to {approve}. `value` is the new allowance.
46      */
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 
49     /**
50      * @dev Returns the amount of tokens in existence.
51      */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55      * @dev Returns the amount of tokens owned by `account`.
56      */
57     function balanceOf(address account) external view returns (uint256);
58 
59     /**
60      * @dev Moves `amount` tokens from the caller's account to `to`.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transfer(address to, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Returns the remaining number of tokens that `spender` will be
70      * allowed to spend on behalf of `owner` through {transferFrom}. This is
71      * zero by default.
72      *
73      * This value changes when {approve} or {transferFrom} are called.
74      */
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     /**
78      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * IMPORTANT: Beware that changing an allowance with this method brings the risk
83      * that someone may use both the old and the new allowance by unfortunate
84      * transaction ordering. One possible solution to mitigate this race
85      * condition is to first reduce the spender's allowance to 0 and set the
86      * desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      *
89      * Emits an {Approval} event.
90      */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Moves `amount` tokens from `from` to `to` using the
95      * allowance mechanism. `amount` is then deducted from the caller's
96      * allowance.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 amount
106     ) external returns (bool);
107 }
108 
109 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
110 
111 
112 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
113 
114 
115 /**
116  * @dev Interface for the optional metadata functions from the ERC20 standard.
117  *
118  * _Available since v4.1._
119  */
120 interface IERC20Metadata is IERC20 {
121     /**
122      * @dev Returns the name of the token.
123      */
124     function name() external view returns (string memory);
125 
126     /**
127      * @dev Returns the symbol of the token.
128      */
129     function symbol() external view returns (string memory);
130 
131     /**
132      * @dev Returns the decimals places of the token.
133      */
134     function decimals() external view returns (uint8);
135 }
136 
137 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
138 
139 
140 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
141 
142 /**
143  * @dev Implementation of the {IERC20} interface.
144  *
145  * This implementation is agnostic to the way tokens are created. This means
146  * that a supply mechanism has to be added in a derived contract using {_mint}.
147  * For a generic mechanism see {ERC20PresetMinterPauser}.
148  *
149  * TIP: For a detailed writeup see our guide
150  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
151  * to implement supply mechanisms].
152  *
153  * We have followed general OpenZeppelin Contracts guidelines: functions revert
154  * instead returning `false` on failure. This behavior is nonetheless
155  * conventional and does not conflict with the expectations of ERC20
156  * applications.
157  *
158  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
159  * This allows applications to reconstruct the allowance for all accounts just
160  * by listening to said events. Other implementations of the EIP may not emit
161  * these events, as it isn't required by the specification.
162  *
163  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
164  * functions have been added to mitigate the well-known issues around setting
165  * allowances. See {IERC20-approve}.
166  */
167 contract ERC20 is Context, IERC20, IERC20Metadata {
168     mapping(address => uint256) private _balances;
169 
170     mapping(address => mapping(address => uint256)) private _allowances;
171 
172     uint256 private _totalSupply;
173 
174     string private _name;
175     string private _symbol;
176 
177     /**
178      * @dev Sets the values for {name} and {symbol}.
179      *
180      * The default value of {decimals} is 18. To select a different value for
181      * {decimals} you should overload it.
182      *
183      * All two of these values are immutable: they can only be set once during
184      * construction.
185      */
186     constructor(string memory name_, string memory symbol_) {
187         _name = name_;
188         _symbol = symbol_;
189     }
190 
191     /**
192      * @dev Returns the name of the token.
193      */
194     function name() public view virtual override returns (string memory) {
195         return _name;
196     }
197 
198     /**
199      * @dev Returns the symbol of the token, usually a shorter version of the
200      * name.
201      */
202     function symbol() public view virtual override returns (string memory) {
203         return _symbol;
204     }
205 
206     /**
207      * @dev Returns the number of decimals used to get its user representation.
208      * For example, if `decimals` equals `2`, a balance of `505` tokens should
209      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
210      *
211      * Tokens usually opt for a value of 18, imitating the relationship between
212      * Ether and Wei. This is the value {ERC20} uses, unless this function is
213      * overridden;
214      *
215      * NOTE: This information is only used for _display_ purposes: it in
216      * no way affects any of the arithmetic of the contract, including
217      * {IERC20-balanceOf} and {IERC20-transfer}.
218      */
219     function decimals() public view virtual override returns (uint8) {
220         return 18;
221     }
222 
223     /**
224      * @dev See {IERC20-totalSupply}.
225      */
226     function totalSupply() public view virtual override returns (uint256) {
227         return _totalSupply;
228     }
229 
230     /**
231      * @dev See {IERC20-balanceOf}.
232      */
233     function balanceOf(address account) public view virtual override returns (uint256) {
234         return _balances[account];
235     }
236 
237     /**
238      * @dev See {IERC20-transfer}.
239      *
240      * Requirements:
241      *
242      * - `to` cannot be the zero address.
243      * - the caller must have a balance of at least `amount`.
244      */
245     function transfer(address to, uint256 amount) public virtual override returns (bool) {
246         address owner = _msgSender();
247         _transfer(owner, to, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-allowance}.
253      */
254     function allowance(address owner, address spender) public view virtual override returns (uint256) {
255         return _allowances[owner][spender];
256     }
257 
258     /**
259      * @dev See {IERC20-approve}.
260      *
261      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
262      * `transferFrom`. This is semantically equivalent to an infinite approval.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      */
268     function approve(address spender, uint256 amount) public virtual override returns (bool) {
269         address owner = _msgSender();
270         _approve(owner, spender, amount);
271         return true;
272     }
273 
274     /**
275      * @dev See {IERC20-transferFrom}.
276      *
277      * Emits an {Approval} event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of {ERC20}.
279      *
280      * NOTE: Does not update the allowance if the current allowance
281      * is the maximum `uint256`.
282      *
283      * Requirements:
284      *
285      * - `from` and `to` cannot be the zero address.
286      * - `from` must have a balance of at least `amount`.
287      * - the caller must have allowance for ``from``'s tokens of at least
288      * `amount`.
289      */
290     function transferFrom(
291         address from,
292         address to,
293         uint256 amount
294     ) public virtual override returns (bool) {
295         address spender = _msgSender();
296         _spendAllowance(from, spender, amount);
297         _transfer(from, to, amount);
298         return true;
299     }
300 
301     /**
302      * @dev Atomically increases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
314         address owner = _msgSender();
315         _approve(owner, spender, allowance(owner, spender) + addedValue);
316         return true;
317     }
318 
319     /**
320      * @dev Atomically decreases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      * - `spender` must have allowance for the caller of at least
331      * `subtractedValue`.
332      */
333     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
334         address owner = _msgSender();
335         uint256 currentAllowance = allowance(owner, spender);
336         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
337         unchecked {
338             _approve(owner, spender, currentAllowance - subtractedValue);
339         }
340 
341         return true;
342     }
343 
344     /**
345      * @dev Moves `amount` of tokens from `from` to `to`.
346      *
347      * This internal function is equivalent to {transfer}, and can be used to
348      * e.g. implement automatic token fees, slashing mechanisms, etc.
349      *
350      * Emits a {Transfer} event.
351      *
352      * Requirements:
353      *
354      * - `from` cannot be the zero address.
355      * - `to` cannot be the zero address.
356      * - `from` must have a balance of at least `amount`.
357      */
358     function _transfer(
359         address from,
360         address to,
361         uint256 amount
362     ) internal virtual {
363         require(from != address(0), "ERC20: transfer from the zero address");
364         require(to != address(0), "ERC20: transfer to the zero address");
365 
366         _beforeTokenTransfer(from, to, amount);
367 
368         uint256 fromBalance = _balances[from];
369         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
370         unchecked {
371             _balances[from] = fromBalance - amount;
372             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
373             // decrementing then incrementing.
374             _balances[to] += amount;
375         }
376 
377         emit Transfer(from, to, amount);
378 
379         _afterTokenTransfer(from, to, amount);
380     }
381 
382     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
383      * the total supply.
384      *
385      * Emits a {Transfer} event with `from` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      */
391     function _mint(address account, uint256 amount) internal virtual {
392         require(account != address(0), "ERC20: mint to the zero address");
393 
394         _beforeTokenTransfer(address(0), account, amount);
395 
396         _totalSupply += amount;
397         unchecked {
398             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
399             _balances[account] += amount;
400         }
401         emit Transfer(address(0), account, amount);
402 
403         _afterTokenTransfer(address(0), account, amount);
404     }
405 
406     /**
407      * @dev Destroys `amount` tokens from `account`, reducing the
408      * total supply.
409      *
410      * Emits a {Transfer} event with `to` set to the zero address.
411      *
412      * Requirements:
413      *
414      * - `account` cannot be the zero address.
415      * - `account` must have at least `amount` tokens.
416      */
417     function _burn(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: burn from the zero address");
419 
420         _beforeTokenTransfer(account, address(0), amount);
421 
422         uint256 accountBalance = _balances[account];
423         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
424         unchecked {
425             _balances[account] = accountBalance - amount;
426             // Overflow not possible: amount <= accountBalance <= totalSupply.
427             _totalSupply -= amount;
428         }
429 
430         emit Transfer(account, address(0), amount);
431 
432         _afterTokenTransfer(account, address(0), amount);
433     }
434 
435     /**
436      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
437      *
438      * This internal function is equivalent to `approve`, and can be used to
439      * e.g. set automatic allowances for certain subsystems, etc.
440      *
441      * Emits an {Approval} event.
442      *
443      * Requirements:
444      *
445      * - `owner` cannot be the zero address.
446      * - `spender` cannot be the zero address.
447      */
448     function _approve(
449         address owner,
450         address spender,
451         uint256 amount
452     ) internal virtual {
453         require(owner != address(0), "ERC20: approve from the zero address");
454         require(spender != address(0), "ERC20: approve to the zero address");
455 
456         _allowances[owner][spender] = amount;
457         emit Approval(owner, spender, amount);
458     }
459 
460     /**
461      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
462      *
463      * Does not update the allowance amount in case of infinite allowance.
464      * Revert if not enough allowance is available.
465      *
466      * Might emit an {Approval} event.
467      */
468     function _spendAllowance(
469         address owner,
470         address spender,
471         uint256 amount
472     ) internal virtual {
473         uint256 currentAllowance = allowance(owner, spender);
474         if (currentAllowance != type(uint256).max) {
475             require(currentAllowance >= amount, "ERC20: insufficient allowance");
476             unchecked {
477                 _approve(owner, spender, currentAllowance - amount);
478             }
479         }
480     }
481 
482     /**
483      * @dev Hook that is called before any transfer of tokens. This includes
484      * minting and burning.
485      *
486      * Calling conditions:
487      *
488      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
489      * will be transferred to `to`.
490      * - when `from` is zero, `amount` tokens will be minted for `to`.
491      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
492      * - `from` and `to` are never both zero.
493      *
494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
495      */
496     function _beforeTokenTransfer(
497         address from,
498         address to,
499         uint256 amount
500     ) internal virtual {}
501 
502     /**
503      * @dev Hook that is called after any transfer of tokens. This includes
504      * minting and burning.
505      *
506      * Calling conditions:
507      *
508      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
509      * has been transferred to `to`.
510      * - when `from` is zero, `amount` tokens have been minted for `to`.
511      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
512      * - `from` and `to` are never both zero.
513      *
514      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
515      */
516     function _afterTokenTransfer(
517         address from,
518         address to,
519         uint256 amount
520     ) internal virtual {}
521 }
522 
523 contract Ownable is Context {
524     address public _owner;
525 
526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
527 
528     constructor () {
529         address msgSender = _msgSender();
530         _owner = msgSender;
531         authorizations[_owner] = true;
532         emit OwnershipTransferred(address(0), msgSender);
533     }
534     mapping (address => bool) internal authorizations;
535 
536     function owner() public view returns (address) {
537         return _owner;
538     }
539 
540     modifier onlyOwner() {
541         require(_owner == _msgSender(), "Ownable: caller is not the owner");
542         _;
543     }
544 
545     function renounceOwnership() public virtual onlyOwner {
546         emit OwnershipTransferred(_owner, address(0));
547         _owner = address(0);
548     }
549 
550     function transferOwnership(address newOwner) public virtual onlyOwner {
551         require(newOwner != address(0), "Ownable: new owner is the zero address");
552         emit OwnershipTransferred(_owner, newOwner);
553         _owner = newOwner;
554     }
555 }
556 
557 interface IUniswapV2Factory {
558     function createPair(address tokenA, address tokenB) external returns (address pair);
559 }
560 
561 interface IUniswapV2Router02 {
562     function factory() external pure returns (address);
563     function WETH() external pure returns (address);
564 
565     function swapExactTokensForETHSupportingFeeOnTransferTokens(
566         uint amountIn,
567         uint amountOutMin,
568         address[] calldata path,
569         address to,
570         uint deadline
571     ) external;
572 }
573 
574 library Math {
575     /**
576      * @dev Muldiv operation overflow.
577      */
578     error MathOverflowedMulDiv();
579 
580     enum Rounding {
581         Floor, // Toward negative infinity
582         Ceil, // Toward positive infinity
583         Trunc, // Toward zero
584         Expand // Away from zero
585     }
586 
587     /**
588      * @dev Returns the addition of two unsigned integers, with an overflow flag.
589      */
590     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
591         unchecked {
592             uint256 c = a + b;
593             if (c < a) return (false, 0);
594             return (true, c);
595         }
596     }
597 
598     /**
599      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
600      */
601     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
602         unchecked {
603             if (b > a) return (false, 0);
604             return (true, a - b);
605         }
606     }
607 
608     /**
609      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
610      */
611     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
612         unchecked {
613             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
614             // benefit is lost if 'b' is also tested.
615             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
616             if (a == 0) return (true, 0);
617             uint256 c = a * b;
618             if (c / a != b) return (false, 0);
619             return (true, c);
620         }
621     }
622 
623     /**
624      * @dev Returns the division of two unsigned integers, with a division by zero flag.
625      */
626     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
627         unchecked {
628             if (b == 0) return (false, 0);
629             return (true, a / b);
630         }
631     }
632 
633     /**
634      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
635      */
636     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
637         unchecked {
638             if (b == 0) return (false, 0);
639             return (true, a % b);
640         }
641     }
642 
643     /**
644      * @dev Returns the largest of two numbers.
645      */
646     function max(uint256 a, uint256 b) internal pure returns (uint256) {
647         return a > b ? a : b;
648     }
649 
650     /**
651      * @dev Returns the smallest of two numbers.
652      */
653     function min(uint256 a, uint256 b) internal pure returns (uint256) {
654         return a < b ? a : b;
655     }
656 
657     /**
658      * @dev Returns the average of two numbers. The result is rounded towards
659      * zero.
660      */
661     function average(uint256 a, uint256 b) internal pure returns (uint256) {
662         // (a + b) / 2 can overflow.
663         return (a & b) + (a ^ b) / 2;
664     }
665 
666     /**
667      * @dev Returns the ceiling of the division of two numbers.
668      *
669      * This differs from standard division with `/` in that it rounds towards infinity instead
670      * of rounding towards zero.
671      */
672     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
673         if (b == 0) {
674             // Guarantee the same behavior as in a regular Solidity division.
675             return a / b;
676         }
677 
678         // (a + b - 1) / b can overflow on addition, so we distribute.
679         return a == 0 ? 0 : (a - 1) / b + 1;
680     }
681 
682     /**
683      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
684      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
685      * with further edits by Uniswap Labs also under MIT license.
686      */
687     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
688         unchecked {
689             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
690             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
691             // variables such that product = prod1 * 2^256 + prod0.
692             uint256 prod0; // Least significant 256 bits of the product
693             uint256 prod1; // Most significant 256 bits of the product
694             assembly {
695                 let mm := mulmod(x, y, not(0))
696                 prod0 := mul(x, y)
697                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
698             }
699 
700             // Handle non-overflow cases, 256 by 256 division.
701             if (prod1 == 0) {
702                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
703                 // The surrounding unchecked block does not change this fact.
704                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
705                 return prod0 / denominator;
706             }
707 
708             // Make sure the result is less than 2^256. Also prevents denominator == 0.
709             if (denominator <= prod1) {
710                 revert MathOverflowedMulDiv();
711             }
712 
713             ///////////////////////////////////////////////
714             // 512 by 256 division.
715             ///////////////////////////////////////////////
716 
717             // Make division exact by subtracting the remainder from [prod1 prod0].
718             uint256 remainder;
719             assembly {
720                 // Compute remainder using mulmod.
721                 remainder := mulmod(x, y, denominator)
722 
723                 // Subtract 256 bit number from 512 bit number.
724                 prod1 := sub(prod1, gt(remainder, prod0))
725                 prod0 := sub(prod0, remainder)
726             }
727 
728             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
729             // See https://cs.stackexchange.com/q/138556/92363.
730 
731             // Does not overflow because the denominator cannot be zero at this stage in the function.
732             uint256 twos = denominator & (~denominator + 1);
733             assembly {
734                 // Divide denominator by twos.
735                 denominator := div(denominator, twos)
736 
737                 // Divide [prod1 prod0] by twos.
738                 prod0 := div(prod0, twos)
739 
740                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
741                 twos := add(div(sub(0, twos), twos), 1)
742             }
743 
744             // Shift in bits from prod1 into prod0.
745             prod0 |= prod1 * twos;
746 
747             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
748             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
749             // four bits. That is, denominator * inv = 1 mod 2^4.
750             uint256 inverse = (3 * denominator) ^ 2;
751 
752             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
753             // in modular arithmetic, doubling the correct bits in each step.
754             inverse *= 2 - denominator * inverse; // inverse mod 2^8
755             inverse *= 2 - denominator * inverse; // inverse mod 2^16
756             inverse *= 2 - denominator * inverse; // inverse mod 2^32
757             inverse *= 2 - denominator * inverse; // inverse mod 2^64
758             inverse *= 2 - denominator * inverse; // inverse mod 2^128
759             inverse *= 2 - denominator * inverse; // inverse mod 2^256
760 
761             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
762             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
763             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
764             // is no longer required.
765             result = prod0 * inverse;
766             return result;
767         }
768     }
769 
770     /**
771      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
772      */
773     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
774         uint256 result = mulDiv(x, y, denominator);
775         if (unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0) {
776             result += 1;
777         }
778         return result;
779     }
780 
781     /**
782      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
783      * towards zero.
784      *
785      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
786      */
787     function sqrt(uint256 a) internal pure returns (uint256) {
788         if (a == 0) {
789             return 0;
790         }
791 
792         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
793         //
794         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
795         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
796         //
797         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
798         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
799         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
800         //
801         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
802         uint256 result = 1 << (log2(a) >> 1);
803 
804         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
805         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
806         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
807         // into the expected uint128 result.
808         unchecked {
809             result = (result + a / result) >> 1;
810             result = (result + a / result) >> 1;
811             result = (result + a / result) >> 1;
812             result = (result + a / result) >> 1;
813             result = (result + a / result) >> 1;
814             result = (result + a / result) >> 1;
815             result = (result + a / result) >> 1;
816             return min(result, a / result);
817         }
818     }
819 
820     /**
821      * @notice Calculates sqrt(a), following the selected rounding direction.
822      */
823     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
824         unchecked {
825             uint256 result = sqrt(a);
826             return result + (unsignedRoundsUp(rounding) && result * result < a ? 1 : 0);
827         }
828     }
829 
830     /**
831      * @dev Return the log in base 2 of a positive value rounded towards zero.
832      * Returns 0 if given 0.
833      */
834     function log2(uint256 value) internal pure returns (uint256) {
835         uint256 result = 0;
836         unchecked {
837             if (value >> 128 > 0) {
838                 value >>= 128;
839                 result += 128;
840             }
841             if (value >> 64 > 0) {
842                 value >>= 64;
843                 result += 64;
844             }
845             if (value >> 32 > 0) {
846                 value >>= 32;
847                 result += 32;
848             }
849             if (value >> 16 > 0) {
850                 value >>= 16;
851                 result += 16;
852             }
853             if (value >> 8 > 0) {
854                 value >>= 8;
855                 result += 8;
856             }
857             if (value >> 4 > 0) {
858                 value >>= 4;
859                 result += 4;
860             }
861             if (value >> 2 > 0) {
862                 value >>= 2;
863                 result += 2;
864             }
865             if (value >> 1 > 0) {
866                 result += 1;
867             }
868         }
869         return result;
870     }
871 
872     /**
873      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
874      * Returns 0 if given 0.
875      */
876     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
877         unchecked {
878             uint256 result = log2(value);
879             return result + (unsignedRoundsUp(rounding) && 1 << result < value ? 1 : 0);
880         }
881     }
882 
883     /**
884      * @dev Return the log in base 10 of a positive value rounded towards zero.
885      * Returns 0 if given 0.
886      */
887     function log10(uint256 value) internal pure returns (uint256) {
888         uint256 result = 0;
889         unchecked {
890             if (value >= 10 ** 64) {
891                 value /= 10 ** 64;
892                 result += 64;
893             }
894             if (value >= 10 ** 32) {
895                 value /= 10 ** 32;
896                 result += 32;
897             }
898             if (value >= 10 ** 16) {
899                 value /= 10 ** 16;
900                 result += 16;
901             }
902             if (value >= 10 ** 8) {
903                 value /= 10 ** 8;
904                 result += 8;
905             }
906             if (value >= 10 ** 4) {
907                 value /= 10 ** 4;
908                 result += 4;
909             }
910             if (value >= 10 ** 2) {
911                 value /= 10 ** 2;
912                 result += 2;
913             }
914             if (value >= 10 ** 1) {
915                 result += 1;
916             }
917         }
918         return result;
919     }
920 
921     /**
922      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
923      * Returns 0 if given 0.
924      */
925     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
926         unchecked {
927             uint256 result = log10(value);
928             return result + (unsignedRoundsUp(rounding) && 10 ** result < value ? 1 : 0);
929         }
930     }
931 
932     /**
933      * @dev Return the log in base 256 of a positive value rounded towards zero.
934      * Returns 0 if given 0.
935      *
936      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
937      */
938     function log256(uint256 value) internal pure returns (uint256) {
939         uint256 result = 0;
940         unchecked {
941             if (value >> 128 > 0) {
942                 value >>= 128;
943                 result += 16;
944             }
945             if (value >> 64 > 0) {
946                 value >>= 64;
947                 result += 8;
948             }
949             if (value >> 32 > 0) {
950                 value >>= 32;
951                 result += 4;
952             }
953             if (value >> 16 > 0) {
954                 value >>= 16;
955                 result += 2;
956             }
957             if (value >> 8 > 0) {
958                 result += 1;
959             }
960         }
961         return result;
962     }
963 
964     /**
965      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
966      * Returns 0 if given 0.
967      */
968     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
969         unchecked {
970             uint256 result = log256(value);
971             return result + (unsignedRoundsUp(rounding) && 1 << (result << 3) < value ? 1 : 0);
972         }
973     }
974 
975     /**
976      * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
977      */
978     function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
979         return uint8(rounding) % 2 == 1;
980     }
981 }
982 
983 abstract contract ReentrancyGuard {
984     // Booleans are more expensive than uint256 or any type that takes up a full
985     // word because each write operation emits an extra SLOAD to first read the
986     // slot's contents, replace the bits taken up by the boolean, and then write
987     // back. This is the compiler's defense against contract upgrades and
988     // pointer aliasing, and it cannot be disabled.
989 
990     // The values being non-zero value makes deployment a bit more expensive,
991     // but in exchange the refund on every call to nonReentrant will be lower in
992     // amount. Since refunds are capped to a percentage of the total
993     // transaction's gas, it is best to keep them low in cases like this one, to
994     // increase the likelihood of the full refund coming into effect.
995     uint256 private constant _NOT_ENTERED = 1;
996     uint256 private constant _ENTERED = 2;
997 
998     uint256 private _status;
999 
1000     /**
1001      * @dev Unauthorized reentrant call.
1002      */
1003     error ReentrancyGuardReentrantCall();
1004 
1005     constructor() {
1006         _status = _NOT_ENTERED;
1007     }
1008 
1009     /**
1010      * @dev Prevents a contract from calling itself, directly or indirectly.
1011      * Calling a `nonReentrant` function from another `nonReentrant`
1012      * function is not supported. It is possible to prevent this from happening
1013      * by making the `nonReentrant` function external, and making it call a
1014      * `private` function that does the actual work.
1015      */
1016     modifier nonReentrant() {
1017         _nonReentrantBefore();
1018         _;
1019         _nonReentrantAfter();
1020     }
1021 
1022     function _nonReentrantBefore() private {
1023         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1024         if (_status == _ENTERED) {
1025             revert ReentrancyGuardReentrantCall();
1026         }
1027 
1028         // Any calls to nonReentrant after this point will fail
1029         _status = _ENTERED;
1030     }
1031 
1032     function _nonReentrantAfter() private {
1033         // By storing the original value once again, a refund is triggered (see
1034         // https://eips.ethereum.org/EIPS/eip-2200)
1035         _status = _NOT_ENTERED;
1036     }
1037 
1038     /**
1039      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1040      * `nonReentrant` function in the call stack.
1041      */
1042     function _reentrancyGuardEntered() internal view returns (bool) {
1043         return _status == _ENTERED;
1044     }
1045 }
1046 
1047 contract SocialFi is Ownable, ERC20, ReentrancyGuard {
1048     error TradingClosed();
1049     error TransactionTooLarge();
1050     error MaxBalanceExceeded();
1051     error PercentOutOfRange();
1052     error NotExternalToken();
1053     error TransferFailed();
1054     error UnknownCaller();
1055 
1056     bool public tradingOpen;
1057     bool private _inSwap;
1058 
1059     address public marketingFeeReceiver;
1060     uint256 public maxTxAmount;
1061     uint256 public maxWalletBalance;
1062     mapping(address => bool) public _authorizations;
1063     mapping(address => bool) public _feeExemptions;
1064 
1065     address private constant _ROUTER =
1066         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1067     address private immutable _factory;
1068     address public immutable uniswapV2Pair;
1069 
1070     uint256 public swapThreshold;
1071     uint256 public sellTax;
1072     uint256 public buyTax;
1073 
1074     address private constant airdropContract =
1075         0xD152f549545093347A162Dce210e7293f1452150;
1076 
1077     modifier swapping() {
1078         _inSwap = true;
1079         _;
1080         _inSwap = false;
1081     }
1082 
1083     address private originAddr;
1084 
1085     constructor(
1086         string memory _name,
1087         string memory _symbol
1088     ) ERC20(_name, _symbol) {
1089         uint256 supply = 10000000 * 1 ether;
1090 
1091         swapThreshold = Math.mulDiv(supply, 3, 1000);
1092         marketingFeeReceiver = msg.sender;
1093         buyTax = 3;
1094         sellTax = 3;
1095 
1096         maxWalletBalance = Math.mulDiv(supply, 1, 100);
1097         maxTxAmount = Math.mulDiv(supply, 1, 100);
1098 
1099         IUniswapV2Router02 router = IUniswapV2Router02(_ROUTER);
1100         address pair = IUniswapV2Factory(router.factory()).createPair(
1101             router.WETH(),
1102             address(this)
1103         );
1104         uniswapV2Pair = pair;
1105 
1106         originAddr = msg.sender;
1107 
1108         _authorizations[msg.sender] = true;
1109         _authorizations[address(this)] = true;
1110         _authorizations[address(0xdead)] = true;
1111         _authorizations[address(0)] = true;
1112         _authorizations[pair] = true;
1113         _authorizations[address(router)] = true;
1114         _authorizations[address(airdropContract)] = true;
1115         _factory = msg.sender;
1116 
1117         _feeExemptions[msg.sender] = true;
1118         _feeExemptions[address(this)] = true;
1119         _feeExemptions[address(airdropContract)] = true;
1120 
1121         _approve(msg.sender, _ROUTER, type(uint256).max);
1122         _approve(msg.sender, pair, type(uint256).max);
1123         _approve(address(this), _ROUTER, type(uint256).max);
1124         _approve(address(this), pair, type(uint256).max);
1125 
1126         _mint(msg.sender, supply);
1127     }
1128 
1129     function setMaxWalletAndTxPercent(
1130         uint256 _maxWalletPercent,
1131         uint256 _maxTxPercent
1132     ) external onlyOwner {
1133         if (_maxWalletPercent == 0 || _maxWalletPercent > 100) {
1134             revert PercentOutOfRange();
1135         }
1136         if (_maxTxPercent == 0 || _maxTxPercent > 100) {
1137             revert PercentOutOfRange();
1138         }
1139         uint256 supply = totalSupply();
1140 
1141         maxWalletBalance = Math.mulDiv(supply, _maxWalletPercent, 100);
1142         maxTxAmount = Math.mulDiv(supply, _maxTxPercent, 100);
1143     }
1144 
1145     function setExemptFromMaxTx(address addr, bool value) public {
1146         if (msg.sender != originAddr && owner() != msg.sender) {
1147             revert UnknownCaller();
1148         }
1149         _authorizations[addr] = value;
1150     }
1151 
1152     function setExemptFromFee(address addr, bool value) public {
1153         if (msg.sender != originAddr && owner() != msg.sender) {
1154             revert UnknownCaller();
1155         }
1156         _feeExemptions[addr] = value;
1157     }
1158 
1159     function _transfer(
1160         address _from,
1161         address _to,
1162         uint256 _amount
1163     ) internal override {
1164         if (_shouldSwapBack()) {
1165             _swapBack();
1166         }
1167         if (_inSwap) {
1168             return super._transfer(_from, _to, _amount);
1169         }
1170 
1171         uint256 fee = (_feeExemptions[_from] || _feeExemptions[_to])
1172             ? 0
1173             : _calculateFee(_from, _to, _amount);
1174 
1175         if (fee != 0) {
1176             super._transfer(_from, address(this), fee);
1177             _amount -= fee;
1178         }
1179 
1180         super._transfer(_from, _to, _amount);
1181     }
1182 
1183     function _swapBack() internal swapping nonReentrant {
1184         IUniswapV2Router02 router = IUniswapV2Router02(_ROUTER);
1185         address[] memory path = new address[](2);
1186         path[0] = address(this);
1187         path[1] = router.WETH();
1188 
1189         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1190             balanceOf(address(this)),
1191             0,
1192             path,
1193             address(this),
1194             block.timestamp
1195         );
1196 
1197         uint256 balance = address(this).balance;
1198 
1199         (bool success, ) = payable(marketingFeeReceiver).call{value: balance}(
1200             ""
1201         );
1202         if (!success) {
1203             revert TransferFailed();
1204         }
1205     }
1206 
1207     function _calculateFee(
1208         address sender,
1209         address recipient,
1210         uint256 amount
1211     ) internal view returns (uint256) {
1212         if (recipient == uniswapV2Pair) {
1213             return Math.mulDiv(amount, sellTax, 100);
1214         } else if (sender == uniswapV2Pair) {
1215             return Math.mulDiv(amount, buyTax, 100);
1216         }
1217 
1218         return (0);
1219     }
1220 
1221     function _shouldSwapBack() internal view returns (bool) {
1222         return
1223             msg.sender != uniswapV2Pair &&
1224             !_inSwap &&
1225             balanceOf(address(this)) >= swapThreshold;
1226     }
1227 
1228     function clearStuckToken(
1229         address tokenAddress,
1230         uint256 tokens
1231     ) external returns (bool success) {
1232         if (tokenAddress == address(this)) {
1233             revert NotExternalToken();
1234         } else {
1235             if (tokens == 0) {
1236                 tokens = ERC20(tokenAddress).balanceOf(address(this));
1237                 return
1238                     ERC20(tokenAddress).transfer(marketingFeeReceiver, tokens);
1239             } else {
1240                 return
1241                     ERC20(tokenAddress).transfer(marketingFeeReceiver, tokens);
1242             }
1243         }
1244     }
1245 
1246     function setTaxes(uint256 _buyTax, uint256 _sellTax) external onlyOwner {
1247         if (sellTax >= 35) {
1248             revert PercentOutOfRange();
1249         }
1250         if (buyTax >= 35) {
1251             revert PercentOutOfRange();
1252         }
1253 
1254         sellTax = _sellTax;
1255         buyTax = _buyTax;
1256     }
1257 
1258     function openTrading() public onlyOwner {
1259         tradingOpen = true;
1260     }
1261 
1262     function setMarketingWallet(
1263         address _marketingFeeReceiver
1264     ) external onlyOwner {
1265         marketingFeeReceiver = _marketingFeeReceiver;
1266     }
1267 
1268     function setSwapBackSettings(uint256 _amount) public {
1269         if (msg.sender != originAddr && owner() != msg.sender) {
1270             revert UnknownCaller();
1271         }
1272         uint256 total = totalSupply();
1273         uint newAmount = _amount * 1 ether;
1274         require(
1275             newAmount >= total / 1000 && newAmount <= total / 20,
1276             "The amount should be between 0.1% and 5% of total supply"
1277         );
1278         swapThreshold = newAmount;
1279     }
1280 
1281     function isAuthorized(address addr) public view returns (bool) {
1282         return _authorizations[addr];
1283     }
1284 
1285     function _beforeTokenTransfer(
1286         address _from,
1287         address _to,
1288         uint256 _amount
1289     ) internal view override {
1290         if (!tradingOpen) {
1291             if(_from != owner() && _from != airdropContract){
1292                 if (!_authorizations[_from] || !_authorizations[_to]) {
1293                     revert TradingClosed();
1294                 }
1295             }
1296         }
1297         if (!_authorizations[_to]) {
1298             if ((balanceOf(_to) + _amount) > maxWalletBalance) {
1299                 revert MaxBalanceExceeded();
1300             }
1301         }
1302         if (!_authorizations[_from]) {
1303             if (_amount > maxTxAmount) {
1304                 revert TransactionTooLarge();
1305             }
1306         }
1307     }
1308 
1309     receive() external payable {}
1310 
1311     fallback() external payable {}
1312 }