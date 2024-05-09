1 // SPDX-License-Identifier: Unlicensed
2 
3 // 🌐 Website: https://yolocoin.tech/
4 // 💫 TG: https://t.me/yolocoineth
5 // 🐦 Twitter: https://twitter.com/yolocoinerc
6 
7 pragma solidity 0.8.11;
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
520 contract YOLOCOIN  is ERC20, Ownable {
521     using SafeMath for uint256;
522  
523     IUniswapV2Router02 public immutable uniswapV2Router;
524     address public immutable uniswapV2Pair;
525  
526     bool private swapping;
527  
528     address private marketingWallet;
529     address private devWallet;
530  
531     uint256 public maxTransactionAmount;
532     uint256 public swapTokensAtAmount;
533     uint256 public maxWallet;
534  
535     bool public limitsInEffect = true;
536     bool public tradingActive = false;
537     bool public swapEnabled = false;
538  
539      // Anti-bot and anti-whale mappings and variables
540     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
541  
542     // Seller Map
543     mapping (address => uint256) private _holderFirstBuyTimestamp;
544  
545     // Blacklist Map
546     mapping (address => bool) private _blacklist;
547     bool public transferDelayEnabled = true;
548  
549     uint256 public buyTotalFees;
550     uint256 public buyMarketingFee;
551     uint256 public buyLiquidityFee;
552     uint256 public buyDevFee;
553  
554     uint256 public sellTotalFees;
555     uint256 public sellMarketingFee;
556     uint256 public sellLiquidityFee;
557     uint256 public sellDevFee;
558  
559     uint256 public tokensForMarketing;
560     uint256 public tokensForLiquidity;
561     uint256 public tokensForDev;
562  
563     // block number of opened trading
564     uint256 launchedAt;
565  
566     /******************/
567  
568     // exclude from fees and max transaction amount
569     mapping (address => bool) private _isExcludedFromFees;
570     mapping (address => bool) public _isExcludedMaxTransactionAmount;
571  
572     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
573     // could be subject to a maximum transfer amount
574     mapping (address => bool) public automatedMarketMakerPairs;
575  
576     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
577  
578     event ExcludeFromFees(address indexed account, bool isExcluded);
579  
580     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
581  
582     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
583  
584     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
585  
586     event SwapAndLiquify(
587         uint256 tokensSwapped,
588         uint256 ethReceived,
589         uint256 tokensIntoLiquidity
590     );
591  
592     event AutoNukeLP();
593  
594     event ManualNukeLP();
595  
596     constructor() ERC20("YOLOCOIN", "YOLO") {
597  
598         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
599  
600         excludeFromMaxTransaction(address(_uniswapV2Router), true);
601         uniswapV2Router = _uniswapV2Router;
602  
603         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
604         excludeFromMaxTransaction(address(uniswapV2Pair), true);
605         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
606  
607         uint256 _buyMarketingFee = 3;
608         uint256 _buyLiquidityFee = 0;
609         uint256 _buyDevFee = 0;
610  
611         uint256 _sellMarketingFee = 3;
612         uint256 _sellLiquidityFee = 0;
613         uint256 _sellDevFee = 0;
614  
615         uint256 totalSupply = 1000000000 * 1e18;
616  
617         maxTransactionAmount = totalSupply * 20 / 1000; // 2%
618         maxWallet = totalSupply * 20 / 1000; // 2% 
619         swapTokensAtAmount = totalSupply * 4 / 10000; // 0.1%
620  
621         buyMarketingFee = _buyMarketingFee;
622         buyLiquidityFee = _buyLiquidityFee;
623         buyDevFee = _buyDevFee;
624         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
625  
626         sellMarketingFee = _sellMarketingFee;
627         sellLiquidityFee = _sellLiquidityFee;
628         sellDevFee = _sellDevFee;
629         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
630  
631         marketingWallet = address(0x04031B178A5819Ab21786059B5ECb041E41338D6);
632         devWallet = address(0xAA6313B07499664D0912aB19B394fc7eF50556a2);
633  
634         // exclude from paying fees or having max transaction amount
635         excludeFromFees(owner(), true);
636         excludeFromFees(address(this), true);
637         excludeFromFees(address(0xdead), true);
638  
639         excludeFromMaxTransaction(owner(), true);
640         excludeFromMaxTransaction(address(this), true);
641         excludeFromMaxTransaction(address(0xdead), true);
642  
643         /*
644             _mint is an internal function in ERC20.sol that is only called here,
645             and CANNOT be called ever again
646         */
647         _mint(msg.sender, totalSupply);
648     }
649  
650     receive() external payable {
651  
652     }
653  
654     // once enabled, can never be turned off
655     function enableTrading() external onlyOwner {
656         tradingActive = true;
657         swapEnabled = true;
658         launchedAt = block.number;
659     }
660  
661     // remove limits after token is stable
662     function removeLimits() external onlyOwner returns (bool){
663         limitsInEffect = false;
664         return true;
665     }
666  
667     // disable Transfer delay - cannot be reenabled
668     function disableTransferDelay() external onlyOwner returns (bool){
669         transferDelayEnabled = false;
670         return true;
671     }
672  
673      // change the minimum amount of tokens to sell from fees
674     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
675         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
676         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
677         swapTokensAtAmount = newAmount;
678         return true;
679     }
680  
681     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
682         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
683         maxTransactionAmount = newNum * (10**18);
684     }
685  
686     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
687         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
688         maxWallet = newNum * (10**18);
689     }
690  
691     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
692         _isExcludedMaxTransactionAmount[updAds] = isEx;
693     }
694 
695           function updateBuyFees(
696         uint256 _devFee,
697         uint256 _liquidityFee,
698         uint256 _marketingFee
699     ) external onlyOwner {
700         buyDevFee = _devFee;
701         buyLiquidityFee = _liquidityFee;
702         buyMarketingFee = _marketingFee;
703         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
704     }
705 
706     function updateSellFees(
707         uint256 _devFee,
708         uint256 _liquidityFee,
709         uint256 _marketingFee
710     ) external onlyOwner {
711         sellDevFee = _devFee;
712         sellLiquidityFee = _liquidityFee;
713         sellMarketingFee = _marketingFee;
714         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
715     }
716  
717     // only use to disable contract sales if absolutely necessary (emergency use only)
718     function updateSwapEnabled(bool enabled) external onlyOwner(){
719         swapEnabled = enabled;
720     }
721  
722     function excludeFromFees(address account, bool excluded) public onlyOwner {
723         _isExcludedFromFees[account] = excluded;
724         emit ExcludeFromFees(account, excluded);
725     }
726  
727     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
728         _blacklist[account] = isBlacklisted;
729     }
730  
731     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
732         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
733  
734         _setAutomatedMarketMakerPair(pair, value);
735     }
736  
737     function _setAutomatedMarketMakerPair(address pair, bool value) private {
738         automatedMarketMakerPairs[pair] = value;
739  
740         emit SetAutomatedMarketMakerPair(pair, value);
741     }
742  
743     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
744         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
745         marketingWallet = newMarketingWallet;
746     }
747  
748     function updateDevWallet(address newWallet) external onlyOwner {
749         emit devWalletUpdated(newWallet, devWallet);
750         devWallet = newWallet;
751     }
752  
753  
754     function isExcludedFromFees(address account) public view returns(bool) {
755         return _isExcludedFromFees[account];
756     }
757  
758     function _transfer(
759         address from,
760         address to,
761         uint256 amount
762     ) internal override {
763         require(from != address(0), "ERC20: transfer from the zero address");
764         require(to != address(0), "ERC20: transfer to the zero address");
765         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
766          if(amount == 0) {
767             super._transfer(from, to, 0);
768             return;
769         }
770  
771         if(limitsInEffect){
772             if (
773                 from != owner() &&
774                 to != owner() &&
775                 to != address(0) &&
776                 to != address(0xdead) &&
777                 !swapping
778             ){
779                 if(!tradingActive){
780                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
781                 }
782  
783                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
784                 if (transferDelayEnabled){
785                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
786                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
787                         _holderLastTransferTimestamp[tx.origin] = block.number;
788                     }
789                 }
790  
791                 //when buy
792                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
793                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
794                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
795                 }
796  
797                 //when sell
798                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
799                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
800                 }
801                 else if(!_isExcludedMaxTransactionAmount[to]){
802                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
803                 }
804             }
805         }
806  
807         uint256 contractTokenBalance = balanceOf(address(this));
808  
809         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
810  
811         if( 
812             canSwap &&
813             swapEnabled &&
814             !swapping &&
815             !automatedMarketMakerPairs[from] &&
816             !_isExcludedFromFees[from] &&
817             !_isExcludedFromFees[to]
818         ) {
819             swapping = true;
820  
821             swapBack();
822  
823             swapping = false;
824         }
825  
826         bool takeFee = !swapping;
827  
828         // if any account belongs to _isExcludedFromFee account then remove the fee
829         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
830             takeFee = false;
831         }
832  
833         uint256 fees = 0;
834         // only take fees on buys/sells, do not take on wallet transfers
835         if(takeFee){
836             // on sell
837             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
838                 fees = amount.mul(sellTotalFees).div(100);
839                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
840                 tokensForDev += fees * sellDevFee / sellTotalFees;
841                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
842             }
843             // on buy
844             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
845                 fees = amount.mul(buyTotalFees).div(100);
846                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
847                 tokensForDev += fees * buyDevFee / buyTotalFees;
848                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
849             }
850  
851             if(fees > 0){    
852                 super._transfer(from, address(this), fees);
853             }
854  
855             amount -= fees;
856         }
857  
858         super._transfer(from, to, amount);
859     }
860  
861     function swapTokensForEth(uint256 tokenAmount) private {
862  
863         // generate the uniswap pair path of token -> weth
864         address[] memory path = new address[](2);
865         path[0] = address(this);
866         path[1] = uniswapV2Router.WETH();
867  
868         _approve(address(this), address(uniswapV2Router), tokenAmount);
869  
870         // make the swap
871         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
872             tokenAmount,
873             0, // accept any amount of ETH
874             path,
875             address(this),
876             block.timestamp
877         );
878  
879     }
880  
881     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
882         // approve token transfer to cover all possible scenarios
883         _approve(address(this), address(uniswapV2Router), tokenAmount);
884  
885         // add the liquidity
886         uniswapV2Router.addLiquidityETH{value: ethAmount}(
887             address(this),
888             tokenAmount,
889             0, // slippage is unavoidable
890             0, // slippage is unavoidable
891             address(this),
892             block.timestamp
893         );
894     }
895  
896     function swapBack() private {
897         uint256 contractBalance = balanceOf(address(this));
898         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
899         bool success;
900  
901         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
902  
903         if(contractBalance > swapTokensAtAmount * 20){
904           contractBalance = swapTokensAtAmount * 20;
905         }
906  
907         // Halve the amount of liquidity tokens
908         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
909         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
910  
911         uint256 initialETHBalance = address(this).balance;
912  
913         swapTokensForEth(amountToSwapForETH); 
914  
915         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
916  
917         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
918         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
919         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
920  
921  
922         tokensForLiquidity = 0;
923         tokensForMarketing = 0;
924         tokensForDev = 0;
925  
926         (success,) = address(devWallet).call{value: ethForDev}("");
927  
928         if(liquidityTokens > 0 && ethForLiquidity > 0){
929             addLiquidity(liquidityTokens, ethForLiquidity);
930             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
931         }
932  
933         (success,) = address(marketingWallet).call{value: address(this).balance}("");
934     }
935 }