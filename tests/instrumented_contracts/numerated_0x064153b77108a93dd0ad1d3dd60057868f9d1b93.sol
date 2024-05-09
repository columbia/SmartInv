1 // HONGKONG INU
2 // SPDX-License-Identifier: Unlicensed
3 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
4 
5 pragma solidity >=0.5.0;
6 
7 interface IUniswapV2Factory {
8     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
9 
10     function feeTo() external view returns (address);
11     function feeToSetter() external view returns (address);
12 
13     function getPair(address tokenA, address tokenB) external view returns (address pair);
14     function allPairs(uint) external view returns (address pair);
15     function allPairsLength() external view returns (uint);
16 
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18 
19     function setFeeTo(address) external;
20     function setFeeToSetter(address) external;
21 }
22 
23 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
24 
25 pragma solidity >=0.6.2;
26 
27 interface IUniswapV2Router01 {
28     function factory() external pure returns (address);
29     function WETH() external pure returns (address);
30 
31     function addLiquidity(
32         address tokenA,
33         address tokenB,
34         uint amountADesired,
35         uint amountBDesired,
36         uint amountAMin,
37         uint amountBMin,
38         address to,
39         uint deadline
40     ) external returns (uint amountA, uint amountB, uint liquidity);
41     function addLiquidityETH(
42         address token,
43         uint amountTokenDesired,
44         uint amountTokenMin,
45         uint amountETHMin,
46         address to,
47         uint deadline
48     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
49     function removeLiquidity(
50         address tokenA,
51         address tokenB,
52         uint liquidity,
53         uint amountAMin,
54         uint amountBMin,
55         address to,
56         uint deadline
57     ) external returns (uint amountA, uint amountB);
58     function removeLiquidityETH(
59         address token,
60         uint liquidity,
61         uint amountTokenMin,
62         uint amountETHMin,
63         address to,
64         uint deadline
65     ) external returns (uint amountToken, uint amountETH);
66     function removeLiquidityWithPermit(
67         address tokenA,
68         address tokenB,
69         uint liquidity,
70         uint amountAMin,
71         uint amountBMin,
72         address to,
73         uint deadline,
74         bool approveMax, uint8 v, bytes32 r, bytes32 s
75     ) external returns (uint amountA, uint amountB);
76     function removeLiquidityETHWithPermit(
77         address token,
78         uint liquidity,
79         uint amountTokenMin,
80         uint amountETHMin,
81         address to,
82         uint deadline,
83         bool approveMax, uint8 v, bytes32 r, bytes32 s
84     ) external returns (uint amountToken, uint amountETH);
85     function swapExactTokensForTokens(
86         uint amountIn,
87         uint amountOutMin,
88         address[] calldata path,
89         address to,
90         uint deadline
91     ) external returns (uint[] memory amounts);
92     function swapTokensForExactTokens(
93         uint amountOut,
94         uint amountInMax,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external returns (uint[] memory amounts);
99     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
100         external
101         payable
102         returns (uint[] memory amounts);
103     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
104         external
105         returns (uint[] memory amounts);
106     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
107         external
108         returns (uint[] memory amounts);
109     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
110         external
111         payable
112         returns (uint[] memory amounts);
113 
114     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
115     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
116     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
117     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
118     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
119 }
120 
121 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
122 
123 pragma solidity >=0.6.2;
124 
125 
126 interface IUniswapV2Router02 is IUniswapV2Router01 {
127     function removeLiquidityETHSupportingFeeOnTransferTokens(
128         address token,
129         uint liquidity,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external returns (uint amountETH);
135     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
136         address token,
137         uint liquidity,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline,
142         bool approveMax, uint8 v, bytes32 r, bytes32 s
143     ) external returns (uint amountETH);
144 
145     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
146         uint amountIn,
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external;
152     function swapExactETHForTokensSupportingFeeOnTransferTokens(
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external payable;
158     function swapExactTokensForETHSupportingFeeOnTransferTokens(
159         uint amountIn,
160         uint amountOutMin,
161         address[] calldata path,
162         address to,
163         uint deadline
164     ) external;
165 }
166 
167 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
168 
169 
170 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 // CAUTION
175 // This version of SafeMath should only be used with Solidity 0.8 or later,
176 // because it relies on the compiler's built in overflow checks.
177 
178 /**
179  * @dev Wrappers over Solidity's arithmetic operations.
180  *
181  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
182  * now has built in overflow checking.
183  */
184 library SafeMath {
185     /**
186      * @dev Returns the addition of two unsigned integers, with an overflow flag.
187      *
188      * _Available since v3.4._
189      */
190     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
191         unchecked {
192             uint256 c = a + b;
193             if (c < a) return (false, 0);
194             return (true, c);
195         }
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
200      *
201      * _Available since v3.4._
202      */
203     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
204         unchecked {
205             if (b > a) return (false, 0);
206             return (true, a - b);
207         }
208     }
209 
210     /**
211      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
212      *
213      * _Available since v3.4._
214      */
215     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
216         unchecked {
217             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
218             // benefit is lost if 'b' is also tested.
219             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
220             if (a == 0) return (true, 0);
221             uint256 c = a * b;
222             if (c / a != b) return (false, 0);
223             return (true, c);
224         }
225     }
226 
227     /**
228      * @dev Returns the division of two unsigned integers, with a division by zero flag.
229      *
230      * _Available since v3.4._
231      */
232     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
233         unchecked {
234             if (b == 0) return (false, 0);
235             return (true, a / b);
236         }
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
241      *
242      * _Available since v3.4._
243      */
244     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
245         unchecked {
246             if (b == 0) return (false, 0);
247             return (true, a % b);
248         }
249     }
250 
251     /**
252      * @dev Returns the addition of two unsigned integers, reverting on
253      * overflow.
254      *
255      * Counterpart to Solidity's `+` operator.
256      *
257      * Requirements:
258      *
259      * - Addition cannot overflow.
260      */
261     function add(uint256 a, uint256 b) internal pure returns (uint256) {
262         return a + b;
263     }
264 
265     /**
266      * @dev Returns the subtraction of two unsigned integers, reverting on
267      * overflow (when the result is negative).
268      *
269      * Counterpart to Solidity's `-` operator.
270      *
271      * Requirements:
272      *
273      * - Subtraction cannot overflow.
274      */
275     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
276         return a - b;
277     }
278 
279     /**
280      * @dev Returns the multiplication of two unsigned integers, reverting on
281      * overflow.
282      *
283      * Counterpart to Solidity's `*` operator.
284      *
285      * Requirements:
286      *
287      * - Multiplication cannot overflow.
288      */
289     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a * b;
291     }
292 
293     /**
294      * @dev Returns the integer division of two unsigned integers, reverting on
295      * division by zero. The result is rounded towards zero.
296      *
297      * Counterpart to Solidity's `/` operator.
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function div(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a / b;
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * reverting when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
320         return a % b;
321     }
322 
323     /**
324      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
325      * overflow (when the result is negative).
326      *
327      * CAUTION: This function is deprecated because it requires allocating memory for the error
328      * message unnecessarily. For custom revert reasons use {trySub}.
329      *
330      * Counterpart to Solidity's `-` operator.
331      *
332      * Requirements:
333      *
334      * - Subtraction cannot overflow.
335      */
336     function sub(
337         uint256 a,
338         uint256 b,
339         string memory errorMessage
340     ) internal pure returns (uint256) {
341         unchecked {
342             require(b <= a, errorMessage);
343             return a - b;
344         }
345     }
346 
347     /**
348      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
349      * division by zero. The result is rounded towards zero.
350      *
351      * Counterpart to Solidity's `/` operator. Note: this function uses a
352      * `revert` opcode (which leaves remaining gas untouched) while Solidity
353      * uses an invalid opcode to revert (consuming all remaining gas).
354      *
355      * Requirements:
356      *
357      * - The divisor cannot be zero.
358      */
359     function div(
360         uint256 a,
361         uint256 b,
362         string memory errorMessage
363     ) internal pure returns (uint256) {
364         unchecked {
365             require(b > 0, errorMessage);
366             return a / b;
367         }
368     }
369 
370     /**
371      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
372      * reverting with custom message when dividing by zero.
373      *
374      * CAUTION: This function is deprecated because it requires allocating memory for the error
375      * message unnecessarily. For custom revert reasons use {tryMod}.
376      *
377      * Counterpart to Solidity's `%` operator. This function uses a `revert`
378      * opcode (which leaves remaining gas untouched) while Solidity uses an
379      * invalid opcode to revert (consuming all remaining gas).
380      *
381      * Requirements:
382      *
383      * - The divisor cannot be zero.
384      */
385     function mod(
386         uint256 a,
387         uint256 b,
388         string memory errorMessage
389     ) internal pure returns (uint256) {
390         unchecked {
391             require(b > 0, errorMessage);
392             return a % b;
393         }
394     }
395 }
396 
397 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @dev Contract module that helps prevent reentrant calls to a function.
406  *
407  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
408  * available, which can be applied to functions to make sure there are no nested
409  * (reentrant) calls to them.
410  *
411  * Note that because there is a single `nonReentrant` guard, functions marked as
412  * `nonReentrant` may not call one another. This can be worked around by making
413  * those functions `private`, and then adding `external` `nonReentrant` entry
414  * points to them.
415  *
416  * TIP: If you would like to learn more about reentrancy and alternative ways
417  * to protect against it, check out our blog post
418  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
419  */
420 abstract contract ReentrancyGuard {
421     // Booleans are more expensive than uint256 or any type that takes up a full
422     // word because each write operation emits an extra SLOAD to first read the
423     // slot's contents, replace the bits taken up by the boolean, and then write
424     // back. This is the compiler's defense against contract upgrades and
425     // pointer aliasing, and it cannot be disabled.
426 
427     // The values being non-zero value makes deployment a bit more expensive,
428     // but in exchange the refund on every call to nonReentrant will be lower in
429     // amount. Since refunds are capped to a percentage of the total
430     // transaction's gas, it is best to keep them low in cases like this one, to
431     // increase the likelihood of the full refund coming into effect.
432     uint256 private constant _NOT_ENTERED = 1;
433     uint256 private constant _ENTERED = 2;
434 
435     uint256 private _status;
436 
437     constructor() {
438         _status = _NOT_ENTERED;
439     }
440 
441     /**
442      * @dev Prevents a contract from calling itself, directly or indirectly.
443      * Calling a `nonReentrant` function from another `nonReentrant`
444      * function is not supported. It is possible to prevent this from happening
445      * by making the `nonReentrant` function external, and making it call a
446      * `private` function that does the actual work.
447      */
448     modifier nonReentrant() {
449         _nonReentrantBefore();
450         _;
451         _nonReentrantAfter();
452     }
453 
454     function _nonReentrantBefore() private {
455         // On the first call to nonReentrant, _status will be _NOT_ENTERED
456         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
457 
458         // Any calls to nonReentrant after this point will fail
459         _status = _ENTERED;
460     }
461 
462     function _nonReentrantAfter() private {
463         // By storing the original value once again, a refund is triggered (see
464         // https://eips.ethereum.org/EIPS/eip-2200)
465         _status = _NOT_ENTERED;
466     }
467 }
468 
469 // File: @openzeppelin/contracts/utils/Context.sol
470 
471 
472 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 /**
477  * @dev Provides information about the current execution context, including the
478  * sender of the transaction and its data. While these are generally available
479  * via msg.sender and msg.data, they should not be accessed in such a direct
480  * manner, since when dealing with meta-transactions the account sending and
481  * paying for execution may not be the actual sender (as far as an application
482  * is concerned).
483  *
484  * This contract is only required for intermediate, library-like contracts.
485  */
486 abstract contract Context {
487     function _msgSender() internal view virtual returns (address) {
488         return msg.sender;
489     }
490 
491     function _msgData() internal view virtual returns (bytes calldata) {
492         return msg.data;
493     }
494 }
495 
496 // File: @openzeppelin/contracts/access/Ownable.sol
497 
498 
499 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 
504 /**
505  * @dev Contract module which provides a basic access control mechanism, where
506  * there is an account (an owner) that can be granted exclusive access to
507  * specific functions.
508  *
509  * By default, the owner account will be the one that deploys the contract. This
510  * can later be changed with {transferOwnership}.
511  *
512  * This module is used through inheritance. It will make available the modifier
513  * `onlyOwner`, which can be applied to your functions to restrict their use to
514  * the owner.
515  */
516 abstract contract Ownable is Context {
517     address private _owner;
518 
519     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
520 
521     /**
522      * @dev Initializes the contract setting the deployer as the initial owner.
523      */
524     constructor() {
525         _transferOwnership(_msgSender());
526     }
527 
528     /**
529      * @dev Throws if called by any account other than the owner.
530      */
531     modifier onlyOwner() {
532         _checkOwner();
533         _;
534     }
535 
536     /**
537      * @dev Returns the address of the current owner.
538      */
539     function owner() public view virtual returns (address) {
540         return _owner;
541     }
542 
543     /**
544      * @dev Throws if the sender is not the owner.
545      */
546     function _checkOwner() internal view virtual {
547         require(owner() == _msgSender(), "Ownable: caller is not the owner");
548     }
549 
550     /**
551      * @dev Leaves the contract without owner. It will not be possible to call
552      * `onlyOwner` functions anymore. Can only be called by the current owner.
553      *
554      * NOTE: Renouncing ownership will leave the contract without an owner,
555      * thereby removing any functionality that is only available to the owner.
556      */
557     function renounceOwnership() public virtual onlyOwner {
558         _transferOwnership(address(0));
559     }
560 
561     /**
562      * @dev Transfers ownership of the contract to a new account (`newOwner`).
563      * Can only be called by the current owner.
564      */
565     function transferOwnership(address newOwner) public virtual onlyOwner {
566         require(newOwner != address(0), "Ownable: new owner is the zero address");
567         _transferOwnership(newOwner);
568     }
569 
570     /**
571      * @dev Transfers ownership of the contract to a new account (`newOwner`).
572      * Internal function without access restriction.
573      */
574     function _transferOwnership(address newOwner) internal virtual {
575         address oldOwner = _owner;
576         _owner = newOwner;
577         emit OwnershipTransferred(oldOwner, newOwner);
578     }
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
582 
583 
584 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @dev Interface of the ERC20 standard as defined in the EIP.
590  */
591 interface IERC20 {
592     /**
593      * @dev Emitted when `value` tokens are moved from one account (`from`) to
594      * another (`to`).
595      *
596      * Note that `value` may be zero.
597      */
598     event Transfer(address indexed from, address indexed to, uint256 value);
599 
600     /**
601      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
602      * a call to {approve}. `value` is the new allowance.
603      */
604     event Approval(address indexed owner, address indexed spender, uint256 value);
605 
606     /**
607      * @dev Returns the amount of tokens in existence.
608      */
609     function totalSupply() external view returns (uint256);
610 
611     /**
612      * @dev Returns the amount of tokens owned by `account`.
613      */
614     function balanceOf(address account) external view returns (uint256);
615 
616     /**
617      * @dev Moves `amount` tokens from the caller's account to `to`.
618      *
619      * Returns a boolean value indicating whether the operation succeeded.
620      *
621      * Emits a {Transfer} event.
622      */
623     function transfer(address to, uint256 amount) external returns (bool);
624 
625     /**
626      * @dev Returns the remaining number of tokens that `spender` will be
627      * allowed to spend on behalf of `owner` through {transferFrom}. This is
628      * zero by default.
629      *
630      * This value changes when {approve} or {transferFrom} are called.
631      */
632     function allowance(address owner, address spender) external view returns (uint256);
633 
634     /**
635      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
636      *
637      * Returns a boolean value indicating whether the operation succeeded.
638      *
639      * IMPORTANT: Beware that changing an allowance with this method brings the risk
640      * that someone may use both the old and the new allowance by unfortunate
641      * transaction ordering. One possible solution to mitigate this race
642      * condition is to first reduce the spender's allowance to 0 and set the
643      * desired value afterwards:
644      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
645      *
646      * Emits an {Approval} event.
647      */
648     function approve(address spender, uint256 amount) external returns (bool);
649 
650     /**
651      * @dev Moves `amount` tokens from `from` to `to` using the
652      * allowance mechanism. `amount` is then deducted from the caller's
653      * allowance.
654      *
655      * Returns a boolean value indicating whether the operation succeeded.
656      *
657      * Emits a {Transfer} event.
658      */
659     function transferFrom(
660         address from,
661         address to,
662         uint256 amount
663     ) external returns (bool);
664 }
665 
666 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @dev Interface for the optional metadata functions from the ERC20 standard.
676  *
677  * _Available since v4.1._
678  */
679 interface IERC20Metadata is IERC20 {
680     /**
681      * @dev Returns the name of the token.
682      */
683     function name() external view returns (string memory);
684 
685     /**
686      * @dev Returns the symbol of the token.
687      */
688     function symbol() external view returns (string memory);
689 
690     /**
691      * @dev Returns the decimals places of the token.
692      */
693     function decimals() external view returns (uint8);
694 }
695 
696 // File: contracts/HONGKONG.sol
697 
698 // HONGKONG INU
699 
700 pragma solidity 0.8.19;
701 
702 
703 
704 
705 
706 
707 
708 
709 
710 contract HONGKONGINU is Context, IERC20, Ownable, ReentrancyGuard {
711     using SafeMath for uint256;
712 
713     IUniswapV2Router02 private immutable uniswapRouter;
714     address private immutable uniswapPair;
715 
716     uint256 public buyFee;
717     uint256 public sellFee;
718     mapping(address => bool) public Addresslist;
719 
720     string private _name;
721     string private _symbol;
722     uint8 private _decimals = 18;
723     uint256 private _totalSupply;
724 
725     mapping(address => uint256) private _balances;
726     mapping(address => mapping(address => uint256)) private _allowances;
727 
728     constructor(
729         string memory _tokenName,
730         string memory _tokensymbol,
731         uint256 initialSupply,
732         address _uniswapRouter
733     ) {
734         _name = _tokenName;
735         _symbol = _tokensymbol;
736 
737         _totalSupply = initialSupply.mul(10**_decimals);
738         _balances[_msgSender()] = _totalSupply;
739 
740         uniswapRouter = IUniswapV2Router02(_uniswapRouter);
741         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), uniswapRouter.WETH());
742 
743         buyFee = 0;
744         sellFee = 0;
745 
746         Addresslist[_msgSender()] = true;
747 
748         emit Transfer(address(0), _msgSender(), _totalSupply);
749     }
750 
751     event TokenChargedFees(address indexed sender, uint256 amount, uint256 timestamp);
752 
753     function name() external view returns (string memory) {
754         return _name;
755     }
756 
757     function symbol() external view returns (string memory) {
758         return _symbol;
759     }
760 
761     function decimals() external view returns (uint8) {
762         return _decimals;
763     }
764 
765     function totalSupply() external view override returns (uint256) {
766         return _totalSupply;
767     }
768 
769     function balanceOf(address account) external view override returns (uint256) {
770         return _balances[account];
771     }
772 
773     function transfer(address recipient, uint256 amount) public override nonReentrant returns (bool) {
774         _transfer(_msgSender(), recipient, amount);
775         return true;
776     }
777 
778     function transferFrom(address sender, address recipient, uint256 amount) public override nonReentrant returns (bool) {
779         _transfer(sender, recipient, amount);
780         uint256 currentAllowance = _allowances[sender][_msgSender()];
781         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
782         _approve(sender, _msgSender(), currentAllowance.sub(amount));
783         return true;
784     }
785 
786     function allowance(address owner, address spender) external view override returns (uint256) {
787         return _allowances[owner][spender];
788     }
789 
790     function approve(address spender, uint256 amount) external override returns (bool) {
791         _approve(_msgSender(), spender, amount);
792         return true;
793     }
794 
795     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
796     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
797     return true;
798     }
799 
800     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
801         uint256 currentAllowance = _allowances[_msgSender()][spender];
802         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
803         _approve(_msgSender(), spender, currentAllowance.sub(subtractedValue));
804         return true;
805     }
806 
807     function _transfer(address sender, address recipient, uint256 amount) internal {
808         require(sender != address(0), "ERC20: transfer from the zero address");
809         require(recipient != address(0), "ERC20: transfer to the zero address");
810         require(amount > 0, "Transfer amount must be greater than zero");
811 
812         uint256 senderBalance = this.balanceOf(sender);
813         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
814 
815         uint256 chargeAmount = 0;
816         uint256 transferAmount = amount;
817 
818         // Check if the sender or recipient is not in the list of addresses  
819         if (!Addresslist[sender] && !Addresslist[recipient]) {
820             // Buy
821             if (sender == uniswapPair && buyFee > 0) {
822                 chargeAmount = amount.mul(buyFee).div(100);
823             // Sell
824             } else if (recipient == uniswapPair && sellFee > 0) {
825                 chargeAmount = amount.mul(sellFee).div(100);
826             // Regular transfers (no fee)
827             } else {
828                 chargeAmount = 0;
829             }
830 
831             if (chargeAmount > 0) {
832                 transferAmount = transferAmount.sub(chargeAmount);
833                 _balances[owner()] = _balances[owner()].add(chargeAmount);
834                 emit TokenChargedFees(sender, chargeAmount, block.timestamp);
835             }
836         }
837 
838         _balances[sender] = senderBalance.sub(amount);
839         _balances[recipient] = _balances[recipient].add(transferAmount);
840 
841         emit Transfer(sender, recipient, transferAmount);
842     }
843 
844     function _approve(address owner, address spender, uint256 amount) internal virtual {
845         require(owner != address(0), "ERC20: approve from the zero address");
846         require(spender != address(0), "ERC20: approve to the zero address");
847 
848         _allowances[owner][spender] = amount;
849         emit Approval(owner, spender, amount);
850     }
851 
852     function setBuyFee(uint256 newBuyFee) external onlyOwner {        
853         buyFee = newBuyFee;
854     }
855 
856     function setSellFee(uint256 newSellFee) external onlyOwner {        
857         sellFee = newSellFee;
858     }
859 
860     function updateAdress(address account, bool status) external onlyOwner {
861         Addresslist[account] = status;
862     }
863 }