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
739     using SafeMath for uint256;
740     using SafeERC20 for IERC20;
741 
742     enum EarlyWithdrawPenalty {
743         NO_PENALTY,
744         BURN_REWARDS,
745         REDISTRIBUTE_REWARDS
746     }
747 
748     // Info of each user.
749     struct StakeInfo {
750         uint256 amount; // How many tokens the user has provided.
751         uint256 rewardDebt; // Reward debt. See explanation below.
752         uint256 depositTime; // Time when user deposited.
753     }
754 
755     IERC20 public tokenStaked; // Address of ERC20 token contract.
756     uint256 public lastRewardTime; // Last time number that ERC20s distribution occurs.
757     uint256 public accERC20PerShare; // Accumulated ERC20s per share, times 1e18.
758     uint256 public totalDeposits; // Total tokens deposited in the farm.
759 
760     // If contractor allows early withdraw on stakes
761     bool public isEarlyWithdrawAllowed;
762     // Minimal period of time to stake
763     uint256 public minTimeToStake;
764     // Address of the ERC20 Token contract.
765     IERC20 public erc20;
766     // The total amount of ERC20 that's paid out as reward.
767     uint256 public paidOut;
768     // ERC20 tokens rewarded per second.
769     uint256 public rewardPerSecond;
770     // Total rewards added to farm
771     uint256 public totalRewards;
772     // Info of each user that stakes ERC20 tokens.
773     mapping(address => StakeInfo[]) public stakeInfo;
774     // The time when farming starts.
775     uint256 public startTime;
776     // The time when farming ends.
777     uint256 public endTime;
778     // Early withdraw penalty
779     EarlyWithdrawPenalty public penalty;
780     // Counter for funding
781     uint256 fundCounter;
782     // Congress address
783     address public congressAddress;
784     // Stake fee percent
785     uint256 public stakeFeePercent;
786     // Reward fee percent
787     uint256 public rewardFeePercent;
788     // Fee collector address
789     address payable public feeCollector;
790     // Flat fee amount
791     uint256 public flatFeeAmount;
792     // Fee option
793     bool public isFlatFeeAllowed;
794 
795     // Events
796     event Deposit(address indexed user, uint256 stakeId, uint256 amount);
797     event Withdraw(address indexed user, uint256 stakeId, uint256 amount);
798     event EmergencyWithdraw(
799         address indexed user,
800         uint256 stakeId,
801         uint256 amount
802     );
803     event EarlyWithdrawPenaltyChange(EarlyWithdrawPenalty penalty);
804 
805     modifier validateStakeByStakeId(address _user, uint256 stakeId) {
806         require(stakeId < stakeInfo[_user].length, "Stake does not exist");
807         _;
808     }
809 
810     constructor(
811         IERC20 _erc20,
812         uint256 _rewardPerSecond,
813         uint256 _startTime,
814         uint256 _minTimeToStake,
815         bool _isEarlyWithdrawAllowed,
816         EarlyWithdrawPenalty _penalty,
817         IERC20 _tokenStaked,
818         address _congressAddress,
819         uint256 _stakeFeePercent,
820         uint256 _rewardFeePercent,
821         uint256 _flatFeeAmount,
822         address payable _feeCollector,
823         bool _isFlatFeeAllowed
824     ) public {
825         require(address(_erc20) != address(0x0), "Wrong token address.");
826         require(_rewardPerSecond > 0, "Rewards per second must be > 0.");
827         require(
828             _startTime >= block.timestamp,
829             "Start timne can not be in the past."
830         );
831         require(_stakeFeePercent < 100, "Stake fee must be < 100.");
832         require(_rewardFeePercent < 100, "Reward fee must be < 100.");
833         require(_feeCollector != address(0x0), "Wrong fee collector address.");
834         require(
835             _congressAddress != address(0x0),
836             "Congress address can not be 0."
837         );
838 
839         erc20 = _erc20;
840         rewardPerSecond = _rewardPerSecond;
841         startTime = _startTime;
842         endTime = _startTime;
843         minTimeToStake = _minTimeToStake;
844         isEarlyWithdrawAllowed = _isEarlyWithdrawAllowed;
845         congressAddress = _congressAddress;
846         stakeFeePercent = _stakeFeePercent;
847         rewardFeePercent = _rewardFeePercent;
848         flatFeeAmount = _flatFeeAmount;
849         feeCollector = _feeCollector;
850         isFlatFeeAllowed = _isFlatFeeAllowed;
851 
852         _setEarlyWithdrawPenalty(_penalty);
853         _addPool(_tokenStaked);
854     }
855 
856     // Set minimun time to stake
857     function setMinTimeToStake(uint256 _minTimeToStake) external onlyOwner {
858         minTimeToStake = _minTimeToStake;
859     }
860 
861     // Set fee collector address
862     function setFeeCollector(address payable _feeCollector) external onlyOwner {
863         require(_feeCollector != address(0x0), "Wrong fee collector address.");
864         feeCollector = _feeCollector;
865     }
866 
867     // Set early withdrawal penalty, if applicable
868     function _setEarlyWithdrawPenalty(EarlyWithdrawPenalty _penalty) internal {
869         penalty = _penalty;
870         emit EarlyWithdrawPenaltyChange(penalty);
871     }
872 
873     // Fund the farm, increase the end time
874     function fund(uint256 _amount) external {
875         fundCounter = fundCounter.add(1);
876 
877         _fundInternal(_amount);
878         erc20.safeTransferFrom(address(msg.sender), address(this), _amount);
879 
880         if (fundCounter == 2) {
881             transferOwnership(congressAddress);
882         }
883     }
884 
885     // Internally fund the farm by adding farmed rewards by user to the end
886     function _fundInternal(uint256 _amount) internal {
887         require(
888             block.timestamp < endTime,
889             "fund: too late, the farm is closed"
890         );
891         require(_amount > 0, "Amount must be greater than 0.");
892         // Compute new end time
893         endTime += _amount.div(rewardPerSecond);
894         // Increase farm total rewards
895         totalRewards = totalRewards.add(_amount);
896     }
897 
898     // Add a new ERC20 token to the pool. Can only be called by the owner.
899     function _addPool(IERC20 _tokenStaked) internal {
900         require(
901             address(_tokenStaked) != address(0x0),
902             "Must input valid address."
903         );
904         require(
905             address(tokenStaked) == address(0x0),
906             "Pool can be set only once."
907         );
908 
909         uint256 _lastRewardTime = block.timestamp > startTime
910             ? block.timestamp
911             : startTime;
912 
913         tokenStaked = _tokenStaked;
914         lastRewardTime = _lastRewardTime;
915         accERC20PerShare = 0;
916         totalDeposits = 0;
917     }
918 
919     // View function to see deposited ERC20 token for a user.
920     function deposited(address _user, uint256 stakeId)
921         public
922         view
923         validateStakeByStakeId(_user, stakeId)
924         returns (uint256)
925     {
926         StakeInfo storage stake = stakeInfo[_user][stakeId];
927         return stake.amount;
928     }
929 
930     // View function to see pending ERC20s for a user.
931     function pending(address _user, uint256 stakeId)
932         public
933         view
934         validateStakeByStakeId(_user, stakeId)
935         returns (uint256)
936     {
937         StakeInfo storage stake = stakeInfo[_user][stakeId];
938 
939         if (stake.amount == 0) {
940             return 0;
941         }
942 
943         uint256 _accERC20PerShare = accERC20PerShare;
944         uint256 tokenSupply = totalDeposits;
945 
946         if (block.timestamp > lastRewardTime && tokenSupply != 0) {
947             uint256 lastTime = block.timestamp < endTime
948                 ? block.timestamp
949                 : endTime;
950             uint256 timeToCompare = lastRewardTime < endTime
951                 ? lastRewardTime
952                 : endTime;
953             uint256 nrOfSeconds = lastTime.sub(timeToCompare);
954             uint256 erc20Reward = nrOfSeconds.mul(rewardPerSecond);
955             _accERC20PerShare = _accERC20PerShare.add(
956                 erc20Reward.mul(1e18).div(tokenSupply)
957             );
958         }
959 
960         return
961             stake.amount.mul(_accERC20PerShare).div(1e18).sub(stake.rewardDebt);
962     }
963 
964     // View function to see deposit timestamp for a user.
965     function depositTimestamp(address _user, uint256 stakeId)
966         public
967         view
968         validateStakeByStakeId(_user, stakeId)
969         returns (uint256)
970     {
971         StakeInfo storage stake = stakeInfo[_user][stakeId];
972         return stake.depositTime;
973     }
974 
975     // View function for total reward the farm has yet to pay out.
976     function totalPending() external view returns (uint256) {
977         if (block.timestamp <= startTime) {
978             return 0;
979         }
980 
981         uint256 lastTime = block.timestamp < endTime
982             ? block.timestamp
983             : endTime;
984         return rewardPerSecond.mul(lastTime - startTime).sub(paidOut);
985     }
986 
987     // Update reward variables of the given pool to be up-to-date.
988     function updatePool() public {
989         uint256 lastTime = block.timestamp < endTime
990             ? block.timestamp
991             : endTime;
992 
993         if (lastTime <= lastRewardTime) {
994             return;
995         }
996 
997         uint256 tokenSupply = totalDeposits;
998 
999         if (tokenSupply == 0) {
1000             lastRewardTime = lastTime;
1001             return;
1002         }
1003 
1004         uint256 nrOfSeconds = lastTime.sub(lastRewardTime);
1005         uint256 erc20Reward = nrOfSeconds.mul(rewardPerSecond);
1006 
1007         accERC20PerShare = accERC20PerShare.add(
1008             erc20Reward.mul(1e18).div(tokenSupply)
1009         );
1010         lastRewardTime = block.timestamp;
1011     }
1012 
1013     // Deposit ERC20 tokens to Farm for ERC20 allocation.
1014     function deposit(uint256 _amount) external payable {
1015         StakeInfo memory stake;
1016 
1017         // Update pool
1018         updatePool();
1019 
1020         // Take token and transfer to contract
1021         tokenStaked.safeTransferFrom(
1022             address(msg.sender),
1023             address(this),
1024             _amount
1025         );
1026 
1027         uint256 stakedAmount = _amount;
1028 
1029         if (isFlatFeeAllowed) {
1030             // Collect flat fee
1031             require(
1032                 msg.value >= flatFeeAmount,
1033                 "Payable amount is less than fee amount."
1034             );
1035             (bool sent, ) = payable(feeCollector).call{value: msg.value}("");
1036             require(sent, "Failed to send flat fee");
1037         } else if (stakeFeePercent > 0) { // Handle this case only if flat fee is not allowed, and stakeFeePercent > 0
1038             // Compute the fee
1039             uint256 feeAmount = _amount.mul(stakeFeePercent).div(100);
1040             // Compute stake amount
1041             stakedAmount = _amount.sub(feeAmount);
1042             // Transfer fee to Fee Collector
1043             tokenStaked.safeTransfer(feeCollector, feeAmount);
1044         }
1045 
1046         // Increase total deposits
1047         totalDeposits = totalDeposits.add(stakedAmount);
1048         // Update user accounting
1049         stake.amount = stakedAmount;
1050         stake.rewardDebt = stake.amount.mul(accERC20PerShare).div(1e18);
1051         stake.depositTime = block.timestamp;
1052         // Compute stake id
1053         uint256 stakeId = stakeInfo[msg.sender].length;
1054         // Push new stake to array of stakes for user
1055         stakeInfo[msg.sender].push(stake);
1056         // Emit deposit event
1057         emit Deposit(msg.sender, stakeId, stakedAmount);
1058     }
1059 
1060     // Withdraw ERC20 tokens from Farm.
1061     function withdraw(uint256 _amount, uint256 stakeId)
1062         external
1063         payable
1064         nonReentrant
1065         validateStakeByStakeId(msg.sender, stakeId)
1066     {
1067         bool minimalTimeStakeRespected;
1068 
1069         StakeInfo storage stake = stakeInfo[msg.sender][stakeId];
1070 
1071         require(
1072             stake.amount >= _amount,
1073             "withdraw: can't withdraw more than deposit"
1074         );
1075 
1076         updatePool();
1077         minimalTimeStakeRespected = stake.depositTime.add(minTimeToStake) <= block.timestamp;
1078         // if early withdraw is not allowed, user can't withdraw funds before
1079         if (!isEarlyWithdrawAllowed) {
1080             // Check if user has respected minimal time to stake, require it.
1081             require(
1082                 minimalTimeStakeRespected,
1083                 "User can not withdraw funds yet."
1084             );
1085         }
1086 
1087         // Compute pending rewards amount of user rewards
1088         uint256 pendingAmount = stake
1089             .amount
1090             .mul(accERC20PerShare)
1091             .div(1e18)
1092             .sub(stake.rewardDebt);
1093 
1094         // Penalties in case user didn't stake enough time
1095 
1096         if (pendingAmount > 0) {
1097             if (
1098                 penalty == EarlyWithdrawPenalty.BURN_REWARDS &&
1099                 !minimalTimeStakeRespected
1100             ) {
1101                 // Burn to address (1)
1102                 _erc20Transfer(address(1), pendingAmount);
1103             } else if (
1104                 penalty == EarlyWithdrawPenalty.REDISTRIBUTE_REWARDS &&
1105                 !minimalTimeStakeRespected
1106             ) {
1107                 if (block.timestamp >= endTime) {
1108                     // Burn rewards because farm can not be funded anymore since it ended
1109                     _erc20Transfer(address(1), pendingAmount);
1110                 } else {
1111                     // Re-fund the farm
1112                     _fundInternal(pendingAmount);
1113                 }
1114             } else {
1115                 // In case either there's no penalty
1116                 _erc20Transfer(msg.sender, pendingAmount);
1117             }
1118         }
1119 
1120         stake.amount = stake.amount.sub(_amount);
1121         stake.rewardDebt = stake.amount.mul(accERC20PerShare).div(1e18);
1122 
1123         tokenStaked.safeTransfer(address(msg.sender), _amount);
1124         totalDeposits = totalDeposits.sub(_amount);
1125 
1126         // Emit Withdraw event
1127         emit Withdraw(msg.sender, stakeId, _amount);
1128     }
1129 
1130     // Withdraw without caring about rewards. EMERGENCY ONLY.
1131     function emergencyWithdraw(uint256 stakeId)
1132         external
1133         nonReentrant
1134         validateStakeByStakeId(msg.sender, stakeId)
1135     {
1136         StakeInfo storage stake = stakeInfo[msg.sender][stakeId];
1137 
1138         // if early withdraw is not allowed, user can't withdraw funds before
1139         if (!isEarlyWithdrawAllowed) {
1140             bool minimalTimeStakeRespected = stake.depositTime.add(
1141                 minTimeToStake
1142             ) <= block.timestamp;
1143             // Check if user has respected minimal time to stake, require it.
1144             require(
1145                 minimalTimeStakeRespected,
1146                 "User can not withdraw funds yet."
1147             );
1148         }
1149 
1150         tokenStaked.safeTransfer(address(msg.sender), stake.amount);
1151         totalDeposits = totalDeposits.sub(stake.amount);
1152 
1153         emit EmergencyWithdraw(msg.sender, stakeId, stake.amount);
1154 
1155         stake.amount = 0;
1156         stake.rewardDebt = 0;
1157     }
1158 
1159     // Get number of stakes user has
1160     function getNumberOfUserStakes(address user)
1161         external
1162         view
1163         returns (uint256)
1164     {
1165         return stakeInfo[user].length;
1166     }
1167 
1168     // Get user pending amounts, stakes and deposit time
1169     function getUserStakesAndPendingAmounts(address user)
1170         external
1171         view
1172         returns (
1173             uint256[] memory,
1174             uint256[] memory,
1175             uint256[] memory
1176         )
1177     {
1178         uint256 numberOfStakes = stakeInfo[user].length;
1179 
1180         uint256[] memory deposits = new uint256[](numberOfStakes);
1181         uint256[] memory pendingAmounts = new uint256[](numberOfStakes);
1182         uint256[] memory depositTime = new uint256[](numberOfStakes);
1183 
1184         for (uint256 i = 0; i < numberOfStakes; i++) {
1185             deposits[i] = deposited(user, i);
1186             pendingAmounts[i] = pending(user, i);
1187             depositTime[i] = depositTimestamp(user, i);
1188         }
1189 
1190         return (deposits, pendingAmounts, depositTime);
1191     }
1192 
1193     // Get total rewards locked/unlocked
1194     function getTotalRewardsLockedUnlocked()
1195         external
1196         view
1197         returns (uint256, uint256)
1198     {
1199         uint256 totalRewardsLocked;
1200         uint256 totalRewardsUnlocked;
1201 
1202         if (block.timestamp <= startTime) {
1203             totalRewardsUnlocked = 0;
1204             totalRewardsLocked = totalRewards;
1205         } else {
1206             uint256 lastTime = block.timestamp < endTime
1207                 ? block.timestamp
1208                 : endTime;
1209             totalRewardsUnlocked = rewardPerSecond.mul(lastTime - startTime);
1210             totalRewardsLocked = totalRewards - totalRewardsUnlocked;
1211         }
1212 
1213         return (totalRewardsUnlocked, totalRewardsLocked);
1214     }
1215 
1216     // Transfer ERC20 and update the required ERC20 to payout all rewards
1217     function _erc20Transfer(address _to, uint256 _amount) internal {
1218         if (isFlatFeeAllowed) {
1219             // Collect flat fee
1220             require(
1221                 msg.value >= flatFeeAmount,
1222                 "Payable amount is less than fee amount."
1223             );
1224             (bool sent, ) = payable(feeCollector).call{value: msg.value}("");
1225             require(sent, "Failed to end flat fee");
1226             // send reward
1227             erc20.transfer(_to, _amount);
1228             paidOut += _amount;
1229         } else if (stakeFeePercent > 0) {
1230             // Collect reward fee
1231             uint256 feeAmount = _amount.mul(rewardFeePercent).div(100);
1232             uint256 rewardAmount = _amount.sub(feeAmount);
1233             erc20.transfer(feeCollector, feeAmount);
1234             // send reward
1235             erc20.transfer(_to, rewardAmount);
1236             paidOut += _amount;
1237         } else {
1238             erc20.transfer(_to, _amount);
1239             paidOut += _amount;
1240         }
1241     }
1242 }