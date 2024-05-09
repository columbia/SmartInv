1 /**
2   ____        _           _               ____            
3  | __ )  __ _| |__  _   _| | ___  _ __   | __ )  ___  ___ 
4  |  _ \ / _` | '_ \| | | | |/ _ \| '_ \  |  _ \ / _ \/ _ \
5  | |_) | (_| | |_) | |_| | | (_) | | | | | |_) |  __/  __/
6  |____/ \__,_|_.__/ \__, |_|\___/|_| |_| |____/ \___|\___|
7                     |___/                                 
8 
9 Website:  https://BabylonBeeCoin.com/
10 Telegram: https://t.me/babylonbeeportal
11 Twitter:  https://twitter.com/BabylonBeeToken            
12 
13 */
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 pragma solidity 0.8.18;
18  
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23  
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28  
29 interface IUniswapV2Pair {
30     event Approval(address indexed owner, address indexed spender, uint value);
31     event Transfer(address indexed from, address indexed to, uint value);
32  
33     function name() external pure returns (string memory);
34     function symbol() external pure returns (string memory);
35     function decimals() external pure returns (uint8);
36     function totalSupply() external view returns (uint);
37     function balanceOf(address owner) external view returns (uint);
38     function allowance(address owner, address spender) external view returns (uint);
39  
40     function approve(address spender, uint value) external returns (bool);
41     function transfer(address to, uint value) external returns (bool);
42     function transferFrom(address from, address to, uint value) external returns (bool);
43  
44     function DOMAIN_SEPARATOR() external view returns (bytes32);
45     function PERMIT_TYPEHASH() external pure returns (bytes32);
46     function nonces(address owner) external view returns (uint);
47  
48     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
49  
50     event Mint(address indexed sender, uint amount0, uint amount1);
51     event Swap(
52         address indexed sender,
53         uint amount0In,
54         uint amount1In,
55         uint amount0Out,
56         uint amount1Out,
57         address indexed to
58     );
59     event Sync(uint112 reserve0, uint112 reserve1);
60  
61     function MINIMUM_LIQUIDITY() external pure returns (uint);
62     function factory() external view returns (address);
63     function token0() external view returns (address);
64     function token1() external view returns (address);
65     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
66     function price0CumulativeLast() external view returns (uint);
67     function price1CumulativeLast() external view returns (uint);
68     function kLast() external view returns (uint);
69  
70     function mint(address to) external returns (uint liquidity);
71     function burn(address to) external returns (uint amount0, uint amount1);
72     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
73     function skim(address to) external;
74     function sync() external;
75  
76     function initialize(address, address) external;
77 }
78  
79 interface IUniswapV2Factory {
80     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
81  
82     function feeTo() external view returns (address);
83     function feeToSetter() external view returns (address);
84  
85     function getPair(address tokenA, address tokenB) external view returns (address pair);
86     function allPairs(uint) external view returns (address pair);
87     function allPairsLength() external view returns (uint);
88  
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90  
91     function setFeeTo(address) external;
92     function setFeeToSetter(address) external;
93 }
94  
95 interface IERC20 {
96 
97     function totalSupply() external view returns (uint256);
98 
99     function balanceOf(address account) external view returns (uint256);
100 
101     function transfer(address recipient, uint256 amount) external returns (bool);
102 
103     function allowance(address owner, address spender) external view returns (uint256);
104 
105     function approve(address spender, uint256 amount) external returns (bool);
106 
107     function transferFrom(
108         address sender,
109         address recipient,
110         uint256 amount
111     ) external returns (bool);
112 
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117  
118 interface IERC20Metadata is IERC20 {
119 
120     function name() external view returns (string memory);
121 
122     function symbol() external view returns (string memory);
123 
124     function decimals() external view returns (uint8);
125 }
126  
127  
128 contract ERC20 is Context, IERC20, IERC20Metadata {
129     using SafeMath for uint256;
130  
131     mapping(address => uint256) private _balances;
132  
133     mapping(address => mapping(address => uint256)) private _allowances;
134  
135     uint256 private _totalSupply;
136  
137     string private _name;
138     string private _symbol;
139 
140     constructor(string memory name_, string memory symbol_) {
141         _name = name_;
142         _symbol = symbol_;
143     }
144 
145     function name() public view virtual override returns (string memory) {
146         return _name;
147     }
148 
149     function symbol() public view virtual override returns (string memory) {
150         return _symbol;
151     }
152 
153     function decimals() public view virtual override returns (uint8) {
154         return 18;
155     }
156 
157     function totalSupply() public view virtual override returns (uint256) {
158         return _totalSupply;
159     }
160 
161     function balanceOf(address account) public view virtual override returns (uint256) {
162         return _balances[account];
163     }
164 
165     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
166         _transfer(_msgSender(), recipient, amount);
167         return true;
168     }
169 
170     function allowance(address owner, address spender) public view virtual override returns (uint256) {
171         return _allowances[owner][spender];
172     }
173 
174     function approve(address spender, uint256 amount) public virtual override returns (bool) {
175         _approve(_msgSender(), spender, amount);
176         return true;
177     }
178 
179     function transferFrom(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) public virtual override returns (bool) {
184         _transfer(sender, recipient, amount);
185         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
186         return true;
187     }
188 
189     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
190         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
191         return true;
192     }
193 
194     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
195         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
196         return true;
197     }
198 
199     function _transfer(
200         address sender,
201         address recipient,
202         uint256 amount
203     ) internal virtual {
204         require(sender != address(0), "ERC20: transfer from the zero address");
205         require(recipient != address(0), "ERC20: transfer to the zero address");
206  
207         _beforeTokenTransfer(sender, recipient, amount);
208  
209         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
210         _balances[recipient] = _balances[recipient].add(amount);
211         emit Transfer(sender, recipient, amount);
212     }
213 
214     function _mint(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: mint to the zero address");
216  
217         _beforeTokenTransfer(address(0), account, amount);
218  
219         _totalSupply = _totalSupply.add(amount);
220         _balances[account] = _balances[account].add(amount);
221         emit Transfer(address(0), account, amount);
222     }
223 
224     function _burn(address account, uint256 amount) internal virtual {
225         require(account != address(0), "ERC20: burn from the zero address");
226  
227         _beforeTokenTransfer(account, address(0), amount);
228  
229         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
230         _totalSupply = _totalSupply.sub(amount);
231         emit Transfer(account, address(0), amount);
232     }
233 
234     function _approve(
235         address owner,
236         address spender,
237         uint256 amount
238     ) internal virtual {
239         require(owner != address(0), "ERC20: approve from the zero address");
240         require(spender != address(0), "ERC20: approve to the zero address");
241  
242         _allowances[owner][spender] = amount;
243         emit Approval(owner, spender, amount);
244     }
245 
246     function _beforeTokenTransfer(
247         address from,
248         address to,
249         uint256 amount
250     ) internal virtual {}
251 }
252  
253 library SafeMath {
254 
255     function add(uint256 a, uint256 b) internal pure returns (uint256) {
256         uint256 c = a + b;
257         require(c >= a, "SafeMath: addition overflow");
258  
259         return c;
260     }
261 
262     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263         return sub(a, b, "SafeMath: subtraction overflow");
264     }
265 
266     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b <= a, errorMessage);
268         uint256 c = a - b;
269  
270         return c;
271     }
272 
273     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
274 
275         if (a == 0) {
276             return 0;
277         }
278  
279         uint256 c = a * b;
280         require(c / a == b, "SafeMath: multiplication overflow");
281  
282         return c;
283     }
284 
285     function div(uint256 a, uint256 b) internal pure returns (uint256) {
286         return div(a, b, "SafeMath: division by zero");
287     }
288 
289     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b > 0, errorMessage);
291         uint256 c = a / b;
292         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
293  
294         return c;
295     }
296 
297     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
298         return mod(a, b, "SafeMath: modulo by zero");
299     }
300 
301     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b != 0, errorMessage);
303         return a % b;
304     }
305 }
306  
307 contract Ownable is Context {
308     address private _owner;
309  
310     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
311 
312     constructor () {
313         address msgSender = _msgSender();
314         _owner = msgSender;
315         emit OwnershipTransferred(address(0), msgSender);
316     }
317 
318     function owner() public view returns (address) {
319         return _owner;
320     }
321 
322     modifier onlyOwner() {
323         require(_owner == _msgSender(), "Ownable: caller is not the owner");
324         _;
325     }
326 
327     function renounceOwnership() public virtual onlyOwner {
328         emit OwnershipTransferred(_owner, address(0));
329         _owner = address(0);
330     }
331 
332     function transferOwnership(address newOwner) public virtual onlyOwner {
333         require(newOwner != address(0), "Ownable: new owner is the zero address");
334         emit OwnershipTransferred(_owner, newOwner);
335         _owner = newOwner;
336     }
337 }
338  
339  
340  
341 library SafeMathInt {
342     int256 private constant MIN_INT256 = int256(1) << 255;
343     int256 private constant MAX_INT256 = ~(int256(1) << 255);
344 
345     function mul(int256 a, int256 b) internal pure returns (int256) {
346         int256 c = a * b;
347  
348         // Detect overflow when multiplying MIN_INT256 with -1
349         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
350         require((b == 0) || (c / b == a));
351         return c;
352     }
353 
354     function div(int256 a, int256 b) internal pure returns (int256) {
355         // Prevent overflow when dividing MIN_INT256 by -1
356         require(b != -1 || a != MIN_INT256);
357  
358         // Solidity already throws when dividing by 0.
359         return a / b;
360     }
361 
362     function sub(int256 a, int256 b) internal pure returns (int256) {
363         int256 c = a - b;
364         require((b >= 0 && c <= a) || (b < 0 && c > a));
365         return c;
366     }
367 
368     function add(int256 a, int256 b) internal pure returns (int256) {
369         int256 c = a + b;
370         require((b >= 0 && c >= a) || (b < 0 && c < a));
371         return c;
372     }
373 
374     function abs(int256 a) internal pure returns (int256) {
375         require(a != MIN_INT256);
376         return a < 0 ? -a : a;
377     }
378  
379  
380     function toUint256Safe(int256 a) internal pure returns (uint256) {
381         require(a >= 0);
382         return uint256(a);
383     }
384 }
385  
386 library SafeMathUint {
387   function toInt256Safe(uint256 a) internal pure returns (int256) {
388     int256 b = int256(a);
389     require(b >= 0);
390     return b;
391   }
392 }
393  
394  
395 interface IUniswapV2Router01 {
396     function factory() external pure returns (address);
397     function WETH() external pure returns (address);
398  
399     function addLiquidity(
400         address tokenA,
401         address tokenB,
402         uint amountADesired,
403         uint amountBDesired,
404         uint amountAMin,
405         uint amountBMin,
406         address to,
407         uint deadline
408     ) external returns (uint amountA, uint amountB, uint liquidity);
409     function addLiquidityETH(
410         address token,
411         uint amountTokenDesired,
412         uint amountTokenMin,
413         uint amountETHMin,
414         address to,
415         uint deadline
416     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
417     function removeLiquidity(
418         address tokenA,
419         address tokenB,
420         uint liquidity,
421         uint amountAMin,
422         uint amountBMin,
423         address to,
424         uint deadline
425     ) external returns (uint amountA, uint amountB);
426     function removeLiquidityETH(
427         address token,
428         uint liquidity,
429         uint amountTokenMin,
430         uint amountETHMin,
431         address to,
432         uint deadline
433     ) external returns (uint amountToken, uint amountETH);
434     function removeLiquidityWithPermit(
435         address tokenA,
436         address tokenB,
437         uint liquidity,
438         uint amountAMin,
439         uint amountBMin,
440         address to,
441         uint deadline,
442         bool approveMax, uint8 v, bytes32 r, bytes32 s
443     ) external returns (uint amountA, uint amountB);
444     function removeLiquidityETHWithPermit(
445         address token,
446         uint liquidity,
447         uint amountTokenMin,
448         uint amountETHMin,
449         address to,
450         uint deadline,
451         bool approveMax, uint8 v, bytes32 r, bytes32 s
452     ) external returns (uint amountToken, uint amountETH);
453     function swapExactTokensForTokens(
454         uint amountIn,
455         uint amountOutMin,
456         address[] calldata path,
457         address to,
458         uint deadline
459     ) external returns (uint[] memory amounts);
460     function swapTokensForExactTokens(
461         uint amountOut,
462         uint amountInMax,
463         address[] calldata path,
464         address to,
465         uint deadline
466     ) external returns (uint[] memory amounts);
467     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
468         external
469         payable
470         returns (uint[] memory amounts);
471     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
472         external
473         returns (uint[] memory amounts);
474     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
475         external
476         returns (uint[] memory amounts);
477     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
478         external
479         payable
480         returns (uint[] memory amounts);
481  
482     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
483     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
484     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
485     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
486     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
487 }
488  
489 interface IUniswapV2Router02 is IUniswapV2Router01 {
490     function removeLiquidityETHSupportingFeeOnTransferTokens(
491         address token,
492         uint liquidity,
493         uint amountTokenMin,
494         uint amountETHMin,
495         address to,
496         uint deadline
497     ) external returns (uint amountETH);
498     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
499         address token,
500         uint liquidity,
501         uint amountTokenMin,
502         uint amountETHMin,
503         address to,
504         uint deadline,
505         bool approveMax, uint8 v, bytes32 r, bytes32 s
506     ) external returns (uint amountETH);
507  
508     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
509         uint amountIn,
510         uint amountOutMin,
511         address[] calldata path,
512         address to,
513         uint deadline
514     ) external;
515     function swapExactETHForTokensSupportingFeeOnTransferTokens(
516         uint amountOutMin,
517         address[] calldata path,
518         address to,
519         uint deadline
520     ) external payable;
521     function swapExactTokensForETHSupportingFeeOnTransferTokens(
522         uint amountIn,
523         uint amountOutMin,
524         address[] calldata path,
525         address to,
526         uint deadline
527     ) external;
528 }
529  
530 contract BabylonBee is ERC20, Ownable {
531     using SafeMath for uint256;
532  
533     IUniswapV2Router02 public immutable uniswapV2Router;
534     address public immutable uniswapV2Pair;
535  
536     bool private swapping;
537  
538     address private marketingWallet;
539     address private devWallet;
540  
541     uint256 public maxTransactionAmount;
542     uint256 public swapTokensAtAmount;
543     uint256 public maxWallet;
544  
545     bool public limitsInEffect = true;
546     bool public tradingActive = false;
547     bool public swapEnabled = false;
548  
549      // Anti-bot and anti-whale mappings and variables
550     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
551  
552     // Seller Map
553     mapping (address => uint256) private _holderFirstBuyTimestamp;
554  
555     // Blacklist Map
556     mapping (address => bool) private _blacklist;
557     bool public transferDelayEnabled = true;
558  
559     uint256 public buyTotalFees;
560     uint256 public buyMarketingFee;
561     uint256 public buyLiquidityFee;
562     uint256 public buyDevFee;
563  
564     uint256 public sellTotalFees;
565     uint256 public sellMarketingFee;
566     uint256 public sellLiquidityFee;
567     uint256 public sellDevFee;
568  
569     uint256 public tokensForMarketing;
570     uint256 public tokensForLiquidity;
571     uint256 public tokensForDev;
572  
573     // block number of opened trading
574     uint256 launchedAt;
575  
576     /******************/
577  
578     // exclude from fees and max transaction amount
579     mapping (address => bool) private _isExcludedFromFees;
580     mapping (address => bool) public _isExcludedMaxTransactionAmount;
581  
582     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
583     // could be subject to a maximum transfer amount
584     mapping (address => bool) public automatedMarketMakerPairs;
585  
586     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
587  
588     event ExcludeFromFees(address indexed account, bool isExcluded);
589  
590     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
591  
592     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
593  
594     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
595  
596     event SwapAndLiquify(
597         uint256 tokensSwapped,
598         uint256 ethReceived,
599         uint256 tokensIntoLiquidity
600     );
601  
602     event AutoNukeLP();
603  
604     event ManualNukeLP();
605  
606     constructor() ERC20("Babylon Bee", "BEE") {
607  
608         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
609  
610         excludeFromMaxTransaction(address(_uniswapV2Router), true);
611         uniswapV2Router = _uniswapV2Router;
612  
613         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
614         excludeFromMaxTransaction(address(uniswapV2Pair), true);
615         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
616  
617         uint256 _buyMarketingFee = 10;
618         uint256 _buyLiquidityFee = 0;
619         uint256 _buyDevFee = 0;
620  
621         uint256 _sellMarketingFee = 25;
622         uint256 _sellLiquidityFee = 0;
623         uint256 _sellDevFee = 0;
624  
625         uint256 decimals = 18;
626         uint256 totalSupply = 44000000000 * (10 ** decimals);
627 
628 
629  
630         maxTransactionAmount = totalSupply * 20 / 1000; // 2.0%
631         maxWallet = totalSupply * 20 / 1000; // 2.0% 
632         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05%
633  
634         buyMarketingFee = _buyMarketingFee;
635         buyLiquidityFee = _buyLiquidityFee;
636         buyDevFee = _buyDevFee;
637         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
638  
639         sellMarketingFee = _sellMarketingFee;
640         sellLiquidityFee = _sellLiquidityFee;
641         sellDevFee = _sellDevFee;
642         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
643  
644         marketingWallet = address(0x54c0558619cE262B3e0a76e945b3b16EC7eea05F);
645         devWallet = address(0x54c0558619cE262B3e0a76e945b3b16EC7eea05F);
646  
647         // exclude from paying fees or having max transaction amount
648         excludeFromFees(owner(), true);
649         excludeFromFees(address(this), true);
650         excludeFromFees(address(0xdead), true);
651         excludeFromFees(address(marketingWallet), true);
652  
653         excludeFromMaxTransaction(owner(), true);
654         excludeFromMaxTransaction(address(this), true);
655         excludeFromMaxTransaction(address(0xdead), true);
656         excludeFromMaxTransaction(address(devWallet), true);
657         excludeFromMaxTransaction(address(marketingWallet), true);
658  
659         /*
660             _mint is an internal function in ERC20.sol that is only called here,
661             and CANNOT be called ever again
662         */
663         _mint(msg.sender, totalSupply);
664     }
665  
666     receive() external payable {
667  
668     }
669  
670     // once enabled, can never be turned off
671     function enableTrading() external onlyOwner {
672         tradingActive = true;
673         swapEnabled = true;
674         launchedAt = block.number;
675     }
676  
677     // remove limits after token is stable
678     function removeLimits() external onlyOwner returns (bool){
679         limitsInEffect = false;
680         return true;
681     }
682  
683     // disable Transfer delay - cannot be reenabled
684     function disableTransferDelay() external onlyOwner returns (bool){
685         transferDelayEnabled = false;
686         return true;
687     }
688  
689      // change the minimum amount of tokens to sell from fees
690     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
691         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
692         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
693         swapTokensAtAmount = newAmount;
694         return true;
695     }
696  
697     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
698         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
699         maxTransactionAmount = newNum * (10**18);
700     }
701  
702     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
703         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
704         maxWallet = newNum * (10**18);
705     }
706  
707     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
708         _isExcludedMaxTransactionAmount[updAds] = isEx;
709     }
710 
711     function updateBuyFees(
712         uint256 _devFee,
713         uint256 _liquidityFee,
714         uint256 _marketingFee
715     ) external onlyOwner {
716         buyDevFee = _devFee;
717         buyLiquidityFee = _liquidityFee;
718         buyMarketingFee = _marketingFee;
719         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
720     }
721 
722     function updateSellFees(
723         uint256 _devFee,
724         uint256 _liquidityFee,
725         uint256 _marketingFee
726     ) external onlyOwner {
727         sellDevFee = _devFee;
728         sellLiquidityFee = _liquidityFee;
729         sellMarketingFee = _marketingFee;
730         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
731     }
732  
733     // only use to disable contract sales if absolutely necessary (emergency use only)
734     function updateSwapEnabled(bool enabled) external onlyOwner(){
735         swapEnabled = enabled;
736     }
737  
738     function excludeFromFees(address account, bool excluded) public onlyOwner {
739         _isExcludedFromFees[account] = excluded;
740         emit ExcludeFromFees(account, excluded);
741     }
742  
743     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
744         _blacklist[account] = isBlacklisted;
745     }
746  
747     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
748         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
749  
750         _setAutomatedMarketMakerPair(pair, value);
751     }
752  
753     function _setAutomatedMarketMakerPair(address pair, bool value) private {
754         automatedMarketMakerPairs[pair] = value;
755  
756         emit SetAutomatedMarketMakerPair(pair, value);
757     }
758  
759     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
760         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
761         marketingWallet = newMarketingWallet;
762     }
763  
764     function updateDevWallet(address newWallet) external onlyOwner {
765         emit devWalletUpdated(newWallet, devWallet);
766         devWallet = newWallet;
767     }
768  
769  
770     function isExcludedFromFees(address account) public view returns(bool) {
771         return _isExcludedFromFees[account];
772     }
773  
774     function _transfer(
775         address from,
776         address to,
777         uint256 amount
778     ) internal override {
779         require(from != address(0), "ERC20: transfer from the zero address");
780         require(to != address(0), "ERC20: transfer to the zero address");
781         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
782          if(amount == 0) {
783             super._transfer(from, to, 0);
784             return;
785         }
786  
787         if(limitsInEffect){
788             if (
789                 from != owner() &&
790                 to != owner() &&
791                 to != address(0) &&
792                 to != address(0xdead) &&
793                 !swapping
794             ){
795                 if(!tradingActive){
796                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
797                 }
798  
799                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
800                 if (transferDelayEnabled){
801                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
802                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
803                         _holderLastTransferTimestamp[tx.origin] = block.number;
804                     }
805                 }
806  
807                 //when buy
808                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
809                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
810                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
811                 }
812  
813                 //when sell
814                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
815                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
816                 }
817                 else if(!_isExcludedMaxTransactionAmount[to]){
818                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
819                 }
820             }
821         }
822  
823         uint256 contractTokenBalance = balanceOf(address(this));
824  
825         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
826  
827         if( 
828             canSwap &&
829             swapEnabled &&
830             !swapping &&
831             !automatedMarketMakerPairs[from] &&
832             !_isExcludedFromFees[from] &&
833             !_isExcludedFromFees[to]
834         ) {
835             swapping = true;
836  
837             swapBack();
838  
839             swapping = false;
840         }
841  
842         bool takeFee = !swapping;
843  
844         // if any account belongs to _isExcludedFromFee account then remove the fee
845         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
846             takeFee = false;
847         }
848  
849         uint256 fees = 0;
850         // only take fees on buys/sells, do not take on wallet transfers
851         if(takeFee){
852             // on sell
853             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
854                 fees = amount.mul(sellTotalFees).div(100);
855                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
856                 tokensForDev += fees * sellDevFee / sellTotalFees;
857                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
858             }
859             // on buy
860             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
861                 fees = amount.mul(buyTotalFees).div(100);
862                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
863                 tokensForDev += fees * buyDevFee / buyTotalFees;
864                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
865             }
866  
867             if(fees > 0){    
868                 super._transfer(from, address(this), fees);
869             }
870  
871             amount -= fees;
872         }
873  
874         super._transfer(from, to, amount);
875     }
876  
877     function swapTokensForEth(uint256 tokenAmount) private {
878  
879         // generate the uniswap pair path of token -> weth
880         address[] memory path = new address[](2);
881         path[0] = address(this);
882         path[1] = uniswapV2Router.WETH();
883  
884         _approve(address(this), address(uniswapV2Router), tokenAmount);
885  
886         // make the swap
887         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
888             tokenAmount,
889             0, // accept any amount of ETH
890             path,
891             address(this),
892             block.timestamp
893         );
894  
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
907             address(this),
908             block.timestamp
909         );
910     }
911  
912     function swapBack() private {
913         uint256 contractBalance = balanceOf(address(this));
914         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
915         bool success;
916  
917         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
918  
919         if(contractBalance > swapTokensAtAmount * 20){
920           contractBalance = swapTokensAtAmount * 20;
921         }
922  
923         // Halve the amount of liquidity tokens
924         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
925         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
926  
927         uint256 initialETHBalance = address(this).balance;
928  
929         swapTokensForEth(amountToSwapForETH); 
930  
931         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
932  
933         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
934         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
935         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
936  
937  
938         tokensForLiquidity = 0;
939         tokensForMarketing = 0;
940         tokensForDev = 0;
941  
942         (success,) = address(devWallet).call{value: ethForDev}("");
943  
944         if(liquidityTokens > 0 && ethForLiquidity > 0){
945             addLiquidity(liquidityTokens, ethForLiquidity);
946             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
947         }
948  
949         (success,) = address(marketingWallet).call{value: address(this).balance}("");
950     }
951 }