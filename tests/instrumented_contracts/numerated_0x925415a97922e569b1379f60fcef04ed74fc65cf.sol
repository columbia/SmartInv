1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
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
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         uint256 c = a + b;
26         if (c < a) return (false, 0);
27         return (true, c);
28     }
29 
30     /**
31      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         if (b > a) return (false, 0);
37         return (true, a - b);
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49         if (a == 0) return (true, 0);
50         uint256 c = a * b;
51         if (c / a != b) return (false, 0);
52         return (true, c);
53     }
54 
55     /**
56      * @dev Returns the division of two unsigned integers, with a division by zero flag.
57      *
58      * _Available since v3.4._
59      */
60     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         if (b == 0) return (false, 0);
62         return (true, a / b);
63     }
64 
65     /**
66      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         if (b == 0) return (false, 0);
72         return (true, a % b);
73     }
74 
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      *
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b <= a, "SafeMath: subtraction overflow");
103         return a - b;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      *
114      * - Multiplication cannot overflow.
115      */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) return 0;
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers, reverting on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b > 0, "SafeMath: division by zero");
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b > 0, "SafeMath: modulo by zero");
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         return a - b;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * CAUTION: This function is deprecated because it requires allocating memory for the error
180      * message unnecessarily. For custom revert reasons use {tryDiv}.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         return a / b;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * reverting with custom message when dividing by zero.
198      *
199      * CAUTION: This function is deprecated because it requires allocating memory for the error
200      * message unnecessarily. For custom revert reasons use {tryMod}.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         return a % b;
213     }
214 }
215 
216 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
217 
218 
219 
220 pragma solidity >=0.6.0 <0.8.0;
221 
222 /**
223  * @dev Interface of the ERC20 standard as defined in the EIP.
224  */
225 interface IERC20 {
226     /**
227      * @dev Returns the amount of tokens in existence.
228      */
229     function totalSupply() external view returns (uint256);
230 
231     /**
232      * @dev Returns the amount of tokens owned by `account`.
233      */
234     function balanceOf(address account) external view returns (uint256);
235 
236     /**
237      * @dev Moves `amount` tokens from the caller's account to `recipient`.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transfer(address recipient, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Returns the remaining number of tokens that `spender` will be
247      * allowed to spend on behalf of `owner` through {transferFrom}. This is
248      * zero by default.
249      *
250      * This value changes when {approve} or {transferFrom} are called.
251      */
252     function allowance(address owner, address spender) external view returns (uint256);
253 
254     /**
255      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
256      *
257      * Returns a boolean value indicating whether the operation succeeded.
258      *
259      * IMPORTANT: Beware that changing an allowance with this method brings the risk
260      * that someone may use both the old and the new allowance by unfortunate
261      * transaction ordering. One possible solution to mitigate this race
262      * condition is to first reduce the spender's allowance to 0 and set the
263      * desired value afterwards:
264      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265      *
266      * Emits an {Approval} event.
267      */
268     function approve(address spender, uint256 amount) external returns (bool);
269 
270     /**
271      * @dev Moves `amount` tokens from `sender` to `recipient` using the
272      * allowance mechanism. `amount` is then deducted from the caller's
273      * allowance.
274      *
275      * Returns a boolean value indicating whether the operation succeeded.
276      *
277      * Emits a {Transfer} event.
278      */
279     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
280 
281     /**
282      * @dev Emitted when `value` tokens are moved from one account (`from`) to
283      * another (`to`).
284      *
285      * Note that `value` may be zero.
286      */
287     event Transfer(address indexed from, address indexed to, uint256 value);
288 
289     /**
290      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
291      * a call to {approve}. `value` is the new allowance.
292      */
293     event Approval(address indexed owner, address indexed spender, uint256 value);
294 }
295 
296 // File: @openzeppelin/contracts/utils/Address.sol
297 
298 
299 
300 pragma solidity >=0.6.2 <0.8.0;
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, `isContract` will return false for the following
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      */
323     function isContract(address account) internal view returns (bool) {
324         // This method relies on extcodesize, which returns 0 for contracts in
325         // construction, since the code is only stored at the end of the
326         // constructor execution.
327 
328         uint256 size;
329         // solhint-disable-next-line no-inline-assembly
330         assembly { size := extcodesize(account) }
331         return size > 0;
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(address(this).balance >= amount, "Address: insufficient balance");
352 
353         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
354         (bool success, ) = recipient.call{ value: amount }("");
355         require(success, "Address: unable to send value, recipient may have reverted");
356     }
357 
358     /**
359      * @dev Performs a Solidity function call using a low level `call`. A
360      * plain`call` is an unsafe replacement for a function call: use this
361      * function instead.
362      *
363      * If `target` reverts with a revert reason, it is bubbled up by this
364      * function (like regular Solidity function calls).
365      *
366      * Returns the raw returned data. To convert to the expected return value,
367      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
368      *
369      * Requirements:
370      *
371      * - `target` must be a contract.
372      * - calling `target` with `data` must not revert.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
377       return functionCall(target, data, "Address: low-level call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
382      * `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, 0, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but also transferring `value` wei to `target`.
393      *
394      * Requirements:
395      *
396      * - the calling contract must have an ETH balance of at least `value`.
397      * - the called Solidity function must be `payable`.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
407      * with `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
412         require(address(this).balance >= value, "Address: insufficient balance for call");
413         require(isContract(target), "Address: call to non-contract");
414 
415         // solhint-disable-next-line avoid-low-level-calls
416         (bool success, bytes memory returndata) = target.call{ value: value }(data);
417         return _verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
427         return functionStaticCall(target, data, "Address: low-level static call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
437         require(isContract(target), "Address: static call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = target.staticcall(data);
441         return _verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
451         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
456      * but performing a delegate call.
457      *
458      * _Available since v3.4._
459      */
460     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
461         require(isContract(target), "Address: delegate call to non-contract");
462 
463         // solhint-disable-next-line avoid-low-level-calls
464         (bool success, bytes memory returndata) = target.delegatecall(data);
465         return _verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
469         if (success) {
470             return returndata;
471         } else {
472             // Look for revert reason and bubble it up if present
473             if (returndata.length > 0) {
474                 // The easiest way to bubble the revert reason is using memory via assembly
475 
476                 // solhint-disable-next-line no-inline-assembly
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
489 
490 
491 
492 pragma solidity >=0.6.0 <0.8.0;
493 
494 
495 
496 
497 /**
498  * @title SafeERC20
499  * @dev Wrappers around ERC20 operations that throw on failure (when the token
500  * contract returns false). Tokens that return no value (and instead revert or
501  * throw on failure) are also supported, non-reverting calls are assumed to be
502  * successful.
503  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
504  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
505  */
506 library SafeERC20 {
507     using SafeMath for uint256;
508     using Address for address;
509 
510     function safeTransfer(IERC20 token, address to, uint256 value) internal {
511         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
512     }
513 
514     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
515         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
516     }
517 
518     /**
519      * @dev Deprecated. This function has issues similar to the ones found in
520      * {IERC20-approve}, and its usage is discouraged.
521      *
522      * Whenever possible, use {safeIncreaseAllowance} and
523      * {safeDecreaseAllowance} instead.
524      */
525     function safeApprove(IERC20 token, address spender, uint256 value) internal {
526         // safeApprove should only be called when setting an initial allowance,
527         // or when resetting it to zero. To increase and decrease it, use
528         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
529         // solhint-disable-next-line max-line-length
530         require((value == 0) || (token.allowance(address(this), spender) == 0),
531             "SafeERC20: approve from non-zero to non-zero allowance"
532         );
533         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
534     }
535 
536     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
537         uint256 newAllowance = token.allowance(address(this), spender).add(value);
538         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
539     }
540 
541     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
542         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
543         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
544     }
545 
546     /**
547      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
548      * on the return value: the return value is optional (but if data is returned, it must not be false).
549      * @param token The token targeted by the call.
550      * @param data The call data (encoded using abi.encode or one of its variants).
551      */
552     function _callOptionalReturn(IERC20 token, bytes memory data) private {
553         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
554         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
555         // the target address contains contract code and also asserts for success in the low-level call.
556 
557         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
558         if (returndata.length > 0) { // Return data is optional
559             // solhint-disable-next-line max-line-length
560             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
561         }
562     }
563 }
564 
565 // File: @openzeppelin/contracts/utils/Context.sol
566 
567 
568 
569 pragma solidity >=0.6.0 <0.8.0;
570 
571 /*
572  * @dev Provides information about the current execution context, including the
573  * sender of the transaction and its data. While these are generally available
574  * via msg.sender and msg.data, they should not be accessed in such a direct
575  * manner, since when dealing with GSN meta-transactions the account sending and
576  * paying for execution may not be the actual sender (as far as an application
577  * is concerned).
578  *
579  * This contract is only required for intermediate, library-like contracts.
580  */
581 abstract contract Context {
582     function _msgSender() internal view virtual returns (address payable) {
583         return msg.sender;
584     }
585 
586     function _msgData() internal view virtual returns (bytes memory) {
587         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
588         return msg.data;
589     }
590 }
591 
592 // File: @openzeppelin/contracts/access/Ownable.sol
593 
594 
595 
596 pragma solidity >=0.6.0 <0.8.0;
597 
598 /**
599  * @dev Contract module which provides a basic access control mechanism, where
600  * there is an account (an owner) that can be granted exclusive access to
601  * specific functions.
602  *
603  * By default, the owner account will be the one that deploys the contract. This
604  * can later be changed with {transferOwnership}.
605  *
606  * This module is used through inheritance. It will make available the modifier
607  * `onlyOwner`, which can be applied to your functions to restrict their use to
608  * the owner.
609  */
610 abstract contract Ownable is Context {
611     address private _owner;
612 
613     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
614 
615     /**
616      * @dev Initializes the contract setting the deployer as the initial owner.
617      */
618     constructor () internal {
619         address msgSender = _msgSender();
620         _owner = msgSender;
621         emit OwnershipTransferred(address(0), msgSender);
622     }
623 
624     /**
625      * @dev Returns the address of the current owner.
626      */
627     function owner() public view virtual returns (address) {
628         return _owner;
629     }
630 
631     /**
632      * @dev Throws if called by any account other than the owner.
633      */
634     modifier onlyOwner() {
635         require(owner() == _msgSender(), "Ownable: caller is not the owner");
636         _;
637     }
638 
639     /**
640      * @dev Leaves the contract without owner. It will not be possible to call
641      * `onlyOwner` functions anymore. Can only be called by the current owner.
642      *
643      * NOTE: Renouncing ownership will leave the contract without an owner,
644      * thereby removing any functionality that is only available to the owner.
645      */
646     function renounceOwnership() public virtual onlyOwner {
647         emit OwnershipTransferred(_owner, address(0));
648         _owner = address(0);
649     }
650 
651     /**
652      * @dev Transfers ownership of the contract to a new account (`newOwner`).
653      * Can only be called by the current owner.
654      */
655     function transferOwnership(address newOwner) public virtual onlyOwner {
656         require(newOwner != address(0), "Ownable: new owner is the zero address");
657         emit OwnershipTransferred(_owner, newOwner);
658         _owner = newOwner;
659     }
660 }
661 
662 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
663 
664 
665 
666 pragma solidity >=0.6.0 <0.8.0;
667 
668 /**
669  * @dev Contract module that helps prevent reentrant calls to a function.
670  *
671  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
672  * available, which can be applied to functions to make sure there are no nested
673  * (reentrant) calls to them.
674  *
675  * Note that because there is a single `nonReentrant` guard, functions marked as
676  * `nonReentrant` may not call one another. This can be worked around by making
677  * those functions `private`, and then adding `external` `nonReentrant` entry
678  * points to them.
679  *
680  * TIP: If you would like to learn more about reentrancy and alternative ways
681  * to protect against it, check out our blog post
682  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
683  */
684 abstract contract ReentrancyGuard {
685     // Booleans are more expensive than uint256 or any type that takes up a full
686     // word because each write operation emits an extra SLOAD to first read the
687     // slot's contents, replace the bits taken up by the boolean, and then write
688     // back. This is the compiler's defense against contract upgrades and
689     // pointer aliasing, and it cannot be disabled.
690 
691     // The values being non-zero value makes deployment a bit more expensive,
692     // but in exchange the refund on every call to nonReentrant will be lower in
693     // amount. Since refunds are capped to a percentage of the total
694     // transaction's gas, it is best to keep them low in cases like this one, to
695     // increase the likelihood of the full refund coming into effect.
696     uint256 private constant _NOT_ENTERED = 1;
697     uint256 private constant _ENTERED = 2;
698 
699     uint256 private _status;
700 
701     constructor () internal {
702         _status = _NOT_ENTERED;
703     }
704 
705     /**
706      * @dev Prevents a contract from calling itself, directly or indirectly.
707      * Calling a `nonReentrant` function from another `nonReentrant`
708      * function is not supported. It is possible to prevent this from happening
709      * by making the `nonReentrant` function external, and make it call a
710      * `private` function that does the actual work.
711      */
712     modifier nonReentrant() {
713         // On the first call to nonReentrant, _notEntered will be true
714         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
715 
716         // Any calls to nonReentrant after this point will fail
717         _status = _ENTERED;
718 
719         _;
720 
721         // By storing the original value once again, a refund is triggered (see
722         // https://eips.ethereum.org/EIPS/eip-2200)
723         _status = _NOT_ENTERED;
724     }
725 }
726 
727 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
728 
729 
730 
731 pragma solidity >=0.6.0 <0.8.0;
732 
733 
734 
735 
736 /**
737  * @dev Implementation of the {IERC20} interface.
738  *
739  * This implementation is agnostic to the way tokens are created. This means
740  * that a supply mechanism has to be added in a derived contract using {_mint}.
741  * For a generic mechanism see {ERC20PresetMinterPauser}.
742  *
743  * TIP: For a detailed writeup see our guide
744  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
745  * to implement supply mechanisms].
746  *
747  * We have followed general OpenZeppelin guidelines: functions revert instead
748  * of returning `false` on failure. This behavior is nonetheless conventional
749  * and does not conflict with the expectations of ERC20 applications.
750  *
751  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
752  * This allows applications to reconstruct the allowance for all accounts just
753  * by listening to said events. Other implementations of the EIP may not emit
754  * these events, as it isn't required by the specification.
755  *
756  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
757  * functions have been added to mitigate the well-known issues around setting
758  * allowances. See {IERC20-approve}.
759  */
760 contract ERC20 is Context, IERC20 {
761     using SafeMath for uint256;
762 
763     mapping (address => uint256) private _balances;
764 
765     mapping (address => mapping (address => uint256)) private _allowances;
766 
767     uint256 private _totalSupply;
768 
769     string private _name;
770     string private _symbol;
771     uint8 private _decimals;
772 
773     /**
774      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
775      * a default value of 18.
776      *
777      * To select a different value for {decimals}, use {_setupDecimals}.
778      *
779      * All three of these values are immutable: they can only be set once during
780      * construction.
781      */
782     constructor (string memory name_, string memory symbol_) public {
783         _name = name_;
784         _symbol = symbol_;
785         _decimals = 9;
786     }
787 
788     /**
789      * @dev Returns the name of the token.
790      */
791     function name() public view virtual returns (string memory) {
792         return _name;
793     }
794 
795     /**
796      * @dev Returns the symbol of the token, usually a shorter version of the
797      * name.
798      */
799     function symbol() public view virtual returns (string memory) {
800         return _symbol;
801     }
802 
803     /**
804      * @dev Returns the number of decimals used to get its user representation.
805      * For example, if `decimals` equals `2`, a balance of `505` tokens should
806      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
807      *
808      * Tokens usually opt for a value of 18, imitating the relationship between
809      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
810      * called.
811      *
812      * NOTE: This information is only used for _display_ purposes: it in
813      * no way affects any of the arithmetic of the contract, including
814      * {IERC20-balanceOf} and {IERC20-transfer}.
815      */
816     function decimals() public view virtual returns (uint8) {
817         return _decimals;
818     }
819 
820     /**
821      * @dev See {IERC20-totalSupply}.
822      */
823     function totalSupply() public view virtual override returns (uint256) {
824         return _totalSupply;
825     }
826 
827     /**
828      * @dev See {IERC20-balanceOf}.
829      */
830     function balanceOf(address account) public view virtual override returns (uint256) {
831         return _balances[account];
832     }
833 
834     /**
835      * @dev See {IERC20-transfer}.
836      *
837      * Requirements:
838      *
839      * - `recipient` cannot be the zero address.
840      * - the caller must have a balance of at least `amount`.
841      */
842     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
843         _transfer(_msgSender(), recipient, amount);
844         return true;
845     }
846 
847     /**
848      * @dev See {IERC20-allowance}.
849      */
850     function allowance(address owner, address spender) public view virtual override returns (uint256) {
851         return _allowances[owner][spender];
852     }
853 
854     /**
855      * @dev See {IERC20-approve}.
856      *
857      * Requirements:
858      *
859      * - `spender` cannot be the zero address.
860      */
861     function approve(address spender, uint256 amount) public virtual override returns (bool) {
862         _approve(_msgSender(), spender, amount);
863         return true;
864     }
865 
866     /**
867      * @dev See {IERC20-transferFrom}.
868      *
869      * Emits an {Approval} event indicating the updated allowance. This is not
870      * required by the EIP. See the note at the beginning of {ERC20}.
871      *
872      * Requirements:
873      *
874      * - `sender` and `recipient` cannot be the zero address.
875      * - `sender` must have a balance of at least `amount`.
876      * - the caller must have allowance for ``sender``'s tokens of at least
877      * `amount`.
878      */
879     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
880         _transfer(sender, recipient, amount);
881         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
882         return true;
883     }
884 
885     /**
886      * @dev Atomically increases the allowance granted to `spender` by the caller.
887      *
888      * This is an alternative to {approve} that can be used as a mitigation for
889      * problems described in {IERC20-approve}.
890      *
891      * Emits an {Approval} event indicating the updated allowance.
892      *
893      * Requirements:
894      *
895      * - `spender` cannot be the zero address.
896      */
897     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
898         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
899         return true;
900     }
901 
902     /**
903      * @dev Atomically decreases the allowance granted to `spender` by the caller.
904      *
905      * This is an alternative to {approve} that can be used as a mitigation for
906      * problems described in {IERC20-approve}.
907      *
908      * Emits an {Approval} event indicating the updated allowance.
909      *
910      * Requirements:
911      *
912      * - `spender` cannot be the zero address.
913      * - `spender` must have allowance for the caller of at least
914      * `subtractedValue`.
915      */
916     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
917         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
918         return true;
919     }
920 
921     /**
922      * @dev Moves tokens `amount` from `sender` to `recipient`.
923      *
924      * This is internal function is equivalent to {transfer}, and can be used to
925      * e.g. implement automatic token fees, slashing mechanisms, etc.
926      *
927      * Emits a {Transfer} event.
928      *
929      * Requirements:
930      *
931      * - `sender` cannot be the zero address.
932      * - `recipient` cannot be the zero address.
933      * - `sender` must have a balance of at least `amount`.
934      */
935     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
936         require(sender != address(0), "ERC20: transfer from the zero address");
937         require(recipient != address(0), "ERC20: transfer to the zero address");
938 
939         _beforeTokenTransfer(sender, recipient, amount);
940 
941         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
942         _balances[recipient] = _balances[recipient].add(amount);
943         emit Transfer(sender, recipient, amount);
944     }
945 
946     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
947      * the total supply.
948      *
949      * Emits a {Transfer} event with `from` set to the zero address.
950      *
951      * Requirements:
952      *
953      * - `to` cannot be the zero address.
954      */
955     function _mint(address account, uint256 amount) internal virtual {
956         require(account != address(0), "ERC20: mint to the zero address");
957 
958         _beforeTokenTransfer(address(0), account, amount);
959 
960         _totalSupply = _totalSupply.add(amount);
961         _balances[account] = _balances[account].add(amount);
962         emit Transfer(address(0), account, amount);
963     }
964 
965     /**
966      * @dev Destroys `amount` tokens from `account`, reducing the
967      * total supply.
968      *
969      * Emits a {Transfer} event with `to` set to the zero address.
970      *
971      * Requirements:
972      *
973      * - `account` cannot be the zero address.
974      * - `account` must have at least `amount` tokens.
975      */
976     function _burn(address account, uint256 amount) internal virtual {
977         require(account != address(0), "ERC20: burn from the zero address");
978 
979         _beforeTokenTransfer(account, address(0), amount);
980 
981         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
982         _totalSupply = _totalSupply.sub(amount);
983         emit Transfer(account, address(0), amount);
984     }
985 
986     /**
987      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
988      *
989      * This internal function is equivalent to `approve`, and can be used to
990      * e.g. set automatic allowances for certain subsystems, etc.
991      *
992      * Emits an {Approval} event.
993      *
994      * Requirements:
995      *
996      * - `owner` cannot be the zero address.
997      * - `spender` cannot be the zero address.
998      */
999     function _approve(address owner, address spender, uint256 amount) internal virtual {
1000         require(owner != address(0), "ERC20: approve from the zero address");
1001         require(spender != address(0), "ERC20: approve to the zero address");
1002 
1003         _allowances[owner][spender] = amount;
1004         emit Approval(owner, spender, amount);
1005     }
1006 
1007     /**
1008      * @dev Sets {decimals} to a value other than the default one of 18.
1009      *
1010      * WARNING: This function should only be called from the constructor. Most
1011      * applications that interact with token contracts will not expect
1012      * {decimals} to ever change, and may work incorrectly if it does.
1013      */
1014     function _setupDecimals(uint8 decimals_) internal virtual {
1015         _decimals = decimals_;
1016     }
1017 
1018     /**
1019      * @dev Hook that is called before any transfer of tokens. This includes
1020      * minting and burning.
1021      *
1022      * Calling conditions:
1023      *
1024      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1025      * will be to transferred to `to`.
1026      * - when `from` is zero, `amount` tokens will be minted for `to`.
1027      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1028      * - `from` and `to` are never both zero.
1029      *
1030      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1031      */
1032     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1033 }
1034 
1035 contract StakedOtherdao is ERC20, Ownable {
1036     using SafeMath for uint256;
1037     using SafeERC20 for IERC20;
1038 
1039     // Info of each user.
1040     struct UserInfo {
1041         uint256 amount;         
1042         uint256 rewardDebt;     
1043     }
1044 
1045     // Info of each pool.
1046     struct PoolInfo {
1047         IERC20 lpToken;           // Address of LP token contract.
1048         uint256 allocPoint;       // How many allocation points assigned to this pool. Rewards to distribute per block.
1049         uint256 lastRewardBlock;  // Last block number that tokens distribution occurs.
1050         uint256 accRewardTokenPerShare;   // Accumulated tokens per share, times 1e12. See below.
1051         uint16 depositFeeBP;      // Deposit fee in basis points
1052     }
1053 
1054 
1055     // Info of each pool.
1056     PoolInfo[] public poolInfo;
1057     // Info of each user that stakes LP tokens.
1058     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1059     // Total allocation points. Must be the sum of all allocation points in all pools.
1060     uint256 public totalAllocPoint = 0;
1061     // The block number when reward distribution starts.
1062     uint256 public startBlock;
1063 
1064     // The REWARD TOKEN!
1065     IERC20 public rewardToken;
1066     // Dev address.
1067     address payable public devaddr;
1068     // Reward tokens distributed per block.
1069     uint256 public rewardTokenPerBlock;
1070     // Bonus muliplier for early stakers.
1071     uint256 public constant BONUS_MULTIPLIER = 1;
1072     // Deposit Fee address
1073     address public feeAddress;
1074     // Base Token reward bool
1075     bool public isETH;
1076     // Reward fee
1077     uint16 public rewardFee;
1078 
1079     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1080     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1081     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1082 
1083     constructor(
1084         IERC20 _rewardToken,
1085         address payable _devaddr,
1086         address _feeAddress,
1087         uint256 _rewardTokenPerBlock,
1088         uint256 _startBlock,
1089         uint16 _rewardFee,
1090         string memory _name,
1091         string memory _symbol
1092     ) public ERC20(_name, _symbol) {
1093         rewardTokenPerBlock = _rewardTokenPerBlock;
1094         startBlock = _startBlock;
1095         rewardToken = _rewardToken;
1096         devaddr = _devaddr;
1097         feeAddress = _feeAddress;
1098         rewardFee = _rewardFee;
1099     }
1100 
1101 
1102     receive() external payable {
1103 
1104   	}
1105 
1106     function poolLength() external view returns (uint256) {
1107         return poolInfo.length;
1108     }
1109 
1110     // Add a new lp to the pool. Can only be called by the owner.
1111     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1112     function add(uint256 _allocPoint, IERC20 _lpToken, uint16 _depositFeeBP, bool _withUpdate) public onlyOwner {
1113         require(_depositFeeBP <= 10000, "add: invalid deposit fee basis points");
1114         if (_withUpdate) {
1115             massUpdatePools();
1116         }
1117         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1118         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1119         poolInfo.push(PoolInfo({
1120             lpToken: _lpToken,
1121             allocPoint: _allocPoint,
1122             lastRewardBlock: lastRewardBlock,
1123             accRewardTokenPerShare: 0,
1124             depositFeeBP: _depositFeeBP
1125         }));
1126     }
1127 
1128     // Update the given pool's Token allocation point and deposit fee. Can only be called by the owner.
1129     function set(uint256 _pid, uint256 _allocPoint, uint16 _depositFeeBP, bool _withUpdate) public onlyOwner {
1130         require(_depositFeeBP <= 10000, "set: invalid deposit fee basis points");
1131         if (_withUpdate) {
1132             massUpdatePools();
1133         }
1134         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1135         poolInfo[_pid].allocPoint = _allocPoint;
1136         poolInfo[_pid].depositFeeBP = _depositFeeBP;
1137     }
1138 
1139     // Return reward multiplier over the given _from to _to block.
1140     function getMultiplier(uint256 _from, uint256 _to) public pure returns (uint256) {
1141         return _to.sub(_from).mul(BONUS_MULTIPLIER);
1142     }
1143 
1144     // View function to see pending Rewards on frontend.
1145     function pendingRewardToken(uint256 _pid, address _user) external view returns (uint256) {
1146         PoolInfo storage pool = poolInfo[_pid];
1147         UserInfo storage user = userInfo[_pid][_user];
1148         uint256 accRewardTokenPerShare = pool.accRewardTokenPerShare;
1149         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1150         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1151             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1152             uint256 tokenReward = multiplier.mul(rewardTokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1153             accRewardTokenPerShare = accRewardTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1154         }
1155         uint256 pending = user.amount.mul(accRewardTokenPerShare).div(1e12).sub(user.rewardDebt);
1156         return pending.sub(pending.div(rewardFee));
1157     }
1158 
1159     // Update reward variables for all pools. Be careful of gas spending!
1160     function massUpdatePools() public {
1161         uint256 length = poolInfo.length;
1162         for (uint256 pid = 0; pid < length; ++pid) {
1163             updatePool(pid);
1164         }
1165     }
1166 
1167     // Update reward variables of the given pool to be up-to-date.
1168     function updatePool(uint256 _pid) public {
1169         PoolInfo storage pool = poolInfo[_pid];
1170         if (block.number <= pool.lastRewardBlock) {
1171             return;
1172         }
1173         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1174         if (lpSupply == 0 || pool.allocPoint == 0) {
1175             pool.lastRewardBlock = block.number;
1176             return;
1177         }
1178         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1179         uint256 tokenReward = multiplier.mul(rewardTokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1180         pool.accRewardTokenPerShare = pool.accRewardTokenPerShare.add(tokenReward.mul(1e12).div(lpSupply));
1181         pool.lastRewardBlock = block.number;
1182     }
1183 
1184     // Deposit tokens to Stake for reward allocation.
1185     function deposit(uint256 _pid, uint256 _amount) public {
1186         PoolInfo storage pool = poolInfo[_pid];
1187         UserInfo storage user = userInfo[_pid][msg.sender];
1188         updatePool(_pid);
1189         if (user.amount > 0) {
1190             uint256 pending = user.amount.mul(pool.accRewardTokenPerShare).div(1e12).sub(user.rewardDebt);
1191             if(pending > 0) {
1192                 if(!isETH){
1193                     require(rewardToken.balanceOf(address(this)) >= pending, 'Rewardpool empty');
1194                     safeRewardTokenTransfer(devaddr, pending.div(rewardFee));
1195                     pending = pending - pending.div(rewardFee);
1196                     safeRewardTokenTransfer(msg.sender, pending);
1197                 } else {
1198                     require(address(this).balance >= pending, 'Rewardpool empty');
1199                     devaddr.transfer(pending.div(rewardFee));
1200                     pending = pending - pending.div(rewardFee);
1201                     msg.sender.transfer(pending);
1202                 }
1203             }
1204         }
1205         if(_amount > 0) {
1206             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1207             if(pool.depositFeeBP > 0){
1208                 uint256 depositFee = _amount.mul(pool.depositFeeBP).div(10000);
1209                 pool.lpToken.safeTransfer(feeAddress, depositFee);
1210                 user.amount = user.amount.add(_amount).sub(depositFee);
1211             }else{
1212                 user.amount = user.amount.add(_amount);
1213             }
1214         }
1215         user.rewardDebt = user.amount.mul(pool.accRewardTokenPerShare).div(1e12);
1216         uint256 shares = 0;
1217         shares = _amount;
1218         _mint(msg.sender, shares);
1219         emit Deposit(msg.sender, _pid, _amount);
1220     }
1221 
1222    // Withdraw tokens from Staking.
1223     function withdraw(uint256 _pid, uint256 _amount) public {
1224         PoolInfo storage pool = poolInfo[_pid];
1225         UserInfo storage user = userInfo[_pid][msg.sender];
1226         require(user.amount >= _amount, "withdraw: not good");
1227         updatePool(_pid);
1228         uint256 pending = user.amount.mul(pool.accRewardTokenPerShare).div(1e12).sub(user.rewardDebt);
1229         if(pending > 0) {
1230             if(!isETH){
1231                 require(rewardToken.balanceOf(address(this)) >= pending, 'Rewardpool empty');
1232                 safeRewardTokenTransfer(devaddr, pending.div(rewardFee));
1233                 pending = pending - pending.div(rewardFee);
1234                 safeRewardTokenTransfer(msg.sender, pending);
1235             } else {
1236                 require(address(this).balance >= pending, 'Rewardpool empty');
1237                 devaddr.transfer(pending.div(rewardFee));
1238                 pending = pending - pending.div(rewardFee);
1239                 msg.sender.transfer(pending);
1240             }  
1241         }
1242         if(_amount > 0) {
1243             user.amount = user.amount.sub(_amount);
1244             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1245         }
1246         user.rewardDebt = user.amount.mul(pool.accRewardTokenPerShare).div(1e12);
1247         _burn(msg.sender, _amount);
1248         emit Withdraw(msg.sender, _pid, _amount);
1249     }
1250 
1251     // Withdraw without caring about rewards. EMERGENCY ONLY.
1252     function emergencyWithdraw(uint256 _pid) public {
1253         PoolInfo storage pool = poolInfo[_pid];
1254         UserInfo storage user = userInfo[_pid][msg.sender];
1255         uint256 amount = user.amount;
1256         user.amount = 0;
1257         user.rewardDebt = 0;
1258         pool.lpToken.safeTransfer(address(msg.sender), amount);
1259         _burn(msg.sender, amount);
1260         emit EmergencyWithdraw(msg.sender, _pid, amount);
1261     }
1262 
1263     // Safe rewardToken transfer function, just in case if rounding error causes pool to not have enough tokens.
1264     function safeRewardTokenTransfer(address _to, uint256 _amount) internal {
1265         uint256 rewardTokenBal = rewardToken.balanceOf(address(this));
1266         if (_amount > rewardTokenBal) {
1267             rewardToken.transfer(_to, rewardTokenBal);
1268         } else {
1269             rewardToken.transfer(_to, _amount);
1270         }
1271     }
1272     // Update dev address by the previous dev.
1273     function dev(address payable _devaddr) public {
1274         require(msg.sender == devaddr, "dev: wut?");
1275         devaddr = _devaddr;
1276     }
1277 
1278     function setFeeAddress(address _feeAddress) public{
1279         require(msg.sender == feeAddress, "setFeeAddress: FORBIDDEN");
1280         feeAddress = _feeAddress;
1281     }
1282 
1283     function setIsETH(bool _isETH) external onlyOwner {
1284         isETH = _isETH;
1285     }
1286 
1287     function setRewardToken(IERC20 _rewardToken) external onlyOwner {
1288         rewardToken = _rewardToken;
1289     }
1290 
1291     function setRewardFee(uint16 _rewardFee) external onlyOwner {
1292         require(_rewardFee >= 0 && _rewardFee <= 50);
1293         rewardFee = _rewardFee;
1294     }
1295 
1296     function updateEmissionRate(uint256 _rewardTokenPerBlock) public onlyOwner {
1297         massUpdatePools();
1298         rewardTokenPerBlock = _rewardTokenPerBlock;
1299     }
1300 }