1 /**
2  *Submitted for verification at Etherscan.io on 2023-01-11
3 */
4 
5 /**
6 
7 TELEGRAM: https://t.me/ZeusCoinERC20
8 
9 DISCORD: https://discord.gg/HrGNvufNeX
10 
11 TWITTER: https://twitter.com/ZeusCoinERC20
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 /**
18  
19 */
20 
21 
22 pragma solidity ^0.8.17;
23 
24 /**
25  * Abstract contract to easily change things when deploying new projects. Saves me having to find it everywhere.
26  */
27 abstract contract Project {
28     address public marketingWallet = 0x96c2233Ff62643b88EC3CF18f9a237FB486b0Ad0;
29     address public devWallet = 0x96c2233Ff62643b88EC3CF18f9a237FB486b0Ad0;
30 
31     string constant _name = "Zeus Coin";
32     string constant _symbol = "Zeus";
33     uint8 constant _decimals = 9;
34 
35     uint256 _totalSupply = 1 * 10**6 * 10**_decimals;
36 
37     uint256 public _maxTxAmount = (_totalSupply * 10) / 1000; // (_totalSupply * 10) / 1000 [this equals 1%]
38     uint256 public _maxWalletToken = (_totalSupply * 10) / 1000; //
39 
40     uint256 public buyFee             = 0;
41     uint256 public buyTotalFee        = buyFee;
42 
43     uint256 public swapLpFee          = 0;
44     uint256 public swapMarketing      = 0;
45     uint256 public swapTreasuryFee    = 0;
46     uint256 public swapTotalFee       = swapMarketing + swapLpFee + swapTreasuryFee;
47 
48     uint256 public transFee           = 0;
49 
50     uint256 public feeDenominator     = 100;
51 
52 }
53 
54 /**
55  * @dev Wrappers over Solidity's arithmetic operations.
56  *
57  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
58  * now has built in overflow checking.
59  */
60 library SafeMath {
61 
62     /**
63      * @dev Returns the addition of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `+` operator.
67      *
68      * Requirements:
69      *
70      * - Addition cannot overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         return a + b;
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      *
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return a - b;
88     }
89 
90     /**
91      * @dev Returns the multiplication of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `*` operator.
95      *
96      * Requirements:
97      *
98      * - Multiplication cannot overflow.
99      */
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         return a * b;
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers, reverting on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator.
109      *
110      * Requirements:
111      *
112      * - The divisor cannot be zero.
113      */
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return a / b;
116     }
117 
118     /**
119      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
120      * reverting when dividing by zero.
121      *
122      * Counterpart to Solidity's `%` operator. This function uses a `revert`
123      * opcode (which leaves remaining gas untouched) while Solidity uses an
124      * invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      *
128      * - The divisor cannot be zero.
129      */
130     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a % b;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
136      * overflow (when the result is negative).
137      *
138      * CAUTION: This function is deprecated because it requires allocating memory for the error
139      * message unnecessarily. For custom revert reasons use {trySub}.
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(
148         uint256 a,
149         uint256 b,
150         string memory errorMessage
151     ) internal pure returns (uint256) {
152         unchecked {
153             require(b <= a, errorMessage);
154             return a - b;
155         }
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function div(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b > 0, errorMessage);
177             return a / b;
178         }
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * reverting with custom message when dividing by zero.
184      *
185      * CAUTION: This function is deprecated because it requires allocating memory for the error
186      * message unnecessarily. For custom revert reasons use {tryMod}.
187      *
188      * Counterpart to Solidity's `%` operator. This function uses a `revert`
189      * opcode (which leaves remaining gas untouched) while Solidity uses an
190      * invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function mod(
197         uint256 a,
198         uint256 b,
199         string memory errorMessage
200     ) internal pure returns (uint256) {
201         unchecked {
202             require(b > 0, errorMessage);
203             return a % b;
204         }
205     }
206 }
207 
208 interface IERC20 {
209     function totalSupply() external view returns (uint256);
210     function decimals() external view returns (uint8);
211     function symbol() external view returns (string memory);
212     function name() external view returns (string memory);
213     function getOwner() external view returns (address);
214     function balanceOf(address account) external view returns (uint256);
215     function transfer(address recipient, uint256 amount) external returns (bool);
216     function allowance(address _owner, address spender) external view returns (uint256);
217     function approve(address spender, uint256 amount) external returns (bool);
218     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
219     event Transfer(address indexed from, address indexed to, uint256 value);
220     event Approval(address indexed owner, address indexed spender, uint256 value);
221 }
222 
223 abstract contract Context {
224     //function _msgSender() internal view virtual returns (address payable) {
225     function _msgSender() internal view virtual returns (address) {
226         return msg.sender;
227     }
228 
229     function _msgData() internal view virtual returns (bytes memory) {
230         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
231         return msg.data;
232     }
233 }
234 
235 
236 /**
237  * @dev Contract module which provides a basic access control mechanism, where
238  * there is an account (an owner) that can be granted exclusive access to
239  * specific functions.
240  *
241  * By default, the owner account will be the one that deploys the contract. This
242  * can later be changed with {transferOwnership}.
243  *
244  * This module is used through inheritance. It will make available the modifier
245  * `onlyOwner`, which can be applied to your functions to restrict their use to
246  * the owner.
247  */
248 contract Ownable is Context {
249     address private _owner;
250     address private _previousOwner;
251     uint256 private _lockTime;
252 
253     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
254 
255     /**
256      * @dev Initializes the contract setting the deployer as the initial owner.
257      */
258     constructor () {
259         address msgSender = _msgSender();
260         _owner = msgSender;
261         emit OwnershipTransferred(address(0), msgSender);
262     }
263 
264     /**
265      * @dev Returns the address of the current owner.
266      */
267     function owner() public view returns (address) {
268         return _owner;
269     }
270 
271     /**
272      * @dev Throws if called by any account other than the owner.
273      */
274     modifier onlyOwner() {
275         require(_owner == _msgSender(), "Ownable: caller is not the owner");
276         _;
277     }
278 
279      /**
280      * @dev Leaves the contract without owner. It will not be possible to call
281      * `onlyOwner` functions anymore. Can only be called by the current owner.
282      *
283      * NOTE: Renouncing ownership will leave the contract without an owner,
284      * thereby removing any functionality that is only available to the owner.
285      */
286     function renounceOwnership() public virtual onlyOwner {
287         emit OwnershipTransferred(_owner, address(0));
288         _owner = address(0);
289     }
290 
291     /**
292      * @dev Transfers ownership of the contract to a new account (`newOwner`).
293      * Can only be called by the current owner.
294      */
295     function transferOwnership(address newOwner) public virtual onlyOwner {
296         require(newOwner != address(0), "Ownable: new owner is the zero address");
297         emit OwnershipTransferred(_owner, newOwner);
298         _owner = newOwner;
299     }
300 
301     function geUnlockTime() public view returns (uint256) {
302         return _lockTime;
303     }
304 
305     //Locks the contract for owner for the amount of time provided
306     function lock(uint256 time) public virtual onlyOwner {
307         _previousOwner = _owner;
308         _owner = address(0);
309         _lockTime = block.timestamp + time;
310         emit OwnershipTransferred(_owner, address(0));
311     }
312     
313     //Unlocks the contract for owner when _lockTime is exceeds
314     function unlock() public virtual {
315         require(_previousOwner == msg.sender, "You don't have permission to unlock");
316         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
317         emit OwnershipTransferred(_owner, _previousOwner);
318         _owner = _previousOwner;
319     }
320 }
321 
322 
323 interface IUniswapV2Factory {
324     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
325 
326     function feeTo() external view returns (address);
327     function feeToSetter() external view returns (address);
328 
329     function getPair(address tokenA, address tokenB) external view returns (address pair);
330     function allPairs(uint) external view returns (address pair);
331     function allPairsLength() external view returns (uint);
332 
333     function createPair(address tokenA, address tokenB) external returns (address pair);
334 
335     function setFeeTo(address) external;
336     function setFeeToSetter(address) external;
337 }
338 
339 
340 
341 interface IUniswapV2Pair {
342     event Approval(address indexed owner, address indexed spender, uint value);
343     event Transfer(address indexed from, address indexed to, uint value);
344 
345     function name() external pure returns (string memory);
346     function symbol() external pure returns (string memory);
347     function decimals() external pure returns (uint8);
348     function totalSupply() external view returns (uint);
349     function balanceOf(address owner) external view returns (uint);
350     function allowance(address owner, address spender) external view returns (uint);
351 
352     function approve(address spender, uint value) external returns (bool);
353     function transfer(address to, uint value) external returns (bool);
354     function transferFrom(address from, address to, uint value) external returns (bool);
355 
356     function DOMAIN_SEPARATOR() external view returns (bytes32);
357     function PERMIT_TYPEHASH() external pure returns (bytes32);
358     function nonces(address owner) external view returns (uint);
359 
360     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
361 
362     event Mint(address indexed sender, uint amount0, uint amount1);
363     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
364     event Swap(
365         address indexed sender,
366         uint amount0In,
367         uint amount1In,
368         uint amount0Out,
369         uint amount1Out,
370         address indexed to
371     );
372     event Sync(uint112 reserve0, uint112 reserve1);
373 
374     function MINIMUM_LIQUIDITY() external pure returns (uint);
375     function factory() external view returns (address);
376     function token0() external view returns (address);
377     function token1() external view returns (address);
378     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
379     function price0CumulativeLast() external view returns (uint);
380     function price1CumulativeLast() external view returns (uint);
381     function kLast() external view returns (uint);
382 
383     function mint(address to) external returns (uint liquidity);
384     function burn(address to) external returns (uint amount0, uint amount1);
385     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
386     function skim(address to) external;
387     function sync() external;
388 
389     function initialize(address, address) external;
390 }
391 
392 
393 interface IUniswapV2Router01 {
394     function factory() external pure returns (address);
395     function WETH() external pure returns (address);
396 
397     function addLiquidity(
398         address tokenA,
399         address tokenB,
400         uint amountADesired,
401         uint amountBDesired,
402         uint amountAMin,
403         uint amountBMin,
404         address to,
405         uint deadline
406     ) external returns (uint amountA, uint amountB, uint liquidity);
407     function addLiquidityETH(
408         address token,
409         uint amountTokenDesired,
410         uint amountTokenMin,
411         uint amountETHMin,
412         address to,
413         uint deadline
414     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
415     function removeLiquidity(
416         address tokenA,
417         address tokenB,
418         uint liquidity,
419         uint amountAMin,
420         uint amountBMin,
421         address to,
422         uint deadline
423     ) external returns (uint amountA, uint amountB);
424     function removeLiquidityETH(
425         address token,
426         uint liquidity,
427         uint amountTokenMin,
428         uint amountETHMin,
429         address to,
430         uint deadline
431     ) external returns (uint amountToken, uint amountETH);
432     function removeLiquidityWithPermit(
433         address tokenA,
434         address tokenB,
435         uint liquidity,
436         uint amountAMin,
437         uint amountBMin,
438         address to,
439         uint deadline,
440         bool approveMax, uint8 v, bytes32 r, bytes32 s
441     ) external returns (uint amountA, uint amountB);
442     function removeLiquidityETHWithPermit(
443         address token,
444         uint liquidity,
445         uint amountTokenMin,
446         uint amountETHMin,
447         address to,
448         uint deadline,
449         bool approveMax, uint8 v, bytes32 r, bytes32 s
450     ) external returns (uint amountToken, uint amountETH);
451     function swapExactTokensForTokens(
452         uint amountIn,
453         uint amountOutMin,
454         address[] calldata path,
455         address to,
456         uint deadline
457     ) external returns (uint[] memory amounts);
458     function swapTokensForExactTokens(
459         uint amountOut,
460         uint amountInMax,
461         address[] calldata path,
462         address to,
463         uint deadline
464     ) external returns (uint[] memory amounts);
465     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
466         external
467         payable
468         returns (uint[] memory amounts);
469     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
470         external
471         returns (uint[] memory amounts);
472     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
473         external
474         returns (uint[] memory amounts);
475     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
476         external
477         payable
478         returns (uint[] memory amounts);
479 
480     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
481     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
482     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
483     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
484     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
485 }
486 
487 
488 
489 
490 interface IUniswapV2Router02 is IUniswapV2Router01 {
491     function removeLiquidityETHSupportingFeeOnTransferTokens(
492         address token,
493         uint liquidity,
494         uint amountTokenMin,
495         uint amountETHMin,
496         address to,
497         uint deadline
498     ) external returns (uint amountETH);
499     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
500         address token,
501         uint liquidity,
502         uint amountTokenMin,
503         uint amountETHMin,
504         address to,
505         uint deadline,
506         bool approveMax, uint8 v, bytes32 r, bytes32 s
507     ) external returns (uint amountETH);
508 
509     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
510         uint amountIn,
511         uint amountOutMin,
512         address[] calldata path,
513         address to,
514         uint deadline
515     ) external;
516     function swapExactETHForTokensSupportingFeeOnTransferTokens(
517         uint amountOutMin,
518         address[] calldata path,
519         address to,
520         uint deadline
521     ) external payable;
522     function swapExactTokensForETHSupportingFeeOnTransferTokens(
523         uint amountIn,
524         uint amountOutMin,
525         address[] calldata path,
526         address to,
527         uint deadline
528     ) external;
529 }
530 
531 
532 /**
533  * MainContract
534  */
535 contract ZeusContract is Project, IERC20, Ownable {
536     using SafeMath for uint256;
537 
538     address DEAD = 0x000000000000000000000000000000000000dEaD;
539     address ZERO = 0x0000000000000000000000000000000000000000;
540 
541     mapping (address => uint256) _balances;
542     mapping (address => mapping (address => uint256)) _allowances;
543 
544     mapping (address => bool) isFeeExempt;
545     mapping (address => bool) isTxLimitExempt;
546     mapping (address => bool) isMaxExempt;
547     mapping (address => bool) isTimelockExempt;
548 
549     address public autoLiquidityReceiver;
550 
551     uint256 targetLiquidity = 20;
552     uint256 targetLiquidityDenominator = 100;
553 
554     IUniswapV2Router02 public immutable contractRouter;
555     address public immutable uniswapV2Pair;
556 
557     bool public tradingOpen = false;
558 
559     bool public buyCooldownEnabled = true;
560     uint8 public cooldownTimerInterval = 10;
561     mapping (address => uint) private cooldownTimer;
562 
563     bool public swapEnabled = true;
564     uint256 public swapThreshold = _totalSupply * 30 / 10000;
565     uint256 public swapAmount = _totalSupply * 30 / 10000;
566 
567     bool inSwap;
568     modifier swapping() { inSwap = true; _; inSwap = false; }
569 
570     constructor () {
571 
572         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
573          // Create a uniswap pair for this new token
574         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
575             .createPair(address(this), _uniswapV2Router.WETH());
576 
577         // set the rest of the contract variables
578         contractRouter = _uniswapV2Router;
579 
580         _allowances[address(this)][address(contractRouter)] = type(uint256).max;
581 
582         isFeeExempt[msg.sender] = true;
583         isTxLimitExempt[msg.sender] = true;
584         isMaxExempt[msg.sender] = true;
585 
586         isTimelockExempt[msg.sender] = true;
587         isTimelockExempt[DEAD] = true;
588         isTimelockExempt[address(this)] = true;
589 
590         isFeeExempt[marketingWallet] = true;
591         isMaxExempt[marketingWallet] = true;
592         isTxLimitExempt[marketingWallet] = true;
593 
594         autoLiquidityReceiver = msg.sender;
595 
596         _balances[msg.sender] = _totalSupply;
597         emit Transfer(address(0), msg.sender, _totalSupply);
598     }
599 
600     receive() external payable { }
601 
602     function totalSupply() external view override returns (uint256) { return _totalSupply; }
603     function decimals() external pure override returns (uint8) { return _decimals; }
604     function symbol() external pure override returns (string memory) { return _symbol; }
605     function name() external pure override returns (string memory) { return _name; }
606     function getOwner() external view override returns (address) { return owner(); }
607     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
608     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
609 
610     function approve(address spender, uint256 amount) public override returns (bool) {
611         _allowances[msg.sender][spender] = amount;
612         emit Approval(msg.sender, spender, amount);
613         return true;
614     }
615 
616     function approveMax(address spender) external returns (bool) {
617         return approve(spender, type(uint256).max);
618     }
619 
620     function transfer(address recipient, uint256 amount) external override returns (bool) {
621         return _transferFrom(msg.sender, recipient, amount);
622     }
623 
624     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
625         if(_allowances[sender][msg.sender] != type(uint256).max){
626             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
627         }
628 
629         return _transferFrom(sender, recipient, amount);
630     }
631 
632     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
633         _maxWalletToken = (_totalSupply * maxWallPercent_base1000 ) / 1000;
634     }
635     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner() {
636         _maxTxAmount = (_totalSupply * maxTXPercentage_base1000 ) / 1000;
637     }
638 
639     function setTxLimit(uint256 amount) external onlyOwner() {
640         _maxTxAmount = amount;
641     }
642 
643 // *** 
644 // Functions for the burning mechanism 
645 // *** 
646 
647     /**
648     * Burn an amount of tokens for the current wallet (if they have enough)
649     */
650     function burnTokens(uint256 amount) external {
651         // does this user have enough tokens to perform the burn
652         if(_balances[msg.sender] > amount) {
653             _basicTransfer(msg.sender, DEAD, amount);
654         }
655     }
656 
657 
658 // *** 
659 // End functions for the burning mechanism 
660 // *** 
661 
662     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
663         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
664 
665         if(sender != owner() && recipient != owner()){
666             require(tradingOpen,"Trading not open yet");
667         }
668 
669         bool inSell = (recipient == uniswapV2Pair);
670         bool inTransfer = (recipient != uniswapV2Pair && sender != uniswapV2Pair);
671 
672         if (recipient != address(this) && 
673             recipient != address(DEAD) && 
674             recipient != uniswapV2Pair && 
675             recipient != marketingWallet && 
676             recipient != devWallet && 
677             recipient != autoLiquidityReceiver
678         ){
679             uint256 heldTokens = balanceOf(recipient);
680             if(!isMaxExempt[recipient]) {
681                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
682             }
683         }
684 
685         if (sender == uniswapV2Pair &&
686             buyCooldownEnabled &&
687             !isTimelockExempt[recipient]
688         ){
689             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two buys");
690             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
691         }
692 
693         // Checks max transaction limit
694         // but no point if the recipient is exempt
695         // this check ensures that someone that is buying and is txnExempt then they are able to buy any amount
696         if(!isTxLimitExempt[recipient]) {
697             checkTxLimit(sender, amount);
698         }
699 
700         //Exchange tokens
701         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
702 
703         uint256 amountReceived = amount;
704 
705         // Do NOT take a fee if sender AND recipient are NOT the contract
706         // i.e. you are doing a transfer
707         if(inTransfer) {
708             if(transFee > 0) {
709                 amountReceived = takeTransferFee(sender, amount);
710             }
711         } else {
712             amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount, inSell) : amount;
713             
714             if(shouldSwapBack()){ swapBack(); }
715         }
716 
717         _balances[recipient] = _balances[recipient].add(amountReceived);
718 
719         emit Transfer(sender, recipient, amountReceived);
720         return true;
721     }
722 
723     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
724         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
725         _balances[recipient] = _balances[recipient].add(amount);
726         emit Transfer(sender, recipient, amount);
727         return true;
728     }
729 
730     function checkTxLimit(address sender, uint256 amount) internal view {
731         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
732     }
733 
734     function shouldTakeFee(address sender) internal view returns (bool) {
735         return !isFeeExempt[sender];
736     }
737 
738 // *** 
739 // Handle Fees
740 // *** 
741 
742     function takeTransferFee(address sender, uint256 amount) internal returns (uint256) {
743 
744         uint256 feeToTake = transFee;
745         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
746         
747         _balances[address(this)] = _balances[address(this)].add(feeAmount);
748         emit Transfer(sender, address(this), feeAmount);
749 
750         return amount.sub(feeAmount);
751     }
752 
753     function takeFee(address sender, uint256 amount, bool isSell) internal returns (uint256) {
754 
755         uint256 feeToTake = isSell ? swapTotalFee : buyTotalFee;
756         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
757         
758         _balances[address(this)] = _balances[address(this)].add(feeAmount);
759         emit Transfer(sender, address(this), feeAmount);
760 
761         return amount.sub(feeAmount);
762     }
763 
764 // *** 
765 // End Handle Fees
766 // *** 
767 
768     function shouldSwapBack() internal view returns (bool) {
769         return msg.sender != uniswapV2Pair
770         && !inSwap
771         && swapEnabled
772         && _balances[address(this)] >= swapThreshold;
773     }
774 
775     function clearStuckBalance(uint256 amountPercentage) external onlyOwner() {
776         uint256 amountETH = address(this).balance;
777         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
778     }
779 
780     function clearStuckBalance_sender(uint256 amountPercentage) external onlyOwner() {
781         uint256 amountETH = address(this).balance;
782         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
783     }
784 
785     // switch Trading
786     function tradingStatus(bool _status) public onlyOwner {
787         tradingOpen = _status;
788     }
789 
790     // enable cooldown between trades
791     function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
792         buyCooldownEnabled = _status;
793         cooldownTimerInterval = _interval;
794     }
795 
796     function swapBack() internal swapping {
797         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : swapLpFee;
798         uint256 amountToLiquify = swapAmount.mul(dynamicLiquidityFee).div(swapTotalFee).div(2);
799         uint256 amountToSwap = swapAmount.sub(amountToLiquify);
800 
801         address[] memory path = new address[](2);
802         path[0] = address(this);
803         path[1] = contractRouter.WETH();
804 
805         uint256 balanceBefore = address(this).balance;
806 
807         contractRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
808             amountToSwap,
809             0,
810             path,
811             address(this),
812             block.timestamp
813         );
814 
815         uint256 amountETH = address(this).balance.sub(balanceBefore);
816 
817         uint256 totalETHFee = swapTotalFee.sub(dynamicLiquidityFee.div(2));
818 
819         uint256 amountETHLiquidity = amountETH.mul(swapLpFee).div(totalETHFee).div(2);
820         uint256 amountETHMarketing = amountETH.mul(swapMarketing).div(totalETHFee);
821         uint256 amountETHTreasury = amountETH.mul(swapTreasuryFee).div(totalETHFee);
822 
823         (bool tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 30000}("");
824         (tmpSuccess,) = payable(devWallet).call{value: amountETHTreasury, gas: 30000}("");
825 
826         // Supress warning msg
827         tmpSuccess = false;
828 
829         if(amountToLiquify > 0){
830             contractRouter.addLiquidityETH{value: amountETHLiquidity}(
831                 address(this),
832                 amountToLiquify,
833                 0,
834                 0,
835                 autoLiquidityReceiver,
836                 block.timestamp
837             );
838             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
839         }
840     }
841 
842 // *** 
843 // Various exempt functions
844 // *** 
845 
846     function setIsFeeExempt(address holder, bool exempt) external onlyOwner() {
847         isFeeExempt[holder] = exempt;
848     }
849 
850     function setIsMaxExempt(address holder, bool exempt) external onlyOwner() {
851         isMaxExempt[holder] = exempt;
852     }
853 
854     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner() {
855         isTxLimitExempt[holder] = exempt;
856     }
857 
858     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner() {
859         isTimelockExempt[holder] = exempt;
860     }
861 
862 // *** 
863 // End various exempt functions
864 // *** 
865 
866 
867 // ***
868 // Start fee things
869 // ***
870 
871     function setTransFee(uint256 fee) external onlyOwner() {
872         transFee = fee;
873     }
874 
875     function setSwapFees(uint256 _newSwapLpFee, uint256 _newSwapMarketingFee, uint256 _newSwapTreasuryFee, uint256 _feeDenominator) external onlyOwner() {
876         swapLpFee = _newSwapLpFee;
877         swapMarketing = _newSwapMarketingFee;
878         swapTreasuryFee = _newSwapTreasuryFee;
879         swapTotalFee = _newSwapLpFee.add(_newSwapMarketingFee).add(_newSwapTreasuryFee);
880         feeDenominator = _feeDenominator;
881         require(swapTotalFee < 90, "Fees cannot be that high");
882     }
883 
884     function setBuyFees(uint256 buyTax) external onlyOwner() {
885         buyTotalFee = buyTax;
886     }
887 
888 // ***
889 // end fee stuff§2e sw. 
890 // ***
891 
892 
893 
894     function setTreasuryFeeReceiver(address _newWallet) external onlyOwner() {
895         isFeeExempt[devWallet] = false;
896         isFeeExempt[_newWallet] = true;
897         devWallet = _newWallet;
898     }
899 
900     function setMarketingWallet(address _newWallet) external onlyOwner() {
901         isFeeExempt[marketingWallet] = false;
902         isFeeExempt[_newWallet] = true;
903 
904         isMaxExempt[_newWallet] = true;
905 
906         marketingWallet = _newWallet;
907     }
908 
909     function setFeeReceivers(address _autoLiquidityReceiver, address _newMarketingWallet, address _newdevWallet ) external onlyOwner() {
910 
911         isFeeExempt[devWallet] = false;
912         isFeeExempt[_newdevWallet] = true;
913         isFeeExempt[marketingWallet] = false;
914         isFeeExempt[_newMarketingWallet] = true;
915 
916         isMaxExempt[_newMarketingWallet] = true;
917 
918         autoLiquidityReceiver = _autoLiquidityReceiver;
919         marketingWallet = _newMarketingWallet;
920         devWallet = _newdevWallet;
921     }
922 
923 // ***
924 // Swap settings
925 // ***
926 
927     function setSwapThresholdAmount(uint256 _amount) external onlyOwner() {
928         swapThreshold = _amount;
929     }
930 
931     function setSwapAmount(uint256 _amount) external onlyOwner() {
932         if(_amount > swapThreshold) {
933             swapAmount = swapThreshold;
934         } else {
935             swapAmount = _amount;
936         }        
937     }
938 
939 // ***
940 // End Swap settings
941 // ***
942 
943     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner() {
944         targetLiquidity = _target;
945         targetLiquidityDenominator = _denominator;
946     }
947 
948     function getCirculatingSupply() public view returns (uint256) {
949         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
950     }
951 
952     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
953         return accuracy.mul(balanceOf(uniswapV2Pair).mul(2)).div(getCirculatingSupply());
954     }
955 
956     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
957         return getLiquidityBacking(accuracy) > target;
958     }
959 
960     /* Airdrop */
961     function airDropCustom(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
962 
963         require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
964         require(addresses.length == tokens.length,"Mismatch between Address and token count");
965 
966         uint256 SCCC = 0;
967 
968         for(uint i=0; i < addresses.length; i++){
969             SCCC = SCCC + tokens[i];
970         }
971 
972         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
973 
974         for(uint i=0; i < addresses.length; i++){
975             _basicTransfer(from,addresses[i],tokens[i]);
976         }
977         
978     }
979 
980     function airDropFixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
981 
982         require(addresses.length < 801,"GAS Error: max airdrop limit is 800 addresses");
983 
984         uint256 SCCC = tokens * addresses.length;
985 
986         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
987 
988         for(uint i=0; i < addresses.length; i++){
989             _basicTransfer(from,addresses[i],tokens);
990         }
991     }
992 
993     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
994 
995 }