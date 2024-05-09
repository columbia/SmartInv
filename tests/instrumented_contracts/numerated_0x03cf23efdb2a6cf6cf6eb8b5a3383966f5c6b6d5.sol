1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-17
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-17
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.11;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
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
92     function totalSupply() external view returns (uint256);
93     function balanceOf(address account) external view returns (uint256);
94     function transfer(address recipient, uint256 amount) external returns (bool);
95     function allowance(address owner, address spender) external view returns (uint256);
96     function approve(address spender, uint256 amount) external returns (bool);
97     function transferFrom(
98         address sender,
99         address recipient,
100         uint256 amount
101     ) external returns (bool);
102     
103     event Transfer(address indexed from, address indexed to, uint256 value);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 interface IERC20Metadata is IERC20 {
108     function name() external view returns (string memory);
109     function symbol() external view returns (string memory);
110     function decimals() external view returns (uint8);
111 }
112 
113 
114 contract ERC20 is Context, IERC20, IERC20Metadata {
115     using SafeMath for uint256;
116 
117     mapping(address => uint256) private _balances;
118 
119     mapping(address => mapping(address => uint256)) private _allowances;
120 
121     uint256 private _totalSupply;
122 
123     string private _name;
124     string private _symbol;
125 
126     constructor(string memory name_, string memory symbol_) {
127         _name = name_;
128         _symbol = symbol_;
129     }
130 
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135     function symbol() public view virtual override returns (string memory) {
136         return _symbol;
137     }
138 
139     function decimals() public view virtual override returns (uint8) {
140         return 9;
141     }
142 
143     function totalSupply() public view virtual override returns (uint256) {
144         return _totalSupply;
145     }
146 
147     function balanceOf(address account) public view virtual override returns (uint256) {
148         return _balances[account];
149     }
150 
151     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
152         _transfer(_msgSender(), recipient, amount);
153         return true;
154     }
155 
156     function allowance(address owner, address spender) public view virtual override returns (uint256) {
157         return _allowances[owner][spender];
158     }
159 
160     function approve(address spender, uint256 amount) public virtual override returns (bool) {
161         _approve(_msgSender(), spender, amount);
162         return true;
163     }
164 
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) public virtual override returns (bool) {
170         _transfer(sender, recipient, amount);
171         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
172         return true;
173     }
174 
175     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
176         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
177         return true;
178     }
179 
180     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
181         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
182         return true;
183     }
184 
185     function _transfer(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) internal virtual {
190         require(sender != address(0), "ERC20: transfer from the zero address");
191         require(recipient != address(0), "ERC20: transfer to the zero address");
192 
193         _beforeTokenTransfer(sender, recipient, amount);
194 
195         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
196         _balances[recipient] = _balances[recipient].add(amount);
197         emit Transfer(sender, recipient, amount);
198     }
199 
200     function _mint(address account, uint256 amount) internal virtual {
201         require(account != address(0), "ERC20: mint to the zero address");
202 
203         _beforeTokenTransfer(address(0), account, amount);
204 
205         _totalSupply = _totalSupply.add(amount);
206         _balances[account] = _balances[account].add(amount);
207         emit Transfer(address(0), account, amount);
208     }
209 
210     function _burn(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: burn from the zero address");
212 
213         _beforeTokenTransfer(account, address(0), amount);
214 
215         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
216         _totalSupply = _totalSupply.sub(amount);
217         emit Transfer(account, address(0), amount);
218     }
219 
220     function _approve(
221         address owner,
222         address spender,
223         uint256 amount
224     ) internal virtual {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227 
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232     function _beforeTokenTransfer(
233         address from,
234         address to,
235         uint256 amount
236     ) internal virtual {}
237 }
238 
239 library SafeMath {
240     function add(uint256 a, uint256 b) internal pure returns (uint256) {
241         uint256 c = a + b;
242         require(c >= a, "SafeMath: addition overflow");
243 
244         return c;
245     }
246 
247     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248         return sub(a, b, "SafeMath: subtraction overflow");
249     }
250 
251     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b <= a, errorMessage);
253         uint256 c = a - b;
254 
255         return c;
256     }
257 
258     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
259         if (a == 0) {
260             return 0;
261         }
262 
263         uint256 c = a * b;
264         require(c / a == b, "SafeMath: multiplication overflow");
265 
266         return c;
267     }
268 
269     function div(uint256 a, uint256 b) internal pure returns (uint256) {
270         return div(a, b, "SafeMath: division by zero");
271     }
272 
273     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b > 0, errorMessage);
275         uint256 c = a / b;
276         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
277 
278         return c;
279     }
280 
281     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
282         return mod(a, b, "SafeMath: modulo by zero");
283     }
284 
285     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b != 0, errorMessage);
287         return a % b;
288     }
289 }
290 
291 contract Ownable is Context {
292     address private _owner;
293 
294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296     constructor () {
297         address msgSender = _msgSender();
298         _owner = msgSender;
299         emit OwnershipTransferred(address(0), msgSender);
300     }
301 
302     function owner() public view returns (address) {
303         return _owner;
304     }
305 
306     modifier onlyOwner() {
307         require(_owner == _msgSender(), "Ownable: caller is not the owner");
308         _;
309     }
310 
311     function renounceOwnership() public virtual onlyOwner {
312         emit OwnershipTransferred(_owner, address(0));
313         _owner = address(0);
314     }
315 
316     function transferOwnership(address newOwner) public virtual onlyOwner {
317         require(newOwner != address(0), "Ownable: new owner is the zero address");
318         emit OwnershipTransferred(_owner, newOwner);
319         _owner = newOwner;
320     }
321 }
322 
323 
324 
325 library SafeMathInt {
326     int256 private constant MIN_INT256 = int256(1) << 255;
327     int256 private constant MAX_INT256 = ~(int256(1) << 255);
328 
329     function mul(int256 a, int256 b) internal pure returns (int256) {
330         int256 c = a * b;
331 
332         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
333         require((b == 0) || (c / b == a));
334         return c;
335     }
336 
337     function div(int256 a, int256 b) internal pure returns (int256) {
338         require(b != -1 || a != MIN_INT256);
339 
340         return a / b;
341     }
342 
343     function sub(int256 a, int256 b) internal pure returns (int256) {
344         int256 c = a - b;
345         require((b >= 0 && c <= a) || (b < 0 && c > a));
346         return c;
347     }
348 
349     function add(int256 a, int256 b) internal pure returns (int256) {
350         int256 c = a + b;
351         require((b >= 0 && c >= a) || (b < 0 && c < a));
352         return c;
353     }
354 
355     function abs(int256 a) internal pure returns (int256) {
356         require(a != MIN_INT256);
357         return a < 0 ? -a : a;
358     }
359 
360     function toUint256Safe(int256 a) internal pure returns (uint256) {
361         require(a >= 0);
362         return uint256(a);
363     }
364 }
365 
366 library SafeMathUint {
367   function toInt256Safe(uint256 a) internal pure returns (int256) {
368     int256 b = int256(a);
369     require(b >= 0);
370     return b;
371   }
372 }
373 
374 interface IUniswapV2Router01 {
375     function factory() external pure returns (address);
376     function WETH() external pure returns (address);
377 
378     function addLiquidity(
379         address tokenA,
380         address tokenB,
381         uint amountADesired,
382         uint amountBDesired,
383         uint amountAMin,
384         uint amountBMin,
385         address to,
386         uint deadline
387     ) external returns (uint amountA, uint amountB, uint liquidity);
388     function addLiquidityETH(
389         address token,
390         uint amountTokenDesired,
391         uint amountTokenMin,
392         uint amountETHMin,
393         address to,
394         uint deadline
395     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
396     function removeLiquidity(
397         address tokenA,
398         address tokenB,
399         uint liquidity,
400         uint amountAMin,
401         uint amountBMin,
402         address to,
403         uint deadline
404     ) external returns (uint amountA, uint amountB);
405     function removeLiquidityETH(
406         address token,
407         uint liquidity,
408         uint amountTokenMin,
409         uint amountETHMin,
410         address to,
411         uint deadline
412     ) external returns (uint amountToken, uint amountETH);
413     function removeLiquidityWithPermit(
414         address tokenA,
415         address tokenB,
416         uint liquidity,
417         uint amountAMin,
418         uint amountBMin,
419         address to,
420         uint deadline,
421         bool approveMax, uint8 v, bytes32 r, bytes32 s
422     ) external returns (uint amountA, uint amountB);
423     function removeLiquidityETHWithPermit(
424         address token,
425         uint liquidity,
426         uint amountTokenMin,
427         uint amountETHMin,
428         address to,
429         uint deadline,
430         bool approveMax, uint8 v, bytes32 r, bytes32 s
431     ) external returns (uint amountToken, uint amountETH);
432     function swapExactTokensForTokens(
433         uint amountIn,
434         uint amountOutMin,
435         address[] calldata path,
436         address to,
437         uint deadline
438     ) external returns (uint[] memory amounts);
439     function swapTokensForExactTokens(
440         uint amountOut,
441         uint amountInMax,
442         address[] calldata path,
443         address to,
444         uint deadline
445     ) external returns (uint[] memory amounts);
446     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
447         external
448         payable
449         returns (uint[] memory amounts);
450     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
451         external
452         returns (uint[] memory amounts);
453     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
454         external
455         returns (uint[] memory amounts);
456     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
457         external
458         payable
459         returns (uint[] memory amounts);
460 
461     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
462     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
463     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
464     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
465     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
466 }
467 
468 interface IUniswapV2Router02 is IUniswapV2Router01 {
469     function removeLiquidityETHSupportingFeeOnTransferTokens(
470         address token,
471         uint liquidity,
472         uint amountTokenMin,
473         uint amountETHMin,
474         address to,
475         uint deadline
476     ) external returns (uint amountETH);
477     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
478         address token,
479         uint liquidity,
480         uint amountTokenMin,
481         uint amountETHMin,
482         address to,
483         uint deadline,
484         bool approveMax, uint8 v, bytes32 r, bytes32 s
485     ) external returns (uint amountETH);
486     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
487         uint amountIn,
488         uint amountOutMin,
489         address[] calldata path,
490         address to,
491         uint deadline
492     ) external;
493     function swapExactETHForTokensSupportingFeeOnTransferTokens(
494         uint amountOutMin,
495         address[] calldata path,
496         address to,
497         uint deadline
498     ) external payable;
499     function swapExactTokensForETHSupportingFeeOnTransferTokens(
500         uint amountIn,
501         uint amountOutMin,
502         address[] calldata path,
503         address to,
504         uint deadline
505     ) external;
506 }
507 
508 contract FOREST is ERC20, Ownable {
509     using SafeMath for uint256;
510 
511     IUniswapV2Router02 public immutable uniswapV2Router;
512     address public immutable uniswapV2Pair;
513 
514     mapping (address => bool) private _isSniper;
515     bool private _swapping;
516     uint256 private _launchTime;
517 
518     address public feeWallet;
519     
520     uint256 public maxTransactionAmount;
521     uint256 public swapTokensAtAmount;
522     uint256 public maxWallet;
523         
524     bool public limitsInEffect = true;
525     bool public tradingActive = false;
526     
527     // Anti-bot and anti-whale mappings and variables
528     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
529     bool public transferDelayEnabled = true;
530 
531     uint256 public buyTotalFees;
532     uint256 private _buyMarketingFee;
533     uint256 private _buyLiquidityFee;
534     uint256 private _buyDevFee;
535     
536     uint256 public sellTotalFees;
537     uint256 private _sellMarketingFee;
538     uint256 private _sellLiquidityFee;
539     uint256 private _sellDevFee;
540     
541     uint256 private _tokensForMarketing;
542     uint256 private _tokensForLiquidity;
543     uint256 private _tokensForDev;
544     
545     /******************/
546 
547     // exlcude from fees and max transaction amount
548     mapping (address => bool) private _isExcludedFromFees;
549     mapping (address => bool) public _isExcludedMaxTransactionAmount;
550 
551     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
552     // could be subject to a maximum transfer amount
553     mapping (address => bool) public automatedMarketMakerPairs;
554 
555     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
556     event ExcludeFromFees(address indexed account, bool isExcluded);
557     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
558     event feeWalletUpdated(address indexed newWallet, address indexed oldWallet);
559     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
560     event AutoNukeLP();
561     event ManualNukeLP();
562 
563     constructor() ERC20("YAKUSHIMA", "FOREST") {
564         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
565         
566         excludeFromMaxTransaction(address(_uniswapV2Router), true);
567         uniswapV2Router = _uniswapV2Router;
568         
569         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
570         excludeFromMaxTransaction(address(uniswapV2Pair), true);
571         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
572         
573         uint256 buyMarketingFee = 1;
574         uint256 buyLiquidityFee = 1;
575         uint256 buyDevFee = 1;
576 
577         uint256 sellMarketingFee = 1;
578         uint256 sellLiquidityFee = 1;
579         uint256 sellDevFee = 1;
580         
581         uint256 totalSupply = 1e18 * 1e9;
582         
583         maxTransactionAmount = totalSupply * 4 / 100; // 4% maxTransactionAmountTxn
584         maxWallet = totalSupply * 5 / 100; // 5% maxWallet
585         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
586 
587         _buyMarketingFee = buyMarketingFee;
588         _buyLiquidityFee = buyLiquidityFee;
589         _buyDevFee = buyDevFee;
590         buyTotalFees = _buyMarketingFee + _buyLiquidityFee + _buyDevFee;
591         
592         _sellMarketingFee = sellMarketingFee;
593         _sellLiquidityFee = sellLiquidityFee;
594         _sellDevFee = sellDevFee;
595         sellTotalFees = _sellMarketingFee + _sellLiquidityFee + _sellDevFee;
596         
597         feeWallet = address(owner()); // set as fee wallet
598 
599         // exclude from paying fees or having max transaction amount
600         excludeFromFees(owner(), true);
601         excludeFromFees(address(this), true);
602         excludeFromFees(address(0xdead), true);
603         
604         excludeFromMaxTransaction(owner(), true);
605         excludeFromMaxTransaction(address(this), true);
606         excludeFromMaxTransaction(address(0xdead), true);
607         
608         /*
609             _mint is an internal function in ERC20.sol that is only called here,
610             and CANNOT be called ever again
611         */
612         _mint(msg.sender, totalSupply);
613     }
614 
615     // once enabled, can never be turned off
616     function enableTrading() external onlyOwner {
617         tradingActive = true;
618         _launchTime = block.timestamp;
619     }
620     
621     // remove limits after token is stable
622     function removeLimits() external onlyOwner returns (bool) {
623         limitsInEffect = false;
624         return true;
625     }
626     
627     // disable Transfer delay - cannot be reenabled
628     function disableTransferDelay() external onlyOwner returns (bool) {
629         transferDelayEnabled = false;
630         return true;
631     }
632     
633      // change the minimum amount of tokens to sell from fees
634     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
635   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
636   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
637   	    swapTokensAtAmount = newAmount;
638   	    return true;
639   	}
640     
641     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
642         require(newNum >= (totalSupply() * 1 / 1000) / 1e9, "Cannot set maxTransactionAmount lower than 0.1%");
643         maxTransactionAmount = newNum * 1e9;
644     }
645 
646     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
647         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxWallet lower than 0.5%");
648         maxWallet = newNum * 1e9;
649     }
650     
651     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
652         _isExcludedMaxTransactionAmount[updAds] = isEx;
653     }
654     
655     function updateBuyFees(uint256 marketingFee, uint256 liquidityFee, uint256 devFee) external onlyOwner {
656         _buyMarketingFee = marketingFee;
657         _buyLiquidityFee = liquidityFee;
658         _buyDevFee = devFee;
659         buyTotalFees = _buyMarketingFee + _buyLiquidityFee + _buyDevFee;
660         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
661     }
662     
663     function updateSellFees(uint256 marketingFee, uint256 liquidityFee, uint256 devFee) external onlyOwner {
664         _sellMarketingFee = marketingFee;
665         _sellLiquidityFee = liquidityFee;
666         _sellDevFee = devFee;
667         sellTotalFees = _sellMarketingFee + _sellLiquidityFee + _sellDevFee;
668         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
669     }
670 
671     function excludeFromFees(address account, bool excluded) public onlyOwner {
672         _isExcludedFromFees[account] = excluded;
673         emit ExcludeFromFees(account, excluded);
674     }
675 
676     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
677         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
678 
679         _setAutomatedMarketMakerPair(pair, value);
680     }
681 
682     function _setAutomatedMarketMakerPair(address pair, bool value) private {
683         automatedMarketMakerPairs[pair] = value;
684 
685         emit SetAutomatedMarketMakerPair(pair, value);
686     }
687     
688     function updateFeeWallet(address newWallet) external onlyOwner {
689         emit feeWalletUpdated(newWallet, feeWallet);
690         feeWallet = newWallet;
691     }
692 
693     function isExcludedFromFees(address account) public view returns(bool) {
694         return _isExcludedFromFees[account];
695     }
696     
697     function setSnipers(address[] memory snipers_) public onlyOwner() {
698         for (uint i = 0; i < snipers_.length; i++) {
699             if (snipers_[i] != uniswapV2Pair && snipers_[i] != address(uniswapV2Router)) {
700                 _isSniper[snipers_[i]] = true;
701             }
702         }
703     }
704     
705     function delSnipers(address[] memory snipers_) public onlyOwner() {
706         for (uint i = 0; i < snipers_.length; i++) {
707             _isSniper[snipers_[i]] = false;
708         }
709     }
710     
711     function isSniper(address addr) public view returns (bool) {
712         return _isSniper[addr];
713     }
714 
715     function _transfer(
716         address from,
717         address to,
718         uint256 amount
719     ) internal override {
720         require(from != address(0), "ERC20: transfer from the zero address");
721         require(to != address(0), "ERC20: transfer to the zero address");
722         require(!_isSniper[from], "Your address has been marked as a sniper, you are unable to transfer or swap.");
723         
724          if (amount == 0) {
725             super._transfer(from, to, 0);
726             return;
727         }
728         
729         if (block.timestamp == _launchTime) _isSniper[to] = true;
730         
731         if (limitsInEffect) {
732             if (
733                 from != owner() &&
734                 to != owner() &&
735                 to != address(0) &&
736                 to != address(0xdead) &&
737                 !_swapping
738             ) {
739                 if (!tradingActive) {
740                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
741                 }
742 
743                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
744                 if (transferDelayEnabled){
745                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
746                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
747                         _holderLastTransferTimestamp[tx.origin] = block.number;
748                     }
749                 }
750                  
751                 // when buy
752                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
753                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
754                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
755                 }
756                 
757                 // when sell
758                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
759                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
760                 }
761                 else if (!_isExcludedMaxTransactionAmount[to]){
762                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
763                 }
764             }
765         }
766         
767 		uint256 contractTokenBalance = balanceOf(address(this));
768         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
769         if (
770             canSwap &&
771             !_swapping &&
772             !automatedMarketMakerPairs[from] &&
773             !_isExcludedFromFees[from] &&
774             !_isExcludedFromFees[to]
775         ) {
776             _swapping = true;
777             swapBack();
778             _swapping = false;
779         }
780 
781         bool takeFee = !_swapping;
782 
783         // if any account belongs to _isExcludedFromFee account then remove the fee
784         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
785             takeFee = false;
786         }
787         
788         uint256 fees = 0;
789         // only take fees on buys/sells, do not take on wallet transfers
790         if (takeFee) {
791             // on sell
792             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
793                 fees = amount.mul(sellTotalFees).div(100);
794                 _tokensForLiquidity += fees * _sellLiquidityFee / sellTotalFees;
795                 _tokensForDev += fees * _sellDevFee / sellTotalFees;
796                 _tokensForMarketing += fees * _sellMarketingFee / sellTotalFees;
797             }
798             // on buy
799             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
800         	    fees = amount.mul(buyTotalFees).div(100);
801         	    _tokensForLiquidity += fees * _buyLiquidityFee / buyTotalFees;
802                 _tokensForDev += fees * _buyDevFee / buyTotalFees;
803                 _tokensForMarketing += fees * _buyMarketingFee / buyTotalFees;
804             }
805             
806             if (fees > 0) {
807                 super._transfer(from, address(this), fees);
808             }
809         	
810         	amount -= fees;
811         }
812 
813         super._transfer(from, to, amount);
814     }
815 
816     function _swapTokensForEth(uint256 tokenAmount) private {
817         // generate the uniswap pair path of token -> weth
818         address[] memory path = new address[](2);
819         path[0] = address(this);
820         path[1] = uniswapV2Router.WETH();
821 
822         _approve(address(this), address(uniswapV2Router), tokenAmount);
823 
824         // make the swap
825         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
826             tokenAmount,
827             0, // accept any amount of ETH
828             path,
829             address(this),
830             block.timestamp
831         );
832     }
833     
834     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
835         // approve token transfer to cover all possible scenarios
836         _approve(address(this), address(uniswapV2Router), tokenAmount);
837 
838         // add the liquidity
839         uniswapV2Router.addLiquidityETH{value: ethAmount}(
840             address(this),
841             tokenAmount,
842             0, // slippage is unavoidable
843             0, // slippage is unavoidable
844             owner(),
845             block.timestamp
846         );
847     }
848 
849     function swapBack() private {
850         uint256 contractBalance = balanceOf(address(this));
851         uint256 totalTokensToSwap = _tokensForLiquidity + _tokensForMarketing + _tokensForDev;
852         
853         if (contractBalance == 0 || totalTokensToSwap == 0) return;
854         if (contractBalance > swapTokensAtAmount * 20) {
855           contractBalance = swapTokensAtAmount * 20;
856         }
857         
858         // Halve the amount of liquidity tokens
859         uint256 liquidityTokens = contractBalance * _tokensForLiquidity / totalTokensToSwap / 2;
860         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
861         
862         uint256 initialETHBalance = address(this).balance;
863 
864         _swapTokensForEth(amountToSwapForETH); 
865         
866         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
867         uint256 ethForMarketing = ethBalance.mul(_tokensForMarketing).div(totalTokensToSwap);
868         uint256 ethForDev = ethBalance.mul(_tokensForDev).div(totalTokensToSwap);
869         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
870         
871         _tokensForLiquidity = 0;
872         _tokensForMarketing = 0;
873         _tokensForDev = 0;
874                 
875         if (liquidityTokens > 0 && ethForLiquidity > 0) {
876             _addLiquidity(liquidityTokens, ethForLiquidity);
877             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, _tokensForLiquidity);
878         }
879     }
880 
881     function withdrawFees() external {
882         payable(feeWallet).transfer(address(this).balance);
883     }
884 
885     receive() external payable {}
886 }