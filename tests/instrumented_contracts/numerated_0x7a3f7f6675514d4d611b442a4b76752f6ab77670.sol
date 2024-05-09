1 // SPDX-License-Identifier: Unlicensed
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         _checkOwner();
66         _;
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     function _checkOwner() internal view virtual {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Interface of the ERC20 standard as defined in the EIP.
123  */
124 interface IERC20 {
125     /**
126      * @dev Emitted when `value` tokens are moved from one account (`from`) to
127      * another (`to`).
128      *
129      * Note that `value` may be zero.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 
133     /**
134      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
135      * a call to {approve}. `value` is the new allowance.
136      */
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 
139     /**
140      * @dev Returns the amount of tokens in existence.
141      */
142     function totalSupply() external view returns (uint256);
143 
144     /**
145      * @dev Returns the amount of tokens owned by `account`.
146      */
147     function balanceOf(address account) external view returns (uint256);
148 
149     /**
150      * @dev Moves `amount` tokens from the caller's account to `to`.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transfer(address to, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Returns the remaining number of tokens that `spender` will be
160      * allowed to spend on behalf of `owner` through {transferFrom}. This is
161      * zero by default.
162      *
163      * This value changes when {approve} or {transferFrom} are called.
164      */
165     function allowance(address owner, address spender) external view returns (uint256);
166 
167     /**
168      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * IMPORTANT: Beware that changing an allowance with this method brings the risk
173      * that someone may use both the old and the new allowance by unfortunate
174      * transaction ordering. One possible solution to mitigate this race
175      * condition is to first reduce the spender's allowance to 0 and set the
176      * desired value afterwards:
177      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178      *
179      * Emits an {Approval} event.
180      */
181     function approve(address spender, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Moves `amount` tokens from `from` to `to` using the
185      * allowance mechanism. `amount` is then deducted from the caller's
186      * allowance.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(
193         address from,
194         address to,
195         uint256 amount
196     ) external returns (bool);
197 }
198 
199 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 
207 /**
208  * @dev Interface for the optional metadata functions from the ERC20 standard.
209  *
210  * _Available since v4.1._
211  */
212 interface IERC20Metadata is IERC20 {
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the symbol of the token.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the decimals places of the token.
225      */
226     function decimals() external view returns (uint8);
227 }
228 
229 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
230 
231 
232 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 
237 
238 
239 /**
240  * @dev Implementation of the {IERC20} interface.
241  *
242  * This implementation is agnostic to the way tokens are created. This means
243  * that a supply mechanism has to be added in a derived contract using {_mint}.
244  * For a generic mechanism see {ERC20PresetMinterPauser}.
245  *
246  * TIP: For a detailed writeup see our guide
247  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
248  * to implement supply mechanisms].
249  *
250  * We have followed general OpenZeppelin Contracts guidelines: functions revert
251  * instead returning `false` on failure. This behavior is nonetheless
252  * conventional and does not conflict with the expectations of ERC20
253  * applications.
254  *
255  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
256  * This allows applications to reconstruct the allowance for all accounts just
257  * by listening to said events. Other implementations of the EIP may not emit
258  * these events, as it isn't required by the specification.
259  *
260  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
261  * functions have been added to mitigate the well-known issues around setting
262  * allowances. See {IERC20-approve}.
263  */
264 contract ERC20 is Context, IERC20, IERC20Metadata {
265     mapping(address => uint256) private _balances;
266 
267     mapping(address => mapping(address => uint256)) private _allowances;
268 
269     uint256 private _totalSupply;
270 
271     string private _name;
272     string private _symbol;
273 
274     /**
275      * @dev Sets the values for {name} and {symbol}.
276      *
277      * The default value of {decimals} is 18. To select a different value for
278      * {decimals} you should overload it.
279      *
280      * All two of these values are immutable: they can only be set once during
281      * construction.
282      */
283     constructor(string memory name_, string memory symbol_) {
284         _name = name_;
285         _symbol = symbol_;
286     }
287 
288     /**
289      * @dev Returns the name of the token.
290      */
291     function name() public view virtual override returns (string memory) {
292         return _name;
293     }
294 
295     /**
296      * @dev Returns the symbol of the token, usually a shorter version of the
297      * name.
298      */
299     function symbol() public view virtual override returns (string memory) {
300         return _symbol;
301     }
302 
303     /**
304      * @dev Returns the number of decimals used to get its user representation.
305      * For example, if `decimals` equals `2`, a balance of `505` tokens should
306      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
307      *
308      * Tokens usually opt for a value of 18, imitating the relationship between
309      * Ether and Wei. This is the value {ERC20} uses, unless this function is
310      * overridden;
311      *
312      * NOTE: This information is only used for _display_ purposes: it in
313      * no way affects any of the arithmetic of the contract, including
314      * {IERC20-balanceOf} and {IERC20-transfer}.
315      */
316     function decimals() public view virtual override returns (uint8) {
317         return 18;
318     }
319 
320     /**
321      * @dev See {IERC20-totalSupply}.
322      */
323     function totalSupply() public view virtual override returns (uint256) {
324         return _totalSupply;
325     }
326 
327     /**
328      * @dev See {IERC20-balanceOf}.
329      */
330     function balanceOf(address account) public view virtual override returns (uint256) {
331         return _balances[account];
332     }
333 
334     /**
335      * @dev See {IERC20-transfer}.
336      *
337      * Requirements:
338      *
339      * - `to` cannot be the zero address.
340      * - the caller must have a balance of at least `amount`.
341      */
342     function transfer(address to, uint256 amount) public virtual override returns (bool) {
343         address owner = _msgSender();
344         _transfer(owner, to, amount);
345         return true;
346     }
347 
348     /**
349      * @dev See {IERC20-allowance}.
350      */
351     function allowance(address owner, address spender) public view virtual override returns (uint256) {
352         return _allowances[owner][spender];
353     }
354 
355     /**
356      * @dev See {IERC20-approve}.
357      *
358      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
359      * `transferFrom`. This is semantically equivalent to an infinite approval.
360      *
361      * Requirements:
362      *
363      * - `spender` cannot be the zero address.
364      */
365     function approve(address spender, uint256 amount) public virtual override returns (bool) {
366         address owner = _msgSender();
367         _approve(owner, spender, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-transferFrom}.
373      *
374      * Emits an {Approval} event indicating the updated allowance. This is not
375      * required by the EIP. See the note at the beginning of {ERC20}.
376      *
377      * NOTE: Does not update the allowance if the current allowance
378      * is the maximum `uint256`.
379      *
380      * Requirements:
381      *
382      * - `from` and `to` cannot be the zero address.
383      * - `from` must have a balance of at least `amount`.
384      * - the caller must have allowance for ``from``'s tokens of at least
385      * `amount`.
386      */
387     function transferFrom(
388         address from,
389         address to,
390         uint256 amount
391     ) public virtual override returns (bool) {
392         address spender = _msgSender();
393         _spendAllowance(from, spender, amount);
394         _transfer(from, to, amount);
395         return true;
396     }
397 
398     /**
399      * @dev Atomically increases the allowance granted to `spender` by the caller.
400      *
401      * This is an alternative to {approve} that can be used as a mitigation for
402      * problems described in {IERC20-approve}.
403      *
404      * Emits an {Approval} event indicating the updated allowance.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      */
410     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
411         address owner = _msgSender();
412         _approve(owner, spender, allowance(owner, spender) + addedValue);
413         return true;
414     }
415 
416     /**
417      * @dev Atomically decreases the allowance granted to `spender` by the caller.
418      *
419      * This is an alternative to {approve} that can be used as a mitigation for
420      * problems described in {IERC20-approve}.
421      *
422      * Emits an {Approval} event indicating the updated allowance.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      * - `spender` must have allowance for the caller of at least
428      * `subtractedValue`.
429      */
430     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
431         address owner = _msgSender();
432         uint256 currentAllowance = allowance(owner, spender);
433         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
434         unchecked {
435             _approve(owner, spender, currentAllowance - subtractedValue);
436         }
437 
438         return true;
439     }
440 
441     /**
442      * @dev Moves `amount` of tokens from `from` to `to`.
443      *
444      * This internal function is equivalent to {transfer}, and can be used to
445      * e.g. implement automatic token fees, slashing mechanisms, etc.
446      *
447      * Emits a {Transfer} event.
448      *
449      * Requirements:
450      *
451      * - `from` cannot be the zero address.
452      * - `to` cannot be the zero address.
453      * - `from` must have a balance of at least `amount`.
454      */
455     function _transfer(
456         address from,
457         address to,
458         uint256 amount
459     ) internal virtual {
460         require(from != address(0), "ERC20: transfer from the zero address");
461         require(to != address(0), "ERC20: transfer to the zero address");
462 
463         _beforeTokenTransfer(from, to, amount);
464 
465         uint256 fromBalance = _balances[from];
466         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
467         unchecked {
468             _balances[from] = fromBalance - amount;
469         }
470         _balances[to] += amount;
471 
472         emit Transfer(from, to, amount);
473 
474         _afterTokenTransfer(from, to, amount);
475     }
476 
477     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
478      * the total supply.
479      *
480      * Emits a {Transfer} event with `from` set to the zero address.
481      *
482      * Requirements:
483      *
484      * - `account` cannot be the zero address.
485      */
486     function _mint(address account, uint256 amount) internal virtual {
487         require(account != address(0), "ERC20: mint to the zero address");
488 
489         _beforeTokenTransfer(address(0), account, amount);
490 
491         _totalSupply += amount;
492         _balances[account] += amount;
493         emit Transfer(address(0), account, amount);
494 
495         _afterTokenTransfer(address(0), account, amount);
496     }
497 
498     /**
499      * @dev Destroys `amount` tokens from `account`, reducing the
500      * total supply.
501      *
502      * Emits a {Transfer} event with `to` set to the zero address.
503      *
504      * Requirements:
505      *
506      * - `account` cannot be the zero address.
507      * - `account` must have at least `amount` tokens.
508      */
509     function _burn(address account, uint256 amount) internal virtual {
510         require(account != address(0), "ERC20: burn from the zero address");
511 
512         _beforeTokenTransfer(account, address(0), amount);
513 
514         uint256 accountBalance = _balances[account];
515         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
516         unchecked {
517             _balances[account] = accountBalance - amount;
518         }
519         _totalSupply -= amount;
520 
521         emit Transfer(account, address(0), amount);
522 
523         _afterTokenTransfer(account, address(0), amount);
524     }
525 
526     /**
527      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
528      *
529      * This internal function is equivalent to `approve`, and can be used to
530      * e.g. set automatic allowances for certain subsystems, etc.
531      *
532      * Emits an {Approval} event.
533      *
534      * Requirements:
535      *
536      * - `owner` cannot be the zero address.
537      * - `spender` cannot be the zero address.
538      */
539     function _approve(
540         address owner,
541         address spender,
542         uint256 amount
543     ) internal virtual {
544         require(owner != address(0), "ERC20: approve from the zero address");
545         require(spender != address(0), "ERC20: approve to the zero address");
546 
547         _allowances[owner][spender] = amount;
548         emit Approval(owner, spender, amount);
549     }
550 
551     /**
552      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
553      *
554      * Does not update the allowance amount in case of infinite allowance.
555      * Revert if not enough allowance is available.
556      *
557      * Might emit an {Approval} event.
558      */
559     function _spendAllowance(
560         address owner,
561         address spender,
562         uint256 amount
563     ) internal virtual {
564         uint256 currentAllowance = allowance(owner, spender);
565         if (currentAllowance != type(uint256).max) {
566             require(currentAllowance >= amount, "ERC20: insufficient allowance");
567             unchecked {
568                 _approve(owner, spender, currentAllowance - amount);
569             }
570         }
571     }
572 
573     /**
574      * @dev Hook that is called before any transfer of tokens. This includes
575      * minting and burning.
576      *
577      * Calling conditions:
578      *
579      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
580      * will be transferred to `to`.
581      * - when `from` is zero, `amount` tokens will be minted for `to`.
582      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
583      * - `from` and `to` are never both zero.
584      *
585      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
586      */
587     function _beforeTokenTransfer(
588         address from,
589         address to,
590         uint256 amount
591     ) internal virtual {}
592 
593     /**
594      * @dev Hook that is called after any transfer of tokens. This includes
595      * minting and burning.
596      *
597      * Calling conditions:
598      *
599      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
600      * has been transferred to `to`.
601      * - when `from` is zero, `amount` tokens have been minted for `to`.
602      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
603      * - `from` and `to` are never both zero.
604      *
605      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
606      */
607     function _afterTokenTransfer(
608         address from,
609         address to,
610         uint256 amount
611     ) internal virtual {}
612 }
613 
614 // File: TORA.sol
615 
616 
617 pragma solidity ^0.8.0;
618 
619 
620 
621 interface IUniswapV2Router01 {
622     function factory() external pure returns (address);
623     function WETH() external pure returns (address);
624     function addLiquidityETH(address token,uint amountTokenDesired,uint amountTokenMin,uint amountETHMin,address to,uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
625 } 
626 
627 interface IUniswapV2Router02 is IUniswapV2Router01 {
628     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external;
629 }
630 
631 interface IUniswapV2Factory {
632      function createPair(address tokenA, address tokenB) external returns (address pair);
633 }
634 
635 
636 contract TORA is ERC20, Ownable {
637     IUniswapV2Router02 public uniswapV2Router;
638     
639     bool private swapping;
640     
641     uint256 public swapTokensAtAmount = 500_000 * (10**18);
642 
643     uint256 public purchaseMarketingFee = 0;
644     uint256 public purchaseLiquidityFee = 0;
645     uint256 public purchaseBurnFee = 0;
646 
647     uint256 public sellMarketingFee = 6;
648     uint256 public sellLiquidityFee = 4;
649     uint256 public sellBurnFee = 1;
650 
651     uint256 public maxTxAmount = 3_000_000 ether;
652 
653     uint256 public pendingMarketingFee;
654     uint256 public pendingBurnFee;
655     uint256 public pendingLiguidityFee;
656     
657     address public marketingWallet = 0x180E6b05e0cA53CaE4f2cC2783886D107b278427;
658     address public uniswapV2Pair; 
659 
660     mapping (address => bool) private _isExcludedFromFees;
661     mapping (address => bool) public automatedMarketMakerPairs;
662 
663     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
664     event ExcludeFromFees(address indexed account, bool isExcluded);
665     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
666     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
667 
668     event SwapAndLiquify(
669         uint256 tokensSwapped,
670         uint256 ethReceived,
671         uint256 tokensIntoLiqudity
672     );
673 
674     constructor() ERC20("Tora Inu", "TORA") {
675 
676     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
677         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
678             .createPair(address(this), _uniswapV2Router.WETH());
679 
680         uniswapV2Router = _uniswapV2Router;
681         uniswapV2Pair = _uniswapV2Pair;
682 
683         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
684 
685         excludeFromFees(owner(), true); 
686         excludeFromFees(address(this), true);
687         _mint(owner(), 1_000_000_000 * (10**18));
688     }
689 
690     receive() external payable {
691   	}
692 
693  
694     function updateUniswapV2Router(address newAddress) public onlyOwner {
695         require(newAddress != address(uniswapV2Router), "The router already has that address");
696         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
697         uniswapV2Router = IUniswapV2Router02(newAddress);
698         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
699             .createPair(address(this), uniswapV2Router.WETH());
700         uniswapV2Pair = _uniswapV2Pair;
701     }
702 
703     function excludeFromFees(address account, bool excluded) public onlyOwner {
704         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
705         _isExcludedFromFees[account] = excluded;
706         emit ExcludeFromFees(account, excluded);
707     }
708 
709     function excludeMultipleAccountsFromFees(address[] memory accounts, bool excluded) public onlyOwner {
710         for(uint256 i = 0; i < accounts.length; i++) {
711             _isExcludedFromFees[accounts[i]] = excluded;
712         }
713         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
714     }
715 
716     function setSwapTokensAtAmount(uint256 amount) external onlyOwner{
717         swapTokensAtAmount = amount;
718     }
719 
720     function setPurchaseFee(uint _newmarketingfee, uint _newliquidityfee, uint _newburnfee) external onlyOwner {
721         require(_newmarketingfee+_newliquidityfee+_newburnfee<=20, "fee too high");
722         purchaseMarketingFee = _newmarketingfee;
723         purchaseLiquidityFee = _newliquidityfee;
724         purchaseBurnFee = _newburnfee;
725     }
726 
727     function setSellFee(uint _newmarketingfee, uint _newliquidityfee, uint _newburnfee) external onlyOwner {
728         require(_newmarketingfee+_newliquidityfee+_newburnfee<=20, "fee too high");
729         sellMarketingFee = _newmarketingfee;
730         sellLiquidityFee = _newliquidityfee;
731         sellBurnFee = _newburnfee;
732     }
733 
734     function setMaxTxAmount(uint256 _amount) external onlyOwner() {
735         maxTxAmount = _amount;
736     }
737 
738     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
739         require(pair != uniswapV2Pair, "The Uniswap pair cannot be removed from automatedMarketMakerPairs");
740         _setAutomatedMarketMakerPair(pair, value);
741     }
742 
743     function _setAutomatedMarketMakerPair(address pair, bool value) private {
744         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
745         automatedMarketMakerPairs[pair] = value;
746 
747         emit SetAutomatedMarketMakerPair(pair, value);
748     }
749 
750     function swapOnDemand() external onlyOwner {
751         swapping = true;
752         uint256 contractTokenBalanceforlp = pendingLiguidityFee;
753         swapAndLiquify(contractTokenBalanceforlp);
754         swapping = false;
755     }
756 
757     function isExcludedFromFees(address account) public view returns(bool) {
758         return _isExcludedFromFees[account];
759     }
760 
761     function _transfer(
762         address from,
763         address to,
764         uint256 amount
765     ) internal override {
766         require(from != address(0), "ERC20: transfer from the zero address");
767         require(to != address(0), "ERC20: transfer to the zero address");
768 
769         if(amount == 0) {
770             super._transfer(from, to, 0);
771             return;
772         }
773 
774         if (from != owner() && to != owner()) {
775             require(amount <= maxTxAmount ,"transfer: amount exceeds the maxTxAmount");
776         }
777  
778 		uint256 contractTokenBalanceforlp = pendingLiguidityFee;
779         bool canSwap = contractTokenBalanceforlp >= swapTokensAtAmount;
780 
781         if( canSwap &&
782             !swapping &&
783             !automatedMarketMakerPairs[from] &&
784             from != owner() &&
785             to != owner()
786         ) 
787         {
788             swapping = true;
789             swapAndLiquify(contractTokenBalanceforlp);
790             swapAndSendMarketingFee();
791             deflationaryBurn();
792             swapping = false;
793         }
794 
795         bool takeFee = !swapping;
796         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
797             takeFee = false;
798         }
799         
800         if(takeFee) {
801 
802         	if (automatedMarketMakerPairs[from]) {
803                 uint256 mfee = (amount*purchaseMarketingFee)/100;
804                 uint256 lfee = (amount*purchaseLiquidityFee)/100;
805                 uint256 bfee = (amount*purchaseBurnFee)/100;
806 
807                 uint totalfee = mfee + lfee + bfee;
808                 pendingMarketingFee += mfee;
809                 pendingLiguidityFee += lfee;
810                 pendingBurnFee += bfee;
811 
812                 amount = amount - totalfee;
813                 super._transfer(from, address(this), totalfee);
814             }
815 
816             else if (automatedMarketMakerPairs[to]) {
817                 uint256 mfee = (amount*sellMarketingFee)/100;
818                 uint256 lfee = (amount*sellLiquidityFee)/100;
819                 uint256 bfee = (amount*sellBurnFee)/100;
820 
821                 uint totalfee = mfee + lfee + bfee;
822                 pendingMarketingFee += mfee;
823                 pendingLiguidityFee += lfee;
824                 pendingBurnFee += bfee;
825 
826                 amount = amount - totalfee;
827                 super._transfer(from, address(this), totalfee);
828             }
829 
830         }
831         super._transfer(from, to, amount);
832     }
833 
834 
835     function claimMarketingFees() external onlyOwner {
836         uint _pendingMarketingFee = pendingMarketingFee;
837         if (_pendingMarketingFee > 0) 
838         {
839         swapping = true;    
840         swapTokensForEth(_pendingMarketingFee);
841         uint amount = address(this).balance;
842         (bool success, ) = address(marketingWallet).call{ value: amount }("");
843         require(success, "Address: unable to extract value, tx may have reverted");
844         pendingMarketingFee = 0;
845         swapping = false;    
846         }
847     }
848 
849 
850     function deflationaryBurn() public {
851         uint _pendingBurnFee = pendingBurnFee;
852         if (_pendingBurnFee > 0) {
853             _burn(address(this), _pendingBurnFee);
854             pendingBurnFee = 0;
855         } 
856     }
857 
858     function setmarketingWallet(address _walletaddress) external onlyOwner {
859         marketingWallet = _walletaddress;
860     }
861 
862 
863     function swapAndLiquify(uint256 tokens) private {
864         uint256 half = tokens/2;
865         uint256 otherHalf = tokens-(half);
866         uint256 initialBalance = address(this).balance;
867         swapTokensForEth(half);
868         uint256 newBalance = address(this).balance-(initialBalance);
869         addLiquidity(otherHalf, newBalance);
870         pendingLiguidityFee = 0;
871         emit SwapAndLiquify(half, newBalance, otherHalf);
872     }
873 
874     function swapAndSendMarketingFee() private {
875         uint _pendingMarketingFee = pendingMarketingFee;
876         if (_pendingMarketingFee > 0) 
877         {
878         swapTokensForEth(_pendingMarketingFee);
879         uint amount = address(this).balance;
880         (bool success, ) = address(marketingWallet).call{ value: amount }("");
881         require(success, "Address: unable to extract value, tx may have reverted");
882         pendingMarketingFee = 0;
883         }
884     }
885 
886 
887     function swapTokensForEth(uint256 tokenAmount) private {
888         address[] memory path = new address[](2);
889         path[0] = address(this);
890         path[1] = uniswapV2Router.WETH();
891 
892         _approve(address(this), address(uniswapV2Router), tokenAmount);
893         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
894             tokenAmount,
895             0, 
896             path,
897             address(this),
898             block.timestamp
899         );
900     }
901 
902     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
903         _approve(address(this), address(uniswapV2Router), tokenAmount);
904         uniswapV2Router.addLiquidityETH{value: ethAmount}(
905             address(this),
906             tokenAmount,
907             0, 
908             0,
909             owner(),
910             block.timestamp
911         );
912     }
913 
914     function migrateGasToken(address payable _newadd,uint256 amount) public onlyOwner {    
915         (bool success, ) = address(_newadd).call{ value: amount }("");
916         require(success, "Address: unable to extract value, tx may have reverted");    
917     }
918 
919 }