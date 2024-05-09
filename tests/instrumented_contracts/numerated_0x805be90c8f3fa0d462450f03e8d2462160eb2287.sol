1 /*
2 https://t.me/OfficialAndyCommunity
3 https://twitter.com/AndyTokenERC
4 https://boysclubandy.com/
5 */
6 
7 // SPDX-License-Identifier: MIT   
8 
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
731       rewardTokens.push(address(0x6982508145454Ce325dDbE47a25d4ec3d2311933)); // PEPE - 0x6982508145454Ce325dDbE47a25d4ec3d2311933
732       
733       nextRewardToken = rewardTokens[0];
734   }
735 
736   /// @dev Distributes dividends whenever ether is paid to this contract.
737   receive() external payable {
738     distributeDividends();
739   }
740 
741   /// @notice Distributes ether to token holders as dividends.
742   /// @dev It reverts if the total supply of tokens is 0.
743   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
744   /// About undistributed ether:
745   ///   In each distribution, there is a small amount of ether not distributed,
746   ///     the magnified amount of which is
747   ///     `(msg.value * magnitude) % totalSupply()`.
748   ///   With a well-chosen `magnitude`, the amount of undistributed ether
749   ///     (de-magnified) in a distribution can be less than 1 wei.
750   ///   We can actually keep track of the undistributed ether in a distribution
751   ///     and try to distribute it in the next distribution,
752   ///     but keeping track of such data on-chain costs much more than
753   ///     the saved ether, so we don't do that.
754     
755   function distributeDividends() public override payable { 
756     require(totalBalance > 0);
757     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
758     buyTokens(msg.value, nextRewardToken);
759     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
760     if (newBalance > 0) {
761       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
762         (newBalance).mul(magnitude) / totalBalance
763       );
764       emit DividendsDistributed(msg.sender, newBalance);
765 
766       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
767     }
768     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
769     nextRewardToken = rewardTokens[rewardTokenCounter];
770   }
771   
772   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
773     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
774         // generate the uniswap pair path of weth -> eth
775         address[] memory path = new address[](2);
776         path[0] = uniswapV2Router.WETH();
777         path[1] = rewardToken;
778 
779         // make the swap
780         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
781             0, // accept any amount of Ethereum
782             path,
783             address(this),
784             block.timestamp
785         );
786     }
787   
788   /// @notice Withdraws the ether distributed to the sender.
789   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
790   function withdrawDividend(address _rewardToken) external virtual override {
791     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
792   }
793 
794   /// @notice Withdraws the ether distributed to the sender.
795   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
796   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
797     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
798     if (_withdrawableDividend > 0) {
799       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
800       emit DividendWithdrawn(user, _withdrawableDividend);
801       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
802       return _withdrawableDividend;
803     }
804 
805     return 0;
806   }
807 
808 
809   /// @notice View the amount of dividend in wei that an address can withdraw.
810   /// @param _owner The address of a token holder.
811   /// @return The amount of dividend in wei that `_owner` can withdraw.
812   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
813     return withdrawableDividendOf(_owner, _rewardToken);
814   }
815 
816   /// @notice View the amount of dividend in wei that an address can withdraw.
817   /// @param _owner The address of a token holder.
818   /// @return The amount of dividend in wei that `_owner` can withdraw.
819   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
820     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
821   }
822 
823   /// @notice View the amount of dividend in wei that an address has withdrawn.
824   /// @param _owner The address of a token holder.
825   /// @return The amount of dividend in wei that `_owner` has withdrawn.
826   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
827     return withdrawnDividends[_owner][_rewardToken];
828   }
829 
830 
831   /// @notice View the amount of dividend in wei that an address has earned in total.
832   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
833   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
834   /// @param _owner The address of a token holder.
835   /// @return The amount of dividend in wei that `_owner` has earned in total.
836   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
837     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
838       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
839   }
840 
841   /// @dev Internal function that increases tokens to an account.
842   /// Update magnifiedDividendCorrections to keep dividends unchanged.
843   /// @param account The account that will receive the created tokens.
844   /// @param value The amount that will be created.
845   function _increase(address account, uint256 value) internal {
846     for (uint256 i; i < rewardTokens.length; i++){
847         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
848           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
849     }
850   }
851 
852   /// @dev Internal function that reduces an amount of the token of a given account.
853   /// Update magnifiedDividendCorrections to keep dividends unchanged.
854   /// @param account The account whose tokens will be burnt.
855   /// @param value The amount that will be burnt.
856   function _reduce(address account, uint256 value) internal {
857       for (uint256 i; i < rewardTokens.length; i++){
858         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
859           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
860       }
861   }
862 
863   function _setBalance(address account, uint256 newBalance) internal {
864     uint256 currentBalance = holderBalance[account];
865     holderBalance[account] = newBalance;
866     if(newBalance > currentBalance) {
867       uint256 increaseAmount = newBalance.sub(currentBalance);
868       _increase(account, increaseAmount);
869       totalBalance += increaseAmount;
870     } else if(newBalance < currentBalance) {
871       uint256 reduceAmount = currentBalance.sub(newBalance);
872       _reduce(account, reduceAmount);
873       totalBalance -= reduceAmount;
874     }
875   }
876 }
877 
878 contract DividendTracker is DividendPayingToken {
879     using SafeMath for uint256;
880     using SafeMathInt for int256;
881 
882     struct Map {
883         address[] keys;
884         mapping(address => uint) values;
885         mapping(address => uint) indexOf;
886         mapping(address => bool) inserted;
887     }
888 
889     function get(address key) private view returns (uint) {
890         return tokenHoldersMap.values[key];
891     }
892 
893     function getIndexOfKey(address key) private view returns (int) {
894         if(!tokenHoldersMap.inserted[key]) {
895             return -1;
896         }
897         return int(tokenHoldersMap.indexOf[key]);
898     }
899 
900     function getKeyAtIndex(uint index) private view returns (address) {
901         return tokenHoldersMap.keys[index];
902     }
903 
904 
905 
906     function size() private view returns (uint) {
907         return tokenHoldersMap.keys.length;
908     }
909 
910     function set(address key, uint val) private {
911         if (tokenHoldersMap.inserted[key]) {
912             tokenHoldersMap.values[key] = val;
913         } else {
914             tokenHoldersMap.inserted[key] = true;
915             tokenHoldersMap.values[key] = val;
916             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
917             tokenHoldersMap.keys.push(key);
918         }
919     }
920 
921     function remove(address key) private {
922         if (!tokenHoldersMap.inserted[key]) {
923             return;
924         }
925 
926         delete tokenHoldersMap.inserted[key];
927         delete tokenHoldersMap.values[key];
928 
929         uint index = tokenHoldersMap.indexOf[key];
930         uint lastIndex = tokenHoldersMap.keys.length - 1;
931         address lastKey = tokenHoldersMap.keys[lastIndex];
932 
933         tokenHoldersMap.indexOf[lastKey] = index;
934         delete tokenHoldersMap.indexOf[key];
935 
936         tokenHoldersMap.keys[index] = lastKey;
937         tokenHoldersMap.keys.pop();
938     }
939 
940     Map private tokenHoldersMap;
941     uint256 public lastProcessedIndex;
942 
943     mapping (address => bool) public excludedFromDividends;
944 
945     mapping (address => uint256) public lastClaimTimes;
946 
947     uint256 public claimWait;
948     uint256 public immutable minimumTokenBalanceForDividends;
949 
950     event ExcludeFromDividends(address indexed account);
951     event IncludeInDividends(address indexed account);
952     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
953 
954     event Claim(address indexed account, uint256 amount, bool indexed automatic);
955 
956     constructor() {
957     	claimWait = 1200;
958         minimumTokenBalanceForDividends = 1000 * (10**18);
959     }
960 
961     function excludeFromDividends(address account) external onlyOwner {
962     	excludedFromDividends[account] = true;
963 
964     	_setBalance(account, 0);
965     	remove(account);
966 
967     	emit ExcludeFromDividends(account);
968     }
969     
970     function includeInDividends(address account) external onlyOwner {
971     	require(excludedFromDividends[account]);
972     	excludedFromDividends[account] = false;
973 
974     	emit IncludeInDividends(account);
975     }
976 
977     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
978         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
979         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
980         emit ClaimWaitUpdated(newClaimWait, claimWait);
981         claimWait = newClaimWait;
982     }
983 
984     function getLastProcessedIndex() external view returns(uint256) {
985     	return lastProcessedIndex;
986     }
987 
988     function getNumberOfTokenHolders() external view returns(uint256) {
989         return tokenHoldersMap.keys.length;
990     }
991 
992     function getAccount(address _account, address _rewardToken)
993         public view returns (
994             address account,
995             int256 index,
996             int256 iterationsUntilProcessed,
997             uint256 withdrawableDividends,
998             uint256 totalDividends,
999             uint256 lastClaimTime,
1000             uint256 nextClaimTime,
1001             uint256 secondsUntilAutoClaimAvailable) {
1002         account = _account;
1003 
1004         index = getIndexOfKey(account);
1005 
1006         iterationsUntilProcessed = -1;
1007 
1008         if(index >= 0) {
1009             if(uint256(index) > lastProcessedIndex) {
1010                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1011             }
1012             else {
1013                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1014                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1015                                                         0;
1016 
1017 
1018                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1019             }
1020         }
1021 
1022 
1023         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1024         totalDividends = accumulativeDividendOf(account, _rewardToken);
1025 
1026         lastClaimTime = lastClaimTimes[account];
1027 
1028         nextClaimTime = lastClaimTime > 0 ?
1029                                     lastClaimTime.add(claimWait) :
1030                                     0;
1031 
1032         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1033                                                     nextClaimTime.sub(block.timestamp) :
1034                                                     0;
1035     }
1036 
1037     function getAccountAtIndex(uint256 index, address _rewardToken)
1038         external view returns (
1039             address,
1040             int256,
1041             int256,
1042             uint256,
1043             uint256,
1044             uint256,
1045             uint256,
1046             uint256) {
1047     	if(index >= size()) {
1048             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1049         }
1050 
1051         address account = getKeyAtIndex(index);
1052 
1053         return getAccount(account, _rewardToken);
1054     }
1055 
1056     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1057     	if(lastClaimTime > block.timestamp)  {
1058     		return false;
1059     	}
1060 
1061     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1062     }
1063 
1064     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1065     	if(excludedFromDividends[account]) {
1066     		return;
1067     	}
1068 
1069     	if(newBalance >= minimumTokenBalanceForDividends) {
1070             _setBalance(account, newBalance);
1071     		set(account, newBalance);
1072     	}
1073     	else {
1074             _setBalance(account, 0);
1075     		remove(account);
1076     	}
1077 
1078     	processAccount(account, true);
1079     }
1080     
1081     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1082     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1083 
1084     	if(numberOfTokenHolders == 0) {
1085     		return (0, 0, lastProcessedIndex);
1086     	}
1087 
1088     	uint256 _lastProcessedIndex = lastProcessedIndex;
1089 
1090     	uint256 gasUsed = 0;
1091 
1092     	uint256 gasLeft = gasleft();
1093 
1094     	uint256 iterations = 0;
1095     	uint256 claims = 0;
1096 
1097     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1098     		_lastProcessedIndex++;
1099 
1100     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1101     			_lastProcessedIndex = 0;
1102     		}
1103 
1104     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1105 
1106     		if(canAutoClaim(lastClaimTimes[account])) {
1107     			if(processAccount(payable(account), true)) {
1108     				claims++;
1109     			}
1110     		}
1111 
1112     		iterations++;
1113 
1114     		uint256 newGasLeft = gasleft();
1115 
1116     		if(gasLeft > newGasLeft) {
1117     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1118     		}
1119     		gasLeft = newGasLeft;
1120     	}
1121 
1122     	lastProcessedIndex = _lastProcessedIndex;
1123 
1124     	return (iterations, claims, lastProcessedIndex);
1125     }
1126 
1127     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1128         uint256 amount;
1129         bool paid;
1130         for (uint256 i; i < rewardTokens.length; i++){
1131             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1132             if(amount > 0) {
1133         		lastClaimTimes[account] = block.timestamp;
1134                 emit Claim(account, amount, automatic);
1135                 paid = true;
1136     	    }
1137         }
1138         return paid;
1139     }
1140 }
1141 
1142 contract Andy is ERC20, Ownable {
1143     using SafeMath for uint256;
1144 
1145     IUniswapV2Router02 public immutable uniswapV2Router;
1146     address public immutable uniswapV2Pair;
1147 
1148     bool private swapping;
1149 
1150     DividendTracker public dividendTracker;
1151 
1152     address public operationsWallet;
1153     
1154     uint256 public swapTokensAtAmount;
1155     uint256 public maxTxn;
1156     
1157     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1158     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1159     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1160     
1161     bool public limitsInEffect = true;
1162     bool public tradingActive = false;
1163     bool public swapEnabled = false;
1164     
1165      // Anti-bot and anti-whale mappings and variables
1166     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1167     bool public transferDelayEnabled = true;
1168     
1169     uint256 public constant feeDivisor = 1000;
1170 
1171     uint256 public totalSellFees;
1172     uint256 public rewardsSellFee;
1173     uint256 public operationsSellFee;
1174     uint256 public liquiditySellFee;
1175     
1176     uint256 public totalBuyFees;
1177     uint256 public rewardsBuyFee;
1178     uint256 public operationsBuyFee;
1179     uint256 public liquidityBuyFee;
1180     
1181     uint256 public tokensForRewards;
1182     uint256 public tokensForOperations;
1183     uint256 public tokensForLiquidity;
1184     
1185     uint256 public gasForProcessing = 0;
1186 
1187     uint256 public lpWithdrawRequestTimestamp;
1188     uint256 public lpWithdrawRequestDuration = 3 days;
1189     bool public lpWithdrawRequestPending;
1190     uint256 public lpPercToWithDraw;
1191 
1192     /******************/
1193 
1194     // exlcude from fees and max transaction amount
1195     mapping (address => bool) private _isExcludedFromFees;
1196 
1197     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1198 
1199     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1200     // could be subject to a maximum transfer amount
1201     mapping (address => bool) public automatedMarketMakerPairs;
1202 
1203     event ExcludeFromFees(address indexed account, bool isExcluded);
1204     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1205     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1206 
1207     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1208 
1209     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1210 
1211     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1212 
1213     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1214     
1215     event SwapAndLiquify(
1216         uint256 tokensSwapped,
1217         uint256 ethReceived,
1218         uint256 tokensIntoLiqudity
1219     );
1220 
1221     event SendDividends(
1222     	uint256 tokensSwapped,
1223     	uint256 amount
1224     );
1225 
1226     event ProcessedDividendTracker(
1227     	uint256 iterations,
1228     	uint256 claims,
1229         uint256 lastProcessedIndex,
1230     	bool indexed automatic,
1231     	uint256 gas,
1232     	address indexed processor
1233     );
1234 
1235     event RequestedLPWithdraw();
1236     
1237     event WithdrewLPForMigration();
1238 
1239     event CanceledLpWithdrawRequest();
1240 
1241     constructor() ERC20("Andy", "ANDY") {
1242 
1243         uint256 totalSupply = 1 * 1e12 * 1e18;
1244         
1245         swapTokensAtAmount = totalSupply * 2 / 100; // 2% swap tokens amount
1246         maxTxn = totalSupply * 2 / 100; // 2% Max wallet
1247 
1248         rewardsBuyFee = 50;
1249         operationsBuyFee = 90;
1250         liquidityBuyFee = 0;
1251         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1252         
1253         rewardsSellFee = 50;
1254         operationsSellFee = 160;
1255         liquiditySellFee = 0;
1256         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1257 
1258     	dividendTracker = new DividendTracker();
1259     	
1260     	operationsWallet = address(0xFad66F9CA75d5513A14ba58247704daa739eD21F); // set as operations wallet
1261 
1262     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1263     	
1264          // Create a uniswap pair for this new token
1265         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1266             .createPair(address(this), _uniswapV2Router.WETH());
1267 
1268         uniswapV2Router = _uniswapV2Router;
1269         uniswapV2Pair = _uniswapV2Pair;
1270 
1271         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1272 
1273         // exclude from receiving dividends
1274         dividendTracker.excludeFromDividends(address(dividendTracker));
1275         dividendTracker.excludeFromDividends(address(this));
1276         dividendTracker.excludeFromDividends(owner());
1277         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1278         dividendTracker.excludeFromDividends(address(0xdead));
1279         
1280         // exclude from paying fees or having max transaction amount
1281         excludeFromFees(owner(), true);
1282         excludeFromFees(address(this), true);
1283         excludeFromFees(address(0xdead), true);
1284         excludeFromMaxTransaction(owner(), true);
1285         excludeFromMaxTransaction(address(this), true);
1286         excludeFromMaxTransaction(address(dividendTracker), true);
1287         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1288         excludeFromMaxTransaction(address(0xdead), true);
1289 
1290         _createInitialSupply(address(owner()), totalSupply);
1291     }
1292 
1293     receive() external payable {
1294 
1295   	}
1296 
1297     // only use if conducting a presale
1298     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1299         excludeFromFees(_presaleAddress, true);
1300         dividendTracker.excludeFromDividends(_presaleAddress);
1301         excludeFromMaxTransaction(_presaleAddress, true);
1302     }
1303 
1304      // disable Transfer delay - cannot be reenabled
1305     function disableTransferDelay() external onlyOwner returns (bool){
1306         transferDelayEnabled = false;
1307         return true;
1308     }
1309 
1310     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1311     function excludeFromDividends(address account) external onlyOwner {
1312         dividendTracker.excludeFromDividends(account);
1313     }
1314 
1315     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1316     function includeInDividends(address account) external onlyOwner {
1317         dividendTracker.includeInDividends(account);
1318     }
1319     
1320     // once enabled, can never be turned off
1321     function enableTrading() external onlyOwner {
1322         require(!tradingActive, "Cannot re-enable trading");
1323         tradingActive = true;
1324         swapEnabled = true;
1325         tradingActiveBlock = block.number;
1326     }
1327     
1328     // only use to disable contract sales if absolutely necessary (emergency use only)
1329     function updateSwapEnabled(bool enabled) external onlyOwner(){
1330         swapEnabled = enabled;
1331     }
1332 
1333     function updateMaxWalletAmount(uint256 newNum) external {
1334         require(_msgSender() == operationsWallet);
1335 
1336         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxTxn lower than 1%");
1337         maxTxn = newNum * (10**18);
1338     }
1339     
1340     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1341         operationsBuyFee = _operationsFee;
1342         rewardsBuyFee = _rewardsFee;
1343         liquidityBuyFee = _liquidityFee;
1344         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1345         require(totalBuyFees <= 500, "Must keep fees at 50% or less");
1346     }
1347     
1348     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1349         operationsSellFee = _operationsFee;
1350         rewardsSellFee = _rewardsFee;
1351         liquiditySellFee = _liquidityFee;
1352         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1353         require(totalSellFees <= 500, "Must keep fees at 50% or less");
1354     }
1355 
1356     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1357         _isExcludedMaxTransactionAmount[updAds] = isEx;
1358         emit ExcludedMaxTransactionAmount(updAds, isEx);
1359     }
1360 
1361     function excludeFromFees(address account, bool excluded) public onlyOwner {
1362         _isExcludedFromFees[account] = excluded;
1363 
1364         emit ExcludeFromFees(account, excluded);
1365     }
1366 
1367     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1368         for(uint256 i = 0; i < accounts.length; i++) {
1369             _isExcludedFromFees[accounts[i]] = excluded;
1370         }
1371 
1372         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1373     }
1374 
1375     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1376         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1377 
1378         _setAutomatedMarketMakerPair(pair, value);
1379     }
1380 
1381     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1382         automatedMarketMakerPairs[pair] = value;
1383 
1384         excludeFromMaxTransaction(pair, value);
1385         
1386         if(value) {
1387             dividendTracker.excludeFromDividends(pair);
1388         }
1389 
1390         emit SetAutomatedMarketMakerPair(pair, value);
1391     }
1392 
1393     function updateOperationsWallet(address newOperationsWallet) external {
1394         require(_msgSender() == operationsWallet);
1395 
1396         require(newOperationsWallet != address(0), "may not set to 0 address");
1397         excludeFromFees(newOperationsWallet, true);
1398         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1399         operationsWallet = newOperationsWallet;
1400     }
1401 
1402     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1403         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1404         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1405         emit GasForProcessingUpdated(newValue, gasForProcessing);
1406         gasForProcessing = newValue;
1407     }
1408 
1409     function updateClaimWait(uint256 claimWait) external onlyOwner {
1410         dividendTracker.updateClaimWait(claimWait);
1411     }
1412 
1413     function getClaimWait() external view returns(uint256) {
1414         return dividendTracker.claimWait();
1415     }
1416 
1417     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1418         return dividendTracker.totalDividendsDistributed(rewardToken);
1419     }
1420 
1421     function isExcludedFromFees(address account) external view returns(bool) {
1422         return _isExcludedFromFees[account];
1423     }
1424 
1425     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1426     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1427   	}
1428 
1429 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1430 		return dividendTracker.holderBalance(account);
1431 	}
1432 
1433     function getAccountDividendsInfo(address account, address rewardToken)
1434         external view returns (
1435             address,
1436             int256,
1437             int256,
1438             uint256,
1439             uint256,
1440             uint256,
1441             uint256,
1442             uint256) {
1443         return dividendTracker.getAccount(account, rewardToken);
1444     }
1445 
1446 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1447         external view returns (
1448             address,
1449             int256,
1450             int256,
1451             uint256,
1452             uint256,
1453             uint256,
1454             uint256,
1455             uint256) {
1456     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1457     }
1458 
1459 	function processDividendTracker(uint256 gas) external {
1460 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1461 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1462     }
1463 
1464     function claim() external {
1465 		dividendTracker.processAccount(payable(msg.sender), false);
1466     }
1467 
1468     function getLastProcessedIndex() external view returns(uint256) {
1469     	return dividendTracker.getLastProcessedIndex();
1470     }
1471 
1472     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1473         return dividendTracker.getNumberOfTokenHolders();
1474     }
1475     
1476     function getNumberOfDividends() external view returns(uint256) {
1477         return dividendTracker.totalBalance();
1478     }
1479     
1480     // remove limits after token is stable
1481     function removeLimits() external onlyOwner returns (bool){
1482         limitsInEffect = false;
1483         transferDelayEnabled = false;
1484         return true;
1485     }
1486     
1487     function _transfer(
1488         address from,
1489         address to,
1490         uint256 amount
1491     ) internal override {
1492         require(from != address(0), "ERC20: transfer from the zero address");
1493         require(to != address(0), "ERC20: transfer to the zero address");
1494         
1495          if(amount == 0) {
1496             super._transfer(from, to, 0);
1497             return;
1498         }
1499         
1500         if(!tradingActive){
1501             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1502         }
1503         
1504         if(limitsInEffect){
1505             if (
1506                 from != owner() &&
1507                 to != owner() &&
1508                 to != address(0) &&
1509                 to != address(0xdead) &&
1510                 !swapping
1511             ){
1512 
1513                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1514                 if (transferDelayEnabled){
1515                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1516                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1517                         _holderLastTransferTimestamp[tx.origin] = block.number;
1518                     }
1519                 }
1520                 
1521                 //when buy
1522                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1523                     require(amount + balanceOf(to) <= maxTxn, "Unable to exceed Max Wallet");
1524                 } 
1525                 //when sell
1526                 else if(!_isExcludedMaxTransactionAmount[to]) {
1527                     require(amount + balanceOf(to) <= maxTxn, "Unable to exceed Max Wallet");
1528                 }
1529             }
1530         }
1531 
1532 		uint256 contractTokenBalance = balanceOf(address(this));
1533         
1534         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1535 
1536         if( 
1537             canSwap &&
1538             swapEnabled &&
1539             !swapping &&
1540             !automatedMarketMakerPairs[from] &&
1541             !_isExcludedFromFees[from] &&
1542             !_isExcludedFromFees[to]
1543         ) {
1544             swapping = true;
1545             swapBack();
1546             swapping = false;
1547         }
1548 
1549         bool takeFee = !swapping;
1550 
1551         // if any account belongs to _isExcludedFromFee account then remove the fee
1552         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1553             takeFee = false;
1554         }
1555         
1556         uint256 fees = 0;
1557         
1558         // no taxes on transfers (non buys/sells)
1559         if(takeFee){
1560             // on sell
1561             if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1562                 fees = amount.mul(totalSellFees).div(feeDivisor);
1563                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1564                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1565                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1566             }
1567             
1568             // on buy
1569             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1570         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1571         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1572                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1573                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1574             }
1575 
1576             if(fees > 0){    
1577                 super._transfer(from, address(this), fees);
1578             }
1579         	
1580         	amount -= fees;
1581         }
1582 
1583         super._transfer(from, to, amount);
1584 
1585         dividendTracker.setBalance(payable(from), balanceOf(from));
1586         dividendTracker.setBalance(payable(to), balanceOf(to));
1587 
1588         if(!swapping && gasForProcessing > 0) {
1589 	    	uint256 gas = gasForProcessing;
1590 
1591 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1592 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1593 	    	}
1594 	    	catch {}
1595         }
1596     }
1597     
1598     function swapTokensForEth(uint256 tokenAmount) private {
1599 
1600         // generate the uniswap pair path of token -> weth
1601         address[] memory path = new address[](2);
1602         path[0] = address(this);
1603         path[1] = uniswapV2Router.WETH();
1604 
1605         _approve(address(this), address(uniswapV2Router), tokenAmount);
1606 
1607         // make the swap
1608         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1609             tokenAmount,
1610             0, // accept any amount of ETH
1611             path,
1612             address(this),
1613             block.timestamp
1614         );
1615         
1616     }
1617     
1618     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1619         // approve token transfer to cover all possible scenarios
1620         _approve(address(this), address(uniswapV2Router), tokenAmount);
1621 
1622         // add the liquidity
1623         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1624             address(this),
1625             tokenAmount,
1626             0, // slippage is unavoidable
1627             0, // slippage is unavoidable
1628             address(operationsWallet),
1629             block.timestamp
1630         );
1631 
1632     }
1633     
1634     function swapBack() private {
1635         uint256 contractBalance = balanceOf(address(this));
1636         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1637         
1638         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1639         
1640         // Halve the amount of liquidity tokens
1641         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1642         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1643         
1644         uint256 initialETHBalance = address(this).balance;
1645 
1646         swapTokensForEth(amountToSwapForETH); 
1647         
1648         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1649         
1650         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1651         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1652         
1653         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1654         
1655         tokensForLiquidity = 0;
1656         tokensForOperations = 0;
1657         tokensForRewards = 0;
1658         
1659         
1660         
1661         if(liquidityTokens > 0 && ethForLiquidity > 0){
1662             addLiquidity(liquidityTokens, ethForLiquidity);
1663             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1664         }
1665         
1666         // call twice to force buy of both reward tokens.
1667         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1668 
1669         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1670     }
1671 
1672     function withdrawStuckEth() external onlyOwner {
1673         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1674         require(success, "failed to withdraw");
1675     }
1676 
1677     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1678         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1679         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1680         lpWithdrawRequestTimestamp = block.timestamp;
1681         lpWithdrawRequestPending = true;
1682         lpPercToWithDraw = percToWithdraw;
1683         emit RequestedLPWithdraw();
1684     }
1685 
1686     function nextAvailableLpWithdrawDate() public view returns (uint256){
1687         if(lpWithdrawRequestPending){
1688             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1689         }
1690         else {
1691             return 0;  // 0 means no open requests
1692         }
1693     }
1694 
1695     function withdrawRequestedLP() external onlyOwner {
1696         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1697         lpWithdrawRequestTimestamp = 0;
1698         lpWithdrawRequestPending = false;
1699 
1700         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1701         
1702         lpPercToWithDraw = 0;
1703 
1704         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1705     }
1706 
1707     function cancelLPWithdrawRequest() external onlyOwner {
1708         lpWithdrawRequestPending = false;
1709         lpPercToWithDraw = 0;
1710         lpWithdrawRequestTimestamp = 0;
1711         emit CanceledLpWithdrawRequest();
1712     }
1713 }