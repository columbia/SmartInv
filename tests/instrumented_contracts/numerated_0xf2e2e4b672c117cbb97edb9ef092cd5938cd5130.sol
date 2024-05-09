1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-02
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      *
31      * - Addition cannot overflow.
32      */
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      *
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      *
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      *
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts with custom message when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b != 0, errorMessage);
161         return a % b;
162     }
163 }
164 
165 
166 /**
167  * @dev Collection of functions related to the address type
168  */
169 library Address {
170     /**
171      * @dev Returns true if `account` is a contract.
172      *
173      * [IMPORTANT]
174      * ====
175      * It is unsafe to assume that an address for which this function returns
176      * false is an externally-owned account (EOA) and not a contract.
177      *
178      * Among others, `isContract` will return false for the following
179      * types of addresses:
180      *
181      *  - an externally-owned account
182      *  - a contract in construction
183      *  - an address where a contract will be created
184      *  - an address where a contract lived, but was destroyed
185      * ====
186      */
187     function isContract(address account) internal view returns (bool) {
188         // This method relies on extcodesize, which returns 0 for contracts in
189         // construction, since the code is only stored at the end of the
190         // constructor execution.
191 
192         uint256 size;
193         // solhint-disable-next-line no-inline-assembly
194         assembly { size := extcodesize(account) }
195         return size > 0;
196     }
197 
198     /**
199      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
200      * `recipient`, forwarding all available gas and reverting on errors.
201      *
202      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
203      * of certain opcodes, possibly making contracts go over the 2300 gas limit
204      * imposed by `transfer`, making them unable to receive funds via
205      * `transfer`. {sendValue} removes this limitation.
206      *
207      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
208      *
209      * IMPORTANT: because control is transferred to `recipient`, care must be
210      * taken to not create reentrancy vulnerabilities. Consider using
211      * {ReentrancyGuard} or the
212      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
213      */
214     function sendValue(address payable recipient, uint256 amount) internal {
215         require(address(this).balance >= amount, "Address: insufficient balance");
216 
217         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
218         (bool success, ) = recipient.call{ value: amount }("");
219         require(success, "Address: unable to send value, recipient may have reverted");
220     }
221 
222     /**
223      * @dev Performs a Solidity function call using a low level `call`. A
224      * plain`call` is an unsafe replacement for a function call: use this
225      * function instead.
226      *
227      * If `target` reverts with a revert reason, it is bubbled up by this
228      * function (like regular Solidity function calls).
229      *
230      * Returns the raw returned data. To convert to the expected return value,
231      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
232      *
233      * Requirements:
234      *
235      * - `target` must be a contract.
236      * - calling `target` with `data` must not revert.
237      *
238      * _Available since v3.1._
239      */
240     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
241       return functionCall(target, data, "Address: low-level call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
246      * `errorMessage` as a fallback revert reason when `target` reverts.
247      *
248      * _Available since v3.1._
249      */
250     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, 0, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but also transferring `value` wei to `target`.
257      *
258      * Requirements:
259      *
260      * - the calling contract must have an ETH balance of at least `value`.
261      * - the called Solidity function must be `payable`.
262      *
263      * _Available since v3.1._
264      */
265     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
266         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
271      * with `errorMessage` as a fallback revert reason when `target` reverts.
272      *
273      * _Available since v3.1._
274      */
275     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
276         require(address(this).balance >= value, "Address: insufficient balance for call");
277         require(isContract(target), "Address: call to non-contract");
278 
279         // solhint-disable-next-line avoid-low-level-calls
280         (bool success, bytes memory returndata) = target.call{ value: value }(data);
281         return _verifyCallResult(success, returndata, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but performing a static call.
287      *
288      * _Available since v3.3._
289      */
290     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
291         return functionStaticCall(target, data, "Address: low-level static call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
296      * but performing a static call.
297      *
298      * _Available since v3.3._
299      */
300     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
301         require(isContract(target), "Address: static call to non-contract");
302 
303         // solhint-disable-next-line avoid-low-level-calls
304         (bool success, bytes memory returndata) = target.staticcall(data);
305         return _verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but performing a delegate call.
311      *
312      * _Available since v3.3._
313      */
314     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
320      * but performing a delegate call.
321      *
322      * _Available since v3.3._
323      */
324     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
325         require(isContract(target), "Address: delegate call to non-contract");
326 
327         // solhint-disable-next-line avoid-low-level-calls
328         (bool success, bytes memory returndata) = target.delegatecall(data);
329         return _verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
333         if (success) {
334             return returndata;
335         } else {
336             // Look for revert reason and bubble it up if present
337             if (returndata.length > 0) {
338                 // The easiest way to bubble the revert reason is using memory via assembly
339 
340                 // solhint-disable-next-line no-inline-assembly
341                 assembly {
342                     let returndata_size := mload(returndata)
343                     revert(add(32, returndata), returndata_size)
344                 }
345             } else {
346                 revert(errorMessage);
347             }
348         }
349     }
350 }
351 
352 
353 /*
354  * @dev Provides information about the current execution context, including the
355  * sender of the transaction and its data. While these are generally available
356  * via msg.sender and msg.data, they should not be accessed in such a direct
357  * manner, since when dealing with GSN meta-transactions the account sending and
358  * paying for execution may not be the actual sender (as far as an application
359  * is concerned).
360  *
361  * This contract is only required for intermediate, library-like contracts.
362  */
363 abstract contract Context {
364     function _msgSender() internal view virtual returns (address payable) {
365         return msg.sender;
366     }
367 
368     function _msgData() internal view virtual returns (bytes memory) {
369         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
370         return msg.data;
371     }
372 }
373 
374 
375 /**
376  * @dev Contract module which provides a basic access control mechanism, where
377  * there is an account (an owner) that can be granted exclusive access to
378  * specific functions.
379  *
380  * By default, the owner account will be the one that deploys the contract. This
381  * can later be changed with {transferOwnership}.
382  *
383  * This module is used through inheritance. It will make available the modifier
384  * `onlyOwner`, which can be applied to your functions to restrict their use to
385  * the owner.
386  */
387 contract Ownable is Context {
388     address private _owner;
389 
390     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
391 
392     /**
393      * @dev Initializes the contract setting the deployer as the initial owner.
394      */
395     constructor () internal {
396         address msgSender = _msgSender();
397         _owner = msgSender;
398         emit OwnershipTransferred(address(0), msgSender);
399     }
400 
401     /**
402      * @dev Returns the address of the current owner.
403      */
404     function owner() public view returns (address) {
405         return _owner;
406     }
407 
408     /**
409      * @dev Throws if called by any account other than the owner.
410      */
411     modifier onlyOwner() {
412         require(_owner == _msgSender(), "Ownable: caller is not the owner");
413         _;
414     }
415 
416     /**
417      * @dev Leaves the contract without owner. It will not be possible to call
418      * `onlyOwner` functions anymore. Can only be called by the current owner.
419      *
420      * NOTE: Renouncing ownership will leave the contract without an owner,
421      * thereby removing any functionality that is only available to the owner.
422      */
423     function renounceOwnership() public virtual onlyOwner {
424         emit OwnershipTransferred(_owner, address(0));
425         _owner = address(0);
426     }
427 
428     /**
429      * @dev Transfers ownership of the contract to a new account (`newOwner`).
430      * Can only be called by the current owner.
431      */
432     function transferOwnership(address newOwner) public virtual onlyOwner {
433         require(newOwner != address(0), "Ownable: new owner is the zero address");
434         emit OwnershipTransferred(_owner, newOwner);
435         _owner = newOwner;
436     }
437 }
438 
439 
440 
441 /**
442  * @dev Contract module that helps prevent reentrant calls to a function.
443  *
444  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
445  * available, which can be applied to functions to make sure there are no nested
446  * (reentrant) calls to them.
447  *
448  * Note that because there is a single `nonReentrant` guard, functions marked as
449  * `nonReentrant` may not call one another. This can be worked around by making
450  * those functions `private`, and then adding `external` `nonReentrant` entry
451  * points to them.
452  *
453  * TIP: If you would like to learn more about reentrancy and alternative ways
454  * to protect against it, check out our blog post
455  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
456  */
457 contract ReentrancyGuard {
458     // Booleans are more expensive than uint256 or any type that takes up a full
459     // word because each write operation emits an extra SLOAD to first read the
460     // slot's contents, replace the bits taken up by the boolean, and then write
461     // back. This is the compiler's defense against contract upgrades and
462     // pointer aliasing, and it cannot be disabled.
463 
464     // The values being non-zero value makes deployment a bit more expensive,
465     // but in exchange the refund on every call to nonReentrant will be lower in
466     // amount. Since refunds are capped to a percentage of the total
467     // transaction's gas, it is best to keep them low in cases like this one, to
468     // increase the likelihood of the full refund coming into effect.
469     uint256 private constant _NOT_ENTERED = 1;
470     uint256 private constant _ENTERED = 2;
471 
472     uint256 private _status;
473 
474     constructor () internal {
475         _status = _NOT_ENTERED;
476     }
477 
478     /**
479      * @dev Prevents a contract from calling itself, directly or indirectly.
480      * Calling a `nonReentrant` function from another `nonReentrant`
481      * function is not supported. It is possible to prevent this from happening
482      * by making the `nonReentrant` function external, and make it call a
483      * `private` function that does the actual work.
484      */
485     modifier nonReentrant() {
486         // On the first call to nonReentrant, _notEntered will be true
487         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
488 
489         // Any calls to nonReentrant after this point will fail
490         _status = _ENTERED;
491 
492         _;
493 
494         // By storing the original value once again, a refund is triggered (see
495         // https://eips.ethereum.org/EIPS/eip-2200)
496         _status = _NOT_ENTERED;
497     }
498 }
499 
500 /**
501  * @dev Contract module which allows children to implement an emergency stop
502  * mechanism that can be triggered by an authorized account.
503  *
504  * This module is used through inheritance. It will make available the
505  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
506  * the functions of your contract. Note that they will not be pausable by
507  * simply including this module, only once the modifiers are put in place.
508  */
509 contract Pausable is Context {
510     /**
511      * @dev Emitted when the pause is triggered by `account`.
512      */
513     event Paused(address account);
514 
515     /**
516      * @dev Emitted when the pause is lifted by `account`.
517      */
518     event Unpaused(address account);
519 
520     bool private _paused;
521 
522     /**
523      * @dev Initializes the contract in unpaused state.
524      */
525     constructor () internal {
526         _paused = false;
527     }
528 
529     /**
530      * @dev Returns true if the contract is paused, and false otherwise.
531      */
532     function paused() public view returns (bool) {
533         return _paused;
534     }
535 
536     /**
537      * @dev Modifier to make a function callable only when the contract is not paused.
538      *
539      * Requirements:
540      *
541      * - The contract must not be paused.
542      */
543     modifier whenNotPaused() {
544         require(!_paused, "Pausable: paused");
545         _;
546     }
547 
548     /**
549      * @dev Modifier to make a function callable only when the contract is paused.
550      *
551      * Requirements:
552      *
553      * - The contract must be paused.
554      */
555     modifier whenPaused() {
556         require(_paused, "Pausable: not paused");
557         _;
558     }
559 
560     /**
561      * @dev Triggers stopped state.
562      *
563      * Requirements:
564      *
565      * - The contract must not be paused.
566      */
567     function _pause() internal virtual whenNotPaused {
568         _paused = true;
569         emit Paused(_msgSender());
570     }
571 
572     /**
573      * @dev Returns to normal state.
574      *
575      * Requirements:
576      *
577      * - The contract must be paused.
578      */
579     function _unpause() internal virtual whenPaused {
580         _paused = false;
581         emit Unpaused(_msgSender());
582     }
583 }
584 
585 /**
586  * @dev Interface of the ERC20 standard as defined in the EIP.
587  */
588 interface IERC20 {
589     /**
590      * @dev Returns the amount of tokens in existence.
591      */
592     function totalSupply() external view returns (uint256);
593 
594     /**
595      * @dev Returns the amount of tokens owned by `account`.
596      */
597     function balanceOf(address account) external view returns (uint256);
598 
599     /**
600      * @dev Moves `amount` tokens from the caller's account to `recipient`.
601      *
602      * Returns a boolean value indicating whether the operation succeeded.
603      *
604      * Emits a {Transfer} event.
605      */
606     function transfer(address recipient, uint256 amount) external returns (bool);
607 
608     /**
609      * @dev Returns the remaining number of tokens that `spender` will be
610      * allowed to spend on behalf of `owner` through {transferFrom}. This is
611      * zero by default.
612      *
613      * This value changes when {approve} or {transferFrom} are called.
614      */
615     function allowance(address owner, address spender) external view returns (uint256);
616 
617     /**
618      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
619      *
620      * Returns a boolean value indicating whether the operation succeeded.
621      *
622      * IMPORTANT: Beware that changing an allowance with this method brings the risk
623      * that someone may use both the old and the new allowance by unfortunate
624      * transaction ordering. One possible solution to mitigate this race
625      * condition is to first reduce the spender's allowance to 0 and set the
626      * desired value afterwards:
627      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
628      *
629      * Emits an {Approval} event.
630      */
631     function approve(address spender, uint256 amount) external returns (bool);
632 
633     /**
634      * @dev Moves `amount` tokens from `sender` to `recipient` using the
635      * allowance mechanism. `amount` is then deducted from the caller's
636      * allowance.
637      *
638      * Returns a boolean value indicating whether the operation succeeded.
639      *
640      * Emits a {Transfer} event.
641      */
642     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
643 
644     /**
645      * @dev Emitted when `value` tokens are moved from one account (`from`) to
646      * another (`to`).
647      *
648      * Note that `value` may be zero.
649      */
650     event Transfer(address indexed from, address indexed to, uint256 value);
651 
652     /**
653      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
654      * a call to {approve}. `value` is the new allowance.
655      */
656     event Approval(address indexed owner, address indexed spender, uint256 value);
657 }
658 
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
728 pragma solidity ^0.6.0;
729 
730 /// @title HeroStaking Contract
731 
732 interface IERC1155 {
733     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
734 }
735 
736 interface INodeRunnersNFT {
737     function getFighter(uint256 tokenId) external view returns (uint256, uint256, uint256, uint256, uint256, uint256);
738 }
739 
740 contract NFTStaking is ReentrancyGuard, Pausable, Ownable {
741     using SafeMath for uint256;
742     using SafeERC20 for IERC20;
743 
744     /* ========== STATE VARIABLES ========== */
745 
746     IERC20 public NDR;
747     IERC1155 public NFT;
748 
749     uint256 public periodFinish = 0;
750     uint256 public rewardRate = 0;
751     uint256 public rewardsDuration = 182 days;
752     uint256 public lastUpdateTime;
753     uint256 public rewardPerTokenStored;
754     uint256 public _totalStrength;
755     uint256 private _totalSupply;
756 
757     mapping(address => uint256) public userRewardPerTokenPaid;
758     mapping(address => uint256) public strengthWeight;
759     mapping(address => uint256) public rewards;
760     mapping(address => uint256) private _balances;
761     mapping(address => uint256[]) public staked;
762 
763     /* ========== CONSTRUCTOR ========== */
764 
765     constructor(address _NFT, address _NDR) public {
766         NDR = IERC20(_NDR);
767         NFT = IERC1155(_NFT);
768     }
769 
770     /* ========== VIEWS ========== */
771 
772     /**
773      * @dev Total staked cards in total
774      */
775     function totalSupply() external view returns (uint256) {
776         return _totalSupply;
777     }
778 
779     /**
780      * @dev Total staked cards by user
781      */
782     function balanceOf(address account) external view returns (uint256) {
783         return _balances[account];
784     }
785 
786     function lastTimeRewardApplicable() public view returns (uint256) {
787         return min(block.timestamp, periodFinish);
788     }
789 
790     function rewardPerToken() public view returns (uint256) {
791         if (_totalStrength == 0) {
792             return rewardPerTokenStored;
793         }
794         return
795             rewardPerTokenStored.add(
796                 lastTimeRewardApplicable()
797                     .sub(lastUpdateTime)
798                     .mul(rewardRate)
799                     .mul(1e18)
800                     .div(_totalStrength)
801             );
802     }
803 
804     /**
805      * @dev Get claimable NDR amount
806      */
807     function earned(address account) public view returns (uint256) {
808         return
809             strengthWeight[account]
810                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
811                 .div(1e18)
812                 .add(rewards[account]);
813     }
814 
815     function getRewardForDuration() external view returns (uint256) {
816         return rewardRate.mul(rewardsDuration);
817     }
818 
819     function min(uint256 a, uint256 b) public pure returns (uint256) {
820         return a < b ? a : b;
821     }
822 
823     /* ========== MUTATIVE FUNCTIONS ========== */
824 
825     /**
826      * @dev Change contract addresses of ERC-20, ERC-1155 tokens
827      */
828     function changeAddresses(address _NDR, address _NFT) public onlyOwner {
829         NDR = IERC20(_NDR);
830         NFT = IERC1155(_NFT);
831     }
832 
833     /**
834      * @dev Return all ctaked cards
835      */
836     function stakedOf(address who) external view returns (uint256[] memory) {
837         return staked[who];
838     }
839 
840     /**
841      * @dev Stake ERC-1155
842      */
843     function stake(uint256 tokenId) external nonReentrant whenNotPaused updateReward(msg.sender) {
844         (,,,,,uint256 series) = INodeRunnersNFT(address(NFT)).getFighter(tokenId);
845         require(series == 1 || series == 2, "wrong id");
846         require(_balances[msg.sender].add(1) <= 4, "4 NFT max");
847         (uint256 strength,,,,,) = INodeRunnersNFT(address(NFT)).getFighter(tokenId);
848         strengthWeight[msg.sender] = strengthWeight[msg.sender].add(strength);
849         _totalStrength = _totalStrength.add(strength);
850         _totalSupply++;
851         _balances[msg.sender] = _balances[msg.sender].add(1);
852         staked[msg.sender].push(tokenId);
853         NFT.safeTransferFrom(msg.sender, address(this), tokenId, 1, "0x0");
854         emit Staked(msg.sender, tokenId);
855     }
856 
857     /**
858      * @dev Used by `withdrawNFT` function
859      */
860     function withdrawSingle(uint256 tokenId) internal {
861         uint256[] memory token = staked[msg.sender];
862         for (uint8 index = 0; index < token.length; index++) {
863             if (token[index] == tokenId) {
864                 staked[msg.sender][index] = staked[msg.sender][token.length - 1];
865                 staked[msg.sender].pop();
866                 return;
867             }
868         }
869     }
870 
871     /**
872      * @dev Withdraw ERC-1155
873      */
874     function withdrawNFT(uint256 tokenId) public updateReward(msg.sender) {
875         (uint256 strength,,,,,) = INodeRunnersNFT(address(NFT)).getFighter(tokenId);
876         strengthWeight[msg.sender] = strengthWeight[msg.sender].sub(strength);
877         _totalStrength = _totalStrength.sub(strength);
878         _totalSupply--;
879         _balances[msg.sender] = _balances[msg.sender].sub(1);
880         withdrawSingle(tokenId);
881         NFT.safeTransferFrom(address(this), msg.sender, tokenId, 1, "0x0");
882         emit Withdrawn(msg.sender, tokenId);
883     }
884 
885     /**
886      * @dev Withdraw all cards
887      */
888     function withdraw() public updateReward(msg.sender) {
889         uint256[] memory token = staked[msg.sender];
890         for (uint8 index = 0; index < token.length; index++) {
891             withdrawNFT(token[index]);
892         }
893     }
894 
895     /**
896      * @dev Get all rewards
897      */
898     function getReward() public nonReentrant updateReward(msg.sender) {
899         uint256 reward = rewards[msg.sender];
900         if (reward > 0) {
901             rewards[msg.sender] = 0;
902             NDR.safeTransfer(msg.sender, reward);
903             emit RewardPaid(msg.sender, reward);
904         }
905     }
906 
907     /**
908      * @dev Unstake all cards and get all rewards
909      */
910     function exit() external {
911         withdraw();
912         getReward();
913     }
914 
915     /* ========== RESTRICTED FUNCTIONS ========== */
916 
917     function onERC1155Received(address, address, uint256, uint256, bytes memory) public pure virtual returns (bytes4) {
918         return this.onERC1155Received.selector;
919     }
920 
921     function notifyRewardAmount(uint256 reward)
922         external
923         onlyOwner
924         updateReward(address(0))
925     {
926         if (block.timestamp >= periodFinish) {
927             rewardRate = reward.div(rewardsDuration);
928         } else {
929             uint256 remaining = periodFinish.sub(block.timestamp);
930             uint256 leftover = remaining.mul(rewardRate);
931             rewardRate = reward.add(leftover).div(rewardsDuration);
932         }
933 
934         // Ensure the provided reward amount is not more than the balance in the contract.
935         // This keeps the reward rate in the right range, preventing overflows due to
936         // very high values of rewardRate in the earned and rewardsPerToken functions;
937         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
938         uint256 balance = NDR.balanceOf(address(this));
939         require(
940             rewardRate <= balance.div(rewardsDuration),
941             "Provided reward too high"
942         );
943         lastUpdateTime = block.timestamp;
944         periodFinish = block.timestamp.add(rewardsDuration);
945         emit RewardAdded(reward);
946     }
947 
948     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
949     function recoverERC20(address tokenAddress, uint256 tokenAmount)
950         external
951         onlyOwner
952     {
953         // Cannot recover the staking token or the rewards token
954         require(
955             tokenAddress != address(NFT) &&
956                 tokenAddress != address(NDR),
957             "Cannot withdraw the staking or rewards tokens"
958         );
959         IERC20(tokenAddress).safeTransfer(this.owner(), tokenAmount);
960         emit Recovered(tokenAddress, tokenAmount);
961     }
962 
963     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
964         require(
965             block.timestamp > periodFinish,
966             "Previous rewards period must be complete before changing the duration for the new period"
967         );
968         rewardsDuration = _rewardsDuration;
969         emit RewardsDurationUpdated(rewardsDuration);
970     }
971 
972     /* ========== MODIFIERS ========== */
973 
974     modifier updateReward(address account) {
975         rewardPerTokenStored = rewardPerToken();
976         lastUpdateTime = lastTimeRewardApplicable();
977         if (account != address(0)) {
978             rewards[account] = earned(account);
979             userRewardPerTokenPaid[account] = rewardPerTokenStored;
980         }
981         _;
982     }
983 
984     /* ========== EVENTS ========== */
985 
986     event RewardAdded(uint256 reward);
987     event Staked(address indexed user, uint256 tokenId);
988     event Withdrawn(address indexed user, uint256 tokenId);
989     event RewardPaid(address indexed user, uint256 reward);
990     event RewardsDurationUpdated(uint256 newDuration);
991     event Recovered(address token, uint256 amount);
992 }