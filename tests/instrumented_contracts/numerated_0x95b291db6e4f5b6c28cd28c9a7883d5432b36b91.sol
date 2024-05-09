1 /**
2 
3 TELEGRAM: https://t.me/WASFBCoin
4 
5 Dev wallet / Presale addy: WASFB.eth
6 
7 
8 
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 
14 /**
15  
16 */
17 
18 
19 pragma solidity ^0.8.17;
20 
21 /**
22  *
23  */
24 abstract contract Project {
25     address public marketingWallet = 0xD61aEa3A0Bf5ba826dAEEB3c6C4be47d560402E1;
26     address public devWallet = 0xD61aEa3A0Bf5ba826dAEEB3c6C4be47d560402E1;
27 
28     string constant _name = "We Are So Fucking Back";
29     string constant _symbol = "WASFB";
30     uint8 constant _decimals = 9;
31 
32     uint256 _totalSupply = 1 * 1000**6 * 10**_decimals;
33 
34     uint256 public _maxTxAmount = (_totalSupply * 10) / 1000; // (_totalSupply * 10) / 1000 [this equals 1%]
35     uint256 public _maxWalletToken = (_totalSupply * 1000) / 1000; //
36 
37     uint256 public buyFee             = 6;
38     uint256 public buyTotalFee        = buyFee;
39 
40     uint256 public swapLpFee          = 1;
41     uint256 public swapMarketing      = 5;
42     uint256 public swapTreasuryFee    = 0;
43     uint256 public swapTotalFee       = swapMarketing + swapLpFee + swapTreasuryFee;
44 
45     uint256 public transFee           = 0;
46 
47     uint256 public feeDenominator     = 100;
48 
49 }
50 
51 /**
52  * @dev Wrappers over Solidity's arithmetic operations.
53  *
54  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
55  * now has built in overflow checking.
56  */
57 library SafeMath {
58 
59     /**
60      * @dev Returns the addition of two unsigned integers, reverting on
61      * overflow.
62      *
63      * Counterpart to Solidity's `+` operator.
64      *
65      * Requirements:
66      *
67      * - Addition cannot overflow.
68      */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a + b;
71     }
72 
73     /**
74      * @dev Returns the subtraction of two unsigned integers, reverting on
75      * overflow (when the result is negative).
76      *
77      * Counterpart to Solidity's `-` operator.
78      *
79      * Requirements:
80      *
81      * - Subtraction cannot overflow.
82      */
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return a - b;
85     }
86 
87     /**
88      * @dev Returns the multiplication of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `*` operator.
92      *
93      * Requirements:
94      *
95      * - Multiplication cannot overflow.
96      */
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a * b;
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers, reverting on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator.
106      *
107      * Requirements:
108      *
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a / b;
113     }
114 
115     /**
116      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
117      * reverting when dividing by zero.
118      *
119      * Counterpart to Solidity's `%` operator. This function uses a `revert`
120      * opcode (which leaves remaining gas untouched) while Solidity uses an
121      * invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      *
125      * - The divisor cannot be zero.
126      */
127     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a % b;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * CAUTION: This function is deprecated because it requires allocating memory for the error
136      * message unnecessarily. For custom revert reasons use {trySub}.
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(
145         uint256 a,
146         uint256 b,
147         string memory errorMessage
148     ) internal pure returns (uint256) {
149         unchecked {
150             require(b <= a, errorMessage);
151             return a - b;
152         }
153     }
154 
155     /**
156      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
157      * division by zero. The result is rounded towards zero.
158      *
159      * Counterpart to Solidity's `/` operator. Note: this function uses a
160      * `revert` opcode (which leaves remaining gas untouched) while Solidity
161      * uses an invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      *
165      * - The divisor cannot be zero.
166      */
167     function div(
168         uint256 a,
169         uint256 b,
170         string memory errorMessage
171     ) internal pure returns (uint256) {
172         unchecked {
173             require(b > 0, errorMessage);
174             return a / b;
175         }
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * reverting with custom message when dividing by zero.
181      *
182      * CAUTION: This function is deprecated because it requires allocating memory for the error
183      * message unnecessarily. For custom revert reasons use {tryMod}.
184      *
185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
186      * opcode (which leaves remaining gas untouched) while Solidity uses an
187      * invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function mod(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a % b;
201         }
202     }
203 }
204 
205 interface IERC20 {
206     function totalSupply() external view returns (uint256);
207     function decimals() external view returns (uint8);
208     function symbol() external view returns (string memory);
209     function name() external view returns (string memory);
210     function getOwner() external view returns (address);
211     function balanceOf(address account) external view returns (uint256);
212     function transfer(address recipient, uint256 amount) external returns (bool);
213     function allowance(address _owner, address spender) external view returns (uint256);
214     function approve(address spender, uint256 amount) external returns (bool);
215     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
216     event Transfer(address indexed from, address indexed to, uint256 value);
217     event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 abstract contract Context {
221     //function _msgSender() internal view virtual returns (address payable) {
222     function _msgSender() internal view virtual returns (address) {
223         return msg.sender;
224     }
225 
226     function _msgData() internal view virtual returns (bytes memory) {
227         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
228         return msg.data;
229     }
230 }
231 
232 
233 /**
234  * @dev Contract module which provides a basic access control mechanism, where
235  * there is an account (an owner) that can be granted exclusive access to
236  * specific functions.
237  *
238  * By default, the owner account will be the one that deploys the contract. This
239  * can later be changed with {transferOwnership}.
240  *
241  * This module is used through inheritance. It will make available the modifier
242  * `onlyOwner`, which can be applied to your functions to restrict their use to
243  * the owner.
244  */
245 contract Ownable is Context {
246     address private _owner;
247     address private _previousOwner;
248     uint256 private _lockTime;
249 
250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
251 
252     /**
253      * @dev Initializes the contract setting the deployer as the initial owner.
254      */
255     constructor () {
256         address msgSender = _msgSender();
257         _owner = msgSender;
258         emit OwnershipTransferred(address(0), msgSender);
259     }
260 
261     /**
262      * @dev Returns the address of the current owner.
263      */
264     function owner() public view returns (address) {
265         return _owner;
266     }
267 
268     /**
269      * @dev Throws if called by any account other than the owner.
270      */
271     modifier onlyOwner() {
272         require(_owner == _msgSender(), "Ownable: caller is not the owner");
273         _;
274     }
275 
276      /**
277      * @dev Leaves the contract without owner. It will not be possible to call
278      * `onlyOwner` functions anymore. Can only be called by the current owner.
279      *
280      * NOTE: Renouncing ownership will leave the contract without an owner,
281      * thereby removing any functionality that is only available to the owner.
282      */
283     function renounceOwnership() public virtual onlyOwner {
284         emit OwnershipTransferred(_owner, address(0));
285         _owner = address(0);
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      * Can only be called by the current owner.
291      */
292     function transferOwnership(address newOwner) public virtual onlyOwner {
293         require(newOwner != address(0), "Ownable: new owner is the zero address");
294         emit OwnershipTransferred(_owner, newOwner);
295         _owner = newOwner;
296     }
297 
298     function geUnlockTime() public view returns (uint256) {
299         return _lockTime;
300     }
301 
302     //Locks the contract for owner for the amount of time provided
303     function lock(uint256 time) public virtual onlyOwner {
304         _previousOwner = _owner;
305         _owner = address(0);
306         _lockTime = block.timestamp + time;
307         emit OwnershipTransferred(_owner, address(0));
308     }
309     
310     //Unlocks the contract for owner when _lockTime is exceeds
311     function unlock() public virtual {
312         require(_previousOwner == msg.sender, "You don't have permission to unlock");
313         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
314         emit OwnershipTransferred(_owner, _previousOwner);
315         _owner = _previousOwner;
316     }
317 }
318 
319 
320 interface IUniswapV2Factory {
321     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
322 
323     function feeTo() external view returns (address);
324     function feeToSetter() external view returns (address);
325 
326     function getPair(address tokenA, address tokenB) external view returns (address pair);
327     function allPairs(uint) external view returns (address pair);
328     function allPairsLength() external view returns (uint);
329 
330     function createPair(address tokenA, address tokenB) external returns (address pair);
331 
332     function setFeeTo(address) external;
333     function setFeeToSetter(address) external;
334 }
335 
336 
337 
338 interface IUniswapV2Pair {
339     event Approval(address indexed owner, address indexed spender, uint value);
340     event Transfer(address indexed from, address indexed to, uint value);
341 
342     function name() external pure returns (string memory);
343     function symbol() external pure returns (string memory);
344     function decimals() external pure returns (uint8);
345     function totalSupply() external view returns (uint);
346     function balanceOf(address owner) external view returns (uint);
347     function allowance(address owner, address spender) external view returns (uint);
348 
349     function approve(address spender, uint value) external returns (bool);
350     function transfer(address to, uint value) external returns (bool);
351     function transferFrom(address from, address to, uint value) external returns (bool);
352 
353     function DOMAIN_SEPARATOR() external view returns (bytes32);
354     function PERMIT_TYPEHASH() external pure returns (bytes32);
355     function nonces(address owner) external view returns (uint);
356 
357     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
358 
359     event Mint(address indexed sender, uint amount0, uint amount1);
360     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
361     event Swap(
362         address indexed sender,
363         uint amount0In,
364         uint amount1In,
365         uint amount0Out,
366         uint amount1Out,
367         address indexed to
368     );
369     event Sync(uint112 reserve0, uint112 reserve1);
370 
371     function MINIMUM_LIQUIDITY() external pure returns (uint);
372     function factory() external view returns (address);
373     function token0() external view returns (address);
374     function token1() external view returns (address);
375     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
376     function price0CumulativeLast() external view returns (uint);
377     function price1CumulativeLast() external view returns (uint);
378     function kLast() external view returns (uint);
379 
380     function mint(address to) external returns (uint liquidity);
381     function burn(address to) external returns (uint amount0, uint amount1);
382     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
383     function skim(address to) external;
384     function sync() external;
385 
386     function initialize(address, address) external;
387 }
388 
389 
390 interface IUniswapV2Router01 {
391     function factory() external pure returns (address);
392     function WETH() external pure returns (address);
393 
394     function addLiquidity(
395         address tokenA,
396         address tokenB,
397         uint amountADesired,
398         uint amountBDesired,
399         uint amountAMin,
400         uint amountBMin,
401         address to,
402         uint deadline
403     ) external returns (uint amountA, uint amountB, uint liquidity);
404     function addLiquidityETH(
405         address token,
406         uint amountTokenDesired,
407         uint amountTokenMin,
408         uint amountETHMin,
409         address to,
410         uint deadline
411     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
412     function removeLiquidity(
413         address tokenA,
414         address tokenB,
415         uint liquidity,
416         uint amountAMin,
417         uint amountBMin,
418         address to,
419         uint deadline
420     ) external returns (uint amountA, uint amountB);
421     function removeLiquidityETH(
422         address token,
423         uint liquidity,
424         uint amountTokenMin,
425         uint amountETHMin,
426         address to,
427         uint deadline
428     ) external returns (uint amountToken, uint amountETH);
429     function removeLiquidityWithPermit(
430         address tokenA,
431         address tokenB,
432         uint liquidity,
433         uint amountAMin,
434         uint amountBMin,
435         address to,
436         uint deadline,
437         bool approveMax, uint8 v, bytes32 r, bytes32 s
438     ) external returns (uint amountA, uint amountB);
439     function removeLiquidityETHWithPermit(
440         address token,
441         uint liquidity,
442         uint amountTokenMin,
443         uint amountETHMin,
444         address to,
445         uint deadline,
446         bool approveMax, uint8 v, bytes32 r, bytes32 s
447     ) external returns (uint amountToken, uint amountETH);
448     function swapExactTokensForTokens(
449         uint amountIn,
450         uint amountOutMin,
451         address[] calldata path,
452         address to,
453         uint deadline
454     ) external returns (uint[] memory amounts);
455     function swapTokensForExactTokens(
456         uint amountOut,
457         uint amountInMax,
458         address[] calldata path,
459         address to,
460         uint deadline
461     ) external returns (uint[] memory amounts);
462     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
463         external
464         payable
465         returns (uint[] memory amounts);
466     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
467         external
468         returns (uint[] memory amounts);
469     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
470         external
471         returns (uint[] memory amounts);
472     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
473         external
474         payable
475         returns (uint[] memory amounts);
476 
477     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
478     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
479     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
480     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
481     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
482 }
483 
484 
485 
486 
487 interface IUniswapV2Router02 is IUniswapV2Router01 {
488     function removeLiquidityETHSupportingFeeOnTransferTokens(
489         address token,
490         uint liquidity,
491         uint amountTokenMin,
492         uint amountETHMin,
493         address to,
494         uint deadline
495     ) external returns (uint amountETH);
496     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
497         address token,
498         uint liquidity,
499         uint amountTokenMin,
500         uint amountETHMin,
501         address to,
502         uint deadline,
503         bool approveMax, uint8 v, bytes32 r, bytes32 s
504     ) external returns (uint amountETH);
505 
506     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
507         uint amountIn,
508         uint amountOutMin,
509         address[] calldata path,
510         address to,
511         uint deadline
512     ) external;
513     function swapExactETHForTokensSupportingFeeOnTransferTokens(
514         uint amountOutMin,
515         address[] calldata path,
516         address to,
517         uint deadline
518     ) external payable;
519     function swapExactTokensForETHSupportingFeeOnTransferTokens(
520         uint amountIn,
521         uint amountOutMin,
522         address[] calldata path,
523         address to,
524         uint deadline
525     ) external;
526 }
527 
528 
529 /**
530  * MainContract
531  */
532 contract WASFBContract is Project, IERC20, Ownable {
533     using SafeMath for uint256;
534 
535     address DEAD = 0x000000000000000000000000000000000000dEaD;
536     address ZERO = 0x0000000000000000000000000000000000000000;
537 
538     mapping (address => uint256) _balances;
539     mapping (address => mapping (address => uint256)) _allowances;
540 
541     mapping (address => bool) isFeeExempt;
542     mapping (address => bool) isTxLimitExempt;
543     mapping (address => bool) isMaxExempt;
544     mapping (address => bool) isTimelockExempt;
545 
546     address public autoLiquidityReceiver;
547 
548     uint256 targetLiquidity = 20;
549     uint256 targetLiquidityDenominator = 100;
550 
551     IUniswapV2Router02 public immutable contractRouter;
552     address public immutable uniswapV2Pair;
553 
554     bool public tradingOpen = false;
555 
556     bool public buyCooldownEnabled = true;
557     uint8 public cooldownTimerInterval = 10;
558     mapping (address => uint) private cooldownTimer;
559 
560     bool public swapEnabled = true;
561     uint256 public swapThreshold = _totalSupply * 30 / 10000;
562     uint256 public swapAmount = _totalSupply * 30 / 10000;
563 
564     bool inSwap;
565     modifier swapping() { inSwap = true; _; inSwap = false; }
566 
567     constructor () {
568 
569         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
570          // Create a uniswap pair for this new token
571         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
572             .createPair(address(this), _uniswapV2Router.WETH());
573 
574         // set the rest of the contract variables
575         contractRouter = _uniswapV2Router;
576 
577         _allowances[address(this)][address(contractRouter)] = type(uint256).max;
578 
579         isFeeExempt[msg.sender] = true;
580         isTxLimitExempt[msg.sender] = true;
581         isMaxExempt[msg.sender] = true;
582 
583         isTimelockExempt[msg.sender] = true;
584         isTimelockExempt[DEAD] = true;
585         isTimelockExempt[address(this)] = true;
586 
587         isFeeExempt[marketingWallet] = true;
588         isMaxExempt[marketingWallet] = true;
589         isTxLimitExempt[marketingWallet] = true;
590 
591         autoLiquidityReceiver = msg.sender;
592 
593         _balances[msg.sender] = _totalSupply;
594         emit Transfer(address(0), msg.sender, _totalSupply);
595     }
596 
597     receive() external payable { }
598 
599     function totalSupply() external view override returns (uint256) { return _totalSupply; }
600     function decimals() external pure override returns (uint8) { return _decimals; }
601     function symbol() external pure override returns (string memory) { return _symbol; }
602     function name() external pure override returns (string memory) { return _name; }
603     function getOwner() external view override returns (address) { return owner(); }
604     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
605     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
606 
607     function approve(address spender, uint256 amount) public override returns (bool) {
608         _allowances[msg.sender][spender] = amount;
609         emit Approval(msg.sender, spender, amount);
610         return true;
611     }
612 
613     function approveMax(address spender) external returns (bool) {
614         return approve(spender, type(uint256).max);
615     }
616 
617     function transfer(address recipient, uint256 amount) external override returns (bool) {
618         return _transferFrom(msg.sender, recipient, amount);
619     }
620 
621     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
622         if(_allowances[sender][msg.sender] != type(uint256).max){
623             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
624         }
625 
626         return _transferFrom(sender, recipient, amount);
627     }
628 
629     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
630         _maxWalletToken = (_totalSupply * maxWallPercent_base1000 ) / 1000;
631     }
632     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner() {
633         _maxTxAmount = (_totalSupply * maxTXPercentage_base1000 ) / 1000;
634     }
635 
636     function setTxLimit(uint256 amount) external onlyOwner() {
637         _maxTxAmount = amount;
638     }
639 
640 // *** 
641 // Functions for the burning mechanism 
642 // *** 
643 
644     /**
645     * Burn an amount of tokens for the current wallet (if they have enough)
646     */
647     function burnTokens(uint256 amount) external {
648         // does this user have enough tokens to perform the burn
649         if(_balances[msg.sender] > amount) {
650             _basicTransfer(msg.sender, DEAD, amount);
651         }
652     }
653 
654 
655 // *** 
656 // End functions for the burning mechanism 
657 // *** 
658 
659     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
660         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
661 
662         if(sender != owner() && recipient != owner()){
663             require(tradingOpen,"Trading not open yet");
664         }
665 
666         bool inSell = (recipient == uniswapV2Pair);
667         bool inTransfer = (recipient != uniswapV2Pair && sender != uniswapV2Pair);
668 
669         if (recipient != address(this) && 
670             recipient != address(DEAD) && 
671             recipient != uniswapV2Pair && 
672             recipient != marketingWallet && 
673             recipient != devWallet && 
674             recipient != autoLiquidityReceiver
675         ){
676             uint256 heldTokens = balanceOf(recipient);
677             if(!isMaxExempt[recipient]) {
678                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
679             }
680         }
681 
682         if (sender == uniswapV2Pair &&
683             buyCooldownEnabled &&
684             !isTimelockExempt[recipient]
685         ){
686             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two buys");
687             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
688         }
689 
690         // Checks max transaction limit
691         // but no point if the recipient is exempt
692         // this check ensures that someone that is buying and is txnExempt then they are able to buy any amount
693         if(!isTxLimitExempt[recipient]) {
694             checkTxLimit(sender, amount);
695         }
696 
697         //Exchange tokens
698         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
699 
700         uint256 amountReceived = amount;
701 
702         // Do NOT take a fee if sender AND recipient are NOT the contract
703         // i.e. you are doing a transfer
704         if(inTransfer) {
705             if(transFee > 0) {
706                 amountReceived = takeTransferFee(sender, amount);
707             }
708         } else {
709             amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount, inSell) : amount;
710             
711             if(shouldSwapBack()){ swapBack(); }
712         }
713 
714         _balances[recipient] = _balances[recipient].add(amountReceived);
715 
716         emit Transfer(sender, recipient, amountReceived);
717         return true;
718     }
719 
720     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
721         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
722         _balances[recipient] = _balances[recipient].add(amount);
723         emit Transfer(sender, recipient, amount);
724         return true;
725     }
726 
727     function checkTxLimit(address sender, uint256 amount) internal view {
728         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
729     }
730 
731     function shouldTakeFee(address sender) internal view returns (bool) {
732         return !isFeeExempt[sender];
733     }
734 
735 // *** 
736 // Handle Fees
737 // *** 
738 
739     function takeTransferFee(address sender, uint256 amount) internal returns (uint256) {
740 
741         uint256 feeToTake = transFee;
742         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
743         
744         _balances[address(this)] = _balances[address(this)].add(feeAmount);
745         emit Transfer(sender, address(this), feeAmount);
746 
747         return amount.sub(feeAmount);
748     }
749 
750     function takeFee(address sender, uint256 amount, bool isSell) internal returns (uint256) {
751 
752         uint256 feeToTake = isSell ? swapTotalFee : buyTotalFee;
753         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
754         
755         _balances[address(this)] = _balances[address(this)].add(feeAmount);
756         emit Transfer(sender, address(this), feeAmount);
757 
758         return amount.sub(feeAmount);
759     }
760 
761 // *** 
762 // End Handle Fees
763 // *** 
764 
765     function shouldSwapBack() internal view returns (bool) {
766         return msg.sender != uniswapV2Pair
767         && !inSwap
768         && swapEnabled
769         && _balances[address(this)] >= swapThreshold;
770     }
771 
772     function clearStuckBalance(uint256 amountPercentage) external onlyOwner() {
773         uint256 amountETH = address(this).balance;
774         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
775     }
776 
777     function clearStuckBalance_sender(uint256 amountPercentage) external onlyOwner() {
778         uint256 amountETH = address(this).balance;
779         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
780     }
781 
782     // switch Trading
783     function tradingStatus(bool _status) public onlyOwner {
784         tradingOpen = _status;
785     }
786 
787     // enable cooldown between trades
788     function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
789         buyCooldownEnabled = _status;
790         cooldownTimerInterval = _interval;
791     }
792 
793     function swapBack() internal swapping {
794         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : swapLpFee;
795         uint256 amountToLiquify = swapAmount.mul(dynamicLiquidityFee).div(swapTotalFee).div(2);
796         uint256 amountToSwap = swapAmount.sub(amountToLiquify);
797 
798         address[] memory path = new address[](2);
799         path[0] = address(this);
800         path[1] = contractRouter.WETH();
801 
802         uint256 balanceBefore = address(this).balance;
803 
804         contractRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
805             amountToSwap,
806             0,
807             path,
808             address(this),
809             block.timestamp
810         );
811 
812         uint256 amountETH = address(this).balance.sub(balanceBefore);
813 
814         uint256 totalETHFee = swapTotalFee.sub(dynamicLiquidityFee.div(2));
815 
816         uint256 amountETHLiquidity = amountETH.mul(swapLpFee).div(totalETHFee).div(2);
817         uint256 amountETHMarketing = amountETH.mul(swapMarketing).div(totalETHFee);
818         uint256 amountETHTreasury = amountETH.mul(swapTreasuryFee).div(totalETHFee);
819 
820         (bool tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 30000}("");
821         (tmpSuccess,) = payable(devWallet).call{value: amountETHTreasury, gas: 30000}("");
822 
823         // Supress warning msg
824         tmpSuccess = false;
825 
826         if(amountToLiquify > 0){
827             contractRouter.addLiquidityETH{value: amountETHLiquidity}(
828                 address(this),
829                 amountToLiquify,
830                 0,
831                 0,
832                 autoLiquidityReceiver,
833                 block.timestamp
834             );
835             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
836         }
837     }
838 
839 // *** 
840 // Various exempt functions
841 // *** 
842 
843     function setIsFeeExempt(address holder, bool exempt) external onlyOwner() {
844         isFeeExempt[holder] = exempt;
845     }
846 
847     function setIsMaxExempt(address holder, bool exempt) external onlyOwner() {
848         isMaxExempt[holder] = exempt;
849     }
850 
851     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner() {
852         isTxLimitExempt[holder] = exempt;
853     }
854 
855     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner() {
856         isTimelockExempt[holder] = exempt;
857     }
858 
859 // *** 
860 // End various exempt functions
861 // *** 
862 
863 
864 // ***
865 // Start fee things
866 // ***
867 
868     function setTransFee(uint256 fee) external onlyOwner() {
869         transFee = fee;
870     }
871 
872     function setSwapFees(uint256 _newSwapLpFee, uint256 _newSwapMarketingFee, uint256 _newSwapTreasuryFee, uint256 _feeDenominator) external onlyOwner() {
873         swapLpFee = _newSwapLpFee;
874         swapMarketing = _newSwapMarketingFee;
875         swapTreasuryFee = _newSwapTreasuryFee;
876         swapTotalFee = _newSwapLpFee.add(_newSwapMarketingFee).add(_newSwapTreasuryFee);
877         feeDenominator = _feeDenominator;
878         require(swapTotalFee < 90, "Fees cannot be that high");
879     }
880 
881     function setBuyFees(uint256 buyTax) external onlyOwner() {
882         buyTotalFee = buyTax;
883     }
884 
885 // ***
886 // end fee stuff§2e sw. 
887 // ***
888 
889 
890 
891     function setTreasuryFeeReceiver(address _newWallet) external onlyOwner() {
892         isFeeExempt[devWallet] = false;
893         isFeeExempt[_newWallet] = true;
894         devWallet = _newWallet;
895     }
896 
897     function setMarketingWallet(address _newWallet) external onlyOwner() {
898         isFeeExempt[marketingWallet] = false;
899         isFeeExempt[_newWallet] = true;
900 
901         isMaxExempt[_newWallet] = true;
902 
903         marketingWallet = _newWallet;
904     }
905 
906     function setFeeReceivers(address _autoLiquidityReceiver, address _newMarketingWallet, address _newdevWallet ) external onlyOwner() {
907 
908         isFeeExempt[devWallet] = false;
909         isFeeExempt[_newdevWallet] = true;
910         isFeeExempt[marketingWallet] = false;
911         isFeeExempt[_newMarketingWallet] = true;
912 
913         isMaxExempt[_newMarketingWallet] = true;
914 
915         autoLiquidityReceiver = _autoLiquidityReceiver;
916         marketingWallet = _newMarketingWallet;
917         devWallet = _newdevWallet;
918     }
919 
920 // ***
921 // Swap settings
922 // ***
923 
924     function setSwapThresholdAmount(uint256 _amount) external onlyOwner() {
925         swapThreshold = _amount;
926     }
927 
928     function setSwapAmount(uint256 _amount) external onlyOwner() {
929         if(_amount > swapThreshold) {
930             swapAmount = swapThreshold;
931         } else {
932             swapAmount = _amount;
933         }        
934     }
935 
936 // ***
937 // End Swap settings
938 // ***
939 
940     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner() {
941         targetLiquidity = _target;
942         targetLiquidityDenominator = _denominator;
943     }
944 
945     function getCirculatingSupply() public view returns (uint256) {
946         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
947     }
948 
949     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
950         return accuracy.mul(balanceOf(uniswapV2Pair).mul(2)).div(getCirculatingSupply());
951     }
952 
953     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
954         return getLiquidityBacking(accuracy) > target;
955     }
956 
957     /* Airdrop */
958     function airDropCustom(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
959 
960         require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
961         require(addresses.length == tokens.length,"Mismatch between Address and token count");
962 
963         uint256 SCCC = 0;
964 
965         for(uint i=0; i < addresses.length; i++){
966             SCCC = SCCC + tokens[i];
967         }
968 
969         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
970 
971         for(uint i=0; i < addresses.length; i++){
972             _basicTransfer(from,addresses[i],tokens[i]);
973         }
974         
975     }
976 
977     function airDropFixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
978 
979         require(addresses.length < 801,"GAS Error: max airdrop limit is 800 addresses");
980 
981         uint256 SCCC = tokens * addresses.length;
982 
983         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
984 
985         for(uint i=0; i < addresses.length; i++){
986             _basicTransfer(from,addresses[i],tokens);
987         }
988     }
989 
990     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
991 
992 }