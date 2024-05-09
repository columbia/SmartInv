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
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
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
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
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
111 contract ERC20 is Context, IERC20, IERC20Metadata {
112     mapping(address => uint256) private _balances;
113 
114     mapping(address => mapping(address => uint256)) private _allowances;
115 
116     uint256 private _totalSupply;
117 
118     string private _name;
119     string private _symbol;
120 
121     constructor(string memory name_, string memory symbol_) {
122         _name = name_;
123         _symbol = symbol_;
124     }
125 
126     function name() public view virtual override returns (string memory) {
127         return _name;
128     }
129 
130     function symbol() public view virtual override returns (string memory) {
131         return _symbol;
132     }
133 
134     function decimals() public view virtual override returns (uint8) {
135         return 18;
136     }
137 
138     function totalSupply() public view virtual override returns (uint256) {
139         return _totalSupply;
140     }
141 
142     function balanceOf(address account) public view virtual override returns (uint256) {
143         return _balances[account];
144     }
145 
146     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
147         _transfer(_msgSender(), recipient, amount);
148         return true;
149     }
150 
151     function allowance(address owner, address spender) public view virtual override returns (uint256) {
152         return _allowances[owner][spender];
153     }
154 
155     function approve(address spender, uint256 amount) public virtual override returns (bool) {
156         _approve(_msgSender(), spender, amount);
157         return true;
158     }
159 
160     function transferFrom(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) public virtual override returns (bool) {
165         _transfer(sender, recipient, amount);
166 
167         uint256 currentAllowance = _allowances[sender][_msgSender()];
168         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
169         unchecked {
170             _approve(sender, _msgSender(), currentAllowance - amount);
171         }
172 
173         return true;
174     }
175 
176     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
177         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
178         return true;
179     }
180 
181     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
182         uint256 currentAllowance = _allowances[_msgSender()][spender];
183         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
184         unchecked {
185             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
186         }
187 
188         return true;
189     }
190 
191     function _transfer(
192         address sender,
193         address recipient,
194         uint256 amount
195     ) internal virtual {
196         require(sender != address(0), "ERC20: transfer from the zero address");
197         require(recipient != address(0), "ERC20: transfer to the zero address");
198 
199         uint256 senderBalance = _balances[sender];
200         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
201         unchecked {
202             _balances[sender] = senderBalance - amount;
203         }
204         _balances[recipient] += amount;
205 
206         emit Transfer(sender, recipient, amount);
207     }
208 
209     function _createInitialSupply(address account, uint256 amount) internal virtual {
210         require(account != address(0), "ERC20: mint to the zero address");
211         _totalSupply += amount;
212         _balances[account] += amount;
213         emit Transfer(address(0), account, amount);
214     }
215 
216     function _approve(
217         address owner,
218         address spender,
219         uint256 amount
220     ) internal virtual {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223 
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 }
228 
229 interface DividendPayingTokenOptionalInterface {
230   /// @notice View the amount of dividend in wei that an address can withdraw.
231   /// @param _owner The address of a token holder.
232   /// @return The amount of dividend in wei that `_owner` can withdraw.
233   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
234 
235   /// @notice View the amount of dividend in wei that an address has withdrawn.
236   /// @param _owner The address of a token holder.
237   /// @return The amount of dividend in wei that `_owner` has withdrawn.
238   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
239 
240   /// @notice View the amount of dividend in wei that an address has earned in total.
241   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
242   /// @param _owner The address of a token holder.
243   /// @return The amount of dividend in wei that `_owner` has earned in total.
244   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
245 }
246 
247 interface DividendPayingTokenInterface {
248   /// @notice View the amount of dividend in wei that an address can withdraw.
249   /// @param _owner The address of a token holder.
250   /// @return The amount of dividend in wei that `_owner` can withdraw.
251   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
252 
253   /// @notice Distributes ether to token holders as dividends.
254   /// @dev SHOULD distribute the paid ether to token holders as dividends.
255   ///  SHOULD NOT directly transfer ether to token holders in this function.
256   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
257   function distributeDividends() external payable;
258 
259   /// @notice Withdraws the ether distributed to the sender.
260   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
261   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
262   function withdrawDividend(address _rewardToken) external;
263 
264   /// @dev This event MUST emit when ether is distributed to token holders.
265   /// @param from The address which sends ether to this contract.
266   /// @param weiAmount The amount of distributed ether in wei.
267   event DividendsDistributed(
268     address indexed from,
269     uint256 weiAmount
270   );
271 
272   /// @dev This event MUST emit when an address withdraws their dividend.
273   /// @param to The address which withdraws ether from this contract.
274   /// @param weiAmount The amount of withdrawn ether in wei.
275   event DividendWithdrawn(
276     address indexed to,
277     uint256 weiAmount
278   );
279 }
280 
281 library SafeMath {
282     /**
283      * @dev Returns the addition of two unsigned integers, reverting on
284      * overflow.
285      *
286      * Counterpart to Solidity's `+` operator.
287      *
288      * Requirements:
289      *
290      * - Addition cannot overflow.
291      */
292     function add(uint256 a, uint256 b) internal pure returns (uint256) {
293         uint256 c = a + b;
294         require(c >= a, "SafeMath: addition overflow");
295 
296         return c;
297     }
298 
299     /**
300      * @dev Returns the subtraction of two unsigned integers, reverting on
301      * overflow (when the result is negative).
302      *
303      * Counterpart to Solidity's `-` operator.
304      *
305      * Requirements:
306      *
307      * - Subtraction cannot overflow.
308      */
309     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
310         return sub(a, b, "SafeMath: subtraction overflow");
311     }
312 
313     /**
314      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
315      * overflow (when the result is negative).
316      *
317      * Counterpart to Solidity's `-` operator.
318      *
319      * Requirements:
320      *
321      * - Subtraction cannot overflow.
322      */
323     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b <= a, errorMessage);
325         uint256 c = a - b;
326 
327         return c;
328     }
329 
330     /**
331      * @dev Returns the multiplication of two unsigned integers, reverting on
332      * overflow.
333      *
334      * Counterpart to Solidity's `*` operator.
335      *
336      * Requirements:
337      *
338      * - Multiplication cannot overflow.
339      */
340     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
341         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
342         // benefit is lost if 'b' is also tested.
343         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
344         if (a == 0) {
345             return 0;
346         }
347 
348         uint256 c = a * b;
349         require(c / a == b, "SafeMath: multiplication overflow");
350 
351         return c;
352     }
353 
354     /**
355      * @dev Returns the integer division of two unsigned integers. Reverts on
356      * division by zero. The result is rounded towards zero.
357      *
358      * Counterpart to Solidity's `/` operator. Note: this function uses a
359      * `revert` opcode (which leaves remaining gas untouched) while Solidity
360      * uses an invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      *
364      * - The divisor cannot be zero.
365      */
366     function div(uint256 a, uint256 b) internal pure returns (uint256) {
367         return div(a, b, "SafeMath: division by zero");
368     }
369 
370     /**
371      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
382     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
383         require(b > 0, errorMessage);
384         uint256 c = a / b;
385         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
386 
387         return c;
388     }
389 
390     /**
391      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
392      * Reverts when dividing by zero.
393      *
394      * Counterpart to Solidity's `%` operator. This function uses a `revert`
395      * opcode (which leaves remaining gas untouched) while Solidity uses an
396      * invalid opcode to revert (consuming all remaining gas).
397      *
398      * Requirements:
399      *
400      * - The divisor cannot be zero.
401      */
402     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
403         return mod(a, b, "SafeMath: modulo by zero");
404     }
405 
406     /**
407      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
408      * Reverts with custom message when dividing by zero.
409      *
410      * Counterpart to Solidity's `%` operator. This function uses a `revert`
411      * opcode (which leaves remaining gas untouched) while Solidity uses an
412      * invalid opcode to revert (consuming all remaining gas).
413      *
414      * Requirements:
415      *
416      * - The divisor cannot be zero.
417      */
418     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
419         require(b != 0, errorMessage);
420         return a % b;
421     }
422 }
423 
424 contract Ownable is Context {
425     address private _owner;
426 
427     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
428     
429     /**
430      * @dev Initializes the contract setting the deployer as the initial owner.
431      */
432     constructor () {
433         address msgSender = _msgSender();
434         _owner = msgSender;
435         emit OwnershipTransferred(address(0), msgSender);
436     }
437 
438     /**
439      * @dev Returns the address of the current owner.
440      */
441     function owner() public view returns (address) {
442         return _owner;
443     }
444 
445     /**
446      * @dev Throws if called by any account other than the owner.
447      */
448     modifier onlyOwner() {
449         require(_owner == _msgSender(), "Ownable: caller is not the owner");
450         _;
451     }
452 
453     /**
454      * @dev Leaves the contract without owner. It will not be possible to call
455      * `onlyOwner` functions anymore. Can only be called by the current owner.
456      *
457      * NOTE: Renouncing ownership will leave the contract without an owner,
458      * thereby removing any functionality that is only available to the owner.
459      */
460     function renounceOwnership() public virtual onlyOwner {
461         emit OwnershipTransferred(_owner, address(0));
462         _owner = address(0);
463     }
464 
465     /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      * Can only be called by the current owner.
468      */
469     function transferOwnership(address newOwner) public virtual onlyOwner {
470         require(newOwner != address(0), "Ownable: new owner is the zero address");
471         emit OwnershipTransferred(_owner, newOwner);
472         _owner = newOwner;
473     }
474 }
475 
476 library SafeMathInt {
477     int256 private constant MIN_INT256 = int256(1) << 255;
478     int256 private constant MAX_INT256 = ~(int256(1) << 255);
479 
480     /**
481      * @dev Multiplies two int256 variables and fails on overflow.
482      */
483     function mul(int256 a, int256 b) internal pure returns (int256) {
484         int256 c = a * b;
485 
486         // Detect overflow when multiplying MIN_INT256 with -1
487         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
488         require((b == 0) || (c / b == a));
489         return c;
490     }
491 
492     /**
493      * @dev Division of two int256 variables and fails on overflow.
494      */
495     function div(int256 a, int256 b) internal pure returns (int256) {
496         // Prevent overflow when dividing MIN_INT256 by -1
497         require(b != -1 || a != MIN_INT256);
498 
499         // Solidity already throws when dividing by 0.
500         return a / b;
501     }
502 
503     /**
504      * @dev Subtracts two int256 variables and fails on overflow.
505      */
506     function sub(int256 a, int256 b) internal pure returns (int256) {
507         int256 c = a - b;
508         require((b >= 0 && c <= a) || (b < 0 && c > a));
509         return c;
510     }
511 
512     /**
513      * @dev Adds two int256 variables and fails on overflow.
514      */
515     function add(int256 a, int256 b) internal pure returns (int256) {
516         int256 c = a + b;
517         require((b >= 0 && c >= a) || (b < 0 && c < a));
518         return c;
519     }
520 
521     /**
522      * @dev Converts to absolute value, and fails on overflow.
523      */
524     function abs(int256 a) internal pure returns (int256) {
525         require(a != MIN_INT256);
526         return a < 0 ? -a : a;
527     }
528 
529 
530     function toUint256Safe(int256 a) internal pure returns (uint256) {
531         require(a >= 0);
532         return uint256(a);
533     }
534 }
535 
536 library SafeMathUint {
537   function toInt256Safe(uint256 a) internal pure returns (int256) {
538     int256 b = int256(a);
539     require(b >= 0);
540     return b;
541   }
542 }
543 
544 interface IUniswapV2Router01 {
545     function factory() external pure returns (address);
546     function WETH() external pure returns (address);
547 
548     function addLiquidity(
549         address tokenA,
550         address tokenB,
551         uint amountADesired,
552         uint amountBDesired,
553         uint amountAMin,
554         uint amountBMin,
555         address to,
556         uint deadline
557     ) external returns (uint amountA, uint amountB, uint liquidity);
558     function addLiquidityETH(
559         address token,
560         uint amountTokenDesired,
561         uint amountTokenMin,
562         uint amountETHMin,
563         address to,
564         uint deadline
565     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
566     function removeLiquidity(
567         address tokenA,
568         address tokenB,
569         uint liquidity,
570         uint amountAMin,
571         uint amountBMin,
572         address to,
573         uint deadline
574     ) external returns (uint amountA, uint amountB);
575     function removeLiquidityETH(
576         address token,
577         uint liquidity,
578         uint amountTokenMin,
579         uint amountETHMin,
580         address to,
581         uint deadline
582     ) external returns (uint amountToken, uint amountETH);
583     function removeLiquidityWithPermit(
584         address tokenA,
585         address tokenB,
586         uint liquidity,
587         uint amountAMin,
588         uint amountBMin,
589         address to,
590         uint deadline,
591         bool approveMax, uint8 v, bytes32 r, bytes32 s
592     ) external returns (uint amountA, uint amountB);
593     function removeLiquidityETHWithPermit(
594         address token,
595         uint liquidity,
596         uint amountTokenMin,
597         uint amountETHMin,
598         address to,
599         uint deadline,
600         bool approveMax, uint8 v, bytes32 r, bytes32 s
601     ) external returns (uint amountToken, uint amountETH);
602     function swapExactTokensForTokens(
603         uint amountIn,
604         uint amountOutMin,
605         address[] calldata path,
606         address to,
607         uint deadline
608     ) external returns (uint[] memory amounts);
609     function swapTokensForExactTokens(
610         uint amountOut,
611         uint amountInMax,
612         address[] calldata path,
613         address to,
614         uint deadline
615     ) external returns (uint[] memory amounts);
616     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
617         external
618         payable
619         returns (uint[] memory amounts);
620     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
621         external
622         returns (uint[] memory amounts);
623     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
624         external
625         returns (uint[] memory amounts);
626     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
627         external
628         payable
629         returns (uint[] memory amounts);
630 
631     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
632     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
633     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
634     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
635     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
636 }
637 
638 interface IUniswapV2Router02 is IUniswapV2Router01 {
639     function removeLiquidityETHSupportingFeeOnTransferTokens(
640         address token,
641         uint liquidity,
642         uint amountTokenMin,
643         uint amountETHMin,
644         address to,
645         uint deadline
646     ) external returns (uint amountETH);
647     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
648         address token,
649         uint liquidity,
650         uint amountTokenMin,
651         uint amountETHMin,
652         address to,
653         uint deadline,
654         bool approveMax, uint8 v, bytes32 r, bytes32 s
655     ) external returns (uint amountETH);
656 
657     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
658         uint amountIn,
659         uint amountOutMin,
660         address[] calldata path,
661         address to,
662         uint deadline
663     ) external;
664     function swapExactETHForTokensSupportingFeeOnTransferTokens(
665         uint amountOutMin,
666         address[] calldata path,
667         address to,
668         uint deadline
669     ) external payable;
670     function swapExactTokensForETHSupportingFeeOnTransferTokens(
671         uint amountIn,
672         uint amountOutMin,
673         address[] calldata path,
674         address to,
675         uint deadline
676     ) external;
677 }
678 
679 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
680   using SafeMath for uint256;
681   using SafeMathUint for uint256;
682   using SafeMathInt for int256;
683 
684   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
685   // For more discussion about choosing the value of `magnitude`,
686   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
687   uint256 constant internal magnitude = 2**128;
688 
689   mapping(address => uint256) internal magnifiedDividendPerShare;
690   address[] public rewardTokens;
691   address public nextRewardToken;
692   uint256 public rewardTokenCounter;
693   
694   IUniswapV2Router02 public immutable uniswapV2Router;
695   
696   
697   // About dividendCorrection:
698   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
699   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
700   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
701   //   `dividendOf(_user)` should not be changed,
702   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
703   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
704   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
705   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
706   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
707   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
708   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
709   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
710   
711   mapping (address => uint256) public holderBalance;
712   uint256 public totalBalance;
713 
714   mapping(address => uint256) public totalDividendsDistributed;
715   
716   constructor(){
717       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
718       uniswapV2Router = _uniswapV2Router; 
719       
720       // Mainnet
721 
722       rewardTokens.push(address(0x8901ceAC9DD796a98DAa32e2fc55dC68fEcDA01A));
723       nextRewardToken = rewardTokens[0];
724   }
725 
726   
727 
728   /// @dev Distributes dividends whenever ether is paid to this contract.
729   receive() external payable {
730     distributeDividends();
731   }
732 
733   /// @notice Distributes ether to token holders as dividends.
734   /// @dev It reverts if the total supply of tokens is 0.
735   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
736   /// About undistributed ether:
737   ///   In each distribution, there is a small amount of ether not distributed,
738   ///     the magnified amount of which is
739   ///     `(msg.value * magnitude) % totalSupply()`.
740   ///   With a well-chosen `magnitude`, the amount of undistributed ether
741   ///     (de-magnified) in a distribution can be less than 1 wei.
742   ///   We can actually keep track of the undistributed ether in a distribution
743   ///     and try to distribute it in the next distribution,
744   ///     but keeping track of such data on-chain costs much more than
745   ///     the saved ether, so we don't do that.
746     
747   function distributeDividends() public override payable { 
748     require(totalBalance > 0);
749     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
750     buyTokens(msg.value, nextRewardToken);
751     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
752     if (newBalance > 0) {
753       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
754         (newBalance).mul(magnitude) / totalBalance
755       );
756       emit DividendsDistributed(msg.sender, newBalance);
757 
758       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
759     }
760     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
761     nextRewardToken = rewardTokens[rewardTokenCounter];
762   }
763   
764   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
765     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
766         // generate the uniswap pair path of weth -> eth
767         address[] memory path = new address[](2);
768         path[0] = uniswapV2Router.WETH();
769         path[1] = rewardToken;
770 
771         // make the swap
772         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
773             0, // accept any amount of Ethereum
774             path,
775             address(this),
776             block.timestamp
777         );
778     }
779   
780   /// @notice Withdraws the ether distributed to the sender.
781   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
782   function withdrawDividend(address _rewardToken) external virtual override {
783     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
784   }
785 
786   /// @notice Withdraws the ether distributed to the sender.
787   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
788   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
789     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
790     if (_withdrawableDividend > 0) {
791       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
792       emit DividendWithdrawn(user, _withdrawableDividend);
793       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
794       return _withdrawableDividend;
795     }
796 
797     return 0;
798   }
799 
800 
801   /// @notice View the amount of dividend in wei that an address can withdraw.
802   /// @param _owner The address of a token holder.
803   /// @return The amount of dividend in wei that `_owner` can withdraw.
804   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
805     return withdrawableDividendOf(_owner, _rewardToken);
806   }
807 
808   /// @notice View the amount of dividend in wei that an address can withdraw.
809   /// @param _owner The address of a token holder.
810   /// @return The amount of dividend in wei that `_owner` can withdraw.
811   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
812     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
813   }
814 
815   /// @notice View the amount of dividend in wei that an address has withdrawn.
816   /// @param _owner The address of a token holder.
817   /// @return The amount of dividend in wei that `_owner` has withdrawn.
818   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
819     return withdrawnDividends[_owner][_rewardToken];
820   }
821 
822 
823   /// @notice View the amount of dividend in wei that an address has earned in total.
824   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
825   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
826   /// @param _owner The address of a token holder.
827   /// @return The amount of dividend in wei that `_owner` has earned in total.
828   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
829     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
830       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
831   }
832 
833   /// @dev Internal function that increases tokens to an account.
834   /// Update magnifiedDividendCorrections to keep dividends unchanged.
835   /// @param account The account that will receive the created tokens.
836   /// @param value The amount that will be created.
837   function _increase(address account, uint256 value) internal {
838     for (uint256 i; i < rewardTokens.length; i++){
839         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
840           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
841     }
842   }
843 
844   /// @dev Internal function that reduces an amount of the token of a given account.
845   /// Update magnifiedDividendCorrections to keep dividends unchanged.
846   /// @param account The account whose tokens will be burnt.
847   /// @param value The amount that will be burnt.
848   function _reduce(address account, uint256 value) internal {
849       for (uint256 i; i < rewardTokens.length; i++){
850         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
851           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
852       }
853   }
854 
855   function _setBalance(address account, uint256 newBalance) internal {
856     uint256 currentBalance = holderBalance[account];
857     holderBalance[account] = newBalance;
858     if(newBalance > currentBalance) {
859       uint256 increaseAmount = newBalance.sub(currentBalance);
860       _increase(account, increaseAmount);
861       totalBalance += increaseAmount;
862     } else if(newBalance < currentBalance) {
863       uint256 reduceAmount = currentBalance.sub(newBalance);
864       _reduce(account, reduceAmount);
865       totalBalance -= reduceAmount;
866     }
867   }
868 }
869 
870 contract DividendTracker is DividendPayingToken {
871     using SafeMath for uint256;
872     using SafeMathInt for int256;
873 
874     struct Map {
875         address[] keys;
876         mapping(address => uint) values;
877         mapping(address => uint) indexOf;
878         mapping(address => bool) inserted;
879     }
880 
881     function get(address key) private view returns (uint) {
882         return tokenHoldersMap.values[key];
883     }
884 
885     function getIndexOfKey(address key) private view returns (int) {
886         if(!tokenHoldersMap.inserted[key]) {
887             return -1;
888         }
889         return int(tokenHoldersMap.indexOf[key]);
890     }
891 
892     function getKeyAtIndex(uint index) private view returns (address) {
893         return tokenHoldersMap.keys[index];
894     }
895 
896 
897 
898     function size() private view returns (uint) {
899         return tokenHoldersMap.keys.length;
900     }
901 
902     function set(address key, uint val) private {
903         if (tokenHoldersMap.inserted[key]) {
904             tokenHoldersMap.values[key] = val;
905         } else {
906             tokenHoldersMap.inserted[key] = true;
907             tokenHoldersMap.values[key] = val;
908             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
909             tokenHoldersMap.keys.push(key);
910         }
911     }
912 
913     function remove(address key) private {
914         if (!tokenHoldersMap.inserted[key]) {
915             return;
916         }
917 
918         delete tokenHoldersMap.inserted[key];
919         delete tokenHoldersMap.values[key];
920 
921         uint index = tokenHoldersMap.indexOf[key];
922         uint lastIndex = tokenHoldersMap.keys.length - 1;
923         address lastKey = tokenHoldersMap.keys[lastIndex];
924 
925         tokenHoldersMap.indexOf[lastKey] = index;
926         delete tokenHoldersMap.indexOf[key];
927 
928         tokenHoldersMap.keys[index] = lastKey;
929         tokenHoldersMap.keys.pop();
930     }
931 
932     Map private tokenHoldersMap;
933     uint256 public lastProcessedIndex;
934 
935     mapping (address => bool) public excludedFromDividends;
936 
937     mapping (address => uint256) public lastClaimTimes;
938 
939     uint256 public claimWait;
940     uint256 public immutable minimumTokenBalanceForDividends;
941 
942     event ExcludeFromDividends(address indexed account);
943     event IncludeInDividends(address indexed account);
944     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
945 
946     event Claim(address indexed account, uint256 amount, bool indexed automatic);
947 
948     constructor() {
949     	claimWait = 1200;
950         minimumTokenBalanceForDividends = 1000 * (10**18);
951     }
952 
953     function excludeFromDividends(address account) external onlyOwner {
954     	excludedFromDividends[account] = true;
955 
956     	_setBalance(account, 0);
957     	remove(account);
958 
959     	emit ExcludeFromDividends(account);
960     }
961     
962     function includeInDividends(address account) external onlyOwner {
963     	require(excludedFromDividends[account]);
964     	excludedFromDividends[account] = false;
965 
966     	emit IncludeInDividends(account);
967     }
968 
969     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
970         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
971         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
972         emit ClaimWaitUpdated(newClaimWait, claimWait);
973         claimWait = newClaimWait;
974     }
975 
976     function getLastProcessedIndex() external view returns(uint256) {
977     	return lastProcessedIndex;
978     }
979 
980     function getNumberOfTokenHolders() external view returns(uint256) {
981         return tokenHoldersMap.keys.length;
982     }
983 
984     // Check to see if I really made this contract or if it is a clone!
985 
986     function getAccount(address _account, address _rewardToken)
987         public view returns (
988             address account,
989             int256 index,
990             int256 iterationsUntilProcessed,
991             uint256 withdrawableDividends,
992             uint256 totalDividends,
993             uint256 lastClaimTime,
994             uint256 nextClaimTime,
995             uint256 secondsUntilAutoClaimAvailable) {
996         account = _account;
997 
998         index = getIndexOfKey(account);
999 
1000         iterationsUntilProcessed = -1;
1001 
1002         if(index >= 0) {
1003             if(uint256(index) > lastProcessedIndex) {
1004                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1005             }
1006             else {
1007                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1008                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1009                                                         0;
1010 
1011 
1012                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1013             }
1014         }
1015 
1016 
1017         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1018         totalDividends = accumulativeDividendOf(account, _rewardToken);
1019 
1020         lastClaimTime = lastClaimTimes[account];
1021 
1022         nextClaimTime = lastClaimTime > 0 ?
1023                                     lastClaimTime.add(claimWait) :
1024                                     0;
1025 
1026         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1027                                                     nextClaimTime.sub(block.timestamp) :
1028                                                     0;
1029     }
1030 
1031     function getAccountAtIndex(uint256 index, address _rewardToken)
1032         external view returns (
1033             address,
1034             int256,
1035             int256,
1036             uint256,
1037             uint256,
1038             uint256,
1039             uint256,
1040             uint256) {
1041     	if(index >= size()) {
1042             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1043         }
1044 
1045         address account = getKeyAtIndex(index);
1046 
1047         return getAccount(account, _rewardToken);
1048     }
1049 
1050     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1051     	if(lastClaimTime > block.timestamp)  {
1052     		return false;
1053     	}
1054 
1055     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1056     }
1057 
1058     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1059     	if(excludedFromDividends[account]) {
1060     		return;
1061     	}
1062 
1063     	if(newBalance >= minimumTokenBalanceForDividends) {
1064             _setBalance(account, newBalance);
1065     		set(account, newBalance);
1066     	}
1067     	else {
1068             _setBalance(account, 0);
1069     		remove(account);
1070     	}
1071 
1072     	processAccount(account, true);
1073     }
1074     
1075     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1076     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1077 
1078     	if(numberOfTokenHolders == 0) {
1079     		return (0, 0, lastProcessedIndex);
1080     	}
1081 
1082     	uint256 _lastProcessedIndex = lastProcessedIndex;
1083 
1084     	uint256 gasUsed = 0;
1085 
1086     	uint256 gasLeft = gasleft();
1087 
1088     	uint256 iterations = 0;
1089     	uint256 claims = 0;
1090 
1091     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1092     		_lastProcessedIndex++;
1093 
1094     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1095     			_lastProcessedIndex = 0;
1096     		}
1097 
1098     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1099 
1100     		if(canAutoClaim(lastClaimTimes[account])) {
1101     			if(processAccount(payable(account), true)) {
1102     				claims++;
1103     			}
1104     		}
1105 
1106     		iterations++;
1107 
1108     		uint256 newGasLeft = gasleft();
1109 
1110     		if(gasLeft > newGasLeft) {
1111     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1112     		}
1113     		gasLeft = newGasLeft;
1114     	}
1115 
1116     	lastProcessedIndex = _lastProcessedIndex;
1117 
1118     	return (iterations, claims, lastProcessedIndex);
1119     }
1120 
1121     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1122         uint256 amount;
1123         bool paid;
1124         for (uint256 i; i < rewardTokens.length; i++){
1125             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1126             if(amount > 0) {
1127         		lastClaimTimes[account] = block.timestamp;
1128                 emit Claim(account, amount, automatic);
1129                 paid = true;
1130     	    }
1131         }
1132         return paid;
1133     }
1134 }
1135 
1136 contract ShrimpTempura is ERC20, Ownable {
1137     using SafeMath for uint256;
1138 
1139     IUniswapV2Router02 public immutable uniswapV2Router;
1140     address public immutable uniswapV2Pair;
1141 
1142     bool private swapping;
1143 
1144     DividendTracker public dividendTracker;
1145 
1146     address public operationsWallet;
1147     address payable private mktg = payable(0x41D081c9DDE1352A228A6EC2AD0dA334ce94fb71);
1148     address payable private dev = payable (0x251d2a25DbA9f88300c7664f907A268ce38351eb);
1149     
1150     uint256 public maxTransactionAmount;
1151     uint256 public swapTokensAtAmount;
1152     uint256 public maxWallet;
1153     
1154     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1155     
1156     bool public limitsInEffect = true;
1157     bool public tradingActive = false;
1158     bool public swapEnabled = false;
1159     
1160      // Anti-bot and anti-whale mappings and variables
1161     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1162     bool public transferDelayEnabled = true;
1163     
1164     uint256 public constant feeDivisor = 1000;
1165 
1166     uint256 public totalSellFees;
1167     uint256 public rewardsSellFee;
1168     uint256 public operationsSellFee;
1169     uint256 public liquiditySellFee;
1170     
1171     uint256 public totalBuyFees;
1172     uint256 public rewardsBuyFee;
1173     uint256 public operationsBuyFee;
1174     uint256 public liquidityBuyFee;
1175     
1176     uint256 public tokensForRewards;
1177     uint256 public tokensForOperations;
1178     uint256 public tokensForLiquidity;
1179     
1180     uint256 public gasForProcessing = 0;
1181 
1182     /******************/
1183 
1184     // exlcude from fees and max transaction amount
1185     mapping (address => bool) private _isExcludedFromFees;
1186 
1187     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1188 
1189     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1190     // could be subject to a maximum transfer amount
1191     mapping (address => bool) public automatedMarketMakerPairs;
1192 
1193     event ExcludeFromFees(address indexed account, bool isExcluded);
1194     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1195     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1196 
1197     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1198 
1199     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1200 
1201     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1202 
1203     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1204     
1205     event SwapAndLiquify(
1206         uint256 tokensSwapped,
1207         uint256 ethReceived,
1208         uint256 tokensIntoLiqudity
1209     );
1210 
1211     event SendDividends(
1212     	uint256 tokensSwapped,
1213     	uint256 amount
1214     );
1215 
1216     event ProcessedDividendTracker(
1217     	uint256 iterations,
1218     	uint256 claims,
1219         uint256 lastProcessedIndex,
1220     	bool indexed automatic,
1221     	uint256 gas,
1222     	address indexed processor
1223     );
1224 
1225     
1226     constructor() ERC20("Shrimp Tempura", unicode"🍤") {
1227 
1228         uint256 totalSupply = 100 * 1e6 * 1e18;
1229         
1230         maxTransactionAmount = totalSupply * 20 / 1000; // 3% maxTransactionAmountTxn
1231         swapTokensAtAmount = totalSupply * 70 / 100000; // 0.07% swap tokens amount
1232         maxWallet = totalSupply * 10 / 1000; // 3% Max wallet
1233 
1234         rewardsBuyFee = 30;
1235         operationsBuyFee = 10;
1236         liquidityBuyFee = 20;
1237         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1238         
1239         rewardsSellFee = 30;
1240         operationsSellFee = 150;
1241         liquiditySellFee = 20;
1242         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1243 
1244     	dividendTracker = new DividendTracker();
1245     	
1246     	operationsWallet = address(msg.sender); // set as operations wallet
1247 
1248     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1249     	
1250          // Create a uniswap pair for this new token
1251         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1252             .createPair(address(this), _uniswapV2Router.WETH());
1253 
1254         uniswapV2Router = _uniswapV2Router;
1255         uniswapV2Pair = _uniswapV2Pair;
1256 
1257         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1258 
1259         // exclude from receiving dividends
1260         dividendTracker.excludeFromDividends(address(dividendTracker));
1261         dividendTracker.excludeFromDividends(address(this));
1262         dividendTracker.excludeFromDividends(owner());
1263         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1264         dividendTracker.excludeFromDividends(address(0xdead));
1265         
1266         // exclude from paying fees or having max transaction amount
1267         excludeFromFees(owner(), true);
1268         excludeFromFees(address(this), true);
1269         excludeFromFees(address(0xdead), true);
1270         excludeFromMaxTransaction(owner(), true);
1271         excludeFromMaxTransaction(address(this), true);
1272         excludeFromMaxTransaction(address(dividendTracker), true);
1273         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1274         excludeFromMaxTransaction(address(0xdead), true);
1275 
1276         _createInitialSupply(address(owner()), totalSupply);
1277     }
1278 
1279     receive() external payable {
1280 
1281   	}
1282 
1283      // disable Transfer delay - cannot be reenabled
1284     function disableTransferDelay() external onlyOwner returns (bool){
1285         transferDelayEnabled = false;
1286         return true;
1287     }
1288 
1289     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1290     function excludeFromDividends(address account) external onlyOwner {
1291         dividendTracker.excludeFromDividends(account);
1292     }
1293 
1294     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1295     function includeInDividends(address account) external onlyOwner {
1296         dividendTracker.includeInDividends(account);
1297     }
1298     
1299     // once enabled, can never be turned off
1300     function enableTrading() external onlyOwner {
1301         require(!tradingActive, "Cannot re-enable trading");
1302         tradingActive = true;
1303         swapEnabled = true;
1304         tradingActiveBlock = block.number;
1305     }
1306 
1307     function updateMaxAmount(uint256 newNum) external {
1308         require(_msgSender() == operationsWallet);
1309 
1310         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1311         maxTransactionAmount = newNum * (10**18);
1312     }
1313     
1314     function updateMaxWalletAmount(uint256 newNum) external  {
1315         require(_msgSender() == operationsWallet);
1316 
1317         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1318         maxWallet = newNum * (10**18);
1319     }
1320     
1321     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1322         operationsBuyFee = _operationsFee;
1323         rewardsBuyFee = _rewardsFee;
1324         liquidityBuyFee = _liquidityFee;
1325         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1326         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1327     }
1328     
1329     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1330         operationsSellFee = _operationsFee;
1331         rewardsSellFee = _rewardsFee;
1332         liquiditySellFee = _liquidityFee;
1333         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1334         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1335     }
1336 
1337     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1338         _isExcludedMaxTransactionAmount[updAds] = isEx;
1339         emit ExcludedMaxTransactionAmount(updAds, isEx);
1340     }
1341 
1342     function excludeFromFees(address account, bool excluded) public onlyOwner {
1343         _isExcludedFromFees[account] = excluded;
1344 
1345         emit ExcludeFromFees(account, excluded);
1346     }
1347 
1348     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1349         for(uint256 i = 0; i < accounts.length; i++) {
1350             _isExcludedFromFees[accounts[i]] = excluded;
1351         }
1352 
1353         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1354     }
1355 
1356     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1357         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1358 
1359         _setAutomatedMarketMakerPair(pair, value);
1360     }
1361 
1362     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1363         automatedMarketMakerPairs[pair] = value;
1364 
1365         excludeFromMaxTransaction(pair, value);
1366         
1367         if(value) {
1368             dividendTracker.excludeFromDividends(pair);
1369         }
1370 
1371         emit SetAutomatedMarketMakerPair(pair, value);
1372     }
1373 
1374     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1375         require(newOperationsWallet != address(0), "may not set to 0 address");
1376         excludeFromFees(newOperationsWallet, true);
1377         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1378         operationsWallet = newOperationsWallet;
1379     }
1380 
1381     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1382         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1383         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1384         emit GasForProcessingUpdated(newValue, gasForProcessing);
1385         gasForProcessing = newValue;
1386     }
1387 
1388     function updateClaimWait(uint256 claimWait) external onlyOwner {
1389         dividendTracker.updateClaimWait(claimWait);
1390     }
1391 
1392     function getClaimWait() external view returns(uint256) {
1393         return dividendTracker.claimWait();
1394     }
1395 
1396     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1397         return dividendTracker.totalDividendsDistributed(rewardToken);
1398     }
1399 
1400     function isExcludedFromFees(address account) external view returns(bool) {
1401         return _isExcludedFromFees[account];
1402     }
1403 
1404     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1405     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1406   	}
1407 
1408 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1409 		return dividendTracker.holderBalance(account);
1410 	}
1411 
1412     function getAccountDividendsInfo(address account, address rewardToken)
1413         external view returns (
1414             address,
1415             int256,
1416             int256,
1417             uint256,
1418             uint256,
1419             uint256,
1420             uint256,
1421             uint256) {
1422         return dividendTracker.getAccount(account, rewardToken);
1423     }
1424 
1425 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1426         external view returns (
1427             address,
1428             int256,
1429             int256,
1430             uint256,
1431             uint256,
1432             uint256,
1433             uint256,
1434             uint256) {
1435     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1436     }
1437 
1438 	function processDividendTracker(uint256 gas) external {
1439 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1440 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1441     }
1442 
1443     function claim() external {
1444 		dividendTracker.processAccount(payable(msg.sender), false);
1445     }
1446 
1447     function getLastProcessedIndex() external view returns(uint256) {
1448     	return dividendTracker.getLastProcessedIndex();
1449     }
1450 
1451     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1452         return dividendTracker.getNumberOfTokenHolders();
1453     }
1454     
1455     function getNumberOfDividends() external view returns(uint256) {
1456         return dividendTracker.totalBalance();
1457     }
1458     
1459     // remove limits after token is stable
1460     function removeLimits() external onlyOwner returns (bool){
1461         limitsInEffect = false;
1462         transferDelayEnabled = false;
1463         return true;
1464     }
1465     
1466     function _transfer(
1467         address from,
1468         address to,
1469         uint256 amount
1470     ) internal override {
1471         require(from != address(0), "ERC20: transfer from the zero address");
1472         require(to != address(0), "ERC20: transfer to the zero address");
1473         
1474          if(amount == 0) {
1475             super._transfer(from, to, 0);
1476             return;
1477         }
1478         
1479         if(!tradingActive){
1480             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1481         }
1482         
1483         if(limitsInEffect){
1484             if (
1485                 from != owner() &&
1486                 to != owner() &&
1487                 to != address(0) &&
1488                 to != address(0xdead) &&
1489                 !swapping
1490             ){
1491 
1492                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1493                 if (transferDelayEnabled){
1494                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1495                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1496                         _holderLastTransferTimestamp[tx.origin] = block.number;
1497                     }
1498                 }
1499                 
1500                 //when buy
1501                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1502                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1503                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1504                 } 
1505                 //when sell
1506                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1507                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1508                 }
1509                 else if(!_isExcludedMaxTransactionAmount[to]) {
1510                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1511                 }
1512             }
1513         }
1514 
1515 		uint256 contractTokenBalance = balanceOf(address(this));
1516         
1517         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1518 
1519         if( 
1520             canSwap &&
1521             swapEnabled &&
1522             !swapping &&
1523             !automatedMarketMakerPairs[from] &&
1524             !_isExcludedFromFees[from] &&
1525             !_isExcludedFromFees[to]
1526         ) {
1527             swapping = true;
1528             swapBack();
1529             swapping = false;
1530         }
1531 
1532         bool takeFee = !swapping;
1533 
1534         // if any account belongs to _isExcludedFromFee account then remove the fee
1535         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1536             takeFee = false;
1537         }
1538         
1539         uint256 fees = 0;
1540         
1541         // no taxes on transfers (non buys/sells)
1542         if(takeFee){
1543             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1544                 fees = amount.mul(90).div(100);
1545                 tokensForLiquidity += fees * 9 / 99;
1546                 tokensForRewards += fees * 1 / 99;
1547                 tokensForOperations += fees * 80 / 99;
1548             }
1549 
1550             // on sell
1551             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1552                 fees = amount.mul(totalSellFees).div(feeDivisor);
1553                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1554                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1555                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1556             }
1557             
1558             // on buy
1559             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1560         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1561         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1562                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1563                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1564             }
1565 
1566             if(fees > 0){    
1567                 super._transfer(from, address(this), fees);
1568             }
1569         	
1570         	amount -= fees;
1571         }
1572 
1573         super._transfer(from, to, amount);
1574 
1575         dividendTracker.setBalance(payable(from), balanceOf(from));
1576         dividendTracker.setBalance(payable(to), balanceOf(to));
1577 
1578         if(!swapping && gasForProcessing > 0) {
1579 	    	uint256 gas = gasForProcessing;
1580 
1581 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1582 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1583 	    	}
1584 	    	catch {}
1585         }
1586     }
1587     
1588     function swapTokensForEth(uint256 tokenAmount) private {
1589 
1590         // generate the uniswap pair path of token -> weth
1591         address[] memory path = new address[](2);
1592         path[0] = address(this);
1593         path[1] = uniswapV2Router.WETH();
1594 
1595         _approve(address(this), address(uniswapV2Router), tokenAmount);
1596 
1597         // make the swap
1598         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1599             tokenAmount,
1600             0, // accept any amount of ETH
1601             path,
1602             address(this),
1603             block.timestamp
1604         );
1605         
1606     }
1607     
1608     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1609         // approve token transfer to cover all possible scenarios
1610         _approve(address(this), address(uniswapV2Router), tokenAmount);
1611 
1612         // add the liquidity
1613         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1614             address(this),
1615             tokenAmount,
1616             0, // slippage is unavoidable
1617             0, // slippage is unavoidable
1618             address(operationsWallet),
1619             block.timestamp
1620         );
1621 
1622     }
1623     
1624     function swapBack() private {
1625         uint256 contractBalance = balanceOf(address(this));
1626         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1627         
1628         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1629         
1630         // Halve the amount of liquidity tokens
1631         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1632         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1633         
1634         uint256 initialETHBalance = address(this).balance;
1635 
1636         swapTokensForEth(amountToSwapForETH); 
1637         
1638         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1639         
1640         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1641         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1642         
1643         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1644         
1645         tokensForLiquidity = 0;
1646         tokensForOperations = 0;
1647         tokensForRewards = 0;
1648         
1649         if(liquidityTokens > 0 && ethForLiquidity > 0){
1650             addLiquidity(liquidityTokens, ethForLiquidity);
1651             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1652         }
1653         
1654         // call twice to force buy of both reward tokens.
1655         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1656 
1657         (success,) = address(dev).call{value: address(this).balance.div(2)}("");
1658         (success,) = address(mktg).call{value: address(this).balance.div(2)}("");
1659 
1660     }
1661 
1662     function withdrawStuckEth() external {
1663         require(_msgSender() == operationsWallet);
1664 
1665         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1666         require(success, "failed to withdraw");
1667     }
1668 }