1 // GMwagmiClassic - GMC
2 // t.me/gmwagmiOfficialPortal
3 // SPDX-License-Identifier: MIT  
4 
5 pragma solidity 0.8.15;
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
684 
685 
686      
687 }
688 
689 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
690   using SafeMath for uint256;
691   using SafeMathUint for uint256;
692   using SafeMathInt for int256;
693 
694   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
695   // For more discussion about choosing the value of `magnitude`,
696   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
697   uint256 constant internal magnitude = 2**128;
698 
699   mapping(address => uint256) internal magnifiedDividendPerShare;
700   address[] public rewardTokens;
701   address public nextRewardToken;
702   uint256 public rewardTokenCounter;
703   
704   IUniswapV2Router02 public immutable uniswapV2Router;
705   
706   
707   // About dividendCorrection:
708   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
709   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
710   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
711   //   `dividendOf(_user)` should not be changed,
712   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
713   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
714   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
715   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
716   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
717   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
718   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
719   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
720   
721   mapping (address => uint256) public holderBalance;
722   uint256 public totalBalance;
723 
724   mapping(address => uint256) public totalDividendsDistributed;
725   
726   constructor(){
727       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
728       uniswapV2Router = _uniswapV2Router; 
729       
730       // Mainnet
731 
732       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC - 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
733       
734       nextRewardToken = rewardTokens[0];
735   }
736 
737   
738 
739   /// @dev Distributes dividends whenever ether is paid to this contract.
740   receive() external payable {
741     distributeDividends();
742   }
743 
744   /// @notice Distributes ether to token holders as dividends.
745   /// @dev It reverts if the total supply of tokens is 0.
746   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
747   /// About undistributed ether:
748   ///   In each distribution, there is a small amount of ether not distributed,
749   ///     the magnified amount of which is
750   ///     `(msg.value * magnitude) % totalSupply()`.
751   ///   With a well-chosen `magnitude`, the amount of undistributed ether
752   ///     (de-magnified) in a distribution can be less than 1 wei.
753   ///   We can actually keep track of the undistributed ether in a distribution
754   ///     and try to distribute it in the next distribution,
755   ///     but keeping track of such data on-chain costs much more than
756   ///     the saved ether, so we don't do that.
757     
758   function distributeDividends() public override payable { 
759     require(totalBalance > 0);
760     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
761     buyTokens(msg.value, nextRewardToken);
762     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
763     if (newBalance > 0) {
764       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
765         (newBalance).mul(magnitude) / totalBalance
766       );
767       emit DividendsDistributed(msg.sender, newBalance);
768 
769       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
770     }
771     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
772     nextRewardToken = rewardTokens[rewardTokenCounter];
773   }
774   
775   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
776     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
777         // generate the uniswap pair path of weth -> eth
778         address[] memory path = new address[](2);
779         path[0] = uniswapV2Router.WETH();
780         path[1] = rewardToken;
781 
782         // make the swap
783         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
784             0, // accept any amount of Ethereum
785             path,
786             address(this),
787             block.timestamp
788         );
789     }
790   
791   /// @notice Withdraws the ether distributed to the sender.
792   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
793   function withdrawDividend(address _rewardToken) external virtual override {
794     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
795   }
796 
797   /// @notice Withdraws the ether distributed to the sender.
798   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
799   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
800     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
801     if (_withdrawableDividend > 0) {
802       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
803       emit DividendWithdrawn(user, _withdrawableDividend);
804       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
805       return _withdrawableDividend;
806     }
807 
808     return 0;
809   }
810 
811 
812   /// @notice View the amount of dividend in wei that an address can withdraw.
813   /// @param _owner The address of a token holder.
814   /// @return The amount of dividend in wei that `_owner` can withdraw.
815   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
816     return withdrawableDividendOf(_owner, _rewardToken);
817   }
818 
819   /// @notice View the amount of dividend in wei that an address can withdraw.
820   /// @param _owner The address of a token holder.
821   /// @return The amount of dividend in wei that `_owner` can withdraw.
822   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
823     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
824   }
825 
826   /// @notice View the amount of dividend in wei that an address has withdrawn.
827   /// @param _owner The address of a token holder.
828   /// @return The amount of dividend in wei that `_owner` has withdrawn.
829   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
830     return withdrawnDividends[_owner][_rewardToken];
831   }
832 
833 
834   /// @notice View the amount of dividend in wei that an address has earned in total.
835   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
836   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
837   /// @param _owner The address of a token holder.
838   /// @return The amount of dividend in wei that `_owner` has earned in total.
839   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
840     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
841       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
842   }
843 
844   /// @dev Internal function that increases tokens to an account.
845   /// Update magnifiedDividendCorrections to keep dividends unchanged.
846   /// @param account The account that will receive the created tokens.
847   /// @param value The amount that will be created.
848   function _increase(address account, uint256 value) internal {
849     for (uint256 i; i < rewardTokens.length; i++){
850         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
851           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
852     }
853   }
854 
855   /// @dev Internal function that reduces an amount of the token of a given account.
856   /// Update magnifiedDividendCorrections to keep dividends unchanged.
857   /// @param account The account whose tokens will be burnt.
858   /// @param value The amount that will be burnt.
859   function _reduce(address account, uint256 value) internal {
860       for (uint256 i; i < rewardTokens.length; i++){
861         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
862           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
863       }
864   }
865 
866   function _setBalance(address account, uint256 newBalance) internal {
867     uint256 currentBalance = holderBalance[account];
868     holderBalance[account] = newBalance;
869     if(newBalance > currentBalance) {
870       uint256 increaseAmount = newBalance.sub(currentBalance);
871       _increase(account, increaseAmount);
872       totalBalance += increaseAmount;
873     } else if(newBalance < currentBalance) {
874       uint256 reduceAmount = currentBalance.sub(newBalance);
875       _reduce(account, reduceAmount);
876       totalBalance -= reduceAmount;
877     }
878   }
879 }
880 
881 contract DividendTracker is DividendPayingToken {
882     using SafeMath for uint256;
883     using SafeMathInt for int256;
884 
885     struct Map {
886         address[] keys;
887         mapping(address => uint) values;
888         mapping(address => uint) indexOf;
889         mapping(address => bool) inserted;
890     }
891 
892     function get(address key) private view returns (uint) {
893         return tokenHoldersMap.values[key];
894     }
895 
896     function getIndexOfKey(address key) private view returns (int) {
897         if(!tokenHoldersMap.inserted[key]) {
898             return -1;
899         }
900         return int(tokenHoldersMap.indexOf[key]);
901     }
902 
903     function getKeyAtIndex(uint index) private view returns (address) {
904         return tokenHoldersMap.keys[index];
905     }
906 
907     function size() private view returns (uint) {
908         return tokenHoldersMap.keys.length;
909     }
910 
911     function set(address key, uint val) private {
912         if (tokenHoldersMap.inserted[key]) {
913             tokenHoldersMap.values[key] = val;
914         } else {
915             tokenHoldersMap.inserted[key] = true;
916             tokenHoldersMap.values[key] = val;
917             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
918             tokenHoldersMap.keys.push(key);
919         }
920     }
921 
922     function remove(address key) private {
923         if (!tokenHoldersMap.inserted[key]) {
924             return;
925         }
926 
927         delete tokenHoldersMap.inserted[key];
928         delete tokenHoldersMap.values[key];
929 
930         uint index = tokenHoldersMap.indexOf[key];
931         uint lastIndex = tokenHoldersMap.keys.length - 1;
932         address lastKey = tokenHoldersMap.keys[lastIndex];
933 
934         tokenHoldersMap.indexOf[lastKey] = index;
935         delete tokenHoldersMap.indexOf[key];
936 
937         tokenHoldersMap.keys[index] = lastKey;
938         tokenHoldersMap.keys.pop();
939     }
940 
941     Map private tokenHoldersMap;
942     uint256 public lastProcessedIndex;
943 
944     mapping (address => bool) public excludedFromDividends;
945 
946     mapping (address => uint256) public lastClaimTimes;
947 
948     uint256 public claimWait;
949     uint256 public immutable minimumTokenBalanceForDividends;
950 
951     event ExcludeFromDividends(address indexed account);
952     event IncludeInDividends(address indexed account);
953     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
954 
955     event Claim(address indexed account, uint256 amount, bool indexed automatic);
956 
957     constructor() {
958     	claimWait = 1200;
959         minimumTokenBalanceForDividends = 1000 * (10**18);
960     }
961 
962     function excludeFromDividends(address account) external onlyOwner {
963     	excludedFromDividends[account] = true;
964 
965     	_setBalance(account, 0);
966     	remove(account);
967 
968     	emit ExcludeFromDividends(account);
969     }
970     
971     function includeInDividends(address account) external onlyOwner {
972     	require(excludedFromDividends[account]);
973     	excludedFromDividends[account] = false;
974 
975     	emit IncludeInDividends(account);
976     }
977 
978     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
979         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
980         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
981         emit ClaimWaitUpdated(newClaimWait, claimWait);
982         claimWait = newClaimWait;
983     }
984 
985     function getLastProcessedIndex() external view returns(uint256) {
986     	return lastProcessedIndex;
987     }
988 
989     function getNumberOfTokenHolders() external view returns(uint256) {
990         return tokenHoldersMap.keys.length;
991     }
992 
993     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
994     	if(lastClaimTime > block.timestamp)  {
995     		return false;
996     	}
997 
998     	return block.timestamp.sub(lastClaimTime) >= claimWait;
999     }
1000 
1001     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1002     	if(excludedFromDividends[account]) {
1003     		return;
1004     	}
1005 
1006     	if(newBalance >= minimumTokenBalanceForDividends) {
1007             _setBalance(account, newBalance);
1008     		set(account, newBalance);
1009     	}
1010     	else {
1011             _setBalance(account, 0);
1012     		remove(account);
1013     	}
1014 
1015     	processAccount(account, true);
1016     }
1017     
1018     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1019     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1020 
1021     	if(numberOfTokenHolders == 0) {
1022     		return (0, 0, lastProcessedIndex);
1023     	}
1024 
1025     	uint256 _lastProcessedIndex = lastProcessedIndex;
1026 
1027     	uint256 gasUsed = 0;
1028 
1029     	uint256 gasLeft = gasleft();
1030 
1031     	uint256 iterations = 0;
1032     	uint256 claims = 0;
1033 
1034     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1035     		_lastProcessedIndex++;
1036 
1037     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1038     			_lastProcessedIndex = 0;
1039     		}
1040 
1041     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1042 
1043     		if(canAutoClaim(lastClaimTimes[account])) {
1044     			if(processAccount(payable(account), true)) {
1045     				claims++;
1046     			}
1047     		}
1048 
1049     		iterations++;
1050 
1051     		uint256 newGasLeft = gasleft();
1052 
1053     		if(gasLeft > newGasLeft) {
1054     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1055     		}
1056     		gasLeft = newGasLeft;
1057     	}
1058 
1059     	lastProcessedIndex = _lastProcessedIndex;
1060 
1061     	return (iterations, claims, lastProcessedIndex);
1062     }
1063 
1064     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1065         uint256 amount;
1066         bool paid;
1067         for (uint256 i; i < rewardTokens.length; i++){
1068             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1069             if(amount > 0) {
1070         		lastClaimTimes[account] = block.timestamp;
1071                 emit Claim(account, amount, automatic);
1072                 paid = true;
1073     	    }
1074         }
1075         return paid;
1076     }
1077 }
1078 
1079 contract GMC is ERC20, Ownable {
1080     using SafeMath for uint256;
1081 
1082     IUniswapV2Router02 public immutable uniswapV2Router;
1083     address public immutable uniswapV2Pair;
1084 
1085     bool private swapping;
1086 
1087     DividendTracker public dividendTracker;
1088 
1089     address public operationsWallet;
1090     
1091     uint256 public maxTransactionAmount;
1092     uint256 public swapTokensAtAmount;
1093     uint256 public maxWallet;
1094     
1095     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1096     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1097     
1098     bool public limitsInEffect = true;
1099     bool public tradingActive = false;
1100     bool public swapEnabled = false;
1101     
1102     uint256 public constant feeDivisor = 1000;
1103 
1104     uint256 public totalSellFees;
1105     uint256 public rewardsSellFee;
1106     uint256 public operationsSellFee;
1107     uint256 public liquiditySellFee;
1108     
1109     uint256 public totalBuyFees;
1110     uint256 public rewardsBuyFee;
1111     uint256 public operationsBuyFee;
1112     uint256 public liquidityBuyFee;
1113     
1114     uint256 public tokensForRewards;
1115     uint256 public tokensForOperations;
1116     uint256 public tokensForLiquidity;
1117     
1118     uint256 public gasForProcessing = 0;
1119 
1120     uint256 public lpWithdrawRequestTimestamp;
1121     uint256 public lpWithdrawRequestDuration = 3 days;
1122     bool public lpWithdrawRequestPending;
1123     uint256 public lpPercToWithDraw;
1124 
1125     // exlcude from fees and max transaction amount
1126     mapping (address => bool) private _isExcludedFromFees;
1127 
1128     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1129 
1130     // store addresses that an automatic market maker pairs. Any transfer *to* these addresses
1131     // could be subject to a maximum transfer amount
1132     mapping (address => bool) public automatedMarketMakerPairs;
1133 
1134     event ExcludeFromFees(address indexed account, bool isExcluded);
1135     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1136 
1137     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1138 
1139     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1140 
1141     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1142 
1143     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1144     
1145     event SwapAndLiquify(
1146         uint256 tokensSwapped,
1147         uint256 ethReceived,
1148         uint256 tokensIntoLiqudity
1149     );
1150 
1151     event SendDividends(
1152     	uint256 tokensSwapped,
1153     	uint256 amount
1154     );
1155 
1156     event ProcessedDividendTracker(
1157     	uint256 iterations,
1158     	uint256 claims,
1159         uint256 lastProcessedIndex,
1160     	bool indexed automatic,
1161     	uint256 gas,
1162     	address indexed processor
1163     );
1164 
1165     event RequestedLPWithdraw();
1166     
1167     event WithdrewLPForMigration();
1168 
1169     event CanceledLpWithdrawRequest();
1170 
1171     constructor() ERC20("GMC", "GMC") {
1172 
1173         uint256 totalSupply = 100 * 1e10 * 1e18;
1174         
1175         maxTransactionAmount = totalSupply * 10 / 1000; // 1% max transaction
1176         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
1177         maxWallet = totalSupply * 10 / 1000; // 1% max wallet
1178 
1179         rewardsBuyFee = 20;
1180         operationsBuyFee = 50;
1181         liquidityBuyFee = 10;
1182         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1183         
1184         rewardsSellFee = 20;
1185         operationsSellFee = 50;
1186         liquiditySellFee = 10;
1187         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1188 
1189     	dividendTracker = new DividendTracker();
1190     	
1191     	operationsWallet = address(msg.sender); // set as operations wallet
1192 
1193     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1194     	
1195          // Create a uniswap pair for this new token
1196         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1197             .createPair(address(this), _uniswapV2Router.WETH());
1198 
1199         uniswapV2Router = _uniswapV2Router;
1200         uniswapV2Pair = _uniswapV2Pair;
1201 
1202         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1203 
1204         // exclude from receiving dividends
1205         dividendTracker.excludeFromDividends(address(dividendTracker));
1206         dividendTracker.excludeFromDividends(address(this));
1207         dividendTracker.excludeFromDividends(owner());
1208         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1209         dividendTracker.excludeFromDividends(address(0xdead));
1210         
1211         // exclude from paying fees or having max transaction amount
1212         excludeFromFees(owner(), true);
1213         excludeFromFees(address(this), true);
1214         excludeFromFees(address(0xdead), true);
1215         excludeFromMaxTransaction(owner(), true);
1216         excludeFromMaxTransaction(address(this), true);
1217         excludeFromMaxTransaction(address(dividendTracker), true);
1218         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1219         excludeFromMaxTransaction(address(0xdead), true);
1220 
1221         _createInitialSupply(address(owner()), totalSupply);
1222     }
1223 
1224     receive() external payable {
1225 
1226   	}
1227 
1228     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1229     function excludeFromDividends(address account) external onlyOwner {
1230         dividendTracker.excludeFromDividends(account);
1231     }
1232 
1233     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1234     function includeInDividends(address account) external onlyOwner {
1235         dividendTracker.includeInDividends(account);
1236     }
1237     
1238     // once enabled, can never be turned off
1239     function enableTrading() external onlyOwner {
1240         require(!tradingActive, "Cannot re-enable trading");
1241         tradingActive = true;
1242         swapEnabled = true;
1243         tradingActiveBlock = block.number;
1244     }
1245     
1246     // only use to disable contract sales if absolutely necessary (emergency use only)
1247     function updateSwapEnabled(bool enabled) external onlyOwner(){
1248         swapEnabled = enabled;
1249     }
1250 
1251     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1252         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1253         maxTransactionAmount = newNum * (10**18);
1254     }
1255     
1256     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1257         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1258         maxWallet = newNum * (10**18);
1259     }
1260     
1261     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1262         operationsBuyFee = _operationsFee;
1263         rewardsBuyFee = _rewardsFee;
1264         liquidityBuyFee = _liquidityFee;
1265         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1266         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1267     }
1268     
1269     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1270         operationsSellFee = _operationsFee;
1271         rewardsSellFee = _rewardsFee;
1272         liquiditySellFee = _liquidityFee;
1273         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1274         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1275     }
1276 
1277     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1278         _isExcludedMaxTransactionAmount[updAds] = isEx;
1279         emit ExcludedMaxTransactionAmount(updAds, isEx);
1280     }
1281 
1282     function excludeFromFees(address account, bool excluded) public onlyOwner {
1283         _isExcludedFromFees[account] = excluded;
1284 
1285         emit ExcludeFromFees(account, excluded);
1286     }
1287 
1288     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1289         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1290 
1291         _setAutomatedMarketMakerPair(pair, value);
1292     }
1293 
1294     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1295         automatedMarketMakerPairs[pair] = value;
1296 
1297         excludeFromMaxTransaction(pair, value);
1298         
1299         if(value) {
1300             dividendTracker.excludeFromDividends(pair);
1301         }
1302 
1303         emit SetAutomatedMarketMakerPair(pair, value);
1304     }
1305 
1306     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1307         require(newOperationsWallet != address(0), "may not set to 0 address");
1308         excludeFromFees(newOperationsWallet, true);
1309         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1310         operationsWallet = newOperationsWallet;
1311     }
1312 
1313     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1314         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1315         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1316         emit GasForProcessingUpdated(newValue, gasForProcessing);
1317         gasForProcessing = newValue;
1318     }
1319 
1320     function updateClaimWait(uint256 claimWait) external onlyOwner {
1321         dividendTracker.updateClaimWait(claimWait);
1322     }
1323 
1324     function getClaimWait() external view returns(uint256) {
1325         return dividendTracker.claimWait();
1326     }
1327 
1328     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1329         return dividendTracker.totalDividendsDistributed(rewardToken);
1330     }
1331 
1332     function isExcludedFromFees(address account) external view returns(bool) {
1333         return _isExcludedFromFees[account];
1334     }
1335 
1336     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1337     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1338   	}
1339 
1340 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1341 		return dividendTracker.holderBalance(account);
1342 	}
1343 
1344  /*
1345 
1346 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1347         external view returns (
1348             address,
1349             int256,
1350             int256,
1351             uint256,
1352             uint256,
1353             uint256,
1354             uint256,
1355             uint256) {
1356     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1357     }
1358 
1359     */
1360 
1361 	function processDividendTracker(uint256 gas) external {
1362 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1363 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1364     }
1365 
1366     function claim() external {
1367 		dividendTracker.processAccount(payable(msg.sender), false);
1368     }
1369 
1370     function getLastProcessedIndex() external view returns(uint256) {
1371     	return dividendTracker.getLastProcessedIndex();
1372     }
1373 
1374     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1375         return dividendTracker.getNumberOfTokenHolders();
1376     }
1377     
1378     function getNumberOfDividends() external view returns(uint256) {
1379         return dividendTracker.totalBalance();
1380     }
1381     
1382     function removeLimits() external onlyOwner returns (bool){
1383         limitsInEffect = false;
1384         return true;
1385     }
1386     
1387     function _transfer(
1388         address from,
1389         address to,
1390         uint256 amount
1391     ) internal override {
1392         require(from != address(0), "ERC20: transfer from the zero address");
1393         require(to != address(0), "ERC20: transfer to the zero address");
1394         
1395          if(amount == 0) {
1396             super._transfer(from, to, 0);
1397             return;
1398         }
1399         
1400         if(!tradingActive){
1401             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1402         }
1403         
1404         if(limitsInEffect){
1405             if (
1406                 from != owner() &&
1407                 to != owner() &&
1408                 to != address(0) &&
1409                 to != address(0xdead) &&
1410                 !swapping
1411             ){
1412                 
1413                 //when buy
1414                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1415                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1416                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1417                 } 
1418                 //when sell
1419                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1420                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1421                 }
1422                 else if(!_isExcludedMaxTransactionAmount[to]) {
1423                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1424                 }
1425             }
1426         }
1427 
1428 		uint256 contractTokenBalance = balanceOf(address(this));
1429         
1430         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1431 
1432         if( 
1433             canSwap &&
1434             swapEnabled &&
1435             !swapping &&
1436             !automatedMarketMakerPairs[from] &&
1437             !_isExcludedFromFees[from] &&
1438             !_isExcludedFromFees[to]
1439         ) {
1440             swapping = true;
1441             swapBack();
1442             swapping = false;
1443         }
1444 
1445         bool takeFee = !swapping;
1446 
1447         // if any account belongs to _isExcludedFromFee account then remove the fee
1448         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1449             takeFee = false;
1450         }
1451         
1452         uint256 fees = 0;
1453         
1454         // no taxes on transfers (non buys/sells)
1455         if(takeFee){
1456             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1457                 fees = amount.mul(99).div(100);
1458                 tokensForLiquidity += fees * 33 / 99;
1459                 tokensForRewards += fees * 33 / 99;
1460                 tokensForOperations += fees * 33 / 99;
1461             }
1462 
1463             // on sell
1464             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1465                 fees = amount.mul(totalSellFees).div(feeDivisor);
1466                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1467                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1468                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1469             }
1470             
1471             // on buy
1472             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1473         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1474         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1475                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1476                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1477             }
1478 
1479             if(fees > 0){    
1480                 super._transfer(from, address(this), fees);
1481             }
1482         	
1483         	amount -= fees;
1484         }
1485 
1486         super._transfer(from, to, amount);
1487 
1488         dividendTracker.setBalance(payable(from), balanceOf(from));
1489         dividendTracker.setBalance(payable(to), balanceOf(to));
1490 
1491         if(!swapping && gasForProcessing > 0) {
1492 	    	uint256 gas = gasForProcessing;
1493 
1494 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1495 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1496 	    	}
1497 	    	catch {}
1498         }
1499     }
1500     
1501     function swapTokensForEth(uint256 tokenAmount) private {
1502 
1503         // generate the uniswap pair path of token -> weth
1504         address[] memory path = new address[](2);
1505         path[0] = address(this);
1506         path[1] = uniswapV2Router.WETH();
1507 
1508         _approve(address(this), address(uniswapV2Router), tokenAmount);
1509 
1510         // make the swap
1511         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1512             tokenAmount,
1513             0, // accept any amount of ETH
1514             path,
1515             address(this),
1516             block.timestamp
1517         );
1518         
1519     }
1520     
1521     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1522         // approve token transfer to cover all possible scenarios
1523         _approve(address(this), address(uniswapV2Router), tokenAmount);
1524 
1525         // add the liquidity
1526         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1527             address(this),
1528             tokenAmount,
1529             0, // slippage is unavoidable
1530             0, // slippage is unavoidable
1531             address(0xdead),
1532             block.timestamp
1533         );
1534 
1535     }
1536     
1537     function swapBack() private {
1538         uint256 contractBalance = balanceOf(address(this));
1539         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1540         
1541         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1542         
1543         // Halve the amount of liquidity tokens
1544         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1545         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1546         
1547         uint256 initialETHBalance = address(this).balance;
1548 
1549         swapTokensForEth(amountToSwapForETH); 
1550         
1551         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1552         
1553         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1554         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1555         
1556         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1557         
1558         tokensForLiquidity = 0;
1559         tokensForOperations = 0;
1560         tokensForRewards = 0;
1561         
1562         
1563         
1564         if(liquidityTokens > 0 && ethForLiquidity > 0){
1565             addLiquidity(liquidityTokens, ethForLiquidity);
1566             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1567         }
1568         
1569         // call twice to force buy of both reward tokens.
1570         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1571 
1572         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1573     }
1574 
1575     function withdrawStuckEth() external onlyOwner {
1576         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1577         require(success, "failed to withdraw");
1578     }
1579 
1580   
1581 
1582     function nextAvailableLpWithdrawDate() public view returns (uint256){
1583         if(lpWithdrawRequestPending){
1584             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1585         }
1586         else {
1587             return 0;  // 0 means no open requests
1588         }
1589     }
1590 
1591     function withdrawRequestedLP() external onlyOwner {
1592         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1593         lpWithdrawRequestTimestamp = 0;
1594         lpWithdrawRequestPending = false;
1595 
1596         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1597         
1598         lpPercToWithDraw = 0;
1599 
1600         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1601     }
1602 
1603    
1604 }