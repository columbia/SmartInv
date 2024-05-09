1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-24
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-11-02
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.6.0;
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations with added overflow
15  * checks.
16  *
17  * Arithmetic operations in Solidity wrap on overflow. This can easily result
18  * in bugs, because programmers usually assume that an overflow raises an
19  * error, which is the standard behavior in high level programming languages.
20  * `SafeMath` restores this intuition by reverting the transaction when an
21  * operation overflows.
22  *
23  * Using this library instead of the unchecked operations eliminates an entire
24  * class of bugs, so it's recommended to use it always.
25  */
26 library SafeMath {
27     /**
28      * @dev Returns the addition of two unsigned integers, reverting on
29      * overflow.
30      *
31      * Counterpart to Solidity's `+` operator.
32      *
33      * Requirements:
34      *
35      * - Addition cannot overflow.
36      */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, reverting on
46      * overflow (when the result is negative).
47      *
48      * Counterpart to Solidity's `-` operator.
49      *
50      * Requirements:
51      *
52      * - Subtraction cannot overflow.
53      */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      *
66      * - Subtraction cannot overflow.
67      */
68     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the multiplication of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `*` operator.
80      *
81      * Requirements:
82      *
83      * - Multiplication cannot overflow.
84      */
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87         // benefit is lost if 'b' is also tested.
88         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the integer division of two unsigned integers. Reverts on
101      * division by zero. The result is rounded towards zero.
102      *
103      * Counterpart to Solidity's `/` operator. Note: this function uses a
104      * `revert` opcode (which leaves remaining gas untouched) while Solidity
105      * uses an invalid opcode to revert (consuming all remaining gas).
106      *
107      * Requirements:
108      *
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
117      * division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator. Note: this function uses a
120      * `revert` opcode (which leaves remaining gas untouched) while Solidity
121      * uses an invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      *
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      *
145      * - The divisor cannot be zero.
146      */
147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
148         return mod(a, b, "SafeMath: modulo by zero");
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * Reverts with custom message when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b != 0, errorMessage);
165         return a % b;
166     }
167 }
168 
169 
170 /**
171  * @dev Collection of functions related to the address type
172  */
173 library Address {
174     /**
175      * @dev Returns true if `account` is a contract.
176      *
177      * [IMPORTANT]
178      * ====
179      * It is unsafe to assume that an address for which this function returns
180      * false is an externally-owned account (EOA) and not a contract.
181      *
182      * Among others, `isContract` will return false for the following
183      * types of addresses:
184      *
185      *  - an externally-owned account
186      *  - a contract in construction
187      *  - an address where a contract will be created
188      *  - an address where a contract lived, but was destroyed
189      * ====
190      */
191     function isContract(address account) internal view returns (bool) {
192         // This method relies on extcodesize, which returns 0 for contracts in
193         // construction, since the code is only stored at the end of the
194         // constructor execution.
195 
196         uint256 size;
197         // solhint-disable-next-line no-inline-assembly
198         assembly { size := extcodesize(account) }
199         return size > 0;
200     }
201 
202     /**
203      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
204      * `recipient`, forwarding all available gas and reverting on errors.
205      *
206      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
207      * of certain opcodes, possibly making contracts go over the 2300 gas limit
208      * imposed by `transfer`, making them unable to receive funds via
209      * `transfer`. {sendValue} removes this limitation.
210      *
211      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
212      *
213      * IMPORTANT: because control is transferred to `recipient`, care must be
214      * taken to not create reentrancy vulnerabilities. Consider using
215      * {ReentrancyGuard} or the
216      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
217      */
218     function sendValue(address payable recipient, uint256 amount) internal {
219         require(address(this).balance >= amount, "Address: insufficient balance");
220 
221         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
222         (bool success, ) = recipient.call{ value: amount }("");
223         require(success, "Address: unable to send value, recipient may have reverted");
224     }
225 
226     /**
227      * @dev Performs a Solidity function call using a low level `call`. A
228      * plain`call` is an unsafe replacement for a function call: use this
229      * function instead.
230      *
231      * If `target` reverts with a revert reason, it is bubbled up by this
232      * function (like regular Solidity function calls).
233      *
234      * Returns the raw returned data. To convert to the expected return value,
235      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
236      *
237      * Requirements:
238      *
239      * - `target` must be a contract.
240      * - calling `target` with `data` must not revert.
241      *
242      * _Available since v3.1._
243      */
244     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
245       return functionCall(target, data, "Address: low-level call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
250      * `errorMessage` as a fallback revert reason when `target` reverts.
251      *
252      * _Available since v3.1._
253      */
254     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, 0, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but also transferring `value` wei to `target`.
261      *
262      * Requirements:
263      *
264      * - the calling contract must have an ETH balance of at least `value`.
265      * - the called Solidity function must be `payable`.
266      *
267      * _Available since v3.1._
268      */
269     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
270         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
275      * with `errorMessage` as a fallback revert reason when `target` reverts.
276      *
277      * _Available since v3.1._
278      */
279     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
280         require(address(this).balance >= value, "Address: insufficient balance for call");
281         require(isContract(target), "Address: call to non-contract");
282 
283         // solhint-disable-next-line avoid-low-level-calls
284         (bool success, bytes memory returndata) = target.call{ value: value }(data);
285         return _verifyCallResult(success, returndata, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but performing a static call.
291      *
292      * _Available since v3.3._
293      */
294     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
295         return functionStaticCall(target, data, "Address: low-level static call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
300      * but performing a static call.
301      *
302      * _Available since v3.3._
303      */
304     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
305         require(isContract(target), "Address: static call to non-contract");
306 
307         // solhint-disable-next-line avoid-low-level-calls
308         (bool success, bytes memory returndata) = target.staticcall(data);
309         return _verifyCallResult(success, returndata, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but performing a delegate call.
315      *
316      * _Available since v3.3._
317      */
318     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
324      * but performing a delegate call.
325      *
326      * _Available since v3.3._
327      */
328     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
329         require(isContract(target), "Address: delegate call to non-contract");
330 
331         // solhint-disable-next-line avoid-low-level-calls
332         (bool success, bytes memory returndata) = target.delegatecall(data);
333         return _verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
337         if (success) {
338             return returndata;
339         } else {
340             // Look for revert reason and bubble it up if present
341             if (returndata.length > 0) {
342                 // The easiest way to bubble the revert reason is using memory via assembly
343 
344                 // solhint-disable-next-line no-inline-assembly
345                 assembly {
346                     let returndata_size := mload(returndata)
347                     revert(add(32, returndata), returndata_size)
348                 }
349             } else {
350                 revert(errorMessage);
351             }
352         }
353     }
354 }
355 
356 /*
357  * @dev Provides information about the current execution context, including the
358  * sender of the transaction and its data. While these are generally available
359  * via msg.sender and msg.data, they should not be accessed in such a direct
360  * manner, since when dealing with GSN meta-transactions the account sending and
361  * paying for execution may not be the actual sender (as far as an application
362  * is concerned).
363  *
364  * This contract is only required for intermediate, library-like contracts.
365  */
366 abstract contract Context {
367     function _msgSender() internal view virtual returns (address payable) {
368         return msg.sender;
369     }
370 
371     function _msgData() internal view virtual returns (bytes memory) {
372         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
373         return msg.data;
374     }
375 }
376 
377 /**
378  * @dev Contract module which provides a basic access control mechanism, where
379  * there is an account (an owner) that can be granted exclusive access to
380  * specific functions.
381  *
382  * By default, the owner account will be the one that deploys the contract. This
383  * can later be changed with {transferOwnership}.
384  *
385  * This module is used through inheritance. It will make available the modifier
386  * `onlyOwner`, which can be applied to your functions to restrict their use to
387  * the owner.
388  */
389 contract Ownable is Context {
390     address private _owner;
391 
392     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
393 
394     /**
395      * @dev Initializes the contract setting the deployer as the initial owner.
396      */
397     constructor () internal {
398         address msgSender = _msgSender();
399         _owner = msgSender;
400         emit OwnershipTransferred(address(0), msgSender);
401     }
402 
403     /**
404      * @dev Returns the address of the current owner.
405      */
406     function owner() public view returns (address) {
407         return _owner;
408     }
409 
410     /**
411      * @dev Throws if called by any account other than the owner.
412      */
413     modifier onlyOwner() {
414         require(_owner == _msgSender(), "Ownable: caller is not the owner");
415         _;
416     }
417 
418     /**
419      * @dev Leaves the contract without owner. It will not be possible to call
420      * `onlyOwner` functions anymore. Can only be called by the current owner.
421      *
422      * NOTE: Renouncing ownership will leave the contract without an owner,
423      * thereby removing any functionality that is only available to the owner.
424      */
425     function renounceOwnership() public virtual onlyOwner {
426         emit OwnershipTransferred(_owner, address(0));
427         _owner = address(0);
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Can only be called by the current owner.
433      */
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         emit OwnershipTransferred(_owner, newOwner);
437         _owner = newOwner;
438     }
439 }
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
744     struct NftToken {
745       bool hasValue;
746       mapping(address => uint256) balances;
747     }
748 
749     /* ========== STATE VARIABLES ========== */
750 
751     IERC20 public NDR;
752     IERC1155 public NFT;
753 
754     uint256 public periodFinish = 0;
755     uint256 public rewardRate = 0;
756     uint256 public rewardsDuration = 125 days;
757     uint256 public lastUpdateTime;
758     uint256 public rewardPerTokenStored;
759     uint256 public _totalStrength;
760     uint256 private _totalSupply;
761     uint256 public fee = 0;
762 
763     mapping(address => uint256) public userRewardPerTokenPaid;
764     mapping(address => uint256) public pureStrengthWeight;
765     mapping(address => uint256) public strengthWeight;
766     mapping(address => uint256) public rewards;
767     mapping(address => uint256) private _balances;
768 
769     uint256 public tokenMaxAmount;
770     mapping(uint256 => bool) private supportedSeries;
771     uint256[] public nftTokens;
772     mapping(uint256 => NftToken) public nftTokenMap;
773     mapping(address => uint256) public percentMultiplierTokenId;
774     mapping(uint256 => uint256) public percentMultiplier;
775     mapping(address => bool) private percentMultiplierApplied;
776 
777     /* ========== CONSTRUCTOR ========== */
778 
779     constructor(address _NFT, address _NDR) public {
780         NDR = IERC20(_NDR);
781         NFT = IERC1155(_NFT);
782     }
783 
784     /* ========== VIEWS ========== */
785 
786     /**
787      * @dev Total staked cards in total
788      */
789     function totalSupply() external view returns (uint256) {
790         return _totalSupply;
791     }
792 
793     /**
794      * @dev Total staked cards by user
795      */
796     function balanceOf(address account) external view returns (uint256) {
797         return _balances[account];
798     }
799 
800     /**
801      * @dev Total staked card by user
802      */
803     function balanceByTokenIdOf(uint256 tokenId, address account) external view returns (uint256) {
804         return nftTokenMap[tokenId].balances[account];
805     }
806 
807     /**
808      * @dev Returns all NFT tokenids
809      */
810     function getNftTokens() external view returns (uint256[] memory) {
811         return nftTokens;
812     }
813 
814 
815     function lastTimeRewardApplicable() public view returns (uint256) {
816         return min(block.timestamp, periodFinish);
817     }
818 
819     function rewardPerToken() public view returns (uint256) {
820         if (_totalStrength == 0) {
821             return rewardPerTokenStored;
822         }
823         return
824             rewardPerTokenStored.add(
825                 lastTimeRewardApplicable()
826                     .sub(lastUpdateTime)
827                     .mul(rewardRate)
828                     .mul(1e18)
829                     .div(_totalStrength)
830             );
831     }
832 
833     /**
834      * @dev Get claimable NDR amount
835      */
836     function earned(address account) public view returns (uint256) {
837         return
838             strengthWeight[account]
839                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
840                 .div(1e18)
841                 .add(rewards[account]);
842     }
843 
844     function getRewardForDuration() external view returns (uint256) {
845         return rewardRate.mul(rewardsDuration);
846     }
847 
848     function min(uint256 a, uint256 b) public pure returns (uint256) {
849         return a < b ? a : b;
850     }
851 
852     /* ========== MUTATIVE FUNCTIONS ========== */
853 
854     /**
855      * @dev Sets percent multiplier
856      */
857     function setPercentMultiplier(uint256 _tokenId, uint256 _percentMultiplier) public onlyOwner {
858        percentMultiplier[_tokenId] = _percentMultiplier;
859     }
860 
861     /**
862      * @dev Sets max amount
863      */
864     function setTokenMaxAmount(uint256 _tokenMaxAmount) public onlyOwner {
865        tokenMaxAmount = _tokenMaxAmount;
866     }
867 
868     /**
869      * @dev Sets supported series
870      */
871     function setSupportedSeries(uint256 _series, bool supported) public onlyOwner {
872        supportedSeries[_series] = supported;
873     }
874 
875     /**
876      * @dev Sets withdraw reward fee
877      */
878     function setWithdrawRewardFee(uint256 _withdrawRewardFee) external onlyOwner {
879        fee = _withdrawRewardFee;
880     }
881 
882     /**
883      * @dev Change contract addresses of ERC-20, ERC-1155 tokens
884      */
885     function changeAddresses(address _NDR, address _NFT) public onlyOwner {
886         NDR = IERC20(_NDR);
887         NFT = IERC1155(_NFT);
888     }
889 
890     /**
891      * @dev Stake ERC-1155
892      */
893     function stake(uint256[] calldata tokenIds, uint256[] calldata amounts) external nonReentrant whenNotPaused updateReward(msg.sender) {
894         require(tokenIds.length == amounts.length, "TokenIds and amounts length should be the same");
895         for(uint256 i = 0; i < tokenIds.length; i++) {
896             stakeInternal(tokenIds[i], amounts[i]);
897         }
898     }
899 
900     /**
901      * @dev Stake particular ERC-1155 tokenId
902      */
903     function stakeInternal(uint256 tokenId, uint256 amount) internal {
904         (uint256 strength,,,,,uint256 series) = INodeRunnersNFT(address(NFT)).getFighter(tokenId);
905         strength = strength.mul(amount);
906 
907         if(!nftTokenMap[tokenId].hasValue) {
908             nftTokens.push(tokenId);
909             nftTokenMap[tokenId] = NftToken({ hasValue: true });
910         }
911         require(supportedSeries[series] == true, "unsupported series");
912         require(nftTokenMap[tokenId].balances[msg.sender].add(amount) <= tokenMaxAmount, "NFT max reached");
913         if(series == 3) {
914             require(amount == 1, "only one nft with series 3 allowed");
915             require(percentMultiplierApplied[msg.sender] == false, "nft with series 3 already applied");
916             percentMultiplierTokenId[msg.sender] = tokenId;
917             percentMultiplierApplied[msg.sender] = true;
918         }
919         
920         _totalStrength = _totalStrength.sub(strengthWeight[msg.sender]);
921         pureStrengthWeight[msg.sender] = pureStrengthWeight[msg.sender].add(strength);
922         
923         if(percentMultiplierApplied[msg.sender]) {
924             strengthWeight[msg.sender] = pureStrengthWeight[msg.sender].add(pureStrengthWeight[msg.sender].mul(percentMultiplier[percentMultiplierTokenId[msg.sender]]).div(100));
925         } else {
926             strengthWeight[msg.sender] = pureStrengthWeight[msg.sender];
927         }
928 
929         _totalStrength = _totalStrength.add(strengthWeight[msg.sender]);
930         _totalSupply = _totalSupply.add(amount);
931         _balances[msg.sender] = _balances[msg.sender].add(amount);        
932         nftTokenMap[tokenId].balances[msg.sender] = nftTokenMap[tokenId].balances[msg.sender].add(amount);
933 
934         NFT.safeTransferFrom(msg.sender, address(this), tokenId, amount, "0x0");
935         emit Staked(msg.sender, tokenId, amount);
936     }
937 
938     /**
939      * @dev Withdraw ERC-1155
940      */
941     function withdrawNFT(uint256[] memory tokenIds, uint256[] memory amounts) public updateReward(msg.sender) {
942         require(tokenIds.length == amounts.length, "TokenIds and amounts length should be the same");
943         for(uint256 i = 0; i < tokenIds.length; i++) {
944             withdrawNFTInternal(tokenIds[i], amounts[i]);
945         }
946     }
947 
948     /**
949      * @dev Withdraw particular ERC-1155 tokenId
950      */
951     function withdrawNFTInternal(uint256 tokenId, uint256 amount) internal {
952         (uint256 strength,,,,,uint256 series) = INodeRunnersNFT(address(NFT)).getFighter(tokenId);
953         strength = strength.mul(amount);
954 
955         _totalStrength = _totalStrength.sub(strengthWeight[msg.sender]);
956         pureStrengthWeight[msg.sender] = pureStrengthWeight[msg.sender].sub(strength);
957 
958         if(series == 3) {
959             require(amount == 1, "only one nft with series 3 allowed");
960             require(percentMultiplierApplied[msg.sender] == true, "nft with series 3 is not staked");
961             percentMultiplierApplied[msg.sender] = false;
962         }
963 
964         if(percentMultiplierApplied[msg.sender]) {
965             strengthWeight[msg.sender] = pureStrengthWeight[msg.sender].add(pureStrengthWeight[msg.sender].mul(percentMultiplier[percentMultiplierTokenId[msg.sender]]).div(100));
966         } else {
967             strengthWeight[msg.sender] = pureStrengthWeight[msg.sender];
968         }
969 
970         _totalStrength = _totalStrength.add(strengthWeight[msg.sender]);
971         _totalSupply = _totalSupply.sub(amount);
972         _balances[msg.sender] = _balances[msg.sender].sub(amount);
973         nftTokenMap[tokenId].balances[msg.sender] = nftTokenMap[tokenId].balances[msg.sender].sub(amount);
974 
975         NFT.safeTransferFrom(address(this), msg.sender, tokenId, amount, "0x0");
976         emit Withdrawn(msg.sender, tokenId, amount);
977     }
978 
979     /**
980      * @dev Withdraw all cards
981      */
982     function withdraw() public updateReward(msg.sender) {
983         uint8 length = 0;
984         for (uint8 i = 0; i < nftTokens.length; i++) {
985             uint256 balance = nftTokenMap[nftTokens[i]].balances[msg.sender];
986             if(balance > 0) {
987                 length++;
988             }
989         }
990 
991         uint256[] memory tokenIds = new uint256[](length);
992         uint256[] memory amounts = new uint256[](length);
993         uint8 j = 0;
994         for (uint8 i = 0; i < nftTokens.length; i++) {
995             uint256 tokenId = nftTokens[i];
996             uint256 balance = nftTokenMap[tokenId].balances[msg.sender];
997             if(balance > 0) {
998                 tokenIds[j] = tokenId;
999                 amounts[j] = balance;
1000                 j++;
1001             }
1002         }
1003 
1004         withdrawNFT(tokenIds, amounts);  
1005     }
1006 
1007     /**
1008      * @dev Get all rewards. used internally
1009      */
1010     function getRewardInternal() internal nonReentrant updateReward(msg.sender) {
1011         uint256 reward = rewards[msg.sender];
1012         if (reward > 0) {
1013             rewards[msg.sender] = 0;
1014             NDR.safeTransfer(msg.sender, reward);
1015             emit RewardPaid(msg.sender, reward);
1016         }
1017     }
1018 
1019     /**
1020      * @dev Get all rewards
1021      */
1022     function getReward() public payable {
1023         require (msg.value == fee, "Get reward fee required");
1024         getRewardInternal();
1025     }
1026 
1027     /**
1028      * @dev Unstake all cards and get all rewards
1029      */
1030     function exit() external payable {
1031         require (msg.value == fee, "Get reward fee required");
1032         withdraw();
1033         getRewardInternal();
1034     }
1035 
1036     /**
1037      * @dev Withdraw reward fee
1038      */
1039     function withdrawRewardFee() external onlyOwner {
1040         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1041         require(success, "Transfer failed");
1042     }
1043 
1044     /* ========== RESTRICTED FUNCTIONS ========== */
1045 
1046     function onERC1155Received(address, address, uint256, uint256, bytes memory) public pure virtual returns (bytes4) {
1047         return this.onERC1155Received.selector;
1048     }
1049 
1050     function notifyRewardAmount(uint256 reward)
1051         external
1052         onlyOwner
1053         updateReward(address(0))
1054     {
1055         if (block.timestamp >= periodFinish) {
1056             rewardRate = reward.div(rewardsDuration);
1057         } else {
1058             uint256 remaining = periodFinish.sub(block.timestamp);
1059             uint256 leftover = remaining.mul(rewardRate);
1060             rewardRate = reward.add(leftover).div(rewardsDuration);
1061         }
1062 
1063         // Ensure the provided reward amount is not more than the balance in the contract.
1064         // This keeps the reward rate in the right range, preventing overflows due to
1065         // very high values of rewardRate in the earned and rewardsPerToken functions;
1066         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1067         uint256 balance = NDR.balanceOf(address(this));
1068         require(
1069             rewardRate <= balance.div(rewardsDuration),
1070             "Provided reward too high"
1071         );
1072         lastUpdateTime = block.timestamp;
1073         periodFinish = block.timestamp.add(rewardsDuration);
1074         emit RewardAdded(reward);
1075     }
1076 
1077     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
1078     function recoverERC20(address tokenAddress, uint256 tokenAmount)
1079         external
1080         onlyOwner
1081     {
1082         // Cannot recover the staking token or the rewards token
1083         require(
1084             tokenAddress != address(NFT) &&
1085                 tokenAddress != address(NDR),
1086             "Cannot withdraw the staking or rewards tokens"
1087         );
1088         IERC20(tokenAddress).safeTransfer(this.owner(), tokenAmount);
1089         emit Recovered(tokenAddress, tokenAmount);
1090     }
1091 
1092     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
1093         require(
1094             block.timestamp > periodFinish,
1095             "Previous rewards period must be complete before changing the duration for the new period"
1096         );
1097         rewardsDuration = _rewardsDuration;
1098         emit RewardsDurationUpdated(rewardsDuration);
1099     }
1100 
1101     /* ========== MODIFIERS ========== */
1102 
1103     modifier updateReward(address account) {
1104         rewardPerTokenStored = rewardPerToken();
1105         lastUpdateTime = lastTimeRewardApplicable();
1106         if (account != address(0)) {
1107             rewards[account] = earned(account);
1108             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1109         }
1110         _;
1111     }
1112 
1113     /* ========== EVENTS ========== */
1114 
1115     event RewardAdded(uint256 reward);
1116     event Staked(address indexed user, uint256 tokenId, uint256 amount);
1117     event Withdrawn(address indexed user, uint256 tokenId, uint256 amount);
1118     event RewardPaid(address indexed user, uint256 reward);
1119     event RewardsDurationUpdated(uint256 newDuration);
1120     event Recovered(address token, uint256 amount);
1121 
1122     receive() external payable {
1123     }
1124 }