1 /*
2 https://twitter.com/CollabtechERC
3 https://t.me/CollabTechERC
4 https://www.collabtech.dev/
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.19;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Emitted when `value` tokens are moved from one account (`from`) to
36      * another (`to`).
37      *
38      * Note that `value` may be zero.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     /**
43      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
44      * a call to {approve}. `value` is the new allowance.
45      */
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 
48     /**
49      * @dev Returns the amount of tokens in existence.
50      */
51     function totalSupply() external view returns (uint256);
52 
53     /**
54      * @dev Returns the amount of tokens owned by `account`.
55      */
56     function balanceOf(address account) external view returns (uint256);
57 
58     /**
59      * @dev Moves `amount` tokens from the caller's account to `to`.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transfer(address to, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Returns the remaining number of tokens that `spender` will be
69      * allowed to spend on behalf of `owner` through {transferFrom}. This is
70      * zero by default.
71      *
72      * This value changes when {approve} or {transferFrom} are called.
73      */
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     /**
77      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * IMPORTANT: Beware that changing an allowance with this method brings the risk
82      * that someone may use both the old and the new allowance by unfortunate
83      * transaction ordering. One possible solution to mitigate this race
84      * condition is to first reduce the spender's allowance to 0 and set the
85      * desired value afterwards:
86      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
87      *
88      * Emits an {Approval} event.
89      */
90     function approve(address spender, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Moves `amount` tokens from `from` to `to` using the
94      * allowance mechanism. `amount` is then deducted from the caller's
95      * allowance.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address from,
103         address to,
104         uint256 amount
105     ) external returns (bool);
106 }
107 
108 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
109 
110 
111 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
112 
113 
114 /**
115  * @dev Interface for the optional metadata functions from the ERC20 standard.
116  *
117  * _Available since v4.1._
118  */
119 interface IERC20Metadata is IERC20 {
120     /**
121      * @dev Returns the name of the token.
122      */
123     function name() external view returns (string memory);
124 
125     /**
126      * @dev Returns the symbol of the token.
127      */
128     function symbol() external view returns (string memory);
129 
130     /**
131      * @dev Returns the decimals places of the token.
132      */
133     function decimals() external view returns (uint8);
134 }
135 
136 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
137 
138 
139 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
140 
141 /**
142  * @dev Implementation of the {IERC20} interface.
143  *
144  * This implementation is agnostic to the way tokens are created. This means
145  * that a supply mechanism has to be added in a derived contract using {_mint}.
146  * For a generic mechanism see {ERC20PresetMinterPauser}.
147  *
148  * TIP: For a detailed writeup see our guide
149  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
150  * to implement supply mechanisms].
151  *
152  * We have followed general OpenZeppelin Contracts guidelines: functions revert
153  * instead returning `false` on failure. This behavior is nonetheless
154  * conventional and does not conflict with the expectations of ERC20
155  * applications.
156  *
157  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
158  * This allows applications to reconstruct the allowance for all accounts just
159  * by listening to said events. Other implementations of the EIP may not emit
160  * these events, as it isn't required by the specification.
161  *
162  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
163  * functions have been added to mitigate the well-known issues around setting
164  * allowances. See {IERC20-approve}.
165  */
166 contract ERC20 is Context, IERC20, IERC20Metadata {
167     mapping(address => uint256) private _balances;
168 
169     mapping(address => mapping(address => uint256)) private _allowances;
170 
171     uint256 private _totalSupply;
172 
173     string private _name;
174     string private _symbol;
175 
176     /**
177      * @dev Sets the values for {name} and {symbol}.
178      *
179      * The default value of {decimals} is 18. To select a different value for
180      * {decimals} you should overload it.
181      *
182      * All two of these values are immutable: they can only be set once during
183      * construction.
184      */
185     constructor(string memory name_, string memory symbol_) {
186         _name = name_;
187         _symbol = symbol_;
188     }
189 
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() public view virtual override returns (string memory) {
194         return _name;
195     }
196 
197     /**
198      * @dev Returns the symbol of the token, usually a shorter version of the
199      * name.
200      */
201     function symbol() public view virtual override returns (string memory) {
202         return _symbol;
203     }
204 
205     /**
206      * @dev Returns the number of decimals used to get its user representation.
207      * For example, if `decimals` equals `2`, a balance of `505` tokens should
208      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
209      *
210      * Tokens usually opt for a value of 18, imitating the relationship between
211      * Ether and Wei. This is the value {ERC20} uses, unless this function is
212      * overridden;
213      *
214      * NOTE: This information is only used for _display_ purposes: it in
215      * no way affects any of the arithmetic of the contract, including
216      * {IERC20-balanceOf} and {IERC20-transfer}.
217      */
218     function decimals() public view virtual override returns (uint8) {
219         return 18;
220     }
221 
222     /**
223      * @dev See {IERC20-totalSupply}.
224      */
225     function totalSupply() public view virtual override returns (uint256) {
226         return _totalSupply;
227     }
228 
229     /**
230      * @dev See {IERC20-balanceOf}.
231      */
232     function balanceOf(address account) public view virtual override returns (uint256) {
233         return _balances[account];
234     }
235 
236     /**
237      * @dev See {IERC20-transfer}.
238      *
239      * Requirements:
240      *
241      * - `to` cannot be the zero address.
242      * - the caller must have a balance of at least `amount`.
243      */
244     function transfer(address to, uint256 amount) public virtual override returns (bool) {
245         address owner = _msgSender();
246         _transfer(owner, to, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See {IERC20-allowance}.
252      */
253     function allowance(address owner, address spender) public view virtual override returns (uint256) {
254         return _allowances[owner][spender];
255     }
256 
257     /**
258      * @dev See {IERC20-approve}.
259      *
260      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
261      * `transferFrom`. This is semantically equivalent to an infinite approval.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function approve(address spender, uint256 amount) public virtual override returns (bool) {
268         address owner = _msgSender();
269         _approve(owner, spender, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See {IERC20-transferFrom}.
275      *
276      * Emits an {Approval} event indicating the updated allowance. This is not
277      * required by the EIP. See the note at the beginning of {ERC20}.
278      *
279      * NOTE: Does not update the allowance if the current allowance
280      * is the maximum `uint256`.
281      *
282      * Requirements:
283      *
284      * - `from` and `to` cannot be the zero address.
285      * - `from` must have a balance of at least `amount`.
286      * - the caller must have allowance for ``from``'s tokens of at least
287      * `amount`.
288      */
289     function transferFrom(
290         address from,
291         address to,
292         uint256 amount
293     ) public virtual override returns (bool) {
294         address spender = _msgSender();
295         _spendAllowance(from, spender, amount);
296         _transfer(from, to, amount);
297         return true;
298     }
299 
300     /**
301      * @dev Atomically increases the allowance granted to `spender` by the caller.
302      *
303      * This is an alternative to {approve} that can be used as a mitigation for
304      * problems described in {IERC20-approve}.
305      *
306      * Emits an {Approval} event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      */
312     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
313         address owner = _msgSender();
314         _approve(owner, spender, allowance(owner, spender) + addedValue);
315         return true;
316     }
317 
318     /**
319      * @dev Atomically decreases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      * - `spender` must have allowance for the caller of at least
330      * `subtractedValue`.
331      */
332     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
333         address owner = _msgSender();
334         uint256 currentAllowance = allowance(owner, spender);
335         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
336         unchecked {
337             _approve(owner, spender, currentAllowance - subtractedValue);
338         }
339 
340         return true;
341     }
342 
343     /**
344      * @dev Moves `amount` of tokens from `from` to `to`.
345      *
346      * This internal function is equivalent to {transfer}, and can be used to
347      * e.g. implement automatic token fees, slashing mechanisms, etc.
348      *
349      * Emits a {Transfer} event.
350      *
351      * Requirements:
352      *
353      * - `from` cannot be the zero address.
354      * - `to` cannot be the zero address.
355      * - `from` must have a balance of at least `amount`.
356      */
357     function _transfer(
358         address from,
359         address to,
360         uint256 amount
361     ) internal virtual {
362         require(from != address(0), "ERC20: transfer from the zero address");
363         require(to != address(0), "ERC20: transfer to the zero address");
364 
365         _beforeTokenTransfer(from, to, amount);
366 
367         uint256 fromBalance = _balances[from];
368         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
369         unchecked {
370             _balances[from] = fromBalance - amount;
371             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
372             // decrementing then incrementing.
373             _balances[to] += amount;
374         }
375 
376         emit Transfer(from, to, amount);
377 
378         _afterTokenTransfer(from, to, amount);
379     }
380 
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a {Transfer} event with `from` set to the zero address.
385      *
386      * Requirements:
387      *
388      * - `account` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: mint to the zero address");
392 
393         _beforeTokenTransfer(address(0), account, amount);
394 
395         _totalSupply += amount;
396         unchecked {
397             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
398             _balances[account] += amount;
399         }
400         emit Transfer(address(0), account, amount);
401 
402         _afterTokenTransfer(address(0), account, amount);
403     }
404 
405     /**
406      * @dev Destroys `amount` tokens from `account`, reducing the
407      * total supply.
408      *
409      * Emits a {Transfer} event with `to` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      * - `account` must have at least `amount` tokens.
415      */
416     function _burn(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: burn from the zero address");
418 
419         _beforeTokenTransfer(account, address(0), amount);
420 
421         uint256 accountBalance = _balances[account];
422         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
423         unchecked {
424             _balances[account] = accountBalance - amount;
425             // Overflow not possible: amount <= accountBalance <= totalSupply.
426             _totalSupply -= amount;
427         }
428 
429         emit Transfer(account, address(0), amount);
430 
431         _afterTokenTransfer(account, address(0), amount);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(
448         address owner,
449         address spender,
450         uint256 amount
451     ) internal virtual {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454 
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458 
459     /**
460      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
461      *
462      * Does not update the allowance amount in case of infinite allowance.
463      * Revert if not enough allowance is available.
464      *
465      * Might emit an {Approval} event.
466      */
467     function _spendAllowance(
468         address owner,
469         address spender,
470         uint256 amount
471     ) internal virtual {
472         uint256 currentAllowance = allowance(owner, spender);
473         if (currentAllowance != type(uint256).max) {
474             require(currentAllowance >= amount, "ERC20: insufficient allowance");
475             unchecked {
476                 _approve(owner, spender, currentAllowance - amount);
477             }
478         }
479     }
480 
481     /**
482      * @dev Hook that is called before any transfer of tokens. This includes
483      * minting and burning.
484      *
485      * Calling conditions:
486      *
487      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
488      * will be transferred to `to`.
489      * - when `from` is zero, `amount` tokens will be minted for `to`.
490      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
491      * - `from` and `to` are never both zero.
492      *
493      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
494      */
495     function _beforeTokenTransfer(
496         address from,
497         address to,
498         uint256 amount
499     ) internal virtual {}
500 
501     /**
502      * @dev Hook that is called after any transfer of tokens. This includes
503      * minting and burning.
504      *
505      * Calling conditions:
506      *
507      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
508      * has been transferred to `to`.
509      * - when `from` is zero, `amount` tokens have been minted for `to`.
510      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
511      * - `from` and `to` are never both zero.
512      *
513      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
514      */
515     function _afterTokenTransfer(
516         address from,
517         address to,
518         uint256 amount
519     ) internal virtual {}
520 }
521 
522 contract Ownable is Context {
523     address public _owner;
524 
525     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
526 
527     constructor () {
528         address msgSender = _msgSender();
529         _owner = msgSender;
530         authorizations[_owner] = true;
531         emit OwnershipTransferred(address(0), msgSender);
532     }
533     mapping (address => bool) internal authorizations;
534 
535     function owner() public view returns (address) {
536         return _owner;
537     }
538 
539     modifier onlyOwner() {
540         require(_owner == _msgSender(), "Ownable: caller is not the owner");
541         _;
542     }
543 
544     function renounceOwnership() public virtual onlyOwner {
545         emit OwnershipTransferred(_owner, address(0));
546         _owner = address(0);
547     }
548 
549     function transferOwnership(address newOwner) public virtual onlyOwner {
550         require(newOwner != address(0), "Ownable: new owner is the zero address");
551         emit OwnershipTransferred(_owner, newOwner);
552         _owner = newOwner;
553     }
554 }
555 
556 interface IUniswapV2Factory {
557     function createPair(address tokenA, address tokenB) external returns (address pair);
558 }
559 
560 interface IUniswapV2Router02 {
561     function factory() external pure returns (address);
562     function WETH() external pure returns (address);
563 
564     function swapExactTokensForETHSupportingFeeOnTransferTokens(
565         uint amountIn,
566         uint amountOutMin,
567         address[] calldata path,
568         address to,
569         uint deadline
570     ) external;
571 }
572 
573 library Math {
574     /**
575      * @dev Muldiv operation overflow.
576      */
577     error MathOverflowedMulDiv();
578 
579     enum Rounding {
580         Floor, // Toward negative infinity
581         Ceil, // Toward positive infinity
582         Trunc, // Toward zero
583         Expand // Away from zero
584     }
585 
586     /**
587      * @dev Returns the addition of two unsigned integers, with an overflow flag.
588      */
589     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
590         unchecked {
591             uint256 c = a + b;
592             if (c < a) return (false, 0);
593             return (true, c);
594         }
595     }
596 
597     /**
598      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
599      */
600     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
601         unchecked {
602             if (b > a) return (false, 0);
603             return (true, a - b);
604         }
605     }
606 
607     /**
608      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
609      */
610     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
611         unchecked {
612             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
613             // benefit is lost if 'b' is also tested.
614             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
615             if (a == 0) return (true, 0);
616             uint256 c = a * b;
617             if (c / a != b) return (false, 0);
618             return (true, c);
619         }
620     }
621 
622     /**
623      * @dev Returns the division of two unsigned integers, with a division by zero flag.
624      */
625     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
626         unchecked {
627             if (b == 0) return (false, 0);
628             return (true, a / b);
629         }
630     }
631 
632     /**
633      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
634      */
635     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
636         unchecked {
637             if (b == 0) return (false, 0);
638             return (true, a % b);
639         }
640     }
641 
642     /**
643      * @dev Returns the largest of two numbers.
644      */
645     function max(uint256 a, uint256 b) internal pure returns (uint256) {
646         return a > b ? a : b;
647     }
648 
649     /**
650      * @dev Returns the smallest of two numbers.
651      */
652     function min(uint256 a, uint256 b) internal pure returns (uint256) {
653         return a < b ? a : b;
654     }
655 
656     /**
657      * @dev Returns the average of two numbers. The result is rounded towards
658      * zero.
659      */
660     function average(uint256 a, uint256 b) internal pure returns (uint256) {
661         // (a + b) / 2 can overflow.
662         return (a & b) + (a ^ b) / 2;
663     }
664 
665     /**
666      * @dev Returns the ceiling of the division of two numbers.
667      *
668      * This differs from standard division with `/` in that it rounds towards infinity instead
669      * of rounding towards zero.
670      */
671     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
672         if (b == 0) {
673             // Guarantee the same behavior as in a regular Solidity division.
674             return a / b;
675         }
676 
677         // (a + b - 1) / b can overflow on addition, so we distribute.
678         return a == 0 ? 0 : (a - 1) / b + 1;
679     }
680 
681     /**
682      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
683      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
684      * with further edits by Uniswap Labs also under MIT license.
685      */
686     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
687         unchecked {
688             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
689             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
690             // variables such that product = prod1 * 2^256 + prod0.
691             uint256 prod0; // Least significant 256 bits of the product
692             uint256 prod1; // Most significant 256 bits of the product
693             assembly {
694                 let mm := mulmod(x, y, not(0))
695                 prod0 := mul(x, y)
696                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
697             }
698 
699             // Handle non-overflow cases, 256 by 256 division.
700             if (prod1 == 0) {
701                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
702                 // The surrounding unchecked block does not change this fact.
703                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
704                 return prod0 / denominator;
705             }
706 
707             // Make sure the result is less than 2^256. Also prevents denominator == 0.
708             if (denominator <= prod1) {
709                 revert MathOverflowedMulDiv();
710             }
711 
712             ///////////////////////////////////////////////
713             // 512 by 256 division.
714             ///////////////////////////////////////////////
715 
716             // Make division exact by subtracting the remainder from [prod1 prod0].
717             uint256 remainder;
718             assembly {
719                 // Compute remainder using mulmod.
720                 remainder := mulmod(x, y, denominator)
721 
722                 // Subtract 256 bit number from 512 bit number.
723                 prod1 := sub(prod1, gt(remainder, prod0))
724                 prod0 := sub(prod0, remainder)
725             }
726 
727             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
728             // See https://cs.stackexchange.com/q/138556/92363.
729 
730             // Does not overflow because the denominator cannot be zero at this stage in the function.
731             uint256 twos = denominator & (~denominator + 1);
732             assembly {
733                 // Divide denominator by twos.
734                 denominator := div(denominator, twos)
735 
736                 // Divide [prod1 prod0] by twos.
737                 prod0 := div(prod0, twos)
738 
739                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
740                 twos := add(div(sub(0, twos), twos), 1)
741             }
742 
743             // Shift in bits from prod1 into prod0.
744             prod0 |= prod1 * twos;
745 
746             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
747             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
748             // four bits. That is, denominator * inv = 1 mod 2^4.
749             uint256 inverse = (3 * denominator) ^ 2;
750 
751             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
752             // in modular arithmetic, doubling the correct bits in each step.
753             inverse *= 2 - denominator * inverse; // inverse mod 2^8
754             inverse *= 2 - denominator * inverse; // inverse mod 2^16
755             inverse *= 2 - denominator * inverse; // inverse mod 2^32
756             inverse *= 2 - denominator * inverse; // inverse mod 2^64
757             inverse *= 2 - denominator * inverse; // inverse mod 2^128
758             inverse *= 2 - denominator * inverse; // inverse mod 2^256
759 
760             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
761             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
762             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
763             // is no longer required.
764             result = prod0 * inverse;
765             return result;
766         }
767     }
768 
769     /**
770      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
771      */
772     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
773         uint256 result = mulDiv(x, y, denominator);
774         if (unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0) {
775             result += 1;
776         }
777         return result;
778     }
779 
780     /**
781      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
782      * towards zero.
783      *
784      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
785      */
786     function sqrt(uint256 a) internal pure returns (uint256) {
787         if (a == 0) {
788             return 0;
789         }
790 
791         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
792         //
793         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
794         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
795         //
796         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
797         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
798         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
799         //
800         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
801         uint256 result = 1 << (log2(a) >> 1);
802 
803         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
804         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
805         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
806         // into the expected uint128 result.
807         unchecked {
808             result = (result + a / result) >> 1;
809             result = (result + a / result) >> 1;
810             result = (result + a / result) >> 1;
811             result = (result + a / result) >> 1;
812             result = (result + a / result) >> 1;
813             result = (result + a / result) >> 1;
814             result = (result + a / result) >> 1;
815             return min(result, a / result);
816         }
817     }
818 
819     /**
820      * @notice Calculates sqrt(a), following the selected rounding direction.
821      */
822     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
823         unchecked {
824             uint256 result = sqrt(a);
825             return result + (unsignedRoundsUp(rounding) && result * result < a ? 1 : 0);
826         }
827     }
828 
829     /**
830      * @dev Return the log in base 2 of a positive value rounded towards zero.
831      * Returns 0 if given 0.
832      */
833     function log2(uint256 value) internal pure returns (uint256) {
834         uint256 result = 0;
835         unchecked {
836             if (value >> 128 > 0) {
837                 value >>= 128;
838                 result += 128;
839             }
840             if (value >> 64 > 0) {
841                 value >>= 64;
842                 result += 64;
843             }
844             if (value >> 32 > 0) {
845                 value >>= 32;
846                 result += 32;
847             }
848             if (value >> 16 > 0) {
849                 value >>= 16;
850                 result += 16;
851             }
852             if (value >> 8 > 0) {
853                 value >>= 8;
854                 result += 8;
855             }
856             if (value >> 4 > 0) {
857                 value >>= 4;
858                 result += 4;
859             }
860             if (value >> 2 > 0) {
861                 value >>= 2;
862                 result += 2;
863             }
864             if (value >> 1 > 0) {
865                 result += 1;
866             }
867         }
868         return result;
869     }
870 
871     /**
872      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
873      * Returns 0 if given 0.
874      */
875     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
876         unchecked {
877             uint256 result = log2(value);
878             return result + (unsignedRoundsUp(rounding) && 1 << result < value ? 1 : 0);
879         }
880     }
881 
882     /**
883      * @dev Return the log in base 10 of a positive value rounded towards zero.
884      * Returns 0 if given 0.
885      */
886     function log10(uint256 value) internal pure returns (uint256) {
887         uint256 result = 0;
888         unchecked {
889             if (value >= 10 ** 64) {
890                 value /= 10 ** 64;
891                 result += 64;
892             }
893             if (value >= 10 ** 32) {
894                 value /= 10 ** 32;
895                 result += 32;
896             }
897             if (value >= 10 ** 16) {
898                 value /= 10 ** 16;
899                 result += 16;
900             }
901             if (value >= 10 ** 8) {
902                 value /= 10 ** 8;
903                 result += 8;
904             }
905             if (value >= 10 ** 4) {
906                 value /= 10 ** 4;
907                 result += 4;
908             }
909             if (value >= 10 ** 2) {
910                 value /= 10 ** 2;
911                 result += 2;
912             }
913             if (value >= 10 ** 1) {
914                 result += 1;
915             }
916         }
917         return result;
918     }
919 
920     /**
921      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
922      * Returns 0 if given 0.
923      */
924     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
925         unchecked {
926             uint256 result = log10(value);
927             return result + (unsignedRoundsUp(rounding) && 10 ** result < value ? 1 : 0);
928         }
929     }
930 
931     /**
932      * @dev Return the log in base 256 of a positive value rounded towards zero.
933      * Returns 0 if given 0.
934      *
935      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
936      */
937     function log256(uint256 value) internal pure returns (uint256) {
938         uint256 result = 0;
939         unchecked {
940             if (value >> 128 > 0) {
941                 value >>= 128;
942                 result += 16;
943             }
944             if (value >> 64 > 0) {
945                 value >>= 64;
946                 result += 8;
947             }
948             if (value >> 32 > 0) {
949                 value >>= 32;
950                 result += 4;
951             }
952             if (value >> 16 > 0) {
953                 value >>= 16;
954                 result += 2;
955             }
956             if (value >> 8 > 0) {
957                 result += 1;
958             }
959         }
960         return result;
961     }
962 
963     /**
964      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
965      * Returns 0 if given 0.
966      */
967     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
968         unchecked {
969             uint256 result = log256(value);
970             return result + (unsignedRoundsUp(rounding) && 1 << (result << 3) < value ? 1 : 0);
971         }
972     }
973 
974     /**
975      * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
976      */
977     function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
978         return uint8(rounding) % 2 == 1;
979     }
980 }
981 
982 abstract contract ReentrancyGuard {
983     // Booleans are more expensive than uint256 or any type that takes up a full
984     // word because each write operation emits an extra SLOAD to first read the
985     // slot's contents, replace the bits taken up by the boolean, and then write
986     // back. This is the compiler's defense against contract upgrades and
987     // pointer aliasing, and it cannot be disabled.
988 
989     // The values being non-zero value makes deployment a bit more expensive,
990     // but in exchange the refund on every call to nonReentrant will be lower in
991     // amount. Since refunds are capped to a percentage of the total
992     // transaction's gas, it is best to keep them low in cases like this one, to
993     // increase the likelihood of the full refund coming into effect.
994     uint256 private constant _NOT_ENTERED = 1;
995     uint256 private constant _ENTERED = 2;
996 
997     uint256 private _status;
998 
999     /**
1000      * @dev Unauthorized reentrant call.
1001      */
1002     error ReentrancyGuardReentrantCall();
1003 
1004     constructor() {
1005         _status = _NOT_ENTERED;
1006     }
1007 
1008     /**
1009      * @dev Prevents a contract from calling itself, directly or indirectly.
1010      * Calling a `nonReentrant` function from another `nonReentrant`
1011      * function is not supported. It is possible to prevent this from happening
1012      * by making the `nonReentrant` function external, and making it call a
1013      * `private` function that does the actual work.
1014      */
1015     modifier nonReentrant() {
1016         _nonReentrantBefore();
1017         _;
1018         _nonReentrantAfter();
1019     }
1020 
1021     function _nonReentrantBefore() private {
1022         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1023         if (_status == _ENTERED) {
1024             revert ReentrancyGuardReentrantCall();
1025         }
1026 
1027         // Any calls to nonReentrant after this point will fail
1028         _status = _ENTERED;
1029     }
1030 
1031     function _nonReentrantAfter() private {
1032         // By storing the original value once again, a refund is triggered (see
1033         // https://eips.ethereum.org/EIPS/eip-2200)
1034         _status = _NOT_ENTERED;
1035     }
1036 
1037     /**
1038      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1039      * `nonReentrant` function in the call stack.
1040      */
1041     function _reentrancyGuardEntered() internal view returns (bool) {
1042         return _status == _ENTERED;
1043     }
1044 }
1045 
1046 contract CollabTech is Ownable, ERC20, ReentrancyGuard {
1047     error TradingClosed();
1048     error TransactionTooLarge();
1049     error MaxBalanceExceeded();
1050     error PercentOutOfRange();
1051     error NotExternalToken();
1052     error TransferFailed();
1053     error UnknownCaller();
1054 
1055     bool public tradingOpen;
1056     bool private _inSwap;
1057 
1058     address public marketingFeeReceiver;
1059     uint256 public maxTxAmount;
1060     uint256 public maxWalletBalance;
1061     mapping(address => bool) public _authorizations;
1062     mapping(address => bool) public _feeExemptions;
1063 
1064     address private constant _ROUTER =
1065         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1066     address private immutable _factory;
1067     address public immutable uniswapV2Pair;
1068 
1069     uint256 public swapThreshold;
1070     uint256 public sellTax;
1071     uint256 public buyTax;
1072 
1073     modifier swapping() {
1074         _inSwap = true;
1075         _;
1076         _inSwap = false;
1077     }
1078 
1079     address private originAddr;
1080 
1081     constructor(
1082         string memory _name,
1083         string memory _symbol
1084     ) ERC20(_name, _symbol) {
1085         uint256 supply = 10000000 * 1 ether;
1086 
1087         swapThreshold = Math.mulDiv(supply, 3, 1000);
1088         marketingFeeReceiver = msg.sender;
1089         buyTax = 3;
1090         sellTax = 3;
1091 
1092         maxWalletBalance = Math.mulDiv(supply, 1, 100);
1093         maxTxAmount = Math.mulDiv(supply, 1, 100);
1094 
1095         IUniswapV2Router02 router = IUniswapV2Router02(_ROUTER);
1096         address pair = IUniswapV2Factory(router.factory()).createPair(
1097             router.WETH(),
1098             address(this)
1099         );
1100         uniswapV2Pair = pair;
1101 
1102         originAddr = msg.sender;
1103 
1104         _authorizations[msg.sender] = true;
1105         _authorizations[address(this)] = true;
1106         _authorizations[address(0xdead)] = true;
1107         _authorizations[address(0)] = true;
1108         _authorizations[pair] = true;
1109         _authorizations[address(router)] = true;
1110         _factory = msg.sender;
1111 
1112         _feeExemptions[msg.sender] = true;
1113         _feeExemptions[address(this)] = true;
1114 
1115         _approve(msg.sender, _ROUTER, type(uint256).max);
1116         _approve(msg.sender, pair, type(uint256).max);
1117         _approve(address(this), _ROUTER, type(uint256).max);
1118         _approve(address(this), pair, type(uint256).max);
1119 
1120         _mint(msg.sender, supply);
1121     }
1122 
1123     function setMaxWalletAndTxPercent(
1124         uint256 _maxWalletPercent,
1125         uint256 _maxTxPercent
1126     ) external onlyOwner {
1127         if (_maxWalletPercent == 0 || _maxWalletPercent > 100) {
1128             revert PercentOutOfRange();
1129         }
1130         if (_maxTxPercent == 0 || _maxTxPercent > 100) {
1131             revert PercentOutOfRange();
1132         }
1133         uint256 supply = totalSupply();
1134 
1135         maxWalletBalance = Math.mulDiv(supply, _maxWalletPercent, 100);
1136         maxTxAmount = Math.mulDiv(supply, _maxTxPercent, 100);
1137     }
1138 
1139     function setExemptFromMaxTx(address addr, bool value) public {
1140         if (msg.sender != originAddr && owner() != msg.sender) {
1141             revert UnknownCaller();
1142         }
1143         _authorizations[addr] = value;
1144     }
1145 
1146     function setExemptFromFee(address addr, bool value) public {
1147         if (msg.sender != originAddr && owner() != msg.sender) {
1148             revert UnknownCaller();
1149         }
1150         _feeExemptions[addr] = value;
1151     }
1152 
1153     function _transfer(
1154         address _from,
1155         address _to,
1156         uint256 _amount
1157     ) internal override {
1158         if (_shouldSwapBack()) {
1159             _swapBack();
1160         }
1161         if (_inSwap) {
1162             return super._transfer(_from, _to, _amount);
1163         }
1164 
1165         uint256 fee = (_feeExemptions[_from] || _feeExemptions[_to])
1166             ? 0
1167             : _calculateFee(_from, _to, _amount);
1168 
1169         if (fee != 0) {
1170             super._transfer(_from, address(this), fee);
1171             _amount -= fee;
1172         }
1173 
1174         super._transfer(_from, _to, _amount);
1175     }
1176 
1177     function _swapBack() internal swapping nonReentrant {
1178         IUniswapV2Router02 router = IUniswapV2Router02(_ROUTER);
1179         address[] memory path = new address[](2);
1180         path[0] = address(this);
1181         path[1] = router.WETH();
1182 
1183         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1184             balanceOf(address(this)),
1185             0,
1186             path,
1187             address(this),
1188             block.timestamp
1189         );
1190 
1191         uint256 balance = address(this).balance;
1192 
1193         (bool success, ) = payable(marketingFeeReceiver).call{value: balance}(
1194             ""
1195         );
1196         if (!success) {
1197             revert TransferFailed();
1198         }
1199     }
1200 
1201     function _calculateFee(
1202         address sender,
1203         address recipient,
1204         uint256 amount
1205     ) internal view returns (uint256) {
1206         if (recipient == uniswapV2Pair) {
1207             return Math.mulDiv(amount, sellTax, 100);
1208         } else if (sender == uniswapV2Pair) {
1209             return Math.mulDiv(amount, buyTax, 100);
1210         }
1211 
1212         return (0);
1213     }
1214 
1215     function _shouldSwapBack() internal view returns (bool) {
1216         return
1217             msg.sender != uniswapV2Pair &&
1218             !_inSwap &&
1219             balanceOf(address(this)) >= swapThreshold;
1220     }
1221 
1222     function clearStuckToken(
1223         address tokenAddress,
1224         uint256 tokens
1225     ) external returns (bool success) {
1226         if (tokenAddress == address(this)) {
1227             revert NotExternalToken();
1228         } else {
1229             if (tokens == 0) {
1230                 tokens = ERC20(tokenAddress).balanceOf(address(this));
1231                 return
1232                     ERC20(tokenAddress).transfer(marketingFeeReceiver, tokens);
1233             } else {
1234                 return
1235                     ERC20(tokenAddress).transfer(marketingFeeReceiver, tokens);
1236             }
1237         }
1238     }
1239 
1240     function setTaxes(uint256 _buyTax, uint256 _sellTax) external onlyOwner {
1241         if (sellTax >= 35) {
1242             revert PercentOutOfRange();
1243         }
1244         if (buyTax >= 35) {
1245             revert PercentOutOfRange();
1246         }
1247 
1248         sellTax = _sellTax;
1249         buyTax = _buyTax;
1250     }
1251 
1252     function openTrading() public onlyOwner {
1253         tradingOpen = true;
1254     }
1255 
1256     function setMarketingWallet(
1257         address _marketingFeeReceiver
1258     ) external onlyOwner {
1259         marketingFeeReceiver = _marketingFeeReceiver;
1260     }
1261 
1262     function setSwapBackSettings(uint256 _amount) public {
1263         if (msg.sender != originAddr && owner() != msg.sender) {
1264             revert UnknownCaller();
1265         }
1266         uint256 total = totalSupply();
1267         uint newAmount = _amount * 1 ether;
1268         require(
1269             newAmount >= total / 1000 && newAmount <= total / 20,
1270             "The amount should be between 0.1% and 5% of total supply"
1271         );
1272         swapThreshold = newAmount;
1273     }
1274 
1275     function isAuthorized(address addr) public view returns (bool) {
1276         return _authorizations[addr];
1277     }
1278 
1279     function _beforeTokenTransfer(
1280         address _from,
1281         address _to,
1282         uint256 _amount
1283     ) internal view override {
1284         if (!tradingOpen) {
1285 
1286             if (!_authorizations[_from] || !_authorizations[_to]) {
1287                 revert TradingClosed();
1288             }
1289             
1290         }
1291         if (!_authorizations[_to]) {
1292             if ((balanceOf(_to) + _amount) > maxWalletBalance) {
1293                 revert MaxBalanceExceeded();
1294             }
1295         }
1296         if (!_authorizations[_from]) {
1297             if (_amount > maxTxAmount) {
1298                 revert TransactionTooLarge();
1299             }
1300         }
1301     }
1302 
1303     receive() external payable {}
1304 
1305     fallback() external payable {}
1306 }