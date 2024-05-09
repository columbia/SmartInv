1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.13;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IDexPair {
17     function sync() external;
18 }
19 
20 interface IUniswapV2Factory {
21     function createPair(address tokenA, address tokenB) external returns (address pair);
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 
117 contract ERC20 is Context, IERC20, IERC20Metadata {
118     mapping(address => uint256) private _balances;
119 
120     mapping(address => mapping(address => uint256)) private _allowances;
121 
122     uint256 private _totalSupply;
123 
124     string private _name;
125     string private _symbol;
126 
127     constructor(string memory name_, string memory symbol_) {
128         _name = name_;
129         _symbol = symbol_;
130     }
131 
132     function name() public view virtual override returns (string memory) {
133         return _name;
134     }
135 
136     function symbol() public view virtual override returns (string memory) {
137         return _symbol;
138     }
139 
140     function decimals() public view virtual override returns (uint8) {
141         return 18;
142     }
143 
144     function totalSupply() public view virtual override returns (uint256) {
145         return _totalSupply;
146     }
147 
148     function balanceOf(address account) public view virtual override returns (uint256) {
149         return _balances[account];
150     }
151 
152     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
153         _transfer(_msgSender(), recipient, amount);
154         return true;
155     }
156 
157     function allowance(address owner, address spender) public view virtual override returns (uint256) {
158         return _allowances[owner][spender];
159     }
160 
161     function approve(address spender, uint256 amount) public virtual override returns (bool) {
162         _approve(_msgSender(), spender, amount);
163         return true;
164     }
165 
166     function transferFrom(
167         address sender,
168         address recipient,
169         uint256 amount
170     ) public virtual override returns (bool) {
171         _transfer(sender, recipient, amount);
172 
173         uint256 currentAllowance = _allowances[sender][_msgSender()];
174         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
175         unchecked {
176             _approve(sender, _msgSender(), currentAllowance - amount);
177         }
178 
179         return true;
180     }
181 
182     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
183         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
184         return true;
185     }
186 
187     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
188         uint256 currentAllowance = _allowances[_msgSender()][spender];
189         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
190         unchecked {
191             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
192         }
193 
194         return true;
195     }
196 
197     function _transfer(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) internal virtual {
202         require(sender != address(0), "ERC20: transfer from the zero address");
203         require(recipient != address(0), "ERC20: transfer to the zero address");
204 
205         uint256 senderBalance = _balances[sender];
206         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
207         unchecked {
208             _balances[sender] = senderBalance - amount;
209         }
210         _balances[recipient] += amount;
211 
212         emit Transfer(sender, recipient, amount);
213     }
214 
215     function _createInitialSupply(address account, uint256 amount) internal virtual {
216         require(account != address(0), "ERC20: mint to the zero address");
217         _totalSupply += amount;
218         _balances[account] += amount;
219         emit Transfer(address(0), account, amount);
220     }
221 
222     function _approve(
223         address owner,
224         address spender,
225         uint256 amount
226     ) internal virtual {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229 
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 }
234 
235 interface DividendPayingTokenOptionalInterface {
236   /// @notice View the amount of dividend in wei that an address can withdraw.
237   /// @param _owner The address of a token holder.
238   /// @return The amount of dividend in wei that `_owner` can withdraw.
239   function withdrawableDividendOf(address _owner) external view returns(uint256);
240 
241   /// @notice View the amount of dividend in wei that an address has withdrawn.
242   /// @param _owner The address of a token holder.
243   /// @return The amount of dividend in wei that `_owner` has withdrawn.
244   function withdrawnDividendOf(address _owner) external view returns(uint256);
245 
246   /// @notice View the amount of dividend in wei that an address has earned in total.
247   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
248   /// @param _owner The address of a token holder.
249   /// @return The amount of dividend in wei that `_owner` has earned in total.
250   function accumulativeDividendOf(address _owner) external view returns(uint256);
251 }
252 
253 interface DividendPayingTokenInterface {
254   /// @notice View the amount of dividend in wei that an address can withdraw.
255   /// @param _owner The address of a token holder.
256   /// @return The amount of dividend in wei that `_owner` can withdraw.
257   function dividendOf(address _owner) external view returns(uint256);
258 
259   /// @notice Distributes ether to token holders as dividends.
260   /// @dev SHOULD distribute the paid ether to token holders as dividends.
261   ///  SHOULD NOT directly transfer ether to token holders in this function.
262   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
263   function distributeDividends() external payable;
264 
265   /// @notice Withdraws the ether distributed to the sender.
266   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
267   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
268   function withdrawDividend() external;
269 
270   /// @dev This event MUST emit when ether is distributed to token holders.
271   /// @param from The address which sends ether to this contract.
272   /// @param weiAmount The amount of distributed ether in wei.
273   event DividendsDistributed(
274     address indexed from,
275     uint256 weiAmount
276   );
277 
278   /// @dev This event MUST emit when an address withdraws their dividend.
279   /// @param to The address which withdraws ether from this contract.
280   /// @param weiAmount The amount of withdrawn ether in wei.
281   event DividendWithdrawn(
282     address indexed to,
283     uint256 weiAmount
284   );
285 }
286 
287 library SafeMath {
288     /**
289      * @dev Returns the addition of two unsigned integers, reverting on
290      * overflow.
291      *
292      * Counterpart to Solidity's `+` operator.
293      *
294      * Requirements:
295      *
296      * - Addition cannot overflow.
297      */
298     function add(uint256 a, uint256 b) internal pure returns (uint256) {
299         uint256 c = a + b;
300         require(c >= a, "SafeMath: addition overflow");
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the subtraction of two unsigned integers, reverting on
307      * overflow (when the result is negative).
308      *
309      * Counterpart to Solidity's `-` operator.
310      *
311      * Requirements:
312      *
313      * - Subtraction cannot overflow.
314      */
315     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
316         return sub(a, b, "SafeMath: subtraction overflow");
317     }
318 
319     /**
320      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
321      * overflow (when the result is negative).
322      *
323      * Counterpart to Solidity's `-` operator.
324      *
325      * Requirements:
326      *
327      * - Subtraction cannot overflow.
328      */
329     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
330         require(b <= a, errorMessage);
331         uint256 c = a - b;
332 
333         return c;
334     }
335 
336     /**
337      * @dev Returns the multiplication of two unsigned integers, reverting on
338      * overflow.
339      *
340      * Counterpart to Solidity's `*` operator.
341      *
342      * Requirements:
343      *
344      * - Multiplication cannot overflow.
345      */
346     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
347         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
348         // benefit is lost if 'b' is also tested.
349         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
350         if (a == 0) {
351             return 0;
352         }
353 
354         uint256 c = a * b;
355         require(c / a == b, "SafeMath: multiplication overflow");
356 
357         return c;
358     }
359 
360     /**
361      * @dev Returns the integer division of two unsigned integers. Reverts on
362      * division by zero. The result is rounded towards zero.
363      *
364      * Counterpart to Solidity's `/` operator. Note: this function uses a
365      * `revert` opcode (which leaves remaining gas untouched) while Solidity
366      * uses an invalid opcode to revert (consuming all remaining gas).
367      *
368      * Requirements:
369      *
370      * - The divisor cannot be zero.
371      */
372     function div(uint256 a, uint256 b) internal pure returns (uint256) {
373         return div(a, b, "SafeMath: division by zero");
374     }
375 
376     /**
377      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
378      * division by zero. The result is rounded towards zero.
379      *
380      * Counterpart to Solidity's `/` operator. Note: this function uses a
381      * `revert` opcode (which leaves remaining gas untouched) while Solidity
382      * uses an invalid opcode to revert (consuming all remaining gas).
383      *
384      * Requirements:
385      *
386      * - The divisor cannot be zero.
387      */
388     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
389         require(b > 0, errorMessage);
390         uint256 c = a / b;
391         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
392 
393         return c;
394     }
395 
396     /**
397      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
398      * Reverts when dividing by zero.
399      *
400      * Counterpart to Solidity's `%` operator. This function uses a `revert`
401      * opcode (which leaves remaining gas untouched) while Solidity uses an
402      * invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
409         return mod(a, b, "SafeMath: modulo by zero");
410     }
411 
412     /**
413      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
414      * Reverts with custom message when dividing by zero.
415      *
416      * Counterpart to Solidity's `%` operator. This function uses a `revert`
417      * opcode (which leaves remaining gas untouched) while Solidity uses an
418      * invalid opcode to revert (consuming all remaining gas).
419      *
420      * Requirements:
421      *
422      * - The divisor cannot be zero.
423      */
424     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
425         require(b != 0, errorMessage);
426         return a % b;
427     }
428 }
429 
430 contract Ownable is Context {
431     address private _owner;
432 
433     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
434     
435     /**
436      * @dev Initializes the contract setting the deployer as the initial owner.
437      */
438     constructor () {
439         address msgSender = _msgSender();
440         _owner = msgSender;
441         emit OwnershipTransferred(address(0), msgSender);
442     }
443 
444     /**
445      * @dev Returns the address of the current owner.
446      */
447     function owner() public view returns (address) {
448         return _owner;
449     }
450 
451     /**
452      * @dev Throws if called by any account other than the owner.
453      */
454     modifier onlyOwner() {
455         require(_owner == _msgSender(), "Ownable: caller is not the owner");
456         _;
457     }
458 
459     /**
460      * @dev Leaves the contract without owner. It will not be possible to call
461      * `onlyOwner` functions anymore. Can only be called by the current owner.
462      *
463      * NOTE: Renouncing ownership will leave the contract without an owner,
464      * thereby removing any functionality that is only available to the owner.
465      */
466     function renounceOwnership() public virtual onlyOwner {
467         emit OwnershipTransferred(_owner, address(0));
468         _owner = address(0);
469     }
470 
471     /**
472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
473      * Can only be called by the current owner.
474      */
475     function transferOwnership(address newOwner) public virtual onlyOwner {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         emit OwnershipTransferred(_owner, newOwner);
478         _owner = newOwner;
479     }
480 }
481 
482 
483 
484 library SafeMathInt {
485     int256 private constant MIN_INT256 = int256(1) << 255;
486     int256 private constant MAX_INT256 = ~(int256(1) << 255);
487 
488     /**
489      * @dev Multiplies two int256 variables and fails on overflow.
490      */
491     function mul(int256 a, int256 b) internal pure returns (int256) {
492         int256 c = a * b;
493 
494         // Detect overflow when multiplying MIN_INT256 with -1
495         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
496         require((b == 0) || (c / b == a));
497         return c;
498     }
499 
500     /**
501      * @dev Division of two int256 variables and fails on overflow.
502      */
503     function div(int256 a, int256 b) internal pure returns (int256) {
504         // Prevent overflow when dividing MIN_INT256 by -1
505         require(b != -1 || a != MIN_INT256);
506 
507         // Solidity already throws when dividing by 0.
508         return a / b;
509     }
510 
511     /**
512      * @dev Subtracts two int256 variables and fails on overflow.
513      */
514     function sub(int256 a, int256 b) internal pure returns (int256) {
515         int256 c = a - b;
516         require((b >= 0 && c <= a) || (b < 0 && c > a));
517         return c;
518     }
519 
520     /**
521      * @dev Adds two int256 variables and fails on overflow.
522      */
523     function add(int256 a, int256 b) internal pure returns (int256) {
524         int256 c = a + b;
525         require((b >= 0 && c >= a) || (b < 0 && c < a));
526         return c;
527     }
528 
529     /**
530      * @dev Converts to absolute value, and fails on overflow.
531      */
532     function abs(int256 a) internal pure returns (int256) {
533         require(a != MIN_INT256);
534         return a < 0 ? -a : a;
535     }
536 
537 
538     function toUint256Safe(int256 a) internal pure returns (uint256) {
539         require(a >= 0);
540         return uint256(a);
541     }
542 }
543 
544 library SafeMathUint {
545   function toInt256Safe(uint256 a) internal pure returns (int256) {
546     int256 b = int256(a);
547     require(b >= 0);
548     return b;
549   }
550 }
551 
552 
553 interface IUniswapV2Router01 {
554     function factory() external pure returns (address);
555     function WETH() external pure returns (address);
556 
557     function addLiquidity(
558         address tokenA,
559         address tokenB,
560         uint amountADesired,
561         uint amountBDesired,
562         uint amountAMin,
563         uint amountBMin,
564         address to,
565         uint deadline
566     ) external returns (uint amountA, uint amountB, uint liquidity);
567     function addLiquidityETH(
568         address token,
569         uint amountTokenDesired,
570         uint amountTokenMin,
571         uint amountETHMin,
572         address to,
573         uint deadline
574     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
575     function removeLiquidity(
576         address tokenA,
577         address tokenB,
578         uint liquidity,
579         uint amountAMin,
580         uint amountBMin,
581         address to,
582         uint deadline
583     ) external returns (uint amountA, uint amountB);
584     function removeLiquidityETH(
585         address token,
586         uint liquidity,
587         uint amountTokenMin,
588         uint amountETHMin,
589         address to,
590         uint deadline
591     ) external returns (uint amountToken, uint amountETH);
592     function removeLiquidityWithPermit(
593         address tokenA,
594         address tokenB,
595         uint liquidity,
596         uint amountAMin,
597         uint amountBMin,
598         address to,
599         uint deadline,
600         bool approveMax, uint8 v, bytes32 r, bytes32 s
601     ) external returns (uint amountA, uint amountB);
602     function removeLiquidityETHWithPermit(
603         address token,
604         uint liquidity,
605         uint amountTokenMin,
606         uint amountETHMin,
607         address to,
608         uint deadline,
609         bool approveMax, uint8 v, bytes32 r, bytes32 s
610     ) external returns (uint amountToken, uint amountETH);
611     function swapExactTokensForTokens(
612         uint amountIn,
613         uint amountOutMin,
614         address[] calldata path,
615         address to,
616         uint deadline
617     ) external returns (uint[] memory amounts);
618     function swapTokensForExactTokens(
619         uint amountOut,
620         uint amountInMax,
621         address[] calldata path,
622         address to,
623         uint deadline
624     ) external returns (uint[] memory amounts);
625     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
626         external
627         payable
628         returns (uint[] memory amounts);
629     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
630         external
631         returns (uint[] memory amounts);
632     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
633         external
634         returns (uint[] memory amounts);
635     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
636         external
637         payable
638         returns (uint[] memory amounts);
639 
640     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
641     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
642     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
643     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
644     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
645 }
646 
647 interface IUniswapV2Router02 is IUniswapV2Router01 {
648     function removeLiquidityETHSupportingFeeOnTransferTokens(
649         address token,
650         uint liquidity,
651         uint amountTokenMin,
652         uint amountETHMin,
653         address to,
654         uint deadline
655     ) external returns (uint amountETH);
656     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
657         address token,
658         uint liquidity,
659         uint amountTokenMin,
660         uint amountETHMin,
661         address to,
662         uint deadline,
663         bool approveMax, uint8 v, bytes32 r, bytes32 s
664     ) external returns (uint amountETH);
665 
666     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
667         uint amountIn,
668         uint amountOutMin,
669         address[] calldata path,
670         address to,
671         uint deadline
672     ) external;
673     function swapExactETHForTokensSupportingFeeOnTransferTokens(
674         uint amountOutMin,
675         address[] calldata path,
676         address to,
677         uint deadline
678     ) external payable;
679     function swapExactTokensForETHSupportingFeeOnTransferTokens(
680         uint amountIn,
681         uint amountOutMin,
682         address[] calldata path,
683         address to,
684         uint deadline
685     ) external;
686 }
687 
688 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
689   using SafeMath for uint256;
690   using SafeMathUint for uint256;
691   using SafeMathInt for int256;
692 
693   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
694   // For more discussion about choosing the value of `magnitude`,
695   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
696   uint256 constant internal magnitude = 2**128;
697 
698   uint256 internal magnifiedDividendPerShare;
699   
700   // About dividendCorrection:
701   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
702   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
703   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
704   //   `dividendOf(_user)` should not be changed,
705   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
706   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
707   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
708   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
709   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
710   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
711   mapping(address => int256) internal magnifiedDividendCorrections;
712   mapping(address => uint256) internal withdrawnDividends;
713   
714   mapping (address => uint256) public holderBalance;
715   uint256 public totalBalance;
716 
717   uint256 public totalDividendsDistributed;
718 
719   /// @dev Distributes dividends whenever ether is paid to this contract.
720   receive() external payable {
721     distributeDividends();
722   }
723 
724   /// @notice Distributes ether to token holders as dividends.
725   /// @dev It reverts if the total supply of tokens is 0.
726   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
727   /// About undistributed ether:
728   ///   In each distribution, there is a small amount of ether not distributed,
729   ///     the magnified amount of which is
730   ///     `(msg.value * magnitude) % totalSupply()`.
731   ///   With a well-chosen `magnitude`, the amount of undistributed ether
732   ///     (de-magnified) in a distribution can be less than 1 wei.
733   ///   We can actually keep track of the undistributed ether in a distribution
734   ///     and try to distribute it in the next distribution,
735   ///     but keeping track of such data on-chain costs much more than
736   ///     the saved ether, so we don't do that.
737     
738   function distributeDividends() public override payable { 
739       require(totalBalance > 0);
740 
741         if (msg.value > 0) {
742           magnifiedDividendPerShare = magnifiedDividendPerShare.add(
743             (msg.value).mul(magnitude) / totalBalance
744           );
745           emit DividendsDistributed(msg.sender, msg.value);
746     
747           totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
748         }
749   }
750   
751   /// @notice Withdraws the ether distributed to the sender.
752   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
753   function withdrawDividend() external virtual override {
754     _withdrawDividendOfUser(payable(msg.sender));
755   }
756 
757   /// @notice Withdraws the ether distributed to the sender.
758   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
759   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
760     uint256 _withdrawableDividend = withdrawableDividendOf(user);
761     if (_withdrawableDividend > 0) {
762       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
763       emit DividendWithdrawn(user, _withdrawableDividend);
764       (bool success,) = user.call{value: _withdrawableDividend, gas: 3000}("");
765 
766       if(!success) {
767         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
768         return 0;
769       }
770 
771       return _withdrawableDividend;
772     }
773 
774     return 0;
775   }
776 
777 
778   /// @notice View the amount of dividend in wei that an address can withdraw.
779   /// @param _owner The address of a token holder.
780   /// @return The amount of dividend in wei that `_owner` can withdraw.
781   function dividendOf(address _owner) external view override returns(uint256) {
782     return withdrawableDividendOf(_owner);
783   }
784 
785   /// @notice View the amount of dividend in wei that an address can withdraw.
786   /// @param _owner The address of a token holder.
787   /// @return The amount of dividend in wei that `_owner` can withdraw.
788   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
789     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
790   }
791 
792   /// @notice View the amount of dividend in wei that an address has withdrawn.
793   /// @param _owner The address of a token holder.
794   /// @return The amount of dividend in wei that `_owner` has withdrawn.
795   function withdrawnDividendOf(address _owner) external view override returns(uint256) {
796     return withdrawnDividends[_owner];
797   }
798 
799 
800   /// @notice View the amount of dividend in wei that an address has earned in total.
801   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
802   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
803   /// @param _owner The address of a token holder.
804   /// @return The amount of dividend in wei that `_owner` has earned in total.
805   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
806     return magnifiedDividendPerShare.mul(holderBalance[_owner]).toInt256Safe()
807       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
808   }
809 
810   /// @dev Internal function that increases tokens to an account.
811   /// Update magnifiedDividendCorrections to keep dividends unchanged.
812   /// @param account The account that will receive the created tokens.
813   /// @param value The amount that will be created.
814   function _increase(address account, uint256 value) internal {
815     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
816       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
817   }
818 
819   /// @dev Internal function that reduces an amount of the token of a given account.
820   /// Update magnifiedDividendCorrections to keep dividends unchanged.
821   /// @param account The account whose tokens will be burnt.
822   /// @param value The amount that will be burnt.
823   function _reduce(address account, uint256 value) internal {
824     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
825       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
826   }
827 
828   function _setBalance(address account, uint256 newBalance) internal {
829     uint256 currentBalance = holderBalance[account];
830     holderBalance[account] = newBalance;
831     if(newBalance > currentBalance) {
832       uint256 increaseAmount = newBalance.sub(currentBalance);
833       _increase(account, increaseAmount);
834       totalBalance += increaseAmount;
835     } else if(newBalance < currentBalance) {
836       uint256 reduceAmount = currentBalance.sub(newBalance);
837       _reduce(account, reduceAmount);
838       totalBalance -= reduceAmount;
839     }
840   }
841 }
842 
843 contract DividendTracker is DividendPayingToken {
844     using SafeMath for uint256;
845     using SafeMathInt for int256;
846 
847     struct Map {
848         address[] keys;
849         mapping(address => uint) values;
850         mapping(address => uint) indexOf;
851         mapping(address => bool) inserted;
852     }
853 
854     function get(address key) private view returns (uint) {
855         return tokenHoldersMap.values[key];
856     }
857 
858     function getIndexOfKey(address key) private view returns (int) {
859         if(!tokenHoldersMap.inserted[key]) {
860             return -1;
861         }
862         return int(tokenHoldersMap.indexOf[key]);
863     }
864 
865     function getKeyAtIndex(uint index) private view returns (address) {
866         return tokenHoldersMap.keys[index];
867     }
868 
869 
870 
871     function size() private view returns (uint) {
872         return tokenHoldersMap.keys.length;
873     }
874 
875     function set(address key, uint val) private {
876         if (tokenHoldersMap.inserted[key]) {
877             tokenHoldersMap.values[key] = val;
878         } else {
879             tokenHoldersMap.inserted[key] = true;
880             tokenHoldersMap.values[key] = val;
881             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
882             tokenHoldersMap.keys.push(key);
883         }
884     }
885 
886     function remove(address key) private {
887         if (!tokenHoldersMap.inserted[key]) {
888             return;
889         }
890 
891         delete tokenHoldersMap.inserted[key];
892         delete tokenHoldersMap.values[key];
893 
894         uint index = tokenHoldersMap.indexOf[key];
895         uint lastIndex = tokenHoldersMap.keys.length - 1;
896         address lastKey = tokenHoldersMap.keys[lastIndex];
897 
898         tokenHoldersMap.indexOf[lastKey] = index;
899         delete tokenHoldersMap.indexOf[key];
900 
901         tokenHoldersMap.keys[index] = lastKey;
902         tokenHoldersMap.keys.pop();
903     }
904 
905     Map private tokenHoldersMap;
906     uint256 public lastProcessedIndex;
907 
908     mapping (address => bool) public excludedFromDividends;
909 
910     mapping (address => uint256) public lastClaimTimes;
911 
912     uint256 public claimWait;
913     uint256 public immutable minimumTokenBalanceForDividends;
914 
915     event ExcludeFromDividends(address indexed account);
916     event IncludeInDividends(address indexed account);
917     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
918 
919     event Claim(address indexed account, uint256 amount, bool indexed automatic);
920 
921     constructor() {
922     	claimWait = 1200;
923         minimumTokenBalanceForDividends = 1000 * (10**18);
924     }
925 
926     function excludeFromDividends(address account) external onlyOwner {
927     	excludedFromDividends[account] = true;
928 
929     	_setBalance(account, 0);
930     	remove(account);
931 
932     	emit ExcludeFromDividends(account);
933     }
934     
935     function includeInDividends(address account) external onlyOwner {
936     	require(excludedFromDividends[account]);
937     	excludedFromDividends[account] = false;
938 
939     	emit IncludeInDividends(account);
940     }
941 
942     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
943         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
944         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
945         emit ClaimWaitUpdated(newClaimWait, claimWait);
946         claimWait = newClaimWait;
947     }
948 
949     function getLastProcessedIndex() external view returns(uint256) {
950     	return lastProcessedIndex;
951     }
952 
953     function getNumberOfTokenHolders() external view returns(uint256) {
954         return tokenHoldersMap.keys.length;
955     }
956 
957     // Check to see if I really made this contract or if it is a clone!
958     // @Sir_Tris on TG, @SirTrisCrypto on Twitter
959 
960     function getAccount(address _account)
961         public view returns (
962             address account,
963             int256 index,
964             int256 iterationsUntilProcessed,
965             uint256 withdrawableDividends,
966             uint256 totalDividends,
967             uint256 lastClaimTime,
968             uint256 nextClaimTime,
969             uint256 secondsUntilAutoClaimAvailable) {
970         account = _account;
971 
972         index = getIndexOfKey(account);
973 
974         iterationsUntilProcessed = -1;
975 
976         if(index >= 0) {
977             if(uint256(index) > lastProcessedIndex) {
978                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
979             }
980             else {
981                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
982                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
983                                                         0;
984 
985 
986                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
987             }
988         }
989 
990 
991         withdrawableDividends = withdrawableDividendOf(account);
992         totalDividends = accumulativeDividendOf(account);
993 
994         lastClaimTime = lastClaimTimes[account];
995 
996         nextClaimTime = lastClaimTime > 0 ?
997                                     lastClaimTime.add(claimWait) :
998                                     0;
999 
1000         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1001                                                     nextClaimTime.sub(block.timestamp) :
1002                                                     0;
1003     }
1004 
1005     function getAccountAtIndex(uint256 index)
1006         external view returns (
1007             address,
1008             int256,
1009             int256,
1010             uint256,
1011             uint256,
1012             uint256,
1013             uint256,
1014             uint256) {
1015     	if(index >= size()) {
1016             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1017         }
1018 
1019         address account = getKeyAtIndex(index);
1020 
1021         return getAccount(account);
1022     }
1023 
1024     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1025     	if(lastClaimTime > block.timestamp)  {
1026     		return false;
1027     	}
1028 
1029     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1030     }
1031 
1032     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1033     	if(excludedFromDividends[account]) {
1034     		return;
1035     	}
1036 
1037     	if(newBalance >= minimumTokenBalanceForDividends) {
1038             _setBalance(account, newBalance);
1039     		set(account, newBalance);
1040     	}
1041     	else {
1042             _setBalance(account, 0);
1043     		remove(account);
1044     	}
1045 
1046     	processAccount(account, true);
1047     }
1048     
1049     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1050     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1051 
1052     	if(numberOfTokenHolders == 0) {
1053     		return (0, 0, lastProcessedIndex);
1054     	}
1055 
1056     	uint256 _lastProcessedIndex = lastProcessedIndex;
1057 
1058     	uint256 gasUsed = 0;
1059 
1060     	uint256 gasLeft = gasleft();
1061 
1062     	uint256 iterations = 0;
1063     	uint256 claims = 0;
1064 
1065     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1066     		_lastProcessedIndex++;
1067 
1068     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1069     			_lastProcessedIndex = 0;
1070     		}
1071 
1072     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1073 
1074     		if(canAutoClaim(lastClaimTimes[account])) {
1075     			if(processAccount(payable(account), true)) {
1076     				claims++;
1077     			}
1078     		}
1079 
1080     		iterations++;
1081 
1082     		uint256 newGasLeft = gasleft();
1083 
1084     		if(gasLeft > newGasLeft) {
1085     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1086     		}
1087     		gasLeft = newGasLeft;
1088     	}
1089 
1090     	lastProcessedIndex = _lastProcessedIndex;
1091 
1092     	return (iterations, claims, lastProcessedIndex);
1093     }
1094 
1095     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1096         uint256 amount = _withdrawDividendOfUser(account);
1097 
1098     	if(amount > 0) {
1099     		lastClaimTimes[account] = block.timestamp;
1100             emit Claim(account, amount, automatic);
1101     		return true;
1102     	}
1103 
1104     	return false;
1105     }
1106 }
1107 
1108 contract Yashav3 is ERC20, Ownable {
1109     using SafeMath for uint256;
1110 
1111     IUniswapV2Router02 public immutable dexRouter;
1112     address public immutable lpPair;
1113 
1114     bool private swapping;
1115 
1116     DividendTracker public dividendTracker;
1117 
1118     address public operationsWallet;
1119     
1120     uint256 public maxTransactionAmount;
1121     uint256 public swapTokensAtAmount;
1122     uint256 public maxWallet;
1123     
1124     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1125     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1126     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1127     
1128     bool public limitsInEffect = true;
1129     bool public tradingActive = false;
1130     bool public swapEnabled = false;
1131     
1132      // Anti-bot and anti-whale mappings and variables
1133     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1134     bool public transferDelayEnabled = true;
1135     
1136     uint256 public constant feeDivisor = 1000;
1137 
1138     uint256 public totalSellFees;
1139     uint256 public rewardsSellFee;
1140     uint256 public operationsSellFee;
1141     uint256 public liquiditySellFee;
1142     
1143     uint256 public totalBuyFees;
1144     uint256 public rewardsBuyFee;
1145     uint256 public operationsBuyFee;
1146     uint256 public liquidityBuyFee;
1147     
1148     uint256 public tokensForRewards;
1149     uint256 public tokensForOperations;
1150     uint256 public tokensForLiquidity;
1151     
1152     uint256 public gasForProcessing = 0;
1153 
1154     uint256 public lpWithdrawRequestTimestamp;
1155     uint256 public lpWithdrawRequestDuration = 3 days;
1156     bool public lpWithdrawRequestPending;
1157     uint256 public lpPercToWithDraw;
1158 
1159     uint256 public percentForLPBurn = 100; // 100 = 1%
1160     bool public lpBurnEnabled = true;
1161     uint256 public lpBurnFrequency = 3600 seconds;
1162     uint256 public lastLpBurnTime;
1163     
1164     uint256 public manualBurnFrequency = 60 seconds;
1165     uint256 public lastManualLpBurnTime;
1166 
1167     /******************/
1168 
1169     // exlcude from fees and max transaction amount
1170     mapping (address => bool) private _isExcludedFromFees;
1171 
1172     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1173 
1174     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1175     // could be subject to a maximum transfer amount
1176     mapping (address => bool) public automatedMarketMakerPairs;
1177 
1178     event ExcludeFromFees(address indexed account, bool isExcluded);
1179     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1180     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1181 
1182     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1183 
1184     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1185 
1186     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1187 
1188     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1189     
1190     event SwapAndLiquify(
1191         uint256 tokensSwapped,
1192         uint256 ethReceived,
1193         uint256 tokensIntoLiqudity
1194     );
1195 
1196     event SendDividends(
1197     	uint256 tokensSwapped,
1198     	uint256 amount
1199     );
1200 
1201     event ProcessedDividendTracker(
1202     	uint256 iterations,
1203     	uint256 claims,
1204         uint256 lastProcessedIndex,
1205     	bool indexed automatic,
1206     	uint256 gas,
1207     	address indexed processor
1208     );
1209 
1210     event AutoNukeLP(uint256 amount);
1211     
1212     event ManualNukeLP(uint256 amount);
1213 
1214     event RequestedLPWithdraw();
1215     
1216     event WithdrewLPForMigration();
1217 
1218     event CanceledLpWithdrawRequest();
1219 
1220     constructor() ERC20("YASHA", "YASHA") {
1221 
1222         uint256 totalSupply = 100 * 1e9 * 1e18;
1223         
1224         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
1225         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
1226         maxWallet = totalSupply * 1 / 100; // 1% Max wallet
1227 
1228         rewardsBuyFee = 50;
1229         operationsBuyFee = 20;
1230         liquidityBuyFee = 20;
1231         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1232         
1233         rewardsSellFee = 50;
1234         operationsSellFee = 20;
1235         liquiditySellFee = 20;
1236         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1237 
1238     	dividendTracker = new DividendTracker();
1239     	
1240     	operationsWallet = address(msg.sender); // set as operations wallet
1241 
1242     	IUniswapV2Router02 _dexRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1243     	
1244          // Create a uniswap pair for this new token
1245         address _lpPair = IUniswapV2Factory(_dexRouter.factory())
1246             .createPair(address(this), _dexRouter.WETH());
1247 
1248         dexRouter = _dexRouter;
1249         lpPair = _lpPair;
1250 
1251         _setAutomatedMarketMakerPair(_lpPair, true);
1252 
1253         // exclude from receiving dividends
1254         dividendTracker.excludeFromDividends(address(dividendTracker));
1255         dividendTracker.excludeFromDividends(address(this));
1256         dividendTracker.excludeFromDividends(owner());
1257         dividendTracker.excludeFromDividends(address(_dexRouter));
1258         dividendTracker.excludeFromDividends(address(0xdead));
1259         
1260         // exclude from paying fees or having max transaction amount
1261         excludeFromFees(owner(), true);
1262         excludeFromFees(address(this), true);
1263         excludeFromFees(address(0xdead), true);
1264         excludeFromMaxTransaction(owner(), true);
1265         excludeFromMaxTransaction(address(this), true);
1266         excludeFromMaxTransaction(address(dividendTracker), true);
1267         excludeFromMaxTransaction(address(_dexRouter), true);
1268         excludeFromMaxTransaction(address(0xdead), true);
1269 
1270         _createInitialSupply(address(owner()), totalSupply);
1271     }
1272 
1273     receive() external payable {
1274 
1275   	}
1276 
1277     // only use if conducting a presale
1278     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1279         excludeFromFees(_presaleAddress, true);
1280         dividendTracker.excludeFromDividends(_presaleAddress);
1281         excludeFromMaxTransaction(_presaleAddress, true);
1282     }
1283 
1284      // disable Transfer delay - cannot be reenabled
1285     function disableTransferDelay() external onlyOwner returns (bool){
1286         transferDelayEnabled = false;
1287         return true;
1288     }
1289 
1290     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1291     function excludeFromDividends(address account) external onlyOwner {
1292         dividendTracker.excludeFromDividends(account);
1293     }
1294 
1295     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1296     function includeInDividends(address account) external onlyOwner {
1297         dividendTracker.includeInDividends(account);
1298     }
1299     
1300     // once enabled, can never be turned off
1301     function enableTrading() external onlyOwner {
1302         require(!tradingActive, "Cannot re-enable trading");
1303         tradingActive = true;
1304         swapEnabled = true;
1305         tradingActiveBlock = block.number;
1306     }
1307     
1308     // only use to disable contract sales if absolutely necessary (emergency use only)
1309     function updateSwapEnabled(bool enabled) external onlyOwner(){
1310         swapEnabled = enabled;
1311     }
1312 
1313     function updateMaxAmount(uint256 newNum) external onlyOwner {
1314         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1315         maxTransactionAmount = newNum * (10**18);
1316     }
1317     
1318     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1319         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1320         maxWallet = newNum * (10**18);
1321     }
1322     
1323     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1324         operationsBuyFee = _operationsFee;
1325         rewardsBuyFee = _rewardsFee;
1326         liquidityBuyFee = _liquidityFee;
1327         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1328         require(totalBuyFees <= 300, "Must keep fees at 30% or less");
1329     }
1330     
1331     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1332         operationsSellFee = _operationsFee;
1333         rewardsSellFee = _rewardsFee;
1334         liquiditySellFee = _liquidityFee;
1335         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1336         require(totalSellFees <= 300, "Must keep fees at 30% or less");
1337     }
1338 
1339     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1340         _isExcludedMaxTransactionAmount[updAds] = isEx;
1341         emit ExcludedMaxTransactionAmount(updAds, isEx);
1342     }
1343 
1344     function excludeFromFees(address account, bool excluded) public onlyOwner {
1345         _isExcludedFromFees[account] = excluded;
1346 
1347         emit ExcludeFromFees(account, excluded);
1348     }
1349 
1350     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1351         for(uint256 i = 0; i < accounts.length; i++) {
1352             _isExcludedFromFees[accounts[i]] = excluded;
1353         }
1354 
1355         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1356     }
1357 
1358     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1359         require(pair != lpPair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1360 
1361         _setAutomatedMarketMakerPair(pair, value);
1362     }
1363 
1364     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1365         automatedMarketMakerPairs[pair] = value;
1366 
1367         excludeFromMaxTransaction(pair, value);
1368         
1369         if(value) {
1370             dividendTracker.excludeFromDividends(pair);
1371         }
1372 
1373         emit SetAutomatedMarketMakerPair(pair, value);
1374     }
1375 
1376     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1377         require(newOperationsWallet != address(0), "may not set to 0 address");
1378         excludeFromFees(newOperationsWallet, true);
1379         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1380         operationsWallet = newOperationsWallet;
1381     }
1382 
1383     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1384         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1385         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1386         emit GasForProcessingUpdated(newValue, gasForProcessing);
1387         gasForProcessing = newValue;
1388     }
1389 
1390     function updateClaimWait(uint256 claimWait) external onlyOwner {
1391         dividendTracker.updateClaimWait(claimWait);
1392     }
1393 
1394     function getClaimWait() external view returns(uint256) {
1395         return dividendTracker.claimWait();
1396     }
1397 
1398     function getTotalDividendsDistributed() external view returns (uint256) {
1399         return dividendTracker.totalDividendsDistributed();
1400     }
1401 
1402     function isExcludedFromFees(address account) external view returns(bool) {
1403         return _isExcludedFromFees[account];
1404     }
1405 
1406     function withdrawableDividendOf(address account) external view returns(uint256) {
1407     	return dividendTracker.withdrawableDividendOf(account);
1408   	}
1409 
1410 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1411 		return dividendTracker.holderBalance(account);
1412 	}
1413 
1414     function getAccountDividendsInfo(address account)
1415         external view returns (
1416             address,
1417             int256,
1418             int256,
1419             uint256,
1420             uint256,
1421             uint256,
1422             uint256,
1423             uint256) {
1424         return dividendTracker.getAccount(account);
1425     }
1426 
1427 	function getAccountDividendsInfoAtIndex(uint256 index)
1428         external view returns (
1429             address,
1430             int256,
1431             int256,
1432             uint256,
1433             uint256,
1434             uint256,
1435             uint256,
1436             uint256) {
1437     	return dividendTracker.getAccountAtIndex(index);
1438     }
1439 
1440 	function processDividendTracker(uint256 gas) external {
1441 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1442 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1443     }
1444 
1445     function claim() external {
1446 		dividendTracker.processAccount(payable(msg.sender), false);
1447     }
1448 
1449     function getLastProcessedIndex() external view returns(uint256) {
1450     	return dividendTracker.getLastProcessedIndex();
1451     }
1452 
1453     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1454         return dividendTracker.getNumberOfTokenHolders();
1455     }
1456     
1457     function getNumberOfDividends() external view returns(uint256) {
1458         return dividendTracker.totalBalance();
1459     }
1460     
1461     // remove limits after token is stable
1462     function removeLimits() external onlyOwner returns (bool){
1463         limitsInEffect = false;
1464         transferDelayEnabled = false;
1465         return true;
1466     }
1467     
1468     function _transfer(
1469         address from,
1470         address to,
1471         uint256 amount
1472     ) internal override {
1473         require(from != address(0), "ERC20: transfer from the zero address");
1474         require(to != address(0), "ERC20: transfer to the zero address");
1475         
1476          if(amount == 0) {
1477             super._transfer(from, to, 0);
1478             return;
1479         }
1480         
1481         if(!tradingActive){
1482             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1483         }
1484         
1485         if(limitsInEffect){
1486             if (
1487                 from != owner() &&
1488                 to != owner() &&
1489                 to != address(0) &&
1490                 to != address(0xdead) &&
1491                 !swapping
1492             ){
1493 
1494                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1495                 if (transferDelayEnabled){
1496                     if (to != address(dexRouter) && to != address(lpPair)){
1497                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1498                         _holderLastTransferTimestamp[tx.origin] = block.number;
1499                     }
1500                 }
1501                 
1502                 //when buy
1503                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1504                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1505                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1506                 } 
1507                 //when sell
1508                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1509                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1510                 }
1511                 else if(!_isExcludedMaxTransactionAmount[to]) {
1512                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1513                 }
1514             }
1515         }
1516 
1517 		uint256 contractTokenBalance = balanceOf(address(this));
1518         
1519         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1520 
1521         if( 
1522             canSwap &&
1523             swapEnabled &&
1524             !swapping &&
1525             !automatedMarketMakerPairs[from] &&
1526             !_isExcludedFromFees[from] &&
1527             !_isExcludedFromFees[to]
1528         ) {
1529             swapping = true;
1530             swapBack();
1531             swapping = false;
1532         }
1533 
1534         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1535             autoBurnLiquidityPairTokens();
1536         }
1537 
1538         bool takeFee = !swapping;
1539 
1540         // if any account belongs to _isExcludedFromFee account then remove the fee
1541         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1542             takeFee = false;
1543         }
1544         
1545         uint256 fees = 0;
1546         
1547         // no taxes on transfers (non buys/sells)
1548         if(takeFee){
1549             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1550                 fees = amount.mul(99).div(100);
1551                 tokensForLiquidity += fees * 33 / 99;
1552                 tokensForRewards += fees * 33 / 99;
1553                 tokensForOperations += fees * 33 / 99;
1554             }
1555 
1556             // on sell
1557             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1558                 fees = amount.mul(totalSellFees).div(feeDivisor);
1559                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1560                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1561                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1562             }
1563             
1564             // on buy
1565             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1566         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1567         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1568                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1569                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1570             }
1571 
1572             if(fees > 0){    
1573                 super._transfer(from, address(this), fees);
1574             }
1575         	
1576         	amount -= fees;
1577         }
1578 
1579         super._transfer(from, to, amount);
1580 
1581         dividendTracker.setBalance(payable(from), balanceOf(from));
1582         dividendTracker.setBalance(payable(to), balanceOf(to));
1583 
1584         if(!swapping && gasForProcessing > 0) {
1585 	    	uint256 gas = gasForProcessing;
1586 
1587 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1588 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1589 	    	}
1590 	    	catch {}
1591         }
1592     }
1593     
1594     function swapTokensForEth(uint256 tokenAmount) private {
1595 
1596         // generate the uniswap pair path of token -> weth
1597         address[] memory path = new address[](2);
1598         path[0] = address(this);
1599         path[1] = dexRouter.WETH();
1600 
1601         _approve(address(this), address(dexRouter), tokenAmount);
1602 
1603         // make the swap
1604         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1605             tokenAmount,
1606             0, // accept any amount of ETH
1607             path,
1608             address(this),
1609             block.timestamp
1610         );
1611         
1612     }
1613     
1614     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1615         // approve token transfer to cover all possible scenarios
1616         _approve(address(this), address(dexRouter), tokenAmount);
1617 
1618         // add the liquidity
1619         dexRouter.addLiquidityETH{value: ethAmount}(
1620             address(this),
1621             tokenAmount,
1622             0, // slippage is unavoidable
1623             0, // slippage is unavoidable
1624             address(this),
1625             block.timestamp
1626         );
1627 
1628     }
1629     
1630     function swapBack() private {
1631         uint256 contractBalance = balanceOf(address(this));
1632         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1633         
1634         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1635         
1636         // Halve the amount of liquidity tokens
1637         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1638         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1639         
1640         uint256 initialETHBalance = address(this).balance;
1641 
1642         swapTokensForEth(amountToSwapForETH); 
1643         
1644         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1645         
1646         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1647         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1648         
1649         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1650         
1651         tokensForLiquidity = 0;
1652         tokensForOperations = 0;
1653         tokensForRewards = 0;
1654         
1655         if(liquidityTokens > 0 && ethForLiquidity > 0){
1656             addLiquidity(liquidityTokens, ethForLiquidity);
1657             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1658         }
1659         
1660         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1661 
1662         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1663     }
1664 
1665     function withdrawStuckEth() external onlyOwner {
1666         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1667         require(success, "failed to withdraw");
1668     }
1669 
1670     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1671         require(_frequencyInSeconds >= 100, "cannot set buyback more often than every 10 minutes");
1672         require(_percent <= 2000 && _percent >= 0, "Must set auto LP burn percent between 1% and 20%");
1673         lpBurnFrequency = _frequencyInSeconds;
1674         percentForLPBurn = _percent;
1675         lpBurnEnabled = _Enabled;
1676     }
1677 
1678      function autoBurnLiquidityPairTokens() internal{
1679         
1680         lastLpBurnTime = block.timestamp;
1681         
1682         // get balance of liquidity pair
1683         uint256 liquidityPairBalance = this.balanceOf(lpPair);
1684         
1685         // calculate amount to burn
1686         uint256 amountToBurn = liquidityPairBalance * percentForLPBurn / 10000;
1687         
1688         if (amountToBurn > 0){
1689             super._transfer(lpPair, address(0xdead), amountToBurn);
1690         }
1691         
1692         //sync price since this is not in a swap transaction!
1693         IDexPair pair = IDexPair(lpPair);
1694         pair.sync();
1695         emit AutoNukeLP(amountToBurn);
1696     }
1697 
1698     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {
1699         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1700         require(percent <= 2000, "May not nuke more than 20% of tokens in LP");
1701         lastManualLpBurnTime = block.timestamp;
1702         
1703         // get balance of liquidity pair
1704         uint256 liquidityPairBalance = this.balanceOf(lpPair);
1705         
1706         // calculate amount to burn
1707         uint256 amountToBurn = liquidityPairBalance * percent / 10000;
1708         
1709         if (amountToBurn > 0){
1710             super._transfer(lpPair, address(0xdead), amountToBurn);
1711         }
1712         
1713         //sync price since this is not in a swap transaction!
1714         IDexPair pair = IDexPair(lpPair);
1715         pair.sync();
1716         emit ManualNukeLP(amountToBurn);
1717     }
1718 
1719     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1720         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1721         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1722         lpWithdrawRequestTimestamp = block.timestamp;
1723         lpWithdrawRequestPending = true;
1724         lpPercToWithDraw = percToWithdraw;
1725         emit RequestedLPWithdraw();
1726     }
1727 
1728     function nextAvailableLpWithdrawDate() public view returns (uint256){
1729         if(lpWithdrawRequestPending){
1730             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1731         }
1732         else {
1733             return 0;  // 0 means no open requests
1734         }
1735     }
1736 
1737     function withdrawRequestedLP() external onlyOwner {
1738         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1739         lpWithdrawRequestTimestamp = 0;
1740         lpWithdrawRequestPending = false;
1741 
1742         uint256 amtToWithdraw = IERC20(address(lpPair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1743         
1744         lpPercToWithDraw = 0;
1745 
1746         IERC20(lpPair).transfer(msg.sender, amtToWithdraw);
1747     }
1748 
1749     function cancelLPWithdrawRequest() external onlyOwner {
1750         lpWithdrawRequestPending = false;
1751         lpPercToWithDraw = 0;
1752         lpWithdrawRequestTimestamp = 0;
1753         emit CanceledLpWithdrawRequest();
1754     }
1755 }