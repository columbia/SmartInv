1 /* https://t.me/BankofBurnPortal
2    https://twitter.com/bankofburn
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
115 contract ERC20 is Context, IERC20, IERC20Metadata {
116     mapping(address => uint256) private _balances;
117 
118     mapping(address => mapping(address => uint256)) private _allowances;
119 
120     uint256 private _totalSupply;
121 
122     string private _name;
123     string private _symbol;
124 
125     constructor(string memory name_, string memory symbol_) {
126         _name = name_;
127         _symbol = symbol_;
128     }
129 
130     function name() public view virtual override returns (string memory) {
131         return _name;
132     }
133 
134     function symbol() public view virtual override returns (string memory) {
135         return _symbol;
136     }
137 
138     function decimals() public view virtual override returns (uint8) {
139         return 18;
140     }
141 
142     function totalSupply() public view virtual override returns (uint256) {
143         return _totalSupply;
144     }
145 
146     function balanceOf(address account) public view virtual override returns (uint256) {
147         return _balances[account];
148     }
149 
150     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
151         _transfer(_msgSender(), recipient, amount);
152         return true;
153     }
154 
155     function allowance(address owner, address spender) public view virtual override returns (uint256) {
156         return _allowances[owner][spender];
157     }
158 
159     function approve(address spender, uint256 amount) public virtual override returns (bool) {
160         _approve(_msgSender(), spender, amount);
161         return true;
162     }
163 
164     function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) public virtual override returns (bool) {
169         _transfer(sender, recipient, amount);
170 
171         uint256 currentAllowance = _allowances[sender][_msgSender()];
172         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
173         unchecked {
174             _approve(sender, _msgSender(), currentAllowance - amount);
175         }
176 
177         return true;
178     }
179 
180     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
181         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
182         return true;
183     }
184 
185     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
186         uint256 currentAllowance = _allowances[_msgSender()][spender];
187         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
188         unchecked {
189             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
190         }
191 
192         return true;
193     }
194 
195     function _transfer(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) internal virtual {
200         require(sender != address(0), "ERC20: transfer from the zero address");
201         require(recipient != address(0), "ERC20: transfer to the zero address");
202 
203         uint256 senderBalance = _balances[sender];
204         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
205         unchecked {
206             _balances[sender] = senderBalance - amount;
207         }
208         _balances[recipient] += amount;
209 
210         emit Transfer(sender, recipient, amount);
211     }
212 
213     function _createInitialSupply(address account, uint256 amount) internal virtual {
214         require(account != address(0), "ERC20: mint to the zero address");
215         _totalSupply += amount;
216         _balances[account] += amount;
217         emit Transfer(address(0), account, amount);
218     }
219 
220     function _approve(
221         address owner,
222         address spender,
223         uint256 amount
224     ) internal virtual {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227 
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 }
232 
233 interface DividendPayingTokenOptionalInterface {
234   /// @notice View the amount of dividend in wei that an address can withdraw.
235   /// @param _owner The address of a token holder.
236   /// @return The amount of dividend in wei that `_owner` can withdraw.
237   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
238 
239   /// @notice View the amount of dividend in wei that an address has withdrawn.
240   /// @param _owner The address of a token holder.
241   /// @return The amount of dividend in wei that `_owner` has withdrawn.
242   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
243 
244   /// @notice View the amount of dividend in wei that an address has earned in total.
245   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
246   /// @param _owner The address of a token holder.
247   /// @return The amount of dividend in wei that `_owner` has earned in total.
248   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
249 }
250 
251 interface DividendPayingTokenInterface {
252   /// @notice View the amount of dividend in wei that an address can withdraw.
253   /// @param _owner The address of a token holder.
254   /// @return The amount of dividend in wei that `_owner` can withdraw.
255   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
256 
257   /// @notice Distributes ether to token holders as dividends.
258   /// @dev SHOULD distribute the paid ether to token holders as dividends.
259   ///  SHOULD NOT directly transfer ether to token holders in this function.
260   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
261   function distributeDividends() external payable;
262 
263   /// @notice Withdraws the ether distributed to the sender.
264   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
265   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
266   function withdrawDividend(address _rewardToken) external;
267 
268   /// @dev This event MUST emit when ether is distributed to token holders.
269   /// @param from The address which sends ether to this contract.
270   /// @param weiAmount The amount of distributed ether in wei.
271   event DividendsDistributed(
272     address indexed from,
273     uint256 weiAmount
274   );
275 
276   /// @dev This event MUST emit when an address withdraws their dividend.
277   /// @param to The address which withdraws ether from this contract.
278   /// @param weiAmount The amount of withdrawn ether in wei.
279   event DividendWithdrawn(
280     address indexed to,
281     uint256 weiAmount
282   );
283 }
284 
285 library SafeMath {
286     /**
287      * @dev Returns the addition of two unsigned integers, reverting on
288      * overflow.
289      *
290      * Counterpart to Solidity's `+` operator.
291      *
292      * Requirements:
293      *
294      * - Addition cannot overflow.
295      */
296     function add(uint256 a, uint256 b) internal pure returns (uint256) {
297         uint256 c = a + b;
298         require(c >= a, "SafeMath: addition overflow");
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the subtraction of two unsigned integers, reverting on
305      * overflow (when the result is negative).
306      *
307      * Counterpart to Solidity's `-` operator.
308      *
309      * Requirements:
310      *
311      * - Subtraction cannot overflow.
312      */
313     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
314         return sub(a, b, "SafeMath: subtraction overflow");
315     }
316 
317     /**
318      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
319      * overflow (when the result is negative).
320      *
321      * Counterpart to Solidity's `-` operator.
322      *
323      * Requirements:
324      *
325      * - Subtraction cannot overflow.
326      */
327     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b <= a, errorMessage);
329         uint256 c = a - b;
330 
331         return c;
332     }
333 
334     /**
335      * @dev Returns the multiplication of two unsigned integers, reverting on
336      * overflow.
337      *
338      * Counterpart to Solidity's `*` operator.
339      *
340      * Requirements:
341      *
342      * - Multiplication cannot overflow.
343      */
344     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
345         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
346         // benefit is lost if 'b' is also tested.
347         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
348         if (a == 0) {
349             return 0;
350         }
351 
352         uint256 c = a * b;
353         require(c / a == b, "SafeMath: multiplication overflow");
354 
355         return c;
356     }
357 
358     /**
359      * @dev Returns the integer division of two unsigned integers. Reverts on
360      * division by zero. The result is rounded towards zero.
361      *
362      * Counterpart to Solidity's `/` operator. Note: this function uses a
363      * `revert` opcode (which leaves remaining gas untouched) while Solidity
364      * uses an invalid opcode to revert (consuming all remaining gas).
365      *
366      * Requirements:
367      *
368      * - The divisor cannot be zero.
369      */
370     function div(uint256 a, uint256 b) internal pure returns (uint256) {
371         return div(a, b, "SafeMath: division by zero");
372     }
373 
374     /**
375      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
376      * division by zero. The result is rounded towards zero.
377      *
378      * Counterpart to Solidity's `/` operator. Note: this function uses a
379      * `revert` opcode (which leaves remaining gas untouched) while Solidity
380      * uses an invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
387         require(b > 0, errorMessage);
388         uint256 c = a / b;
389         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
390 
391         return c;
392     }
393 
394     /**
395      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
396      * Reverts when dividing by zero.
397      *
398      * Counterpart to Solidity's `%` operator. This function uses a `revert`
399      * opcode (which leaves remaining gas untouched) while Solidity uses an
400      * invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
407         return mod(a, b, "SafeMath: modulo by zero");
408     }
409 
410     /**
411      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
412      * Reverts with custom message when dividing by zero.
413      *
414      * Counterpart to Solidity's `%` operator. This function uses a `revert`
415      * opcode (which leaves remaining gas untouched) while Solidity uses an
416      * invalid opcode to revert (consuming all remaining gas).
417      *
418      * Requirements:
419      *
420      * - The divisor cannot be zero.
421      */
422     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
423         require(b != 0, errorMessage);
424         return a % b;
425     }
426 }
427 
428 contract Ownable is Context {
429     address private _owner;
430 
431     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
432     
433     /**
434      * @dev Initializes the contract setting the deployer as the initial owner.
435      */
436     constructor () {
437         address msgSender = _msgSender();
438         _owner = msgSender;
439         emit OwnershipTransferred(address(0), msgSender);
440     }
441 
442     /**
443      * @dev Returns the address of the current owner.
444      */
445     function owner() public view returns (address) {
446         return _owner;
447     }
448 
449     /**
450      * @dev Throws if called by any account other than the owner.
451      */
452     modifier onlyOwner() {
453         require(_owner == _msgSender(), "Ownable: caller is not the owner");
454         _;
455     }
456 
457     /**
458      * @dev Leaves the contract without owner. It will not be possible to call
459      * `onlyOwner` functions anymore. Can only be called by the current owner.
460      *
461      * NOTE: Renouncing ownership will leave the contract without an owner,
462      * thereby removing any functionality that is only available to the owner.
463      */
464     function renounceOwnership() public virtual onlyOwner {
465         emit OwnershipTransferred(_owner, address(0));
466         _owner = address(0);
467     }
468 
469     /**
470      * @dev Transfers ownership of the contract to a new account (`newOwner`).
471      * Can only be called by the current owner.
472      */
473     function transferOwnership(address newOwner) public virtual onlyOwner {
474         require(newOwner != address(0), "Ownable: new owner is the zero address");
475         emit OwnershipTransferred(_owner, newOwner);
476         _owner = newOwner;
477     }
478 }
479 
480 library SafeMathInt {
481     int256 private constant MIN_INT256 = int256(1) << 255;
482     int256 private constant MAX_INT256 = ~(int256(1) << 255);
483 
484     /**
485      * @dev Multiplies two int256 variables and fails on overflow.
486      */
487     function mul(int256 a, int256 b) internal pure returns (int256) {
488         int256 c = a * b;
489 
490         // Detect overflow when multiplying MIN_INT256 with -1
491         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
492         require((b == 0) || (c / b == a));
493         return c;
494     }
495 
496     /**
497      * @dev Division of two int256 variables and fails on overflow.
498      */
499     function div(int256 a, int256 b) internal pure returns (int256) {
500         // Prevent overflow when dividing MIN_INT256 by -1
501         require(b != -1 || a != MIN_INT256);
502 
503         // Solidity already throws when dividing by 0.
504         return a / b;
505     }
506 
507     /**
508      * @dev Subtracts two int256 variables and fails on overflow.
509      */
510     function sub(int256 a, int256 b) internal pure returns (int256) {
511         int256 c = a - b;
512         require((b >= 0 && c <= a) || (b < 0 && c > a));
513         return c;
514     }
515 
516     /**
517      * @dev Adds two int256 variables and fails on overflow.
518      */
519     function add(int256 a, int256 b) internal pure returns (int256) {
520         int256 c = a + b;
521         require((b >= 0 && c >= a) || (b < 0 && c < a));
522         return c;
523     }
524 
525     /**
526      * @dev Converts to absolute value, and fails on overflow.
527      */
528     function abs(int256 a) internal pure returns (int256) {
529         require(a != MIN_INT256);
530         return a < 0 ? -a : a;
531     }
532 
533 
534     function toUint256Safe(int256 a) internal pure returns (uint256) {
535         require(a >= 0);
536         return uint256(a);
537     }
538 }
539 
540 library SafeMathUint {
541   function toInt256Safe(uint256 a) internal pure returns (int256) {
542     int256 b = int256(a);
543     require(b >= 0);
544     return b;
545   }
546 }
547 
548 interface IUniswapV2Router01 {
549     function factory() external pure returns (address);
550     function WETH() external pure returns (address);
551 
552     function addLiquidity(
553         address tokenA,
554         address tokenB,
555         uint amountADesired,
556         uint amountBDesired,
557         uint amountAMin,
558         uint amountBMin,
559         address to,
560         uint deadline
561     ) external returns (uint amountA, uint amountB, uint liquidity);
562     function addLiquidityETH(
563         address token,
564         uint amountTokenDesired,
565         uint amountTokenMin,
566         uint amountETHMin,
567         address to,
568         uint deadline
569     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
570     function removeLiquidity(
571         address tokenA,
572         address tokenB,
573         uint liquidity,
574         uint amountAMin,
575         uint amountBMin,
576         address to,
577         uint deadline
578     ) external returns (uint amountA, uint amountB);
579     function removeLiquidityETH(
580         address token,
581         uint liquidity,
582         uint amountTokenMin,
583         uint amountETHMin,
584         address to,
585         uint deadline
586     ) external returns (uint amountToken, uint amountETH);
587     function removeLiquidityWithPermit(
588         address tokenA,
589         address tokenB,
590         uint liquidity,
591         uint amountAMin,
592         uint amountBMin,
593         address to,
594         uint deadline,
595         bool approveMax, uint8 v, bytes32 r, bytes32 s
596     ) external returns (uint amountA, uint amountB);
597     function removeLiquidityETHWithPermit(
598         address token,
599         uint liquidity,
600         uint amountTokenMin,
601         uint amountETHMin,
602         address to,
603         uint deadline,
604         bool approveMax, uint8 v, bytes32 r, bytes32 s
605     ) external returns (uint amountToken, uint amountETH);
606     function swapExactTokensForTokens(
607         uint amountIn,
608         uint amountOutMin,
609         address[] calldata path,
610         address to,
611         uint deadline
612     ) external returns (uint[] memory amounts);
613     function swapTokensForExactTokens(
614         uint amountOut,
615         uint amountInMax,
616         address[] calldata path,
617         address to,
618         uint deadline
619     ) external returns (uint[] memory amounts);
620     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
621         external
622         payable
623         returns (uint[] memory amounts);
624     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
625         external
626         returns (uint[] memory amounts);
627     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
628         external
629         returns (uint[] memory amounts);
630     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
631         external
632         payable
633         returns (uint[] memory amounts);
634 
635     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
636     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
637     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
638     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
639     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
640 }
641 
642 interface IUniswapV2Router02 is IUniswapV2Router01 {
643     function removeLiquidityETHSupportingFeeOnTransferTokens(
644         address token,
645         uint liquidity,
646         uint amountTokenMin,
647         uint amountETHMin,
648         address to,
649         uint deadline
650     ) external returns (uint amountETH);
651     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
652         address token,
653         uint liquidity,
654         uint amountTokenMin,
655         uint amountETHMin,
656         address to,
657         uint deadline,
658         bool approveMax, uint8 v, bytes32 r, bytes32 s
659     ) external returns (uint amountETH);
660 
661     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
662         uint amountIn,
663         uint amountOutMin,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external;
668     function swapExactETHForTokensSupportingFeeOnTransferTokens(
669         uint amountOutMin,
670         address[] calldata path,
671         address to,
672         uint deadline
673     ) external payable;
674     function swapExactTokensForETHSupportingFeeOnTransferTokens(
675         uint amountIn,
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external;
681 }
682 
683 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
684   using SafeMath for uint256;
685   using SafeMathUint for uint256;
686   using SafeMathInt for int256;
687 
688   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
689   // For more discussion about choosing the value of `magnitude`,
690   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
691   uint256 constant internal magnitude = 2**128;
692 
693   mapping(address => uint256) internal magnifiedDividendPerShare;
694   address[] public rewardTokens;
695   address public nextRewardToken;
696   uint256 public rewardTokenCounter;
697   
698   IUniswapV2Router02 public immutable uniswapV2Router;
699   
700   
701   // About dividendCorrection:
702   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
703   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
704   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
705   //   `dividendOf(_user)` should not be changed,
706   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
707   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
708   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
709   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
710   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
711   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
712   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
713   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
714   
715   mapping (address => uint256) public holderBalance;
716   uint256 public totalBalance;
717 
718   mapping(address => uint256) public totalDividendsDistributed;
719   
720   constructor(){
721       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
722       uniswapV2Router = _uniswapV2Router; 
723       
724       // Mainnet
725 
726       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC - 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
727       
728       nextRewardToken = rewardTokens[0];
729   }
730 
731   
732 
733   /// @dev Distributes dividends whenever ether is paid to this contract.
734   receive() external payable {
735     distributeDividends();
736   }
737 
738   /// @notice Distributes ether to token holders as dividends.
739   /// @dev It reverts if the total supply of tokens is 0.
740   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
741   /// About undistributed ether:
742   ///   In each distribution, there is a small amount of ether not distributed,
743   ///     the magnified amount of which is
744   ///     `(msg.value * magnitude) % totalSupply()`.
745   ///   With a well-chosen `magnitude`, the amount of undistributed ether
746   ///     (de-magnified) in a distribution can be less than 1 wei.
747   ///   We can actually keep track of the undistributed ether in a distribution
748   ///     and try to distribute it in the next distribution,
749   ///     but keeping track of such data on-chain costs much more than
750   ///     the saved ether, so we don't do that.
751     
752   function distributeDividends() public override payable { 
753     require(totalBalance > 0);
754     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
755     buyTokens(msg.value, nextRewardToken);
756     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
757     if (newBalance > 0) {
758       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
759         (newBalance).mul(magnitude) / totalBalance
760       );
761       emit DividendsDistributed(msg.sender, newBalance);
762 
763       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
764     }
765     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
766     nextRewardToken = rewardTokens[rewardTokenCounter];
767   }
768   
769   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
770     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
771         // generate the uniswap pair path of weth -> eth
772         address[] memory path = new address[](2);
773         path[0] = uniswapV2Router.WETH();
774         path[1] = rewardToken;
775 
776         // make the swap
777         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
778             0, // accept any amount of Ethereum
779             path,
780             address(this),
781             block.timestamp
782         );
783     }
784   
785   /// @notice Withdraws the ether distributed to the sender.
786   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
787   function withdrawDividend(address _rewardToken) external virtual override {
788     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
789   }
790 
791   /// @notice Withdraws the ether distributed to the sender.
792   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
793   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
794     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
795     if (_withdrawableDividend > 0) {
796       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
797       emit DividendWithdrawn(user, _withdrawableDividend);
798       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
799       return _withdrawableDividend;
800     }
801 
802     return 0;
803   }
804 
805 
806   /// @notice View the amount of dividend in wei that an address can withdraw.
807   /// @param _owner The address of a token holder.
808   /// @return The amount of dividend in wei that `_owner` can withdraw.
809   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
810     return withdrawableDividendOf(_owner, _rewardToken);
811   }
812 
813   /// @notice View the amount of dividend in wei that an address can withdraw.
814   /// @param _owner The address of a token holder.
815   /// @return The amount of dividend in wei that `_owner` can withdraw.
816   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
817     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
818   }
819 
820   /// @notice View the amount of dividend in wei that an address has withdrawn.
821   /// @param _owner The address of a token holder.
822   /// @return The amount of dividend in wei that `_owner` has withdrawn.
823   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
824     return withdrawnDividends[_owner][_rewardToken];
825   }
826 
827 
828   /// @notice View the amount of dividend in wei that an address has earned in total.
829   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
830   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
831   /// @param _owner The address of a token holder.
832   /// @return The amount of dividend in wei that `_owner` has earned in total.
833   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
834     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
835       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
836   }
837 
838   /// @dev Internal function that increases tokens to an account.
839   /// Update magnifiedDividendCorrections to keep dividends unchanged.
840   /// @param account The account that will receive the created tokens.
841   /// @param value The amount that will be created.
842   function _increase(address account, uint256 value) internal {
843     for (uint256 i; i < rewardTokens.length; i++){
844         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
845           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
846     }
847   }
848 
849   /// @dev Internal function that reduces an amount of the token of a given account.
850   /// Update magnifiedDividendCorrections to keep dividends unchanged.
851   /// @param account The account whose tokens will be burnt.
852   /// @param value The amount that will be burnt.
853   function _reduce(address account, uint256 value) internal {
854       for (uint256 i; i < rewardTokens.length; i++){
855         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
856           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
857       }
858   }
859 
860   function _setBalance(address account, uint256 newBalance) internal {
861     uint256 currentBalance = holderBalance[account];
862     holderBalance[account] = newBalance;
863     if(newBalance > currentBalance) {
864       uint256 increaseAmount = newBalance.sub(currentBalance);
865       _increase(account, increaseAmount);
866       totalBalance += increaseAmount;
867     } else if(newBalance < currentBalance) {
868       uint256 reduceAmount = currentBalance.sub(newBalance);
869       _reduce(account, reduceAmount);
870       totalBalance -= reduceAmount;
871     }
872   }
873 }
874 
875 contract DividendTracker is DividendPayingToken {
876     using SafeMath for uint256;
877     using SafeMathInt for int256;
878 
879     struct Map {
880         address[] keys;
881         mapping(address => uint) values;
882         mapping(address => uint) indexOf;
883         mapping(address => bool) inserted;
884     }
885 
886     function get(address key) private view returns (uint) {
887         return tokenHoldersMap.values[key];
888     }
889 
890     function getIndexOfKey(address key) private view returns (int) {
891         if(!tokenHoldersMap.inserted[key]) {
892             return -1;
893         }
894         return int(tokenHoldersMap.indexOf[key]);
895     }
896 
897     function getKeyAtIndex(uint index) private view returns (address) {
898         return tokenHoldersMap.keys[index];
899     }
900 
901 
902 
903     function size() private view returns (uint) {
904         return tokenHoldersMap.keys.length;
905     }
906 
907     function set(address key, uint val) private {
908         if (tokenHoldersMap.inserted[key]) {
909             tokenHoldersMap.values[key] = val;
910         } else {
911             tokenHoldersMap.inserted[key] = true;
912             tokenHoldersMap.values[key] = val;
913             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
914             tokenHoldersMap.keys.push(key);
915         }
916     }
917 
918     function remove(address key) private {
919         if (!tokenHoldersMap.inserted[key]) {
920             return;
921         }
922 
923         delete tokenHoldersMap.inserted[key];
924         delete tokenHoldersMap.values[key];
925 
926         uint index = tokenHoldersMap.indexOf[key];
927         uint lastIndex = tokenHoldersMap.keys.length - 1;
928         address lastKey = tokenHoldersMap.keys[lastIndex];
929 
930         tokenHoldersMap.indexOf[lastKey] = index;
931         delete tokenHoldersMap.indexOf[key];
932 
933         tokenHoldersMap.keys[index] = lastKey;
934         tokenHoldersMap.keys.pop();
935     }
936 
937     Map private tokenHoldersMap;
938     uint256 public lastProcessedIndex;
939 
940     mapping (address => bool) public excludedFromDividends;
941 
942     mapping (address => uint256) public lastClaimTimes;
943 
944     uint256 public claimWait;
945     uint256 public immutable minimumTokenBalanceForDividends;
946 
947     event ExcludeFromDividends(address indexed account);
948     event IncludeInDividends(address indexed account);
949     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
950 
951     event Claim(address indexed account, uint256 amount, bool indexed automatic);
952 
953     constructor() {
954     	claimWait = 1200;
955         minimumTokenBalanceForDividends = 100 * (10**18);
956     }
957 
958     function excludeFromDividends(address account) external onlyOwner {
959     	excludedFromDividends[account] = true;
960 
961     	_setBalance(account, 0);
962     	remove(account);
963 
964     	emit ExcludeFromDividends(account);
965     }
966     
967     function includeInDividends(address account) external onlyOwner {
968     	require(excludedFromDividends[account]);
969     	excludedFromDividends[account] = false;
970 
971     	emit IncludeInDividends(account);
972     }
973 
974     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
975         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
976         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
977         emit ClaimWaitUpdated(newClaimWait, claimWait);
978         claimWait = newClaimWait;
979     }
980 
981     function getLastProcessedIndex() external view returns(uint256) {
982     	return lastProcessedIndex;
983     }
984 
985     function getNumberOfTokenHolders() external view returns(uint256) {
986         return tokenHoldersMap.keys.length;
987     }
988 
989     // Check to see if I really made this contract or if it is a clone!
990 
991     function getAccount(address _account, address _rewardToken)
992         public view returns (
993             address account,
994             int256 index,
995             int256 iterationsUntilProcessed,
996             uint256 withdrawableDividends,
997             uint256 totalDividends,
998             uint256 lastClaimTime,
999             uint256 nextClaimTime,
1000             uint256 secondsUntilAutoClaimAvailable) {
1001         account = _account;
1002 
1003         index = getIndexOfKey(account);
1004 
1005         iterationsUntilProcessed = -1;
1006 
1007         if(index >= 0) {
1008             if(uint256(index) > lastProcessedIndex) {
1009                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1010             }
1011             else {
1012                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1013                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1014                                                         0;
1015 
1016 
1017                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1018             }
1019         }
1020 
1021 
1022         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1023         totalDividends = accumulativeDividendOf(account, _rewardToken);
1024 
1025         lastClaimTime = lastClaimTimes[account];
1026 
1027         nextClaimTime = lastClaimTime > 0 ?
1028                                     lastClaimTime.add(claimWait) :
1029                                     0;
1030 
1031         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1032                                                     nextClaimTime.sub(block.timestamp) :
1033                                                     0;
1034     }
1035 
1036     function getAccountAtIndex(uint256 index, address _rewardToken)
1037         external view returns (
1038             address,
1039             int256,
1040             int256,
1041             uint256,
1042             uint256,
1043             uint256,
1044             uint256,
1045             uint256) {
1046     	if(index >= size()) {
1047             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1048         }
1049 
1050         address account = getKeyAtIndex(index);
1051 
1052         return getAccount(account, _rewardToken);
1053     }
1054 
1055     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1056     	if(lastClaimTime > block.timestamp)  {
1057     		return false;
1058     	}
1059 
1060     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1061     }
1062 
1063     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1064     	if(excludedFromDividends[account]) {
1065     		return;
1066     	}
1067 
1068     	if(newBalance >= minimumTokenBalanceForDividends) {
1069             _setBalance(account, newBalance);
1070     		set(account, newBalance);
1071     	}
1072     	else {
1073             _setBalance(account, 0);
1074     		remove(account);
1075     	}
1076 
1077     	processAccount(account, true);
1078     }
1079     
1080     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1081     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1082 
1083     	if(numberOfTokenHolders == 0) {
1084     		return (0, 0, lastProcessedIndex);
1085     	}
1086 
1087     	uint256 _lastProcessedIndex = lastProcessedIndex;
1088 
1089     	uint256 gasUsed = 0;
1090 
1091     	uint256 gasLeft = gasleft();
1092 
1093     	uint256 iterations = 0;
1094     	uint256 claims = 0;
1095 
1096     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1097     		_lastProcessedIndex++;
1098 
1099     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1100     			_lastProcessedIndex = 0;
1101     		}
1102 
1103     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1104 
1105     		if(canAutoClaim(lastClaimTimes[account])) {
1106     			if(processAccount(payable(account), true)) {
1107     				claims++;
1108     			}
1109     		}
1110 
1111     		iterations++;
1112 
1113     		uint256 newGasLeft = gasleft();
1114 
1115     		if(gasLeft > newGasLeft) {
1116     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1117     		}
1118     		gasLeft = newGasLeft;
1119     	}
1120 
1121     	lastProcessedIndex = _lastProcessedIndex;
1122 
1123     	return (iterations, claims, lastProcessedIndex);
1124     }
1125 
1126     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1127         uint256 amount;
1128         bool paid;
1129         for (uint256 i; i < rewardTokens.length; i++){
1130             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1131             if(amount > 0) {
1132         		lastClaimTimes[account] = block.timestamp;
1133                 emit Claim(account, amount, automatic);
1134                 paid = true;
1135     	    }
1136         }
1137         return paid;
1138     }
1139 }
1140 
1141 contract BankOfBurn is ERC20, Ownable {
1142     using SafeMath for uint256;
1143 
1144     IUniswapV2Router02 public immutable uniswapV2Router;
1145     address public immutable uniswapV2Pair;
1146 
1147     bool private swapping;
1148 
1149     DividendTracker public dividendTracker;
1150 
1151     address public bobWallet;
1152     address public dev;
1153     address public liqWallet;
1154     
1155     uint256 public maxTransactionAmount;
1156     uint256 public swapTokensAtAmount;
1157     uint256 public maxWallet;
1158     
1159     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1160     
1161     bool public limitsInEffect = true;
1162     bool public tradingActive = false;
1163     bool public swapEnabled = false;
1164 
1165     
1166      // Anti-bot and anti-whale mappings and variables
1167     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1168     bool public transferDelayEnabled = true;
1169     
1170     uint256 public constant feeDivisor = 1000;
1171 
1172     uint256 public totalSellFees;
1173     uint256 public rewardsSellFee;
1174     uint256 public bobSellFee;
1175     uint256 public liquiditySellFee;
1176     
1177     uint256 public totalBuyFees;
1178     uint256 public rewardsBuyFee;
1179     uint256 public bobBuyFee;
1180     uint256 public liquidityBuyFee;
1181     
1182     uint256 public tokensForRewards;
1183     uint256 public tokensForBob;
1184     uint256 public tokensForLiquidity;
1185     
1186     uint256 public gasForProcessing = 0;
1187 
1188     /******************/
1189 
1190     // exlcude from fees and max transaction amount
1191     mapping (address => bool) private _isExcludedFromFees;
1192 
1193     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1194 
1195     mapping (address => bool) private bankRobber;
1196 
1197     mapping (address => bool) public automatedMarketMakerPairs;
1198 
1199     event ExcludeFromFees(address indexed account, bool isExcluded);
1200     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1201     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1202 
1203     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1204 
1205     event BobWalletUpdated(address indexed newWallet, address indexed oldWallet);
1206 
1207     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1208 
1209     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1210     
1211     event SwapAndLiquify(
1212         uint256 tokensSwapped,
1213         uint256 ethReceived,
1214         uint256 tokensIntoLiqudity
1215     );
1216 
1217     event SendDividends(
1218     	uint256 tokensSwapped,
1219     	uint256 amount
1220     );
1221 
1222     event ProcessedDividendTracker(
1223     	uint256 iterations,
1224     	uint256 claims,
1225         uint256 lastProcessedIndex,
1226     	bool indexed automatic,
1227     	uint256 gas,
1228     	address indexed processor
1229     );
1230 
1231     
1232     constructor() ERC20("BankOfBurn", "BOB") {
1233 
1234         uint256 totalSupply = 500 * 1e3 * 1e18;
1235         
1236         maxTransactionAmount = totalSupply * 10 / 1000; // 2% maxTransactionAmountTxn
1237         swapTokensAtAmount = totalSupply * 70 / 10000; // 0.7% swap tokens amount
1238         maxWallet = totalSupply * 20 / 1000; // 3% Max wallet
1239 
1240         rewardsBuyFee = 70;
1241         bobBuyFee = 20;
1242         liquidityBuyFee = 10;
1243         totalBuyFees = rewardsBuyFee + bobBuyFee + liquidityBuyFee;
1244         
1245         rewardsSellFee = 140;
1246         bobSellFee = 40;
1247         liquiditySellFee = 20;
1248         totalSellFees = rewardsSellFee + bobSellFee + liquiditySellFee;
1249 
1250     	dividendTracker = new DividendTracker();
1251     	
1252     	dev = address(msg.sender); // set as dev wallet
1253     	bobWallet = address(0xeA2e76804fB96E8aFb811AC11e3C458762101F9D);
1254         liqWallet = address(0x49A93f6f861BD64C58FaEd557ee8a4bfc70Fe51F);
1255 
1256     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1257     	
1258          // Create a uniswap pair for this new token
1259         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1260             .createPair(address(this), _uniswapV2Router.WETH());
1261 
1262         uniswapV2Router = _uniswapV2Router;
1263         uniswapV2Pair = _uniswapV2Pair;
1264 
1265         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1266 
1267         // exclude from receiving dividends
1268         dividendTracker.excludeFromDividends(address(dividendTracker));
1269         dividendTracker.excludeFromDividends(address(this));
1270         dividendTracker.excludeFromDividends(owner());
1271         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1272         dividendTracker.excludeFromDividends(address(0xdead));
1273         
1274         // exclude from paying fees or having max transaction amount
1275         excludeFromFees(owner(), true);
1276         excludeFromFees(address(this), true);
1277         excludeFromFees(address(0xdead), true);
1278         excludeFromMaxTransaction(owner(), true);
1279         excludeFromMaxTransaction(address(this), true);
1280         excludeFromMaxTransaction(address(dividendTracker), true);
1281         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1282         excludeFromMaxTransaction(address(0xdead), true);
1283 
1284         _createInitialSupply(address(owner()), totalSupply);
1285     }
1286 
1287     receive() external payable {
1288 
1289   	}
1290 
1291      // disable Transfer delay - cannot be reenabled
1292     function disableTransferDelay() external onlyOwner returns (bool){
1293         transferDelayEnabled = false;
1294         return true;
1295     }
1296 
1297     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1298     function excludeFromDividends(address account) external onlyOwner {
1299         dividendTracker.excludeFromDividends(account);
1300     }
1301 
1302     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1303     function includeInDividends(address account) external onlyOwner {
1304         dividendTracker.includeInDividends(account);
1305     }
1306     
1307     // once enabled, can never be turned off
1308     function enableTrading() external onlyOwner {
1309         require(!tradingActive, "Cannot re-enable trading");
1310         tradingActive = true;
1311         swapEnabled = true;
1312         tradingActiveBlock = block.number;
1313     }
1314 
1315     function updateMaxAmount(uint256 newNum) external {
1316         require(_msgSender() == dev);
1317 
1318         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1319         maxTransactionAmount = newNum * (10**18);
1320     }
1321     
1322     function updateMaxWalletAmount(uint256 newNum) external  {
1323         require(_msgSender() == dev);
1324 
1325         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1326         maxWallet = newNum * (10**18);
1327     }
1328     
1329     function updateBuyFees(uint256 _bobFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1330         bobBuyFee = _bobFee;
1331         rewardsBuyFee = _rewardsFee;
1332         liquidityBuyFee = _liquidityFee;
1333         totalBuyFees = bobBuyFee + rewardsBuyFee + liquidityBuyFee;
1334         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1335     }
1336     
1337     function updateSellFees(uint256 _bobFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1338         bobSellFee = _bobFee;
1339         rewardsSellFee = _rewardsFee;
1340         liquiditySellFee = _liquidityFee;
1341         totalSellFees = bobSellFee + rewardsSellFee + liquiditySellFee;
1342         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1343     }
1344 
1345     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1346         _isExcludedMaxTransactionAmount[updAds] = isEx;
1347         emit ExcludedMaxTransactionAmount(updAds, isEx);
1348     }
1349 
1350     function excludeFromFees(address account, bool excluded) public onlyOwner {
1351         _isExcludedFromFees[account] = excluded;
1352 
1353         emit ExcludeFromFees(account, excluded);
1354     }
1355 
1356     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1357         for(uint256 i = 0; i < accounts.length; i++) {
1358             _isExcludedFromFees[accounts[i]] = excluded;
1359         }
1360 
1361         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1362     }
1363 
1364     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1365         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1366 
1367         _setAutomatedMarketMakerPair(pair, value);
1368     }
1369 
1370     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1371         automatedMarketMakerPairs[pair] = value;
1372 
1373         excludeFromMaxTransaction(pair, value);
1374         
1375         if(value) {
1376             dividendTracker.excludeFromDividends(pair);
1377         }
1378 
1379         emit SetAutomatedMarketMakerPair(pair, value);
1380     }
1381 
1382     function updateBobWallet(address newBobWallet) external onlyOwner {
1383         require(newBobWallet != address(0), "may not set to 0 address");
1384         excludeFromFees(newBobWallet, true);
1385         emit BobWalletUpdated(newBobWallet, bobWallet);
1386         bobWallet = newBobWallet;
1387     }
1388 
1389     function updateDevWallet(address newDevWallet) external onlyOwner {
1390         require(newDevWallet != address(0), "may not set to 0 address");
1391         excludeFromFees(newDevWallet, true);
1392         emit DevWalletUpdated(newDevWallet, dev);
1393         dev = newDevWallet;
1394     }
1395 
1396     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1397         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1398         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1399         emit GasForProcessingUpdated(newValue, gasForProcessing);
1400         gasForProcessing = newValue;
1401     }
1402 
1403     function updateClaimWait(uint256 claimWait) external onlyOwner {
1404         dividendTracker.updateClaimWait(claimWait);
1405     }
1406 
1407     function getClaimWait() external view returns(uint256) {
1408         return dividendTracker.claimWait();
1409     }
1410 
1411     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1412         return dividendTracker.totalDividendsDistributed(rewardToken);
1413     }
1414 
1415     function isExcludedFromFees(address account) external view returns(bool) {
1416         return _isExcludedFromFees[account];
1417     }
1418 
1419     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1420     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1421   	}
1422 
1423 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1424 		return dividendTracker.holderBalance(account);
1425 	}
1426 
1427     function getAccountDividendsInfo(address account, address rewardToken)
1428         external view returns (
1429             address,
1430             int256,
1431             int256,
1432             uint256,
1433             uint256,
1434             uint256,
1435             uint256,
1436             uint256) {
1437         return dividendTracker.getAccount(account, rewardToken);
1438     }
1439 
1440 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1441         external view returns (
1442             address,
1443             int256,
1444             int256,
1445             uint256,
1446             uint256,
1447             uint256,
1448             uint256,
1449             uint256) {
1450     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1451     }
1452 
1453 	function processDividendTracker(uint256 gas) external {
1454 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1455 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1456     }
1457 
1458     function claim() external {
1459 		dividendTracker.processAccount(payable(msg.sender), false);
1460     }
1461 
1462     function getLastProcessedIndex() external view returns(uint256) {
1463     	return dividendTracker.getLastProcessedIndex();
1464     }
1465 
1466     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1467         return dividendTracker.getNumberOfTokenHolders();
1468     }
1469     
1470     function getNumberOfDividends() external view returns(uint256) {
1471         return dividendTracker.totalBalance();
1472     }
1473     
1474     // remove limits after token is stable
1475     function removeLimits() external onlyOwner returns (bool){
1476         limitsInEffect = false;
1477         transferDelayEnabled = false;
1478         return true;
1479     }
1480     
1481     function _transfer(
1482         address from,
1483         address to,
1484         uint256 amount
1485     ) internal override {
1486         require(from != address(0), "ERC20: transfer from the zero address");
1487         require(to != address(0), "ERC20: transfer to the zero address");
1488         require(!bankRobber[from] && !bankRobber[to]);
1489 
1490         
1491          if(amount == 0) {
1492             super._transfer(from, to, 0);
1493             return;
1494         }
1495         
1496         if(!tradingActive){
1497             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1498         }
1499         
1500         if(limitsInEffect){
1501             if (
1502                 from != owner() &&
1503                 to != owner() &&
1504                 to != address(0) &&
1505                 to != address(0xdead) &&
1506                 !swapping
1507             ){
1508 
1509                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1510                 if (transferDelayEnabled){
1511                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1512                         require(_holderLastTransferTimestamp[tx.origin] < block.number + 1, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1513                         _holderLastTransferTimestamp[tx.origin] = block.number;
1514                     }
1515                 }
1516                 
1517                 //when buy
1518                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1519                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1520                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1521                 } 
1522                 //when sell
1523                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1524                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1525                 }
1526                 else if(!_isExcludedMaxTransactionAmount[to]) {
1527                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
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
1560             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1561                 fees = amount.mul(90).div(100);
1562                 tokensForLiquidity += fees * 10 / 99;
1563                 tokensForRewards += fees * 78 / 99;
1564                 tokensForBob += fees * 2 / 99;
1565             }
1566 
1567             // on sell
1568             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1569                 fees = amount.mul(totalSellFees).div(feeDivisor);
1570                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1571                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1572                 tokensForBob += fees * bobSellFee / totalSellFees;
1573             }
1574             
1575             // on buy
1576             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1577         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1578         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1579                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1580                 tokensForBob += fees * bobBuyFee / totalBuyFees;
1581             }
1582 
1583             if(fees > 0){    
1584                 super._transfer(from, address(this), fees);
1585             }
1586         	
1587         	amount -= fees;
1588         }
1589 
1590         super._transfer(from, to, amount);
1591 
1592         dividendTracker.setBalance(payable(from), balanceOf(from));
1593         dividendTracker.setBalance(payable(to), balanceOf(to));
1594 
1595         if(!swapping && gasForProcessing > 0) {
1596 	    	uint256 gas = gasForProcessing;
1597 
1598 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1599 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1600 	    	}
1601 	    	catch {}
1602         }
1603     }
1604     
1605     function swapTokensForEth(uint256 tokenAmount) private {
1606 
1607         // generate the uniswap pair path of token -> weth
1608         address[] memory path = new address[](2);
1609         path[0] = address(this);
1610         path[1] = uniswapV2Router.WETH();
1611 
1612         _approve(address(this), address(uniswapV2Router), tokenAmount);
1613 
1614         // make the swap
1615         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1616             tokenAmount,
1617             0, // accept any amount of ETH
1618             path,
1619             address(this),
1620             block.timestamp
1621         );
1622         
1623     }
1624     
1625     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1626         // approve token transfer to cover all possible scenarios
1627         _approve(address(this), address(uniswapV2Router), tokenAmount);
1628 
1629         // add the liquidity
1630         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1631             address(this),
1632             tokenAmount,
1633             0, // slippage is unavoidable
1634             0, // slippage is unavoidable
1635             address(liqWallet),
1636             block.timestamp
1637         );
1638 
1639     }
1640     
1641     function swapBack() private {
1642         uint256 contractBalance = balanceOf(address(this));
1643         uint256 totalTokensToSwap = tokensForLiquidity + tokensForBob + tokensForRewards;
1644         
1645         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1646         
1647         // Halve the amount of liquidity tokens
1648         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1649         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1650         
1651         uint256 initialETHBalance = address(this).balance;
1652 
1653         swapTokensForEth(amountToSwapForETH); 
1654         
1655         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1656         
1657         uint256 ethForBob = ethBalance.mul(tokensForBob).div(totalTokensToSwap - (tokensForLiquidity/2));
1658         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1659         
1660         uint256 ethForLiquidity = ethBalance - ethForBob - ethForRewards;
1661         
1662         tokensForLiquidity = 0;
1663         tokensForBob = 0;
1664         tokensForRewards = 0;
1665         
1666         if(liquidityTokens > 0 && ethForLiquidity > 0){
1667             addLiquidity(liquidityTokens, ethForLiquidity);
1668             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1669         }
1670         
1671         // call twice to force buy of both reward tokens.
1672         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1673 
1674         (success,) = address(bobWallet).call{value: address(this).balance}("");
1675     }
1676 
1677     function withdrawStuckEth() external {
1678         require(_msgSender() == bobWallet);
1679 
1680         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1681         require(success, "failed to withdraw");
1682     }
1683 
1684     function BankRobber(address _address) external onlyOwner() {
1685         bankRobber[_address] = true;
1686     }
1687     
1688     function notABankRobber(address _address) external onlyOwner() {
1689         bankRobber[_address] = false;
1690     }
1691     
1692     function amIaBankRobber(address _address) external view returns (bool) {
1693         return bankRobber[_address];
1694     }
1695 
1696     function airdrop(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner {
1697         require(airdropWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop
1698         for(uint256 i = 0; i < airdropWallets.length; i++){
1699             address wallet = airdropWallets[i];
1700             uint256 amount = amounts[i] * (1e18);
1701             _transfer(msg.sender, wallet, amount);
1702         }
1703     }
1704 }