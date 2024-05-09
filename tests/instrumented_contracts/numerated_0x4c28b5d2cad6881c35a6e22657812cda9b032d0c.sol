1 // TELEGRAM: https://t.me/AIPEPE_Portal
2 // TWITTER: https://twitter.com/AI_PEPE_TOKEN
3 // WEB: http://ai-pepe.lol/
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity 0.8.20;
8  
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13  
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18  
19 interface IUniswapV2Pair {
20     event Approval(address indexed owner, address indexed spender, uint value);
21     event Transfer(address indexed from, address indexed to, uint value);
22  
23     function name() external pure returns (string memory);
24     function symbol() external pure returns (string memory);
25     function decimals() external pure returns (uint8);
26     function totalSupply() external view returns (uint);
27     function balanceOf(address owner) external view returns (uint);
28     function allowance(address owner, address spender) external view returns (uint);
29  
30     function approve(address spender, uint value) external returns (bool);
31     function transfer(address to, uint value) external returns (bool);
32     function transferFrom(address from, address to, uint value) external returns (bool);
33  
34     function DOMAIN_SEPARATOR() external view returns (bytes32);
35     function PERMIT_TYPEHASH() external pure returns (bytes32);
36     function nonces(address owner) external view returns (uint);
37  
38     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
39  
40     event Mint(address indexed sender, uint amount0, uint amount1);
41     event Swap(
42         address indexed sender,
43         uint amount0In,
44         uint amount1In,
45         uint amount0Out,
46         uint amount1Out,
47         address indexed to
48     );
49     event Sync(uint112 reserve0, uint112 reserve1);
50  
51     function MINIMUM_LIQUIDITY() external pure returns (uint);
52     function factory() external view returns (address);
53     function token0() external view returns (address);
54     function token1() external view returns (address);
55     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
56     function price0CumulativeLast() external view returns (uint);
57     function price1CumulativeLast() external view returns (uint);
58     function kLast() external view returns (uint);
59  
60     function mint(address to) external returns (uint liquidity);
61     function burn(address to) external returns (uint amount0, uint amount1);
62     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
63     function skim(address to) external;
64     function sync() external;
65  
66     function initialize(address, address) external;
67 }
68  
69 interface IUniswapV2Factory {
70     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
71  
72     function feeTo() external view returns (address);
73     function feeToSetter() external view returns (address);
74  
75     function getPair(address tokenA, address tokenB) external view returns (address pair);
76     function allPairs(uint) external view returns (address pair);
77     function allPairsLength() external view returns (uint);
78  
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80  
81     function setFeeTo(address) external;
82     function setFeeToSetter(address) external;
83 }
84  
85 interface IERC20 {
86 
87     function totalSupply() external view returns (uint256);
88 
89     function balanceOf(address account) external view returns (uint256);
90 
91     function transfer(address recipient, uint256 amount) external returns (bool);
92 
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     function transferFrom(
98         address sender,
99         address recipient,
100         uint256 amount
101     ) external returns (bool);
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107  
108 interface IERC20Metadata is IERC20 {
109 
110     function name() external view returns (string memory);
111 
112     function symbol() external view returns (string memory);
113 
114     function decimals() external view returns (uint8);
115 }
116  
117  
118 contract ERC20 is Context, IERC20, IERC20Metadata {
119     using SafeMath for uint256;
120  
121     mapping(address => uint256) private _balances;
122  
123     mapping(address => mapping(address => uint256)) private _allowances;
124  
125     uint256 private _totalSupply;
126  
127     string private _name;
128     string private _symbol;
129 
130     constructor(string memory name_, string memory symbol_) {
131         _name = name_;
132         _symbol = symbol_;
133     }
134 
135     function name() public view virtual override returns (string memory) {
136         return _name;
137     }
138 
139     function symbol() public view virtual override returns (string memory) {
140         return _symbol;
141     }
142 
143     function decimals() public view virtual override returns (uint8) {
144         return 18;
145     }
146 
147     function totalSupply() public view virtual override returns (uint256) {
148         return _totalSupply;
149     }
150 
151     function balanceOf(address account) public view virtual override returns (uint256) {
152         return _balances[account];
153     }
154 
155     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
156         _transfer(_msgSender(), recipient, amount);
157         return true;
158     }
159 
160     function allowance(address owner, address spender) public view virtual override returns (uint256) {
161         return _allowances[owner][spender];
162     }
163 
164     function approve(address spender, uint256 amount) public virtual override returns (bool) {
165         _approve(_msgSender(), spender, amount);
166         return true;
167     }
168 
169     function transferFrom(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) public virtual override returns (bool) {
174         _transfer(sender, recipient, amount);
175         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
176         return true;
177     }
178 
179     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
180         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
181         return true;
182     }
183 
184     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
185         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
186         return true;
187     }
188 
189     function _transfer(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) internal virtual {
194         require(sender != address(0), "ERC20: transfer from the zero address");
195         require(recipient != address(0), "ERC20: transfer to the zero address");
196  
197         _beforeTokenTransfer(sender, recipient, amount);
198  
199         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
200         _balances[recipient] = _balances[recipient].add(amount);
201         emit Transfer(sender, recipient, amount);
202     }
203 
204     function _mint(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: mint to the zero address");
206  
207         _beforeTokenTransfer(address(0), account, amount);
208  
209         _totalSupply = _totalSupply.add(amount);
210         _balances[account] = _balances[account].add(amount);
211         emit Transfer(address(0), account, amount);
212     }
213 
214     function _burn(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: burn from the zero address");
216  
217         _beforeTokenTransfer(account, address(0), amount);
218  
219         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
220         _totalSupply = _totalSupply.sub(amount);
221         emit Transfer(account, address(0), amount);
222     }
223 
224     function _approve(
225         address owner,
226         address spender,
227         uint256 amount
228     ) internal virtual {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231  
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _beforeTokenTransfer(
237         address from,
238         address to,
239         uint256 amount
240     ) internal virtual {}
241 }
242  
243 library SafeMath {
244 
245     function add(uint256 a, uint256 b) internal pure returns (uint256) {
246         uint256 c = a + b;
247         require(c >= a, "SafeMath: addition overflow");
248  
249         return c;
250     }
251 
252     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
253         return sub(a, b, "SafeMath: subtraction overflow");
254     }
255 
256     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b <= a, errorMessage);
258         uint256 c = a - b;
259  
260         return c;
261     }
262 
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264 
265         if (a == 0) {
266             return 0;
267         }
268  
269         uint256 c = a * b;
270         require(c / a == b, "SafeMath: multiplication overflow");
271  
272         return c;
273     }
274 
275     function div(uint256 a, uint256 b) internal pure returns (uint256) {
276         return div(a, b, "SafeMath: division by zero");
277     }
278 
279     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b > 0, errorMessage);
281         uint256 c = a / b;
282         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283  
284         return c;
285     }
286 
287     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
288         return mod(a, b, "SafeMath: modulo by zero");
289     }
290 
291     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b != 0, errorMessage);
293         return a % b;
294     }
295 }
296  
297 contract Ownable is Context {
298     address private _owner;
299  
300     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
301 
302     constructor () {
303         address msgSender = _msgSender();
304         _owner = msgSender;
305         emit OwnershipTransferred(address(0), msgSender);
306     }
307 
308     function owner() public view returns (address) {
309         return _owner;
310     }
311 
312     modifier onlyOwner() {
313         require(_owner == _msgSender(), "Ownable: caller is not the owner");
314         _;
315     }
316 
317     function renounceOwnership() public virtual onlyOwner {
318         emit OwnershipTransferred(_owner, address(0));
319         _owner = address(0);
320     }
321 
322     function transferOwnership(address newOwner) public virtual onlyOwner {
323         require(newOwner != address(0), "Ownable: new owner is the zero address");
324         emit OwnershipTransferred(_owner, newOwner);
325         _owner = newOwner;
326     }
327 }
328  
329  
330  
331 library SafeMathInt {
332     int256 private constant MIN_INT256 = int256(1) << 255;
333     int256 private constant MAX_INT256 = ~(int256(1) << 255);
334 
335     function mul(int256 a, int256 b) internal pure returns (int256) {
336         int256 c = a * b;
337  
338         // Detect overflow when multiplying MIN_INT256 with -1
339         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
340         require((b == 0) || (c / b == a));
341         return c;
342     }
343 
344     function div(int256 a, int256 b) internal pure returns (int256) {
345         // Prevent overflow when dividing MIN_INT256 by -1
346         require(b != -1 || a != MIN_INT256);
347  
348         // Solidity already throws when dividing by 0.
349         return a / b;
350     }
351 
352     function sub(int256 a, int256 b) internal pure returns (int256) {
353         int256 c = a - b;
354         require((b >= 0 && c <= a) || (b < 0 && c > a));
355         return c;
356     }
357 
358     function add(int256 a, int256 b) internal pure returns (int256) {
359         int256 c = a + b;
360         require((b >= 0 && c >= a) || (b < 0 && c < a));
361         return c;
362     }
363 
364     function abs(int256 a) internal pure returns (int256) {
365         require(a != MIN_INT256);
366         return a < 0 ? -a : a;
367     }
368  
369  
370     function toUint256Safe(int256 a) internal pure returns (uint256) {
371         require(a >= 0);
372         return uint256(a);
373     }
374 }
375  
376 library SafeMathUint {
377   function toInt256Safe(uint256 a) internal pure returns (int256) {
378     int256 b = int256(a);
379     require(b >= 0);
380     return b;
381   }
382 }
383  
384  
385 interface IUniswapV2Router01 {
386     function factory() external pure returns (address);
387     function WETH() external pure returns (address);
388  
389     function addLiquidity(
390         address tokenA,
391         address tokenB,
392         uint amountADesired,
393         uint amountBDesired,
394         uint amountAMin,
395         uint amountBMin,
396         address to,
397         uint deadline
398     ) external returns (uint amountA, uint amountB, uint liquidity);
399     function addLiquidityETH(
400         address token,
401         uint amountTokenDesired,
402         uint amountTokenMin,
403         uint amountETHMin,
404         address to,
405         uint deadline
406     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
407     function removeLiquidity(
408         address tokenA,
409         address tokenB,
410         uint liquidity,
411         uint amountAMin,
412         uint amountBMin,
413         address to,
414         uint deadline
415     ) external returns (uint amountA, uint amountB);
416     function removeLiquidityETH(
417         address token,
418         uint liquidity,
419         uint amountTokenMin,
420         uint amountETHMin,
421         address to,
422         uint deadline
423     ) external returns (uint amountToken, uint amountETH);
424     function removeLiquidityWithPermit(
425         address tokenA,
426         address tokenB,
427         uint liquidity,
428         uint amountAMin,
429         uint amountBMin,
430         address to,
431         uint deadline,
432         bool approveMax, uint8 v, bytes32 r, bytes32 s
433     ) external returns (uint amountA, uint amountB);
434     function removeLiquidityETHWithPermit(
435         address token,
436         uint liquidity,
437         uint amountTokenMin,
438         uint amountETHMin,
439         address to,
440         uint deadline,
441         bool approveMax, uint8 v, bytes32 r, bytes32 s
442     ) external returns (uint amountToken, uint amountETH);
443     function swapExactTokensForTokens(
444         uint amountIn,
445         uint amountOutMin,
446         address[] calldata path,
447         address to,
448         uint deadline
449     ) external returns (uint[] memory amounts);
450     function swapTokensForExactTokens(
451         uint amountOut,
452         uint amountInMax,
453         address[] calldata path,
454         address to,
455         uint deadline
456     ) external returns (uint[] memory amounts);
457     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
458         external
459         payable
460         returns (uint[] memory amounts);
461     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
462         external
463         returns (uint[] memory amounts);
464     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
465         external
466         returns (uint[] memory amounts);
467     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
468         external
469         payable
470         returns (uint[] memory amounts);
471  
472     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
473     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
474     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
475     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
476     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
477 }
478  
479 interface IUniswapV2Router02 is IUniswapV2Router01 {
480     function removeLiquidityETHSupportingFeeOnTransferTokens(
481         address token,
482         uint liquidity,
483         uint amountTokenMin,
484         uint amountETHMin,
485         address to,
486         uint deadline
487     ) external returns (uint amountETH);
488     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
489         address token,
490         uint liquidity,
491         uint amountTokenMin,
492         uint amountETHMin,
493         address to,
494         uint deadline,
495         bool approveMax, uint8 v, bytes32 r, bytes32 s
496     ) external returns (uint amountETH);
497  
498     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
499         uint amountIn,
500         uint amountOutMin,
501         address[] calldata path,
502         address to,
503         uint deadline
504     ) external;
505     function swapExactETHForTokensSupportingFeeOnTransferTokens(
506         uint amountOutMin,
507         address[] calldata path,
508         address to,
509         uint deadline
510     ) external payable;
511     function swapExactTokensForETHSupportingFeeOnTransferTokens(
512         uint amountIn,
513         uint amountOutMin,
514         address[] calldata path,
515         address to,
516         uint deadline
517     ) external;
518 }
519  
520 contract AIPEPE is ERC20, Ownable {
521 
522     string _name = "AI PEPE";
523     string _symbol = "AIPEPE";
524 
525     using SafeMath for uint256;
526  
527     IUniswapV2Router02 public immutable uniswapV2Router;
528     address public immutable uniswapV2Pair;
529  
530     bool private isSwapping;
531  
532     address private treasuryWallet;
533     address private devWallet;
534  
535     uint256 public maxTx;
536     uint256 public swapTreshold;
537     uint256 public maxWallet;
538  
539     bool public limitsActive = true;
540     bool public tradingLive = false;
541     bool public swapEnabled = true;
542     bool public shouldContractSellAll = false;
543  
544      // Anti-bot and anti-whale mappings and variables
545     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
546  
547     // Seller Map
548     mapping (address => uint256) private _holderFirstBuyTimestamp;
549  
550     // Blacklist Map
551     mapping (address => bool) private _blacklist;
552     bool public transferDelayEnabled = true;
553  
554     uint256 public buyTotalFees;
555     uint256 public buyTreasuryFee;
556     uint256 public buyLiquidityFee;
557     uint256 public buyDevFee;
558  
559     uint256 public sellTotalFees;
560     uint256 public sellTreasuryFee;
561     uint256 public sellLiquidityFee;
562     uint256 public sellDevFee;
563  
564     uint256 public tokensForTreasury;
565     uint256 public tokensForLiquidity;
566     uint256 public tokensForDev;
567  
568     // block number of opened trading
569     uint256 launchedAt;
570  
571     /******************/
572  
573     // exclude from fees and max transaction amount
574     mapping (address => bool) private _isExcludedFromFees;
575     mapping (address => bool) public _isExcludedMaxTransactionAmount;
576  
577     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
578     // could be subject to a maximum transfer amount
579     mapping (address => bool) public automatedMarketMakerPairs;
580  
581     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
582  
583     event ExcludeFromFees(address indexed account, bool isExcluded);
584  
585     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
586  
587     event treasuryWalletUpdated(address indexed newWallet, address indexed oldWallet);
588  
589     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
590  
591     event SwapAndLiquify(
592         uint256 tokensSwapped,
593         uint256 ethReceived,
594         uint256 tokensIntoLiquidity
595     );
596  
597     event AutoNukeLP();
598  
599     event ManualNukeLP();
600  
601     constructor() ERC20(_name, _symbol) {
602  
603         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
604  
605         excludeFromMaxTransaction(address(_uniswapV2Router), true);
606         uniswapV2Router = _uniswapV2Router;
607  
608         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
609         excludeFromMaxTransaction(address(uniswapV2Pair), true);
610         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
611  
612         uint256 _buyTreasuryFee = 27;
613         uint256 _buyLiquidityFee = 0;
614         uint256 _buyDevFee = 0;
615  
616         uint256 _sellTreasuryFee = 88;
617         uint256 _sellLiquidityFee = 0;
618         uint256 _sellDevFee = 0;
619  
620         uint256 totalSupply = 1000000000 * 1e18;
621  
622         maxTx = totalSupply * 20 / 1000; // 2%
623         maxWallet = totalSupply * 20 / 1000; // 2% 
624         swapTreshold = totalSupply * 1 / 1000; // 0.05%
625  
626         buyTreasuryFee = _buyTreasuryFee;
627         buyLiquidityFee = _buyLiquidityFee;
628         buyDevFee = _buyDevFee;
629         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyDevFee;
630  
631         sellTreasuryFee = _sellTreasuryFee;
632         sellLiquidityFee = _sellLiquidityFee;
633         sellDevFee = _sellDevFee;
634         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellDevFee;
635 
636         treasuryWallet = address(0x98C1e9cc83978D8f42ab135df186E2e769889f5e);
637         devWallet = address(0x98C1e9cc83978D8f42ab135df186E2e769889f5e);
638  
639         // exclude from paying fees or having max transaction amount
640         excludeFromFees(owner(), true);
641         excludeFromFees(address(this), true);
642         excludeFromFees(address(0xdead), true);
643         excludeFromFees(address(treasuryWallet), true);
644  
645         excludeFromMaxTransaction(owner(), true);
646         excludeFromMaxTransaction(address(this), true);
647         excludeFromMaxTransaction(address(0xdead), true);
648         excludeFromMaxTransaction(address(devWallet), true);
649         excludeFromMaxTransaction(address(treasuryWallet), true);
650  
651         /*
652             _mint is an internal function in ERC20.sol that is only called here,
653             and CANNOT be called ever again
654         */
655         _mint(msg.sender, totalSupply);
656     }
657  
658     receive() external payable {
659  
660     }
661  
662     // once enabled, can never be turned off
663     function enableTrading() external onlyOwner {
664        
665         tradingLive = true;
666         swapEnabled = true;
667         launchedAt = block.number;
668 
669        
670        
671         
672     }
673  
674     // remove limits after token is stable
675     function removeLimits() external onlyOwner returns (bool){
676         limitsActive = false;
677         return true;
678     }
679  
680     // disable Transfer delay - cannot be reenabled
681     function disableTransferDelay() external onlyOwner returns (bool){
682         transferDelayEnabled = false;
683         return true;
684     }
685 
686     function enableEmptyContract(bool enabled) external onlyOwner{
687         shouldContractSellAll = enabled;
688     }
689  
690      // change the minimum amount of tokens to sell from fees
691     function setSwapTreshold(uint256 newAmount) external onlyOwner returns (bool){
692         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
693         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
694         swapTreshold = newAmount;
695         return true;
696     }
697  
698     function updateTransactionLimits(uint256 _maxTx, uint256 _maxWallet) external onlyOwner {
699         require(_maxTx >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
700         require(_maxWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
701         maxTx = _maxTx * (10**18);
702         maxWallet = _maxWallet * (10**18);
703     }
704  
705     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
706         _isExcludedMaxTransactionAmount[updAds] = isEx;
707     }
708 
709     function setFees(
710         uint256 _devBuyFee,
711         uint256 _liquidityBuyFee,
712         uint256 _treasuryBuyFee,
713         uint256 _devSellFee,
714         uint256 _liquiditySellFee,
715         uint256 _treasurySellFee
716     ) external onlyOwner {
717     
718         buyDevFee = _devBuyFee;
719         buyLiquidityFee = _liquidityBuyFee;
720         buyTreasuryFee = _treasuryBuyFee;
721         buyTotalFees = buyDevFee + buyLiquidityFee + buyTreasuryFee;
722         sellDevFee = _devSellFee;
723         sellLiquidityFee = _liquiditySellFee;
724         sellTreasuryFee = _treasurySellFee;
725         sellTotalFees = sellDevFee + sellLiquidityFee + sellTreasuryFee;
726         require(buyTotalFees <= 30 && sellTotalFees <= 30, "Fees cannot be higher then 30%");
727     }
728 
729     // only use to disable contract sales if absolutely necessary (emergency use only)
730     function updateContractSellEnabled(bool enabled) external onlyOwner(){
731         swapEnabled = enabled;
732     }
733  
734     function excludeFromFees(address account, bool excluded) public onlyOwner {
735         _isExcludedFromFees[account] = excluded;
736         emit ExcludeFromFees(account, excluded);
737     }
738  
739     function blacklist(address account, bool isBlacklisted) public onlyOwner {
740         _blacklist[account] = isBlacklisted;
741     }
742  
743     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
744         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
745  
746         _setAutomatedMarketMakerPair(pair, value);
747     }
748  
749     function _setAutomatedMarketMakerPair(address pair, bool value) private {
750         automatedMarketMakerPairs[pair] = value;
751  
752         emit SetAutomatedMarketMakerPair(pair, value);
753     }
754 
755     function updateFeeRecivers(address newTreasuryWallet, address newDevWallet) external onlyOwner{
756         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
757         treasuryWallet = newTreasuryWallet;
758         emit devWalletUpdated(newDevWallet, devWallet);
759         devWallet = newDevWallet;
760     }
761 
762  
763   
764     function isExcludedFromFees(address account) public view returns(bool) {
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
775         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
776         
777         if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
778         
779     }
780         
781         
782          if(amount == 0) {
783             super._transfer(from, to, 0);
784             return;
785         }
786  
787         if(limitsActive){
788             if (
789                 from != owner() &&
790                 to != owner() &&
791                 to != address(0) &&
792                 to != address(0xdead) &&
793                 !isSwapping
794             ){
795                 if(!tradingLive){
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
809                         require(amount <= maxTx, "Buy transfer amount exceeds the maxTransactionAmount.");
810                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
811                 }
812  
813                 //when sell
814                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
815                         require(amount <= maxTx, "Sell transfer amount exceeds the maxTransactionAmount.");
816                 }
817                 else if(!_isExcludedMaxTransactionAmount[to]){
818                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
819                 }
820             }
821         }
822  
823         uint256 contractTokenBalance = balanceOf(address(this));
824  
825         bool canSwap = contractTokenBalance >= swapTreshold;
826  
827         if( 
828             canSwap &&
829             swapEnabled &&
830             !isSwapping &&
831             !automatedMarketMakerPairs[from] &&
832             !_isExcludedFromFees[from] &&
833             !_isExcludedFromFees[to]
834         ) {
835             isSwapping = true;
836  
837             swapBack();
838  
839             isSwapping = false;
840         }
841  
842         bool takeFee = !isSwapping;
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
857                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
858             }
859             // on buy
860             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
861                 fees = amount.mul(buyTotalFees).div(100);
862                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
863                 tokensForDev += fees * buyDevFee / buyTotalFees;
864                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
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
914         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury + tokensForDev;
915         bool success;
916  
917         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
918  
919         if(shouldContractSellAll == false){
920             if(contractBalance > swapTreshold * 20){
921                 contractBalance = swapTreshold * 20;
922             }
923         }else{
924             contractBalance = balanceOf(address(this));
925         }
926         
927  
928         // Halve the amount of liquidity tokens
929         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
930         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
931  
932         uint256 initialETHBalance = address(this).balance;
933  
934         swapTokensForEth(amountToSwapForETH); 
935  
936         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
937  
938         uint256 ethForMarketing = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
939         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
940         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
941  
942  
943         tokensForLiquidity = 0;
944         tokensForTreasury = 0;
945         tokensForDev = 0;
946  
947         (success,) = address(devWallet).call{value: ethForDev}("");
948  
949         if(liquidityTokens > 0 && ethForLiquidity > 0){
950             addLiquidity(liquidityTokens, ethForLiquidity);
951             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
952         }
953  
954         (success,) = address(treasuryWallet).call{value: address(this).balance}("");
955     }
956 }