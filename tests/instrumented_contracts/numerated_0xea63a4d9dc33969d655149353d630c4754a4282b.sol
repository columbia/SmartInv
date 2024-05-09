1 /*
2 PachaInu.com 
3 
4 pachainu.medium.com
5 
6 https://t.me/PachaInu
7 
8 https://twitter.com/Pacha_Inu
9 */
10 
11 // SPDX-License-Identifier: Unlicensed
12 
13 pragma solidity 0.8.11;
14  
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19  
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24  
25 interface IUniswapV2Pair {
26     event Approval(address indexed owner, address indexed spender, uint value);
27     event Transfer(address indexed from, address indexed to, uint value);
28  
29     function name() external pure returns (string memory);
30     function symbol() external pure returns (string memory);
31     function decimals() external pure returns (uint8);
32     function totalSupply() external view returns (uint);
33     function balanceOf(address owner) external view returns (uint);
34     function allowance(address owner, address spender) external view returns (uint);
35  
36     function approve(address spender, uint value) external returns (bool);
37     function transfer(address to, uint value) external returns (bool);
38     function transferFrom(address from, address to, uint value) external returns (bool);
39  
40     function DOMAIN_SEPARATOR() external view returns (bytes32);
41     function PERMIT_TYPEHASH() external pure returns (bytes32);
42     function nonces(address owner) external view returns (uint);
43  
44     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
45  
46     event Mint(address indexed sender, uint amount0, uint amount1);
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
270 
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
526 contract PachaInu  is ERC20, Ownable {
527     using SafeMath for uint256;
528  
529     IUniswapV2Router02 public immutable uniswapV2Router;
530     address public immutable uniswapV2Pair;
531  
532     bool private swapping;
533  
534     address private marketingWallet;
535     address private devWallet;
536  
537     uint256 public maxTransactionAmount;
538     uint256 public swapTokensAtAmount;
539     uint256 public maxWallet;
540  
541     bool public limitsInEffect = true;
542     bool public tradingActive = false;
543     bool public swapEnabled = false;
544  
545      // Anti-bot and anti-whale mappings and variables
546     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
547  
548     // Seller Map
549     mapping (address => uint256) private _holderFirstBuyTimestamp;
550  
551     // Blacklist Map
552     mapping (address => bool) private _blacklist;
553     bool public transferDelayEnabled = true;
554  
555     uint256 public buyTotalFees;
556     uint256 public buyMarketingFee;
557     uint256 public buyLiquidityFee;
558     uint256 public buyDevFee;
559  
560     uint256 public sellTotalFees;
561     uint256 public sellMarketingFee;
562     uint256 public sellLiquidityFee;
563     uint256 public sellDevFee;
564  
565     uint256 public tokensForMarketing;
566     uint256 public tokensForLiquidity;
567     uint256 public tokensForDev;
568  
569     // block number of opened trading
570     uint256 launchedAt;
571  
572     /******************/
573  
574     // exclude from fees and max transaction amount
575     mapping (address => bool) private _isExcludedFromFees;
576     mapping (address => bool) public _isExcludedMaxTransactionAmount;
577  
578     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
579     // could be subject to a maximum transfer amount
580     mapping (address => bool) public automatedMarketMakerPairs;
581  
582     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
583  
584     event ExcludeFromFees(address indexed account, bool isExcluded);
585  
586     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
587  
588     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
589  
590     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
591  
592     event SwapAndLiquify(
593         uint256 tokensSwapped,
594         uint256 ethReceived,
595         uint256 tokensIntoLiquidity
596     );
597  
598     event AutoNukeLP();
599  
600     event ManualNukeLP();
601  
602     constructor() ERC20(" Pacha Inu", "PACHA") {
603  
604         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
605  
606         excludeFromMaxTransaction(address(_uniswapV2Router), true);
607         uniswapV2Router = _uniswapV2Router;
608  
609         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
610         excludeFromMaxTransaction(address(uniswapV2Pair), true);
611         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
612  
613         uint256 _buyMarketingFee = 20;
614         uint256 _buyLiquidityFee = 0;
615         uint256 _buyDevFee = 9;
616  
617         uint256 _sellMarketingFee = 42;
618         uint256 _sellLiquidityFee = 0;
619         uint256 _sellDevFee = 18;
620  
621         uint256 totalSupply = 333666999 * 1e18;
622  
623         maxTransactionAmount = totalSupply * 8991 / 1000000; // 0.8991%
624         maxWallet = totalSupply * 8991 / 1000000; // 0.8991% 
625         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1%
626  
627         buyMarketingFee = _buyMarketingFee;
628         buyLiquidityFee = _buyLiquidityFee;
629         buyDevFee = _buyDevFee;
630         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
631  
632         sellMarketingFee = _sellMarketingFee;
633         sellLiquidityFee = _sellLiquidityFee;
634         sellDevFee = _sellDevFee;
635         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
636  
637         marketingWallet = address(0x069A364CFfd78C40223997872c47D4f15C8223B7);
638         devWallet = address(0x46da76c225d92F33Fd706B03dd285d9dFD008837);
639  
640         // exclude from paying fees or having max transaction amount
641         excludeFromFees(owner(), true);
642         excludeFromFees(address(this), true);
643         excludeFromFees(address(0xdead), true);
644  
645         excludeFromMaxTransaction(owner(), true);
646         excludeFromMaxTransaction(address(this), true);
647         excludeFromMaxTransaction(address(0xdead), true);
648  
649         /*
650             _mint is an internal function in ERC20.sol that is only called here,
651             and CANNOT be called ever again
652         */
653         _mint(msg.sender, totalSupply);
654     }
655  
656     receive() external payable {
657  
658     }
659  
660     // once enabled, can never be turned off
661     function enableTrading() external onlyOwner {
662         tradingActive = true;
663         swapEnabled = true;
664         launchedAt = block.number;
665     }
666  
667     // remove limits after token is stable
668     function removeLimits() external onlyOwner returns (bool){
669         limitsInEffect = false;
670         return true;
671     }
672  
673     // disable Transfer delay - cannot be reenabled
674     function disableTransferDelay() external onlyOwner returns (bool){
675         transferDelayEnabled = false;
676         return true;
677     }
678  
679      // change the minimum amount of tokens to sell from fees
680     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
681         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
682         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
683         swapTokensAtAmount = newAmount;
684         return true;
685     }
686  
687     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
688         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
689         maxTransactionAmount = newNum * (10**18);
690     }
691  
692     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
693         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
694         maxWallet = newNum * (10**18);
695     }
696  
697     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
698         _isExcludedMaxTransactionAmount[updAds] = isEx;
699     }
700 
701           function updateBuyFees(
702         uint256 _devFee,
703         uint256 _liquidityFee,
704         uint256 _marketingFee
705     ) external onlyOwner {
706         buyDevFee = _devFee;
707         buyLiquidityFee = _liquidityFee;
708         buyMarketingFee = _marketingFee;
709         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
710     }
711 
712     function updateSellFees(
713         uint256 _devFee,
714         uint256 _liquidityFee,
715         uint256 _marketingFee
716     ) external onlyOwner {
717         sellDevFee = _devFee;
718         sellLiquidityFee = _liquidityFee;
719         sellMarketingFee = _marketingFee;
720         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
721     }
722  
723     // only use to disable contract sales if absolutely necessary (emergency use only)
724     function updateSwapEnabled(bool enabled) external onlyOwner(){
725         swapEnabled = enabled;
726     }
727  
728     function excludeFromFees(address account, bool excluded) public onlyOwner {
729         _isExcludedFromFees[account] = excluded;
730         emit ExcludeFromFees(account, excluded);
731     }
732  
733     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
734         _blacklist[account] = isBlacklisted;
735     }
736  
737     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
738         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
739  
740         _setAutomatedMarketMakerPair(pair, value);
741     }
742  
743     function _setAutomatedMarketMakerPair(address pair, bool value) private {
744         automatedMarketMakerPairs[pair] = value;
745  
746         emit SetAutomatedMarketMakerPair(pair, value);
747     }
748  
749     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
750         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
751         marketingWallet = newMarketingWallet;
752     }
753  
754     function updateDevWallet(address newWallet) external onlyOwner {
755         emit devWalletUpdated(newWallet, devWallet);
756         devWallet = newWallet;
757     }
758  
759  
760     function isExcludedFromFees(address account) public view returns(bool) {
761         return _isExcludedFromFees[account];
762     }
763  
764     function _transfer(
765         address from,
766         address to,
767         uint256 amount
768     ) internal override {
769         require(from != address(0), "ERC20: transfer from the zero address");
770         require(to != address(0), "ERC20: transfer to the zero address");
771         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
772          if(amount == 0) {
773             super._transfer(from, to, 0);
774             return;
775         }
776  
777         if(limitsInEffect){
778             if (
779                 from != owner() &&
780                 to != owner() &&
781                 to != address(0) &&
782                 to != address(0xdead) &&
783                 !swapping
784             ){
785                 if(!tradingActive){
786                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
787                 }
788  
789                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
790                 if (transferDelayEnabled){
791                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
792                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
793                         _holderLastTransferTimestamp[tx.origin] = block.number;
794                     }
795                 }
796  
797                 //when buy
798                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
799                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
800                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
801                 }
802  
803                 //when sell
804                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
805                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
806                 }
807                 else if(!_isExcludedMaxTransactionAmount[to]){
808                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
809                 }
810             }
811         }
812  
813         uint256 contractTokenBalance = balanceOf(address(this));
814  
815         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
816  
817         if( 
818             canSwap &&
819             swapEnabled &&
820             !swapping &&
821             !automatedMarketMakerPairs[from] &&
822             !_isExcludedFromFees[from] &&
823             !_isExcludedFromFees[to]
824         ) {
825             swapping = true;
826  
827             swapBack();
828  
829             swapping = false;
830         }
831  
832         bool takeFee = !swapping;
833  
834         // if any account belongs to _isExcludedFromFee account then remove the fee
835         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
836             takeFee = false;
837         }
838  
839         uint256 fees = 0;
840         // only take fees on buys/sells, do not take on wallet transfers
841         if(takeFee){
842             // on sell
843             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
844                 fees = amount.mul(sellTotalFees).div(100);
845                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
846                 tokensForDev += fees * sellDevFee / sellTotalFees;
847                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
848             }
849             // on buy
850             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
851                 fees = amount.mul(buyTotalFees).div(100);
852                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
853                 tokensForDev += fees * buyDevFee / buyTotalFees;
854                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
855             }
856  
857             if(fees > 0){    
858                 super._transfer(from, address(this), fees);
859             }
860  
861             amount -= fees;
862         }
863  
864         super._transfer(from, to, amount);
865     }
866  
867     function swapTokensForEth(uint256 tokenAmount) private {
868  
869         // generate the uniswap pair path of token -> weth
870         address[] memory path = new address[](2);
871         path[0] = address(this);
872         path[1] = uniswapV2Router.WETH();
873  
874         _approve(address(this), address(uniswapV2Router), tokenAmount);
875  
876         // make the swap
877         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
878             tokenAmount,
879             0, // accept any amount of ETH
880             path,
881             address(this),
882             block.timestamp
883         );
884  
885     }
886  
887     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
888         // approve token transfer to cover all possible scenarios
889         _approve(address(this), address(uniswapV2Router), tokenAmount);
890  
891         // add the liquidity
892         uniswapV2Router.addLiquidityETH{value: ethAmount}(
893             address(this),
894             tokenAmount,
895             0, // slippage is unavoidable
896             0, // slippage is unavoidable
897             address(this),
898             block.timestamp
899         );
900     }
901  
902     function swapBack() private {
903         uint256 contractBalance = balanceOf(address(this));
904         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
905         bool success;
906  
907         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
908  
909         if(contractBalance > swapTokensAtAmount * 20){
910           contractBalance = swapTokensAtAmount * 20;
911         }
912  
913         // Halve the amount of liquidity tokens
914         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
915         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
916  
917         uint256 initialETHBalance = address(this).balance;
918  
919         swapTokensForEth(amountToSwapForETH); 
920  
921         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
922  
923         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
924         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
925         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
926  
927  
928         tokensForLiquidity = 0;
929         tokensForMarketing = 0;
930         tokensForDev = 0;
931  
932         (success,) = address(devWallet).call{value: ethForDev}("");
933  
934         if(liquidityTokens > 0 && ethForLiquidity > 0){
935             addLiquidity(liquidityTokens, ethForLiquidity);
936             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
937         }
938  
939         (success,) = address(marketingWallet).call{value: address(this).balance}("");
940     }
941 }