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
160 // File: @openzeppelin/contracts/utils/Address.sol
161 
162 pragma solidity ^0.5.5;
163 
164 /**
165  * @dev Collection of functions related to the address type
166  */
167 library Address {
168     /**
169      * @dev Returns true if `account` is a contract.
170      *
171      * This test is non-exhaustive, and there may be false-negatives: during the
172      * execution of a contract's constructor, its address will be reported as
173      * not containing a contract.
174      *
175      * IMPORTANT: It is unsafe to assume that an address for which this
176      * function returns false is an externally-owned account (EOA) and not a
177      * contract.
178      */
179     function isContract(address account) internal view returns (bool) {
180         // This method relies in extcodesize, which returns 0 for contracts in
181         // construction, since the code is only stored at the end of the
182         // constructor execution.
183 
184         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
185         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
186         // for accounts without code, i.e. `keccak256('')`
187         bytes32 codehash;
188         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
189         // solhint-disable-next-line no-inline-assembly
190         assembly { codehash := extcodehash(account) }
191         return (codehash != 0x0 && codehash != accountHash);
192     }
193 
194     /**
195      * @dev Converts an `address` into `address payable`. Note that this is
196      * simply a type cast: the actual underlying value is not changed.
197      *
198      * _Available since v2.4.0._
199      */
200     function toPayable(address account) internal pure returns (address payable) {
201         return address(uint160(account));
202     }
203 
204     /**
205      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
206      * `recipient`, forwarding all available gas and reverting on errors.
207      *
208      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
209      * of certain opcodes, possibly making contracts go over the 2300 gas limit
210      * imposed by `transfer`, making them unable to receive funds via
211      * `transfer`. {sendValue} removes this limitation.
212      *
213      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
214      *
215      * IMPORTANT: because control is transferred to `recipient`, care must be
216      * taken to not create reentrancy vulnerabilities. Consider using
217      * {ReentrancyGuard} or the
218      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
219      *
220      * _Available since v2.4.0._
221      */
222     function sendValue(address payable recipient, uint256 amount) internal {
223         require(address(this).balance >= amount, "Address: insufficient balance");
224 
225         // solhint-disable-next-line avoid-call-value
226         (bool success, ) = recipient.call.value(amount)("");
227         require(success, "Address: unable to send value, recipient may have reverted");
228     }
229 }
230 
231 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
232 
233 pragma solidity ^0.5.0;
234 
235 /**
236  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
237  * the optional functions; to access them see {ERC20Detailed}.
238  */
239 interface IERC20 {
240     /**
241      * @dev Returns the amount of tokens in existence.
242      */
243     function totalSupply() external view returns (uint256);
244 
245     /**
246      * @dev Returns the amount of tokens owned by `account`.
247      */
248     function balanceOf(address account) external view returns (uint256);
249 
250     /**
251      * @dev Moves `amount` tokens from the caller's account to `recipient`.
252      *
253      * Returns a boolean value indicating whether the operation succeeded.
254      *
255      * Emits a {Transfer} event.
256      */
257     function transfer(address recipient, uint256 amount) external returns (bool);
258 
259     /**
260      * @dev Returns the remaining number of tokens that `spender` will be
261      * allowed to spend on behalf of `owner` through {transferFrom}. This is
262      * zero by default.
263      *
264      * This value changes when {approve} or {transferFrom} are called.
265      */
266     function allowance(address owner, address spender) external view returns (uint256);
267 
268     /**
269      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
270      *
271      * Returns a boolean value indicating whether the operation succeeded.
272      *
273      * IMPORTANT: Beware that changing an allowance with this method brings the risk
274      * that someone may use both the old and the new allowance by unfortunate
275      * transaction ordering. One possible solution to mitigate this race
276      * condition is to first reduce the spender's allowance to 0 and set the
277      * desired value afterwards:
278      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279      *
280      * Emits an {Approval} event.
281      */
282     function approve(address spender, uint256 amount) external returns (bool);
283 
284     /**
285      * @dev Moves `amount` tokens from `sender` to `recipient` using the
286      * allowance mechanism. `amount` is then deducted from the caller's
287      * allowance.
288      *
289      * Returns a boolean value indicating whether the operation succeeded.
290      *
291      * Emits a {Transfer} event.
292      */
293     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
294 
295     /**
296      * @dev Emitted when `value` tokens are moved from one account (`from`) to
297      * another (`to`).
298      *
299      * Note that `value` may be zero.
300      */
301     event Transfer(address indexed from, address indexed to, uint256 value);
302 
303     /**
304      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
305      * a call to {approve}. `value` is the new allowance.
306      */
307     event Approval(address indexed owner, address indexed spender, uint256 value);
308 }
309 
310 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
311 
312 pragma solidity ^0.5.0;
313 
314 
315 
316 
317 /**
318  * @title SafeERC20
319  * @dev Wrappers around ERC20 operations that throw on failure (when the token
320  * contract returns false). Tokens that return no value (and instead revert or
321  * throw on failure) are also supported, non-reverting calls are assumed to be
322  * successful.
323  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
324  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
325  */
326 library SafeERC20 {
327     using SafeMath for uint256;
328     using Address for address;
329 
330     function safeTransfer(IERC20 token, address to, uint256 value) internal {
331         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
332     }
333 
334     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
335         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
336     }
337 
338     function safeApprove(IERC20 token, address spender, uint256 value) internal {
339         // safeApprove should only be called when setting an initial allowance,
340         // or when resetting it to zero. To increase and decrease it, use
341         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
342         // solhint-disable-next-line max-line-length
343         require((value == 0) || (token.allowance(address(this), spender) == 0),
344             "SafeERC20: approve from non-zero to non-zero allowance"
345         );
346         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
347     }
348 
349     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
350         uint256 newAllowance = token.allowance(address(this), spender).add(value);
351         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
352     }
353 
354     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
355         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
356         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
357     }
358 
359     /**
360      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
361      * on the return value: the return value is optional (but if data is returned, it must not be false).
362      * @param token The token targeted by the call.
363      * @param data The call data (encoded using abi.encode or one of its variants).
364      */
365     function callOptionalReturn(IERC20 token, bytes memory data) private {
366         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
367         // we're implementing it ourselves.
368 
369         // A Solidity high level call has three parts:
370         //  1. The target address is checked to verify it contains contract code
371         //  2. The call itself is made, and success asserted
372         //  3. The return value is decoded, which in turn checks the size of the returned data.
373         // solhint-disable-next-line max-line-length
374         require(address(token).isContract(), "SafeERC20: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = address(token).call(data);
378         require(success, "SafeERC20: low-level call failed");
379 
380         if (returndata.length > 0) { // Return data is optional
381             // solhint-disable-next-line max-line-length
382             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/GSN/Context.sol
388 
389 pragma solidity ^0.5.0;
390 
391 /*
392  * @dev Provides information about the current execution context, including the
393  * sender of the transaction and its data. While these are generally available
394  * via msg.sender and msg.data, they should not be accessed in such a direct
395  * manner, since when dealing with GSN meta-transactions the account sending and
396  * paying for execution may not be the actual sender (as far as an application
397  * is concerned).
398  *
399  * This contract is only required for intermediate, library-like contracts.
400  */
401 contract Context {
402     // Empty internal constructor, to prevent people from mistakenly deploying
403     // an instance of this contract, which should be used via inheritance.
404     constructor () internal { }
405     // solhint-disable-previous-line no-empty-blocks
406 
407     function _msgSender() internal view returns (address payable) {
408         return msg.sender;
409     }
410 
411     function _msgData() internal view returns (bytes memory) {
412         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
413         return msg.data;
414     }
415 }
416 
417 // File: @openzeppelin/contracts/ownership/Ownable.sol
418 
419 pragma solidity ^0.5.0;
420 
421 /**
422  * @dev Contract module which provides a basic access control mechanism, where
423  * there is an account (an owner) that can be granted exclusive access to
424  * specific functions.
425  *
426  * This module is used through inheritance. It will make available the modifier
427  * `onlyOwner`, which can be applied to your functions to restrict their use to
428  * the owner.
429  */
430 contract Ownable is Context {
431     address private _owner;
432 
433     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
434 
435     /**
436      * @dev Initializes the contract setting the deployer as the initial owner.
437      */
438     constructor () internal {
439         _owner = _msgSender();
440         emit OwnershipTransferred(address(0), _owner);
441     }
442 
443     /**
444      * @dev Returns the address of the current owner.
445      */
446     function owner() public view returns (address) {
447         return _owner;
448     }
449 
450     /**
451      * @dev Throws if called by any account other than the owner.
452      */
453     modifier onlyOwner() {
454         require(isOwner(), "Ownable: caller is not the owner");
455         _;
456     }
457 
458     /**
459      * @dev Returns true if the caller is the current owner.
460      */
461     function isOwner() public view returns (bool) {
462         return _msgSender() == _owner;
463     }
464 
465     /**
466      * @dev Leaves the contract without owner. It will not be possible to call
467      * `onlyOwner` functions anymore. Can only be called by the current owner.
468      *
469      * NOTE: Renouncing ownership will leave the contract without an owner,
470      * thereby removing any functionality that is only available to the owner.
471      */
472     function renounceOwnership() public onlyOwner {
473         emit OwnershipTransferred(_owner, address(0));
474         _owner = address(0);
475     }
476 
477     /**
478      * @dev Transfers ownership of the contract to a new account (`newOwner`).
479      * Can only be called by the current owner.
480      */
481     function transferOwnership(address newOwner) public onlyOwner {
482         _transferOwnership(newOwner);
483     }
484 
485     /**
486      * @dev Transfers ownership of the contract to a new account (`newOwner`).
487      */
488     function _transferOwnership(address newOwner) internal {
489         require(newOwner != address(0), "Ownable: new owner is the zero address");
490         emit OwnershipTransferred(_owner, newOwner);
491         _owner = newOwner;
492     }
493 }
494 
495 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
496 
497 pragma solidity >=0.5.0;
498 
499 interface IUniswapV2Pair {
500     event Approval(address indexed owner, address indexed spender, uint value);
501     event Transfer(address indexed from, address indexed to, uint value);
502 
503     function name() external pure returns (string memory);
504     function symbol() external pure returns (string memory);
505     function decimals() external pure returns (uint8);
506     function totalSupply() external view returns (uint);
507     function balanceOf(address owner) external view returns (uint);
508     function allowance(address owner, address spender) external view returns (uint);
509 
510     function approve(address spender, uint value) external returns (bool);
511     function transfer(address to, uint value) external returns (bool);
512     function transferFrom(address from, address to, uint value) external returns (bool);
513 
514     function DOMAIN_SEPARATOR() external view returns (bytes32);
515     function PERMIT_TYPEHASH() external pure returns (bytes32);
516     function nonces(address owner) external view returns (uint);
517 
518     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
519 
520     event Mint(address indexed sender, uint amount0, uint amount1);
521     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
522     event Swap(
523         address indexed sender,
524         uint amount0In,
525         uint amount1In,
526         uint amount0Out,
527         uint amount1Out,
528         address indexed to
529     );
530     event Sync(uint112 reserve0, uint112 reserve1);
531 
532     function MINIMUM_LIQUIDITY() external pure returns (uint);
533     function factory() external view returns (address);
534     function token0() external view returns (address);
535     function token1() external view returns (address);
536     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
537     function price0CumulativeLast() external view returns (uint);
538     function price1CumulativeLast() external view returns (uint);
539     function kLast() external view returns (uint);
540 
541     function mint(address to) external returns (uint liquidity);
542     function burn(address to) external returns (uint amount0, uint amount1);
543     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
544     function skim(address to) external;
545     function sync() external;
546 
547     function initialize(address, address) external;
548 }
549 
550 // File: contracts/lib/UniswapV2Library.sol
551 
552 // taken from here: https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/libraries/UniswapV2Library.sol
553 pragma solidity >=0.5.0;
554 
555 
556 
557 library UniswapV2Library {
558     using SafeMath for uint256;
559 
560     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
561     function getAmountOut(
562         uint256 amountIn,
563         uint256 reserveIn,
564         uint256 reserveOut
565     ) internal pure returns (uint256 amountOut) {
566         require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
567         require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
568         uint256 amountInWithFee = amountIn.mul(997);
569         uint256 numerator = amountInWithFee.mul(reserveOut);
570         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
571         amountOut = numerator / denominator;
572     }
573 
574     /**
575      * @author allemanfredi
576      * @notice given an input amount, returns the output
577      *         amount with slippage and with fees. This fx is
578      *         to check approximately onchain the slippage
579      *         during a swap
580      */
581     function calculateSlippageAmountWithFees(
582         uint256 _amountIn,
583         uint256 _allowedSlippage,
584         uint256 _rateIn,
585         uint256 _rateOut
586     ) internal pure returns (uint256) {
587         require(_amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
588         uint256 slippageAmount = _amountIn
589             .mul(_rateOut)
590             .div(_rateIn)
591             .mul(10000 - _allowedSlippage)
592             .div(10000);
593         // NOTE: remove fees
594         return slippageAmount.mul(997).div(1000);
595     }
596 
597     /**
598      * @author allemanfredi
599      * @notice given 2 inputs amount, it returns the
600      *         rate percentage between the 2 amounts
601      */
602     function calculateRate(uint256 _amountIn, uint256 _amountOut) internal pure returns (uint256) {
603         require(_amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
604         require(_amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
605         return
606             _amountIn > _amountOut
607                 ? (10000 * _amountIn).sub(10000 * _amountOut).div(_amountIn)
608                 : (10000 * _amountOut).sub(10000 * _amountIn).div(_amountOut);
609     }
610 
611     /**
612      * @author allemanfredi
613      * @notice returns the slippage for a trade without counting the fees
614      */
615     function calculateSlippage(
616         uint256 _amountIn,
617         uint256 _reserveIn,
618         uint256 _reserveOut
619     ) internal pure returns (uint256) {
620         require(_amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
621         uint256 price = _reserveOut.mul(10**18).div(_reserveIn);
622         uint256 quote = _amountIn.mul(price);
623         uint256 amountOut = getAmountOut(_amountIn, _reserveIn, _reserveOut);
624         return uint256(10000).sub((amountOut * 10000).div(quote.div(10**18))).mul(997).div(1000);
625     }
626 }
627 
628 // File: @openzeppelin/contracts/math/Math.sol
629 
630 pragma solidity ^0.5.0;
631 
632 /**
633  * @dev Standard math utilities missing in the Solidity language.
634  */
635 library Math {
636     /**
637      * @dev Returns the largest of two numbers.
638      */
639     function max(uint256 a, uint256 b) internal pure returns (uint256) {
640         return a >= b ? a : b;
641     }
642 
643     /**
644      * @dev Returns the smallest of two numbers.
645      */
646     function min(uint256 a, uint256 b) internal pure returns (uint256) {
647         return a < b ? a : b;
648     }
649 
650     /**
651      * @dev Returns the average of two numbers. The result is rounded towards
652      * zero.
653      */
654     function average(uint256 a, uint256 b) internal pure returns (uint256) {
655         // (a + b) / 2 can overflow, so we distribute
656         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
657     }
658 }
659 
660 // File: contracts/IRewardDistributionRecipient.sol
661 
662 pragma solidity ^0.5.0;
663 
664 
665 
666 contract IRewardDistributionRecipient is Ownable {
667     address public rewardDistribution;
668 
669     function notifyRewardAmount(uint256 reward) external;
670 
671     modifier onlyRewardDistribution() {
672         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
673         _;
674     }
675 
676     function setRewardDistribution(address _rewardDistribution) external onlyOwner {
677         rewardDistribution = _rewardDistribution;
678     }
679 }
680 
681 // File: contracts/ModifiedUnipool.sol
682 
683 pragma solidity ^0.5.0;
684 
685 
686 
687 
688 
689 
690 
691 contract LPTokenWrapper {
692     using SafeMath for uint256;
693     using SafeERC20 for IERC20;
694 
695     IERC20 public uniV2;
696 
697     uint256 private _totalSupply;
698     mapping(address => uint256) private _balances;
699     mapping(address => mapping(address => uint256)) private _allowances;
700 
701     event Approval(address indexed owner, address indexed spender, uint256 value);
702 
703     constructor(address _uniV2) public {
704         uniV2 = IERC20(_uniV2);
705     }
706 
707     function totalSupply() public view returns (uint256) {
708         return _totalSupply;
709     }
710 
711     function balanceOf(address account) public view returns (uint256) {
712         return _balances[account];
713     }
714 
715     function stakeFor(address _user, uint256 _amount) public {
716         _stake(_user, _amount);
717     }
718 
719     function stake(uint256 _amount) public {
720         _stake(msg.sender, _amount);
721     }
722 
723     function approve(address _user, uint256 _amount) public {
724         _approve(msg.sender, _user, _amount);
725     }
726 
727     function withdraw(uint256 _amount) public {
728         _withdraw(msg.sender, _amount);
729     }
730 
731     function withdrawFrom(address _user, uint256 _amount) public {
732         _withdraw(_user, _amount);
733         _approve(
734             _user,
735             msg.sender,
736             _allowances[_user][msg.sender].sub(
737                 _amount,
738                 "LPTokenWrapper: transfer amount exceeds allowance"
739             )
740         );
741     }
742 
743     function allowance(address _owner, address _spender) public view returns (uint256) {
744         return _allowances[_owner][_spender];
745     }
746 
747     function _stake(address _user, uint256 _amount) internal {
748         _totalSupply = _totalSupply.add(_amount);
749         _balances[_user] = _balances[_user].add(_amount);
750         uniV2.safeTransferFrom(msg.sender, address(this), _amount);
751     }
752 
753     function _withdraw(address _owner, uint256 _amount) internal {
754         _totalSupply = _totalSupply.sub(_amount);
755         _balances[_owner] = _balances[_owner].sub(_amount);
756         IERC20(uniV2).safeTransfer(msg.sender, _amount);
757     }
758 
759     function _approve(
760         address _owner,
761         address _user,
762         uint256 _amount
763     ) internal returns (bool) {
764         require(_user != address(0), "LPTokenWrapper: approve to the zero address");
765         _allowances[_owner][_user] = _amount;
766         emit Approval(_owner, _user, _amount);
767         return true;
768     }
769 }
770 
771 
772 contract ModifiedUnipool is LPTokenWrapper, IRewardDistributionRecipient {
773     address public rewardToken;
774     uint256 public constant DURATION = 7 days;
775 
776     uint256 public periodFinish = 0;
777     uint256 public rewardRate = 0;
778     uint256 public lastUpdateTime;
779     uint256 public rewardPerTokenStored;
780     mapping(address => uint256) public userRewardPerTokenPaid;
781     mapping(address => uint256) public rewards;
782 
783     event RewardAdded(uint256 reward);
784     event Staked(address indexed user, uint256 amount);
785     event Withdrawn(address indexed user, uint256 amount);
786     event RewardPaid(address indexed user, uint256 reward);
787 
788     modifier updateReward(address account) {
789         rewardPerTokenStored = rewardPerToken();
790         lastUpdateTime = lastTimeRewardApplicable();
791         if (account != address(0)) {
792             rewards[account] = earned(account);
793             userRewardPerTokenPaid[account] = rewardPerTokenStored;
794         }
795         _;
796     }
797 
798     constructor(address _rewardToken, address _uniV2) public LPTokenWrapper(_uniV2) {
799         rewardToken = _rewardToken;
800     }
801 
802     function notifyRewardAmount(uint256 reward)
803         external
804         onlyRewardDistribution
805         updateReward(address(0))
806     {
807         if (block.timestamp >= periodFinish) {
808             rewardRate = reward.div(DURATION);
809         } else {
810             uint256 remaining = periodFinish.sub(block.timestamp);
811             uint256 leftover = remaining.mul(rewardRate);
812             rewardRate = reward.add(leftover).div(DURATION);
813         }
814         lastUpdateTime = block.timestamp;
815         periodFinish = block.timestamp.add(DURATION);
816         emit RewardAdded(reward);
817     }
818 
819     function exit() external {
820         withdraw(balanceOf(msg.sender));
821         getReward(msg.sender);
822     }
823 
824     function lastTimeRewardApplicable() public view returns (uint256) {
825         return Math.min(block.timestamp, periodFinish);
826     }
827 
828     function rewardPerToken() public view returns (uint256) {
829         if (totalSupply() == 0) {
830             return rewardPerTokenStored;
831         }
832         return
833             rewardPerTokenStored.add(
834                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(
835                     totalSupply()
836                 )
837             );
838     }
839 
840     function earned(address account) public view returns (uint256) {
841         return
842             balanceOf(account)
843                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
844                 .div(1e18)
845                 .add(rewards[account]);
846     }
847 
848     function stake(uint256 amount) public updateReward(msg.sender) {
849         require(amount > 0, "Cannot stake 0");
850         super.stake(amount);
851         emit Staked(msg.sender, amount);
852     }
853 
854     function stakeFor(address _user, uint256 _amount) public updateReward(_user) {
855         require(_amount > 0, "Cannot stake 0");
856         super.stakeFor(_user, _amount);
857         emit Staked(_user, _amount);
858     }
859 
860     function withdraw(uint256 amount) public updateReward(msg.sender) {
861         require(amount > 0, "Cannot withdraw 0");
862         super.withdraw(amount);
863         emit Withdrawn(msg.sender, amount);
864     }
865 
866     function withdrawFrom(address _user, uint256 amount) public updateReward(_user) {
867         require(amount > 0, "Cannot withdraw 0");
868         super.withdrawFrom(_user, amount);
869         emit Withdrawn(_user, amount);
870     }
871 
872     function getReward() public {
873         _getReward(msg.sender);
874     }
875 
876     function getReward(address _user) public {
877         _getReward(_user);
878     }
879 
880     function _getReward(address _user) internal updateReward(_user) {
881         uint256 reward = earned(_user);
882         if (reward > 0) {
883             rewards[_user] = 0;
884             IERC20(rewardToken).safeTransfer(_user, reward);
885             emit RewardPaid(_user, reward);
886         }
887     }
888 }
889 
890 // File: contracts/interfaces/IWETH.sol
891 
892 pragma solidity >=0.5.0;
893 
894 interface IWETH {
895     function deposit() external payable;
896 
897     function transfer(address to, uint256 value) external returns (bool);
898 
899     function withdraw(uint256) external;
900 
901     function balanceOf(address who) external view returns (uint256);
902 
903     function approve(address spender, uint256 amount) external returns (bool);
904 
905     function allowance(address owner, address spender) external returns (uint256);
906 }
907 
908 // File: contracts/strategies/RewardedPntWethUniV2Pair.sol
909 
910 pragma solidity ^0.5.0;
911 
912 
913 
914 
915 
916 
917 
918 
919 
920 
921 
922 contract RewardedPntWethUniV2Pair is Ownable {
923     using SafeMath for uint256;
924     using SafeERC20 for IERC20;
925 
926     IERC20 public pnt;
927     IWETH public weth;
928     IUniswapV2Pair public uniV2;
929     ModifiedUnipool public modifiedUnipool;
930 
931     uint256 public allowedSlippage;
932 
933     event Staked(address indexed user, uint256 amount);
934     event Unstaked(address indexed user, uint256 pntAmount, uint256 ethAmount);
935     event AllowedSlippageChanged(uint256 slippage);
936 
937     /**
938      * @param _uniV2 UniV2Pair address
939      * @param _modifiedUnipool ModifiedUnipool address
940      */
941     constructor(address _uniV2, address _modifiedUnipool) public {
942         require(Address.isContract(_uniV2), "RewardedPntWethUniV2Pair: _uniV2 not a contract");
943 
944         uniV2 = IUniswapV2Pair(_uniV2);
945         modifiedUnipool = ModifiedUnipool(_modifiedUnipool);
946         pnt = IERC20(uniV2.token0());
947         weth = IWETH(uniV2.token1());
948     }
949 
950     /**
951      * @notice function used to handle the ethers sent
952      *         during the witdraw within the unstake function
953      */
954     function() external payable {
955         require(msg.sender == address(weth), "RewardedPntWethUniV2Pair: msg.sender is not weth");
956     }
957 
958     /**
959      *  @param _allowedSlippage new max allowed in percentage
960      */
961     function setAllowedSlippage(uint256 _allowedSlippage) external onlyOwner {
962         allowedSlippage = _allowedSlippage;
963         emit AllowedSlippageChanged(_allowedSlippage);
964     }
965 
966     /**
967      * @notice _stakeFor wrapper
968      */
969     function stake() public payable returns (bool) {
970         require(msg.value > 0, "RewardedPntWethUniV2Pair: msg.value must be greater than 0");
971         _stakeFor(msg.sender, msg.value);
972         return true;
973     }
974 
975     /**
976      * @notice Burn all user's UniV2 staked in the ModifiedUnipool,
977      *         unwrap the corresponding amount of WETH into ETH, collect
978      *         rewards matured from the UniV2 staking and sent it to msg.sender.
979      *         User must approve this contract to withdraw the corresponding
980      *         amount of his UniV2 balance in behalf of him.
981      */
982     function unstake() public returns (bool) {
983         uint256 uniV2SenderBalance = modifiedUnipool.balanceOf(msg.sender);
984         require(
985             modifiedUnipool.allowance(msg.sender, address(this)) >= uniV2SenderBalance,
986             "RewardedPntWethUniV2Pair: amount not approved"
987         );
988 
989         modifiedUnipool.withdrawFrom(msg.sender, uniV2SenderBalance);
990         modifiedUnipool.getReward(msg.sender);
991 
992         uniV2.transfer(address(uniV2), uniV2SenderBalance);
993         (uint256 pntAmount, uint256 wethAmount) = uniV2.burn(address(this));
994 
995         weth.withdraw(wethAmount);
996         address(msg.sender).transfer(wethAmount);
997         pnt.transfer(msg.sender, pntAmount);
998 
999         emit Unstaked(msg.sender, pntAmount, wethAmount);
1000         return true;
1001     }
1002 
1003     /**
1004      * @notice Wrap the Ethereum sent into WETH, swap the amount sent / 2
1005      *         into WETH and put them into a PNT/WETH Uniswap pool.
1006      *         The amount of UniV2 token will be sent to ModifiedUnipool
1007      *         in order to mature rewards.
1008      * @param _user address of the user who will have UniV2 tokens in ModifiedUnipool
1009      * @param _amount amount of weth to use to perform this operation
1010      */
1011     function _stakeFor(address _user, uint256 _amount) internal {
1012         uint256 wethAmountIn = _amount / 2;
1013         (uint256 pntReserve, uint256 wethReserve, ) = uniV2.getReserves();
1014         uint256 pntAmountOut = UniswapV2Library.getAmountOut(wethAmountIn, wethReserve, pntReserve);
1015 
1016         require(
1017             allowedSlippage >=
1018                 UniswapV2Library.calculateSlippage(wethAmountIn, wethReserve, pntReserve),
1019             "RewardedPntWethUniV2Pair: too much slippage"
1020         );
1021 
1022         weth.deposit.value(_amount)();
1023         weth.transfer(address(uniV2), wethAmountIn);
1024         uniV2.swap(pntAmountOut, 0, address(this), "");
1025 
1026         pnt.safeTransfer(address(uniV2), pntAmountOut);
1027         weth.transfer(address(uniV2), wethAmountIn);
1028         uint256 liquidity = uniV2.mint(address(this));
1029 
1030         uniV2.approve(address(modifiedUnipool), liquidity);
1031         modifiedUnipool.stakeFor(_user, liquidity);
1032 
1033         emit Staked(_user, _amount);
1034     }
1035 }