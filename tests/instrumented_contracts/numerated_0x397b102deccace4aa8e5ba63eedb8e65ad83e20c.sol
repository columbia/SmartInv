1 /**
2 Encryption A.I An Erc 20 token that provides telegram bots and tools
3 which helps devs to launch without fear of snipers and bots buying early. 
4 
5 Telegram :- t.me/EncryptionAIERC
6 Medium :- https://medium.com/@EncryptionAI
7 Telegram Bot :- t.me/EncryptionCryptoBot
8 Twitter :- https://twitter.com/EncryptionAIERC
9 Website :- encryptionai.xyz
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 /**
16  
17 */
18 
19 
20 pragma solidity ^0.8.17;
21 
22 /**
23  * Abstract contract to easily change things when deploying new projects. Saves me having to find it everywhere.
24  */
25 abstract contract Project {
26     address public marketingWallet = 0xbF2954915C89768f4293bA412bA1368382217A8C;
27     address public devWallet = 0xbF2954915C89768f4293bA412bA1368382217A8C;
28 
29     string constant _name = "Encryption AI";
30     string constant _symbol = "0xEncrypt";
31     uint8 constant _decimals = 9;
32 
33     uint256 _totalSupply = 1 * 10**6 * 10**_decimals;
34 
35     uint256 public _maxTxAmount = (_totalSupply * 20) / 1000; // (_totalSupply * 10) / 1000 [this equals 1%]
36     uint256 public _maxWalletToken = (_totalSupply * 20) / 1000; //
37 
38     uint256 public buyFee             = 20;
39     uint256 public buyTotalFee        = buyFee;
40 
41     uint256 public swapLpFee          = 1;
42     uint256 public swapMarketing      = 18;
43     uint256 public swapTreasuryFee    = 1;
44     uint256 public swapTotalFee       = swapMarketing + swapLpFee + swapTreasuryFee;
45 
46     uint256 public transFee           = 5;
47 
48     uint256 public feeDenominator     = 100;
49 
50 }
51 
52 /**
53  * @dev Wrappers over Solidity's arithmetic operations.
54  *
55  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
56  * now has built in overflow checking.
57  */
58 library SafeMath {
59 
60     /**
61      * @dev Returns the addition of two unsigned integers, reverting on
62      * overflow.
63      *
64      * Counterpart to Solidity's `+` operator.
65      *
66      * Requirements:
67      *
68      * - Addition cannot overflow.
69      */
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a + b;
72     }
73 
74     /**
75      * @dev Returns the subtraction of two unsigned integers, reverting on
76      * overflow (when the result is negative).
77      *
78      * Counterpart to Solidity's `-` operator.
79      *
80      * Requirements:
81      *
82      * - Subtraction cannot overflow.
83      */
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return a - b;
86     }
87 
88     /**
89      * @dev Returns the multiplication of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `*` operator.
93      *
94      * Requirements:
95      *
96      * - Multiplication cannot overflow.
97      */
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a * b;
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers, reverting on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator.
107      *
108      * Requirements:
109      *
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a / b;
114     }
115 
116     /**
117      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
118      * reverting when dividing by zero.
119      *
120      * Counterpart to Solidity's `%` operator. This function uses a `revert`
121      * opcode (which leaves remaining gas untouched) while Solidity uses an
122      * invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      *
126      * - The divisor cannot be zero.
127      */
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         return a % b;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * CAUTION: This function is deprecated because it requires allocating memory for the error
137      * message unnecessarily. For custom revert reasons use {trySub}.
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(
146         uint256 a,
147         uint256 b,
148         string memory errorMessage
149     ) internal pure returns (uint256) {
150         unchecked {
151             require(b <= a, errorMessage);
152             return a - b;
153         }
154     }
155 
156     /**
157      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
158      * division by zero. The result is rounded towards zero.
159      *
160      * Counterpart to Solidity's `/` operator. Note: this function uses a
161      * `revert` opcode (which leaves remaining gas untouched) while Solidity
162      * uses an invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      *
166      * - The divisor cannot be zero.
167      */
168     function div(
169         uint256 a,
170         uint256 b,
171         string memory errorMessage
172     ) internal pure returns (uint256) {
173         unchecked {
174             require(b > 0, errorMessage);
175             return a / b;
176         }
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * reverting with custom message when dividing by zero.
182      *
183      * CAUTION: This function is deprecated because it requires allocating memory for the error
184      * message unnecessarily. For custom revert reasons use {tryMod}.
185      *
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function mod(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b > 0, errorMessage);
201             return a % b;
202         }
203     }
204 }
205 
206 interface IERC20 {
207     function totalSupply() external view returns (uint256);
208     function decimals() external view returns (uint8);
209     function symbol() external view returns (string memory);
210     function name() external view returns (string memory);
211     function getOwner() external view returns (address);
212     function balanceOf(address account) external view returns (uint256);
213     function transfer(address recipient, uint256 amount) external returns (bool);
214     function allowance(address _owner, address spender) external view returns (uint256);
215     function approve(address spender, uint256 amount) external returns (bool);
216     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
217     event Transfer(address indexed from, address indexed to, uint256 value);
218     event Approval(address indexed owner, address indexed spender, uint256 value);
219 }
220 
221 abstract contract Context {
222     //function _msgSender() internal view virtual returns (address payable) {
223     function _msgSender() internal view virtual returns (address) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes memory) {
228         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
229         return msg.data;
230     }
231 }
232 
233 
234 /**
235  * @dev Contract module which provides a basic access control mechanism, where
236  * there is an account (an owner) that can be granted exclusive access to
237  * specific functions.
238  *
239  * By default, the owner account will be the one that deploys the contract. This
240  * can later be changed with {transferOwnership}.
241  *
242  * This module is used through inheritance. It will make available the modifier
243  * `onlyOwner`, which can be applied to your functions to restrict their use to
244  * the owner.
245  */
246 contract Ownable is Context {
247     address private _owner;
248     address private _previousOwner;
249     uint256 private _lockTime;
250 
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     /**
254      * @dev Initializes the contract setting the deployer as the initial owner.
255      */
256     constructor () {
257         address msgSender = _msgSender();
258         _owner = msgSender;
259         emit OwnershipTransferred(address(0), msgSender);
260     }
261 
262     /**
263      * @dev Returns the address of the current owner.
264      */
265     function owner() public view returns (address) {
266         return _owner;
267     }
268 
269     /**
270      * @dev Throws if called by any account other than the owner.
271      */
272     modifier onlyOwner() {
273         require(_owner == _msgSender(), "Ownable: caller is not the owner");
274         _;
275     }
276 
277      /**
278      * @dev Leaves the contract without owner. It will not be possible to call
279      * `onlyOwner` functions anymore. Can only be called by the current owner.
280      *
281      * NOTE: Renouncing ownership will leave the contract without an owner,
282      * thereby removing any functionality that is only available to the owner.
283      */
284     function renounceOwnership() public virtual onlyOwner {
285         emit OwnershipTransferred(_owner, address(0));
286         _owner = address(0);
287     }
288 
289     /**
290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
291      * Can only be called by the current owner.
292      */
293     function transferOwnership(address newOwner) public virtual onlyOwner {
294         require(newOwner != address(0), "Ownable: new owner is the zero address");
295         emit OwnershipTransferred(_owner, newOwner);
296         _owner = newOwner;
297     }
298 
299     function geUnlockTime() public view returns (uint256) {
300         return _lockTime;
301     }
302 
303     //Locks the contract for owner for the amount of time provided
304     function lock(uint256 time) public virtual onlyOwner {
305         _previousOwner = _owner;
306         _owner = address(0);
307         _lockTime = block.timestamp + time;
308         emit OwnershipTransferred(_owner, address(0));
309     }
310     
311     //Unlocks the contract for owner when _lockTime is exceeds
312     function unlock() public virtual {
313         require(_previousOwner == msg.sender, "You don't have permission to unlock");
314         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
315         emit OwnershipTransferred(_owner, _previousOwner);
316         _owner = _previousOwner;
317     }
318 }
319 
320 
321 interface IUniswapV2Factory {
322     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
323 
324     function feeTo() external view returns (address);
325     function feeToSetter() external view returns (address);
326 
327     function getPair(address tokenA, address tokenB) external view returns (address pair);
328     function allPairs(uint) external view returns (address pair);
329     function allPairsLength() external view returns (uint);
330 
331     function createPair(address tokenA, address tokenB) external returns (address pair);
332 
333     function setFeeTo(address) external;
334     function setFeeToSetter(address) external;
335 }
336 
337 
338 
339 interface IUniswapV2Pair {
340     event Approval(address indexed owner, address indexed spender, uint value);
341     event Transfer(address indexed from, address indexed to, uint value);
342 
343     function name() external pure returns (string memory);
344     function symbol() external pure returns (string memory);
345     function decimals() external pure returns (uint8);
346     function totalSupply() external view returns (uint);
347     function balanceOf(address owner) external view returns (uint);
348     function allowance(address owner, address spender) external view returns (uint);
349 
350     function approve(address spender, uint value) external returns (bool);
351     function transfer(address to, uint value) external returns (bool);
352     function transferFrom(address from, address to, uint value) external returns (bool);
353 
354     function DOMAIN_SEPARATOR() external view returns (bytes32);
355     function PERMIT_TYPEHASH() external pure returns (bytes32);
356     function nonces(address owner) external view returns (uint);
357 
358     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
359 
360     event Mint(address indexed sender, uint amount0, uint amount1);
361     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
362     event Swap(
363         address indexed sender,
364         uint amount0In,
365         uint amount1In,
366         uint amount0Out,
367         uint amount1Out,
368         address indexed to
369     );
370     event Sync(uint112 reserve0, uint112 reserve1);
371 
372     function MINIMUM_LIQUIDITY() external pure returns (uint);
373     function factory() external view returns (address);
374     function token0() external view returns (address);
375     function token1() external view returns (address);
376     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
377     function price0CumulativeLast() external view returns (uint);
378     function price1CumulativeLast() external view returns (uint);
379     function kLast() external view returns (uint);
380 
381     function mint(address to) external returns (uint liquidity);
382     function burn(address to) external returns (uint amount0, uint amount1);
383     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
384     function skim(address to) external;
385     function sync() external;
386 
387     function initialize(address, address) external;
388 }
389 
390 
391 interface IUniswapV2Router01 {
392     function factory() external pure returns (address);
393     function WETH() external pure returns (address);
394 
395     function addLiquidity(
396         address tokenA,
397         address tokenB,
398         uint amountADesired,
399         uint amountBDesired,
400         uint amountAMin,
401         uint amountBMin,
402         address to,
403         uint deadline
404     ) external returns (uint amountA, uint amountB, uint liquidity);
405     function addLiquidityETH(
406         address token,
407         uint amountTokenDesired,
408         uint amountTokenMin,
409         uint amountETHMin,
410         address to,
411         uint deadline
412     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
413     function removeLiquidity(
414         address tokenA,
415         address tokenB,
416         uint liquidity,
417         uint amountAMin,
418         uint amountBMin,
419         address to,
420         uint deadline
421     ) external returns (uint amountA, uint amountB);
422     function removeLiquidityETH(
423         address token,
424         uint liquidity,
425         uint amountTokenMin,
426         uint amountETHMin,
427         address to,
428         uint deadline
429     ) external returns (uint amountToken, uint amountETH);
430     function removeLiquidityWithPermit(
431         address tokenA,
432         address tokenB,
433         uint liquidity,
434         uint amountAMin,
435         uint amountBMin,
436         address to,
437         uint deadline,
438         bool approveMax, uint8 v, bytes32 r, bytes32 s
439     ) external returns (uint amountA, uint amountB);
440     function removeLiquidityETHWithPermit(
441         address token,
442         uint liquidity,
443         uint amountTokenMin,
444         uint amountETHMin,
445         address to,
446         uint deadline,
447         bool approveMax, uint8 v, bytes32 r, bytes32 s
448     ) external returns (uint amountToken, uint amountETH);
449     function swapExactTokensForTokens(
450         uint amountIn,
451         uint amountOutMin,
452         address[] calldata path,
453         address to,
454         uint deadline
455     ) external returns (uint[] memory amounts);
456     function swapTokensForExactTokens(
457         uint amountOut,
458         uint amountInMax,
459         address[] calldata path,
460         address to,
461         uint deadline
462     ) external returns (uint[] memory amounts);
463     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
464         external
465         payable
466         returns (uint[] memory amounts);
467     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
468         external
469         returns (uint[] memory amounts);
470     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
471         external
472         returns (uint[] memory amounts);
473     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
474         external
475         payable
476         returns (uint[] memory amounts);
477 
478     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
479     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
480     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
481     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
482     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
483 }
484 
485 
486 
487 
488 interface IUniswapV2Router02 is IUniswapV2Router01 {
489     function removeLiquidityETHSupportingFeeOnTransferTokens(
490         address token,
491         uint liquidity,
492         uint amountTokenMin,
493         uint amountETHMin,
494         address to,
495         uint deadline
496     ) external returns (uint amountETH);
497     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
498         address token,
499         uint liquidity,
500         uint amountTokenMin,
501         uint amountETHMin,
502         address to,
503         uint deadline,
504         bool approveMax, uint8 v, bytes32 r, bytes32 s
505     ) external returns (uint amountETH);
506 
507     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
508         uint amountIn,
509         uint amountOutMin,
510         address[] calldata path,
511         address to,
512         uint deadline
513     ) external;
514     function swapExactETHForTokensSupportingFeeOnTransferTokens(
515         uint amountOutMin,
516         address[] calldata path,
517         address to,
518         uint deadline
519     ) external payable;
520     function swapExactTokensForETHSupportingFeeOnTransferTokens(
521         uint amountIn,
522         uint amountOutMin,
523         address[] calldata path,
524         address to,
525         uint deadline
526     ) external;
527 }
528 
529 
530 /**
531  * MainContract
532  */
533 contract EncryptionAIContract is Project, IERC20, Ownable {
534     using SafeMath for uint256;
535 
536     address DEAD = 0x000000000000000000000000000000000000dEaD;
537     address ZERO = 0x0000000000000000000000000000000000000000;
538 
539     mapping (address => uint256) _balances;
540     mapping (address => mapping (address => uint256)) _allowances;
541 
542     mapping (address => bool) isFeeExempt;
543     mapping (address => bool) isTxLimitExempt;
544     mapping (address => bool) isMaxExempt;
545     mapping (address => bool) isTimelockExempt;
546 
547     address public autoLiquidityReceiver;
548 
549     uint256 targetLiquidity = 20;
550     uint256 targetLiquidityDenominator = 100;
551 
552     IUniswapV2Router02 public immutable contractRouter;
553     address public immutable uniswapV2Pair;
554 
555     bool public tradingOpen = false;
556 
557     bool public buyCooldownEnabled = true;
558     uint8 public cooldownTimerInterval = 10;
559     mapping (address => uint) private cooldownTimer;
560 
561     bool public swapEnabled = true;
562     uint256 public swapThreshold = _totalSupply * 30 / 10000;
563     uint256 public swapAmount = _totalSupply * 30 / 10000;
564 
565     bool inSwap;
566     modifier swapping() { inSwap = true; _; inSwap = false; }
567 
568     constructor () {
569 
570         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
571          // Create a uniswap pair for this new token
572         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
573             .createPair(address(this), _uniswapV2Router.WETH());
574 
575         // set the rest of the contract variables
576         contractRouter = _uniswapV2Router;
577 
578         _allowances[address(this)][address(contractRouter)] = type(uint256).max;
579 
580         isFeeExempt[msg.sender] = true;
581         isTxLimitExempt[msg.sender] = true;
582         isMaxExempt[msg.sender] = true;
583 
584         isTimelockExempt[msg.sender] = true;
585         isTimelockExempt[DEAD] = true;
586         isTimelockExempt[address(this)] = true;
587 
588         isFeeExempt[marketingWallet] = true;
589         isMaxExempt[marketingWallet] = true;
590         isTxLimitExempt[marketingWallet] = true;
591 
592         autoLiquidityReceiver = msg.sender;
593 
594         _balances[msg.sender] = _totalSupply;
595         emit Transfer(address(0), msg.sender, _totalSupply);
596     }
597 
598     receive() external payable { }
599 
600     function totalSupply() external view override returns (uint256) { return _totalSupply; }
601     function decimals() external pure override returns (uint8) { return _decimals; }
602     function symbol() external pure override returns (string memory) { return _symbol; }
603     function name() external pure override returns (string memory) { return _name; }
604     function getOwner() external view override returns (address) { return owner(); }
605     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
606     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
607 
608     function approve(address spender, uint256 amount) public override returns (bool) {
609         _allowances[msg.sender][spender] = amount;
610         emit Approval(msg.sender, spender, amount);
611         return true;
612     }
613 
614     function approveMax(address spender) external returns (bool) {
615         return approve(spender, type(uint256).max);
616     }
617 
618     function transfer(address recipient, uint256 amount) external override returns (bool) {
619         return _transferFrom(msg.sender, recipient, amount);
620     }
621 
622     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
623         if(_allowances[sender][msg.sender] != type(uint256).max){
624             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
625         }
626 
627         return _transferFrom(sender, recipient, amount);
628     }
629 
630     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
631         _maxWalletToken = (_totalSupply * maxWallPercent_base1000 ) / 1000;
632     }
633     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner() {
634         _maxTxAmount = (_totalSupply * maxTXPercentage_base1000 ) / 1000;
635     }
636 
637     function setTxLimit(uint256 amount) external onlyOwner() {
638         _maxTxAmount = amount;
639     }
640 
641 // *** 
642 // Functions for the burning mechanism 
643 // *** 
644 
645     /**
646     * Burn an amount of tokens for the current wallet (if they have enough)
647     */
648     function burnTokens(uint256 amount) external {
649         // does this user have enough tokens to perform the burn
650         if(_balances[msg.sender] > amount) {
651             _basicTransfer(msg.sender, DEAD, amount);
652         }
653     }
654 
655 
656 // *** 
657 // End functions for the burning mechanism 
658 // *** 
659 
660     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
661         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
662 
663         if(sender != owner() && recipient != owner()){
664             require(tradingOpen,"Trading not open yet");
665         }
666 
667         bool inSell = (recipient == uniswapV2Pair);
668         bool inTransfer = (recipient != uniswapV2Pair && sender != uniswapV2Pair);
669 
670         if (recipient != address(this) && 
671             recipient != address(DEAD) && 
672             recipient != uniswapV2Pair && 
673             recipient != marketingWallet && 
674             recipient != devWallet && 
675             recipient != autoLiquidityReceiver
676         ){
677             uint256 heldTokens = balanceOf(recipient);
678             if(!isMaxExempt[recipient]) {
679                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
680             }
681         }
682 
683         if (sender == uniswapV2Pair &&
684             buyCooldownEnabled &&
685             !isTimelockExempt[recipient]
686         ){
687             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two buys");
688             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
689         }
690 
691         // Checks max transaction limit
692         // but no point if the recipient is exempt
693         // this check ensures that someone that is buying and is txnExempt then they are able to buy any amount
694         if(!isTxLimitExempt[recipient]) {
695             checkTxLimit(sender, amount);
696         }
697 
698         //Exchange tokens
699         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
700 
701         uint256 amountReceived = amount;
702 
703         // Do NOT take a fee if sender AND recipient are NOT the contract
704         // i.e. you are doing a transfer
705         if(inTransfer) {
706             if(transFee > 0) {
707                 amountReceived = takeTransferFee(sender, amount);
708             }
709         } else {
710             amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount, inSell) : amount;
711             
712             if(shouldSwapBack()){ swapBack(); }
713         }
714 
715         _balances[recipient] = _balances[recipient].add(amountReceived);
716 
717         emit Transfer(sender, recipient, amountReceived);
718         return true;
719     }
720 
721     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
722         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
723         _balances[recipient] = _balances[recipient].add(amount);
724         emit Transfer(sender, recipient, amount);
725         return true;
726     }
727 
728     function checkTxLimit(address sender, uint256 amount) internal view {
729         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
730     }
731 
732     function shouldTakeFee(address sender) internal view returns (bool) {
733         return !isFeeExempt[sender];
734     }
735 
736 // *** 
737 // Handle Fees
738 // *** 
739 
740     function takeTransferFee(address sender, uint256 amount) internal returns (uint256) {
741 
742         uint256 feeToTake = transFee;
743         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
744         
745         _balances[address(this)] = _balances[address(this)].add(feeAmount);
746         emit Transfer(sender, address(this), feeAmount);
747 
748         return amount.sub(feeAmount);
749     }
750 
751     function takeFee(address sender, uint256 amount, bool isSell) internal returns (uint256) {
752 
753         uint256 feeToTake = isSell ? swapTotalFee : buyTotalFee;
754         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
755         
756         _balances[address(this)] = _balances[address(this)].add(feeAmount);
757         emit Transfer(sender, address(this), feeAmount);
758 
759         return amount.sub(feeAmount);
760     }
761 
762 // *** 
763 // End Handle Fees
764 // *** 
765 
766     function shouldSwapBack() internal view returns (bool) {
767         return msg.sender != uniswapV2Pair
768         && !inSwap
769         && swapEnabled
770         && _balances[address(this)] >= swapThreshold;
771     }
772 
773     function clearStuckBalance(uint256 amountPercentage) external onlyOwner() {
774         uint256 amountETH = address(this).balance;
775         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
776     }
777 
778     function clearStuckBalance_sender(uint256 amountPercentage) external onlyOwner() {
779         uint256 amountETH = address(this).balance;
780         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
781     }
782 
783     // switch Trading
784     function tradingStatus(bool _status) public onlyOwner {
785         tradingOpen = _status;
786     }
787 
788     // enable cooldown between trades
789     function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
790         buyCooldownEnabled = _status;
791         cooldownTimerInterval = _interval;
792     }
793 
794     function swapBack() internal swapping {
795         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : swapLpFee;
796         uint256 amountToLiquify = swapAmount.mul(dynamicLiquidityFee).div(swapTotalFee).div(2);
797         uint256 amountToSwap = swapAmount.sub(amountToLiquify);
798 
799         address[] memory path = new address[](2);
800         path[0] = address(this);
801         path[1] = contractRouter.WETH();
802 
803         uint256 balanceBefore = address(this).balance;
804 
805         contractRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
806             amountToSwap,
807             0,
808             path,
809             address(this),
810             block.timestamp
811         );
812 
813         uint256 amountETH = address(this).balance.sub(balanceBefore);
814 
815         uint256 totalETHFee = swapTotalFee.sub(dynamicLiquidityFee.div(2));
816 
817         uint256 amountETHLiquidity = amountETH.mul(swapLpFee).div(totalETHFee).div(2);
818         uint256 amountETHMarketing = amountETH.mul(swapMarketing).div(totalETHFee);
819         uint256 amountETHTreasury = amountETH.mul(swapTreasuryFee).div(totalETHFee);
820 
821         (bool tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 30000}("");
822         (tmpSuccess,) = payable(devWallet).call{value: amountETHTreasury, gas: 30000}("");
823 
824         // Supress warning msg
825         tmpSuccess = false;
826 
827         if(amountToLiquify > 0){
828             contractRouter.addLiquidityETH{value: amountETHLiquidity}(
829                 address(this),
830                 amountToLiquify,
831                 0,
832                 0,
833                 autoLiquidityReceiver,
834                 block.timestamp
835             );
836             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
837         }
838     }
839 
840 // *** 
841 // Various exempt functions
842 // *** 
843 
844     function setIsFeeExempt(address holder, bool exempt) external onlyOwner() {
845         isFeeExempt[holder] = exempt;
846     }
847 
848     function setIsMaxExempt(address holder, bool exempt) external onlyOwner() {
849         isMaxExempt[holder] = exempt;
850     }
851 
852     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner() {
853         isTxLimitExempt[holder] = exempt;
854     }
855 
856     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner() {
857         isTimelockExempt[holder] = exempt;
858     }
859 
860 // *** 
861 // End various exempt functions
862 // *** 
863 
864 
865 // ***
866 // Start fee things
867 // ***
868 
869     function setTransFee(uint256 fee) external onlyOwner() {
870         transFee = fee;
871     }
872 
873     function setSwapFees(uint256 _newSwapLpFee, uint256 _newSwapMarketingFee, uint256 _newSwapTreasuryFee, uint256 _feeDenominator) external onlyOwner() {
874         swapLpFee = _newSwapLpFee;
875         swapMarketing = _newSwapMarketingFee;
876         swapTreasuryFee = _newSwapTreasuryFee;
877         swapTotalFee = _newSwapLpFee.add(_newSwapMarketingFee).add(_newSwapTreasuryFee);
878         feeDenominator = _feeDenominator;
879         require(swapTotalFee < 90, "Fees cannot be that high");
880     }
881 
882     function setBuyFees(uint256 buyTax) external onlyOwner() {
883         buyTotalFee = buyTax;
884     }
885 
886 // ***
887 // end fee stuff§2e sw. 
888 // ***
889 
890 
891 
892     function setTreasuryFeeReceiver(address _newWallet) external onlyOwner() {
893         isFeeExempt[devWallet] = false;
894         isFeeExempt[_newWallet] = true;
895         devWallet = _newWallet;
896     }
897 
898     function setMarketingWallet(address _newWallet) external onlyOwner() {
899         isFeeExempt[marketingWallet] = false;
900         isFeeExempt[_newWallet] = true;
901 
902         isMaxExempt[_newWallet] = true;
903 
904         marketingWallet = _newWallet;
905     }
906 
907     function setFeeReceivers(address _autoLiquidityReceiver, address _newMarketingWallet, address _newdevWallet ) external onlyOwner() {
908 
909         isFeeExempt[devWallet] = false;
910         isFeeExempt[_newdevWallet] = true;
911         isFeeExempt[marketingWallet] = false;
912         isFeeExempt[_newMarketingWallet] = true;
913 
914         isMaxExempt[_newMarketingWallet] = true;
915 
916         autoLiquidityReceiver = _autoLiquidityReceiver;
917         marketingWallet = _newMarketingWallet;
918         devWallet = _newdevWallet;
919     }
920 
921 // ***
922 // Swap settings
923 // ***
924 
925     function setSwapThresholdAmount(uint256 _amount) external onlyOwner() {
926         swapThreshold = _amount;
927     }
928 
929     function setSwapAmount(uint256 _amount) external onlyOwner() {
930         if(_amount > swapThreshold) {
931             swapAmount = swapThreshold;
932         } else {
933             swapAmount = _amount;
934         }        
935     }
936 
937 // ***
938 // End Swap settings
939 // ***
940 
941     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner() {
942         targetLiquidity = _target;
943         targetLiquidityDenominator = _denominator;
944     }
945 
946     function getCirculatingSupply() public view returns (uint256) {
947         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
948     }
949 
950     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
951         return accuracy.mul(balanceOf(uniswapV2Pair).mul(2)).div(getCirculatingSupply());
952     }
953 
954     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
955         return getLiquidityBacking(accuracy) > target;
956     }
957 
958     /* Airdrop */
959     function airDropCustom(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
960 
961         require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
962         require(addresses.length == tokens.length,"Mismatch between Address and token count");
963 
964         uint256 SCCC = 0;
965 
966         for(uint i=0; i < addresses.length; i++){
967             SCCC = SCCC + tokens[i];
968         }
969 
970         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
971 
972         for(uint i=0; i < addresses.length; i++){
973             _basicTransfer(from,addresses[i],tokens[i]);
974         }
975         
976     }
977 
978     function airDropFixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
979 
980         require(addresses.length < 801,"GAS Error: max airdrop limit is 800 addresses");
981 
982         uint256 SCCC = tokens * addresses.length;
983 
984         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
985 
986         for(uint i=0; i < addresses.length; i++){
987             _basicTransfer(from,addresses[i],tokens);
988         }
989     }
990 
991     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
992 
993 }