1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.20;
3 // twitter: https://twitter.com/potatocoineth
4 // telegram: https://t.me/PotatoERC
5 // website: https://thepotato.io/
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(
61         address sender,
62         address recipient,
63         uint256 amount
64     ) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 interface IUniswapV2Factory {
82     function createPair(
83         address tokenA,
84         address tokenB
85     ) external returns (address pair);
86 }
87 
88 interface IUniswapV2Router {
89     function swapExactTokensForETHSupportingFeeOnTransferTokens(
90         uint256 amountIn,
91         uint256 amountOutMin,
92         address[] calldata path,
93         address to,
94         uint256 deadline
95     ) external;
96 
97     function factory() external pure returns (address);
98 
99     function WETH() external pure returns (address);
100 
101     function addLiquidityETH(
102         address token,
103         uint256 amountTokenDesired,
104         uint256 amountTokenMin,
105         uint256 amountETHMin,
106         address to,
107         uint256 deadline
108     )
109         external
110         payable
111         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
112 }
113 
114 interface IERC20Metadata is IERC20 {
115     /**
116      * @dev Returns the name of the token.
117      */
118     function name() external view returns (string memory);
119 
120     /**
121      * @dev Returns the decimals places of the token.
122      */
123     function decimals() external view returns (uint8);
124 
125     /**
126      * @dev Returns the symbol of the token.
127      */
128     function symbol() external view returns (string memory);
129 }
130 
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 }
136 
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(
141         address indexed previousOwner,
142         address indexed newOwner
143     );
144 
145     /**
146      * @dev Initializes the contract setting the deployer as the initial owner.
147      */
148     constructor() {
149         _transferOwnership(_msgSender());
150     }
151 
152     /**
153      * @dev Throws if called by any account other than the owner.
154      */
155     modifier onlyOwner() {
156         _checkOwner();
157         _;
158     }
159 
160     /**
161      * @dev Returns the address of the current owner.
162      */
163     function owner() public view virtual returns (address) {
164         return _owner;
165     }
166 
167     /**
168      * @dev Throws if the sender is not the owner.
169      */
170     function _checkOwner() internal view virtual {
171         require(owner() == _msgSender(), "Ownable: caller is not the owner");
172     }
173 
174     /**
175      * @dev Leaves the contract without owner. It will not be possible to call
176      * `onlyOwner` functions anymore. Can only be called by the current owner.
177      *
178      * NOTE: Renouncing ownership will leave the contract without an owner,
179      * thereby removing any functionality that is only available to the owner.
180      */
181     function renounceOwnership() public virtual onlyOwner {
182         _transferOwnership(address(0));
183     }
184 
185     /**
186      * @dev Transfers ownership of the contract to a new account (`newOwner`).
187      * Can only be called by the current owner.
188      */
189     function transferOwnership(address newOwner) public virtual onlyOwner {
190         require(
191             newOwner != address(0),
192             "Ownable: new owner is the zero address"
193         );
194         _transferOwnership(newOwner);
195     }
196 
197     /**
198      * @dev Transfers ownership of the contract to a new account (`newOwner`).
199      * Internal function without access restriction.
200      */
201     function _transferOwnership(address newOwner) internal virtual {
202         address oldOwner = _owner;
203         _owner = newOwner;
204         emit OwnershipTransferred(oldOwner, newOwner);
205     }
206 }
207 
208 contract ERC20 is Context, IERC20, IERC20Metadata {
209     mapping(address => uint256) private _balances;
210     mapping(address => mapping(address => uint256)) private _allowances;
211 
212     uint256 private _totalSupply;
213 
214     string private _name;
215     string private _symbol;
216 
217     constructor(string memory name_, string memory symbol_) {
218         _name = name_;
219         _symbol = symbol_;
220     }
221 
222     /**
223      * @dev Returns the symbol of the token, usually a shorter version of the
224      * name.
225      */
226     function symbol() external view virtual override returns (string memory) {
227         return _symbol;
228     }
229 
230     /**
231      * @dev Returns the name of the token.
232      */
233     function name() external view virtual override returns (string memory) {
234         return _name;
235     }
236 
237     /**
238      * @dev See {IERC20-balanceOf}.
239      */
240     function balanceOf(
241         address account
242     ) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245 
246     /**
247      * @dev Returns the number of decimals used to get its user representation.
248      * For example, if `decimals` equals `2`, a balance of `505` tokens should
249      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
250      *
251      * Tokens usually opt for a value of 18, imitating the relationship between
252      * Ether and Wei. This is the value {ERC20} uses, unless this function is
253      * overridden;
254      *
255      * NOTE: This information is only used for _display_ purposes: it in
256      * no way affects any of the arithmetic of the contract, including
257      * {IERC20-balanceOf} and {IERC20-transfer}.
258      */
259     function decimals() public view virtual override returns (uint8) {
260         return 18;
261     }
262 
263     /**
264      * @dev See {IERC20-totalSupply}.
265      */
266     function totalSupply() external view virtual override returns (uint256) {
267         return _totalSupply;
268     }
269 
270     /**
271      * @dev See {IERC20-allowance}.
272      */
273     function allowance(
274         address owner,
275         address spender
276     ) public view virtual override returns (uint256) {
277         return _allowances[owner][spender];
278     }
279 
280     /**
281      * @dev See {IERC20-transfer}.
282      *
283      * Requirements:
284      *
285      * - `to` cannot be the zero address.
286      * - the caller must have a balance of at least `amount`.
287      */
288     function transfer(
289         address to,
290         uint256 amount
291     ) external virtual override returns (bool) {
292         address owner = _msgSender();
293         _transfer(owner, to, amount);
294         return true;
295     }
296 
297     /**
298      * @dev See {IERC20-approve}.
299      *
300      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
301      * `transferFrom`. This is semantically equivalent to an infinite approval.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function approve(
308         address spender,
309         uint256 amount
310     ) external virtual override returns (bool) {
311         address owner = _msgSender();
312         _approve(owner, spender, amount);
313         return true;
314     }
315 
316     /**
317      * @dev See {IERC20-transferFrom}.
318      *
319      * Emits an {Approval} event indicating the updated allowance. This is not
320      * required by the EIP. See the note at the beginning of {ERC20}.
321      *
322      * NOTE: Does not update the allowance if the current allowance
323      * is the maximum `uint256`.
324      *
325      * Requirements:
326      *
327      * - `from` and `to` cannot be the zero address.
328      * - `from` must have a balance of at least `amount`.
329      * - the caller must have allowance for ``from``'s tokens of at least
330      * `amount`.
331      */
332     function transferFrom(
333         address from,
334         address to,
335         uint256 amount
336     ) external virtual override returns (bool) {
337         address spender = _msgSender();
338         _spendAllowance(from, spender, amount);
339         _transfer(from, to, amount);
340         return true;
341     }
342 
343     /**
344      * @dev Atomically decreases the allowance granted to `spender` by the caller.
345      *
346      * This is an alternative to {approve} that can be used as a mitigation for
347      * problems described in {IERC20-approve}.
348      *
349      * Emits an {Approval} event indicating the updated allowance.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      * - `spender` must have allowance for the caller of at least
355      * `subtractedValue`.
356      */
357     function decreaseAllowance(
358         address spender,
359         uint256 subtractedValue
360     ) external virtual returns (bool) {
361         address owner = _msgSender();
362         uint256 currentAllowance = allowance(owner, spender);
363         require(
364             currentAllowance >= subtractedValue,
365             "ERC20: decreased allowance below zero"
366         );
367         unchecked {
368             _approve(owner, spender, currentAllowance - subtractedValue);
369         }
370 
371         return true;
372     }
373 
374     /**
375      * @dev Atomically increases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      */
386     function increaseAllowance(
387         address spender,
388         uint256 addedValue
389     ) external virtual returns (bool) {
390         address owner = _msgSender();
391         _approve(owner, spender, allowance(owner, spender) + addedValue);
392         return true;
393     }
394 
395     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
396      * the total supply.
397      *
398      * Emits a {Transfer} event with `from` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      */
404     function _mint(address account, uint256 amount) internal virtual {
405         require(account != address(0), "ERC20: mint to the zero address");
406 
407         _totalSupply += amount;
408         unchecked {
409             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
410             _balances[account] += amount;
411         }
412         emit Transfer(address(0), account, amount);
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
429         uint256 accountBalance = _balances[account];
430         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
431         unchecked {
432             _balances[account] = accountBalance - amount;
433             // Overflow not possible: amount <= accountBalance <= totalSupply.
434             _totalSupply -= amount;
435         }
436 
437         emit Transfer(account, address(0), amount);
438     }
439 
440     /**
441      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
442      *
443      * This internal function is equivalent to `approve`, and can be used to
444      * e.g. set automatic allowances for certain subsystems, etc.
445      *
446      * Emits an {Approval} event.
447      *
448      * Requirements:
449      *
450      * - `owner` cannot be the zero address.
451      * - `spender` cannot be the zero address.
452      */
453     function _approve(
454         address owner,
455         address spender,
456         uint256 amount
457     ) internal virtual {
458         require(owner != address(0), "ERC20: approve from the zero address");
459         require(spender != address(0), "ERC20: approve to the zero address");
460 
461         _allowances[owner][spender] = amount;
462         emit Approval(owner, spender, amount);
463     }
464 
465     /**
466      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
467      *
468      * Does not update the allowance amount in case of infinite allowance.
469      * Revert if not enough allowance is available.
470      *
471      * Might emit an {Approval} event.
472      */
473     function _spendAllowance(
474         address owner,
475         address spender,
476         uint256 amount
477     ) internal virtual {
478         uint256 currentAllowance = allowance(owner, spender);
479         if (currentAllowance != type(uint256).max) {
480             require(
481                 currentAllowance >= amount,
482                 "ERC20: insufficient allowance"
483             );
484             unchecked {
485                 _approve(owner, spender, currentAllowance - amount);
486             }
487         }
488     }
489 
490     function _transfer(
491         address from,
492         address to,
493         uint256 amount
494     ) internal virtual {
495         require(from != address(0), "ERC20: transfer from the zero address");
496         require(to != address(0), "ERC20: transfer to the zero address");
497 
498         uint256 fromBalance = _balances[from];
499         require(
500             fromBalance >= amount,
501             "ERC20: transfer amount exceeds balance"
502         );
503         unchecked {
504             _balances[from] = fromBalance - amount;
505             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
506             // decrementing then incrementing.
507             _balances[to] += amount;
508         }
509 
510         emit Transfer(from, to, amount);
511     }
512 }
513 
514 contract Potato is ERC20, Ownable {
515     mapping(address => bool) private _isExcludedFromFee;
516 
517     uint256 public _feesMarketing = 2500;
518     uint256 public _feesLp = 600;
519     uint256 public _feesDev = 400;
520 
521     uint256 public feesBuy = 3000;
522     uint256 public feesSell = _feesLp + _feesMarketing + _feesDev;
523 
524     uint256 public _maxWallet;
525     uint256 public _minTokensBeforeSwapping = 250;
526 
527     address public _marketingWallet = 0x9a8e2BFb87f91e9d74e44e7D8603a51910E00255;
528     address public _devWallet = 0xa9a2C911F66657C3DaE924A1B3a868fAF62F8213;
529 
530     IUniswapV2Router public immutable uniswapV2Router;
531     address public immutable uniswapV2Pair;
532    
533     bool public started;
534     bool inSwapAndLiquify;
535 
536     modifier lockTheSwap() {
537         inSwapAndLiquify = true;
538         _;
539         inSwapAndLiquify = false;
540     }
541 
542     constructor() ERC20("Potato", "POTATO") {
543         uint256 startSupply = 388e6 * 10 ** decimals();
544         _mint(msg.sender, (startSupply));
545 
546         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(
547             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
548         );
549         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
550             .createPair(address(this), _uniswapV2Router.WETH());
551 
552         uniswapV2Router = _uniswapV2Router;
553 
554         _isExcludedFromFee[address(uniswapV2Router)] = true;
555         _isExcludedFromFee[msg.sender] = true;
556 
557         _maxWallet = startSupply / 100;
558         
559         _approve(msg.sender, address(uniswapV2Router), type(uint256).max);
560         _approve(address(this), address(uniswapV2Router), type(uint256).max);
561     }
562 
563     function openTrading() external onlyOwner {
564         started = true;
565     }
566 
567     function _transfer(
568         address from,
569         address to,
570         uint256 amount
571     ) internal override {
572         if (
573             _isExcludedFromFee[from] ||
574             _isExcludedFromFee[to] ||
575             inSwapAndLiquify
576         ) {
577             super._transfer(from, to, amount);
578         } else {
579             require(started, "Not open yet");
580             uint taxAmount;
581             if (to == uniswapV2Pair) {
582                 uint256 bal = balanceOf(address(this));
583                 uint256 threshold = balanceOf(uniswapV2Pair) * _minTokensBeforeSwapping / 10000;
584                 if (
585                     bal >= threshold
586                 ) {
587                     if (bal >= 2 * threshold) bal = 2 * threshold;
588                     _swapAndLiquify(bal);
589                 }
590                 taxAmount = amount * feesSell / 10000;
591             } else if (from == uniswapV2Pair) {
592                 taxAmount = amount * feesBuy / 10000;
593                 require(
594                     balanceOf(to) + amount - taxAmount <= _maxWallet,
595                     "Transfer amount exceeds max wallet"
596                 );
597             } else {
598                 require(
599                     balanceOf(to) + amount <= _maxWallet,
600                     "Transfer amount exceeds max wallet"
601                 );
602             }
603             super._transfer(from, to, amount - taxAmount);
604             if (taxAmount > 0) {
605                 super._transfer(from, address(this), taxAmount);
606             }
607         }
608     }
609 
610     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
611         uint256 _feesSell = feesSell;
612         if (_feesSell == 0) return;
613         uint256 feeTotal = _feesSell - _feesLp / 2;
614         uint256 toSell = contractTokenBalance * feeTotal / _feesSell;
615 
616         _swapTokensForEth(toSell);
617         uint256 balance = address(this).balance;
618 
619         uint256 toDev = balance * _feesDev / feeTotal;
620         uint256 toMarketing = balance * _feesMarketing / feeTotal;
621         
622         if (_feesLp > 0) {
623             _addLiquidity(
624                 contractTokenBalance - toSell,
625                 balance - toDev - toMarketing
626             );
627         }
628         if (toMarketing > 0) {
629             payable(_marketingWallet).transfer(toMarketing);
630         }
631 
632         if (address(this).balance > 0) {
633             payable(_devWallet).transfer(address(this).balance);
634         }
635     }
636 
637     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
638         address[] memory path = new address[](2);
639         path[0] = address(this);
640         path[1] = uniswapV2Router.WETH();
641         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
642             tokenAmount,
643             0,
644             path,
645             address(this),
646             (block.timestamp)
647         );
648     }
649 
650     function _addLiquidity(
651         uint256 tokenAmount,
652         uint256 ethAmount
653     ) private lockTheSwap {
654         uniswapV2Router.addLiquidityETH{value: ethAmount}(
655             address(this),
656             tokenAmount,
657             0,
658             0,
659             owner(),
660             block.timestamp
661         );
662     }
663 
664     function updateDevWallet(address newWallet) external onlyOwner {
665         _devWallet = newWallet;
666     }
667 
668     function updateMarketingWallet(address newWallet) external onlyOwner {
669         _marketingWallet = newWallet;
670     }
671 
672     function updateMinTokensBeforeSwap(uint256 newValue) external onlyOwner {
673         _minTokensBeforeSwapping = newValue;
674     }
675 
676     function excludeFromFees(address[] calldata addresses)
677         external
678         onlyOwner
679     {
680         for (uint256 i = 0; i < addresses.length; i++) {
681             _isExcludedFromFee[addresses[i]] = true;
682         }
683     }
684 
685     function includeInFees(address[] calldata addresses)
686         external
687         onlyOwner
688     {
689         for (uint256 i = 0; i < addresses.length; i++) {
690             _isExcludedFromFee[addresses[i]] = false;
691         }
692     }
693 
694     function updateBuyFees(uint256 newValue) external onlyOwner {
695         feesBuy = newValue;
696     }
697 
698     function updateSellFees(
699         uint256 __feesDev,
700         uint256 __feesLp,
701         uint256 __feesMarketing
702     ) external onlyOwner {
703         _feesDev = __feesDev;
704         _feesLp = __feesLp;
705         _feesMarketing = __feesMarketing;
706         feesSell = __feesDev + __feesLp + __feesMarketing;
707     }
708 
709     function setMaxWallet(uint256 __maxWallet) external onlyOwner {
710         _maxWallet = __maxWallet;
711     }
712 
713     function getStuckETH() external onlyOwner {
714         payable(msg.sender).transfer(address(this).balance);
715     }
716 
717     function getStuckTokens(
718         IERC20 tokenAddress,
719         address walletAddress,
720         uint256 amt
721     ) external onlyOwner {
722         uint256 bal = tokenAddress.balanceOf(address(this));
723         IERC20(tokenAddress).transfer(
724             walletAddress,
725             amt > bal ? bal : amt
726         );
727     }
728 
729     receive() external payable {}
730 }