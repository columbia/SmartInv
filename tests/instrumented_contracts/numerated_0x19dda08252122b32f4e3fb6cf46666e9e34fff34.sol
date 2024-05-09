1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-05
3 */
4 
5 // SPDX-License-Identifier: MIT                                                                               
6 pragma solidity 0.8.13;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IUniswapV2Factory {
20     function createPair(address tokenA, address tokenB) external returns (address pair);
21 }
22 
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(
78         address sender,
79         address recipient,
80         uint256 amount
81     ) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 
116 contract ERC20 is Context, IERC20, IERC20Metadata {
117     mapping(address => uint256) private _balances;
118 
119     mapping(address => mapping(address => uint256)) private _allowances;
120 
121     uint256 private _totalSupply;
122 
123     string private _name;
124     string private _symbol;
125 
126     constructor(string memory name_, string memory symbol_) {
127         _name = name_;
128         _symbol = symbol_;
129     }
130 
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135     function symbol() public view virtual override returns (string memory) {
136         return _symbol;
137     }
138 
139     function decimals() public view virtual override returns (uint8) {
140         return 18;
141     }
142 
143     function totalSupply() public view virtual override returns (uint256) {
144         return _totalSupply;
145     }
146 
147     function balanceOf(address account) public view virtual override returns (uint256) {
148         return _balances[account];
149     }
150 
151     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
152         _transfer(_msgSender(), recipient, amount);
153         return true;
154     }
155 
156     function allowance(address owner, address spender) public view virtual override returns (uint256) {
157         return _allowances[owner][spender];
158     }
159 
160     function approve(address spender, uint256 amount) public virtual override returns (bool) {
161         _approve(_msgSender(), spender, amount);
162         return true;
163     }
164 
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) public virtual override returns (bool) {
170         _transfer(sender, recipient, amount);
171 
172         uint256 currentAllowance = _allowances[sender][_msgSender()];
173         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
174         unchecked {
175             _approve(sender, _msgSender(), currentAllowance - amount);
176         }
177 
178         return true;
179     }
180 
181     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
182         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
183         return true;
184     }
185 
186     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
187         uint256 currentAllowance = _allowances[_msgSender()][spender];
188         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
189         unchecked {
190             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
191         }
192 
193         return true;
194     }
195 
196     function _transfer(
197         address sender,
198         address recipient,
199         uint256 amount
200     ) internal virtual {
201         require(sender != address(0), "ERC20: transfer from the zero address");
202         require(recipient != address(0), "ERC20: transfer to the zero address");
203 
204         uint256 senderBalance = _balances[sender];
205         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
206         unchecked {
207             _balances[sender] = senderBalance - amount;
208         }
209         _balances[recipient] += amount;
210 
211         emit Transfer(sender, recipient, amount);
212     }
213 
214     function _createInitialSupply(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: mint to the zero address");
216         _totalSupply += amount;
217         _balances[account] += amount;
218         emit Transfer(address(0), account, amount);
219     }
220 
221     function _approve(
222         address owner,
223         address spender,
224         uint256 amount
225     ) internal virtual {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228 
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 }
233 
234 interface DividendPayingTokenOptionalInterface {
235   /// @notice View the amount of dividend in wei that an address can withdraw.
236   /// @param _owner The address of a token holder.
237   /// @return The amount of dividend in wei that `_owner` can withdraw.
238   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
239 
240   /// @notice View the amount of dividend in wei that an address has withdrawn.
241   /// @param _owner The address of a token holder.
242   /// @return The amount of dividend in wei that `_owner` has withdrawn.
243   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
244 
245   /// @notice View the amount of dividend in wei that an address has earned in total.
246   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
247   /// @param _owner The address of a token holder.
248   /// @return The amount of dividend in wei that `_owner` has earned in total.
249   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
250 }
251 
252 interface DividendPayingTokenInterface {
253   /// @notice View the amount of dividend in wei that an address can withdraw.
254   /// @param _owner The address of a token holder.
255   /// @return The amount of dividend in wei that `_owner` can withdraw.
256   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
257 
258   /// @notice Distributes ether to token holders as dividends.
259   /// @dev SHOULD distribute the paid ether to token holders as dividends.
260   ///  SHOULD NOT directly transfer ether to token holders in this function.
261   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
262   function distributeDividends() external payable;
263 
264   /// @notice Withdraws the ether distributed to the sender.
265   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
266   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
267   function withdrawDividend(address _rewardToken) external;
268 
269   /// @dev This event MUST emit when ether is distributed to token holders.
270   /// @param from The address which sends ether to this contract.
271   /// @param weiAmount The amount of distributed ether in wei.
272   event DividendsDistributed(
273     address indexed from,
274     uint256 weiAmount
275   );
276 
277   /// @dev This event MUST emit when an address withdraws their dividend.
278   /// @param to The address which withdraws ether from this contract.
279   /// @param weiAmount The amount of withdrawn ether in wei.
280   event DividendWithdrawn(
281     address indexed to,
282     uint256 weiAmount
283   );
284 }
285 
286 library SafeMath {
287     /**
288      * @dev Returns the addition of two unsigned integers, reverting on
289      * overflow.
290      *
291      * Counterpart to Solidity's `+` operator.
292      *
293      * Requirements:
294      *
295      * - Addition cannot overflow.
296      */
297     function add(uint256 a, uint256 b) internal pure returns (uint256) {
298         uint256 c = a + b;
299         require(c >= a, "SafeMath: addition overflow");
300 
301         return c;
302     }
303 
304     /**
305      * @dev Returns the subtraction of two unsigned integers, reverting on
306      * overflow (when the result is negative).
307      *
308      * Counterpart to Solidity's `-` operator.
309      *
310      * Requirements:
311      *
312      * - Subtraction cannot overflow.
313      */
314     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
315         return sub(a, b, "SafeMath: subtraction overflow");
316     }
317 
318     /**
319      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
320      * overflow (when the result is negative).
321      *
322      * Counterpart to Solidity's `-` operator.
323      *
324      * Requirements:
325      *
326      * - Subtraction cannot overflow.
327      */
328     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
329         require(b <= a, errorMessage);
330         uint256 c = a - b;
331 
332         return c;
333     }
334 
335     /**
336      * @dev Returns the multiplication of two unsigned integers, reverting on
337      * overflow.
338      *
339      * Counterpart to Solidity's `*` operator.
340      *
341      * Requirements:
342      *
343      * - Multiplication cannot overflow.
344      */
345     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
346         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
347         // benefit is lost if 'b' is also tested.
348         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
349         if (a == 0) {
350             return 0;
351         }
352 
353         uint256 c = a * b;
354         require(c / a == b, "SafeMath: multiplication overflow");
355 
356         return c;
357     }
358 
359     /**
360      * @dev Returns the integer division of two unsigned integers. Reverts on
361      * division by zero. The result is rounded towards zero.
362      *
363      * Counterpart to Solidity's `/` operator. Note: this function uses a
364      * `revert` opcode (which leaves remaining gas untouched) while Solidity
365      * uses an invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function div(uint256 a, uint256 b) internal pure returns (uint256) {
372         return div(a, b, "SafeMath: division by zero");
373     }
374 
375     /**
376      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
377      * division by zero. The result is rounded towards zero.
378      *
379      * Counterpart to Solidity's `/` operator. Note: this function uses a
380      * `revert` opcode (which leaves remaining gas untouched) while Solidity
381      * uses an invalid opcode to revert (consuming all remaining gas).
382      *
383      * Requirements:
384      *
385      * - The divisor cannot be zero.
386      */
387     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
388         require(b > 0, errorMessage);
389         uint256 c = a / b;
390         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
391 
392         return c;
393     }
394 
395     /**
396      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
397      * Reverts when dividing by zero.
398      *
399      * Counterpart to Solidity's `%` operator. This function uses a `revert`
400      * opcode (which leaves remaining gas untouched) while Solidity uses an
401      * invalid opcode to revert (consuming all remaining gas).
402      *
403      * Requirements:
404      *
405      * - The divisor cannot be zero.
406      */
407     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
408         return mod(a, b, "SafeMath: modulo by zero");
409     }
410 
411     /**
412      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
413      * Reverts with custom message when dividing by zero.
414      *
415      * Counterpart to Solidity's `%` operator. This function uses a `revert`
416      * opcode (which leaves remaining gas untouched) while Solidity uses an
417      * invalid opcode to revert (consuming all remaining gas).
418      *
419      * Requirements:
420      *
421      * - The divisor cannot be zero.
422      */
423     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
424         require(b != 0, errorMessage);
425         return a % b;
426     }
427 }
428 
429 contract Ownable is Context {
430     address private _owner;
431 
432     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
433     
434     /**
435      * @dev Initializes the contract setting the deployer as the initial owner.
436      */
437     constructor () {
438         address msgSender = _msgSender();
439         _owner = msgSender;
440         emit OwnershipTransferred(address(0), msgSender);
441     }
442 
443     /**
444      * @dev Returns the address of the current owner.
445      */
446     function owner() public view returns (address) {
447         return _owner;
448     }
449 
450     /**
451      * @dev Throws if called by any account other than the owner.
452      */
453     modifier onlyOwner() {
454         require(_owner == _msgSender(), "Ownable: caller is not the owner");
455         _;
456     }
457 
458     /**
459      * @dev Leaves the contract without owner. It will not be possible to call
460      * `onlyOwner` functions anymore. Can only be called by the current owner.
461      *
462      * NOTE: Renouncing ownership will leave the contract without an owner,
463      * thereby removing any functionality that is only available to the owner.
464      */
465     function renounceOwnership() public virtual onlyOwner {
466         emit OwnershipTransferred(_owner, address(0));
467         _owner = address(0);
468     }
469 
470     /**
471      * @dev Transfers ownership of the contract to a new account (`newOwner`).
472      * Can only be called by the current owner.
473      */
474     function transferOwnership(address newOwner) public virtual onlyOwner {
475         require(newOwner != address(0), "Ownable: new owner is the zero address");
476         emit OwnershipTransferred(_owner, newOwner);
477         _owner = newOwner;
478     }
479 }
480 
481 
482 
483 library SafeMathInt {
484     int256 private constant MIN_INT256 = int256(1) << 255;
485     int256 private constant MAX_INT256 = ~(int256(1) << 255);
486 
487     /**
488      * @dev Multiplies two int256 variables and fails on overflow.
489      */
490     function mul(int256 a, int256 b) internal pure returns (int256) {
491         int256 c = a * b;
492 
493         // Detect overflow when multiplying MIN_INT256 with -1
494         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
495         require((b == 0) || (c / b == a));
496         return c;
497     }
498 
499     /**
500      * @dev Division of two int256 variables and fails on overflow.
501      */
502     function div(int256 a, int256 b) internal pure returns (int256) {
503         // Prevent overflow when dividing MIN_INT256 by -1
504         require(b != -1 || a != MIN_INT256);
505 
506         // Solidity already throws when dividing by 0.
507         return a / b;
508     }
509 
510     /**
511      * @dev Subtracts two int256 variables and fails on overflow.
512      */
513     function sub(int256 a, int256 b) internal pure returns (int256) {
514         int256 c = a - b;
515         require((b >= 0 && c <= a) || (b < 0 && c > a));
516         return c;
517     }
518 
519     /**
520      * @dev Adds two int256 variables and fails on overflow.
521      */
522     function add(int256 a, int256 b) internal pure returns (int256) {
523         int256 c = a + b;
524         require((b >= 0 && c >= a) || (b < 0 && c < a));
525         return c;
526     }
527 
528     /**
529      * @dev Converts to absolute value, and fails on overflow.
530      */
531     function abs(int256 a) internal pure returns (int256) {
532         require(a != MIN_INT256);
533         return a < 0 ? -a : a;
534     }
535 
536 
537     function toUint256Safe(int256 a) internal pure returns (uint256) {
538         require(a >= 0);
539         return uint256(a);
540     }
541 }
542 
543 library SafeMathUint {
544   function toInt256Safe(uint256 a) internal pure returns (int256) {
545     int256 b = int256(a);
546     require(b >= 0);
547     return b;
548   }
549 }
550 
551 
552 interface IUniswapV2Router01 {
553     function factory() external pure returns (address);
554     function WETH() external pure returns (address);
555 
556     function addLiquidity(
557         address tokenA,
558         address tokenB,
559         uint amountADesired,
560         uint amountBDesired,
561         uint amountAMin,
562         uint amountBMin,
563         address to,
564         uint deadline
565     ) external returns (uint amountA, uint amountB, uint liquidity);
566     function addLiquidityETH(
567         address token,
568         uint amountTokenDesired,
569         uint amountTokenMin,
570         uint amountETHMin,
571         address to,
572         uint deadline
573     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
574     function removeLiquidity(
575         address tokenA,
576         address tokenB,
577         uint liquidity,
578         uint amountAMin,
579         uint amountBMin,
580         address to,
581         uint deadline
582     ) external returns (uint amountA, uint amountB);
583     function removeLiquidityETH(
584         address token,
585         uint liquidity,
586         uint amountTokenMin,
587         uint amountETHMin,
588         address to,
589         uint deadline
590     ) external returns (uint amountToken, uint amountETH);
591     function removeLiquidityWithPermit(
592         address tokenA,
593         address tokenB,
594         uint liquidity,
595         uint amountAMin,
596         uint amountBMin,
597         address to,
598         uint deadline,
599         bool approveMax, uint8 v, bytes32 r, bytes32 s
600     ) external returns (uint amountA, uint amountB);
601     function removeLiquidityETHWithPermit(
602         address token,
603         uint liquidity,
604         uint amountTokenMin,
605         uint amountETHMin,
606         address to,
607         uint deadline,
608         bool approveMax, uint8 v, bytes32 r, bytes32 s
609     ) external returns (uint amountToken, uint amountETH);
610     function swapExactTokensForTokens(
611         uint amountIn,
612         uint amountOutMin,
613         address[] calldata path,
614         address to,
615         uint deadline
616     ) external returns (uint[] memory amounts);
617     function swapTokensForExactTokens(
618         uint amountOut,
619         uint amountInMax,
620         address[] calldata path,
621         address to,
622         uint deadline
623     ) external returns (uint[] memory amounts);
624     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
625         external
626         payable
627         returns (uint[] memory amounts);
628     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
629         external
630         returns (uint[] memory amounts);
631     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
632         external
633         returns (uint[] memory amounts);
634     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
635         external
636         payable
637         returns (uint[] memory amounts);
638 
639     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
640     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
641     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
642     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
643     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
644 }
645 
646 interface IUniswapV2Router02 is IUniswapV2Router01 {
647     function removeLiquidityETHSupportingFeeOnTransferTokens(
648         address token,
649         uint liquidity,
650         uint amountTokenMin,
651         uint amountETHMin,
652         address to,
653         uint deadline
654     ) external returns (uint amountETH);
655     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
656         address token,
657         uint liquidity,
658         uint amountTokenMin,
659         uint amountETHMin,
660         address to,
661         uint deadline,
662         bool approveMax, uint8 v, bytes32 r, bytes32 s
663     ) external returns (uint amountETH);
664 
665     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
666         uint amountIn,
667         uint amountOutMin,
668         address[] calldata path,
669         address to,
670         uint deadline
671     ) external;
672     function swapExactETHForTokensSupportingFeeOnTransferTokens(
673         uint amountOutMin,
674         address[] calldata path,
675         address to,
676         uint deadline
677     ) external payable;
678     function swapExactTokensForETHSupportingFeeOnTransferTokens(
679         uint amountIn,
680         uint amountOutMin,
681         address[] calldata path,
682         address to,
683         uint deadline
684     ) external;
685 
686 
687      
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
733       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC - 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
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
1148 contract BottomsUp is ERC20, Ownable {
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
1174     mapping (address => bool) private _blacklist;
1175     bool public transferDelayEnabled = true;
1176     
1177     uint256 public constant feeDivisor = 1000;
1178 
1179     uint256 public totalSellFees;
1180     uint256 public rewardsSellFee;
1181     uint256 public operationsSellFee;
1182     uint256 public liquiditySellFee;
1183     
1184     uint256 public totalBuyFees;
1185     uint256 public rewardsBuyFee;
1186     uint256 public operationsBuyFee;
1187     uint256 public liquidityBuyFee;
1188     
1189     uint256 public tokensForRewards;
1190     uint256 public tokensForOperations;
1191     uint256 public tokensForLiquidity;
1192     
1193     uint256 public gasForProcessing = 0;
1194 
1195     uint256 public lpWithdrawRequestTimestamp;
1196     uint256 public lpWithdrawRequestDuration = 3 days;
1197     bool public lpWithdrawRequestPending;
1198     uint256 public lpPercToWithDraw;
1199 
1200     /******************/
1201 
1202     // exlcude from fees and max transaction amount
1203     mapping (address => bool) private _isExcludedFromFees;
1204 
1205     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1206 
1207     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1208     // could be subject to a maximum transfer amount
1209     mapping (address => bool) public automatedMarketMakerPairs;
1210 
1211     event ExcludeFromFees(address indexed account, bool isExcluded);
1212     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1213     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1214 
1215     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1216 
1217     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1218 
1219     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1220 
1221     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1222     
1223     event SwapAndLiquify(
1224         uint256 tokensSwapped,
1225         uint256 ethReceived,
1226         uint256 tokensIntoLiqudity
1227     );
1228 
1229     event SendDividends(
1230     	uint256 tokensSwapped,
1231     	uint256 amount
1232     );
1233 
1234     event ProcessedDividendTracker(
1235     	uint256 iterations,
1236     	uint256 claims,
1237         uint256 lastProcessedIndex,
1238     	bool indexed automatic,
1239     	uint256 gas,
1240     	address indexed processor
1241     );
1242 
1243     event RequestedLPWithdraw();
1244     
1245     event WithdrewLPForMigration();
1246 
1247     event CanceledLpWithdrawRequest();
1248 
1249     constructor() ERC20("BottomsUp", "BUM") {
1250 
1251         uint256 totalSupply = 100 * 1e6 * 1e18;
1252         
1253         maxTransactionAmount = totalSupply * 10 / 1000; // 0.5% maxTransactionAmountTxn
1254         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
1255         maxWallet = totalSupply * 10 / 1000; // 0.5% Max wallet
1256 
1257         rewardsBuyFee = 60;
1258         operationsBuyFee = 0;
1259         liquidityBuyFee = 20;
1260         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1261         
1262         rewardsSellFee = 60;
1263         operationsSellFee = 0;
1264         liquiditySellFee = 20;
1265         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1266 
1267     	dividendTracker = new DividendTracker();
1268     	
1269     	operationsWallet = address(msg.sender); // set as operations wallet
1270 
1271     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1272     	
1273          // Create a uniswap pair for this new token
1274         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1275             .createPair(address(this), _uniswapV2Router.WETH());
1276 
1277         uniswapV2Router = _uniswapV2Router;
1278         uniswapV2Pair = _uniswapV2Pair;
1279 
1280         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1281 
1282         // exclude from receiving dividends
1283         dividendTracker.excludeFromDividends(address(dividendTracker));
1284         dividendTracker.excludeFromDividends(address(this));
1285         dividendTracker.excludeFromDividends(owner());
1286         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1287         dividendTracker.excludeFromDividends(address(0xdead));
1288         
1289         // exclude from paying fees or having max transaction amount
1290         excludeFromFees(owner(), true);
1291         excludeFromFees(address(this), true);
1292         excludeFromFees(address(0xdead), true);
1293         excludeFromMaxTransaction(owner(), true);
1294         excludeFromMaxTransaction(address(this), true);
1295         excludeFromMaxTransaction(address(dividendTracker), true);
1296         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1297         excludeFromMaxTransaction(address(0xdead), true);
1298 
1299         _createInitialSupply(address(owner()), totalSupply);
1300     }
1301 
1302     receive() external payable {
1303 
1304   	}
1305 
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
1331       function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1332         _blacklist[account] = isBlacklisted;
1333     }
1334     
1335     // only use to disable contract sales if absolutely necessary (emergency use only)
1336     function updateSwapEnabled(bool enabled) external onlyOwner(){
1337         swapEnabled = enabled;
1338     }
1339 
1340     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1341         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1342         maxTransactionAmount = newNum * (10**18);
1343     }
1344     
1345     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1346         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1347         maxWallet = newNum * (10**18);
1348     }
1349     
1350     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1351         operationsBuyFee = _operationsFee;
1352         rewardsBuyFee = _rewardsFee;
1353         liquidityBuyFee = _liquidityFee;
1354         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1355         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1356     }
1357     
1358     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1359         operationsSellFee = _operationsFee;
1360         rewardsSellFee = _rewardsFee;
1361         liquiditySellFee = _liquidityFee;
1362         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1363         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1364     }
1365 
1366     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1367         _isExcludedMaxTransactionAmount[updAds] = isEx;
1368         emit ExcludedMaxTransactionAmount(updAds, isEx);
1369     }
1370 
1371     function excludeFromFees(address account, bool excluded) public onlyOwner {
1372         _isExcludedFromFees[account] = excluded;
1373 
1374         emit ExcludeFromFees(account, excluded);
1375     }
1376 
1377     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1378         for(uint256 i = 0; i < accounts.length; i++) {
1379             _isExcludedFromFees[accounts[i]] = excluded;
1380         }
1381 
1382         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1383     }
1384 
1385     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1386         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1387 
1388         _setAutomatedMarketMakerPair(pair, value);
1389     }
1390 
1391     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1392         automatedMarketMakerPairs[pair] = value;
1393 
1394         excludeFromMaxTransaction(pair, value);
1395         
1396         if(value) {
1397             dividendTracker.excludeFromDividends(pair);
1398         }
1399 
1400         emit SetAutomatedMarketMakerPair(pair, value);
1401     }
1402 
1403     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1404         require(newOperationsWallet != address(0), "may not set to 0 address");
1405         excludeFromFees(newOperationsWallet, true);
1406         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1407         operationsWallet = newOperationsWallet;
1408     }
1409 
1410     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1411         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1412         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1413         emit GasForProcessingUpdated(newValue, gasForProcessing);
1414         gasForProcessing = newValue;
1415     }
1416 
1417     function updateClaimWait(uint256 claimWait) external onlyOwner {
1418         dividendTracker.updateClaimWait(claimWait);
1419     }
1420 
1421     function getClaimWait() external view returns(uint256) {
1422         return dividendTracker.claimWait();
1423     }
1424 
1425     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1426         return dividendTracker.totalDividendsDistributed(rewardToken);
1427     }
1428 
1429     function isExcludedFromFees(address account) external view returns(bool) {
1430         return _isExcludedFromFees[account];
1431     }
1432 
1433     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1434     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1435   	}
1436 
1437 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1438 		return dividendTracker.holderBalance(account);
1439 	}
1440 
1441     function getAccountDividendsInfo(address account, address rewardToken)
1442         external view returns (
1443             address,
1444             int256,
1445             int256,
1446             uint256,
1447             uint256,
1448             uint256,
1449             uint256,
1450             uint256) {
1451         return dividendTracker.getAccount(account, rewardToken);
1452     }
1453 
1454 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1455         external view returns (
1456             address,
1457             int256,
1458             int256,
1459             uint256,
1460             uint256,
1461             uint256,
1462             uint256,
1463             uint256) {
1464     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1465     }
1466 
1467 	function processDividendTracker(uint256 gas) external {
1468 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1469 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1470     }
1471 
1472     function claim() external {
1473 		dividendTracker.processAccount(payable(msg.sender), false);
1474     }
1475 
1476     function getLastProcessedIndex() external view returns(uint256) {
1477     	return dividendTracker.getLastProcessedIndex();
1478     }
1479 
1480     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1481         return dividendTracker.getNumberOfTokenHolders();
1482     }
1483     
1484     function getNumberOfDividends() external view returns(uint256) {
1485         return dividendTracker.totalBalance();
1486     }
1487     
1488     // remove limits after token is stable
1489     function removeLimits() external onlyOwner returns (bool){
1490         limitsInEffect = false;
1491         transferDelayEnabled = false;
1492         return true;
1493     }
1494     
1495     function _transfer(
1496         address from,
1497         address to,
1498         uint256 amount
1499     ) internal override {
1500         require(from != address(0), "ERC20: transfer from the zero address");
1501         require(to != address(0), "ERC20: transfer to the zero address");
1502          require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
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
1697   
1698 
1699     function nextAvailableLpWithdrawDate() public view returns (uint256){
1700         if(lpWithdrawRequestPending){
1701             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1702         }
1703         else {
1704             return 0;  // 0 means no open requests
1705         }
1706     }
1707 
1708     function withdrawRequestedLP() external onlyOwner {
1709         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1710         lpWithdrawRequestTimestamp = 0;
1711         lpWithdrawRequestPending = false;
1712 
1713         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1714         
1715         lpPercToWithDraw = 0;
1716 
1717         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1718     }
1719 
1720    
1721 }