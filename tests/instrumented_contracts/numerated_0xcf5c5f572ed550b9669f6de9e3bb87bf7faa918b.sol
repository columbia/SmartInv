1 /*
2 
3 
4 Welcome Frogs! 🐸 Ribbit 🐸
5 
6 Supply: 1,000,000,000
7 
8 Tax:  0%.
9 
10 -What is the token utility? 
11 -Frogs can jump up to 50 times their length.
12 
13 Website: https://frogerc20.com/
14 
15 Twitter: https://twitter.com/FrogERC20
16 
17 Telegram: https://t.me/Frogerc
18 
19 
20        
21        ,--------.
22      ,-.🐸   🐸,'.
23      \_*._ ' '_.* _/
24       /`-.`--' .-'\
25  ,--./    `---'    \,--.
26  \   |(  )     (  )|   /
27   \  | ||       || |  /
28    \ | /|\     /|\ | /
29    /  \-._     _,-/  \
30   //| \\  `---'  // |\\
31  /,-.,-.\       /,-.,-.\
32 
33 */
34 
35 // SPDX-License-Identifier: Unlicensed
36 
37 pragma solidity 0.8.11;
38  
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43  
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48  
49 interface IUniswapV2Pair {
50     event Approval(address indexed owner, address indexed spender, uint value);
51     event Transfer(address indexed from, address indexed to, uint value);
52  
53     function name() external pure returns (string memory);
54     function symbol() external pure returns (string memory);
55     function decimals() external pure returns (uint8);
56     function totalSupply() external view returns (uint);
57     function balanceOf(address owner) external view returns (uint);
58     function allowance(address owner, address spender) external view returns (uint);
59  
60     function approve(address spender, uint value) external returns (bool);
61     function transfer(address to, uint value) external returns (bool);
62     function transferFrom(address from, address to, uint value) external returns (bool);
63  
64     function DOMAIN_SEPARATOR() external view returns (bytes32);
65     function PERMIT_TYPEHASH() external pure returns (bytes32);
66     function nonces(address owner) external view returns (uint);
67  
68     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
69  
70     event Mint(address indexed sender, uint amount0, uint amount1);
71     event Swap(
72         address indexed sender,
73         uint amount0In,
74         uint amount1In,
75         uint amount0Out,
76         uint amount1Out,
77         address indexed to
78     );
79     event Sync(uint112 reserve0, uint112 reserve1);
80  
81     function MINIMUM_LIQUIDITY() external pure returns (uint);
82     function factory() external view returns (address);
83     function token0() external view returns (address);
84     function token1() external view returns (address);
85     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
86     function price0CumulativeLast() external view returns (uint);
87     function price1CumulativeLast() external view returns (uint);
88     function kLast() external view returns (uint);
89  
90     function mint(address to) external returns (uint liquidity);
91     function burn(address to) external returns (uint amount0, uint amount1);
92     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
93     function skim(address to) external;
94     function sync() external;
95  
96     function initialize(address, address) external;
97 }
98  
99 interface IUniswapV2Factory {
100     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
101  
102     function feeTo() external view returns (address);
103     function feeToSetter() external view returns (address);
104  
105     function getPair(address tokenA, address tokenB) external view returns (address pair);
106     function allPairs(uint) external view returns (address pair);
107     function allPairsLength() external view returns (uint);
108  
109     function createPair(address tokenA, address tokenB) external returns (address pair);
110  
111     function setFeeTo(address) external;
112     function setFeeToSetter(address) external;
113 }
114  
115 interface IERC20 {
116 
117     function totalSupply() external view returns (uint256);
118 
119     function balanceOf(address account) external view returns (uint256);
120 
121     function transfer(address recipient, uint256 amount) external returns (bool);
122 
123     function allowance(address owner, address spender) external view returns (uint256);
124 
125     function approve(address spender, uint256 amount) external returns (bool);
126 
127     function transferFrom(
128         address sender,
129         address recipient,
130         uint256 amount
131     ) external returns (bool);
132 
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137  
138 interface IERC20Metadata is IERC20 {
139 
140     function name() external view returns (string memory);
141 
142     function symbol() external view returns (string memory);
143 
144     function decimals() external view returns (uint8);
145 }
146  
147  
148 contract ERC20 is Context, IERC20, IERC20Metadata {
149     using SafeMath for uint256;
150  
151     mapping(address => uint256) private _balances;
152  
153     mapping(address => mapping(address => uint256)) private _allowances;
154  
155     uint256 private _totalSupply;
156  
157     string private _name;
158     string private _symbol;
159 
160     constructor(string memory name_, string memory symbol_) {
161         _name = name_;
162         _symbol = symbol_;
163     }
164 
165     function name() public view virtual override returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public view virtual override returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public view virtual override returns (uint8) {
174         return 18;
175     }
176 
177     function totalSupply() public view virtual override returns (uint256) {
178         return _totalSupply;
179     }
180 
181     function balanceOf(address account) public view virtual override returns (uint256) {
182         return _balances[account];
183     }
184 
185     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view virtual override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public virtual override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(
200         address sender,
201         address recipient,
202         uint256 amount
203     ) public virtual override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
210         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
211         return true;
212     }
213 
214     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
215         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
216         return true;
217     }
218 
219     function _transfer(
220         address sender,
221         address recipient,
222         uint256 amount
223     ) internal virtual {
224         require(sender != address(0), "ERC20: transfer from the zero address");
225         require(recipient != address(0), "ERC20: transfer to the zero address");
226  
227         _beforeTokenTransfer(sender, recipient, amount);
228  
229         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
230         _balances[recipient] = _balances[recipient].add(amount);
231         emit Transfer(sender, recipient, amount);
232     }
233 
234     function _mint(address account, uint256 amount) internal virtual {
235         require(account != address(0), "ERC20: mint to the zero address");
236  
237         _beforeTokenTransfer(address(0), account, amount);
238  
239         _totalSupply = _totalSupply.add(amount);
240         _balances[account] = _balances[account].add(amount);
241         emit Transfer(address(0), account, amount);
242     }
243 
244     function _burn(address account, uint256 amount) internal virtual {
245         require(account != address(0), "ERC20: burn from the zero address");
246  
247         _beforeTokenTransfer(account, address(0), amount);
248  
249         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
250         _totalSupply = _totalSupply.sub(amount);
251         emit Transfer(account, address(0), amount);
252     }
253 
254     function _approve(
255         address owner,
256         address spender,
257         uint256 amount
258     ) internal virtual {
259         require(owner != address(0), "ERC20: approve from the zero address");
260         require(spender != address(0), "ERC20: approve to the zero address");
261  
262         _allowances[owner][spender] = amount;
263         emit Approval(owner, spender, amount);
264     }
265 
266     function _beforeTokenTransfer(
267         address from,
268         address to,
269         uint256 amount
270     ) internal virtual {}
271 }
272  
273 library SafeMath {
274 
275     function add(uint256 a, uint256 b) internal pure returns (uint256) {
276         uint256 c = a + b;
277         require(c >= a, "SafeMath: addition overflow");
278  
279         return c;
280     }
281 
282     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
283         return sub(a, b, "SafeMath: subtraction overflow");
284     }
285 
286     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
287         require(b <= a, errorMessage);
288         uint256 c = a - b;
289  
290         return c;
291     }
292 
293     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
294 
295         if (a == 0) {
296             return 0;
297         }
298  
299         uint256 c = a * b;
300         require(c / a == b, "SafeMath: multiplication overflow");
301  
302         return c;
303     }
304 
305     function div(uint256 a, uint256 b) internal pure returns (uint256) {
306         return div(a, b, "SafeMath: division by zero");
307     }
308 
309     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
310         require(b > 0, errorMessage);
311         uint256 c = a / b;
312         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
313  
314         return c;
315     }
316 
317     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
318         return mod(a, b, "SafeMath: modulo by zero");
319     }
320 
321     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
322         require(b != 0, errorMessage);
323         return a % b;
324     }
325 }
326  
327 contract Ownable is Context {
328     address private _owner;
329  
330     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
331 
332     constructor () {
333         address msgSender = _msgSender();
334         _owner = msgSender;
335         emit OwnershipTransferred(address(0), msgSender);
336     }
337 
338     function owner() public view returns (address) {
339         return _owner;
340     }
341 
342     modifier onlyOwner() {
343         require(_owner == _msgSender(), "Ownable: caller is not the owner");
344         _;
345     }
346 
347     function renounceOwnership() public virtual onlyOwner {
348         emit OwnershipTransferred(_owner, address(0));
349         _owner = address(0);
350     }
351 
352     function transferOwnership(address newOwner) public virtual onlyOwner {
353         require(newOwner != address(0), "Ownable: new owner is the zero address");
354         emit OwnershipTransferred(_owner, newOwner);
355         _owner = newOwner;
356     }
357 }
358  
359  
360  
361 library SafeMathInt {
362     int256 private constant MIN_INT256 = int256(1) << 255;
363     int256 private constant MAX_INT256 = ~(int256(1) << 255);
364 
365     function mul(int256 a, int256 b) internal pure returns (int256) {
366         int256 c = a * b;
367  
368         // Detect overflow when multiplying MIN_INT256 with -1
369         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
370         require((b == 0) || (c / b == a));
371         return c;
372     }
373 
374     function div(int256 a, int256 b) internal pure returns (int256) {
375         // Prevent overflow when dividing MIN_INT256 by -1
376         require(b != -1 || a != MIN_INT256);
377  
378         // Solidity already throws when dividing by 0.
379         return a / b;
380     }
381 
382     function sub(int256 a, int256 b) internal pure returns (int256) {
383         int256 c = a - b;
384         require((b >= 0 && c <= a) || (b < 0 && c > a));
385         return c;
386     }
387 
388     function add(int256 a, int256 b) internal pure returns (int256) {
389         int256 c = a + b;
390         require((b >= 0 && c >= a) || (b < 0 && c < a));
391         return c;
392     }
393 
394     function abs(int256 a) internal pure returns (int256) {
395         require(a != MIN_INT256);
396         return a < 0 ? -a : a;
397     }
398  
399  
400     function toUint256Safe(int256 a) internal pure returns (uint256) {
401         require(a >= 0);
402         return uint256(a);
403     }
404 }
405  
406 library SafeMathUint {
407   function toInt256Safe(uint256 a) internal pure returns (int256) {
408     int256 b = int256(a);
409     require(b >= 0);
410     return b;
411   }
412 }
413  
414  
415 interface IUniswapV2Router01 {
416     function factory() external pure returns (address);
417     function WETH() external pure returns (address);
418  
419     function addLiquidity(
420         address tokenA,
421         address tokenB,
422         uint amountADesired,
423         uint amountBDesired,
424         uint amountAMin,
425         uint amountBMin,
426         address to,
427         uint deadline
428     ) external returns (uint amountA, uint amountB, uint liquidity);
429     function addLiquidityETH(
430         address token,
431         uint amountTokenDesired,
432         uint amountTokenMin,
433         uint amountETHMin,
434         address to,
435         uint deadline
436     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
437     function removeLiquidity(
438         address tokenA,
439         address tokenB,
440         uint liquidity,
441         uint amountAMin,
442         uint amountBMin,
443         address to,
444         uint deadline
445     ) external returns (uint amountA, uint amountB);
446     function removeLiquidityETH(
447         address token,
448         uint liquidity,
449         uint amountTokenMin,
450         uint amountETHMin,
451         address to,
452         uint deadline
453     ) external returns (uint amountToken, uint amountETH);
454     function removeLiquidityWithPermit(
455         address tokenA,
456         address tokenB,
457         uint liquidity,
458         uint amountAMin,
459         uint amountBMin,
460         address to,
461         uint deadline,
462         bool approveMax, uint8 v, bytes32 r, bytes32 s
463     ) external returns (uint amountA, uint amountB);
464     function removeLiquidityETHWithPermit(
465         address token,
466         uint liquidity,
467         uint amountTokenMin,
468         uint amountETHMin,
469         address to,
470         uint deadline,
471         bool approveMax, uint8 v, bytes32 r, bytes32 s
472     ) external returns (uint amountToken, uint amountETH);
473     function swapExactTokensForTokens(
474         uint amountIn,
475         uint amountOutMin,
476         address[] calldata path,
477         address to,
478         uint deadline
479     ) external returns (uint[] memory amounts);
480     function swapTokensForExactTokens(
481         uint amountOut,
482         uint amountInMax,
483         address[] calldata path,
484         address to,
485         uint deadline
486     ) external returns (uint[] memory amounts);
487     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
488         external
489         payable
490         returns (uint[] memory amounts);
491     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
492         external
493         returns (uint[] memory amounts);
494     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
495         external
496         returns (uint[] memory amounts);
497     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
498         external
499         payable
500         returns (uint[] memory amounts);
501  
502     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
503     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
504     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
505     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
506     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
507 }
508  
509 interface IUniswapV2Router02 is IUniswapV2Router01 {
510     function removeLiquidityETHSupportingFeeOnTransferTokens(
511         address token,
512         uint liquidity,
513         uint amountTokenMin,
514         uint amountETHMin,
515         address to,
516         uint deadline
517     ) external returns (uint amountETH);
518     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
519         address token,
520         uint liquidity,
521         uint amountTokenMin,
522         uint amountETHMin,
523         address to,
524         uint deadline,
525         bool approveMax, uint8 v, bytes32 r, bytes32 s
526     ) external returns (uint amountETH);
527  
528     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
529         uint amountIn,
530         uint amountOutMin,
531         address[] calldata path,
532         address to,
533         uint deadline
534     ) external;
535     function swapExactETHForTokensSupportingFeeOnTransferTokens(
536         uint amountOutMin,
537         address[] calldata path,
538         address to,
539         uint deadline
540     ) external payable;
541     function swapExactTokensForETHSupportingFeeOnTransferTokens(
542         uint amountIn,
543         uint amountOutMin,
544         address[] calldata path,
545         address to,
546         uint deadline
547     ) external;
548 }
549  
550 contract Frog is ERC20, Ownable {
551     using SafeMath for uint256;
552  
553     IUniswapV2Router02 public immutable uniswapV2Router;
554     address public immutable uniswapV2Pair;
555  
556     bool private swapping;
557  
558     address private marketingWallet;
559     address private devWallet;
560  
561     uint256 public maxTransactionAmount;
562     uint256 public swapTokensAtAmount;
563     uint256 public maxWallet;
564  
565     bool public limitsInEffect = true;
566     bool public tradingActive = false;
567     bool public swapEnabled = false;
568  
569      // Anti-bot and anti-whale mappings and variables
570     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
571  
572     // Seller Map
573     mapping (address => uint256) private _holderFirstBuyTimestamp;
574  
575     // Blacklist Map
576     mapping (address => bool) private _blacklist;
577     bool public transferDelayEnabled = true;
578  
579     uint256 public buyTotalFees;
580     uint256 public buyMarketingFee;
581     uint256 public buyLiquidityFee;
582     uint256 public buyDevFee;
583  
584     uint256 public sellTotalFees;
585     uint256 public sellMarketingFee;
586     uint256 public sellLiquidityFee;
587     uint256 public sellDevFee;
588  
589     uint256 public tokensForMarketing;
590     uint256 public tokensForLiquidity;
591     uint256 public tokensForDev;
592  
593     // block number of opened trading
594     uint256 launchedAt;
595  
596     /******************/
597  
598     // exclude from fees and max transaction amount
599     mapping (address => bool) private _isExcludedFromFees;
600     mapping (address => bool) public _isExcludedMaxTransactionAmount;
601  
602     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
603     // could be subject to a maximum transfer amount
604     mapping (address => bool) public automatedMarketMakerPairs;
605  
606     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
607  
608     event ExcludeFromFees(address indexed account, bool isExcluded);
609  
610     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
611  
612     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
613  
614     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
615  
616     event SwapAndLiquify(
617         uint256 tokensSwapped,
618         uint256 ethReceived,
619         uint256 tokensIntoLiquidity
620     );
621  
622     event AutoNukeLP();
623  
624     event ManualNukeLP();
625  
626     constructor() ERC20("Frog", unicode"🐸") {
627  
628         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
629  
630         excludeFromMaxTransaction(address(_uniswapV2Router), true);
631         uniswapV2Router = _uniswapV2Router;
632  
633         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
634         excludeFromMaxTransaction(address(uniswapV2Pair), true);
635         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
636  
637         uint256 _buyMarketingFee = 25;
638         uint256 _buyLiquidityFee = 0;
639         uint256 _buyDevFee = 0;
640  
641         uint256 _sellMarketingFee = 25;
642         uint256 _sellLiquidityFee = 0;
643         uint256 _sellDevFee = 0;
644  
645         uint256 totalSupply = 100000000000000 * 1e18;
646  
647         maxTransactionAmount = totalSupply * 20 / 1000; // .5%
648         maxWallet = totalSupply * 20 / 1000; // 1% 
649         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05%
650  
651         buyMarketingFee = _buyMarketingFee;
652         buyLiquidityFee = _buyLiquidityFee;
653         buyDevFee = _buyDevFee;
654         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
655  
656         sellMarketingFee = _sellMarketingFee;
657         sellLiquidityFee = _sellLiquidityFee;
658         sellDevFee = _sellDevFee;
659         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
660  
661         marketingWallet = address(0x667bb1e55f070a10F45c273Fe32c76cE6e7C506c);
662         devWallet = address(0x667bb1e55f070a10F45c273Fe32c76cE6e7C506c);
663  
664         // exclude from paying fees or having max transaction amount
665         excludeFromFees(owner(), true);
666         excludeFromFees(address(this), true);
667         excludeFromFees(address(0xdead), true);
668         excludeFromFees(address(marketingWallet), true);
669  
670         excludeFromMaxTransaction(owner(), true);
671         excludeFromMaxTransaction(address(this), true);
672         excludeFromMaxTransaction(address(0xdead), true);
673         excludeFromMaxTransaction(address(devWallet), true);
674         excludeFromMaxTransaction(address(marketingWallet), true);
675  
676         /*
677             _mint is an internal function in ERC20.sol that is only called here,
678             and CANNOT be called ever again
679         */
680         _mint(msg.sender, totalSupply);
681     }
682  
683     receive() external payable {
684  
685     }
686  
687     // once enabled, can never be turned off
688     function enableTrading() external onlyOwner {
689         tradingActive = true;
690         swapEnabled = true;
691         launchedAt = block.number;
692     }
693  
694     // remove limits after token is stable
695     function removeLimits() external onlyOwner returns (bool){
696         limitsInEffect = false;
697         return true;
698     }
699  
700     // disable Transfer delay - cannot be reenabled
701     function disableTransferDelay() external onlyOwner returns (bool){
702         transferDelayEnabled = false;
703         return true;
704     }
705  
706      // change the minimum amount of tokens to sell from fees
707     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
708         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
709         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
710         swapTokensAtAmount = newAmount;
711         return true;
712     }
713  
714     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
715         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
716         maxTransactionAmount = newNum * (10**18);
717     }
718  
719     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
720         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
721         maxWallet = newNum * (10**18);
722     }
723  
724     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
725         _isExcludedMaxTransactionAmount[updAds] = isEx;
726     }
727 
728     function updateBuyFees(
729         uint256 _devFee,
730         uint256 _liquidityFee,
731         uint256 _marketingFee
732     ) external onlyOwner {
733         buyDevFee = _devFee;
734         buyLiquidityFee = _liquidityFee;
735         buyMarketingFee = _marketingFee;
736         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
737     }
738 
739     function updateSellFees(
740         uint256 _devFee,
741         uint256 _liquidityFee,
742         uint256 _marketingFee
743     ) external onlyOwner {
744         sellDevFee = _devFee;
745         sellLiquidityFee = _liquidityFee;
746         sellMarketingFee = _marketingFee;
747         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
748     }
749  
750     // only use to disable contract sales if absolutely necessary (emergency use only)
751     function updateSwapEnabled(bool enabled) external onlyOwner(){
752         swapEnabled = enabled;
753     }
754  
755     function excludeFromFees(address account, bool excluded) public onlyOwner {
756         _isExcludedFromFees[account] = excluded;
757         emit ExcludeFromFees(account, excluded);
758     }
759  
760     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
761         _blacklist[account] = isBlacklisted;
762     }
763  
764     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
765         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
766  
767         _setAutomatedMarketMakerPair(pair, value);
768     }
769  
770     function _setAutomatedMarketMakerPair(address pair, bool value) private {
771         automatedMarketMakerPairs[pair] = value;
772  
773         emit SetAutomatedMarketMakerPair(pair, value);
774     }
775  
776     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
777         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
778         marketingWallet = newMarketingWallet;
779     }
780  
781     function updateDevWallet(address newWallet) external onlyOwner {
782         emit devWalletUpdated(newWallet, devWallet);
783         devWallet = newWallet;
784     }
785  
786  
787     function isExcludedFromFees(address account) public view returns(bool) {
788         return _isExcludedFromFees[account];
789     }
790  
791     function _transfer(
792         address from,
793         address to,
794         uint256 amount
795     ) internal override {
796         require(from != address(0), "ERC20: transfer from the zero address");
797         require(to != address(0), "ERC20: transfer to the zero address");
798         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
799          if(amount == 0) {
800             super._transfer(from, to, 0);
801             return;
802         }
803  
804         if(limitsInEffect){
805             if (
806                 from != owner() &&
807                 to != owner() &&
808                 to != address(0) &&
809                 to != address(0xdead) &&
810                 !swapping
811             ){
812                 if(!tradingActive){
813                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
814                 }
815  
816                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
817                 if (transferDelayEnabled){
818                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
819                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
820                         _holderLastTransferTimestamp[tx.origin] = block.number;
821                     }
822                 }
823  
824                 //when buy
825                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
826                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
827                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
828                 }
829  
830                 //when sell
831                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
832                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
833                 }
834                 else if(!_isExcludedMaxTransactionAmount[to]){
835                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
836                 }
837             }
838         }
839  
840         uint256 contractTokenBalance = balanceOf(address(this));
841  
842         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
843  
844         if( 
845             canSwap &&
846             swapEnabled &&
847             !swapping &&
848             !automatedMarketMakerPairs[from] &&
849             !_isExcludedFromFees[from] &&
850             !_isExcludedFromFees[to]
851         ) {
852             swapping = true;
853  
854             swapBack();
855  
856             swapping = false;
857         }
858  
859         bool takeFee = !swapping;
860  
861         // if any account belongs to _isExcludedFromFee account then remove the fee
862         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
863             takeFee = false;
864         }
865  
866         uint256 fees = 0;
867         // only take fees on buys/sells, do not take on wallet transfers
868         if(takeFee){
869             // on sell
870             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
871                 fees = amount.mul(sellTotalFees).div(100);
872                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
873                 tokensForDev += fees * sellDevFee / sellTotalFees;
874                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
875             }
876             // on buy
877             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
878                 fees = amount.mul(buyTotalFees).div(100);
879                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
880                 tokensForDev += fees * buyDevFee / buyTotalFees;
881                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
882             }
883  
884             if(fees > 0){    
885                 super._transfer(from, address(this), fees);
886             }
887  
888             amount -= fees;
889         }
890  
891         super._transfer(from, to, amount);
892     }
893  
894     function swapTokensForEth(uint256 tokenAmount) private {
895  
896         // generate the uniswap pair path of token -> weth
897         address[] memory path = new address[](2);
898         path[0] = address(this);
899         path[1] = uniswapV2Router.WETH();
900  
901         _approve(address(this), address(uniswapV2Router), tokenAmount);
902  
903         // make the swap
904         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
905             tokenAmount,
906             0, // accept any amount of ETH
907             path,
908             address(this),
909             block.timestamp
910         );
911  
912     }
913  
914     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
915         // approve token transfer to cover all possible scenarios
916         _approve(address(this), address(uniswapV2Router), tokenAmount);
917  
918         // add the liquidity
919         uniswapV2Router.addLiquidityETH{value: ethAmount}(
920             address(this),
921             tokenAmount,
922             0, // slippage is unavoidable
923             0, // slippage is unavoidable
924             address(this),
925             block.timestamp
926         );
927     }
928  
929     function swapBack() private {
930         uint256 contractBalance = balanceOf(address(this));
931         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
932         bool success;
933  
934         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
935  
936         if(contractBalance > swapTokensAtAmount * 20){
937           contractBalance = swapTokensAtAmount * 20;
938         }
939  
940         // Halve the amount of liquidity tokens
941         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
942         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
943  
944         uint256 initialETHBalance = address(this).balance;
945  
946         swapTokensForEth(amountToSwapForETH); 
947  
948         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
949  
950         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
951         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
952         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
953  
954  
955         tokensForLiquidity = 0;
956         tokensForMarketing = 0;
957         tokensForDev = 0;
958  
959         (success,) = address(devWallet).call{value: ethForDev}("");
960  
961         if(liquidityTokens > 0 && ethForLiquidity > 0){
962             addLiquidity(liquidityTokens, ethForLiquidity);
963             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
964         }
965  
966         (success,) = address(marketingWallet).call{value: address(this).balance}("");
967     }
968 }