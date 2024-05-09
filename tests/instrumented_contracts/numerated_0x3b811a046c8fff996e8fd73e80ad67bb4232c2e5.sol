1 /*
2 https://t.me/JuicerPortal
3 https://twitter.com/JUICERTOKEN
4 https://www.juicer-token.com/
5 */
6 // SPDX-License-Identifier: MIT                                                                             
7 pragma solidity 0.8.13;
8 
9 abstract contract Context { 
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
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
239   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
240 
241   /// @notice View the amount of dividend in wei that an address has withdrawn.
242   /// @param _owner The address of a token holder.
243   /// @return The amount of dividend in wei that `_owner` has withdrawn.
244   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
245 
246   /// @notice View the amount of dividend in wei that an address has earned in total.
247   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
248   /// @param _owner The address of a token holder.
249   /// @return The amount of dividend in wei that `_owner` has earned in total.
250   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
251 }
252 
253 interface DividendPayingTokenInterface {
254   /// @notice View the amount of dividend in wei that an address can withdraw.
255   /// @param _owner The address of a token holder.
256   /// @return The amount of dividend in wei that `_owner` can withdraw.
257   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
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
268   function withdrawDividend(address _rewardToken) external;
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
698   mapping(address => uint256) internal magnifiedDividendPerShare;
699   address[] public rewardTokens;
700   address public nextRewardToken;
701   uint256 public rewardTokenCounter;
702   
703   IUniswapV2Router02 public immutable uniswapV2Router;
704   
705   
706   // About dividendCorrection:
707   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
708   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
709   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
710   //   `dividendOf(_user)` should not be changed,
711   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
712   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
713   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
714   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
715   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
716   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
717   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
718   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
719   
720   mapping (address => uint256) public holderBalance;
721   uint256 public totalBalance;
722 
723   mapping(address => uint256) public totalDividendsDistributed;
724   
725   constructor(){
726       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
727       uniswapV2Router = _uniswapV2Router; 
728       
729       // Mainnet
730 
731       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC - 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
732       
733       nextRewardToken = rewardTokens[0];
734   }
735 
736   
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
994     // Check to see if I really made this contract or if it is a clone!
995 
996     function getAccount(address _account, address _rewardToken)
997         public view returns (
998             address account,
999             int256 index,
1000             int256 iterationsUntilProcessed,
1001             uint256 withdrawableDividends,
1002             uint256 totalDividends,
1003             uint256 lastClaimTime,
1004             uint256 nextClaimTime,
1005             uint256 secondsUntilAutoClaimAvailable) {
1006         account = _account;
1007 
1008         index = getIndexOfKey(account);
1009 
1010         iterationsUntilProcessed = -1;
1011 
1012         if(index >= 0) {
1013             if(uint256(index) > lastProcessedIndex) {
1014                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1015             }
1016             else {
1017                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1018                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1019                                                         0;
1020 
1021 
1022                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1023             }
1024         }
1025 
1026 
1027         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1028         totalDividends = accumulativeDividendOf(account, _rewardToken);
1029 
1030         lastClaimTime = lastClaimTimes[account];
1031 
1032         nextClaimTime = lastClaimTime > 0 ?
1033                                     lastClaimTime.add(claimWait) :
1034                                     0;
1035 
1036         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1037                                                     nextClaimTime.sub(block.timestamp) :
1038                                                     0;
1039     }
1040 
1041     function getAccountAtIndex(uint256 index, address _rewardToken)
1042         external view returns (
1043             address,
1044             int256,
1045             int256,
1046             uint256,
1047             uint256,
1048             uint256,
1049             uint256,
1050             uint256) {
1051     	if(index >= size()) {
1052             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1053         }
1054 
1055         address account = getKeyAtIndex(index);
1056 
1057         return getAccount(account, _rewardToken);
1058     }
1059 
1060     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1061     	if(lastClaimTime > block.timestamp)  {
1062     		return false;
1063     	}
1064 
1065     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1066     }
1067 
1068     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1069     	if(excludedFromDividends[account]) {
1070     		return;
1071     	}
1072 
1073     	if(newBalance >= minimumTokenBalanceForDividends) {
1074             _setBalance(account, newBalance);
1075     		set(account, newBalance);
1076     	}
1077     	else {
1078             _setBalance(account, 0);
1079     		remove(account);
1080     	}
1081 
1082     	processAccount(account, true);
1083     }
1084     
1085     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1086     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1087 
1088     	if(numberOfTokenHolders == 0) {
1089     		return (0, 0, lastProcessedIndex);
1090     	}
1091 
1092     	uint256 _lastProcessedIndex = lastProcessedIndex;
1093 
1094     	uint256 gasUsed = 0;
1095 
1096     	uint256 gasLeft = gasleft();
1097 
1098     	uint256 iterations = 0;
1099     	uint256 claims = 0;
1100 
1101     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1102     		_lastProcessedIndex++;
1103 
1104     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1105     			_lastProcessedIndex = 0;
1106     		}
1107 
1108     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1109 
1110     		if(canAutoClaim(lastClaimTimes[account])) {
1111     			if(processAccount(payable(account), true)) {
1112     				claims++;
1113     			}
1114     		}
1115 
1116     		iterations++;
1117 
1118     		uint256 newGasLeft = gasleft();
1119 
1120     		if(gasLeft > newGasLeft) {
1121     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1122     		}
1123     		gasLeft = newGasLeft;
1124     	}
1125 
1126     	lastProcessedIndex = _lastProcessedIndex;
1127 
1128     	return (iterations, claims, lastProcessedIndex);
1129     }
1130 
1131     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1132         uint256 amount;
1133         bool paid;
1134         for (uint256 i; i < rewardTokens.length; i++){
1135             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1136             if(amount > 0) {
1137         		lastClaimTimes[account] = block.timestamp;
1138                 emit Claim(account, amount, automatic);
1139                 paid = true;
1140     	    }
1141         }
1142         return paid;
1143     }
1144 }
1145 
1146 contract JUICER is ERC20, Ownable {
1147     using SafeMath for uint256;
1148 
1149     IUniswapV2Router02 public immutable uniswapV2Router;
1150     address public immutable uniswapV2Pair;
1151 
1152     bool private swapping;
1153 
1154     DividendTracker public dividendTracker;
1155 
1156     address public operationsWallet;
1157     
1158     uint256 public maxTransactionAmount;
1159     uint256 public swapTokensAtAmount;
1160     uint256 public maxWallet;
1161     
1162     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1163     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1164     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1165     
1166     bool public limitsInEffect = true;
1167     bool public tradingActive = false;
1168     bool public swapEnabled = false;
1169     
1170      // Anti-bot and anti-whale mappings and variables
1171     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1172     bool public transferDelayEnabled = true;
1173     
1174     uint256 public constant feeDivisor = 1000;
1175 
1176     uint256 public totalSellFees;
1177     uint256 public rewardsSellFee;
1178     uint256 public operationsSellFee;
1179     uint256 public liquiditySellFee;
1180     
1181     uint256 public totalBuyFees;
1182     uint256 public rewardsBuyFee;
1183     uint256 public operationsBuyFee;
1184     uint256 public liquidityBuyFee;
1185     
1186     uint256 public tokensForRewards;
1187     uint256 public tokensForOperations;
1188     uint256 public tokensForLiquidity;
1189     
1190     uint256 public gasForProcessing = 0;
1191 
1192     uint256 public lpWithdrawRequestTimestamp;
1193     uint256 public lpWithdrawRequestDuration = 3 days;
1194     bool public lpWithdrawRequestPending;
1195     uint256 public lpPercToWithDraw;
1196 
1197     /******************/
1198 
1199     // exlcude from fees and max transaction amount
1200     mapping (address => bool) private _isExcludedFromFees;
1201 
1202     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1203 
1204     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1205     // could be subject to a maximum transfer amount
1206     mapping (address => bool) public automatedMarketMakerPairs;
1207 
1208     event ExcludeFromFees(address indexed account, bool isExcluded);
1209     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1210     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1211 
1212     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1213 
1214     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1215 
1216     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1217 
1218     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1219     
1220     event SwapAndLiquify(
1221         uint256 tokensSwapped,
1222         uint256 ethReceived,
1223         uint256 tokensIntoLiqudity
1224     );
1225 
1226     event SendDividends(
1227     	uint256 tokensSwapped,
1228     	uint256 amount
1229     );
1230 
1231     event ProcessedDividendTracker(
1232     	uint256 iterations,
1233     	uint256 claims,
1234         uint256 lastProcessedIndex,
1235     	bool indexed automatic,
1236     	uint256 gas,
1237     	address indexed processor
1238     );
1239 
1240     event RequestedLPWithdraw();
1241     
1242     event WithdrewLPForMigration();
1243 
1244     event CanceledLpWithdrawRequest();
1245 
1246     constructor() ERC20("JUICER", "JUICER") {
1247 
1248         uint256 totalSupply = 100 * 1e6 * 1e18;
1249         
1250         maxTransactionAmount = totalSupply * 10 / 1000; // 1.0% maxTransactionAmountTxn
1251         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
1252         maxWallet = totalSupply * 10 / 1000; // 1.0% Max wallet
1253 
1254         rewardsBuyFee = 20;
1255         operationsBuyFee = 70;
1256         liquidityBuyFee = 10;
1257         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1258         
1259         rewardsSellFee = 20;
1260         operationsSellFee = 170;
1261         liquiditySellFee = 10;
1262         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1263 
1264     	dividendTracker = new DividendTracker();
1265     	
1266     	operationsWallet = address(msg.sender); // set as operations wallet
1267 
1268     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1269     	
1270          // Create a uniswap pair for this new token
1271         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1272             .createPair(address(this), _uniswapV2Router.WETH());
1273 
1274         uniswapV2Router = _uniswapV2Router;
1275         uniswapV2Pair = _uniswapV2Pair;
1276 
1277         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1278 
1279         // exclude from receiving dividends
1280         dividendTracker.excludeFromDividends(address(dividendTracker));
1281         dividendTracker.excludeFromDividends(address(this));
1282         dividendTracker.excludeFromDividends(owner());
1283         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1284         dividendTracker.excludeFromDividends(address(0xdead));
1285         
1286         // exclude from paying fees or having max transaction amount
1287         excludeFromFees(owner(), true);
1288         excludeFromFees(address(this), true);
1289         excludeFromFees(address(0xdead), true);
1290         excludeFromMaxTransaction(owner(), true);
1291         excludeFromMaxTransaction(address(this), true);
1292         excludeFromMaxTransaction(address(dividendTracker), true);
1293         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1294         excludeFromMaxTransaction(address(0xdead), true);
1295 
1296         _createInitialSupply(address(owner()), totalSupply);
1297     }
1298 
1299     receive() external payable {
1300 
1301   	}
1302 
1303     // only use if conducting a presale
1304     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1305         excludeFromFees(_presaleAddress, true);
1306         dividendTracker.excludeFromDividends(_presaleAddress);
1307         excludeFromMaxTransaction(_presaleAddress, true);
1308     }
1309 
1310      // disable Transfer delay - cannot be reenabled
1311     function disableTransferDelay() external onlyOwner returns (bool){
1312         transferDelayEnabled = false;
1313         return true;
1314     }
1315 
1316     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1317     function excludeFromDividends(address account) external onlyOwner {
1318         dividendTracker.excludeFromDividends(account);
1319     }
1320 
1321     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1322     function includeInDividends(address account) external onlyOwner {
1323         dividendTracker.includeInDividends(account);
1324     }
1325     
1326     // once enabled, can never be turned off
1327     function enableTrading() external onlyOwner {
1328         require(!tradingActive, "Cannot re-enable trading");
1329         tradingActive = true;
1330         swapEnabled = true;
1331         tradingActiveBlock = block.number;
1332     }
1333     
1334     // only use to disable contract sales if absolutely necessary (emergency use only)
1335     function updateSwapEnabled(bool enabled) external onlyOwner(){
1336         swapEnabled = enabled;
1337     }
1338 
1339     function updateMaxAmount(uint256 newNum) external onlyOwner {
1340         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1341         maxTransactionAmount = newNum * (10**18);
1342     }
1343     
1344     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1345         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1346         maxWallet = newNum * (10**18);
1347     }
1348     
1349     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1350         operationsBuyFee = _operationsFee;
1351         rewardsBuyFee = _rewardsFee;
1352         liquidityBuyFee = _liquidityFee;
1353         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1354         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1355     }
1356     
1357     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1358         operationsSellFee = _operationsFee;
1359         rewardsSellFee = _rewardsFee;
1360         liquiditySellFee = _liquidityFee;
1361         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1362         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1363     }
1364 
1365     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1366         _isExcludedMaxTransactionAmount[updAds] = isEx;
1367         emit ExcludedMaxTransactionAmount(updAds, isEx);
1368     }
1369 
1370     function excludeFromFees(address account, bool excluded) public onlyOwner {
1371         _isExcludedFromFees[account] = excluded;
1372 
1373         emit ExcludeFromFees(account, excluded);
1374     }
1375 
1376     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1377         for(uint256 i = 0; i < accounts.length; i++) {
1378             _isExcludedFromFees[accounts[i]] = excluded;
1379         }
1380 
1381         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1382     }
1383 
1384     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1385         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1386 
1387         _setAutomatedMarketMakerPair(pair, value);
1388     }
1389 
1390     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1391         automatedMarketMakerPairs[pair] = value;
1392 
1393         excludeFromMaxTransaction(pair, value);
1394         
1395         if(value) {
1396             dividendTracker.excludeFromDividends(pair);
1397         }
1398 
1399         emit SetAutomatedMarketMakerPair(pair, value);
1400     }
1401 
1402     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1403         require(newOperationsWallet != address(0), "may not set to 0 address");
1404         excludeFromFees(newOperationsWallet, true);
1405         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1406         operationsWallet = newOperationsWallet;
1407     }
1408 
1409     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1410         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1411         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1412         emit GasForProcessingUpdated(newValue, gasForProcessing);
1413         gasForProcessing = newValue;
1414     }
1415 
1416     function updateClaimWait(uint256 claimWait) external onlyOwner {
1417         dividendTracker.updateClaimWait(claimWait);
1418     }
1419 
1420     function getClaimWait() external view returns(uint256) {
1421         return dividendTracker.claimWait();
1422     }
1423 
1424     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1425         return dividendTracker.totalDividendsDistributed(rewardToken);
1426     }
1427 
1428     function isExcludedFromFees(address account) external view returns(bool) {
1429         return _isExcludedFromFees[account];
1430     }
1431 
1432     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1433     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1434   	}
1435 
1436 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1437 		return dividendTracker.holderBalance(account);
1438 	}
1439 
1440     function getAccountDividendsInfo(address account, address rewardToken)
1441         external view returns (
1442             address,
1443             int256,
1444             int256,
1445             uint256,
1446             uint256,
1447             uint256,
1448             uint256,
1449             uint256) {
1450         return dividendTracker.getAccount(account, rewardToken);
1451     }
1452 
1453 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1454         external view returns (
1455             address,
1456             int256,
1457             int256,
1458             uint256,
1459             uint256,
1460             uint256,
1461             uint256,
1462             uint256) {
1463     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1464     }
1465 
1466 	function processDividendTracker(uint256 gas) external {
1467 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1468 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1469     }
1470 
1471     function claim() external {
1472 		dividendTracker.processAccount(payable(msg.sender), false);
1473     }
1474 
1475     function getLastProcessedIndex() external view returns(uint256) {
1476     	return dividendTracker.getLastProcessedIndex();
1477     }
1478 
1479     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1480         return dividendTracker.getNumberOfTokenHolders();
1481     }
1482     
1483     function getNumberOfDividends() external view returns(uint256) {
1484         return dividendTracker.totalBalance();
1485     }
1486     
1487     // remove limits after token is stable
1488     function removeLimits() external onlyOwner returns (bool){
1489         limitsInEffect = false;
1490         transferDelayEnabled = false;
1491         return true;
1492     }
1493     
1494     function _transfer(
1495         address from,
1496         address to,
1497         uint256 amount
1498     ) internal override {
1499         require(from != address(0), "ERC20: transfer from the zero address");
1500         require(to != address(0), "ERC20: transfer to the zero address");
1501         
1502          if(amount == 0) {
1503             super._transfer(from, to, 0);
1504             return;
1505         }
1506         
1507         if(!tradingActive){
1508             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1509         }
1510         
1511         if(limitsInEffect){
1512             if (
1513                 from != owner() &&
1514                 to != owner() &&
1515                 to != address(0) &&
1516                 to != address(0xdead) &&
1517                 !swapping
1518             ){
1519 
1520                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1521                 if (transferDelayEnabled){
1522                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1523                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1524                         _holderLastTransferTimestamp[tx.origin] = block.number;
1525                     }
1526                 }
1527                 
1528                 //when buy
1529                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1530                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1531                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1532                 } 
1533                 //when sell
1534                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1535                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1536                 }
1537                 else if(!_isExcludedMaxTransactionAmount[to]) {
1538                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1539                 }
1540             }
1541         }
1542 
1543 		uint256 contractTokenBalance = balanceOf(address(this));
1544         
1545         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1546 
1547         if( 
1548             canSwap &&
1549             swapEnabled &&
1550             !swapping &&
1551             !automatedMarketMakerPairs[from] &&
1552             !_isExcludedFromFees[from] &&
1553             !_isExcludedFromFees[to]
1554         ) {
1555             swapping = true;
1556             swapBack();
1557             swapping = false;
1558         }
1559 
1560         bool takeFee = !swapping;
1561 
1562         // if any account belongs to _isExcludedFromFee account then remove the fee
1563         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1564             takeFee = false;
1565         }
1566         
1567         uint256 fees = 0;
1568         
1569         // no taxes on transfers (non buys/sells)
1570         if(takeFee){
1571             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1572                 fees = amount.mul(99).div(100);
1573                 tokensForLiquidity += fees * 33 / 99;
1574                 tokensForRewards += fees * 33 / 99;
1575                 tokensForOperations += fees * 33 / 99;
1576             }
1577 
1578             // on sell
1579             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1580                 fees = amount.mul(totalSellFees).div(feeDivisor);
1581                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1582                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1583                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1584             }
1585             
1586             // on buy
1587             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1588         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1589         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1590                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1591                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1592             }
1593 
1594             if(fees > 0){    
1595                 super._transfer(from, address(this), fees);
1596             }
1597         	
1598         	amount -= fees;
1599         }
1600 
1601         super._transfer(from, to, amount);
1602 
1603         dividendTracker.setBalance(payable(from), balanceOf(from));
1604         dividendTracker.setBalance(payable(to), balanceOf(to));
1605 
1606         if(!swapping && gasForProcessing > 0) {
1607 	    	uint256 gas = gasForProcessing;
1608 
1609 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1610 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1611 	    	}
1612 	    	catch {}
1613         }
1614     }
1615     
1616     function swapTokensForEth(uint256 tokenAmount) private {
1617 
1618         // generate the uniswap pair path of token -> weth
1619         address[] memory path = new address[](2);
1620         path[0] = address(this);
1621         path[1] = uniswapV2Router.WETH();
1622 
1623         _approve(address(this), address(uniswapV2Router), tokenAmount);
1624 
1625         // make the swap
1626         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1627             tokenAmount,
1628             0, // accept any amount of ETH
1629             path,
1630             address(this),
1631             block.timestamp
1632         );
1633         
1634     }
1635     
1636     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1637         // approve token transfer to cover all possible scenarios
1638         _approve(address(this), address(uniswapV2Router), tokenAmount);
1639 
1640         // add the liquidity
1641         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1642             address(this),
1643             tokenAmount,
1644             0, // slippage is unavoidable
1645             0, // slippage is unavoidable
1646             address(0xdead),
1647             block.timestamp
1648         );
1649 
1650     }
1651     
1652     function swapBack() private {
1653         uint256 contractBalance = balanceOf(address(this));
1654         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1655         
1656         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1657         
1658         // Halve the amount of liquidity tokens
1659         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1660         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1661         
1662         uint256 initialETHBalance = address(this).balance;
1663 
1664         swapTokensForEth(amountToSwapForETH); 
1665         
1666         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1667         
1668         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1669         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1670         
1671         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1672         
1673         tokensForLiquidity = 0;
1674         tokensForOperations = 0;
1675         tokensForRewards = 0;
1676         
1677         
1678         
1679         if(liquidityTokens > 0 && ethForLiquidity > 0){
1680             addLiquidity(liquidityTokens, ethForLiquidity);
1681             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1682         }
1683         
1684         // call twice to force buy of both reward tokens.
1685         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1686 
1687         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1688     }
1689 
1690     function withdrawStuckEth() external onlyOwner {
1691         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1692         require(success, "failed to withdraw");
1693     }
1694 
1695     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1696         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1697         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1698         lpWithdrawRequestTimestamp = block.timestamp;
1699         lpWithdrawRequestPending = true;
1700         lpPercToWithDraw = percToWithdraw;
1701         emit RequestedLPWithdraw();
1702     }
1703 
1704     function nextAvailableLpWithdrawDate() public view returns (uint256){
1705         if(lpWithdrawRequestPending){
1706             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1707         }
1708         else {
1709             return 0;  // 0 means no open requests
1710         }
1711     }
1712 
1713     function withdrawRequestedLP() external onlyOwner {
1714         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1715         lpWithdrawRequestTimestamp = 0;
1716         lpWithdrawRequestPending = false;
1717 
1718         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1719         
1720         lpPercToWithDraw = 0;
1721 
1722         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1723     }
1724 
1725     function cancelLPWithdrawRequest() external onlyOwner {
1726         lpWithdrawRequestPending = false;
1727         lpPercToWithDraw = 0;
1728         lpWithdrawRequestTimestamp = 0;
1729         emit CanceledLpWithdrawRequest();
1730     }
1731 }