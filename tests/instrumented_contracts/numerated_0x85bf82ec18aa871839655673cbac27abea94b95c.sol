1 /*
2  Liquidity Dao - LIQUIDITY Token Contract 
3  
4  Twitter - https://twitter.com/liquidity_DAO
5  Telegram - https://t.me/LiquidityDao
6  Website - liquiditydao.io
7 */  
8 // SPDX-License-Identifier: MIT 
9 pragma solidity 0.8.13;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 interface IUniswapV2Factory {
23     function createPair(address tokenA, address tokenB) external returns (address pair);
24 }
25 
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address sender,
82         address recipient,
83         uint256 amount
84     ) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     mapping(address => uint256) private _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123 
124     uint256 private _totalSupply;
125 
126     string private _name;
127     string private _symbol;
128 
129     constructor(string memory name_, string memory symbol_) {
130         _name = name_;
131         _symbol = symbol_;
132     }
133 
134     function name() public view virtual override returns (string memory) {
135         return _name;
136     }
137 
138     function symbol() public view virtual override returns (string memory) {
139         return _symbol;
140     }
141 
142     function decimals() public view virtual override returns (uint8) {
143         return 18;
144     }
145 
146     function totalSupply() public view virtual override returns (uint256) {
147         return _totalSupply;
148     }
149 
150     function balanceOf(address account) public view virtual override returns (uint256) {
151         return _balances[account];
152     }
153 
154     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
155         _transfer(_msgSender(), recipient, amount);
156         return true;
157     }
158 
159     function allowance(address owner, address spender) public view virtual override returns (uint256) {
160         return _allowances[owner][spender];
161     }
162 
163     function approve(address spender, uint256 amount) public virtual override returns (bool) {
164         _approve(_msgSender(), spender, amount);
165         return true;
166     }
167 
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) public virtual override returns (bool) {
173         _transfer(sender, recipient, amount);
174 
175         uint256 currentAllowance = _allowances[sender][_msgSender()];
176         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
177         unchecked {
178             _approve(sender, _msgSender(), currentAllowance - amount);
179         }
180 
181         return true;
182     }
183 
184     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
185         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
186         return true;
187     }
188 
189     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
190         uint256 currentAllowance = _allowances[_msgSender()][spender];
191         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
192         unchecked {
193             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
194         }
195 
196         return true;
197     }
198 
199     function _transfer(
200         address sender,
201         address recipient,
202         uint256 amount
203     ) internal virtual {
204         require(sender != address(0), "ERC20: transfer from the zero address");
205         require(recipient != address(0), "ERC20: transfer to the zero address");
206 
207         uint256 senderBalance = _balances[sender];
208         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
209         unchecked {
210             _balances[sender] = senderBalance - amount;
211         }
212         _balances[recipient] += amount;
213 
214         emit Transfer(sender, recipient, amount);
215     }
216 
217     function _createInitialSupply(address account, uint256 amount) internal virtual {
218         require(account != address(0), "ERC20: mint to the zero address");
219         _totalSupply += amount;
220         _balances[account] += amount;
221         emit Transfer(address(0), account, amount);
222     }
223 
224     function _approve(
225         address owner,
226         address spender,
227         uint256 amount
228     ) internal virtual {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231 
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 }
236 
237 interface DividendPayingTokenOptionalInterface {
238   /// @notice View the amount of dividend in wei that an address can withdraw.
239   /// @param _owner The address of a token holder.
240   /// @return The amount of dividend in wei that `_owner` can withdraw.
241   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
242 
243   /// @notice View the amount of dividend in wei that an address has withdrawn.
244   /// @param _owner The address of a token holder.
245   /// @return The amount of dividend in wei that `_owner` has withdrawn.
246   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
247 
248   /// @notice View the amount of dividend in wei that an address has earned in total.
249   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
250   /// @param _owner The address of a token holder.
251   /// @return The amount of dividend in wei that `_owner` has earned in total.
252   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
253 }
254 
255 interface DividendPayingTokenInterface {
256   /// @notice View the amount of dividend in wei that an address can withdraw.
257   /// @param _owner The address of a token holder.
258   /// @return The amount of dividend in wei that `_owner` can withdraw.
259   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
260 
261   /// @notice Distributes ether to token holders as dividends.
262   /// @dev SHOULD distribute the paid ether to token holders as dividends.
263   ///  SHOULD NOT directly transfer ether to token holders in this function.
264   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
265   function distributeDividends() external payable;
266 
267   /// @notice Withdraws the ether distributed to the sender.
268   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
269   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
270   function withdrawDividend(address _rewardToken) external;
271 
272   /// @dev This event MUST emit when ether is distributed to token holders.
273   /// @param from The address which sends ether to this contract.
274   /// @param weiAmount The amount of distributed ether in wei.
275   event DividendsDistributed(
276     address indexed from,
277     uint256 weiAmount
278   );
279 
280   /// @dev This event MUST emit when an address withdraws their dividend.
281   /// @param to The address which withdraws ether from this contract.
282   /// @param weiAmount The amount of withdrawn ether in wei.
283   event DividendWithdrawn(
284     address indexed to,
285     uint256 weiAmount
286   );
287 }
288 
289 library SafeMath {
290     /**
291      * @dev Returns the addition of two unsigned integers, reverting on
292      * overflow.
293      *
294      * Counterpart to Solidity's `+` operator.
295      *
296      * Requirements:
297      *
298      * - Addition cannot overflow.
299      */
300     function add(uint256 a, uint256 b) internal pure returns (uint256) {
301         uint256 c = a + b;
302         require(c >= a, "SafeMath: addition overflow");
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the subtraction of two unsigned integers, reverting on
309      * overflow (when the result is negative).
310      *
311      * Counterpart to Solidity's `-` operator.
312      *
313      * Requirements:
314      *
315      * - Subtraction cannot overflow.
316      */
317     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
318         return sub(a, b, "SafeMath: subtraction overflow");
319     }
320 
321     /**
322      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
323      * overflow (when the result is negative).
324      *
325      * Counterpart to Solidity's `-` operator.
326      *
327      * Requirements:
328      *
329      * - Subtraction cannot overflow.
330      */
331     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         require(b <= a, errorMessage);
333         uint256 c = a - b;
334 
335         return c;
336     }
337 
338     /**
339      * @dev Returns the multiplication of two unsigned integers, reverting on
340      * overflow.
341      *
342      * Counterpart to Solidity's `*` operator.
343      *
344      * Requirements:
345      *
346      * - Multiplication cannot overflow.
347      */
348     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
349         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
350         // benefit is lost if 'b' is also tested.
351         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
352         if (a == 0) {
353             return 0;
354         }
355 
356         uint256 c = a * b;
357         require(c / a == b, "SafeMath: multiplication overflow");
358 
359         return c;
360     }
361 
362     /**
363      * @dev Returns the integer division of two unsigned integers. Reverts on
364      * division by zero. The result is rounded towards zero.
365      *
366      * Counterpart to Solidity's `/` operator. Note: this function uses a
367      * `revert` opcode (which leaves remaining gas untouched) while Solidity
368      * uses an invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      *
372      * - The divisor cannot be zero.
373      */
374     function div(uint256 a, uint256 b) internal pure returns (uint256) {
375         return div(a, b, "SafeMath: division by zero");
376     }
377 
378     /**
379      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
380      * division by zero. The result is rounded towards zero.
381      *
382      * Counterpart to Solidity's `/` operator. Note: this function uses a
383      * `revert` opcode (which leaves remaining gas untouched) while Solidity
384      * uses an invalid opcode to revert (consuming all remaining gas).
385      *
386      * Requirements:
387      *
388      * - The divisor cannot be zero.
389      */
390     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
391         require(b > 0, errorMessage);
392         uint256 c = a / b;
393         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
394 
395         return c;
396     }
397 
398     /**
399      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
400      * Reverts when dividing by zero.
401      *
402      * Counterpart to Solidity's `%` operator. This function uses a `revert`
403      * opcode (which leaves remaining gas untouched) while Solidity uses an
404      * invalid opcode to revert (consuming all remaining gas).
405      *
406      * Requirements:
407      *
408      * - The divisor cannot be zero.
409      */
410     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
411         return mod(a, b, "SafeMath: modulo by zero");
412     }
413 
414     /**
415      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
416      * Reverts with custom message when dividing by zero.
417      *
418      * Counterpart to Solidity's `%` operator. This function uses a `revert`
419      * opcode (which leaves remaining gas untouched) while Solidity uses an
420      * invalid opcode to revert (consuming all remaining gas).
421      *
422      * Requirements:
423      *
424      * - The divisor cannot be zero.
425      */
426     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
427         require(b != 0, errorMessage);
428         return a % b;
429     }
430 }
431 
432 contract Ownable is Context {
433     address private _owner;
434 
435     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
436     
437     /**
438      * @dev Initializes the contract setting the deployer as the initial owner.
439      */
440     constructor () {
441         address msgSender = _msgSender();
442         _owner = msgSender;
443         emit OwnershipTransferred(address(0), msgSender);
444     }
445 
446     /**
447      * @dev Returns the address of the current owner.
448      */
449     function owner() public view returns (address) {
450         return _owner;
451     }
452 
453     /**
454      * @dev Throws if called by any account other than the owner.
455      */
456     modifier onlyOwner() {
457         require(_owner == _msgSender(), "Ownable: caller is not the owner");
458         _;
459     }
460 
461     /**
462      * @dev Leaves the contract without owner. It will not be possible to call
463      * `onlyOwner` functions anymore. Can only be called by the current owner.
464      *
465      * NOTE: Renouncing ownership will leave the contract without an owner,
466      * thereby removing any functionality that is only available to the owner.
467      */
468     function renounceOwnership() public virtual onlyOwner {
469         emit OwnershipTransferred(_owner, address(0));
470         _owner = address(0);
471     }
472 
473     /**
474      * @dev Transfers ownership of the contract to a new account (`newOwner`).
475      * Can only be called by the current owner.
476      */
477     function transferOwnership(address newOwner) public virtual onlyOwner {
478         require(newOwner != address(0), "Ownable: new owner is the zero address");
479         emit OwnershipTransferred(_owner, newOwner);
480         _owner = newOwner;
481     }
482 }
483 
484 
485 
486 library SafeMathInt {
487     int256 private constant MIN_INT256 = int256(1) << 255;
488     int256 private constant MAX_INT256 = ~(int256(1) << 255);
489 
490     /**
491      * @dev Multiplies two int256 variables and fails on overflow.
492      */
493     function mul(int256 a, int256 b) internal pure returns (int256) {
494         int256 c = a * b;
495 
496         // Detect overflow when multiplying MIN_INT256 with -1
497         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
498         require((b == 0) || (c / b == a));
499         return c;
500     }
501 
502     /**
503      * @dev Division of two int256 variables and fails on overflow.
504      */
505     function div(int256 a, int256 b) internal pure returns (int256) {
506         // Prevent overflow when dividing MIN_INT256 by -1
507         require(b != -1 || a != MIN_INT256);
508 
509         // Solidity already throws when dividing by 0.
510         return a / b;
511     }
512 
513     /**
514      * @dev Subtracts two int256 variables and fails on overflow.
515      */
516     function sub(int256 a, int256 b) internal pure returns (int256) {
517         int256 c = a - b;
518         require((b >= 0 && c <= a) || (b < 0 && c > a));
519         return c;
520     }
521 
522     /**
523      * @dev Adds two int256 variables and fails on overflow.
524      */
525     function add(int256 a, int256 b) internal pure returns (int256) {
526         int256 c = a + b;
527         require((b >= 0 && c >= a) || (b < 0 && c < a));
528         return c;
529     }
530 
531     /**
532      * @dev Converts to absolute value, and fails on overflow.
533      */
534     function abs(int256 a) internal pure returns (int256) {
535         require(a != MIN_INT256);
536         return a < 0 ? -a : a;
537     }
538 
539 
540     function toUint256Safe(int256 a) internal pure returns (uint256) {
541         require(a >= 0);
542         return uint256(a);
543     }
544 }
545 
546 library SafeMathUint {
547   function toInt256Safe(uint256 a) internal pure returns (int256) {
548     int256 b = int256(a);
549     require(b >= 0);
550     return b;
551   }
552 }
553 
554 
555 interface IUniswapV2Router01 {
556     function factory() external pure returns (address);
557     function WETH() external pure returns (address);
558 
559     function addLiquidity(
560         address tokenA,
561         address tokenB,
562         uint amountADesired,
563         uint amountBDesired,
564         uint amountAMin,
565         uint amountBMin,
566         address to,
567         uint deadline
568     ) external returns (uint amountA, uint amountB, uint liquidity);
569     function addLiquidityETH(
570         address token,
571         uint amountTokenDesired,
572         uint amountTokenMin,
573         uint amountETHMin,
574         address to,
575         uint deadline
576     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
577     function removeLiquidity(
578         address tokenA,
579         address tokenB,
580         uint liquidity,
581         uint amountAMin,
582         uint amountBMin,
583         address to,
584         uint deadline
585     ) external returns (uint amountA, uint amountB);
586     function removeLiquidityETH(
587         address token,
588         uint liquidity,
589         uint amountTokenMin,
590         uint amountETHMin,
591         address to,
592         uint deadline
593     ) external returns (uint amountToken, uint amountETH);
594     function removeLiquidityWithPermit(
595         address tokenA,
596         address tokenB,
597         uint liquidity,
598         uint amountAMin,
599         uint amountBMin,
600         address to,
601         uint deadline,
602         bool approveMax, uint8 v, bytes32 r, bytes32 s
603     ) external returns (uint amountA, uint amountB);
604     function removeLiquidityETHWithPermit(
605         address token,
606         uint liquidity,
607         uint amountTokenMin,
608         uint amountETHMin,
609         address to,
610         uint deadline,
611         bool approveMax, uint8 v, bytes32 r, bytes32 s
612     ) external returns (uint amountToken, uint amountETH);
613     function swapExactTokensForTokens(
614         uint amountIn,
615         uint amountOutMin,
616         address[] calldata path,
617         address to,
618         uint deadline
619     ) external returns (uint[] memory amounts);
620     function swapTokensForExactTokens(
621         uint amountOut,
622         uint amountInMax,
623         address[] calldata path,
624         address to,
625         uint deadline
626     ) external returns (uint[] memory amounts);
627     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
628         external
629         payable
630         returns (uint[] memory amounts);
631     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
632         external
633         returns (uint[] memory amounts);
634     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
635         external
636         returns (uint[] memory amounts);
637     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
638         external
639         payable
640         returns (uint[] memory amounts);
641 
642     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
643     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
644     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
645     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
646     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
647 }
648 
649 interface IUniswapV2Router02 is IUniswapV2Router01 {
650     function removeLiquidityETHSupportingFeeOnTransferTokens(
651         address token,
652         uint liquidity,
653         uint amountTokenMin,
654         uint amountETHMin,
655         address to,
656         uint deadline
657     ) external returns (uint amountETH);
658     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
659         address token,
660         uint liquidity,
661         uint amountTokenMin,
662         uint amountETHMin,
663         address to,
664         uint deadline,
665         bool approveMax, uint8 v, bytes32 r, bytes32 s
666     ) external returns (uint amountETH);
667 
668     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
669         uint amountIn,
670         uint amountOutMin,
671         address[] calldata path,
672         address to,
673         uint deadline
674     ) external;
675     function swapExactETHForTokensSupportingFeeOnTransferTokens(
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external payable;
681     function swapExactTokensForETHSupportingFeeOnTransferTokens(
682         uint amountIn,
683         uint amountOutMin,
684         address[] calldata path,
685         address to,
686         uint deadline
687     ) external;
688 }
689 
690 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
691   using SafeMath for uint256;
692   using SafeMathUint for uint256;
693   using SafeMathInt for int256;
694 
695   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
696   // For more discussion about choosing the value of `magnitude`,
697   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
698   uint256 constant internal magnitude = 2**128;
699 
700   mapping(address => uint256) internal magnifiedDividendPerShare;
701   address[] public rewardTokens;
702   address public nextRewardToken;
703   uint256 public rewardTokenCounter;
704   
705   IUniswapV2Router02 public immutable uniswapV2Router;
706   
707   
708   // About dividendCorrection:
709   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
710   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
711   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
712   //   `dividendOf(_user)` should not be changed,
713   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
714   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
715   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
716   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
717   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
718   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
719   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
720   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
721   
722   mapping (address => uint256) public holderBalance;
723   uint256 public totalBalance;
724 
725   mapping(address => uint256) public totalDividendsDistributed;
726   
727   constructor(){
728       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
729       uniswapV2Router = _uniswapV2Router; 
730       
731       // Mainnet
732 
733       rewardTokens.push(address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2)); // WETH - 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
734       
735       nextRewardToken = rewardTokens[0];
736   }
737 
738   
739 
740   /// @dev Distributes dividends whenever ether is paid to this contract.
741   receive() external payable {
742     distributeDividends();
743   }
744 
745   /// @notice Distributes ether to token holders as dividends.
746   /// @dev It reverts if the total supply of tokens is 0.
747   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
748   /// About undistributed ether:
749   ///   In each distribution, there is a small amount of ether not distributed,
750   ///     the magnified amount of which is
751   ///     `(msg.value * magnitude) % totalSupply()`.
752   ///   With a well-chosen `magnitude`, the amount of undistributed ether
753   ///     (de-magnified) in a distribution can be less than 1 wei.
754   ///   We can actually keep track of the undistributed ether in a distribution
755   ///     and try to distribute it in the next distribution,
756   ///     but keeping track of such data on-chain costs much more than
757   ///     the saved ether, so we don't do that.
758     
759   function distributeDividends() public override payable { 
760     require(totalBalance > 0);
761     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
762     buyTokens(msg.value, nextRewardToken);
763     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
764     if (newBalance > 0) {
765       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
766         (newBalance).mul(magnitude) / totalBalance
767       );
768       emit DividendsDistributed(msg.sender, newBalance);
769 
770       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
771     }
772     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
773     nextRewardToken = rewardTokens[rewardTokenCounter];
774   }
775   
776   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
777     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
778         // generate the uniswap pair path of weth -> eth
779         address[] memory path = new address[](2);
780         path[0] = uniswapV2Router.WETH();
781         path[1] = rewardToken;
782 
783         // make the swap
784         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
785             0, // accept any amount of Ethereum
786             path,
787             address(this),
788             block.timestamp
789         );
790     }
791   
792   /// @notice Withdraws the ether distributed to the sender.
793   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
794   function withdrawDividend(address _rewardToken) external virtual override {
795     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
796   }
797 
798   /// @notice Withdraws the ether distributed to the sender.
799   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
800   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
801     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
802     if (_withdrawableDividend > 0) {
803       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
804       emit DividendWithdrawn(user, _withdrawableDividend);
805       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
806       return _withdrawableDividend;
807     }
808 
809     return 0;
810   }
811 
812 
813   /// @notice View the amount of dividend in wei that an address can withdraw.
814   /// @param _owner The address of a token holder.
815   /// @return The amount of dividend in wei that `_owner` can withdraw.
816   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
817     return withdrawableDividendOf(_owner, _rewardToken);
818   }
819 
820   /// @notice View the amount of dividend in wei that an address can withdraw.
821   /// @param _owner The address of a token holder.
822   /// @return The amount of dividend in wei that `_owner` can withdraw.
823   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
824     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
825   }
826 
827   /// @notice View the amount of dividend in wei that an address has withdrawn.
828   /// @param _owner The address of a token holder.
829   /// @return The amount of dividend in wei that `_owner` has withdrawn.
830   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
831     return withdrawnDividends[_owner][_rewardToken];
832   }
833 
834 
835   /// @notice View the amount of dividend in wei that an address has earned in total.
836   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
837   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
838   /// @param _owner The address of a token holder.
839   /// @return The amount of dividend in wei that `_owner` has earned in total.
840   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
841     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
842       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
843   }
844 
845   /// @dev Internal function that increases tokens to an account.
846   /// Update magnifiedDividendCorrections to keep dividends unchanged.
847   /// @param account The account that will receive the created tokens.
848   /// @param value The amount that will be created.
849   function _increase(address account, uint256 value) internal {
850     for (uint256 i; i < rewardTokens.length; i++){
851         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
852           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
853     }
854   }
855 
856   /// @dev Internal function that reduces an amount of the token of a given account.
857   /// Update magnifiedDividendCorrections to keep dividends unchanged.
858   /// @param account The account whose tokens will be burnt.
859   /// @param value The amount that will be burnt.
860   function _reduce(address account, uint256 value) internal {
861       for (uint256 i; i < rewardTokens.length; i++){
862         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
863           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
864       }
865   }
866 
867   function _setBalance(address account, uint256 newBalance) internal {
868     uint256 currentBalance = holderBalance[account];
869     holderBalance[account] = newBalance;
870     if(newBalance > currentBalance) {
871       uint256 increaseAmount = newBalance.sub(currentBalance);
872       _increase(account, increaseAmount);
873       totalBalance += increaseAmount;
874     } else if(newBalance < currentBalance) {
875       uint256 reduceAmount = currentBalance.sub(newBalance);
876       _reduce(account, reduceAmount);
877       totalBalance -= reduceAmount;
878     }
879   }
880 }
881 
882 contract DividendTracker is DividendPayingToken {
883     using SafeMath for uint256;
884     using SafeMathInt for int256;
885 
886     struct Map {
887         address[] keys;
888         mapping(address => uint) values;
889         mapping(address => uint) indexOf;
890         mapping(address => bool) inserted;
891     }
892 
893     function get(address key) private view returns (uint) {
894         return tokenHoldersMap.values[key];
895     }
896 
897     function getIndexOfKey(address key) private view returns (int) {
898         if(!tokenHoldersMap.inserted[key]) {
899             return -1;
900         }
901         return int(tokenHoldersMap.indexOf[key]);
902     }
903 
904     function getKeyAtIndex(uint index) private view returns (address) {
905         return tokenHoldersMap.keys[index];
906     }
907 
908 
909 
910     function size() private view returns (uint) {
911         return tokenHoldersMap.keys.length;
912     }
913 
914     function set(address key, uint val) private {
915         if (tokenHoldersMap.inserted[key]) {
916             tokenHoldersMap.values[key] = val;
917         } else {
918             tokenHoldersMap.inserted[key] = true;
919             tokenHoldersMap.values[key] = val;
920             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
921             tokenHoldersMap.keys.push(key);
922         }
923     }
924 
925     function remove(address key) private {
926         if (!tokenHoldersMap.inserted[key]) {
927             return;
928         }
929 
930         delete tokenHoldersMap.inserted[key];
931         delete tokenHoldersMap.values[key];
932 
933         uint index = tokenHoldersMap.indexOf[key];
934         uint lastIndex = tokenHoldersMap.keys.length - 1;
935         address lastKey = tokenHoldersMap.keys[lastIndex];
936 
937         tokenHoldersMap.indexOf[lastKey] = index;
938         delete tokenHoldersMap.indexOf[key];
939 
940         tokenHoldersMap.keys[index] = lastKey;
941         tokenHoldersMap.keys.pop();
942     }
943 
944     Map private tokenHoldersMap;
945     uint256 public lastProcessedIndex;
946 
947     mapping (address => bool) public excludedFromDividends;
948 
949     mapping (address => uint256) public lastClaimTimes;
950 
951     uint256 public claimWait;
952     uint256 public immutable minimumTokenBalanceForDividends;
953 
954     event ExcludeFromDividends(address indexed account);
955     event IncludeInDividends(address indexed account);
956     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
957 
958     event Claim(address indexed account, uint256 amount, bool indexed automatic);
959 
960     constructor() {
961     	claimWait = 1200;
962         minimumTokenBalanceForDividends = 1000 * (10**18);
963     }
964 
965     function excludeFromDividends(address account) external onlyOwner {
966     	excludedFromDividends[account] = true;
967 
968     	_setBalance(account, 0);
969     	remove(account);
970 
971     	emit ExcludeFromDividends(account);
972     }
973     
974     function includeInDividends(address account) external onlyOwner {
975     	require(excludedFromDividends[account]);
976     	excludedFromDividends[account] = false;
977 
978     	emit IncludeInDividends(account);
979     }
980 
981     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
982         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
983         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
984         emit ClaimWaitUpdated(newClaimWait, claimWait);
985         claimWait = newClaimWait;
986     }
987 
988     function getLastProcessedIndex() external view returns(uint256) {
989     	return lastProcessedIndex;
990     }
991 
992     function getNumberOfTokenHolders() external view returns(uint256) {
993         return tokenHoldersMap.keys.length;
994     }
995 
996     // Check to see if I really made this contract or if it is a clone!
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
1053     	if(index >= size()) {
1054             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1055         }
1056 
1057         address account = getKeyAtIndex(index);
1058 
1059         return getAccount(account, _rewardToken);
1060     }
1061 
1062     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1063     	if(lastClaimTime > block.timestamp)  {
1064     		return false;
1065     	}
1066 
1067     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1068     }
1069 
1070     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1071     	if(excludedFromDividends[account]) {
1072     		return;
1073     	}
1074 
1075     	if(newBalance >= minimumTokenBalanceForDividends) {
1076             _setBalance(account, newBalance);
1077     		set(account, newBalance);
1078     	}
1079     	else {
1080             _setBalance(account, 0);
1081     		remove(account);
1082     	}
1083 
1084     	processAccount(account, true);
1085     }
1086     
1087     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1088     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1089 
1090     	if(numberOfTokenHolders == 0) {
1091     		return (0, 0, lastProcessedIndex);
1092     	}
1093 
1094     	uint256 _lastProcessedIndex = lastProcessedIndex;
1095 
1096     	uint256 gasUsed = 0;
1097 
1098     	uint256 gasLeft = gasleft();
1099 
1100     	uint256 iterations = 0;
1101     	uint256 claims = 0;
1102 
1103     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1104     		_lastProcessedIndex++;
1105 
1106     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1107     			_lastProcessedIndex = 0;
1108     		}
1109 
1110     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1111 
1112     		if(canAutoClaim(lastClaimTimes[account])) {
1113     			if(processAccount(payable(account), true)) {
1114     				claims++;
1115     			}
1116     		}
1117 
1118     		iterations++;
1119 
1120     		uint256 newGasLeft = gasleft();
1121 
1122     		if(gasLeft > newGasLeft) {
1123     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1124     		}
1125     		gasLeft = newGasLeft;
1126     	}
1127 
1128     	lastProcessedIndex = _lastProcessedIndex;
1129 
1130     	return (iterations, claims, lastProcessedIndex);
1131     }
1132 
1133     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1134         uint256 amount;
1135         bool paid;
1136         for (uint256 i; i < rewardTokens.length; i++){
1137             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1138             if(amount > 0) {
1139         		lastClaimTimes[account] = block.timestamp;
1140                 emit Claim(account, amount, automatic);
1141                 paid = true;
1142     	    }
1143         }
1144         return paid;
1145     }
1146 }
1147 
1148 contract LIQUIDITY is ERC20, Ownable {
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
1160     uint256 public maxTransactionAmount;
1161     uint256 public swapTokensAtAmount;
1162     uint256 public maxWallet;
1163     
1164     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1165     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1166     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1167     
1168     bool public limitsInEffect = true;
1169     bool public tradingActive = false;
1170     bool public swapEnabled = false;
1171     
1172      // Anti-bot and anti-whale mappings and variables
1173     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1174     bool public transferDelayEnabled = true;
1175     
1176     uint256 public constant feeDivisor = 1000;
1177 
1178     uint256 public totalSellFees;
1179     uint256 public rewardsSellFee;
1180     uint256 public operationsSellFee;
1181     uint256 public liquiditySellFee;
1182     
1183     uint256 public totalBuyFees;
1184     uint256 public rewardsBuyFee;
1185     uint256 public operationsBuyFee;
1186     uint256 public liquidityBuyFee;
1187     
1188     uint256 public tokensForRewards;
1189     uint256 public tokensForOperations;
1190     uint256 public tokensForLiquidity;
1191     
1192     uint256 public gasForProcessing = 0;
1193 
1194     uint256 public lpWithdrawRequestTimestamp;
1195     uint256 public lpWithdrawRequestDuration = 3 days;
1196     bool public lpWithdrawRequestPending;
1197     uint256 public lpPercToWithDraw;
1198 
1199     /******************/
1200 
1201     // exlcude from fees and max transaction amount
1202     mapping (address => bool) private _isExcludedFromFees;
1203 
1204     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1205 
1206     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1207     // could be subject to a maximum transfer amount
1208     mapping (address => bool) public automatedMarketMakerPairs;
1209 
1210     event ExcludeFromFees(address indexed account, bool isExcluded);
1211     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1212     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1213 
1214     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1215 
1216     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1217 
1218     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1219 
1220     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1221     
1222     event SwapAndLiquify(
1223         uint256 tokensSwapped,
1224         uint256 ethReceived,
1225         uint256 tokensIntoLiqudity
1226     );
1227 
1228     event SendDividends(
1229     	uint256 tokensSwapped,
1230     	uint256 amount
1231     );
1232 
1233     event ProcessedDividendTracker(
1234     	uint256 iterations,
1235     	uint256 claims,
1236         uint256 lastProcessedIndex,
1237     	bool indexed automatic,
1238     	uint256 gas,
1239     	address indexed processor
1240     );
1241 
1242     event RequestedLPWithdraw();
1243     
1244     event WithdrewLPForMigration();
1245 
1246     event CanceledLpWithdrawRequest();
1247 
1248     constructor() ERC20("Liquidity Dao", "LIQUIDITY") {
1249 
1250         uint256 totalSupply = 1000 * 1e6 * 1e18;
1251         
1252         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
1253         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
1254         maxWallet = totalSupply * 5 / 1000; // 0.5% Max wallet
1255 
1256         rewardsBuyFee = 30;
1257         operationsBuyFee = 40;
1258         liquidityBuyFee = 0;
1259         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1260         
1261         rewardsSellFee = 30;
1262         operationsSellFee = 40;
1263         liquiditySellFee = 0;
1264         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1265 
1266     	dividendTracker = new DividendTracker();
1267     	
1268     	operationsWallet = address(0x6BEaD42136eE5E854b5F7069e19F63367b1b9400); // set as operations wallet
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
1341     function updateMaxAmount(uint256 newNum) external onlyOwner {
1342         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1343         maxTransactionAmount = newNum * (10**18);
1344     }
1345     
1346     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1347         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1348         maxWallet = newNum * (10**18);
1349     }
1350     
1351     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1352         operationsBuyFee = _operationsFee;
1353         rewardsBuyFee = _rewardsFee;
1354         liquidityBuyFee = _liquidityFee;
1355         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1356         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1357     }
1358     
1359     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1360         operationsSellFee = _operationsFee;
1361         rewardsSellFee = _rewardsFee;
1362         liquiditySellFee = _liquidityFee;
1363         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1364         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1365     }
1366 
1367     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1368         _isExcludedMaxTransactionAmount[updAds] = isEx;
1369         emit ExcludedMaxTransactionAmount(updAds, isEx);
1370     }
1371 
1372     function excludeFromFees(address account, bool excluded) public onlyOwner {
1373         _isExcludedFromFees[account] = excluded;
1374 
1375         emit ExcludeFromFees(account, excluded);
1376     }
1377 
1378     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1379         for(uint256 i = 0; i < accounts.length; i++) {
1380             _isExcludedFromFees[accounts[i]] = excluded;
1381         }
1382 
1383         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1384     }
1385 
1386     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1387         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1388 
1389         _setAutomatedMarketMakerPair(pair, value);
1390     }
1391 
1392     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1393         automatedMarketMakerPairs[pair] = value;
1394 
1395         excludeFromMaxTransaction(pair, value);
1396         
1397         if(value) {
1398             dividendTracker.excludeFromDividends(pair);
1399         }
1400 
1401         emit SetAutomatedMarketMakerPair(pair, value);
1402     }
1403 
1404     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1405         require(newOperationsWallet != address(0), "may not set to 0 address");
1406         excludeFromFees(newOperationsWallet, true);
1407         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1408         operationsWallet = newOperationsWallet;
1409     }
1410 
1411     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1412         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1413         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1414         emit GasForProcessingUpdated(newValue, gasForProcessing);
1415         gasForProcessing = newValue;
1416     }
1417 
1418     function updateClaimWait(uint256 claimWait) external onlyOwner {
1419         dividendTracker.updateClaimWait(claimWait);
1420     }
1421 
1422     function getClaimWait() external view returns(uint256) {
1423         return dividendTracker.claimWait();
1424     }
1425 
1426     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1427         return dividendTracker.totalDividendsDistributed(rewardToken);
1428     }
1429 
1430     function isExcludedFromFees(address account) external view returns(bool) {
1431         return _isExcludedFromFees[account];
1432     }
1433 
1434     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1435     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1436   	}
1437 
1438 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1439 		return dividendTracker.holderBalance(account);
1440 	}
1441 
1442     function getAccountDividendsInfo(address account, address rewardToken)
1443         external view returns (
1444             address,
1445             int256,
1446             int256,
1447             uint256,
1448             uint256,
1449             uint256,
1450             uint256,
1451             uint256) {
1452         return dividendTracker.getAccount(account, rewardToken);
1453     }
1454 
1455 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1456         external view returns (
1457             address,
1458             int256,
1459             int256,
1460             uint256,
1461             uint256,
1462             uint256,
1463             uint256,
1464             uint256) {
1465     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1466     }
1467 
1468 	function processDividendTracker(uint256 gas) external {
1469 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1470 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1471     }
1472 
1473     function claim() external {
1474 		dividendTracker.processAccount(payable(msg.sender), false);
1475     }
1476 
1477     function getLastProcessedIndex() external view returns(uint256) {
1478     	return dividendTracker.getLastProcessedIndex();
1479     }
1480 
1481     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1482         return dividendTracker.getNumberOfTokenHolders();
1483     }
1484     
1485     function getNumberOfDividends() external view returns(uint256) {
1486         return dividendTracker.totalBalance();
1487     }
1488     
1489     // remove limits after token is stable
1490     function removeLimits() external onlyOwner returns (bool){
1491         limitsInEffect = false;
1492         transferDelayEnabled = false;
1493         return true;
1494     }
1495     
1496     function _transfer(
1497         address from,
1498         address to,
1499         uint256 amount
1500     ) internal override {
1501         require(from != address(0), "ERC20: transfer from the zero address");
1502         require(to != address(0), "ERC20: transfer to the zero address");
1503         
1504          if(amount == 0) {
1505             super._transfer(from, to, 0);
1506             return;
1507         }
1508         
1509         if(!tradingActive){
1510             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1511         }
1512         
1513         if(limitsInEffect){
1514             if (
1515                 from != owner() &&
1516                 to != owner() &&
1517                 to != address(0) &&
1518                 to != address(0xdead) &&
1519                 !swapping
1520             ){
1521 
1522                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1523                 if (transferDelayEnabled){
1524                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1525                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1526                         _holderLastTransferTimestamp[tx.origin] = block.number;
1527                     }
1528                 }
1529                 
1530                 //when buy
1531                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1532                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1533                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1534                 } 
1535                 //when sell
1536                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1537                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1538                 }
1539                 else if(!_isExcludedMaxTransactionAmount[to]) {
1540                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1541                 }
1542             }
1543         }
1544 
1545 		uint256 contractTokenBalance = balanceOf(address(this));
1546         
1547         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1548 
1549         if( 
1550             canSwap &&
1551             swapEnabled &&
1552             !swapping &&
1553             !automatedMarketMakerPairs[from] &&
1554             !_isExcludedFromFees[from] &&
1555             !_isExcludedFromFees[to]
1556         ) {
1557             swapping = true;
1558             swapBack();
1559             swapping = false;
1560         }
1561 
1562         bool takeFee = !swapping;
1563 
1564         // if any account belongs to _isExcludedFromFee account then remove the fee
1565         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1566             takeFee = false;
1567         }
1568         
1569         uint256 fees = 0;
1570         
1571         // no taxes on transfers (non buys/sells)
1572         if(takeFee){
1573             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1574                 fees = amount.mul(99).div(100);
1575                 tokensForLiquidity += fees * 33 / 99;
1576                 tokensForRewards += fees * 33 / 99;
1577                 tokensForOperations += fees * 33 / 99;
1578             }
1579 
1580             // on sell
1581             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1582                 fees = amount.mul(totalSellFees).div(feeDivisor);
1583                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1584                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1585                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1586             }
1587             
1588             // on buy
1589             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1590         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1591         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1592                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1593                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1594             }
1595 
1596             if(fees > 0){    
1597                 super._transfer(from, address(this), fees);
1598             }
1599         	
1600         	amount -= fees;
1601         }
1602 
1603         super._transfer(from, to, amount);
1604 
1605         dividendTracker.setBalance(payable(from), balanceOf(from));
1606         dividendTracker.setBalance(payable(to), balanceOf(to));
1607 
1608         if(!swapping && gasForProcessing > 0) {
1609 	    	uint256 gas = gasForProcessing;
1610 
1611 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1612 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1613 	    	}
1614 	    	catch {}
1615         }
1616     }
1617     
1618     function swapTokensForEth(uint256 tokenAmount) private {
1619 
1620         // generate the uniswap pair path of token -> weth
1621         address[] memory path = new address[](2);
1622         path[0] = address(this);
1623         path[1] = uniswapV2Router.WETH();
1624 
1625         _approve(address(this), address(uniswapV2Router), tokenAmount);
1626 
1627         // make the swap
1628         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1629             tokenAmount,
1630             0, // accept any amount of ETH
1631             path,
1632             address(this),
1633             block.timestamp
1634         );
1635         
1636     }
1637     
1638     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1639         // approve token transfer to cover all possible scenarios
1640         _approve(address(this), address(uniswapV2Router), tokenAmount);
1641 
1642         // add the liquidity
1643         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1644             address(this),
1645             tokenAmount,
1646             0, // slippage is unavoidable
1647             0, // slippage is unavoidable
1648             address(0xdead),
1649             block.timestamp
1650         );
1651 
1652     }
1653     
1654     function swapBack() private {
1655         uint256 contractBalance = balanceOf(address(this));
1656         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1657         
1658         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1659         
1660         // Halve the amount of liquidity tokens
1661         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1662         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1663         
1664         uint256 initialETHBalance = address(this).balance;
1665 
1666         swapTokensForEth(amountToSwapForETH); 
1667         
1668         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1669         
1670         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1671         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1672         
1673         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1674         
1675         tokensForLiquidity = 0;
1676         tokensForOperations = 0;
1677         tokensForRewards = 0;
1678         
1679         
1680         
1681         if(liquidityTokens > 0 && ethForLiquidity > 0){
1682             addLiquidity(liquidityTokens, ethForLiquidity);
1683             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1684         }
1685         
1686         // call twice to force buy of both reward tokens.
1687         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1688 
1689         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1690     }
1691 
1692     function withdrawStuckEth() external onlyOwner {
1693         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1694         require(success, "failed to withdraw");
1695     }
1696 
1697     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1698         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1699         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1700         lpWithdrawRequestTimestamp = block.timestamp;
1701         lpWithdrawRequestPending = true;
1702         lpPercToWithDraw = percToWithdraw;
1703         emit RequestedLPWithdraw();
1704     }
1705 
1706     function nextAvailableLpWithdrawDate() public view returns (uint256){
1707         if(lpWithdrawRequestPending){
1708             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1709         }
1710         else {
1711             return 0;  // 0 means no open requests
1712         }
1713     }
1714 
1715     function withdrawRequestedLP() external onlyOwner {
1716         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1717         lpWithdrawRequestTimestamp = 0;
1718         lpWithdrawRequestPending = false;
1719 
1720         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1721         
1722         lpPercToWithDraw = 0;
1723 
1724         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1725     }
1726 
1727     function cancelLPWithdrawRequest() external onlyOwner {
1728         lpWithdrawRequestPending = false;
1729         lpPercToWithDraw = 0;
1730         lpWithdrawRequestTimestamp = 0;
1731         emit CanceledLpWithdrawRequest();
1732     }
1733 }