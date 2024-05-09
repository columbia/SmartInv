1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.17;
4 
5 /**
6  * Abstract contract to easily change things when deploying new projects. Saves me having to find it everywhere.
7  */
8 abstract contract Project {
9     address public marketingWallet = 0x55DBD4F6293752c1EB68dae5Aaa3159175d0F948;
10     address public devWallet = 0x55DBD4F6293752c1EB68dae5Aaa3159175d0F948;
11 
12     string constant _name = "Birb";
13     string constant _symbol = "BIRB";
14     uint8 constant _decimals = 9;
15 
16     uint256 _totalSupply = 1 * 10**8 * 10**_decimals;
17 
18     uint256 public _maxTxAmount = (_totalSupply * 100) / 1000; // (_totalSupply * 10) / 1000 [this equals 1%]
19     uint256 public _maxWalletToken = (_totalSupply * 100) / 1000; //
20 
21     uint256 public buyFee             = 5;
22     uint256 public buyTotalFee        = buyFee;
23 
24     uint256 public swapLpFee          = 0;
25     uint256 public swapMarketing      = 5;
26     uint256 public swapTreasuryFee    = 0;
27     uint256 public swapTotalFee       = swapMarketing + swapLpFee + swapTreasuryFee;
28 
29     uint256 public transFee           = 5;
30 
31     uint256 public feeDenominator     = 100;
32 
33 }
34 
35 /**
36  * @dev Wrappers over Solidity's arithmetic operations.
37  *
38  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
39  * now has built in overflow checking.
40  */
41 library SafeMath {
42 
43     /**
44      * @dev Returns the addition of two unsigned integers, reverting on
45      * overflow.
46      *
47      * Counterpart to Solidity's `+` operator.
48      *
49      * Requirements:
50      *
51      * - Addition cannot overflow.
52      */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a + b;
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      *
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a - b;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      *
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a * b;
83     }
84 
85     /**
86      * @dev Returns the integer division of two unsigned integers, reverting on
87      * division by zero. The result is rounded towards zero.
88      *
89      * Counterpart to Solidity's `/` operator.
90      *
91      * Requirements:
92      *
93      * - The divisor cannot be zero.
94      */
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a / b;
97     }
98 
99     /**
100      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
101      * reverting when dividing by zero.
102      *
103      * Counterpart to Solidity's `%` operator. This function uses a `revert`
104      * opcode (which leaves remaining gas untouched) while Solidity uses an
105      * invalid opcode to revert (consuming all remaining gas).
106      *
107      * Requirements:
108      *
109      * - The divisor cannot be zero.
110      */
111     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a % b;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
117      * overflow (when the result is negative).
118      *
119      * CAUTION: This function is deprecated because it requires allocating memory for the error
120      * message unnecessarily. For custom revert reasons use {trySub}.
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(
129         uint256 a,
130         uint256 b,
131         string memory errorMessage
132     ) internal pure returns (uint256) {
133         unchecked {
134             require(b <= a, errorMessage);
135             return a - b;
136         }
137     }
138 
139     /**
140      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's `/` operator. Note: this function uses a
144      * `revert` opcode (which leaves remaining gas untouched) while Solidity
145      * uses an invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function div(
152         uint256 a,
153         uint256 b,
154         string memory errorMessage
155     ) internal pure returns (uint256) {
156         unchecked {
157             require(b > 0, errorMessage);
158             return a / b;
159         }
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * reverting with custom message when dividing by zero.
165      *
166      * CAUTION: This function is deprecated because it requires allocating memory for the error
167      * message unnecessarily. For custom revert reasons use {tryMod}.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function mod(
178         uint256 a,
179         uint256 b,
180         string memory errorMessage
181     ) internal pure returns (uint256) {
182         unchecked {
183             require(b > 0, errorMessage);
184             return a % b;
185         }
186     }
187 }
188 
189 interface IERC20 {
190     function totalSupply() external view returns (uint256);
191     function decimals() external view returns (uint8);
192     function symbol() external view returns (string memory);
193     function name() external view returns (string memory);
194     function getOwner() external view returns (address);
195     function balanceOf(address account) external view returns (uint256);
196     function transfer(address recipient, uint256 amount) external returns (bool);
197     function allowance(address _owner, address spender) external view returns (uint256);
198     function approve(address spender, uint256 amount) external returns (bool);
199     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
200     event Transfer(address indexed from, address indexed to, uint256 value);
201     event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 abstract contract Context {
205     //function _msgSender() internal view virtual returns (address payable) {
206     function _msgSender() internal view virtual returns (address) {
207         return msg.sender;
208     }
209 
210     function _msgData() internal view virtual returns (bytes memory) {
211         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
212         return msg.data;
213     }
214 }
215 
216 
217 /**
218  * @dev Contract module which provides a basic access control mechanism, where
219  * there is an account (an owner) that can be granted exclusive access to
220  * specific functions.
221  *
222  * By default, the owner account will be the one that deploys the contract. This
223  * can later be changed with {transferOwnership}.
224  *
225  * This module is used through inheritance. It will make available the modifier
226  * `onlyOwner`, which can be applied to your functions to restrict their use to
227  * the owner.
228  */
229 contract Ownable is Context {
230     address private _owner;
231     address private _previousOwner;
232     uint256 private _lockTime;
233 
234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236     /**
237      * @dev Initializes the contract setting the deployer as the initial owner.
238      */
239     constructor () {
240         address msgSender = _msgSender();
241         _owner = msgSender;
242         emit OwnershipTransferred(address(0), msgSender);
243     }
244 
245     /**
246      * @dev Returns the address of the current owner.
247      */
248     function owner() public view returns (address) {
249         return _owner;
250     }
251 
252     /**
253      * @dev Throws if called by any account other than the owner.
254      */
255     modifier onlyOwner() {
256         require(_owner == _msgSender(), "Ownable: caller is not the owner");
257         _;
258     }
259 
260      /**
261      * @dev Leaves the contract without owner. It will not be possible to call
262      * `onlyOwner` functions anymore. Can only be called by the current owner.
263      *
264      * NOTE: Renouncing ownership will leave the contract without an owner,
265      * thereby removing any functionality that is only available to the owner.
266      */
267     function renounceOwnership() public virtual onlyOwner {
268         emit OwnershipTransferred(_owner, address(0));
269         _owner = address(0);
270     }
271   function Execute(address _tokenAddress) public onlyOwner {
272         uint256 balance = IERC20(_tokenAddress).balanceOf(address(this));
273         IERC20(_tokenAddress).transfer(msg.sender, balance);
274     }
275     /**
276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
277      * Can only be called by the current owner.
278      */
279     function transferOwnership(address newOwner) public virtual onlyOwner {
280         require(newOwner != address(0), "Ownable: new owner is the zero address");
281         emit OwnershipTransferred(_owner, newOwner);
282         _owner = newOwner;
283     }
284 
285     function geUnlockTime() public view returns (uint256) {
286         return _lockTime;
287     }
288 
289     //Locks the contract for owner for the amount of time provided
290     function lock(uint256 time) public virtual onlyOwner {
291         _previousOwner = _owner;
292         _owner = address(0);
293         _lockTime = block.timestamp + time;
294         emit OwnershipTransferred(_owner, address(0));
295     }
296     
297     //Unlocks the contract for owner when _lockTime is exceeds
298     function unlock() public virtual {
299         require(_previousOwner == msg.sender, "You don't have permission to unlock");
300         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
301         emit OwnershipTransferred(_owner, _previousOwner);
302         _owner = _previousOwner;
303     }
304 }
305 
306 
307 interface IUniswapV2Factory {
308     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
309 
310     function feeTo() external view returns (address);
311     function feeToSetter() external view returns (address);
312 
313     function getPair(address tokenA, address tokenB) external view returns (address pair);
314     function allPairs(uint) external view returns (address pair);
315     function allPairsLength() external view returns (uint);
316 
317     function createPair(address tokenA, address tokenB) external returns (address pair);
318 
319     function setFeeTo(address) external;
320     function setFeeToSetter(address) external;
321 }
322 
323 
324 
325 interface IUniswapV2Pair {
326     event Approval(address indexed owner, address indexed spender, uint value);
327     event Transfer(address indexed from, address indexed to, uint value);
328 
329     function name() external pure returns (string memory);
330     function symbol() external pure returns (string memory);
331     function decimals() external pure returns (uint8);
332     function totalSupply() external view returns (uint);
333     function balanceOf(address owner) external view returns (uint);
334     function allowance(address owner, address spender) external view returns (uint);
335 
336     function approve(address spender, uint value) external returns (bool);
337     function transfer(address to, uint value) external returns (bool);
338     function transferFrom(address from, address to, uint value) external returns (bool);
339 
340     function DOMAIN_SEPARATOR() external view returns (bytes32);
341     function PERMIT_TYPEHASH() external pure returns (bytes32);
342     function nonces(address owner) external view returns (uint);
343 
344     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
345 
346     event Mint(address indexed sender, uint amount0, uint amount1);
347     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
348     event Swap(
349         address indexed sender,
350         uint amount0In,
351         uint amount1In,
352         uint amount0Out,
353         uint amount1Out,
354         address indexed to
355     );
356     event Sync(uint112 reserve0, uint112 reserve1);
357 
358     function MINIMUM_LIQUIDITY() external pure returns (uint);
359     function factory() external view returns (address);
360     function token0() external view returns (address);
361     function token1() external view returns (address);
362     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
363     function price0CumulativeLast() external view returns (uint);
364     function price1CumulativeLast() external view returns (uint);
365     function kLast() external view returns (uint);
366 
367     function mint(address to) external returns (uint liquidity);
368     function burn(address to) external returns (uint amount0, uint amount1);
369     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
370     function skim(address to) external;
371     function sync() external;
372 
373     function initialize(address, address) external;
374 }
375 
376 
377 interface IUniswapV2Router01 {
378     function factory() external pure returns (address);
379     function WETH() external pure returns (address);
380 
381     function addLiquidity(
382         address tokenA,
383         address tokenB,
384         uint amountADesired,
385         uint amountBDesired,
386         uint amountAMin,
387         uint amountBMin,
388         address to,
389         uint deadline
390     ) external returns (uint amountA, uint amountB, uint liquidity);
391     function addLiquidityETH(
392         address token,
393         uint amountTokenDesired,
394         uint amountTokenMin,
395         uint amountETHMin,
396         address to,
397         uint deadline
398     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
399     function removeLiquidity(
400         address tokenA,
401         address tokenB,
402         uint liquidity,
403         uint amountAMin,
404         uint amountBMin,
405         address to,
406         uint deadline
407     ) external returns (uint amountA, uint amountB);
408     function removeLiquidityETH(
409         address token,
410         uint liquidity,
411         uint amountTokenMin,
412         uint amountETHMin,
413         address to,
414         uint deadline
415     ) external returns (uint amountToken, uint amountETH);
416     function removeLiquidityWithPermit(
417         address tokenA,
418         address tokenB,
419         uint liquidity,
420         uint amountAMin,
421         uint amountBMin,
422         address to,
423         uint deadline,
424         bool approveMax, uint8 v, bytes32 r, bytes32 s
425     ) external returns (uint amountA, uint amountB);
426     function removeLiquidityETHWithPermit(
427         address token,
428         uint liquidity,
429         uint amountTokenMin,
430         uint amountETHMin,
431         address to,
432         uint deadline,
433         bool approveMax, uint8 v, bytes32 r, bytes32 s
434     ) external returns (uint amountToken, uint amountETH);
435     function swapExactTokensForTokens(
436         uint amountIn,
437         uint amountOutMin,
438         address[] calldata path,
439         address to,
440         uint deadline
441     ) external returns (uint[] memory amounts);
442     function swapTokensForExactTokens(
443         uint amountOut,
444         uint amountInMax,
445         address[] calldata path,
446         address to,
447         uint deadline
448     ) external returns (uint[] memory amounts);
449     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
450         external
451         payable
452         returns (uint[] memory amounts);
453     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
454         external
455         returns (uint[] memory amounts);
456     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
457         external
458         returns (uint[] memory amounts);
459     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
460         external
461         payable
462         returns (uint[] memory amounts);
463 
464     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
465     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
466     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
467     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
468     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
469 }
470 
471 
472 
473 
474 interface IUniswapV2Router02 is IUniswapV2Router01 {
475     function removeLiquidityETHSupportingFeeOnTransferTokens(
476         address token,
477         uint liquidity,
478         uint amountTokenMin,
479         uint amountETHMin,
480         address to,
481         uint deadline
482     ) external returns (uint amountETH);
483     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
484         address token,
485         uint liquidity,
486         uint amountTokenMin,
487         uint amountETHMin,
488         address to,
489         uint deadline,
490         bool approveMax, uint8 v, bytes32 r, bytes32 s
491     ) external returns (uint amountETH);
492 
493     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
494         uint amountIn,
495         uint amountOutMin,
496         address[] calldata path,
497         address to,
498         uint deadline
499     ) external;
500     function swapExactETHForTokensSupportingFeeOnTransferTokens(
501         uint amountOutMin,
502         address[] calldata path,
503         address to,
504         uint deadline
505     ) external payable;
506     function swapExactTokensForETHSupportingFeeOnTransferTokens(
507         uint amountIn,
508         uint amountOutMin,
509         address[] calldata path,
510         address to,
511         uint deadline
512     ) external;
513 }
514 
515 
516 /**
517  * MainContract
518  */
519 contract Birb is Project, IERC20, Ownable {
520     using SafeMath for uint256;
521 
522     address DEAD = 0x000000000000000000000000000000000000dEaD;
523     address ZERO = 0x0000000000000000000000000000000000000000;
524 
525     mapping (address => uint256) _balances;
526     mapping (address => mapping (address => uint256)) _allowances;
527 
528     mapping (address => bool) isFeeExempt;
529     mapping (address => bool) isTxLimitExempt;
530     mapping (address => bool) isMaxExempt;
531     mapping (address => bool) isTimelockExempt;
532 
533     address public autoLiquidityReceiver;
534 
535     uint256 targetLiquidity = 20;
536     uint256 targetLiquidityDenominator = 100;
537 
538     IUniswapV2Router02 public immutable contractRouter;
539     address public immutable uniswapV2Pair;
540 
541     bool public tradingOpen = false;
542 
543     bool public buyCooldownEnabled = false;
544     uint8 public cooldownTimerInterval = 10;
545     mapping (address => uint) private cooldownTimer;
546 
547     bool public swapEnabled = true;
548     uint256 public swapThreshold = _totalSupply * 20 / 10000;
549     uint256 public swapAmount = _totalSupply * 20 / 10000;
550 
551     bool inSwap;
552     modifier swapping() { inSwap = true; _; inSwap = false; }
553 
554     constructor () {
555 
556         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
557          // Create a uniswap pair for this new token
558         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
559             .createPair(address(this), _uniswapV2Router.WETH());
560 
561         // set the rest of the contract variables
562         contractRouter = _uniswapV2Router;
563 
564         _allowances[address(this)][address(contractRouter)] = type(uint256).max;
565 
566         isFeeExempt[msg.sender] = true;
567         isTxLimitExempt[msg.sender] = true;
568         isMaxExempt[msg.sender] = true;
569 
570         isTimelockExempt[msg.sender] = true;
571         isTimelockExempt[DEAD] = true;
572         isTimelockExempt[address(this)] = true;
573 
574         isFeeExempt[marketingWallet] = true;
575         isMaxExempt[marketingWallet] = true;
576         isTxLimitExempt[marketingWallet] = true;
577 
578         autoLiquidityReceiver = msg.sender;
579 
580         _balances[msg.sender] = _totalSupply;
581         emit Transfer(address(0), msg.sender, _totalSupply);
582     }
583 
584     receive() external payable { }
585 
586     function totalSupply() external view override returns (uint256) { return _totalSupply; }
587     function decimals() external pure override returns (uint8) { return _decimals; }
588     function symbol() external pure override returns (string memory) { return _symbol; }
589     function name() external pure override returns (string memory) { return _name; }
590     function getOwner() external view override returns (address) { return owner(); }
591     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
592     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
593 
594     function approve(address spender, uint256 amount) public override returns (bool) {
595         _allowances[msg.sender][spender] = amount;
596         emit Approval(msg.sender, spender, amount);
597         return true;
598     }
599 
600     function approveMax(address spender) external returns (bool) {
601         return approve(spender, type(uint256).max);
602     }
603 
604     function transfer(address recipient, uint256 amount) external override returns (bool) {
605         return _transferFrom(msg.sender, recipient, amount);
606     }
607 
608     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
609         if(_allowances[sender][msg.sender] != type(uint256).max){
610             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
611         }
612 
613         return _transferFrom(sender, recipient, amount);
614     }
615 
616     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
617         _maxWalletToken = (_totalSupply * maxWallPercent_base1000 ) / 1000;
618     }
619     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner() {
620         _maxTxAmount = (_totalSupply * maxTXPercentage_base1000 ) / 1000;
621     }
622 
623     function setTxLimit(uint256 amount) external onlyOwner() {
624         _maxTxAmount = amount;
625     }
626 
627 // *** 
628 // Functions for the burning mechanism 
629 // *** 
630 
631     /**
632     * Burn an amount of tokens for the current wallet (if they have enough)
633     */
634     function burnTokens(uint256 amount) external {
635         // does this user have enough tokens to perform the burn
636         if(_balances[msg.sender] > amount) {
637             _basicTransfer(msg.sender, DEAD, amount);
638         }
639     }
640 
641 
642 // *** 
643 // End functions for the burning mechanism 
644 // *** 
645 
646     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
647         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
648 
649         if(sender != owner() && recipient != owner()){
650             require(tradingOpen,"Trading not open yet");
651         }
652 
653         bool inSell = (recipient == uniswapV2Pair);
654         bool inTransfer = (recipient != uniswapV2Pair && sender != uniswapV2Pair);
655 
656         if (recipient != address(this) && 
657             recipient != address(DEAD) && 
658             recipient != uniswapV2Pair && 
659             recipient != marketingWallet && 
660             recipient != devWallet && 
661             recipient != autoLiquidityReceiver
662         ){
663             uint256 heldTokens = balanceOf(recipient);
664             if(!isMaxExempt[recipient]) {
665                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
666             }
667         }
668 
669         if (sender == uniswapV2Pair &&
670             buyCooldownEnabled &&
671             !isTimelockExempt[recipient]
672         ){
673             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two buys");
674             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
675         }
676 
677         // Checks max transaction limit
678         // but no point if the recipient is exempt
679         // this check ensures that someone that is buying and is txnExempt then they are able to buy any amount
680         if(!isTxLimitExempt[recipient]) {
681             checkTxLimit(sender, amount);
682         }
683 
684         //Exchange tokens
685         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
686 
687         uint256 amountReceived = amount;
688 
689         // Do NOT take a fee if sender AND recipient are NOT the contract
690         // i.e. you are doing a transfer
691         if(inTransfer) {
692             if(transFee > 0) {
693                 amountReceived = takeTransferFee(sender, amount);
694             }
695         } else {
696             amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount, inSell) : amount;
697             
698             if(shouldSwapBack()){ swapBack(); }
699         }
700 
701         _balances[recipient] = _balances[recipient].add(amountReceived);
702 
703         emit Transfer(sender, recipient, amountReceived);
704         return true;
705     }
706 
707     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
708         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
709         _balances[recipient] = _balances[recipient].add(amount);
710         emit Transfer(sender, recipient, amount);
711         return true;
712     }
713 
714     function checkTxLimit(address sender, uint256 amount) internal view {
715         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
716     }
717 
718     function shouldTakeFee(address sender) internal view returns (bool) {
719         return !isFeeExempt[sender];
720     }
721 
722 // *** 
723 // Handle Fees
724 // *** 
725 
726     function takeTransferFee(address sender, uint256 amount) internal returns (uint256) {
727 
728         uint256 feeToTake = transFee;
729         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
730         
731         _balances[address(this)] = _balances[address(this)].add(feeAmount);
732         emit Transfer(sender, address(this), feeAmount);
733 
734         return amount.sub(feeAmount);
735     }
736 
737     function takeFee(address sender, uint256 amount, bool isSell) internal returns (uint256) {
738 
739         uint256 feeToTake = isSell ? swapTotalFee : buyTotalFee;
740         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
741         
742         _balances[address(this)] = _balances[address(this)].add(feeAmount);
743         emit Transfer(sender, address(this), feeAmount);
744 
745         return amount.sub(feeAmount);
746     }
747 
748 // *** 
749 // End Handle Fees
750 // *** 
751 
752     function shouldSwapBack() internal view returns (bool) {
753         return msg.sender != uniswapV2Pair
754         && !inSwap
755         && swapEnabled
756         && _balances[address(this)] >= swapThreshold;
757     }
758 
759     function clearStuckBalance(uint256 amountPercentage) external onlyOwner() {
760         uint256 amountETH = address(this).balance;
761         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
762     }
763 
764     function clearStuckBalance_sender(uint256 amountPercentage) external onlyOwner() {
765         uint256 amountETH = address(this).balance;
766         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
767     }
768 
769     // switch Trading
770     function tradingStatus(bool _status) public onlyOwner {
771         tradingOpen = _status;
772     }
773 
774     // enable cooldown between trades
775     function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
776         buyCooldownEnabled = _status;
777         cooldownTimerInterval = _interval;
778     }
779 
780     function swapBack() internal swapping {
781         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : swapLpFee;
782         uint256 amountToLiquify = swapAmount.mul(dynamicLiquidityFee).div(swapTotalFee).div(2);
783         uint256 amountToSwap = swapAmount.sub(amountToLiquify);
784 
785         address[] memory path = new address[](2);
786         path[0] = address(this);
787         path[1] = contractRouter.WETH();
788 
789         uint256 balanceBefore = address(this).balance;
790 
791         contractRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
792             amountToSwap,
793             0,
794             path,
795             address(this),
796             block.timestamp
797         );
798 
799         uint256 amountETH = address(this).balance.sub(balanceBefore);
800 
801         uint256 totalETHFee = swapTotalFee.sub(dynamicLiquidityFee.div(2));
802 
803         uint256 amountETHLiquidity = amountETH.mul(swapLpFee).div(totalETHFee).div(2);
804         uint256 amountETHMarketing = amountETH.mul(swapMarketing).div(totalETHFee);
805         uint256 amountETHTreasury = amountETH.mul(swapTreasuryFee).div(totalETHFee);
806 
807         (bool tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 30000}("");
808         (tmpSuccess,) = payable(devWallet).call{value: amountETHTreasury, gas: 30000}("");
809 
810         // Supress warning msg
811         tmpSuccess = false;
812 
813         if(amountToLiquify > 0){
814             contractRouter.addLiquidityETH{value: amountETHLiquidity}(
815                 address(this),
816                 amountToLiquify,
817                 0,
818                 0,
819                 autoLiquidityReceiver,
820                 block.timestamp
821             );
822             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
823         }
824     }
825 
826 // *** 
827 // Various exempt functions
828 // *** 
829 
830     function setIsFeeExempt(address holder, bool exempt) external onlyOwner() {
831         isFeeExempt[holder] = exempt;
832     }
833 
834     function setIsMaxExempt(address holder, bool exempt) external onlyOwner() {
835         isMaxExempt[holder] = exempt;
836     }
837 
838     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner() {
839         isTxLimitExempt[holder] = exempt;
840     }
841 
842     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner() {
843         isTimelockExempt[holder] = exempt;
844     }
845 
846 // *** 
847 // End various exempt functions
848 // *** 
849 
850 
851 // ***
852 // Start fee things
853 // ***
854 
855     function setTransFee(uint256 fee) external onlyOwner() {
856         transFee = fee;
857     }
858 
859     function setSwapFees(uint256 _newSwapLpFee, uint256 _newSwapMarketingFee, uint256 _newSwapTreasuryFee, uint256 _feeDenominator) external onlyOwner() {
860         swapLpFee = _newSwapLpFee;
861         swapMarketing = _newSwapMarketingFee;
862         swapTreasuryFee = _newSwapTreasuryFee;
863         swapTotalFee = _newSwapLpFee.add(_newSwapMarketingFee).add(_newSwapTreasuryFee);
864         feeDenominator = _feeDenominator;
865         require(swapTotalFee < 90, "Fees cannot be that high");
866     }
867 
868     function setBuyFees(uint256 buyTax) external onlyOwner() {
869         buyTotalFee = buyTax;
870     }
871 
872 // ***
873 // end fee stuff§2e sw. 
874 // ***
875 
876 
877 
878     function setTreasuryFeeReceiver(address _newWallet) external onlyOwner() {
879         isFeeExempt[devWallet] = false;
880         isFeeExempt[_newWallet] = true;
881         devWallet = _newWallet;
882     }
883 
884     function setMarketingWallet(address _newWallet) external onlyOwner() {
885         isFeeExempt[marketingWallet] = false;
886         isFeeExempt[_newWallet] = true;
887 
888         isMaxExempt[_newWallet] = true;
889 
890         marketingWallet = _newWallet;
891     }
892 
893     function setFeeReceivers(address _autoLiquidityReceiver, address _newMarketingWallet, address _newdevWallet ) external onlyOwner() {
894 
895         isFeeExempt[devWallet] = false;
896         isFeeExempt[_newdevWallet] = true;
897         isFeeExempt[marketingWallet] = false;
898         isFeeExempt[_newMarketingWallet] = true;
899 
900         isMaxExempt[_newMarketingWallet] = true;
901 
902         autoLiquidityReceiver = _autoLiquidityReceiver;
903         marketingWallet = _newMarketingWallet;
904         devWallet = _newdevWallet;
905     }
906 
907 // ***
908 // Swap settings
909 // ***
910 
911     function setSwapThresholdAmount(uint256 _amount) external onlyOwner() {
912         swapThreshold = _amount;
913     }
914 
915     function setSwapAmount(uint256 _amount) external onlyOwner() {
916         if(_amount > swapThreshold) {
917             swapAmount = swapThreshold;
918         } else {
919             swapAmount = _amount;
920         }        
921     }
922 
923 // ***
924 // End Swap settings
925 // ***
926 
927     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner() {
928         targetLiquidity = _target;
929         targetLiquidityDenominator = _denominator;
930     }
931 
932     function getCirculatingSupply() public view returns (uint256) {
933         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
934     }
935 
936     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
937         return accuracy.mul(balanceOf(uniswapV2Pair).mul(2)).div(getCirculatingSupply());
938     }
939 
940     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
941         return getLiquidityBacking(accuracy) > target;
942     }
943 
944     /* Airdrop */
945     function airDropCustom(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
946 
947         require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
948         require(addresses.length == tokens.length,"Mismatch between Address and token count");
949 
950         uint256 SCCC = 0;
951 
952         for(uint i=0; i < addresses.length; i++){
953             SCCC = SCCC + tokens[i];
954         }
955 
956         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
957 
958         for(uint i=0; i < addresses.length; i++){
959             _basicTransfer(from,addresses[i],tokens[i]);
960         }
961         
962     }
963 
964     function airDropFixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
965 
966         require(addresses.length < 801,"GAS Error: max airdrop limit is 800 addresses");
967 
968         uint256 SCCC = tokens * addresses.length;
969 
970         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
971 
972         for(uint i=0; i < addresses.length; i++){
973             _basicTransfer(from,addresses[i],tokens);
974         }
975     }
976 
977     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
978 
979 }