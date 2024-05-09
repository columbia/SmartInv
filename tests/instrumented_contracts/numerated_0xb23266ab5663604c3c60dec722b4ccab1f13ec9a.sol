1 /**
2 
3 Hi Frens,
4 
5 Solana will crash. Even more then now.
6 
7 You have seen what LUNC did and now FTTC.
8 
9 So get your Solana Classic for cheap while you can - $SOLC
10 
11 0% TAX
12 3% MAX WALLET
13 
14 Will be Locked & Renounced
15 
16 
17 Socials & Website:
18 
19 Website: https://solanaclassic.tech
20 Telegram: https://t.me/SolanaClassicEntry
21 Twitter: https://twitter.com/SolanaClassic
22 
23 
24 
25 
26 
27  */
28 // SPDX-License-Identifier: MIT
29 
30 
31 pragma solidity ^0.8.9;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(
91         address sender,
92         address recipient,
93         uint256 amount
94     ) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 /**
112  * @dev Interface for the optional metadata functions from the ERC20 standard.
113  *
114  * _Available since v4.1._
115  */
116 interface IERC20Metadata is IERC20 {
117     /**
118      * @dev Returns the name of the token.
119      */
120     function name() external view returns (string memory);
121 
122     /**
123      * @dev Returns the symbol of the token.
124      */
125     function symbol() external view returns (string memory);
126 
127     /**
128      * @dev Returns the decimals places of the token.
129      */
130     function decimals() external view returns (uint8);
131 }
132 
133 /*
134  * @dev Provides information about the current execution context, including the
135  * sender of the transaction and its data. While these are generally available
136  * via msg.sender and msg.data, they should not be accessed in such a direct
137  * manner, since when dealing with meta-transactions the account sending and
138  * paying for execution may not be the actual sender (as far as an application
139  * is concerned).
140  *
141  * This contract is only required for intermediate, library-like contracts.
142  */
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         return msg.data;
150     }
151 }
152 
153 /**
154  * @dev Implementation of the {IERC20} interface.
155  *
156  * This implementation is agnostic to the way tokens are created. This means
157  * that a supply mechanism has to be added in a derived contract using {_mint}.
158  * For a generic mechanism see {ERC20PresetMinterPauser}.
159  *
160  * TIP: For a detailed writeup see our guide
161  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
162  * to implement supply mechanisms].
163  *
164  * We have followed general OpenZeppelin guidelines: functions revert instead
165  * of returning `false` on failure. This behavior is nonetheless conventional
166  * and does not conflict with the expectations of ERC20 applications.
167  *
168  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
169  * This allows applications to reconstruct the allowance for all accounts just
170  * by listening to said events. Other implementations of the EIP may not emit
171  * these events, as it isn't required by the specification.
172  *
173  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
174  * functions have been added to mitigate the well-known issues around setting
175  * allowances. See {IERC20-approve}.
176  */
177 contract ERC20 is Context, IERC20, IERC20Metadata {
178     mapping(address => uint256) private _balances;
179 
180     mapping(address => mapping(address => uint256)) private _allowances;
181 
182     uint256 private _totalSupply;
183 
184     string private _name;
185     string private _symbol;
186 
187     /**
188      * @dev Sets the values for {name} and {symbol}.
189      *
190      * The default value of {decimals} is 18. To select a different value for
191      * {decimals} you should overload it.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200 
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207 
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215 
216     /**
217      * @dev Returns the number of decimals used to get its user representation.
218      * For example, if `decimals` equals `2`, a balance of `505` tokens should
219      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
220      *
221      * Tokens usually opt for a value of 18, imitating the relationship between
222      * Ether and Wei. This is the value {ERC20} uses, unless this function is
223      * overridden;
224      *
225      * NOTE: This information is only used for _display_ purposes: it in
226      * no way affects any of the arithmetic of the contract, including
227      * {IERC20-balanceOf} and {IERC20-transfer}.
228      */
229     function decimals() public view virtual override returns (uint8) {
230         return 18;
231     }
232 
233     /**
234      * @dev See {IERC20-totalSupply}.
235      */
236     function totalSupply() public view virtual override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241      * @dev See {IERC20-balanceOf}.
242      */
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     /**
248      * @dev See {IERC20-transfer}.
249      *
250      * Requirements:
251      *
252      * - `recipient` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279    
280     function transferFrom(
281         address sender,
282         address recipient,
283         uint256 amount
284     ) public virtual override returns (bool) {
285         _transfer(sender, recipient, amount);
286 
287         uint256 currentAllowance = _allowances[sender][_msgSender()];
288         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
289         unchecked {
290             _approve(sender, _msgSender(), currentAllowance - amount);
291         }
292 
293         return true;
294     }
295 
296  
297     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
298         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
299         return true;
300     }
301 
302  
303     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
304         uint256 currentAllowance = _allowances[_msgSender()][spender];
305         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
306         unchecked {
307             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
308         }
309 
310         return true;
311     }
312 
313   
314     function _transfer(
315         address sender,
316         address recipient,
317         uint256 amount
318     ) internal virtual {
319         require(sender != address(0), "ERC20: transfer from the zero address");
320         require(recipient != address(0), "ERC20: transfer to the zero address");
321 
322         _beforeTokenTransfer(sender, recipient, amount);
323 
324         uint256 senderBalance = _balances[sender];
325         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
326         unchecked {
327             _balances[sender] = senderBalance - amount;
328         }
329         _balances[recipient] += amount;
330 
331         emit Transfer(sender, recipient, amount);
332 
333         _afterTokenTransfer(sender, recipient, amount);
334     }
335 
336    
337     function _mint(address account, uint256 amount) internal virtual {
338         require(account != address(0), "ERC20: mint to the zero address");
339 
340         _beforeTokenTransfer(address(0), account, amount);
341 
342         _totalSupply += amount;
343         _balances[account] += amount;
344         emit Transfer(address(0), account, amount);
345 
346         _afterTokenTransfer(address(0), account, amount);
347     }
348 
349     /**
350      * @dev Destroys `amount` tokens from `account`, reducing the
351      * total supply.
352      *
353      * Emits a {Transfer} event with `to` set to the zero address.
354      *
355      * Requirements:
356      *
357      * - `account` cannot be the zero address.
358      * - `account` must have at least `amount` tokens.
359      */
360     function _burn(address account, uint256 amount) internal virtual {
361         require(account != address(0), "ERC20: burn from the zero address");
362 
363         _beforeTokenTransfer(account, address(0), amount);
364 
365         uint256 accountBalance = _balances[account];
366         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
367         unchecked {
368             _balances[account] = accountBalance - amount;
369         }
370         _totalSupply -= amount;
371 
372         emit Transfer(account, address(0), amount);
373 
374         _afterTokenTransfer(account, address(0), amount);
375     }
376 
377     /**
378      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
379      *
380      * This internal function is equivalent to `approve`, and can be used to
381      * e.g. set automatic allowances for certain subsystems, etc.
382      *
383      * Emits an {Approval} event.
384      *
385      * Requirements:
386      *
387      * - `owner` cannot be the zero address.
388      * - `spender` cannot be the zero address.
389      */
390     function _approve(
391         address owner,
392         address spender,
393         uint256 amount
394     ) internal virtual {
395         require(owner != address(0), "ERC20: approve from the zero address");
396         require(spender != address(0), "ERC20: approve to the zero address");
397 
398         _allowances[owner][spender] = amount;
399         emit Approval(owner, spender, amount);
400     }
401 
402     /**
403      * @dev Hook that is called before any transfer of tokens. This includes
404      * minting and burning.
405      *
406      * Calling conditions:
407      *
408      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
409      * will be transferred to `to`.
410      * - when `from` is zero, `amount` tokens will be minted for `to`.
411      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
412      * - `from` and `to` are never both zero.
413      *
414      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
415      */
416     function _beforeTokenTransfer(
417         address from,
418         address to,
419         uint256 amount
420     ) internal virtual {}
421 
422     /**
423      * @dev Hook that is called after any transfer of tokens. This includes
424      * minting and burning.
425      *
426      * Calling conditions:
427      *
428      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
429      * has been transferred to `to`.
430      * - when `from` is zero, `amount` tokens have been minted for `to`.
431      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
432      * - `from` and `to` are never both zero.
433      *
434      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
435      */
436     function _afterTokenTransfer(
437         address from,
438         address to,
439         uint256 amount
440     ) internal virtual {}
441 }
442 
443 /**
444  * @dev Contract module which provides a basic access control mechanism, where
445  * there is an account (an owner) that can be granted exclusive access to
446  * specific functions.
447  *
448  * By default, the owner account will be the one that deploys the contract. This
449  * can later be changed with {transferOwnership}.
450  *
451  * This module is used through inheritance. It will make available the modifier
452  * `onlyOwner`, which can be applied to your functions to restrict their use to
453  * the owner.
454  */
455 abstract contract Ownable is Context {
456     address private _owner;
457 
458     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
459 
460     /**
461      * @dev Initializes the contract setting the deployer as the initial owner.
462      */
463     constructor() {
464     }
465 
466     /**
467      * @dev Returns the address of the current owner.
468      */
469     function owner() public view virtual returns (address) {
470         return _owner;
471     }
472 
473     /**
474      * @dev Throws if called by any account other than the owner.
475      */
476     modifier onlyOwner() {
477         require(owner() == _msgSender(), "Ownable: caller is not the owner");
478         _;
479     }
480 
481     /**
482      * @dev Leaves the contract without owner. It will not be possible to call
483      * `onlyOwner` functions anymore. Can only be called by the current owner.
484      *
485      * NOTE: Renouncing ownership will leave the contract without an owner,
486      * thereby removing any functionality that is only available to the owner.
487      */
488     function renounceOwnership() public virtual onlyOwner {
489         _setOwner(address(0));
490     }
491 
492     /**
493      * @dev Transfers ownership of the contract to a new account (`newOwner`).
494      * Can only be called by the current owner.
495      */
496     function transferOwnership(address newOwner) public virtual onlyOwner {
497         require(newOwner != address(0), "Ownable: new owner is the zero address");
498         _setOwner(newOwner);
499     }
500 
501     function _setOwner(address newOwner) internal {
502         address oldOwner = _owner;
503         _owner = newOwner;
504         emit OwnershipTransferred(oldOwner, newOwner);
505     }
506 }
507 
508 /**
509  * @dev Contract module which allows children to implement an emergency stop
510  * mechanism that can be triggered by an authorized account.
511  *
512  * This module is used through inheritance. It will make available the
513  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
514  * the functions of your contract. Note that they will not be pausable by
515  * simply including this module, only once the modifiers are put in place.
516  */
517 abstract contract Pausable is Context {
518     /**
519      * @dev Emitted when the pause is triggered by `account`.
520      */
521     event Paused(address account);
522 
523     /**
524      * @dev Emitted when the pause is lifted by `account`.
525      */
526     event Unpaused(address account);
527 
528     bool private _paused;
529 
530     /**
531      * @dev Initializes the contract in unpaused state.
532      */
533     constructor() {
534         _paused = false;
535     }
536 
537     /**
538      * @dev Returns true if the contract is paused, and false otherwise.
539      */
540     function paused() public view virtual returns (bool) {
541         return _paused;
542     }
543 
544     /**
545      * @dev Modifier to make a function callable only when the contract is not paused.
546      *
547      * Requirements:
548      *
549      * - The contract must not be paused.
550      */
551     modifier whenNotPaused() {
552         require(!paused(), "Pausable: paused");
553         _;
554     }
555 
556     /**
557      * @dev Modifier to make a function callable only when the contract is paused.
558      *
559      * Requirements:
560      *
561      * - The contract must be paused.
562      */
563     modifier whenPaused() {
564         require(paused(), "Pausable: not paused");
565         _;
566     }
567 
568     /**
569      * @dev Triggers stopped state.
570      *
571      * Requirements:
572      *
573      * - The contract must not be paused.
574      */
575     function _pause() internal virtual whenNotPaused {
576         _paused = true;
577         emit Paused(_msgSender());
578     }
579 
580     /**
581      * @dev Returns to normal state.
582      *
583      * Requirements:
584      *
585      * - The contract must be paused.
586      */
587     function _unpause() internal virtual whenPaused {
588         _paused = false;
589         emit Unpaused(_msgSender());
590     }
591 }
592 
593 interface IUniswapV2Pair {
594     event Approval(address indexed owner, address indexed spender, uint value);
595     event Transfer(address indexed from, address indexed to, uint value);
596 
597     function name() external pure returns (string memory);
598     function symbol() external pure returns (string memory);
599     function decimals() external pure returns (uint8);
600     function totalSupply() external view returns (uint);
601     function balanceOf(address owner) external view returns (uint);
602     function allowance(address owner, address spender) external view returns (uint);
603 
604     function approve(address spender, uint value) external returns (bool);
605     function transfer(address to, uint value) external returns (bool);
606     function transferFrom(address from, address to, uint value) external returns (bool);
607 
608     function DOMAIN_SEPARATOR() external view returns (bytes32);
609     function PERMIT_TYPEHASH() external pure returns (bytes32);
610     function nonces(address owner) external view returns (uint);
611 
612     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
613 
614     event Mint(address indexed sender, uint amount0, uint amount1);
615     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
616     event Swap(
617         address indexed sender,
618         uint amount0In,
619         uint amount1In,
620         uint amount0Out,
621         uint amount1Out,
622         address indexed to
623     );
624     event Sync(uint112 reserve0, uint112 reserve1);
625 
626     function MINIMUM_LIQUIDITY() external pure returns (uint);
627     function factory() external view returns (address);
628     function token0() external view returns (address);
629     function token1() external view returns (address);
630     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
631     function price0CumulativeLast() external view returns (uint);
632     function price1CumulativeLast() external view returns (uint);
633     function kLast() external view returns (uint);
634 
635     function mint(address to) external returns (uint liquidity);
636     function burn(address to) external returns (uint amount0, uint amount1);
637     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
638     function skim(address to) external;
639     function sync() external;
640 
641     function initialize(address, address) external;
642 }
643 
644 interface IUniswapV2Factory {
645     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
646 
647     function feeTo() external view returns (address);
648     function feeToSetter() external view returns (address);
649 
650     function getPair(address tokenA, address tokenB) external view returns (address pair);
651     function allPairs(uint) external view returns (address pair);
652     function allPairsLength() external view returns (uint);
653 
654     function createPair(address tokenA, address tokenB) external returns (address pair);
655 
656     function setFeeTo(address) external;
657     function setFeeToSetter(address) external;
658 }
659 
660 interface IUniswapV2Router01 {
661     function factory() external pure returns (address);
662     function WETH() external pure returns (address);
663 
664     function addLiquidity(
665         address tokenA,
666         address tokenB,
667         uint amountADesired,
668         uint amountBDesired,
669         uint amountAMin,
670         uint amountBMin,
671         address to,
672         uint deadline
673     ) external returns (uint amountA, uint amountB, uint liquidity);
674     function addLiquidityETH(
675         address token,
676         uint amountTokenDesired,
677         uint amountTokenMin,
678         uint amountETHMin,
679         address to,
680         uint deadline
681     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
682     function removeLiquidity(
683         address tokenA,
684         address tokenB,
685         uint liquidity,
686         uint amountAMin,
687         uint amountBMin,
688         address to,
689         uint deadline
690     ) external returns (uint amountA, uint amountB);
691     function removeLiquidityETH(
692         address token,
693         uint liquidity,
694         uint amountTokenMin,
695         uint amountETHMin,
696         address to,
697         uint deadline
698     ) external returns (uint amountToken, uint amountETH);
699     function removeLiquidityWithPermit(
700         address tokenA,
701         address tokenB,
702         uint liquidity,
703         uint amountAMin,
704         uint amountBMin,
705         address to,
706         uint deadline,
707         bool approveMax, uint8 v, bytes32 r, bytes32 s
708     ) external returns (uint amountA, uint amountB);
709     function removeLiquidityETHWithPermit(
710         address token,
711         uint liquidity,
712         uint amountTokenMin,
713         uint amountETHMin,
714         address to,
715         uint deadline,
716         bool approveMax, uint8 v, bytes32 r, bytes32 s
717     ) external returns (uint amountToken, uint amountETH);
718     function swapExactTokensForTokens(
719         uint amountIn,
720         uint amountOutMin,
721         address[] calldata path,
722         address to,
723         uint deadline
724     ) external returns (uint[] memory amounts);
725     function swapTokensForExactTokens(
726         uint amountOut,
727         uint amountInMax,
728         address[] calldata path,
729         address to,
730         uint deadline
731     ) external returns (uint[] memory amounts);
732     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
733         external
734         payable
735         returns (uint[] memory amounts);
736     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
737         external
738         returns (uint[] memory amounts);
739     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
740         external
741         returns (uint[] memory amounts);
742     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
743         external
744         payable
745         returns (uint[] memory amounts);
746 
747     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
748     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
749     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
750     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
751     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
752 }
753 
754 interface IUniswapV2Router02 is IUniswapV2Router01 {
755     function removeLiquidityETHSupportingFeeOnTransferTokens(
756         address token,
757         uint liquidity,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline
762     ) external returns (uint amountETH);
763     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
764         address token,
765         uint liquidity,
766         uint amountTokenMin,
767         uint amountETHMin,
768         address to,
769         uint deadline,
770         bool approveMax, uint8 v, bytes32 r, bytes32 s
771     ) external returns (uint amountETH);
772 
773     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
774         uint amountIn,
775         uint amountOutMin,
776         address[] calldata path,
777         address to,
778         uint deadline
779     ) external;
780     function swapExactETHForTokensSupportingFeeOnTransferTokens(
781         uint amountOutMin,
782         address[] calldata path,
783         address to,
784         uint deadline
785     ) external payable;
786     function swapExactTokensForETHSupportingFeeOnTransferTokens(
787         uint amountIn,
788         uint amountOutMin,
789         address[] calldata path,
790         address to,
791         uint deadline
792     ) external;
793 }
794 
795 contract SolanaClassic is ERC20, Ownable, Pausable {
796 
797     // variables
798     
799     uint256 private initialSupply;
800    
801     uint256 private denominator = 100;
802 
803     uint256 private swapThreshold = 0.0000005 ether; //
804     
805     uint256 private devTaxBuy;
806     uint256 private liquidityTaxBuy;
807    
808     
809     uint256 private devTaxSell;
810     uint256 private liquidityTaxSell;
811     uint256 public maxWallet;
812     
813     address private devTaxWallet;
814     address private liquidityTaxWallet;
815     
816     
817     // Mappings
818     
819     mapping (address => bool) private blacklist;
820     mapping (address => bool) private excludeList;
821    
822     
823     mapping (string => uint256) private buyTaxes;
824     mapping (string => uint256) private sellTaxes;
825     mapping (string => address) private taxWallets;
826     
827     bool public taxStatus = true;
828     
829     IUniswapV2Router02 private uniswapV2Router02;
830     IUniswapV2Factory private uniswapV2Factory;
831     IUniswapV2Pair private uniswapV2Pair;
832     
833     constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply) ERC20(_tokenName, _tokenSymbol) payable
834     {
835         initialSupply =_supply * (10**18);
836         maxWallet = initialSupply * 3 / 100; //
837         _setOwner(msg.sender);
838         uniswapV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
839         uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
840         uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));
841         taxWallets["liquidity"] = address(0);
842         setBuyTax(0,0); //dev tax, liquidity tax
843         setSellTax(0,0); //dev tax, liquidity tax
844         setTaxWallets(0xbdef53A8bd15338dc1667E45Df92beED63915F1e); // replace this with your wallet
845         exclude(msg.sender);
846         exclude(address(this));
847         exclude(devTaxWallet);
848         _mint(msg.sender, initialSupply);
849     }
850     
851     
852     uint256 private devTokens;
853     uint256 private liquidityTokens;
854     
855     
856     /**
857      * @dev Calculates the tax, transfer it to the contract. If the user is selling, and the swap threshold is met, it executes the tax.
858      */
859     function handleTax(address from, address to, uint256 amount) private returns (uint256) {
860         address[] memory sellPath = new address[](2);
861         sellPath[0] = address(this);
862         sellPath[1] = uniswapV2Router02.WETH();
863         
864         if(!isExcluded(from) && !isExcluded(to)) {
865             uint256 tax;
866             uint256 baseUnit = amount / denominator;
867             if(from == address(uniswapV2Pair)) {
868                 tax += baseUnit * buyTaxes["dev"];
869                 tax += baseUnit * buyTaxes["liquidity"];
870                
871                 
872                 if(tax > 0) {
873                     _transfer(from, address(this), tax);   
874                 }
875                 
876                 
877                 devTokens += baseUnit * buyTaxes["dev"];
878                 liquidityTokens += baseUnit * buyTaxes["liquidity"];
879 
880             } else if(to == address(uniswapV2Pair)) {
881                 
882                 tax += baseUnit * sellTaxes["dev"];
883                 tax += baseUnit * sellTaxes["liquidity"];
884                 
885                 
886                 if(tax > 0) {
887                     _transfer(from, address(this), tax);   
888                 }
889                 
890                
891                 devTokens += baseUnit * sellTaxes["dev"];
892                 liquidityTokens += baseUnit * sellTaxes["liquidity"];
893                 
894                 
895                 uint256 taxSum =  devTokens + liquidityTokens;
896                 
897                 if(taxSum == 0) return amount;
898                 
899                 uint256 ethValue = uniswapV2Router02.getAmountsOut( devTokens + liquidityTokens, sellPath)[1];
900                 
901                 if(ethValue >= swapThreshold) {
902                     uint256 startBalance = address(this).balance;
903 
904                     uint256 toSell = devTokens + liquidityTokens / 2 ;
905                     
906                     _approve(address(this), address(uniswapV2Router02), toSell);
907             
908                     uniswapV2Router02.swapExactTokensForETH(
909                         toSell,
910                         0,
911                         sellPath,
912                         address(this),
913                         block.timestamp
914                     );
915                     
916                     uint256 ethGained = address(this).balance - startBalance;
917                     
918                     uint256 liquidityToken = liquidityTokens / 2;
919                     uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
920                     
921                     
922                     uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
923                    
924                     
925                     _approve(address(this), address(uniswapV2Router02), liquidityToken);
926                     
927                     uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
928                         address(this),
929                         liquidityToken,
930                         0,
931                         0,
932                         taxWallets["liquidity"],
933                         block.timestamp
934                     );
935                     
936                     uint256 remainingTokens = (devTokens + liquidityTokens) - (toSell + liquidityToken);
937                     
938                     if(remainingTokens > 0) {
939                         _transfer(address(this), taxWallets["dev"], remainingTokens);
940                     }
941                     
942                     
943                    (bool success,) = taxWallets["dev"].call{value: devETH}("");
944                    require(success, "transfer to  dev wallet failed");
945                     
946                     
947                     if(ethGained - ( devETH + liquidityETH) > 0) {
948                        (bool success1,) = taxWallets["dev"].call{value: ethGained - (devETH + liquidityETH)}("");
949                         require(success1, "transfer to  dev wallet failed");
950                     }
951 
952                     
953                     
954                     
955                     devTokens = 0;
956                     liquidityTokens = 0;
957                     
958                 }
959                 
960             }
961             
962             amount -= tax;
963             if (to != address(uniswapV2Pair)){
964                 require(balanceOf(to) + amount <= maxWallet, "maxWallet limit exceeded");
965             }
966            
967         }
968         
969         return amount;
970     }
971     
972     function _transfer(
973         address sender,
974         address recipient,
975         uint256 amount
976     ) internal override virtual {
977         require(!paused(), "ERC20: token transfer while paused");
978         require(!isBlacklisted(msg.sender), "ERC20: sender blacklisted");
979         require(!isBlacklisted(recipient), "ERC20: recipient blacklisted");
980         require(!isBlacklisted(tx.origin), "ERC20: sender blacklisted");
981         
982         if(taxStatus) {
983             amount = handleTax(sender, recipient, amount);   
984         }
985 
986         super._transfer(sender, recipient, amount);
987     }
988     
989     /**
990      * @dev Triggers the tax handling functionality
991      */
992     function triggerTax() public onlyOwner {
993         handleTax(address(0), address(uniswapV2Pair), 0);
994     }
995     
996     /**
997      * @dev Pauses transfers on the token.
998      */
999     function pause() public onlyOwner {
1000         require(!paused(), "ERC20: Contract is already paused");
1001         _pause();
1002     }
1003 
1004     /**
1005      * @dev Unpauses transfers on the token.
1006      */
1007     function unpause() public onlyOwner {
1008         require(paused(), "ERC20: Contract is not paused");
1009         _unpause();
1010     }
1011 
1012      /**
1013      * @dev set max wallet limit per address.
1014      */
1015 
1016     function setMaxWallet (uint256 amount) external onlyOwner {
1017         require (amount > 10000, "NO rug pull");
1018         maxWallet = amount * 10**18;
1019     }
1020     
1021     /**
1022      * @dev Burns tokens from caller address.
1023      */
1024     function burn(uint256 amount) public onlyOwner {
1025         _burn(msg.sender, amount);
1026     }
1027     
1028     /**
1029      * @dev Blacklists the specified account (Disables transfers to and from the account).
1030      */
1031     function enableBlacklist(address account) public onlyOwner {
1032         require(!blacklist[account], "ERC20: Account is already blacklisted");
1033         blacklist[account] = true;
1034     }
1035     
1036     /**
1037      * @dev Remove the specified account from the blacklist.
1038      */
1039     function disableBlacklist(address account) public onlyOwner {
1040         require(blacklist[account], "ERC20: Account is not blacklisted");
1041         blacklist[account] = false;
1042     }
1043     
1044     /**
1045      * @dev Excludes the specified account from tax.
1046      */
1047     function exclude(address account) public onlyOwner {
1048         require(!isExcluded(account), "ERC20: Account is already excluded");
1049         excludeList[account] = true;
1050     }
1051     
1052     /**
1053      * @dev Re-enables tax on the specified account.
1054      */
1055     function removeExclude(address account) public onlyOwner {
1056         require(isExcluded(account), "ERC20: Account is not excluded");
1057         excludeList[account] = false;
1058     }
1059     
1060     /**
1061      * @dev Sets tax for buys.
1062      */
1063     function setBuyTax(uint256 dev,uint256 liquidity) public onlyOwner {
1064         buyTaxes["dev"] = dev;
1065         buyTaxes["liquidity"] = liquidity;
1066        
1067     }
1068     
1069     /**
1070      * @dev Sets tax for sells.
1071      */
1072     function setSellTax(uint256 dev, uint256 liquidity) public onlyOwner {
1073 
1074         sellTaxes["dev"] = dev;
1075         sellTaxes["liquidity"] = liquidity;
1076         
1077     }
1078     
1079     /**
1080      * @dev Sets wallets for taxes.
1081      */
1082     function setTaxWallets(address dev) public onlyOwner {
1083         taxWallets["dev"] = dev;
1084         
1085     }
1086 
1087     function claimStuckTokens(address _token) external onlyOwner {
1088  
1089         if (_token == address(0x0)) {
1090             payable(owner()).transfer(address(this).balance);
1091             return;
1092         }
1093         IERC20 erc20token = IERC20(_token);
1094         uint256 balance = erc20token.balanceOf(address(this));
1095         erc20token.transfer(owner(), balance);
1096     }
1097     
1098     /**
1099      * @dev Enables tax globally.
1100      */
1101     function enableTax() public onlyOwner {
1102         require(!taxStatus, "ERC20: Tax is already enabled");
1103         taxStatus = true;
1104     }
1105     
1106     /**
1107      * @dev Disables tax globally.
1108      */
1109     function disableTax() public onlyOwner {
1110         require(taxStatus, "ERC20: Tax is already disabled");
1111         taxStatus = false;
1112     }
1113     
1114     /**
1115      * @dev Returns true if the account is blacklisted, and false otherwise.
1116      */
1117     function isBlacklisted(address account) public view returns (bool) {
1118         return blacklist[account];
1119     }
1120     
1121     /**
1122      * @dev Returns true if the account is excluded, and false otherwise.
1123      */
1124     function isExcluded(address account) public view returns (bool) {
1125         return excludeList[account];
1126     }
1127     
1128     receive() external payable {}
1129 }