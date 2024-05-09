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
665 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.1
666 
667 
668 pragma solidity >=0.6.0 <0.8.0;
669 
670 /**
671  * @dev Contract module that helps prevent reentrant calls to a function.
672  *
673  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
674  * available, which can be applied to functions to make sure there are no nested
675  * (reentrant) calls to them.
676  *
677  * Note that because there is a single `nonReentrant` guard, functions marked as
678  * `nonReentrant` may not call one another. This can be worked around by making
679  * those functions `private`, and then adding `external` `nonReentrant` entry
680  * points to them.
681  *
682  * TIP: If you would like to learn more about reentrancy and alternative ways
683  * to protect against it, check out our blog post
684  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
685  */
686 abstract contract ReentrancyGuard {
687     // Booleans are more expensive than uint256 or any type that takes up a full
688     // word because each write operation emits an extra SLOAD to first read the
689     // slot's contents, replace the bits taken up by the boolean, and then write
690     // back. This is the compiler's defense against contract upgrades and
691     // pointer aliasing, and it cannot be disabled.
692 
693     // The values being non-zero value makes deployment a bit more expensive,
694     // but in exchange the refund on every call to nonReentrant will be lower in
695     // amount. Since refunds are capped to a percentage of the total
696     // transaction's gas, it is best to keep them low in cases like this one, to
697     // increase the likelihood of the full refund coming into effect.
698     uint256 private constant _NOT_ENTERED = 1;
699     uint256 private constant _ENTERED = 2;
700 
701     uint256 private _status;
702 
703     constructor () internal {
704         _status = _NOT_ENTERED;
705     }
706 
707     /**
708      * @dev Prevents a contract from calling itself, directly or indirectly.
709      * Calling a `nonReentrant` function from another `nonReentrant`
710      * function is not supported. It is possible to prevent this from happening
711      * by making the `nonReentrant` function external, and make it call a
712      * `private` function that does the actual work.
713      */
714     modifier nonReentrant() {
715         // On the first call to nonReentrant, _notEntered will be true
716         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
717 
718         // Any calls to nonReentrant after this point will fail
719         _status = _ENTERED;
720 
721         _;
722 
723         // By storing the original value once again, a refund is triggered (see
724         // https://eips.ethereum.org/EIPS/eip-2200)
725         _status = _NOT_ENTERED;
726     }
727 }
728 
729 
730 // File contracts/TokensFarm.sol
731 
732 pragma solidity 0.6.12;
733 
734 
735 
736 
737 
738 contract TokensFarm is Ownable, ReentrancyGuard {
739 
740     using SafeMath for uint256;
741     using SafeERC20 for IERC20;
742 
743     enum EarlyWithdrawPenalty { NO_PENALTY, BURN_REWARDS, REDISTRIBUTE_REWARDS }
744 
745     // Info of each user.
746     struct StakeInfo {
747         uint256 amount;             // How many tokens the user has provided.
748         uint256 rewardDebt;         // Reward debt. See explanation below.
749         uint256 depositTime;        // Time when user deposited.
750     }
751 
752     IERC20 public tokenStaked;         // Address of ERC20 token contract.
753     uint256 public lastRewardTime;     // Last time number that ERC20s distribution occurs.
754     uint256 public accERC20PerShare;   // Accumulated ERC20s per share, times 1e36.
755     uint256 public totalDeposits;      // Total tokens deposited in the farm.
756 
757     // If contractor allows early withdraw on stakes
758     bool public isEarlyWithdrawAllowed;
759     // Minimal period of time to stake
760     uint256 public minTimeToStake;
761     // Address of the ERC20 Token contract.
762     IERC20 public erc20;
763     // The total amount of ERC20 that's paid out as reward.
764     uint256 public paidOut;
765     // ERC20 tokens rewarded per second.
766     uint256 public rewardPerSecond;
767     // Total rewards added to farm
768     uint256 public totalRewards;
769     // Info of each user that stakes ERC20 tokens.
770     mapping (address => StakeInfo[]) public stakeInfo;
771     // The time when farming starts.
772     uint256 public startTime;
773     // The time when farming ends.
774     uint256 public endTime;
775     // Early withdraw penalty
776     EarlyWithdrawPenalty public penalty;
777     // Counter for funding
778     uint256 fundCounter;
779     // Congress address
780     address public congressAddress;
781 
782     // Events
783     event Deposit(address indexed user, uint256 stakeId, uint256 amount);
784     event Withdraw(address indexed user, uint256 stakeId, uint256 amount);
785     event EmergencyWithdraw(address indexed user, uint256 stakeId, uint256 amount);
786     event EarlyWithdrawPenaltyChange(EarlyWithdrawPenalty penalty);
787 
788     modifier validateStakeByStakeId(address _user, uint256 stakeId) {
789         require(stakeId < stakeInfo[_user].length, "Stake does not exist");
790         _;
791     }
792 
793     constructor(
794         IERC20 _erc20,
795         uint256 _rewardPerSecond,
796         uint256 _startTime,
797         uint256 _minTimeToStake,
798         bool _isEarlyWithdrawAllowed,
799         EarlyWithdrawPenalty _penalty,
800         IERC20 _tokenStaked,
801         address _congressAddress
802     ) public {
803         require(address(_erc20) != address(0x0), "Wrong token address.");
804         require(_rewardPerSecond > 0, "Rewards per second must be > 0.");
805         require(_startTime >= block.timestamp, "Start timne can not be in the past.");
806 
807         erc20 = _erc20;
808         rewardPerSecond = _rewardPerSecond;
809         startTime = _startTime;
810         endTime = _startTime;
811         minTimeToStake = _minTimeToStake;
812         isEarlyWithdrawAllowed = _isEarlyWithdrawAllowed;
813         congressAddress = _congressAddress;
814 
815         _setEarlyWithdrawPenalty(_penalty);
816         _addPool(_tokenStaked);
817     }
818 
819     // Set minimun time to stake
820     function setMinTimeToStake(uint256 _minTimeToStake) external onlyOwner {
821         minTimeToStake = _minTimeToStake;
822     }
823 
824     // Set early withdrawal penalty, if applicable
825     function _setEarlyWithdrawPenalty(EarlyWithdrawPenalty _penalty) internal {
826         require(isEarlyWithdrawAllowed, "Early withdrawal is not allowed, so there is no penalty.");
827         penalty = _penalty;
828 
829         emit EarlyWithdrawPenaltyChange(penalty);
830     }
831 
832     // Fund the farm, increase the end time
833     function fund(uint256 _amount) external {
834         fundCounter = fundCounter.add(1);
835         
836         _fundInternal(_amount);
837         erc20.safeTransferFrom(address(msg.sender), address(this), _amount);
838 
839         if (fundCounter == 2) {
840             transferOwnership(congressAddress);
841         }
842     }
843 
844     // Internally fund the farm by adding farmed rewards by user to the end
845     function _fundInternal(uint _amount) internal {
846         require(block.timestamp < endTime, "fund: too late, the farm is closed");
847         require(_amount > 0, "Amount must be greater than 0.");
848         // Compute new end time
849         endTime += _amount.div(rewardPerSecond);
850         // Increase farm total rewards
851         totalRewards = totalRewards.add(_amount);
852     }
853 
854     // Add a new ERC20 token to the pool. Can only be called by the owner.
855     function _addPool(IERC20 _tokenStaked) internal {
856         require(address(_tokenStaked) != address(0x0), "Must input valid address.");
857         require(address(tokenStaked) == address(0x0), "Pool can be set only once.");
858 
859         uint256 _lastRewardTime = block.timestamp > startTime ? block.timestamp : startTime;
860 
861         tokenStaked = _tokenStaked;
862         lastRewardTime = _lastRewardTime;
863         accERC20PerShare = 0;
864         totalDeposits = 0;
865     }
866 
867     // View function to see deposited ERC20 token for a user.
868     function deposited(address _user, uint256 stakeId) public view validateStakeByStakeId(_user, stakeId) returns (uint256) {
869         StakeInfo storage stake = stakeInfo[_user][stakeId];
870         return stake.amount;
871     }
872 
873     // View function to see pending ERC20s for a user.
874     function pending(address _user, uint256 stakeId) public view validateStakeByStakeId(_user, stakeId) returns (uint256) {
875         StakeInfo storage stake = stakeInfo[_user][stakeId];
876 
877         if(stake.amount == 0) {
878             return 0;
879         }
880 
881         uint256 _accERC20PerShare = accERC20PerShare;
882         uint256 tokenSupply = totalDeposits;
883 
884         if (block.timestamp > lastRewardTime && tokenSupply != 0) {
885             uint256 lastTime = block.timestamp < endTime ? block.timestamp : endTime;
886             uint256 timeToCompare = lastRewardTime < endTime ? lastRewardTime : endTime;
887             uint256 nrOfSeconds = lastTime.sub(timeToCompare);
888             uint256 erc20Reward = nrOfSeconds.mul(rewardPerSecond);
889             _accERC20PerShare = _accERC20PerShare.add(erc20Reward.mul(1e36).div(tokenSupply));
890         }
891 
892         return stake.amount.mul(_accERC20PerShare).div(1e36).sub(stake.rewardDebt);
893     }
894 
895     // View function to see deposit timestamp for a user.
896     function depositTimestamp(address _user, uint256 stakeId) public view validateStakeByStakeId(_user, stakeId) returns (uint256) {
897         StakeInfo storage stake = stakeInfo[_user][stakeId];
898         return stake.depositTime;
899     }
900 
901     // View function for total reward the farm has yet to pay out.
902     function totalPending() external view returns (uint256) {
903         if (block.timestamp <= startTime) {
904             return 0;
905         }
906 
907         uint256 lastTime = block.timestamp < endTime ? block.timestamp : endTime;
908         return rewardPerSecond.mul(lastTime - startTime).sub(paidOut);
909     }
910 
911     // Update reward variables of the given pool to be up-to-date.
912     function updatePool() public {
913         uint256 lastTime = block.timestamp < endTime ? block.timestamp : endTime;
914 
915         if (lastTime <= lastRewardTime) {
916             return;
917         }
918 
919         uint256 tokenSupply = totalDeposits;
920 
921         if (tokenSupply == 0) {
922             lastRewardTime = lastTime;
923             return;
924         }
925 
926         uint256 nrOfSeconds = lastTime.sub(lastRewardTime);
927         uint256 erc20Reward = nrOfSeconds.mul(rewardPerSecond);
928 
929         accERC20PerShare = accERC20PerShare.add(erc20Reward.mul(1e36).div(tokenSupply));
930         lastRewardTime = block.timestamp;
931     }
932 
933     // Deposit ERC20 tokens to Farm for ERC20 allocation.
934     function deposit(uint256 _amount) external {
935         StakeInfo memory stake;
936 
937         // Update pool
938         updatePool();
939 
940         // Take token and transfer to contract
941         tokenStaked.safeTransferFrom(address(msg.sender), address(this), _amount);
942         // Add amount to the pool total deposits
943         totalDeposits = totalDeposits.add(_amount);
944 
945         // Update user accounting
946         stake.amount = _amount;
947         stake.rewardDebt = stake.amount.mul(accERC20PerShare).div(1e36);
948         stake.depositTime = block.timestamp;
949 
950         uint stakeId = stakeInfo[msg.sender].length;
951 
952         // Push new stake to array of stakes for user
953         stakeInfo[msg.sender].push(stake);
954 
955         // Emit deposit event
956         emit Deposit(msg.sender, stakeId, _amount);
957     }
958 
959     // Withdraw ERC20 tokens from Farm.
960     function withdraw(uint256 _amount, uint256 stakeId) external nonReentrant validateStakeByStakeId(msg.sender, stakeId) {
961         bool minimalTimeStakeRespected;
962 
963         StakeInfo storage stake = stakeInfo[msg.sender][stakeId];
964 
965         require(stake.amount >= _amount, "withdraw: can't withdraw more than deposit");
966 
967         updatePool();
968 
969         // if early withdraw is not allowed, user can't withdraw funds before
970         if(!isEarlyWithdrawAllowed) {
971             minimalTimeStakeRespected = stake.depositTime.add(minTimeToStake) <= block.timestamp;
972             // Check if user has respected minimal time to stake, require it.
973             require(minimalTimeStakeRespected, "User can not withdraw funds yet.");
974         }
975 
976         // Compute pending rewards amount of user rewards
977         uint256 pendingAmount = stake.amount.mul(accERC20PerShare).div(1e36).sub(stake.rewardDebt);
978 
979         // Penalties in case user didn't stake enough time
980         minimalTimeStakeRespected = stake.depositTime.add(minTimeToStake) <= block.timestamp;
981         if(penalty == EarlyWithdrawPenalty.BURN_REWARDS && !minimalTimeStakeRespected) {
982             // Burn to address (1)
983             _erc20Transfer(address(1), pendingAmount);
984         } else if (penalty == EarlyWithdrawPenalty.REDISTRIBUTE_REWARDS && !minimalTimeStakeRespected) {
985             // Re-fund the farm
986             _fundInternal(pendingAmount);
987         } else {
988             // In case either there's no penalty
989             _erc20Transfer(msg.sender, pendingAmount);
990         }
991 
992         stake.amount = stake.amount.sub(_amount);
993         stake.rewardDebt = stake.amount.mul(accERC20PerShare).div(1e36);
994 
995         tokenStaked.safeTransfer(address(msg.sender), _amount);
996         totalDeposits = totalDeposits.sub(_amount);
997 
998         // Emit Withdraw event
999         emit Withdraw(msg.sender, stakeId, _amount);
1000     }
1001 
1002 
1003     // Withdraw without caring about rewards. EMERGENCY ONLY.
1004     function emergencyWithdraw(uint256 stakeId) external nonReentrant validateStakeByStakeId(msg.sender, stakeId) {
1005         StakeInfo storage stake = stakeInfo[msg.sender][stakeId];
1006 
1007         // if early withdraw is not allowed, user can't withdraw funds before
1008         if(!isEarlyWithdrawAllowed) {
1009             bool minimalTimeStakeRespected = stake.depositTime.add(minTimeToStake) <= block.timestamp;
1010             // Check if user has respected minimal time to stake, require it.
1011             require(minimalTimeStakeRespected, "User can not withdraw funds yet.");
1012         }
1013 
1014         tokenStaked.safeTransfer(address(msg.sender), stake.amount);
1015         totalDeposits = totalDeposits.sub(stake.amount);
1016 
1017         emit EmergencyWithdraw(msg.sender, stakeId, stake.amount);
1018 
1019         stake.amount = 0;
1020         stake.rewardDebt = 0;
1021     }
1022 
1023     // Get number of stakes user has
1024     function getNumberOfUserStakes(address user) external view returns (uint256){
1025         return stakeInfo[user].length;
1026     }
1027 
1028     // Get user pending amounts, stakes and deposit time
1029     function getUserStakesAndPendingAmounts(address user) external view returns (uint256[] memory, uint256[] memory, uint256[] memory) {
1030         uint256 numberOfStakes = stakeInfo[user].length;
1031 
1032         uint256[] memory deposits = new uint256[](numberOfStakes);
1033         uint256[] memory pendingAmounts = new uint256[](numberOfStakes);
1034         uint256[] memory depositTime = new uint256[](numberOfStakes);
1035 
1036         for (uint i = 0; i < numberOfStakes; i++) {
1037             deposits[i] = deposited(user, i);
1038             pendingAmounts[i] = pending(user, i);
1039             depositTime[i] = depositTimestamp(user, i);
1040         }
1041 
1042         return (deposits, pendingAmounts, depositTime);
1043     }
1044 
1045     // Get total rewards locked/unlocked
1046     function getTotalRewardsLockedUnlocked() external view returns (uint256, uint256) {
1047         uint256 totalRewardsLocked;
1048         uint256 totalRewardsUnlocked;
1049 
1050         if (block.timestamp <= startTime) {
1051             totalRewardsUnlocked = 0;
1052             totalRewardsLocked = totalRewards;
1053         } else {
1054             uint256 lastTime = block.timestamp < endTime ? block.timestamp : endTime;
1055             totalRewardsUnlocked = rewardPerSecond.mul(lastTime - startTime);
1056             totalRewardsLocked = totalRewards - totalRewardsUnlocked;
1057         }
1058 
1059         return (totalRewardsUnlocked, totalRewardsLocked);
1060     }
1061 
1062     // Transfer ERC20 and update the required ERC20 to payout all rewards
1063     function _erc20Transfer(address _to, uint256 _amount) internal {
1064         erc20.transfer(_to, _amount);
1065         paidOut += _amount;
1066     }
1067 }