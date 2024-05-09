1 /**
2 
3 */
4 
5 /**
6 
7 
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 /**
14  
15 */
16 
17 
18 pragma solidity ^0.8.17;
19 
20 /**
21  * Abstract contract to easily change things when deploying new projects. Saves me having to find it everywhere.
22  */
23 abstract contract Project {
24     address public marketingWallet = 0x38CF467010001315E9760D652BaaB1370D3db2C5;
25     address public devWallet = 0x38CF467010001315E9760D652BaaB1370D3db2C5;
26 
27     string constant _name = "GoogleAI";
28     string constant _symbol = "GAI";
29     uint8 constant _decimals = 9;
30 
31     uint256 _totalSupply = 1 * 10**6 * 10**_decimals;
32 
33     uint256 public _maxTxAmount = (_totalSupply * 40) / 1000; // (_totalSupply * 10) / 1000 [this equals 1%]
34     uint256 public _maxWalletToken = (_totalSupply * 40) / 1000; //
35 
36     uint256 public buyFee             = 50;
37     uint256 public buyTotalFee        = buyFee;
38 
39     uint256 public swapLpFee          = 1;
40     uint256 public swapMarketing      = 39;
41     uint256 public swapTreasuryFee    = 0;
42     uint256 public swapTotalFee       = swapMarketing + swapLpFee + swapTreasuryFee;
43 
44     uint256 public transFee           = 5;
45 
46     uint256 public feeDenominator     = 100;
47 
48 }
49 
50 /**
51  * @dev Wrappers over Solidity's arithmetic operations.
52  *
53  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
54  * now has built in overflow checking.
55  */
56 library SafeMath {
57 
58     /**
59      * @dev Returns the addition of two unsigned integers, reverting on
60      * overflow.
61      *
62      * Counterpart to Solidity's `+` operator.
63      *
64      * Requirements:
65      *
66      * - Addition cannot overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         return a + b;
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      *
80      * - Subtraction cannot overflow.
81      */
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return a - b;
84     }
85 
86     /**
87      * @dev Returns the multiplication of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `*` operator.
91      *
92      * Requirements:
93      *
94      * - Multiplication cannot overflow.
95      */
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a * b;
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers, reverting on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator.
105      *
106      * Requirements:
107      *
108      * - The divisor cannot be zero.
109      */
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a / b;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * reverting when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a % b;
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * CAUTION: This function is deprecated because it requires allocating memory for the error
135      * message unnecessarily. For custom revert reasons use {trySub}.
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(
144         uint256 a,
145         uint256 b,
146         string memory errorMessage
147     ) internal pure returns (uint256) {
148         unchecked {
149             require(b <= a, errorMessage);
150             return a - b;
151         }
152     }
153 
154     /**
155      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
156      * division by zero. The result is rounded towards zero.
157      *
158      * Counterpart to Solidity's `/` operator. Note: this function uses a
159      * `revert` opcode (which leaves remaining gas untouched) while Solidity
160      * uses an invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function div(
167         uint256 a,
168         uint256 b,
169         string memory errorMessage
170     ) internal pure returns (uint256) {
171         unchecked {
172             require(b > 0, errorMessage);
173             return a / b;
174         }
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * reverting with custom message when dividing by zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryMod}.
183      *
184      * Counterpart to Solidity's `%` operator. This function uses a `revert`
185      * opcode (which leaves remaining gas untouched) while Solidity uses an
186      * invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function mod(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a % b;
200         }
201     }
202 }
203 
204 interface IERC20 {
205     function totalSupply() external view returns (uint256);
206     function decimals() external view returns (uint8);
207     function symbol() external view returns (string memory);
208     function name() external view returns (string memory);
209     function getOwner() external view returns (address);
210     function balanceOf(address account) external view returns (uint256);
211     function transfer(address recipient, uint256 amount) external returns (bool);
212     function allowance(address _owner, address spender) external view returns (uint256);
213     function approve(address spender, uint256 amount) external returns (bool);
214     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
215     event Transfer(address indexed from, address indexed to, uint256 value);
216     event Approval(address indexed owner, address indexed spender, uint256 value);
217 }
218 
219 abstract contract Context {
220     //function _msgSender() internal view virtual returns (address payable) {
221     function _msgSender() internal view virtual returns (address) {
222         return msg.sender;
223     }
224 
225     function _msgData() internal view virtual returns (bytes memory) {
226         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
227         return msg.data;
228     }
229 }
230 
231 
232 /**
233  * @dev Contract module which provides a basic access control mechanism, where
234  * there is an account (an owner) that can be granted exclusive access to
235  * specific functions.
236  *
237  * By default, the owner account will be the one that deploys the contract. This
238  * can later be changed with {transferOwnership}.
239  *
240  * This module is used through inheritance. It will make available the modifier
241  * `onlyOwner`, which can be applied to your functions to restrict their use to
242  * the owner.
243  */
244 contract Ownable is Context {
245     address private _owner;
246     address private _previousOwner;
247     uint256 private _lockTime;
248 
249     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
250 
251     /**
252      * @dev Initializes the contract setting the deployer as the initial owner.
253      */
254     constructor () {
255         address msgSender = _msgSender();
256         _owner = msgSender;
257         emit OwnershipTransferred(address(0), msgSender);
258     }
259 
260     /**
261      * @dev Returns the address of the current owner.
262      */
263     function owner() public view returns (address) {
264         return _owner;
265     }
266 
267     /**
268      * @dev Throws if called by any account other than the owner.
269      */
270     modifier onlyOwner() {
271         require(_owner == _msgSender(), "Ownable: caller is not the owner");
272         _;
273     }
274 
275      /**
276      * @dev Leaves the contract without owner. It will not be possible to call
277      * `onlyOwner` functions anymore. Can only be called by the current owner.
278      *
279      * NOTE: Renouncing ownership will leave the contract without an owner,
280      * thereby removing any functionality that is only available to the owner.
281      */
282     function renounceOwnership() public virtual onlyOwner {
283         emit OwnershipTransferred(_owner, address(0));
284         _owner = address(0);
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Can only be called by the current owner.
290      */
291     function transferOwnership(address newOwner) public virtual onlyOwner {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         emit OwnershipTransferred(_owner, newOwner);
294         _owner = newOwner;
295     }
296 
297     function geUnlockTime() public view returns (uint256) {
298         return _lockTime;
299     }
300 
301     //Locks the contract for owner for the amount of time provided
302     function lock(uint256 time) public virtual onlyOwner {
303         _previousOwner = _owner;
304         _owner = address(0);
305         _lockTime = block.timestamp + time;
306         emit OwnershipTransferred(_owner, address(0));
307     }
308     
309     //Unlocks the contract for owner when _lockTime is exceeds
310     function unlock() public virtual {
311         require(_previousOwner == msg.sender, "You don't have permission to unlock");
312         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
313         emit OwnershipTransferred(_owner, _previousOwner);
314         _owner = _previousOwner;
315     }
316 }
317 
318 
319 interface IUniswapV2Factory {
320     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
321 
322     function feeTo() external view returns (address);
323     function feeToSetter() external view returns (address);
324 
325     function getPair(address tokenA, address tokenB) external view returns (address pair);
326     function allPairs(uint) external view returns (address pair);
327     function allPairsLength() external view returns (uint);
328 
329     function createPair(address tokenA, address tokenB) external returns (address pair);
330 
331     function setFeeTo(address) external;
332     function setFeeToSetter(address) external;
333 }
334 
335 
336 
337 interface IUniswapV2Pair {
338     event Approval(address indexed owner, address indexed spender, uint value);
339     event Transfer(address indexed from, address indexed to, uint value);
340 
341     function name() external pure returns (string memory);
342     function symbol() external pure returns (string memory);
343     function decimals() external pure returns (uint8);
344     function totalSupply() external view returns (uint);
345     function balanceOf(address owner) external view returns (uint);
346     function allowance(address owner, address spender) external view returns (uint);
347 
348     function approve(address spender, uint value) external returns (bool);
349     function transfer(address to, uint value) external returns (bool);
350     function transferFrom(address from, address to, uint value) external returns (bool);
351 
352     function DOMAIN_SEPARATOR() external view returns (bytes32);
353     function PERMIT_TYPEHASH() external pure returns (bytes32);
354     function nonces(address owner) external view returns (uint);
355 
356     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
357 
358     event Mint(address indexed sender, uint amount0, uint amount1);
359     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
360     event Swap(
361         address indexed sender,
362         uint amount0In,
363         uint amount1In,
364         uint amount0Out,
365         uint amount1Out,
366         address indexed to
367     );
368     event Sync(uint112 reserve0, uint112 reserve1);
369 
370     function MINIMUM_LIQUIDITY() external pure returns (uint);
371     function factory() external view returns (address);
372     function token0() external view returns (address);
373     function token1() external view returns (address);
374     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
375     function price0CumulativeLast() external view returns (uint);
376     function price1CumulativeLast() external view returns (uint);
377     function kLast() external view returns (uint);
378 
379     function mint(address to) external returns (uint liquidity);
380     function burn(address to) external returns (uint amount0, uint amount1);
381     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
382     function skim(address to) external;
383     function sync() external;
384 
385     function initialize(address, address) external;
386 }
387 
388 
389 interface IUniswapV2Router01 {
390     function factory() external pure returns (address);
391     function WETH() external pure returns (address);
392 
393     function addLiquidity(
394         address tokenA,
395         address tokenB,
396         uint amountADesired,
397         uint amountBDesired,
398         uint amountAMin,
399         uint amountBMin,
400         address to,
401         uint deadline
402     ) external returns (uint amountA, uint amountB, uint liquidity);
403     function addLiquidityETH(
404         address token,
405         uint amountTokenDesired,
406         uint amountTokenMin,
407         uint amountETHMin,
408         address to,
409         uint deadline
410     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
411     function removeLiquidity(
412         address tokenA,
413         address tokenB,
414         uint liquidity,
415         uint amountAMin,
416         uint amountBMin,
417         address to,
418         uint deadline
419     ) external returns (uint amountA, uint amountB);
420     function removeLiquidityETH(
421         address token,
422         uint liquidity,
423         uint amountTokenMin,
424         uint amountETHMin,
425         address to,
426         uint deadline
427     ) external returns (uint amountToken, uint amountETH);
428     function removeLiquidityWithPermit(
429         address tokenA,
430         address tokenB,
431         uint liquidity,
432         uint amountAMin,
433         uint amountBMin,
434         address to,
435         uint deadline,
436         bool approveMax, uint8 v, bytes32 r, bytes32 s
437     ) external returns (uint amountA, uint amountB);
438     function removeLiquidityETHWithPermit(
439         address token,
440         uint liquidity,
441         uint amountTokenMin,
442         uint amountETHMin,
443         address to,
444         uint deadline,
445         bool approveMax, uint8 v, bytes32 r, bytes32 s
446     ) external returns (uint amountToken, uint amountETH);
447     function swapExactTokensForTokens(
448         uint amountIn,
449         uint amountOutMin,
450         address[] calldata path,
451         address to,
452         uint deadline
453     ) external returns (uint[] memory amounts);
454     function swapTokensForExactTokens(
455         uint amountOut,
456         uint amountInMax,
457         address[] calldata path,
458         address to,
459         uint deadline
460     ) external returns (uint[] memory amounts);
461     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
462         external
463         payable
464         returns (uint[] memory amounts);
465     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
466         external
467         returns (uint[] memory amounts);
468     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
469         external
470         returns (uint[] memory amounts);
471     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
472         external
473         payable
474         returns (uint[] memory amounts);
475 
476     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
477     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
478     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
479     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
480     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
481 }
482 
483 
484 
485 
486 interface IUniswapV2Router02 is IUniswapV2Router01 {
487     function removeLiquidityETHSupportingFeeOnTransferTokens(
488         address token,
489         uint liquidity,
490         uint amountTokenMin,
491         uint amountETHMin,
492         address to,
493         uint deadline
494     ) external returns (uint amountETH);
495     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
496         address token,
497         uint liquidity,
498         uint amountTokenMin,
499         uint amountETHMin,
500         address to,
501         uint deadline,
502         bool approveMax, uint8 v, bytes32 r, bytes32 s
503     ) external returns (uint amountETH);
504 
505     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
506         uint amountIn,
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external;
512     function swapExactETHForTokensSupportingFeeOnTransferTokens(
513         uint amountOutMin,
514         address[] calldata path,
515         address to,
516         uint deadline
517     ) external payable;
518     function swapExactTokensForETHSupportingFeeOnTransferTokens(
519         uint amountIn,
520         uint amountOutMin,
521         address[] calldata path,
522         address to,
523         uint deadline
524     ) external;
525 }
526 
527 
528 /**
529  * MainContract
530  */
531 contract GoogleAI is Project, IERC20, Ownable {
532     using SafeMath for uint256;
533 
534     address DEAD = 0x000000000000000000000000000000000000dEaD;
535     address ZERO = 0x0000000000000000000000000000000000000000;
536 
537     mapping (address => uint256) _balances;
538     mapping (address => mapping (address => uint256)) _allowances;
539 
540     mapping (address => bool) isFeeExempt;
541     mapping (address => bool) isTxLimitExempt;
542     mapping (address => bool) isMaxExempt;
543     mapping (address => bool) isTimelockExempt;
544 
545     address public autoLiquidityReceiver;
546 
547     uint256 targetLiquidity = 20;
548     uint256 targetLiquidityDenominator = 100;
549 
550     IUniswapV2Router02 public immutable contractRouter;
551     address public immutable uniswapV2Pair;
552 
553     bool public tradingOpen = false;
554 
555     bool public buyCooldownEnabled = true;
556     uint8 public cooldownTimerInterval = 10;
557     mapping (address => uint) private cooldownTimer;
558 
559     bool public swapEnabled = true;
560     uint256 public swapThreshold = _totalSupply * 30 / 10000;
561     uint256 public swapAmount = _totalSupply * 30 / 10000;
562 
563     bool inSwap;
564     modifier swapping() { inSwap = true; _; inSwap = false; }
565 
566     constructor () {
567 
568         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
569          // Create a uniswap pair for this new token
570         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
571             .createPair(address(this), _uniswapV2Router.WETH());
572 
573         // set the rest of the contract variables
574         contractRouter = _uniswapV2Router;
575 
576         _allowances[address(this)][address(contractRouter)] = type(uint256).max;
577 
578         isFeeExempt[msg.sender] = true;
579         isTxLimitExempt[msg.sender] = true;
580         isMaxExempt[msg.sender] = true;
581 
582         isTimelockExempt[msg.sender] = true;
583         isTimelockExempt[DEAD] = true;
584         isTimelockExempt[address(this)] = true;
585 
586         isFeeExempt[marketingWallet] = true;
587         isMaxExempt[marketingWallet] = true;
588         isTxLimitExempt[marketingWallet] = true;
589 
590         autoLiquidityReceiver = msg.sender;
591 
592         _balances[msg.sender] = _totalSupply;
593         emit Transfer(address(0), msg.sender, _totalSupply);
594     }
595 
596     receive() external payable { }
597 
598     function totalSupply() external view override returns (uint256) { return _totalSupply; }
599     function decimals() external pure override returns (uint8) { return _decimals; }
600     function symbol() external pure override returns (string memory) { return _symbol; }
601     function name() external pure override returns (string memory) { return _name; }
602     function getOwner() external view override returns (address) { return owner(); }
603     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
604     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
605 
606     function approve(address spender, uint256 amount) public override returns (bool) {
607         _allowances[msg.sender][spender] = amount;
608         emit Approval(msg.sender, spender, amount);
609         return true;
610     }
611 
612     function approveMax(address spender) external returns (bool) {
613         return approve(spender, type(uint256).max);
614     }
615 
616     function transfer(address recipient, uint256 amount) external override returns (bool) {
617         return _transferFrom(msg.sender, recipient, amount);
618     }
619 
620     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
621         if(_allowances[sender][msg.sender] != type(uint256).max){
622             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
623         }
624 
625         return _transferFrom(sender, recipient, amount);
626     }
627 
628     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
629         _maxWalletToken = (_totalSupply * maxWallPercent_base1000 ) / 1000;
630     }
631     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner() {
632         _maxTxAmount = (_totalSupply * maxTXPercentage_base1000 ) / 1000;
633     }
634 
635     function setTxLimit(uint256 amount) external onlyOwner() {
636         _maxTxAmount = amount;
637     }
638 
639 // *** 
640 // Functions for the burning mechanism 
641 // *** 
642 
643     /**
644     * Burn an amount of tokens for the current wallet (if they have enough)
645     */
646     function burnTokens(uint256 amount) external {
647         // does this user have enough tokens to perform the burn
648         if(_balances[msg.sender] > amount) {
649             _basicTransfer(msg.sender, DEAD, amount);
650         }
651     }
652 
653 
654 // *** 
655 // End functions for the burning mechanism 
656 // *** 
657 
658     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
659         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
660 
661         if(sender != owner() && recipient != owner()){
662             require(tradingOpen,"Trading not open yet");
663         }
664 
665         bool inSell = (recipient == uniswapV2Pair);
666         bool inTransfer = (recipient != uniswapV2Pair && sender != uniswapV2Pair);
667 
668         if (recipient != address(this) && 
669             recipient != address(DEAD) && 
670             recipient != uniswapV2Pair && 
671             recipient != marketingWallet && 
672             recipient != devWallet && 
673             recipient != autoLiquidityReceiver
674         ){
675             uint256 heldTokens = balanceOf(recipient);
676             if(!isMaxExempt[recipient]) {
677                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
678             }
679         }
680 
681         if (sender == uniswapV2Pair &&
682             buyCooldownEnabled &&
683             !isTimelockExempt[recipient]
684         ){
685             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two buys");
686             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
687         }
688 
689         // Checks max transaction limit
690         // but no point if the recipient is exempt
691         // this check ensures that someone that is buying and is txnExempt then they are able to buy any amount
692         if(!isTxLimitExempt[recipient]) {
693             checkTxLimit(sender, amount);
694         }
695 
696         //Exchange tokens
697         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
698 
699         uint256 amountReceived = amount;
700 
701         // Do NOT take a fee if sender AND recipient are NOT the contract
702         // i.e. you are doing a transfer
703         if(inTransfer) {
704             if(transFee > 0) {
705                 amountReceived = takeTransferFee(sender, amount);
706             }
707         } else {
708             amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount, inSell) : amount;
709             
710             if(shouldSwapBack()){ swapBack(); }
711         }
712 
713         _balances[recipient] = _balances[recipient].add(amountReceived);
714 
715         emit Transfer(sender, recipient, amountReceived);
716         return true;
717     }
718 
719     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
720         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
721         _balances[recipient] = _balances[recipient].add(amount);
722         emit Transfer(sender, recipient, amount);
723         return true;
724     }
725 
726     function checkTxLimit(address sender, uint256 amount) internal view {
727         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
728     }
729 
730     function shouldTakeFee(address sender) internal view returns (bool) {
731         return !isFeeExempt[sender];
732     }
733 
734 // *** 
735 // Handle Fees
736 // *** 
737 
738     function takeTransferFee(address sender, uint256 amount) internal returns (uint256) {
739 
740         uint256 feeToTake = transFee;
741         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
742         
743         _balances[address(this)] = _balances[address(this)].add(feeAmount);
744         emit Transfer(sender, address(this), feeAmount);
745 
746         return amount.sub(feeAmount);
747     }
748 
749     function takeFee(address sender, uint256 amount, bool isSell) internal returns (uint256) {
750 
751         uint256 feeToTake = isSell ? swapTotalFee : buyTotalFee;
752         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
753         
754         _balances[address(this)] = _balances[address(this)].add(feeAmount);
755         emit Transfer(sender, address(this), feeAmount);
756 
757         return amount.sub(feeAmount);
758     }
759 
760 // *** 
761 // End Handle Fees
762 // *** 
763 
764     function shouldSwapBack() internal view returns (bool) {
765         return msg.sender != uniswapV2Pair
766         && !inSwap
767         && swapEnabled
768         && _balances[address(this)] >= swapThreshold;
769     }
770 
771     function clearStuckBalance(uint256 amountPercentage) external onlyOwner() {
772         uint256 amountETH = address(this).balance;
773         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
774     }
775 
776     function clearStuckBalance_sender(uint256 amountPercentage) external onlyOwner() {
777         uint256 amountETH = address(this).balance;
778         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
779     }
780 
781     // switch Trading
782     function tradingStatus(bool _status) public onlyOwner {
783         tradingOpen = _status;
784     }
785 
786     // enable cooldown between trades
787     function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
788         buyCooldownEnabled = _status;
789         cooldownTimerInterval = _interval;
790     }
791 
792     function swapBack() internal swapping {
793         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : swapLpFee;
794         uint256 amountToLiquify = swapAmount.mul(dynamicLiquidityFee).div(swapTotalFee).div(2);
795         uint256 amountToSwap = swapAmount.sub(amountToLiquify);
796 
797         address[] memory path = new address[](2);
798         path[0] = address(this);
799         path[1] = contractRouter.WETH();
800 
801         uint256 balanceBefore = address(this).balance;
802 
803         contractRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
804             amountToSwap,
805             0,
806             path,
807             address(this),
808             block.timestamp
809         );
810 
811         uint256 amountETH = address(this).balance.sub(balanceBefore);
812 
813         uint256 totalETHFee = swapTotalFee.sub(dynamicLiquidityFee.div(2));
814 
815         uint256 amountETHLiquidity = amountETH.mul(swapLpFee).div(totalETHFee).div(2);
816         uint256 amountETHMarketing = amountETH.mul(swapMarketing).div(totalETHFee);
817         uint256 amountETHTreasury = amountETH.mul(swapTreasuryFee).div(totalETHFee);
818 
819         (bool tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 30000}("");
820         (tmpSuccess,) = payable(devWallet).call{value: amountETHTreasury, gas: 30000}("");
821 
822         // Supress warning msg
823         tmpSuccess = false;
824 
825         if(amountToLiquify > 0){
826             contractRouter.addLiquidityETH{value: amountETHLiquidity}(
827                 address(this),
828                 amountToLiquify,
829                 0,
830                 0,
831                 autoLiquidityReceiver,
832                 block.timestamp
833             );
834             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
835         }
836     }
837 
838 // *** 
839 // Various exempt functions
840 // *** 
841 
842     function setIsFeeExempt(address holder, bool exempt) external onlyOwner() {
843         isFeeExempt[holder] = exempt;
844     }
845 
846     function setIsMaxExempt(address holder, bool exempt) external onlyOwner() {
847         isMaxExempt[holder] = exempt;
848     }
849 
850     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner() {
851         isTxLimitExempt[holder] = exempt;
852     }
853 
854     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner() {
855         isTimelockExempt[holder] = exempt;
856     }
857 
858 // *** 
859 // End various exempt functions
860 // *** 
861 
862 
863 // ***
864 // Start fee things
865 // ***
866 
867     function setTransFee(uint256 fee) external onlyOwner() {
868         transFee = fee;
869     }
870 
871     function setSwapFees(uint256 _newSwapLpFee, uint256 _newSwapMarketingFee, uint256 _newSwapTreasuryFee, uint256 _feeDenominator) external onlyOwner() {
872         swapLpFee = _newSwapLpFee;
873         swapMarketing = _newSwapMarketingFee;
874         swapTreasuryFee = _newSwapTreasuryFee;
875         swapTotalFee = _newSwapLpFee.add(_newSwapMarketingFee).add(_newSwapTreasuryFee);
876         feeDenominator = _feeDenominator;
877         require(swapTotalFee < 90, "Fees cannot be that high");
878     }
879 
880     function setBuyFees(uint256 buyTax) external onlyOwner() {
881         buyTotalFee = buyTax;
882     }
883 
884 // ***
885 // end fee stuff§2e sw. 
886 // ***
887 
888 
889 
890     function setTreasuryFeeReceiver(address _newWallet) external onlyOwner() {
891         isFeeExempt[devWallet] = false;
892         isFeeExempt[_newWallet] = true;
893         devWallet = _newWallet;
894     }
895 
896     function setMarketingWallet(address _newWallet) external onlyOwner() {
897         isFeeExempt[marketingWallet] = false;
898         isFeeExempt[_newWallet] = true;
899 
900         isMaxExempt[_newWallet] = true;
901 
902         marketingWallet = _newWallet;
903     }
904 
905     function setFeeReceivers(address _autoLiquidityReceiver, address _newMarketingWallet, address _newdevWallet ) external onlyOwner() {
906 
907         isFeeExempt[devWallet] = false;
908         isFeeExempt[_newdevWallet] = true;
909         isFeeExempt[marketingWallet] = false;
910         isFeeExempt[_newMarketingWallet] = true;
911 
912         isMaxExempt[_newMarketingWallet] = true;
913 
914         autoLiquidityReceiver = _autoLiquidityReceiver;
915         marketingWallet = _newMarketingWallet;
916         devWallet = _newdevWallet;
917     }
918 
919 // ***
920 // Swap settings
921 // ***
922 
923     function setSwapThresholdAmount(uint256 _amount) external onlyOwner() {
924         swapThreshold = _amount;
925     }
926 
927     function setSwapAmount(uint256 _amount) external onlyOwner() {
928         if(_amount > swapThreshold) {
929             swapAmount = swapThreshold;
930         } else {
931             swapAmount = _amount;
932         }        
933     }
934 
935 // ***
936 // End Swap settings
937 // ***
938 
939     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner() {
940         targetLiquidity = _target;
941         targetLiquidityDenominator = _denominator;
942     }
943 
944     function getCirculatingSupply() public view returns (uint256) {
945         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
946     }
947 
948     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
949         return accuracy.mul(balanceOf(uniswapV2Pair).mul(2)).div(getCirculatingSupply());
950     }
951 
952     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
953         return getLiquidityBacking(accuracy) > target;
954     }
955 
956     /* Airdrop */
957     function airDropCustom(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
958 
959         require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
960         require(addresses.length == tokens.length,"Mismatch between Address and token count");
961 
962         uint256 SCCC = 0;
963 
964         for(uint i=0; i < addresses.length; i++){
965             SCCC = SCCC + tokens[i];
966         }
967 
968         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
969 
970         for(uint i=0; i < addresses.length; i++){
971             _basicTransfer(from,addresses[i],tokens[i]);
972         }
973         
974     }
975 
976     function airDropFixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
977 
978         require(addresses.length < 801,"GAS Error: max airdrop limit is 800 addresses");
979 
980         uint256 SCCC = tokens * addresses.length;
981 
982         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
983 
984         for(uint i=0; i < addresses.length; i++){
985             _basicTransfer(from,addresses[i],tokens);
986         }
987     }
988 
989     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
990 
991 }