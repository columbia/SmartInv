1 pragma solidity =0.6.6;
2 
3 
4 // 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 // 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
260         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
261         // for accounts without code, i.e. `keccak256('')`
262         bytes32 codehash;
263         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { codehash := extcodehash(account) }
266         return (codehash != accountHash && codehash != 0x0);
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain`call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312       return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
322         return _functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         return _functionCallWithValue(target, data, value, errorMessage);
349     }
350 
351     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
352         require(isContract(target), "Address: call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
356         if (success) {
357             return returndata;
358         } else {
359             // Look for revert reason and bubble it up if present
360             if (returndata.length > 0) {
361                 // The easiest way to bubble the revert reason is using memory via assembly
362 
363                 // solhint-disable-next-line no-inline-assembly
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 // 
376 /**
377  * @title SafeERC20
378  * @dev Wrappers around ERC20 operations that throw on failure (when the token
379  * contract returns false). Tokens that return no value (and instead revert or
380  * throw on failure) are also supported, non-reverting calls are assumed to be
381  * successful.
382  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
383  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
384  */
385 library SafeERC20 {
386     using SafeMath for uint256;
387     using Address for address;
388 
389     function safeTransfer(IERC20 token, address to, uint256 value) internal {
390         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
391     }
392 
393     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
394         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
395     }
396 
397     /**
398      * @dev Deprecated. This function has issues similar to the ones found in
399      * {IERC20-approve}, and its usage is discouraged.
400      *
401      * Whenever possible, use {safeIncreaseAllowance} and
402      * {safeDecreaseAllowance} instead.
403      */
404     function safeApprove(IERC20 token, address spender, uint256 value) internal {
405         // safeApprove should only be called when setting an initial allowance,
406         // or when resetting it to zero. To increase and decrease it, use
407         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
408         // solhint-disable-next-line max-line-length
409         require((value == 0) || (token.allowance(address(this), spender) == 0),
410             "SafeERC20: approve from non-zero to non-zero allowance"
411         );
412         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
413     }
414 
415     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
416         uint256 newAllowance = token.allowance(address(this), spender).add(value);
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
418     }
419 
420     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
422         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
423     }
424 
425     /**
426      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
427      * on the return value: the return value is optional (but if data is returned, it must not be false).
428      * @param token The token targeted by the call.
429      * @param data The call data (encoded using abi.encode or one of its variants).
430      */
431     function _callOptionalReturn(IERC20 token, bytes memory data) private {
432         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
433         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
434         // the target address contains contract code and also asserts for success in the low-level call.
435 
436         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
437         if (returndata.length > 0) { // Return data is optional
438             // solhint-disable-next-line max-line-length
439             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
440         }
441     }
442 }
443 
444 // 
445 /*
446  * @dev Provides information about the current execution context, including the
447  * sender of the transaction and its data. While these are generally available
448  * via msg.sender and msg.data, they should not be accessed in such a direct
449  * manner, since when dealing with GSN meta-transactions the account sending and
450  * paying for execution may not be the actual sender (as far as an application
451  * is concerned).
452  *
453  * This contract is only required for intermediate, library-like contracts.
454  */
455 abstract contract Context {
456     function _msgSender() internal view virtual returns (address payable) {
457         return msg.sender;
458     }
459 
460     function _msgData() internal view virtual returns (bytes memory) {
461         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
462         return msg.data;
463     }
464 }
465 
466 // 
467 /**
468  * @dev Contract module which allows children to implement an emergency stop
469  * mechanism that can be triggered by an authorized account.
470  *
471  * This module is used through inheritance. It will make available the
472  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
473  * the functions of your contract. Note that they will not be pausable by
474  * simply including this module, only once the modifiers are put in place.
475  */
476 contract Pausable is Context {
477     /**
478      * @dev Emitted when the pause is triggered by `account`.
479      */
480     event Paused(address account);
481 
482     /**
483      * @dev Emitted when the pause is lifted by `account`.
484      */
485     event Unpaused(address account);
486 
487     bool private _paused;
488 
489     /**
490      * @dev Initializes the contract in unpaused state.
491      */
492     constructor () internal {
493         _paused = false;
494     }
495 
496     /**
497      * @dev Returns true if the contract is paused, and false otherwise.
498      */
499     function paused() public view returns (bool) {
500         return _paused;
501     }
502 
503     /**
504      * @dev Modifier to make a function callable only when the contract is not paused.
505      *
506      * Requirements:
507      *
508      * - The contract must not be paused.
509      */
510     modifier whenNotPaused() {
511         require(!_paused, "Pausable: paused");
512         _;
513     }
514 
515     /**
516      * @dev Modifier to make a function callable only when the contract is paused.
517      *
518      * Requirements:
519      *
520      * - The contract must be paused.
521      */
522     modifier whenPaused() {
523         require(_paused, "Pausable: not paused");
524         _;
525     }
526 
527     /**
528      * @dev Triggers stopped state.
529      *
530      * Requirements:
531      *
532      * - The contract must not be paused.
533      */
534     function _pause() internal virtual whenNotPaused {
535         _paused = true;
536         emit Paused(_msgSender());
537     }
538 
539     /**
540      * @dev Returns to normal state.
541      *
542      * Requirements:
543      *
544      * - The contract must be paused.
545      */
546     function _unpause() internal virtual whenPaused {
547         _paused = false;
548         emit Unpaused(_msgSender());
549     }
550 }
551 
552 // 
553 /**
554  * @dev Contract module that helps prevent reentrant calls to a function.
555  *
556  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
557  * available, which can be applied to functions to make sure there are no nested
558  * (reentrant) calls to them.
559  *
560  * Note that because there is a single `nonReentrant` guard, functions marked as
561  * `nonReentrant` may not call one another. This can be worked around by making
562  * those functions `private`, and then adding `external` `nonReentrant` entry
563  * points to them.
564  *
565  * TIP: If you would like to learn more about reentrancy and alternative ways
566  * to protect against it, check out our blog post
567  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
568  */
569 contract ReentrancyGuard {
570     // Booleans are more expensive than uint256 or any type that takes up a full
571     // word because each write operation emits an extra SLOAD to first read the
572     // slot's contents, replace the bits taken up by the boolean, and then write
573     // back. This is the compiler's defense against contract upgrades and
574     // pointer aliasing, and it cannot be disabled.
575 
576     // The values being non-zero value makes deployment a bit more expensive,
577     // but in exchange the refund on every call to nonReentrant will be lower in
578     // amount. Since refunds are capped to a percentage of the total
579     // transaction's gas, it is best to keep them low in cases like this one, to
580     // increase the likelihood of the full refund coming into effect.
581     uint256 private constant _NOT_ENTERED = 1;
582     uint256 private constant _ENTERED = 2;
583 
584     uint256 private _status;
585 
586     constructor () internal {
587         _status = _NOT_ENTERED;
588     }
589 
590     /**
591      * @dev Prevents a contract from calling itself, directly or indirectly.
592      * Calling a `nonReentrant` function from another `nonReentrant`
593      * function is not supported. It is possible to prevent this from happening
594      * by making the `nonReentrant` function external, and make it call a
595      * `private` function that does the actual work.
596      */
597     modifier nonReentrant() {
598         // On the first call to nonReentrant, _notEntered will be true
599         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
600 
601         // Any calls to nonReentrant after this point will fail
602         _status = _ENTERED;
603 
604         _;
605 
606         // By storing the original value once again, a refund is triggered (see
607         // https://eips.ethereum.org/EIPS/eip-2200)
608         _status = _NOT_ENTERED;
609     }
610 }
611 
612 // 
613 /**
614  * @dev Contract module which provides a basic access control mechanism, where
615  * there is an account (an owner) that can be granted exclusive access to
616  * specific functions.
617  *
618  * By default, the owner account will be the one that deploys the contract. This
619  * can later be changed with {transferOwnership}.
620  *
621  * This module is used through inheritance. It will make available the modifier
622  * `onlyOwner`, which can be applied to your functions to restrict their use to
623  * the owner.
624  */
625 contract Ownable is Context {
626     address private _owner;
627 
628     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
629 
630     /**
631      * @dev Initializes the contract setting the deployer as the initial owner.
632      */
633     constructor () internal {
634         address msgSender = _msgSender();
635         _owner = msgSender;
636         emit OwnershipTransferred(address(0), msgSender);
637     }
638 
639     /**
640      * @dev Returns the address of the current owner.
641      */
642     function owner() public view returns (address) {
643         return _owner;
644     }
645 
646     /**
647      * @dev Throws if called by any account other than the owner.
648      */
649     modifier onlyOwner() {
650         require(_owner == _msgSender(), "Ownable: caller is not the owner");
651         _;
652     }
653 
654     /**
655      * @dev Leaves the contract without owner. It will not be possible to call
656      * `onlyOwner` functions anymore. Can only be called by the current owner.
657      *
658      * NOTE: Renouncing ownership will leave the contract without an owner,
659      * thereby removing any functionality that is only available to the owner.
660      */
661     function renounceOwnership() public virtual onlyOwner {
662         emit OwnershipTransferred(_owner, address(0));
663         _owner = address(0);
664     }
665 
666     /**
667      * @dev Transfers ownership of the contract to a new account (`newOwner`).
668      * Can only be called by the current owner.
669      */
670     function transferOwnership(address newOwner) public virtual onlyOwner {
671         require(newOwner != address(0), "Ownable: new owner is the zero address");
672         emit OwnershipTransferred(_owner, newOwner);
673         _owner = newOwner;
674     }
675 }
676 
677 // 
678 /**
679  * @dev Interface of the ERC165 standard, as defined in the
680  * https://eips.ethereum.org/EIPS/eip-165[EIP].
681  *
682  * Implementers can declare support of contract interfaces, which can then be
683  * queried by others ({ERC165Checker}).
684  *
685  * For an implementation, see {ERC165}.
686  */
687 interface IERC165 {
688     /**
689      * @dev Returns true if this contract implements the interface defined by
690      * `interfaceId`. See the corresponding
691      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
692      * to learn more about how these ids are created.
693      *
694      * This function call must use less than 30 000 gas.
695      */
696     function supportsInterface(bytes4 interfaceId) external view returns (bool);
697 }
698 
699 // 
700 /**
701  * _Available since v3.1._
702  */
703 interface IERC1155Receiver is IERC165 {
704 
705     /**
706         @dev Handles the receipt of a single ERC1155 token type. This function is
707         called at the end of a `safeTransferFrom` after the balance has been updated.
708         To accept the transfer, this must return
709         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
710         (i.e. 0xf23a6e61, or its own function selector).
711         @param operator The address which initiated the transfer (i.e. msg.sender)
712         @param from The address which previously owned the token
713         @param id The ID of the token being transferred
714         @param value The amount of tokens being transferred
715         @param data Additional data with no specified format
716         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
717     */
718     function onERC1155Received(
719         address operator,
720         address from,
721         uint256 id,
722         uint256 value,
723         bytes calldata data
724     )
725         external
726         returns(bytes4);
727 
728     /**
729         @dev Handles the receipt of a multiple ERC1155 token types. This function
730         is called at the end of a `safeBatchTransferFrom` after the balances have
731         been updated. To accept the transfer(s), this must return
732         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
733         (i.e. 0xbc197c81, or its own function selector).
734         @param operator The address which initiated the batch transfer (i.e. msg.sender)
735         @param from The address which previously owned the token
736         @param ids An array containing ids of each token being transferred (order and length must match values array)
737         @param values An array containing amounts of each token being transferred (order and length must match ids array)
738         @param data Additional data with no specified format
739         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
740     */
741     function onERC1155BatchReceived(
742         address operator,
743         address from,
744         uint256[] calldata ids,
745         uint256[] calldata values,
746         bytes calldata data
747     )
748         external
749         returns(bytes4);
750 }
751 
752 // 
753 /**
754  * @dev Required interface of an ERC1155 compliant contract, as defined in the
755  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
756  *
757  * _Available since v3.1._
758  */
759 interface IERC1155 is IERC165 {
760     /**
761      * @dev Emitted when `value` tokens of token type `id` are transfered from `from` to `to` by `operator`.
762      */
763     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
764 
765     /**
766      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
767      * transfers.
768      */
769     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
770 
771     /**
772      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
773      * `approved`.
774      */
775     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
776 
777     /**
778      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
779      *
780      * If an {URI} event was emitted for `id`, the standard
781      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
782      * returned by {IERC1155MetadataURI-uri}.
783      */
784     event URI(string value, uint256 indexed id);
785 
786     /**
787      * @dev Returns the amount of tokens of token type `id` owned by `account`.
788      *
789      * Requirements:
790      *
791      * - `account` cannot be the zero address.
792      */
793     function balanceOf(address account, uint256 id) external view returns (uint256);
794 
795     /**
796      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
797      *
798      * Requirements:
799      *
800      * - `accounts` and `ids` must have the same length.
801      */
802     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
803 
804     /**
805      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
806      *
807      * Emits an {ApprovalForAll} event.
808      *
809      * Requirements:
810      *
811      * - `operator` cannot be the caller.
812      */
813     function setApprovalForAll(address operator, bool approved) external;
814 
815     /**
816      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
817      *
818      * See {setApprovalForAll}.
819      */
820     function isApprovedForAll(address account, address operator) external view returns (bool);
821 
822     /**
823      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
824      *
825      * Emits a {TransferSingle} event.
826      *
827      * Requirements:
828      *
829      * - `to` cannot be the zero address.
830      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
831      * - `from` must have a balance of tokens of type `id` of at least `amount`.
832      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
833      * acceptance magic value.
834      */
835     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
836 
837     /**
838      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
839      *
840      * Emits a {TransferBatch} event.
841      *
842      * Requirements:
843      *
844      * - `ids` and `amounts` must have the same length.
845      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
846      * acceptance magic value.
847      */
848     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
849 }
850 
851 /**
852  * @dev Implementation of Multi-Token Standard contract
853  */
854 contract ERC1155 is IERC165 {
855   using SafeMath for uint256;
856   using Address for address;
857 
858 
859   /***********************************|
860   |        Variables and Events       |
861   |__________________________________*/
862 
863   // onReceive function signatures
864   bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
865   bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
866 
867   // Objects balances
868   mapping (address => mapping(uint256 => uint256)) internal balances;
869 
870   // Operator Functions
871   mapping (address => mapping(address => bool)) internal operators;
872 
873   // Events
874   event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
875   event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
876   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
877   event URI(string _uri, uint256 indexed _id);
878 
879 
880   /***********************************|
881   |     Public Transfer Functions     |
882   |__________________________________*/
883 
884   /**
885    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
886    * @param _from    Source address
887    * @param _to      Target address
888    * @param _id      ID of the token type
889    * @param _amount  Transfered amount
890    * @param _data    Additional data with no specified format, sent in call to `_to`
891    */
892   function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
893     public
894   {
895     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
896     require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
897     // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
898 
899     _safeTransferFrom(_from, _to, _id, _amount);
900     _callonERC1155Received(_from, _to, _id, _amount, _data);
901   }
902 
903   /**
904    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
905    * @param _from     Source addresses
906    * @param _to       Target addresses
907    * @param _ids      IDs of each token type
908    * @param _amounts  Transfer amounts per token type
909    * @param _data     Additional data with no specified format, sent in call to `_to`
910    */
911   function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
912     public
913   {
914     // Requirements
915     require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
916     require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
917 
918     _safeBatchTransferFrom(_from, _to, _ids, _amounts);
919     _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
920   }
921 
922 
923   /***********************************|
924   |    Internal Transfer Functions    |
925   |__________________________________*/
926 
927   /**
928    * @notice Transfers amount amount of an _id from the _from address to the _to address specified
929    * @param _from    Source address
930    * @param _to      Target address
931    * @param _id      ID of the token type
932    * @param _amount  Transfered amount
933    */
934   function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
935     internal
936   {
937     // Update balances
938     balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
939     balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
940 
941     // Emit event
942     emit TransferSingle(msg.sender, _from, _to, _id, _amount);
943   }
944 
945   /**
946    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
947    */
948   function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
949     internal
950   {
951     // Check if recipient is contract
952     if (_to.isContract()) {
953       bytes4 retval = IERC1155Receiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
954       require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
955     }
956   }
957 
958   /**
959    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
960    * @param _from     Source addresses
961    * @param _to       Target addresses
962    * @param _ids      IDs of each token type
963    * @param _amounts  Transfer amounts per token type
964    */
965   function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
966     internal
967   {
968     require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
969 
970     // Number of transfer to execute
971     uint256 nTransfer = _ids.length;
972 
973     // Executing all transfers
974     for (uint256 i = 0; i < nTransfer; i++) {
975       // Update storage balance of previous bin
976       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
977       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
978     }
979 
980     // Emit event
981     emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
982   }
983 
984   /**
985    * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
986    */
987   function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
988     internal
989   {
990     // Pass data if recipient is contract
991     if (_to.isContract()) {
992       bytes4 retval = IERC1155Receiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
993       require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
994     }
995   }
996 
997 
998   /***********************************|
999   |         Operator Functions        |
1000   |__________________________________*/
1001 
1002   /**
1003    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
1004    * @param _operator  Address to add to the set of authorized operators
1005    * @param _approved  True if the operator is approved, false to revoke approval
1006    */
1007   function setApprovalForAll(address _operator, bool _approved)
1008     external
1009   {
1010     // Update operator status
1011     operators[msg.sender][_operator] = _approved;
1012     emit ApprovalForAll(msg.sender, _operator, _approved);
1013   }
1014 
1015   /**
1016    * @notice Queries the approval status of an operator for a given owner
1017    * @param _owner     The owner of the Tokens
1018    * @param _operator  Address of authorized operator
1019    * @return isOperator True if the operator is approved, false if not
1020    */
1021   function isApprovedForAll(address _owner, address _operator)
1022     public virtual view returns (bool isOperator)
1023   {
1024     return operators[_owner][_operator];
1025   }
1026 
1027 
1028   /***********************************|
1029   |         Balance Functions         |
1030   |__________________________________*/
1031 
1032   /**
1033    * @notice Get the balance of an account's Tokens
1034    * @param _owner  The address of the token holder
1035    * @param _id     ID of the Token
1036    * @return The _owner's balance of the Token type requested
1037    */
1038   function balanceOf(address _owner, uint256 _id)
1039     public view returns (uint256)
1040   {
1041     return balances[_owner][_id];
1042   }
1043 
1044   /**
1045    * @notice Get the balance of multiple account/token pairs
1046    * @param _owners The addresses of the token holders
1047    * @param _ids    ID of the Tokens
1048    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
1049    */
1050   function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
1051     public view returns (uint256[] memory)
1052   {
1053     require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
1054 
1055     // Variables
1056     uint256[] memory batchBalances = new uint256[](_owners.length);
1057 
1058     // Iterate over each owner and token ID
1059     for (uint256 i = 0; i < _owners.length; i++) {
1060       batchBalances[i] = balances[_owners[i]][_ids[i]];
1061     }
1062 
1063     return batchBalances;
1064   }
1065 
1066 
1067   /***********************************|
1068   |          ERC165 Functions         |
1069   |__________________________________*/
1070 
1071   /**
1072    * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
1073    */
1074   bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
1075 
1076   /**
1077    * INTERFACE_SIGNATURE_ERC1155 =
1078    * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
1079    * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
1080    * bytes4(keccak256("balanceOf(address,uint256)")) ^
1081    * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
1082    * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
1083    * bytes4(keccak256("isApprovedForAll(address,address)"));
1084    */
1085   bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
1086 
1087   /**
1088    * @notice Query if a contract implements an interface
1089    * @param _interfaceID  The interface identifier, as specified in ERC-165
1090    * @return `true` if the contract implements `_interfaceID` and
1091    */
1092   function supportsInterface(bytes4 _interfaceID) external override view returns (bool) {
1093     if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
1094         _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
1095       return true;
1096     }
1097     return false;
1098   }
1099 }
1100 
1101 /**
1102  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
1103  *      a parent contract to be executed as they are `internal` functions
1104  */
1105 contract ERC1155MintBurn is ERC1155 {
1106 
1107   /****************************************|
1108   |            Minting Functions           |
1109   |_______________________________________*/
1110 
1111   /**
1112    * @notice Mint _amount of tokens of a given id
1113    * @param _to      The address to mint tokens to
1114    * @param _id      Token id to mint
1115    * @param _amount  The amount to be minted
1116    * @param _data    Data to pass if receiver is contract
1117    */
1118   function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
1119     internal
1120   {
1121     // Add _amount
1122     balances[_to][_id] = balances[_to][_id].add(_amount);
1123 
1124     // Emit event
1125     emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
1126 
1127     // Calling onReceive method if recipient is contract
1128     _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
1129   }
1130 
1131   /**
1132    * @notice Mint tokens for each ids in _ids
1133    * @param _to       The address to mint tokens to
1134    * @param _ids      Array of ids to mint
1135    * @param _amounts  Array of amount of tokens to mint per id
1136    * @param _data    Data to pass if receiver is contract
1137    */
1138   function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
1139     internal
1140   {
1141     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
1142 
1143     // Number of mints to execute
1144     uint256 nMint = _ids.length;
1145 
1146      // Executing all minting
1147     for (uint256 i = 0; i < nMint; i++) {
1148       // Update storage balance
1149       balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1150     }
1151 
1152     // Emit batch mint event
1153     emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
1154 
1155     // Calling onReceive method if recipient is contract
1156     _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
1157   }
1158 
1159 
1160   /****************************************|
1161   |            Burning Functions           |
1162   |_______________________________________*/
1163 
1164   /**
1165    * @notice Burn _amount of tokens of a given token id
1166    * @param _from    The address to burn tokens from
1167    * @param _id      Token id to burn
1168    * @param _amount  The amount to be burned
1169    */
1170   function _burn(address _from, uint256 _id, uint256 _amount)
1171     internal
1172   {
1173     //Substract _amount
1174     balances[_from][_id] = balances[_from][_id].sub(_amount);
1175 
1176     // Emit event
1177     emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
1178   }
1179 
1180   /**
1181    * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
1182    * @param _from     The address to burn tokens from
1183    * @param _ids      Array of token ids to burn
1184    * @param _amounts  Array of the amount to be burned
1185    */
1186   function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
1187     internal
1188   {
1189     require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
1190 
1191     // Number of mints to execute
1192     uint256 nBurn = _ids.length;
1193 
1194      // Executing all minting
1195     for (uint256 i = 0; i < nBurn; i++) {
1196       // Update storage balance
1197       balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
1198     }
1199 
1200     // Emit batch mint event
1201     emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
1202   }
1203 
1204 }
1205 
1206 /**
1207  * @notice Contract that handles metadata related methods.
1208  * @dev Methods assume a deterministic generation of URI based on token IDs.
1209  *      Methods also assume that URI uses hex representation of token IDs.
1210  */
1211 contract ERC1155Metadata {
1212 
1213   // URI's default URI prefix
1214   string internal baseMetadataURI;
1215   event URI(string _uri, uint256 indexed _id);
1216 
1217 
1218   /***********************************|
1219   |     Metadata Public Function s    |
1220   |__________________________________*/
1221 
1222   /**
1223    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
1224    * @dev URIs are defined in RFC 3986.
1225    *      URIs are assumed to be deterministically generated based on token ID
1226    *      Token IDs are assumed to be represented in their hex format in URIs
1227    * @return URI string
1228    */
1229   function uri(uint256 _id) public virtual view returns (string memory) {
1230     return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
1231   }
1232 
1233 
1234   /***********************************|
1235   |    Metadata Internal Functions    |
1236   |__________________________________*/
1237 
1238   /**
1239    * @notice Will emit default URI log event for corresponding token _id
1240    * @param _tokenIDs Array of IDs of tokens to log default URI
1241    */
1242   function _logURIs(uint256[] memory _tokenIDs) internal {
1243     string memory baseURL = baseMetadataURI;
1244     string memory tokenURI;
1245 
1246     for (uint256 i = 0; i < _tokenIDs.length; i++) {
1247       tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
1248       emit URI(tokenURI, _tokenIDs[i]);
1249     }
1250   }
1251 
1252   /**
1253    * @notice Will emit a specific URI log event for corresponding token
1254    * @param _tokenIDs IDs of the token corresponding to the _uris logged
1255    * @param _URIs    The URIs of the specified _tokenIDs
1256    */
1257   function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
1258     require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
1259     for (uint256 i = 0; i < _tokenIDs.length; i++) {
1260       emit URI(_URIs[i], _tokenIDs[i]);
1261     }
1262   }
1263 
1264   /**
1265    * @notice Will update the base URL of token's URI
1266    * @param _newBaseMetadataURI New base URL of token's URI
1267    */
1268   function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
1269     baseMetadataURI = _newBaseMetadataURI;
1270   }
1271 
1272 
1273   /***********************************|
1274   |    Utility Internal Functions     |
1275   |__________________________________*/
1276 
1277   /**
1278    * @notice Convert uint256 to string
1279    * @param _i Unsigned integer to convert to string
1280    */
1281   function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1282     if (_i == 0) {
1283       return "0";
1284     }
1285 
1286     uint256 j = _i;
1287     uint256 ii = _i;
1288     uint256 len;
1289 
1290     // Get number of bytes
1291     while (j != 0) {
1292       len++;
1293       j /= 10;
1294     }
1295 
1296     bytes memory bstr = new bytes(len);
1297     uint256 k = len - 1;
1298 
1299     // Get each individual ASCII
1300     while (ii != 0) {
1301       bstr[k--] = byte(uint8(48 + ii % 10));
1302       ii /= 10;
1303     }
1304 
1305     // Convert to string
1306     return string(bstr);
1307   }
1308 
1309 }
1310 
1311 /**
1312  * @title Roles
1313  * @dev Library for managing addresses assigned to a Role.
1314  */
1315 library Roles {
1316     struct Role {
1317         mapping (address => bool) bearer;
1318     }
1319 
1320     /**
1321      * @dev Give an account access to this role.
1322      */
1323     function add(Role storage role, address account) internal {
1324         require(!has(role, account), "Roles: account already has role");
1325         role.bearer[account] = true;
1326     }
1327 
1328     /**
1329      * @dev Remove an account's access to this role.
1330      */
1331     function remove(Role storage role, address account) internal {
1332         require(has(role, account), "Roles: account does not have role");
1333         role.bearer[account] = false;
1334     }
1335 
1336     /**
1337      * @dev Check if an account has this role.
1338      * @return bool
1339      */
1340     function has(Role storage role, address account) internal view returns (bool) {
1341         require(account != address(0), "Roles: account is the zero address");
1342         return role.bearer[account];
1343     }
1344 }
1345 
1346 contract MinterRole is Context {
1347     using Roles for Roles.Role;
1348 
1349     event MinterAdded(address indexed account);
1350     event MinterRemoved(address indexed account);
1351 
1352     Roles.Role private _minters;
1353 
1354     constructor () internal {
1355         _addMinter(_msgSender());
1356     }
1357 
1358     modifier onlyMinter() {
1359         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1360         _;
1361     }
1362 
1363     function isMinter(address account) public view returns (bool) {
1364         return _minters.has(account);
1365     }
1366 
1367     function addMinter(address account) public onlyMinter {
1368         _addMinter(account);
1369     }
1370 
1371     function renounceMinter() public {
1372         _removeMinter(_msgSender());
1373     }
1374 
1375     function _addMinter(address account) internal {
1376         _minters.add(account);
1377         emit MinterAdded(account);
1378     }
1379 
1380     function _removeMinter(address account) internal {
1381         _minters.remove(account);
1382         emit MinterRemoved(account);
1383     }
1384 }
1385 
1386 /**
1387  * @title WhitelistAdminRole
1388  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
1389  */
1390 contract WhitelistAdminRole is Context {
1391     using Roles for Roles.Role;
1392 
1393     event WhitelistAdminAdded(address indexed account);
1394     event WhitelistAdminRemoved(address indexed account);
1395 
1396     Roles.Role private _whitelistAdmins;
1397 
1398     constructor () internal {
1399         _addWhitelistAdmin(_msgSender());
1400     }
1401 
1402     modifier onlyWhitelistAdmin() {
1403         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
1404         _;
1405     }
1406 
1407     function isWhitelistAdmin(address account) public view returns (bool) {
1408         return _whitelistAdmins.has(account);
1409     }
1410 
1411     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
1412         _addWhitelistAdmin(account);
1413     }
1414 
1415     function renounceWhitelistAdmin() public {
1416         _removeWhitelistAdmin(_msgSender());
1417     }
1418 
1419     function _addWhitelistAdmin(address account) internal {
1420         _whitelistAdmins.add(account);
1421         emit WhitelistAdminAdded(account);
1422     }
1423 
1424     function _removeWhitelistAdmin(address account) internal {
1425         _whitelistAdmins.remove(account);
1426         emit WhitelistAdminRemoved(account);
1427     }
1428 }
1429 
1430 // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1431 library Strings {
1432 	function strConcat(
1433 		string memory _a,
1434 		string memory _b,
1435 		string memory _c,
1436 		string memory _d,
1437 		string memory _e
1438 	) internal pure returns (string memory) {
1439 		bytes memory _ba = bytes(_a);
1440 		bytes memory _bb = bytes(_b);
1441 		bytes memory _bc = bytes(_c);
1442 		bytes memory _bd = bytes(_d);
1443 		bytes memory _be = bytes(_e);
1444 		string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1445 		bytes memory babcde = bytes(abcde);
1446 		uint256 k = 0;
1447 		for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1448 		for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1449 		for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1450 		for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1451 		for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1452 		return string(babcde);
1453 	}
1454 
1455 	function strConcat(
1456 		string memory _a,
1457 		string memory _b,
1458 		string memory _c,
1459 		string memory _d
1460 	) internal pure returns (string memory) {
1461 		return strConcat(_a, _b, _c, _d, "");
1462 	}
1463 
1464 	function strConcat(
1465 		string memory _a,
1466 		string memory _b,
1467 		string memory _c
1468 	) internal pure returns (string memory) {
1469 		return strConcat(_a, _b, _c, "", "");
1470 	}
1471 
1472 	function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1473 		return strConcat(_a, _b, "", "", "");
1474 	}
1475 
1476 	function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1477 		if (_i == 0) {
1478 			return "0";
1479 		}
1480 		uint256 j = _i;
1481 		uint256 len;
1482 		while (j != 0) {
1483 			len++;
1484 			j /= 10;
1485 		}
1486 		bytes memory bstr = new bytes(len);
1487 		uint256 k = len - 1;
1488 		while (_i != 0) {
1489 			bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1490 			_i /= 10;
1491 		}
1492 		return string(bstr);
1493 	}
1494 }
1495 
1496 contract OwnableDelegateProxy {}
1497 
1498 contract ProxyRegistry {
1499 	mapping(address => OwnableDelegateProxy) public proxies;
1500 }
1501 
1502 /**
1503  * @title ERC1155Tradable
1504  * ERC1155Tradable - ERC1155 contract that whitelists an operator address, 
1505  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1506   like _exists(), name(), symbol(), and totalSupply()
1507  */
1508 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1509 	using Strings for string;
1510 
1511 	address proxyRegistryAddress;
1512 	uint256 private _currentTokenID = 0;
1513 	mapping(uint256 => address) public creators;
1514 	mapping(uint256 => uint256) public tokenSupply;
1515 	mapping(uint256 => uint256) public tokenMaxSupply;
1516 	// Contract name
1517 	string public name;
1518 	// Contract symbol
1519 	string public symbol;
1520 
1521 	constructor(
1522 		string memory _name,
1523 		string memory _symbol,
1524 		address _proxyRegistryAddress
1525 	) public {
1526 		name = _name;
1527 		symbol = _symbol;
1528 		proxyRegistryAddress = _proxyRegistryAddress;
1529 	}
1530 
1531 	function removeWhitelistAdmin(address account) public onlyOwner {
1532 		_removeWhitelistAdmin(account);
1533 	}
1534 
1535 	function removeMinter(address account) public onlyOwner {
1536 		_removeMinter(account);
1537 	}
1538 
1539 	function uri(uint256 _id) public override view returns (string memory) {
1540 		require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1541 		return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1542 	}
1543 
1544 	/**
1545 	 * @dev Returns the total quantity for a token ID
1546 	 * @param _id uint256 ID of the token to query
1547 	 * @return amount of token in existence
1548 	 */
1549 	function totalSupply(uint256 _id) public view returns (uint256) {
1550 		return tokenSupply[_id];
1551 	}
1552 
1553 	/**
1554 	 * @dev Returns the max quantity for a token ID
1555 	 * @param _id uint256 ID of the token to query
1556 	 * @return amount of token in existence
1557 	 */
1558 	function maxSupply(uint256 _id) public view returns (uint256) {
1559 		return tokenMaxSupply[_id];
1560 	}
1561 
1562 	/**
1563 	 * @dev Will update the base URL of token's URI
1564 	 * @param _newBaseMetadataURI New base URL of token's URI
1565 	 */
1566 	function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1567 		_setBaseMetadataURI(_newBaseMetadataURI);
1568 	}
1569 
1570 	/**
1571 	 * @dev Creates a new token type and assigns _initialSupply to an address
1572 	 * @param _maxSupply max supply allowed
1573 	 * @param _initialSupply Optional amount to supply the first owner
1574 	 * @param _uri Optional URI for this token type
1575 	 * @param _data Optional data to pass if receiver is contract
1576 	 * @return tokenId The newly created token ID
1577 	 */
1578 	function create(
1579 		uint256 _maxSupply,
1580 		uint256 _initialSupply,
1581 		string calldata _uri,
1582 		bytes calldata _data
1583 	) external onlyWhitelistAdmin returns (uint256 tokenId) {
1584 		require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1585 		uint256 _id = _getNextTokenID();
1586 		_incrementTokenTypeId();
1587 		creators[_id] = msg.sender;
1588 
1589 		if (bytes(_uri).length > 0) {
1590 			emit URI(_uri, _id);
1591 		}
1592 
1593 		if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1594 		tokenSupply[_id] = _initialSupply;
1595 		tokenMaxSupply[_id] = _maxSupply;
1596 		return _id;
1597 	}
1598 
1599 	/**
1600 	 * @dev Mints some amount of tokens to an address
1601 	 * @param _to          Address of the future owner of the token
1602 	 * @param _id          Token ID to mint
1603 	 * @param _quantity    Amount of tokens to mint
1604 	 * @param _data        Data to pass if receiver is contract
1605 	 */
1606 	function mint(
1607 		address _to,
1608 		uint256 _id,
1609 		uint256 _quantity,
1610 		bytes memory _data
1611 	) public onlyMinter {
1612 		uint256 tokenId = _id;
1613 		require(tokenSupply[tokenId] < tokenMaxSupply[tokenId], "Max supply reached");
1614 		_mint(_to, _id, _quantity, _data);
1615 		tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1616 	}
1617 
1618 	/**
1619 	 * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1620 	 */
1621 	function isApprovedForAll(address _owner, address _operator) public override view returns (bool isOperator) {
1622 		// Whitelist OpenSea proxy contract for easy trading.
1623 		ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1624 		if (address(proxyRegistry.proxies(_owner)) == _operator) {
1625 			return true;
1626 		}
1627 
1628 		return ERC1155.isApprovedForAll(_owner, _operator);
1629 	}
1630 
1631 	/**
1632 	 * @dev Returns whether the specified token exists by checking to see if it has a creator
1633 	 * @param _id uint256 ID of the token to query the existence of
1634 	 * @return bool whether the token exists
1635 	 */
1636 	function _exists(uint256 _id) internal view returns (bool) {
1637 		return creators[_id] != address(0);
1638 	}
1639 
1640 	/**
1641 	 * @dev calculates the next token ID based on value of _currentTokenID
1642 	 * @return uint256 for the next token ID
1643 	 */
1644 	function _getNextTokenID() private view returns (uint256) {
1645 		return _currentTokenID.add(1);
1646 	}
1647 
1648 	/**
1649 	 * @dev increments the value of _currentTokenID
1650 	 */
1651 	function _incrementTokenTypeId() private {
1652 		_currentTokenID++;
1653 	}
1654 }
1655 
1656 contract ChadletsGenesisPool is ReentrancyGuard, Pausable, Ownable {
1657     using SafeMath for uint256;
1658     using SafeERC20 for IERC20;
1659 
1660 	ERC1155Tradable public chadsLtdAddress;
1661     IERC20 public stakingToken;
1662 
1663 	mapping(address => uint256) public lastUpdateTime;
1664 	mapping(address => uint256) public points;
1665 	mapping(uint256 => uint256) public cards;
1666 
1667 	uint256 public maxChadletsPerDay = 69;
1668 
1669 	uint256 public maxStakingTokens = 1104;
1670 	
1671     uint256 private _totalSupply;
1672     mapping(address => uint256) private _balances;	
1673 
1674 	event CardAdded(uint256 card, uint256 points);
1675 	event Staked(address indexed user, uint256 amount);
1676 	event Withdrawn(address indexed user, uint256 amount);
1677 	event Redeemed(address indexed user, uint256 amount);
1678 
1679 	modifier updateReward(address account) {
1680 		if (account != address(0)) {
1681 			points[account] = earned(account);
1682 			lastUpdateTime[account] = block.timestamp;
1683 		}
1684 		_;
1685 	}
1686 
1687 	constructor(ERC1155Tradable _chadsLtdAddress, IERC20 _stakingToken) public {
1688 		chadsLtdAddress = _chadsLtdAddress;
1689         stakingToken = _stakingToken;
1690         _pause();
1691 	}
1692 
1693     function totalSupply() public view returns (uint256) {
1694         return _totalSupply;
1695     }
1696 
1697     function balanceOf(address account) public view returns (uint256) {
1698         return _balances[account];
1699     }
1700 
1701     function unpause() external onlyOwner {
1702         super._unpause();
1703     }
1704 
1705 	function setMaxStakingTokens(uint256 _maxStakingTokens) external onlyOwner {
1706 		maxStakingTokens = _maxStakingTokens;
1707 	}
1708 
1709 	function setMaxChadletsPerDay(uint256 _maxChadletsPerDay) external onlyOwner {
1710 		maxChadletsPerDay = _maxChadletsPerDay;
1711 	}
1712 
1713 	function setPoints(address _address, uint256 _points) external onlyOwner {
1714 		points[_address] = _points;
1715 	}
1716 
1717 	function addCard(uint256 cardId, uint256 amount) public onlyOwner {
1718 		cards[cardId] = amount;
1719 		emit CardAdded(cardId, amount);
1720 	}
1721 
1722 	function earned(address account) public view returns (uint256) {
1723 		uint256 blockTime = block.timestamp;
1724 		return
1725 			points[account].add(
1726 				blockTime.sub(lastUpdateTime[account])
1727 				.mul(1e18)
1728 				.div(86400)
1729 				.mul((balanceOf(account).mul(maxChadletsPerDay).div(maxStakingTokens))	// max 69e18 (1104e18 * (69/1104)) per day
1730 				.div(1e18))
1731 			);
1732 	}
1733 
1734     function stake(uint256 amount) external nonReentrant whenNotPaused updateReward(msg.sender) {
1735         require(amount > 0, "Cannot stake 0");
1736 		require(amount.add(balanceOf(msg.sender)) <= (maxStakingTokens * 1e18), "Cannot stake more than maxStakingTokens");
1737         _totalSupply = _totalSupply.add(amount);
1738         _balances[msg.sender] = _balances[msg.sender].add(amount);
1739         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1740         emit Staked(msg.sender, amount);
1741     }
1742 
1743     function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
1744         require(amount > 0, "Cannot withdraw 0");
1745         _totalSupply = _totalSupply.sub(amount);
1746         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1747         stakingToken.safeTransfer(msg.sender, amount);
1748         emit Withdrawn(msg.sender, amount);
1749     }
1750 
1751 	function exit() external {
1752 		withdraw(balanceOf(msg.sender));
1753 	}
1754 
1755 	function redeem(uint256 card) public updateReward(msg.sender) {
1756 		require(cards[card] != 0, "Card not found");
1757 		require(points[msg.sender] >= cards[card], "Not enough points to redeem for card");
1758 		require(chadsLtdAddress.totalSupply(card) < chadsLtdAddress.maxSupply(card), "Max cards minted");
1759 
1760 		points[msg.sender] = points[msg.sender].sub(cards[card]);
1761 		chadsLtdAddress.mint(msg.sender, card, 1, "");
1762 		emit Redeemed(msg.sender, cards[card]);
1763 	}
1764 }