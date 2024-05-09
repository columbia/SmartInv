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
230 interface DividendPayingTokenOptionalInterface {
231   /// @notice View the amount of dividend in wei that an address can withdraw.
232   /// @param _owner The address of a token holder.
233   /// @return The amount of dividend in wei that `_owner` can withdraw.
234   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
235 
236   /// @notice View the amount of dividend in wei that an address has withdrawn.
237   /// @param _owner The address of a token holder.
238   /// @return The amount of dividend in wei that `_owner` has withdrawn.
239   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
240 
241   /// @notice View the amount of dividend in wei that an address has earned in total.
242   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
243   /// @param _owner The address of a token holder.
244   /// @return The amount of dividend in wei that `_owner` has earned in total.
245   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
246 }
247 
248 interface DividendPayingTokenInterface {
249   /// @notice View the amount of dividend in wei that an address can withdraw.
250   /// @param _owner The address of a token holder.
251   /// @return The amount of dividend in wei that `_owner` can withdraw.
252   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
253 
254   /// @notice Distributes ether to token holders as dividends.
255   /// @dev SHOULD distribute the paid ether to token holders as dividends.
256   ///  SHOULD NOT directly transfer ether to token holders in this function.
257   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
258   function distributeDividends() external payable;
259 
260   /// @notice Withdraws the ether distributed to the sender.
261   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
262   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
263   function withdrawDividend(address _rewardToken) external;
264 
265   /// @dev This event MUST emit when ether is distributed to token holders.
266   /// @param from The address which sends ether to this contract.
267   /// @param weiAmount The amount of distributed ether in wei.
268   event DividendsDistributed(
269     address indexed from,
270     uint256 weiAmount
271   );
272 
273   /// @dev This event MUST emit when an address withdraws their dividend.
274   /// @param to The address which withdraws ether from this contract.
275   /// @param weiAmount The amount of withdrawn ether in wei.
276   event DividendWithdrawn(
277     address indexed to,
278     uint256 weiAmount
279   );
280 }
281 
282 library SafeMath {
283     /**
284      * @dev Returns the addition of two unsigned integers, reverting on
285      * overflow.
286      *
287      * Counterpart to Solidity's `+` operator.
288      *
289      * Requirements:
290      *
291      * - Addition cannot overflow.
292      */
293     function add(uint256 a, uint256 b) internal pure returns (uint256) {
294         uint256 c = a + b;
295         require(c >= a, "SafeMath: addition overflow");
296 
297         return c;
298     }
299 
300     /**
301      * @dev Returns the subtraction of two unsigned integers, reverting on
302      * overflow (when the result is negative).
303      *
304      * Counterpart to Solidity's `-` operator.
305      *
306      * Requirements:
307      *
308      * - Subtraction cannot overflow.
309      */
310     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
311         return sub(a, b, "SafeMath: subtraction overflow");
312     }
313 
314     /**
315      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
316      * overflow (when the result is negative).
317      *
318      * Counterpart to Solidity's `-` operator.
319      *
320      * Requirements:
321      *
322      * - Subtraction cannot overflow.
323      */
324     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
325         require(b <= a, errorMessage);
326         uint256 c = a - b;
327 
328         return c;
329     }
330 
331     /**
332      * @dev Returns the multiplication of two unsigned integers, reverting on
333      * overflow.
334      *
335      * Counterpart to Solidity's `*` operator.
336      *
337      * Requirements:
338      *
339      * - Multiplication cannot overflow.
340      */
341     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
342         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
343         // benefit is lost if 'b' is also tested.
344         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
345         if (a == 0) {
346             return 0;
347         }
348 
349         uint256 c = a * b;
350         require(c / a == b, "SafeMath: multiplication overflow");
351 
352         return c;
353     }
354 
355     /**
356      * @dev Returns the integer division of two unsigned integers. Reverts on
357      * division by zero. The result is rounded towards zero.
358      *
359      * Counterpart to Solidity's `/` operator. Note: this function uses a
360      * `revert` opcode (which leaves remaining gas untouched) while Solidity
361      * uses an invalid opcode to revert (consuming all remaining gas).
362      *
363      * Requirements:
364      *
365      * - The divisor cannot be zero.
366      */
367     function div(uint256 a, uint256 b) internal pure returns (uint256) {
368         return div(a, b, "SafeMath: division by zero");
369     }
370 
371     /**
372      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
373      * division by zero. The result is rounded towards zero.
374      *
375      * Counterpart to Solidity's `/` operator. Note: this function uses a
376      * `revert` opcode (which leaves remaining gas untouched) while Solidity
377      * uses an invalid opcode to revert (consuming all remaining gas).
378      *
379      * Requirements:
380      *
381      * - The divisor cannot be zero.
382      */
383     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
384         require(b > 0, errorMessage);
385         uint256 c = a / b;
386         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
387 
388         return c;
389     }
390 
391     /**
392      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
393      * Reverts when dividing by zero.
394      *
395      * Counterpart to Solidity's `%` operator. This function uses a `revert`
396      * opcode (which leaves remaining gas untouched) while Solidity uses an
397      * invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      *
401      * - The divisor cannot be zero.
402      */
403     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
404         return mod(a, b, "SafeMath: modulo by zero");
405     }
406 
407     /**
408      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
409      * Reverts with custom message when dividing by zero.
410      *
411      * Counterpart to Solidity's `%` operator. This function uses a `revert`
412      * opcode (which leaves remaining gas untouched) while Solidity uses an
413      * invalid opcode to revert (consuming all remaining gas).
414      *
415      * Requirements:
416      *
417      * - The divisor cannot be zero.
418      */
419     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
420         require(b != 0, errorMessage);
421         return a % b;
422     }
423 }
424 
425 contract Ownable is Context {
426     address private _owner;
427 
428     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
429     
430     /**
431      * @dev Initializes the contract setting the deployer as the initial owner.
432      */
433     constructor () {
434         address msgSender = _msgSender();
435         _owner = msgSender;
436         emit OwnershipTransferred(address(0), msgSender);
437     }
438 
439     /**
440      * @dev Returns the address of the current owner.
441      */
442     function owner() public view returns (address) {
443         return _owner;
444     }
445 
446     /**
447      * @dev Throws if called by any account other than the owner.
448      */
449     modifier onlyOwner() {
450         require(_owner == _msgSender(), "Ownable: caller is not the owner");
451         _;
452     }
453 
454     /**
455      * @dev Leaves the contract without owner. It will not be possible to call
456      * `onlyOwner` functions anymore. Can only be called by the current owner.
457      *
458      * NOTE: Renouncing ownership will leave the contract without an owner,
459      * thereby removing any functionality that is only available to the owner.
460      */
461     function renounceOwnership() public virtual onlyOwner {
462         emit OwnershipTransferred(_owner, address(0));
463         _owner = address(0);
464     }
465 
466     /**
467      * @dev Transfers ownership of the contract to a new account (`newOwner`).
468      * Can only be called by the current owner.
469      */
470     function transferOwnership(address newOwner) public virtual onlyOwner {
471         require(newOwner != address(0), "Ownable: new owner is the zero address");
472         emit OwnershipTransferred(_owner, newOwner);
473         _owner = newOwner;
474     }
475 }
476 
477 
478 
479 library SafeMathInt {
480     int256 private constant MIN_INT256 = int256(1) << 255;
481     int256 private constant MAX_INT256 = ~(int256(1) << 255);
482 
483     /**
484      * @dev Multiplies two int256 variables and fails on overflow.
485      */
486     function mul(int256 a, int256 b) internal pure returns (int256) {
487         int256 c = a * b;
488 
489         // Detect overflow when multiplying MIN_INT256 with -1
490         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
491         require((b == 0) || (c / b == a));
492         return c;
493     }
494 
495     /**
496      * @dev Division of two int256 variables and fails on overflow.
497      */
498     function div(int256 a, int256 b) internal pure returns (int256) {
499         // Prevent overflow when dividing MIN_INT256 by -1
500         require(b != -1 || a != MIN_INT256);
501 
502         // Solidity already throws when dividing by 0.
503         return a / b;
504     }
505 
506     /**
507      * @dev Subtracts two int256 variables and fails on overflow.
508      */
509     function sub(int256 a, int256 b) internal pure returns (int256) {
510         int256 c = a - b;
511         require((b >= 0 && c <= a) || (b < 0 && c > a));
512         return c;
513     }
514 
515     /**
516      * @dev Adds two int256 variables and fails on overflow.
517      */
518     function add(int256 a, int256 b) internal pure returns (int256) {
519         int256 c = a + b;
520         require((b >= 0 && c >= a) || (b < 0 && c < a));
521         return c;
522     }
523 
524     /**
525      * @dev Converts to absolute value, and fails on overflow.
526      */
527     function abs(int256 a) internal pure returns (int256) {
528         require(a != MIN_INT256);
529         return a < 0 ? -a : a;
530     }
531 
532 
533     function toUint256Safe(int256 a) internal pure returns (uint256) {
534         require(a >= 0);
535         return uint256(a);
536     }
537 }
538 
539 library SafeMathUint {
540   function toInt256Safe(uint256 a) internal pure returns (int256) {
541     int256 b = int256(a);
542     require(b >= 0);
543     return b;
544   }
545 }
546 
547 
548 interface IUniswapV2Router01 {
549     function factory() external pure returns (address);
550     function WETH() external pure returns (address);
551 
552     function addLiquidity(
553         address tokenA,
554         address tokenB,
555         uint amountADesired,
556         uint amountBDesired,
557         uint amountAMin,
558         uint amountBMin,
559         address to,
560         uint deadline
561     ) external returns (uint amountA, uint amountB, uint liquidity);
562     function addLiquidityETH(
563         address token,
564         uint amountTokenDesired,
565         uint amountTokenMin,
566         uint amountETHMin,
567         address to,
568         uint deadline
569     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
570     function removeLiquidity(
571         address tokenA,
572         address tokenB,
573         uint liquidity,
574         uint amountAMin,
575         uint amountBMin,
576         address to,
577         uint deadline
578     ) external returns (uint amountA, uint amountB);
579     function removeLiquidityETH(
580         address token,
581         uint liquidity,
582         uint amountTokenMin,
583         uint amountETHMin,
584         address to,
585         uint deadline
586     ) external returns (uint amountToken, uint amountETH);
587     function removeLiquidityWithPermit(
588         address tokenA,
589         address tokenB,
590         uint liquidity,
591         uint amountAMin,
592         uint amountBMin,
593         address to,
594         uint deadline,
595         bool approveMax, uint8 v, bytes32 r, bytes32 s
596     ) external returns (uint amountA, uint amountB);
597     function removeLiquidityETHWithPermit(
598         address token,
599         uint liquidity,
600         uint amountTokenMin,
601         uint amountETHMin,
602         address to,
603         uint deadline,
604         bool approveMax, uint8 v, bytes32 r, bytes32 s
605     ) external returns (uint amountToken, uint amountETH);
606     function swapExactTokensForTokens(
607         uint amountIn,
608         uint amountOutMin,
609         address[] calldata path,
610         address to,
611         uint deadline
612     ) external returns (uint[] memory amounts);
613     function swapTokensForExactTokens(
614         uint amountOut,
615         uint amountInMax,
616         address[] calldata path,
617         address to,
618         uint deadline
619     ) external returns (uint[] memory amounts);
620     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
621         external
622         payable
623         returns (uint[] memory amounts);
624     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
625         external
626         returns (uint[] memory amounts);
627     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
628         external
629         returns (uint[] memory amounts);
630     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
631         external
632         payable
633         returns (uint[] memory amounts);
634 
635     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
636     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
637     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
638     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
639     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
640 }
641 
642 interface IUniswapV2Router02 is IUniswapV2Router01 {
643     function removeLiquidityETHSupportingFeeOnTransferTokens(
644         address token,
645         uint liquidity,
646         uint amountTokenMin,
647         uint amountETHMin,
648         address to,
649         uint deadline
650     ) external returns (uint amountETH);
651     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
652         address token,
653         uint liquidity,
654         uint amountTokenMin,
655         uint amountETHMin,
656         address to,
657         uint deadline,
658         bool approveMax, uint8 v, bytes32 r, bytes32 s
659     ) external returns (uint amountETH);
660 
661     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
662         uint amountIn,
663         uint amountOutMin,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external;
668     function swapExactETHForTokensSupportingFeeOnTransferTokens(
669         uint amountOutMin,
670         address[] calldata path,
671         address to,
672         uint deadline
673     ) external payable;
674     function swapExactTokensForETHSupportingFeeOnTransferTokens(
675         uint amountIn,
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external;
681 }
682 
683 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
684   using SafeMath for uint256;
685   using SafeMathUint for uint256;
686   using SafeMathInt for int256;
687 
688   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
689   // For more discussion about choosing the value of `magnitude`,
690   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
691   uint256 constant internal magnitude = 2**128;
692 
693   mapping(address => uint256) internal magnifiedDividendPerShare;
694   address[] public rewardTokens;
695   address public nextRewardToken;
696   uint256 public rewardTokenCounter;
697   
698   IUniswapV2Router02 public immutable uniswapV2Router;
699   
700   
701   // About dividendCorrection:
702   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
703   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
704   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
705   //   `dividendOf(_user)` should not be changed,
706   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
707   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
708   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
709   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
710   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
711   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
712   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
713   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
714   
715   mapping (address => uint256) public holderBalance;
716   uint256 public totalBalance;
717 
718   mapping(address => uint256) public totalDividendsDistributed;
719   
720   constructor(){
721       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
722       uniswapV2Router = _uniswapV2Router; 
723       
724       // Mainnet
725 
726       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC - 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
727       
728       nextRewardToken = rewardTokens[0];
729   }
730 
731   
732 
733   /// @dev Distributes dividends whenever ether is paid to this contract.
734   receive() external payable {
735     distributeDividends();
736   }
737 
738   /// @notice Distributes ether to token holders as dividends.
739   /// @dev It reverts if the total supply of tokens is 0.
740   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
741   /// About undistributed ether:
742   ///   In each distribution, there is a small amount of ether not distributed,
743   ///     the magnified amount of which is
744   ///     `(msg.value * magnitude) % totalSupply()`.
745   ///   With a well-chosen `magnitude`, the amount of undistributed ether
746   ///     (de-magnified) in a distribution can be less than 1 wei.
747   ///   We can actually keep track of the undistributed ether in a distribution
748   ///     and try to distribute it in the next distribution,
749   ///     but keeping track of such data on-chain costs much more than
750   ///     the saved ether, so we don't do that.
751     
752   function distributeDividends() public override payable { 
753     require(totalBalance > 0);
754     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
755     buyTokens(msg.value, nextRewardToken);
756     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
757     if (newBalance > 0) {
758       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
759         (newBalance).mul(magnitude) / totalBalance
760       );
761       emit DividendsDistributed(msg.sender, newBalance);
762 
763       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
764     }
765     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
766     nextRewardToken = rewardTokens[rewardTokenCounter];
767   }
768   
769   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
770     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
771         // generate the uniswap pair path of weth -> eth
772         address[] memory path = new address[](2);
773         path[0] = uniswapV2Router.WETH();
774         path[1] = rewardToken;
775 
776         // make the swap
777         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
778             0, // accept any amount of Ethereum
779             path,
780             address(this),
781             block.timestamp
782         );
783     }
784   
785   /// @notice Withdraws the ether distributed to the sender.
786   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
787   function withdrawDividend(address _rewardToken) external virtual override {
788     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
789   }
790 
791   /// @notice Withdraws the ether distributed to the sender.
792   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
793   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
794     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
795     if (_withdrawableDividend > 0) {
796       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
797       emit DividendWithdrawn(user, _withdrawableDividend);
798       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
799       return _withdrawableDividend;
800     }
801 
802     return 0;
803   }
804 
805 
806   /// @notice View the amount of dividend in wei that an address can withdraw.
807   /// @param _owner The address of a token holder.
808   /// @return The amount of dividend in wei that `_owner` can withdraw.
809   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
810     return withdrawableDividendOf(_owner, _rewardToken);
811   }
812 
813   /// @notice View the amount of dividend in wei that an address can withdraw.
814   /// @param _owner The address of a token holder.
815   /// @return The amount of dividend in wei that `_owner` can withdraw.
816   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
817     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
818   }
819 
820   /// @notice View the amount of dividend in wei that an address has withdrawn.
821   /// @param _owner The address of a token holder.
822   /// @return The amount of dividend in wei that `_owner` has withdrawn.
823   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
824     return withdrawnDividends[_owner][_rewardToken];
825   }
826 
827 
828   /// @notice View the amount of dividend in wei that an address has earned in total.
829   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
830   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
831   /// @param _owner The address of a token holder.
832   /// @return The amount of dividend in wei that `_owner` has earned in total.
833   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
834     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
835       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
836   }
837 
838   /// @dev Internal function that increases tokens to an account.
839   /// Update magnifiedDividendCorrections to keep dividends unchanged.
840   /// @param account The account that will receive the created tokens.
841   /// @param value The amount that will be created.
842   function _increase(address account, uint256 value) internal {
843     for (uint256 i; i < rewardTokens.length; i++){
844         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
845           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
846     }
847   }
848 
849   /// @dev Internal function that reduces an amount of the token of a given account.
850   /// Update magnifiedDividendCorrections to keep dividends unchanged.
851   /// @param account The account whose tokens will be burnt.
852   /// @param value The amount that will be burnt.
853   function _reduce(address account, uint256 value) internal {
854       for (uint256 i; i < rewardTokens.length; i++){
855         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
856           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
857       }
858   }
859 
860   function _setBalance(address account, uint256 newBalance) internal {
861     uint256 currentBalance = holderBalance[account];
862     holderBalance[account] = newBalance;
863     if(newBalance > currentBalance) {
864       uint256 increaseAmount = newBalance.sub(currentBalance);
865       _increase(account, increaseAmount);
866       totalBalance += increaseAmount;
867     } else if(newBalance < currentBalance) {
868       uint256 reduceAmount = currentBalance.sub(newBalance);
869       _reduce(account, reduceAmount);
870       totalBalance -= reduceAmount;
871     }
872   }
873 }
874 
875 contract DividendTracker is DividendPayingToken {
876     using SafeMath for uint256;
877     using SafeMathInt for int256;
878 
879     struct Map {
880         address[] keys;
881         mapping(address => uint) values;
882         mapping(address => uint) indexOf;
883         mapping(address => bool) inserted;
884     }
885 
886     function get(address key) private view returns (uint) {
887         return tokenHoldersMap.values[key];
888     }
889 
890     function getIndexOfKey(address key) private view returns (int) {
891         if(!tokenHoldersMap.inserted[key]) {
892             return -1;
893         }
894         return int(tokenHoldersMap.indexOf[key]);
895     }
896 
897     function getKeyAtIndex(uint index) private view returns (address) {
898         return tokenHoldersMap.keys[index];
899     }
900 
901 
902 
903     function size() private view returns (uint) {
904         return tokenHoldersMap.keys.length;
905     }
906 
907     function set(address key, uint val) private {
908         if (tokenHoldersMap.inserted[key]) {
909             tokenHoldersMap.values[key] = val;
910         } else {
911             tokenHoldersMap.inserted[key] = true;
912             tokenHoldersMap.values[key] = val;
913             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
914             tokenHoldersMap.keys.push(key);
915         }
916     }
917 
918     function remove(address key) private {
919         if (!tokenHoldersMap.inserted[key]) {
920             return;
921         }
922 
923         delete tokenHoldersMap.inserted[key];
924         delete tokenHoldersMap.values[key];
925 
926         uint index = tokenHoldersMap.indexOf[key];
927         uint lastIndex = tokenHoldersMap.keys.length - 1;
928         address lastKey = tokenHoldersMap.keys[lastIndex];
929 
930         tokenHoldersMap.indexOf[lastKey] = index;
931         delete tokenHoldersMap.indexOf[key];
932 
933         tokenHoldersMap.keys[index] = lastKey;
934         tokenHoldersMap.keys.pop();
935     }
936 
937     Map private tokenHoldersMap;
938     uint256 public lastProcessedIndex;
939 
940     mapping (address => bool) public excludedFromDividends;
941 
942     mapping (address => uint256) public lastClaimTimes;
943 
944     uint256 public claimWait;
945     uint256 public immutable minimumTokenBalanceForDividends;
946 
947     event ExcludeFromDividends(address indexed account);
948     event IncludeInDividends(address indexed account);
949     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
950 
951     event Claim(address indexed account, uint256 amount, bool indexed automatic);
952 
953     constructor() {
954     	claimWait = 1200;
955         minimumTokenBalanceForDividends = 1000 * (10**18);
956     }
957 
958     function excludeFromDividends(address account) external onlyOwner {
959     	excludedFromDividends[account] = true;
960 
961     	_setBalance(account, 0);
962     	remove(account);
963 
964     	emit ExcludeFromDividends(account);
965     }
966     
967     function includeInDividends(address account) external onlyOwner {
968     	require(excludedFromDividends[account]);
969     	excludedFromDividends[account] = false;
970 
971     	emit IncludeInDividends(account);
972     }
973 
974     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
975         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
976         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
977         emit ClaimWaitUpdated(newClaimWait, claimWait);
978         claimWait = newClaimWait;
979     }
980 
981     function getLastProcessedIndex() external view returns(uint256) {
982     	return lastProcessedIndex;
983     }
984 
985     function getNumberOfTokenHolders() external view returns(uint256) {
986         return tokenHoldersMap.keys.length;
987     }
988 
989     // Check to see if I really made this contract or if it is a clone!
990 
991     function getAccount(address _account, address _rewardToken)
992         public view returns (
993             address account,
994             int256 index,
995             int256 iterationsUntilProcessed,
996             uint256 withdrawableDividends,
997             uint256 totalDividends,
998             uint256 lastClaimTime,
999             uint256 nextClaimTime,
1000             uint256 secondsUntilAutoClaimAvailable) {
1001         account = _account;
1002 
1003         index = getIndexOfKey(account);
1004 
1005         iterationsUntilProcessed = -1;
1006 
1007         if(index >= 0) {
1008             if(uint256(index) > lastProcessedIndex) {
1009                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1010             }
1011             else {
1012                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1013                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1014                                                         0;
1015 
1016 
1017                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1018             }
1019         }
1020 
1021 
1022         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1023         totalDividends = accumulativeDividendOf(account, _rewardToken);
1024 
1025         lastClaimTime = lastClaimTimes[account];
1026 
1027         nextClaimTime = lastClaimTime > 0 ?
1028                                     lastClaimTime.add(claimWait) :
1029                                     0;
1030 
1031         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1032                                                     nextClaimTime.sub(block.timestamp) :
1033                                                     0;
1034     }
1035 
1036     function getAccountAtIndex(uint256 index, address _rewardToken)
1037         external view returns (
1038             address,
1039             int256,
1040             int256,
1041             uint256,
1042             uint256,
1043             uint256,
1044             uint256,
1045             uint256) {
1046     	if(index >= size()) {
1047             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1048         }
1049 
1050         address account = getKeyAtIndex(index);
1051 
1052         return getAccount(account, _rewardToken);
1053     }
1054 
1055     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1056     	if(lastClaimTime > block.timestamp)  {
1057     		return false;
1058     	}
1059 
1060     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1061     }
1062 
1063     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1064     	if(excludedFromDividends[account]) {
1065     		return;
1066     	}
1067 
1068     	if(newBalance >= minimumTokenBalanceForDividends) {
1069             _setBalance(account, newBalance);
1070     		set(account, newBalance);
1071     	}
1072     	else {
1073             _setBalance(account, 0);
1074     		remove(account);
1075     	}
1076 
1077     	processAccount(account, true);
1078     }
1079     
1080     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1081     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1082 
1083     	if(numberOfTokenHolders == 0) {
1084     		return (0, 0, lastProcessedIndex);
1085     	}
1086 
1087     	uint256 _lastProcessedIndex = lastProcessedIndex;
1088 
1089     	uint256 gasUsed = 0;
1090 
1091     	uint256 gasLeft = gasleft();
1092 
1093     	uint256 iterations = 0;
1094     	uint256 claims = 0;
1095 
1096     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1097     		_lastProcessedIndex++;
1098 
1099     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1100     			_lastProcessedIndex = 0;
1101     		}
1102 
1103     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1104 
1105     		if(canAutoClaim(lastClaimTimes[account])) {
1106     			if(processAccount(payable(account), true)) {
1107     				claims++;
1108     			}
1109     		}
1110 
1111     		iterations++;
1112 
1113     		uint256 newGasLeft = gasleft();
1114 
1115     		if(gasLeft > newGasLeft) {
1116     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1117     		}
1118     		gasLeft = newGasLeft;
1119     	}
1120 
1121     	lastProcessedIndex = _lastProcessedIndex;
1122 
1123     	return (iterations, claims, lastProcessedIndex);
1124     }
1125 
1126     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1127         uint256 amount;
1128         bool paid;
1129         for (uint256 i; i < rewardTokens.length; i++){
1130             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1131             if(amount > 0) {
1132         		lastClaimTimes[account] = block.timestamp;
1133                 emit Claim(account, amount, automatic);
1134                 paid = true;
1135     	    }
1136         }
1137         return paid;
1138     }
1139 }
1140 
1141 contract MobyDickV2 is ERC20, Ownable {
1142     using SafeMath for uint256;
1143 
1144     IUniswapV2Router02 public immutable uniswapV2Router;
1145     address public immutable uniswapV2Pair;
1146 
1147     bool private swapping;
1148 
1149     DividendTracker public dividendTracker;
1150 
1151     address public operationsWallet;
1152     
1153     uint256 public maxTransactionAmount;
1154     uint256 public swapTokensAtAmount;
1155     uint256 public maxWallet;
1156     
1157     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1158     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1159     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1160     
1161     bool public limitsInEffect = true;
1162     bool public tradingActive = false;
1163     bool public swapEnabled = false;
1164     
1165      // Anti-bot and anti-whale mappings and variables
1166     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1167     bool public transferDelayEnabled = true;
1168     
1169     uint256 public constant feeDivisor = 1000;
1170 
1171     uint256 public totalSellFees;
1172     uint256 public rewardsSellFee;
1173     uint256 public operationsSellFee;
1174     uint256 public liquiditySellFee;
1175     
1176     uint256 public totalBuyFees;
1177     uint256 public rewardsBuyFee;
1178     uint256 public operationsBuyFee;
1179     uint256 public liquidityBuyFee;
1180     
1181     uint256 public tokensForRewards;
1182     uint256 public tokensForOperations;
1183     uint256 public tokensForLiquidity;
1184     
1185     uint256 public gasForProcessing = 0;
1186 
1187     uint256 public lpWithdrawRequestTimestamp;
1188     uint256 public lpWithdrawRequestDuration = 3 days;
1189     bool public lpWithdrawRequestPending;
1190     uint256 public lpPercToWithDraw;
1191 
1192     /******************/
1193 
1194     // exlcude from fees and max transaction amount
1195     mapping (address => bool) private _isExcludedFromFees;
1196 
1197     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1198 
1199     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1200     // could be subject to a maximum transfer amount
1201     mapping (address => bool) public automatedMarketMakerPairs;
1202 
1203     event ExcludeFromFees(address indexed account, bool isExcluded);
1204     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1205     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1206 
1207     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1208 
1209     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1210 
1211     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1212 
1213     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1214     
1215     event SwapAndLiquify(
1216         uint256 tokensSwapped,
1217         uint256 ethReceived,
1218         uint256 tokensIntoLiqudity
1219     );
1220 
1221     event SendDividends(
1222     	uint256 tokensSwapped,
1223     	uint256 amount
1224     );
1225 
1226     event ProcessedDividendTracker(
1227     	uint256 iterations,
1228     	uint256 claims,
1229         uint256 lastProcessedIndex,
1230     	bool indexed automatic,
1231     	uint256 gas,
1232     	address indexed processor
1233     );
1234 
1235     event RequestedLPWithdraw();
1236     
1237     event WithdrewLPForMigration();
1238 
1239     event CanceledLpWithdrawRequest();
1240 
1241     constructor() ERC20("Moby Dick 2.0", "WHALEv2") {
1242 
1243         uint256 totalSupply = 100 * 1e9 * 1e18;
1244         
1245         maxTransactionAmount = totalSupply * 15 / 1000; // 1.5% maxTransactionAmountTxn
1246         swapTokensAtAmount = totalSupply * 15 / 10000; // 0.15% swap tokens amount
1247         maxWallet = totalSupply * 15 / 1000; // 1.5% Max wallet
1248 
1249         rewardsBuyFee = 30;
1250         operationsBuyFee = 50;
1251         liquidityBuyFee = 0;
1252         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1253         
1254         rewardsSellFee = 30;
1255         operationsSellFee = 50;
1256         liquiditySellFee = 0;
1257         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1258 
1259     	dividendTracker = new DividendTracker();
1260     	
1261     	operationsWallet = address(msg.sender); // set as operations wallet
1262 
1263     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1264     	
1265          // Create a uniswap pair for this new token
1266         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1267             .createPair(address(this), _uniswapV2Router.WETH());
1268 
1269         uniswapV2Router = _uniswapV2Router;
1270         uniswapV2Pair = _uniswapV2Pair;
1271 
1272         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1273 
1274         // exclude from receiving dividends
1275         dividendTracker.excludeFromDividends(address(dividendTracker));
1276         dividendTracker.excludeFromDividends(address(this));
1277         dividendTracker.excludeFromDividends(owner());
1278         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1279         dividendTracker.excludeFromDividends(address(0xdead));
1280         
1281         // exclude from paying fees or having max transaction amount
1282         excludeFromFees(owner(), true);
1283         excludeFromFees(address(this), true);
1284         excludeFromFees(address(0xdead), true);
1285         excludeFromMaxTransaction(owner(), true);
1286         excludeFromMaxTransaction(address(this), true);
1287         excludeFromMaxTransaction(address(dividendTracker), true);
1288         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1289         excludeFromMaxTransaction(address(0xdead), true);
1290 
1291         _createInitialSupply(address(owner()), totalSupply);
1292     }
1293 
1294     receive() external payable {
1295 
1296   	}
1297 
1298     // only use if conducting a presale
1299     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1300         excludeFromFees(_presaleAddress, true);
1301         dividendTracker.excludeFromDividends(_presaleAddress);
1302         excludeFromMaxTransaction(_presaleAddress, true);
1303     }
1304 
1305      // disable Transfer delay - cannot be reenabled
1306     function disableTransferDelay() external onlyOwner returns (bool){
1307         transferDelayEnabled = false;
1308         return true;
1309     }
1310 
1311     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1312     function excludeFromDividends(address account) external onlyOwner {
1313         dividendTracker.excludeFromDividends(account);
1314     }
1315 
1316     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1317     function includeInDividends(address account) external onlyOwner {
1318         dividendTracker.includeInDividends(account);
1319     }
1320     
1321     // once enabled, can never be turned off
1322     function enableTrading() external onlyOwner {
1323         require(!tradingActive, "Cannot re-enable trading");
1324         tradingActive = true;
1325         swapEnabled = true;
1326         tradingActiveBlock = block.number;
1327     }
1328     
1329     // only use to disable contract sales if absolutely necessary (emergency use only)
1330     function updateSwapEnabled(bool enabled) external onlyOwner(){
1331         swapEnabled = enabled;
1332     }
1333 
1334     function updateMaxAmount(uint256 newNum) external onlyOwner {
1335         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1336         maxTransactionAmount = newNum * (10**18);
1337     }
1338     
1339     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1340         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1341         maxWallet = newNum * (10**18);
1342     }
1343     
1344     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1345         operationsBuyFee = _operationsFee;
1346         rewardsBuyFee = _rewardsFee;
1347         liquidityBuyFee = _liquidityFee;
1348         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1349         require(totalBuyFees <= 250, "Must keep fees at 25% or less");
1350     }
1351     
1352     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1353         operationsSellFee = _operationsFee;
1354         rewardsSellFee = _rewardsFee;
1355         liquiditySellFee = _liquidityFee;
1356         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1357         require(totalSellFees <= 250, "Must keep fees at 25% or less");
1358     }
1359 
1360     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1361         _isExcludedMaxTransactionAmount[updAds] = isEx;
1362         emit ExcludedMaxTransactionAmount(updAds, isEx);
1363     }
1364 
1365     function excludeFromFees(address account, bool excluded) public onlyOwner {
1366         _isExcludedFromFees[account] = excluded;
1367 
1368         emit ExcludeFromFees(account, excluded);
1369     }
1370 
1371     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1372         for(uint256 i = 0; i < accounts.length; i++) {
1373             _isExcludedFromFees[accounts[i]] = excluded;
1374         }
1375 
1376         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1377     }
1378 
1379     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1380         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1381 
1382         _setAutomatedMarketMakerPair(pair, value);
1383     }
1384 
1385     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1386         automatedMarketMakerPairs[pair] = value;
1387 
1388         excludeFromMaxTransaction(pair, value);
1389         
1390         if(value) {
1391             dividendTracker.excludeFromDividends(pair);
1392         }
1393 
1394         emit SetAutomatedMarketMakerPair(pair, value);
1395     }
1396 
1397     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1398         require(newOperationsWallet != address(0), "may not set to 0 address");
1399         excludeFromFees(newOperationsWallet, true);
1400         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1401         operationsWallet = newOperationsWallet;
1402     }
1403 
1404     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1405         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1406         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1407         emit GasForProcessingUpdated(newValue, gasForProcessing);
1408         gasForProcessing = newValue;
1409     }
1410 
1411     function updateClaimWait(uint256 claimWait) external onlyOwner {
1412         dividendTracker.updateClaimWait(claimWait);
1413     }
1414 
1415     function getClaimWait() external view returns(uint256) {
1416         return dividendTracker.claimWait();
1417     }
1418 
1419     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1420         return dividendTracker.totalDividendsDistributed(rewardToken);
1421     }
1422 
1423     function isExcludedFromFees(address account) external view returns(bool) {
1424         return _isExcludedFromFees[account];
1425     }
1426 
1427     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1428     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1429   	}
1430 
1431 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1432 		return dividendTracker.holderBalance(account);
1433 	}
1434 
1435     function getAccountDividendsInfo(address account, address rewardToken)
1436         external view returns (
1437             address,
1438             int256,
1439             int256,
1440             uint256,
1441             uint256,
1442             uint256,
1443             uint256,
1444             uint256) {
1445         return dividendTracker.getAccount(account, rewardToken);
1446     }
1447 
1448 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1449         external view returns (
1450             address,
1451             int256,
1452             int256,
1453             uint256,
1454             uint256,
1455             uint256,
1456             uint256,
1457             uint256) {
1458     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1459     }
1460 
1461 	function processDividendTracker(uint256 gas) external {
1462 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1463 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1464     }
1465 
1466     function claim() external {
1467 		dividendTracker.processAccount(payable(msg.sender), false);
1468     }
1469 
1470     function getLastProcessedIndex() external view returns(uint256) {
1471     	return dividendTracker.getLastProcessedIndex();
1472     }
1473 
1474     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1475         return dividendTracker.getNumberOfTokenHolders();
1476     }
1477     
1478     function getNumberOfDividends() external view returns(uint256) {
1479         return dividendTracker.totalBalance();
1480     }
1481     
1482     // remove limits after token is stable
1483     function removeLimits() external onlyOwner returns (bool){
1484         limitsInEffect = false;
1485         transferDelayEnabled = false;
1486         return true;
1487     }
1488     
1489     function _transfer(
1490         address from,
1491         address to,
1492         uint256 amount
1493     ) internal override {
1494         require(from != address(0), "ERC20: transfer from the zero address");
1495         require(to != address(0), "ERC20: transfer to the zero address");
1496         
1497          if(amount == 0) {
1498             super._transfer(from, to, 0);
1499             return;
1500         }
1501         
1502         if(!tradingActive){
1503             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1504         }
1505         
1506         if(limitsInEffect){
1507             if (
1508                 from != owner() &&
1509                 to != owner() &&
1510                 to != address(0) &&
1511                 to != address(0xdead) &&
1512                 !swapping
1513             ){
1514 
1515                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1516                 if (transferDelayEnabled){
1517                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1518                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1519                         _holderLastTransferTimestamp[tx.origin] = block.number;
1520                     }
1521                 }
1522                 
1523                 //when buy
1524                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1525                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1526                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1527                 } 
1528                 //when sell
1529                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1530                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1531                 }
1532                 else if(!_isExcludedMaxTransactionAmount[to]) {
1533                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1534                 }
1535             }
1536         }
1537 
1538 		uint256 contractTokenBalance = balanceOf(address(this));
1539         
1540         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1541 
1542         if( 
1543             canSwap &&
1544             swapEnabled &&
1545             !swapping &&
1546             !automatedMarketMakerPairs[from] &&
1547             !_isExcludedFromFees[from] &&
1548             !_isExcludedFromFees[to]
1549         ) {
1550             swapping = true;
1551             swapBack();
1552             swapping = false;
1553         }
1554 
1555         bool takeFee = !swapping;
1556 
1557         // if any account belongs to _isExcludedFromFee account then remove the fee
1558         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1559             takeFee = false;
1560         }
1561         
1562         uint256 fees = 0;
1563         
1564         // no taxes on transfers (non buys/sells)
1565         if(takeFee){
1566             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1567                 fees = amount.mul(99).div(100);
1568                 tokensForLiquidity += fees * 33 / 99;
1569                 tokensForRewards += fees * 33 / 99;
1570                 tokensForOperations += fees * 33 / 99;
1571             }
1572 
1573             // on sell
1574             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1575                 fees = amount.mul(totalSellFees).div(feeDivisor);
1576                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1577                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1578                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1579             }
1580             
1581             // on buy
1582             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1583         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1584         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1585                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1586                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1587             }
1588 
1589             if(fees > 0){    
1590                 super._transfer(from, address(this), fees);
1591             }
1592         	
1593         	amount -= fees;
1594         }
1595 
1596         super._transfer(from, to, amount);
1597 
1598         dividendTracker.setBalance(payable(from), balanceOf(from));
1599         dividendTracker.setBalance(payable(to), balanceOf(to));
1600 
1601         if(!swapping && gasForProcessing > 0) {
1602 	    	uint256 gas = gasForProcessing;
1603 
1604 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1605 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1606 	    	}
1607 	    	catch {}
1608         }
1609     }
1610     
1611     function swapTokensForEth(uint256 tokenAmount) private {
1612 
1613         // generate the uniswap pair path of token -> weth
1614         address[] memory path = new address[](2);
1615         path[0] = address(this);
1616         path[1] = uniswapV2Router.WETH();
1617 
1618         _approve(address(this), address(uniswapV2Router), tokenAmount);
1619 
1620         // make the swap
1621         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1622             tokenAmount,
1623             0, // accept any amount of ETH
1624             path,
1625             address(this),
1626             block.timestamp
1627         );
1628         
1629     }
1630     
1631     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1632         // approve token transfer to cover all possible scenarios
1633         _approve(address(this), address(uniswapV2Router), tokenAmount);
1634 
1635         // add the liquidity
1636         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1637             address(this),
1638             tokenAmount,
1639             0, // slippage is unavoidable
1640             0, // slippage is unavoidable
1641             address(0xdead),
1642             block.timestamp
1643         );
1644 
1645     }
1646     
1647     function swapBack() private {
1648         uint256 contractBalance = balanceOf(address(this));
1649         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1650         
1651         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1652         
1653         // Halve the amount of liquidity tokens
1654         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1655         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1656         
1657         uint256 initialETHBalance = address(this).balance;
1658 
1659         swapTokensForEth(amountToSwapForETH); 
1660         
1661         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1662         
1663         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1664         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1665         
1666         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1667         
1668         tokensForLiquidity = 0;
1669         tokensForOperations = 0;
1670         tokensForRewards = 0;
1671         
1672         
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