1 pragma solidity ^0.8.0;
2 /*
3 Twitter: 
4 twitter.com/boomer_coin_eth
5 
6 Tg:
7 t.me/boomer_coin_eth
8 */
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Emitted when `value` tokens are moved from one account (`from`) to
16      * another (`to`).
17      *
18      * Note that `value` may be zero.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /**
23      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
24      * a call to {approve}. `value` is the new allowance.
25      */
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https:
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `from` to `to` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) external returns (bool);
86 }
87 
88 
89 
90 
91 
92 
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Interface for the optional metadata functions from the ERC20 standard.
98  *
99  * _Available since v4.1._
100  */
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 
119 
120 
121 
122 
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 
147 
148 
149 
150 
151 
152 pragma solidity ^0.8.0;
153 
154 
155 
156 /**
157  * @dev Implementation of the {IERC20} interface.
158  *
159  * This implementation is agnostic to the way tokens are created. This means
160  * that a supply mechanism has to be added in a derived contract using {_mint}.
161  * For a generic mechanism see {ERC20PresetMinterPauser}.
162  *
163  * TIP: For a detailed writeup see our guide
164  * https:
165  * to implement supply mechanisms].
166  *
167  * We have followed general OpenZeppelin Contracts guidelines: functions revert
168  * instead returning `false` on failure. This behavior is nonetheless
169  * conventional and does not conflict with the expectations of ERC20
170  * applications.
171  *
172  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
173  * This allows applications to reconstruct the allowance for all accounts just
174  * by listening to said events. Other implementations of the EIP may not emit
175  * these events, as it isn't required by the specification.
176  *
177  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
178  * functions have been added to mitigate the well-known issues around setting
179  * allowances. See {IERC20-approve}.
180  */
181 contract ERC20 is Context, IERC20, IERC20Metadata {
182     mapping(address => uint256) private _balances;
183 
184     mapping(address => mapping(address => uint256)) private _allowances;
185 
186     uint256 private _totalSupply;
187 
188     string private _name;
189     string private _symbol;
190 
191     /**
192      * @dev Sets the values for {name} and {symbol}.
193      *
194      * The default value of {decimals} is 18. To select a different value for
195      * {decimals} you should overload it.
196      *
197      * All two of these values are immutable: they can only be set once during
198      * construction.
199      */
200     constructor(string memory name_, string memory symbol_) {
201         _name = name_;
202         _symbol = symbol_;
203     }
204 
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() public view virtual override returns (string memory) {
209         return _name;
210     }
211 
212     /**
213      * @dev Returns the symbol of the token, usually a shorter version of the
214      * name.
215      */
216     function symbol() public view virtual override returns (string memory) {
217         return _symbol;
218     }
219 
220     /**
221      * @dev Returns the number of decimals used to get its user representation.
222      * For example, if `decimals` equals `2`, a balance of `505` tokens should
223      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
224      *
225      * Tokens usually opt for a value of 18, imitating the relationship between
226      * Ether and Wei. This is the value {ERC20} uses, unless this function is
227      * overridden;
228      *
229      * NOTE: This information is only used for _display_ purposes: it in
230      * no way affects any of the arithmetic of the contract, including
231      * {IERC20-balanceOf} and {IERC20-transfer}.
232      */
233     function decimals() public view virtual override returns (uint8) {
234         return 18;
235     }
236 
237     /**
238      * @dev See {IERC20-totalSupply}.
239      */
240     function totalSupply() public view virtual override returns (uint256) {
241         return _totalSupply;
242     }
243 
244     /**
245      * @dev See {IERC20-balanceOf}.
246      */
247     function balanceOf(address account) public view virtual override returns (uint256) {
248         return _balances[account];
249     }
250 
251     /**
252      * @dev See {IERC20-transfer}.
253      *
254      * Requirements:
255      *
256      * - `to` cannot be the zero address.
257      * - the caller must have a balance of at least `amount`.
258      */
259     function transfer(address to, uint256 amount) public virtual override returns (bool) {
260         address owner = _msgSender();
261         _transfer(owner, to, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-allowance}.
267      */
268     function allowance(address owner, address spender) public view virtual override returns (uint256) {
269         return _allowances[owner][spender];
270     }
271 
272     /**
273      * @dev See {IERC20-approve}.
274      *
275      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
276      * `transferFrom`. This is semantically equivalent to an infinite approval.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function approve(address spender, uint256 amount) public virtual override returns (bool) {
283         address owner = _msgSender();
284         _approve(owner, spender, amount);
285         return true;
286     }
287 
288     /**
289      * @dev See {IERC20-transferFrom}.
290      *
291      * Emits an {Approval} event indicating the updated allowance. This is not
292      * required by the EIP. See the note at the beginning of {ERC20}.
293      *
294      * NOTE: Does not update the allowance if the current allowance
295      * is the maximum `uint256`.
296      *
297      * Requirements:
298      *
299      * - `from` and `to` cannot be the zero address.
300      * - `from` must have a balance of at least `amount`.
301      * - the caller must have allowance for ``from``'s tokens of at least
302      * `amount`.
303      */
304     function transferFrom(
305         address from,
306         address to,
307         uint256 amount
308     ) public virtual override returns (bool) {
309         address spender = _msgSender();
310         _spendAllowance(from, spender, amount);
311         _transfer(from, to, amount);
312         return true;
313     }
314 
315     /**
316      * @dev Atomically increases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
328         address owner = _msgSender();
329         _approve(owner, spender, allowance(owner, spender) + addedValue);
330         return true;
331     }
332 
333     /**
334      * @dev Atomically decreases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      * - `spender` must have allowance for the caller of at least
345      * `subtractedValue`.
346      */
347     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
348         address owner = _msgSender();
349         uint256 currentAllowance = allowance(owner, spender);
350         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
351         unchecked {
352             _approve(owner, spender, currentAllowance - subtractedValue);
353         }
354 
355         return true;
356     }
357 
358     /**
359      * @dev Moves `amount` of tokens from `from` to `to`.
360      *
361      * This internal function is equivalent to {transfer}, and can be used to
362      * e.g. implement automatic token fees, slashing mechanisms, etc.
363      *
364      * Emits a {Transfer} event.
365      *
366      * Requirements:
367      *
368      * - `from` cannot be the zero address.
369      * - `to` cannot be the zero address.
370      * - `from` must have a balance of at least `amount`.
371      */
372     function _transfer(
373         address from,
374         address to,
375         uint256 amount
376     ) internal virtual {
377         require(from != address(0), "ERC20: transfer from the zero address");
378         require(to != address(0), "ERC20: transfer to the zero address");
379 
380         _beforeTokenTransfer(from, to, amount);
381 
382         uint256 fromBalance = _balances[from];
383         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
384         unchecked {
385             _balances[from] = fromBalance - amount;
386         }
387         _balances[to] += amount;
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
409         _balances[account] += amount;
410         emit Transfer(address(0), account, amount);
411 
412         _afterTokenTransfer(address(0), account, amount);
413     }
414 
415     /**
416      * @dev Destroys `amount` tokens from `account`, reducing the
417      * total supply.
418      *
419      * Emits a {Transfer} event with `to` set to the zero address.
420      *
421      * Requirements:
422      *
423      * - `account` cannot be the zero address.
424      * - `account` must have at least `amount` tokens.
425      */
426     function _burn(address account, uint256 amount) internal virtual {
427         require(account != address(0), "ERC20: burn from the zero address");
428 
429         _beforeTokenTransfer(account, address(0), amount);
430 
431         uint256 accountBalance = _balances[account];
432         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
433         unchecked {
434             _balances[account] = accountBalance - amount;
435         }
436         _totalSupply -= amount;
437 
438         emit Transfer(account, address(0), amount);
439 
440         _afterTokenTransfer(account, address(0), amount);
441     }
442 
443     /**
444      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
445      *
446      * This internal function is equivalent to `approve`, and can be used to
447      * e.g. set automatic allowances for certain subsystems, etc.
448      *
449      * Emits an {Approval} event.
450      *
451      * Requirements:
452      *
453      * - `owner` cannot be the zero address.
454      * - `spender` cannot be the zero address.
455      */
456     function _approve(
457         address owner,
458         address spender,
459         uint256 amount
460     ) internal virtual {
461         require(owner != address(0), "ERC20: approve from the zero address");
462         require(spender != address(0), "ERC20: approve to the zero address");
463 
464         _allowances[owner][spender] = amount;
465         emit Approval(owner, spender, amount);
466     }
467 
468     /**
469      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
470      *
471      * Does not update the allowance amount in case of infinite allowance.
472      * Revert if not enough allowance is available.
473      *
474      * Might emit an {Approval} event.
475      */
476     function _spendAllowance(
477         address owner,
478         address spender,
479         uint256 amount
480     ) internal virtual {
481         uint256 currentAllowance = allowance(owner, spender);
482         if (currentAllowance != type(uint256).max) {
483             require(currentAllowance >= amount, "ERC20: insufficient allowance");
484             unchecked {
485                 _approve(owner, spender, currentAllowance - amount);
486             }
487         }
488     }
489 
490     /**
491      * @dev Hook that is called before any transfer of tokens. This includes
492      * minting and burning.
493      *
494      * Calling conditions:
495      *
496      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
497      * will be transferred to `to`.
498      * - when `from` is zero, `amount` tokens will be minted for `to`.
499      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
500      * - `from` and `to` are never both zero.
501      *
502      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
503      */
504     function _beforeTokenTransfer(
505         address from,
506         address to,
507         uint256 amount
508     ) internal virtual {}
509 
510     /**
511      * @dev Hook that is called after any transfer of tokens. This includes
512      * minting and burning.
513      *
514      * Calling conditions:
515      *
516      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
517      * has been transferred to `to`.
518      * - when `from` is zero, `amount` tokens have been minted for `to`.
519      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
520      * - `from` and `to` are never both zero.
521      *
522      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
523      */
524     function _afterTokenTransfer(
525         address from,
526         address to,
527         uint256 amount
528     ) internal virtual {}
529 }
530 
531 
532 
533 
534 
535 
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Extension of {ERC20} that allows token holders to destroy both their own
542  * tokens and those that they have an allowance for, in a way that can be
543  * recognized off-chain (via event analysis).
544  */
545 abstract contract ERC20Burnable is Context, ERC20 {
546     /**
547      * @dev Destroys `amount` tokens from the caller.
548      *
549      * See {ERC20-_burn}.
550      */
551     function burn(uint256 amount) public virtual {
552         _burn(_msgSender(), amount);
553     }
554 
555     /**
556      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
557      * allowance.
558      *
559      * See {ERC20-_burn} and {ERC20-allowance}.
560      *
561      * Requirements:
562      *
563      * - the caller must have allowance for ``accounts``'s tokens of at least
564      * `amount`.
565      */
566     function burnFrom(address account, uint256 amount) public virtual {
567         _spendAllowance(account, _msgSender(), amount);
568         _burn(account, amount);
569     }
570 }
571 
572 
573 
574 
575 
576 
577 
578 pragma solidity ^0.8.0;
579 
580 
581 
582 
583 
584 
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @dev Contract module which provides a basic access control mechanism, where
590  * there is an account (an owner) that can be granted exclusive access to
591  * specific functions.
592  *
593  * By default, the owner account will be the one that deploys the contract. This
594  * can later be changed with {transferOwnership}.
595  *
596  * This module is used through inheritance. It will make available the modifier
597  * `onlyOwner`, which can be applied to your functions to restrict their use to
598  * the owner.
599  */
600 abstract contract Ownable is Context {
601     address private _owner;
602 
603     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
604 
605     /**
606      * @dev Initializes the contract setting the deployer as the initial owner.
607      */
608     constructor() {
609         _transferOwnership(_msgSender());
610     }
611 
612     /**
613      * @dev Throws if called by any account other than the owner.
614      */
615     modifier onlyOwner() {
616         _checkOwner();
617         _;
618     }
619 
620     /**
621      * @dev Returns the address of the current owner.
622      */
623     function owner() public view virtual returns (address) {
624         return _owner;
625     }
626 
627     /**
628      * @dev Throws if the sender is not the owner.
629      */
630     function _checkOwner() internal view virtual {
631         require(owner() == _msgSender(), "Ownable: caller is not the owner");
632     }
633 
634     /**
635      * @dev Leaves the contract without owner. It will not be possible to call
636      * `onlyOwner` functions anymore. Can only be called by the current owner.
637      *
638      * NOTE: Renouncing ownership will leave the contract without an owner,
639      * thereby removing any functionality that is only available to the owner.
640      */
641     function renounceOwnership() public virtual onlyOwner {
642         _transferOwnership(address(0));
643     }
644 
645     /**
646      * @dev Transfers ownership of the contract to a new account (`newOwner`).
647      * Can only be called by the current owner.
648      */
649     function transferOwnership(address newOwner) public virtual onlyOwner {
650         require(newOwner != address(0), "Ownable: new owner is the zero address");
651         _transferOwnership(newOwner);
652     }
653 
654     /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      * Internal function without access restriction.
657      */
658     function _transferOwnership(address newOwner) internal virtual {
659         address oldOwner = _owner;
660         _owner = newOwner;
661         emit OwnershipTransferred(oldOwner, newOwner);
662     }
663 }
664 
665 
666 
667 
668 interface IUniswapV2Factory {
669     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
670 
671     function feeTo() external view returns (address);
672     function feeToSetter() external view returns (address);
673 
674     function getPair(address tokenA, address tokenB) external view returns (address pair);
675     function allPairs(uint) external view returns (address pair);
676     function allPairsLength() external view returns (uint);
677 
678     function createPair(address tokenA, address tokenB) external returns (address pair);
679 
680     function setFeeTo(address) external;
681     function setFeeToSetter(address) external;
682 }
683 
684 interface IUniswapV2Pair {
685     event Approval(address indexed owner, address indexed spender, uint value);
686     event Transfer(address indexed from, address indexed to, uint value);
687 
688     function name() external pure returns (string memory);
689     function symbol() external pure returns (string memory);
690     function decimals() external pure returns (uint8);
691     function totalSupply() external view returns (uint);
692     function balanceOf(address owner) external view returns (uint);
693     function allowance(address owner, address spender) external view returns (uint);
694 
695     function approve(address spender, uint value) external returns (bool);
696     function transfer(address to, uint value) external returns (bool);
697     function transferFrom(address from, address to, uint value) external returns (bool);
698 
699     function DOMAIN_SEPARATOR() external view returns (bytes32);
700     function PERMIT_TYPEHASH() external pure returns (bytes32);
701     function nonces(address owner) external view returns (uint);
702 
703     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
704 
705     event Mint(address indexed sender, uint amount0, uint amount1);
706     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
707     event Swap(
708         address indexed sender,
709         uint amount0In,
710         uint amount1In,
711         uint amount0Out,
712         uint amount1Out,
713         address indexed to
714     );
715     event Sync(uint112 reserve0, uint112 reserve1);
716 
717     function MINIMUM_LIQUIDITY() external pure returns (uint);
718     function factory() external view returns (address);
719     function token0() external view returns (address);
720     function token1() external view returns (address);
721     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
722     function price0CumulativeLast() external view returns (uint);
723     function price1CumulativeLast() external view returns (uint);
724     function kLast() external view returns (uint);
725 
726     function mint(address to) external returns (uint liquidity);
727     function burn(address to) external returns (uint amount0, uint amount1);
728     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
729     function skim(address to) external;
730     function sync() external;
731 
732     function initialize(address, address) external;
733 }
734 
735 interface IUniswapV2Router01 {
736     function factory() external pure returns (address);
737     function WETH() external pure returns (address);
738 
739     function addLiquidity(
740         address tokenA,
741         address tokenB,
742         uint amountADesired,
743         uint amountBDesired,
744         uint amountAMin,
745         uint amountBMin,
746         address to,
747         uint deadline
748     ) external returns (uint amountA, uint amountB, uint liquidity);
749     function addLiquidityETH(
750         address token,
751         uint amountTokenDesired,
752         uint amountTokenMin,
753         uint amountETHMin,
754         address to,
755         uint deadline
756     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
757     function removeLiquidity(
758         address tokenA,
759         address tokenB,
760         uint liquidity,
761         uint amountAMin,
762         uint amountBMin,
763         address to,
764         uint deadline
765     ) external returns (uint amountA, uint amountB);
766     function removeLiquidityETH(
767         address token,
768         uint liquidity,
769         uint amountTokenMin,
770         uint amountETHMin,
771         address to,
772         uint deadline
773     ) external returns (uint amountToken, uint amountETH);
774     function removeLiquidityWithPermit(
775         address tokenA,
776         address tokenB,
777         uint liquidity,
778         uint amountAMin,
779         uint amountBMin,
780         address to,
781         uint deadline,
782         bool approveMax, uint8 v, bytes32 r, bytes32 s
783     ) external returns (uint amountA, uint amountB);
784     function removeLiquidityETHWithPermit(
785         address token,
786         uint liquidity,
787         uint amountTokenMin,
788         uint amountETHMin,
789         address to,
790         uint deadline,
791         bool approveMax, uint8 v, bytes32 r, bytes32 s
792     ) external returns (uint amountToken, uint amountETH);
793     function swapExactTokensForTokens(
794         uint amountIn,
795         uint amountOutMin,
796         address[] calldata path,
797         address to,
798         uint deadline
799     ) external returns (uint[] memory amounts);
800     function swapTokensForExactTokens(
801         uint amountOut,
802         uint amountInMax,
803         address[] calldata path,
804         address to,
805         uint deadline
806     ) external returns (uint[] memory amounts);
807     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
808     external
809     payable
810     returns (uint[] memory amounts);
811     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
812     external
813     returns (uint[] memory amounts);
814     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
815     external
816     returns (uint[] memory amounts);
817     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
818     external
819     payable
820     returns (uint[] memory amounts);
821 
822     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
823     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
824     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
825     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
826     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
827 }
828 
829 interface IUniswapV2Router02 is IUniswapV2Router01{
830     function removeLiquidityETHSupportingFeeOnTransferTokens(
831         address token,
832         uint liquidity,
833         uint amountTokenMin,
834         uint amountETHMin,
835         address to,
836         uint deadline
837     ) external returns (uint amountETH);
838     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
839         address token,
840         uint liquidity,
841         uint amountTokenMin,
842         uint amountETHMin,
843         address to,
844         uint deadline,
845         bool approveMax, uint8 v, bytes32 r, bytes32 s
846     ) external returns (uint amountETH);
847 
848     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
849         uint amountIn,
850         uint amountOutMin,
851         address[] calldata path,
852         address to,
853         uint deadline
854     ) external;
855     function swapExactETHForTokensSupportingFeeOnTransferTokens(
856         uint amountOutMin,
857         address[] calldata path,
858         address to,
859         uint deadline
860     ) external payable;
861     function swapExactTokensForETHSupportingFeeOnTransferTokens(
862         uint amountIn,
863         uint amountOutMin,
864         address[] calldata path,
865         address to,
866         uint deadline
867     ) external;
868 }
869 
870 interface IWETH {
871     function deposit() external payable;
872     function transfer(address to, uint value) external returns (bool);
873     function withdraw(uint) external;
874 }
875 
876 
877 interface IUniswapV2ERC20 {
878     event Approval(address indexed owner, address indexed spender, uint value);
879     event Transfer(address indexed from, address indexed to, uint value);
880 
881     function name() external pure returns (string memory);
882     function symbol() external pure returns (string memory);
883     function decimals() external pure returns (uint8);
884     function totalSupply() external view returns (uint);
885     function balanceOf(address owner) external view returns (uint);
886     function allowance(address owner, address spender) external view returns (uint);
887 
888     function approve(address spender, uint value) external returns (bool);
889     function transfer(address to, uint value) external returns (bool);
890     function transferFrom(address from, address to, uint value) external returns (bool);
891 
892     function DOMAIN_SEPARATOR() external view returns (bytes32);
893     function PERMIT_TYPEHASH() external pure returns (bytes32);
894     function nonces(address owner) external view returns (uint);
895 
896     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
897 }
898 
899 
900 
901 
902 
903 
904 pragma solidity ^0.8.15;
905 
906 
907 
908 
909 contract Boomer is ERC20Burnable, Ownable {
910     uint256 private constant TOTAL_SUPPLY = 100_000_000_000e18;
911     address public marketingWallet;
912     uint256 public maxPercentToSwap = 5;
913     IUniswapV2Router02 public uniswapV2Router;
914     address public  uniswapV2Pair;
915 
916     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
917     address private constant ZERO = 0x0000000000000000000000000000000000000000;
918 
919     bool private swapping;
920     uint256 public swapTokensAtAmount;
921     bool public isTEnabled;
922 
923     mapping(address => bool) private _isExcludedFromFees;
924     mapping(address => bool) public automatedMarketMakerPairs;
925 
926     event ExcludeFromFees(address indexed account);
927     event FeesUpdated(uint256 sellFee, uint256 buyFee);
928     event MarketingWalletChanged(address marketingWallet);
929     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
930     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
931     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
932 
933     uint256 public sellFee;
934     uint256 public buyFee;
935 
936     
937     bool public isBotProtectionDisabledPermanently;
938     uint256 public maxTxAmount;
939     uint256 public maxHolding;
940     bool public buyCooldownEnabled = true;
941     uint256 public buyCooldown = 30;
942     mapping(address => bool) public isExempt;
943     mapping(address => uint256) public lastBuy;
944 
945     constructor (address router, address operator) ERC20("Boomer Coin", "BOOMER")
946     {
947         _mint(owner(), TOTAL_SUPPLY);
948 
949         swapTokensAtAmount = TOTAL_SUPPLY / 1000;
950         maxHolding = TOTAL_SUPPLY / 100;
951         maxTxAmount = TOTAL_SUPPLY / 100;
952         marketingWallet = operator;
953         sellFee = 90;
954         buyFee = 5;
955 
956         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
957         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
958         .createPair(address(this), _uniswapV2Router.WETH());
959 
960         uniswapV2Router = _uniswapV2Router;
961         uniswapV2Pair = _uniswapV2Pair;
962 
963         _approve(address(this), address(uniswapV2Router), type(uint256).max);
964 
965         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
966 
967         _isExcludedFromFees[owner()] = true;
968         _isExcludedFromFees[DEAD] = true;
969         _isExcludedFromFees[address(this)] = true;
970         _isExcludedFromFees[address(uniswapV2Router)] = true;
971 
972         
973         isExempt[address(uniswapV2Router)] = true;
974         isExempt[owner()] = true;
975     }
976 
977     receive() external payable {
978     }
979 
980     function openP() public onlyOwner {
981         require(isTEnabled == false, "Trading is already open!");
982         isTEnabled = true;
983     }
984 
985     function claimStuckTokens(address token) external onlyOwner {
986         require(token != address(this), "Owner cannot claim native tokens");
987         if (token == address(0x0)) {
988             payable(msg.sender).transfer(address(this).balance);
989             return;
990         }
991         IERC20 ERC20token = IERC20(token);
992         uint256 balance = ERC20token.balanceOf(address(this));
993         ERC20token.transfer(msg.sender, balance);
994     }
995 
996     function sendETH(address payable recipient, uint256 amount) internal {
997         recipient.call{gas : 2300, value : amount}("");
998     }
999 
1000     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1001         require(pair != uniswapV2Pair, "The Uniswap pair cannot be removed from automatedMarketMakerPairs");
1002 
1003         _setAutomatedMarketMakerPair(pair, value);
1004     }
1005 
1006     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1007         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
1008         automatedMarketMakerPairs[pair] = value;
1009 
1010         emit SetAutomatedMarketMakerPair(pair, value);
1011     }
1012 
1013     
1014     function excludeFromFees(address account) external onlyOwner {
1015         require(!_isExcludedFromFees[account], "Account is already the value of true");
1016         _isExcludedFromFees[account] = true;
1017 
1018         emit ExcludeFromFees(account);
1019     }
1020 
1021     function includeInFees(address account) external onlyOwner {
1022         require(_isExcludedFromFees[account], "Account already included");
1023         _isExcludedFromFees[account] = false;
1024     }
1025 
1026     function isExcludedFromFees(address account) public view returns (bool) {
1027         return _isExcludedFromFees[account];
1028     }
1029 
1030     function updateFees(uint256 _sellFee, uint256 _buyFee) external onlyOwner {
1031         require(_sellFee <= 18, "Fees must be less than 10%");
1032         require(_buyFee <= 18, "Fees must be less than 10%");
1033         sellFee = _sellFee;
1034         buyFee = _buyFee;
1035 
1036         emit FeesUpdated(sellFee, buyFee);
1037     }
1038 
1039     function changeMarketingWallet(address _marketingWallet) external onlyOwner {
1040         require(_marketingWallet != marketingWallet, "same wallet");
1041         marketingWallet = _marketingWallet;
1042         emit MarketingWalletChanged(marketingWallet);
1043     }
1044 
1045     function _transfer(
1046         address from,
1047         address to,
1048         uint256 amount
1049     ) internal override {
1050         require(from != address(0), "ERC20: transfer from the zero address");
1051         require(to != address(0), "ERC20: transfer to the zero address");
1052 
1053         if (!swapping) {
1054             _check(from, to, amount);
1055         }
1056 
1057         uint _buyFee = buyFee;
1058         uint _sellFee = sellFee;
1059 
1060         if (!isExempt[from] && !isExempt[to]) {
1061             require(isTEnabled, "Trade is not open");
1062         }
1063 
1064         if (amount == 0) {
1065             return;
1066         }
1067 
1068         bool takeFee = !swapping;
1069 
1070         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1071             takeFee = false;
1072         }
1073 
1074         uint256 toSwap = balanceOf(address(this));
1075 
1076         bool canSwap = toSwap >= swapTokensAtAmount && toSwap > 0 && !automatedMarketMakerPairs[from] && takeFee;
1077         if (canSwap &&
1078             !swapping) {
1079             swapping = true;
1080             uint256 pairBalance = balanceOf(uniswapV2Pair);
1081             if (toSwap > pairBalance * maxPercentToSwap / 100) {
1082                 toSwap = pairBalance * maxPercentToSwap / 100;
1083             }
1084             swapAndSendMarketing(toSwap);
1085             swapping = false;
1086         }
1087 
1088         if (takeFee && to == uniswapV2Pair && _sellFee > 0) {
1089             uint256 fees = (amount * _sellFee) / 100;
1090             amount = amount - fees;
1091 
1092             super._transfer(from, address(this), fees);
1093         }
1094         else if (takeFee && from == uniswapV2Pair && _buyFee > 0) {
1095             uint256 fees = (amount * _buyFee) / 100;
1096             amount = amount - fees;
1097 
1098             super._transfer(from, address(this), fees);
1099         }
1100 
1101         super._transfer(from, to, amount);
1102     }
1103 
1104     
1105     function swapAndSendMarketing(uint256 tokenAmount) private {
1106 
1107         address[] memory path = new address[](2);
1108         path[0] = address(this);
1109         path[1] = uniswapV2Router.WETH();
1110 
1111         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1112             tokenAmount,
1113             0, 
1114             path,
1115             address(this),
1116             block.timestamp) {}
1117         catch {
1118         }
1119 
1120         uint256 newBalance = address(this).balance;
1121         sendETH(payable(marketingWallet), newBalance);
1122 
1123         emit SwapAndSendMarketing(tokenAmount, newBalance);
1124     }
1125 
1126     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
1127         require(newAmount > 0);
1128         swapTokensAtAmount = newAmount;
1129     }
1130 
1131     function setMaxPercentToSwap(uint256 newAmount) external onlyOwner {
1132         require(newAmount > 1, "too low");
1133         require(newAmount <= 10, "too high");
1134         maxPercentToSwap = newAmount;
1135     }
1136 
1137     function _check(
1138         address from,
1139         address to,
1140         uint256 amount
1141     ) internal {
1142         
1143         if (!isBotProtectionDisabledPermanently) {
1144             
1145             if (!isSpecialAddresses(from, to) && !isExempt[to]) {
1146 
1147                 _checkBuyCooldown(from, to);
1148                 _checkMaxTxAmount(to, amount);
1149                 
1150                 _checkMaxHoldingLimit(to, amount);
1151             }
1152         }
1153 
1154     }
1155 
1156     function _checkBuyCooldown(address from, address to) internal {
1157         if (buyCooldownEnabled && from == uniswapV2Pair) {
1158             require(block.timestamp - lastBuy[tx.origin] >= buyCooldown, "buy cooldown");
1159             lastBuy[tx.origin] = block.timestamp;
1160         }
1161 
1162     }
1163 
1164     function _checkMaxTxAmount(address to, uint256 amount) internal view {
1165         require(amount <= maxTxAmount, "Amount exceeds max");
1166 
1167     }
1168 
1169     function _checkMaxHoldingLimit(address to, uint256 amount) internal view {
1170         if (to == uniswapV2Pair) {
1171             return;
1172         }
1173 
1174         require(balanceOf(to) + amount <= maxHolding, "Max holding exceeded max");
1175 
1176     }
1177 
1178     function isSpecialAddresses(address from, address to) view public returns (bool){
1179         
1180         return (from == owner() || to == owner() || from == address(this) || to == address(this));
1181     }
1182 
1183     function disableBotProtectionPermanently() external onlyOwner {
1184         isBotProtectionDisabledPermanently = true;
1185     }
1186 
1187     function setMaxTxAmount(uint256 maxTxAmount_) external onlyOwner {
1188         maxTxAmount = maxTxAmount_;
1189     }
1190 
1191 
1192     function setMaxHolding(uint256 maxHolding_) external onlyOwner {
1193         maxHolding = maxHolding_;
1194     }
1195 
1196     function setExempt(address who, bool status) public onlyOwner {
1197         isExempt[who] = status;
1198     }
1199 
1200     function setBuyCooldownStatus(bool status) external onlyOwner {
1201         buyCooldownEnabled = status;
1202     }
1203 
1204     function setBuyCooldown(uint256 buyCooldown_) external onlyOwner {
1205         buyCooldown = buyCooldown_;
1206     }
1207 }