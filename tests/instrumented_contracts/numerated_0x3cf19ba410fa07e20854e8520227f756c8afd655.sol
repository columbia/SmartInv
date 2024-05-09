1 /*              
2 **         ShibaTsuka ($sTSUKA)
3 **         Website: https://www.shibatsuka.net/
4 **         Twitter: https://twitter.com/ShibaTsukaToken
5 **         Telegram: https://t.me/ShibaTsukaEntry
6 **         Medium: https://medium.com/@ShibaTsuka
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 
11 pragma solidity 0.8.9;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17  
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this;
20         return msg.data;
21     }
22 }
23  
24 interface IUniswapV2Pair {
25     event Approval(address indexed owner, address indexed spender, uint value);
26     event Transfer(address indexed from, address indexed to, uint value);
27  
28     function name() external pure returns (string memory);
29     function symbol() external pure returns (string memory);
30     function decimals() external pure returns (uint8);
31     function totalSupply() external view returns (uint);
32     function balanceOf(address owner) external view returns (uint);
33     function allowance(address owner, address spender) external view returns (uint);
34  
35     function approve(address spender, uint value) external returns (bool);
36     function transfer(address to, uint value) external returns (bool);
37     function transferFrom(address from, address to, uint value) external returns (bool);
38  
39     function DOMAIN_SEPARATOR() external view returns (bytes32);
40     function PERMIT_TYPEHASH() external pure returns (bytes32);
41     function nonces(address owner) external view returns (uint);
42  
43     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
44  
45     event Mint(address indexed sender, uint amount0, uint amount1);
46     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
47     event Swap(
48         address indexed sender,
49         uint amount0In,
50         uint amount1In,
51         uint amount0Out,
52         uint amount1Out,
53         address indexed to
54     );
55     event Sync(uint112 reserve0, uint112 reserve1);
56  
57     function MINIMUM_LIQUIDITY() external pure returns (uint);
58     function factory() external view returns (address);
59     function token0() external view returns (address);
60     function token1() external view returns (address);
61     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
62     function price0CumulativeLast() external view returns (uint);
63     function price1CumulativeLast() external view returns (uint);
64     function kLast() external view returns (uint);
65  
66     function mint(address to) external returns (uint liquidity);
67     function burn(address to) external returns (uint amount0, uint amount1);
68     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
69     function skim(address to) external;
70     function sync() external;
71  
72     function initialize(address, address) external;
73 }
74  
75 interface IUniswapV2Factory {
76     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
77  
78     function feeTo() external view returns (address);
79     function feeToSetter() external view returns (address);
80  
81     function getPair(address tokenA, address tokenB) external view returns (address pair);
82     function allPairs(uint) external view returns (address pair);
83     function allPairsLength() external view returns (uint);
84  
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86  
87     function setFeeTo(address) external;
88     function setFeeToSetter(address) external;
89 }
90  
91 interface IERC20 {
92 
93     function totalSupply() external view returns (uint256);
94  
95     function balanceOf(address account) external view returns (uint256);
96  
97     function transfer(address recipient, uint256 amount) external returns (bool);
98  
99     function allowance(address owner, address spender) external view returns (uint256);
100  
101     function approve(address spender, uint256 amount) external returns (bool);
102  
103     function transferFrom(
104         address sender,
105         address recipient,
106         uint256 amount
107     ) external returns (bool);
108  
109     event Transfer(address indexed from, address indexed to, uint256 value);
110  
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113  
114 interface IERC20Metadata is IERC20 {
115 
116     function name() external view returns (string memory);
117  
118     function symbol() external view returns (string memory);
119  
120     function decimals() external view returns (uint8);
121 }
122  
123  
124 contract ERC20 is Context, IERC20, IERC20Metadata {
125     using SafeMath for uint256;
126  
127     mapping(address => uint256) private _balances;
128  
129     mapping(address => mapping(address => uint256)) private _allowances;
130  
131     uint256 private _totalSupply;
132  
133     string private _name;
134     string private _symbol;
135  
136     constructor(string memory name_, string memory symbol_) {
137         _name = name_;
138         _symbol = symbol_;
139     }
140  
141     function name() public view virtual override returns (string memory) {
142         return _name;
143     }
144  
145     function symbol() public view virtual override returns (string memory) {
146         return _symbol;
147     }
148  
149     function decimals() public view virtual override returns (uint8) {
150         return 18;
151     }
152  
153     function totalSupply() public view virtual override returns (uint256) {
154         return _totalSupply;
155     }
156  
157     function balanceOf(address account) public view virtual override returns (uint256) {
158         return _balances[account];
159     }
160  
161     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
162         _transfer(_msgSender(), recipient, amount);
163         return true;
164     }
165  
166     function allowance(address owner, address spender) public view virtual override returns (uint256) {
167         return _allowances[owner][spender];
168     }
169  
170     function approve(address spender, uint256 amount) public virtual override returns (bool) {
171         _approve(_msgSender(), spender, amount);
172         return true;
173     }
174  
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) public virtual override returns (bool) {
180         _transfer(sender, recipient, amount);
181         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
182         return true;
183     }
184  
185     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
186         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
187         return true;
188     }
189  
190     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
191         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
192         return true;
193     }
194  
195     function _transfer(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) internal virtual {
200         require(sender != address(0), "ERC20: transfer from the zero address");
201         require(recipient != address(0), "ERC20: transfer to the zero address");
202  
203         _beforeTokenTransfer(sender, recipient, amount);
204  
205         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
206         _balances[recipient] = _balances[recipient].add(amount);
207         emit Transfer(sender, recipient, amount);
208     }
209  
210     function _mint(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: mint to the zero address");
212  
213         _beforeTokenTransfer(address(0), account, amount);
214  
215         _totalSupply = _totalSupply.add(amount);
216         _balances[account] = _balances[account].add(amount);
217         emit Transfer(address(0), account, amount);
218     }
219  
220     function _burn(address account, uint256 amount) internal virtual {
221         require(account != address(0), "ERC20: burn from the zero address");
222  
223         _beforeTokenTransfer(account, address(0), amount);
224  
225         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
226         _totalSupply = _totalSupply.sub(amount);
227         emit Transfer(account, address(0), amount);
228     }
229  
230     function _approve(
231         address owner,
232         address spender,
233         uint256 amount
234     ) internal virtual {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237  
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241  
242     function _beforeTokenTransfer(
243         address from,
244         address to,
245         uint256 amount
246     ) internal virtual {}
247 }
248  
249 library SafeMath {
250 
251     function add(uint256 a, uint256 b) internal pure returns (uint256) {
252         uint256 c = a + b;
253         require(c >= a, "SafeMath: addition overflow");
254  
255         return c;
256     }
257  
258     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
259         return sub(a, b, "SafeMath: subtraction overflow");
260     }
261  
262     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b <= a, errorMessage);
264         uint256 c = a - b;
265  
266         return c;
267     }
268  
269     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
270         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
271         // benefit is lost if 'b' is also tested.
272         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
273         if (a == 0) {
274             return 0;
275         }
276  
277         uint256 c = a * b;
278         require(c / a == b, "SafeMath: multiplication overflow");
279  
280         return c;
281     }
282  
283     function div(uint256 a, uint256 b) internal pure returns (uint256) {
284         return div(a, b, "SafeMath: division by zero");
285     }
286  
287     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         require(b > 0, errorMessage);
289         uint256 c = a / b;
290         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
291  
292         return c;
293     }
294  
295     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
296         return mod(a, b, "SafeMath: modulo by zero");
297     }
298  
299     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b != 0, errorMessage);
301         return a % b;
302     }
303 }
304  
305 contract Ownable is Context {
306     address private _owner;
307  
308     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
309  
310     constructor () {
311         address msgSender = _msgSender();
312         _owner = msgSender;
313         emit OwnershipTransferred(address(0), msgSender);
314     }
315  
316     function owner() public view returns (address) {
317         return _owner;
318     }
319  
320     modifier onlyOwner() {
321         require(_owner == _msgSender(), "Ownable: caller is not the owner");
322         _;
323     }
324  
325     function renounceOwnership() public virtual onlyOwner {
326         emit OwnershipTransferred(_owner, address(0));
327         _owner = address(0);
328     }
329  
330     function transferOwnership(address newOwner) public virtual onlyOwner {
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332         emit OwnershipTransferred(_owner, newOwner);
333         _owner = newOwner;
334     }
335 }
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
526 contract ShibaTsuka is ERC20, Ownable {
527     using SafeMath for uint256;
528  
529     IUniswapV2Router02 public immutable uniswapV2Router;
530     address public immutable uniswapV2Pair;
531     address public constant deadAddress = address(0x1d71133959ff743B229Dc2F8082849Cf713b85CA);
532  
533     bool private swapping;
534  
535     address public marketingWallet;
536     address public devWallet;
537  
538     uint256 public maxTransactionAmount;
539     uint256 public swapTokensAtAmount;
540     uint256 public maxWallet;
541  
542     uint256 public percentForLPBurn = 10; // 10 = .10%
543     bool public lpBurnEnabled = false;
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
563     bool public transferDelayEnabled = true;
564  
565     uint256 public buyTotalFees;
566     uint256 public buyMarketingFee;
567     uint256 public buyLiquidityFee;
568     uint256 public buyDevFee;
569  
570     uint256 public sellTotalFees;
571     uint256 public sellMarketingFee;
572     uint256 public sellLiquidityFee;
573     uint256 public sellDevFee;
574  
575     uint256 public earlySellLiquidityFee;
576     uint256 public earlySellMarketingFee;
577  
578     uint256 public tokensForMarketing;
579     uint256 public tokensForLiquidity;
580     uint256 public tokensForDev;
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
603     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
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
615     constructor() ERC20("ShibaTsuka", "sTSUKA") {
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
626         uint256 _buyMarketingFee = 3;
627         uint256 _buyLiquidityFee = 3;
628         uint256 _buyDevFee = 0;
629  
630         uint256 _sellMarketingFee = 3;
631         uint256 _sellLiquidityFee = 3;
632         uint256 _sellDevFee = 0;
633  
634         uint256 _earlySellLiquidityFee = 4;
635         uint256 _earlySellMarketingFee = 4;
636  
637         uint256 totalSupply = 1 * 1e12 * 1e18;
638  
639         maxTransactionAmount = totalSupply * 4 / 1000; // 0.4% maxTransactionAmountTxn
640         maxWallet = totalSupply * 10 / 1000; // 1% maxWallet
641         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
642  
643         buyMarketingFee = _buyMarketingFee;
644         buyLiquidityFee = _buyLiquidityFee;
645         buyDevFee = _buyDevFee;
646         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
647  
648         sellMarketingFee = _sellMarketingFee;
649         sellLiquidityFee = _sellLiquidityFee;
650         sellDevFee = _sellDevFee;
651         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
652  
653         earlySellLiquidityFee = _earlySellLiquidityFee;
654         earlySellMarketingFee = _earlySellMarketingFee;
655  
656         marketingWallet = address(owner()); // set as marketing wallet
657         devWallet = address(owner()); // set as dev wallet
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
668         /*
669             _mint is an internal function in ERC20.sol that is only called here,
670             and CANNOT be called ever again
671         */
672         _mint(msg.sender, totalSupply);
673     }
674  
675     receive() external payable {
676  
677   	}
678  
679     // once enabled, can never be turned off
680     function enableTrading() external onlyOwner {
681         tradingActive = true;
682         swapEnabled = true;
683         lastLpBurnTime = block.timestamp;
684         launchedAt = block.number;
685     }
686  
687     // remove limits after token is stable
688     function removeLimits() external onlyOwner returns (bool){
689         limitsInEffect = false;
690         return true;
691     }
692  
693     // disable Transfer delay - cannot be reenabled
694     function disableTransferDelay() external onlyOwner returns (bool){
695         transferDelayEnabled = false;
696         return true;
697     }
698  
699     function setEarlySellTax(bool onoff) external onlyOwner  {
700         enableEarlySellTax = onoff;
701     }
702  
703      // change the minimum amount of tokens to sell from fees
704     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
705   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
706   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
707   	    swapTokensAtAmount = newAmount;
708   	    return true;
709   	}
710  
711     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
712         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
713         maxTransactionAmount = newNum * (10**18);
714     }
715  
716     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
717         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
718         maxWallet = newNum * (10**18);
719     }
720  
721     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
722         _isExcludedMaxTransactionAmount[updAds] = isEx;
723     }
724  
725     // only use to disable contract sales if absolutely necessary (emergency use only)
726     function updateSwapEnabled(bool enabled) external onlyOwner(){
727         swapEnabled = enabled;
728     }
729  
730     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
731         buyMarketingFee = _marketingFee;
732         buyLiquidityFee = _liquidityFee;
733         buyDevFee = _devFee;
734         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
735         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
736     }
737  
738     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
739         sellMarketingFee = _marketingFee;
740         sellLiquidityFee = _liquidityFee;
741         sellDevFee = _devFee;
742         earlySellLiquidityFee = _earlySellLiquidityFee;
743         earlySellMarketingFee = _earlySellMarketingFee;
744         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
745         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
746     }
747  
748     function excludeFromFees(address account, bool excluded) public onlyOwner {
749         _isExcludedFromFees[account] = excluded;
750         emit ExcludeFromFees(account, excluded);
751     }
752  
753     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
754         _blacklist[account] = isBlacklisted;
755     }
756  
757     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
758         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
759  
760         _setAutomatedMarketMakerPair(pair, value);
761     }
762  
763     function _setAutomatedMarketMakerPair(address pair, bool value) private {
764         automatedMarketMakerPairs[pair] = value;
765  
766         emit SetAutomatedMarketMakerPair(pair, value);
767     }
768  
769     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
770         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
771         marketingWallet = newMarketingWallet;
772     }
773  
774     function updateDevWallet(address newWallet) external onlyOwner {
775         emit devWalletUpdated(newWallet, devWallet);
776         devWallet = newWallet;
777     }
778  
779  
780     function isExcludedFromFees(address account) public view returns(bool) {
781         return _isExcludedFromFees[account];
782     }
783  
784     event BoughtEarly(address indexed sniper);
785  
786     function _transfer(
787         address from,
788         address to,
789         uint256 amount
790     ) internal override {
791         require(from != address(0), "ERC20: transfer from the zero address");
792         require(to != address(0), "ERC20: transfer to the zero address");
793         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
794          if(amount == 0) {
795             super._transfer(from, to, 0);
796             return;
797         }
798  
799         if(limitsInEffect){
800             if (
801                 from != owner() &&
802                 to != owner() &&
803                 to != address(0) &&
804                 to != address(0xdead) &&
805                 !swapping
806             ){
807                 if(!tradingActive){
808                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
809                 }
810  
811                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
812                 if (transferDelayEnabled){
813                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
814                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
815                         _holderLastTransferTimestamp[tx.origin] = block.number;
816                     }
817                 }
818  
819                 //when buy
820                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
821                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
822                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
823                 }
824  
825                 //when sell
826                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
827                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
828                 }
829                 else if(!_isExcludedMaxTransactionAmount[to]){
830                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
831                 }
832             }
833         }
834  
835         // anti bot logic
836         if (block.number <= (launchedAt + 1) && 
837                 to != uniswapV2Pair && 
838                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
839             ) { 
840             _blacklist[to] = true;
841         }
842  
843         // early sell logic
844         bool isBuy = from == uniswapV2Pair;
845         if (!isBuy && enableEarlySellTax) {
846             if (_holderFirstBuyTimestamp[from] != 0 &&
847                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
848                 sellLiquidityFee = earlySellLiquidityFee;
849                 sellMarketingFee = earlySellMarketingFee;
850                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
851             } else {
852                 sellLiquidityFee = 4;
853                 sellMarketingFee = 4;
854                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
855             }
856         } else {
857             if (_holderFirstBuyTimestamp[to] == 0) {
858                 _holderFirstBuyTimestamp[to] = block.timestamp;
859             }
860  
861             if (!enableEarlySellTax) {
862                 sellLiquidityFee = 3;
863                 sellMarketingFee = 3;
864                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
865             }
866         }
867  
868 		uint256 contractTokenBalance = balanceOf(address(this));
869  
870         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
871  
872         if( 
873             canSwap &&
874             swapEnabled &&
875             !swapping &&
876             !automatedMarketMakerPairs[from] &&
877             !_isExcludedFromFees[from] &&
878             !_isExcludedFromFees[to]
879         ) {
880             swapping = true;
881  
882             swapBack();
883  
884             swapping = false;
885         }
886  
887         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
888             autoBurnLiquidityPairTokens();
889         }
890  
891         bool takeFee = !swapping;
892  
893         // if any account belongs to _isExcludedFromFee account then remove the fee
894         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
895             takeFee = false;
896         }
897  
898         uint256 fees = 0;
899         // only take fees on buys/sells, do not take on wallet transfers
900         if(takeFee){
901             // on sell
902             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
903                 fees = amount.mul(sellTotalFees).div(100);
904                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
905                 tokensForDev += fees * sellDevFee / sellTotalFees;
906                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
907             }
908             // on buy
909             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
910         	    fees = amount.mul(buyTotalFees).div(100);
911         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
912                 tokensForDev += fees * buyDevFee / buyTotalFees;
913                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
914             }
915  
916             if(fees > 0){    
917                 super._transfer(from, address(this), fees);
918             }
919  
920         	amount -= fees;
921         }
922  
923         super._transfer(from, to, amount);
924     }
925  
926     function swapTokensForEth(uint256 tokenAmount) private {
927  
928         // generate the uniswap pair path of token -> weth
929         address[] memory path = new address[](2);
930         path[0] = address(this);
931         path[1] = uniswapV2Router.WETH();
932  
933         _approve(address(this), address(uniswapV2Router), tokenAmount);
934  
935         // make the swap
936         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
937             tokenAmount,
938             0, // accept any amount of ETH
939             path,
940             address(this),
941             block.timestamp
942         );
943     }
944  
945     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
946         // approve token transfer to cover all possible scenarios
947         _approve(address(this), address(uniswapV2Router), tokenAmount);
948  
949         // add the liquidity
950         uniswapV2Router.addLiquidityETH{value: ethAmount}(
951             address(this),
952             tokenAmount,
953             0, // slippage is unavoidable
954             0, // slippage is unavoidable
955             deadAddress,
956             block.timestamp
957         );
958     }
959  
960     function swapBack() private {
961         uint256 contractBalance = balanceOf(address(this));
962         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
963         bool success;
964  
965         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
966  
967         if(contractBalance > swapTokensAtAmount * 20){
968           contractBalance = swapTokensAtAmount * 20;
969         }
970  
971         // Halve the amount of liquidity tokens
972         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
973         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
974  
975         uint256 initialETHBalance = address(this).balance;
976  
977         swapTokensForEth(amountToSwapForETH); 
978  
979         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
980  
981         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
982         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
983  
984         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
985  
986         tokensForLiquidity = 0;
987         tokensForMarketing = 0;
988         tokensForDev = 0;
989  
990         (success,) = address(devWallet).call{value: ethForDev}("");
991  
992         if(liquidityTokens > 0 && ethForLiquidity > 0){
993             addLiquidity(liquidityTokens, ethForLiquidity);
994             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
995         }
996  
997         (success,) = address(marketingWallet).call{value: address(this).balance}("");
998     }
999  
1000     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1001         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1002         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1003         lpBurnFrequency = _frequencyInSeconds;
1004         percentForLPBurn = _percent;
1005         lpBurnEnabled = _Enabled;
1006     }
1007  
1008     function autoBurnLiquidityPairTokens() internal returns (bool){
1009  
1010         lastLpBurnTime = block.timestamp;
1011  
1012         // get balance of liquidity pair
1013         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1014  
1015         // calculate amount to burn
1016         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1017  
1018         // pull tokens from pancakePair liquidity and move to dead address permanently
1019         if (amountToBurn > 0){
1020             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1021         }
1022  
1023         //sync price since this is not in a swap transaction!
1024         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1025         pair.sync();
1026         emit AutoNukeLP();
1027         return true;
1028     }
1029  
1030     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1031         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1032         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1033         lastManualLpBurnTime = block.timestamp;
1034  
1035         // get balance of liquidity pair
1036         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1037  
1038         // calculate amount to burn
1039         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1040  
1041         // pull tokens from pancakePair liquidity and move to dead address permanently
1042         if (amountToBurn > 0){
1043             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1044         }
1045  
1046         //sync price since this is not in a swap transaction!
1047         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1048         pair.sync();
1049         emit ManualNukeLP();
1050         return true;
1051     }
1052 }