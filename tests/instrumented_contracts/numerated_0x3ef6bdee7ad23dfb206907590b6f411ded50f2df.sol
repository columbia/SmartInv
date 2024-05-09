1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.20;
3 
4 // twitter: https://twitter.com/astroworldeth
5 // web: https://astroworld.pro/
6 // telegram: https://t.me/astroworldeth
7 
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 interface IUniswapV2Factory {
84     function createPair(
85         address tokenA,
86         address tokenB
87     ) external returns (address pair);
88 }
89 
90 interface IUniswapV2Router {
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint256 amountIn,
93         uint256 amountOutMin,
94         address[] calldata path,
95         address to,
96         uint256 deadline
97     ) external;
98 
99     function factory() external pure returns (address);
100 
101     function WETH() external pure returns (address);
102 
103     function addLiquidityETH(
104         address token,
105         uint256 amountTokenDesired,
106         uint256 amountTokenMin,
107         uint256 amountETHMin,
108         address to,
109         uint256 deadline
110     )
111         external
112         payable
113         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
114 }
115 
116 interface IERC20Metadata is IERC20 {
117     /**
118      * @dev Returns the name of the token.
119      */
120     function name() external view returns (string memory);
121 
122     /**
123      * @dev Returns the decimals places of the token.
124      */
125     function decimals() external view returns (uint8);
126 
127     /**
128      * @dev Returns the symbol of the token.
129      */
130     function symbol() external view returns (string memory);
131 }
132 
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 }
138 
139 abstract contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(
143         address indexed previousOwner,
144         address indexed newOwner
145     );
146 
147     /**
148      * @dev Initializes the contract setting the deployer as the initial owner.
149      */
150     constructor() {
151         _transferOwnership(_msgSender());
152     }
153 
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyOwner() {
158         _checkOwner();
159         _;
160     }
161 
162     /**
163      * @dev Returns the address of the current owner.
164      */
165     function owner() public view virtual returns (address) {
166         return _owner;
167     }
168 
169     /**
170      * @dev Throws if the sender is not the owner.
171      */
172     function _checkOwner() internal view virtual {
173         require(owner() == _msgSender(), "Ownable: caller is not the owner");
174     }
175 
176     /**
177      * @dev Leaves the contract without owner. It will not be possible to call
178      * `onlyOwner` functions anymore. Can only be called by the current owner.
179      *
180      * NOTE: Renouncing ownership will leave the contract without an owner,
181      * thereby removing any functionality that is only available to the owner.
182      */
183     function renounceOwnership() public virtual onlyOwner {
184         _transferOwnership(address(0));
185     }
186 
187     /**
188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
189      * Can only be called by the current owner.
190      */
191     function transferOwnership(address newOwner) public virtual onlyOwner {
192         require(
193             newOwner != address(0),
194             "Ownable: new owner is the zero address"
195         );
196         _transferOwnership(newOwner);
197     }
198 
199     /**
200      * @dev Transfers ownership of the contract to a new account (`newOwner`).
201      * Internal function without access restriction.
202      */
203     function _transferOwnership(address newOwner) internal virtual {
204         address oldOwner = _owner;
205         _owner = newOwner;
206         emit OwnershipTransferred(oldOwner, newOwner);
207     }
208 }
209 
210 contract ERC20 is Context, IERC20, IERC20Metadata {
211     mapping(address => uint256) private _balances;
212     mapping(address => mapping(address => uint256)) private _allowances;
213 
214     uint256 private _totalSupply;
215 
216     string private _name;
217     string private _symbol;
218 
219     constructor(string memory name_, string memory symbol_) {
220         _name = name_;
221         _symbol = symbol_;
222     }
223 
224     /**
225      * @dev Returns the symbol of the token, usually a shorter version of the
226      * name.
227      */
228     function symbol() external view virtual override returns (string memory) {
229         return _symbol;
230     }
231 
232     /**
233      * @dev Returns the name of the token.
234      */
235     function name() external view virtual override returns (string memory) {
236         return _name;
237     }
238 
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(
243         address account
244     ) public view virtual override returns (uint256) {
245         return _balances[account];
246     }
247 
248     /**
249      * @dev Returns the number of decimals used to get its user representation.
250      * For example, if `decimals` equals `2`, a balance of `505` tokens should
251      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
252      *
253      * Tokens usually opt for a value of 18, imitating the relationship between
254      * Ether and Wei. This is the value {ERC20} uses, unless this function is
255      * overridden;
256      *
257      * NOTE: This information is only used for _display_ purposes: it in
258      * no way affects any of the arithmetic of the contract, including
259      * {IERC20-balanceOf} and {IERC20-transfer}.
260      */
261     function decimals() public view virtual override returns (uint8) {
262         return 18;
263     }
264 
265     /**
266      * @dev See {IERC20-totalSupply}.
267      */
268     function totalSupply() external view virtual override returns (uint256) {
269         return _totalSupply;
270     }
271 
272     /**
273      * @dev See {IERC20-allowance}.
274      */
275     function allowance(
276         address owner,
277         address spender
278     ) public view virtual override returns (uint256) {
279         return _allowances[owner][spender];
280     }
281 
282     /**
283      * @dev See {IERC20-transfer}.
284      *
285      * Requirements:
286      *
287      * - `to` cannot be the zero address.
288      * - the caller must have a balance of at least `amount`.
289      */
290     function transfer(
291         address to,
292         uint256 amount
293     ) external virtual override returns (bool) {
294         address owner = _msgSender();
295         _transfer(owner, to, amount);
296         return true;
297     }
298 
299     /**
300      * @dev See {IERC20-approve}.
301      *
302      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
303      * `transferFrom`. This is semantically equivalent to an infinite approval.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      */
309     function approve(
310         address spender,
311         uint256 amount
312     ) external virtual override returns (bool) {
313         address owner = _msgSender();
314         _approve(owner, spender, amount);
315         return true;
316     }
317 
318     /**
319      * @dev See {IERC20-transferFrom}.
320      *
321      * Emits an {Approval} event indicating the updated allowance. This is not
322      * required by the EIP. See the note at the beginning of {ERC20}.
323      *
324      * NOTE: Does not update the allowance if the current allowance
325      * is the maximum `uint256`.
326      *
327      * Requirements:
328      *
329      * - `from` and `to` cannot be the zero address.
330      * - `from` must have a balance of at least `amount`.
331      * - the caller must have allowance for ``from``'s tokens of at least
332      * `amount`.
333      */
334     function transferFrom(
335         address from,
336         address to,
337         uint256 amount
338     ) external virtual override returns (bool) {
339         address spender = _msgSender();
340         _spendAllowance(from, spender, amount);
341         _transfer(from, to, amount);
342         return true;
343     }
344 
345     /**
346      * @dev Atomically decreases the allowance granted to `spender` by the caller.
347      *
348      * This is an alternative to {approve} that can be used as a mitigation for
349      * problems described in {IERC20-approve}.
350      *
351      * Emits an {Approval} event indicating the updated allowance.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      * - `spender` must have allowance for the caller of at least
357      * `subtractedValue`.
358      */
359     function decreaseAllowance(
360         address spender,
361         uint256 subtractedValue
362     ) external virtual returns (bool) {
363         address owner = _msgSender();
364         uint256 currentAllowance = allowance(owner, spender);
365         require(
366             currentAllowance >= subtractedValue,
367             "ERC20: decreased allowance below zero"
368         );
369         unchecked {
370             _approve(owner, spender, currentAllowance - subtractedValue);
371         }
372 
373         return true;
374     }
375 
376     /**
377      * @dev Atomically increases the allowance granted to `spender` by the caller.
378      *
379      * This is an alternative to {approve} that can be used as a mitigation for
380      * problems described in {IERC20-approve}.
381      *
382      * Emits an {Approval} event indicating the updated allowance.
383      *
384      * Requirements:
385      *
386      * - `spender` cannot be the zero address.
387      */
388     function increaseAllowance(
389         address spender,
390         uint256 addedValue
391     ) external virtual returns (bool) {
392         address owner = _msgSender();
393         _approve(owner, spender, allowance(owner, spender) + addedValue);
394         return true;
395     }
396 
397     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
398      * the total supply.
399      *
400      * Emits a {Transfer} event with `from` set to the zero address.
401      *
402      * Requirements:
403      *
404      * - `account` cannot be the zero address.
405      */
406     function _mint(address account, uint256 amount) internal virtual {
407         require(account != address(0), "ERC20: mint to the zero address");
408 
409         _totalSupply += amount;
410         unchecked {
411             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
412             _balances[account] += amount;
413         }
414         emit Transfer(address(0), account, amount);
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
443      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
444      *
445      * Does not update the allowance amount in case of infinite allowance.
446      * Revert if not enough allowance is available.
447      *
448      * Might emit an {Approval} event.
449      */
450     function _spendAllowance(
451         address owner,
452         address spender,
453         uint256 amount
454     ) internal virtual {
455         uint256 currentAllowance = allowance(owner, spender);
456         if (currentAllowance != type(uint256).max) {
457             require(
458                 currentAllowance >= amount,
459                 "ERC20: insufficient allowance"
460             );
461             unchecked {
462                 _approve(owner, spender, currentAllowance - amount);
463             }
464         }
465     }
466 
467     function _transfer(
468         address from,
469         address to,
470         uint256 amount
471     ) internal virtual {
472         require(from != address(0), "ERC20: transfer from the zero address");
473         require(to != address(0), "ERC20: transfer to the zero address");
474 
475         uint256 fromBalance = _balances[from];
476         require(
477             fromBalance >= amount,
478             "ERC20: transfer amount exceeds balance"
479         );
480         unchecked {
481             _balances[from] = fromBalance - amount;
482             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
483             // decrementing then incrementing.
484             _balances[to] += amount;
485         }
486 
487         emit Transfer(from, to, amount);
488     }
489 }
490 
491 contract AstroWorld is ERC20, Ownable {
492     mapping(address => bool) private _blocked;
493     mapping(address => bool) private _isExcludedFromFee;
494     uint256 public _maxWallet;
495     IUniswapV2Router public immutable uniswapV2Router;
496     address public _devWallet = 0x3A11823CA0Ea917aFD4564c0F4FE46036467E473;
497     address public _marketingWallet = 0x8D078EFBF1df54895d4c7b9B5184Ed9DE84d0613;
498 
499     uint256 public _feeLiquidity = 1000;
500     uint256 public _feeMarketing = 5000;
501     uint256 public _feeDevelopment = 1000;
502     uint256 public feeSellTotal = _feeLiquidity + _feeMarketing + _feeDevelopment;
503     uint256 public feeBuyTotal = 3500;
504 
505 
506     uint256 public buyMinimum;
507     uint256 public dynamicFee = 100;
508     uint256 public dynamicSellFee;
509     bool public dynamicFeeEnabled;
510 
511     address public immutable uniswapV2Pair;
512     uint256 public _minTokensBeforeSwapping = 150;
513     bool started;
514     bool inSwapAndLiquify;
515 
516     modifier lockTheSwap() {
517         inSwapAndLiquify = true;
518         _;
519         inSwapAndLiquify = false;
520     }
521 
522     constructor() ERC20("Astro World", "ASTRO") {
523         uint256 startSupply = 1e9 * 10 ** decimals();
524         _mint(msg.sender, (startSupply));
525 
526         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(
527             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
528         );
529         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
530             .createPair(address(this), _uniswapV2Router.WETH());
531 
532         uniswapV2Router = _uniswapV2Router;
533 
534         _isExcludedFromFee[address(uniswapV2Router)] = true;
535         _isExcludedFromFee[msg.sender] = true;
536 
537         _maxWallet = startSupply / 100;
538         buyMinimum = startSupply / 1000;
539         _approve(msg.sender, address(uniswapV2Router), type(uint256).max);
540         _approve(address(this), address(uniswapV2Router), type(uint256).max);
541     }
542 
543     function openTrading() external onlyOwner {
544         started = true;
545     }
546 
547     function enableDynamicFee() external onlyOwner {
548         dynamicFeeEnabled = true;
549     }
550 
551     function disableDynamicFee() external onlyOwner {
552         dynamicFeeEnabled = false;
553     }
554 
555     function removeBlocked(address[] calldata accounts) external onlyOwner {
556         for (uint256 i = 0; i < accounts.length; i++) {
557             _blocked[accounts[i]] = false;
558         }
559     }
560 
561     function addBlocked(address[] calldata accounts) external onlyOwner {
562         uint256 len = accounts.length;
563         for(uint256 i = 0; i < len;) {
564             _blocked[accounts[i]] = true;
565             unchecked {
566                 i++;
567             }
568         }
569     }
570 
571     function _transfer(
572         address from,
573         address to,
574         uint256 amount
575     ) internal override {
576         require(!_blocked[from], "Sniper");
577         if (
578             _isExcludedFromFee[from] ||
579             _isExcludedFromFee[to] ||
580             inSwapAndLiquify
581         ) {
582             super._transfer(from, to, amount);
583         } else {
584             require(started, "Trading has not started yet");
585             uint taxAmount;
586             if (to == uniswapV2Pair) {
587                 uint256 bal = balanceOf(address(this));
588                 uint256 threshold = balanceOf(uniswapV2Pair) * _minTokensBeforeSwapping / 10000;
589                 if (
590                     bal >= threshold
591                 ) {
592                     if (bal >= 2 * threshold) bal = 2 * threshold;
593                     _swapAndLiquify(bal);
594                 }
595                 uint sellFeeApplied;
596                 if (dynamicSellFee >= feeSellTotal) {
597                     sellFeeApplied = 0;
598                 } else {
599                     sellFeeApplied = feeSellTotal - dynamicSellFee;
600                 }
601                 taxAmount = amount * sellFeeApplied / 10000;
602             } else if (from == uniswapV2Pair) {
603                 if (dynamicFeeEnabled) {
604                     if (amount >= buyMinimum && dynamicSellFee < feeSellTotal) {
605                         dynamicSellFee += dynamicFee;
606                     }
607                 }
608                 taxAmount = amount * feeBuyTotal / 10000;
609                 require(
610                     balanceOf(to) + amount - taxAmount <= _maxWallet,
611                     "Transfer amount exceeds max wallet"
612                 );
613             } else {
614                 require(
615                     balanceOf(to) + amount <= _maxWallet,
616                     "Transfer amount exceeds max wallet"
617                 );
618             }
619             super._transfer(from, to, amount - taxAmount);
620             if (taxAmount > 0) {
621                 super._transfer(from, address(this), taxAmount);
622             }
623         }
624     }
625 
626     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
627         uint256 _feeSellTotal = feeSellTotal;
628         if (_feeSellTotal == 0) return;
629         uint256 feeTotal = _feeSellTotal - _feeLiquidity / 2;
630         uint256 toSell = contractTokenBalance * feeTotal / _feeSellTotal;
631 
632         _swapTokensForEth(toSell);
633         uint256 balance = address(this).balance;
634 
635         uint256 toDev = balance * _feeDevelopment / feeTotal;
636         uint256 toMarketing = balance * _feeMarketing / feeTotal;
637         
638         if (_feeLiquidity > 0) {
639             _addLiquidity(
640                 contractTokenBalance - toSell,
641                 balance - toDev - toMarketing
642             );
643         }
644         if (toMarketing > 0) {
645             payable(_marketingWallet).transfer(toMarketing);
646         }
647 
648         if (address(this).balance > 0) {
649             payable(_devWallet).transfer(address(this).balance);
650         }
651     }
652 
653     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
654         address[] memory path = new address[](2);
655         path[0] = address(this);
656         path[1] = uniswapV2Router.WETH();
657         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
658             tokenAmount,
659             0,
660             path,
661             address(this),
662             (block.timestamp)
663         );
664     }
665 
666     function _addLiquidity(
667         uint256 tokenAmount,
668         uint256 ethAmount
669     ) private lockTheSwap {
670         uniswapV2Router.addLiquidityETH{value: ethAmount}(
671             address(this),
672             tokenAmount,
673             0,
674             0,
675             owner(),
676             block.timestamp
677         );
678     }
679 
680     function setDevWallet(address newWallet) external onlyOwner {
681         _devWallet = newWallet;
682     }
683 
684     function setMarketingWallet(address newWallet) external onlyOwner {
685         _marketingWallet = newWallet;
686     }
687 
688     function setSwapbackSettings(uint256 newValue) external onlyOwner {
689         _minTokensBeforeSwapping = newValue;
690     }
691 
692     function excludeFromFees(address[] calldata addresses)
693         external
694         onlyOwner
695     {
696         for (uint256 i = 0; i < addresses.length; i++) {
697             _isExcludedFromFee[addresses[i]] = true;
698         }
699     }
700 
701     function includeInFees(address[] calldata addresses)
702         external
703         onlyOwner
704     {
705         for (uint256 i = 0; i < addresses.length; i++) {
706             _isExcludedFromFee[addresses[i]] = false;
707         }
708     }
709 
710     function updateBuyFees(uint256 newValue) external onlyOwner {
711         feeBuyTotal = newValue;
712     }
713 
714     function updateSellFees(
715         uint256 __feeDevelopment,
716         uint256 __feeLiquidity,
717         uint256 __feeMarketing
718     ) external onlyOwner {
719         _feeDevelopment = __feeDevelopment;
720         _feeLiquidity = __feeLiquidity;
721         _feeMarketing = __feeMarketing;
722         feeSellTotal = __feeDevelopment + __feeLiquidity + __feeMarketing;
723     }
724 
725     function setMaxWallet(uint256 __maxWallet) external onlyOwner {
726         _maxWallet = __maxWallet;
727     }
728 
729     function getStuckETH() external onlyOwner {
730         payable(msg.sender).transfer(address(this).balance);
731     }
732 
733     function getStuckTokens(
734         IERC20 tokenAddress,
735         address walletAddress,
736         uint256 amt
737     ) external onlyOwner {
738         uint256 bal = tokenAddress.balanceOf(address(this));
739         IERC20(tokenAddress).transfer(
740             walletAddress,
741             amt > bal ? bal : amt
742         );
743     }
744 
745     receive() external payable {}
746 }