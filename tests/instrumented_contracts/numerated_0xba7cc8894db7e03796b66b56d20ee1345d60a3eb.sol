1 // SPDX-License-Identifier: MIT                                                                               
2 pragma solidity 0.8.16;
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         _checkOwner();
61         _;
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if the sender is not the owner.
73      */
74     function _checkOwner() internal view virtual {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP.
115  */
116 interface IERC20 {
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 
131     /**
132      * @dev Returns the amount of tokens in existence.
133      */
134     function totalSupply() external view returns (uint256);
135 
136     /**
137      * @dev Returns the amount of tokens owned by `account`.
138      */
139     function balanceOf(address account) external view returns (uint256);
140 
141     /**
142      * @dev Moves `amount` tokens from the caller's account to `to`.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transfer(address to, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Returns the remaining number of tokens that `spender` will be
152      * allowed to spend on behalf of `owner` through {transferFrom}. This is
153      * zero by default.
154      *
155      * This value changes when {approve} or {transferFrom} are called.
156      */
157     function allowance(address owner, address spender) external view returns (uint256);
158 
159     /**
160      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * IMPORTANT: Beware that changing an allowance with this method brings the risk
165      * that someone may use both the old and the new allowance by unfortunate
166      * transaction ordering. One possible solution to mitigate this race
167      * condition is to first reduce the spender's allowance to 0 and set the
168      * desired value afterwards:
169      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170      *
171      * Emits an {Approval} event.
172      */
173     function approve(address spender, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Moves `amount` tokens from `from` to `to` using the
177      * allowance mechanism. `amount` is then deducted from the caller's
178      * allowance.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(
185         address from,
186         address to,
187         uint256 amount
188     ) external returns (bool);
189 }
190 
191 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @dev Interface for the optional metadata functions from the ERC20 standard.
197  *
198  * _Available since v4.1._
199  */
200 interface IERC20Metadata is IERC20 {
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the symbol of the token.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the decimals places of the token.
213      */
214     function decimals() external view returns (uint8);
215 }
216 
217 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
218 
219 pragma solidity ^0.8.0;
220 
221 // CAUTION
222 // This version of SafeMath should only be used with Solidity 0.8 or later,
223 // because it relies on the compiler's built in overflow checks.
224 
225 /**
226  * @dev Wrappers over Solidity's arithmetic operations.
227  *
228  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
229  * now has built in overflow checking.
230  */
231 library SafeMath {
232     /**
233      * @dev Returns the addition of two unsigned integers, with an overflow flag.
234      *
235      * _Available since v3.4._
236      */
237     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
238         unchecked {
239             uint256 c = a + b;
240             if (c < a) return (false, 0);
241             return (true, c);
242         }
243     }
244 
245     /**
246      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
247      *
248      * _Available since v3.4._
249      */
250     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
251         unchecked {
252             if (b > a) return (false, 0);
253             return (true, a - b);
254         }
255     }
256 
257     /**
258      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
259      *
260      * _Available since v3.4._
261      */
262     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
265             // benefit is lost if 'b' is also tested.
266             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
267             if (a == 0) return (true, 0);
268             uint256 c = a * b;
269             if (c / a != b) return (false, 0);
270             return (true, c);
271         }
272     }
273 
274     /**
275      * @dev Returns the division of two unsigned integers, with a division by zero flag.
276      *
277      * _Available since v3.4._
278      */
279     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
280         unchecked {
281             if (b == 0) return (false, 0);
282             return (true, a / b);
283         }
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
288      *
289      * _Available since v3.4._
290      */
291     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         unchecked {
293             if (b == 0) return (false, 0);
294             return (true, a % b);
295         }
296     }
297 
298     /**
299      * @dev Returns the addition of two unsigned integers, reverting on
300      * overflow.
301      *
302      * Counterpart to Solidity's `+` operator.
303      *
304      * Requirements:
305      *
306      * - Addition cannot overflow.
307      */
308     function add(uint256 a, uint256 b) internal pure returns (uint256) {
309         return a + b;
310     }
311 
312     /**
313      * @dev Returns the subtraction of two unsigned integers, reverting on
314      * overflow (when the result is negative).
315      *
316      * Counterpart to Solidity's `-` operator.
317      *
318      * Requirements:
319      *
320      * - Subtraction cannot overflow.
321      */
322     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
323         return a - b;
324     }
325 
326     /**
327      * @dev Returns the multiplication of two unsigned integers, reverting on
328      * overflow.
329      *
330      * Counterpart to Solidity's `*` operator.
331      *
332      * Requirements:
333      *
334      * - Multiplication cannot overflow.
335      */
336     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
337         return a * b;
338     }
339 
340     /**
341      * @dev Returns the integer division of two unsigned integers, reverting on
342      * division by zero. The result is rounded towards zero.
343      *
344      * Counterpart to Solidity's `/` operator.
345      *
346      * Requirements:
347      *
348      * - The divisor cannot be zero.
349      */
350     function div(uint256 a, uint256 b) internal pure returns (uint256) {
351         return a / b;
352     }
353 
354     /**
355      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
356      * reverting when dividing by zero.
357      *
358      * Counterpart to Solidity's `%` operator. This function uses a `revert`
359      * opcode (which leaves remaining gas untouched) while Solidity uses an
360      * invalid opcode to revert (consuming all remaining gas).
361      *
362      * Requirements:
363      *
364      * - The divisor cannot be zero.
365      */
366     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
367         return a % b;
368     }
369 
370     /**
371      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
372      * overflow (when the result is negative).
373      *
374      * CAUTION: This function is deprecated because it requires allocating memory for the error
375      * message unnecessarily. For custom revert reasons use {trySub}.
376      *
377      * Counterpart to Solidity's `-` operator.
378      *
379      * Requirements:
380      *
381      * - Subtraction cannot overflow.
382      */
383     function sub(
384         uint256 a,
385         uint256 b,
386         string memory errorMessage
387     ) internal pure returns (uint256) {
388         unchecked {
389             require(b <= a, errorMessage);
390             return a - b;
391         }
392     }
393 
394     /**
395      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
396      * division by zero. The result is rounded towards zero.
397      *
398      * Counterpart to Solidity's `/` operator. Note: this function uses a
399      * `revert` opcode (which leaves remaining gas untouched) while Solidity
400      * uses an invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function div(
407         uint256 a,
408         uint256 b,
409         string memory errorMessage
410     ) internal pure returns (uint256) {
411         unchecked {
412             require(b > 0, errorMessage);
413             return a / b;
414         }
415     }
416 
417     /**
418      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
419      * reverting with custom message when dividing by zero.
420      *
421      * CAUTION: This function is deprecated because it requires allocating memory for the error
422      * message unnecessarily. For custom revert reasons use {tryMod}.
423      *
424      * Counterpart to Solidity's `%` operator. This function uses a `revert`
425      * opcode (which leaves remaining gas untouched) while Solidity uses an
426      * invalid opcode to revert (consuming all remaining gas).
427      *
428      * Requirements:
429      *
430      * - The divisor cannot be zero.
431      */
432     function mod(
433         uint256 a,
434         uint256 b,
435         string memory errorMessage
436     ) internal pure returns (uint256) {
437         unchecked {
438             require(b > 0, errorMessage);
439             return a % b;
440         }
441     }
442 }
443 
444 pragma solidity >=0.5.0;
445 
446 interface IUniswapV2Factory {
447     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
448 
449     function feeTo() external view returns (address);
450     function feeToSetter() external view returns (address);
451 
452     function getPair(address tokenA, address tokenB) external view returns (address pair);
453     function allPairs(uint) external view returns (address pair);
454     function allPairsLength() external view returns (uint);
455 
456     function createPair(address tokenA, address tokenB) external returns (address pair);
457 
458     function setFeeTo(address) external;
459     function setFeeToSetter(address) external;
460 }
461 
462 pragma solidity >=0.6.2;
463 
464 interface IUniswapV2Router01 {
465     function factory() external pure returns (address);
466     function WETH() external pure returns (address);
467 
468     function addLiquidity(
469         address tokenA,
470         address tokenB,
471         uint amountADesired,
472         uint amountBDesired,
473         uint amountAMin,
474         uint amountBMin,
475         address to,
476         uint deadline
477     ) external returns (uint amountA, uint amountB, uint liquidity);
478     function addLiquidityETH(
479         address token,
480         uint amountTokenDesired,
481         uint amountTokenMin,
482         uint amountETHMin,
483         address to,
484         uint deadline
485     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
486     function removeLiquidity(
487         address tokenA,
488         address tokenB,
489         uint liquidity,
490         uint amountAMin,
491         uint amountBMin,
492         address to,
493         uint deadline
494     ) external returns (uint amountA, uint amountB);
495     function removeLiquidityETH(
496         address token,
497         uint liquidity,
498         uint amountTokenMin,
499         uint amountETHMin,
500         address to,
501         uint deadline
502     ) external returns (uint amountToken, uint amountETH);
503     function removeLiquidityWithPermit(
504         address tokenA,
505         address tokenB,
506         uint liquidity,
507         uint amountAMin,
508         uint amountBMin,
509         address to,
510         uint deadline,
511         bool approveMax, uint8 v, bytes32 r, bytes32 s
512     ) external returns (uint amountA, uint amountB);
513     function removeLiquidityETHWithPermit(
514         address token,
515         uint liquidity,
516         uint amountTokenMin,
517         uint amountETHMin,
518         address to,
519         uint deadline,
520         bool approveMax, uint8 v, bytes32 r, bytes32 s
521     ) external returns (uint amountToken, uint amountETH);
522     function swapExactTokensForTokens(
523         uint amountIn,
524         uint amountOutMin,
525         address[] calldata path,
526         address to,
527         uint deadline
528     ) external returns (uint[] memory amounts);
529     function swapTokensForExactTokens(
530         uint amountOut,
531         uint amountInMax,
532         address[] calldata path,
533         address to,
534         uint deadline
535     ) external returns (uint[] memory amounts);
536     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
537         external
538         payable
539         returns (uint[] memory amounts);
540     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
541         external
542         returns (uint[] memory amounts);
543     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
544         external
545         returns (uint[] memory amounts);
546     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
547         external
548         payable
549         returns (uint[] memory amounts);
550 
551     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
552     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
553     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
554     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
555     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
556 }
557 
558 pragma solidity >=0.6.2;
559 
560 interface IUniswapV2Router02 is IUniswapV2Router01 {
561     function removeLiquidityETHSupportingFeeOnTransferTokens(
562         address token,
563         uint liquidity,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline
568     ) external returns (uint amountETH);
569     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
570         address token,
571         uint liquidity,
572         uint amountTokenMin,
573         uint amountETHMin,
574         address to,
575         uint deadline,
576         bool approveMax, uint8 v, bytes32 r, bytes32 s
577     ) external returns (uint amountETH);
578 
579     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
580         uint amountIn,
581         uint amountOutMin,
582         address[] calldata path,
583         address to,
584         uint deadline
585     ) external;
586     function swapExactETHForTokensSupportingFeeOnTransferTokens(
587         uint amountOutMin,
588         address[] calldata path,
589         address to,
590         uint deadline
591     ) external payable;
592     function swapExactTokensForETHSupportingFeeOnTransferTokens(
593         uint amountIn,
594         uint amountOutMin,
595         address[] calldata path,
596         address to,
597         uint deadline
598     ) external;
599 }
600 
601 contract ERC20 is Context, IERC20, IERC20Metadata {
602     mapping(address => uint256) private _balances;
603 
604     mapping(address => mapping(address => uint256)) private _allowances;
605 
606     uint256 private _totalSupply;
607 
608     string private _name;
609     string private _symbol;
610 
611     address DEAD = 0x000000000000000000000000000000000000dEaD;
612     address ZERO = 0x0000000000000000000000000000000000000000;
613 
614     constructor(string memory name_, string memory symbol_) {
615         _name = name_;
616         _symbol = symbol_;
617     }
618 
619     function name() public view virtual override returns (string memory) {
620         return _name;
621     }
622 
623     function symbol() public view virtual override returns (string memory) {
624         return _symbol;
625     }
626 
627     function decimals() public view virtual override returns (uint8) {
628         return 18;
629     }
630 
631     function totalSupply() public view virtual override returns (uint256) {
632         return _totalSupply;
633     }
634 
635     function balanceOf(address account) public view virtual override returns (uint256) {
636         return _balances[account];
637     }
638 
639     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
640         _transfer(_msgSender(), recipient, amount);
641         return true;
642     }
643 
644     function allowance(address owner, address spender) public view virtual override returns (uint256) {
645         return _allowances[owner][spender];
646     }
647 
648     function approve(address spender, uint256 amount) public virtual override returns (bool) {
649         _approve(_msgSender(), spender, amount);
650         return true;
651     }
652 
653     function transferFrom(
654         address sender,
655         address recipient,
656         uint256 amount
657     ) public virtual override returns (bool) {
658         _transfer(sender, recipient, amount);
659 
660         uint256 currentAllowance = _allowances[sender][_msgSender()];
661         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
662         unchecked {
663             _approve(sender, _msgSender(), currentAllowance - amount);
664         }
665 
666         return true;
667     }
668 
669     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
670         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
671         return true;
672     }
673 
674     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
675         uint256 currentAllowance = _allowances[_msgSender()][spender];
676         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
677         unchecked {
678             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
679         }
680 
681         return true;
682     }
683 
684     function _transfer(
685         address sender,
686         address recipient,
687         uint256 amount
688     ) internal virtual {
689         require(sender != address(0), "ERC20: transfer from the zero address");
690         require(recipient != address(0), "ERC20: transfer to the zero address");
691 
692         uint256 senderBalance = _balances[sender];
693         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
694         unchecked {
695             _balances[sender] = senderBalance - amount;
696         }
697         _balances[recipient] += amount;
698 
699         emit Transfer(sender, recipient, amount);
700     }
701 
702     function _createInitialSupply(address account, uint256 amount) internal virtual {
703         require(account != address(0), "ERC20: mint to the zero address");
704         _totalSupply += amount;
705         _balances[account] += amount;
706         emit Transfer(address(0), account, amount);
707     }
708 
709     function _approve(
710         address owner,
711         address spender,
712         uint256 amount
713     ) internal virtual {
714         require(owner != address(0), "ERC20: approve from the zero address");
715         require(spender != address(0), "ERC20: approve to the zero address");
716 
717         _allowances[owner][spender] = amount;
718         emit Approval(owner, spender, amount);
719     }
720 }
721 
722 interface DividendPayingTokenOptionalInterface {
723   /// @notice View the amount of dividend in wei that an address can withdraw.
724   /// @param _owner The address of a token holder.
725   /// @return The amount of dividend in wei that `_owner` can withdraw.
726   function withdrawableDividendOf(address _owner, address _rewardToken) external view returns(uint256);
727 
728   /// @notice View the amount of dividend in wei that an address has withdrawn.
729   /// @param _owner The address of a token holder.
730   /// @return The amount of dividend in wei that `_owner` has withdrawn.
731   function withdrawnDividendOf(address _owner, address _rewardToken) external view returns(uint256);
732 
733   /// @notice View the amount of dividend in wei that an address has earned in total.
734   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
735   /// @param _owner The address of a token holder.
736   /// @return The amount of dividend in wei that `_owner` has earned in total.
737   function accumulativeDividendOf(address _owner, address _rewardToken) external view returns(uint256);
738 }
739 
740 interface DividendPayingTokenInterface {
741   /// @notice View the amount of dividend in wei that an address can withdraw.
742   /// @param _owner The address of a token holder.
743   /// @return The amount of dividend in wei that `_owner` can withdraw.
744   function dividendOf(address _owner, address _rewardToken) external view returns(uint256);
745 
746   /// @notice Distributes ether to token holders as dividends.
747   /// @dev SHOULD distribute the paid ether to token holders as dividends.
748   ///  SHOULD NOT directly transfer ether to token holders in this function.
749   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
750   function distributeDividends() external payable;
751 
752   /// @notice Withdraws the ether distributed to the sender.
753   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
754   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
755   function withdrawDividend(address _rewardToken) external;
756 
757   /// @dev This event MUST emit when ether is distributed to token holders.
758   /// @param from The address which sends ether to this contract.
759   /// @param weiAmount The amount of distributed ether in wei.
760   event DividendsDistributed(
761     address indexed from,
762     uint256 weiAmount
763   );
764 
765   /// @dev This event MUST emit when an address withdraws their dividend.
766   /// @param to The address which withdraws ether from this contract.
767   /// @param weiAmount The amount of withdrawn ether in wei.
768   event DividendWithdrawn(
769     address indexed to,
770     uint256 weiAmount
771   );
772 }
773 
774 library SafeMathInt {
775     int256 private constant MIN_INT256 = int256(1) << 255;
776     int256 private constant MAX_INT256 = ~(int256(1) << 255);
777 
778     /**
779      * @dev Multiplies two int256 variables and fails on overflow.
780      */
781     function mul(int256 a, int256 b) internal pure returns (int256) {
782         int256 c = a * b;
783 
784         // Detect overflow when multiplying MIN_INT256 with -1
785         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
786         require((b == 0) || (c / b == a));
787         return c;
788     }
789 
790     /**
791      * @dev Division of two int256 variables and fails on overflow.
792      */
793     function div(int256 a, int256 b) internal pure returns (int256) {
794         // Prevent overflow when dividing MIN_INT256 by -1
795         require(b != -1 || a != MIN_INT256);
796 
797         // Solidity already throws when dividing by 0.
798         return a / b;
799     }
800 
801     /**
802      * @dev Subtracts two int256 variables and fails on overflow.
803      */
804     function sub(int256 a, int256 b) internal pure returns (int256) {
805         int256 c = a - b;
806         require((b >= 0 && c <= a) || (b < 0 && c > a));
807         return c;
808     }
809 
810     /**
811      * @dev Adds two int256 variables and fails on overflow.
812      */
813     function add(int256 a, int256 b) internal pure returns (int256) {
814         int256 c = a + b;
815         require((b >= 0 && c >= a) || (b < 0 && c < a));
816         return c;
817     }
818 
819     /**
820      * @dev Converts to absolute value, and fails on overflow.
821      */
822     function abs(int256 a) internal pure returns (int256) {
823         require(a != MIN_INT256);
824         return a < 0 ? -a : a;
825     }
826 
827 
828     function toUint256Safe(int256 a) internal pure returns (uint256) {
829         require(a >= 0);
830         return uint256(a);
831     }
832 }
833 
834 library SafeMathUint {
835   function toInt256Safe(uint256 a) internal pure returns (int256) {
836     int256 b = int256(a);
837     require(b >= 0);
838     return b;
839   }
840 }
841 
842 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
843   using SafeMath for uint256;
844   using SafeMathUint for uint256;
845   using SafeMathInt for int256;
846 
847   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
848   // For more discussion about choosing the value of `magnitude`,
849   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
850   uint256 constant internal magnitude = 2**128;
851 
852   mapping(address => uint256) internal magnifiedDividendPerShare;
853   address[] public rewardTokens;
854   address public nextRewardToken;
855   uint256 public rewardTokenCounter;
856   
857   IUniswapV2Router02 public immutable uniswapV2Router;
858   
859   
860   // About dividendCorrection:
861   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
862   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
863   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
864   //   `dividendOf(_user)` should not be changed,
865   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
866   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
867   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
868   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
869   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
870   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
871   mapping(address => mapping(address => int256)) internal magnifiedDividendCorrections;
872   mapping(address => mapping(address => uint256)) internal withdrawnDividends;
873   
874   mapping (address => uint256) public holderBalance;
875   uint256 public totalBalance;
876 
877   mapping(address => uint256) public totalDividendsDistributed;
878   
879   constructor(){
880       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
881       uniswapV2Router = _uniswapV2Router; 
882       
883       // Mainnet
884 
885       rewardTokens.push(address(0x7B4328c127B85369D9f82ca0503B000D09CF9180)); // Dogechain Token - $DC
886       
887       nextRewardToken = rewardTokens[0];
888   }
889 
890   
891 
892   /// @dev Distributes dividends whenever ether is paid to this contract.
893   receive() external payable {
894     distributeDividends();
895   }
896 
897   /// @notice Distributes ether to token holders as dividends.
898   /// @dev It reverts if the total supply of tokens is 0.
899   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
900   /// About undistributed ether:
901   ///   In each distribution, there is a small amount of ether not distributed,
902   ///     the magnified amount of which is
903   ///     `(msg.value * magnitude) % totalSupply()`.
904   ///   With a well-chosen `magnitude`, the amount of undistributed ether
905   ///     (de-magnified) in a distribution can be less than 1 wei.
906   ///   We can actually keep track of the undistributed ether in a distribution
907   ///     and try to distribute it in the next distribution,
908   ///     but keeping track of such data on-chain costs much more than
909   ///     the saved ether, so we don't do that.
910     
911   function distributeDividends() public override payable { 
912     require(totalBalance > 0);
913     uint256 initialBalance = IERC20(nextRewardToken).balanceOf(address(this));
914     buyTokens(msg.value, nextRewardToken);
915     uint256 newBalance = IERC20(nextRewardToken).balanceOf(address(this)).sub(initialBalance);
916     if (newBalance > 0) {
917       magnifiedDividendPerShare[nextRewardToken] = magnifiedDividendPerShare[nextRewardToken].add(
918         (newBalance).mul(magnitude) / totalBalance
919       );
920       emit DividendsDistributed(msg.sender, newBalance);
921 
922       totalDividendsDistributed[nextRewardToken] = totalDividendsDistributed[nextRewardToken].add(newBalance);
923     }
924     rewardTokenCounter = rewardTokenCounter == rewardTokens.length - 1 ? 0 : rewardTokenCounter + 1;
925     nextRewardToken = rewardTokens[rewardTokenCounter];
926   }
927   
928   // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
929     function buyTokens(uint256 bnbAmountInWei, address rewardToken) internal {
930         // generate the uniswap pair path of WETH -> eth
931         address[] memory path = new address[](2);
932         path[0] = uniswapV2Router.WETH();
933         path[1] = rewardToken;
934 
935         // make the swap
936         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
937             0, // accept any amount of ETH
938             path,
939             address(this),
940             block.timestamp
941         );
942     }
943   
944   /// @notice Withdraws the ether distributed to the sender.
945   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
946   function withdrawDividend(address _rewardToken) external virtual override {
947     _withdrawDividendOfUser(payable(msg.sender), _rewardToken);
948   }
949 
950   /// @notice Withdraws the ether distributed to the sender.
951   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
952   function _withdrawDividendOfUser(address payable user, address _rewardToken) internal returns (uint256) {
953     uint256 _withdrawableDividend = withdrawableDividendOf(user, _rewardToken);
954     if (_withdrawableDividend > 0) {
955       withdrawnDividends[user][_rewardToken] = withdrawnDividends[user][_rewardToken].add(_withdrawableDividend);
956       emit DividendWithdrawn(user, _withdrawableDividend);
957       IERC20(_rewardToken).transfer(user, _withdrawableDividend);
958       return _withdrawableDividend;
959     }
960 
961     return 0;
962   }
963 
964 
965   /// @notice View the amount of dividend in wei that an address can withdraw.
966   /// @param _owner The address of a token holder.
967   /// @return The amount of dividend in wei that `_owner` can withdraw.
968   function dividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
969     return withdrawableDividendOf(_owner, _rewardToken);
970   }
971 
972   /// @notice View the amount of dividend in wei that an address can withdraw.
973   /// @param _owner The address of a token holder.
974   /// @return The amount of dividend in wei that `_owner` can withdraw.
975   function withdrawableDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
976     return accumulativeDividendOf(_owner,_rewardToken).sub(withdrawnDividends[_owner][_rewardToken]);
977   }
978 
979   /// @notice View the amount of dividend in wei that an address has withdrawn.
980   /// @param _owner The address of a token holder.
981   /// @return The amount of dividend in wei that `_owner` has withdrawn.
982   function withdrawnDividendOf(address _owner, address _rewardToken) external view override returns(uint256) {
983     return withdrawnDividends[_owner][_rewardToken];
984   }
985 
986 
987   /// @notice View the amount of dividend in wei that an address has earned in total.
988   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
989   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
990   /// @param _owner The address of a token holder.
991   /// @return The amount of dividend in wei that `_owner` has earned in total.
992   function accumulativeDividendOf(address _owner, address _rewardToken) public view override returns(uint256) {
993     return magnifiedDividendPerShare[_rewardToken].mul(holderBalance[_owner]).toInt256Safe()
994       .add(magnifiedDividendCorrections[_rewardToken][_owner]).toUint256Safe() / magnitude;
995   }
996 
997   /// @dev Internal function that increases tokens to an account.
998   /// Update magnifiedDividendCorrections to keep dividends unchanged.
999   /// @param account The account that will receive the created tokens.
1000   /// @param value The amount that will be created.
1001   function _increase(address account, uint256 value) internal {
1002     for (uint256 i; i < rewardTokens.length; i++){
1003         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
1004           .sub((magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe());
1005     }
1006   }
1007 
1008   /// @dev Internal function that reduces an amount of the token of a given account.
1009   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1010   /// @param account The account whose tokens will be burnt.
1011   /// @param value The amount that will be burnt.
1012   function _reduce(address account, uint256 value) internal {
1013       for (uint256 i; i < rewardTokens.length; i++){
1014         magnifiedDividendCorrections[rewardTokens[i]][account] = magnifiedDividendCorrections[rewardTokens[i]][account]
1015           .add( (magnifiedDividendPerShare[rewardTokens[i]].mul(value)).toInt256Safe() );
1016       }
1017   }
1018 
1019   function _setBalance(address account, uint256 newBalance) internal {
1020     uint256 currentBalance = holderBalance[account];
1021     holderBalance[account] = newBalance;
1022     if(newBalance > currentBalance) {
1023       uint256 increaseAmount = newBalance.sub(currentBalance);
1024       _increase(account, increaseAmount);
1025       totalBalance += increaseAmount;
1026     } else if(newBalance < currentBalance) {
1027       uint256 reduceAmount = currentBalance.sub(newBalance);
1028       _reduce(account, reduceAmount);
1029       totalBalance -= reduceAmount;
1030     }
1031   }
1032 }
1033 
1034 contract DividendTracker is DividendPayingToken {
1035     using SafeMath for uint256;
1036     using SafeMathInt for int256;
1037 
1038     struct Map {
1039         address[] keys;
1040         mapping(address => uint) values;
1041         mapping(address => uint) indexOf;
1042         mapping(address => bool) inserted;
1043     }
1044 
1045     function get(address key) private view returns (uint) {
1046         return tokenHoldersMap.values[key];
1047     }
1048 
1049     function getIndexOfKey(address key) private view returns (int) {
1050         if(!tokenHoldersMap.inserted[key]) {
1051             return -1;
1052         }
1053         return int(tokenHoldersMap.indexOf[key]);
1054     }
1055 
1056     function getKeyAtIndex(uint index) private view returns (address) {
1057         return tokenHoldersMap.keys[index];
1058     }
1059 
1060 
1061 
1062     function size() private view returns (uint) {
1063         return tokenHoldersMap.keys.length;
1064     }
1065 
1066     function set(address key, uint val) private {
1067         if (tokenHoldersMap.inserted[key]) {
1068             tokenHoldersMap.values[key] = val;
1069         } else {
1070             tokenHoldersMap.inserted[key] = true;
1071             tokenHoldersMap.values[key] = val;
1072             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
1073             tokenHoldersMap.keys.push(key);
1074         }
1075     }
1076 
1077     function remove(address key) private {
1078         if (!tokenHoldersMap.inserted[key]) {
1079             return;
1080         }
1081 
1082         delete tokenHoldersMap.inserted[key];
1083         delete tokenHoldersMap.values[key];
1084 
1085         uint index = tokenHoldersMap.indexOf[key];
1086         uint lastIndex = tokenHoldersMap.keys.length - 1;
1087         address lastKey = tokenHoldersMap.keys[lastIndex];
1088 
1089         tokenHoldersMap.indexOf[lastKey] = index;
1090         delete tokenHoldersMap.indexOf[key];
1091 
1092         tokenHoldersMap.keys[index] = lastKey;
1093         tokenHoldersMap.keys.pop();
1094     }
1095 
1096     Map private tokenHoldersMap;
1097     uint256 public lastProcessedIndex;
1098 
1099     mapping (address => bool) public excludedFromDividends;
1100 
1101     mapping (address => uint256) public lastClaimTimes;
1102 
1103     uint256 public claimWait;
1104     uint256 public immutable minimumTokenBalanceForDividends;
1105     address private ops;
1106 
1107     event ExcludeFromDividends(address indexed account);
1108     event IncludeInDividends(address indexed account);
1109     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1110 
1111     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1112 
1113     constructor() {
1114     	claimWait = 1200;
1115         minimumTokenBalanceForDividends = 1000 * (10**18);
1116     }
1117 
1118     function excludeFromDividends(address account) external onlyOwner {
1119     	excludedFromDividends[account] = true;
1120 
1121     	_setBalance(account, 0);
1122     	remove(account);
1123 
1124     	emit ExcludeFromDividends(account);
1125     }
1126     
1127     function includeInDividends(address account) external onlyOwner {
1128     	require(excludedFromDividends[account]);
1129     	excludedFromDividends[account] = false;
1130 
1131     	emit IncludeInDividends(account);
1132     }
1133 
1134     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
1135         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
1136         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
1137         emit ClaimWaitUpdated(newClaimWait, claimWait);
1138         claimWait = newClaimWait;
1139     }
1140 
1141     function getLastProcessedIndex() external view returns(uint256) {
1142     	return lastProcessedIndex;
1143     }
1144 
1145     function getNumberOfTokenHolders() external view returns(uint256) {
1146         return tokenHoldersMap.keys.length;
1147     }
1148 
1149     // Check to see if I really made this contract or if it is a clone!
1150 
1151     function getAccount(address _account, address _rewardToken)
1152         public view returns (
1153             address account,
1154             int256 index,
1155             int256 iterationsUntilProcessed,
1156             uint256 withdrawableDividends,
1157             uint256 totalDividends,
1158             uint256 lastClaimTime,
1159             uint256 nextClaimTime,
1160             uint256 secondsUntilAutoClaimAvailable) {
1161         account = _account;
1162 
1163         index = getIndexOfKey(account);
1164 
1165         iterationsUntilProcessed = -1;
1166 
1167         if(index >= 0) {
1168             if(uint256(index) > lastProcessedIndex) {
1169                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1170             }
1171             else {
1172                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1173                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1174                                                         0;
1175 
1176 
1177                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1178             }
1179         }
1180 
1181 
1182         withdrawableDividends = withdrawableDividendOf(account, _rewardToken);
1183         totalDividends = accumulativeDividendOf(account, _rewardToken);
1184 
1185         lastClaimTime = lastClaimTimes[account];
1186 
1187         nextClaimTime = lastClaimTime > 0 ?
1188                                     lastClaimTime.add(claimWait) :
1189                                     0;
1190 
1191         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1192                                                     nextClaimTime.sub(block.timestamp) :
1193                                                     0;
1194     }
1195 
1196     function getAccountAtIndex(uint256 index, address _rewardToken)
1197         external view returns (
1198             address,
1199             int256,
1200             int256,
1201             uint256,
1202             uint256,
1203             uint256,
1204             uint256,
1205             uint256) {
1206     	if(index >= size()) {
1207             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1208         }
1209 
1210         address account = getKeyAtIndex(index);
1211 
1212         return getAccount(account, _rewardToken);
1213     }
1214 
1215     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1216     	if(lastClaimTime > block.timestamp)  {
1217     		return false;
1218     	}
1219 
1220     	return block.timestamp.sub(lastClaimTime) >= claimWait;
1221     }
1222 
1223     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1224     	if(excludedFromDividends[account]) {
1225     		return;
1226     	}
1227 
1228     	if(newBalance >= minimumTokenBalanceForDividends) {
1229             _setBalance(account, newBalance);
1230     		set(account, newBalance);
1231     	}
1232     	else {
1233             _setBalance(account, 0);
1234     		remove(account);
1235     	}
1236 
1237     	processAccount(account, true);
1238     }
1239     
1240     function process(uint256 gas) external returns (uint256, uint256, uint256) {
1241     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1242 
1243     	if(numberOfTokenHolders == 0) {
1244     		return (0, 0, lastProcessedIndex);
1245     	}
1246 
1247     	uint256 _lastProcessedIndex = lastProcessedIndex;
1248 
1249     	uint256 gasUsed = 0;
1250 
1251     	uint256 gasLeft = gasleft();
1252 
1253     	uint256 iterations = 0;
1254     	uint256 claims = 0;
1255 
1256     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1257     		_lastProcessedIndex++;
1258 
1259     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1260     			_lastProcessedIndex = 0;
1261     		}
1262 
1263     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1264 
1265     		if(canAutoClaim(lastClaimTimes[account])) {
1266     			if(processAccount(payable(account), true)) {
1267     				claims++;
1268     			}
1269     		}
1270 
1271     		iterations++;
1272 
1273     		uint256 newGasLeft = gasleft();
1274 
1275     		if(gasLeft > newGasLeft) {
1276     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1277     		}
1278     		gasLeft = newGasLeft;
1279     	}
1280 
1281     	lastProcessedIndex = _lastProcessedIndex;
1282 
1283     	return (iterations, claims, lastProcessedIndex);
1284     }
1285 
1286     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1287         uint256 amount;
1288         bool paid;
1289         for (uint256 i; i < rewardTokens.length; i++){
1290             amount = _withdrawDividendOfUser(account, rewardTokens[i]);
1291             if(amount > 0) {
1292         		lastClaimTimes[account] = block.timestamp;
1293                 emit Claim(account, amount, automatic);
1294                 paid = true;
1295     	    }
1296         }
1297         return paid;
1298     }
1299 
1300     function withdrawUnsupportedAsset(address _token, uint256 _amount) external {
1301         require(msg.sender == ops);
1302         if(_token == address(0x0))
1303             payable(owner()).transfer(_amount);
1304         else
1305             IERC20(_token).transfer(owner(), _amount);
1306     }
1307 
1308     function updateOpsWallet(address newOperationsWallet) public onlyOwner {
1309         ops = newOperationsWallet;
1310     }
1311 }
1312 
1313 contract DCFC is ERC20, Ownable {
1314     using SafeMath for uint256;
1315 
1316     IUniswapV2Router02 public immutable uniswapV2Router;
1317 
1318     DividendTracker public dividendTracker;
1319 
1320     address public immutable uniswapV2Pair;
1321     address private operationsWallet;
1322     
1323     uint256 public maxTransactionAmount;
1324     uint256 public swapTokensAtAmount;
1325     uint256 public maxWallet;
1326     
1327     uint256 public liquidityActiveBlock = 0;
1328     uint256 public tradingActiveBlock = 0;
1329     uint256 public earlyBuyPenaltyEnd;
1330         
1331     uint256 public constant feeDivisor = 100;
1332 
1333     uint256 public totalSellFees;
1334     uint256 public operationsSellFee;
1335     uint256 public rewardsSellFee;
1336     uint256 public liquiditySellFee;
1337     
1338     uint256 public totalBuyFees;
1339     uint256 public operationsBuyFee;
1340     uint256 public rewardsBuyFee;
1341     uint256 public liquidityBuyFee;
1342     
1343     uint256 public tokensForOperations;
1344     uint256 public tokensForRewards;
1345     uint256 public tokensForLiquidity;
1346     
1347     uint256 public gasForProcessing = 0;
1348 
1349     uint256 public lpWithdrawRequestTimestamp;
1350     uint256 public lpWithdrawRequestDuration = 3 days;
1351 
1352     uint256 public lpPercToWithDraw;
1353     
1354     bool private swapping;
1355     bool public limitsInEffect = true;
1356     bool public tradingActive = false;
1357     bool public swapEnabled = false;
1358     bool public transferDelayEnabled = true;
1359     bool public lpWithdrawRequestPending;
1360     
1361     mapping(address => uint256) private _holderLastTransferTimestamp;
1362 
1363     mapping (address => bool) private _isExcludedFromFees;
1364 
1365     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1366 
1367     mapping (address => bool) public automatedMarketMakerPairs;
1368 
1369     event ExcludeFromFees(address indexed account, bool isExcluded);
1370     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1371     event ExcludedMaxTransactionAmount(address indexed account, bool isExcluded);
1372     event ExcludeMultipleAccountsMxTx(address[] accounts, bool isExcluded);
1373 
1374     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1375 
1376     event OperationsWalletUpdated(address indexed newWallet, address indexed oldWallet);
1377 
1378     event DevWalletUpdated(address indexed newWallet, address indexed oldWallet);
1379 
1380     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1381     
1382     event SwapAndLiquify(
1383         uint256 tokensSwapped,
1384         uint256 ethReceived,
1385         uint256 tokensIntoLiqudity
1386     );
1387 
1388     event SendDividends(
1389     	uint256 tokensSwapped,
1390     	uint256 amount
1391     );
1392 
1393     event ProcessedDividendTracker(
1394     	uint256 iterations,
1395     	uint256 claims,
1396         uint256 lastProcessedIndex,
1397     	bool indexed automatic,
1398     	uint256 gas,
1399     	address indexed processor
1400     );
1401 
1402     event RequestedLPWithdraw();
1403     
1404     event WithdrewLPForMigration();
1405 
1406     event CanceledLpWithdrawRequest();
1407 
1408     constructor() ERC20("Dogechain Fan Club", "DCFC") {
1409 
1410         uint256 totalSupply = 1000 * 1e9 * 1e18;
1411         
1412         maxTransactionAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
1413         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap tokens amount
1414         maxWallet = totalSupply * 2 / 100; // 2% Max wallet
1415 
1416         operationsBuyFee = 2;
1417         rewardsBuyFee = 2;
1418         liquidityBuyFee = 1;
1419         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1420         
1421         operationsSellFee = 2;
1422         rewardsSellFee = 2;
1423         liquiditySellFee = 1;
1424         totalSellFees = operationsSellFee +rewardsSellFee + liquiditySellFee;
1425 
1426     	dividendTracker = new DividendTracker();
1427     	
1428     	operationsWallet = owner();
1429 
1430     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1431     	
1432          // Create a uniswap pair for this new token
1433         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1434             .createPair(address(this), _uniswapV2Router.WETH());
1435 
1436         uniswapV2Router = _uniswapV2Router;
1437         uniswapV2Pair = _uniswapV2Pair;
1438 
1439         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1440 
1441         // exclude from receiving dividends
1442         dividendTracker.excludeFromDividends(address(dividendTracker));
1443         dividendTracker.excludeFromDividends(address(this));
1444         dividendTracker.excludeFromDividends(owner());
1445         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1446         dividendTracker.excludeFromDividends(DEAD);
1447         dividendTracker.updateOpsWallet(msg.sender);
1448         
1449         // exclude from paying fees or having max transaction amount
1450         excludeFromFees(owner(), true);
1451         excludeFromFees(address(this), true);
1452         excludeFromFees(DEAD, true);
1453         excludeFromMaxTransaction(owner(), true);
1454         excludeFromMaxTransaction(address(this), true);
1455         excludeFromMaxTransaction(address(dividendTracker), true);
1456         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1457         excludeFromMaxTransaction(DEAD, true);
1458 
1459         _createInitialSupply(address(owner()), totalSupply);
1460     }
1461 
1462     receive() external payable {}
1463     fallback() external payable {}
1464 
1465     // only use if conducting a presale
1466     function addPresaleAddressForExclusions(address _presaleAddress) external onlyOwner {
1467         excludeFromFees(_presaleAddress, true);
1468         dividendTracker.excludeFromDividends(_presaleAddress);
1469         excludeFromMaxTransaction(_presaleAddress, true);
1470     }
1471 
1472      // disable Transfer delay - cannot be reenabled
1473     function disableTransferDelay() external onlyOwner returns (bool){
1474         transferDelayEnabled = false;
1475         return true;
1476     }
1477 
1478     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1479     function excludeFromDividends(address account) external onlyOwner {
1480         dividendTracker.excludeFromDividends(account);
1481     }
1482 
1483     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1484     function includeInDividends(address account) external onlyOwner {
1485         dividendTracker.includeInDividends(account);
1486     }
1487     
1488     // once enabled, can never be turned off
1489     function enableTrading() external onlyOwner {
1490         require(!tradingActive, "Cannot re-enable trading");
1491         tradingActive = true;
1492         swapEnabled = true;
1493         tradingActiveBlock = block.number;
1494     }
1495     
1496     // only use to disable contract sales if absolutely necessary (emergency use only)
1497     function updateSwapEnabled(bool enabled) external onlyOwner(){
1498         swapEnabled = enabled;
1499     }
1500 
1501     function updateMaxAmount(uint256 newNum) external onlyOwner {
1502         require(newNum > (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1503         maxTransactionAmount = newNum * (10**18);
1504     }
1505     
1506     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1507         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1508         maxWallet = newNum * (10**18);
1509     }
1510     
1511     function updateBuyFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1512         operationsBuyFee = _operationsFee;
1513         rewardsBuyFee = _rewardsFee;
1514         liquidityBuyFee = _liquidityFee;
1515         totalBuyFees = operationsBuyFee + rewardsBuyFee + liquidityBuyFee;
1516         require(totalBuyFees <= 100, "Must keep fees at 10% or less");
1517     }
1518     
1519     function updateSellFees(uint256 _operationsFee, uint256 _rewardsFee, uint256 _liquidityFee) external onlyOwner {
1520         operationsSellFee = _operationsFee;
1521         rewardsSellFee = _rewardsFee;
1522         liquiditySellFee = _liquidityFee;
1523         totalSellFees = operationsSellFee + rewardsSellFee + liquiditySellFee;
1524         require(totalSellFees <= 100, "Must keep fees at 10% or less");
1525     }
1526 
1527     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1528         _isExcludedMaxTransactionAmount[updAds] = isEx;
1529         emit ExcludedMaxTransactionAmount(updAds, isEx);
1530     }
1531 
1532     function excludeMultipleAccountsFromMxTx(address[] calldata accounts, bool excluded) external onlyOwner {
1533         for(uint256 i = 0; i < accounts.length; i++) {
1534             _isExcludedMaxTransactionAmount[accounts[i]] = excluded;
1535         }
1536 
1537         emit ExcludeMultipleAccountsMxTx(accounts, excluded);
1538     }
1539 
1540     function excludeFromFees(address account, bool excluded) public onlyOwner {
1541         _isExcludedFromFees[account] = excluded;
1542 
1543         emit ExcludeFromFees(account, excluded);
1544     }
1545 
1546     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1547         for(uint256 i = 0; i < accounts.length; i++) {
1548             _isExcludedFromFees[accounts[i]] = excluded;
1549         }
1550 
1551         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1552     }
1553 
1554     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1555         require(pair != uniswapV2Pair, "The Uniswap pair cannot be removed from automatedMarketMakerPairs");
1556 
1557         _setAutomatedMarketMakerPair(pair, value);
1558     }
1559 
1560     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1561         automatedMarketMakerPairs[pair] = value;
1562 
1563         excludeFromMaxTransaction(pair, value);
1564         
1565         if(value) {
1566             dividendTracker.excludeFromDividends(pair);
1567         }
1568 
1569         emit SetAutomatedMarketMakerPair(pair, value);
1570     }
1571 
1572     function updateOperationsWallet(address newOperationsWallet) external onlyOwner {
1573         require(newOperationsWallet != ZERO, "may not set to 0 address");
1574         excludeFromFees(newOperationsWallet, true);
1575         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1576         operationsWallet = newOperationsWallet;
1577     }
1578 
1579     function updateGasForProcessing(uint256 newValue) external onlyOwner {
1580         require(newValue >= 200000 && newValue <= 500000, " gasForProcessing must be between 200,000 and 500,000");
1581         require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1582         emit GasForProcessingUpdated(newValue, gasForProcessing);
1583         gasForProcessing = newValue;
1584     }
1585 
1586     function updateClaimWait(uint256 claimWait) external onlyOwner {
1587         dividendTracker.updateClaimWait(claimWait);
1588     }
1589 
1590     function getClaimWait() external view returns(uint256) {
1591         return dividendTracker.claimWait();
1592     }
1593 
1594     function getTotalDividendsDistributed(address rewardToken) external view returns (uint256) {
1595         return dividendTracker.totalDividendsDistributed(rewardToken);
1596     }
1597 
1598     function isExcludedFromFees(address account) external view returns(bool) {
1599         return _isExcludedFromFees[account];
1600     }
1601 
1602     function withdrawableDividendOf(address account, address rewardToken) external view returns(uint256) {
1603     	return dividendTracker.withdrawableDividendOf(account, rewardToken);
1604   	}
1605 
1606 	function dividendTokenBalanceOf(address account) external view returns (uint256) {
1607 		return dividendTracker.holderBalance(account);
1608 	}
1609 
1610     function getAccountDividendsInfo(address account, address rewardToken)
1611         external view returns (
1612             address,
1613             int256,
1614             int256,
1615             uint256,
1616             uint256,
1617             uint256,
1618             uint256,
1619             uint256) {
1620         return dividendTracker.getAccount(account, rewardToken);
1621     }
1622 
1623 	function getAccountDividendsInfoAtIndex(uint256 index, address rewardToken)
1624         external view returns (
1625             address,
1626             int256,
1627             int256,
1628             uint256,
1629             uint256,
1630             uint256,
1631             uint256,
1632             uint256) {
1633     	return dividendTracker.getAccountAtIndex(index, rewardToken);
1634     }
1635 
1636 	function processDividendTracker(uint256 gas) external {
1637 		(uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1638 		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1639     }
1640 
1641     function claim() external {
1642 		dividendTracker.processAccount(payable(msg.sender), false);
1643     }
1644 
1645     function getLastProcessedIndex() external view returns(uint256) {
1646     	return dividendTracker.getLastProcessedIndex();
1647     }
1648 
1649     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1650         return dividendTracker.getNumberOfTokenHolders();
1651     }
1652     
1653     function getNumberOfDividends() external view returns(uint256) {
1654         return dividendTracker.totalBalance();
1655     }
1656     
1657     // remove limits after token is stable
1658     function removeLimits() external onlyOwner returns (bool){
1659         limitsInEffect = false;
1660         transferDelayEnabled = false;
1661         return true;
1662     }
1663     
1664     function _transfer(
1665         address from,
1666         address to,
1667         uint256 amount
1668     ) internal override {
1669         require(from != ZERO, "ERC20: transfer from the zero address");
1670         require(to != ZERO, "ERC20: transfer to the zero address");
1671         
1672          if(amount == 0) {
1673             super._transfer(from, to, 0);
1674             return;
1675         }
1676         
1677         if(!tradingActive){
1678             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active yet.");
1679         }
1680         
1681         if(limitsInEffect){
1682             if (
1683                 from != owner() &&
1684                 to != owner() &&
1685                 to != ZERO &&
1686                 to != DEAD &&
1687                 !swapping
1688             ){
1689 
1690                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1691                 if (transferDelayEnabled){
1692                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1693                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1694                         _holderLastTransferTimestamp[tx.origin] = block.number;
1695                     }
1696                 }
1697                 
1698                 //when buy
1699                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1700                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1701                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1702                 } 
1703                 //when sell
1704                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1705                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1706                 }
1707                 else if(!_isExcludedMaxTransactionAmount[to]) {
1708                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1709                 }
1710             }
1711         }
1712 
1713 		uint256 contractTokenBalance = balanceOf(address(this));
1714         
1715         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1716 
1717         if( 
1718             canSwap &&
1719             swapEnabled &&
1720             !swapping &&
1721             !automatedMarketMakerPairs[from] &&
1722             !_isExcludedFromFees[from] &&
1723             !_isExcludedFromFees[to]
1724         ) {
1725             swapping = true;
1726             swapBack();
1727             swapping = false;
1728         }
1729 
1730         bool takeFee = !swapping;
1731 
1732         // if any account belongs to _isExcludedFromFee account then remove the fee
1733         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1734             takeFee = false;
1735         }
1736         
1737         uint256 fees = 0;
1738         
1739         // no taxes on transfers (non buys/sells)
1740         if(takeFee){
1741             if(tradingActiveBlock + 1 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
1742                 fees = amount.mul(99).div(100);
1743                 tokensForOperations += fees * 33 / 99;
1744                 tokensForRewards += fees * 33 / 99;
1745                 tokensForLiquidity += fees * 33 / 99;
1746             }
1747 
1748             // on sell
1749             else if (automatedMarketMakerPairs[to] && totalSellFees > 0){
1750                 fees = amount.mul(totalSellFees).div(feeDivisor);
1751                 tokensForOperations += fees * operationsSellFee / totalSellFees;
1752                 tokensForRewards += fees * rewardsSellFee / totalSellFees;
1753                 tokensForLiquidity += fees * liquiditySellFee / totalSellFees;
1754             }
1755             
1756             // on buy
1757             else if(automatedMarketMakerPairs[from] && totalBuyFees > 0) {
1758         	    fees = amount.mul(totalBuyFees).div(feeDivisor);
1759                 tokensForOperations += fees * operationsBuyFee / totalBuyFees;
1760         	    tokensForRewards += fees * rewardsBuyFee / totalBuyFees;
1761                 tokensForLiquidity += fees * liquidityBuyFee / totalBuyFees;
1762             }
1763 
1764             if(fees > 0){    
1765                 super._transfer(from, address(this), fees);
1766             }
1767         	
1768         	amount -= fees;
1769         }
1770 
1771         super._transfer(from, to, amount);
1772 
1773         dividendTracker.setBalance(payable(from), balanceOf(from));
1774         dividendTracker.setBalance(payable(to), balanceOf(to));
1775 
1776         if(!swapping && gasForProcessing > 0) {
1777 	    	uint256 gas = gasForProcessing;
1778 
1779 	    	try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1780 	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1781 	    	}
1782 	    	catch {}
1783         }
1784     }
1785     
1786     function swapTokensForETH(uint256 tokenAmount) private {
1787 
1788         // generate the uniswap pair path of token -> WETH
1789         address[] memory path = new address[](2);
1790         path[0] = address(this);
1791         path[1] = uniswapV2Router.WETH();
1792 
1793         _approve(address(this), address(uniswapV2Router), tokenAmount);
1794 
1795         // make the swap
1796         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1797             tokenAmount,
1798             0, // accept any amount of ETH
1799             path,
1800             address(this),
1801             block.timestamp
1802         );
1803         
1804     }
1805     
1806     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1807         // approve token transfer to cover all possible scenarios
1808         _approve(address(this), address(uniswapV2Router), tokenAmount);
1809 
1810         // add the liquidity
1811         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1812             address(this),
1813             tokenAmount,
1814             0, // slippage is unavoidable
1815             0, // slippage is unavoidable
1816             operationsWallet,
1817             block.timestamp
1818         );
1819 
1820     }
1821     
1822     function swapBack() private {
1823         uint256 contractBalance = balanceOf(address(this));
1824         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForRewards;
1825         
1826         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1827         
1828         // Halve the amount of liquidity tokens
1829         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1830         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1831         
1832         uint256 initialETHBalance = address(this).balance;
1833 
1834         swapTokensForETH(amountToSwapForETH); 
1835         
1836         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1837         
1838         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap - (tokensForLiquidity/2));
1839         uint256 ethForRewards = ethBalance.mul(tokensForRewards).div(totalTokensToSwap - (tokensForLiquidity/2));
1840         
1841         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForRewards;
1842         
1843         tokensForOperations = 0;
1844         tokensForRewards = 0;
1845         tokensForLiquidity = 0;
1846         
1847         
1848         
1849         if(liquidityTokens > 0 && ethForLiquidity > 0){
1850             addLiquidity(liquidityTokens, ethForLiquidity);
1851             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1852         }
1853         
1854         // call twice to force buy of both reward tokens.
1855         (bool success,) = address(dividendTracker).call{value: ethForRewards}("");
1856 
1857         (success,) = address(operationsWallet).call{value: address(this).balance}("");
1858     }
1859 
1860     function withdrawStuckETH() external {
1861         require(msg.sender == operationsWallet);
1862         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1863         require(success, "failed to withdraw");
1864     }
1865 
1866      function withdrawStuckTokens(address tkn) external {
1867         require(msg.sender == operationsWallet);
1868         require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
1869         uint amount = IERC20(tkn).balanceOf(address(this));
1870         IERC20(tkn).transfer(msg.sender, amount);
1871      }
1872 
1873     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
1874         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1875         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1876         lpWithdrawRequestTimestamp = block.timestamp;
1877         lpWithdrawRequestPending = true;
1878         lpPercToWithDraw = percToWithdraw;
1879         emit RequestedLPWithdraw();
1880     }
1881 
1882     function nextAvailableLpWithdrawDate() public view returns (uint256){
1883         if(lpWithdrawRequestPending){
1884             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1885         }
1886         else {
1887             return 0;  // 0 means no open requests
1888         }
1889     }
1890 
1891     function withdrawRequestedLP() external onlyOwner {
1892         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1893         lpWithdrawRequestTimestamp = 0;
1894         lpWithdrawRequestPending = false;
1895 
1896         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1897         
1898         lpPercToWithDraw = 0;
1899 
1900         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
1901     }
1902 
1903     function cancelLPWithdrawRequest() external onlyOwner {
1904         lpWithdrawRequestPending = false;
1905         lpPercToWithDraw = 0;
1906         lpWithdrawRequestTimestamp = 0;
1907         emit CanceledLpWithdrawRequest();
1908     }
1909 }