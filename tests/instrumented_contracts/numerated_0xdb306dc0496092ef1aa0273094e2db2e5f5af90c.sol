1 // File: DDAO.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-09-15
5 */
6 
7 /**
8  *Submitted for verification at Etherscan.io on 2022-09-15
9 */
10 
11 /**
12   Website: www.degendao.lol
13   Twitter: www.twitter.com/DegenDAOETH
14   TG: t.me/DegenDAOerc 
15 */
16 
17 
18 pragma solidity 0.8.11;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 interface IUniswapV2Pair {
32     event Approval(address indexed owner, address indexed spender, uint value);
33     event Transfer(address indexed from, address indexed to, uint value);
34 
35     function name() external pure returns (string memory);
36     function symbol() external pure returns (string memory);
37     function decimals() external pure returns (uint8);
38     function totalSupply() external view returns (uint);
39     function balanceOf(address owner) external view returns (uint);
40     function allowance(address owner, address spender) external view returns (uint);
41 
42     function approve(address spender, uint value) external returns (bool);
43     function transfer(address to, uint value) external returns (bool);
44     function transferFrom(address from, address to, uint value) external returns (bool);
45 
46     function DOMAIN_SEPARATOR() external view returns (bytes32);
47     function PERMIT_TYPEHASH() external pure returns (bytes32);
48     function nonces(address owner) external view returns (uint);
49 
50     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
51 
52     event Mint(address indexed sender, uint amount0, uint amount1);
53     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
54     event Swap(
55         address indexed sender,
56         uint amount0In,
57         uint amount1In,
58         uint amount0Out,
59         uint amount1Out,
60         address indexed to
61     );
62     event Sync(uint112 reserve0, uint112 reserve1);
63 
64     function MINIMUM_LIQUIDITY() external pure returns (uint);
65     function factory() external view returns (address);
66     function token0() external view returns (address);
67     function token1() external view returns (address);
68     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
69     function price0CumulativeLast() external view returns (uint);
70     function price1CumulativeLast() external view returns (uint);
71     function kLast() external view returns (uint);
72 
73     function mint(address to) external returns (uint liquidity);
74     function burn(address to) external returns (uint amount0, uint amount1);
75     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
76     function skim(address to) external;
77     function sync() external;
78 
79     function initialize(address, address) external;
80 }
81 
82 interface IUniswapV2Factory {
83     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
84 
85     function feeTo() external view returns (address);
86     function feeToSetter() external view returns (address);
87 
88     function getPair(address tokenA, address tokenB) external view returns (address pair);
89     function allPairs(uint) external view returns (address pair);
90     function allPairsLength() external view returns (uint);
91 
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 
94     function setFeeTo(address) external;
95     function setFeeToSetter(address) external;
96 }
97 
98 interface IERC20 {
99     function totalSupply() external view returns (uint256);
100     function balanceOf(address account) external view returns (uint256);
101     function transfer(address recipient, uint256 amount) external returns (bool);
102     function allowance(address owner, address spender) external view returns (uint256);
103     function approve(address spender, uint256 amount) external returns (bool);
104     function transferFrom(
105         address sender,
106         address recipient,
107         uint256 amount
108     ) external returns (bool);
109     
110     event Transfer(address indexed from, address indexed to, uint256 value);
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 interface IERC20Metadata is IERC20 {
115     function name() external view returns (string memory);
116     function symbol() external view returns (string memory);
117     function decimals() external view returns (uint8);
118 }
119 
120 
121 contract ERC20 is Context, IERC20, IERC20Metadata {
122     using SafeMath for uint256;
123 
124     mapping(address => uint256) private _balances;
125 
126     mapping(address => mapping(address => uint256)) private _allowances;
127 
128     uint256 private _totalSupply;
129 
130     string private _name;
131     string private _symbol;
132 
133     constructor(string memory name_, string memory symbol_) {
134         _name = name_;
135         _symbol = symbol_;
136     }
137 
138     function name() public view virtual override returns (string memory) {
139         return _name;
140     }
141 
142     function symbol() public view virtual override returns (string memory) {
143         return _symbol;
144     }
145 
146     function decimals() public view virtual override returns (uint8) {
147         return 9;
148     }
149 
150     function totalSupply() public view virtual override returns (uint256) {
151         return _totalSupply;
152     }
153 
154     function balanceOf(address account) public view virtual override returns (uint256) {
155         return _balances[account];
156     }
157 
158     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
159         _transfer(_msgSender(), recipient, amount);
160         return true;
161     }
162 
163     function allowance(address owner, address spender) public view virtual override returns (uint256) {
164         return _allowances[owner][spender];
165     }
166 
167     function approve(address spender, uint256 amount) public virtual override returns (bool) {
168         _approve(_msgSender(), spender, amount);
169         return true;
170     }
171 
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) public virtual override returns (bool) {
177         _transfer(sender, recipient, amount);
178         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
179         return true;
180     }
181 
182     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
183         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
184         return true;
185     }
186 
187     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
188         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
189         return true;
190     }
191 
192     function _transfer(
193         address sender,
194         address recipient,
195         uint256 amount
196     ) internal virtual {
197         require(sender != address(0), "ERC20: transfer from the zero address");
198         require(recipient != address(0), "ERC20: transfer to the zero address");
199 
200         _beforeTokenTransfer(sender, recipient, amount);
201 
202         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
203         _balances[recipient] = _balances[recipient].add(amount);
204         emit Transfer(sender, recipient, amount);
205     }
206 
207     function _mint(address account, uint256 amount) internal virtual {
208         require(account != address(0), "ERC20: mint to the zero address");
209 
210         _beforeTokenTransfer(address(0), account, amount);
211 
212         _totalSupply = _totalSupply.add(amount);
213         _balances[account] = _balances[account].add(amount);
214         emit Transfer(address(0), account, amount);
215     }
216 
217     function _burn(address account, uint256 amount) internal virtual {
218         require(account != address(0), "ERC20: burn from the zero address");
219 
220         _beforeTokenTransfer(account, address(0), amount);
221 
222         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
223         _totalSupply = _totalSupply.sub(amount);
224         emit Transfer(account, address(0), amount);
225     }
226 
227     function _approve(
228         address owner,
229         address spender,
230         uint256 amount
231     ) internal virtual {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234 
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 
239     function _beforeTokenTransfer(
240         address from,
241         address to,
242         uint256 amount
243     ) internal virtual {}
244 }
245 
246 library SafeMath {
247     function add(uint256 a, uint256 b) internal pure returns (uint256) {
248         uint256 c = a + b;
249         require(c >= a, "SafeMath: addition overflow");
250 
251         return c;
252     }
253 
254     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
255         return sub(a, b, "SafeMath: subtraction overflow");
256     }
257 
258     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b <= a, errorMessage);
260         uint256 c = a - b;
261 
262         return c;
263     }
264 
265     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
266         if (a == 0) {
267             return 0;
268         }
269 
270         uint256 c = a * b;
271         require(c / a == b, "SafeMath: multiplication overflow");
272 
273         return c;
274     }
275 
276     function div(uint256 a, uint256 b) internal pure returns (uint256) {
277         return div(a, b, "SafeMath: division by zero");
278     }
279 
280     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         require(b > 0, errorMessage);
282         uint256 c = a / b;
283         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284 
285         return c;
286     }
287 
288     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
289         return mod(a, b, "SafeMath: modulo by zero");
290     }
291 
292     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b != 0, errorMessage);
294         return a % b;
295     }
296 }
297 
298 contract Ownable is Context {
299     address private _owner;
300 
301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
302 
303     constructor () {
304         address msgSender = _msgSender();
305         _owner = msgSender;
306         emit OwnershipTransferred(address(0), msgSender);
307     }
308 
309     function owner() public view returns (address) {
310         return _owner;
311     }
312 
313     modifier onlyOwner() {
314         require(_owner == _msgSender(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     function renounceOwnership() public virtual onlyOwner {
319         emit OwnershipTransferred(_owner, address(0));
320         _owner = address(0);
321     }
322 
323     function transferOwnership(address newOwner) public virtual onlyOwner {
324         require(newOwner != address(0), "Ownable: new owner is the zero address");
325         emit OwnershipTransferred(_owner, newOwner);
326         _owner = newOwner;
327     }
328 }
329 
330 
331 
332 library SafeMathInt {
333     int256 private constant MIN_INT256 = int256(1) << 255;
334     int256 private constant MAX_INT256 = ~(int256(1) << 255);
335 
336     function mul(int256 a, int256 b) internal pure returns (int256) {
337         int256 c = a * b;
338 
339         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
340         require((b == 0) || (c / b == a));
341         return c;
342     }
343 
344     function div(int256 a, int256 b) internal pure returns (int256) {
345         require(b != -1 || a != MIN_INT256);
346 
347         return a / b;
348     }
349 
350     function sub(int256 a, int256 b) internal pure returns (int256) {
351         int256 c = a - b;
352         require((b >= 0 && c <= a) || (b < 0 && c > a));
353         return c;
354     }
355 
356     function add(int256 a, int256 b) internal pure returns (int256) {
357         int256 c = a + b;
358         require((b >= 0 && c >= a) || (b < 0 && c < a));
359         return c;
360     }
361 
362     function abs(int256 a) internal pure returns (int256) {
363         require(a != MIN_INT256);
364         return a < 0 ? -a : a;
365     }
366 
367     function toUint256Safe(int256 a) internal pure returns (uint256) {
368         require(a >= 0);
369         return uint256(a);
370     }
371 }
372 
373 library SafeMathUint {
374   function toInt256Safe(uint256 a) internal pure returns (int256) {
375     int256 b = int256(a);
376     require(b >= 0);
377     return b;
378   }
379 }
380 
381 interface IUniswapV2Router01 {
382     function factory() external pure returns (address);
383     function WETH() external pure returns (address);
384 
385     function addLiquidity(
386         address tokenA,
387         address tokenB,
388         uint amountADesired,
389         uint amountBDesired,
390         uint amountAMin,
391         uint amountBMin,
392         address to,
393         uint deadline
394     ) external returns (uint amountA, uint amountB, uint liquidity);
395     function addLiquidityETH(
396         address token,
397         uint amountTokenDesired,
398         uint amountTokenMin,
399         uint amountETHMin,
400         address to,
401         uint deadline
402     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
403     function removeLiquidity(
404         address tokenA,
405         address tokenB,
406         uint liquidity,
407         uint amountAMin,
408         uint amountBMin,
409         address to,
410         uint deadline
411     ) external returns (uint amountA, uint amountB);
412     function removeLiquidityETH(
413         address token,
414         uint liquidity,
415         uint amountTokenMin,
416         uint amountETHMin,
417         address to,
418         uint deadline
419     ) external returns (uint amountToken, uint amountETH);
420     function removeLiquidityWithPermit(
421         address tokenA,
422         address tokenB,
423         uint liquidity,
424         uint amountAMin,
425         uint amountBMin,
426         address to,
427         uint deadline,
428         bool approveMax, uint8 v, bytes32 r, bytes32 s
429     ) external returns (uint amountA, uint amountB);
430     function removeLiquidityETHWithPermit(
431         address token,
432         uint liquidity,
433         uint amountTokenMin,
434         uint amountETHMin,
435         address to,
436         uint deadline,
437         bool approveMax, uint8 v, bytes32 r, bytes32 s
438     ) external returns (uint amountToken, uint amountETH);
439     function swapExactTokensForTokens(
440         uint amountIn,
441         uint amountOutMin,
442         address[] calldata path,
443         address to,
444         uint deadline
445     ) external returns (uint[] memory amounts);
446     function swapTokensForExactTokens(
447         uint amountOut,
448         uint amountInMax,
449         address[] calldata path,
450         address to,
451         uint deadline
452     ) external returns (uint[] memory amounts);
453     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
454         external
455         payable
456         returns (uint[] memory amounts);
457     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
458         external
459         returns (uint[] memory amounts);
460     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
461         external
462         returns (uint[] memory amounts);
463     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
464         external
465         payable
466         returns (uint[] memory amounts);
467 
468     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
469     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
470     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
471     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
472     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
473 }
474 
475 interface IUniswapV2Router02 is IUniswapV2Router01 {
476     function removeLiquidityETHSupportingFeeOnTransferTokens(
477         address token,
478         uint liquidity,
479         uint amountTokenMin,
480         uint amountETHMin,
481         address to,
482         uint deadline
483     ) external returns (uint amountETH);
484     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
485         address token,
486         uint liquidity,
487         uint amountTokenMin,
488         uint amountETHMin,
489         address to,
490         uint deadline,
491         bool approveMax, uint8 v, bytes32 r, bytes32 s
492     ) external returns (uint amountETH);
493     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
494         uint amountIn,
495         uint amountOutMin,
496         address[] calldata path,
497         address to,
498         uint deadline
499     ) external;
500     function swapExactETHForTokensSupportingFeeOnTransferTokens(
501         uint amountOutMin,
502         address[] calldata path,
503         address to,
504         uint deadline
505     ) external payable;
506     function swapExactTokensForETHSupportingFeeOnTransferTokens(
507         uint amountIn,
508         uint amountOutMin,
509         address[] calldata path,
510         address to,
511         uint deadline
512     ) external;
513 }
514 
515 contract DDAO is ERC20, Ownable {
516     using SafeMath for uint256;
517 
518     IUniswapV2Router02 public immutable uniswapV2Router;
519     address public immutable uniswapV2Pair;
520 
521     mapping (address => bool) private _isSniper;
522     bool private _swapping;
523     uint256 private _launchTime;
524 
525     address public feeWallet;
526     
527     uint256 public maxTransactionAmount;
528     uint256 public swapTokensAtAmount;
529     uint256 public maxWallet;
530         
531     bool public limitsInEffect = true;
532     bool public tradingActive = false;
533     
534     // Anti-bot and anti-whale mappings and variables
535     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
536     bool public transferDelayEnabled = true;
537 
538     uint256 public buyTotalFees;
539     uint256 private _buyMarketingFee;
540     uint256 private _buyLiquidityFee;
541     uint256 private _buyDevFee;
542     
543     uint256 public sellTotalFees;
544     uint256 private _sellMarketingFee;
545     uint256 private _sellLiquidityFee;
546     uint256 private _sellDevFee;
547     
548     uint256 private _tokensForMarketing;
549     uint256 private _tokensForLiquidity;
550     uint256 private _tokensForDev;
551     
552     /******************/
553 
554     // exlcude from fees and max transaction amount
555     mapping (address => bool) private _isExcludedFromFees;
556     mapping (address => bool) public _isExcludedMaxTransactionAmount;
557 
558     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
559     // could be subject to a maximum transfer amount
560     mapping (address => bool) public automatedMarketMakerPairs;
561 
562     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
563     event ExcludeFromFees(address indexed account, bool isExcluded);
564     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
565     event feeWalletUpdated(address indexed newWallet, address indexed oldWallet);
566     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
567     event AutoNukeLP();
568     event ManualNukeLP();
569 
570     constructor() ERC20("DegenDAO", "DDAO") {
571         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
572         
573         excludeFromMaxTransaction(address(_uniswapV2Router), true);
574         uniswapV2Router = _uniswapV2Router;
575         
576         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
577         excludeFromMaxTransaction(address(uniswapV2Pair), true);
578         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
579         
580         uint256 buyMarketingFee = 1;
581         uint256 buyLiquidityFee = 3;
582         uint256 buyDevFee = 1;
583 
584         uint256 sellMarketingFee = 1;
585         uint256 sellLiquidityFee = 3;
586         uint256 sellDevFee = 1;
587         
588         uint256 totalSupply = 1e5 * 1e9;
589         
590         maxTransactionAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
591         maxWallet = totalSupply * 2 / 100; // 2% maxWallet
592         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
593 
594         _buyMarketingFee = buyMarketingFee;
595         _buyLiquidityFee = buyLiquidityFee;
596         _buyDevFee = buyDevFee;
597         buyTotalFees = _buyMarketingFee + _buyLiquidityFee + _buyDevFee;
598         
599         _sellMarketingFee = sellMarketingFee;
600         _sellLiquidityFee = sellLiquidityFee;
601         _sellDevFee = sellDevFee;
602         sellTotalFees = _sellMarketingFee + _sellLiquidityFee + _sellDevFee;
603         
604         feeWallet = address(owner()); // set as fee wallet
605 
606         // exclude from paying fees or having max transaction amount
607         excludeFromFees(owner(), true);
608         excludeFromFees(address(this), true);
609         excludeFromFees(address(0xdead), true);
610         
611         excludeFromMaxTransaction(owner(), true);
612         excludeFromMaxTransaction(address(this), true);
613         excludeFromMaxTransaction(address(0xdead), true);
614         
615         /*
616             _mint is an internal function in ERC20.sol that is only called here,
617             and CANNOT be called ever again
618         */
619         _mint(msg.sender, totalSupply);
620     }
621 
622     // once enabled, can never be turned off
623     function enableTrading() external onlyOwner {
624         tradingActive = true;
625         _launchTime = block.timestamp;
626     }
627     
628     // remove limits after token is stable
629     function removeLimits() external onlyOwner returns (bool) {
630         limitsInEffect = false;
631         return true;
632     }
633     
634     // disable Transfer delay - cannot be reenabled
635     function disableTransferDelay() external onlyOwner returns (bool) {
636         transferDelayEnabled = false;
637         return true;
638     }
639     
640      // change the minimum amount of tokens to sell from fees
641     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
642   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
643   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
644   	    swapTokensAtAmount = newAmount;
645   	    return true;
646   	}
647     
648     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
649         require(newNum >= (totalSupply() * 1 / 1000) / 1e9, "Cannot set maxTransactionAmount lower than 0.1%");
650         maxTransactionAmount = newNum * 1e9;
651     }
652 
653     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
654         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxWallet lower than 0.5%");
655         maxWallet = newNum * 1e9;
656     }
657     
658     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
659         _isExcludedMaxTransactionAmount[updAds] = isEx;
660     }
661     
662     function updateBuyFees(uint256 marketingFee, uint256 liquidityFee, uint256 devFee) external onlyOwner {
663         _buyMarketingFee = marketingFee;
664         _buyLiquidityFee = liquidityFee;
665         _buyDevFee = devFee;
666         buyTotalFees = _buyMarketingFee + _buyLiquidityFee + _buyDevFee;
667         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
668     }
669     
670     function updateSellFees(uint256 marketingFee, uint256 liquidityFee, uint256 devFee) external onlyOwner {
671         _sellMarketingFee = marketingFee;
672         _sellLiquidityFee = liquidityFee;
673         _sellDevFee = devFee;
674         sellTotalFees = _sellMarketingFee + _sellLiquidityFee + _sellDevFee;
675         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
676     }
677 
678     function excludeFromFees(address account, bool excluded) public onlyOwner {
679         _isExcludedFromFees[account] = excluded;
680         emit ExcludeFromFees(account, excluded);
681     }
682 
683     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
684         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
685 
686         _setAutomatedMarketMakerPair(pair, value);
687     }
688 
689     function _setAutomatedMarketMakerPair(address pair, bool value) private {
690         automatedMarketMakerPairs[pair] = value;
691 
692         emit SetAutomatedMarketMakerPair(pair, value);
693     }
694     
695     function updateFeeWallet(address newWallet) external onlyOwner {
696         emit feeWalletUpdated(newWallet, feeWallet);
697         feeWallet = newWallet;
698     }
699 
700     function isExcludedFromFees(address account) public view returns(bool) {
701         return _isExcludedFromFees[account];
702     }
703     
704     function setSnipers(address[] memory snipers_) public onlyOwner() {
705         for (uint i = 0; i < snipers_.length; i++) {
706             if (snipers_[i] != uniswapV2Pair && snipers_[i] != address(uniswapV2Router)) {
707                 _isSniper[snipers_[i]] = true;
708             }
709         }
710     }
711     
712     function delSnipers(address[] memory snipers_) public onlyOwner() {
713         for (uint i = 0; i < snipers_.length; i++) {
714             _isSniper[snipers_[i]] = false;
715         }
716     }
717     
718     function isSniper(address addr) public view returns (bool) {
719         return _isSniper[addr];
720     }
721 
722     function _transfer(
723         address from,
724         address to,
725         uint256 amount
726     ) internal override {
727         require(from != address(0), "ERC20: transfer from the zero address");
728         require(to != address(0), "ERC20: transfer to the zero address");
729         require(!_isSniper[from], "Your address has been marked as a sniper, you are unable to transfer or swap.");
730         
731          if (amount == 0) {
732             super._transfer(from, to, 0);
733             return;
734         }
735         
736         if (block.timestamp == _launchTime) _isSniper[to] = true;
737         
738         if (limitsInEffect) {
739             if (
740                 from != owner() &&
741                 to != owner() &&
742                 to != address(0) &&
743                 to != address(0xdead) &&
744                 !_swapping
745             ) {
746                 if (!tradingActive) {
747                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
748                 }
749 
750                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
751                 if (transferDelayEnabled){
752                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
753                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
754                         _holderLastTransferTimestamp[tx.origin] = block.number;
755                     }
756                 }
757                  
758                 // when buy
759                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
760                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
761                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
762                 }
763                 
764                 // when sell
765                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
766                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
767                 }
768                 else if (!_isExcludedMaxTransactionAmount[to]){
769                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
770                 }
771             }
772         }
773         
774 		uint256 contractTokenBalance = balanceOf(address(this));
775         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
776         if (
777             canSwap &&
778             !_swapping &&
779             !automatedMarketMakerPairs[from] &&
780             !_isExcludedFromFees[from] &&
781             !_isExcludedFromFees[to]
782         ) {
783             _swapping = true;
784             swapBack();
785             _swapping = false;
786         }
787 
788         bool takeFee = !_swapping;
789 
790         // if any account belongs to _isExcludedFromFee account then remove the fee
791         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
792             takeFee = false;
793         }
794         
795         uint256 fees = 0;
796         // only take fees on buys/sells, do not take on wallet transfers
797         if (takeFee) {
798             // on sell
799             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
800                 fees = amount.mul(sellTotalFees).div(100);
801                 _tokensForLiquidity += fees * _sellLiquidityFee / sellTotalFees;
802                 _tokensForDev += fees * _sellDevFee / sellTotalFees;
803                 _tokensForMarketing += fees * _sellMarketingFee / sellTotalFees;
804             }
805             // on buy
806             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
807         	    fees = amount.mul(buyTotalFees).div(100);
808         	    _tokensForLiquidity += fees * _buyLiquidityFee / buyTotalFees;
809                 _tokensForDev += fees * _buyDevFee / buyTotalFees;
810                 _tokensForMarketing += fees * _buyMarketingFee / buyTotalFees;
811             }
812             
813             if (fees > 0) {
814                 super._transfer(from, address(this), fees);
815             }
816         	
817         	amount -= fees;
818         }
819 
820         super._transfer(from, to, amount);
821     }
822 
823     function _swapTokensForEth(uint256 tokenAmount) private {
824         // generate the uniswap pair path of token -> weth
825         address[] memory path = new address[](2);
826         path[0] = address(this);
827         path[1] = uniswapV2Router.WETH();
828 
829         _approve(address(this), address(uniswapV2Router), tokenAmount);
830 
831         // make the swap
832         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
833             tokenAmount,
834             0, // accept any amount of ETH
835             path,
836             address(this),
837             block.timestamp
838         );
839     }
840     
841     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
842         // approve token transfer to cover all possible scenarios
843         _approve(address(this), address(uniswapV2Router), tokenAmount);
844 
845         // add the liquidity
846         uniswapV2Router.addLiquidityETH{value: ethAmount}(
847             address(this),
848             tokenAmount,
849             0, // slippage is unavoidable
850             0, // slippage is unavoidable
851             owner(),
852             block.timestamp
853         );
854     }
855 
856     function swapBack() private {
857         uint256 contractBalance = balanceOf(address(this));
858         uint256 totalTokensToSwap = _tokensForLiquidity + _tokensForMarketing + _tokensForDev;
859         
860         if (contractBalance == 0 || totalTokensToSwap == 0) return;
861         if (contractBalance > swapTokensAtAmount * 20) {
862           contractBalance = swapTokensAtAmount * 20;
863         }
864         
865         // Halve the amount of liquidity tokens
866         uint256 liquidityTokens = contractBalance * _tokensForLiquidity / totalTokensToSwap / 2;
867         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
868         
869         uint256 initialETHBalance = address(this).balance;
870 
871         _swapTokensForEth(amountToSwapForETH); 
872         
873         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
874         uint256 ethForMarketing = ethBalance.mul(_tokensForMarketing).div(totalTokensToSwap);
875         uint256 ethForDev = ethBalance.mul(_tokensForDev).div(totalTokensToSwap);
876         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
877         
878         _tokensForLiquidity = 0;
879         _tokensForMarketing = 0;
880         _tokensForDev = 0;
881                 
882         if (liquidityTokens > 0 && ethForLiquidity > 0) {
883             _addLiquidity(liquidityTokens, ethForLiquidity);
884             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, _tokensForLiquidity);
885         }
886     }
887 
888     function withdrawFees() external {
889         payable(feeWallet).transfer(address(this).balance);
890     }
891 
892     receive() external payable {}
893 }