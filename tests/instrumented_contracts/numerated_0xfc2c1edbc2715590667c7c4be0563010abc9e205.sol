1 // SPDX-License-Identifier: MIT                                                                               
2                                       
3 pragma solidity 0.8.17;
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
682 }
683 
684 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
685   using SafeMath for uint256;
686   using SafeMathUint for uint256;
687   using SafeMathInt for int256;
688 
689   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
690   // For more discussion about choosing the value of `magnitude`,
691   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
692   uint256 constant internal magnitude = 2**128;
693 
694   mapping(address => uint256) internal magnifiedDividendPerShare;
695   address[] public rewardTokens;
696   address public nextRewardToken;
697   uint256 public rewardTokenCounter;
698   
699   IUniswapV2Router02 public immutable uniswapV2Router;
700   
701   
702   // About dividendCorrection:
703   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
704   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
705   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
706   //   `dividendOf(_user)` should not be changed,
707   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
708   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
709   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
710   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
711   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
712   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
713   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
714   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
715   
716   mapping (address => uint256) public holderBalance;
717   uint256 public totalBalance;
718 
719   mapping(address => uint256) public totalDividendsDistributed;
720   
721   constructor(){
722       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // router 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
723       uniswapV2Router = _uniswapV2Router; 
724       
725       // Mainnet
726       rewardTokens.push(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)); // USDC - Mainnet  0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
727       nextRewardToken = rewardTokens[0];
728   }
729 
730   
731 
732   /// @dev Distributes dividends whenever ether is paid to this contract.
733   receive() external payable {
734     distributeDividends();
735   }
736 
737   /// @notice Distributes ether to token holders as dividends.
738   /// @dev It reverts if the total supply of tokens is 0.
739   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
740   /// About undistributed ether:
741   ///   In each distribution, there is a small amount of ether not distributed,
742   ///     the magnified amount of which is
743   ///     `(msg.value * magnitude) % totalSupply()`.
744   ///   With a well-chosen `magnitude`, the amount of undistributed ether
745   ///     (de-magnified) in a distribution can be less than 1 wei.
746   ///   We can actually keep track of the undistributed ether in a distribution
747   ///     and try to distribute it in the next distribution,
748   ///     but keeping track of such data on-chain costs much more than
749   ///     the saved ether, so we don't do that.
750     
751   function distributeDividends() public override payable { 
752     require(totalBalance > 0);
753     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
754     buyTokens(msg.value, nextRewardToken);
755     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
756     if (newBalance > 0) {
757       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
758         (newBalance).mul(magnitude) / totalBalance
759       );
760       emit DividendsDistributed(msg.sender, newBalance);
761 
762       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
763     }
764     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
765     nextRewardToken = rewardTokens[rewardTokenCounter];
766   }
767   
768   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
769     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
770         // generate the uniswap pair path of weth -> eth
771         address[] memory path = new address[](2);
772         path[0] = uniswapV2Router.WETH();
773         path[1] = rewardToken;
774 
775         // make the swap
776         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
777             0, // accept any amount of Ethereum
778             path,
779             address(this),
780             block.timestamp
781         );
782     }
783   
784   /// @notice Withdraws the ether distributed to the sender.
785   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
786   function withdrawDividend(address _rewardToken) external virtual override {
787     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
788   }
789 
790   /// @notice Withdraws the ether distributed to the sender.
791   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
792   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
793     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
794     if (_withdrawableDividend > 0) {
795       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
796       emit DividendWithdrawn(user, _withdrawableDividend);
797       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
798       return _withdrawableDividend;
799     }
800 
801     return 0;
802   }
803 
804 
805   /// @notice View the amount of dividend in wei that an address can withdraw.
806   /// @param _owner The address of a token holder.
807   /// @return The amount of dividend in wei that `_owner` can withdraw.
808   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
809     return withdrawableDividendOf(_owner, _rewardToken);
810   }
811 
812   /// @notice View the amount of dividend in wei that an address can withdraw.
813   /// @param _owner The address of a token holder.
814   /// @return The amount of dividend in wei that `_owner` can withdraw.
815   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
816     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
817   }
818 
819   /// @notice View the amount of dividend in wei that an address has withdrawn.
820   /// @param _owner The address of a token holder.
821   /// @return The amount of dividend in wei that `_owner` has withdrawn.
822   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
823     return withdrawnDividends[_owner][_rewardToken];
824   }
825 
826 
827   /// @notice View the amount of dividend in wei that an address has earned in total.
828   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
829   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
830   /// @param _owner The address of a token holder.
831   /// @return The amount of dividend in wei that `_owner` has earned in total.
832   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
833     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
834       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
835   }
836 
837   /// @dev Internal function that increases tokens to an account.
838   /// Update magnifiedDividendCorrections to keep dividends unchanged.
839   /// @param account The account that will receive the created tokens.
840   /// @param value The amount that will be created.
841   function _increase(address account, uint256 value) internal {
842     for (uint256 i; i < rewardTokens.length; i++){
843         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
844           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
845     }
846   }
847 
848   /// @dev Internal function that reduces an amount of the token of a given account.
849   /// Update magnifiedDividendCorrections to keep dividends unchanged.
850   /// @param account The account whose tokens will be burnt.
851   /// @param value The amount that will be burnt.
852   function _reduce(address account, uint256 value) internal {
853       for (uint256 i; i < rewardTokens.length; i++){
854         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
855           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
856       }
857   }
858 
859   function _setBalance(address account, uint256 newBalance) internal {
860     uint256 currentBalance = holderBalance[account];
861     holderBalance[account] = newBalance;
862     if(newBalance > currentBalance) {
863       uint256 increaseAmount = newBalance.sub(currentBalance);
864       _increase(account, increaseAmount);
865       totalBalance += increaseAmount;
866     } else if(newBalance < currentBalance) {
867       uint256 reduceAmount = currentBalance.sub(newBalance);
868       _reduce(account, reduceAmount);
869       totalBalance -= reduceAmount;
870     }
871   }
872 }
873 
874 contract DividendTracker is DividendPayingToken {
875     using SafeMath for uint256;
876     using SafeMathInt for int256;
877 
878     struct Map {
879         address[] keys;
880         mapping(address => uint) values;
881         mapping(address => uint) indexOf;
882         mapping(address => bool) inserted;
883     }
884 
885     function get(address key) private view returns (uint) {
886         return tokenHoldersMap.values[key];
887     }
888 
889     function getIndexOfKey(address key) private view returns (int) {
890         if(!tokenHoldersMap.inserted[key]) {
891             return -1;
892         }
893         return int(tokenHoldersMap.indexOf[key]);
894     }
895 
896     function getKeyAtIndex(uint index) private view returns (address) {
897         return tokenHoldersMap.keys[index];
898     }
899 
900 
901 
902     function size() private view returns (uint) {
903         return tokenHoldersMap.keys.length;
904     }
905 
906     function set(address key, uint val) private {
907         if (tokenHoldersMap.inserted[key]) {
908             tokenHoldersMap.values[key] = val;
909         } else {
910             tokenHoldersMap.inserted[key] = true;
911             tokenHoldersMap.values[key] = val;
912             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
913             tokenHoldersMap.keys.push(key);
914         }
915     }
916 
917     function remove(address key) private {
918         if (!tokenHoldersMap.inserted[key]) {
919             return;
920         }
921 
922         delete tokenHoldersMap.inserted[key];
923         delete tokenHoldersMap.values[key];
924 
925         uint index = tokenHoldersMap.indexOf[key];
926         uint lastIndex = tokenHoldersMap.keys.length - 1;
927         address lastKey = tokenHoldersMap.keys[lastIndex];
928 
929         tokenHoldersMap.indexOf[lastKey] = index;
930         delete tokenHoldersMap.indexOf[key];
931 
932         tokenHoldersMap.keys[index] = lastKey;
933         tokenHoldersMap.keys.pop();
934     }
935 
936     Map private tokenHoldersMap;
937     uint256 public lastProcessedIndex;
938 
939     mapping (address => bool) public excludedFromDividends;
940 
941     mapping (address => uint256) public lastClaimTimes;
942 
943     uint256 public claimWait;
944     uint256 public immutable minimumTokenBalanceForDividends;
945 
946     event ExcludeFromDividends(address indexed account);
947     event IncludeInDividends(address indexed account);
948     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
949 
950     event Claim(address indexed account, uint256 amount, bool indexed automatic);
951 
952     constructor() {
953     	claimWait = 1200;
954         minimumTokenBalanceForDividends = 5 * (10**18);
955     }
956 
957     function excludeFromDividends(address account) external onlyOwner {
958     	excludedFromDividends[account] = true;
959 
960     	_setBalance(account, 0);
961     	remove(account);
962 
963     	emit ExcludeFromDividends(account);
964     }
965     
966     function includeInDividends(address account) external onlyOwner {
967     	require(excludedFromDividends[account]);
968     	excludedFromDividends[account] = false;
969 
970     	emit IncludeInDividends(account);
971     }
972 
973     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
974         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
975         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
976         emit ClaimWaitUpdated(newClaimWait, claimWait);
977         claimWait = newClaimWait;
978     }
979 
980     function getLastProcessedIndex() external view returns(uint256) {
981     	return lastProcessedIndex;
982     }
983 
984     function getNumberOfTokenHolders() external view returns(uint256) {
985         return tokenHoldersMap.keys.length;
986     }
987 
988     // Check to see if I really made this contract or if it is a clone!
989     // @Sir_Tris on TG, @SirTrisCrypto on Twitter
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
1141 contract THEDISTRICT is ERC20, Ownable {
1142     using SafeMath for uint256;
1143 
1144     IUniswapV2Router02 public immutable uniswapV2Router;
1145     address public immutable uniswapV2Pair;
1146 
1147     bool private swapping;
1148 
1149     DividendTracker public dividendTracker;
1150 
1151     address public operationsWallet;
1152     address private developmentWallet;
1153     address private buybackburnWallet;
1154     address private projectWallet;
1155     address private reserveWallet;
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
1202     mapping (address => bool) private _isblacklisted;
1203     mapping (address => uint256) private _transferDelay;
1204     mapping (address => bool) private _holderDelay;
1205 
1206     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1207     // could be subject to a maximum transfer amount
1208     mapping (address => bool) public automatedMarketMakerPairs;
1209 
1210     event ExcludeFromFees(address indexed account, bool isExcluded);
1211     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1212     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1213 
1214     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1215 
1216     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1217 
1218     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1219 
1220     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1221     
1222     event SwapAndLiquify(
1223         uint256 tokensSwapped,
1224         uint256 ethReceived,
1225         uint256 tokensIntoLiqudity
1226     );
1227 
1228     event SendDividends(
1229     	uint256 tokensSwapped,
1230     	uint256 amount
1231     );
1232 
1233     event ProcessedDividendTracker(
1234     	uint256 iterations,
1235     	uint256 claims,
1236         uint256 lastProcessedIndex,
1237     	bool indexed automatic,
1238     	uint256 gas,
1239     	address indexed processor
1240     );
1241 
1242     event RequestedLPWithdraw();
1243     
1244     event WithdrewLPForMigration();
1245 
1246     event CanceledLpWithdrawRequest();
1247 
1248     constructor() ERC20("The District", "D82") {
1249 
1250         uint256 totalSupply = 100000 * 1e18;
1251         
1252         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
1253         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
1254         maxWallet = totalSupply * 15 / 1000; // 1.5% Max wallet
1255 
1256         rewardsBuyFee = 70;
1257         operationsBuyFee = 10;
1258         liquidityBuyFee = 0;
1259         totalBuyFees = rewardsBuyFee + operationsBuyFee + liquidityBuyFee;
1260         
1261         rewardsSellFee = 70;
1262         operationsSellFee = 10;
1263         liquiditySellFee = 120;
1264         totalSellFees = rewardsSellFee + operationsSellFee + liquiditySellFee;
1265 
1266     	dividendTracker = new DividendTracker();
1267     	operationsWallet = address(0x4eFd1d32d52865299a38FeDCbF860A339763864B); // set as operations wallet
1268         developmentWallet = address(0x14e485DB7f0178Ae02A93f9fEbf3de8299eFbb02);
1269         buybackburnWallet = address(0xe57A300AE3e3C7AEe94cDA6AB23CB1966B707Fc1);
1270         projectWallet = address(0xD61C971E8483E934237DE5aAc8cc703e01325433);
1271         reserveWallet = address(0xb437eF4C46246f04E6C54fD183aEb656c4684459);
1272 
1273     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1274     	
1275          // Create a uniswap pair for this new token
1276         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1277             .createPair(address(this), _uniswapV2Router.WETH());
1278 
1279         uniswapV2Router = _uniswapV2Router;
1280         uniswapV2Pair = _uniswapV2Pair;
1281 
1282         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1283 
1284         // exclude from receiving dividends
1285         dividendTracker.excludeFromDividends(address(dividendTracker));
1286         dividendTracker.excludeFromDividends(address(this));
1287         dividendTracker.excludeFromDividends(owner());
1288         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1289         dividendTracker.excludeFromDividends(address(0xdead));
1290         
1291         // exclude from paying fees or having max transaction amount
1292         excludeFromFees(owner(), true);
1293         excludeFromFees(address(this), true);
1294         excludeFromFees(address(0xdead), true);
1295         excludeFromFees(developmentWallet, true);
1296         excludeFromFees(buybackburnWallet, true);
1297         excludeFromFees(projectWallet, true);
1298         excludeFromFees(reserveWallet, true);
1299         excludeFromMaxTransaction(owner(), true);
1300         excludeFromMaxTransaction(address(this), true);
1301         excludeFromMaxTransaction(address(dividendTracker), true);
1302         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1303         excludeFromMaxTransaction(address(0xdead), true);
1304         excludeFromMaxTransaction(developmentWallet, true);
1305         excludeFromMaxTransaction(buybackburnWallet, true);
1306         excludeFromMaxTransaction(projectWallet, true);
1307         excludeFromMaxTransaction(reserveWallet, true);
1308 
1309         _createInitialSupply(address(owner()), totalSupply);
1310     }
1311 
1312     receive() external payable {
1313 
1314   	}
1315 
1316      // disable Transfer delay - cannot be reenabled
1317     function disableTransferDelay() external onlyOwner returns (bool){
1318         transferDelayEnabled = false;
1319         return true;
1320     }
1321 
1322     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1323     function excludeFromDividends(address account) external onlyOwner {
1324         dividendTracker.excludeFromDividends(account);
1325     }
1326 
1327     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1328     function includeInDividends(address account) external onlyOwner {
1329         dividendTracker.includeInDividends(account);
1330     }
1331     
1332     // once enabled, can never be turned off
1333     function enableTrading() external onlyOwner {
1334         require(!tradingActive, "Cannot re-enable trading");
1335         tradingActive = true;
1336         swapEnabled = true;
1337         tradingActiveBlock = block.number;
1338     }
1339     
1340     // only use to disable contract sales if absolutely necessary (emergency use only)
1341     function updateSwapEnabled(bool enabled) external onlyOwner(){
1342         swapEnabled = enabled;
1343     }
1344 
1345     function updateMaxAmount(uint256 newNum) external onlyOwner {
1346         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1347         maxTransactionAmount = newNum * (10**18);
1348     }
1349     
1350     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1351         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1352         maxWallet = newNum * (10**18);
1353     }
1354     
1355     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1356         operationsBuyFee = _operationsFee;
1357         rewardsBuyFee = _rewardsFee;
1358         liquidityBuyFee = _liquidityFee;
1359         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1360         require(totalBuyFees <= 210, "Must keep fees at 21% or less");
1361     }
1362     
1363     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1364         operationsSellFee = _operationsFee;
1365         rewardsSellFee = _rewardsFee;
1366         liquiditySellFee = _liquidityFee;
1367         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1368     }
1369 
1370     function airdropHolders(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
1371         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
1372         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1373         for(uint256 i = 0; i < wallets.length; i++){
1374             address wallet = wallets[i];
1375             uint256 amount = amountsInTokens[i]*1e18;
1376             _transfer(msg.sender, wallet, amount);
1377         }
1378     }
1379 
1380     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1381         _isExcludedMaxTransactionAmount[updAds] = isEx;
1382         emit ExcludedMaxTransactionAmount(updAds, isEx);
1383     }
1384 
1385     function excludeFromFees(address account, bool excluded) public onlyOwner {
1386         _isExcludedFromFees[account] = excluded;
1387 
1388         emit ExcludeFromFees(account, excluded);
1389     }
1390 
1391     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1392         for(uint256 i = 0; i < accounts.length; i++) {
1393             _isExcludedFromFees[accounts[i]] = excluded;
1394         }
1395 
1396         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1397     }
1398 
1399     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1400         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1401 
1402         _setAutomatedMarketMakerPair(pair, value);
1403     }
1404 
1405     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1406         automatedMarketMakerPairs[pair] = value;
1407 
1408         excludeFromMaxTransaction(pair, value);
1409         
1410         if(value) {
1411             dividendTracker.excludeFromDividends(pair);
1412         }
1413 
1414         emit SetAutomatedMarketMakerPair(pair, value);
1415     }
1416 
1417     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1418         require(newOperationsWallet != address(0), "may not set to 0 address");
1419         excludeFromFees(newOperationsWallet, true);
1420         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1421         operationsWallet = newOperationsWallet;
1422     }
1423 
1424     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1425         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1426         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1427         emit GasForProcessingUpdated(newValue, gasForProcessing);
1428         gasForProcessing = newValue;
1429     }
1430 
1431     function updateClaimWait(uint256 claimWait) external onlyOwner {
1432         dividendTracker.updateClaimWait(claimWait);
1433     }
1434 
1435     function getClaimWait() external view returns(uint256) {
1436         return dividendTracker.claimWait();
1437     }
1438 
1439     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1440         return dividendTracker.totalDividendsDistributed(rewardToken);
1441     }
1442 
1443     function isExcludedFromFees(address account) external view returns(bool) {
1444         return _isExcludedFromFees[account];
1445     }
1446 
1447     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1448     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1449   	}
1450 
1451 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1452 		return dividendTracker.holderBalance(account);
1453 	}
1454 
1455     function getAccountDividendsInfo(address account, address rewardToken)
1456         external view returns (
1457             address,
1458             int256,
1459             int256,
1460             uint256,
1461             uint256,
1462             uint256,
1463             uint256,
1464             uint256) {
1465         return dividendTracker.getAccount(account, rewardToken);
1466     }
1467 
1468 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1469         external view returns (
1470             address,
1471             int256,
1472             int256,
1473             uint256,
1474             uint256,
1475             uint256,
1476             uint256,
1477             uint256) {
1478     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1479     }
1480 
1481 	function processDividendTracker(uint256 gas) external {
1482 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1483 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1484     }
1485 
1486     function claim() external {
1487 		dividendTracker.processAccount(payable(msg.sender), false);
1488     }
1489 
1490     function getLastProcessedIndex() external view returns(uint256) {
1491     	return dividendTracker.getLastProcessedIndex();
1492     }
1493 
1494     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1495         return dividendTracker.getNumberOfTokenHolders();
1496     }
1497     
1498     function getNumberOfDividends() external view returns(uint256) {
1499         return dividendTracker.totalBalance();
1500     }
1501     
1502     // remove limits after token is stable
1503     function removeLimits() external onlyOwner returns (bool){
1504         limitsInEffect = false;
1505         transferDelayEnabled = false;
1506         return true;
1507     }
1508 
1509     function setBlacklist(address[] memory blacklisted_, bool status_) public onlyOwner {
1510         if (status_ == true) {
1511             require(block.number < tradingActiveBlock + 300, "too late to blacklist");
1512         }
1513         for (uint i = 0; i < blacklisted_.length; i++) {
1514             if (blacklisted_[i] != address(uniswapV2Pair) && blacklisted_[i] != address(uniswapV2Router)) {
1515                 _isblacklisted[blacklisted_[i]] = status_;
1516             }
1517         }
1518     }
1519 
1520     
1521     function _transfer(
1522         address from,
1523         address to,
1524         uint256 amount
1525     ) internal override {
1526         require(from != address(0), "ERC20: transfer from the zero address");
1527         require(to != address(0), "ERC20: transfer to the zero address");
1528         require(!_isblacklisted[to] && !_isblacklisted[from],"unable to trade");
1529 
1530          if(amount == 0) {
1531             super._transfer(from, to, 0);
1532             return;
1533         }
1534         
1535         if(!tradingActive){
1536             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1537         }
1538         
1539         if(limitsInEffect){
1540             if (
1541                 from != owner() &&
1542                 to != owner() &&
1543                 to != address(0) &&
1544                 to != address(0xdead) &&
1545                 !swapping
1546             ){
1547 
1548                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1549                 if (transferDelayEnabled){
1550                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1551                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1552                         _holderLastTransferTimestamp[tx.origin] = block.number;
1553                     }
1554                 }
1555                 
1556                 //when buy
1557                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1558                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1559                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1560                 } 
1561                 //when sell
1562                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1563                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1564                 }
1565                 else if(!_isExcludedMaxTransactionAmount[to]) {
1566                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1567                 }
1568             }
1569         }
1570 
1571 		uint256 contractTokenBalance = balanceOf(address(this));
1572         
1573         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1574 
1575         if( 
1576             canSwap &&
1577             swapEnabled &&
1578             !swapping &&
1579             !automatedMarketMakerPairs[from] &&
1580             !_isExcludedFromFees[from] &&
1581             !_isExcludedFromFees[to]
1582         ) {
1583             swapping = true;
1584             swapBack();
1585             swapping = false;
1586         }
1587 
1588         bool takeFee = !swapping;
1589 
1590         // if any account belongs to _isExcludedFromFee account then remove the fee
1591         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1592             takeFee = false;
1593         }
1594         
1595         uint256 fees = 0;
1596         
1597         // no taxes on transfers (non buys/sells)
1598         if(takeFee){
1599             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1600                 fees = amount.mul(99).div(100);
1601                 tokensForLiquidity += fees * 33 / 99;
1602                 tokensForRewards += fees * 33 / 99;
1603                 tokensForOperations += fees * 33 / 99;
1604             }
1605 
1606             // on sell
1607             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1608                 fees = amount.mul(totalSellFees).div(feeDivisor);
1609                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1610                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1611                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1612             }
1613             
1614             // on buy
1615             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1616         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1617         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1618                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1619                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1620             }
1621 
1622             if(fees > 0){    
1623                 super._transfer(from, address(this), fees);
1624             }
1625         	
1626         	amount -= fees;
1627         }
1628 
1629         super._transfer(from, to, amount);
1630 
1631         dividendTracker.setBalance(payable(from), balanceOf(from));
1632         dividendTracker.setBalance(payable(to), balanceOf(to));
1633 
1634         if(!swapping && gasForProcessing > 0) {
1635 	    	uint256 gas = gasForProcessing;
1636 
1637 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1638 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1639 	    	}
1640 	    	catch {}
1641         }
1642     }
1643     
1644     function swapTokensForEth(uint256 tokenAmount) private {
1645 
1646         // generate the uniswap pair path of token -> weth
1647         address[] memory path = new address[](2);
1648         path[0] = address(this);
1649         path[1] = uniswapV2Router.WETH();
1650 
1651         _approve(address(this), address(uniswapV2Router), tokenAmount);
1652 
1653         // make the swap
1654         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1655             tokenAmount,
1656             0, // accept any amount of ETH
1657             path,
1658             address(this),
1659             block.timestamp
1660         );
1661         
1662     }
1663     
1664     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1665         // approve token transfer to cover all possible scenarios
1666         _approve(address(this), address(uniswapV2Router), tokenAmount);
1667 
1668         // add the liquidity
1669         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1670             address(this),
1671             tokenAmount,
1672             0, // slippage is unavoidable
1673             0, // slippage is unavoidable
1674             address(0x62598ed094c6f7588Cc3f0E5c8D92EF0aeB9Ed3d),
1675             block.timestamp
1676         );
1677 
1678     }
1679     
1680     function swapBack() private {
1681         uint256 contractBalance = balanceOf(address(this));
1682         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1683         
1684         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1685         
1686         // Halve the amount of liquidity tokens
1687         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1688         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1689         
1690         uint256 initialETHBalance = address(this).balance;
1691 
1692         swapTokensForEth(amountToSwapForETH); 
1693         
1694         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1695         
1696         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1697         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1698         
1699         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1700         
1701         tokensForLiquidity = 0;
1702         tokensForOperations = 0;
1703         tokensForRewards = 0;
1704         
1705         if(liquidityTokens > 0 && ethForLiquidity > 0){
1706             addLiquidity(liquidityTokens, ethForLiquidity);
1707             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1708         }
1709         
1710         // call twice to force buy of both reward tokens.
1711         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1712 
1713         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1714     }
1715 
1716     function withdrawStuckEth() external onlyOwner {
1717         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1718         require(success, "failed to withdraw");
1719     }
1720 
1721 }