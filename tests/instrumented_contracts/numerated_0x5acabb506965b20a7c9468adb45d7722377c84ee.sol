1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
4 
5 
6 pragma solidity >=0.6.0 <0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 
83 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
84 
85 
86 pragma solidity >=0.6.0 <0.8.0;
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, with an overflow flag.
104      *
105      * _Available since v3.4._
106      */
107     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         uint256 c = a + b;
109         if (c < a) return (false, 0);
110         return (true, c);
111     }
112 
113     /**
114      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
115      *
116      * _Available since v3.4._
117      */
118     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         if (b > a) return (false, 0);
120         return (true, a - b);
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
125      *
126      * _Available since v3.4._
127      */
128     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130         // benefit is lost if 'b' is also tested.
131         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
132         if (a == 0) return (true, 0);
133         uint256 c = a * b;
134         if (c / a != b) return (false, 0);
135         return (true, c);
136     }
137 
138     /**
139      * @dev Returns the division of two unsigned integers, with a division by zero flag.
140      *
141      * _Available since v3.4._
142      */
143     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         if (b == 0) return (false, 0);
145         return (true, a / b);
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         if (b == 0) return (false, 0);
155         return (true, a % b);
156     }
157 
158     /**
159      * @dev Returns the addition of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `+` operator.
163      *
164      * Requirements:
165      *
166      * - Addition cannot overflow.
167      */
168     function add(uint256 a, uint256 b) internal pure returns (uint256) {
169         uint256 c = a + b;
170         require(c >= a, "SafeMath: addition overflow");
171         return c;
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting on
176      * overflow (when the result is negative).
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b <= a, "SafeMath: subtraction overflow");
186         return a - b;
187     }
188 
189     /**
190      * @dev Returns the multiplication of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `*` operator.
194      *
195      * Requirements:
196      *
197      * - Multiplication cannot overflow.
198      */
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         if (a == 0) return 0;
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203         return c;
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers, reverting on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         require(b > 0, "SafeMath: division by zero");
220         return a / b;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * reverting when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         require(b > 0, "SafeMath: modulo by zero");
237         return a % b;
238     }
239 
240     /**
241      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
242      * overflow (when the result is negative).
243      *
244      * CAUTION: This function is deprecated because it requires allocating memory for the error
245      * message unnecessarily. For custom revert reasons use {trySub}.
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      *
251      * - Subtraction cannot overflow.
252      */
253     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b <= a, errorMessage);
255         return a - b;
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
260      * division by zero. The result is rounded towards zero.
261      *
262      * CAUTION: This function is deprecated because it requires allocating memory for the error
263      * message unnecessarily. For custom revert reasons use {tryDiv}.
264      *
265      * Counterpart to Solidity's `/` operator. Note: this function uses a
266      * `revert` opcode (which leaves remaining gas untouched) while Solidity
267      * uses an invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b > 0, errorMessage);
275         return a / b;
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * reverting with custom message when dividing by zero.
281      *
282      * CAUTION: This function is deprecated because it requires allocating memory for the error
283      * message unnecessarily. For custom revert reasons use {tryMod}.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b > 0, errorMessage);
295         return a % b;
296     }
297 }
298 
299 
300 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
301 
302 
303 pragma solidity >=0.6.2 <0.8.0;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize, which returns 0 for contracts in
328         // construction, since the code is only stored at the end of the
329         // constructor execution.
330 
331         uint256 size;
332         // solhint-disable-next-line no-inline-assembly
333         assembly { size := extcodesize(account) }
334         return size > 0;
335     }
336 
337     /**
338      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
339      * `recipient`, forwarding all available gas and reverting on errors.
340      *
341      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
342      * of certain opcodes, possibly making contracts go over the 2300 gas limit
343      * imposed by `transfer`, making them unable to receive funds via
344      * `transfer`. {sendValue} removes this limitation.
345      *
346      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
347      *
348      * IMPORTANT: because control is transferred to `recipient`, care must be
349      * taken to not create reentrancy vulnerabilities. Consider using
350      * {ReentrancyGuard} or the
351      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
352      */
353     function sendValue(address payable recipient, uint256 amount) internal {
354         require(address(this).balance >= amount, "Address: insufficient balance");
355 
356         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
357         (bool success, ) = recipient.call{ value: amount }("");
358         require(success, "Address: unable to send value, recipient may have reverted");
359     }
360 
361     /**
362      * @dev Performs a Solidity function call using a low level `call`. A
363      * plain`call` is an unsafe replacement for a function call: use this
364      * function instead.
365      *
366      * If `target` reverts with a revert reason, it is bubbled up by this
367      * function (like regular Solidity function calls).
368      *
369      * Returns the raw returned data. To convert to the expected return value,
370      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
371      *
372      * Requirements:
373      *
374      * - `target` must be a contract.
375      * - calling `target` with `data` must not revert.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
380       return functionCall(target, data, "Address: low-level call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
385      * `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
410      * with `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
415         require(address(this).balance >= value, "Address: insufficient balance for call");
416         require(isContract(target), "Address: call to non-contract");
417 
418         // solhint-disable-next-line avoid-low-level-calls
419         (bool success, bytes memory returndata) = target.call{ value: value }(data);
420         return _verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
430         return functionStaticCall(target, data, "Address: low-level static call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
440         require(isContract(target), "Address: static call to non-contract");
441 
442         // solhint-disable-next-line avoid-low-level-calls
443         (bool success, bytes memory returndata) = target.staticcall(data);
444         return _verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
454         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a delegate call.
460      *
461      * _Available since v3.4._
462      */
463     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
464         require(isContract(target), "Address: delegate call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = target.delegatecall(data);
468         return _verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 // solhint-disable-next-line no-inline-assembly
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 }
490 
491 
492 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
493 
494 
495 pragma solidity >=0.6.0 <0.8.0;
496 
497 
498 
499 /**
500  * @title SafeERC20
501  * @dev Wrappers around ERC20 operations that throw on failure (when the token
502  * contract returns false). Tokens that return no value (and instead revert or
503  * throw on failure) are also supported, non-reverting calls are assumed to be
504  * successful.
505  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
506  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
507  */
508 library SafeERC20 {
509     using SafeMath for uint256;
510     using Address for address;
511 
512     function safeTransfer(IERC20 token, address to, uint256 value) internal {
513         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
514     }
515 
516     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
517         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
518     }
519 
520     /**
521      * @dev Deprecated. This function has issues similar to the ones found in
522      * {IERC20-approve}, and its usage is discouraged.
523      *
524      * Whenever possible, use {safeIncreaseAllowance} and
525      * {safeDecreaseAllowance} instead.
526      */
527     function safeApprove(IERC20 token, address spender, uint256 value) internal {
528         // safeApprove should only be called when setting an initial allowance,
529         // or when resetting it to zero. To increase and decrease it, use
530         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
531         // solhint-disable-next-line max-line-length
532         require((value == 0) || (token.allowance(address(this), spender) == 0),
533             "SafeERC20: approve from non-zero to non-zero allowance"
534         );
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
536     }
537 
538     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
539         uint256 newAllowance = token.allowance(address(this), spender).add(value);
540         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
541     }
542 
543     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
544         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
545         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
546     }
547 
548     /**
549      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
550      * on the return value: the return value is optional (but if data is returned, it must not be false).
551      * @param token The token targeted by the call.
552      * @param data The call data (encoded using abi.encode or one of its variants).
553      */
554     function _callOptionalReturn(IERC20 token, bytes memory data) private {
555         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
556         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
557         // the target address contains contract code and also asserts for success in the low-level call.
558 
559         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
560         if (returndata.length > 0) { // Return data is optional
561             // solhint-disable-next-line max-line-length
562             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
563         }
564     }
565 }
566 
567 
568 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
569 
570 
571 pragma solidity >=0.6.0 <0.8.0;
572 
573 /*
574  * @dev Provides information about the current execution context, including the
575  * sender of the transaction and its data. While these are generally available
576  * via msg.sender and msg.data, they should not be accessed in such a direct
577  * manner, since when dealing with GSN meta-transactions the account sending and
578  * paying for execution may not be the actual sender (as far as an application
579  * is concerned).
580  *
581  * This contract is only required for intermediate, library-like contracts.
582  */
583 abstract contract Context {
584     function _msgSender() internal view virtual returns (address payable) {
585         return msg.sender;
586     }
587 
588     function _msgData() internal view virtual returns (bytes memory) {
589         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
590         return msg.data;
591     }
592 }
593 
594 
595 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
596 
597 
598 pragma solidity >=0.6.0 <0.8.0;
599 
600 /**
601  * @dev Contract module which provides a basic access control mechanism, where
602  * there is an account (an owner) that can be granted exclusive access to
603  * specific functions.
604  *
605  * By default, the owner account will be the one that deploys the contract. This
606  * can later be changed with {transferOwnership}.
607  *
608  * This module is used through inheritance. It will make available the modifier
609  * `onlyOwner`, which can be applied to your functions to restrict their use to
610  * the owner.
611  */
612 abstract contract Ownable is Context {
613     address private _owner;
614 
615     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
616 
617     /**
618      * @dev Initializes the contract setting the deployer as the initial owner.
619      */
620     constructor () internal {
621         address msgSender = _msgSender();
622         _owner = msgSender;
623         emit OwnershipTransferred(address(0), msgSender);
624     }
625 
626     /**
627      * @dev Returns the address of the current owner.
628      */
629     function owner() public view virtual returns (address) {
630         return _owner;
631     }
632 
633     /**
634      * @dev Throws if called by any account other than the owner.
635      */
636     modifier onlyOwner() {
637         require(owner() == _msgSender(), "Ownable: caller is not the owner");
638         _;
639     }
640 
641     /**
642      * @dev Leaves the contract without owner. It will not be possible to call
643      * `onlyOwner` functions anymore. Can only be called by the current owner.
644      *
645      * NOTE: Renouncing ownership will leave the contract without an owner,
646      * thereby removing any functionality that is only available to the owner.
647      */
648     function renounceOwnership() public virtual onlyOwner {
649         emit OwnershipTransferred(_owner, address(0));
650         _owner = address(0);
651     }
652 
653     /**
654      * @dev Transfers ownership of the contract to a new account (`newOwner`).
655      * Can only be called by the current owner.
656      */
657     function transferOwnership(address newOwner) public virtual onlyOwner {
658         require(newOwner != address(0), "Ownable: new owner is the zero address");
659         emit OwnershipTransferred(_owner, newOwner);
660         _owner = newOwner;
661     }
662 }
663 
664 
665 // File contracts/Farm.sol
666 
667 pragma solidity 0.6.12;
668 
669 
670 
671 
672 contract Farm is Ownable {
673     using SafeMath for uint256;
674     using SafeERC20 for IERC20;
675 
676     // Info of each user.
677     struct UserInfo {
678         uint256 amount;     // How many LP tokens the user has provided.
679         uint256 rewardDebt; // Reward debt. See explanation below.
680         //
681         // We do some fancy math here. Basically, any point in time, the amount of ERC20s
682         // entitled to a user but is pending to be distributed is:
683         //
684         //   pending reward = (user.amount * pool.accERC20PerShare) - user.rewardDebt
685         //
686         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
687         //   1. The pool's `accERC20PerShare` (and `lastRewardBlock`) gets updated.
688         //   2. User receives the pending reward sent to his/her address.
689         //   3. User's `amount` gets updated.
690         //   4. User's `rewardDebt` gets updated.
691     }
692 
693     // Info of each pool.
694     struct PoolInfo {
695         IERC20 lpToken;             // Address of LP token contract.
696         uint256 allocPoint;         // How many allocation points assigned to this pool. ERC20s to distribute per block.
697         uint256 lastRewardBlock;    // Last block number that ERC20s distribution occurs.
698         uint256 accERC20PerShare;   // Accumulated ERC20s per share, times 1e36.
699     }
700 
701     // Address of the ERC20 Token contract.
702     IERC20 public erc20;
703     // The total amount of ERC20 that's paid out as reward.
704     uint256 public paidOut;
705     // ERC20 tokens rewarded per block.
706     uint256 public rewardPerBlock;
707 
708     // Total rewards added to farm
709     uint256 public totalRewards;
710 
711     // Mapping to determine if LP token is added
712     mapping (address => bool) public isLPTokenAdded;
713 
714     // Info of each pool.
715     PoolInfo[] public poolInfo;
716     // Info of each user that stakes LP tokens.
717     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
718     // Total allocation points. Must be the sum of all allocation points in all pools.
719     uint256 public totalAllocPoint;
720 
721     // The block number when farming starts.
722     uint256 public startBlock;
723     // The block number when farming ends.
724     uint256 public endBlock;
725 
726     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
727     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
728     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
729 
730     constructor(IERC20 _erc20, uint256 _rewardPerBlock, uint256 _startBlock) public {
731         erc20 = _erc20;
732         rewardPerBlock = _rewardPerBlock;
733         startBlock = _startBlock;
734         endBlock = _startBlock;
735     }
736 
737     // Number of LP pools
738     function poolLength() external view returns (uint256) {
739         return poolInfo.length;
740     }
741 
742     // Fund the farm, increase the end block
743     function fund(uint256 _amount) external {
744         require(block.number < endBlock, "fund: too late, the farm is closed");
745 
746         erc20.safeTransferFrom(address(msg.sender), address(this), _amount);
747         endBlock += _amount.div(rewardPerBlock);
748 
749         // Increase farm total rewards
750         totalRewards = totalRewards.add(_amount);
751     }
752 
753     // Add a new lp to the pool. Can only be called by the owner.
754     // DO NOT add the same LP token more than once. Rewards will be messed up if you do.
755     function addPool(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) external onlyOwner {
756         require(isLPTokenAdded[address(_lpToken)] == false, "Add: LP Token is already added");
757         isLPTokenAdded[address(_lpToken)] = true; // Mark that token is added
758 
759         if (_withUpdate) {
760             massUpdatePools();
761         }
762 
763         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
764         totalAllocPoint = totalAllocPoint.add(_allocPoint);
765         poolInfo.push(PoolInfo({
766             lpToken: _lpToken,
767             allocPoint: _allocPoint,
768             lastRewardBlock: lastRewardBlock,
769             accERC20PerShare: 0
770         }));
771     }
772 
773     // Update the given pool's ERC20 allocation point. Can only be called by the owner.
774     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) external onlyOwner {
775         if (_withUpdate) {
776             massUpdatePools();
777         }
778         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
779         poolInfo[_pid].allocPoint = _allocPoint;
780     }
781 
782     // View function to see deposited LP for a user.
783     function deposited(uint256 _pid, address _user) external view returns (uint256) {
784         UserInfo storage user = userInfo[_pid][_user];
785         return user.amount;
786     }
787 
788     // View function to see pending ERC20s for a user.
789     function pending(uint256 _pid, address _user) external view returns (uint256) {
790         PoolInfo storage pool = poolInfo[_pid];
791         UserInfo storage user = userInfo[_pid][_user];
792         uint256 accERC20PerShare = pool.accERC20PerShare;
793         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
794 
795         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
796             uint256 lastBlock = block.number < endBlock ? block.number : endBlock;
797             uint256 nrOfBlocks = lastBlock.sub(pool.lastRewardBlock);
798             uint256 erc20Reward = nrOfBlocks.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
799             accERC20PerShare = accERC20PerShare.add(erc20Reward.mul(1e36).div(lpSupply));
800         }
801 
802         return user.amount.mul(accERC20PerShare).div(1e36).sub(user.rewardDebt);
803     }
804 
805     // View function for total reward the farm has yet to pay out.
806     function totalPending() external view returns (uint256) {
807         if (block.number <= startBlock) {
808             return 0;
809         }
810 
811         uint256 lastBlock = block.number < endBlock ? block.number : endBlock;
812         return rewardPerBlock.mul(lastBlock - startBlock).sub(paidOut);
813     }
814 
815     // Update reward variables for all pools. Be careful of gas spending!
816     function massUpdatePools() public {
817         uint256 length = poolInfo.length;
818         for (uint256 pid = 0; pid < length; ++pid) {
819             updatePool(pid);
820         }
821     }
822 
823     // Update reward variables of the given pool to be up-to-date.
824     function updatePool(uint256 _pid) public {
825         PoolInfo storage pool = poolInfo[_pid];
826         uint256 lastBlock = block.number < endBlock ? block.number : endBlock;
827 
828         if (lastBlock <= pool.lastRewardBlock) {
829             return;
830         }
831         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
832         if (lpSupply == 0) {
833             pool.lastRewardBlock = lastBlock;
834             return;
835         }
836 
837         uint256 nrOfBlocks = lastBlock.sub(pool.lastRewardBlock);
838         uint256 erc20Reward = nrOfBlocks.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
839 
840         pool.accERC20PerShare = pool.accERC20PerShare.add(erc20Reward.mul(1e36).div(lpSupply));
841         pool.lastRewardBlock = block.number;
842     }
843 
844     // Deposit LP tokens to Farm for ERC20 allocation.
845     function deposit(uint256 _pid, uint256 _amount) external {
846         PoolInfo storage pool = poolInfo[_pid];
847         UserInfo storage user = userInfo[_pid][msg.sender];
848         updatePool(_pid);
849         if (user.amount > 0) {
850             uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
851             erc20Transfer(msg.sender, pendingAmount);
852         }
853         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
854         user.amount = user.amount.add(_amount);
855         user.rewardDebt = user.amount.mul(pool.accERC20PerShare).div(1e36);
856         emit Deposit(msg.sender, _pid, _amount);
857     }
858 
859     // Withdraw LP tokens from Farm.
860     function withdraw(uint256 _pid, uint256 _amount) external {
861         PoolInfo storage pool = poolInfo[_pid];
862         UserInfo storage user = userInfo[_pid][msg.sender];
863         require(user.amount >= _amount, "withdraw: can't withdraw more than deposit");
864         updatePool(_pid);
865         uint256 pendingAmount = user.amount.mul(pool.accERC20PerShare).div(1e36).sub(user.rewardDebt);
866         erc20Transfer(msg.sender, pendingAmount);
867         user.amount = user.amount.sub(_amount);
868         user.rewardDebt = user.amount.mul(pool.accERC20PerShare).div(1e36);
869         pool.lpToken.safeTransfer(address(msg.sender), _amount);
870         emit Withdraw(msg.sender, _pid, _amount);
871     }
872 
873     // Withdraw without caring about rewards. EMERGENCY ONLY.
874     function emergencyWithdraw(uint256 _pid) external {
875         PoolInfo storage pool = poolInfo[_pid];
876         UserInfo storage user = userInfo[_pid][msg.sender];
877         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
878         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
879         user.amount = 0;
880         user.rewardDebt = 0;
881     }
882 
883     // Transfer ERC20 and update the required ERC20 to payout all rewards
884     function erc20Transfer(address _to, uint256 _amount) internal {
885         erc20.transfer(_to, _amount);
886         paidOut += _amount;
887     }
888 }