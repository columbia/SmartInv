1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/GSN/Context.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /*
165  * @dev Provides information about the current execution context, including the
166  * sender of the transaction and its data. While these are generally available
167  * via msg.sender and msg.data, they should not be accessed in such a direct
168  * manner, since when dealing with GSN meta-transactions the account sending and
169  * paying for execution may not be the actual sender (as far as an application
170  * is concerned).
171  *
172  * This contract is only required for intermediate, library-like contracts.
173  */
174 contract Context {
175     // Empty internal constructor, to prevent people from mistakenly deploying
176     // an instance of this contract, which should be used via inheritance.
177     constructor () internal { }
178     // solhint-disable-previous-line no-empty-blocks
179 
180     function _msgSender() internal view returns (address payable) {
181         return msg.sender;
182     }
183 
184     function _msgData() internal view returns (bytes memory) {
185         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
186         return msg.data;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/ownership/Ownable.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /**
195  * @dev Contract module which provides a basic access control mechanism, where
196  * there is an account (an owner) that can be granted exclusive access to
197  * specific functions.
198  *
199  * This module is used through inheritance. It will make available the modifier
200  * `onlyOwner`, which can be applied to your functions to restrict their use to
201  * the owner.
202  */
203 contract Ownable is Context {
204     address private _owner;
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208     /**
209      * @dev Initializes the contract setting the deployer as the initial owner.
210      */
211     constructor () internal {
212         address msgSender = _msgSender();
213         _owner = msgSender;
214         emit OwnershipTransferred(address(0), msgSender);
215     }
216 
217     /**
218      * @dev Returns the address of the current owner.
219      */
220     function owner() public view returns (address) {
221         return _owner;
222     }
223 
224     /**
225      * @dev Throws if called by any account other than the owner.
226      */
227     modifier onlyOwner() {
228         require(isOwner(), "Ownable: caller is not the owner");
229         _;
230     }
231 
232     /**
233      * @dev Returns true if the caller is the current owner.
234      */
235     function isOwner() public view returns (bool) {
236         return _msgSender() == _owner;
237     }
238 
239     /**
240      * @dev Leaves the contract without owner. It will not be possible to call
241      * `onlyOwner` functions anymore. Can only be called by the current owner.
242      *
243      * NOTE: Renouncing ownership will leave the contract without an owner,
244      * thereby removing any functionality that is only available to the owner.
245      */
246     function renounceOwnership() public onlyOwner {
247         emit OwnershipTransferred(_owner, address(0));
248         _owner = address(0);
249     }
250 
251     /**
252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
253      * Can only be called by the current owner.
254      */
255     function transferOwnership(address newOwner) public onlyOwner {
256         _transferOwnership(newOwner);
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      */
262     function _transferOwnership(address newOwner) internal {
263         require(newOwner != address(0), "Ownable: new owner is the zero address");
264         emit OwnershipTransferred(_owner, newOwner);
265         _owner = newOwner;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Address.sol
270 
271 pragma solidity ^0.5.5;
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following 
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
296         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
297         // for accounts without code, i.e. `keccak256('')`
298         bytes32 codehash;
299         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
300         // solhint-disable-next-line no-inline-assembly
301         assembly { codehash := extcodehash(account) }
302         return (codehash != accountHash && codehash != 0x0);
303     }
304 
305     /**
306      * @dev Converts an `address` into `address payable`. Note that this is
307      * simply a type cast: the actual underlying value is not changed.
308      *
309      * _Available since v2.4.0._
310      */
311     function toPayable(address account) internal pure returns (address payable) {
312         return address(uint160(account));
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      *
331      * _Available since v2.4.0._
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(address(this).balance >= amount, "Address: insufficient balance");
335 
336         // solhint-disable-next-line avoid-call-value
337         (bool success, ) = recipient.call.value(amount)("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 }
341 
342 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
343 
344 pragma solidity ^0.5.0;
345 
346 /**
347  * @dev Contract module that helps prevent reentrant calls to a function.
348  *
349  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
350  * available, which can be applied to functions to make sure there are no nested
351  * (reentrant) calls to them.
352  *
353  * Note that because there is a single `nonReentrant` guard, functions marked as
354  * `nonReentrant` may not call one another. This can be worked around by making
355  * those functions `private`, and then adding `external` `nonReentrant` entry
356  * points to them.
357  *
358  * TIP: If you would like to learn more about reentrancy and alternative ways
359  * to protect against it, check out our blog post
360  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
361  *
362  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
363  * metering changes introduced in the Istanbul hardfork.
364  */
365 contract ReentrancyGuard {
366     bool private _notEntered;
367 
368     constructor () internal {
369         // Storing an initial non-zero value makes deployment a bit more
370         // expensive, but in exchange the refund on every call to nonReentrant
371         // will be lower in amount. Since refunds are capped to a percetange of
372         // the total transaction's gas, it is best to keep them low in cases
373         // like this one, to increase the likelihood of the full refund coming
374         // into effect.
375         _notEntered = true;
376     }
377 
378     /**
379      * @dev Prevents a contract from calling itself, directly or indirectly.
380      * Calling a `nonReentrant` function from another `nonReentrant`
381      * function is not supported. It is possible to prevent this from happening
382      * by making the `nonReentrant` function external, and make it call a
383      * `private` function that does the actual work.
384      */
385     modifier nonReentrant() {
386         // On the first call to nonReentrant, _notEntered will be true
387         require(_notEntered, "ReentrancyGuard: reentrant call");
388 
389         // Any calls to nonReentrant after this point will fail
390         _notEntered = false;
391 
392         _;
393 
394         // By storing the original value once again, a refund is triggered (see
395         // https://eips.ethereum.org/EIPS/eip-2200)
396         _notEntered = true;
397     }
398 }
399 
400 // File: contracts/UniswapV2/UniswapV2Router.sol
401 
402 pragma solidity 0.5.12;
403 
404 interface IUniswapV2Router02 {
405     function factory() external pure returns (address);
406 
407     function WETH() external pure returns (address);
408 
409     function addLiquidity(
410         address tokenA,
411         address tokenB,
412         uint256 amountADesired,
413         uint256 amountBDesired,
414         uint256 amountAMin,
415         uint256 amountBMin,
416         address to,
417         uint256 deadline
418     )
419         external
420         returns (
421             uint256 amountA,
422             uint256 amountB,
423             uint256 liquidity
424         );
425 
426     function addLiquidityETH(
427         address token,
428         uint256 amountTokenDesired,
429         uint256 amountTokenMin,
430         uint256 amountETHMin,
431         address to,
432         uint256 deadline
433     )
434         external
435         payable
436         returns (
437             uint256 amountToken,
438             uint256 amountETH,
439             uint256 liquidity
440         );
441 
442     function removeLiquidity(
443         address tokenA,
444         address tokenB,
445         uint256 liquidity,
446         uint256 amountAMin,
447         uint256 amountBMin,
448         address to,
449         uint256 deadline
450     ) external returns (uint256 amountA, uint256 amountB);
451 
452     function removeLiquidityETH(
453         address token,
454         uint256 liquidity,
455         uint256 amountTokenMin,
456         uint256 amountETHMin,
457         address to,
458         uint256 deadline
459     ) external returns (uint256 amountToken, uint256 amountETH);
460 
461     function removeLiquidityWithPermit(
462         address tokenA,
463         address tokenB,
464         uint256 liquidity,
465         uint256 amountAMin,
466         uint256 amountBMin,
467         address to,
468         uint256 deadline,
469         bool approveMax,
470         uint8 v,
471         bytes32 r,
472         bytes32 s
473     ) external returns (uint256 amountA, uint256 amountB);
474 
475     function removeLiquidityETHWithPermit(
476         address token,
477         uint256 liquidity,
478         uint256 amountTokenMin,
479         uint256 amountETHMin,
480         address to,
481         uint256 deadline,
482         bool approveMax,
483         uint8 v,
484         bytes32 r,
485         bytes32 s
486     ) external returns (uint256 amountToken, uint256 amountETH);
487 
488     function swapExactTokensForTokens(
489         uint256 amountIn,
490         uint256 amountOutMin,
491         address[] calldata path,
492         address to,
493         uint256 deadline
494     ) external returns (uint256[] memory amounts);
495 
496     function swapTokensForExactTokens(
497         uint256 amountOut,
498         uint256 amountInMax,
499         address[] calldata path,
500         address to,
501         uint256 deadline
502     ) external returns (uint256[] memory amounts);
503 
504     function swapExactETHForTokens(
505         uint256 amountOutMin,
506         address[] calldata path,
507         address to,
508         uint256 deadline
509     ) external payable returns (uint256[] memory amounts);
510 
511     function swapTokensForExactETH(
512         uint256 amountOut,
513         uint256 amountInMax,
514         address[] calldata path,
515         address to,
516         uint256 deadline
517     ) external returns (uint256[] memory amounts);
518 
519     function swapExactTokensForETH(
520         uint256 amountIn,
521         uint256 amountOutMin,
522         address[] calldata path,
523         address to,
524         uint256 deadline
525     ) external returns (uint256[] memory amounts);
526 
527     function swapETHForExactTokens(
528         uint256 amountOut,
529         address[] calldata path,
530         address to,
531         uint256 deadline
532     ) external payable returns (uint256[] memory amounts);
533 
534     function removeLiquidityETHSupportingFeeOnTransferTokens(
535         address token,
536         uint256 liquidity,
537         uint256 amountTokenMin,
538         uint256 amountETHMin,
539         address to,
540         uint256 deadline
541     ) external returns (uint256 amountETH);
542 
543     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
544         address token,
545         uint256 liquidity,
546         uint256 amountTokenMin,
547         uint256 amountETHMin,
548         address to,
549         uint256 deadline,
550         bool approveMax,
551         uint8 v,
552         bytes32 r,
553         bytes32 s
554     ) external returns (uint256 amountETH);
555 
556     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
557         uint256 amountIn,
558         uint256 amountOutMin,
559         address[] calldata path,
560         address to,
561         uint256 deadline
562     ) external;
563 
564     function swapExactETHForTokensSupportingFeeOnTransferTokens(
565         uint256 amountOutMin,
566         address[] calldata path,
567         address to,
568         uint256 deadline
569     ) external payable;
570 
571     function swapExactTokensForETHSupportingFeeOnTransferTokens(
572         uint256 amountIn,
573         uint256 amountOutMin,
574         address[] calldata path,
575         address to,
576         uint256 deadline
577     ) external;
578 
579     function quote(
580         uint256 amountA,
581         uint256 reserveA,
582         uint256 reserveB
583     ) external pure returns (uint256 amountB);
584 
585     function getAmountOut(
586         uint256 amountIn,
587         uint256 reserveIn,
588         uint256 reserveOut
589     ) external pure returns (uint256 amountOut);
590 
591     function getAmountIn(
592         uint256 amountOut,
593         uint256 reserveIn,
594         uint256 reserveOut
595     ) external pure returns (uint256 amountIn);
596 
597     function getAmountsOut(uint256 amountIn, address[] calldata path)
598         external
599         view
600         returns (uint256[] memory amounts);
601 
602     function getAmountsIn(uint256 amountOut, address[] calldata path)
603         external
604         view
605         returns (uint256[] memory amounts);
606 }
607 
608 // File: contracts/UniswapV2/UniswapV2Zapin.sol
609 
610 pragma solidity 0.5.12;
611 
612 
613 
614 
615 
616 
617 library TransferHelper {
618     function safeApprove(
619         address token,
620         address to,
621         uint256 value
622     ) internal {
623         // bytes4(keccak256(bytes('approve(address,uint256)')));
624         (bool success, bytes memory data) = token.call(
625             abi.encodeWithSelector(0x095ea7b3, to, value)
626         );
627         require(
628             success && (data.length == 0 || abi.decode(data, (bool))),
629             "TransferHelper: APPROVE_FAILED"
630         );
631     }
632 
633     function safeTransfer(
634         address token,
635         address to,
636         uint256 value
637     ) internal {
638         // bytes4(keccak256(bytes('transfer(address,uint256)')));
639         (bool success, bytes memory data) = token.call(
640             abi.encodeWithSelector(0xa9059cbb, to, value)
641         );
642         require(
643             success && (data.length == 0 || abi.decode(data, (bool))),
644             "TransferHelper: TRANSFER_FAILED"
645         );
646     }
647 
648     function safeTransferFrom(
649         address token,
650         address from,
651         address to,
652         uint256 value
653     ) internal {
654         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
655         (bool success, bytes memory data) = token.call(
656             abi.encodeWithSelector(0x23b872dd, from, to, value)
657         );
658         require(
659             success && (data.length == 0 || abi.decode(data, (bool))),
660             "TransferHelper: TRANSFER_FROM_FAILED"
661         );
662     }
663 }
664 
665 // import "@uniswap/lib/contracts/libraries/Babylonian.sol";
666 library Babylonian {
667     function sqrt(uint256 y) internal pure returns (uint256 z) {
668         if (y > 3) {
669             z = y;
670             uint256 x = y / 2 + 1;
671             while (x < z) {
672                 z = x;
673                 x = (y / x + x) / 2;
674             }
675         } else if (y != 0) {
676             z = 1;
677         }
678         // else z = 0
679     }
680 }
681 
682 /**
683  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
684  * the optional functions; to access them see {ERC20Detailed}.
685  */
686 interface IERC20 {
687     /**
688      * @dev Returns the number of decimals.
689      */
690     function decimals() external view returns (uint256);
691 
692     /**
693      * @dev Returns the amount of tokens in existence.
694      */
695     function totalSupply() external view returns (uint256);
696 
697     /**
698      * @dev Returns the amount of tokens owned by `account`.
699      */
700     function balanceOf(address account) external view returns (uint256);
701 
702     /**
703      * @dev Moves `amount` tokens from the caller's account to `recipient`.
704      *
705      * Returns a boolean value indicating whether the operation succeeded.
706      *
707      * Emits a {Transfer} event.
708      */
709     function transfer(address recipient, uint256 amount)
710         external
711         returns (bool);
712 
713     /**
714      * @dev Returns the remaining number of tokens that `spender` will be
715      * allowed to spend on behalf of `owner` through {transferFrom}. This is
716      * zero by default.
717      *
718      * This value changes when {approve} or {transferFrom} are called.
719      */
720     function allowance(address owner, address spender)
721         external
722         view
723         returns (uint256);
724 
725     /**
726      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
727      *
728      * Returns a boolean value indicating whether the operation succeeded.
729      *
730      * IMPORTANT: Beware that changing an allowance with this method brings the risk
731      * that someone may use both the old and the new allowance by unfortunate
732      * transaction ordering. One possible solution to mitigate this race
733      * condition is to first reduce the spender's allowance to 0 and set the
734      * desired value afterwards:
735      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
736      *
737      * Emits an {Approval} event.
738      */
739     function approve(address spender, uint256 amount) external returns (bool);
740 
741     /**
742      * @dev Moves `amount` tokens from `sender` to `recipient` using the
743      * allowance mechanism. `amount` is then deducted from the caller's
744      * allowance.
745      *
746      * Returns a boolean value indicating whether the operation succeeded.
747      *
748      * Emits a {Transfer} event.
749      */
750     function transferFrom(
751         address sender,
752         address recipient,
753         uint256 amount
754     ) external returns (bool);
755 
756     /**
757      * @dev Emitted when `value` tokens are moved from one account (`from`) to
758      * another (`to`).
759      *
760      * Note that `value` may be zero.
761      */
762     event Transfer(address indexed from, address indexed to, uint256 value);
763 
764     /**
765      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
766      * a call to {approve}. `value` is the new allowance.
767      */
768     event Approval(
769         address indexed owner,
770         address indexed spender,
771         uint256 value
772     );
773 }
774 
775 interface IWETH {
776     function deposit() external payable;
777 
778     function transfer(address to, uint256 value) external returns (bool);
779 
780     function withdraw(uint256) external;
781 }
782 
783 interface IUniswapV1Factory {
784     function getExchange(address token)
785         external
786         view
787         returns (address exchange);
788 }
789 
790 interface IUniswapV2Factory {
791     function getPair(address tokenA, address tokenB)
792         external
793         view
794         returns (address);
795 }
796 
797 interface IUniswapExchange {
798     // converting ERC20 to ERC20 and transfer
799     function tokenToTokenTransferInput(
800         uint256 tokens_sold,
801         uint256 min_tokens_bought,
802         uint256 min_eth_bought,
803         uint256 deadline,
804         address recipient,
805         address token_addr
806     ) external returns (uint256 tokens_bought);
807 
808     function tokenToTokenSwapInput(
809         uint256 tokens_sold,
810         uint256 min_tokens_bought,
811         uint256 min_eth_bought,
812         uint256 deadline,
813         address token_addr
814     ) external returns (uint256 tokens_bought);
815 
816     function getEthToTokenInputPrice(uint256 eth_sold)
817         external
818         view
819         returns (uint256 tokens_bought);
820 
821     function getTokenToEthInputPrice(uint256 tokens_sold)
822         external
823         view
824         returns (uint256 eth_bought);
825 
826     function tokenToEthTransferInput(
827         uint256 tokens_sold,
828         uint256 min_eth,
829         uint256 deadline,
830         address recipient
831     ) external returns (uint256 eth_bought);
832 
833     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline)
834         external
835         payable
836         returns (uint256 tokens_bought);
837 
838     function ethToTokenTransferInput(
839         uint256 min_tokens,
840         uint256 deadline,
841         address recipient
842     ) external payable returns (uint256 tokens_bought);
843 
844     function balanceOf(address _owner) external view returns (uint256);
845 
846     function transfer(address _to, uint256 _value) external returns (bool);
847 
848     function transferFrom(
849         address from,
850         address to,
851         uint256 tokens
852     ) external returns (bool success);
853 }
854 
855 interface IUniswapV2Pair {
856     function token0() external pure returns (address);
857 
858     function token1() external pure returns (address);
859 
860     function getReserves()
861         external
862         view
863         returns (
864             uint112 _reserve0,
865             uint112 _reserve1,
866             uint32 _blockTimestampLast
867         );
868 }
869 
870 contract UniswapV2_ZapIn is ReentrancyGuard, Ownable {
871     using SafeMath for uint256;
872     using Address for address;
873     bool private stopped = false;
874     uint16 public goodwill;
875     address public dzgoodwillAddress;
876     uint256 public defaultSlippage;
877 
878     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(
879         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
880     );
881 
882     IUniswapV1Factory public UniSwapV1FactoryAddress = IUniswapV1Factory(
883         0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95
884     );
885 
886     IUniswapV2Factory public UniSwapV2FactoryAddress = IUniswapV2Factory(
887         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
888     );
889 
890     address wethTokenAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
891 
892     constructor(
893         uint16 _goodwill,
894         address _dzgoodwillAddress,
895         uint256 _slippage
896     ) public {
897         goodwill = _goodwill;
898         dzgoodwillAddress = _dzgoodwillAddress;
899         defaultSlippage = _slippage;
900     }
901 
902     // circuit breaker modifiers
903     modifier stopInEmergency {
904         if (stopped) {
905             revert("Temporarily Paused");
906         } else {
907             _;
908         }
909     }
910 
911     /**
912     @notice This function is used to invest in given Uniswap V2 pair through ETH/ERC20 Tokens
913     @param _FromTokenContractAddress The ERC20 token used for investment (address(0x00) if ether)
914     @param _ToUnipoolToken0 The Uniswap V2 pair token0 address
915     @param _ToUnipoolToken1 The Uniswap V2 pair token1 address
916     @param _amount The amount of fromToken to invest
917     @param slippage Slippage user wants
918     @return Amount of LP bought
919      */
920     function ZapIn(
921         address _FromTokenContractAddress,
922         address _ToUnipoolToken0,
923         address _ToUnipoolToken1,
924         uint256 _amount,
925         uint256 slippage
926     ) public payable nonReentrant stopInEmergency returns (uint256) {
927         uint256 toInvest;
928         if (_FromTokenContractAddress == address(0)) {
929             require(msg.value > 0, "Error: ETH not sent");
930             toInvest = msg.value;
931         } else {
932             require(msg.value == 0, "Error: ETH sent");
933             require(_amount > 0, "Error: Invalid ERC amount");
934             TransferHelper.safeTransferFrom(
935                 _FromTokenContractAddress,
936                 msg.sender,
937                 address(this),
938                 _amount
939             );
940             toInvest = _amount;
941         }
942 
943         uint256 withSlippage = slippage > 0 && slippage < 10000
944             ? slippage
945             : defaultSlippage;
946 
947         uint256 LPBought = _performZapIn(
948             _FromTokenContractAddress,
949             _ToUnipoolToken0,
950             _ToUnipoolToken1,
951             toInvest,
952             withSlippage
953         );
954 
955         //get pair address
956         address _ToUniPoolAddress = UniSwapV2FactoryAddress.getPair(
957             _ToUnipoolToken0,
958             _ToUnipoolToken1
959         );
960 
961         //transfer goodwill
962         uint256 goodwillPortion = _transferGoodwill(
963             _ToUniPoolAddress,
964             LPBought
965         );
966 
967         TransferHelper.safeTransfer(
968             _ToUniPoolAddress,
969             msg.sender,
970             SafeMath.sub(LPBought, goodwillPortion)
971         );
972         return SafeMath.sub(LPBought, goodwillPortion);
973     }
974 
975     function _performZapIn(
976         address _FromTokenContractAddress,
977         address _ToUnipoolToken0,
978         address _ToUnipoolToken1,
979         uint256 _amount,
980         uint256 slippage
981     ) internal returns (uint256) {
982         uint256 token0Bought;
983         uint256 token1Bought;
984 
985         if (canSwapFromV2(_ToUnipoolToken0, _ToUnipoolToken1)) {
986             (token0Bought, token1Bought) = exchangeTokensV2(
987                 _FromTokenContractAddress,
988                 _ToUnipoolToken0,
989                 _ToUnipoolToken1,
990                 _amount,
991                 slippage
992             );
993         } else if (
994             canSwapFromV1(_ToUnipoolToken0, _ToUnipoolToken1, _amount, _amount)
995         ) {
996             (token0Bought, token1Bought) = exchangeTokensV1(
997                 _FromTokenContractAddress,
998                 _ToUnipoolToken0,
999                 _ToUnipoolToken1,
1000                 _amount,
1001                 slippage
1002             );
1003         }
1004 
1005         require(token0Bought > 0 && token0Bought > 0, "Could not exchange");
1006 
1007         TransferHelper.safeApprove(
1008             _ToUnipoolToken0,
1009             address(uniswapV2Router),
1010             token0Bought
1011         );
1012 
1013         TransferHelper.safeApprove(
1014             _ToUnipoolToken1,
1015             address(uniswapV2Router),
1016             token1Bought
1017         );
1018 
1019         (uint256 amountA, uint256 amountB, uint256 LP) = uniswapV2Router
1020             .addLiquidity(
1021             _ToUnipoolToken0,
1022             _ToUnipoolToken1,
1023             token0Bought,
1024             token1Bought,
1025             1,
1026             1,
1027             address(this),
1028             now + 60
1029         );
1030 
1031         uint256 residue;
1032         if (SafeMath.sub(token0Bought, amountA) > 0) {
1033             if (canSwapFromV2(_ToUnipoolToken0, _FromTokenContractAddress)) {
1034                 residue = swapFromV2(
1035                     _ToUnipoolToken0,
1036                     _FromTokenContractAddress,
1037                     SafeMath.sub(token0Bought, amountA),
1038                     10000
1039                 );
1040             } else {
1041                 TransferHelper.safeTransfer(
1042                     _ToUnipoolToken0,
1043                     msg.sender,
1044                     SafeMath.sub(token0Bought, amountA)
1045                 );
1046             }
1047         }
1048 
1049         if (SafeMath.sub(token1Bought, amountB) > 0) {
1050             if (canSwapFromV2(_ToUnipoolToken1, _FromTokenContractAddress)) {
1051                 residue += swapFromV2(
1052                     _ToUnipoolToken1,
1053                     _FromTokenContractAddress,
1054                     SafeMath.sub(token1Bought, amountB),
1055                     10000
1056                 );
1057             } else {
1058                 TransferHelper.safeTransfer(
1059                     _ToUnipoolToken1,
1060                     msg.sender,
1061                     SafeMath.sub(token1Bought, amountB)
1062                 );
1063             }
1064         }
1065 
1066         if (residue > 0) {
1067             TransferHelper.safeTransfer(
1068                 _FromTokenContractAddress,
1069                 msg.sender,
1070                 residue
1071             );
1072         }
1073 
1074         return LP;
1075     }
1076 
1077     function exchangeTokensV1(
1078         address _FromTokenContractAddress,
1079         address _ToUnipoolToken0,
1080         address _ToUnipoolToken1,
1081         uint256 _amount,
1082         uint256 slippage
1083     ) internal returns (uint256 token0Bought, uint256 token1Bought) {
1084         IUniswapV2Pair pair = IUniswapV2Pair(
1085             UniSwapV2FactoryAddress.getPair(_ToUnipoolToken0, _ToUnipoolToken1)
1086         );
1087         (uint256 res0, uint256 res1, ) = pair.getReserves();
1088         if (_FromTokenContractAddress == address(0)) {
1089             token0Bought = _eth2Token(_ToUnipoolToken0, _amount, slippage);
1090             uint256 amountToSwap = calculateSwapInAmount(res0, token0Bought);
1091             //if no reserve or a new pair is created
1092             if (amountToSwap <= 0) amountToSwap = SafeMath.div(token0Bought, 2);
1093             token1Bought = _eth2Token(_ToUnipoolToken1, amountToSwap, slippage);
1094             token0Bought = SafeMath.sub(token0Bought, amountToSwap);
1095         } else {
1096             if (_ToUnipoolToken0 == _FromTokenContractAddress) {
1097                 uint256 amountToSwap = calculateSwapInAmount(res0, _amount);
1098                 //if no reserve or a new pair is created
1099                 if (amountToSwap <= 0) amountToSwap = SafeMath.div(_amount, 2);
1100                 token1Bought = _token2Token(
1101                     _FromTokenContractAddress,
1102                     address(this),
1103                     _ToUnipoolToken1,
1104                     amountToSwap,
1105                     slippage
1106                 );
1107 
1108                 token0Bought = SafeMath.sub(_amount, amountToSwap);
1109             } else if (_ToUnipoolToken1 == _FromTokenContractAddress) {
1110                 uint256 amountToSwap = calculateSwapInAmount(res1, _amount);
1111                 //if no reserve or a new pair is created
1112                 if (amountToSwap <= 0) amountToSwap = SafeMath.div(_amount, 2);
1113                 token0Bought = _token2Token(
1114                     _FromTokenContractAddress,
1115                     address(this),
1116                     _ToUnipoolToken0,
1117                     amountToSwap,
1118                     slippage
1119                 );
1120 
1121                 token1Bought = SafeMath.sub(_amount, amountToSwap);
1122             } else {
1123                 token0Bought = _token2Token(
1124                     _FromTokenContractAddress,
1125                     address(this),
1126                     _ToUnipoolToken0,
1127                     _amount,
1128                     slippage
1129                 );
1130                 uint256 amountToSwap = calculateSwapInAmount(
1131                     res0,
1132                     token0Bought
1133                 );
1134                 //if no reserve or a new pair is created
1135                 if (amountToSwap <= 0) amountToSwap = SafeMath.div(_amount, 2);
1136 
1137                 token1Bought = _token2Token(
1138                     _FromTokenContractAddress,
1139                     address(this),
1140                     _ToUnipoolToken1,
1141                     amountToSwap,
1142                     slippage
1143                 );
1144                 token0Bought = SafeMath.sub(token0Bought, amountToSwap);
1145             }
1146         }
1147     }
1148 
1149     function exchangeTokensV2(
1150         address _FromTokenContractAddress,
1151         address _ToUnipoolToken0,
1152         address _ToUnipoolToken1,
1153         uint256 _amount,
1154         uint256 slippage
1155     ) internal returns (uint256 token0Bought, uint256 token1Bought) {
1156         IUniswapV2Pair pair = IUniswapV2Pair(
1157             UniSwapV2FactoryAddress.getPair(_ToUnipoolToken0, _ToUnipoolToken1)
1158         );
1159         (uint256 res0, uint256 res1, ) = pair.getReserves();
1160         if (
1161             canSwapFromV2(_FromTokenContractAddress, _ToUnipoolToken0) &&
1162             canSwapFromV2(_ToUnipoolToken0, _ToUnipoolToken1)
1163         ) {
1164             token0Bought = swapFromV2(
1165                 _FromTokenContractAddress,
1166                 _ToUnipoolToken0,
1167                 _amount,
1168                 slippage
1169             );
1170             uint256 amountToSwap = calculateSwapInAmount(res0, token0Bought);
1171             //if no reserve or a new pair is created
1172             if (amountToSwap <= 0) amountToSwap = SafeMath.div(token0Bought, 2);
1173             token1Bought = swapFromV2(
1174                 _ToUnipoolToken0,
1175                 _ToUnipoolToken1,
1176                 amountToSwap,
1177                 slippage
1178             );
1179             token0Bought = SafeMath.sub(token0Bought, amountToSwap);
1180         } else if (
1181             canSwapFromV2(_FromTokenContractAddress, _ToUnipoolToken1) &&
1182             canSwapFromV2(_ToUnipoolToken0, _ToUnipoolToken1)
1183         ) {
1184             token1Bought = swapFromV2(
1185                 _FromTokenContractAddress,
1186                 _ToUnipoolToken1,
1187                 _amount,
1188                 slippage
1189             );
1190             uint256 amountToSwap = calculateSwapInAmount(res1, token1Bought);
1191             //if no reserve or a new pair is created
1192             if (amountToSwap <= 0) amountToSwap = SafeMath.div(token1Bought, 2);
1193             token0Bought = swapFromV2(
1194                 _ToUnipoolToken1,
1195                 _ToUnipoolToken0,
1196                 amountToSwap,
1197                 slippage
1198             );
1199             token1Bought = SafeMath.sub(token1Bought, amountToSwap);
1200         }
1201     }
1202 
1203     //checks if tokens can be exchanged with UniV1
1204     function canSwapFromV1(
1205         address _fromToken,
1206         address _toToken,
1207         uint256 fromAmount,
1208         uint256 toAmount
1209     ) public view returns (bool) {
1210         require(
1211             _fromToken != address(0) || _toToken != address(0),
1212             "Invalid Exchange values"
1213         );
1214 
1215         if (_fromToken == address(0)) {
1216             IUniswapExchange toExchange = IUniswapExchange(
1217                 UniSwapV1FactoryAddress.getExchange(_toToken)
1218             );
1219             uint256 tokenBalance = IERC20(_toToken).balanceOf(
1220                 address(toExchange)
1221             );
1222             uint256 ethBalance = address(toExchange).balance;
1223             if (tokenBalance > toAmount && ethBalance > fromAmount) return true;
1224         } else if (_toToken == address(0)) {
1225             IUniswapExchange fromExchange = IUniswapExchange(
1226                 UniSwapV1FactoryAddress.getExchange(_fromToken)
1227             );
1228             uint256 tokenBalance = IERC20(_fromToken).balanceOf(
1229                 address(fromExchange)
1230             );
1231             uint256 ethBalance = address(fromExchange).balance;
1232             if (tokenBalance > fromAmount && ethBalance > toAmount) return true;
1233         } else {
1234             IUniswapExchange toExchange = IUniswapExchange(
1235                 UniSwapV1FactoryAddress.getExchange(_toToken)
1236             );
1237             IUniswapExchange fromExchange = IUniswapExchange(
1238                 UniSwapV1FactoryAddress.getExchange(_fromToken)
1239             );
1240             uint256 balance1 = IERC20(_fromToken).balanceOf(
1241                 address(fromExchange)
1242             );
1243             uint256 balance2 = IERC20(_toToken).balanceOf(address(toExchange));
1244             if (balance1 > fromAmount && balance2 > toAmount) return true;
1245         }
1246         return false;
1247     }
1248 
1249     //checks if tokens can be exchanged with UniV2
1250     function canSwapFromV2(address _fromToken, address _toToken)
1251         public
1252         view
1253         returns (bool)
1254     {
1255         require(
1256             _fromToken != address(0) || _toToken != address(0),
1257             "Invalid Exchange values"
1258         );
1259 
1260         if (_fromToken == _toToken) return true;
1261 
1262         if (_fromToken == address(0) || _fromToken == wethTokenAddress) {
1263             if (_toToken == wethTokenAddress || _toToken == address(0))
1264                 return true;
1265             IUniswapV2Pair pair = IUniswapV2Pair(
1266                 UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1267             );
1268             if (_haveReserve(pair)) return true;
1269         } else if (_toToken == address(0) || _toToken == wethTokenAddress) {
1270             if (_fromToken == wethTokenAddress || _fromToken == address(0))
1271                 return true;
1272             IUniswapV2Pair pair = IUniswapV2Pair(
1273                 UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1274             );
1275             if (_haveReserve(pair)) return true;
1276         } else {
1277             IUniswapV2Pair pair1 = IUniswapV2Pair(
1278                 UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1279             );
1280             IUniswapV2Pair pair2 = IUniswapV2Pair(
1281                 UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1282             );
1283             IUniswapV2Pair pair3 = IUniswapV2Pair(
1284                 UniSwapV2FactoryAddress.getPair(_fromToken, _toToken)
1285             );
1286             if (_haveReserve(pair1) && _haveReserve(pair2)) return true;
1287             if (_haveReserve(pair3)) return true;
1288         }
1289         return false;
1290     }
1291 
1292     //checks if the UNI v2 contract have reserves to swap tokens
1293     function _haveReserve(IUniswapV2Pair pair) internal view returns (bool) {
1294         if (address(pair) != address(0)) {
1295             (uint256 res0, uint256 res1, ) = pair.getReserves();
1296             if (res0 > 0 && res1 > 0) {
1297                 return true;
1298             }
1299         }
1300     }
1301 
1302     function calculateSwapInAmount(uint256 reserveIn, uint256 userIn)
1303         public
1304         pure
1305         returns (uint256)
1306     {
1307         return
1308             Babylonian
1309                 .sqrt(
1310                 reserveIn.mul(userIn.mul(3988000) + reserveIn.mul(3988009))
1311             )
1312                 .sub(reserveIn.mul(1997)) / 1994;
1313     }
1314 
1315     //swaps _fromToken for _toToken
1316     //for eth, address(0) otherwise ERC token address
1317     function swapFromV2(
1318         address _fromToken,
1319         address _toToken,
1320         uint256 amount,
1321         uint256 slippage
1322     ) internal returns (uint256) {
1323         require(
1324             _fromToken != address(0) || _toToken != address(0),
1325             "Invalid Exchange values"
1326         );
1327         if (_fromToken == _toToken) return amount;
1328 
1329         require(canSwapFromV2(_fromToken, _toToken), "Cannot be exchanged");
1330         require(amount > 0, "Invalid amount");
1331 
1332         if (_fromToken == address(0)) {
1333             if (_toToken == wethTokenAddress) {
1334                 IWETH(wethTokenAddress).deposit.value(amount)();
1335                 return amount;
1336             }
1337             address[] memory path = new address[](2);
1338             path[0] = wethTokenAddress;
1339             path[1] = _toToken;
1340             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1341             minTokens = SafeMath.div(
1342                 SafeMath.mul(minTokens, SafeMath.sub(10000, slippage)),
1343                 10000
1344             );
1345             uint256[] memory amounts = uniswapV2Router
1346                 .swapExactETHForTokens
1347                 .value(amount)(minTokens, path, address(this), now + 180);
1348             return amounts[1];
1349         } else if (_toToken == address(0)) {
1350             if (_fromToken == wethTokenAddress) {
1351                 IWETH(wethTokenAddress).withdraw(amount);
1352                 return amount;
1353             }
1354             address[] memory path = new address[](2);
1355             TransferHelper.safeApprove(
1356                 _fromToken,
1357                 address(uniswapV2Router),
1358                 amount
1359             );
1360             path[0] = _fromToken;
1361             path[1] = wethTokenAddress;
1362             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1363             minTokens = SafeMath.div(
1364                 SafeMath.mul(minTokens, SafeMath.sub(10000, slippage)),
1365                 10000
1366             );
1367             uint256[] memory amounts = uniswapV2Router.swapExactTokensForETH(
1368                 amount,
1369                 minTokens,
1370                 path,
1371                 address(this),
1372                 now + 180
1373             );
1374             return amounts[1];
1375         } else {
1376             TransferHelper.safeApprove(
1377                 _fromToken,
1378                 address(uniswapV2Router),
1379                 amount
1380             );
1381             uint256 returnedAmount = _swapTokenToTokenV2(
1382                 _fromToken,
1383                 _toToken,
1384                 amount,
1385                 slippage
1386             );
1387             require(returnedAmount > 0, "Error in swap");
1388             return returnedAmount;
1389         }
1390     }
1391 
1392     //swaps 2 ERC tokens (UniV2)
1393     function _swapTokenToTokenV2(
1394         address _fromToken,
1395         address _toToken,
1396         uint256 amount,
1397         uint256 slippage
1398     ) internal returns (uint256) {
1399         IUniswapV2Pair pair1 = IUniswapV2Pair(
1400             UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1401         );
1402         IUniswapV2Pair pair2 = IUniswapV2Pair(
1403             UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1404         );
1405         IUniswapV2Pair pair3 = IUniswapV2Pair(
1406             UniSwapV2FactoryAddress.getPair(_fromToken, _toToken)
1407         );
1408 
1409         uint256[] memory amounts;
1410 
1411         if (_haveReserve(pair3)) {
1412             address[] memory path = new address[](2);
1413             path[0] = _fromToken;
1414             path[1] = _toToken;
1415             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1416             minTokens = SafeMath.div(
1417                 SafeMath.mul(minTokens, SafeMath.sub(10000, slippage)),
1418                 10000
1419             );
1420             amounts = uniswapV2Router.swapExactTokensForTokens(
1421                 amount,
1422                 minTokens,
1423                 path,
1424                 address(this),
1425                 now + 180
1426             );
1427             return amounts[1];
1428         } else if (_haveReserve(pair1) && _haveReserve(pair2)) {
1429             address[] memory path = new address[](3);
1430             path[0] = _fromToken;
1431             path[1] = wethTokenAddress;
1432             path[2] = _toToken;
1433             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[2];
1434             minTokens = SafeMath.div(
1435                 SafeMath.mul(minTokens, SafeMath.sub(10000, slippage)),
1436                 10000
1437             );
1438             amounts = uniswapV2Router.swapExactTokensForTokens(
1439                 amount,
1440                 minTokens,
1441                 path,
1442                 address(this),
1443                 now + 180
1444             );
1445             return amounts[2];
1446         }
1447         return 0;
1448     }
1449 
1450     /**
1451     @notice This function is used to buy tokens from eth
1452     @param _tokenContractAddress Token address which we want to buy
1453     @param _amount The amount of eth we want to exchange
1454     @return The quantity of token bought
1455      */
1456     function _eth2Token(
1457         address _tokenContractAddress,
1458         uint256 _amount,
1459         uint256 slippage
1460     ) internal returns (uint256 tokenBought) {
1461         IUniswapExchange FromUniSwapExchangeContractAddress = IUniswapExchange(
1462             UniSwapV1FactoryAddress.getExchange(_tokenContractAddress)
1463         );
1464 
1465         uint256 minTokenBought = FromUniSwapExchangeContractAddress
1466             .getEthToTokenInputPrice(_amount);
1467         minTokenBought = SafeMath.div(
1468             SafeMath.mul(minTokenBought, SafeMath.sub(10000, slippage)),
1469             10000
1470         );
1471 
1472         tokenBought = FromUniSwapExchangeContractAddress
1473             .ethToTokenSwapInput
1474             .value(_amount)(minTokenBought, SafeMath.add(now, 300));
1475     }
1476 
1477     /**
1478     @notice This function is used to swap token with ETH
1479     @param _FromTokenContractAddress The token address to swap from
1480     @param tokens2Trade The quantity of tokens to swap
1481     @return The amount of eth bought
1482      */
1483     function _token2Eth(
1484         address _FromTokenContractAddress,
1485         uint256 tokens2Trade,
1486         address _toWhomToIssue,
1487         uint256 slippage
1488     ) internal returns (uint256 ethBought) {
1489         IUniswapExchange FromUniSwapExchangeContractAddress = IUniswapExchange(
1490             UniSwapV1FactoryAddress.getExchange(_FromTokenContractAddress)
1491         );
1492 
1493         TransferHelper.safeApprove(
1494             _FromTokenContractAddress,
1495             address(FromUniSwapExchangeContractAddress),
1496             tokens2Trade
1497         );
1498 
1499         uint256 minEthBought = FromUniSwapExchangeContractAddress
1500             .getTokenToEthInputPrice(tokens2Trade);
1501         minEthBought = SafeMath.div(
1502             SafeMath.mul(minEthBought, SafeMath.sub(10000, slippage)),
1503             10000
1504         );
1505 
1506         ethBought = FromUniSwapExchangeContractAddress.tokenToEthTransferInput(
1507             tokens2Trade,
1508             minEthBought,
1509             SafeMath.add(now, 300),
1510             _toWhomToIssue
1511         );
1512         require(ethBought > 0, "Error in swapping Eth: 1");
1513     }
1514 
1515     /**
1516     @notice This function is used to swap tokens
1517     @param _FromTokenContractAddress The token address to swap from
1518     @param _ToWhomToIssue The address to transfer after swap
1519     @param _ToTokenContractAddress The token address to swap to
1520     @param tokens2Trade The quantity of tokens to swap
1521     @return The amount of tokens returned after swap
1522      */
1523     function _token2Token(
1524         address _FromTokenContractAddress,
1525         address _ToWhomToIssue,
1526         address _ToTokenContractAddress,
1527         uint256 tokens2Trade,
1528         uint256 slippage
1529     ) internal returns (uint256 tokenBought) {
1530         IUniswapExchange FromUniSwapExchangeContractAddress = IUniswapExchange(
1531             UniSwapV1FactoryAddress.getExchange(_FromTokenContractAddress)
1532         );
1533 
1534         TransferHelper.safeApprove(
1535             _FromTokenContractAddress,
1536             address(FromUniSwapExchangeContractAddress),
1537             tokens2Trade
1538         );
1539 
1540         uint256 minEthBought = FromUniSwapExchangeContractAddress
1541             .getTokenToEthInputPrice(tokens2Trade);
1542         minEthBought = SafeMath.div(
1543             SafeMath.mul(minEthBought, SafeMath.sub(10000, slippage)),
1544             10000
1545         );
1546 
1547         uint256 minTokenBought = FromUniSwapExchangeContractAddress
1548             .getEthToTokenInputPrice(minEthBought);
1549         minTokenBought = SafeMath.div(
1550             SafeMath.mul(minTokenBought, SafeMath.sub(10000, slippage)),
1551             10000
1552         );
1553 
1554         tokenBought = FromUniSwapExchangeContractAddress
1555             .tokenToTokenTransferInput(
1556             tokens2Trade,
1557             minTokenBought,
1558             minEthBought,
1559             SafeMath.add(now, 300),
1560             _ToWhomToIssue,
1561             _ToTokenContractAddress
1562         );
1563         require(tokenBought > 0, "Error in swapping ERC: 1");
1564     }
1565 
1566     /**
1567     @notice This function is used to calculate and transfer goodwill
1568     @param _tokenContractAddress Token in which goodwill is deducted
1569     @param tokens2Trade The total amount of tokens to be zapped in
1570     @return The quantity of goodwill deducted
1571      */
1572     function _transferGoodwill(
1573         address _tokenContractAddress,
1574         uint256 tokens2Trade
1575     ) internal returns (uint256 goodwillPortion) {
1576         goodwillPortion = SafeMath.div(
1577             SafeMath.mul(tokens2Trade, goodwill),
1578             10000
1579         );
1580 
1581         if (goodwillPortion == 0) {
1582             return 0;
1583         }
1584 
1585         TransferHelper.safeTransfer(
1586             _tokenContractAddress,
1587             dzgoodwillAddress,
1588             goodwillPortion
1589         );
1590     }
1591 
1592     function updateSlippage(uint256 _newSlippage) public onlyOwner {
1593         require(
1594             _newSlippage > 0 && _newSlippage < 10000,
1595             "Slippage Value not allowed"
1596         );
1597         defaultSlippage = _newSlippage;
1598     }
1599 
1600     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1601         require(
1602             _new_goodwill >= 0 && _new_goodwill < 10000,
1603             "GoodWill Value not allowed"
1604         );
1605         goodwill = _new_goodwill;
1606     }
1607 
1608     function set_new_dzgoodwillAddress(address _new_dzgoodwillAddress)
1609         public
1610         onlyOwner
1611     {
1612         dzgoodwillAddress = _new_dzgoodwillAddress;
1613     }
1614 
1615     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1616         uint256 qty = _TokenAddress.balanceOf(address(this));
1617         TransferHelper.safeTransfer(address(_TokenAddress), owner(), qty);
1618     }
1619 
1620     // - to Pause the contract
1621     function toggleContractActive() public onlyOwner {
1622         stopped = !stopped;
1623     }
1624 
1625     // - to withdraw any ETH balance sitting in the contract
1626     function withdraw() public onlyOwner {
1627         uint256 contractBalance = address(this).balance;
1628         address payable _to = owner().toPayable();
1629         _to.transfer(contractBalance);
1630     }
1631 
1632     // - to kill the contract
1633     function destruct() public onlyOwner {
1634         address payable _to = owner().toPayable();
1635         selfdestruct(_to);
1636     }
1637 
1638     function() external payable {}
1639 }