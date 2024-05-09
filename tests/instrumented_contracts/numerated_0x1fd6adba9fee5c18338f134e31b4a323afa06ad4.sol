1 // SPDX-License-Identifier: AGPL-3.0
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 
7 
8 // Part: Babylonian
9 
10 // import "@uniswap/lib/contracts/libraries/Babylonian.sol";
11 library Babylonian {
12     function sqrt(int256 y) internal pure returns (int256 z) {
13         if (y > 3) {
14             z = y;
15             int256 x = y / 2 + 1;
16             while (x < z) {
17                 z = x;
18                 x = (y / x + x) / 2;
19             }
20         } else if (y != 0) {
21             z = 1;
22         }
23     }
24 }
25 
26 // Part: IPickleJar
27 
28 interface IPickleJar {
29     function balanceOf(address account) external view returns (uint256);
30     function depositAll() external;
31     function deposit(uint256 _amount) external;
32 }
33 
34 // Part: IUniswapV2Pair
35 
36 interface IUniswapV2Pair {
37     function getReserves() external view returns (
38         uint112 _reserve0, 
39         uint112 _reserve1, 
40         uint32 _blockTimestampLast
41     );
42 }
43 
44 // Part: IUniswapV2Router02
45 
46 interface IUniswapV2Router02 {
47 
48     modifier ensure(uint deadline) {
49         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
50         _;
51     }
52 
53     // **** ADD LIQUIDITY ****
54     function addLiquidityETH(
55         address token,
56         uint amountTokenDesired,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline
61     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
62 
63     function addLiquidity(
64         address tokenA,
65         address tokenB,
66         uint amountADesired,
67         uint amountBDesired,
68         uint amountAMin,
69         uint amountBMin,
70         address to,
71         uint deadline
72     ) external returns (uint amountA, uint amountB, uint liquidity);
73 
74     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
75         external
76         payable
77         returns (uint[] memory amounts);
78 
79     function swapExactTokensForTokens(
80         uint amountIn,
81         uint amountOutMin,
82         address[] calldata path,
83         address to,
84         uint deadline
85     ) external returns (uint[] memory amounts);
86 
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92 }
93 
94 // Part: IveCurveVault
95 
96 interface IveCurveVault {
97     function depositAll() external;
98     function deposit(uint256 _amount) external;
99     function approve(address spender, uint256 amount) external returns (bool);
100     function transfer(address dst, uint256 amount) external returns (bool);
101     function balanceOf(address account) external view returns (uint256);
102 }
103 
104 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Address
105 
106 /**
107  * @dev Collection of functions related to the address type
108  */
109 library Address {
110     /**
111      * @dev Returns true if `account` is a contract.
112      *
113      * [IMPORTANT]
114      * ====
115      * It is unsafe to assume that an address for which this function returns
116      * false is an externally-owned account (EOA) and not a contract.
117      *
118      * Among others, `isContract` will return false for the following
119      * types of addresses:
120      *
121      *  - an externally-owned account
122      *  - a contract in construction
123      *  - an address where a contract will be created
124      *  - an address where a contract lived, but was destroyed
125      * ====
126      */
127     function isContract(address account) internal view returns (bool) {
128         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
129         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
130         // for accounts without code, i.e. `keccak256('')`
131         bytes32 codehash;
132         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
133         // solhint-disable-next-line no-inline-assembly
134         assembly { codehash := extcodehash(account) }
135         return (codehash != accountHash && codehash != 0x0);
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
158         (bool success, ) = recipient.call{ value: amount }("");
159         require(success, "Address: unable to send value, recipient may have reverted");
160     }
161 
162     /**
163      * @dev Performs a Solidity function call using a low level `call`. A
164      * plain`call` is an unsafe replacement for a function call: use this
165      * function instead.
166      *
167      * If `target` reverts with a revert reason, it is bubbled up by this
168      * function (like regular Solidity function calls).
169      *
170      * Returns the raw returned data. To convert to the expected return value,
171      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
172      *
173      * Requirements:
174      *
175      * - `target` must be a contract.
176      * - calling `target` with `data` must not revert.
177      *
178      * _Available since v3.1._
179      */
180     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
181       return functionCall(target, data, "Address: low-level call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
186      * `errorMessage` as a fallback revert reason when `target` reverts.
187      *
188      * _Available since v3.1._
189      */
190     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
191         return _functionCallWithValue(target, data, 0, errorMessage);
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
196      * but also transferring `value` wei to `target`.
197      *
198      * Requirements:
199      *
200      * - the calling contract must have an ETH balance of at least `value`.
201      * - the called Solidity function must be `payable`.
202      *
203      * _Available since v3.1._
204      */
205     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
211      * with `errorMessage` as a fallback revert reason when `target` reverts.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
216         require(address(this).balance >= value, "Address: insufficient balance for call");
217         return _functionCallWithValue(target, data, value, errorMessage);
218     }
219 
220     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
221         require(isContract(target), "Address: call to non-contract");
222 
223         // solhint-disable-next-line avoid-low-level-calls
224         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
225         if (success) {
226             return returndata;
227         } else {
228             // Look for revert reason and bubble it up if present
229             if (returndata.length > 0) {
230                 // The easiest way to bubble the revert reason is using memory via assembly
231 
232                 // solhint-disable-next-line no-inline-assembly
233                 assembly {
234                     let returndata_size := mload(returndata)
235                     revert(add(32, returndata), returndata_size)
236                 }
237             } else {
238                 revert(errorMessage);
239             }
240         }
241     }
242 }
243 
244 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Context
245 
246 /*
247  * @dev Provides information about the current execution context, including the
248  * sender of the transaction and its data. While these are generally available
249  * via msg.sender and msg.data, they should not be accessed in such a direct
250  * manner, since when dealing with GSN meta-transactions the account sending and
251  * paying for execution may not be the actual sender (as far as an application
252  * is concerned).
253  *
254  * This contract is only required for intermediate, library-like contracts.
255  */
256 abstract contract Context {
257     function _msgSender() internal view virtual returns (address payable) {
258         return msg.sender;
259     }
260 
261     function _msgData() internal view virtual returns (bytes memory) {
262         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
263         return msg.data;
264     }
265 }
266 
267 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/IERC20
268 
269 /**
270  * @dev Interface of the ERC20 standard as defined in the EIP.
271  */
272 interface IERC20 {
273     /**
274      * @dev Returns the amount of tokens in existence.
275      */
276     function totalSupply() external view returns (uint256);
277 
278     /**
279      * @dev Returns the amount of tokens owned by `account`.
280      */
281     function balanceOf(address account) external view returns (uint256);
282 
283     /**
284      * @dev Moves `amount` tokens from the caller's account to `recipient`.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * Emits a {Transfer} event.
289      */
290     function transfer(address recipient, uint256 amount) external returns (bool);
291 
292     /**
293      * @dev Returns the remaining number of tokens that `spender` will be
294      * allowed to spend on behalf of `owner` through {transferFrom}. This is
295      * zero by default.
296      *
297      * This value changes when {approve} or {transferFrom} are called.
298      */
299     function allowance(address owner, address spender) external view returns (uint256);
300 
301     /**
302      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * IMPORTANT: Beware that changing an allowance with this method brings the risk
307      * that someone may use both the old and the new allowance by unfortunate
308      * transaction ordering. One possible solution to mitigate this race
309      * condition is to first reduce the spender's allowance to 0 and set the
310      * desired value afterwards:
311      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312      *
313      * Emits an {Approval} event.
314      */
315     function approve(address spender, uint256 amount) external returns (bool);
316 
317     /**
318      * @dev Moves `amount` tokens from `sender` to `recipient` using the
319      * allowance mechanism. `amount` is then deducted from the caller's
320      * allowance.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * Emits a {Transfer} event.
325      */
326     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
327 
328     /**
329      * @dev Emitted when `value` tokens are moved from one account (`from`) to
330      * another (`to`).
331      *
332      * Note that `value` may be zero.
333      */
334     event Transfer(address indexed from, address indexed to, uint256 value);
335 
336     /**
337      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
338      * a call to {approve}. `value` is the new allowance.
339      */
340     event Approval(address indexed owner, address indexed spender, uint256 value);
341 }
342 
343 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SafeMath
344 
345 /**
346  * @dev Wrappers over Solidity's arithmetic operations with added overflow
347  * checks.
348  *
349  * Arithmetic operations in Solidity wrap on overflow. This can easily result
350  * in bugs, because programmers usually assume that an overflow raises an
351  * error, which is the standard behavior in high level programming languages.
352  * `SafeMath` restores this intuition by reverting the transaction when an
353  * operation overflows.
354  *
355  * Using this library instead of the unchecked operations eliminates an entire
356  * class of bugs, so it's recommended to use it always.
357  */
358 library SafeMath {
359     /**
360      * @dev Returns the addition of two unsigned integers, reverting on
361      * overflow.
362      *
363      * Counterpart to Solidity's `+` operator.
364      *
365      * Requirements:
366      *
367      * - Addition cannot overflow.
368      */
369     function add(uint256 a, uint256 b) internal pure returns (uint256) {
370         uint256 c = a + b;
371         require(c >= a, "SafeMath: addition overflow");
372 
373         return c;
374     }
375 
376     /**
377      * @dev Returns the subtraction of two unsigned integers, reverting on
378      * overflow (when the result is negative).
379      *
380      * Counterpart to Solidity's `-` operator.
381      *
382      * Requirements:
383      *
384      * - Subtraction cannot overflow.
385      */
386     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
387         return sub(a, b, "SafeMath: subtraction overflow");
388     }
389 
390     /**
391      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
392      * overflow (when the result is negative).
393      *
394      * Counterpart to Solidity's `-` operator.
395      *
396      * Requirements:
397      *
398      * - Subtraction cannot overflow.
399      */
400     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
401         require(b <= a, errorMessage);
402         uint256 c = a - b;
403 
404         return c;
405     }
406 
407     /**
408      * @dev Returns the multiplication of two unsigned integers, reverting on
409      * overflow.
410      *
411      * Counterpart to Solidity's `*` operator.
412      *
413      * Requirements:
414      *
415      * - Multiplication cannot overflow.
416      */
417     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
418         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
419         // benefit is lost if 'b' is also tested.
420         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
421         if (a == 0) {
422             return 0;
423         }
424 
425         uint256 c = a * b;
426         require(c / a == b, "SafeMath: multiplication overflow");
427 
428         return c;
429     }
430 
431     /**
432      * @dev Returns the integer division of two unsigned integers. Reverts on
433      * division by zero. The result is rounded towards zero.
434      *
435      * Counterpart to Solidity's `/` operator. Note: this function uses a
436      * `revert` opcode (which leaves remaining gas untouched) while Solidity
437      * uses an invalid opcode to revert (consuming all remaining gas).
438      *
439      * Requirements:
440      *
441      * - The divisor cannot be zero.
442      */
443     function div(uint256 a, uint256 b) internal pure returns (uint256) {
444         return div(a, b, "SafeMath: division by zero");
445     }
446 
447     /**
448      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
449      * division by zero. The result is rounded towards zero.
450      *
451      * Counterpart to Solidity's `/` operator. Note: this function uses a
452      * `revert` opcode (which leaves remaining gas untouched) while Solidity
453      * uses an invalid opcode to revert (consuming all remaining gas).
454      *
455      * Requirements:
456      *
457      * - The divisor cannot be zero.
458      */
459     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
460         require(b > 0, errorMessage);
461         uint256 c = a / b;
462         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
463 
464         return c;
465     }
466 
467     /**
468      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
469      * Reverts when dividing by zero.
470      *
471      * Counterpart to Solidity's `%` operator. This function uses a `revert`
472      * opcode (which leaves remaining gas untouched) while Solidity uses an
473      * invalid opcode to revert (consuming all remaining gas).
474      *
475      * Requirements:
476      *
477      * - The divisor cannot be zero.
478      */
479     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
480         return mod(a, b, "SafeMath: modulo by zero");
481     }
482 
483     /**
484      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
485      * Reverts with custom message when dividing by zero.
486      *
487      * Counterpart to Solidity's `%` operator. This function uses a `revert`
488      * opcode (which leaves remaining gas untouched) while Solidity uses an
489      * invalid opcode to revert (consuming all remaining gas).
490      *
491      * Requirements:
492      *
493      * - The divisor cannot be zero.
494      */
495     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
496         require(b != 0, errorMessage);
497         return a % b;
498     }
499 }
500 
501 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SignedSafeMath
502 
503 /**
504  * @title SignedSafeMath
505  * @dev Signed math operations with safety checks that revert on error.
506  */
507 library SignedSafeMath {
508     int256 constant private _INT256_MIN = -2**255;
509 
510         /**
511      * @dev Returns the multiplication of two signed integers, reverting on
512      * overflow.
513      *
514      * Counterpart to Solidity's `*` operator.
515      *
516      * Requirements:
517      *
518      * - Multiplication cannot overflow.
519      */
520     function mul(int256 a, int256 b) internal pure returns (int256) {
521         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
522         // benefit is lost if 'b' is also tested.
523         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
524         if (a == 0) {
525             return 0;
526         }
527 
528         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
529 
530         int256 c = a * b;
531         require(c / a == b, "SignedSafeMath: multiplication overflow");
532 
533         return c;
534     }
535 
536     /**
537      * @dev Returns the integer division of two signed integers. Reverts on
538      * division by zero. The result is rounded towards zero.
539      *
540      * Counterpart to Solidity's `/` operator. Note: this function uses a
541      * `revert` opcode (which leaves remaining gas untouched) while Solidity
542      * uses an invalid opcode to revert (consuming all remaining gas).
543      *
544      * Requirements:
545      *
546      * - The divisor cannot be zero.
547      */
548     function div(int256 a, int256 b) internal pure returns (int256) {
549         require(b != 0, "SignedSafeMath: division by zero");
550         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
551 
552         int256 c = a / b;
553 
554         return c;
555     }
556 
557     /**
558      * @dev Returns the subtraction of two signed integers, reverting on
559      * overflow.
560      *
561      * Counterpart to Solidity's `-` operator.
562      *
563      * Requirements:
564      *
565      * - Subtraction cannot overflow.
566      */
567     function sub(int256 a, int256 b) internal pure returns (int256) {
568         int256 c = a - b;
569         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
570 
571         return c;
572     }
573 
574     /**
575      * @dev Returns the addition of two signed integers, reverting on
576      * overflow.
577      *
578      * Counterpart to Solidity's `+` operator.
579      *
580      * Requirements:
581      *
582      * - Addition cannot overflow.
583      */
584     function add(int256 a, int256 b) internal pure returns (int256) {
585         int256 c = a + b;
586         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
587 
588         return c;
589     }
590 }
591 
592 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Ownable
593 
594 /**
595  * @dev Contract module which provides a basic access control mechanism, where
596  * there is an account (an owner) that can be granted exclusive access to
597  * specific functions.
598  *
599  * By default, the owner account will be the one that deploys the contract. This
600  * can later be changed with {transferOwnership}.
601  *
602  * This module is used through inheritance. It will make available the modifier
603  * `onlyOwner`, which can be applied to your functions to restrict their use to
604  * the owner.
605  */
606 contract Ownable is Context {
607     address private _owner;
608 
609     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
610 
611     /**
612      * @dev Initializes the contract setting the deployer as the initial owner.
613      */
614     constructor () internal {
615         address msgSender = _msgSender();
616         _owner = msgSender;
617         emit OwnershipTransferred(address(0), msgSender);
618     }
619 
620     /**
621      * @dev Returns the address of the current owner.
622      */
623     function owner() public view returns (address) {
624         return _owner;
625     }
626 
627     /**
628      * @dev Throws if called by any account other than the owner.
629      */
630     modifier onlyOwner() {
631         require(_owner == _msgSender(), "Ownable: caller is not the owner");
632         _;
633     }
634 
635     /**
636      * @dev Leaves the contract without owner. It will not be possible to call
637      * `onlyOwner` functions anymore. Can only be called by the current owner.
638      *
639      * NOTE: Renouncing ownership will leave the contract without an owner,
640      * thereby removing any functionality that is only available to the owner.
641      */
642     function renounceOwnership() public virtual onlyOwner {
643         emit OwnershipTransferred(_owner, address(0));
644         _owner = address(0);
645     }
646 
647     /**
648      * @dev Transfers ownership of the contract to a new account (`newOwner`).
649      * Can only be called by the current owner.
650      */
651     function transferOwnership(address newOwner) public virtual onlyOwner {
652         require(newOwner != address(0), "Ownable: new owner is the zero address");
653         emit OwnershipTransferred(_owner, newOwner);
654         _owner = newOwner;
655     }
656 }
657 
658 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SafeERC20
659 
660 /**
661  * @title SafeERC20
662  * @dev Wrappers around ERC20 operations that throw on failure (when the token
663  * contract returns false). Tokens that return no value (and instead revert or
664  * throw on failure) are also supported, non-reverting calls are assumed to be
665  * successful.
666  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
667  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
668  */
669 library SafeERC20 {
670     using SafeMath for uint256;
671     using Address for address;
672 
673     function safeTransfer(IERC20 token, address to, uint256 value) internal {
674         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
675     }
676 
677     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
678         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
679     }
680 
681     /**
682      * @dev Deprecated. This function has issues similar to the ones found in
683      * {IERC20-approve}, and its usage is discouraged.
684      *
685      * Whenever possible, use {safeIncreaseAllowance} and
686      * {safeDecreaseAllowance} instead.
687      */
688     function safeApprove(IERC20 token, address spender, uint256 value) internal {
689         // safeApprove should only be called when setting an initial allowance,
690         // or when resetting it to zero. To increase and decrease it, use
691         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
692         // solhint-disable-next-line max-line-length
693         require((value == 0) || (token.allowance(address(this), spender) == 0),
694             "SafeERC20: approve from non-zero to non-zero allowance"
695         );
696         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
697     }
698 
699     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
700         uint256 newAllowance = token.allowance(address(this), spender).add(value);
701         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
702     }
703 
704     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
705         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
706         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
707     }
708 
709     /**
710      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
711      * on the return value: the return value is optional (but if data is returned, it must not be false).
712      * @param token The token targeted by the call.
713      * @param data The call data (encoded using abi.encode or one of its variants).
714      */
715     function _callOptionalReturn(IERC20 token, bytes memory data) private {
716         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
717         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
718         // the target address contains contract code and also asserts for success in the low-level call.
719 
720         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
721         if (returndata.length > 0) { // Return data is optional
722             // solhint-disable-next-line max-line-length
723             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
724         }
725     }
726 }
727 
728 // File: ZapYveCrvEthLPsToPickle.sol
729 
730 contract ZapYveCrvEthLPsToPickle is Ownable {
731     using SafeERC20 for IERC20;
732     using Address for address;
733     using SafeMath for uint256;
734     using SignedSafeMath for int256;
735 
736     // Tokens
737     address public constant ethYveCrv = 0x10B47177E92Ef9D5C6059055d92DdF6290848991; // LP Token
738     address public constant yveCrv = 0xc5bDdf9843308380375a611c18B50Fb9341f502A;
739     address public constant crv = 0xD533a949740bb3306d119CC777fa900bA034cd52;
740     address public constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
741     IPickleJar public pickleJar = IPickleJar(0x5Eff6d166D66BacBC1BF52E2C54dD391AE6b1f48);
742     IveCurveVault public yVault = IveCurveVault(yveCrv);
743 
744     // DEXes
745     address public activeDex = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F; // Sushi default
746     address public sushiswapRouter = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F;
747     address public uniswapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
748     IUniswapV2Router02 public swapRouter;
749     
750     // ETH/CRV pair we want to swap with
751     address public swapPair = 0x58Dc5a51fE44589BEb22E8CE67720B5BC5378009; // Initialize with Sushiswap
752     address public sushiswapPair = 0x58Dc5a51fE44589BEb22E8CE67720B5BC5378009;
753     address public uniswapPair = 0x3dA1313aE46132A397D90d95B1424A9A7e3e0fCE;
754     
755     // Dex swap paths
756     address[] public swapEthPath;
757     address[] public swapCrvPath;
758     address[] public swapForYveCrvPath;
759 
760     // Misc
761     address payable public governance = 0xFEB4acf3df3cDEA7399794D0869ef76A6EfAff52;
762 
763     modifier onlyGovernance() {
764         require(msg.sender == governance, "!authorized");
765         _;
766     }
767 
768     constructor() public Ownable() {
769         // Initialize with Sushiswap
770         swapRouter = IUniswapV2Router02(activeDex);
771 
772         // Setup some initial approvals
773         IERC20(crv).safeApprove(activeDex, uint256(-1)); // For curve swaps on dex
774         IERC20(weth).safeApprove(activeDex, uint256(-1)); // For staking into pickle jar
775         IERC20(crv).safeApprove(yveCrv, uint256(-1));// approve vault to take curve
776         IERC20(yveCrv).safeApprove(sushiswapRouter, uint256(-1));
777         IERC20(ethYveCrv).safeApprove(address(pickleJar), uint256(-1)); // For staking into pickle jar
778 
779         swapEthPath = new address[](2);
780         swapEthPath[0] = weth;
781         swapEthPath[1] = crv;
782 
783         swapCrvPath = new address[](2);
784         swapCrvPath[0] = crv;
785         swapCrvPath[1] = weth;
786 
787         swapForYveCrvPath = new address[](2);
788         swapForYveCrvPath[0] = weth;
789         swapForYveCrvPath[1] = yveCrv;
790     }
791 
792     function setGovernance(address payable _governance) external onlyGovernance {
793         governance = _governance;
794     }
795 
796     /*  ETH Zap  */
797     function zapInETH() external payable {
798         _zapIn(true, msg.value);
799     }
800 
801     /*  CRV Zap  (denominated in wei) */
802     function zapInCRV(uint256 crvAmount) external {
803         require(crvAmount != 0, "0 CRV");
804         IERC20(crv).transferFrom(msg.sender, address(this), crvAmount);
805         _zapIn(false, IERC20(crv).balanceOf(address(this))); // Include any dust from prev txns
806     }
807 
808     function _zapIn(bool _isEth, uint256 _haveAmount) internal returns (uint256) {
809         IUniswapV2Pair lpPair = IUniswapV2Pair(ethYveCrv); // Pair we LP against
810         (uint112 lpReserveA, uint112 lpReserveB, ) = lpPair.getReserves();
811 
812         //  Check if it's worthwhile to use the Yearn yveCRV vault
813         bool useVault = shouldUseVault(lpReserveA, lpReserveB);
814 
815         // Logic tree below is used to calculate amounts and then swap based on useVault and Zap token type
816         if(useVault){
817             // Calculate swap amount
818             uint256 amountToSwap = calculateSwapAmount(_isEth, _haveAmount);
819             _tokenSwap(_isEth, amountToSwap);
820             yVault.depositAll();
821         }
822         else{
823             if(_isEth){
824                 // Calculate the swap needed for the right amount of yveCRV for a single-sided deposit
825                 int256 amountToSell = calculateSingleSided(lpReserveA, address(this).balance);
826                 swapRouter.swapExactETHForTokens{value: uint256(amountToSell)}(1, swapForYveCrvPath, address(this), now);
827             }
828             else{
829                 // User sent CRV: Must convert all CRV to WETH first, not ETH - this will save some gas when LP'ing
830                 uint amountWeth = IUniswapV2Router02(sushiswapRouter).swapExactTokensForTokens(_haveAmount, 0, swapCrvPath, address(this), now)[swapCrvPath.length - 1];
831                 int256 amountToSell = calculateSingleSided(lpReserveA, amountWeth);
832                 swapRouter.swapExactTokensForTokens(uint256(amountToSell), 1, swapForYveCrvPath, address(this), now);
833             }           
834         }
835         
836         //  Add liquidity based on whether we're holding ETH or WETH
837         if(_isEth){
838             IUniswapV2Router02(sushiswapRouter).addLiquidityETH{value: address(this).balance}( 
839                 yveCrv, yVault.balanceOf(address(this)), 1, 1, address(this), now
840             );
841         }
842         else{
843             //  To save gas, CRV handles only weth, so we use a different function to add liquidity when holding weth
844             IUniswapV2Router02(sushiswapRouter).addLiquidity(
845                 yveCrv, weth, yVault.balanceOf(address(this)), IERC20(weth).balanceOf(address(this)), 0, 0, address(this), now
846             );
847         }
848        
849         //  Deposit LP tokens to Pickle jar and send tokens back to user
850         pickleJar.depositAll();
851         IERC20(address(pickleJar)).safeTransfer(msg.sender, pickleJar.balanceOf(address(this)));
852 
853         // This is where we would stake pickle jar tokens but unfortunately
854         // the Pickle staking contract does not permit deposits 
855         // on behalf of another user / address
856         // https://github.com/pickle-finance/protocol/blob/db62174dd0c95839057c91406ee361575530b359/src/yield-farming/masterchef.sol#L212
857     }
858 
859     function _tokenSwap(bool _isEth, uint256 _amountIn) internal returns (uint256) {
860         uint256 amountOut = 0;
861         if (_isEth) {
862             amountOut = swapRouter.swapExactETHForTokens{value: _amountIn}(1, swapEthPath, address(this), now)[swapEthPath.length - 1];
863         } else {
864             // Buy WETH, not ETH - this will save some gas when LP'ing
865             amountOut = swapRouter.swapExactTokensForTokens(_amountIn, 0, swapCrvPath, address(this), now)[swapCrvPath.length - 1];
866         }
867         require(amountOut > 0, "Error Swapping Tokens");
868         return amountOut;
869     }
870 
871     function setActiveDex(uint256 exchange) public onlyGovernance {
872         if(exchange == 0){
873             activeDex = sushiswapRouter;
874             swapPair = sushiswapPair;
875         }else if (exchange == 1) {
876             activeDex = uniswapRouter;
877             swapPair = uniswapPair;
878         }else{
879             require(false, "incorrect pool");
880         }
881         swapRouter = IUniswapV2Router02(activeDex);
882         IERC20(crv).safeApprove(activeDex, uint256(-1));
883         IERC20(weth).safeApprove(activeDex, uint256(-1));
884     }
885 
886     function sweep(address _token) external onlyGovernance {
887         IERC20(_token).safeTransfer(governance, IERC20(_token).balanceOf(address(this)));
888         uint256 balance = address(this).balance;
889         if(balance > 0){
890             governance.transfer(balance);
891         }
892     }
893 
894     function shouldUseVault(uint256 lpReserveA, uint256 lpReserveB) internal view returns (bool) {
895         uint256 safetyFactor = 1e5; // For extra precision
896         // Get asset ratio of swap pair
897         IUniswapV2Pair pair = IUniswapV2Pair(swapPair); // Pair we might want to swap against
898         (uint256 reserveA, uint256 reserveB, ) = pair.getReserves();
899         uint256 pool1ratio = reserveB.mul(safetyFactor).div(reserveA);
900         // Get asset ratio of LP pair
901         uint256 pool2ratio = lpReserveB.mul(safetyFactor).div(lpReserveA);
902         return pool1ratio > pool2ratio; // Use vault only if pool 2 offers a better price
903     }
904 
905     function calculateSingleSided(uint256 reserveIn, uint256 userIn) internal pure returns (int256) {
906         return
907             Babylonian.sqrt(
908                 int256(reserveIn).mul(int256(userIn).mul(3988000) + int256(reserveIn).mul(3988009))
909             ).sub(int256(reserveIn).mul(1997)) / 1994;
910     }
911 
912     // This function goes into some complex math which is explained here: 
913     // https://hackmd.io/@Ap_76vwNTg-vxJxbiaLMMQ/rkoFT_bz_
914     function calculateSwapAmount(bool _isEth, uint256 _haveAmount) internal view returns (uint256) {
915         IUniswapV2Pair pair = IUniswapV2Pair(swapPair); // Pair we swap against
916         (uint256 reserveA, uint256 reserveB, ) = pair.getReserves();
917         int256 pool1HaveReserve = 0;
918         int256 pool1WantReserve = 0;
919         int256 rb = 0;
920         int256 ra = 0;
921         
922         if(_isEth){
923             pool1HaveReserve = int256(reserveA);
924             pool1WantReserve = int256(reserveB);
925         }
926         else{
927             pool1HaveReserve = int256(reserveB);
928             pool1WantReserve = int256(reserveA);
929         }
930         
931         pair = IUniswapV2Pair(ethYveCrv); // Pair we swap against
932         (reserveA, reserveB, ) = pair.getReserves();
933         if(_isEth){
934             ra = int256(reserveB);
935             rb = int256(reserveA);
936         }
937         else{
938             ra = int256(reserveA);
939             rb = int256(reserveB);
940         }
941         
942         int256 numToSquare = int256(_haveAmount).mul(997); // This line and the next one add together a part of the formula...
943         numToSquare = numToSquare.add(pool1HaveReserve.mul(1000)); // ...which we'll need to square later on.
944         int256 FACTOR = 1e20; // To help with precision
945 
946         // LINE 1
947         int256 h = int256(_haveAmount); // re-assert this or else stack will get too deep and forget it
948         int256 a = pool1WantReserve.mul(-1994).mul(ra).div(rb);
949         int256 b = h.mul(997);
950         b = b.sub(pool1HaveReserve.mul(1000));
951         b = a.mul(b);
952 
953         // LINE 2
954         a = ra.mul(ra).mul(FACTOR).div(rb);
955         a = a.div(rb); // We lose some precision here
956         int256 c = numToSquare.mul(numToSquare);
957         a = c.mul(a).div(FACTOR);
958         a = b.add(a); // Add result to total
959         
960         // LINE 3
961         int256 r = pool1WantReserve.mul(pool1WantReserve);
962         r = r.mul(994009);
963         a = a.add(r); // Add result to total
964         
965         // Sqaure what we have so far
966         int256 sq = Babylonian.sqrt(a);
967         
968         // LINE 4
969         b = h.mul(997).mul(ra).mul(FACTOR).div(rb);
970         
971         // LINE 5
972         FACTOR = 1e20; // re-state, otherwise stack depth is exceeded
973         r = pool1HaveReserve.mul(1000);
974         r = r.mul(ra).mul(FACTOR);
975         r = r.div(rb);
976         h = pool1WantReserve.mul(-997);
977         h = h.mul(FACTOR).sub(r);
978         b = b.add(h).div(FACTOR);
979         b = b.add(sq);
980         
981         // LINE 6
982         a = ra.mul(1994);
983         a = a.mul(FACTOR).div(rb); // We lose some precision here
984         return uint256(b.mul(FACTOR).div(a));
985     }
986 
987     receive() external payable {
988         _zapIn(true, msg.value);
989     }
990 }
