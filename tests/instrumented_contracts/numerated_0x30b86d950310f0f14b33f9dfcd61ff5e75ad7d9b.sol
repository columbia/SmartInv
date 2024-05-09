1 // File: contracts/PolluxEth.sol
2 
3 /* POLLUX PROTOCOL | THE FIRST CROSS CHAIN REFLECTIONS PROJECT UTILISING 6 CHAINS
4 
5 TG: https://t.me/polluxprotocol
6 Twitter: https://twitter.com/polluxprotocol
7 Website: https://polluxprotocol.com
8 Docs: https://docs.polluxprotocol.com
9 
10 */
11 
12 
13 pragma solidity 0.8.13;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 interface IUniswapV2Factory {
27     function createPair(address tokenA, address tokenB) external returns (address pair);
28 }
29 
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 interface IERC20Metadata is IERC20 {
106     /**
107      * @dev Returns the name of the token.
108      */
109     function name() external view returns (string memory);
110 
111     /**
112      * @dev Returns the symbol of the token.
113      */
114     function symbol() external view returns (string memory);
115 
116     /**
117      * @dev Returns the decimals places of the token.
118      */
119     function decimals() external view returns (uint8);
120 }
121 
122 
123 contract ERC20 is Context, IERC20, IERC20Metadata {
124     mapping(address => uint256) private _balances;
125 
126     mapping(address => mapping(address => uint256)) private _allowances;
127 
128     uint256 private _totalSupply;
129 
130     string private _name;
131     string private _symbol;
132 
133     constructor(string memory name_, string memory symbol_) {
134         _name = name_;
135         _symbol = symbol_;
136     }
137 
138     function name() public view virtual override returns (string memory) {
139         return _name;
140     }
141 
142     function symbol() public view virtual override returns (string memory) {
143         return _symbol;
144     }
145 
146     function decimals() public view virtual override returns (uint8) {
147         return 18;
148     }
149 
150     function totalSupply() public view virtual override returns (uint256) {
151         return _totalSupply;
152     }
153 
154     function balanceOf(address account) public view virtual override returns (uint256) {
155         return _balances[account];
156     }
157 
158     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
159         _transfer(_msgSender(), recipient, amount);
160         return true;
161     }
162 
163     function allowance(address owner, address spender) public view virtual override returns (uint256) {
164         return _allowances[owner][spender];
165     }
166 
167     function approve(address spender, uint256 amount) public virtual override returns (bool) {
168         _approve(_msgSender(), spender, amount);
169         return true;
170     }
171 
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) public virtual override returns (bool) {
177         _transfer(sender, recipient, amount);
178 
179         uint256 currentAllowance = _allowances[sender][_msgSender()];
180         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
181         unchecked {
182             _approve(sender, _msgSender(), currentAllowance - amount);
183         }
184 
185         return true;
186     }
187 
188     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
189         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
190         return true;
191     }
192 
193     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
194         uint256 currentAllowance = _allowances[_msgSender()][spender];
195         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
196         unchecked {
197             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
198         }
199 
200         return true;
201     }
202 
203     function _transfer(
204         address sender,
205         address recipient,
206         uint256 amount
207     ) internal virtual {
208         require(sender != address(0), "ERC20: transfer from the zero address");
209         require(recipient != address(0), "ERC20: transfer to the zero address");
210 
211         uint256 senderBalance = _balances[sender];
212         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
213         unchecked {
214             _balances[sender] = senderBalance - amount;
215         }
216         _balances[recipient] += amount;
217 
218         emit Transfer(sender, recipient, amount);
219     }
220 
221     function _createInitialSupply(address account, uint256 amount) internal virtual {
222         require(account != address(0), "ERC20: mint to the zero address");
223         _totalSupply += amount;
224         _balances[account] += amount;
225         emit Transfer(address(0), account, amount);
226     }
227 
228     function _approve(
229         address owner,
230         address spender,
231         uint256 amount
232     ) internal virtual {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235 
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 }
240 
241 interface DividendPayingTokenOptionalInterface {
242   /// @notice View the amount of dividend in wei that an address can withdraw.
243   /// @param _owner The address of a token holder.
244   /// @return The amount of dividend in wei that `_owner` can withdraw.
245   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
246 
247   /// @notice View the amount of dividend in wei that an address has withdrawn.
248   /// @param _owner The address of a token holder.
249   /// @return The amount of dividend in wei that `_owner` has withdrawn.
250   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
251 
252   /// @notice View the amount of dividend in wei that an address has earned in total.
253   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
254   /// @param _owner The address of a token holder.
255   /// @return The amount of dividend in wei that `_owner` has earned in total.
256   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
257 }
258 
259 interface DividendPayingTokenInterface {
260   /// @notice View the amount of dividend in wei that an address can withdraw.
261   /// @param _owner The address of a token holder.
262   /// @return The amount of dividend in wei that `_owner` can withdraw.
263   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
264 
265   /// @notice Distributes ether to token holders as dividends.
266   /// @dev SHOULD distribute the paid ether to token holders as dividends.
267   ///  SHOULD NOT directly transfer ether to token holders in this function.
268   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
269   function distributeDividends() external payable;
270 
271   /// @notice Withdraws the ether distributed to the sender.
272   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
273   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
274   function withdrawDividend(address _rewardToken) external;
275 
276   /// @dev This event MUST emit when ether is distributed to token holders.
277   /// @param from The address which sends ether to this contract.
278   /// @param weiAmount The amount of distributed ether in wei.
279   event DividendsDistributed(
280     address indexed from,
281     uint256 weiAmount
282   );
283 
284   /// @dev This event MUST emit when an address withdraws their dividend.
285   /// @param to The address which withdraws ether from this contract.
286   /// @param weiAmount The amount of withdrawn ether in wei.
287   event DividendWithdrawn(
288     address indexed to,
289     uint256 weiAmount
290   );
291 }
292 
293 library SafeMath {
294     /**
295      * @dev Returns the addition of two unsigned integers, reverting on
296      * overflow.
297      *
298      * Counterpart to Solidity's `+` operator.
299      *
300      * Requirements:
301      *
302      * - Addition cannot overflow.
303      */
304     function add(uint256 a, uint256 b) internal pure returns (uint256) {
305         uint256 c = a + b;
306         require(c >= a, "SafeMath: addition overflow");
307 
308         return c;
309     }
310 
311     /**
312      * @dev Returns the subtraction of two unsigned integers, reverting on
313      * overflow (when the result is negative).
314      *
315      * Counterpart to Solidity's `-` operator.
316      *
317      * Requirements:
318      *
319      * - Subtraction cannot overflow.
320      */
321     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
322         return sub(a, b, "SafeMath: subtraction overflow");
323     }
324 
325     /**
326      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
327      * overflow (when the result is negative).
328      *
329      * Counterpart to Solidity's `-` operator.
330      *
331      * Requirements:
332      *
333      * - Subtraction cannot overflow.
334      */
335     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
336         require(b <= a, errorMessage);
337         uint256 c = a - b;
338 
339         return c;
340     }
341 
342     /**
343      * @dev Returns the multiplication of two unsigned integers, reverting on
344      * overflow.
345      *
346      * Counterpart to Solidity's `*` operator.
347      *
348      * Requirements:
349      *
350      * - Multiplication cannot overflow.
351      */
352     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
353         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
354         // benefit is lost if 'b' is also tested.
355         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
356         if (a == 0) {
357             return 0;
358         }
359 
360         uint256 c = a * b;
361         require(c / a == b, "SafeMath: multiplication overflow");
362 
363         return c;
364     }
365 
366     /**
367      * @dev Returns the integer division of two unsigned integers. Reverts on
368      * division by zero. The result is rounded towards zero.
369      *
370      * Counterpart to Solidity's `/` operator. Note: this function uses a
371      * `revert` opcode (which leaves remaining gas untouched) while Solidity
372      * uses an invalid opcode to revert (consuming all remaining gas).
373      *
374      * Requirements:
375      *
376      * - The divisor cannot be zero.
377      */
378     function div(uint256 a, uint256 b) internal pure returns (uint256) {
379         return div(a, b, "SafeMath: division by zero");
380     }
381 
382     /**
383      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
384      * division by zero. The result is rounded towards zero.
385      *
386      * Counterpart to Solidity's `/` operator. Note: this function uses a
387      * `revert` opcode (which leaves remaining gas untouched) while Solidity
388      * uses an invalid opcode to revert (consuming all remaining gas).
389      *
390      * Requirements:
391      *
392      * - The divisor cannot be zero.
393      */
394     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
395         require(b > 0, errorMessage);
396         uint256 c = a / b;
397         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
398 
399         return c;
400     }
401 
402     /**
403      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
404      * Reverts when dividing by zero.
405      *
406      * Counterpart to Solidity's `%` operator. This function uses a `revert`
407      * opcode (which leaves remaining gas untouched) while Solidity uses an
408      * invalid opcode to revert (consuming all remaining gas).
409      *
410      * Requirements:
411      *
412      * - The divisor cannot be zero.
413      */
414     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
415         return mod(a, b, "SafeMath: modulo by zero");
416     }
417 
418     /**
419      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
420      * Reverts with custom message when dividing by zero.
421      *
422      * Counterpart to Solidity's `%` operator. This function uses a `revert`
423      * opcode (which leaves remaining gas untouched) while Solidity uses an
424      * invalid opcode to revert (consuming all remaining gas).
425      *
426      * Requirements:
427      *
428      * - The divisor cannot be zero.
429      */
430     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
431         require(b != 0, errorMessage);
432         return a % b;
433     }
434 }
435 
436 contract Ownable is Context {
437     address private _owner;
438 
439     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
440     
441     /**
442      * @dev Initializes the contract setting the deployer as the initial owner.
443      */
444     constructor () {
445         address msgSender = _msgSender();
446         _owner = msgSender;
447         emit OwnershipTransferred(address(0), msgSender);
448     }
449 
450     /**
451      * @dev Returns the address of the current owner.
452      */
453     function owner() public view returns (address) {
454         return _owner;
455     }
456 
457     /**
458      * @dev Throws if called by any account other than the owner.
459      */
460     modifier onlyOwner() {
461         require(_owner == _msgSender(), "Ownable: caller is not the owner");
462         _;
463     }
464 
465     /**
466      * @dev Leaves the contract without owner. It will not be possible to call
467      * `onlyOwner` functions anymore. Can only be called by the current owner.
468      *
469      * NOTE: Renouncing ownership will leave the contract without an owner,
470      * thereby removing any functionality that is only available to the owner.
471      */
472     function renounceOwnership() public virtual onlyOwner {
473         emit OwnershipTransferred(_owner, address(0));
474         _owner = address(0);
475     }
476 
477     /**
478      * @dev Transfers ownership of the contract to a new account (`newOwner`).
479      * Can only be called by the current owner.
480      */
481     function transferOwnership(address newOwner) public virtual onlyOwner {
482         require(newOwner != address(0), "Ownable: new owner is the zero address");
483         emit OwnershipTransferred(_owner, newOwner);
484         _owner = newOwner;
485     }
486 }
487 
488 
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
732       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // sushiswap router on arbitrum - 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
733       uniswapV2Router = _uniswapV2Router; 
734       
735       // Mainnet
736 
737       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // 
738       
739       nextRewardToken = rewardTokens[0];
740   }
741 
742   
743 
744   /// @dev Distributes dividends whenever ether is paid to this contract.
745   receive() external payable {
746     distributeDividends();
747   }
748 
749   /// @notice Distributes ether to token holders as dividends.
750   /// @dev It reverts if the total supply of tokens is 0.
751   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
752   /// About undistributed ether:
753   ///   In each distribution, there is a small amount of ether not distributed,
754   ///     the magnified amount of which is
755   ///     `(msg.value * magnitude) % totalSupply()`.
756   ///   With a well-chosen `magnitude`, the amount of undistributed ether
757   ///     (de-magnified) in a distribution can be less than 1 wei.
758   ///   We can actually keep track of the undistributed ether in a distribution
759   ///     and try to distribute it in the next distribution,
760   ///     but keeping track of such data on-chain costs much more than
761   ///     the saved ether, so we don't do that.
762     
763   function distributeDividends() public override payable { 
764     require(totalBalance > 0);
765     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
766     buyTokens(msg.value, nextRewardToken);
767     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
768     if (newBalance > 0) {
769       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
770         (newBalance).mul(magnitude) / totalBalance
771       );
772       emit DividendsDistributed(msg.sender, newBalance);
773 
774       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
775     }
776     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
777     nextRewardToken = rewardTokens[rewardTokenCounter];
778   }
779   
780   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
781     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
782         // generate the uniswap pair path of weth -> eth
783         address[] memory path = new address[](2);
784         path[0] = uniswapV2Router.WETH();
785         path[1] = rewardToken;
786 
787         // make the swap
788         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
789             0, // accept any amount of Ethereum
790             path,
791             address(this),
792             block.timestamp
793         );
794     }
795   
796   /// @notice Withdraws the ether distributed to the sender.
797   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
798   function withdrawDividend(address _rewardToken) external virtual override {
799     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
800   }
801 
802   /// @notice Withdraws the ether distributed to the sender.
803   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
804   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
805     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
806     if (_withdrawableDividend > 0) {
807       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
808       emit DividendWithdrawn(user, _withdrawableDividend);
809       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
810       return _withdrawableDividend;
811     }
812 
813     return 0;
814   }
815 
816 
817   /// @notice View the amount of dividend in wei that an address can withdraw.
818   /// @param _owner The address of a token holder.
819   /// @return The amount of dividend in wei that `_owner` can withdraw.
820   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
821     return withdrawableDividendOf(_owner, _rewardToken);
822   }
823 
824   /// @notice View the amount of dividend in wei that an address can withdraw.
825   /// @param _owner The address of a token holder.
826   /// @return The amount of dividend in wei that `_owner` can withdraw.
827   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
828     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
829   }
830 
831   /// @notice View the amount of dividend in wei that an address has withdrawn.
832   /// @param _owner The address of a token holder.
833   /// @return The amount of dividend in wei that `_owner` has withdrawn.
834   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
835     return withdrawnDividends[_owner][_rewardToken];
836   }
837 
838 
839   /// @notice View the amount of dividend in wei that an address has earned in total.
840   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
841   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
842   /// @param _owner The address of a token holder.
843   /// @return The amount of dividend in wei that `_owner` has earned in total.
844   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
845     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
846       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
847   }
848 
849   /// @dev Internal function that increases tokens to an account.
850   /// Update magnifiedDividendCorrections to keep dividends unchanged.
851   /// @param account The account that will receive the created tokens.
852   /// @param value The amount that will be created.
853   function _increase(address account, uint256 value) internal {
854     for (uint256 i; i < rewardTokens.length; i++){
855         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
856           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
857     }
858   }
859 
860   /// @dev Internal function that reduces an amount of the token of a given account.
861   /// Update magnifiedDividendCorrections to keep dividends unchanged.
862   /// @param account The account whose tokens will be burnt.
863   /// @param value The amount that will be burnt.
864   function _reduce(address account, uint256 value) internal {
865       for (uint256 i; i < rewardTokens.length; i++){
866         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
867           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
868       }
869   }
870 
871   function _setBalance(address account, uint256 newBalance) internal {
872     uint256 currentBalance = holderBalance[account];
873     holderBalance[account] = newBalance;
874     if(newBalance > currentBalance) {
875       uint256 increaseAmount = newBalance.sub(currentBalance);
876       _increase(account, increaseAmount);
877       totalBalance += increaseAmount;
878     } else if(newBalance < currentBalance) {
879       uint256 reduceAmount = currentBalance.sub(newBalance);
880       _reduce(account, reduceAmount);
881       totalBalance -= reduceAmount;
882     }
883   }
884 }
885 
886 contract DividendTracker is DividendPayingToken {
887     using SafeMath for uint256;
888     using SafeMathInt for int256;
889 
890     struct Map {
891         address[] keys;
892         mapping(address => uint) values;
893         mapping(address => uint) indexOf;
894         mapping(address => bool) inserted;
895     }
896 
897     function get(address key) private view returns (uint) {
898         return tokenHoldersMap.values[key];
899     }
900 
901     function getIndexOfKey(address key) private view returns (int) {
902         if(!tokenHoldersMap.inserted[key]) {
903             return -1;
904         }
905         return int(tokenHoldersMap.indexOf[key]);
906     }
907 
908     function getKeyAtIndex(uint index) private view returns (address) {
909         return tokenHoldersMap.keys[index];
910     }
911 
912 
913 
914     function size() private view returns (uint) {
915         return tokenHoldersMap.keys.length;
916     }
917 
918     function set(address key, uint val) private {
919         if (tokenHoldersMap.inserted[key]) {
920             tokenHoldersMap.values[key] = val;
921         } else {
922             tokenHoldersMap.inserted[key] = true;
923             tokenHoldersMap.values[key] = val;
924             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
925             tokenHoldersMap.keys.push(key);
926         }
927     }
928 
929     function remove(address key) private {
930         if (!tokenHoldersMap.inserted[key]) {
931             return;
932         }
933 
934         delete tokenHoldersMap.inserted[key];
935         delete tokenHoldersMap.values[key];
936 
937         uint index = tokenHoldersMap.indexOf[key];
938         uint lastIndex = tokenHoldersMap.keys.length - 1;
939         address lastKey = tokenHoldersMap.keys[lastIndex];
940 
941         tokenHoldersMap.indexOf[lastKey] = index;
942         delete tokenHoldersMap.indexOf[key];
943 
944         tokenHoldersMap.keys[index] = lastKey;
945         tokenHoldersMap.keys.pop();
946     }
947 
948     Map private tokenHoldersMap;
949     uint256 public lastProcessedIndex;
950 
951     mapping (address => bool) public excludedFromDividends;
952 
953     mapping (address => uint256) public lastClaimTimes;
954 
955     uint256 public claimWait;
956     uint256 public immutable minimumTokenBalanceForDividends;
957 
958     event ExcludeFromDividends(address indexed account);
959     event IncludeInDividends(address indexed account);
960     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
961 
962     event Claim(address indexed account, uint256 amount, bool indexed automatic);
963 
964     constructor() {
965     	claimWait = 1200;
966         minimumTokenBalanceForDividends = 1000 * (10**18);
967     }
968 
969     function excludeFromDividends(address account) external onlyOwner {
970     	excludedFromDividends[account] = true;
971 
972     	_setBalance(account, 0);
973     	remove(account);
974 
975     	emit ExcludeFromDividends(account);
976     }
977     
978     function includeInDividends(address account) external onlyOwner {
979     	require(excludedFromDividends[account]);
980     	excludedFromDividends[account] = false;
981 
982     	emit IncludeInDividends(account);
983     }
984 
985     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
986         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
987         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
988         emit ClaimWaitUpdated(newClaimWait, claimWait);
989         claimWait = newClaimWait;
990     }
991 
992     function getLastProcessedIndex() external view returns(uint256) {
993     	return lastProcessedIndex;
994     }
995 
996     function getNumberOfTokenHolders() external view returns(uint256) {
997         return tokenHoldersMap.keys.length;
998     }
999 
1000     // Check to see if I really made this contract or if it is a clone!
1001 
1002     function getAccount(address _account, address _rewardToken)
1003         public view returns (
1004             address account,
1005             int256 index,
1006             int256 iterationsUntilProcessed,
1007             uint256 withdrawableDividends,
1008             uint256 totalDividends,
1009             uint256 lastClaimTime,
1010             uint256 nextClaimTime,
1011             uint256 secondsUntilAutoClaimAvailable) {
1012         account = _account;
1013 
1014         index = getIndexOfKey(account);
1015 
1016         iterationsUntilProcessed = -1;
1017 
1018         if(index >= 0) {
1019             if(uint256(index) > lastProcessedIndex) {
1020                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1021             }
1022             else {
1023                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1024                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1025                                                         0;
1026 
1027 
1028                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1029             }
1030         }
1031 
1032 
1033         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1034         totalDividends = accumulativeDividendOf(account, _rewardToken);
1035 
1036         lastClaimTime = lastClaimTimes[account];
1037 
1038         nextClaimTime = lastClaimTime > 0 ?
1039                                     lastClaimTime.add(claimWait) :
1040                                     0;
1041 
1042         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1043                                                     nextClaimTime.sub(block.timestamp) :
1044                                                     0;
1045     }
1046 
1047     function getAccountAtIndex(uint256 index, address _rewardToken)
1048         external view returns (
1049             address,
1050             int256,
1051             int256,
1052             uint256,
1053             uint256,
1054             uint256,
1055             uint256,
1056             uint256) {
1057     	if(index >= size()) {
1058             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1059         }
1060 
1061         address account = getKeyAtIndex(index);
1062 
1063         return getAccount(account, _rewardToken);
1064     }
1065 
1066     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1067     	if(lastClaimTime > block.timestamp)  {
1068     		return false;
1069     	}
1070 
1071     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1072     }
1073 
1074     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1075     	if(excludedFromDividends[account]) {
1076     		return;
1077     	}
1078 
1079     	if(newBalance >= minimumTokenBalanceForDividends) {
1080             _setBalance(account, newBalance);
1081     		set(account, newBalance);
1082     	}
1083     	else {
1084             _setBalance(account, 0);
1085     		remove(account);
1086     	}
1087 
1088     	processAccount(account, true);
1089     }
1090     
1091     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1092     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1093 
1094     	if(numberOfTokenHolders == 0) {
1095     		return (0, 0, lastProcessedIndex);
1096     	}
1097 
1098     	uint256 _lastProcessedIndex = lastProcessedIndex;
1099 
1100     	uint256 gasUsed = 0;
1101 
1102     	uint256 gasLeft = gasleft();
1103 
1104     	uint256 iterations = 0;
1105     	uint256 claims = 0;
1106 
1107     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1108     		_lastProcessedIndex++;
1109 
1110     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1111     			_lastProcessedIndex = 0;
1112     		}
1113 
1114     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1115 
1116     		if(canAutoClaim(lastClaimTimes[account])) {
1117     			if(processAccount(payable(account), true)) {
1118     				claims++;
1119     			}
1120     		}
1121 
1122     		iterations++;
1123 
1124     		uint256 newGasLeft = gasleft();
1125 
1126     		if(gasLeft > newGasLeft) {
1127     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1128     		}
1129     		gasLeft = newGasLeft;
1130     	}
1131 
1132     	lastProcessedIndex = _lastProcessedIndex;
1133 
1134     	return (iterations, claims, lastProcessedIndex);
1135     }
1136 
1137     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1138         uint256 amount;
1139         bool paid;
1140         for (uint256 i; i < rewardTokens.length; i++){
1141             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1142             if(amount > 0) {
1143         		lastClaimTimes[account] = block.timestamp;
1144                 emit Claim(account, amount, automatic);
1145                 paid = true;
1146     	    }
1147         }
1148         return paid;
1149     }
1150 }
1151 
1152 
1153 contract Pollux is ERC20, Ownable {
1154     using SafeMath for uint256;
1155 
1156     IUniswapV2Router02 public immutable uniswapV2Router;
1157     address public immutable uniswapV2Pair;
1158 
1159     bool private swapping;
1160 
1161     DividendTracker public dividendTracker;
1162 
1163     address public MarketingWallet;
1164     
1165     uint256 public maxTransactionAmount;
1166     uint256 public swapTokensAtAmount;
1167     uint256 public maxWallet;
1168     
1169     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1170     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1171     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1172     
1173     bool public limitsInEffect = true;
1174     bool public tradingActive = false;
1175     bool public swapEnabled = false;
1176     
1177      // Anti-bot and anti-whale mappings and variables
1178     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1179     bool public transferDelayEnabled = true;
1180     
1181     uint256 public constant feeDivisor = 1000;
1182 
1183     uint256 public totalSellFees;
1184     uint256 public rewardsSellFee;
1185     uint256 public MarketingSellFee;
1186     uint256 public liquiditySellFee;
1187     
1188     uint256 public totalBuyFees;
1189     uint256 public rewardsBuyFee;
1190     uint256 public MarketingBuyFee;
1191     uint256 public liquidityBuyFee;
1192     
1193     uint256 public tokensForRewards;
1194     uint256 public tokensForMarketing;
1195     uint256 public tokensForLiquidity;
1196     
1197     uint256 public gasForProcessing = 0;
1198 
1199     uint256 public lpWithdrawRequestTimestamp;
1200     uint256 public lpWithdrawRequestDuration = 3 days;
1201     bool public lpWithdrawRequestPending;
1202     uint256 public lpPercToWithDraw;
1203 
1204     /******************/
1205 
1206     // exlcude from fees and max transaction amount
1207     mapping (address => bool) private _isExcludedFromFees;
1208 
1209     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1210 
1211     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1212     // could be subject to a maximum transfer amount
1213     mapping (address => bool) public automatedMarketMakerPairs;
1214 
1215     event ExcludeFromFees(address indexed account, bool isExcluded);
1216     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1217     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1218 
1219     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1220 
1221     event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
1222 
1223     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1224 
1225     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1226     
1227     event SwapAndLiquify(
1228         uint256 tokensSwapped,
1229         uint256 ethReceived,
1230         uint256 tokensIntoLiqudity
1231     );
1232 
1233     event SendDividends(
1234     	uint256 tokensSwapped,
1235     	uint256 amount
1236     );
1237 
1238     event ProcessedDividendTracker(
1239     	uint256 iterations,
1240     	uint256 claims,
1241         uint256 lastProcessedIndex,
1242     	bool indexed automatic,
1243     	uint256 gas,
1244     	address indexed processor
1245     );
1246 
1247     event RequestedLPWithdraw();
1248     
1249     event WithdrewLPForMigration();
1250 
1251     event CanceledLpWithdrawRequest();
1252 
1253     constructor() ERC20("Pollux Token", "POLL") {
1254 
1255         uint256 totalSupply = 100 * 1e4 * 1e18;
1256         
1257         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
1258         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
1259         maxWallet = totalSupply * 2 / 100; // 2% Max wallet
1260 
1261         rewardsBuyFee = 30;
1262         MarketingBuyFee = 20;
1263         liquidityBuyFee = 10;
1264         totalBuyFees = rewardsBuyFee + MarketingBuyFee + liquidityBuyFee;
1265         
1266         rewardsSellFee = 30;
1267         MarketingSellFee = 110;
1268         liquiditySellFee = 10;
1269         totalSellFees = rewardsSellFee + MarketingSellFee + liquiditySellFee;
1270 
1271     	dividendTracker = new DividendTracker();
1272     	
1273     	MarketingWallet = address(msg.sender); // set as Marketing wallet
1274 
1275     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1276     	
1277          // Create a uniswap pair for this new token
1278         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1279             .createPair(address(this), _uniswapV2Router.WETH());
1280 
1281         uniswapV2Router = _uniswapV2Router;
1282         uniswapV2Pair = _uniswapV2Pair;
1283 
1284         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1285 
1286         // exclude from receiving dividends
1287         dividendTracker.excludeFromDividends(address(dividendTracker));
1288         dividendTracker.excludeFromDividends(address(this));
1289         dividendTracker.excludeFromDividends(owner());
1290         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1291         dividendTracker.excludeFromDividends(address(0xdead));
1292         
1293         // exclude from paying fees or having max transaction amount
1294         excludeFromFees(owner(), true);
1295         excludeFromFees(address(this), true);
1296         excludeFromFees(address(0xdead), true);
1297         excludeFromMaxTransaction(owner(), true);
1298         excludeFromMaxTransaction(address(this), true);
1299         excludeFromMaxTransaction(address(dividendTracker), true);
1300         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1301         excludeFromMaxTransaction(address(0xdead), true);
1302 
1303         _createInitialSupply(address(owner()), totalSupply);
1304     }
1305 
1306     receive() external payable {
1307 
1308   	}
1309 
1310     // only use if conducting a presale
1311     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1312         excludeFromFees(_presaleAddress, true);
1313         dividendTracker.excludeFromDividends(_presaleAddress);
1314         excludeFromMaxTransaction(_presaleAddress, true);
1315     }
1316 
1317      // disable Transfer delay - cannot be reenabled
1318     function disableTransferDelay() external onlyOwner returns (bool){
1319         transferDelayEnabled = false;
1320         return true;
1321     }
1322 
1323     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1324     function excludeFromDividends(address account) external onlyOwner {
1325         dividendTracker.excludeFromDividends(account);
1326     }
1327 
1328     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1329     function includeInDividends(address account) external onlyOwner {
1330         dividendTracker.includeInDividends(account);
1331     }
1332     
1333     // once enabled, can never be turned off
1334     function enableTrading() external onlyOwner {
1335         require(!tradingActive, "Cannot re-enable trading");
1336         tradingActive = true;
1337         swapEnabled = true;
1338         tradingActiveBlock = block.number;
1339     }
1340     
1341     // only use to disable contract sales if absolutely necessary (emergency use only)
1342     function updateSwapEnabled(bool enabled) external onlyOwner(){
1343         swapEnabled = enabled;
1344     }
1345 
1346     function updateMaxAmount(uint256 newNum) external onlyOwner {
1347         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1348         maxTransactionAmount = newNum * (10**18);
1349     }
1350     
1351     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1352         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1353         maxWallet = newNum * (10**18);
1354     }
1355     
1356     function updateBuyFees(uint256 _MarketingFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1357         MarketingBuyFee = _MarketingFee;
1358         rewardsBuyFee = _rewardsFee;
1359         liquidityBuyFee = _liquidityFee;
1360         totalBuyFees = MarketingBuyFee + rewardsBuyFee + liquidityBuyFee;
1361         require(totalBuyFees <= 250, "Must keep fees at 10% or less");
1362     }
1363     
1364     function updateSellFees(uint256 _MarketingFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1365         MarketingSellFee = _MarketingFee;
1366         rewardsSellFee = _rewardsFee;
1367         liquiditySellFee = _liquidityFee;
1368         totalSellFees = MarketingSellFee + rewardsSellFee + liquiditySellFee;
1369         require(totalSellFees <= 250, "Must keep fees at 10% or less");
1370     }
1371 
1372     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1373         _isExcludedMaxTransactionAmount[updAds] = isEx;
1374         emit ExcludedMaxTransactionAmount(updAds, isEx);
1375     }
1376 
1377     function excludeFromFees(address account, bool excluded) public onlyOwner {
1378         _isExcludedFromFees[account] = excluded;
1379 
1380         emit ExcludeFromFees(account, excluded);
1381     }
1382 
1383     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1384         for(uint256 i = 0; i < accounts.length; i++) {
1385             _isExcludedFromFees[accounts[i]] = excluded;
1386         }
1387 
1388         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1389     }
1390 
1391     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1392         require(pair != uniswapV2Pair, "The SushiSwap pair cannot be removed from automatedMarketMakerPairs");
1393 
1394         _setAutomatedMarketMakerPair(pair, value);
1395     }
1396 
1397     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1398         automatedMarketMakerPairs[pair] = value;
1399 
1400         excludeFromMaxTransaction(pair, value);
1401         
1402         if(value) {
1403             dividendTracker.excludeFromDividends(pair);
1404         }
1405 
1406         emit SetAutomatedMarketMakerPair(pair, value);
1407     }
1408 
1409     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1410         require(newMarketingWallet != address(0), "may not set to 0 address");
1411         excludeFromFees(newMarketingWallet, true);
1412         emit MarketingWalletUpdated(newMarketingWallet, MarketingWallet);
1413         MarketingWallet = newMarketingWallet;
1414     }
1415 
1416     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1417         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1418         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1419         emit GasForProcessingUpdated(newValue, gasForProcessing);
1420         gasForProcessing = newValue;
1421     }
1422 
1423     function updateClaimWait(uint256 claimWait) external onlyOwner {
1424         dividendTracker.updateClaimWait(claimWait);
1425     }
1426 
1427     function getClaimWait() external view returns(uint256) {
1428         return dividendTracker.claimWait();
1429     }
1430 
1431     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1432         return dividendTracker.totalDividendsDistributed(rewardToken);
1433     }
1434 
1435     function isExcludedFromFees(address account) external view returns(bool) {
1436         return _isExcludedFromFees[account];
1437     }
1438 
1439     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1440     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1441   	}
1442 
1443 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1444 		return dividendTracker.holderBalance(account);
1445 	}
1446 
1447     function getAccountDividendsInfo(address account, address rewardToken)
1448         external view returns (
1449             address,
1450             int256,
1451             int256,
1452             uint256,
1453             uint256,
1454             uint256,
1455             uint256,
1456             uint256) {
1457         return dividendTracker.getAccount(account, rewardToken);
1458     }
1459 
1460 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1461         external view returns (
1462             address,
1463             int256,
1464             int256,
1465             uint256,
1466             uint256,
1467             uint256,
1468             uint256,
1469             uint256) {
1470     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1471     }
1472 
1473 	function processDividendTracker(uint256 gas) external {
1474 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1475 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1476     }
1477 
1478     function claim() external {
1479 		dividendTracker.processAccount(payable(msg.sender), false);
1480     }
1481 
1482     function getLastProcessedIndex() external view returns(uint256) {
1483     	return dividendTracker.getLastProcessedIndex();
1484     }
1485 
1486     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1487         return dividendTracker.getNumberOfTokenHolders();
1488     }
1489     
1490     function getNumberOfDividends() external view returns(uint256) {
1491         return dividendTracker.totalBalance();
1492     }
1493     
1494     // remove limits after token is stable
1495     function removeLimits() external onlyOwner returns (bool){
1496         limitsInEffect = false;
1497         transferDelayEnabled = false;
1498         return true;
1499     }
1500     
1501     function _transfer(
1502         address from,
1503         address to,
1504         uint256 amount
1505     ) internal override {
1506         require(from != address(0), "ERC20: transfer from the zero address");
1507         require(to != address(0), "ERC20: transfer to the zero address");
1508         
1509          if(amount == 0) {
1510             super._transfer(from, to, 0);
1511             return;
1512         }
1513         
1514         if(!tradingActive){
1515             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1516         }
1517         
1518         if(limitsInEffect){
1519             if (
1520                 from != owner() &&
1521                 to != owner() &&
1522                 to != address(0) &&
1523                 to != address(0xdead) &&
1524                 !swapping
1525             ){
1526 
1527                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1528                 if (transferDelayEnabled){
1529                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1530                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1531                         _holderLastTransferTimestamp[tx.origin] = block.number;
1532                     }
1533                 }
1534                 
1535                 //when buy
1536                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1537                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1538                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1539                 } 
1540                 //when sell
1541                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1542                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1543                 }
1544                 else if(!_isExcludedMaxTransactionAmount[to]) {
1545                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1546                 }
1547             }
1548         }
1549 
1550 		uint256 contractTokenBalance = balanceOf(address(this));
1551         
1552         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1553 
1554         if( 
1555             canSwap &&
1556             swapEnabled &&
1557             !swapping &&
1558             !automatedMarketMakerPairs[from] &&
1559             !_isExcludedFromFees[from] &&
1560             !_isExcludedFromFees[to]
1561         ) {
1562             swapping = true;
1563             swapBack();
1564             swapping = false;
1565         }
1566 
1567         bool takeFee = !swapping;
1568 
1569         // if any account belongs to _isExcludedFromFee account then remove the fee
1570         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1571             takeFee = false;
1572         }
1573         
1574         uint256 fees = 0;
1575         
1576         // no taxes on transfers (non buys/sells)
1577         if(takeFee){
1578             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1579                 fees = amount.mul(99).div(100);
1580                 tokensForLiquidity += fees * 33 / 99;
1581                 tokensForRewards += fees * 33 / 99;
1582                 tokensForMarketing += fees * 33 / 99;
1583             }
1584 
1585             // on sell
1586             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1587                 fees = amount.mul(totalSellFees).div(feeDivisor);
1588                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1589                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1590                 tokensForMarketing += fees * MarketingSellFee / totalSellFees;
1591             }
1592             
1593             // on buy
1594             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1595         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1596         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1597                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1598                 tokensForMarketing += fees * MarketingBuyFee / totalBuyFees;
1599             }
1600 
1601             if(fees > 0){    
1602                 super._transfer(from, address(this), fees);
1603             }
1604         	
1605         	amount -= fees;
1606         }
1607 
1608         super._transfer(from, to, amount);
1609 
1610         dividendTracker.setBalance(payable(from), balanceOf(from));
1611         dividendTracker.setBalance(payable(to), balanceOf(to));
1612 
1613         if(!swapping && gasForProcessing > 0) {
1614 	    	uint256 gas = gasForProcessing;
1615 
1616 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1617 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1618 	    	}
1619 	    	catch {}
1620         }
1621     }
1622     
1623     function swapTokensForEth(uint256 tokenAmount) private {
1624 
1625         // generate the uniswap pair path of token -> weth
1626         address[] memory path = new address[](2);
1627         path[0] = address(this);
1628         path[1] = uniswapV2Router.WETH();
1629 
1630         _approve(address(this), address(uniswapV2Router), tokenAmount);
1631 
1632         // make the swap
1633         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1634             tokenAmount,
1635             0, // accept any amount of ETH
1636             path,
1637             address(this),
1638             block.timestamp
1639         );
1640         
1641     }
1642     
1643     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1644         // approve token transfer to cover all possible scenarios
1645         _approve(address(this), address(uniswapV2Router), tokenAmount);
1646 
1647         // add the liquidity
1648         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1649             address(this),
1650             tokenAmount,
1651             0, // slippage is unavoidable
1652             0, // slippage is unavoidable
1653             address(0xdead),
1654             block.timestamp
1655         );
1656 
1657     }
1658     
1659     function swapBack() private {
1660         uint256 contractBalance = balanceOf(address(this));
1661         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForRewards;
1662         
1663         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1664         
1665         // Halve the amount of liquidity tokens
1666         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1667         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1668         
1669         uint256 initialETHBalance = address(this).balance;
1670 
1671         swapTokensForEth(amountToSwapForETH); 
1672         
1673         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1674         
1675         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap - (tokensForLiquidity/2));
1676         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1677         
1678         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForRewards;
1679         
1680         tokensForLiquidity = 0;
1681         tokensForMarketing = 0;
1682         tokensForRewards = 0;
1683         
1684         
1685         
1686         if(liquidityTokens > 0 && ethForLiquidity > 0){
1687             addLiquidity(liquidityTokens, ethForLiquidity);
1688             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1689         }
1690         
1691         // call twice to force buy of both reward tokens.
1692         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1693 
1694         (success,) = address(MarketingWallet).call{value: address(this).balance}("");
1695     }
1696 
1697     function withdrawStuckEth() external onlyOwner {
1698         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1699         require(success, "failed to withdraw");
1700     }
1701 
1702     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1703         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1704         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1705         lpWithdrawRequestTimestamp = block.timestamp;
1706         lpWithdrawRequestPending = true;
1707         lpPercToWithDraw = percToWithdraw;
1708         emit RequestedLPWithdraw();
1709     }
1710 
1711     function nextAvailableLpWithdrawDate() public view returns (uint256){
1712         if(lpWithdrawRequestPending){
1713             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1714         }
1715         else {
1716             return 0;  // 0 means no open requests
1717         }
1718     }
1719 
1720     function withdrawRequestedLP() external onlyOwner {
1721         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1722         lpWithdrawRequestTimestamp = 0;
1723         lpWithdrawRequestPending = false;
1724 
1725         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1726         
1727         lpPercToWithDraw = 0;
1728 
1729         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1730     }
1731 
1732     function cancelLPWithdrawRequest() external onlyOwner {
1733         lpWithdrawRequestPending = false;
1734         lpPercToWithDraw = 0;
1735         lpWithdrawRequestTimestamp = 0;
1736         emit CanceledLpWithdrawRequest();
1737     }
1738 }