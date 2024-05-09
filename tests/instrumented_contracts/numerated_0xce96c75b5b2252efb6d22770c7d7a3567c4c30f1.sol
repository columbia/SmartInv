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
324 // Dependency file: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
325 
326 // pragma solidity >=0.5.0;
327 
328 interface IUniswapV2Factory {
329     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
330 
331     function feeTo() external view returns (address);
332     function feeToSetter() external view returns (address);
333 
334     function getPair(address tokenA, address tokenB) external view returns (address pair);
335     function allPairs(uint) external view returns (address pair);
336     function allPairsLength() external view returns (uint);
337 
338     function createPair(address tokenA, address tokenB) external returns (address pair);
339 
340     function setFeeTo(address) external;
341     function setFeeToSetter(address) external;
342 }
343 
344 
345 // Dependency file: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
346 
347 // pragma solidity >=0.6.2;
348 
349 interface IUniswapV2Router01 {
350     function factory() external pure returns (address);
351     function WETH() external pure returns (address);
352 
353     function addLiquidity(
354         address tokenA,
355         address tokenB,
356         uint amountADesired,
357         uint amountBDesired,
358         uint amountAMin,
359         uint amountBMin,
360         address to,
361         uint deadline
362     ) external returns (uint amountA, uint amountB, uint liquidity);
363     function addLiquidityETH(
364         address token,
365         uint amountTokenDesired,
366         uint amountTokenMin,
367         uint amountETHMin,
368         address to,
369         uint deadline
370     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
371     function removeLiquidity(
372         address tokenA,
373         address tokenB,
374         uint liquidity,
375         uint amountAMin,
376         uint amountBMin,
377         address to,
378         uint deadline
379     ) external returns (uint amountA, uint amountB);
380     function removeLiquidityETH(
381         address token,
382         uint liquidity,
383         uint amountTokenMin,
384         uint amountETHMin,
385         address to,
386         uint deadline
387     ) external returns (uint amountToken, uint amountETH);
388     function removeLiquidityWithPermit(
389         address tokenA,
390         address tokenB,
391         uint liquidity,
392         uint amountAMin,
393         uint amountBMin,
394         address to,
395         uint deadline,
396         bool approveMax, uint8 v, bytes32 r, bytes32 s
397     ) external returns (uint amountA, uint amountB);
398     function removeLiquidityETHWithPermit(
399         address token,
400         uint liquidity,
401         uint amountTokenMin,
402         uint amountETHMin,
403         address to,
404         uint deadline,
405         bool approveMax, uint8 v, bytes32 r, bytes32 s
406     ) external returns (uint amountToken, uint amountETH);
407     function swapExactTokensForTokens(
408         uint amountIn,
409         uint amountOutMin,
410         address[] calldata path,
411         address to,
412         uint deadline
413     ) external returns (uint[] memory amounts);
414     function swapTokensForExactTokens(
415         uint amountOut,
416         uint amountInMax,
417         address[] calldata path,
418         address to,
419         uint deadline
420     ) external returns (uint[] memory amounts);
421     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
422         external
423         payable
424         returns (uint[] memory amounts);
425     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
426         external
427         returns (uint[] memory amounts);
428     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
429         external
430         returns (uint[] memory amounts);
431     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
432         external
433         payable
434         returns (uint[] memory amounts);
435 
436     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
437     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
438     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
439     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
440     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
441 }
442 
443 
444 // Dependency file: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
445 
446 // pragma solidity >=0.6.2;
447 
448 // import '/Users/train/Documents/Work/Decent/unitrade/unitrade/node_modules/@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol';
449 
450 interface IUniswapV2Router02 is IUniswapV2Router01 {
451     function removeLiquidityETHSupportingFeeOnTransferTokens(
452         address token,
453         uint liquidity,
454         uint amountTokenMin,
455         uint amountETHMin,
456         address to,
457         uint deadline
458     ) external returns (uint amountETH);
459     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
460         address token,
461         uint liquidity,
462         uint amountTokenMin,
463         uint amountETHMin,
464         address to,
465         uint deadline,
466         bool approveMax, uint8 v, bytes32 r, bytes32 s
467     ) external returns (uint amountETH);
468 
469     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
470         uint amountIn,
471         uint amountOutMin,
472         address[] calldata path,
473         address to,
474         uint deadline
475     ) external;
476     function swapExactETHForTokensSupportingFeeOnTransferTokens(
477         uint amountOutMin,
478         address[] calldata path,
479         address to,
480         uint deadline
481     ) external payable;
482     function swapExactTokensForETHSupportingFeeOnTransferTokens(
483         uint amountIn,
484         uint amountOutMin,
485         address[] calldata path,
486         address to,
487         uint deadline
488     ) external;
489 }
490 
491 
492 // Dependency file: @uniswap/lib/contracts/libraries/TransferHelper.sol
493 
494 // pragma solidity >=0.6.0;
495 
496 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
497 library TransferHelper {
498     function safeApprove(address token, address to, uint value) internal {
499         // bytes4(keccak256(bytes('approve(address,uint256)')));
500         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
501         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
502     }
503 
504     function safeTransfer(address token, address to, uint value) internal {
505         // bytes4(keccak256(bytes('transfer(address,uint256)')));
506         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
507         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
508     }
509 
510     function safeTransferFrom(address token, address from, address to, uint value) internal {
511         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
512         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
513         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
514     }
515 
516     function safeTransferETH(address to, uint value) internal {
517         (bool success,) = to.call{value:value}(new bytes(0));
518         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
519     }
520 }
521 
522 
523 // Dependency file: contracts/UniTradeIncinerator.sol
524 
525 // pragma solidity ^0.6.6;
526 
527 // import "@openzeppelin/contracts/math/SafeMath.sol";
528 // import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
529 // import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
530 
531 contract UniTradeIncinerator {
532     using SafeMath for uint256;
533 
534     uint256 constant UINT256_MAX = ~uint256(0);
535     IUniswapV2Router02 public immutable uniswapV2Router;
536     address public immutable unitrade;
537     uint256 lastIncinerated;
538 
539     event UniTradeToBurn(uint256 etherIn);
540     event UniTradeBurned(uint256 etherIn, uint256 tokensBurned);
541 
542     constructor(IUniswapV2Router02 _uniswapV2Router, address _unitrade) public {
543         uniswapV2Router = _uniswapV2Router;
544         unitrade = _unitrade;
545         lastIncinerated = block.timestamp;
546     }
547 
548     function burn() external payable returns (bool) {
549         require(msg.value > 0, "Nothing to burn");
550 
551         emit UniTradeToBurn(msg.value);
552 
553         if (block.timestamp < lastIncinerated + 1 days) {
554             return true;
555         }
556 
557         lastIncinerated = block.timestamp;
558 
559         address[] memory _tokenPair = new address[](2);
560         _tokenPair[0] = uniswapV2Router.WETH();
561         _tokenPair[1] = unitrade;
562 
563         uint256[] memory _swapResult = uniswapV2Router.swapExactETHForTokens{
564             value: address(this).balance
565         }(
566             0, // take any
567             _tokenPair,
568             address(this),
569             UINT256_MAX
570         );
571 
572         emit UniTradeBurned(_swapResult[0], _swapResult[1]);
573 
574         return true;
575     }
576 }
577 
578 
579 // Dependency file: contracts/IUniTradeStaker.sol
580 
581 // pragma solidity ^0.6.6;
582 
583 interface IUniTradeStaker
584 {
585     function deposit() external payable;
586 }
587 
588 
589 // Root file: contracts/UniTradeOrderBook.sol
590 
591 pragma solidity ^0.6.6;
592 
593 // import "@openzeppelin/contracts/math/SafeMath.sol";
594 // import "@openzeppelin/contracts/access/Ownable.sol";
595 // import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
596 // import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
597 // import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
598 // import "@uniswap/lib/contracts/libraries/TransferHelper.sol";
599 // import "contracts/UniTradeIncinerator.sol";
600 // import "contracts/IUniTradeStaker.sol";
601 
602 contract UniTradeOrderBook is Ownable, ReentrancyGuard {
603     using SafeMath for uint256;
604 
605     uint256 constant UINT256_MAX = ~uint256(0);
606     IUniswapV2Router02 public immutable uniswapV2Router;
607     IUniswapV2Factory public immutable uniswapV2Factory;
608     UniTradeIncinerator public immutable incinerator;
609     IUniTradeStaker public staker;
610 
611     enum OrderType {TokensForTokens, EthForTokens, TokensForEth}
612     enum OrderState {Placed, Cancelled, Executed}
613 
614     struct Order {
615         OrderType orderType;
616         address payable maker;
617         address tokenIn;
618         address tokenOut;
619         uint256 amountInOffered;
620         uint256 amountOutExpected;
621         uint256 executorFee;
622         uint256 totalEthDeposited;
623         uint256 activeOrderIndex;
624         OrderState orderState;
625     }
626 
627     uint256 private orderNumber;
628     uint256[] private activeOrders;
629     mapping(uint256 => Order) private orders;
630     mapping(address => uint256[]) private ordersForAddress;
631 
632     event OrderPlaced(
633         uint256 indexed orderId,
634         OrderType orderType,
635         address payable indexed maker,
636         address tokenIn,
637         address tokenOut,
638         uint256 amountInOffered,
639         uint256 amountOutExpected,
640         uint256 executorFee,
641         uint256 totalEthDeposited
642     );
643     event OrderCancelled(uint256 indexed orderId);
644     event OrderExecuted(
645         uint256 indexed orderId,
646         address indexed executor,
647         uint256[] amounts,
648         uint256 unitradeFee
649     );
650     event StakerUpdated(address newStaker);
651 
652     modifier exists(uint256 orderId) {
653         require(orders[orderId].maker != address(0), "Order not found");
654         _;
655     }
656 
657     constructor(
658         IUniswapV2Router02 _uniswapV2Router,
659         UniTradeIncinerator _incinerator,
660         IUniTradeStaker _staker
661     ) public {
662         uniswapV2Router = _uniswapV2Router;
663         uniswapV2Factory = IUniswapV2Factory(_uniswapV2Router.factory());
664         incinerator = _incinerator;
665         staker = _staker;
666     }
667 
668     function placeOrder(
669         OrderType orderType,
670         address tokenIn,
671         address tokenOut,
672         uint256 amountInOffered,
673         uint256 amountOutExpected,
674         uint256 executorFee
675     ) external payable nonReentrant returns (uint256) {
676         require(amountInOffered > 0, "Invalid offered amount");
677         require(amountOutExpected > 0, "Invalid expected amount");
678         require(executorFee > 0, "Invalid executor fee");
679 
680         address _wethAddress = uniswapV2Router.WETH();
681 
682         if (orderType != OrderType.EthForTokens) {
683             require(
684                 msg.value == executorFee,
685                 "Transaction value must match executor fee"
686             );
687             if (orderType == OrderType.TokensForEth) {
688                 require(tokenOut == _wethAddress, "Token out must be WETH");
689             } else {
690                 getPair(tokenIn, _wethAddress);
691             }
692             // transfer tokenIn funds in necessary for order execution
693             TransferHelper.safeTransferFrom(
694                 tokenIn,
695                 msg.sender,
696                 address(this),
697                 amountInOffered
698             );
699         } else {
700             require(tokenIn == _wethAddress, "Token in must be WETH");
701             require(
702                 msg.value == amountInOffered.add(executorFee),
703                 "Transaction value must match offer and fee"
704             );
705         }
706 
707         // get canonical uniswap pair address
708         address _pairAddress = getPair(tokenIn, tokenOut);
709 
710         (uint256 _orderId, Order memory _order) = registerOrder(
711             orderType,
712             msg.sender,
713             tokenIn,
714             tokenOut,
715             _pairAddress,
716             amountInOffered,
717             amountOutExpected,
718             executorFee,
719             msg.value
720         );
721 
722         emit OrderPlaced(
723             _orderId,
724             _order.orderType,
725             _order.maker,
726             _order.tokenIn,
727             _order.tokenOut,
728             _order.amountInOffered,
729             _order.amountOutExpected,
730             _order.executorFee,
731             _order.totalEthDeposited
732         );
733 
734         return _orderId;
735     }
736 
737     function updateOrder(
738         uint256 orderId,
739         uint256 amountInOffered,
740         uint256 amountOutExpected,
741         uint256 executorFee
742     ) external payable exists(orderId) nonReentrant returns (bool) {
743         Order memory _updatingOrder = orders[orderId];
744         require(msg.sender == _updatingOrder.maker, "Permission denied");
745         require(
746             _updatingOrder.orderState == OrderState.Placed,
747             "Cannot update order"
748         );
749         require(amountInOffered > 0, "Invalid offered amount");
750         require(amountOutExpected > 0, "Invalid expected amount");
751         require(executorFee > 0, "Invalid executor fee");
752 
753         if (_updatingOrder.orderType == OrderType.EthForTokens) {
754             uint256 newTotal = amountInOffered.add(executorFee);
755             if (newTotal > _updatingOrder.totalEthDeposited) {
756                 require(
757                     msg.value == newTotal.sub(_updatingOrder.totalEthDeposited),
758                     "Additional deposit must match"
759                 );
760             } else if (newTotal < _updatingOrder.totalEthDeposited) {
761                 TransferHelper.safeTransferETH(
762                     _updatingOrder.maker,
763                     _updatingOrder.totalEthDeposited.sub(newTotal)
764                 );
765             }
766             _updatingOrder.totalEthDeposited = newTotal;
767         } else {
768             if (executorFee > _updatingOrder.executorFee) {
769                 require(
770                     msg.value == executorFee.sub(_updatingOrder.executorFee),
771                     "Additional fee must match"
772                 );
773             } else if (executorFee < _updatingOrder.executorFee) {
774                 TransferHelper.safeTransferETH(
775                     _updatingOrder.maker,
776                     _updatingOrder.executorFee.sub(executorFee)
777                 );
778             }
779             _updatingOrder.totalEthDeposited = executorFee;
780             if (amountInOffered > _updatingOrder.amountInOffered) {
781                 TransferHelper.safeTransferFrom(
782                     _updatingOrder.tokenIn,
783                     msg.sender,
784                     address(this),
785                     amountInOffered.sub(_updatingOrder.amountInOffered)
786                 );
787             } else if (amountInOffered < _updatingOrder.amountInOffered) {
788                 TransferHelper.safeTransfer(
789                     _updatingOrder.tokenIn,
790                     _updatingOrder.maker,
791                     _updatingOrder.amountInOffered.sub(amountInOffered)
792                 );
793             }
794         }
795 
796         // update order record
797         _updatingOrder.amountInOffered = amountInOffered;
798         _updatingOrder.amountOutExpected = amountOutExpected;
799         _updatingOrder.executorFee = executorFee;
800         orders[orderId] = _updatingOrder;
801 
802         return true;
803     }
804 
805     function cancelOrder(uint256 orderId)
806         external
807         exists(orderId)
808         nonReentrant
809         returns (bool)
810     {
811         Order memory _cancellingOrder = orders[orderId];
812         require(msg.sender == _cancellingOrder.maker, "Permission denied");
813         require(
814             _cancellingOrder.orderState == OrderState.Placed,
815             "Cannot cancel order"
816         );
817 
818         proceedOrder(orderId, OrderState.Cancelled);
819 
820         // Revert token allocation, funds, and fees
821         if (_cancellingOrder.orderType != OrderType.EthForTokens) {
822             TransferHelper.safeTransfer(
823                 _cancellingOrder.tokenIn,
824                 _cancellingOrder.maker,
825                 _cancellingOrder.amountInOffered
826             );
827         }
828         TransferHelper.safeTransferETH(
829             _cancellingOrder.maker,
830             _cancellingOrder.totalEthDeposited
831         );
832 
833         emit OrderCancelled(orderId);
834         return true;
835     }
836 
837     function executeOrder(uint256 orderId)
838         external
839         exists(orderId)
840         nonReentrant
841         returns (uint256[] memory)
842     {
843         Order memory _executingOrder = orders[orderId];
844         require(
845             _executingOrder.orderState == OrderState.Placed,
846             "Cannot execute order"
847         );
848 
849         proceedOrder(orderId, OrderState.Executed);
850 
851         address[] memory _addressPair = createPair(
852             _executingOrder.tokenIn,
853             _executingOrder.tokenOut
854         );
855         uint256[] memory _swapResult;
856         uint256 unitradeFee = 0;
857 
858         if (_executingOrder.orderType == OrderType.TokensForTokens) {
859             TransferHelper.safeApprove(
860                 _executingOrder.tokenIn,
861                 address(uniswapV2Router),
862                 _executingOrder.amountInOffered
863             );
864             uint256 _tokenFee = _executingOrder.amountInOffered.div(100);
865             _swapResult = uniswapV2Router.swapExactTokensForTokens(
866                 _executingOrder.amountInOffered.sub(_tokenFee),
867                 _executingOrder.amountOutExpected,
868                 _addressPair,
869                 _executingOrder.maker,
870                 UINT256_MAX
871             );
872             if (_tokenFee > 0) {
873                 // Convert 1% of tokens to ETH as fee
874                 address[] memory _wethPair = createPair(
875                     _executingOrder.tokenIn,
876                     uniswapV2Router.WETH()
877                 );
878                 uint256[] memory _ethSwapResult = uniswapV2Router
879                     .swapExactTokensForETH(
880                     _tokenFee,
881                     0, //take any
882                     _wethPair,
883                     address(this),
884                     UINT256_MAX
885                 );
886                 unitradeFee = _ethSwapResult[1];
887             }
888         } else if (_executingOrder.orderType == OrderType.TokensForEth) {
889             TransferHelper.safeApprove(
890                 _executingOrder.tokenIn,
891                 address(uniswapV2Router),
892                 _executingOrder.amountInOffered
893             );
894             _swapResult = uniswapV2Router.swapExactTokensForETH(
895                 _executingOrder.amountInOffered,
896                 _executingOrder.amountOutExpected,
897                 _addressPair,
898                 address(this),
899                 UINT256_MAX
900             );
901             unitradeFee = _swapResult[1].div(100);
902             // Transfer to maker after post swap fee split
903             TransferHelper.safeTransferETH(
904                 _executingOrder.maker,
905                 _swapResult[1].sub(unitradeFee)
906             );
907         } else if (_executingOrder.orderType == OrderType.EthForTokens) {
908             // Subtract fee from initial swap
909             uint256 amountEthOffered = _executingOrder.totalEthDeposited.sub(
910                 _executingOrder.executorFee
911             );
912             unitradeFee = amountEthOffered.div(100);
913             _swapResult = uniswapV2Router.swapExactETHForTokens{
914                 value: amountEthOffered.sub(unitradeFee)
915             }(
916                 _executingOrder.amountOutExpected,
917                 _addressPair,
918                 _executingOrder.maker,
919                 UINT256_MAX
920             );
921         }
922 
923         // Transfer fee to incinerator/staker
924         if (unitradeFee > 0) {
925             uint256 burnAmount = unitradeFee.mul(6).div(10);
926             if (burnAmount > 0) {
927                 incinerator.burn{value: burnAmount}(); //no require
928             }
929             staker.deposit{value: unitradeFee.sub(burnAmount)}(); //no require
930         }
931 
932         // transfer fee to executor
933         TransferHelper.safeTransferETH(msg.sender, _executingOrder.executorFee);
934 
935         emit OrderExecuted(orderId, msg.sender, _swapResult, unitradeFee);
936 
937         return _swapResult;
938     }
939 
940     function registerOrder(
941         OrderType orderType,
942         address payable maker,
943         address tokenIn,
944         address tokenOut,
945         address pairAddress,
946         uint256 amountInOffered,
947         uint256 amountOutExpected,
948         uint256 executorFee,
949         uint256 totalEthDeposited
950     ) internal returns (uint256 orderId, Order memory) {
951         uint256 _orderId = orderNumber;
952         orderNumber++;
953 
954         // create order entries
955         Order memory _order = Order({
956             orderType: orderType,
957             maker: maker,
958             tokenIn: tokenIn,
959             tokenOut: tokenOut,
960             amountInOffered: amountInOffered,
961             amountOutExpected: amountOutExpected,
962             executorFee: executorFee,
963             totalEthDeposited: totalEthDeposited,
964             activeOrderIndex: activeOrders.length,
965             orderState: OrderState.Placed
966         });
967 
968         activeOrders.push(_orderId);
969         orders[_orderId] = _order;
970         ordersForAddress[maker].push(_orderId);
971         ordersForAddress[pairAddress].push(_orderId);
972 
973         return (_orderId, _order);
974     }
975 
976     function proceedOrder(uint256 orderId, OrderState nextState)
977         internal
978         returns (bool)
979     {
980         Order memory _proceedingOrder = orders[orderId];
981         require(
982             _proceedingOrder.orderState == OrderState.Placed,
983             "Cannot proceed order"
984         );
985 
986         if (activeOrders.length > 1) {
987             uint256 _availableIndex = _proceedingOrder.activeOrderIndex;
988             uint256 _lastOrderId = activeOrders[activeOrders.length - 1];
989             Order memory _lastOrder = orders[_lastOrderId];
990             _lastOrder.activeOrderIndex = _availableIndex;
991             orders[_lastOrderId] = _lastOrder;
992             activeOrders[_availableIndex] = _lastOrderId;
993         }
994 
995         activeOrders.pop();
996         _proceedingOrder.orderState = nextState;
997         orders[orderId] = _proceedingOrder;
998 
999         return true;
1000     }
1001 
1002     function getPair(address tokenA, address tokenB)
1003         internal
1004         view
1005         returns (address)
1006     {
1007         address _pairAddress = uniswapV2Factory.getPair(tokenA, tokenB);
1008         require(_pairAddress != address(0), "Unavailable pair address");
1009         return _pairAddress;
1010     }
1011 
1012     function getOrder(uint256 orderId)
1013         external
1014         view
1015         exists(orderId)
1016         returns (
1017             OrderType orderType,
1018             address payable maker,
1019             address tokenIn,
1020             address tokenOut,
1021             uint256 amountInOffered,
1022             uint256 amountOutExpected,
1023             uint256 executorFee,
1024             uint256 totalEthDeposited,
1025             OrderState orderState
1026         )
1027     {
1028         Order memory _order = orders[orderId];
1029         return (
1030             _order.orderType,
1031             _order.maker,
1032             _order.tokenIn,
1033             _order.tokenOut,
1034             _order.amountInOffered,
1035             _order.amountOutExpected,
1036             _order.executorFee,
1037             _order.totalEthDeposited,
1038             _order.orderState
1039         );
1040     }
1041 
1042     function updateStaker(IUniTradeStaker newStaker) external onlyOwner {
1043         staker = newStaker;
1044         emit StakerUpdated(address(newStaker));
1045     }
1046 
1047     function createPair(address tokenA, address tokenB)
1048         internal
1049         pure
1050         returns (address[] memory)
1051     {
1052         address[] memory _addressPair = new address[](2);
1053         _addressPair[0] = tokenA;
1054         _addressPair[1] = tokenB;
1055         return _addressPair;
1056     }
1057 
1058     function getActiveOrdersLength() external view returns (uint256) {
1059         return activeOrders.length;
1060     }
1061 
1062     function getActiveOrderId(uint256 index) external view returns (uint256) {
1063         return activeOrders[index];
1064     }
1065 
1066     function getOrdersForAddressLength(address _address)
1067         external
1068         view
1069         returns (uint256)
1070     {
1071         return ordersForAddress[_address].length;
1072     }
1073 
1074     function getOrderIdForAddress(address _address, uint256 index)
1075         external
1076         view
1077         returns (uint256)
1078     {
1079         return ordersForAddress[_address][index];
1080     }
1081 
1082     receive() external payable {} // to receive ETH from Uniswap
1083 }