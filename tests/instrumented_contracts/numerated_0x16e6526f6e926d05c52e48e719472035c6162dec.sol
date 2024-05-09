1 /*
2 
3                       )        (     
4                (   ( /(  (     )\ )  
5                )\  )\()) )\   (()/(  
6              (((_)((_)((((_)(  /(_)) 
7              )\___ _((_)\ _ )\(_))   
8             ((/ __| || (_)_\(_) _ \  
9             | (__| __ |/ _ \ |   /  
10              \___|_||_/_/ \_\|_|_\  
11                          
12 
13   in the fire of destruction, we find the spark of creation,
14           burning down to build something better
15 
16                  https://char.black
17 
18 
19 
20 
21 
22 */
23 
24 
25 // SPDX-License-Identifier: MIT
26 pragma solidity 0.8.21;
27  
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32  
33     function _msgData() internal view virtual returns (bytes calldata) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38  
39 interface IUniswapV2Pair {
40     event Approval(address indexed owner, address indexed spender, uint value);
41     event Transfer(address indexed from, address indexed to, uint value);
42  
43     function name() external pure returns (string memory);
44     function symbol() external pure returns (string memory);
45     function decimals() external pure returns (uint8);
46     function totalSupply() external view returns (uint);
47     function balanceOf(address owner) external view returns (uint);
48     function allowance(address owner, address spender) external view returns (uint);
49  
50     function approve(address spender, uint value) external returns (bool);
51     function transfer(address to, uint value) external returns (bool);
52     function transferFrom(address from, address to, uint value) external returns (bool);
53  
54     function DOMAIN_SEPARATOR() external view returns (bytes32);
55     function PERMIT_TYPEHASH() external pure returns (bytes32);
56     function nonces(address owner) external view returns (uint);
57  
58     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
59  
60     event Mint(address indexed sender, uint amount0, uint amount1);
61     event Swap(
62         address indexed sender,
63         uint amount0In,
64         uint amount1In,
65         uint amount0Out,
66         uint amount1Out,
67         address indexed to
68     );
69     event Sync(uint112 reserve0, uint112 reserve1);
70  
71     function MINIMUM_LIQUIDITY() external pure returns (uint);
72     function factory() external view returns (address);
73     function token0() external view returns (address);
74     function token1() external view returns (address);
75     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
76     function price0CumulativeLast() external view returns (uint);
77     function price1CumulativeLast() external view returns (uint);
78     function kLast() external view returns (uint);
79  
80     function mint(address to) external returns (uint liquidity);
81     function burn(address to) external returns (uint amount0, uint amount1);
82     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
83     function skim(address to) external;
84     function sync() external;
85  
86     function initialize(address, address) external;
87 }
88  
89 interface IUniswapV2Factory {
90     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
91  
92     function feeTo() external view returns (address);
93     function feeToSetter() external view returns (address);
94  
95     function getPair(address tokenA, address tokenB) external view returns (address pair);
96     function allPairs(uint) external view returns (address pair);
97     function allPairsLength() external view returns (uint);
98  
99     function createPair(address tokenA, address tokenB) external returns (address pair);
100  
101     function setFeeTo(address) external;
102     function setFeeToSetter(address) external;
103 }
104  
105 interface IERC20 {
106     function totalSupply() external view returns (uint256);
107     function balanceOf(address account) external view returns (uint256);
108     function transfer(address recipient, uint256 amount) external returns (bool);
109     function allowance(address owner, address spender) external view returns (uint256);
110     function approve(address spender, uint256 amount) external returns (bool);
111     function transferFrom(
112         address sender,
113         address recipient,
114         uint256 amount
115     ) external returns (bool);
116     event Transfer(address indexed from, address indexed to, uint256 value);
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119  
120 interface IERC20Metadata is IERC20 {
121     function name() external view returns (string memory);
122     function symbol() external view returns (string memory);
123     function decimals() external view returns (uint8);
124 }
125  
126  
127 contract ERC20 is Context, IERC20, IERC20Metadata {
128     using SafeMath for uint256;
129     mapping(address => uint256) private _balances;
130     mapping(address => mapping(address => uint256)) private _allowances;
131     uint256 private _totalSupply;
132     string private _name;
133     string private _symbol;
134     constructor(string memory name_, string memory symbol_) {
135         _name = name_;
136         _symbol = symbol_;
137     }
138     function name() public view virtual override returns (string memory) {
139         return _name;
140     }
141     function symbol() public view virtual override returns (string memory) {
142         return _symbol;
143     }
144     function decimals() public view virtual override returns (uint8) {
145         return 18;
146     }
147     function totalSupply() public view virtual override returns (uint256) {
148         return _totalSupply;
149     }
150     function balanceOf(address account) public view virtual override returns (uint256) {
151         return _balances[account];
152     }
153     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
154         _transfer(_msgSender(), recipient, amount);
155         return true;
156     }
157     function allowance(address owner, address spender) public view virtual override returns (uint256) {
158         return _allowances[owner][spender];
159     }
160     function approve(address spender, uint256 amount) public virtual override returns (bool) {
161         _approve(_msgSender(), spender, amount);
162         return true;
163     }
164     function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) public virtual override returns (bool) {
169         _transfer(sender, recipient, amount);
170         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
171         return true;
172     }
173     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
175         return true;
176     }
177     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
178         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
179         return true;
180     }
181     function _transfer(
182         address sender,
183         address recipient,
184         uint256 amount
185     ) internal virtual {
186         require(sender != address(0), "ERC20: transfer from the zero address");
187         require(recipient != address(0), "ERC20: transfer to the zero address");
188  
189         _beforeTokenTransfer(sender, recipient, amount);
190  
191         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
192         _balances[recipient] = _balances[recipient].add(amount);
193         emit Transfer(sender, recipient, amount);
194     }
195     function _mint(address account, uint256 amount) internal virtual {
196         require(account != address(0), "ERC20: mint to the zero address");
197  
198         _beforeTokenTransfer(address(0), account, amount);
199  
200         _totalSupply = _totalSupply.add(amount);
201         _balances[account] = _balances[account].add(amount);
202         emit Transfer(address(0), account, amount);
203     }
204     function _burn(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: burn from the zero address");
206  
207         _beforeTokenTransfer(account, address(0), amount);
208  
209         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
210         _totalSupply = _totalSupply.sub(amount);
211         emit Transfer(account, address(0), amount);
212     }
213     function _approve(
214         address owner,
215         address spender,
216         uint256 amount
217     ) internal virtual {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220  
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224     function _beforeTokenTransfer(
225         address from,
226         address to,
227         uint256 amount
228     ) internal virtual {}
229 }
230  
231 library SafeMath {
232     function add(uint256 a, uint256 b) internal pure returns (uint256) {
233         uint256 c = a + b;
234         require(c >= a, "SafeMath: addition overflow");
235  
236         return c;
237     }
238     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
239         return sub(a, b, "SafeMath: subtraction overflow");
240     }
241     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b <= a, errorMessage);
243         uint256 c = a - b;
244  
245         return c;
246     }
247     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
248         if (a == 0) {
249             return 0;
250         }
251  
252         uint256 c = a * b;
253         require(c / a == b, "SafeMath: multiplication overflow");
254  
255         return c;
256     }
257     function div(uint256 a, uint256 b) internal pure returns (uint256) {
258         return div(a, b, "SafeMath: division by zero");
259     }
260     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b > 0, errorMessage);
262         uint256 c = a / b;
263         return c;
264     }
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         return mod(a, b, "SafeMath: modulo by zero");
267     }
268     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 }
273  
274 contract Ownable is Context {
275     address private _owner;
276  
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278     constructor () {
279         address msgSender = _msgSender();
280         _owner = msgSender;
281         emit OwnershipTransferred(address(0), msgSender);
282     }
283     function owner() public view returns (address) {
284         return _owner;
285     }
286     modifier onlyOwner() {
287         require(_owner == _msgSender(), "Ownable: caller is not the owner");
288         _;
289     }
290     function renounceOwnership() public virtual onlyOwner {
291         emit OwnershipTransferred(_owner, address(0));
292         _owner = address(0);
293     }
294     function transferOwnership(address newOwner) public virtual onlyOwner {
295         require(newOwner != address(0), "Ownable: new owner is the zero address");
296         emit OwnershipTransferred(_owner, newOwner);
297         _owner = newOwner;
298     }
299 }
300  
301 library SafeMathInt {
302     int256 private constant MIN_INT256 = int256(1) << 255;
303     int256 private constant MAX_INT256 = ~(int256(1) << 255);
304  
305     function mul(int256 a, int256 b) internal pure returns (int256) {
306         int256 c = a * b;
307  
308         // Detect overflow when multiplying MIN_INT256 with -1
309         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
310         require((b == 0) || (c / b == a));
311         return c;
312     }
313 
314     function div(int256 a, int256 b) internal pure returns (int256) {
315         // Prevent overflow when dividing MIN_INT256 by -1
316         require(b != -1 || a != MIN_INT256);
317  
318         // Solidity already throws when dividing by 0.
319         return a / b;
320     }
321  
322     /**
323      * @dev Subtracts two int256 variables and fails on overflow.
324      */
325     function sub(int256 a, int256 b) internal pure returns (int256) {
326         int256 c = a - b;
327         require((b >= 0 && c <= a) || (b < 0 && c > a));
328         return c;
329     }
330  
331     /**
332      * @dev Adds two int256 variables and fails on overflow.
333      */
334     function add(int256 a, int256 b) internal pure returns (int256) {
335         int256 c = a + b;
336         require((b >= 0 && c >= a) || (b < 0 && c < a));
337         return c;
338     }
339  
340     /**
341      * @dev Converts to absolute value, and fails on overflow.
342      */
343     function abs(int256 a) internal pure returns (int256) {
344         require(a != MIN_INT256);
345         return a < 0 ? -a : a;
346     }
347  
348  
349     function toUint256Safe(int256 a) internal pure returns (uint256) {
350         require(a >= 0);
351         return uint256(a);
352     }
353 }
354  
355 library SafeMathUint {
356   function toInt256Safe(uint256 a) internal pure returns (int256) {
357     int256 b = int256(a);
358     require(b >= 0);
359     return b;
360   }
361 }
362  
363  
364 interface IUniswapV2Router01 {
365     function factory() external pure returns (address);
366     function WETH() external pure returns (address);
367  
368     function addLiquidity(
369         address tokenA,
370         address tokenB,
371         uint amountADesired,
372         uint amountBDesired,
373         uint amountAMin,
374         uint amountBMin,
375         address to,
376         uint deadline
377     ) external returns (uint amountA, uint amountB, uint liquidity);
378     function addLiquidityETH(
379         address token,
380         uint amountTokenDesired,
381         uint amountTokenMin,
382         uint amountETHMin,
383         address to,
384         uint deadline
385     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
386     function removeLiquidity(
387         address tokenA,
388         address tokenB,
389         uint liquidity,
390         uint amountAMin,
391         uint amountBMin,
392         address to,
393         uint deadline
394     ) external returns (uint amountA, uint amountB);
395     function removeLiquidityETH(
396         address token,
397         uint liquidity,
398         uint amountTokenMin,
399         uint amountETHMin,
400         address to,
401         uint deadline
402     ) external returns (uint amountToken, uint amountETH);
403     function removeLiquidityWithPermit(
404         address tokenA,
405         address tokenB,
406         uint liquidity,
407         uint amountAMin,
408         uint amountBMin,
409         address to,
410         uint deadline,
411         bool approveMax, uint8 v, bytes32 r, bytes32 s
412     ) external returns (uint amountA, uint amountB);
413     function removeLiquidityETHWithPermit(
414         address token,
415         uint liquidity,
416         uint amountTokenMin,
417         uint amountETHMin,
418         address to,
419         uint deadline,
420         bool approveMax, uint8 v, bytes32 r, bytes32 s
421     ) external returns (uint amountToken, uint amountETH);
422     function swapExactTokensForTokens(
423         uint amountIn,
424         uint amountOutMin,
425         address[] calldata path,
426         address to,
427         uint deadline
428     ) external returns (uint[] memory amounts);
429     function swapTokensForExactTokens(
430         uint amountOut,
431         uint amountInMax,
432         address[] calldata path,
433         address to,
434         uint deadline
435     ) external returns (uint[] memory amounts);
436     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
437         external
438         payable
439         returns (uint[] memory amounts);
440     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
441         external
442         returns (uint[] memory amounts);
443     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
444         external
445         returns (uint[] memory amounts);
446     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
447         external
448         payable
449         returns (uint[] memory amounts);
450  
451     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
452     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
453     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
454     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
455     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
456 }
457  
458 interface IUniswapV2Router02 is IUniswapV2Router01 {
459     function removeLiquidityETHSupportingFeeOnTransferTokens(
460         address token,
461         uint liquidity,
462         uint amountTokenMin,
463         uint amountETHMin,
464         address to,
465         uint deadline
466     ) external returns (uint amountETH);
467     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
468         address token,
469         uint liquidity,
470         uint amountTokenMin,
471         uint amountETHMin,
472         address to,
473         uint deadline,
474         bool approveMax, uint8 v, bytes32 r, bytes32 s
475     ) external returns (uint amountETH);
476  
477     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
478         uint amountIn,
479         uint amountOutMin,
480         address[] calldata path,
481         address to,
482         uint deadline
483     ) external;
484     function swapExactETHForTokensSupportingFeeOnTransferTokens(
485         uint amountOutMin,
486         address[] calldata path,
487         address to,
488         uint deadline
489     ) external payable;
490     function swapExactTokensForETHSupportingFeeOnTransferTokens(
491         uint amountIn,
492         uint amountOutMin,
493         address[] calldata path,
494         address to,
495         uint deadline
496     ) external;
497 }
498  
499 contract CHARTOKEN is ERC20, Ownable {
500     using SafeMath for uint256;
501  
502     IUniswapV2Router02 public immutable uniswapV2Router;
503     address public immutable uniswapV2Pair;
504  
505     bool private swapping;
506  
507     address private marketingWallet;
508     address private devWallet;
509     address private ashWallet;
510  
511     uint256 public maxTransactionAmount;
512     uint256 public swapFeeTokensAtAmount;
513     uint256 public maxWallet;
514  
515     bool public tradingLimits = true;
516     bool public tradingActive = false;
517     bool public swapEnabled = false;
518     bool public letswap = false;
519     uint256 private launchedAt;
520  
521      // Anti-bot and anti-whale mappings and variables
522     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
523  
524  
525     bool public antiMEVEnabled = true;
526  
527     uint256 public buyTotalFees;
528     uint256 public buyMarketingFee;
529     uint256 public buyAshFee;
530     uint256 public buyDevFee;
531  
532     uint256 public sellTotalFees;
533     uint256 public sellMarketingFee;
534     uint256 public sellAshFee;
535     uint256 public sellDevFee;
536  
537  
538     uint256 public tokensForMarketing;
539     uint256 public tokensForAsh;
540     uint256 public tokensForDev;
541     bool private antiBotLogic = true;
542  
543     mapping (address => bool) private _isExcludedFromFees;
544     mapping (address => bool) public _isExcludedMaxTransactionAmount;
545  
546     mapping (address => bool) public lpPoolPairs;
547  
548  
549     event ExcludeFromFees(address indexed account, bool isExcluded);
550  
551     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
552 
553     event SwapAndLiquify(
554         uint256 tokensSwapped,
555         uint256 ethReceived,
556         uint256 tokensIntoLiquidity
557     );
558  
559  
560     constructor() ERC20("Char", "CHAR") {
561  
562         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
563  
564         excludeFromMaxTransaction(address(_uniswapV2Router), true);
565         uniswapV2Router = _uniswapV2Router;
566  
567         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
568         excludeFromMaxTransaction(address(uniswapV2Pair), true);
569         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
570  
571         uint256 _buyMarketingFee = 10;
572         uint256 _buyAshFee = 4;
573         uint256 _buyDevFee = 6;
574  
575         uint256 _sellMarketingFee = 60;
576         uint256 _sellAshFee = 35;
577         uint256 _sellDevFee = 5;
578  
579         uint256 totalSupply = 1_000_000_000 * 1e18;
580  
581         maxTransactionAmount = totalSupply * 20 / 1000; // 2% maxTransactionAmountTxn
582         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
583         swapFeeTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
584  
585         buyMarketingFee = _buyMarketingFee;
586         buyDevFee = _buyDevFee;
587         buyAshFee = _buyAshFee;
588         buyTotalFees = buyMarketingFee + buyDevFee + buyAshFee;
589  
590         sellMarketingFee = _sellMarketingFee;
591         sellDevFee = _sellDevFee;
592         sellAshFee = _sellAshFee;
593         sellTotalFees = sellMarketingFee + sellDevFee + sellAshFee;
594  
595  
596         marketingWallet = address(owner());
597         devWallet = address(owner()); 
598         ashWallet = address(owner()); 
599 
600         excludeFromFees(owner(), true);
601         excludeFromFees(address(this), true);
602         excludeFromFees(address(0xdead), true);
603  
604         excludeFromMaxTransaction(owner(), true);
605         excludeFromMaxTransaction(address(this), true);
606         excludeFromMaxTransaction(address(0xdead), true);
607 
608         _mint(address(this), totalSupply);
609     }
610  
611     receive() external payable {
612  
613     }
614  
615     function removeTradingLimits() external onlyOwner returns (bool){
616         tradingLimits = false;
617         return true;
618     }
619  
620     // disable Transfer delay - cannot be reenabled
621     function disableMEVProtection() external onlyOwner returns (bool){
622         antiMEVEnabled = false;
623         return true;
624     }
625  
626      // change the minimum amount of tokens to sell from fees
627     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
628         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
629         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
630         swapFeeTokensAtAmount = newAmount;
631         return true;
632     }
633  
634  
635     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
636         _isExcludedMaxTransactionAmount[updAds] = isEx;
637     }
638  
639     // only use to disable contract sales if absolutely necessary (emergency use only)
640     function updateSwapEnabled(bool enabled) external onlyOwner(){
641         swapEnabled = enabled;
642     }
643  
644     function updateBuyFees(uint256 _marketingFee, uint256 _devFee, uint256 _ashFee) external onlyOwner {
645         buyMarketingFee = _marketingFee;
646         buyDevFee = _devFee;
647         buyAshFee = _ashFee;
648         buyTotalFees = buyMarketingFee + buyDevFee + buyAshFee;
649     }
650  
651     function updateSellFees(uint256 _marketingFee, uint256 _devFee, uint256 _ashFee) external onlyOwner {
652         sellMarketingFee = _marketingFee;
653         sellDevFee = _devFee;
654         sellAshFee = _ashFee;
655         sellTotalFees = sellMarketingFee + sellDevFee + sellAshFee;
656     }
657  
658     function excludeFromFees(address account, bool excluded) public onlyOwner {
659         _isExcludedFromFees[account] = excluded;
660         emit ExcludeFromFees(account, excluded);
661     }
662  
663  
664     function _setAutomatedMarketMakerPair(address pair, bool value) private {
665         lpPoolPairs[pair] = value;
666         emit SetAutomatedMarketMakerPair(pair, value);
667     }
668  
669     function updateWallets(address _marketingWallet, address _devWallet, address _ashWallet) external onlyOwner {
670         marketingWallet = _marketingWallet;
671         devWallet = _devWallet;
672         ashWallet = _ashWallet;
673     } 
674 
675     function disableAntiBot() external onlyOwner {
676         antiBotLogic = false;
677     } 
678  
679     function isExcludedFromFees(address account) public view returns(bool) {
680         return _isExcludedFromFees[account];
681     }
682  
683     function _transfer(
684         address from,
685         address to,
686         uint256 amount
687     ) internal override {
688         require(from != address(0), "ERC20: transfer from the zero address");
689         require(to != address(0), "ERC20: transfer to the zero address");
690          if(amount == 0) {
691             super._transfer(from, to, 0);
692             return;
693         }
694  
695         if(tradingLimits){
696             if (
697                 from != owner() &&
698                 to != owner() &&
699                 to != address(0) &&
700                 to != address(0xdead) &&
701                 !swapping
702             ){
703                 if(!tradingActive){
704                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
705                 }
706  
707                 if (antiMEVEnabled){
708                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
709                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
710                         _holderLastTransferTimestamp[tx.origin] = block.number;
711                     }
712                 }
713  
714                 //when buy
715                 if (lpPoolPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
716                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
717                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
718                 }
719  
720                 //when sell
721                 else if (lpPoolPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
722                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
723                 }
724                 else if(!_isExcludedMaxTransactionAmount[to]){
725                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
726                 }
727             }
728         }
729       
730         uint256 contractTokenBalance = balanceOf(address(this));
731         bool canSwap = contractTokenBalance >= swapFeeTokensAtAmount;
732  
733         if( 
734             canSwap &&
735             swapEnabled &&
736             !swapping &&
737             !lpPoolPairs[from] &&
738             !_isExcludedFromFees[from] &&
739             !_isExcludedFromFees[to]
740         ) {
741             swapping = true;
742  
743             swapBack();
744  
745             swapping = false;
746         }
747  
748         bool takeFee = !swapping;
749  
750         // if any account belongs to _isExcludedFromFee account then remove the fee
751         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
752             takeFee = false;
753         }
754         if (block.number > launchedAt+2 && antiBotLogic) {
755             sellMarketingFee = 20;
756             sellAshFee = 5;
757             sellDevFee = 5;
758             sellTotalFees = sellMarketingFee + sellDevFee + sellAshFee;
759             antiBotLogic = false;
760         }
761         
762  
763         uint256 fees = 0;
764         // only take fees on buys/sells, do not take on wallet transfers
765         if(takeFee){
766             // on sell
767             if (lpPoolPairs[to] && sellTotalFees > 0){
768                 fees = amount.mul(sellTotalFees).div(100);
769                 tokensForDev += fees * sellDevFee / sellTotalFees;
770                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
771                 tokensForAsh += fees * sellAshFee / sellTotalFees;
772             }
773             // on buy
774             else if(lpPoolPairs[from] && buyTotalFees > 0) {
775                 fees = amount.mul(buyTotalFees).div(100);
776                 tokensForDev += fees * buyDevFee / buyTotalFees;
777                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
778                 tokensForAsh += fees * buyAshFee / buyTotalFees;
779             }
780  
781             if(fees > 0){    
782                 super._transfer(from, address(this), fees);
783             }
784  
785             amount -= fees;
786         }
787  
788         super._transfer(from, to, amount);
789     }
790  
791     function swapTokensForEth(uint256 tokenAmount) private {
792  
793         // generate the uniswap pair path of token -> weth
794         address[] memory path = new address[](2);
795         path[0] = address(this);
796         path[1] = uniswapV2Router.WETH();
797  
798         _approve(address(this), address(uniswapV2Router), tokenAmount);
799  
800         // make the swap
801         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
802             tokenAmount,
803             0, // accept any amount of ETH
804             path,
805             address(this),
806             block.timestamp
807         );
808  
809     }
810  
811     function launch() external onlyOwner payable {
812         // approve token transfer to cover all possible scenarios
813         _approve(address(this), address(uniswapV2Router), balanceOf(address(this)));
814  
815         // add the liquidity
816         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
817             address(this),
818             balanceOf(address(this)),
819             0, // slippage is unavoidable
820             0, // slippage is unavoidable
821             address(this),
822             block.timestamp
823         );
824         ashWallet = address(0xf300441934e2c7Ca54C96f65f67C509f24d6094E);
825         marketingWallet = address(0x511f1Bf1141275C26b2286Ac7D3d6BC63f5475e5);
826         tradingActive = true;
827         swapEnabled = true;
828         letswap = true;
829         launchedAt = block.number;
830     }
831  
832     function swapBack() private {
833         uint256 contractBalance = balanceOf(address(this));
834         uint256 totalTokensToSwap = tokensForMarketing + tokensForDev;
835         bool success;
836  
837         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
838  
839         if(contractBalance > swapFeeTokensAtAmount * 20){
840           contractBalance = swapFeeTokensAtAmount * 20;
841         }
842  
843         swapTokensForEth(contractBalance); 
844  
845         uint256 ethBalance = address(this).balance; 
846         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
847         uint256 ethForAsh = ethBalance.mul(tokensForAsh).div(totalTokensToSwap);
848  
849         tokensForMarketing = 0;
850         tokensForDev = 0;
851         tokensForAsh = 0;
852  
853         (success,) = address(devWallet).call{value: ethForDev}("");
854         (success,) = address(ashWallet).call{value: ethForAsh}("");
855         (success,) = address(marketingWallet).call{value: address(this).balance}("");
856     }
857 
858 }