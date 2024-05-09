1 /*
2 
3 https://medium.com/@shichiERC/
4 https://twitter.com/ShichiToken
5 https://t.me/shichifukujin
6 
7 
8  */
9 
10 
11 // SPDX-License-Identifier: MIT
12 
13 
14 pragma solidity ^0.8.9;
15 
16 /**
17  * @dev Interface of the ERC20 standard as defined in the EIP.
18  */
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 /*
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         return msg.data;
133     }
134 }
135 
136 /**
137  * @dev Implementation of the {IERC20} interface.
138  *
139  * This implementation is agnostic to the way tokens are created. This means
140  * that a supply mechanism has to be added in a derived contract using {_mint}.
141  * For a generic mechanism see {ERC20PresetMinterPauser}.
142  *
143  * TIP: For a detailed writeup see our guide
144  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
145  * to implement supply mechanisms].
146  *
147  * We have followed general OpenZeppelin guidelines: functions revert instead
148  * of returning `false` on failure. This behavior is nonetheless conventional
149  * and does not conflict with the expectations of ERC20 applications.
150  *
151  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
152  * This allows applications to reconstruct the allowance for all accounts just
153  * by listening to said events. Other implementations of the EIP may not emit
154  * these events, as it isn't required by the specification.
155  *
156  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
157  * functions have been added to mitigate the well-known issues around setting
158  * allowances. See {IERC20-approve}.
159  */
160 contract ERC20 is Context, IERC20, IERC20Metadata {
161     mapping(address => uint256) private _balances;
162 
163     mapping(address => mapping(address => uint256)) private _allowances;
164 
165     uint256 private _totalSupply;
166 
167     string private _name;
168     string private _symbol;
169 
170     /**
171      * @dev Sets the values for {name} and {symbol}.
172      *
173      * The default value of {decimals} is 18. To select a different value for
174      * {decimals} you should overload it.
175      *
176      * All two of these values are immutable: they can only be set once during
177      * construction.
178      */
179     constructor(string memory name_, string memory symbol_) {
180         _name = name_;
181         _symbol = symbol_;
182     }
183 
184     /**
185      * @dev Returns the name of the token.
186      */
187     function name() public view virtual override returns (string memory) {
188         return _name;
189     }
190 
191     /**
192      * @dev Returns the symbol of the token, usually a shorter version of the
193      * name.
194      */
195     function symbol() public view virtual override returns (string memory) {
196         return _symbol;
197     }
198 
199     /**
200      * @dev Returns the number of decimals used to get its user representation.
201      * For example, if `decimals` equals `2`, a balance of `505` tokens should
202      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
203      *
204      * Tokens usually opt for a value of 18, imitating the relationship between
205      * Ether and Wei. This is the value {ERC20} uses, unless this function is
206      * overridden;
207      *
208      * NOTE: This information is only used for _display_ purposes: it in
209      * no way affects any of the arithmetic of the contract, including
210      * {IERC20-balanceOf} and {IERC20-transfer}.
211      */
212     function decimals() public view virtual override returns (uint8) {
213         return 18;
214     }
215 
216     /**
217      * @dev See {IERC20-totalSupply}.
218      */
219     function totalSupply() public view virtual override returns (uint256) {
220         return _totalSupply;
221     }
222 
223     /**
224      * @dev See {IERC20-balanceOf}.
225      */
226     function balanceOf(address account) public view virtual override returns (uint256) {
227         return _balances[account];
228     }
229 
230     /**
231      * @dev See {IERC20-transfer}.
232      *
233      * Requirements:
234      *
235      * - `recipient` cannot be the zero address.
236      * - the caller must have a balance of at least `amount`.
237      */
238     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
239         _transfer(_msgSender(), recipient, amount);
240         return true;
241     }
242 
243     /**
244      * @dev See {IERC20-allowance}.
245      */
246     function allowance(address owner, address spender) public view virtual override returns (uint256) {
247         return _allowances[owner][spender];
248     }
249 
250     /**
251      * @dev See {IERC20-approve}.
252      *
253      * Requirements:
254      *
255      * - `spender` cannot be the zero address.
256      */
257     function approve(address spender, uint256 amount) public virtual override returns (bool) {
258         _approve(_msgSender(), spender, amount);
259         return true;
260     }
261 
262     /**
263      * @dev See {IERC20-transferFrom}.
264      *
265      * Emits an {Approval} event indicating the updated allowance. This is not
266      * required by the EIP. See the note at the beginning of {ERC20}.
267      *
268      * Requirements:
269      *
270      * - `sender` and `recipient` cannot be the zero address.
271      * - `sender` must have a balance of at least `amount`.
272      * - the caller must have allowance for ``sender``'s tokens of at least
273      * `amount`.
274      */
275     function transferFrom(
276         address sender,
277         address recipient,
278         uint256 amount
279     ) public virtual override returns (bool) {
280         _transfer(sender, recipient, amount);
281 
282         uint256 currentAllowance = _allowances[sender][_msgSender()];
283         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
284         unchecked {
285             _approve(sender, _msgSender(), currentAllowance - amount);
286         }
287 
288         return true;
289     }
290 
291     /**
292      * @dev Atomically increases the allowance granted to `spender` by the caller.
293      *
294      * This is an alternative to {approve} that can be used as a mitigation for
295      * problems described in {IERC20-approve}.
296      *
297      * Emits an {Approval} event indicating the updated allowance.
298      *
299      * Requirements:
300      *
301      * - `spender` cannot be the zero address.
302      */
303     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
304         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
305         return true;
306     }
307 
308     /**
309      * @dev Atomically decreases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      * - `spender` must have allowance for the caller of at least
320      * `subtractedValue`.
321      */
322     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
323         uint256 currentAllowance = _allowances[_msgSender()][spender];
324         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
325         unchecked {
326             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
327         }
328 
329         return true;
330     }
331 
332     /**
333      * @dev Moves `amount` of tokens from `sender` to `recipient`.
334      *
335      * This internal function is equivalent to {transfer}, and can be used to
336      * e.g. implement automatic token fees, slashing mechanisms, etc.
337      *
338      * Emits a {Transfer} event.
339      *
340      * Requirements:
341      *
342      * - `sender` cannot be the zero address.
343      * - `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      */
346     function _transfer(
347         address sender,
348         address recipient,
349         uint256 amount
350     ) internal virtual {
351         require(sender != address(0), "ERC20: transfer from the zero address");
352         require(recipient != address(0), "ERC20: transfer to the zero address");
353 
354         _beforeTokenTransfer(sender, recipient, amount);
355 
356         uint256 senderBalance = _balances[sender];
357         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
358         unchecked {
359             _balances[sender] = senderBalance - amount;
360         }
361         _balances[recipient] += amount;
362 
363         emit Transfer(sender, recipient, amount);
364 
365         _afterTokenTransfer(sender, recipient, amount);
366     }
367 
368     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
369      * the total supply.
370      *
371      * Emits a {Transfer} event with `from` set to the zero address.
372      *
373      * Requirements:
374      *
375      * - `account` cannot be the zero address.
376      */
377     function _mint(address account, uint256 amount) internal virtual {
378         require(account != address(0), "ERC20: mint to the zero address");
379 
380         _beforeTokenTransfer(address(0), account, amount);
381 
382         _totalSupply += amount;
383         _balances[account] += amount;
384         emit Transfer(address(0), account, amount);
385 
386         _afterTokenTransfer(address(0), account, amount);
387     }
388 
389     /**
390      * @dev Destroys `amount` tokens from `account`, reducing the
391      * total supply.
392      *
393      * Emits a {Transfer} event with `to` set to the zero address.
394      *
395      * Requirements:
396      *
397      * - `account` cannot be the zero address.
398      * - `account` must have at least `amount` tokens.
399      */
400     function _burn(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: burn from the zero address");
402 
403         _beforeTokenTransfer(account, address(0), amount);
404 
405         uint256 accountBalance = _balances[account];
406         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
407         unchecked {
408             _balances[account] = accountBalance - amount;
409         }
410         _totalSupply -= amount;
411 
412         emit Transfer(account, address(0), amount);
413 
414         _afterTokenTransfer(account, address(0), amount);
415     }
416 
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
419      *
420      * This internal function is equivalent to `approve`, and can be used to
421      * e.g. set automatic allowances for certain subsystems, etc.
422      *
423      * Emits an {Approval} event.
424      *
425      * Requirements:
426      *
427      * - `owner` cannot be the zero address.
428      * - `spender` cannot be the zero address.
429      */
430     function _approve(
431         address owner,
432         address spender,
433         uint256 amount
434     ) internal virtual {
435         require(owner != address(0), "ERC20: approve from the zero address");
436         require(spender != address(0), "ERC20: approve to the zero address");
437 
438         _allowances[owner][spender] = amount;
439         emit Approval(owner, spender, amount);
440     }
441 
442     /**
443      * @dev Hook that is called before any transfer of tokens. This includes
444      * minting and burning.
445      *
446      * Calling conditions:
447      *
448      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
449      * will be transferred to `to`.
450      * - when `from` is zero, `amount` tokens will be minted for `to`.
451      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
452      * - `from` and `to` are never both zero.
453      *
454      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
455      */
456     function _beforeTokenTransfer(
457         address from,
458         address to,
459         uint256 amount
460     ) internal virtual {}
461 
462     /**
463      * @dev Hook that is called after any transfer of tokens. This includes
464      * minting and burning.
465      *
466      * Calling conditions:
467      *
468      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
469      * has been transferred to `to`.
470      * - when `from` is zero, `amount` tokens have been minted for `to`.
471      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
472      * - `from` and `to` are never both zero.
473      *
474      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
475      */
476     function _afterTokenTransfer(
477         address from,
478         address to,
479         uint256 amount
480     ) internal virtual {}
481 }
482 
483 /**
484  * @dev Contract module which provides a basic access control mechanism, where
485  * there is an account (an owner) that can be granted exclusive access to
486  * specific functions.
487  *
488  * By default, the owner account will be the one that deploys the contract. This
489  * can later be changed with {transferOwnership}.
490  *
491  * This module is used through inheritance. It will make available the modifier
492  * `onlyOwner`, which can be applied to your functions to restrict their use to
493  * the owner.
494  */
495 abstract contract Ownable is Context {
496     address private _owner;
497 
498     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
499 
500     /**
501      * @dev Initializes the contract setting the deployer as the initial owner.
502      */
503     constructor() {
504     }
505 
506     /**
507      * @dev Returns the address of the current owner.
508      */
509     function owner() public view virtual returns (address) {
510         return _owner;
511     }
512 
513     /**
514      * @dev Throws if called by any account other than the owner.
515      */
516     modifier onlyOwner() {
517         require(owner() == _msgSender(), "Ownable: caller is not the owner");
518         _;
519     }
520 
521     /**
522      * @dev Leaves the contract without owner. It will not be possible to call
523      * `onlyOwner` functions anymore. Can only be called by the current owner.
524      *
525      * NOTE: Renouncing ownership will leave the contract without an owner,
526      * thereby removing any functionality that is only available to the owner.
527      */
528     function renounceOwnership() public virtual onlyOwner {
529         _setOwner(address(0));
530     }
531 
532     /**
533      * @dev Transfers ownership of the contract to a new account (`newOwner`).
534      * Can only be called by the current owner.
535      */
536     function transferOwnership(address newOwner) public virtual onlyOwner {
537         require(newOwner != address(0), "Ownable: new owner is the zero address");
538         _setOwner(newOwner);
539     }
540 
541     function _setOwner(address newOwner) internal {
542         address oldOwner = _owner;
543         _owner = newOwner;
544         emit OwnershipTransferred(oldOwner, newOwner);
545     }
546 }
547 
548 /**
549  * @dev Contract module which allows children to implement an emergency stop
550  * mechanism that can be triggered by an authorized account.
551  *
552  * This module is used through inheritance. It will make available the
553  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
554  * the functions of your contract. Note that they will not be pausable by
555  * simply including this module, only once the modifiers are put in place.
556  */
557 abstract contract Pausable is Context {
558     /**
559      * @dev Emitted when the pause is triggered by `account`.
560      */
561     event Paused(address account);
562 
563     /**
564      * @dev Emitted when the pause is lifted by `account`.
565      */
566     event Unpaused(address account);
567 
568     bool private _paused;
569 
570     /**
571      * @dev Initializes the contract in unpaused state.
572      */
573     constructor() {
574         _paused = false;
575     }
576 
577     /**
578      * @dev Returns true if the contract is paused, and false otherwise.
579      */
580     function paused() public view virtual returns (bool) {
581         return _paused;
582     }
583 
584     /**
585      * @dev Modifier to make a function callable only when the contract is not paused.
586      *
587      * Requirements:
588      *
589      * - The contract must not be paused.
590      */
591     modifier whenNotPaused() {
592         require(!paused(), "Pausable: paused");
593         _;
594     }
595 
596     /**
597      * @dev Modifier to make a function callable only when the contract is paused.
598      *
599      * Requirements:
600      *
601      * - The contract must be paused.
602      */
603     modifier whenPaused() {
604         require(paused(), "Pausable: not paused");
605         _;
606     }
607 
608     /**
609      * @dev Triggers stopped state.
610      *
611      * Requirements:
612      *
613      * - The contract must not be paused.
614      */
615     function _pause() internal virtual whenNotPaused {
616         _paused = true;
617         emit Paused(_msgSender());
618     }
619 
620     /**
621      * @dev Returns to normal state.
622      *
623      * Requirements:
624      *
625      * - The contract must be paused.
626      */
627     function _unpause() internal virtual whenPaused {
628         _paused = false;
629         emit Unpaused(_msgSender());
630     }
631 }
632 
633 interface IUniswapV2Pair {
634     event Approval(address indexed owner, address indexed spender, uint value);
635     event Transfer(address indexed from, address indexed to, uint value);
636 
637     function name() external pure returns (string memory);
638     function symbol() external pure returns (string memory);
639     function decimals() external pure returns (uint8);
640     function totalSupply() external view returns (uint);
641     function balanceOf(address owner) external view returns (uint);
642     function allowance(address owner, address spender) external view returns (uint);
643 
644     function approve(address spender, uint value) external returns (bool);
645     function transfer(address to, uint value) external returns (bool);
646     function transferFrom(address from, address to, uint value) external returns (bool);
647 
648     function DOMAIN_SEPARATOR() external view returns (bytes32);
649     function PERMIT_TYPEHASH() external pure returns (bytes32);
650     function nonces(address owner) external view returns (uint);
651 
652     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
653 
654     event Mint(address indexed sender, uint amount0, uint amount1);
655     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
656     event Swap(
657         address indexed sender,
658         uint amount0In,
659         uint amount1In,
660         uint amount0Out,
661         uint amount1Out,
662         address indexed to
663     );
664     event Sync(uint112 reserve0, uint112 reserve1);
665 
666     function MINIMUM_LIQUIDITY() external pure returns (uint);
667     function factory() external view returns (address);
668     function token0() external view returns (address);
669     function token1() external view returns (address);
670     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
671     function price0CumulativeLast() external view returns (uint);
672     function price1CumulativeLast() external view returns (uint);
673     function kLast() external view returns (uint);
674 
675     function mint(address to) external returns (uint liquidity);
676     function burn(address to) external returns (uint amount0, uint amount1);
677     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
678     function skim(address to) external;
679     function sync() external;
680 
681     function initialize(address, address) external;
682 }
683 
684 interface IUniswapV2Factory {
685     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
686 
687     function feeTo() external view returns (address);
688     function feeToSetter() external view returns (address);
689 
690     function getPair(address tokenA, address tokenB) external view returns (address pair);
691     function allPairs(uint) external view returns (address pair);
692     function allPairsLength() external view returns (uint);
693 
694     function createPair(address tokenA, address tokenB) external returns (address pair);
695 
696     function setFeeTo(address) external;
697     function setFeeToSetter(address) external;
698 }
699 
700 interface IUniswapV2Router01 {
701     function factory() external pure returns (address);
702     function WETH() external pure returns (address);
703 
704     function addLiquidity(
705         address tokenA,
706         address tokenB,
707         uint amountADesired,
708         uint amountBDesired,
709         uint amountAMin,
710         uint amountBMin,
711         address to,
712         uint deadline
713     ) external returns (uint amountA, uint amountB, uint liquidity);
714     function addLiquidityETH(
715         address token,
716         uint amountTokenDesired,
717         uint amountTokenMin,
718         uint amountETHMin,
719         address to,
720         uint deadline
721     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
722     function removeLiquidity(
723         address tokenA,
724         address tokenB,
725         uint liquidity,
726         uint amountAMin,
727         uint amountBMin,
728         address to,
729         uint deadline
730     ) external returns (uint amountA, uint amountB);
731     function removeLiquidityETH(
732         address token,
733         uint liquidity,
734         uint amountTokenMin,
735         uint amountETHMin,
736         address to,
737         uint deadline
738     ) external returns (uint amountToken, uint amountETH);
739     function removeLiquidityWithPermit(
740         address tokenA,
741         address tokenB,
742         uint liquidity,
743         uint amountAMin,
744         uint amountBMin,
745         address to,
746         uint deadline,
747         bool approveMax, uint8 v, bytes32 r, bytes32 s
748     ) external returns (uint amountA, uint amountB);
749     function removeLiquidityETHWithPermit(
750         address token,
751         uint liquidity,
752         uint amountTokenMin,
753         uint amountETHMin,
754         address to,
755         uint deadline,
756         bool approveMax, uint8 v, bytes32 r, bytes32 s
757     ) external returns (uint amountToken, uint amountETH);
758     function swapExactTokensForTokens(
759         uint amountIn,
760         uint amountOutMin,
761         address[] calldata path,
762         address to,
763         uint deadline
764     ) external returns (uint[] memory amounts);
765     function swapTokensForExactTokens(
766         uint amountOut,
767         uint amountInMax,
768         address[] calldata path,
769         address to,
770         uint deadline
771     ) external returns (uint[] memory amounts);
772     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
773         external
774         payable
775         returns (uint[] memory amounts);
776     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
777         external
778         returns (uint[] memory amounts);
779     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
780         external
781         returns (uint[] memory amounts);
782     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
783         external
784         payable
785         returns (uint[] memory amounts);
786 
787     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
788     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
789     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
790     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
791     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
792 }
793 
794 interface IUniswapV2Router02 is IUniswapV2Router01 {
795     function removeLiquidityETHSupportingFeeOnTransferTokens(
796         address token,
797         uint liquidity,
798         uint amountTokenMin,
799         uint amountETHMin,
800         address to,
801         uint deadline
802     ) external returns (uint amountETH);
803     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
804         address token,
805         uint liquidity,
806         uint amountTokenMin,
807         uint amountETHMin,
808         address to,
809         uint deadline,
810         bool approveMax, uint8 v, bytes32 r, bytes32 s
811     ) external returns (uint amountETH);
812 
813     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
814         uint amountIn,
815         uint amountOutMin,
816         address[] calldata path,
817         address to,
818         uint deadline
819     ) external;
820     function swapExactETHForTokensSupportingFeeOnTransferTokens(
821         uint amountOutMin,
822         address[] calldata path,
823         address to,
824         uint deadline
825     ) external payable;
826     function swapExactTokensForETHSupportingFeeOnTransferTokens(
827         uint amountIn,
828         uint amountOutMin,
829         address[] calldata path,
830         address to,
831         uint deadline
832     ) external;
833 }
834 
835 contract Shichi is ERC20, Ownable, Pausable {
836 
837     // variables
838     
839     uint256 private initialSupply;
840    
841     uint256 private denominator = 100;
842 
843     uint256 private swapThreshold = 0.00005 ether; //
844     
845     uint256 private devTaxBuy;
846     uint256 private liquidityTaxBuy;
847    
848     
849     uint256 private devTaxSell;
850     uint256 private liquidityTaxSell;
851     uint256 public maxWallet;
852     
853     address private devTaxWallet;
854     address private liquidityTaxWallet;
855     
856     
857     // Mappings
858     
859     mapping (address => bool) private blacklist;
860     mapping (address => bool) private excludeList;
861    
862     
863     mapping (string => uint256) private buyTaxes;
864     mapping (string => uint256) private sellTaxes;
865     mapping (string => address) private taxWallets;
866     
867     bool public taxStatus = true;
868     
869     IUniswapV2Router02 private uniswapV2Router02;
870     IUniswapV2Factory private uniswapV2Factory;
871     IUniswapV2Pair private uniswapV2Pair;
872     
873     constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply) ERC20(_tokenName, _tokenSymbol) payable
874     {
875         initialSupply =_supply * (10**18);
876         maxWallet = initialSupply * 2 / 100; 
877         _setOwner(msg.sender);
878         uniswapV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
879         uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
880         uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));
881         taxWallets["liquidity"] = address(0);
882         setBuyTax(15,5); 
883         setSellTax(15,5); 
884         setTaxWallets(0x9D1f2a6BFa0e89c3Ad79aB5780254297f0281965); // 
885         exclude(msg.sender);
886         exclude(address(this));
887         exclude(devTaxWallet);
888         _mint(msg.sender, initialSupply);
889     }
890     
891     
892     uint256 private devTokens;
893     uint256 private liquidityTokens;
894     
895     
896     /**
897      * @dev Calculates the tax, transfer it to the contract. If the user is selling, and the swap threshold is met, it executes the tax.
898      */
899     function handleTax(address from, address to, uint256 amount) private returns (uint256) {
900         address[] memory sellPath = new address[](2);
901         sellPath[0] = address(this);
902         sellPath[1] = uniswapV2Router02.WETH();
903         
904         if(!isExcluded(from) && !isExcluded(to)) {
905             uint256 tax;
906             uint256 baseUnit = amount / denominator;
907             if(from == address(uniswapV2Pair)) {
908                 tax += baseUnit * buyTaxes["dev"];
909                 tax += baseUnit * buyTaxes["liquidity"];
910                
911                 
912                 if(tax > 0) {
913                     _transfer(from, address(this), tax);   
914                 }
915                 
916                 
917                 devTokens += baseUnit * buyTaxes["dev"];
918                 liquidityTokens += baseUnit * buyTaxes["liquidity"];
919 
920             } else if(to == address(uniswapV2Pair)) {
921                 
922                 tax += baseUnit * sellTaxes["dev"];
923                 tax += baseUnit * sellTaxes["liquidity"];
924                 
925                 
926                 if(tax > 0) {
927                     _transfer(from, address(this), tax);   
928                 }
929                 
930                
931                 devTokens += baseUnit * sellTaxes["dev"];
932                 liquidityTokens += baseUnit * sellTaxes["liquidity"];
933                 
934                 
935                 uint256 taxSum =  devTokens + liquidityTokens;
936                 
937                 if(taxSum == 0) return amount;
938                 
939                 uint256 ethValue = uniswapV2Router02.getAmountsOut( devTokens + liquidityTokens, sellPath)[1];
940                 
941                 if(ethValue >= swapThreshold) {
942                     uint256 startBalance = address(this).balance;
943 
944                     uint256 toSell = devTokens + liquidityTokens / 2 ;
945                     
946                     _approve(address(this), address(uniswapV2Router02), toSell);
947             
948                     uniswapV2Router02.swapExactTokensForETH(
949                         toSell,
950                         0,
951                         sellPath,
952                         address(this),
953                         block.timestamp
954                     );
955                     
956                     uint256 ethGained = address(this).balance - startBalance;
957                     
958                     uint256 liquidityToken = liquidityTokens / 2;
959                     uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
960                     
961                     
962                     uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
963                    
964                     
965                     _approve(address(this), address(uniswapV2Router02), liquidityToken);
966                     
967                     uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
968                         address(this),
969                         liquidityToken,
970                         0,
971                         0,
972                         taxWallets["liquidity"],
973                         block.timestamp
974                     );
975                     
976                     uint256 remainingTokens = (devTokens + liquidityTokens) - (toSell + liquidityToken);
977                     
978                     if(remainingTokens > 0) {
979                         _transfer(address(this), taxWallets["dev"], remainingTokens);
980                     }
981                     
982                     
983                    (bool success,) = taxWallets["dev"].call{value: devETH}("");
984                    require(success, "transfer to  dev wallet failed");
985                     
986                     
987                     if(ethGained - ( devETH + liquidityETH) > 0) {
988                        (bool success1,) = taxWallets["dev"].call{value: ethGained - (devETH + liquidityETH)}("");
989                         require(success1, "transfer to  dev wallet failed");
990                     }
991 
992                     
993                     
994                     
995                     devTokens = 0;
996                     liquidityTokens = 0;
997                     
998                 }
999                 
1000             }
1001             
1002             amount -= tax;
1003             if (to != address(uniswapV2Pair)){
1004                 require(balanceOf(to) + amount <= maxWallet, "maxWallet limit exceeded");
1005             }
1006            
1007         }
1008         
1009         return amount;
1010     }
1011     
1012     function _transfer(
1013         address sender,
1014         address recipient,
1015         uint256 amount
1016     ) internal override virtual {
1017         require(!paused(), "ERC20: token transfer while paused");
1018         require(!isBlacklisted(msg.sender), "ERC20: sender blacklisted");
1019         require(!isBlacklisted(recipient), "ERC20: recipient blacklisted");
1020         require(!isBlacklisted(tx.origin), "ERC20: sender blacklisted");
1021         
1022         if(taxStatus) {
1023             amount = handleTax(sender, recipient, amount);   
1024         }
1025 
1026         super._transfer(sender, recipient, amount);
1027     }
1028     
1029     /**
1030      * @dev Triggers the tax handling functionality
1031      */
1032     function triggerTax() public onlyOwner {
1033         handleTax(address(0), address(uniswapV2Pair), 0);
1034     }
1035     
1036     /**
1037      * @dev Pauses transfers on the token.
1038      */
1039     function pause() public onlyOwner {
1040         require(!paused(), "ERC20: Contract is already paused");
1041         _pause();
1042     }
1043 
1044     /**
1045      * @dev Unpauses transfers on the token.
1046      */
1047     function unpause() public onlyOwner {
1048         require(paused(), "ERC20: Contract is not paused");
1049         _unpause();
1050     }
1051 
1052      /**
1053      * @dev set max wallet limit per address.
1054      */
1055 
1056     function setMaxWallet (uint256 amount) external onlyOwner {
1057         require (amount > 10000, "NO rug pull");
1058         maxWallet = amount * 10**18;
1059     }
1060     
1061     /**
1062      * @dev Burns tokens from caller address.
1063      */
1064     function burn(uint256 amount) public onlyOwner {
1065         _burn(msg.sender, amount);
1066     }
1067     
1068     /**
1069      * @dev Blacklists the specified account (Disables transfers to and from the account).
1070      */
1071     function enableBlacklist(address account) public onlyOwner {
1072         require(!blacklist[account], "ERC20: Account is already blacklisted");
1073         blacklist[account] = true;
1074     }
1075     
1076     /**
1077      * @dev Remove the specified account from the blacklist.
1078      */
1079     function disableBlacklist(address account) public onlyOwner {
1080         require(blacklist[account], "ERC20: Account is not blacklisted");
1081         blacklist[account] = false;
1082     }
1083     
1084     /**
1085      * @dev Excludes the specified account from tax.
1086      */
1087     function exclude(address account) public onlyOwner {
1088         require(!isExcluded(account), "ERC20: Account is already excluded");
1089         excludeList[account] = true;
1090     }
1091     
1092     /**
1093      * @dev Re-enables tax on the specified account.
1094      */
1095     function removeExclude(address account) public onlyOwner {
1096         require(isExcluded(account), "ERC20: Account is not excluded");
1097         excludeList[account] = false;
1098     }
1099     
1100     /**
1101      * @dev Sets tax for buys.
1102      */
1103     function setBuyTax(uint256 dev,uint256 liquidity) public onlyOwner {
1104         buyTaxes["dev"] = dev;
1105         buyTaxes["liquidity"] = liquidity;
1106        
1107     }
1108     
1109     /**
1110      * @dev Sets tax for sells.
1111      */
1112     function setSellTax(uint256 dev, uint256 liquidity) public onlyOwner {
1113 
1114         sellTaxes["dev"] = dev;
1115         sellTaxes["liquidity"] = liquidity;
1116         
1117     }
1118     
1119     /**
1120      * @dev Sets wallets for taxes.
1121      */
1122     function setTaxWallets(address dev) public onlyOwner {
1123         taxWallets["dev"] = dev;
1124         
1125     }
1126 
1127     function claimStuckTokens(address _token) external onlyOwner {
1128  
1129         if (_token == address(0x0)) {
1130             payable(owner()).transfer(address(this).balance);
1131             return;
1132         }
1133         IERC20 erc20token = IERC20(_token);
1134         uint256 balance = erc20token.balanceOf(address(this));
1135         erc20token.transfer(owner(), balance);
1136     }
1137     
1138     /**
1139      * @dev Enables tax globally.
1140      */
1141     function enableTax() public onlyOwner {
1142         require(!taxStatus, "ERC20: Tax is already enabled");
1143         taxStatus = true;
1144     }
1145     
1146     /**
1147      * @dev Disables tax globally.
1148      */
1149     function disableTax() public onlyOwner {
1150         require(taxStatus, "ERC20: Tax is already disabled");
1151         taxStatus = false;
1152     }
1153     
1154     /**
1155      * @dev Returns true if the account is blacklisted, and false otherwise.
1156      */
1157     function isBlacklisted(address account) public view returns (bool) {
1158         return blacklist[account];
1159     }
1160     
1161     /**
1162      * @dev Returns true if the account is excluded, and false otherwise.
1163      */
1164     function isExcluded(address account) public view returns (bool) {
1165         return excludeList[account];
1166     }
1167     
1168     receive() external payable {}
1169 }