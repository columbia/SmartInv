1 /**
2 Website: https://www.pepurai.com/
3 **/
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.2
29 
30 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         _checkOwner();
63         _;
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if the sender is not the owner.
75      */
76     function _checkOwner() internal view virtual {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby disabling any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         _transferOwnership(address(0));
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Internal function without access restriction.
103      */
104     function _transferOwnership(address newOwner) internal virtual {
105         address oldOwner = _owner;
106         _owner = newOwner;
107         emit OwnershipTransferred(oldOwner, newOwner);
108     }
109 }
110 
111 
112 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.2
113 
114 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Interface of the ERC20 standard as defined in the EIP.
120  */
121 interface IERC20 {
122     /**
123      * @dev Emitted when `value` tokens are moved from one account (`from`) to
124      * another (`to`).
125      *
126      * Note that `value` may be zero.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 
130     /**
131      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
132      * a call to {approve}. `value` is the new allowance.
133      */
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 
136     /**
137      * @dev Returns the amount of tokens in existence.
138      */
139     function totalSupply() external view returns (uint256);
140 
141     /**
142      * @dev Returns the amount of tokens owned by `account`.
143      */
144     function balanceOf(address account) external view returns (uint256);
145 
146     /**
147      * @dev Moves `amount` tokens from the caller's account to `to`.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transfer(address to, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Returns the remaining number of tokens that `spender` will be
157      * allowed to spend on behalf of `owner` through {transferFrom}. This is
158      * zero by default.
159      *
160      * This value changes when {approve} or {transferFrom} are called.
161      */
162     function allowance(address owner, address spender) external view returns (uint256);
163 
164     /**
165      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * IMPORTANT: Beware that changing an allowance with this method brings the risk
170      * that someone may use both the old and the new allowance by unfortunate
171      * transaction ordering. One possible solution to mitigate this race
172      * condition is to first reduce the spender's allowance to 0 and set the
173      * desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      *
176      * Emits an {Approval} event.
177      */
178     function approve(address spender, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Moves `amount` tokens from `from` to `to` using the
182      * allowance mechanism. `amount` is then deducted from the caller's
183      * allowance.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transferFrom(address from, address to, uint256 amount) external returns (bool);
190 }
191 
192 
193 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.2
194 
195 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Interface for the optional metadata functions from the ERC20 standard.
201  *
202  * _Available since v4.1._
203  */
204 interface IERC20Metadata is IERC20 {
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the symbol of the token.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the decimals places of the token.
217      */
218     function decimals() external view returns (uint8);
219 }
220 
221 
222 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.2
223 
224 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 
229 
230 /**
231  * @dev Implementation of the {IERC20} interface.
232  *
233  * This implementation is agnostic to the way tokens are created. This means
234  * that a supply mechanism has to be added in a derived contract using {_mint}.
235  * For a generic mechanism see {ERC20PresetMinterPauser}.
236  *
237  * TIP: For a detailed writeup see our guide
238  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
239  * to implement supply mechanisms].
240  *
241  * The default value of {decimals} is 18. To change this, you should override
242  * this function so it returns a different value.
243  *
244  * We have followed general OpenZeppelin Contracts guidelines: functions revert
245  * instead returning `false` on failure. This behavior is nonetheless
246  * conventional and does not conflict with the expectations of ERC20
247  * applications.
248  *
249  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
250  * This allows applications to reconstruct the allowance for all accounts just
251  * by listening to said events. Other implementations of the EIP may not emit
252  * these events, as it isn't required by the specification.
253  *
254  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
255  * functions have been added to mitigate the well-known issues around setting
256  * allowances. See {IERC20-approve}.
257  */
258 contract ERC20 is Context, IERC20, IERC20Metadata {
259     mapping(address => uint256) private _balances;
260 
261     mapping(address => mapping(address => uint256)) private _allowances;
262 
263     uint256 private _totalSupply;
264 
265     string private _name;
266     string private _symbol;
267 
268     /**
269      * @dev Sets the values for {name} and {symbol}.
270      *
271      * All two of these values are immutable: they can only be set once during
272      * construction.
273      */
274     constructor(string memory name_, string memory symbol_) {
275         _name = name_;
276         _symbol = symbol_;
277     }
278 
279     /**
280      * @dev Returns the name of the token.
281      */
282     function name() public view virtual override returns (string memory) {
283         return _name;
284     }
285 
286     /**
287      * @dev Returns the symbol of the token, usually a shorter version of the
288      * name.
289      */
290     function symbol() public view virtual override returns (string memory) {
291         return _symbol;
292     }
293 
294     /**
295      * @dev Returns the number of decimals used to get its user representation.
296      * For example, if `decimals` equals `2`, a balance of `505` tokens should
297      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
298      *
299      * Tokens usually opt for a value of 18, imitating the relationship between
300      * Ether and Wei. This is the default value returned by this function, unless
301      * it's overridden.
302      *
303      * NOTE: This information is only used for _display_ purposes: it in
304      * no way affects any of the arithmetic of the contract, including
305      * {IERC20-balanceOf} and {IERC20-transfer}.
306      */
307     function decimals() public view virtual override returns (uint8) {
308         return 18;
309     }
310 
311     /**
312      * @dev See {IERC20-totalSupply}.
313      */
314     function totalSupply() public view virtual override returns (uint256) {
315         return _totalSupply;
316     }
317 
318     /**
319      * @dev See {IERC20-balanceOf}.
320      */
321     function balanceOf(address account) public view virtual override returns (uint256) {
322         return _balances[account];
323     }
324 
325     /**
326      * @dev See {IERC20-transfer}.
327      *
328      * Requirements:
329      *
330      * - `to` cannot be the zero address.
331      * - the caller must have a balance of at least `amount`.
332      */
333     function transfer(address to, uint256 amount) public virtual override returns (bool) {
334         address owner = _msgSender();
335         _transfer(owner, to, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-allowance}.
341      */
342     function allowance(address owner, address spender) public view virtual override returns (uint256) {
343         return _allowances[owner][spender];
344     }
345 
346     /**
347      * @dev See {IERC20-approve}.
348      *
349      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
350      * `transferFrom`. This is semantically equivalent to an infinite approval.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      */
356     function approve(address spender, uint256 amount) public virtual override returns (bool) {
357         address owner = _msgSender();
358         _approve(owner, spender, amount);
359         return true;
360     }
361 
362     /**
363      * @dev See {IERC20-transferFrom}.
364      *
365      * Emits an {Approval} event indicating the updated allowance. This is not
366      * required by the EIP. See the note at the beginning of {ERC20}.
367      *
368      * NOTE: Does not update the allowance if the current allowance
369      * is the maximum `uint256`.
370      *
371      * Requirements:
372      *
373      * - `from` and `to` cannot be the zero address.
374      * - `from` must have a balance of at least `amount`.
375      * - the caller must have allowance for ``from``'s tokens of at least
376      * `amount`.
377      */
378     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
379         address spender = _msgSender();
380         _spendAllowance(from, spender, amount);
381         _transfer(from, to, amount);
382         return true;
383     }
384 
385     /**
386      * @dev Atomically increases the allowance granted to `spender` by the caller.
387      *
388      * This is an alternative to {approve} that can be used as a mitigation for
389      * problems described in {IERC20-approve}.
390      *
391      * Emits an {Approval} event indicating the updated allowance.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
398         address owner = _msgSender();
399         _approve(owner, spender, allowance(owner, spender) + addedValue);
400         return true;
401     }
402 
403     /**
404      * @dev Atomically decreases the allowance granted to `spender` by the caller.
405      *
406      * This is an alternative to {approve} that can be used as a mitigation for
407      * problems described in {IERC20-approve}.
408      *
409      * Emits an {Approval} event indicating the updated allowance.
410      *
411      * Requirements:
412      *
413      * - `spender` cannot be the zero address.
414      * - `spender` must have allowance for the caller of at least
415      * `subtractedValue`.
416      */
417     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
418         address owner = _msgSender();
419         uint256 currentAllowance = allowance(owner, spender);
420         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
421         unchecked {
422             _approve(owner, spender, currentAllowance - subtractedValue);
423         }
424 
425         return true;
426     }
427 
428     /**
429      * @dev Moves `amount` of tokens from `from` to `to`.
430      *
431      * This internal function is equivalent to {transfer}, and can be used to
432      * e.g. implement automatic token fees, slashing mechanisms, etc.
433      *
434      * Emits a {Transfer} event.
435      *
436      * Requirements:
437      *
438      * - `from` cannot be the zero address.
439      * - `to` cannot be the zero address.
440      * - `from` must have a balance of at least `amount`.
441      */
442     function _transfer(address from, address to, uint256 amount) internal virtual {
443         require(from != address(0), "ERC20: transfer from the zero address");
444         require(to != address(0), "ERC20: transfer to the zero address");
445 
446         _beforeTokenTransfer(from, to, amount);
447 
448         uint256 fromBalance = _balances[from];
449         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
450         unchecked {
451             _balances[from] = fromBalance - amount;
452             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
453             // decrementing then incrementing.
454             _balances[to] += amount;
455         }
456 
457         emit Transfer(from, to, amount);
458 
459         _afterTokenTransfer(from, to, amount);
460     }
461 
462     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
463      * the total supply.
464      *
465      * Emits a {Transfer} event with `from` set to the zero address.
466      *
467      * Requirements:
468      *
469      * - `account` cannot be the zero address.
470      */
471     function _mint(address account, uint256 amount) internal virtual {
472         require(account != address(0), "ERC20: mint to the zero address");
473 
474         _beforeTokenTransfer(address(0), account, amount);
475 
476         _totalSupply += amount;
477         unchecked {
478             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
479             _balances[account] += amount;
480         }
481         emit Transfer(address(0), account, amount);
482 
483         _afterTokenTransfer(address(0), account, amount);
484     }
485 
486     /**
487      * @dev Destroys `amount` tokens from `account`, reducing the
488      * total supply.
489      *
490      * Emits a {Transfer} event with `to` set to the zero address.
491      *
492      * Requirements:
493      *
494      * - `account` cannot be the zero address.
495      * - `account` must have at least `amount` tokens.
496      */
497     function _burn(address account, uint256 amount) internal virtual {
498         require(account != address(0), "ERC20: burn from the zero address");
499 
500         _beforeTokenTransfer(account, address(0), amount);
501 
502         uint256 accountBalance = _balances[account];
503         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
504         unchecked {
505             _balances[account] = accountBalance - amount;
506             // Overflow not possible: amount <= accountBalance <= totalSupply.
507             _totalSupply -= amount;
508         }
509 
510         emit Transfer(account, address(0), amount);
511 
512         _afterTokenTransfer(account, address(0), amount);
513     }
514 
515     /**
516      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
517      *
518      * This internal function is equivalent to `approve`, and can be used to
519      * e.g. set automatic allowances for certain subsystems, etc.
520      *
521      * Emits an {Approval} event.
522      *
523      * Requirements:
524      *
525      * - `owner` cannot be the zero address.
526      * - `spender` cannot be the zero address.
527      */
528     function _approve(address owner, address spender, uint256 amount) internal virtual {
529         require(owner != address(0), "ERC20: approve from the zero address");
530         require(spender != address(0), "ERC20: approve to the zero address");
531 
532         _allowances[owner][spender] = amount;
533         emit Approval(owner, spender, amount);
534     }
535 
536     /**
537      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
538      *
539      * Does not update the allowance amount in case of infinite allowance.
540      * Revert if not enough allowance is available.
541      *
542      * Might emit an {Approval} event.
543      */
544     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
545         uint256 currentAllowance = allowance(owner, spender);
546         if (currentAllowance != type(uint256).max) {
547             require(currentAllowance >= amount, "ERC20: insufficient allowance");
548             unchecked {
549                 _approve(owner, spender, currentAllowance - amount);
550             }
551         }
552     }
553 
554     /**
555      * @dev Hook that is called before any transfer of tokens. This includes
556      * minting and burning.
557      *
558      * Calling conditions:
559      *
560      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
561      * will be transferred to `to`.
562      * - when `from` is zero, `amount` tokens will be minted for `to`.
563      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
564      * - `from` and `to` are never both zero.
565      *
566      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
567      */
568     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
569 
570     /**
571      * @dev Hook that is called after any transfer of tokens. This includes
572      * minting and burning.
573      *
574      * Calling conditions:
575      *
576      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
577      * has been transferred to `to`.
578      * - when `from` is zero, `amount` tokens have been minted for `to`.
579      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
580      * - `from` and `to` are never both zero.
581      *
582      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
583      */
584     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
585 }
586 
587 
588 // File contracts/PEPURAI.sol
589 
590 
591 /**
592 Website: https://www.pepurai.com/
593 **/
594 
595 pragma solidity 0.8.17;
596 
597 
598 interface IUniswapV2Factory {
599     function createPair(address tokenA, address tokenB)
600     external
601     returns (address pair);
602 }
603 
604 interface IUniswapV2Router {
605     function factory() external pure returns (address);
606     function WETH() external pure returns (address);
607 
608     function swapExactTokensForETHSupportingFeeOnTransferTokens(
609         uint amountIn,
610         uint amountOutMin,
611         address[] calldata path,
612         address to,
613         uint deadline
614     ) external;
615 
616     function swapExactETHForTokensSupportingFeeOnTransferTokens(
617         uint amountOutMin,
618         address[] calldata path,
619         address to,
620         uint deadline
621     ) external payable;
622 
623     function addLiquidityETH(
624         address token,
625         uint256 amountTokenDesired,
626         uint256 amountTokenMin,
627         uint256 amountETHMin,
628         address to,
629         uint256 deadline
630     )
631     external
632     payable
633     returns (
634         uint256 amountToken,
635         uint256 amountETH,
636         uint256 liquidity
637     );
638 }
639 
640 contract PEPURAI is ERC20, Ownable {
641     address public devWallet;
642     address public marketingWallet;
643 
644     uint256 public maxBuyAmount;
645     uint256 public maxSellAmount;
646     uint256 public maxWalletAmount;
647     IUniswapV2Router public uniswapV2Router;
648 
649     address public lpPair;
650 
651     bool public hasLimits = true;
652     bool private swapping;
653     uint256 public swapTokensAtAmount;
654 
655     uint256 public constant FEE_DECIMALS = 10000;
656     uint256 public buyTotalFees;
657     uint256 public buyMarketingFee;
658     uint256 public buyDevFee;
659     uint256 public buyLiquidityFee;
660 
661     uint256 public sellTotalFees;
662     uint256 public sellmarketingFee;
663     uint256 public sellDevFee;
664     uint256 public sellLiquidityFee;
665 
666     uint256 public tokensForMarketing;
667     uint256 public tokensForDev;
668     uint256 public tokensForLiquidity;
669 
670     mapping (address => bool) private _isExcludedFromFees;
671     mapping (address => bool) public _isExcludedMaxTransactionAmount;
672     mapping (address => bool) public automatedMarketMakerPairs;
673 
674     //events
675     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
676     event MaxTransactionExclusion(address _address, bool excluded);
677     event ExcludeFromFees(address indexed account, bool isExcluded);
678     event OwnerForcedSwapBack(uint256 timestamp);
679     event UpdatedMaxBuyAmount(uint256 newAmount);
680     event UpdatedMaxSellAmount(uint256 newAmount);
681     event UpdatedMaxWalletAmount(uint256 newAmount);
682     event RemovedLimits();
683     event BuyBackTriggered(uint256 amount);
684 
685     constructor() ERC20("PEPURAI", "PEPURAI") {
686 
687         address newOwner = msg.sender; // can leave alone if owner is deployer.
688 
689         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
690         uniswapV2Router = _uniswapV2Router;
691 
692         //create pair
693         lpPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
694         _excludeFromMaxTransaction(address(lpPair), true);
695         _setAutomatedMarketMakerPair(address(lpPair), true);
696 
697         uint256 totalSupply = 420690000000000 * 1e18;
698 
699         maxBuyAmount = totalSupply * 1 / 100;
700         maxSellAmount = totalSupply * 1 / 100;
701         maxWalletAmount = totalSupply * 1 / 100;
702         swapTokensAtAmount = totalSupply * 1 / 1000;
703 
704         buyDevFee = 0;
705         buyMarketingFee = 600;
706         buyLiquidityFee = 600;
707         buyTotalFees = buyMarketingFee + buyDevFee + buyLiquidityFee;
708 
709         sellDevFee = 0;
710         sellmarketingFee = 600;
711         sellLiquidityFee = 600;
712         sellTotalFees = sellmarketingFee + sellDevFee + sellLiquidityFee;
713 
714         devWallet = newOwner;
715         marketingWallet = newOwner;
716 
717         _excludeFromMaxTransaction(devWallet, true);
718         _excludeFromMaxTransaction(marketingWallet, true);
719         _excludeFromMaxTransaction(address(this), true);
720 
721         excludeFromFees(newOwner, true);
722         excludeFromFees(devWallet, true);
723         excludeFromFees(marketingWallet, true);
724 
725         excludeFromFees(address(this), true);
726         excludeFromFees(address(0xdead), true);
727 
728         _mint(newOwner, totalSupply);
729 
730         transferOwnership(newOwner);
731     }
732 
733     function _transfer(address from, address to, uint256 amount) internal override {
734         require(from != address(0), "cannot transfer from the zero address");
735         require(to != address(0), "cannot transfer to the zero address");
736         require(amount > 0, "amount must be greater than 0");
737 
738         if(hasLimits){
739             if(from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
740                 //buy action
741                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
742                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
743                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
744                 }
745                 //sell action
746                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
747                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
748                 }
749                 //other transfers
750                 else if(!_isExcludedMaxTransactionAmount[to]){
751                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max amount");
752                 }
753             }
754         }
755 
756         uint256 contractTokenBalance = balanceOf(address(this));
757 
758         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
759 
760         if(canSwap && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
761             swapping = true;
762             swapBack();
763             swapping = false;
764         }
765 
766         bool takeFee = true;
767 
768         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
769             takeFee = false;
770         }
771 
772         uint256 fees = 0;
773 
774         if(takeFee){
775             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
776                 fees = amount * sellTotalFees / FEE_DECIMALS;
777                 tokensForDev += fees * sellDevFee / sellTotalFees;
778                 tokensForMarketing += fees * sellmarketingFee / sellTotalFees;
779                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
780             }
781             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
782                 fees = amount * buyTotalFees / FEE_DECIMALS;
783                 tokensForDev += fees * buyDevFee / buyTotalFees;
784                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
785                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
786             }
787 
788             if(fees > 0){
789 
790                 super._transfer(from, address(this), fees);
791             }
792 
793             amount -= fees;
794 
795         }
796 
797         super._transfer(from, to, amount);
798 
799     }
800 
801     function swapBack() private {
802 
803         uint256 contractBalance = balanceOf(address(this));
804         uint256 totalTokensToSwap = tokensForDev + tokensForMarketing + tokensForLiquidity;
805 
806         if(contractBalance == 0 || totalTokensToSwap == 0){return;}
807 
808         if(contractBalance > swapTokensAtAmount * 20){
809             contractBalance = swapTokensAtAmount * 20;
810         }
811 
812         bool success;
813 
814         // Halve the amount of liquidity tokens
815         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
816 
817         swapTokensForEth(contractBalance - liquidityTokens);
818 
819         uint256 ethBalance = address(this).balance;
820         uint256 ethForLiquidity = ethBalance;
821 
822         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
823         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
824 
825         ethForLiquidity -= ethForDev + ethForMarketing;
826 
827         tokensForLiquidity = 0;
828         tokensForDev = 0;
829         tokensForMarketing = 0;
830 
831         if(liquidityTokens > 0 && ethForLiquidity > 0){
832             addLiquidity(liquidityTokens, ethForLiquidity);
833         }
834 
835         (success,) = address(devWallet).call{value: ethForDev}("");
836         (success,) = address(marketingWallet).call{value: address(this).balance}("");
837 
838     }
839 
840     receive() external payable {}
841 
842     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
843         // approve token transfer to cover all possible scenarios
844         _approve(address(this), address(uniswapV2Router), tokenAmount);
845 
846         // add the liquidity
847         uniswapV2Router.addLiquidityETH{value: ethAmount}(
848             address(this),
849             tokenAmount,
850             0,
851             0,
852             address(0xdead),
853             block.timestamp
854         );
855     }
856 
857     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
858         if(!isEx){
859             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
860         }
861         _isExcludedMaxTransactionAmount[updAds] = isEx;
862     }
863 
864     function _excludeFromMaxTransaction(address adrs, bool isExcluded) private {
865         _isExcludedMaxTransactionAmount[adrs] = isExcluded;
866         emit MaxTransactionExclusion(adrs, isExcluded);
867     }
868 
869     function swapTokensForEth(uint256 tokenAmount) private {
870 
871         // generate the uniswap pair path of token -> weth
872         address[] memory path = new address[](2);
873         path[0] = address(this);
874         path[1] = uniswapV2Router.WETH();
875 
876         _approve(address(this), address(uniswapV2Router), tokenAmount);
877 
878         // make the swap
879         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
880             tokenAmount,
881             0, // accept any amount of ETH
882             path,
883             address(this),
884             block.timestamp
885         );
886 
887     }
888 
889     // force Swap back if slippage issues.
890     function forceSwapBack() external onlyOwner {
891         require(balanceOf(address(this)) >= swapTokensAtAmount, "Contract should have a token amount that is higher than restriction");
892         swapping = true;
893         swapBack();
894         swapping = false;
895         emit OwnerForcedSwapBack(block.timestamp);
896     }
897 
898     // withdraw ETH from contract address
899     function withdrawStuckETH() external onlyOwner {
900         bool success;
901         (success,) = address(msg.sender).call{value: address(this).balance}("");
902     }
903 
904     function excludeFromFees(address account, bool excluded) public onlyOwner {
905         _isExcludedFromFees[account] = excluded;
906         emit ExcludeFromFees(account, excluded);
907     }
908 
909     function setWalletsAddresses(address _development, address _marketingAddress) external onlyOwner {
910         require(_development != address(0),"address cannot be zero address");
911         require(_marketingAddress != address(0),"address cannot be zero address");
912 
913         devWallet = payable(_development);
914         marketingWallet = payable(_marketingAddress);
915 
916     }
917 
918     // change the minimum amount of tokens to sell from fees
919     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
920         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
921         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
922         swapTokensAtAmount = newAmount;
923     }
924 
925     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
926         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
927         maxWalletAmount = newNum * (10**18);
928         emit UpdatedMaxWalletAmount(maxWalletAmount);
929     }
930 
931     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
932         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
933         maxBuyAmount = newNum * (10**18);
934         emit UpdatedMaxBuyAmount(maxBuyAmount);
935     }
936 
937     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
938         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
939         maxSellAmount = newNum * (10**18);
940         emit UpdatedMaxSellAmount(maxSellAmount);
941     }
942 
943     function updateBuyFees(uint256 _devFee, uint256 _marketingFee, uint256 _liquidityFee) external onlyOwner {
944         buyDevFee = _devFee;
945         buyMarketingFee = _marketingFee;
946         buyLiquidityFee = _liquidityFee;
947         buyTotalFees = buyDevFee + buyMarketingFee + buyLiquidityFee;
948         require(buyTotalFees <= 5500, "Must keep fees at 55% or less");
949     }
950 
951     function updateSellFees(uint256 _devFee, uint256 _marketingFee, uint256 _liquidityFee) external onlyOwner {
952         sellDevFee = _devFee;
953         sellmarketingFee = _marketingFee;
954         sellLiquidityFee = _liquidityFee;
955         sellTotalFees = sellDevFee + sellmarketingFee + sellLiquidityFee;
956         require(sellTotalFees <= 8000, "Must keep fees at 80% or less");
957     }
958 
959     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
960         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
961 
962         _setAutomatedMarketMakerPair(pair, value);
963         emit SetAutomatedMarketMakerPair(pair, value);
964     }
965 
966     function _setAutomatedMarketMakerPair(address pair, bool value) private {
967         automatedMarketMakerPairs[pair] = value;
968 
969         _excludeFromMaxTransaction(pair, value);
970 
971         emit SetAutomatedMarketMakerPair(pair, value);
972     }
973     //remove limits after token is stable
974     function removeLimits() external onlyOwner {
975         hasLimits = false;
976         emit RemovedLimits();
977     }
978 
979     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
980     function buyBackTokens(uint256 amountInWei) payable external onlyOwner {
981         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
982 
983         address[] memory path = new address[](2);
984         path[0] = uniswapV2Router.WETH();
985         path[1] = address(this);
986 
987         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
988             0, // accept any amount of Ethereum
989             path,
990             address(0xdead),
991             block.timestamp
992         );
993 
994         emit BuyBackTriggered(amountInWei);
995     }
996 
997 }