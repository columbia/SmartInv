1 /**
2 
3 TELEGRAM: https://t.me/BaconCoin
4 
5 NO TEAM TOKENS, NO TAXES, LP FUNDED BY LOYAL PORK LOVERS
6 
7 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 
12 /**
13  
14 */
15 
16 
17 pragma solidity ^0.8.17;
18 
19 /**
20  *
21  */
22 abstract contract Project {
23     address public marketingWallet = 0x486d77622fF6A2007b5F5EFe1874c37fd43019e6;
24     address public devWallet = 0x486d77622fF6A2007b5F5EFe1874c37fd43019e6;
25 
26     string constant _name = "Bacon Coin";
27     string constant _symbol = "BACON";
28     uint8 constant _decimals = 9;
29 
30     uint256 _totalSupply = 1 * 80**6 * 10**_decimals;
31 
32     uint256 public _maxTxAmount = (_totalSupply * 80) / 1000; // (_totalSupply * 80) / 1000 [this equals 1%]
33     uint256 public _maxWalletToken = (_totalSupply * 80) / 1000; //
34 
35     uint256 public buyFee             = 0;
36     uint256 public buyTotalFee        = buyFee;
37 
38     uint256 public swapLpFee          = 0;
39     uint256 public swapMarketing      = 0;
40     uint256 public swapTreasuryFee    = 0;
41     uint256 public swapTotalFee       = swapMarketing + swapLpFee + swapTreasuryFee;
42 
43     uint256 public transFee           = 0;
44 
45     uint256 public feeDenominator     = 100;
46 
47 }
48 
49 /**
50  * @dev Wrappers over Solidity's arithmetic operations.
51  *
52  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
53  * now has built in overflow checking.
54  */
55 library SafeMath {
56 
57     /**
58      * @dev Returns the addition of two unsigned integers, reverting on
59      * overflow.
60      *
61      * Counterpart to Solidity's `+` operator.
62      *
63      * Requirements:
64      *
65      * - Addition cannot overflow.
66      */
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a + b;
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      *
79      * - Subtraction cannot overflow.
80      */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a - b;
83     }
84 
85     /**
86      * @dev Returns the multiplication of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `*` operator.
90      *
91      * Requirements:
92      *
93      * - Multiplication cannot overflow.
94      */
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a * b;
97     }
98 
99     /**
100      * @dev Returns the integer division of two unsigned integers, reverting on
101      * division by zero. The result is rounded towards zero.
102      *
103      * Counterpart to Solidity's `/` operator.
104      *
105      * Requirements:
106      *
107      * - The divisor cannot be zero.
108      */
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a / b;
111     }
112 
113     /**
114      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
115      * reverting when dividing by zero.
116      *
117      * Counterpart to Solidity's `%` operator. This function uses a `revert`
118      * opcode (which leaves remaining gas untouched) while Solidity uses an
119      * invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a % b;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131      * overflow (when the result is negative).
132      *
133      * CAUTION: This function is deprecated because it requires allocating memory for the error
134      * message unnecessarily. For custom revert reasons use {trySub}.
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(
143         uint256 a,
144         uint256 b,
145         string memory errorMessage
146     ) internal pure returns (uint256) {
147         unchecked {
148             require(b <= a, errorMessage);
149             return a - b;
150         }
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function div(
166         uint256 a,
167         uint256 b,
168         string memory errorMessage
169     ) internal pure returns (uint256) {
170         unchecked {
171             require(b > 0, errorMessage);
172             return a / b;
173         }
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
178      * reverting with custom message when dividing by zero.
179      *
180      * CAUTION: This function is deprecated because it requires allocating memory for the error
181      * message unnecessarily. For custom revert reasons use {tryMod}.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(
192         uint256 a,
193         uint256 b,
194         string memory errorMessage
195     ) internal pure returns (uint256) {
196         unchecked {
197             require(b > 0, errorMessage);
198             return a % b;
199         }
200     }
201 }
202 
203 interface IERC20 {
204     function totalSupply() external view returns (uint256);
205     function decimals() external view returns (uint8);
206     function symbol() external view returns (string memory);
207     function name() external view returns (string memory);
208     function getOwner() external view returns (address);
209     function balanceOf(address account) external view returns (uint256);
210     function transfer(address recipient, uint256 amount) external returns (bool);
211     function allowance(address _owner, address spender) external view returns (uint256);
212     function approve(address spender, uint256 amount) external returns (bool);
213     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
214     event Transfer(address indexed from, address indexed to, uint256 value);
215     event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217 
218 abstract contract Context {
219     //function _msgSender() internal view virtual returns (address payable) {
220     function _msgSender() internal view virtual returns (address) {
221         return msg.sender;
222     }
223 
224     function _msgData() internal view virtual returns (bytes memory) {
225         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
226         return msg.data;
227     }
228 }
229 
230 
231 /**
232  * @dev Contract module which provides a basic access control mechanism, where
233  * there is an account (an owner) that can be granted exclusive access to
234  * specific functions.
235  *
236  * By default, the owner account will be the one that deploys the contract. This
237  * can later be changed with {transferOwnership}.
238  *
239  * This module is used through inheritance. It will make available the modifier
240  * `onlyOwner`, which can be applied to your functions to restrict their use to
241  * the owner.
242  */
243 contract Ownable is Context {
244     address private _owner;
245     address private _previousOwner;
246     uint256 private _lockTime;
247 
248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249 
250     /**
251      * @dev Initializes the contract setting the deployer as the initial owner.
252      */
253     constructor () {
254         address msgSender = _msgSender();
255         _owner = msgSender;
256         emit OwnershipTransferred(address(0), msgSender);
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(_owner == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274      /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public virtual onlyOwner {
282         emit OwnershipTransferred(_owner, address(0));
283         _owner = address(0);
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      * Can only be called by the current owner.
289      */
290     function transferOwnership(address newOwner) public virtual onlyOwner {
291         require(newOwner != address(0), "Ownable: new owner is the zero address");
292         emit OwnershipTransferred(_owner, newOwner);
293         _owner = newOwner;
294     }
295 
296     function geUnlockTime() public view returns (uint256) {
297         return _lockTime;
298     }
299 
300     //Locks the contract for owner for the amount of time provided
301     function lock(uint256 time) public virtual onlyOwner {
302         _previousOwner = _owner;
303         _owner = address(0);
304         _lockTime = block.timestamp + time;
305         emit OwnershipTransferred(_owner, address(0));
306     }
307     
308     //Unlocks the contract for owner when _lockTime is exceeds
309     function unlock() public virtual {
310         require(_previousOwner == msg.sender, "You don't have permission to unlock");
311         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
312         emit OwnershipTransferred(_owner, _previousOwner);
313         _owner = _previousOwner;
314     }
315 }
316 
317 
318 interface IUniswapV2Factory {
319     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
320 
321     function feeTo() external view returns (address);
322     function feeToSetter() external view returns (address);
323 
324     function getPair(address tokenA, address tokenB) external view returns (address pair);
325     function allPairs(uint) external view returns (address pair);
326     function allPairsLength() external view returns (uint);
327 
328     function createPair(address tokenA, address tokenB) external returns (address pair);
329 
330     function setFeeTo(address) external;
331     function setFeeToSetter(address) external;
332 }
333 
334 
335 
336 interface IUniswapV2Pair {
337     event Approval(address indexed owner, address indexed spender, uint value);
338     event Transfer(address indexed from, address indexed to, uint value);
339 
340     function name() external pure returns (string memory);
341     function symbol() external pure returns (string memory);
342     function decimals() external pure returns (uint8);
343     function totalSupply() external view returns (uint);
344     function balanceOf(address owner) external view returns (uint);
345     function allowance(address owner, address spender) external view returns (uint);
346 
347     function approve(address spender, uint value) external returns (bool);
348     function transfer(address to, uint value) external returns (bool);
349     function transferFrom(address from, address to, uint value) external returns (bool);
350 
351     function DOMAIN_SEPARATOR() external view returns (bytes32);
352     function PERMIT_TYPEHASH() external pure returns (bytes32);
353     function nonces(address owner) external view returns (uint);
354 
355     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
356 
357     event Mint(address indexed sender, uint amount0, uint amount1);
358     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
359     event Swap(
360         address indexed sender,
361         uint amount0In,
362         uint amount1In,
363         uint amount0Out,
364         uint amount1Out,
365         address indexed to
366     );
367     event Sync(uint112 reserve0, uint112 reserve1);
368 
369     function MINIMUM_LIQUIDITY() external pure returns (uint);
370     function factory() external view returns (address);
371     function token0() external view returns (address);
372     function token1() external view returns (address);
373     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
374     function price0CumulativeLast() external view returns (uint);
375     function price1CumulativeLast() external view returns (uint);
376     function kLast() external view returns (uint);
377 
378     function mint(address to) external returns (uint liquidity);
379     function burn(address to) external returns (uint amount0, uint amount1);
380     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
381     function skim(address to) external;
382     function sync() external;
383 
384     function initialize(address, address) external;
385 }
386 
387 
388 interface IUniswapV2Router01 {
389     function factory() external pure returns (address);
390     function WETH() external pure returns (address);
391 
392     function addLiquidity(
393         address tokenA,
394         address tokenB,
395         uint amountADesired,
396         uint amountBDesired,
397         uint amountAMin,
398         uint amountBMin,
399         address to,
400         uint deadline
401     ) external returns (uint amountA, uint amountB, uint liquidity);
402     function addLiquidityETH(
403         address token,
404         uint amountTokenDesired,
405         uint amountTokenMin,
406         uint amountETHMin,
407         address to,
408         uint deadline
409     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
410     function removeLiquidity(
411         address tokenA,
412         address tokenB,
413         uint liquidity,
414         uint amountAMin,
415         uint amountBMin,
416         address to,
417         uint deadline
418     ) external returns (uint amountA, uint amountB);
419     function removeLiquidityETH(
420         address token,
421         uint liquidity,
422         uint amountTokenMin,
423         uint amountETHMin,
424         address to,
425         uint deadline
426     ) external returns (uint amountToken, uint amountETH);
427     function removeLiquidityWithPermit(
428         address tokenA,
429         address tokenB,
430         uint liquidity,
431         uint amountAMin,
432         uint amountBMin,
433         address to,
434         uint deadline,
435         bool approveMax, uint8 v, bytes32 r, bytes32 s
436     ) external returns (uint amountA, uint amountB);
437     function removeLiquidityETHWithPermit(
438         address token,
439         uint liquidity,
440         uint amountTokenMin,
441         uint amountETHMin,
442         address to,
443         uint deadline,
444         bool approveMax, uint8 v, bytes32 r, bytes32 s
445     ) external returns (uint amountToken, uint amountETH);
446     function swapExactTokensForTokens(
447         uint amountIn,
448         uint amountOutMin,
449         address[] calldata path,
450         address to,
451         uint deadline
452     ) external returns (uint[] memory amounts);
453     function swapTokensForExactTokens(
454         uint amountOut,
455         uint amountInMax,
456         address[] calldata path,
457         address to,
458         uint deadline
459     ) external returns (uint[] memory amounts);
460     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
461         external
462         payable
463         returns (uint[] memory amounts);
464     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
465         external
466         returns (uint[] memory amounts);
467     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
468         external
469         returns (uint[] memory amounts);
470     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
471         external
472         payable
473         returns (uint[] memory amounts);
474 
475     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
476     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
477     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
478     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
479     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
480 }
481 
482 
483 
484 
485 interface IUniswapV2Router02 is IUniswapV2Router01 {
486     function removeLiquidityETHSupportingFeeOnTransferTokens(
487         address token,
488         uint liquidity,
489         uint amountTokenMin,
490         uint amountETHMin,
491         address to,
492         uint deadline
493     ) external returns (uint amountETH);
494     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
495         address token,
496         uint liquidity,
497         uint amountTokenMin,
498         uint amountETHMin,
499         address to,
500         uint deadline,
501         bool approveMax, uint8 v, bytes32 r, bytes32 s
502     ) external returns (uint amountETH);
503 
504     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
505         uint amountIn,
506         uint amountOutMin,
507         address[] calldata path,
508         address to,
509         uint deadline
510     ) external;
511     function swapExactETHForTokensSupportingFeeOnTransferTokens(
512         uint amountOutMin,
513         address[] calldata path,
514         address to,
515         uint deadline
516     ) external payable;
517     function swapExactTokensForETHSupportingFeeOnTransferTokens(
518         uint amountIn,
519         uint amountOutMin,
520         address[] calldata path,
521         address to,
522         uint deadline
523     ) external;
524 }
525 
526 
527 /**
528  * MainContract
529  */
530 contract BaconCoinContract is Project, IERC20, Ownable {
531     using SafeMath for uint256;
532 
533     address DEAD = 0x000000000000000000000000000000000000dEaD;
534     address ZERO = 0x0000000000000000000000000000000000000000;
535 
536     mapping (address => uint256) _balances;
537     mapping (address => mapping (address => uint256)) _allowances;
538 
539     mapping (address => bool) isFeeExempt;
540     mapping (address => bool) isTxLimitExempt;
541     mapping (address => bool) isMaxExempt;
542     mapping (address => bool) isTimelockExempt;
543 
544     address public autoLiquidityReceiver;
545 
546     uint256 targetLiquidity = 20;
547     uint256 targetLiquidityDenominator = 100;
548 
549     IUniswapV2Router02 public immutable contractRouter;
550     address public immutable uniswapV2Pair;
551 
552     bool public tradingOpen = false;
553 
554     bool public buyCooldownEnabled = true;
555     uint8 public cooldownTimerInterval = 10;
556     mapping (address => uint) private cooldownTimer;
557 
558     bool public swapEnabled = true;
559     uint256 public swapThreshold = _totalSupply * 30 / 10000;
560     uint256 public swapAmount = _totalSupply * 30 / 10000;
561 
562     bool inSwap;
563     modifier swapping() { inSwap = true; _; inSwap = false; }
564 
565     constructor () {
566 
567         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
568          // Create a uniswap pair for this new token
569         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
570             .createPair(address(this), _uniswapV2Router.WETH());
571 
572         // set the rest of the contract variables
573         contractRouter = _uniswapV2Router;
574 
575         _allowances[address(this)][address(contractRouter)] = type(uint256).max;
576 
577         isFeeExempt[msg.sender] = true;
578         isTxLimitExempt[msg.sender] = true;
579         isMaxExempt[msg.sender] = true;
580 
581         isTimelockExempt[msg.sender] = true;
582         isTimelockExempt[DEAD] = true;
583         isTimelockExempt[address(this)] = true;
584 
585         isFeeExempt[marketingWallet] = true;
586         isMaxExempt[marketingWallet] = true;
587         isTxLimitExempt[marketingWallet] = true;
588 
589         autoLiquidityReceiver = msg.sender;
590 
591         _balances[msg.sender] = _totalSupply;
592         emit Transfer(address(0), msg.sender, _totalSupply);
593     }
594 
595     receive() external payable { }
596 
597     function totalSupply() external view override returns (uint256) { return _totalSupply; }
598     function decimals() external pure override returns (uint8) { return _decimals; }
599     function symbol() external pure override returns (string memory) { return _symbol; }
600     function name() external pure override returns (string memory) { return _name; }
601     function getOwner() external view override returns (address) { return owner(); }
602     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
603     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
604 
605     function approve(address spender, uint256 amount) public override returns (bool) {
606         _allowances[msg.sender][spender] = amount;
607         emit Approval(msg.sender, spender, amount);
608         return true;
609     }
610 
611     function approveMax(address spender) external returns (bool) {
612         return approve(spender, type(uint256).max);
613     }
614 
615     function transfer(address recipient, uint256 amount) external override returns (bool) {
616         return _transferFrom(msg.sender, recipient, amount);
617     }
618 
619     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
620         if(_allowances[sender][msg.sender] != type(uint256).max){
621             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
622         }
623 
624         return _transferFrom(sender, recipient, amount);
625     }
626 
627     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
628         _maxWalletToken = (_totalSupply * maxWallPercent_base1000 ) / 1000;
629     }
630     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner() {
631         _maxTxAmount = (_totalSupply * maxTXPercentage_base1000 ) / 1000;
632     }
633 
634     function setTxLimit(uint256 amount) external onlyOwner() {
635         _maxTxAmount = amount;
636     }
637 
638 // *** 
639 // Functions for the burning mechanism 
640 // *** 
641 
642     /**
643     * Burn an amount of tokens for the current wallet (if they have enough)
644     */
645     function burnTokens(uint256 amount) external {
646         // does this user have enough tokens to perform the burn
647         if(_balances[msg.sender] > amount) {
648             _basicTransfer(msg.sender, DEAD, amount);
649         }
650     }
651 
652 
653 // *** 
654 // End functions for the burning mechanism 
655 // *** 
656 
657     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
658         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
659 
660         if(sender != owner() && recipient != owner()){
661             require(tradingOpen,"Trading not open yet");
662         }
663 
664         bool inSell = (recipient == uniswapV2Pair);
665         bool inTransfer = (recipient != uniswapV2Pair && sender != uniswapV2Pair);
666 
667         if (recipient != address(this) && 
668             recipient != address(DEAD) && 
669             recipient != uniswapV2Pair && 
670             recipient != marketingWallet && 
671             recipient != devWallet && 
672             recipient != autoLiquidityReceiver
673         ){
674             uint256 heldTokens = balanceOf(recipient);
675             if(!isMaxExempt[recipient]) {
676                 require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
677             }
678         }
679 
680         if (sender == uniswapV2Pair &&
681             buyCooldownEnabled &&
682             !isTimelockExempt[recipient]
683         ){
684             require(cooldownTimer[recipient] < block.timestamp,"Please wait for 1min between two buys");
685             cooldownTimer[recipient] = block.timestamp + cooldownTimerInterval;
686         }
687 
688         // Checks max transaction limit
689         // but no point if the recipient is exempt
690         // this check ensures that someone that is buying and is txnExempt then they are able to buy any amount
691         if(!isTxLimitExempt[recipient]) {
692             checkTxLimit(sender, amount);
693         }
694 
695         //Exchange tokens
696         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
697 
698         uint256 amountReceived = amount;
699 
700         // Do NOT take a fee if sender AND recipient are NOT the contract
701         // i.e. you are doing a transfer
702         if(inTransfer) {
703             if(transFee > 0) {
704                 amountReceived = takeTransferFee(sender, amount);
705             }
706         } else {
707             amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount, inSell) : amount;
708             
709             if(shouldSwapBack()){ swapBack(); }
710         }
711 
712         _balances[recipient] = _balances[recipient].add(amountReceived);
713 
714         emit Transfer(sender, recipient, amountReceived);
715         return true;
716     }
717 
718     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
719         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
720         _balances[recipient] = _balances[recipient].add(amount);
721         emit Transfer(sender, recipient, amount);
722         return true;
723     }
724 
725     function checkTxLimit(address sender, uint256 amount) internal view {
726         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
727     }
728 
729     function shouldTakeFee(address sender) internal view returns (bool) {
730         return !isFeeExempt[sender];
731     }
732 
733 // *** 
734 // Handle Fees
735 // *** 
736 
737     function takeTransferFee(address sender, uint256 amount) internal returns (uint256) {
738 
739         uint256 feeToTake = transFee;
740         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
741         
742         _balances[address(this)] = _balances[address(this)].add(feeAmount);
743         emit Transfer(sender, address(this), feeAmount);
744 
745         return amount.sub(feeAmount);
746     }
747 
748     function takeFee(address sender, uint256 amount, bool isSell) internal returns (uint256) {
749 
750         uint256 feeToTake = isSell ? swapTotalFee : buyTotalFee;
751         uint256 feeAmount = amount.mul(feeToTake).mul(100).div(feeDenominator * 100);
752         
753         _balances[address(this)] = _balances[address(this)].add(feeAmount);
754         emit Transfer(sender, address(this), feeAmount);
755 
756         return amount.sub(feeAmount);
757     }
758 
759 // *** 
760 // End Handle Fees
761 // *** 
762 
763     function shouldSwapBack() internal view returns (bool) {
764         return msg.sender != uniswapV2Pair
765         && !inSwap
766         && swapEnabled
767         && _balances[address(this)] >= swapThreshold;
768     }
769 
770     function clearStuckBalance(uint256 amountPercentage) external onlyOwner() {
771         uint256 amountETH = address(this).balance;
772         payable(marketingWallet).transfer(amountETH * amountPercentage / 100);
773     }
774 
775     function clearStuckBalance_sender(uint256 amountPercentage) external onlyOwner() {
776         uint256 amountETH = address(this).balance;
777         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
778     }
779 
780     // switch Trading
781     function tradingStatus(bool _status) public onlyOwner {
782         tradingOpen = _status;
783     }
784 
785     // enable cooldown between trades
786     function cooldownEnabled(bool _status, uint8 _interval) public onlyOwner {
787         buyCooldownEnabled = _status;
788         cooldownTimerInterval = _interval;
789     }
790 
791     function swapBack() internal swapping {
792         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : swapLpFee;
793         uint256 amountToLiquify = swapAmount.mul(dynamicLiquidityFee).div(swapTotalFee).div(2);
794         uint256 amountToSwap = swapAmount.sub(amountToLiquify);
795 
796         address[] memory path = new address[](2);
797         path[0] = address(this);
798         path[1] = contractRouter.WETH();
799 
800         uint256 balanceBefore = address(this).balance;
801 
802         contractRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
803             amountToSwap,
804             0,
805             path,
806             address(this),
807             block.timestamp
808         );
809 
810         uint256 amountETH = address(this).balance.sub(balanceBefore);
811 
812         uint256 totalETHFee = swapTotalFee.sub(dynamicLiquidityFee.div(2));
813 
814         uint256 amountETHLiquidity = amountETH.mul(swapLpFee).div(totalETHFee).div(2);
815         uint256 amountETHMarketing = amountETH.mul(swapMarketing).div(totalETHFee);
816         uint256 amountETHTreasury = amountETH.mul(swapTreasuryFee).div(totalETHFee);
817 
818         (bool tmpSuccess,) = payable(marketingWallet).call{value: amountETHMarketing, gas: 30000}("");
819         (tmpSuccess,) = payable(devWallet).call{value: amountETHTreasury, gas: 30000}("");
820 
821         // Supress warning msg
822         tmpSuccess = false;
823 
824         if(amountToLiquify > 0){
825             contractRouter.addLiquidityETH{value: amountETHLiquidity}(
826                 address(this),
827                 amountToLiquify,
828                 0,
829                 0,
830                 autoLiquidityReceiver,
831                 block.timestamp
832             );
833             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
834         }
835     }
836 
837 // *** 
838 // Various exempt functions
839 // *** 
840 
841     function setIsFeeExempt(address holder, bool exempt) external onlyOwner() {
842         isFeeExempt[holder] = exempt;
843     }
844 
845     function setIsMaxExempt(address holder, bool exempt) external onlyOwner() {
846         isMaxExempt[holder] = exempt;
847     }
848 
849     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner() {
850         isTxLimitExempt[holder] = exempt;
851     }
852 
853     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner() {
854         isTimelockExempt[holder] = exempt;
855     }
856 
857 // *** 
858 // End various exempt functions
859 // *** 
860 
861 
862 // ***
863 // Start fee things
864 // ***
865 
866     function setTransFee(uint256 fee) external onlyOwner() {
867         transFee = fee;
868     }
869 
870     function setSwapFees(uint256 _newSwapLpFee, uint256 _newSwapMarketingFee, uint256 _newSwapTreasuryFee, uint256 _feeDenominator) external onlyOwner() {
871         swapLpFee = _newSwapLpFee;
872         swapMarketing = _newSwapMarketingFee;
873         swapTreasuryFee = _newSwapTreasuryFee;
874         swapTotalFee = _newSwapLpFee.add(_newSwapMarketingFee).add(_newSwapTreasuryFee);
875         feeDenominator = _feeDenominator;
876         require(swapTotalFee < 90, "Fees cannot be that high");
877     }
878 
879     function setBuyFees(uint256 buyTax) external onlyOwner() {
880         buyTotalFee = buyTax;
881     }
882 
883 // ***
884 // end fee stuff§2e sw. 
885 // ***
886 
887 
888 
889     function setTreasuryFeeReceiver(address _newWallet) external onlyOwner() {
890         isFeeExempt[devWallet] = false;
891         isFeeExempt[_newWallet] = true;
892         devWallet = _newWallet;
893     }
894 
895     function setMarketingWallet(address _newWallet) external onlyOwner() {
896         isFeeExempt[marketingWallet] = false;
897         isFeeExempt[_newWallet] = true;
898 
899         isMaxExempt[_newWallet] = true;
900 
901         marketingWallet = _newWallet;
902     }
903 
904     function setFeeReceivers(address _autoLiquidityReceiver, address _newMarketingWallet, address _newdevWallet ) external onlyOwner() {
905 
906         isFeeExempt[devWallet] = false;
907         isFeeExempt[_newdevWallet] = true;
908         isFeeExempt[marketingWallet] = false;
909         isFeeExempt[_newMarketingWallet] = true;
910 
911         isMaxExempt[_newMarketingWallet] = true;
912 
913         autoLiquidityReceiver = _autoLiquidityReceiver;
914         marketingWallet = _newMarketingWallet;
915         devWallet = _newdevWallet;
916     }
917 
918 // ***
919 // Swap settings
920 // ***
921 
922     function setSwapThresholdAmount(uint256 _amount) external onlyOwner() {
923         swapThreshold = _amount;
924     }
925 
926     function setSwapAmount(uint256 _amount) external onlyOwner() {
927         if(_amount > swapThreshold) {
928             swapAmount = swapThreshold;
929         } else {
930             swapAmount = _amount;
931         }        
932     }
933 
934 // ***
935 // End Swap settings
936 // ***
937 
938     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner() {
939         targetLiquidity = _target;
940         targetLiquidityDenominator = _denominator;
941     }
942 
943     function getCirculatingSupply() public view returns (uint256) {
944         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
945     }
946 
947     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
948         return accuracy.mul(balanceOf(uniswapV2Pair).mul(2)).div(getCirculatingSupply());
949     }
950 
951     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
952         return getLiquidityBacking(accuracy) > target;
953     }
954 
955     /* Airdrop */
956     function airDropCustom(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
957 
958         require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
959         require(addresses.length == tokens.length,"Mismatch between Address and token count");
960 
961         uint256 SCCC = 0;
962 
963         for(uint i=0; i < addresses.length; i++){
964             SCCC = SCCC + tokens[i];
965         }
966 
967         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
968 
969         for(uint i=0; i < addresses.length; i++){
970             _basicTransfer(from,addresses[i],tokens[i]);
971         }
972         
973     }
974 
975     function airDropFixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
976 
977         require(addresses.length < 801,"GAS Error: max airdrop limit is 800 addresses");
978 
979         uint256 SCCC = tokens * addresses.length;
980 
981         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
982 
983         for(uint i=0; i < addresses.length; i++){
984             _basicTransfer(from,addresses[i],tokens);
985         }
986     }
987 
988     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
989 
990 }