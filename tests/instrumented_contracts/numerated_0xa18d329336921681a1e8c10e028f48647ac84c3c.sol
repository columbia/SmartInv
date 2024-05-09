1 /**
2 
3 */
4 
5 pragma solidity 0.8.13;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IUniswapV2Factory {
19     function createPair(address tokenA, address tokenB) external returns (address pair);
20 }
21 
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 
115 contract ERC20 is Context, IERC20, IERC20Metadata {
116     mapping(address => uint256) private _balances;
117 
118     mapping(address => mapping(address => uint256)) private _allowances;
119 
120     uint256 private _totalSupply;
121 
122     string private _name;
123     string private _symbol;
124 
125     constructor(string memory name_, string memory symbol_) {
126         _name = name_;
127         _symbol = symbol_;
128     }
129 
130     function name() public view virtual override returns (string memory) {
131         return _name;
132     }
133 
134     function symbol() public view virtual override returns (string memory) {
135         return _symbol;
136     }
137 
138     function decimals() public view virtual override returns (uint8) {
139         return 18;
140     }
141 
142     function totalSupply() public view virtual override returns (uint256) {
143         return _totalSupply;
144     }
145 
146     function balanceOf(address account) public view virtual override returns (uint256) {
147         return _balances[account];
148     }
149 
150     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
151         _transfer(_msgSender(), recipient, amount);
152         return true;
153     }
154 
155     function allowance(address owner, address spender) public view virtual override returns (uint256) {
156         return _allowances[owner][spender];
157     }
158 
159     function approve(address spender, uint256 amount) public virtual override returns (bool) {
160         _approve(_msgSender(), spender, amount);
161         return true;
162     }
163 
164     function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) public virtual override returns (bool) {
169         _transfer(sender, recipient, amount);
170 
171         uint256 currentAllowance = _allowances[sender][_msgSender()];
172         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
173         unchecked {
174             _approve(sender, _msgSender(), currentAllowance - amount);
175         }
176 
177         return true;
178     }
179 
180     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
181         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
182         return true;
183     }
184 
185     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
186         uint256 currentAllowance = _allowances[_msgSender()][spender];
187         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
188         unchecked {
189             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
190         }
191 
192         return true;
193     }
194 
195     function _transfer(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) internal virtual {
200         require(sender != address(0), "ERC20: transfer from the zero address");
201         require(recipient != address(0), "ERC20: transfer to the zero address");
202 
203         uint256 senderBalance = _balances[sender];
204         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
205         unchecked {
206             _balances[sender] = senderBalance - amount;
207         }
208         _balances[recipient] += amount;
209 
210         emit Transfer(sender, recipient, amount);
211     }
212 
213     function _createInitialSupply(address account, uint256 amount) internal virtual {
214         require(account != address(0), "ERC20: mint to the zero address");
215         _totalSupply += amount;
216         _balances[account] += amount;
217         emit Transfer(address(0), account, amount);
218     }
219 
220     function _approve(
221         address owner,
222         address spender,
223         uint256 amount
224     ) internal virtual {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227 
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 }
232 
233 interface DividendPayingTokenOptionalInterface {
234   /// @notice View the amount of dividend in wei that an address can withdraw.
235   /// @param _owner The address of a token holder.
236   /// @return The amount of dividend in wei that `_owner` can withdraw.
237   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
238 
239   /// @notice View the amount of dividend in wei that an address has withdrawn.
240   /// @param _owner The address of a token holder.
241   /// @return The amount of dividend in wei that `_owner` has withdrawn.
242   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
243 
244   /// @notice View the amount of dividend in wei that an address has earned in total.
245   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
246   /// @param _owner The address of a token holder.
247   /// @return The amount of dividend in wei that `_owner` has earned in total.
248   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
249 }
250 
251 interface DividendPayingTokenInterface {
252   /// @notice View the amount of dividend in wei that an address can withdraw.
253   /// @param _owner The address of a token holder.
254   /// @return The amount of dividend in wei that `_owner` can withdraw.
255   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
256 
257   /// @notice Distributes ether to token holders as dividends.
258   /// @dev SHOULD distribute the paid ether to token holders as dividends.
259   ///  SHOULD NOT directly transfer ether to token holders in this function.
260   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
261   function distributeDividends() external payable;
262 
263   /// @notice Withdraws the ether distributed to the sender.
264   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
265   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
266   function withdrawDividend(address _rewardToken) external;
267 
268   /// @dev This event MUST emit when ether is distributed to token holders.
269   /// @param from The address which sends ether to this contract.
270   /// @param weiAmount The amount of distributed ether in wei.
271   event DividendsDistributed(
272     address indexed from,
273     uint256 weiAmount
274   );
275 
276   /// @dev This event MUST emit when an address withdraws their dividend.
277   /// @param to The address which withdraws ether from this contract.
278   /// @param weiAmount The amount of withdrawn ether in wei.
279   event DividendWithdrawn(
280     address indexed to,
281     uint256 weiAmount
282   );
283 }
284 
285 library SafeMath {
286     /**
287      * @dev Returns the addition of two unsigned integers, reverting on
288      * overflow.
289      *
290      * Counterpart to Solidity's `+` operator.
291      *
292      * Requirements:
293      *
294      * - Addition cannot overflow.
295      */
296     function add(uint256 a, uint256 b) internal pure returns (uint256) {
297         uint256 c = a + b;
298         require(c >= a, "SafeMath: addition overflow");
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the subtraction of two unsigned integers, reverting on
305      * overflow (when the result is negative).
306      *
307      * Counterpart to Solidity's `-` operator.
308      *
309      * Requirements:
310      *
311      * - Subtraction cannot overflow.
312      */
313     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
314         return sub(a, b, "SafeMath: subtraction overflow");
315     }
316 
317     /**
318      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
319      * overflow (when the result is negative).
320      *
321      * Counterpart to Solidity's `-` operator.
322      *
323      * Requirements:
324      *
325      * - Subtraction cannot overflow.
326      */
327     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b <= a, errorMessage);
329         uint256 c = a - b;
330 
331         return c;
332     }
333 
334     /**
335      * @dev Returns the multiplication of two unsigned integers, reverting on
336      * overflow.
337      *
338      * Counterpart to Solidity's `*` operator.
339      *
340      * Requirements:
341      *
342      * - Multiplication cannot overflow.
343      */
344     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
345         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
346         // benefit is lost if 'b' is also tested.
347         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
348         if (a == 0) {
349             return 0;
350         }
351 
352         uint256 c = a * b;
353         require(c / a == b, "SafeMath: multiplication overflow");
354 
355         return c;
356     }
357 
358     /**
359      * @dev Returns the integer division of two unsigned integers. Reverts on
360      * division by zero. The result is rounded towards zero.
361      *
362      * Counterpart to Solidity's `/` operator. Note: this function uses a
363      * `revert` opcode (which leaves remaining gas untouched) while Solidity
364      * uses an invalid opcode to revert (consuming all remaining gas).
365      *
366      * Requirements:
367      *
368      * - The divisor cannot be zero.
369      */
370     function div(uint256 a, uint256 b) internal pure returns (uint256) {
371         return div(a, b, "SafeMath: division by zero");
372     }
373 
374     /**
375      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
376      * division by zero. The result is rounded towards zero.
377      *
378      * Counterpart to Solidity's `/` operator. Note: this function uses a
379      * `revert` opcode (which leaves remaining gas untouched) while Solidity
380      * uses an invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
387         require(b > 0, errorMessage);
388         uint256 c = a / b;
389         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
390 
391         return c;
392     }
393 
394     /**
395      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
396      * Reverts when dividing by zero.
397      *
398      * Counterpart to Solidity's `%` operator. This function uses a `revert`
399      * opcode (which leaves remaining gas untouched) while Solidity uses an
400      * invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
407         return mod(a, b, "SafeMath: modulo by zero");
408     }
409 
410     /**
411      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
412      * Reverts with custom message when dividing by zero.
413      *
414      * Counterpart to Solidity's `%` operator. This function uses a `revert`
415      * opcode (which leaves remaining gas untouched) while Solidity uses an
416      * invalid opcode to revert (consuming all remaining gas).
417      *
418      * Requirements:
419      *
420      * - The divisor cannot be zero.
421      */
422     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
423         require(b != 0, errorMessage);
424         return a % b;
425     }
426 }
427 
428 contract Ownable is Context {
429     address private _owner;
430 
431     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
432     
433     /**
434      * @dev Initializes the contract setting the deployer as the initial owner.
435      */
436     constructor () {
437         address msgSender = _msgSender();
438         _owner = msgSender;
439         emit OwnershipTransferred(address(0), msgSender);
440     }
441 
442     /**
443      * @dev Returns the address of the current owner.
444      */
445     function owner() public view returns (address) {
446         return _owner;
447     }
448 
449     /**
450      * @dev Throws if called by any account other than the owner.
451      */
452     modifier onlyOwner() {
453         require(_owner == _msgSender(), "Ownable: caller is not the owner");
454         _;
455     }
456 
457     /**
458      * @dev Leaves the contract without owner. It will not be possible to call
459      * `onlyOwner` functions anymore. Can only be called by the current owner.
460      *
461      * NOTE: Renouncing ownership will leave the contract without an owner,
462      * thereby removing any functionality that is only available to the owner.
463      */
464     function renounceOwnership() public virtual onlyOwner {
465         emit OwnershipTransferred(_owner, address(0));
466         _owner = address(0);
467     }
468 
469     /**
470      * @dev Transfers ownership of the contract to a new account (`newOwner`).
471      * Can only be called by the current owner.
472      */
473     function transferOwnership(address newOwner) public virtual onlyOwner {
474         require(newOwner != address(0), "Ownable: new owner is the zero address");
475         emit OwnershipTransferred(_owner, newOwner);
476         _owner = newOwner;
477     }
478 }
479 
480 
481 
482 library SafeMathInt {
483     int256 private constant MIN_INT256 = int256(1) << 255;
484     int256 private constant MAX_INT256 = ~(int256(1) << 255);
485 
486     /**
487      * @dev Multiplies two int256 variables and fails on overflow.
488      */
489     function mul(int256 a, int256 b) internal pure returns (int256) {
490         int256 c = a * b;
491 
492         // Detect overflow when multiplying MIN_INT256 with -1
493         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
494         require((b == 0) || (c / b == a));
495         return c;
496     }
497 
498     /**
499      * @dev Division of two int256 variables and fails on overflow.
500      */
501     function div(int256 a, int256 b) internal pure returns (int256) {
502         // Prevent overflow when dividing MIN_INT256 by -1
503         require(b != -1 || a != MIN_INT256);
504 
505         // Solidity already throws when dividing by 0.
506         return a / b;
507     }
508 
509     /**
510      * @dev Subtracts two int256 variables and fails on overflow.
511      */
512     function sub(int256 a, int256 b) internal pure returns (int256) {
513         int256 c = a - b;
514         require((b >= 0 && c <= a) || (b < 0 && c > a));
515         return c;
516     }
517 
518     /**
519      * @dev Adds two int256 variables and fails on overflow.
520      */
521     function add(int256 a, int256 b) internal pure returns (int256) {
522         int256 c = a + b;
523         require((b >= 0 && c >= a) || (b < 0 && c < a));
524         return c;
525     }
526 
527     /**
528      * @dev Converts to absolute value, and fails on overflow.
529      */
530     function abs(int256 a) internal pure returns (int256) {
531         require(a != MIN_INT256);
532         return a < 0 ? -a : a;
533     }
534 
535 
536     function toUint256Safe(int256 a) internal pure returns (uint256) {
537         require(a >= 0);
538         return uint256(a);
539     }
540 }
541 
542 library SafeMathUint {
543   function toInt256Safe(uint256 a) internal pure returns (int256) {
544     int256 b = int256(a);
545     require(b >= 0);
546     return b;
547   }
548 }
549 
550 
551 interface IUniswapV2Router01 {
552     function factory() external pure returns (address);
553     function WETH() external pure returns (address);
554 
555     function addLiquidity(
556         address tokenA,
557         address tokenB,
558         uint amountADesired,
559         uint amountBDesired,
560         uint amountAMin,
561         uint amountBMin,
562         address to,
563         uint deadline
564     ) external returns (uint amountA, uint amountB, uint liquidity);
565     function addLiquidityETH(
566         address token,
567         uint amountTokenDesired,
568         uint amountTokenMin,
569         uint amountETHMin,
570         address to,
571         uint deadline
572     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
573     function removeLiquidity(
574         address tokenA,
575         address tokenB,
576         uint liquidity,
577         uint amountAMin,
578         uint amountBMin,
579         address to,
580         uint deadline
581     ) external returns (uint amountA, uint amountB);
582     function removeLiquidityETH(
583         address token,
584         uint liquidity,
585         uint amountTokenMin,
586         uint amountETHMin,
587         address to,
588         uint deadline
589     ) external returns (uint amountToken, uint amountETH);
590     function removeLiquidityWithPermit(
591         address tokenA,
592         address tokenB,
593         uint liquidity,
594         uint amountAMin,
595         uint amountBMin,
596         address to,
597         uint deadline,
598         bool approveMax, uint8 v, bytes32 r, bytes32 s
599     ) external returns (uint amountA, uint amountB);
600     function removeLiquidityETHWithPermit(
601         address token,
602         uint liquidity,
603         uint amountTokenMin,
604         uint amountETHMin,
605         address to,
606         uint deadline,
607         bool approveMax, uint8 v, bytes32 r, bytes32 s
608     ) external returns (uint amountToken, uint amountETH);
609     function swapExactTokensForTokens(
610         uint amountIn,
611         uint amountOutMin,
612         address[] calldata path,
613         address to,
614         uint deadline
615     ) external returns (uint[] memory amounts);
616     function swapTokensForExactTokens(
617         uint amountOut,
618         uint amountInMax,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external returns (uint[] memory amounts);
623     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
624         external
625         payable
626         returns (uint[] memory amounts);
627     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
628         external
629         returns (uint[] memory amounts);
630     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
631         external
632         returns (uint[] memory amounts);
633     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
634         external
635         payable
636         returns (uint[] memory amounts);
637 
638     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
639     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
640     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
641     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
642     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
643 }
644 
645 interface IUniswapV2Router02 is IUniswapV2Router01 {
646     function removeLiquidityETHSupportingFeeOnTransferTokens(
647         address token,
648         uint liquidity,
649         uint amountTokenMin,
650         uint amountETHMin,
651         address to,
652         uint deadline
653     ) external returns (uint amountETH);
654     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
655         address token,
656         uint liquidity,
657         uint amountTokenMin,
658         uint amountETHMin,
659         address to,
660         uint deadline,
661         bool approveMax, uint8 v, bytes32 r, bytes32 s
662     ) external returns (uint amountETH);
663 
664     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
665         uint amountIn,
666         uint amountOutMin,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external;
671     function swapExactETHForTokensSupportingFeeOnTransferTokens(
672         uint amountOutMin,
673         address[] calldata path,
674         address to,
675         uint deadline
676     ) external payable;
677     function swapExactTokensForETHSupportingFeeOnTransferTokens(
678         uint amountIn,
679         uint amountOutMin,
680         address[] calldata path,
681         address to,
682         uint deadline
683     ) external;
684 }
685 
686 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
687   using SafeMath for uint256;
688   using SafeMathUint for uint256;
689   using SafeMathInt for int256;
690 
691   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
692   // For more discussion about choosing the value of `magnitude`,
693   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
694   uint256 constant internal magnitude = 2**128;
695 
696   mapping(address => uint256) internal magnifiedDividendPerShare;
697   address[] public rewardTokens;
698   address public nextRewardToken;
699   uint256 public rewardTokenCounter;
700   
701   IUniswapV2Router02 public immutable uniswapV2Router;
702   
703   
704   // About dividendCorrection:
705   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
706   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
707   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
708   //   `dividendOf(_user)` should not be changed,
709   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
710   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
711   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
712   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
713   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
714   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
715   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
716   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
717   
718   mapping (address => uint256) public holderBalance;
719   uint256 public totalBalance;
720 
721   mapping(address => uint256) public totalDividendsDistributed;
722   
723   constructor(){
724       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
725       uniswapV2Router = _uniswapV2Router; 
726       
727       // Mainnet
728 
729       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC - 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
730       
731       nextRewardToken = rewardTokens[0];
732   }
733 
734   
735 
736   /// @dev Distributes dividends whenever ether is paid to this contract.
737   receive() external payable {
738     distributeDividends();
739   }
740 
741   /// @notice Distributes ether to token holders as dividends.
742   /// @dev It reverts if the total supply of tokens is 0.
743   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
744   /// About undistributed ether:
745   ///   In each distribution, there is a small amount of ether not distributed,
746   ///     the magnified amount of which is
747   ///     `(msg.value * magnitude) % totalSupply()`.
748   ///   With a well-chosen `magnitude`, the amount of undistributed ether
749   ///     (de-magnified) in a distribution can be less than 1 wei.
750   ///   We can actually keep track of the undistributed ether in a distribution
751   ///     and try to distribute it in the next distribution,
752   ///     but keeping track of such data on-chain costs much more than
753   ///     the saved ether, so we don't do that.
754     
755   function distributeDividends() public override payable { 
756     require(totalBalance > 0);
757     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
758     buyTokens(msg.value, nextRewardToken);
759     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
760     if (newBalance > 0) {
761       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
762         (newBalance).mul(magnitude) / totalBalance
763       );
764       emit DividendsDistributed(msg.sender, newBalance);
765 
766       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
767     }
768     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
769     nextRewardToken = rewardTokens[rewardTokenCounter];
770   }
771   
772   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
773     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
774         // generate the uniswap pair path of weth -> eth
775         address[] memory path = new address[](2);
776         path[0] = uniswapV2Router.WETH();
777         path[1] = rewardToken;
778 
779         // make the swap
780         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
781             0, // accept any amount of Ethereum
782             path,
783             address(this),
784             block.timestamp
785         );
786     }
787   
788   /// @notice Withdraws the ether distributed to the sender.
789   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
790   function withdrawDividend(address _rewardToken) external virtual override {
791     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
792   }
793 
794   /// @notice Withdraws the ether distributed to the sender.
795   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
796   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
797     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
798     if (_withdrawableDividend > 0) {
799       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
800       emit DividendWithdrawn(user, _withdrawableDividend);
801       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
802       return _withdrawableDividend;
803     }
804 
805     return 0;
806   }
807 
808 
809   /// @notice View the amount of dividend in wei that an address can withdraw.
810   /// @param _owner The address of a token holder.
811   /// @return The amount of dividend in wei that `_owner` can withdraw.
812   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
813     return withdrawableDividendOf(_owner, _rewardToken);
814   }
815 
816   /// @notice View the amount of dividend in wei that an address can withdraw.
817   /// @param _owner The address of a token holder.
818   /// @return The amount of dividend in wei that `_owner` can withdraw.
819   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
820     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
821   }
822 
823   /// @notice View the amount of dividend in wei that an address has withdrawn.
824   /// @param _owner The address of a token holder.
825   /// @return The amount of dividend in wei that `_owner` has withdrawn.
826   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
827     return withdrawnDividends[_owner][_rewardToken];
828   }
829 
830 
831   /// @notice View the amount of dividend in wei that an address has earned in total.
832   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
833   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
834   /// @param _owner The address of a token holder.
835   /// @return The amount of dividend in wei that `_owner` has earned in total.
836   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
837     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
838       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
839   }
840 
841   /// @dev Internal function that increases tokens to an account.
842   /// Update magnifiedDividendCorrections to keep dividends unchanged.
843   /// @param account The account that will receive the created tokens.
844   /// @param value The amount that will be created.
845   function _increase(address account, uint256 value) internal {
846     for (uint256 i; i < rewardTokens.length; i++){
847         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
848           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
849     }
850   }
851 
852   /// @dev Internal function that reduces an amount of the token of a given account.
853   /// Update magnifiedDividendCorrections to keep dividends unchanged.
854   /// @param account The account whose tokens will be burnt.
855   /// @param value The amount that will be burnt.
856   function _reduce(address account, uint256 value) internal {
857       for (uint256 i; i < rewardTokens.length; i++){
858         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
859           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
860       }
861   }
862 
863   function _setBalance(address account, uint256 newBalance) internal {
864     uint256 currentBalance = holderBalance[account];
865     holderBalance[account] = newBalance;
866     if(newBalance > currentBalance) {
867       uint256 increaseAmount = newBalance.sub(currentBalance);
868       _increase(account, increaseAmount);
869       totalBalance += increaseAmount;
870     } else if(newBalance < currentBalance) {
871       uint256 reduceAmount = currentBalance.sub(newBalance);
872       _reduce(account, reduceAmount);
873       totalBalance -= reduceAmount;
874     }
875   }
876 }
877 
878 contract DividendTracker is DividendPayingToken {
879     using SafeMath for uint256;
880     using SafeMathInt for int256;
881 
882     struct Map {
883         address[] keys;
884         mapping(address => uint) values;
885         mapping(address => uint) indexOf;
886         mapping(address => bool) inserted;
887     }
888 
889     function get(address key) private view returns (uint) {
890         return tokenHoldersMap.values[key];
891     }
892 
893     function getIndexOfKey(address key) private view returns (int) {
894         if(!tokenHoldersMap.inserted[key]) {
895             return -1;
896         }
897         return int(tokenHoldersMap.indexOf[key]);
898     }
899 
900     function getKeyAtIndex(uint index) private view returns (address) {
901         return tokenHoldersMap.keys[index];
902     }
903 
904 
905 
906     function size() private view returns (uint) {
907         return tokenHoldersMap.keys.length;
908     }
909 
910     function set(address key, uint val) private {
911         if (tokenHoldersMap.inserted[key]) {
912             tokenHoldersMap.values[key] = val;
913         } else {
914             tokenHoldersMap.inserted[key] = true;
915             tokenHoldersMap.values[key] = val;
916             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
917             tokenHoldersMap.keys.push(key);
918         }
919     }
920 
921     function remove(address key) private {
922         if (!tokenHoldersMap.inserted[key]) {
923             return;
924         }
925 
926         delete tokenHoldersMap.inserted[key];
927         delete tokenHoldersMap.values[key];
928 
929         uint index = tokenHoldersMap.indexOf[key];
930         uint lastIndex = tokenHoldersMap.keys.length - 1;
931         address lastKey = tokenHoldersMap.keys[lastIndex];
932 
933         tokenHoldersMap.indexOf[lastKey] = index;
934         delete tokenHoldersMap.indexOf[key];
935 
936         tokenHoldersMap.keys[index] = lastKey;
937         tokenHoldersMap.keys.pop();
938     }
939 
940     Map private tokenHoldersMap;
941     uint256 public lastProcessedIndex;
942 
943     mapping (address => bool) public excludedFromDividends;
944 
945     mapping (address => uint256) public lastClaimTimes;
946 
947     uint256 public claimWait;
948     uint256 public immutable minimumTokenBalanceForDividends;
949 
950     event ExcludeFromDividends(address indexed account);
951     event IncludeInDividends(address indexed account);
952     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
953 
954     event Claim(address indexed account, uint256 amount, bool indexed automatic);
955 
956     constructor() {
957     	claimWait = 1200;
958         minimumTokenBalanceForDividends = 1000 * (10**18);
959     }
960 
961     function excludeFromDividends(address account) external onlyOwner {
962     	excludedFromDividends[account] = true;
963 
964     	_setBalance(account, 0);
965     	remove(account);
966 
967     	emit ExcludeFromDividends(account);
968     }
969     
970     function includeInDividends(address account) external onlyOwner {
971     	require(excludedFromDividends[account]);
972     	excludedFromDividends[account] = false;
973 
974     	emit IncludeInDividends(account);
975     }
976 
977     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
978         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
979         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
980         emit ClaimWaitUpdated(newClaimWait, claimWait);
981         claimWait = newClaimWait;
982     }
983 
984     function getLastProcessedIndex() external view returns(uint256) {
985     	return lastProcessedIndex;
986     }
987 
988     function getNumberOfTokenHolders() external view returns(uint256) {
989         return tokenHoldersMap.keys.length;
990     }
991 
992     // Check to see if I really made this contract or if it is a clone!
993 
994     function getAccount(address _account, address _rewardToken)
995         public view returns (
996             address account,
997             int256 index,
998             int256 iterationsUntilProcessed,
999             uint256 withdrawableDividends,
1000             uint256 totalDividends,
1001             uint256 lastClaimTime,
1002             uint256 nextClaimTime,
1003             uint256 secondsUntilAutoClaimAvailable) {
1004         account = _account;
1005 
1006         index = getIndexOfKey(account);
1007 
1008         iterationsUntilProcessed = -1;
1009 
1010         if(index >= 0) {
1011             if(uint256(index) > lastProcessedIndex) {
1012                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1013             }
1014             else {
1015                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1016                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1017                                                         0;
1018 
1019 
1020                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1021             }
1022         }
1023 
1024 
1025         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1026         totalDividends = accumulativeDividendOf(account, _rewardToken);
1027 
1028         lastClaimTime = lastClaimTimes[account];
1029 
1030         nextClaimTime = lastClaimTime > 0 ?
1031                                     lastClaimTime.add(claimWait) :
1032                                     0;
1033 
1034         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1035                                                     nextClaimTime.sub(block.timestamp) :
1036                                                     0;
1037     }
1038 
1039     function getAccountAtIndex(uint256 index, address _rewardToken)
1040         external view returns (
1041             address,
1042             int256,
1043             int256,
1044             uint256,
1045             uint256,
1046             uint256,
1047             uint256,
1048             uint256) {
1049     	if(index >= size()) {
1050             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1051         }
1052 
1053         address account = getKeyAtIndex(index);
1054 
1055         return getAccount(account, _rewardToken);
1056     }
1057 
1058     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1059     	if(lastClaimTime > block.timestamp)  {
1060     		return false;
1061     	}
1062 
1063     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1064     }
1065 
1066     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1067     	if(excludedFromDividends[account]) {
1068     		return;
1069     	}
1070 
1071     	if(newBalance >= minimumTokenBalanceForDividends) {
1072             _setBalance(account, newBalance);
1073     		set(account, newBalance);
1074     	}
1075     	else {
1076             _setBalance(account, 0);
1077     		remove(account);
1078     	}
1079 
1080     	processAccount(account, true);
1081     }
1082     
1083     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1084     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1085 
1086     	if(numberOfTokenHolders == 0) {
1087     		return (0, 0, lastProcessedIndex);
1088     	}
1089 
1090     	uint256 _lastProcessedIndex = lastProcessedIndex;
1091 
1092     	uint256 gasUsed = 0;
1093 
1094     	uint256 gasLeft = gasleft();
1095 
1096     	uint256 iterations = 0;
1097     	uint256 claims = 0;
1098 
1099     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1100     		_lastProcessedIndex++;
1101 
1102     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1103     			_lastProcessedIndex = 0;
1104     		}
1105 
1106     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1107 
1108     		if(canAutoClaim(lastClaimTimes[account])) {
1109     			if(processAccount(payable(account), true)) {
1110     				claims++;
1111     			}
1112     		}
1113 
1114     		iterations++;
1115 
1116     		uint256 newGasLeft = gasleft();
1117 
1118     		if(gasLeft > newGasLeft) {
1119     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1120     		}
1121     		gasLeft = newGasLeft;
1122     	}
1123 
1124     	lastProcessedIndex = _lastProcessedIndex;
1125 
1126     	return (iterations, claims, lastProcessedIndex);
1127     }
1128 
1129     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1130         uint256 amount;
1131         bool paid;
1132         for (uint256 i; i < rewardTokens.length; i++){
1133             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1134             if(amount > 0) {
1135         		lastClaimTimes[account] = block.timestamp;
1136                 emit Claim(account, amount, automatic);
1137                 paid = true;
1138     	    }
1139         }
1140         return paid;
1141     }
1142 }
1143 
1144 contract WHIRLPOOL is ERC20, Ownable {
1145     using SafeMath for uint256;
1146 
1147     IUniswapV2Router02 public immutable uniswapV2Router;
1148     address public immutable uniswapV2Pair;
1149 
1150     bool private swapping;
1151 
1152     DividendTracker public dividendTracker;
1153 
1154     address public operationsWallet;
1155     
1156     uint256 public maxTransactionAmount;
1157     uint256 public swapTokensAtAmount;
1158     uint256 public maxWallet;
1159     
1160     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1161     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1162     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1163     
1164     bool public limitsInEffect = true;
1165     bool public tradingActive = false;
1166     bool public swapEnabled = false;
1167     
1168      // Anti-bot and anti-whale mappings and variables
1169     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1170     bool public transferDelayEnabled = true;
1171     
1172     uint256 public constant feeDivisor = 1000;
1173 
1174     uint256 public totalSellFees;
1175     uint256 public rewardsSellFee;
1176     uint256 public operationsSellFee;
1177     uint256 public liquiditySellFee;
1178     
1179     uint256 public totalBuyFees;
1180     uint256 public rewardsBuyFee;
1181     uint256 public operationsBuyFee;
1182     uint256 public liquidityBuyFee;
1183     
1184     uint256 public tokensForRewards;
1185     uint256 public tokensForOperations;
1186     uint256 public tokensForLiquidity;
1187     
1188     uint256 public gasForProcessing = 0;
1189 
1190     uint256 public lpWithdrawRequestTimestamp;
1191     uint256 public lpWithdrawRequestDuration = 3 days;
1192     bool public lpWithdrawRequestPending;
1193     uint256 public lpPercToWithDraw;
1194 
1195     /******************/
1196 
1197     // exlcude from fees and max transaction amount
1198     mapping (address => bool) private _isExcludedFromFees;
1199 
1200     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1201 
1202     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1203     // could be subject to a maximum transfer amount
1204     mapping (address => bool) public automatedMarketMakerPairs;
1205 
1206     event ExcludeFromFees(address indexed account, bool isExcluded);
1207     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1208     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1209 
1210     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1211 
1212     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1213 
1214     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1215 
1216     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1217     
1218     event SwapAndLiquify(
1219         uint256 tokensSwapped,
1220         uint256 ethReceived,
1221         uint256 tokensIntoLiqudity
1222     );
1223 
1224     event SendDividends(
1225     	uint256 tokensSwapped,
1226     	uint256 amount
1227     );
1228 
1229     event ProcessedDividendTracker(
1230     	uint256 iterations,
1231     	uint256 claims,
1232         uint256 lastProcessedIndex,
1233     	bool indexed automatic,
1234     	uint256 gas,
1235     	address indexed processor
1236     );
1237 
1238     event RequestedLPWithdraw();
1239     
1240     event WithdrewLPForMigration();
1241 
1242     event CanceledLpWithdrawRequest();
1243 
1244     constructor() ERC20("WHIRLPOOL", "WHRL") {
1245 
1246         uint256 totalSupply = 100 * 1e6 * 1e18;
1247         
1248         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
1249         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
1250         maxWallet = totalSupply * 5 / 1000; // 0.5% Max wallet
1251 
1252         rewardsBuyFee = 20;
1253         operationsBuyFee = 20;
1254         liquidityBuyFee = 20;
1255         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1256         
1257         rewardsSellFee = 20;
1258         operationsSellFee = 20;
1259         liquiditySellFee = 20;
1260         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1261 
1262     	dividendTracker = new DividendTracker();
1263     	
1264     	operationsWallet = address(msg.sender); // set as operations wallet
1265 
1266     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1267     	
1268          // Create a uniswap pair for this new token
1269         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1270             .createPair(address(this), _uniswapV2Router.WETH());
1271 
1272         uniswapV2Router = _uniswapV2Router;
1273         uniswapV2Pair = _uniswapV2Pair;
1274 
1275         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1276 
1277         // exclude from receiving dividends
1278         dividendTracker.excludeFromDividends(address(dividendTracker));
1279         dividendTracker.excludeFromDividends(address(this));
1280         dividendTracker.excludeFromDividends(owner());
1281         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1282         dividendTracker.excludeFromDividends(address(0xdead));
1283         
1284         // exclude from paying fees or having max transaction amount
1285         excludeFromFees(owner(), true);
1286         excludeFromFees(address(this), true);
1287         excludeFromFees(address(0xdead), true);
1288         excludeFromMaxTransaction(owner(), true);
1289         excludeFromMaxTransaction(address(this), true);
1290         excludeFromMaxTransaction(address(dividendTracker), true);
1291         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1292         excludeFromMaxTransaction(address(0xdead), true);
1293 
1294         _createInitialSupply(address(owner()), totalSupply);
1295     }
1296 
1297     receive() external payable {
1298 
1299   	}
1300 
1301     // only use if conducting a presale
1302     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1303         excludeFromFees(_presaleAddress, true);
1304         dividendTracker.excludeFromDividends(_presaleAddress);
1305         excludeFromMaxTransaction(_presaleAddress, true);
1306     }
1307 
1308      // disable Transfer delay - cannot be reenabled
1309     function disableTransferDelay() external onlyOwner returns (bool){
1310         transferDelayEnabled = false;
1311         return true;
1312     }
1313 
1314     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1315     function excludeFromDividends(address account) external onlyOwner {
1316         dividendTracker.excludeFromDividends(account);
1317     }
1318 
1319     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1320     function includeInDividends(address account) external onlyOwner {
1321         dividendTracker.includeInDividends(account);
1322     }
1323     
1324     // once enabled, can never be turned off
1325     function enableTrading() external onlyOwner {
1326         require(!tradingActive, "Cannot re-enable trading");
1327         tradingActive = true;
1328         swapEnabled = true;
1329         tradingActiveBlock = block.number;
1330     }
1331     
1332     // only use to disable contract sales if absolutely necessary (emergency use only)
1333     function updateSwapEnabled(bool enabled) external onlyOwner(){
1334         swapEnabled = enabled;
1335     }
1336 
1337     function updateMaxAmount(uint256 newNum) external onlyOwner {
1338         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1339         maxTransactionAmount = newNum * (10**18);
1340     }
1341     
1342     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1343         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1344         maxWallet = newNum * (10**18);
1345     }
1346     
1347     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1348         operationsBuyFee = _operationsFee;
1349         rewardsBuyFee = _rewardsFee;
1350         liquidityBuyFee = _liquidityFee;
1351         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1352         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1353     }
1354     
1355     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1356         operationsSellFee = _operationsFee;
1357         rewardsSellFee = _rewardsFee;
1358         liquiditySellFee = _liquidityFee;
1359         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1360         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1361     }
1362 
1363     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1364         _isExcludedMaxTransactionAmount[updAds] = isEx;
1365         emit ExcludedMaxTransactionAmount(updAds, isEx);
1366     }
1367 
1368     function excludeFromFees(address account, bool excluded) public onlyOwner {
1369         _isExcludedFromFees[account] = excluded;
1370 
1371         emit ExcludeFromFees(account, excluded);
1372     }
1373 
1374     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1375         for(uint256 i = 0; i < accounts.length; i++) {
1376             _isExcludedFromFees[accounts[i]] = excluded;
1377         }
1378 
1379         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1380     }
1381 
1382     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1383         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1384 
1385         _setAutomatedMarketMakerPair(pair, value);
1386     }
1387 
1388     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1389         automatedMarketMakerPairs[pair] = value;
1390 
1391         excludeFromMaxTransaction(pair, value);
1392         
1393         if(value) {
1394             dividendTracker.excludeFromDividends(pair);
1395         }
1396 
1397         emit SetAutomatedMarketMakerPair(pair, value);
1398     }
1399 
1400     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1401         require(newOperationsWallet != address(0), "may not set to 0 address");
1402         excludeFromFees(newOperationsWallet, true);
1403         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1404         operationsWallet = newOperationsWallet;
1405     }
1406 
1407     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1408         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1409         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1410         emit GasForProcessingUpdated(newValue, gasForProcessing);
1411         gasForProcessing = newValue;
1412     }
1413 
1414     function updateClaimWait(uint256 claimWait) external onlyOwner {
1415         dividendTracker.updateClaimWait(claimWait);
1416     }
1417 
1418     function getClaimWait() external view returns(uint256) {
1419         return dividendTracker.claimWait();
1420     }
1421 
1422     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1423         return dividendTracker.totalDividendsDistributed(rewardToken);
1424     }
1425 
1426     function isExcludedFromFees(address account) external view returns(bool) {
1427         return _isExcludedFromFees[account];
1428     }
1429 
1430     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1431     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1432   	}
1433 
1434 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1435 		return dividendTracker.holderBalance(account);
1436 	}
1437 
1438     function getAccountDividendsInfo(address account, address rewardToken)
1439         external view returns (
1440             address,
1441             int256,
1442             int256,
1443             uint256,
1444             uint256,
1445             uint256,
1446             uint256,
1447             uint256) {
1448         return dividendTracker.getAccount(account, rewardToken);
1449     }
1450 
1451 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1452         external view returns (
1453             address,
1454             int256,
1455             int256,
1456             uint256,
1457             uint256,
1458             uint256,
1459             uint256,
1460             uint256) {
1461     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1462     }
1463 
1464 	function processDividendTracker(uint256 gas) external {
1465 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1466 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1467     }
1468 
1469     function claim() external {
1470 		dividendTracker.processAccount(payable(msg.sender), false);
1471     }
1472 
1473     function getLastProcessedIndex() external view returns(uint256) {
1474     	return dividendTracker.getLastProcessedIndex();
1475     }
1476 
1477     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1478         return dividendTracker.getNumberOfTokenHolders();
1479     }
1480     
1481     function getNumberOfDividends() external view returns(uint256) {
1482         return dividendTracker.totalBalance();
1483     }
1484     
1485     // remove limits after token is stable
1486     function removeLimits() external onlyOwner returns (bool){
1487         limitsInEffect = false;
1488         transferDelayEnabled = false;
1489         return true;
1490     }
1491     
1492     function _transfer(
1493         address from,
1494         address to,
1495         uint256 amount
1496     ) internal override {
1497         require(from != address(0), "ERC20: transfer from the zero address");
1498         require(to != address(0), "ERC20: transfer to the zero address");
1499         
1500          if(amount == 0) {
1501             super._transfer(from, to, 0);
1502             return;
1503         }
1504         
1505         if(!tradingActive){
1506             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1507         }
1508         
1509         if(limitsInEffect){
1510             if (
1511                 from != owner() &&
1512                 to != owner() &&
1513                 to != address(0) &&
1514                 to != address(0xdead) &&
1515                 !swapping
1516             ){
1517 
1518                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1519                 if (transferDelayEnabled){
1520                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1521                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1522                         _holderLastTransferTimestamp[tx.origin] = block.number;
1523                     }
1524                 }
1525                 
1526                 //when buy
1527                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1528                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1529                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1530                 } 
1531                 //when sell
1532                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1533                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1534                 }
1535                 else if(!_isExcludedMaxTransactionAmount[to]) {
1536                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1537                 }
1538             }
1539         }
1540 
1541 		uint256 contractTokenBalance = balanceOf(address(this));
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
1569             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1570                 fees = amount.mul(99).div(100);
1571                 tokensForLiquidity += fees * 33 / 99;
1572                 tokensForRewards += fees * 33 / 99;
1573                 tokensForOperations += fees * 33 / 99;
1574             }
1575 
1576             // on sell
1577             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1578                 fees = amount.mul(totalSellFees).div(feeDivisor);
1579                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1580                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1581                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1582             }
1583             
1584             // on buy
1585             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1586         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1587         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1588                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1589                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1590             }
1591 
1592             if(fees > 0){    
1593                 super._transfer(from, address(this), fees);
1594             }
1595         	
1596         	amount -= fees;
1597         }
1598 
1599         super._transfer(from, to, amount);
1600 
1601         dividendTracker.setBalance(payable(from), balanceOf(from));
1602         dividendTracker.setBalance(payable(to), balanceOf(to));
1603 
1604         if(!swapping && gasForProcessing > 0) {
1605 	    	uint256 gas = gasForProcessing;
1606 
1607 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1608 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1609 	    	}
1610 	    	catch {}
1611         }
1612     }
1613     
1614     function swapTokensForEth(uint256 tokenAmount) private {
1615 
1616         // generate the uniswap pair path of token -> weth
1617         address[] memory path = new address[](2);
1618         path[0] = address(this);
1619         path[1] = uniswapV2Router.WETH();
1620 
1621         _approve(address(this), address(uniswapV2Router), tokenAmount);
1622 
1623         // make the swap
1624         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1625             tokenAmount,
1626             0, // accept any amount of ETH
1627             path,
1628             address(this),
1629             block.timestamp
1630         );
1631         
1632     }
1633     
1634     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1635         // approve token transfer to cover all possible scenarios
1636         _approve(address(this), address(uniswapV2Router), tokenAmount);
1637 
1638         // add the liquidity
1639         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1640             address(this),
1641             tokenAmount,
1642             0, // slippage is unavoidable
1643             0, // slippage is unavoidable
1644             address(0xdead),
1645             block.timestamp
1646         );
1647 
1648     }
1649     
1650     function swapBack() private {
1651         uint256 contractBalance = balanceOf(address(this));
1652         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1653         
1654         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1655         
1656         // Halve the amount of liquidity tokens
1657         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1658         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1659         
1660         uint256 initialETHBalance = address(this).balance;
1661 
1662         swapTokensForEth(amountToSwapForETH); 
1663         
1664         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1665         
1666         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1667         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1668         
1669         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1670         
1671         tokensForLiquidity = 0;
1672         tokensForOperations = 0;
1673         tokensForRewards = 0;
1674         
1675         
1676         
1677         if(liquidityTokens > 0 && ethForLiquidity > 0){
1678             addLiquidity(liquidityTokens, ethForLiquidity);
1679             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1680         }
1681         
1682         // call twice to force buy of both reward tokens.
1683         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1684 
1685         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1686     }
1687 
1688     function withdrawStuckEth() external onlyOwner {
1689         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1690         require(success, "failed to withdraw");
1691     }
1692 
1693     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1694         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1695         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1696         lpWithdrawRequestTimestamp = block.timestamp;
1697         lpWithdrawRequestPending = true;
1698         lpPercToWithDraw = percToWithdraw;
1699         emit RequestedLPWithdraw();
1700     }
1701 
1702     function nextAvailableLpWithdrawDate() public view returns (uint256){
1703         if(lpWithdrawRequestPending){
1704             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1705         }
1706         else {
1707             return 0;  // 0 means no open requests
1708         }
1709     }
1710 
1711     function withdrawRequestedLP() external onlyOwner {
1712         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1713         lpWithdrawRequestTimestamp = 0;
1714         lpWithdrawRequestPending = false;
1715 
1716         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1717         
1718         lpPercToWithDraw = 0;
1719 
1720         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1721     }
1722 
1723     function cancelLPWithdrawRequest() external onlyOwner {
1724         lpWithdrawRequestPending = false;
1725         lpPercToWithDraw = 0;
1726         lpWithdrawRequestTimestamp = 0;
1727         emit CanceledLpWithdrawRequest();
1728     }
1729 }