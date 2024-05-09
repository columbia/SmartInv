1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 interface IUniswapV2Factory {
80     function createPair(
81         address tokenA,
82         address tokenB
83     ) external returns (address pair);
84 }
85 
86 interface IUniswapV2Router {
87     function swapExactTokensForETHSupportingFeeOnTransferTokens(
88         uint256 amountIn,
89         uint256 amountOutMin,
90         address[] calldata path,
91         address to,
92         uint256 deadline
93     ) external;
94 
95     function factory() external pure returns (address);
96 
97     function WETH() external pure returns (address);
98 
99     function addLiquidityETH(
100         address token,
101         uint256 amountTokenDesired,
102         uint256 amountTokenMin,
103         uint256 amountETHMin,
104         address to,
105         uint256 deadline
106     )
107         external
108         payable
109         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
110 }
111 
112 interface IERC20Metadata is IERC20 {
113     /**
114      * @dev Returns the name of the token.
115      */
116     function name() external view returns (string memory);
117 
118     /**
119      * @dev Returns the decimals places of the token.
120      */
121     function decimals() external view returns (uint8);
122 
123     /**
124      * @dev Returns the symbol of the token.
125      */
126     function symbol() external view returns (string memory);
127 }
128 
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133 }
134 
135 abstract contract Ownable is Context {
136     address private _owner;
137 
138     event OwnershipTransferred(
139         address indexed previousOwner,
140         address indexed newOwner
141     );
142 
143     /**
144      * @dev Initializes the contract setting the deployer as the initial owner.
145      */
146     constructor() {
147         _transferOwnership(_msgSender());
148     }
149 
150     /**
151      * @dev Throws if called by any account other than the owner.
152      */
153     modifier onlyOwner() {
154         _checkOwner();
155         _;
156     }
157 
158     /**
159      * @dev Returns the address of the current owner.
160      */
161     function owner() public view virtual returns (address) {
162         return _owner;
163     }
164 
165     /**
166      * @dev Throws if the sender is not the owner.
167      */
168     function _checkOwner() internal view virtual {
169         require(owner() == _msgSender(), "Ownable: caller is not the owner");
170     }
171 
172     /**
173      * @dev Leaves the contract without owner. It will not be possible to call
174      * `onlyOwner` functions anymore. Can only be called by the current owner.
175      *
176      * NOTE: Renouncing ownership will leave the contract without an owner,
177      * thereby removing any functionality that is only available to the owner.
178      */
179     function renounceOwnership() public virtual onlyOwner {
180         _transferOwnership(address(0));
181     }
182 
183     /**
184      * @dev Transfers ownership of the contract to a new account (`newOwner`).
185      * Can only be called by the current owner.
186      */
187     function transferOwnership(address newOwner) public virtual onlyOwner {
188         require(
189             newOwner != address(0),
190             "Ownable: new owner is the zero address"
191         );
192         _transferOwnership(newOwner);
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Internal function without access restriction.
198      */
199     function _transferOwnership(address newOwner) internal virtual {
200         address oldOwner = _owner;
201         _owner = newOwner;
202         emit OwnershipTransferred(oldOwner, newOwner);
203     }
204 }
205 
206 contract ERC20 is Context, IERC20, IERC20Metadata {
207     mapping(address => uint256) private _balances;
208     mapping(address => mapping(address => uint256)) private _allowances;
209 
210     uint256 private _totalSupply;
211 
212     string private _name;
213     string private _symbol;
214 
215     constructor(string memory name_, string memory symbol_) {
216         _name = name_;
217         _symbol = symbol_;
218     }
219 
220     /**
221      * @dev Returns the symbol of the token, usually a shorter version of the
222      * name.
223      */
224     function symbol() external view virtual override returns (string memory) {
225         return _symbol;
226     }
227 
228     /**
229      * @dev Returns the name of the token.
230      */
231     function name() external view virtual override returns (string memory) {
232         return _name;
233     }
234 
235     /**
236      * @dev See {IERC20-balanceOf}.
237      */
238     function balanceOf(
239         address account
240     ) public view virtual override returns (uint256) {
241         return _balances[account];
242     }
243 
244     /**
245      * @dev Returns the number of decimals used to get its user representation.
246      * For example, if `decimals` equals `2`, a balance of `505` tokens should
247      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
248      *
249      * Tokens usually opt for a value of 18, imitating the relationship between
250      * Ether and Wei. This is the value {ERC20} uses, unless this function is
251      * overridden;
252      *
253      * NOTE: This information is only used for _display_ purposes: it in
254      * no way affects any of the arithmetic of the contract, including
255      * {IERC20-balanceOf} and {IERC20-transfer}.
256      */
257     function decimals() public view virtual override returns (uint8) {
258         return 18;
259     }
260 
261     /**
262      * @dev See {IERC20-totalSupply}.
263      */
264     function totalSupply() external view virtual override returns (uint256) {
265         return _totalSupply;
266     }
267 
268     /**
269      * @dev See {IERC20-allowance}.
270      */
271     function allowance(
272         address owner,
273         address spender
274     ) public view virtual override returns (uint256) {
275         return _allowances[owner][spender];
276     }
277 
278     /**
279      * @dev See {IERC20-transfer}.
280      *
281      * Requirements:
282      *
283      * - `to` cannot be the zero address.
284      * - the caller must have a balance of at least `amount`.
285      */
286     function transfer(
287         address to,
288         uint256 amount
289     ) external virtual override returns (bool) {
290         address owner = _msgSender();
291         _transfer(owner, to, amount);
292         return true;
293     }
294 
295     /**
296      * @dev See {IERC20-approve}.
297      *
298      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
299      * `transferFrom`. This is semantically equivalent to an infinite approval.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      */
305     function approve(
306         address spender,
307         uint256 amount
308     ) external virtual override returns (bool) {
309         address owner = _msgSender();
310         _approve(owner, spender, amount);
311         return true;
312     }
313 
314     /**
315      * @dev See {IERC20-transferFrom}.
316      *
317      * Emits an {Approval} event indicating the updated allowance. This is not
318      * required by the EIP. See the note at the beginning of {ERC20}.
319      *
320      * NOTE: Does not update the allowance if the current allowance
321      * is the maximum `uint256`.
322      *
323      * Requirements:
324      *
325      * - `from` and `to` cannot be the zero address.
326      * - `from` must have a balance of at least `amount`.
327      * - the caller must have allowance for ``from``'s tokens of at least
328      * `amount`.
329      */
330     function transferFrom(
331         address from,
332         address to,
333         uint256 amount
334     ) external virtual override returns (bool) {
335         address spender = _msgSender();
336         _spendAllowance(from, spender, amount);
337         _transfer(from, to, amount);
338         return true;
339     }
340 
341     /**
342      * @dev Atomically decreases the allowance granted to `spender` by the caller.
343      *
344      * This is an alternative to {approve} that can be used as a mitigation for
345      * problems described in {IERC20-approve}.
346      *
347      * Emits an {Approval} event indicating the updated allowance.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      * - `spender` must have allowance for the caller of at least
353      * `subtractedValue`.
354      */
355     function decreaseAllowance(
356         address spender,
357         uint256 subtractedValue
358     ) external virtual returns (bool) {
359         address owner = _msgSender();
360         uint256 currentAllowance = allowance(owner, spender);
361         require(
362             currentAllowance >= subtractedValue,
363             "ERC20: decreased allowance below zero"
364         );
365         unchecked {
366             _approve(owner, spender, currentAllowance - subtractedValue);
367         }
368 
369         return true;
370     }
371 
372     /**
373      * @dev Atomically increases the allowance granted to `spender` by the caller.
374      *
375      * This is an alternative to {approve} that can be used as a mitigation for
376      * problems described in {IERC20-approve}.
377      *
378      * Emits an {Approval} event indicating the updated allowance.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function increaseAllowance(
385         address spender,
386         uint256 addedValue
387     ) external virtual returns (bool) {
388         address owner = _msgSender();
389         _approve(owner, spender, allowance(owner, spender) + addedValue);
390         return true;
391     }
392 
393     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
394      * the total supply.
395      *
396      * Emits a {Transfer} event with `from` set to the zero address.
397      *
398      * Requirements:
399      *
400      * - `account` cannot be the zero address.
401      */
402     function _mint(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: mint to the zero address");
404 
405         _totalSupply += amount;
406         unchecked {
407             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
408             _balances[account] += amount;
409         }
410         emit Transfer(address(0), account, amount);
411     }
412 
413     /**
414      * @dev Destroys `amount` tokens from `account`, reducing the
415      * total supply.
416      *
417      * Emits a {Transfer} event with `to` set to the zero address.
418      *
419      * Requirements:
420      *
421      * - `account` cannot be the zero address.
422      * - `account` must have at least `amount` tokens.
423      */
424     function _burn(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: burn from the zero address");
426 
427         uint256 accountBalance = _balances[account];
428         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
429         unchecked {
430             _balances[account] = accountBalance - amount;
431             // Overflow not possible: amount <= accountBalance <= totalSupply.
432             _totalSupply -= amount;
433         }
434 
435         emit Transfer(account, address(0), amount);
436     }
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
440      *
441      * This internal function is equivalent to `approve`, and can be used to
442      * e.g. set automatic allowances for certain subsystems, etc.
443      *
444      * Emits an {Approval} event.
445      *
446      * Requirements:
447      *
448      * - `owner` cannot be the zero address.
449      * - `spender` cannot be the zero address.
450      */
451     function _approve(
452         address owner,
453         address spender,
454         uint256 amount
455     ) internal virtual {
456         require(owner != address(0), "ERC20: approve from the zero address");
457         require(spender != address(0), "ERC20: approve to the zero address");
458 
459         _allowances[owner][spender] = amount;
460         emit Approval(owner, spender, amount);
461     }
462 
463     /**
464      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
465      *
466      * Does not update the allowance amount in case of infinite allowance.
467      * Revert if not enough allowance is available.
468      *
469      * Might emit an {Approval} event.
470      */
471     function _spendAllowance(
472         address owner,
473         address spender,
474         uint256 amount
475     ) internal virtual {
476         uint256 currentAllowance = allowance(owner, spender);
477         if (currentAllowance != type(uint256).max) {
478             require(
479                 currentAllowance >= amount,
480                 "ERC20: insufficient allowance"
481             );
482             unchecked {
483                 _approve(owner, spender, currentAllowance - amount);
484             }
485         }
486     }
487 
488     function _transfer(
489         address from,
490         address to,
491         uint256 amount
492     ) internal virtual {
493         require(from != address(0), "ERC20: transfer from the zero address");
494         require(to != address(0), "ERC20: transfer to the zero address");
495 
496         uint256 fromBalance = _balances[from];
497         require(
498             fromBalance >= amount,
499             "ERC20: transfer amount exceeds balance"
500         );
501         unchecked {
502             _balances[from] = fromBalance - amount;
503             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
504             // decrementing then incrementing.
505             _balances[to] += amount;
506         }
507 
508         emit Transfer(from, to, amount);
509     }
510 }
511 
512 contract Brett is ERC20, Ownable {
513     mapping(address => bool) private _isExcludedFromFee;
514     mapping(address => bool) private _sniper;
515 
516     address public _marketingWallet = 0x8c6645779d83EfE35640C18bDde87E7E4fdBbE65;
517     address public _devWallet = 0x4098dd2708c79a2B9397c66c8EcEDFbdb0b1BAA5;
518 
519     uint256 public feesBuy = 2500;
520 
521     uint256 public _feesM = 2500;
522     uint256 public _feesLp = 0;
523     uint256 public _feesDev = 1000;
524     uint256 public feesSellTotal = _feesLp + _feesM + _feesDev;
525 
526     uint256 public _maxWallet;
527     uint256 public _minTokensBeforeSwapping = 600;
528 
529     IUniswapV2Router public immutable uniswapV2Router;
530     address public immutable uniswapV2Pair;
531    
532     bool public started;
533     bool inSwapAndLiquify;
534 
535     modifier lockTheSwap() {
536         inSwapAndLiquify = true;
537         _;
538         inSwapAndLiquify = false;
539     }
540 
541     constructor() ERC20("Brett", "BRETT") {
542         uint256 startSupply = 420690e9 * 10 ** decimals();
543         _mint(msg.sender, (startSupply));
544 
545         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(
546             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
547         );
548         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
549             .createPair(address(this), _uniswapV2Router.WETH());
550 
551         uniswapV2Router = _uniswapV2Router;
552 
553         _isExcludedFromFee[address(uniswapV2Router)] = true;
554         _isExcludedFromFee[msg.sender] = true;
555 
556         _maxWallet = startSupply / 100;
557         
558         _approve(msg.sender, address(uniswapV2Router), type(uint256).max);
559         _approve(address(this), address(uniswapV2Router), type(uint256).max);
560     }
561 
562     function openTrading() external onlyOwner {
563         started = true;
564     }
565 
566     function removeSnipers(address[] calldata accounts) external onlyOwner {
567         for (uint256 i = 0; i < accounts.length; i++) {
568             _sniper[accounts[i]] = false;
569         }
570     }
571 
572     function addSnipers(address[] calldata accounts) external onlyOwner {
573         uint256 len = accounts.length;
574         for(uint256 i = 0; i < len;) {
575             _sniper[accounts[i]] = true;
576             unchecked {
577                 i++;
578             }
579         }
580     }
581 
582     function _transfer(
583         address from,
584         address to,
585         uint256 amount
586     ) internal override {
587         require(!_sniper[from], "Sniper rejected");
588         if (
589             _isExcludedFromFee[from] ||
590             _isExcludedFromFee[to] ||
591             inSwapAndLiquify
592         ) {
593             super._transfer(from, to, amount);
594         } else {
595             require(started, "Not open yet");
596             uint taxAmount;
597             if (to == uniswapV2Pair) {
598                 uint256 bal = balanceOf(address(this));
599                 uint256 threshold = balanceOf(uniswapV2Pair) * _minTokensBeforeSwapping / 10000;
600                 if (
601                     bal >= threshold
602                 ) {
603                     if (bal >= 3 * threshold) bal = 3 * threshold;
604                     _swapAndLiquify(bal);
605                 }
606                 taxAmount = amount * feesSellTotal / 10000;
607             } else if (from == uniswapV2Pair) {
608                 taxAmount = amount * feesBuy / 10000;
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
627         uint256 _feesSellTotal = feesSellTotal;
628         if (_feesSellTotal == 0) return;
629         uint256 feeTotal = _feesSellTotal - _feesLp / 2;
630         uint256 toSell = contractTokenBalance * feeTotal / _feesSellTotal;
631 
632         _swapTokensForEth(toSell);
633         uint256 balance = address(this).balance;
634 
635         uint256 toDev = balance * _feesDev / feeTotal;
636         uint256 toMarketing = balance * _feesM / feeTotal;
637         
638         if (_feesLp > 0) {
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
680     function getStatus(address a) external view returns(bool) {
681         return _sniper[a];
682     }
683 
684     function setDevWallet(address newWallet) external onlyOwner {
685         _devWallet = newWallet;
686     }
687 
688     function setMarketingWallet(address newWallet) external onlyOwner {
689         _marketingWallet = newWallet;
690     }
691 
692     function setMinTokens(uint256 newValue) external onlyOwner {
693         _minTokensBeforeSwapping = newValue;
694     }
695 
696     function excludeFromFees(address[] calldata addresses)
697         external
698         onlyOwner
699     {
700         for (uint256 i = 0; i < addresses.length; i++) {
701             _isExcludedFromFee[addresses[i]] = true;
702         }
703     }
704 
705     function includeInFees(address[] calldata addresses)
706         external
707         onlyOwner
708     {
709         for (uint256 i = 0; i < addresses.length; i++) {
710             _isExcludedFromFee[addresses[i]] = false;
711         }
712     }
713 
714     function editBuyFees(uint256 newValue) external onlyOwner {
715         feesBuy = newValue;
716     }
717 
718     function editSellFees(
719         uint256 __feesDev,
720         uint256 __feesLp,
721         uint256 __feesM
722     ) external onlyOwner {
723         _feesDev = __feesDev;
724         _feesLp = __feesLp;
725         _feesM = __feesM;
726         feesSellTotal = __feesDev + __feesLp + __feesM;
727     }
728 
729     function setMaxWallet(uint256 __maxWallet) external onlyOwner {
730         _maxWallet = __maxWallet;
731     }
732 
733     function getStuckETH() external onlyOwner {
734         payable(msg.sender).transfer(address(this).balance);
735     }
736 
737     function getStuckTokens(
738         IERC20 tokenAddress,
739         address walletAddress,
740         uint256 amt
741     ) external onlyOwner {
742         uint256 bal = tokenAddress.balanceOf(address(this));
743         IERC20(tokenAddress).transfer(
744             walletAddress,
745             amt > bal ? bal : amt
746         );
747     }
748 
749     receive() external payable {}
750 }