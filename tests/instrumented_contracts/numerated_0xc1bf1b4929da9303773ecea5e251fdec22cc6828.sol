1 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 
164 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
165 
166 // pragma solidity ^0.6.0;
167 
168 /*
169  * @dev Provides information about the current execution context, including the
170  * sender of the transaction and its data. While these are generally available
171  * via msg.sender and msg.data, they should not be accessed in such a direct
172  * manner, since when dealing with GSN meta-transactions the account sending and
173  * paying for execution may not be the actual sender (as far as an application
174  * is concerned).
175  *
176  * This contract is only required for intermediate, library-like contracts.
177  */
178 abstract contract Context {
179     function _msgSender() internal view virtual returns (address payable) {
180         return msg.sender;
181     }
182 
183     function _msgData() internal view virtual returns (bytes memory) {
184         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
185         return msg.data;
186     }
187 }
188 
189 
190 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
191 
192 // pragma solidity ^0.6.0;
193 
194 // import "@openzeppelin/contracts/GSN/Context.sol";
195 /**
196  * @dev Contract module which provides a basic access control mechanism, where
197  * there is an account (an owner) that can be granted exclusive access to
198  * specific functions.
199  *
200  * By default, the owner account will be the one that deploys the contract. This
201  * can later be changed with {transferOwnership}.
202  *
203  * This module is used through inheritance. It will make available the modifier
204  * `onlyOwner`, which can be applied to your functions to restrict their use to
205  * the owner.
206  */
207 contract Ownable is Context {
208     address private _owner;
209 
210     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
211 
212     /**
213      * @dev Initializes the contract setting the deployer as the initial owner.
214      */
215     constructor () internal {
216         address msgSender = _msgSender();
217         _owner = msgSender;
218         emit OwnershipTransferred(address(0), msgSender);
219     }
220 
221     /**
222      * @dev Returns the address of the current owner.
223      */
224     function owner() public view returns (address) {
225         return _owner;
226     }
227 
228     /**
229      * @dev Throws if called by any account other than the owner.
230      */
231     modifier onlyOwner() {
232         require(_owner == _msgSender(), "Ownable: caller is not the owner");
233         _;
234     }
235 
236     /**
237      * @dev Leaves the contract without owner. It will not be possible to call
238      * `onlyOwner` functions anymore. Can only be called by the current owner.
239      *
240      * NOTE: Renouncing ownership will leave the contract without an owner,
241      * thereby removing any functionality that is only available to the owner.
242      */
243     function renounceOwnership() public virtual onlyOwner {
244         emit OwnershipTransferred(_owner, address(0));
245         _owner = address(0);
246     }
247 
248     /**
249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
250      * Can only be called by the current owner.
251      */
252     function transferOwnership(address newOwner) public virtual onlyOwner {
253         require(newOwner != address(0), "Ownable: new owner is the zero address");
254         emit OwnershipTransferred(_owner, newOwner);
255         _owner = newOwner;
256     }
257 }
258 
259 
260 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
261 
262 // pragma solidity ^0.6.0;
263 
264 /**
265  * @dev Contract module that helps prevent reentrant calls to a function.
266  *
267  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
268  * available, which can be applied to functions to make sure there are no nested
269  * (reentrant) calls to them.
270  *
271  * Note that because there is a single `nonReentrant` guard, functions marked as
272  * `nonReentrant` may not call one another. This can be worked around by making
273  * those functions `private`, and then adding `external` `nonReentrant` entry
274  * points to them.
275  *
276  * TIP: If you would like to learn more about reentrancy and alternative ways
277  * to protect against it, check out our blog post
278  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
279  */
280 contract ReentrancyGuard {
281     // Booleans are more expensive than uint256 or any type that takes up a full
282     // word because each write operation emits an extra SLOAD to first read the
283     // slot's contents, replace the bits taken up by the boolean, and then write
284     // back. This is the compiler's defense against contract upgrades and
285     // pointer aliasing, and it cannot be disabled.
286 
287     // The values being non-zero value makes deployment a bit more expensive,
288     // but in exchange the refund on every call to nonReentrant will be lower in
289     // amount. Since refunds are capped to a percentage of the total
290     // transaction's gas, it is best to keep them low in cases like this one, to
291     // increase the likelihood of the full refund coming into effect.
292     uint256 private constant _NOT_ENTERED = 1;
293     uint256 private constant _ENTERED = 2;
294 
295     uint256 private _status;
296 
297     constructor () internal {
298         _status = _NOT_ENTERED;
299     }
300 
301     /**
302      * @dev Prevents a contract from calling itself, directly or indirectly.
303      * Calling a `nonReentrant` function from another `nonReentrant`
304      * function is not supported. It is possible to prevent this from happening
305      * by making the `nonReentrant` function external, and make it call a
306      * `private` function that does the actual work.
307      */
308     modifier nonReentrant() {
309         // On the first call to nonReentrant, _notEntered will be true
310         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
311 
312         // Any calls to nonReentrant after this point will fail
313         _status = _ENTERED;
314 
315         _;
316 
317         // By storing the original value once again, a refund is triggered (see
318         // https://eips.ethereum.org/EIPS/eip-2200)
319         _status = _NOT_ENTERED;
320     }
321 }
322 
323 
324 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
325 
326 // pragma solidity ^0.6.0;
327 
328 /**
329  * @dev Interface of the ERC20 standard as defined in the EIP.
330  */
331 interface IERC20 {
332     /**
333      * @dev Returns the amount of tokens in existence.
334      */
335     function totalSupply() external view returns (uint256);
336 
337     /**
338      * @dev Returns the amount of tokens owned by `account`.
339      */
340     function balanceOf(address account) external view returns (uint256);
341 
342     /**
343      * @dev Moves `amount` tokens from the caller's account to `recipient`.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * Emits a {Transfer} event.
348      */
349     function transfer(address recipient, uint256 amount) external returns (bool);
350 
351     /**
352      * @dev Returns the remaining number of tokens that `spender` will be
353      * allowed to spend on behalf of `owner` through {transferFrom}. This is
354      * zero by default.
355      *
356      * This value changes when {approve} or {transferFrom} are called.
357      */
358     function allowance(address owner, address spender) external view returns (uint256);
359 
360     /**
361      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * // importANT: Beware that changing an allowance with this method brings the risk
366      * that someone may use both the old and the new allowance by unfortunate
367      * transaction ordering. One possible solution to mitigate this race
368      * condition is to first reduce the spender's allowance to 0 and set the
369      * desired value afterwards:
370      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
371      *
372      * Emits an {Approval} event.
373      */
374     function approve(address spender, uint256 amount) external returns (bool);
375 
376     /**
377      * @dev Moves `amount` tokens from `sender` to `recipient` using the
378      * allowance mechanism. `amount` is then deducted from the caller's
379      * allowance.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * Emits a {Transfer} event.
384      */
385     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
386 
387     /**
388      * @dev Emitted when `value` tokens are moved from one account (`from`) to
389      * another (`to`).
390      *
391      * Note that `value` may be zero.
392      */
393     event Transfer(address indexed from, address indexed to, uint256 value);
394 
395     /**
396      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
397      * a call to {approve}. `value` is the new allowance.
398      */
399     event Approval(address indexed owner, address indexed spender, uint256 value);
400 }
401 
402 
403 // Dependency file: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
404 
405 // pragma solidity >=0.5.0;
406 
407 interface IUniswapV2Factory {
408     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
409 
410     function feeTo() external view returns (address);
411     function feeToSetter() external view returns (address);
412 
413     function getPair(address tokenA, address tokenB) external view returns (address pair);
414     function allPairs(uint) external view returns (address pair);
415     function allPairsLength() external view returns (uint);
416 
417     function createPair(address tokenA, address tokenB) external returns (address pair);
418 
419     function setFeeTo(address) external;
420     function setFeeToSetter(address) external;
421 }
422 
423 
424 // Dependency file: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
425 
426 // pragma solidity >=0.6.2;
427 
428 interface IUniswapV2Router01 {
429     function factory() external pure returns (address);
430     function WETH() external pure returns (address);
431 
432     function addLiquidity(
433         address tokenA,
434         address tokenB,
435         uint amountADesired,
436         uint amountBDesired,
437         uint amountAMin,
438         uint amountBMin,
439         address to,
440         uint deadline
441     ) external returns (uint amountA, uint amountB, uint liquidity);
442     function addLiquidityETH(
443         address token,
444         uint amountTokenDesired,
445         uint amountTokenMin,
446         uint amountETHMin,
447         address to,
448         uint deadline
449     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
450     function removeLiquidity(
451         address tokenA,
452         address tokenB,
453         uint liquidity,
454         uint amountAMin,
455         uint amountBMin,
456         address to,
457         uint deadline
458     ) external returns (uint amountA, uint amountB);
459     function removeLiquidityETH(
460         address token,
461         uint liquidity,
462         uint amountTokenMin,
463         uint amountETHMin,
464         address to,
465         uint deadline
466     ) external returns (uint amountToken, uint amountETH);
467     function removeLiquidityWithPermit(
468         address tokenA,
469         address tokenB,
470         uint liquidity,
471         uint amountAMin,
472         uint amountBMin,
473         address to,
474         uint deadline,
475         bool approveMax, uint8 v, bytes32 r, bytes32 s
476     ) external returns (uint amountA, uint amountB);
477     function removeLiquidityETHWithPermit(
478         address token,
479         uint liquidity,
480         uint amountTokenMin,
481         uint amountETHMin,
482         address to,
483         uint deadline,
484         bool approveMax, uint8 v, bytes32 r, bytes32 s
485     ) external returns (uint amountToken, uint amountETH);
486     function swapExactTokensForTokens(
487         uint amountIn,
488         uint amountOutMin,
489         address[] calldata path,
490         address to,
491         uint deadline
492     ) external returns (uint[] memory amounts);
493     function swapTokensForExactTokens(
494         uint amountOut,
495         uint amountInMax,
496         address[] calldata path,
497         address to,
498         uint deadline
499     ) external returns (uint[] memory amounts);
500     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
501         external
502         payable
503         returns (uint[] memory amounts);
504     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
505         external
506         returns (uint[] memory amounts);
507     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
508         external
509         returns (uint[] memory amounts);
510     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
511         external
512         payable
513         returns (uint[] memory amounts);
514 
515     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
516     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
517     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
518     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
519     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
520 }
521 
522 
523 // Dependency file: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
524 
525 // pragma solidity >=0.6.2;
526 
527 // import '/Users/train/Documents/Work/Decent/unitrade/unitrade/node_modules/@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol';
528 
529 interface IUniswapV2Router02 is IUniswapV2Router01 {
530     function removeLiquidityETHSupportingFeeOnTransferTokens(
531         address token,
532         uint liquidity,
533         uint amountTokenMin,
534         uint amountETHMin,
535         address to,
536         uint deadline
537     ) external returns (uint amountETH);
538     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
539         address token,
540         uint liquidity,
541         uint amountTokenMin,
542         uint amountETHMin,
543         address to,
544         uint deadline,
545         bool approveMax, uint8 v, bytes32 r, bytes32 s
546     ) external returns (uint amountETH);
547 
548     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
549         uint amountIn,
550         uint amountOutMin,
551         address[] calldata path,
552         address to,
553         uint deadline
554     ) external;
555     function swapExactETHForTokensSupportingFeeOnTransferTokens(
556         uint amountOutMin,
557         address[] calldata path,
558         address to,
559         uint deadline
560     ) external payable;
561     function swapExactTokensForETHSupportingFeeOnTransferTokens(
562         uint amountIn,
563         uint amountOutMin,
564         address[] calldata path,
565         address to,
566         uint deadline
567     ) external;
568 }
569 
570 
571 // Dependency file: @uniswap/lib/contracts/libraries/TransferHelper.sol
572 
573 // pragma solidity >=0.6.0;
574 
575 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
576 library TransferHelper {
577     function safeApprove(address token, address to, uint value) internal {
578         // bytes4(keccak256(bytes('approve(address,uint256)')));
579         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
580         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
581     }
582 
583     function safeTransfer(address token, address to, uint value) internal {
584         // bytes4(keccak256(bytes('transfer(address,uint256)')));
585         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
586         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
587     }
588 
589     function safeTransferFrom(address token, address from, address to, uint value) internal {
590         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
591         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
592         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
593     }
594 
595     function safeTransferETH(address to, uint value) internal {
596         (bool success,) = to.call{value:value}(new bytes(0));
597         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
598     }
599 }
600 
601 
602 // Dependency file: contracts/UniTradeIncinerator.sol
603 
604 // pragma solidity ^0.6.6;
605 
606 // import "@openzeppelin/contracts/math/SafeMath.sol";
607 // import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
608 // import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
609 
610 contract UniTradeIncinerator {
611     using SafeMath for uint256;
612 
613     uint256 constant UINT256_MAX = ~uint256(0);
614     IUniswapV2Router02 public immutable uniswapV2Router;
615     address public immutable unitrade;
616     uint256 lastIncinerated;
617 
618     event UniTradeToBurn(uint256 etherIn);
619     event UniTradeBurned(uint256 etherIn, uint256 tokensBurned);
620 
621     constructor(IUniswapV2Router02 _uniswapV2Router, address _unitrade) public {
622         uniswapV2Router = _uniswapV2Router;
623         unitrade = _unitrade;
624         lastIncinerated = block.timestamp;
625     }
626 
627     function burn() external payable returns (bool) {
628         require(msg.value > 0, "Nothing to burn");
629 
630         emit UniTradeToBurn(msg.value);
631 
632         if (block.timestamp < lastIncinerated + 1 days) {
633             return true;
634         }
635 
636         lastIncinerated = block.timestamp;
637 
638         address[] memory _tokenPair = new address[](2);
639         _tokenPair[0] = uniswapV2Router.WETH();
640         _tokenPair[1] = unitrade;
641 
642         uint256[] memory _swapResult = uniswapV2Router.swapExactETHForTokens{
643             value: address(this).balance
644         }(
645             0, // take any
646             _tokenPair,
647             address(this),
648             UINT256_MAX
649         );
650 
651         emit UniTradeBurned(_swapResult[0], _swapResult[1]);
652 
653         return true;
654     }
655 }
656 
657 
658 // Dependency file: contracts/IUniTradeStaker.sol
659 
660 // pragma solidity ^0.6.6;
661 
662 interface IUniTradeStaker
663 {
664     function deposit() external payable;
665 }
666 
667 
668 // Root file: contracts/UniTradeOrderBook.sol
669 
670 pragma solidity ^0.6.6;
671 
672 // import "@openzeppelin/contracts/math/SafeMath.sol";
673 // import "@openzeppelin/contracts/access/Ownable.sol";
674 // import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
675 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
676 // import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
677 // import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
678 // import "@uniswap/lib/contracts/libraries/TransferHelper.sol";
679 // import "contracts/UniTradeIncinerator.sol";
680 // import "contracts/IUniTradeStaker.sol";
681 
682 contract UniTradeOrderBook is Ownable, ReentrancyGuard {
683     using SafeMath for uint256;
684 
685     uint256 constant UINT256_MAX = ~uint256(0);
686     IUniswapV2Router02 public immutable uniswapV2Router;
687     IUniswapV2Factory public immutable uniswapV2Factory;
688     UniTradeIncinerator public immutable incinerator;
689     IUniTradeStaker public staker;
690     uint16 public feeMul;
691     uint16 public feeDiv;
692     uint16 public splitMul;
693     uint16 public splitDiv;
694 
695     enum OrderType {TokensForTokens, EthForTokens, TokensForEth}
696     enum OrderState {Placed, Cancelled, Executed}
697 
698     struct Order {
699         OrderType orderType;
700         address payable maker;
701         address tokenIn;
702         address tokenOut;
703         uint256 amountInOffered;
704         uint256 amountOutExpected;
705         uint256 executorFee;
706         uint256 totalEthDeposited;
707         uint256 activeOrderIndex;
708         OrderState orderState;
709         bool deflationary;
710     }
711 
712     uint256 private orderNumber;
713     uint256[] private activeOrders;
714     mapping(uint256 => Order) private orders;
715     mapping(address => uint256[]) private ordersForAddress;
716 
717     event OrderPlaced(
718         uint256 indexed orderId,
719         OrderType orderType,
720         address payable indexed maker,
721         address tokenIn,
722         address tokenOut,
723         uint256 amountInOffered,
724         uint256 amountOutExpected,
725         uint256 executorFee,
726         uint256 totalEthDeposited
727     );
728     event OrderUpdated(
729         uint256 indexed orderId,
730         uint256 amountInOffered,
731         uint256 amountOutExpected,
732         uint256 executorFee
733     );
734     event OrderCancelled(uint256 indexed orderId);
735     event OrderExecuted(
736         uint256 indexed orderId,
737         address indexed executor,
738         uint256[] amounts,
739         uint256 unitradeFee
740     );
741     event StakerUpdated(address newStaker);
742 
743     modifier exists(uint256 orderId) {
744         require(orders[orderId].maker != address(0), "Order not found");
745         _;
746     }
747 
748     constructor(
749         IUniswapV2Router02 _uniswapV2Router,
750         UniTradeIncinerator _incinerator,
751         IUniTradeStaker _staker,
752         uint16 _feeMul,
753         uint16 _feeDiv,
754         uint16 _splitMul,
755         uint16 _splitDiv
756     ) public {
757         uniswapV2Router = _uniswapV2Router;
758         uniswapV2Factory = IUniswapV2Factory(_uniswapV2Router.factory());
759         incinerator = _incinerator;
760         staker = _staker;
761         feeMul = _feeMul;
762         feeDiv = _feeDiv;
763         splitMul = _splitMul;
764         splitDiv = _splitDiv;
765     }
766 
767     function placeOrder(
768         OrderType orderType,
769         address tokenIn,
770         address tokenOut,
771         uint256 amountInOffered,
772         uint256 amountOutExpected,
773         uint256 executorFee
774     ) external payable nonReentrant returns (uint256) {
775         require(amountInOffered > 0, "Invalid offered amount");
776         require(amountOutExpected > 0, "Invalid expected amount");
777         require(executorFee > 0, "Invalid executor fee");
778 
779         address _wethAddress = uniswapV2Router.WETH();
780         bool deflationary = false;
781 
782         if (orderType != OrderType.EthForTokens) {
783             require(
784                 msg.value == executorFee,
785                 "Transaction value must match executor fee"
786             );
787             if (orderType == OrderType.TokensForEth) {
788                 require(tokenOut == _wethAddress, "Token out must be WETH");
789             } else {
790                 getPair(tokenIn, _wethAddress);
791             }
792             uint256 beforeBalance = IERC20(tokenIn).balanceOf(address(this));
793             // transfer tokenIn funds in necessary for order execution
794             TransferHelper.safeTransferFrom(
795                 tokenIn,
796                 msg.sender,
797                 address(this),
798                 amountInOffered
799             );
800             uint256 afterBalance = IERC20(tokenIn).balanceOf(address(this));
801             if (afterBalance.sub(beforeBalance) != amountInOffered) {
802                 amountInOffered = afterBalance.sub(beforeBalance);
803                 deflationary = true;
804             }
805             require(amountInOffered > 0, "Invalid final offered amount");
806         } else {
807             require(tokenIn == _wethAddress, "Token in must be WETH");
808             require(
809                 msg.value == amountInOffered.add(executorFee),
810                 "Transaction value must match offer and fee"
811             );
812         }
813 
814         // get canonical uniswap pair address
815         address _pairAddress = getPair(tokenIn, tokenOut);
816 
817         (uint256 _orderId, Order memory _order) = registerOrder(
818             orderType,
819             msg.sender,
820             tokenIn,
821             tokenOut,
822             _pairAddress,
823             amountInOffered,
824             amountOutExpected,
825             executorFee,
826             msg.value,
827             deflationary
828         );
829 
830         emit OrderPlaced(
831             _orderId,
832             _order.orderType,
833             _order.maker,
834             _order.tokenIn,
835             _order.tokenOut,
836             _order.amountInOffered,
837             _order.amountOutExpected,
838             _order.executorFee,
839             _order.totalEthDeposited
840         );
841 
842         return _orderId;
843     }
844 
845     function updateOrder(
846         uint256 orderId,
847         uint256 amountInOffered,
848         uint256 amountOutExpected,
849         uint256 executorFee
850     ) external payable exists(orderId) nonReentrant returns (bool) {
851         Order memory _updatingOrder = orders[orderId];
852         require(msg.sender == _updatingOrder.maker, "Permission denied");
853         require(
854             _updatingOrder.orderState == OrderState.Placed,
855             "Cannot update order"
856         );
857         require(amountInOffered > 0, "Invalid offered amount");
858         require(amountOutExpected > 0, "Invalid expected amount");
859         require(executorFee > 0, "Invalid executor fee");
860 
861         if (_updatingOrder.orderType == OrderType.EthForTokens) {
862             uint256 newTotal = amountInOffered.add(executorFee);
863             if (newTotal > _updatingOrder.totalEthDeposited) {
864                 require(
865                     msg.value == newTotal.sub(_updatingOrder.totalEthDeposited),
866                     "Additional deposit must match"
867                 );
868             } else if (newTotal < _updatingOrder.totalEthDeposited) {
869                 TransferHelper.safeTransferETH(
870                     _updatingOrder.maker,
871                     _updatingOrder.totalEthDeposited.sub(newTotal)
872                 );
873             }
874             _updatingOrder.totalEthDeposited = newTotal;
875         } else {
876             if (executorFee > _updatingOrder.executorFee) {
877                 require(
878                     msg.value == executorFee.sub(_updatingOrder.executorFee),
879                     "Additional fee must match"
880                 );
881             } else if (executorFee < _updatingOrder.executorFee) {
882                 TransferHelper.safeTransferETH(
883                     _updatingOrder.maker,
884                     _updatingOrder.executorFee.sub(executorFee)
885                 );
886             }
887             _updatingOrder.totalEthDeposited = executorFee;
888             if (amountInOffered > _updatingOrder.amountInOffered) {
889                 uint256 beforeBalance = IERC20(_updatingOrder.tokenIn)
890                     .balanceOf(address(this));
891                 TransferHelper.safeTransferFrom(
892                     _updatingOrder.tokenIn,
893                     msg.sender,
894                     address(this),
895                     amountInOffered.sub(_updatingOrder.amountInOffered)
896                 );
897                 uint256 afterBalance = IERC20(_updatingOrder.tokenIn).balanceOf(
898                     address(this)
899                 );
900                 amountInOffered = _updatingOrder.amountInOffered.add(
901                     afterBalance.sub(beforeBalance)
902                 );
903             } else if (amountInOffered < _updatingOrder.amountInOffered) {
904                 TransferHelper.safeTransfer(
905                     _updatingOrder.tokenIn,
906                     _updatingOrder.maker,
907                     _updatingOrder.amountInOffered.sub(amountInOffered)
908                 );
909             }
910         }
911 
912         // update order record
913         _updatingOrder.amountInOffered = amountInOffered;
914         _updatingOrder.amountOutExpected = amountOutExpected;
915         _updatingOrder.executorFee = executorFee;
916         orders[orderId] = _updatingOrder;
917 
918         emit OrderUpdated(
919             orderId,
920             amountInOffered,
921             amountOutExpected,
922             executorFee
923         );
924 
925         return true;
926     }
927 
928     function cancelOrder(uint256 orderId)
929         external
930         exists(orderId)
931         nonReentrant
932         returns (bool)
933     {
934         Order memory _cancellingOrder = orders[orderId];
935         require(msg.sender == _cancellingOrder.maker, "Permission denied");
936         require(
937             _cancellingOrder.orderState == OrderState.Placed,
938             "Cannot cancel order"
939         );
940 
941         proceedOrder(orderId, OrderState.Cancelled);
942 
943         // Revert token allocation, funds, and fees
944         if (_cancellingOrder.orderType != OrderType.EthForTokens) {
945             TransferHelper.safeTransfer(
946                 _cancellingOrder.tokenIn,
947                 _cancellingOrder.maker,
948                 _cancellingOrder.amountInOffered
949             );
950         }
951 
952         TransferHelper.safeTransferETH(
953             _cancellingOrder.maker,
954             _cancellingOrder.totalEthDeposited
955         );
956 
957         emit OrderCancelled(orderId);
958         return true;
959     }
960 
961     function executeOrder(uint256 orderId)
962         external
963         exists(orderId)
964         nonReentrant
965         returns (uint256[] memory amounts)
966     {
967         Order memory _executingOrder = orders[orderId];
968         require(
969             _executingOrder.orderState == OrderState.Placed,
970             "Cannot execute order"
971         );
972 
973         proceedOrder(orderId, OrderState.Executed);
974 
975         address[] memory _addressPair = createPair(
976             _executingOrder.tokenIn,
977             _executingOrder.tokenOut
978         );
979         uint256 unitradeFee = 0;
980 
981         if (_executingOrder.orderType == OrderType.TokensForTokens) {
982             TransferHelper.safeApprove(
983                 _executingOrder.tokenIn,
984                 address(uniswapV2Router),
985                 _executingOrder.amountInOffered
986             );
987             uint256 _tokenFee = _executingOrder.amountInOffered.mul(feeMul).div(
988                 feeDiv
989             );
990             if (_executingOrder.deflationary) {
991                 uint256 beforeBalance = IERC20(_executingOrder.tokenOut)
992                     .balanceOf(_executingOrder.maker);
993                 uniswapV2Router
994                     .swapExactTokensForTokensSupportingFeeOnTransferTokens(
995                     _executingOrder.amountInOffered.sub(_tokenFee),
996                     _executingOrder.amountOutExpected,
997                     _addressPair,
998                     _executingOrder.maker,
999                     UINT256_MAX
1000                 );
1001                 uint256 afterBalance = IERC20(_executingOrder.tokenOut)
1002                     .balanceOf(_executingOrder.maker);
1003                 amounts = new uint256[](2);
1004                 amounts[0] = _executingOrder.amountInOffered.sub(_tokenFee);
1005                 amounts[1] = afterBalance.sub(beforeBalance);
1006             } else {
1007                 amounts = uniswapV2Router.swapExactTokensForTokens(
1008                     _executingOrder.amountInOffered.sub(_tokenFee),
1009                     _executingOrder.amountOutExpected,
1010                     _addressPair,
1011                     _executingOrder.maker,
1012                     UINT256_MAX
1013                 );
1014             }
1015 
1016             if (_tokenFee > 0) {
1017                 // Convert x% of tokens to ETH as fee
1018                 address[] memory _wethPair = createPair(
1019                     _executingOrder.tokenIn,
1020                     uniswapV2Router.WETH()
1021                 );
1022                 if (_executingOrder.deflationary) {
1023                     uint256 beforeBalance = IERC20(uniswapV2Router.WETH())
1024                         .balanceOf(address(this));
1025                     uniswapV2Router
1026                         .swapExactTokensForETHSupportingFeeOnTransferTokens(
1027                         _tokenFee,
1028                         0, //take any
1029                         _wethPair,
1030                         address(this),
1031                         UINT256_MAX
1032                     );
1033                     uint256 afterBalance = IERC20(uniswapV2Router.WETH())
1034                         .balanceOf(address(this));
1035                     unitradeFee = afterBalance.sub(beforeBalance);
1036                 } else {
1037                     uint256[] memory _ethSwapResult = uniswapV2Router
1038                         .swapExactTokensForETH(
1039                         _tokenFee,
1040                         0, //take any
1041                         _wethPair,
1042                         address(this),
1043                         UINT256_MAX
1044                     );
1045                     unitradeFee = _ethSwapResult[1];
1046                 }
1047             }
1048         } else if (_executingOrder.orderType == OrderType.TokensForEth) {
1049             TransferHelper.safeApprove(
1050                 _executingOrder.tokenIn,
1051                 address(uniswapV2Router),
1052                 _executingOrder.amountInOffered
1053             );
1054             if (_executingOrder.deflationary) {
1055                 uint256 beforeBalance = address(this).balance;
1056                 uniswapV2Router
1057                     .swapExactTokensForETHSupportingFeeOnTransferTokens(
1058                     _executingOrder.amountInOffered,
1059                     _executingOrder.amountOutExpected,
1060                     _addressPair,
1061                     address(this),
1062                     UINT256_MAX
1063                 );
1064                 uint256 afterBalance = address(this).balance;
1065                 amounts = new uint256[](2);
1066                 amounts[0] = _executingOrder.amountInOffered;
1067                 amounts[1] = afterBalance.sub(beforeBalance);
1068             } else {
1069                 amounts = uniswapV2Router.swapExactTokensForETH(
1070                     _executingOrder.amountInOffered,
1071                     _executingOrder.amountOutExpected,
1072                     _addressPair,
1073                     address(this),
1074                     UINT256_MAX
1075                 );
1076             }
1077 
1078             unitradeFee = amounts[1].mul(feeMul).div(feeDiv);
1079             if (amounts[1].sub(unitradeFee) > 0) {
1080                 // Transfer to maker after post swap fee split
1081                 TransferHelper.safeTransferETH(
1082                     _executingOrder.maker,
1083                     amounts[1].sub(unitradeFee)
1084                 );
1085             }
1086         } else if (_executingOrder.orderType == OrderType.EthForTokens) {
1087             // Subtract fee from initial swap
1088             uint256 amountEthOffered = _executingOrder.totalEthDeposited.sub(
1089                 _executingOrder.executorFee
1090             );
1091             unitradeFee = amountEthOffered.mul(feeMul).div(feeDiv);
1092 
1093             uint256 beforeBalance = IERC20(_executingOrder.tokenOut).balanceOf(
1094                 _executingOrder.maker
1095             );
1096             uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1097                 value: amountEthOffered.sub(unitradeFee)
1098             }(
1099                 _executingOrder.amountOutExpected,
1100                 _addressPair,
1101                 _executingOrder.maker,
1102                 UINT256_MAX
1103             );
1104             uint256 afterBalance = IERC20(_executingOrder.tokenOut).balanceOf(
1105                 _executingOrder.maker
1106             );
1107             amounts = new uint256[](2);
1108             amounts[0] = amountEthOffered.sub(unitradeFee);
1109             amounts[1] = afterBalance.sub(beforeBalance);
1110         }
1111 
1112         // Transfer fee to incinerator/staker
1113         if (unitradeFee > 0) {
1114             uint256 burnAmount = unitradeFee.mul(splitMul).div(splitDiv);
1115             if (burnAmount > 0) {
1116                 incinerator.burn{value: burnAmount}(); //no require
1117             }
1118             staker.deposit{value: unitradeFee.sub(burnAmount)}(); //no require
1119         }
1120 
1121         // transfer fee to executor
1122         TransferHelper.safeTransferETH(msg.sender, _executingOrder.executorFee);
1123 
1124         emit OrderExecuted(orderId, msg.sender, amounts, unitradeFee);
1125     }
1126 
1127     function registerOrder(
1128         OrderType orderType,
1129         address payable maker,
1130         address tokenIn,
1131         address tokenOut,
1132         address pairAddress,
1133         uint256 amountInOffered,
1134         uint256 amountOutExpected,
1135         uint256 executorFee,
1136         uint256 totalEthDeposited,
1137         bool deflationary
1138     ) internal returns (uint256 orderId, Order memory) {
1139         uint256 _orderId = orderNumber;
1140         orderNumber++;
1141 
1142         // create order entries
1143         Order memory _order = Order({
1144             orderType: orderType,
1145             maker: maker,
1146             tokenIn: tokenIn,
1147             tokenOut: tokenOut,
1148             amountInOffered: amountInOffered,
1149             amountOutExpected: amountOutExpected,
1150             executorFee: executorFee,
1151             totalEthDeposited: totalEthDeposited,
1152             activeOrderIndex: activeOrders.length,
1153             orderState: OrderState.Placed,
1154             deflationary: deflationary
1155         });
1156 
1157         activeOrders.push(_orderId);
1158         orders[_orderId] = _order;
1159         ordersForAddress[maker].push(_orderId);
1160         ordersForAddress[pairAddress].push(_orderId);
1161 
1162         return (_orderId, _order);
1163     }
1164 
1165     function proceedOrder(uint256 orderId, OrderState nextState)
1166         internal
1167         returns (bool)
1168     {
1169         Order memory _proceedingOrder = orders[orderId];
1170         require(
1171             _proceedingOrder.orderState == OrderState.Placed,
1172             "Cannot proceed order"
1173         );
1174 
1175         if (activeOrders.length > 1) {
1176             uint256 _availableIndex = _proceedingOrder.activeOrderIndex;
1177             uint256 _lastOrderId = activeOrders[activeOrders.length - 1];
1178             Order memory _lastOrder = orders[_lastOrderId];
1179             _lastOrder.activeOrderIndex = _availableIndex;
1180             orders[_lastOrderId] = _lastOrder;
1181             activeOrders[_availableIndex] = _lastOrderId;
1182         }
1183 
1184         activeOrders.pop();
1185         _proceedingOrder.orderState = nextState;
1186         _proceedingOrder.activeOrderIndex = UINT256_MAX; // indicate that it's not active
1187         orders[orderId] = _proceedingOrder;
1188 
1189         return true;
1190     }
1191 
1192     function getPair(address tokenA, address tokenB)
1193         internal
1194         view
1195         returns (address)
1196     {
1197         address _pairAddress = uniswapV2Factory.getPair(tokenA, tokenB);
1198         require(_pairAddress != address(0), "Unavailable pair address");
1199         return _pairAddress;
1200     }
1201 
1202     function getOrder(uint256 orderId)
1203         external
1204         view
1205         exists(orderId)
1206         returns (
1207             OrderType orderType,
1208             address payable maker,
1209             address tokenIn,
1210             address tokenOut,
1211             uint256 amountInOffered,
1212             uint256 amountOutExpected,
1213             uint256 executorFee,
1214             uint256 totalEthDeposited,
1215             OrderState orderState,
1216             bool deflationary
1217         )
1218     {
1219         Order memory _order = orders[orderId];
1220         return (
1221             _order.orderType,
1222             _order.maker,
1223             _order.tokenIn,
1224             _order.tokenOut,
1225             _order.amountInOffered,
1226             _order.amountOutExpected,
1227             _order.executorFee,
1228             _order.totalEthDeposited,
1229             _order.orderState,
1230             _order.deflationary
1231         );
1232     }
1233 
1234     function updateStaker(IUniTradeStaker newStaker) external onlyOwner {
1235         staker = newStaker;
1236         emit StakerUpdated(address(newStaker));
1237     }
1238 
1239     function updateFee(uint16 _feeMul, uint16 _feeDiv) external onlyOwner {
1240         require(_feeMul < _feeDiv, "!fee");
1241         feeMul = _feeMul;
1242         feeDiv = _feeDiv;
1243     }
1244 
1245     function updateSplit(uint16 _splitMul, uint16 _splitDiv)
1246         external
1247         onlyOwner
1248     {
1249         require(_splitMul < _splitDiv, "!split");
1250         splitMul = _splitMul;
1251         splitDiv = _splitDiv;
1252     }
1253 
1254     function createPair(address tokenA, address tokenB)
1255         internal
1256         pure
1257         returns (address[] memory)
1258     {
1259         address[] memory _addressPair = new address[](2);
1260         _addressPair[0] = tokenA;
1261         _addressPair[1] = tokenB;
1262         return _addressPair;
1263     }
1264 
1265     function getActiveOrdersLength() external view returns (uint256) {
1266         return activeOrders.length;
1267     }
1268 
1269     function getActiveOrderId(uint256 index) external view returns (uint256) {
1270         return activeOrders[index];
1271     }
1272 
1273     function getOrdersForAddressLength(address _address)
1274         external
1275         view
1276         returns (uint256)
1277     {
1278         return ordersForAddress[_address].length;
1279     }
1280 
1281     function getOrderIdForAddress(address _address, uint256 index)
1282         external
1283         view
1284         returns (uint256)
1285     {
1286         return ordersForAddress[_address][index];
1287     }
1288 
1289     receive() external payable {} // to receive ETH from Uniswap
1290 }