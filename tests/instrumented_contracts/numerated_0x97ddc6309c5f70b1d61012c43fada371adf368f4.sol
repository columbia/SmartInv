1 // File: erc-20.sol
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     constructor() {
20         _transferOwnership(_msgSender());
21     }
22 
23     function owner() public view virtual returns (address) {
24         return _owner;
25     }
26 
27     modifier onlyOwner() {
28         require(owner() == _msgSender(), "Ownable: caller is not the owner");
29         _;
30     }
31 
32     function renounceOwnership() public virtual onlyOwner {
33         _transferOwnership(address(0));
34     }
35 
36     function transferOwnership(address newOwner) public virtual onlyOwner {
37         require(newOwner != address(0), "Ownable: new owner is the zero address");
38         _transferOwnership(newOwner);
39     }
40 
41     function _transferOwnership(address newOwner) internal virtual {
42         address oldOwner = _owner;
43         _owner = newOwner;
44         emit OwnershipTransferred(oldOwner, newOwner);
45     }
46 }
47 
48 interface IERC20 {
49     function totalSupply() external view returns (uint256);
50 
51     function balanceOf(address account) external view returns (uint256);
52 
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     function transferFrom(
60         address sender,
61         address recipient,
62         uint256 amount
63     ) external returns (bool);
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 interface IERC20Metadata is IERC20 {
71     function name() external view returns (string memory);
72 
73     function symbol() external view returns (string memory);
74 
75     function decimals() external view returns (uint8);
76 }
77 
78 contract ERC20 is Context, IERC20, IERC20Metadata {
79     mapping(address => uint256) private _balances;
80 
81     mapping(address => mapping(address => uint256)) private _allowances;
82 
83     uint256 private _totalSupply;
84 
85     string private _name;
86     string private _symbol;
87 
88     constructor(string memory name_, string memory symbol_) {
89         _name = name_;
90         _symbol = symbol_;
91     }
92 
93     function name() public view virtual override returns (string memory) {
94         return _name;
95     }
96 
97     function symbol() public view virtual override returns (string memory) {
98         return _symbol;
99     }
100 
101     function decimals() public view virtual override returns (uint8) {
102         return 18;
103     }
104 
105     function totalSupply() public view virtual override returns (uint256) {
106         return _totalSupply;
107     }
108 
109     function balanceOf(address account) public view virtual override returns (uint256) {
110         return _balances[account];
111     }
112 
113     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
114         _transfer(_msgSender(), recipient, amount);
115         return true;
116     }
117 
118     function allowance(address owner, address spender) public view virtual override returns (uint256) {
119         return _allowances[owner][spender];
120     }
121 
122     function approve(address spender, uint256 amount) public virtual override returns (bool) {
123         _approve(_msgSender(), spender, amount);
124         return true;
125     }
126 
127     function transferFrom(
128         address sender,
129         address recipient,
130         uint256 amount
131     ) public virtual override returns (bool) {
132         _transfer(sender, recipient, amount);
133 
134         uint256 currentAllowance = _allowances[sender][_msgSender()];
135         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
136         unchecked {
137             _approve(sender, _msgSender(), currentAllowance - amount);
138         }
139 
140         return true;
141     }
142 
143     function _transfer(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) internal virtual {
148         require(sender != address(0), "ERC20: transfer from the zero address");
149         require(recipient != address(0), "ERC20: transfer to the zero address");
150 
151         _beforeTokenTransfer(sender, recipient, amount);
152 
153         uint256 senderBalance = _balances[sender];
154         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
155         unchecked {
156             _balances[sender] = senderBalance - amount;
157         }
158         _balances[recipient] += amount;
159 
160         emit Transfer(sender, recipient, amount);
161 
162         _afterTokenTransfer(sender, recipient, amount);
163     }
164 
165     function _mint(address account, uint256 amount) internal virtual {
166         require(account != address(0), "ERC20: mint to the zero address");
167 
168         _beforeTokenTransfer(address(0), account, amount);
169 
170         _totalSupply += amount;
171         _balances[account] += amount;
172         emit Transfer(address(0), account, amount);
173 
174         _afterTokenTransfer(address(0), account, amount);
175     }
176 
177 
178     function _approve(
179         address owner,
180         address spender,
181         uint256 amount
182     ) internal virtual {
183         require(owner != address(0), "ERC20: approve from the zero address");
184         require(spender != address(0), "ERC20: approve to the zero address");
185 
186         _allowances[owner][spender] = amount;
187         emit Approval(owner, spender, amount);
188     }
189 
190     function _beforeTokenTransfer(
191         address from,
192         address to,
193         uint256 amount
194     ) internal virtual {}
195 
196     function _afterTokenTransfer(
197         address from,
198         address to,
199         uint256 amount
200     ) internal virtual {}
201 }
202 
203 library SafeMath {
204     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
205         unchecked {
206             uint256 c = a + b;
207             if (c < a) return (false, 0);
208             return (true, c);
209         }
210     }
211 
212     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
213         unchecked {
214             if (b > a) return (false, 0);
215             return (true, a - b);
216         }
217     }
218 
219     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
220         unchecked {
221             if (a == 0) return (true, 0);
222             uint256 c = a * b;
223             if (c / a != b) return (false, 0);
224             return (true, c);
225         }
226     }
227 
228     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
229         unchecked {
230             if (b == 0) return (false, 0);
231             return (true, a / b);
232         }
233     }
234 
235     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
236         unchecked {
237             if (b == 0) return (false, 0);
238             return (true, a % b);
239         }
240     }
241 
242     function add(uint256 a, uint256 b) internal pure returns (uint256) {
243         return a + b;
244     }
245 
246     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
247         return a - b;
248     }
249 
250     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
251         return a * b;
252     }
253 
254     function div(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a / b;
256     }
257 
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a % b;
260     }
261 
262     function sub(
263         uint256 a,
264         uint256 b,
265         string memory errorMessage
266     ) internal pure returns (uint256) {
267         unchecked {
268             require(b <= a, errorMessage);
269             return a - b;
270         }
271     }
272 
273     function div(
274         uint256 a,
275         uint256 b,
276         string memory errorMessage
277     ) internal pure returns (uint256) {
278         unchecked {
279             require(b > 0, errorMessage);
280             return a / b;
281         }
282     }
283 
284     function mod(
285         uint256 a,
286         uint256 b,
287         string memory errorMessage
288     ) internal pure returns (uint256) {
289         unchecked {
290             require(b > 0, errorMessage);
291             return a % b;
292         }
293     }
294 }
295 
296 interface IUniswapV2Factory {
297     event PairCreated(
298         address indexed token0,
299         address indexed token1,
300         address pair,
301         uint256
302     );
303 
304     function createPair(address tokenA, address tokenB)
305         external
306         returns (address pair);
307 }
308 
309 interface IUniswapV2Router02 {
310     function factory() external pure returns (address);
311 
312     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
313         uint256 amountIn,
314         uint256 amountOutMin,
315         address[] calldata path,
316         address to,
317         uint256 deadline
318     ) external;
319 }
320 
321 contract sanctuary is ERC20, Ownable {
322     using SafeMath for uint256;
323 
324     IUniswapV2Router02 public immutable uniswapV2Router;
325     address public immutable uniswapV2Pair;
326     address public constant deadAddress = address(0xdead);
327     address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
328 
329     bool private swapping;
330 
331     address public devWallet;
332 
333     uint256 public maxTransactionAmount;
334     uint256 public swapTokensAtAmount;
335     uint256 public maxWallet;
336 
337     bool public limitsInEffect = true;
338     bool public tradingActive = false;
339     bool public swapEnabled = true;
340 
341     uint256 public buyTotalFees;
342     uint256 public buyDevFee;
343     uint256 public buyLiquidityFee;
344 
345     uint256 public sellTotalFees;
346     uint256 public sellDevFee;
347     uint256 public sellLiquidityFee;
348 
349     /******************/
350 
351     // 
352     mapping(address => bool) private _isExcludedFromFees;
353     mapping(address => bool) public _isExcludedMaxTransactionAmount;
354 
355 
356     event ExcludeFromFees(address indexed account, bool isExcluded);
357 
358     event devWalletUpdated(
359         address indexed newWallet,
360         address indexed oldWallet
361     );
362 
363     constructor() ERC20("Sanctuary", "S") {
364         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
365 
366         excludeFromMaxTransaction(address(_uniswapV2Router), true);
367         uniswapV2Router = _uniswapV2Router;
368 
369         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
370             .createPair(address(this), USDC);
371         excludeFromMaxTransaction(address(uniswapV2Pair), true);
372 
373 
374         uint256 _buyDevFee = 0;
375         uint256 _buyLiquidityFee = 0;
376 
377         uint256 _sellDevFee = 2;
378         uint256 _sellLiquidityFee = 0;
379 
380         uint256 totalSupply = 100_000_000 * 1e18;
381 
382         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
383         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
384         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
385 
386         buyDevFee = _buyDevFee;
387         buyLiquidityFee = _buyLiquidityFee;
388         buyTotalFees = buyDevFee + buyLiquidityFee;
389 
390         sellDevFee = _sellDevFee;
391         sellLiquidityFee = _sellLiquidityFee;
392         sellTotalFees = sellDevFee + sellLiquidityFee;
393 
394         devWallet = address(0x83f3705Bb137d4ee7859398EaF92e8d4D5fAF37a); // set as dev wallet
395 
396         // exclude from paying fees or having max transaction amount
397         excludeFromFees(owner(), true);
398         excludeFromFees(address(this), true);
399         excludeFromFees(address(0xdead), true);
400 
401         excludeFromMaxTransaction(owner(), true);
402         excludeFromMaxTransaction(address(this), true);
403         excludeFromMaxTransaction(address(0xdead), true);
404 
405         /*
406             _mint is an internal function in ERC20.sol that is only called here,
407             and CANNOT be called ever again
408         */
409         _mint(msg.sender, totalSupply);
410     }
411 
412     receive() external payable {}
413 
414     // once enabled, can never be turned off
415     function enableTrading() external onlyOwner {
416         tradingActive = true;
417         swapEnabled = true;
418     }
419 
420     // remove limits after token is stable
421     function removeLimits() external onlyOwner returns (bool) {
422         limitsInEffect = false;
423         return true;
424     }
425 
426     // change the minimum amount of tokens to sell from fees
427     function updateSwapTokensAtAmount(uint256 newAmount)
428         external
429         onlyOwner
430         returns (bool)
431     {
432         require(
433             newAmount >= (totalSupply() * 1) / 100000,
434             "Swap amount cannot be lower than 0.001% total supply."
435         );
436         require(
437             newAmount <= (totalSupply() * 5) / 1000,
438             "Swap amount cannot be higher than 0.5% total supply."
439         );
440         swapTokensAtAmount = newAmount;
441         return true;
442     }
443 
444     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
445         require(
446             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
447             "Cannot set maxTransactionAmount lower than 0.1%"
448         );
449         maxTransactionAmount = newNum * (10**18);
450     }
451 
452     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
453         require(
454             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
455             "Cannot set maxWallet lower than 0.5%"
456         );
457         maxWallet = newNum * (10**18);
458     }
459 
460     function excludeFromMaxTransaction(address updAds, bool isEx)
461         public
462         onlyOwner
463     {
464         _isExcludedMaxTransactionAmount[updAds] = isEx;
465     }
466 
467     function updateSwapEnabled(bool enabled) external onlyOwner {
468         swapEnabled = enabled;
469     }
470 
471     function updateBuyFees(
472         uint256 _devFee,
473         uint256 _liquidityFee
474     ) external onlyOwner {
475         buyDevFee = _devFee;
476         buyLiquidityFee = _liquidityFee;
477         buyTotalFees = buyDevFee + buyLiquidityFee;
478         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
479     }
480 
481     function updateSellFees(
482         uint256 _devFee,
483         uint256 _liquidityFee
484     ) external onlyOwner {
485         sellDevFee = _devFee;
486         sellLiquidityFee = _liquidityFee;
487         sellTotalFees = sellDevFee + sellLiquidityFee;
488         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
489     }
490 
491     function excludeFromFees(address account, bool excluded) public onlyOwner {
492         _isExcludedFromFees[account] = excluded;
493         emit ExcludeFromFees(account, excluded);
494     }
495 
496     function updateDevWallet(address newDevWallet)
497         external
498         onlyOwner
499     {
500         emit devWalletUpdated(newDevWallet, devWallet);
501         devWallet = newDevWallet;
502     }
503 
504 
505     function isExcludedFromFees(address account) public view returns (bool) {
506         return _isExcludedFromFees[account];
507     }
508 
509     function _transfer(
510         address from,
511         address to,
512         uint256 amount
513     ) internal override {
514         require(from != address(0), "ERC20: transfer from the zero address");
515         require(to != address(0), "ERC20: transfer to the zero address");
516 
517         if (amount == 0) {
518             super._transfer(from, to, 0);
519             return;
520         }
521 
522         if (limitsInEffect) {
523             if (
524                 from != owner() &&
525                 to != owner() &&
526                 to != address(0) &&
527                 to != address(0xdead) &&
528                 !swapping
529             ) {
530                 if (!tradingActive) {
531                     require(
532                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
533                         "Trading is not active."
534                     );
535                 }
536 
537                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
538                 //when buy
539                 if (
540                     from == uniswapV2Pair &&
541                     !_isExcludedMaxTransactionAmount[to]
542                 ) {
543                     require(
544                         amount <= maxTransactionAmount,
545                         "Buy transfer amount exceeds the maxTransactionAmount."
546                     );
547                     require(
548                         amount + balanceOf(to) <= maxWallet,
549                         "Max wallet exceeded"
550                     );
551                 }
552                 else if (!_isExcludedMaxTransactionAmount[to]) {
553                     require(
554                         amount + balanceOf(to) <= maxWallet,
555                         "Max wallet exceeded"
556                     );
557                 }
558             }
559         }
560 
561         uint256 contractTokenBalance = balanceOf(address(this));
562 
563         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
564 
565         if (
566             canSwap &&
567             swapEnabled &&
568             !swapping &&
569             to == uniswapV2Pair &&
570             !_isExcludedFromFees[from] &&
571             !_isExcludedFromFees[to]
572         ) {
573             swapping = true;
574 
575             swapBack();
576 
577             swapping = false;
578         }
579 
580         bool takeFee = !swapping;
581 
582         // if any account belongs to _isExcludedFromFee account then remove the fee
583         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
584             takeFee = false;
585         }
586 
587         uint256 fees = 0;
588         uint256 tokensForLiquidity = 0;
589         uint256 tokensForDev = 0;
590         // only take fees on buys/sells, do not take on wallet transfers
591         if (takeFee) {
592             // on sell
593             if (to == uniswapV2Pair && sellTotalFees > 0) {
594                 fees = amount.mul(sellTotalFees).div(100);
595                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
596                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
597             }
598             // on buy
599             else if (from == uniswapV2Pair && buyTotalFees > 0) {
600                 fees = amount.mul(buyTotalFees).div(100);
601                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
602                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
603             }
604 
605             if (fees> 0) {
606                 super._transfer(from, address(this), fees);
607             }
608             if (tokensForLiquidity > 0) {
609                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
610             }
611 
612             amount -= fees;
613         }
614 
615         super._transfer(from, to, amount);
616     }
617 
618     function swapTokensForUSDC(uint256 tokenAmount) private {
619         // generate the uniswap pair path of token -> weth
620         address[] memory path = new address[](2);
621         path[0] = address(this);
622         path[1] = USDC;
623 
624         _approve(address(this), address(uniswapV2Router), tokenAmount);
625 
626         // make the swap
627         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
628             tokenAmount,
629             0, // accept any amount of USDC
630             path,
631             devWallet,
632             block.timestamp
633         );
634     }
635 
636     function swapBack() private {
637         uint256 contractBalance = balanceOf(address(this));
638         if (contractBalance == 0) {
639             return;
640         }
641 
642         if (contractBalance > swapTokensAtAmount * 20) {
643             contractBalance = swapTokensAtAmount * 20;
644         }
645 
646         swapTokensForUSDC(contractBalance);
647     }
648 
649 }