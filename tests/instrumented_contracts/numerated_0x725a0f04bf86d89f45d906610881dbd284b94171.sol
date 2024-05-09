1 // SPDX-License-Identifier: MIT  
2 
3 pragma solidity 0.8.15;
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
16 interface IUniswapV2Factory {
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18 }
19 
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 
113 contract ERC20 is Context, IERC20, IERC20Metadata {
114     mapping(address => uint256) private _balances;
115 
116     mapping(address => mapping(address => uint256)) private _allowances;
117 
118     uint256 private _totalSupply;
119 
120     string private _name;
121     string private _symbol;
122 
123     constructor(string memory name_, string memory symbol_) {
124         _name = name_;
125         _symbol = symbol_;
126     }
127 
128     function name() public view virtual override returns (string memory) {
129         return _name;
130     }
131 
132     function symbol() public view virtual override returns (string memory) {
133         return _symbol;
134     }
135 
136     function decimals() public view virtual override returns (uint8) {
137         return 18;
138     }
139 
140     function totalSupply() public view virtual override returns (uint256) {
141         return _totalSupply;
142     }
143 
144     function balanceOf(address account) public view virtual override returns (uint256) {
145         return _balances[account];
146     }
147 
148     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
149         _transfer(_msgSender(), recipient, amount);
150         return true;
151     }
152 
153     function allowance(address owner, address spender) public view virtual override returns (uint256) {
154         return _allowances[owner][spender];
155     }
156 
157     function approve(address spender, uint256 amount) public virtual override returns (bool) {
158         _approve(_msgSender(), spender, amount);
159         return true;
160     }
161 
162     function transferFrom(
163         address sender,
164         address recipient,
165         uint256 amount
166     ) public virtual override returns (bool) {
167         _transfer(sender, recipient, amount);
168 
169         uint256 currentAllowance = _allowances[sender][_msgSender()];
170         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
171         unchecked {
172             _approve(sender, _msgSender(), currentAllowance - amount);
173         }
174 
175         return true;
176     }
177 
178     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
179         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
180         return true;
181     }
182 
183     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
184         uint256 currentAllowance = _allowances[_msgSender()][spender];
185         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
186         unchecked {
187             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
188         }
189 
190         return true;
191     }
192 
193     function _transfer(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) internal virtual {
198         require(sender != address(0), "ERC20: transfer from the zero address");
199         require(recipient != address(0), "ERC20: transfer to the zero address");
200 
201         uint256 senderBalance = _balances[sender];
202         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
203         unchecked {
204             _balances[sender] = senderBalance - amount;
205         }
206         _balances[recipient] += amount;
207 
208         emit Transfer(sender, recipient, amount);
209     }
210 
211     function _createInitialSupply(address account, uint256 amount) internal virtual {
212         require(account != address(0), "ERC20: mint to the zero address");
213         _totalSupply += amount;
214         _balances[account] += amount;
215         emit Transfer(address(0), account, amount);
216     }
217 
218     function _approve(
219         address owner,
220         address spender,
221         uint256 amount
222     ) internal virtual {
223         require(owner != address(0), "ERC20: approve from the zero address");
224         require(spender != address(0), "ERC20: approve to the zero address");
225 
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 }
230 
231 interface DividendPayingTokenOptionalInterface {
232   /// @notice View the amount of dividend in wei that an address can withdraw.
233   /// @param _owner The address of a token holder.
234   /// @return The amount of dividend in wei that `_owner` can withdraw.
235   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
236 
237   /// @notice View the amount of dividend in wei that an address has withdrawn.
238   /// @param _owner The address of a token holder.
239   /// @return The amount of dividend in wei that `_owner` has withdrawn.
240   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
241 
242   /// @notice View the amount of dividend in wei that an address has earned in total.
243   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
244   /// @param _owner The address of a token holder.
245   /// @return The amount of dividend in wei that `_owner` has earned in total.
246   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
247 }
248 
249 interface DividendPayingTokenInterface {
250   /// @notice View the amount of dividend in wei that an address can withdraw.
251   /// @param _owner The address of a token holder.
252   /// @return The amount of dividend in wei that `_owner` can withdraw.
253   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
254 
255   /// @notice Distributes ether to token holders as dividends.
256   /// @dev SHOULD distribute the paid ether to token holders as dividends.
257   ///  SHOULD NOT directly transfer ether to token holders in this function.
258   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
259   function distributeDividends() external payable;
260 
261   /// @notice Withdraws the ether distributed to the sender.
262   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
263   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
264   function withdrawDividend(address _rewardToken) external;
265 
266   /// @dev This event MUST emit when ether is distributed to token holders.
267   /// @param from The address which sends ether to this contract.
268   /// @param weiAmount The amount of distributed ether in wei.
269   event DividendsDistributed(
270     address indexed from,
271     uint256 weiAmount
272   );
273 
274   /// @dev This event MUST emit when an address withdraws their dividend.
275   /// @param to The address which withdraws ether from this contract.
276   /// @param weiAmount The amount of withdrawn ether in wei.
277   event DividendWithdrawn(
278     address indexed to,
279     uint256 weiAmount
280   );
281 }
282 
283 library SafeMath {
284     /**
285      * @dev Returns the addition of two unsigned integers, reverting on
286      * overflow.
287      *
288      * Counterpart to Solidity's `+` operator.
289      *
290      * Requirements:
291      *
292      * - Addition cannot overflow.
293      */
294     function add(uint256 a, uint256 b) internal pure returns (uint256) {
295         uint256 c = a + b;
296         require(c >= a, "SafeMath: addition overflow");
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the subtraction of two unsigned integers, reverting on
303      * overflow (when the result is negative).
304      *
305      * Counterpart to Solidity's `-` operator.
306      *
307      * Requirements:
308      *
309      * - Subtraction cannot overflow.
310      */
311     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
312         return sub(a, b, "SafeMath: subtraction overflow");
313     }
314 
315     /**
316      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
317      * overflow (when the result is negative).
318      *
319      * Counterpart to Solidity's `-` operator.
320      *
321      * Requirements:
322      *
323      * - Subtraction cannot overflow.
324      */
325     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
326         require(b <= a, errorMessage);
327         uint256 c = a - b;
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the multiplication of two unsigned integers, reverting on
334      * overflow.
335      *
336      * Counterpart to Solidity's `*` operator.
337      *
338      * Requirements:
339      *
340      * - Multiplication cannot overflow.
341      */
342     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
343         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
344         // benefit is lost if 'b' is also tested.
345         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
346         if (a == 0) {
347             return 0;
348         }
349 
350         uint256 c = a * b;
351         require(c / a == b, "SafeMath: multiplication overflow");
352 
353         return c;
354     }
355 
356     /**
357      * @dev Returns the integer division of two unsigned integers. Reverts on
358      * division by zero. The result is rounded towards zero.
359      *
360      * Counterpart to Solidity's `/` operator. Note: this function uses a
361      * `revert` opcode (which leaves remaining gas untouched) while Solidity
362      * uses an invalid opcode to revert (consuming all remaining gas).
363      *
364      * Requirements:
365      *
366      * - The divisor cannot be zero.
367      */
368     function div(uint256 a, uint256 b) internal pure returns (uint256) {
369         return div(a, b, "SafeMath: division by zero");
370     }
371 
372     /**
373      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
374      * division by zero. The result is rounded towards zero.
375      *
376      * Counterpart to Solidity's `/` operator. Note: this function uses a
377      * `revert` opcode (which leaves remaining gas untouched) while Solidity
378      * uses an invalid opcode to revert (consuming all remaining gas).
379      *
380      * Requirements:
381      *
382      * - The divisor cannot be zero.
383      */
384     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
385         require(b > 0, errorMessage);
386         uint256 c = a / b;
387         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
388 
389         return c;
390     }
391 
392     /**
393      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
394      * Reverts when dividing by zero.
395      *
396      * Counterpart to Solidity's `%` operator. This function uses a `revert`
397      * opcode (which leaves remaining gas untouched) while Solidity uses an
398      * invalid opcode to revert (consuming all remaining gas).
399      *
400      * Requirements:
401      *
402      * - The divisor cannot be zero.
403      */
404     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
405         return mod(a, b, "SafeMath: modulo by zero");
406     }
407 
408     /**
409      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
410      * Reverts with custom message when dividing by zero.
411      *
412      * Counterpart to Solidity's `%` operator. This function uses a `revert`
413      * opcode (which leaves remaining gas untouched) while Solidity uses an
414      * invalid opcode to revert (consuming all remaining gas).
415      *
416      * Requirements:
417      *
418      * - The divisor cannot be zero.
419      */
420     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
421         require(b != 0, errorMessage);
422         return a % b;
423     }
424 }
425 
426 contract Ownable is Context {
427     address private _owner;
428 
429     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
430     
431     /**
432      * @dev Initializes the contract setting the deployer as the initial owner.
433      */
434     constructor () {
435         address msgSender = _msgSender();
436         _owner = msgSender;
437         emit OwnershipTransferred(address(0), msgSender);
438     }
439 
440     /**
441      * @dev Returns the address of the current owner.
442      */
443     function owner() public view returns (address) {
444         return _owner;
445     }
446 
447     /**
448      * @dev Throws if called by any account other than the owner.
449      */
450     modifier onlyOwner() {
451         require(_owner == _msgSender(), "Ownable: caller is not the owner");
452         _;
453     }
454 
455     /**
456      * @dev Leaves the contract without owner. It will not be possible to call
457      * `onlyOwner` functions anymore. Can only be called by the current owner.
458      *
459      * NOTE: Renouncing ownership will leave the contract without an owner,
460      * thereby removing any functionality that is only available to the owner.
461      */
462     function renounceOwnership() public virtual onlyOwner {
463         emit OwnershipTransferred(_owner, address(0));
464         _owner = address(0);
465     }
466 
467     /**
468      * @dev Transfers ownership of the contract to a new account (`newOwner`).
469      * Can only be called by the current owner.
470      */
471     function transferOwnership(address newOwner) public virtual onlyOwner {
472         require(newOwner != address(0), "Ownable: new owner is the zero address");
473         emit OwnershipTransferred(_owner, newOwner);
474         _owner = newOwner;
475     }
476 }
477 
478 
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
548 
549 interface IUniswapV2Router01 {
550     function factory() external pure returns (address);
551     function WETH() external pure returns (address);
552 
553     function addLiquidity(
554         address tokenA,
555         address tokenB,
556         uint amountADesired,
557         uint amountBDesired,
558         uint amountAMin,
559         uint amountBMin,
560         address to,
561         uint deadline
562     ) external returns (uint amountA, uint amountB, uint liquidity);
563     function addLiquidityETH(
564         address token,
565         uint amountTokenDesired,
566         uint amountTokenMin,
567         uint amountETHMin,
568         address to,
569         uint deadline
570     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
571     function removeLiquidity(
572         address tokenA,
573         address tokenB,
574         uint liquidity,
575         uint amountAMin,
576         uint amountBMin,
577         address to,
578         uint deadline
579     ) external returns (uint amountA, uint amountB);
580     function removeLiquidityETH(
581         address token,
582         uint liquidity,
583         uint amountTokenMin,
584         uint amountETHMin,
585         address to,
586         uint deadline
587     ) external returns (uint amountToken, uint amountETH);
588     function removeLiquidityWithPermit(
589         address tokenA,
590         address tokenB,
591         uint liquidity,
592         uint amountAMin,
593         uint amountBMin,
594         address to,
595         uint deadline,
596         bool approveMax, uint8 v, bytes32 r, bytes32 s
597     ) external returns (uint amountA, uint amountB);
598     function removeLiquidityETHWithPermit(
599         address token,
600         uint liquidity,
601         uint amountTokenMin,
602         uint amountETHMin,
603         address to,
604         uint deadline,
605         bool approveMax, uint8 v, bytes32 r, bytes32 s
606     ) external returns (uint amountToken, uint amountETH);
607     function swapExactTokensForTokens(
608         uint amountIn,
609         uint amountOutMin,
610         address[] calldata path,
611         address to,
612         uint deadline
613     ) external returns (uint[] memory amounts);
614     function swapTokensForExactTokens(
615         uint amountOut,
616         uint amountInMax,
617         address[] calldata path,
618         address to,
619         uint deadline
620     ) external returns (uint[] memory amounts);
621     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
622         external
623         payable
624         returns (uint[] memory amounts);
625     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
626         external
627         returns (uint[] memory amounts);
628     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
629         external
630         returns (uint[] memory amounts);
631     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
632         external
633         payable
634         returns (uint[] memory amounts);
635 
636     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
637     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
638     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
639     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
640     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
641 }
642 
643 interface IUniswapV2Router02 is IUniswapV2Router01 {
644     function removeLiquidityETHSupportingFeeOnTransferTokens(
645         address token,
646         uint liquidity,
647         uint amountTokenMin,
648         uint amountETHMin,
649         address to,
650         uint deadline
651     ) external returns (uint amountETH);
652     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
653         address token,
654         uint liquidity,
655         uint amountTokenMin,
656         uint amountETHMin,
657         address to,
658         uint deadline,
659         bool approveMax, uint8 v, bytes32 r, bytes32 s
660     ) external returns (uint amountETH);
661 
662     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
663         uint amountIn,
664         uint amountOutMin,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external;
669     function swapExactETHForTokensSupportingFeeOnTransferTokens(
670         uint amountOutMin,
671         address[] calldata path,
672         address to,
673         uint deadline
674     ) external payable;
675     function swapExactTokensForETHSupportingFeeOnTransferTokens(
676         uint amountIn,
677         uint amountOutMin,
678         address[] calldata path,
679         address to,
680         uint deadline
681     ) external;
682 
683 
684      
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
905     function size() private view returns (uint) {
906         return tokenHoldersMap.keys.length;
907     }
908 
909     function set(address key, uint val) private {
910         if (tokenHoldersMap.inserted[key]) {
911             tokenHoldersMap.values[key] = val;
912         } else {
913             tokenHoldersMap.inserted[key] = true;
914             tokenHoldersMap.values[key] = val;
915             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
916             tokenHoldersMap.keys.push(key);
917         }
918     }
919 
920     function remove(address key) private {
921         if (!tokenHoldersMap.inserted[key]) {
922             return;
923         }
924 
925         delete tokenHoldersMap.inserted[key];
926         delete tokenHoldersMap.values[key];
927 
928         uint index = tokenHoldersMap.indexOf[key];
929         uint lastIndex = tokenHoldersMap.keys.length - 1;
930         address lastKey = tokenHoldersMap.keys[lastIndex];
931 
932         tokenHoldersMap.indexOf[lastKey] = index;
933         delete tokenHoldersMap.indexOf[key];
934 
935         tokenHoldersMap.keys[index] = lastKey;
936         tokenHoldersMap.keys.pop();
937     }
938 
939     Map private tokenHoldersMap;
940     uint256 public lastProcessedIndex;
941 
942     mapping (address => bool) public excludedFromDividends;
943 
944     mapping (address => uint256) public lastClaimTimes;
945 
946     uint256 public claimWait;
947     uint256 public immutable minimumTokenBalanceForDividends;
948 
949     event ExcludeFromDividends(address indexed account);
950     event IncludeInDividends(address indexed account);
951     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
952 
953     event Claim(address indexed account, uint256 amount, bool indexed automatic);
954 
955     constructor() {
956     	claimWait = 1200;
957         minimumTokenBalanceForDividends = 1000 * (10**18);
958     }
959 
960     function excludeFromDividends(address account) external onlyOwner {
961     	excludedFromDividends[account] = true;
962 
963     	_setBalance(account, 0);
964     	remove(account);
965 
966     	emit ExcludeFromDividends(account);
967     }
968     
969     function includeInDividends(address account) external onlyOwner {
970     	require(excludedFromDividends[account]);
971     	excludedFromDividends[account] = false;
972 
973     	emit IncludeInDividends(account);
974     }
975 
976     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
977         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
978         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
979         emit ClaimWaitUpdated(newClaimWait, claimWait);
980         claimWait = newClaimWait;
981     }
982 
983     function getLastProcessedIndex() external view returns(uint256) {
984     	return lastProcessedIndex;
985     }
986 
987     function getNumberOfTokenHolders() external view returns(uint256) {
988         return tokenHoldersMap.keys.length;
989     }
990 
991     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
992     	if(lastClaimTime > block.timestamp)  {
993     		return false;
994     	}
995 
996     	return block.timestamp.sub(lastClaimTime) >= claimWait;
997     }
998 
999     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1000     	if(excludedFromDividends[account]) {
1001     		return;
1002     	}
1003 
1004     	if(newBalance >= minimumTokenBalanceForDividends) {
1005             _setBalance(account, newBalance);
1006     		set(account, newBalance);
1007     	}
1008     	else {
1009             _setBalance(account, 0);
1010     		remove(account);
1011     	}
1012 
1013     	processAccount(account, true);
1014     }
1015     
1016     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1017     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1018 
1019     	if(numberOfTokenHolders == 0) {
1020     		return (0, 0, lastProcessedIndex);
1021     	}
1022 
1023     	uint256 _lastProcessedIndex = lastProcessedIndex;
1024 
1025     	uint256 gasUsed = 0;
1026 
1027     	uint256 gasLeft = gasleft();
1028 
1029     	uint256 iterations = 0;
1030     	uint256 claims = 0;
1031 
1032     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1033     		_lastProcessedIndex++;
1034 
1035     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1036     			_lastProcessedIndex = 0;
1037     		}
1038 
1039     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1040 
1041     		if(canAutoClaim(lastClaimTimes[account])) {
1042     			if(processAccount(payable(account), true)) {
1043     				claims++;
1044     			}
1045     		}
1046 
1047     		iterations++;
1048 
1049     		uint256 newGasLeft = gasleft();
1050 
1051     		if(gasLeft > newGasLeft) {
1052     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1053     		}
1054     		gasLeft = newGasLeft;
1055     	}
1056 
1057     	lastProcessedIndex = _lastProcessedIndex;
1058 
1059     	return (iterations, claims, lastProcessedIndex);
1060     }
1061 
1062     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1063         uint256 amount;
1064         bool paid;
1065         for (uint256 i; i < rewardTokens.length; i++){
1066             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1067             if(amount > 0) {
1068         		lastClaimTimes[account] = block.timestamp;
1069                 emit Claim(account, amount, automatic);
1070                 paid = true;
1071     	    }
1072         }
1073         return paid;
1074     }
1075 }
1076 
1077 contract Aurum is ERC20, Ownable {
1078     using SafeMath for uint256;
1079 
1080     IUniswapV2Router02 public immutable uniswapV2Router;
1081     address public immutable uniswapV2Pair;
1082 
1083     bool private swapping;
1084 
1085     DividendTracker public dividendTracker;
1086     
1087     uint256 public maxTransactionAmount;
1088     uint256 public swapTokensAtAmount;
1089     uint256 public maxWallet;
1090     
1091     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
1092     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
1093     
1094     bool public limitsInEffect = true;
1095     bool public tradingActive = false;
1096     bool public swapEnabled = false;
1097     
1098     uint256 public constant feeDivisor = 1000;
1099 
1100     uint256 public totalSellFees;
1101     uint256 public rewardsSellFee;
1102     uint256 public liquiditySellFee;
1103     
1104     uint256 public totalBuyFees;
1105     uint256 public rewardsBuyFee;
1106     uint256 public liquidityBuyFee;
1107     
1108     uint256 public tokensForRewards;
1109     uint256 public tokensForLiquidity;
1110     
1111     uint256 public gasForProcessing = 0;
1112 
1113     uint256 public lpWithdrawRequestTimestamp;
1114     uint256 public lpWithdrawRequestDuration = 3 days;
1115     bool public lpWithdrawRequestPending;
1116     uint256 public lpPercToWithDraw;
1117 
1118     // exlcude from fees and max transaction amount
1119     mapping (address => bool) private _isExcludedFromFees;
1120 
1121     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1122 
1123     // store addresses that an automatic market maker pairs. Any transfer *to* these addresses
1124     // could be subject to a maximum transfer amount
1125     mapping (address => bool) public automatedMarketMakerPairs;
1126 
1127     event ExcludeFromFees(address indexed account, bool isExcluded);
1128     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1129 
1130     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1131 
1132     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1133 
1134     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1135     
1136     event SwapAndLiquify(
1137         uint256 tokensSwapped,
1138         uint256 ethReceived,
1139         uint256 tokensIntoLiqudity
1140     );
1141 
1142     event SendDividends(
1143     	uint256 tokensSwapped,
1144     	uint256 amount
1145     );
1146 
1147     event ProcessedDividendTracker(
1148     	uint256 iterations,
1149     	uint256 claims,
1150         uint256 lastProcessedIndex,
1151     	bool indexed automatic,
1152     	uint256 gas,
1153     	address indexed processor
1154     );
1155 
1156     event RequestedLPWithdraw();
1157     
1158     event WithdrewLPForMigration();
1159 
1160     event CanceledLpWithdrawRequest();
1161 
1162     constructor() ERC20("Aurum", "AURUM") {
1163 
1164         uint256 totalSupply = 100 * 1e9 * 1e18;
1165         
1166         maxTransactionAmount = totalSupply * 10 / 1000;
1167         swapTokensAtAmount = totalSupply * 5 / 10000;
1168         maxWallet = totalSupply * 10 / 1000;
1169 
1170         rewardsBuyFee = 60;
1171         liquidityBuyFee = 10;
1172         totalBuyFees = rewardsBuyFee + liquidityBuyFee;
1173         
1174         rewardsSellFee = 60;
1175         liquiditySellFee = 10;
1176         totalSellFees = rewardsSellFee + liquiditySellFee;
1177 
1178     	dividendTracker = new DividendTracker();
1179 
1180     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1181     	
1182          // Create a uniswap pair for this new token
1183         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1184             .createPair(address(this), _uniswapV2Router.WETH());
1185 
1186         uniswapV2Router = _uniswapV2Router;
1187         uniswapV2Pair = _uniswapV2Pair;
1188 
1189         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1190 
1191         // exclude from receiving dividends
1192         dividendTracker.excludeFromDividends(address(dividendTracker));
1193         dividendTracker.excludeFromDividends(address(this));
1194         dividendTracker.excludeFromDividends(owner());
1195         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1196         dividendTracker.excludeFromDividends(address(0xdead));
1197         
1198         // exclude from paying fees or having max transaction amount
1199         excludeFromFees(owner(), true);
1200         excludeFromFees(address(this), true);
1201         excludeFromFees(address(0xdead), true);
1202         excludeFromMaxTransaction(owner(), true);
1203         excludeFromMaxTransaction(address(this), true);
1204         excludeFromMaxTransaction(address(dividendTracker), true);
1205         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1206         excludeFromMaxTransaction(address(0xdead), true);
1207 
1208         _createInitialSupply(address(owner()), totalSupply);
1209     }
1210 
1211     receive() external payable {
1212 
1213   	}
1214 
1215     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1216     function excludeFromDividends(address account) external onlyOwner {
1217         dividendTracker.excludeFromDividends(account);
1218     }
1219 
1220     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1221     function includeInDividends(address account) external onlyOwner {
1222         dividendTracker.includeInDividends(account);
1223     }
1224     
1225     // once enabled, can never be turned off
1226     function enableTrading() external onlyOwner {
1227         require(!tradingActive, "Cannot re-enable trading");
1228         tradingActive = true;
1229         swapEnabled = true;
1230         tradingActiveBlock = block.number;
1231     }
1232     
1233     // only use to disable contract sales if absolutely necessary (emergency use only)
1234     function updateSwapEnabled(bool enabled) external onlyOwner(){
1235         swapEnabled = enabled;
1236     }
1237 
1238     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1239         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1240         maxTransactionAmount = newNum * (10**18);
1241     }
1242     
1243     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1244         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1245         maxWallet = newNum * (10**18);
1246     }
1247     
1248     function updateBuyFees(uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1249         rewardsBuyFee = _rewardsFee;
1250         liquidityBuyFee = _liquidityFee;
1251         totalBuyFees = rewardsBuyFee + liquidityBuyFee;
1252         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1253     }
1254     
1255     function updateSellFees(uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1256         rewardsSellFee = _rewardsFee;
1257         liquiditySellFee = _liquidityFee;
1258         totalSellFees = rewardsSellFee + liquiditySellFee;
1259         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1260     }
1261 
1262     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1263         _isExcludedMaxTransactionAmount[updAds] = isEx;
1264         emit ExcludedMaxTransactionAmount(updAds, isEx);
1265     }
1266 
1267     function excludeFromFees(address account, bool excluded) public onlyOwner {
1268         _isExcludedFromFees[account] = excluded;
1269 
1270         emit ExcludeFromFees(account, excluded);
1271     }
1272 
1273     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1274         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1275 
1276         _setAutomatedMarketMakerPair(pair, value);
1277     }
1278 
1279     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1280         automatedMarketMakerPairs[pair] = value;
1281 
1282         excludeFromMaxTransaction(pair, value);
1283         
1284         if(value) {
1285             dividendTracker.excludeFromDividends(pair);
1286         }
1287 
1288         emit SetAutomatedMarketMakerPair(pair, value);
1289     }
1290 
1291     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1292         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1293         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1294         emit GasForProcessingUpdated(newValue, gasForProcessing);
1295         gasForProcessing = newValue;
1296     }
1297 
1298     function updateClaimWait(uint256 claimWait) external onlyOwner {
1299         dividendTracker.updateClaimWait(claimWait);
1300     }
1301 
1302     function getClaimWait() external view returns(uint256) {
1303         return dividendTracker.claimWait();
1304     }
1305 
1306     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1307         return dividendTracker.totalDividendsDistributed(rewardToken);
1308     }
1309 
1310     function isExcludedFromFees(address account) external view returns(bool) {
1311         return _isExcludedFromFees[account];
1312     }
1313 
1314     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1315     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1316   	}
1317 
1318 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1319 		return dividendTracker.holderBalance(account);
1320 	}
1321 
1322  /*
1323 
1324 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1325         external view returns (
1326             address,
1327             int256,
1328             int256,
1329             uint256,
1330             uint256,
1331             uint256,
1332             uint256,
1333             uint256) {
1334     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1335     }
1336 
1337     */
1338 
1339 	function processDividendTracker(uint256 gas) external {
1340 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1341 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1342     }
1343 
1344     function claim() external {
1345 		dividendTracker.processAccount(payable(msg.sender), false);
1346     }
1347 
1348     function getLastProcessedIndex() external view returns(uint256) {
1349     	return dividendTracker.getLastProcessedIndex();
1350     }
1351 
1352     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1353         return dividendTracker.getNumberOfTokenHolders();
1354     }
1355     
1356     function getNumberOfDividends() external view returns(uint256) {
1357         return dividendTracker.totalBalance();
1358     }
1359     
1360     function removeLimits() external onlyOwner returns (bool){
1361         limitsInEffect = false;
1362         return true;
1363     }
1364     
1365     function _transfer(
1366         address from,
1367         address to,
1368         uint256 amount
1369     ) internal override {
1370         require(from != address(0), "ERC20: transfer from the zero address");
1371         require(to != address(0), "ERC20: transfer to the zero address");
1372         
1373          if(amount == 0) {
1374             super._transfer(from, to, 0);
1375             return;
1376         }
1377         
1378         if(!tradingActive){
1379             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1380         }
1381         
1382         if(limitsInEffect){
1383             if (
1384                 from != owner() &&
1385                 to != owner() &&
1386                 to != address(0) &&
1387                 to != address(0xdead) &&
1388                 !swapping
1389             ){
1390                 
1391                 //when buy
1392                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1393                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1394                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1395                 } 
1396                 //when sell
1397                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1398                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1399                 }
1400                 else if(!_isExcludedMaxTransactionAmount[to]) {
1401                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1402                 }
1403             }
1404         }
1405 
1406 		uint256 contractTokenBalance = balanceOf(address(this));
1407         
1408         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1409 
1410         if( 
1411             canSwap &&
1412             swapEnabled &&
1413             !swapping &&
1414             !automatedMarketMakerPairs[from] &&
1415             !_isExcludedFromFees[from] &&
1416             !_isExcludedFromFees[to]
1417         ) {
1418             swapping = true;
1419             swapBack();
1420             swapping = false;
1421         }
1422 
1423         bool takeFee = !swapping;
1424 
1425         // if any account belongs to _isExcludedFromFee account then remove the fee
1426         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1427             takeFee = false;
1428         }
1429         
1430         uint256 fees = 0;
1431         
1432         // no taxes on transfers (non buys/sells)
1433         if(takeFee){
1434             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1435                 fees = amount.mul(99).div(100);
1436                 tokensForLiquidity += fees * 33 / 99;
1437                 tokensForRewards += fees * 33 / 99;
1438             }
1439 
1440             // on sell
1441             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1442                 fees = amount.mul(totalSellFees).div(feeDivisor);
1443                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1444                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1445             }
1446             
1447             // on buy
1448             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1449         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1450         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1451                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1452             }
1453 
1454             if(fees > 0){    
1455                 super._transfer(from, address(this), fees);
1456             }
1457         	
1458         	amount -= fees;
1459         }
1460 
1461         super._transfer(from, to, amount);
1462 
1463         dividendTracker.setBalance(payable(from), balanceOf(from));
1464         dividendTracker.setBalance(payable(to), balanceOf(to));
1465 
1466         if(!swapping && gasForProcessing > 0) {
1467 	    	uint256 gas = gasForProcessing;
1468 
1469 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1470 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1471 	    	}
1472 	    	catch {}
1473         }
1474     }
1475     
1476     function swapTokensForEth(uint256 tokenAmount) private {
1477 
1478         // generate the uniswap pair path of token -> weth
1479         address[] memory path = new address[](2);
1480         path[0] = address(this);
1481         path[1] = uniswapV2Router.WETH();
1482 
1483         _approve(address(this), address(uniswapV2Router), tokenAmount);
1484 
1485         // make the swap
1486         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1487             tokenAmount,
1488             0, // accept any amount of ETH
1489             path,
1490             address(this),
1491             block.timestamp
1492         );
1493         
1494     }
1495     
1496     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1497         // approve token transfer to cover all possible scenarios
1498         _approve(address(this), address(uniswapV2Router), tokenAmount);
1499 
1500         // add the liquidity
1501         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1502             address(this),
1503             tokenAmount,
1504             0, // slippage is unavoidable
1505             0, // slippage is unavoidable
1506             address(0xdead),
1507             block.timestamp
1508         );
1509 
1510     }
1511     
1512     function swapBack() private {
1513         uint256 contractBalance = balanceOf(address(this));
1514         uint256 totalTokensToSwap = tokensForLiquidity + tokensForRewards;
1515         
1516         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1517         
1518         // Halve the amount of liquidity tokens
1519         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1520         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1521         
1522         uint256 initialETHBalance = address(this).balance;
1523 
1524         swapTokensForEth(amountToSwapForETH); 
1525         
1526         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1527         
1528         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1529         
1530         uint256 ethForLiquidity = ethBalance - ethForRewards;
1531         
1532         tokensForLiquidity = 0;
1533         tokensForRewards = 0;
1534         
1535         
1536         
1537         if(liquidityTokens > 0 && ethForLiquidity > 0){
1538             addLiquidity(liquidityTokens, ethForLiquidity);
1539             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1540         }
1541         
1542         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1543     }
1544 
1545     function withdrawStuckEth() external onlyOwner {
1546         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1547         require(success, "failed to withdraw");
1548     }
1549 
1550   
1551 
1552     function nextAvailableLpWithdrawDate() public view returns (uint256){
1553         if(lpWithdrawRequestPending){
1554             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1555         }
1556         else {
1557             return 0;  // 0 means no open requests
1558         }
1559     }
1560 
1561     function withdrawRequestedLP() external onlyOwner {
1562         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1563         lpWithdrawRequestTimestamp = 0;
1564         lpWithdrawRequestPending = false;
1565 
1566         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1567         
1568         lpPercToWithDraw = 0;
1569 
1570         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1571     }
1572 
1573    
1574 }