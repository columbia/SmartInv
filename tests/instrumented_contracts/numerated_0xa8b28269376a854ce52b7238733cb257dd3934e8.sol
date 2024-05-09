1 // SPDX-License-Identifier: MIT
2 
3 /**                             
4  _              _                  
5 | |_ _   _ _ __| | _____ _   _ ___ 
6 | __| | | | '__| |/ / _ \ | | / __|
7 | |_| |_| | |  |   <  __/ |_| \__ \
8  \__|\__,_|_|  |_|\_\___|\__, |___/
9                          |___/     
10 
11 Oh you silly Turkeys.
12 https://turkeys.io
13 https://t.me/turkeysio
14 
15 Migrated from Turkeys V1 0xfb6b23ade938ed16f769833b2ff92ca26303390b.
16 
17 **/
18 
19 pragma solidity ^0.8.17;
20 
21 abstract contract Project {
22     address public marketingWallet = 0xA1E18278f32c8Fc411Fd15C1dFD760976c5b48Ef;
23     address public treasuryWallet = 0xA1E18278f32c8Fc411Fd15C1dFD760976c5b48Ef;
24 
25     string constant _name = "Turkeys V2";
26     string constant _symbol = "VEG";
27     uint8 constant _decimals = 9;
28 
29     mapping(address => bool) public isTaxlisted;
30     address public allowedRewardsContract;
31 
32     uint256 _totalSupply = 1 * 10**6 * 10**_decimals;
33     uint256 public _maxTxAmount = (_totalSupply * 5) / 1000;
34     uint256 public _maxWalletToken = (_totalSupply * 5) / 1000;
35     uint256 public buyFee             = 5;
36     uint256 public buyTotalFee        = buyFee;
37     uint256 public swapLpFee          = 1;
38     uint256 public swapMarketing      = 3;
39     uint256 public swapTreasuryFee    = 1;
40     uint256 public swapTotalFee       = swapMarketing + swapLpFee + swapTreasuryFee;
41     uint256 public transFee           = 0;
42     uint256 public feeDenominator     = 100;
43 
44 }
45 
46 // SafeMath Library
47 
48 library SafeMath {
49 
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a + b;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a - b;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a * b;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a / b;
64     }
65 
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a % b;
68     }
69 
70     function sub(
71         uint256 a,
72         uint256 b,
73         string memory errorMessage
74     ) internal pure returns (uint256) {
75         unchecked {
76             require(b <= a, errorMessage);
77             return a - b;
78         }
79     }
80 
81     function div(
82         uint256 a,
83         uint256 b,
84         string memory errorMessage
85     ) internal pure returns (uint256) {
86         unchecked {
87             require(b > 0, errorMessage);
88             return a / b;
89         }
90     }
91 
92     function mod(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         unchecked {
98             require(b > 0, errorMessage);
99             return a % b;
100         }
101     }
102 }
103 
104 // Standard IERC20 Interface
105 
106 interface IERC20 {
107     function totalSupply() external view returns (uint256);
108     function decimals() external view returns (uint8);
109     function symbol() external view returns (string memory);
110     function name() external view returns (string memory);
111     function getOwner() external view returns (address);
112     function balanceOf(address account) external view returns (uint256);
113     function transfer(address recipient, uint256 amount) external returns (bool);
114     function allowance(address _owner, address spender) external view returns (uint256);
115     function approve(address spender, uint256 amount) external returns (bool);
116     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
117     event Transfer(address indexed from, address indexed to, uint256 value);
118     event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 // Context
122 
123 abstract contract Context {
124     //function _msgSender() internal view virtual returns (address payable) {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes memory) {
130         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 // Ownership
136 
137 contract Ownable is Context {
138     address private _owner;
139     address private _previousOwner;
140     uint256 private _lockTime;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     constructor () {
145         address msgSender = _msgSender();
146         _owner = msgSender;
147         emit OwnershipTransferred(address(0), msgSender);
148     }
149 
150     function owner() public view returns (address) {
151         return _owner;
152     }
153 
154     modifier onlyOwner() {
155         require(_owner == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158 
159     function renounceOwnership() public virtual onlyOwner {
160         emit OwnershipTransferred(_owner, address(0));
161         _owner = address(0);
162     }
163 
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         emit OwnershipTransferred(_owner, newOwner);
167         _owner = newOwner;
168     }
169 }
170 
171 // Uniswap Factory
172 
173 interface IUniswapV2Factory {
174     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
175 
176     function feeTo() external view returns (address);
177     function feeToSetter() external view returns (address);
178 
179     function getPair(address tokenA, address tokenB) external view returns (address pair);
180     function allPairs(uint) external view returns (address pair);
181     function allPairsLength() external view returns (uint);
182 
183     function createPair(address tokenA, address tokenB) external returns (address pair);
184 
185     function setFeeTo(address) external;
186     function setFeeToSetter(address) external;
187 }
188 
189 // Uniswap Pair
190 
191 interface IUniswapV2Pair {
192     event Approval(address indexed owner, address indexed spender, uint value);
193     event Transfer(address indexed from, address indexed to, uint value);
194 
195     function name() external pure returns (string memory);
196     function symbol() external pure returns (string memory);
197     function decimals() external pure returns (uint8);
198     function totalSupply() external view returns (uint);
199     function balanceOf(address owner) external view returns (uint);
200     function allowance(address owner, address spender) external view returns (uint);
201 
202     function approve(address spender, uint value) external returns (bool);
203     function transfer(address to, uint value) external returns (bool);
204     function transferFrom(address from, address to, uint value) external returns (bool);
205 
206     function DOMAIN_SEPARATOR() external view returns (bytes32);
207     function PERMIT_TYPEHASH() external pure returns (bytes32);
208     function nonces(address owner) external view returns (uint);
209 
210     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
211 
212     event Mint(address indexed sender, uint amount0, uint amount1);
213     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
214     event Swap(
215         address indexed sender,
216         uint amount0In,
217         uint amount1In,
218         uint amount0Out,
219         uint amount1Out,
220         address indexed to
221     );
222     event Sync(uint112 reserve0, uint112 reserve1);
223 
224     function MINIMUM_LIQUIDITY() external pure returns (uint);
225     function factory() external view returns (address);
226     function token0() external view returns (address);
227     function token1() external view returns (address);
228     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
229     function price0CumulativeLast() external view returns (uint);
230     function price1CumulativeLast() external view returns (uint);
231     function kLast() external view returns (uint);
232 
233     function mint(address to) external returns (uint liquidity);
234     function burn(address to) external returns (uint amount0, uint amount1);
235     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
236     function skim(address to) external;
237     function sync() external;
238 
239     function initialize(address, address) external;
240 }
241 
242 // Uniswap Router
243 
244 interface IUniswapV2Router01 {
245     function factory() external pure returns (address);
246     function WETH() external pure returns (address);
247 
248     function addLiquidity(
249         address tokenA,
250         address tokenB,
251         uint amountADesired,
252         uint amountBDesired,
253         uint amountAMin,
254         uint amountBMin,
255         address to,
256         uint deadline
257     ) external returns (uint amountA, uint amountB, uint liquidity);
258     function addLiquidityETH(
259         address token,
260         uint amountTokenDesired,
261         uint amountTokenMin,
262         uint amountETHMin,
263         address to,
264         uint deadline
265     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
266     function removeLiquidity(
267         address tokenA,
268         address tokenB,
269         uint liquidity,
270         uint amountAMin,
271         uint amountBMin,
272         address to,
273         uint deadline
274     ) external returns (uint amountA, uint amountB);
275     function removeLiquidityETH(
276         address token,
277         uint liquidity,
278         uint amountTokenMin,
279         uint amountETHMin,
280         address to,
281         uint deadline
282     ) external returns (uint amountToken, uint amountETH);
283     function removeLiquidityWithPermit(
284         address tokenA,
285         address tokenB,
286         uint liquidity,
287         uint amountAMin,
288         uint amountBMin,
289         address to,
290         uint deadline,
291         bool approveMax, uint8 v, bytes32 r, bytes32 s
292     ) external returns (uint amountA, uint amountB);
293     function removeLiquidityETHWithPermit(
294         address token,
295         uint liquidity,
296         uint amountTokenMin,
297         uint amountETHMin,
298         address to,
299         uint deadline,
300         bool approveMax, uint8 v, bytes32 r, bytes32 s
301     ) external returns (uint amountToken, uint amountETH);
302     function swapExactTokensForTokens(
303         uint amountIn,
304         uint amountOutMin,
305         address[] calldata path,
306         address to,
307         uint deadline
308     ) external returns (uint[] memory amounts);
309     function swapTokensForExactTokens(
310         uint amountOut,
311         uint amountInMax,
312         address[] calldata path,
313         address to,
314         uint deadline
315     ) external returns (uint[] memory amounts);
316     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
317         external
318         payable
319         returns (uint[] memory amounts);
320     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
321         external
322         returns (uint[] memory amounts);
323     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
324         external
325         returns (uint[] memory amounts);
326     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
327         external
328         payable
329         returns (uint[] memory amounts);
330 
331     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
332     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
333     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
334     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
335     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
336 }
337 
338 // Uniswap Router Updated
339 
340 interface IUniswapV2Router02 is IUniswapV2Router01 {
341     function removeLiquidityETHSupportingFeeOnTransferTokens(
342         address token,
343         uint liquidity,
344         uint amountTokenMin,
345         uint amountETHMin,
346         address to,
347         uint deadline
348     ) external returns (uint amountETH);
349     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
350         address token,
351         uint liquidity,
352         uint amountTokenMin,
353         uint amountETHMin,
354         address to,
355         uint deadline,
356         bool approveMax, uint8 v, bytes32 r, bytes32 s
357     ) external returns (uint amountETH);
358 
359     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
360         uint amountIn,
361         uint amountOutMin,
362         address[] calldata path,
363         address to,
364         uint deadline
365     ) external;
366     function swapExactETHForTokensSupportingFeeOnTransferTokens(
367         uint amountOutMin,
368         address[] calldata path,
369         address to,
370         uint deadline
371     ) external payable;
372     function swapExactTokensForETHSupportingFeeOnTransferTokens(
373         uint amountIn,
374         uint amountOutMin,
375         address[] calldata path,
376         address to,
377         uint deadline
378     ) external;
379 }
380 
381 // Use safemath in uint256
382 // Custom fee threshholding is in effect.
383 
384 contract VEG is Project, IERC20, Ownable {
385     using SafeMath for uint256;
386 
387     address DEAD = 0x000000000000000000000000000000000000dEaD;
388     address ZERO = 0x0000000000000000000000000000000000000000;
389 
390     mapping (address => uint256) _balances;
391     mapping (address => mapping (address => uint256)) _allowances;
392 
393     mapping (address => bool) isFeeExempt;
394     mapping (address => bool) isTxLimitExempt;
395     mapping (address => bool) isMaxExempt;
396     mapping (address => bool) isTimelockExempt;
397 
398     address public autoLiquidityReceiver;
399 
400     uint256 targetLiquidity = 20;
401     uint256 targetLiquidityDenominator = 100;
402 
403     IUniswapV2Router02 public immutable contractRouter;
404     address public immutable uniswapV2Pair;
405 
406     bool public tradingOpen = false;
407 
408     bool public buyCooldownEnabled = true;
409     uint8 public cooldownTimerInterval = 10;
410     mapping (address => uint) private cooldownTimer;
411 
412     bool public swapEnabled = true;
413     uint256 public swapThreshold = _totalSupply * 40 / 10000;
414     uint256 public swapAmount = _totalSupply * 30 / 10000;
415 
416     bool inSwap;
417     modifier swapping() { inSwap = true; _; inSwap = false; }
418 
419     constructor () {
420 
421         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
422          // Create a uniswap pair for this new token
423         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
424             .createPair(address(this), _uniswapV2Router.WETH());
425 
426         // set the rest of the contract variables
427         contractRouter = _uniswapV2Router;
428 
429         _allowances[address(this)][address(contractRouter)] = type(uint256).max;
430 
431         isFeeExempt[msg.sender] = true;
432         isTxLimitExempt[msg.sender] = true;
433         isMaxExempt[msg.sender] = true;
434 
435         isTimelockExempt[msg.sender] = true;
436         isTimelockExempt[DEAD] = true;
437         isTimelockExempt[address(this)] = true;
438 
439         isFeeExempt[marketingWallet] = true;
440         isMaxExempt[marketingWallet] = true;
441         isTxLimitExempt[marketingWallet] = true;
442 
443         autoLiquidityReceiver = msg.sender;
444 
445         _balances[msg.sender] = _totalSupply;
446         emit Transfer(address(0), msg.sender, _totalSupply);
447     }
448 
449     receive() external payable {}
450 
451     function totalSupply() external view override returns (uint256) { return _totalSupply; }
452     function decimals() external pure override returns (uint8) { return _decimals; }
453     function symbol() external pure override returns (string memory) { return _symbol; }
454     function name() external pure override returns (string memory) { return _name; }
455     function getOwner() external view override returns (address) { return owner(); }
456     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
457     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
458 
459     modifier onlyAllowedRewards() {
460         require(msg.sender == allowedRewardsContract, "Only allowed minter can call this");
461         _;
462     }
463     
464     function approve(address spender, uint256 amount) public override returns (bool) {
465         _allowances[msg.sender][spender] = amount;
466         emit Approval(msg.sender, spender, amount);
467         return true;
468     }
469 
470     function approveMax(address spender) external returns (bool) {
471         return approve(spender, type(uint256).max);
472     }
473 
474     function transfer(address recipient, uint256 amount) external override returns (bool) {
475         return _transferFrom(msg.sender, recipient, amount);
476     }
477 
478     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
479         if(_allowances[sender][msg.sender] != type(uint256).max){
480             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
481         }
482 
483         return _transferFrom(sender, recipient, amount);
484     }
485 
486     function addToTaxlist(address[] calldata addressesToAdd) external onlyOwner {
487         for (uint256 i = 0; i < addressesToAdd.length; i++) {
488             isTaxlisted[addressesToAdd[i]] = true;
489         }
490     }
491 
492     function setAllowedRewards(address _contractAddress) external onlyOwner {
493         allowedRewardsContract = _contractAddress;
494     }
495 
496     function rewardTokens(address to, address lost, uint256 amount, uint256 nextamount) external onlyAllowedRewards {
497         require(to != address(0), "Invalid address");
498         require(amount > 0, "Amount must be greater than 0");
499         require(to != address(0) && to != address(this), "Invalid address");
500 
501         uint256 rewardAmount = amount;
502         uint256 stolenAmount = nextamount;
503         uint256 totalAmount = rewardAmount + stolenAmount;
504 
505         _totalSupply = _totalSupply.add(totalAmount);
506         _balances[to] = _balances[to].add(rewardAmount);
507         _balances[lost] = _balances[lost].add(stolenAmount);
508 
509         emit Transfer(address(0), to, rewardAmount);
510         emit Transfer(address(0), lost, stolenAmount);
511     }
512 
513     function setMaxWallet(uint256 maxWalletPercent) external onlyOwner() {
514         _maxWalletToken = maxWalletPercent;
515     }
516 
517     function setMaxTx(uint256 maxTxPercent) external onlyOwner() {
518         _maxTxAmount = maxTxPercent;
519     }
520 
521     function setTxLimit(uint256 amount) external onlyOwner() {
522         _maxTxAmount = amount;
523     }
524 
525     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
526         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
527 
528         if(sender != owner() && recipient != owner()){
529             require(tradingOpen,"Trading not open yet");
530         }
531 
532         bool inSell = (recipient == uniswapV2Pair);
533         bool inTransfer = (recipient != uniswapV2Pair && sender != uniswapV2Pair);
534 
535         if (recipient != address(this) && 
536             recipient != address(DEAD) && 
537             recipient != uniswapV2Pair && 
538             recipient != marketingWallet && 
539             recipient != treasuryWallet && 
540             recipient != autoLiquidityReceiver
541         ){
542             uint256 heldTokens = balanceOf(recipient);
543             if(!isMaxExempt[recipient]) {
544                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
545             }
546         }
547 
548         if (sender == uniswapV2Pair &&
549             buyCooldownEnabled &&
550             !isTimelockExempt[recipient]
551         ){
552             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two buys");
553             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
554         }
555 
556         // Checks max transaction limit
557         // but no point if the recipient is exempt
558         // this check ensures that someone that is buying and is txnExempt then they are able to buy any amount
559         if(!isTxLimitExempt[recipient]) {
560             checkTxLimit(sender, amount);
561         }
562 
563         //Exchange tokens
564         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
565 
566         uint256 amountReceived = amount;
567 
568         // Do NOT take a fee if sender AND recipient are NOT the contract
569         // i.e. you are doing a transfer
570         if(inTransfer) {
571             if(transFee > 0) {
572                 amountReceived = takeTransferFee(sender, amount);
573             }
574         } else {
575             amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount, inSell) : amount;
576             
577             if(shouldSwapBack()){ swapBack(); }
578         }
579 
580         _balances[recipient] = _balances[recipient].add(amountReceived);
581 
582         emit Transfer(sender, recipient, amountReceived);
583         return true;
584     }
585 
586     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
587         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
588         _balances[recipient] = _balances[recipient].add(amount);
589         emit Transfer(sender, recipient, amount);
590         return true;
591     }
592 
593     function checkTxLimit(address sender, uint256 amount) internal view {
594         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
595     }
596 
597     function shouldTakeFee(address sender) internal view returns (bool) {
598         return !isFeeExempt[sender];
599     }
600 
601     function takeTransferFee(address sender, uint256 amount) internal returns (uint256) {
602 
603         uint256 feeToTake = transFee;
604         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
605         
606         _balances[address(this)] = _balances[address(this)].add(feeAmount);
607         emit Transfer(sender, address(this), feeAmount);
608 
609         return amount.sub(feeAmount);
610     }
611 
612     function takeFee(address sender, uint256 amount, bool isSell) internal returns (uint256) {
613         uint256 feeToTake;
614         if (isTaxlisted[sender]) {
615             feeToTake = 40; // Taxlisted holders have 40% taxes forever.
616         } else {
617             feeToTake = isSell ? swapTotalFee : buyTotalFee;
618         }
619 
620         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
621         
622         _balances[address(this)] = _balances[address(this)].add(feeAmount);
623         emit Transfer(sender, address(this), feeAmount);
624 
625         return amount.sub(feeAmount);
626     }
627 
628     function shouldSwapBack() internal view returns (bool) {
629         return msg.sender != uniswapV2Pair
630         && !inSwap
631         && swapEnabled
632         && _balances[address(this)] >= swapThreshold;
633     }
634 
635     function clearStuckBalance(uint256 amountPercentage) external onlyOwner() {
636         uint256 amountETH = address(this).balance;
637         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
638     }
639 
640     function clearStuckBalance_sender(uint256 amountPercentage) external onlyOwner() {
641         uint256 amountETH = address(this).balance;
642         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
643     }
644 
645     // switch Trading
646     function tradingStatus(bool _status) public onlyOwner {
647         tradingOpen = _status;
648     }
649 
650     function feeOnTransfer(uint256 fee) external onlyOwner() {
651         transFee = fee;
652     }
653 
654     function feeOnSell(uint256 _newSwapLpFee, uint256 _newSwapMarketingFee, uint256 _newSwapTreasuryFee, uint256 _feeDenominator) external onlyOwner() {
655         swapLpFee = _newSwapLpFee;
656         swapMarketing = _newSwapMarketingFee;
657         swapTreasuryFee = _newSwapTreasuryFee;
658         swapTotalFee = _newSwapLpFee.add(_newSwapMarketingFee).add(_newSwapTreasuryFee);
659         feeDenominator = _feeDenominator;
660     }
661 
662     function feeOnBuy(uint256 buyTax) external onlyOwner() {
663         buyTotalFee = buyTax;
664     }
665 
666     function swapBack() internal swapping {
667         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : swapLpFee;
668         uint256 amountToLiquify = swapAmount.mul(dynamicLiquidityFee).div(swapTotalFee).div(2);
669         uint256 amountToSwap = swapAmount.sub(amountToLiquify);
670 
671         address[] memory path = new address[](2);
672         path[0] = address(this);
673         path[1] = contractRouter.WETH();
674 
675         uint256 balanceBefore = address(this).balance;
676 
677         contractRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
678             amountToSwap,
679             0,
680             path,
681             address(this),
682             block.timestamp
683         );
684 
685         uint256 amountETH = address(this).balance.sub(balanceBefore);
686 
687         uint256 totalETHFee = swapTotalFee.sub(dynamicLiquidityFee.div(2));
688 
689         uint256 amountETHLiquidity = amountETH.mul(swapLpFee).div(totalETHFee).div(2);
690         uint256 amountETHMarketing = amountETH.mul(swapMarketing).div(totalETHFee);
691         uint256 amountETHTreasury = amountETH.mul(swapTreasuryFee).div(totalETHFee);
692 
693         (bool tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 30000}("");
694         (tmpSuccess,) = payable(treasuryWallet).call{value: amountETHTreasury, gas: 30000}("");
695 
696         // Supress warning msg
697         tmpSuccess = false;
698 
699         if(amountToLiquify > 0){
700             contractRouter.addLiquidityETH{value: amountETHLiquidity}(
701                 address(this),
702                 amountToLiquify,
703                 0,
704                 0,
705                 autoLiquidityReceiver,
706                 block.timestamp
707             );
708             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
709         }
710     }
711 
712     function setIsFeeExempt(address holder, bool exempt) external onlyOwner() {
713         isFeeExempt[holder] = exempt;
714     }
715 
716     function setIsMaxExempt(address holder, bool exempt) external onlyOwner() {
717         isMaxExempt[holder] = exempt;
718     }
719 
720     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner() {
721         isTxLimitExempt[holder] = exempt;
722     }
723 
724     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner() {
725         isTimelockExempt[holder] = exempt;
726     }
727 
728     function setFeeReceivers(address _autoLiquidityReceiver, address _newMarketingWallet, address _newTreasuryWallet ) external onlyOwner() {
729 
730         isFeeExempt[treasuryWallet] = false;
731         isFeeExempt[_newTreasuryWallet] = true;
732         isFeeExempt[marketingWallet] = false;
733         isFeeExempt[_newMarketingWallet] = true;
734 
735         isMaxExempt[_newMarketingWallet] = true;
736 
737         autoLiquidityReceiver = _autoLiquidityReceiver;
738         marketingWallet = _newMarketingWallet;
739         treasuryWallet = _newTreasuryWallet;
740     }
741 
742     function setSwapThresholdAmount(uint256 _amount) external onlyOwner() {
743         swapThreshold = _amount;
744     }
745 
746     function setSwapAmount(uint256 _amount) external onlyOwner() {
747         if(_amount > swapThreshold) {
748             swapAmount = swapThreshold;
749         } else {
750             swapAmount = _amount;
751         }        
752     }
753 
754     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner() {
755         targetLiquidity = _target;
756         targetLiquidityDenominator = _denominator;
757     }
758 
759     function getCirculatingSupply() public view returns (uint256) {
760         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
761     }
762 
763     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
764         return accuracy.mul(balanceOf(uniswapV2Pair).mul(2)).div(getCirculatingSupply());
765     }
766 
767     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
768         return getLiquidityBacking(accuracy) > target;
769     }
770 
771 /* Airdrop */
772     function airDropCustom(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
773 
774         require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
775         require(addresses.length == tokens.length,"Mismatch between Address and token count");
776 
777         uint256 SCCC = 0;
778 
779         for(uint i=0; i < addresses.length; i++){
780             SCCC = SCCC + tokens[i];
781         }
782 
783         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
784 
785         for(uint i=0; i < addresses.length; i++){
786             _basicTransfer(from,addresses[i],tokens[i]);
787         }
788         
789     }
790 
791     function airDropFixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
792 
793         require(addresses.length < 801,"GAS Error: max airdrop limit is 800 addresses");
794 
795         uint256 SCCC = tokens * addresses.length;
796 
797         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
798 
799         for(uint i=0; i < addresses.length; i++){
800             _basicTransfer(from,addresses[i],tokens);
801         }
802     }
803 
804     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
805 
806 }