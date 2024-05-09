1 // SPDX-License-Identifier: GPL-3.0-or-later
2 // Includes openzeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/) code with MIT license
3 
4 
5 // File: @openzeppelin/contracts/GSN/Context.sol
6 
7 
8 pragma solidity >=0.6.0 <0.8.0;
9 
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/utils/Pausable.sol
33 
34 
35 
36 
37 
38 
39 /**
40  * @dev Contract module which allows children to implement an emergency stop
41  * mechanism that can be triggered by an authorized account.
42  *
43  * This module is used through inheritance. It will make available the
44  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
45  * the functions of your contract. Note that they will not be pausable by
46  * simply including this module, only once the modifiers are put in place.
47  */
48 abstract contract Pausable is Context {
49     /**
50      * @dev Emitted when the pause is triggered by `account`.
51      */
52     event Paused(address account);
53 
54     /**
55      * @dev Emitted when the pause is lifted by `account`.
56      */
57     event Unpaused(address account);
58 
59     bool private _paused;
60 
61     /**
62      * @dev Initializes the contract in unpaused state.
63      */
64     constructor () internal {
65         _paused = false;
66     }
67 
68     /**
69      * @dev Returns true if the contract is paused, and false otherwise.
70      */
71     function paused() public view returns (bool) {
72         return _paused;
73     }
74 
75     /**
76      * @dev Modifier to make a function callable only when the contract is not paused.
77      *
78      * Requirements:
79      *
80      * - The contract must not be paused.
81      */
82     modifier whenNotPaused() {
83         require(!_paused, "Pausable: paused");
84         _;
85     }
86 
87     /**
88      * @dev Modifier to make a function callable only when the contract is paused.
89      *
90      * Requirements:
91      *
92      * - The contract must be paused.
93      */
94     modifier whenPaused() {
95         require(_paused, "Pausable: not paused");
96         _;
97     }
98 
99     /**
100      * @dev Triggers stopped state.
101      *
102      * Requirements:
103      *
104      * - The contract must not be paused.
105      */
106     function _pause() internal virtual whenNotPaused {
107         _paused = true;
108         emit Paused(_msgSender());
109     }
110 
111     /**
112      * @dev Returns to normal state.
113      *
114      * Requirements:
115      *
116      * - The contract must be paused.
117      */
118     function _unpause() internal virtual whenPaused {
119         _paused = false;
120         emit Unpaused(_msgSender());
121     }
122 }
123 
124 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
125 
126 
127 
128 
129 
130 /**
131  * @dev Interface of the ERC20 standard as defined in the EIP.
132  */
133 interface IERC20 {
134     /**
135      * @dev Returns the amount of tokens in existence.
136      */
137     function totalSupply() external view returns (uint256);
138 
139     /**
140      * @dev Returns the amount of tokens owned by `account`.
141      */
142     function balanceOf(address account) external view returns (uint256);
143 
144     /**
145      * @dev Moves `amount` tokens from the caller's account to `recipient`.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transfer(address recipient, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Returns the remaining number of tokens that `spender` will be
155      * allowed to spend on behalf of `owner` through {transferFrom}. This is
156      * zero by default.
157      *
158      * This value changes when {approve} or {transferFrom} are called.
159      */
160     function allowance(address owner, address spender) external view returns (uint256);
161 
162     /**
163      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * IMPORTANT: Beware that changing an allowance with this method brings the risk
168      * that someone may use both the old and the new allowance by unfortunate
169      * transaction ordering. One possible solution to mitigate this race
170      * condition is to first reduce the spender's allowance to 0 and set the
171      * desired value afterwards:
172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173      *
174      * Emits an {Approval} event.
175      */
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Moves `amount` tokens from `sender` to `recipient` using the
180      * allowance mechanism. `amount` is then deducted from the caller's
181      * allowance.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
188 
189     /**
190      * @dev Emitted when `value` tokens are moved from one account (`from`) to
191      * another (`to`).
192      *
193      * Note that `value` may be zero.
194      */
195     event Transfer(address indexed from, address indexed to, uint256 value);
196 
197     /**
198      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
199      * a call to {approve}. `value` is the new allowance.
200      */
201     event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 // File: @openzeppelin/contracts/math/SafeMath.sol
205 
206 
207 
208 
209 
210 /**
211  * @dev Wrappers over Solidity's arithmetic operations with added overflow
212  * checks.
213  *
214  * Arithmetic operations in Solidity wrap on overflow. This can easily result
215  * in bugs, because programmers usually assume that an overflow raises an
216  * error, which is the standard behavior in high level programming languages.
217  * `SafeMath` restores this intuition by reverting the transaction when an
218  * operation overflows.
219  *
220  * Using this library instead of the unchecked operations eliminates an entire
221  * class of bugs, so it's recommended to use it always.
222  */
223 library SafeMath {
224     /**
225      * @dev Returns the addition of two unsigned integers, reverting on
226      * overflow.
227      *
228      * Counterpart to Solidity's `+` operator.
229      *
230      * Requirements:
231      *
232      * - Addition cannot overflow.
233      */
234     function add(uint256 a, uint256 b) internal pure returns (uint256) {
235         uint256 c = a + b;
236         require(c >= a, "SafeMath: addition overflow");
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the subtraction of two unsigned integers, reverting on
243      * overflow (when the result is negative).
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      *
249      * - Subtraction cannot overflow.
250      */
251     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
252         return sub(a, b, "SafeMath: subtraction overflow");
253     }
254 
255     /**
256      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
257      * overflow (when the result is negative).
258      *
259      * Counterpart to Solidity's `-` operator.
260      *
261      * Requirements:
262      *
263      * - Subtraction cannot overflow.
264      */
265     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b <= a, errorMessage);
267         uint256 c = a - b;
268 
269         return c;
270     }
271 
272     /**
273      * @dev Returns the multiplication of two unsigned integers, reverting on
274      * overflow.
275      *
276      * Counterpart to Solidity's `*` operator.
277      *
278      * Requirements:
279      *
280      * - Multiplication cannot overflow.
281      */
282     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
283         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
284         // benefit is lost if 'b' is also tested.
285         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
286         if (a == 0) {
287             return 0;
288         }
289 
290         uint256 c = a * b;
291         require(c / a == b, "SafeMath: multiplication overflow");
292 
293         return c;
294     }
295 
296     /**
297      * @dev Returns the integer division of two unsigned integers. Reverts on
298      * division by zero. The result is rounded towards zero.
299      *
300      * Counterpart to Solidity's `/` operator. Note: this function uses a
301      * `revert` opcode (which leaves remaining gas untouched) while Solidity
302      * uses an invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      *
306      * - The divisor cannot be zero.
307      */
308     function div(uint256 a, uint256 b) internal pure returns (uint256) {
309         return div(a, b, "SafeMath: division by zero");
310     }
311 
312     /**
313      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
314      * division by zero. The result is rounded towards zero.
315      *
316      * Counterpart to Solidity's `/` operator. Note: this function uses a
317      * `revert` opcode (which leaves remaining gas untouched) while Solidity
318      * uses an invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
325         require(b > 0, errorMessage);
326         uint256 c = a / b;
327         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
334      * Reverts when dividing by zero.
335      *
336      * Counterpart to Solidity's `%` operator. This function uses a `revert`
337      * opcode (which leaves remaining gas untouched) while Solidity uses an
338      * invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      *
342      * - The divisor cannot be zero.
343      */
344     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
345         return mod(a, b, "SafeMath: modulo by zero");
346     }
347 
348     /**
349      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
350      * Reverts with custom message when dividing by zero.
351      *
352      * Counterpart to Solidity's `%` operator. This function uses a `revert`
353      * opcode (which leaves remaining gas untouched) while Solidity uses an
354      * invalid opcode to revert (consuming all remaining gas).
355      *
356      * Requirements:
357      *
358      * - The divisor cannot be zero.
359      */
360     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
361         require(b != 0, errorMessage);
362         return a % b;
363     }
364 }
365 
366 // File: @openzeppelin/contracts/utils/Address.sol
367 
368 
369 
370 
371 
372 /**
373  * @dev Collection of functions related to the address type
374  */
375 library Address {
376     /**
377      * @dev Returns true if `account` is a contract.
378      *
379      * [IMPORTANT]
380      * ====
381      * It is unsafe to assume that an address for which this function returns
382      * false is an externally-owned account (EOA) and not a contract.
383      *
384      * Among others, `isContract` will return false for the following
385      * types of addresses:
386      *
387      *  - an externally-owned account
388      *  - a contract in construction
389      *  - an address where a contract will be created
390      *  - an address where a contract lived, but was destroyed
391      * ====
392      */
393     function isContract(address account) internal view returns (bool) {
394         // This method relies on extcodesize, which returns 0 for contracts in
395         // construction, since the code is only stored at the end of the
396         // constructor execution.
397 
398         uint256 size;
399         // solhint-disable-next-line no-inline-assembly
400         assembly { size := extcodesize(account) }
401         return size > 0;
402     }
403 
404     /**
405      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
406      * `recipient`, forwarding all available gas and reverting on errors.
407      *
408      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
409      * of certain opcodes, possibly making contracts go over the 2300 gas limit
410      * imposed by `transfer`, making them unable to receive funds via
411      * `transfer`. {sendValue} removes this limitation.
412      *
413      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
414      *
415      * IMPORTANT: because control is transferred to `recipient`, care must be
416      * taken to not create reentrancy vulnerabilities. Consider using
417      * {ReentrancyGuard} or the
418      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
419      */
420     function sendValue(address payable recipient, uint256 amount) internal {
421         require(address(this).balance >= amount, "Address: insufficient balance");
422 
423         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
424         (bool success, ) = recipient.call{ value: amount }("");
425         require(success, "Address: unable to send value, recipient may have reverted");
426     }
427 
428     /**
429      * @dev Performs a Solidity function call using a low level `call`. A
430      * plain`call` is an unsafe replacement for a function call: use this
431      * function instead.
432      *
433      * If `target` reverts with a revert reason, it is bubbled up by this
434      * function (like regular Solidity function calls).
435      *
436      * Returns the raw returned data. To convert to the expected return value,
437      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
438      *
439      * Requirements:
440      *
441      * - `target` must be a contract.
442      * - calling `target` with `data` must not revert.
443      *
444      * _Available since v3.1._
445      */
446     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
447       return functionCall(target, data, "Address: low-level call failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
452      * `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
457         return functionCallWithValue(target, data, 0, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but also transferring `value` wei to `target`.
463      *
464      * Requirements:
465      *
466      * - the calling contract must have an ETH balance of at least `value`.
467      * - the called Solidity function must be `payable`.
468      *
469      * _Available since v3.1._
470      */
471     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
472         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
477      * with `errorMessage` as a fallback revert reason when `target` reverts.
478      *
479      * _Available since v3.1._
480      */
481     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
482         require(address(this).balance >= value, "Address: insufficient balance for call");
483         require(isContract(target), "Address: call to non-contract");
484 
485         // solhint-disable-next-line avoid-low-level-calls
486         (bool success, bytes memory returndata) = target.call{ value: value }(data);
487         return _verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but performing a static call.
493      *
494      * _Available since v3.3._
495      */
496     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
497         return functionStaticCall(target, data, "Address: low-level static call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
502      * but performing a static call.
503      *
504      * _Available since v3.3._
505      */
506     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
507         require(isContract(target), "Address: static call to non-contract");
508 
509         // solhint-disable-next-line avoid-low-level-calls
510         (bool success, bytes memory returndata) = target.staticcall(data);
511         return _verifyCallResult(success, returndata, errorMessage);
512     }
513 
514     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
515         if (success) {
516             return returndata;
517         } else {
518             // Look for revert reason and bubble it up if present
519             if (returndata.length > 0) {
520                 // The easiest way to bubble the revert reason is using memory via assembly
521 
522                 // solhint-disable-next-line no-inline-assembly
523                 assembly {
524                     let returndata_size := mload(returndata)
525                     revert(add(32, returndata), returndata_size)
526                 }
527             } else {
528                 revert(errorMessage);
529             }
530         }
531     }
532 }
533 
534 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
535 
536 
537 
538 
539 
540 
541 
542 
543 /**
544  * @title SafeERC20
545  * @dev Wrappers around ERC20 operations that throw on failure (when the token
546  * contract returns false). Tokens that return no value (and instead revert or
547  * throw on failure) are also supported, non-reverting calls are assumed to be
548  * successful.
549  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
550  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
551  */
552 library SafeERC20 {
553     using SafeMath for uint256;
554     using Address for address;
555 
556     function safeTransfer(IERC20 token, address to, uint256 value) internal {
557         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
558     }
559 
560     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
561         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
562     }
563 
564     /**
565      * @dev Deprecated. This function has issues similar to the ones found in
566      * {IERC20-approve}, and its usage is discouraged.
567      *
568      * Whenever possible, use {safeIncreaseAllowance} and
569      * {safeDecreaseAllowance} instead.
570      */
571     function safeApprove(IERC20 token, address spender, uint256 value) internal {
572         // safeApprove should only be called when setting an initial allowance,
573         // or when resetting it to zero. To increase and decrease it, use
574         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
575         // solhint-disable-next-line max-line-length
576         require((value == 0) || (token.allowance(address(this), spender) == 0),
577             "SafeERC20: approve from non-zero to non-zero allowance"
578         );
579         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
580     }
581 
582     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
583         uint256 newAllowance = token.allowance(address(this), spender).add(value);
584         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
585     }
586 
587     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
588         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
589         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
590     }
591 
592     /**
593      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
594      * on the return value: the return value is optional (but if data is returned, it must not be false).
595      * @param token The token targeted by the call.
596      * @param data The call data (encoded using abi.encode or one of its variants).
597      */
598     function _callOptionalReturn(IERC20 token, bytes memory data) private {
599         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
600         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
601         // the target address contains contract code and also asserts for success in the low-level call.
602 
603         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
604         if (returndata.length > 0) { // Return data is optional
605             // solhint-disable-next-line max-line-length
606             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
607         }
608     }
609 }
610 
611 // File: @openzeppelin/contracts/access/Ownable.sol
612 
613 
614 
615 
616 
617 /**
618  * @dev Contract module which provides a basic access control mechanism, where
619  * there is an account (an owner) that can be granted exclusive access to
620  * specific functions.
621  *
622  * By default, the owner account will be the one that deploys the contract. This
623  * can later be changed with {transferOwnership}.
624  *
625  * This module is used through inheritance. It will make available the modifier
626  * `onlyOwner`, which can be applied to your functions to restrict their use to
627  * the owner.
628  */
629 abstract contract Ownable is Context {
630     address private _owner;
631 
632     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
633 
634     /**
635      * @dev Initializes the contract setting the deployer as the initial owner.
636      */
637     constructor () internal {
638         address msgSender = _msgSender();
639         _owner = msgSender;
640         emit OwnershipTransferred(address(0), msgSender);
641     }
642 
643     /**
644      * @dev Returns the address of the current owner.
645      */
646     function owner() public view returns (address) {
647         return _owner;
648     }
649 
650     /**
651      * @dev Throws if called by any account other than the owner.
652      */
653     modifier onlyOwner() {
654         require(_owner == _msgSender(), "Ownable: caller is not the owner");
655         _;
656     }
657 
658     /**
659      * @dev Leaves the contract without owner. It will not be possible to call
660      * `onlyOwner` functions anymore. Can only be called by the current owner.
661      *
662      * NOTE: Renouncing ownership will leave the contract without an owner,
663      * thereby removing any functionality that is only available to the owner.
664      */
665     function renounceOwnership() public virtual onlyOwner {
666         emit OwnershipTransferred(_owner, address(0));
667         _owner = address(0);
668     }
669 
670     /**
671      * @dev Transfers ownership of the contract to a new account (`newOwner`).
672      * Can only be called by the current owner.
673      */
674     function transferOwnership(address newOwner) public virtual onlyOwner {
675         require(newOwner != address(0), "Ownable: new owner is the zero address");
676         emit OwnershipTransferred(_owner, newOwner);
677         _owner = newOwner;
678     }
679 }
680 
681 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
682 
683 
684 
685 
686 
687 /**
688  * @dev Contract module that helps prevent reentrant calls to a function.
689  *
690  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
691  * available, which can be applied to functions to make sure there are no nested
692  * (reentrant) calls to them.
693  *
694  * Note that because there is a single `nonReentrant` guard, functions marked as
695  * `nonReentrant` may not call one another. This can be worked around by making
696  * those functions `private`, and then adding `external` `nonReentrant` entry
697  * points to them.
698  *
699  * TIP: If you would like to learn more about reentrancy and alternative ways
700  * to protect against it, check out our blog post
701  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
702  */
703 abstract contract ReentrancyGuard {
704     // Booleans are more expensive than uint256 or any type that takes up a full
705     // word because each write operation emits an extra SLOAD to first read the
706     // slot's contents, replace the bits taken up by the boolean, and then write
707     // back. This is the compiler's defense against contract upgrades and
708     // pointer aliasing, and it cannot be disabled.
709 
710     // The values being non-zero value makes deployment a bit more expensive,
711     // but in exchange the refund on every call to nonReentrant will be lower in
712     // amount. Since refunds are capped to a percentage of the total
713     // transaction's gas, it is best to keep them low in cases like this one, to
714     // increase the likelihood of the full refund coming into effect.
715     uint256 private constant _NOT_ENTERED = 1;
716     uint256 private constant _ENTERED = 2;
717 
718     uint256 private _status;
719 
720     constructor () internal {
721         _status = _NOT_ENTERED;
722     }
723 
724     /**
725      * @dev Prevents a contract from calling itself, directly or indirectly.
726      * Calling a `nonReentrant` function from another `nonReentrant`
727      * function is not supported. It is possible to prevent this from happening
728      * by making the `nonReentrant` function external, and make it call a
729      * `private` function that does the actual work.
730      */
731     modifier nonReentrant() {
732         // On the first call to nonReentrant, _notEntered will be true
733         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
734 
735         // Any calls to nonReentrant after this point will fail
736         _status = _ENTERED;
737 
738         _;
739 
740         // By storing the original value once again, a refund is triggered (see
741         // https://eips.ethereum.org/EIPS/eip-2200)
742         _status = _NOT_ENTERED;
743     }
744 }
745 
746 // File: contracts/Escapable.sol
747 
748 
749 
750 
751 
752 /*
753     Copyright 2016, Jordi Baylina
754     Contributor: Adrià Massanet <adria@codecontext.io>
755     Contributor: Oleg Abrosimov <support@ethereumico.io>
756 
757     This program is free software: you can redistribute it and/or modify
758     it under the terms of the GNU General Public License as published by
759     the Free Software Foundation, either version 3 of the License, or
760     (at your option) any later version.
761 
762     This program is distributed in the hope that it will be useful,
763     but WITHOUT ANY WARRANTY; without even the implied warranty of
764     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
765     GNU General Public License for more details.
766 
767     You should have received a copy of the GNU General Public License
768     along with this program.  If not, see <http://www.gnu.org/licenses/>.
769 
770 
771 */
772 
773 
774 
775 
776 
777 
778 /// @dev Creates an escape hatch function that can be called in an
779 ///  emergency that will allow designated addresses to send any ether or tokens
780 ///  held in the contract to an `escapeHatchDestination`
781 contract Escapable is Ownable, ReentrancyGuard {
782   using SafeERC20 for IERC20;
783 
784   /// @notice The `escapeHatch()` should only be called as a last resort if a
785   /// security issue is uncovered or something unexpected happened
786   /// @param _token to transfer, use 0x0 for ether
787   function escapeHatch(address _token, address payable _escapeHatchDestination) external onlyOwner nonReentrant {
788     require(_escapeHatchDestination != address(0x0));
789 
790     uint256 balance;
791 
792     /// @dev Logic for ether
793     if (_token == address(0x0)) {
794       balance = address(this).balance;
795       _escapeHatchDestination.transfer(balance);
796       EscapeHatchCalled(_token, balance);
797       return;
798     }
799     // Logic for tokens
800     IERC20 token = IERC20(_token);
801     balance = token.balanceOf(address(this));
802     token.safeTransfer(_escapeHatchDestination, balance);
803     emit EscapeHatchCalled(_token, balance);
804   }
805 
806   event EscapeHatchCalled(address token, uint256 amount);
807 }
808 
809 // File: contracts/MultiTransfer.sol
810 
811 
812 
813 
814 
815 /*
816     Copyright 2020, Oleg Abrosimov <support@ethereumico.io>
817     Based on work by: Jordi Baylina, Adrià Massanet, Alon Bukai
818 
819     This program is free software: you can redistribute it and/or modify
820     it under the terms of the GNU General Public License as published by
821     the Free Software Foundation, either version 3 of the License, or
822     (at your option) any later version.
823 
824     This program is distributed in the hope that it will be useful,
825     but WITHOUT ANY WARRANTY; without even the implied warranty of
826     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
827     GNU General Public License for more details.
828 
829     You should have received a copy of the GNU General Public License
830     along with this program.  If not, see <http://www.gnu.org/licenses/>.
831 
832 
833 */
834 
835 
836 
837 
838 /// @notice Transfer Ether to multiple addresses
839 contract MultiTransfer is Pausable {
840   using SafeMath for uint256;
841 
842   /// @notice Send to multiple addresses using two arrays which
843   ///  includes the address and the amount.
844   ///  Payable
845   /// @param _addresses Array of addresses to send to
846   /// @param _amounts Array of amounts to send
847   function multiTransfer_OST(address payable[] calldata _addresses, uint256[] calldata _amounts)
848   payable external whenNotPaused returns(bool)
849   {
850     // require(_addresses.length == _amounts.length);
851     // require(_addresses.length <= 255);
852     uint256 _value = msg.value;
853     for (uint8 i; i < _addresses.length; i++) {
854       _value = _value.sub(_amounts[i]);
855 
856       // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
857       /*(success, ) = */_addresses[i].call{ value: _amounts[i] }("");
858       // we do not care. caller should check sending results manually and re-send if needed.
859     }
860     return true;
861   }
862 
863   /// @notice Send to two addresses
864   ///  Payable
865   /// @param _address1 Address to send to
866   /// @param _amount1 Amount to send to _address1
867   /// @param _address2 Address to send to
868   /// @param _amount2 Amount to send to _address2
869   function transfer2(address payable _address1, uint256 _amount1, address payable _address2, uint256 _amount2)
870   payable external whenNotPaused returns(bool)
871   {
872     uint256 _value = msg.value;
873     _value = _value.sub(_amount1);
874     _value = _value.sub(_amount2);
875 
876     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
877     /*(success, ) = */_address1.call{ value: _amount1 }("");
878 
879     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
880     /*(success, ) = */_address2.call{ value: _amount2 }("");
881 
882     return true;
883   }
884 }
885 
886 // File: contracts/MultiTransferEqual.sol
887 
888 
889 
890 
891 
892 /*
893     Copyright 2020, Oleg Abrosimov <support@ethereumico.io>
894     Based on work by: Jordi Baylina, Adrià Massanet, Alon Bukai
895 
896     This program is free software: you can redistribute it and/or modify
897     it under the terms of the GNU General Public License as published by
898     the Free Software Foundation, either version 3 of the License, or
899     (at your option) any later version.
900 
901     This program is distributed in the hope that it will be useful,
902     but WITHOUT ANY WARRANTY; without even the implied warranty of
903     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
904     GNU General Public License for more details.
905 
906     You should have received a copy of the GNU General Public License
907     along with this program.  If not, see <http://www.gnu.org/licenses/>.
908 
909 
910 */
911 
912 
913 /// @notice Transfer equal Ether amount to multiple addresses
914 contract MultiTransferEqual is Pausable {
915   /// @notice Send equal Ether amount to multiple addresses.
916   ///  Payable
917   /// @param _addresses Array of addresses to send to
918   /// @param _amount Amount to send
919   function multiTransferEqual_L1R(address payable[] calldata _addresses, uint256 _amount)
920   payable external whenNotPaused returns(bool)
921   {
922     // assert(_addresses.length <= 255);
923     require(_amount <= msg.value / _addresses.length);
924     for (uint8 i; i < _addresses.length; i++) {
925       // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
926       /*(success, ) = */_addresses[i].call{ value: _amount }("");
927       // we do not care. caller should check sending results manually and re-send if needed.
928     }
929     return true;
930   }
931 }
932 
933 // File: contracts/MultiTransferToken.sol
934 
935 
936 
937 
938 
939 /*
940     Copyright 2020, Oleg Abrosimov <support@ethereumico.io>
941     Based on work by: Jordi Baylina, Adrià Massanet, Alon Bukai
942 
943     This program is free software: you can redistribute it and/or modify
944     it under the terms of the GNU General Public License as published by
945     the Free Software Foundation, either version 3 of the License, or
946     (at your option) any later version.
947 
948     This program is distributed in the hope that it will be useful,
949     but WITHOUT ANY WARRANTY; without even the implied warranty of
950     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
951     GNU General Public License for more details.
952 
953     You should have received a copy of the GNU General Public License
954     along with this program.  If not, see <http://www.gnu.org/licenses/>.
955 
956 
957 */
958 
959 
960 
961 
962 
963 /// @notice Transfer tokens to multiple addresses
964 contract MultiTransferToken is Pausable {
965   using SafeMath for uint256;
966   using SafeERC20 for IERC20;
967 
968   /// @notice Send ERC20 tokens to multiple addresses
969   ///  using two arrays which includes the address and the amount.
970   ///
971   /// @param _token The token to send
972   /// @param _addresses Array of addresses to send to
973   /// @param _amounts Array of token amounts to send
974   /// @param _amountSum Sum of the _amounts array to send
975   function multiTransferToken_a4A(
976     address _token,
977     address[] calldata _addresses,
978     uint256[] calldata _amounts,
979     uint256 _amountSum
980   ) payable external whenNotPaused
981   {
982     // require(_addresses.length == _amounts.length);
983     // require(_addresses.length <= 255);
984     IERC20 token = IERC20(_token);
985     token.safeTransferFrom(msg.sender, address(this), _amountSum);
986     for (uint8 i; i < _addresses.length; i++) {
987       _amountSum = _amountSum.sub(_amounts[i]);
988       token.transfer(_addresses[i], _amounts[i]);
989     }
990   }
991 }
992 
993 // File: contracts/MultiTransferTokenEqual.sol
994 
995 
996 
997 
998 
999 /*
1000     Copyright 2020, Oleg Abrosimov <support@ethereumico.io>
1001     Based on work by: Jordi Baylina, Adrià Massanet, Alon Bukai
1002 
1003     This program is free software: you can redistribute it and/or modify
1004     it under the terms of the GNU General Public License as published by
1005     the Free Software Foundation, either version 3 of the License, or
1006     (at your option) any later version.
1007 
1008     This program is distributed in the hope that it will be useful,
1009     but WITHOUT ANY WARRANTY; without even the implied warranty of
1010     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1011     GNU General Public License for more details.
1012 
1013     You should have received a copy of the GNU General Public License
1014     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1015 
1016 
1017 */
1018 
1019 
1020 
1021 
1022 
1023 /// @notice Transfer equal tokens amount to multiple addresses
1024 contract MultiTransferTokenEqual is Pausable {
1025   using SafeMath for uint256;
1026   using SafeERC20 for IERC20;
1027 
1028   /// @notice Send equal ERC20 tokens amount to multiple contracts
1029   ///
1030   /// @param _token The token to send
1031   /// @param _addresses Array of addresses to send to
1032   /// @param _amount Tokens amount to send to each address
1033   function multiTransferTokenEqual_71p(
1034     address _token,
1035     address[] calldata _addresses,
1036     uint256 _amount
1037   ) payable external whenNotPaused
1038   {
1039     // assert(_addresses.length <= 255);
1040     uint256 _amountSum = _amount.mul(_addresses.length);
1041     IERC20 token = IERC20(_token);
1042     token.safeTransferFrom(msg.sender, address(this), _amountSum);
1043     for (uint8 i; i < _addresses.length; i++) {
1044       token.transfer(_addresses[i], _amount);
1045     }
1046   }
1047 }
1048 
1049 // File: contracts/MultiTransferTokenEther.sol
1050 
1051 
1052 
1053 
1054 
1055 /*
1056     Copyright 2020, Oleg Abrosimov <support@ethereumico.io>
1057     Based on work by: Jordi Baylina, Adrià Massanet, Alon Bukai
1058 
1059     This program is free software: you can redistribute it and/or modify
1060     it under the terms of the GNU General Public License as published by
1061     the Free Software Foundation, either version 3 of the License, or
1062     (at your option) any later version.
1063 
1064     This program is distributed in the hope that it will be useful,
1065     but WITHOUT ANY WARRANTY; without even the implied warranty of
1066     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1067     GNU General Public License for more details.
1068 
1069     You should have received a copy of the GNU General Public License
1070     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1071 
1072 
1073 */
1074 
1075 
1076 
1077 
1078 
1079 /// @notice Transfer tokens and Ether to multiple addresses in one call
1080 contract MultiTransferTokenEther is Pausable {
1081   using SafeMath for uint256;
1082   using SafeERC20 for IERC20;
1083 
1084   /// @notice Send ERC20 tokens and Ether to multiple addresses
1085   ///  using three arrays which includes the address and the amounts.
1086   ///
1087   /// @param _token The token to send
1088   /// @param _addresses Array of addresses to send to
1089   /// @param _amounts Array of token amounts to send
1090   /// @param _amountsEther Array of Ether amounts to send
1091   function multiTransferTokenEther(
1092     address _token,
1093     address payable[] calldata _addresses,
1094     uint256[] calldata _amounts,
1095     uint256 _amountSum,
1096     uint256[] calldata _amountsEther
1097   ) payable external whenNotPaused
1098   {
1099     // assert(_addresses.length == _amounts.length);
1100     // assert(_addresses.length == _amountsEther.length);
1101     // assert(_addresses.length <= 255);
1102     uint256 _value = msg.value;
1103     IERC20 token = IERC20(_token);
1104     token.safeTransferFrom(msg.sender, address(this), _amountSum);
1105     // bool success;
1106     for (uint8 i; i < _addresses.length; i++) {
1107       _amountSum = _amountSum.sub(_amounts[i]);
1108       _value = _value.sub(_amountsEther[i]);
1109       token.transfer(_addresses[i], _amounts[i]);
1110 
1111       // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1112       /*(success, ) = */_addresses[i].call{ value: _amountsEther[i] }("");
1113       // we do not care. caller should check sending results manually and re-send if needed.
1114     }
1115   }
1116 }
1117 
1118 // File: contracts/MultiTransferTokenEtherEqual.sol
1119 
1120 
1121 
1122 
1123 
1124 /*
1125     Copyright 2020, Oleg Abrosimov <support@ethereumico.io>
1126     Based on work by: Jordi Baylina, Adrià Massanet, Alon Bukai
1127 
1128     This program is free software: you can redistribute it and/or modify
1129     it under the terms of the GNU General Public License as published by
1130     the Free Software Foundation, either version 3 of the License, or
1131     (at your option) any later version.
1132 
1133     This program is distributed in the hope that it will be useful,
1134     but WITHOUT ANY WARRANTY; without even the implied warranty of
1135     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1136     GNU General Public License for more details.
1137 
1138     You should have received a copy of the GNU General Public License
1139     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1140 
1141 
1142 */
1143 
1144 
1145 
1146 
1147 
1148 /// @notice Transfer equal amounts of tokens and Ether to multiple addresses in one call
1149 contract MultiTransferTokenEtherEqual is Pausable {
1150   using SafeMath for uint256;
1151   using SafeERC20 for IERC20;
1152 
1153   /// @notice Send equal ERC20 tokens amount to multiple addresses
1154   ///
1155   /// @param _token The token to send
1156   /// @param _addresses Array of addresses to send to
1157   /// @param _amount Tokens amount to send to each address
1158   /// @param _amountEther Ether amount to send
1159   function multiTransferTokenEtherEqual(
1160     address _token,
1161     address payable[] calldata _addresses,
1162     uint256 _amount,
1163     uint256 _amountEther
1164   ) payable external whenNotPaused
1165   {
1166     // assert(_addresses.length <= 255);
1167     require(_amountEther <= msg.value / _addresses.length);
1168 
1169     uint256 _amountSum = _amount.mul(_addresses.length);
1170     IERC20 token = IERC20(_token);
1171     token.safeTransferFrom(msg.sender, address(this), _amountSum);
1172     for (uint8 i; i < _addresses.length; i++) {
1173       token.transfer(_addresses[i], _amount);
1174 
1175       // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1176       /*(success, ) = */_addresses[i].call{ value: _amountEther }("");
1177       // we do not care. caller should check sending results manually and re-send if needed.
1178     }
1179   }
1180 }
1181 
1182 // File: contracts/MultiSend.sol
1183 
1184 
1185 
1186 
1187 
1188 /*
1189     Copyright 2020, Oleg Abrosimov <support@ethereumico.io>
1190     Based on work by: Jordi Baylina, Adrià Massanet, Alon Bukai
1191 
1192     This program is free software: you can redistribute it and/or modify
1193     it under the terms of the GNU General Public License as published by
1194     the Free Software Foundation, either version 3 of the License, or
1195     (at your option) any later version.
1196 
1197     This program is distributed in the hope that it will be useful,
1198     but WITHOUT ANY WARRANTY; without even the implied warranty of
1199     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1200     GNU General Public License for more details.
1201 
1202     You should have received a copy of the GNU General Public License
1203     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1204 
1205 
1206 */
1207 
1208 
1209 
1210 
1211 
1212 
1213 
1214 
1215 
1216 /// @notice `MultiSend` is a contract for sending multiple ETH/ERC20 Tokens to
1217 /// multiple addresses.
1218 ///
1219 /// Used for the https://ethereumico.io/multisend service and
1220 /// in the [Ethereum Wallet](https://wordpress.org/plugins/ethereum-wallet/) and
1221 /// [ERC20 Dividend Payments WordPress](https://ethereumico.io/product/erc20-dividend-payments/)
1222 /// plugins implementation
1223 ///
1224 contract MultiSend is Pausable, Escapable,
1225   MultiTransfer,
1226   MultiTransferEqual,
1227   MultiTransferToken,
1228   MultiTransferTokenEqual,
1229   MultiTransferTokenEther,
1230   MultiTransferTokenEtherEqual
1231 {
1232   /// @dev Emergency stop contract in a case of a critical security flaw discovered
1233   function emergencyStop() external onlyOwner {
1234       _pause();
1235   }
1236 
1237   /// @dev Default payable function to not allow sending to contract;
1238   receive() external payable {
1239     revert("Can not accept Ether directly.");
1240   }
1241 
1242   /// @dev Notice callers if functions that do not exist are called
1243   fallback() external payable { require(msg.data.length == 0); }
1244 }