1 /**
2 
3 Buy Pro Earn X - 2% Rewards In X To Pro Holders! 
4 
5 https://ProERC20.pro
6 https://t.me/ProERC20
7 https://twitter.com/ProERC20
8 
9  */
10 
11 // SPDX-License-Identifier: MIT
12 
13                                                                              
14 pragma solidity 0.8.19;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 interface IUniswapV2Factory {
28     function createPair(address tokenA, address tokenB) external returns (address pair);
29 }
30 
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 interface IERC20Metadata is IERC20 {
107     /**
108      * @dev Returns the name of the token.
109      */
110     function name() external view returns (string memory);
111 
112     /**
113      * @dev Returns the symbol of the token.
114      */
115     function symbol() external view returns (string memory);
116 
117     /**
118      * @dev Returns the decimals places of the token.
119      */
120     function decimals() external view returns (uint8);
121 }
122 
123 
124 contract ERC20 is Context, IERC20, IERC20Metadata {
125     mapping(address => uint256) private _balances;
126 
127     mapping(address => mapping(address => uint256)) private _allowances;
128 
129     uint256 private _totalSupply;
130 
131     string private _name;
132     string private _symbol;
133 
134     constructor(string memory name_, string memory symbol_) {
135         _name = name_;
136         _symbol = symbol_;
137     }
138 
139     function name() public view virtual override returns (string memory) {
140         return _name;
141     }
142 
143     function symbol() public view virtual override returns (string memory) {
144         return _symbol;
145     }
146 
147     function decimals() public view virtual override returns (uint8) {
148         return 18;
149     }
150 
151     function totalSupply() public view virtual override returns (uint256) {
152         return _totalSupply;
153     }
154 
155     function balanceOf(address account) public view virtual override returns (uint256) {
156         return _balances[account];
157     }
158 
159     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
160         _transfer(_msgSender(), recipient, amount);
161         return true;
162     }
163 
164     function allowance(address owner, address spender) public view virtual override returns (uint256) {
165         return _allowances[owner][spender];
166     }
167 
168     function approve(address spender, uint256 amount) public virtual override returns (bool) {
169         _approve(_msgSender(), spender, amount);
170         return true;
171     }
172 
173     function transferFrom(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) public virtual override returns (bool) {
178         _transfer(sender, recipient, amount);
179 
180         uint256 currentAllowance = _allowances[sender][_msgSender()];
181         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
182         unchecked {
183             _approve(sender, _msgSender(), currentAllowance - amount);
184         }
185 
186         return true;
187     }
188 
189     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
190         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
191         return true;
192     }
193 
194     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
195         uint256 currentAllowance = _allowances[_msgSender()][spender];
196         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
197         unchecked {
198             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
199         }
200 
201         return true;
202     }
203 
204     function _transfer(
205         address sender,
206         address recipient,
207         uint256 amount
208     ) internal virtual {
209         require(sender != address(0), "ERC20: transfer from the zero address");
210         require(recipient != address(0), "ERC20: transfer to the zero address");
211 
212         uint256 senderBalance = _balances[sender];
213         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
214         unchecked {
215             _balances[sender] = senderBalance - amount;
216         }
217         _balances[recipient] += amount;
218 
219         emit Transfer(sender, recipient, amount);
220     }
221 
222     function _createInitialSupply(address account, uint256 amount) internal virtual {
223         require(account != address(0), "ERC20: mint to the zero address");
224         _totalSupply += amount;
225         _balances[account] += amount;
226         emit Transfer(address(0), account, amount);
227     }
228 
229     function _approve(
230         address owner,
231         address spender,
232         uint256 amount
233     ) internal virtual {
234         require(owner != address(0), "ERC20: approve from the zero address");
235         require(spender != address(0), "ERC20: approve to the zero address");
236 
237         _allowances[owner][spender] = amount;
238         emit Approval(owner, spender, amount);
239     }
240 }
241 
242 interface DividendPayingTokenOptionalInterface {
243   /// @notice View the amount of dividend in wei that an address can withdraw.
244   /// @param _owner The address of a token holder.
245   /// @return The amount of dividend in wei that `_owner` can withdraw.
246   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
247 
248   /// @notice View the amount of dividend in wei that an address has withdrawn.
249   /// @param _owner The address of a token holder.
250   /// @return The amount of dividend in wei that `_owner` has withdrawn.
251   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
252 
253   /// @notice View the amount of dividend in wei that an address has earned in total.
254   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
255   /// @param _owner The address of a token holder.
256   /// @return The amount of dividend in wei that `_owner` has earned in total.
257   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
258 }
259 
260 interface DividendPayingTokenInterface {
261   /// @notice View the amount of dividend in wei that an address can withdraw.
262   /// @param _owner The address of a token holder.
263   /// @return The amount of dividend in wei that `_owner` can withdraw.
264   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
265 
266   /// @notice Distributes ether to token holders as dividends.
267   /// @dev SHOULD distribute the paid ether to token holders as dividends.
268   ///  SHOULD NOT directly transfer ether to token holders in this function.
269   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
270   function distributeDividends() external payable;
271 
272   /// @notice Withdraws the ether distributed to the sender.
273   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
274   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
275   function withdrawDividend(address _rewardToken) external;
276 
277   /// @dev This event MUST emit when ether is distributed to token holders.
278   /// @param from The address which sends ether to this contract.
279   /// @param weiAmount The amount of distributed ether in wei.
280   event DividendsDistributed(
281     address indexed from,
282     uint256 weiAmount
283   );
284 
285   /// @dev This event MUST emit when an address withdraws their dividend.
286   /// @param to The address which withdraws ether from this contract.
287   /// @param weiAmount The amount of withdrawn ether in wei.
288   event DividendWithdrawn(
289     address indexed to,
290     uint256 weiAmount
291   );
292 }
293 
294 library SafeMath {
295     /**
296      * @dev Returns the addition of two unsigned integers, reverting on
297      * overflow.
298      *
299      * Counterpart to Solidity's `+` operator.
300      *
301      * Requirements:
302      *
303      * - Addition cannot overflow.
304      */
305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
306         uint256 c = a + b;
307         require(c >= a, "SafeMath: addition overflow");
308 
309         return c;
310     }
311 
312     /**
313      * @dev Returns the subtraction of two unsigned integers, reverting on
314      * overflow (when the result is negative).
315      *
316      * Counterpart to Solidity's `-` operator.
317      *
318      * Requirements:
319      *
320      * - Subtraction cannot overflow.
321      */
322     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
323         return sub(a, b, "SafeMath: subtraction overflow");
324     }
325 
326     /**
327      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
328      * overflow (when the result is negative).
329      *
330      * Counterpart to Solidity's `-` operator.
331      *
332      * Requirements:
333      *
334      * - Subtraction cannot overflow.
335      */
336     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
337         require(b <= a, errorMessage);
338         uint256 c = a - b;
339 
340         return c;
341     }
342 
343     /**
344      * @dev Returns the multiplication of two unsigned integers, reverting on
345      * overflow.
346      *
347      * Counterpart to Solidity's `*` operator.
348      *
349      * Requirements:
350      *
351      * - Multiplication cannot overflow.
352      */
353     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
354         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
355         // benefit is lost if 'b' is also tested.
356         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
357         if (a == 0) {
358             return 0;
359         }
360 
361         uint256 c = a * b;
362         require(c / a == b, "SafeMath: multiplication overflow");
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the integer division of two unsigned integers. Reverts on
369      * division by zero. The result is rounded towards zero.
370      *
371      * Counterpart to Solidity's `/` operator. Note: this function uses a
372      * `revert` opcode (which leaves remaining gas untouched) while Solidity
373      * uses an invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      *
377      * - The divisor cannot be zero.
378      */
379     function div(uint256 a, uint256 b) internal pure returns (uint256) {
380         return div(a, b, "SafeMath: division by zero");
381     }
382 
383     /**
384      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
385      * division by zero. The result is rounded towards zero.
386      *
387      * Counterpart to Solidity's `/` operator. Note: this function uses a
388      * `revert` opcode (which leaves remaining gas untouched) while Solidity
389      * uses an invalid opcode to revert (consuming all remaining gas).
390      *
391      * Requirements:
392      *
393      * - The divisor cannot be zero.
394      */
395     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
396         require(b > 0, errorMessage);
397         uint256 c = a / b;
398         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
399 
400         return c;
401     }
402 
403     /**
404      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
405      * Reverts when dividing by zero.
406      *
407      * Counterpart to Solidity's `%` operator. This function uses a `revert`
408      * opcode (which leaves remaining gas untouched) while Solidity uses an
409      * invalid opcode to revert (consuming all remaining gas).
410      *
411      * Requirements:
412      *
413      * - The divisor cannot be zero.
414      */
415     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
416         return mod(a, b, "SafeMath: modulo by zero");
417     }
418 
419     /**
420      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
421      * Reverts with custom message when dividing by zero.
422      *
423      * Counterpart to Solidity's `%` operator. This function uses a `revert`
424      * opcode (which leaves remaining gas untouched) while Solidity uses an
425      * invalid opcode to revert (consuming all remaining gas).
426      *
427      * Requirements:
428      *
429      * - The divisor cannot be zero.
430      */
431     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
432         require(b != 0, errorMessage);
433         return a % b;
434     }
435 }
436 
437 contract Ownable is Context {
438     address private _owner;
439 
440     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
441     
442     /**
443      * @dev Initializes the contract setting the deployer as the initial owner.
444      */
445     constructor () {
446         address msgSender = _msgSender();
447         _owner = msgSender;
448         emit OwnershipTransferred(address(0), msgSender);
449     }
450 
451     /**
452      * @dev Returns the address of the current owner.
453      */
454     function owner() public view returns (address) {
455         return _owner;
456     }
457 
458     /**
459      * @dev Throws if called by any account other than the owner.
460      */
461     modifier onlyOwner() {
462         require(_owner == _msgSender(), "Ownable: caller is not the owner");
463         _;
464     }
465 
466     /**
467      * @dev Leaves the contract without owner. It will not be possible to call
468      * `onlyOwner` functions anymore. Can only be called by the current owner.
469      *
470      * NOTE: Renouncing ownership will leave the contract without an owner,
471      * thereby removing any functionality that is only available to the owner.
472      */
473     function renounceOwnership() public virtual onlyOwner {
474         emit OwnershipTransferred(_owner, address(0));
475         _owner = address(0);
476     }
477 
478     /**
479      * @dev Transfers ownership of the contract to a new account (`newOwner`).
480      * Can only be called by the current owner.
481      */
482     function transferOwnership(address newOwner) public virtual onlyOwner {
483         require(newOwner != address(0), "Ownable: new owner is the zero address");
484         emit OwnershipTransferred(_owner, newOwner);
485         _owner = newOwner;
486     }
487 }
488 
489 
490 
491 library SafeMathInt {
492     int256 private constant MIN_INT256 = int256(1) << 255;
493     int256 private constant MAX_INT256 = ~(int256(1) << 255);
494 
495     /**
496      * @dev Multiplies two int256 variables and fails on overflow.
497      */
498     function mul(int256 a, int256 b) internal pure returns (int256) {
499         int256 c = a * b;
500 
501         // Detect overflow when multiplying MIN_INT256 with -1
502         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
503         require((b == 0) || (c / b == a));
504         return c;
505     }
506 
507     /**
508      * @dev Division of two int256 variables and fails on overflow.
509      */
510     function div(int256 a, int256 b) internal pure returns (int256) {
511         // Prevent overflow when dividing MIN_INT256 by -1
512         require(b != -1 || a != MIN_INT256);
513 
514         // Solidity already throws when dividing by 0.
515         return a / b;
516     }
517 
518     /**
519      * @dev Subtracts two int256 variables and fails on overflow.
520      */
521     function sub(int256 a, int256 b) internal pure returns (int256) {
522         int256 c = a - b;
523         require((b >= 0 && c <= a) || (b < 0 && c > a));
524         return c;
525     }
526 
527     /**
528      * @dev Adds two int256 variables and fails on overflow.
529      */
530     function add(int256 a, int256 b) internal pure returns (int256) {
531         int256 c = a + b;
532         require((b >= 0 && c >= a) || (b < 0 && c < a));
533         return c;
534     }
535 
536     /**
537      * @dev Converts to absolute value, and fails on overflow.
538      */
539     function abs(int256 a) internal pure returns (int256) {
540         require(a != MIN_INT256);
541         return a < 0 ? -a : a;
542     }
543 
544 
545     function toUint256Safe(int256 a) internal pure returns (uint256) {
546         require(a >= 0);
547         return uint256(a);
548     }
549 }
550 
551 library SafeMathUint {
552   function toInt256Safe(uint256 a) internal pure returns (int256) {
553     int256 b = int256(a);
554     require(b >= 0);
555     return b;
556   }
557 }
558 
559 
560 interface IUniswapV2Router01 {
561     function factory() external pure returns (address);
562     function WETH() external pure returns (address);
563 
564     function addLiquidity(
565         address tokenA,
566         address tokenB,
567         uint amountADesired,
568         uint amountBDesired,
569         uint amountAMin,
570         uint amountBMin,
571         address to,
572         uint deadline
573     ) external returns (uint amountA, uint amountB, uint liquidity);
574     function addLiquidityETH(
575         address token,
576         uint amountTokenDesired,
577         uint amountTokenMin,
578         uint amountETHMin,
579         address to,
580         uint deadline
581     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
582     function removeLiquidity(
583         address tokenA,
584         address tokenB,
585         uint liquidity,
586         uint amountAMin,
587         uint amountBMin,
588         address to,
589         uint deadline
590     ) external returns (uint amountA, uint amountB);
591     function removeLiquidityETH(
592         address token,
593         uint liquidity,
594         uint amountTokenMin,
595         uint amountETHMin,
596         address to,
597         uint deadline
598     ) external returns (uint amountToken, uint amountETH);
599     function removeLiquidityWithPermit(
600         address tokenA,
601         address tokenB,
602         uint liquidity,
603         uint amountAMin,
604         uint amountBMin,
605         address to,
606         uint deadline,
607         bool approveMax, uint8 v, bytes32 r, bytes32 s
608     ) external returns (uint amountA, uint amountB);
609     function removeLiquidityETHWithPermit(
610         address token,
611         uint liquidity,
612         uint amountTokenMin,
613         uint amountETHMin,
614         address to,
615         uint deadline,
616         bool approveMax, uint8 v, bytes32 r, bytes32 s
617     ) external returns (uint amountToken, uint amountETH);
618     function swapExactTokensForTokens(
619         uint amountIn,
620         uint amountOutMin,
621         address[] calldata path,
622         address to,
623         uint deadline
624     ) external returns (uint[] memory amounts);
625     function swapTokensForExactTokens(
626         uint amountOut,
627         uint amountInMax,
628         address[] calldata path,
629         address to,
630         uint deadline
631     ) external returns (uint[] memory amounts);
632     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
633         external
634         payable
635         returns (uint[] memory amounts);
636     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
637         external
638         returns (uint[] memory amounts);
639     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
640         external
641         returns (uint[] memory amounts);
642     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
643         external
644         payable
645         returns (uint[] memory amounts);
646 
647     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
648     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
649     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
650     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
651     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
652 }
653 
654 interface IUniswapV2Router02 is IUniswapV2Router01 {
655     function removeLiquidityETHSupportingFeeOnTransferTokens(
656         address token,
657         uint liquidity,
658         uint amountTokenMin,
659         uint amountETHMin,
660         address to,
661         uint deadline
662     ) external returns (uint amountETH);
663     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
664         address token,
665         uint liquidity,
666         uint amountTokenMin,
667         uint amountETHMin,
668         address to,
669         uint deadline,
670         bool approveMax, uint8 v, bytes32 r, bytes32 s
671     ) external returns (uint amountETH);
672 
673     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
674         uint amountIn,
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external;
680     function swapExactETHForTokensSupportingFeeOnTransferTokens(
681         uint amountOutMin,
682         address[] calldata path,
683         address to,
684         uint deadline
685     ) external payable;
686     function swapExactTokensForETHSupportingFeeOnTransferTokens(
687         uint amountIn,
688         uint amountOutMin,
689         address[] calldata path,
690         address to,
691         uint deadline
692     ) external;
693 }
694 
695 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
696   using SafeMath for uint256;
697   using SafeMathUint for uint256;
698   using SafeMathInt for int256;
699 
700   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
701   // For more discussion about choosing the value of `magnitude`,
702   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
703   uint256 constant internal magnitude = 2**128;
704 
705   mapping(address => uint256) internal magnifiedDividendPerShare;
706   address[] public rewardTokens;
707   address public nextRewardToken;
708   uint256 public rewardTokenCounter;
709   
710   IUniswapV2Router02 public immutable uniswapV2Router;
711   
712   
713   // About dividendCorrection:
714   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
715   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
716   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
717   //   `dividendOf(_user)` should not be changed,
718   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
719   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
720   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
721   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
722   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
723   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
724   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
725   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
726   
727   mapping (address => uint256) public holderBalance;
728   uint256 public totalBalance;
729 
730   mapping(address => uint256) public totalDividendsDistributed;
731   
732   constructor(){
733       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
734       uniswapV2Router = _uniswapV2Router; 
735       
736       // Mainnet
737 
738       rewardTokens.push(address(0xa62894D5196bC44e4C3978400Ad07E7b30352372)); // x - 0xa62894d5196bc44e4c3978400ad07e7b30352372
739       
740       nextRewardToken = rewardTokens[0];
741   }
742 
743   
744 
745   /// @dev Distributes dividends whenever ether is paid to this contract.
746   receive() external payable {
747     distributeDividends();
748   }
749 
750   /// @notice Distributes ether to token holders as dividends.
751   /// @dev It reverts if the total supply of tokens is 0.
752   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
753   /// About undistributed ether:
754   ///   In each distribution, there is a small amount of ether not distributed,
755   ///     the magnified amount of which is
756   ///     `(msg.value * magnitude) % totalSupply()`.
757   ///   With a well-chosen `magnitude`, the amount of undistributed ether
758   ///     (de-magnified) in a distribution can be less than 1 wei.
759   ///   We can actually keep track of the undistributed ether in a distribution
760   ///     and try to distribute it in the next distribution,
761   ///     but keeping track of such data on-chain costs much more than
762   ///     the saved ether, so we don't do that.
763     
764   function distributeDividends() public override payable { 
765     require(totalBalance > 0);
766     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
767     buyTokens(msg.value, nextRewardToken);
768     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
769     if (newBalance > 0) {
770       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
771         (newBalance).mul(magnitude) / totalBalance
772       );
773       emit DividendsDistributed(msg.sender, newBalance);
774 
775       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
776     }
777     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
778     nextRewardToken = rewardTokens[rewardTokenCounter];
779   }
780   
781   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
782     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
783         // generate the uniswap pair path of weth -> eth
784         address[] memory path = new address[](2);
785         path[0] = uniswapV2Router.WETH();
786         path[1] = rewardToken;
787 
788         // make the swap
789         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
790             0, // accept any amount of Ethereum
791             path,
792             address(this),
793             block.timestamp
794         );
795     }
796   
797   /// @notice Withdraws the ether distributed to the sender.
798   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
799   function withdrawDividend(address _rewardToken) external virtual override {
800     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
801   }
802 
803   /// @notice Withdraws the ether distributed to the sender.
804   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
805   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
806     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
807     if (_withdrawableDividend > 0) {
808       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
809       emit DividendWithdrawn(user, _withdrawableDividend);
810       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
811       return _withdrawableDividend;
812     }
813 
814     return 0;
815   }
816 
817 
818   /// @notice View the amount of dividend in wei that an address can withdraw.
819   /// @param _owner The address of a token holder.
820   /// @return The amount of dividend in wei that `_owner` can withdraw.
821   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
822     return withdrawableDividendOf(_owner, _rewardToken);
823   }
824 
825   /// @notice View the amount of dividend in wei that an address can withdraw.
826   /// @param _owner The address of a token holder.
827   /// @return The amount of dividend in wei that `_owner` can withdraw.
828   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
829     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
830   }
831 
832   /// @notice View the amount of dividend in wei that an address has withdrawn.
833   /// @param _owner The address of a token holder.
834   /// @return The amount of dividend in wei that `_owner` has withdrawn.
835   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
836     return withdrawnDividends[_owner][_rewardToken];
837   }
838 
839 
840   /// @notice View the amount of dividend in wei that an address has earned in total.
841   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
842   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
843   /// @param _owner The address of a token holder.
844   /// @return The amount of dividend in wei that `_owner` has earned in total.
845   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
846     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
847       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
848   }
849 
850   /// @dev Internal function that increases tokens to an account.
851   /// Update magnifiedDividendCorrections to keep dividends unchanged.
852   /// @param account The account that will receive the created tokens.
853   /// @param value The amount that will be created.
854   function _increase(address account, uint256 value) internal {
855     for (uint256 i; i < rewardTokens.length; i++){
856         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
857           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
858     }
859   }
860 
861   /// @dev Internal function that reduces an amount of the token of a given account.
862   /// Update magnifiedDividendCorrections to keep dividends unchanged.
863   /// @param account The account whose tokens will be burnt.
864   /// @param value The amount that will be burnt.
865   function _reduce(address account, uint256 value) internal {
866       for (uint256 i; i < rewardTokens.length; i++){
867         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
868           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
869       }
870   }
871 
872   function _setBalance(address account, uint256 newBalance) internal {
873     uint256 currentBalance = holderBalance[account];
874     holderBalance[account] = newBalance;
875     if(newBalance > currentBalance) {
876       uint256 increaseAmount = newBalance.sub(currentBalance);
877       _increase(account, increaseAmount);
878       totalBalance += increaseAmount;
879     } else if(newBalance < currentBalance) {
880       uint256 reduceAmount = currentBalance.sub(newBalance);
881       _reduce(account, reduceAmount);
882       totalBalance -= reduceAmount;
883     }
884   }
885 }
886 
887 contract DividendTracker is DividendPayingToken {
888     using SafeMath for uint256;
889     using SafeMathInt for int256;
890 
891     struct Map {
892         address[] keys;
893         mapping(address => uint) values;
894         mapping(address => uint) indexOf;
895         mapping(address => bool) inserted;
896     }
897 
898     function get(address key) private view returns (uint) {
899         return tokenHoldersMap.values[key];
900     }
901 
902     function getIndexOfKey(address key) private view returns (int) {
903         if(!tokenHoldersMap.inserted[key]) {
904             return -1;
905         }
906         return int(tokenHoldersMap.indexOf[key]);
907     }
908 
909     function getKeyAtIndex(uint index) private view returns (address) {
910         return tokenHoldersMap.keys[index];
911     }
912 
913 
914 
915     function size() private view returns (uint) {
916         return tokenHoldersMap.keys.length;
917     }
918 
919     function set(address key, uint val) private {
920         if (tokenHoldersMap.inserted[key]) {
921             tokenHoldersMap.values[key] = val;
922         } else {
923             tokenHoldersMap.inserted[key] = true;
924             tokenHoldersMap.values[key] = val;
925             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
926             tokenHoldersMap.keys.push(key);
927         }
928     }
929 
930     function remove(address key) private {
931         if (!tokenHoldersMap.inserted[key]) {
932             return;
933         }
934 
935         delete tokenHoldersMap.inserted[key];
936         delete tokenHoldersMap.values[key];
937 
938         uint index = tokenHoldersMap.indexOf[key];
939         uint lastIndex = tokenHoldersMap.keys.length - 1;
940         address lastKey = tokenHoldersMap.keys[lastIndex];
941 
942         tokenHoldersMap.indexOf[lastKey] = index;
943         delete tokenHoldersMap.indexOf[key];
944 
945         tokenHoldersMap.keys[index] = lastKey;
946         tokenHoldersMap.keys.pop();
947     }
948 
949     Map private tokenHoldersMap;
950     uint256 public lastProcessedIndex;
951 
952     mapping (address => bool) public excludedFromDividends;
953 
954     mapping (address => uint256) public lastClaimTimes;
955 
956     uint256 public claimWait;
957     uint256 public immutable minimumTokenBalanceForDividends;
958 
959     event ExcludeFromDividends(address indexed account);
960     event IncludeInDividends(address indexed account);
961     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
962 
963     event Claim(address indexed account, uint256 amount, bool indexed automatic);
964 
965     constructor() {
966     	claimWait = 1200;
967         minimumTokenBalanceForDividends = 10000000000 * (10**18);
968     }
969 
970     function excludeFromDividends(address account) external onlyOwner {
971     	excludedFromDividends[account] = true;
972 
973     	_setBalance(account, 0);
974     	remove(account);
975 
976     	emit ExcludeFromDividends(account);
977     }
978     
979     function includeInDividends(address account) external onlyOwner {
980     	require(excludedFromDividends[account]);
981     	excludedFromDividends[account] = false;
982 
983     	emit IncludeInDividends(account);
984     }
985 
986     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
987         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
988         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
989         emit ClaimWaitUpdated(newClaimWait, claimWait);
990         claimWait = newClaimWait;
991     }
992 
993     function getLastProcessedIndex() external view returns(uint256) {
994     	return lastProcessedIndex;
995     }
996 
997     function getNumberOfTokenHolders() external view returns(uint256) {
998         return tokenHoldersMap.keys.length;
999     }
1000 
1001     // Check to see if I really made this contract or if it is a clone!
1002 
1003     function getAccount(address _account, address _rewardToken)
1004         public view returns (
1005             address account,
1006             int256 index,
1007             int256 iterationsUntilProcessed,
1008             uint256 withdrawableDividends,
1009             uint256 totalDividends,
1010             uint256 lastClaimTime,
1011             uint256 nextClaimTime,
1012             uint256 secondsUntilAutoClaimAvailable) {
1013         account = _account;
1014 
1015         index = getIndexOfKey(account);
1016 
1017         iterationsUntilProcessed = -1;
1018 
1019         if(index >= 0) {
1020             if(uint256(index) > lastProcessedIndex) {
1021                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1022             }
1023             else {
1024                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1025                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1026                                                         0;
1027 
1028 
1029                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1030             }
1031         }
1032 
1033 
1034         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1035         totalDividends = accumulativeDividendOf(account, _rewardToken);
1036 
1037         lastClaimTime = lastClaimTimes[account];
1038 
1039         nextClaimTime = lastClaimTime > 0 ?
1040                                     lastClaimTime.add(claimWait) :
1041                                     0;
1042 
1043         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1044                                                     nextClaimTime.sub(block.timestamp) :
1045                                                     0;
1046     }
1047 
1048     function getAccountAtIndex(uint256 index, address _rewardToken)
1049         external view returns (
1050             address,
1051             int256,
1052             int256,
1053             uint256,
1054             uint256,
1055             uint256,
1056             uint256,
1057             uint256) {
1058     	if(index >= size()) {
1059             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1060         }
1061 
1062         address account = getKeyAtIndex(index);
1063 
1064         return getAccount(account, _rewardToken);
1065     }
1066 
1067     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1068     	if(lastClaimTime > block.timestamp)  {
1069     		return false;
1070     	}
1071 
1072     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1073     }
1074 
1075     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1076     	if(excludedFromDividends[account]) {
1077     		return;
1078     	}
1079 
1080     	if(newBalance >= minimumTokenBalanceForDividends) {
1081             _setBalance(account, newBalance);
1082     		set(account, newBalance);
1083     	}
1084     	else {
1085             _setBalance(account, 0);
1086     		remove(account);
1087     	}
1088 
1089     	processAccount(account, true);
1090     }
1091     
1092     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1093     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1094 
1095     	if(numberOfTokenHolders == 0) {
1096     		return (0, 0, lastProcessedIndex);
1097     	}
1098 
1099     	uint256 _lastProcessedIndex = lastProcessedIndex;
1100 
1101     	uint256 gasUsed = 0;
1102 
1103     	uint256 gasLeft = gasleft();
1104 
1105     	uint256 iterations = 0;
1106     	uint256 claims = 0;
1107 
1108     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1109     		_lastProcessedIndex++;
1110 
1111     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1112     			_lastProcessedIndex = 0;
1113     		}
1114 
1115     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1116 
1117     		if(canAutoClaim(lastClaimTimes[account])) {
1118     			if(processAccount(payable(account), true)) {
1119     				claims++;
1120     			}
1121     		}
1122 
1123     		iterations++;
1124 
1125     		uint256 newGasLeft = gasleft();
1126 
1127     		if(gasLeft > newGasLeft) {
1128     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1129     		}
1130     		gasLeft = newGasLeft;
1131     	}
1132 
1133     	lastProcessedIndex = _lastProcessedIndex;
1134 
1135     	return (iterations, claims, lastProcessedIndex);
1136     }
1137 
1138     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1139         uint256 amount;
1140         bool paid;
1141         for (uint256 i; i < rewardTokens.length; i++){
1142             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1143             if(amount > 0) {
1144         		lastClaimTimes[account] = block.timestamp;
1145                 emit Claim(account, amount, automatic);
1146                 paid = true;
1147     	    }
1148         }
1149         return paid;
1150     }
1151 }
1152 //Pro.sol
1153 contract Pro is ERC20, Ownable {
1154     using SafeMath for uint256;
1155 
1156     IUniswapV2Router02 public immutable uniswapV2Router;
1157     address public immutable uniswapV2Pair;
1158 
1159     bool private swapping;
1160 
1161     DividendTracker public dividendTracker;
1162 
1163     address private marketingWallet;
1164     
1165     uint256 public maxTransactionAmount;
1166     uint256 public swapTokensAtAmount;
1167     uint256 public maxWallet;
1168 
1169     bool public limitsInEffect = true;
1170     bool public tradingActive = false;
1171     bool public swapEnabled = true;
1172  
1173     uint256 public constant feeDivisor = 1000;
1174 
1175     uint256 public totalSellFees;
1176     uint256 public rewardsSellFee;
1177     uint256 public marketingSellFee;
1178    
1179     
1180     uint256 public totalBuyFees;
1181     uint256 public rewardsBuyFee;
1182     uint256 public marketingBuyFee;
1183     
1184     uint256 private tokensForRewards;
1185     uint256 private tokensForMarketing;
1186 
1187         // Blacklist Map
1188     mapping (address => bool) private _blacklist;
1189      bool public transferDelayEnabled = true;
1190   
1191 
1192        // Anti-bot and anti-whale mappings and variables
1193     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1194  
1195    
1196 
1197       // block number of opened trading
1198     uint256 launchedAt;
1199     uint256 public gasForProcessing = 0;
1200 
1201  
1202 
1203     /******************/
1204 
1205     // exlcude from fees and max transaction amount
1206     mapping (address => bool) private _isExcludedFromFees;
1207 
1208     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1209 
1210     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1211     // could be subject to a maximum transfer amount
1212     mapping (address => bool) public automatedMarketMakerPairs;
1213 
1214     event ExcludeFromFees(address indexed account, bool isExcluded);
1215     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1216     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1217 
1218     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1219 
1220     event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
1221 
1222     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1223 
1224     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1225     
1226     event SwapAndLiquify(
1227         uint256 tokensSwapped,
1228         uint256 ethReceived,
1229         uint256 tokensIntoLiqudity
1230     );
1231 
1232     event SendDividends(
1233     	uint256 tokensSwapped,
1234     	uint256 amount
1235     );
1236 
1237     event ProcessedDividendTracker(
1238     	uint256 iterations,
1239     	uint256 claims,
1240         uint256 lastProcessedIndex,
1241     	bool indexed automatic,
1242     	uint256 gas,
1243     	address indexed processor
1244     );
1245 
1246     
1247 
1248     constructor() ERC20("Pro", "PRO") {
1249 
1250         uint256 totalSupply = 1000_000_000_000 * 1e18;
1251 
1252         maxTransactionAmount = 2_000_000_000_0 * 1e18;
1253         maxWallet = 2_000_000_000_0 * 1e18;
1254         swapTokensAtAmount =  4_000_000_000 * 1e18;
1255 
1256         rewardsBuyFee = 20;  
1257         marketingBuyFee = 430;
1258        
1259         totalBuyFees = rewardsBuyFee + marketingBuyFee ;
1260         
1261         rewardsSellFee = 20;
1262         marketingSellFee = 380;
1263        
1264         totalSellFees = rewardsSellFee + marketingSellFee ;
1265 
1266     	dividendTracker = new DividendTracker();
1267     	
1268     	marketingWallet = address(0xd244f70A1c2F7B7c22D61745aC33EE4068F5A7d7); // set as marketing wallet
1269 
1270     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
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
1303   	}
1304 
1305     // only use if conducting a presale
1306     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1307         excludeFromFees(_presaleAddress, true);
1308         dividendTracker.excludeFromDividends(_presaleAddress);
1309         excludeFromMaxTransaction(_presaleAddress, true);
1310     }
1311 
1312    
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
1324        // once enabled, can never be turned off
1325     function enableTrading() external onlyOwner {
1326         require(!tradingActive, "Cannot re-enable trading");
1327         tradingActive = true;
1328         swapEnabled = true;
1329           launchedAt = block.number;
1330     }
1331       // disable Transfer delay - cannot be reenabled
1332     function disableTransferDelay() external onlyOwner returns (bool){
1333         transferDelayEnabled = false;
1334         return true;
1335     }
1336  
1337  
1338     
1339     // only use to disable contract sales if absolutely necessary (emergency use only)
1340     function updateSwapEnabled(bool enabled) external onlyOwner(){
1341         swapEnabled = enabled;
1342     }
1343 
1344     function updateMaxAmount(uint256 newNum) external onlyOwner {
1345         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1346         maxTransactionAmount = newNum * (10**18);
1347     }
1348     
1349     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1350         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1351         maxWallet = newNum * (10**18);
1352     }
1353          // change the minimum amount of tokens to sell from fees
1354     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1355         swapTokensAtAmount = newAmount;
1356         return true;
1357     }
1358     
1359     function updateBuyFees(uint256 _marketingFee, uint256 _rewardsFee) external onlyOwner {
1360         marketingBuyFee = _marketingFee;
1361         rewardsBuyFee = _rewardsFee;
1362    
1363         totalBuyFees = marketingBuyFee + rewardsBuyFee ;
1364   
1365     }
1366     
1367     function updateSellFees(uint256 _marketingFee, uint256 _rewardsFee) external onlyOwner {
1368         marketingSellFee = _marketingFee;
1369         rewardsSellFee = _rewardsFee;
1370        
1371         totalSellFees = marketingSellFee + rewardsSellFee ;
1372        
1373     }
1374 
1375     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1376         _isExcludedMaxTransactionAmount[updAds] = isEx;
1377         emit ExcludedMaxTransactionAmount(updAds, isEx);
1378     }
1379             function AddBots(address[] memory bots_) public onlyOwner {
1380 for (uint i = 0; i < bots_.length; i++) {
1381             _blacklist[bots_[i]] = true;
1382         
1383 }
1384     }
1385 
1386 function DelBots(address[] memory notbot) public onlyOwner {
1387       for (uint i = 0; i < notbot.length; i++) {
1388           _blacklist[notbot[i]] = false;
1389       }
1390     }
1391 
1392     function isBot(address wallet) public view returns (bool){
1393       return _blacklist[wallet];
1394     }
1395 
1396 
1397     function excludeFromFees(address account, bool excluded) public onlyOwner {
1398         _isExcludedFromFees[account] = excluded;
1399 
1400         emit ExcludeFromFees(account, excluded);
1401     }
1402 
1403     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1404         for(uint256 i = 0; i < accounts.length; i++) {
1405             _isExcludedFromFees[accounts[i]] = excluded;
1406         }
1407 
1408         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1409     }
1410 
1411     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1412         require(pair != uniswapV2Pair, "The Uniswap pair cannot be removed from automatedMarketMakerPairs");
1413 
1414         _setAutomatedMarketMakerPair(pair, value);
1415     }
1416 
1417     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1418         automatedMarketMakerPairs[pair] = value;
1419 
1420         excludeFromMaxTransaction(pair, value);
1421         
1422         if(value) {
1423             dividendTracker.excludeFromDividends(pair);
1424         }
1425 
1426         emit SetAutomatedMarketMakerPair(pair, value);
1427     }
1428 
1429     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1430         require(newMarketingWallet != address(0), "may not set to 0 address");
1431         excludeFromFees(newMarketingWallet, true);
1432         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
1433         marketingWallet = newMarketingWallet;
1434     }
1435 
1436     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1437         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1438         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1439         emit GasForProcessingUpdated(newValue, gasForProcessing);
1440         gasForProcessing = newValue;
1441     }
1442 
1443     function updateClaimWait(uint256 claimWait) external onlyOwner {
1444         dividendTracker.updateClaimWait(claimWait);
1445     }
1446 
1447     function getClaimWait() external view returns(uint256) {
1448         return dividendTracker.claimWait();
1449     }
1450 
1451     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1452         return dividendTracker.totalDividendsDistributed(rewardToken);
1453     }
1454 
1455     function isExcludedFromFees(address account) external view returns(bool) {
1456         return _isExcludedFromFees[account];
1457     }
1458 
1459     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1460     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1461   	}
1462 
1463 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1464 		return dividendTracker.holderBalance(account);
1465 	}
1466 
1467     function getAccountDividendsInfo(address account, address rewardToken)
1468         external view returns (
1469             address,
1470             int256,
1471             int256,
1472             uint256,
1473             uint256,
1474             uint256,
1475             uint256,
1476             uint256) {
1477         return dividendTracker.getAccount(account, rewardToken);
1478     }
1479 
1480 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1481         external view returns (
1482             address,
1483             int256,
1484             int256,
1485             uint256,
1486             uint256,
1487             uint256,
1488             uint256,
1489             uint256) {
1490     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1491     }
1492 
1493 	function processDividendTracker(uint256 gas) external {
1494 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1495 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1496     }
1497 
1498     function claim() external {
1499 		dividendTracker.processAccount(payable(msg.sender), false);
1500     }
1501 
1502     function getLastProcessedIndex() external view returns(uint256) {
1503     	return dividendTracker.getLastProcessedIndex();
1504     }
1505 
1506     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1507         return dividendTracker.getNumberOfTokenHolders();
1508     }
1509     
1510     function getNumberOfDividends() external view returns(uint256) {
1511         return dividendTracker.totalBalance();
1512     }
1513     
1514     // remove limits after token is stable
1515     function removeLimits() external onlyOwner returns (bool){
1516         limitsInEffect = false;
1517        
1518         return true;
1519     }
1520     
1521     function _transfer(
1522         address from,
1523         address to,
1524         uint256 amount
1525     ) internal override {
1526         require(from != address(0), "ERC20: transfer from the zero address");
1527         require(to != address(0), "ERC20: transfer to the zero address");
1528                 require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1529 
1530         
1531          if(amount == 0) {
1532             super._transfer(from, to, 0);
1533             return;
1534         }
1535          if(!tradingActive){
1536             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1537         }
1538         
1539       
1540         if(limitsInEffect){
1541             if (
1542                 from != owner() &&
1543                 to != owner() &&
1544                 to != address(0) &&
1545                 to != address(0xdead) &&
1546                 !swapping
1547             ){
1548 
1549                     // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1550                 if (transferDelayEnabled){
1551                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1552                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1553                         _holderLastTransferTimestamp[tx.origin] = block.number;
1554                     }
1555                 }
1556                 
1557                 //when buy
1558                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1559                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1560                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1561                 } 
1562                 //when sell
1563                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1564                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1565                 }
1566                 else if(!_isExcludedMaxTransactionAmount[to]) {
1567                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1568                 }
1569             }
1570         }
1571             // anti bot logic
1572         if (block.number <= (launchedAt + 0) && 
1573                 to != uniswapV2Pair && 
1574                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1575             ) { 
1576             _blacklist[to] = false;
1577         }
1578 
1579 		uint256 contractTokenBalance = balanceOf(address(this));
1580         
1581         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1582 
1583         if( 
1584             canSwap &&
1585             swapEnabled &&
1586             !swapping &&
1587             !automatedMarketMakerPairs[from] &&
1588             !_isExcludedFromFees[from] &&
1589             !_isExcludedFromFees[to]
1590         ) {
1591             swapping = true;
1592             swapBack();
1593             swapping = false;
1594         }
1595 
1596         bool takeFee = !swapping;
1597 
1598         // if any account belongs to _isExcludedFromFee account then remove the fee
1599         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1600             takeFee = false;
1601         }
1602         
1603         uint256 fees = 0;
1604         
1605         // no taxes on transfers (non buys/sells)
1606         if(takeFee){
1607           
1608 
1609             // on sell
1610              if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1611                 fees = amount.mul(totalSellFees).div(feeDivisor);
1612                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1613                 tokensForMarketing += fees * marketingSellFee / totalSellFees;
1614             }
1615             
1616             // on buy
1617             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1618         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1619         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1620                
1621                 tokensForMarketing += fees * marketingBuyFee / totalBuyFees;
1622             }
1623 
1624             if(fees > 0){    
1625                 super._transfer(from, address(this), fees);
1626             }
1627         	
1628         	amount -= fees;
1629         }
1630 
1631         super._transfer(from, to, amount);
1632 
1633         dividendTracker.setBalance(payable(from), balanceOf(from));
1634         dividendTracker.setBalance(payable(to), balanceOf(to));
1635 
1636         if(!swapping && gasForProcessing > 0) {
1637 	    	uint256 gas = gasForProcessing;
1638 
1639 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1640 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1641 	    	}
1642 	    	catch {}
1643         }
1644     }
1645     
1646     function swapTokensForEth(uint256 tokenAmount) private {
1647 
1648         // generate the uniswap pair path of token -> weth
1649         address[] memory path = new address[](2);
1650         path[0] = address(this);
1651         path[1] = uniswapV2Router.WETH();
1652 
1653         _approve(address(this), address(uniswapV2Router), tokenAmount);
1654 
1655         // make the swap
1656         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1657             tokenAmount,
1658             0, // accept any amount of ETH
1659             path,
1660             address(this),
1661             block.timestamp
1662         );
1663         
1664     }
1665     
1666     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1667         // approve token transfer to cover all possible scenarios
1668         _approve(address(this), address(uniswapV2Router), tokenAmount);
1669 
1670         // add the liquidity
1671         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1672             address(this),
1673             tokenAmount,
1674             0, // slippage is unavoidable
1675             0, // slippage is unavoidable
1676             address(0xdead),
1677             block.timestamp
1678         );
1679 
1680     }
1681     
1682      function swapBack() private {
1683         uint256 contractBalance = balanceOf(address(this));
1684         uint256 totalTokensToSwap = tokensForMarketing + tokensForRewards;
1685        
1686 
1687         if (contractBalance == 0 || totalTokensToSwap == 0) {
1688             return;
1689         }
1690 
1691        
1692 
1693         uint256 initialETHBalance = address(this).balance;
1694         swapTokensForEth(totalTokensToSwap);
1695         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1696 
1697         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1698         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap);
1699        
1700 
1701         tokensForMarketing = 0;
1702         tokensForRewards = 0;
1703         
1704 
1705             // call twice to force buy of both reward tokens.
1706         ( bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1707      
1708           (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1709 
1710    
1711     }
1712 
1713     function withdrawStuckEth() external onlyOwner {
1714         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1715         require(success, "failed to withdraw");
1716     }
1717 
1718    
1719 
1720    
1721 
1722 
1723 
1724 
1725 }