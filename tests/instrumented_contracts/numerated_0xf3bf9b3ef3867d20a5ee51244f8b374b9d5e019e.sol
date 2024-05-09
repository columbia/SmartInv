1 /*
2 Telegram: https://t.me/EdgefolioETH
3 Twitter: https://twitter.com/EdgefolioETH
4 Website: https://EdgefolioETH.com/
5 */
6 
7 // SPDX-License-Identifier: Unlicensed                                                                         
8  
9 pragma solidity 0.8.21;
10  
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15  
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21  
22 interface IUniswapV2Pair {
23     event Approval(address indexed owner, address indexed spender, uint value);
24     event Transfer(address indexed from, address indexed to, uint value);
25  
26     function name() external pure returns (string memory);
27     function symbol() external pure returns (string memory);
28     function decimals() external pure returns (uint8);
29     function totalSupply() external view returns (uint);
30     function balanceOf(address owner) external view returns (uint);
31     function allowance(address owner, address spender) external view returns (uint);
32  
33     function approve(address spender, uint value) external returns (bool);
34     function transfer(address to, uint value) external returns (bool);
35     function transferFrom(address from, address to, uint value) external returns (bool);
36  
37     function DOMAIN_SEPARATOR() external view returns (bytes32);
38     function PERMIT_TYPEHASH() external pure returns (bytes32);
39     function nonces(address owner) external view returns (uint);
40  
41     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
42  
43     event Mint(address indexed sender, uint amount0, uint amount1);
44     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
45     event Swap(
46         address indexed sender,
47         uint amount0In,
48         uint amount1In,
49         uint amount0Out,
50         uint amount1Out,
51         address indexed to
52     );
53     event Sync(uint112 reserve0, uint112 reserve1);
54  
55     function MINIMUM_LIQUIDITY() external pure returns (uint);
56     function factory() external view returns (address);
57     function token0() external view returns (address);
58     function token1() external view returns (address);
59     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
60     function price0CumulativeLast() external view returns (uint);
61     function price1CumulativeLast() external view returns (uint);
62     function kLast() external view returns (uint);
63  
64     function mint(address to) external returns (uint liquidity);
65     function burn(address to) external returns (uint amount0, uint amount1);
66     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
67     function skim(address to) external;
68     function sync() external;
69  
70     function initialize(address, address) external;
71 }
72  
73 interface IUniswapV2Factory {
74     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
75  
76     function feeTo() external view returns (address);
77     function feeToSetter() external view returns (address);
78  
79     function getPair(address tokenA, address tokenB) external view returns (address pair);
80     function allPairs(uint) external view returns (address pair);
81     function allPairsLength() external view returns (uint);
82  
83     function createPair(address tokenA, address tokenB) external returns (address pair);
84  
85     function setFeeTo(address) external;
86     function setFeeToSetter(address) external;
87 }
88  
89 interface IERC20 {
90 
91     function totalSupply() external view returns (uint256);
92 
93     function balanceOf(address account) external view returns (uint256);
94 
95     function transfer(address recipient, uint256 amount) external returns (bool);
96 
97     function allowance(address owner, address spender) external view returns (uint256);
98 
99     function approve(address spender, uint256 amount) external returns (bool);
100 
101     function transferFrom(
102         address sender,
103         address recipient,
104         uint256 amount
105     ) external returns (bool);
106 
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111  
112 interface IERC20Metadata is IERC20 {
113 
114     function name() external view returns (string memory);
115 
116     function symbol() external view returns (string memory);
117 
118     function decimals() external view returns (uint8);
119 }
120  
121  
122 contract ERC20 is Context, IERC20, IERC20Metadata {
123     using SafeMath for uint256;
124  
125     mapping(address => uint256) private _balances;
126  
127     mapping(address => mapping(address => uint256)) private _allowances;
128  
129     uint256 private _totalSupply;
130  
131     string private _name;
132     string private _symbol;
133 
134     constructor(string memory name_, string memory symbol_) {
135         _name = name_;
136         _symbol = symbol_;
137     }
138 
139     function name() public view virtual override returns (string memory) {
140         return _name;
141     }
142 
143     function symbol() public view virtual override returns (string memory) {
144         return _symbol;
145     }
146 
147     function decimals() public view virtual override returns (uint8) {
148         return 18;
149     }
150 
151     function totalSupply() public view virtual override returns (uint256) {
152         return _totalSupply;
153     }
154 
155     function balanceOf(address account) public view virtual override returns (uint256) {
156         return _balances[account];
157     }
158 
159     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
160         _transfer(_msgSender(), recipient, amount);
161         return true;
162     }
163 
164     function allowance(address owner, address spender) public view virtual override returns (uint256) {
165         return _allowances[owner][spender];
166     }
167 
168     function approve(address spender, uint256 amount) public virtual override returns (bool) {
169         _approve(_msgSender(), spender, amount);
170         return true;
171     }
172 
173     function transferFrom(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) public virtual override returns (bool) {
178         _transfer(sender, recipient, amount);
179         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
180         return true;
181     }
182 
183     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
184         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
185         return true;
186     }
187 
188     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
189         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
190         return true;
191     }
192 
193     function _transfer(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) internal virtual {
198         require(sender != address(0), "ERC20: transfer from the zero address");
199         require(recipient != address(0), "ERC20: transfer to the zero address");
200  
201         _beforeTokenTransfer(sender, recipient, amount);
202  
203         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
204         _balances[recipient] = _balances[recipient].add(amount);
205         emit Transfer(sender, recipient, amount);
206     }
207 
208     function _mint(address account, uint256 amount) internal virtual {
209         require(account != address(0), "ERC20: mint to the zero address");
210  
211         _beforeTokenTransfer(address(0), account, amount);
212  
213         _totalSupply = _totalSupply.add(amount);
214         _balances[account] = _balances[account].add(amount);
215         emit Transfer(address(0), account, amount);
216     }
217 
218     function _burn(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: burn from the zero address");
220  
221         _beforeTokenTransfer(account, address(0), amount);
222  
223         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
224         _totalSupply = _totalSupply.sub(amount);
225         emit Transfer(account, address(0), amount);
226     }
227 
228     function _approve(
229         address owner,
230         address spender,
231         uint256 amount
232     ) internal virtual {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235  
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 
240     function _beforeTokenTransfer(
241         address from,
242         address to,
243         uint256 amount
244     ) internal virtual {}
245 }
246  
247 library SafeMath {
248 
249     function add(uint256 a, uint256 b) internal pure returns (uint256) {
250         uint256 c = a + b;
251         require(c >= a, "SafeMath: addition overflow");
252  
253         return c;
254     }
255 
256     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
257         return sub(a, b, "SafeMath: subtraction overflow");
258     }
259 
260     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b <= a, errorMessage);
262         uint256 c = a - b;
263  
264         return c;
265     }
266 
267     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
268         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
269         // benefit is lost if 'b' is also tested.
270         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
271         if (a == 0) {
272             return 0;
273         }
274  
275         uint256 c = a * b;
276         require(c / a == b, "SafeMath: multiplication overflow");
277  
278         return c;
279     }
280 
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         return div(a, b, "SafeMath: division by zero");
283     }
284 
285     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b > 0, errorMessage);
287         uint256 c = a / b;
288         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
289  
290         return c;
291     }
292 
293     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
294         return mod(a, b, "SafeMath: modulo by zero");
295     }
296 
297     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b != 0, errorMessage);
299         return a % b;
300     }
301 }
302  
303 contract Ownable is Context {
304     address private _owner;
305  
306     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
307  
308     constructor () {
309         address msgSender = _msgSender();
310         _owner = msgSender;
311         emit OwnershipTransferred(address(0), msgSender);
312     }
313 
314     function owner() public view returns (address) {
315         return _owner;
316     }
317  
318     modifier onlyOwner() {
319         require(_owner == _msgSender(), "Ownable: caller is not the owner");
320         _;
321     }
322 
323     function renounceOwnership() public virtual onlyOwner {
324         emit OwnershipTransferred(_owner, address(0));
325         _owner = address(0);
326     }
327 
328     function transferOwnership(address newOwner) public virtual onlyOwner {
329         require(newOwner != address(0), "Ownable: new owner is the zero address");
330         emit OwnershipTransferred(_owner, newOwner);
331         _owner = newOwner;
332     }
333 }
334  
335  
336  
337 library SafeMathInt {
338     int256 private constant MIN_INT256 = int256(1) << 255;
339     int256 private constant MAX_INT256 = ~(int256(1) << 255);
340 
341     function mul(int256 a, int256 b) internal pure returns (int256) {
342         int256 c = a * b;
343  
344         // Detect overflow when multiplying MIN_INT256 with -1
345         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
346         require((b == 0) || (c / b == a));
347         return c;
348     }
349 
350     function div(int256 a, int256 b) internal pure returns (int256) {
351         // Prevent overflow when dividing MIN_INT256 by -1
352         require(b != -1 || a != MIN_INT256);
353  
354         // Solidity already throws when dividing by 0.
355         return a / b;
356     }
357 
358     function sub(int256 a, int256 b) internal pure returns (int256) {
359         int256 c = a - b;
360         require((b >= 0 && c <= a) || (b < 0 && c > a));
361         return c;
362     }
363 
364     function add(int256 a, int256 b) internal pure returns (int256) {
365         int256 c = a + b;
366         require((b >= 0 && c >= a) || (b < 0 && c < a));
367         return c;
368     }
369 
370     function abs(int256 a) internal pure returns (int256) {
371         require(a != MIN_INT256);
372         return a < 0 ? -a : a;
373     }
374  
375  
376     function toUint256Safe(int256 a) internal pure returns (uint256) {
377         require(a >= 0);
378         return uint256(a);
379     }
380 }
381  
382 library SafeMathUint {
383   function toInt256Safe(uint256 a) internal pure returns (int256) {
384     int256 b = int256(a);
385     require(b >= 0);
386     return b;
387   }
388 }
389  
390  
391 interface IUniswapV2Router01 {
392     function factory() external pure returns (address);
393     function WETH() external pure returns (address);
394  
395     function addLiquidity(
396         address tokenA,
397         address tokenB,
398         uint amountADesired,
399         uint amountBDesired,
400         uint amountAMin,
401         uint amountBMin,
402         address to,
403         uint deadline
404     ) external returns (uint amountA, uint amountB, uint liquidity);
405     function addLiquidityETH(
406         address token,
407         uint amountTokenDesired,
408         uint amountTokenMin,
409         uint amountETHMin,
410         address to,
411         uint deadline
412     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
413     function removeLiquidity(
414         address tokenA,
415         address tokenB,
416         uint liquidity,
417         uint amountAMin,
418         uint amountBMin,
419         address to,
420         uint deadline
421     ) external returns (uint amountA, uint amountB);
422     function removeLiquidityETH(
423         address token,
424         uint liquidity,
425         uint amountTokenMin,
426         uint amountETHMin,
427         address to,
428         uint deadline
429     ) external returns (uint amountToken, uint amountETH);
430     function removeLiquidityWithPermit(
431         address tokenA,
432         address tokenB,
433         uint liquidity,
434         uint amountAMin,
435         uint amountBMin,
436         address to,
437         uint deadline,
438         bool approveMax, uint8 v, bytes32 r, bytes32 s
439     ) external returns (uint amountA, uint amountB);
440     function removeLiquidityETHWithPermit(
441         address token,
442         uint liquidity,
443         uint amountTokenMin,
444         uint amountETHMin,
445         address to,
446         uint deadline,
447         bool approveMax, uint8 v, bytes32 r, bytes32 s
448     ) external returns (uint amountToken, uint amountETH);
449     function swapExactTokensForTokens(
450         uint amountIn,
451         uint amountOutMin,
452         address[] calldata path,
453         address to,
454         uint deadline
455     ) external returns (uint[] memory amounts);
456     function swapTokensForExactTokens(
457         uint amountOut,
458         uint amountInMax,
459         address[] calldata path,
460         address to,
461         uint deadline
462     ) external returns (uint[] memory amounts);
463     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
464         external
465         payable
466         returns (uint[] memory amounts);
467     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
468         external
469         returns (uint[] memory amounts);
470     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
471         external
472         returns (uint[] memory amounts);
473     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
474         external
475         payable
476         returns (uint[] memory amounts);
477  
478     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
479     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
480     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
481     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
482     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
483 }
484  
485 interface IUniswapV2Router02 is IUniswapV2Router01 {
486     function removeLiquidityETHSupportingFeeOnTransferTokens(
487         address token,
488         uint liquidity,
489         uint amountTokenMin,
490         uint amountETHMin,
491         address to,
492         uint deadline
493     ) external returns (uint amountETH);
494     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
495         address token,
496         uint liquidity,
497         uint amountTokenMin,
498         uint amountETHMin,
499         address to,
500         uint deadline,
501         bool approveMax, uint8 v, bytes32 r, bytes32 s
502     ) external returns (uint amountETH);
503  
504     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
505         uint amountIn,
506         uint amountOutMin,
507         address[] calldata path,
508         address to,
509         uint deadline
510     ) external;
511     function swapExactETHForTokensSupportingFeeOnTransferTokens(
512         uint amountOutMin,
513         address[] calldata path,
514         address to,
515         uint deadline
516     ) external payable;
517     function swapExactTokensForETHSupportingFeeOnTransferTokens(
518         uint amountIn,
519         uint amountOutMin,
520         address[] calldata path,
521         address to,
522         uint deadline
523     ) external;
524 }
525  
526 contract EFOLIO is ERC20, Ownable {
527     using SafeMath for uint256;
528  
529     IUniswapV2Router02 public immutable uniswapV2Router;
530     address public immutable uniswapV2Pair;
531     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
532  
533     bool private swapping;
534  
535     address public marketingWallet;
536     address public edgeWallet;
537  
538     uint256 public maxTransactionAmount;
539     uint256 public swapTokensAtAmount;
540     uint256 public maxWallet;
541  
542     uint256 public percentForLPBurn = 25; // 25 = .25%
543     bool public lpBurnEnabled = true;
544     uint256 public lpBurnFrequency = 7200 seconds;
545     uint256 public lastLpBurnTime;
546  
547     uint256 public manualBurnFrequency = 30 minutes;
548     uint256 public lastManualLpBurnTime;
549  
550     bool public limitsInEffect = true;
551     bool public tradingActive = false;
552     bool public swapEnabled = false;
553     bool public enableEarlySellTax = false;
554  
555      // Anti-bot and anti-whale mappings and variables
556     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
557  
558     // Seller Map
559     mapping (address => uint256) private _holderFirstBuyTimestamp;
560  
561     // Blacklist Map
562     mapping (address => bool) private _blacklist;
563     bool public transferDelayEnabled = false;
564  
565     uint256 public buyTotalFees;
566     uint256 public buyMarketingFee;
567     uint256 public buyLiquidityFee;
568     uint256 public buyEdgeFee;
569  
570     uint256 public sellTotalFees;
571     uint256 public sellMarketingFee;
572     uint256 public sellLiquidityFee;
573     uint256 public sellEdgeFee;
574  
575     uint256 public earlySellLiquidityFee;
576     uint256 public earlySellMarketingFee;
577  
578     uint256 public tokensForMarketing;
579     uint256 public tokensForLiquidity;
580     uint256 public tokensForEdge;
581  
582     // block number of opened trading
583     uint256 launchedAt;
584  
585     /******************/
586  
587     // exclude from fees and max transaction amount
588     mapping (address => bool) private _isExcludedFromFees;
589     mapping (address => bool) public _isExcludedMaxTransactionAmount;
590  
591     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
592     // could be subject to a maximum transfer amount
593     mapping (address => bool) public automatedMarketMakerPairs;
594  
595     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
596  
597     event ExcludeFromFees(address indexed account, bool isExcluded);
598  
599     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
600  
601     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
602  
603     event edgeWalletUpdated(address indexed newWallet, address indexed oldWallet);
604  
605     event SwapAndLiquify(
606         uint256 tokensSwapped,
607         uint256 ethReceived,
608         uint256 tokensIntoLiquidity
609     );
610  
611     event AutoNukeLP();
612  
613     event ManualNukeLP();
614  
615     constructor() ERC20(unicode"Edgefolio", "EFOLIO") {
616  
617         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
618  
619         excludeFromMaxTransaction(address(_uniswapV2Router), true);
620         uniswapV2Router = _uniswapV2Router;
621  
622         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
623         excludeFromMaxTransaction(address(uniswapV2Pair), true);
624         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
625  
626         uint256 _buyMarketingFee = 20;
627         uint256 _buyLiquidityFee = 0;
628         uint256 _buyEdgeFee = 0;
629  
630         uint256 _sellMarketingFee = 40;
631         uint256 _sellLiquidityFee = 0;
632         uint256 _sellEdgeFee = 0;
633  
634         uint256 _earlySellLiquidityFee = 0;
635         uint256 _earlySellMarketingFee = 0;
636  
637         uint256 totalSupply = 1 * 1e6 * 1e18;
638  
639         maxTransactionAmount = totalSupply * 1000 / 1000;
640         maxWallet = totalSupply * 20 / 1000;
641         swapTokensAtAmount = totalSupply * 10 / 10000;
642  
643         buyMarketingFee = _buyMarketingFee;
644         buyLiquidityFee = _buyLiquidityFee;
645         buyEdgeFee = _buyEdgeFee;
646         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyEdgeFee;
647  
648         sellMarketingFee = _sellMarketingFee;
649         sellLiquidityFee = _sellLiquidityFee;
650         sellEdgeFee = _sellEdgeFee;
651         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellEdgeFee;
652  
653         earlySellLiquidityFee = _earlySellLiquidityFee;
654         earlySellMarketingFee = _earlySellMarketingFee;
655  
656         marketingWallet = address(0xA284895d1B5D4478a2B0b801b20c0100C112F920); // set as marketing wallet
657         edgeWallet = address(0x536C8fb619a40D761Cb9CFd459ac8bE854b9389D); // set as Edge wallet
658  
659         // exclude from paying fees or having max transaction amount
660         excludeFromFees(owner(), true);
661         excludeFromFees(address(this), true);
662         excludeFromFees(address(0xdead), true);
663  
664         excludeFromMaxTransaction(owner(), true);
665         excludeFromMaxTransaction(address(this), true);
666         excludeFromMaxTransaction(address(0xdead), true);
667  
668         _mint(msg.sender, totalSupply);
669     }
670  
671     receive() external payable {
672  
673   	}
674  
675     // once enabled, can never be turned off
676     function enableTrading() external onlyOwner {
677         tradingActive = true;
678         swapEnabled = true;
679         lastLpBurnTime = block.timestamp;
680         launchedAt = block.number;
681     }
682  
683     // remove limits after token is stable
684     function removeLimits() external onlyOwner returns (bool){
685         limitsInEffect = false;
686         return true;
687     }
688  
689     // disable Transfer delay - cannot be reenabled
690     function disableTransferDelay() external onlyOwner returns (bool){
691         transferDelayEnabled = false;
692         return true;
693     }
694  
695     function setEarlySellTax(bool onoff) external onlyOwner  {
696         enableEarlySellTax = onoff;
697     }
698  
699      // change the minimum amount of tokens to sell from fees
700     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
701   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
702   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
703   	    swapTokensAtAmount = newAmount;
704   	    return true;
705   	}
706  
707     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
708         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
709         maxTransactionAmount = newNum * (10**18);
710     }
711  
712     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
713         require(newNum >= (totalSupply() * 15 / 1000)/1e18, "Cannot set maxWallet lower than 1.5%");
714         maxWallet = newNum * (10**18);
715     }
716  
717     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
718         _isExcludedMaxTransactionAmount[updAds] = isEx;
719     }
720  
721     // only use to disable contract sales if absolutely necessary (emergency use only)
722     function updateSwapEnabled(bool enabled) external onlyOwner(){
723         swapEnabled = enabled;
724     }
725  
726     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _EdgeFee) external onlyOwner {
727         buyMarketingFee = _marketingFee;
728         buyLiquidityFee = _liquidityFee;
729         buyEdgeFee = _EdgeFee;
730         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyEdgeFee;
731         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
732     }
733  
734     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _EdgeFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
735         sellMarketingFee = _marketingFee;
736         sellLiquidityFee = _liquidityFee;
737         sellEdgeFee = _EdgeFee;
738         earlySellLiquidityFee = _earlySellLiquidityFee;
739         earlySellMarketingFee = _earlySellMarketingFee;
740         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellEdgeFee;
741         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
742     }
743  
744     function excludeFromFees(address account, bool excluded) public onlyOwner {
745         _isExcludedFromFees[account] = excluded;
746         emit ExcludeFromFees(account, excluded);
747     }
748  
749     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
750         _blacklist[account] = isBlacklisted;
751     }
752  
753     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
754         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
755  
756         _setAutomatedMarketMakerPair(pair, value);
757     }
758  
759     function _setAutomatedMarketMakerPair(address pair, bool value) private {
760         automatedMarketMakerPairs[pair] = value;
761  
762         emit SetAutomatedMarketMakerPair(pair, value);
763     }
764  
765     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
766         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
767         marketingWallet = newMarketingWallet;
768     }
769  
770     function updateedgeWallet(address newWallet) external onlyOwner {
771         emit edgeWalletUpdated(newWallet, edgeWallet);
772         edgeWallet = newWallet;
773     }
774  
775  
776     function isExcludedFromFees(address account) public view returns(bool) {
777         return _isExcludedFromFees[account];
778     }
779  
780     event BoughtEarly(address indexed sniper);
781  
782     function _transfer(
783         address from,
784         address to,
785         uint256 amount
786     ) internal override {
787         require(from != address(0), "ERC20: transfer from the zero address");
788         require(to != address(0), "ERC20: transfer to the zero address");
789         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
790          if(amount == 0) {
791             super._transfer(from, to, 0);
792             return;
793         }
794  
795         if(limitsInEffect){
796             if (
797                 from != owner() &&
798                 to != owner() &&
799                 to != address(0) &&
800                 to != address(0xdead) &&
801                 !swapping
802             ){
803                 if(!tradingActive){
804                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
805                 }
806  
807                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
808                 if (transferDelayEnabled){
809                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
810                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
811                         _holderLastTransferTimestamp[tx.origin] = block.number;
812                     }
813                 }
814  
815                 //when buy
816                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
817                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
818                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
819                 }
820  
821                 //when sell
822                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
823                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
824                 }
825                 else if(!_isExcludedMaxTransactionAmount[to]){
826                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
827                 }
828             }
829         }
830  
831         // anti bot logic
832         if (block.number <= (launchedAt + 0) && 
833                 to != uniswapV2Pair && 
834                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
835             ) { 
836             _blacklist[to] = false;
837         }
838  
839 		uint256 contractTokenBalance = balanceOf(address(this));
840  
841         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
842  
843         if( 
844             canSwap &&
845             swapEnabled &&
846             !swapping &&
847             !automatedMarketMakerPairs[from] &&
848             !_isExcludedFromFees[from] &&
849             !_isExcludedFromFees[to]
850         ) {
851             swapping = true;
852  
853             swapBack();
854  
855             swapping = false;
856         }
857  
858         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
859             autoBurnLiquidityPairTokens();
860         }
861  
862         bool takeFee = !swapping;
863  
864         // if any account belongs to _isExcludedFromFee account then remove the fee
865         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
866             takeFee = false;
867         }
868  
869         uint256 fees = 0;
870         // only take fees on buys/sells, do not take on wallet transfers
871         if(takeFee){
872             // on sell
873             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
874                 fees = amount.mul(sellTotalFees).div(100);
875                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
876                 tokensForEdge += fees * sellEdgeFee / sellTotalFees;
877                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
878             }
879             // on buy
880             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
881         	    fees = amount.mul(buyTotalFees).div(100);
882         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
883                 tokensForEdge += fees * buyEdgeFee / buyTotalFees;
884                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
885             }
886  
887             if(fees > 0){    
888                 super._transfer(from, address(this), fees);
889             }
890  
891         	amount -= fees;
892         }
893  
894         super._transfer(from, to, amount);
895     }
896  
897     function swapTokensForEth(uint256 tokenAmount) private {
898  
899         address[] memory path = new address[](2);
900         path[0] = address(this);
901         path[1] = uniswapV2Router.WETH();
902  
903         _approve(address(this), address(uniswapV2Router), tokenAmount);
904  
905         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
906             tokenAmount,
907             0, // accept any amount of ETH
908             path,
909             address(this),
910             block.timestamp
911         );
912  
913     }
914 
915     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
916         _approve(address(this), address(uniswapV2Router), tokenAmount);
917  
918         uniswapV2Router.addLiquidityETH{value: ethAmount}(
919             address(this),
920             tokenAmount,
921             0, // slippage is unavoidable
922             0, // slippage is unavoidable
923             deadAddress,
924             block.timestamp
925         );
926     }
927  
928     function swapBack() private {
929         uint256 contractBalance = balanceOf(address(this));
930         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForEdge;
931         bool success;
932  
933         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
934  
935         if(contractBalance > swapTokensAtAmount * 20){
936           contractBalance = swapTokensAtAmount * 20;
937         }
938  
939         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
940         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
941  
942         uint256 initialETHBalance = address(this).balance;
943  
944         swapTokensForEth(amountToSwapForETH); 
945  
946         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
947  
948         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
949         uint256 ethForEdge = ethBalance.mul(tokensForEdge).div(totalTokensToSwap);
950  
951  
952         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForEdge;
953  
954  
955         tokensForLiquidity = 0;
956         tokensForMarketing = 0;
957         tokensForEdge = 0;
958  
959         (success,) = address(edgeWallet).call{value: ethForEdge}("");
960  
961         if(liquidityTokens > 0 && ethForLiquidity > 0){
962             addLiquidity(liquidityTokens, ethForLiquidity);
963             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
964         }
965  
966  
967         (success,) = address(marketingWallet).call{value: address(this).balance}("");
968     }
969  
970     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
971         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
972         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
973         lpBurnFrequency = _frequencyInSeconds;
974         percentForLPBurn = _percent;
975         lpBurnEnabled = _Enabled;
976     }
977  
978     function autoBurnLiquidityPairTokens() internal returns (bool){
979  
980         lastLpBurnTime = block.timestamp;
981  
982         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
983  
984         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
985  
986         if (amountToBurn > 0){
987             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
988         }
989  
990         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
991         pair.sync();
992         emit AutoNukeLP();
993         return true;
994     }
995  
996     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
997         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
998         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
999         lastManualLpBurnTime = block.timestamp;
1000  
1001         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1002  
1003         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1004  
1005         if (amountToBurn > 0){
1006             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1007         }
1008  
1009         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1010         pair.sync();
1011         emit ManualNukeLP();
1012         return true;
1013     }
1014 }