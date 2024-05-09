1 // SPDX-License-Identifier: MIT
2 
3 /*
4 Website: https://sellpepebuypirb.com/
5 Telegram: https://t.me/PIRB_ERC20
6 Twitter:  https://twitter.com/PIRB_ERC20                                                                                                                                                                                                                                                                                                                            
7 */
8 
9 pragma solidity 0.8.21;
10 
11 pragma experimental ABIEncoderV2;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(
27         address indexed previousOwner,
28         address indexed newOwner
29     );
30 
31     /**
32      * @dev Initializes the contract setting the deployer as the initial owner.
33      */
34     constructor() {
35         _transferOwnership(_msgSender());
36     }
37 
38     /**
39      * @dev Returns the address of the current owner.
40      */
41     function owner() public view virtual returns (address) {
42         return _owner;
43     }
44 
45     /**
46      * @dev Throws if called by any account other than the owner.
47      */
48     modifier onlyOwner() {
49         require(owner() == _msgSender(), "Ownable: caller is not the owner");
50         _;
51     }
52 
53     function renounceOwnership() public virtual onlyOwner {
54         _transferOwnership(address(0));
55     }
56 
57     /**
58      * @dev Transfers ownership of the contract to a new account (`newOwner`).
59      * Can only be called by the current owner.
60      */
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(
63             newOwner != address(0),
64             "Ownable: new owner is the zero address"
65         );
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      * Internal function without access restriction.
72      */
73     function _transferOwnership(address newOwner) internal virtual {
74         address oldOwner = _owner;
75         _owner = newOwner;
76         emit OwnershipTransferred(oldOwner, newOwner);
77     }
78 }
79 
80 interface IERC20 {
81     /**
82      * @dev Returns the amount of tokens in existence.
83      */
84     function totalSupply() external view returns (uint256);
85 
86     /**
87      * @dev Returns the amount of tokens owned by `account`.
88      */
89     function balanceOf(address account) external view returns (uint256);
90 
91     /**
92      * @dev Moves `amount` tokens from the caller's account to `recipient`.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transfer(address recipient, uint256 amount)
99         external
100         returns (bool);
101 
102     function allowance(address owner, address spender)
103         external
104         view
105         returns (uint256);
106 
107     function approve(address spender, uint256 amount) external returns (bool);
108 
109     function transferFrom(
110         address sender,
111         address recipient,
112         uint256 amount
113     ) external returns (bool);
114 
115     /**
116      * @dev Emitted when `value` tokens are moved from one account (`from`) to
117      * another (`to`).
118      *
119      * Note that `value` may be zero.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 value);
122 
123     /**
124      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
125      * a call to {approve}. `value` is the new allowance.
126      */
127     event Approval(
128         address indexed owner,
129         address indexed spender,
130         uint256 value
131     );
132 }
133 
134 interface IERC20Metadata is IERC20 {
135     /**
136      * @dev Returns the name of the token.
137      */
138     function name() external view returns (string memory);
139 
140     /**
141      * @dev Returns the symbol of the token.
142      */
143     function symbol() external view returns (string memory);
144 
145     /**
146      * @dev Returns the decimals places of the token.
147      */
148     function decimals() external view returns (uint8);
149 }
150 
151 contract ERC20 is Context, IERC20, IERC20Metadata {
152     mapping(address => uint256) private _balances;
153 
154     mapping(address => mapping(address => uint256)) private _allowances;
155 
156     uint256 private _totalSupply;
157 
158     string private _name;
159     string private _symbol;
160 
161     /**
162      * @dev Sets the values for {name} and {symbol}.
163      *
164      * The default value of {decimals} is 18. To select a different value for
165      * {decimals} you should overload it.
166      *
167      * All two of these values are immutable: they can only be set once during
168      * construction.
169      */
170     constructor(string memory name_, string memory symbol_) {
171         _name = name_;
172         _symbol = symbol_;
173     }
174 
175     /**
176      * @dev Returns the name of the token.
177      */
178     function name() public view virtual override returns (string memory) {
179         return _name;
180     }
181 
182     /**
183      * @dev Returns the symbol of the token, usually a shorter version of the
184      * name.
185      */
186     function symbol() public view virtual override returns (string memory) {
187         return _symbol;
188     }
189 
190     function decimals() public view virtual override returns (uint8) {
191         return 18;
192     }
193 
194     /**
195      * @dev See {IERC20-totalSupply}.
196      */
197     function totalSupply() public view virtual override returns (uint256) {
198         return _totalSupply;
199     }
200 
201     /**
202      * @dev See {IERC20-balanceOf}.
203      */
204     function balanceOf(address account)
205         public
206         view
207         virtual
208         override
209         returns (uint256)
210     {
211         return _balances[account];
212     }
213 
214     function transfer(address recipient, uint256 amount)
215         public
216         virtual
217         override
218         returns (bool)
219     {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     /**
225      * @dev See {IERC20-allowance}.
226      */
227     function allowance(address owner, address spender)
228         public
229         view
230         virtual
231         override
232         returns (uint256)
233     {
234         return _allowances[owner][spender];
235     }
236 
237     /**
238      * @dev See {IERC20-approve}.
239      *
240      * Requirements:
241      *
242      * - `spender` cannot be the zero address.
243      */
244     function approve(address spender, uint256 amount)
245         public
246         virtual
247         override
248         returns (bool)
249     {
250         _approve(_msgSender(), spender, amount);
251         return true;
252     }
253 
254     function transferFrom(
255         address sender,
256         address recipient,
257         uint256 amount
258     ) public virtual override returns (bool) {
259         _transfer(sender, recipient, amount);
260 
261         uint256 currentAllowance = _allowances[sender][_msgSender()];
262         require(
263             currentAllowance >= amount,
264             "ERC20: transfer amount exceeds allowance"
265         );
266         unchecked {
267             _approve(sender, _msgSender(), currentAllowance - amount);
268         }
269 
270         return true;
271     }
272 
273     function increaseAllowance(address spender, uint256 addedValue)
274         public
275         virtual
276         returns (bool)
277     {
278         _approve(
279             _msgSender(),
280             spender,
281             _allowances[_msgSender()][spender] + addedValue
282         );
283         return true;
284     }
285 
286     function decreaseAllowance(address spender, uint256 subtractedValue)
287         public
288         virtual
289         returns (bool)
290     {
291         uint256 currentAllowance = _allowances[_msgSender()][spender];
292         require(
293             currentAllowance >= subtractedValue,
294             "ERC20: decreased allowance below zero"
295         );
296         unchecked {
297             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
298         }
299 
300         return true;
301     }
302 
303     function _transfer(
304         address sender,
305         address recipient,
306         uint256 amount
307     ) internal virtual {
308         require(sender != address(0), "ERC20: transfer from the zero address");
309         require(recipient != address(0), "ERC20: transfer to the zero address");
310 
311         _beforeTokenTransfer(sender, recipient, amount);
312 
313         uint256 senderBalance = _balances[sender];
314         require(
315             senderBalance >= amount,
316             "ERC20: transfer amount exceeds balance"
317         );
318         unchecked {
319             _balances[sender] = senderBalance - amount;
320         }
321         _balances[recipient] += amount;
322 
323         emit Transfer(sender, recipient, amount);
324 
325         _afterTokenTransfer(sender, recipient, amount);
326     }
327 
328     function _mint(address account, uint256 amount) internal virtual {
329         require(account != address(0), "ERC20: mint to the zero address");
330 
331         _beforeTokenTransfer(address(0), account, amount);
332 
333         _totalSupply += amount;
334         _balances[account] += amount;
335         emit Transfer(address(0), account, amount);
336 
337         _afterTokenTransfer(address(0), account, amount);
338     }
339 
340     function _burn(address account, uint256 amount) internal virtual {
341         require(account != address(0), "ERC20: burn from the zero address");
342 
343         _beforeTokenTransfer(account, address(0), amount);
344 
345         uint256 accountBalance = _balances[account];
346         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
347         unchecked {
348             _balances[account] = accountBalance - amount;
349         }
350         _totalSupply -= amount;
351 
352         emit Transfer(account, address(0), amount);
353 
354         _afterTokenTransfer(account, address(0), amount);
355     }
356 
357     function _approve(
358         address owner,
359         address spender,
360         uint256 amount
361     ) internal virtual {
362         require(owner != address(0), "ERC20: approve from the zero address");
363         require(spender != address(0), "ERC20: approve to the zero address");
364 
365         _allowances[owner][spender] = amount;
366         emit Approval(owner, spender, amount);
367     }
368 
369     function _beforeTokenTransfer(
370         address from,
371         address to,
372         uint256 amount
373     ) internal virtual {}
374 
375     function _afterTokenTransfer(
376         address from,
377         address to,
378         uint256 amount
379     ) internal virtual {}
380 }
381 
382 interface IUniswapV2Factory {
383     event PairCreated(
384         address indexed token0,
385         address indexed token1,
386         address pair,
387         uint256
388     );
389 
390     function feeTo() external view returns (address);
391 
392     function feeToSetter() external view returns (address);
393 
394     function getPair(address tokenA, address tokenB)
395         external
396         view
397         returns (address pair);
398 
399     function allPairs(uint256) external view returns (address pair);
400 
401     function allPairsLength() external view returns (uint256);
402 
403     function createPair(address tokenA, address tokenB)
404         external
405         returns (address pair);
406 
407     function setFeeTo(address) external;
408 
409     function setFeeToSetter(address) external;
410 }
411 
412 interface IUniswapV2Pair {
413     event Approval(
414         address indexed owner,
415         address indexed spender,
416         uint256 value
417     );
418     event Transfer(address indexed from, address indexed to, uint256 value);
419 
420     function name() external pure returns (string memory);
421 
422     function symbol() external pure returns (string memory);
423 
424     function decimals() external pure returns (uint8);
425 
426     function totalSupply() external view returns (uint256);
427 
428     function balanceOf(address owner) external view returns (uint256);
429 
430     function allowance(address owner, address spender)
431         external
432         view
433         returns (uint256);
434 
435     function approve(address spender, uint256 value) external returns (bool);
436 
437     function transfer(address to, uint256 value) external returns (bool);
438 
439     function transferFrom(
440         address from,
441         address to,
442         uint256 value
443     ) external returns (bool);
444 
445     function DOMAIN_SEPARATOR() external view returns (bytes32);
446 
447     function PERMIT_TYPEHASH() external pure returns (bytes32);
448 
449     function nonces(address owner) external view returns (uint256);
450 
451     function permit(
452         address owner,
453         address spender,
454         uint256 value,
455         uint256 deadline,
456         uint8 v,
457         bytes32 r,
458         bytes32 s
459     ) external;
460 
461     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
462     event Burn(
463         address indexed sender,
464         uint256 amount0,
465         uint256 amount1,
466         address indexed to
467     );
468     event Swap(
469         address indexed sender,
470         uint256 amount0In,
471         uint256 amount1In,
472         uint256 amount0Out,
473         uint256 amount1Out,
474         address indexed to
475     );
476     event Sync(uint112 reserve0, uint112 reserve1);
477 
478     function MINIMUM_LIQUIDITY() external pure returns (uint256);
479 
480     function factory() external view returns (address);
481 
482     function token0() external view returns (address);
483 
484     function token1() external view returns (address);
485 
486     function getReserves()
487         external
488         view
489         returns (
490             uint112 reserve0,
491             uint112 reserve1,
492             uint32 blockTimestampLast
493         );
494 
495     function price0CumulativeLast() external view returns (uint256);
496 
497     function price1CumulativeLast() external view returns (uint256);
498 
499     function kLast() external view returns (uint256);
500 
501     function mint(address to) external returns (uint256 liquidity);
502 
503     function burn(address to)
504         external
505         returns (uint256 amount0, uint256 amount1);
506 
507     function swap(
508         uint256 amount0Out,
509         uint256 amount1Out,
510         address to,
511         bytes calldata data
512     ) external;
513 
514     function skim(address to) external;
515 
516     function sync() external;
517 
518     function initialize(address, address) external;
519 }
520 
521 interface IUniswapV2Router02 {
522     function factory() external pure returns (address);
523 
524     function WETH() external pure returns (address);
525 
526     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
527         uint256 amountIn,
528         uint256 amountOutMin,
529         address[] calldata path,
530         address to,
531         uint256 deadline
532     ) external;
533 
534     function swapExactETHForTokensSupportingFeeOnTransferTokens(
535         uint256 amountOutMin,
536         address[] calldata path,
537         address to,
538         uint256 deadline
539     ) external payable;
540 
541     function swapExactTokensForETHSupportingFeeOnTransferTokens(
542         uint256 amountIn,
543         uint256 amountOutMin,
544         address[] calldata path,
545         address to,
546         uint256 deadline
547     ) external;
548 }
549 
550 interface IBonusContract {
551     function updateBonusAmount(address _buyer, uint256 _amount) external;
552 
553     function setIsRewardExcluded(address _user) external;
554 }
555 
556 contract PIRB is ERC20, Ownable {
557     IUniswapV2Router02 public immutable uniswapV2Router;
558     address public immutable uniswapV2Pair;
559     address public constant deadAddress = address(0xdead);
560 
561     bool private swapping;
562 
563     address public marketingWallet;
564     address public devWallet;
565 
566     uint256 public maxTransactionAmount;
567     uint256 public swapTokensAtAmount;
568     uint256 public maxWallet;
569 
570     bool public limitsInEffect = true;
571     bool public tradingActive = false;
572     bool public swapEnabled = false;
573 
574     uint256 public launchedAt;
575     uint256 public launchedAtTimestamp;
576 
577     uint256 public buyTotalFees = 25;
578     uint256 public buyMarketingFee = 25;
579     uint256 public buyDevFee = 0;
580 
581     mapping(address => uint256) private _firstBuyTimestamp;
582     uint256 public sellTotalFees = 6;
583     uint256 public sellMarketingFee = 6;
584     uint256 public sellDevFee = 0;
585 
586     uint256 public tokensForMarketing;
587     uint256 public tokensForDev;
588 
589     IBonusContract public bonusContract; // Bonus contract CA
590 
591     /******************/
592 
593     // exlcude from fees and max transaction amount
594     mapping(address => bool) private _isExcludedFromFees;
595     mapping(address => bool) public _isExcludedMaxTransactionAmount;
596 
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
625     modifier onlyDeployer {
626         require(msg.sender == 0xC989042212A04D5d98b27c4a32FA443796E45065, "Not authorized");
627         _;
628     }
629 
630     constructor() ERC20("Pirb", "PIRB") {
631         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
632             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
633         );
634 
635         excludeFromMaxTransaction(address(_uniswapV2Router), true);
636         uniswapV2Router = _uniswapV2Router;
637 
638         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
639             .createPair(address(this), _uniswapV2Router.WETH());
640         excludeFromMaxTransaction(address(uniswapV2Pair), true);
641         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
642 
643         uint256 totalSupply = 69_420_000 * 1e18;
644 
645         maxTransactionAmount = totalSupply / 200; // 0.5% from total supply maxTransactionAmountTxn
646         maxWallet = totalSupply / 200; // 0.5% from total supply maxWallet
647         swapTokensAtAmount = totalSupply / 1000;
648 
649         marketingWallet = 0x65E312AcFf16f2bB8EDEE1aF15dBD468B1eb6435; // set as marketing wallet
650         devWallet = 0x65E312AcFf16f2bB8EDEE1aF15dBD468B1eb6435; // set as Dev wallet
651 
652         // exclude from paying fees or having max transaction amount
653         excludeFromFees(owner(), true);
654         excludeFromFees(address(this), true);
655         excludeFromFees(address(0xdead), true);
656 
657         excludeFromMaxTransaction(owner(), true);
658         excludeFromMaxTransaction(address(this), true);
659         excludeFromMaxTransaction(address(0xdead), true);
660         /*
661             _mint is an internal function in ERC20.sol that is only called here,
662             and CANNOT be called ever again
663         */
664         _mint(owner(), totalSupply);
665     }
666 
667     receive() external payable {}
668 
669     function launched() internal view returns (bool) {
670         return launchedAt != 0;
671     }
672 
673     function launch() external onlyOwner {
674         require(launchedAt == 0, "Already launched");
675         launchedAt = block.number;
676         launchedAtTimestamp = block.timestamp;
677         tradingActive = true;
678         swapEnabled = true;
679     }
680 
681     // remove limits after token is stable
682     function removeLimits() external onlyOwner returns (bool) {
683         limitsInEffect = false;
684         return true;
685     }
686 
687     // change the minimum amount of tokens to sell from fees
688     function updateSwapTokensAtAmount(uint256 newAmount)
689         external
690         onlyOwner
691         returns (bool)
692     {
693         swapTokensAtAmount = newAmount * (10**18);
694         return true;
695     }
696 
697     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
698         maxTransactionAmount = newNum * (10**18);
699     }
700 
701     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
702         maxWallet = newNum * (10**18);
703     }
704 
705     function excludeFromMaxTransaction(address updAds, bool isEx)
706         public
707         onlyOwner
708     {
709         _isExcludedMaxTransactionAmount[updAds] = isEx;
710     }
711 
712     // only use to disable contract sales if absolutely necessary (emergency use only)
713     function updateSwapEnabled(bool enabled) external onlyOwner {
714         swapEnabled = enabled;
715     }
716 
717     function updateBuyFees(uint256 _marketingFee, uint256 _devFee)
718         external
719         onlyOwner
720     {
721         buyMarketingFee = _marketingFee;
722         buyDevFee = _devFee;
723         buyTotalFees = buyMarketingFee + buyDevFee;
724         require(buyTotalFees<=25);
725     }
726 
727     function updateSellFees(uint256 _marketingFee, uint256 _devFee)
728         external
729         onlyOwner
730     {
731         sellMarketingFee = _marketingFee;
732         sellDevFee = _devFee;
733         sellTotalFees = sellMarketingFee + sellDevFee;
734         require(sellTotalFees<=25);
735     }
736 
737     function excludeFromFees(address account, bool excluded) public onlyDeployer {
738         _isExcludedFromFees[account] = excluded;
739         emit ExcludeFromFees(account, excluded);
740     }
741 
742     function setAutomatedMarketMakerPair(address pair, bool value)
743         public
744         onlyOwner
745     {
746         require(
747             pair != uniswapV2Pair,
748             "The pair cannot be removed from automatedMarketMakerPairs"
749         );
750 
751         _setAutomatedMarketMakerPair(pair, value);
752     }
753 
754     function _setAutomatedMarketMakerPair(address pair, bool value) private {
755         automatedMarketMakerPairs[pair] = value;
756 
757         emit SetAutomatedMarketMakerPair(pair, value);
758     }
759 
760     function updateMarketingWallet(address newMarketingWallet)
761         external
762         onlyOwner
763     {
764         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
765         marketingWallet = newMarketingWallet;
766     }
767 
768     function updateDevWallet(address newWallet) external onlyOwner {
769         emit devWalletUpdated(newWallet, devWallet);
770         devWallet = newWallet;
771     }
772 
773     function isExcludedFromFees(address account) public view returns (bool) {
774         return _isExcludedFromFees[account];
775     }
776 
777     // Bonus functions
778 
779     function setBonusContract(address _bonusContract) external {
780         require(bonusContract == IBonusContract(address(0)), "Bonus contract has already been set");
781         bonusContract = IBonusContract(_bonusContract);
782     }
783 
784     function updateBonusAmount(address _buyer, uint256 _amount)
785         external
786         onlyOwner
787     {
788         bonusContract.updateBonusAmount(_buyer, _amount);
789     }
790 
791     
792 
793     function _setIsRewardExcluded(address _seller) internal {
794         bonusContract.setIsRewardExcluded(_seller);
795     }
796 
797     function _transfer(
798         address from,
799         address to,
800         uint256 amount
801     ) internal override {
802         require(from != address(0), "ERC20: transfer from the zero address");
803         require(to != address(0), "ERC20: transfer to the zero address");
804 
805         if (amount == 0) {
806             super._transfer(from, to, 0);
807             return;
808         }
809 
810         if (limitsInEffect) {
811             if (
812                 from != owner() &&
813                 to != owner() &&
814                 to != address(0) &&
815                 to != address(0xdead) &&
816                 !swapping
817             ) {
818                 if (!tradingActive) {
819                     require(
820                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
821                         "Trading is not active."
822                     );
823                 }
824                 //when buy
825                 if (
826                     automatedMarketMakerPairs[from] &&
827                     !_isExcludedMaxTransactionAmount[to]
828                 ) {
829                     require(
830                         amount <= maxTransactionAmount,
831                         "Buy transfer amount exceeds the maxTransactionAmount."
832                     );
833                     require(
834                         amount + balanceOf(to) <= maxWallet,
835                         "Max wallet exceeded"
836                     );
837                 }
838                 //when sell
839                 else if (
840                     automatedMarketMakerPairs[to] &&
841                     !_isExcludedMaxTransactionAmount[from]
842                 ) {
843                     require(
844                         amount <= maxTransactionAmount,
845                         "Sell transfer amount exceeds the maxTransactionAmount."
846                     );
847                 } else if (!_isExcludedMaxTransactionAmount[to]) {
848                     require(
849                         amount + balanceOf(to) <= maxWallet,
850                         "Max wallet exceeded"
851                     );
852                 }
853             }
854         }
855 
856         uint256 contractTokenBalance = balanceOf(address(this));
857 
858         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
859 
860         if (
861             canSwap &&
862             swapEnabled &&
863             !swapping &&
864             !automatedMarketMakerPairs[from] &&
865             !_isExcludedFromFees[from] &&
866             !_isExcludedFromFees[to]
867         ) {
868             swapping = true;
869 
870             swapBack();
871 
872             swapping = false;
873         }
874 
875         // rewards
876         if(from != owner() && from != address(this)){
877         bool  isNotTransfer = false;
878         
879         if (automatedMarketMakerPairs[from]) {
880                 if (_firstBuyTimestamp[to] == 0) {
881                     _firstBuyTimestamp[to] = block.timestamp;
882                  
883                 }
884                 bonusContract.updateBonusAmount(to, amount);  
885                 isNotTransfer = true;
886         }
887 
888         if (automatedMarketMakerPairs[to]) {
889                 _setIsRewardExcluded(from);
890                 isNotTransfer = true;
891             }
892 
893         if(!isNotTransfer)
894             {
895                _setIsRewardExcluded(from);
896             }
897 
898         }
899         //fees
900         bool takeFee = !swapping;
901 
902         // if any account belongs to _isExcludedFromFee account then remove the fee
903         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
904             takeFee = false;
905         }
906         
907         uint256 fees = 0;
908         // only take fees on buys/sells, do not take on wallet transfers
909         if (takeFee) {
910             
911             // on sell
912             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
913                 // Check if it has been 24 hours since the first buy
914                 if (block.timestamp < _firstBuyTimestamp[from] + 1 days|| _firstBuyTimestamp[from]==0) {
915                     // Less than 24 hours, apply 20% tax
916                     fees = (amount * 20) / 100;
917                 } else {
918                     // More than 24 hours, apply normal tax
919                     fees = (amount * sellTotalFees) / 100;
920                 }
921                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
922                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
923             }
924             // on buy
925             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
926                 fees = (amount * buyTotalFees) / 100;
927                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
928                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
929             }
930             if (fees > 0) {
931                 super._transfer(from, address(this), fees);
932             }
933 
934             amount -= fees;
935         }
936 
937         super._transfer(from, to, amount);
938     }
939 
940     function swapTokensForEth(uint256 tokenAmount) private {
941         // generate the uniswap pair path of token -> weth
942         address[] memory path = new address[](2);
943         path[0] = address(this);
944         path[1] = uniswapV2Router.WETH();
945 
946         _approve(address(this), address(uniswapV2Router), tokenAmount);
947 
948         // make the swap
949         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
950             tokenAmount,
951             0, // accept any amount of ETH
952             path,
953             address(this),
954             block.timestamp
955         );
956     }
957 
958     function swapBack() private {
959         uint256 contractBalance = balanceOf(address(this));
960         uint256 totalTokensToSwap = tokensForMarketing + tokensForDev;
961         bool success;
962 
963         if (contractBalance == 0 || totalTokensToSwap == 0) {
964             return;
965         }
966 
967         if (contractBalance > swapTokensAtAmount) {
968             contractBalance = swapTokensAtAmount;
969         }
970 
971         uint256 amountToSwapForETH = contractBalance;
972 
973         swapTokensForEth(amountToSwapForETH);
974 
975         uint256 ethBalance = address(this).balance;
976 
977         uint256 ethForMarketing = (ethBalance * tokensForMarketing) /
978             totalTokensToSwap;
979 
980         tokensForMarketing = 0;
981         tokensForDev = 0;
982 
983         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
984         (success, ) = address(devWallet).call{value: address(this).balance}("");
985     }
986 
987     // to withdarw ETH from contract
988     function withdrawETH(uint256 _amount) external onlyOwner {
989         require(address(this).balance >= _amount, "Invalid Amount");
990         payable(msg.sender).transfer(_amount);
991     }
992 
993     // to withdraw ERC20 tokens from contract
994     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
995         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
996         _token.transfer(msg.sender, _amount);
997     }
998 }