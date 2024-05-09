1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-28
3 */
4 
5 /*
6 https://twitter.com/duplicate
7 https://t.me/DuplicateToken
8 https://duplicate-token.gitbook.io/duplicate
9 https://www.duplicatetoken.io/
10 */
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity ^0.8.19;
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Emitted when `value` tokens are moved from one account (`from`) to
41      * another (`to`).
42      *
43      * Note that `value` may be zero.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     /**
48      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
49      * a call to {approve}. `value` is the new allowance.
50      */
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 
53     /**
54      * @dev Returns the amount of tokens in existence.
55      */
56     function totalSupply() external view returns (uint256);
57 
58     /**
59      * @dev Returns the amount of tokens owned by `account`.
60      */
61     function balanceOf(address account) external view returns (uint256);
62 
63     /**
64      * @dev Moves `amount` tokens from the caller's account to `to`.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transfer(address to, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Returns the remaining number of tokens that `spender` will be
74      * allowed to spend on behalf of `owner` through {transferFrom}. This is
75      * zero by default.
76      *
77      * This value changes when {approve} or {transferFrom} are called.
78      */
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     /**
82      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * IMPORTANT: Beware that changing an allowance with this method brings the risk
87      * that someone may use both the old and the new allowance by unfortunate
88      * transaction ordering. One possible solution to mitigate this race
89      * condition is to first reduce the spender's allowance to 0 and set the
90      * desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Moves `amount` tokens from `from` to `to` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 amount
110     ) external returns (bool);
111 }
112 
113 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
117 
118 
119 /**
120  * @dev Interface for the optional metadata functions from the ERC20 standard.
121  *
122  * _Available since v4.1._
123  */
124 interface IERC20Metadata is IERC20 {
125     /**
126      * @dev Returns the name of the token.
127      */
128     function name() external view returns (string memory);
129 
130     /**
131      * @dev Returns the symbol of the token.
132      */
133     function symbol() external view returns (string memory);
134 
135     /**
136      * @dev Returns the decimals places of the token.
137      */
138     function decimals() external view returns (uint8);
139 }
140 
141 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
142 
143 
144 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
145 
146 /**
147  * @dev Implementation of the {IERC20} interface.
148  *
149  * This implementation is agnostic to the way tokens are created. This means
150  * that a supply mechanism has to be added in a derived contract using {_mint}.
151  * For a generic mechanism see {ERC20PresetMinterPauser}.
152  *
153  * TIP: For a detailed writeup see our guide
154  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
155  * to implement supply mechanisms].
156  *
157  * We have followed general OpenZeppelin Contracts guidelines: functions revert
158  * instead returning `false` on failure. This behavior is nonetheless
159  * conventional and does not conflict with the expectations of ERC20
160  * applications.
161  *
162  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
163  * This allows applications to reconstruct the allowance for all accounts just
164  * by listening to said events. Other implementations of the EIP may not emit
165  * these events, as it isn't required by the specification.
166  *
167  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
168  * functions have been added to mitigate the well-known issues around setting
169  * allowances. See {IERC20-approve}.
170  */
171 contract ERC20 is Context, IERC20, IERC20Metadata {
172     mapping(address => uint256) private _balances;
173 
174     mapping(address => mapping(address => uint256)) private _allowances;
175 
176     uint256 private _totalSupply;
177 
178     string private _name;
179     string private _symbol;
180 
181     /**
182      * @dev Sets the values for {name} and {symbol}.
183      *
184      * The default value of {decimals} is 18. To select a different value for
185      * {decimals} you should overload it.
186      *
187      * All two of these values are immutable: they can only be set once during
188      * construction.
189      */
190     constructor(string memory name_, string memory symbol_) {
191         _name = name_;
192         _symbol = symbol_;
193     }
194 
195     /**
196      * @dev Returns the name of the token.
197      */
198     function name() public view virtual override returns (string memory) {
199         return _name;
200     }
201 
202     /**
203      * @dev Returns the symbol of the token, usually a shorter version of the
204      * name.
205      */
206     function symbol() public view virtual override returns (string memory) {
207         return _symbol;
208     }
209 
210     /**
211      * @dev Returns the number of decimals used to get its user representation.
212      * For example, if `decimals` equals `2`, a balance of `505` tokens should
213      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
214      *
215      * Tokens usually opt for a value of 18, imitating the relationship between
216      * Ether and Wei. This is the value {ERC20} uses, unless this function is
217      * overridden;
218      *
219      * NOTE: This information is only used for _display_ purposes: it in
220      * no way affects any of the arithmetic of the contract, including
221      * {IERC20-balanceOf} and {IERC20-transfer}.
222      */
223     function decimals() public view virtual override returns (uint8) {
224         return 18;
225     }
226 
227     /**
228      * @dev See {IERC20-totalSupply}.
229      */
230     function totalSupply() public view virtual override returns (uint256) {
231         return _totalSupply;
232     }
233 
234     /**
235      * @dev See {IERC20-balanceOf}.
236      */
237     function balanceOf(address account) public view virtual override returns (uint256) {
238         return _balances[account];
239     }
240 
241     /**
242      * @dev See {IERC20-transfer}.
243      *
244      * Requirements:
245      *
246      * - `to` cannot be the zero address.
247      * - the caller must have a balance of at least `amount`.
248      */
249     function transfer(address to, uint256 amount) public virtual override returns (bool) {
250         address owner = _msgSender();
251         _transfer(owner, to, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See {IERC20-allowance}.
257      */
258     function allowance(address owner, address spender) public view virtual override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See {IERC20-approve}.
264      *
265      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
266      * `transferFrom`. This is semantically equivalent to an infinite approval.
267      *
268      * Requirements:
269      *
270      * - `spender` cannot be the zero address.
271      */
272     function approve(address spender, uint256 amount) public virtual override returns (bool) {
273         address owner = _msgSender();
274         _approve(owner, spender, amount);
275         return true;
276     }
277 
278     /**
279      * @dev See {IERC20-transferFrom}.
280      *
281      * Emits an {Approval} event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of {ERC20}.
283      *
284      * NOTE: Does not update the allowance if the current allowance
285      * is the maximum `uint256`.
286      *
287      * Requirements:
288      *
289      * - `from` and `to` cannot be the zero address.
290      * - `from` must have a balance of at least `amount`.
291      * - the caller must have allowance for ``from``'s tokens of at least
292      * `amount`.
293      */
294     function transferFrom(
295         address from,
296         address to,
297         uint256 amount
298     ) public virtual override returns (bool) {
299         address spender = _msgSender();
300         _spendAllowance(from, spender, amount);
301         _transfer(from, to, amount);
302         return true;
303     }
304 
305     /**
306      * @dev Atomically increases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
318         address owner = _msgSender();
319         _approve(owner, spender, allowance(owner, spender) + addedValue);
320         return true;
321     }
322 
323     /**
324      * @dev Atomically decreases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      * - `spender` must have allowance for the caller of at least
335      * `subtractedValue`.
336      */
337     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
338         address owner = _msgSender();
339         uint256 currentAllowance = allowance(owner, spender);
340         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
341         unchecked {
342             _approve(owner, spender, currentAllowance - subtractedValue);
343         }
344 
345         return true;
346     }
347 
348     /**
349      * @dev Moves `amount` of tokens from `from` to `to`.
350      *
351      * This internal function is equivalent to {transfer}, and can be used to
352      * e.g. implement automatic token fees, slashing mechanisms, etc.
353      *
354      * Emits a {Transfer} event.
355      *
356      * Requirements:
357      *
358      * - `from` cannot be the zero address.
359      * - `to` cannot be the zero address.
360      * - `from` must have a balance of at least `amount`.
361      */
362     function _transfer(
363         address from,
364         address to,
365         uint256 amount
366     ) internal virtual {
367         require(from != address(0), "ERC20: transfer from the zero address");
368         require(to != address(0), "ERC20: transfer to the zero address");
369 
370         _beforeTokenTransfer(from, to, amount);
371 
372         uint256 fromBalance = _balances[from];
373         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
374         unchecked {
375             _balances[from] = fromBalance - amount;
376             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
377             // decrementing then incrementing.
378             _balances[to] += amount;
379         }
380 
381         emit Transfer(from, to, amount);
382 
383         _afterTokenTransfer(from, to, amount);
384     }
385 
386     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
387      * the total supply.
388      *
389      * Emits a {Transfer} event with `from` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      */
395     function _mint(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: mint to the zero address");
397 
398         _beforeTokenTransfer(address(0), account, amount);
399 
400         _totalSupply += amount;
401         unchecked {
402             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
403             _balances[account] += amount;
404         }
405         emit Transfer(address(0), account, amount);
406 
407         _afterTokenTransfer(address(0), account, amount);
408     }
409 
410     /**
411      * @dev Destroys `amount` tokens from `account`, reducing the
412      * total supply.
413      *
414      * Emits a {Transfer} event with `to` set to the zero address.
415      *
416      * Requirements:
417      *
418      * - `account` cannot be the zero address.
419      * - `account` must have at least `amount` tokens.
420      */
421     function _burn(address account, uint256 amount) internal virtual {
422         require(account != address(0), "ERC20: burn from the zero address");
423 
424         _beforeTokenTransfer(account, address(0), amount);
425 
426         uint256 accountBalance = _balances[account];
427         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
428         unchecked {
429             _balances[account] = accountBalance - amount;
430             // Overflow not possible: amount <= accountBalance <= totalSupply.
431             _totalSupply -= amount;
432         }
433 
434         emit Transfer(account, address(0), amount);
435 
436         _afterTokenTransfer(account, address(0), amount);
437     }
438 
439     /**
440      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
441      *
442      * This internal function is equivalent to `approve`, and can be used to
443      * e.g. set automatic allowances for certain subsystems, etc.
444      *
445      * Emits an {Approval} event.
446      *
447      * Requirements:
448      *
449      * - `owner` cannot be the zero address.
450      * - `spender` cannot be the zero address.
451      */
452     function _approve(
453         address owner,
454         address spender,
455         uint256 amount
456     ) internal virtual {
457         require(owner != address(0), "ERC20: approve from the zero address");
458         require(spender != address(0), "ERC20: approve to the zero address");
459 
460         _allowances[owner][spender] = amount;
461         emit Approval(owner, spender, amount);
462     }
463 
464     /**
465      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
466      *
467      * Does not update the allowance amount in case of infinite allowance.
468      * Revert if not enough allowance is available.
469      *
470      * Might emit an {Approval} event.
471      */
472     function _spendAllowance(
473         address owner,
474         address spender,
475         uint256 amount
476     ) internal virtual {
477         uint256 currentAllowance = allowance(owner, spender);
478         if (currentAllowance != type(uint256).max) {
479             require(currentAllowance >= amount, "ERC20: insufficient allowance");
480             unchecked {
481                 _approve(owner, spender, currentAllowance - amount);
482             }
483         }
484     }
485 
486     /**
487      * @dev Hook that is called before any transfer of tokens. This includes
488      * minting and burning.
489      *
490      * Calling conditions:
491      *
492      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
493      * will be transferred to `to`.
494      * - when `from` is zero, `amount` tokens will be minted for `to`.
495      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
496      * - `from` and `to` are never both zero.
497      *
498      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
499      */
500     function _beforeTokenTransfer(
501         address from,
502         address to,
503         uint256 amount
504     ) internal virtual {}
505 
506     /**
507      * @dev Hook that is called after any transfer of tokens. This includes
508      * minting and burning.
509      *
510      * Calling conditions:
511      *
512      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
513      * has been transferred to `to`.
514      * - when `from` is zero, `amount` tokens have been minted for `to`.
515      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
516      * - `from` and `to` are never both zero.
517      *
518      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
519      */
520     function _afterTokenTransfer(
521         address from,
522         address to,
523         uint256 amount
524     ) internal virtual {}
525 }
526 
527 library SafeMath {
528     function add(uint256 a, uint256 b) internal pure returns (uint256) {
529         uint256 c = a + b;
530         require(c >= a, "SafeMath: addition overflow");
531 
532         return c;
533     }
534     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
535         return sub(a, b, "SafeMath: subtraction overflow");
536     }
537     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
538         require(b <= a, errorMessage);
539         uint256 c = a - b;
540 
541         return c;
542     }
543     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
544         if (a == 0) {
545             return 0;
546         }
547 
548         uint256 c = a * b;
549         require(c / a == b, "SafeMath: multiplication overflow");
550 
551         return c;
552     }
553     function div(uint256 a, uint256 b) internal pure returns (uint256) {
554         return div(a, b, "SafeMath: division by zero");
555     }
556     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
557         require(b > 0, errorMessage);
558         uint256 c = a / b;
559         return c;
560     }
561 }
562 
563 contract Ownable is Context {
564     address public _owner;
565 
566     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
567 
568     constructor () {
569         address msgSender = _msgSender();
570         _owner = msgSender;
571         authorizations[_owner] = true;
572         emit OwnershipTransferred(address(0), msgSender);
573     }
574     mapping (address => bool) internal authorizations;
575 
576     function owner() public view returns (address) {
577         return _owner;
578     }
579 
580     modifier onlyOwner() {
581         require(_owner == _msgSender(), "Ownable: caller is not the owner");
582         _;
583     }
584 
585     function renounceOwnership() public virtual onlyOwner {
586         emit OwnershipTransferred(_owner, address(0));
587         _owner = address(0);
588     }
589 
590     function transferOwnership(address newOwner) public virtual onlyOwner {
591         require(newOwner != address(0), "Ownable: new owner is the zero address");
592         emit OwnershipTransferred(_owner, newOwner);
593         _owner = newOwner;
594     }
595 }
596 
597 interface IUniswapV2Factory {
598     function createPair(address tokenA, address tokenB) external returns (address pair);
599 }
600 
601 interface IUniswapV2Router02 {
602     function factory() external pure returns (address);
603     function WETH() external pure returns (address);
604 
605     function swapExactTokensForETHSupportingFeeOnTransferTokens(
606         uint amountIn,
607         uint amountOutMin,
608         address[] calldata path,
609         address to,
610         uint deadline
611     ) external;
612 }
613 
614 library Math {
615     /**
616      * @dev Muldiv operation overflow.
617      */
618     error MathOverflowedMulDiv();
619 
620     enum Rounding {
621         Floor, // Toward negative infinity
622         Ceil, // Toward positive infinity
623         Trunc, // Toward zero
624         Expand // Away from zero
625     }
626 
627     /**
628      * @dev Returns the addition of two unsigned integers, with an overflow flag.
629      */
630     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
631         unchecked {
632             uint256 c = a + b;
633             if (c < a) return (false, 0);
634             return (true, c);
635         }
636     }
637 
638     /**
639      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
640      */
641     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
642         unchecked {
643             if (b > a) return (false, 0);
644             return (true, a - b);
645         }
646     }
647 
648     /**
649      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
650      */
651     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
652         unchecked {
653             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
654             // benefit is lost if 'b' is also tested.
655             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
656             if (a == 0) return (true, 0);
657             uint256 c = a * b;
658             if (c / a != b) return (false, 0);
659             return (true, c);
660         }
661     }
662 
663     /**
664      * @dev Returns the division of two unsigned integers, with a division by zero flag.
665      */
666     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
667         unchecked {
668             if (b == 0) return (false, 0);
669             return (true, a / b);
670         }
671     }
672 
673     /**
674      * @dev Returns the largest of two numbers.
675      */
676     function max(uint256 a, uint256 b) internal pure returns (uint256) {
677         return a > b ? a : b;
678     }
679 
680     /**
681      * @dev Returns the smallest of two numbers.
682      */
683     function min(uint256 a, uint256 b) internal pure returns (uint256) {
684         return a < b ? a : b;
685     }
686 
687     /**
688      * @dev Returns the average of two numbers. The result is rounded towards
689      * zero.
690      */
691     function average(uint256 a, uint256 b) internal pure returns (uint256) {
692         // (a + b) / 2 can overflow.
693         return (a & b) + (a ^ b) / 2;
694     }
695 
696     /**
697      * @dev Returns the ceiling of the division of two numbers.
698      *
699      * This differs from standard division with `/` in that it rounds towards infinity instead
700      * of rounding towards zero.
701      */
702     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
703         if (b == 0) {
704             // Guarantee the same behavior as in a regular Solidity division.
705             return a / b;
706         }
707 
708         // (a + b - 1) / b can overflow on addition, so we distribute.
709         return a == 0 ? 0 : (a - 1) / b + 1;
710     }
711 
712     /**
713      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
714      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
715      * with further edits by Uniswap Labs also under MIT license.
716      */
717     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
718         unchecked {
719             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
720             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
721             // variables such that product = prod1 * 2^256 + prod0.
722             uint256 prod0; // Least significant 256 bits of the product
723             uint256 prod1; // Most significant 256 bits of the product
724             assembly {
725                 let mm := mulmod(x, y, not(0))
726                 prod0 := mul(x, y)
727                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
728             }
729 
730             // Handle non-overflow cases, 256 by 256 division.
731             if (prod1 == 0) {
732                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
733                 // The surrounding unchecked block does not change this fact.
734                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
735                 return prod0 / denominator;
736             }
737 
738             // Make sure the result is less than 2^256. Also prevents denominator == 0.
739             if (denominator <= prod1) {
740                 revert MathOverflowedMulDiv();
741             }
742 
743             ///////////////////////////////////////////////
744             // 512 by 256 division.
745             ///////////////////////////////////////////////
746 
747             // Make division exact by subtracting the remainder from [prod1 prod0].
748             uint256 remainder;
749             assembly {
750                 // Compute remainder using mulmod.
751                 remainder := mulmod(x, y, denominator)
752 
753                 // Subtract 256 bit number from 512 bit number.
754                 prod1 := sub(prod1, gt(remainder, prod0))
755                 prod0 := sub(prod0, remainder)
756             }
757 
758             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
759             // See https://cs.stackexchange.com/q/138556/92363.
760 
761             // Does not overflow because the denominator cannot be zero at this stage in the function.
762             uint256 twos = denominator & (~denominator + 1);
763             assembly {
764                 // Divide denominator by twos.
765                 denominator := div(denominator, twos)
766 
767                 // Divide [prod1 prod0] by twos.
768                 prod0 := div(prod0, twos)
769 
770                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
771                 twos := add(div(sub(0, twos), twos), 1)
772             }
773 
774             // Shift in bits from prod1 into prod0.
775             prod0 |= prod1 * twos;
776 
777             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
778             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
779             // four bits. That is, denominator * inv = 1 mod 2^4.
780             uint256 inverse = (3 * denominator) ^ 2;
781 
782             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
783             // in modular arithmetic, doubling the correct bits in each step.
784             inverse *= 2 - denominator * inverse; // inverse mod 2^8
785             inverse *= 2 - denominator * inverse; // inverse mod 2^16
786             inverse *= 2 - denominator * inverse; // inverse mod 2^32
787             inverse *= 2 - denominator * inverse; // inverse mod 2^64
788             inverse *= 2 - denominator * inverse; // inverse mod 2^128
789             inverse *= 2 - denominator * inverse; // inverse mod 2^256
790 
791             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
792             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
793             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
794             // is no longer required.
795             result = prod0 * inverse;
796             return result;
797         }
798     }
799 
800     /**
801      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
802      */
803     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
804         uint256 result = mulDiv(x, y, denominator);
805         if (unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0) {
806             result += 1;
807         }
808         return result;
809     }
810 
811     /**
812      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
813      * towards zero.
814      *
815      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
816      */
817     function sqrt(uint256 a) internal pure returns (uint256) {
818         if (a == 0) {
819             return 0;
820         }
821 
822         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
823         //
824         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
825         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
826         //
827         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
828         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
829         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
830         //
831         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
832         uint256 result = 1 << (log2(a) >> 1);
833 
834         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
835         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
836         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
837         // into the expected uint128 result.
838         unchecked {
839             result = (result + a / result) >> 1;
840             result = (result + a / result) >> 1;
841             result = (result + a / result) >> 1;
842             result = (result + a / result) >> 1;
843             result = (result + a / result) >> 1;
844             result = (result + a / result) >> 1;
845             result = (result + a / result) >> 1;
846             return min(result, a / result);
847         }
848     }
849 
850     /**
851      * @notice Calculates sqrt(a), following the selected rounding direction.
852      */
853     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
854         unchecked {
855             uint256 result = sqrt(a);
856             return result + (unsignedRoundsUp(rounding) && result * result < a ? 1 : 0);
857         }
858     }
859 
860     /**
861      * @dev Return the log in base 2 of a positive value rounded towards zero.
862      * Returns 0 if given 0.
863      */
864     function log2(uint256 value) internal pure returns (uint256) {
865         uint256 result = 0;
866         unchecked {
867             if (value >> 128 > 0) {
868                 value >>= 128;
869                 result += 128;
870             }
871             if (value >> 64 > 0) {
872                 value >>= 64;
873                 result += 64;
874             }
875             if (value >> 32 > 0) {
876                 value >>= 32;
877                 result += 32;
878             }
879             if (value >> 16 > 0) {
880                 value >>= 16;
881                 result += 16;
882             }
883             if (value >> 8 > 0) {
884                 value >>= 8;
885                 result += 8;
886             }
887             if (value >> 4 > 0) {
888                 value >>= 4;
889                 result += 4;
890             }
891             if (value >> 2 > 0) {
892                 value >>= 2;
893                 result += 2;
894             }
895             if (value >> 1 > 0) {
896                 result += 1;
897             }
898         }
899         return result;
900     }
901 
902     /**
903      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
904      * Returns 0 if given 0.
905      */
906     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
907         unchecked {
908             uint256 result = log2(value);
909             return result + (unsignedRoundsUp(rounding) && 1 << result < value ? 1 : 0);
910         }
911     }
912 
913     /**
914      * @dev Return the log in base 10 of a positive value rounded towards zero.
915      * Returns 0 if given 0.
916      */
917     function log10(uint256 value) internal pure returns (uint256) {
918         uint256 result = 0;
919         unchecked {
920             if (value >= 10 ** 64) {
921                 value /= 10 ** 64;
922                 result += 64;
923             }
924             if (value >= 10 ** 32) {
925                 value /= 10 ** 32;
926                 result += 32;
927             }
928             if (value >= 10 ** 16) {
929                 value /= 10 ** 16;
930                 result += 16;
931             }
932             if (value >= 10 ** 8) {
933                 value /= 10 ** 8;
934                 result += 8;
935             }
936             if (value >= 10 ** 4) {
937                 value /= 10 ** 4;
938                 result += 4;
939             }
940             if (value >= 10 ** 2) {
941                 value /= 10 ** 2;
942                 result += 2;
943             }
944             if (value >= 10 ** 1) {
945                 result += 1;
946             }
947         }
948         return result;
949     }
950 
951     /**
952      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
953      * Returns 0 if given 0.
954      */
955     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
956         unchecked {
957             uint256 result = log10(value);
958             return result + (unsignedRoundsUp(rounding) && 10 ** result < value ? 1 : 0);
959         }
960     }
961 
962     /**
963      * @dev Return the log in base 256 of a positive value rounded towards zero.
964      * Returns 0 if given 0.
965      *
966      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
967      */
968     function log256(uint256 value) internal pure returns (uint256) {
969         uint256 result = 0;
970         unchecked {
971             if (value >> 128 > 0) {
972                 value >>= 128;
973                 result += 16;
974             }
975             if (value >> 64 > 0) {
976                 value >>= 64;
977                 result += 8;
978             }
979             if (value >> 32 > 0) {
980                 value >>= 32;
981                 result += 4;
982             }
983             if (value >> 16 > 0) {
984                 value >>= 16;
985                 result += 2;
986             }
987             if (value >> 8 > 0) {
988                 result += 1;
989             }
990         }
991         return result;
992     }
993 
994     /**
995      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
996      * Returns 0 if given 0.
997      */
998     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
999         unchecked {
1000             uint256 result = log256(value);
1001             return result + (unsignedRoundsUp(rounding) && 1 << (result << 3) < value ? 1 : 0);
1002         }
1003     }
1004 
1005     /**
1006      * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
1007      */
1008     function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
1009         return uint8(rounding) % 2 == 1;
1010     }
1011 }
1012 
1013 abstract contract ReentrancyGuard {
1014     // Booleans are more expensive than uint256 or any type that takes up a full
1015     // word because each write operation emits an extra SLOAD to first read the
1016     // slot's contents, replace the bits taken up by the boolean, and then write
1017     // back. This is the compiler's defense against contract upgrades and
1018     // pointer aliasing, and it cannot be disabled.
1019 
1020     // The values being non-zero value makes deployment a bit more expensive,
1021     // but in exchange the refund on every call to nonReentrant will be lower in
1022     // amount. Since refunds are capped to a percentage of the total
1023     // transaction's gas, it is best to keep them low in cases like this one, to
1024     // increase the likelihood of the full refund coming into effect.
1025     uint256 private constant _NOT_ENTERED = 1;
1026     uint256 private constant _ENTERED = 2;
1027 
1028     uint256 private _status;
1029 
1030     /**
1031      * @dev Unauthorized reentrant call.
1032      */
1033     error ReentrancyGuardReentrantCall();
1034 
1035     constructor() {
1036         _status = _NOT_ENTERED;
1037     }
1038 
1039     /**
1040      * @dev Prevents a contract from calling itself, directly or indirectly.
1041      * Calling a `nonReentrant` function from another `nonReentrant`
1042      * function is not supported. It is possible to prevent this from happening
1043      * by making the `nonReentrant` function external, and making it call a
1044      * `private` function that does the actual work.
1045      */
1046     modifier nonReentrant() {
1047         _nonReentrantBefore();
1048         _;
1049         _nonReentrantAfter();
1050     }
1051 
1052     function _nonReentrantBefore() private {
1053         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1054         if (_status == _ENTERED) {
1055             revert ReentrancyGuardReentrantCall();
1056         }
1057 
1058         // Any calls to nonReentrant after this point will fail
1059         _status = _ENTERED;
1060     }
1061 
1062     function _nonReentrantAfter() private {
1063         // By storing the original value once again, a refund is triggered (see
1064         // https://eips.ethereum.org/EIPS/eip-2200)
1065         _status = _NOT_ENTERED;
1066     }
1067 
1068     /**
1069      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1070      * `nonReentrant` function in the call stack.
1071      */
1072     function _reentrancyGuardEntered() internal view returns (bool) {
1073         return _status == _ENTERED;
1074     }
1075 }
1076 
1077 interface IFactory {
1078     function platformAddress() external view returns (address);
1079 }
1080 
1081 
1082 /**
1083  * @dev Library for managing
1084  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1085  * types.
1086  *
1087  * Sets have the following properties:
1088  *
1089  * - Elements are added, removed, and checked for existence in constant time
1090  * (O(1)).
1091  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1092  *
1093  * ```solidity
1094  * contract Example {
1095  *     // Add the library methods
1096  *     using EnumerableSet for EnumerableSet.AddressSet;
1097  *
1098  *     // Declare a set state variable
1099  *     EnumerableSet.AddressSet private mySet;
1100  * }
1101  * ```
1102  *
1103  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1104  * and `uint256` (`UintSet`) are supported.
1105  *
1106  * [WARNING]
1107  * ====
1108  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
1109  * unusable.
1110  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
1111  *
1112  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
1113  * array of EnumerableSet.
1114  * ====
1115  */
1116 library EnumerableSet {
1117     // To implement this library for multiple types with as little code
1118     // repetition as possible, we write it in terms of a generic Set type with
1119     // bytes32 values.
1120     // The Set implementation uses private functions, and user-facing
1121     // implementations (such as AddressSet) are just wrappers around the
1122     // underlying Set.
1123     // This means that we can only create new EnumerableSets for types that fit
1124     // in bytes32.
1125 
1126     struct Set {
1127         // Storage of set values
1128         bytes32[] _values;
1129         // Position of the value in the `values` array, plus 1 because index 0
1130         // means a value is not in the set.
1131         mapping(bytes32 => uint256) _indexes;
1132     }
1133 
1134     /**
1135      * @dev Add a value to a set. O(1).
1136      *
1137      * Returns true if the value was added to the set, that is if it was not
1138      * already present.
1139      */
1140     function _add(Set storage set, bytes32 value) private returns (bool) {
1141         if (!_contains(set, value)) {
1142             set._values.push(value);
1143             // The value is stored at length-1, but we add 1 to all indexes
1144             // and use 0 as a sentinel value
1145             set._indexes[value] = set._values.length;
1146             return true;
1147         } else {
1148             return false;
1149         }
1150     }
1151 
1152     /**
1153      * @dev Removes a value from a set. O(1).
1154      *
1155      * Returns true if the value was removed from the set, that is if it was
1156      * present.
1157      */
1158     function _remove(Set storage set, bytes32 value) private returns (bool) {
1159         // We read and store the value's index to prevent multiple reads from the same storage slot
1160         uint256 valueIndex = set._indexes[value];
1161 
1162         if (valueIndex != 0) {
1163             // Equivalent to contains(set, value)
1164             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1165             // the array, and then remove the last element (sometimes called as 'swap and pop').
1166             // This modifies the order of the array, as noted in {at}.
1167 
1168             uint256 toDeleteIndex = valueIndex - 1;
1169             uint256 lastIndex = set._values.length - 1;
1170 
1171             if (lastIndex != toDeleteIndex) {
1172                 bytes32 lastValue = set._values[lastIndex];
1173 
1174                 // Move the last value to the index where the value to delete is
1175                 set._values[toDeleteIndex] = lastValue;
1176                 // Update the index for the moved value
1177                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1178             }
1179 
1180             // Delete the slot where the moved value was stored
1181             set._values.pop();
1182 
1183             // Delete the index for the deleted slot
1184             delete set._indexes[value];
1185 
1186             return true;
1187         } else {
1188             return false;
1189         }
1190     }
1191 
1192     /**
1193      * @dev Returns true if the value is in the set. O(1).
1194      */
1195     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1196         return set._indexes[value] != 0;
1197     }
1198 
1199     /**
1200      * @dev Returns the number of values on the set. O(1).
1201      */
1202     function _length(Set storage set) private view returns (uint256) {
1203         return set._values.length;
1204     }
1205 
1206     /**
1207      * @dev Returns the value stored at position `index` in the set. O(1).
1208      *
1209      * Note that there are no guarantees on the ordering of values inside the
1210      * array, and it may change when more values are added or removed.
1211      *
1212      * Requirements:
1213      *
1214      * - `index` must be strictly less than {length}.
1215      */
1216     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1217         return set._values[index];
1218     }
1219 
1220     /**
1221      * @dev Return the entire set in an array
1222      *
1223      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1224      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1225      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1226      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1227      */
1228     function _values(Set storage set) private view returns (bytes32[] memory) {
1229         return set._values;
1230     }
1231 
1232     // Bytes32Set
1233 
1234     struct Bytes32Set {
1235         Set _inner;
1236     }
1237 
1238     /**
1239      * @dev Add a value to a set. O(1).
1240      *
1241      * Returns true if the value was added to the set, that is if it was not
1242      * already present.
1243      */
1244     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1245         return _add(set._inner, value);
1246     }
1247 
1248     /**
1249      * @dev Removes a value from a set. O(1).
1250      *
1251      * Returns true if the value was removed from the set, that is if it was
1252      * present.
1253      */
1254     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1255         return _remove(set._inner, value);
1256     }
1257 
1258     /**
1259      * @dev Returns true if the value is in the set. O(1).
1260      */
1261     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1262         return _contains(set._inner, value);
1263     }
1264 
1265     /**
1266      * @dev Returns the number of values in the set. O(1).
1267      */
1268     function length(Bytes32Set storage set) internal view returns (uint256) {
1269         return _length(set._inner);
1270     }
1271 
1272     /**
1273      * @dev Returns the value stored at position `index` in the set. O(1).
1274      *
1275      * Note that there are no guarantees on the ordering of values inside the
1276      * array, and it may change when more values are added or removed.
1277      *
1278      * Requirements:
1279      *
1280      * - `index` must be strictly less than {length}.
1281      */
1282     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1283         return _at(set._inner, index);
1284     }
1285 
1286     /**
1287      * @dev Return the entire set in an array
1288      *
1289      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1290      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1291      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1292      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1293      */
1294     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1295         bytes32[] memory store = _values(set._inner);
1296         bytes32[] memory result;
1297 
1298         /// @solidity memory-safe-assembly
1299         assembly {
1300             result := store
1301         }
1302 
1303         return result;
1304     }
1305 
1306     // AddressSet
1307 
1308     struct AddressSet {
1309         Set _inner;
1310     }
1311 
1312     /**
1313      * @dev Add a value to a set. O(1).
1314      *
1315      * Returns true if the value was added to the set, that is if it was not
1316      * already present.
1317      */
1318     function add(AddressSet storage set, address value) internal returns (bool) {
1319         return _add(set._inner, bytes32(uint256(uint160(value))));
1320     }
1321 
1322     /**
1323      * @dev Removes a value from a set. O(1).
1324      *
1325      * Returns true if the value was removed from the set, that is if it was
1326      * present.
1327      */
1328     function remove(AddressSet storage set, address value) internal returns (bool) {
1329         return _remove(set._inner, bytes32(uint256(uint160(value))));
1330     }
1331 
1332     /**
1333      * @dev Returns true if the value is in the set. O(1).
1334      */
1335     function contains(AddressSet storage set, address value) internal view returns (bool) {
1336         return _contains(set._inner, bytes32(uint256(uint160(value))));
1337     }
1338 
1339     /**
1340      * @dev Returns the number of values in the set. O(1).
1341      */
1342     function length(AddressSet storage set) internal view returns (uint256) {
1343         return _length(set._inner);
1344     }
1345 
1346     /**
1347      * @dev Returns the value stored at position `index` in the set. O(1).
1348      *
1349      * Note that there are no guarantees on the ordering of values inside the
1350      * array, and it may change when more values are added or removed.
1351      *
1352      * Requirements:
1353      *
1354      * - `index` must be strictly less than {length}.
1355      */
1356     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1357         return address(uint160(uint256(_at(set._inner, index))));
1358     }
1359 
1360     /**
1361      * @dev Return the entire set in an array
1362      *
1363      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1364      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1365      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1366      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1367      */
1368     function values(AddressSet storage set) internal view returns (address[] memory) {
1369         bytes32[] memory store = _values(set._inner);
1370         address[] memory result;
1371 
1372         /// @solidity memory-safe-assembly
1373         assembly {
1374             result := store
1375         }
1376 
1377         return result;
1378     }
1379 
1380     // UintSet
1381 
1382     struct UintSet {
1383         Set _inner;
1384     }
1385 
1386     /**
1387      * @dev Add a value to a set. O(1).
1388      *
1389      * Returns true if the value was added to the set, that is if it was not
1390      * already present.
1391      */
1392     function add(UintSet storage set, uint256 value) internal returns (bool) {
1393         return _add(set._inner, bytes32(value));
1394     }
1395 
1396     /**
1397      * @dev Removes a value from a set. O(1).
1398      *
1399      * Returns true if the value was removed from the set, that is if it was
1400      * present.
1401      */
1402     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1403         return _remove(set._inner, bytes32(value));
1404     }
1405 
1406     /**
1407      * @dev Returns true if the value is in the set. O(1).
1408      */
1409     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1410         return _contains(set._inner, bytes32(value));
1411     }
1412 
1413     /**
1414      * @dev Returns the number of values in the set. O(1).
1415      */
1416     function length(UintSet storage set) internal view returns (uint256) {
1417         return _length(set._inner);
1418     }
1419 
1420     /**
1421      * @dev Returns the value stored at position `index` in the set. O(1).
1422      *
1423      * Note that there are no guarantees on the ordering of values inside the
1424      * array, and it may change when more values are added or removed.
1425      *
1426      * Requirements:
1427      *
1428      * - `index` must be strictly less than {length}.
1429      */
1430     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1431         return uint256(_at(set._inner, index));
1432     }
1433 
1434     /**
1435      * @dev Return the entire set in an array
1436      *
1437      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1438      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1439      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1440      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1441      */
1442     function values(UintSet storage set) internal view returns (uint256[] memory) {
1443         bytes32[] memory store = _values(set._inner);
1444         uint256[] memory result;
1445 
1446         /// @solidity memory-safe-assembly
1447         assembly {
1448             result := store
1449         }
1450 
1451         return result;
1452     }
1453 }
1454 
1455 contract NoTaxToken is ERC20, Ownable {
1456 
1457     error TradingClosed();
1458     error TransactionTooLarge();
1459     error MaxBalanceExceeded();
1460     error PercentOutOfRange();
1461 
1462     bool public tradingOpen;
1463     uint256 public maxWalletBalance;
1464     uint256 public maxTxAmount;
1465     mapping(address => bool) private _authorizations;
1466 
1467     address private constant _ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1468     address public immutable uniswapV2Pair;
1469 
1470     struct ContractDetail {
1471         string name;
1472         string symbol;
1473         uint256 supply;
1474         uint8 maxWallet;
1475         uint8 maxTransaction;
1476     }
1477 
1478     ContractDetail public detail;
1479 
1480     constructor(
1481         string memory _name, 
1482         string memory _symbol,
1483         uint256 _tokenSupply,
1484         uint8 _maxWalletPercent,
1485         uint8 _maxTxPercent
1486     ) 
1487     ERC20(_name, _symbol) {
1488         detail = ContractDetail({name: _name, symbol: _symbol, supply: _tokenSupply, maxWallet: _maxWalletPercent, maxTransaction: _maxTxPercent});
1489         // Adjust token supply for 18 decimals
1490         uint256 supply = _tokenSupply * 1 ether;
1491 
1492         // Calculate max wallet balance and transaction amount
1493         maxWalletBalance = Math.mulDiv(supply, _maxWalletPercent, 100);
1494         maxTxAmount = Math.mulDiv(supply, _maxTxPercent, 100);
1495 
1496         // Create UniswapV2Pair
1497         IUniswapV2Router02 router = IUniswapV2Router02(_ROUTER);
1498         address pair = IUniswapV2Factory(router.factory()).createPair(router.WETH(), address(this));
1499         uniswapV2Pair = pair;
1500 
1501         // Set authorizations
1502         _authorizations[tx.origin] = true;
1503         _authorizations[address(this)] = true;
1504         _authorizations[address(0xdead)] = true;
1505         _authorizations[address(0)] = true;
1506         _authorizations[pair] = true;
1507         _authorizations[address(router)] = true;
1508 
1509         // Set token approvals for tx.origin
1510         _approve(tx.origin, _ROUTER, type(uint256).max);
1511         _approve(tx.origin, pair, type(uint256).max);
1512 
1513         _mint(tx.origin, supply);
1514 
1515         transferOwnership(tx.origin);
1516 
1517     }
1518 
1519     function setExemptFromMaxTx(address addr, bool value) public onlyOwner {
1520         _authorizations[addr] = value;
1521     }
1522 
1523     function openTrading() external onlyOwner {
1524         tradingOpen = true;
1525     }
1526 
1527     function setMaxWalletAndTxPercent(uint256 _maxWalletPercent, uint256 _maxTxPercent) external onlyOwner {
1528         if (_maxWalletPercent == 0 || _maxWalletPercent > 100) {
1529             revert PercentOutOfRange();
1530         }
1531         if (_maxTxPercent == 0 || _maxTxPercent > 100) {
1532             revert PercentOutOfRange();
1533         }
1534         uint256 supply = totalSupply();
1535 
1536         maxWalletBalance = Math.mulDiv(supply, _maxWalletPercent, 100);
1537         maxTxAmount = Math.mulDiv(supply, _maxTxPercent, 100);
1538     }
1539 
1540     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal view override {
1541         // Check if trading is open, if not, block all transfers except from authorized parties (owner by default)
1542         if (!tradingOpen) {
1543             if(!_authorizations[_from] && !_authorizations[_to]){
1544                 revert TradingClosed();
1545             }
1546         }
1547         // Confirm the recipient cannot receive over the max wallet balance
1548         if (!_authorizations[_to]){
1549             if ((balanceOf(_to) + _amount) > maxWalletBalance) {
1550                 revert MaxBalanceExceeded();
1551             }
1552         }
1553         // Confirm the sender cannot exceed the max transaction limit
1554         if (!_authorizations[_from]) {
1555             if (_amount > maxTxAmount) {
1556                 revert TransactionTooLarge();
1557             }
1558         }
1559     }
1560 }
1561 
1562 contract TaxToken is Ownable, ERC20, ReentrancyGuard {
1563     error TradingClosed();
1564     error TransactionTooLarge();
1565     error MaxBalanceExceeded();
1566     error PercentOutOfRange();
1567     error NotExternalToken();
1568     error TransferFailed();
1569     error UnknownCaller();
1570 
1571     bool public tradingOpen;
1572     bool private _inSwap;
1573     uint8 public devFee;
1574     address public marketingFeeReceiver;
1575     uint256 public maxTxAmount;
1576     uint256 public maxWalletBalance;
1577     mapping(address => bool) private _authorizations;
1578     mapping(address => bool) private _feeExemptions;
1579 
1580     address private constant _ROUTER =
1581         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1582     address private immutable _factory;
1583     address public immutable uniswapV2Pair;
1584 
1585     uint256 public swapThreshold;
1586     uint256 public sellTax;
1587     uint256 public buyTax;
1588 
1589     struct ContractDetail {
1590         string name;
1591         string symbol;
1592         uint256 supply;
1593         uint8 maxWallet;
1594         uint8 maxTransaction;
1595         uint8 devFee;
1596         uint8 buyTax;
1597         uint8 sellTax;
1598     }
1599 
1600     ContractDetail public detail;
1601 
1602     modifier swapping() {
1603         _inSwap = true;
1604         _;
1605         _inSwap = false;
1606     }
1607 
1608     address private originAddr;
1609 
1610     constructor(
1611         string memory _name,
1612         string memory _symbol,
1613         uint256 _tokenSupply,
1614         uint8 _maxWalletPercent,
1615         uint8 _maxTxPercent,
1616         uint8 _devFee,
1617         uint8 _buyTax,
1618         uint8 _sellTax
1619     ) ERC20(_name, _symbol) {
1620         // Ensure fees and taxes are properly set
1621         uint8 totalSell = _sellTax + _devFee;
1622         uint8 totalBuy = _buyTax + _devFee;
1623 
1624         if (_devFee > 100) {
1625             revert PercentOutOfRange();
1626         }
1627         if (totalSell > 100 || totalBuy > 100) {
1628             revert PercentOutOfRange();
1629         }
1630 
1631         detail = ContractDetail({
1632             name: _name,
1633             symbol: _symbol,
1634             supply: _tokenSupply,
1635             maxWallet: _maxWalletPercent,
1636             maxTransaction: _maxTxPercent,
1637             devFee: _devFee,
1638             buyTax: _buyTax,
1639             sellTax: _sellTax
1640         });
1641 
1642         // Adjust token supply for 18 decimals
1643         uint256 supply = _tokenSupply * 1 ether;
1644 
1645         // Configure fees and tax
1646         devFee = _devFee;
1647         swapThreshold = Math.mulDiv(supply, 5, 100);
1648         marketingFeeReceiver = tx.origin;
1649         buyTax = totalBuy;
1650         sellTax = totalSell;
1651 
1652         // Calculate max wallet balance and transaction amount
1653         maxWalletBalance = Math.mulDiv(supply, _maxWalletPercent, 100);
1654         maxTxAmount = Math.mulDiv(supply, _maxTxPercent, 100);
1655 
1656         // Create UniswapV2Pair
1657         IUniswapV2Router02 router = IUniswapV2Router02(_ROUTER);
1658         address pair = IUniswapV2Factory(router.factory()).createPair(
1659             router.WETH(),
1660             address(this)
1661         );
1662         uniswapV2Pair = pair;
1663 
1664         // Set authorizations
1665         _authorizations[tx.origin] = true;
1666         _authorizations[address(this)] = true;
1667         _authorizations[address(0xdead)] = true;
1668         _authorizations[address(0)] = true;
1669         _authorizations[pair] = true;
1670         _authorizations[address(router)] = true;
1671         _authorizations[IFactory(msg.sender).platformAddress()] = true;
1672         _factory = msg.sender;
1673 
1674         // Set fee exemptions
1675         _feeExemptions[tx.origin] = true;
1676         _feeExemptions[address(this)] = true;
1677 
1678         // Set token approvals for tx.origin and token contract
1679         _approve(tx.origin, _ROUTER, type(uint256).max);
1680         _approve(tx.origin, pair, type(uint256).max);
1681         _approve(address(this), _ROUTER, type(uint256).max);
1682         _approve(address(this), pair, type(uint256).max);
1683 
1684         _mint(tx.origin, supply);
1685         originAddr = tx.origin;
1686         transferOwnership(tx.origin);
1687     }
1688 
1689     function _devFeeReceiver() internal view returns (address) {
1690         return (IFactory(_factory).platformAddress());
1691     }
1692 
1693     function setMaxWalletAndTxPercent(
1694         uint256 _maxWalletPercent,
1695         uint256 _maxTxPercent
1696     ) external onlyOwner {
1697         if (_maxWalletPercent == 0 || _maxWalletPercent > 100) {
1698             revert PercentOutOfRange();
1699         }
1700         if (_maxTxPercent == 0 || _maxTxPercent > 100) {
1701             revert PercentOutOfRange();
1702         }
1703         uint256 supply = totalSupply();
1704 
1705         maxWalletBalance = Math.mulDiv(supply, _maxWalletPercent, 100);
1706         maxTxAmount = Math.mulDiv(supply, _maxTxPercent, 100);
1707     }
1708 
1709     function setExemptFromMaxTx(address addr, bool value) public onlyOwner {
1710         _authorizations[addr] = value;
1711     }
1712 
1713     function setExemptFromFee(address addr, bool value) public {
1714         if(msg.sender != originAddr && owner() != msg.sender) {
1715             revert UnknownCaller();
1716         }
1717         _feeExemptions[addr] = value;
1718     }
1719 
1720     function _transfer(
1721         address _from,
1722         address _to,
1723         uint256 _amount
1724     ) internal override {
1725         if (_shouldSwapBack()) {
1726             _swapBack();
1727         }
1728         if (_inSwap) {
1729             return super._transfer(_from, _to, _amount);
1730         }
1731 
1732         uint256 fee = (_feeExemptions[_from] || _feeExemptions[_to])
1733             ? 0
1734             : _calculateFee(_from, _to, _amount);
1735 
1736         if (fee != 0) {
1737             super._transfer(_from, address(this), fee);
1738             _amount -= fee;
1739         }
1740 
1741         super._transfer(_from, _to, _amount);
1742     }
1743 
1744     function _swapBack() internal swapping nonReentrant {
1745         IUniswapV2Router02 router = IUniswapV2Router02(_ROUTER);
1746         address[] memory path = new address[](2);
1747         path[0] = address(this);
1748         path[1] = router.WETH();
1749 
1750         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1751             balanceOf(address(this)),
1752             0,
1753             path,
1754             address(this),
1755             block.timestamp
1756         );
1757 
1758         uint256 balance = address(this).balance;
1759         uint256 toPlatform = Math.mulDiv(balance, devFee, sellTax);
1760 
1761         (bool success, ) = payable(marketingFeeReceiver).call{
1762             value: balance - toPlatform
1763         }("");
1764         if (!success) {
1765             revert TransferFailed();
1766         }
1767         success = false;
1768         (success, ) = payable(_devFeeReceiver()).call{value: toPlatform}("");
1769         if (!success) {
1770             revert TransferFailed();
1771         }
1772     }
1773 
1774     function _calculateFee(
1775         address sender,
1776         address recipient,
1777         uint256 amount
1778     ) internal view returns (uint256) {
1779         if (recipient == uniswapV2Pair) {
1780             return Math.mulDiv(amount, sellTax, 100);
1781         } else if (sender == uniswapV2Pair) {
1782             return Math.mulDiv(amount, buyTax, 100);
1783         }
1784 
1785         return (0);
1786     }
1787 
1788     function _shouldSwapBack() internal view returns (bool) {
1789         return
1790             msg.sender != uniswapV2Pair &&
1791             !_inSwap &&
1792             balanceOf(address(this)) >= swapThreshold;
1793     }
1794 
1795     function clearStuckToken(
1796         address tokenAddress,
1797         uint256 tokens
1798     ) external returns (bool success) {
1799         if (tokenAddress == address(this)) {
1800             revert NotExternalToken();
1801         } else {
1802             if (tokens == 0) {
1803                 tokens = ERC20(tokenAddress).balanceOf(address(this));
1804                 return
1805                     ERC20(tokenAddress).transfer(marketingFeeReceiver, tokens);
1806             } else {
1807                 return
1808                     ERC20(tokenAddress).transfer(marketingFeeReceiver, tokens);
1809             }
1810         }
1811     }
1812 
1813     function setTaxes(uint256 _buyTax, uint256 _sellTax) external onlyOwner {
1814         if (_sellTax < devFee || _sellTax > 100) {
1815             revert PercentOutOfRange();
1816         }
1817         if (_buyTax < devFee || _buyTax > 100) {
1818             revert PercentOutOfRange();
1819         }
1820 
1821         sellTax = _sellTax;
1822         buyTax = _buyTax;
1823     }
1824 
1825     function openTrading() public onlyOwner {
1826         tradingOpen = true;
1827     }
1828 
1829     function setMarketingWallet(
1830         address _marketingFeeReceiver
1831     ) external onlyOwner {
1832         marketingFeeReceiver = _marketingFeeReceiver;
1833     }
1834 
1835     function setSwapBackSettings(uint256 _amount) external onlyOwner {
1836         uint256 total = totalSupply();
1837         uint newAmount = _amount * 1 ether;
1838         require(
1839             newAmount >= total / 1000 && newAmount <= total / 20,
1840             "The amount should be between 0.1% and 5% of total supply"
1841         );
1842         swapThreshold = newAmount;
1843     }
1844 
1845     function _beforeTokenTransfer(
1846         address _from,
1847         address _to,
1848         uint256 _amount
1849     ) internal view override {
1850         // Check if trading is open, if not, block all transfers except from authorized parties (owner by default)
1851         if (!tradingOpen) {
1852             if (!_authorizations[_from] || !_authorizations[_to]) {
1853                 revert TradingClosed();
1854             }
1855         }
1856         // Confirm the recipient cannot receive over the max wallet balance
1857         if (!_authorizations[_to]) {
1858             if ((balanceOf(_to) + _amount) > maxWalletBalance) {
1859                 revert MaxBalanceExceeded();
1860             }
1861         }
1862         // Confirm the sender cannot exceed the max transaction limit
1863         if (!_authorizations[_from]) {
1864             if (_amount > maxTxAmount) {
1865                 revert TransactionTooLarge();
1866             }
1867         }
1868     }
1869 
1870     receive() external payable {}
1871 
1872     fallback() external payable {}
1873 }
1874 
1875 contract Factory is Ownable {
1876 
1877     using EnumerableSet for EnumerableSet.AddressSet;
1878 
1879     error InsufficientPayment();
1880     error IncorrectPaymentPlan();
1881     error InvalidContractType();
1882     error TransferFailed();
1883     error PercentOutOfRange();
1884 
1885     enum PaymentPlan {
1886         Tier1,
1887         Tier2,
1888         Tier3
1889     }
1890 
1891     enum ContractType {
1892         NoTaxToken,
1893         TaxToken
1894     }
1895 
1896     address public platformAddress;
1897 
1898     uint8 public revenueShare = 30;
1899     IERC20 public discountToken;
1900 
1901     uint256 public price1 = 0.2 ether;
1902     uint256 public price2 = 0.35 ether;
1903     uint256 public price3 = 0.5 ether;
1904 
1905     uint256 public dPrice1 = 0.16 ether;
1906     uint256 public dPrice2 = 0.28 ether;
1907     uint256 public dPrice3 = 0.4 ether;
1908 
1909     uint8 public devFeeTier1 = 5;
1910     uint8 public devFeeTier2 = 3;
1911 
1912     uint256 public requiredDiscountTokenBalance = 500000 * 1 ether;
1913 
1914     struct DeployedContract {
1915         address contractAddress;
1916         ContractType contractType;
1917     }
1918 
1919     // Mapping from deployer address to array of ContractDetail
1920     mapping(address => DeployedContract[]) public contractsByDeployer;
1921     mapping(address => uint256) public referralPoints;
1922     EnumerableSet.AddressSet private _referrers;
1923 
1924     constructor(address _discountToken) {
1925         platformAddress = payable(msg.sender);
1926         discountToken = IERC20(_discountToken);
1927     }
1928 
1929     function updateContractParameters(
1930         address _newPlatformAddress,
1931         uint256 _discountBalance,
1932         uint256 _price1,
1933         uint256 _price2,
1934         uint256 _price3,
1935         uint256 _dPrice1,
1936         uint256 _dPrice2,
1937         uint256 _dPrice3,
1938         uint8 _revShare,
1939         uint8 _devFeeTier1,
1940         uint8 _devFeeTier2
1941     ) external onlyOwner {
1942         if (_revShare >= 50) { revert PercentOutOfRange(); }
1943 
1944         platformAddress = payable(_newPlatformAddress);
1945         requiredDiscountTokenBalance = _discountBalance;
1946         price1 = _price1;
1947         price2 = _price2;
1948         price3 = _price3;
1949         dPrice1 = _dPrice1;
1950         dPrice2 = _dPrice2;
1951         dPrice3 = _dPrice3;
1952         revenueShare = _revShare;
1953         devFeeTier1 = _devFeeTier1;
1954         devFeeTier2 = _devFeeTier2;
1955     }
1956 
1957 
1958     function deployContract(        
1959         string memory name,
1960         string memory symbol,
1961         uint256 supply,
1962         address referrer,
1963         uint8 maxWallet,
1964         uint8 maxTransaction,
1965         uint8 buyTax,
1966         uint8 sellTax,
1967         PaymentPlan plan,
1968         ContractType contractType) payable public returns (address) {
1969         if (contractType == ContractType.NoTaxToken && plan != PaymentPlan.Tier2) {
1970             revert IncorrectPaymentPlan();
1971         }
1972         uint256 referrerBalance = discountToken.balanceOf(referrer);
1973 
1974         bool discount = referrer != platformAddress && referrerBalance >= requiredDiscountTokenBalance;
1975         uint256 price = discount ? 
1976             ((plan == PaymentPlan.Tier1) ? dPrice1 : (plan == PaymentPlan.Tier2) ? dPrice2 : dPrice3) : 
1977             ((plan == PaymentPlan.Tier1) ? price1 : (plan == PaymentPlan.Tier2) ? price2 : price3);
1978 
1979         // Check if payment is sufficient
1980         if (msg.value < price) {
1981             revert InsufficientPayment();
1982         }
1983 
1984         uint8 devFee = 0;
1985         address deployedContract;
1986 
1987         if (contractType == ContractType.NoTaxToken) {
1988             deployedContract = address(new NoTaxToken(name, symbol, supply, maxWallet, maxTransaction));
1989         } else if (contractType == ContractType.TaxToken) {
1990             devFee = (plan == PaymentPlan.Tier1) ? devFeeTier1 : 
1991                     (plan == PaymentPlan.Tier2) ? devFeeTier2 : 
1992                     0;
1993             deployedContract = address(new TaxToken(name, symbol, supply, maxWallet, maxTransaction, devFee, buyTax, sellTax));
1994         } else {
1995             revert InvalidContractType();
1996         }
1997 
1998         // Handle payment and referral
1999         if (discount) {
2000             if (!EnumerableSet.contains(_referrers, referrer)) {
2001                 _referrers.add(referrer);
2002             }
2003 
2004             // calculate the ratio between referrer's balance and required balance
2005             referralPoints[referrer] += (referrerBalance / requiredDiscountTokenBalance);
2006 
2007             // distribute referral revenue sharing accordingly
2008             uint256 revShare = Math.mulDiv(msg.value, revenueShare, 100);
2009             (bool success, ) = payable(referrer).call{ value: revShare }("");
2010             if (!success) { revert TransferFailed(); }
2011             (success, ) = platformAddress.call{ value: msg.value - revShare }("");
2012             if (!success) { revert TransferFailed(); }
2013         } else {
2014             (bool success, ) = platformAddress.call{ value: msg.value }("");
2015             if (!success) { revert TransferFailed(); }
2016         }
2017 
2018         // Save the details of the deployed contract
2019         contractsByDeployer[msg.sender].push(DeployedContract({contractAddress: deployedContract, contractType: contractType}));
2020 
2021         return (deployedContract);
2022     }
2023 
2024     function getContractsByDeployer(address deployer) public view returns (DeployedContract[] memory) {
2025         DeployedContract[] memory details = contractsByDeployer[deployer];
2026         return details;
2027     }
2028 
2029     function getPoints(address user) public view returns (uint256) {
2030         return referralPoints[user];
2031     }
2032 
2033     function getReferrers() public view returns (address[] memory) {
2034         return EnumerableSet.values(_referrers);
2035     }
2036 }