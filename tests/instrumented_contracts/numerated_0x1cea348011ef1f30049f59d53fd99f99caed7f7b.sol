1 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 
29 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
30 
31 
32 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 
107 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
108 
109 
110 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP.
116  */
117 interface IERC20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     /**
124      * @dev Returns the amount of tokens owned by `account`.
125      */
126     function balanceOf(address account) external view returns (uint256);
127 
128     /**
129      * @dev Moves `amount` tokens from the caller's account to `recipient`.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transfer(address recipient, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Returns the remaining number of tokens that `spender` will be
139      * allowed to spend on behalf of `owner` through {transferFrom}. This is
140      * zero by default.
141      *
142      * This value changes when {approve} or {transferFrom} are called.
143      */
144     function allowance(address owner, address spender) external view returns (uint256);
145 
146     /**
147      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * IMPORTANT: Beware that changing an allowance with this method brings the risk
152      * that someone may use both the old and the new allowance by unfortunate
153      * transaction ordering. One possible solution to mitigate this race
154      * condition is to first reduce the spender's allowance to 0 and set the
155      * desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      *
158      * Emits an {Approval} event.
159      */
160     function approve(address spender, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Moves `amount` tokens from `sender` to `recipient` using the
164      * allowance mechanism. `amount` is then deducted from the caller's
165      * allowance.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) external returns (bool);
176 
177     /**
178      * @dev Emitted when `value` tokens are moved from one account (`from`) to
179      * another (`to`).
180      *
181      * Note that `value` may be zero.
182      */
183     event Transfer(address indexed from, address indexed to, uint256 value);
184 
185     /**
186      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
187      * a call to {approve}. `value` is the new allowance.
188      */
189     event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 
193 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
194 
195 
196 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
197 
198 pragma solidity ^0.8.0;
199 
200 /**
201  * @dev Interface for the optional metadata functions from the ERC20 standard.
202  *
203  * _Available since v4.1._
204  */
205 interface IERC20Metadata is IERC20 {
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the symbol of the token.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the decimals places of the token.
218      */
219     function decimals() external view returns (uint8);
220 }
221 
222 
223 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
224 
225 
226 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 
231 
232 /**
233  * @dev Implementation of the {IERC20} interface.
234  *
235  * This implementation is agnostic to the way tokens are created. This means
236  * that a supply mechanism has to be added in a derived contract using {_mint}.
237  * For a generic mechanism see {ERC20PresetMinterPauser}.
238  *
239  * TIP: For a detailed writeup see our guide
240  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
241  * to implement supply mechanisms].
242  *
243  * We have followed general OpenZeppelin Contracts guidelines: functions revert
244  * instead returning `false` on failure. This behavior is nonetheless
245  * conventional and does not conflict with the expectations of ERC20
246  * applications.
247  *
248  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
249  * This allows applications to reconstruct the allowance for all accounts just
250  * by listening to said events. Other implementations of the EIP may not emit
251  * these events, as it isn't required by the specification.
252  *
253  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
254  * functions have been added to mitigate the well-known issues around setting
255  * allowances. See {IERC20-approve}.
256  */
257 contract ERC20 is Context, IERC20, IERC20Metadata {
258     mapping(address => uint256) private _balances;
259 
260     mapping(address => mapping(address => uint256)) private _allowances;
261 
262     uint256 private _totalSupply;
263 
264     string private _name;
265     string private _symbol;
266 
267     /**
268      * @dev Sets the values for {name} and {symbol}.
269      *
270      * The default value of {decimals} is 18. To select a different value for
271      * {decimals} you should overload it.
272      *
273      * All two of these values are immutable: they can only be set once during
274      * construction.
275      */
276     constructor(string memory name_, string memory symbol_) {
277         _name = name_;
278         _symbol = symbol_;
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view virtual override returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view virtual override returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      * For example, if `decimals` equals `2`, a balance of `505` tokens should
299      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
300      *
301      * Tokens usually opt for a value of 18, imitating the relationship between
302      * Ether and Wei. This is the value {ERC20} uses, unless this function is
303      * overridden;
304      *
305      * NOTE: This information is only used for _display_ purposes: it in
306      * no way affects any of the arithmetic of the contract, including
307      * {IERC20-balanceOf} and {IERC20-transfer}.
308      */
309     function decimals() public view virtual override returns (uint8) {
310         return 18;
311     }
312 
313     /**
314      * @dev See {IERC20-totalSupply}.
315      */
316     function totalSupply() public view virtual override returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {IERC20-balanceOf}.
322      */
323     function balanceOf(address account) public view virtual override returns (uint256) {
324         return _balances[account];
325     }
326 
327     /**
328      * @dev See {IERC20-transfer}.
329      *
330      * Requirements:
331      *
332      * - `recipient` cannot be the zero address.
333      * - the caller must have a balance of at least `amount`.
334      */
335     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(address owner, address spender) public view virtual override returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {IERC20-approve}.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      */
354     function approve(address spender, uint256 amount) public virtual override returns (bool) {
355         _approve(_msgSender(), spender, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-transferFrom}.
361      *
362      * Emits an {Approval} event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of {ERC20}.
364      *
365      * Requirements:
366      *
367      * - `sender` and `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      * - the caller must have allowance for ``sender``'s tokens of at least
370      * `amount`.
371      */
372     function transferFrom(
373         address sender,
374         address recipient,
375         uint256 amount
376     ) public virtual override returns (bool) {
377         _transfer(sender, recipient, amount);
378 
379         uint256 currentAllowance = _allowances[sender][_msgSender()];
380         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
381         unchecked {
382             _approve(sender, _msgSender(), currentAllowance - amount);
383         }
384 
385         return true;
386     }
387 
388     /**
389      * @dev Atomically increases the allowance granted to `spender` by the caller.
390      *
391      * This is an alternative to {approve} that can be used as a mitigation for
392      * problems described in {IERC20-approve}.
393      *
394      * Emits an {Approval} event indicating the updated allowance.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
401         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
402         return true;
403     }
404 
405     /**
406      * @dev Atomically decreases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      * - `spender` must have allowance for the caller of at least
417      * `subtractedValue`.
418      */
419     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
420         uint256 currentAllowance = _allowances[_msgSender()][spender];
421         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
422         unchecked {
423             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
424         }
425 
426         return true;
427     }
428 
429     /**
430      * @dev Moves `amount` of tokens from `sender` to `recipient`.
431      *
432      * This internal function is equivalent to {transfer}, and can be used to
433      * e.g. implement automatic token fees, slashing mechanisms, etc.
434      *
435      * Emits a {Transfer} event.
436      *
437      * Requirements:
438      *
439      * - `sender` cannot be the zero address.
440      * - `recipient` cannot be the zero address.
441      * - `sender` must have a balance of at least `amount`.
442      */
443     function _transfer(
444         address sender,
445         address recipient,
446         uint256 amount
447     ) internal virtual {
448         require(sender != address(0), "ERC20: transfer from the zero address");
449         require(recipient != address(0), "ERC20: transfer to the zero address");
450 
451         _beforeTokenTransfer(sender, recipient, amount);
452 
453         uint256 senderBalance = _balances[sender];
454         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
455         unchecked {
456             _balances[sender] = senderBalance - amount;
457         }
458         _balances[recipient] += amount;
459 
460         emit Transfer(sender, recipient, amount);
461 
462         _afterTokenTransfer(sender, recipient, amount);
463     }
464 
465     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
466      * the total supply.
467      *
468      * Emits a {Transfer} event with `from` set to the zero address.
469      *
470      * Requirements:
471      *
472      * - `account` cannot be the zero address.
473      */
474     function _mint(address account, uint256 amount) internal virtual {
475         require(account != address(0), "ERC20: mint to the zero address");
476 
477         _beforeTokenTransfer(address(0), account, amount);
478 
479         _totalSupply += amount;
480         _balances[account] += amount;
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
506         }
507         _totalSupply -= amount;
508 
509         emit Transfer(account, address(0), amount);
510 
511         _afterTokenTransfer(account, address(0), amount);
512     }
513 
514     /**
515      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
516      *
517      * This internal function is equivalent to `approve`, and can be used to
518      * e.g. set automatic allowances for certain subsystems, etc.
519      *
520      * Emits an {Approval} event.
521      *
522      * Requirements:
523      *
524      * - `owner` cannot be the zero address.
525      * - `spender` cannot be the zero address.
526      */
527     function _approve(
528         address owner,
529         address spender,
530         uint256 amount
531     ) internal virtual {
532         require(owner != address(0), "ERC20: approve from the zero address");
533         require(spender != address(0), "ERC20: approve to the zero address");
534 
535         _allowances[owner][spender] = amount;
536         emit Approval(owner, spender, amount);
537     }
538 
539     /**
540      * @dev Hook that is called before any transfer of tokens. This includes
541      * minting and burning.
542      *
543      * Calling conditions:
544      *
545      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
546      * will be transferred to `to`.
547      * - when `from` is zero, `amount` tokens will be minted for `to`.
548      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
549      * - `from` and `to` are never both zero.
550      *
551      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
552      */
553     function _beforeTokenTransfer(
554         address from,
555         address to,
556         uint256 amount
557     ) internal virtual {}
558 
559     /**
560      * @dev Hook that is called after any transfer of tokens. This includes
561      * minting and burning.
562      *
563      * Calling conditions:
564      *
565      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
566      * has been transferred to `to`.
567      * - when `from` is zero, `amount` tokens have been minted for `to`.
568      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
569      * - `from` and `to` are never both zero.
570      *
571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
572      */
573     function _afterTokenTransfer(
574         address from,
575         address to,
576         uint256 amount
577     ) internal virtual {}
578 }
579 
580 interface IUniswapV2Factory {
581     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
582     
583     function createPair(address tokenA, address tokenB) external returns (address pair);
584  
585 }
586 
587 
588 interface IUniswapV2Router02 {
589     function factory() external pure returns (address);
590 
591     function WETH() external pure returns (address);
592 
593     function swapExactTokensForETHSupportingFeeOnTransferTokens(
594         uint256 amountIn,
595         uint256 amountOutMin,
596         address[] calldata path,
597         address to,
598         uint256 deadline
599     ) external;
600 }
601 // File contracts/SlepeToken.sol
602 
603 pragma solidity ^0.8.0;
604 
605 
606 contract SlepeToken is Ownable, ERC20 {
607     bool public limited = true;
608     bool public tradingEnabled;
609     bool private swapping;
610     bool public swapEnabled;
611 
612     uint256 public maxHoldingAmount = 4206899999999999999999999999987;
613     uint256 public minHoldingAmount;
614 
615     uint256 public buyMarketingFee = 1; // 1% buy marketing fee
616     uint256 public sellMarketingFee = 1; // 1% sell marketing fee
617 
618     uint256 public swapTokensAtAmount = 100000 * 1e18;
619     address public uniswapV2Pair;
620     address public marketingWallet;
621     IUniswapV2Router02 router = IUniswapV2Router02 (0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D ); //uniswap v2 router
622     mapping(address => bool) public blacklists;
623     mapping(address => bool) public excludedFromFees;
624 
625 
626 
627     constructor() ERC20("Slept on Pepe", "SLEPE") {
628          address _uniswapV2Pair = IUniswapV2Factory(router.factory())
629             .createPair(address(this), router.WETH());
630            uniswapV2Pair   = _uniswapV2Pair;
631            marketingWallet = address(0xCA3e6986D58af79c544d5c7d7B66b51AABf8b830); //0xCA3e6986D58af79c544d5c7d7B66b51AABf8b830
632 
633            excludedFromFees[address(this)] = true;
634            excludedFromFees[msg.sender] = true;
635            excludedFromFees[marketingWallet] = true;
636 
637             _mint(msg.sender, 420689999999999999999999999998764); //420,689,999,999,999.999999999999998764 Slepe
638     }
639 
640     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
641         blacklists[_address] = _isBlacklisting;
642     }
643 
644     function setRule(bool _limited, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
645         limited = _limited;
646 
647         maxHoldingAmount = _maxHoldingAmount;
648         minHoldingAmount = _minHoldingAmount;
649     }
650 
651     function setMarketingFee (uint256 buy, uint256 sell) external onlyOwner {
652         buyMarketingFee = buy;
653         sellMarketingFee = sell;
654         require (buyMarketingFee + sellMarketingFee <= 10, "Max Fees limit is 10%");
655     }
656 
657       function enableTrading() external onlyOwner{
658         require(!tradingEnabled, "Trading already enabled.");
659         tradingEnabled = true;
660         swapEnabled = true;
661     }
662 
663     function updateMarketingWallet (address newWallet) external onlyOwner {
664         marketingWallet = newWallet;
665     }
666 
667     function _transfer(address from,address to,uint256 amount) internal  override {
668         require(from != address(0), "ERC20: transfer from the zero address");
669         require(to != address(0), "ERC20: transfer to the zero address");
670          require(!blacklists[to] && !blacklists[from], "Blacklisted");
671         require(tradingEnabled || excludedFromFees[from] || excludedFromFees[to], "Trading not yet enabled!");
672        
673         if (amount == 0) {
674             super._transfer(from, to, 0);
675             return;
676         }
677 
678         if (limited && from == uniswapV2Pair) {
679             require(balanceOf(to) + amount <= maxHoldingAmount && balanceOf(to) + amount >= minHoldingAmount, "Forbid");
680         }
681 
682 		uint256 contractTokenBalance = balanceOf(address(this));
683 
684         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
685 
686         if (canSwap &&
687             !swapping &&
688             to == uniswapV2Pair &&
689             swapEnabled
690         ) {
691             swapping = true;
692                 
693             swapAndLiquify(contractTokenBalance);
694 
695             swapping = false;
696         }
697 
698          bool takeFee = !swapping;
699  
700         // if any account belongs to _isExcludedFromFee account then remove the fee
701         if (excludedFromFees[from] || excludedFromFees[to]) {
702             takeFee = false;
703         }
704  
705 
706        uint256 fees = 0;
707         // only take fees on buys/sells, do not take on wallet transfers
708         if (takeFee) {
709             // on sell
710             if (to == uniswapV2Pair && sellMarketingFee > 0) {
711                 fees = (amount * sellMarketingFee) / 100;
712                
713             }
714             // on buy
715             if (from == uniswapV2Pair && buyMarketingFee > 0) {
716                 fees = (amount * buyMarketingFee) / 100;
717                
718             }
719  
720             if (fees > 0) {
721                 super._transfer(from, address(this), fees);
722             }
723  
724             amount -= fees;
725         }
726 
727         super._transfer(from, to, amount);
728     }
729 
730      function swapAndLiquify(uint256 tokens) private {
731        
732         address[] memory path = new address[](2);
733         path[0] = address(this);
734         path[1] = router.WETH();
735         if(allowance(address(this), address(router)) < tokens ){
736        _approve(address(this), address(router), ~uint256(0));
737         }
738        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
739            tokens,
740             0,
741             path,
742             marketingWallet,
743             block.timestamp);
744         
745     }
746 
747     function burn(uint256 value) external {
748         _burn(msg.sender, value);
749     }
750 }