1 /**
2 /*
3      BLACK MATIC $BMT IS A MATIC REWARDS TOKEN ON THE ERC20 BLOCKCHAIN GIVING HOLDERS MATIC REWARDS FOR LIFE.
4 
5      Website: http://blackmaticeth.com
6      TG: https://t.me/blackmatic_eth
7      Twitter: https://twitter.com/BlackMaticEth
8      
9 */
10 
11 // SPDX-License-Identifier: MIT                                                                               
12 pragma solidity 0.8.13;
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
487 library SafeMathInt {
488     int256 private constant MIN_INT256 = int256(1) << 255;
489     int256 private constant MAX_INT256 = ~(int256(1) << 255);
490 
491     /**
492      * @dev Multiplies two int256 variables and fails on overflow.
493      */
494     function mul(int256 a, int256 b) internal pure returns (int256) {
495         int256 c = a * b;
496 
497         // Detect overflow when multiplying MIN_INT256 with -1
498         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
499         require((b == 0) || (c / b == a));
500         return c;
501     }
502 
503     /**
504      * @dev Division of two int256 variables and fails on overflow.
505      */
506     function div(int256 a, int256 b) internal pure returns (int256) {
507         // Prevent overflow when dividing MIN_INT256 by -1
508         require(b != -1 || a != MIN_INT256);
509 
510         // Solidity already throws when dividing by 0.
511         return a / b;
512     }
513 
514     /**
515      * @dev Subtracts two int256 variables and fails on overflow.
516      */
517     function sub(int256 a, int256 b) internal pure returns (int256) {
518         int256 c = a - b;
519         require((b >= 0 && c <= a) || (b < 0 && c > a));
520         return c;
521     }
522 
523     /**
524      * @dev Adds two int256 variables and fails on overflow.
525      */
526     function add(int256 a, int256 b) internal pure returns (int256) {
527         int256 c = a + b;
528         require((b >= 0 && c >= a) || (b < 0 && c < a));
529         return c;
530     }
531 
532     /**
533      * @dev Converts to absolute value, and fails on overflow.
534      */
535     function abs(int256 a) internal pure returns (int256) {
536         require(a != MIN_INT256);
537         return a < 0 ? -a : a;
538     }
539 
540 
541     function toUint256Safe(int256 a) internal pure returns (uint256) {
542         require(a >= 0);
543         return uint256(a);
544     }
545 }
546 
547 library SafeMathUint {
548   function toInt256Safe(uint256 a) internal pure returns (int256) {
549     int256 b = int256(a);
550     require(b >= 0);
551     return b;
552   }
553 }
554 
555 
556 interface IUniswapV2Router01 {
557     function factory() external pure returns (address);
558     function WETH() external pure returns (address);
559 
560     function addLiquidity(
561         address tokenA,
562         address tokenB,
563         uint amountADesired,
564         uint amountBDesired,
565         uint amountAMin,
566         uint amountBMin,
567         address to,
568         uint deadline
569     ) external returns (uint amountA, uint amountB, uint liquidity);
570     function addLiquidityETH(
571         address token,
572         uint amountTokenDesired,
573         uint amountTokenMin,
574         uint amountETHMin,
575         address to,
576         uint deadline
577     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
578     function removeLiquidity(
579         address tokenA,
580         address tokenB,
581         uint liquidity,
582         uint amountAMin,
583         uint amountBMin,
584         address to,
585         uint deadline
586     ) external returns (uint amountA, uint amountB);
587     function removeLiquidityETH(
588         address token,
589         uint liquidity,
590         uint amountTokenMin,
591         uint amountETHMin,
592         address to,
593         uint deadline
594     ) external returns (uint amountToken, uint amountETH);
595     function removeLiquidityWithPermit(
596         address tokenA,
597         address tokenB,
598         uint liquidity,
599         uint amountAMin,
600         uint amountBMin,
601         address to,
602         uint deadline,
603         bool approveMax, uint8 v, bytes32 r, bytes32 s
604     ) external returns (uint amountA, uint amountB);
605     function removeLiquidityETHWithPermit(
606         address token,
607         uint liquidity,
608         uint amountTokenMin,
609         uint amountETHMin,
610         address to,
611         uint deadline,
612         bool approveMax, uint8 v, bytes32 r, bytes32 s
613     ) external returns (uint amountToken, uint amountETH);
614     function swapExactTokensForTokens(
615         uint amountIn,
616         uint amountOutMin,
617         address[] calldata path,
618         address to,
619         uint deadline
620     ) external returns (uint[] memory amounts);
621     function swapTokensForExactTokens(
622         uint amountOut,
623         uint amountInMax,
624         address[] calldata path,
625         address to,
626         uint deadline
627     ) external returns (uint[] memory amounts);
628     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
629         external
630         payable
631         returns (uint[] memory amounts);
632     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
633         external
634         returns (uint[] memory amounts);
635     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
636         external
637         returns (uint[] memory amounts);
638     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
639         external
640         payable
641         returns (uint[] memory amounts);
642 
643     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
644     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
645     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
646     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
647     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
648 }
649 
650 interface IUniswapV2Router02 is IUniswapV2Router01 {
651     function removeLiquidityETHSupportingFeeOnTransferTokens(
652         address token,
653         uint liquidity,
654         uint amountTokenMin,
655         uint amountETHMin,
656         address to,
657         uint deadline
658     ) external returns (uint amountETH);
659     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
660         address token,
661         uint liquidity,
662         uint amountTokenMin,
663         uint amountETHMin,
664         address to,
665         uint deadline,
666         bool approveMax, uint8 v, bytes32 r, bytes32 s
667     ) external returns (uint amountETH);
668 
669     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
670         uint amountIn,
671         uint amountOutMin,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external;
676     function swapExactETHForTokensSupportingFeeOnTransferTokens(
677         uint amountOutMin,
678         address[] calldata path,
679         address to,
680         uint deadline
681     ) external payable;
682     function swapExactTokensForETHSupportingFeeOnTransferTokens(
683         uint amountIn,
684         uint amountOutMin,
685         address[] calldata path,
686         address to,
687         uint deadline
688     ) external;
689 }
690 
691 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
692   using SafeMath for uint256;
693   using SafeMathUint for uint256;
694   using SafeMathInt for int256;
695 
696   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
697   // For more discussion about choosing the value of `magnitude`,
698   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
699   uint256 constant internal magnitude = 2**128;
700 
701   mapping(address => uint256) internal magnifiedDividendPerShare;
702   address[] public rewardTokens;
703   address public nextRewardToken;
704   uint256 public rewardTokenCounter;
705   
706   IUniswapV2Router02 public immutable uniswapV2Router;
707   
708   
709   // About dividendCorrection:
710   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
711   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
712   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
713   //   `dividendOf(_user)` should not be changed,
714   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
715   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
716   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
717   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
718   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
719   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
720   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
721   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
722   
723   mapping (address => uint256) public holderBalance;
724   uint256 public totalBalance;
725 
726   mapping(address => uint256) public totalDividendsDistributed;
727   
728   constructor(){
729       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
730       uniswapV2Router = _uniswapV2Router; 
731       
732       // Mainnet
733 
734       rewardTokens.push(address(0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0)); // MATIC - 0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0
735       
736       nextRewardToken = rewardTokens[0];
737   }
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
907 
908 
909     function size() private view returns (uint) {
910         return tokenHoldersMap.keys.length;
911     }
912 
913     function set(address key, uint val) private {
914         if (tokenHoldersMap.inserted[key]) {
915             tokenHoldersMap.values[key] = val;
916         } else {
917             tokenHoldersMap.inserted[key] = true;
918             tokenHoldersMap.values[key] = val;
919             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
920             tokenHoldersMap.keys.push(key);
921         }
922     }
923 
924     function remove(address key) private {
925         if (!tokenHoldersMap.inserted[key]) {
926             return;
927         }
928 
929         delete tokenHoldersMap.inserted[key];
930         delete tokenHoldersMap.values[key];
931 
932         uint index = tokenHoldersMap.indexOf[key];
933         uint lastIndex = tokenHoldersMap.keys.length - 1;
934         address lastKey = tokenHoldersMap.keys[lastIndex];
935 
936         tokenHoldersMap.indexOf[lastKey] = index;
937         delete tokenHoldersMap.indexOf[key];
938 
939         tokenHoldersMap.keys[index] = lastKey;
940         tokenHoldersMap.keys.pop();
941     }
942 
943     Map private tokenHoldersMap;
944     uint256 public lastProcessedIndex;
945 
946     mapping (address => bool) public excludedFromDividends;
947 
948     mapping (address => uint256) public lastClaimTimes;
949 
950     uint256 public claimWait;
951     uint256 public immutable minimumTokenBalanceForDividends;
952 
953     event ExcludeFromDividends(address indexed account);
954     event IncludeInDividends(address indexed account);
955     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
956 
957     event Claim(address indexed account, uint256 amount, bool indexed automatic);
958 
959     constructor() {
960     	claimWait = 1200;
961         minimumTokenBalanceForDividends = 1000 * (10**18);
962     }
963 
964     function excludeFromDividends(address account) external onlyOwner {
965     	excludedFromDividends[account] = true;
966 
967     	_setBalance(account, 0);
968     	remove(account);
969 
970     	emit ExcludeFromDividends(account);
971     }
972     
973     function includeInDividends(address account) external onlyOwner {
974     	require(excludedFromDividends[account]);
975     	excludedFromDividends[account] = false;
976 
977     	emit IncludeInDividends(account);
978     }
979 
980     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
981         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
982         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
983         emit ClaimWaitUpdated(newClaimWait, claimWait);
984         claimWait = newClaimWait;
985     }
986 
987     function getLastProcessedIndex() external view returns(uint256) {
988     	return lastProcessedIndex;
989     }
990 
991     function getNumberOfTokenHolders() external view returns(uint256) {
992         return tokenHoldersMap.keys.length;
993     }
994 
995     function getAccount(address _account, address _rewardToken)
996         public view returns (
997             address account,
998             int256 index,
999             int256 iterationsUntilProcessed,
1000             uint256 withdrawableDividends,
1001             uint256 totalDividends,
1002             uint256 lastClaimTime,
1003             uint256 nextClaimTime,
1004             uint256 secondsUntilAutoClaimAvailable) {
1005         account = _account;
1006 
1007         index = getIndexOfKey(account);
1008 
1009         iterationsUntilProcessed = -1;
1010 
1011         if(index >= 0) {
1012             if(uint256(index) > lastProcessedIndex) {
1013                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1014             }
1015             else {
1016                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1017                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1018                                                         0;
1019 
1020 
1021                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1022             }
1023         }
1024 
1025 
1026         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1027         totalDividends = accumulativeDividendOf(account, _rewardToken);
1028 
1029         lastClaimTime = lastClaimTimes[account];
1030 
1031         nextClaimTime = lastClaimTime > 0 ?
1032                                     lastClaimTime.add(claimWait) :
1033                                     0;
1034 
1035         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1036                                                     nextClaimTime.sub(block.timestamp) :
1037                                                     0;
1038     }
1039 
1040     function getAccountAtIndex(uint256 index, address _rewardToken)
1041         external view returns (
1042             address,
1043             int256,
1044             int256,
1045             uint256,
1046             uint256,
1047             uint256,
1048             uint256,
1049             uint256) {
1050     	if(index >= size()) {
1051             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1052         }
1053 
1054         address account = getKeyAtIndex(index);
1055 
1056         return getAccount(account, _rewardToken);
1057     }
1058 
1059     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1060     	if(lastClaimTime > block.timestamp)  {
1061     		return false;
1062     	}
1063 
1064     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1065     }
1066 
1067     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1068     	if(excludedFromDividends[account]) {
1069     		return;
1070     	}
1071 
1072     	if(newBalance >= minimumTokenBalanceForDividends) {
1073             _setBalance(account, newBalance);
1074     		set(account, newBalance);
1075     	}
1076     	else {
1077             _setBalance(account, 0);
1078     		remove(account);
1079     	}
1080 
1081     	processAccount(account, true);
1082     }
1083     
1084     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1085     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1086 
1087     	if(numberOfTokenHolders == 0) {
1088     		return (0, 0, lastProcessedIndex);
1089     	}
1090 
1091     	uint256 _lastProcessedIndex = lastProcessedIndex;
1092 
1093     	uint256 gasUsed = 0;
1094 
1095     	uint256 gasLeft = gasleft();
1096 
1097     	uint256 iterations = 0;
1098     	uint256 claims = 0;
1099 
1100     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1101     		_lastProcessedIndex++;
1102 
1103     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1104     			_lastProcessedIndex = 0;
1105     		}
1106 
1107     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1108 
1109     		if(canAutoClaim(lastClaimTimes[account])) {
1110     			if(processAccount(payable(account), true)) {
1111     				claims++;
1112     			}
1113     		}
1114 
1115     		iterations++;
1116 
1117     		uint256 newGasLeft = gasleft();
1118 
1119     		if(gasLeft > newGasLeft) {
1120     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1121     		}
1122     		gasLeft = newGasLeft;
1123     	}
1124 
1125     	lastProcessedIndex = _lastProcessedIndex;
1126 
1127     	return (iterations, claims, lastProcessedIndex);
1128     }
1129 
1130     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1131         uint256 amount;
1132         bool paid;
1133         for (uint256 i; i < rewardTokens.length; i++){
1134             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1135             if(amount > 0) {
1136         		lastClaimTimes[account] = block.timestamp;
1137                 emit Claim(account, amount, automatic);
1138                 paid = true;
1139     	    }
1140         }
1141         return paid;
1142     }
1143 }
1144 
1145 contract BLACKMATIC is ERC20, Ownable {
1146     using SafeMath for uint256;
1147 
1148     IUniswapV2Router02 public immutable uniswapV2Router;
1149     address public immutable uniswapV2Pair;
1150 
1151     bool private swapping;
1152 
1153     DividendTracker public dividendTracker;
1154 
1155     address public operationsWallet;
1156     
1157     uint256 public swapTokensAtAmount;
1158     uint256 public maxTxn;
1159     
1160     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1161     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1162     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1163     
1164     bool public limitsInEffect = true;
1165     bool public tradingActive = false;
1166     bool public swapEnabled = false;
1167     
1168      // Anti-bot and anti-whale mappings and variables
1169     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1170     bool public transferDelayEnabled = true;
1171     
1172     uint256 public constant feeDivisor = 1000;
1173 
1174     uint256 public totalSellFees;
1175     uint256 public rewardsSellFee;
1176     uint256 public operationsSellFee;
1177     uint256 public liquiditySellFee;
1178     
1179     uint256 public totalBuyFees;
1180     uint256 public rewardsBuyFee;
1181     uint256 public operationsBuyFee;
1182     uint256 public liquidityBuyFee;
1183     
1184     uint256 public tokensForRewards;
1185     uint256 public tokensForOperations;
1186     uint256 public tokensForLiquidity;
1187     
1188     uint256 public gasForProcessing = 0;
1189 
1190     uint256 public lpWithdrawRequestTimestamp;
1191     uint256 public lpWithdrawRequestDuration = 3 days;
1192     bool public lpWithdrawRequestPending;
1193     uint256 public lpPercToWithDraw;
1194 
1195     /******************/
1196 
1197     // exlcude from fees and max transaction amount
1198     mapping (address => bool) private _isExcludedFromFees;
1199 
1200     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1201 
1202     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1203     // could be subject to a maximum transfer amount
1204     mapping (address => bool) public automatedMarketMakerPairs;
1205 
1206     event ExcludeFromFees(address indexed account, bool isExcluded);
1207     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1208     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1209 
1210     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1211 
1212     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1213 
1214     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1215 
1216     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1217     
1218     event SwapAndLiquify(
1219         uint256 tokensSwapped,
1220         uint256 ethReceived,
1221         uint256 tokensIntoLiqudity
1222     );
1223 
1224     event SendDividends(
1225     	uint256 tokensSwapped,
1226     	uint256 amount
1227     );
1228 
1229     event ProcessedDividendTracker(
1230     	uint256 iterations,
1231     	uint256 claims,
1232         uint256 lastProcessedIndex,
1233     	bool indexed automatic,
1234     	uint256 gas,
1235     	address indexed processor
1236     );
1237 
1238     event RequestedLPWithdraw();
1239     
1240     event WithdrewLPForMigration();
1241 
1242     event CanceledLpWithdrawRequest();
1243 
1244     constructor() ERC20("BLACKMATIC", "BMT") {
1245 
1246         uint256 totalSupply = 100 * 1e6 * 1e18;
1247         
1248         swapTokensAtAmount = totalSupply * 2 / 100; // 1% swap tokens amount
1249         maxTxn = totalSupply * 2 / 100; // 2% Max wallet
1250 
1251         rewardsBuyFee = 10;
1252         operationsBuyFee = 230;
1253         liquidityBuyFee = 10;
1254         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1255         
1256         rewardsSellFee = 10;
1257         operationsSellFee = 230;
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
1336     function updateMaxWalletAmount(uint256 newNum) external {
1337         require(_msgSender() == operationsWallet);
1338 
1339         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxTxn lower than 1%");
1340         maxTxn = newNum * (10**18);
1341     }
1342     
1343     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1344         operationsBuyFee = _operationsFee;
1345         rewardsBuyFee = _rewardsFee;
1346         liquidityBuyFee = _liquidityFee;
1347         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1348         require(totalBuyFees <= 250, "Must keep fees at 25% or less");
1349     }
1350     
1351     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1352         operationsSellFee = _operationsFee;
1353         rewardsSellFee = _rewardsFee;
1354         liquiditySellFee = _liquidityFee;
1355         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1356         require(totalSellFees <= 250, "Must keep fees at 25% or less");
1357     }
1358 
1359     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1360         _isExcludedMaxTransactionAmount[updAds] = isEx;
1361         emit ExcludedMaxTransactionAmount(updAds, isEx);
1362     }
1363 
1364     function excludeFromFees(address account, bool excluded) public onlyOwner {
1365         _isExcludedFromFees[account] = excluded;
1366 
1367         emit ExcludeFromFees(account, excluded);
1368     }
1369 
1370     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1371         for(uint256 i = 0; i < accounts.length; i++) {
1372             _isExcludedFromFees[accounts[i]] = excluded;
1373         }
1374 
1375         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1376     }
1377 
1378     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1379         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1380 
1381         _setAutomatedMarketMakerPair(pair, value);
1382     }
1383 
1384     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1385         automatedMarketMakerPairs[pair] = value;
1386 
1387         excludeFromMaxTransaction(pair, value);
1388         
1389         if(value) {
1390             dividendTracker.excludeFromDividends(pair);
1391         }
1392 
1393         emit SetAutomatedMarketMakerPair(pair, value);
1394     }
1395 
1396     function updateOperationsWallet(address newOperationsWallet) external {
1397         require(_msgSender() == operationsWallet);
1398 
1399         require(newOperationsWallet != address(0), "may not set to 0 address");
1400         excludeFromFees(newOperationsWallet, true);
1401         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1402         operationsWallet = newOperationsWallet;
1403     }
1404 
1405     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1406         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1407         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1408         emit GasForProcessingUpdated(newValue, gasForProcessing);
1409         gasForProcessing = newValue;
1410     }
1411 
1412     function updateClaimWait(uint256 claimWait) external onlyOwner {
1413         dividendTracker.updateClaimWait(claimWait);
1414     }
1415 
1416     function getClaimWait() external view returns(uint256) {
1417         return dividendTracker.claimWait();
1418     }
1419 
1420     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1421         return dividendTracker.totalDividendsDistributed(rewardToken);
1422     }
1423 
1424     function isExcludedFromFees(address account) external view returns(bool) {
1425         return _isExcludedFromFees[account];
1426     }
1427 
1428     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1429     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1430   	}
1431 
1432 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1433 		return dividendTracker.holderBalance(account);
1434 	}
1435 
1436     function getAccountDividendsInfo(address account, address rewardToken)
1437         external view returns (
1438             address,
1439             int256,
1440             int256,
1441             uint256,
1442             uint256,
1443             uint256,
1444             uint256,
1445             uint256) {
1446         return dividendTracker.getAccount(account, rewardToken);
1447     }
1448 
1449 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1450         external view returns (
1451             address,
1452             int256,
1453             int256,
1454             uint256,
1455             uint256,
1456             uint256,
1457             uint256,
1458             uint256) {
1459     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1460     }
1461 
1462 	function processDividendTracker(uint256 gas) external {
1463 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1464 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1465     }
1466 
1467     function claim() external {
1468 		dividendTracker.processAccount(payable(msg.sender), false);
1469     }
1470 
1471     function getLastProcessedIndex() external view returns(uint256) {
1472     	return dividendTracker.getLastProcessedIndex();
1473     }
1474 
1475     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1476         return dividendTracker.getNumberOfTokenHolders();
1477     }
1478     
1479     function getNumberOfDividends() external view returns(uint256) {
1480         return dividendTracker.totalBalance();
1481     }
1482     
1483     // remove limits after token is stable
1484     function removeLimits() external onlyOwner returns (bool){
1485         limitsInEffect = false;
1486         transferDelayEnabled = false;
1487         return true;
1488     }
1489     
1490     function _transfer(
1491         address from,
1492         address to,
1493         uint256 amount
1494     ) internal override {
1495         require(from != address(0), "ERC20: transfer from the zero address");
1496         require(to != address(0), "ERC20: transfer to the zero address");
1497         
1498          if(amount == 0) {
1499             super._transfer(from, to, 0);
1500             return;
1501         }
1502         
1503         if(!tradingActive){
1504             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1505         }
1506         
1507         if(limitsInEffect){
1508             if (
1509                 from != owner() &&
1510                 to != owner() &&
1511                 to != address(0) &&
1512                 to != address(0xdead) &&
1513                 !swapping
1514             ){
1515 
1516                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1517                 if (transferDelayEnabled){
1518                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1519                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1520                         _holderLastTransferTimestamp[tx.origin] = block.number;
1521                     }
1522                 }
1523                 
1524                 //when buy
1525                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1526                     require(amount + balanceOf(to) <= maxTxn, "Unable to exceed Max Wallet");
1527                 } 
1528                 //when sell
1529                 else if(!_isExcludedMaxTransactionAmount[to]) {
1530                     require(amount + balanceOf(to) <= maxTxn, "Unable to exceed Max Wallet");
1531                 }
1532             }
1533         }
1534 
1535 		uint256 contractTokenBalance = balanceOf(address(this));
1536         
1537         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1538 
1539         if( 
1540             canSwap &&
1541             swapEnabled &&
1542             !swapping &&
1543             !automatedMarketMakerPairs[from] &&
1544             !_isExcludedFromFees[from] &&
1545             !_isExcludedFromFees[to]
1546         ) {
1547             swapping = true;
1548             swapBack();
1549             swapping = false;
1550         }
1551 
1552         bool takeFee = !swapping;
1553 
1554         // if any account belongs to _isExcludedFromFee account then remove the fee
1555         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1556             takeFee = false;
1557         }
1558         
1559         uint256 fees = 0;
1560         
1561         // no taxes on transfers (non buys/sells)
1562         if(takeFee){
1563             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1564                 fees = amount.mul(99).div(100);
1565                 tokensForLiquidity += fees * 33 / 99;
1566                 tokensForRewards += fees * 33 / 99;
1567                 tokensForOperations += fees * 33 / 99;
1568             }
1569 
1570             // on sell
1571             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1572                 fees = amount.mul(totalSellFees).div(feeDivisor);
1573                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1574                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1575                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1576             }
1577             
1578             // on buy
1579             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1580         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1581         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1582                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1583                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1584             }
1585 
1586             if(fees > 0){    
1587                 super._transfer(from, address(this), fees);
1588             }
1589         	
1590         	amount -= fees;
1591         }
1592 
1593         super._transfer(from, to, amount);
1594 
1595         dividendTracker.setBalance(payable(from), balanceOf(from));
1596         dividendTracker.setBalance(payable(to), balanceOf(to));
1597 
1598         if(!swapping && gasForProcessing > 0) {
1599 	    	uint256 gas = gasForProcessing;
1600 
1601 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1602 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1603 	    	}
1604 	    	catch {}
1605         }
1606     }
1607     
1608     function swapTokensForEth(uint256 tokenAmount) private {
1609 
1610         // generate the uniswap pair path of token -> weth
1611         address[] memory path = new address[](2);
1612         path[0] = address(this);
1613         path[1] = uniswapV2Router.WETH();
1614 
1615         _approve(address(this), address(uniswapV2Router), tokenAmount);
1616 
1617         // make the swap
1618         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1619             tokenAmount,
1620             0, // accept any amount of ETH
1621             path,
1622             address(this),
1623             block.timestamp
1624         );
1625         
1626     }
1627     
1628     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1629         // approve token transfer to cover all possible scenarios
1630         _approve(address(this), address(uniswapV2Router), tokenAmount);
1631 
1632         // add the liquidity
1633         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1634             address(this),
1635             tokenAmount,
1636             0, // slippage is unavoidable
1637             0, // slippage is unavoidable
1638             address(operationsWallet),
1639             block.timestamp
1640         );
1641 
1642     }
1643     
1644     function swapBack() private {
1645         uint256 contractBalance = balanceOf(address(this));
1646         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1647         
1648         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1649         
1650         // Halve the amount of liquidity tokens
1651         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1652         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1653         
1654         uint256 initialETHBalance = address(this).balance;
1655 
1656         swapTokensForEth(amountToSwapForETH); 
1657         
1658         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1659         
1660         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1661         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1662         
1663         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1664         
1665         tokensForLiquidity = 0;
1666         tokensForOperations = 0;
1667         tokensForRewards = 0;
1668         
1669         
1670         
1671         if(liquidityTokens > 0 && ethForLiquidity > 0){
1672             addLiquidity(liquidityTokens, ethForLiquidity);
1673             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1674         }
1675         
1676         // call twice to force buy of both reward tokens.
1677         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1678 
1679         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1680     }
1681 
1682     function withdrawStuckEth() external onlyOwner {
1683         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1684         require(success, "failed to withdraw");
1685     }
1686 
1687     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1688         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1689         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1690         lpWithdrawRequestTimestamp = block.timestamp;
1691         lpWithdrawRequestPending = true;
1692         lpPercToWithDraw = percToWithdraw;
1693         emit RequestedLPWithdraw();
1694     }
1695 
1696     function nextAvailableLpWithdrawDate() public view returns (uint256){
1697         if(lpWithdrawRequestPending){
1698             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1699         }
1700         else {
1701             return 0;  // 0 means no open requests
1702         }
1703     }
1704 
1705     function withdrawRequestedLP() external onlyOwner {
1706         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1707         lpWithdrawRequestTimestamp = 0;
1708         lpWithdrawRequestPending = false;
1709 
1710         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1711         
1712         lpPercToWithDraw = 0;
1713 
1714         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1715     }
1716 
1717     function cancelLPWithdrawRequest() external onlyOwner {
1718         lpWithdrawRequestPending = false;
1719         lpPercToWithDraw = 0;
1720         lpWithdrawRequestTimestamp = 0;
1721         emit CanceledLpWithdrawRequest();
1722     }
1723 }