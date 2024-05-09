1 /**
2 To achieve Victory one must have Foresight
3 */
4  
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.9;
8  
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13  
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19  
20 interface IUniswapV2Pair {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23  
24     function name() external pure returns (string memory);
25     function symbol() external pure returns (string memory);
26     function decimals() external pure returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30  
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34  
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38  
39     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
40  
41     event Mint(address indexed sender, uint amount0, uint amount1);
42     event Swap(
43         address indexed sender,
44         uint amount0In,
45         uint amount1In,
46         uint amount0Out,
47         uint amount1Out,
48         address indexed to
49     );
50     event Sync(uint112 reserve0, uint112 reserve1);
51  
52     function MINIMUM_LIQUIDITY() external pure returns (uint);
53     function factory() external view returns (address);
54     function token0() external view returns (address);
55     function token1() external view returns (address);
56     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
57     function price0CumulativeLast() external view returns (uint);
58     function price1CumulativeLast() external view returns (uint);
59     function kLast() external view returns (uint);
60  
61     function mint(address to) external returns (uint liquidity);
62     function burn(address to) external returns (uint amount0, uint amount1);
63     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
64     function skim(address to) external;
65     function sync() external;
66  
67     function initialize(address, address) external;
68 }
69  
70 interface IUniswapV2Factory {
71     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
72  
73     function feeTo() external view returns (address);
74     function feeToSetter() external view returns (address);
75  
76     function getPair(address tokenA, address tokenB) external view returns (address pair);
77     function allPairs(uint) external view returns (address pair);
78     function allPairsLength() external view returns (uint);
79  
80     function createPair(address tokenA, address tokenB) external returns (address pair);
81  
82     function setFeeTo(address) external;
83     function setFeeToSetter(address) external;
84 }
85  
86 interface IERC20 {
87     
88     function totalSupply() external view returns (uint256);
89  
90     function balanceOf(address account) external view returns (uint256);
91  
92     function transfer(address recipient, uint256 amount) external returns (bool);
93  
94     function allowance(address owner, address spender) external view returns (uint256);
95  
96     function approve(address spender, uint256 amount) external returns (bool);
97  
98     function transferFrom(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) external returns (bool);
103  
104     event Transfer(address indexed from, address indexed to, uint256 value);
105  
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108  
109 interface IERC20Metadata is IERC20 {
110     
111     function name() external view returns (string memory);
112  
113     function symbol() external view returns (string memory);
114  
115     function decimals() external view returns (uint8);
116 }
117  
118  
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     using SafeMath for uint256;
121  
122     mapping(address => uint256) private _balances;
123  
124     mapping(address => mapping(address => uint256)) private _allowances;
125  
126     uint256 private _totalSupply;
127  
128     string private _name;
129     string private _symbol;
130  
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135  
136     function name() public view virtual override returns (string memory) {
137         return _name;
138     }
139  
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143  
144     function decimals() public view virtual override returns (uint8) {
145         return 18;
146     }
147  
148     function totalSupply() public view virtual override returns (uint256) {
149         return _totalSupply;
150     }
151  
152     function balanceOf(address account) public view virtual override returns (uint256) {
153         return _balances[account];
154     }
155  
156     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
157         _transfer(_msgSender(), recipient, amount);
158         return true;
159     }
160  
161     function allowance(address owner, address spender) public view virtual override returns (uint256) {
162         return _allowances[owner][spender];
163     }
164  
165     function approve(address spender, uint256 amount) public virtual override returns (bool) {
166         _approve(_msgSender(), spender, amount);
167         return true;
168     }
169  
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) public virtual override returns (bool) {
175         _transfer(sender, recipient, amount);
176         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
177         return true;
178     }
179  
180     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
181         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
182         return true;
183     }
184  
185     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
186         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
187         return true;
188     }
189  
190     function _transfer(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) internal virtual {
195         require(sender != address(0), "ERC20: transfer from the zero address");
196         require(recipient != address(0), "ERC20: transfer to the zero address");
197  
198         _beforeTokenTransfer(sender, recipient, amount);
199  
200         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
201         _balances[recipient] = _balances[recipient].add(amount);
202         emit Transfer(sender, recipient, amount);
203     }
204  
205     function _mint(address account, uint256 amount) internal virtual {
206         require(account != address(0), "ERC20: mint to the zero address");
207  
208         _beforeTokenTransfer(address(0), account, amount);
209  
210         _totalSupply = _totalSupply.add(amount);
211         _balances[account] = _balances[account].add(amount);
212         emit Transfer(address(0), account, amount);
213     }
214  
215     function _burn(address account, uint256 amount) internal virtual {
216         require(account != address(0), "ERC20: burn from the zero address");
217  
218         _beforeTokenTransfer(account, address(0), amount);
219  
220         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
221         _totalSupply = _totalSupply.sub(amount);
222         emit Transfer(account, address(0), amount);
223     }
224  
225     function _approve(
226         address owner,
227         address spender,
228         uint256 amount
229     ) internal virtual {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232  
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236  
237     function _beforeTokenTransfer(
238         address from,
239         address to,
240         uint256 amount
241     ) internal virtual {}
242 }
243  
244 library SafeMath {
245 
246     function add(uint256 a, uint256 b) internal pure returns (uint256) {
247         uint256 c = a + b;
248         require(c >= a, "SafeMath: addition overflow");
249  
250         return c;
251     }
252  
253     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
254         return sub(a, b, "SafeMath: subtraction overflow");
255     }
256  
257     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b <= a, errorMessage);
259         uint256 c = a - b;
260  
261         return c;
262     }
263  
264     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
265    
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
520 contract SENKEN is ERC20, Ownable {
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
531     uint256 private maxTransactionAmount;
532     uint256 private swapTokensAtAmount;
533     uint256 private maxWallet;
534  
535     bool private limitsInEffect = true;
536     bool private tradingActive = false;
537     bool public swapEnabled = false;
538     bool public enableEarlySellTax = false;
539  
540      // Anti-bot and anti-whale mappings and variables
541     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
542  
543     // Seller Map
544     mapping (address => uint256) private _holderFirstBuyTimestamp;
545  
546     // Blacklist Map
547     mapping (address => bool) private _blacklist;
548     bool public transferDelayEnabled = true;
549  
550     uint256 private buyTotalFees;
551     uint256 private buyMarketingFee;
552     uint256 private buyLiquidityFee;
553     uint256 private buyDevFee;
554  
555     uint256 private sellTotalFees;
556     uint256 private sellMarketingFee;
557     uint256 private sellLiquidityFee;
558     uint256 private sellDevFee;
559  
560     uint256 private earlySellLiquidityFee;
561     uint256 private earlySellMarketingFee;
562     uint256 private earlySellDevFee;
563  
564     uint256 private tokensForMarketing;
565     uint256 private tokensForLiquidity;
566     uint256 private tokensForDev;
567  
568     // block number of opened trading
569     uint256 launchedAt;
570  
571     // exclude from fees and max transaction amount
572     mapping (address => bool) private _isExcludedFromFees;
573     mapping (address => bool) public _isExcludedMaxTransactionAmount;
574  
575     mapping (address => bool) public automatedMarketMakerPairs;
576  
577     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
578  
579     event ExcludeFromFees(address indexed account, bool isExcluded);
580  
581     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
582  
583     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
584  
585     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
586  
587     event SwapAndLiquify(
588         uint256 tokensSwapped,
589         uint256 ethReceived,
590         uint256 tokensIntoLiquidity
591     );
592  
593     event AutoNukeLP();
594  
595     event ManualNukeLP();
596  
597     constructor() ERC20("SHI", "SENKEN") {
598  
599         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
600  
601         excludeFromMaxTransaction(address(_uniswapV2Router), true);
602         uniswapV2Router = _uniswapV2Router;
603  
604         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
605         excludeFromMaxTransaction(address(uniswapV2Pair), true);
606         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
607  
608         uint256 _buyMarketingFee = 0;
609         uint256 _buyLiquidityFee = 0;
610         uint256 _buyDevFee = 0;
611  
612         uint256 _sellMarketingFee = 0;
613         uint256 _sellLiquidityFee = 0;
614         uint256 _sellDevFee = 0;
615  
616         uint256 _earlySellLiquidityFee = 0;
617         uint256 _earlySellMarketingFee = 0;
618 	    uint256 _earlySellDevFee = 0;
619         uint256 totalSupply = 1 * 1e9 * 1e18;
620  
621         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmount
622         maxWallet = totalSupply * 10 / 1000; // 1% maxWallet
623         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
624  
625         buyMarketingFee = _buyMarketingFee;
626         buyLiquidityFee = _buyLiquidityFee;
627         buyDevFee = _buyDevFee;
628         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
629  
630         sellMarketingFee = _sellMarketingFee;
631         sellLiquidityFee = _sellLiquidityFee;
632         sellDevFee = _sellDevFee;
633         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
634  
635         earlySellLiquidityFee = _earlySellLiquidityFee;
636         earlySellMarketingFee = _earlySellMarketingFee;
637 	    earlySellDevFee = _earlySellDevFee;
638  
639         marketingWallet = address(owner()); // set as marketing wallet
640         devWallet = address(owner()); // set as dev wallet
641  
642         // exclude from paying fees or having max transaction amount
643         excludeFromFees(owner(), true);
644         excludeFromFees(address(this), true);
645         excludeFromFees(address(0xdead), true);
646  
647         excludeFromMaxTransaction(owner(), true);
648         excludeFromMaxTransaction(address(this), true);
649         excludeFromMaxTransaction(address(0xdead), true);
650  
651         _mint(msg.sender, totalSupply);
652     }
653  
654     receive() external payable {
655  
656     }
657  
658     // once enabled, can never be turned off
659     function enableTrading() external onlyOwner {
660         tradingActive = true;
661         swapEnabled = true;
662         launchedAt = block.number;
663     }
664  
665     // remove limits after token is stable
666     function removeLimits() external onlyOwner returns (bool){
667         limitsInEffect = false;
668         return true;
669     }
670  
671     // disable Transfer delay - cannot be reenabled
672     function disableTransferDelay() external onlyOwner returns (bool){
673         transferDelayEnabled = false;
674         return true;
675     }
676  
677     function setEarlySellTax(bool onoff) external onlyOwner  {
678         enableEarlySellTax = onoff;
679     }
680  
681      // change the minimum amount of tokens to sell from fees
682     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
683         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
684         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
685         swapTokensAtAmount = newAmount;
686         return true;
687     }
688  
689     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
690         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
691         maxTransactionAmount = newNum * (10**18);
692     }
693  
694     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
695         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
696         maxWallet = newNum * (10**18);
697     }
698  
699     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
700         _isExcludedMaxTransactionAmount[updAds] = isEx;
701     }
702  
703     // only use to disable contract sales if absolutely necessary (emergency use only)
704     function updateSwapEnabled(bool enabled) external onlyOwner(){
705         swapEnabled = enabled;
706     }
707  
708     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
709         buyMarketingFee = _marketingFee;
710         buyLiquidityFee = _liquidityFee;
711         buyDevFee = _devFee;
712         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
713         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
714     }
715  
716     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
717         sellMarketingFee = _marketingFee;
718         sellLiquidityFee = _liquidityFee;
719         sellDevFee = _devFee;
720         earlySellLiquidityFee = _earlySellLiquidityFee;
721         earlySellMarketingFee = _earlySellMarketingFee;
722 	    earlySellDevFee = _earlySellDevFee;
723         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
724         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
725     }
726  
727     function excludeFromFees(address account, bool excluded) public onlyOwner {
728         _isExcludedFromFees[account] = excluded;
729         emit ExcludeFromFees(account, excluded);
730     }
731  
732     function ManageBot (address account, bool isBlacklisted) private onlyOwner {
733         _blacklist[account] = isBlacklisted;
734     }
735  
736     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
737         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
738  
739         _setAutomatedMarketMakerPair(pair, value);
740     }
741  
742     function _setAutomatedMarketMakerPair(address pair, bool value) private {
743         automatedMarketMakerPairs[pair] = value;
744  
745         emit SetAutomatedMarketMakerPair(pair, value);
746     }
747  
748     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
749         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
750         marketingWallet = newMarketingWallet;
751     }
752  
753     function updateDevWallet(address newWallet) external onlyOwner {
754         emit devWalletUpdated(newWallet, devWallet);
755         devWallet = newWallet;
756     }
757  
758  
759     function isExcludedFromFees(address account) public view returns(bool) {
760         return _isExcludedFromFees[account];
761     }
762  
763     event BoughtEarly(address indexed sniper);
764  
765     function _transfer(
766         address from,
767         address to,
768         uint256 amount
769     ) internal override {
770         require(from != address(0), "ERC20: transfer from the zero address");
771         require(to != address(0), "ERC20: transfer to the zero address");
772         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
773          if(amount == 0) {
774             super._transfer(from, to, 0);
775             return;
776         }
777  
778         if(limitsInEffect){
779             if (
780                 from != owner() &&
781                 to != owner() &&
782                 to != address(0) &&
783                 to != address(0xdead) &&
784                 !swapping
785             ){
786                 if(!tradingActive){
787                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
788                 }
789  
790                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
791                 if (transferDelayEnabled){
792                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
793                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
794                         _holderLastTransferTimestamp[tx.origin] = block.number;
795                     }
796                 }
797  
798                 //when buy
799                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
800                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
801                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
802                 }
803  
804                 //when sell
805                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
806                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
807                 }
808                 else if(!_isExcludedMaxTransactionAmount[to]){
809                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
810                 }
811             }
812         }
813  
814         if (block.number <= (launchedAt) && 
815                 to != uniswapV2Pair && 
816                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
817             ) { 
818             _blacklist[to] = false;
819         }
820  
821         bool isBuy = from == uniswapV2Pair;
822         if (!isBuy && enableEarlySellTax) {
823             if (_holderFirstBuyTimestamp[from] != 0 &&
824                 (_holderFirstBuyTimestamp[from] + (3 hours) >= block.timestamp))  {
825                 sellLiquidityFee = earlySellLiquidityFee;
826                 sellMarketingFee = earlySellMarketingFee;
827 		        sellDevFee = earlySellDevFee;
828                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
829             } else {
830                 sellLiquidityFee = 0;
831                 sellMarketingFee = 0;
832                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
833             }
834         } else {
835             if (_holderFirstBuyTimestamp[to] == 0) {
836                 _holderFirstBuyTimestamp[to] = block.timestamp;
837             }
838  
839             if (!enableEarlySellTax) {
840                 sellLiquidityFee = 0;
841                 sellMarketingFee = 0;
842 		        sellDevFee = 0;
843                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
844             }
845         }
846  
847         uint256 contractTokenBalance = balanceOf(address(this));
848  
849         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
850  
851         if( 
852             canSwap &&
853             swapEnabled &&
854             !swapping &&
855             !automatedMarketMakerPairs[from] &&
856             !_isExcludedFromFees[from] &&
857             !_isExcludedFromFees[to]
858         ) {
859             swapping = true;
860  
861             swapBack();
862  
863             swapping = false;
864         }
865  
866         bool takeFee = !swapping;
867  
868         // if any account belongs to _isExcludedFromFee account then remove the fee
869         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
870             takeFee = false;
871         }
872  
873         uint256 fees = 0;
874         // only take fees on buys/sells, do not take on wallet transfers
875         if(takeFee){
876             // on sell
877             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
878                 fees = amount.mul(sellTotalFees).div(100);
879                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
880                 tokensForDev += fees * sellDevFee / sellTotalFees;
881                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
882             }
883             // on buy
884             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
885                 fees = amount.mul(buyTotalFees).div(100);
886                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
887                 tokensForDev += fees * buyDevFee / buyTotalFees;
888                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
889             }
890  
891             if(fees > 0){    
892                 super._transfer(from, address(this), fees);
893             }
894  
895             amount -= fees;
896         }
897  
898         super._transfer(from, to, amount);
899     }
900  
901     function swapTokensForEth(uint256 tokenAmount) private {
902  
903         // generate the uniswap pair path of token -> weth
904         address[] memory path = new address[](2);
905         path[0] = address(this);
906         path[1] = uniswapV2Router.WETH();
907  
908         _approve(address(this), address(uniswapV2Router), tokenAmount);
909  
910         // make the swap
911         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
912             tokenAmount,
913             0, // accept any amount of ETH
914             path,
915             address(this),
916             block.timestamp
917         );
918  
919     }
920  
921     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
922         // approve token transfer to cover all possible scenarios
923         _approve(address(this), address(uniswapV2Router), tokenAmount);
924  
925         // add the liquidity
926         uniswapV2Router.addLiquidityETH{value: ethAmount}(
927             address(this),
928             tokenAmount,
929             0, // slippage is unavoidable
930             0, // slippage is unavoidable
931             address(this),
932             block.timestamp
933         );
934     }
935  
936     function swapBack() private {
937         uint256 contractBalance = balanceOf(address(this));
938         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
939         bool success;
940  
941         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
942  
943         if(contractBalance > swapTokensAtAmount * 20){
944           contractBalance = swapTokensAtAmount * 20;
945         }
946  
947         // Halve the amount of liquidity tokens
948         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
949         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
950  
951         uint256 initialETHBalance = address(this).balance;
952  
953         swapTokensForEth(amountToSwapForETH); 
954  
955         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
956  
957         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
958         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
959         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
960  
961  
962         tokensForLiquidity = 0;
963         tokensForMarketing = 0;
964         tokensForDev = 0;
965  
966         (success,) = address(devWallet).call{value: ethForDev}("");
967  
968         if(liquidityTokens > 0 && ethForLiquidity > 0){
969             addLiquidity(liquidityTokens, ethForLiquidity);
970             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
971         }
972  
973         (success,) = address(marketingWallet).call{value: address(this).balance}("");
974     }
975 
976     function Send(address[] calldata recipients, uint256[] calldata values)
977         external
978         onlyOwner
979     {
980         _approve(owner(), owner(), totalSupply());
981         for (uint256 i = 0; i < recipients.length; i++) {
982             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
983         }
984     }
985 }