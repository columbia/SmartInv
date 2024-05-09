1 // http://t.me/bitcoin_inu
2 
3 // SPDX-License-Identifier: MIT                                                                               
4 pragma solidity 0.8.13;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IUniswapV2Factory {
18     function createPair(address tokenA, address tokenB) external returns (address pair);
19 }
20 
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 interface IERC20Metadata is IERC20 {
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() external view returns (string memory);
101 
102     /**
103      * @dev Returns the symbol of the token.
104      */
105     function symbol() external view returns (string memory);
106 
107     /**
108      * @dev Returns the decimals places of the token.
109      */
110     function decimals() external view returns (uint8);
111 }
112 
113 
114 contract ERC20 is Context, IERC20, IERC20Metadata {
115     mapping(address => uint256) private _balances;
116 
117     mapping(address => mapping(address => uint256)) private _allowances;
118 
119     uint256 private _totalSupply;
120 
121     string private _name;
122     string private _symbol;
123 
124     constructor(string memory name_, string memory symbol_) {
125         _name = name_;
126         _symbol = symbol_;
127     }
128 
129     function name() public view virtual override returns (string memory) {
130         return _name;
131     }
132 
133     function symbol() public view virtual override returns (string memory) {
134         return _symbol;
135     }
136 
137     function decimals() public view virtual override returns (uint8) {
138         return 18;
139     }
140 
141     function totalSupply() public view virtual override returns (uint256) {
142         return _totalSupply;
143     }
144 
145     function balanceOf(address account) public view virtual override returns (uint256) {
146         return _balances[account];
147     }
148 
149     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
150         _transfer(_msgSender(), recipient, amount);
151         return true;
152     }
153 
154     function allowance(address owner, address spender) public view virtual override returns (uint256) {
155         return _allowances[owner][spender];
156     }
157 
158     function approve(address spender, uint256 amount) public virtual override returns (bool) {
159         _approve(_msgSender(), spender, amount);
160         return true;
161     }
162 
163     function transferFrom(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) public virtual override returns (bool) {
168         _transfer(sender, recipient, amount);
169 
170         uint256 currentAllowance = _allowances[sender][_msgSender()];
171         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
172         unchecked {
173             _approve(sender, _msgSender(), currentAllowance - amount);
174         }
175 
176         return true;
177     }
178 
179     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
180         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
181         return true;
182     }
183 
184     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
185         uint256 currentAllowance = _allowances[_msgSender()][spender];
186         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
187         unchecked {
188             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
189         }
190 
191         return true;
192     }
193 
194     function _transfer(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) internal virtual {
199         require(sender != address(0), "ERC20: transfer from the zero address");
200         require(recipient != address(0), "ERC20: transfer to the zero address");
201 
202         uint256 senderBalance = _balances[sender];
203         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
204         unchecked {
205             _balances[sender] = senderBalance - amount;
206         }
207         _balances[recipient] += amount;
208 
209         emit Transfer(sender, recipient, amount);
210     }
211 
212     function _createInitialSupply(address account, uint256 amount) internal virtual {
213         require(account != address(0), "ERC20: mint to the zero address");
214         _totalSupply += amount;
215         _balances[account] += amount;
216         emit Transfer(address(0), account, amount);
217     }
218 
219     function _approve(
220         address owner,
221         address spender,
222         uint256 amount
223     ) internal virtual {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226 
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 }
231 
232 interface DividendPayingTokenOptionalInterface {
233   /// @notice View the amount of dividend in wei that an address can withdraw.
234   /// @param _owner The address of a token holder.
235   /// @return The amount of dividend in wei that `_owner` can withdraw.
236   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
237 
238   /// @notice View the amount of dividend in wei that an address has withdrawn.
239   /// @param _owner The address of a token holder.
240   /// @return The amount of dividend in wei that `_owner` has withdrawn.
241   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
242 
243   /// @notice View the amount of dividend in wei that an address has earned in total.
244   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
245   /// @param _owner The address of a token holder.
246   /// @return The amount of dividend in wei that `_owner` has earned in total.
247   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
248 }
249 
250 interface DividendPayingTokenInterface {
251   /// @notice View the amount of dividend in wei that an address can withdraw.
252   /// @param _owner The address of a token holder.
253   /// @return The amount of dividend in wei that `_owner` can withdraw.
254   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
255 
256   /// @notice Distributes ether to token holders as dividends.
257   /// @dev SHOULD distribute the paid ether to token holders as dividends.
258   ///  SHOULD NOT directly transfer ether to token holders in this function.
259   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
260   function distributeDividends() external payable;
261 
262   /// @notice Withdraws the ether distributed to the sender.
263   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
264   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
265   function withdrawDividend(address _rewardToken) external;
266 
267   /// @dev This event MUST emit when ether is distributed to token holders.
268   /// @param from The address which sends ether to this contract.
269   /// @param weiAmount The amount of distributed ether in wei.
270   event DividendsDistributed(
271     address indexed from,
272     uint256 weiAmount
273   );
274 
275   /// @dev This event MUST emit when an address withdraws their dividend.
276   /// @param to The address which withdraws ether from this contract.
277   /// @param weiAmount The amount of withdrawn ether in wei.
278   event DividendWithdrawn(
279     address indexed to,
280     uint256 weiAmount
281   );
282 }
283 
284 library SafeMath {
285     /**
286      * @dev Returns the addition of two unsigned integers, reverting on
287      * overflow.
288      *
289      * Counterpart to Solidity's `+` operator.
290      *
291      * Requirements:
292      *
293      * - Addition cannot overflow.
294      */
295     function add(uint256 a, uint256 b) internal pure returns (uint256) {
296         uint256 c = a + b;
297         require(c >= a, "SafeMath: addition overflow");
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the subtraction of two unsigned integers, reverting on
304      * overflow (when the result is negative).
305      *
306      * Counterpart to Solidity's `-` operator.
307      *
308      * Requirements:
309      *
310      * - Subtraction cannot overflow.
311      */
312     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
313         return sub(a, b, "SafeMath: subtraction overflow");
314     }
315 
316     /**
317      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
318      * overflow (when the result is negative).
319      *
320      * Counterpart to Solidity's `-` operator.
321      *
322      * Requirements:
323      *
324      * - Subtraction cannot overflow.
325      */
326     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
327         require(b <= a, errorMessage);
328         uint256 c = a - b;
329 
330         return c;
331     }
332 
333     /**
334      * @dev Returns the multiplication of two unsigned integers, reverting on
335      * overflow.
336      *
337      * Counterpart to Solidity's `*` operator.
338      *
339      * Requirements:
340      *
341      * - Multiplication cannot overflow.
342      */
343     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
344         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
345         // benefit is lost if 'b' is also tested.
346         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
347         if (a == 0) {
348             return 0;
349         }
350 
351         uint256 c = a * b;
352         require(c / a == b, "SafeMath: multiplication overflow");
353 
354         return c;
355     }
356 
357     /**
358      * @dev Returns the integer division of two unsigned integers. Reverts on
359      * division by zero. The result is rounded towards zero.
360      *
361      * Counterpart to Solidity's `/` operator. Note: this function uses a
362      * `revert` opcode (which leaves remaining gas untouched) while Solidity
363      * uses an invalid opcode to revert (consuming all remaining gas).
364      *
365      * Requirements:
366      *
367      * - The divisor cannot be zero.
368      */
369     function div(uint256 a, uint256 b) internal pure returns (uint256) {
370         return div(a, b, "SafeMath: division by zero");
371     }
372 
373     /**
374      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
375      * division by zero. The result is rounded towards zero.
376      *
377      * Counterpart to Solidity's `/` operator. Note: this function uses a
378      * `revert` opcode (which leaves remaining gas untouched) while Solidity
379      * uses an invalid opcode to revert (consuming all remaining gas).
380      *
381      * Requirements:
382      *
383      * - The divisor cannot be zero.
384      */
385     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
386         require(b > 0, errorMessage);
387         uint256 c = a / b;
388         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
389 
390         return c;
391     }
392 
393     /**
394      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
395      * Reverts when dividing by zero.
396      *
397      * Counterpart to Solidity's `%` operator. This function uses a `revert`
398      * opcode (which leaves remaining gas untouched) while Solidity uses an
399      * invalid opcode to revert (consuming all remaining gas).
400      *
401      * Requirements:
402      *
403      * - The divisor cannot be zero.
404      */
405     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
406         return mod(a, b, "SafeMath: modulo by zero");
407     }
408 
409     /**
410      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
411      * Reverts with custom message when dividing by zero.
412      *
413      * Counterpart to Solidity's `%` operator. This function uses a `revert`
414      * opcode (which leaves remaining gas untouched) while Solidity uses an
415      * invalid opcode to revert (consuming all remaining gas).
416      *
417      * Requirements:
418      *
419      * - The divisor cannot be zero.
420      */
421     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
422         require(b != 0, errorMessage);
423         return a % b;
424     }
425 }
426 
427 contract Ownable is Context {
428     address private _owner;
429 
430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
431     
432     /**
433      * @dev Initializes the contract setting the deployer as the initial owner.
434      */
435     constructor () {
436         address msgSender = _msgSender();
437         _owner = msgSender;
438         emit OwnershipTransferred(address(0), msgSender);
439     }
440 
441     /**
442      * @dev Returns the address of the current owner.
443      */
444     function owner() public view returns (address) {
445         return _owner;
446     }
447 
448     /**
449      * @dev Throws if called by any account other than the owner.
450      */
451     modifier onlyOwner() {
452         require(_owner == _msgSender(), "Ownable: caller is not the owner");
453         _;
454     }
455 
456     /**
457      * @dev Leaves the contract without owner. It will not be possible to call
458      * `onlyOwner` functions anymore. Can only be called by the current owner.
459      *
460      * NOTE: Renouncing ownership will leave the contract without an owner,
461      * thereby removing any functionality that is only available to the owner.
462      */
463     function renounceOwnership() public virtual onlyOwner {
464         emit OwnershipTransferred(_owner, address(0));
465         _owner = address(0);
466     }
467 
468     /**
469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
470      * Can only be called by the current owner.
471      */
472     function transferOwnership(address newOwner) public virtual onlyOwner {
473         require(newOwner != address(0), "Ownable: new owner is the zero address");
474         emit OwnershipTransferred(_owner, newOwner);
475         _owner = newOwner;
476     }
477 }
478 
479 
480 
481 library SafeMathInt {
482     int256 private constant MIN_INT256 = int256(1) << 255;
483     int256 private constant MAX_INT256 = ~(int256(1) << 255);
484 
485     /**
486      * @dev Multiplies two int256 variables and fails on overflow.
487      */
488     function mul(int256 a, int256 b) internal pure returns (int256) {
489         int256 c = a * b;
490 
491         // Detect overflow when multiplying MIN_INT256 with -1
492         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
493         require((b == 0) || (c / b == a));
494         return c;
495     }
496 
497     /**
498      * @dev Division of two int256 variables and fails on overflow.
499      */
500     function div(int256 a, int256 b) internal pure returns (int256) {
501         // Prevent overflow when dividing MIN_INT256 by -1
502         require(b != -1 || a != MIN_INT256);
503 
504         // Solidity already throws when dividing by 0.
505         return a / b;
506     }
507 
508     /**
509      * @dev Subtracts two int256 variables and fails on overflow.
510      */
511     function sub(int256 a, int256 b) internal pure returns (int256) {
512         int256 c = a - b;
513         require((b >= 0 && c <= a) || (b < 0 && c > a));
514         return c;
515     }
516 
517     /**
518      * @dev Adds two int256 variables and fails on overflow.
519      */
520     function add(int256 a, int256 b) internal pure returns (int256) {
521         int256 c = a + b;
522         require((b >= 0 && c >= a) || (b < 0 && c < a));
523         return c;
524     }
525 
526     /**
527      * @dev Converts to absolute value, and fails on overflow.
528      */
529     function abs(int256 a) internal pure returns (int256) {
530         require(a != MIN_INT256);
531         return a < 0 ? -a : a;
532     }
533 
534 
535     function toUint256Safe(int256 a) internal pure returns (uint256) {
536         require(a >= 0);
537         return uint256(a);
538     }
539 }
540 
541 library SafeMathUint {
542   function toInt256Safe(uint256 a) internal pure returns (int256) {
543     int256 b = int256(a);
544     require(b >= 0);
545     return b;
546   }
547 }
548 
549 
550 interface IUniswapV2Router01 {
551     function factory() external pure returns (address);
552     function WETH() external pure returns (address);
553 
554     function addLiquidity(
555         address tokenA,
556         address tokenB,
557         uint amountADesired,
558         uint amountBDesired,
559         uint amountAMin,
560         uint amountBMin,
561         address to,
562         uint deadline
563     ) external returns (uint amountA, uint amountB, uint liquidity);
564     function addLiquidityETH(
565         address token,
566         uint amountTokenDesired,
567         uint amountTokenMin,
568         uint amountETHMin,
569         address to,
570         uint deadline
571     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
572     function removeLiquidity(
573         address tokenA,
574         address tokenB,
575         uint liquidity,
576         uint amountAMin,
577         uint amountBMin,
578         address to,
579         uint deadline
580     ) external returns (uint amountA, uint amountB);
581     function removeLiquidityETH(
582         address token,
583         uint liquidity,
584         uint amountTokenMin,
585         uint amountETHMin,
586         address to,
587         uint deadline
588     ) external returns (uint amountToken, uint amountETH);
589     function removeLiquidityWithPermit(
590         address tokenA,
591         address tokenB,
592         uint liquidity,
593         uint amountAMin,
594         uint amountBMin,
595         address to,
596         uint deadline,
597         bool approveMax, uint8 v, bytes32 r, bytes32 s
598     ) external returns (uint amountA, uint amountB);
599     function removeLiquidityETHWithPermit(
600         address token,
601         uint liquidity,
602         uint amountTokenMin,
603         uint amountETHMin,
604         address to,
605         uint deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint amountToken, uint amountETH);
608     function swapExactTokensForTokens(
609         uint amountIn,
610         uint amountOutMin,
611         address[] calldata path,
612         address to,
613         uint deadline
614     ) external returns (uint[] memory amounts);
615     function swapTokensForExactTokens(
616         uint amountOut,
617         uint amountInMax,
618         address[] calldata path,
619         address to,
620         uint deadline
621     ) external returns (uint[] memory amounts);
622     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
623         external
624         payable
625         returns (uint[] memory amounts);
626     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
627         external
628         returns (uint[] memory amounts);
629     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
630         external
631         returns (uint[] memory amounts);
632     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
633         external
634         payable
635         returns (uint[] memory amounts);
636 
637     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
638     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
639     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
640     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
641     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
642 }
643 
644 interface IUniswapV2Router02 is IUniswapV2Router01 {
645     function removeLiquidityETHSupportingFeeOnTransferTokens(
646         address token,
647         uint liquidity,
648         uint amountTokenMin,
649         uint amountETHMin,
650         address to,
651         uint deadline
652     ) external returns (uint amountETH);
653     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
654         address token,
655         uint liquidity,
656         uint amountTokenMin,
657         uint amountETHMin,
658         address to,
659         uint deadline,
660         bool approveMax, uint8 v, bytes32 r, bytes32 s
661     ) external returns (uint amountETH);
662 
663     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
664         uint amountIn,
665         uint amountOutMin,
666         address[] calldata path,
667         address to,
668         uint deadline
669     ) external;
670     function swapExactETHForTokensSupportingFeeOnTransferTokens(
671         uint amountOutMin,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external payable;
676     function swapExactTokensForETHSupportingFeeOnTransferTokens(
677         uint amountIn,
678         uint amountOutMin,
679         address[] calldata path,
680         address to,
681         uint deadline
682     ) external;
683 }
684 
685 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
686   using SafeMath for uint256;
687   using SafeMathUint for uint256;
688   using SafeMathInt for int256;
689 
690   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
691   // For more discussion about choosing the value of `magnitude`,
692   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
693   uint256 constant internal magnitude = 2**128;
694 
695   mapping(address => uint256) internal magnifiedDividendPerShare;
696   address[] public rewardTokens;
697   address public nextRewardToken;
698   uint256 public rewardTokenCounter;
699   
700   IUniswapV2Router02 public immutable uniswapV2Router;
701   
702   
703   // About dividendCorrection:
704   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
705   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
706   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
707   //   `dividendOf(_user)` should not be changed,
708   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
709   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
710   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
711   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
712   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
713   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
714   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
715   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
716   
717   mapping (address => uint256) public holderBalance;
718   uint256 public totalBalance;
719 
720   mapping(address => uint256) public totalDividendsDistributed;
721   
722   constructor(){
723       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
724       uniswapV2Router = _uniswapV2Router; 
725       
726       // Mainnet
727 
728       rewardTokens.push(address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599)); // WBTC - 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
729       
730       nextRewardToken = rewardTokens[0];
731   }
732 
733   
734 
735   /// @dev Distributes dividends whenever ether is paid to this contract.
736   receive() external payable {
737     distributeDividends();
738   }
739 
740   /// @notice Distributes ether to token holders as dividends.
741   /// @dev It reverts if the total supply of tokens is 0.
742   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
743   /// About undistributed ether:
744   ///   In each distribution, there is a small amount of ether not distributed,
745   ///     the magnified amount of which is
746   ///     `(msg.value * magnitude) % totalSupply()`.
747   ///   With a well-chosen `magnitude`, the amount of undistributed ether
748   ///     (de-magnified) in a distribution can be less than 1 wei.
749   ///   We can actually keep track of the undistributed ether in a distribution
750   ///     and try to distribute it in the next distribution,
751   ///     but keeping track of such data on-chain costs much more than
752   ///     the saved ether, so we don't do that.
753     
754   function distributeDividends() public override payable { 
755     require(totalBalance > 0);
756     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
757     buyTokens(msg.value, nextRewardToken);
758     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
759     if (newBalance > 0) {
760       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
761         (newBalance).mul(magnitude) / totalBalance
762       );
763       emit DividendsDistributed(msg.sender, newBalance);
764 
765       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
766     }
767     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
768     nextRewardToken = rewardTokens[rewardTokenCounter];
769   }
770   
771   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
772     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
773         // generate the uniswap pair path of weth -> eth
774         address[] memory path = new address[](2);
775         path[0] = uniswapV2Router.WETH();
776         path[1] = rewardToken;
777 
778         // make the swap
779         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
780             0, // accept any amount of Ethereum
781             path,
782             address(this),
783             block.timestamp
784         );
785     }
786   
787   /// @notice Withdraws the ether distributed to the sender.
788   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
789   function withdrawDividend(address _rewardToken) external virtual override {
790     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
791   }
792 
793   /// @notice Withdraws the ether distributed to the sender.
794   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
795   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
796     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
797     if (_withdrawableDividend > 0) {
798       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
799       emit DividendWithdrawn(user, _withdrawableDividend);
800       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
801       return _withdrawableDividend;
802     }
803 
804     return 0;
805   }
806 
807 
808   /// @notice View the amount of dividend in wei that an address can withdraw.
809   /// @param _owner The address of a token holder.
810   /// @return The amount of dividend in wei that `_owner` can withdraw.
811   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
812     return withdrawableDividendOf(_owner, _rewardToken);
813   }
814 
815   /// @notice View the amount of dividend in wei that an address can withdraw.
816   /// @param _owner The address of a token holder.
817   /// @return The amount of dividend in wei that `_owner` can withdraw.
818   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
819     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
820   }
821 
822   /// @notice View the amount of dividend in wei that an address has withdrawn.
823   /// @param _owner The address of a token holder.
824   /// @return The amount of dividend in wei that `_owner` has withdrawn.
825   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
826     return withdrawnDividends[_owner][_rewardToken];
827   }
828 
829 
830   /// @notice View the amount of dividend in wei that an address has earned in total.
831   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
832   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
833   /// @param _owner The address of a token holder.
834   /// @return The amount of dividend in wei that `_owner` has earned in total.
835   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
836     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
837       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
838   }
839 
840   /// @dev Internal function that increases tokens to an account.
841   /// Update magnifiedDividendCorrections to keep dividends unchanged.
842   /// @param account The account that will receive the created tokens.
843   /// @param value The amount that will be created.
844   function _increase(address account, uint256 value) internal {
845     for (uint256 i; i < rewardTokens.length; i++){
846         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
847           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
848     }
849   }
850 
851   /// @dev Internal function that reduces an amount of the token of a given account.
852   /// Update magnifiedDividendCorrections to keep dividends unchanged.
853   /// @param account The account whose tokens will be burnt.
854   /// @param value The amount that will be burnt.
855   function _reduce(address account, uint256 value) internal {
856       for (uint256 i; i < rewardTokens.length; i++){
857         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
858           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
859       }
860   }
861 
862   function _setBalance(address account, uint256 newBalance) internal {
863     uint256 currentBalance = holderBalance[account];
864     holderBalance[account] = newBalance;
865     if(newBalance > currentBalance) {
866       uint256 increaseAmount = newBalance.sub(currentBalance);
867       _increase(account, increaseAmount);
868       totalBalance += increaseAmount;
869     } else if(newBalance < currentBalance) {
870       uint256 reduceAmount = currentBalance.sub(newBalance);
871       _reduce(account, reduceAmount);
872       totalBalance -= reduceAmount;
873     }
874   }
875 }
876 
877 contract DividendTracker is DividendPayingToken {
878     using SafeMath for uint256;
879     using SafeMathInt for int256;
880 
881     struct Map {
882         address[] keys;
883         mapping(address => uint) values;
884         mapping(address => uint) indexOf;
885         mapping(address => bool) inserted;
886     }
887 
888     function get(address key) private view returns (uint) {
889         return tokenHoldersMap.values[key];
890     }
891 
892     function getIndexOfKey(address key) private view returns (int) {
893         if(!tokenHoldersMap.inserted[key]) {
894             return -1;
895         }
896         return int(tokenHoldersMap.indexOf[key]);
897     }
898 
899     function getKeyAtIndex(uint index) private view returns (address) {
900         return tokenHoldersMap.keys[index];
901     }
902 
903 
904 
905     function size() private view returns (uint) {
906         return tokenHoldersMap.keys.length;
907     }
908 
909     function set(address key, uint val) private {
910         if (tokenHoldersMap.inserted[key]) {
911             tokenHoldersMap.values[key] = val;
912         } else {
913             tokenHoldersMap.inserted[key] = true;
914             tokenHoldersMap.values[key] = val;
915             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
916             tokenHoldersMap.keys.push(key);
917         }
918     }
919 
920     function remove(address key) private {
921         if (!tokenHoldersMap.inserted[key]) {
922             return;
923         }
924 
925         delete tokenHoldersMap.inserted[key];
926         delete tokenHoldersMap.values[key];
927 
928         uint index = tokenHoldersMap.indexOf[key];
929         uint lastIndex = tokenHoldersMap.keys.length - 1;
930         address lastKey = tokenHoldersMap.keys[lastIndex];
931 
932         tokenHoldersMap.indexOf[lastKey] = index;
933         delete tokenHoldersMap.indexOf[key];
934 
935         tokenHoldersMap.keys[index] = lastKey;
936         tokenHoldersMap.keys.pop();
937     }
938 
939     Map private tokenHoldersMap;
940     uint256 public lastProcessedIndex;
941 
942     mapping (address => bool) public excludedFromDividends;
943 
944     mapping (address => uint256) public lastClaimTimes;
945 
946     uint256 public claimWait;
947     uint256 public immutable minimumTokenBalanceForDividends;
948 
949     event ExcludeFromDividends(address indexed account);
950     event IncludeInDividends(address indexed account);
951     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
952 
953     event Claim(address indexed account, uint256 amount, bool indexed automatic);
954 
955     constructor() {
956     	claimWait = 1200;
957         minimumTokenBalanceForDividends = 1000 * (10**18);
958     }
959 
960     function excludeFromDividends(address account) external onlyOwner {
961     	excludedFromDividends[account] = true;
962 
963     	_setBalance(account, 0);
964     	remove(account);
965 
966     	emit ExcludeFromDividends(account);
967     }
968     
969     function includeInDividends(address account) external onlyOwner {
970     	require(excludedFromDividends[account]);
971     	excludedFromDividends[account] = false;
972 
973     	emit IncludeInDividends(account);
974     }
975 
976     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
977         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
978         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
979         emit ClaimWaitUpdated(newClaimWait, claimWait);
980         claimWait = newClaimWait;
981     }
982 
983     function getLastProcessedIndex() external view returns(uint256) {
984     	return lastProcessedIndex;
985     }
986 
987     function getNumberOfTokenHolders() external view returns(uint256) {
988         return tokenHoldersMap.keys.length;
989     }
990 
991     // Check to see if I really made this contract or if it is a clone!
992 
993     function getAccount(address _account, address _rewardToken)
994         public view returns (
995             address account,
996             int256 index,
997             int256 iterationsUntilProcessed,
998             uint256 withdrawableDividends,
999             uint256 totalDividends,
1000             uint256 lastClaimTime,
1001             uint256 nextClaimTime,
1002             uint256 secondsUntilAutoClaimAvailable) {
1003         account = _account;
1004 
1005         index = getIndexOfKey(account);
1006 
1007         iterationsUntilProcessed = -1;
1008 
1009         if(index >= 0) {
1010             if(uint256(index) > lastProcessedIndex) {
1011                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1012             }
1013             else {
1014                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1015                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1016                                                         0;
1017 
1018 
1019                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1020             }
1021         }
1022 
1023 
1024         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1025         totalDividends = accumulativeDividendOf(account, _rewardToken);
1026 
1027         lastClaimTime = lastClaimTimes[account];
1028 
1029         nextClaimTime = lastClaimTime > 0 ?
1030                                     lastClaimTime.add(claimWait) :
1031                                     0;
1032 
1033         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1034                                                     nextClaimTime.sub(block.timestamp) :
1035                                                     0;
1036     }
1037 
1038     function getAccountAtIndex(uint256 index, address _rewardToken)
1039         external view returns (
1040             address,
1041             int256,
1042             int256,
1043             uint256,
1044             uint256,
1045             uint256,
1046             uint256,
1047             uint256) {
1048     	if(index >= size()) {
1049             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1050         }
1051 
1052         address account = getKeyAtIndex(index);
1053 
1054         return getAccount(account, _rewardToken);
1055     }
1056 
1057     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1058     	if(lastClaimTime > block.timestamp)  {
1059     		return false;
1060     	}
1061 
1062     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1063     }
1064 
1065     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1066     	if(excludedFromDividends[account]) {
1067     		return;
1068     	}
1069 
1070     	if(newBalance >= minimumTokenBalanceForDividends) {
1071             _setBalance(account, newBalance);
1072     		set(account, newBalance);
1073     	}
1074     	else {
1075             _setBalance(account, 0);
1076     		remove(account);
1077     	}
1078 
1079     	processAccount(account, true);
1080     }
1081     
1082     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1083     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1084 
1085     	if(numberOfTokenHolders == 0) {
1086     		return (0, 0, lastProcessedIndex);
1087     	}
1088 
1089     	uint256 _lastProcessedIndex = lastProcessedIndex;
1090 
1091     	uint256 gasUsed = 0;
1092 
1093     	uint256 gasLeft = gasleft();
1094 
1095     	uint256 iterations = 0;
1096     	uint256 claims = 0;
1097 
1098     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1099     		_lastProcessedIndex++;
1100 
1101     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1102     			_lastProcessedIndex = 0;
1103     		}
1104 
1105     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1106 
1107     		if(canAutoClaim(lastClaimTimes[account])) {
1108     			if(processAccount(payable(account), true)) {
1109     				claims++;
1110     			}
1111     		}
1112 
1113     		iterations++;
1114 
1115     		uint256 newGasLeft = gasleft();
1116 
1117     		if(gasLeft > newGasLeft) {
1118     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1119     		}
1120     		gasLeft = newGasLeft;
1121     	}
1122 
1123     	lastProcessedIndex = _lastProcessedIndex;
1124 
1125     	return (iterations, claims, lastProcessedIndex);
1126     }
1127 
1128     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1129         uint256 amount;
1130         bool paid;
1131         for (uint256 i; i < rewardTokens.length; i++){
1132             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1133             if(amount > 0) {
1134         		lastClaimTimes[account] = block.timestamp;
1135                 emit Claim(account, amount, automatic);
1136                 paid = true;
1137     	    }
1138         }
1139         return paid;
1140     }
1141 }
1142 
1143 contract BitcoinInu is ERC20, Ownable {
1144     using SafeMath for uint256;
1145 
1146     IUniswapV2Router02 public immutable uniswapV2Router;
1147     address public immutable uniswapV2Pair;
1148 
1149     bool private swapping;
1150 
1151     DividendTracker public dividendTracker;
1152 
1153     address public operationsWallet;
1154     
1155     uint256 public maxTransactionAmount;
1156     uint256 public swapTokensAtAmount;
1157     uint256 public maxWallet;
1158     
1159     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1160     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1161     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1162     
1163     bool public limitsInEffect = true;
1164     bool public tradingActive = false;
1165     bool public swapEnabled = false;
1166     
1167      // Anti-bot and anti-whale mappings and variables
1168     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1169     bool public transferDelayEnabled = true;
1170     
1171     uint256 public constant feeDivisor = 1000;
1172 
1173     uint256 public totalSellFees;
1174     uint256 public rewardsSellFee;
1175     uint256 public operationsSellFee;
1176     uint256 public liquiditySellFee;
1177     
1178     uint256 public totalBuyFees;
1179     uint256 public rewardsBuyFee;
1180     uint256 public operationsBuyFee;
1181     uint256 public liquidityBuyFee;
1182     
1183     uint256 public tokensForRewards;
1184     uint256 public tokensForOperations;
1185     uint256 public tokensForLiquidity;
1186     
1187     uint256 public gasForProcessing = 0;
1188 
1189     uint256 public lpWithdrawRequestTimestamp;
1190     uint256 public lpWithdrawRequestDuration = 3 days;
1191     bool public lpWithdrawRequestPending;
1192     uint256 public lpPercToWithDraw;
1193 
1194     /******************/
1195 
1196     // exlcude from fees and max transaction amount
1197     mapping (address => bool) private _isExcludedFromFees;
1198 
1199     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1200 
1201     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1202     // could be subject to a maximum transfer amount
1203     mapping (address => bool) public automatedMarketMakerPairs;
1204 
1205     event ExcludeFromFees(address indexed account, bool isExcluded);
1206     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1207     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1208 
1209     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1210 
1211     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1212 
1213     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1214 
1215     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1216     
1217     event SwapAndLiquify(
1218         uint256 tokensSwapped,
1219         uint256 ethReceived,
1220         uint256 tokensIntoLiqudity
1221     );
1222 
1223     event SendDividends(
1224     	uint256 tokensSwapped,
1225     	uint256 amount
1226     );
1227 
1228     event ProcessedDividendTracker(
1229     	uint256 iterations,
1230     	uint256 claims,
1231         uint256 lastProcessedIndex,
1232     	bool indexed automatic,
1233     	uint256 gas,
1234     	address indexed processor
1235     );
1236 
1237     event RequestedLPWithdraw();
1238     
1239     event WithdrewLPForMigration();
1240 
1241     event CanceledLpWithdrawRequest();
1242 
1243     constructor() ERC20("Bitcoin Inu", "BTCI") {
1244 
1245         uint256 totalSupply = 100_000_000 * 1e18;
1246 
1247         maxTransactionAmount = 2_000_000 * 1e18;
1248         maxWallet = 2_000_000 * 1e18;
1249         swapTokensAtAmount = (totalSupply * 20) / 10000;
1250 
1251         rewardsBuyFee = 10;
1252         operationsBuyFee = 30;
1253         liquidityBuyFee = 10;
1254         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1255         
1256         rewardsSellFee = 10;
1257         operationsSellFee = 70;
1258         liquiditySellFee = 10;
1259         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1260 
1261     	dividendTracker = new DividendTracker();
1262     	
1263     	operationsWallet = address(msg.sender); // set as operations wallet
1264 
1265     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1266     	
1267          // Create a uniswap pair for this new token
1268         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1269             .createPair(address(this), _uniswapV2Router.WETH());
1270 
1271         uniswapV2Router = _uniswapV2Router;
1272         uniswapV2Pair = _uniswapV2Pair;
1273 
1274         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1275 
1276         // exclude from receiving dividends
1277         dividendTracker.excludeFromDividends(address(dividendTracker));
1278         dividendTracker.excludeFromDividends(address(this));
1279         dividendTracker.excludeFromDividends(owner());
1280         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1281         dividendTracker.excludeFromDividends(address(0xdead));
1282         
1283         // exclude from paying fees or having max transaction amount
1284         excludeFromFees(owner(), true);
1285         excludeFromFees(address(this), true);
1286         excludeFromFees(address(0xdead), true);
1287         excludeFromMaxTransaction(owner(), true);
1288         excludeFromMaxTransaction(address(this), true);
1289         excludeFromMaxTransaction(address(dividendTracker), true);
1290         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1291         excludeFromMaxTransaction(address(0xdead), true);
1292 
1293         _createInitialSupply(address(owner()), totalSupply);
1294     }
1295 
1296     receive() external payable {
1297 
1298   	}
1299 
1300     // only use if conducting a presale
1301     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1302         excludeFromFees(_presaleAddress, true);
1303         dividendTracker.excludeFromDividends(_presaleAddress);
1304         excludeFromMaxTransaction(_presaleAddress, true);
1305     }
1306 
1307      // disable Transfer delay - cannot be reenabled
1308     function disableTransferDelay() external onlyOwner returns (bool){
1309         transferDelayEnabled = false;
1310         return true;
1311     }
1312 
1313     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1314     function excludeFromDividends(address account) external onlyOwner {
1315         dividendTracker.excludeFromDividends(account);
1316     }
1317 
1318     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1319     function includeInDividends(address account) external onlyOwner {
1320         dividendTracker.includeInDividends(account);
1321     }
1322     
1323     // once enabled, can never be turned off
1324     function enableTrading() external onlyOwner {
1325         require(!tradingActive, "Cannot re-enable trading");
1326         tradingActive = true;
1327         swapEnabled = true;
1328         tradingActiveBlock = block.number;
1329     }
1330     
1331     // only use to disable contract sales if absolutely necessary (emergency use only)
1332     function updateSwapEnabled(bool enabled) external onlyOwner(){
1333         swapEnabled = enabled;
1334     }
1335 
1336     function updateMaxAmount(uint256 newNum) external onlyOwner {
1337         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1338         maxTransactionAmount = newNum * (10**18);
1339     }
1340     
1341     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1342         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1343         maxWallet = newNum * (10**18);
1344     }
1345     
1346     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1347         operationsBuyFee = _operationsFee;
1348         rewardsBuyFee = _rewardsFee;
1349         liquidityBuyFee = _liquidityFee;
1350         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1351         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1352     }
1353     
1354     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1355         operationsSellFee = _operationsFee;
1356         rewardsSellFee = _rewardsFee;
1357         liquiditySellFee = _liquidityFee;
1358         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1359         require(totalSellFees <= 100, "Must keep fees at 10% or less");
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
1399     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1400         require(newOperationsWallet != address(0), "may not set to 0 address");
1401         excludeFromFees(newOperationsWallet, true);
1402         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1403         operationsWallet = newOperationsWallet;
1404     }
1405 
1406     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1407         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1408         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1409         emit GasForProcessingUpdated(newValue, gasForProcessing);
1410         gasForProcessing = newValue;
1411     }
1412 
1413     function updateClaimWait(uint256 claimWait) external onlyOwner {
1414         dividendTracker.updateClaimWait(claimWait);
1415     }
1416 
1417     function getClaimWait() external view returns(uint256) {
1418         return dividendTracker.claimWait();
1419     }
1420 
1421     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1422         return dividendTracker.totalDividendsDistributed(rewardToken);
1423     }
1424 
1425     function isExcludedFromFees(address account) external view returns(bool) {
1426         return _isExcludedFromFees[account];
1427     }
1428 
1429     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1430     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1431   	}
1432 
1433 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1434 		return dividendTracker.holderBalance(account);
1435 	}
1436 
1437     function getAccountDividendsInfo(address account, address rewardToken)
1438         external view returns (
1439             address,
1440             int256,
1441             int256,
1442             uint256,
1443             uint256,
1444             uint256,
1445             uint256,
1446             uint256) {
1447         return dividendTracker.getAccount(account, rewardToken);
1448     }
1449 
1450 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1451         external view returns (
1452             address,
1453             int256,
1454             int256,
1455             uint256,
1456             uint256,
1457             uint256,
1458             uint256,
1459             uint256) {
1460     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1461     }
1462 
1463 	function processDividendTracker(uint256 gas) external {
1464 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1465 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1466     }
1467 
1468     function claim() external {
1469 		dividendTracker.processAccount(payable(msg.sender), false);
1470     }
1471 
1472     function getLastProcessedIndex() external view returns(uint256) {
1473     	return dividendTracker.getLastProcessedIndex();
1474     }
1475 
1476     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1477         return dividendTracker.getNumberOfTokenHolders();
1478     }
1479     
1480     function getNumberOfDividends() external view returns(uint256) {
1481         return dividendTracker.totalBalance();
1482     }
1483     
1484     // remove limits after token is stable
1485     function removeLimits() external onlyOwner returns (bool){
1486         limitsInEffect = false;
1487         transferDelayEnabled = false;
1488         return true;
1489     }
1490     
1491     function _transfer(
1492         address from,
1493         address to,
1494         uint256 amount
1495     ) internal override {
1496         require(from != address(0), "ERC20: transfer from the zero address");
1497         require(to != address(0), "ERC20: transfer to the zero address");
1498         
1499          if(amount == 0) {
1500             super._transfer(from, to, 0);
1501             return;
1502         }
1503         
1504         if(!tradingActive){
1505             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1506         }
1507         
1508         if(limitsInEffect){
1509             if (
1510                 from != owner() &&
1511                 to != owner() &&
1512                 to != address(0) &&
1513                 to != address(0xdead) &&
1514                 !swapping
1515             ){
1516 
1517                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1518                 if (transferDelayEnabled){
1519                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1520                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1521                         _holderLastTransferTimestamp[tx.origin] = block.number;
1522                     }
1523                 }
1524                 
1525                 //when buy
1526                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1527                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1528                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1529                 } 
1530                 //when sell
1531                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1532                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1533                 }
1534                 else if(!_isExcludedMaxTransactionAmount[to]) {
1535                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1536                 }
1537             }
1538         }
1539 
1540 		uint256 contractTokenBalance = balanceOf(address(this));
1541         
1542         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1543 
1544         if( 
1545             canSwap &&
1546             swapEnabled &&
1547             !swapping &&
1548             !automatedMarketMakerPairs[from] &&
1549             !_isExcludedFromFees[from] &&
1550             !_isExcludedFromFees[to]
1551         ) {
1552             swapping = true;
1553             swapBack();
1554             swapping = false;
1555         }
1556 
1557         bool takeFee = !swapping;
1558 
1559         // if any account belongs to _isExcludedFromFee account then remove the fee
1560         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1561             takeFee = false;
1562         }
1563         
1564         uint256 fees = 0;
1565         
1566         // no taxes on transfers (non buys/sells)
1567         if(takeFee){
1568             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1569                 fees = amount.mul(99).div(100);
1570                 tokensForLiquidity += fees * 33 / 99;
1571                 tokensForRewards += fees * 33 / 99;
1572                 tokensForOperations += fees * 33 / 99;
1573             }
1574 
1575             // on sell
1576             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1577                 fees = amount.mul(totalSellFees).div(feeDivisor);
1578                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1579                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1580                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1581             }
1582             
1583             // on buy
1584             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1585         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1586         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1587                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1588                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1589             }
1590 
1591             if(fees > 0){    
1592                 super._transfer(from, address(this), fees);
1593             }
1594         	
1595         	amount -= fees;
1596         }
1597 
1598         super._transfer(from, to, amount);
1599 
1600         dividendTracker.setBalance(payable(from), balanceOf(from));
1601         dividendTracker.setBalance(payable(to), balanceOf(to));
1602 
1603         if(!swapping && gasForProcessing > 0) {
1604 	    	uint256 gas = gasForProcessing;
1605 
1606 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1607 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1608 	    	}
1609 	    	catch {}
1610         }
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
1643             address(0xdead),
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
1674         
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