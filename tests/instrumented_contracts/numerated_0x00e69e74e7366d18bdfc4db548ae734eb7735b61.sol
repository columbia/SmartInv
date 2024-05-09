1 /**
2 
3 https://medium.com/@haoleserc
4 https://twitter.com/haoleserc
5 
6  */
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity ^0.8.17;
11 
12 /**
13  * Abstract contract to easily change things when deploying new projects. Saves me having to find it everywhere.
14  */
15 abstract contract Project {
16     address public marketingWallet = 0x8a37897cfDF960bdE8902C913399d83309130324;
17     address public devWallet = 0xf2C8f125Cee3aE81222B5cdCe4110Ed3024e452B;
18 
19     string constant _name = "HAOLES";
20     string constant _symbol = "HAOLES";
21     uint8 constant _decimals = 9;
22 
23     uint256 _totalSupply = 1 * 10**6 * 10**_decimals;
24 
25     uint256 public _maxTxAmount = (_totalSupply * 1) / 1000; // (_totalSupply * 10) / 1000 [this equals 1%]
26     uint256 public _maxWalletToken = (_totalSupply * 1) / 1000; //
27 
28     uint256 public buyFee             = 3;
29     uint256 public buyTotalFee        = buyFee;
30 
31     uint256 public swapLpFee          = 1;
32     uint256 public swapMarketing      = 1;
33     uint256 public swapTreasuryFee    = 1;
34     uint256 public swapTotalFee       = swapMarketing + swapLpFee + swapTreasuryFee;
35 
36     uint256 public transFee           = 3;
37 
38     uint256 public feeDenominator     = 100;
39 
40 }
41 
42 /**
43  * @dev Wrappers over Solidity's arithmetic operations.
44  *
45  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
46  * now has built in overflow checking.
47  */
48 library SafeMath {
49 
50     /**
51      * @dev Returns the addition of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `+` operator.
55      *
56      * Requirements:
57      *
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         return a + b;
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting on
66      * overflow (when the result is negative).
67      *
68      * Counterpart to Solidity's `-` operator.
69      *
70      * Requirements:
71      *
72      * - Subtraction cannot overflow.
73      */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a - b;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      *
86      * - Multiplication cannot overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         return a * b;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers, reverting on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator.
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return a / b;
104     }
105 
106     /**
107      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
108      * reverting when dividing by zero.
109      *
110      * Counterpart to Solidity's `%` operator. This function uses a `revert`
111      * opcode (which leaves remaining gas untouched) while Solidity uses an
112      * invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a % b;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * CAUTION: This function is deprecated because it requires allocating memory for the error
127      * message unnecessarily. For custom revert reasons use {trySub}.
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(
136         uint256 a,
137         uint256 b,
138         string memory errorMessage
139     ) internal pure returns (uint256) {
140         unchecked {
141             require(b <= a, errorMessage);
142             return a - b;
143         }
144     }
145 
146     /**
147      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
148      * division by zero. The result is rounded towards zero.
149      *
150      * Counterpart to Solidity's `/` operator. Note: this function uses a
151      * `revert` opcode (which leaves remaining gas untouched) while Solidity
152      * uses an invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function div(
159         uint256 a,
160         uint256 b,
161         string memory errorMessage
162     ) internal pure returns (uint256) {
163         unchecked {
164             require(b > 0, errorMessage);
165             return a / b;
166         }
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * reverting with custom message when dividing by zero.
172      *
173      * CAUTION: This function is deprecated because it requires allocating memory for the error
174      * message unnecessarily. For custom revert reasons use {tryMod}.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function mod(
185         uint256 a,
186         uint256 b,
187         string memory errorMessage
188     ) internal pure returns (uint256) {
189         unchecked {
190             require(b > 0, errorMessage);
191             return a % b;
192         }
193     }
194 }
195 
196 interface IERC20 {
197     function totalSupply() external view returns (uint256);
198     function decimals() external view returns (uint8);
199     function symbol() external view returns (string memory);
200     function name() external view returns (string memory);
201     function getOwner() external view returns (address);
202     function balanceOf(address account) external view returns (uint256);
203     function transfer(address recipient, uint256 amount) external returns (bool);
204     function allowance(address _owner, address spender) external view returns (uint256);
205     function approve(address spender, uint256 amount) external returns (bool);
206     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
207     event Transfer(address indexed from, address indexed to, uint256 value);
208     event Approval(address indexed owner, address indexed spender, uint256 value);
209 }
210 
211 abstract contract Context {
212     //function _msgSender() internal view virtual returns (address payable) {
213     function _msgSender() internal view virtual returns (address) {
214         return msg.sender;
215     }
216 
217     function _msgData() internal view virtual returns (bytes memory) {
218         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
219         return msg.data;
220     }
221 }
222 
223 
224 /**
225  * @dev Contract module which provides a basic access control mechanism, where
226  * there is an account (an owner) that can be granted exclusive access to
227  * specific functions.
228  *
229  * By default, the owner account will be the one that deploys the contract. This
230  * can later be changed with {transferOwnership}.
231  *
232  * This module is used through inheritance. It will make available the modifier
233  * `onlyOwner`, which can be applied to your functions to restrict their use to
234  * the owner.
235  */
236 contract Ownable is Context {
237     address private _owner;
238     address private _previousOwner;
239     uint256 private _lockTime;
240 
241     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
242 
243     /**
244      * @dev Initializes the contract setting the deployer as the initial owner.
245      */
246     constructor () {
247         address msgSender = _msgSender();
248         _owner = msgSender;
249         emit OwnershipTransferred(address(0), msgSender);
250     }
251 
252     /**
253      * @dev Returns the address of the current owner.
254      */
255     function owner() public view returns (address) {
256         return _owner;
257     }
258 
259     /**
260      * @dev Throws if called by any account other than the owner.
261      */
262     modifier onlyOwner() {
263         require(_owner == _msgSender(), "Ownable: caller is not the owner");
264         _;
265     }
266 
267      /**
268      * @dev Leaves the contract without owner. It will not be possible to call
269      * `onlyOwner` functions anymore. Can only be called by the current owner.
270      *
271      * NOTE: Renouncing ownership will leave the contract without an owner,
272      * thereby removing any functionality that is only available to the owner.
273      */
274     function renounceOwnership() public virtual onlyOwner {
275         emit OwnershipTransferred(_owner, address(0));
276         _owner = address(0);
277     }
278 
279     /**
280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
281      * Can only be called by the current owner.
282      */
283     function transferOwnership(address newOwner) public virtual onlyOwner {
284         require(newOwner != address(0), "Ownable: new owner is the zero address");
285         emit OwnershipTransferred(_owner, newOwner);
286         _owner = newOwner;
287     }
288 
289     function geUnlockTime() public view returns (uint256) {
290         return _lockTime;
291     }
292 
293     //Locks the contract for owner for the amount of time provided
294     function lock(uint256 time) public virtual onlyOwner {
295         _previousOwner = _owner;
296         _owner = address(0);
297         _lockTime = block.timestamp + time;
298         emit OwnershipTransferred(_owner, address(0));
299     }
300     
301     //Unlocks the contract for owner when _lockTime is exceeds
302     function unlock() public virtual {
303         require(_previousOwner == msg.sender, "You don't have permission to unlock");
304         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
305         emit OwnershipTransferred(_owner, _previousOwner);
306         _owner = _previousOwner;
307     }
308 }
309 
310 
311 interface IUniswapV2Factory {
312     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
313 
314     function feeTo() external view returns (address);
315     function feeToSetter() external view returns (address);
316 
317     function getPair(address tokenA, address tokenB) external view returns (address pair);
318     function allPairs(uint) external view returns (address pair);
319     function allPairsLength() external view returns (uint);
320 
321     function createPair(address tokenA, address tokenB) external returns (address pair);
322 
323     function setFeeTo(address) external;
324     function setFeeToSetter(address) external;
325 }
326 
327 
328 
329 interface IUniswapV2Pair {
330     event Approval(address indexed owner, address indexed spender, uint value);
331     event Transfer(address indexed from, address indexed to, uint value);
332 
333     function name() external pure returns (string memory);
334     function symbol() external pure returns (string memory);
335     function decimals() external pure returns (uint8);
336     function totalSupply() external view returns (uint);
337     function balanceOf(address owner) external view returns (uint);
338     function allowance(address owner, address spender) external view returns (uint);
339 
340     function approve(address spender, uint value) external returns (bool);
341     function transfer(address to, uint value) external returns (bool);
342     function transferFrom(address from, address to, uint value) external returns (bool);
343 
344     function DOMAIN_SEPARATOR() external view returns (bytes32);
345     function PERMIT_TYPEHASH() external pure returns (bytes32);
346     function nonces(address owner) external view returns (uint);
347 
348     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
349 
350     event Mint(address indexed sender, uint amount0, uint amount1);
351     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
352     event Swap(
353         address indexed sender,
354         uint amount0In,
355         uint amount1In,
356         uint amount0Out,
357         uint amount1Out,
358         address indexed to
359     );
360     event Sync(uint112 reserve0, uint112 reserve1);
361 
362     function MINIMUM_LIQUIDITY() external pure returns (uint);
363     function factory() external view returns (address);
364     function token0() external view returns (address);
365     function token1() external view returns (address);
366     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
367     function price0CumulativeLast() external view returns (uint);
368     function price1CumulativeLast() external view returns (uint);
369     function kLast() external view returns (uint);
370 
371     function mint(address to) external returns (uint liquidity);
372     function burn(address to) external returns (uint amount0, uint amount1);
373     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
374     function skim(address to) external;
375     function sync() external;
376 
377     function initialize(address, address) external;
378 }
379 
380 
381 interface IUniswapV2Router01 {
382     function factory() external pure returns (address);
383     function WETH() external pure returns (address);
384 
385     function addLiquidity(
386         address tokenA,
387         address tokenB,
388         uint amountADesired,
389         uint amountBDesired,
390         uint amountAMin,
391         uint amountBMin,
392         address to,
393         uint deadline
394     ) external returns (uint amountA, uint amountB, uint liquidity);
395     function addLiquidityETH(
396         address token,
397         uint amountTokenDesired,
398         uint amountTokenMin,
399         uint amountETHMin,
400         address to,
401         uint deadline
402     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
403     function removeLiquidity(
404         address tokenA,
405         address tokenB,
406         uint liquidity,
407         uint amountAMin,
408         uint amountBMin,
409         address to,
410         uint deadline
411     ) external returns (uint amountA, uint amountB);
412     function removeLiquidityETH(
413         address token,
414         uint liquidity,
415         uint amountTokenMin,
416         uint amountETHMin,
417         address to,
418         uint deadline
419     ) external returns (uint amountToken, uint amountETH);
420     function removeLiquidityWithPermit(
421         address tokenA,
422         address tokenB,
423         uint liquidity,
424         uint amountAMin,
425         uint amountBMin,
426         address to,
427         uint deadline,
428         bool approveMax, uint8 v, bytes32 r, bytes32 s
429     ) external returns (uint amountA, uint amountB);
430     function removeLiquidityETHWithPermit(
431         address token,
432         uint liquidity,
433         uint amountTokenMin,
434         uint amountETHMin,
435         address to,
436         uint deadline,
437         bool approveMax, uint8 v, bytes32 r, bytes32 s
438     ) external returns (uint amountToken, uint amountETH);
439     function swapExactTokensForTokens(
440         uint amountIn,
441         uint amountOutMin,
442         address[] calldata path,
443         address to,
444         uint deadline
445     ) external returns (uint[] memory amounts);
446     function swapTokensForExactTokens(
447         uint amountOut,
448         uint amountInMax,
449         address[] calldata path,
450         address to,
451         uint deadline
452     ) external returns (uint[] memory amounts);
453     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
454         external
455         payable
456         returns (uint[] memory amounts);
457     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
458         external
459         returns (uint[] memory amounts);
460     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
461         external
462         returns (uint[] memory amounts);
463     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
464         external
465         payable
466         returns (uint[] memory amounts);
467 
468     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
469     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
470     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
471     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
472     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
473 }
474 
475 
476 
477 
478 interface IUniswapV2Router02 is IUniswapV2Router01 {
479     function removeLiquidityETHSupportingFeeOnTransferTokens(
480         address token,
481         uint liquidity,
482         uint amountTokenMin,
483         uint amountETHMin,
484         address to,
485         uint deadline
486     ) external returns (uint amountETH);
487     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
488         address token,
489         uint liquidity,
490         uint amountTokenMin,
491         uint amountETHMin,
492         address to,
493         uint deadline,
494         bool approveMax, uint8 v, bytes32 r, bytes32 s
495     ) external returns (uint amountETH);
496 
497     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
498         uint amountIn,
499         uint amountOutMin,
500         address[] calldata path,
501         address to,
502         uint deadline
503     ) external;
504     function swapExactETHForTokensSupportingFeeOnTransferTokens(
505         uint amountOutMin,
506         address[] calldata path,
507         address to,
508         uint deadline
509     ) external payable;
510     function swapExactTokensForETHSupportingFeeOnTransferTokens(
511         uint amountIn,
512         uint amountOutMin,
513         address[] calldata path,
514         address to,
515         uint deadline
516     ) external;
517 }
518 
519 
520 /**
521  * MainContract
522  */
523 contract haolesContract is Project, IERC20, Ownable {
524     using SafeMath for uint256;
525 
526     address DEAD = 0x000000000000000000000000000000000000dEaD;
527     address ZERO = 0x0000000000000000000000000000000000000000;
528 
529     mapping (address => uint256) _balances;
530     mapping (address => mapping (address => uint256)) _allowances;
531 
532     mapping (address => bool) isFeeExempt;
533     mapping (address => bool) isTxLimitExempt;
534     mapping (address => bool) isMaxExempt;
535     mapping (address => bool) isTimelockExempt;
536 
537     address public autoLiquidityReceiver;
538 
539     uint256 targetLiquidity = 20;
540     uint256 targetLiquidityDenominator = 100;
541 
542     IUniswapV2Router02 public immutable contractRouter;
543     address public immutable uniswapV2Pair;
544 
545     bool public tradingOpen = false;
546 
547     bool public buyCooldownEnabled = true;
548     uint8 public cooldownTimerInterval = 10;
549     mapping (address => uint) private cooldownTimer;
550 
551     bool public swapEnabled = true;
552     uint256 public swapThreshold = _totalSupply * 30 / 10000;
553     uint256 public swapAmount = _totalSupply * 30 / 10000;
554 
555     bool inSwap;
556     modifier swapping() { inSwap = true; _; inSwap = false; }
557 
558     constructor () {
559 
560         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
561          // Create a uniswap pair for this new token
562         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
563             .createPair(address(this), _uniswapV2Router.WETH());
564 
565         // set the rest of the contract variables
566         contractRouter = _uniswapV2Router;
567 
568         _allowances[address(this)][address(contractRouter)] = type(uint256).max;
569 
570         isFeeExempt[msg.sender] = true;
571         isTxLimitExempt[msg.sender] = true;
572         isMaxExempt[msg.sender] = true;
573 
574         isTimelockExempt[msg.sender] = true;
575         isTimelockExempt[DEAD] = true;
576         isTimelockExempt[address(this)] = true;
577 
578         isFeeExempt[marketingWallet] = true;
579         isMaxExempt[marketingWallet] = true;
580         isTxLimitExempt[marketingWallet] = true;
581 
582         autoLiquidityReceiver = msg.sender;
583 
584         _balances[msg.sender] = _totalSupply;
585         emit Transfer(address(0), msg.sender, _totalSupply);
586     }
587 
588     receive() external payable { }
589 
590     function totalSupply() external view override returns (uint256) { return _totalSupply; }
591     function decimals() external pure override returns (uint8) { return _decimals; }
592     function symbol() external pure override returns (string memory) { return _symbol; }
593     function name() external pure override returns (string memory) { return _name; }
594     function getOwner() external view override returns (address) { return owner(); }
595     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
596     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
597 
598     function approve(address spender, uint256 amount) public override returns (bool) {
599         _allowances[msg.sender][spender] = amount;
600         emit Approval(msg.sender, spender, amount);
601         return true;
602     }
603 
604     function approveMax(address spender) external returns (bool) {
605         return approve(spender, type(uint256).max);
606     }
607 
608     function transfer(address recipient, uint256 amount) external override returns (bool) {
609         return _transferFrom(msg.sender, recipient, amount);
610     }
611 
612     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
613         if(_allowances[sender][msg.sender] != type(uint256).max){
614             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
615         }
616 
617         return _transferFrom(sender, recipient, amount);
618     }
619 
620     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
621         _maxWalletToken = (_totalSupply * maxWallPercent_base1000 ) / 1000;
622     }
623     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner() {
624         _maxTxAmount = (_totalSupply * maxTXPercentage_base1000 ) / 1000;
625     }
626 
627     function setTxLimit(uint256 amount) external onlyOwner() {
628         _maxTxAmount = amount;
629     }
630 
631 // *** 
632 // Functions for the burning mechanism 
633 // *** 
634 
635     /**
636     * Burn an amount of tokens for the current wallet (if they have enough)
637     */
638     function burnTokens(uint256 amount) external {
639         // does this user have enough tokens to perform the burn
640         if(_balances[msg.sender] > amount) {
641             _basicTransfer(msg.sender, DEAD, amount);
642         }
643     }
644 
645 
646 // *** 
647 // End functions for the burning mechanism 
648 // *** 
649 
650     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
651         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
652 
653         if(sender != owner() && recipient != owner()){
654             require(tradingOpen,"Trading not open yet");
655         }
656 
657         bool inSell = (recipient == uniswapV2Pair);
658         bool inTransfer = (recipient != uniswapV2Pair && sender != uniswapV2Pair);
659 
660         if (recipient != address(this) && 
661             recipient != address(DEAD) && 
662             recipient != uniswapV2Pair && 
663             recipient != marketingWallet && 
664             recipient != devWallet && 
665             recipient != autoLiquidityReceiver
666         ){
667             uint256 heldTokens = balanceOf(recipient);
668             if(!isMaxExempt[recipient]) {
669                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
670             }
671         }
672 
673         if (sender == uniswapV2Pair &&
674             buyCooldownEnabled &&
675             !isTimelockExempt[recipient]
676         ){
677             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two buys");
678             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
679         }
680 
681         // Checks max transaction limit
682         // but no point if the recipient is exempt
683         // this check ensures that someone that is buying and is txnExempt then they are able to buy any amount
684         if(!isTxLimitExempt[recipient]) {
685             checkTxLimit(sender, amount);
686         }
687 
688         //Exchange tokens
689         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
690 
691         uint256 amountReceived = amount;
692 
693         // Do NOT take a fee if sender AND recipient are NOT the contract
694         // i.e. you are doing a transfer
695         if(inTransfer) {
696             if(transFee > 0) {
697                 amountReceived = takeTransferFee(sender, amount);
698             }
699         } else {
700             amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount, inSell) : amount;
701             
702             if(shouldSwapBack()){ swapBack(); }
703         }
704 
705         _balances[recipient] = _balances[recipient].add(amountReceived);
706 
707         emit Transfer(sender, recipient, amountReceived);
708         return true;
709     }
710 
711     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
712         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
713         _balances[recipient] = _balances[recipient].add(amount);
714         emit Transfer(sender, recipient, amount);
715         return true;
716     }
717 
718     function checkTxLimit(address sender, uint256 amount) internal view {
719         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
720     }
721 
722     function shouldTakeFee(address sender) internal view returns (bool) {
723         return !isFeeExempt[sender];
724     }
725 
726 // *** 
727 // Handle Fees
728 // *** 
729 
730     function takeTransferFee(address sender, uint256 amount) internal returns (uint256) {
731 
732         uint256 feeToTake = transFee;
733         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
734         
735         _balances[address(this)] = _balances[address(this)].add(feeAmount);
736         emit Transfer(sender, address(this), feeAmount);
737 
738         return amount.sub(feeAmount);
739     }
740 
741     function takeFee(address sender, uint256 amount, bool isSell) internal returns (uint256) {
742 
743         uint256 feeToTake = isSell ? swapTotalFee : buyTotalFee;
744         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
745         
746         _balances[address(this)] = _balances[address(this)].add(feeAmount);
747         emit Transfer(sender, address(this), feeAmount);
748 
749         return amount.sub(feeAmount);
750     }
751 
752 // *** 
753 // End Handle Fees
754 // *** 
755 
756     function shouldSwapBack() internal view returns (bool) {
757         return msg.sender != uniswapV2Pair
758         && !inSwap
759         && swapEnabled
760         && _balances[address(this)] >= swapThreshold;
761     }
762 
763     function clearStuckBalance(uint256 amountPercentage) external onlyOwner() {
764         uint256 amountETH = address(this).balance;
765         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
766     }
767 
768     function clearStuckBalance_sender(uint256 amountPercentage) external onlyOwner() {
769         uint256 amountETH = address(this).balance;
770         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
771     }
772 
773     // switch Trading
774     function tradingStatus(bool _status) public onlyOwner {
775         tradingOpen = _status;
776     }
777 
778     // enable cooldown between trades
779     function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
780         buyCooldownEnabled = _status;
781         cooldownTimerInterval = _interval;
782     }
783 
784     function swapBack() internal swapping {
785         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : swapLpFee;
786         uint256 amountToLiquify = swapAmount.mul(dynamicLiquidityFee).div(swapTotalFee).div(2);
787         uint256 amountToSwap = swapAmount.sub(amountToLiquify);
788 
789         address[] memory path = new address[](2);
790         path[0] = address(this);
791         path[1] = contractRouter.WETH();
792 
793         uint256 balanceBefore = address(this).balance;
794 
795         contractRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
796             amountToSwap,
797             0,
798             path,
799             address(this),
800             block.timestamp
801         );
802 
803         uint256 amountETH = address(this).balance.sub(balanceBefore);
804 
805         uint256 totalETHFee = swapTotalFee.sub(dynamicLiquidityFee.div(2));
806 
807         uint256 amountETHLiquidity = amountETH.mul(swapLpFee).div(totalETHFee).div(2);
808         uint256 amountETHMarketing = amountETH.mul(swapMarketing).div(totalETHFee);
809         uint256 amountETHTreasury = amountETH.mul(swapTreasuryFee).div(totalETHFee);
810 
811         (bool tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 30000}("");
812         (tmpSuccess,) = payable(devWallet).call{value: amountETHTreasury, gas: 30000}("");
813 
814         // Supress warning msg
815         tmpSuccess = false;
816 
817         if(amountToLiquify > 0){
818             contractRouter.addLiquidityETH{value: amountETHLiquidity}(
819                 address(this),
820                 amountToLiquify,
821                 0,
822                 0,
823                 autoLiquidityReceiver,
824                 block.timestamp
825             );
826             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
827         }
828     }
829 
830 // *** 
831 // Various exempt functions
832 // *** 
833 
834     function setIsFeeExempt(address holder, bool exempt) external onlyOwner() {
835         isFeeExempt[holder] = exempt;
836     }
837 
838     function setIsMaxExempt(address holder, bool exempt) external onlyOwner() {
839         isMaxExempt[holder] = exempt;
840     }
841 
842     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner() {
843         isTxLimitExempt[holder] = exempt;
844     }
845 
846     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner() {
847         isTimelockExempt[holder] = exempt;
848     }
849 
850 // *** 
851 // End various exempt functions
852 // *** 
853 
854 
855 // ***
856 // Start fee things
857 // ***
858 
859     function setTransFee(uint256 fee) external onlyOwner() {
860         transFee = fee;
861     }
862 
863     function setSwapFees(uint256 _newSwapLpFee, uint256 _newSwapMarketingFee, uint256 _newSwapTreasuryFee, uint256 _feeDenominator) external onlyOwner() {
864         swapLpFee = _newSwapLpFee;
865         swapMarketing = _newSwapMarketingFee;
866         swapTreasuryFee = _newSwapTreasuryFee;
867         swapTotalFee = _newSwapLpFee.add(_newSwapMarketingFee).add(_newSwapTreasuryFee);
868         feeDenominator = _feeDenominator;
869         require(swapTotalFee < 90, "Fees cannot be that high");
870     }
871 
872     function setBuyFees(uint256 buyTax) external onlyOwner() {
873         buyTotalFee = buyTax;
874     }
875 
876 // ***
877 // end fee stuff§2e sw. 
878 // ***
879 
880 
881 
882     function setTreasuryFeeReceiver(address _newWallet) external onlyOwner() {
883         isFeeExempt[devWallet] = false;
884         isFeeExempt[_newWallet] = true;
885         devWallet = _newWallet;
886     }
887 
888     function setMarketingWallet(address _newWallet) external onlyOwner() {
889         isFeeExempt[marketingWallet] = false;
890         isFeeExempt[_newWallet] = true;
891 
892         isMaxExempt[_newWallet] = true;
893 
894         marketingWallet = _newWallet;
895     }
896 
897     function setFeeReceivers(address _autoLiquidityReceiver, address _newMarketingWallet, address _newdevWallet ) external onlyOwner() {
898 
899         isFeeExempt[devWallet] = false;
900         isFeeExempt[_newdevWallet] = true;
901         isFeeExempt[marketingWallet] = false;
902         isFeeExempt[_newMarketingWallet] = true;
903 
904         isMaxExempt[_newMarketingWallet] = true;
905 
906         autoLiquidityReceiver = _autoLiquidityReceiver;
907         marketingWallet = _newMarketingWallet;
908         devWallet = _newdevWallet;
909     }
910 
911 // ***
912 // Swap settings
913 // ***
914 
915     function setSwapThresholdAmount(uint256 _amount) external onlyOwner() {
916         swapThreshold = _amount;
917     }
918 
919     function setSwapAmount(uint256 _amount) external onlyOwner() {
920         if(_amount > swapThreshold) {
921             swapAmount = swapThreshold;
922         } else {
923             swapAmount = _amount;
924         }        
925     }
926 
927 // ***
928 // End Swap settings
929 // ***
930 
931     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner() {
932         targetLiquidity = _target;
933         targetLiquidityDenominator = _denominator;
934     }
935 
936     function getCirculatingSupply() public view returns (uint256) {
937         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
938     }
939 
940     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
941         return accuracy.mul(balanceOf(uniswapV2Pair).mul(2)).div(getCirculatingSupply());
942     }
943 
944     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
945         return getLiquidityBacking(accuracy) > target;
946     }
947 
948     /* Airdrop */
949     function airDropCustom(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
950 
951         require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
952         require(addresses.length == tokens.length,"Mismatch between Address and token count");
953 
954         uint256 SCCC = 0;
955 
956         for(uint i=0; i < addresses.length; i++){
957             SCCC = SCCC + tokens[i];
958         }
959 
960         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
961 
962         for(uint i=0; i < addresses.length; i++){
963             _basicTransfer(from,addresses[i],tokens[i]);
964         }
965         
966     }
967 
968     function airDropFixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
969 
970         require(addresses.length < 801,"GAS Error: max airdrop limit is 800 addresses");
971 
972         uint256 SCCC = tokens * addresses.length;
973 
974         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
975 
976         for(uint i=0; i < addresses.length; i++){
977             _basicTransfer(from,addresses[i],tokens);
978         }
979     }
980 
981     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
982 
983 }