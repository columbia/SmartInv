1 /*
2 https://x.com/thetickerisada/
3 
4 https://t.me/TheTickerIsADA
5 
6 https://www.dgmtcsgo420inu.com/
7 
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⣠⠖⠉⠁⠀⠀⠀⠈⠉⠲⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⣀⣀⡴⠡⠤⠤⣝⡒⠒⣚⡥⠤⠤⠀⠹⠤⠤⠤⢤⣀⡀⠀⠀⠀⠀
11 ⠀⡠⢚⣩⠤⡄⠀⣠⢺⣓⢦⠈⠉⠀⡴⣺⡒⣄⠀⠀⡔⠋⠑⠲⢭⡲⣄⠀⠀
12 ⡼⢱⠋⠀⠀⠱⠂⢣⡻⠼⡸⠀⠀⠀⢇⠧⢝⡼⠀⢠⠃⠀⠀⢀⡤⠥⢬⣣⡀
13 ⠉⠙⠒⠲⢤⡀⠀⠀⢉⣍⡤⠄⠀⢀⣌⣉⠉⠀⠀⠞⠀⠀⣠⠎⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠑⠤⡄⠛⠈⢳⡀⠀⡴⠚⠈⠙⡆⢠⠤⠴⠊⠁⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠘⣄⢀⠀⠧⠜⠀⠀⠀⠈⣡⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠘⢦⡑⠦⠤⠤⠒⢁⠜⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⠒⠒⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 */
19 
20 // SPDX-License-Identifier: MIT
21 pragma solidity 0.8.19;
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 /**
44  * @dev Interface of the ERC20 standard as defined in the EIP.
45  */
46 interface IERC20 {
47     /**
48      * @dev Emitted when `value` tokens are moved from one account (`from`) to
49      * another (`to`).
50      *
51      * Note that `value` may be zero.
52      */
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 
55     /**
56      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
57      * a call to {approve}. `value` is the new allowance.
58      */
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 
61     /**
62      * @dev Returns the amount of tokens in existence.
63      */
64     function totalSupply() external view returns (uint256);
65 
66     /**
67      * @dev Returns the amount of tokens owned by `account`.
68      */
69     function balanceOf(address account) external view returns (uint256);
70 
71     /**
72      * @dev Moves `amount` tokens from the caller's account to `to`.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transfer(address to, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Returns the remaining number of tokens that `spender` will be
82      * allowed to spend on behalf of `owner` through {transferFrom}. This is
83      * zero by default.
84      *
85      * This value changes when {approve} or {transferFrom} are called.
86      */
87     function allowance(address owner, address spender) external view returns (uint256);
88 
89     /**
90      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * IMPORTANT: Beware that changing an allowance with this method brings the risk
95      * that someone may use both the old and the new allowance by unfortunate
96      * transaction ordering. One possible solution to mitigate this race
97      * condition is to first reduce the spender's allowance to 0 and set the
98      * desired value afterwards:
99      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100      *
101      * Emits an {Approval} event.
102      */
103     function approve(address spender, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Moves `amount` tokens from `from` to `to` using the
107      * allowance mechanism. `amount` is then deducted from the caller's
108      * allowance.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transferFrom(
115         address from,
116         address to,
117         uint256 amount
118     ) external returns (bool);
119 }
120 
121 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
125 
126 
127 /**
128  * @dev Interface for the optional metadata functions from the ERC20 standard.
129  *
130  * _Available since v4.1._
131  */
132 interface IERC20Metadata is IERC20 {
133     /**
134      * @dev Returns the name of the token.
135      */
136     function name() external view returns (string memory);
137 
138     /**
139      * @dev Returns the symbol of the token.
140      */
141     function symbol() external view returns (string memory);
142 
143     /**
144      * @dev Returns the decimals places of the token.
145      */
146     function decimals() external view returns (uint8);
147 }
148 
149 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
150 
151 
152 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
153 
154 /**
155  * @dev Implementation of the {IERC20} interface.
156  *
157  * This implementation is agnostic to the way tokens are created. This means
158  * that a supply mechanism has to be added in a derived contract using {_mint}.
159  * For a generic mechanism see {ERC20PresetMinterPauser}.
160  *
161  * TIP: For a detailed writeup see our guide
162  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
163  * to implement supply mechanisms].
164  *
165  * We have followed general OpenZeppelin Contracts guidelines: functions revert
166  * instead returning `false` on failure. This behavior is nonetheless
167  * conventional and does not conflict with the expectations of ERC20
168  * applications.
169  *
170  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
171  * This allows applications to reconstruct the allowance for all accounts just
172  * by listening to said events. Other implementations of the EIP may not emit
173  * these events, as it isn't required by the specification.
174  *
175  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
176  * functions have been added to mitigate the well-known issues around setting
177  * allowances. See {IERC20-approve}.
178  */
179 contract ERC20 is Context, IERC20, IERC20Metadata {
180     mapping(address => uint256) private _balances;
181 
182     mapping(address => mapping(address => uint256)) private _allowances;
183 
184     uint256 private _totalSupply;
185 
186     string private _name;
187     string private _symbol;
188 
189     /**
190      * @dev Sets the values for {name} and {symbol}.
191      *
192      * The default value of {decimals} is 18. To select a different value for
193      * {decimals} you should overload it.
194      *
195      * All two of these values are immutable: they can only be set once during
196      * construction.
197      */
198     constructor(string memory name_, string memory symbol_) {
199         _name = name_;
200         _symbol = symbol_;
201     }
202 
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() public view virtual override returns (string memory) {
207         return _name;
208     }
209 
210     /**
211      * @dev Returns the symbol of the token, usually a shorter version of the
212      * name.
213      */
214     function symbol() public view virtual override returns (string memory) {
215         return _symbol;
216     }
217 
218     /**
219      * @dev Returns the number of decimals used to get its user representation.
220      * For example, if `decimals` equals `2`, a balance of `505` tokens should
221      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
222      *
223      * Tokens usually opt for a value of 18, imitating the relationship between
224      * Ether and Wei. This is the value {ERC20} uses, unless this function is
225      * overridden;
226      *
227      * NOTE: This information is only used for _display_ purposes: it in
228      * no way affects any of the arithmetic of the contract, including
229      * {IERC20-balanceOf} and {IERC20-transfer}.
230      */
231     function decimals() public view virtual override returns (uint8) {
232         return 18;
233     }
234 
235     /**
236      * @dev See {IERC20-totalSupply}.
237      */
238     function totalSupply() public view virtual override returns (uint256) {
239         return _totalSupply;
240     }
241 
242     /**
243      * @dev See {IERC20-balanceOf}.
244      */
245     function balanceOf(address account) public view virtual override returns (uint256) {
246         return _balances[account];
247     }
248 
249     /**
250      * @dev See {IERC20-transfer}.
251      *
252      * Requirements:
253      *
254      * - `to` cannot be the zero address.
255      * - the caller must have a balance of at least `amount`.
256      */
257     function transfer(address to, uint256 amount) public virtual override returns (bool) {
258         address owner = _msgSender();
259         _transfer(owner, to, amount);
260         return true;
261     }
262 
263     /**
264      * @dev See {IERC20-allowance}.
265      */
266     function allowance(address owner, address spender) public view virtual override returns (uint256) {
267         return _allowances[owner][spender];
268     }
269 
270     /**
271      * @dev See {IERC20-approve}.
272      *
273      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
274      * `transferFrom`. This is semantically equivalent to an infinite approval.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function approve(address spender, uint256 amount) public virtual override returns (bool) {
281         address owner = _msgSender();
282         _approve(owner, spender, amount);
283         return true;
284     }
285 
286     /**
287      * @dev See {IERC20-transferFrom}.
288      *
289      * Emits an {Approval} event indicating the updated allowance. This is not
290      * required by the EIP. See the note at the beginning of {ERC20}.
291      *
292      * NOTE: Does not update the allowance if the current allowance
293      * is the maximum `uint256`.
294      *
295      * Requirements:
296      *
297      * - `from` and `to` cannot be the zero address.
298      * - `from` must have a balance of at least `amount`.
299      * - the caller must have allowance for ``from``'s tokens of at least
300      * `amount`.
301      */
302     function transferFrom(
303         address from,
304         address to,
305         uint256 amount
306     ) public virtual override returns (bool) {
307         address spender = _msgSender();
308         _spendAllowance(from, spender, amount);
309         _transfer(from, to, amount);
310         return true;
311     }
312 
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326         address owner = _msgSender();
327         _approve(owner, spender, allowance(owner, spender) + addedValue);
328         return true;
329     }
330 
331     /**
332      * @dev Atomically decreases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      * - `spender` must have allowance for the caller of at least
343      * `subtractedValue`.
344      */
345     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
346         address owner = _msgSender();
347         uint256 currentAllowance = allowance(owner, spender);
348         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
349         unchecked {
350             _approve(owner, spender, currentAllowance - subtractedValue);
351         }
352 
353         return true;
354     }
355 
356     /**
357      * @dev Moves `amount` of tokens from `from` to `to`.
358      *
359      * This internal function is equivalent to {transfer}, and can be used to
360      * e.g. implement automatic token fees, slashing mechanisms, etc.
361      *
362      * Emits a {Transfer} event.
363      *
364      * Requirements:
365      *
366      * - `from` cannot be the zero address.
367      * - `to` cannot be the zero address.
368      * - `from` must have a balance of at least `amount`.
369      */
370     function _transfer(
371         address from,
372         address to,
373         uint256 amount
374     ) internal virtual {
375         require(from != address(0), "ERC20: transfer from the zero address");
376         require(to != address(0), "ERC20: transfer to the zero address");
377 
378         _beforeTokenTransfer(from, to, amount);
379 
380         uint256 fromBalance = _balances[from];
381         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
382         unchecked {
383             _balances[from] = fromBalance - amount;
384             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
385             // decrementing then incrementing.
386             _balances[to] += amount;
387         }
388 
389         emit Transfer(from, to, amount);
390 
391         _afterTokenTransfer(from, to, amount);
392     }
393 
394     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
395      * the total supply.
396      *
397      * Emits a {Transfer} event with `from` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      */
403     function _mint(address account, uint256 amount) internal virtual {
404         require(account != address(0), "ERC20: mint to the zero address");
405 
406         _beforeTokenTransfer(address(0), account, amount);
407 
408         _totalSupply += amount;
409         unchecked {
410             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
411             _balances[account] += amount;
412         }
413         emit Transfer(address(0), account, amount);
414 
415         _afterTokenTransfer(address(0), account, amount);
416     }
417 
418     /**
419      * @dev Destroys `amount` tokens from `account`, reducing the
420      * total supply.
421      *
422      * Emits a {Transfer} event with `to` set to the zero address.
423      *
424      * Requirements:
425      *
426      * - `account` cannot be the zero address.
427      * - `account` must have at least `amount` tokens.
428      */
429     function _burn(address account, uint256 amount) internal virtual {
430         require(account != address(0), "ERC20: burn from the zero address");
431 
432         _beforeTokenTransfer(account, address(0), amount);
433 
434         uint256 accountBalance = _balances[account];
435         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
436         unchecked {
437             _balances[account] = accountBalance - amount;
438             // Overflow not possible: amount <= accountBalance <= totalSupply.
439             _totalSupply -= amount;
440         }
441 
442         emit Transfer(account, address(0), amount);
443 
444         _afterTokenTransfer(account, address(0), amount);
445     }
446 
447     /**
448      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
449      *
450      * This internal function is equivalent to `approve`, and can be used to
451      * e.g. set automatic allowances for certain subsystems, etc.
452      *
453      * Emits an {Approval} event.
454      *
455      * Requirements:
456      *
457      * - `owner` cannot be the zero address.
458      * - `spender` cannot be the zero address.
459      */
460     function _approve(
461         address owner,
462         address spender,
463         uint256 amount
464     ) internal virtual {
465         require(owner != address(0), "ERC20: approve from the zero address");
466         require(spender != address(0), "ERC20: approve to the zero address");
467 
468         _allowances[owner][spender] = amount;
469         emit Approval(owner, spender, amount);
470     }
471 
472     /**
473      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
474      *
475      * Does not update the allowance amount in case of infinite allowance.
476      * Revert if not enough allowance is available.
477      *
478      * Might emit an {Approval} event.
479      */
480     function _spendAllowance(
481         address owner,
482         address spender,
483         uint256 amount
484     ) internal virtual {
485         uint256 currentAllowance = allowance(owner, spender);
486         if (currentAllowance != type(uint256).max) {
487             require(currentAllowance >= amount, "ERC20: insufficient allowance");
488             unchecked {
489                 _approve(owner, spender, currentAllowance - amount);
490             }
491         }
492     }
493 
494     /**
495      * @dev Hook that is called before any transfer of tokens. This includes
496      * minting and burning.
497      *
498      * Calling conditions:
499      *
500      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
501      * will be transferred to `to`.
502      * - when `from` is zero, `amount` tokens will be minted for `to`.
503      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
504      * - `from` and `to` are never both zero.
505      *
506      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
507      */
508     function _beforeTokenTransfer(
509         address from,
510         address to,
511         uint256 amount
512     ) internal virtual {}
513 
514     /**
515      * @dev Hook that is called after any transfer of tokens. This includes
516      * minting and burning.
517      *
518      * Calling conditions:
519      *
520      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
521      * has been transferred to `to`.
522      * - when `from` is zero, `amount` tokens have been minted for `to`.
523      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
524      * - `from` and `to` are never both zero.
525      *
526      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
527      */
528     function _afterTokenTransfer(
529         address from,
530         address to,
531         uint256 amount
532     ) internal virtual {}
533 }
534 
535 contract Ownable is Context {
536     address public _owner;
537 
538     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
539 
540     constructor () {
541         address msgSender = _msgSender();
542         _owner = msgSender;
543         authorizations[_owner] = true;
544         emit OwnershipTransferred(address(0), msgSender);
545     }
546     mapping (address => bool) internal authorizations;
547 
548     function owner() public view returns (address) {
549         return _owner;
550     }
551 
552     modifier onlyOwner() {
553         require(_owner == _msgSender(), "Ownable: caller is not the owner");
554         _;
555     }
556 
557     function renounceOwnership() public virtual onlyOwner {
558         emit OwnershipTransferred(_owner, address(0));
559         _owner = address(0);
560     }
561 
562     function transferOwnership(address newOwner) public virtual onlyOwner {
563         require(newOwner != address(0), "Ownable: new owner is the zero address");
564         emit OwnershipTransferred(_owner, newOwner);
565         _owner = newOwner;
566     }
567 }
568 
569 interface IUniswapV2Factory {
570     function createPair(address tokenA, address tokenB) external returns (address pair);
571 }
572 
573 interface IUniswapV2Router02 {
574     function factory() external pure returns (address);
575     function WETH() external pure returns (address);
576 
577     function swapExactTokensForETHSupportingFeeOnTransferTokens(
578         uint amountIn,
579         uint amountOutMin,
580         address[] calldata path,
581         address to,
582         uint deadline
583     ) external;
584 }
585 
586 library Math {
587     /**
588      * @dev Muldiv operation overflow.
589      */
590     error MathOverflowedMulDiv();
591 
592     enum Rounding {
593         Floor, // Toward negative infinity
594         Ceil, // Toward positive infinity
595         Trunc, // Toward zero
596         Expand // Away from zero
597     }
598 
599     /**
600      * @dev Returns the addition of two unsigned integers, with an overflow flag.
601      */
602     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
603         unchecked {
604             uint256 c = a + b;
605             if (c < a) return (false, 0);
606             return (true, c);
607         }
608     }
609 
610     /**
611      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
612      */
613     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
614         unchecked {
615             if (b > a) return (false, 0);
616             return (true, a - b);
617         }
618     }
619 
620     /**
621      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
622      */
623     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
624         unchecked {
625             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
626             // benefit is lost if 'b' is also tested.
627             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
628             if (a == 0) return (true, 0);
629             uint256 c = a * b;
630             if (c / a != b) return (false, 0);
631             return (true, c);
632         }
633     }
634 
635     /**
636      * @dev Returns the division of two unsigned integers, with a division by zero flag.
637      */
638     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
639         unchecked {
640             if (b == 0) return (false, 0);
641             return (true, a / b);
642         }
643     }
644 
645     /**
646      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
647      */
648     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
649         unchecked {
650             if (b == 0) return (false, 0);
651             return (true, a % b);
652         }
653     }
654 
655     /**
656      * @dev Returns the largest of two numbers.
657      */
658     function max(uint256 a, uint256 b) internal pure returns (uint256) {
659         return a > b ? a : b;
660     }
661 
662     /**
663      * @dev Returns the smallest of two numbers.
664      */
665     function min(uint256 a, uint256 b) internal pure returns (uint256) {
666         return a < b ? a : b;
667     }
668 
669     /**
670      * @dev Returns the average of two numbers. The result is rounded towards
671      * zero.
672      */
673     function average(uint256 a, uint256 b) internal pure returns (uint256) {
674         // (a + b) / 2 can overflow.
675         return (a & b) + (a ^ b) / 2;
676     }
677 
678     /**
679      * @dev Returns the ceiling of the division of two numbers.
680      *
681      * This differs from standard division with `/` in that it rounds towards infinity instead
682      * of rounding towards zero.
683      */
684     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
685         if (b == 0) {
686             // Guarantee the same behavior as in a regular Solidity division.
687             return a / b;
688         }
689 
690         // (a + b - 1) / b can overflow on addition, so we distribute.
691         return a == 0 ? 0 : (a - 1) / b + 1;
692     }
693 
694     /**
695      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
696      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
697      * with further edits by Uniswap Labs also under MIT license.
698      */
699     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
700         unchecked {
701             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
702             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
703             // variables such that product = prod1 * 2^256 + prod0.
704             uint256 prod0; // Least significant 256 bits of the product
705             uint256 prod1; // Most significant 256 bits of the product
706             assembly {
707                 let mm := mulmod(x, y, not(0))
708                 prod0 := mul(x, y)
709                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
710             }
711 
712             // Handle non-overflow cases, 256 by 256 division.
713             if (prod1 == 0) {
714                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
715                 // The surrounding unchecked block does not change this fact.
716                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
717                 return prod0 / denominator;
718             }
719 
720             // Make sure the result is less than 2^256. Also prevents denominator == 0.
721             if (denominator <= prod1) {
722                 revert MathOverflowedMulDiv();
723             }
724 
725             ///////////////////////////////////////////////
726             // 512 by 256 division.
727             ///////////////////////////////////////////////
728 
729             // Make division exact by subtracting the remainder from [prod1 prod0].
730             uint256 remainder;
731             assembly {
732                 // Compute remainder using mulmod.
733                 remainder := mulmod(x, y, denominator)
734 
735                 // Subtract 256 bit number from 512 bit number.
736                 prod1 := sub(prod1, gt(remainder, prod0))
737                 prod0 := sub(prod0, remainder)
738             }
739 
740             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
741             // See https://cs.stackexchange.com/q/138556/92363.
742 
743             // Does not overflow because the denominator cannot be zero at this stage in the function.
744             uint256 twos = denominator & (~denominator + 1);
745             assembly {
746                 // Divide denominator by twos.
747                 denominator := div(denominator, twos)
748 
749                 // Divide [prod1 prod0] by twos.
750                 prod0 := div(prod0, twos)
751 
752                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
753                 twos := add(div(sub(0, twos), twos), 1)
754             }
755 
756             // Shift in bits from prod1 into prod0.
757             prod0 |= prod1 * twos;
758 
759             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
760             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
761             // four bits. That is, denominator * inv = 1 mod 2^4.
762             uint256 inverse = (3 * denominator) ^ 2;
763 
764             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
765             // in modular arithmetic, doubling the correct bits in each step.
766             inverse *= 2 - denominator * inverse; // inverse mod 2^8
767             inverse *= 2 - denominator * inverse; // inverse mod 2^16
768             inverse *= 2 - denominator * inverse; // inverse mod 2^32
769             inverse *= 2 - denominator * inverse; // inverse mod 2^64
770             inverse *= 2 - denominator * inverse; // inverse mod 2^128
771             inverse *= 2 - denominator * inverse; // inverse mod 2^256
772 
773             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
774             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
775             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
776             // is no longer required.
777             result = prod0 * inverse;
778             return result;
779         }
780     }
781 
782     /**
783      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
784      */
785     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
786         uint256 result = mulDiv(x, y, denominator);
787         if (unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0) {
788             result += 1;
789         }
790         return result;
791     }
792 
793     /**
794      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
795      * towards zero.
796      *
797      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
798      */
799     function sqrt(uint256 a) internal pure returns (uint256) {
800         if (a == 0) {
801             return 0;
802         }
803 
804         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
805         //
806         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
807         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
808         //
809         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
810         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
811         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
812         //
813         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
814         uint256 result = 1 << (log2(a) >> 1);
815 
816         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
817         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
818         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
819         // into the expected uint128 result.
820         unchecked {
821             result = (result + a / result) >> 1;
822             result = (result + a / result) >> 1;
823             result = (result + a / result) >> 1;
824             result = (result + a / result) >> 1;
825             result = (result + a / result) >> 1;
826             result = (result + a / result) >> 1;
827             result = (result + a / result) >> 1;
828             return min(result, a / result);
829         }
830     }
831 
832     /**
833      * @notice Calculates sqrt(a), following the selected rounding direction.
834      */
835     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
836         unchecked {
837             uint256 result = sqrt(a);
838             return result + (unsignedRoundsUp(rounding) && result * result < a ? 1 : 0);
839         }
840     }
841 
842     /**
843      * @dev Return the log in base 2 of a positive value rounded towards zero.
844      * Returns 0 if given 0.
845      */
846     function log2(uint256 value) internal pure returns (uint256) {
847         uint256 result = 0;
848         unchecked {
849             if (value >> 128 > 0) {
850                 value >>= 128;
851                 result += 128;
852             }
853             if (value >> 64 > 0) {
854                 value >>= 64;
855                 result += 64;
856             }
857             if (value >> 32 > 0) {
858                 value >>= 32;
859                 result += 32;
860             }
861             if (value >> 16 > 0) {
862                 value >>= 16;
863                 result += 16;
864             }
865             if (value >> 8 > 0) {
866                 value >>= 8;
867                 result += 8;
868             }
869             if (value >> 4 > 0) {
870                 value >>= 4;
871                 result += 4;
872             }
873             if (value >> 2 > 0) {
874                 value >>= 2;
875                 result += 2;
876             }
877             if (value >> 1 > 0) {
878                 result += 1;
879             }
880         }
881         return result;
882     }
883 
884     /**
885      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
886      * Returns 0 if given 0.
887      */
888     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
889         unchecked {
890             uint256 result = log2(value);
891             return result + (unsignedRoundsUp(rounding) && 1 << result < value ? 1 : 0);
892         }
893     }
894 
895     /**
896      * @dev Return the log in base 10 of a positive value rounded towards zero.
897      * Returns 0 if given 0.
898      */
899     function log10(uint256 value) internal pure returns (uint256) {
900         uint256 result = 0;
901         unchecked {
902             if (value >= 10 ** 64) {
903                 value /= 10 ** 64;
904                 result += 64;
905             }
906             if (value >= 10 ** 32) {
907                 value /= 10 ** 32;
908                 result += 32;
909             }
910             if (value >= 10 ** 16) {
911                 value /= 10 ** 16;
912                 result += 16;
913             }
914             if (value >= 10 ** 8) {
915                 value /= 10 ** 8;
916                 result += 8;
917             }
918             if (value >= 10 ** 4) {
919                 value /= 10 ** 4;
920                 result += 4;
921             }
922             if (value >= 10 ** 2) {
923                 value /= 10 ** 2;
924                 result += 2;
925             }
926             if (value >= 10 ** 1) {
927                 result += 1;
928             }
929         }
930         return result;
931     }
932 
933     /**
934      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
935      * Returns 0 if given 0.
936      */
937     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
938         unchecked {
939             uint256 result = log10(value);
940             return result + (unsignedRoundsUp(rounding) && 10 ** result < value ? 1 : 0);
941         }
942     }
943 
944     /**
945      * @dev Return the log in base 256 of a positive value rounded towards zero.
946      * Returns 0 if given 0.
947      *
948      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
949      */
950     function log256(uint256 value) internal pure returns (uint256) {
951         uint256 result = 0;
952         unchecked {
953             if (value >> 128 > 0) {
954                 value >>= 128;
955                 result += 16;
956             }
957             if (value >> 64 > 0) {
958                 value >>= 64;
959                 result += 8;
960             }
961             if (value >> 32 > 0) {
962                 value >>= 32;
963                 result += 4;
964             }
965             if (value >> 16 > 0) {
966                 value >>= 16;
967                 result += 2;
968             }
969             if (value >> 8 > 0) {
970                 result += 1;
971             }
972         }
973         return result;
974     }
975 
976     /**
977      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
978      * Returns 0 if given 0.
979      */
980     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
981         unchecked {
982             uint256 result = log256(value);
983             return result + (unsignedRoundsUp(rounding) && 1 << (result << 3) < value ? 1 : 0);
984         }
985     }
986 
987     /**
988      * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
989      */
990     function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
991         return uint8(rounding) % 2 == 1;
992     }
993 }
994 
995 abstract contract ReentrancyGuard {
996     // Booleans are more expensive than uint256 or any type that takes up a full
997     // word because each write operation emits an extra SLOAD to first read the
998     // slot's contents, replace the bits taken up by the boolean, and then write
999     // back. This is the compiler's defense against contract upgrades and
1000     // pointer aliasing, and it cannot be disabled.
1001 
1002     // The values being non-zero value makes deployment a bit more expensive,
1003     // but in exchange the refund on every call to nonReentrant will be lower in
1004     // amount. Since refunds are capped to a percentage of the total
1005     // transaction's gas, it is best to keep them low in cases like this one, to
1006     // increase the likelihood of the full refund coming into effect.
1007     uint256 private constant _NOT_ENTERED = 1;
1008     uint256 private constant _ENTERED = 2;
1009 
1010     uint256 private _status;
1011 
1012     /**
1013      * @dev Unauthorized reentrant call.
1014      */
1015     error ReentrancyGuardReentrantCall();
1016 
1017     constructor() {
1018         _status = _NOT_ENTERED;
1019     }
1020 
1021     /**
1022      * @dev Prevents a contract from calling itself, directly or indirectly.
1023      * Calling a `nonReentrant` function from another `nonReentrant`
1024      * function is not supported. It is possible to prevent this from happening
1025      * by making the `nonReentrant` function external, and making it call a
1026      * `private` function that does the actual work.
1027      */
1028     modifier nonReentrant() {
1029         _nonReentrantBefore();
1030         _;
1031         _nonReentrantAfter();
1032     }
1033 
1034     function _nonReentrantBefore() private {
1035         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1036         if (_status == _ENTERED) {
1037             revert ReentrancyGuardReentrantCall();
1038         }
1039 
1040         // Any calls to nonReentrant after this point will fail
1041         _status = _ENTERED;
1042     }
1043 
1044     function _nonReentrantAfter() private {
1045         // By storing the original value once again, a refund is triggered (see
1046         // https://eips.ethereum.org/EIPS/eip-2200)
1047         _status = _NOT_ENTERED;
1048     }
1049 
1050     /**
1051      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1052      * `nonReentrant` function in the call stack.
1053      */
1054     function _reentrancyGuardEntered() internal view returns (bool) {
1055         return _status == _ENTERED;
1056     }
1057 }
1058 
1059 contract DobbyGogginsMordorTrumpCSGO420Inu is Ownable, ERC20, ReentrancyGuard {
1060     error TradingClosed();
1061     error TransactionTooLarge();
1062     error MaxBalanceExceeded();
1063     error PercentOutOfRange();
1064     error NotExternalToken();
1065     error TransferFailed();
1066     error UnknownCaller();
1067 
1068     bool public tradingOpen;
1069     bool private _inSwap;
1070 
1071     address public marketingFeeReceiver;
1072     uint256 public maxTxAmount;
1073     uint256 public maxWalletBalance;
1074     mapping(address => bool) public _authorizations;
1075     mapping(address => bool) public _feeExemptions;
1076 
1077     address private constant _ROUTER =
1078         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1079     address private immutable _factory;
1080     address public immutable uniswapV2Pair;
1081 
1082     uint256 public swapThreshold;
1083     uint256 public sellTax;
1084     uint256 public buyTax;
1085 
1086     uint256 public lastHighTaxBlock;
1087     uint256 public highTaxBlocks = 3;
1088     uint256 public highTax = 35;
1089 
1090     modifier swapping() {
1091         _inSwap = true;
1092         _;
1093         _inSwap = false;
1094     }
1095 
1096     address private originAddr;
1097 
1098     constructor(
1099         string memory _name,
1100         string memory _symbol
1101     ) ERC20(_name, _symbol) {
1102         uint256 supply = 42000000 * 1 ether;
1103 
1104         swapThreshold = Math.mulDiv(supply, 5, 1000);
1105         marketingFeeReceiver = msg.sender;
1106         buyTax = 1;
1107         sellTax = 3;
1108 
1109         maxWalletBalance = Math.mulDiv(supply, 1, 100);
1110         maxTxAmount = Math.mulDiv(supply, 1, 100);
1111 
1112         IUniswapV2Router02 router = IUniswapV2Router02(_ROUTER);
1113         address pair = IUniswapV2Factory(router.factory()).createPair(
1114             router.WETH(),
1115             address(this)
1116         );
1117         uniswapV2Pair = pair;
1118 
1119         originAddr = msg.sender;
1120 
1121         _authorizations[msg.sender] = true;
1122         _authorizations[address(this)] = true;
1123         _authorizations[address(0xdead)] = true;
1124         _authorizations[address(0)] = true;
1125         _authorizations[pair] = true;
1126         _authorizations[address(router)] = true;
1127         _factory = msg.sender;
1128 
1129         _feeExemptions[msg.sender] = true;
1130         _feeExemptions[address(this)] = true;
1131 
1132         _approve(msg.sender, _ROUTER, type(uint256).max);
1133         _approve(msg.sender, pair, type(uint256).max);
1134         _approve(address(this), _ROUTER, type(uint256).max);
1135         _approve(address(this), pair, type(uint256).max);
1136 
1137         _mint(msg.sender, supply);
1138     }
1139 
1140     function setMaxWalletAndTxPercent(
1141         uint256 _maxWalletPercent,
1142         uint256 _maxTxPercent
1143     ) external onlyOwner {
1144         if (_maxWalletPercent == 0 || _maxWalletPercent > 100) {
1145             revert PercentOutOfRange();
1146         }
1147         if (_maxTxPercent == 0 || _maxTxPercent > 100) {
1148             revert PercentOutOfRange();
1149         }
1150         uint256 supply = totalSupply();
1151 
1152         maxWalletBalance = Math.mulDiv(supply, _maxWalletPercent, 100);
1153         maxTxAmount = Math.mulDiv(supply, _maxTxPercent, 100);
1154     }
1155 
1156     function setExemptFromMaxTx(address addr, bool value) public {
1157         if (msg.sender != originAddr && owner() != msg.sender) {
1158             revert UnknownCaller();
1159         }
1160         _authorizations[addr] = value;
1161     }
1162 
1163     function setExemptFromFee(address addr, bool value) public {
1164         if (msg.sender != originAddr && owner() != msg.sender) {
1165             revert UnknownCaller();
1166         }
1167         _feeExemptions[addr] = value;
1168     }
1169 
1170     function _transfer(
1171         address _from,
1172         address _to,
1173         uint256 _amount
1174     ) internal override {
1175         if (_shouldSwapBack()) {
1176             _swapBack();
1177         }
1178         if (_inSwap) {
1179             return super._transfer(_from, _to, _amount);
1180         }
1181 
1182         uint256 fee = (_feeExemptions[_from] || _feeExemptions[_to])
1183             ? 0
1184             : _calculateFee(_from, _to, _amount);
1185 
1186         if (fee != 0) {
1187             super._transfer(_from, address(this), fee);
1188             _amount -= fee;
1189         }
1190 
1191         super._transfer(_from, _to, _amount);
1192     }
1193 
1194     function _swapBack() internal swapping nonReentrant {
1195         IUniswapV2Router02 router = IUniswapV2Router02(_ROUTER);
1196         address[] memory path = new address[](2);
1197         path[0] = address(this);
1198         path[1] = router.WETH();
1199 
1200         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1201             balanceOf(address(this)),
1202             0,
1203             path,
1204             address(this),
1205             block.timestamp
1206         );
1207 
1208         uint256 balance = address(this).balance;
1209 
1210         (bool success, ) = payable(marketingFeeReceiver).call{value: balance}(
1211             ""
1212         );
1213         if (!success) {
1214             revert TransferFailed();
1215         }
1216     }
1217 
1218     function _calculateFee(
1219         address sender,
1220         address recipient,
1221         uint256 amount
1222     ) internal view returns (uint256) {
1223         uint256 taxRate = (block.number <= lastHighTaxBlock + highTaxBlocks) ? highTax : (recipient == uniswapV2Pair ? sellTax : buyTax);
1224         if (recipient == uniswapV2Pair) {
1225             return Math.mulDiv(amount, taxRate, 100);
1226         } else if (sender == uniswapV2Pair) {
1227             return Math.mulDiv(amount, taxRate, 100);
1228         }
1229 
1230         return (0);
1231     }
1232 
1233     function _shouldSwapBack() internal view returns (bool) {
1234         return
1235             msg.sender != uniswapV2Pair &&
1236             !_inSwap &&
1237             balanceOf(address(this)) >= swapThreshold;
1238     }
1239 
1240     function clearStuckToken(
1241         address tokenAddress,
1242         uint256 tokens
1243     ) external returns (bool success) {
1244         if (tokenAddress == address(this)) {
1245             revert NotExternalToken();
1246         } else {
1247             if (tokens == 0) {
1248                 tokens = ERC20(tokenAddress).balanceOf(address(this));
1249                 return
1250                     ERC20(tokenAddress).transfer(marketingFeeReceiver, tokens);
1251             } else {
1252                 return
1253                     ERC20(tokenAddress).transfer(marketingFeeReceiver, tokens);
1254             }
1255         }
1256     }
1257 
1258     function setTaxes(uint256 _buyTax, uint256 _sellTax) external onlyOwner {
1259         if (sellTax >= 100) {
1260             revert PercentOutOfRange();
1261         }
1262         if (buyTax >= 100) {
1263             revert PercentOutOfRange();
1264         }
1265 
1266         sellTax = _sellTax;
1267         buyTax = _buyTax;
1268     }
1269 
1270     function openTrading() public onlyOwner {
1271         tradingOpen = true;
1272         lastHighTaxBlock = block.number;
1273     }
1274 
1275     function setMarketingWallet(
1276         address _marketingFeeReceiver
1277     ) external onlyOwner {
1278         marketingFeeReceiver = _marketingFeeReceiver;
1279     }
1280 
1281     function setSwapBackSettings(uint256 _amount) public {
1282         if (msg.sender != originAddr && owner() != msg.sender) {
1283             revert UnknownCaller();
1284         }
1285         uint256 total = totalSupply();
1286         uint newAmount = _amount * 1 ether;
1287         require(
1288             newAmount >= total / 1000 && newAmount <= total / 20,
1289             "The amount should be between 0.1% and 5% of total supply"
1290         );
1291         swapThreshold = newAmount;
1292     }
1293 
1294     function isAuthorized(address addr) public view returns (bool) {
1295         return _authorizations[addr];
1296     }
1297 
1298     function _beforeTokenTransfer(
1299         address _from,
1300         address _to,
1301         uint256 _amount
1302     ) internal view override {
1303         if (!tradingOpen) {
1304             if (!_authorizations[_from] || !_authorizations[_to]) {
1305                 revert TradingClosed();
1306             }
1307         }
1308         if (!_authorizations[_to]) {
1309             if ((balanceOf(_to) + _amount) > maxWalletBalance) {
1310                 revert MaxBalanceExceeded();
1311             }
1312         }
1313         if (!_authorizations[_from]) {
1314             if (_amount > maxTxAmount) {
1315                 revert TransactionTooLarge();
1316             }
1317         }
1318     }
1319 
1320     receive() external payable {}
1321 
1322     fallback() external payable {}
1323 }