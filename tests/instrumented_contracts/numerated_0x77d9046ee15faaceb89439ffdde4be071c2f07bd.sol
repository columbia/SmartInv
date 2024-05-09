1 // SPDX-License-Identifier: MIT                                                                               
2 pragma solidity 0.8.17;
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
15 interface IDexFactory {
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
230 
231 library SafeMath {
232     /**
233      * @dev Returns the addition of two unsigned integers, reverting on
234      * overflow.
235      *
236      * Counterpart to Solidity's `+` operator.
237      *
238      * Requirements:
239      *
240      * - Addition cannot overflow.
241      */
242     function add(uint256 a, uint256 b) internal pure returns (uint256) {
243         uint256 c = a + b;
244         require(c >= a, "SafeMath: addition overflow");
245 
246         return c;
247     }
248 
249     /**
250      * @dev Returns the subtraction of two unsigned integers, reverting on
251      * overflow (when the result is negative).
252      *
253      * Counterpart to Solidity's `-` operator.
254      *
255      * Requirements:
256      *
257      * - Subtraction cannot overflow.
258      */
259     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
260         return sub(a, b, "SafeMath: subtraction overflow");
261     }
262 
263     /**
264      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
265      * overflow (when the result is negative).
266      *
267      * Counterpart to Solidity's `-` operator.
268      *
269      * Requirements:
270      *
271      * - Subtraction cannot overflow.
272      */
273     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b <= a, errorMessage);
275         uint256 c = a - b;
276 
277         return c;
278     }
279 
280     /**
281      * @dev Returns the multiplication of two unsigned integers, reverting on
282      * overflow.
283      *
284      * Counterpart to Solidity's `*` operator.
285      *
286      * Requirements:
287      *
288      * - Multiplication cannot overflow.
289      */
290     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
291         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
292         // benefit is lost if 'b' is also tested.
293         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
294         if (a == 0) {
295             return 0;
296         }
297 
298         uint256 c = a * b;
299         require(c / a == b, "SafeMath: multiplication overflow");
300 
301         return c;
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers. Reverts on
306      * division by zero. The result is rounded towards zero.
307      *
308      * Counterpart to Solidity's `/` operator. Note: this function uses a
309      * `revert` opcode (which leaves remaining gas untouched) while Solidity
310      * uses an invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function div(uint256 a, uint256 b) internal pure returns (uint256) {
317         return div(a, b, "SafeMath: division by zero");
318     }
319 
320     /**
321      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
322      * division by zero. The result is rounded towards zero.
323      *
324      * Counterpart to Solidity's `/` operator. Note: this function uses a
325      * `revert` opcode (which leaves remaining gas untouched) while Solidity
326      * uses an invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      *
330      * - The divisor cannot be zero.
331      */
332     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
333         require(b > 0, errorMessage);
334         uint256 c = a / b;
335         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
336 
337         return c;
338     }
339 
340     /**
341      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
342      * Reverts when dividing by zero.
343      *
344      * Counterpart to Solidity's `%` operator. This function uses a `revert`
345      * opcode (which leaves remaining gas untouched) while Solidity uses an
346      * invalid opcode to revert (consuming all remaining gas).
347      *
348      * Requirements:
349      *
350      * - The divisor cannot be zero.
351      */
352     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
353         return mod(a, b, "SafeMath: modulo by zero");
354     }
355 
356     /**
357      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
358      * Reverts with custom message when dividing by zero.
359      *
360      * Counterpart to Solidity's `%` operator. This function uses a `revert`
361      * opcode (which leaves remaining gas untouched) while Solidity uses an
362      * invalid opcode to revert (consuming all remaining gas).
363      *
364      * Requirements:
365      *
366      * - The divisor cannot be zero.
367      */
368     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
369         require(b != 0, errorMessage);
370         return a % b;
371     }
372 }
373 
374 contract Ownable is Context {
375     address private _owner;
376 
377     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
378     
379     /**
380      * @dev Initializes the contract setting the deployer as the initial owner.
381      */
382     constructor () {
383         address msgSender = _msgSender();
384         _owner = msgSender;
385         emit OwnershipTransferred(address(0), msgSender);
386     }
387 
388     /**
389      * @dev Returns the address of the current owner.
390      */
391     function owner() public view returns (address) {
392         return _owner;
393     }
394 
395     /**
396      * @dev Throws if called by any account other than the owner.
397      */
398     modifier onlyOwner() {
399         require(_owner == _msgSender(), "Ownable: caller is not the owner");
400         _;
401     }
402 
403     /**
404      * @dev Leaves the contract without owner. It will not be possible to call
405      * `onlyOwner` functions anymore. Can only be called by the current owner.
406      *
407      * NOTE: Renouncing ownership will leave the contract without an owner,
408      * thereby removing any functionality that is only available to the owner.
409      */
410     function renounceOwnership() public virtual onlyOwner {
411         emit OwnershipTransferred(_owner, address(0));
412         _owner = address(0);
413     }
414 
415     /**
416      * @dev Transfers ownership of the contract to a new account (`newOwner`).
417      * Can only be called by the current owner.
418      */
419     function transferOwnership(address newOwner) public virtual onlyOwner {
420         require(newOwner != address(0), "Ownable: new owner is the zero address");
421         emit OwnershipTransferred(_owner, newOwner);
422         _owner = newOwner;
423     }
424 }
425 
426 
427 
428 library SafeMathInt {
429     int256 private constant MIN_INT256 = int256(1) << 255;
430     int256 private constant MAX_INT256 = ~(int256(1) << 255);
431 
432     /**
433      * @dev Multiplies two int256 variables and fails on overflow.
434      */
435     function mul(int256 a, int256 b) internal pure returns (int256) {
436         int256 c = a * b;
437 
438         // Detect overflow when multiplying MIN_INT256 with -1
439         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
440         require((b == 0) || (c / b == a));
441         return c;
442     }
443 
444     /**
445      * @dev Division of two int256 variables and fails on overflow.
446      */
447     function div(int256 a, int256 b) internal pure returns (int256) {
448         // Prevent overflow when dividing MIN_INT256 by -1
449         require(b != -1 || a != MIN_INT256);
450 
451         // Solidity already throws when dividing by 0.
452         return a / b;
453     }
454 
455     /**
456      * @dev Subtracts two int256 variables and fails on overflow.
457      */
458     function sub(int256 a, int256 b) internal pure returns (int256) {
459         int256 c = a - b;
460         require((b >= 0 && c <= a) || (b < 0 && c > a));
461         return c;
462     }
463 
464     /**
465      * @dev Adds two int256 variables and fails on overflow.
466      */
467     function add(int256 a, int256 b) internal pure returns (int256) {
468         int256 c = a + b;
469         require((b >= 0 && c >= a) || (b < 0 && c < a));
470         return c;
471     }
472 
473     /**
474      * @dev Converts to absolute value, and fails on overflow.
475      */
476     function abs(int256 a) internal pure returns (int256) {
477         require(a != MIN_INT256);
478         return a < 0 ? -a : a;
479     }
480 
481 
482     function toUint256Safe(int256 a) internal pure returns (uint256) {
483         require(a >= 0);
484         return uint256(a);
485     }
486 }
487 
488 library SafeMathUint {
489   function toInt256Safe(uint256 a) internal pure returns (int256) {
490     int256 b = int256(a);
491     require(b >= 0);
492     return b;
493   }
494 }
495 
496 interface IDexRouter {
497     function factory() external pure returns (address);
498     function WETH() external pure returns (address);
499     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
500     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
501     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
502     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
503     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
504     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
505     function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
506 }
507 
508 interface DividendPayingTokenOptionalInterface {
509   /// @notice View the amount of dividend in wei that an address can withdraw.
510   /// @param _owner The address of a token holder.
511   /// @return The amount of dividend in wei that `_owner` can withdraw.
512   function withdrawableDividendOf(address _owner) external view returns(uint256);
513 
514   /// @notice View the amount of dividend in wei that an address has withdrawn.
515   /// @param _owner The address of a token holder.
516   /// @return The amount of dividend in wei that `_owner` has withdrawn.
517   function withdrawnDividendOf(address _owner) external view returns(uint256);
518 
519   /// @notice View the amount of dividend in wei that an address has earned in total.
520   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
521   /// @param _owner The address of a token holder.
522   /// @return The amount of dividend in wei that `_owner` has earned in total.
523   function accumulativeDividendOf(address _owner) external view returns(uint256);
524 }
525 
526 interface DividendPayingTokenInterface {
527   /// @notice View the amount of dividend in wei that an address can withdraw.
528   /// @param _owner The address of a token holder.
529   /// @return The amount of dividend in wei that `_owner` can withdraw.
530   function dividendOf(address _owner) external view returns(uint256);
531 
532   /// @notice Distributes ether to token holders as dividends.
533   /// @dev SHOULD distribute the paid ether to token holders as dividends.
534   ///  SHOULD NOT directly transfer ether to token holders in this function.
535   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
536   function distributeDividends() external payable;
537 
538   /// @notice Withdraws the ether distributed to the sender.
539   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
540   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
541   function withdrawDividend() external;
542 
543   /// @dev This event MUST emit when ether is distributed to token holders.
544   /// @param from The address which sends ether to this contract.
545   /// @param weiAmount The amount of distributed ether in wei.
546   event DividendsDistributed(
547     address indexed from,
548     uint256 weiAmount
549   );
550 
551   /// @dev This event MUST emit when an address withdraws their dividend.
552   /// @param to The address which withdraws ether from this contract.
553   /// @param weiAmount The amount of withdrawn ether in wei.
554   event DividendWithdrawn(
555     address indexed to,
556     uint256 weiAmount
557   );
558 }
559 
560 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
561   using SafeMath for uint256;
562   using SafeMathUint for uint256;
563   using SafeMathInt for int256;
564 
565   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
566   // For more discussion about choosing the value of `magnitude`,
567   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
568   uint256 constant internal magnitude = 2**128;
569 
570   uint256 internal magnifiedDividendPerShare;
571                                                                                     
572   // About dividendCorrection:
573   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
574   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
575   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
576   //   `dividendOf(_user)` should not be changed,
577   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
578   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
579   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
580   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
581   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
582   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
583   mapping(address => int256) internal magnifiedDividendCorrections;
584   mapping(address => uint256) internal withdrawnDividends;
585   
586   mapping (address => uint256) public holderBalance;
587   uint256 public totalBalance;
588 
589   uint256 public totalDividendsDistributed;
590 
591   /// @dev Distributes dividends whenever ether is paid to this contract.
592   receive() external payable {
593     distributeDividends();
594   }
595 
596   /// @notice Distributes ether to token holders as dividends.
597   /// @dev It reverts if the total supply of tokens is 0.
598   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
599   /// About undistributed ether:
600   ///   In each distribution, there is a small amount of ether not distributed,
601   ///     the magnified amount of which is
602   ///     `(msg.value * magnitude) % totalSupply()`.
603   ///   With a well-chosen `magnitude`, the amount of undistributed ether
604   ///     (de-magnified) in a distribution can be less than 1 wei.
605   ///   We can actually keep track of the undistributed ether in a distribution
606   ///     and try to distribute it in the next distribution,
607   ///     but keeping track of such data on-chain costs much more than
608   ///     the saved ether, so we don't do that.
609     
610   function distributeDividends() public override payable {
611     if(totalBalance > 0 && msg.value > 0){
612         magnifiedDividendPerShare = magnifiedDividendPerShare.add(
613             (msg.value).mul(magnitude) / totalBalance
614         );
615         emit DividendsDistributed(msg.sender, msg.value);
616 
617         totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
618     }
619   }
620 
621   /// @notice Withdraws the ether distributed to the sender.
622   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
623   function withdrawDividend() external virtual override {
624     _withdrawDividendOfUser(payable(msg.sender));
625   }
626 
627   /// @notice Withdraws the ether distributed to the sender.
628   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
629   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
630     uint256 _withdrawableDividend = withdrawableDividendOf(user);
631     if (_withdrawableDividend > 0) {
632       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
633 
634       emit DividendWithdrawn(user, _withdrawableDividend);
635       (bool success,) = user.call{value: _withdrawableDividend}("");
636 
637       if(!success) {
638         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
639         return 0;
640       }
641 
642       return _withdrawableDividend;
643     }
644 
645     return 0;
646   }
647 
648 
649   /// @notice View the amount of dividend in wei that an address can withdraw.
650   /// @param _owner The address of a token holder.
651   /// @return The amount of dividend in wei that `_owner` can withdraw.
652   function dividendOf(address _owner) external view override returns(uint256) {
653     return withdrawableDividendOf(_owner);
654   }
655 
656   /// @notice View the amount of dividend in wei that an address can withdraw.
657   /// @param _owner The address of a token holder.
658   /// @return The amount of dividend in wei that `_owner` can withdraw.
659   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
660     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
661   }
662 
663   /// @notice View the amount of dividend in wei that an address has withdrawn.
664   /// @param _owner The address of a token holder.
665   /// @return The amount of dividend in wei that `_owner` has withdrawn.
666   function withdrawnDividendOf(address _owner) external view override returns(uint256) {
667     return withdrawnDividends[_owner];
668   }
669 
670 
671   /// @notice View the amount of dividend in wei that an address has earned in total.
672   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
673   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
674   /// @param _owner The address of a token holder.
675   /// @return The amount of dividend in wei that `_owner` has earned in total.
676   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
677     return magnifiedDividendPerShare.mul(holderBalance[_owner]).toInt256Safe()
678       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
679   }
680 
681   /// @dev Internal function that increases tokens to an account.
682   /// Update magnifiedDividendCorrections to keep dividends unchanged.
683   /// @param account The account that will receive the created tokens.
684   /// @param value The amount that will be created.
685   function _increase(address account, uint256 value) internal {
686     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
687       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
688   }
689 
690   /// @dev Internal function that reduces an amount of the token of a given account.
691   /// Update magnifiedDividendCorrections to keep dividends unchanged.
692   /// @param account The account whose tokens will be burnt.
693   /// @param value The amount that will be burnt.
694   function _reduce(address account, uint256 value) internal {
695     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
696       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
697   }
698 
699   function _setBalance(address account, uint256 newBalance) internal {
700     uint256 currentBalance = holderBalance[account];
701     holderBalance[account] = newBalance;
702     if(newBalance > currentBalance) {
703       uint256 increaseAmount = newBalance.sub(currentBalance);
704       _increase(account, increaseAmount);
705       totalBalance += increaseAmount;
706     } else if(newBalance < currentBalance) {
707       uint256 reduceAmount = currentBalance.sub(newBalance);
708       _reduce(account, reduceAmount);
709       totalBalance -= reduceAmount;
710     }
711   }
712 }
713 
714 
715 contract DividendTracker is DividendPayingToken {
716     using SafeMath for uint256;
717     using SafeMathInt for int256;
718 
719     struct Map {
720         address[] keys;
721         mapping(address => uint) values;
722         mapping(address => uint) indexOf;
723         mapping(address => bool) inserted;
724     }
725 
726     function get(address key) private view returns (uint) {
727         return tokenHoldersMap.values[key];
728     }
729 
730     function getIndexOfKey(address key) private view returns (int) {
731         if(!tokenHoldersMap.inserted[key]) {
732             return -1;
733         }
734         return int(tokenHoldersMap.indexOf[key]);
735     }
736 
737     function getKeyAtIndex(uint index) private view returns (address) {
738         return tokenHoldersMap.keys[index];
739     }
740 
741 
742 
743     function size() private view returns (uint) {
744         return tokenHoldersMap.keys.length;
745     }
746 
747     function set(address key, uint val) private {
748         if (tokenHoldersMap.inserted[key]) {
749             tokenHoldersMap.values[key] = val;
750         } else {
751             tokenHoldersMap.inserted[key] = true;
752             tokenHoldersMap.values[key] = val;
753             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
754             tokenHoldersMap.keys.push(key);
755         }
756     }
757 
758     function remove(address key) private {
759         if (!tokenHoldersMap.inserted[key]) {
760             return;
761         }
762 
763         delete tokenHoldersMap.inserted[key];
764         delete tokenHoldersMap.values[key];
765 
766         uint index = tokenHoldersMap.indexOf[key];
767         uint lastIndex = tokenHoldersMap.keys.length - 1;
768         address lastKey = tokenHoldersMap.keys[lastIndex];
769 
770         tokenHoldersMap.indexOf[lastKey] = index;
771         delete tokenHoldersMap.indexOf[key];
772 
773         tokenHoldersMap.keys[index] = lastKey;
774         tokenHoldersMap.keys.pop();
775     }
776 
777     Map private tokenHoldersMap;
778     uint256 public lastProcessedIndex;
779 
780     mapping (address => bool) public excludedFromDividends;
781 
782     mapping (address => uint256) public lastClaimTimes;
783 
784     uint256 public claimWait;
785     uint256 public immutable minimumTokenBalanceForDividends;
786 
787     event ExcludeFromDividends(address indexed account);
788     event IncludeInDividends(address indexed account);
789     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
790 
791     event Claim(address indexed account, uint256 amount, bool indexed automatic);
792 
793     constructor() {
794     	claimWait = 1;
795         minimumTokenBalanceForDividends = 1;
796     }
797 
798     function excludeFromDividends(address account) external onlyOwner {
799     	excludedFromDividends[account] = true;
800 
801     	_setBalance(account, 0);
802     	remove(account);
803 
804     	emit ExcludeFromDividends(account);
805     }
806     
807     function includeInDividends(address account) external onlyOwner {
808     	require(excludedFromDividends[account]);
809     	excludedFromDividends[account] = false;
810 
811     	emit IncludeInDividends(account);
812     }
813 
814     function getLastProcessedIndex() external view returns(uint256) {
815     	return lastProcessedIndex;
816     }
817 
818     function getNumberOfTokenHolders() external view returns(uint256) {
819         return tokenHoldersMap.keys.length;
820     }
821 
822     function getAccount(address _account)
823         public view returns (
824             address account,
825             int256 index,
826             int256 iterationsUntilProcessed,
827             uint256 withdrawableDividends,
828             uint256 totalDividends,
829             uint256 lastClaimTime,
830             uint256 nextClaimTime,
831             uint256 secondsUntilAutoClaimAvailable) {
832         account = _account;
833 
834         index = getIndexOfKey(account);
835 
836         iterationsUntilProcessed = -1;
837 
838         if(index >= 0) {
839             if(uint256(index) > lastProcessedIndex) {
840                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
841             }
842             else {
843                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
844                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
845                                                         0;
846 
847 
848                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
849             }
850         }
851 
852 
853         withdrawableDividends = withdrawableDividendOf(account);
854         totalDividends = accumulativeDividendOf(account);
855 
856         lastClaimTime = lastClaimTimes[account];
857 
858         nextClaimTime = lastClaimTime > 0 ?
859                                     lastClaimTime.add(claimWait) :
860                                     0;
861 
862         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
863                                                     nextClaimTime.sub(block.timestamp) :
864                                                     0;
865     }
866 
867     function getAccountAtIndex(uint256 index)
868         external view returns (
869             address,
870             int256,
871             int256,
872             uint256,
873             uint256,
874             uint256,
875             uint256,
876             uint256) {
877     	if(index >= size()) {
878             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
879         }
880 
881         address account = getKeyAtIndex(index);
882 
883         return getAccount(account);
884     }
885 
886     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
887     	if(lastClaimTime > block.timestamp)  {
888     		return false;
889     	}
890 
891     	return block.timestamp.sub(lastClaimTime) >= claimWait;
892     }
893 
894     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
895     	if(excludedFromDividends[account]) {
896     		return;
897     	}
898 
899     	if(newBalance >= minimumTokenBalanceForDividends) {
900             _setBalance(account, newBalance);
901     		set(account, newBalance);
902     	}
903     	else {
904             _setBalance(account, 0);
905     		remove(account);
906     	}
907 
908     	processAccount(account, true);
909     }
910     
911     
912     function process(uint256 gas) external returns (uint256, uint256, uint256) {
913     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
914 
915     	if(numberOfTokenHolders == 0) {
916     		return (0, 0, lastProcessedIndex);
917     	}
918 
919     	uint256 _lastProcessedIndex = lastProcessedIndex;
920 
921     	uint256 gasUsed = 0;
922 
923     	uint256 gasLeft = gasleft();
924 
925     	uint256 iterations = 0;
926     	uint256 claims = 0;
927 
928     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
929     		_lastProcessedIndex++;
930 
931     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
932     			_lastProcessedIndex = 0;
933     		}
934 
935     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
936 
937     		if(canAutoClaim(lastClaimTimes[account])) {
938     			if(processAccount(payable(account), true)) {
939     				claims++;
940     			}
941     		}
942 
943     		iterations++;
944 
945     		uint256 newGasLeft = gasleft();
946 
947     		if(gasLeft > newGasLeft) {
948     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
949     		}
950     		gasLeft = newGasLeft;
951     	}
952 
953     	lastProcessedIndex = _lastProcessedIndex;
954 
955     	return (iterations, claims, lastProcessedIndex);
956     }
957 
958     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
959         uint256 amount = _withdrawDividendOfUser(account);
960 
961     	if(amount > 0) {
962     		lastClaimTimes[account] = block.timestamp;
963             emit Claim(account, amount, automatic);
964     		return true;
965     	}
966 
967     	return false;
968     }
969 }
970 
971 library Address {
972     function isContract(address account) internal view returns (bool) {
973         return account.code.length > 0;
974     }
975 
976     function sendValue(address payable recipient, uint256 amount) internal {
977         require(address(this).balance >= amount, "Address: insufficient balance");
978 
979         (bool success, ) = recipient.call{value: amount}("");
980         require(success, "Address: unable to send value, recipient may have reverted");
981     }
982 
983     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
984         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
985     }
986 
987     function functionCall(
988         address target,
989         bytes memory data,
990         string memory errorMessage
991     ) internal returns (bytes memory) {
992         return functionCallWithValue(target, data, 0, errorMessage);
993     }
994 
995     /**
996      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
997      * but also transferring `value` wei to `target`.
998      *
999      * Requirements:
1000      *
1001      * - the calling contract must have an ETH balance of at least `value`.
1002      * - the called Solidity function must be `payable`.
1003      *
1004      * _Available since v3.1._
1005      */
1006     function functionCallWithValue(
1007         address target,
1008         bytes memory data,
1009         uint256 value
1010     ) internal returns (bytes memory) {
1011         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1012     }
1013 
1014     /**
1015      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1016      * with `errorMessage` as a fallback revert reason when `target` reverts.
1017      *
1018      * _Available since v3.1._
1019      */
1020     function functionCallWithValue(
1021         address target,
1022         bytes memory data,
1023         uint256 value,
1024         string memory errorMessage
1025     ) internal returns (bytes memory) {
1026         require(address(this).balance >= value, "Address: insufficient balance for call");
1027         (bool success, bytes memory returndata) = target.call{value: value}(data);
1028         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1029     }
1030 
1031     /**
1032      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1033      * but performing a static call.
1034      *
1035      * _Available since v3.3._
1036      */
1037     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1038         return functionStaticCall(target, data, "Address: low-level static call failed");
1039     }
1040 
1041     /**
1042      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1043      * but performing a static call.
1044      *
1045      * _Available since v3.3._
1046      */
1047     function functionStaticCall(
1048         address target,
1049         bytes memory data,
1050         string memory errorMessage
1051     ) internal view returns (bytes memory) {
1052         (bool success, bytes memory returndata) = target.staticcall(data);
1053         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1054     }
1055 
1056     /**
1057      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1058      * but performing a delegate call.
1059      *
1060      * _Available since v3.4._
1061      */
1062     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1063         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1064     }
1065 
1066     /**
1067      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1068      * but performing a delegate call.
1069      *
1070      * _Available since v3.4._
1071      */
1072     function functionDelegateCall(
1073         address target,
1074         bytes memory data,
1075         string memory errorMessage
1076     ) internal returns (bytes memory) {
1077         (bool success, bytes memory returndata) = target.delegatecall(data);
1078         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1079     }
1080 
1081     /**
1082      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1083      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1084      *
1085      * _Available since v4.8._
1086      */
1087     function verifyCallResultFromTarget(
1088         address target,
1089         bool success,
1090         bytes memory returndata,
1091         string memory errorMessage
1092     ) internal view returns (bytes memory) {
1093         if (success) {
1094             if (returndata.length == 0) {
1095                 // only check isContract if the call was successful and the return data is empty
1096                 // otherwise we already know that it was a contract
1097                 require(isContract(target), "Address: call to non-contract");
1098             }
1099             return returndata;
1100         } else {
1101             _revert(returndata, errorMessage);
1102         }
1103     }
1104 
1105     /**
1106      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1107      * revert reason or using the provided one.
1108      *
1109      * _Available since v4.3._
1110      */
1111     function verifyCallResult(
1112         bool success,
1113         bytes memory returndata,
1114         string memory errorMessage
1115     ) internal pure returns (bytes memory) {
1116         if (success) {
1117             return returndata;
1118         } else {
1119             _revert(returndata, errorMessage);
1120         }
1121     }
1122 
1123     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1124         // Look for revert reason and bubble it up if present
1125         if (returndata.length > 0) {
1126             // The easiest way to bubble the revert reason is using memory via assembly
1127             /// @solidity memory-safe-assembly
1128             assembly {
1129                 let returndata_size := mload(returndata)
1130                 revert(add(32, returndata), returndata_size)
1131             }
1132         } else {
1133             revert(errorMessage);
1134         }
1135     }
1136 }
1137 
1138 library SafeERC20 {
1139     using Address for address;
1140 
1141     function safeTransfer(
1142         IERC20 token,
1143         address to,
1144         uint256 value
1145     ) internal {
1146         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1147     }
1148 
1149     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1150         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1151         if (returndata.length > 0) {
1152             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1153         }
1154     }
1155 }
1156 
1157 interface ILpPair {
1158     function sync() external;
1159 }
1160 
1161 interface IPriceFeed {
1162     function latestAnswer() external view returns (int256);
1163 }
1164 
1165 contract Jiyuu is ERC20, Ownable {
1166     using SafeMath for uint256;
1167 
1168     IPriceFeed internal immutable priceFeed;
1169     mapping(address => uint256) public walletDollarCostAverage;
1170 
1171     IDexRouter public immutable dexRouter;
1172     address public lpPair;
1173 
1174     bool private swapping;
1175 
1176     DividendTracker public dividendTracker;
1177 
1178     address public operationsAddress;
1179     
1180     uint256 public swapTokensAtAmount;
1181     uint256 public maxTransactionAmt;
1182     uint256 public maxWallet;
1183     uint256 public maxTxnIncreaseBlock;
1184     
1185     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1186     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1187     
1188     bool public limitsInEffect = true;
1189     bool public tradingActive = false;
1190     bool public swapEnabled = false;
1191     
1192      // Anti-bot and anti-whale mappings and variables
1193     mapping(address => uint256) private _holderLastTransferBlock; // to hold last Transfers temporarily during launch
1194     bool public transferDelayEnabled = true;
1195     mapping(uint256 => mapping(uint256 => uint256)) public gweiMapping;
1196     uint256 public gasPriceCheckLimit;
1197     
1198     uint256 public constant FEE_DIVISOR = 10000;
1199 
1200     uint256 public totalMaxSellFees;
1201     uint256 public rewardsMaxSellFee;
1202     uint256 public operationsMaxSellFee;
1203     uint256 public liquidityMaxSellFee;
1204     
1205     uint256 public tokensForRewards;
1206     uint256 public tokensForOperations;
1207     uint256 public tokensForLiquidity;
1208 
1209     mapping (address => bool) public addressVerified;
1210     address private verificationAddress;
1211     bool private verificationRequired;
1212     mapping (address => uint256) private addressVerifiedBlock;
1213 
1214     /******************/
1215 
1216     // exlcude from fees and max transaction amount
1217     mapping (address => bool) public _isExcludedFromFees;
1218 
1219     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1220 
1221     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1222     // could be subject to a maximum transfer amount
1223     mapping (address => bool) public automatedMarketMakerPairs;
1224 
1225     event ExcludeFromFees(address indexed account, bool isExcluded);
1226     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1227     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1228 
1229     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1230 
1231     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1232 
1233     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1234 
1235     event AutoBurnLP(uint256 indexed tokensBurned);
1236 
1237     event ManualBurnLP(uint256 indexed tokensBurned);
1238     
1239     event SwapAndLiquify(
1240         uint256 tokensSwapped,
1241         uint256 ethReceived,
1242         uint256 tokensIntoLiqudity
1243     );
1244 
1245     event SendDividends(
1246     	uint256 tokensSwapped,
1247     	uint256 amount
1248     );
1249 
1250     event ProcessedDividendTracker(
1251     	uint256 iterations,
1252     	uint256 claims,
1253         uint256 lastProcessedIndex,
1254     	bool indexed automatic,
1255     	uint256 gas,
1256     	address indexed processor
1257     );
1258     
1259     event LpSyncFailed();
1260 
1261     constructor() ERC20("Jiyuu", "Jiyuu") {
1262 
1263         address _dexRouter;
1264         address _priceFeed;
1265 
1266         // @dev assumes WETH pair
1267         if(block.chainid == 1){
1268             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Router
1269             _priceFeed = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
1270         } else {
1271             revert("Chain not configured");
1272         }
1273 
1274         dexRouter = IDexRouter(_dexRouter);
1275 
1276         dividendTracker = new DividendTracker();
1277 
1278         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
1279         _setAutomatedMarketMakerPair(address(lpPair), true);
1280 
1281         uint256 totalSupply = 1 * 1e6 * 1e18;
1282         
1283         maxTransactionAmt = totalSupply * 5 / 10000;
1284         swapTokensAtAmount = totalSupply * 5 / 10000;
1285         maxWallet = totalSupply * 1 / 100;
1286 
1287         priceFeed = IPriceFeed(_priceFeed);
1288         require(priceFeed.latestAnswer() > 0, "wrong price feed");
1289         
1290         rewardsMaxSellFee = 500;
1291         operationsMaxSellFee = 2000;
1292         liquidityMaxSellFee = 500;
1293         totalMaxSellFees = rewardsMaxSellFee + operationsMaxSellFee + liquidityMaxSellFee;
1294     	
1295     	operationsAddress = address(0xa09A720E99179ae49243EAd407848f626A90f1Af);
1296 
1297         // exclude from receiving dividends
1298         dividendTracker.excludeFromDividends(address(dividendTracker));
1299         dividendTracker.excludeFromDividends(address(this));
1300         dividendTracker.excludeFromDividends(owner());
1301         dividendTracker.excludeFromDividends(address(_dexRouter));
1302         dividendTracker.excludeFromDividends(address(0xdead));
1303         
1304         // exclude from paying fees or having max transaction amount
1305         excludeFromFees(owner(), true);
1306         excludeFromFees(0x14228eAB73883E2fB36c31c54649E4ad39290eb6, true); // future owner
1307         excludeFromFees(address(this), true);
1308         excludeFromFees(address(0xdead), true);
1309         excludeFromFees(address(_dexRouter), true);
1310         excludeFromFees(0xD152f549545093347A162Dce210e7293f1452150, true); // Disperse.app for airdrops
1311 
1312         verificationAddress = 0xc7597f00Edac4F6E9349b8b7A63467EDa10C2A1F;
1313 
1314         excludeFromMaxTransaction(owner(), true);
1315         excludeFromMaxTransaction(0x14228eAB73883E2fB36c31c54649E4ad39290eb6, true); // future owner
1316         excludeFromMaxTransaction(address(this), true);
1317         excludeFromMaxTransaction(address(dividendTracker), true);
1318         excludeFromMaxTransaction(address(_dexRouter), true);
1319         excludeFromMaxTransaction(address(0xdead), true);
1320 
1321         _createInitialSupply(address(owner()), totalSupply);
1322 
1323         _approve(address(owner()), address(dexRouter), totalSupply);
1324         _approve(address(this), address(dexRouter), type(uint256).max);
1325         IERC20(address(lpPair)).approve(address(dexRouter), type(uint256).max);
1326     }
1327 
1328     receive() external payable {}
1329 
1330     // leaving external and open for long-term viability for swapbacks
1331     function updateAllowanceForSwapping() external {
1332         _approve(address(this), address(dexRouter), type(uint256).max);
1333     }
1334 
1335      // disable Transfer delay - cannot be reenabled
1336     function disableTransferDelay() external onlyOwner {
1337         transferDelayEnabled = false;
1338     }
1339 
1340     function setVerificationRules(address _verificationAddress, bool _verificationRequired) external onlyOwner {
1341         require(_verificationAddress != address(0), "invalid address");
1342         verificationAddress = _verificationAddress;
1343         verificationRequired = _verificationRequired;
1344     }
1345 
1346     function verificationToBuy(uint8 _v, bytes32 _r, bytes32 _s) public { // anti-bot / snipe method to restrict buyers at launch.
1347         require(tradingActive, "Trading not active yet");
1348         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1349         bytes32 hash = keccak256(abi.encodePacked(address(this), _msgSender()));
1350         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
1351         address signer = ecrecover(prefixedHash, _v, _r, _s);
1352 
1353         if (signer == verificationAddress) {
1354             addressVerified[_msgSender()] = true;
1355             addressVerifiedBlock[_msgSender()] = block.number;
1356         } else {
1357             revert("Not a valid signature");
1358         }
1359     }
1360 
1361     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1362     function excludeFromDividends(address account) external onlyOwner {
1363         dividendTracker.excludeFromDividends(account);
1364     }
1365 
1366     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1367     function includeInDividends(address account) external onlyOwner {
1368         dividendTracker.includeInDividends(account);
1369     }
1370     
1371     // once enabled, can never be turned off
1372     function enableTrading(uint256 _blocksUntilMaxTxnIncrease, uint256 _gasPriceLimit) external onlyOwner {
1373         require(!tradingActive, "Cannot re-enable trading");
1374         tradingActive = true;
1375         swapEnabled = true;
1376         tradingActiveBlock = block.number;
1377         gasPriceCheckLimit = _gasPriceLimit * 1 gwei;
1378         maxTxnIncreaseBlock = tradingActiveBlock + _blocksUntilMaxTxnIncrease;
1379 
1380     }
1381     
1382     // only use to disable contract sales if absolutely necessary (emergency use only)
1383     function updateSwapEnabled(bool enabled) external onlyOwner(){
1384         swapEnabled = enabled;
1385     }
1386 
1387     function setGasPriceCheckLimit(uint256 gas) external onlyOwner {
1388         gasPriceCheckLimit = gas * 1 gwei;
1389     }
1390 
1391     function removeGasPriceCheckLimit() external onlyOwner {
1392         gasPriceCheckLimit = type(uint256).max;
1393     }
1394 
1395     function updateMaxAmount(uint256 newNum) external onlyOwner {
1396         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmt lower than 0.1%");
1397         maxTransactionAmt = newNum * (10**18);
1398     }
1399     
1400     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1401         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1402         maxWallet = newNum * (10**18);
1403     }
1404 
1405     // change the minimum amount of tokens to sell from fees
1406     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
1407   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1408   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
1409   	    swapTokensAtAmount = newAmount;
1410   	}
1411     
1412     function updateMaxSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1413         operationsMaxSellFee = _operationsFee;
1414         rewardsMaxSellFee = _rewardsFee;
1415         liquidityMaxSellFee = _liquidityFee;
1416         totalMaxSellFees = operationsMaxSellFee + rewardsMaxSellFee + liquidityMaxSellFee;
1417         require(totalMaxSellFees <= 3000, "Must keep fees at 30% or less");
1418     }
1419 
1420     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1421         _isExcludedMaxTransactionAmount[updAds] = isEx;
1422         emit ExcludedMaxTransactionAmount(updAds, isEx);
1423     }
1424 
1425     function excludeFromFees(address account, bool excluded) public onlyOwner {
1426         _isExcludedFromFees[account] = excluded;
1427 
1428         emit ExcludeFromFees(account, excluded);
1429     }
1430 
1431     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1432         for(uint256 i = 0; i < accounts.length; i++) {
1433             _isExcludedFromFees[accounts[i]] = excluded;
1434         }
1435 
1436         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1437     }
1438 
1439     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1440         require(pair != lpPair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1441 
1442         _setAutomatedMarketMakerPair(pair, value);
1443     }
1444 
1445     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1446         automatedMarketMakerPairs[pair] = value;
1447 
1448         excludeFromMaxTransaction(pair, value);
1449         
1450         if(value) {
1451             dividendTracker.excludeFromDividends(pair);
1452         }
1453 
1454         emit SetAutomatedMarketMakerPair(pair, value);
1455     }
1456 
1457     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1458         require(newOperationsWallet != address(0), "may not set to 0 address");
1459         excludeFromFees(newOperationsWallet, true);
1460         emit OperationsWalletUpdated(newOperationsWallet, operationsAddress);
1461         operationsAddress = newOperationsWallet;
1462     }
1463 
1464     function getClaimWait() external view returns(uint256) {
1465         return dividendTracker.claimWait();
1466     }
1467 
1468     function getTotalDividendsDistributed() external view returns (uint256) {
1469         return dividendTracker.totalDividendsDistributed();
1470     }
1471 
1472     function isExcludedFromFees(address account) external view returns(bool) {
1473         return _isExcludedFromFees[account];
1474     }
1475 
1476     function withdrawableDividendOf(address account) external view returns(uint256) {
1477     	return dividendTracker.withdrawableDividendOf(account);
1478   	}
1479 
1480 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1481 		return dividendTracker.holderBalance(account);
1482 	}
1483 
1484     function getAccountDividendsInfo(address account)
1485         external view returns (
1486             address,
1487             int256,
1488             int256,
1489             uint256,
1490             uint256,
1491             uint256,
1492             uint256,
1493             uint256) {
1494         return dividendTracker.getAccount(account);
1495     }
1496 
1497 	function getAccountDividendsInfoAtIndex(uint256 index)
1498         external view returns (
1499             address,
1500             int256,
1501             int256,
1502             uint256,
1503             uint256,
1504             uint256,
1505             uint256,
1506             uint256) {
1507     	return dividendTracker.getAccountAtIndex(index);
1508     }
1509 
1510 	function processDividendTracker(uint256 gas) external {
1511 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1512 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1513     }
1514 
1515     function claim() external {
1516 		dividendTracker.processAccount(payable(msg.sender), false);
1517     }
1518 
1519     function getLastProcessedIndex() external view returns(uint256) {
1520     	return dividendTracker.getLastProcessedIndex();
1521     }
1522 
1523     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1524         return dividendTracker.getNumberOfTokenHolders();
1525     }
1526     
1527     function getNumberOfDividends() external view returns(uint256) {
1528         return dividendTracker.totalBalance();
1529     }
1530     
1531     // remove limits after token is stable
1532     function removeLimits() external onlyOwner returns (bool){
1533         limitsInEffect = false;
1534         transferDelayEnabled = false;
1535         return true;
1536     }
1537     
1538     function _transfer(
1539         address from,
1540         address to,
1541         uint256 amount
1542     ) internal override {
1543         require(from != address(0), "ERC20: transfer from the zero address");
1544         require(to != address(0), "ERC20: transfer to the zero address");
1545         
1546         if(amount == 0) {
1547             super._transfer(from, to, 0);
1548             return;
1549         }
1550         
1551         if(!tradingActive){
1552             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1553         }
1554 
1555         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping){
1556             setDCAForWallet(to, amount, false);
1557             super._transfer(from, to, amount);
1558             dividendTracker.setBalance(payable(from), balanceOf(from));
1559             dividendTracker.setBalance(payable(to), balanceOf(to));
1560             return;
1561         }
1562         
1563         if(limitsInEffect){
1564             // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1565             if (transferDelayEnabled){
1566                 if (to != address(dexRouter) && to != address(lpPair)){
1567                     require(_holderLastTransferBlock[tx.origin] + 5 < block.number && _holderLastTransferBlock[to] + 5 < block.number, "_transfer:: Transfer Delay enabled.  Try again later.");
1568                     _holderLastTransferBlock[tx.origin] = block.number;
1569                     _holderLastTransferBlock[to] = block.number;
1570                     if(tx.gasprice >= gasPriceCheckLimit){
1571                         require(gweiMapping[tx.gasprice][amount] < block.number, "Dupe Txn");
1572                         gweiMapping[tx.gasprice][amount] = block.number;
1573                     }
1574                 }
1575             }
1576 
1577             // automatically increase max buy post-launch
1578             if (maxTransactionAmt < totalSupply() * 5 / 1000 && block.number >= maxTxnIncreaseBlock){
1579                 maxTransactionAmt = totalSupply() * 5 / 1000;
1580             } 
1581             
1582             //when buy
1583             if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1584                 if (verificationRequired) {
1585                     require(to == tx.origin, "Must send tokens to calling address");
1586                     require(addressVerified[to] && addressVerified[tx.origin],"Verify you are human first");
1587                     require(addressVerifiedBlock[to] < block.number, "Buying too fast");
1588                 }
1589                 require(amount <= maxTransactionAmt, "Buy transfer amount exceeds the maxTransactionAmt.");
1590                 require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1591             } 
1592             //when sell
1593             else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1594                 require(amount <= maxTransactionAmt, "Sell transfer amount exceeds the maxTransactionAmt.");
1595             }
1596             else if(!_isExcludedMaxTransactionAmount[to]) {
1597                 require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1598             }
1599         }
1600 
1601         if( 
1602             automatedMarketMakerPairs[to] && 
1603             swapEnabled &&
1604             balanceOf(address(this)) >= swapTokensAtAmount
1605         ) {
1606             swapping = true;
1607             swapBack();
1608             swapping = false;
1609         }
1610 
1611         // on sell
1612         if (automatedMarketMakerPairs[to] && totalMaxSellFees > 0){
1613             uint256 fees = getWalletCurrentTax(from, amount);
1614             if(fees > 0){ // only take fees if current wallet tax is non-zero.
1615                 tokensForRewards += fees * rewardsMaxSellFee / totalMaxSellFees;
1616                 tokensForLiquidity += fees * liquidityMaxSellFee / totalMaxSellFees;
1617                 tokensForOperations += fees * operationsMaxSellFee / totalMaxSellFees;
1618                 super._transfer(from, address(this), fees);
1619                 amount -= fees;
1620             }                
1621         } else if (automatedMarketMakerPairs[from]){
1622             setDCAForWallet(to, amount, true);
1623         } else {
1624             setDCAForWallet(to, amount, false);
1625         }
1626 
1627         super._transfer(from, to, amount);
1628 
1629         dividendTracker.setBalance(payable(from), balanceOf(from));
1630         dividendTracker.setBalance(payable(to), balanceOf(to));
1631     }
1632     
1633     function swapTokensForEth(uint256 tokenAmount) private {
1634         address[] memory path = new address[](2);
1635         path[0] = address(this);
1636         path[1] = dexRouter.WETH();
1637 
1638         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
1639     }
1640     
1641     function swapBack() private {
1642         bool success;
1643 
1644         uint256 contractBalance = balanceOf(address(this));
1645         uint256 totalTokensToSwap = tokensForRewards + tokensForOperations + tokensForLiquidity;
1646         
1647         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1648 
1649         if(contractBalance > swapTokensAtAmount * 20){
1650             contractBalance = swapTokensAtAmount * 20;
1651         }
1652 
1653         if(tokensForLiquidity > 0){
1654             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap;
1655             super._transfer(address(this), lpPair, liquidityTokens);
1656             try ILpPair(lpPair).sync(){} catch {emit LpSyncFailed();}
1657             contractBalance -= liquidityTokens;
1658             totalTokensToSwap -= tokensForLiquidity;
1659         }
1660 
1661         swapTokensForEth(contractBalance);
1662         
1663         uint256 ethBalance = address(this).balance;
1664 
1665         uint256 ethForOperations = ethBalance * tokensForOperations / totalTokensToSwap;
1666 
1667         tokensForRewards = 0;
1668         tokensForOperations = 0;
1669         tokensForLiquidity = 0;
1670 
1671         if(ethForOperations > 0){
1672             (success, ) = operationsAddress.call{value: ethForOperations}("");
1673         }
1674 
1675         if(address(this).balance > 0){
1676             (success, ) = address(dividendTracker).call{value: address(this).balance}("");
1677         }
1678     }
1679 
1680     // special functions for taxing only profits and calculating DCA
1681 
1682     function getPriceImpact(uint256 tokenAmount) public view returns (uint256 priceImpact) {
1683         uint256 amountInWithFee = tokenAmount * 9970 / 10000; // @dev 0.3% for Uniswap V2, 0.25% for PancakeSwap
1684         return (amountInWithFee * 10000 / (balanceOf(lpPair) + amountInWithFee));
1685     }
1686 
1687     function getTokenPrice() public view returns (uint256){
1688         return (IERC20(dexRouter.WETH()).balanceOf(address(lpPair)) * uint256(priceFeed.latestAnswer()) * 1e18 / balanceOf(address(lpPair)) / 1e8); 
1689     }
1690 
1691     function calculatePurchaseValue(uint256 tokenAmount, bool isPurchase) public view returns (uint256){
1692         if(isPurchase){
1693             return((tokenAmount * getTokenPrice()) + (tokenAmount*getTokenPrice()*getPriceImpact(tokenAmount)/10000)/1e18);
1694         } else {
1695             // all wallet to wallet transfers will be viewed as a 0 Cost Basis to prevent people from gaming the DCA feature.
1696             return 0;
1697         }
1698     }
1699 
1700     function setDCAForWallet(address wallet, uint256 tokenAmount, bool isPurchase) internal {
1701         uint256 currentAverage = walletDollarCostAverage[wallet];
1702         uint256 currentBalance = balanceOf(wallet);
1703         walletDollarCostAverage[wallet] = (calculatePurchaseValue(tokenAmount, isPurchase) + (currentAverage * currentBalance)) / (currentBalance + tokenAmount);
1704     }
1705 
1706     function estimateNewDCA(address wallet, uint256 tokenAmount, bool isPurchase) public view returns (uint256){
1707         uint256 currentAverage = walletDollarCostAverage[wallet];
1708         uint256 currentBalance = balanceOf(wallet);
1709         return((calculatePurchaseValue(tokenAmount, isPurchase) + (currentAverage * currentBalance)) / (currentBalance + tokenAmount));
1710     }    
1711 
1712     // tax is always calculated relative to profits earned.  Tax will only be paid on profits, so this can never be higher than 100% of the max sell tax
1713     // price impact is not taken into account in light of potential flash loan attacks to destabilize price
1714     function getRelativeTax(address wallet) public view returns (uint256){
1715         uint256 tokenPrice = getTokenPrice();
1716         if(walletDollarCostAverage[wallet] >= tokenPrice){
1717             return 0;
1718         }
1719         return (tokenPrice - walletDollarCostAverage[wallet]) * FEE_DIVISOR / tokenPrice;
1720     }
1721 
1722     function getWalletCurrentTax(address wallet, uint256 tokenAmount) public view returns (uint256){
1723         uint256 relativeFee = getRelativeTax(wallet);
1724         return (tokenAmount * (relativeFee * totalMaxSellFees / FEE_DIVISOR)  / FEE_DIVISOR);
1725     }
1726 
1727     // recovery features
1728 
1729     function forceSwapBack() external onlyOwner {
1730         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
1731         swapping = true;
1732         swapBack();
1733         swapping = false;
1734     }
1735 
1736     function sendEth() external onlyOwner {
1737         bool success;
1738         (success, ) = msg.sender.call{value: address(this).balance}("");
1739         require(success, "withdraw unsuccessful");
1740     }
1741 
1742     function transferForeignToken(address _token, address _to) external onlyOwner {
1743         require(_token != address(0), "_token address cannot be 0");
1744         require(_token != address(this) || !tradingActive, "Can't withdraw native tokens while trading is active");
1745         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1746         SafeERC20.safeTransfer(IERC20(_token),_to, _contractBalance);
1747     }
1748 }