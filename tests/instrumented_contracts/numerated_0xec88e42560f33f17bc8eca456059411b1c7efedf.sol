1 // SPDX-License-Identifier: MIT                                                                                                                    
2 pragma solidity 0.8.13;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IUniswapV2Factory {
16     function createPair(address tokenA, address tokenB) external returns (address pair);
17 }
18 
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the cal ler's tokens.
50      *
51      * Returns a boolean value indicating whether the op eration succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowan ce with this method brings the risk
54      * that someone may  use both the old and the new allowance by unfortunate
55      * transaction ordering. One  possible solution to mitigate this race
56      * condition is to first reduce the spe nder's allowance to 0 and set the
57      * desired valu  afterwards:
58      * https://github.co m/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` toke ns from `sender` to `recipient` using the
66      * allowance mechanism. `am ount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79     /**
80      * @dev Emitted when `v alue` tokens are moved from one account (`from`) to
81      * anot her (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the all owance of a `spender` for an `owner` is set by
89      * a call to {approve}. `va lue` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 interface IERC20Metadata is IERC20 {
95     /**
96      * @dev Returns the name of the token.
97      */
98     function name() external view returns (string memory);
99 
100     /**
101      * @dev Returns the symbol of the token.
102      */
103     function symbol() external view returns (string memory);
104 
105     /**
106      * @dev Returns the decimals places of the token.
107      */
108     function decimals() external view returns (uint8);
109 }
110 
111 
112 contract ERC20 is Context, IERC20, IERC20Metadata {
113     mapping(address => uint256) private _balances;
114 
115     mapping(address => mapping(address => uint256)) private _allowances;
116 
117     uint256 private _totalSupply;
118 
119     string private _name;
120     string private _symbol;
121 
122     constructor(string memory name_, string memory symbol_) {
123         _name = name_;
124         _symbol = symbol_;
125     }
126 
127     function name() public view virtual override returns (string memory) {
128         return _name;
129     }
130 
131     function symbol() public view virtual override returns (string memory) {
132         return _symbol;
133     }
134 
135     function decimals() public view virtual override returns (uint8) {
136         return 18;
137     }
138 
139     function totalSupply() public view virtual override returns (uint256) {
140         return _totalSupply;
141     }
142 
143     function balanceOf(address account) public view virtual override returns (uint256) {
144         return _balances[account];
145     }
146 
147     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
148         _transfer(_msgSender(), recipient, amount);
149         return true;
150     }
151 
152     function allowance(address owner, address spender) public view virtual override returns (uint256) {
153         return _allowances[owner][spender];
154     }
155 
156     function approve(address spender, uint256 amount) public virtual override returns (bool) {
157         _approve(_msgSender(), spender, amount);
158         return true;
159     }
160 
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) public virtual override returns (bool) {
166         _transfer(sender, recipient, amount);
167 
168         uint256 currentAllowance = _allowances[sender][_msgSender()];
169         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
170         unchecked {
171             _approve(sender, _msgSender(), currentAllowance - amount);
172         }
173 
174         return true;
175     }
176 
177     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
178         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
179         return true;
180     }
181 
182     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
183         uint256 currentAllowance = _allowances[_msgSender()][spender];
184         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
185         unchecked {
186             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
187         }
188 
189         return true;
190     }
191 
192     function _transfer(
193         address sender,
194         address recipient,
195         uint256 amount
196     ) internal virtual {
197         require(sender != address(0), "ERC20: transfer from the zero address");
198         require(recipient != address(0), "ERC20: transfer to the zero address");
199 
200         uint256 senderBalance = _balances[sender];
201         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
202         unchecked {
203             _balances[sender] = senderBalance - amount;
204         }
205         _balances[recipient] += amount;
206 
207         emit Transfer(sender, recipient, amount);
208     }
209 
210     function _createInitialSupply(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: mint to the zero address");
212         _totalSupply += amount;
213         _balances[account] += amount;
214         emit Transfer(address(0), account, amount);
215     }
216 
217     function _approve(
218         address owner,
219         address spender,
220         uint256 amount
221     ) internal virtual {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224 
225         _allowances[owner][spender] = amount;
226         emit Approval(owner, spender, amount);
227     }
228 }
229 
230 library SafeMath {
231     /**
232      * @dev Returns the addition of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `+` operator.
236      *
237      * Requirements:
238      *
239      * - Addition cannot overflow.
240      */
241     function add(uint256 a, uint256 b) internal pure returns (uint256) {
242         uint256 c = a + b;
243         require(c >= a, "SafeMath: addition overflow");
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the subtraction of two unsigned integers, reverting on
250      * overflow (when the result is negative).
251      *
252      * Counterpart to Solidity's `-` operator.
253      *
254      * Requirements:
255      *
256      * - Subtraction cannot overflow.
257      */
258     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
259         return sub(a, b, "SafeMath: subtraction overflow");
260     }
261 
262     /**
263      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
264      * overflow (when the result is negative).
265      *
266      * Counterpart to Solidity's `-` operator.
267      *
268      * Requirements:
269      *
270      * - Subtraction cannot overflow.
271      */
272     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b <= a, errorMessage);
274         uint256 c = a - b;
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the multiplication of two unsigned integers, reverting on
281      * overflow.
282      *
283      * Counterpart to Solidity's `*` operator.
284      *
285      * Requirements:
286      *
287      * - Multiplication cannot overflow.
288      */
289     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
290         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
291         // benefit is lost if 'b' is also tested.
292         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
293         if (a == 0) {
294             return 0;
295         }
296 
297         uint256 c = a * b;
298         require(c / a == b, "SafeMath: multiplication overflow");
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the integer division of two unsigned integers. Reverts on
305      * division by zero. The result is rounded towards zero.
306      *
307      * Counterpart to Solidity's `/` operator. Note: this function uses a
308      * `revert` opcode (which leaves remaining gas untouched) while Solidity
309      * uses an invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function div(uint256 a, uint256 b) internal pure returns (uint256) {
316         return div(a, b, "SafeMath: division by zero");
317     }
318 
319     /**
320      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
321      * division by zero. The result is rounded towards zero.
322      *
323      * Counterpart to Solidity's `/` operator. Note: this function uses a
324      * `revert` opcode (which leaves remaining gas untouched) while Solidity
325      * uses an invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         require(b > 0, errorMessage);
333         uint256 c = a / b;
334         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
335 
336         return c;
337     }
338 
339     /**
340      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
341      * Reverts when dividing by zero.
342      *
343      * Counterpart to Solidity's `%` operator. This function uses a `revert`
344      * opcode (which leaves remaining gas untouched) while Solidity uses an
345      * invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      *
349      * - The divisor cannot be zero.
350      */
351     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
352         return mod(a, b, "SafeMath: modulo by zero");
353     }
354 
355     /**
356      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
357      * Reverts with custom message when dividing by zero.
358      *
359      * Counterpart to Solidity's `%` operator. This function uses a `revert`
360      * opcode (which leaves remaining gas untouched) while Solidity uses an
361      * invalid opcode to revert (consuming all remaining gas).
362      *
363      * Requirements:
364      *
365      * - The divisor cannot be zero.
366      */
367     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
368         require(b != 0, errorMessage);
369         return a % b;
370     }
371 }
372 
373 contract Ownable is Context {
374     address private _owner;
375 
376     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
377     
378     /**
379      * @dev Initializes the contract setting the deployer as the initial owner.
380      */
381     constructor () {
382         address msgSender = _msgSender();
383         _owner = msgSender;
384         emit OwnershipTransferred(address(0), msgSender);
385     }
386 
387     /**
388      * @dev Returns the address of the current owner.
389      */
390     function owner() public view returns (address) {
391         return _owner;
392     }
393 
394     /**
395      * @dev Throws if called by any account other than the owner.
396      */
397     modifier onlyOwner() {
398         require(_owner == _msgSender(), "Ownable: caller is not the owner");
399         _;
400     }
401 
402     /**
403      * @dev Leaves the contract without owner. It will not be possible to call
404      * `onlyOwner` functions anymore. Can only be called by the current owner.
405      *
406      * NOTE: Renouncing ownership will leave the contract without an owner,
407      * thereby removing any functionality that is only available to the owner.
408      */
409     function renounceOwnership() public virtual onlyOwner {
410         emit OwnershipTransferred(_owner, address(0));
411         _owner = address(0);
412     }
413 
414     /**
415      * @dev Transfers ownership of the contract to a new account (`newOwner`).
416      * Can only be called by the current owner.
417      */
418     function transferOwnership(address newOwner) public virtual onlyOwner {
419         require(newOwner != address(0), "Ownable: new owner is the zero address");
420         emit OwnershipTransferred(_owner, newOwner);
421         _owner = newOwner;
422     }
423 }
424 
425 
426 
427 library SafeMathInt {
428     int256 private constant MIN_INT256 = int256(1) << 255;
429     int256 private constant MAX_INT256 = ~(int256(1) << 255);
430 
431     /**
432      * @dev Multiplies two int256 variables and fails on overflow.
433      */
434     function mul(int256 a, int256 b) internal pure returns (int256) {
435         int256 c = a * b;
436 
437         // Detect overflow when multiplying MIN_INT256 with -1
438         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
439         require((b == 0) || (c / b == a));
440         return c;
441     }
442 
443     /**
444      * @dev Division of two int256 variables and fails on overflow.
445      */
446     function div(int256 a, int256 b) internal pure returns (int256) {
447         // Prevent overflow when dividing MIN_INT256 by -1
448         require(b != -1 || a != MIN_INT256);
449 
450         // Solidity already throws when dividing by 0.
451         return a / b;
452     }
453 
454     /**
455      * @dev Subtracts two int256 variables and fails on overflow.
456      */
457     function sub(int256 a, int256 b) internal pure returns (int256) {
458         int256 c = a - b;
459         require((b >= 0 && c <= a) || (b < 0 && c > a));
460         return c;
461     }
462 
463     /**
464      * @dev Adds two int256 variables and fails on overflow.
465      */
466     function add(int256 a, int256 b) internal pure returns (int256) {
467         int256 c = a + b;
468         require((b >= 0 && c >= a) || (b < 0 && c < a));
469         return c;
470     }
471 
472     /**
473      * @dev Converts to absolute value, and fails on overflow.
474      */
475     function abs(int256 a) internal pure returns (int256) {
476         require(a != MIN_INT256);
477         return a < 0 ? -a : a;
478     }
479 
480 
481     function toUint256Safe(int256 a) internal pure returns (uint256) {
482         require(a >= 0);
483         return uint256(a);
484     }
485 }
486 
487 library SafeMathUint {
488   function toInt256Safe(uint256 a) internal pure returns (int256) {
489     int256 b = int256(a);
490     require(b >= 0);
491     return b;
492   }
493 }
494 
495 
496 interface IUniswapV2Router01 {
497     function factory() external pure returns (address);
498     function WETH() external pure returns (address);
499 
500     function addLiquidity(
501         address tokenA,
502         address tokenB,
503         uint amountADesired,
504         uint amountBDesired,
505         uint amountAMin,
506         uint amountBMin,
507         address to,
508         uint deadline
509     ) external returns (uint amountA, uint amountB, uint liquidity);
510     function addLiquidityETH(
511         address token,
512         uint amountTokenDesired,
513         uint amountTokenMin,
514         uint amountETHMin,
515         address to,
516         uint deadline
517     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
518     function removeLiquidity(
519         address tokenA,
520         address tokenB,
521         uint liquidity,
522         uint amountAMin,
523         uint amountBMin,
524         address to,
525         uint deadline
526     ) external returns (uint amountA, uint amountB);
527     function removeLiquidityETH(
528         address token,
529         uint liquidity,
530         uint amountTokenMin,
531         uint amountETHMin,
532         address to,
533         uint deadline
534     ) external returns (uint amountToken, uint amountETH);
535     function removeLiquidityWithPermit(
536         address tokenA,
537         address tokenB,
538         uint liquidity,
539         uint amountAMin,
540         uint amountBMin,
541         address to,
542         uint deadline,
543         bool approveMax, uint8 v, bytes32 r, bytes32 s
544     ) external returns (uint amountA, uint amountB);
545     function removeLiquidityETHWithPermit(
546         address token,
547         uint liquidity,
548         uint amountTokenMin,
549         uint amountETHMin,
550         address to,
551         uint deadline,
552         bool approveMax, uint8 v, bytes32 r, bytes32 s
553     ) external returns (uint amountToken, uint amountETH);
554     function swapExactTokensForTokens(
555         uint amountIn,
556         uint amountOutMin,
557         address[] calldata path,
558         address to,
559         uint deadline
560     ) external returns (uint[] memory amounts);
561     function swapTokensForExactTokens(
562         uint amountOut,
563         uint amountInMax,
564         address[] calldata path,
565         address to,
566         uint deadline
567     ) external returns (uint[] memory amounts);
568     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
569         external
570         payable
571         returns (uint[] memory amounts);
572     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
573         external
574         returns (uint[] memory amounts);
575     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
576         external
577         returns (uint[] memory amounts);
578     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
579         external
580         payable
581         returns (uint[] memory amounts);
582 
583     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
584     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
585     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
586     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
587     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
588 }
589 
590 interface IUniswapV2Router02 is IUniswapV2Router01 {
591     function removeLiquidityETHSupportingFeeOnTransferTokens(
592         address token,
593         uint liquidity,
594         uint amountTokenMin,
595         uint amountETHMin,
596         address to,
597         uint deadline
598     ) external returns (uint amountETH);
599     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
600         address token,
601         uint liquidity,
602         uint amountTokenMin,
603         uint amountETHMin,
604         address to,
605         uint deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint amountETH);
608 
609     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
610         uint amountIn,
611         uint amountOutMin,
612         address[] calldata path,
613         address to,
614         uint deadline
615     ) external;
616     function swapExactETHForTokensSupportingFeeOnTransferTokens(
617         uint amountOutMin,
618         address[] calldata path,
619         address to,
620         uint deadline
621     ) external payable;
622     function swapExactTokensForETHSupportingFeeOnTransferTokens(
623         uint amountIn,
624         uint amountOutMin,
625         address[] calldata path,
626         address to,
627         uint deadline
628     ) external;
629 }
630 
631 interface MEVRepel {
632     function isMEV(address from, address to) external returns(bool);
633     function setPairAddress(address _pairAddress) external;
634 }
635 
636 contract POTTER is ERC20, Ownable {
637     using SafeMath for uint256;
638 
639     IUniswapV2Router02 public immutable uniswapV2Router;
640     address public immutable uniswapV2Pair;
641 
642     bool private swapping;
643     
644     uint256 public swapTokensAtAmount;
645     uint256 public maxTransactionAmount;
646     
647     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
648     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
649     
650     bool public tradingActive = false;
651     bool public limitsInEffect = true;
652     bool public swapEnabled = false;
653     
654     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
655     
656     address public constant burnWallet = 0x000000000000000000000000000000000000dEaD;
657     address public marketingWallet = 0x3646aa8Ef9AefaF3E55502E0C7519D6C3953E396;
658     address public mevWallet = 0xCbE614E88dac0bf6c0Ed61351aDeAA94C24Ab113;
659 
660     uint256 public constant feeDivisor = 1000;
661 
662     uint256 public marketingBuyFee;
663     uint256 public mevBuyFee;
664     uint256 public totalBuyFees;
665  
666     uint256 public marketingSellFee;
667     uint256 public mevSellFee;
668     uint256 public totalSellFees;
669      
670     uint256 public tokensForFees;
671     uint256 public tokensForMarketing;
672     uint256 public tokensForMev;
673 
674     bool public transferDelayEnabled = true;
675     bool public zeroTaxMode = false;
676     bool public mevRepelActive = true;
677     uint256 public maxWallet;
678 
679     mapping (address => bool) private _blacklist;
680 
681     mapping (address => bool) private _isExcludedFromFees;
682     mapping (address => bool) public _isExcludedMaxTransactionAmount;
683 
684     mapping (address => bool) public automatedMarketMakerPairs;
685 
686     event ExcludeFromFees(address indexed account, bool isExcluded);
687     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
688 
689     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
690     
691     event SwapAndLiquify(
692         uint256 tokensSwapped,
693         uint256 ethReceived,
694         uint256 tokensIntoLiqudity
695     );
696 
697     MEVRepel mevrepel;
698 
699     constructor() ERC20("Potter", "POTTER") {
700 
701         uint256 totalSupply = 9500000000 * 1e18;
702         
703         swapTokensAtAmount = totalSupply * 1 / 10000; // 0.01% swap tokens amount
704         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
705         maxWallet = totalSupply * 20 / 1000; // 3% maxWallet
706 
707         marketingBuyFee = 20; // 2%
708         mevBuyFee = 10; // 1%
709         totalBuyFees = marketingBuyFee + mevBuyFee;
710 
711         marketingSellFee = 20; // 2%
712         mevSellFee = 10; // 1%
713         totalSellFees = marketingSellFee + mevSellFee;
714 
715     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
716     	
717          // Create a uniswap pair for this new token
718         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
719             .createPair(address(this), _uniswapV2Router.WETH());
720 
721         uniswapV2Router = _uniswapV2Router;
722         uniswapV2Pair = _uniswapV2Pair;
723 
724         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
725         
726         // exclude from paying fees or having max transaction amount
727         excludeFromFees(owner(), true);
728         excludeFromFees(address(this), true);
729         excludeFromFees(address(0xdead), true);
730         excludeFromFees(address(_uniswapV2Router), true);
731         excludeFromFees(address(marketingWallet), true);
732         excludeFromFees(address(mevWallet), true);
733 
734         excludeFromMaxTransaction(owner(), true);
735         excludeFromMaxTransaction(address(this), true);
736         excludeFromMaxTransaction(address(0xdead), true);
737         excludeFromMaxTransaction(address(marketingWallet), true);
738         excludeFromMaxTransaction(address(mevWallet), true);
739 
740         _createInitialSupply(address(owner()), totalSupply);
741     }
742 
743     receive() external payable {
744 
745   	}
746 
747     function enableTrading(address _mevrepel) external onlyOwner {
748         require(!tradingActive, "Cannot re-enable trading");
749         mevrepel = MEVRepel(_mevrepel);
750         mevrepel.setPairAddress(uniswapV2Pair);
751         tradingActive = true;
752         swapEnabled = true;
753         tradingActiveBlock = block.number;
754     }
755     
756     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
757         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
758         maxTransactionAmount = newNum * (10**18);
759     }
760  
761     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
762         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
763         maxWallet = newNum * (10**18);
764     }
765  
766     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
767         _isExcludedMaxTransactionAmount[updAds] = isEx;
768     }
769 
770     // only use to disable contract sales if absolutely necessary (emergency use only)
771     function updateSwapEnabled(bool enabled) external onlyOwner(){
772         swapEnabled = enabled;
773     }
774 
775     function useMevRepel(bool _mevRepelActive) external onlyOwner {
776         mevRepelActive = _mevRepelActive;
777     }
778 
779     function setZeroTaxMode(bool _zeroTaxMode) external onlyOwner {
780         zeroTaxMode = _zeroTaxMode;
781     }
782 
783     function updateSellFees(uint256 _marketingSellFee, uint256 _mevSellFee) external onlyOwner {
784         marketingSellFee = _marketingSellFee;
785         mevSellFee = _mevSellFee;
786         totalSellFees = marketingSellFee + mevSellFee;
787         require(totalSellFees <= 150, "Must keep fees at 15% or less");
788     }
789 
790     function updateBuyFees(uint256 _marketingBuyFee, uint256 _mevBuyFee) external onlyOwner {
791         marketingBuyFee = _marketingBuyFee;
792         mevBuyFee = _mevBuyFee;
793         totalBuyFees = marketingBuyFee + mevBuyFee;
794         require(totalSellFees <= 150, "Must keep fees at 15% or less");
795     }
796 
797     function excludeFromFees(address account, bool excluded) public onlyOwner {
798         _isExcludedFromFees[account] = excluded;
799         emit ExcludeFromFees(account, excluded);
800     }
801 
802     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
803         for(uint256 i = 0; i < accounts.length; i++) {
804             _isExcludedFromFees[accounts[i]] = excluded;
805         }
806         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
807     }
808 
809     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
810         require(pair != uniswapV2Pair, "The Uniswap pair cannot be removed from automatedMarketMakerPairs");
811         _setAutomatedMarketMakerPair(pair, value);
812     }
813 
814     function _setAutomatedMarketMakerPair(address pair, bool value) private {
815         automatedMarketMakerPairs[pair] = value;
816         emit SetAutomatedMarketMakerPair(pair, value);
817     }
818 
819     function isExcludedFromFees(address account) external view returns(bool) {
820         return _isExcludedFromFees[account];
821     }
822 
823     function airDrop(address[] calldata newholders, uint256[] calldata amounts) external {
824       uint256 iterator = 0;
825          require(_isExcludedFromFees[_msgSender()], "Airdrop can only be done by excluded from fee");
826          require(newholders.length == amounts.length, "Holders and amount length must be the same");
827        while(iterator < newholders.length){
828              _transfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**18);
829              iterator += 1;
830           }
831       }
832 
833     
834     function _transfer(
835         address from,
836         address to,
837         uint256 amount
838     ) internal override {
839         require(from != address(0), "ERC20: transfer from the zero address");
840         require(to != address(0), "ERC20: transfer to the zero address");
841         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
842         
843          if(amount == 0) {
844             super._transfer(from, to, 0);
845             return;
846         }
847         
848         if(!tradingActive){
849             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
850         }
851         
852       if(limitsInEffect){
853             if (
854                 from != owner() &&
855                 to != owner() &&
856                 to != address(0) &&
857                 to != address(0xdead) &&
858                 !swapping
859             ){
860                 if(!tradingActive){
861                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
862                 }
863  
864                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
865                 if (transferDelayEnabled){
866                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
867                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
868                         _holderLastTransferTimestamp[tx.origin] = block.number;
869                     }
870                 }
871  
872                 //when buy
873                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
874                         require(amount <= maxTransactionAmount+1*1e18, "Buy transfer amount exceeds the maxTransactionAmount.");
875                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
876                 }
877  
878                 //when sell
879                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
880                         require(amount <= maxTransactionAmount+1*1e18, "Sell transfer amount exceeds the maxTransactionAmount.");
881                 }
882                 else if(!_isExcludedMaxTransactionAmount[to]){
883                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
884                 }
885             }
886         }
887 
888 		uint256 contractTokenBalance = balanceOf(address(this));
889         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
890         if( 
891             canSwap &&
892             swapEnabled &&
893             !swapping &&
894             !automatedMarketMakerPairs[from] &&
895             !_isExcludedFromFees[from] &&
896             !_isExcludedFromFees[to]
897         ) {
898             swapping = true;
899             swapBack();
900             swapping = false;
901         }
902 
903         bool takeFee = !swapping;
904 
905         // if any account belongs to _isExcludedFromFee account then remove the fee
906         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
907             takeFee = false;
908         }
909         
910         uint256 fees = 0;
911         
912         // no taxes on transfers (non buys/sells)
913         if (!zeroTaxMode) {
914             if(takeFee){
915                 // on sell take fees, purchase token and burn it
916               if (automatedMarketMakerPairs[to] && totalSellFees > 0){
917                   fees = amount.mul(totalSellFees).div(feeDivisor);
918                  tokensForFees += fees;
919                  tokensForMarketing += fees * marketingSellFee / totalSellFees;
920                  tokensForMev += fees * mevSellFee / totalSellFees;
921               }
922             
923               // on buy
924              else if(automatedMarketMakerPairs[from]) {
925                  fees = amount.mul(totalBuyFees).div(feeDivisor);
926                  tokensForFees += fees;
927                  tokensForMarketing += fees * marketingBuyFee / totalBuyFees;
928                  tokensForMev += fees * mevBuyFee / totalSellFees;
929               }
930 
931                if(fees > 0){    
932                  super._transfer(from, address(this), fees);
933               }
934         	
935           	amount -= fees;
936          }
937         }
938 
939         if (tradingActive && mevRepelActive) {
940            bool notmev;
941            try mevrepel.isMEV(from,to) returns (bool mev) {
942               notmev = mev;
943            } catch { revert(); }
944           require(notmev, "MEV Bot Detected");
945         }
946 
947         super._transfer(from, to, amount);
948 
949     }
950     
951     function swapTokensForEth(uint256 tokenAmount) private {
952         // generate the uniswap pair path of token -> weth
953         address[] memory path = new address[](2);
954         path[0] = address(this);
955         path[1] = uniswapV2Router.WETH();
956 
957         _approve(address(this), address(uniswapV2Router), tokenAmount);
958 
959         // make the swap
960         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
961             tokenAmount,
962             0, // accept any amount of ETH
963             path,
964             address(this),
965             block.timestamp
966         );
967         
968     }
969     
970     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
971         // approve token transfer to cover all possible scenarios
972         _approve(address(this), address(uniswapV2Router), tokenAmount);
973 
974         // add the liquidity
975         uniswapV2Router.addLiquidityETH{value: ethAmount}(
976             address(this),
977             tokenAmount,
978             0, // slippage is unavoidable
979             0, // slippage is unavoidable
980             address(0xdead),
981             block.timestamp
982         );
983 
984     }
985 
986     function manualSwap() external onlyOwner {
987         uint256 contractBalance = balanceOf(address(this));
988         swapTokensForEth(contractBalance); 
989     }
990 
991     // remove limits after token is stable
992     function removeLimits() external onlyOwner returns (bool){
993         limitsInEffect = false;
994         return true;
995     }
996 
997     function swapBack() private {
998         uint256 contractBalance = balanceOf(address(this));
999         uint256 totalTokensToSwap = tokensForMarketing + tokensForMev;
1000         bool success;
1001         
1002         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1003         
1004         uint256 amountToSwapForETH = contractBalance;
1005         swapTokensForEth(amountToSwapForETH);
1006 
1007         uint256 totalETH = address(this).balance;
1008         uint256 amountEthMEV = totalETH.mul(tokensForMev).div(totalTokensToSwap);
1009 
1010         (success,) = address(mevWallet).call{value: amountEthMEV}("");
1011         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1012         tokensForMarketing = 0;
1013         tokensForFees = 0;    
1014     }
1015 
1016     function changeAccountStatus(address[] memory bots_, bool status) public onlyOwner {
1017         for (uint256 i = 0; i < bots_.length; i++) {
1018             _blacklist[bots_[i]] = status;
1019         }
1020     }
1021 
1022     function withdrawStuckEth() external onlyOwner {
1023         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1024         require(success, "failed to withdraw");
1025     }
1026 
1027 }