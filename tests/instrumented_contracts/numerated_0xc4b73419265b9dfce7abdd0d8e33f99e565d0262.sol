1 pragma solidity ^0.6.12;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      *
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      *
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      *
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      *
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      *
99      * - The divisor cannot be zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      *
115      * - The divisor cannot be zero.
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 
160 /**
161  * @dev Collection of functions related to the address type
162  */
163  
164 library Address {
165     /**
166      * @dev Returns true if `account` is a contract.
167      *
168      * [IMPORTANT]
169      * ====
170      * It is unsafe to assume that an address for which this function returns
171      * false is an externally-owned account (EOA) and not a contract.
172      *
173      * Among others, `isContract` will return false for the following
174      * types of addresses:
175      *
176      *  - an externally-owned account
177      *  - a contract in construction
178      *  - an address where a contract will be created
179      *  - an address where a contract lived, but was destroyed
180      * ====
181      */
182     function isContract(address account) internal view returns (bool) {
183         // This method relies on extcodesize, which returns 0 for contracts in
184         // construction, since the code is only stored at the end of the
185         // constructor execution.
186 
187         uint256 size;
188         // solhint-disable-next-line no-inline-assembly
189         assembly { size := extcodesize(account) }
190         return size > 0;
191     }
192 
193     /**
194      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
195      * `recipient`, forwarding all available gas and reverting on errors.
196      *
197      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
198      * of certain opcodes, possibly making contracts go over the 2300 gas limit
199      * imposed by `transfer`, making them unable to receive funds via
200      * `transfer`. {sendValue} removes this limitation.
201      *
202      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
203      *
204      * IMPORTANT: because control is transferred to `recipient`, care must be
205      * taken to not create reentrancy vulnerabilities. Consider using
206      * {ReentrancyGuard} or the
207      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
208      */
209     function sendValue(address payable recipient, uint256 amount) internal {
210         require(address(this).balance >= amount, "Address: insufficient balance");
211 
212         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
213         (bool success, ) = recipient.call{ value: amount }("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 
217     /**
218      * @dev Performs a Solidity function call using a low level `call`. A
219      * plain`call` is an unsafe replacement for a function call: use this
220      * function instead.
221      *
222      * If `target` reverts with a revert reason, it is bubbled up by this
223      * function (like regular Solidity function calls).
224      *
225      * Returns the raw returned data. To convert to the expected return value,
226      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
227      *
228      * Requirements:
229      *
230      * - `target` must be a contract.
231      * - calling `target` with `data` must not revert.
232      *
233      * _Available since v3.1._
234      */
235     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
236       return functionCall(target, data, "Address: low-level call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
241      * `errorMessage` as a fallback revert reason when `target` reverts.
242      *
243      * _Available since v3.1._
244      */
245     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
246         return functionCallWithValue(target, data, 0, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but also transferring `value` wei to `target`.
252      *
253      * Requirements:
254      *
255      * - the calling contract must have an ETH balance of at least `value`.
256      * - the called Solidity function must be `payable`.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
261         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
266      * with `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
271         require(address(this).balance >= value, "Address: insufficient balance for call");
272         require(isContract(target), "Address: call to non-contract");
273 
274         // solhint-disable-next-line avoid-low-level-calls
275         (bool success, bytes memory returndata) = target.call{ value: value }(data);
276         return _verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but performing a static call.
282      *
283      * _Available since v3.3._
284      */
285     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
286         return functionStaticCall(target, data, "Address: low-level static call failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
291      * but performing a static call.
292      *
293      * _Available since v3.3._
294      */
295     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
296         require(isContract(target), "Address: static call to non-contract");
297 
298         // solhint-disable-next-line avoid-low-level-calls
299         (bool success, bytes memory returndata) = target.staticcall(data);
300         return _verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.3._
308      */
309     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a delegate call.
316      *
317      * _Available since v3.3._
318      */
319     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
320         require(isContract(target), "Address: delegate call to non-contract");
321 
322         // solhint-disable-next-line avoid-low-level-calls
323         (bool success, bytes memory returndata) = target.delegatecall(data);
324         return _verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
328         if (success) {
329             return returndata;
330         } else {
331             // Look for revert reason and bubble it up if present
332             if (returndata.length > 0) {
333                 // The easiest way to bubble the revert reason is using memory via assembly
334 
335                 // solhint-disable-next-line no-inline-assembly
336                 assembly {
337                     let returndata_size := mload(returndata)
338                     revert(add(32, returndata), returndata_size)
339                 }
340             } else {
341                 revert(errorMessage);
342             }
343         }
344     }
345 }
346 
347 
348 /*
349  * @dev Provides information about the current execution context, including the
350  * sender of the transaction and its data. While these are generally available
351  * via msg.sender and msg.data, they should not be accessed in such a direct
352  * manner, since when dealing with GSN meta-transactions the account sending and
353  * paying for execution may not be the actual sender (as far as an application
354  * is concerned).
355  *
356  * This contract is only required for intermediate, library-like contracts.
357  */
358 abstract contract Context {
359     function _msgSender() internal view virtual returns (address payable) {
360         return msg.sender;
361     }
362 
363     function _msgData() internal view virtual returns (bytes memory) {
364         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
365         return msg.data;
366     }
367 }
368 
369 
370 /**
371  * @dev Contract module which provides a basic access control mechanism, where
372  * there is an account (an owner) that can be granted exclusive access to
373  * specific functions.
374  *
375  * By default, the owner account will be the one that deploys the contract. This
376  * can later be changed with {transferOwnership}.
377  *
378  * This module is used through inheritance. It will make available the modifier
379  * `onlyOwner`, which can be applied to your functions to restrict their use to
380  * the owner.
381  */
382 contract Ownable is Context {
383     address private _owner;
384 
385     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
386 
387     /**
388      * @dev Initializes the contract setting the deployer as the initial owner.
389      */
390     constructor () internal {
391         address msgSender = _msgSender();
392         _owner = msgSender;
393         emit OwnershipTransferred(address(0), msgSender);
394     }
395 
396     /**
397      * @dev Returns the address of the current owner.
398      */
399     function owner() public view returns (address) {
400         return _owner;
401     }
402 
403     /**
404      * @dev Throws if called by any account other than the owner.
405      */
406     modifier onlyOwner() {
407         require(_owner == _msgSender(), "Ownable: caller is not the owner");
408         _;
409     }
410 
411     /**
412      * @dev Leaves the contract without owner. It will not be possible to call
413      * `onlyOwner` functions anymore. Can only be called by the current owner.
414      *
415      * NOTE: Renouncing ownership will leave the contract without an owner,
416      * thereby removing any functionality that is only available to the owner.
417      */
418     function renounceOwnership() public virtual onlyOwner {
419         emit OwnershipTransferred(_owner, address(0));
420         _owner = address(0);
421     }
422 
423     /**
424      * @dev Transfers ownership of the contract to a new account (`newOwner`).
425      * Can only be called by the current owner.
426      */
427     function transferOwnership(address newOwner) public virtual onlyOwner {
428         require(newOwner != address(0), "Ownable: new owner is the zero address");
429         emit OwnershipTransferred(_owner, newOwner);
430         _owner = newOwner;
431     }
432 }
433 
434 
435 
436 /**
437  * @dev Contract module that helps prevent reentrant calls to a function.
438  *
439  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
440  * available, which can be applied to functions to make sure there are no nested
441  * (reentrant) calls to them.
442  *
443  * Note that because there is a single `nonReentrant` guard, functions marked as
444  * `nonReentrant` may not call one another. This can be worked around by making
445  * those functions `private`, and then adding `external` `nonReentrant` entry
446  * points to them.
447  *
448  * TIP: If you would like to learn more about reentrancy and alternative ways
449  * to protect against it, check out our blog post
450  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
451  */
452 contract ReentrancyGuard {
453     // Booleans are more expensive than uint256 or any type that takes up a full
454     // word because each write operation emits an extra SLOAD to first read the
455     // slot's contents, replace the bits taken up by the boolean, and then write
456     // back. This is the compiler's defense against contract upgrades and
457     // pointer aliasing, and it cannot be disabled.
458 
459     // The values being non-zero value makes deployment a bit more expensive,
460     // but in exchange the refund on every call to nonReentrant will be lower in
461     // amount. Since refunds are capped to a percentage of the total
462     // transaction's gas, it is best to keep them low in cases like this one, to
463     // increase the likelihood of the full refund coming into effect.
464     uint256 private constant _NOT_ENTERED = 1;
465     uint256 private constant _ENTERED = 2;
466 
467     uint256 private _status;
468 
469     constructor () internal {
470         _status = _NOT_ENTERED;
471     }
472 
473     /**
474      * @dev Prevents a contract from calling itself, directly or indirectly.
475      * Calling a `nonReentrant` function from another `nonReentrant`
476      * function is not supported. It is possible to prevent this from happening
477      * by making the `nonReentrant` function external, and make it call a
478      * `private` function that does the actual work.
479      */
480     modifier nonReentrant() {
481         // On the first call to nonReentrant, _notEntered will be true
482         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
483 
484         // Any calls to nonReentrant after this point will fail
485         _status = _ENTERED;
486 
487         _;
488 
489         // By storing the original value once again, a refund is triggered (see
490         // https://eips.ethereum.org/EIPS/eip-2200)
491         _status = _NOT_ENTERED;
492     }
493 }
494 
495 /**
496  * @dev Contract module which allows children to implement an emergency stop
497  * mechanism that can be triggered by an authorized account.
498  *
499  * This module is used through inheritance. It will make available the
500  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
501  * the functions of your contract. Note that they will not be pausable by
502  * simply including this module, only once the modifiers are put in place.
503  */
504 contract Pausable is Context {
505     /**
506      * @dev Emitted when the pause is triggered by `account`.
507      */
508     event Paused(address account);
509 
510     /**
511      * @dev Emitted when the pause is lifted by `account`.
512      */
513     event Unpaused(address account);
514 
515     bool private _paused;
516 
517     /**
518      * @dev Initializes the contract in unpaused state.
519      */
520     constructor () internal {
521         _paused = false;
522     }
523 
524     /**
525      * @dev Returns true if the contract is paused, and false otherwise.
526      */
527     function paused() public view returns (bool) {
528         return _paused;
529     }
530 
531     /**
532      * @dev Modifier to make a function callable only when the contract is not paused.
533      *
534      * Requirements:
535      *
536      * - The contract must not be paused.
537      */
538     modifier whenNotPaused() {
539         require(!_paused, "Pausable: paused");
540         _;
541     }
542 
543     /**
544      * @dev Modifier to make a function callable only when the contract is paused.
545      *
546      * Requirements:
547      *
548      * - The contract must be paused.
549      */
550     modifier whenPaused() {
551         require(_paused, "Pausable: not paused");
552         _;
553     }
554 
555     /**
556      * @dev Triggers stopped state.
557      *
558      * Requirements:
559      *
560      * - The contract must not be paused.
561      */
562     function _pause() internal virtual whenNotPaused {
563         _paused = true;
564         emit Paused(_msgSender());
565     }
566 
567     /**
568      * @dev Returns to normal state.
569      *
570      * Requirements:
571      *
572      * - The contract must be paused.
573      */
574     function _unpause() internal virtual whenPaused {
575         _paused = false;
576         emit Unpaused(_msgSender());
577     }
578 }
579 
580 /**
581  * @dev Interface of the ERC20 standard as defined in the EIP.
582  */
583 interface IERC20 {
584     /**
585      * @dev Returns the amount of tokens in existence.
586      */
587     function totalSupply() external view returns (uint256);
588 
589     /**
590      * @dev Returns the amount of tokens owned by `account`.
591      */
592     function balanceOf(address account) external view returns (uint256);
593 
594     /**
595      * @dev Moves `amount` tokens from the caller's account to `recipient`.
596      *
597      * Returns a boolean value indicating whether the operation succeeded.
598      *
599      * Emits a {Transfer} event.
600      */
601     function transfer(address recipient, uint256 amount) external returns (bool);
602 
603     /**
604      * @dev Returns the remaining number of tokens that `spender` will be
605      * allowed to spend on behalf of `owner` through {transferFrom}. This is
606      * zero by default.
607      *
608      * This value changes when {approve} or {transferFrom} are called.
609      */
610     function allowance(address owner, address spender) external view returns (uint256);
611 
612     /**
613      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
614      *
615      * Returns a boolean value indicating whether the operation succeeded.
616      *
617      * IMPORTANT: Beware that changing an allowance with this method brings the risk
618      * that someone may use both the old and the new allowance by unfortunate
619      * transaction ordering. One possible solution to mitigate this race
620      * condition is to first reduce the spender's allowance to 0 and set the
621      * desired value afterwards:
622      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
623      *
624      * Emits an {Approval} event.
625      */
626     function approve(address spender, uint256 amount) external returns (bool);
627 
628     /**
629      * @dev Moves `amount` tokens from `sender` to `recipient` using the
630      * allowance mechanism. `amount` is then deducted from the caller's
631      * allowance.
632      *
633      * Returns a boolean value indicating whether the operation succeeded.
634      *
635      * Emits a {Transfer} event.
636      */
637     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
638 
639     /**
640      * @dev Emitted when `value` tokens are moved from one account (`from`) to
641      * another (`to`).
642      *
643      * Note that `value` may be zero.
644      */
645     event Transfer(address indexed from, address indexed to, uint256 value);
646 
647     /**
648      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
649      * a call to {approve}. `value` is the new allowance.
650      */
651     event Approval(address indexed owner, address indexed spender, uint256 value);
652 }
653 
654 
655 /**
656  * @title SafeERC20
657  * @dev Wrappers around ERC20 operations that throw on failure (when the token
658  * contract returns false). Tokens that return no value (and instead revert or
659  * throw on failure) are also supported, non-reverting calls are assumed to be
660  * successful.
661  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
662  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
663  */
664 library SafeERC20 {
665     using SafeMath for uint256;
666     using Address for address;
667 
668     function safeTransfer(IERC20 token, address to, uint256 value) internal {
669         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
670     }
671 
672     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
673         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
674     }
675 
676     /**
677      * @dev Deprecated. This function has issues similar to the ones found in
678      * {IERC20-approve}, and its usage is discouraged.
679      *
680      * Whenever possible, use {safeIncreaseAllowance} and
681      * {safeDecreaseAllowance} instead.
682      */
683     function safeApprove(IERC20 token, address spender, uint256 value) internal {
684         // safeApprove should only be called when setting an initial allowance,
685         // or when resetting it to zero. To increase and decrease it, use
686         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
687         // solhint-disable-next-line max-line-length
688         require((value == 0) || (token.allowance(address(this), spender) == 0),
689             "SafeERC20: approve from non-zero to non-zero allowance"
690         );
691         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
692     }
693 
694     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
695         uint256 newAllowance = token.allowance(address(this), spender).add(value);
696         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
697     }
698 
699     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
700         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
701         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
702     }
703 
704     /**
705      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
706      * on the return value: the return value is optional (but if data is returned, it must not be false).
707      * @param token The token targeted by the call.
708      * @param data The call data (encoded using abi.encode or one of its variants).
709      */
710     function _callOptionalReturn(IERC20 token, bytes memory data) private {
711         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
712         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
713         // the target address contains contract code and also asserts for success in the low-level call.
714 
715         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
716         if (returndata.length > 0) { // Return data is optional
717             // solhint-disable-next-line max-line-length
718             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
719         }
720     }
721 }
722 
723 interface INFTStaking {
724     function balanceOf(address account) external view returns (uint256);
725 }
726 
727 contract ERC20CustomStaking is ReentrancyGuard, Pausable, Ownable {
728     using SafeMath for uint256;
729     using SafeERC20 for IERC20;
730 
731     /* ========== STATE VARIABLES ========== */
732 
733     IERC20 public NDR;
734     IERC20 public token;
735     INFTStaking public NFTStaking;
736 
737     uint256 public periodFinish = 0;
738     uint256 public rewardRate = 0;
739     uint256 public rewardsDuration;
740     uint256 public lastUpdateTime;
741     uint256 public rewardPerTokenStored;
742     uint256 private _totalSupply;
743     bool public nftRequired;
744 
745     mapping(address => uint256) public userRewardPerTokenPaid;
746     mapping(address => uint256) public rewards;
747     mapping(address => uint256) public balances;
748 
749     uint256 public tokenMaxAmount;
750     
751     /* ========== CONSTRUCTOR ========== */
752 
753     constructor(address _token, address _NDR, address _NFTSTAKING) public {
754         token = IERC20(_token);
755         NDR = IERC20(_NDR);
756         NFTStaking = INFTStaking(_NFTSTAKING);
757     }
758 
759     /* ========== VIEWS ========== */
760 
761     /**
762      * @dev Total staked cards in total
763      */
764     function totalSupply() external view returns (uint256) {
765         return _totalSupply;
766     }
767 
768     /**
769      * @dev Total stake by user
770      */
771     function balanceOf(address account) external view returns (uint256) {
772         return balances[account];
773     }
774 
775     function lastTimeRewardApplicable() public view returns (uint256) {
776         return min(block.timestamp, periodFinish);
777     }
778 
779     function rewardPerToken() public view returns (uint256) {
780         if (_totalSupply == 0) {
781             return rewardPerTokenStored;
782         }
783         return
784             rewardPerTokenStored.add(
785                 lastTimeRewardApplicable()
786                     .sub(lastUpdateTime)
787                     .mul(rewardRate)
788                     .mul(10 ** 18)
789                     .div(_totalSupply)
790             );
791     }
792 
793     /**
794      * @dev Get claimable NDR amount
795      */
796     function earned(address account) public view returns (uint256) {
797         uint8 rewardApplicable = 1;
798         if(nftRequired) {
799             rewardApplicable = NFTStaking.balanceOf(account) > 0 ? 1 : 0;
800         }
801         return balances[account].mul(rewardApplicable)
802             .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
803             .div(10 ** 18)
804             .add(rewards[account]);
805     }
806 
807     function getRewardForDuration() external view returns (uint256) {
808         return rewardRate.mul(rewardsDuration);
809     }
810 
811     function min(uint256 a, uint256 b) public pure returns (uint256) {
812         return a < b ? a : b;
813     }
814 
815     /* ========== MUTATIVE FUNCTIONS ========== */
816 
817     /**
818      * @dev Sets max amount
819      */
820     function setTokenMaxAmount(uint256 _tokenMaxAmount) public onlyOwner {
821        tokenMaxAmount = _tokenMaxAmount;
822     }
823 
824     /**
825      * @dev init supported ERC-20 
826      */
827     function setNftRequired(bool _nftRequired) public onlyOwner {
828        nftRequired = _nftRequired;
829     }
830 
831     /**
832      * @dev Change contract addresses of ERC-20, ERC-1155 tokens
833      */
834     function changeAddresses(address _NDR, address _token) public onlyOwner {
835         NDR = IERC20(_NDR);
836         token = IERC20(_token);
837     }
838 
839     /**
840      * @dev Stake ERC-1155
841      */
842     function stake(uint256 amount) external nonReentrant whenNotPaused updateReward(msg.sender) {
843         require(balances[msg.sender].add(amount) <= tokenMaxAmount, "ERC20 max");
844         
845         token.safeTransferFrom(msg.sender, address(this), amount);
846         _totalSupply = _totalSupply.add(amount);
847         balances[msg.sender] = balances[msg.sender].add(amount);
848 
849         emit Staked(msg.sender, amount);
850     }
851 
852     /**
853      * @dev Withdraw ERC-20
854      */
855     function withdraw(uint256 amount) public updateReward(msg.sender) {
856         _totalSupply = _totalSupply.sub(amount);
857         balances[msg.sender] = balances[msg.sender].sub(amount);
858         token.safeTransfer(msg.sender, amount);
859 
860         emit Withdrawn(msg.sender, amount);
861     }
862 
863     /**
864      * @dev Get all rewards
865      */
866     function getReward() public nonReentrant updateReward(msg.sender) {
867         uint256 reward = rewards[msg.sender];
868         if (reward > 0) {
869             rewards[msg.sender] = 0;
870             NDR.safeTransfer(msg.sender, reward);
871             emit RewardPaid(msg.sender, reward);
872         }
873     }
874 
875     /**
876      * @dev Unstake all cards and get all rewards
877      */
878     function exit() external {
879         withdraw(balances[msg.sender]);
880         getReward();
881     }
882 
883     /* ========== RESTRICTED FUNCTIONS ========== */
884 
885     function notifyRewardAmount(uint256 reward, uint256 duration)
886         external
887         onlyOwner
888         updateReward(address(0))
889     {
890         rewardsDuration = duration;
891         if (block.timestamp >= periodFinish) {
892             rewardRate = reward.div(rewardsDuration);
893         } else {
894             uint256 remaining = periodFinish.sub(block.timestamp);
895             uint256 leftover = remaining.mul(rewardRate);
896             rewardRate = reward.add(leftover).div(rewardsDuration);
897         }
898 
899         // Ensure the provided reward amount is not more than the balance in the contract.
900         // This keeps the reward rate in the right range, preventing overflows due to
901         // very high values of rewardRate in the earned and rewardsPerToken functions;
902         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
903         uint256 balance = NDR.balanceOf(address(this));
904         require(
905             rewardRate <= balance.div(rewardsDuration),
906             "Provided reward too high"
907         );
908         lastUpdateTime = block.timestamp;
909         periodFinish = block.timestamp.add(rewardsDuration);
910         emit RewardAdded(reward);
911     }
912 
913     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
914     function recoverERC20(address tokenAddress, uint256 tokenAmount)
915         external
916         onlyOwner
917     {
918         // Cannot recover the staking token or the rewards token
919         require(tokenAddress != address(token) && tokenAddress != address(NDR), "Cannot withdraw the staking or rewards tokens");
920         IERC20(tokenAddress).safeTransfer(this.owner(), tokenAmount);
921         emit Recovered(tokenAddress, tokenAmount);
922     }
923 
924     function setRewardsDuration(uint256 duration) external onlyOwner {
925         require(
926             block.timestamp > periodFinish,
927             "Previous rewards period must be complete before changing the duration for the new period"
928         );
929         rewardsDuration = duration;
930         emit RewardsDurationUpdated(duration);
931     }
932 
933     /* ========== MODIFIERS ========== */
934 
935     modifier updateReward(address account) {
936         rewardPerTokenStored = rewardPerToken();
937         lastUpdateTime = lastTimeRewardApplicable();
938         if (account != address(0)) {
939             rewards[account] = earned(account);
940             userRewardPerTokenPaid[account] = rewardPerTokenStored;
941         }
942         _;
943     }
944 
945     /* ========== EVENTS ========== */
946 
947     event RewardAdded(uint256 reward);
948     event Staked(address indexed user, uint256 amount);
949     event Withdrawn(address indexed user, uint256 amount);
950     event RewardPaid(address indexed user, uint256 reward);
951     event RewardsDurationUpdated(uint256 newDuration);
952     event Recovered(address token, uint256 amount);
953 }