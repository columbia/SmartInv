1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.11;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IUniswapV2Pair {
17     event Approval(address indexed owner, address indexed spender, uint value);
18     event Transfer(address indexed from, address indexed to, uint value);
19 
20     function name() external pure returns (string memory);
21     function symbol() external pure returns (string memory);
22     function decimals() external pure returns (uint8);
23     function totalSupply() external view returns (uint);
24     function balanceOf(address owner) external view returns (uint);
25     function allowance(address owner, address spender) external view returns (uint);
26 
27     function approve(address spender, uint value) external returns (bool);
28     function transfer(address to, uint value) external returns (bool);
29     function transferFrom(address from, address to, uint value) external returns (bool);
30 
31     function DOMAIN_SEPARATOR() external view returns (bytes32);
32     function PERMIT_TYPEHASH() external pure returns (bytes32);
33     function nonces(address owner) external view returns (uint);
34 
35     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
36 
37     event Mint(address indexed sender, uint amount0, uint amount1);
38     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
39     event Swap(
40         address indexed sender,
41         uint amount0In,
42         uint amount1In,
43         uint amount0Out,
44         uint amount1Out,
45         address indexed to
46     );
47     event Sync(uint112 reserve0, uint112 reserve1);
48 
49     function MINIMUM_LIQUIDITY() external pure returns (uint);
50     function factory() external view returns (address);
51     function token0() external view returns (address);
52     function token1() external view returns (address);
53     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
54     function price0CumulativeLast() external view returns (uint);
55     function price1CumulativeLast() external view returns (uint);
56     function kLast() external view returns (uint);
57 
58     function mint(address to) external returns (uint liquidity);
59     function burn(address to) external returns (uint amount0, uint amount1);
60     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
61     function skim(address to) external;
62     function sync() external;
63 
64     function initialize(address, address) external;
65 }
66 
67 interface IUniswapV2Factory {
68     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
69 
70     function feeTo() external view returns (address);
71     function feeToSetter() external view returns (address);
72 
73     function getPair(address tokenA, address tokenB) external view returns (address pair);
74     function allPairs(uint) external view returns (address pair);
75     function allPairsLength() external view returns (uint);
76 
77     function createPair(address tokenA, address tokenB) external returns (address pair);
78 
79     function setFeeTo(address) external;
80     function setFeeToSetter(address) external;
81 }
82 
83 interface IERC20 {
84     function totalSupply() external view returns (uint256);
85     function balanceOf(address account) external view returns (uint256);
86     function transfer(address recipient, uint256 amount) external returns (bool);
87     function allowance(address owner, address spender) external view returns (uint256);
88     function approve(address spender, uint256 amount) external returns (bool);
89     function transferFrom(
90         address sender,
91         address recipient,
92         uint256 amount
93     ) external returns (bool);
94     
95     event Transfer(address indexed from, address indexed to, uint256 value);
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 interface IERC20Metadata is IERC20 {
100     function name() external view returns (string memory);
101     function symbol() external view returns (string memory);
102     function decimals() external view returns (uint8);
103 }
104 
105 
106 contract ERC20 is Context, IERC20, IERC20Metadata {
107     using SafeMath for uint256;
108 
109     mapping(address => uint256) private _balances;
110 
111     mapping(address => mapping(address => uint256)) private _allowances;
112 
113     uint256 private _totalSupply;
114 
115     string private _name;
116     string private _symbol;
117 
118     constructor(string memory name_, string memory symbol_) {
119         _name = name_;
120         _symbol = symbol_;
121     }
122 
123     function name() public view virtual override returns (string memory) {
124         return _name;
125     }
126 
127     function symbol() public view virtual override returns (string memory) {
128         return _symbol;
129     }
130 
131     function decimals() public view virtual override returns (uint8) {
132         return 9;
133     }
134 
135     function totalSupply() public view virtual override returns (uint256) {
136         return _totalSupply;
137     }
138 
139     function balanceOf(address account) public view virtual override returns (uint256) {
140         return _balances[account];
141     }
142 
143     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
144         _transfer(_msgSender(), recipient, amount);
145         return true;
146     }
147 
148     function allowance(address owner, address spender) public view virtual override returns (uint256) {
149         return _allowances[owner][spender];
150     }
151 
152     function approve(address spender, uint256 amount) public virtual override returns (bool) {
153         _approve(_msgSender(), spender, amount);
154         return true;
155     }
156 
157     function transferFrom(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) public virtual override returns (bool) {
162         _transfer(sender, recipient, amount);
163         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
164         return true;
165     }
166 
167     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
168         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
169         return true;
170     }
171 
172     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
173         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
174         return true;
175     }
176 
177     function _transfer(
178         address sender,
179         address recipient,
180         uint256 amount
181     ) internal virtual {
182         require(sender != address(0), "ERC20: transfer from the zero address");
183         require(recipient != address(0), "ERC20: transfer to the zero address");
184 
185         _beforeTokenTransfer(sender, recipient, amount);
186 
187         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
188         _balances[recipient] = _balances[recipient].add(amount);
189         emit Transfer(sender, recipient, amount);
190     }
191 
192     function _mint(address account, uint256 amount) internal virtual {
193         require(account != address(0), "ERC20: mint to the zero address");
194 
195         _beforeTokenTransfer(address(0), account, amount);
196 
197         _totalSupply = _totalSupply.add(amount);
198         _balances[account] = _balances[account].add(amount);
199         emit Transfer(address(0), account, amount);
200     }
201 
202     function _burn(address account, uint256 amount) internal virtual {
203         require(account != address(0), "ERC20: burn from the zero address");
204 
205         _beforeTokenTransfer(account, address(0), amount);
206 
207         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
208         _totalSupply = _totalSupply.sub(amount);
209         emit Transfer(account, address(0), amount);
210     }
211 
212     function _approve(
213         address owner,
214         address spender,
215         uint256 amount
216     ) internal virtual {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219 
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
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
238 
239     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
240         return sub(a, b, "SafeMath: subtraction overflow");
241     }
242 
243     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b <= a, errorMessage);
245         uint256 c = a - b;
246 
247         return c;
248     }
249 
250     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
251         if (a == 0) {
252             return 0;
253         }
254 
255         uint256 c = a * b;
256         require(c / a == b, "SafeMath: multiplication overflow");
257 
258         return c;
259     }
260 
261     function div(uint256 a, uint256 b) internal pure returns (uint256) {
262         return div(a, b, "SafeMath: division by zero");
263     }
264 
265     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b > 0, errorMessage);
267         uint256 c = a / b;
268         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
269 
270         return c;
271     }
272 
273     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
274         return mod(a, b, "SafeMath: modulo by zero");
275     }
276 
277     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b != 0, errorMessage);
279         return a % b;
280     }
281 }
282 
283 contract Ownable is Context {
284     address private _owner;
285 
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288     constructor () {
289         address msgSender = _msgSender();
290         _owner = msgSender;
291         emit OwnershipTransferred(address(0), msgSender);
292     }
293 
294     function owner() public view returns (address) {
295         return _owner;
296     }
297 
298     modifier onlyOwner() {
299         require(_owner == _msgSender(), "Ownable: caller is not the owner");
300         _;
301     }
302 
303     function renounceOwnership() public virtual onlyOwner {
304         emit OwnershipTransferred(_owner, address(0));
305         _owner = address(0);
306     }
307 
308     function transferOwnership(address newOwner) public virtual onlyOwner {
309         require(newOwner != address(0), "Ownable: new owner is the zero address");
310         emit OwnershipTransferred(_owner, newOwner);
311         _owner = newOwner;
312     }
313 }
314 
315 
316 
317 library SafeMathInt {
318     int256 private constant MIN_INT256 = int256(1) << 255;
319     int256 private constant MAX_INT256 = ~(int256(1) << 255);
320 
321     function mul(int256 a, int256 b) internal pure returns (int256) {
322         int256 c = a * b;
323 
324         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
325         require((b == 0) || (c / b == a));
326         return c;
327     }
328 
329     function div(int256 a, int256 b) internal pure returns (int256) {
330         require(b != -1 || a != MIN_INT256);
331 
332         return a / b;
333     }
334 
335     function sub(int256 a, int256 b) internal pure returns (int256) {
336         int256 c = a - b;
337         require((b >= 0 && c <= a) || (b < 0 && c > a));
338         return c;
339     }
340 
341     function add(int256 a, int256 b) internal pure returns (int256) {
342         int256 c = a + b;
343         require((b >= 0 && c >= a) || (b < 0 && c < a));
344         return c;
345     }
346 
347     function abs(int256 a) internal pure returns (int256) {
348         require(a != MIN_INT256);
349         return a < 0 ? -a : a;
350     }
351 
352     function toUint256Safe(int256 a) internal pure returns (uint256) {
353         require(a >= 0);
354         return uint256(a);
355     }
356 }
357 
358 library SafeMathUint {
359   function toInt256Safe(uint256 a) internal pure returns (int256) {
360     int256 b = int256(a);
361     require(b >= 0);
362     return b;
363   }
364 }
365 
366 interface IUniswapV2Router01 {
367     function factory() external pure returns (address);
368     function WETH() external pure returns (address);
369 
370     function addLiquidity(
371         address tokenA,
372         address tokenB,
373         uint amountADesired,
374         uint amountBDesired,
375         uint amountAMin,
376         uint amountBMin,
377         address to,
378         uint deadline
379     ) external returns (uint amountA, uint amountB, uint liquidity);
380     function addLiquidityETH(
381         address token,
382         uint amountTokenDesired,
383         uint amountTokenMin,
384         uint amountETHMin,
385         address to,
386         uint deadline
387     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
388     function removeLiquidity(
389         address tokenA,
390         address tokenB,
391         uint liquidity,
392         uint amountAMin,
393         uint amountBMin,
394         address to,
395         uint deadline
396     ) external returns (uint amountA, uint amountB);
397     function removeLiquidityETH(
398         address token,
399         uint liquidity,
400         uint amountTokenMin,
401         uint amountETHMin,
402         address to,
403         uint deadline
404     ) external returns (uint amountToken, uint amountETH);
405     function removeLiquidityWithPermit(
406         address tokenA,
407         address tokenB,
408         uint liquidity,
409         uint amountAMin,
410         uint amountBMin,
411         address to,
412         uint deadline,
413         bool approveMax, uint8 v, bytes32 r, bytes32 s
414     ) external returns (uint amountA, uint amountB);
415     function removeLiquidityETHWithPermit(
416         address token,
417         uint liquidity,
418         uint amountTokenMin,
419         uint amountETHMin,
420         address to,
421         uint deadline,
422         bool approveMax, uint8 v, bytes32 r, bytes32 s
423     ) external returns (uint amountToken, uint amountETH);
424     function swapExactTokensForTokens(
425         uint amountIn,
426         uint amountOutMin,
427         address[] calldata path,
428         address to,
429         uint deadline
430     ) external returns (uint[] memory amounts);
431     function swapTokensForExactTokens(
432         uint amountOut,
433         uint amountInMax,
434         address[] calldata path,
435         address to,
436         uint deadline
437     ) external returns (uint[] memory amounts);
438     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
439         external
440         payable
441         returns (uint[] memory amounts);
442     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
443         external
444         returns (uint[] memory amounts);
445     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
446         external
447         returns (uint[] memory amounts);
448     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
449         external
450         payable
451         returns (uint[] memory amounts);
452 
453     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
454     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
455     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
456     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
457     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
458 }
459 
460 interface IUniswapV2Router02 is IUniswapV2Router01 {
461     function removeLiquidityETHSupportingFeeOnTransferTokens(
462         address token,
463         uint liquidity,
464         uint amountTokenMin,
465         uint amountETHMin,
466         address to,
467         uint deadline
468     ) external returns (uint amountETH);
469     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
470         address token,
471         uint liquidity,
472         uint amountTokenMin,
473         uint amountETHMin,
474         address to,
475         uint deadline,
476         bool approveMax, uint8 v, bytes32 r, bytes32 s
477     ) external returns (uint amountETH);
478     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
479         uint amountIn,
480         uint amountOutMin,
481         address[] calldata path,
482         address to,
483         uint deadline
484     ) external;
485     function swapExactETHForTokensSupportingFeeOnTransferTokens(
486         uint amountOutMin,
487         address[] calldata path,
488         address to,
489         uint deadline
490     ) external payable;
491     function swapExactTokensForETHSupportingFeeOnTransferTokens(
492         uint amountIn,
493         uint amountOutMin,
494         address[] calldata path,
495         address to,
496         uint deadline
497     ) external;
498 }
499 
500 contract YE is ERC20, Ownable {
501     using SafeMath for uint256;
502 
503     IUniswapV2Router02 public immutable uniswapV2Router;
504     address public immutable uniswapV2Pair;
505 
506     mapping (address => bool) private _isSniper;
507     bool private _swapping;
508     uint256 private _launchTime;
509 
510     address public feeWallet;
511     
512     uint256 public maxTransactionAmount;
513     uint256 public swapTokensAtAmount;
514     uint256 public maxWallet;
515         
516     bool public limitsInEffect = true;
517     bool public tradingActive;
518     
519     // Anti-bot and anti-whale mappings and variables
520     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
521     bool public transferDelayEnabled = true;
522 
523     uint256 public buyTotalFees;
524     uint256 private _buyDevFee;
525     uint256 private _buyLiquidityFee;
526     
527     uint256 public sellTotalFees;
528     uint256 private _sellDevFee;
529     uint256 private _sellLiquidityFee;
530     
531     uint256 private _tokensForDev;
532     uint256 private _tokensForLiquidity;
533     
534     // exclude from fees and max transaction amount
535     mapping (address => bool) private _isExcludedFromFees;
536     mapping (address => bool) public _isExcludedMaxTransactionAmount;
537 
538     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
539     // could be subject to a maximum transfer amount
540     mapping (address => bool) public automatedMarketMakerPairs;
541 
542     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
543     event ExcludeFromFees(address indexed account, bool isExcluded);
544     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
545     event feeWalletUpdated(address indexed newWallet, address indexed oldWallet);
546     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
547     event AutoNukeLP();
548     event ManualNukeLP();
549 
550     constructor() ERC20("Welcome Back Kanye", "YE") {
551         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
552         
553         excludeFromMaxTransaction(address(_uniswapV2Router), true);
554         uniswapV2Router = _uniswapV2Router;
555         
556         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
557         excludeFromMaxTransaction(address(uniswapV2Pair), true);
558         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
559         
560         uint256 buyDevFee = 0;
561         uint256 buyLiquidityFee = 0;
562 
563         uint256 sellDevFee = 0;
564         uint256 sellLiquidityFee = 0;
565         
566         uint256 totalSupply = 1e9 * 1e9;
567         
568         maxTransactionAmount = totalSupply * 2 / 100; // 2%
569         maxWallet = totalSupply * 2 / 100; // 2%
570         swapTokensAtAmount = totalSupply * 30 / 10000;
571 
572         _buyDevFee = buyDevFee;
573         _buyLiquidityFee = buyLiquidityFee;
574         buyTotalFees = _buyDevFee + _buyLiquidityFee;
575         
576         _sellDevFee = sellDevFee;
577         _sellLiquidityFee = sellLiquidityFee;
578         sellTotalFees = _sellDevFee + _sellLiquidityFee;
579         
580         feeWallet = address(owner()); // set as fee wallet
581 
582         // exclude from paying fees or having max transaction amount
583         excludeFromFees(owner(), true);
584         excludeFromFees(address(this), true);
585         excludeFromFees(address(0xdead), true);
586         
587         excludeFromMaxTransaction(owner(), true);
588         excludeFromMaxTransaction(address(this), true);
589         excludeFromMaxTransaction(address(0xdead), true);
590         
591         /*
592             _mint is an internal function in ERC20.sol that is only called here,
593             and CANNOT be called ever again
594         */
595         _mint(msg.sender, totalSupply);
596     }
597 
598     // once enabled, can never be turned off
599     function enableTrading() external onlyOwner {
600         tradingActive = true;
601         _launchTime = block.timestamp;
602     }
603     
604     // remove limits after token is stable
605     function removeLimits() external onlyOwner returns (bool) {
606         limitsInEffect = false;
607         return true;
608     }
609     
610     // disable Transfer delay - cannot be reenabled
611     function disableTransferDelay() external onlyOwner returns (bool) {
612         transferDelayEnabled = false;
613         return true;
614     }
615     
616      // change the minimum amount of tokens to sell from fees
617     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
618   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
619   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
620   	    swapTokensAtAmount = newAmount;
621   	    return true;
622   	}
623     
624     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
625         require(newNum >= (totalSupply() * 1 / 1000) / 1e9, "Cannot set maxTransactionAmount lower than 0.1%");
626         maxTransactionAmount = newNum * 1e9;
627     }
628 
629     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
630         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxWallet lower than 0.5%");
631         maxWallet = newNum * 1e9;
632     }
633     
634     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
635         _isExcludedMaxTransactionAmount[updAds] = isEx;
636     }
637     
638     function updateBuyFees(uint256 devFee, uint256 liquidityFee) external onlyOwner {
639         _buyDevFee = devFee;
640         _buyLiquidityFee = liquidityFee;
641         buyTotalFees = _buyDevFee + _buyLiquidityFee;
642         require(buyTotalFees <= 7, "Must keep fees at 7% or less");
643     }
644     
645     function updateSellFees(uint256 devFee, uint256 liquidityFee) external onlyOwner {
646         _sellDevFee = devFee;
647         _sellLiquidityFee = liquidityFee;
648         sellTotalFees = _sellDevFee + _sellLiquidityFee;
649     }
650 
651     function excludeFromFees(address account, bool excluded) public onlyOwner {
652         _isExcludedFromFees[account] = excluded;
653         emit ExcludeFromFees(account, excluded);
654     }
655 
656     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
657         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
658 
659         _setAutomatedMarketMakerPair(pair, value);
660     }
661 
662     function _setAutomatedMarketMakerPair(address pair, bool value) private {
663         automatedMarketMakerPairs[pair] = value;
664 
665         emit SetAutomatedMarketMakerPair(pair, value);
666     }
667     
668     function updateFeeWallet(address newWallet) external onlyOwner {
669         emit feeWalletUpdated(newWallet, feeWallet);
670         feeWallet = newWallet;
671     }
672 
673     function isExcludedFromFees(address account) public view returns(bool) {
674         return _isExcludedFromFees[account];
675     }
676     
677     function setSnipers(address[] memory snipers_) public onlyOwner() {
678         for (uint i = 0; i < snipers_.length; i++) {
679             if (snipers_[i] != uniswapV2Pair && snipers_[i] != address(uniswapV2Router)) {
680                 _isSniper[snipers_[i]] = true;
681             }
682         }
683     }
684     
685     function delSnipers(address[] memory snipers_) public onlyOwner() {
686         for (uint i = 0; i < snipers_.length; i++) {
687             _isSniper[snipers_[i]] = false;
688         }
689     }
690     
691     function isSniper(address addr) public view returns (bool) {
692         return _isSniper[addr];
693     }
694 
695     function _transfer(
696         address from,
697         address to,
698         uint256 amount
699     ) internal override {
700         require(from != address(0), "ERC20: transfer from the zero address");
701         require(to != address(0), "ERC20: transfer to the zero address");
702         require(!_isSniper[from], "Your address has been marked as a sniper, you are unable to transfer or swap.");
703         
704          if (amount == 0) {
705             super._transfer(from, to, 0);
706             return;
707         }
708         
709         if (block.timestamp == _launchTime) _isSniper[to] = true;
710         
711         if (limitsInEffect) {
712             if (
713                 from != owner() &&
714                 to != owner() &&
715                 to != address(0) &&
716                 to != address(0xdead) &&
717                 !_swapping
718             ) {
719                 if (!tradingActive) {
720                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
721                 }
722 
723                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
724                 if (transferDelayEnabled){
725                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
726                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
727                         _holderLastTransferTimestamp[tx.origin] = block.number;
728                     }
729                 }
730                  
731                 // when buy
732                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
733                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
734                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
735                 }
736                 
737                 // when sell
738                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
739                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
740                 }
741                 else if (!_isExcludedMaxTransactionAmount[to]){
742                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
743                 }
744             }
745         }
746         
747 		uint256 contractTokenBalance = balanceOf(address(this));
748         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
749         if (
750             canSwap &&
751             !_swapping &&
752             !automatedMarketMakerPairs[from] &&
753             !_isExcludedFromFees[from] &&
754             !_isExcludedFromFees[to]
755         ) {
756             _swapping = true;
757             swapBack();
758             _swapping = false;
759         }
760 
761         bool takeFee = !_swapping;
762 
763         // if any account belongs to _isExcludedFromFee account then remove the fee
764         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
765             takeFee = false;
766         }
767         
768         uint256 fees = 0;
769         // only take fees on buys/sells, do not take on wallet transfers
770         if (takeFee) {
771             // on sell
772             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
773                 fees = amount.mul(sellTotalFees).div(100);
774                 _tokensForLiquidity += fees * _sellLiquidityFee / sellTotalFees;
775                 _tokensForDev += fees * _sellDevFee / sellTotalFees;
776             }
777             // on buy
778             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
779         	    fees = amount.mul(buyTotalFees).div(100);
780         	    _tokensForLiquidity += fees * _buyLiquidityFee / buyTotalFees;
781                 _tokensForDev += fees * _buyDevFee / buyTotalFees;
782             }
783             
784             if (fees > 0) {
785                 super._transfer(from, address(this), fees);
786             }
787         	
788         	amount -= fees;
789         }
790 
791         super._transfer(from, to, amount);
792     }
793 
794     function _swapTokensForEth(uint256 tokenAmount) private {
795         // generate the uniswap pair path of token -> weth
796         address[] memory path = new address[](2);
797         path[0] = address(this);
798         path[1] = uniswapV2Router.WETH();
799 
800         _approve(address(this), address(uniswapV2Router), tokenAmount);
801 
802         // make the swap
803         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
804             tokenAmount,
805             0, // accept any amount of ETH
806             path,
807             address(this),
808             block.timestamp
809         );
810     }
811     
812     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
813         // approve token transfer to cover all possible scenarios
814         _approve(address(this), address(uniswapV2Router), tokenAmount);
815 
816         // add the liquidity
817         uniswapV2Router.addLiquidityETH{value: ethAmount}(
818             address(this),
819             tokenAmount,
820             0, // slippage is unavoidable
821             0, // slippage is unavoidable
822             owner(),
823             block.timestamp
824         );
825     }
826 
827     function swapBack() private {
828         uint256 contractBalance = balanceOf(address(this));
829         uint256 totalTokensToSwap = _tokensForLiquidity + _tokensForDev;
830         
831         if (contractBalance == 0 || totalTokensToSwap == 0) return;
832         if (contractBalance > swapTokensAtAmount * 20) {
833           contractBalance = swapTokensAtAmount * 20;
834         }
835         
836         // Halve the amount of liquidity tokens
837         uint256 liquidityTokens = contractBalance * _tokensForLiquidity / totalTokensToSwap / 2;
838         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
839         
840         uint256 initialETHBalance = address(this).balance;
841 
842         _swapTokensForEth(amountToSwapForETH); 
843         
844         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
845         uint256 ethForDev = ethBalance.mul(_tokensForDev).div(totalTokensToSwap);
846         uint256 ethForLiquidity = ethBalance - ethForDev;
847         
848         _tokensForLiquidity = 0;
849         _tokensForDev = 0;
850                 
851         if (liquidityTokens > 0 && ethForLiquidity > 0) {
852             _addLiquidity(liquidityTokens, ethForLiquidity);
853             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, _tokensForLiquidity);
854         }
855     }
856 
857     function withdrawFees() external {
858         payable(feeWallet).transfer(address(this).balance);
859     }
860 
861     receive() external payable {}
862 }