1 /*
2 
3 
4 He Sold? Pump It! is a Memecoin token based on the Ethereum blockchain. 
5 The token was designed to be a decentralized finance (DeFi) project that allows users to trade and store value on the ERC20 token standard.
6 
7 Tax: 0%
8 
9 
10 Website: https://pumpit.vip/
11 
12 Twitter: https://twitter.com/HeSoldPumpITERC
13 
14 Telegram: https://t.me/HeSoldPumpItERC
15 
16 
17 ██╗  ██╗███████╗    ███████╗ ██████╗ ██╗     ██████╗ ██████╗     ██████╗ ██╗   ██╗███╗   ███╗██████╗     ██╗████████╗██╗
18 ██║  ██║██╔════╝    ██╔════╝██╔═══██╗██║     ██╔══██╗╚════██╗    ██╔══██╗██║   ██║████╗ ████║██╔══██╗    ██║╚══██╔══╝██║
19 ███████║█████╗      ███████╗██║   ██║██║     ██║  ██║  ▄███╔╝    ██████╔╝██║   ██║██╔████╔██║██████╔╝    ██║   ██║   ██║
20 ██╔══██║██╔══╝      ╚════██║██║   ██║██║     ██║  ██║  ▀▀══╝     ██╔═══╝ ██║   ██║██║╚██╔╝██║██╔═══╝     ██║   ██║   ╚═╝
21 ██║  ██║███████╗    ███████║╚██████╔╝███████╗██████╔╝  ██╗       ██║     ╚██████╔╝██║ ╚═╝ ██║██║         ██║   ██║   ██╗
22 ╚═╝  ╚═╝╚══════╝    ╚══════╝ ╚═════╝ ╚══════╝╚═════╝   ╚═╝       ╚═╝      ╚═════╝ ╚═╝     ╚═╝╚═╝         ╚═╝   ╚═╝   ╚═╝
23                                                                                                                         
24 
25 
26 
27 */
28 
29 // SPDX-License-Identifier: Unlicensed
30 
31 pragma solidity 0.8.11;
32  
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37  
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42  
43 interface IUniswapV2Pair {
44     event Approval(address indexed owner, address indexed spender, uint value);
45     event Transfer(address indexed from, address indexed to, uint value);
46  
47     function name() external pure returns (string memory);
48     function symbol() external pure returns (string memory);
49     function decimals() external pure returns (uint8);
50     function totalSupply() external view returns (uint);
51     function balanceOf(address owner) external view returns (uint);
52     function allowance(address owner, address spender) external view returns (uint);
53  
54     function approve(address spender, uint value) external returns (bool);
55     function transfer(address to, uint value) external returns (bool);
56     function transferFrom(address from, address to, uint value) external returns (bool);
57  
58     function DOMAIN_SEPARATOR() external view returns (bytes32);
59     function PERMIT_TYPEHASH() external pure returns (bytes32);
60     function nonces(address owner) external view returns (uint);
61  
62     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
63  
64     event Mint(address indexed sender, uint amount0, uint amount1);
65     event Swap(
66         address indexed sender,
67         uint amount0In,
68         uint amount1In,
69         uint amount0Out,
70         uint amount1Out,
71         address indexed to
72     );
73     event Sync(uint112 reserve0, uint112 reserve1);
74  
75     function MINIMUM_LIQUIDITY() external pure returns (uint);
76     function factory() external view returns (address);
77     function token0() external view returns (address);
78     function token1() external view returns (address);
79     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
80     function price0CumulativeLast() external view returns (uint);
81     function price1CumulativeLast() external view returns (uint);
82     function kLast() external view returns (uint);
83  
84     function mint(address to) external returns (uint liquidity);
85     function burn(address to) external returns (uint amount0, uint amount1);
86     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
87     function skim(address to) external;
88     function sync() external;
89  
90     function initialize(address, address) external;
91 }
92  
93 interface IUniswapV2Factory {
94     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
95  
96     function feeTo() external view returns (address);
97     function feeToSetter() external view returns (address);
98  
99     function getPair(address tokenA, address tokenB) external view returns (address pair);
100     function allPairs(uint) external view returns (address pair);
101     function allPairsLength() external view returns (uint);
102  
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104  
105     function setFeeTo(address) external;
106     function setFeeToSetter(address) external;
107 }
108  
109 interface IERC20 {
110 
111     function totalSupply() external view returns (uint256);
112 
113     function balanceOf(address account) external view returns (uint256);
114 
115     function transfer(address recipient, uint256 amount) external returns (bool);
116 
117     function allowance(address owner, address spender) external view returns (uint256);
118 
119     function approve(address spender, uint256 amount) external returns (bool);
120 
121     function transferFrom(
122         address sender,
123         address recipient,
124         uint256 amount
125     ) external returns (bool);
126 
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131  
132 interface IERC20Metadata is IERC20 {
133 
134     function name() external view returns (string memory);
135 
136     function symbol() external view returns (string memory);
137 
138     function decimals() external view returns (uint8);
139 }
140  
141  
142 contract ERC20 is Context, IERC20, IERC20Metadata {
143     using SafeMath for uint256;
144  
145     mapping(address => uint256) private _balances;
146  
147     mapping(address => mapping(address => uint256)) private _allowances;
148  
149     uint256 private _totalSupply;
150  
151     string private _name;
152     string private _symbol;
153 
154     constructor(string memory name_, string memory symbol_) {
155         _name = name_;
156         _symbol = symbol_;
157     }
158 
159     function name() public view virtual override returns (string memory) {
160         return _name;
161     }
162 
163     function symbol() public view virtual override returns (string memory) {
164         return _symbol;
165     }
166 
167     function decimals() public view virtual override returns (uint8) {
168         return 18;
169     }
170 
171     function totalSupply() public view virtual override returns (uint256) {
172         return _totalSupply;
173     }
174 
175     function balanceOf(address account) public view virtual override returns (uint256) {
176         return _balances[account];
177     }
178 
179     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
180         _transfer(_msgSender(), recipient, amount);
181         return true;
182     }
183 
184     function allowance(address owner, address spender) public view virtual override returns (uint256) {
185         return _allowances[owner][spender];
186     }
187 
188     function approve(address spender, uint256 amount) public virtual override returns (bool) {
189         _approve(_msgSender(), spender, amount);
190         return true;
191     }
192 
193     function transferFrom(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) public virtual override returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202 
203     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
204         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
205         return true;
206     }
207 
208     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
209         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
210         return true;
211     }
212 
213     function _transfer(
214         address sender,
215         address recipient,
216         uint256 amount
217     ) internal virtual {
218         require(sender != address(0), "ERC20: transfer from the zero address");
219         require(recipient != address(0), "ERC20: transfer to the zero address");
220  
221         _beforeTokenTransfer(sender, recipient, amount);
222  
223         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
224         _balances[recipient] = _balances[recipient].add(amount);
225         emit Transfer(sender, recipient, amount);
226     }
227 
228     function _mint(address account, uint256 amount) internal virtual {
229         require(account != address(0), "ERC20: mint to the zero address");
230  
231         _beforeTokenTransfer(address(0), account, amount);
232  
233         _totalSupply = _totalSupply.add(amount);
234         _balances[account] = _balances[account].add(amount);
235         emit Transfer(address(0), account, amount);
236     }
237 
238     function _burn(address account, uint256 amount) internal virtual {
239         require(account != address(0), "ERC20: burn from the zero address");
240  
241         _beforeTokenTransfer(account, address(0), amount);
242  
243         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
244         _totalSupply = _totalSupply.sub(amount);
245         emit Transfer(account, address(0), amount);
246     }
247 
248     function _approve(
249         address owner,
250         address spender,
251         uint256 amount
252     ) internal virtual {
253         require(owner != address(0), "ERC20: approve from the zero address");
254         require(spender != address(0), "ERC20: approve to the zero address");
255  
256         _allowances[owner][spender] = amount;
257         emit Approval(owner, spender, amount);
258     }
259 
260     function _beforeTokenTransfer(
261         address from,
262         address to,
263         uint256 amount
264     ) internal virtual {}
265 }
266  
267 library SafeMath {
268 
269     function add(uint256 a, uint256 b) internal pure returns (uint256) {
270         uint256 c = a + b;
271         require(c >= a, "SafeMath: addition overflow");
272  
273         return c;
274     }
275 
276     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
277         return sub(a, b, "SafeMath: subtraction overflow");
278     }
279 
280     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         require(b <= a, errorMessage);
282         uint256 c = a - b;
283  
284         return c;
285     }
286 
287     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
288 
289         if (a == 0) {
290             return 0;
291         }
292  
293         uint256 c = a * b;
294         require(c / a == b, "SafeMath: multiplication overflow");
295  
296         return c;
297     }
298 
299     function div(uint256 a, uint256 b) internal pure returns (uint256) {
300         return div(a, b, "SafeMath: division by zero");
301     }
302 
303     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         require(b > 0, errorMessage);
305         uint256 c = a / b;
306         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
307  
308         return c;
309     }
310 
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         return mod(a, b, "SafeMath: modulo by zero");
313     }
314 
315     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         require(b != 0, errorMessage);
317         return a % b;
318     }
319 }
320  
321 contract Ownable is Context {
322     address private _owner;
323  
324     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
325 
326     constructor () {
327         address msgSender = _msgSender();
328         _owner = msgSender;
329         emit OwnershipTransferred(address(0), msgSender);
330     }
331 
332     function owner() public view returns (address) {
333         return _owner;
334     }
335 
336     modifier onlyOwner() {
337         require(_owner == _msgSender(), "Ownable: caller is not the owner");
338         _;
339     }
340 
341     function renounceOwnership() public virtual onlyOwner {
342         emit OwnershipTransferred(_owner, address(0));
343         _owner = address(0);
344     }
345 
346     function transferOwnership(address newOwner) public virtual onlyOwner {
347         require(newOwner != address(0), "Ownable: new owner is the zero address");
348         emit OwnershipTransferred(_owner, newOwner);
349         _owner = newOwner;
350     }
351 }
352  
353  
354  
355 library SafeMathInt {
356     int256 private constant MIN_INT256 = int256(1) << 255;
357     int256 private constant MAX_INT256 = ~(int256(1) << 255);
358 
359     function mul(int256 a, int256 b) internal pure returns (int256) {
360         int256 c = a * b;
361  
362         // Detect overflow when multiplying MIN_INT256 with -1
363         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
364         require((b == 0) || (c / b == a));
365         return c;
366     }
367 
368     function div(int256 a, int256 b) internal pure returns (int256) {
369         // Prevent overflow when dividing MIN_INT256 by -1
370         require(b != -1 || a != MIN_INT256);
371  
372         // Solidity already throws when dividing by 0.
373         return a / b;
374     }
375 
376     function sub(int256 a, int256 b) internal pure returns (int256) {
377         int256 c = a - b;
378         require((b >= 0 && c <= a) || (b < 0 && c > a));
379         return c;
380     }
381 
382     function add(int256 a, int256 b) internal pure returns (int256) {
383         int256 c = a + b;
384         require((b >= 0 && c >= a) || (b < 0 && c < a));
385         return c;
386     }
387 
388     function abs(int256 a) internal pure returns (int256) {
389         require(a != MIN_INT256);
390         return a < 0 ? -a : a;
391     }
392  
393  
394     function toUint256Safe(int256 a) internal pure returns (uint256) {
395         require(a >= 0);
396         return uint256(a);
397     }
398 }
399  
400 library SafeMathUint {
401   function toInt256Safe(uint256 a) internal pure returns (int256) {
402     int256 b = int256(a);
403     require(b >= 0);
404     return b;
405   }
406 }
407  
408  
409 interface IUniswapV2Router01 {
410     function factory() external pure returns (address);
411     function WETH() external pure returns (address);
412  
413     function addLiquidity(
414         address tokenA,
415         address tokenB,
416         uint amountADesired,
417         uint amountBDesired,
418         uint amountAMin,
419         uint amountBMin,
420         address to,
421         uint deadline
422     ) external returns (uint amountA, uint amountB, uint liquidity);
423     function addLiquidityETH(
424         address token,
425         uint amountTokenDesired,
426         uint amountTokenMin,
427         uint amountETHMin,
428         address to,
429         uint deadline
430     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
431     function removeLiquidity(
432         address tokenA,
433         address tokenB,
434         uint liquidity,
435         uint amountAMin,
436         uint amountBMin,
437         address to,
438         uint deadline
439     ) external returns (uint amountA, uint amountB);
440     function removeLiquidityETH(
441         address token,
442         uint liquidity,
443         uint amountTokenMin,
444         uint amountETHMin,
445         address to,
446         uint deadline
447     ) external returns (uint amountToken, uint amountETH);
448     function removeLiquidityWithPermit(
449         address tokenA,
450         address tokenB,
451         uint liquidity,
452         uint amountAMin,
453         uint amountBMin,
454         address to,
455         uint deadline,
456         bool approveMax, uint8 v, bytes32 r, bytes32 s
457     ) external returns (uint amountA, uint amountB);
458     function removeLiquidityETHWithPermit(
459         address token,
460         uint liquidity,
461         uint amountTokenMin,
462         uint amountETHMin,
463         address to,
464         uint deadline,
465         bool approveMax, uint8 v, bytes32 r, bytes32 s
466     ) external returns (uint amountToken, uint amountETH);
467     function swapExactTokensForTokens(
468         uint amountIn,
469         uint amountOutMin,
470         address[] calldata path,
471         address to,
472         uint deadline
473     ) external returns (uint[] memory amounts);
474     function swapTokensForExactTokens(
475         uint amountOut,
476         uint amountInMax,
477         address[] calldata path,
478         address to,
479         uint deadline
480     ) external returns (uint[] memory amounts);
481     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
482         external
483         payable
484         returns (uint[] memory amounts);
485     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
486         external
487         returns (uint[] memory amounts);
488     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
489         external
490         returns (uint[] memory amounts);
491     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
492         external
493         payable
494         returns (uint[] memory amounts);
495  
496     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
497     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
498     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
499     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
500     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
501 }
502  
503 interface IUniswapV2Router02 is IUniswapV2Router01 {
504     function removeLiquidityETHSupportingFeeOnTransferTokens(
505         address token,
506         uint liquidity,
507         uint amountTokenMin,
508         uint amountETHMin,
509         address to,
510         uint deadline
511     ) external returns (uint amountETH);
512     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
513         address token,
514         uint liquidity,
515         uint amountTokenMin,
516         uint amountETHMin,
517         address to,
518         uint deadline,
519         bool approveMax, uint8 v, bytes32 r, bytes32 s
520     ) external returns (uint amountETH);
521  
522     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
523         uint amountIn,
524         uint amountOutMin,
525         address[] calldata path,
526         address to,
527         uint deadline
528     ) external;
529     function swapExactETHForTokensSupportingFeeOnTransferTokens(
530         uint amountOutMin,
531         address[] calldata path,
532         address to,
533         uint deadline
534     ) external payable;
535     function swapExactTokensForETHSupportingFeeOnTransferTokens(
536         uint amountIn,
537         uint amountOutMin,
538         address[] calldata path,
539         address to,
540         uint deadline
541     ) external;
542 }
543  
544 contract Pump is ERC20, Ownable {
545     using SafeMath for uint256;
546  
547     IUniswapV2Router02 public immutable uniswapV2Router;
548     address public immutable uniswapV2Pair;
549  
550     bool private swapping;
551  
552     address private marketingWallet;
553     address private devWallet;
554  
555     uint256 public maxTransactionAmount;
556     uint256 public swapTokensAtAmount;
557     uint256 public maxWallet;
558  
559     bool public limitsInEffect = true;
560     bool public tradingActive = false;
561     bool public swapEnabled = false;
562  
563      // Anti-bot and anti-whale mappings and variables
564     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
565  
566     // Seller Map
567     mapping (address => uint256) private _holderFirstBuyTimestamp;
568  
569     // Blacklist Map
570     mapping (address => bool) private _blacklist;
571     bool public transferDelayEnabled = false;
572  
573     uint256 public buyTotalFees;
574     uint256 public buyMarketingFee;
575     uint256 public buyLiquidityFee;
576     uint256 public buyDevFee;
577  
578     uint256 public sellTotalFees;
579     uint256 public sellMarketingFee;
580     uint256 public sellLiquidityFee;
581     uint256 public sellDevFee;
582  
583     uint256 public tokensForMarketing;
584     uint256 public tokensForLiquidity;
585     uint256 public tokensForDev;
586  
587     // block number of opened trading
588     uint256 launchedAt;
589  
590     /******************/
591  
592     // exclude from fees and max transaction amount
593     mapping (address => bool) private _isExcludedFromFees;
594     mapping (address => bool) public _isExcludedMaxTransactionAmount;
595  
596     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
597     // could be subject to a maximum transfer amount
598     mapping (address => bool) public automatedMarketMakerPairs;
599  
600     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
601  
602     event ExcludeFromFees(address indexed account, bool isExcluded);
603  
604     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
605  
606     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
607  
608     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
609  
610     event SwapAndLiquify(
611         uint256 tokensSwapped,
612         uint256 ethReceived,
613         uint256 tokensIntoLiquidity
614     );
615  
616     event AutoNukeLP();
617  
618     event ManualNukeLP();
619  
620     constructor() ERC20("He Sold? Pump IT!", "PUMP") {
621  
622         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
623  
624         excludeFromMaxTransaction(address(_uniswapV2Router), true);
625         uniswapV2Router = _uniswapV2Router;
626  
627         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
628         excludeFromMaxTransaction(address(uniswapV2Pair), true);
629         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
630  
631         uint256 _buyMarketingFee = 25;
632         uint256 _buyLiquidityFee = 0;
633         uint256 _buyDevFee = 0;
634  
635         uint256 _sellMarketingFee = 25;
636         uint256 _sellLiquidityFee = 0;
637         uint256 _sellDevFee = 0;
638  
639         uint256 totalSupply = 100000000000000 * 1e18;
640  
641         maxTransactionAmount = totalSupply * 200 / 1000; // .5%
642         maxWallet = totalSupply * 200 / 1000; // 1% 
643         swapTokensAtAmount = totalSupply * 100 / 10000; // 0.05%
644  
645         buyMarketingFee = _buyMarketingFee;
646         buyLiquidityFee = _buyLiquidityFee;
647         buyDevFee = _buyDevFee;
648         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
649  
650         sellMarketingFee = _sellMarketingFee;
651         sellLiquidityFee = _sellLiquidityFee;
652         sellDevFee = _sellDevFee;
653         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
654  
655         marketingWallet = address(0xCeF704c5b13153cA8E9349eD8245134bF0425001);
656         devWallet = address(0xCeF704c5b13153cA8E9349eD8245134bF0425001);
657  
658         // exclude from paying fees or having max transaction amount
659         excludeFromFees(owner(), true);
660         excludeFromFees(address(this), true);
661         excludeFromFees(address(0xdead), true);
662         excludeFromFees(address(marketingWallet), true);
663  
664         excludeFromMaxTransaction(owner(), true);
665         excludeFromMaxTransaction(address(this), true);
666         excludeFromMaxTransaction(address(0xdead), true);
667         excludeFromMaxTransaction(address(devWallet), true);
668         excludeFromMaxTransaction(address(marketingWallet), true);
669  
670         /*
671             _mint is an internal function in ERC20.sol that is only called here,
672             and CANNOT be called ever again
673         */
674         _mint(msg.sender, totalSupply);
675     }
676  
677     receive() external payable {
678  
679     }
680  
681     // once enabled, can never be turned off
682     function enableTrading() external onlyOwner {
683         tradingActive = true;
684         swapEnabled = true;
685         launchedAt = block.number;
686     }
687  
688     // remove limits after token is stable
689     function removeLimits() external onlyOwner returns (bool){
690         limitsInEffect = false;
691         return true;
692     }
693  
694     // disable Transfer delay - cannot be reenabled
695     function disableTransferDelay() external onlyOwner returns (bool){
696         transferDelayEnabled = false;
697         return true;
698     }
699  
700      // change the minimum amount of tokens to sell from fees
701     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
702         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
703         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
704         swapTokensAtAmount = newAmount;
705         return true;
706     }
707  
708     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
709         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
710         maxTransactionAmount = newNum * (10**18);
711     }
712  
713     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
714         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
715         maxWallet = newNum * (10**18);
716     }
717  
718     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
719         _isExcludedMaxTransactionAmount[updAds] = isEx;
720     }
721 
722     function updateBuyFees(
723         uint256 _devFee,
724         uint256 _liquidityFee,
725         uint256 _marketingFee
726     ) external onlyOwner {
727         buyDevFee = _devFee;
728         buyLiquidityFee = _liquidityFee;
729         buyMarketingFee = _marketingFee;
730         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
731     }
732 
733     function updateSellFees(
734         uint256 _devFee,
735         uint256 _liquidityFee,
736         uint256 _marketingFee
737     ) external onlyOwner {
738         sellDevFee = _devFee;
739         sellLiquidityFee = _liquidityFee;
740         sellMarketingFee = _marketingFee;
741         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
742     }
743  
744     // only use to disable contract sales if absolutely necessary (emergency use only)
745     function updateSwapEnabled(bool enabled) external onlyOwner(){
746         swapEnabled = enabled;
747     }
748  
749     function excludeFromFees(address account, bool excluded) public onlyOwner {
750         _isExcludedFromFees[account] = excluded;
751         emit ExcludeFromFees(account, excluded);
752     }
753  
754     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
755         _blacklist[account] = isBlacklisted;
756     }
757  
758     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
759         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
760  
761         _setAutomatedMarketMakerPair(pair, value);
762     }
763  
764     function _setAutomatedMarketMakerPair(address pair, bool value) private {
765         automatedMarketMakerPairs[pair] = value;
766  
767         emit SetAutomatedMarketMakerPair(pair, value);
768     }
769  
770     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
771         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
772         marketingWallet = newMarketingWallet;
773     }
774  
775     function updateDevWallet(address newWallet) external onlyOwner {
776         emit devWalletUpdated(newWallet, devWallet);
777         devWallet = newWallet;
778     }
779  
780  
781     function isExcludedFromFees(address account) public view returns(bool) {
782         return _isExcludedFromFees[account];
783     }
784  
785     function _transfer(
786         address from,
787         address to,
788         uint256 amount
789     ) internal override {
790         require(from != address(0), "ERC20: transfer from the zero address");
791         require(to != address(0), "ERC20: transfer to the zero address");
792         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
793          if(amount == 0) {
794             super._transfer(from, to, 0);
795             return;
796         }
797  
798         if(limitsInEffect){
799             if (
800                 from != owner() &&
801                 to != owner() &&
802                 to != address(0) &&
803                 to != address(0xdead) &&
804                 !swapping
805             ){
806                 if(!tradingActive){
807                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
808                 }
809  
810                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
811                 if (transferDelayEnabled){
812                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
813                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
814                         _holderLastTransferTimestamp[tx.origin] = block.number;
815                     }
816                 }
817  
818                 //when buy
819                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
820                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
821                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
822                 }
823  
824                 //when sell
825                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
826                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
827                 }
828                 else if(!_isExcludedMaxTransactionAmount[to]){
829                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
830                 }
831             }
832         }
833  
834         uint256 contractTokenBalance = balanceOf(address(this));
835  
836         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
837  
838         if( 
839             canSwap &&
840             swapEnabled &&
841             !swapping &&
842             !automatedMarketMakerPairs[from] &&
843             !_isExcludedFromFees[from] &&
844             !_isExcludedFromFees[to]
845         ) {
846             swapping = true;
847  
848             swapBack();
849  
850             swapping = false;
851         }
852  
853         bool takeFee = !swapping;
854  
855         // if any account belongs to _isExcludedFromFee account then remove the fee
856         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
857             takeFee = false;
858         }
859  
860         uint256 fees = 0;
861         // only take fees on buys/sells, do not take on wallet transfers
862         if(takeFee){
863             // on sell
864             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
865                 fees = amount.mul(sellTotalFees).div(100);
866                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
867                 tokensForDev += fees * sellDevFee / sellTotalFees;
868                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
869             }
870             // on buy
871             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
872                 fees = amount.mul(buyTotalFees).div(100);
873                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
874                 tokensForDev += fees * buyDevFee / buyTotalFees;
875                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
876             }
877  
878             if(fees > 0){    
879                 super._transfer(from, address(this), fees);
880             }
881  
882             amount -= fees;
883         }
884  
885         super._transfer(from, to, amount);
886     }
887  
888     function swapTokensForEth(uint256 tokenAmount) private {
889  
890         // generate the uniswap pair path of token -> weth
891         address[] memory path = new address[](2);
892         path[0] = address(this);
893         path[1] = uniswapV2Router.WETH();
894  
895         _approve(address(this), address(uniswapV2Router), tokenAmount);
896  
897         // make the swap
898         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
899             tokenAmount,
900             0, // accept any amount of ETH
901             path,
902             address(this),
903             block.timestamp
904         );
905  
906     }
907  
908     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
909         // approve token transfer to cover all possible scenarios
910         _approve(address(this), address(uniswapV2Router), tokenAmount);
911  
912         // add the liquidity
913         uniswapV2Router.addLiquidityETH{value: ethAmount}(
914             address(this),
915             tokenAmount,
916             0, // slippage is unavoidable
917             0, // slippage is unavoidable
918             address(this),
919             block.timestamp
920         );
921     }
922  
923     function swapBack() private {
924         uint256 contractBalance = balanceOf(address(this));
925         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
926         bool success;
927  
928         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
929  
930         if(contractBalance > swapTokensAtAmount * 20){
931           contractBalance = swapTokensAtAmount * 20;
932         }
933  
934         // Halve the amount of liquidity tokens
935         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
936         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
937  
938         uint256 initialETHBalance = address(this).balance;
939  
940         swapTokensForEth(amountToSwapForETH); 
941  
942         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
943  
944         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
945         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
946         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
947  
948  
949         tokensForLiquidity = 0;
950         tokensForMarketing = 0;
951         tokensForDev = 0;
952  
953         (success,) = address(devWallet).call{value: ethForDev}("");
954  
955         if(liquidityTokens > 0 && ethForLiquidity > 0){
956             addLiquidity(liquidityTokens, ethForLiquidity);
957             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
958         }
959  
960         (success,) = address(marketingWallet).call{value: address(this).balance}("");
961     }
962 }