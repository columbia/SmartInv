1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.18;
3 
4 /**
5 
6         ████████╗██████╗░░█████╗░██████╗░███████╗░██╗░░░░░░░██╗██╗██╗░░██╗    ████████╗░█████╗░██╗░░██╗███████╗███╗░░██╗
7         ╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔════╝░██║░░██╗░░██║██║╚██╗██╔╝    ╚══██╔══╝██╔══██╗██║░██╔╝██╔════╝████╗░██║
8         ░░░██║░░░██████╔╝███████║██║░░██║█████╗░░░╚██╗████╗██╔╝██║░╚███╔╝░    ░░░██║░░░██║░░██║█████═╝░█████╗░░██╔██╗██║
9         ░░░██║░░░██╔══██╗██╔══██║██║░░██║██╔══╝░░░░████╔═████║░██║░██╔██╗░    ░░░██║░░░██║░░██║██╔═██╗░██╔══╝░░██║╚████║
10         ░░░██║░░░██║░░██║██║░░██║██████╔╝███████╗░░╚██╔╝░╚██╔╝░██║██╔╝╚██╗    ░░░██║░░░╚█████╔╝██║░╚██╗███████╗██║░╚███║
11         ░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝    ░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚══╝
12 
13 */
14 interface IBEP20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function transfer(address recipient, uint256 amount)
20         external
21         returns (bool);
22 
23     function allowance(address owner, address spender)
24         external
25         view
26         returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(
38         address indexed owner,
39         address indexed spender,
40         uint256 value
41     );
42 }
43 
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes calldata) {
50         this;
51         return msg.data;
52     }
53 }
54 
55 abstract contract Ownable is Context {
56     address private _owner;
57     event OwnershipTransferred(
58         address indexed previousOwner,
59         address indexed newOwner
60     );
61 
62     constructor() {
63         _owner = address(msg.sender);
64         emit OwnershipTransferred(address(0), _owner);
65     }
66 
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(
83             newOwner != address(0),
84             "Ownable: new owner is the zero address"
85         );
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 interface IUniswapV2Factory {
92     event PairCreated(
93         address indexed token0,
94         address indexed token1,
95         address pair,
96         uint256
97     );
98 
99     function feeTo() external view returns (address);
100 
101     function feeToSetter() external view returns (address);
102 
103     function getPair(address tokenA, address tokenB)
104         external
105         view
106         returns (address pair);
107 
108     function allPairs(uint256) external view returns (address pair);
109 
110     function allPairsLength() external view returns (uint256);
111 
112     function createPair(address tokenA, address tokenB)
113         external
114         returns (address pair);
115 
116     function setFeeTo(address) external;
117 
118     function setFeeToSetter(address) external;
119 }
120 
121 interface IUniswapV2Pair {
122     event Approval(
123         address indexed owner,
124         address indexed spender,
125         uint256 value
126     );
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 
129     function name() external pure returns (string memory);
130 
131     function symbol() external pure returns (string memory);
132 
133     function decimals() external pure returns (uint8);
134 
135     function totalSupply() external view returns (uint256);
136 
137     function balanceOf(address owner) external view returns (uint256);
138 
139     function allowance(address owner, address spender)
140         external
141         view
142         returns (uint256);
143 
144     function approve(address spender, uint256 value) external returns (bool);
145 
146     function transfer(address to, uint256 value) external returns (bool);
147 
148     function transferFrom(
149         address from,
150         address to,
151         uint256 value
152     ) external returns (bool);
153 
154     function DOMAIN_SEPARATOR() external view returns (bytes32);
155 
156     function PERMIT_TYPEHASH() external pure returns (bytes32);
157 
158     function nonces(address owner) external view returns (uint256);
159 
160     function permit(
161         address owner,
162         address spender,
163         uint256 value,
164         uint256 deadline,
165         uint8 v,
166         bytes32 r,
167         bytes32 s
168     ) external;
169 
170     event Burn(
171         address indexed sender,
172         uint256 amount0,
173         uint256 amount1,
174         address indexed to
175     );
176     event Swap(
177         address indexed sender,
178         uint256 amount0In,
179         uint256 amount1In,
180         uint256 amount0Out,
181         uint256 amount1Out,
182         address indexed to
183     );
184     event Sync(uint112 reserve0, uint112 reserve1);
185 
186     function MINIMUM_LIQUIDITY() external pure returns (uint256);
187 
188     function factory() external view returns (address);
189 
190     function token0() external view returns (address);
191 
192     function token1() external view returns (address);
193 
194     function getReserves()
195         external
196         view
197         returns (
198             uint112 reserve0,
199             uint112 reserve1,
200             uint32 blockTimestampLast
201         );
202 
203     function price0CumulativeLast() external view returns (uint256);
204 
205     function price1CumulativeLast() external view returns (uint256);
206 
207     function kLast() external view returns (uint256);
208 
209     function burn(address to)
210         external
211         returns (uint256 amount0, uint256 amount1);
212 
213     function swap(
214         uint256 amount0Out,
215         uint256 amount1Out,
216         address to,
217         bytes calldata data
218     ) external;
219 
220     function skim(address to) external;
221 
222     function sync() external;
223 
224     function initialize(address, address) external;
225 }
226 
227 interface IUniswapV2Router01 {
228     function factory() external pure returns (address);
229 
230     function WETH() external pure returns (address);
231 
232     function addLiquidity(
233         address tokenA,
234         address tokenB,
235         uint256 amountADesired,
236         uint256 amountBDesired,
237         uint256 amountAMin,
238         uint256 amountBMin,
239         address to,
240         uint256 deadline
241     )
242         external
243         returns (
244             uint256 amountA,
245             uint256 amountB,
246             uint256 liquidity
247         );
248 
249     function addLiquidityETH(
250         address token,
251         uint256 amountTokenDesired,
252         uint256 amountTokenMin,
253         uint256 amountETHMin,
254         address to,
255         uint256 deadline
256     )
257         external
258         payable
259         returns (
260             uint256 amountToken,
261             uint256 amountETH,
262             uint256 liquidity
263         );
264 
265     function removeLiquidity(
266         address tokenA,
267         address tokenB,
268         uint256 liquidity,
269         uint256 amountAMin,
270         uint256 amountBMin,
271         address to,
272         uint256 deadline
273     ) external returns (uint256 amountA, uint256 amountB);
274 
275     function removeLiquidityETH(
276         address token,
277         uint256 liquidity,
278         uint256 amountTokenMin,
279         uint256 amountETHMin,
280         address to,
281         uint256 deadline
282     ) external returns (uint256 amountToken, uint256 amountETH);
283 
284     function removeLiquidityWithPermit(
285         address tokenA,
286         address tokenB,
287         uint256 liquidity,
288         uint256 amountAMin,
289         uint256 amountBMin,
290         address to,
291         uint256 deadline,
292         bool approveMax,
293         uint8 v,
294         bytes32 r,
295         bytes32 s
296     ) external returns (uint256 amountA, uint256 amountB);
297 
298     function removeLiquidityETHWithPermit(
299         address token,
300         uint256 liquidity,
301         uint256 amountTokenMin,
302         uint256 amountETHMin,
303         address to,
304         uint256 deadline,
305         bool approveMax,
306         uint8 v,
307         bytes32 r,
308         bytes32 s
309     ) external returns (uint256 amountToken, uint256 amountETH);
310 
311     function swapExactTokensForTokens(
312         uint256 amountIn,
313         uint256 amountOutMin,
314         address[] calldata path,
315         address to,
316         uint256 deadline
317     ) external returns (uint256[] memory amounts);
318 
319     function swapTokensForExactTokens(
320         uint256 amountOut,
321         uint256 amountInMax,
322         address[] calldata path,
323         address to,
324         uint256 deadline
325     ) external returns (uint256[] memory amounts);
326 
327     function swapExactETHForTokens(
328         uint256 amountOutMin,
329         address[] calldata path,
330         address to,
331         uint256 deadline
332     ) external payable returns (uint256[] memory amounts);
333 
334     function swapTokensForExactETH(
335         uint256 amountOut,
336         uint256 amountInMax,
337         address[] calldata path,
338         address to,
339         uint256 deadline
340     ) external returns (uint256[] memory amounts);
341 
342     function swapExactTokensForETH(
343         uint256 amountIn,
344         uint256 amountOutMin,
345         address[] calldata path,
346         address to,
347         uint256 deadline
348     ) external returns (uint256[] memory amounts);
349 
350     function swapETHForExactTokens(
351         uint256 amountOut,
352         address[] calldata path,
353         address to,
354         uint256 deadline
355     ) external payable returns (uint256[] memory amounts);
356 
357     function quote(
358         uint256 amountA,
359         uint256 reserveA,
360         uint256 reserveB
361     ) external pure returns (uint256 amountB);
362 
363     function getAmountOut(
364         uint256 amountIn,
365         uint256 reserveIn,
366         uint256 reserveOut
367     ) external pure returns (uint256 amountOut);
368 
369     function getAmountIn(
370         uint256 amountOut,
371         uint256 reserveIn,
372         uint256 reserveOut
373     ) external pure returns (uint256 amountIn);
374 
375     function getAmountsOut(uint256 amountIn, address[] calldata path)
376         external
377         view
378         returns (uint256[] memory amounts);
379 
380     function getAmountsIn(uint256 amountOut, address[] calldata path)
381         external
382         view
383         returns (uint256[] memory amounts);
384 }
385 
386 interface IUniswapV2Router02 is IUniswapV2Router01 {
387     function removeLiquidityETHSupportingFeeOnTransferTokens(
388         address token,
389         uint256 liquidity,
390         uint256 amountTokenMin,
391         uint256 amountETHMin,
392         address to,
393         uint256 deadline
394     ) external returns (uint256 amountETH);
395 
396     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
397         address token,
398         uint256 liquidity,
399         uint256 amountTokenMin,
400         uint256 amountETHMin,
401         address to,
402         uint256 deadline,
403         bool approveMax,
404         uint8 v,
405         bytes32 r,
406         bytes32 s
407     ) external returns (uint256 amountETH);
408 
409     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
410         uint256 amountIn,
411         uint256 amountOutMin,
412         address[] calldata path,
413         address to,
414         uint256 deadline
415     ) external;
416 
417     function swapExactETHForTokensSupportingFeeOnTransferTokens(
418         uint256 amountOutMin,
419         address[] calldata path,
420         address to,
421         uint256 deadline
422     ) external payable;
423 
424     function swapExactTokensForETHSupportingFeeOnTransferTokens(
425         uint256 amountIn,
426         uint256 amountOutMin,
427         address[] calldata path,
428         address to,
429         uint256 deadline
430     ) external;
431 }
432 
433 contract TradeWixToken is Ownable, IBEP20 {
434     mapping(address => uint256) private _balances;
435     mapping(address => mapping(address => uint256)) private _allowances;
436     mapping(address => bool) private _isExcludedFromFee;
437     mapping(address => bool) private _isExcludedFromWalletHoldingLimit;
438     mapping(address => bool) private _isExcludedFromTxLimit;
439     mapping(address => bool) private _isAutomaticMarketMaker;
440     uint256 public _decimals = 18;
441     uint256 public _totalSupply = 1 * 10**9 * 10**_decimals;
442     string private _name = "TradeWix";
443     string private _symbol = "WIX";
444 
445     address public immutable DeadWalletAddress =
446         0x000000000000000000000000000000000000dEaD;
447     address payable public MarketingWalletAddress =
448         payable(0x2EB15D3C5c5C6C30C2D53d552d49236673889cf4);
449     address payable public StakingWalletAddress =
450         payable(0xf57fd7Fa55E5e58EF67F00877C31351e1cFe26A3);
451 
452     uint256 public _BuyingLiquidityFee = 1;
453     uint256 public _BuyingMarketingFee = 2;
454     uint256 public _BuyingStakingFee = 1;
455 
456     uint256 public _SellingLiquidityFee = 1;
457     uint256 public _SellingMarketingFee = 2;
458     uint256 public _SellingStakingFee = 1;
459 
460     uint256 internal feeDenominator = 100;
461 
462     IUniswapV2Router02 public uniswapV2Router;
463     address public uniswapV2Pair;
464 
465     bool internal inSwapAndLiquify;
466     bool public swapAndLiquifyEnabled = true;
467 
468     uint256 public numTokensSellToAddToLiquidity = 1 * 10**6 * 10**_decimals;
469     uint256 public _maxWalletHoldingLimit = 11 * 10**6 * 10**_decimals;
470     uint256 public _maxTxLimit = 10 * 10**6 * 10**_decimals;
471 
472     event MaxWalletHoldingAmountUpdated(uint256 updatedMaxWalletHoldingAmount);
473     event MaxTxHoldingAmountUpdated(uint256 updatedMaxTxAmount);
474     event AutomaticMarketMakerPairUpdated(address account, bool status);
475     event TaxBuyingFeeUpdated(uint256 TaxFees);
476     event TaxSellingFeeUpdated(uint256 TaxFees);
477     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
478     event SwapAndLiquifyEnabledUpdated(bool enabled);
479     event SwapAndLiquify(
480         uint256 tokensSwapped,
481         uint256 ETHReceived,
482         uint256 tokensIntoLiqudity
483     );
484 
485     modifier lockTheSwap() {
486         inSwapAndLiquify = true;
487         _;
488         inSwapAndLiquify = false;
489     }
490 
491     constructor() {
492         _balances[owner()] = _totalSupply;
493         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
494             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
495         );
496         // Create a uniswap pair for this new token
497         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
498             .createPair(address(this), _uniswapV2Router.WETH());
499 
500         // set the rest of the contract variables
501         uniswapV2Router = _uniswapV2Router;
502 
503         //exclude owner and this contract from fee and Wallet holding Limits
504         _isExcludedFromFee[owner()] = true;
505         _isExcludedFromFee[address(this)] = true;
506         _isExcludedFromFee[StakingWalletAddress] = true;
507         _isExcludedFromFee[MarketingWalletAddress] = true;
508 
509         _isExcludedFromTxLimit[address(this)] = true;
510         _isExcludedFromTxLimit[owner()] = true;
511         _isExcludedFromTxLimit[MarketingWalletAddress] = true;
512         _isExcludedFromTxLimit[StakingWalletAddress] = true;
513 
514         _isExcludedFromWalletHoldingLimit[address(this)] = true;
515         _isExcludedFromWalletHoldingLimit[StakingWalletAddress] = true;
516         _isExcludedFromWalletHoldingLimit[uniswapV2Pair] = true;
517         _isExcludedFromWalletHoldingLimit[MarketingWalletAddress] = true;
518         _isExcludedFromWalletHoldingLimit[owner()] = true;
519 
520         _isAutomaticMarketMaker[uniswapV2Pair] = true;
521 
522         emit Transfer(address(0), owner(), _totalSupply);
523     }
524 
525     function name() external view returns (string memory) {
526         return _name;
527     }
528 
529     function symbol() external view returns (string memory) {
530         return _symbol;
531     }
532 
533     function decimals() external view returns (uint256) {
534         return _decimals;
535     }
536 
537     function totalSupply() external view override returns (uint256) {
538         return _totalSupply;
539     }
540 
541     function balanceOf(address account) public view override returns (uint256) {
542         return _balances[account];
543     }
544 
545     function approve(address spender, uint256 amount)
546         public
547         virtual
548         override
549         returns (bool)
550     {
551         _approve(_msgSender(), spender, amount);
552         return true;
553     }
554 
555     function _approve(
556         address owner,
557         address spender,
558         uint256 amount
559     ) internal virtual {
560         require(owner != address(0), "IBEP20: approve from the zero address");
561         require(spender != address(0), "IBEP20: approve to the zero address");
562         _allowances[owner][spender] = amount;
563         emit Approval(owner, spender, amount);
564     }
565 
566     function allowance(address owner, address spender)
567         public
568         view
569         virtual
570         override
571         returns (uint256)
572     {
573         return _allowances[owner][spender];
574     }
575 
576     function increaseAllowance(address spender, uint256 addedValue)
577         public
578         virtual
579         returns (bool)
580     {
581         _approve(
582             _msgSender(),
583             spender,
584             _allowances[_msgSender()][spender] + addedValue
585         );
586         return true;
587     }
588 
589     function decreaseAllowance(address spender, uint256 subtractedValue)
590         public
591         virtual
592         returns (bool)
593     {
594         uint256 currentAllowance = _allowances[_msgSender()][spender];
595         require(
596             currentAllowance >= subtractedValue,
597             "IBEP20: decreased allowance below zero"
598         );
599         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
600         return true;
601     }
602 
603     function excludeFromFee(address account) external onlyOwner {
604         _isExcludedFromFee[account] = true;
605     }
606 
607     function includeInFee(address account) external onlyOwner {
608         _isExcludedFromFee[account] = false;
609     }
610 
611     function isExcludedFromTax(address add) external view returns (bool) {
612         return _isExcludedFromFee[add];
613     }
614 
615     function isExcludedFromWalletLimit(address WalletAddress)
616         external
617         view
618         returns (bool)
619     {
620         return _isExcludedFromWalletHoldingLimit[WalletAddress];
621     }
622 
623     function excludeFromMaxWalletHoldingLimit(address account)
624         external
625         onlyOwner
626     {
627         _isExcludedFromWalletHoldingLimit[account] = true;
628     }
629 
630     function includeInMaxWalletHoldingLimit(address account)
631         external
632         onlyOwner
633     {
634         require(
635             account != uniswapV2Pair,
636             "You can't play with Liquidity pair address"
637         );
638         _isExcludedFromWalletHoldingLimit[account] = false;
639     }
640 
641     function UpdateMaxWalletHoldingLimit(uint256 maxWalletHoldingAmount)
642         external
643         onlyOwner
644     {
645         require(
646             maxWalletHoldingAmount * 10**_decimals >= 1_000_000 * 10**_decimals,
647             "Amount should be greater or equal to 1 Millin Tokens"
648         );
649         _maxWalletHoldingLimit = maxWalletHoldingAmount * 10**_decimals;
650         emit MaxWalletHoldingAmountUpdated(_maxWalletHoldingLimit);
651     }
652 
653     function excludeFromMaxTxLimit(address account) external onlyOwner {
654         _isExcludedFromTxLimit[account] = true;
655     }
656 
657     function includeInMaxTxLimit(address account) external onlyOwner {
658         _isExcludedFromTxLimit[account] = false;
659     }
660 
661     function UpdateMaxTxLimit(uint256 maxTxAmount) external onlyOwner {
662         require(
663             maxTxAmount * 10**_decimals >= 1_000_000 * 10**_decimals,
664             "Amount should be greater or equal to 1 Millin Tokens"
665         );
666         _maxTxLimit = maxTxAmount * 10**_decimals;
667         emit MaxTxHoldingAmountUpdated(_maxTxLimit);
668     }
669 
670     function isAutomaticMarketMaker(address account)
671         external
672         view
673         returns (bool)
674     {
675         return _isAutomaticMarketMaker[account];
676     }
677 
678     function setNewLiquidityPair(address addNewAMM, bool status)
679         external
680         onlyOwner
681     {
682         _isAutomaticMarketMaker[addNewAMM] = status;
683         emit AutomaticMarketMakerPairUpdated(addNewAMM, status);
684     }
685 
686     function UpdateWallets(address payable newMarketingWallet)
687         external
688         onlyOwner
689     {
690         require(newMarketingWallet != address(0), "You can't set zero address");
691         MarketingWalletAddress = newMarketingWallet;
692     }
693 
694     function UpdateBuyingTaxFees(
695         uint256 newLiquidityFee,
696         uint256 newMarketingFee,
697         uint256 newStakingFee
698     ) external onlyOwner {
699         require(
700             newLiquidityFee + newMarketingFee + newStakingFee <= 15,
701             "you can't set more than 15%"
702         );
703         _BuyingLiquidityFee = newLiquidityFee;
704         _BuyingMarketingFee = newMarketingFee;
705         _BuyingStakingFee = newStakingFee;
706 
707         emit TaxBuyingFeeUpdated(
708             _BuyingLiquidityFee + _BuyingMarketingFee + _BuyingStakingFee
709         );
710     }
711 
712     function UpdateSellingTaxFees(
713         uint256 newLiquidityFee,
714         uint256 newMarketingFee,
715         uint256 newStakingFee
716     ) external onlyOwner {
717         require(
718             newLiquidityFee + newMarketingFee + newStakingFee <= 15,
719             "you can't set more than 15%"
720         );
721         _SellingLiquidityFee = newLiquidityFee;
722         _SellingMarketingFee = newMarketingFee;
723         _SellingStakingFee = newStakingFee;
724 
725         emit TaxSellingFeeUpdated(
726             _SellingLiquidityFee + _SellingMarketingFee + _SellingStakingFee
727         );
728     }
729 
730     function UpdateNoOfTokensSellToGetReward(uint256 thresholdValue)
731         external
732         onlyOwner
733     {
734         numTokensSellToAddToLiquidity = thresholdValue * 10**_decimals;
735         emit MinTokensBeforeSwapUpdated(numTokensSellToAddToLiquidity);
736     }
737 
738     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
739         swapAndLiquifyEnabled = _enabled;
740         emit SwapAndLiquifyEnabledUpdated(_enabled);
741     }
742 
743     function transfer(address recipient, uint256 amount)
744         public
745         virtual
746         override
747         returns (bool)
748     {
749         _transfer(_msgSender(), recipient, amount);
750         return true;
751     }
752 
753     function transferFrom(
754         address sender,
755         address recipient,
756         uint256 amount
757     ) public virtual override returns (bool) {
758         _transfer(sender, recipient, amount);
759         uint256 currentAllowance = _allowances[sender][_msgSender()];
760         require(
761             currentAllowance >= amount,
762             "IBEP20: transfer amount exceeds allowance"
763         );
764         return true;
765     }
766 
767     // To receive ETH from uniswapV2Router when swapping
768     receive() external payable {}
769 
770     function _transfer(
771         address sender,
772         address recipient,
773         uint256 amount
774     ) internal virtual {
775         require(sender != address(0), "IBEP20: transfer from the zero address");
776         require(
777             recipient != address(0),
778             "IBEP20: transfer to the zero address"
779         );
780         require(_balances[sender] >= amount, "You don't have enough balance");
781 
782         if (
783             !_isExcludedFromWalletHoldingLimit[recipient] && sender != owner()
784         ) {
785             require(
786                 balanceOf(recipient) + amount <= _maxWalletHoldingLimit,
787                 "Wallet Holding limit exceeded"
788             );
789         }
790 
791         if (sender != owner()) {
792             require(
793                 amount <= _maxTxLimit ||
794                     _isExcludedFromTxLimit[sender] ||
795                     _isExcludedFromTxLimit[recipient],
796                 "TX Limit Exceeded"
797             );
798         }
799 
800         uint256 totalTax = 0;
801 
802         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
803             totalTax = 0;
804         } else {
805             if (_isAutomaticMarketMaker[recipient]) {
806                 totalTax =
807                     (amount *
808                         (_SellingLiquidityFee +
809                             _SellingMarketingFee +
810                             _SellingStakingFee)) /
811                     (feeDenominator);
812             } else {
813                 totalTax =
814                     (amount *
815                         (_BuyingLiquidityFee +
816                             _BuyingMarketingFee +
817                             _BuyingStakingFee)) /
818                     (feeDenominator);
819             }
820         }
821 
822         uint256 contractTokenBalance = balanceOf(address(this));
823 
824         bool overMinTokenBalance = contractTokenBalance >=
825             numTokensSellToAddToLiquidity;
826         if (
827             !inSwapAndLiquify &&
828             recipient == uniswapV2Pair &&
829             swapAndLiquifyEnabled &&
830             balanceOf(uniswapV2Pair) > numTokensSellToAddToLiquidity
831         ) {
832             if (overMinTokenBalance) {
833                 contractTokenBalance = numTokensSellToAddToLiquidity;
834 
835                 uint256 remainingLiquidityToken;
836                 if (
837                     _SellingLiquidityFee +
838                         _SellingMarketingFee +
839                         _SellingStakingFee >
840                     0
841                 ) {
842                     remainingLiquidityToken =
843                         (contractTokenBalance *
844                             (_SellingMarketingFee + _SellingStakingFee)) /
845                         (_SellingMarketingFee +
846                             _SellingLiquidityFee +
847                             _SellingStakingFee);
848                 }
849 
850                 uint256 liquidityToken;
851                 if (_SellingLiquidityFee > 0) {
852                     liquidityToken =
853                         contractTokenBalance -
854                         (remainingLiquidityToken);
855                 } else {
856                     if (_SellingMarketingFee + _SellingStakingFee > 0) {
857                         remainingLiquidityToken = contractTokenBalance;
858                     }
859                 }
860 
861                 // Swap Tokens and Send to Marketing Wallet
862                 if (_SellingMarketingFee + _SellingStakingFee > 0) {
863                     swapTokens(remainingLiquidityToken);
864                 }
865                 if (liquidityToken > 0) {
866                     // Remove Hate Swap and Liquidity by breaking Token in proportion
867                     swapAndLiquify(liquidityToken);
868                 }
869             }
870         }
871 
872         uint256 amountReceived = amount - (totalTax);
873         _balances[address(this)] += totalTax;
874         _balances[sender] = _balances[sender] - amount;
875         _balances[recipient] += amountReceived;
876 
877         if (totalTax > 0) {
878             emit Transfer(sender, address(this), totalTax);
879         }
880         emit Transfer(sender, recipient, amountReceived);
881     }
882 
883     function swapTokens(uint256 _contractTokenBalance) private lockTheSwap {
884         uint256 combineFee = _SellingMarketingFee + _SellingStakingFee;
885         uint256 initialBalance = address(this).balance;
886         swapTokensForETH(_contractTokenBalance);
887         uint256 transferredBalance = address(this).balance - (initialBalance);
888         uint256 marketingBalance = (transferredBalance *
889             (_SellingMarketingFee)) / (combineFee);
890         uint256 stakingBalance = (transferredBalance * (_SellingStakingFee)) /
891             combineFee;
892 
893         if (marketingBalance > 0) {
894             transferToAddressETH(MarketingWalletAddress, marketingBalance);
895         }
896         if (stakingBalance > 0) {
897             transferToAddressETH(StakingWalletAddress, stakingBalance);
898         }
899     }
900 
901     function transferToAddressETH(address payable recipient, uint256 amount)
902         private
903     {
904         recipient.transfer(amount);
905     }
906 
907     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
908         // split the contract balance into halves
909         uint256 half = contractTokenBalance / 2;
910         uint256 otherHalf = contractTokenBalance - half;
911 
912         // capture the contract's current ETH balance.
913         // this is so that we can capture exactly the amount of ETH that the
914         // swap creates, and not make the liquidity event include any ETH that
915         // has been manually sent to the contract
916         uint256 initialBalance = address(this).balance;
917 
918         // swap tokens for ETH
919         swapTokensForETH(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
920 
921         // how much ETH did we just swap into?
922         uint256 newBalance = address(this).balance - (initialBalance);
923 
924         // add liquidity to uniswap
925         addLiquidity(otherHalf, newBalance);
926 
927         emit SwapAndLiquify(half, newBalance, otherHalf);
928 
929         if (address(this).balance > 0) {
930             MarketingWalletAddress.transfer(address(this).balance);
931         }
932     }
933 
934     function swapTokensForETH(uint256 tokenAmount) private {
935         // generate the uniswap pair path of token -> wETH
936         address[] memory path = new address[](2);
937         path[0] = address(this);
938         path[1] = uniswapV2Router.WETH();
939 
940         _approve(address(this), address(uniswapV2Router), tokenAmount);
941 
942         // make the swap
943         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
944             tokenAmount,
945             0, // accept any amount of ETH
946             path,
947             address(this),
948             block.timestamp
949         );
950     }
951 
952     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
953         // approve token transfer to cover all possible scenarios
954         _approve(address(this), address(uniswapV2Router), tokenAmount);
955 
956         // add the liquidity
957         uniswapV2Router.addLiquidityETH{value: ETHAmount}(
958             address(this),
959             tokenAmount,
960             0, // slippage is unavoidable
961             0, // slippage is unavoidable
962             owner(),
963             block.timestamp
964         );
965     }
966 
967     /* Airdrop Begins */
968     function AirDropMultiTransfer(
969         address[] calldata addresses,
970         uint256[] calldata tokens
971     ) external {
972         address from = msg.sender;
973         require(
974             addresses.length < 501,
975             "GAS Error: max airdrop limit is 500 addresses"
976         );
977         require(
978             addresses.length == tokens.length,
979             "Mismatch between Address and token count"
980         );
981 
982         uint256 SCCC = 0;
983 
984         for (uint256 i = 0; i < addresses.length; i++) {
985             SCCC = SCCC + tokens[i];
986         }
987 
988         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
989 
990         for (uint256 i = 0; i < addresses.length; i++) {
991             _transfer(from, addresses[i], tokens[i]);
992         }
993     }
994 }