1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
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
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 
162 /**
163  * @dev Collection of functions related to the address type
164  */
165 library Address {
166     /**
167      * @dev Returns true if `account` is a contract.
168      *
169      * [IMPORTANT]
170      * ====
171      * It is unsafe to assume that an address for which this function returns
172      * false is an externally-owned account (EOA) and not a contract.
173      *
174      * Among others, `isContract` will return false for the following
175      * types of addresses:
176      *
177      *  - an externally-owned account
178      *  - a contract in construction
179      *  - an address where a contract will be created
180      *  - an address where a contract lived, but was destroyed
181      * ====
182      */
183     function isContract(address account) internal view returns (bool) {
184         // This method relies on extcodesize, which returns 0 for contracts in
185         // construction, since the code is only stored at the end of the
186         // constructor execution.
187 
188         uint256 size;
189         // solhint-disable-next-line no-inline-assembly
190         assembly { size := extcodesize(account) }
191         return size > 0;
192     }
193 
194     /**
195      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
196      * `recipient`, forwarding all available gas and reverting on errors.
197      *
198      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
199      * of certain opcodes, possibly making contracts go over the 2300 gas limit
200      * imposed by `transfer`, making them unable to receive funds via
201      * `transfer`. {sendValue} removes this limitation.
202      *
203      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
204      *
205      * IMPORTANT: because control is transferred to `recipient`, care must be
206      * taken to not create reentrancy vulnerabilities. Consider using
207      * {ReentrancyGuard} or the
208      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
209      */
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
214         (bool success, ) = recipient.call{ value: amount }("");
215         require(success, "Address: unable to send value, recipient may have reverted");
216     }
217 
218     /**
219      * @dev Performs a Solidity function call using a low level `call`. A
220      * plain`call` is an unsafe replacement for a function call: use this
221      * function instead.
222      *
223      * If `target` reverts with a revert reason, it is bubbled up by this
224      * function (like regular Solidity function calls).
225      *
226      * Returns the raw returned data. To convert to the expected return value,
227      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
228      *
229      * Requirements:
230      *
231      * - `target` must be a contract.
232      * - calling `target` with `data` must not revert.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
237       return functionCall(target, data, "Address: low-level call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
242      * `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
247         return functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but also transferring `value` wei to `target`.
253      *
254      * Requirements:
255      *
256      * - the calling contract must have an ETH balance of at least `value`.
257      * - the called Solidity function must be `payable`.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
267      * with `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
272         require(address(this).balance >= value, "Address: insufficient balance for call");
273         require(isContract(target), "Address: call to non-contract");
274 
275         // solhint-disable-next-line avoid-low-level-calls
276         (bool success, bytes memory returndata) = target.call{ value: value }(data);
277         return _verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but performing a static call.
283      *
284      * _Available since v3.3._
285      */
286     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
287         return functionStaticCall(target, data, "Address: low-level static call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292      * but performing a static call.
293      *
294      * _Available since v3.3._
295      */
296     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
297         require(isContract(target), "Address: static call to non-contract");
298 
299         // solhint-disable-next-line avoid-low-level-calls
300         (bool success, bytes memory returndata) = target.staticcall(data);
301         return _verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but performing a delegate call.
307      *
308      * _Available since v3.3._
309      */
310     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
316      * but performing a delegate call.
317      *
318      * _Available since v3.3._
319      */
320     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
321         require(isContract(target), "Address: delegate call to non-contract");
322 
323         // solhint-disable-next-line avoid-low-level-calls
324         (bool success, bytes memory returndata) = target.delegatecall(data);
325         return _verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
329         if (success) {
330             return returndata;
331         } else {
332             // Look for revert reason and bubble it up if present
333             if (returndata.length > 0) {
334                 // The easiest way to bubble the revert reason is using memory via assembly
335 
336                 // solhint-disable-next-line no-inline-assembly
337                 assembly {
338                     let returndata_size := mload(returndata)
339                     revert(add(32, returndata), returndata_size)
340                 }
341             } else {
342                 revert(errorMessage);
343             }
344         }
345     }
346 }
347 
348 
349 /*
350  * @dev Provides information about the current execution context, including the
351  * sender of the transaction and its data. While these are generally available
352  * via msg.sender and msg.data, they should not be accessed in such a direct
353  * manner, since when dealing with GSN meta-transactions the account sending and
354  * paying for execution may not be the actual sender (as far as an application
355  * is concerned).
356  *
357  * This contract is only required for intermediate, library-like contracts.
358  */
359 abstract contract Context {
360     function _msgSender() internal view virtual returns (address payable) {
361         return msg.sender;
362     }
363 
364     function _msgData() internal view virtual returns (bytes memory) {
365         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
366         return msg.data;
367     }
368 }
369 
370 
371 /**
372  * @dev Contract module which provides a basic access control mechanism, where
373  * there is an account (an owner) that can be granted exclusive access to
374  * specific functions.
375  *
376  * By default, the owner account will be the one that deploys the contract. This
377  * can later be changed with {transferOwnership}.
378  *
379  * This module is used through inheritance. It will make available the modifier
380  * `onlyOwner`, which can be applied to your functions to restrict their use to
381  * the owner.
382  */
383 contract Ownable is Context {
384     address private _owner;
385 
386     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
387 
388     /**
389      * @dev Initializes the contract setting the deployer as the initial owner.
390      */
391     constructor () internal {
392         address msgSender = _msgSender();
393         _owner = msgSender;
394         emit OwnershipTransferred(address(0), msgSender);
395     }
396 
397     /**
398      * @dev Returns the address of the current owner.
399      */
400     function owner() public view returns (address) {
401         return _owner;
402     }
403 
404     /**
405      * @dev Throws if called by any account other than the owner.
406      */
407     modifier onlyOwner() {
408         require(_owner == _msgSender(), "Ownable: caller is not the owner");
409         _;
410     }
411 
412     /**
413      * @dev Leaves the contract without owner. It will not be possible to call
414      * `onlyOwner` functions anymore. Can only be called by the current owner.
415      *
416      * NOTE: Renouncing ownership will leave the contract without an owner,
417      * thereby removing any functionality that is only available to the owner.
418      */
419     function renounceOwnership() public virtual onlyOwner {
420         emit OwnershipTransferred(_owner, address(0));
421         _owner = address(0);
422     }
423 
424     /**
425      * @dev Transfers ownership of the contract to a new account (`newOwner`).
426      * Can only be called by the current owner.
427      */
428     function transferOwnership(address newOwner) public virtual onlyOwner {
429         require(newOwner != address(0), "Ownable: new owner is the zero address");
430         emit OwnershipTransferred(_owner, newOwner);
431         _owner = newOwner;
432     }
433 }
434 
435 
436 
437 /**
438  * @dev Contract module that helps prevent reentrant calls to a function.
439  *
440  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
441  * available, which can be applied to functions to make sure there are no nested
442  * (reentrant) calls to them.
443  *
444  * Note that because there is a single `nonReentrant` guard, functions marked as
445  * `nonReentrant` may not call one another. This can be worked around by making
446  * those functions `private`, and then adding `external` `nonReentrant` entry
447  * points to them.
448  *
449  * TIP: If you would like to learn more about reentrancy and alternative ways
450  * to protect against it, check out our blog post
451  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
452  */
453 contract ReentrancyGuard {
454     // Booleans are more expensive than uint256 or any type that takes up a full
455     // word because each write operation emits an extra SLOAD to first read the
456     // slot's contents, replace the bits taken up by the boolean, and then write
457     // back. This is the compiler's defense against contract upgrades and
458     // pointer aliasing, and it cannot be disabled.
459 
460     // The values being non-zero value makes deployment a bit more expensive,
461     // but in exchange the refund on every call to nonReentrant will be lower in
462     // amount. Since refunds are capped to a percentage of the total
463     // transaction's gas, it is best to keep them low in cases like this one, to
464     // increase the likelihood of the full refund coming into effect.
465     uint256 private constant _NOT_ENTERED = 1;
466     uint256 private constant _ENTERED = 2;
467 
468     uint256 private _status;
469 
470     constructor () internal {
471         _status = _NOT_ENTERED;
472     }
473 
474     /**
475      * @dev Prevents a contract from calling itself, directly or indirectly.
476      * Calling a `nonReentrant` function from another `nonReentrant`
477      * function is not supported. It is possible to prevent this from happening
478      * by making the `nonReentrant` function external, and make it call a
479      * `private` function that does the actual work.
480      */
481     modifier nonReentrant() {
482         // On the first call to nonReentrant, _notEntered will be true
483         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
484 
485         // Any calls to nonReentrant after this point will fail
486         _status = _ENTERED;
487 
488         _;
489 
490         // By storing the original value once again, a refund is triggered (see
491         // https://eips.ethereum.org/EIPS/eip-2200)
492         _status = _NOT_ENTERED;
493     }
494 }
495 
496 /**
497  * @dev Contract module which allows children to implement an emergency stop
498  * mechanism that can be triggered by an authorized account.
499  *
500  * This module is used through inheritance. It will make available the
501  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
502  * the functions of your contract. Note that they will not be pausable by
503  * simply including this module, only once the modifiers are put in place.
504  */
505 contract Pausable is Context {
506     /**
507      * @dev Emitted when the pause is triggered by `account`.
508      */
509     event Paused(address account);
510 
511     /**
512      * @dev Emitted when the pause is lifted by `account`.
513      */
514     event Unpaused(address account);
515 
516     bool private _paused;
517 
518     /**
519      * @dev Initializes the contract in unpaused state.
520      */
521     constructor () internal {
522         _paused = false;
523     }
524 
525     /**
526      * @dev Returns true if the contract is paused, and false otherwise.
527      */
528     function paused() public view returns (bool) {
529         return _paused;
530     }
531 
532     /**
533      * @dev Modifier to make a function callable only when the contract is not paused.
534      *
535      * Requirements:
536      *
537      * - The contract must not be paused.
538      */
539     modifier whenNotPaused() {
540         require(!_paused, "Pausable: paused");
541         _;
542     }
543 
544     /**
545      * @dev Modifier to make a function callable only when the contract is paused.
546      *
547      * Requirements:
548      *
549      * - The contract must be paused.
550      */
551     modifier whenPaused() {
552         require(_paused, "Pausable: not paused");
553         _;
554     }
555 
556     /**
557      * @dev Triggers stopped state.
558      *
559      * Requirements:
560      *
561      * - The contract must not be paused.
562      */
563     function _pause() internal virtual whenNotPaused {
564         _paused = true;
565         emit Paused(_msgSender());
566     }
567 
568     /**
569      * @dev Returns to normal state.
570      *
571      * Requirements:
572      *
573      * - The contract must be paused.
574      */
575     function _unpause() internal virtual whenPaused {
576         _paused = false;
577         emit Unpaused(_msgSender());
578     }
579 }
580 
581 /**
582  * @dev Interface of the ERC20 standard as defined in the EIP.
583  */
584 interface IERC20 {
585     /**
586      * @dev Returns the amount of tokens in existence.
587      */
588     function totalSupply() external view returns (uint256);
589 
590     /**
591      * @dev Returns the amount of tokens owned by `account`.
592      */
593     function balanceOf(address account) external view returns (uint256);
594 
595     /**
596      * @dev Moves `amount` tokens from the caller's account to `recipient`.
597      *
598      * Returns a boolean value indicating whether the operation succeeded.
599      *
600      * Emits a {Transfer} event.
601      */
602     function transfer(address recipient, uint256 amount) external returns (bool);
603 
604     /**
605      * @dev Returns the remaining number of tokens that `spender` will be
606      * allowed to spend on behalf of `owner` through {transferFrom}. This is
607      * zero by default.
608      *
609      * This value changes when {approve} or {transferFrom} are called.
610      */
611     function allowance(address owner, address spender) external view returns (uint256);
612 
613     /**
614      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
615      *
616      * Returns a boolean value indicating whether the operation succeeded.
617      *
618      * IMPORTANT: Beware that changing an allowance with this method brings the risk
619      * that someone may use both the old and the new allowance by unfortunate
620      * transaction ordering. One possible solution to mitigate this race
621      * condition is to first reduce the spender's allowance to 0 and set the
622      * desired value afterwards:
623      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
624      *
625      * Emits an {Approval} event.
626      */
627     function approve(address spender, uint256 amount) external returns (bool);
628 
629     /**
630      * @dev Moves `amount` tokens from `sender` to `recipient` using the
631      * allowance mechanism. `amount` is then deducted from the caller's
632      * allowance.
633      *
634      * Returns a boolean value indicating whether the operation succeeded.
635      *
636      * Emits a {Transfer} event.
637      */
638     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
639 
640     /**
641      * @dev Emitted when `value` tokens are moved from one account (`from`) to
642      * another (`to`).
643      *
644      * Note that `value` may be zero.
645      */
646     event Transfer(address indexed from, address indexed to, uint256 value);
647 
648     /**
649      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
650      * a call to {approve}. `value` is the new allowance.
651      */
652     event Approval(address indexed owner, address indexed spender, uint256 value);
653 }
654 
655 
656 /**
657  * @title SafeERC20
658  * @dev Wrappers around ERC20 operations that throw on failure (when the token
659  * contract returns false). Tokens that return no value (and instead revert or
660  * throw on failure) are also supported, non-reverting calls are assumed to be
661  * successful.
662  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
663  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
664  */
665 library SafeERC20 {
666     using SafeMath for uint256;
667     using Address for address;
668 
669     function safeTransfer(IERC20 token, address to, uint256 value) internal {
670         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
671     }
672 
673     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
674         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
675     }
676 
677     /**
678      * @dev Deprecated. This function has issues similar to the ones found in
679      * {IERC20-approve}, and its usage is discouraged.
680      *
681      * Whenever possible, use {safeIncreaseAllowance} and
682      * {safeDecreaseAllowance} instead.
683      */
684     function safeApprove(IERC20 token, address spender, uint256 value) internal {
685         // safeApprove should only be called when setting an initial allowance,
686         // or when resetting it to zero. To increase and decrease it, use
687         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
688         // solhint-disable-next-line max-line-length
689         require((value == 0) || (token.allowance(address(this), spender) == 0),
690             "SafeERC20: approve from non-zero to non-zero allowance"
691         );
692         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
693     }
694 
695     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
696         uint256 newAllowance = token.allowance(address(this), spender).add(value);
697         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
698     }
699 
700     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
701         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
702         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
703     }
704 
705     /**
706      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
707      * on the return value: the return value is optional (but if data is returned, it must not be false).
708      * @param token The token targeted by the call.
709      * @param data The call data (encoded using abi.encode or one of its variants).
710      */
711     function _callOptionalReturn(IERC20 token, bytes memory data) private {
712         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
713         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
714         // the target address contains contract code and also asserts for success in the low-level call.
715 
716         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
717         if (returndata.length > 0) { // Return data is optional
718             // solhint-disable-next-line max-line-length
719             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
720         }
721     }
722 }
723 
724 pragma solidity ^0.6.0;
725 
726 /// @title Kool Bar Contract
727 
728 interface IERC1155 {
729     function balanceOf(address account, uint256 id) external view returns (uint256);
730 }
731 
732 interface IKOOLNFT {
733     function mint(address to, uint256 id, uint256 amount) external;
734     function burn(address account, uint256 id, uint256 amount) external;
735 }
736 
737 contract KoolBar is ReentrancyGuard, Pausable, Ownable {
738     using SafeMath for uint256;
739     using SafeERC20 for IERC20;
740 
741     IERC20 public AID;
742     IERC20 public KOOL;
743     address public NFT;
744 
745     uint256 private _totalSupply;
746 
747     mapping(address => mapping(uint256 => uint256)) public claimed;
748     mapping(uint256 => uint256) public prices;
749 
750     event CardPaid(address indexed user, uint256 amount, uint256 tokenId);
751     event Withdrawn(address indexed user, uint256 amount);
752     event Recovered(address token, uint256 amount);
753 
754     constructor(address _AID, address _KOOL, address _NFT) public {
755         AID = IERC20(_AID);
756         KOOL = IERC20(_KOOL);
757         NFT = _NFT;
758     }
759 
760     function pause() external onlyOwner whenNotPaused {
761         _pause();
762         emit Paused(msg.sender);
763     }
764 
765     function unpause() external onlyOwner whenPaused {
766         _unpause();
767         emit Unpaused(msg.sender);
768     }
769     
770     function updateNFT(address _NFT) external onlyOwner {
771         NFT = _NFT;
772     }
773 
774     function initiateSalePrices(uint256[] memory ids, uint256[] memory values) external onlyOwner {
775         require(ids.length == values.length);
776         uint256 length = ids.length;
777         uint i;
778         for (i=0; i < length; i++) {
779             prices[ids[i]] = values[i];
780         }
781     }
782 
783     function getDrink(uint256 tokenId, uint256 amount) external payable nonReentrant whenNotPaused {
784         // Zero Flavour
785         if (tokenId == 1) {
786             require(claimed[msg.sender][tokenId].add(amount) <= 1, "1 NFT per wallet");
787             claimed[msg.sender][tokenId] = claimed[msg.sender][tokenId].add(amount);
788             IKOOLNFT(NFT).mint(msg.sender, tokenId, amount);
789         }
790 
791         // Sergey Non-drinker
792         else if (tokenId == 2) {
793             uint256 value = prices[tokenId];
794             require(msg.value >= value.mul(amount), "wrong value");
795             require(claimed[msg.sender][tokenId].add(amount) <= 10, "10 NFT per wallet");
796             payable(this.owner()).transfer(msg.value);
797             claimed[msg.sender][tokenId] = claimed[msg.sender][tokenId].add(amount);
798             IKOOLNFT(NFT).mint(msg.sender, tokenId, amount);
799         }
800 
801         // Common Flavors 3-6
802         else if (tokenId >= 3 && tokenId <=6) {
803             uint256 value = prices[tokenId];
804             require(AID.balanceOf(msg.sender) >= value.mul(amount), "wrong value");
805             require(claimed[msg.sender][tokenId].add(amount) <= 15, "15 NFT per wallet");
806             AID.safeTransferFrom(msg.sender, 0x1111111111111111111111111111111111111111, value.mul(amount));
807             claimed[msg.sender][tokenId] = claimed[msg.sender][tokenId].add(amount);
808             IKOOLNFT(NFT).mint(msg.sender, tokenId, amount);
809         }
810 
811         // Banana FOMO
812         else if (tokenId == 7) {
813             uint256 value = prices[tokenId];
814             require(AID.balanceOf(msg.sender) >= value.mul(amount), "wrong value");
815             require(claimed[msg.sender][tokenId].add(amount) <= 10, "10 NFT per wallet");
816             AID.safeTransferFrom(msg.sender, 0x1111111111111111111111111111111111111111, value.mul(amount));
817             claimed[msg.sender][tokenId] = claimed[msg.sender][tokenId].add(amount);
818             IKOOLNFT(NFT).mint(msg.sender, tokenId, amount);
819         }
820 
821         // Rugberry
822         else if (tokenId == 8) {
823             IKOOLNFT(NFT).burn(msg.sender, 4, 1); // Red Cherry Dump
824             IKOOLNFT(NFT).burn(msg.sender, 6, 3); // Grapes of ETH
825             IKOOLNFT(NFT).mint(msg.sender, tokenId, 1);
826         }
827 
828         // Moonshine Punch
829         else if (tokenId == 9) {
830             IKOOLNFT(NFT).burn(msg.sender, 7, 1); // Banana FOMO
831             IKOOLNFT(NFT).burn(msg.sender, 3, 1); // Green Apple Pump
832             IKOOLNFT(NFT).burn(msg.sender, 5, 2); // Bitcoin Orange
833             IKOOLNFT(NFT).mint(msg.sender, tokenId, 1);
834         }
835 
836         // Vitalik Butter
837         else if (tokenId == 10) {
838             IKOOLNFT(NFT).burn(msg.sender, 3, 2); // Green Apple Pump
839             IKOOLNFT(NFT).burn(msg.sender, 4, 2); // Red Cherry Dump
840             IKOOLNFT(NFT).mint(msg.sender, tokenId, 1);
841         }
842 
843         // Doge Food
844         else if (tokenId == 11) {
845             IKOOLNFT(NFT).burn(msg.sender, 9, 1); // Moonshine
846             IKOOLNFT(NFT).burn(msg.sender, 7, 1); // Banana FOMO
847             IKOOLNFT(NFT).burn(msg.sender, 5, 1); // Bitcoin Orange
848             IKOOLNFT(NFT).burn(msg.sender, 3, 1); // Green Apple Pump
849             IKOOLNFT(NFT).mint(msg.sender, tokenId, 1);
850         }
851 
852         // Rekt Dragonfruit
853         else if (tokenId == 12) {
854             IKOOLNFT(NFT).burn(msg.sender, 6, 1); // Grapes of ETH
855             IKOOLNFT(NFT).burn(msg.sender, 10, 1); // Vitalik Butter
856             IKOOLNFT(NFT).burn(msg.sender, 8, 1); // Rugberry
857             IKOOLNFT(NFT).mint(msg.sender, tokenId, 1);
858         }
859 
860         // Chad Lemonade
861         else if (tokenId == 13) {
862             require(IERC1155(0xd07dc4262BCDbf85190C01c996b4C06a461d2430).balanceOf(msg.sender, 22280) >= 1); // KOOL Сhad
863             IKOOLNFT(NFT).burn(msg.sender, 11, 1); // Doge food
864             IKOOLNFT(NFT).burn(msg.sender, 12, 1); // Rekt DragonFruit
865             IKOOLNFT(NFT).mint(msg.sender, tokenId, 1);
866         }
867 
868         // Inflatable Kool-Aid Man
869         else if (tokenId == 14 || tokenId == 20) {
870             uint256 value = prices[tokenId];
871             require(msg.value >= value.mul(amount), "wrong value");
872             payable(this.owner()).transfer(msg.value);
873             IKOOLNFT(NFT).mint(msg.sender, tokenId, amount);
874         }
875 
876         // Kool Tote Bag
877         else if (tokenId == 15) {
878             uint256 value = prices[tokenId];
879             require(KOOL.balanceOf(msg.sender) >= value.mul(amount), "wrong value");
880             KOOL.safeTransferFrom(msg.sender, 0x1111111111111111111111111111111111111111, value.mul(amount));
881             IKOOLNFT(NFT).mint(msg.sender, tokenId, amount);
882         }
883 
884         // Kool Key Chain, Kool Stamp Collecting Kit
885         else if (tokenId == 16 || tokenId == 17 || tokenId == 18 || tokenId == 19 || tokenId == 21) {
886             uint256 value = prices[tokenId];
887             require(AID.balanceOf(msg.sender) >= value.mul(amount), "wrong value");
888             AID.safeTransferFrom(msg.sender, 0x1111111111111111111111111111111111111111, value.mul(amount));
889             IKOOLNFT(NFT).mint(msg.sender, tokenId, amount);
890         } else {
891             revert();
892         }
893         emit CardPaid(msg.sender, amount, tokenId);
894     }
895 
896     function withdrawERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
897         IERC20(tokenAddress).transfer(this.owner(), tokenAmount);
898         emit Recovered(tokenAddress, tokenAmount);
899     }
900 }