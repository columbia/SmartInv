1 // SPDX-License-Identifier: MIT       
2 
3 /*
4    Limitless Utility Aggregator: Aggregating the best utility into a single token.
5 
6    Website: https://limitlessutility.net/
7    Telegram: https://t.me/limitlessutility
8 */
9 
10 
11 
12 pragma solidity 0.8.12;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IUniswapV2Factory {
26     function createPair(address tokenA, address tokenB) external returns (address pair);
27 }
28 
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 
122 contract ERC20 is Context, IERC20, IERC20Metadata {
123     mapping(address => uint256) private _balances;
124 
125     mapping(address => mapping(address => uint256)) private _allowances;
126 
127     uint256 private _totalSupply;
128 
129     string private _name;
130     string private _symbol;
131 
132     constructor(string memory name_, string memory symbol_) {
133         _name = name_;
134         _symbol = symbol_;
135     }
136 
137     function name() public view virtual override returns (string memory) {
138         return _name;
139     }
140 
141     function symbol() public view virtual override returns (string memory) {
142         return _symbol;
143     }
144 
145     function decimals() public view virtual override returns (uint8) {
146         return 18;
147     }
148 
149     function totalSupply() public view virtual override returns (uint256) {
150         return _totalSupply;
151     }
152 
153     function balanceOf(address account) public view virtual override returns (uint256) {
154         return _balances[account];
155     }
156 
157     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
158         _transfer(_msgSender(), recipient, amount);
159         return true;
160     }
161 
162     function allowance(address owner, address spender) public view virtual override returns (uint256) {
163         return _allowances[owner][spender];
164     }
165 
166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
167         _approve(_msgSender(), spender, amount);
168         return true;
169     }
170 
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) public virtual override returns (bool) {
176         _transfer(sender, recipient, amount);
177 
178         uint256 currentAllowance = _allowances[sender][_msgSender()];
179         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
180         unchecked {
181             _approve(sender, _msgSender(), currentAllowance - amount);
182         }
183 
184         return true;
185     }
186 
187     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
188         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
189         return true;
190     }
191 
192     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
193         uint256 currentAllowance = _allowances[_msgSender()][spender];
194         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
195         unchecked {
196             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
197         }
198 
199         return true;
200     }
201 
202     function _transfer(
203         address sender,
204         address recipient,
205         uint256 amount
206     ) internal virtual {
207         require(sender != address(0), "ERC20: transfer from the zero address");
208         require(recipient != address(0), "ERC20: transfer to the zero address");
209 
210         uint256 senderBalance = _balances[sender];
211         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
212         unchecked {
213             _balances[sender] = senderBalance - amount;
214         }
215         _balances[recipient] += amount;
216 
217         emit Transfer(sender, recipient, amount);
218     }
219 
220     function _createInitialSupply(address account, uint256 amount) internal virtual {
221         require(account != address(0), "ERC20: mint to the zero address");
222         _totalSupply += amount;
223         _balances[account] += amount;
224         emit Transfer(address(0), account, amount);
225     }
226 
227     function _approve(
228         address owner,
229         address spender,
230         uint256 amount
231     ) internal virtual {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234 
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 }
239 
240 interface DividendPayingTokenOptionalInterface {
241   /// @notice View the amount of dividend in wei that an address can withdraw.
242   /// @param _owner The address of a token holder.
243   /// @return The amount of dividend in wei that `_owner` can withdraw.
244   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
245 
246   /// @notice View the amount of dividend in wei that an address has withdrawn.
247   /// @param _owner The address of a token holder.
248   /// @return The amount of dividend in wei that `_owner` has withdrawn.
249   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
250 
251   /// @notice View the amount of dividend in wei that an address has earned in total.
252   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
253   /// @param _owner The address of a token holder.
254   /// @return The amount of dividend in wei that `_owner` has earned in total.
255   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
256 }
257 
258 interface DividendPayingTokenInterface {
259   /// @notice View the amount of dividend in wei that an address can withdraw.
260   /// @param _owner The address of a token holder.
261   /// @return The amount of dividend in wei that `_owner` can withdraw.
262   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
263 
264   /// @notice Distributes ether to token holders as dividends.
265   /// @dev SHOULD distribute the paid ether to token holders as dividends.
266   ///  SHOULD NOT directly transfer ether to token holders in this function.
267   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
268   function distributeDividends() external payable;
269 
270   /// @notice Withdraws the ether distributed to the sender.
271   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
272   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
273   function withdrawDividend(address _rewardToken) external;
274 
275   /// @dev This event MUST emit when ether is distributed to token holders.
276   /// @param from The address which sends ether to this contract.
277   /// @param weiAmount The amount of distributed ether in wei.
278   event DividendsDistributed(
279     address indexed from,
280     uint256 weiAmount
281   );
282 
283   /// @dev This event MUST emit when an address withdraws their dividend.
284   /// @param to The address which withdraws ether from this contract.
285   /// @param weiAmount The amount of withdrawn ether in wei.
286   event DividendWithdrawn(
287     address indexed to,
288     uint256 weiAmount
289   );
290 }
291 
292 library SafeMath {
293     /**
294      * @dev Returns the addition of two unsigned integers, reverting on
295      * overflow.
296      *
297      * Counterpart to Solidity's `+` operator.
298      *
299      * Requirements:
300      *
301      * - Addition cannot overflow.
302      */
303     function add(uint256 a, uint256 b) internal pure returns (uint256) {
304         uint256 c = a + b;
305         require(c >= a, "SafeMath: addition overflow");
306 
307         return c;
308     }
309 
310     /**
311      * @dev Returns the subtraction of two unsigned integers, reverting on
312      * overflow (when the result is negative).
313      *
314      * Counterpart to Solidity's `-` operator.
315      *
316      * Requirements:
317      *
318      * - Subtraction cannot overflow.
319      */
320     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
321         return sub(a, b, "SafeMath: subtraction overflow");
322     }
323 
324     /**
325      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
326      * overflow (when the result is negative).
327      *
328      * Counterpart to Solidity's `-` operator.
329      *
330      * Requirements:
331      *
332      * - Subtraction cannot overflow.
333      */
334     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         require(b <= a, errorMessage);
336         uint256 c = a - b;
337 
338         return c;
339     }
340 
341     /**
342      * @dev Returns the multiplication of two unsigned integers, reverting on
343      * overflow.
344      *
345      * Counterpart to Solidity's `*` operator.
346      *
347      * Requirements:
348      *
349      * - Multiplication cannot overflow.
350      */
351     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
352         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
353         // benefit is lost if 'b' is also tested.
354         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
355         if (a == 0) {
356             return 0;
357         }
358 
359         uint256 c = a * b;
360         require(c / a == b, "SafeMath: multiplication overflow");
361 
362         return c;
363     }
364 
365     /**
366      * @dev Returns the integer division of two unsigned integers. Reverts on
367      * division by zero. The result is rounded towards zero.
368      *
369      * Counterpart to Solidity's `/` operator. Note: this function uses a
370      * `revert` opcode (which leaves remaining gas untouched) while Solidity
371      * uses an invalid opcode to revert (consuming all remaining gas).
372      *
373      * Requirements:
374      *
375      * - The divisor cannot be zero.
376      */
377     function div(uint256 a, uint256 b) internal pure returns (uint256) {
378         return div(a, b, "SafeMath: division by zero");
379     }
380 
381     /**
382      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
383      * division by zero. The result is rounded towards zero.
384      *
385      * Counterpart to Solidity's `/` operator. Note: this function uses a
386      * `revert` opcode (which leaves remaining gas untouched) while Solidity
387      * uses an invalid opcode to revert (consuming all remaining gas).
388      *
389      * Requirements:
390      *
391      * - The divisor cannot be zero.
392      */
393     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
394         require(b > 0, errorMessage);
395         uint256 c = a / b;
396         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
397 
398         return c;
399     }
400 
401     /**
402      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
403      * Reverts when dividing by zero.
404      *
405      * Counterpart to Solidity's `%` operator. This function uses a `revert`
406      * opcode (which leaves remaining gas untouched) while Solidity uses an
407      * invalid opcode to revert (consuming all remaining gas).
408      *
409      * Requirements:
410      *
411      * - The divisor cannot be zero.
412      */
413     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
414         return mod(a, b, "SafeMath: modulo by zero");
415     }
416 
417     /**
418      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
419      * Reverts with custom message when dividing by zero.
420      *
421      * Counterpart to Solidity's `%` operator. This function uses a `revert`
422      * opcode (which leaves remaining gas untouched) while Solidity uses an
423      * invalid opcode to revert (consuming all remaining gas).
424      *
425      * Requirements:
426      *
427      * - The divisor cannot be zero.
428      */
429     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
430         require(b != 0, errorMessage);
431         return a % b;
432     }
433 }
434 
435 contract Ownable is Context {
436     address private _owner;
437 
438     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
439     
440     /**
441      * @dev Initializes the contract setting the deployer as the initial owner.
442      */
443     constructor () {
444         address msgSender = _msgSender();
445         _owner = msgSender;
446         emit OwnershipTransferred(address(0), msgSender);
447     }
448 
449     /**
450      * @dev Returns the address of the current owner.
451      */
452     function owner() public view returns (address) {
453         return _owner;
454     }
455 
456     /**
457      * @dev Throws if called by any account other than the owner.
458      */
459     modifier onlyOwner() {
460         require(_owner == _msgSender(), "Ownable: caller is not the owner");
461         _;
462     }
463 
464     /**
465      * @dev Leaves the contract without owner. It will not be possible to call
466      * `onlyOwner` functions anymore. Can only be called by the current owner.
467      *
468      * NOTE: Renouncing ownership will leave the contract without an owner,
469      * thereby removing any functionality that is only available to the owner.
470      */
471     function renounceOwnership() public virtual onlyOwner {
472         emit OwnershipTransferred(_owner, address(0));
473         _owner = address(0);
474     }
475 
476     /**
477      * @dev Transfers ownership of the contract to a new account (`newOwner`).
478      * Can only be called by the current owner.
479      */
480     function transferOwnership(address newOwner) public virtual onlyOwner {
481         require(newOwner != address(0), "Ownable: new owner is the zero address");
482         emit OwnershipTransferred(_owner, newOwner);
483         _owner = newOwner;
484     }
485 }
486 
487 
488 
489 library SafeMathInt {
490     int256 private constant MIN_INT256 = int256(1) << 255;
491     int256 private constant MAX_INT256 = ~(int256(1) << 255);
492 
493     /**
494      * @dev Multiplies two int256 variables and fails on overflow.
495      */
496     function mul(int256 a, int256 b) internal pure returns (int256) {
497         int256 c = a * b;
498 
499         // Detect overflow when multiplying MIN_INT256 with -1
500         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
501         require((b == 0) || (c / b == a));
502         return c;
503     }
504 
505     /**
506      * @dev Division of two int256 variables and fails on overflow.
507      */
508     function div(int256 a, int256 b) internal pure returns (int256) {
509         // Prevent overflow when dividing MIN_INT256 by -1
510         require(b != -1 || a != MIN_INT256);
511 
512         // Solidity already throws when dividing by 0.
513         return a / b;
514     }
515 
516     /**
517      * @dev Subtracts two int256 variables and fails on overflow.
518      */
519     function sub(int256 a, int256 b) internal pure returns (int256) {
520         int256 c = a - b;
521         require((b >= 0 && c <= a) || (b < 0 && c > a));
522         return c;
523     }
524 
525     /**
526      * @dev Adds two int256 variables and fails on overflow.
527      */
528     function add(int256 a, int256 b) internal pure returns (int256) {
529         int256 c = a + b;
530         require((b >= 0 && c >= a) || (b < 0 && c < a));
531         return c;
532     }
533 
534     /**
535      * @dev Converts to absolute value, and fails on overflow.
536      */
537     function abs(int256 a) internal pure returns (int256) {
538         require(a != MIN_INT256);
539         return a < 0 ? -a : a;
540     }
541 
542 
543     function toUint256Safe(int256 a) internal pure returns (uint256) {
544         require(a >= 0);
545         return uint256(a);
546     }
547 }
548 
549 library SafeMathUint {
550   function toInt256Safe(uint256 a) internal pure returns (int256) {
551     int256 b = int256(a);
552     require(b >= 0);
553     return b;
554   }
555 }
556 
557 
558 interface IUniswapV2Router01 {
559     function factory() external pure returns (address);
560     function WETH() external pure returns (address);
561 
562     function addLiquidity(
563         address tokenA,
564         address tokenB,
565         uint amountADesired,
566         uint amountBDesired,
567         uint amountAMin,
568         uint amountBMin,
569         address to,
570         uint deadline
571     ) external returns (uint amountA, uint amountB, uint liquidity);
572     function addLiquidityETH(
573         address token,
574         uint amountTokenDesired,
575         uint amountTokenMin,
576         uint amountETHMin,
577         address to,
578         uint deadline
579     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
580     function removeLiquidity(
581         address tokenA,
582         address tokenB,
583         uint liquidity,
584         uint amountAMin,
585         uint amountBMin,
586         address to,
587         uint deadline
588     ) external returns (uint amountA, uint amountB);
589     function removeLiquidityETH(
590         address token,
591         uint liquidity,
592         uint amountTokenMin,
593         uint amountETHMin,
594         address to,
595         uint deadline
596     ) external returns (uint amountToken, uint amountETH);
597     function removeLiquidityWithPermit(
598         address tokenA,
599         address tokenB,
600         uint liquidity,
601         uint amountAMin,
602         uint amountBMin,
603         address to,
604         uint deadline,
605         bool approveMax, uint8 v, bytes32 r, bytes32 s
606     ) external returns (uint amountA, uint amountB);
607     function removeLiquidityETHWithPermit(
608         address token,
609         uint liquidity,
610         uint amountTokenMin,
611         uint amountETHMin,
612         address to,
613         uint deadline,
614         bool approveMax, uint8 v, bytes32 r, bytes32 s
615     ) external returns (uint amountToken, uint amountETH);
616     function swapExactTokensForTokens(
617         uint amountIn,
618         uint amountOutMin,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external returns (uint[] memory amounts);
623     function swapTokensForExactTokens(
624         uint amountOut,
625         uint amountInMax,
626         address[] calldata path,
627         address to,
628         uint deadline
629     ) external returns (uint[] memory amounts);
630     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
631         external
632         payable
633         returns (uint[] memory amounts);
634     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
635         external
636         returns (uint[] memory amounts);
637     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
638         external
639         returns (uint[] memory amounts);
640     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
641         external
642         payable
643         returns (uint[] memory amounts);
644 
645     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
646     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
647     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
648     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
649     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
650 }
651 
652 interface IUniswapV2Router02 is IUniswapV2Router01 {
653     function removeLiquidityETHSupportingFeeOnTransferTokens(
654         address token,
655         uint liquidity,
656         uint amountTokenMin,
657         uint amountETHMin,
658         address to,
659         uint deadline
660     ) external returns (uint amountETH);
661     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
662         address token,
663         uint liquidity,
664         uint amountTokenMin,
665         uint amountETHMin,
666         address to,
667         uint deadline,
668         bool approveMax, uint8 v, bytes32 r, bytes32 s
669     ) external returns (uint amountETH);
670 
671     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
672         uint amountIn,
673         uint amountOutMin,
674         address[] calldata path,
675         address to,
676         uint deadline
677     ) external;
678     function swapExactETHForTokensSupportingFeeOnTransferTokens(
679         uint amountOutMin,
680         address[] calldata path,
681         address to,
682         uint deadline
683     ) external payable;
684     function swapExactTokensForETHSupportingFeeOnTransferTokens(
685         uint amountIn,
686         uint amountOutMin,
687         address[] calldata path,
688         address to,
689         uint deadline
690     ) external;
691 }
692 
693 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
694   using SafeMath for uint256;
695   using SafeMathUint for uint256;
696   using SafeMathInt for int256;
697 
698   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
699   // For more discussion about choosing the value of `magnitude`,
700   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
701   uint256 constant internal magnitude = 2**128;
702 
703   mapping(address => uint256) internal magnifiedDividendPerShare;
704   address[] public rewardTokens;
705   address public nextRewardToken;
706   uint256 public rewardTokenCounter;
707   
708   IUniswapV2Router02 public immutable uniswapV2Router;
709   
710   
711   // About dividendCorrection:
712   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
713   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
714   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
715   //   `dividendOf(_user)` should not be changed,
716   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
717   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
718   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
719   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
720   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
721   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
722   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
723   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
724   
725   mapping (address => uint256) public holderBalance;
726   uint256 public totalBalance;
727 
728   mapping(address => uint256) public totalDividendsDistributed;
729   
730   constructor(){
731       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
732       uniswapV2Router = _uniswapV2Router; 
733       
734       // Mainnet
735 
736       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC - 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
737       
738       nextRewardToken = rewardTokens[0];
739   }
740 
741   
742 
743   /// @dev Distributes dividends whenever ether is paid to this contract.
744   receive() external payable {
745     distributeDividends();
746   }
747 
748   /// @notice Distributes ether to token holders as dividends.
749   /// @dev It reverts if the total supply of tokens is 0.
750   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
751   /// About undistributed ether:
752   ///   In each distribution, there is a small amount of ether not distributed,
753   ///     the magnified amount of which is
754   ///     `(msg.value * magnitude) % totalSupply()`.
755   ///   With a well-chosen `magnitude`, the amount of undistributed ether
756   ///     (de-magnified) in a distribution can be less than 1 wei.
757   ///   We can actually keep track of the undistributed ether in a distribution
758   ///     and try to distribute it in the next distribution,
759   ///     but keeping track of such data on-chain costs much more than
760   ///     the saved ether, so we don't do that.
761     
762   function distributeDividends() public override payable { 
763     require(totalBalance > 0);
764     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
765     buyTokens(msg.value, nextRewardToken);
766     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
767     if (newBalance > 0) {
768       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
769         (newBalance).mul(magnitude) / totalBalance
770       );
771       emit DividendsDistributed(msg.sender, newBalance);
772 
773       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
774     }
775     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
776     nextRewardToken = rewardTokens[rewardTokenCounter];
777   }
778   
779   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
780     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
781         // generate the uniswap pair path of weth -> eth
782         address[] memory path = new address[](2);
783         path[0] = uniswapV2Router.WETH();
784         path[1] = rewardToken;
785 
786         // make the swap
787         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
788             0, // accept any amount of Ethereum
789             path,
790             address(this),
791             block.timestamp
792         );
793     }
794   
795   /// @notice Withdraws the ether distributed to the sender.
796   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
797   function withdrawDividend(address _rewardToken) external virtual override {
798     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
799   }
800 
801   /// @notice Withdraws the ether distributed to the sender.
802   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
803   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
804     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
805     if (_withdrawableDividend > 0) {
806       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
807       emit DividendWithdrawn(user, _withdrawableDividend);
808       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
809       return _withdrawableDividend;
810     }
811 
812     return 0;
813   }
814 
815 
816   /// @notice View the amount of dividend in wei that an address can withdraw.
817   /// @param _owner The address of a token holder.
818   /// @return The amount of dividend in wei that `_owner` can withdraw.
819   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
820     return withdrawableDividendOf(_owner, _rewardToken);
821   }
822 
823   /// @notice View the amount of dividend in wei that an address can withdraw.
824   /// @param _owner The address of a token holder.
825   /// @return The amount of dividend in wei that `_owner` can withdraw.
826   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
827     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
828   }
829 
830   /// @notice View the amount of dividend in wei that an address has withdrawn.
831   /// @param _owner The address of a token holder.
832   /// @return The amount of dividend in wei that `_owner` has withdrawn.
833   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
834     return withdrawnDividends[_owner][_rewardToken];
835   }
836 
837 
838   /// @notice View the amount of dividend in wei that an address has earned in total.
839   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
840   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
841   /// @param _owner The address of a token holder.
842   /// @return The amount of dividend in wei that `_owner` has earned in total.
843   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
844     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
845       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
846   }
847 
848   /// @dev Internal function that increases tokens to an account.
849   /// Update magnifiedDividendCorrections to keep dividends unchanged.
850   /// @param account The account that will receive the created tokens.
851   /// @param value The amount that will be created.
852   function _increase(address account, uint256 value) internal {
853     for (uint256 i; i < rewardTokens.length; i++){
854         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
855           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
856     }
857   }
858 
859   /// @dev Internal function that reduces an amount of the token of a given account.
860   /// Update magnifiedDividendCorrections to keep dividends unchanged.
861   /// @param account The account whose tokens will be burnt.
862   /// @param value The amount that will be burnt.
863   function _reduce(address account, uint256 value) internal {
864       for (uint256 i; i < rewardTokens.length; i++){
865         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
866           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
867       }
868   }
869 
870   function _setBalance(address account, uint256 newBalance) internal {
871     uint256 currentBalance = holderBalance[account];
872     holderBalance[account] = newBalance;
873     if(newBalance > currentBalance) {
874       uint256 increaseAmount = newBalance.sub(currentBalance);
875       _increase(account, increaseAmount);
876       totalBalance += increaseAmount;
877     } else if(newBalance < currentBalance) {
878       uint256 reduceAmount = currentBalance.sub(newBalance);
879       _reduce(account, reduceAmount);
880       totalBalance -= reduceAmount;
881     }
882   }
883 }
884 
885 contract DividendTracker is DividendPayingToken {
886     using SafeMath for uint256;
887     using SafeMathInt for int256;
888 
889     struct Map {
890         address[] keys;
891         mapping(address => uint) values;
892         mapping(address => uint) indexOf;
893         mapping(address => bool) inserted;
894     }
895 
896     function get(address key) private view returns (uint) {
897         return tokenHoldersMap.values[key];
898     }
899 
900     function getIndexOfKey(address key) private view returns (int) {
901         if(!tokenHoldersMap.inserted[key]) {
902             return -1;
903         }
904         return int(tokenHoldersMap.indexOf[key]);
905     }
906 
907     function getKeyAtIndex(uint index) private view returns (address) {
908         return tokenHoldersMap.keys[index];
909     }
910 
911 
912 
913     function size() private view returns (uint) {
914         return tokenHoldersMap.keys.length;
915     }
916 
917     function set(address key, uint val) private {
918         if (tokenHoldersMap.inserted[key]) {
919             tokenHoldersMap.values[key] = val;
920         } else {
921             tokenHoldersMap.inserted[key] = true;
922             tokenHoldersMap.values[key] = val;
923             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
924             tokenHoldersMap.keys.push(key);
925         }
926     }
927 
928     function remove(address key) private {
929         if (!tokenHoldersMap.inserted[key]) {
930             return;
931         }
932 
933         delete tokenHoldersMap.inserted[key];
934         delete tokenHoldersMap.values[key];
935 
936         uint index = tokenHoldersMap.indexOf[key];
937         uint lastIndex = tokenHoldersMap.keys.length - 1;
938         address lastKey = tokenHoldersMap.keys[lastIndex];
939 
940         tokenHoldersMap.indexOf[lastKey] = index;
941         delete tokenHoldersMap.indexOf[key];
942 
943         tokenHoldersMap.keys[index] = lastKey;
944         tokenHoldersMap.keys.pop();
945     }
946 
947     Map private tokenHoldersMap;
948     uint256 public lastProcessedIndex;
949 
950     mapping (address => bool) public excludedFromDividends;
951 
952     mapping (address => uint256) public lastClaimTimes;
953 
954     uint256 public claimWait;
955     uint256 public immutable minimumTokenBalanceForDividends;
956 
957     event ExcludeFromDividends(address indexed account);
958     event IncludeInDividends(address indexed account);
959     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
960 
961     event Claim(address indexed account, uint256 amount, bool indexed automatic);
962 
963     constructor() {
964     	claimWait = 1200;
965         minimumTokenBalanceForDividends = 10000 * (10**18);
966     }
967 
968     function excludeFromDividends(address account) external onlyOwner {
969     	excludedFromDividends[account] = true;
970 
971     	_setBalance(account, 0);
972     	remove(account);
973 
974     	emit ExcludeFromDividends(account);
975     }
976     
977     function includeInDividends(address account) external onlyOwner {
978     	require(excludedFromDividends[account]);
979     	excludedFromDividends[account] = false;
980 
981     	emit IncludeInDividends(account);
982     }
983 
984     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
985         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
986         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
987         emit ClaimWaitUpdated(newClaimWait, claimWait);
988         claimWait = newClaimWait;
989     }
990 
991     function getLastProcessedIndex() external view returns(uint256) {
992     	return lastProcessedIndex;
993     }
994 
995     function getNumberOfTokenHolders() external view returns(uint256) {
996         return tokenHoldersMap.keys.length;
997     }
998 
999     // Check to see if I really made this contract or if it is a clone!
1000 
1001     function getAccount(address _account, address _rewardToken)
1002         public view returns (
1003             address account,
1004             int256 index,
1005             int256 iterationsUntilProcessed,
1006             uint256 withdrawableDividends,
1007             uint256 totalDividends,
1008             uint256 lastClaimTime,
1009             uint256 nextClaimTime,
1010             uint256 secondsUntilAutoClaimAvailable) {
1011         account = _account;
1012 
1013         index = getIndexOfKey(account);
1014 
1015         iterationsUntilProcessed = -1;
1016 
1017         if(index >= 0) {
1018             if(uint256(index) > lastProcessedIndex) {
1019                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1020             }
1021             else {
1022                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1023                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1024                                                         0;
1025 
1026 
1027                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1028             }
1029         }
1030 
1031 
1032         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1033         totalDividends = accumulativeDividendOf(account, _rewardToken);
1034 
1035         lastClaimTime = lastClaimTimes[account];
1036 
1037         nextClaimTime = lastClaimTime > 0 ?
1038                                     lastClaimTime.add(claimWait) :
1039                                     0;
1040 
1041         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1042                                                     nextClaimTime.sub(block.timestamp) :
1043                                                     0;
1044     }
1045 
1046     function getAccountAtIndex(uint256 index, address _rewardToken)
1047         external view returns (
1048             address,
1049             int256,
1050             int256,
1051             uint256,
1052             uint256,
1053             uint256,
1054             uint256,
1055             uint256) {
1056     	if(index >= size()) {
1057             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1058         }
1059 
1060         address account = getKeyAtIndex(index);
1061 
1062         return getAccount(account, _rewardToken);
1063     }
1064 
1065     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1066     	if(lastClaimTime > block.timestamp)  {
1067     		return false;
1068     	}
1069 
1070     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1071     }
1072 
1073     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1074     	if(excludedFromDividends[account]) {
1075     		return;
1076     	}
1077 
1078     	if(newBalance >= minimumTokenBalanceForDividends) {
1079             _setBalance(account, newBalance);
1080     		set(account, newBalance);
1081     	}
1082     	else {
1083             _setBalance(account, 0);
1084     		remove(account);
1085     	}
1086 
1087     	processAccount(account, true);
1088     }
1089     
1090     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1091     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1092 
1093     	if(numberOfTokenHolders == 0) {
1094     		return (0, 0, lastProcessedIndex);
1095     	}
1096 
1097     	uint256 _lastProcessedIndex = lastProcessedIndex;
1098 
1099     	uint256 gasUsed = 0;
1100 
1101     	uint256 gasLeft = gasleft();
1102 
1103     	uint256 iterations = 0;
1104     	uint256 claims = 0;
1105 
1106     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1107     		_lastProcessedIndex++;
1108 
1109     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1110     			_lastProcessedIndex = 0;
1111     		}
1112 
1113     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1114 
1115     		if(canAutoClaim(lastClaimTimes[account])) {
1116     			if(processAccount(payable(account), true)) {
1117     				claims++;
1118     			}
1119     		}
1120 
1121     		iterations++;
1122 
1123     		uint256 newGasLeft = gasleft();
1124 
1125     		if(gasLeft > newGasLeft) {
1126     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1127     		}
1128     		gasLeft = newGasLeft;
1129     	}
1130 
1131     	lastProcessedIndex = _lastProcessedIndex;
1132 
1133     	return (iterations, claims, lastProcessedIndex);
1134     }
1135 
1136     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1137         uint256 amount;
1138         bool paid;
1139         for (uint256 i; i < rewardTokens.length; i++){
1140             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1141             if(amount > 0) {
1142         		lastClaimTimes[account] = block.timestamp;
1143                 emit Claim(account, amount, automatic);
1144                 paid = true;
1145     	    }
1146         }
1147         return paid;
1148     }
1149 }
1150 
1151 contract LIMITLESS is ERC20, Ownable {
1152     using SafeMath for uint256;
1153 
1154     IUniswapV2Router02 public immutable uniswapV2Router;
1155     address public immutable uniswapV2Pair;
1156 
1157     bool private swapping;
1158 
1159     DividendTracker public dividendTracker;
1160 
1161     address public operationsWallet;
1162     
1163     uint256 public maxTransactionAmount;
1164     uint256 public swapTokensAtAmount;
1165     uint256 public maxWallet;
1166     
1167     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1168     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1169     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1170     
1171     bool public limitsInEffect = true;
1172     bool public tradingActive = false;
1173     bool public swapEnabled = false;
1174     
1175      // Anti-bot and anti-whale mappings and variables
1176     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1177     bool public transferDelayEnabled = true;
1178     
1179     uint256 public constant feeDivisor = 1000;
1180 
1181     uint256 public totalSellFees;
1182     uint256 public rewardsSellFee;
1183     uint256 public operationsSellFee;
1184     uint256 public liquiditySellFee;
1185     
1186     uint256 public totalBuyFees;
1187     uint256 public rewardsBuyFee;
1188     uint256 public operationsBuyFee;
1189     uint256 public liquidityBuyFee;
1190     
1191     uint256 public tokensForRewards;
1192     uint256 public tokensForOperations;
1193     uint256 public tokensForLiquidity;
1194     
1195     uint256 public gasForProcessing = 0;
1196 
1197     uint256 public lpWithdrawRequestTimestamp;
1198     uint256 public lpWithdrawRequestDuration = 30 days;
1199     bool public lpWithdrawRequestPending;
1200     uint256 public lpPercToWithDraw;
1201 
1202     /******************/
1203 
1204     // exlcude from fees and max transaction amount
1205     mapping (address => bool) private _isExcludedFromFees;
1206 
1207     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1208 
1209     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1210     // could be subject to a maximum transfer amount
1211     mapping (address => bool) public automatedMarketMakerPairs;
1212 
1213     event ExcludeFromFees(address indexed account, bool isExcluded);
1214     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1215     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1216 
1217     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1218 
1219     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1220 
1221     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1222 
1223     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1224     
1225     event SwapAndLiquify(
1226         uint256 tokensSwapped,
1227         uint256 ethReceived,
1228         uint256 tokensIntoLiqudity
1229     );
1230 
1231     event SendDividends(
1232     	uint256 tokensSwapped,
1233     	uint256 amount
1234     );
1235 
1236     event ProcessedDividendTracker(
1237     	uint256 iterations,
1238     	uint256 claims,
1239         uint256 lastProcessedIndex,
1240     	bool indexed automatic,
1241     	uint256 gas,
1242     	address indexed processor
1243     );
1244 
1245     event RequestedLPWithdraw();
1246     
1247     event WithdrewLPForMigration();
1248 
1249     event CanceledLpWithdrawRequest();
1250 
1251     constructor() ERC20("Limitless Utility Aggregator", "LIMITLESS") {
1252 
1253         uint256 totalSupply = 1000 * 1e6 * 1e18;
1254         
1255         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
1256         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
1257         maxWallet = totalSupply * 5 / 1000; // 0.5% Max wallet
1258 
1259         rewardsBuyFee = 40;
1260         operationsBuyFee = 30;
1261         liquidityBuyFee = 10;
1262         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1263         
1264         rewardsSellFee = 40;
1265         operationsSellFee = 30;
1266         liquiditySellFee = 10;
1267         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1268 
1269     	dividendTracker = new DividendTracker();
1270     	
1271     	operationsWallet = address(msg.sender); // set as operations wallet
1272 
1273     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1274     	
1275          // Create a uniswap pair for this new token
1276         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1277             .createPair(address(this), _uniswapV2Router.WETH());
1278 
1279         uniswapV2Router = _uniswapV2Router;
1280         uniswapV2Pair = _uniswapV2Pair;
1281 
1282         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1283 
1284         // exclude from receiving dividends
1285         dividendTracker.excludeFromDividends(address(dividendTracker));
1286         dividendTracker.excludeFromDividends(address(this));
1287         dividendTracker.excludeFromDividends(owner());
1288         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1289         dividendTracker.excludeFromDividends(address(0xdead));
1290         
1291         // exclude from paying fees or having max transaction amount
1292         excludeFromFees(owner(), true);
1293         excludeFromFees(address(this), true);
1294         excludeFromFees(address(0xdead), true);
1295         excludeFromMaxTransaction(owner(), true);
1296         excludeFromMaxTransaction(address(this), true);
1297         excludeFromMaxTransaction(address(dividendTracker), true);
1298         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1299         excludeFromMaxTransaction(address(0xdead), true);
1300 
1301         _createInitialSupply(address(owner()), totalSupply);
1302     }
1303 
1304     receive() external payable {
1305 
1306   	}
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
1325     function enableTradingToPublic() external onlyOwner {
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
1360         require(totalSellFees <= 160, "Must keep fees at 16% or less");
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
1569             // if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1570             //     fees = amount.mul(99).div(100);
1571             //     tokensForLiquidity += fees * 33 / 99;
1572             //     tokensForRewards += fees * 33 / 99;
1573             //     tokensForOperations += fees * 33 / 99;
1574             // }
1575 
1576             // on sell
1577             if (automatedMarketMakerPairs[to] && totalSellFees > 0){
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
1723     function extendLPLock() external onlyOwner {
1724         lpWithdrawRequestDuration = lpWithdrawRequestDuration + 30 days;
1725     }
1726 
1727     function cancelLPWithdrawRequest() external onlyOwner {
1728         lpWithdrawRequestPending = false;
1729         lpPercToWithDraw = 0;
1730         lpWithdrawRequestTimestamp = 0;
1731         emit CanceledLpWithdrawRequest();
1732     }
1733 }