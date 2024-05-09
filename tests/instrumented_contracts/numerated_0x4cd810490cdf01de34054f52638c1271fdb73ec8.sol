1 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
2 
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin\contracts\GSN\Context.sol
28 
29 // SPDX-License-Identifier: MIT
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 // File: @openzeppelin\contracts\access\Ownable.sol
34 
35 
36 pragma solidity >=0.6.0 <0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor () internal {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
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
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         emit OwnershipTransferred(_owner, newOwner);
98         _owner = newOwner;
99     }
100 }
101 
102 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
103 
104 
105 pragma solidity >=0.6.0 <0.8.0;
106 
107 /**
108  * @dev Interface of the ERC20 standard as defined in the EIP.
109  */
110 interface IERC20 {
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `recipient`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `sender` to `recipient` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
168      * another (`to`).
169      *
170      * Note that `value` may be zero.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 value);
173 
174     /**
175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176      * a call to {approve}. `value` is the new allowance.
177      */
178     event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
182 
183 
184 pragma solidity >=0.6.0 <0.8.0;
185 
186 /**
187  * @dev Wrappers over Solidity's arithmetic operations with added overflow
188  * checks.
189  *
190  * Arithmetic operations in Solidity wrap on overflow. This can easily result
191  * in bugs, because programmers usually assume that an overflow raises an
192  * error, which is the standard behavior in high level programming languages.
193  * `SafeMath` restores this intuition by reverting the transaction when an
194  * operation overflows.
195  *
196  * Using this library instead of the unchecked operations eliminates an entire
197  * class of bugs, so it's recommended to use it always.
198  */
199 library SafeMath {
200     /**
201      * @dev Returns the addition of two unsigned integers, with an overflow flag.
202      *
203      * _Available since v3.4._
204      */
205     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
206         uint256 c = a + b;
207         if (c < a) return (false, 0);
208         return (true, c);
209     }
210 
211     /**
212      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
213      *
214      * _Available since v3.4._
215      */
216     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
217         if (b > a) return (false, 0);
218         return (true, a - b);
219     }
220 
221     /**
222      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
223      *
224      * _Available since v3.4._
225      */
226     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
228         // benefit is lost if 'b' is also tested.
229         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
230         if (a == 0) return (true, 0);
231         uint256 c = a * b;
232         if (c / a != b) return (false, 0);
233         return (true, c);
234     }
235 
236     /**
237      * @dev Returns the division of two unsigned integers, with a division by zero flag.
238      *
239      * _Available since v3.4._
240      */
241     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
242         if (b == 0) return (false, 0);
243         return (true, a / b);
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
248      *
249      * _Available since v3.4._
250      */
251     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         if (b == 0) return (false, 0);
253         return (true, a % b);
254     }
255 
256     /**
257      * @dev Returns the addition of two unsigned integers, reverting on
258      * overflow.
259      *
260      * Counterpart to Solidity's `+` operator.
261      *
262      * Requirements:
263      *
264      * - Addition cannot overflow.
265      */
266     function add(uint256 a, uint256 b) internal pure returns (uint256) {
267         uint256 c = a + b;
268         require(c >= a, "SafeMath: addition overflow");
269         return c;
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting on
274      * overflow (when the result is negative).
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      *
280      * - Subtraction cannot overflow.
281      */
282     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
283         require(b <= a, "SafeMath: subtraction overflow");
284         return a - b;
285     }
286 
287     /**
288      * @dev Returns the multiplication of two unsigned integers, reverting on
289      * overflow.
290      *
291      * Counterpart to Solidity's `*` operator.
292      *
293      * Requirements:
294      *
295      * - Multiplication cannot overflow.
296      */
297     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
298         if (a == 0) return 0;
299         uint256 c = a * b;
300         require(c / a == b, "SafeMath: multiplication overflow");
301         return c;
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers, reverting on
306      * division by zero. The result is rounded towards zero.
307      *
308      * Counterpart to Solidity's `/` operator. Note: this function uses a
309      * `revert` opcode (which leaves remaining gas untouched) while Solidity
310      * uses an invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function div(uint256 a, uint256 b) internal pure returns (uint256) {
317         require(b > 0, "SafeMath: division by zero");
318         return a / b;
319     }
320 
321     /**
322      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
323      * reverting when dividing by zero.
324      *
325      * Counterpart to Solidity's `%` operator. This function uses a `revert`
326      * opcode (which leaves remaining gas untouched) while Solidity uses an
327      * invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      *
331      * - The divisor cannot be zero.
332      */
333     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
334         require(b > 0, "SafeMath: modulo by zero");
335         return a % b;
336     }
337 
338     /**
339      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
340      * overflow (when the result is negative).
341      *
342      * CAUTION: This function is deprecated because it requires allocating memory for the error
343      * message unnecessarily. For custom revert reasons use {trySub}.
344      *
345      * Counterpart to Solidity's `-` operator.
346      *
347      * Requirements:
348      *
349      * - Subtraction cannot overflow.
350      */
351     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
352         require(b <= a, errorMessage);
353         return a - b;
354     }
355 
356     /**
357      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
358      * division by zero. The result is rounded towards zero.
359      *
360      * CAUTION: This function is deprecated because it requires allocating memory for the error
361      * message unnecessarily. For custom revert reasons use {tryDiv}.
362      *
363      * Counterpart to Solidity's `/` operator. Note: this function uses a
364      * `revert` opcode (which leaves remaining gas untouched) while Solidity
365      * uses an invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
372         require(b > 0, errorMessage);
373         return a / b;
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
391     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
392         require(b > 0, errorMessage);
393         return a % b;
394     }
395 }
396 
397 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
398 
399 pragma solidity >=0.6.2 <0.8.0;
400 
401 /**
402  * @dev Collection of functions related to the address type
403  */
404 library Address {
405     /**
406      * @dev Returns true if `account` is a contract.
407      *
408      * [IMPORTANT]
409      * ====
410      * It is unsafe to assume that an address for which this function returns
411      * false is an externally-owned account (EOA) and not a contract.
412      *
413      * Among others, `isContract` will return false for the following
414      * types of addresses:
415      *
416      *  - an externally-owned account
417      *  - a contract in construction
418      *  - an address where a contract will be created
419      *  - an address where a contract lived, but was destroyed
420      * ====
421      */
422     function isContract(address account) internal view returns (bool) {
423         // This method relies on extcodesize, which returns 0 for contracts in
424         // construction, since the code is only stored at the end of the
425         // constructor execution.
426 
427         uint256 size;
428         // solhint-disable-next-line no-inline-assembly
429         assembly { size := extcodesize(account) }
430         return size > 0;
431     }
432 
433     /**
434      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
435      * `recipient`, forwarding all available gas and reverting on errors.
436      *
437      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
438      * of certain opcodes, possibly making contracts go over the 2300 gas limit
439      * imposed by `transfer`, making them unable to receive funds via
440      * `transfer`. {sendValue} removes this limitation.
441      *
442      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
443      *
444      * IMPORTANT: because control is transferred to `recipient`, care must be
445      * taken to not create reentrancy vulnerabilities. Consider using
446      * {ReentrancyGuard} or the
447      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
448      */
449     function sendValue(address payable recipient, uint256 amount) internal {
450         require(address(this).balance >= amount, "Address: insufficient balance");
451 
452         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
453         (bool success, ) = recipient.call{ value: amount }("");
454         require(success, "Address: unable to send value, recipient may have reverted");
455     }
456 
457     /**
458      * @dev Performs a Solidity function call using a low level `call`. A
459      * plain`call` is an unsafe replacement for a function call: use this
460      * function instead.
461      *
462      * If `target` reverts with a revert reason, it is bubbled up by this
463      * function (like regular Solidity function calls).
464      *
465      * Returns the raw returned data. To convert to the expected return value,
466      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
467      *
468      * Requirements:
469      *
470      * - `target` must be a contract.
471      * - calling `target` with `data` must not revert.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
476       return functionCall(target, data, "Address: low-level call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
481      * `errorMessage` as a fallback revert reason when `target` reverts.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
486         return functionCallWithValue(target, data, 0, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but also transferring `value` wei to `target`.
492      *
493      * Requirements:
494      *
495      * - the calling contract must have an ETH balance of at least `value`.
496      * - the called Solidity function must be `payable`.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
501         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
506      * with `errorMessage` as a fallback revert reason when `target` reverts.
507      *
508      * _Available since v3.1._
509      */
510     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
511         require(address(this).balance >= value, "Address: insufficient balance for call");
512         require(isContract(target), "Address: call to non-contract");
513 
514         // solhint-disable-next-line avoid-low-level-calls
515         (bool success, bytes memory returndata) = target.call{ value: value }(data);
516         return _verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
521      * but performing a static call.
522      *
523      * _Available since v3.3._
524      */
525     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
526         return functionStaticCall(target, data, "Address: low-level static call failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
531      * but performing a static call.
532      *
533      * _Available since v3.3._
534      */
535     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
536         require(isContract(target), "Address: static call to non-contract");
537 
538         // solhint-disable-next-line avoid-low-level-calls
539         (bool success, bytes memory returndata) = target.staticcall(data);
540         return _verifyCallResult(success, returndata, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but performing a delegate call.
546      *
547      * _Available since v3.4._
548      */
549     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
550         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
555      * but performing a delegate call.
556      *
557      * _Available since v3.4._
558      */
559     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
560         require(isContract(target), "Address: delegate call to non-contract");
561 
562         // solhint-disable-next-line avoid-low-level-calls
563         (bool success, bytes memory returndata) = target.delegatecall(data);
564         return _verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
568         if (success) {
569             return returndata;
570         } else {
571             // Look for revert reason and bubble it up if present
572             if (returndata.length > 0) {
573                 // The easiest way to bubble the revert reason is using memory via assembly
574 
575                 // solhint-disable-next-line no-inline-assembly
576                 assembly {
577                     let returndata_size := mload(returndata)
578                     revert(add(32, returndata), returndata_size)
579                 }
580             } else {
581                 revert(errorMessage);
582             }
583         }
584     }
585 }
586 
587 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
588 
589 
590 pragma solidity >=0.6.0 <0.8.0;
591 
592 
593 
594 
595 /**
596  * @title SafeERC20
597  * @dev Wrappers around ERC20 operations that throw on failure (when the token
598  * contract returns false). Tokens that return no value (and instead revert or
599  * throw on failure) are also supported, non-reverting calls are assumed to be
600  * successful.
601  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
602  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
603  */
604 library SafeERC20 {
605     using SafeMath for uint256;
606     using Address for address;
607 
608     function safeTransfer(IERC20 token, address to, uint256 value) internal {
609         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
610     }
611 
612     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
613         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
614     }
615 
616     /**
617      * @dev Deprecated. This function has issues similar to the ones found in
618      * {IERC20-approve}, and its usage is discouraged.
619      *
620      * Whenever possible, use {safeIncreaseAllowance} and
621      * {safeDecreaseAllowance} instead.
622      */
623     function safeApprove(IERC20 token, address spender, uint256 value) internal {
624         // safeApprove should only be called when setting an initial allowance,
625         // or when resetting it to zero. To increase and decrease it, use
626         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
627         // solhint-disable-next-line max-line-length
628         require((value == 0) || (token.allowance(address(this), spender) == 0),
629             "SafeERC20: approve from non-zero to non-zero allowance"
630         );
631         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
632     }
633 
634     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
635         uint256 newAllowance = token.allowance(address(this), spender).add(value);
636         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
637     }
638 
639     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
640         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
641         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
642     }
643 
644     /**
645      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
646      * on the return value: the return value is optional (but if data is returned, it must not be false).
647      * @param token The token targeted by the call.
648      * @param data The call data (encoded using abi.encode or one of its variants).
649      */
650     function _callOptionalReturn(IERC20 token, bytes memory data) private {
651         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
652         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
653         // the target address contains contract code and also asserts for success in the low-level call.
654 
655         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
656         if (returndata.length > 0) { // Return data is optional
657             // solhint-disable-next-line max-line-length
658             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
659         }
660     }
661 }
662 
663 
664 
665 // File: contracts\LiquidityMining.sol
666 
667 pragma solidity 0.6.12;
668 
669 
670 
671 
672 
673 
674 
675 contract LiquidityMining is Ownable {
676     using SafeMath for uint256;
677     using SafeERC20 for IERC20;
678 
679     uint256 private constant DECIMALS = 18;
680     uint256 private constant UNITS = 10**DECIMALS;
681 
682     // Info of each user.
683     struct UserInfo {
684         uint256 amount; // How many LP tokens the user has provided.
685         uint256 rewardDebt; // Reward debt. See explanation below.
686         uint256 rewardDebtAtBlock; // the last block user stake
687     }
688 
689     // Info of each pool.
690     struct PoolInfo {
691         IERC20 token; // Address of LP token contract.
692         uint256 tokenPerBlock; // TOKENs to distribute per block.
693         uint256 lastRewardBlock; // Last block number that TOKEN distribution occurs.
694         uint256 accTokenPerShare; // Accumulated TOKENs per share, times 1e18 (UNITS).
695     }
696 
697     IERC20 public immutable token;
698     address public tokenRewardsAddress;
699 
700     // The block number when TOKEN mining starts.
701     uint256 public immutable START_BLOCK;
702 
703     // Info of each pool.
704     PoolInfo[] public poolInfo;
705 
706     // tokenToPoolId
707     mapping(address => uint256) public tokenToPoolId;
708 
709     // Info of each user that stakes LP tokens. pid => user address => info
710     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
711 
712     event Deposit(address indexed user, uint256 indexed poolId, uint256 amount);
713 
714     event Withdraw(
715         address indexed user,
716         uint256 indexed poolId,
717         uint256 amount
718     );
719 
720     event EmergencyWithdraw(
721         address indexed user,
722         uint256 indexed poolId,
723         uint256 amount
724     );
725 
726     event SendTokenReward(
727         address indexed user,
728         uint256 indexed poolId,
729         uint256 amount
730     );
731 
732     //set token sc, reward address and start block
733     constructor(
734         address _tokenAddress,
735         address _tokenRewardsAddress,
736         uint256 _startBlock
737     ) public {
738         require(_tokenAddress != address(0),"error zero address");
739         require(_tokenRewardsAddress != address(0),"error zero address");
740         token = IERC20(_tokenAddress);
741         tokenRewardsAddress = _tokenRewardsAddress;
742         START_BLOCK = _startBlock;
743     }
744 
745     /********************** PUBLIC ********************************/
746 
747     // Add a new erc20 token to the pool. Can only be called by the owner.
748     function add(
749         uint256 _tokenPerBlock,
750         IERC20 _token,
751         bool _withUpdate
752     ) external onlyOwner {
753         require(
754             tokenToPoolId[address(_token)] == 0,
755             "Token is already in pool"
756         );
757 
758         if (_withUpdate) {
759             massUpdatePools();
760         }
761 
762         uint256 lastRewardBlock =
763             block.number > START_BLOCK ? block.number : START_BLOCK;
764 
765         tokenToPoolId[address(_token)] = poolInfo.length + 1;
766 
767         poolInfo.push(
768             PoolInfo({
769                 token: _token,
770                 tokenPerBlock: _tokenPerBlock,
771                 lastRewardBlock: lastRewardBlock,
772                 accTokenPerShare: 0
773             })
774         );
775     }
776 
777     // Update the given pool's TOKEN allocation point. Can only be called by the owner.
778     function set(
779         uint256 _poolId,
780         uint256 _tokenPerBlock,
781         bool _withUpdate
782     ) external onlyOwner {
783         if (_withUpdate) {
784             massUpdatePools();
785         }
786 
787         poolInfo[_poolId].tokenPerBlock = _tokenPerBlock;
788     }
789 
790     // Update reward variables for all pools. Be careful of gas spending!
791     function massUpdatePools() public {
792         uint256 length = poolInfo.length;
793 
794         for (uint256 poolId = 0; poolId < length; ++poolId) {
795             updatePool(poolId);
796         }
797     }
798 
799     // Update reward variables of the given pool to be up-to-date.
800     function updatePool(uint256 _poolId) public {
801         PoolInfo storage pool = poolInfo[_poolId];
802 
803         // Return if it's too early (if START_BLOCK is in the future probably)
804         if (block.number <= pool.lastRewardBlock) return;
805 
806         // Retrieve amount of tokens held in contract
807         uint256 poolBalance = pool.token.balanceOf(address(this));
808 
809         // If the contract holds no tokens at all, don't proceed.
810         if (poolBalance == 0) {
811             pool.lastRewardBlock = block.number;
812             return;
813         }
814 
815         // Calculate the amount of TOKEN to send to the contract to pay out for this pool
816         uint256 rewards =
817             getPoolReward(pool.lastRewardBlock, block.number, pool.tokenPerBlock);
818 
819         // Update the accumulated TOKENPerShare
820         pool.accTokenPerShare = pool.accTokenPerShare.add(
821             rewards.mul(UNITS).div(poolBalance)
822         );
823 
824         // Update the last block
825         pool.lastRewardBlock = block.number;
826     }
827 
828     // Get rewards for a specific amount of TOKENPerBlocks
829     function getPoolReward(
830         uint256 _from,
831         uint256 _to,
832         uint256 _tokenPerBlock
833     ) public view returns (uint256 rewards) {
834         // Calculate number of blocks covered.
835         uint256 blockCount = _to.sub(_from);
836 
837         // Get the amount of TOKEN for this pool
838         uint256 amount = blockCount.mul(_tokenPerBlock);
839 
840         // Retrieve allowance and balance
841         uint256 allowedToken =
842             token.allowance(tokenRewardsAddress, address(this));
843         uint256 farmingBalance = token.balanceOf(tokenRewardsAddress);
844 
845         // If the actual balance is less than the allowance, use the balance.
846         allowedToken = farmingBalance < allowedToken ? farmingBalance : allowedToken;
847 
848         // If we reached the total amount allowed already, return the allowedToken
849         if (allowedToken < amount) {
850             rewards = allowedToken;
851         } else {
852             rewards = amount;
853         }
854     }
855 
856     function claimReward(uint256 _poolId) external {
857         updatePool(_poolId);
858         _harvest(_poolId);
859     }
860 
861     // Deposit LP tokens to TOKENStaking for TOKEN allocation.
862     function deposit(uint256 _poolId, uint256 _amount) external {
863         require(_amount > 0, "Amount cannot be 0");
864 
865         PoolInfo storage pool = poolInfo[_poolId];
866         UserInfo storage user = userInfo[_poolId][msg.sender];
867 
868         updatePool(_poolId);
869 
870         _harvest(_poolId);
871 
872         pool.token.safeTransferFrom(
873             address(msg.sender),
874             address(this),
875             _amount
876         );
877 
878         // This is the very first deposit
879         if (user.amount == 0) {
880             user.rewardDebtAtBlock = block.number;
881         }
882 
883         user.amount = user.amount.add(_amount);
884         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(UNITS);
885         emit Deposit(msg.sender, _poolId, _amount);
886     }
887 
888     // Withdraw LP tokens from TOKENStaking.
889     function withdraw(uint256 _poolId, uint256 _amount) external {
890         PoolInfo storage pool = poolInfo[_poolId];
891         UserInfo storage user = userInfo[_poolId][msg.sender];
892 
893         require(_amount > 0, "Amount cannot be 0");
894 
895         updatePool(_poolId);
896         _harvest(_poolId);
897 
898         user.amount = user.amount.sub(_amount);
899 
900         pool.token.safeTransfer(address(msg.sender), _amount);
901 
902         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(UNITS);
903 
904         emit Withdraw(msg.sender, _poolId, _amount);
905     }
906 
907     // Withdraw without caring about rewards. EMERGENCY ONLY.
908     function emergencyWithdraw(uint256 _poolId) external {
909         PoolInfo storage pool = poolInfo[_poolId];
910         UserInfo storage user = userInfo[_poolId][msg.sender];
911 
912         uint256 amountToSend = user.amount;
913         user.amount = 0;
914         user.rewardDebt = 0;
915         user.rewardDebtAtBlock = 0;
916 
917         pool.token.safeTransfer(address(msg.sender), amountToSend);
918 
919         emit EmergencyWithdraw(msg.sender, _poolId, amountToSend);
920     }
921 
922     /********************** EXTERNAL ********************************/
923 
924     // Return the number of added pools
925     function poolLength() external view returns (uint256) {
926         return poolInfo.length;
927     }
928 
929     // View function to see pending TOKENs on frontend.
930     function pendingReward(uint256 _poolId, address _user)
931         external
932         view
933         returns (uint256)
934     {
935         PoolInfo storage pool = poolInfo[_poolId];
936         UserInfo storage user = userInfo[_poolId][_user];
937 
938         uint256 accTokenPerShare = pool.accTokenPerShare;
939         uint256 poolBalance = pool.token.balanceOf(address(this));
940 
941         if (block.number > pool.lastRewardBlock && poolBalance > 0) {
942             uint256 rewards =
943                 getPoolReward(
944                     pool.lastRewardBlock,
945                     block.number,
946                     pool.tokenPerBlock
947                 );
948             accTokenPerShare = accTokenPerShare.add(
949                 rewards.mul(UNITS).div(poolBalance)
950             );
951         }
952 
953         uint256 pending =
954             user.amount.mul(accTokenPerShare).div(UNITS).sub(user.rewardDebt);
955 
956         return pending;
957     }
958 
959     /********************** INTERNAL ********************************/
960 
961     function _harvest(uint256 _poolId) internal {
962         PoolInfo storage pool = poolInfo[_poolId];
963         UserInfo storage user = userInfo[_poolId][msg.sender];
964 
965         if (user.amount == 0) return;
966 
967         uint256 pending =
968             user.amount.mul(pool.accTokenPerShare).div(UNITS).sub(
969                 user.rewardDebt
970             );
971 
972             // Retrieve allowance and balance
973         uint256 allowedToken =
974             token.allowance(tokenRewardsAddress, address(this));
975         uint256 farmingBalance = token.balanceOf(tokenRewardsAddress);
976 
977                 // If the actual balance is less than the allowance, use the balance.
978         allowedToken = farmingBalance < allowedToken ? farmingBalance : allowedToken;
979 
980         if (pending > allowedToken) {
981             pending = allowedToken;
982         }
983 
984         if (pending > 0) {
985             user.rewardDebtAtBlock = block.number;
986 
987             user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(UNITS);
988 
989             // Pay out the pending rewards
990             token.safeTransferFrom(tokenRewardsAddress, msg.sender, pending);
991 
992             emit SendTokenReward(msg.sender, _poolId, pending);
993             return;
994         }
995 
996         user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(UNITS);
997     }
998 
999     /********************** ADMIN ********************************/
1000     function changeRewardAddress(address _rewardAddress) external onlyOwner {
1001         require(_rewardAddress != address(0),"Address can't be 0");
1002         tokenRewardsAddress = _rewardAddress;
1003     }
1004 }