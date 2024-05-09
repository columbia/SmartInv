1 // SPDX-License-Identifier: MIT
2 /**
3 
4 
5 
6 
7 Telegram: https://t.me/BOB2_Portal
8 
9 
10 **/
11 pragma solidity 0.8.19;
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address account) external view returns (uint256);
17 
18     function transfer(address recipient, uint256 amount)
19         external
20         returns (bool);
21 
22     function allowance(address owner, address spender)
23         external
24         view
25         returns (uint256);
26 
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(
37         address indexed owner,
38         address indexed spender,
39         uint256 value
40     );
41 }
42 
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view virtual returns (bytes calldata) {
49         this;
50         return msg.data;
51     }
52 }
53 
54 abstract contract Ownable is Context {
55     address private _owner;
56     event OwnershipTransferred(
57         address indexed previousOwner,
58         address indexed newOwner
59     );
60 
61     constructor() {
62         _owner = address(_msgSender());
63         emit OwnershipTransferred(address(0), _owner);
64     }
65 
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(
82             newOwner != address(0),
83             "Ownable: new owner is the zero address"
84         );
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 interface IUniswapV2Factory {
91     event PairCreated(
92         address indexed token0,
93         address indexed token1,
94         address pair,
95         uint256
96     );
97 
98     function feeTo() external view returns (address);
99 
100     function feeToSetter() external view returns (address);
101 
102     function getPair(address tokenA, address tokenB)
103         external
104         view
105         returns (address pair);
106 
107     function allPairs(uint256) external view returns (address pair);
108 
109     function allPairsLength() external view returns (uint256);
110 
111     function createPair(address tokenA, address tokenB)
112         external
113         returns (address pair);
114 
115     function setFeeTo(address) external;
116 
117     function setFeeToSetter(address) external;
118 }
119 
120 interface IUniswapV2Pair {
121     event Approval(
122         address indexed owner,
123         address indexed spender,
124         uint256 value
125     );
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 
128     function name() external pure returns (string memory);
129 
130     function symbol() external pure returns (string memory);
131 
132     function decimals() external pure returns (uint8);
133 
134     function totalSupply() external view returns (uint256);
135 
136     function balanceOf(address owner) external view returns (uint256);
137 
138     function allowance(address owner, address spender)
139         external
140         view
141         returns (uint256);
142 
143     function approve(address spender, uint256 value) external returns (bool);
144 
145     function transfer(address to, uint256 value) external returns (bool);
146 
147     function transferFrom(
148         address from,
149         address to,
150         uint256 value
151     ) external returns (bool);
152 
153     function DOMAIN_SEPARATOR() external view returns (bytes32);
154 
155     function PERMIT_TYPEHASH() external pure returns (bytes32);
156 
157     function nonces(address owner) external view returns (uint256);
158 
159     function permit(
160         address owner,
161         address spender,
162         uint256 value,
163         uint256 deadline,
164         uint8 v,
165         bytes32 r,
166         bytes32 s
167     ) external;
168 
169     event Burn(
170         address indexed sender,
171         uint256 amount0,
172         uint256 amount1,
173         address indexed to
174     );
175     event Swap(
176         address indexed sender,
177         uint256 amount0In,
178         uint256 amount1In,
179         uint256 amount0Out,
180         uint256 amount1Out,
181         address indexed to
182     );
183     event Sync(uint112 reserve0, uint112 reserve1);
184 
185     function MINIMUM_LIQUIDITY() external pure returns (uint256);
186 
187     function factory() external view returns (address);
188 
189     function token0() external view returns (address);
190 
191     function token1() external view returns (address);
192 
193     function getReserves()
194         external
195         view
196         returns (
197             uint112 reserve0,
198             uint112 reserve1,
199             uint32 blockTimestampLast
200         );
201 
202     function price0CumulativeLast() external view returns (uint256);
203 
204     function price1CumulativeLast() external view returns (uint256);
205 
206     function kLast() external view returns (uint256);
207 
208     function burn(address to)
209         external
210         returns (uint256 amount0, uint256 amount1);
211 
212     function swap(
213         uint256 amount0Out,
214         uint256 amount1Out,
215         address to,
216         bytes calldata data
217     ) external;
218 
219     function skim(address to) external;
220 
221     function sync() external;
222 
223     function initialize(address, address) external;
224 }
225 
226 interface IUniswapV2Router01 {
227     function factory() external pure returns (address);
228 
229     function WETH() external pure returns (address);
230 
231     function addLiquidity(
232         address tokenA,
233         address tokenB,
234         uint256 amountADesired,
235         uint256 amountBDesired,
236         uint256 amountAMin,
237         uint256 amountBMin,
238         address to,
239         uint256 deadline
240     )
241         external
242         returns (
243             uint256 amountA,
244             uint256 amountB,
245             uint256 liquidity
246         );
247 
248     function addLiquidityETH(
249         address token,
250         uint256 amountTokenDesired,
251         uint256 amountTokenMin,
252         uint256 amountETHMin,
253         address to,
254         uint256 deadline
255     )
256         external
257         payable
258         returns (
259             uint256 amountToken,
260             uint256 amountETH,
261             uint256 liquidity
262         );
263 
264     function removeLiquidity(
265         address tokenA,
266         address tokenB,
267         uint256 liquidity,
268         uint256 amountAMin,
269         uint256 amountBMin,
270         address to,
271         uint256 deadline
272     ) external returns (uint256 amountA, uint256 amountB);
273 
274     function removeLiquidityETH(
275         address token,
276         uint256 liquidity,
277         uint256 amountTokenMin,
278         uint256 amountETHMin,
279         address to,
280         uint256 deadline
281     ) external returns (uint256 amountToken, uint256 amountETH);
282 
283     function removeLiquidityWithPermit(
284         address tokenA,
285         address tokenB,
286         uint256 liquidity,
287         uint256 amountAMin,
288         uint256 amountBMin,
289         address to,
290         uint256 deadline,
291         bool approveMax,
292         uint8 v,
293         bytes32 r,
294         bytes32 s
295     ) external returns (uint256 amountA, uint256 amountB);
296 
297     function removeLiquidityETHWithPermit(
298         address token,
299         uint256 liquidity,
300         uint256 amountTokenMin,
301         uint256 amountETHMin,
302         address to,
303         uint256 deadline,
304         bool approveMax,
305         uint8 v,
306         bytes32 r,
307         bytes32 s
308     ) external returns (uint256 amountToken, uint256 amountETH);
309 
310     function swapExactTokensForTokens(
311         uint256 amountIn,
312         uint256 amountOutMin,
313         address[] calldata path,
314         address to,
315         uint256 deadline
316     ) external returns (uint256[] memory amounts);
317 
318     function swapTokensForExactTokens(
319         uint256 amountOut,
320         uint256 amountInMax,
321         address[] calldata path,
322         address to,
323         uint256 deadline
324     ) external returns (uint256[] memory amounts);
325 
326     function swapExactETHForTokens(
327         uint256 amountOutMin,
328         address[] calldata path,
329         address to,
330         uint256 deadline
331     ) external payable returns (uint256[] memory amounts);
332 
333     function swapTokensForExactETH(
334         uint256 amountOut,
335         uint256 amountInMax,
336         address[] calldata path,
337         address to,
338         uint256 deadline
339     ) external returns (uint256[] memory amounts);
340 
341     function swapExactTokensForETH(
342         uint256 amountIn,
343         uint256 amountOutMin,
344         address[] calldata path,
345         address to,
346         uint256 deadline
347     ) external returns (uint256[] memory amounts);
348 
349     function swapETHForExactTokens(
350         uint256 amountOut,
351         address[] calldata path,
352         address to,
353         uint256 deadline
354     ) external payable returns (uint256[] memory amounts);
355 
356     function quote(
357         uint256 amountA,
358         uint256 reserveA,
359         uint256 reserveB
360     ) external pure returns (uint256 amountB);
361 
362     function getAmountOut(
363         uint256 amountIn,
364         uint256 reserveIn,
365         uint256 reserveOut
366     ) external pure returns (uint256 amountOut);
367 
368     function getAmountIn(
369         uint256 amountOut,
370         uint256 reserveIn,
371         uint256 reserveOut
372     ) external pure returns (uint256 amountIn);
373 
374     function getAmountsOut(uint256 amountIn, address[] calldata path)
375         external
376         view
377         returns (uint256[] memory amounts);
378 
379     function getAmountsIn(uint256 amountOut, address[] calldata path)
380         external
381         view
382         returns (uint256[] memory amounts);
383 }
384 
385 interface IUniswapV2Router02 is IUniswapV2Router01 {
386     function removeLiquidityETHSupportingFeeOnTransferTokens(
387         address token,
388         uint256 liquidity,
389         uint256 amountTokenMin,
390         uint256 amountETHMin,
391         address to,
392         uint256 deadline
393     ) external returns (uint256 amountETH);
394 
395     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
396         address token,
397         uint256 liquidity,
398         uint256 amountTokenMin,
399         uint256 amountETHMin,
400         address to,
401         uint256 deadline,
402         bool approveMax,
403         uint8 v,
404         bytes32 r,
405         bytes32 s
406     ) external returns (uint256 amountETH);
407 
408     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
409         uint256 amountIn,
410         uint256 amountOutMin,
411         address[] calldata path,
412         address to,
413         uint256 deadline
414     ) external;
415 
416     function swapExactETHForTokensSupportingFeeOnTransferTokens(
417         uint256 amountOutMin,
418         address[] calldata path,
419         address to,
420         uint256 deadline
421     ) external payable;
422 
423     function swapExactTokensForETHSupportingFeeOnTransferTokens(
424         uint256 amountIn,
425         uint256 amountOutMin,
426         address[] calldata path,
427         address to,
428         uint256 deadline
429     ) external;
430 }
431 
432 contract BOB2 is Ownable, IERC20 {
433     mapping(address => uint256) private _balances;
434     mapping(address => mapping(address => uint256)) private _allowances;
435     mapping(address => bool) private _isExcludedFromFee;
436     mapping(address => bool) private _isExcludedFromWalletHoldingLimit;
437     mapping(address => bool) private _isAutomaticMarketMaker;
438     mapping(address => bool) private _isAccountLimited;
439 
440     uint256 public _decimals = 18;
441     uint256 public _totalSupply = 690 * 10**6 * 10**_decimals;
442     string private _name = "BOB 2.0";
443     string private _symbol = "BOB2.0";
444 
445     address public immutable DeadWalletAddress =
446         0x000000000000000000000000000000000000dEaD;
447     address payable public MarketingWalletAddress;
448 
449     uint256 public _BuyingMarketingFee = 20;
450 
451     uint256 public _SellingMarketingFee = 99;
452 
453     uint256 internal feeDenominator = 100;
454 
455     IUniswapV2Router02 public uniswapV2Router;
456     address public uniswapV2Pair;
457 
458     bool internal inSwapAndLiquify;
459     bool public swapAndLiquifyEnabled = true;
460 
461     uint256 public numTokensSellToAddToLiquidity = (_totalSupply * 150) / 10**4;
462     uint256 public _maxWalletHoldingLimit = (_totalSupply * 2) / 10**2;
463 
464     event MaxWalletHoldingAmountUpdated(uint256 updatedMaxWalletHoldingAmount);
465     event AutomaticMarketMakerPairUpdated(address account, bool status);
466     event BuyingTaxFeeUpdated(uint256 TaxFees);
467     event SellingTaxFeeUpdated(uint256 TaxFees);
468     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
469     event SwapAndLiquifyEnabledUpdated(bool enabled);
470     event SwapAndLiquify(
471         uint256 tokensSwapped,
472         uint256 ETHReceived,
473         uint256 tokensIntoLiqudity
474     );
475 
476     modifier lockTheSwap() {
477         inSwapAndLiquify = true;
478         _;
479         inSwapAndLiquify = false;
480     }
481 
482     constructor() {
483         _balances[owner()] = _totalSupply;
484         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
485             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
486         );
487         // Create a uniswap pair for this new token
488         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
489             .createPair(address(this), _uniswapV2Router.WETH());
490 
491         // set the rest of the contract variables
492         uniswapV2Router = _uniswapV2Router;
493         //DeployerWallet
494         MarketingWalletAddress = payable(address(msg.sender));
495         //exclude owner and this contract from fee and Wallet holding Limits
496         _isExcludedFromFee[owner()] = true;
497         _isExcludedFromFee[address(this)] = true;
498         _isExcludedFromWalletHoldingLimit[owner()] = true;
499         _isExcludedFromWalletHoldingLimit[uniswapV2Pair] = true;
500         _isExcludedFromWalletHoldingLimit[address(this)] = true;
501         _isAutomaticMarketMaker[uniswapV2Pair] = true;
502 
503         emit Transfer(address(0), owner(), _totalSupply);
504     }
505 
506     function name() external view returns (string memory) {
507         return _name;
508     }
509 
510     function symbol() external view returns (string memory) {
511         return _symbol;
512     }
513 
514     function decimals() external view returns (uint256) {
515         return _decimals;
516     }
517 
518     function totalSupply() external view override returns (uint256) {
519         return _totalSupply;
520     }
521 
522     function balanceOf(address account) public view override returns (uint256) {
523         return _balances[account];
524     }
525 
526     function approve(address spender, uint256 amount)
527         public
528         virtual
529         override
530         returns (bool)
531     {
532         _approve(_msgSender(), spender, amount);
533         return true;
534     }
535 
536     function _approve(
537         address owner,
538         address spender,
539         uint256 amount
540     ) internal virtual {
541         require(owner != address(0), "IERC20: approve from the zero address");
542         require(spender != address(0), "IERC20: approve to the zero address");
543         _allowances[owner][spender] = amount;
544         emit Approval(owner, spender, amount);
545     }
546 
547     function allowance(address owner, address spender)
548         public
549         view
550         virtual
551         override
552         returns (uint256)
553     {
554         return _allowances[owner][spender];
555     }
556 
557     function increaseAllowance(address spender, uint256 addedValue)
558         public
559         virtual
560         returns (bool)
561     {
562         _approve(
563             _msgSender(),
564             spender,
565             _allowances[_msgSender()][spender] + addedValue
566         );
567         return true;
568     }
569 
570     function decreaseAllowance(address spender, uint256 subtractedValue)
571         public
572         virtual
573         returns (bool)
574     {
575         uint256 currentAllowance = _allowances[_msgSender()][spender];
576         require(
577             currentAllowance >= subtractedValue,
578             "IERC20: decreased allowance below zero"
579         );
580         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
581         return true;
582     }
583 
584     function ExcludeFromFee(address account) external onlyOwner {
585         _isExcludedFromFee[account] = true;
586     }
587 
588     function IncludeInFee(address account) external onlyOwner {
589         _isExcludedFromFee[account] = false;
590     }
591 
592     function IsExcludedFromTax(address account) external view returns (bool) {
593         return _isExcludedFromFee[account];
594     }
595 
596     function isExcludedFromWalletLimit(address WalletAddress)
597         external
598         view
599         returns (bool)
600     {
601         return _isExcludedFromWalletHoldingLimit[WalletAddress];
602     }
603 
604     function excludeFromMaxWalletHoldingLimit(address account)
605         external
606         onlyOwner
607     {
608         _isExcludedFromWalletHoldingLimit[account] = true;
609     }
610 
611     function includeInMaxWalletHoldingLimit(address account)
612         external
613         onlyOwner
614     {
615         require(
616             account != uniswapV2Pair,
617             "You can't play with Liquidity pair address"
618         );
619         _isExcludedFromWalletHoldingLimit[account] = false;
620     }
621 
622     function UpdateAccountLimition(address account, bool status)
623         external
624         onlyOwner
625     {
626         _isAccountLimited[account] = status;
627     }
628 
629     function isAccountLimited(address account) external view returns (bool) {
630         return _isAccountLimited[account];
631     }
632 
633     function UpdateWallets(address payable newMarketingWallet)
634         external
635         onlyOwner
636     {
637         require(newMarketingWallet != address(0), "You can't set zero address");
638         MarketingWalletAddress = newMarketingWallet;
639     }
640 
641     function UpdateBuyingTaxFees(uint256 newMarketingFee) external onlyOwner {
642         _BuyingMarketingFee = newMarketingFee;
643         emit BuyingTaxFeeUpdated(_BuyingMarketingFee);
644     }
645 
646     function UpdateSellingTaxFees(uint256 newMarketingFee) external onlyOwner {
647         _SellingMarketingFee = newMarketingFee;
648         emit SellingTaxFeeUpdated(_SellingMarketingFee);
649     }
650 
651     function UpdateNoOfTokensSellToGetReward(uint256 thresholdValue)
652         external
653         onlyOwner
654     {
655         numTokensSellToAddToLiquidity = thresholdValue * 10**_decimals;
656         emit MinTokensBeforeSwapUpdated(numTokensSellToAddToLiquidity);
657     }
658 
659     function removeWalletHoldingLimit() external onlyOwner {
660         _maxWalletHoldingLimit = (_totalSupply * 100) / 10**2;
661     }
662 
663     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
664         swapAndLiquifyEnabled = _enabled;
665         emit SwapAndLiquifyEnabledUpdated(_enabled);
666     }
667 
668     function transfer(address recipient, uint256 amount)
669         public
670         virtual
671         override
672         returns (bool)
673     {
674         _transfer(_msgSender(), recipient, amount);
675         return true;
676     }
677 
678     function transferFrom(
679         address sender,
680         address recipient,
681         uint256 amount
682     ) public virtual override returns (bool) {
683         _transfer(sender, recipient, amount);
684         uint256 currentAllowance = _allowances[sender][_msgSender()];
685         require(
686             currentAllowance >= amount,
687             "IERC20: transfer amount exceeds allowance"
688         );
689         return true;
690     }
691 
692     // To receive BNB from PancakeswapV2 when swapping
693     receive() external payable {}
694 
695     function _transfer(
696         address sender,
697         address recipient,
698         uint256 amount
699     ) internal virtual {
700         require(sender != address(0), "IERC20: transfer from the zero address");
701         require(
702             recipient != address(0),
703             "IERC20: transfer to the zero address"
704         );
705         require(
706             !_isAccountLimited[sender] && !_isAccountLimited[recipient],
707             "Sorry your account is limiited"
708         );
709         require(_balances[sender] >= amount, "You don't have enough balance");
710 
711         if (
712             !_isExcludedFromWalletHoldingLimit[recipient] && sender != owner()
713         ) {
714             require(
715                 balanceOf(recipient) + amount <= _maxWalletHoldingLimit,
716                 "Wallet Holding limit exceeded"
717             );
718         }
719 
720         uint256 totalTax = 0;
721 
722         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
723             totalTax = 0;
724         } else {
725             if (_isAutomaticMarketMaker[recipient]) {
726                 totalTax = (amount * (_SellingMarketingFee)) / (feeDenominator);
727             } else if (_isAutomaticMarketMaker[sender]) {
728                 totalTax = (amount * (_BuyingMarketingFee)) / (feeDenominator);
729             } else {
730                 totalTax = 0;
731             }
732         }
733 
734         uint256 contractTokenBalance = balanceOf(address(this));
735 
736         bool overMinTokenBalance = contractTokenBalance >=
737             numTokensSellToAddToLiquidity;
738         if (
739             !inSwapAndLiquify &&
740             recipient == uniswapV2Pair &&
741             swapAndLiquifyEnabled &&
742             balanceOf(uniswapV2Pair) > numTokensSellToAddToLiquidity
743         ) {
744             if (overMinTokenBalance) {
745                 contractTokenBalance = numTokensSellToAddToLiquidity;
746                 swapTokens(contractTokenBalance);
747             }
748         }
749 
750         uint256 amountReceived = amount - (totalTax);
751         _balances[address(this)] += totalTax;
752         _balances[sender] = _balances[sender] - amount;
753         _balances[recipient] += amountReceived;
754 
755         if (totalTax > 0) {
756             emit Transfer(sender, address(this), totalTax);
757         }
758         emit Transfer(sender, recipient, amountReceived);
759     }
760 
761     function swapTokens(uint256 _contractTokenBalance) private lockTheSwap {
762         swapTokensForETH(_contractTokenBalance);
763         uint256 MarketingBalance = address(this).balance;
764         if (MarketingBalance > 0) {
765             MarketingWalletAddress.transfer(address(this).balance);
766         }
767     }
768 
769     function swapTokensForETH(uint256 tokenAmount) private {
770         // generate the uniswap pair path of token -> wETH
771         address[] memory path = new address[](2);
772         path[0] = address(this);
773         path[1] = uniswapV2Router.WETH();
774 
775         _approve(address(this), address(uniswapV2Router), tokenAmount);
776 
777         // make the swap
778         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
779             tokenAmount,
780             0, // accept any amount of ETH
781             path,
782             address(this),
783             block.timestamp
784         );
785     }
786 }