1 /**
2 
3 WEB : www.pyramid.to
4 
5 TG : @PyramidProtocol 
6 
7 7% TOTAL TAX
8 
9 ---6% USDC REFLECTIONS---
10 ---1% AUTO LIQUIDITY---
11 
12 */
13 
14 // SPDX-License-Identifier: MIT  
15 
16 pragma solidity 0.8.15;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IUniswapV2Factory {
30     function createPair(address tokenA, address tokenB) external returns (address pair);
31 }
32 
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 interface IERC20Metadata is IERC20 {
109     /**
110      * @dev Returns the name of the token.
111      */
112     function name() external view returns (string memory);
113 
114     /**
115      * @dev Returns the symbol of the token.
116      */
117     function symbol() external view returns (string memory);
118 
119     /**
120      * @dev Returns the decimals places of the token.
121      */
122     function decimals() external view returns (uint8);
123 }
124 
125 
126 contract ERC20 is Context, IERC20, IERC20Metadata {
127     mapping(address => uint256) private _balances;
128 
129     mapping(address => mapping(address => uint256)) private _allowances;
130 
131     uint256 private _totalSupply;
132 
133     string private _name;
134     string private _symbol;
135 
136     constructor(string memory name_, string memory symbol_) {
137         _name = name_;
138         _symbol = symbol_;
139     }
140 
141     function name() public view virtual override returns (string memory) {
142         return _name;
143     }
144 
145     function symbol() public view virtual override returns (string memory) {
146         return _symbol;
147     }
148 
149     function decimals() public view virtual override returns (uint8) {
150         return 18;
151     }
152 
153     function totalSupply() public view virtual override returns (uint256) {
154         return _totalSupply;
155     }
156 
157     function balanceOf(address account) public view virtual override returns (uint256) {
158         return _balances[account];
159     }
160 
161     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
162         _transfer(_msgSender(), recipient, amount);
163         return true;
164     }
165 
166     function allowance(address owner, address spender) public view virtual override returns (uint256) {
167         return _allowances[owner][spender];
168     }
169 
170     function approve(address spender, uint256 amount) public virtual override returns (bool) {
171         _approve(_msgSender(), spender, amount);
172         return true;
173     }
174 
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) public virtual override returns (bool) {
180         _transfer(sender, recipient, amount);
181 
182         uint256 currentAllowance = _allowances[sender][_msgSender()];
183         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
184         unchecked {
185             _approve(sender, _msgSender(), currentAllowance - amount);
186         }
187 
188         return true;
189     }
190 
191     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
192         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
193         return true;
194     }
195 
196     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
197         uint256 currentAllowance = _allowances[_msgSender()][spender];
198         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
199         unchecked {
200             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
201         }
202 
203         return true;
204     }
205 
206     function _transfer(
207         address sender,
208         address recipient,
209         uint256 amount
210     ) internal virtual {
211         require(sender != address(0), "ERC20: transfer from the zero address");
212         require(recipient != address(0), "ERC20: transfer to the zero address");
213 
214         uint256 senderBalance = _balances[sender];
215         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
216         unchecked {
217             _balances[sender] = senderBalance - amount;
218         }
219         _balances[recipient] += amount;
220 
221         emit Transfer(sender, recipient, amount);
222     }
223 
224     function _createInitialSupply(address account, uint256 amount) internal virtual {
225         require(account != address(0), "ERC20: mint to the zero address");
226         _totalSupply += amount;
227         _balances[account] += amount;
228         emit Transfer(address(0), account, amount);
229     }
230 
231     function _approve(
232         address owner,
233         address spender,
234         uint256 amount
235     ) internal virtual {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238 
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242 }
243 
244 interface DividendPayingTokenOptionalInterface {
245   /// @notice View the amount of dividend in wei that an address can withdraw.
246   /// @param _owner The address of a token holder.
247   /// @return The amount of dividend in wei that `_owner` can withdraw.
248   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
249 
250   /// @notice View the amount of dividend in wei that an address has withdrawn.
251   /// @param _owner The address of a token holder.
252   /// @return The amount of dividend in wei that `_owner` has withdrawn.
253   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
254 
255   /// @notice View the amount of dividend in wei that an address has earned in total.
256   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
257   /// @param _owner The address of a token holder.
258   /// @return The amount of dividend in wei that `_owner` has earned in total.
259   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
260 }
261 
262 interface DividendPayingTokenInterface {
263   /// @notice View the amount of dividend in wei that an address can withdraw.
264   /// @param _owner The address of a token holder.
265   /// @return The amount of dividend in wei that `_owner` can withdraw.
266   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
267 
268   /// @notice Distributes ether to token holders as dividends.
269   /// @dev SHOULD distribute the paid ether to token holders as dividends.
270   ///  SHOULD NOT directly transfer ether to token holders in this function.
271   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
272   function distributeDividends() external payable;
273 
274   /// @notice Withdraws the ether distributed to the sender.
275   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
276   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
277   function withdrawDividend(address _rewardToken) external;
278 
279   /// @dev This event MUST emit when ether is distributed to token holders.
280   /// @param from The address which sends ether to this contract.
281   /// @param weiAmount The amount of distributed ether in wei.
282   event DividendsDistributed(
283     address indexed from,
284     uint256 weiAmount
285   );
286 
287   /// @dev This event MUST emit when an address withdraws their dividend.
288   /// @param to The address which withdraws ether from this contract.
289   /// @param weiAmount The amount of withdrawn ether in wei.
290   event DividendWithdrawn(
291     address indexed to,
292     uint256 weiAmount
293   );
294 }
295 
296 library SafeMath {
297     /**
298      * @dev Returns the addition of two unsigned integers, reverting on
299      * overflow.
300      *
301      * Counterpart to Solidity's `+` operator.
302      *
303      * Requirements:
304      *
305      * - Addition cannot overflow.
306      */
307     function add(uint256 a, uint256 b) internal pure returns (uint256) {
308         uint256 c = a + b;
309         require(c >= a, "SafeMath: addition overflow");
310 
311         return c;
312     }
313 
314     /**
315      * @dev Returns the subtraction of two unsigned integers, reverting on
316      * overflow (when the result is negative).
317      *
318      * Counterpart to Solidity's `-` operator.
319      *
320      * Requirements:
321      *
322      * - Subtraction cannot overflow.
323      */
324     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
325         return sub(a, b, "SafeMath: subtraction overflow");
326     }
327 
328     /**
329      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
330      * overflow (when the result is negative).
331      *
332      * Counterpart to Solidity's `-` operator.
333      *
334      * Requirements:
335      *
336      * - Subtraction cannot overflow.
337      */
338     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
339         require(b <= a, errorMessage);
340         uint256 c = a - b;
341 
342         return c;
343     }
344 
345     /**
346      * @dev Returns the multiplication of two unsigned integers, reverting on
347      * overflow.
348      *
349      * Counterpart to Solidity's `*` operator.
350      *
351      * Requirements:
352      *
353      * - Multiplication cannot overflow.
354      */
355     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
356         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
357         // benefit is lost if 'b' is also tested.
358         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
359         if (a == 0) {
360             return 0;
361         }
362 
363         uint256 c = a * b;
364         require(c / a == b, "SafeMath: multiplication overflow");
365 
366         return c;
367     }
368 
369     /**
370      * @dev Returns the integer division of two unsigned integers. Reverts on
371      * division by zero. The result is rounded towards zero.
372      *
373      * Counterpart to Solidity's `/` operator. Note: this function uses a
374      * `revert` opcode (which leaves remaining gas untouched) while Solidity
375      * uses an invalid opcode to revert (consuming all remaining gas).
376      *
377      * Requirements:
378      *
379      * - The divisor cannot be zero.
380      */
381     function div(uint256 a, uint256 b) internal pure returns (uint256) {
382         return div(a, b, "SafeMath: division by zero");
383     }
384 
385     /**
386      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
387      * division by zero. The result is rounded towards zero.
388      *
389      * Counterpart to Solidity's `/` operator. Note: this function uses a
390      * `revert` opcode (which leaves remaining gas untouched) while Solidity
391      * uses an invalid opcode to revert (consuming all remaining gas).
392      *
393      * Requirements:
394      *
395      * - The divisor cannot be zero.
396      */
397     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
398         require(b > 0, errorMessage);
399         uint256 c = a / b;
400         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
401 
402         return c;
403     }
404 
405     /**
406      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
407      * Reverts when dividing by zero.
408      *
409      * Counterpart to Solidity's `%` operator. This function uses a `revert`
410      * opcode (which leaves remaining gas untouched) while Solidity uses an
411      * invalid opcode to revert (consuming all remaining gas).
412      *
413      * Requirements:
414      *
415      * - The divisor cannot be zero.
416      */
417     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
418         return mod(a, b, "SafeMath: modulo by zero");
419     }
420 
421     /**
422      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
423      * Reverts with custom message when dividing by zero.
424      *
425      * Counterpart to Solidity's `%` operator. This function uses a `revert`
426      * opcode (which leaves remaining gas untouched) while Solidity uses an
427      * invalid opcode to revert (consuming all remaining gas).
428      *
429      * Requirements:
430      *
431      * - The divisor cannot be zero.
432      */
433     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
434         require(b != 0, errorMessage);
435         return a % b;
436     }
437 }
438 
439 contract Ownable is Context {
440     address private _owner;
441 
442     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
443     
444     /**
445      * @dev Initializes the contract setting the deployer as the initial owner.
446      */
447     constructor () {
448         address msgSender = _msgSender();
449         _owner = msgSender;
450         emit OwnershipTransferred(address(0), msgSender);
451     }
452 
453     /**
454      * @dev Returns the address of the current owner.
455      */
456     function owner() public view returns (address) {
457         return _owner;
458     }
459 
460     /**
461      * @dev Throws if called by any account other than the owner.
462      */
463     modifier onlyOwner() {
464         require(_owner == _msgSender(), "Ownable: caller is not the owner");
465         _;
466     }
467 
468     /**
469      * @dev Leaves the contract without owner. It will not be possible to call
470      * `onlyOwner` functions anymore. Can only be called by the current owner.
471      *
472      * NOTE: Renouncing ownership will leave the contract without an owner,
473      * thereby removing any functionality that is only available to the owner.
474      */
475     function renounceOwnership() public virtual onlyOwner {
476         emit OwnershipTransferred(_owner, address(0));
477         _owner = address(0);
478     }
479 
480     /**
481      * @dev Transfers ownership of the contract to a new account (`newOwner`).
482      * Can only be called by the current owner.
483      */
484     function transferOwnership(address newOwner) public virtual onlyOwner {
485         require(newOwner != address(0), "Ownable: new owner is the zero address");
486         emit OwnershipTransferred(_owner, newOwner);
487         _owner = newOwner;
488     }
489 }
490 
491 
492 
493 library SafeMathInt {
494     int256 private constant MIN_INT256 = int256(1) << 255;
495     int256 private constant MAX_INT256 = ~(int256(1) << 255);
496 
497     /**
498      * @dev Multiplies two int256 variables and fails on overflow.
499      */
500     function mul(int256 a, int256 b) internal pure returns (int256) {
501         int256 c = a * b;
502 
503         // Detect overflow when multiplying MIN_INT256 with -1
504         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
505         require((b == 0) || (c / b == a));
506         return c;
507     }
508 
509     /**
510      * @dev Division of two int256 variables and fails on overflow.
511      */
512     function div(int256 a, int256 b) internal pure returns (int256) {
513         // Prevent overflow when dividing MIN_INT256 by -1
514         require(b != -1 || a != MIN_INT256);
515 
516         // Solidity already throws when dividing by 0.
517         return a / b;
518     }
519 
520     /**
521      * @dev Subtracts two int256 variables and fails on overflow.
522      */
523     function sub(int256 a, int256 b) internal pure returns (int256) {
524         int256 c = a - b;
525         require((b >= 0 && c <= a) || (b < 0 && c > a));
526         return c;
527     }
528 
529     /**
530      * @dev Adds two int256 variables and fails on overflow.
531      */
532     function add(int256 a, int256 b) internal pure returns (int256) {
533         int256 c = a + b;
534         require((b >= 0 && c >= a) || (b < 0 && c < a));
535         return c;
536     }
537 
538     /**
539      * @dev Converts to absolute value, and fails on overflow.
540      */
541     function abs(int256 a) internal pure returns (int256) {
542         require(a != MIN_INT256);
543         return a < 0 ? -a : a;
544     }
545 
546 
547     function toUint256Safe(int256 a) internal pure returns (uint256) {
548         require(a >= 0);
549         return uint256(a);
550     }
551 }
552 
553 library SafeMathUint {
554   function toInt256Safe(uint256 a) internal pure returns (int256) {
555     int256 b = int256(a);
556     require(b >= 0);
557     return b;
558   }
559 }
560 
561 
562 interface IUniswapV2Router01 {
563     function factory() external pure returns (address);
564     function WETH() external pure returns (address);
565 
566     function addLiquidity(
567         address tokenA,
568         address tokenB,
569         uint amountADesired,
570         uint amountBDesired,
571         uint amountAMin,
572         uint amountBMin,
573         address to,
574         uint deadline
575     ) external returns (uint amountA, uint amountB, uint liquidity);
576     function addLiquidityETH(
577         address token,
578         uint amountTokenDesired,
579         uint amountTokenMin,
580         uint amountETHMin,
581         address to,
582         uint deadline
583     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
584     function removeLiquidity(
585         address tokenA,
586         address tokenB,
587         uint liquidity,
588         uint amountAMin,
589         uint amountBMin,
590         address to,
591         uint deadline
592     ) external returns (uint amountA, uint amountB);
593     function removeLiquidityETH(
594         address token,
595         uint liquidity,
596         uint amountTokenMin,
597         uint amountETHMin,
598         address to,
599         uint deadline
600     ) external returns (uint amountToken, uint amountETH);
601     function removeLiquidityWithPermit(
602         address tokenA,
603         address tokenB,
604         uint liquidity,
605         uint amountAMin,
606         uint amountBMin,
607         address to,
608         uint deadline,
609         bool approveMax, uint8 v, bytes32 r, bytes32 s
610     ) external returns (uint amountA, uint amountB);
611     function removeLiquidityETHWithPermit(
612         address token,
613         uint liquidity,
614         uint amountTokenMin,
615         uint amountETHMin,
616         address to,
617         uint deadline,
618         bool approveMax, uint8 v, bytes32 r, bytes32 s
619     ) external returns (uint amountToken, uint amountETH);
620     function swapExactTokensForTokens(
621         uint amountIn,
622         uint amountOutMin,
623         address[] calldata path,
624         address to,
625         uint deadline
626     ) external returns (uint[] memory amounts);
627     function swapTokensForExactTokens(
628         uint amountOut,
629         uint amountInMax,
630         address[] calldata path,
631         address to,
632         uint deadline
633     ) external returns (uint[] memory amounts);
634     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
635         external
636         payable
637         returns (uint[] memory amounts);
638     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
639         external
640         returns (uint[] memory amounts);
641     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
642         external
643         returns (uint[] memory amounts);
644     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
645         external
646         payable
647         returns (uint[] memory amounts);
648 
649     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
650     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
651     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
652     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
653     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
654 }
655 
656 interface IUniswapV2Router02 is IUniswapV2Router01 {
657     function removeLiquidityETHSupportingFeeOnTransferTokens(
658         address token,
659         uint liquidity,
660         uint amountTokenMin,
661         uint amountETHMin,
662         address to,
663         uint deadline
664     ) external returns (uint amountETH);
665     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
666         address token,
667         uint liquidity,
668         uint amountTokenMin,
669         uint amountETHMin,
670         address to,
671         uint deadline,
672         bool approveMax, uint8 v, bytes32 r, bytes32 s
673     ) external returns (uint amountETH);
674 
675     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
676         uint amountIn,
677         uint amountOutMin,
678         address[] calldata path,
679         address to,
680         uint deadline
681     ) external;
682     function swapExactETHForTokensSupportingFeeOnTransferTokens(
683         uint amountOutMin,
684         address[] calldata path,
685         address to,
686         uint deadline
687     ) external payable;
688     function swapExactTokensForETHSupportingFeeOnTransferTokens(
689         uint amountIn,
690         uint amountOutMin,
691         address[] calldata path,
692         address to,
693         uint deadline
694     ) external;
695 
696 
697      
698 }
699 
700 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
701   using SafeMath for uint256;
702   using SafeMathUint for uint256;
703   using SafeMathInt for int256;
704 
705   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
706   // For more discussion about choosing the value of `magnitude`,
707   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
708   uint256 constant internal magnitude = 2**128;
709 
710   mapping(address => uint256) internal magnifiedDividendPerShare;
711   address[] public rewardTokens;
712   address public nextRewardToken;
713   uint256 public rewardTokenCounter;
714   
715   IUniswapV2Router02 public immutable uniswapV2Router;
716   
717   
718   // About dividendCorrection:
719   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
720   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
721   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
722   //   `dividendOf(_user)` should not be changed,
723   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
724   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
725   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
726   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
727   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
728   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
729   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
730   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
731   
732   mapping (address => uint256) public holderBalance;
733   uint256 public totalBalance;
734 
735   mapping(address => uint256) public totalDividendsDistributed;
736   
737   constructor(){
738       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
739       uniswapV2Router = _uniswapV2Router; 
740       
741       // Mainnet
742 
743       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC - 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
744       
745       nextRewardToken = rewardTokens[0];
746   }
747 
748   
749 
750   /// @dev Distributes dividends whenever ether is paid to this contract.
751   receive() external payable {
752     distributeDividends();
753   }
754 
755   /// @notice Distributes ether to token holders as dividends.
756   /// @dev It reverts if the total supply of tokens is 0.
757   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
758   /// About undistributed ether:
759   ///   In each distribution, there is a small amount of ether not distributed,
760   ///     the magnified amount of which is
761   ///     `(msg.value * magnitude) % totalSupply()`.
762   ///   With a well-chosen `magnitude`, the amount of undistributed ether
763   ///     (de-magnified) in a distribution can be less than 1 wei.
764   ///   We can actually keep track of the undistributed ether in a distribution
765   ///     and try to distribute it in the next distribution,
766   ///     but keeping track of such data on-chain costs much more than
767   ///     the saved ether, so we don't do that.
768     
769   function distributeDividends() public override payable { 
770     require(totalBalance > 0);
771     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
772     buyTokens(msg.value, nextRewardToken);
773     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
774     if (newBalance > 0) {
775       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
776         (newBalance).mul(magnitude) / totalBalance
777       );
778       emit DividendsDistributed(msg.sender, newBalance);
779 
780       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
781     }
782     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
783     nextRewardToken = rewardTokens[rewardTokenCounter];
784   }
785   
786   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
787     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
788         // generate the uniswap pair path of weth -> eth
789         address[] memory path = new address[](2);
790         path[0] = uniswapV2Router.WETH();
791         path[1] = rewardToken;
792 
793         // make the swap
794         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
795             0, // accept any amount of Ethereum
796             path,
797             address(this),
798             block.timestamp
799         );
800     }
801   
802   /// @notice Withdraws the ether distributed to the sender.
803   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
804   function withdrawDividend(address _rewardToken) external virtual override {
805     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
806   }
807 
808   /// @notice Withdraws the ether distributed to the sender.
809   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
810   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
811     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
812     if (_withdrawableDividend > 0) {
813       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
814       emit DividendWithdrawn(user, _withdrawableDividend);
815       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
816       return _withdrawableDividend;
817     }
818 
819     return 0;
820   }
821 
822 
823   /// @notice View the amount of dividend in wei that an address can withdraw.
824   /// @param _owner The address of a token holder.
825   /// @return The amount of dividend in wei that `_owner` can withdraw.
826   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
827     return withdrawableDividendOf(_owner, _rewardToken);
828   }
829 
830   /// @notice View the amount of dividend in wei that an address can withdraw.
831   /// @param _owner The address of a token holder.
832   /// @return The amount of dividend in wei that `_owner` can withdraw.
833   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
834     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
835   }
836 
837   /// @notice View the amount of dividend in wei that an address has withdrawn.
838   /// @param _owner The address of a token holder.
839   /// @return The amount of dividend in wei that `_owner` has withdrawn.
840   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
841     return withdrawnDividends[_owner][_rewardToken];
842   }
843 
844 
845   /// @notice View the amount of dividend in wei that an address has earned in total.
846   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
847   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
848   /// @param _owner The address of a token holder.
849   /// @return The amount of dividend in wei that `_owner` has earned in total.
850   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
851     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
852       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
853   }
854 
855   /// @dev Internal function that increases tokens to an account.
856   /// Update magnifiedDividendCorrections to keep dividends unchanged.
857   /// @param account The account that will receive the created tokens.
858   /// @param value The amount that will be created.
859   function _increase(address account, uint256 value) internal {
860     for (uint256 i; i < rewardTokens.length; i++){
861         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
862           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
863     }
864   }
865 
866   /// @dev Internal function that reduces an amount of the token of a given account.
867   /// Update magnifiedDividendCorrections to keep dividends unchanged.
868   /// @param account The account whose tokens will be burnt.
869   /// @param value The amount that will be burnt.
870   function _reduce(address account, uint256 value) internal {
871       for (uint256 i; i < rewardTokens.length; i++){
872         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
873           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
874       }
875   }
876 
877   function _setBalance(address account, uint256 newBalance) internal {
878     uint256 currentBalance = holderBalance[account];
879     holderBalance[account] = newBalance;
880     if(newBalance > currentBalance) {
881       uint256 increaseAmount = newBalance.sub(currentBalance);
882       _increase(account, increaseAmount);
883       totalBalance += increaseAmount;
884     } else if(newBalance < currentBalance) {
885       uint256 reduceAmount = currentBalance.sub(newBalance);
886       _reduce(account, reduceAmount);
887       totalBalance -= reduceAmount;
888     }
889   }
890 }
891 
892 contract DividendTracker is DividendPayingToken {
893     using SafeMath for uint256;
894     using SafeMathInt for int256;
895 
896     struct Map {
897         address[] keys;
898         mapping(address => uint) values;
899         mapping(address => uint) indexOf;
900         mapping(address => bool) inserted;
901     }
902 
903     function get(address key) private view returns (uint) {
904         return tokenHoldersMap.values[key];
905     }
906 
907     function getIndexOfKey(address key) private view returns (int) {
908         if(!tokenHoldersMap.inserted[key]) {
909             return -1;
910         }
911         return int(tokenHoldersMap.indexOf[key]);
912     }
913 
914     function getKeyAtIndex(uint index) private view returns (address) {
915         return tokenHoldersMap.keys[index];
916     }
917 
918     function size() private view returns (uint) {
919         return tokenHoldersMap.keys.length;
920     }
921 
922     function set(address key, uint val) private {
923         if (tokenHoldersMap.inserted[key]) {
924             tokenHoldersMap.values[key] = val;
925         } else {
926             tokenHoldersMap.inserted[key] = true;
927             tokenHoldersMap.values[key] = val;
928             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
929             tokenHoldersMap.keys.push(key);
930         }
931     }
932 
933     function remove(address key) private {
934         if (!tokenHoldersMap.inserted[key]) {
935             return;
936         }
937 
938         delete tokenHoldersMap.inserted[key];
939         delete tokenHoldersMap.values[key];
940 
941         uint index = tokenHoldersMap.indexOf[key];
942         uint lastIndex = tokenHoldersMap.keys.length - 1;
943         address lastKey = tokenHoldersMap.keys[lastIndex];
944 
945         tokenHoldersMap.indexOf[lastKey] = index;
946         delete tokenHoldersMap.indexOf[key];
947 
948         tokenHoldersMap.keys[index] = lastKey;
949         tokenHoldersMap.keys.pop();
950     }
951 
952     Map private tokenHoldersMap;
953     uint256 public lastProcessedIndex;
954 
955     mapping (address => bool) public excludedFromDividends;
956 
957     mapping (address => uint256) public lastClaimTimes;
958 
959     uint256 public claimWait;
960     uint256 public immutable minimumTokenBalanceForDividends;
961 
962     event ExcludeFromDividends(address indexed account);
963     event IncludeInDividends(address indexed account);
964     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
965 
966     event Claim(address indexed account, uint256 amount, bool indexed automatic);
967 
968     constructor() {
969     	claimWait = 1200;
970         minimumTokenBalanceForDividends = 1000 * (10**18);
971     }
972 
973     function excludeFromDividends(address account) external onlyOwner {
974     	excludedFromDividends[account] = true;
975 
976     	_setBalance(account, 0);
977     	remove(account);
978 
979     	emit ExcludeFromDividends(account);
980     }
981     
982     function includeInDividends(address account) external onlyOwner {
983     	require(excludedFromDividends[account]);
984     	excludedFromDividends[account] = false;
985 
986     	emit IncludeInDividends(account);
987     }
988 
989     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
990         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
991         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
992         emit ClaimWaitUpdated(newClaimWait, claimWait);
993         claimWait = newClaimWait;
994     }
995 
996     function getLastProcessedIndex() external view returns(uint256) {
997     	return lastProcessedIndex;
998     }
999 
1000     function getNumberOfTokenHolders() external view returns(uint256) {
1001         return tokenHoldersMap.keys.length;
1002     }
1003 
1004     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1005     	if(lastClaimTime > block.timestamp)  {
1006     		return false;
1007     	}
1008 
1009     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1010     }
1011 
1012     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1013     	if(excludedFromDividends[account]) {
1014     		return;
1015     	}
1016 
1017     	if(newBalance >= minimumTokenBalanceForDividends) {
1018             _setBalance(account, newBalance);
1019     		set(account, newBalance);
1020     	}
1021     	else {
1022             _setBalance(account, 0);
1023     		remove(account);
1024     	}
1025 
1026     	processAccount(account, true);
1027     }
1028     
1029     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1030     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1031 
1032     	if(numberOfTokenHolders == 0) {
1033     		return (0, 0, lastProcessedIndex);
1034     	}
1035 
1036     	uint256 _lastProcessedIndex = lastProcessedIndex;
1037 
1038     	uint256 gasUsed = 0;
1039 
1040     	uint256 gasLeft = gasleft();
1041 
1042     	uint256 iterations = 0;
1043     	uint256 claims = 0;
1044 
1045     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1046     		_lastProcessedIndex++;
1047 
1048     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1049     			_lastProcessedIndex = 0;
1050     		}
1051 
1052     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1053 
1054     		if(canAutoClaim(lastClaimTimes[account])) {
1055     			if(processAccount(payable(account), true)) {
1056     				claims++;
1057     			}
1058     		}
1059 
1060     		iterations++;
1061 
1062     		uint256 newGasLeft = gasleft();
1063 
1064     		if(gasLeft > newGasLeft) {
1065     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1066     		}
1067     		gasLeft = newGasLeft;
1068     	}
1069 
1070     	lastProcessedIndex = _lastProcessedIndex;
1071 
1072     	return (iterations, claims, lastProcessedIndex);
1073     }
1074 
1075     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1076         uint256 amount;
1077         bool paid;
1078         for (uint256 i; i < rewardTokens.length; i++){
1079             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1080             if(amount > 0) {
1081         		lastClaimTimes[account] = block.timestamp;
1082                 emit Claim(account, amount, automatic);
1083                 paid = true;
1084     	    }
1085         }
1086         return paid;
1087     }
1088 }
1089 
1090 contract PyramidProtocol is ERC20, Ownable {
1091     using SafeMath for uint256;
1092 
1093     IUniswapV2Router02 public immutable uniswapV2Router;
1094     address public immutable uniswapV2Pair;
1095 
1096     bool private swapping;
1097 
1098     DividendTracker public dividendTracker;
1099     
1100     uint256 public maxTransactionAmount;
1101     uint256 public swapTokensAtAmount;
1102     uint256 public maxWallet;
1103     
1104     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1105     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1106     
1107     bool public limitsInEffect = true;
1108     bool public tradingActive = false;
1109     bool public swapEnabled = false;
1110     
1111     uint256 public constant feeDivisor = 1000;
1112 
1113     uint256 public totalSellFees;
1114     uint256 public rewardsSellFee;
1115     uint256 public liquiditySellFee;
1116     
1117     uint256 public totalBuyFees;
1118     uint256 public rewardsBuyFee;
1119     uint256 public liquidityBuyFee;
1120     
1121     uint256 public tokensForRewards;
1122     uint256 public tokensForLiquidity;
1123     
1124     uint256 public gasForProcessing = 0;
1125 
1126     uint256 public lpWithdrawRequestTimestamp;
1127     uint256 public lpWithdrawRequestDuration = 3 days;
1128     bool public lpWithdrawRequestPending;
1129     uint256 public lpPercToWithDraw;
1130 
1131     // exlcude from fees and max transaction amount
1132     mapping (address => bool) private _isExcludedFromFees;
1133 
1134     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1135 
1136     // store addresses that an automatic market maker pairs. Any transfer *to* these addresses
1137     // could be subject to a maximum transfer amount
1138     mapping (address => bool) public automatedMarketMakerPairs;
1139 
1140     event ExcludeFromFees(address indexed account, bool isExcluded);
1141     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1142 
1143     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1144 
1145     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1146 
1147     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1148     
1149     event SwapAndLiquify(
1150         uint256 tokensSwapped,
1151         uint256 ethReceived,
1152         uint256 tokensIntoLiqudity
1153     );
1154 
1155     event SendDividends(
1156     	uint256 tokensSwapped,
1157     	uint256 amount
1158     );
1159 
1160     event ProcessedDividendTracker(
1161     	uint256 iterations,
1162     	uint256 claims,
1163         uint256 lastProcessedIndex,
1164     	bool indexed automatic,
1165     	uint256 gas,
1166     	address indexed processor
1167     );
1168 
1169     event RequestedLPWithdraw();
1170     
1171     event WithdrewLPForMigration();
1172 
1173     event CanceledLpWithdrawRequest();
1174 
1175     constructor() ERC20("Pyramid Protocol", "PYRAMID") {
1176 
1177         uint256 totalSupply = 100 * 1e9 * 1e18;
1178         
1179         maxTransactionAmount = totalSupply * 10 / 1000;
1180         swapTokensAtAmount = totalSupply * 5 / 10000;
1181         maxWallet = totalSupply * 10 / 1000;
1182 
1183         rewardsBuyFee = 60;
1184         liquidityBuyFee = 10;
1185         totalBuyFees = rewardsBuyFee + liquidityBuyFee;
1186         
1187         rewardsSellFee = 60;
1188         liquiditySellFee = 10;
1189         totalSellFees = rewardsSellFee + liquiditySellFee;
1190 
1191     	dividendTracker = new DividendTracker();
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
1261     function updateBuyFees(uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1262         rewardsBuyFee = _rewardsFee;
1263         liquidityBuyFee = _liquidityFee;
1264         totalBuyFees = rewardsBuyFee + liquidityBuyFee;
1265         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1266     }
1267     
1268     function updateSellFees(uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1269         rewardsSellFee = _rewardsFee;
1270         liquiditySellFee = _liquidityFee;
1271         totalSellFees = rewardsSellFee + liquiditySellFee;
1272         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1273     }
1274 
1275     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1276         _isExcludedMaxTransactionAmount[updAds] = isEx;
1277         emit ExcludedMaxTransactionAmount(updAds, isEx);
1278     }
1279 
1280     function excludeFromFees(address account, bool excluded) public onlyOwner {
1281         _isExcludedFromFees[account] = excluded;
1282 
1283         emit ExcludeFromFees(account, excluded);
1284     }
1285 
1286     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1287         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1288 
1289         _setAutomatedMarketMakerPair(pair, value);
1290     }
1291 
1292     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1293         automatedMarketMakerPairs[pair] = value;
1294 
1295         excludeFromMaxTransaction(pair, value);
1296         
1297         if(value) {
1298             dividendTracker.excludeFromDividends(pair);
1299         }
1300 
1301         emit SetAutomatedMarketMakerPair(pair, value);
1302     }
1303 
1304     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1305         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1306         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1307         emit GasForProcessingUpdated(newValue, gasForProcessing);
1308         gasForProcessing = newValue;
1309     }
1310 
1311     function updateClaimWait(uint256 claimWait) external onlyOwner {
1312         dividendTracker.updateClaimWait(claimWait);
1313     }
1314 
1315     function getClaimWait() external view returns(uint256) {
1316         return dividendTracker.claimWait();
1317     }
1318 
1319     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1320         return dividendTracker.totalDividendsDistributed(rewardToken);
1321     }
1322 
1323     function isExcludedFromFees(address account) external view returns(bool) {
1324         return _isExcludedFromFees[account];
1325     }
1326 
1327     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1328     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1329   	}
1330 
1331 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1332 		return dividendTracker.holderBalance(account);
1333 	}
1334 
1335  /*
1336 
1337 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1338         external view returns (
1339             address,
1340             int256,
1341             int256,
1342             uint256,
1343             uint256,
1344             uint256,
1345             uint256,
1346             uint256) {
1347     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1348     }
1349 
1350     */
1351 
1352 	function processDividendTracker(uint256 gas) external {
1353 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1354 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1355     }
1356 
1357     function claim() external {
1358 		dividendTracker.processAccount(payable(msg.sender), false);
1359     }
1360 
1361     function getLastProcessedIndex() external view returns(uint256) {
1362     	return dividendTracker.getLastProcessedIndex();
1363     }
1364 
1365     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1366         return dividendTracker.getNumberOfTokenHolders();
1367     }
1368     
1369     function getNumberOfDividends() external view returns(uint256) {
1370         return dividendTracker.totalBalance();
1371     }
1372     
1373     function removeLimits() external onlyOwner returns (bool){
1374         limitsInEffect = false;
1375         return true;
1376     }
1377     
1378     function _transfer(
1379         address from,
1380         address to,
1381         uint256 amount
1382     ) internal override {
1383         require(from != address(0), "ERC20: transfer from the zero address");
1384         require(to != address(0), "ERC20: transfer to the zero address");
1385         
1386          if(amount == 0) {
1387             super._transfer(from, to, 0);
1388             return;
1389         }
1390         
1391         if(!tradingActive){
1392             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1393         }
1394         
1395         if(limitsInEffect){
1396             if (
1397                 from != owner() &&
1398                 to != owner() &&
1399                 to != address(0) &&
1400                 to != address(0xdead) &&
1401                 !swapping
1402             ){
1403                 
1404                 //when buy
1405                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1406                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1407                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1408                 } 
1409                 //when sell
1410                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1411                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1412                 }
1413                 else if(!_isExcludedMaxTransactionAmount[to]) {
1414                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1415                 }
1416             }
1417         }
1418 
1419 		uint256 contractTokenBalance = balanceOf(address(this));
1420         
1421         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1422 
1423         if( 
1424             canSwap &&
1425             swapEnabled &&
1426             !swapping &&
1427             !automatedMarketMakerPairs[from] &&
1428             !_isExcludedFromFees[from] &&
1429             !_isExcludedFromFees[to]
1430         ) {
1431             swapping = true;
1432             swapBack();
1433             swapping = false;
1434         }
1435 
1436         bool takeFee = !swapping;
1437 
1438         // if any account belongs to _isExcludedFromFee account then remove the fee
1439         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1440             takeFee = false;
1441         }
1442         
1443         uint256 fees = 0;
1444         
1445         // no taxes on transfers (non buys/sells)
1446         if(takeFee){
1447             
1448 
1449             // on sell
1450             if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1451                 fees = amount.mul(totalSellFees).div(feeDivisor);
1452                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1453                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1454             }
1455             
1456             // on buy
1457             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1458         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1459         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1460                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1461             }
1462 
1463             if(fees > 0){    
1464                 super._transfer(from, address(this), fees);
1465             }
1466         	
1467         	amount -= fees;
1468         }
1469 
1470         super._transfer(from, to, amount);
1471 
1472         dividendTracker.setBalance(payable(from), balanceOf(from));
1473         dividendTracker.setBalance(payable(to), balanceOf(to));
1474 
1475         if(!swapping && gasForProcessing > 0) {
1476 	    	uint256 gas = gasForProcessing;
1477 
1478 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1479 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1480 	    	}
1481 	    	catch {}
1482         }
1483     }
1484     
1485     function swapTokensForEth(uint256 tokenAmount) private {
1486 
1487         // generate the uniswap pair path of token -> weth
1488         address[] memory path = new address[](2);
1489         path[0] = address(this);
1490         path[1] = uniswapV2Router.WETH();
1491 
1492         _approve(address(this), address(uniswapV2Router), tokenAmount);
1493 
1494         // make the swap
1495         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1496             tokenAmount,
1497             0, // accept any amount of ETH
1498             path,
1499             address(this),
1500             block.timestamp
1501         );
1502         
1503     }
1504     
1505     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1506         // approve token transfer to cover all possible scenarios
1507         _approve(address(this), address(uniswapV2Router), tokenAmount);
1508 
1509         // add the liquidity
1510         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1511             address(this),
1512             tokenAmount,
1513             0, // slippage is unavoidable
1514             0, // slippage is unavoidable
1515             address(0xdead),
1516             block.timestamp
1517         );
1518 
1519     }
1520     
1521     function swapBack() private {
1522         uint256 contractBalance = balanceOf(address(this));
1523         uint256 totalTokensToSwap = tokensForLiquidity + tokensForRewards;
1524         
1525         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1526         
1527         // Halve the amount of liquidity tokens
1528         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1529         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1530         
1531         uint256 initialETHBalance = address(this).balance;
1532 
1533         swapTokensForEth(amountToSwapForETH); 
1534         
1535         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1536         
1537         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1538         
1539         uint256 ethForLiquidity = ethBalance - ethForRewards;
1540         
1541         tokensForLiquidity = 0;
1542         tokensForRewards = 0;
1543         
1544         
1545         
1546         if(liquidityTokens > 0 && ethForLiquidity > 0){
1547             addLiquidity(liquidityTokens, ethForLiquidity);
1548             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1549         }
1550         
1551         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1552     }
1553 
1554     function withdrawStuckEth() external onlyOwner {
1555         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1556         require(success, "failed to withdraw");
1557     }
1558 
1559   
1560 
1561     function nextAvailableLpWithdrawDate() public view returns (uint256){
1562         if(lpWithdrawRequestPending){
1563             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1564         }
1565         else {
1566             return 0;  // 0 means no open requests
1567         }
1568     }
1569 
1570     function withdrawRequestedLP() external onlyOwner {
1571         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1572         lpWithdrawRequestTimestamp = 0;
1573         lpWithdrawRequestPending = false;
1574 
1575         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1576         
1577         lpPercToWithDraw = 0;
1578 
1579         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1580     }
1581 
1582    
1583 }