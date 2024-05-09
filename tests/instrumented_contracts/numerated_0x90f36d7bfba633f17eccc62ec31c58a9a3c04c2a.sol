1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.9;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(
64         address sender,
65         address recipient,
66         uint256 amount
67     ) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 /**
85  * @dev Interface for the optional metadata functions from the ERC20 standard.
86  *
87  * _Available since v4.1._
88  */
89 interface IERC20Metadata is IERC20 {
90     /**
91      * @dev Returns the name of the token.
92      */
93     function name() external view returns (string memory);
94 
95     /**
96      * @dev Returns the symbol of the token.
97      */
98     function symbol() external view returns (string memory);
99 
100     /**
101      * @dev Returns the decimals places of the token.
102      */
103     function decimals() external view returns (uint8);
104 }
105 
106 /*
107  * @dev Provides information about the current execution context, including the
108  * sender of the transaction and its data. While these are generally available
109  * via msg.sender and msg.data, they should not be accessed in such a direct
110  * manner, since when dealing with meta-transactions the account sending and
111  * paying for execution may not be the actual sender (as far as an application
112  * is concerned).
113  *
114  * This contract is only required for intermediate, library-like contracts.
115  */
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120 
121     function _msgData() internal view virtual returns (bytes calldata) {
122         return msg.data;
123     }
124 }
125 
126 /**
127  * @dev Implementation of the {IERC20} interface.
128  *
129  * This implementation is agnostic to the way tokens are created. This means
130  * that a supply mechanism has to be added in a derived contract using {_mint}.
131  * For a generic mechanism see {ERC20PresetMinterPauser}.
132  *
133  * TIP: For a detailed writeup see our guide
134  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
135  * to implement supply mechanisms].
136  *
137  * We have followed general OpenZeppelin guidelines: functions revert instead
138  * of returning `false` on failure. This behavior is nonetheless conventional
139  * and does not conflict with the expectations of ERC20 applications.
140  *
141  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
142  * This allows applications to reconstruct the allowance for all accounts just
143  * by listening to said events. Other implementations of the EIP may not emit
144  * these events, as it isn't required by the specification.
145  *
146  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
147  * functions have been added to mitigate the well-known issues around setting
148  * allowances. See {IERC20-approve}.
149  */
150 contract ERC20 is Context, IERC20, IERC20Metadata {
151     mapping(address => uint256) private _balances;
152 
153     mapping(address => mapping(address => uint256)) private _allowances;
154 
155     uint256 private _totalSupply;
156 
157     string private _name;
158     string private _symbol;
159 
160     /**
161      * @dev Sets the values for {name} and {symbol}.
162      *
163      * The default value of {decimals} is 18. To select a different value for
164      * {decimals} you should overload it.
165      *
166      * All two of these values are immutable: they can only be set once during
167      * construction.
168      */
169     constructor(string memory name_, string memory symbol_) {
170         _name = name_;
171         _symbol = symbol_;
172     }
173 
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() public view virtual override returns (string memory) {
178         return _name;
179     }
180 
181     /**
182      * @dev Returns the symbol of the token, usually a shorter version of the
183      * name.
184      */
185     function symbol() public view virtual override returns (string memory) {
186         return _symbol;
187     }
188 
189     /**
190      * @dev Returns the number of decimals used to get its user representation.
191      * For example, if `decimals` equals `2`, a balance of `505` tokens should
192      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
193      *
194      * Tokens usually opt for a value of 18, imitating the relationship between
195      * Ether and Wei. This is the value {ERC20} uses, unless this function is
196      * overridden;
197      *
198      * NOTE: This information is only used for _display_ purposes: it in
199      * no way affects any of the arithmetic of the contract, including
200      * {IERC20-balanceOf} and {IERC20-transfer}.
201      */
202     function decimals() public view virtual override returns (uint8) {
203         return 18;
204     }
205 
206     /**
207      * @dev See {IERC20-totalSupply}.
208      */
209     function totalSupply() public view virtual override returns (uint256) {
210         return _totalSupply;
211     }
212 
213     /**
214      * @dev See {IERC20-balanceOf}.
215      */
216     function balanceOf(address account) public view virtual override returns (uint256) {
217         return _balances[account];
218     }
219 
220     /**
221      * @dev See {IERC20-transfer}.
222      *
223      * Requirements:
224      *
225      * - `recipient` cannot be the zero address.
226      * - the caller must have a balance of at least `amount`.
227      */
228     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
229         _transfer(_msgSender(), recipient, amount);
230         return true;
231     }
232 
233     /**
234      * @dev See {IERC20-allowance}.
235      */
236     function allowance(address owner, address spender) public view virtual override returns (uint256) {
237         return _allowances[owner][spender];
238     }
239 
240     /**
241      * @dev See {IERC20-approve}.
242      *
243      * Requirements:
244      *
245      * - `spender` cannot be the zero address.
246      */
247     function approve(address spender, uint256 amount) public virtual override returns (bool) {
248         _approve(_msgSender(), spender, amount);
249         return true;
250     }
251 
252     /**
253      * @dev See {IERC20-transferFrom}.
254      *
255      * Emits an {Approval} event indicating the updated allowance. This is not
256      * required by the EIP. See the note at the beginning of {ERC20}.
257      *
258      * Requirements:
259      *
260      * - `sender` and `recipient` cannot be the zero address.
261      * - `sender` must have a balance of at least `amount`.
262      * - the caller must have allowance for ``sender``'s tokens of at least
263      * `amount`.
264      */
265     function transferFrom(
266         address sender,
267         address recipient,
268         uint256 amount
269     ) public virtual override returns (bool) {
270         _transfer(sender, recipient, amount);
271 
272         uint256 currentAllowance = _allowances[sender][_msgSender()];
273         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
274         unchecked {
275             _approve(sender, _msgSender(), currentAllowance - amount);
276         }
277 
278         return true;
279     }
280 
281     /**
282      * @dev Atomically increases the allowance granted to `spender` by the caller.
283      *
284      * This is an alternative to {approve} that can be used as a mitigation for
285      * problems described in {IERC20-approve}.
286      *
287      * Emits an {Approval} event indicating the updated allowance.
288      *
289      * Requirements:
290      *
291      * - `spender` cannot be the zero address.
292      */
293     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
294         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
295         return true;
296     }
297 
298     /**
299      * @dev Atomically decreases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to {approve} that can be used as a mitigation for
302      * problems described in {IERC20-approve}.
303      *
304      * Emits an {Approval} event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      * - `spender` must have allowance for the caller of at least
310      * `subtractedValue`.
311      */
312     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
313         uint256 currentAllowance = _allowances[_msgSender()][spender];
314         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
315         unchecked {
316             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
317         }
318 
319         return true;
320     }
321 
322     /**
323      * @dev Moves `amount` of tokens from `sender` to `recipient`.
324      *
325      * This internal function is equivalent to {transfer}, and can be used to
326      * e.g. implement automatic token fees, slashing mechanisms, etc.
327      *
328      * Emits a {Transfer} event.
329      *
330      * Requirements:
331      *
332      * - `sender` cannot be the zero address.
333      * - `recipient` cannot be the zero address.
334      * - `sender` must have a balance of at least `amount`.
335      */
336     function _transfer(
337         address sender,
338         address recipient,
339         uint256 amount
340     ) internal virtual {
341         require(sender != address(0), "ERC20: transfer from the zero address");
342         require(recipient != address(0), "ERC20: transfer to the zero address");
343 
344         _beforeTokenTransfer(sender, recipient, amount);
345 
346         uint256 senderBalance = _balances[sender];
347         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
348         unchecked {
349             _balances[sender] = senderBalance - amount;
350         }
351         _balances[recipient] += amount;
352 
353         emit Transfer(sender, recipient, amount);
354 
355         _afterTokenTransfer(sender, recipient, amount);
356     }
357 
358     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
359      * the total supply.
360      *
361      * Emits a {Transfer} event with `from` set to the zero address.
362      *
363      * Requirements:
364      *
365      * - `account` cannot be the zero address.
366      */
367     function _mint(address account, uint256 amount) internal virtual {
368         require(account != address(0), "ERC20: mint to the zero address");
369 
370         _beforeTokenTransfer(address(0), account, amount);
371 
372         _totalSupply += amount;
373         _balances[account] += amount;
374         emit Transfer(address(0), account, amount);
375 
376         _afterTokenTransfer(address(0), account, amount);
377     }
378 
379     /**
380      * @dev Destroys `amount` tokens from `account`, reducing the
381      * total supply.
382      *
383      * Emits a {Transfer} event with `to` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      * - `account` must have at least `amount` tokens.
389      */
390     function _burn(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: burn from the zero address");
392 
393         _beforeTokenTransfer(account, address(0), amount);
394 
395         uint256 accountBalance = _balances[account];
396         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
397         unchecked {
398             _balances[account] = accountBalance - amount;
399         }
400         _totalSupply -= amount;
401 
402         emit Transfer(account, address(0), amount);
403 
404         _afterTokenTransfer(account, address(0), amount);
405     }
406 
407     /**
408      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
409      *
410      * This internal function is equivalent to `approve`, and can be used to
411      * e.g. set automatic allowances for certain subsystems, etc.
412      *
413      * Emits an {Approval} event.
414      *
415      * Requirements:
416      *
417      * - `owner` cannot be the zero address.
418      * - `spender` cannot be the zero address.
419      */
420     function _approve(
421         address owner,
422         address spender,
423         uint256 amount
424     ) internal virtual {
425         require(owner != address(0), "ERC20: approve from the zero address");
426         require(spender != address(0), "ERC20: approve to the zero address");
427 
428         _allowances[owner][spender] = amount;
429         emit Approval(owner, spender, amount);
430     }
431 
432     /**
433      * @dev Hook that is called before any transfer of tokens. This includes
434      * minting and burning.
435      *
436      * Calling conditions:
437      *
438      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
439      * will be transferred to `to`.
440      * - when `from` is zero, `amount` tokens will be minted for `to`.
441      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
442      * - `from` and `to` are never both zero.
443      *
444      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
445      */
446     function _beforeTokenTransfer(
447         address from,
448         address to,
449         uint256 amount
450     ) internal virtual {}
451 
452     /**
453      * @dev Hook that is called after any transfer of tokens. This includes
454      * minting and burning.
455      *
456      * Calling conditions:
457      *
458      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
459      * has been transferred to `to`.
460      * - when `from` is zero, `amount` tokens have been minted for `to`.
461      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
462      * - `from` and `to` are never both zero.
463      *
464      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
465      */
466     function _afterTokenTransfer(
467         address from,
468         address to,
469         uint256 amount
470     ) internal virtual {}
471 }
472 
473 /**
474  * @dev Contract module which provides a basic access control mechanism, where
475  * there is an account (an owner) that can be granted exclusive access to
476  * specific functions.
477  *
478  * By default, the owner account will be the one that deploys the contract. This
479  * can later be changed with {transferOwnership}.
480  *
481  * This module is used through inheritance. It will make available the modifier
482  * `onlyOwner`, which can be applied to your functions to restrict their use to
483  * the owner.
484  */
485 abstract contract Ownable is Context {
486     address private _owner;
487 
488     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
489 
490     /**
491      * @dev Initializes the contract setting the deployer as the initial owner.
492      */
493     constructor() {
494     }
495 
496     /**
497      * @dev Returns the address of the current owner.
498      */
499     function owner() public view virtual returns (address) {
500         return _owner;
501     }
502 
503     /**
504      * @dev Throws if called by any account other than the owner.
505      */
506     modifier onlyOwner() {
507         require(owner() == _msgSender(), "Ownable: caller is not the owner");
508         _;
509     }
510 
511     /**
512      * @dev Leaves the contract without owner. It will not be possible to call
513      * `onlyOwner` functions anymore. Can only be called by the current owner.
514      *
515      * NOTE: Renouncing ownership will leave the contract without an owner,
516      * thereby removing any functionality that is only available to the owner.
517      */
518     function renounceOwnership() public virtual onlyOwner {
519         _setOwner(address(0));
520     }
521 
522     /**
523      * @dev Transfers ownership of the contract to a new account (`newOwner`).
524      * Can only be called by the current owner.
525      */
526     function transferOwnership(address newOwner) public virtual onlyOwner {
527         require(newOwner != address(0), "Ownable: new owner is the zero address");
528         _setOwner(newOwner);
529     }
530 
531     function _setOwner(address newOwner) internal {
532         address oldOwner = _owner;
533         _owner = newOwner;
534         emit OwnershipTransferred(oldOwner, newOwner);
535     }
536 }
537 
538 /**
539  * @dev Contract module which allows children to implement an emergency stop
540  * mechanism that can be triggered by an authorized account.
541  *
542  * This module is used through inheritance. It will make available the
543  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
544  * the functions of your contract. Note that they will not be pausable by
545  * simply including this module, only once the modifiers are put in place.
546  */
547 abstract contract Pausable is Context {
548     /**
549      * @dev Emitted when the pause is triggered by `account`.
550      */
551     event Paused(address account);
552 
553     /**
554      * @dev Emitted when the pause is lifted by `account`.
555      */
556     event Unpaused(address account);
557 
558     bool private _paused;
559 
560     /**
561      * @dev Initializes the contract in unpaused state.
562      */
563     constructor() {
564         _paused = false;
565     }
566 
567     /**
568      * @dev Returns true if the contract is paused, and false otherwise.
569      */
570     function paused() public view virtual returns (bool) {
571         return _paused;
572     }
573 
574     /**
575      * @dev Modifier to make a function callable only when the contract is not paused.
576      *
577      * Requirements:
578      *
579      * - The contract must not be paused.
580      */
581     modifier whenNotPaused() {
582         require(!paused(), "Pausable: paused");
583         _;
584     }
585 
586     /**
587      * @dev Modifier to make a function callable only when the contract is paused.
588      *
589      * Requirements:
590      *
591      * - The contract must be paused.
592      */
593     modifier whenPaused() {
594         require(paused(), "Pausable: not paused");
595         _;
596     }
597 
598     /**
599      * @dev Triggers stopped state.
600      *
601      * Requirements:
602      *
603      * - The contract must not be paused.
604      */
605     function _pause() internal virtual whenNotPaused {
606         _paused = true;
607         emit Paused(_msgSender());
608     }
609 
610     /**
611      * @dev Returns to normal state.
612      *
613      * Requirements:
614      *
615      * - The contract must be paused.
616      */
617     function _unpause() internal virtual whenPaused {
618         _paused = false;
619         emit Unpaused(_msgSender());
620     }
621 }
622 
623 interface IUniswapV2Pair {
624     event Approval(address indexed owner, address indexed spender, uint value);
625     event Transfer(address indexed from, address indexed to, uint value);
626 
627     function name() external pure returns (string memory);
628     function symbol() external pure returns (string memory);
629     function decimals() external pure returns (uint8);
630     function totalSupply() external view returns (uint);
631     function balanceOf(address owner) external view returns (uint);
632     function allowance(address owner, address spender) external view returns (uint);
633 
634     function approve(address spender, uint value) external returns (bool);
635     function transfer(address to, uint value) external returns (bool);
636     function transferFrom(address from, address to, uint value) external returns (bool);
637 
638     function DOMAIN_SEPARATOR() external view returns (bytes32);
639     function PERMIT_TYPEHASH() external pure returns (bytes32);
640     function nonces(address owner) external view returns (uint);
641 
642     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
643 
644     event Mint(address indexed sender, uint amount0, uint amount1);
645     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
646     event Swap(
647         address indexed sender,
648         uint amount0In,
649         uint amount1In,
650         uint amount0Out,
651         uint amount1Out,
652         address indexed to
653     );
654     event Sync(uint112 reserve0, uint112 reserve1);
655 
656     function MINIMUM_LIQUIDITY() external pure returns (uint);
657     function factory() external view returns (address);
658     function token0() external view returns (address);
659     function token1() external view returns (address);
660     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
661     function price0CumulativeLast() external view returns (uint);
662     function price1CumulativeLast() external view returns (uint);
663     function kLast() external view returns (uint);
664 
665     function mint(address to) external returns (uint liquidity);
666     function burn(address to) external returns (uint amount0, uint amount1);
667     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
668     function skim(address to) external;
669     function sync() external;
670 
671     function initialize(address, address) external;
672 }
673 
674 interface IUniswapV2Factory {
675     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
676 
677     function feeTo() external view returns (address);
678     function feeToSetter() external view returns (address);
679 
680     function getPair(address tokenA, address tokenB) external view returns (address pair);
681     function allPairs(uint) external view returns (address pair);
682     function allPairsLength() external view returns (uint);
683 
684     function createPair(address tokenA, address tokenB) external returns (address pair);
685 
686     function setFeeTo(address) external;
687     function setFeeToSetter(address) external;
688 }
689 
690 interface IUniswapV2Router01 {
691     function factory() external pure returns (address);
692     function WETH() external pure returns (address);
693 
694     function addLiquidity(
695         address tokenA,
696         address tokenB,
697         uint amountADesired,
698         uint amountBDesired,
699         uint amountAMin,
700         uint amountBMin,
701         address to,
702         uint deadline
703     ) external returns (uint amountA, uint amountB, uint liquidity);
704     function addLiquidityETH(
705         address token,
706         uint amountTokenDesired,
707         uint amountTokenMin,
708         uint amountETHMin,
709         address to,
710         uint deadline
711     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
712     function removeLiquidity(
713         address tokenA,
714         address tokenB,
715         uint liquidity,
716         uint amountAMin,
717         uint amountBMin,
718         address to,
719         uint deadline
720     ) external returns (uint amountA, uint amountB);
721     function removeLiquidityETH(
722         address token,
723         uint liquidity,
724         uint amountTokenMin,
725         uint amountETHMin,
726         address to,
727         uint deadline
728     ) external returns (uint amountToken, uint amountETH);
729     function removeLiquidityWithPermit(
730         address tokenA,
731         address tokenB,
732         uint liquidity,
733         uint amountAMin,
734         uint amountBMin,
735         address to,
736         uint deadline,
737         bool approveMax, uint8 v, bytes32 r, bytes32 s
738     ) external returns (uint amountA, uint amountB);
739     function removeLiquidityETHWithPermit(
740         address token,
741         uint liquidity,
742         uint amountTokenMin,
743         uint amountETHMin,
744         address to,
745         uint deadline,
746         bool approveMax, uint8 v, bytes32 r, bytes32 s
747     ) external returns (uint amountToken, uint amountETH);
748     function swapExactTokensForTokens(
749         uint amountIn,
750         uint amountOutMin,
751         address[] calldata path,
752         address to,
753         uint deadline
754     ) external returns (uint[] memory amounts);
755     function swapTokensForExactTokens(
756         uint amountOut,
757         uint amountInMax,
758         address[] calldata path,
759         address to,
760         uint deadline
761     ) external returns (uint[] memory amounts);
762     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
763         external
764         payable
765         returns (uint[] memory amounts);
766     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
767         external
768         returns (uint[] memory amounts);
769     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
770         external
771         returns (uint[] memory amounts);
772     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
773         external
774         payable
775         returns (uint[] memory amounts);
776 
777     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
778     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
779     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
780     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
781     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
782 }
783 
784 interface IUniswapV2Router02 is IUniswapV2Router01 {
785     function removeLiquidityETHSupportingFeeOnTransferTokens(
786         address token,
787         uint liquidity,
788         uint amountTokenMin,
789         uint amountETHMin,
790         address to,
791         uint deadline
792     ) external returns (uint amountETH);
793     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
794         address token,
795         uint liquidity,
796         uint amountTokenMin,
797         uint amountETHMin,
798         address to,
799         uint deadline,
800         bool approveMax, uint8 v, bytes32 r, bytes32 s
801     ) external returns (uint amountETH);
802 
803     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
804         uint amountIn,
805         uint amountOutMin,
806         address[] calldata path,
807         address to,
808         uint deadline
809     ) external;
810     function swapExactETHForTokensSupportingFeeOnTransferTokens(
811         uint amountOutMin,
812         address[] calldata path,
813         address to,
814         uint deadline
815     ) external payable;
816     function swapExactTokensForETHSupportingFeeOnTransferTokens(
817         uint amountIn,
818         uint amountOutMin,
819         address[] calldata path,
820         address to,
821         uint deadline
822     ) external;
823 }
824 
825 contract CoinToken is ERC20, Ownable, Pausable {
826 
827     // CONFIG START
828     
829     uint256 private initialSupply;
830    
831     uint256 private denominator = 100;
832 
833     uint256 private swapThreshold = 0.0000005 ether; // The contract will only swap to ETH, once the fee tokens reach the specified threshold
834     
835     uint256 private devTaxBuy;
836     uint256 private marketingTaxBuy;
837     uint256 private liquidityTaxBuy;
838     uint256 private charityTaxBuy;
839     
840     uint256 private devTaxSell;
841     uint256 private marketingTaxSell;
842     uint256 private liquidityTaxSell;
843     uint256 private charityTaxSell;
844     
845     address private devTaxWallet;
846     address private marketingTaxWallet;
847     address private liquidityTaxWallet;
848     address private charityTaxWallet;
849     
850     // CONFIG END
851     
852     mapping (address => bool) private blacklist;
853     mapping (address => bool) private excludeList;
854     
855     mapping (string => uint256) private buyTaxes;
856     mapping (string => uint256) private sellTaxes;
857     mapping (string => address) private taxWallets;
858     
859     bool public taxStatus = true;
860     
861     IUniswapV2Router02 private uniswapV2Router02;
862     IUniswapV2Factory private uniswapV2Factory;
863     IUniswapV2Pair private uniswapV2Pair;
864     
865     constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply,address[6] memory _addr,uint256[8] memory _value) ERC20(_tokenName, _tokenSymbol) payable
866     {
867         initialSupply =_supply * (10**18);
868         _setOwner(_addr[5]);
869         uniswapV2Router02 = IUniswapV2Router02(_addr[1]);
870         uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
871         uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));
872         taxWallets["liquidity"] = _addr[0];
873         setBuyTax(_value[0], _value[1], _value[3], _value[2]);
874         setSellTax(_value[4], _value[5], _value[7], _value[6]);
875         setTaxWallets(_addr[2], _addr[3], _addr[4]);
876         exclude(msg.sender);
877         exclude(address(this));
878         payable(_addr[0]).transfer(msg.value);
879         _mint(msg.sender, initialSupply);
880     }
881     
882     uint256 private marketingTokens;
883     uint256 private devTokens;
884     uint256 private liquidityTokens;
885     uint256 private charityTokens;
886     
887     /**
888      * @dev Calculates the tax, transfer it to the contract. If the user is selling, and the swap threshold is met, it executes the tax.
889      */
890     function handleTax(address from, address to, uint256 amount) private returns (uint256) {
891         address[] memory sellPath = new address[](2);
892         sellPath[0] = address(this);
893         sellPath[1] = uniswapV2Router02.WETH();
894         
895         if(!isExcluded(from) && !isExcluded(to)) {
896             uint256 tax;
897             uint256 baseUnit = amount / denominator;
898             if(from == address(uniswapV2Pair)) {
899                 tax += baseUnit * buyTaxes["marketing"];
900                 tax += baseUnit * buyTaxes["dev"];
901                 tax += baseUnit * buyTaxes["liquidity"];
902                 tax += baseUnit * buyTaxes["charity"];
903                 
904                 if(tax > 0) {
905                     _transfer(from, address(this), tax);   
906                 }
907                 
908                 marketingTokens += baseUnit * buyTaxes["marketing"];
909                 devTokens += baseUnit * buyTaxes["dev"];
910                 liquidityTokens += baseUnit * buyTaxes["liquidity"];
911                 charityTokens += baseUnit * buyTaxes["charity"];
912             } else if(to == address(uniswapV2Pair)) {
913                 tax += baseUnit * sellTaxes["marketing"];
914                 tax += baseUnit * sellTaxes["dev"];
915                 tax += baseUnit * sellTaxes["liquidity"];
916                 tax += baseUnit * sellTaxes["charity"];
917                 
918                 if(tax > 0) {
919                     _transfer(from, address(this), tax);   
920                 }
921                 
922                 marketingTokens += baseUnit * sellTaxes["marketing"];
923                 devTokens += baseUnit * sellTaxes["dev"];
924                 liquidityTokens += baseUnit * sellTaxes["liquidity"];
925                 charityTokens += baseUnit * sellTaxes["charity"];
926                 
927                 uint256 taxSum = marketingTokens + devTokens + liquidityTokens + charityTokens;
928                 
929                 if(taxSum == 0) return amount;
930                 
931                 uint256 ethValue = uniswapV2Router02.getAmountsOut(marketingTokens + devTokens + liquidityTokens + charityTokens, sellPath)[1];
932                 
933                 if(ethValue >= swapThreshold) {
934                     uint256 startBalance = address(this).balance;
935 
936                     uint256 toSell = marketingTokens + devTokens + liquidityTokens / 2 + charityTokens;
937                     
938                     _approve(address(this), address(uniswapV2Router02), toSell);
939             
940                     uniswapV2Router02.swapExactTokensForETH(
941                         toSell,
942                         0,
943                         sellPath,
944                         address(this),
945                         block.timestamp
946                     );
947                     
948                     uint256 ethGained = address(this).balance - startBalance;
949                     
950                     uint256 liquidityToken = liquidityTokens / 2;
951                     uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
952                     
953                     uint256 marketingETH = (ethGained * ((marketingTokens * 10**18) / taxSum)) / 10**18;
954                     uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
955                     uint256 charityETH = (ethGained * ((charityTokens * 10**18) / taxSum)) / 10**18;
956                     
957                     _approve(address(this), address(uniswapV2Router02), liquidityToken);
958                     
959                     (uint amountToken, uint amountETH, uint liquidity) = uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
960                         address(this),
961                         liquidityToken,
962                         0,
963                         0,
964                         taxWallets["liquidity"],
965                         block.timestamp
966                     );
967                     
968                     uint256 remainingTokens = (marketingTokens + devTokens + liquidityTokens + charityTokens) - (toSell + amountToken);
969                     
970                     if(remainingTokens > 0) {
971                         _transfer(address(this), taxWallets["dev"], remainingTokens);
972                     }
973                     
974                     taxWallets["marketing"].call{value: marketingETH}("");
975                     taxWallets["dev"].call{value: devETH}("");
976                     taxWallets["charity"].call{value: charityETH}("");
977                     
978                     if(ethGained - (marketingETH + devETH + liquidityETH + charityETH) > 0) {
979                         taxWallets["marketing"].call{value: ethGained - (marketingETH + devETH + liquidityETH + charityETH)}("");
980                     }
981                     
982                     marketingTokens = 0;
983                     devTokens = 0;
984                     liquidityTokens = 0;
985                     charityTokens = 0;
986                 }
987                 
988             }
989             
990             amount -= tax;
991         }
992         
993         return amount;
994     }
995     
996     function _transfer(
997         address sender,
998         address recipient,
999         uint256 amount
1000     ) internal override virtual {
1001         require(!paused(), "CoinToken: token transfer while paused");
1002         require(!isBlacklisted(msg.sender), "CoinToken: sender blacklisted");
1003         require(!isBlacklisted(recipient), "CoinToken: recipient blacklisted");
1004         require(!isBlacklisted(tx.origin), "CoinToken: sender blacklisted");
1005         
1006         if(taxStatus) {
1007             amount = handleTax(sender, recipient, amount);   
1008         }
1009         
1010         super._transfer(sender, recipient, amount);
1011     }
1012     
1013     /**
1014      * @dev Triggers the tax handling functionality
1015      */
1016     function triggerTax() public onlyOwner {
1017         handleTax(address(0), address(uniswapV2Pair), 0);
1018     }
1019     
1020     /**
1021      * @dev Pauses transfers on the token.
1022      */
1023     function pause() public onlyOwner {
1024         require(!paused(), "CoinToken: Contract is already paused");
1025         _pause();
1026     }
1027 
1028     /**
1029      * @dev Unpauses transfers on the token.
1030      */
1031     function unpause() public onlyOwner {
1032         require(paused(), "CoinToken: Contract is not paused");
1033         _unpause();
1034     }
1035     
1036     /**
1037      * @dev Burns tokens from caller address.
1038      */
1039     function burn(uint256 amount) public onlyOwner {
1040         _burn(msg.sender, amount);
1041     }
1042     
1043     /**
1044      * @dev Blacklists the specified account (Disables transfers to and from the account).
1045      */
1046     function enableBlacklist(address account) public onlyOwner {
1047         require(!blacklist[account], "CoinToken: Account is already blacklisted");
1048         blacklist[account] = true;
1049     }
1050     
1051     /**
1052      * @dev Remove the specified account from the blacklist.
1053      */
1054     function disableBlacklist(address account) public onlyOwner {
1055         require(blacklist[account], "CoinToken: Account is not blacklisted");
1056         blacklist[account] = false;
1057     }
1058     
1059     /**
1060      * @dev Excludes the specified account from tax.
1061      */
1062     function exclude(address account) public onlyOwner {
1063         require(!isExcluded(account), "CoinToken: Account is already excluded");
1064         excludeList[account] = true;
1065     }
1066     
1067     /**
1068      * @dev Re-enables tax on the specified account.
1069      */
1070     function removeExclude(address account) public onlyOwner {
1071         require(isExcluded(account), "CoinToken: Account is not excluded");
1072         excludeList[account] = false;
1073     }
1074     
1075     /**
1076      * @dev Sets tax for buys.
1077      */
1078     function setBuyTax(uint256 dev, uint256 marketing, uint256 liquidity, uint256 charity) public onlyOwner {
1079         buyTaxes["dev"] = dev;
1080         buyTaxes["marketing"] = marketing;
1081         buyTaxes["liquidity"] = liquidity;
1082         buyTaxes["charity"] = charity;
1083     }
1084     
1085     /**
1086      * @dev Sets tax for sells.
1087      */
1088     function setSellTax(uint256 dev, uint256 marketing, uint256 liquidity, uint256 charity) public onlyOwner {
1089 
1090         sellTaxes["dev"] = dev;
1091         sellTaxes["marketing"] = marketing;
1092         sellTaxes["liquidity"] = liquidity;
1093         sellTaxes["charity"] = charity;
1094     }
1095     
1096     /**
1097      * @dev Sets wallets for taxes.
1098      */
1099     function setTaxWallets(address dev, address marketing, address charity) public onlyOwner {
1100         taxWallets["dev"] = dev;
1101         taxWallets["marketing"] = marketing;
1102         taxWallets["charity"] = charity;
1103     }
1104     
1105     /**
1106      * @dev Enables tax globally.
1107      */
1108     function enableTax() public onlyOwner {
1109         require(!taxStatus, "CoinToken: Tax is already enabled");
1110         taxStatus = true;
1111     }
1112     
1113     /**
1114      * @dev Disables tax globally.
1115      */
1116     function disableTax() public onlyOwner {
1117         require(taxStatus, "CoinToken: Tax is already disabled");
1118         taxStatus = false;
1119     }
1120     
1121     /**
1122      * @dev Returns true if the account is blacklisted, and false otherwise.
1123      */
1124     function isBlacklisted(address account) public view returns (bool) {
1125         return blacklist[account];
1126     }
1127     
1128     /**
1129      * @dev Returns true if the account is excluded, and false otherwise.
1130      */
1131     function isExcluded(address account) public view returns (bool) {
1132         return excludeList[account];
1133     }
1134     
1135     receive() external payable {}
1136 }