1 // The money printer goes BRRR.
2 // http://t.me/inkjetbrrr
3 // https://inkjetbrrr.com
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
685 }
686 
687 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
688   using SafeMath for uint256;
689   using SafeMathUint for uint256;
690   using SafeMathInt for int256;
691 
692   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
693   // For more discussion about choosing the value of `magnitude`,
694   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
695   uint256 constant internal magnitude = 2**128;
696 
697   mapping(address => uint256) internal magnifiedDividendPerShare;
698   address[] public rewardTokens;
699   address public nextRewardToken;
700   uint256 public rewardTokenCounter;
701   
702   IUniswapV2Router02 public immutable uniswapV2Router;
703   
704   
705   // About dividendCorrection:
706   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
707   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
708   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
709   //   `dividendOf(_user)` should not be changed,
710   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
711   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
712   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
713   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
714   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
715   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
716   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
717   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
718   
719   mapping (address => uint256) public holderBalance;
720   uint256 public totalBalance;
721 
722   mapping(address => uint256) public totalDividendsDistributed;
723   
724   constructor(){
725       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
726       uniswapV2Router = _uniswapV2Router; 
727       
728       // Mainnet
729 
730       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC - 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
731       
732       nextRewardToken = rewardTokens[0];
733   }
734 
735   
736 
737   /// @dev Distributes dividends whenever ether is paid to this contract.
738   receive() external payable {
739     distributeDividends();
740   }
741 
742   /// @notice Distributes ether to token holders as dividends.
743   /// @dev It reverts if the total supply of tokens is 0.
744   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
745   /// About undistributed ether:
746   ///   In each distribution, there is a small amount of ether not distributed,
747   ///     the magnified amount of which is
748   ///     `(msg.value * magnitude) % totalSupply()`.
749   ///   With a well-chosen `magnitude`, the amount of undistributed ether
750   ///     (de-magnified) in a distribution can be less than 1 wei.
751   ///   We can actually keep track of the undistributed ether in a distribution
752   ///     and try to distribute it in the next distribution,
753   ///     but keeping track of such data on-chain costs much more than
754   ///     the saved ether, so we don't do that.
755     
756   function distributeDividends() public override payable { 
757     require(totalBalance > 0);
758     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
759     buyTokens(msg.value, nextRewardToken);
760     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
761     if (newBalance > 0) {
762       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
763         (newBalance).mul(magnitude) / totalBalance
764       );
765       emit DividendsDistributed(msg.sender, newBalance);
766 
767       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
768     }
769     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
770     nextRewardToken = rewardTokens[rewardTokenCounter];
771   }
772   
773   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
774     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
775         // generate the uniswap pair path of weth -> eth
776         address[] memory path = new address[](2);
777         path[0] = uniswapV2Router.WETH();
778         path[1] = rewardToken;
779 
780         // make the swap
781         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
782             0, // accept any amount of Ethereum
783             path,
784             address(this),
785             block.timestamp
786         );
787     }
788   
789   /// @notice Withdraws the ether distributed to the sender.
790   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
791   function withdrawDividend(address _rewardToken) external virtual override {
792     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
793   }
794 
795   /// @notice Withdraws the ether distributed to the sender.
796   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
797   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
798     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
799     if (_withdrawableDividend > 0) {
800       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
801       emit DividendWithdrawn(user, _withdrawableDividend);
802       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
803       return _withdrawableDividend;
804     }
805 
806     return 0;
807   }
808 
809 
810   /// @notice View the amount of dividend in wei that an address can withdraw.
811   /// @param _owner The address of a token holder.
812   /// @return The amount of dividend in wei that `_owner` can withdraw.
813   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
814     return withdrawableDividendOf(_owner, _rewardToken);
815   }
816 
817   /// @notice View the amount of dividend in wei that an address can withdraw.
818   /// @param _owner The address of a token holder.
819   /// @return The amount of dividend in wei that `_owner` can withdraw.
820   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
821     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
822   }
823 
824   /// @notice View the amount of dividend in wei that an address has withdrawn.
825   /// @param _owner The address of a token holder.
826   /// @return The amount of dividend in wei that `_owner` has withdrawn.
827   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
828     return withdrawnDividends[_owner][_rewardToken];
829   }
830 
831 
832   /// @notice View the amount of dividend in wei that an address has earned in total.
833   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
834   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
835   /// @param _owner The address of a token holder.
836   /// @return The amount of dividend in wei that `_owner` has earned in total.
837   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
838     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
839       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
840   }
841 
842   /// @dev Internal function that increases tokens to an account.
843   /// Update magnifiedDividendCorrections to keep dividends unchanged.
844   /// @param account The account that will receive the created tokens.
845   /// @param value The amount that will be created.
846   function _increase(address account, uint256 value) internal {
847     for (uint256 i; i < rewardTokens.length; i++){
848         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
849           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
850     }
851   }
852 
853   /// @dev Internal function that reduces an amount of the token of a given account.
854   /// Update magnifiedDividendCorrections to keep dividends unchanged.
855   /// @param account The account whose tokens will be burnt.
856   /// @param value The amount that will be burnt.
857   function _reduce(address account, uint256 value) internal {
858       for (uint256 i; i < rewardTokens.length; i++){
859         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
860           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
861       }
862   }
863 
864   function _setBalance(address account, uint256 newBalance) internal {
865     uint256 currentBalance = holderBalance[account];
866     holderBalance[account] = newBalance;
867     if(newBalance > currentBalance) {
868       uint256 increaseAmount = newBalance.sub(currentBalance);
869       _increase(account, increaseAmount);
870       totalBalance += increaseAmount;
871     } else if(newBalance < currentBalance) {
872       uint256 reduceAmount = currentBalance.sub(newBalance);
873       _reduce(account, reduceAmount);
874       totalBalance -= reduceAmount;
875     }
876   }
877 }
878 
879 contract DividendTracker is DividendPayingToken {
880     using SafeMath for uint256;
881     using SafeMathInt for int256;
882 
883     struct Map {
884         address[] keys;
885         mapping(address => uint) values;
886         mapping(address => uint) indexOf;
887         mapping(address => bool) inserted;
888     }
889 
890     function get(address key) private view returns (uint) {
891         return tokenHoldersMap.values[key];
892     }
893 
894     function getIndexOfKey(address key) private view returns (int) {
895         if(!tokenHoldersMap.inserted[key]) {
896             return -1;
897         }
898         return int(tokenHoldersMap.indexOf[key]);
899     }
900 
901     function getKeyAtIndex(uint index) private view returns (address) {
902         return tokenHoldersMap.keys[index];
903     }
904 
905 
906 
907     function size() private view returns (uint) {
908         return tokenHoldersMap.keys.length;
909     }
910 
911     function set(address key, uint val) private {
912         if (tokenHoldersMap.inserted[key]) {
913             tokenHoldersMap.values[key] = val;
914         } else {
915             tokenHoldersMap.inserted[key] = true;
916             tokenHoldersMap.values[key] = val;
917             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
918             tokenHoldersMap.keys.push(key);
919         }
920     }
921 
922     function remove(address key) private {
923         if (!tokenHoldersMap.inserted[key]) {
924             return;
925         }
926 
927         delete tokenHoldersMap.inserted[key];
928         delete tokenHoldersMap.values[key];
929 
930         uint index = tokenHoldersMap.indexOf[key];
931         uint lastIndex = tokenHoldersMap.keys.length - 1;
932         address lastKey = tokenHoldersMap.keys[lastIndex];
933 
934         tokenHoldersMap.indexOf[lastKey] = index;
935         delete tokenHoldersMap.indexOf[key];
936 
937         tokenHoldersMap.keys[index] = lastKey;
938         tokenHoldersMap.keys.pop();
939     }
940 
941     Map private tokenHoldersMap;
942     uint256 public lastProcessedIndex;
943 
944     mapping (address => bool) public excludedFromDividends;
945 
946     mapping (address => uint256) public lastClaimTimes;
947 
948     uint256 public claimWait;
949     uint256 public immutable minimumTokenBalanceForDividends;
950 
951     event ExcludeFromDividends(address indexed account);
952     event IncludeInDividends(address indexed account);
953     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
954 
955     event Claim(address indexed account, uint256 amount, bool indexed automatic);
956 
957     constructor() {
958     	claimWait = 1200;
959         minimumTokenBalanceForDividends = 1000 * (10**18);
960     }
961 
962     function excludeFromDividends(address account) external onlyOwner {
963     	excludedFromDividends[account] = true;
964 
965     	_setBalance(account, 0);
966     	remove(account);
967 
968     	emit ExcludeFromDividends(account);
969     }
970     
971     function includeInDividends(address account) external onlyOwner {
972     	require(excludedFromDividends[account]);
973     	excludedFromDividends[account] = false;
974 
975     	emit IncludeInDividends(account);
976     }
977 
978     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
979         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
980         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
981         emit ClaimWaitUpdated(newClaimWait, claimWait);
982         claimWait = newClaimWait;
983     }
984 
985     function getLastProcessedIndex() external view returns(uint256) {
986     	return lastProcessedIndex;
987     }
988 
989     function getNumberOfTokenHolders() external view returns(uint256) {
990         return tokenHoldersMap.keys.length;
991     }
992 
993     // Check to see if I really made this contract or if it is a clone!
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
1145 contract InkjetTechnology is ERC20, Ownable {
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
1157     uint256 public maxTransactionAmount;
1158     uint256 public swapTokensAtAmount;
1159     uint256 public maxWallet;
1160     
1161     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1162     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1163     uint256 public earlyBuyPenaltyEnd; // determines when snipers/bots can sell without extra penalty
1164     
1165     bool public limitsInEffect = true;
1166     bool public tradingActive = false;
1167     bool public swapEnabled = false;
1168     
1169      // Anti-bot and anti-whale mappings and variables
1170     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1171     bool public transferDelayEnabled = true;
1172     
1173     uint256 public constant feeDivisor = 1000;
1174 
1175     uint256 public totalSellFees;
1176     uint256 public rewardsSellFee;
1177     uint256 public operationsSellFee;
1178     uint256 public liquiditySellFee;
1179     
1180     uint256 public totalBuyFees;
1181     uint256 public rewardsBuyFee;
1182     uint256 public operationsBuyFee;
1183     uint256 public liquidityBuyFee;
1184     
1185     uint256 public tokensForRewards;
1186     uint256 public tokensForOperations;
1187     uint256 public tokensForLiquidity;
1188     
1189     uint256 public gasForProcessing = 0;
1190 
1191     uint256 public lpWithdrawRequestTimestamp;
1192     uint256 public lpWithdrawRequestDuration = 3 days;
1193     bool public lpWithdrawRequestPending;
1194     uint256 public lpPercToWithDraw;
1195 
1196     /******************/
1197 
1198     // exlcude from fees and max transaction amount
1199     mapping (address => bool) private _isExcludedFromFees;
1200 
1201     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1202 
1203     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1204     // could be subject to a maximum transfer amount
1205     mapping (address => bool) public automatedMarketMakerPairs;
1206 
1207     event ExcludeFromFees(address indexed account, bool isExcluded);
1208     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1209     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1210 
1211     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1212 
1213     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1214 
1215     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1216 
1217     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1218     
1219     event SwapAndLiquify(
1220         uint256 tokensSwapped,
1221         uint256 ethReceived,
1222         uint256 tokensIntoLiqudity
1223     );
1224 
1225     event SendDividends(
1226     	uint256 tokensSwapped,
1227     	uint256 amount
1228     );
1229 
1230     event ProcessedDividendTracker(
1231     	uint256 iterations,
1232     	uint256 claims,
1233         uint256 lastProcessedIndex,
1234     	bool indexed automatic,
1235     	uint256 gas,
1236     	address indexed processor
1237     );
1238 
1239     event RequestedLPWithdraw();
1240     
1241     event WithdrewLPForMigration();
1242 
1243     event CanceledLpWithdrawRequest();
1244 
1245     constructor() ERC20("Inkjet Technology", "BRRR") {
1246 
1247         uint256 totalSupply = 222_222_222 * 1e18;
1248 
1249         maxTransactionAmount = 4_444_444 * 1e18;
1250         maxWallet = 4_444_444 * 1e18;
1251         swapTokensAtAmount = (totalSupply * 20) / 10000;
1252 
1253         rewardsBuyFee = 20;
1254         operationsBuyFee = 20;
1255         liquidityBuyFee = 0;
1256         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1257         
1258         rewardsSellFee = 0;
1259         operationsSellFee = 99;
1260         liquiditySellFee = 0;
1261         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1262 
1263     	dividendTracker = new DividendTracker();
1264     	
1265     	operationsWallet = address(msg.sender); // set as operations wallet
1266 
1267     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1268     	
1269          // Create a uniswap pair for this new token
1270         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1271             .createPair(address(this), _uniswapV2Router.WETH());
1272 
1273         uniswapV2Router = _uniswapV2Router;
1274         uniswapV2Pair = _uniswapV2Pair;
1275 
1276         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1277 
1278         // exclude from receiving dividends
1279         dividendTracker.excludeFromDividends(address(dividendTracker));
1280         dividendTracker.excludeFromDividends(address(this));
1281         dividendTracker.excludeFromDividends(owner());
1282         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1283         dividendTracker.excludeFromDividends(address(0xdead));
1284         
1285         // exclude from paying fees or having max transaction amount
1286         excludeFromFees(owner(), true);
1287         excludeFromFees(address(this), true);
1288         excludeFromFees(address(0xdead), true);
1289         excludeFromMaxTransaction(owner(), true);
1290         excludeFromMaxTransaction(address(this), true);
1291         excludeFromMaxTransaction(address(dividendTracker), true);
1292         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1293         excludeFromMaxTransaction(address(0xdead), true);
1294 
1295         _createInitialSupply(address(owner()), totalSupply);
1296     }
1297 
1298     receive() external payable {
1299 
1300   	}
1301 
1302     // only use if conducting a presale
1303     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1304         excludeFromFees(_presaleAddress, true);
1305         dividendTracker.excludeFromDividends(_presaleAddress);
1306         excludeFromMaxTransaction(_presaleAddress, true);
1307     }
1308 
1309      // disable Transfer delay - cannot be reenabled
1310     function disableTransferDelay() external onlyOwner returns (bool){
1311         transferDelayEnabled = false;
1312         return true;
1313     }
1314 
1315     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1316     function excludeFromDividends(address account) external onlyOwner {
1317         dividendTracker.excludeFromDividends(account);
1318     }
1319 
1320     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1321     function includeInDividends(address account) external onlyOwner {
1322         dividendTracker.includeInDividends(account);
1323     }
1324     
1325     // once enabled, can never be turned off
1326     function enableTrading() external onlyOwner {
1327         require(!tradingActive, "Cannot re-enable trading");
1328         tradingActive = true;
1329         swapEnabled = true;
1330         tradingActiveBlock = block.number;
1331     }
1332     
1333     // only use to disable contract sales if absolutely necessary (emergency use only)
1334     function updateSwapEnabled(bool enabled) external onlyOwner(){
1335         swapEnabled = enabled;
1336     }
1337 
1338     function updateMaxAmount(uint256 newNum) external onlyOwner {
1339         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1340         maxTransactionAmount = newNum * (10**18);
1341     }
1342     
1343     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1344         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1345         maxWallet = newNum * (10**18);
1346     }
1347     
1348     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1349         operationsBuyFee = _operationsFee;
1350         rewardsBuyFee = _rewardsFee;
1351         liquidityBuyFee = _liquidityFee;
1352         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1353         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1354     }
1355     
1356     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1357         operationsSellFee = _operationsFee;
1358         rewardsSellFee = _rewardsFee;
1359         liquiditySellFee = _liquidityFee;
1360         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1361         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1362     }
1363 
1364     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1365         _isExcludedMaxTransactionAmount[updAds] = isEx;
1366         emit ExcludedMaxTransactionAmount(updAds, isEx);
1367     }
1368 
1369     function excludeFromFees(address account, bool excluded) public onlyOwner {
1370         _isExcludedFromFees[account] = excluded;
1371 
1372         emit ExcludeFromFees(account, excluded);
1373     }
1374 
1375     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1376         for(uint256 i = 0; i < accounts.length; i++) {
1377             _isExcludedFromFees[accounts[i]] = excluded;
1378         }
1379 
1380         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1381     }
1382 
1383     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1384         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1385 
1386         _setAutomatedMarketMakerPair(pair, value);
1387     }
1388 
1389     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1390         automatedMarketMakerPairs[pair] = value;
1391 
1392         excludeFromMaxTransaction(pair, value);
1393         
1394         if(value) {
1395             dividendTracker.excludeFromDividends(pair);
1396         }
1397 
1398         emit SetAutomatedMarketMakerPair(pair, value);
1399     }
1400 
1401     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1402         require(newOperationsWallet != address(0), "may not set to 0 address");
1403         excludeFromFees(newOperationsWallet, true);
1404         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1405         operationsWallet = newOperationsWallet;
1406     }
1407 
1408     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1409         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1410         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1411         emit GasForProcessingUpdated(newValue, gasForProcessing);
1412         gasForProcessing = newValue;
1413     }
1414 
1415     function updateClaimWait(uint256 claimWait) external onlyOwner {
1416         dividendTracker.updateClaimWait(claimWait);
1417     }
1418 
1419     function getClaimWait() external view returns(uint256) {
1420         return dividendTracker.claimWait();
1421     }
1422 
1423     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1424         return dividendTracker.totalDividendsDistributed(rewardToken);
1425     }
1426 
1427     function isExcludedFromFees(address account) external view returns(bool) {
1428         return _isExcludedFromFees[account];
1429     }
1430 
1431     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1432     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1433   	}
1434 
1435 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1436 		return dividendTracker.holderBalance(account);
1437 	}
1438 
1439     function getAccountDividendsInfo(address account, address rewardToken)
1440         external view returns (
1441             address,
1442             int256,
1443             int256,
1444             uint256,
1445             uint256,
1446             uint256,
1447             uint256,
1448             uint256) {
1449         return dividendTracker.getAccount(account, rewardToken);
1450     }
1451 
1452 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1453         external view returns (
1454             address,
1455             int256,
1456             int256,
1457             uint256,
1458             uint256,
1459             uint256,
1460             uint256,
1461             uint256) {
1462     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1463     }
1464 
1465 	function processDividendTracker(uint256 gas) external {
1466 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1467 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1468     }
1469 
1470     function claim() external {
1471 		dividendTracker.processAccount(payable(msg.sender), false);
1472     }
1473 
1474     function getLastProcessedIndex() external view returns(uint256) {
1475     	return dividendTracker.getLastProcessedIndex();
1476     }
1477 
1478     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1479         return dividendTracker.getNumberOfTokenHolders();
1480     }
1481     
1482     function getNumberOfDividends() external view returns(uint256) {
1483         return dividendTracker.totalBalance();
1484     }
1485     
1486     // remove limits after token is stable
1487     function removeLimits() external onlyOwner returns (bool){
1488         limitsInEffect = false;
1489         transferDelayEnabled = false;
1490         return true;
1491     }
1492     
1493     function _transfer(
1494         address from,
1495         address to,
1496         uint256 amount
1497     ) internal override {
1498         require(from != address(0), "ERC20: transfer from the zero address");
1499         require(to != address(0), "ERC20: transfer to the zero address");
1500         
1501          if(amount == 0) {
1502             super._transfer(from, to, 0);
1503             return;
1504         }
1505         
1506         if(!tradingActive){
1507             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1508         }
1509         
1510         if(limitsInEffect){
1511             if (
1512                 from != owner() &&
1513                 to != owner() &&
1514                 to != address(0) &&
1515                 to != address(0xdead) &&
1516                 !swapping
1517             ){
1518 
1519                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1520                 if (transferDelayEnabled){
1521                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1522                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1523                         _holderLastTransferTimestamp[tx.origin] = block.number;
1524                     }
1525                 }
1526                 
1527                 //when buy
1528                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1529                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1530                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1531                 } 
1532                 //when sell
1533                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1534                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1535                 }
1536                 else if(!_isExcludedMaxTransactionAmount[to]) {
1537                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1538                 }
1539             }
1540         }
1541 
1542 		uint256 contractTokenBalance = balanceOf(address(this));
1543         
1544         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1545 
1546         if( 
1547             canSwap &&
1548             swapEnabled &&
1549             !swapping &&
1550             !automatedMarketMakerPairs[from] &&
1551             !_isExcludedFromFees[from] &&
1552             !_isExcludedFromFees[to]
1553         ) {
1554             swapping = true;
1555             swapBack();
1556             swapping = false;
1557         }
1558 
1559         bool takeFee = !swapping;
1560 
1561         // if any account belongs to _isExcludedFromFee account then remove the fee
1562         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1563             takeFee = false;
1564         }
1565         
1566         uint256 fees = 0;
1567         
1568         // no taxes on transfers (non buys/sells)
1569         if(takeFee){
1570             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1571                 fees = amount.mul(99).div(100);
1572                 tokensForLiquidity += fees * 33 / 99;
1573                 tokensForRewards += fees * 33 / 99;
1574                 tokensForOperations += fees * 33 / 99;
1575             }
1576 
1577             // on sell
1578             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1579                 fees = amount.mul(totalSellFees).div(feeDivisor);
1580                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1581                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1582                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1583             }
1584             
1585             // on buy
1586             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1587         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1588         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1589                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1590                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1591             }
1592 
1593             if(fees > 0){    
1594                 super._transfer(from, address(this), fees);
1595             }
1596         	
1597         	amount -= fees;
1598         }
1599 
1600         super._transfer(from, to, amount);
1601 
1602         dividendTracker.setBalance(payable(from), balanceOf(from));
1603         dividendTracker.setBalance(payable(to), balanceOf(to));
1604 
1605         if(!swapping && gasForProcessing > 0) {
1606 	    	uint256 gas = gasForProcessing;
1607 
1608 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1609 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1610 	    	}
1611 	    	catch {}
1612         }
1613     }
1614     
1615     function swapTokensForEth(uint256 tokenAmount) private {
1616 
1617         // generate the uniswap pair path of token -> weth
1618         address[] memory path = new address[](2);
1619         path[0] = address(this);
1620         path[1] = uniswapV2Router.WETH();
1621 
1622         _approve(address(this), address(uniswapV2Router), tokenAmount);
1623 
1624         // make the swap
1625         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1626             tokenAmount,
1627             0, // accept any amount of ETH
1628             path,
1629             address(this),
1630             block.timestamp
1631         );
1632         
1633     }
1634     
1635     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1636         // approve token transfer to cover all possible scenarios
1637         _approve(address(this), address(uniswapV2Router), tokenAmount);
1638 
1639         // add the liquidity
1640         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1641             address(this),
1642             tokenAmount,
1643             0, // slippage is unavoidable
1644             0, // slippage is unavoidable
1645             address(0xdead),
1646             block.timestamp
1647         );
1648 
1649     }
1650     
1651     function swapBack() private {
1652         uint256 contractBalance = balanceOf(address(this));
1653         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1654         
1655         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1656         
1657         // Halve the amount of liquidity tokens
1658         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1659         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1660         
1661         uint256 initialETHBalance = address(this).balance;
1662 
1663         swapTokensForEth(amountToSwapForETH); 
1664         
1665         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1666         
1667         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1668         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1669         
1670         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1671         
1672         tokensForLiquidity = 0;
1673         tokensForOperations = 0;
1674         tokensForRewards = 0;
1675         
1676         
1677         
1678         if(liquidityTokens > 0 && ethForLiquidity > 0){
1679             addLiquidity(liquidityTokens, ethForLiquidity);
1680             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1681         }
1682         
1683         // call twice to force buy of both reward tokens.
1684         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1685 
1686         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1687     }
1688 
1689     function withdrawStuckEth() external onlyOwner {
1690         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1691         require(success, "failed to withdraw");
1692     }
1693 
1694     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1695         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1696         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1697         lpWithdrawRequestTimestamp = block.timestamp;
1698         lpWithdrawRequestPending = true;
1699         lpPercToWithDraw = percToWithdraw;
1700         emit RequestedLPWithdraw();
1701     }
1702 
1703     function nextAvailableLpWithdrawDate() public view returns (uint256){
1704         if(lpWithdrawRequestPending){
1705             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1706         }
1707         else {
1708             return 0;  // 0 means no open requests
1709         }
1710     }
1711 
1712     function withdrawRequestedLP() external onlyOwner {
1713         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1714         lpWithdrawRequestTimestamp = 0;
1715         lpWithdrawRequestPending = false;
1716 
1717         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1718         
1719         lpPercToWithDraw = 0;
1720 
1721         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1722     }
1723 
1724     function cancelLPWithdrawRequest() external onlyOwner {
1725         lpWithdrawRequestPending = false;
1726         lpPercToWithDraw = 0;
1727         lpWithdrawRequestTimestamp = 0;
1728         emit CanceledLpWithdrawRequest();
1729     }
1730 }