1 /**
2 
3 Welcome to the world of Hoppa. 
4 
5 $HAMA is a reflection of love. Hold $HAMA and earn $HAMS
6 
7 5/5 Tax 4% HAMS reflections 1%TEAM
8 
9 /https://t.me/HAMACOIN
10 
11 **/
12 
13 // SPDX-License-Identifier: MIT   
14 
15 pragma solidity 0.8.20;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IUniswapV2Factory {
29     function createPair(address tokenA, address tokenB) external returns (address pair);
30 }
31 
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(
87         address sender,
88         address recipient,
89         uint256 amount
90     ) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 interface IERC20Metadata is IERC20 {
108     /**
109      * @dev Returns the name of the token.
110      */
111     function name() external view returns (string memory);
112 
113     /**
114      * @dev Returns the symbol of the token.
115      */
116     function symbol() external view returns (string memory);
117 
118     /**
119      * @dev Returns the decimals places of the token.
120      */
121     function decimals() external view returns (uint8);
122 }
123 
124 
125 contract ERC20 is Context, IERC20, IERC20Metadata {
126     mapping(address => uint256) private _balances;
127 
128     mapping(address => mapping(address => uint256)) private _allowances;
129 
130     uint256 private _totalSupply;
131 
132     string private _name;
133     string private _symbol;
134 
135     constructor(string memory name_, string memory symbol_) {
136         _name = name_;
137         _symbol = symbol_;
138     }
139 
140     function name() public view virtual override returns (string memory) {
141         return _name;
142     }
143 
144     function symbol() public view virtual override returns (string memory) {
145         return _symbol;
146     }
147 
148     function decimals() public view virtual override returns (uint8) {
149         return 18;
150     }
151 
152     function totalSupply() public view virtual override returns (uint256) {
153         return _totalSupply;
154     }
155 
156     function balanceOf(address account) public view virtual override returns (uint256) {
157         return _balances[account];
158     }
159 
160     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
161         _transfer(_msgSender(), recipient, amount);
162         return true;
163     }
164 
165     function allowance(address owner, address spender) public view virtual override returns (uint256) {
166         return _allowances[owner][spender];
167     }
168 
169     function approve(address spender, uint256 amount) public virtual override returns (bool) {
170         _approve(_msgSender(), spender, amount);
171         return true;
172     }
173 
174     function transferFrom(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) public virtual override returns (bool) {
179         _transfer(sender, recipient, amount);
180 
181         uint256 currentAllowance = _allowances[sender][_msgSender()];
182         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
183         unchecked {
184             _approve(sender, _msgSender(), currentAllowance - amount);
185         }
186 
187         return true;
188     }
189 
190     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
191         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
192         return true;
193     }
194 
195     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
196         uint256 currentAllowance = _allowances[_msgSender()][spender];
197         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
198         unchecked {
199             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
200         }
201 
202         return true;
203     }
204 
205     function _transfer(
206         address sender,
207         address recipient,
208         uint256 amount
209     ) internal virtual {
210         require(sender != address(0), "ERC20: transfer from the zero address");
211         require(recipient != address(0), "ERC20: transfer to the zero address");
212 
213         uint256 senderBalance = _balances[sender];
214         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
215         unchecked {
216             _balances[sender] = senderBalance - amount;
217         }
218         _balances[recipient] += amount;
219 
220         emit Transfer(sender, recipient, amount);
221     }
222 
223     function _createInitialSupply(address account, uint256 amount) internal virtual {
224         require(account != address(0), "ERC20: mint to the zero address");
225         _totalSupply += amount;
226         _balances[account] += amount;
227         emit Transfer(address(0), account, amount);
228     }
229 
230     function _approve(
231         address owner,
232         address spender,
233         uint256 amount
234     ) internal virtual {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237 
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 }
242 
243 interface DividendPayingTokenOptionalInterface {
244   /// @notice View the amount of dividend in wei that an address can withdraw.
245   /// @param _owner The address of a token holder.
246   /// @return The amount of dividend in wei that `_owner` can withdraw.
247   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
248 
249   /// @notice View the amount of dividend in wei that an address has withdrawn.
250   /// @param _owner The address of a token holder.
251   /// @return The amount of dividend in wei that `_owner` has withdrawn.
252   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
253 
254   /// @notice View the amount of dividend in wei that an address has earned in total.
255   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
256   /// @param _owner The address of a token holder.
257   /// @return The amount of dividend in wei that `_owner` has earned in total.
258   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
259 }
260 
261 interface DividendPayingTokenInterface {
262   /// @notice View the amount of dividend in wei that an address can withdraw.
263   /// @param _owner The address of a token holder.
264   /// @return The amount of dividend in wei that `_owner` can withdraw.
265   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
266 
267   /// @notice Distributes ether to token holders as dividends.
268   /// @dev SHOULD distribute the paid ether to token holders as dividends.
269   ///  SHOULD NOT directly transfer ether to token holders in this function.
270   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
271   function distributeDividends() external payable;
272 
273   /// @notice Withdraws the ether distributed to the sender.
274   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
275   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
276   function withdrawDividend(address _rewardToken) external;
277 
278   /// @dev This event MUST emit when ether is distributed to token holders.
279   /// @param from The address which sends ether to this contract.
280   /// @param weiAmount The amount of distributed ether in wei.
281   event DividendsDistributed(
282     address indexed from,
283     uint256 weiAmount
284   );
285 
286   /// @dev This event MUST emit when an address withdraws their dividend.
287   /// @param to The address which withdraws ether from this contract.
288   /// @param weiAmount The amount of withdrawn ether in wei.
289   event DividendWithdrawn(
290     address indexed to,
291     uint256 weiAmount
292   );
293 }
294 
295 library SafeMath {
296     /**
297      * @dev Returns the addition of two unsigned integers, reverting on
298      * overflow.
299      *
300      * Counterpart to Solidity's `+` operator.
301      *
302      * Requirements:
303      *
304      * - Addition cannot overflow.
305      */
306     function add(uint256 a, uint256 b) internal pure returns (uint256) {
307         uint256 c = a + b;
308         require(c >= a, "SafeMath: addition overflow");
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the subtraction of two unsigned integers, reverting on
315      * overflow (when the result is negative).
316      *
317      * Counterpart to Solidity's `-` operator.
318      *
319      * Requirements:
320      *
321      * - Subtraction cannot overflow.
322      */
323     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
324         return sub(a, b, "SafeMath: subtraction overflow");
325     }
326 
327     /**
328      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
329      * overflow (when the result is negative).
330      *
331      * Counterpart to Solidity's `-` operator.
332      *
333      * Requirements:
334      *
335      * - Subtraction cannot overflow.
336      */
337     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338         require(b <= a, errorMessage);
339         uint256 c = a - b;
340 
341         return c;
342     }
343 
344     /**
345      * @dev Returns the multiplication of two unsigned integers, reverting on
346      * overflow.
347      *
348      * Counterpart to Solidity's `*` operator.
349      *
350      * Requirements:
351      *
352      * - Multiplication cannot overflow.
353      */
354     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
355         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
356         // benefit is lost if 'b' is also tested.
357         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
358         if (a == 0) {
359             return 0;
360         }
361 
362         uint256 c = a * b;
363         require(c / a == b, "SafeMath: multiplication overflow");
364 
365         return c;
366     }
367 
368     /**
369      * @dev Returns the integer division of two unsigned integers. Reverts on
370      * division by zero. The result is rounded towards zero.
371      *
372      * Counterpart to Solidity's `/` operator. Note: this function uses a
373      * `revert` opcode (which leaves remaining gas untouched) while Solidity
374      * uses an invalid opcode to revert (consuming all remaining gas).
375      *
376      * Requirements:
377      *
378      * - The divisor cannot be zero.
379      */
380     function div(uint256 a, uint256 b) internal pure returns (uint256) {
381         return div(a, b, "SafeMath: division by zero");
382     }
383 
384     /**
385      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
386      * division by zero. The result is rounded towards zero.
387      *
388      * Counterpart to Solidity's `/` operator. Note: this function uses a
389      * `revert` opcode (which leaves remaining gas untouched) while Solidity
390      * uses an invalid opcode to revert (consuming all remaining gas).
391      *
392      * Requirements:
393      *
394      * - The divisor cannot be zero.
395      */
396     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
397         require(b > 0, errorMessage);
398         uint256 c = a / b;
399         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
400 
401         return c;
402     }
403 
404     /**
405      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
406      * Reverts when dividing by zero.
407      *
408      * Counterpart to Solidity's `%` operator. This function uses a `revert`
409      * opcode (which leaves remaining gas untouched) while Solidity uses an
410      * invalid opcode to revert (consuming all remaining gas).
411      *
412      * Requirements:
413      *
414      * - The divisor cannot be zero.
415      */
416     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
417         return mod(a, b, "SafeMath: modulo by zero");
418     }
419 
420     /**
421      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
422      * Reverts with custom message when dividing by zero.
423      *
424      * Counterpart to Solidity's `%` operator. This function uses a `revert`
425      * opcode (which leaves remaining gas untouched) while Solidity uses an
426      * invalid opcode to revert (consuming all remaining gas).
427      *
428      * Requirements:
429      *
430      * - The divisor cannot be zero.
431      */
432     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
433         require(b != 0, errorMessage);
434         return a % b;
435     }
436 }
437 
438 contract Ownable is Context {
439     address private _owner;
440 
441     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
442     
443     /**
444      * @dev Initializes the contract setting the deployer as the initial owner.
445      */
446     constructor () {
447         address msgSender = _msgSender();
448         _owner = msgSender;
449         emit OwnershipTransferred(address(0), msgSender);
450     }
451 
452     /**
453      * @dev Returns the address of the current owner.
454      */
455     function owner() public view returns (address) {
456         return _owner;
457     }
458 
459     /**
460      * @dev Throws if called by any account other than the owner.
461      */
462     modifier onlyOwner() {
463         require(_owner == _msgSender(), "Ownable: caller is not the owner");
464         _;
465     }
466 
467     /**
468      * @dev Leaves the contract without owner. It will not be possible to call
469      * `onlyOwner` functions anymore. Can only be called by the current owner.
470      *
471      * NOTE: Renouncing ownership will leave the contract without an owner,
472      * thereby removing any functionality that is only available to the owner.
473      */
474     function renounceOwnership() public virtual onlyOwner {
475         emit OwnershipTransferred(_owner, address(0));
476         _owner = address(0);
477     }
478 
479     /**
480      * @dev Transfers ownership of the contract to a new account (`newOwner`).
481      * Can only be called by the current owner.
482      */
483     function transferOwnership(address newOwner) public virtual onlyOwner {
484         require(newOwner != address(0), "Ownable: new owner is the zero address");
485         emit OwnershipTransferred(_owner, newOwner);
486         _owner = newOwner;
487     }
488 }
489 
490 library SafeMathInt {
491     int256 private constant MIN_INT256 = int256(1) << 255;
492     int256 private constant MAX_INT256 = ~(int256(1) << 255);
493 
494     /**
495      * @dev Multiplies two int256 variables and fails on overflow.
496      */
497     function mul(int256 a, int256 b) internal pure returns (int256) {
498         int256 c = a * b;
499 
500         // Detect overflow when multiplying MIN_INT256 with -1
501         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
502         require((b == 0) || (c / b == a));
503         return c;
504     }
505 
506     /**
507      * @dev Division of two int256 variables and fails on overflow.
508      */
509     function div(int256 a, int256 b) internal pure returns (int256) {
510         // Prevent overflow when dividing MIN_INT256 by -1
511         require(b != -1 || a != MIN_INT256);
512 
513         // Solidity already throws when dividing by 0.
514         return a / b;
515     }
516 
517     /**
518      * @dev Subtracts two int256 variables and fails on overflow.
519      */
520     function sub(int256 a, int256 b) internal pure returns (int256) {
521         int256 c = a - b;
522         require((b >= 0 && c <= a) || (b < 0 && c > a));
523         return c;
524     }
525 
526     /**
527      * @dev Adds two int256 variables and fails on overflow.
528      */
529     function add(int256 a, int256 b) internal pure returns (int256) {
530         int256 c = a + b;
531         require((b >= 0 && c >= a) || (b < 0 && c < a));
532         return c;
533     }
534 
535     /**
536      * @dev Converts to absolute value, and fails on overflow.
537      */
538     function abs(int256 a) internal pure returns (int256) {
539         require(a != MIN_INT256);
540         return a < 0 ? -a : a;
541     }
542 
543 
544     function toUint256Safe(int256 a) internal pure returns (uint256) {
545         require(a >= 0);
546         return uint256(a);
547     }
548 }
549 
550 library SafeMathUint {
551   function toInt256Safe(uint256 a) internal pure returns (int256) {
552     int256 b = int256(a);
553     require(b >= 0);
554     return b;
555   }
556 }
557 
558 
559 interface IUniswapV2Router01 {
560     function factory() external pure returns (address);
561     function WETH() external pure returns (address);
562 
563     function addLiquidity(
564         address tokenA,
565         address tokenB,
566         uint amountADesired,
567         uint amountBDesired,
568         uint amountAMin,
569         uint amountBMin,
570         address to,
571         uint deadline
572     ) external returns (uint amountA, uint amountB, uint liquidity);
573     function addLiquidityETH(
574         address token,
575         uint amountTokenDesired,
576         uint amountTokenMin,
577         uint amountETHMin,
578         address to,
579         uint deadline
580     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
581     function removeLiquidity(
582         address tokenA,
583         address tokenB,
584         uint liquidity,
585         uint amountAMin,
586         uint amountBMin,
587         address to,
588         uint deadline
589     ) external returns (uint amountA, uint amountB);
590     function removeLiquidityETH(
591         address token,
592         uint liquidity,
593         uint amountTokenMin,
594         uint amountETHMin,
595         address to,
596         uint deadline
597     ) external returns (uint amountToken, uint amountETH);
598     function removeLiquidityWithPermit(
599         address tokenA,
600         address tokenB,
601         uint liquidity,
602         uint amountAMin,
603         uint amountBMin,
604         address to,
605         uint deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint amountA, uint amountB);
608     function removeLiquidityETHWithPermit(
609         address token,
610         uint liquidity,
611         uint amountTokenMin,
612         uint amountETHMin,
613         address to,
614         uint deadline,
615         bool approveMax, uint8 v, bytes32 r, bytes32 s
616     ) external returns (uint amountToken, uint amountETH);
617     function swapExactTokensForTokens(
618         uint amountIn,
619         uint amountOutMin,
620         address[] calldata path,
621         address to,
622         uint deadline
623     ) external returns (uint[] memory amounts);
624     function swapTokensForExactTokens(
625         uint amountOut,
626         uint amountInMax,
627         address[] calldata path,
628         address to,
629         uint deadline
630     ) external returns (uint[] memory amounts);
631     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
632         external
633         payable
634         returns (uint[] memory amounts);
635     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
636         external
637         returns (uint[] memory amounts);
638     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
639         external
640         returns (uint[] memory amounts);
641     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
642         external
643         payable
644         returns (uint[] memory amounts);
645 
646     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
647     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
648     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
649     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
650     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
651 }
652 
653 interface IUniswapV2Router02 is IUniswapV2Router01 {
654     function removeLiquidityETHSupportingFeeOnTransferTokens(
655         address token,
656         uint liquidity,
657         uint amountTokenMin,
658         uint amountETHMin,
659         address to,
660         uint deadline
661     ) external returns (uint amountETH);
662     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
663         address token,
664         uint liquidity,
665         uint amountTokenMin,
666         uint amountETHMin,
667         address to,
668         uint deadline,
669         bool approveMax, uint8 v, bytes32 r, bytes32 s
670     ) external returns (uint amountETH);
671 
672     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
673         uint amountIn,
674         uint amountOutMin,
675         address[] calldata path,
676         address to,
677         uint deadline
678     ) external;
679     function swapExactETHForTokensSupportingFeeOnTransferTokens(
680         uint amountOutMin,
681         address[] calldata path,
682         address to,
683         uint deadline
684     ) external payable;
685     function swapExactTokensForETHSupportingFeeOnTransferTokens(
686         uint amountIn,
687         uint amountOutMin,
688         address[] calldata path,
689         address to,
690         uint deadline
691     ) external;
692 }
693 
694 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
695   using SafeMath for uint256;
696   using SafeMathUint for uint256;
697   using SafeMathInt for int256;
698 
699   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
700   // For more discussion about choosing the value of `magnitude`,
701   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
702   uint256 constant internal magnitude = 2**128;
703 
704   mapping(address => uint256) internal magnifiedDividendPerShare;
705   address[] public rewardTokens;
706   address public nextRewardToken;
707   uint256 public rewardTokenCounter;
708   
709   IUniswapV2Router02 public immutable uniswapV2Router;
710   
711   
712   // About dividendCorrection:
713   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
714   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
715   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
716   //   `dividendOf(_user)` should not be changed,
717   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
718   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
719   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
720   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
721   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
722   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
723   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
724   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
725   
726   mapping (address => uint256) public holderBalance;
727   uint256 public totalBalance;
728 
729   mapping(address => uint256) public totalDividendsDistributed;
730   
731   constructor(){
732       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
733       uniswapV2Router = _uniswapV2Router; 
734       
735       // Mainnet
736 
737       rewardTokens.push(address(0x48c87cDacb6Bb6BF6E5Cd85D8ee5C847084c7410)); // HAMS - 0x48c87cDacb6Bb6BF6E5Cd85D8ee5C847084c7410
738       
739       nextRewardToken = rewardTokens[0];
740   }
741 
742   /// @dev Distributes dividends whenever ether is paid to this contract.
743   receive() external payable {
744     distributeDividends();
745   }
746 
747   /// @notice Distributes ether to token holders as dividends.
748   /// @dev It reverts if the total supply of tokens is 0.
749   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
750   /// About undistributed ether:
751   ///   In each distribution, there is a small amount of ether not distributed,
752   ///     the magnified amount of which is
753   ///     `(msg.value * magnitude) % totalSupply()`.
754   ///   With a well-chosen `magnitude`, the amount of undistributed ether
755   ///     (de-magnified) in a distribution can be less than 1 wei.
756   ///   We can actually keep track of the undistributed ether in a distribution
757   ///     and try to distribute it in the next distribution,
758   ///     but keeping track of such data on-chain costs much more than
759   ///     the saved ether, so we don't do that.
760     
761   function distributeDividends() public override payable { 
762     require(totalBalance > 0);
763     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
764     buyTokens(msg.value, nextRewardToken);
765     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
766     if (newBalance > 0) {
767       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
768         (newBalance).mul(magnitude) / totalBalance
769       );
770       emit DividendsDistributed(msg.sender, newBalance);
771 
772       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
773     }
774     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
775     nextRewardToken = rewardTokens[rewardTokenCounter];
776   }
777   
778   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
779     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
780         // generate the uniswap pair path of weth -> eth
781         address[] memory path = new address[](2);
782         path[0] = uniswapV2Router.WETH();
783         path[1] = rewardToken;
784 
785         // make the swap
786         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
787             0, // accept any amount of Ethereum
788             path,
789             address(this),
790             block.timestamp
791         );
792     }
793   
794   /// @notice Withdraws the ether distributed to the sender.
795   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
796   function withdrawDividend(address _rewardToken) external virtual override {
797     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
798   }
799 
800   /// @notice Withdraws the ether distributed to the sender.
801   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
802   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
803     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
804     if (_withdrawableDividend > 0) {
805       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
806       emit DividendWithdrawn(user, _withdrawableDividend);
807       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
808       return _withdrawableDividend;
809     }
810 
811     return 0;
812   }
813 
814 
815   /// @notice View the amount of dividend in wei that an address can withdraw.
816   /// @param _owner The address of a token holder.
817   /// @return The amount of dividend in wei that `_owner` can withdraw.
818   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
819     return withdrawableDividendOf(_owner, _rewardToken);
820   }
821 
822   /// @notice View the amount of dividend in wei that an address can withdraw.
823   /// @param _owner The address of a token holder.
824   /// @return The amount of dividend in wei that `_owner` can withdraw.
825   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
826     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
827   }
828 
829   /// @notice View the amount of dividend in wei that an address has withdrawn.
830   /// @param _owner The address of a token holder.
831   /// @return The amount of dividend in wei that `_owner` has withdrawn.
832   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
833     return withdrawnDividends[_owner][_rewardToken];
834   }
835 
836 
837   /// @notice View the amount of dividend in wei that an address has earned in total.
838   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
839   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
840   /// @param _owner The address of a token holder.
841   /// @return The amount of dividend in wei that `_owner` has earned in total.
842   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
843     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
844       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
845   }
846 
847   /// @dev Internal function that increases tokens to an account.
848   /// Update magnifiedDividendCorrections to keep dividends unchanged.
849   /// @param account The account that will receive the created tokens.
850   /// @param value The amount that will be created.
851   function _increase(address account, uint256 value) internal {
852     for (uint256 i; i < rewardTokens.length; i++){
853         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
854           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
855     }
856   }
857 
858   /// @dev Internal function that reduces an amount of the token of a given account.
859   /// Update magnifiedDividendCorrections to keep dividends unchanged.
860   /// @param account The account whose tokens will be burnt.
861   /// @param value The amount that will be burnt.
862   function _reduce(address account, uint256 value) internal {
863       for (uint256 i; i < rewardTokens.length; i++){
864         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
865           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
866       }
867   }
868 
869   function _setBalance(address account, uint256 newBalance) internal {
870     uint256 currentBalance = holderBalance[account];
871     holderBalance[account] = newBalance;
872     if(newBalance > currentBalance) {
873       uint256 increaseAmount = newBalance.sub(currentBalance);
874       _increase(account, increaseAmount);
875       totalBalance += increaseAmount;
876     } else if(newBalance < currentBalance) {
877       uint256 reduceAmount = currentBalance.sub(newBalance);
878       _reduce(account, reduceAmount);
879       totalBalance -= reduceAmount;
880     }
881   }
882 }
883 
884 contract DividendTracker is DividendPayingToken {
885     using SafeMath for uint256;
886     using SafeMathInt for int256;
887 
888     struct Map {
889         address[] keys;
890         mapping(address => uint) values;
891         mapping(address => uint) indexOf;
892         mapping(address => bool) inserted;
893     }
894 
895     function get(address key) private view returns (uint) {
896         return tokenHoldersMap.values[key];
897     }
898 
899     function getIndexOfKey(address key) private view returns (int) {
900         if(!tokenHoldersMap.inserted[key]) {
901             return -1;
902         }
903         return int(tokenHoldersMap.indexOf[key]);
904     }
905 
906     function getKeyAtIndex(uint index) private view returns (address) {
907         return tokenHoldersMap.keys[index];
908     }
909 
910 
911 
912     function size() private view returns (uint) {
913         return tokenHoldersMap.keys.length;
914     }
915 
916     function set(address key, uint val) private {
917         if (tokenHoldersMap.inserted[key]) {
918             tokenHoldersMap.values[key] = val;
919         } else {
920             tokenHoldersMap.inserted[key] = true;
921             tokenHoldersMap.values[key] = val;
922             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
923             tokenHoldersMap.keys.push(key);
924         }
925     }
926 
927     function remove(address key) private {
928         if (!tokenHoldersMap.inserted[key]) {
929             return;
930         }
931 
932         delete tokenHoldersMap.inserted[key];
933         delete tokenHoldersMap.values[key];
934 
935         uint index = tokenHoldersMap.indexOf[key];
936         uint lastIndex = tokenHoldersMap.keys.length - 1;
937         address lastKey = tokenHoldersMap.keys[lastIndex];
938 
939         tokenHoldersMap.indexOf[lastKey] = index;
940         delete tokenHoldersMap.indexOf[key];
941 
942         tokenHoldersMap.keys[index] = lastKey;
943         tokenHoldersMap.keys.pop();
944     }
945 
946     Map private tokenHoldersMap;
947     uint256 public lastProcessedIndex;
948 
949     mapping (address => bool) public excludedFromDividends;
950 
951     mapping (address => uint256) public lastClaimTimes;
952 
953     uint256 public claimWait;
954     uint256 public immutable minimumTokenBalanceForDividends;
955 
956     event ExcludeFromDividends(address indexed account);
957     event IncludeInDividends(address indexed account);
958     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
959 
960     event Claim(address indexed account, uint256 amount, bool indexed automatic);
961 
962     constructor() {
963         claimWait = 1200;
964         minimumTokenBalanceForDividends = 1000 * (10**18);
965     }
966 
967     function excludeFromDividends(address account) external onlyOwner {
968         excludedFromDividends[account] = true;
969 
970         _setBalance(account, 0);
971         remove(account);
972 
973         emit ExcludeFromDividends(account);
974     }
975     
976     function includeInDividends(address account) external onlyOwner {
977         require(excludedFromDividends[account]);
978         excludedFromDividends[account] = false;
979 
980         emit IncludeInDividends(account);
981     }
982 
983     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
984         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
985         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
986         emit ClaimWaitUpdated(newClaimWait, claimWait);
987         claimWait = newClaimWait;
988     }
989 
990     function getLastProcessedIndex() external view returns(uint256) {
991         return lastProcessedIndex;
992     }
993 
994     function getNumberOfTokenHolders() external view returns(uint256) {
995         return tokenHoldersMap.keys.length;
996     }
997 
998     function getAccount(address _account, address _rewardToken)
999         public view returns (
1000             address account,
1001             int256 index,
1002             int256 iterationsUntilProcessed,
1003             uint256 withdrawableDividends,
1004             uint256 totalDividends,
1005             uint256 lastClaimTime,
1006             uint256 nextClaimTime,
1007             uint256 secondsUntilAutoClaimAvailable) {
1008         account = _account;
1009 
1010         index = getIndexOfKey(account);
1011 
1012         iterationsUntilProcessed = -1;
1013 
1014         if(index >= 0) {
1015             if(uint256(index) > lastProcessedIndex) {
1016                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1017             }
1018             else {
1019                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1020                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1021                                                         0;
1022 
1023 
1024                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1025             }
1026         }
1027 
1028 
1029         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1030         totalDividends = accumulativeDividendOf(account, _rewardToken);
1031 
1032         lastClaimTime = lastClaimTimes[account];
1033 
1034         nextClaimTime = lastClaimTime > 0 ?
1035                                     lastClaimTime.add(claimWait) :
1036                                     0;
1037 
1038         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1039                                                     nextClaimTime.sub(block.timestamp) :
1040                                                     0;
1041     }
1042 
1043     function getAccountAtIndex(uint256 index, address _rewardToken)
1044         external view returns (
1045             address,
1046             int256,
1047             int256,
1048             uint256,
1049             uint256,
1050             uint256,
1051             uint256,
1052             uint256) {
1053         if(index >= size()) {
1054             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1055         }
1056 
1057         address account = getKeyAtIndex(index);
1058 
1059         return getAccount(account, _rewardToken);
1060     }
1061 
1062     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1063         if(lastClaimTime > block.timestamp)  {
1064             return false;
1065         }
1066 
1067         return block.timestamp.sub(lastClaimTime) >= claimWait;
1068     }
1069 
1070     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1071         if(excludedFromDividends[account]) {
1072             return;
1073         }
1074 
1075         if(newBalance >= minimumTokenBalanceForDividends) {
1076             _setBalance(account, newBalance);
1077             set(account, newBalance);
1078         }
1079         else {
1080             _setBalance(account, 0);
1081             remove(account);
1082         }
1083 
1084         processAccount(account, true);
1085     }
1086     
1087     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1088         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1089 
1090         if(numberOfTokenHolders == 0) {
1091             return (0, 0, lastProcessedIndex);
1092         }
1093 
1094         uint256 _lastProcessedIndex = lastProcessedIndex;
1095 
1096         uint256 gasUsed = 0;
1097 
1098         uint256 gasLeft = gasleft();
1099 
1100         uint256 iterations = 0;
1101         uint256 claims = 0;
1102 
1103         while(gasUsed < gas && iterations < numberOfTokenHolders) {
1104             _lastProcessedIndex++;
1105 
1106             if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1107                 _lastProcessedIndex = 0;
1108             }
1109 
1110             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1111 
1112             if(canAutoClaim(lastClaimTimes[account])) {
1113                 if(processAccount(payable(account), true)) {
1114                     claims++;
1115                 }
1116             }
1117 
1118             iterations++;
1119 
1120             uint256 newGasLeft = gasleft();
1121 
1122             if(gasLeft > newGasLeft) {
1123                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1124             }
1125             gasLeft = newGasLeft;
1126         }
1127 
1128         lastProcessedIndex = _lastProcessedIndex;
1129 
1130         return (iterations, claims, lastProcessedIndex);
1131     }
1132 
1133     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1134         uint256 amount;
1135         bool paid;
1136         for (uint256 i; i < rewardTokens.length; i++){
1137             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1138             if(amount > 0) {
1139                 lastClaimTimes[account] = block.timestamp;
1140                 emit Claim(account, amount, automatic);
1141                 paid = true;
1142             }
1143         }
1144         return paid;
1145     }
1146 }
1147 
1148 contract HAMA is ERC20, Ownable {
1149     using SafeMath for uint256;
1150 
1151     IUniswapV2Router02 public immutable uniswapV2Router;
1152     address public immutable uniswapV2Pair;
1153 
1154     bool private swapping;
1155 
1156     DividendTracker public dividendTracker;
1157 
1158     address public operationsWallet;
1159     
1160     uint256 public swapTokensAtAmount;
1161     uint256 public maxTxn;
1162     
1163     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1164     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1165     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1166     
1167     bool public limitsInEffect = true;
1168     bool public tradingActive = false;
1169     bool public swapEnabled = false;
1170     
1171      // Anti-bot and anti-whale mappings and variables
1172     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1173     bool public transferDelayEnabled = true;
1174     
1175     uint256 public constant feeDivisor = 1000;
1176 
1177     uint256 public totalSellFees;
1178     uint256 public rewardsSellFee;
1179     uint256 public operationsSellFee;
1180     uint256 public liquiditySellFee;
1181     
1182     uint256 public totalBuyFees;
1183     uint256 public rewardsBuyFee;
1184     uint256 public operationsBuyFee;
1185     uint256 public liquidityBuyFee;
1186     
1187     uint256 public tokensForRewards;
1188     uint256 public tokensForOperations;
1189     uint256 public tokensForLiquidity;
1190     
1191     uint256 public gasForProcessing = 0;
1192 
1193     uint256 public lpWithdrawRequestTimestamp;
1194     uint256 public lpWithdrawRequestDuration = 3 days;
1195     bool public lpWithdrawRequestPending;
1196     uint256 public lpPercToWithDraw;
1197 
1198     /******************/
1199 
1200     // exlcude from fees and max transaction amount
1201     mapping (address => bool) private _isExcludedFromFees;
1202 
1203     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1204 
1205     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1206     // could be subject to a maximum transfer amount
1207     mapping (address => bool) public automatedMarketMakerPairs;
1208 
1209     event ExcludeFromFees(address indexed account, bool isExcluded);
1210     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1211     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1212 
1213     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1214 
1215     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1216 
1217     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1218 
1219     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1220     
1221     event SwapAndLiquify(
1222         uint256 tokensSwapped,
1223         uint256 ethReceived,
1224         uint256 tokensIntoLiqudity
1225     );
1226 
1227     event SendDividends(
1228         uint256 tokensSwapped,
1229         uint256 amount
1230     );
1231 
1232     event ProcessedDividendTracker(
1233         uint256 iterations,
1234         uint256 claims,
1235         uint256 lastProcessedIndex,
1236         bool indexed automatic,
1237         uint256 gas,
1238         address indexed processor
1239     );
1240 
1241     event RequestedLPWithdraw();
1242     
1243     event WithdrewLPForMigration();
1244 
1245     event CanceledLpWithdrawRequest();
1246 
1247     constructor() ERC20("Hama", "HAMA") {
1248 
1249         uint256 totalSupply = 1 * 1e12 * 1e18;
1250         
1251         swapTokensAtAmount = totalSupply * 2 / 1000; // 0.2% swap tokens amount
1252         maxTxn = totalSupply * 2 / 100; // 2% Max wallet
1253 
1254         rewardsBuyFee = 30;
1255         operationsBuyFee = 170;
1256         liquidityBuyFee = 0;
1257         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1258         
1259         rewardsSellFee = 30;
1260         operationsSellFee = 270;
1261         liquiditySellFee = 0;
1262         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1263 
1264         dividendTracker = new DividendTracker();
1265         
1266         operationsWallet = address(0xd48aC1b891D74ee73fA8d86967aE2CAc7BfBc015); // set as operations wallet
1267 
1268         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1269         
1270          // Create a uniswap pair for this new token
1271         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1272             .createPair(address(this), _uniswapV2Router.WETH());
1273 
1274         uniswapV2Router = _uniswapV2Router;
1275         uniswapV2Pair = _uniswapV2Pair;
1276 
1277         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1278 
1279         // exclude from receiving dividends
1280         dividendTracker.excludeFromDividends(address(dividendTracker));
1281         dividendTracker.excludeFromDividends(address(this));
1282         dividendTracker.excludeFromDividends(owner());
1283         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1284         dividendTracker.excludeFromDividends(address(0xdead));
1285         
1286         // exclude from paying fees or having max transaction amount
1287         excludeFromFees(owner(), true);
1288         excludeFromFees(address(this), true);
1289         excludeFromFees(address(0xdead), true);
1290         excludeFromMaxTransaction(owner(), true);
1291         excludeFromMaxTransaction(address(this), true);
1292         excludeFromMaxTransaction(address(dividendTracker), true);
1293         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1294         excludeFromMaxTransaction(address(0xdead), true);
1295 
1296         _createInitialSupply(address(owner()), totalSupply);
1297     }
1298 
1299     receive() external payable {
1300 
1301     }
1302 
1303     // only use if conducting a presale
1304     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1305         excludeFromFees(_presaleAddress, true);
1306         dividendTracker.excludeFromDividends(_presaleAddress);
1307         excludeFromMaxTransaction(_presaleAddress, true);
1308     }
1309 
1310      // disable Transfer delay - cannot be reenabled
1311     function disableTransferDelay() external onlyOwner returns (bool){
1312         transferDelayEnabled = false;
1313         return true;
1314     }
1315 
1316     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1317     function excludeFromDividends(address account) external onlyOwner {
1318         dividendTracker.excludeFromDividends(account);
1319     }
1320 
1321     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1322     function includeInDividends(address account) external onlyOwner {
1323         dividendTracker.includeInDividends(account);
1324     }
1325     
1326     // once enabled, can never be turned off
1327     function enableTrading() external onlyOwner {
1328         require(!tradingActive, "Cannot re-enable trading");
1329         tradingActive = true;
1330         swapEnabled = true;
1331         tradingActiveBlock = block.number;
1332     }
1333     
1334     // only use to disable contract sales if absolutely necessary (emergency use only)
1335     function updateSwapEnabled(bool enabled) external onlyOwner(){
1336         swapEnabled = enabled;
1337     }
1338 
1339     function updateMaxWalletAmount(uint256 newNum) external {
1340         require(_msgSender() == operationsWallet);
1341 
1342         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxTxn lower than 1%");
1343         maxTxn = newNum * (10**18);
1344     }
1345     
1346     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1347         operationsBuyFee = _operationsFee;
1348         rewardsBuyFee = _rewardsFee;
1349         liquidityBuyFee = _liquidityFee;
1350         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1351         require(totalBuyFees <= 300, "Must keep fees at 30% or less");
1352     }
1353     
1354     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1355         operationsSellFee = _operationsFee;
1356         rewardsSellFee = _rewardsFee;
1357         liquiditySellFee = _liquidityFee;
1358         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1359         require(totalSellFees <= 300, "Must keep fees at 30% or less");
1360     }
1361 
1362     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1363         _isExcludedMaxTransactionAmount[updAds] = isEx;
1364         emit ExcludedMaxTransactionAmount(updAds, isEx);
1365     }
1366 
1367     function excludeFromFees(address account, bool excluded) public onlyOwner {
1368         _isExcludedFromFees[account] = excluded;
1369 
1370         emit ExcludeFromFees(account, excluded);
1371     }
1372 
1373     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1374         for(uint256 i = 0; i < accounts.length; i++) {
1375             _isExcludedFromFees[accounts[i]] = excluded;
1376         }
1377 
1378         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1379     }
1380 
1381     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1382         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1383 
1384         _setAutomatedMarketMakerPair(pair, value);
1385     }
1386 
1387     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1388         automatedMarketMakerPairs[pair] = value;
1389 
1390         excludeFromMaxTransaction(pair, value);
1391         
1392         if(value) {
1393             dividendTracker.excludeFromDividends(pair);
1394         }
1395 
1396         emit SetAutomatedMarketMakerPair(pair, value);
1397     }
1398 
1399     function updateSwapTokensAtAmount(uint256 _value) external {
1400         require(_msgSender() == operationsWallet);
1401         require(_value >=1 && _value <=200); // .01% <= _value <= 2%
1402         swapTokensAtAmount = totalSupply() * _value / (10000); 
1403     }
1404 
1405     function updateOperationsWallet(address newOperationsWallet) external {
1406         require(_msgSender() == operationsWallet);
1407 
1408         require(newOperationsWallet != address(0), "may not set to 0 address");
1409         excludeFromFees(newOperationsWallet, true);
1410         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1411         operationsWallet = newOperationsWallet;
1412     }
1413 
1414     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1415         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1416         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1417         emit GasForProcessingUpdated(newValue, gasForProcessing);
1418         gasForProcessing = newValue;
1419     }
1420 
1421     function updateClaimWait(uint256 claimWait) external onlyOwner {
1422         dividendTracker.updateClaimWait(claimWait);
1423     }
1424 
1425     function getClaimWait() external view returns(uint256) {
1426         return dividendTracker.claimWait();
1427     }
1428 
1429     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1430         return dividendTracker.totalDividendsDistributed(rewardToken);
1431     }
1432 
1433     function isExcludedFromFees(address account) external view returns(bool) {
1434         return _isExcludedFromFees[account];
1435     }
1436 
1437     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1438         return dividendTracker.withdrawableDividendOf(account, rewardToken);
1439     }
1440 
1441     function dividendTokenBalanceOf(address account) external view returns (uint256) {
1442         return dividendTracker.holderBalance(account);
1443     }
1444 
1445     function getAccountDividendsInfo(address account, address rewardToken)
1446         external view returns (
1447             address,
1448             int256,
1449             int256,
1450             uint256,
1451             uint256,
1452             uint256,
1453             uint256,
1454             uint256) {
1455         return dividendTracker.getAccount(account, rewardToken);
1456     }
1457 
1458     function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1459         external view returns (
1460             address,
1461             int256,
1462             int256,
1463             uint256,
1464             uint256,
1465             uint256,
1466             uint256,
1467             uint256) {
1468         return dividendTracker.getAccountAtIndex(index, rewardToken);
1469     }
1470 
1471     function processDividendTracker(uint256 gas) external {
1472         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1473         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1474     }
1475 
1476     function claim() external {
1477         dividendTracker.processAccount(payable(msg.sender), false);
1478     }
1479 
1480     function getLastProcessedIndex() external view returns(uint256) {
1481         return dividendTracker.getLastProcessedIndex();
1482     }
1483 
1484     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1485         return dividendTracker.getNumberOfTokenHolders();
1486     }
1487     
1488     function getNumberOfDividends() external view returns(uint256) {
1489         return dividendTracker.totalBalance();
1490     }
1491     
1492     // remove limits after token is stable
1493     function removeLimits() external onlyOwner returns (bool){
1494         limitsInEffect = false;
1495         transferDelayEnabled = false;
1496         return true;
1497     }
1498     
1499     function _transfer(
1500         address from,
1501         address to,
1502         uint256 amount
1503     ) internal override {
1504         require(from != address(0), "ERC20: transfer from the zero address");
1505         require(to != address(0), "ERC20: transfer to the zero address");
1506         
1507          if(amount == 0) {
1508             super._transfer(from, to, 0);
1509             return;
1510         }
1511         
1512         if(!tradingActive){
1513             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1514         }
1515         
1516         if(limitsInEffect){
1517             if (
1518                 from != owner() &&
1519                 to != owner() &&
1520                 to != address(0) &&
1521                 to != address(0xdead) &&
1522                 !swapping
1523             ){
1524 
1525                 //when buy
1526                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1527                     if (tradingActiveBlock + 3  > block.number) {
1528                     require(!isContract(to));
1529                 }
1530                     require(amount + balanceOf(to) <= maxTxn, "Unable to exceed Max Wallet");
1531                 } 
1532                 //when sell
1533                 else if(!_isExcludedMaxTransactionAmount[to]) {
1534                     require(amount + balanceOf(to) <= maxTxn, "Unable to exceed Max Wallet");
1535                 }
1536             }
1537         }
1538 
1539         uint256 contractTokenBalance = balanceOf(address(this));
1540         
1541         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1542 
1543         if( 
1544             canSwap &&
1545             swapEnabled &&
1546             !swapping &&
1547             !automatedMarketMakerPairs[from] &&
1548             !_isExcludedFromFees[from] &&
1549             !_isExcludedFromFees[to]
1550         ) {
1551             swapping = true;
1552             swapBack();
1553             swapping = false;
1554         }
1555 
1556         bool takeFee = !swapping;
1557 
1558         // if any account belongs to _isExcludedFromFee account then remove the fee
1559         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1560             takeFee = false;
1561         }
1562         
1563         uint256 fees = 0;
1564         
1565         // no taxes on transfers (non buys/sells)
1566         if(takeFee){
1567             // on sell
1568             if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1569                 fees = amount.mul(totalSellFees).div(feeDivisor);
1570                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1571                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1572                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1573             }
1574             
1575             // on buy
1576             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1577                 fees = amount.mul(totalBuyFees).div(feeDivisor);
1578                 tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1579                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1580                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1581             }
1582 
1583             if(fees > 0){    
1584                 super._transfer(from, address(this), fees);
1585             }
1586             
1587             amount -= fees;
1588         }
1589 
1590         super._transfer(from, to, amount);
1591 
1592         dividendTracker.setBalance(payable(from), balanceOf(from));
1593         dividendTracker.setBalance(payable(to), balanceOf(to));
1594 
1595         if(!swapping && gasForProcessing > 0) {
1596             uint256 gas = gasForProcessing;
1597 
1598             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1599                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1600             }
1601             catch {}
1602         }
1603     }
1604     
1605     function isContract(address account) private view returns (bool) {
1606         uint256 size;
1607         assembly {
1608             size := extcodesize(account)
1609         }
1610         return size > 0;
1611     }
1612 
1613     function swapTokensForEth(uint256 tokenAmount) private {
1614 
1615         // generate the uniswap pair path of token -> weth
1616         address[] memory path = new address[](2);
1617         path[0] = address(this);
1618         path[1] = uniswapV2Router.WETH();
1619 
1620         _approve(address(this), address(uniswapV2Router), tokenAmount);
1621 
1622         // make the swap
1623         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1624             tokenAmount,
1625             0, // accept any amount of ETH
1626             path,
1627             address(this),
1628             block.timestamp
1629         );
1630         
1631     }
1632     
1633     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1634         // approve token transfer to cover all possible scenarios
1635         _approve(address(this), address(uniswapV2Router), tokenAmount);
1636 
1637         // add the liquidity
1638         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1639             address(this),
1640             tokenAmount,
1641             0, // slippage is unavoidable
1642             0, // slippage is unavoidable
1643             address(operationsWallet),
1644             block.timestamp
1645         );
1646 
1647     }
1648     
1649     function swapBack() private {
1650         uint256 contractBalance = balanceOf(address(this));
1651         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1652         
1653         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1654         
1655         // Halve the amount of liquidity tokens
1656         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1657         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1658         
1659         uint256 initialETHBalance = address(this).balance;
1660 
1661         swapTokensForEth(amountToSwapForETH); 
1662         
1663         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1664         
1665         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1666         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1667         
1668         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1669         
1670         tokensForLiquidity = 0;
1671         tokensForOperations = 0;
1672         tokensForRewards = 0;
1673         
1674         if(liquidityTokens > 0 && ethForLiquidity > 0){
1675             addLiquidity(liquidityTokens, ethForLiquidity);
1676             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1677         }
1678         
1679         // call twice to force buy of both reward tokens.
1680         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1681 
1682         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1683     }
1684 
1685     function withdrawStuckEth() external onlyOwner {
1686         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1687         require(success, "failed to withdraw");
1688     }
1689 
1690     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1691         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1692         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1693         lpWithdrawRequestTimestamp = block.timestamp;
1694         lpWithdrawRequestPending = true;
1695         lpPercToWithDraw = percToWithdraw;
1696         emit RequestedLPWithdraw();
1697     }
1698 
1699     function nextAvailableLpWithdrawDate() public view returns (uint256){
1700         if(lpWithdrawRequestPending){
1701             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1702         }
1703         else {
1704             return 0;  // 0 means no open requests
1705         }
1706     }
1707 
1708     function withdrawRequestedLP() external onlyOwner {
1709         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1710         lpWithdrawRequestTimestamp = 0;
1711         lpWithdrawRequestPending = false;
1712 
1713         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1714         
1715         lpPercToWithDraw = 0;
1716 
1717         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1718     }
1719 
1720     function cancelLPWithdrawRequest() external onlyOwner {
1721         lpWithdrawRequestPending = false;
1722         lpPercToWithDraw = 0;
1723         lpWithdrawRequestTimestamp = 0;
1724         emit CanceledLpWithdrawRequest();
1725     }
1726 }