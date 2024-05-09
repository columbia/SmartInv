1 // SPDX-License-Identifier: MIT
2 
3 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
163 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
164 
165 pragma solidity >=0.6.2 <0.8.0;
166 
167 /**
168  * @dev Collection of functions related to the address type
169  */
170 library Address {
171     /**
172      * @dev Returns true if `account` is a contract.
173      *
174      * [IMPORTANT]
175      * ====
176      * It is unsafe to assume that an address for which this function returns
177      * false is an externally-owned account (EOA) and not a contract.
178      *
179      * Among others, `isContract` will return false for the following
180      * types of addresses:
181      *
182      *  - an externally-owned account
183      *  - a contract in construction
184      *  - an address where a contract will be created
185      *  - an address where a contract lived, but was destroyed
186      * ====
187      */
188     function isContract(address account) internal view returns (bool) {
189         // This method relies on extcodesize, which returns 0 for contracts in
190         // construction, since the code is only stored at the end of the
191         // constructor execution.
192 
193         uint256 size;
194         // solhint-disable-next-line no-inline-assembly
195         assembly { size := extcodesize(account) }
196         return size > 0;
197     }
198 
199     /**
200      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
201      * `recipient`, forwarding all available gas and reverting on errors.
202      *
203      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
204      * of certain opcodes, possibly making contracts go over the 2300 gas limit
205      * imposed by `transfer`, making them unable to receive funds via
206      * `transfer`. {sendValue} removes this limitation.
207      *
208      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
209      *
210      * IMPORTANT: because control is transferred to `recipient`, care must be
211      * taken to not create reentrancy vulnerabilities. Consider using
212      * {ReentrancyGuard} or the
213      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
214      */
215     function sendValue(address payable recipient, uint256 amount) internal {
216         require(address(this).balance >= amount, "Address: insufficient balance");
217 
218         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
219         (bool success, ) = recipient.call{ value: amount }("");
220         require(success, "Address: unable to send value, recipient may have reverted");
221     }
222 
223     /**
224      * @dev Performs a Solidity function call using a low level `call`. A
225      * plain`call` is an unsafe replacement for a function call: use this
226      * function instead.
227      *
228      * If `target` reverts with a revert reason, it is bubbled up by this
229      * function (like regular Solidity function calls).
230      *
231      * Returns the raw returned data. To convert to the expected return value,
232      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
233      *
234      * Requirements:
235      *
236      * - `target` must be a contract.
237      * - calling `target` with `data` must not revert.
238      *
239      * _Available since v3.1._
240      */
241     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
242       return functionCall(target, data, "Address: low-level call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
247      * `errorMessage` as a fallback revert reason when `target` reverts.
248      *
249      * _Available since v3.1._
250      */
251     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, 0, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but also transferring `value` wei to `target`.
258      *
259      * Requirements:
260      *
261      * - the calling contract must have an ETH balance of at least `value`.
262      * - the called Solidity function must be `payable`.
263      *
264      * _Available since v3.1._
265      */
266     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
267         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
272      * with `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
277         require(address(this).balance >= value, "Address: insufficient balance for call");
278         require(isContract(target), "Address: call to non-contract");
279 
280         // solhint-disable-next-line avoid-low-level-calls
281         (bool success, bytes memory returndata) = target.call{ value: value }(data);
282         return _verifyCallResult(success, returndata, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but performing a static call.
288      *
289      * _Available since v3.3._
290      */
291     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
292         return functionStaticCall(target, data, "Address: low-level static call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
297      * but performing a static call.
298      *
299      * _Available since v3.3._
300      */
301     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
302         require(isContract(target), "Address: static call to non-contract");
303 
304         // solhint-disable-next-line avoid-low-level-calls
305         (bool success, bytes memory returndata) = target.staticcall(data);
306         return _verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
310         if (success) {
311             return returndata;
312         } else {
313             // Look for revert reason and bubble it up if present
314             if (returndata.length > 0) {
315                 // The easiest way to bubble the revert reason is using memory via assembly
316 
317                 // solhint-disable-next-line no-inline-assembly
318                 assembly {
319                     let returndata_size := mload(returndata)
320                     revert(add(32, returndata), returndata_size)
321                 }
322             } else {
323                 revert(errorMessage);
324             }
325         }
326     }
327 }
328 
329 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
330 
331 pragma solidity >=0.6.0 <0.8.0;
332 
333 
334 
335 
336 /**
337  * @title SafeERC20
338  * @dev Wrappers around ERC20 operations that throw on failure (when the token
339  * contract returns false). Tokens that return no value (and instead revert or
340  * throw on failure) are also supported, non-reverting calls are assumed to be
341  * successful.
342  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
343  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
344  */
345 library SafeERC20 {
346     using SafeMath for uint256;
347     using Address for address;
348 
349     function safeTransfer(IERC20 token, address to, uint256 value) internal {
350         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
351     }
352 
353     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
354         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
355     }
356 
357     /**
358      * @dev Deprecated. This function has issues similar to the ones found in
359      * {IERC20-approve}, and its usage is discouraged.
360      *
361      * Whenever possible, use {safeIncreaseAllowance} and
362      * {safeDecreaseAllowance} instead.
363      */
364     function safeApprove(IERC20 token, address spender, uint256 value) internal {
365         // safeApprove should only be called when setting an initial allowance,
366         // or when resetting it to zero. To increase and decrease it, use
367         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
368         // solhint-disable-next-line max-line-length
369         require((value == 0) || (token.allowance(address(this), spender) == 0),
370             "SafeERC20: approve from non-zero to non-zero allowance"
371         );
372         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
373     }
374 
375     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
376         uint256 newAllowance = token.allowance(address(this), spender).add(value);
377         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
378     }
379 
380     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
381         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
382         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
383     }
384 
385     /**
386      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
387      * on the return value: the return value is optional (but if data is returned, it must not be false).
388      * @param token The token targeted by the call.
389      * @param data The call data (encoded using abi.encode or one of its variants).
390      */
391     function _callOptionalReturn(IERC20 token, bytes memory data) private {
392         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
393         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
394         // the target address contains contract code and also asserts for success in the low-level call.
395 
396         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
397         if (returndata.length > 0) { // Return data is optional
398             // solhint-disable-next-line max-line-length
399             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
400         }
401     }
402 }
403 
404 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
405 
406 pragma solidity >=0.6.0 <0.8.0;
407 
408 /**
409  * @dev Interface of the ERC20 standard as defined in the EIP.
410  */
411 interface IERC20 {
412     /**
413      * @dev Returns the amount of tokens in existence.
414      */
415     function totalSupply() external view returns (uint256);
416 
417     /**
418      * @dev Returns the amount of tokens owned by `account`.
419      */
420     function balanceOf(address account) external view returns (uint256);
421 
422     /**
423      * @dev Moves `amount` tokens from the caller's account to `recipient`.
424      *
425      * Returns a boolean value indicating whether the operation succeeded.
426      *
427      * Emits a {Transfer} event.
428      */
429     function transfer(address recipient, uint256 amount) external returns (bool);
430 
431     /**
432      * @dev Returns the remaining number of tokens that `spender` will be
433      * allowed to spend on behalf of `owner` through {transferFrom}. This is
434      * zero by default.
435      *
436      * This value changes when {approve} or {transferFrom} are called.
437      */
438     function allowance(address owner, address spender) external view returns (uint256);
439 
440     /**
441      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
442      *
443      * Returns a boolean value indicating whether the operation succeeded.
444      *
445      * IMPORTANT: Beware that changing an allowance with this method brings the risk
446      * that someone may use both the old and the new allowance by unfortunate
447      * transaction ordering. One possible solution to mitigate this race
448      * condition is to first reduce the spender's allowance to 0 and set the
449      * desired value afterwards:
450      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
451      *
452      * Emits an {Approval} event.
453      */
454     function approve(address spender, uint256 amount) external returns (bool);
455 
456     /**
457      * @dev Moves `amount` tokens from `sender` to `recipient` using the
458      * allowance mechanism. `amount` is then deducted from the caller's
459      * allowance.
460      *
461      * Returns a boolean value indicating whether the operation succeeded.
462      *
463      * Emits a {Transfer} event.
464      */
465     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
466 
467     /**
468      * @dev Emitted when `value` tokens are moved from one account (`from`) to
469      * another (`to`).
470      *
471      * Note that `value` may be zero.
472      */
473     event Transfer(address indexed from, address indexed to, uint256 value);
474 
475     /**
476      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
477      * a call to {approve}. `value` is the new allowance.
478      */
479     event Approval(address indexed owner, address indexed spender, uint256 value);
480 }
481 
482 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
483 
484 pragma solidity >=0.6.0 <0.8.0;
485 
486 /*
487  * @dev Provides information about the current execution context, including the
488  * sender of the transaction and its data. While these are generally available
489  * via msg.sender and msg.data, they should not be accessed in such a direct
490  * manner, since when dealing with GSN meta-transactions the account sending and
491  * paying for execution may not be the actual sender (as far as an application
492  * is concerned).
493  *
494  * This contract is only required for intermediate, library-like contracts.
495  */
496 abstract contract Context {
497     function _msgSender() internal view virtual returns (address payable) {
498         return msg.sender;
499     }
500 
501     function _msgData() internal view virtual returns (bytes memory) {
502         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
503         return msg.data;
504     }
505 }
506 
507 // File: @openzeppelin\contracts\access\Ownable.sol
508 
509 pragma solidity >=0.6.0 <0.8.0;
510 
511 /**
512  * @dev Contract module which provides a basic access control mechanism, where
513  * there is an account (an owner) that can be granted exclusive access to
514  * specific functions.
515  *
516  * By default, the owner account will be the one that deploys the contract. This
517  * can later be changed with {transferOwnership}.
518  *
519  * This module is used through inheritance. It will make available the modifier
520  * `onlyOwner`, which can be applied to your functions to restrict their use to
521  * the owner.
522  */
523 abstract contract Ownable is Context {
524     address private _owner;
525 
526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
527 
528     /**
529      * @dev Initializes the contract setting the deployer as the initial owner.
530      */
531     constructor () internal {
532         address msgSender = _msgSender();
533         _owner = msgSender;
534         emit OwnershipTransferred(address(0), msgSender);
535     }
536 
537     /**
538      * @dev Returns the address of the current owner.
539      */
540     function owner() public view returns (address) {
541         return _owner;
542     }
543 
544     /**
545      * @dev Throws if called by any account other than the owner.
546      */
547     modifier onlyOwner() {
548         require(_owner == _msgSender(), "Ownable: caller is not the owner");
549         _;
550     }
551 
552     /**
553      * @dev Leaves the contract without owner. It will not be possible to call
554      * `onlyOwner` functions anymore. Can only be called by the current owner.
555      *
556      * NOTE: Renouncing ownership will leave the contract without an owner,
557      * thereby removing any functionality that is only available to the owner.
558      */
559     function renounceOwnership() public virtual onlyOwner {
560         emit OwnershipTransferred(_owner, address(0));
561         _owner = address(0);
562     }
563 
564     /**
565      * @dev Transfers ownership of the contract to a new account (`newOwner`).
566      * Can only be called by the current owner.
567      */
568     function transferOwnership(address newOwner) public virtual onlyOwner {
569         require(newOwner != address(0), "Ownable: new owner is the zero address");
570         emit OwnershipTransferred(_owner, newOwner);
571         _owner = newOwner;
572     }
573 }
574 
575 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
576 
577 pragma solidity >=0.6.0 <0.8.0;
578 
579 /**
580  * @dev Contract module that helps prevent reentrant calls to a function.
581  *
582  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
583  * available, which can be applied to functions to make sure there are no nested
584  * (reentrant) calls to them.
585  *
586  * Note that because there is a single `nonReentrant` guard, functions marked as
587  * `nonReentrant` may not call one another. This can be worked around by making
588  * those functions `private`, and then adding `external` `nonReentrant` entry
589  * points to them.
590  *
591  * TIP: If you would like to learn more about reentrancy and alternative ways
592  * to protect against it, check out our blog post
593  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
594  */
595 abstract contract ReentrancyGuard {
596     // Booleans are more expensive than uint256 or any type that takes up a full
597     // word because each write operation emits an extra SLOAD to first read the
598     // slot's contents, replace the bits taken up by the boolean, and then write
599     // back. This is the compiler's defense against contract upgrades and
600     // pointer aliasing, and it cannot be disabled.
601 
602     // The values being non-zero value makes deployment a bit more expensive,
603     // but in exchange the refund on every call to nonReentrant will be lower in
604     // amount. Since refunds are capped to a percentage of the total
605     // transaction's gas, it is best to keep them low in cases like this one, to
606     // increase the likelihood of the full refund coming into effect.
607     uint256 private constant _NOT_ENTERED = 1;
608     uint256 private constant _ENTERED = 2;
609 
610     uint256 private _status;
611 
612     constructor () internal {
613         _status = _NOT_ENTERED;
614     }
615 
616     /**
617      * @dev Prevents a contract from calling itself, directly or indirectly.
618      * Calling a `nonReentrant` function from another `nonReentrant`
619      * function is not supported. It is possible to prevent this from happening
620      * by making the `nonReentrant` function external, and make it call a
621      * `private` function that does the actual work.
622      */
623     modifier nonReentrant() {
624         // On the first call to nonReentrant, _notEntered will be true
625         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
626 
627         // Any calls to nonReentrant after this point will fail
628         _status = _ENTERED;
629 
630         _;
631 
632         // By storing the original value once again, a refund is triggered (see
633         // https://eips.ethereum.org/EIPS/eip-2200)
634         _status = _NOT_ENTERED;
635     }
636 }
637 
638 // File: @openzeppelin\contracts\utils\Pausable.sol
639 
640 
641 pragma solidity >=0.6.0 <0.8.0;
642 
643 
644 /**
645  * @dev Contract module which allows children to implement an emergency stop
646  * mechanism that can be triggered by an authorized account.
647  *
648  * This module is used through inheritance. It will make available the
649  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
650  * the functions of your contract. Note that they will not be pausable by
651  * simply including this module, only once the modifiers are put in place.
652  */
653 abstract contract Pausable is Context {
654     /**
655      * @dev Emitted when the pause is triggered by `account`.
656      */
657     event Paused(address account);
658 
659     /**
660      * @dev Emitted when the pause is lifted by `account`.
661      */
662     event Unpaused(address account);
663 
664     bool private _paused;
665 
666     /**
667      * @dev Initializes the contract in unpaused state.
668      */
669     constructor () internal {
670         _paused = false;
671     }
672 
673     /**
674      * @dev Returns true if the contract is paused, and false otherwise.
675      */
676     function paused() public view returns (bool) {
677         return _paused;
678     }
679 
680     /**
681      * @dev Modifier to make a function callable only when the contract is not paused.
682      *
683      * Requirements:
684      *
685      * - The contract must not be paused.
686      */
687     modifier whenNotPaused() {
688         require(!_paused, "Pausable: paused");
689         _;
690     }
691 
692     /**
693      * @dev Modifier to make a function callable only when the contract is paused.
694      *
695      * Requirements:
696      *
697      * - The contract must be paused.
698      */
699     modifier whenPaused() {
700         require(_paused, "Pausable: not paused");
701         _;
702     }
703 
704     /**
705      * @dev Triggers stopped state.
706      *
707      * Requirements:
708      *
709      * - The contract must not be paused.
710      */
711     function _pause() internal virtual whenNotPaused {
712         _paused = true;
713         emit Paused(_msgSender());
714     }
715 
716     /**
717      * @dev Returns to normal state.
718      *
719      * Requirements:
720      *
721      * - The contract must be paused.
722      */
723     function _unpause() internal virtual whenPaused {
724         _paused = false;
725         emit Unpaused(_msgSender());
726     }
727 }
728 
729 // File: contracts\interfaces\ILockProxy.sol
730 
731 pragma solidity >=0.6.0;
732 
733 interface ILockProxy {
734     function managerProxyContract() external view returns (address);
735     function proxyHashMap(uint64) external view returns (bytes memory);
736     function assetHashMap(address, uint64) external view returns (bytes memory);
737     function getBalanceFor(address) external view returns (uint256);
738     function setManagerProxy(
739         address eccmpAddr
740     ) external;
741     
742     function bindProxyHash(
743         uint64 toChainId, 
744         bytes calldata targetProxyHash
745     ) external returns (bool);
746 
747     function bindAssetHash(
748         address fromAssetHash, 
749         uint64 toChainId, 
750         bytes calldata toAssetHash
751     ) external returns (bool);
752 
753     function lock(
754         address fromAssetHash, 
755         uint64 toChainId, 
756         bytes calldata toAddress, 
757         uint256 amount
758     ) external payable returns (bool);
759 }
760 
761 // File: contracts\PolyWrapper.sol
762 
763 pragma solidity >=0.6.0;
764 
765 
766 
767 
768 
769 
770 
771 
772 contract PolyWrapper is Ownable, Pausable, ReentrancyGuard {
773     using SafeMath for uint;
774     using SafeERC20 for IERC20;
775 
776     uint public chainId;
777     address public feeCollector;
778 
779     ILockProxy public lockProxy;
780 
781     constructor(address _owner, uint _chainId) public {
782         require(_chainId != 0, "!legal");
783         transferOwnership(_owner);
784         chainId = _chainId;
785     }
786 
787     function setFeeCollector(address collector) external onlyOwner {
788         require(collector != address(0), "emtpy address");
789         feeCollector = collector;
790     }
791 
792 
793     function setLockProxy(address _lockProxy) external onlyOwner {
794         require(_lockProxy != address(0));
795         lockProxy = ILockProxy(_lockProxy);
796         require(lockProxy.managerProxyContract() != address(0), "not lockproxy");
797     }
798 
799     function pause() external onlyOwner {
800         _pause();
801     }
802 
803     function unpause() external onlyOwner {
804         _unpause();
805     }
806 
807 
808     function extractFee(address token) external {
809         require(msg.sender == feeCollector, "!feeCollector");
810         if (token == address(0)) {
811             payable(msg.sender).transfer(address(this).balance);
812         } else {
813             IERC20(token).safeTransfer(feeCollector, IERC20(token).balanceOf(address(this)));
814         }
815     }
816     
817     function lock(address fromAsset, uint64 toChainId, bytes memory toAddress, uint amount, uint fee, uint id) external payable nonReentrant whenNotPaused {
818         
819         require(toChainId != chainId && toChainId != 0, "!toChainId");
820         require(amount > fee, "amount less than fee");
821         
822         _pull(fromAsset, amount);
823 
824         _push(fromAsset, toChainId, toAddress, amount.sub(fee));
825 
826         emit PolyWrapperLock(fromAsset, msg.sender, toChainId, toAddress, amount.sub(fee), fee, id);
827     }
828 
829     function speedUp(address fromAsset, bytes memory txHash, uint fee) external payable nonReentrant whenNotPaused {
830         _pull(fromAsset, fee);
831         emit PolyWrapperSpeedUp(fromAsset, txHash, msg.sender, fee);
832     }
833 
834     function _pull(address fromAsset, uint amount) internal {
835         if (fromAsset == address(0)) {
836             require(msg.value == amount, "insufficient ether");
837         } else {
838             IERC20(fromAsset).safeTransferFrom(msg.sender, address(this), amount);
839         }
840     }
841 
842     function _push(address fromAsset, uint64 toChainId, bytes memory toAddress, uint amount) internal {
843         if (fromAsset == address(0)) {
844             require(lockProxy.lock{value: amount}(fromAsset, toChainId, toAddress, amount), "lock ether fail");
845         } else {
846             IERC20(fromAsset).safeApprove(address(lockProxy), 0);
847             IERC20(fromAsset).safeApprove(address(lockProxy), amount);
848             require(lockProxy.lock(fromAsset, toChainId, toAddress, amount), "lock erc20 fail");
849         }
850     }
851 
852     event PolyWrapperLock(address indexed fromAsset, address indexed sender, uint64 toChainId, bytes toAddress, uint net, uint fee, uint id);
853     event PolyWrapperSpeedUp(address indexed fromAsset, bytes indexed txHash, address indexed sender, uint efee);
854 
855 }