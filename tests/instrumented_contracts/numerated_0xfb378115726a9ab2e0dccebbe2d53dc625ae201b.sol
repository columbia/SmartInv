1 /*           
2 **
3 **                  |\__/|
4 **                 /     \
5 **                /_.~ ~,_\
6 **                   \@/
7 **
8 **         Kitsune Inu ($KITSUNE)
9 **         https://www.kitsuneinu.org/
10 **         https://t.me/KitsuneInuEntryPortal
11 **         https://medium.com/@KitsuneInu
12 **         https://twitter.com/KitsuneInuETH
13 */
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 pragma solidity 0.8.9;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23  
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this;
26         return msg.data;
27     }
28 }
29  
30 interface IUniswapV2Pair {
31     event Approval(address indexed owner, address indexed spender, uint value);
32     event Transfer(address indexed from, address indexed to, uint value);
33  
34     function name() external pure returns (string memory);
35     function symbol() external pure returns (string memory);
36     function decimals() external pure returns (uint8);
37     function totalSupply() external view returns (uint);
38     function balanceOf(address owner) external view returns (uint);
39     function allowance(address owner, address spender) external view returns (uint);
40  
41     function approve(address spender, uint value) external returns (bool);
42     function transfer(address to, uint value) external returns (bool);
43     function transferFrom(address from, address to, uint value) external returns (bool);
44  
45     function DOMAIN_SEPARATOR() external view returns (bytes32);
46     function PERMIT_TYPEHASH() external pure returns (bytes32);
47     function nonces(address owner) external view returns (uint);
48  
49     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
50  
51     event Mint(address indexed sender, uint amount0, uint amount1);
52     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
53     event Swap(
54         address indexed sender,
55         uint amount0In,
56         uint amount1In,
57         uint amount0Out,
58         uint amount1Out,
59         address indexed to
60     );
61     event Sync(uint112 reserve0, uint112 reserve1);
62  
63     function MINIMUM_LIQUIDITY() external pure returns (uint);
64     function factory() external view returns (address);
65     function token0() external view returns (address);
66     function token1() external view returns (address);
67     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
68     function price0CumulativeLast() external view returns (uint);
69     function price1CumulativeLast() external view returns (uint);
70     function kLast() external view returns (uint);
71  
72     function mint(address to) external returns (uint liquidity);
73     function burn(address to) external returns (uint amount0, uint amount1);
74     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
75     function skim(address to) external;
76     function sync() external;
77  
78     function initialize(address, address) external;
79 }
80  
81 interface IUniswapV2Factory {
82     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
83  
84     function feeTo() external view returns (address);
85     function feeToSetter() external view returns (address);
86  
87     function getPair(address tokenA, address tokenB) external view returns (address pair);
88     function allPairs(uint) external view returns (address pair);
89     function allPairsLength() external view returns (uint);
90  
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92  
93     function setFeeTo(address) external;
94     function setFeeToSetter(address) external;
95 }
96  
97 interface IERC20 {
98 
99     function totalSupply() external view returns (uint256);
100  
101     function balanceOf(address account) external view returns (uint256);
102  
103     function transfer(address recipient, uint256 amount) external returns (bool);
104  
105     function allowance(address owner, address spender) external view returns (uint256);
106  
107     function approve(address spender, uint256 amount) external returns (bool);
108  
109     function transferFrom(
110         address sender,
111         address recipient,
112         uint256 amount
113     ) external returns (bool);
114  
115     event Transfer(address indexed from, address indexed to, uint256 value);
116  
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119  
120 interface IERC20Metadata is IERC20 {
121 
122     function name() external view returns (string memory);
123  
124     function symbol() external view returns (string memory);
125  
126     function decimals() external view returns (uint8);
127 }
128  
129  
130 contract ERC20 is Context, IERC20, IERC20Metadata {
131     using SafeMath for uint256;
132  
133     mapping(address => uint256) private _balances;
134  
135     mapping(address => mapping(address => uint256)) private _allowances;
136  
137     uint256 private _totalSupply;
138  
139     string private _name;
140     string private _symbol;
141  
142     constructor(string memory name_, string memory symbol_) {
143         _name = name_;
144         _symbol = symbol_;
145     }
146  
147     function name() public view virtual override returns (string memory) {
148         return _name;
149     }
150  
151     function symbol() public view virtual override returns (string memory) {
152         return _symbol;
153     }
154  
155     function decimals() public view virtual override returns (uint8) {
156         return 18;
157     }
158  
159     function totalSupply() public view virtual override returns (uint256) {
160         return _totalSupply;
161     }
162  
163     function balanceOf(address account) public view virtual override returns (uint256) {
164         return _balances[account];
165     }
166  
167     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
168         _transfer(_msgSender(), recipient, amount);
169         return true;
170     }
171  
172     function allowance(address owner, address spender) public view virtual override returns (uint256) {
173         return _allowances[owner][spender];
174     }
175  
176     function approve(address spender, uint256 amount) public virtual override returns (bool) {
177         _approve(_msgSender(), spender, amount);
178         return true;
179     }
180  
181     function transferFrom(
182         address sender,
183         address recipient,
184         uint256 amount
185     ) public virtual override returns (bool) {
186         _transfer(sender, recipient, amount);
187         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
188         return true;
189     }
190  
191     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
192         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
193         return true;
194     }
195  
196     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
197         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
198         return true;
199     }
200  
201     function _transfer(
202         address sender,
203         address recipient,
204         uint256 amount
205     ) internal virtual {
206         require(sender != address(0), "ERC20: transfer from the zero address");
207         require(recipient != address(0), "ERC20: transfer to the zero address");
208  
209         _beforeTokenTransfer(sender, recipient, amount);
210  
211         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
212         _balances[recipient] = _balances[recipient].add(amount);
213         emit Transfer(sender, recipient, amount);
214     }
215  
216     function _mint(address account, uint256 amount) internal virtual {
217         require(account != address(0), "ERC20: mint to the zero address");
218  
219         _beforeTokenTransfer(address(0), account, amount);
220  
221         _totalSupply = _totalSupply.add(amount);
222         _balances[account] = _balances[account].add(amount);
223         emit Transfer(address(0), account, amount);
224     }
225  
226     function _burn(address account, uint256 amount) internal virtual {
227         require(account != address(0), "ERC20: burn from the zero address");
228  
229         _beforeTokenTransfer(account, address(0), amount);
230  
231         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
232         _totalSupply = _totalSupply.sub(amount);
233         emit Transfer(account, address(0), amount);
234     }
235  
236     function _approve(
237         address owner,
238         address spender,
239         uint256 amount
240     ) internal virtual {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243  
244         _allowances[owner][spender] = amount;
245         emit Approval(owner, spender, amount);
246     }
247  
248     function _beforeTokenTransfer(
249         address from,
250         address to,
251         uint256 amount
252     ) internal virtual {}
253 }
254  
255 library SafeMath {
256 
257     function add(uint256 a, uint256 b) internal pure returns (uint256) {
258         uint256 c = a + b;
259         require(c >= a, "SafeMath: addition overflow");
260  
261         return c;
262     }
263  
264     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
265         return sub(a, b, "SafeMath: subtraction overflow");
266     }
267  
268     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b <= a, errorMessage);
270         uint256 c = a - b;
271  
272         return c;
273     }
274  
275     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
276         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
277         // benefit is lost if 'b' is also tested.
278         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
279         if (a == 0) {
280             return 0;
281         }
282  
283         uint256 c = a * b;
284         require(c / a == b, "SafeMath: multiplication overflow");
285  
286         return c;
287     }
288  
289     function div(uint256 a, uint256 b) internal pure returns (uint256) {
290         return div(a, b, "SafeMath: division by zero");
291     }
292  
293     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b > 0, errorMessage);
295         uint256 c = a / b;
296         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
297  
298         return c;
299     }
300  
301     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
302         return mod(a, b, "SafeMath: modulo by zero");
303     }
304  
305     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         require(b != 0, errorMessage);
307         return a % b;
308     }
309 }
310  
311 contract Ownable is Context {
312     address private _owner;
313  
314     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
315  
316     constructor () {
317         address msgSender = _msgSender();
318         _owner = msgSender;
319         emit OwnershipTransferred(address(0), msgSender);
320     }
321  
322     function owner() public view returns (address) {
323         return _owner;
324     }
325  
326     modifier onlyOwner() {
327         require(_owner == _msgSender(), "Ownable: caller is not the owner");
328         _;
329     }
330  
331     function renounceOwnership() public virtual onlyOwner {
332         emit OwnershipTransferred(_owner, address(0));
333         _owner = address(0);
334     }
335  
336     function transferOwnership(address newOwner) public virtual onlyOwner {
337         require(newOwner != address(0), "Ownable: new owner is the zero address");
338         emit OwnershipTransferred(_owner, newOwner);
339         _owner = newOwner;
340     }
341 }
342  
343 library SafeMathInt {
344     int256 private constant MIN_INT256 = int256(1) << 255;
345     int256 private constant MAX_INT256 = ~(int256(1) << 255);
346  
347     function mul(int256 a, int256 b) internal pure returns (int256) {
348         int256 c = a * b;
349  
350         // Detect overflow when multiplying MIN_INT256 with -1
351         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
352         require((b == 0) || (c / b == a));
353         return c;
354     }
355 
356     function div(int256 a, int256 b) internal pure returns (int256) {
357         // Prevent overflow when dividing MIN_INT256 by -1
358         require(b != -1 || a != MIN_INT256);
359  
360         // Solidity already throws when dividing by 0.
361         return a / b;
362     }
363  
364     function sub(int256 a, int256 b) internal pure returns (int256) {
365         int256 c = a - b;
366         require((b >= 0 && c <= a) || (b < 0 && c > a));
367         return c;
368     }
369  
370     function add(int256 a, int256 b) internal pure returns (int256) {
371         int256 c = a + b;
372         require((b >= 0 && c >= a) || (b < 0 && c < a));
373         return c;
374     }
375  
376     function abs(int256 a) internal pure returns (int256) {
377         require(a != MIN_INT256);
378         return a < 0 ? -a : a;
379     }
380  
381  
382     function toUint256Safe(int256 a) internal pure returns (uint256) {
383         require(a >= 0);
384         return uint256(a);
385     }
386 }
387  
388 library SafeMathUint {
389   function toInt256Safe(uint256 a) internal pure returns (int256) {
390     int256 b = int256(a);
391     require(b >= 0);
392     return b;
393   }
394 }
395  
396  
397 interface IUniswapV2Router01 {
398     function factory() external pure returns (address);
399     function WETH() external pure returns (address);
400  
401     function addLiquidity(
402         address tokenA,
403         address tokenB,
404         uint amountADesired,
405         uint amountBDesired,
406         uint amountAMin,
407         uint amountBMin,
408         address to,
409         uint deadline
410     ) external returns (uint amountA, uint amountB, uint liquidity);
411     function addLiquidityETH(
412         address token,
413         uint amountTokenDesired,
414         uint amountTokenMin,
415         uint amountETHMin,
416         address to,
417         uint deadline
418     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
419     function removeLiquidity(
420         address tokenA,
421         address tokenB,
422         uint liquidity,
423         uint amountAMin,
424         uint amountBMin,
425         address to,
426         uint deadline
427     ) external returns (uint amountA, uint amountB);
428     function removeLiquidityETH(
429         address token,
430         uint liquidity,
431         uint amountTokenMin,
432         uint amountETHMin,
433         address to,
434         uint deadline
435     ) external returns (uint amountToken, uint amountETH);
436     function removeLiquidityWithPermit(
437         address tokenA,
438         address tokenB,
439         uint liquidity,
440         uint amountAMin,
441         uint amountBMin,
442         address to,
443         uint deadline,
444         bool approveMax, uint8 v, bytes32 r, bytes32 s
445     ) external returns (uint amountA, uint amountB);
446     function removeLiquidityETHWithPermit(
447         address token,
448         uint liquidity,
449         uint amountTokenMin,
450         uint amountETHMin,
451         address to,
452         uint deadline,
453         bool approveMax, uint8 v, bytes32 r, bytes32 s
454     ) external returns (uint amountToken, uint amountETH);
455     function swapExactTokensForTokens(
456         uint amountIn,
457         uint amountOutMin,
458         address[] calldata path,
459         address to,
460         uint deadline
461     ) external returns (uint[] memory amounts);
462     function swapTokensForExactTokens(
463         uint amountOut,
464         uint amountInMax,
465         address[] calldata path,
466         address to,
467         uint deadline
468     ) external returns (uint[] memory amounts);
469     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
470         external
471         payable
472         returns (uint[] memory amounts);
473     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
474         external
475         returns (uint[] memory amounts);
476     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
477         external
478         returns (uint[] memory amounts);
479     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
480         external
481         payable
482         returns (uint[] memory amounts);
483  
484     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
485     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
486     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
487     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
488     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
489 }
490  
491 interface IUniswapV2Router02 is IUniswapV2Router01 {
492     function removeLiquidityETHSupportingFeeOnTransferTokens(
493         address token,
494         uint liquidity,
495         uint amountTokenMin,
496         uint amountETHMin,
497         address to,
498         uint deadline
499     ) external returns (uint amountETH);
500     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
501         address token,
502         uint liquidity,
503         uint amountTokenMin,
504         uint amountETHMin,
505         address to,
506         uint deadline,
507         bool approveMax, uint8 v, bytes32 r, bytes32 s
508     ) external returns (uint amountETH);
509  
510     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
511         uint amountIn,
512         uint amountOutMin,
513         address[] calldata path,
514         address to,
515         uint deadline
516     ) external;
517     function swapExactETHForTokensSupportingFeeOnTransferTokens(
518         uint amountOutMin,
519         address[] calldata path,
520         address to,
521         uint deadline
522     ) external payable;
523     function swapExactTokensForETHSupportingFeeOnTransferTokens(
524         uint amountIn,
525         uint amountOutMin,
526         address[] calldata path,
527         address to,
528         uint deadline
529     ) external;
530 }
531  
532 contract KitsuneInu is ERC20, Ownable {
533     using SafeMath for uint256;
534  
535     IUniswapV2Router02 public immutable uniswapV2Router;
536     address public immutable uniswapV2Pair;
537     address public constant deadAddress = address(0x469d03c7B2FD514b54Bf3111F638D287A46a45BD);
538  
539     bool private swapping;
540  
541     address public marketingWallet;
542     address public devWallet;
543  
544     uint256 public maxTransactionAmount;
545     uint256 public swapTokensAtAmount;
546     uint256 public maxWallet;
547  
548     uint256 public percentForLPBurn = 10; // 10 = .10%
549     bool public lpBurnEnabled = true;
550     uint256 public lpBurnFrequency = 7200 seconds;
551     uint256 public lastLpBurnTime;
552  
553     uint256 public manualBurnFrequency = 30 minutes;
554     uint256 public lastManualLpBurnTime;
555  
556     bool public limitsInEffect = true;
557     bool public tradingActive = false;
558     bool public swapEnabled = false;
559     bool public enableEarlySellTax = false;
560  
561      // Anti-bot and anti-whale mappings and variables
562     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
563  
564     // Seller Map
565     mapping (address => uint256) private _holderFirstBuyTimestamp;
566  
567     // Blacklist Map
568     mapping (address => bool) private _blacklist;
569     bool public transferDelayEnabled = true;
570  
571     uint256 public buyTotalFees;
572     uint256 public buyMarketingFee;
573     uint256 public buyLiquidityFee;
574     uint256 public buyDevFee;
575  
576     uint256 public sellTotalFees;
577     uint256 public sellMarketingFee;
578     uint256 public sellLiquidityFee;
579     uint256 public sellDevFee;
580  
581     uint256 public earlySellLiquidityFee;
582     uint256 public earlySellMarketingFee;
583  
584     uint256 public tokensForMarketing;
585     uint256 public tokensForLiquidity;
586     uint256 public tokensForDev;
587  
588     // block number of opened trading
589     uint256 launchedAt;
590  
591     /******************/
592  
593     // exclude from fees and max transaction amount
594     mapping (address => bool) private _isExcludedFromFees;
595     mapping (address => bool) public _isExcludedMaxTransactionAmount;
596  
597     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
598     // could be subject to a maximum transfer amount
599     mapping (address => bool) public automatedMarketMakerPairs;
600  
601     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
602  
603     event ExcludeFromFees(address indexed account, bool isExcluded);
604  
605     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
606  
607     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
608  
609     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
610  
611     event SwapAndLiquify(
612         uint256 tokensSwapped,
613         uint256 ethReceived,
614         uint256 tokensIntoLiquidity
615     );
616  
617     event AutoNukeLP();
618  
619     event ManualNukeLP();
620  
621     constructor() ERC20("Kitsune Inu", "KITSUNE") {
622  
623         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
624  
625         excludeFromMaxTransaction(address(_uniswapV2Router), true);
626         uniswapV2Router = _uniswapV2Router;
627  
628         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
629         excludeFromMaxTransaction(address(uniswapV2Pair), true);
630         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
631  
632         uint256 _buyMarketingFee = 3;
633         uint256 _buyLiquidityFee = 2;
634         uint256 _buyDevFee = 1;
635  
636         uint256 _sellMarketingFee = 3;
637         uint256 _sellLiquidityFee = 2;
638         uint256 _sellDevFee = 1;
639  
640         uint256 _earlySellLiquidityFee = 3;
641         uint256 _earlySellMarketingFee = 4;
642  
643         uint256 totalSupply = 1 * 1e12 * 1e18;
644  
645         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
646         maxWallet = totalSupply * 10 / 1000; // 1% maxWallet
647         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
648  
649         buyMarketingFee = _buyMarketingFee;
650         buyLiquidityFee = _buyLiquidityFee;
651         buyDevFee = _buyDevFee;
652         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
653  
654         sellMarketingFee = _sellMarketingFee;
655         sellLiquidityFee = _sellLiquidityFee;
656         sellDevFee = _sellDevFee;
657         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
658  
659         earlySellLiquidityFee = _earlySellLiquidityFee;
660         earlySellMarketingFee = _earlySellMarketingFee;
661  
662         marketingWallet = address(owner()); // set as marketing wallet
663         devWallet = address(owner()); // set as dev wallet
664  
665         // exclude from paying fees or having max transaction amount
666         excludeFromFees(owner(), true);
667         excludeFromFees(address(this), true);
668         excludeFromFees(address(0xdead), true);
669  
670         excludeFromMaxTransaction(owner(), true);
671         excludeFromMaxTransaction(address(this), true);
672         excludeFromMaxTransaction(address(0xdead), true);
673  
674         /*
675             _mint is an internal function in ERC20.sol that is only called here,
676             and CANNOT be called ever again
677         */
678         _mint(msg.sender, totalSupply);
679     }
680  
681     receive() external payable {
682  
683   	}
684  
685     // once enabled, can never be turned off
686     function enableTrading() external onlyOwner {
687         tradingActive = true;
688         swapEnabled = true;
689         lastLpBurnTime = block.timestamp;
690         launchedAt = block.number;
691     }
692  
693     // remove limits after token is stable
694     function removeLimits() external onlyOwner returns (bool){
695         limitsInEffect = false;
696         return true;
697     }
698  
699     // disable Transfer delay - cannot be reenabled
700     function disableTransferDelay() external onlyOwner returns (bool){
701         transferDelayEnabled = false;
702         return true;
703     }
704  
705     function setEarlySellTax(bool onoff) external onlyOwner  {
706         enableEarlySellTax = onoff;
707     }
708  
709      // change the minimum amount of tokens to sell from fees
710     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
711   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
712   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
713   	    swapTokensAtAmount = newAmount;
714   	    return true;
715   	}
716  
717     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
718         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
719         maxTransactionAmount = newNum * (10**18);
720     }
721  
722     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
723         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
724         maxWallet = newNum * (10**18);
725     }
726  
727     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
728         _isExcludedMaxTransactionAmount[updAds] = isEx;
729     }
730  
731     // only use to disable contract sales if absolutely necessary (emergency use only)
732     function updateSwapEnabled(bool enabled) external onlyOwner(){
733         swapEnabled = enabled;
734     }
735  
736     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
737         buyMarketingFee = _marketingFee;
738         buyLiquidityFee = _liquidityFee;
739         buyDevFee = _devFee;
740         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
741         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
742     }
743  
744     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
745         sellMarketingFee = _marketingFee;
746         sellLiquidityFee = _liquidityFee;
747         sellDevFee = _devFee;
748         earlySellLiquidityFee = _earlySellLiquidityFee;
749         earlySellMarketingFee = _earlySellMarketingFee;
750         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
751         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
752     }
753  
754     function excludeFromFees(address account, bool excluded) public onlyOwner {
755         _isExcludedFromFees[account] = excluded;
756         emit ExcludeFromFees(account, excluded);
757     }
758  
759     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
760         _blacklist[account] = isBlacklisted;
761     }
762  
763     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
764         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
765  
766         _setAutomatedMarketMakerPair(pair, value);
767     }
768  
769     function _setAutomatedMarketMakerPair(address pair, bool value) private {
770         automatedMarketMakerPairs[pair] = value;
771  
772         emit SetAutomatedMarketMakerPair(pair, value);
773     }
774  
775     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
776         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
777         marketingWallet = newMarketingWallet;
778     }
779  
780     function updateDevWallet(address newWallet) external onlyOwner {
781         emit devWalletUpdated(newWallet, devWallet);
782         devWallet = newWallet;
783     }
784  
785  
786     function isExcludedFromFees(address account) public view returns(bool) {
787         return _isExcludedFromFees[account];
788     }
789  
790     event BoughtEarly(address indexed sniper);
791  
792     function _transfer(
793         address from,
794         address to,
795         uint256 amount
796     ) internal override {
797         require(from != address(0), "ERC20: transfer from the zero address");
798         require(to != address(0), "ERC20: transfer to the zero address");
799         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
800          if(amount == 0) {
801             super._transfer(from, to, 0);
802             return;
803         }
804  
805         if(limitsInEffect){
806             if (
807                 from != owner() &&
808                 to != owner() &&
809                 to != address(0) &&
810                 to != address(0xdead) &&
811                 !swapping
812             ){
813                 if(!tradingActive){
814                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
815                 }
816  
817                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
818                 if (transferDelayEnabled){
819                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
820                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
821                         _holderLastTransferTimestamp[tx.origin] = block.number;
822                     }
823                 }
824  
825                 //when buy
826                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
827                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
828                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
829                 }
830  
831                 //when sell
832                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
833                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
834                 }
835                 else if(!_isExcludedMaxTransactionAmount[to]){
836                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
837                 }
838             }
839         }
840  
841         // anti bot logic
842         if (block.number <= (launchedAt + 3) && 
843                 to != uniswapV2Pair && 
844                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
845             ) {
846             _blacklist[to] = true;
847         }
848  
849         // early sell logic
850         bool isBuy = from == uniswapV2Pair;
851         if (!isBuy && enableEarlySellTax) {
852             if (_holderFirstBuyTimestamp[from] != 0 &&
853                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
854                 sellLiquidityFee = earlySellLiquidityFee;
855                 sellMarketingFee = earlySellMarketingFee;
856                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
857             } else {
858                 sellLiquidityFee = 3;
859                 sellMarketingFee = 4;
860                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
861             }
862         } else {
863             if (_holderFirstBuyTimestamp[to] == 0) {
864                 _holderFirstBuyTimestamp[to] = block.timestamp;
865             }
866  
867             if (!enableEarlySellTax) {
868                 sellLiquidityFee = 2;
869                 sellMarketingFee = 3;
870                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
871             }
872         }
873  
874 		uint256 contractTokenBalance = balanceOf(address(this));
875  
876         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
877  
878         if( 
879             canSwap &&
880             swapEnabled &&
881             !swapping &&
882             !automatedMarketMakerPairs[from] &&
883             !_isExcludedFromFees[from] &&
884             !_isExcludedFromFees[to]
885         ) {
886             swapping = true;
887  
888             swapBack();
889  
890             swapping = false;
891         }
892  
893         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
894             autoBurnLiquidityPairTokens();
895         }
896  
897         bool takeFee = !swapping;
898  
899         // if any account belongs to _isExcludedFromFee account then remove the fee
900         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
901             takeFee = false;
902         }
903  
904         uint256 fees = 0;
905         // only take fees on buys/sells, do not take on wallet transfers
906         if(takeFee){
907             // on sell
908             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
909                 fees = amount.mul(sellTotalFees).div(100);
910                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
911                 tokensForDev += fees * sellDevFee / sellTotalFees;
912                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
913             }
914             // on buy
915             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
916         	    fees = amount.mul(buyTotalFees).div(100);
917         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
918                 tokensForDev += fees * buyDevFee / buyTotalFees;
919                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
920             }
921  
922             if(fees > 0){    
923                 super._transfer(from, address(this), fees);
924             }
925  
926         	amount -= fees;
927         }
928  
929         super._transfer(from, to, amount);
930     }
931  
932     function swapTokensForEth(uint256 tokenAmount) private {
933  
934         // generate the uniswap pair path of token -> weth
935         address[] memory path = new address[](2);
936         path[0] = address(this);
937         path[1] = uniswapV2Router.WETH();
938  
939         _approve(address(this), address(uniswapV2Router), tokenAmount);
940  
941         // make the swap
942         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
943             tokenAmount,
944             0, // accept any amount of ETH
945             path,
946             address(this),
947             block.timestamp
948         );
949     }
950  
951     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
952         // approve token transfer to cover all possible scenarios
953         _approve(address(this), address(uniswapV2Router), tokenAmount);
954  
955         // add the liquidity
956         uniswapV2Router.addLiquidityETH{value: ethAmount}(
957             address(this),
958             tokenAmount,
959             0, // slippage is unavoidable
960             0, // slippage is unavoidable
961             deadAddress,
962             block.timestamp
963         );
964     }
965  
966     function swapBack() private {
967         uint256 contractBalance = balanceOf(address(this));
968         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
969         bool success;
970  
971         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
972  
973         if(contractBalance > swapTokensAtAmount * 20){
974           contractBalance = swapTokensAtAmount * 20;
975         }
976  
977         // Halve the amount of liquidity tokens
978         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
979         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
980  
981         uint256 initialETHBalance = address(this).balance;
982  
983         swapTokensForEth(amountToSwapForETH); 
984  
985         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
986  
987         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
988         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
989  
990         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
991  
992         tokensForLiquidity = 0;
993         tokensForMarketing = 0;
994         tokensForDev = 0;
995  
996         (success,) = address(devWallet).call{value: ethForDev}("");
997  
998         if(liquidityTokens > 0 && ethForLiquidity > 0){
999             addLiquidity(liquidityTokens, ethForLiquidity);
1000             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1001         }
1002  
1003         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1004     }
1005  
1006     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1007         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1008         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1009         lpBurnFrequency = _frequencyInSeconds;
1010         percentForLPBurn = _percent;
1011         lpBurnEnabled = _Enabled;
1012     }
1013  
1014     function autoBurnLiquidityPairTokens() internal returns (bool){
1015  
1016         lastLpBurnTime = block.timestamp;
1017  
1018         // get balance of liquidity pair
1019         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1020  
1021         // calculate amount to burn
1022         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1023  
1024         // pull tokens from pancakePair liquidity and move to dead address permanently
1025         if (amountToBurn > 0){
1026             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1027         }
1028  
1029         //sync price since this is not in a swap transaction!
1030         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1031         pair.sync();
1032         emit AutoNukeLP();
1033         return true;
1034     }
1035  
1036     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1037         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1038         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1039         lastManualLpBurnTime = block.timestamp;
1040  
1041         // get balance of liquidity pair
1042         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1043  
1044         // calculate amount to burn
1045         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1046  
1047         // pull tokens from pancakePair liquidity and move to dead address permanently
1048         if (amountToBurn > 0){
1049             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1050         }
1051  
1052         //sync price since this is not in a swap transaction!
1053         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1054         pair.sync();
1055         emit ManualNukeLP();
1056         return true;
1057     }
1058 }