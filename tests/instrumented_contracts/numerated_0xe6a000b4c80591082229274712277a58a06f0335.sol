1 /**
2 https://wapple.care
3 https://x.com/wappleerc20
4 https://t.me/wappleerc20
5 https://www.tiktok.com/@wapplewapple
6 
7 **/
8 
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity ^0.8.18;
12 pragma experimental ABIEncoderV2;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(
28         address indexed previousOwner,
29         address indexed newOwner
30     );
31 
32     /**
33      * @dev Initializes the contract setting the deployer as the initial owner.
34      */
35     constructor() {
36         _transferOwnership(_msgSender());
37     }
38 
39     /**
40      * @dev Returns the address of the current owner.
41      */
42     function owner() public view virtual returns (address) {
43         return _owner;
44     }
45 
46     /**
47      * @dev Throws if called by any account other than the owner.
48      */
49     modifier onlyOwner() {
50         require(owner() == _msgSender(), "Ownable: caller is not the owner");
51         _;
52     }
53 
54     function renounceOwnership() public virtual onlyOwner {
55         _transferOwnership(address(0));
56     }
57 
58     /**
59      * @dev Transfers ownership of the contract to a new account (`newOwner`).
60      * Can only be called by the current owner.
61      */
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(
64             newOwner != address(0),
65             "Ownable: new owner is the zero address"
66         );
67         _transferOwnership(newOwner);
68     }
69 
70     /**
71      * @dev Transfers ownership of the contract to a new account (`newOwner`).
72      * Internal function without access restriction.
73      */
74     function _transferOwnership(address newOwner) internal virtual {
75         address oldOwner = _owner;
76         _owner = newOwner;
77         emit OwnershipTransferred(oldOwner, newOwner);
78     }
79 }
80 
81 interface IERC20 {
82     /**
83      * @dev Returns the amount of tokens in existence.
84      */
85     function totalSupply() external view returns (uint256);
86 
87     /**
88      * @dev Returns the amount of tokens owned by `account`.
89      */
90     function balanceOf(address account) external view returns (uint256);
91 
92     /**
93      * @dev Moves `amount` tokens from the caller's account to `recipient`.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transfer(
100         address recipient,
101         uint256 amount
102     ) external returns (bool);
103 
104     function allowance(
105         address owner,
106         address spender
107     ) external view returns (uint256);
108 
109     function approve(address spender, uint256 amount) external returns (bool);
110 
111     function transferFrom(
112         address sender,
113         address recipient,
114         uint256 amount
115     ) external returns (bool);
116 
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(
130         address indexed owner,
131         address indexed spender,
132         uint256 value
133     );
134 }
135 
136 interface IERC20Metadata is IERC20 {
137     /**
138      * @dev Returns the name of the token.
139      */
140     function name() external view returns (string memory);
141 
142     /**
143      * @dev Returns the symbol of the token.
144      */
145     function symbol() external view returns (string memory);
146 
147     /**
148      * @dev Returns the decimals places of the token.
149      */
150     function decimals() external view returns (uint8);
151 }
152 
153 contract ERC20 is Context, IERC20, IERC20Metadata {
154     mapping(address => uint256) private _balances;
155 
156     mapping(address => mapping(address => uint256)) private _allowances;
157 
158     uint256 private _totalSupply;
159 
160     string private _name;
161     string private _symbol;
162 
163     /**
164      * @dev Sets the values for {name} and {symbol}.
165      *
166      * The default value of {decimals} is 18. To select a different value for
167      * {decimals} you should overload it.
168      *
169      * All two of these values are immutable: they can only be set once during
170      * construction.
171      */
172     constructor(string memory name_, string memory symbol_) {
173         _name = name_;
174         _symbol = symbol_;
175     }
176 
177     /**
178      * @dev Returns the name of the token.
179      */
180     function name() public view virtual override returns (string memory) {
181         return _name;
182     }
183 
184     /**
185      * @dev Returns the symbol of the token, usually a shorter version of the
186      * name.
187      */
188     function symbol() public view virtual override returns (string memory) {
189         return _symbol;
190     }
191 
192     function decimals() public view virtual override returns (uint8) {
193         return 18;
194     }
195 
196     /**
197      * @dev See {IERC20-totalSupply}.
198      */
199     function totalSupply() public view virtual override returns (uint256) {
200         return _totalSupply;
201     }
202 
203     /**
204      * @dev See {IERC20-balanceOf}.
205      */
206     function balanceOf(
207         address account
208     ) public view virtual override returns (uint256) {
209         return _balances[account];
210     }
211 
212     function transfer(
213         address recipient,
214         uint256 amount
215     ) public virtual override returns (bool) {
216         _transfer(_msgSender(), recipient, amount);
217         return true;
218     }
219 
220     /**
221      * @dev See {IERC20-allowance}.
222      */
223     function allowance(
224         address owner,
225         address spender
226     ) public view virtual override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     /**
231      * @dev See {IERC20-approve}.
232      *
233      * Requirements:
234      *
235      * - `spender` cannot be the zero address.
236      */
237     function approve(
238         address spender,
239         uint256 amount
240     ) public virtual override returns (bool) {
241         _approve(_msgSender(), spender, amount);
242         return true;
243     }
244 
245     function transferFrom(
246         address sender,
247         address recipient,
248         uint256 amount
249     ) public virtual override returns (bool) {
250         _transfer(sender, recipient, amount);
251 
252         uint256 currentAllowance = _allowances[sender][_msgSender()];
253         require(
254             currentAllowance >= amount,
255             "ERC20: transfer amount exceeds allowance"
256         );
257         unchecked {
258             _approve(sender, _msgSender(), currentAllowance - amount);
259         }
260 
261         return true;
262     }
263 
264     function increaseAllowance(
265         address spender,
266         uint256 addedValue
267     ) public virtual returns (bool) {
268         _approve(
269             _msgSender(),
270             spender,
271             _allowances[_msgSender()][spender] + addedValue
272         );
273         return true;
274     }
275 
276     function decreaseAllowance(
277         address spender,
278         uint256 subtractedValue
279     ) public virtual returns (bool) {
280         uint256 currentAllowance = _allowances[_msgSender()][spender];
281         require(
282             currentAllowance >= subtractedValue,
283             "ERC20: decreased allowance below zero"
284         );
285         unchecked {
286             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
287         }
288 
289         return true;
290     }
291 
292     function _transfer(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) internal virtual {
297         require(sender != address(0), "ERC20: transfer from the zero address");
298         require(recipient != address(0), "ERC20: transfer to the zero address");
299 
300         _beforeTokenTransfer(sender, recipient, amount);
301 
302         uint256 senderBalance = _balances[sender];
303         require(
304             senderBalance >= amount,
305             "ERC20: transfer amount exceeds balance"
306         );
307         unchecked {
308             _balances[sender] = senderBalance - amount;
309         }
310         _balances[recipient] += amount;
311 
312         emit Transfer(sender, recipient, amount);
313 
314         _afterTokenTransfer(sender, recipient, amount);
315     }
316 
317     function _mint(address account, uint256 amount) internal virtual {
318         require(account != address(0), "ERC20: mint to the zero address");
319 
320         _beforeTokenTransfer(address(0), account, amount);
321 
322         _totalSupply += amount;
323         _balances[account] += amount;
324         emit Transfer(address(0), account, amount);
325 
326         _afterTokenTransfer(address(0), account, amount);
327     }
328 
329     function _burn(address account, uint256 amount) internal virtual {
330         require(account != address(0), "ERC20: burn from the zero address");
331 
332         _beforeTokenTransfer(account, address(0), amount);
333 
334         uint256 accountBalance = _balances[account];
335         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
336         unchecked {
337             _balances[account] = accountBalance - amount;
338         }
339         _totalSupply -= amount;
340 
341         emit Transfer(account, address(0), amount);
342 
343         _afterTokenTransfer(account, address(0), amount);
344     }
345 
346     function _approve(
347         address owner,
348         address spender,
349         uint256 amount
350     ) internal virtual {
351         require(owner != address(0), "ERC20: approve from the zero address");
352         require(spender != address(0), "ERC20: approve to the zero address");
353 
354         _allowances[owner][spender] = amount;
355         emit Approval(owner, spender, amount);
356     }
357 
358     function _beforeTokenTransfer(
359         address from,
360         address to,
361         uint256 amount
362     ) internal virtual {}
363 
364     function _afterTokenTransfer(
365         address from,
366         address to,
367         uint256 amount
368     ) internal virtual {}
369 }
370 
371 interface IUniswapV2Factory {
372     event PairCreated(
373         address indexed token0,
374         address indexed token1,
375         address pair,
376         uint256
377     );
378 
379     function feeTo() external view returns (address);
380 
381     function feeToSetter() external view returns (address);
382 
383     function getPair(
384         address tokenA,
385         address tokenB
386     ) external view returns (address pair);
387 
388     function allPairs(uint256) external view returns (address pair);
389 
390     function allPairsLength() external view returns (uint256);
391 
392     function createPair(
393         address tokenA,
394         address tokenB
395     ) external returns (address pair);
396 
397     function setFeeTo(address) external;
398 
399     function setFeeToSetter(address) external;
400 }
401 
402 interface IUniswapV2Pair {
403     event Approval(
404         address indexed owner,
405         address indexed spender,
406         uint256 value
407     );
408     event Transfer(address indexed from, address indexed to, uint256 value);
409 
410     function name() external pure returns (string memory);
411 
412     function symbol() external pure returns (string memory);
413 
414     function decimals() external pure returns (uint8);
415 
416     function totalSupply() external view returns (uint256);
417 
418     function balanceOf(address owner) external view returns (uint256);
419 
420     function allowance(
421         address owner,
422         address spender
423     ) external view returns (uint256);
424 
425     function approve(address spender, uint256 value) external returns (bool);
426 
427     function transfer(address to, uint256 value) external returns (bool);
428 
429     function transferFrom(
430         address from,
431         address to,
432         uint256 value
433     ) external returns (bool);
434 
435     function DOMAIN_SEPARATOR() external view returns (bytes32);
436 
437     function PERMIT_TYPEHASH() external pure returns (bytes32);
438 
439     function nonces(address owner) external view returns (uint256);
440 
441     function permit(
442         address owner,
443         address spender,
444         uint256 value,
445         uint256 deadline,
446         uint8 v,
447         bytes32 r,
448         bytes32 s
449     ) external;
450 
451     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
452     event Burn(
453         address indexed sender,
454         uint256 amount0,
455         uint256 amount1,
456         address indexed to
457     );
458     event Swap(
459         address indexed sender,
460         uint256 amount0In,
461         uint256 amount1In,
462         uint256 amount0Out,
463         uint256 amount1Out,
464         address indexed to
465     );
466     event Sync(uint112 reserve0, uint112 reserve1);
467 
468     function MINIMUM_LIQUIDITY() external pure returns (uint256);
469 
470     function factory() external view returns (address);
471 
472     function token0() external view returns (address);
473 
474     function token1() external view returns (address);
475 
476     function getReserves()
477         external
478         view
479         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
480 
481     function price0CumulativeLast() external view returns (uint256);
482 
483     function price1CumulativeLast() external view returns (uint256);
484 
485     function kLast() external view returns (uint256);
486 
487     function mint(address to) external returns (uint256 liquidity);
488 
489     function burn(
490         address to
491     ) external returns (uint256 amount0, uint256 amount1);
492 
493     function swap(
494         uint256 amount0Out,
495         uint256 amount1Out,
496         address to,
497         bytes calldata data
498     ) external;
499 
500     function skim(address to) external;
501 
502     function sync() external;
503 
504     function initialize(address, address) external;
505 }
506 
507 interface IUniswapV2Router02 {
508     function factory() external pure returns (address);
509 
510     function WETH() external pure returns (address);
511 
512     function addLiquidity(
513         address tokenA,
514         address tokenB,
515         uint256 amountADesired,
516         uint256 amountBDesired,
517         uint256 amountAMin,
518         uint256 amountBMin,
519         address to,
520         uint256 deadline
521     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
522 
523     function addLiquidityETH(
524         address token,
525         uint256 amountTokenDesired,
526         uint256 amountTokenMin,
527         uint256 amountETHMin,
528         address to,
529         uint256 deadline
530     )
531         external
532         payable
533         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
534 
535     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
536         uint256 amountIn,
537         uint256 amountOutMin,
538         address[] calldata path,
539         address to,
540         uint256 deadline
541     ) external;
542 
543     function swapExactETHForTokensSupportingFeeOnTransferTokens(
544         uint256 amountOutMin,
545         address[] calldata path,
546         address to,
547         uint256 deadline
548     ) external payable;
549 
550     function swapExactTokensForETHSupportingFeeOnTransferTokens(
551         uint256 amountIn,
552         uint256 amountOutMin,
553         address[] calldata path,
554         address to,
555         uint256 deadline
556     ) external;
557 }
558 
559 //  Main Token Contract
560 contract Wapple is ERC20, Ownable {
561     IUniswapV2Router02 public immutable uniswapV2Router;
562     address public immutable uniswapV2Pair;
563     address public constant deadAddress = address(0xdead);
564 
565     bool private swapping;
566 
567     address public marketingWallet;
568     address public devWallet;
569 
570     uint256 public maxTransactionAmount;
571     uint256 public swapTokensAtAmount;
572     uint256 public maxWallet;
573 
574     bool public limitsInEffect = true;
575     bool public swapEnabled = false;
576     bool public tradingActive = false;
577 
578     uint256 public launchedAt;
579     uint256 public launchedAtTimestamp;
580 
581     uint256 public buyTotalFees = 25;
582     uint256 public buyMarketingFee = 25;
583     uint256 public buyDevFee = 0;
584 
585     uint256 public sellTotalFees = 50;
586     uint256 public sellMarketingFee = 50;
587     uint256 public sellDevFee = 0;
588 
589     uint256 tokensForMarketing;
590     uint256 tokenForDev;
591 
592     /******************/
593 
594     // exlcude from fees and max transaction amount
595     mapping(address => bool) private _isExcludedFromFees;
596     mapping(address => bool) public _isExcludedMaxTransactionAmount;
597     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
598     // could be subject to a maximum transfer amount
599     mapping(address => bool) public automatedMarketMakerPairs;
600 
601     event UpdateUniswapV2Router(
602         address indexed newAddress,
603         address indexed oldAddress
604     );
605 
606     event ExcludeFromFees(address indexed account, bool isExcluded);
607 
608     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
609 
610     event marketingWalletUpdated(
611         address indexed newWallet,
612         address indexed oldWallet
613     );
614 
615     event devWalletUpdated(
616         address indexed newWallet,
617         address indexed oldWallet
618     );
619     event SwapAndLiquify(
620         uint256 tokensSwapped,
621         uint256 ethReceived,
622         uint256 tokensIntoLiquidity
623     );
624 
625     constructor() ERC20("Wapple", "WAPPLE") {
626         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
627             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
628         );
629 
630         excludeFromMaxTransaction(address(_uniswapV2Router), true);
631         uniswapV2Router = _uniswapV2Router;
632 
633         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
634             .createPair(address(this), _uniswapV2Router.WETH());
635         excludeFromMaxTransaction(address(uniswapV2Pair), true);
636         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
637 
638         uint256 totalSupply = 1_000_000_000 * 1e18; // 1 billion
639 
640         maxTransactionAmount = 20_000_000 * 1e18; // 2%   of total supply is maxTransactionAmountTxn
641         maxWallet = 20_000_000 * 1e18; // 3 % of total supply is  maxWallet
642         swapTokensAtAmount = 1_000_000 * 1e18; //.1% at start
643 
644         marketingWallet = address(msg.sender); // set as marketing wallet
645         devWallet = address(msg.sender); // set as dev wallet
646         // exclude from paying fees or having max transaction amount
647         excludeFromFees(owner(), true);
648 
649         excludeFromFees(address(this), true);
650         excludeFromFees(address(0xdead), true);
651 
652         excludeFromMaxTransaction(owner(), true);
653         excludeFromMaxTransaction(address(this), true);
654         excludeFromMaxTransaction(address(0xdead), true);
655 
656         /*
657             _mint is an internal function in ERC20.sol that is only called here,
658             and CANNOT be called ever again
659         */
660         _mint(owner(), totalSupply);
661     }
662 
663     receive() external payable {}
664 
665     // remove limits after token is stable
666     function removeLimits() external onlyOwner returns (bool) {
667         limitsInEffect = false;
668         return true;
669     }
670 
671     function launched() internal view returns (bool) {
672         return launchedAt != 0;
673     }
674 
675     function launch() public onlyOwner {
676         require(launchedAt == 0, "Already launched boi");
677         launchedAt = block.number;
678         launchedAtTimestamp = block.timestamp;
679         tradingActive = true;
680         swapEnabled = true;
681     }
682 
683     // change the minimum amount of tokens to sell from fees
684     function updateSwapTokensAtAmount(
685         uint256 newAmount
686     ) external onlyOwner returns (bool) {
687         swapTokensAtAmount = newAmount * (10 ** 18);
688         return true;
689     }
690 
691     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
692         maxTransactionAmount = newNum * (10 ** 18);
693     }
694 
695     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
696         maxWallet = newNum * (10 ** 18);
697     }
698 
699     function excludeFromMaxTransaction(
700         address updAds,
701         bool isEx
702     ) public onlyOwner {
703         _isExcludedMaxTransactionAmount[updAds] = isEx;
704     }
705 
706     // only use to disable contract sales if absolutely necessary (emergency use only)
707     function updateSwapEnabled(bool enabled) external onlyOwner {
708         swapEnabled = enabled;
709     }
710 
711     function updateBuyFees(
712         uint256 _marketingFee,
713         uint256 _devFee
714     ) external onlyOwner {
715         buyMarketingFee = _marketingFee;
716         buyDevFee = _devFee;
717         buyTotalFees = buyMarketingFee + buyDevFee;
718     }
719 
720     function updateSellFees(
721         uint256 _marketingFee,
722         uint256 _devFee
723     ) external onlyOwner {
724         sellMarketingFee = _marketingFee;
725         sellDevFee = _devFee;
726         sellTotalFees = sellMarketingFee + sellDevFee;
727     }
728 
729     function excludeFromFees(address account, bool excluded) public onlyOwner {
730         _isExcludedFromFees[account] = excluded;
731         emit ExcludeFromFees(account, excluded);
732     }
733 
734     function setAutomatedMarketMakerPair(
735         address pair,
736         bool value
737     ) public onlyOwner {
738         require(
739             pair != uniswapV2Pair,
740             "The pair cannot be removed from automatedMarketMakerPairs"
741         );
742 
743         _setAutomatedMarketMakerPair(pair, value);
744     }
745 
746     function _setAutomatedMarketMakerPair(address pair, bool value) private {
747         automatedMarketMakerPairs[pair] = value;
748 
749         emit SetAutomatedMarketMakerPair(pair, value);
750     }
751 
752     function updateMarketingWallet(
753         address newMarketingWallet
754     ) external onlyOwner {
755         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
756         marketingWallet = newMarketingWallet;
757     }
758 
759     function updateDevWallet(address newWallet) external onlyOwner {
760         emit devWalletUpdated(newWallet, devWallet);
761         devWallet = newWallet;
762     }
763 
764     function isExcludedFromFees(address account) public view returns (bool) {
765         return _isExcludedFromFees[account];
766     }
767 
768     function _transfer(
769         address from,
770         address to,
771         uint256 amount
772     ) internal override {
773         require(from != address(0), "ERC20: transfer from the zero address");
774         require(to != address(0), "ERC20: transfer to the zero address");
775 
776         if (amount == 0) {
777             super._transfer(from, to, 0);
778             return;
779         }
780 
781         if (limitsInEffect) {
782             if (
783                 from != owner() &&
784                 to != owner() &&
785                 to != address(0) &&
786                 to != address(0xdead) &&
787                 !swapping
788             ) {
789                 if (!tradingActive) {
790                     require(
791                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
792                         "Trading is not active."
793                     );
794                 }
795                 //when buy
796                 if (
797                     automatedMarketMakerPairs[from] &&
798                     !_isExcludedMaxTransactionAmount[to]
799                 ) {
800                     require(
801                         amount <= maxTransactionAmount,
802                         "Buy transfer amount exceeds the maxTransactionAmount."
803                     );
804                     require(
805                         amount + balanceOf(to) <= maxWallet,
806                         "Max wallet exceeded"
807                     );
808                 }
809                 //when sell
810                 else if (
811                     automatedMarketMakerPairs[to] &&
812                     !_isExcludedMaxTransactionAmount[from]
813                 ) {
814                     require(
815                         amount <= maxTransactionAmount,
816                         "Sell transfer amount exceeds the maxTransactionAmount."
817                     );
818                 } else if (!_isExcludedMaxTransactionAmount[to]) {
819                     require(
820                         amount + balanceOf(to) <= maxWallet,
821                         "Max wallet exceeded"
822                     );
823                 }
824             }
825         }
826 
827         uint256 contractTokenBalance = balanceOf(address(this));
828 
829         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
830 
831         if (
832             canSwap &&
833             swapEnabled &&
834             !swapping &&
835             !automatedMarketMakerPairs[from] &&
836             !_isExcludedFromFees[from] &&
837             !_isExcludedFromFees[to]
838         ) {
839             swapping = true;
840 
841             swapBack();
842 
843             swapping = false;
844         }
845 
846         bool takeFee = !swapping;
847 
848         // if any account belongs to _isExcludedFromFee account then remove the fee
849         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
850             takeFee = false;
851         }
852 
853         uint256 fees = 0;
854         // only take fees on buys/sells, do not take on wallet transfers
855         if (takeFee) {
856             // on sell
857             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
858                 fees = (amount * sellTotalFees) / 100;
859                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
860                 tokenForDev += (fees * sellDevFee) / sellTotalFees;
861             }
862             // on buy
863             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
864                 fees = (amount * buyTotalFees) / 100;
865                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
866                 tokenForDev += (fees * buyDevFee) / buyTotalFees;
867             }
868 
869             if (fees > 0) {
870                 super._transfer(from, address(this), fees);
871             }
872 
873             amount -= fees;
874         }
875 
876         super._transfer(from, to, amount);
877     }
878 
879     function swapTokensForEth(uint256 tokenAmount) private {
880         // generate the uniswap pair path of token -> weth
881         address[] memory path = new address[](2);
882         path[0] = address(this);
883         path[1] = uniswapV2Router.WETH();
884 
885         _approve(address(this), address(uniswapV2Router), tokenAmount);
886 
887         // make the swap
888         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
889             tokenAmount,
890             0, // accept any amount of ETH
891             path,
892             address(this),
893             block.timestamp
894         );
895     }
896 
897     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
898         // approve token transfer to cover all possible scenarios
899         _approve(address(this), address(uniswapV2Router), tokenAmount);
900 
901         // add the liquidity
902         uniswapV2Router.addLiquidityETH{value: ethAmount}(
903             address(this),
904             tokenAmount,
905             0, // slippage is unavoidable
906             0, // slippage is unavoidable
907             deadAddress,
908             block.timestamp
909         );
910     }
911 
912     function swapBack() private {
913         uint256 contractBalance = balanceOf(address(this));
914         uint256 totalTokensToSwap = tokensForMarketing + tokenForDev;
915         bool success;
916 
917         if (contractBalance > swapTokensAtAmount) {
918             contractBalance = swapTokensAtAmount;
919         }
920 
921         uint256 amountToSwapForETH = contractBalance;
922 
923         swapTokensForEth(amountToSwapForETH);
924 
925         uint256 ethBalance = (address(this).balance);
926         uint256 ethForDev = (ethBalance * tokenForDev) / totalTokensToSwap;
927 
928         tokensForMarketing = 0;
929         tokenForDev = 0;
930 
931         (success, ) = address(devWallet).call{value: ethForDev}("");
932         (success, ) = address(marketingWallet).call{
933             value: address(this).balance
934         }("");
935     }
936 
937     function withdrawETH(uint256 _amount) external onlyOwner {
938         require(address(this).balance >= _amount, "Invalid Amount");
939         payable(msg.sender).transfer(_amount);
940     }
941 
942     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
943         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
944         _token.transfer(msg.sender, _amount);
945     }
946 }