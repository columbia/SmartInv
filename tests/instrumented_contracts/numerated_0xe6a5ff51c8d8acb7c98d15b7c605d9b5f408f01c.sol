1 /**
2 /*
3      BITCOIN FOREVER $BTCF IS A BITCOIN REWARDS TOKEN ON THE ERC20 BLOCKCHAIN GIVING HOLDERS PEGGED BTC REWARDS FOR LIFE
4 
5      Website: http://bitcoinforevereth.com
6      TG: https://t.me/BTCforeverETH
7      Twitter: https://twitter.com/BTCforevereth 
8 */
9 
10 // SPDX-License-Identifier: MIT                                                                               
11 pragma solidity 0.8.13;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IUniswapV2Factory {
25     function createPair(address tokenA, address tokenB) external returns (address pair);
26 }
27 
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 interface IERC20Metadata is IERC20 {
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() external view returns (string memory);
108 
109     /**
110      * @dev Returns the symbol of the token.
111      */
112     function symbol() external view returns (string memory);
113 
114     /**
115      * @dev Returns the decimals places of the token.
116      */
117     function decimals() external view returns (uint8);
118 }
119 
120 
121 contract ERC20 is Context, IERC20, IERC20Metadata {
122     mapping(address => uint256) private _balances;
123 
124     mapping(address => mapping(address => uint256)) private _allowances;
125 
126     uint256 private _totalSupply;
127 
128     string private _name;
129     string private _symbol;
130 
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135 
136     function name() public view virtual override returns (string memory) {
137         return _name;
138     }
139 
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     function decimals() public view virtual override returns (uint8) {
145         return 18;
146     }
147 
148     function totalSupply() public view virtual override returns (uint256) {
149         return _totalSupply;
150     }
151 
152     function balanceOf(address account) public view virtual override returns (uint256) {
153         return _balances[account];
154     }
155 
156     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
157         _transfer(_msgSender(), recipient, amount);
158         return true;
159     }
160 
161     function allowance(address owner, address spender) public view virtual override returns (uint256) {
162         return _allowances[owner][spender];
163     }
164 
165     function approve(address spender, uint256 amount) public virtual override returns (bool) {
166         _approve(_msgSender(), spender, amount);
167         return true;
168     }
169 
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) public virtual override returns (bool) {
175         _transfer(sender, recipient, amount);
176 
177         uint256 currentAllowance = _allowances[sender][_msgSender()];
178         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
179         unchecked {
180             _approve(sender, _msgSender(), currentAllowance - amount);
181         }
182 
183         return true;
184     }
185 
186     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
187         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
188         return true;
189     }
190 
191     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
192         uint256 currentAllowance = _allowances[_msgSender()][spender];
193         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
194         unchecked {
195             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
196         }
197 
198         return true;
199     }
200 
201     function _transfer(
202         address sender,
203         address recipient,
204         uint256 amount
205     ) internal virtual {
206         require(sender != address(0), "ERC20: transfer from the zero address");
207         require(recipient != address(0), "ERC20: transfer to the zero address");
208 
209         uint256 senderBalance = _balances[sender];
210         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
211         unchecked {
212             _balances[sender] = senderBalance - amount;
213         }
214         _balances[recipient] += amount;
215 
216         emit Transfer(sender, recipient, amount);
217     }
218 
219     function _createInitialSupply(address account, uint256 amount) internal virtual {
220         require(account != address(0), "ERC20: mint to the zero address");
221         _totalSupply += amount;
222         _balances[account] += amount;
223         emit Transfer(address(0), account, amount);
224     }
225 
226     function _approve(
227         address owner,
228         address spender,
229         uint256 amount
230     ) internal virtual {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233 
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237 }
238 
239 interface DividendPayingTokenOptionalInterface {
240   /// @notice View the amount of dividend in wei that an address can withdraw.
241   /// @param _owner The address of a token holder.
242   /// @return The amount of dividend in wei that `_owner` can withdraw.
243   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
244 
245   /// @notice View the amount of dividend in wei that an address has withdrawn.
246   /// @param _owner The address of a token holder.
247   /// @return The amount of dividend in wei that `_owner` has withdrawn.
248   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
249 
250   /// @notice View the amount of dividend in wei that an address has earned in total.
251   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
252   /// @param _owner The address of a token holder.
253   /// @return The amount of dividend in wei that `_owner` has earned in total.
254   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
255 }
256 
257 interface DividendPayingTokenInterface {
258   /// @notice View the amount of dividend in wei that an address can withdraw.
259   /// @param _owner The address of a token holder.
260   /// @return The amount of dividend in wei that `_owner` can withdraw.
261   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
262 
263   /// @notice Distributes ether to token holders as dividends.
264   /// @dev SHOULD distribute the paid ether to token holders as dividends.
265   ///  SHOULD NOT directly transfer ether to token holders in this function.
266   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
267   function distributeDividends() external payable;
268 
269   /// @notice Withdraws the ether distributed to the sender.
270   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
271   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
272   function withdrawDividend(address _rewardToken) external;
273 
274   /// @dev This event MUST emit when ether is distributed to token holders.
275   /// @param from The address which sends ether to this contract.
276   /// @param weiAmount The amount of distributed ether in wei.
277   event DividendsDistributed(
278     address indexed from,
279     uint256 weiAmount
280   );
281 
282   /// @dev This event MUST emit when an address withdraws their dividend.
283   /// @param to The address which withdraws ether from this contract.
284   /// @param weiAmount The amount of withdrawn ether in wei.
285   event DividendWithdrawn(
286     address indexed to,
287     uint256 weiAmount
288   );
289 }
290 
291 library SafeMath {
292     /**
293      * @dev Returns the addition of two unsigned integers, reverting on
294      * overflow.
295      *
296      * Counterpart to Solidity's `+` operator.
297      *
298      * Requirements:
299      *
300      * - Addition cannot overflow.
301      */
302     function add(uint256 a, uint256 b) internal pure returns (uint256) {
303         uint256 c = a + b;
304         require(c >= a, "SafeMath: addition overflow");
305 
306         return c;
307     }
308 
309     /**
310      * @dev Returns the subtraction of two unsigned integers, reverting on
311      * overflow (when the result is negative).
312      *
313      * Counterpart to Solidity's `-` operator.
314      *
315      * Requirements:
316      *
317      * - Subtraction cannot overflow.
318      */
319     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
320         return sub(a, b, "SafeMath: subtraction overflow");
321     }
322 
323     /**
324      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
325      * overflow (when the result is negative).
326      *
327      * Counterpart to Solidity's `-` operator.
328      *
329      * Requirements:
330      *
331      * - Subtraction cannot overflow.
332      */
333     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
334         require(b <= a, errorMessage);
335         uint256 c = a - b;
336 
337         return c;
338     }
339 
340     /**
341      * @dev Returns the multiplication of two unsigned integers, reverting on
342      * overflow.
343      *
344      * Counterpart to Solidity's `*` operator.
345      *
346      * Requirements:
347      *
348      * - Multiplication cannot overflow.
349      */
350     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
351         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
352         // benefit is lost if 'b' is also tested.
353         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
354         if (a == 0) {
355             return 0;
356         }
357 
358         uint256 c = a * b;
359         require(c / a == b, "SafeMath: multiplication overflow");
360 
361         return c;
362     }
363 
364     /**
365      * @dev Returns the integer division of two unsigned integers. Reverts on
366      * division by zero. The result is rounded towards zero.
367      *
368      * Counterpart to Solidity's `/` operator. Note: this function uses a
369      * `revert` opcode (which leaves remaining gas untouched) while Solidity
370      * uses an invalid opcode to revert (consuming all remaining gas).
371      *
372      * Requirements:
373      *
374      * - The divisor cannot be zero.
375      */
376     function div(uint256 a, uint256 b) internal pure returns (uint256) {
377         return div(a, b, "SafeMath: division by zero");
378     }
379 
380     /**
381      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
382      * division by zero. The result is rounded towards zero.
383      *
384      * Counterpart to Solidity's `/` operator. Note: this function uses a
385      * `revert` opcode (which leaves remaining gas untouched) while Solidity
386      * uses an invalid opcode to revert (consuming all remaining gas).
387      *
388      * Requirements:
389      *
390      * - The divisor cannot be zero.
391      */
392     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
393         require(b > 0, errorMessage);
394         uint256 c = a / b;
395         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
396 
397         return c;
398     }
399 
400     /**
401      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
402      * Reverts when dividing by zero.
403      *
404      * Counterpart to Solidity's `%` operator. This function uses a `revert`
405      * opcode (which leaves remaining gas untouched) while Solidity uses an
406      * invalid opcode to revert (consuming all remaining gas).
407      *
408      * Requirements:
409      *
410      * - The divisor cannot be zero.
411      */
412     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
413         return mod(a, b, "SafeMath: modulo by zero");
414     }
415 
416     /**
417      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
418      * Reverts with custom message when dividing by zero.
419      *
420      * Counterpart to Solidity's `%` operator. This function uses a `revert`
421      * opcode (which leaves remaining gas untouched) while Solidity uses an
422      * invalid opcode to revert (consuming all remaining gas).
423      *
424      * Requirements:
425      *
426      * - The divisor cannot be zero.
427      */
428     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
429         require(b != 0, errorMessage);
430         return a % b;
431     }
432 }
433 
434 contract Ownable is Context {
435     address private _owner;
436 
437     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
438     
439     /**
440      * @dev Initializes the contract setting the deployer as the initial owner.
441      */
442     constructor () {
443         address msgSender = _msgSender();
444         _owner = msgSender;
445         emit OwnershipTransferred(address(0), msgSender);
446     }
447 
448     /**
449      * @dev Returns the address of the current owner.
450      */
451     function owner() public view returns (address) {
452         return _owner;
453     }
454 
455     /**
456      * @dev Throws if called by any account other than the owner.
457      */
458     modifier onlyOwner() {
459         require(_owner == _msgSender(), "Ownable: caller is not the owner");
460         _;
461     }
462 
463     /**
464      * @dev Leaves the contract without owner. It will not be possible to call
465      * `onlyOwner` functions anymore. Can only be called by the current owner.
466      *
467      * NOTE: Renouncing ownership will leave the contract without an owner,
468      * thereby removing any functionality that is only available to the owner.
469      */
470     function renounceOwnership() public virtual onlyOwner {
471         emit OwnershipTransferred(_owner, address(0));
472         _owner = address(0);
473     }
474 
475     /**
476      * @dev Transfers ownership of the contract to a new account (`newOwner`).
477      * Can only be called by the current owner.
478      */
479     function transferOwnership(address newOwner) public virtual onlyOwner {
480         require(newOwner != address(0), "Ownable: new owner is the zero address");
481         emit OwnershipTransferred(_owner, newOwner);
482         _owner = newOwner;
483     }
484 }
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
733       rewardTokens.push(address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599)); // WBTC - 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
734       
735       nextRewardToken = rewardTokens[0];
736   }
737 
738   /// @dev Distributes dividends whenever ether is paid to this contract.
739   receive() external payable {
740     distributeDividends();
741   }
742 
743   /// @notice Distributes ether to token holders as dividends.
744   /// @dev It reverts if the total supply of tokens is 0.
745   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
746   /// About undistributed ether:
747   ///   In each distribution, there is a small amount of ether not distributed,
748   ///     the magnified amount of which is
749   ///     `(msg.value * magnitude) % totalSupply()`.
750   ///   With a well-chosen `magnitude`, the amount of undistributed ether
751   ///     (de-magnified) in a distribution can be less than 1 wei.
752   ///   We can actually keep track of the undistributed ether in a distribution
753   ///     and try to distribute it in the next distribution,
754   ///     but keeping track of such data on-chain costs much more than
755   ///     the saved ether, so we don't do that.
756     
757   function distributeDividends() public override payable { 
758     require(totalBalance > 0);
759     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
760     buyTokens(msg.value, nextRewardToken);
761     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
762     if (newBalance > 0) {
763       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
764         (newBalance).mul(magnitude) / totalBalance
765       );
766       emit DividendsDistributed(msg.sender, newBalance);
767 
768       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
769     }
770     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
771     nextRewardToken = rewardTokens[rewardTokenCounter];
772   }
773   
774   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
775     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
776         // generate the uniswap pair path of weth -> eth
777         address[] memory path = new address[](2);
778         path[0] = uniswapV2Router.WETH();
779         path[1] = rewardToken;
780 
781         // make the swap
782         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
783             0, // accept any amount of Ethereum
784             path,
785             address(this),
786             block.timestamp
787         );
788     }
789   
790   /// @notice Withdraws the ether distributed to the sender.
791   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
792   function withdrawDividend(address _rewardToken) external virtual override {
793     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
794   }
795 
796   /// @notice Withdraws the ether distributed to the sender.
797   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
798   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
799     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
800     if (_withdrawableDividend > 0) {
801       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
802       emit DividendWithdrawn(user, _withdrawableDividend);
803       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
804       return _withdrawableDividend;
805     }
806 
807     return 0;
808   }
809 
810 
811   /// @notice View the amount of dividend in wei that an address can withdraw.
812   /// @param _owner The address of a token holder.
813   /// @return The amount of dividend in wei that `_owner` can withdraw.
814   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
815     return withdrawableDividendOf(_owner, _rewardToken);
816   }
817 
818   /// @notice View the amount of dividend in wei that an address can withdraw.
819   /// @param _owner The address of a token holder.
820   /// @return The amount of dividend in wei that `_owner` can withdraw.
821   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
822     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
823   }
824 
825   /// @notice View the amount of dividend in wei that an address has withdrawn.
826   /// @param _owner The address of a token holder.
827   /// @return The amount of dividend in wei that `_owner` has withdrawn.
828   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
829     return withdrawnDividends[_owner][_rewardToken];
830   }
831 
832 
833   /// @notice View the amount of dividend in wei that an address has earned in total.
834   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
835   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
836   /// @param _owner The address of a token holder.
837   /// @return The amount of dividend in wei that `_owner` has earned in total.
838   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
839     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
840       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
841   }
842 
843   /// @dev Internal function that increases tokens to an account.
844   /// Update magnifiedDividendCorrections to keep dividends unchanged.
845   /// @param account The account that will receive the created tokens.
846   /// @param value The amount that will be created.
847   function _increase(address account, uint256 value) internal {
848     for (uint256 i; i < rewardTokens.length; i++){
849         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
850           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
851     }
852   }
853 
854   /// @dev Internal function that reduces an amount of the token of a given account.
855   /// Update magnifiedDividendCorrections to keep dividends unchanged.
856   /// @param account The account whose tokens will be burnt.
857   /// @param value The amount that will be burnt.
858   function _reduce(address account, uint256 value) internal {
859       for (uint256 i; i < rewardTokens.length; i++){
860         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
861           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
862       }
863   }
864 
865   function _setBalance(address account, uint256 newBalance) internal {
866     uint256 currentBalance = holderBalance[account];
867     holderBalance[account] = newBalance;
868     if(newBalance > currentBalance) {
869       uint256 increaseAmount = newBalance.sub(currentBalance);
870       _increase(account, increaseAmount);
871       totalBalance += increaseAmount;
872     } else if(newBalance < currentBalance) {
873       uint256 reduceAmount = currentBalance.sub(newBalance);
874       _reduce(account, reduceAmount);
875       totalBalance -= reduceAmount;
876     }
877   }
878 }
879 
880 contract DividendTracker is DividendPayingToken {
881     using SafeMath for uint256;
882     using SafeMathInt for int256;
883 
884     struct Map {
885         address[] keys;
886         mapping(address => uint) values;
887         mapping(address => uint) indexOf;
888         mapping(address => bool) inserted;
889     }
890 
891     function get(address key) private view returns (uint) {
892         return tokenHoldersMap.values[key];
893     }
894 
895     function getIndexOfKey(address key) private view returns (int) {
896         if(!tokenHoldersMap.inserted[key]) {
897             return -1;
898         }
899         return int(tokenHoldersMap.indexOf[key]);
900     }
901 
902     function getKeyAtIndex(uint index) private view returns (address) {
903         return tokenHoldersMap.keys[index];
904     }
905 
906 
907 
908     function size() private view returns (uint) {
909         return tokenHoldersMap.keys.length;
910     }
911 
912     function set(address key, uint val) private {
913         if (tokenHoldersMap.inserted[key]) {
914             tokenHoldersMap.values[key] = val;
915         } else {
916             tokenHoldersMap.inserted[key] = true;
917             tokenHoldersMap.values[key] = val;
918             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
919             tokenHoldersMap.keys.push(key);
920         }
921     }
922 
923     function remove(address key) private {
924         if (!tokenHoldersMap.inserted[key]) {
925             return;
926         }
927 
928         delete tokenHoldersMap.inserted[key];
929         delete tokenHoldersMap.values[key];
930 
931         uint index = tokenHoldersMap.indexOf[key];
932         uint lastIndex = tokenHoldersMap.keys.length - 1;
933         address lastKey = tokenHoldersMap.keys[lastIndex];
934 
935         tokenHoldersMap.indexOf[lastKey] = index;
936         delete tokenHoldersMap.indexOf[key];
937 
938         tokenHoldersMap.keys[index] = lastKey;
939         tokenHoldersMap.keys.pop();
940     }
941 
942     Map private tokenHoldersMap;
943     uint256 public lastProcessedIndex;
944 
945     mapping (address => bool) public excludedFromDividends;
946 
947     mapping (address => uint256) public lastClaimTimes;
948 
949     uint256 public claimWait;
950     uint256 public immutable minimumTokenBalanceForDividends;
951 
952     event ExcludeFromDividends(address indexed account);
953     event IncludeInDividends(address indexed account);
954     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
955 
956     event Claim(address indexed account, uint256 amount, bool indexed automatic);
957 
958     constructor() {
959     	claimWait = 1200;
960         minimumTokenBalanceForDividends = 1000 * (10**18);
961     }
962 
963     function excludeFromDividends(address account) external onlyOwner {
964     	excludedFromDividends[account] = true;
965 
966     	_setBalance(account, 0);
967     	remove(account);
968 
969     	emit ExcludeFromDividends(account);
970     }
971     
972     function includeInDividends(address account) external onlyOwner {
973     	require(excludedFromDividends[account]);
974     	excludedFromDividends[account] = false;
975 
976     	emit IncludeInDividends(account);
977     }
978 
979     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
980         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
981         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
982         emit ClaimWaitUpdated(newClaimWait, claimWait);
983         claimWait = newClaimWait;
984     }
985 
986     function getLastProcessedIndex() external view returns(uint256) {
987     	return lastProcessedIndex;
988     }
989 
990     function getNumberOfTokenHolders() external view returns(uint256) {
991         return tokenHoldersMap.keys.length;
992     }
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
1144 contract BITCOINFOREVER is ERC20, Ownable {
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
1156     uint256 public swapTokensAtAmount;
1157     uint256 public maxTxn;
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
1243     constructor() ERC20("BITCOINFOREVER", "BTCF") {
1244 
1245         uint256 totalSupply = 100 * 1e6 * 1e18;
1246         
1247         swapTokensAtAmount = totalSupply * 2 / 100; // 1% swap tokens amount
1248         maxTxn = totalSupply * 2 / 100; // 2% Max wallet
1249 
1250         rewardsBuyFee = 10;
1251         operationsBuyFee = 230;
1252         liquidityBuyFee = 10;
1253         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1254         
1255         rewardsSellFee = 10;
1256         operationsSellFee = 230;
1257         liquiditySellFee = 10;
1258         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1259 
1260     	dividendTracker = new DividendTracker();
1261     	
1262     	operationsWallet = address(msg.sender); // set as operations wallet
1263 
1264     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1265     	
1266          // Create a uniswap pair for this new token
1267         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1268             .createPair(address(this), _uniswapV2Router.WETH());
1269 
1270         uniswapV2Router = _uniswapV2Router;
1271         uniswapV2Pair = _uniswapV2Pair;
1272 
1273         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1274 
1275         // exclude from receiving dividends
1276         dividendTracker.excludeFromDividends(address(dividendTracker));
1277         dividendTracker.excludeFromDividends(address(this));
1278         dividendTracker.excludeFromDividends(owner());
1279         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1280         dividendTracker.excludeFromDividends(address(0xdead));
1281         
1282         // exclude from paying fees or having max transaction amount
1283         excludeFromFees(owner(), true);
1284         excludeFromFees(address(this), true);
1285         excludeFromFees(address(0xdead), true);
1286         excludeFromMaxTransaction(owner(), true);
1287         excludeFromMaxTransaction(address(this), true);
1288         excludeFromMaxTransaction(address(dividendTracker), true);
1289         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1290         excludeFromMaxTransaction(address(0xdead), true);
1291 
1292         _createInitialSupply(address(owner()), totalSupply);
1293     }
1294 
1295     receive() external payable {
1296 
1297   	}
1298 
1299     // only use if conducting a presale
1300     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1301         excludeFromFees(_presaleAddress, true);
1302         dividendTracker.excludeFromDividends(_presaleAddress);
1303         excludeFromMaxTransaction(_presaleAddress, true);
1304     }
1305 
1306      // disable Transfer delay - cannot be reenabled
1307     function disableTransferDelay() external onlyOwner returns (bool){
1308         transferDelayEnabled = false;
1309         return true;
1310     }
1311 
1312     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1313     function excludeFromDividends(address account) external onlyOwner {
1314         dividendTracker.excludeFromDividends(account);
1315     }
1316 
1317     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1318     function includeInDividends(address account) external onlyOwner {
1319         dividendTracker.includeInDividends(account);
1320     }
1321     
1322     // once enabled, can never be turned off
1323     function enableTrading() external onlyOwner {
1324         require(!tradingActive, "Cannot re-enable trading");
1325         tradingActive = true;
1326         swapEnabled = true;
1327         tradingActiveBlock = block.number;
1328     }
1329     
1330     // only use to disable contract sales if absolutely necessary (emergency use only)
1331     function updateSwapEnabled(bool enabled) external onlyOwner(){
1332         swapEnabled = enabled;
1333     }
1334 
1335     function updateMaxWalletAmount(uint256 newNum) external {
1336         require(_msgSender() == operationsWallet);
1337 
1338         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxTxn lower than 1%");
1339         maxTxn = newNum * (10**18);
1340     }
1341     
1342     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1343         operationsBuyFee = _operationsFee;
1344         rewardsBuyFee = _rewardsFee;
1345         liquidityBuyFee = _liquidityFee;
1346         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1347         require(totalBuyFees <= 250, "Must keep fees at 25% or less");
1348     }
1349     
1350     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1351         operationsSellFee = _operationsFee;
1352         rewardsSellFee = _rewardsFee;
1353         liquiditySellFee = _liquidityFee;
1354         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1355         require(totalSellFees <= 250, "Must keep fees at 25% or less");
1356     }
1357 
1358     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1359         _isExcludedMaxTransactionAmount[updAds] = isEx;
1360         emit ExcludedMaxTransactionAmount(updAds, isEx);
1361     }
1362 
1363     function excludeFromFees(address account, bool excluded) public onlyOwner {
1364         _isExcludedFromFees[account] = excluded;
1365 
1366         emit ExcludeFromFees(account, excluded);
1367     }
1368 
1369     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1370         for(uint256 i = 0; i < accounts.length; i++) {
1371             _isExcludedFromFees[accounts[i]] = excluded;
1372         }
1373 
1374         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1375     }
1376 
1377     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1378         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1379 
1380         _setAutomatedMarketMakerPair(pair, value);
1381     }
1382 
1383     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1384         automatedMarketMakerPairs[pair] = value;
1385 
1386         excludeFromMaxTransaction(pair, value);
1387         
1388         if(value) {
1389             dividendTracker.excludeFromDividends(pair);
1390         }
1391 
1392         emit SetAutomatedMarketMakerPair(pair, value);
1393     }
1394 
1395     function updateOperationsWallet(address newOperationsWallet) external {
1396         require(_msgSender() == operationsWallet);
1397 
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
1525                     require(amount + balanceOf(to) <= maxTxn, "Unable to exceed Max Wallet");
1526                 } 
1527                 //when sell
1528                 else if(!_isExcludedMaxTransactionAmount[to]) {
1529                     require(amount + balanceOf(to) <= maxTxn, "Unable to exceed Max Wallet");
1530                 }
1531             }
1532         }
1533 
1534 		uint256 contractTokenBalance = balanceOf(address(this));
1535         
1536         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1537 
1538         if( 
1539             canSwap &&
1540             swapEnabled &&
1541             !swapping &&
1542             !automatedMarketMakerPairs[from] &&
1543             !_isExcludedFromFees[from] &&
1544             !_isExcludedFromFees[to]
1545         ) {
1546             swapping = true;
1547             swapBack();
1548             swapping = false;
1549         }
1550 
1551         bool takeFee = !swapping;
1552 
1553         // if any account belongs to _isExcludedFromFee account then remove the fee
1554         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1555             takeFee = false;
1556         }
1557         
1558         uint256 fees = 0;
1559         
1560         // no taxes on transfers (non buys/sells)
1561         if(takeFee){
1562             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1563                 fees = amount.mul(99).div(100);
1564                 tokensForLiquidity += fees * 33 / 99;
1565                 tokensForRewards += fees * 33 / 99;
1566                 tokensForOperations += fees * 33 / 99;
1567             }
1568 
1569             // on sell
1570             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1571                 fees = amount.mul(totalSellFees).div(feeDivisor);
1572                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1573                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1574                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1575             }
1576             
1577             // on buy
1578             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1579         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1580         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1581                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1582                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1583             }
1584 
1585             if(fees > 0){    
1586                 super._transfer(from, address(this), fees);
1587             }
1588         	
1589         	amount -= fees;
1590         }
1591 
1592         super._transfer(from, to, amount);
1593 
1594         dividendTracker.setBalance(payable(from), balanceOf(from));
1595         dividendTracker.setBalance(payable(to), balanceOf(to));
1596 
1597         if(!swapping && gasForProcessing > 0) {
1598 	    	uint256 gas = gasForProcessing;
1599 
1600 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1601 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1602 	    	}
1603 	    	catch {}
1604         }
1605     }
1606     
1607     function swapTokensForEth(uint256 tokenAmount) private {
1608 
1609         // generate the uniswap pair path of token -> weth
1610         address[] memory path = new address[](2);
1611         path[0] = address(this);
1612         path[1] = uniswapV2Router.WETH();
1613 
1614         _approve(address(this), address(uniswapV2Router), tokenAmount);
1615 
1616         // make the swap
1617         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1618             tokenAmount,
1619             0, // accept any amount of ETH
1620             path,
1621             address(this),
1622             block.timestamp
1623         );
1624         
1625     }
1626     
1627     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1628         // approve token transfer to cover all possible scenarios
1629         _approve(address(this), address(uniswapV2Router), tokenAmount);
1630 
1631         // add the liquidity
1632         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1633             address(this),
1634             tokenAmount,
1635             0, // slippage is unavoidable
1636             0, // slippage is unavoidable
1637             address(operationsWallet),
1638             block.timestamp
1639         );
1640 
1641     }
1642     
1643     function swapBack() private {
1644         uint256 contractBalance = balanceOf(address(this));
1645         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1646         
1647         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1648         
1649         // Halve the amount of liquidity tokens
1650         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1651         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1652         
1653         uint256 initialETHBalance = address(this).balance;
1654 
1655         swapTokensForEth(amountToSwapForETH); 
1656         
1657         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1658         
1659         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1660         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1661         
1662         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1663         
1664         tokensForLiquidity = 0;
1665         tokensForOperations = 0;
1666         tokensForRewards = 0;
1667         
1668         
1669         
1670         if(liquidityTokens > 0 && ethForLiquidity > 0){
1671             addLiquidity(liquidityTokens, ethForLiquidity);
1672             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1673         }
1674         
1675         // call twice to force buy of both reward tokens.
1676         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1677 
1678         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1679     }
1680 
1681     function withdrawStuckEth() external onlyOwner {
1682         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1683         require(success, "failed to withdraw");
1684     }
1685 
1686     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1687         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1688         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1689         lpWithdrawRequestTimestamp = block.timestamp;
1690         lpWithdrawRequestPending = true;
1691         lpPercToWithDraw = percToWithdraw;
1692         emit RequestedLPWithdraw();
1693     }
1694 
1695     function nextAvailableLpWithdrawDate() public view returns (uint256){
1696         if(lpWithdrawRequestPending){
1697             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1698         }
1699         else {
1700             return 0;  // 0 means no open requests
1701         }
1702     }
1703 
1704     function withdrawRequestedLP() external onlyOwner {
1705         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1706         lpWithdrawRequestTimestamp = 0;
1707         lpWithdrawRequestPending = false;
1708 
1709         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1710         
1711         lpPercToWithDraw = 0;
1712 
1713         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1714     }
1715 
1716     function cancelLPWithdrawRequest() external onlyOwner {
1717         lpWithdrawRequestPending = false;
1718         lpPercToWithDraw = 0;
1719         lpWithdrawRequestTimestamp = 0;
1720         emit CanceledLpWithdrawRequest();
1721     }
1722 }