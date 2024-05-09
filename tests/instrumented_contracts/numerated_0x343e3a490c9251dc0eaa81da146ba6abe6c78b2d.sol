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
59     function sub(
60         uint256 a,
61         uint256 b,
62         string memory errorMessage
63     ) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
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
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      *
119      * _Available since v2.4.0._
120      */
121     function div(
122         uint256 a,
123         uint256 b,
124         string memory errorMessage
125     ) internal pure returns (uint256) {
126         // Solidity only automatically asserts when dividing by 0
127         require(b > 0, errorMessage);
128         uint256 c = a / b;
129         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136      * Reverts when dividing by zero.
137      *
138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
139      * opcode (which leaves remaining gas untouched) while Solidity uses an
140      * invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         return mod(a, b, "SafeMath: modulo by zero");
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * Reverts with custom message when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      * - The divisor cannot be zero.
159      *
160      * _Available since v2.4.0._
161      */
162     function mod(
163         uint256 a,
164         uint256 b,
165         string memory errorMessage
166     ) internal pure returns (uint256) {
167         require(b != 0, errorMessage);
168         return a % b;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/GSN/Context.sol
173 
174 pragma solidity ^0.5.0;
175 
176 /*
177  * @dev Provides information about the current execution context, including the
178  * sender of the transaction and its data. While these are generally available
179  * via msg.sender and msg.data, they should not be accessed in such a direct
180  * manner, since when dealing with GSN meta-transactions the account sending and
181  * paying for execution may not be the actual sender (as far as an application
182  * is concerned).
183  *
184  * This contract is only required for intermediate, library-like contracts.
185  */
186 contract Context {
187     // Empty internal constructor, to prevent people from mistakenly deploying
188     // an instance of this contract, which should be used via inheritance.
189     constructor() internal {}
190 
191     // solhint-disable-previous-line no-empty-blocks
192 
193     function _msgSender() internal view returns (address payable) {
194         return msg.sender;
195     }
196 
197     function _msgData() internal view returns (bytes memory) {
198         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
199         return msg.data;
200     }
201 }
202 
203 // File: @openzeppelin/contracts/ownership/Ownable.sol
204 
205 pragma solidity ^0.5.0;
206 
207 /**
208  * @dev Contract module which provides a basic access control mechanism, where
209  * there is an account (an owner) that can be granted exclusive access to
210  * specific functions.
211  *
212  * This module is used through inheritance. It will make available the modifier
213  * `onlyOwner`, which can be applied to your functions to restrict their use to
214  * the owner.
215  */
216 contract Ownable is Context {
217     address private _owner;
218 
219     event OwnershipTransferred(
220         address indexed previousOwner,
221         address indexed newOwner
222     );
223 
224     /**
225      * @dev Initializes the contract setting the deployer as the initial owner.
226      */
227     constructor() internal {
228         address msgSender = _msgSender();
229         _owner = msgSender;
230         emit OwnershipTransferred(address(0), msgSender);
231     }
232 
233     /**
234      * @dev Returns the address of the current owner.
235      */
236     function owner() public view returns (address) {
237         return _owner;
238     }
239 
240     /**
241      * @dev Throws if called by any account other than the owner.
242      */
243     modifier onlyOwner() {
244         require(isOwner(), "Ownable: caller is not the owner");
245         _;
246     }
247 
248     /**
249      * @dev Returns true if the caller is the current owner.
250      */
251     function isOwner() public view returns (bool) {
252         return _msgSender() == _owner;
253     }
254 
255     /**
256      * @dev Leaves the contract without owner. It will not be possible to call
257      * `onlyOwner` functions anymore. Can only be called by the current owner.
258      *
259      * NOTE: Renouncing ownership will leave the contract without an owner,
260      * thereby removing any functionality that is only available to the owner.
261      */
262     function renounceOwnership() public onlyOwner {
263         emit OwnershipTransferred(_owner, address(0));
264         _owner = address(0);
265     }
266 
267     /**
268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
269      * Can only be called by the current owner.
270      */
271     function transferOwnership(address newOwner) public onlyOwner {
272         _transferOwnership(newOwner);
273     }
274 
275     /**
276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
277      */
278     function _transferOwnership(address newOwner) internal {
279         require(
280             newOwner != address(0),
281             "Ownable: new owner is the zero address"
282         );
283         emit OwnershipTransferred(_owner, newOwner);
284         _owner = newOwner;
285     }
286 }
287 
288 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
289 
290 pragma solidity ^0.5.0;
291 
292 /**
293  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
294  * the optional functions; to access them see {ERC20Detailed}.
295  */
296 interface IERC20 {
297     /**
298      * @dev Returns the amount of tokens in existence.
299      */
300     function totalSupply() external view returns (uint256);
301 
302     /**
303      * @dev Returns the amount of tokens owned by `account`.
304      */
305     function balanceOf(address account) external view returns (uint256);
306 
307     /**
308      * @dev Moves `amount` tokens from the caller's account to `recipient`.
309      *
310      * Returns a boolean value indicating whether the operation succeeded.
311      *
312      * Emits a {Transfer} event.
313      */
314     function transfer(address recipient, uint256 amount)
315         external
316         returns (bool);
317 
318     /**
319      * @dev Returns the remaining number of tokens that `spender` will be
320      * allowed to spend on behalf of `owner` through {transferFrom}. This is
321      * zero by default.
322      *
323      * This value changes when {approve} or {transferFrom} are called.
324      */
325     function allowance(address owner, address spender)
326         external
327         view
328         returns (uint256);
329 
330     /**
331      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
332      *
333      * Returns a boolean value indicating whether the operation succeeded.
334      *
335      * IMPORTANT: Beware that changing an allowance with this method brings the risk
336      * that someone may use both the old and the new allowance by unfortunate
337      * transaction ordering. One possible solution to mitigate this race
338      * condition is to first reduce the spender's allowance to 0 and set the
339      * desired value afterwards:
340      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
341      *
342      * Emits an {Approval} event.
343      */
344     function approve(address spender, uint256 amount) external returns (bool);
345 
346     /**
347      * @dev Moves `amount` tokens from `sender` to `recipient` using the
348      * allowance mechanism. `amount` is then deducted from the caller's
349      * allowance.
350      *
351      * Returns a boolean value indicating whether the operation succeeded.
352      *
353      * Emits a {Transfer} event.
354      */
355     function transferFrom(
356         address sender,
357         address recipient,
358         uint256 amount
359     ) external returns (bool);
360 
361     /**
362      * @dev Emitted when `value` tokens are moved from one account (`from`) to
363      * another (`to`).
364      *
365      * Note that `value` may be zero.
366      */
367     event Transfer(address indexed from, address indexed to, uint256 value);
368 
369     /**
370      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
371      * a call to {approve}. `value` is the new allowance.
372      */
373     event Approval(
374         address indexed owner,
375         address indexed spender,
376         uint256 value
377     );
378 }
379 
380 // File: @openzeppelin/contracts/utils/Address.sol
381 
382 pragma solidity ^0.5.5;
383 
384 /**
385  * @dev Collection of functions related to the address type
386  */
387 library Address {
388     /**
389      * @dev Returns true if `account` is a contract.
390      *
391      * [IMPORTANT]
392      * ====
393      * It is unsafe to assume that an address for which this function returns
394      * false is an externally-owned account (EOA) and not a contract.
395      *
396      * Among others, `isContract` will return false for the following
397      * types of addresses:
398      *
399      *  - an externally-owned account
400      *  - a contract in construction
401      *  - an address where a contract will be created
402      *  - an address where a contract lived, but was destroyed
403      * ====
404      */
405     function isContract(address account) internal view returns (bool) {
406         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
407         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
408         // for accounts without code, i.e. `keccak256('')`
409         bytes32 codehash;
410 
411 
412             bytes32 accountHash
413          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
414         // solhint-disable-next-line no-inline-assembly
415         assembly {
416             codehash := extcodehash(account)
417         }
418         return (codehash != accountHash && codehash != 0x0);
419     }
420 
421     /**
422      * @dev Converts an `address` into `address payable`. Note that this is
423      * simply a type cast: the actual underlying value is not changed.
424      *
425      * _Available since v2.4.0._
426      */
427     function toPayable(address account)
428         internal
429         pure
430         returns (address payable)
431     {
432         return address(uint160(account));
433     }
434 
435     /**
436      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
437      * `recipient`, forwarding all available gas and reverting on errors.
438      *
439      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
440      * of certain opcodes, possibly making contracts go over the 2300 gas limit
441      * imposed by `transfer`, making them unable to receive funds via
442      * `transfer`. {sendValue} removes this limitation.
443      *
444      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
445      *
446      * IMPORTANT: because control is transferred to `recipient`, care must be
447      * taken to not create reentrancy vulnerabilities. Consider using
448      * {ReentrancyGuard} or the
449      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
450      *
451      * _Available since v2.4.0._
452      */
453     function sendValue(address payable recipient, uint256 amount) internal {
454         require(
455             address(this).balance >= amount,
456             "Address: insufficient balance"
457         );
458 
459         // solhint-disable-next-line avoid-call-value
460         (bool success, ) = recipient.call.value(amount)("");
461         require(
462             success,
463             "Address: unable to send value, recipient may have reverted"
464         );
465     }
466 }
467 
468 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
469 
470 pragma solidity ^0.5.0;
471 
472 /**
473  * @dev Contract module that helps prevent reentrant calls to a function.
474  *
475  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
476  * available, which can be applied to functions to make sure there are no nested
477  * (reentrant) calls to them.
478  *
479  * Note that because there is a single `nonReentrant` guard, functions marked as
480  * `nonReentrant` may not call one another. This can be worked around by making
481  * those functions `private`, and then adding `external` `nonReentrant` entry
482  * points to them.
483  *
484  * TIP: If you would like to learn more about reentrancy and alternative ways
485  * to protect against it, check out our blog post
486  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
487  *
488  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
489  * metering changes introduced in the Istanbul hardfork.
490  */
491 contract ReentrancyGuard {
492     bool private _notEntered;
493 
494     constructor() internal {
495         // Storing an initial non-zero value makes deployment a bit more
496         // expensive, but in exchange the refund on every call to nonReentrant
497         // will be lower in amount. Since refunds are capped to a percetange of
498         // the total transaction's gas, it is best to keep them low in cases
499         // like this one, to increase the likelihood of the full refund coming
500         // into effect.
501         _notEntered = true;
502     }
503 
504     /**
505      * @dev Prevents a contract from calling itself, directly or indirectly.
506      * Calling a `nonReentrant` function from another `nonReentrant`
507      * function is not supported. It is possible to prevent this from happening
508      * by making the `nonReentrant` function external, and make it call a
509      * `private` function that does the actual work.
510      */
511     modifier nonReentrant() {
512         // On the first call to nonReentrant, _notEntered will be true
513         require(_notEntered, "ReentrancyGuard: reentrant call");
514 
515         // Any calls to nonReentrant after this point will fail
516         _notEntered = false;
517 
518         _;
519 
520         // By storing the original value once again, a refund is triggered (see
521         // https://eips.ethereum.org/EIPS/eip-2200)
522         _notEntered = true;
523     }
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
527 
528 pragma solidity ^0.5.0;
529 
530 /**
531  * @title SafeERC20
532  * @dev Wrappers around ERC20 operations that throw on failure (when the token
533  * contract returns false). Tokens that return no value (and instead revert or
534  * throw on failure) are also supported, non-reverting calls are assumed to be
535  * successful.
536  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
537  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
538  */
539 library SafeERC20 {
540     using SafeMath for uint256;
541     using Address for address;
542 
543     function safeTransfer(
544         IERC20 token,
545         address to,
546         uint256 value
547     ) internal {
548         callOptionalReturn(
549             token,
550             abi.encodeWithSelector(token.transfer.selector, to, value)
551         );
552     }
553 
554     function safeTransferFrom(
555         IERC20 token,
556         address from,
557         address to,
558         uint256 value
559     ) internal {
560         callOptionalReturn(
561             token,
562             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
563         );
564     }
565 
566     function safeApprove(
567         IERC20 token,
568         address spender,
569         uint256 value
570     ) internal {
571         // safeApprove should only be called when setting an initial allowance,
572         // or when resetting it to zero. To increase and decrease it, use
573         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
574         // solhint-disable-next-line max-line-length
575         require(
576             (value == 0) || (token.allowance(address(this), spender) == 0),
577             "SafeERC20: approve from non-zero to non-zero allowance"
578         );
579         callOptionalReturn(
580             token,
581             abi.encodeWithSelector(token.approve.selector, spender, value)
582         );
583     }
584 
585     function safeIncreaseAllowance(
586         IERC20 token,
587         address spender,
588         uint256 value
589     ) internal {
590         uint256 newAllowance = token.allowance(address(this), spender).add(
591             value
592         );
593         callOptionalReturn(
594             token,
595             abi.encodeWithSelector(
596                 token.approve.selector,
597                 spender,
598                 newAllowance
599             )
600         );
601     }
602 
603     function safeDecreaseAllowance(
604         IERC20 token,
605         address spender,
606         uint256 value
607     ) internal {
608         uint256 newAllowance = token.allowance(address(this), spender).sub(
609             value,
610             "SafeERC20: decreased allowance below zero"
611         );
612         callOptionalReturn(
613             token,
614             abi.encodeWithSelector(
615                 token.approve.selector,
616                 spender,
617                 newAllowance
618             )
619         );
620     }
621 
622     /**
623      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
624      * on the return value: the return value is optional (but if data is returned, it must not be false).
625      * @param token The token targeted by the call.
626      * @param data The call data (encoded using abi.encode or one of its variants).
627      */
628     function callOptionalReturn(IERC20 token, bytes memory data) private {
629         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
630         // we're implementing it ourselves.
631 
632         // A Solidity high level call has three parts:
633         //  1. The target address is checked to verify it contains contract code
634         //  2. The call itself is made, and success asserted
635         //  3. The return value is decoded, which in turn checks the size of the returned data.
636         // solhint-disable-next-line max-line-length
637         require(address(token).isContract(), "SafeERC20: call to non-contract");
638 
639         // solhint-disable-next-line avoid-low-level-calls
640         (bool success, bytes memory returndata) = address(token).call(data);
641         require(success, "SafeERC20: low-level call failed");
642 
643         if (returndata.length > 0) {
644             // Return data is optional
645             // solhint-disable-next-line max-line-length
646             require(
647                 abi.decode(returndata, (bool)),
648                 "SafeERC20: ERC20 operation did not succeed"
649             );
650         }
651     }
652 }
653 
654 // File: contracts/UniswapV2/UniswapV2Router.sol
655 
656 pragma solidity 0.5.12;
657 
658 interface IUniswapV2Router02 {
659     function factory() external pure returns (address);
660 
661     function WETH() external pure returns (address);
662 
663     function addLiquidity(
664         address tokenA,
665         address tokenB,
666         uint256 amountADesired,
667         uint256 amountBDesired,
668         uint256 amountAMin,
669         uint256 amountBMin,
670         address to,
671         uint256 deadline
672     )
673         external
674         returns (
675             uint256 amountA,
676             uint256 amountB,
677             uint256 liquidity
678         );
679 
680     function addLiquidityETH(
681         address token,
682         uint256 amountTokenDesired,
683         uint256 amountTokenMin,
684         uint256 amountETHMin,
685         address to,
686         uint256 deadline
687     )
688         external
689         payable
690         returns (
691             uint256 amountToken,
692             uint256 amountETH,
693             uint256 liquidity
694         );
695 
696     function removeLiquidity(
697         address tokenA,
698         address tokenB,
699         uint256 liquidity,
700         uint256 amountAMin,
701         uint256 amountBMin,
702         address to,
703         uint256 deadline
704     ) external returns (uint256 amountA, uint256 amountB);
705 
706     function removeLiquidityETH(
707         address token,
708         uint256 liquidity,
709         uint256 amountTokenMin,
710         uint256 amountETHMin,
711         address to,
712         uint256 deadline
713     ) external returns (uint256 amountToken, uint256 amountETH);
714 
715     function removeLiquidityWithPermit(
716         address tokenA,
717         address tokenB,
718         uint256 liquidity,
719         uint256 amountAMin,
720         uint256 amountBMin,
721         address to,
722         uint256 deadline,
723         bool approveMax,
724         uint8 v,
725         bytes32 r,
726         bytes32 s
727     ) external returns (uint256 amountA, uint256 amountB);
728 
729     function removeLiquidityETHWithPermit(
730         address token,
731         uint256 liquidity,
732         uint256 amountTokenMin,
733         uint256 amountETHMin,
734         address to,
735         uint256 deadline,
736         bool approveMax,
737         uint8 v,
738         bytes32 r,
739         bytes32 s
740     ) external returns (uint256 amountToken, uint256 amountETH);
741 
742     function swapExactTokensForTokens(
743         uint256 amountIn,
744         uint256 amountOutMin,
745         address[] calldata path,
746         address to,
747         uint256 deadline
748     ) external returns (uint256[] memory amounts);
749 
750     function swapTokensForExactTokens(
751         uint256 amountOut,
752         uint256 amountInMax,
753         address[] calldata path,
754         address to,
755         uint256 deadline
756     ) external returns (uint256[] memory amounts);
757 
758     function swapExactETHForTokens(
759         uint256 amountOutMin,
760         address[] calldata path,
761         address to,
762         uint256 deadline
763     ) external payable returns (uint256[] memory amounts);
764 
765     function swapTokensForExactETH(
766         uint256 amountOut,
767         uint256 amountInMax,
768         address[] calldata path,
769         address to,
770         uint256 deadline
771     ) external returns (uint256[] memory amounts);
772 
773     function swapExactTokensForETH(
774         uint256 amountIn,
775         uint256 amountOutMin,
776         address[] calldata path,
777         address to,
778         uint256 deadline
779     ) external returns (uint256[] memory amounts);
780 
781     function swapETHForExactTokens(
782         uint256 amountOut,
783         address[] calldata path,
784         address to,
785         uint256 deadline
786     ) external payable returns (uint256[] memory amounts);
787 
788     function removeLiquidityETHSupportingFeeOnTransferTokens(
789         address token,
790         uint256 liquidity,
791         uint256 amountTokenMin,
792         uint256 amountETHMin,
793         address to,
794         uint256 deadline
795     ) external returns (uint256 amountETH);
796 
797     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
798         address token,
799         uint256 liquidity,
800         uint256 amountTokenMin,
801         uint256 amountETHMin,
802         address to,
803         uint256 deadline,
804         bool approveMax,
805         uint8 v,
806         bytes32 r,
807         bytes32 s
808     ) external returns (uint256 amountETH);
809 
810     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
811         uint256 amountIn,
812         uint256 amountOutMin,
813         address[] calldata path,
814         address to,
815         uint256 deadline
816     ) external;
817 
818     function swapExactETHForTokensSupportingFeeOnTransferTokens(
819         uint256 amountOutMin,
820         address[] calldata path,
821         address to,
822         uint256 deadline
823     ) external payable;
824 
825     function swapExactTokensForETHSupportingFeeOnTransferTokens(
826         uint256 amountIn,
827         uint256 amountOutMin,
828         address[] calldata path,
829         address to,
830         uint256 deadline
831     ) external;
832 
833     function quote(
834         uint256 amountA,
835         uint256 reserveA,
836         uint256 reserveB
837     ) external pure returns (uint256 amountB);
838 
839     function getAmountOut(
840         uint256 amountIn,
841         uint256 reserveIn,
842         uint256 reserveOut
843     ) external pure returns (uint256 amountOut);
844 
845     function getAmountIn(
846         uint256 amountOut,
847         uint256 reserveIn,
848         uint256 reserveOut
849     ) external pure returns (uint256 amountIn);
850 
851     function getAmountsOut(uint256 amountIn, address[] calldata path)
852         external
853         view
854         returns (uint256[] memory amounts);
855 
856     function getAmountsIn(uint256 amountOut, address[] calldata path)
857         external
858         view
859         returns (uint256[] memory amounts);
860 }
861 
862 // File: contracts/UniswapV2/UniswapV2_ZapOut_General_V2.sol
863 
864 pragma solidity 0.5.12;
865 
866 // Copyright (C) 2020 dipeshsukhani, nodarjanashia, suhailg, apoorvlathey, sebaudet, sumit
867 
868 // This program is free software: you can redistribute it and/or modify
869 // it under the terms of the GNU Affero General Public License as published by
870 // the Free Software Foundation, either version 2 of the License, or
871 // (at your option) any later version.
872 //
873 // This program is distributed in the hope that it will be useful,
874 // but WITHOUT ANY WARRANTY; without even the implied warranty of
875 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
876 // GNU Affero General Public License for more details.
877 //
878 // Visit <https://www.gnu.org/licenses/>for a copy of the GNU Affero General Public License
879 
880 ///@author Zapper
881 ///@notice this contract implements one click removal of liquidity from Uniswap V2 pools, receiving ETH, ERC tokens or both.
882 
883 library TransferHelper {
884     function safeApprove(
885         address token,
886         address to,
887         uint256 value
888     ) internal {
889         // bytes4(keccak256(bytes('approve(address,uint256)')));
890         (bool success, bytes memory data) = token.call(
891             abi.encodeWithSelector(0x095ea7b3, to, value)
892         );
893         require(
894             success && (data.length == 0 || abi.decode(data, (bool))),
895             "TransferHelper: APPROVE_FAILED"
896         );
897     }
898 
899     function safeTransfer(
900         address token,
901         address to,
902         uint256 value
903     ) internal {
904         // bytes4(keccak256(bytes('transfer(address,uint256)')));
905         (bool success, bytes memory data) = token.call(
906             abi.encodeWithSelector(0xa9059cbb, to, value)
907         );
908         require(
909             success && (data.length == 0 || abi.decode(data, (bool))),
910             "TransferHelper: TRANSFER_FAILED"
911         );
912     }
913 
914     function safeTransferFrom(
915         address token,
916         address from,
917         address to,
918         uint256 value
919     ) internal {
920         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
921         (bool success, bytes memory data) = token.call(
922             abi.encodeWithSelector(0x23b872dd, from, to, value)
923         );
924         require(
925             success && (data.length == 0 || abi.decode(data, (bool))),
926             "TransferHelper: TRANSFER_FROM_FAILED"
927         );
928     }
929 }
930 
931 interface Iuniswap {
932     // converting ERC20 to ERC20 and transfer
933     function tokenToTokenTransferInput(
934         uint256 tokens_sold,
935         uint256 min_tokens_bought,
936         uint256 min_eth_bought,
937         uint256 deadline,
938         address recipient,
939         address token_addr
940     ) external returns (uint256 tokens_bought);
941 
942     function tokenToTokenSwapInput(
943         uint256 tokens_sold,
944         uint256 min_tokens_bought,
945         uint256 min_eth_bought,
946         uint256 deadline,
947         address token_addr
948     ) external returns (uint256 tokens_bought);
949 
950     function getTokenToEthInputPrice(uint256 tokens_sold)
951         external
952         view
953         returns (uint256 eth_bought);
954 
955     function tokenToEthTransferInput(
956         uint256 tokens_sold,
957         uint256 min_eth,
958         uint256 deadline,
959         address recipient
960     ) external returns (uint256 eth_bought);
961 
962     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline)
963         external
964         payable
965         returns (uint256 tokens_bought);
966 
967     function ethToTokenTransferInput(
968         uint256 min_tokens,
969         uint256 deadline,
970         address recipient
971     ) external payable returns (uint256 tokens_bought);
972 
973     function balanceOf(address _owner) external view returns (uint256);
974 
975     function transfer(address _to, uint256 _value) external returns (bool);
976 
977     function transferFrom(
978         address from,
979         address to,
980         uint256 tokens
981     ) external returns (bool success);
982 }
983 
984 interface IUniswapV2Pair {
985     function token0() external pure returns (address);
986 
987     function token1() external pure returns (address);
988 
989     function totalSupply() external view returns (uint256);
990 
991     function getReserves()
992         external
993         view
994         returns (
995             uint112 _reserve0,
996             uint112 _reserve1,
997             uint32 _blockTimestampLast
998         );
999 }
1000 
1001 interface IWETH {
1002     function deposit() external payable;
1003 
1004     function transfer(address to, uint256 value) external returns (bool);
1005 
1006     function withdraw(uint256) external;
1007 }
1008 
1009 interface IUniswapV2Factory {
1010     function getPair(address tokenA, address tokenB)
1011         external
1012         view
1013         returns (address);
1014 }
1015 
1016 contract UniswapV2_ZapOut_General_V2 is ReentrancyGuard, Ownable {
1017     using SafeMath for uint256;
1018     using Address for address;
1019     bool private stopped = false;
1020     uint16 public goodwill;
1021     address public dzgoodwillAddress;
1022 
1023     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(
1024         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1025     );
1026 
1027     IUniswapV2Factory public UniSwapV2FactoryAddress = IUniswapV2Factory(
1028         0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
1029     );
1030 
1031     address public wethTokenAddress = address(
1032         0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
1033     );
1034 
1035     constructor(uint16 _goodwill, address _dzgoodwillAddress) public {
1036         goodwill = _goodwill;
1037         dzgoodwillAddress = _dzgoodwillAddress;
1038     }
1039 
1040     // circuit breaker modifiers
1041     modifier stopInEmergency {
1042         if (stopped) {
1043             revert("Temporarily Paused");
1044         } else {
1045             _;
1046         }
1047     }
1048 
1049     /**
1050     @notice This function is used to zapout of given Uniswap pair in the bounded tokens
1051     @param _FromUniPoolAddress The uniswap pair address to zapout
1052     @param _IncomingLP The amount of LP
1053     @return the amount of pair tokens received after zapout
1054      */
1055     function ZapOut2PairToken(
1056         address _FromUniPoolAddress,
1057         uint256 _IncomingLP
1058     )
1059         public
1060         payable
1061         nonReentrant
1062         stopInEmergency
1063         returns (uint256 amountA, uint256 amountB)
1064     {
1065         IUniswapV2Pair pair = IUniswapV2Pair(_FromUniPoolAddress);
1066 
1067         require(address(pair) != address(0), "Error: Invalid Unipool Address");
1068 
1069         //get reserves
1070         address token0 = pair.token0();
1071         address token1 = pair.token1();
1072 
1073         TransferHelper.safeTransferFrom(
1074             _FromUniPoolAddress,
1075             msg.sender,
1076             address(this),
1077             _IncomingLP
1078         );
1079 
1080         uint256 goodwillPortion = _transferGoodwill(
1081             _FromUniPoolAddress,
1082             _IncomingLP
1083         );
1084 
1085         TransferHelper.safeApprove(
1086             _FromUniPoolAddress,
1087             address(uniswapV2Router),
1088             SafeMath.sub(_IncomingLP, goodwillPortion)
1089         );
1090 
1091         if (token0 == wethTokenAddress || token1 == wethTokenAddress) {
1092             address _token = token0 == wethTokenAddress ? token1 : token0;
1093             (amountA, amountB) = uniswapV2Router.removeLiquidityETH(
1094                 _token,
1095                 SafeMath.sub(_IncomingLP, goodwillPortion),
1096                 1,
1097                 1,
1098                 msg.sender,
1099                 now + 60
1100             );
1101         } else {
1102             (amountA, amountB) = uniswapV2Router.removeLiquidity(
1103                 token0,
1104                 token1,
1105                 SafeMath.sub(_IncomingLP, goodwillPortion),
1106                 1,
1107                 1,
1108                 msg.sender,
1109                 now + 60
1110             );
1111         }
1112     }
1113 
1114     /**
1115     @notice This function is used to zapout of given Uniswap pair in ETH/ERC20 Tokens
1116     @param _ToTokenContractAddress The ERC20 token to zapout in (address(0x00) if ether)
1117     @param _FromUniPoolAddress The uniswap pair address to zapout from
1118     @param _IncomingLP The amount of LP
1119     @return the amount of eth/tokens received after zapout
1120      */
1121     function ZapOut(
1122         address _ToTokenContractAddress,
1123         address _FromUniPoolAddress,
1124         uint256 _IncomingLP,
1125         uint256 _minTokensRec
1126     ) public payable nonReentrant stopInEmergency returns (uint256) {
1127         IUniswapV2Pair pair = IUniswapV2Pair(_FromUniPoolAddress);
1128 
1129         require(address(pair) != address(0), "Error: Invalid Unipool Address");
1130 
1131         //get pair tokens
1132         address token0 = pair.token0();
1133         address token1 = pair.token1();
1134 
1135         TransferHelper.safeTransferFrom(
1136             _FromUniPoolAddress,
1137             msg.sender,
1138             address(this),
1139             _IncomingLP
1140         );
1141 
1142         uint256 goodwillPortion = _transferGoodwill(
1143             _FromUniPoolAddress,
1144             _IncomingLP
1145         );
1146 
1147         TransferHelper.safeApprove(
1148             _FromUniPoolAddress,
1149             address(uniswapV2Router),
1150             SafeMath.sub(_IncomingLP, goodwillPortion)
1151         );
1152 
1153         (uint256 amountA, uint256 amountB) = uniswapV2Router.removeLiquidity(
1154             token0,
1155             token1,
1156             SafeMath.sub(_IncomingLP, goodwillPortion),
1157             1,
1158             1,
1159             address(this),
1160             now + 60
1161         );
1162 
1163         uint256 tokenBought;
1164         if (
1165             canSwapFromV2(_ToTokenContractAddress, token0) &&
1166             canSwapFromV2(_ToTokenContractAddress, token1)
1167         ) {
1168             tokenBought = swapFromV2(token0, _ToTokenContractAddress, amountA);
1169             tokenBought += swapFromV2(token1, _ToTokenContractAddress, amountB);
1170         } else if (canSwapFromV2(_ToTokenContractAddress, token0)) {
1171             uint256 token0Bought = swapFromV2(token1, token0, amountB);
1172             tokenBought = swapFromV2(
1173                 token0,
1174                 _ToTokenContractAddress,
1175                 token0Bought.add(amountA)
1176             );
1177         } else if (canSwapFromV2(_ToTokenContractAddress, token1)) {
1178             uint256 token1Bought = swapFromV2(token0, token1, amountA);
1179             tokenBought = swapFromV2(
1180                 token1,
1181                 _ToTokenContractAddress,
1182                 token1Bought.add(amountB)
1183             );
1184         }
1185 
1186         require(tokenBought >= _minTokensRec, "High slippage");
1187 
1188         if (_ToTokenContractAddress == address(0)) {
1189             msg.sender.transfer(tokenBought);
1190         } else {
1191             TransferHelper.safeTransfer(
1192                 _ToTokenContractAddress,
1193                 msg.sender,
1194                 tokenBought
1195             );
1196         }
1197 
1198         return tokenBought;
1199     }
1200 
1201     //swaps _fromToken for _toToken
1202     //for eth, address(0) otherwise ERC token address
1203     function swapFromV2(
1204         address _fromToken,
1205         address _toToken,
1206         uint256 amount
1207     ) internal returns (uint256) {
1208         require(
1209             _fromToken != address(0) || _toToken != address(0),
1210             "Invalid Exchange values"
1211         );
1212         if (_fromToken == _toToken) return amount;
1213 
1214         require(canSwapFromV2(_fromToken, _toToken), "Cannot be exchanged");
1215         require(amount > 0, "Invalid amount");
1216 
1217         if (_fromToken == address(0)) {
1218             if (_toToken == wethTokenAddress) {
1219                 IWETH(wethTokenAddress).deposit.value(amount)();
1220                 return amount;
1221             }
1222             address[] memory path = new address[](2);
1223             path[0] = wethTokenAddress;
1224             path[1] = _toToken;
1225             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1226             minTokens = SafeMath.div(
1227                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1228                 10000
1229             );
1230             uint256[] memory amounts = uniswapV2Router
1231                 .swapExactETHForTokens
1232                 .value(amount)(minTokens, path, address(this), now + 180);
1233             return amounts[1];
1234         } else if (_toToken == address(0)) {
1235             if (_fromToken == wethTokenAddress) {
1236                 IWETH(wethTokenAddress).withdraw(amount);
1237                 return amount;
1238             }
1239             address[] memory path = new address[](2);
1240             TransferHelper.safeApprove(
1241                 _fromToken,
1242                 address(uniswapV2Router),
1243                 amount
1244             );
1245             path[0] = _fromToken;
1246             path[1] = wethTokenAddress;
1247             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1248             minTokens = SafeMath.div(
1249                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1250                 10000
1251             );
1252             uint256[] memory amounts = uniswapV2Router.swapExactTokensForETH(
1253                 amount,
1254                 minTokens,
1255                 path,
1256                 address(this),
1257                 now + 180
1258             );
1259             return amounts[1];
1260         } else {
1261             TransferHelper.safeApprove(
1262                 _fromToken,
1263                 address(uniswapV2Router),
1264                 amount
1265             );
1266             uint256 returnedAmount = _swapTokenToTokenV2(
1267                 _fromToken,
1268                 _toToken,
1269                 amount
1270             );
1271             require(returnedAmount > 0, "Error in swap");
1272             return returnedAmount;
1273         }
1274     }
1275 
1276     //swaps 2 ERC tokens (UniV2)
1277     function _swapTokenToTokenV2(
1278         address _fromToken,
1279         address _toToken,
1280         uint256 amount
1281     ) internal returns (uint256) {
1282         IUniswapV2Pair pair1 = IUniswapV2Pair(
1283             UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1284         );
1285         IUniswapV2Pair pair2 = IUniswapV2Pair(
1286             UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1287         );
1288         IUniswapV2Pair pair3 = IUniswapV2Pair(
1289             UniSwapV2FactoryAddress.getPair(_fromToken, _toToken)
1290         );
1291 
1292         uint256[] memory amounts;
1293 
1294         if (_haveReserve(pair3)) {
1295             address[] memory path = new address[](2);
1296             path[0] = _fromToken;
1297             path[1] = _toToken;
1298             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[1];
1299             minTokens = SafeMath.div(
1300                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1301                 10000
1302             );
1303             amounts = uniswapV2Router.swapExactTokensForTokens(
1304                 amount,
1305                 minTokens,
1306                 path,
1307                 address(this),
1308                 now + 180
1309             );
1310             return amounts[1];
1311         } else if (_haveReserve(pair1) && _haveReserve(pair2)) {
1312             address[] memory path = new address[](3);
1313             path[0] = _fromToken;
1314             path[1] = wethTokenAddress;
1315             path[2] = _toToken;
1316             uint256 minTokens = uniswapV2Router.getAmountsOut(amount, path)[2];
1317             minTokens = SafeMath.div(
1318                 SafeMath.mul(minTokens, SafeMath.sub(10000, 200)),
1319                 10000
1320             );
1321             amounts = uniswapV2Router.swapExactTokensForTokens(
1322                 amount,
1323                 minTokens,
1324                 path,
1325                 address(this),
1326                 now + 180
1327             );
1328             return amounts[2];
1329         }
1330         return 0;
1331     }
1332 
1333     function canSwapFromV2(address _fromToken, address _toToken)
1334         public
1335         view
1336         returns (bool)
1337     {
1338         require(
1339             _fromToken != address(0) || _toToken != address(0),
1340             "Invalid Exchange values"
1341         );
1342 
1343         if (_fromToken == _toToken) return true;
1344 
1345         if (_fromToken == address(0) || _fromToken == wethTokenAddress) {
1346             if (_toToken == wethTokenAddress || _toToken == address(0))
1347                 return true;
1348             IUniswapV2Pair pair = IUniswapV2Pair(
1349                 UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1350             );
1351             if (_haveReserve(pair)) return true;
1352         } else if (_toToken == address(0) || _toToken == wethTokenAddress) {
1353             if (_fromToken == wethTokenAddress || _fromToken == address(0))
1354                 return true;
1355             IUniswapV2Pair pair = IUniswapV2Pair(
1356                 UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1357             );
1358             if (_haveReserve(pair)) return true;
1359         } else {
1360             IUniswapV2Pair pair1 = IUniswapV2Pair(
1361                 UniSwapV2FactoryAddress.getPair(_fromToken, wethTokenAddress)
1362             );
1363             IUniswapV2Pair pair2 = IUniswapV2Pair(
1364                 UniSwapV2FactoryAddress.getPair(_toToken, wethTokenAddress)
1365             );
1366             IUniswapV2Pair pair3 = IUniswapV2Pair(
1367                 UniSwapV2FactoryAddress.getPair(_fromToken, _toToken)
1368             );
1369             if (_haveReserve(pair1) && _haveReserve(pair2)) return true;
1370             if (_haveReserve(pair3)) return true;
1371         }
1372         return false;
1373     }
1374 
1375     //checks if the UNI v2 contract have reserves to swap tokens
1376     function _haveReserve(IUniswapV2Pair pair) internal view returns (bool) {
1377         if (address(pair) != address(0)) {
1378             uint256 totalSupply = pair.totalSupply();
1379             if (totalSupply > 0) return true;
1380         }
1381     }
1382 
1383     /**
1384     @notice This function is used to calculate and transfer goodwill
1385     @param _tokenContractAddress Token in which goodwill is deducted
1386     @param tokens2Trade The total amount of tokens to be zapped in
1387     @return The quantity of goodwill deducted
1388      */
1389     function _transferGoodwill(
1390         address _tokenContractAddress,
1391         uint256 tokens2Trade
1392     ) internal returns (uint256 goodwillPortion) {
1393         if (goodwill == 0) {
1394             return 0;
1395         }
1396 
1397         goodwillPortion = SafeMath.div(
1398             SafeMath.mul(tokens2Trade, goodwill),
1399             10000
1400         );
1401 
1402         TransferHelper.safeTransfer(
1403             _tokenContractAddress,
1404             dzgoodwillAddress,
1405             goodwillPortion
1406         );
1407     }
1408 
1409     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
1410         require(
1411             _new_goodwill >= 0 && _new_goodwill < 10000,
1412             "GoodWill Value not allowed"
1413         );
1414         goodwill = _new_goodwill;
1415     }
1416 
1417     function set_new_dzgoodwillAddress(address _new_dzgoodwillAddress)
1418         public
1419         onlyOwner
1420     {
1421         dzgoodwillAddress = _new_dzgoodwillAddress;
1422     }
1423 
1424     function inCaseTokengetsStuck(IERC20 _TokenAddress) public onlyOwner {
1425         uint256 qty = _TokenAddress.balanceOf(address(this));
1426         TransferHelper.safeTransfer(address(_TokenAddress), owner(), qty);
1427     }
1428 
1429     // - to Pause the contract
1430     function toggleContractActive() public onlyOwner {
1431         stopped = !stopped;
1432     }
1433 
1434     // - to withdraw any ETH balance sitting in the contract
1435     function withdraw() public onlyOwner {
1436         uint256 contractBalance = address(this).balance;
1437         address payable _to = owner().toPayable();
1438         _to.transfer(contractBalance);
1439     }
1440 
1441     function() external payable {}
1442 }