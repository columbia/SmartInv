1 // SPDX-License-Identifier: MIT
2 pragma solidity = 0.8.17;
3 
4 /*
5  SHILLER Token is here - Join the $SHILLA Army, with its brand new, first of its kind utility - SHILLING Competition on Twitter!
6  The ShillerBot is LIVE and first shilling competition is starting on launch! The $SHILLA who shills on Twitter the most, wins the competition prize!
7   Join us:
8  
9   Website: https://www.shiller.app
10   Telegram: https://t.me/Shiller_portal
11   Twitter: https://twitter.com/ShillerErc
12  
13  */
14 
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 interface IUniswapV2Factory {
27     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
28 
29     function createPair(address tokenA, address tokenB) external returns (address pair);
30 
31 }
32 
33 
34 interface IUniswapV2Pair {
35     event Approval(address indexed owner, address indexed spender, uint value);
36     event Transfer(address indexed from, address indexed to, uint value);
37 
38     function name() external pure returns (string memory);
39     function symbol() external pure returns (string memory);
40     function decimals() external pure returns (uint8);
41     function totalSupply() external view returns (uint);
42     function balanceOf(address owner) external view returns (uint);
43     function allowance(address owner, address spender) external view returns (uint);
44 
45     function approve(address spender, uint value) external returns (bool);
46     function transfer(address to, uint value) external returns (bool);
47     function transferFrom(address from, address to, uint value) external returns (bool);
48 
49     function DOMAIN_SEPARATOR() external view returns (bytes32);
50     function PERMIT_TYPEHASH() external pure returns (bytes32);
51     function nonces(address owner) external view returns (uint);
52 
53     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
54 
55     event Mint(address indexed sender, uint amount0, uint amount1);
56     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
57     event Swap(
58         address indexed sender,
59         uint amount0In,
60         uint amount1In,
61         uint amount0Out,
62         uint amount1Out,
63         address indexed to
64     );
65     event Sync(uint112 reserve0, uint112 reserve1);
66 
67     function MINIMUM_LIQUIDITY() external pure returns (uint);
68     function factory() external view returns (address);
69     function token0() external view returns (address);
70     function token1() external view returns (address);
71     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
72     function price0CumulativeLast() external view returns (uint);
73     function price1CumulativeLast() external view returns (uint);
74     function kLast() external view returns (uint);
75 
76     function mint(address to) external returns (uint liquidity);
77     function burn(address to) external returns (uint amount0, uint amount1);
78     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
79     function skim(address to) external;
80     function sync() external;
81 
82     function initialize(address, address) external;
83 }
84 
85 
86 interface IERC20 {
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89     function totalSupply() external view returns (uint256);
90     function balanceOf(address account) external view returns (uint256);
91     function transfer(address to, uint256 amount) external returns (bool);
92     function allowance(address owner, address spender) external view returns (uint256);
93     function approve(address spender, uint256 amount) external returns (bool);
94     function transferFrom(address from, address to, uint256 amount) external returns (bool);
95 }
96 
97 
98 interface IERC20Metadata is IERC20 {
99     function name() external view returns (string memory);
100     function symbol() external view returns (string memory);
101     function decimals() external view returns (uint8);
102 }
103 
104 
105 abstract contract Ownable is Context {
106     address private _owner;
107 
108     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109 
110     constructor() {
111         _transferOwnership(_msgSender());
112     }
113 
114     modifier onlyOwner() {
115         _checkOwner();
116         _;
117     }
118 
119     function owner() public view virtual returns (address) {
120         return _owner;
121     }
122 
123     function _checkOwner() internal view virtual {
124         require(owner() == _msgSender(), "Ownable: caller is not the owner");
125     }
126 
127 
128     function renounceOwnership() public virtual onlyOwner {
129         _transferOwnership(address(0));
130     }
131 
132 
133     function transferOwnership(address newOwner) public virtual onlyOwner {
134         require(newOwner != address(0), "Ownable: new owner is the zero address");
135         _transferOwnership(newOwner);
136     }
137 
138 
139     function _transferOwnership(address newOwner) internal virtual {
140         address oldOwner = _owner;
141         _owner = newOwner;
142         emit OwnershipTransferred(oldOwner, newOwner);
143     }
144 }
145 
146 // ERC20 Contract 
147 
148 contract ERC20 is Context, IERC20, IERC20Metadata {
149     mapping(address => uint256) private _balances;
150     mapping(address => mapping(address => uint256)) private _allowances;
151 
152     uint256 private _totalSupply;
153 
154     string private _name;
155     string private _symbol;
156 
157     constructor(string memory name_, string memory symbol_) {
158         _name = name_;
159         _symbol = symbol_;
160     }
161 
162 
163     function symbol() external view virtual override returns (string memory) {
164         return _symbol;
165     }
166 
167     function name() external view virtual override returns (string memory) {
168         return _name;
169     }
170 
171 
172     function balanceOf(address account)
173         public
174         view
175         virtual
176         override
177         returns (uint256)
178     {
179         return _balances[account];
180     }
181 
182 
183     function decimals() public view virtual override returns (uint8) {
184         return 9;
185     }
186 
187 
188     function totalSupply() external view virtual override returns (uint256) {
189         return _totalSupply;
190     }
191 
192 
193     function allowance(address owner, address spender)
194         public
195         view
196         virtual
197         override
198         returns (uint256)
199     {
200         return _allowances[owner][spender];
201     }
202 
203 
204     function transfer(address to, uint256 amount)
205         external
206         virtual
207         override
208         returns (bool)
209     {
210         address owner = _msgSender();
211         _transfer(owner, to, amount);
212         return true;
213     }
214 
215 
216     function approve(address spender, uint256 amount)
217         external
218         virtual
219         override
220         returns (bool)
221     {
222         address owner = _msgSender();
223         _approve(owner, spender, amount);
224         return true;
225     }
226 
227 
228     function transferFrom(
229         address from,
230         address to,
231         uint256 amount
232     ) external virtual override returns (bool) {
233         address spender = _msgSender();
234         _spendAllowance(from, spender, amount);
235         _transfer(from, to, amount);
236         return true;
237     }
238 
239 
240     function decreaseAllowance(address spender, uint256 subtractedValue)
241         external
242         virtual
243         returns (bool)
244     {
245         address owner = _msgSender();
246         uint256 currentAllowance = allowance(owner, spender);
247         require(
248             currentAllowance >= subtractedValue,
249             "ERC20: decreased allowance below zero"
250         );
251         unchecked {
252             _approve(owner, spender, currentAllowance - subtractedValue);
253         }
254 
255         return true;
256     }
257 
258 
259     function increaseAllowance(address spender, uint256 addedValue)
260         external
261         virtual
262         returns (bool)
263     {
264         address owner = _msgSender();
265         _approve(owner, spender, allowance(owner, spender) + addedValue);
266         return true;
267     }
268 
269 
270     function _mint(address account, uint256 amount) internal virtual {
271         require(account != address(0), "ERC20: mint to the zero address");
272 
273         _totalSupply += amount;
274         unchecked {
275             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
276             _balances[account] += amount;
277         }
278         emit Transfer(address(0), account, amount);
279     }
280 
281 
282     function _burn(address account, uint256 amount) internal virtual {
283         require(account != address(0), "ERC20: burn from the zero address");
284 
285         uint256 accountBalance = _balances[account];
286         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
287         unchecked {
288             _balances[account] = accountBalance - amount;
289             // Overflow not possible: amount <= accountBalance <= totalSupply.
290             _totalSupply -= amount;
291         }
292 
293         emit Transfer(account, address(0), amount);
294     }
295 
296 
297     function _approve(
298         address owner,
299         address spender,
300         uint256 amount
301     ) internal virtual {
302         require(owner != address(0), "ERC20: approve from the zero address");
303         require(spender != address(0), "ERC20: approve to the zero address");
304 
305         _allowances[owner][spender] = amount;
306         emit Approval(owner, spender, amount);
307     }
308 
309     function _spendAllowance(
310         address owner,
311         address spender,
312         uint256 amount
313     ) internal virtual {
314         uint256 currentAllowance = allowance(owner, spender);
315         if (currentAllowance != type(uint256).max) {
316             require(
317                 currentAllowance >= amount,
318                 "ERC20: insufficient allowance"
319             );
320             unchecked {
321                 _approve(owner, spender, currentAllowance - amount);
322             }
323         }
324     }
325 
326     function _transfer(
327         address from,
328         address to,
329         uint256 amount
330     ) internal virtual {
331         require(from != address(0), "ERC20: transfer from the zero address");
332         require(to != address(0), "ERC20: transfer to the zero address");
333 
334         uint256 fromBalance = _balances[from];
335         require(
336             fromBalance >= amount,
337             "ERC20: transfer amount exceeds balance"
338         );
339         unchecked {
340             _balances[from] = fromBalance - amount;
341             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
342             // decrementing then incrementing.
343             _balances[to] += amount;
344         }
345 
346         emit Transfer(from, to, amount);
347     }
348 }
349 
350 
351 
352 
353 
354 interface IUniswapV2Router01 {
355     function factory() external pure returns (address);
356 
357     function WETH() external pure returns (address);
358 
359     function addLiquidity(
360         address tokenA,
361         address tokenB,
362         uint256 amountADesired,
363         uint256 amountBDesired,
364         uint256 amountAMin,
365         uint256 amountBMin,
366         address to,
367         uint256 deadline
368     )
369         external
370         returns (
371             uint256 amountA,
372             uint256 amountB,
373             uint256 liquidity
374         );
375 
376     function addLiquidityETH(
377         address token,
378         uint256 amountTokenDesired,
379         uint256 amountTokenMin,
380         uint256 amountETHMin,
381         address to,
382         uint256 deadline
383     )
384         external
385         payable
386         returns (
387             uint256 amountToken,
388             uint256 amountETH,
389             uint256 liquidity
390         );
391 
392     function removeLiquidity(
393         address tokenA,
394         address tokenB,
395         uint256 liquidity,
396         uint256 amountAMin,
397         uint256 amountBMin,
398         address to,
399         uint256 deadline
400     ) external returns (uint256 amountA, uint256 amountB);
401 
402     function removeLiquidityETH(
403         address token,
404         uint256 liquidity,
405         uint256 amountTokenMin,
406         uint256 amountETHMin,
407         address to,
408         uint256 deadline
409     ) external returns (uint256 amountToken, uint256 amountETH);
410 
411     function removeLiquidityWithPermit(
412         address tokenA,
413         address tokenB,
414         uint256 liquidity,
415         uint256 amountAMin,
416         uint256 amountBMin,
417         address to,
418         uint256 deadline,
419         bool approveMax,
420         uint8 v,
421         bytes32 r,
422         bytes32 s
423     ) external returns (uint256 amountA, uint256 amountB);
424 
425     function removeLiquidityETHWithPermit(
426         address token,
427         uint256 liquidity,
428         uint256 amountTokenMin,
429         uint256 amountETHMin,
430         address to,
431         uint256 deadline,
432         bool approveMax,
433         uint8 v,
434         bytes32 r,
435         bytes32 s
436     ) external returns (uint256 amountToken, uint256 amountETH);
437 
438     function swapExactTokensForTokens(
439         uint256 amountIn,
440         uint256 amountOutMin,
441         address[] calldata path,
442         address to,
443         uint256 deadline
444     ) external returns (uint256[] memory amounts);
445 
446     function swapTokensForExactTokens(
447         uint256 amountOut,
448         uint256 amountInMax,
449         address[] calldata path,
450         address to,
451         uint256 deadline
452     ) external returns (uint256[] memory amounts);
453 
454     function swapExactETHForTokens(
455         uint256 amountOutMin,
456         address[] calldata path,
457         address to,
458         uint256 deadline
459     ) external payable returns (uint256[] memory amounts);
460 
461     function swapTokensForExactETH(
462         uint256 amountOut,
463         uint256 amountInMax,
464         address[] calldata path,
465         address to,
466         uint256 deadline
467     ) external returns (uint256[] memory amounts);
468 
469     function swapExactTokensForETH(
470         uint256 amountIn,
471         uint256 amountOutMin,
472         address[] calldata path,
473         address to,
474         uint256 deadline
475     ) external returns (uint256[] memory amounts);
476 
477     function swapETHForExactTokens(
478         uint256 amountOut,
479         address[] calldata path,
480         address to,
481         uint256 deadline
482     ) external payable returns (uint256[] memory amounts);
483 
484     function quote(
485         uint256 amountA,
486         uint256 reserveA,
487         uint256 reserveB
488     ) external pure returns (uint256 amountB);
489 
490     function getAmountOut(
491         uint256 amountIn,
492         uint256 reserveIn,
493         uint256 reserveOut
494     ) external pure returns (uint256 amountOut);
495 
496     function getAmountIn(
497         uint256 amountOut,
498         uint256 reserveIn,
499         uint256 reserveOut
500     ) external pure returns (uint256 amountIn);
501 
502     function getAmountsOut(uint256 amountIn, address[] calldata path)
503         external
504         view
505         returns (uint256[] memory amounts);
506 
507     function getAmountsIn(uint256 amountOut, address[] calldata path)
508         external
509         view
510         returns (uint256[] memory amounts);
511 }
512 
513 interface IUniswapV2Router02 is IUniswapV2Router01 {
514     function removeLiquidityETHSupportingFeeOnTransferTokens(
515         address token,
516         uint256 liquidity,
517         uint256 amountTokenMin,
518         uint256 amountETHMin,
519         address to,
520         uint256 deadline
521     ) external returns (uint256 amountETH);
522 
523     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
524         address token,
525         uint256 liquidity,
526         uint256 amountTokenMin,
527         uint256 amountETHMin,
528         address to,
529         uint256 deadline,
530         bool approveMax,
531         uint8 v,
532         bytes32 r,
533         bytes32 s
534     ) external returns (uint256 amountETH);
535 
536     function swapExactETHForTokensSupportingFeeOnTransferTokens(
537         uint256 amountOutMin,
538         address[] calldata path,
539         address to,
540         uint256 deadline
541     ) external payable;
542 
543     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
544         uint256 amountIn,
545         uint256 amountOutMin,
546         address[] calldata path,
547         address to,
548         uint256 deadline
549     ) external;
550 
551     function swapExactTokensForETHSupportingFeeOnTransferTokens(
552         uint256 amountIn,
553         uint256 amountOutMin,
554         address[] calldata path,
555         address to,
556         uint256 deadline
557     ) external;
558 }
559 
560 contract Shiller is ERC20, Ownable {
561     
562     IUniswapV2Router02 public immutable uniswapV2Router;
563     address public immutable uniswapV2Pair;
564     address public constant deadAddress = address(0xdead);
565 
566     // TOKENOMICS
567     string private _name = "Shiller";
568     string private _symbol = "SHILLA";
569     uint8 private _decimals = 9;
570     uint256 private _supply = 100000000;
571     uint256 public maxTxAmount = 1000000 * 10**_decimals;
572     uint256 public maxWalletAmount = 1000000 * 10**_decimals;
573     bool public maxWalletEnabled = true;
574 
575 
576     // ======================================
577     // FEE
578 
579     uint256 public buyLiqFee;
580     uint256 public buyMarketingFee;
581     uint256 public buyContestFee;
582     uint256 public buyTotalFee;
583 
584 
585     uint256 public sellLiqFee;
586     uint256 public sellMarketingFee;
587     uint256 public sellContestFee;
588     uint256 public sellTotalFee;
589     
590     
591     address public marketingFeeAddress;
592     address public contestFeeAddress; 
593 
594     //=======================================
595     // EVENTS
596 
597     event updateBuyTax(uint256 buyLiqFee, uint256 buyMarketingFee, uint256 buyContestFee);
598     event updateSellTax(uint256 sellLiqFee, uint256 sellMarketingFee, uint256 sellContestFee);
599     event updateMaxTxAmount(uint256 maxTxAmount);
600     event updateMaxWalletAmount(uint256 maxWalletAmount);
601     event updateContestReceiver(address contestFeeReceiver); 
602     event updateMarketingReceiver(address marketingFeeAddress);
603     event TradingEnabled();
604     event ExcludeFromFees(address indexed account, bool isExcluded);
605     event SetAutomatedMarketMakerPair(address pair, bool value);
606     
607     //=======================================
608     // MAPS
609     mapping(address => bool) private _isExcludedFromFees;
610     mapping(address => bool) private canTransferBeforeTradingIsEnabled;
611     mapping(address => bool) public automatedMarketMakerPairs;
612 
613     //=======================================
614 
615     uint256 private _feeReserves = 0;
616     uint256 private _tokensAmountToSellForLiq = 500000 * 10**_decimals;
617     uint256 private _tokensAmountToSellForMarketing = 800000 * 10**_decimals;
618     uint256 private _tokensAmountToSellForContest = 200000 * 10**_decimals;
619     uint256 private swapTokensTrigger = 1200000 * 10**_decimals;
620     uint256 public launchblock; // FOR DEADBLOCKS
621     uint256 private deadblocks;
622     uint256 public launchtimestamp; 
623     uint256 public cooldowntimer = 30; //COOLDOWN TIMER
624     bool public swapAndLiquifyEnabled = true;
625     bool public inSwapAndLiquify = false;
626     bool public limitsInEffect = true;
627     bool public tradingEnabled = false;
628     bool private swapping;
629     bool public cooldoownEnabled = true;
630 
631     event SwapAndLiquify(
632         uint256 tokenAmountSwapped, 
633         uint256 ethAmountReceived, 
634         uint256 tokenAmountToLiquidity);
635 
636     modifier lockSwap() {
637         inSwapAndLiquify = true;
638         _;
639         inSwapAndLiquify = false;
640     }
641 
642 
643 
644     constructor() ERC20(_name, _symbol) {
645         _mint(msg.sender, (_supply * 10**_decimals));
646 
647         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
648         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
649 
650         buyMarketingFee = 8;
651         buyLiqFee = 2;
652         buyContestFee = 2;
653         buyTotalFee = buyLiqFee + buyMarketingFee + buyContestFee;
654 
655         sellMarketingFee = 30;
656         sellLiqFee = 2;
657         sellContestFee = 3;
658         sellTotalFee = sellLiqFee + sellMarketingFee + sellContestFee;
659 
660 
661         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
662 
663         uniswapV2Router = _uniswapV2Router;
664 
665         marketingFeeAddress = address(0x9169923f0882a74aefd97e40302da40b32236409);
666         contestFeeAddress = address(0xa0E5867C0dfD99847Af3830007C48a994C112710);
667 
668         _isExcludedFromFees[address(uniswapV2Router)] = true;
669         _isExcludedFromFees[msg.sender] = true;
670         _isExcludedFromFees[address(this)] = true;
671     
672         canTransferBeforeTradingIsEnabled[msg.sender] = true;
673         canTransferBeforeTradingIsEnabled[address(this)] = true;
674     }
675 
676 
677     function enableTrading() external onlyOwner {
678         require(!tradingEnabled);
679         tradingEnabled = true;
680         launchblock = block.number;
681         launchtimestamp = block.timestamp;
682         deadblocks = 3;
683         emit TradingEnabled();
684     }
685 
686     function changeMarketingReceiver(address newAddress) public onlyOwner {
687         marketingFeeAddress = newAddress;
688         emit updateMarketingReceiver(marketingFeeAddress);
689     }    
690 
691     function changeContestReceiver(address newAddress) public onlyOwner {
692         contestFeeAddress = newAddress;
693         emit updateContestReceiver(contestFeeAddress);
694     }
695 
696     function setExcludeFees(address account, bool excluded) public onlyOwner {
697         _isExcludedFromFees[account] = excluded;
698         emit ExcludeFromFees(account, excluded);
699     }
700 
701     function setLimitsInEffect(bool value) external onlyOwner {
702         limitsInEffect = value;
703     }
704 
705     function setSwapTriggerAmount(uint256 amountMarketingFee, uint256 amountLiqFee, uint256 amountContestFee) public onlyOwner {
706         _tokensAmountToSellForMarketing = amountMarketingFee * (10**_decimals);
707         _tokensAmountToSellForLiq = amountLiqFee * (10**_decimals);
708         _tokensAmountToSellForContest = amountContestFee * (10**_decimals);
709     }
710 
711     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
712         _setAutomatedMarketMakerPair(pair, value);
713     }
714 
715     function _setAutomatedMarketMakerPair(address pair, bool value) private {
716         automatedMarketMakerPairs[pair] = value;
717 
718         emit SetAutomatedMarketMakerPair(pair, value);
719     }
720 
721     function setBuyTax(uint256 _buyLiqFee, uint256 _buyMarketingFee, uint256 _buyContestFee) public onlyOwner {
722         require((_buyLiqFee + _buyMarketingFee + _buyContestFee) <= 100, "ERC20: total tax must no be greater than 100");
723         buyLiqFee = _buyLiqFee;
724         buyMarketingFee = _buyMarketingFee;
725         buyContestFee = _buyContestFee;
726         buyTotalFee = buyLiqFee + buyMarketingFee + buyContestFee;
727         emit updateBuyTax(buyLiqFee, buyMarketingFee, buyContestFee);
728     }
729 
730 
731     function setSellTax(uint256 _sellLiqFee, uint256 _sellMarketingFee, uint256 _sellContestFee) public onlyOwner {
732         require((_sellLiqFee + _sellMarketingFee) <= 100, "ERC20: total tax must no be greater than 100");
733         sellLiqFee = _sellLiqFee;
734         sellMarketingFee = _sellMarketingFee;
735         sellContestFee = _sellContestFee;
736         sellTotalFee = sellLiqFee + sellMarketingFee + sellContestFee;
737         emit updateSellTax(sellLiqFee, sellMarketingFee, sellContestFee);
738     }
739 
740     function setMaxTxAmount(uint256 _maxTxAmount) public onlyOwner {
741         maxTxAmount = _maxTxAmount;
742         emit updateMaxTxAmount(maxTxAmount);
743     }
744 
745     function setMaxWalletAmount(uint256 _maxWalletAmount) public onlyOwner {
746         maxWalletAmount = _maxWalletAmount;
747         emit updateMaxWalletAmount(maxWalletAmount);
748     }
749 
750     
751 
752     function _swapTokensForEth(uint256 tokenAmount) private lockSwap {
753     address[] memory path = new address[](2);
754     path[0] = address(this);
755     path[1] = uniswapV2Router.WETH();
756 
757     _approve(address(this), address(uniswapV2Router), tokenAmount);
758 
759     uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
760         tokenAmount,
761         0,
762         path,
763         address(this),
764         (block.timestamp + 300)
765     );
766     }
767 
768     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private lockSwap {
769         _approve(address(this), address(uniswapV2Router), tokenAmount);
770 
771         uniswapV2Router.addLiquidityETH{value: ethAmount}(
772             address(this),
773             tokenAmount,
774             0,
775             0,
776             owner(),
777             block.timestamp
778         );
779     }
780     function _transfer(address from, address to, uint256 amount) internal override {
781         require(from != address(0), "ERC20: transfer from the zero address");
782         require(to != address(0), "ERC20: transfer to the zero address");
783         require(amount > 0, "Transfer amount must be greater than zero");
784 
785         uint256 marketingFee;
786         uint256 liqFee;
787         uint256 contestFee;
788 
789         if (!canTransferBeforeTradingIsEnabled[from]) {
790             require(tradingEnabled, "Trading has not yet been enabled");          
791         }    
792 
793         if (to == deadAddress) {
794             _burn(from, amount);
795             return;
796         }
797 
798         else if (!swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
799             require(amount <= maxTxAmount, "Cannot exceed max transaction amount");
800 
801             bool isSelling = automatedMarketMakerPairs[to];
802             bool isBuying = automatedMarketMakerPairs[from];
803             uint256 transferAmount = amount;
804 
805             // If the transaction is a Sell
806             if (isSelling) {
807                 
808                 // Get the fee's
809                 marketingFee = sellMarketingFee;
810                 liqFee = sellLiqFee;
811                 contestFee = sellContestFee;
812 
813                 // Check reserves and balances
814                 uint256 contractTokenBalance = balanceOf(address(this));
815 
816                 bool swapForLiq = (contractTokenBalance - _feeReserves) >= _tokensAmountToSellForLiq;
817                 bool swapForFees = _feeReserves > _tokensAmountToSellForMarketing + _tokensAmountToSellForContest;
818 
819                 // get fee's
820                 if (swapForLiq || swapForFees) {
821                     swapping = true;
822 
823                     if (swapAndLiquifyEnabled && swapForLiq) {
824                         _swapAndLiquify(_tokensAmountToSellForLiq);
825                     }
826 
827                     if (swapForFees) {
828                         uint256 amountToSwap = _tokensAmountToSellForMarketing + _tokensAmountToSellForContest;
829                         _swapTokensForEth(amountToSwap);
830                         _feeReserves -= amountToSwap;
831                         uint256 ethForContest = (address(this).balance * _tokensAmountToSellForContest) / amountToSwap;
832                         uint256 ethForMarketing = address(this).balance - ethForContest;
833 
834                         bool sentcontest = payable(contestFeeAddress).send(ethForContest);
835                         bool sentmarketing = payable(marketingFeeAddress).send(ethForMarketing);
836                         require(sentcontest, "Failed to send ETH");
837                         require(sentmarketing, "Failed to send ETH");
838 
839                     }
840                     
841                     swapping = false;
842                 }
843             }
844 
845             // Else if transaction is a Buy
846             else if (isBuying) {
847                 marketingFee = buyMarketingFee;
848                 liqFee = buyLiqFee;
849                 contestFee = buyContestFee;
850 
851                 if (maxWalletEnabled) {
852                     uint256 contractBalanceRecipient = balanceOf(to);
853                     require(contractBalanceRecipient + amount <= maxWalletAmount, "Exceeds max wallet.");
854                 }
855 
856                 if (limitsInEffect) { 
857                     if (block.number < launchblock + deadblocks) {
858                         uint256 botFee = 99 - (liqFee + contestFee);
859                         marketingFee = botFee;
860                     }
861                 }
862 
863             }
864 
865             // Divide the amount between receiving and fee share
866             if (marketingFee > 0 && liqFee > 0 && contestFee > 0) {
867                 uint256 marketingContestFeeShare = ((amount * (marketingFee + contestFee)) / 100);
868                 uint256 liqFeeShare = ((amount * liqFee) / 100);
869                 uint256 feeShare = marketingContestFeeShare + liqFeeShare;
870                 transferAmount = amount - feeShare;
871                 _feeReserves += marketingContestFeeShare;
872                 super._transfer(from, address(this), feeShare);
873             }
874 
875             super._transfer(from, to, transferAmount);
876         }
877         else {
878             super._transfer(from, to, amount);
879         }
880     }
881 
882 
883 
884     // Swaps Tokens for Fee's
885     function _swapAndLiquify(uint256 contractTokenBalance) private lockSwap {
886         uint256 dividedBalance = (contractTokenBalance / 2);
887         uint256 otherdividedBalance = (contractTokenBalance - dividedBalance);
888 
889         uint256 initialBalance = address(this).balance;
890 
891         _swapTokensForEth(dividedBalance);
892 
893         uint256 newBalance = (address(this).balance - initialBalance);
894 
895         _addLiquidity(otherdividedBalance, newBalance);
896 
897         emit SwapAndLiquify(dividedBalance, newBalance, otherdividedBalance);
898     }
899     receive() external payable {}
900 }