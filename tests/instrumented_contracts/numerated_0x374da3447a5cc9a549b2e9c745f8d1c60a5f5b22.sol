1 /**
2 
3 Welcome to the world of Hoppa. 
4 
5 $HOPPA is a reflection of love. Hold $HOPPA and earn $HOPPY
6 
7 // https://hoppacoin.vip/
8 
9 // https://twitter.com/HoppaCoin
10 
11 // https://t.me/HoppaCoin
12 
13 **/
14 
15 // SPDX-License-Identifier: MIT   
16 
17 pragma solidity 0.8.20;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 interface IUniswapV2Factory {
31     function createPair(address tokenA, address tokenB) external returns (address pair);
32 }
33 
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 interface IERC20Metadata is IERC20 {
110     /**
111      * @dev Returns the name of the token.
112      */
113     function name() external view returns (string memory);
114 
115     /**
116      * @dev Returns the symbol of the token.
117      */
118     function symbol() external view returns (string memory);
119 
120     /**
121      * @dev Returns the decimals places of the token.
122      */
123     function decimals() external view returns (uint8);
124 }
125 
126 
127 contract ERC20 is Context, IERC20, IERC20Metadata {
128     mapping(address => uint256) private _balances;
129 
130     mapping(address => mapping(address => uint256)) private _allowances;
131 
132     uint256 private _totalSupply;
133 
134     string private _name;
135     string private _symbol;
136 
137     constructor(string memory name_, string memory symbol_) {
138         _name = name_;
139         _symbol = symbol_;
140     }
141 
142     function name() public view virtual override returns (string memory) {
143         return _name;
144     }
145 
146     function symbol() public view virtual override returns (string memory) {
147         return _symbol;
148     }
149 
150     function decimals() public view virtual override returns (uint8) {
151         return 18;
152     }
153 
154     function totalSupply() public view virtual override returns (uint256) {
155         return _totalSupply;
156     }
157 
158     function balanceOf(address account) public view virtual override returns (uint256) {
159         return _balances[account];
160     }
161 
162     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
163         _transfer(_msgSender(), recipient, amount);
164         return true;
165     }
166 
167     function allowance(address owner, address spender) public view virtual override returns (uint256) {
168         return _allowances[owner][spender];
169     }
170 
171     function approve(address spender, uint256 amount) public virtual override returns (bool) {
172         _approve(_msgSender(), spender, amount);
173         return true;
174     }
175 
176     function transferFrom(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) public virtual override returns (bool) {
181         _transfer(sender, recipient, amount);
182 
183         uint256 currentAllowance = _allowances[sender][_msgSender()];
184         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
185         unchecked {
186             _approve(sender, _msgSender(), currentAllowance - amount);
187         }
188 
189         return true;
190     }
191 
192     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
193         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
194         return true;
195     }
196 
197     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
198         uint256 currentAllowance = _allowances[_msgSender()][spender];
199         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
200         unchecked {
201             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
202         }
203 
204         return true;
205     }
206 
207     function _transfer(
208         address sender,
209         address recipient,
210         uint256 amount
211     ) internal virtual {
212         require(sender != address(0), "ERC20: transfer from the zero address");
213         require(recipient != address(0), "ERC20: transfer to the zero address");
214 
215         uint256 senderBalance = _balances[sender];
216         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
217         unchecked {
218             _balances[sender] = senderBalance - amount;
219         }
220         _balances[recipient] += amount;
221 
222         emit Transfer(sender, recipient, amount);
223     }
224 
225     function _createInitialSupply(address account, uint256 amount) internal virtual {
226         require(account != address(0), "ERC20: mint to the zero address");
227         _totalSupply += amount;
228         _balances[account] += amount;
229         emit Transfer(address(0), account, amount);
230     }
231 
232     function _approve(
233         address owner,
234         address spender,
235         uint256 amount
236     ) internal virtual {
237         require(owner != address(0), "ERC20: approve from the zero address");
238         require(spender != address(0), "ERC20: approve to the zero address");
239 
240         _allowances[owner][spender] = amount;
241         emit Approval(owner, spender, amount);
242     }
243 }
244 
245 interface DividendPayingTokenOptionalInterface {
246   /// @notice View the amount of dividend in wei that an address can withdraw.
247   /// @param _owner The address of a token holder.
248   /// @return The amount of dividend in wei that `_owner` can withdraw.
249   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
250 
251   /// @notice View the amount of dividend in wei that an address has withdrawn.
252   /// @param _owner The address of a token holder.
253   /// @return The amount of dividend in wei that `_owner` has withdrawn.
254   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
255 
256   /// @notice View the amount of dividend in wei that an address has earned in total.
257   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
258   /// @param _owner The address of a token holder.
259   /// @return The amount of dividend in wei that `_owner` has earned in total.
260   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
261 }
262 
263 interface DividendPayingTokenInterface {
264   /// @notice View the amount of dividend in wei that an address can withdraw.
265   /// @param _owner The address of a token holder.
266   /// @return The amount of dividend in wei that `_owner` can withdraw.
267   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
268 
269   /// @notice Distributes ether to token holders as dividends.
270   /// @dev SHOULD distribute the paid ether to token holders as dividends.
271   ///  SHOULD NOT directly transfer ether to token holders in this function.
272   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
273   function distributeDividends() external payable;
274 
275   /// @notice Withdraws the ether distributed to the sender.
276   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
277   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
278   function withdrawDividend(address _rewardToken) external;
279 
280   /// @dev This event MUST emit when ether is distributed to token holders.
281   /// @param from The address which sends ether to this contract.
282   /// @param weiAmount The amount of distributed ether in wei.
283   event DividendsDistributed(
284     address indexed from,
285     uint256 weiAmount
286   );
287 
288   /// @dev This event MUST emit when an address withdraws their dividend.
289   /// @param to The address which withdraws ether from this contract.
290   /// @param weiAmount The amount of withdrawn ether in wei.
291   event DividendWithdrawn(
292     address indexed to,
293     uint256 weiAmount
294   );
295 }
296 
297 library SafeMath {
298     /**
299      * @dev Returns the addition of two unsigned integers, reverting on
300      * overflow.
301      *
302      * Counterpart to Solidity's `+` operator.
303      *
304      * Requirements:
305      *
306      * - Addition cannot overflow.
307      */
308     function add(uint256 a, uint256 b) internal pure returns (uint256) {
309         uint256 c = a + b;
310         require(c >= a, "SafeMath: addition overflow");
311 
312         return c;
313     }
314 
315     /**
316      * @dev Returns the subtraction of two unsigned integers, reverting on
317      * overflow (when the result is negative).
318      *
319      * Counterpart to Solidity's `-` operator.
320      *
321      * Requirements:
322      *
323      * - Subtraction cannot overflow.
324      */
325     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
326         return sub(a, b, "SafeMath: subtraction overflow");
327     }
328 
329     /**
330      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
331      * overflow (when the result is negative).
332      *
333      * Counterpart to Solidity's `-` operator.
334      *
335      * Requirements:
336      *
337      * - Subtraction cannot overflow.
338      */
339     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
340         require(b <= a, errorMessage);
341         uint256 c = a - b;
342 
343         return c;
344     }
345 
346     /**
347      * @dev Returns the multiplication of two unsigned integers, reverting on
348      * overflow.
349      *
350      * Counterpart to Solidity's `*` operator.
351      *
352      * Requirements:
353      *
354      * - Multiplication cannot overflow.
355      */
356     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
357         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
358         // benefit is lost if 'b' is also tested.
359         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
360         if (a == 0) {
361             return 0;
362         }
363 
364         uint256 c = a * b;
365         require(c / a == b, "SafeMath: multiplication overflow");
366 
367         return c;
368     }
369 
370     /**
371      * @dev Returns the integer division of two unsigned integers. Reverts on
372      * division by zero. The result is rounded towards zero.
373      *
374      * Counterpart to Solidity's `/` operator. Note: this function uses a
375      * `revert` opcode (which leaves remaining gas untouched) while Solidity
376      * uses an invalid opcode to revert (consuming all remaining gas).
377      *
378      * Requirements:
379      *
380      * - The divisor cannot be zero.
381      */
382     function div(uint256 a, uint256 b) internal pure returns (uint256) {
383         return div(a, b, "SafeMath: division by zero");
384     }
385 
386     /**
387      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
388      * division by zero. The result is rounded towards zero.
389      *
390      * Counterpart to Solidity's `/` operator. Note: this function uses a
391      * `revert` opcode (which leaves remaining gas untouched) while Solidity
392      * uses an invalid opcode to revert (consuming all remaining gas).
393      *
394      * Requirements:
395      *
396      * - The divisor cannot be zero.
397      */
398     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
399         require(b > 0, errorMessage);
400         uint256 c = a / b;
401         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
402 
403         return c;
404     }
405 
406     /**
407      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
408      * Reverts when dividing by zero.
409      *
410      * Counterpart to Solidity's `%` operator. This function uses a `revert`
411      * opcode (which leaves remaining gas untouched) while Solidity uses an
412      * invalid opcode to revert (consuming all remaining gas).
413      *
414      * Requirements:
415      *
416      * - The divisor cannot be zero.
417      */
418     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
419         return mod(a, b, "SafeMath: modulo by zero");
420     }
421 
422     /**
423      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
424      * Reverts with custom message when dividing by zero.
425      *
426      * Counterpart to Solidity's `%` operator. This function uses a `revert`
427      * opcode (which leaves remaining gas untouched) while Solidity uses an
428      * invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      *
432      * - The divisor cannot be zero.
433      */
434     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
435         require(b != 0, errorMessage);
436         return a % b;
437     }
438 }
439 
440 contract Ownable is Context {
441     address private _owner;
442 
443     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
444     
445     /**
446      * @dev Initializes the contract setting the deployer as the initial owner.
447      */
448     constructor () {
449         address msgSender = _msgSender();
450         _owner = msgSender;
451         emit OwnershipTransferred(address(0), msgSender);
452     }
453 
454     /**
455      * @dev Returns the address of the current owner.
456      */
457     function owner() public view returns (address) {
458         return _owner;
459     }
460 
461     /**
462      * @dev Throws if called by any account other than the owner.
463      */
464     modifier onlyOwner() {
465         require(_owner == _msgSender(), "Ownable: caller is not the owner");
466         _;
467     }
468 
469     /**
470      * @dev Leaves the contract without owner. It will not be possible to call
471      * `onlyOwner` functions anymore. Can only be called by the current owner.
472      *
473      * NOTE: Renouncing ownership will leave the contract without an owner,
474      * thereby removing any functionality that is only available to the owner.
475      */
476     function renounceOwnership() public virtual onlyOwner {
477         emit OwnershipTransferred(_owner, address(0));
478         _owner = address(0);
479     }
480 
481     /**
482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
483      * Can only be called by the current owner.
484      */
485     function transferOwnership(address newOwner) public virtual onlyOwner {
486         require(newOwner != address(0), "Ownable: new owner is the zero address");
487         emit OwnershipTransferred(_owner, newOwner);
488         _owner = newOwner;
489     }
490 }
491 
492 library SafeMathInt {
493     int256 private constant MIN_INT256 = int256(1) << 255;
494     int256 private constant MAX_INT256 = ~(int256(1) << 255);
495 
496     /**
497      * @dev Multiplies two int256 variables and fails on overflow.
498      */
499     function mul(int256 a, int256 b) internal pure returns (int256) {
500         int256 c = a * b;
501 
502         // Detect overflow when multiplying MIN_INT256 with -1
503         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
504         require((b == 0) || (c / b == a));
505         return c;
506     }
507 
508     /**
509      * @dev Division of two int256 variables and fails on overflow.
510      */
511     function div(int256 a, int256 b) internal pure returns (int256) {
512         // Prevent overflow when dividing MIN_INT256 by -1
513         require(b != -1 || a != MIN_INT256);
514 
515         // Solidity already throws when dividing by 0.
516         return a / b;
517     }
518 
519     /**
520      * @dev Subtracts two int256 variables and fails on overflow.
521      */
522     function sub(int256 a, int256 b) internal pure returns (int256) {
523         int256 c = a - b;
524         require((b >= 0 && c <= a) || (b < 0 && c > a));
525         return c;
526     }
527 
528     /**
529      * @dev Adds two int256 variables and fails on overflow.
530      */
531     function add(int256 a, int256 b) internal pure returns (int256) {
532         int256 c = a + b;
533         require((b >= 0 && c >= a) || (b < 0 && c < a));
534         return c;
535     }
536 
537     /**
538      * @dev Converts to absolute value, and fails on overflow.
539      */
540     function abs(int256 a) internal pure returns (int256) {
541         require(a != MIN_INT256);
542         return a < 0 ? -a : a;
543     }
544 
545 
546     function toUint256Safe(int256 a) internal pure returns (uint256) {
547         require(a >= 0);
548         return uint256(a);
549     }
550 }
551 
552 library SafeMathUint {
553   function toInt256Safe(uint256 a) internal pure returns (int256) {
554     int256 b = int256(a);
555     require(b >= 0);
556     return b;
557   }
558 }
559 
560 
561 interface IUniswapV2Router01 {
562     function factory() external pure returns (address);
563     function WETH() external pure returns (address);
564 
565     function addLiquidity(
566         address tokenA,
567         address tokenB,
568         uint amountADesired,
569         uint amountBDesired,
570         uint amountAMin,
571         uint amountBMin,
572         address to,
573         uint deadline
574     ) external returns (uint amountA, uint amountB, uint liquidity);
575     function addLiquidityETH(
576         address token,
577         uint amountTokenDesired,
578         uint amountTokenMin,
579         uint amountETHMin,
580         address to,
581         uint deadline
582     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
583     function removeLiquidity(
584         address tokenA,
585         address tokenB,
586         uint liquidity,
587         uint amountAMin,
588         uint amountBMin,
589         address to,
590         uint deadline
591     ) external returns (uint amountA, uint amountB);
592     function removeLiquidityETH(
593         address token,
594         uint liquidity,
595         uint amountTokenMin,
596         uint amountETHMin,
597         address to,
598         uint deadline
599     ) external returns (uint amountToken, uint amountETH);
600     function removeLiquidityWithPermit(
601         address tokenA,
602         address tokenB,
603         uint liquidity,
604         uint amountAMin,
605         uint amountBMin,
606         address to,
607         uint deadline,
608         bool approveMax, uint8 v, bytes32 r, bytes32 s
609     ) external returns (uint amountA, uint amountB);
610     function removeLiquidityETHWithPermit(
611         address token,
612         uint liquidity,
613         uint amountTokenMin,
614         uint amountETHMin,
615         address to,
616         uint deadline,
617         bool approveMax, uint8 v, bytes32 r, bytes32 s
618     ) external returns (uint amountToken, uint amountETH);
619     function swapExactTokensForTokens(
620         uint amountIn,
621         uint amountOutMin,
622         address[] calldata path,
623         address to,
624         uint deadline
625     ) external returns (uint[] memory amounts);
626     function swapTokensForExactTokens(
627         uint amountOut,
628         uint amountInMax,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external returns (uint[] memory amounts);
633     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
634         external
635         payable
636         returns (uint[] memory amounts);
637     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
638         external
639         returns (uint[] memory amounts);
640     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
641         external
642         returns (uint[] memory amounts);
643     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
644         external
645         payable
646         returns (uint[] memory amounts);
647 
648     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
649     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
650     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
651     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
652     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
653 }
654 
655 interface IUniswapV2Router02 is IUniswapV2Router01 {
656     function removeLiquidityETHSupportingFeeOnTransferTokens(
657         address token,
658         uint liquidity,
659         uint amountTokenMin,
660         uint amountETHMin,
661         address to,
662         uint deadline
663     ) external returns (uint amountETH);
664     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
665         address token,
666         uint liquidity,
667         uint amountTokenMin,
668         uint amountETHMin,
669         address to,
670         uint deadline,
671         bool approveMax, uint8 v, bytes32 r, bytes32 s
672     ) external returns (uint amountETH);
673 
674     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
675         uint amountIn,
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external;
681     function swapExactETHForTokensSupportingFeeOnTransferTokens(
682         uint amountOutMin,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external payable;
687     function swapExactTokensForETHSupportingFeeOnTransferTokens(
688         uint amountIn,
689         uint amountOutMin,
690         address[] calldata path,
691         address to,
692         uint deadline
693     ) external;
694 }
695 
696 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
697   using SafeMath for uint256;
698   using SafeMathUint for uint256;
699   using SafeMathInt for int256;
700 
701   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
702   // For more discussion about choosing the value of `magnitude`,
703   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
704   uint256 constant internal magnitude = 2**128;
705 
706   mapping(address => uint256) internal magnifiedDividendPerShare;
707   address[] public rewardTokens;
708   address public nextRewardToken;
709   uint256 public rewardTokenCounter;
710   
711   IUniswapV2Router02 public immutable uniswapV2Router;
712   
713   
714   // About dividendCorrection:
715   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
716   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
717   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
718   //   `dividendOf(_user)` should not be changed,
719   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
720   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
721   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
722   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
723   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
724   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
725   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
726   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
727   
728   mapping (address => uint256) public holderBalance;
729   uint256 public totalBalance;
730 
731   mapping(address => uint256) public totalDividendsDistributed;
732   
733   constructor(){
734       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
735       uniswapV2Router = _uniswapV2Router; 
736       
737       // Mainnet
738 
739       rewardTokens.push(address(0x8C130499D33097D4D000D3332E1672f75b431543)); // HOPPY - 0x8C130499D33097D4D000D3332E1672f75b431543
740       
741       nextRewardToken = rewardTokens[0];
742   }
743 
744   /// @dev Distributes dividends whenever ether is paid to this contract.
745   receive() external payable {
746     distributeDividends();
747   }
748 
749   /// @notice Distributes ether to token holders as dividends.
750   /// @dev It reverts if the total supply of tokens is 0.
751   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
752   /// About undistributed ether:
753   ///   In each distribution, there is a small amount of ether not distributed,
754   ///     the magnified amount of which is
755   ///     `(msg.value * magnitude) % totalSupply()`.
756   ///   With a well-chosen `magnitude`, the amount of undistributed ether
757   ///     (de-magnified) in a distribution can be less than 1 wei.
758   ///   We can actually keep track of the undistributed ether in a distribution
759   ///     and try to distribute it in the next distribution,
760   ///     but keeping track of such data on-chain costs much more than
761   ///     the saved ether, so we don't do that.
762     
763   function distributeDividends() public override payable { 
764     require(totalBalance > 0);
765     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
766     buyTokens(msg.value, nextRewardToken);
767     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
768     if (newBalance > 0) {
769       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
770         (newBalance).mul(magnitude) / totalBalance
771       );
772       emit DividendsDistributed(msg.sender, newBalance);
773 
774       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
775     }
776     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
777     nextRewardToken = rewardTokens[rewardTokenCounter];
778   }
779   
780   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
781     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
782         // generate the uniswap pair path of weth -> eth
783         address[] memory path = new address[](2);
784         path[0] = uniswapV2Router.WETH();
785         path[1] = rewardToken;
786 
787         // make the swap
788         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
789             0, // accept any amount of Ethereum
790             path,
791             address(this),
792             block.timestamp
793         );
794     }
795   
796   /// @notice Withdraws the ether distributed to the sender.
797   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
798   function withdrawDividend(address _rewardToken) external virtual override {
799     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
800   }
801 
802   /// @notice Withdraws the ether distributed to the sender.
803   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
804   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
805     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
806     if (_withdrawableDividend > 0) {
807       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
808       emit DividendWithdrawn(user, _withdrawableDividend);
809       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
810       return _withdrawableDividend;
811     }
812 
813     return 0;
814   }
815 
816 
817   /// @notice View the amount of dividend in wei that an address can withdraw.
818   /// @param _owner The address of a token holder.
819   /// @return The amount of dividend in wei that `_owner` can withdraw.
820   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
821     return withdrawableDividendOf(_owner, _rewardToken);
822   }
823 
824   /// @notice View the amount of dividend in wei that an address can withdraw.
825   /// @param _owner The address of a token holder.
826   /// @return The amount of dividend in wei that `_owner` can withdraw.
827   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
828     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
829   }
830 
831   /// @notice View the amount of dividend in wei that an address has withdrawn.
832   /// @param _owner The address of a token holder.
833   /// @return The amount of dividend in wei that `_owner` has withdrawn.
834   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
835     return withdrawnDividends[_owner][_rewardToken];
836   }
837 
838 
839   /// @notice View the amount of dividend in wei that an address has earned in total.
840   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
841   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
842   /// @param _owner The address of a token holder.
843   /// @return The amount of dividend in wei that `_owner` has earned in total.
844   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
845     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
846       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
847   }
848 
849   /// @dev Internal function that increases tokens to an account.
850   /// Update magnifiedDividendCorrections to keep dividends unchanged.
851   /// @param account The account that will receive the created tokens.
852   /// @param value The amount that will be created.
853   function _increase(address account, uint256 value) internal {
854     for (uint256 i; i < rewardTokens.length; i++){
855         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
856           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
857     }
858   }
859 
860   /// @dev Internal function that reduces an amount of the token of a given account.
861   /// Update magnifiedDividendCorrections to keep dividends unchanged.
862   /// @param account The account whose tokens will be burnt.
863   /// @param value The amount that will be burnt.
864   function _reduce(address account, uint256 value) internal {
865       for (uint256 i; i < rewardTokens.length; i++){
866         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
867           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
868       }
869   }
870 
871   function _setBalance(address account, uint256 newBalance) internal {
872     uint256 currentBalance = holderBalance[account];
873     holderBalance[account] = newBalance;
874     if(newBalance > currentBalance) {
875       uint256 increaseAmount = newBalance.sub(currentBalance);
876       _increase(account, increaseAmount);
877       totalBalance += increaseAmount;
878     } else if(newBalance < currentBalance) {
879       uint256 reduceAmount = currentBalance.sub(newBalance);
880       _reduce(account, reduceAmount);
881       totalBalance -= reduceAmount;
882     }
883   }
884 }
885 
886 contract DividendTracker is DividendPayingToken {
887     using SafeMath for uint256;
888     using SafeMathInt for int256;
889 
890     struct Map {
891         address[] keys;
892         mapping(address => uint) values;
893         mapping(address => uint) indexOf;
894         mapping(address => bool) inserted;
895     }
896 
897     function get(address key) private view returns (uint) {
898         return tokenHoldersMap.values[key];
899     }
900 
901     function getIndexOfKey(address key) private view returns (int) {
902         if(!tokenHoldersMap.inserted[key]) {
903             return -1;
904         }
905         return int(tokenHoldersMap.indexOf[key]);
906     }
907 
908     function getKeyAtIndex(uint index) private view returns (address) {
909         return tokenHoldersMap.keys[index];
910     }
911 
912 
913 
914     function size() private view returns (uint) {
915         return tokenHoldersMap.keys.length;
916     }
917 
918     function set(address key, uint val) private {
919         if (tokenHoldersMap.inserted[key]) {
920             tokenHoldersMap.values[key] = val;
921         } else {
922             tokenHoldersMap.inserted[key] = true;
923             tokenHoldersMap.values[key] = val;
924             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
925             tokenHoldersMap.keys.push(key);
926         }
927     }
928 
929     function remove(address key) private {
930         if (!tokenHoldersMap.inserted[key]) {
931             return;
932         }
933 
934         delete tokenHoldersMap.inserted[key];
935         delete tokenHoldersMap.values[key];
936 
937         uint index = tokenHoldersMap.indexOf[key];
938         uint lastIndex = tokenHoldersMap.keys.length - 1;
939         address lastKey = tokenHoldersMap.keys[lastIndex];
940 
941         tokenHoldersMap.indexOf[lastKey] = index;
942         delete tokenHoldersMap.indexOf[key];
943 
944         tokenHoldersMap.keys[index] = lastKey;
945         tokenHoldersMap.keys.pop();
946     }
947 
948     Map private tokenHoldersMap;
949     uint256 public lastProcessedIndex;
950 
951     mapping (address => bool) public excludedFromDividends;
952 
953     mapping (address => uint256) public lastClaimTimes;
954 
955     uint256 public claimWait;
956     uint256 public immutable minimumTokenBalanceForDividends;
957 
958     event ExcludeFromDividends(address indexed account);
959     event IncludeInDividends(address indexed account);
960     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
961 
962     event Claim(address indexed account, uint256 amount, bool indexed automatic);
963 
964     constructor() {
965         claimWait = 1200;
966         minimumTokenBalanceForDividends = 1000 * (10**18);
967     }
968 
969     function excludeFromDividends(address account) external onlyOwner {
970         excludedFromDividends[account] = true;
971 
972         _setBalance(account, 0);
973         remove(account);
974 
975         emit ExcludeFromDividends(account);
976     }
977     
978     function includeInDividends(address account) external onlyOwner {
979         require(excludedFromDividends[account]);
980         excludedFromDividends[account] = false;
981 
982         emit IncludeInDividends(account);
983     }
984 
985     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
986         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
987         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
988         emit ClaimWaitUpdated(newClaimWait, claimWait);
989         claimWait = newClaimWait;
990     }
991 
992     function getLastProcessedIndex() external view returns(uint256) {
993         return lastProcessedIndex;
994     }
995 
996     function getNumberOfTokenHolders() external view returns(uint256) {
997         return tokenHoldersMap.keys.length;
998     }
999 
1000     function getAccount(address _account, address _rewardToken)
1001         public view returns (
1002             address account,
1003             int256 index,
1004             int256 iterationsUntilProcessed,
1005             uint256 withdrawableDividends,
1006             uint256 totalDividends,
1007             uint256 lastClaimTime,
1008             uint256 nextClaimTime,
1009             uint256 secondsUntilAutoClaimAvailable) {
1010         account = _account;
1011 
1012         index = getIndexOfKey(account);
1013 
1014         iterationsUntilProcessed = -1;
1015 
1016         if(index >= 0) {
1017             if(uint256(index) > lastProcessedIndex) {
1018                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1019             }
1020             else {
1021                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1022                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1023                                                         0;
1024 
1025 
1026                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1027             }
1028         }
1029 
1030 
1031         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1032         totalDividends = accumulativeDividendOf(account, _rewardToken);
1033 
1034         lastClaimTime = lastClaimTimes[account];
1035 
1036         nextClaimTime = lastClaimTime > 0 ?
1037                                     lastClaimTime.add(claimWait) :
1038                                     0;
1039 
1040         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1041                                                     nextClaimTime.sub(block.timestamp) :
1042                                                     0;
1043     }
1044 
1045     function getAccountAtIndex(uint256 index, address _rewardToken)
1046         external view returns (
1047             address,
1048             int256,
1049             int256,
1050             uint256,
1051             uint256,
1052             uint256,
1053             uint256,
1054             uint256) {
1055         if(index >= size()) {
1056             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1057         }
1058 
1059         address account = getKeyAtIndex(index);
1060 
1061         return getAccount(account, _rewardToken);
1062     }
1063 
1064     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1065         if(lastClaimTime > block.timestamp)  {
1066             return false;
1067         }
1068 
1069         return block.timestamp.sub(lastClaimTime) >= claimWait;
1070     }
1071 
1072     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1073         if(excludedFromDividends[account]) {
1074             return;
1075         }
1076 
1077         if(newBalance >= minimumTokenBalanceForDividends) {
1078             _setBalance(account, newBalance);
1079             set(account, newBalance);
1080         }
1081         else {
1082             _setBalance(account, 0);
1083             remove(account);
1084         }
1085 
1086         processAccount(account, true);
1087     }
1088     
1089     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1090         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1091 
1092         if(numberOfTokenHolders == 0) {
1093             return (0, 0, lastProcessedIndex);
1094         }
1095 
1096         uint256 _lastProcessedIndex = lastProcessedIndex;
1097 
1098         uint256 gasUsed = 0;
1099 
1100         uint256 gasLeft = gasleft();
1101 
1102         uint256 iterations = 0;
1103         uint256 claims = 0;
1104 
1105         while(gasUsed < gas && iterations < numberOfTokenHolders) {
1106             _lastProcessedIndex++;
1107 
1108             if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1109                 _lastProcessedIndex = 0;
1110             }
1111 
1112             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1113 
1114             if(canAutoClaim(lastClaimTimes[account])) {
1115                 if(processAccount(payable(account), true)) {
1116                     claims++;
1117                 }
1118             }
1119 
1120             iterations++;
1121 
1122             uint256 newGasLeft = gasleft();
1123 
1124             if(gasLeft > newGasLeft) {
1125                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1126             }
1127             gasLeft = newGasLeft;
1128         }
1129 
1130         lastProcessedIndex = _lastProcessedIndex;
1131 
1132         return (iterations, claims, lastProcessedIndex);
1133     }
1134 
1135     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1136         uint256 amount;
1137         bool paid;
1138         for (uint256 i; i < rewardTokens.length; i++){
1139             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1140             if(amount > 0) {
1141                 lastClaimTimes[account] = block.timestamp;
1142                 emit Claim(account, amount, automatic);
1143                 paid = true;
1144             }
1145         }
1146         return paid;
1147     }
1148 }
1149 
1150 contract HOPPA is ERC20, Ownable {
1151     using SafeMath for uint256;
1152 
1153     IUniswapV2Router02 public immutable uniswapV2Router;
1154     address public immutable uniswapV2Pair;
1155 
1156     bool private swapping;
1157 
1158     DividendTracker public dividendTracker;
1159 
1160     address public operationsWallet;
1161     
1162     uint256 public swapTokensAtAmount;
1163     uint256 public maxTxn;
1164     
1165     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1166     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1167     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1168     
1169     bool public limitsInEffect = true;
1170     bool public tradingActive = false;
1171     bool public swapEnabled = false;
1172     
1173      // Anti-bot and anti-whale mappings and variables
1174     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1175     bool public transferDelayEnabled = true;
1176     
1177     uint256 public constant feeDivisor = 1000;
1178 
1179     uint256 public totalSellFees;
1180     uint256 public rewardsSellFee;
1181     uint256 public operationsSellFee;
1182     uint256 public liquiditySellFee;
1183     
1184     uint256 public totalBuyFees;
1185     uint256 public rewardsBuyFee;
1186     uint256 public operationsBuyFee;
1187     uint256 public liquidityBuyFee;
1188     
1189     uint256 public tokensForRewards;
1190     uint256 public tokensForOperations;
1191     uint256 public tokensForLiquidity;
1192     
1193     uint256 public gasForProcessing = 0;
1194 
1195     uint256 public lpWithdrawRequestTimestamp;
1196     uint256 public lpWithdrawRequestDuration = 3 days;
1197     bool public lpWithdrawRequestPending;
1198     uint256 public lpPercToWithDraw;
1199 
1200     /******************/
1201 
1202     // exlcude from fees and max transaction amount
1203     mapping (address => bool) private _isExcludedFromFees;
1204 
1205     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1206 
1207     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1208     // could be subject to a maximum transfer amount
1209     mapping (address => bool) public automatedMarketMakerPairs;
1210 
1211     event ExcludeFromFees(address indexed account, bool isExcluded);
1212     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1213     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1214 
1215     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1216 
1217     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1218 
1219     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1220 
1221     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1222     
1223     event SwapAndLiquify(
1224         uint256 tokensSwapped,
1225         uint256 ethReceived,
1226         uint256 tokensIntoLiqudity
1227     );
1228 
1229     event SendDividends(
1230         uint256 tokensSwapped,
1231         uint256 amount
1232     );
1233 
1234     event ProcessedDividendTracker(
1235         uint256 iterations,
1236         uint256 claims,
1237         uint256 lastProcessedIndex,
1238         bool indexed automatic,
1239         uint256 gas,
1240         address indexed processor
1241     );
1242 
1243     event RequestedLPWithdraw();
1244     
1245     event WithdrewLPForMigration();
1246 
1247     event CanceledLpWithdrawRequest();
1248 
1249     constructor() ERC20("Hoppa", "HOPPA") {
1250 
1251         uint256 totalSupply = 1 * 1e12 * 1e18;
1252         
1253         swapTokensAtAmount = totalSupply * 2 / 1000; // 0.2% swap tokens amount
1254         maxTxn = totalSupply * 2 / 100; // 2% Max wallet
1255 
1256         rewardsBuyFee = 30;
1257         operationsBuyFee = 170;
1258         liquidityBuyFee = 0;
1259         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1260         
1261         rewardsSellFee = 30;
1262         operationsSellFee = 270;
1263         liquiditySellFee = 0;
1264         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1265 
1266         dividendTracker = new DividendTracker();
1267         
1268         operationsWallet = address(0x28D23993CE0B825aE7dF4AfaC36324465d9c6ECe); // set as operations wallet
1269 
1270         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1271         
1272          // Create a uniswap pair for this new token
1273         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1274             .createPair(address(this), _uniswapV2Router.WETH());
1275 
1276         uniswapV2Router = _uniswapV2Router;
1277         uniswapV2Pair = _uniswapV2Pair;
1278 
1279         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1280 
1281         // exclude from receiving dividends
1282         dividendTracker.excludeFromDividends(address(dividendTracker));
1283         dividendTracker.excludeFromDividends(address(this));
1284         dividendTracker.excludeFromDividends(owner());
1285         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1286         dividendTracker.excludeFromDividends(address(0xdead));
1287         
1288         // exclude from paying fees or having max transaction amount
1289         excludeFromFees(owner(), true);
1290         excludeFromFees(address(this), true);
1291         excludeFromFees(address(0xdead), true);
1292         excludeFromMaxTransaction(owner(), true);
1293         excludeFromMaxTransaction(address(this), true);
1294         excludeFromMaxTransaction(address(dividendTracker), true);
1295         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1296         excludeFromMaxTransaction(address(0xdead), true);
1297 
1298         _createInitialSupply(address(owner()), totalSupply);
1299     }
1300 
1301     receive() external payable {
1302 
1303     }
1304 
1305     // only use if conducting a presale
1306     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1307         excludeFromFees(_presaleAddress, true);
1308         dividendTracker.excludeFromDividends(_presaleAddress);
1309         excludeFromMaxTransaction(_presaleAddress, true);
1310     }
1311 
1312      // disable Transfer delay - cannot be reenabled
1313     function disableTransferDelay() external onlyOwner returns (bool){
1314         transferDelayEnabled = false;
1315         return true;
1316     }
1317 
1318     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1319     function excludeFromDividends(address account) external onlyOwner {
1320         dividendTracker.excludeFromDividends(account);
1321     }
1322 
1323     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1324     function includeInDividends(address account) external onlyOwner {
1325         dividendTracker.includeInDividends(account);
1326     }
1327     
1328     // once enabled, can never be turned off
1329     function enableTrading() external onlyOwner {
1330         require(!tradingActive, "Cannot re-enable trading");
1331         tradingActive = true;
1332         swapEnabled = true;
1333         tradingActiveBlock = block.number;
1334     }
1335     
1336     // only use to disable contract sales if absolutely necessary (emergency use only)
1337     function updateSwapEnabled(bool enabled) external onlyOwner(){
1338         swapEnabled = enabled;
1339     }
1340 
1341     function updateMaxWalletAmount(uint256 newNum) external {
1342         require(_msgSender() == operationsWallet);
1343 
1344         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxTxn lower than 1%");
1345         maxTxn = newNum * (10**18);
1346     }
1347     
1348     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1349         operationsBuyFee = _operationsFee;
1350         rewardsBuyFee = _rewardsFee;
1351         liquidityBuyFee = _liquidityFee;
1352         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1353         require(totalBuyFees <= 300, "Must keep fees at 30% or less");
1354     }
1355     
1356     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1357         operationsSellFee = _operationsFee;
1358         rewardsSellFee = _rewardsFee;
1359         liquiditySellFee = _liquidityFee;
1360         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1361         require(totalSellFees <= 300, "Must keep fees at 30% or less");
1362     }
1363 
1364     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1365         _isExcludedMaxTransactionAmount[updAds] = isEx;
1366         emit ExcludedMaxTransactionAmount(updAds, isEx);
1367     }
1368 
1369     function excludeFromFees(address account, bool excluded) public onlyOwner {
1370         _isExcludedFromFees[account] = excluded;
1371 
1372         emit ExcludeFromFees(account, excluded);
1373     }
1374 
1375     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1376         for(uint256 i = 0; i < accounts.length; i++) {
1377             _isExcludedFromFees[accounts[i]] = excluded;
1378         }
1379 
1380         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1381     }
1382 
1383     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1384         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1385 
1386         _setAutomatedMarketMakerPair(pair, value);
1387     }
1388 
1389     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1390         automatedMarketMakerPairs[pair] = value;
1391 
1392         excludeFromMaxTransaction(pair, value);
1393         
1394         if(value) {
1395             dividendTracker.excludeFromDividends(pair);
1396         }
1397 
1398         emit SetAutomatedMarketMakerPair(pair, value);
1399     }
1400 
1401     function updateSwapTokensAtAmount(uint256 _value) external {
1402         require(_msgSender() == operationsWallet);
1403         require(_value >=1 && _value <=200); // .01% <= _value <= 2%
1404         swapTokensAtAmount = totalSupply() * _value / (10000); 
1405     }
1406 
1407     function updateOperationsWallet(address newOperationsWallet) external {
1408         require(_msgSender() == operationsWallet);
1409 
1410         require(newOperationsWallet != address(0), "may not set to 0 address");
1411         excludeFromFees(newOperationsWallet, true);
1412         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1413         operationsWallet = newOperationsWallet;
1414     }
1415 
1416     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1417         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1418         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1419         emit GasForProcessingUpdated(newValue, gasForProcessing);
1420         gasForProcessing = newValue;
1421     }
1422 
1423     function updateClaimWait(uint256 claimWait) external onlyOwner {
1424         dividendTracker.updateClaimWait(claimWait);
1425     }
1426 
1427     function getClaimWait() external view returns(uint256) {
1428         return dividendTracker.claimWait();
1429     }
1430 
1431     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1432         return dividendTracker.totalDividendsDistributed(rewardToken);
1433     }
1434 
1435     function isExcludedFromFees(address account) external view returns(bool) {
1436         return _isExcludedFromFees[account];
1437     }
1438 
1439     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1440         return dividendTracker.withdrawableDividendOf(account, rewardToken);
1441     }
1442 
1443     function dividendTokenBalanceOf(address account) external view returns (uint256) {
1444         return dividendTracker.holderBalance(account);
1445     }
1446 
1447     function getAccountDividendsInfo(address account, address rewardToken)
1448         external view returns (
1449             address,
1450             int256,
1451             int256,
1452             uint256,
1453             uint256,
1454             uint256,
1455             uint256,
1456             uint256) {
1457         return dividendTracker.getAccount(account, rewardToken);
1458     }
1459 
1460     function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1461         external view returns (
1462             address,
1463             int256,
1464             int256,
1465             uint256,
1466             uint256,
1467             uint256,
1468             uint256,
1469             uint256) {
1470         return dividendTracker.getAccountAtIndex(index, rewardToken);
1471     }
1472 
1473     function processDividendTracker(uint256 gas) external {
1474         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1475         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1476     }
1477 
1478     function claim() external {
1479         dividendTracker.processAccount(payable(msg.sender), false);
1480     }
1481 
1482     function getLastProcessedIndex() external view returns(uint256) {
1483         return dividendTracker.getLastProcessedIndex();
1484     }
1485 
1486     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1487         return dividendTracker.getNumberOfTokenHolders();
1488     }
1489     
1490     function getNumberOfDividends() external view returns(uint256) {
1491         return dividendTracker.totalBalance();
1492     }
1493     
1494     // remove limits after token is stable
1495     function removeLimits() external onlyOwner returns (bool){
1496         limitsInEffect = false;
1497         transferDelayEnabled = false;
1498         return true;
1499     }
1500     
1501     function _transfer(
1502         address from,
1503         address to,
1504         uint256 amount
1505     ) internal override {
1506         require(from != address(0), "ERC20: transfer from the zero address");
1507         require(to != address(0), "ERC20: transfer to the zero address");
1508         
1509          if(amount == 0) {
1510             super._transfer(from, to, 0);
1511             return;
1512         }
1513         
1514         if(!tradingActive){
1515             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1516         }
1517         
1518         if(limitsInEffect){
1519             if (
1520                 from != owner() &&
1521                 to != owner() &&
1522                 to != address(0) &&
1523                 to != address(0xdead) &&
1524                 !swapping
1525             ){
1526 
1527                 //when buy
1528                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1529                     if (tradingActiveBlock + 3  > block.number) {
1530                     require(!isContract(to));
1531                 }
1532                     require(amount + balanceOf(to) <= maxTxn, "Unable to exceed Max Wallet");
1533                 } 
1534                 //when sell
1535                 else if(!_isExcludedMaxTransactionAmount[to]) {
1536                     require(amount + balanceOf(to) <= maxTxn, "Unable to exceed Max Wallet");
1537                 }
1538             }
1539         }
1540 
1541         uint256 contractTokenBalance = balanceOf(address(this));
1542         
1543         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1544 
1545         if( 
1546             canSwap &&
1547             swapEnabled &&
1548             !swapping &&
1549             !automatedMarketMakerPairs[from] &&
1550             !_isExcludedFromFees[from] &&
1551             !_isExcludedFromFees[to]
1552         ) {
1553             swapping = true;
1554             swapBack();
1555             swapping = false;
1556         }
1557 
1558         bool takeFee = !swapping;
1559 
1560         // if any account belongs to _isExcludedFromFee account then remove the fee
1561         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1562             takeFee = false;
1563         }
1564         
1565         uint256 fees = 0;
1566         
1567         // no taxes on transfers (non buys/sells)
1568         if(takeFee){
1569             // on sell
1570             if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1571                 fees = amount.mul(totalSellFees).div(feeDivisor);
1572                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1573                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1574                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1575             }
1576             
1577             // on buy
1578             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1579                 fees = amount.mul(totalBuyFees).div(feeDivisor);
1580                 tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1581                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1582                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1583             }
1584 
1585             if(fees > 0){    
1586                 super._transfer(from, address(this), fees);
1587             }
1588             
1589             amount -= fees;
1590         }
1591 
1592         super._transfer(from, to, amount);
1593 
1594         dividendTracker.setBalance(payable(from), balanceOf(from));
1595         dividendTracker.setBalance(payable(to), balanceOf(to));
1596 
1597         if(!swapping && gasForProcessing > 0) {
1598             uint256 gas = gasForProcessing;
1599 
1600             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1601                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1602             }
1603             catch {}
1604         }
1605     }
1606     
1607     function isContract(address account) private view returns (bool) {
1608         uint256 size;
1609         assembly {
1610             size := extcodesize(account)
1611         }
1612         return size > 0;
1613     }
1614 
1615     function swapTokensForEth(uint256 tokenAmount) private {
1616 
1617         // generate the uniswap pair path of token -> weth
1618         address[] memory path = new address[](2);
1619         path[0] = address(this);
1620         path[1] = uniswapV2Router.WETH();
1621 
1622         _approve(address(this), address(uniswapV2Router), tokenAmount);
1623 
1624         // make the swap
1625         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1626             tokenAmount,
1627             0, // accept any amount of ETH
1628             path,
1629             address(this),
1630             block.timestamp
1631         );
1632         
1633     }
1634     
1635     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1636         // approve token transfer to cover all possible scenarios
1637         _approve(address(this), address(uniswapV2Router), tokenAmount);
1638 
1639         // add the liquidity
1640         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1641             address(this),
1642             tokenAmount,
1643             0, // slippage is unavoidable
1644             0, // slippage is unavoidable
1645             address(operationsWallet),
1646             block.timestamp
1647         );
1648 
1649     }
1650     
1651     function swapBack() private {
1652         uint256 contractBalance = balanceOf(address(this));
1653         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1654         
1655         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1656         
1657         // Halve the amount of liquidity tokens
1658         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1659         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1660         
1661         uint256 initialETHBalance = address(this).balance;
1662 
1663         swapTokensForEth(amountToSwapForETH); 
1664         
1665         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1666         
1667         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1668         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1669         
1670         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1671         
1672         tokensForLiquidity = 0;
1673         tokensForOperations = 0;
1674         tokensForRewards = 0;
1675         
1676         if(liquidityTokens > 0 && ethForLiquidity > 0){
1677             addLiquidity(liquidityTokens, ethForLiquidity);
1678             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1679         }
1680         
1681         // call twice to force buy of both reward tokens.
1682         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1683 
1684         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1685     }
1686 
1687     function withdrawStuckEth() external onlyOwner {
1688         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1689         require(success, "failed to withdraw");
1690     }
1691 
1692     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1693         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1694         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1695         lpWithdrawRequestTimestamp = block.timestamp;
1696         lpWithdrawRequestPending = true;
1697         lpPercToWithDraw = percToWithdraw;
1698         emit RequestedLPWithdraw();
1699     }
1700 
1701     function nextAvailableLpWithdrawDate() public view returns (uint256){
1702         if(lpWithdrawRequestPending){
1703             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1704         }
1705         else {
1706             return 0;  // 0 means no open requests
1707         }
1708     }
1709 
1710     function withdrawRequestedLP() external onlyOwner {
1711         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1712         lpWithdrawRequestTimestamp = 0;
1713         lpWithdrawRequestPending = false;
1714 
1715         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1716         
1717         lpPercToWithDraw = 0;
1718 
1719         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1720     }
1721 
1722     function cancelLPWithdrawRequest() external onlyOwner {
1723         lpWithdrawRequestPending = false;
1724         lpPercToWithDraw = 0;
1725         lpWithdrawRequestTimestamp = 0;
1726         emit CanceledLpWithdrawRequest();
1727     }
1728 }